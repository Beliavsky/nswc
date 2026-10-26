"""Reviewed storage modernization: equivalences and private module state.

External COMMON blocks retain their ABI. Module procedures use private saved
variables instead. Layout views are matched by type and offset; unused padding
views disappear. The DEBDF1 save/restore entry points explicitly pack all slots.
"""
from collections import defaultdict
import copy
import json
from pathlib import Path
import re

from combine_declarations import split_list, type_declaration
from data_constants import dimensions, declarations_in
from format_free_form import groups, TOKEN, wrap_line
from fortran_procedures import procedure_spans, procedure_blocks
from procedure_purity import code_hash

MANIFEST = Path(__file__).with_name('shared-storage.json')
COMMON = re.compile(r'^\s*common\s*/(\w+)/\s*(.+)$', re.I)
SIZES = {'INTEGER': 4, 'REAL': 4, 'DOUBLE PRECISION': 8, 'LOGICAL': 4, 'COMPLEX': 8}
FENCES = {'spdata', 'dpdata', 'cubatb'}
ALIASES = {'alfa1': ('alfa', 0), 'alfa2': ('alfa', 2),
           'beta1': ('beta', 0), 'beta2': ('beta', 2), 'beta3': ('beta', 4)}
EXPECTED_EQUIVALENCES = {
    'ASJY': {'equivalence(alfa(1,1),alfa1(1,1))', 'equivalence(alfa(1,3),alfa2(1,1))',
             'equivalence(beta(1,1),beta1(1,1))', 'equivalence(beta(1,3),beta2(1,1))',
             'equivalence(beta(1,5),beta3(1,1))'},
    'SFFT': {'equivalence(i,ii)'},
    'ADCOMP': {'equivalence(fleft(2),fdervl(1)),(fright(2),fdervr(1))'},
}


def declaration(code):
    return None if re.search(r',\s*parameter\b', code, re.I) else type_declaration(code)


def host_groups(body):
    depth = 0
    for physical, code in groups(body.splitlines(True)):
        if re.match(r'^\s*(?:abstract\s+)?interface\b', code, re.I):
            depth += 1
        elif re.match(r'^\s*end\s*interface\b', code, re.I):
            depth -= 1
            continue
        elif re.match(r'^\s*contains\b', code, re.I):
            break
        if not depth:
            yield physical, code


def replace_names(code, mapping):
    for token in reversed(list(TOKEN.finditer(code))):
        value = mapping.get(token[0].lower())
        if value is not None:
            code = code[:token.start()] + value + code[token.end():]
    return code


def edited_group(edits, removed, start, physical, code):
    record = physical[0]
    label = re.match(r'\s*(\d+\s+)?', record.code)[1] or ''
    indent = re.match(r'\s*', record.code)[0]
    text = wrap_line(indent + label, code, '', '', record.newline, len(indent) + 3) if code else ''
    edits[start + record.index] = text + (indent + record.comment + record.newline if record.comment else '')
    for r in physical[1:]:
        if r.comment:
            edits[start + r.index] = indent + r.comment + r.newline
    removed.update(start + r.index for r in physical)


