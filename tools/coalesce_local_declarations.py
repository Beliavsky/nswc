"""Combine matching local declarations in contiguous free-form type blocks.

Unlike xcombine_decl.py's adjacent single-entity rule, merge multi-entity
declarations across intervening types. Arguments, results, procedures, storage
aliases, initializers, comments and specification dependencies are protected.
"""
import argparse
from pathlib import Path
import re
import subprocess
import tempfile

from combine_declarations import type_declaration
from format_free_form import TOKEN, groups
from fortran_procedures import procedure_spans


def parsed(physical, logical):
    if ('::' not in logical or re.search(r',\s*parameter\b', logical, re.I)
            or any(r.comment or r.continued_string for r in physical)
            or [r.index for r in physical] != list(range(physical[0].index, physical[-1].index + 1))
            or re.match(r'^\s*\d+\s', physical[0].code)):
        return None
    try:
        decl = type_declaration(logical)
    except ValueError:
        return None
    if not decl:
        return None
    typ, attrs, items = decl
    if typ.startswith('CHARACTER') or any(a.lower() in ('parameter', 'external', 'intrinsic') for a in attrs):
        return None
    names = {n.lower() for n, _, _ in items}
    arrays = {n.lower() for n, shape, _ in items if shape}
    if any(re.match(r'dimension\b', a, re.I) for a in attrs):
        arrays |= names
    expressions = ' '.join([re.sub(r'^[A-Z ]+', '', typ), *attrs,
                            *[shape + length for _, shape, length in items]])
    refs = {m[0].lower() for m in TOKEN.finditer(expressions) if re.fullmatch(r'[A-Za-z_]\w*', m[0])}
    indent = re.match(r'^\s*', physical[0].code)[0]
    return {'records': physical, 'type': typ, 'attrs': attrs, 'items': items,
            'names': names, 'arrays': arrays, 'refs': refs,
            'prefix': logical.split('::', 1)[0].strip(), 'indent': indent,
            'key': (typ.lower(), tuple(re.sub(r'\s+', '', a.lower()) for a in attrs), indent)}


def emit(decls, max_len):
    first = decls[0]
    entities = [n + shape + length for decl in decls for n, shape, length in decl['items']]
    prefix = first['indent'] + first['prefix'] + ' :: '
    continuation = first['indent'] + '   & '
    newline = first['records'][0].newline or '\n'
    output, line, has_entity = [], prefix, False
    for i, entity in enumerate(entities):
        addition = (', ' if has_entity else '') + entity
        reserve = 3 if i + 1 < len(entities) else 0
        if len(line + addition) + reserve > max_len:
            tail = ', &' if has_entity else '&'
            if len(line + tail) > max_len or len(continuation + entity) + reserve > max_len:
                return None
            output.append(line + tail + newline)
            line, has_entity = continuation + entity, True
        else:
            line += addition
            has_entity = True
    output.append(line + newline)
    return ''.join(output)


