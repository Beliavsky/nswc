"""Format free-form external Fortran procedures without changing fixed source.

Use three-space block indentation, spaces around assignment and binary +/-,
and IF condition spacing. Remove unary + only at the start of assignment RHSs.
Comments, literal text and FORMAT records are preserved. Unsupported layouts
raise an error before the CLI writes its output. This is a lexical formatter,
not a general Fortran parser.
"""
import argparse
from dataclasses import dataclass
from pathlib import Path
import re


TOKEN = re.compile(r"'(?:[^']|'')*'|\"(?:[^\"]|\"\")*\"|"
                   r'(?:\d+\.(?!(?i:eq|ne|lt|le|gt|ge|and|or|not|eqv|neqv|true|false)\.)\d*|\.\d+|\d+)'
                   r'(?:[eEdD][+-]?\d+)?(?:_\w+)?|'
                   r'\.[A-Za-z]+\.|[A-Za-z_]\w*|\*\*|//|=>|==|/=|<=|>=|[^\s]')
HEADER = re.compile(r'^(?:(?:integer|real|double\s+precision|complex|logical|character)'
                    r'(?:\*\d+|\([^)]*\))?\s+)?(?:subroutine|function)\b', re.I)


@dataclass
class Record:
    index: int
    code: str
    comment: str
    newline: str
    continued_string: bool


def split_comment(body, quote=''):
    i = 0
    while i < len(body):
        char = body[i]
        if quote:
            if char == quote:
                if i + 1 < len(body) and body[i + 1] == quote:
                    i += 1
                else:
                    quote = ''
        elif char in "'\"":
            quote = char
        elif char == '!':
            return body[:i], body[i:], quote
        elif char == ';':
            raise ValueError('Semicolon-separated statements require review')
        i += 1
    return body, '', quote


def groups(lines):
    pending, logical, quote = [], [], ''
    for i, raw in enumerate(lines):
        body = raw.rstrip('\r\n')
        if not body.strip() or body.lstrip().startswith('!'):
            continue
        if body.lstrip().startswith('#'):
            raise ValueError(f'Line {i + 1}: preprocessor directive requires review')
        was_quoted = bool(quote)
        code, comment, quote = split_comment(body, quote)
        piece = code.lstrip()
        if pending and piece.startswith('&'):
            piece = piece[1:]
            if not was_quoted and logical[-1] and piece:
                pair = logical[-1][-1] + piece[0]
                if (re.fullmatch(r'[\w.]{2}', pair) or pair in ('**', '//', '=>', '==', '/=', '<=', '>=')):
                    raise ValueError(f'Line {i + 1}: a token split across continuation lines requires review')
        if was_quoted and not code.lstrip().startswith('&'):
            raise ValueError(f'Line {i + 1}: missing string continuation marker')
        continuing = piece.rstrip().endswith('&')
        if continuing:
            piece = piece.rstrip()[:-1]
        if not pending:
            piece = re.sub(r'^\d+\s+', '', piece)
        pending.append(Record(i, code, comment, raw[len(body):], was_quoted or bool(quote)))
        logical.append(piece)
        if not continuing:
            if quote:
                raise ValueError(f'Line {i + 1}: unterminated string')
            yield pending, ' '.join(logical)
            pending, logical = [], []
    if pending or quote:
        raise ValueError('Unterminated continuation at end of input')


def conditional_end(tokens):
    """Return the closing parenthesis of a leading IF/ELSE IF condition."""
    words = [t.lower() for t in tokens]
    first = 1 if words[:1] in (['if'], ['elseif']) else 2 if words[:2] == ['else', 'if'] else None
    if first is None or first >= len(words) or words[first] != '(':
        return None
    depth = 0
    for i in range(first, len(words)):
        if words[i] == '(':
            depth += 1
        elif words[i] == ')':
            depth -= 1
            if depth == 0:
                # An array named IF is an assignment, not an IF statement.
                return None if words[i + 1:i + 2] == ['='] else i
    return None


def assignment_equal(tokens):
    """Locate a simple assignment, including the action of a logical IF."""
    close = conditional_end(tokens)
    start = close + 1 if close is not None else 0
    if start >= len(tokens) or not re.fullmatch(r'[A-Za-z_]\w*', tokens[start]):
        return None
    i = start + 1
    if i < len(tokens) and tokens[i] == '(':
        depth = 1
        i += 1
        while i < len(tokens) and depth:
            depth += (tokens[i] == '(') - (tokens[i] == ')')
            i += 1
    return i if tokens[i:i + 1] == ['='] else None


