"""Check label-state dispatch, exact branch references and strict compilation."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from modernize_deleted_do import transform as loops
from modernize_remaining_features import transform, assigned_labels, verify, strict_standard


class RemainingFeatureTests(unittest.TestCase):
    source = b'''      INTEGER FUNCTION DISPATCH(N)
      IMPLICIT NONE
      INTEGER N,NEXT,I
      DISPATCH=0
      DO 50 I=1,N
      ASSIGN 010 TO NEXT
      IF (MOD(I,2).EQ.0) GO TO 5
      ASSIGN 020 TO NEXT
    5 GO TO NEXT,(10,20)
   10 DISPATCH=DISPATCH+I
      GO TO 50
   20 DISPATCH=DISPATCH-I
   50 CONTINUE
      END FUNCTION DISPATCH
'''

    def test_dispatch_and_loop_conversion_preserve_labels(self):
        report = {}
        changed = transform(self.source, report)
        self.assertEqual(report['transfer_counts'], {'assign': 2, 'dispatch': 1})
        self.assertEqual(report['loop_counts'], {'converted': 1})
        self.assertIn(b'    5 SELECT CASE', changed)
        self.assertIn(b'CASE ( 10 )', changed)
        self.assertIn(b'NEXT = 10', changed)
        self.assertIn(b'   50 CONTINUE\n      END DO', changed)
        self.assertEqual(transform(changed), changed)

    def test_assigned_label_cannot_be_used_as_data_or_format(self):
        for statement in (b'      N=NEXT\n', b'      WRITE(*,NEXT) N\n',
                          b'      CALL S(NEXT)\n', b'      EQUIVALENCE (NEXT,N)\n'):
            source = self.source.replace(b'      DISPATCH=0\n', statement + b'      DISPATCH=0\n')
            with self.assertRaisesRegex(ValueError, 'another use'):
                assigned_labels(source)

    def test_numeric_mentions_and_done_are_not_loop_headers_or_branches(self):
        source = b'''      SUBROUTINE S(N,A)
      IMPLICIT NONE
      INTEGER N,A,I
      LOGICAL DONE
      A=10
      DO 10 I=1,N
      DONE=.FALSE.
   10 A=A+I
      END SUBROUTINE S
'''
        self.assertEqual(loops(source).data, source)
        self.assertNotEqual(loops(source, precise=True).data, source)

    def test_true_entries_into_loop_stay_unconverted(self):
        source = b'''      SUBROUTINE S(N,A)
      INTEGER N,A,I
      GO TO 10
      DO 10 I=1,N
   10 A=A+I
      END SUBROUTINE S
'''
        for branch in (b'GO TO 10', b'GO TO (10,20),N', b'READ(*,*,ERR=10) N'):
            test = source.replace(b'GO TO 10', branch)
            self.assertEqual(loops(test, precise=True).data, test)

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_execution_and_strict_standard(self):
        changed = transform(self.source)
        verify(self.source, changed)
        with tempfile.TemporaryDirectory(prefix='nswc-remaining-test-') as work:
            folder = Path(work)
            driver = folder / 'driver.f90'
            driver.write_text('''program probe
implicit none
integer :: n,dispatch
do n=0,10
   print *,n,dispatch(n)
end do
end program probe
''')
            for optimization in ('-O0', '-O2'):
                outputs = []
                for data, standard in ((self.source, '-std=legacy'), (changed, strict_standard())):
                    source = folder / 'input.f';source.write_bytes(data)
                    r = subprocess.run(['gfortran', optimization, standard, str(source), str(driver), '-o', 'probe.exe'],
                                       cwd=work, capture_output=True, text=True, timeout=60)
                    self.assertEqual(r.returncode, 0, r.stderr)
                    r = subprocess.run([str(folder / 'probe.exe')], capture_output=True, text=True, timeout=10)
                    self.assertEqual(r.returncode, 0, r.stderr);outputs.append(r.stdout)
                self.assertEqual(*outputs)
