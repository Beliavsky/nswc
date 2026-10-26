"""Apply reviewed COMPB and BLKTR1 corrections after purity annotation.

COMPB supplies disjoint complex-root and real-root work arrays to PPADD. On
success, TRANSFER restores the packed representation expected by BLKTR1.
For all-real roots, PPADD compacts entries 2:n; entry 1 historically came from
the overlapping first complex root, so it must now be copied explicitly.
On an error return, partial root workspace is not used by BLKTRI.
BLKTR1 substitutes index 1 for empty factors before forming product arguments.
INDXB's workspace anchors remain unchanged for COMPB.
"""
import re
from fortran_procedures import procedure_spans


def correct_root_workspace(text):
    lines = text.splitlines(True)
    start, end = next((s, e) for n, s, e in procedure_spans(text) if n == 'COMPB')
    body = ''.join(lines[start:end])
    declaration = 'real :: cnv, eps\n'
    call = 'call ppadd (nm + 1,ierror,an,cn,b(j1),b(j1),b(j2))\n'
    # Maintained fixed form now includes the same correction. Accept only the
    # reviewed block (with original or normalized parentheses spacing), and
    # normalize its comparisons to the historical free-form spelling.
    from periodic_root_workspace import NEW_CALL
    from fixed_to_free import convert_text
    from lowercase_fortran import lowercase
    from format_free_form import format_source
    from normalize_fixed_spacing import transform as normalize_spacing
    blocks = {format_source(lowercase(convert_text(source))) for source in
              (NEW_CALL, normalize_spacing(NEW_CALL.encode('ascii')).decode('ascii'))}
    if body.count('complex, allocatable :: root_complex(:)\n') == 1:
        present = [block for block in blocks if body.count(block) == 1]
        if (body.count('real, allocatable :: root_real(:)\n') != 1
                or len(present) != 1 or call in body):
            raise ValueError('COMPB corrected workspace block needs review')
        block = present[0]
        body = body.replace(block, block.replace('.ne.', '/=').replace('.eq.', '=='))
        return ''.join(lines[:start]) + body + ''.join(lines[end:])
    if body.count(declaration) != 1 or body.count(call) != 1:
        raise ValueError('COMPB workspace correction: source needs review')
    body = body.replace(declaration, declaration +
                        'complex, allocatable :: root_complex(:)\n'
                        'real, allocatable :: root_real(:)\n')
    body = body.replace(call, '''allocate(root_complex(nmp),root_real(nmp))
root_real = b(j1:j1 + nm)
call ppadd (nmp,ierror,an,cn,root_complex,root_real,b(j2))
if (ierror /= 0) return
b(j1:j1 + 2*nmp - 1) = transfer(root_complex,b(j1),2*nmp)
if (ncmplx == 0) then
   root_real(1) = real(root_complex(1))
   b(j1:j1 + nm) = root_real
end if
''')
    return ''.join(lines[:start]) + body + ''.join(lines[end:])


def correct_empty_factor_index(text):
    """Use a valid actual argument in BLKTR1 for every zero-length factor."""
    lines = text.splitlines(True)
    start, end = next((s, e) for n, s, e in procedure_spans(text) if n == 'BLKTR1')
    body = ''.join(lines[start:end])
    calls = list(re.finditer(r'^( *)call indxb\s*\([^\n]*?,(\w+),(\w+)\)\n', body, re.M))
    if len(calls) != 27:
        raise ValueError('BLKTR1 empty-factor call inventory needs review')
    # This lookup locates the periodic root workspace: its subsequent product
    # uses NM+1 roots, not the returned NP length. Preserve that anchor.
    anchors = [m for m in calls if re.sub(r'\s+', '', m[0]) == 'callindxb(if,k-1,ip,np)']
    if len(anchors) != 1:
        raise ValueError('BLKTR1 periodic-root anchor needs review')
    if body[anchors[0].end():].startswith(f'{anchors[0][1]}if (np .eq. 0) ip = 1\n'):
        raise ValueError('BLKTR1 periodic-root anchor correction needs review')
    calls = [m for m in calls if m not in anchors]
    expected = [(m, f'{m[1]}if ({m[3]} .eq. 0) {m[2]} = 1\n') for m in calls]
    present = [body[m.end():].startswith(guard) for m, guard in expected]
    if all(present):
        return text
    if any(present):
        raise ValueError('BLKTR1 partial factor-index correction needs review')
    for match, guard in reversed(expected):
        body = body[:match.end()] + guard + body[match.end():]
    return ''.join(lines[:start]) + body + ''.join(lines[end:])


def transform(text):
    return correct_empty_factor_index(correct_root_workspace(text))
