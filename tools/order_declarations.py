"""Put dummy-argument declarations before local types in fixed-form procedures.

Use --mark-locals for the final argument/result/local section pass; the default
mode preserves historical declaration-ordering behavior.

Preview by default; --output writes a new file. Bounds/type dependencies take
precedence over grouping. Separate DIMENSION statements remain in place because
their bounds can depend on intervening PARAMETER definitions. Comments, executable
statements, declaration attributes and entity order within each group survive.
"""
import argparse
from dataclasses import dataclass, asdict
import hashlib
import heapq
import json
from pathlib import Path
import re

from combine_declarations import type_declaration, split_list, emit
from explicit_typing import units
from name_procedure_ends import ConversionError, statements, code_comment


@dataclass
class Result:
    data: bytes
    procedures: int
    changed_procedures: int
    mixed_declarations_split: int
    prerequisite_locals: list
    retained_dimensions: list

    def report(self, original):
        result = {k: v for k, v in asdict(self).items() if k != 'data'}
        result.update(input_sha256=hashlib.sha256(original).hexdigest(),
                      output_sha256=hashlib.sha256(self.data).hexdigest())
        return result


def transform(data):
    lines, scopes = units(data)
    edits, removed = {}, set()
    changed = mixed = 0
    prerequisites, dimensions = [], []
    for procedure, (start, _, end) in scopes.items():
        body = list(statements(lines[start:end]))
        header = body[0].code
        args = set(re.sub(r'\s+', '', header[header.index('(') + 1:header.rindex(')')]).upper().split(',')) if '(' in header else set()
        nodes, type_lines, positions = [], [], []
        for s in body[1:]:
            decl = type_declaration(s.code)
            external = re.match(r'^\s*EXTERNAL\s+(?:::)?\s*(.*)$', s.code, re.I)
            if re.match(r'^\s*DIMENSION\b', s.code, re.I):
                dimensions.append({'procedure': procedure, 'statement': s.code.strip()})
            if decl is None and not external:
                continue
            if external:
                entries = split_list(external[1])
                if not all(re.fullmatch(r'[A-Za-z]\w*', n) for n in entries):
                    raise ConversionError(f'{procedure}: unsupported EXTERNAL declaration')
                typ, attrs, items = 'EXTERNAL', [], [(n, '', '') for n in entries]
            else:
                typ, attrs, items = decl
            for i in s.lines:
                raw = lines[start + i].rstrip('\r\n')
                if raw[:5].strip() or raw[72:].strip() or code_comment(raw[6:72])[1]:
                    raise ConversionError(f'{procedure}: labelled, annotated or sequence-field declaration')
            groups = [[item for item in items if (item[0].upper() in args) == dummy]
                      for dummy in (True, False)]
            mixed += bool(groups[0] and groups[1])
            newline = '\r\n' if lines[start + s.lines[0]].endswith('\r\n') else '\n'
            for dummy, group in zip((True, False), groups):
                if not group:
                    continue
                prefix = typ + (', ' + ', '.join(attrs) if attrs else '') + (' ::' if not external else '')
                entities = [name + shape + length for name, shape, length in group]
                # Only selectors, bounds and entity lengths supply dependencies;
                # INTENT(IN) must not be confused with a variable named IN.
                expressions = ' '.join([re.sub(r'^[A-Z ]+', '', typ),
                                        *[a for a in attrs if re.match(r'\s*(?:DIMENSION|KIND|LEN)\b', a, re.I)],
                                        *[shape + length for _, shape, length in group]])
                refs = {w.upper() for w in re.findall(r'[A-Za-z]\w*', expressions)}
                nodes.append({'dummy': dummy, 'names': {n.upper() for n, _, _ in group},
                              'refs': refs, 'external': bool(external),
                              'text': ''.join(emit(prefix, entities, newline))})
            type_lines.extend(start + i for i in s.lines)
            if not external:
                positions.append(s.lines[0])
        if not nodes:
            continue
        # Crossing these other specifications is safe after all types are known.
        # Fail closed for a different layout instead of crossing PARAMETER/DATA.
        for s in body[1:]:
            if positions and positions[0] <= s.lines[0] <= positions[-1] and start + s.lines[0] not in type_lines:
                if not re.match(r'^\s*(?:EXTERNAL|DIMENSION)\b', s.code, re.I):
                    raise ConversionError(f'{procedure}: intervening specification requires review: {s.code}')
        owners = {}
        for i, node in enumerate(nodes):
            if not node['external']:
                for name in node['names']:
                    if name in owners:
                        raise ConversionError(f'{procedure}: duplicate type for {name}')
                    owners[name] = i
        deps = [{owners[n] for n in node['refs'] if n in owners and owners[n] != i}
                for i, node in enumerate(nodes)]
        for i, node in enumerate(nodes):
            if node['external']:
                deps[i].update(owners[n] for n in node['names'] if n in owners)
        required = set()
        def require(i):
            if i not in required:
                required.add(i)
                for dependency in deps[i]:
                    require(dependency)
        for i, node in enumerate(nodes):
            if node['dummy']:
                require(i)
        for i in sorted(required):
            if not nodes[i]['dummy']:
                prerequisites.append({'procedure': procedure, 'locals': sorted(nodes[i]['names']),
                                      'reason': 'type or bound dependency of an argument'})
        pending = {i: set(d) for i, d in enumerate(deps)}
        ready, order = [], []
        def enqueue(i):
            priority = 0 if nodes[i]['dummy'] else 1 if i in required else 2
            heapq.heappush(ready, (priority, i))
        for i in pending:
            if not pending[i]:
                enqueue(i)
        while ready:
            _, i = heapq.heappop(ready)
            order.append(i)
            for j in pending:
                if i in pending[j]:
                    pending[j].remove(i)
                    if not pending[j]:
                        enqueue(j)
        if len(order) != len(nodes):
            raise ConversionError(f'{procedure}: cyclic declaration dependency')
        first = min(type_lines)
        replacement = ''.join(nodes[i]['text'] for i in order)
        # Keep the result unchanged if it is already in the chosen normal form.
        if lines[first:first + len(replacement.splitlines(True))] == replacement.splitlines(True) and type_lines == list(range(first, first + len(replacement.splitlines(True)))):
            continue
        edits[first] = replacement
        removed.update(type_lines)
        changed += 1
    output = ''.join(edits.get(i, '') + (line if i not in removed else '') for i, line in enumerate(lines)).encode('latin-1')
    return Result(output, len(scopes), changed, mixed, prerequisites, dimensions)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--report', type=Path)
    parser.add_argument('--mark-locals', action='store_true', help='Group arguments/results and mark the start of local declarations')
    args = parser.parse_args()
    if args.output and args.report and args.output.resolve() == args.report.resolve():
        parser.error('Output and report must be distinct')
    for target in (args.output, args.report):
        if target and target.exists():
            parser.error('Output and report must name new files')
    data = args.source.read_bytes()
    if args.mark_locals:
        from declaration_sections import transform as sections
        report = {}
        output = sections(data, report)
        if args.output:
            args.output.write_bytes(output)
        if args.report:
            args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8', newline='\n')
        print(f"{len(report['marked'])} marked; {len(report['reordered'])} reordered; {len(report['skipped'])} need review.")
        return
    result = transform(data)
    if args.output:
        args.output.write_bytes(result.data)
    if args.report:
        args.report.write_text(json.dumps(result.report(data), indent=2) + '\n', encoding='utf-8', newline='\n')
    print(f'{result.changed_procedures}/{result.procedures} procedures reordered; '
          f'{len(result.prerequisite_locals)} required local declaration groups precede arguments.')


if __name__ == '__main__':
    main()
