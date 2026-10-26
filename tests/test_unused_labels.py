"""Label cleanup must distinguish real references from ordinary numbers."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from remove_unused_labels import transform, references, verify
from name_procedure_ends import statements


def unit(body):
    return ('      SUBROUTINE T(N)\n      INTEGER N,I\n' + body + '      END SUBROUTINE T\n').encode('ascii')


class UnusedLabelTests(unittest.TestCase):
    def test_numbers_literals_comments_and_unused_continue(self):
        source = unit("      N=40\n   10 CONTINUE ! Keep this comment\n   40 N=N+1\n"
                      "      PRINT *, 'GO TO 40', 'ERR=10'\nC     GO TO 10\n")
        report = {}
        result = transform(source, report)
        self.assertNotIn(b'CONTINUE', result)
        self.assertIn(b'      ! Keep this comment\n', result)
        self.assertIn(b'      N=N+1', result)
        self.assertIn(b"'GO TO 40', 'ERR=10'", result)
        self.assertEqual(report['counts'], {'remove_continue': 1, 'remove_label': 1})
        self.assertEqual(transform(result), result)
        hollerith = unit('      N=1\n      CALL F(8HGO TO 40)\n   40 N=N+1\n')
        self.assertNotIn(b'   40 N=', transform(hollerith))

    def test_all_reference_forms_are_protected(self):
        body = '''      IF(N.LT.0) GO TO 10
      GO TO (20,30), N
      IF(N)40,50,60
      DO 70 I=1,N
      READ(5,80,ERR=90,END=100,EOR=110)N
      IF(N.EQ.1) CALL F(*120,N*130)
'''
        refs, reason = references(list(statements(body.splitlines(True))))
        self.assertEqual(refs, {10,20,30,40,50,60,70,90,100,110,120})
        self.assertEqual(reason, '')
        source = unit(body + ''.join(f'{n:5} CONTINUE\n' for n in refs) + '   80 FORMAT(I5)\n  130 N=N+1\n')
        result = transform(source)
        for n in refs:
            self.assertIn(f'{n:5} CONTINUE'.encode(), result)
        self.assertIn(b'   80 FORMAT', result)
        self.assertNotIn(b'  130 N=', result)

    def test_indirect_flow_skips_whole_procedure(self):
        for code in ('      ASSIGN 10 TO N\n', '      GO TO N,(10,20)\n',
                     '      CALL F(8H!GO TO40,*10)\n'):
            source = unit(code + '   10 CONTINUE\n   20 CONTINUE\n')
            report = {}
            self.assertEqual(transform(source, report), source)
            self.assertEqual(len(report['skipped_procedures']), 1)

    def test_continuations_scope_and_sequence_fields(self):
        source = unit('      GO TO\n     & 10\n   10 N=N+1\n   20 CONTINUE\n')
        other = unit('      N=10\n   10 N=N+1\n').replace(b'SUBROUTINE T', b'SUBROUTINE U')
        result = transform(source + other)
        self.assertEqual(result.count(b'   10 N=N+1'), 1)
        self.assertNotIn(b'   20 CONTINUE', result)
        seq = unit('      N=1\n' + '   30 CONTINUE'.ljust(72) + 'SEQUENCE\n')
        self.assertIn(b'      CONTINUE', transform(seq))
        self.assertIn(b'SEQUENCE', transform(seq))

    def test_formats_specifications_and_initial_array_assignments_remain(self):
        source = unit('   10 DATA I/40/\n   20 FORMAT(I5)\n   30 A(I)=1\n      N=1\n   40 N=N+1\n')
        result = transform(source)
        for label in (10,20,30):
            self.assertIn(f'{label:5} '.encode(), result)
        self.assertNotIn(b'   40 N=', result)

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_compiler_and_execution_agree(self):
        source = unit('      N=0\n      DO I=1,4\n   10 CONTINUE\n   40 N=N+I\n      END DO\n')
        result = transform(source)
        verify(source, result)
        with tempfile.TemporaryDirectory(prefix='unused-label-test-') as work:
            work = Path(work)
            for opt in ('-O0', '-O2'):
                for body in (source, result):
                    (work/'input.f').write_bytes(body + b'      CALL T(N)\n      IF(N.NE.10) STOP 1\n      END\n')
                    compiled = subprocess.run(['gfortran', opt, 'input.f', '-o', 'test.exe'], cwd=work, capture_output=True, text=True)
                    self.assertEqual(compiled.returncode, 0, compiled.stderr)
                    self.assertEqual(subprocess.run([str(work/'test.exe')], cwd=work).returncode, 0)


if __name__ == '__main__':
    unittest.main()
