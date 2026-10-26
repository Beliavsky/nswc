"""Control-flow and fixed-form regression cases for the limited DO converter."""

from contextlib import redirect_stderr, redirect_stdout
import io
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from modernize_do import transform, main
from name_procedure_ends import ConversionError, transform as name_ends
import json
from explicit_typing import apply_manifest, DEFAULT_MANIFEST


def procedure(body, name="S"):
    return (f"      SUBROUTINE {name}\n" + body + f"      END SUBROUTINE {name}\n").encode()


class ModernizeDoTests(unittest.TestCase):
    def test_simple_and_nested_loops(self):
        source = procedure("      DO 10 I=1,N\n      DO 20 J=1,M\n"
                           "      A(I,J)=I+J\n   20 CONTINUE\n   10 CONTINUE\n")
        result = transform(source)
        self.assertEqual([r.status for r in result.loops], ["converted", "converted"])
        self.assertEqual(result.data.count(b"END DO"), 2)
        self.assertEqual(len(source.splitlines()), len(result.data.splitlines()))
        self.assertEqual(transform(result.data).data, result.data)

    def test_zero_negative_and_continued_body(self):
        source = procedure("      DO 10 I=N,1,-1\n      A(I)=B(I)+\n"
                           "     * C(I)\n   10 CONTINUE\n")
        result = transform(source)
        self.assertIn(b"DO I=N,1,-1", result.data)
        self.assertIn(b"     * C(I)", result.data)

    def test_labels_are_scoped_to_procedures(self):
        first = procedure("      DO 10 I=1,N\n   10 CONTINUE\n", "FIRST")
        second = procedure("      GOTO 10\n   10 CONTINUE\n", "SECOND")
        result = transform(first + second)
        self.assertEqual(result.loops[0].status, "converted")
        self.assertTrue(result.data.endswith(second))

    def test_references_to_terminator_are_preserved(self):
        for reference in ("GOTO 10", "IF(X)10,30,40", "GOTO (10,30),I",
                          "READ(5,*,ERR=10)X", "CALL F(*10)"):
            with self.subTest(reference=reference):
                source = procedure("      DO 10 I=1,N\n      " + reference + "\n   10 CONTINUE\n")
                self.assertEqual(transform(source).data, source)

    def test_branch_into_body_is_skipped(self):
        source = procedure("      GOTO 20\n      DO 10 I=1,N\n   20 A=I\n   10 CONTINUE\n")
        result = transform(source)
        self.assertEqual(result.data, source)
        self.assertEqual(result.loops[0].reason, "possible branch into loop body")

    def test_shared_and_executable_terminators_are_skipped(self):
        for body in ("      DO 10 I=1,N\n      DO 10 J=1,M\n   10 CONTINUE\n",
                     "      DO 10 I=1,N\n   10 A(I)=I\n"):
            source = procedure(body)
            self.assertEqual(transform(source).data, source)

    def test_indirect_branches_and_crossing_boundaries_are_skipped(self):
        for body in ("      ASSIGN 20 TO K\n      DO 10 I=1,N\n   10 CONTINUE\n",
                     "      GOTO K\n      DO 10 I=1,N\n   10 CONTINUE\n",
                     "      OUTER: DO I=1,N\n      DO 10 J=1,M\n   10 CONTINUE\n      END DO OUTER\n",
                     "      DO 10 I=1,N\n      DO 20 J=1,M\n   10 CONTINUE\n   20 CONTINUE\n"):
            source = procedure(body)
            self.assertEqual(transform(source).data, source)

    def test_existing_block_loop_nesting(self):
        source = procedure("      DO 10 I=1,N\n      DO J=1,M\n"
                           "      A(I,J)=I+J\n      END DO\n   10 CONTINUE\n")
        result = transform(source)
        self.assertEqual(result.loops[0].status, "converted")
        self.assertEqual(result.data.count(b"END DO"), 2)

    def test_comments_strings_and_numeric_mentions(self):
        source = procedure("C     GOTO 10\n      DO 10 I=1,N ! comment\n"
                           "      PRINT *, '10 ! not a branch'\n   10 CONTINUE ! done\n")
        result = transform(source)
        self.assertEqual(result.loops[0].status, "converted")
        self.assertIn(b"END DO  ! done", result.data)
        ambiguous = procedure("      DO 10 I=1,N\n      K=10\n   10 CONTINUE\n")
        self.assertEqual(transform(ambiguous).data, ambiguous)

    def test_continued_headers_and_do_assignment_are_unchanged(self):
        for body in ("      DO 10 I=1,\n     * N\n   10 CONTINUE\n",
                     "      DO10I=1.10\n   10 CONTINUE\n"):
            source = procedure(body)
            self.assertEqual(transform(source).data, source)

    def test_byte_preservation_and_fixed_fields(self):
        source = procedure("      DO 10 I=1,N\n   10 CONTINUE\n").replace(b"\n", b"\r\n")
        source = source.replace(b"      DO 10 I=1,N\r\n",
                                b"      DO 10 I=1,N".ljust(72) + b"SEQ00001\r\n")
        result = transform(source)
        self.assertIn(b"SEQ00001\r\n", result.data)
        self.assertTrue(all(line.endswith(b"\r\n") for line in result.data.splitlines(True)))
        self.assertEqual(result.data.splitlines()[1][72:], b"SEQ00001")

    def test_malformed_source_is_rejected(self):
        for source in (b"      PROGRAM X\n      END\n",
                       procedure("   10 CONTINUE\n   10 CONTINUE\n"),
                       b"      SUBROUTINE S\n      DO 10 I=1,N\n"):
            with self.assertRaises(ConversionError):
                transform(source)

    def test_cli_dry_run_output_backup_and_report(self):
        with tempfile.TemporaryDirectory() as folder, redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            source = Path(folder) / "source.f"
            output = Path(folder) / "output.f"
            report = Path(folder) / "report.csv"
            original = procedure("      DO 10 I=1,N\n   10 CONTINUE\n")
            source.write_bytes(original)
            self.assertEqual(main([str(source)]), 0)
            self.assertEqual(source.read_bytes(), original)
            self.assertEqual(main([str(source), "--output", str(output), "--report", str(report)]), 0)
            self.assertIn("converted", report.read_text())
            self.assertEqual(main([str(source), "--output", str(output)]), 2)
            self.assertEqual(main([str(source), "--in-place"]), 0)
            self.assertEqual(Path(str(source) + ".loops.bak").read_bytes(), original)
            source.write_bytes(original)
            self.assertEqual(main([str(source), "--in-place"]), 2)

    def test_complete_library_reproduces_maintained_source(self):
        readable = name_ends((ROOT / "nswc_orig.f").read_bytes()).data
        result = transform(readable)
        self.assertEqual(len(result.loops), 4247)
        self.assertEqual(sum(r.status == "converted" for r in result.loops), 2548)
        from reviewed_source_fixes import apply_fixes
        reviewed = apply_manifest(apply_fixes(result.data), json.loads(DEFAULT_MANIFEST.read_text()))
        from argument_intents import apply_intents, DEFAULT_MANIFEST as INTENT_MANIFEST
        if INTENT_MANIFEST.exists():
            reviewed = apply_intents(reviewed, json.loads(INTENT_MANIFEST.read_text()))
        from combine_declarations import transform as combine_declarations
        from order_declarations import transform as order_declarations
        from remove_final_returns import transform_fixed as remove_final_returns
        from periodic_root_workspace import transform_fixed as correct_workspace
        from modernize_deleted_do import transform as modernize_deleted_loops
        from modernize_arithmetic_if import transform as modernize_arithmetic_if
        from modernize_remaining_features import transform as finish_remaining
        from blktri_empty_factors import transform_fixed as correct_empty_factors
        from remove_unused_labels import transform as clean_unused_labels
        from source_comment_fixes import transform_fixed as fix_comments
        from goto_to_exit import transform as convert_exits
        self.assertEqual(convert_exits(fix_comments(clean_unused_labels(correct_empty_factors(finish_remaining(modernize_arithmetic_if(modernize_deleted_loops(correct_workspace(remove_final_returns(order_declarations(combine_declarations(reviewed).data).data))).data)))))),
                         (ROOT / "nswc.f").read_bytes())
        self.assertEqual(transform(result.data).data, result.data)


if __name__ == "__main__":
    unittest.main()
