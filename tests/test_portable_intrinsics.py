"""Keep double-precision intrinsic calls portable without changing literals."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from portable_intrinsics import transform


class PortableIntrinsicTests(unittest.TestCase):
    def test_specific_gamma_calls_use_generic_and_preserve_text(self):
        source = '''pure double precision function drcomp(a)
implicit none
double precision, intent(in) :: a
double precision :: dgamma, local
drcomp = dgamma(a) ! dgamma(a)
print *, 'dgamma(a)'
end function drcomp
'''
        result = transform(source)
        self.assertIn('intrinsic :: gamma\n', result)
        self.assertIn('double precision :: local\n', result)
        self.assertIn('drcomp = gamma(a) ! dgamma(a)', result)
        self.assertIn("print *, 'dgamma(a)'", result)
        self.assertIn('double precision, intent(in) :: a', result)
