"""Interface generation guards, signature checks, and temporary caller rewriting."""
import copy
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from generate_interfaces import assemble, normalize_body, procedure_blocks
from validate_interfaces import compare_signatures, module_caller


class InterfaceTests(unittest.TestCase):
    raw = '''MODULE S__genmod
INTERFACE
SUBROUTINE S(N,X, &
 & Y)
INTEGER(KIND=4), INTENT(IN) :: N
REAL(KIND=8), INTENT(INOUT) :: X(N),Y(*)
END SUBROUTINE S
END INTERFACE
END MODULE
'''

    def test_kind_mapping_implicit_none_and_continued_header(self):
        body = normalize_body(self.raw)
        self.assertIn('& Y)\n      IMPLICIT NONE\n', body)
        self.assertIn('DOUBLE PRECISION, INTENT(INOUT)', body)
        self.assertNotIn('KIND=', body)
        self.assertEqual(set(procedure_blocks(body)), {'S'})

    def test_unreviewed_kind_and_incomplete_sets_fail(self):
        with self.assertRaisesRegex(ValueError, 'kind mapping'):
            normalize_body(self.raw.replace('KIND=8', 'KIND=16'))
        with self.assertRaisesRegex(ValueError, 'procedure set'):
            assemble({'S': self.raw}, {'S', 'T'})
        with self.assertRaisesRegex(ValueError, 'Wrong generated'):
            assemble({'T': self.raw}, {'T'})

    def test_procedure_reader_rejects_duplicates_and_unclosed_definitions(self):
        body = normalize_body(self.raw)
        for source in (body + body, body.replace('END SUBROUTINE S', '')):
            with self.assertRaises(ValueError):
                procedure_blocks(source)

    def test_argument_modes_types_shapes_and_order_are_checked(self):
        source = {'S': {'s': {'type spec': 'type spec : (UNKNOWN 0)',
                             'attributes': 'attributes: (PROCEDURE SUBROUTINE)', 'Formal arglist': 'n x'},
                        'x': {'type spec': 'type spec : (REAL 8)',
                              'attributes': 'attributes: (VARIABLE DIMENSION DUMMY(INOUT))',
                              'Array spec': 'Array spec:(1 [0] AS_ASSUMED_SIZE 1 *)'}}}
        self.assertEqual(compare_signatures(source, source), 2)
        for name, field, value in [('x', 'type spec', 'type spec : (REAL 4)'),
                                   ('x', 'attributes', 'attributes: (VARIABLE DIMENSION DUMMY(IN))'),
                                   ('x', 'Array spec', 'wrong shape'), ('s', 'Formal arglist', 'x n')]:
            changed = copy.deepcopy(source)
            changed['S'][name][field] = value
            with self.assertRaisesRegex(ValueError, 'characteristics differ'):
                compare_signatures(source, changed)

    def test_subroutine_callback_use_inference_is_not_an_interface_change(self):
        source = {'S': {'f': {'type spec': 'type spec : (UNKNOWN 0)',
                              'attributes': 'attributes: (PROCEDURE DUMMY-PROC DUMMY SUBROUTINE)'}}}
        interface = {'S': {'f': {'type spec': 'type spec : (UNKNOWN 0)',
                                 'attributes': 'attributes: (PROCEDURE EXTERNAL DUMMY)'}}}
        self.assertEqual(compare_signatures(source, interface), 1)

    def test_caller_keeps_abstract_interfaces_and_external_callbacks(self):
        text = '''program p
implicit none
abstract interface
subroutine callback(x)
real :: x
end subroutine
end interface
interface
subroutine s(n,x)
integer :: n
real :: x(n)
end subroutine
end interface
double precision, external :: dgamma, local_function
external s
print *, 'external s'
end program
'''
        rewritten = module_caller(text, {'S', 'DGAMMA'})
        self.assertIn('use nswc_interfaces, only:', rewritten)
        self.assertIn('DGAMMA, S', rewritten)
        self.assertIn('abstract interface\nsubroutine callback(x)', rewritten)
        self.assertIn('double precision, external :: local_function', rewritten)
        self.assertNotIn('subroutine s(', rewritten)
        self.assertIn("print *, 'external s'", rewritten)

    def test_nested_callback_interfaces_are_removed_with_the_library_interface(self):
        text = '''program p
interface
subroutine q(f)
interface
real function f(x)
real :: x
end function
end interface
end subroutine
end interface
end program
'''
        rewritten = module_caller(text, {'Q'})
        self.assertIn('    Q\n', rewritten)
        self.assertNotIn('interface\n', rewritten)
        with self.assertRaisesRegex(ValueError, 'not a library'):
            module_caller(text, {'OTHER'})


if __name__ == '__main__':
    unittest.main()
