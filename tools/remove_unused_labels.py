"""Preview or remove unused labels and redundant CONTINUEs in fixed-form procedures.

Only external subroutines/functions in columns 7--72 are supported. Unsupported
source layout is rejected; procedures with indirect transfers are left alone.
FORMAT labels are always retained. No ordinary numeric literals count as targets.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re

from explicit_typing import units
from modernize_do import masked, has_comma
from name_procedure_ends import statements, code_comment, split_line

MANIFEST = Path(__file__).with_name('unused-labels.json')
SPEC = re.compile(r'^(?:IMPLICIT|INTEGER|REAL|DOUBLEPRECISION|DOUBLECOMPLEX|COMPLEX|LOGICAL|CHARACTER|'
                  r'DIMENSION|COMMON|EQUIVALENCE|DATA|SAVE|PARAMETER|EXTERNAL|INTRINSIC|INTENT|OPTIONAL|'
                  r'ALLOCATABLE|POINTER|TARGET|PUBLIC|PRIVATE|SUBROUTINE|FUNCTION|ENTRY)')


def action(code):
    """Separate a leading IF condition, retaining only its action or destinations."""
    if not code.startswith('IF('):
        return code
    depth = 0
    for i, char in enumerate(code[2:], 2):
        depth += (char == '(') - (char == ')')
        if not depth:
            return code if code[i + 1:].startswith('=') else code[i + 1:]
    raise ValueError('Unbalanced IF condition')


def references(unit):
    refs = set()
    for statement in unit:
        code = re.sub(r'\s+', '', masked(statement.code)).upper()
        tail = action(code)
        if tail.startswith('ASSIGN'):
            return refs, 'assigned label storage'
        if tail.startswith('GOTO'):
            target = tail[4:]
            if re.fullmatch(r'\d+', target):
                refs.add(int(target))
            elif (m := re.match(r'^\(([\d,]+)\),?.+$', target)):
                refs.update(map(int, m[1].split(',')))
            else:
                return refs, 'indirect or unsupported GO TO'
        if (m := re.fullmatch(r'(\d+),(\d+),(\d+)', tail)):
            refs.update(map(int, m.groups()))
        if (m := re.match(r'^DO(\d+),?(.*)$', code)):
            rest = m[2]
            if not rest or rest.startswith('WHILE(') or ('=' in rest and has_comma(rest.split('=', 1)[1])):
                refs.add(int(m[1]))
        if re.match(r'^(?:READ|WRITE|OPEN|CLOSE|INQUIRE|BACKSPACE|ENDFILE|REWIND|FLUSH|WAIT)\(', tail):
            refs.update(int(m[1]) for m in re.finditer(r'(?:ERR|END|EOR)=(\d+)(?=[,)])', tail))
        if tail.startswith('CALL'):
            refs.update(int(m[1]) for m in re.finditer(r'(?:\(|,)\*(\d+)(?=[,)])', tail))
    return refs, ''


def transform(data, report=None):
    lines, scopes = units(data)
    all_statements = list(statements(lines))
    edits, changes, skipped = {}, [], []
    retained = Counter()
    for name, (start, _, stop) in scopes.items():
        unit = [s for s in all_statements if start <= s.lines[0] < stop]
        labels = [int(lines[s.lines[0]][:5]) for s in unit if lines[s.lines[0]][:5].strip()]
        refs, reason = references(unit)
        # The shared fixed-form reader splits inline comments before masking
        # literals. A Hollerith payload containing ! needs a separate lexer;
        # never risk losing a later alternate-return or branch reference.
        if any(re.search(r'\d+H', s.code, re.I) and
               any('!' in lines[i][6:72] for i in s.lines) for s in unit):
            reason = 'Hollerith/comment boundary requires review'
        if len(labels) != len(set(labels)):
            reason = 'duplicate labels'
        if refs - set(labels):
            reason = reason or 'undefined target labels'
        if reason:
            skipped.append({'procedure': name, 'reason': reason})
            continue
        specification = True
        for s in unit:
            i = s.lines[0]
            raw, newline = split_line(lines[i])
            label = int(raw[:5]) if raw[:5].strip() else None
            code = re.sub(r'\s+', '', masked(s.code)).upper()
            if code.startswith('FORMAT('):
                retained['FORMAT'] += label is not None
                continue
            if specification and (SPEC.match(code) or re.match(r'^[A-Z_]\w*\([^=]*\)=', code)):
                retained['specification or ambiguous initial assignment'] += label is not None
                continue
            specification = False
            if label in refs:
                retained['referenced'] += 1
                continue
            if code == 'CONTINUE' and len(s.lines) == 1 and not raw[72:].strip():
                _, comment, _ = code_comment(raw[6:72])
                edits[i] = '      ' + comment + newline if comment else ''
                kind = 'remove_continue'
            elif label is not None:
                edits[i] = '     ' + lines[i][5:]
                kind = 'remove_label'
            else:
                continue
            changes.append({'procedure': name, 'line': i + 1, 'label': label,
                            'action': kind, 'statement': s.code.strip()})
    output = ''.join(edits.get(i, line) for i, line in enumerate(lines)).encode('latin-1')
    if report is not None:
        report.update({'input_sha256': hashlib.sha256(data).hexdigest(),
                       'output_sha256': hashlib.sha256(output).hexdigest(),
                       'changes': changes, 'counts': dict(Counter(c['action'] for c in changes)),
                       'retained_labels': dict(retained), 'skipped_procedures': skipped})
    return output


def verify(before, after, compiler='gfortran'):
    from modernize_deleted_do import verify as verify_compiler
    from validate_explicit_typing import non_declaration_content
    if transform(before) != after or transform(after) != after:
        raise ValueError('Label cleanup does not reproduce or is not idempotent')
    if non_declaration_content(before)[1] != non_declaration_content(after)[1]:
        raise ValueError('Label cleanup changed comment text or order')
    verify_compiler(before, after, compiler)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--report', type=Path)
    parser.add_argument('--compiler', help='Verify compiler symbols, warnings and assembly before writing')
    args = parser.parse_args()
    for path in (args.output, args.report):
        if path is not None and path.exists():
            parser.error('Output/report must name a new file: ' + str(path))
    if args.output and args.report and args.output.resolve() == args.report.resolve():
        parser.error('Output and report must be separate files')
    before, report = args.source.read_bytes(), {}
    after = transform(before, report)
    if args.compiler:
        verify(before, after, args.compiler)
    if args.output:
        with args.output.open('xb') as stream:
            stream.write(after)
    if args.report:
        with args.report.open('x', encoding='ascii', newline='\n') as stream:
            stream.write(json.dumps(report, indent=2) + '\n')
    print(report['counts'])
    print('Skipped procedures:', report['skipped_procedures'])


if __name__ == '__main__':
    main()