def equivalence_free(text, manifest=None):
    manifest = json.loads(MANIFEST.read_text()) if manifest is None else manifest
    lines, edits, removed = text.splitlines(True), {}, set()
    for host, start, end in procedure_spans(text):
        entry = manifest['equivalences'].get(host)
        if entry is None:
            continue
        body = ''.join(lines[start:end])
        digest = code_hash(body)
        if digest == entry.get('output_hash'):
            continue
        if digest != entry['source_hash']:
            raise ValueError(f'{host}: storage review is stale')
        drop = set(ALIASES) if host == 'ASJY' else {'ii'} if host == 'SFFT' else {'fdervl', 'fdervr'}
        counts = defaultdict(int)
        for physical, code in host_groups(body):
            updated = None
            if re.match(r'^\s*equivalence\b', code, re.I):
                if code not in entry['statements']:
                    raise ValueError(f'{host}: unexpected EQUIVALENCE')
                updated = ''
                counts['equivalences'] += 1
            elif (decl := declaration(code)) and drop & {n.lower() for n, _, _ in decl[2]}:
                kept = [n + shape + length for n, shape, length in decl[2] if n.lower() not in drop]
                updated = code.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(kept) if kept else ''
            elif host == 'ASJY' and re.match(r'^\s*data\b', code, re.I):
                def target(m):
                    name, offset = ALIASES[m[1].lower()]
                    counts[m[1].lower()] += 1
                    return f'{name}({int(m[2])},{int(m[3]) + offset})'
                updated = re.sub(r'\b(alfa1|alfa2|beta1|beta2|beta3)\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)', target, code, flags=re.I)
            elif host == 'SFFT':
                updated = replace_names(code, {'ii': 'i'})
            elif host == 'ADCOMP':
                updated = replace_names(code, {'fdervl': 'fleft(2:10)', 'fdervr': 'fright(2:10)'})
            if updated is not None and updated != code:
                edited_group(edits, removed, start, physical, updated)
        if counts['equivalences'] != len(entry['statements']):
            raise ValueError(f'{host}: equivalence inventory differs')
        if host == 'ASJY' and {n: counts[n] for n in ALIASES} != {'alfa1': 52, 'alfa2': 52, 'beta1': 52, 'beta2': 52, 'beta3': 26}:
            raise ValueError('ASJY coefficient alias inventory differs')
    return ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines))


def equivalence_review(text):
    entries = {}
    for name, body in procedure_blocks(text).items():
        statements = [code for _, code in host_groups(body) if re.match(r'^\s*equivalence\b', code, re.I)]
        if statements:
            if name not in {'ASJY', 'SFFT', 'ADCOMP'}:
                raise ValueError('Unreviewed equivalence host: ' + name)
            if {re.sub(r'\s+', '', s).lower() for s in statements} != EXPECTED_EQUIVALENCES[name]:
                raise ValueError('Unreviewed equivalence association in ' + name)
            declarations = declarations_in(body)
            expected = ({'i': ('integer', []), 'ii': ('integer', [])} if name == 'SFFT' else
                        {n: ('double precision', [(1, 10)] if n in {'fleft', 'fright'} else [(1, 9)])
                         for n in ('fleft', 'fright', 'fdervl', 'fdervr')} if name == 'ADCOMP' else
                        {n: ('real', [(1, 26), (1, width)]) for n, width in
                         [('alfa', 4), ('alfa1', 2), ('alfa2', 2), ('beta', 5), ('beta1', 2), ('beta2', 2), ('beta3', 1)]})
            for variable, (typ, bounds) in expected.items():
                entry = declarations.get(variable, {})
                if entry.get('type') != typ or dimensions(entry.get('shape', '')) != bounds:
                    raise ValueError(f'{name}:{variable}: unreviewed storage type/shape')
            entries[name] = {'source_hash': code_hash(body), 'statements': statements}
    manifest = {'equivalences': entries}
    converted = procedure_blocks(equivalence_free(text, manifest))
    for name, entry in entries.items():
        entry['output_hash'] = code_hash(converted[name])
    return manifest


def common_views(text):
    views = {}
    for host, body in procedure_blocks(text).items():
        if not re.search(r'^\s*common\b', body, re.M | re.I):
            continue
        declarations, commons, uses = {}, [], set()
        statements = list(host_groups(body))
        for _, code in statements:
            if decl := declaration(code):
                typ, attrs, items = decl
                for name, shape, length in items:
                    declarations[name.lower()] = {'type': typ, 'shape': shape, 'attrs': attrs}
                    uses.update(m[0].lower() for m in TOKEN.finditer(shape))
            elif match := COMMON.fullmatch(code):
                commons.append(match)
            elif not re.match(r'^\s*(?:implicit|end|subroutine|function|external|intrinsic|interface|format)\b', code, re.I):
                uses.update(m[0].lower() for m in TOKEN.finditer(code))
        blocks = {}
        for match in commons:
            block, offset, entries = match[1].lower(), 0, []
            for item in split_list(match[2]):
                entity = re.fullmatch(r'\s*(\w+)\s*(\([^)]*\))?\s*', item)
                if not entity:
                    raise ValueError(f'{host}: unsupported COMMON entity: {item}')
                name = entity[1].lower()
                decl = declarations[name]
                if decl['type'] not in SIZES or decl['attrs']:
                    raise ValueError(f'{host}:{name}: unsupported COMMON type/attributes')
                shape = entity[2] or decl['shape']
                bounds = dimensions(shape)
                if any(lo != 1 for lo, hi in bounds):
                    raise ValueError(f'{host}:{name}: nondefault COMMON lower bound')
                dims = [hi for lo, hi in bounds]
                count = 1
                for extent in dims:
                    count *= extent
                size = SIZES[decl['type']]
                offset = (offset + size - 1)//size*size
                entries.append({'name': name, 'type': decl['type'], 'dims': dims,
                                'offset': offset, 'bytes': size*count, 'used': name in uses})
                offset += size*count
            blocks[block] = entries
        views[host] = blocks
    return views


