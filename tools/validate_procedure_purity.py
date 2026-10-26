"""Verify purity legality, unchanged data/control flow, and elemental array calls."""
import argparse
from collections import Counter
import difflib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from sentence_case_comments import sentence_case
from format_free_form import format_source
from free_source_fixes import transform as apply_free_fixes
from procedure_purity import transform, MANIFEST
from validate_explicit_typing import symbols
from generate_interfaces import compiler_environment
from data_constants import transform as apply_constants
from portable_intrinsics import transform as portable_intrinsics
from simplify_free_style import transform as simplify_style
from generic_intrinsics import transform as apply_generics

ROOT = Path(__file__).resolve().parents[1]


def executable_code(dump):
    scope, active, result = None, False, {}
    for line in dump.splitlines():
        match = re.match(r'^procedure name = (\w+)', line)
        if match:
            scope, active = match[1].upper(), False
            result[scope] = []
        if line.strip() == 'code:':
            active = True
        elif line.startswith(('---', 'Namespace:')):
            active = False
        elif active and line.strip():
            result[scope].append(line.rstrip())
    return result


def run(command, folder, env=None, success=True):
    result = subprocess.run(command, cwd=folder, env=env, capture_output=True, text=True, timeout=300)
    if success and result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    return result


def numerical_probe(compiler, folder, env=None, intel=False):
    if intel:
        run([compiler, '/nologo', '/c', str(ROOT / 'nswc_interfaces.f90'), '/object:interfaces.obj'], folder, env)
        run([compiler, '/nologo', '/Od', '/fp:strict', '/warn:nointerfaces', '/c', str(ROOT / 'nswc.f90'), '/object:library.obj'], folder, env)
        command = [compiler, '/nologo', '/fpe:0', str(ROOT / 'tests/purity/test_pure_elemental.f90'), 'library.obj', '/exe:probe.exe']
    else:
        run([compiler, '-std=f2008', '-pedantic-errors', '-c', str(ROOT / 'nswc_interfaces.f90'), '-o', 'interfaces.o'], folder)
        run([compiler, '-std=legacy', '-fno-allow-argument-mismatch', '-c', str(ROOT / 'nswc.f90'), '-o', 'library.o'], folder)
        command = [compiler, '-std=f2008', '-pedantic-errors', '-ffpe-trap=invalid,zero,overflow',
                   str(ROOT / 'tests/purity/test_pure_elemental.f90'), 'library.o', '-o', 'probe.exe']
    run(command, folder, env)
    output = run([str(folder / 'probe.exe')], folder, env)
    if 'test_pure_elemental: PASS' not in output.stdout:
        raise ValueError(output.stdout + output.stderr)
    negative = folder / 'negative.f90'
    negative.write_text('''program probe
use nswc_interfaces, only: polydd
implicit none
contains
pure double precision function invalid(x)
double precision, intent(in) :: x
invalid = polydd(x)
end function invalid
end program probe
''', newline='\n')
    command = ([compiler, '/nologo', '/c', str(negative)] if intel else
               [compiler, '-std=f2008', '-pedantic-errors', '-c', str(negative)])
    if run(command, folder, env, success=False).returncode == 0:
        raise ValueError('Compiler accepted the impure polynomial helper in a pure caller')
    print(('Intel' if intel else 'GNU') + ': pure callers, elemental arrays and scalar broadcasting passed; impure call rejected.', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', default='gfortran')
    parser.add_argument('--ifx')
    parser.add_argument('--intel-env', type=Path)
    args = parser.parse_args()
    baseline = portable_intrinsics(apply_constants(sentence_case(format_source(lowercase(convert_text((ROOT / 'nswc.f').read_text(encoding='ascii'))))).text))
    manifest = json.loads(MANIFEST.read_text())
    annotated = transform(baseline, manifest)
    if apply_generics(simplify_style(apply_free_fixes(annotated))) != (ROOT / 'nswc.f90').read_text(encoding='ascii'):
        raise ValueError('Purity regeneration differs from maintained source')
    inventories, code, warnings = [], [], []
    with tempfile.TemporaryDirectory(prefix='nswc-purity-validation-') as work:
        folder = Path(work)
        for name, text in [('baseline', baseline), ('annotated', annotated)]:
            path = folder / (name + '.f90')
            path.write_text(text, encoding='ascii', newline='\n')
            result = run([args.compiler, '-fsyntax-only', '-std=legacy', '-fallow-argument-mismatch',
                          '-fdump-fortran-original', str(path)], folder)
            inventories.append(symbols(result.stdout, True))
            code.append(executable_code(result.stdout))
            warnings.append(Counter(re.findall(r'^Warning: (.*)', result.stderr, re.M)))
        data = [{n: {v: r for v, r in scope.items() if 'PROCEDURE' not in r.get('attributes', '')}
                 for n, scope in inventory.items()} for inventory in inventories]
        if data[0] != data[1]:
            raise ValueError('Purity annotation changed data symbols, attributes or array bounds')
        for name in inventories[0]:
            before, after = inventories[0][name][name.lower()], inventories[1][name][name.lower()]
            for field in ('type spec', 'Formal arglist'):
                if before.get(field) != after.get(field):
                    raise ValueError(f'{name}: argument order or function result type changed')
            expected = manifest['procedures'].get(name, {}).get('attribute', '')
            for attribute in ('pure', 'elemental'):
                if bool(re.search(r'\b' + attribute.upper() + r'\b', after.get('attributes', ''))) != (attribute in expected.split()):
                    raise ValueError(f'{name}: compiler {attribute} attribute differs from review')
        if code[0] != code[1]:
            differences = [n for n in code[0] if code[0].get(n) != code[1].get(n)]
            name = differences[0]
            raise ValueError('Executable compiler trees differ in ' + name + ':\n' + '\n'.join(
                list(difflib.unified_diff(code[0][name], code[1][name]))[:50]))
        if warnings[0] != warnings[1]:
            raise ValueError('Purity annotation changed the compiler warning inventory')
        print('All data records, argument order, result types and executable compiler trees are unchanged.', flush=True)
        print(json.dumps(manifest['summary']), flush=True)
        gnu = folder / 'gnu'
        gnu.mkdir()
        numerical_probe(args.compiler, gnu)
        if args.ifx:
            intel = folder / 'intel'
            intel.mkdir()
            numerical_probe(args.ifx, intel, compiler_environment(args.intel_env), intel=True)


if __name__ == '__main__':
    main()
