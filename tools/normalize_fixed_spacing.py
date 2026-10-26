"""Tighten parentheses in fixed-form Fortran without changing its tokens.

Keep columns 1--6, comments, literal text, FORMAT records, sequence fields and
physical line counts. Continued character literals and Hollerith statements are
left unchanged. Only unnecessary blanks are removed; no records grow or wrap.
"""
import argparse
from pathlib import Path
import re

from format_free_form import TOKEN, conditional_end
from name_procedure_ends import statements, split_line, code_comment


CONTROLS = {'if', 'elseif', 'while', 'case', 'where', 'forall', 'read', 'write',
            'open', 'close', 'inquire', 'backspace', 'rewind', 'endfile', 'flush',
            'wait', 'allocate', 'deallocate', 'nullify', 'associate', 'critical',
            'goto', 'to', 'is'}


def tighten(code):
    matches = list(TOKEN.finditer(code))
    if not matches:
        return code
    values = [m[0] for m in matches]
    gaps = [code[:matches[0].start()]]
    gaps.extend(code[a.end():b.start()] for a, b in zip(matches, matches[1:]))
    gaps.append(code[matches[-1].end():])
    close = conditional_end(values)
    starts = {0, 1 if values[:1] and values[0].lower() in {'do', 'else', 'select', 'type', 'class', 'go'} else 0}
    if values[1:2] == [':']:
        starts.update({2, 3})
    if close is not None:
        starts.add(close + 1)
    for i, value in enumerate(values):
        if i and value == '(':
            previous = values[i - 1]
            control = i - 1 in starts and previous.lower() in CONTROLS
            if re.fullmatch(r'[A-Za-z_]\w*', previous) and not control:
                gaps[i] = ''
        if value == '(' and i + 1 < len(values):
            gaps[i + 1] = ''
        if value == ')' and i:
            gaps[i] = ''
    return ''.join(g + v for g, v in zip(gaps, values)) + gaps[-1]


def transform(data):
    lines = data.decode('latin-1').splitlines(keepends=True)
    for statement in statements(lines):
        if re.match(r'^\s*FORMAT\s*\(', statement.code, re.I):
            continue
        # Hollerith payloads and split character tokens require another lexer.
        if re.search(r'\d+H', statement.code, re.I):
            continue
        quote, fields = '', []
        for index in statement.lines:
            raw, newline = split_line(lines[index])
            code, comment, quote = code_comment(raw[6:72], quote)
            fields.append((index, raw, newline, code, comment, quote))
        if any(field[-1] for field in fields):
            continue
        for index, raw, newline, code, comment, _ in fields:
            revised = tighten(code)
            if revised == code:
                continue
            # Keep inline comments at the same column as the original record.
            if comment:
                revised = revised.ljust(len(code)) + comment
            body = raw[:6] + revised
            if len(raw) > 72:
                body = body.ljust(72) + raw[72:]
            lines[index] = body + newline
    return ''.join(lines).encode('latin-1')


def verify(before, after, compiler='gfortran'):
    from fixed_to_free import convert_text
    from format_free_form import semantic_statements
    from modernize_deleted_do import verify as compiler_verify
    from validate_explicit_typing import non_declaration_content
    if transform(before) != after or transform(after) != after:
        raise ValueError('Spacing conversion is not exact and idempotent')
    if semantic_statements(convert_text(before.decode('latin-1'))) != semantic_statements(convert_text(after.decode('latin-1'))):
        raise ValueError('Spacing changed logical-statement tokens or literal text')
    if non_declaration_content(before)[1] != non_declaration_content(after)[1]:
        raise ValueError('Spacing changed comment text or order')
    old_lines, new_lines = before.splitlines(), after.splitlines()
    if len(old_lines) != len(new_lines) or any(a[:6] != b[:6] or a[72:] != b[72:] for a, b in zip(old_lines, new_lines)):
        raise ValueError('Spacing changed record counts or fixed-form control/sequence columns')
    compiler_verify(before, after, compiler)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--compiler')
    args = parser.parse_args()
    if args.output and args.output.exists():
        parser.error('--output must name a new file')
    before = args.source.read_bytes()
    after = transform(before)
    if args.compiler:
        verify(before, after, args.compiler)
    if args.output:
        with args.output.open('xb') as stream:
            stream.write(after)
    print('Changed records:', sum(a != b for a, b in zip(before.splitlines(), after.splitlines())))


if __name__ == '__main__':
    main()
