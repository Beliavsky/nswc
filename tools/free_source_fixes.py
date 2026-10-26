"""Normalize the reviewed COMPB correction after purity annotation.

COMPB supplies disjoint complex-root and real-root work arrays to PPADD. On
success, TRANSFER restores the packed representation expected by BLKTR1.
For all-real roots, PPADD compacts entries 2:n; entry 1 historically came from
the overlapping first complex root, so it must now be copied explicitly.
On an error return, partial root workspace is not used by BLKTRI.
"""
from fortran_procedures import procedure_spans


def transform(text):
    lines = text.splitlines(True)
    start, end = next((s, e) for n, s, e in procedure_spans(text) if n == 'COMPB')
    body = ''.join(lines[start:end])
    declaration = 'real :: cnv, eps\n'
    call = 'call ppadd (nm + 1,ierror,an,cn,b(j1),b(j1),b(j2))\n'
    # Maintained fixed form now includes the same correction. Accept only the
    # exact reviewed block and normalize its comparisons to the historical
    # free-form spelling, keeping generated sources byte-for-byte unchanged.
    from periodic_root_workspace import NEW_CALL
    from fixed_to_free import convert_text
    from lowercase_fortran import lowercase
    from format_free_form import format_source
    block = format_source(lowercase(convert_text(NEW_CALL)))
    if body.count('complex, allocatable :: root_complex(:)\n') == 1:
        if (body.count('real, allocatable :: root_real(:)\n') != 1
                or body.count(block) != 1 or call in body):
            raise ValueError('COMPB corrected workspace block needs review')
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
