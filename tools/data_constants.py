"""Apply reviewed read-only DATA-to-PARAMETER conversions to free-form code."""
import json
from pathlib import Path
import re

from combine_declarations import split_list, type_declaration
from fortran_procedures import procedure_spans
from format_free_form import groups, wrap_line
from procedure_purity import code_hash

MANIFEST = Path(__file__).with_name('data-constants.json')


def dimensions(shape):
    if not shape:
        return []
    bounds = []
    for value in split_list(shape[1:-1]):
        pair = value.split(':')
        bounds.append((1, int(pair[0])) if len(pair) == 1 else (int(pair[0]), int(pair[1])))
    return bounds


def locations(name, bounds):
    if not bounds:
        return [(name, ())]
    result = [()]
    for lo, hi in bounds:
        result = [indices + (i,) for i in range(lo, hi + 1) for indices in result]
    return [(name, indices) for indices in result]


def parse_data(logical, declarations):
    """Return ordinary DATA groups, retaining target and literal spellings."""
    text = re.sub(r'^\s*data\s+', '', logical, flags=re.I)
    slash, depth, quote, i = [], 0, '', 0
    while i < len(text):
        char = text[i]
        if quote:
            if char == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    i += 1
                else:
                    quote = ''
        elif char in "'\"":
            quote = char
        elif char == '(':
            depth += 1
        elif char == ')':
            depth -= 1
        elif char == '/' and depth == 0:
            slash.append(i)
        i += 1
    if quote or depth or not slash or len(slash) % 2:
        raise ValueError('Unsupported DATA delimiters')
    result, previous = [], 0
    for start, end in zip(slash[::2], slash[1::2]):
        target_text = text[previous:start].strip().lstrip(',').strip()
        targets = []
        for raw in split_list(target_text):
            match = re.fullmatch(r'(\w+)\s*(\([^)]*\))?', raw)
            if not match:
                raise ValueError('Unsupported DATA target: ' + raw)
            name = match[1].lower()
            if name not in declarations:
                raise ValueError('Undeclared DATA target: ' + name)
            if match[2]:
                indices = tuple(int(s.strip()) for s in split_list(match[2][1:-1]))
                cells = [(name, indices)]
            else:
                cells = locations(name, dimensions(declarations[name]['shape']))
            targets.append((raw, cells))
        values = []
        for raw in split_list(text[start + 1:end]):
            repeat = re.match(r'^(\d+)\s*\*\s*(.*)$', raw)
            values.extend([repeat[2]]*int(repeat[1]) if repeat else [raw])
        if sum(len(cells) for _, cells in targets) != len(values):
            raise ValueError('DATA target/value counts differ')
        result.append((targets, values))
        previous = end + 1
    if text[previous:].strip().strip(','):
        raise ValueError('Unsupported trailing DATA text')
    return result


def declarations_in(body):
    declarations = {}
    for records, logical in groups(body.splitlines(True)):
        if re.match(r'^\s*(?:integer|real|double\s+(?:precision|complex)|complex|logical|character)\b.*?,\s*parameter\b', logical, re.I):
            continue
        declaration = type_declaration(logical)
        if declaration:
            typ, attrs, items = declaration
            for name, shape, length in items:
                declarations[name.lower()] = {'type': typ.lower(), 'attrs': attrs,
                                              'shape': shape, 'length': length,
                                              'annotated': any(r.comment for r in records)}
    return declarations


def expand_data_repeats(text):
    """Expand repetition syntax for GNU dumps, which omit DATA repeat counts."""
    lines, output, previous = text.splitlines(True), [], 0
    for _, start, end in procedure_spans(text):
        body = ''.join(lines[start:end])
        statements = list(groups(body.splitlines(True)))
        repeated = [(r, logical) for r, logical in statements if re.match(r'^\s*data\s+', logical, re.I)
                    and re.search(r'\d+\s*\*', logical)]
        if not repeated:
            continue
        declarations = declarations_in(body)
        removed, edits = set(), {}
        for records, logical in repeated:
            pairs = parse_data(logical, declarations)
            replacement = 'data ' + ', '.join(', '.join(raw for raw, _ in targets) + ' /' + ', '.join(values) + '/'
                                             for targets, values in pairs)
            removed.update(r.index for r in records)
            edits[records[0].index] = wrap_line('', replacement, '', '', records[0].newline, 3)
        output.extend(lines[previous:start])
        output.extend(edits.get(i, '') + (line if i not in removed else '') for i, line in enumerate(body.splitlines(True)))
        previous = end
    output.extend(lines[previous:])
    return ''.join(output)


