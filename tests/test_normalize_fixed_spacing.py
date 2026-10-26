"""Parentheses spacing must preserve fixed-form tokens and protected text."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from normalize_fixed_spacing import transform, tighten


class FixedSpacingTests(unittest.TestCase):
    def test_conditions_arrays_and_calls(self):
        self.assertEqual(tighten('   IF ( N .LE. K ( I ) ) EXIT'), '   IF (N .LE. K(I)) EXIT')
        self.assertEqual(tighten('CALL FOO ( A ( I ), ( X + Y ) )'), 'CALL FOO(A(I), (X + Y))')
        self.assertEqual(tighten('IF ( X ) WRITE ( *, * ) A ( I )'), 'IF (X) WRITE (*, *) A(I)')
        self.assertEqual(tighten('DO WHILE ( X ( I ) .GT. 0 )'), 'DO WHILE (X(I) .GT. 0)')
        self.assertEqual(tighten('GO TO ( 10, 20 ), I'), 'GO TO (10, 20), I')

    def test_strings_comments_and_sequence_fields(self):
        line = "  100 IF ( A ( I ) .EQ. '( keep )' ) X ( I ) = 1"
        original = (line + ' ! ( keep )').ljust(72) + 'SEQ12345\r\n'
        revised = transform(original.encode()).decode()
        self.assertEqual(revised[:6], original[:6])
        self.assertEqual(revised[72:], original[72:])
        self.assertEqual(revised.index('!'), original.index('!'))
        self.assertIn("'( keep )'", revised)
        self.assertIn('IF (A(I)', revised)
        self.assertEqual(transform(revised.encode()).decode(), revised)

    def test_continuations_and_protected_statements(self):
        protected = b"C     Keep ( this )\n  100 FORMAT ( '( keep )', 8H( keep ))\n      S = 'first\n     & ( keep )'\n"
        self.assertEqual(transform(protected), protected)
        original = b'      X ( I ) = A ( I ) +\n     & B ( I )\n'
        revised = transform(original)
        self.assertEqual(revised, b'      X(I) = A(I) +\n     & B(I)\n')
        self.assertEqual([r[:6] for r in original.splitlines()], [r[:6] for r in revised.splitlines()])

    def test_workspace_review_accepts_only_the_two_reviewed_layouts(self):
        from periodic_root_workspace import NEW_CALL
        from fixed_to_free import convert_text
        from lowercase_fortran import lowercase
        from format_free_form import format_source, semantic_statements
        from free_source_fixes import correct_root_workspace
        results = []
        for fixed in (NEW_CALL.encode(), transform(NEW_CALL.encode())):
            block = format_source(lowercase(convert_text(fixed.decode())))
            source = ('subroutine compb()\ncomplex, allocatable :: root_complex(:)\n'
                      'real, allocatable :: root_real(:)\n'+block+'end subroutine compb\n')
            results.append(semantic_statements(correct_root_workspace(source)))
            with self.assertRaisesRegex(ValueError, 'needs review'):
                correct_root_workspace(source.replace('nmp', 'nmp+1', 1))
        self.assertEqual(*results)


if __name__ == '__main__':
    unittest.main()
