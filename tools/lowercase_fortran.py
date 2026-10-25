"""Lowercase free-form Fortran code, preserving strings, comments and layout.

This is a lexical filter, not a formatter or a fixed-form converter. It handles
doubled quotes and continued character literals, including intervening comment
lines. Preprocessor directives and unquoted Hollerith constants require separate
review and are rejected before any output file is written.
"""
import argparse
from pathlib import Path
import re
import sys


def lowercase(text):
    result, quote = [], ''
    # Only CR/LF end physical source lines; other bytes in comments are data.
    for number, raw in enumerate(re.findall(r'[^\r\n]*(?:\r\n|\r|\n|$)', text), 1):
        if not raw:
            continue
        body = raw.rstrip('\r\n')
        newline = raw[len(body):]
        if not body.strip() or body.lstrip().startswith('!'):
            result.append(raw)
            continue
        if body.lstrip().startswith('#'):
            raise ValueError(f'Line {number}: preprocessor directives require review')
        if quote and not body.lstrip().startswith('&'):
            raise ValueError(f'Line {number}: continued character literal requires leading &')
        output, i = [], 0
        while i < len(body):
            c = body[i]
            if quote:
                output.append(c)
                if c == quote:
                    if i + 1 < len(body) and body[i + 1] == quote:
                        output.append(body[i + 1])
                        i += 1
                    else:
                        quote = ''
            elif c in "'\"":
                quote = c
                output.append(c)
            elif c == '!':
                output.append(body[i:])
                break
            else:
                if c.isdigit() and (i == 0 or not (body[i - 1].isalnum() or body[i - 1] == '_')):
                    if re.match(r'\d+[hH]', body[i:]):
                        raise ValueError(f'Line {number}: Hollerith constants require review')
                output.append(chr(ord(c) + 32) if 'A' <= c <= 'Z' else c)
            i += 1
        if quote and not body.rstrip().endswith('&'):
            raise ValueError(f'Line {number}: unterminated character literal')
        result.append(''.join(output) + newline)
    if quote:
        raise ValueError('Unterminated continued character literal at end of file')
    return ''.join(result)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', required=True, type=Path, help='Write a new file')
    args = parser.parse_args(argv)
    try:
        # Latin-1 preserves arbitrary comment bytes and line endings exactly.
        text = args.source.read_bytes().decode('latin-1')
        converted = lowercase(text).encode('latin-1')
        with args.output.open('xb') as output:
            output.write(converted)
        print(f'Wrote {args.output}')
        return 0
    except (OSError, ValueError) as error:
        print('error: ' + str(error), file=sys.stderr)
        return 2


if __name__ == '__main__':
    raise SystemExit(main())
