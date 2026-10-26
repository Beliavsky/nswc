"""Reproduce reviewed comment-only corrections in maintained fixed form."""
from explicit_typing import units


def transform_fixed(data):
    lines, scopes = units(data)
    start, _, end = scopes['SHELL']
    body = ''.join(lines[start:end])
    tail = '      I = I - 1\n      END DO\n      END SUBROUTINE SHELL\n'
    old = 'C\n' + tail
    if body.count(old) == 1:
        body = body.replace(old, tail, 1)
    elif body.count(tail) != 1:
        raise ValueError('SHELL empty-comment correction needs review')
    return (''.join(lines[:start]) + body + ''.join(lines[end:])).encode('latin-1')
