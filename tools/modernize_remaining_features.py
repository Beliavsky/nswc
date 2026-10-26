"""Remove assigned-label transfers and finish labelled DO conversion.

Assigned-label variables must be local integers used only in ASSIGN, assigned
GO TO and declarations. Integer label values and SELECT CASE preserve every
valid target mapping. The final DO pass uses explicit branch edges rather than
numeric mentions; historical conservative passes keep their original behavior.
"""
import argparse
import functools
from collections import defaultdict, Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess

from explicit_typing import units
from modernize_arithmetic_if import emit
from modernize_deleted_do import transform as loops
from name_procedure_ends import statements, code_comment
from modernize_do import masked

MANIFEST = Path(__file__).with_name('remaining-features.json')
ASSIGN = re.compile(r'^\s*ASSIGN\s+(\d+)\s+TO\s+(\w+)\s*$', re.I)
GOTO = re.compile(r'^\s*GO\s*TO\s+([A-Z]\w*)\s*,?\s*\(([\d,\s]+)\)\s*$', re.I)


@functools.lru_cache(maxsize=None)
def strict_standard(compiler='gfortran'):
    """Use F2023 when supported; older GNU releases check the F2018 deletions."""
    for flag in ('-std=f2023', '-std=f2018'):
        result = subprocess.run([compiler, flag, '-x', 'f95', '-fsyntax-only', '-'],
                                input='end\n', capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            return flag
        if 'unrecognized command-line option' not in result.stderr:
            raise RuntimeError(result.stderr)
    raise RuntimeError('Compiler does not support strict Fortran 2018 or 2023 checks')


def assigned_labels(data):
    lines, scopes = units(data)
    edits, removed, report = {}, set(), []
    all_statements = list(statements(lines))
    for name, (start, _, stop) in scopes.items():
        unit = [s for s in all_statements if start <= s.lines[0] < stop]
        variables = {m[2].upper() for s in unit if (m := ASSIGN.fullmatch(s.code))}
        if not variables:
            continue
        declarations, assignments, dispatches = {}, defaultdict(set), defaultdict(list)
        for s in unit:
            code = masked(s.code).upper()
            used = variables & set(re.findall(r'\b[A-Z]\w*\b', code))
            if not used:
                continue
            a, g = ASSIGN.fullmatch(s.code), GOTO.fullmatch(s.code)
            if re.match(r'^\s*INTEGER\b', code):
                for v in used:
                    declarations[v] = True
                continue
            if a:
                assignments[a[2].upper()].add(int(a[1]))
                codes = [f'{a[2]} = {int(a[1])}']
                kind = 'assign'
            elif g:
                variable = g[1].upper()
                targets = list(map(int, re.findall(r'\d+', g[2])))
                if len(set(targets)) != len(targets):
                    raise ValueError(f'{name}: repeated dispatch target')
                dispatches[variable].append(targets)
                codes = [f'SELECT CASE ({variable})']
                for target in targets:
                    codes += [f'CASE ({target})', f'   GO TO {target}']
                codes += ['END SELECT']
                kind = 'dispatch'
            else:
                raise ValueError(f'{name}: assigned label variable has another use: {s.code}')
            if len(s.lines) != 1 or len(lines[s.lines[0]].rstrip('\r\n')) > 72:
                raise ValueError(f'{name}: assigned transfer layout requires review')
            i = s.lines[0]
            raw = lines[i].rstrip('\r\n');newline = lines[i][len(raw):]
            indent = re.match(r'\s*', raw[6:])[0]
            label = raw[:5].strip()
            edits[i] = ''.join(emit(c, label if j == 0 else '', indent, newline) for j, c in enumerate(codes))
            _, comment, _ = code_comment(raw[6:72])
            if comment:
                edits[i] += '      ' + comment + newline
            removed.update(s.lines)
            report.append({'procedure': name, 'line': i + 1, 'kind': kind,
                           'before': s.code.strip(), 'after': codes})
        if set(declarations) != variables or set(dispatches) != variables:
            raise ValueError(f'{name}: assigned-label declaration/dispatch inventory differs')
        labels = {int(lines[s.lines[0]][:5]) for s in unit if lines[s.lines[0]][:5].strip()}
        for v in variables:
            targets = set().union(*(set(t) for t in dispatches[v]))
            if not assignments[v] <= targets or not targets <= labels:
                raise ValueError(f'{name}: assigned-label targets are incomplete')
    result = ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines)).encode('latin-1')
    return result, report


def transform(data, report=None):
    assigned, transfers = assigned_labels(data)
    result = loops(assigned, precise=True)
    if report is not None:
        report.update({'input_sha256': hashlib.sha256(data).hexdigest(),
                       'output_sha256': hashlib.sha256(result.data).hexdigest(),
                       'transfers': transfers, 'loops': [vars(r) for r in result.loops],
                       'transfer_counts': dict(Counter(r['kind'] for r in transfers)),
                       'loop_counts': dict(Counter(r.status for r in result.loops))})
    return result.data


def verify(before, after, compiler='gfortran'):
    from modernize_arithmetic_if import compile_dump
    from modernize_deleted_do import verify as verify_loops
    from validate_explicit_typing import symbols, non_declaration_content
    if transform(before) != after:
        raise ValueError('Source edit is not exactly the remaining-feature conversion')
    assigned, transfers = assigned_labels(before)
    old, old_warnings = compile_dump(before, compiler)
    new, new_warnings = compile_dump(assigned, compiler)
    old, new = symbols(old, True), symbols(new, True)
    # GNU marks only these local scalar selectors with ASSIGN. Their numeric
    # types remain the same; the deleted-feature marker must disappear.
    for scope, variable in {(r['procedure'], ASSIGN.fullmatch(r['before'])[2].lower())
                            for r in transfers if r['kind'] == 'assign'}:
        entry = old[scope][variable]
        if (entry.get('attributes') != 'attributes: (VARIABLE ASSIGN)'
                or not re.fullmatch(r'type spec : \(INTEGER \d+\)', entry.get('type spec', ''))
                or set(entry) != {'attributes', 'type spec'}):
            raise ValueError(f'{scope}:{variable}: selector is not a local scalar integer')
        entry['attributes'] = 'attributes: (VARIABLE)'
    if old != new:
        raise ValueError('Assigned-label conversion changed existing compiler symbols')
    warnings = lambda s: re.findall(r'^(?:Warning|Error):.*', s, re.M)
    if warnings(old_warnings) != warnings(new_warnings):
        raise ValueError('Assigned-label conversion changed legacy-build warnings')
    if non_declaration_content(before)[1] != non_declaration_content(after)[1]:
        raise ValueError('Remaining-feature conversion changed the comment stream')
    verify_loops(assigned, after, compiler)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--report', type=Path)
    parser.add_argument('--compiler')
    args = parser.parse_args()
    for path in (args.output, args.report):
        if path is not None and path.exists():
            parser.error('Output/report must name a new file: ' + str(path))
    if args.output and args.report and args.output.resolve() == args.report.resolve():
        parser.error('Output and report must be separate files')
    report = {}
    result = transform(args.source.read_bytes(), report)
    if args.compiler:
        verify(args.source.read_bytes(), result, args.compiler)
    if args.output:
        with args.output.open('xb') as f:f.write(result)
    if args.report:
        with args.report.open('x') as f:f.write(json.dumps(report, indent=2) + '\n')
    print(report['transfer_counts'], report['loop_counts'])
    print(Counter(r['reason'] for r in report['loops'] if r['reason']))


if __name__ == '__main__':
    main()
