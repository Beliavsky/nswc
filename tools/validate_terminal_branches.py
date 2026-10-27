"""Reproduce terminal-branch cleanup and compare the changed routines numerically."""
import json
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import units
from goto_to_exit import transform as exits
from normalize_fixed_spacing import transform as spacing
from remove_unused_labels import transform as labels
from source_comment_fixes import transform_fixed as comments
from structure_terminal_branches import transform, MANIFEST
from validate_unused_labels import baseline
from validate_explicit_typing import symbols

ROOT = Path(__file__).resolve().parents[1]
DRIVER = '''program check_branches
use, intrinsic :: ieee_arithmetic
implicit none
real, external :: cbrt_old, cbrt_new
real(8), external :: dcbrt_old, dcbrt_new
complex, external :: cflect_old, cflect_new
real :: x, a, b
real(8) :: d, da, db
complex :: z, za, zb
integer :: i, j
logical :: exact_zero
character :: arg
call get_command_argument(1,arg)
exact_zero = arg == '0'
do i = -300,300
   d = scale(1.23456789012345d0,i)
   do j = -1,1,2
      call check_d(d*j)
   end do
end do
do i = -120,120
   x = scale(1.234567,i)
   do j = -1,1,2
      call check_r(x*j)
   end do
end do
call check_r(0.0)
call check_r(-0.0)
call check_d(0.d0)
call check_d(-0.d0)
call check_r(ieee_value(0.0,ieee_positive_inf))
call check_r(ieee_value(0.0,ieee_negative_inf))
call check_r(ieee_value(0.0,ieee_quiet_nan))
call check_d(ieee_value(0.d0,ieee_positive_inf))
call check_d(ieee_value(0.d0,ieee_negative_inf))
call check_d(ieee_value(0.d0,ieee_quiet_nan))
do i = -20,20
   do j = -20,20
      z = cmplx(real(i),real(j))
      za = cflect_old(z)
      zb = cflect_new(z)
      if (any(transfer(za,[0,0]) /= transfer(zb,[0,0]))) stop 3
   end do
end do
print *, 'terminal branches: PASS'
contains
subroutine check_r(v)
real, intent(in) :: v
a = cbrt_old(v)
b = cbrt_new(v)
if (ieee_is_nan(a) .neqv. ieee_is_nan(b)) stop 4
if (ieee_is_nan(a)) return
if (a /= b) stop 5
if (exact_zero .and. transfer(a,0) /= transfer(b,0)) stop 6
end subroutine
subroutine check_d(v)
real(8), intent(in) :: v
da = dcbrt_old(v)
db = dcbrt_new(v)
if (ieee_is_nan(da) .neqv. ieee_is_nan(db)) stop 7
if (ieee_is_nan(da)) return
if (da /= db) stop 8
if (exact_zero .and. transfer(da,0_8) /= transfer(db,0_8)) stop 9
end subroutine
end program
'''


def verify(before, after, report):
    if transform(before) != after or transform(after) != after:
        raise ValueError('Transformation is not exact and idempotent')
    names = [r['procedure'] for r in report['converted']]
    sources = []
    for data in (before, after):
        lines, scopes = units(data)
        sources.append(''.join(''.join(lines[scopes[n][0]:scopes[n][2]]) for n in names))
    with tempfile.TemporaryDirectory(prefix='nswc-terminal-branches-') as work:
        folder = Path(work)
        inventories = []
        for source in sources:
            path = folder/'input.f'
            path.write_text(source)
            r = subprocess.run(['gfortran','-std=f2023','-pedantic-errors','-fsyntax-only',
                                '-fdump-fortran-original',str(path)],capture_output=True,text=True)
            if r.returncode:
                raise RuntimeError(r.stderr)
            inventories.append(symbols(r.stdout,True))
        if inventories[0] != inventories[1]:
            raise ValueError('Existing compiler symbol records changed')
        for suffix, source in zip(('old','new'),sources):
            for name in names:
                source = re.sub(r'\b'+name+r'\b',name+'_'+suffix,source,flags=re.I)
            (folder/f'{suffix}.f').write_text(source)
        (folder/'driver.f90').write_text(DRIVER)
        for optimization in ('0','2'):
            exe = folder/'check.exe'
            r = subprocess.run(['gfortran','-std=f2023','-pedantic-errors','-O'+optimization,
                                str(folder/'old.f'),str(folder/'new.f'),str(folder/'driver.f90'),
                                '-o',str(exe)],capture_output=True,text=True)
            if r.returncode:
                raise RuntimeError(r.stderr)
            r = subprocess.run([str(exe),optimization],capture_output=True,text=True)
            if r.returncode or 'PASS' not in r.stdout:
                raise RuntimeError(r.stdout+r.stderr)
            print(f'-O{optimization}: '+r.stdout.strip())


def main():
    before = spacing(exits(comments(labels(baseline()))))
    report = {}
    after = transform(before,report)
    from fixed_generic_intrinsics import transform as generics
    if generics(after) != (ROOT/'nswc.f').read_bytes():
        raise ValueError('Fixed source does not reproduce terminal-branch cleanup')
    if report != json.loads(MANIFEST.read_text()):
        raise ValueError('Terminal-branch review is stale')
    verify(before,after,report)
    print('Reproduced:', ', '.join(r['procedure'] for r in report['converted']))

if __name__ == '__main__':
    main()
