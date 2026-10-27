"""Safety boundaries for generated-copy elimination."""
import sys
from pathlib import Path
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from remove_redundant_copies import transform

SOURCE='''      REAL FUNCTION F(X)
      IMPLICIT NONE
      REAL, INTENT(IN) :: X
      REAL :: R
      REAL :: NSWC_AI_R4
C     Keep NSWC_AI_R4 in comments.
      NSWC_AI_R4 = X
      IF (NSWC_AI_R4 .LT. 0) THEN
         R = LOG(-X)/3.0
         F = -EXP(R)
      ELSE IF (NSWC_AI_R4 .EQ. 0) THEN
         F = 0.0
      ELSE
         F = EXP(LOG(X)/3.0)
      END IF
      END FUNCTION F
'''

class Copies(unittest.TestCase):
    def check_skip(self,source):
        report={}; data=source.encode()
        self.assertEqual(transform(data,report),data)
        self.assertTrue(report['skipped'])
    def test_structured(self):
        report={}; result=transform(SOURCE.encode(),report)
        self.assertEqual(len(report['converted']),1)
        self.assertIn(b'C     Keep NSWC_AI_R4 in comments.',result)
        self.assertIn(b'IF (X .LT. 0)',result)
        self.assertNotIn(b'REAL :: NSWC_AI_R4',result)
        self.assertEqual(transform(result),result)
    def test_adjacent(self):
        source=SOURCE[:SOURCE.index('      IF')]+'''      IF (NSWC_AI_R4 .LT. 0) GO TO 10
      IF (NSWC_AI_R4 .EQ. 0) GO TO 20
      F = X
      RETURN
   10 F = -X
      RETURN
   20 F = 0.0
      END FUNCTION F
'''
        self.assertNotEqual(transform(source.encode()),source.encode())
        self.check_skip(source.replace('      IF (NSWC_AI_R4 .EQ.','    5 IF (NSWC_AI_R4 .EQ.'))
    def test_type_intent_expression(self):
        for old,new in [('REAL :: NSWC_AI_R4','INTEGER :: NSWC_AI_R4'),('INTENT(IN)','INTENT(INOUT)'),('NSWC_AI_R4 = X','NSWC_AI_R4 = X + 1'),(':: X',':: X(1)')]:
            with self.subTest(new=new): self.check_skip(SOURCE.replace(old,new))
    def test_reassignment_and_calls(self):
        for new in ['         X = 1.0','         NSWC_AI_R4 = 1.0','         CALL G(X)','         R = G(X)','   10    R = LOG(-X)/3.0']:
            with self.subTest(new=new): self.check_skip(SOURCE.replace('         R = LOG(-X)/3.0',new))
    def test_annotations_and_storage(self):
        self.check_skip(SOURCE.replace('REAL :: NSWC_AI_R4','REAL :: NSWC_AI_R4 ! preserve'))
        self.check_skip(SOURCE.replace('      NSWC_AI_R4 = X','      SAVE NSWC_AI_R4\n      NSWC_AI_R4 = X'))
        self.check_skip(SOURCE.replace('      NSWC_AI_R4 = X','      ENTRY G(X)\n      NSWC_AI_R4 = X'))
    def test_inline_comment(self):
        source=SOURCE.replace('0) THEN\n','0) THEN ! NSWC_AI_R4\n',1)
        result=transform(source.encode())
        self.assertIn(b'! NSWC_AI_R4',result)
        self.assertIn(b'IF (X .LT. 0)',result)

if __name__=='__main__': unittest.main()