def parameter(name, declaration, values):
    typ, shape, length = declaration['type'], declaration['shape'], declaration['length']
    if shape:
        constructor_type = re.sub(r'character\*(\d+)', r'character(len=\1)', typ)
        constructor = '[' + constructor_type + ' :: ' + ', '.join(values) + ']'
        bounds = dimensions(shape)
        if len(bounds) > 1:
            constructor = 'reshape(' + constructor + ', [' + ', '.join(str(hi - lo + 1) for lo, hi in bounds) + '])'
        value = constructor
    else:
        value = values[0]
    return wrap_line('', f'{typ}, parameter :: {name}{shape}{length} = {value}', '', '', '\n', 3)


def transform(text, manifest=None):
    manifest = json.loads(MANIFEST.read_text()) if manifest is None else manifest
    lines, output, previous = text.splitlines(True), [], 0
    for name, start, end in procedure_spans(text):
        entry = manifest['procedures'].get(name)
        if entry is None:
            continue
        body = ''.join(lines[start:end])
        if code_hash(body) != entry['source_hash']:
            raise ValueError(f'{name}: code changed since DATA constant review')
        declarations = declarations_in(body)
        selected = set(entry['constants'])
        logical_groups = list(groups(body.splitlines(True)))
        removed, edits, anchor = set(), {}, None
        for records, logical in logical_groups:
            declaration = type_declaration(logical)
            save = re.match(r'^\s*save\s+(?:::)?\s*(.+)', logical, re.I)
            if declaration or re.match(r'^\s*(?:implicit|external|intrinsic|parameter|common|equivalence|save)\b', logical, re.I):
                anchor = records[-1].index + 1
            replacement = None
            if declaration:
                kept = [(n, s, l) for n, s, l in declaration[2] if n.lower() not in selected]
                if len(kept) != len(declaration[2]):
                    replacement = logical.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(n + s + l for n, s, l in kept) if kept else ''
            elif save:
                names = split_list(save[1])
                kept = [n for n in names if n.lower() not in selected]
                if kept != names:
                    replacement = 'save ' + ', '.join(kept) if kept else ''
            elif re.match(r'^\s*data\s+', logical, re.I):
                pairs, changed = [], False
                for targets, values in parse_data(logical, declarations):
                    names = {n for _, cells in targets for n, _ in cells}
                    if not names & selected:
                        pairs.append(', '.join(raw for raw, _ in targets) + ' /' + ', '.join(values) + '/')
                        continue
                    changed = True
                    kept_targets, kept_values, offset = [], [], 0
                    for raw, cells in targets:
                        if cells[0][0] not in selected:
                            kept_targets.append(raw)
                            kept_values.extend(values[offset:offset + len(cells)])
                        offset += len(cells)
                    if kept_targets:
                        pairs.append(', '.join(kept_targets) + ' /' + ', '.join(kept_values) + '/')
                if changed:
                    replacement = 'data ' + ', '.join(pairs) if pairs else ''
            if replacement is not None:
                if any(r.comment for r in records):
                    raise ValueError(f'{name}: annotated declaration needs review')
                removed.update(r.index for r in records)
                if replacement:
                    edits[records[0].index] = wrap_line('', replacement, '', '', records[0].newline, 3)
        if anchor is None:
            raise ValueError(f'{name}: missing specification insertion point')
        insertion = ''.join(parameter(n, declarations[n], v) for n, v in entry['constants'].items())
        output.extend(lines[previous:start])
        for i, line in enumerate(body.splitlines(True)):
            if i == anchor:
                output.append(insertion)
            output.append(edits.get(i, '') + (line if i not in removed else ''))
        previous = end
    output.extend(lines[previous:])
    return ''.join(output)
