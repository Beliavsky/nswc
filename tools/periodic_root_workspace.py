"""Apply the reviewed COMPB root-workspace correction to maintained fixed form.

This late stage follows declaration/RETURN cleanup so historical declaration
and type reviews remain independently reproducible. The archive is untouched.
"""
from explicit_typing import units


DECLARATION = '      REAL :: CNV, EPS\n'
ARRAYS = ('      COMPLEX, ALLOCATABLE :: ROOT_COMPLEX(:)\n'
          '      REAL, ALLOCATABLE :: ROOT_REAL(:)\n')
OLD_CALL = '      CALL PPADD (NM+1,IERROR,AN,CN,B(J1),B(J1),B(J2))\n'
NEW_CALL = '''      ALLOCATE(ROOT_COMPLEX(NMP),ROOT_REAL(NMP))
      ROOT_REAL = B(J1:J1+NM)
      CALL PPADD (NMP,IERROR,AN,CN,ROOT_COMPLEX,ROOT_REAL,B(J2))
      IF (IERROR .NE. 0) RETURN
      B(J1:J1+2*NMP-1) = TRANSFER(ROOT_COMPLEX,B(J1),2*NMP)
      IF (NCMPLX .EQ. 0) THEN
         ROOT_REAL(1) = REAL(ROOT_COMPLEX(1))
         B(J1:J1+NM) = ROOT_REAL
      END IF
'''


def transform_fixed(data):
    lines, scopes = units(data)
    start, _, end = scopes['COMPB']
    body = ''.join(lines[start:end])
    if ARRAYS in body and NEW_CALL in body and OLD_CALL not in body:
        return data
    if body.count(DECLARATION) != 1 or body.count(OLD_CALL) != 1:
        raise ValueError('COMPB fixed-form workspace correction needs review')
    if 'ROOT_COMPLEX' in body or 'ROOT_REAL' in body:
        raise ValueError('COMPB workspace names already used')
    body = body.replace(DECLARATION, DECLARATION + ARRAYS)
    body = body.replace(OLD_CALL, NEW_CALL)
    if any(len(line) > 72 for line in body.splitlines()):
        raise ValueError('COMPB correction exceeds fixed-form width')
    return (''.join(lines[:start]) + body + ''.join(lines[end:])).encode('latin-1')
