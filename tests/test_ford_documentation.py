"""Reversible documentation placement and complete generated-source proof."""
from pathlib import Path
import sys
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from ford_documentation import transform,strip,line_numbers,HISTORY_BEGIN
from format_free_form import semantic_statements
ROOT=Path(__file__).resolve().parents[1]

class FordDocumentationTests(unittest.TestCase):
    def test_continued_header_and_interface_are_handled(self):
        source='subroutine stod(neq, &\n & y)\nimplicit none\ninteger :: neq\nreal :: y(*)\ninterface\n subroutine shell(a,n)\n real a(*)\n integer n\n end subroutine shell\nend interface\nend subroutine stod\n'
        result=transform(source)
        self.assertTrue(result.startswith('subroutine stod(neq, &\n & y)\n!! <!-- nswc-ford:begin STOD -->'))
        self.assertNotIn('begin SHELL',result)
        self.assertEqual(strip(result),source)
        self.assertEqual(transform(result),result)

    def test_line_map_preserves_original_lines(self):
        source='pure elemental real function cbrt(x)\nreal,intent(in)::x\ncbrt=x\nend function cbrt\n'
        result=transform(source);mapping=line_numbers(source,result)
        for i,line in enumerate(source.splitlines(),1):self.assertEqual(result.splitlines()[mapping[i]-1],line)
        self.assertEqual(semantic_statements(source),semantic_statements(result))

    def test_unmanaged_comments_survive(self):
        source='! ordinary\n!! unowned documentation\nsubroutine s\nend subroutine s\n'
        self.assertEqual(transform(source),source)
        with self.assertRaises(ValueError):strip('!! <!-- nswc-ford:begin CBRT -->\n')
        with self.assertRaises(ValueError):
            strip('!! <!-- nswc-ford:begin CBRT -->\nreal :: hidden\n!! <!-- nswc-ford:end -->\n')

    def test_complete_sources_only_change_managed_comments(self):
        for filename in ['nswc.f90','nswc_mod.f90']:
            source=(ROOT/filename).read_text();result=transform(source)
            self.assertEqual(result,source)
            self.assertEqual(semantic_statements(source),semantic_statements(strip(source)))
            self.assertEqual(source.count('!! <!-- nswc-ford:begin '),6 if filename=='nswc_mod.f90' else 5)
            self.assertIn(HISTORY_BEGIN,source)
            self.assertIn('begin STOD',source)

if __name__=='__main__':unittest.main()
