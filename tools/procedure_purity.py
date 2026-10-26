"""Apply reviewed PURE/ELEMENTAL contracts to generated external procedures.

The manifest records code hashes and compiler-derived call references. Local
interfaces make pure and elemental calls explicit without a module dependency.
No fixed-form source or executable statement is edited by this pass.
"""
import hashlib
import json
from pathlib import Path
import re

from combine_declarations import type_declaration, split_list
from fortran_procedures import procedure_spans
from format_free_form import format_source, groups, semantic_statements, wrap_line
from lowercase_fortran import lowercase

MANIFEST = Path(__file__).with_name('procedure-purity.json')


def code_hash(text):
    return hashlib.sha256(repr(semantic_statements(text)).encode('ascii')).hexdigest()


def transform(text, manifest=None):
    if manifest is None:
        if not MANIFEST.exists():
            return text
        manifest = json.loads(MANIFEST.read_text())
    lines = text.splitlines(True)
    entries = manifest['procedures']
    output, previous = [], 0
    for name, start, end in procedure_spans(text):
        original = ''.join(lines[start:end])
        if code_hash(original) != manifest['source_hashes'].get(name):
            raise ValueError(f'{name}: code changed since purity analysis; regenerate the review')
        local_interfaces = [callee for callee in manifest['calls'].get(name, [])
                            if callee in entries and (name in entries or entries[callee]['attribute'] == 'pure elemental')]
        body = lines[start:end]
        edits, removed, anchor = {}, set(), None
        for records, logical in groups(body):
            decl = type_declaration(logical)
            external = re.match(r'^\s*external\s+(?:::)?\s*(.*)', logical, re.I)
            if decl:
                anchor = records[-1].index + 1
                kept = [(n, shape, length) for n, shape, length in decl[2] if n.upper() not in local_interfaces]
                if len(kept) == len(decl[2]):
                    continue
                if '::' not in logical:
                    raise ValueError('Expected combined type declarations')
                replacement = logical.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(n + s + l for n, s, l in kept) if kept else ''
            elif external:
                names = split_list(external[1])
                kept = [n for n in names if n.upper() not in local_interfaces]
                if kept == names:
                    continue
                replacement = 'external ' + ', '.join(kept) if kept else ''
            else:
                continue
            if any(r.comment for r in records):
                raise ValueError(f'{name}: annotated declaration needs review')
            removed.update(r.index for r in records)
            if replacement:
                edits[records[0].index] = wrap_line('', replacement, '', '', records[0].newline, 3)
        if name in entries:
            edits[0] = entries[name]['attribute'] + ' ' + body[0].lstrip()
            removed.add(0)
        insertion = ''
        if local_interfaces:
            if anchor is None:
                raise ValueError(f'{name}: no declaration insertion point')
            insertion = 'interface\n'
            for callee in sorted(local_interfaces):
                signature = lowercase(entries[callee]['interface'])
                insertion += signature
            insertion += 'end interface\n'
        changed = ''.join((insertion if i == anchor else '') + edits.get(i, '') +
                          (line if i not in removed else '') for i, line in enumerate(body))
        if anchor == len(body):
            changed += insertion
        output.extend(lines[previous:start])
        output.append(changed)
        previous = end
    output.extend(lines[previous:])
    return format_source(''.join(output))
