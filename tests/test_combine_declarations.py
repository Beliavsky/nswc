"""Declaration formatting: scope, specification order, comments, and safe writes."""
from contextlib import redirect_stdout, redirect_stderr
import io
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from combine_declarations import transform, main, split_list


def source(declarations):
    return ('      SUBROUTINE S(N,X,Y)\n      IMPLICIT NONE\n' + declarations +
            '      CALL WORK(N,X,Y)\n      END SUBROUTINE S\n').encode('ascii')


class CombineDeclarationTests(unittest.TestCase):
    def test_scalar_example_and_idempotence(self):
        original = b'      INTEGER FUNCTION IPMPAR(I)\n      IMPLICIT NONE\n      INTENT(IN) I\n      INTEGER I\n      IPMPAR=I\n      END FUNCTION IPMPAR\n'
        result = transform(original)
        self.assertIn(b'      INTEGER, INTENT(IN) :: I\n', result.data)
        self.assertEqual(result.intents_combined, 1)
        self.assertEqual(transform(result.data).data, result.data)
        self.assertIn(b'      IPMPAR=I\n', result.data)

    def test_different_intents_split_without_reordering(self):
        result = transform(source('      INTENT(IN) N,Y\n      INTENT(OUT) X\n      INTEGER N,X,Y\n'))
        self.assertIn(b'INTEGER, INTENT(IN) :: N\n      INTEGER, INTENT(OUT) :: X\n      INTEGER, INTENT(IN) :: Y', result.data)
        self.assertNotIn(b'      INTENT(', result.data)

    def test_dimensions_and_existing_attributes(self):
        result = transform(source('      INTEGER N\n      INTENT(INOUT) X\n      REAL, TARGET :: X,Y\n      DIMENSION X(N),Y(3)\n'))
        self.assertIn(b'REAL, TARGET, INTENT(INOUT) :: X(N)', result.data)
        self.assertIn(b'REAL, TARGET :: Y(3)', result.data)
        self.assertEqual(result.dimensions_combined, 2)
        self.assertNotIn(b'      DIMENSION', result.data)

    def test_later_parameter_and_type_dependencies_stay_in_place(self):
        result = transform(source('      REAL X,Y\n      INTEGER N,K\n      PARAMETER(K=3)\n      DIMENSION X(N),Y(K)\n'))
        self.assertEqual(result.dimensions_combined, 0)
        self.assertIn(b'      DIMENSION X(N),Y(K)\n', result.data)
        self.assertEqual(len(result.reviews), 2)
        # A typed parameter whose value is defined later is also retained.
        result = transform(source('      INTEGER K\n      REAL X\n      PARAMETER(K=3)\n      DIMENSION X(K)\n'))
        self.assertIn(b'      DIMENSION X(K)', result.data)

    def test_partial_dimension_merge_keeps_unresolved_entities(self):
        result = transform(source('      INTEGER N\n      REAL X,Y\n      INTEGER K\n      DIMENSION X(N),Y(K)\n'))
        self.assertIn(b'REAL :: X(N), Y', result.data)
        self.assertIn(b'      DIMENSION Y(K)', result.data)
        self.assertEqual(result.dimensions_combined, 1)

    def test_comments_between_continuations_and_inline_comments_survive(self):
        original = source('      INTENT(IN) N ! Keep intent explanation\n      INTEGER N, ! First type comment\nC Keep this full comment\n     & X,Y ! Keep type explanation\n')
        result = transform(original)
        for text in [b'! Keep intent explanation', b'C Keep this full comment\n', b'! Keep type explanation']:
            self.assertEqual(result.data.count(text), 1)
        self.assertIn(b'      CALL WORK(N,X,Y)\n', result.data)
        self.assertLess(result.data.index(b'! First type comment'), result.data.index(b'C Keep this full comment'))
        self.assertLess(result.data.index(b'C Keep this full comment'), result.data.index(b'! Keep type explanation'))
        self.assertEqual(transform(result.data).data, result.data)

    def test_wrapping_crlf_and_scope_isolation(self):
        declarations = ('      INTENT(IN) N\n      INTENT(INOUT) X,Y\n      INTEGER N\n      DOUBLE PRECISION X(123456789,123456789),\n'
                        '     & Y(123456789,123456789)\n')
        original = source(declarations).replace(b'\n', b'\r\n')
        other = b'      SUBROUTINE T(N)\r\n      INTEGER N\r\n      END SUBROUTINE T\r\n'
        result = transform(original + other)
        self.assertTrue(all(len(line) <= 72 for line in result.data.splitlines()))
        self.assertTrue(all(line.endswith(b'\r\n') for line in result.data.splitlines(True)))
        self.assertIn(b'      INTEGER :: N\r\n      END SUBROUTINE T', result.data)
        self.assertIn(b'     &', result.data)

    def test_unsupported_initializers_and_sequence_fields_are_retained(self):
        for declaration in ['      REAL :: X = 1.0\n', '      REAL X'.ljust(72) + 'SEQ001\n']:
            result = transform(source('      INTENT(IN) X\n' + declaration))
            self.assertIn(declaration.encode('ascii'), result.data)
            self.assertIn(b'      INTENT(IN) X\n', result.data)
            self.assertEqual(result.intents_combined, 0)
            self.assertTrue(result.reviews)
        self.assertEqual(split_list("a(1,max(2,n)), b('X,''Y,Z'), c"), ["a(1,max(2,n))", "b('X,''Y,Z')", 'c'])

    def test_cli_preview_and_nonoverwriting_destinations(self):
        with tempfile.TemporaryDirectory() as directory, redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            path, output, report = [Path(directory) / name for name in ('input.f', 'output.f', 'report.json')]
            original = source('      INTENT(IN) N\n      INTEGER N\n')
            path.write_bytes(original)
            self.assertEqual(main([str(path)]), 0)
            self.assertEqual(path.read_bytes(), original)
            self.assertEqual(main([str(path), '--output', str(output), '--report', str(report)]), 0)
            self.assertEqual(main([str(path), '--output', str(output)]), 2)
            self.assertEqual(main([str(path), '--in-place', '--report', str(report)]), 2)
            self.assertEqual(path.read_bytes(), original)
            self.assertEqual(main([str(path), '--in-place']), 0)
            self.assertEqual(Path(str(path) + '.declarations.bak').read_bytes(), original)


if __name__ == '__main__':
    unittest.main()
