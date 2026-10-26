"""Compare GNU's complete compiler dumps before and after free-form formatting."""
import argparse
from pathlib import Path
import subprocess
import tempfile

from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from format_free_form import format_source, semantic_statements
from validate_explicit_typing import symbols
from free_source_fixes import transform as apply_free_fixes
from procedure_purity import transform as apply_purity

ROOT = Path(__file__).resolve().parents[1]


def without_unary_plus(dump):
    """Remove only balanced GNU (U+ operand) wrappers, preserving the operand."""
    while '(U+ ' in dump:
        start = dump.index('(U+ ')
        depth, quote, i = 1, '', start + 4
        while i < len(dump) and depth:
            char = dump[i]
            if quote:
                if char == quote:
                    if i + 1 < len(dump) and dump[i + 1] == quote:
                        i += 1
                    else:
                        quote = ''
            elif char in "'\"":
                quote = char
            elif char == '(':
                depth += 1
            elif char == ')':
                depth -= 1
            i += 1
        if depth:
            raise ValueError('Unbalanced GNU unary-plus expression')
        dump = dump[:start] + dump[start + 4:i - 1] + dump[i:]
    return dump


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', default='gfortran')
    args = parser.parse_args()
    original = lowercase(convert_text((ROOT / 'nswc.f').read_text(encoding='ascii')))
    formatted = format_source(original)
    if semantic_statements(apply_free_fixes(apply_purity(formatted))) != semantic_statements((ROOT / 'nswc.f90').read_text(encoding='ascii')):
        raise ValueError('Maintained free-form code differs from formatted fixed-form conversion')
    dumps = []
    with tempfile.TemporaryDirectory(prefix='nswc-free-formatting-') as folder:
        for name, text in [('before', original), ('after', formatted)]:
            path = Path(folder, name + '.f90')
            path.write_text(text, encoding='ascii', newline='\n')
            result = subprocess.run([args.compiler, '-fsyntax-only', '-std=legacy',
                                     '-fallow-argument-mismatch', '-fdump-fortran-original', str(path)],
                                    cwd=folder, capture_output=True, text=True, timeout=180)
            if result.returncode:
                raise RuntimeError(result.stderr)
            dumps.append(result.stdout)
    records = symbols(dumps[0], include_intrinsics=True)
    if records != symbols(dumps[1], include_intrinsics=True):
        raise ValueError('Formatting changed compiler symbol records')
    if without_unary_plus(dumps[0]) != without_unary_plus(dumps[1]):
        raise ValueError('Formatting changed compiler expressions or control flow')
    print(f'Confirmed {sum(map(len, records.values()))} unchanged compiler symbol records.')
    print('Complete compiler dumps agree after removing redundant unary-plus wrappers only.')


if __name__ == '__main__':
    main()
