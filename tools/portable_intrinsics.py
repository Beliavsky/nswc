"""Use portable generic GAMMA for two GNU-specific DGAMMA intrinsic calls."""
import re

from combine_declarations import type_declaration
from fortran_procedures import procedure_spans
from format_free_form import TOKEN, groups, wrap_line


def transform(text):
    lines, output, previous = text.splitlines(True), [], 0
    for name, start, end in procedure_spans(text):
        if name not in ('DRCOMP', 'DGINV'):
            continue
        body = lines[start:end]
        removed, edits, calls, inserted = set(), {}, 0, False
        for records, logical in groups(body):
            constant = bool(re.search(r',\s*parameter\b', logical, re.I))
            declaration = None if constant else type_declaration(logical)
            if declaration:
                kept = [(n, s, l) for n, s, l in declaration[2] if n.lower() != 'dgamma']
                if len(kept) != len(declaration[2]):
                    if any(r.comment for r in records):
                        raise ValueError(f'{name}: annotated DGAMMA declaration needs review')
                    replacement = logical.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(n + s + l for n, s, l in kept) if kept else ''
                    removed.update(r.index for r in records)
                    if replacement:
                        edits[records[0].index] = wrap_line('', replacement, '', '', '\n', 3)
        output.extend(lines[previous:start])
        for i, line in enumerate(body):
            if i in removed:
                output.append(edits.get(i, ''))
                continue
            tokens = []
            for token in TOKEN.finditer(line):
                if token[0] == '!':
                    break
                tokens.append(token)
            for token, following in reversed(list(zip(tokens, tokens[1:]))):
                if token[0].lower() == 'dgamma' and following[0] == '(':
                    line = line[:token.start()] + 'gamma' + line[token.end():]
                    calls += 1
            output.append(line)
            if not inserted and re.match(r'^\s*implicit\s+none\s*$', line, re.I):
                output.append('intrinsic :: gamma\n')
                inserted = True
        if calls != 1 or not inserted:
            raise ValueError(f'{name}: portable intrinsic conversion needs review')
        previous = end
    output.extend(lines[previous:])
    return ''.join(output)
