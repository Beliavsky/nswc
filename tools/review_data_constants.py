"""Review DATA initializers using write contexts, call intents and GNU values."""
import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile

from data_constants import (MANIFEST, declarations_in, dimensions, locations,
                            expand_data_repeats, parse_data, transform)
from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from format_free_form import TOKEN, assignment_equal, conditional_end, format_source, groups
from fortran_procedures import procedure_blocks
from procedure_purity import code_hash
from validate_explicit_typing import symbols

ROOT = Path(__file__).resolve().parents[1]
MATH_INTRINSICS = set(('abs iabs dabs cabs cdabs aimag dimag conjg dconjg cmplx dcmplx '
                      'sqrt dsqrt csqrt cdsqrt exp dexp cexp log alog dlog clog log10 alog10 dlog10 '
                      'sin dsin csin cos dcos ccos tan dtan asin dasin acos dacos atan datan '
                      'atan2 datan2 sinh dsinh cosh dcosh tanh dtanh '
                      'int ifix idint real float sngl dble dfloat aint dint anint dnint nint idnint '
                      'max max0 max1 amax0 amax1 dmax1 min min0 min1 amin0 amin1 dmin1 '
                      'sign isign dsign dim idim ddim mod amod dmod modulo '
                      'ichar iachar char achar len index scan verify trim adjustl adjustr '
                      'ishft ishftc iand ior ieor not btest ibset ibclr '
                      'epsilon tiny huge radix digits minexponent maxexponent '
                      'gamma dgamma log_gamma erf erfc derf derfc '
                      'kind size lbound ubound product sum all any maxval minval reshape transfer').split())


def compile_dump(text, folder, label, compiler='gfortran'):
    source = folder / (label + '.f90')
    source.write_text(expand_data_repeats(text), encoding='ascii', newline='\n')
    result = subprocess.run([compiler, '-std=legacy', '-fallow-argument-mismatch', '-fsyntax-only',
                             '-fdump-fortran-original', str(source)], cwd=folder,
                            capture_output=True, text=True, timeout=180)
    if result.returncode:
        raise RuntimeError(result.stderr[:15000])
    inventory = symbols(result.stdout, True)
    scope, symbol = None, None
    for line in result.stdout.splitlines():
        header = re.match(r'procedure name = (\w+)', line)
        if header:
            scope, symbol = header[1].upper(), None
        match = re.search(r"symtree:.*?\|\| symbol: '([^']+)'", line)
        if match:
            symbol = match[1]
        value = re.match(r'^\s*value:\s*(.*)', line)
        if value and scope and symbol:
            inventory[scope][symbol]['value'] = value[1]
    return inventory, result.stderr


def actual_arguments(tokens, opening):
    depth, current, result = 1, [], []
    for token in tokens[opening + 1:]:
        if token == '(':
            depth += 1
        elif token == ')':
            depth -= 1
            if depth == 0:
                return result + [current]
        if token == ',' and depth == 1:
            result.append(current)
            current = []
        else:
            current.append(token)
    raise ValueError('Unbalanced actual argument list')


def variable_actual(tokens):
    """Return the root of a variable designator; expressions pass temporary values."""
    if not tokens or not re.fullmatch(r'[a-z_]\w*', tokens[0], re.I):
        return None
    i = 1
    while i < len(tokens):
        if tokens[i] == '(':
            depth = 1
            i += 1
            while i < len(tokens) and depth:
                depth += (tokens[i] == '(') - (tokens[i] == ')')
                i += 1
            if depth:
                return None
        elif tokens[i] == '%' and i + 1 < len(tokens):
            i += 2
        else:
            return None
    return tokens[0]


def unsafe_uses(body, candidates, inventory, scope_name):
    scope = inventory[scope_name]
    unsafe = {}
    def reject(names, reason):
        for n in names & candidates:
            unsafe.setdefault(n, set()).add(reason)
    for records, logical in groups(body.splitlines(True)):
        tokens = [m[0].lower() for m in TOKEN.finditer(logical)]
        if not tokens:
            continue
        first = tokens[0]
        if '%' in tokens:
            reject(set(tokens), 'nonstandard address or component context')
        if first in ('data', 'save', 'implicit', 'external', 'intrinsic', 'parameter'):
            if first == 'save' and any(r.comment for r in records):
                reject(set(tokens), 'annotated SAVE statement')
            continue
        if first == 'equivalence':
            reject(candidates, 'storage association through EQUIVALENCE')
            continue
        if first == 'common':
            reject(set(tokens), 'COMMON storage')
            continue
        if type_declaration_start(logical):
            continue
        eq = assignment_equal(tokens)
        if first == 'do' and '=' in tokens:
            reject({tokens[tokens.index('=') - 1]}, 'DO index')
        elif eq is not None:
            condition = conditional_end(tokens)
            lhs = tokens[(condition + 1 if condition is not None else 0):eq]
            if lhs:
                reject({lhs[0]}, 'assignment target')
        if first in ('read', 'inquire', 'open', 'close', 'backspace', 'rewind', 'endfile', 'assign'):
            reject(set(tokens), 'I/O or assigned-label context')
        for i, token in enumerate(tokens[:-1]):
            record = scope.get(token, {})
            is_call = i > 0 and tokens[i - 1] == 'call'
            if tokens[i + 1] != '(' or (not is_call and 'PROCEDURE' not in record.get('attributes', '')):
                continue
            if 'INTRINSIC-PROC' in record.get('attributes', '') and token in MATH_INTRINSICS and not is_call:
                continue
            callee = inventory.get(token.upper()) if 'DUMMY' not in record.get('attributes', '') else None
            formals = callee.get(token, {}).get('Formal arglist', '').split(':', 1)[-1].split() if callee else []
            for position, actual in enumerate(actual_arguments(tokens, i + 1)):
                formal = formals[position] if position < len(formals) else None
                if len(actual) >= 2 and actual[1] == '=':
                    formal, actual = actual[0], actual[2:]
                attrs = callee.get(formal, {}).get('attributes', '') if callee and formal else ''
                if 'DUMMY(IN)' not in attrs:
                    root = variable_actual(actual)
                    if root:
                        reject({root}, f'argument of {token} without confirmed INTENT(IN)')
    return {n: sorted(v) for n, v in unsafe.items()}


