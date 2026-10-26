"""Declaration grouping must preserve scope, attributes and dependencies."""
from pathlib import Path
import shutil
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from coalesce_local_declarations import transform, verify


class CoalesceLocalTests(unittest.TestCase):
    def checked(self, source, **kwargs):
        result = transform(source, **kwargs)
        self.assertEqual(transform(result, **kwargs), result)
        if shutil.which('gfortran'):
            verify(source, result)
        return result

    def test_arguments_arrays_and_intervening_types(self):
        source = '''subroutine s(n,x)
implicit none
integer, intent(in) :: n
real, intent(out) :: x
integer :: i,j
real :: a(n),b
integer :: k
real :: c(n)
i=1
j=2
k=3
a=1.
b=2.
c=3.
x=a(i)+b+c(i)+j+k
end subroutine s
'''
        result = self.checked(source)
        self.assertIn('integer :: i, j, k\n', result)
        self.assertIn('real :: a(n), b, c(n)\n', result)
        self.assertIn('integer, intent(in) :: n\nreal, intent(out) :: x\n', result)

    def test_comments_initializers_attributes_and_dependencies_are_barriers(self):
        source = '''subroutine s(x)
implicit none
real, intent(out) :: x
integer :: seed
real :: a
integer :: array(kind(seed))
integer :: later
! separate section
real :: b ! documented variable
real :: c
integer :: initialized=1
real :: d
real, save :: saved
real :: e
seed=1
array=2
later=3
a=1.
b=2.
c=3.
d=4.
e=5.
saved=6.
x=seed+sum(array)+later+a+b+c+d+e+saved+initialized
end subroutine s
'''
        result = self.checked(source)
        self.assertIn('integer :: seed\n', result)
        self.assertIn('integer :: array(kind(seed))\ninteger :: later\n', result)
        self.assertIn('! separate section\nreal :: b ! documented variable\nreal :: c\n', result)
        self.assertIn('integer :: initialized=1\n', result)
        self.assertIn('real :: d, e\nreal, save :: saved\n', result)

    def test_external_function_and_storage_objects_remain_separate(self):
        source = '''subroutine s(x)
implicit none
real, intent(inout) :: x
real :: fun
real :: a
real :: b
integer :: member
integer :: local
common /block/ member
a=fun(x)
b=a
local=1
x=b+member+local
end subroutine s
'''
        result = self.checked(source)
        self.assertIn('real :: fun\nreal :: a, b\n', result)
        self.assertIn('integer :: member\ninteger :: local\n', result)

    def test_nested_interfaces_and_result_variables_are_protected(self):
        source = '''real function f(x) result(r)
implicit none
real, intent(in) :: x
real :: a
real :: b
interface
real function helper(x)
real, intent(in) :: x
end function helper
end interface
real :: c
real :: d
a=x
b=a
c=b
d=c
r=helper(d)
end function f
'''
        result = self.checked(source)
        self.assertIn('real :: a, b\ninterface\n', result)
        self.assertIn('real, intent(in) :: x\nend function helper\nend interface\n', result)
        self.assertIn('real :: c, d\n', result)

    def test_wrapping_and_crlf(self):
        names = ['variable_number_' + str(i) for i in range(12)]
        source = 'subroutine s()\nimplicit none\n' + ''.join('real :: ' + n + '\n' for n in names) + 'end subroutine s\n'
        result = self.checked(source, max_len=60)
        self.assertTrue(all(len(line) <= 60 for line in result.splitlines()))
        self.assertIn(', &\n   & ', result)
        crlf = transform(source.replace('\n', '\r\n'), max_len=60)
        self.assertEqual(crlf.replace('\r\n', '\n'), result)