def state_layout(views):
    blocks = defaultdict(list)
    for host, groups in views.items():
        for block, entries in groups.items():
            blocks[block].extend((host, e) for e in entries)
    result = {}
    for block, candidates in blocks.items():
        # The two packed views are implemented explicitly, not aliased over
        # discontiguous module variables. Other used views must agree exactly.
        candidates = [(host, e) for host, e in candidates if host not in {'RSCO', 'SVCO'}]
        selected = []
        for host, e in sorted(candidates, key=lambda pair: (not pair[1]['used'], pair[1]['bytes'])):
            overlap = [a for a in selected if a['offset'] < e['offset'] + e['bytes'] and e['offset'] < a['offset'] + a['bytes']]
            same = [a for a in overlap if all(a[k] == e[k] for k in ('offset', 'bytes', 'type', 'dims'))]
            if overlap:
                if e['used'] and not same:
                    raise ValueError(f'{block}:{host}:{e["name"]}: overlapping active COMMON views require review')
                continue
            field = copy.deepcopy(e)
            field['state'] = 'nswc_state_' + block + '_' + e['name']
            field.pop('used')
            selected.append(field)
        result[block] = sorted(selected, key=lambda e: e['offset'])
    if 'debdf1' in result:
        covered = {i for e in result['debdf1'] for i in range(e['offset'], e['offset'] + e['bytes'])}
        if covered != set(range(4*(218 + 33))):
            raise ValueError('DEBDF1 packed state coverage differs')
    return result


def binding_map(host, blocks, layout):
    mapping = {}
    for block, entries in blocks.items():
        for e in entries:
            matches = [f for f in layout[block] if all(f[k] == e[k] for k in ('offset', 'bytes', 'type', 'dims'))]
            if matches:
                mapping[e['name']] = matches[0]['state']
            elif e['used'] and host not in {'RSCO', 'SVCO'}:
                raise ValueError(f'{host}:{e["name"]}: active COMMON view has no state field')
    return mapping


def packed_copy(host, layout):
    output = []
    for e in layout['debdf1']:
        real = e['type'] == 'REAL'
        if not real and e['type'] != 'INTEGER':
            raise ValueError('DEBDF1 packing requires default real/integer storage')
        lo = e['offset']//4 + 1 - (0 if real else 218)
        count = e['bytes']//4
        vec = ('rsav' if real else 'isav') + '(' + (str(lo) if count == 1 else f'{lo}:{lo + count - 1}') + ')'
        field = e['state']
        if host == 'RSCO':
            rhs = f"reshape({vec}, [{', '.join(map(str, e['dims']))}])" if len(e['dims']) > 1 else vec
            output.append(field + ' = ' + rhs)
        else:
            rhs = f'reshape({field}, [{count}])' if len(e['dims']) > 1 else field
            output.append(vec + ' = ' + rhs)
    return output


