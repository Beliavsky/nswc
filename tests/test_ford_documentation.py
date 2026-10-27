"""Reversible documentation placement and complete generated-source proof."""
from pathlib import Path
import sys
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from ford_documentation import transform,strip,line_numbers,HISTORY_BEGIN,introductory_comments
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
        self.assertEqual(strip(transform(source)),source)
        self.assertIn('No introductory description is present',transform('subroutine s\nend subroutine s\n'))
        with self.assertRaises(ValueError):strip('!! <!-- nswc-ford:begin CBRT -->\n')
        with self.assertRaises(ValueError):
            strip('!! <!-- nswc-ford:begin CBRT -->\nreal :: hidden\n!! <!-- nswc-ford:end -->\n')

    def test_complete_sources_only_change_managed_comments(self):
        for filename in ['nswc.f90','nswc_mod.f90']:
            source=(ROOT/filename).read_text();result=transform(source)
            self.assertEqual(result,source)
            self.assertEqual(semantic_statements(source),semantic_statements(strip(source)))
            self.assertEqual(source.count('!! <!-- nswc-ford:begin '),1063 if filename=='nswc_mod.f90' else 1062)
            self.assertIn(HISTORY_BEGIN,source)
            self.assertIn('begin STOD',source)

    def test_only_introductory_notes_are_imported(self):
        source='subroutine example(x)\nimplicit none\n! Purpose and arguments\nreal :: x\n! beginning of local variable declarations\nreal :: y\ninterface\nsubroutine callback()\nend subroutine callback\nend interface\n!   x = input\n!   y = x**2\ny=x*x\n! Execution note must stay private\nx=y\nend subroutine example\n'
        notes=introductory_comments(source.splitlines(True))
        self.assertIn('x = input',notes)
        self.assertNotIn('Execution note',notes)
        self.assertNotIn('beginning of local',notes)
        result=transform(source)
        doc=result.split('!! <!-- nswc-ford:end -->')[0]
        self.assertIn('!!    y = x**2',doc)
        self.assertNotIn('Execution note',doc)
        self.assertEqual(strip(result),source)

    def test_pre_header_prologue_and_literal_fences(self):
        source='subroutine earlier\n! private execution note\nend subroutine earlier\n\n! Fourier initialization\n! ``` example fence\nsubroutine example\nend subroutine example\n'
        result=transform(source)
        doc=result.split('!! <!-- nswc-ford:begin EXAMPLE -->')[1]
        self.assertIn('Fourier initialization',doc)
        self.assertIn('!! ````text',doc)
        self.assertNotIn('private execution note',doc)
        self.assertEqual(strip(result),source)

if __name__=='__main__':unittest.main()
