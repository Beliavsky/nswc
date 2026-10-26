"""Verify DATA conversion values, executable statements and unchanged symbols."""
import json
import argparse
from pathlib import Path
import re
import tempfile
import subprocess

from data_constants import MANIFEST, declarations_in, parameter, transform
from fortran_procedures import procedure_blocks
from generate_interfaces import compiler_environment
from format_free_form import wrap_line
from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from format_free_form import format_source, groups, semantic_statements
from review_data_constants import compile_dump, review, verify_values

ROOT = Path(__file__).resolve().parents[1]


def executable_statements(text):
    result = []
    specification = re.compile(r'^\s*(?:integer|real|double\s+(?:precision|complex)|complex|logical|character|'
                               r'data|save|implicit|external|intrinsic|parameter|common|equivalence|dimension)\b', re.I)
    for _, logical in groups(text.splitlines(True)):
        if not specification.match(logical):
            result.extend(semantic_statements(logical))
    return result


def initializer_probe(source, manifest):
    blocks = procedure_blocks(source)
    output = ['program initializer_bits\nuse iso_fortran_env, only: int8\nimplicit none\n']
    output.extend('call check_' + n.lower() + '()\n' for n in manifest['procedures'])
    output.extend(["print *, 'initializer_bits: PASS'\n", 'contains\n'])
    for name, entry in manifest['procedures'].items():
        declarations = declarations_in(blocks[name])
        output.append('subroutine check_' + name.lower() + '()\nimplicit none\n')
        data, checks = [], []
        for variable, values in entry['constants'].items():
            declaration = declarations[variable]
            old, new = variable + '_old', variable + '_new'
            output.append(f"{declaration['type']} :: {old}{declaration['shape']}{declaration['length']}\n")
            output.append(parameter(new, declaration, values))
            data.append(wrap_line('', 'data ' + old + ' /' + ', '.join(values) + '/', '', '', '\n', 3))
            checks.append(wrap_line('', f"if (any(transfer({old}, [0_int8]) /= transfer({new}, [0_int8]))) "
                                    f"error stop '{name}:{variable}: initializer bits'", '', '', '\n', 3))
        output.extend(data)
        output.extend(checks)
        output.append('end subroutine check_' + name.lower() + '\n')
    output.append('end program initializer_bits\n')
    return ''.join(output)


def verify_bits(probe, folder, compiler, intel=False, env=None):
    source = folder / 'initializer_bits.f90'
    source.write_text(probe, encoding='ascii', newline='\n')
    exe = folder / 'initializer_bits.exe'
    flags = ['/nologo', '/Od', '/fp:strict', str(source), '/exe:' + str(exe)] if intel else ['-std=legacy', str(source), '-o', str(exe)]
    result = subprocess.run([compiler, *flags], cwd=folder, env=env, capture_output=True, text=True, timeout=180)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr[:10000])
    result = subprocess.run([str(exe)], cwd=folder, env=env, capture_output=True, text=True, timeout=30)
    if result.returncode or 'initializer_bits: PASS' not in result.stdout:
        raise RuntimeError(result.stdout + result.stderr)
    print(('Intel' if intel else 'GNU') + ': every converted scalar/array initializer has identical storage bits.', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ifx')
    parser.add_argument('--intel-env', type=Path)
    args = parser.parse_args()
    source = format_source(lowercase(convert_text((ROOT / 'nswc.f').read_text(encoding='ascii'))))
    manifest = json.loads(MANIFEST.read_text())
    converted = transform(source, manifest)
    if executable_statements(source) != executable_statements(converted):
        raise ValueError('DATA conversion changed executable statements')
    with tempfile.TemporaryDirectory(prefix='nswc-constant-check-') as work:
        folder = Path(work)
        before, warnings_before = compile_dump(source, folder, 'before')
        if review(source, before) != manifest:
            raise ValueError('DATA review does not reproduce its read/write and initialization analysis')
        after, warnings_after = compile_dump(converted, folder, 'after')
        verify_values(before, after, manifest)
        for scope in before:
            constants = manifest['procedures'].get(scope, {}).get('constants', {})
            for variable, record in before[scope].items():
                if variable not in constants and record != after[scope].get(variable):
                    raise ValueError(f'{scope}:{variable}: an unconverted compiler record changed')
        old = re.findall(r'^Warning:.*', warnings_before, re.M)
        new = re.findall(r'^Warning:.*', warnings_after, re.M)
        if old != new:
            raise ValueError('DATA conversion changed compiler warnings')
        probe = initializer_probe(source, manifest)
        verify_bits(probe, folder, 'gfortran')
        if args.ifx:
            verify_bits(probe, folder, args.ifx, True, compiler_environment(args.intel_env))
    print(json.dumps(manifest['summary']), flush=True)
    print('Initialized values, types, bounds, executable statements and unconverted symbols are unchanged.', flush=True)


if __name__ == '__main__':
    main()
