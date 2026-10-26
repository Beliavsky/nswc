"""Check alias removal, table bits, module state layout and optimized behavior."""
import argparse
import copy
import json
from pathlib import Path
import re
import subprocess
import tempfile

from data_constants import declarations_in
from fortran_procedures import procedure_blocks
from format_free_form import groups, wrap_line, TOKEN
from generate_interfaces import compiler_environment
from generate_module import module_source
from modernize_obsolescent import compile_dump, transform as obsolescent
from modernize_remaining_features import strict_standard
from storage_modernization import (ALIASES, MANIFEST, common_views, equivalence_free,
                                   equivalence_review, module_state, normalize_module_records)
from validate_explicit_typing import symbols
from validate_interfaces import compare_signatures, module_caller
from validate_obsolescent import baseline

ROOT = Path(__file__).resolve().parents[1]


def coefficient_probe(text):
    body = procedure_blocks(text)['ASJY']
    declarations = declarations_in(body)
    names = {'alfa', 'beta'} | ALIASES.keys()
    output = ['program coefficient_bits\nimplicit none\n']
    for name, entry in declarations.items():
        if name in names:
            output.append(entry['type'] + ' :: ' + name + entry['shape'] + '\n')
    for _, code in groups(body.splitlines(True)):
        if (re.match(r'^\s*equivalence\b', code, re.I) or
                re.match(r'^\s*data\s+(?:alfa[12]?|beta[123]?)\b', code, re.I)):
            output.append(wrap_line('', code, '', '', '\n', 3))
    output += ["print '(*(z8.8,1x))', transfer(alfa,[0])\n",
               "print '(*(z8.8,1x))', transfer(beta,[0])\nend program coefficient_bits\n"]
    return ''.join(output)


def run(command, work, env=None):
    r = subprocess.run(command, cwd=work, env=env, capture_output=True, text=True, timeout=300)
    if r.returncode:
        raise RuntimeError(r.stdout + r.stderr[-14000:])
    return r


def table_bits(before, after, compiler, work, intel=False, env=None):
    outputs = []
    for source in (before, after):
        path = Path(work) / 'bits.f90'
        path.write_text(coefficient_probe(source), encoding='ascii', newline='\n')
        exe = Path(work) / 'bits.exe'
        flags = ['/nologo', '/Od', '/fp:strict', str(path), '/exe:' + str(exe)] if intel else ['-std=legacy', str(path), '-o', str(exe)]
        run([compiler, *flags], work, env)
        outputs.append(run([str(exe)], work, env).stdout)
    if outputs[0] != outputs[1]:
        raise ValueError('ASJY coefficient storage bits differ')
    if len(outputs[0].split()) != 234:
        raise ValueError('ASJY coefficient element inventory differs')
    print(('Intel' if intel else 'GNU') + ': all 234 ASJY coefficient elements have identical bits.', flush=True)


def compare_alias_records(before, after, work):
    a = symbols(compile_dump(before, work)[0])
    b = symbols(compile_dump(after, work)[0])
    count = compare_signatures(a, b)
    for name in ALIASES:
        del a['ASJY'][name]
    for host, names in [('SFFT', ['ii']), ('ADCOMP', ['fdervl', 'fdervr'])]:
        for name in names:
            del a[host][name]
    for host, names in [('ASJY', ['alfa', 'beta']), ('SFFT', ['i']), ('ADCOMP', ['fleft', 'fright'])]:
        for name in names:
            attrs = a[host][name]['attributes']
            a[host][name]['attributes'] = attrs.replace(' IN-EQUIVALENCE', ' DATA' if host == 'ASJY' else '')
    if a != b:
        changed = [h + ':' + n for h, scope in a.items() for n, value in scope.items() if value != b[h].get(n)]
        raise ValueError('Unreviewed alias-removal compiler records changed: ' + ', '.join(changed[:20]))
    if common_views(before) != common_views(after):
        raise ValueError('External COMMON layouts or bindings changed')
    print(f'Confirmed {count} unchanged interfaces and all external COMMON layouts.', flush=True)


