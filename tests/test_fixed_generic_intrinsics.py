"""Fixed-form generic replacements preserve bindings and physical source fields."""
from pathlib import Path
import shutil
import sys
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from fixed_generic_intrinsics import review, transform

SOURCE = b'''      DOUBLE PRECISION FUNCTION F(X)
      IMPLICIT NONE
      DOUBLE PRECISION, INTENT(IN) :: X
      DOUBLE PRECISION :: DLOG, DEXP
C     DLOG(X) and DEXP(X) are mentioned in this comment.
      F = DLOG(X) + DEXP(X)
      END FUNCTION F
'''

@unittest.skipUnless(shutil.which('gfortran'),'GNU compiler required')
class FixedGenericTests(unittest.TestCase):
    def test_types_declarations_and_idempotence(self):
        manifest = review(SOURCE)
        output = transform(SOURCE,manifest)
        self.assertIn(b'F = LOG(X) + EXP(X)',output)
        self.assertNotIn(b'DOUBLE PRECISION :: DLOG',output)
        self.assertIn(b'C     DLOG(X) and DEXP(X)',output)
        self.assertEqual(transform(output,manifest),output)
        with self.assertRaises(ValueError):
            transform(SOURCE.replace(b'F = DLOG',b'F = 2*DLOG'),manifest)

    def test_literal_comment_label_continuation_and_sequence(self):
        source = SOURCE.replace(b'      F = DLOG(X) + DEXP(X)',
            b"      PRINT *, 'DLOG(X)'\n"+
            b'   10 F = DLOG(X)'.ljust(72)+b'000123\n'+
            b'     & + DEXP(X) ! DEXP remains in this comment')
        output = transform(source,review(source))
        self.assertIn(b"'DLOG(X)'",output)
        self.assertIn(b'   10 F = LOG(X)',output)
        self.assertIn(b'     & + EXP(X)',output)
        old = next(l for l in source.splitlines() if l.startswith(b'   10'))
        new = next(l for l in output.splitlines() if l.startswith(b'   10'))
        self.assertEqual(old[72:],new[72:])
        old = next(l for l in source.splitlines() if b'! DEXP' in l)
        new = next(l for l in output.splitlines() if b'! DEXP' in l)
        self.assertEqual(old.index(b'!'),new.index(b'!'))
        self.assertEqual(old[old.index(b'!'):],new[new.index(b'!'):])

    def test_error_function_library_binding(self):
        source = SOURCE.replace(b'DLOG, DEXP',b'DERF, DERFC').replace(
            b'DLOG(X) + DEXP(X)',b'DERF(X) + DERFC(X)')+b'''      REAL FUNCTION ERF(X)
      REAL :: X
      ERF = X
      END FUNCTION ERF
      REAL FUNCTION ERFC(X)
      REAL :: X
      ERFC = X
      END FUNCTION ERFC
'''
        output = transform(source,review(source))
        self.assertIn(b'INTRINSIC :: ERF, ERFC',output)
        self.assertIn(b'F = ERF(X) + ERFC(X)',output)
        self.assertIn(b'REAL FUNCTION ERF(X)',output)
        mixed = source.replace(b'DOUBLE PRECISION :: DERF, DERFC',b'DOUBLE PRECISION :: DERF, DERFC, R')
        mixed_output = transform(mixed,review(mixed))
        self.assertIn(b'IMPLICIT NONE\n      INTRINSIC :: ERF, ERFC',mixed_output)
        self.assertIn(b'DOUBLE PRECISION :: R',mixed_output)

    def test_conflicting_name_and_procedure_argument(self):
        source = b'''      SUBROUTINE F(X,LOG,Y)
      DOUBLE PRECISION :: X,LOG,Y,DLOG,DEXP
      INTRINSIC :: DLOG, DEXP
      EXTERNAL :: APPLY
      Y = DLOG(X)
      CALL APPLY(DEXP,X,Y)
      END SUBROUTINE F
'''
        manifest = review(source)
        self.assertEqual(manifest['summary']['calls'],0)
        self.assertEqual(transform(source,manifest),source)
        self.assertIn('dlog',manifest['retained']['F'])
        self.assertIn(b'CALL APPLY(DEXP,X,Y)',transform(source,manifest))

    def test_split_identifier_rejected(self):
        source = SOURCE.replace(b'DLOG(X) + DEXP(X)',b'DLO\n     &G(X) + DEXP(X)')
        with self.assertRaises(ValueError):
            review(source)

if __name__ == '__main__':
    unittest.main()
