"""Purity contracts require explicit local interfaces and compiler review."""
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from procedure_purity import transform, code_hash
from fortran_procedures import procedure_blocks
from interface_variants import legacy_interfaces
from analyze_procedure_purity import review


class ProcedurePurityTests(unittest.TestCase):
    def test_pure_call_chain_keeps_external_implementations(self):
        source = '''real function leaf(x)
implicit none
real, intent(in) :: x
leaf = x*x
end function leaf
real function caller(x)
implicit none
real, intent(in) :: x
real :: leaf
external leaf
caller = leaf(x)
end function caller
'''
        blocks = procedure_blocks(source)
        manifest = {'source_hashes': {n: code_hash(b) for n, b in blocks.items()},
                    'calls': {'LEAF': [], 'CALLER': ['LEAF']},
                    'procedures': {
                        'LEAF': {'attribute': 'pure elemental', 'interface': 'pure elemental real function leaf(x)\nimplicit none\nreal, intent(in) :: x\nend function leaf\n'},
                        'CALLER': {'attribute': 'pure', 'interface': ''}}}
        result = transform(source, manifest)
        self.assertEqual(set(procedure_blocks(result)), {'LEAF', 'CALLER'})
        self.assertIn('pure real function caller', result)
        self.assertIn('interface\n   pure elemental real function leaf(x)\n      implicit none', result)
        self.assertNotIn('external leaf', result)
        self.assertIn('caller = leaf(x)', result)
        with self.assertRaisesRegex(ValueError, 'code changed'):
            transform(source.replace('x*x', 'x+x'), manifest)

    def test_legacy_interface_view_only_removes_contract_prefixes(self):
        text = 'pure elemental real function f(x)\nreal,intent(in)::x\nend function f\n'
        self.assertEqual(legacy_interfaces(text), 'real function f(x)\nreal,intent(in)::x\nend function f\n')
        self.assertEqual(legacy_interfaces('pure function f(pure )\n'), 'function f(pure )\n')

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU compiler required')
    def test_compiler_rejects_a_heuristic_candidate_that_writes_common(self):
        text = '''subroutine bad(x)
implicit none
real, intent(in) :: x
real :: counter
common /state/ counter
counter = x
end subroutine bad
'''
        interface = 'subroutine bad(x)\nreal,intent(in)::x\nend subroutine bad\n'
        draft = {'pure': ['BAD'], 'elemental': [], 'rejected': {}, 'procedure_actuals': []}
        with tempfile.TemporaryDirectory() as folder:
            result = review(text, interface, draft, 'gfortran', Path(folder))
        self.assertEqual(result['summary']['annotated'], 0)
        self.assertIn('BAD', result['compiler_rejections'])