def optimized_probe(compiler, work, intel=False, env=None):
    external = (ROOT / 'nswc.f90').read_text()
    blocks = procedure_blocks(external)
    names = set(blocks)
    selected = {'ADAPT', 'SFFT', 'RADIX', 'RNDERR', 'RSCO', 'SVCO', 'STORE2', 'DSTOR2'}
    pending = list(selected)
    while pending:
        host = pending.pop()
        refs = {token[0].upper() for _, code in groups(blocks[host].splitlines(True))
                for token in TOKEN.finditer(code)} & names
        pending.extend(refs - selected)
        selected.update(refs)
    drivers = ['test_storage_state', 'test_adaptive_approx_compat']
    outputs = {name: [] for name in drivers}
    for stem in ('nswc', 'nswc_mod'):
        obj = Path(work) / ('library.obj' if intel else 'library.o')
        if stem == 'nswc':
            source = ''.join(body for name, body in blocks.items() if name in selected)
        else:
            module = (ROOT / 'nswc_mod.f90').read_text()
            module_blocks = procedure_blocks(module)
            first = module.index(next(iter(module_blocks.values())))
            prefix = module[:first]
            prefix = ''.join(line for line in prefix.splitlines(True)
                             if not (m := re.match(r'^public :: (\w+)\s*$', line, re.I)) or m[1].upper() in selected)
            source = prefix + ''.join(body for name, body in module_blocks.items() if name in selected) + 'end module nswc_mod\n'
        subset = Path(work) / 'library.f90'
        subset.write_text(source, encoding='ascii', newline='\n')
        flags = ['/nologo', '/O2', '/fp:strict', '/warn:nointerfaces'] if intel else ['-O2', '-std=legacy', '-fno-allow-argument-mismatch']
        output = ['/object:' + str(obj)] if intel else ['-o', str(obj)]
        run([compiler, *flags, '/c' if intel else '-c', str(subset), *output], work, env)
        path = Path(work) / 'probe.f90'
        exe = Path(work) / 'probe.exe'
        output = ['/exe:' + str(exe)] if intel else ['-o', str(exe)]
        for name in drivers:
            driver = (ROOT / 'tests/fortran' / (name + '.f90')).read_text()
            text = module_caller(driver, names).replace('nswc_interfaces', 'nswc_mod') if stem == 'nswc_mod' else driver
            path.write_text(text, encoding='ascii', newline='\n')
            run([compiler, *flags, str(path), str(obj), *output], work, env)
            result = run([str(exe)], work, env)
            if name + ': PASS' not in result.stdout:
                raise ValueError('Optimized ' + name + ' probe did not complete')
            outputs[name].append(result.stdout)
        if stem == 'nswc':
            path.write_text('''program common_abi
implicit none
real :: s1,s2
double precision :: d1,d2
common /spdata/ s1,s2
common /dpdata/ d1,d2
call store2(3.5,-4.5)
call dstor2(7.25d0,-8.25d0)
if(s1/=3.5.or.s2/=-4.5) error stop 'SPDATA ABI'
if(d1/=7.25d0.or.d2/=-8.25d0) error stop 'DPDATA ABI'
print *, 'common_abi: PASS'
end program common_abi
''', encoding='ascii', newline='\n')
            run([compiler, *flags, str(path), str(obj), *output], work, env)
            if 'common_abi: PASS' not in run([str(exe)], work, env).stdout:
                raise ValueError('External COMMON ABI probe did not complete')
    if any(pair[0] != pair[1] for pair in outputs.values()):
        raise ValueError('Optimized external/module storage behavior differs')
    print(('Intel' if intel else 'GNU') + ': optimized packed-state, FFT, adaptive derivatives, rounding, radix and COMMON ABI probes passed.', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ifx')
    parser.add_argument('--intel-env', type=Path)
    args = parser.parse_args()
    before = obsolescent(baseline())
    manifest = json.loads(MANIFEST.read_text())
    if equivalence_review(before) != {'equivalences': manifest['equivalences']}:
        raise ValueError('Equivalence review does not reproduce')
    after = equivalence_free(before)
    if after != (ROOT / 'nswc.f90').read_text(encoding='ascii') or equivalence_free(after) != after:
        raise ValueError('Equivalence-free generation is stale or not idempotent')
    report = {}
    modern = module_state(module_source(after, modern_state=False), report)
    if report != manifest['module_state'] or modern != (ROOT / 'nswc_mod.f90').read_text(encoding='ascii'):
        raise ValueError('Private module state or review does not reproduce')
    if module_state(modern) != modern:
        raise ValueError('Private module state pass is not idempotent')
    with tempfile.TemporaryDirectory(prefix='nswc-storage-check-') as work:
        compare_alias_records(before, after, work)
        external_records = symbols(compile_dump(after, work)[0])
        module_records = symbols(compile_dump(modern, work)[0])
        compare_signatures(external_records, normalize_module_records(external_records, module_records, report))
        private_probe = Path(work) / 'private.f90'
        private_probe.write_text('program p\nuse nswc_mod, only: cbrt\nend program p\n')
        run(['gfortran', '-fsyntax-only', str(private_probe)], work)
        private_probe.write_text('program p\nuse nswc_mod, only: nswc_state_spdata_d1\nend program p\n')
        private_check = subprocess.run(['gfortran', '-fsyntax-only', str(private_probe)], cwd=work,
                                       capture_output=True, text=True, timeout=30)
        if private_check.returncode == 0:
            raise ValueError('Compiler exposed private module state')
        for name, source in [('nswc.f90', after), ('nswc_mod.f90', modern)]:
            if re.search(r'^\s*equivalence\b', source, re.M | re.I):
                raise ValueError(name + ': equivalence remains')
            strict = run(['gfortran', strict_standard(), '-pedantic-errors', '-fsyntax-only', str(ROOT / name)], work)
            if name == 'nswc_mod.f90' and strict.stderr.strip():
                raise ValueError('Strict module compilation is not warning-free:\n' + strict.stderr[:4000])
        table_bits(before, after, 'gfortran', work)
        optimized_probe('gfortran', work)
        if args.ifx:
            env = compiler_environment(args.intel_env)
            table_bits(before, after, args.ifx, work, True, env)
            optimized_probe(args.ifx, work, True, env)
    print('Module: 14 COMMON blocks removed; strict compilation has no warnings. External COMMON ABI retained.')


if __name__ == '__main__':
    main()