def transform(text, report=None, max_len=132):
    lines, output, previous = text.splitlines(True), [], 0
    stats = {'procedures': 0, 'changed_procedures': 0, 'merged_groups': 0, 'declarations_removed': 0}
    for name, start, end in procedure_spans(text):
        stats['procedures'] += 1
        body = lines[start:end]
        statements, depth = [], 0
        for physical, logical in groups(body):
            opening = bool(re.match(r'^\s*(?:abstract\s+)?interface\b', logical, re.I))
            closing = bool(re.match(r'^\s*end\s*interface\b', logical, re.I))
            if depth:
                depth += opening - closing
                if not depth:
                    statements.append((physical, logical, None))
                continue
            if opening:
                depth = 1
            statements.append((physical, logical, None if opening else parsed(physical, logical)))
        header = statements[0][1]
        args = re.search(r'\b(?:function|subroutine)\s+\w+\s*\(([^)]*)\)', header, re.I)
        protected = {n.strip().lower() for n in args[1].split(',')} if args else set()
        protected.add(name.lower())
        result = re.search(r'\bresult\s*\(\s*(\w+)\s*\)', header, re.I)
        if result:
            protected.add(result[1].lower())
        arrays = set().union(*(d['arrays'] for _, _, d in statements if d))
        for _, logical, _ in statements:
            if re.match(r'^\s*(?:external|intrinsic|common|equivalence)\b', logical, re.I):
                protected.update(re.findall(r'[A-Za-z_]\w*', logical.lower()))
            tokens = [m[0].lower() for m in TOKEN.finditer(logical)]
            protected.update(t for t, following in zip(tokens, tokens[1:])
                             if following == '(' and t not in arrays and re.fullmatch(r'[a-z_]\w*', t))
        edits, removed, run, changed = {}, set(), [], False

        def flush():
            nonlocal changed
            if not run:
                return
            owners = set().union(*(d['names'] for d in run))
            segments, segment = [], []
            # A declaration using another local's type/bound is a barrier.
            for decl in run:
                if decl['refs'] & owners:
                    segments.append(segment)
                    segment = []
                else:
                    segment.append(decl)
            segments.append(segment)
            for segment in segments:
                buckets = {}
                for decl in segment:
                    buckets.setdefault(decl['key'], []).append(decl)
                for matches in buckets.values():
                    if len(matches) < 2:
                        continue
                    replacement = emit(matches, max_len)
                    if replacement is None:
                        continue
                    stats['merged_groups'] += 1
                    stats['declarations_removed'] += len(matches) - 1
                    changed = True
                    edits[matches[0]['records'][0].index] = replacement
                    removed.update(r.index for decl in matches for r in decl['records'])
            run.clear()

        previous_record = -1
        for physical, logical, decl in statements[1:]:
            if decl is None or decl['names'] & protected or physical[0].index != previous_record + 1:
                flush()
            if decl is not None and not decl['names'] & protected:
                run.append(decl)
            elif not re.match(r'^\s*(?:implicit|use|import|external|intrinsic|parameter|save|common|equivalence|data|dimension|namelist|optional|intent|public|private|interface|abstract\s+interface|end\s*interface|integer|real|double\s+(?:precision|complex)|complex|logical|character)\b', logical, re.I):
                break
            previous_record = physical[-1].index
        flush()
        stats['changed_procedures'] += changed
        output.extend(lines[previous:start])
        output.extend(edits.get(i, '' if i in removed else line) for i, line in enumerate(body))
        previous = end
    output.extend(lines[previous:])
    if report is not None:
        report.update(stats)
    return ''.join(output)


def verify(before, after, compiler='gfortran'):
    from generic_intrinsics import compile_dump
    with tempfile.TemporaryDirectory(prefix='nswc-coalesce-check-') as work:
        original = compile_dump(before, work, compiler)
        combined = compile_dump(after, work, compiler)
    if original[0] != combined[0]:
        raise ValueError('Coalescing changed compiler symbols or executable trees')
    warnings = lambda value: re.findall(r'^(?:Warning|Error):.*', value, re.M)
    if warnings(original[1]) != warnings(combined[1]):
        raise ValueError('Coalescing changed compiler diagnostics')
    if original[2] != combined[2]:
        # Removing source lines changes embedded runtime-error locations.
        # Require identical assembly after normalizing only those strings.
        assembly = []
        with tempfile.TemporaryDirectory(prefix='nswc-coalesce-assembly-') as work:
            path = Path(work) / 'input.f90'
            for text in (before, after):
                path.write_text(text, encoding='ascii', newline='\n')
                result = subprocess.run([compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                                         '-S', str(path), '-o', 'input.s'], cwd=work,
                                        capture_output=True, text=True, timeout=180)
                if result.returncode:
                    raise RuntimeError(result.stderr)
                lines = (Path(work) / 'input.s').read_text().splitlines()
                for i, line in enumerate(lines):
                    if re.match(r'^\s*\.(?:ascii|string)\s', line):
                        line = re.sub(r'\bAt line \d+ of file\b', 'At line <source> of file', line)
                        lines[i] = re.sub(r'\baround line \d+\b', 'around line <source>', line)
                assembly.append(lines)
        if assembly[0] != assembly[1]:
            raise ValueError('Coalescing changed assembly beyond runtime diagnostic line numbers')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--max-len', type=int, default=132)
    parser.add_argument('--compiler', help='Verify complete GNU compiler dumps before writing')
    args = parser.parse_args()
    if args.max_len < 20:
        parser.error('--max-len must be at least 20')
    text, report = args.source.read_text(encoding='ascii'), {}
    combined = transform(text, report, args.max_len)
    if args.compiler:
        verify(text, combined, args.compiler)
        print('Complete compiler records, trees and assembly are unchanged except diagnostic line numbers.')
    args.output.write_text(combined, encoding='ascii', newline='\n')
    print(report)


if __name__ == '__main__':
    main()
