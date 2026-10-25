"""Readable prose without changing code, literals, math, tables or references."""
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from sentence_case_comments import sentence_case


class CommentCaseTests(unittest.TestCase):
    def test_sentences_continue_across_physical_lines(self):
        source = '!     THIS ROUTINE COMPUTES THE VALUE OF THE\n!     FUNCTION. IT IS ASSUMED THAT THE INPUT IS VALID.\n'
        self.assertEqual(sentence_case(source).text,
                         '!     This routine computes the value of the\n!     function. It is assumed that the input is valid.\n')

    def test_numeric_sentence_end_and_article_versus_symbol(self):
        source = '!     SET COLUMN 1. (ALL OTHER COLUMNS ARE IGNORED.)\n!\n!     USE A MATRIX WITH BASE-A DIGITS.\n'
        self.assertEqual(sentence_case(source).text,
                         '!     Set column 1. (All other columns are ignored.)\n!\n!     Use a matrix with base-A digits.\n')

    def test_proper_names_acronyms_and_existing_capitalization(self):
        source = '!     COMPUTE THE BESSEL FUNCTION USING LINPACK AND IEEE ARITHMETIC.\n!\n!     Already correct MixedCase.\n'
        self.assertEqual(sentence_case(source).text,
                         '!     Compute the Bessel function using LINPACK and IEEE arithmetic.\n!\n!     Already correct MixedCase.\n')

    def test_computer_names_and_math_symbols_in_prose(self):
        source = '!     MACHINE CONSTANTS FOR THE AT&T AND DATA GENERAL COMPUTERS.\n!\n!     THE MATRIX A GIVES THE RESULT.\n'
        self.assertEqual(sentence_case(source).text,
                         '!     Machine constants for the AT&T and Data General computers.\n!\n!     The matrix A gives the result.\n')
        self.assertEqual(sentence_case('! IF ARC  (JL,JR) IS IN THE GRAPH, REMOVE IT.\n').text,
                         '! If arc  (JL,JR) is in the graph, remove it.\n')

    def test_code_inline_comments_quoted_text_and_directives_unchanged(self):
        source = '''!$OMP PARALLEL
!DEC$ ATTRIBUTES ALIAS: 'NAME' :: NAME
!GCC$ ATTRIBUTES NO_ARG_CHECK :: NAME
!     CALL FCN(N,X,FVEC)
!     INTEGER N
!     REAL X(N)
!     DATA X /1.0/
!     IMPLICIT NONE
!     Y = X**N
!     COLUMN     VALUE     MEANING
call f('MiXed') ! KEEP INLINE COMMENT
'''
        expected = source
        for code in ('CALL FCN(N,X,FVEC)', 'INTEGER N', 'REAL X(N)', 'DATA X /1.0/',
                     'IMPLICIT NONE', 'Y = X**N'):
            expected = expected.replace(code, code.lower())
        self.assertEqual(sentence_case(source).text, expected)

    def test_scoped_identifiers_and_commented_literals(self):
        source = '''subroutine example(n, answer)
integer :: n, answer, a
!     The argument N gives the size. The variable ANSWER contains the result.
!     CALL EXAMPLE(N, ANSWER)
!     DATA ANSWER /4HMiXe/
!     WRITE(*,*) 'Keep ''Quoted'' TEXT', ANSWER
! 10  CONTINUE
!     Machine constants for the Data General computers.
!     A normal distribution is used.
!     WRITTEN BY A.H. MORRIS.
end subroutine example
subroutine other()
!     N is a mathematical symbol here.
end subroutine other
'''
        result = sentence_case(source).text
        self.assertIn('The argument n gives the size. The variable answer contains the result.', result)
        self.assertIn('call example(n, answer)', result)
        self.assertIn('data answer /4HMiXe/', result)
        self.assertIn("write(*,*) 'Keep ''Quoted'' TEXT', answer", result)
        self.assertIn('! 10  continue', result)
        self.assertIn('Data General computers.', result)
        self.assertIn('A normal distribution is used.', result)
        self.assertIn('A.H. MORRIS.', result)
        self.assertIn('!     N is a mathematical symbol here.', result)
        self.assertEqual(sentence_case(result).text, result)

    def test_reference_paragraphs_and_author_names_unchanged(self):
        source = '!     WRITTEN BY A.H. MORRIS.\n!     FROM THE BOOK ON LINEAR EQUATIONS.\n'
        result = sentence_case(source)
        self.assertEqual(result.text, source)
        self.assertEqual(result.retained['reference/author/history paragraph'], 2)

    def test_unfamiliar_words_are_retained_and_reported(self):
        result = sentence_case('!     THIS ROUTINE COMPUTES THE ZZZUNREVIEWED VALUE.\n')
        self.assertIn('ZZZUNREVIEWED', result.text)
        self.assertIn('ZZZUNREVIEWED', result.unknown)
        self.assertEqual(result.unknown['ZZZUNREVIEWED']['first_line'], 1)

    def test_case_only_layout_and_idempotence(self):
        source = "!     THIS IS A POSITIVE NUMBER.\r\n\r\nprint *, 'Quoted ! VALUE'\r\n!     NEXT VALUE"
        result = sentence_case(source)
        self.assertEqual(len(result.text), len(source))
        self.assertTrue(all(a == b or a.lower() == b.lower() for a,b in zip(source, result.text)))
        self.assertEqual(sentence_case(result.text).text, result.text)
        self.assertIn("print *, 'Quoted ! VALUE'\r\n", result.text)


if __name__ == '__main__':
    unittest.main()
