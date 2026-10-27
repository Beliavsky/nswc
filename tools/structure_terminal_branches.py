"""Structure terminal three-way sign dispatches in fixed-form procedures.

Preview by default. Only straight-line assignment arms at procedure end are
accepted. Retain the tested temporary: evaluating/converting it once matters.
"""
import argparse
from bisect import bisect_left
import hashlib
import json
from pathlib import Path
import re

from explicit_typing import units
from name_procedure_ends import statements, split_line, code_comment
from remove_unused_labels import references, SPEC

MANIFEST = Path(__file__).with_name('terminal-branches.json')
NAME = r'[A-Z][A-Z0-9_]*'
NEG = re.compile(rf'IF\s*\(\s*({NAME})\s*\.LT\.\s*0\s*\)\s*GO\s*TO\s*(\d+)', re.I)
ZERO = re.compile(rf'IF\s*\(\s*({NAME})\s*\.EQ\.\s*0\s*\)\s*GO\s*TO\s*(\d+)', re.I)
JUMP = re.compile(r'GO\s*TO\s*(\d+)', re.I)
ASSIGN = re.compile(rf'{NAME}\s*(?:\([^=]*\))?\s*=(?![=>])\s*.+', re.I)


def transform(data, report=None):
    lines, scopes = units(data)
    all_statements = list(statements(lines))
    starts = [s.lines[0] for s in all_statements]
    edits, removed, converted, skipped = {}, set(), [], []
    for name, (start, _, stop) in scopes.items():
        unit = all_statements[bisect_left(starts, start):bisect_left(starts, stop)]
        for i, s in enumerate(unit[:-3]):
            neg = NEG.fullmatch(s.code.strip())
            if not neg:
                continue
            zero = ZERO.fullmatch(unit[i+1].code.strip())
            jump = JUMP.fullmatch(unit[i+2].code.strip())
            if not zero or not jump or neg[1].upper() != zero[1].upper():
                continue
            try:
                targets = list(map(int, (neg[2], zero[2], jump[1])))
                if len(set(targets)) != 3:
                    raise ValueError('destinations are not distinct')
                refs, reason = references(unit)
                if reason:
                    raise ValueError(reason)
                labels = {int(lines[t.lines[0]][:5]): j for j, t in enumerate(unit)
                          if lines[t.lines[0]][:5].strip()}
                if len(labels) != sum(bool(lines[t.lines[0]][:5].strip()) for t in unit):
                    raise ValueError('duplicate labels')
                if any(t not in labels for t in targets):
                    raise ValueError('missing destination')
                positions = sorted(labels[t] for t in targets)
                if positions[0] != i+3:
                    raise ValueError('branches are not contiguous with dispatch')
                # Restrict to a top-level tail: no preceding executable control
                # constructs, entries, statement functions or prior transfers.
                for t in unit[:i]:
                    compact = re.sub(r'\s+', '', t.code).upper()
                    if compact.startswith('ENTRY') or not (SPEC.match(compact) or
                            re.fullmatch(rf'{NAME}\s*=.*', t.code.strip(), re.I)):
                        raise ValueError('unsupported preceding statement')
                if any(re.match(r'\s*[Cc*!]\$', line) for line in lines[start:stop]):
                    raise ValueError('directive requires review')
                if any(re.search(r'\d+H', t.code, re.I) for t in unit):
                    raise ValueError('Hollerith requires review')
                if any(references([t])[0] & set(targets) for j, t in enumerate(unit)
                       if j not in (i, i+1, i+2)):
                    raise ValueError('another statement references a branch label')
                if any(lines[t.lines[0]][:5].strip() for t in unit[i:i+3]):
                    raise ValueError('labelled dispatch requires review')
                tail = unit[i:-1]
                if any(len(t.lines) != 1 for t in tail):
                    raise ValueError('continued branch statement requires review')
                for t in tail:
                    raw, _ = split_line(lines[t.lines[0]])
                    if raw[72:].strip() or code_comment(raw[6:72])[1]:
                        raise ValueError('sequence field or inline comment requires review')
                # Reordering arms would reorder intervening comments; skip these
                # until a comment-attachment policy is supplied.
                covered = {t.lines[0] for t in tail}
                if any(lines[j].strip() for j in range(s.lines[0], unit[-1].lines[0]) if j not in covered):
                    raise ValueError('comment between branches requires review')
                arms = {}
                for p, q in zip(positions, positions[1:] + [len(unit)-1]):
                    arm = unit[p:q]
                    if q != len(unit)-1:
                        if arm[-1].code.strip().upper() != 'RETURN':
                            raise ValueError('branch falls through')
                        arm = arm[:-1]
                    elif arm and arm[-1].code.strip().upper() == 'RETURN':
                        arm = arm[:-1]
                    if not arm or any(not ASSIGN.fullmatch(t.code.strip()) for t in arm):
                        raise ValueError('branch contains more than assignments')
                    if any(lines[t.lines[0]][:5].strip() for t in unit[p+1:q]):
                        raise ValueError('internal branch label')
                    arms[p] = arm
                _, newline = split_line(lines[s.lines[0]])
                out = []
                for header, target in zip((f'IF ({neg[1]} .LT. 0) THEN',
                                           f'ELSE IF ({neg[1]} .EQ. 0) THEN', 'ELSE'), targets):
                    out.append('      '+header+newline)
                    for t in arms[labels[target]]:
                        code = t.code.strip()
                        if len(code) > 63:
                            raise ValueError('indented assignment exceeds fixed width')
                        out.append('         '+code+newline)
                out.append('      END IF'+newline)
                edits[s.lines[0]] = ''.join(out)
                removed.update(range(s.lines[0], unit[-1].lines[0]))
                converted.append({'procedure': name, 'line': s.lines[0]+1,
                                  'temporary': neg[1], 'targets': targets})
                break
            except ValueError as error:
                skipped.append({'procedure': name, 'line': s.lines[0]+1, 'reason': str(error)})
    output = ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines)).encode('latin-1')
    if report is not None:
        report.update(input_sha256=hashlib.sha256(data).hexdigest(),
                      output_sha256=hashlib.sha256(output).hexdigest(),
                      converted=converted, skipped=skipped)
    return output


def finish_fixed(data):
    """Final formatting, structured tails and generics for historical validators."""
    from normalize_fixed_spacing import transform as spacing
    from fixed_generic_intrinsics import transform as generics
    return generics(transform(spacing(data)))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    for path in (args.output, args.report):
        if path and path.exists():
            parser.error(f'Output must name a new file: {path}')
    if args.output and args.report and args.output.resolve() == args.report.resolve():
        parser.error('Output and report must be separate files')
    report = {}
    output = transform(args.source.read_bytes(), report)
    if args.output:
        with args.output.open('xb') as stream:
            stream.write(output)
    if args.report:
        with args.report.open('x', newline='\n') as stream:
            stream.write(json.dumps(report, indent=2)+'\n')
    print('Converted:', ', '.join(r['procedure'] for r in report['converted']))
    print('Skipped dispatches:', len(report['skipped']))


if __name__ == '__main__':
    main()
