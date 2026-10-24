"""Run with: python -m unittest discover -s tests -v"""

from contextlib import redirect_stderr, redirect_stdout
import io
from pathlib import Path
import re
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from name_procedure_ends import ConversionError, main, transform


class ProcedureEndsTests(unittest.TestCase):
    def test_typed_function_and_subroutine_with_comment_header(self):
        source = (b"      INTEGER FUNCTION F(I)\n      F=I\n      END\n"
                  b"C next procedure\n      SUBROUTINE S\n      END\n")
        result = transform(source)
        self.assertEqual(result.data, (
            b"      INTEGER FUNCTION F(I)\n      F=I\n      END FUNCTION F\n\n"
            b"C next procedure\n      SUBROUTINE S\n      END SUBROUTINE S\n"))
        self.assertEqual((result.procedures, result.endings_changed, result.blank_lines_added), (2, 2, 1))

    def test_continued_header_and_embedded_keyword_spaces(self):
        source = (b"      DOUBLE PRECISION FUN\nC interleaved comment\n"
                  b"     +CTION LONG_NAME(X)\n      END\n")
        self.assertIn(b"END FUNCTION LONG_NAME", transform(source).data)

    def test_strings_inline_comments_and_block_endings(self):
        source = (b"      CHARACTER*(*) FUNCTION word()\n"
                  b"      PRINT *, 'DON''T!;END', \"END SUBROUTINE\"\n"
                  b"      IF (.TRUE.) THEN\n      END IF\n"
                  b"      END ! keep this\n")
        result = transform(source)
        self.assertIn(b"END FUNCTION word  ! keep this", result.data)
        self.assertIn(b"      END IF\n", result.data)
        self.assertIn(b"'DON''T!;END'", result.data)

    def test_labels_and_sequence_columns(self):
        end = b"  900 END".ljust(72) + b"00001234\r\n"
        result = transform(b"      SUBROUTINE S\r\n" + end)
        self.assertEqual(result.data.splitlines()[-1],
                         b"  900 END SUBROUTINE S".ljust(72) + b"00001234")
        self.assertNotIn(b"\n", result.data.replace(b"\r\n", b""))

    def test_preserves_comment_bytes_and_missing_final_newline(self):
        source = b"C non-ASCII byte: \xe9\n      FUNCTION F()\n      END"
        self.assertEqual(transform(source).data,
                         b"C non-ASCII byte: \xe9\n      FUNCTION F()\n      END FUNCTION F")

    def test_existing_names_and_blank_lines_are_idempotent(self):
        source = (b"      REAL*8 FUNCTION F(X)\n      END FUNCTION F\n\n\n"
                  b"      SUBROUTINE S\n      ENDSUBROUTINES\n")
        result = transform(source)
        self.assertEqual(result.data, source)
        self.assertEqual((result.endings_changed, result.blank_lines_added), (0, 0))

    def test_unnamed_explicit_ending_gets_name(self):
        result = transform(b"      FUNCTION F()\n      END FUNCTION\n")
        self.assertIn(b"END FUNCTION F\n", result.data)

    def test_malformed_boundaries_fail(self):
        for source in [b"      END\n", b"      SUBROUTINE S\n",
                       b"      SUBROUTINE S\n      SUBROUTINE T\n      END\n",
                       b"      SUBROUTINE S\n      END FUNCTION S\n",
                       b"      SUBROUTINE S\n      END SUBROUTINE T\n"]:
            with self.subTest(source=source), self.assertRaises(ConversionError):
                transform(source)

    def test_unsupported_forms_fail(self):
        for source in [b"\tSUBROUTINE S\n", b"      PROGRAM P\n      END\n",
                       b"#ifdef TEST\n", b"     +SUBROUTINE S\n",
                       b"      SUBROUTINE S\n      CONTAINS\n",
                       b"      SUBROUTINE S\n      CALL F; END\n"]:
            with self.subTest(source=source), self.assertRaises(ConversionError):
                transform(source)

    def test_line_length_overflow_fails(self):
        with self.assertRaisesRegex(ConversionError, "column 72"):
            transform(b"      SUBROUTINE " + b"A" * 60 + b"\n      END\n")

    def test_cli_preview_output_and_backup(self):
        with tempfile.TemporaryDirectory() as folder, redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            source = Path(folder) / "input.f"
            output = Path(folder) / "output.f"
            original = b"      SUBROUTINE S\n      END\n"
            source.write_bytes(original)
            self.assertEqual(main([str(source)]), 0)
            self.assertEqual(source.read_bytes(), original)
            self.assertEqual(main([str(source), "-o", str(output)]), 0)
            self.assertIn(b"END SUBROUTINE S", output.read_bytes())
            self.assertEqual(main([str(source), "-o", str(output)]), 2)
            self.assertEqual(source.read_bytes(), original)
            self.assertEqual(main([str(source), "--in-place"]), 0)
            self.assertEqual(Path(str(source) + ".bak").read_bytes(), original)
            source.write_bytes(original)
            self.assertEqual(main([str(source), "--in-place"]), 2)
            self.assertEqual(source.read_bytes(), original)

    def test_invalid_input_never_creates_output(self):
        with tempfile.TemporaryDirectory() as folder, redirect_stderr(io.StringIO()):
            source = Path(folder) / "bad.f"
            output = Path(folder) / "output.f"
            source.write_bytes(b"      SUBROUTINE S\n")
            self.assertEqual(main([str(source), "-o", str(output)]), 2)
            self.assertFalse(output.exists())

    def test_complete_nswc_library(self):
        source = (ROOT / "nswc_orig.f").read_bytes()
        result = transform(source)
        self.assertEqual(result.procedures, 1062)
        self.assertEqual(result.endings_changed, 1062)
        self.assertEqual(len(re.findall(rb"(?m)^ {6,}END (?:FUNCTION|SUBROUTINE) \w+\r?$", result.data)), 1062)
        self.assertEqual(transform(result.data).data, result.data)
        # All nonblank lines other than procedure endings must be byte-identical.
        before = [line for line in source.splitlines() if line.strip() and line.strip() != b"END"]
        after = [line for line in result.data.splitlines()
                 if line.strip() and not re.match(rb"^ {6,}END (?:FUNCTION|SUBROUTINE) \w+$", line)]
        self.assertEqual(before, after)


if __name__ == "__main__":
    unittest.main()
