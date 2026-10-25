"""Reviewed declarations, stale-manifest protection, and compiler dump parsing."""

from contextlib import redirect_stdout, redirect_stderr
import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from explicit_typing import apply_manifest, analyze, digest, parse_declarations, units, main
from name_procedure_ends import ConversionError
from validate_explicit_typing import symbols, scope_preserved


def manifest_for(source, declarations=None):
    return {"procedures": {"S": {"sha256": digest(source),
                                "declarations": declarations or ["      INTEGER I"]}}}


class ExplicitTypingTests(unittest.TestCase):
    source = b"      SUBROUTINE S(I)\n      I=I+1\n      END SUBROUTINE S\n"

    def test_insert_and_idempotence(self):
        manifest = manifest_for(self.source)
        changed = apply_manifest(self.source, manifest)
        self.assertEqual(changed, self.source.replace(b"      I=I+1", b"      IMPLICIT NONE\n      INTEGER I\n      I=I+1"))
        self.assertEqual(apply_manifest(changed, manifest), changed)

    def test_rejects_changed_bodies_and_manifest_declarations(self):
        manifest = manifest_for(self.source)
        with self.assertRaisesRegex(ConversionError, "changed"):
            apply_manifest(self.source.replace(b"I+1", b"I+2"), manifest)
        for declaration in ("      SAVE", "      REAL " + "X"*70, "      REAL X\n      STOP"):
            with self.assertRaises(ConversionError):
                apply_manifest(self.source, manifest_for(self.source, [declaration]))

    def test_existing_implicit_rules_are_not_overridden(self):
        source = self.source.replace(b"      I=I+1", b"      IMPLICIT REAL(A-Z)\n      I=I+1")
        with self.assertRaisesRegex(ConversionError, "Existing IMPLICIT"):
            apply_manifest(source, manifest_for(source))

    def test_multiline_header_and_preserved_crlf(self):
        source = self.source.replace(b"S(I)", b"S(\n     * I)").replace(b"\n", b"\r\n")
        changed = apply_manifest(source, manifest_for(source))
        self.assertIn(b"     * I)\r\n      IMPLICIT NONE\r\n", changed)
        self.assertTrue(all(line.endswith(b"\r\n") for line in changed.splitlines(True)))

    def test_declaration_sections_and_continuations(self):
        text = ("C====>Begin Module S File trial.f\nC Comment\n      INTEGER I,\n"
                "     x J\nC====>End Module S File trial.f\n")
        self.assertEqual(parse_declarations(text), {"S": ["      INTEGER I,", "     x J"]})

    def test_analyze_uses_selected_procedures_and_missing_only_options(self):
        def fake_run(command, cwd, **kwargs):
            self.assertIn("undeclared-only", command[3])
            self.assertEqual((Path(cwd)/"trial.f").read_bytes(), self.source)
            (Path(cwd)/"trial.dcl").write_text(
                "C====>Begin Module S File trial.f\n      INTEGER I\nC====>End Module S File trial.f\n")
            return subprocess.CompletedProcess(command, 0, "FTNCHEK", "")
        with patch("explicit_typing.subprocess.run", side_effect=fake_run):
            manifest, log = analyze(self.source, {"S"}, "ftnchek")
        self.assertEqual(manifest["procedures"]["S"]["declarations"], ["      INTEGER I"])

    def test_cli_preview_and_safe_output_backup(self):
        with tempfile.TemporaryDirectory() as folder, redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            source = Path(folder)/"source.f"
            output = Path(folder)/"output.f"
            manifest = Path(folder)/"manifest.json"
            source.write_bytes(self.source)
            manifest.write_text(json.dumps(manifest_for(self.source)))
            args = ["apply", str(source), "--manifest", str(manifest)]
            self.assertEqual(main(args), 0)
            self.assertEqual(source.read_bytes(), self.source)
            self.assertEqual(main(args + ["--output", str(output)]), 0)
            self.assertEqual(main(args + ["--output", str(output)]), 2)
            self.assertEqual(main(args + ["--in-place"]), 0)
            self.assertEqual(Path(str(source)+".implicit.bak").read_bytes(), self.source)
            source.write_bytes(self.source)
            self.assertEqual(main(args + ["--in-place"]), 2)

    def test_compiler_symbol_inventory_preserves_real_functions(self):
        text = """procedure name = s
  symtree: 'x' || symbol: 'x'
    type spec : (REAL 8)
    attributes: (VARIABLE IMPLICIT-TYPE DUMMY)
    Array spec:(1 [0] AS_EXPLICIT 1 3 )
  symtree: 'f' || symbol: 'f'
    type spec : (REAL 4)
    attributes: (PROCEDURE EXTERNAL-PROC DUMMY FUNCTION)
  symtree: 'sin' || symbol: 'sin'
    type spec : (REAL 4)
    attributes: (PROCEDURE INTRINSIC-PROC FUNCTION)
"""
        first = symbols(text)
        second = symbols(text.replace("IMPLICIT-TYPE ", ""))
        self.assertEqual(first, second)
        self.assertEqual(set(first["S"]), {"x", "f"})
        self.assertNotEqual(first, symbols(text.replace("REAL 8", "REAL 4")))

    def test_reviewed_forwarded_subroutine_classification(self):
        before = {"jac": {"type spec": "type spec : (UNKNOWN 0)",
                          "attributes": "attributes: (PROCEDURE EXTERNAL DUMMY)"}}
        after = {"jac": {**before["jac"],
                         "attributes": "attributes: (PROCEDURE EXTERNAL DUMMY SUBROUTINE)"}}
        self.assertFalse(scope_preserved(before, after))
        self.assertTrue(scope_preserved(before, after, ["jac"]))
        self.assertTrue(scope_preserved(before, before, ["jac"]))
        self.assertEqual(after["jac"]["attributes"],
                         "attributes: (PROCEDURE EXTERNAL DUMMY SUBROUTINE)")
        for field, value in (("type spec", "type spec : (REAL 4)"),
                             ("Array spec", "Array spec: (1 [0] AS_EXPLICIT 1 3)"),
                             ("attributes", "attributes: (PROCEDURE EXTERNAL SUBROUTINE)")):
            changed = {"jac": {**after["jac"], field: value}}
            self.assertFalse(scope_preserved(before, changed, ["jac"]))
        typed = {"jac": {**before["jac"], "type spec": "type spec : (REAL 4)"}}
        self.assertFalse(scope_preserved(typed, after, ["jac"]))
        self.assertFalse(scope_preserved(before, {**after, "extra": {}}, ["jac"]))

    def test_reviewed_function_resolution_requires_original_return_type(self):
        before = {"f": {"type spec": "type spec : (UNKNOWN 0)",
                        "attributes": "attributes: (PROCEDURE EXTERNAL DUMMY)"}}
        after = {"f": {"type spec": "type spec : (REAL 4)",
                       "attributes": "attributes: (PROCEDURE EXTERNAL DUMMY FUNCTION)"}}
        expected = {"f": "type spec : (REAL 4)"}
        self.assertFalse(scope_preserved(before, after))
        self.assertTrue(scope_preserved(before, after, reviewed_functions=expected))
        self.assertTrue(scope_preserved(after, after, reviewed_functions=expected))
        for field, value in (("type spec", "type spec : (REAL 8)"),
                             ("attributes", "attributes: (PROCEDURE EXTERNAL FUNCTION)"),
                             ("Formal arglist", "Formal arglist: x y")):
            changed = {"f": {**after["f"], field: value}}
            self.assertFalse(scope_preserved(before, changed, reviewed_functions=expected))
        self.assertFalse(scope_preserved(after, before, reviewed_functions=expected))


if __name__ == "__main__":
    unittest.main()
