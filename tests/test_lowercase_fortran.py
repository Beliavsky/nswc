"""Case conversion must preserve literals, comments and physical source layout."""
from contextlib import redirect_stdout, redirect_stderr
import io
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from lowercase_fortran import lowercase, main


class LowercaseTests(unittest.TestCase):
    def test_code_and_mixed_case_names_with_preserved_literals_and_comments(self):
        source = '''PROGRAM Mixed_Name
! Keep THIS comment.
  PRINT *, 'Keep ! MiXed text', "A 'Quote'", 'DON''T change' ! Inline COMMENT
  X=1.0D+02; CALL Mixed_Proc(X)
END PROGRAM Mixed_Name
'''
        expected = '''program mixed_name
! Keep THIS comment.
  print *, 'Keep ! MiXed text', "A 'Quote'", 'DON''T change' ! Inline COMMENT
  x=1.0d+02; call mixed_proc(x)
end program mixed_name
'''
        self.assertEqual(lowercase(source), expected)
        self.assertEqual(lowercase(expected), expected)

    def test_continued_literal_and_intervening_comment_and_blank_lines(self):
        source = 'PRINT *, "AbC&\n! Keep Comment\n\n   &!DEF" ! Comment\nCALL S(X)\n'
        expected = 'print *, "AbC&\n! Keep Comment\n\n   &!DEF" ! Comment\ncall s(x)\n'
        self.assertEqual(lowercase(source), expected)

    def test_layout_tabs_crlf_unicode_and_missing_final_newline(self):
        source = "\tPRINT *, 'École'  ! Café\r\n\r\n\r\nCALL MiXeD"
        self.assertEqual(lowercase(source), "\tprint *, 'École'  ! Café\r\n\r\n\r\ncall mixed")
        self.assertEqual(lowercase(''), '')
        self.assertEqual(lowercase('CALL S'), 'call s')
        self.assertEqual(lowercase('CALL S ! Keep\x85UPPER\n'), 'call s ! Keep\x85UPPER\n')

    def test_invalid_and_unsupported_input_fails_closed(self):
        for source in ['PRINT *, 4HABCD\n', '#define NAME VALUE\n', "PRINT *, 'bad\n",
                       "PRINT *, 'bad&\n", "PRINT *, 'bad&\nNEXT'\n"]:
            with self.subTest(source=source), self.assertRaises(ValueError):
                lowercase(source)
        self.assertEqual(lowercase("! 4HABCD\nPRINT *, '4HABCD'\n"), "! 4HABCD\nprint *, '4HABCD'\n")

    def test_cli_preserves_bytes_and_refuses_overwrite_or_partial_output(self):
        with tempfile.TemporaryDirectory() as folder, redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            source, output = [Path(folder) / n for n in ('input.f90', 'output.f90')]
            original = b"PRINT *, 'MiXed' ! Caf\xe9\r\n"
            source.write_bytes(original)
            self.assertEqual(main([str(source), '--output', str(output)]), 0)
            self.assertEqual(source.read_bytes(), original)
            self.assertEqual(output.read_bytes(), b"print *, 'MiXed' ! Caf\xe9\r\n")
            self.assertEqual(main([str(source), '--output', str(output)]), 2)
            output.unlink()
            source.write_bytes(b'PRINT *, 4HABCD\n')
            self.assertEqual(main([str(source), '--output', str(output)]), 2)
            self.assertFalse(output.exists())


if __name__ == '__main__':
    unittest.main()
