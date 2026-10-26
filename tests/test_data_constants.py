"""DATA conversion must preserve storage values and retain mutable objects."""
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from data_constants import transform
from review_data_constants import compile_dump, review, verify_values
from validate_data_constants import executable_statements


@unittest.skipUnless(shutil.which('gfortran'), 'GNU compiler required')
class DataConstantTests(unittest.TestCase):
    def convert(self, text):
        with tempfile.TemporaryDirectory() as work:
            folder = Path(work)
            before, _ = compile_dump(text, folder, 'before')
            manifest = review(text, before)
            result = transform(text, manifest)
            after, _ = compile_dump(result, folder, 'after')
            verify_values(before, after, manifest)
        self.assertEqual(executable_statements(text), executable_statements(result))
        return result, manifest

    def test_values_bounds_order_and_default_literal_rounding(self):
        source = '''subroutine constants(x)
implicit none
double precision, intent(out) :: x
double precision :: a(0:1,2), scale
integer :: flag
save a, scale, flag
data a /0.1, 2d0, 2*3.0/, scale, flag /0.123456789, 0/
flag = flag + 1
x = a(1,2)*scale + flag
end subroutine constants
'''
        result, manifest = self.convert(source)
        self.assertEqual(set(manifest['procedures']['CONSTANTS']['constants']), {'a', 'scale'})
        self.assertIn('reshape(', result)
        self.assertIn('save flag', result)
        self.assertIn('data flag /0/', result)
        self.assertNotIn('save a', result)
        with self.assertRaisesRegex(ValueError, 'code changed'):
            transform(source.replace('flag + 1', 'flag + 2'), manifest)

    def test_call_intents_unknown_callbacks_partial_and_aliased_objects(self):
        source = '''subroutine checked(x, callback)
implicit none
real, intent(out) :: x
external callback
real :: safe, writable, unknown, partial(2), coefficient
data safe, writable, unknown, partial(1), coefficient /1.,2.,3.,4.,5./
call consume(safe,x)
call change(writable)
call callback(unknown)
call callback(coefficient*2.)
x = x + partial(1)
end subroutine checked
subroutine consume(a,x)
implicit none
real, intent(in) :: a
real, intent(out) :: x
x = a
end subroutine consume
subroutine change(a)
implicit none
real, intent(inout) :: a
a = a + 1.
end subroutine change
subroutine aliased(x)
implicit none
real, intent(out) :: x
real :: a,b
equivalence(a,b)
data a /1./
b = 2.
x = a
end subroutine aliased
'''
        _, manifest = self.convert(source)
        self.assertEqual(set(manifest['procedures']['CHECKED']['constants']), {'safe', 'coefficient'})
        self.assertNotIn('ALIASED', manifest['procedures'])
