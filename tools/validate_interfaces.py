"""Verify Intel-generated external interfaces with GNU Fortran and optionally ifx.

Check compiler symbol signatures, reject invalid calls, and run the existing
numerical mains both with their original declarations and with module imports.
All generated callers, objects, and executables stay in temporary directories.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile

from generate_interfaces import ROOT, MODULE, METADATA, compiler_environment, procedure_blocks, sha
from validate_explicit_typing import symbols
from validate_sources import check_result, test_programs
from callback_interfaces import abstract_interfaces, enrich, strip_contracts, BINDINGS


def command_run(command, folder, env=None, timeout=180, expect_success=True):
    result = subprocess.run(command, cwd=folder, env=env, capture_output=True, text=True,
                            stdin=subprocess.DEVNULL, timeout=timeout)
    if expect_success and result.returncode:
        raise RuntimeError(f'Command failed: {command}\n{result.stdout}\n{result.stderr}')
    return result


def attributes(record):
    match = re.fullmatch(r'attributes:\s*\((.*)\)', record.get('attributes', ''))
    return set(match[1].split()) if match else set()


def signature(record):
    attrs = attributes(record)
    relevant = {'VARIABLE', 'PROCEDURE', 'DIMENSION', 'OPTIONAL', 'POINTER', 'ALLOCATABLE',
                'VALUE', 'TARGET', 'CONTIGUOUS', 'VOLATILE', 'ASYNCHRONOUS'}
    # DUMMY-PROC and inferred call-graph attributes describe executable use.
    # A declared, untyped EXTERNAL under IMPLICIT NONE is a subroutine callback.
    category = None
    if 'PROCEDURE' in attrs:
        category = 'SUBROUTINE' if record.get('type spec') == 'type spec : (UNKNOWN 0)' else 'FUNCTION'
    return {'type': record.get('type spec'), 'shape': record.get('Array spec'),
            'arguments': record.get('Formal arglist'), 'category': category,
            'attributes': sorted(attrs & relevant),
            'dummy': sorted(a for a in attrs if a == 'DUMMY' or a.startswith('DUMMY('))}


def compare_signatures(original, generated):
    if original.keys() != generated.keys():
        raise ValueError('Procedure inventory differs')
    count = 0
    differences = {}
    for scope, records in original.items():
        for name, record in records.items():
            if name != scope.lower() and not any(a == 'DUMMY' or a.startswith('DUMMY(') for a in attributes(record)):
                continue
            count += 1
            before = signature(record)
            after = signature(generated[scope].get(name, {}))
            if before != after:
                differences[scope + ':' + name] = {'source': before, 'interface': after}
    if differences:
        raise ValueError('Interface characteristics differ:\n' + json.dumps(differences, indent=2))
    return count


def verify_signatures(compiler, folder):
    source, module = (ROOT / 'nswc.f90').read_bytes(), MODULE.read_bytes()
    metadata = json.loads(METADATA.read_text())
    if metadata['source_sha256'] != sha(source) or metadata['module_sha256'] != sha(module):
        raise ValueError('Interface generation metadata is stale')
    if metadata['callback_review_sha256'] != sha((ROOT / 'tools/callback_interfaces.py').read_bytes()):
        raise ValueError('Callback review metadata is stale')
    if abstract_interfaces() not in module.decode('ascii'):
        raise ValueError('Callback definitions differ from reviewed contracts')
    definitions = procedure_blocks(source.decode('ascii'))
    interfaces = procedure_blocks(module.decode('ascii'))
    if len(definitions) != 1062 or definitions.keys() != interfaces.keys() or metadata['procedures'] != 1062:
        raise ValueError('Expected all 1062 procedure interfaces')
    stub = Path(folder) / 'interface_stubs.f90'
    stripped = {name: strip_contracts(body) for name, body in interfaces.items()}
    for name, body in stripped.items():
        if enrich(name, body) != interfaces[name]:
            raise ValueError('Callback interface differs from review: ' + name)
    stub.write_text(''.join(stripped.values()), encoding='ascii', newline='\n')
    inventories = []
    for path, flags in [(ROOT / 'nswc.f90', ['-std=legacy', '-fallow-argument-mismatch']),
                        (stub, ['-std=f2008', '-pedantic-errors'])]:
        result = command_run([compiler, '-fsyntax-only', '-fdump-fortran-original', *flags, str(path)], folder)
        inventories.append(symbols(result.stdout))
    count = compare_signatures(*inventories)
    print(f'Confirmed {count} procedure, argument, and function-result records across 1062 interfaces.', flush=True)
    return set(interfaces)


def module_caller(text, library_names):
    """Replace this suite's local library interfaces with USE ... ONLY imports."""
    names, kept, depth, preserve = set(), [], 0, False
    for line in text.splitlines(keepends=True):
        code = line.split('!', 1)[0].strip()
        if re.match(r'^(?:abstract\s+)?interface\b', code, re.I):
            if depth == 0:
                preserve = bool(re.match(r'^abstract\b', code, re.I))
            depth += 1
            if preserve:
                kept.append(line)
            continue
        if re.match(r'^end\s*interface\b', code, re.I):
            if preserve:
                kept.append(line)
            depth -= 1
            if depth < 0:
                raise ValueError('Unbalanced interface')
            if depth == 0:
                preserve = False
            continue
        if depth:
            if preserve:
                kept.append(line)
                continue
            match = re.match(r'^(?:(?:double\s+precision|real|integer|complex|logical)\s+)?(?:subroutine|function)\s+(\w+)', code, re.I)
            if depth == 1 and match:
                name = match[1].upper()
                if name not in library_names:
                    raise ValueError(f'Test interface is not a library procedure: {name}')
                names.add(name)
            continue
        if re.match(r'^(?:(?:double\s+precision|real|integer|complex|logical)\s*,\s*)?external\b', code, re.I):
            match = re.match(r'^(.*?\bexternal\b\s*(?:::)?\s*)(.*)$', code, re.I)
            if not match:
                raise ValueError('Unsupported external declaration')
            remaining = []
            for name in match[2].split(','):
                name = name.strip()
                if name.upper() in library_names:
                    names.add(name.upper())
                else:
                    remaining.append(name)
            if not remaining:
                continue
            if len(remaining) != len(match[2].split(',')):
                line = '  ' + match[1] + ', '.join(remaining) + '\n'
        kept.append(line)
    if depth or not names:
        raise ValueError('Unbalanced interfaces or no library imports')
    index = next(i for i, line in enumerate(kept) if re.match(r'^\s*program\s+', line, re.I)) + 1
    imports = ['  use nswc_interfaces, only: &\n']
    ordered = sorted(names)
    for i in range(0, len(ordered), 6):
        imports.append('    ' + ', '.join(ordered[i:i + 6]) + (', &\n' if i + 6 < len(ordered) else '\n'))
    return ''.join(kept[:index] + imports + kept[index:])


