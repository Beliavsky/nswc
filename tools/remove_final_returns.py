"""Remove only unlabelled, unannotated plain RETURNs immediately before END.

Comments and blank lines may intervene. Labelled, conditional, alternate,
annotated and continued returns, and returns before other statements, survive.
The fixed-form scanner supports external procedures; free form also supports
module procedures while ignoring nested interface bodies.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import units
from format_free_form import groups
from fortran_procedures import procedure_spans
from name_procedure_ends import statements, code_comment


def plain(code):
    return re.sub(r'\s+', '', code).upper() == 'RETURN'


def transform_fixed(data, report=None):
    lines, scopes = units(data)
    removed, changes, retained = set(), {}, {}
    for name, (start, _, end) in scopes.items():
        body = list(statements(lines[start:end]))
        for statement in reversed(body[1:-1]):
            if not plain(statement.code):
                break
            index = start + statement.lines[0]
            raw = lines[index].rstrip('\r\n')
            reason = ('labelled' if raw[:5].strip() else 'continued' if len(statement.lines) != 1
                      else 'annotated' if code_comment(raw[6:72])[1] or raw[72:].strip() else None)
            if reason:
                retained[name] = reason
                break
            removed.add(index)
            changes[name] = changes.get(name, 0) + 1
    result = ''.join(line for i, line in enumerate(lines) if i not in removed).encode('latin-1')
    if report is not None:
        report.update({'form': 'fixed', 'procedures': len(scopes), 'removed': len(removed),
                       'removed_by_procedure': changes, 'retained_terminal_returns': retained,
                       'input_sha256': hashlib.sha256(data).hexdigest(),
                       'output_sha256': hashlib.sha256(result).hexdigest()})
    return result


def transform_free(text, report=None):
    lines, removed, changes, retained = text.splitlines(True), set(), {}, {}
    spans = list(procedure_spans(text))
    for name, start, end in spans:
        body = list(groups(lines[start:end]))
        for physical, logical in reversed(body[1:-1]):
            if not plain(logical):
                break
            record = physical[0]
            reason = ('labelled' if re.match(r'^\s*\d+\s', record.code) else
                      'continued' if len(physical) != 1 else 'annotated' if record.comment else None)
            if reason:
                retained[name] = reason
                break
            removed.add(start + record.index)
            changes[name] = changes.get(name, 0) + 1
    result = ''.join(line for i, line in enumerate(lines) if i not in removed)
    if report is not None:
        report.update({'form': 'free', 'procedures': len(spans), 'removed': len(removed),
                       'removed_by_procedure': changes, 'retained_terminal_returns': retained})
    return result


def normalized_dump(dump):
    # GNU's frontend retains explicit RETURN nodes. Only a plain terminal node
    # immediately before the procedure separator is equivalent to falling out.
    pattern = r'(?m)^[ \t]+RETURN[ \t]*\n(?=[ \t\r\n]*(?:-{5,}|Namespace:|$))'
    previous = None
    while previous != dump:
        previous, dump = dump, re.sub(pattern, '', dump)
    return dump


def verify(before, after, form='free', compiler='gfortran'):
    dumps, warnings = [], []
    with tempfile.TemporaryDirectory(prefix='nswc-final-return-check-') as work:
        path = Path(work) / ('input.f' if form == 'fixed' else 'input.f90')
        for text in (before, after):
            path.write_bytes(text if isinstance(text, bytes) else text.encode('ascii'))
            result = subprocess.run([compiler, '-std=legacy', '-fallow-argument-mismatch',
                                     '-fsyntax-only', '-fdump-fortran-original', str(path)],
                                    cwd=work, capture_output=True, text=True, timeout=180)
            if result.returncode:
                raise RuntimeError(result.stderr)
            dumps.append(normalized_dump(result.stdout))
            warnings.append(re.findall(r'^(?:Warning|Error):.*', result.stderr, re.M))
    if dumps[0] != dumps[1]:
        raise ValueError('Final RETURN cleanup changed compiler records beyond terminal RETURN nodes')
    if warnings[0] != warnings[1]:
        raise ValueError('Final RETURN cleanup changed compiler warnings')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--form', choices=('fixed', 'free'))
    parser.add_argument('--report', type=Path)
    parser.add_argument('--compiler', help='Verify GNU compiler records before writing')
    args = parser.parse_args()
    form = args.form or ('fixed' if args.source.suffix.lower() in ('.f', '.for', '.ftn') else 'free')
    original, report = args.source.read_bytes(), {}
    changed = transform_fixed(original, report) if form == 'fixed' else transform_free(original.decode('ascii'), report).encode('ascii')
    if args.compiler:
        verify(original, changed, form, args.compiler)
    args.output.write_bytes(changed)
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='ascii', newline='\n')
    print(f"{form}: removed {report['removed']} terminal RETURN statements in {len(report['removed_by_procedure'])} procedures.")


if __name__ == '__main__':
    main()
