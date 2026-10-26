"""Style simplification must preserve kinds, comments and compiler semantics."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from simplify_free_style import transform


SOURCE = '''pure integer function foo (i)
implicit none
integer, intent(in) :: i
integer, parameter :: a(2) = [integer :: 1, -2]
real, parameter :: b(2) = [real :: .1, 2e0]
double precision, parameter :: c(2) = [double precision :: .1d0, 2d0]
double precision, parameter :: mixed(2) = [double precision :: .1, 2d0]
double precision, parameter :: rounded(2) = [double precision :: .1, 2.]
logical, parameter :: flags(2) = [logical :: .true., .false.]
foo = a(i) + int(b(i) + c(i) + mixed(i) + rounded(i))
end function foo
'''


class SimplifyStyleTests(unittest.TestCase):
    def test_only_matching_default_literal_types_are_removed(self):
        result = transform(SOURCE)
        self.assertIn('function foo(i)', result)
        self.assertIn('a(2) = [1, -2]', result)
        self.assertIn('b(2) = [.1, 2e0]', result)
        self.assertIn('c(2) = [.1d0, 2d0]', result)
        self.assertIn('[.true., .false.]', result)
        self.assertIn('[double precision :: .1, 2d0]', result)
        self.assertIn('[double precision :: .1, 2.]', result)
        self.assertEqual(transform(result), result)

    def test_comments_strings_kinds_expressions_and_continuations(self):
        source = '''subroutine bar (x)
integer :: x
call baz (x) ! baz (x), [integer :: 1, 2]
print *, 'bar (x) [integer :: 1, 2]'
x = foo (x)
end subroutine bar
integer function foo (x)
integer :: x
integer, parameter :: a(2) = [integer :: &
   & 1, 2]
integer, parameter :: b(2) = [integer :: 1_4, 2_4]
integer, parameter :: c(2) = [integer :: 1 + 2, 3]
character(2), parameter :: d(2) = [character(2) :: 'a', 'bb']
foo = x
end function foo
'''
        result = transform(source)
        self.assertIn('call baz(x) ! baz (x), [integer :: 1, 2]', result)
        self.assertIn("'bar (x) [integer :: 1, 2]'", result)
        self.assertIn('x = foo(x)', result)
        self.assertIn('[&\n   & 1, 2]', result)
        self.assertIn('[integer :: 1_4, 2_4]', result)
        self.assertIn('[integer :: 1 + 2, 3]', result)
        self.assertIn("[character(2) :: 'a', 'bb']", result)

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU compiler required')
    def test_complete_compiler_dumps_match(self):
        with tempfile.TemporaryDirectory() as work:
            path = Path(work) / 'input.f90'
            dumps = []
            for source in (SOURCE, transform(SOURCE)):
                path.write_text(source)
                result = subprocess.run(['gfortran', '-std=f2008', '-pedantic-errors',
                                         '-fsyntax-only', '-fdump-fortran-original', str(path)],
                                        cwd=work, capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stderr)
                dumps.append(result.stdout)
            self.assertEqual(*dumps)
