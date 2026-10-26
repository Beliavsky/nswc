"""Preview fixed-form GO TOs that can become equivalent structured loop exits.

Only branches to the first statement after an enclosing block DO are eligible.
Nested exits use a collision-free construct name. Uncertain layout/flow is left
unchanged. Target labels disappear only when no references remain.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import units
from modernize_arithmetic_if import emit
from modernize_do import masked, has_comma
from name_procedure_ends import statements, split_line, code_comment
from remove_unused_labels import action, references

MANIFEST = Path(__file__).with_name('goto-exits.json')


def loops_in(unit):
    loops, stack, active = {}, [], []
    for i, s in enumerate(unit):
        code = re.sub(r'\s+', '', masked(s.code)).upper()
        active.append(tuple(stack))
        if re.match(r'^(?:\w+:)?DO(?:CONCURRENT|\d)', code):
            raise ValueError('labelled or concurrent DO requires review')
        end = re.fullmatch(r'ENDDO(\w+)?', code)
        if end:
            if not stack:
                raise ValueError('unmatched END DO')
            start = stack.pop()
            if (end[1] or '') != loops[start]['name']:
                raise ValueError('loop construct names do not match')
            loops[start]['end'] = i
            continue
        header = re.fullmatch(r'(?:(\w+):)?DO(.*)', code)
        if not header:
            continue
        rest = header[2]
        if rest and not (rest.startswith('WHILE(') or
                         re.match(r'^\w+=', rest) and has_comma(rest.split('=', 1)[1])):
            continue  # An assignment such as DONE=1 is not a loop.
        loops[i] = {'name': header[1] or '', 'end': None}
        stack.append(i)
    if stack:
        raise ValueError('unclosed DO')
    return loops, active


def render(lines, statement, code):
    if len(statement.lines) != 1:
        raise ValueError('continued statement requires review')
    raw, newline = split_line(lines[statement.lines[0]])
    if raw[72:].strip():
        raise ValueError('sequence field requires review')
    indent = re.match(r'\s*', raw[6:72])[0]
    _, comment, _ = code_comment(raw[6:72])
    result = emit(code.strip(), raw[:5].strip(), indent, newline)
    if comment:
        result += '      ' + comment + newline
    return result


def transform(data, report=None):
    lines, scopes = units(data)
    all_statements = list(statements(lines))
    edits, conversions, skipped, removed_targets = {}, [], [], []
    targets_by_host = {}
    for host, (start, _, end) in scopes.items():
        unit = [s for s in all_statements if start <= s.lines[0] < end]
        refs, reason = references(unit)
        if any(re.match(r'^\s*[Cc*!]\$(?:OMP|ACC)', line, re.I) for line in lines[start:end]):
            reason = 'parallel directive requires review'
        if any(re.search(r'\d+H', s.code, re.I) for s in unit):
            reason = 'Hollerith data requires review'
        if any(re.match(r'^(?:\w+:)?(?:BLOCK$|(?:ASSOCIATE|CRITICAL|FORALL|CHANGETEAM)(?:\(|$))',
                        re.sub(r'\s+', '', masked(s.code)).upper()) for s in unit):
            reason = 'unsupported enclosing construct'
        try:
            if reason:
                raise ValueError(reason)
            loops, active = loops_in(unit)
        except ValueError as error:
            skipped.append({'procedure': host, 'reason': str(error)})
            continue
        labels = {int(lines[s.lines[0]][:5]): i for i, s in enumerate(unit) if lines[s.lines[0]][:5].strip()}
        if len(labels) != sum(bool(lines[s.lines[0]][:5].strip()) for s in unit):
            skipped.append({'procedure': host, 'reason': 'duplicate labels'})
            continue
        if refs - labels.keys():
            skipped.append({'procedure': host, 'reason': 'undefined target labels'})
            continue
        incoming = {label: set() for label in labels}
        for source, statement in enumerate(unit):
            for label in references([statement])[0] & labels.keys():
                incoming[label].add(source)
        identifiers = set(re.findall(r'\b[A-Z_]\w*', masked(' '.join(s.code for s in unit)).upper()))
        names, named_used = {}, set()
        for i, s in enumerate(unit):
            tail = action(re.sub(r'\s+', '', masked(s.code)).upper())
            branch = re.fullmatch(r'GOTO(\d+)', tail)
            if not branch:
                continue
            target = int(branch[1])
            destination = labels.get(target)
            candidates = [l for l in active[i] if loops[l]['end'] + 1 == destination]
            if not candidates:
                continue
            loop = candidates[-1]
            if any(loop < position <= loops[loop]['end'] and
                   any(not loop <= source <= loops[loop]['end'] for source in incoming[label])
                   for label, position in labels.items()):
                skipped.append({'procedure': host, 'line': s.lines[0]+1, 'reason': 'incoming branch into loop body'})
                continue
            if re.match(r'^\s*FORMAT\s*\(', unit[destination].code, re.I):
                continue
            name = loops[loop]['name']
            match = re.search(r'\bGO\s*TO\s*(\d+)\s*$', s.code, re.I)
            if not match or int(match[1]) != target:
                skipped.append({'procedure': host, 'line': s.lines[0]+1, 'reason': 'branch spelling requires review'})
                continue
            try:
                if loop != active[i][-1]:
                    if not name:
                        if loop not in names:
                            number = 1
                            while f'NSWC_EXIT_{number}' in identifiers:
                                number += 1
                            names[loop] = f'NSWC_EXIT_{number}'
                            identifiers.add(names[loop])
                        name = names[loop]
                        render(lines, unit[loop], name + ': ' + unit[loop].code.strip())
                        render(lines, unit[loops[loop]['end']], 'END DO ' + name)
                    replacement = 'EXIT ' + name
                else:
                    replacement = 'EXIT'
                text = render(lines, s, s.code[:match.start()] + replacement)
            except ValueError as error:
                skipped.append({'procedure': host, 'line': s.lines[0]+1, 'reason': str(error)})
                continue
            edits[s.lines[0]] = text
            if loop in names and name:
                named_used.add(loop)
            targets_by_host.setdefault(host, set()).add(target)
            conversions.append({'procedure': host, 'line': s.lines[0]+1, 'target': target,
                                'loop_line': unit[loop].lines[0]+1, 'exit': replacement,
                                'before': s.code.strip()})
        for loop in named_used:
            name = names[loop]
            edits[unit[loop].lines[0]] = render(lines, unit[loop], name + ': ' + unit[loop].code.strip())
            edits[unit[loops[loop]['end']].lines[0]] = render(lines, unit[loops[loop]['end']], 'END DO ' + name)
    output = ''.join(edits.get(i, line) for i, line in enumerate(lines)).encode('latin-1')
    # Re-read all remaining references before pruning converted target labels.
    new_lines, new_scopes = units(output)
    new_statements = list(statements(new_lines))
    pruned = {}
    for host, targets in targets_by_host.items():
        start, _, end = new_scopes[host]
        unit = [s for s in new_statements if start <= s.lines[0] < end]
        refs, reason = references(unit)
        if reason:
            raise ValueError('Reference analysis changed after conversion: ' + host)
        for s in unit:
            i = s.lines[0]
            raw, newline = split_line(new_lines[i])
            label = int(raw[:5]) if raw[:5].strip() else None
            if label not in targets or label in refs:
                continue
            if re.match(r'^\s*FORMAT\s*\(', s.code, re.I):
                continue
            if re.sub(r'\s+', '', s.code).upper() == 'CONTINUE' and len(s.lines) == 1 and not raw[72:].strip():
                _, comment, _ = code_comment(raw[6:72])
                pruned[i] = '      ' + comment + newline if comment else ''
            else:
                pruned[i] = '     ' + new_lines[i][5:]
            removed_targets.append({'procedure': host, 'label': label})
    output = ''.join(pruned.get(i, line) for i, line in enumerate(new_lines)).encode('latin-1')
    if report is not None:
        report.update({'input_sha256': hashlib.sha256(data).hexdigest(),
                       'output_sha256': hashlib.sha256(output).hexdigest(),
                       'conversions': conversions, 'removed_targets': removed_targets,
                       'skipped': skipped, 'converted': len(conversions),
                       'named_exits': sum(c['exit'] != 'EXIT' for c in conversions)})
    return output


def canonical_assembly(text):
    names = {}
    output = []
    for line in text.splitlines():
        if re.match(r'^\s*\.(?:ascii|string)\s', line):
            line = re.sub(r'\bAt line \d+ of file\b', 'At line <source> of file', line)
            line = re.sub(r'\baround line \d+\b', 'around line <source>', line)
        if not re.match(r'^\s*\.(?:ascii|string)\s', line):
            line = re.sub(r'\.L\w*\d+\b', lambda m: names.setdefault(m[0], f'.L_local_{len(names)}'), line)
        output.append(line)
    return output


def verify(before, after, compiler='gfortran'):
    from validate_explicit_typing import symbols, non_declaration_content
    report = {}
    if transform(before, report) != after or transform(after) != after:
        raise ValueError('EXIT conversion is not exact or idempotent')
    if non_declaration_content(before)[1] != non_declaration_content(after)[1]:
        raise ValueError('EXIT conversion changed comment text or order')
    added_names = {(c['procedure'], c['exit'].split()[1].lower()) for c in report['conversions'] if c['exit'] != 'EXIT'}
    with tempfile.TemporaryDirectory(prefix='nswc-exit-check-') as work:
        path = Path(work)/'input.f'
        inventories, warnings, assembly = [], [], []
        for data in (before, after):
            path.write_bytes(data)
            result = subprocess.run([compiler, '-O2', '-std=legacy', '-fno-allow-argument-mismatch',
                                     '-fdump-fortran-original', '-S', str(path), '-o', 'input.s'],
                                    cwd=work, capture_output=True, text=True, timeout=300)
            if result.returncode:
                raise RuntimeError(result.stderr)
            inventories.append(symbols(result.stdout, True))
            warnings.append(re.findall(r'^(?:Warning|Error):.*', result.stderr, re.M))
            assembly.append(canonical_assembly((Path(work)/'input.s').read_text()))
        for host, name in added_names:
            if name not in inventories[0][host]:
                if inventories[1][host].pop(name, None) != {'type spec': 'type spec : (UNKNOWN 0)', 'attributes': 'attributes: (LABEL)'}:
                    raise ValueError(f'{host}:{name}: unexpected construct-name record')
        if inventories[0] != inventories[1]:
            raise ValueError('EXIT conversion changed non-construct compiler records')
        if warnings[0] != warnings[1]:
            raise ValueError('EXIT conversion changed compiler warnings')
        if assembly[0] != assembly[1]:
            import difflib
            diff = ''.join(difflib.unified_diff(assembly[0], assembly[1], lineterm='\n'))
            raise ValueError('Optimized assembly differs beyond local-label renumbering and diagnostic lines:\n'+diff[:5000])


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
    before, report = args.source.read_bytes(), {}
    after = transform(before, report)
    if args.compiler:
        verify(before, after, args.compiler)
    if args.output:
        with args.output.open('xb') as stream:
            stream.write(after)
    if args.report:
        with args.report.open('x', encoding='ascii', newline='\n') as stream:
            stream.write(json.dumps(report, indent=2)+'\n')
    print({key: report[key] for key in ('converted', 'named_exits')})
    print('Skipped:', dict(Counter(e['reason'] for e in report['skipped'])))


if __name__ == '__main__':
    main()
