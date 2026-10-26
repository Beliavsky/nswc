"""Apply the reviewed BLKTR1 empty-factor correction to maintained fixed form.

This runs after historical control-flow passes. COMPB and the periodic-root
workspace anchor in BLKTR1 retain their original INDXB results.
"""
import re


def transform_fixed(data, undo=False):
    text = data.decode('ascii')
    scope = re.search(r'^      SUBROUTINE BLKTR1\b.*?^      END SUBROUTINE BLKTR1\n', text, re.M | re.S)
    if scope is None:
        raise ValueError('BLKTR1 fixed-form scope needs review')
    body = scope[0]
    calls = list(re.finditer(r'^( +)CALL INDXB\s*\([^\n]*?,(\w+),(\w+)\)\n', body, re.M))
    anchors = [m for m in calls if re.sub(r'\s+', '', m[0]) == 'CALLINDXB(IF,K-1,IP,NP)']
    if len(calls) != 27 or len(anchors) != 1:
        raise ValueError('BLKTR1 fixed-form lookup inventory needs review')
    if body[anchors[0].end():].startswith(f'{anchors[0][1]}IF (NP .EQ. 0) IP = 1\n'):
        raise ValueError('BLKTR1 periodic-root anchor needs review')
    guards = [(m, f'{m[1]}IF ({m[3]} .EQ. 0) {m[2]} = 1\n') for m in calls if m not in anchors]
    present = [body[m.end():].startswith(guard) for m, guard in guards]
    if any(present) and not all(present):
        raise ValueError('BLKTR1 partial fixed-form correction needs review')
    if all(present) == (not undo):
        return data
    for match, guard in reversed(guards):
        body = body[:match.end()] + (body[match.end() + len(guard):] if undo else guard + body[match.end():])
    if any(len(line) > 72 for line in body.splitlines()):
        raise ValueError('BLKTR1 correction exceeds fixed-form width')
    return (text[:scope.start()] + body + text[scope.end():]).encode('ascii')
