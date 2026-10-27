"""A module must use host procedures without disturbing callbacks or data."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from generate_module import module_source


class ModuleGenerationTests(unittest.TestCase):
    def test_procedure_references_data_and_dummy_callbacks(self):
        source = '''real function leaf(x)
implicit none
real, intent(in) :: x
leaf = x*x
end function leaf
subroutine caller(x)
implicit none
real :: x, leaf, keep
external leaf, user_callback
x = leaf(x)
end subroutine caller
subroutine callback(leaf,x)
implicit none
real :: leaf, x
external leaf
x = leaf(x)
end subroutine callback
subroutine data()
implicit none
real :: leaf(2)
leaf(1) = 1.0
end subroutine data
'''
        result = module_source(source, {'CALLER': ['LEAF'], 'CALLBACK': ['LEAF']}, documentation=False)
        self.assertIn('module nswc_mod\nimplicit none\nprivate\n', result)
        self.assertRegex(result, r'(?m)^public :: [^\n]*\bcaller\b')
        self.assertIn('real(nswc_sp) :: x, keep\nexternal user_callback\n', result)
        self.assertIn('real(nswc_sp) :: leaf, x\nexternal leaf\n', result)
        self.assertIn('real(nswc_sp) :: leaf(2)\n', result)
        self.assertIn('x = leaf(x)\n', result)

    def test_local_library_interface_removed(self):
        source = '''pure real function leaf(x)
implicit none
real,intent(in)::x
leaf=x*x
end function leaf
pure real function caller(x)
implicit none
real,intent(in)::x
interface
pure real function leaf(x)
implicit none
real,intent(in)::x
end function leaf
end interface
caller=leaf(x)
end function caller
'''
        result = module_source(source, {'CALLER': ['LEAF']}, documentation=False)
        self.assertNotIn('interface', result)
        self.assertEqual(result.count('pure real(nswc_sp) function leaf'), 1)

    def test_called_dummy_subroutine_gets_external_declaration(self):
        source = 'subroutine s(f,x)\nimplicit none\nreal :: x\ncall f(x)\nend subroutine s\n'
        result = module_source(source, {})
        self.assertIn('implicit none\nexternal f\nreal(nswc_sp) :: x\n', result)
        duplicated = source.replace('real :: x\n', 'real :: x\nimplicit none\n')
        self.assertEqual(module_source(duplicated, {}).count('external f\n'), 1)

    def test_intrinsic_binding_overrides_module_procedure(self):
        source = '''real function gamma(x)
implicit none
real :: x
gamma = x
end function gamma
subroutine s(x,y)
implicit none
real :: x,y,gamma
y = gamma(x)
end subroutine s
'''
        result = module_source(source, {'S': ['GAMMA']}, {'S': ['gamma']})
        self.assertIn('intrinsic :: gamma\nreal(nswc_sp) :: x,y,gamma\n', result)

    def test_specific_gamma_intrinsic_uses_portable_generic(self):
        source = '''double precision function dgamma(x)
implicit none
double precision :: x
dgamma = x
end function dgamma
subroutine s(x,y)
implicit none
double precision :: x,y,dgamma
y = dgamma(x) ! dgamma(x)
print *, 'dgamma(x)'
print *, '!', dgamma(x) ! dgamma(x)
end subroutine s
'''
        result = module_source(source, {'S': ['DGAMMA']}, {'S': ['dgamma']})
        self.assertIn('intrinsic :: gamma\n', result)
        self.assertIn('real(nswc_dp) :: x, y\n', result)
        self.assertIn('y = gamma(x) ! dgamma(x)\n', result)
        self.assertIn("print *, 'dgamma(x)'", result)
        self.assertIn("print *, '!', gamma(x) ! dgamma(x)", result)
        self.assertIn('dgamma = x\n', result)


if __name__ == '__main__':
    unittest.main()