PROBE_PREFIX = '''program interface_probe
use nswc_interfaces, only: scopy, sgefa, dqdcrt, qags, ode
implicit none
real :: x(2),y(2),scalar,a(1,1),sr(2),work(400),result,error
double precision :: coeff(3),zr(2),zi(2)
integer :: ip(1),info,neval,ier,last,iw(100)
'''
PROBES = [
    ('integer type', 'call scopy(1,x,1,y,1)', 'call scopy(1.0,x,1,y,1)'),
    ('array rank', 'call scopy(1,x,1,y,1)', 'call scopy(1,x,1,scalar,1)'),
    ('output constant', 'call sgefa(a,1,1,ip,info)', 'call sgefa(a,1,1,ip,0)'),
    ('real precision', 'call dqdcrt(coeff,zr,zi)', 'call dqdcrt(coeff,sr,zi)'),
    ('missing argument', 'call scopy(1,x,1,y,1)', 'call scopy(1,x,1,y)'),
    ('callback result', 'call qags(single_f,0.,1.,1e-5,1e-5,result,error,neval,ier,100,400,last,iw,work)',
                        'call qags(double_f,0.,1.,1e-5,1e-5,result,error,neval,ier,100,400,last,iw,work)')]
for label, callback in [('arity', 'no_argument'), ('parameter type', 'double_argument'),
                        ('parameter rank', 'array_argument'), ('parameter intent', 'no_intent')]:
    good = 'call qags(single_f,0.,1.,1e-5,1e-5,result,error,neval,ier,100,400,last,iw,work)'
    PROBES.append(('callback ' + label, good, good.replace('single_f', callback)))
PROBES.append(('callback array descriptor',
               'call ode(rhs,1,y,scalar,1.,error,result,info,work,iw)',
               'call ode(descriptor_rhs,1,y,scalar,1.,error,result,info,work,iw)'))
