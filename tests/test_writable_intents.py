"""Conservative writable arguments, initial definitions, and call-site guards."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from explicit_typing import digest
from writable_intents import assignment, definable_base, infer, initial_scalar_outputs, mask_strings


def record(dummy=False, array=False):
    attrs = "attributes: (VARIABLE" + (" DIMENSION" if array else "") + (" DUMMY" if dummy else "") + ")"
    return {"type spec": "type spec : (REAL 4)", "attributes": attrs}


def source(name, args, body):
    return (f"      SUBROUTINE {name}({','.join(args)})\n      IMPLICIT NONE\n"
            + "".join("      " + line + "\n" for line in body)
            + f"      END SUBROUTINE {name}\n").encode()


class WritableIntentTests(unittest.TestCase):
    def test_scalar_prefix_requires_assignment_before_read_or_branch(self):
        records = {name: record(True) for name in ['status', 'x', 'y']}
        records['a'] = record(True, True)
        body = [(1, 'status=0'), (2, 'x=x+1'), (3, 'if (status.eq.0) return'), (4, 'y=1')]
        outputs = initial_scalar_outputs(body, set(records), records, set())
        self.assertEqual(set(outputs), {'status'})
        self.assertEqual(initial_scalar_outputs([(1, 'x=0')], {'x'}, records, {'x'}), {})
        self.assertEqual(initial_scalar_outputs([(1, 'a(1)=0')], {'a'}, records, set()), {})
        self.assertEqual(initial_scalar_outputs([(1, 'do10i=1,n'), (2, 'x=0')], {'x'}, records, set()), {})

    def test_definability_rejects_expressions_sections_and_vector_subscripts(self):
        records = {'x': record(True), 'a': record(True, True), 'i': record(), 'iv': record(False, True)}
        self.assertEqual(definable_base('a(i+1)', records, 's'), 'a')
        self.assertEqual(definable_base('x', records, 's'), 'x')
        for actual in ['1.0', '(x)', 'x+1', 'a(i)+a(i)', 'a(:)', 'a(iv)']:
            self.assertIsNone(definable_base(actual, records, 's'), actual)

    def test_partial_arrays_and_early_returns_keep_incoming_values(self):
        data = source('S', ['N', 'A', 'STATUS'], ['INTEGER N,STATUS', 'REAL A(N)',
                      'STATUS=0', 'IF(N.LE.0) RETURN', 'A(1)=2'])
        records = {'n': record(True), 'status': record(True), 'a': record(True, True)}
        existing = {'input_sha256': digest(data), 'procedures': {}}
        result = infer(data, {'S': records}, existing)['procedures']['S']['arguments']
        self.assertEqual(result, {'A': 'INOUT', 'STATUS': 'OUT'})
        sized = source('T', ['N', 'A'], ['INTEGER N', 'REAL A(N)', 'N=0'])
        result = infer(sized, {'T': records}, {'input_sha256': digest(sized), 'procedures': {}})
        self.assertEqual(result['procedures']['T']['arguments']['N'], 'INOUT')

    def test_nonvariable_actual_blocks_new_output_contract(self):
        data = source('SET', ['X'], ['REAL X', 'X=0']) + source('USE', ['Y'], ['REAL Y', 'CALL SET(1.0)'])
        inventory = {'SET': {'x': record(True)}, 'USE': {'y': record(True)}}
        result = infer(data, inventory, {'input_sha256': digest(data), 'procedures': {}})
        self.assertNotIn('SET', result['procedures'])
        self.assertIn('SET:X', result['writable_analysis']['nonvariable_actuals'])

    def test_known_calls_propagate_writes_and_observed_aliases_prevent_out(self):
        data = source('SET', ['X', 'A'], ['REAL X,A', 'X=0', 'A=A+1'])
        data += source('USE', ['Y'], ['REAL Y', 'CALL SET(Y,Y)'])
        inventory = {'SET': {'x': record(True), 'a': record(True)}, 'USE': {'y': record(True)}}
        result = infer(data, inventory, {'input_sha256': digest(data), 'procedures': {}})
        self.assertEqual(result['procedures']['SET']['arguments'], {'A': 'INOUT', 'X': 'INOUT'})
        self.assertEqual(result['procedures']['USE']['arguments'], {'Y': 'INOUT'})

    def test_storage_association_is_excluded_and_prior_inputs_are_checked(self):
        data = source('S', ['X'], ['REAL X,Z', 'COMMON /C/ Z', 'X=0'])
        result = infer(data, {'S': {'x': record(True), 'z': record()}}, {'input_sha256': digest(data), 'procedures': {}})
        self.assertEqual(result['procedures'], {})
        from name_procedure_ends import ConversionError
        with self.assertRaises(ConversionError):
            infer(data, {'S': {'x': record(True)}}, {'procedures': {'S': {'arguments': {'X': 'IN'}}}})

    def test_function_calls_in_conditions_propagate_writes(self):
        data = (b'      REAL FUNCTION TOUCH(X)\n      IMPLICIT NONE\n'
                b'      REAL X\n      X=X+1\n      TOUCH=X\n'
                b'      END FUNCTION TOUCH\n')
        data += source('USE', ['Y'], ['REAL Y,TOUCH', 'IF(TOUCH(Y).GT.0) RETURN'])
        inventory = {'TOUCH': {'x': record(True), 'touch': {'attributes': '(PROCEDURE FUNCTION)'}},
                     'USE': {'y': record(True), 'touch': {'attributes': '(PROCEDURE FUNCTION)'}}}
        result = infer(data, inventory, {'input_sha256': digest(data), 'procedures': {}})
        self.assertEqual(result['procedures']['USE']['arguments'], {'Y': 'INOUT'})
        self.assertEqual(result['procedures']['TOUCH']['arguments'], {'X': 'INOUT'})

    def test_assignments_distinguish_keyword_like_variable_names_and_literals(self):
        self.assertEqual(assignment('save=a(i)')[0], 'save')
        self.assertIsNone(assignment('do i=1,n'))
        self.assertEqual(mask_strings("X='it''s (x)'"), 'x=           ')


if __name__ == '__main__':
    unittest.main()
