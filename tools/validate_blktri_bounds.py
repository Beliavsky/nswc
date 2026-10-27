"""Check empty polynomial indices and bounds-checked block-tridiagonal solves."""
import argparse
from pathlib import Path
import re
import subprocess
import tempfile

from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from format_free_form import format_source, groups, TOKEN, semantic_statements
from fortran_procedures import procedure_blocks
from free_source_fixes import correct_empty_factor_index
from generate_interfaces import compiler_environment
from validate_module import standalone_caller, state_test_module
from validate_storage import run
from validate_interfaces import restrict_public
from blktri_empty_factors import transform_fixed as correct_fixed
from explicit_typing import units

ROOT = Path(__file__).resolve().parents[1]


def solver_sources(external, module):
    """Select exact production bodies plus all their library dependencies."""
    blocks = procedure_blocks(external)
    names = set(blocks)
    selected, pending = {'BLKTRI'}, ['BLKTRI']
    while pending:
        host = pending.pop()
        refs = {t[0].upper() for _, code in groups(blocks[host].splitlines(True))
                for t in TOKEN.finditer(code)} & names
        pending.extend(refs - selected)
        selected.update(refs)
    module_blocks = procedure_blocks(module)
    prefix = module[:module.index(next(iter(module_blocks.values())))]
    prefix = restrict_public(prefix, selected)
    return (''.join(body for name, body in blocks.items() if name in selected),
            state_test_module(prefix + ''.join(body for name, body in module_blocks.items() if name in selected)
                              + 'end module nswc_mod\n'))


def verify(compiler, work, intel=False, env=None):
    work = Path(work)
    external = (ROOT / 'nswc.f90').read_text()
    fixed = (ROOT / 'nswc.f').read_text()
    old_fixed = correct_fixed(fixed.encode('ascii'), undo=True)
    if correct_fixed(old_fixed) != fixed.encode('ascii') or correct_fixed(fixed.encode('ascii')) != fixed.encode('ascii'):
        raise ValueError('Fixed-form correction does not reproduce or is not idempotent')
    old_body = re.search(r'^      SUBROUTINE BLKTR1\b.*?^      END SUBROUTINE BLKTR1\n',
                         old_fixed.decode('ascii'), re.M | re.S)[0]
    old_body = format_source(lowercase(convert_text(old_body)))
    new_body = procedure_blocks(external)['BLKTR1']
    from simplify_free_style import transform as style
    if semantic_statements(style(correct_empty_factor_index(old_body))) != semantic_statements(new_body):
        raise ValueError('BLKTR1 change exceeds the reviewed index guards')
    if correct_empty_factor_index(correct_empty_factor_index(old_body)) != correct_empty_factor_index(old_body):
        raise ValueError('BLKTR1 correction is not idempotent')
    original_index = re.search(r'^      SUBROUTINE INDXB\b.*?^      END SUBROUTINE INDXB\n', fixed, re.M | re.S)[0]
    original_index = style(format_source(lowercase(convert_text(original_index))))
    if semantic_statements(original_index) != semantic_statements(procedure_blocks(external)['INDXB']):
        raise ValueError('INDXB workspace-anchor behavior changed')
    label = 'Intel' if intel else 'GNU'
    free_sources = solver_sources(external, (ROOT / 'nswc_mod.f90').read_text())
    selected = set(procedure_blocks(free_sources[0]))
    fixed_lines, scopes = units(fixed.encode('ascii'))
    fixed_source = ''.join(''.join(fixed_lines[start:end]) for name, (start, _, end) in scopes.items() if name in selected)
    sources = [('fixed', fixed_source), ('external', free_sources[0]), ('module', free_sources[1])]
    names = set(procedure_blocks(external))
    driver = (ROOT / 'tests/fortran/test_blktri_periodic.f90').read_text()
    for opt in (0, 2):
        flags = (['/nologo', f'/O{opt}' if opt else '/Od', '/fp:strict', '/check:bounds', '/traceback', '/warn:nointerfaces']
                 if intel else [f'-O{opt}', '-g', '-std=legacy', '-fcheck=bounds', '-fbacktrace',
                                '-finit-integer=0', '-ffpe-trap=invalid,zero,overflow', '-fno-allow-argument-mismatch'])
        exe = work / 'probe.exe'
        output = ['/exe:' + str(exe)] if intel else ['-o', str(exe)]
        source = work / 'probe.f90'
        if not intel and opt == 0:
            # Restore only BLKTR1 to reproduce B(0) deterministically.
            before = free_sources[0].replace(new_body, style(old_body))
            source.write_text(before + driver, newline='\n')
            run([compiler, *flags, str(source), *output], work, env)
            failed = subprocess.run([str(exe)], cwd=work, capture_output=True, text=True, timeout=30)
            if failed.returncode == 0 or "below lower bound of 1" not in failed.stderr:
                raise ValueError('Regression did not detect the original B(0):\n' + failed.stderr)
            print('GNU: reproduced original B(0) bounds failure.', flush=True)
        for variant, text in sources:
            module = variant == 'module'
            library = work / ('library.f' if variant == 'fixed' else 'library.f90')
            obj = work / ('library.obj' if intel else 'library.o')
            library.write_text(text, newline='\n')
            objout = ['/object:' + str(obj)] if intel else ['-o', str(obj)]
            run([compiler, *flags, '/c' if intel else '-c', str(library), *objout], work, env)
            for periodic in (True, False):
                caller = driver
                if not periodic:
                    caller = caller.replace('call blktri(0,0,n,', 'call blktri(0,1,n,').replace('call blktri(1,0,n,', 'call blktri(1,1,n,')
                    caller = caller.replace('            w = 0.0', '            an(1) = 0.0\n            cn(n) = 0.0\n            w = 0.0')
                    caller = caller.replace('            if (ncmplx /= mode) stop 2\n', '')
                if module:
                    caller = standalone_caller(caller, names)
                source.write_text(caller, newline='\n')
                run([compiler, *flags, str(source), str(obj), *output], work, env)
                try:
                    result = run([str(exe)], work, env)
                except RuntimeError as error:
                    raise RuntimeError(f'{label} O{opt}, {variant}, periodic={periodic}: {error}') from error
                if 'test_blktri_periodic: PASS' not in result.stdout:
                    raise ValueError('Bounds-checked solver did not complete')
        print(f'{label} O{opt}: fixed/external/module periodic/nonperiodic solves passed with bounds checking.', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ifx')
    parser.add_argument('--intel-env', type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='nswc-blktri-bounds-') as work:
        verify('gfortran', work)
        if args.ifx:
            verify(args.ifx, work, True, compiler_environment(args.intel_env))


if __name__ == '__main__':
    main()
