"""Modernize comparisons, tighten parentheses and simplify constructor types.

Only homogeneous default-kind numeric/logical literal constructors qualify.
Expressions, explicit kinds, complex/character values and mixed types retain
their type specifiers. Comments, strings and FORMAT statements are preserved.
"""
import argparse
from pathlib import Path
import re
import subprocess
import tempfile

from format_free_form import TOKEN, groups, wrap_line
from fortran_procedures import HEADER

COMPARISONS = {'.eq.': '==', '.ne.': '/=', '.lt.': '<',
               '.le.': '<=', '.gt.': '>', '.ge.': '>='}


def comparison_style(text):
    lines = text.splitlines(True)
    for records, logical in groups(lines):
        if any(r.continued_string for r in records) or re.match(r'^\s*format\b', logical, re.I):
            continue
        for record in records:
            matches = list(TOKEN.finditer(record.code))
            if not matches:
                continue
            gaps = [record.code[:matches[0].start()]]
            gaps.extend(record.code[a.end():b.start()] for a, b in zip(matches, matches[1:]))
            gaps.append(record.code[matches[-1].end():])
            values = [m[0] for m in matches]
            for i, value in enumerate(values):
                operator = COMPARISONS.get(value.lower(), value)
                if operator in COMPARISONS.values():
                    values[i] = operator
                    if i:
                        gaps[i] = ' '
                    if i + 1 < len(values):
                        gaps[i + 1] = ' '
            code = ''.join(gap + value for gap, value in zip(gaps, values)) + gaps[-1]
            if len(code.rstrip()) > 132:
                prefix = re.match(r'^\s*', code)[0]
                suffix = (' ' + record.comment) if record.comment else ''
                lines[record.index] = wrap_line(prefix, code[len(prefix):].rstrip(), suffix, '', record.newline, 3)
            else:
                lines[record.index] = code + record.comment + record.newline
    return ''.join(lines)


def literal_type(tokens):
    value = ''.join(tokens).lower()
    if re.fullmatch(r'[+-]?\d+', value):
        return 'integer'
    if re.fullmatch(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)d[+-]?\d+', value):
        return 'double precision'
    if re.fullmatch(r'[+-]?(?:\d+\.\d*|\.\d+)(?:e[+-]?\d+)?|[+-]?\d+e[+-]?\d+', value):
        return 'real'
    if value in ('.true.', '.false.'):
        return 'logical'
    return None


def transform(text):
    lines = text.splitlines(True)
    names = {m[1].lower() for line in lines if (m := HEADER.match(line))}
    edits = {}

    def remove(record, start, end):
        edits.setdefault(record.index, []).append((start, end))

    for records, logical in groups(lines):
        if any(r.continued_string for r in records):
            continue
        tokens = [(r, m) for r in records for m in TOKEN.finditer(r.code) if m[0] != '&']
        words = [m[0].lower() for _, m in tokens]
        if words[:1] == ['format'] or (len(words) > 1 and words[0].isdigit() and words[1] == 'format'):
            continue
        for i, ((record, token), (following_record, following)) in enumerate(zip(tokens, tokens[1:])):
            if following[0] != '(' or following_record.index != record.index:
                continue
            if token[0].lower() in names or (i and words[i - 1] in ('function', 'subroutine', 'call')):
                remove(record, token.end(), following.start())
        for opening, word in enumerate(words):
            if word != '[':
                continue
            closing = opening + 1
            while closing < len(words) and words[closing] not in (']', '['):
                closing += 1
            if closing == len(words) or words[closing] != ']':
                continue
            prefix = opening + 1
            separator = prefix + (2 if words[prefix:prefix + 2] == ['double', 'precision'] else 1)
            typ = ' '.join(words[prefix:separator])
            if typ not in ('integer', 'real', 'double precision', 'logical') or words[separator:separator + 2] != [':', ':']:
                continue
            values, current = [], []
            for value in words[separator + 2:closing] + [',']:
                if value == ',':
                    values.append(current)
                    current = []
                else:
                    current.append(value)
            if not values or any(literal_type(v) != typ for v in values):
                continue
            for record, token in tokens[prefix:separator + 2]:
                end = token.end()
                while end < len(record.code) and record.code[end] in ' \t':
                    end += 1
                remove(record, token.start(), end)
    for index, spans in edits.items():
        line = lines[index]
        for start, end in sorted(spans, reverse=True):
            line = line[:start] + line[end:]
        lines[index] = line
    return comparison_style(''.join(lines))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--compiler', help='Compare complete GNU compiler dumps before writing')
    args = parser.parse_args()
    text = args.source.read_text(encoding='ascii')
    result = transform(text)
    if args.compiler:
        with tempfile.TemporaryDirectory(prefix='nswc-style-check-') as work:
            source = Path(work) / 'input.f90'
            dumps = []
            for value in (text, result):
                source.write_text(value, encoding='ascii', newline='\n')
                compiled = subprocess.run([args.compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                                           '-fsyntax-only', '-fdump-fortran-original', str(source)],
                                          cwd=work, capture_output=True, text=True, timeout=180)
                if compiled.returncode:
                    raise RuntimeError(compiled.stderr)
                dumps.append((compiled.stdout, compiled.stderr))
            if dumps[0] != dumps[1]:
                raise ValueError('Style simplification changed compiler records or diagnostics')
        print('Complete GNU compiler dumps and diagnostics are unchanged.')
    args.output.write_text(result, encoding='ascii', newline='\n')


if __name__ == '__main__':
    main()
