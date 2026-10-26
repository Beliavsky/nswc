"""Replace arithmetic IF using reviewed compiler expression types.

Repeated destinations need one comparison. Three distinct destinations use a
local temporary, assigned once, in the expression's original numeric type.
The review probe uses ASSOCIATE only for compiler type inference; maintained
Fortran sources use ordinary Fortran 90 declarations, assignments and IFs.
"""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import units
from format_free_form import TOKEN
from name_procedure_ends import statements, code_comment

MANIFEST = Path(__file__).with_name('arithmetic-if.json')
PATTERN = re.compile(r'^\s*IF\s*\((.*)\)\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*$', re.I)
TYPES = {'INTEGER 4': 'INTEGER', 'REAL 4': 'REAL', 'REAL 8': 'DOUBLE PRECISION'}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def candidates(data):
    lines, scopes = units(data)
    result = []
    all_statements = list(statements(lines))
    for name, (start, _, end) in scopes.items():
        unit = [s for s in all_statements if start <= s.lines[0] < end]
        terminals = {str(int(m[1])) for s in unit
                     if (m := re.match(r'^\s*DO\s+(\d+)\s+', s.code, re.I))}
        for s in unit:
            if not (m := PATTERN.fullmatch(s.code)):
                continue
            label = lines[s.lines[0]][:5].strip()
            if label and str(int(label)) in terminals:
                raise ValueError(f'{name}: arithmetic IF is a DO terminal; review separately')
            if any(len(lines[i].rstrip('\r\n')) > 72 for i in s.lines):
                raise ValueError(f'{name}: sequence field on arithmetic IF needs review')
            result.append({'procedure': name, 'lines': list(s.lines), 'expression': m[1].strip(),
                           'targets': list(m.groups()[1:]), 'label': label,
                           'probe': f'nswc_ai_probe_{len(result) + 1}'})
    return lines, scopes, result


def emit(code, label='', indent='', newline='\n'):
    """Wrap at token boundaries without splitting literals or exponent tokens."""
    tokens = []
    for match in TOKEN.finditer(code):
        token = match[0]
        if token == ':' and tokens and tokens[-1] == ':':
            tokens[-1] = '::'
        else:
            tokens.append(token)
    # The fixed-to-free converter treats adjacent identifier/number fragments
    # across records as a split token. Keep the branch action intact so TO and
    # its label cannot become the invalid free-form identifier TO160.
    groups, i = [], 0
    while i < len(tokens):
        if [t.upper() for t in tokens[i:i + 2]] == ['GO', 'TO'] and i + 2 < len(tokens) and tokens[i + 2].isdigit():
            groups.append(' '.join(tokens[i:i + 3]))
            i += 3
        else:
            groups.append(tokens[i])
            i += 1
    tokens = groups
    output, pending = [], ''
    prefix = label.rjust(5) + ' ' + indent
    for token in tokens:
        if len(prefix + pending + ' ' + token) > 72 and pending:
            output.append(prefix + pending + newline)
            prefix, pending = '     &' + indent, ''
        pending += (' ' if pending else '') + token
        if len(prefix + pending) > 72:
            raise ValueError('Arithmetic IF replacement token exceeds fixed-form width')
    output.append(prefix + pending + newline)
    return ''.join(output)


def compile_dump(data, compiler='gfortran'):
    with tempfile.TemporaryDirectory(prefix='nswc-arithmetic-if-') as work:
        path = Path(work) / 'input.f'
        path.write_bytes(data)
        result = subprocess.run([compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                                 '-fsyntax-only', '-fdump-fortran-original', str(path)],
                                cwd=work, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError(result.stderr)
        return result.stdout, result.stderr


def review(data, compiler='gfortran'):
    from validate_explicit_typing import symbols
    lines, scopes, records = candidates(data)
    edits, removed = {}, set()
    for r in records:
        if len(set(map(int, r['targets']))) == 2:
            continue
        line = r['lines'][0]
        if re.search(r'\bNSWC_AI_\w*\b', ''.join(lines[scopes[r['procedure']][0]:scopes[r['procedure']][2]]), re.I):
            raise ValueError('Arithmetic IF helper name already used')
        label = r['label']
        edits[line] = (emit(f"ASSOCIATE ({r['probe']} => ({r['expression']}))", label) +
                       emit(f"IF ({r['probe']}) " + ','.join(r['targets'])) + emit('END ASSOCIATE'))
        removed.update(r['lines'])
    probe = ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines)).encode('latin-1')
    inventory = symbols(compile_dump(probe, compiler)[0], True)
    declarations = defaultdict(dict)
    for r in records:
        if len(set(map(int, r['targets']))) == 2:
            r['temporary'] = None
        else:
            kind = inventory[r['procedure']][r['probe']]['type spec']
            kind = re.fullmatch(r'type spec : \((.+)\)', kind)[1]
            if kind not in TYPES:
                raise ValueError(f"Unsupported expression type: {kind}")
            r['type'] = kind
            r['temporary'] = 'NSWC_AI_' + kind.replace('INTEGER ', 'I').replace('REAL ', 'R')
            declarations[r['procedure']][r['temporary']] = TYPES[kind]
        r.pop('probe')
    manifest = {'input_sha256': digest(data), 'records': records,
                'declarations': dict(declarations), 'converted': len(records),
                'destination_counts': {str(k): v for k, v in Counter(
                    len(set(map(int, r['targets']))) for r in records).items()}}
    manifest['output_sha256'] = digest(transform(data, manifest))
    return manifest


