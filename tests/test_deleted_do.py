"""Exercise terminal operations, shared loops and branches during conversion."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from modernize_deleted_do import transform, verify


class DeletedDoTests(unittest.TestCase):
    source = b'''      SUBROUTINE S(A,N,M)
      IMPLICIT NONE
      INTEGER N,M,I,J
      INTEGER A
      A=0
      DO 10 I=1,N
      DO 10 J=1,M
      IF (J.EQ.2) GO TO 10
      A=A+J
   10 A=A+I
      END SUBROUTINE S
'''

    def test_shared_terminal_operation_is_preserved_once(self):
        result = transform(self.source)
        self.assertEqual(sum(r.status == 'converted' for r in result.loops), 2)
        self.assertIn(b'   10 A=A+I\n      END DO\n      END DO\n', result.data)
        self.assertEqual(result.data.count(b'   10 A=A+I'), 1)
        self.assertEqual(transform(result.data).data, result.data)

    def test_branch_from_outside_retains_whole_shared_group(self):
        source = self.source.replace(b'      A=0\n', b'      A=0\n      IF (N.LT.0) GO TO 10\n')
        result = transform(source)
        self.assertEqual(result.data, source)
        self.assertTrue(all(r.status == 'skipped' for r in result.loops))

    def test_indirect_branch_and_continued_header_are_retained(self):
        source = self.source.replace(b'      A=0\n', b'      ASSIGN 10 TO A\n')
        self.assertEqual(transform(source).data, source)
        source = self.source.replace(b'      DO 10 I=1,N\n', b'      DO 10 I=1,\n     &N\n')
        self.assertEqual(transform(source).data, source)

    def test_continued_terminal_and_comments(self):
        source = self.source.replace(b'   10 A=A+I\n', b'   10 A=A+\nC Keep comment\n     &I\n')
        source = source.replace(b'\n', b'\r\n')
        result = transform(source)
        self.assertIn(b'   10 A=A+\r\nC Keep comment\r\n     &I\r\n      END DO\r\n', result.data)

    def test_crossing_boundaries_and_unrelated_edits_are_rejected(self):
        source = self.source.replace(b'      DO 10 J=1,M', b'      DO 20 J=1,M')
        source = source.replace(b'      END SUBROUTINE', b'   20 CONTINUE\n      END SUBROUTINE')
        self.assertEqual(transform(source).data, source)
        from refresh_do_review_hashes import migrate
        changed = transform(self.source).data.replace(b'A=A+I', b'A=A-I')
        with self.assertRaisesRegex(ValueError, 'not exactly'):
            migrate(self.source, changed)

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_assembly_and_execution_with_empty_and_nonempty_loops(self):
        result = transform(self.source)
        verify(self.source, result.data)
        with tempfile.TemporaryDirectory(prefix='nswc-do-test-') as work:
            path, driver = Path(work) / 'library.f', Path(work) / 'driver.f90'
            driver.write_text('''program probe
implicit none
integer :: n,m,a
do n=0,4
   do m=0,4
      call s(a,n,m)
      print *,n,m,a
   end do
end do
end program probe
''')
            outputs = []
            for data in (self.source, result.data):
                path.write_bytes(data)
                compiled = subprocess.run(['gfortran', '-std=legacy', str(path), str(driver), '-o', 'probe.exe'],
                                          cwd=work, capture_output=True, text=True, timeout=60)
                self.assertEqual(compiled.returncode, 0, compiled.stderr)
                run = subprocess.run([str(Path(work) / 'probe.exe')], capture_output=True, text=True, timeout=10)
                self.assertEqual(run.returncode, 0, run.stderr)
                outputs.append(run.stdout)
            self.assertEqual(*outputs)
