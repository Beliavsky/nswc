"""Input proof dependencies, replay protection, and compiler intent checks."""

import copy
import sys
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from argument_intents import apply_intents, call_dependencies, intent_lines, invocations, normalize_intents, prove_inputs
from explicit_typing import digest
from name_procedure_ends import ConversionError


class ArgumentIntentTests(unittest.TestCase):
    source = (b"      SUBROUTINE S(N,X)\n      IMPLICIT NONE\n"
              b"      INTEGER N\n      REAL X(N)\n      X(N)=1\n      END SUBROUTINE S\n")

    def manifest(self, source=None):
        source = self.source if source is None else source
        return {"input_sha256": digest(source), "procedures": {
            "S": {"sha256": digest(source), "arguments": {"N": "IN"}}}}

    def test_replay_preserves_source_and_is_idempotent(self):
        manifest = self.manifest()
        changed = apply_intents(self.source, manifest)
        self.assertEqual(changed.replace(b"      INTENT(IN) N\n", b""), self.source)
        self.assertEqual(apply_intents(changed, manifest), changed)
        self.assertEqual(apply_intents(changed, manifest, strip=True), self.source)
        self.assertEqual(apply_intents(self.source, manifest, strip=True), self.source)
        crlf = self.source.replace(b"\n", b"\r\n")
        result = apply_intents(crlf, self.manifest(crlf))
        self.assertTrue(all(line.endswith(b"\r\n") for line in result.splitlines(True)))

    def test_stale_procedures_and_cross_procedure_dependencies_fail(self):
        with self.assertRaises(ConversionError):
            apply_intents(self.source.replace(b"X(N)=1", b"X(N)=2"), self.manifest())
        second = b"\n      SUBROUTINE T\n      IMPLICIT NONE\n      END SUBROUTINE T\n"
        manifest = self.manifest()
        manifest["input_sha256"] = digest(self.source + second)
        apply_intents(self.source + second, manifest)
        with self.assertRaisesRegex(ConversionError, "whole-library"):
            apply_intents(self.source + second.replace(b"T\n", b"U\n"), manifest)

    def test_rejects_non_dummy_injected_and_invalid_annotations(self):
        for arguments in ({"BOGUS": "IN"}, {"N": "IN OUT"}, {"N\n      STOP": "IN"}):
            manifest = self.manifest()
            manifest["procedures"]["S"]["arguments"] = arguments
            with self.assertRaises(ConversionError):
                apply_intents(self.source, manifest)
        with self.assertRaises(ConversionError):
            apply_intents(self.source.replace(b"IMPLICIT NONE", b"IMPLICIT REAL(A-Z)"), self.manifest())

    def test_declarations_fit_fixed_form_columns(self):
        lines = intent_lines({"ARGUMENT" + str(i): "IN" for i in range(30)})
        self.assertGreater(len(lines), 1)
        self.assertTrue(all(len(line) <= 72 for line in lines))

    def test_mixed_intents_replay_and_compiler_confirmation(self):
        source = (b"      SUBROUTINE S(N,A,STATUS)\n      IMPLICIT NONE\n"
                  b"      INTEGER N,STATUS\n      REAL A(N)\n"
                  b"      STATUS=0\n      A(1)=A(1)+1\n      END SUBROUTINE S\n")
        manifest = {"input_sha256": digest(source), "procedures": {"S": {
            "sha256": digest(source), "arguments": {"N": "IN", "A": "INOUT", "STATUS": "OUT"}}}}
        changed = apply_intents(source, manifest)
        self.assertIn(b"      INTENT(OUT) STATUS\n      INTENT(INOUT) A\n", changed)
        self.assertEqual(apply_intents(changed, manifest), changed)
        self.assertEqual(apply_intents(changed, manifest, strip=True), source)
        inventory = {"S": {name.lower(): {"attributes": f"attributes: (VARIABLE DUMMY({mode}))"}
                            for name, mode in manifest["procedures"]["S"]["arguments"].items()}}
        normalized = normalize_intents(inventory, manifest)
        self.assertTrue(all(e["attributes"] == "attributes: (VARIABLE DUMMY)" for e in normalized["S"].values()))

    def test_call_actuals_include_nested_references_and_keyword_arguments(self):
        result = call_dependencies(["array(i)", "third=n+1", "unknown=x"],
                                   ["first", "second", "third"], {"array", "i", "n", "x"})
        self.assertEqual(result["array"], {"first"})
        self.assertEqual(result["i"], {"first"})
        self.assertEqual(result["n"], {"third"})
        self.assertIsNone(result["x"])
        self.assertIsNone(call_dependencies(["x"], [], {"x"})["x"])

    def test_calls_in_conditions_and_nested_arguments_are_not_lost(self):
        calls = invocations("IF (UNKNOWN(N)+KNOWN(A(I), 'N,)') > 0) CALL WORK(X)")
        self.assertIn(("unknown", ["n"]), calls)
        self.assertIn(("a", ["i"]), calls)
        self.assertIn(("known", ["a(i)", ""]), calls)
        self.assertIn(("work", ["x"]), calls)
        self.assertIsNone(call_dependencies(calls[0][1], [], {"n"})["n"])
        quoted = invocations("ANSWER=F('N, G(X)', N, TEXT='it''s (X)')")
        self.assertEqual(len(quoted), 1)
        self.assertEqual(quoted[0][0], "f")
        self.assertEqual(len(quoted[0][1]), 3)
        self.assertEqual(quoted[0][1][1], "n")

    def test_proof_propagates_but_does_not_guess_through_cycles_or_unknown_calls(self):
        leaf, caller, outer = ("leaf", "x"), ("caller", "x"), ("outer", "x")
        a, b, unknown = ("a", "x"), ("b", "x"), ("unknown", "x")
        requirements = {leaf: set(), caller: {leaf}, outer: {caller}, a: {b}, b: {a}, unknown: None}
        self.assertEqual(prove_inputs(set(requirements), requirements), {leaf, caller, outer})

    def test_only_confirmed_intents_are_removed_from_comparison(self):
        inventory = {"S": {"n": {"type spec": "type spec : (INTEGER 4)",
                                  "attributes": "attributes: (VARIABLE DUMMY(IN))"}}}
        original = copy.deepcopy(inventory)
        result = normalize_intents(inventory, self.manifest())
        self.assertEqual(result["S"]["n"]["attributes"], "attributes: (VARIABLE DUMMY)")
        self.assertEqual(inventory, original)
        with self.assertRaises(ConversionError):
            normalize_intents(result, self.manifest())


if __name__ == "__main__":
    unittest.main()
