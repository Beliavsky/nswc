"""Find external definitions or interface bodies, excluding nested interfaces."""
import re

PREFIX = r'(?:(?:PURE|ELEMENTAL|IMPURE|RECURSIVE|MODULE)\s+)*'
HEADER = re.compile(r'^\s*' + PREFIX +
                    r'(?:(?:DOUBLE\s*PRECISION|DOUBLE\s*COMPLEX|REAL|INTEGER|COMPLEX|LOGICAL|CHARACTER)'
                    r'(?:\*\d+|\([^)]*\))?\s+)?' + PREFIX +
                    r'(?:SUBROUTINE|FUNCTION)\s+(\w+)', re.I)


def procedure_spans(text):
    current, nested, abstract = None, 0, 0
    seen = set()
    for i, line in enumerate(text.splitlines(True)):
        if line.lstrip().startswith('!'):
            continue
        opening = re.match(r'^\s*(?:abstract\s+)?interface\b', line, re.I)
        closing = re.match(r'^\s*end\s*interface\b', line, re.I)
        if nested:
            nested += bool(opening) - bool(closing)
            continue
        if current and opening:
            nested = 1
            continue
        if abstract:
            abstract += bool(opening) - bool(closing)
            continue
        if re.match(r'^\s*abstract\s+interface\b', line, re.I):
            abstract = 1
            continue
        match = HEADER.match(line)
        if match:
            if current:
                raise ValueError('Nested or unterminated procedure')
            name = match[1].upper()
            if name in seen:
                raise ValueError(f'Duplicate procedure: {name}')
            seen.add(name)
            current = name, i
        if current and re.match(r'^\s*end\s+(?:subroutine|function)\b', line, re.I):
            yield current[0], current[1], i + 1
            current = None
    if current or nested or abstract:
        raise ValueError('Unterminated procedure or interface')


def procedure_blocks(text):
    lines = text.splitlines(True)
    return {name: ''.join(lines[start:end]) for name, start, end in procedure_spans(text)}