def module_state(text, report=None):
    views = common_views(text)
    if not views:
        return text
    if any(token[0].lower().startswith('nswc_state_')
           for physical, code in groups(text.splitlines(True)) for token in TOKEN.finditer(code)):
        raise ValueError('Reserved module state identifier already exists')
    layout = state_layout(views)
    lines, edits, removed = text.splitlines(True), {}, set()
    for host, start, end in procedure_spans(text):
        if host not in views:
            continue
        mapping = binding_map(host, views[host], layout)
        names = {e['name'] for entries in views[host].values() for e in entries}
        executable = []
        for physical, code in host_groups(''.join(lines[start:end])):
            updated = code
            if COMMON.fullmatch(code):
                updated = ''
            elif decl := declaration(code):
                kept = [n + shape + length for n, shape, length in decl[2] if n.lower() not in names]
                if len(kept) != len(decl[2]):
                    updated = code.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(kept) if kept else ''
                updated = replace_names(updated, mapping)
            elif re.match(r'^\s*(?:subroutine|function|implicit|end\s+(?:subroutine|function)|external|intrinsic|format)\b', code, re.I):
                pass
            else:
                if re.match(r'^\s*equivalence\b', code, re.I) and names & {m[0].lower() for m in TOKEN.finditer(code)}:
                    raise ValueError(f'{host}: remove COMMON equivalences before module state migration')
                if host in {'RSCO', 'SVCO'} and not re.search(r',\s*parameter\b', code, re.I):
                    executable.append((physical, code))
                    continue
                updated = replace_names(code, mapping)
            if updated != code:
                edited_group(edits, removed, start, physical, updated)
        if host in {'RSCO', 'SVCO'}:
            expected = ['doi=1,lenrls', ('rls(i)=rsav(i)' if host == 'RSCO' else 'rsav(i)=rls(i)'), 'enddo',
                        'doi=1,lenils', ('ils(i)=isav(i)' if host == 'RSCO' else 'isav(i)=ils(i)'), 'enddo']
            if [re.sub(r'\s+', '', code).lower() for _, code in executable] != expected:
                raise ValueError(host + ': packed state implementation changed')
            for physical, code in executable:
                edited_group(edits, removed, start, physical, '')
            record = executable[0][0][0]
            edits[start + record.index] = ''.join(wrap_line('', c, '', '', '\n', 3) for c in packed_copy(host, layout))
    declarations = []
    for block, fields in layout.items():
        for e in fields:
            shape = '(' + ','.join(map(str, e['dims'])) + ')' if e['dims'] else ''
            attrs = ', save, volatile' if block in FENCES else ', save'
            declarations.append(f"{e['type'].lower()}{attrs} :: {e['state']}{shape}\n")
    # Module scope has exactly one CONTAINS before all procedure definitions.
    first = min(start for _, start, _ in procedure_spans(text))
    prefix_contains = [i for i in range(first) if re.match(r'^\s*contains\s*$', lines[i], re.I)]
    if len(prefix_contains) != 1:
        raise ValueError('Expected one enclosing module')
    at = prefix_contains[0]
    edits[at] = ''.join(declarations) + lines[at]
    if report is not None:
        report.update({'views': views, 'layout': layout,
                       'common_blocks': len(layout), 'common_statements': sum(map(len, views.values()))})
    return ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines))


def normalize_module_records(external, module, review):
    """Check each private state field before restoring reviewed COMMON names.

    This normalization is only for comparing the remaining compiler records;
    module regeneration and packed-state tests separately verify all bindings.
    """
    result = copy.deepcopy(module)
    parent = result.pop('NSWC_MOD')
    for block, fields in review['layout'].items():
        for field in fields:
            reference = next(external[host][e['name']]
                             for host, blocks in review['views'].items()
                             for e in blocks.get(block, [])
                             if all(e[k] == field[k] for k in ('name', 'offset', 'bytes', 'dims', 'type')))
            actual = parent[field['state']]
            if any(actual.get(k) != reference.get(k) for k in ('type spec', 'Array spec')):
                raise ValueError('Module state type/bounds changed: ' + field['state'])
            attrs = set(actual['attributes'].removeprefix('attributes: (').removesuffix(')').split())
            if not {'SAVE', 'EXPLICIT-SAVE'} & attrs or 'IN-COMMON' in attrs or ('VOLATILE' in attrs) != (block in FENCES):
                raise ValueError('Module state lifetime/visibility/fence differs: ' + field['state'])
    for host, scope in result.items():
        if host.lower() in parent:
            scope[host.lower()] = parent[host.lower()]
        for name in list(scope):
            if name.startswith('nswc_state_'):
                del scope[name]
        for entries in review['views'].get(host, {}).values():
            for e in entries:
                scope[e['name']] = external[host][e['name']]
    return result


def new_state_intrinsics(review):
    if any(len(e['dims']) > 1 for e in review['layout'].get('debdf1', [])):
        return {('RSCO', 'reshape'), ('SVCO', 'reshape')}
    return set()
