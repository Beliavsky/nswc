"""Declaration section boundaries must respect argument/result dependencies."""
import sys
from pathlib import Path
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from declaration_sections import transform,MARKER,remove_empty_free_markers

class Sections(unittest.TestCase):
 def check(self,text):
  data=text.encode();report={};after=transform(data,report)
  self.assertFalse(report['skipped'])
  self.assertEqual(transform(after),after)
  return after.decode(),report
 def test_mixed_arguments_results_callbacks(self):
  after,r=self.check('''      REAL FUNCTION F(X,CB)
      IMPLICIT NONE
      REAL :: WORK, X, F, CB
      EXTERNAL CB
C     Keep the description.
      F = CB(X)
      END FUNCTION F
''')
  self.assertLess(after.index(':: X, F, CB'),after.index(MARKER))
  self.assertLess(after.index('EXTERNAL CB'),after.index(MARKER))
  self.assertLess(after.index(MARKER),after.index(':: WORK'))
  self.assertIn('C     Keep the description.',after)
  self.assertEqual(r['mixed_declarations'],['F'])
 def test_named_function_result(self):
  after,r=self.check('      FUNCTION F(X) RESULT(R)\n      IMPLICIT NONE\n      REAL :: WORK, R, X\n      R = X\n      END FUNCTION F\n')
  self.assertLess(after.index(':: R, X'),after.index(MARKER))
  self.assertLess(after.index(MARKER),after.index(':: WORK'))
 def test_parameter_dependency(self):
  after,r=self.check('''      SUBROUTINE S(X)
      IMPLICIT NONE
      INTEGER :: N, UNRELATED
      PARAMETER (N=3)
      REAL :: X(N), WORK
      END SUBROUTINE S
''')
  self.assertLess(after.index(':: N'),after.index('PARAMETER'))
  self.assertLess(after.index('PARAMETER'),after.index(':: X(N)'))
  self.assertLess(after.index(':: X(N)'),after.index(MARKER))
  self.assertGreater(after.index(':: UNRELATED'),after.index(MARKER))
  self.assertEqual(r['prerequisite_locals'][0]['names'],['N'])
 def test_typed_parameter_kind(self):
  after,r=self.check('''      SUBROUTINE S(X)
      IMPLICIT NONE
      INTEGER, PARAMETER :: RK = KIND(0.0)
      REAL(RK) :: WORK, X
      END SUBROUTINE S
''')
  self.assertLess(after.index('PARAMETER'),after.index(':: X'))
  self.assertLess(after.index(':: X'),after.index(MARKER))
  self.assertLess(after.index(MARKER),after.index(':: WORK'))
 def test_separate_dimension(self):
  after,r=self.check('''      SUBROUTINE S(N,X)
      IMPLICIT NONE
      INTEGER :: LOCAL, N
      REAL :: X
      COMMON /C/ LOCAL
      DIMENSION X(N)
      END SUBROUTINE S
''')
  self.assertLess(after.index('DIMENSION X(N)'),after.index(MARKER))
  self.assertLess(after.index(MARKER),after.index(':: LOCAL'))
  self.assertIn('COMMON /C/ LOCAL',after)
 def test_no_local_variables(self):
  after,r=self.check('''      REAL FUNCTION F(X)
      IMPLICIT NONE
      REAL :: X, F, G
      EXTERNAL G
      F = G(X)
      END FUNCTION F
''')
  self.assertNotIn(MARKER,after)
  self.assertEqual(r['without_marker'],['F'])
 def test_annotations_and_entry_require_review(self):
  for insertion in ('      REAL :: LOCAL ! Keep this\n','      ENTRY OTHER(X)\n'):
   text='      SUBROUTINE S(X)\n      IMPLICIT NONE\n      REAL :: X\n'+insertion+'      END SUBROUTINE S\n'
   r={};self.assertEqual(transform(text.encode(),r),text.encode());self.assertTrue(r['skipped'])
   text=text.replace(insertion,MARKER+'\n'+insertion)
   self.assertEqual(transform(text.encode()),text.encode())
 def test_external_function_without_external_attribute(self):
  source='      REAL FUNCTION F(X)\n      IMPLICIT NONE\n      REAL :: X, G\n      F = G(X)\n      END FUNCTION F\n'
  result,r=self.check(source)
  self.assertNotIn(MARKER,result)
  source=source.replace(':: X, G',':: X, G(2)')
  result,r=self.check(source)
  self.assertIn(MARKER,result)
 def test_remove_empty_module_markers(self):
  source='subroutine s(x)\nreal :: x\n!     beginning of local variable declarations\nx = 1\nend subroutine s\n'
  self.assertNotIn('beginning of local',remove_empty_free_markers(source))
  source=source.replace('x = 1','real :: local\nx = 1')
  self.assertIn('beginning of local',remove_empty_free_markers(source))

 def test_crlf(self):
  text='      SUBROUTINE S(X)\r\n      IMPLICIT NONE\r\n      REAL :: X, A\r\n      END SUBROUTINE S\r\n'
  result,r=self.check(text)
  self.assertIn(MARKER+'\r\n',result)
  self.assertNotIn('\n',result.replace('\r\n',''))

if __name__=='__main__':unittest.main()