def type_declaration_start(logical):
    return bool(re.match(r'^\s*(?:integer|real|double\s+(?:precision|complex)|complex|logical|character)\b', logical, re.I))


def review(text, inventory):
    selected, rejected, unsupported = {}, {}, {}
    for name, body in procedure_blocks(text).items():
        if not re.search(r'^\s*data\s+', body, re.I | re.M):
            continue
        try:
            declarations = declarations_in(body)
            initialized = {}
            for records, logical in groups(body.splitlines(True)):
                if not re.match(r'^\s*data\s+', logical, re.I):
                    continue
                if any(r.comment for r in records):
                    raise ValueError('Annotated DATA statement')
                for targets, values in parse_data(logical, declarations):
                    cells = [cell for _, cells in targets for cell in cells]
                    for (variable, indices), value in zip(cells, values):
                        entries = initialized.setdefault(variable, {})
                        if indices in entries:
                            raise ValueError('Duplicate initializer for ' + variable)
                        entries[indices] = value
            bad = unsafe_uses(body, set(initialized), inventory, name)
            constants = {}
            for variable, cells in initialized.items():
                declaration = declarations[variable]
                reasons = bad.setdefault(variable, [])
                bounds = dimensions(declaration['shape'])
                expected = locations(variable, bounds)
                if set(cells) != {index for _, index in expected}:
                    reasons.append('partial or out-of-bounds initialization')
                if declaration['annotated']:
                    reasons.append('annotated type declaration')
                if {a.lower() for a in declaration['attrs']} - {'save'}:
                    reasons.append('additional declaration attributes')
                if '*' in declaration['type'] and not declaration['type'].startswith('character'):
                    reasons.append('nonstandard kind syntax')
                if any(re.match(r"[bozx]['\"]|\d+[hH]", v, re.I) for v in cells.values()):
                    reasons.append('bit-pattern or Hollerith initialization')
                if not reasons:
                    constants[variable] = [cells[index] for _, index in expected]
            rejected[name] = {n: r for n, r in bad.items() if r}
            if constants:
                selected[name] = {'source_hash': code_hash(body), 'constants': constants}
        except (ValueError, KeyError) as error:
            unsupported[name] = str(error)
    return {'procedures': selected, 'retained': {n: v for n, v in rejected.items() if v},
            'unsupported_procedures': unsupported,
            'summary': {'procedures': len(selected), 'constants': sum(len(e['constants']) for e in selected.values())}}


def verify_values(before, after, manifest):
    for scope, entry in manifest['procedures'].items():
        for variable in entry['constants']:
            old, new = before[scope][variable], after[scope][variable]
            for field in ('type spec', 'Array spec', 'value'):
                if old.get(field) != new.get(field):
                    raise ValueError(f'{scope}:{variable}: compiler {field} changed: {old.get(field)} -> {new.get(field)}')
            if 'PARAMETER' not in new.get('attributes', ''):
                raise ValueError(f'{scope}:{variable}: compiler did not confirm PARAMETER')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--compiler', default='gfortran')
    args = parser.parse_args()
    if args.output.exists():
        parser.error('Output must name a new review file')
    source = format_source(lowercase(convert_text((ROOT / 'nswc.f').read_text(encoding='ascii'))))
    with tempfile.TemporaryDirectory(prefix='nswc-data-review-') as work:
        folder = Path(work)
        before, _ = compile_dump(source, folder, 'before', args.compiler)
        manifest = review(source, before)
        transformed = transform(source, manifest)
        after, _ = compile_dump(transformed, folder, 'after', args.compiler)
        verify_values(before, after, manifest)
    args.output.write_text(json.dumps(manifest, indent=2) + '\n', encoding='ascii', newline='\n')
    print(json.dumps(manifest['summary']), flush=True)
    print('Compiler types, bounds and initialized values agree for every converted object.', flush=True)


if __name__ == '__main__':
    main()
