"""Structured exits must retain loop state, side effects and outside targets."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT/'tools'))
from goto_to_exit import transform, verify
from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from format_free_form import format_source


def source(body, extra=''):
    return ('      SUBROUTINE T(N,S,I,J)\n      INTEGER N,S,I,J\n'+extra+body+'      END SUBROUTINE T\n').encode('ascii')


class GotoExitTests(unittest.TestCase):
    inner = source('      S=0\n      DO I=1,N\n      IF(I.EQ.2) GO TO 20\n      S=S+I\n      END DO\n   20 S=S+10\n')
    outer = source('      S=0\n      DO I=1,N\n      DO J=1,4\n      S=S+1\n      IF(J.EQ.2) GO TO 20\n      END DO\n      END DO\n   20 S=S+10\n')

    def test_inner_exit_and_unused_target(self):
        result = transform(self.inner)
        self.assertIn(b'IF ( I .EQ. 2 ) EXIT', result)
        self.assertNotIn(b'   20 ', result)
        self.assertNotIn(b'NSWC_EXIT', result)
        self.assertEqual(transform(result), result)

    def test_outer_exit_names_and_collision(self):
        result = transform(self.outer)
        self.assertIn(b'NSWC_EXIT_1 : DO', result)
        self.assertIn(b'EXIT NSWC_EXIT_1', result)
        self.assertIn(b'END DO NSWC_EXIT_1', result)
        collision = self.outer.replace(b'      S=0', b'      INTEGER NSWC_EXIT_1\n      S=0')
        self.assertIn(b'EXIT NSWC_EXIT_2', transform(collision))
        self.assertEqual(transform(result), result)
        free = format_source(lowercase(convert_text(result.decode('ascii'))))
        self.assertEqual(format_source(free), free)
        self.assertIn('   do j', free)
        # A data object can have the same spelling as the END DO keyword.
        self.assertIn('enddo = 1', format_source('enddo=1\n'))
        named = self.outer.replace(b'      DO I=', b'      search: DO I=').replace(b'      END DO\n   20', b'      END DO search\n   20')
        self.assertIn(b'EXIT SEARCH', transform(named))

    def test_outside_reference_keeps_target(self):
        original = self.inner.replace(b'      S=0', b'      S=0\n      IF(N.LT.0) GO TO 20')
        result = transform(original)
        self.assertIn(b'IF(N.LT.0) GO TO 20', result)
        self.assertIn(b'   20 S=S+10', result)
        self.assertIn(b'EXIT', result)

    def test_skipping_code_and_incoming_edges_are_not_converted(self):
        skip = self.inner.replace(b'   20 S=', b'      S=S+100\n   20 S=')
        self.assertEqual(transform(skip), skip)
        incoming = self.inner.replace(b'      DO I=', b'      IF(N.LT.0) GO TO 30\n      DO I=').replace(b'      S=S+I', b'   30 S=S+I')
        self.assertEqual(transform(incoming), incoming)
        continued = self.inner.replace(b'      IF(I.EQ.2) GO TO 20', b'      IF(I.EQ.2)\n     & GO TO 20')
        self.assertEqual(transform(continued), continued)

    def test_indirect_and_concurrent_loops_are_skipped(self):
        for original in (self.inner.replace(b'      S=0', b'      ASSIGN 20 TO J\n      S=0'),
                         self.inner.replace(b'DO I=1,N', b'DO CONCURRENT(I=1:N)')):
            self.assertEqual(transform(original), original)

    def test_block_array_is_not_a_block_construct(self):
        original = self.inner.replace(b'      S=0', b'      REAL BLOCK(1)\n      BLOCK(1)=0\n      S=0')
        self.assertIn(b'EXIT', transform(original))
        block = self.inner.replace(b'      S=0', b'      LOCAL_SCOPE: BLOCK\n      END BLOCK LOCAL_SCOPE\n      S=0')
        self.assertEqual(transform(block), block)

    def test_literals_comments_and_other_target_references(self):
        original = self.inner.replace(b'IF(I.EQ.2)', b"IF('A!B'.EQ.'A!B')")
        original = original.replace(b'GO TO 20\n', b'GO TO 20 ! Leave the loop\n')
        revised = transform(original)
        self.assertIn(b"'A!B'", revised)
        self.assertIn(b'! Leave the loop', revised)
        self.assertEqual(transform(revised), revised)
        # An I/O error branch outside the loop still needs the label.
        original = self.inner.replace(b'      S=0', b'      READ(5,*,ERR=20) S\n      S=0')
        self.assertIn(b'   20 S=S+10', transform(original))

    def test_continued_named_exit_converts_to_free_form(self):
        from simplify_free_style import transform as style
        from modernize_arithmetic_if import emit
        branch = emit('IF ((A(I,J)+B(I,J)).NE.0.0) EXIT NSWC_EXIT_1', '', '      ', '\n')
        # Force a legal keyword/name boundary onto separate fixed-form records.
        branch = branch.replace('EXIT NSWC_EXIT_1', 'EXIT\n     &NSWC_EXIT_1')
        free = convert_text(branch)
        self.assertIn('EXIT NSWC_EXIT_1', free)
        self.assertNotIn('EXITNSWC', style(free))

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_execution_and_compiler_records(self):
        # IF calls a stateful function; the conversion must evaluate it once.
        side = self.inner.replace(b'      S=0', b'      LOGICAL HIT\n      EXTERNAL HIT\n      INTEGER NCALL\n      COMMON /COUNT/ NCALL\n      NCALL=0\n      S=0')
        side = side.replace(b'   20 S=S+10', b'   20 S=S+10\n      J=NCALL')
        side = side.replace(b'IF(I.EQ.2)', b'IF(HIT(I))') + b'''      LOGICAL FUNCTION HIT(I)
      INTEGER I,NCALL
      COMMON /COUNT/ NCALL
      NCALL=NCALL+1
      HIT=I.EQ.2
      END FUNCTION HIT
'''
        driver = b'''      INTEGER N,S,I,J
      DO N=-2,4
      I=-777
      J=-888
      CALL T(N,S,I,J)
      PRINT *,N,S,I,J
      END DO
      END
'''
        for original in (self.inner, self.outer, side):
            revised = transform(original)
            verify(original, revised)
            with tempfile.TemporaryDirectory(prefix='exit-regression-') as work:
                work = Path(work)
                for opt in ('-O0','-O2'):
                    outputs = []
                    for body in (original,revised):
                        (work/'input.f').write_bytes(body+driver)
                        r = subprocess.run(['gfortran',opt,'-fcheck=all','input.f','-o','probe.exe'],cwd=work,capture_output=True,text=True)
                        self.assertEqual(r.returncode,0,r.stderr)
                        r = subprocess.run([str(work/'probe.exe')],cwd=work,capture_output=True,text=True)
                        self.assertEqual(r.returncode,0,r.stderr)
                        outputs.append(r.stdout)
                    self.assertEqual(*outputs)


if __name__ == '__main__':
    unittest.main()
