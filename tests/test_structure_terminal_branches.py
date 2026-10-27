"""Conservative tail restructuring, including control-flow rejection cases."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from structure_terminal_branches import transform,transform_two_way

SOURCE = b'''      REAL FUNCTION F(X)
      IMPLICIT NONE
      REAL, INTENT(IN) :: X
      REAL :: T
      T = X
      IF (T .LT. 0) GO TO 30
      IF (T .EQ. 0) GO TO 10
      GO TO 20
   10 F = 0.0
      RETURN
   20 F = X + 1.0
      RETURN
   30 F = -X
      END FUNCTION F
'''

class TerminalBranchesTests(unittest.TestCase):
    def test_structure_and_idempotence(self):
        report = {}
        result = transform(SOURCE, report)
        self.assertNotIn(b'GO TO', result)
        self.assertNotIn(b'RETURN', result)
        self.assertIn(b'IF (T .LT. 0) THEN\n         F = -X', result)
        self.assertIn(b'ELSE IF (T .EQ. 0) THEN\n         F = 0.0', result)
        self.assertEqual(transform(result), result)
        self.assertEqual(len(report['converted']), 1)

    def test_expression_evaluated_once(self):
        source = SOURCE.replace(b'T = X', b'T = SIDE(X)')
        result = transform(source)
        self.assertEqual(result.count(b'SIDE(X)'), 1)
        self.assertIn(b'T = SIDE(X)', result)

    def test_unsafe_control_flow(self):
        variants = [
            SOURCE.replace(b'      T = X', b'      IF (X .GT. 2) GO TO 10\n      T = X'),
            SOURCE.replace(b'      T = X', b'      DO I = 1,2\n      T = X'),
            SOURCE.replace(b'      RETURN\n   20', b'   40 RETURN\n   20'),
            SOURCE.replace(b'      RETURN\n   20', b'   20'),
            SOURCE.replace(b'   30 F = -X', b'   30 CALL SIDE(X)'),
            SOURCE.replace(b'   30 F = -X', b'   30 F => X'),
            SOURCE.replace(b'GO TO 30', b'GO TO 20'),
            SOURCE.replace(b'      T = X', b'      ENTRY OTHER(X)\n      T = X'),
            SOURCE.replace(b'      T = X', b'      ASSIGN 10 TO I\n      T = X'),
        ]
        for source in variants:
            with self.subTest(source=source):
                self.assertEqual(transform(source), source)

    def test_layout_needs_review(self):
        variants = [
            SOURCE.replace(b'   30 F = -X', b'C     Negative case\n   30 F = -X'),
            SOURCE.replace(b'   30 F = -X', b'   30 F = -X ! comment'),
            SOURCE.replace(b'   30 F = -X', b'   30 F =\n     & -X'),
            SOURCE.replace(b'      T = X', b'C$OMP PARALLEL\n      T = X'),
            SOURCE.replace(b'      IF (T .LT.', b'   50 IF (T .LT.'),
            SOURCE.replace(b'   30 F = -X', b'   30 F = -X' + b' '*61+b'SEQ'),
        ]
        for source in variants:
            with self.subTest(source=source):
                self.assertEqual(transform(source), source)

TWO_WAY_SOURCE=b'''      SUBROUTINE FFT1(A,B,N,ISN,IERR)
      IMPLICIT NONE
      INTEGER :: N, ISN, IERR
      REAL :: A(N), B(N)
C     Wrapper
      IF (ABS(ISN) .NE. 1) GO TO 10
      CALL SFFT(A,B,N,N,N,ISN,IERR)
      RETURN
   10 IERR = 4
      END SUBROUTINE FFT1
'''


class TwoWayBranchesTests(unittest.TestCase):
    def test_call_wrapper_and_idempotence(self):
        report={};result=transform_two_way(TWO_WAY_SOURCE,report)
        self.assertIn(b'IF (ABS(ISN) .NE. 1) THEN\n         IERR = 4\n      ELSE\n         CALL SFFT',result)
        self.assertNotIn(b'GO TO',result)
        self.assertNotIn(b'RETURN',result)
        self.assertIn(b'C     Wrapper\n',result)
        self.assertEqual(transform_two_way(result),result)
        self.assertEqual(len(report['converted']),1)

    def test_condition_keeps_single_evaluation(self):
        source=TWO_WAY_SOURCE.replace(b'ABS(ISN)',b'SIDE(ISN)')
        self.assertEqual(transform_two_way(source).count(b'SIDE(ISN)'),1)

    def test_reject_unsupported_control_flow(self):
        variants=[
            TWO_WAY_SOURCE.replace(b'C     Wrapper',b'      IF (N .EQ. 0) GO TO 10'),
            TWO_WAY_SOURCE.replace(b'C     Wrapper',b'      DO I = 1,2'),
            TWO_WAY_SOURCE.replace(b'C     Wrapper',b'      ENTRY OTHER(A)'),
            TWO_WAY_SOURCE.replace(b'      RETURN\n',b''),
            TWO_WAY_SOURCE.replace(b'   10 IERR = 4',b'   10 IF (N .EQ. 1) IERR = 4'),
            TWO_WAY_SOURCE.replace(b'      CALL SFFT(A,B,N,N,N,ISN,IERR)',b'      CALL SFFT(A,*10)'),
            TWO_WAY_SOURCE.replace(b'      CALL SFFT',b'   20 CALL SFFT'),
        ]
        for source in variants:
            with self.subTest(source=source):self.assertEqual(transform_two_way(source),source)

    def test_reject_comments_continuations_and_width(self):
        variants=[
            TWO_WAY_SOURCE.replace(b'   10 IERR = 4',b'C     Error path\n   10 IERR = 4'),
            TWO_WAY_SOURCE.replace(b'   10 IERR = 4',b'   10 IERR = 4 ! error'),
            TWO_WAY_SOURCE.replace(b'   10 IERR = 4',b'   10 IERR =\n     & 4'),
            TWO_WAY_SOURCE.replace(b'   10 IERR = 4',b'   10 IERR = '+b'1+'*28+b'1'),
            TWO_WAY_SOURCE.replace(b'C     Wrapper',b'C$OMP PARALLEL'),
        ]
        for source in variants:
            with self.subTest(source=source):self.assertEqual(transform_two_way(source),source)

    def test_optional_last_return_and_assignment_prefix(self):
        source=TWO_WAY_SOURCE.replace(b'C     Wrapper',b'      IERR = -1').replace(b'      END SUBROUTINE',b'      RETURN\n      END SUBROUTINE')
        result=transform_two_way(source)
        self.assertIn(b'      IERR = -1\n',result)
        self.assertNotIn(b'RETURN',result)
        self.assertTrue(all(len(line)<=72 for line in result.splitlines()))

if __name__ == '__main__':
    unittest.main()
