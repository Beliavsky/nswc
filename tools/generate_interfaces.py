"""Generate the optional external-interface module with Intel ifx.

Run in an initialized Intel compiler environment, or pass --ifx explicitly.
COMPB is checked separately because its legacy PPADD workspace association is
not type conforming. This does not change or repair that library call.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

from fortran_procedures import HEADER, procedure_blocks
from callback_interfaces import abstract_interfaces, enrich, BINDINGS, EXCEPTIONS

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / 'nswc_interfaces.f90'
METADATA = Path(__file__).with_name('interface-generation.json')
KINDS = {'REAL(KIND=4)': 'REAL', 'REAL(KIND=8)': 'DOUBLE PRECISION',
         'COMPLEX(KIND=4)': 'COMPLEX', 'INTEGER(KIND=4)': 'INTEGER', 'LOGICAL(KIND=4)': 'LOGICAL'}


def compiler_environment(setup=None):
    if setup is None:
        return dict(os.environ)
    setup = str(Path(setup).resolve())
    if any(c in setup for c in '%"\r\n') or not Path(setup).is_file():
        raise ValueError('Expected an existing Intel environment batch file')
    with tempfile.TemporaryDirectory(prefix='nswc-intel-env-') as folder:
        script = Path(folder) / 'environment.cmd'
        script.write_text(f'@echo off\ncall "{setup}" intel64 >nul\nif errorlevel 1 exit /b 1\nset\n')
        result = subprocess.run(['cmd.exe', '/d', '/c', 'call', str(script)],
                                capture_output=True, text=True, timeout=120)
        if result.returncode:
            raise RuntimeError('Intel environment initialization failed: ' + result.stderr)
    return {name: value for line in result.stdout.splitlines()
            for name, sep, value in [line.partition('=')] if sep and name}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def normalize_body(raw):
    match = re.search(r'^\s*INTERFACE\s*\n(.*?)^\s*END INTERFACE\s*$', raw, re.M | re.S)
    if not match:
        raise ValueError('Unexpected Intel interface wrapper')
    text = match[1]
    for before, after in KINDS.items():
        text = text.replace(before, after)
    if re.search(r'\bKIND\s*=', text, re.I):
        raise ValueError('Unreviewed Intel kind mapping')
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    end_header = 0
    while lines[end_header].endswith('&'):
        end_header += 1
    lines.insert(end_header + 1, 'IMPLICIT NONE')
    return ''.join(('    ' if i == 0 or line.upper().startswith('END ') else '      ') + line + '\n'
                   for i, line in enumerate(lines))


def assemble(raw, expected):
    if set(raw) != set(expected):
        raise ValueError(f'Generated procedure set differs: {set(raw) ^ set(expected)}')
    bodies = {name: normalize_body(raw[name]) for name in sorted(raw)}
    for name, body in bodies.items():
        if list(procedure_blocks(body)) != [name]:
            raise ValueError(f'Wrong generated interface: {name}')
    reviewed = {name + ':' + arg.upper() for name, body in bodies.items()
                for arg in re.findall(r'^\s*EXTERNAL (\w+)\s*$', body, re.M | re.I)}
    if len(expected) == 1062 and reviewed != BINDINGS.keys() | EXCEPTIONS.keys():
        raise ValueError('Callback review inventory differs')
    bodies = {name: enrich(name, body) for name, body in bodies.items()}
    return ('! Generated with Intel ifx; see tools/generate_interfaces.py.\n'
            '! Optional interfaces for existing external procedures; no implementations here.\n'
            '! Import selected names with USE nswc_interfaces, ONLY: ...\n'
            'module nswc_interfaces\n  implicit none\n' + abstract_interfaces() + '  interface\n'
            + ''.join(bodies.values()) + '  end interface\nend module nswc_interfaces\n')


def generate(compiler, source, env=None):
    definitions = procedure_blocks(source.decode('ascii'))
    if len(definitions) != 1062 or 'COMPB' not in definitions:
        raise ValueError('Expected the complete maintained NSWC source')
    raw, diagnostics = {}, []
    with tempfile.TemporaryDirectory(prefix='nswc-ifx-interfaces-') as folder:
        for label, names in [('library', [n for n in definitions if n != 'COMPB']), ('compb', ['COMPB'])]:
            work = Path(folder) / label
            work.mkdir()
            (work / 'input.f90').write_text(''.join(definitions[n] for n in names), encoding='ascii', newline='\n')
            command = [compiler, '/nologo', '/syntax-only', '/gen-interfaces:source', '/warn:interfaces', 'input.f90']
            result = subprocess.run(command, cwd=work, env=env, capture_output=True, text=True, timeout=300)
            diagnostics.append(result.stdout + result.stderr)
            if result.returncode:
                raise RuntimeError(f'ifx generation failed ({label}):\n{diagnostics[-1]}')
            generated = list(work.glob('*__genmod.f90'))
            if len(generated) != len(names):
                raise ValueError(f'Missing generated interfaces in {label}')
            for path in generated:
                name = path.name[:-len('__genmod.f90')].upper()
                if name in raw:
                    raise ValueError(f'Duplicate generated file: {name}')
                raw[name] = path.read_text()
        version = subprocess.run([compiler, '/QV'], env=env, capture_output=True, text=True, timeout=30)
        if version.returncode:
            raise RuntimeError(version.stdout + version.stderr)
    module = assemble(raw, definitions).encode('ascii')
    metadata = {'source': 'nswc.f90', 'source_sha256': sha(source), 'module_sha256': sha(module),
                'compiler': (version.stdout + version.stderr).strip().splitlines()[0],
                'procedures': len(raw), 'kind_mappings': KINDS,
                'callback_review_sha256': sha(Path(__file__).with_name('callback_interfaces.py').read_bytes()),
                'explicit_callbacks': len(BINDINGS), 'callback_exceptions': EXCEPTIONS,
                'isolated_procedures': {'COMPB': 'Known real/complex PPADD workspace alias; see docs/compiler-warnings.md'}}
    return module, metadata, '\n'.join(diagnostics)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ifx', default='ifx')
    parser.add_argument('--intel-env', type=Path, help='Optional Intel environment batch file on Windows')
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    module, metadata, diagnostics = generate(args.ifx, (ROOT / 'nswc.f90').read_bytes(),
                                              compiler_environment(args.intel_env))
    if args.check:
        if MODULE.read_bytes() != module or json.loads(METADATA.read_text()) != metadata:
            raise RuntimeError('Generated interfaces or metadata are stale')
    else:
        MODULE.write_bytes(module)
        METADATA.write_text(json.dumps(metadata, indent=2) + '\n', encoding='utf-8', newline='\n')
    print(diagnostics, end='')
    print(f'Generated and checked {metadata["procedures"]} external procedure interfaces.')


if __name__ == '__main__':
    main()
