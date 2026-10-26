"""Replace remaining safe labelled DOs, including executable/shared terminals.

Keep every existing statement label and terminal operation. Close shared loops
inside out after that operation. Refuse crossing boundaries, indirect branches,
possible entries from outside a loop, continued headers and sequence fields.
Numeric mentions deliberately overestimate branches: uncertain loops are left
for review. This is a second pass; historical modernize_do.py stays unchanged.
"""
import argparse
from collections import Counter, defaultdict
import csv
from dataclasses import dataclass
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import units
from modernize_do import Loop, masked, has_comma
from name_procedure_ends import statements, split_line, code_comment


@dataclass
class Result:
    data: bytes
    loops: tuple


def transform(data):
    lines, scopes = units(data)
    all_statements = list(statements(lines))
    edits, insertions, report = {}, defaultdict(list), []
    for name, (start, _, stop) in scopes.items():
        unit = [s for s in all_statements if start <= s.lines[0] < stop]
        codes = [re.sub(r'\s+', '', masked(s.code)).upper() for s in unit]
        labels, mentions, headers = {}, defaultdict(set), {}
        for i, (s, code) in enumerate(zip(unit, codes)):
            label = lines[s.lines[0]][:5].strip()
            if label:
                label = str(int(label))
                if label in labels:
                    raise ValueError(f'{name}: duplicate label {label}')
                labels[label] = i
            for token in re.findall(r'\d+', code):
                mentions[str(int(token))].add(i)
            match = re.match(r'^DO(\d+)([A-Z][A-Z0-9_]*=.*)$', code)
            if match and has_comma(match[2]):
                headers[i] = str(int(match[1]))
        if not headers:
            continue
        reason = ''
        if any(c.startswith('ASSIGN') or re.search(r'GOTO[A-Z_]', c) for c in codes):
            reason = 'procedure has assigned/indirect control flow'
        stack, intervals = [], {}
        for i, code in enumerate(codes):
            if i in headers:
                stack.append((i, headers[i]))
            elif re.match(r'^DO(?:[A-Z][A-Z0-9_]*=|WHILE\(|$)', code):
                stack.append((i, None))
            if code == 'ENDDO':
                if not stack or stack[-1][1] is not None:
                    reason = 'unmatched or crossing loop boundaries'
                else:
                    stack.pop()
            label = lines[unit[i].lines[0]][:5].strip()
            label = str(int(label)) if label else None
            if label and any(target == label for _, target in stack):
                if stack[-1][1] != label:
                    reason = 'unmatched or crossing loop boundaries'
                while stack and stack[-1][1] == label:
                    first, _ = stack.pop()
                    intervals[first] = i
        if stack:
            reason = 'unmatched or crossing loop boundaries'
        candidates = {}
        for first, target in headers.items():
            last = intervals.get(first)
            why = reason
            if last is None:
                why = why or 'missing or crossing terminal'
            if not why:
                if len(unit[first].lines) != 1:
                    why = 'continued DO header'
                elif len(lines[unit[first].lines[0]].rstrip('\r\n')) > 72:
                    why = 'DO header has sequence field'
                elif any(first < position <= last and
                         any((ref < first or ref > last) and ref not in headers
                             for ref in mentions[label])
                         for label, position in labels.items()):
                    why = 'possible branch into loop from outside'
            candidates[first] = [last, target, why]
        # A shared terminal group is transformed together. A remaining old DO
        # must not end at a statement inside a newly introduced block DO.
        groups = defaultdict(list)
        for first, (last, target, why) in candidates.items():
            groups[target].append(first)
        for firsts in groups.values():
            if any(candidates[f][2] for f in firsts):
                for f in firsts:
                    candidates[f][2] = candidates[f][2] or 'shared terminal group needs review'
        for first, (last, target, why) in candidates.items():
            if not why:
                line = unit[first].lines[0]
                body, newline = split_line(lines[line])
                field, comment, _ = code_comment(body[6:72])
                match = re.match(r'(\s*)DO\s*\d+\s*(.*)', field, re.I)
                if not match:
                    raise ValueError(f'{name}: cannot locate DO header')
                replacement = body[:6] + match[1] + 'DO ' + match[2].rstrip()
                if comment:
                    replacement += '  ' + comment
                if len(replacement) > 72:
                    raise ValueError(f'{name}: DO header exceeds fixed width')
                edits[line] = replacement + newline
                insertions[unit[last].lines[-1]].append((first, '      ' + match[1] + 'END DO' + newline))
            report.append(Loop(name, unit[first].lines[0] + 1,
                               unit[last].lines[-1] + 1 if last is not None else None,
                               target, 'skipped' if why else 'converted', why))
    output = []
    for i, line in enumerate(lines):
        output.append(edits.get(i, line))
        # Larger header indices are inner loops.
        output.extend(s for _, s in sorted(insertions.get(i, []), reverse=True))
    return Result(''.join(output).encode('latin-1'), tuple(report))


def verify(before, after, compiler='gfortran'):
    """Require equal symbol records and assembly except diagnostic line text."""
    from validate_explicit_typing import symbols
    records, assembly, warnings = [], [], []
    with tempfile.TemporaryDirectory(prefix='nswc-deleted-do-') as work:
        path = Path(work) / 'input.f'
        for data in (before, after):
            path.write_bytes(data)
            result = subprocess.run([compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                                     '-fdump-fortran-original', '-S', str(path), '-o', 'input.s'],
                                    cwd=work, capture_output=True, text=True, timeout=180)
            if result.returncode:
                raise RuntimeError(result.stderr)
            records.append(symbols(result.stdout, True))
            warnings.append(re.findall(r'^(?:Warning|Error):.*', result.stderr, re.M))
            lines = (Path(work) / 'input.s').read_text().splitlines()
            for i, line in enumerate(lines):
                if re.match(r'^\s*\.(?:ascii|string)\s', line):
                    line = re.sub(r'\bAt line \d+ of file\b', 'At line <source> of file', line)
                    lines[i] = re.sub(r'\baround line \d+\b', 'around line <source>', line)
            assembly.append(lines)
    if records[0] != records[1]:
        raise ValueError('DO modernization changed compiler symbol records')
    if warnings[0] != warnings[1]:
        raise ValueError('DO modernization changed legacy-build warnings')
    if assembly[0] != assembly[1]:
        import difflib
        diff = ''.join(difflib.unified_diff(assembly[0], assembly[1], lineterm='\n'))
        raise ValueError('DO modernization changed assembly beyond diagnostic line text:\n' + diff[:4000])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--report', type=Path)
    parser.add_argument('--compiler')
    args = parser.parse_args()
    for path in (args.output, args.report):
        if path is not None and path.exists():
            parser.error(f'Output/report must be a new file: {path}')
    if args.output and args.report and args.output.resolve() == args.report.resolve():
        parser.error('Output and report must be separate files')
    original = args.source.read_bytes()
    result = transform(original)
    if args.compiler:
        verify(original, result.data, args.compiler)
    if args.output:
        with args.output.open('xb') as f:
            f.write(result.data)
    if args.report:
        with args.report.open('x', newline='') as f:
            writer = csv.writer(f, lineterminator='\n')
            writer.writerow(Loop.__dataclass_fields__)
            writer.writerows(vars(r).values() for r in result.loops)
    print(Counter(r.status for r in result.loops))
    print(Counter(r.reason for r in result.loops if r.reason))


if __name__ == '__main__':
    main()
