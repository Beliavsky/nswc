"""Combine fixed-form type, INTENT and straightforward DIMENSION declarations.

Preview by default; --output writes a new file, --in-place makes a backup.
This conservative external-procedure scanner preserves executable statements,
comments, declaration order, attributes, bounds and fixed-form column limits.
Unsupported declarations and unsafe dimension moves are reported, not guessed.
"""
import argparse
from dataclasses import dataclass, asdict
import difflib
import hashlib
import json
from pathlib import Path
import re
import sys

from explicit_typing import units
from name_procedure_ends import ConversionError, statements, code_comment, split_line

TYPE = re.compile(r'^\s*(DOUBLE\s+PRECISION|DOUBLE\s+COMPLEX|INTEGER|REAL|COMPLEX|LOGICAL|CHARACTER)'
                  r'\b\s*((?:\*\s*(?:\d+|\([^)]*\))|\([^)]*\))?)\s*(.*)$', re.I)
NAME = re.compile(r'[A-Za-z][A-Za-z0-9_]*')


def split_list(text):
    """Split commas outside parentheses and quoted text, with doubled quotes."""
    result, start, depth, quote, i = [], 0, 0, '', 0
    while i < len(text):
        c = text[i]
        if quote:
            if c == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    i += 1
                else:
                    quote = ''
        elif c in "'\"":
            quote = c
        elif c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth < 0:
                raise ConversionError('Unbalanced declaration parentheses')
        elif c == ',' and depth == 0:
            result.append(text[start:i].strip())
            start = i + 1
        i += 1
    if depth or quote:
        raise ConversionError('Unbalanced declaration parentheses or quotes')
    result.append(text[start:].strip())
    if not all(result):
        raise ConversionError('Empty declaration entity')
    return result


def entity(text):
    """Recognize an uninitialized name, optional shape, and character length."""
    match = NAME.match(text)
    if not match:
        raise ConversionError('Unsupported declaration entity: ' + text)
    name, rest = match[0], text[match.end():].strip()
    shape = ''
    if rest.startswith('('):
        depth, end = 0, None
        for i, c in enumerate(rest):
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
                if depth == 0:
                    end = i + 1
                    break
        if end is None:
            raise ConversionError('Unbalanced entity shape')
        shape, rest = rest[:end], rest[end:].strip()
    if rest and not re.fullmatch(r'\*\s*(?:\d+|\([^)]*\))', rest):
        raise ConversionError('Initialization or unsupported entity syntax: ' + text)
    return name, shape, rest


def type_declaration(code):
    match = TYPE.match(code)
    if not match or re.match(r'FUNCTION\b', match[3], re.I):
        return None
    typ = re.sub(r'\s+', ' ', match[1]).upper() + re.sub(r'\s+', '', match[2])
    tail = match[3]
    if '::' in tail:
        attrs, tail = tail.split('::', 1)
        if attrs.strip() and not attrs.lstrip().startswith(','):
            raise ConversionError('Unsupported type attributes')
        attrs = split_list(attrs.lstrip().lstrip(',')) if attrs.strip() else []
    else:
        attrs = []
    items = [entity(t) for t in split_list(tail)]
    return typ, attrs, items


def emit(prefix, entities, newline):
    """Wrap at entity boundaries using fixed-form continuation column 6."""
    if len('      ' + prefix) > 72:
        raise ConversionError('Type and attributes cannot fit in fixed-form columns')
    result, line = [], '      ' + prefix + ' '
    for i, item in enumerate(entities):
        suffix = ',' if i + 1 < len(entities) else ''
        addition = item + suffix
        if len(line + addition) > 72:
            result.append(line.rstrip() + newline)
            line = '     &'
        if len(line + addition) > 72:
            raise ConversionError('An entity cannot fit in fixed-form columns')
        line += addition + (' ' if suffix else '')
    result.append(line.rstrip() + newline)
    return result


@dataclass
class Result:
    data: bytes
    procedures: int
    type_statements_changed: int
    intents_combined: int
    dimensions_combined: int
    reviews: list

    def report(self):
        return {key: value for key, value in asdict(self).items() if key != 'data'}


