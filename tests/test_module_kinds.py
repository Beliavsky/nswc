"""Named module kinds must retain types, scopes, literals and callback contracts."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from module_kinds import transform, DEFINITION


class ModuleKindTests(unittest.TestCase):
    source = '''module m
implicit none
private
public :: s, d, c
contains
real function s(x)
real, intent(in) :: x
real :: dp
dp = real(x) + 1.0 ! real and double precision stay in comments
s = dp
end function s
double precision function d(f,x)
interface
double precision function f(x)
implicit none
double precision, intent(in) :: x
end function f
end interface
double precision, intent(in) :: x
d = f(x) + 1.0d0
end function d
complex function c(z)
complex, intent(in) :: z
c = cmplx(real(z),aimag(z))
end function c
end module m
'''

    def test_types_callbacks_and_literals(self):
        revised = transform(self.source)
        self.assertIn(DEFINITION, revised)
        self.assertIn('real(nswc_sp) function s', revised)
        self.assertIn('real(nswc_sp) :: dp', revised)
        self.assertIn('real(nswc_dp) function d', revised)
        self.assertIn('complex(nswc_sp) function c', revised)
        self.assertIn('import :: nswc_dp\nimplicit none', revised)
        self.assertIn('dp = real(x) + 1.0 ! real and double precision stay in comments', revised)
        self.assertIn('d = f(x) + 1.0d0', revised)
        self.assertEqual(transform(revised), revised)

    def test_explicit_kinds_constructors_and_wrapping(self):
        source = self.source.replace('real :: dp', 'complex(kind=kind(0d0)) :: dc\nreal :: dp')
        source = source.replace('s = dp', 's = sum([real :: dp, 1.0])')
        source = source.replace('\nreal :: dp', '\nreal :: dp, ' + ', '.join('variable_'+str(i) for i in range(12)))
        revised = transform(source)
        self.assertIn('complex(nswc_dp) :: dc', revised)
        self.assertIn('[real(nswc_sp) :: dp, 1.0]', revised)
        self.assertTrue(all(len(line) <= 132 for line in revised.splitlines()))
        self.assertEqual(transform(revised), revised)

    def test_collisions_and_import_none_are_rejected(self):
        with self.assertRaisesRegex(ValueError, 'Reserved'):
            transform(self.source.replace('real :: dp', 'real :: nswc_sp'))
        with self.assertRaisesRegex(ValueError, 'IMPORT NONE'):
            transform(self.source.replace('function f(x)\n', 'function f(x)\nimport, none\n'))

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_compiler_and_precision_flags(self):
        driver = '''program test
use m, only: s,d,c
implicit none
double precision, external :: cb
print *, s(2.0), d(cb,3.0d0), c((2.0,3.0))
end program test
double precision function cb(x)
double precision, intent(in) :: x
cb = 2.0d0*x
end function cb
'''
        with tempfile.TemporaryDirectory(prefix='nswc-kind-test-') as work:
            work = Path(work)
            for flags in ([], ['-fdefault-real-8'], ['-fdefault-real-8', '-fdefault-double-8']):
                results = []
                for source in (self.source, transform(self.source)):
                    (work/'input.f90').write_text(source+driver)
                    run = subprocess.run(['gfortran', '-std=f2018', '-pedantic-errors', *flags, 'input.f90', '-o', 'test.exe'],cwd=work,capture_output=True,text=True)
                    self.assertEqual(run.returncode,0,run.stderr)
                    run = subprocess.run([str(work/'test.exe')],cwd=work,capture_output=True,text=True)
                    self.assertEqual(run.returncode,0,run.stderr)
                    results.append(run.stdout)
                self.assertEqual(*results)


if __name__ == '__main__':
    unittest.main()
