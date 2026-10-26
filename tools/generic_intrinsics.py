"""Replace reviewed, compiler-confirmed intrinsic calls with generic names.

Conversion intrinsics and intrinsics used as procedure arguments are excluded.
Normal source regeneration needs only the checked-in review and standard library.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile

from combine_declarations import split_list, type_declaration
from format_free_form import TOKEN, groups, wrap_line
from fortran_procedures import procedure_blocks, procedure_spans
from procedure_purity import code_hash
from validate_explicit_typing import symbols

MANIFEST = Path(__file__).with_name('generic-intrinsics.json')
MAPPING = {
    'alog': 'log', 'alog10': 'log10', 'amax1': 'max', 'amin1': 'min',
    'cabs': 'abs', 'ccos': 'cos', 'cexp': 'exp', 'clog': 'log',
    'csin': 'sin', 'csqrt': 'sqrt', 'dabs': 'abs', 'datan': 'atan',
    'datan2': 'atan2', 'dcos': 'cos', 'dexp': 'exp', 'dlog': 'log',
    'dmax1': 'max', 'dmin1': 'min', 'dsign': 'sign', 'dsin': 'sin',
    'dsqrt': 'sqrt', 'iabs': 'abs', 'isign': 'sign', 'max0': 'max', 'min0': 'min',
}
# GNU's frontend retains these specific names until later lowering. The
# generic forms already carry type/kind suffixes at the dump stage.
LOWERED_NAMES = {'amax1': '__max_r4', 'amin1': '__min_r4',
                 'dmax1': '__max_r8', 'dmin1': '__min_r8',
                 'max0': '__max_i4', 'min0': '__min_i4'}


def declaration(logical):
    if re.search(r',\s*parameter\b', logical, re.I):
        return None
    return type_declaration(logical)


def review(text, inventory):
    selected, retained = {}, {}
    library = {n.lower() for n in procedure_blocks(text)}
    for name, body in procedure_blocks(text).items():
        records = inventory[name]
        candidates = {alias: target for alias, target in MAPPING.items()
                      if 'INTRINSIC-PROC' in records.get(alias, {}).get('attributes', '')}
        calls, reasons = {}, {}
        for alias, target in candidates.items():
            if target in library or (target in records and
                    'INTRINSIC-PROC' not in records[target].get('attributes', '')):
                reasons[alias] = 'generic name conflicts with a data object or procedure'
        for physical, logical in groups(body.splitlines(True)):
            decl = declaration(logical)
            intrinsic = re.match(r'^\s*intrinsic\b', logical, re.I)
            if decl or intrinsic:
                names = {n.lower() for n, _, _ in decl[2]} if decl else set(re.findall(r'\w+', logical.lower()))
                for alias in candidates.keys() & names:
                    if any(r.comment or r.continued_string for r in physical):
                        reasons[alias] = 'annotated or continued-string declaration requires review'
                continue
            tokens = [m[0].lower() for m in TOKEN.finditer(logical)]
            if tokens[:1] == ['format']:
                continue
            for i, token in enumerate(tokens):
                if token not in candidates:
                    continue
                if tokens[i + 1:i + 2] != ['(']:
                    reasons[token] = 'non-call use, including a possible procedure argument'
                elif any(r.continued_string for r in physical):
                    reasons[token] = 'continued-string statement requires review'
                else:
                    calls[token] = calls.get(token, 0) + 1
        calls = {alias: count for alias, count in calls.items() if alias not in reasons}
        if calls:
            selected[name] = {'source_hash': code_hash(body), 'calls': calls}
        if reasons:
            retained[name] = reasons
    return {'mapping': MAPPING, 'procedures': selected, 'retained': retained,
            'summary': {'procedures': len(selected),
                        'calls': sum(sum(e['calls'].values()) for e in selected.values())}}


def transform(text, manifest=None):
    manifest = json.loads(MANIFEST.read_text()) if manifest is None else manifest
    if manifest['mapping'] != MAPPING:
        raise ValueError('Generic intrinsic mapping needs review')
    lines, output, previous = text.splitlines(True), [], 0
    for name, start, end in procedure_spans(text):
        entry = manifest['procedures'].get(name)
        if entry is None:
            continue
        body = ''.join(lines[start:end])
        if code_hash(body) != entry['source_hash']:
            raise ValueError(f'{name}: code changed since generic intrinsic review')
        selected = set(entry['calls'])
        edits, removed, counts = {}, set(), dict.fromkeys(selected, 0)
        for physical, logical in groups(body.splitlines(True)):
            decl = declaration(logical)
            intrinsic = re.match(r'^\s*intrinsic\s+(?:::)?\s*(.*)', logical, re.I)
            replacement = None
            if decl and selected & {n.lower() for n, _, _ in decl[2]}:
                kept = [(n, s, l) for n, s, l in decl[2] if n.lower() not in selected]
                replacement = logical.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(n + s + l for n, s, l in kept) if kept else ''
            elif intrinsic:
                names = split_list(intrinsic[1])
                if selected & {n.lower() for n in names}:
                    replacement = 'intrinsic :: ' + ', '.join(dict.fromkeys(MAPPING.get(n.lower(), n) if n.lower() in selected else n for n in names))
            if replacement is not None:
                if any(r.comment or r.continued_string for r in physical):
                    raise ValueError(f'{name}: annotated declaration needs review')
                removed.update(r.index for r in physical)
                if replacement:
                    edits[physical[0].index] = wrap_line('', replacement, '', '', physical[0].newline, 3)
                continue
            if decl or intrinsic or re.match(r'^\s*format\b', logical, re.I):
                continue
            tokens = [(r, m) for r in physical for m in TOKEN.finditer(r.code) if m[0] != '&']
            changes = {}
            for (record, token), (_, following) in zip(tokens, tokens[1:]):
                alias = token[0].lower()
                if alias in selected and following[0] == '(':
                    if record.continued_string:
                        raise ValueError(f'{name}: continued string needs review')
                    changes.setdefault(record.index, []).append((token.start(), token.end(), MAPPING[alias]))
                    counts[alias] += 1
            for record in physical:
                if record.index in changes:
                    code = record.code
                    for first, last, value in sorted(changes[record.index], reverse=True):
                        code = code[:first] + value + code[last:]
                    edits[record.index] = code + record.comment + record.newline
        if counts != entry['calls']:
            raise ValueError(f'{name}: reviewed call counts differ')
        output.extend(lines[previous:start])
        output.extend(edits.get(i, '' if i in removed else line) for i, line in enumerate(body.splitlines(True)))
        previous = end
    output.extend(lines[previous:])
    return ''.join(output)


def compile_dump(text, work, compiler='gfortran'):
    path = Path(work) / 'input.f90'
    path.write_text(text, encoding='ascii', newline='\n')
    obj = Path(work) / 'input.o'
    result = subprocess.run([compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                             '-c', '-fdump-fortran-original', str(path), '-o', str(obj)],
                            cwd=work, capture_output=True, text=True, timeout=180)
    if result.returncode:
        raise RuntimeError(result.stderr)
    return result.stdout, result.stderr, obj.read_bytes()


def normalized_dump(dump, manifest):
    """Omit only reviewed intrinsic symbol blocks; retain every executable tree."""
    output, scope = [], None
    chunks = re.split(r"(?m)(?=^  symtree:|^  code:|^procedure name =|^Namespace:)", dump)
    for chunk in chunks:
        match = re.match(r'procedure name = (\w+)', chunk)
        if match:
            scope = match[1].upper()
        match = re.match(r"  symtree: '([^']+)'", chunk)
        selected = manifest['procedures'].get(scope, {}).get('calls', {})
        names = set(selected) | {MAPPING[n] for n in selected}
        if match and match[1] in names and 'INTRINSIC-PROC' in chunk:
            continue
        for alias in selected:
            if alias in LOWERED_NAMES:
                chunk = chunk.replace('_gfortran_' + alias + '[[', LOWERED_NAMES[alias] + '[[')
        output.append(chunk)
    # A final intrinsic block may own the blank separator before the code tree.
    return '\n'.join(line for line in ''.join(output).splitlines() if line.strip())


def verify(before, after, manifest):
    if before[2] != after[2]:
        raise ValueError('Generic replacement changed the compiled object file')
    if normalized_dump(before[0], manifest) != normalized_dump(after[0], manifest):
        raise ValueError('Generic replacement changed unreviewed symbols or executable compiler trees')
    if before[1] != after[1]:
        # Locations and displayed source change when an intrinsic name shortens.
        warnings = lambda value: re.findall(r'^(?:Warning|Error):.*', value, re.M)
        if warnings(before[1]) != warnings(after[1]):
            raise ValueError('Generic replacement changed compiler diagnostics')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument('--review', type=Path, help='Write a new compiler-verified review')
    mode.add_argument('--output', type=Path)
    parser.add_argument('--manifest', type=Path, default=MANIFEST)
    parser.add_argument('--compiler', default='gfortran')
    args = parser.parse_args()
    source = args.source.read_text(encoding='ascii')
    if args.review:
        if args.review.exists():
            parser.error('Review output must name a new file')
        with tempfile.TemporaryDirectory(prefix='nswc-generic-review-') as work:
            before = compile_dump(source, work, args.compiler)
            manifest = review(source, symbols(before[0], True))
            after = compile_dump(transform(source, manifest), work, args.compiler)
            verify(before, after, manifest)
        args.review.write_text(json.dumps(manifest, indent=2) + '\n', encoding='ascii', newline='\n')
        print(json.dumps(manifest['summary']))
        print('Identical object files; unreviewed symbols and normalized executable trees are unchanged.')
    else:
        result = transform(source, json.loads(args.manifest.read_text()))
        args.output.write_text(result, encoding='ascii', newline='\n')


if __name__ == '__main__':
    main()
