"""Compiler binding, precision, namespace and callback guards for generics."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from generic_intrinsics import MAPPING, compile_dump, review, symbols, transform, verify
from modernize_remaining_features import strict_standard


@unittest.skipUnless(shutil.which('gfortran'), 'GNU compiler required')
class GenericIntrinsicTests(unittest.TestCase):
    def test_gnu_error_function_aliases_keep_intrinsic_binding(self):
        source = '''pure elemental double precision function f(x)
implicit none
double precision, intent(in) :: x
double precision :: derf,derfc
f = derf(x) + derfc(x)
end function f
real function erf(x)
implicit none
real, intent(in) :: x
erf = x
end function erf
real function erfc(x)
implicit none
real, intent(in) :: x
erfc = x
end function erfc
'''
        result, manifest = self.checked(source)
        self.assertIn('intrinsic :: erf, erfc', result)
        self.assertEqual(manifest['procedures']['F']['calls'], {'derf': 1, 'derfc': 1})
        self.assertIn('f = erf(x) + erfc(x)', result)
        self.assertIn('real function erf(x)', result)
        with tempfile.TemporaryDirectory() as work:
            path = Path(work) / 'input.f90'
            path.write_text(result)
            check = subprocess.run(['gfortran', strict_standard(), '-pedantic-errors',
                                    '-fsyntax-only', str(path)], cwd=work,
                                   capture_output=True, text=True, timeout=30)
            self.assertEqual(check.returncode, 0, check.stderr)

    def checked(self, source):
        with tempfile.TemporaryDirectory() as work:
            before = compile_dump(source, work)
            manifest = review(source, symbols(before[0], True))
            result = transform(source, manifest)
            verify(before, compile_dump(result, work), manifest)
        return result, manifest

    def test_every_mapping_preserves_compiled_code(self):
        source = '''subroutine math(x,y,dx,dy,z,i,j,r)
implicit none
real, intent(in) :: x,y
double precision, intent(in) :: dx,dy
complex, intent(in) :: z
integer, intent(in) :: i,j
double precision, intent(out) :: r
r = 0d0
'''
        two = {'amax1', 'amin1', 'datan2', 'dmax1', 'dmin1', 'dsign', 'isign', 'max0', 'min0'}
        integer = {'iabs', 'isign', 'max0', 'min0'}
        for alias in MAPPING:
            args = ['i', 'j'] if alias in integer else ['dx', 'dy'] if alias.startswith('d') else ['z'] if alias.startswith('c') else ['x', 'y']
            source += 'r = r + real(' + alias + '(' + ','.join(args[:2 if alias in two else 1]) + '),kind=kind(r))\n'
        source += "print *, 'dabs(dx)', r ! dsqrt(dx)\nend subroutine math\n"
        result, manifest = self.checked(source)
        self.assertEqual(set(manifest['procedures']['MATH']['calls']), set(MAPPING))
        self.assertIn("'dabs(dx)'", result)
        self.assertIn('! dsqrt(dx)', result)
        with self.assertRaisesRegex(ValueError, 'code changed'):
            transform(source.replace('r = 0d0', 'r = 1d0'), manifest)

    def test_local_names_callbacks_and_external_procedures_are_retained(self):
        source = '''subroutine collision(x,y,r)
implicit none
real, intent(in) :: x,y
real, intent(out) :: r
real :: max
max = 1.
r = amax1(x,y) + max
end subroutine collision
subroutine callback(x,r)
implicit none
double precision, intent(in) :: x
double precision, intent(out) :: r
intrinsic :: dabs
call worker(dabs,x,r)
r = r + dabs(x)
end subroutine callback
double precision function user_call(x)
implicit none
double precision, intent(in) :: x
double precision, external :: dsqrt
user_call = dsqrt(x)
end function user_call
'''
        result, manifest = self.checked(source)
        self.assertEqual(result, source)
        self.assertIn('amax1', manifest['retained']['COLLISION'])
        self.assertIn('dabs', manifest['retained']['CALLBACK'])
        self.assertNotIn('USER_CALL', manifest['procedures'])

    def test_intrinsic_declarations_and_library_name_collisions(self):
        source = '''double precision function f(x)
implicit none
double precision, intent(in) :: x
double precision :: dabs
intrinsic :: dabs, dsqrt
f = dabs(x) + dsqrt(x)
end function f
real function sqrt(x)
implicit none
real, intent(in) :: x
sqrt = x
end function sqrt
'''
        result, manifest = self.checked(source)
        self.assertIn('f = abs(x) + dsqrt(x)', result)
        self.assertIn('intrinsic :: abs, dsqrt', result)
        self.assertNotIn('double precision :: dabs', result)
        self.assertIn('dsqrt', manifest['retained']['F'])