def spacing(code, previous='', drop_plus=None, condition_close=None):
    matches = list(TOKEN.finditer(code))
    values = [m[0] for m in matches]
    close = conditional_end(values)
    gaps = [code[:matches[0].start()] if matches else code]
    gaps.extend(code[a.end():b.start()] for a, b in zip(matches, matches[1:]))
    gaps.append(code[matches[-1].end():] if matches else '')
    binary = set()
    prev = previous
    for i, value in enumerate(values):
        if value in ('+', '-') and (re.fullmatch(r'[A-Za-z_]\w*|(?:\d|\.\d).*', prev)
                                    or prev in (')', ']', '.true.', '.false.') or prev[:1] in ("'", '"')):
            binary.add(i)
        prev = value
    for i, value in enumerate(values):
        if value == '=' or i in binary:
            gaps[i] = gaps[i + 1] = ' '
        if value.lower() in ('if', 'elseif') and values[i + 1:i + 2] == ['('] and (i == 0 or values[i - 1].lower() == 'else'):
            gaps[i + 1] = ' '
    if close is not None and close + 1 < len(values):
        gaps[close + 1] = ' '
    if condition_close is not None and 0 <= condition_close < len(values) - 1:
        gaps[condition_close + 1] = ' '
    result = []
    for i, value in enumerate(values):
        if i == drop_plus:
            # Keep the assignment's required space without retaining unary +.
            gaps[i + 1] = ''
            result.append(gaps[i])
            continue
        result.extend((gaps[i], value))
    result.append(gaps[-1])
    return ''.join(result).strip(), values[-1] if values else previous


def wrap_line(prefix, code, suffix, tail, newline, continuation_indent):
    output = []
    while len(prefix + code + suffix) > 132:
        maximum = 132 - len(prefix) - 2  # Space and trailing ampersand.
        cuts = [m.end() for m in TOKEN.finditer(code) if m.end() <= maximum]
        if not cuts or cuts[-1] == len(code):
            raise ValueError('A single token cannot fit within 132 columns')
        cut = cuts[-1]
        output.append(prefix + code[:cut].rstrip() + ' &' + (newline or '\n'))
        code = code[cut:].lstrip()
        prefix = ' '*continuation_indent + '& '
    output.append(prefix + code + suffix + tail + newline)
    return ''.join(output)