def transform(data, manifest=None):
    if manifest is None:
        manifest = json.loads(MANIFEST.read_text())
    if digest(data) == manifest.get('output_sha256'):
        return data
    if digest(data) != manifest['input_sha256']:
        raise ValueError('Arithmetic IF input differs from the reviewed source')
    lines, scopes, actual = candidates(data)
    entries = manifest['records']
    if [{k: r[k] for k in ('procedure', 'lines', 'expression', 'targets', 'label')} for r in actual] != [
            {k: r[k] for k in ('procedure', 'lines', 'expression', 'targets', 'label')} for r in entries]:
        raise ValueError('Arithmetic IF candidate inventory differs from review')
    edits, removed, insertions = {}, set(), defaultdict(str)
    for r in entries:
        first = r['lines'][0]
        raw = lines[first].rstrip('\r\n')
        newline = lines[first][len(raw):]
        indent = re.match(r'\s*', raw[6:])[0]
        n, z, p = r['targets']
        ni, zi, pi = map(int, (n, z, p))
        expr = r['expression']
        temporary = r['temporary']
        if temporary:
            codes = [f'{temporary} = {expr}']
            if ni == zi == pi:
                codes += [f'GO TO {n}']
            else:
                codes += [f'IF ({temporary} .LT. 0) GO TO {n}',
                          f'IF ({temporary} .EQ. 0) GO TO {z}', f'GO TO {p}']
        elif ni == zi:
            codes = [f'IF (({expr}) .LE. 0) GO TO {n}', f'GO TO {p}']
        elif zi == pi:
            codes = [f'IF (({expr}) .LT. 0) GO TO {n}', f'GO TO {z}']
        elif ni == pi:
            codes = [f'IF (({expr}) .EQ. 0) GO TO {z}', f'GO TO {n}']
        else:
            raise ValueError('Three-way arithmetic IF lacks a reviewed temporary')
        edits[first] = ''.join(emit(code, r['label'] if i == 0 else '', indent, newline)
                               for i, code in enumerate(codes))
        quote = ''
        for i in r['lines']:
            _, comment, quote = code_comment(lines[i].rstrip('\r\n')[6:72], quote)
            if comment:
                edits[i] = edits.get(i, '') + '      ' + comment + newline
        removed.update(r['lines'])
    for name, declarations in manifest['declarations'].items():
        start, _, end = scopes[name]
        anchor = None
        for s in statements(lines[start:end]):
            if re.match(r'^\s*(?:INTEGER|REAL|DOUBLE\s+PRECISION|COMPLEX|LOGICAL|CHARACTER|EXTERNAL|INTRINSIC)\b', s.code, re.I):
                anchor = start + s.lines[-1] + 1
        if anchor is None:
            raise ValueError(f'{name}: no declaration insertion point')
        for variable, type_name in declarations.items():
            insertions[anchor] += emit(f'{type_name} :: {variable}')
    changed = ''.join(insertions[i] + edits.get(i, '' if i in removed else line) for i, line in enumerate(lines))
    result = changed.encode('latin-1')
    if manifest.get('output_sha256') and digest(result) != manifest['output_sha256']:
        raise ValueError('Arithmetic IF output differs from the reviewed source')
    return result


def verify(before, after, manifest, compiler='gfortran'):
    from validate_explicit_typing import symbols, non_declaration_content
    if transform(before, manifest) != after:
        raise ValueError('Source edit differs from reviewed arithmetic IF replacements')
    if non_declaration_content(before)[1] != non_declaration_content(after)[1]:
        raise ValueError('Arithmetic IF conversion changed the comment stream')
    old, old_warnings = compile_dump(before, compiler)
    new, new_warnings = compile_dump(after, compiler)
    old, new = symbols(old, True), symbols(new, True)
    for name, declarations in manifest['declarations'].items():
        for variable, type_name in declarations.items():
            entry = new[name].pop(variable.lower())
            expected = next(k for k, v in TYPES.items() if v == type_name)
            if entry.get('type spec') != f'type spec : ({expected})':
                raise ValueError(f'{name}: temporary type differs from expression')
    if old != new:
        raise ValueError('Arithmetic IF conversion changed existing compiler symbol records')
    warnings = lambda s: re.findall(r'^(?:Warning|Error):.*', s, re.M)
    if warnings(old_warnings) != warnings(new_warnings):
        raise ValueError('Arithmetic IF conversion changed legacy-build warnings')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--manifest', type=Path, default=MANIFEST)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--review', action='store_true')
    parser.add_argument('--compiler', default='gfortran')
    args = parser.parse_args()
    if args.output and args.output.exists():
        parser.error('Output must be a new file')
    if args.review and args.manifest.exists():
        parser.error('A new review must use a new manifest file')
    if args.output and args.output.resolve() == args.manifest.resolve():
        parser.error('Output and manifest must be separate files')
    before = args.source.read_bytes()
    manifest = review(before, args.compiler) if args.review else json.loads(args.manifest.read_text())
    after = transform(before, manifest)
    if before != after:
        verify(before, after, manifest, args.compiler)
    if args.review:
        with args.manifest.open('x') as f:
            f.write(json.dumps(manifest, indent=2) + '\n')
    if args.output:
        with args.output.open('xb') as f:
            f.write(after)
    if before == after:
        print('Source already matches the reviewed arithmetic IF output.')
    else:
        print(f"Converted {manifest['converted']} arithmetic IF statements; existing compiler symbols agree.")


if __name__ == '__main__':
    main()
