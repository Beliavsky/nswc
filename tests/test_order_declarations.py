"""Argument grouping must preserve dependencies, external attributes and comments."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from order_declarations import transform
from name_procedure_ends import ConversionError
from name_procedure_ends import statements
from explicit_typing import units
from combine_declarations import type_declaration, split_list


class DeclarationOrderingTests(unittest.TestCase):
    def test_arguments_and_mixed_declarations(self):
        source = (b'      SUBROUTINE S(N,X)\n      IMPLICIT NONE\n'
                  b'      INTEGER :: LOCAL, N\n      REAL :: WORK\n'
                  b'C     Description stays intact.\n'
                  b'      REAL, INTENT(INOUT) :: X(N)\n'
                  b'      X(1) = WORK + LOCAL\n      END SUBROUTINE S\n')
        r = transform(source)
        self.assertLess(r.data.index(b':: N'), r.data.index(b':: X(N)'))
        self.assertLess(r.data.index(b':: X(N)'), r.data.index(b':: LOCAL'))
        self.assertIn(b'      X(1) = WORK + LOCAL\n', r.data)
        self.assertIn(b'C     Description stays intact.\n', r.data)
        self.assertEqual(r.mixed_declarations_split, 1)
        self.assertEqual(transform(r.data).data, r.data)

    def test_local_common_bound_dependency(self):
        source = (b'      SUBROUTINE S(X)\n      IMPLICIT NONE\n'
                  b'      INTEGER :: UNRELATED, N\n      REAL :: X(N)\n'
                  b'      COMMON /SIZE/ N\n      END SUBROUTINE S\n')
        r = transform(source)
        # The local group supplies N, so it must still precede X's bound.
        self.assertLess(r.data.index(b':: UNRELATED, N'), r.data.index(b':: X(N)'))
        self.assertEqual(r.prerequisite_locals[0]['locals'], ['N', 'UNRELATED'])

    def test_mixed_external_callback_declarations(self):
        source = (b'      SUBROUTINE S(F,N)\n      IMPLICIT NONE\n'
                  b'      INTEGER :: LOCAL, N\n      REAL :: F, G\n'
                  b'      EXTERNAL F, G\n      END SUBROUTINE S\n')
        r = transform(source)
        self.assertLess(r.data.index(b'EXTERNAL F\n'), r.data.index(b':: LOCAL'))
        self.assertLess(r.data.index(b':: LOCAL'), r.data.index(b'EXTERNAL G\n'))
        self.assertEqual(transform(r.data).data, r.data)

    def test_parameter_between_types_requires_review(self):
        source = (b'      SUBROUTINE S(X)\n      IMPLICIT NONE\n'
                  b'      INTEGER :: N\n      PARAMETER (N=3)\n'
                  b'      REAL :: X(N)\n      END SUBROUTINE S\n')
        with self.assertRaisesRegex(ConversionError, 'intervening specification'):
            transform(source)

    def test_separate_dimension_keeps_parameter_order(self):
        source = (b'      SUBROUTINE S(X)\r\n      IMPLICIT NONE\r\n'
                  b'      INTEGER :: N\r\n      REAL :: X\r\n'
                  b'      PARAMETER (N=3)\r\n      DIMENSION X(N)\r\n'
                  b'      END SUBROUTINE S\r\n')
        r = transform(source)
        self.assertLess(r.data.index(b':: X'), r.data.index(b':: N'))
        self.assertIn(b'PARAMETER (N=3)\r\n      DIMENSION X(N)', r.data)
        self.assertEqual(len(r.retained_dimensions), 1)
        self.assertNotIn(b'\n', r.data.replace(b'\r\n', b''))

    def test_inline_comment_requires_review(self):
        source = (b'      SUBROUTINE S(N)\n      IMPLICIT NONE\n'
                  b'      INTEGER :: N ! Keep with N\n      END SUBROUTINE S\n')
        with self.assertRaisesRegex(ConversionError, 'annotated'):
            transform(source)

    def test_complete_library_has_no_argument_types_after_local_types(self):
        root = Path(__file__).resolve().parents[1]
        data = (root / 'nswc.f').read_bytes()
        lines, scopes = units(data)
        for name, (start, _, end) in scopes.items():
            body = list(statements(lines[start:end]))
            header = body[0].code
            args = {n.strip().upper() for n in header[header.index('(') + 1:header.rindex(')')].split(',')} if '(' in header else set()
            local_seen = False
            for s in body[1:]:
                decl = type_declaration(s.code)
                if decl:
                    entities = [n.upper() for n, _, _ in decl[2]]
                elif s.code.strip().upper().startswith('EXTERNAL '):
                    entities = [n.strip().upper() for n in split_list(s.code.strip()[9:])]
                else:
                    continue
                for entity in entities:
                    if entity in args:
                        self.assertFalse(local_seen, f'{name}: argument {entity} follows local declarations')
                    else:
                        local_seen = True
        self.assertEqual(transform(data).data, data)


if __name__ == '__main__':
    unittest.main()
