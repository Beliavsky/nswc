"""Scope, precision and lexical boundaries for shared module pi constants."""
import sys
from pathlib import Path
import shutil
import tempfile
import unittest
import subprocess
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from module_pi_constants import transform,DEFINITIONS
from module_kinds import DEFINITION as KINDS
from validate_module_pi import verify_values

SOURCE='''module m
implicit none
private
'''+KINDS+'''public :: f
contains
real(nswc_sp) function f(x)
real(nswc_sp), intent(in) :: x
real(nswc_sp), parameter :: pi = 3.14159265358979
f = pi*x + 1.5707963267949 ! pi and 3.14159265358979
end function f
end module m
'''

class PiTests(unittest.TestCase):
    def test_consolidation_and_idempotence(self):
        r={};aligned=[];result=transform(SOURCE,r,aligned)
        self.assertIn(DEFINITIONS,result)
        self.assertNotIn('parameter :: pi =',result)
        self.assertIn('f = nswc_pi_sp*x + nswc_half_pi_sp ! pi and 3.14159265358979',result)
        self.assertEqual(len(r['declarations']),1)
        self.assertEqual(len(r['literals']),1)
        self.assertEqual(transform(result),result)
        self.assertEqual(len(aligned[0].splitlines()),len(aligned[1].splitlines()))
    def test_double_and_three_halves(self):
        source=SOURCE.replace('real(nswc_sp)','real(nswc_dp)').replace('3.14159265358979','3.1415926535897932384626433832795d0').replace('1.5707963267949','4.71238898038468985769396507492d0')
        result=transform(source)
        self.assertIn('f = nswc_pi_dp*x + nswc_three_half_pi_dp',result)
    def test_precision_coefficients_and_annotations(self):
        for declaration in ['real(nswc_dp), parameter :: pi = 3.14159265358979',
                            'real(nswc_sp), parameter :: pi = 3.14159',
                            'real(nswc_sp), parameter :: coefficient = 3.14159265358979',
                            'real(nswc_sp), parameter :: pi = 3.14159265358979 ! note']:
            source=SOURCE.replace('real(nswc_sp), parameter :: pi = 3.14159265358979',declaration)
            self.assertIn(declaration,transform(source))
    def test_strings_complex_literals_components_keywords(self):
        source=SOURCE.replace('f = pi*x + 1.5707963267949 ! pi and 3.14159265358979',
          "print *, 'pi 3.14159265358979'\ncall cb(pi=pi)\nf = obj%pi + pi\nz = (0.0,3.14159265358979)")
        result=transform(source)
        self.assertIn("'pi 3.14159265358979'",result)
        self.assertIn('call cb(pi=nswc_pi_sp)',result)
        self.assertIn('obj%pi + nswc_pi_sp',result)
        self.assertIn('z = (0.0,3.14159265358979)',result)
        source=SOURCE.replace('f = pi*x + 1.5707963267949', 'coeff = [3.14159265358979,1.5707963267949]')
        self.assertIn('coeff = [3.14159265358979,1.5707963267949]',transform(source))
    def test_nested_and_collisions(self):
        source=SOURCE.replace('end function f','contains\nreal function g()\ng=pi\nend function g\nend function f')
        self.assertIn('parameter :: pi =',transform(source))
        self.assertNotIn('parameter :: pi =',transform(source.replace('g=pi','g=1.0')))
        with self.assertRaisesRegex(ValueError,'Reserved'):
            transform(SOURCE.replace(':: pi =',':: nswc_pi_sp ='))
    def test_wrapping(self):
        source=SOURCE.replace('f = pi*x + 1.5707963267949', 'f = '+ ' + '.join(['pi*x']*15))
        aligned=[];result=transform(source,aligned_sources=aligned)
        self.assertTrue(all(len(line.split("!")[0].rstrip())<=132 for line in result.splitlines()))
        self.assertEqual(len(aligned[0].splitlines()),len(aligned[1].splitlines()))
    @unittest.skipUnless(shutil.which('gfortran'),'GNU required')
    def test_compiler_values_and_privacy(self):
        review={};result=transform(SOURCE,review)
        verify_values(review)
        with tempfile.TemporaryDirectory(prefix='nswc-pi-unit-') as folder:
            folder=Path(folder);(folder/'input.f90').write_text(result)
            r=subprocess.run(['gfortran','-c','input.f90'],cwd=folder,capture_output=True,text=True)
            self.assertEqual(r.returncode,0,r.stderr)
            (folder/'bad.f90').write_text('program p\nuse m, only: nswc_pi_sp\nend program p\n')
            r=subprocess.run(['gfortran','-fsyntax-only','bad.f90'],cwd=folder,capture_output=True,text=True)
            self.assertNotEqual(r.returncode,0)

if __name__=='__main__': unittest.main()