def format_source(text):
    lines = re.findall(r'[^\r\n]*(?:\r\n|\r|\n|$)', text)
    if lines and not lines[-1]:
        lines.pop()
    result = list(lines)
    stack = []
    for records, logical in groups(lines):
        tokens = [m[0] for m in TOKEN.finditer(logical)]
        lexical = list(TOKEN.finditer(logical))
        for left, right in zip(lexical, lexical[1:]):
            if left[0].isdigit() and right[0].lower().startswith('h') and left.end() == right.start():
                raise ValueError('Unquoted Hollerith data require review')
        lowered = [t.lower() for t in tokens]
        control = tokens[2:] if len(tokens) > 2 and tokens[1] == ':' else tokens
        controls = [t.lower() for t in control]
        first = controls[0] if controls else ''
        compact = re.sub(r'\s+', '', logical).lower()
        label_match = re.match(r'^\s*(\d+)\s+', records[0].code)
        label = label_match[1] if label_match else None
        label_key = str(int(label)) if label else None
        is_header = HEADER.match(re.sub(r'^(?:(?:pure|elemental|impure|recursive)\s+)+', '', logical, flags=re.I))
        prototype = bool(is_header and stack and stack[-1][0] == 'interface')
        if is_header:
            if stack and not prototype:
                raise ValueError(f'Line {records[0].index + 1}: unclosed block at procedure boundary')
        prototype_end = compact.startswith(('endfunction', 'endsubroutine')) and stack and stack[-1][0] == 'prototype'
        do_end = re.fullmatch(r'(?i)end\s*do(?:\s+[a-z_]\w*)?', logical.strip())
        ending = ('prototype' if prototype_end else 'interface' if compact == 'endinterface' else
                  'do' if do_end else 'if' if compact == 'endif' else 'select' if compact == 'endselect' else None)
        if ending:
            if not stack or stack[-1][0] != ending:
                raise ValueError(f'Line {records[0].index + 1}: unmatched END {ending}')
            stack.pop()
        branch = first in ('else', 'elseif', 'case')
        depth = len(stack) - int(branch)
        if depth < 0:
            raise ValueError(f'Line {records[0].index + 1}: unmatched branch')
        literal_continuation = any(r.continued_string for r in records)
        previous = ''
        token_offset = 0
        condition = conditional_end(tokens)
        assignment = assignment_equal(tokens)
        drop_plus = assignment + 1 if assignment is not None and tokens[assignment + 1:assignment + 2] == ['+'] else None
        is_format = first == 'format'
        for offset, record in enumerate(records):
            if is_format:
                continue
            code = record.code.lstrip()
            current_label = label if offset == 0 else None
            if current_label:
                code = re.sub(r'^\d+\s+', '', code)
            prefix_amp = offset > 0 and code.startswith('&')
            if prefix_amp:
                code = code[1:]
            trailing = code.rstrip().endswith('&')
            if trailing:
                code = code.rstrip()[:-1]
            if not literal_continuation:
                token_count = len(list(TOKEN.finditer(code)))
                code, previous = spacing(code, previous, drop_plus=drop_plus - token_offset if drop_plus is not None else None,
                                         condition_close=condition - token_offset if condition is not None else None)
                token_offset += token_count
            else:
                # Leading blanks after & can be literal data on these lines.
                code = code if record.continued_string and offset else code.lstrip()
            indentation = 3*(depth + int(offset > 0))
            prefix = current_label + ' '*max(1, indentation - len(current_label)) if current_label else ' '*indentation
            if prefix_amp:
                prefix += '&' + ('' if literal_continuation else ' ')
            suffix = '&' if literal_continuation and trailing else ' &' if trailing else ''
            tail = (re.search(r'\s*$', record.code)[0] + record.comment) if record.comment else ''
            if literal_continuation:
                rendered = prefix + code + suffix
                if len(rendered.rstrip()) > 132:
                    raise ValueError(f'Line {record.index + 1}: continued literal exceeds 132 columns')
                result[record.index] = rendered + tail + record.newline
            else:
                result[record.index] = wrap_line(prefix, code, suffix, tail, record.newline, 3*(depth + 1))
        close = conditional_end(tokens)
        if first == 'do' and (len(control) == 1 or control[1].isdigit() or
                              controls[1] in ('while', 'concurrent') or control[2:3] == ['=']):
            target = str(int(control[1])) if len(control) > 1 and control[1].isdigit() else None
            stack.append(('do', target))
        elif first == 'if' and close is not None and lowered[close + 1:] == ['then']:
            stack.append(('if', None))
        elif first == 'select':
            stack.append(('select', None))
        elif first == 'interface' or lowered[:2] == ['abstract', 'interface']:
            stack.append(('interface', None))
        elif prototype:
            stack.append(('prototype', None))
        if label_key:
            while stack and stack[-1] == ('do', label_key):
                stack.pop()
            if any(kind == 'do' and target == label_key for kind, target in stack):
                raise ValueError(f'Line {records[0].index + 1}: crossing labelled DO range')
        if compact.startswith(('endfunction', 'endsubroutine')) and stack and not prototype_end:
            raise ValueError(f'Line {records[0].index + 1}: unclosed block at procedure end')
    if stack:
        raise ValueError('Unclosed block at end of input')
    formatted = ''.join(result)
    if semantic_statements(text) != semantic_statements(formatted):
        raise ValueError('Formatting changed Fortran tokens or literal values')
    return formatted


def semantic_statements(text):
    """Audit tokens, permitting only redundant unary + after an equals sign.

    Literal tokens remain exact; whitespace, continuation markers and physical
    line boundaries are excluded. Labels remain part of each logical statement.
    """
    result = []
    lines = re.findall(r'[^\r\n]*(?:\r\n|\r|\n|$)', text)
    for records, logical in groups(lines):
        label = re.match(r'^\s*(\d+)\s+', records[0].code)
        values = [m[0] for m in TOKEN.finditer(logical)]
        result.append((label[1] if label else None,
                       tuple(v for i, v in enumerate(values) if not (v == '+' and i and values[i - 1] == '='))))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    converted = format_source(args.source.read_bytes().decode('latin-1'))
    with args.output.open('xb') as out:
        out.write(converted.encode('latin-1'))


if __name__ == '__main__':
    main()
