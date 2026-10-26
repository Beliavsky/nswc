"""Check single evaluation, numeric kinds, branch labels and strict syntax."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from modernize_arithmetic_if import candidates, review, transform, verify


@unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required for type review')
class ArithmeticIfTests(unittest.TestCase):
    source = b'''      INTEGER FUNCTION PICK(X,COUNT)
      IMPLICIT NONE
      REAL X,ONCE
      INTEGER COUNT
      EXTERNAL ONCE
      IF (ONCE(X,COUNT))10,20,30
   10 PICK=-1
      RETURN
   20 PICK=0
      RETURN
   30 PICK=1
      END FUNCTION PICK

      REAL FUNCTION ONCE(X,COUNT)
      IMPLICIT NONE
      REAL X
      INTEGER COUNT
      COUNT=COUNT+1
      ONCE=X
      END FUNCTION ONCE
'''

    def test_single_evaluation_and_recorded_type(self):
        manifest = review(self.source)
        changed = transform(self.source, manifest)
        self.assertEqual(manifest['records'][0]['type'], 'REAL 4')
        self.assertEqual(changed.count(b'ONCE ( X , COUNT )'), 1)
        self.assertIn(b'REAL :: NSWC_AI_R4', changed)
        self.assertEqual(transform(changed, manifest), changed)
        self.assertEqual(candidates(changed)[2], [])
        verify(self.source, changed, manifest)
        for text in (self.source.replace(b'PICK=-1', b'PICK=-2'), changed.replace(b'GO TO 10', b'GO TO 20')):
            with self.assertRaises(ValueError):
                transform(text, manifest)

    def test_comments_continuation_and_original_label(self):
        source = self.source.replace(b'      IF (ONCE(X,COUNT))10,20,30',
                                     b'   40 IF (ONCE(X, ! original comment\nC between records\n     &COUNT))10,20,30')
        manifest = review(source)
        changed = transform(source, manifest)
        self.assertIn(b'   40 NSWC_AI_R4 =', changed)
        self.assertIn(b'! original comment', changed)
        self.assertIn(b'C between records', changed)
        verify(source, changed, manifest)

    def test_integer_and_double_precision_types(self):
        for type_name, expected in [('INTEGER', 'INTEGER 4'), ('DOUBLE PRECISION', 'REAL 8')]:
            source = self.source.replace(b'REAL X,ONCE', type_name.encode() + b' X,ONCE')
            source = source.replace(b'REAL FUNCTION ONCE', type_name.encode() + b' FUNCTION ONCE')
            source = source.replace(b'      REAL X\n', b'      ' + type_name.encode() + b' X\n')
            manifest = review(source)
            self.assertEqual(manifest['records'][0]['type'], expected)
            verify(source, transform(source, manifest), manifest)

    def test_repeated_targets_do_not_need_temporaries(self):
        for labels in (b'10,10,30', b'10,20,20', b'10,20,10'):
            source = self.source.replace(b'10,20,30', labels)
            manifest = review(source)
            self.assertFalse(manifest['declarations'])
            changed = transform(source, manifest)
            self.assertEqual(changed.count(b'ONCE ( X , COUNT )'), 1)
            verify(source, changed, manifest)

    def test_identical_targets_still_evaluate_expression(self):
        source = self.source.replace(b'10,20,30', b'10,10,10')
        manifest = review(source)
        changed = transform(source, manifest)
        self.assertEqual(changed.count(b'ONCE ( X , COUNT )'), 1)
        self.assertIn(b'GO TO 10', changed)
        verify(source, changed, manifest)

    def test_wrapped_branch_preserves_free_form_token_boundary(self):
        source = self.source.replace(b'IF (ONCE(X,COUNT))10,20,30',
            b'IF(ABS(X)+ABS(X)+ABS(X)+ABS(X)+ABS(X))10,10,30')
        manifest = review(source)
        changed = transform(source, manifest)
        from fixed_to_free import convert_text
        free = convert_text(changed.decode())
        self.assertNotRegex(free, r'(?i)\bto\d+')
        with tempfile.TemporaryDirectory(prefix='nswc-branch-wrap-') as work:
            path = Path(work) / 'input.f90'
            path.write_text(free)
            run = subprocess.run(['gfortran', '-std=f2023', '-pedantic-errors', '-fsyntax-only', str(path)],
                                 capture_output=True, text=True, timeout=30)
            self.assertEqual(run.returncode, 0, run.stderr)

    def test_branch_results_special_values_and_side_effects(self):
        with tempfile.TemporaryDirectory(prefix='nswc-arithmetic-if-test-') as work:
            folder = Path(work)
            driver = folder / 'driver.f90'
            driver.write_text('''program probe
use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_positive_inf, ieee_negative_inf
implicit none
real :: x(10)
integer :: i,n,pick
x = [-huge(0.), -1., -tiny(0.), -0., 0., tiny(0.), 1., huge(0.), &
     ieee_value(0.,ieee_positive_inf),ieee_value(0.,ieee_negative_inf)]
do i=1,size(x)
   n=0
   print *,i,pick(x(i),n)
   if (n /= 1) error stop 'expression evaluated more than once'
end do
end program probe
''')
            for labels in (b'10,20,30', b'10,10,30', b'10,20,20', b'10,20,10', b'10,10,10'):
                source = self.source.replace(b'10,20,30', labels)
                changed = transform(source, review(source))
                for optimization in ('-O0', '-O2'):
                    outputs = []
                    for data, standard in ((source, '-std=legacy'), (changed, '-std=f2023')):
                        library = folder / 'library.f'
                        library.write_bytes(data)
                        result = subprocess.run(['gfortran', optimization, standard, str(library), str(driver), '-o', 'probe.exe'],
                                                cwd=work, capture_output=True, text=True, timeout=60)
                        self.assertEqual(result.returncode, 0, result.stderr)
                        run = subprocess.run([str(folder / 'probe.exe')], capture_output=True, text=True, timeout=10)
                        self.assertEqual(run.returncode, 0, run.stderr)
                        outputs.append(run.stdout)
                    self.assertEqual(*outputs)