def transform(data):
    lines, scopes = units(data)
    edits, reviews = {}, []
    types_changed = intents_combined = dimensions_combined = 0
    for procedure, (start, _, end) in scopes.items():
        body = list(statements(lines[start:end]))[1:]
        types, intents, dimensions, standalone, typed_at = {}, {}, {}, [], {}
        parameters, dummies = {}, set()
        header = next(statements(lines[start:end])).code
        if '(' in header:
            dummies = {n.strip().upper() for n in header[header.index('(') + 1:header.rindex(')')].split(',')}

        def review(statement, reason):
            reviews.append({'procedure': procedure, 'line': start + statement.lines[0] + 1, 'reason': reason})

        def editable(statement):
            return all(not lines[start + i][:5].strip() and
                       not lines[start + i].rstrip('\r\n')[72:].strip() for i in statement.lines)

        for s in body:
            code = s.code.strip()
            if re.match(r'^PARAMETER\s*\(', code, re.I):
                for item in split_list(code[code.index('(') + 1:code.rindex(')')]):
                    parameters[item.split('=', 1)[0].strip().upper()] = s.lines[0]
            if TYPE.match(code):
                try:
                    decl = type_declaration(code)
                    if decl is None:
                        continue
                    if not editable(s):
                        raise ConversionError('Labelled declaration or sequence field retained')
                    keys = [name.upper() for name, _, _ in decl[2]]
                    if len(set(keys)) != len(keys) or any(key in typed_at for key in keys):
                        raise ConversionError('Repeated type declaration retained')
                    types[s.lines[0]] = (s, decl)
                    for ordinal, (name, _, _) in enumerate(decl[2]):
                        key = name.upper()
                        typed_at[key] = (s.lines[0], ordinal)
                        if any(a.upper() == 'PARAMETER' for a in decl[1]):
                            parameters[key] = s.lines[0]
                except ConversionError as error:
                    review(s, str(error))
                continue
            intent = re.fullmatch(r'INTENT\s*\(\s*(INOUT|IN|OUT)\s*\)\s*(?:::)?\s*(.*)', code, re.I)
            dimension = re.match(r'^DIMENSION\b\s*(?:::)?\s*(.*)', code, re.I)
            if intent or dimension:
                try:
                    if not editable(s):
                        raise ConversionError('Labelled declaration or sequence field retained')
                    parsed = [entity(t) for t in split_list(intent[2] if intent else dimension[1])]
                    if len({n.upper() for n, _, _ in parsed}) != len(parsed):
                        raise ConversionError('Repeated attribute entity retained')
                    for name, shape, length in parsed:
                        key = name.upper()
                        target = intents if intent else dimensions
                        if key in target:
                            raise ConversionError('Repeated attribute for ' + key)
                        if (intent and (shape or length)) or (dimension and (not shape or length)):
                            raise ConversionError('Unsupported separate attribute syntax')
                    # Only install a statement after checking every entity.
                    for name, shape, length in parsed:
                        (intents if intent else dimensions)[name.upper()] = (intent[1].upper() if intent else shape, s)
                    standalone.append((s, parsed, bool(intent)))
                except ConversionError as error:
                    review(s, str(error))

        used_intents, used_dimensions = set(), set()

        def replace(statement, replacement):
            # Keep all full-line comments between continuation lines untouched.
            for i in statement.lines:
                field = split_line(lines[start + i])[0][6:72]
                _, comment, _ = code_comment(field)
                edits[start + i] = ['      ' + comment + newline] if comment else []
            first = start + statement.lines[0]
            edits[first] = replacement + edits[first]

        newline = next((split_line(lines[start + i])[1] for s in body for i in s.lines
                        if split_line(lines[start + i])[1]), '\n')
        for position, (s, (typ, attrs, items)) in types.items():
            groups, consumed_i, consumed_d = [], set(), set()
            for ordinal, (name, shape, length) in enumerate(items):
                key, attributes = name.upper(), list(attrs)
                if key in intents:
                    if any(re.match(r'INTENT\b', a, re.I) for a in attrs):
                        raise ConversionError(f'{procedure}: repeated INTENT for {name}')
                    attributes.append('INTENT(' + intents[key][0] + ')')
                    consumed_i.add(key)
                if key in dimensions:
                    if shape or any(re.match(r'DIMENSION\b', a, re.I) for a in attrs):
                        raise ConversionError(f'{procedure}: repeated DIMENSION for {name}')
                    bounds = dimensions[key][0]
                    dependencies = {n.upper() for n in NAME.findall(bounds)}
                    safe = all(n in typed_at and typed_at[n] < (position, ordinal) and
                               (n in dummies or n not in parameters or parameters[n] < position)
                               for n in dependencies)
                    if safe:
                        shape = bounds
                        consumed_d.add(key)
                    else:
                        review(dimensions[key][1], 'Dimension retained to preserve specification order: ' + name)
                prefix = typ + ''.join(', ' + a for a in attributes) + ' ::'
                item = name + shape + length
                # Adjacent groups only: never reorder entities or dependencies.
                if groups and groups[-1][0] == prefix:
                    groups[-1][1].append(item)
                else:
                    groups.append((prefix, [item]))
            try:
                replacement = [line for prefix, names in groups for line in emit(prefix, names, newline)]
            except ConversionError as error:
                review(s, str(error))
                continue
            original = [lines[start + i] for i in s.lines]
            if replacement != original:
                replace(s, replacement)
                types_changed += 1
            used_intents.update(consumed_i)
            used_dimensions.update(consumed_d)
        for s, parsed, is_intent in standalone:
            used = used_intents if is_intent else used_dimensions
            left = [(n, shape, length) for n, shape, length in parsed if n.upper() not in used]
            if len(left) != len(parsed):
                prefix = ('INTENT(' + intents[parsed[0][0].upper()][0] + ')' if is_intent else 'DIMENSION')
                replace(s, emit(prefix, [n + shape + length for n, shape, length in left], newline) if left else [])
            if is_intent:
                for name, _, _ in left:
                    review(s, 'Intent retained; no safely editable type declaration: ' + name)
        intents_combined += len(used_intents)
        dimensions_combined += len(used_dimensions)
    output = ''.join(''.join(edits[i]) if i in edits else line for i, line in enumerate(lines)).encode('latin-1')
    return Result(output, len(scopes), types_changed, intents_combined, dimensions_combined, reviews)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    destination = parser.add_mutually_exclusive_group()
    destination.add_argument('--output', type=Path)
    destination.add_argument('--in-place', action='store_true')
    parser.add_argument('--report', type=Path, help='Write a new JSON review report')
    parser.add_argument('--diff', action='store_true')
    args = parser.parse_args(argv)
    try:
        # Check destinations before making any files or changing the source.
        backup = args.source.with_name(args.source.name + '.declarations.bak')
        destinations = [p for p in (args.output, args.report, backup if args.in_place else None) if p]
        if len({p.resolve() for p in destinations}) != len(destinations) or any(p.exists() for p in destinations):
            raise ConversionError('Output, report and backup must be distinct new files')
        original = args.source.read_bytes()
        result = transform(original)
        if args.diff:
            sys.stdout.writelines(difflib.unified_diff(original.decode('latin-1').splitlines(True),
                                  result.data.decode('latin-1').splitlines(True),
                                  fromfile=str(args.source), tofile=str(args.output or args.source)))
        if args.output:
            with args.output.open('xb') as stream:
                stream.write(result.data)
        elif args.in_place and original != result.data:
            with backup.open('xb') as stream:
                stream.write(original)
            args.source.write_bytes(result.data)
        if args.report:
            with args.report.open('x', encoding='utf-8', newline='\n') as stream:
                json.dump({'input_sha256': hashlib.sha256(original).hexdigest(),
                           'output_sha256': hashlib.sha256(result.data).hexdigest(),
                           **result.report()}, stream, indent=2)
                stream.write('\n')
        print(('Written' if args.output or args.in_place else 'Preview (no source files changed)') + ': ' +
              f'{result.type_statements_changed} type statements; {result.intents_combined} intents and '
              f'{result.dimensions_combined} dimensions combined; {len(result.reviews)} review notes.')
        return 0
    except (OSError, ConversionError) as error:
        print('error: ' + str(error), file=sys.stderr)
        return 2


if __name__ == '__main__':
    raise SystemExit(main())