PROBE_SUFFIX = '''
contains
real function single_f(t)
real,intent(in)::t
single_f=t*t
end function
double precision function double_f(t)
real,intent(in)::t
double_f=dble(t*t)
end function
real function no_argument()
no_argument=1.
end function
real function double_argument(t)
double precision,intent(in)::t
double_argument=real(t)
end function
real function array_argument(t)
real,intent(in)::t(*)
array_argument=t(1)
end function
real function no_intent(t)
real::t
no_intent=t
end function
subroutine rhs(t,y,yp)
real,intent(in)::t,y(*)
real,intent(out)::yp(*)
yp(1)=y(1)
end subroutine
subroutine descriptor_rhs(t,y,yp)
real,intent(in)::t,y(:)
real,intent(out)::yp(*)
yp(1)=y(1)
end subroutine
end program
'''


def verify_calls(compiler, folder, library_names, intel=False, env=None, sources=('nswc.f90',)):
    folder = Path(folder)
    if intel:
        compile_flags = ['/nologo', '/Od', '/fp:strict', '/warn:interfaces']
        obj = lambda path: '/object:' + str(path)
        exe = lambda path: '/exe:' + str(path)
        command_run([compiler, *compile_flags, '/c', str(MODULE), obj(folder / 'interfaces.obj')], folder, env)
    else:
        compile_flags = ['-std=f2008', '-pedantic-errors']
        command_run([compiler, *compile_flags, '-c', str(MODULE), '-o', str(folder / 'interfaces.o')], folder)
    for label, good, bad in PROBES:
        for valid, call in [(True, good), (False, bad)]:
            probe = folder / 'probe.f90'
            probe.write_text(PROBE_PREFIX + call + '\n' + PROBE_SUFFIX, newline='\n')
            command = ([compiler, *compile_flags, '/c', str(probe), obj(folder / 'probe.obj')] if intel
                       else [compiler, *compile_flags, '-c', str(probe), '-o', str(folder / 'probe.o')])
            result = command_run(command, folder, env, expect_success=False)
            if (result.returncode == 0) != valid:
                raise RuntimeError(f'Unexpected probe result ({label}, valid={valid}):\n{result.stdout}\n{result.stderr}')
        print(f'PASS: {"ifx" if intel else "GNU"} rejects invalid {label}.', flush=True)
    passed = 0
    for source in sources:
        library = folder / ('library.obj' if intel else 'library.o')
        if intel:
            # The documented COMPB/PPADD mismatch remains in the implementation.
            command = [compiler, '/nologo', '/Od', '/fp:strict', '/warn:nointerfaces', '/c', str(ROOT / source), obj(library)]
        else:
            command = [compiler, '-c', '-std=legacy', '-fallow-argument-mismatch', str(ROOT / source), '-o', str(library)]
        command_run(command, folder, env, timeout=300)
        for path in test_programs():
            baseline = {}
            for imported in (False, True):
                caller = path
                if imported:
                    caller = folder / path.name
                    caller.write_text(module_caller(path.read_text(), library_names), newline='\n')
                executable = folder / 'test.exe'
                command = ([compiler, *compile_flags, '/fpe:0', str(caller), str(library), exe(executable)] if intel
                           else [compiler, '-std=legacy', '-ffpe-trap=invalid,zero,overflow', str(caller), str(library), '-o', str(executable)])
                command_run(command, folder, env, timeout=60)
                result = command_run([str(executable)], folder, env, timeout=30)
                check_result(result, path.stem, baseline)
                baseline[path.stem] = result.stdout
                passed += 1
            print(f'PASS: {"ifx" if intel else "GNU"} / {source} / {path.stem}: original and module calls agree.', flush=True)
    print(f'{passed} numerical runs passed with {"ifx" if intel else "GNU"}.', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gfortran', default='gfortran')
    parser.add_argument('--ifx', help='Additionally verify callers with Intel ifx')
    parser.add_argument('--intel-env', type=Path)
    parser.add_argument('--source', choices=['nswc.f90', 'nswc.f'], action='append')
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='nswc-interfaces-') as folder:
        names = verify_signatures(args.gfortran, folder)
        gnu = Path(folder) / 'gnu'
        gnu.mkdir()
        verify_calls(args.gfortran, gnu, names, sources=args.source or ['nswc.f90'])
        if args.ifx:
            intel = Path(folder) / 'ifx'
            intel.mkdir()
            verify_calls(args.ifx, intel, names, intel=True, env=compiler_environment(args.intel_env),
                         sources=args.source or ['nswc.f90'])


if __name__ == '__main__':
    main()
