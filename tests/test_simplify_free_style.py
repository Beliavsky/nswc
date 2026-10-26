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
if (i.eq.1) foo = foo + 1
if (i .ne. 2 .and. i.lt.3) foo = foo + 2
if (i.le.4 .or. i.gt.5 .or. i.ge.6) foo = foo + 3
end function foo
'''


class SimplifyStyleTests(unittest.TestCase):
    def test_comparisons_preserve_logical_operators_and_quoted_text(self):
        source = """subroutine s(x,y)
real :: x,y
if (x .eq.y) go to 90 ! x.eq.y
if (x/=y .and. .not.(x.lt.y)) x = y
if (.true. .eqv. .false. .or. .true. .neqv. .false.) x = y
if (x &
   & .GE.y) x = y
print *, 'x.eq.y', "x<=y"
90 format('x.eq.y')
end subroutine s
"""
        result = transform(source)
        self.assertIn('if (x == y) go to 90 ! x.eq.y', result)
        self.assertIn('if (x /= y .and. .not.(x < y))', result)
        self.assertIn('.true. .eqv. .false. .or. .true. .neqv. .false.', result)
        self.assertIn('& >= y)', result)
        self.assertIn("'x.eq.y', \"x<=y\"", result)
        self.assertIn("90 format('x.eq.y')", result)
        self.assertEqual(transform(result), result)

    def test_comparison_spacing_wraps_long_lines(self):
        source = 'if (' + 'a'*61 + '==' + 'b'*61 + ') x=1\n'
        result = transform(source)
        self.assertTrue(all(len(line) <= 132 for line in result.splitlines()))
        self.assertIn(' &\n', result)
        self.assertEqual(transform(result), result)

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
