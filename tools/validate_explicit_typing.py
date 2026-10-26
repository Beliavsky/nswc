"""Compare GNU Fortran's inferred types before and after reviewed typing batches."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import apply_manifest, DEFAULT_MANIFEST
from modernize_do import transform as modernize_loops
from name_procedure_ends import transform as name_ends
from reviewed_source_fixes import apply_fixes, normalize_reviewed_symbols, check_warning_inventory
from combine_declarations import transform as combine_declarations
from order_declarations import transform as order_declarations
from periodic_root_workspace import transform_fixed as correct_workspace
from modernize_deleted_do import transform as modernize_deleted_loops
from modernize_arithmetic_if import transform as modernize_arithmetic_if
from modernize_remaining_features import transform as finish_remaining
from name_procedure_ends import statements, code_comment

ROOT = Path(__file__).resolve().parents[1]


def non_declaration_content(data):
    """Independently compare all remaining statements and the comment stream."""
    lines = data.decode('latin-1').splitlines(True)
    comments = {i: line.rstrip('\r\n') if line[0] in 'Cc*' else line.lstrip().rstrip('\r\n')
                for i, line in enumerate(lines) if line.strip() and line[0] in 'Cc*!'}
    content = []
    for statement in statements(lines):
        if not re.match(r'^\s*(?:INTEGER|REAL|COMPLEX|LOGICAL|CHARACTER|DOUBLE\s+(?:PRECISION|COMPLEX)|INTENT|DIMENSION|EXTERNAL)\b',
                        statement.code, re.I):
            content.append(statement.code)
        quote = ''
        for i in statement.lines:
            _, comment, quote = code_comment(lines[i].rstrip('\r\n')[6:72], quote)
            if comment:
                comments[i] = comment
    # The statement reader skips indented comment-only lines.
    for i, line in enumerate(lines):
        if line[6:72].lstrip().startswith('!') and i not in comments:
            comments[i] = line[6:72].lstrip().rstrip('\r\n')
    return content, [comments[i] for i in sorted(comments)]


def symbols(dump, include_intrinsics=False):
    result = {}
    scope = None
    symbol = None
    for line in dump.splitlines():
        match = re.match(r"procedure name = (\w+)", line)
        if match:
            scope = match[1].upper()
            result[scope] = {}
            symbol = None
        match = re.search(r"symtree:.*?\|\| symbol: '([^']+)'", line)
        if match and scope:
            symbol = match[1]
            result[scope][symbol] = {}
        if symbol and re.match(r"\s*(?:type spec|attributes|Array spec|Formal arglist)\s*:", line):
            key = line.strip().split(":")[0].strip()
            value = re.sub(r"\s+", " ", line.strip().replace("IMPLICIT-TYPE", ""))
            value = value.replace(" )", ")").replace("( ", "(")
            result[scope][symbol][key] = value
    # Intrinsic symbol placeholders lose their implicit defaults under IMPLICIT
    # NONE. Intrinsic result types are resolved from the actual call arguments;
    # those placeholders are not variable or external-function declarations.
    return {scope: {name: entry for name, entry in entries.items()
                    if not name.startswith("__") and (include_intrinsics or "INTRINSIC-PROC" not in entry.get("attributes", ""))}
            for scope, entries in result.items()}


def scope_preserved(before, after, reviewed_subroutines=(), reviewed_functions=None):
    """Compare a scope, accounting for reviewed forwarded procedure resolution.

    IMPLICIT NONE lets GNU classify a forwarded, untyped EXTERNAL as a
    subroutine. The manifest names cases checked against their receiving
    workers' CALL statements. Older GNU dumps also leave some forwarded
    functions UNKNOWN; their expected return types come from independently
    checked original definitions or receiving workers. Other fields must match.
    """
    if before == after:
        return True
    adjusted = dict(after)
    for name in reviewed_subroutines:
        original, converted = before.get(name), after.get(name)
        if not original or not converted:
            return False
        if original == converted:
            continue
        attributes = original.get("attributes", "")
        if (original.get("type spec") != "type spec : (UNKNOWN 0)"
                or "PROCEDURE" not in attributes or "EXTERNAL" not in attributes
                or "SUBROUTINE" in attributes or "FUNCTION" in attributes):
            return False
        refined = dict(converted)
        refined["attributes"] = converted.get("attributes", "").replace(" SUBROUTINE", "", 1)
        if refined != original:
            return False
        adjusted[name] = refined
    for name, expected_type in (reviewed_functions or {}).items():
        original, converted = before.get(name), after.get(name)
        if not original or not converted:
            return False
        if original == converted:
            continue
        attributes = original.get("attributes", "")
        if (original.get("type spec") != "type spec : (UNKNOWN 0)"
                or converted.get("type spec") != expected_type
                or "PROCEDURE" not in attributes or "EXTERNAL" not in attributes
                or "SUBROUTINE" in attributes or "FUNCTION" in attributes
                or " FUNCTION" not in converted.get("attributes", "")):
            return False
        refined = dict(converted)
        refined["type spec"] = original["type spec"]
        refined["attributes"] = converted["attributes"].replace(" FUNCTION", "", 1)
        if refined != original:
            return False
        adjusted[name] = refined
    return before == adjusted


def fixed_stages():
    """Reproduce the historical fixed-form stages before terminal cleanup."""
    from argument_intents import apply_intents, DEFAULT_MANIFEST as INTENT_MANIFEST
    manifest = json.loads(DEFAULT_MANIFEST.read_text())
    before = modernize_loops(name_ends((ROOT / "nswc_orig.f").read_bytes()).data).data
    after = apply_manifest(apply_fixes(before), manifest)
    intents = json.loads(INTENT_MANIFEST.read_text()) if INTENT_MANIFEST.exists() else None
    if intents:
        after = apply_intents(after, intents)
    unformatted_source = after
    formatting = combine_declarations(unformatted_source)
    ordering = order_declarations(formatting.data)
    return before, unformatted_source, formatting, ordering, intents, manifest


def main():
    # Import here: the intent analyzer reuses this module's dump parser.
    from argument_intents import normalize_intents
    from remove_final_returns import transform_fixed as remove_final_returns
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", default="gfortran")
    parser.add_argument("--unformatted-output", type=Path,
                        help="Write a new copy of the verified intermediate source for historical manifest tools")
    args = parser.parse_args()
    if args.unformatted_output and args.unformatted_output.exists():
        parser.error("--unformatted-output must name a new file")
    compiler = str(Path(args.compiler).resolve()) if Path(args.compiler).is_file() else args.compiler
    before, unformatted_source, formatting, ordering, intents, manifest = fixed_stages()
    after = ordering.data
    if non_declaration_content(unformatted_source) != non_declaration_content(after):
        raise RuntimeError("Declaration formatting changed other statements or comments")
    cleanup_report = {}
    after = remove_final_returns(after, cleanup_report)
    if cleanup_report != json.loads((ROOT / 'tools/final-return-cleanup.json').read_text()):
        raise RuntimeError('Terminal RETURN cleanup report is stale')
    if finish_remaining(modernize_arithmetic_if(modernize_deleted_loops(correct_workspace(after)).data)) != (ROOT / "nswc.f").read_bytes():
        raise RuntimeError("Maintained source does not reproduce the reviewed typing, intents, and declaration formatting")
    if json.loads((ROOT / 'tools/declaration-ordering.json').read_text()) != ordering.report(formatting.data):
        raise RuntimeError('Declaration ordering report is stale')
    inventories = []
    with tempfile.TemporaryDirectory(prefix="nswc-typing-") as folder:
        for label, data in (("before", before), ("reviewed", unformatted_source), ("after", after)):
            source = Path(folder) / (label + ".f")
            source.write_bytes(data)
            result = subprocess.run([compiler, "-fsyntax-only", "-std=legacy",
                                     "-fallow-argument-mismatch", "-fdump-fortran-original", str(source)],
                                    cwd=folder, capture_output=True, text=True, timeout=180,
                                    env={**os.environ, "LC_ALL": "C"})
            if result.returncode:
                raise RuntimeError(result.stderr)
            complete = symbols(result.stdout, include_intrinsics=True)
            if label == "reviewed":
                reviewed_inventory = complete
                continue
            if label == "after" and complete != reviewed_inventory:
                raise RuntimeError("Declaration formatting changed compiler symbol records")
            inventory = symbols(result.stdout)
            if label == "after" and intents:
                inventory = normalize_intents(inventory, intents)
            if label == "after":
                warning_count = check_warning_inventory(result.stderr, data)
                inventory = normalize_reviewed_symbols(inventories[0], inventory)
            inventories.append(inventory)
        maintained = Path(folder) / 'maintained.f'
        maintained.write_bytes(finish_remaining(modernize_arithmetic_if(modernize_deleted_loops(correct_workspace(after)).data)))
        result = subprocess.run([compiler, '-fsyntax-only', '-std=legacy',
                                 '-fno-allow-argument-mismatch', str(maintained)],
                                cwd=folder, capture_output=True, text=True, timeout=180,
                                env={**os.environ, 'LC_ALL': 'C'})
        if result.returncode:
            raise RuntimeError(result.stderr)
        fixed_warnings = {'remaining_warnings': [r for r in json.loads(
            (ROOT / 'tools/reviewed-source-fixes.json').read_text())['remaining_warnings']
            if r['procedure'] != 'COMPB']}
        maintained_warning_count = check_warning_inventory(result.stderr, maintained.read_bytes(), fixed_warnings)
    count = 0
    mismatches = {}
    for name in manifest["procedures"]:
        if name not in inventories[0] or name not in inventories[1]:
            raise RuntimeError(f"Missing procedure in compiler dump: {name}")
        reviewed = manifest.get("subroutine_classification_reviews", {}).get(name, {})
        functions = manifest.get("forwarded_function_reviews", {}).get(name, {})
        expected_types = {}
        for symbol, review in functions.items():
            reference = review["type_source"]
            original_type = inventories[0][reference["scope"]][reference["symbol"]]["type spec"]
            if original_type != review["type"]:
                raise RuntimeError(f"Reviewed callback's original return type changed: {name}/{symbol}")
            expected_types[symbol] = original_type
        if not scope_preserved(inventories[0][name], inventories[1][name], reviewed, expected_types):
            original, converted = inventories[0][name], inventories[1][name]
            mismatches[name] = {
                symbol: {"before": original.get(symbol), "after": converted.get(symbol)}
                for symbol in sorted(original.keys() | converted.keys())
                if original.get(symbol) != converted.get(symbol)
            }
        count += len(inventories[0][name])
    if mismatches:
        raise RuntimeError("Type, attributes, shape, or argument list changed:\n"
                           + json.dumps(mismatches, indent=2))
    print(f"Checked {count} compiler symbol records across {len(manifest['procedures'])} procedures; "
          "preserved all except three separately confirmed warning corrections.")
    print(f"Confirmed {warning_count} historical pre-workspace-fix warnings against the reviewed inventory.")
    print(f"Maintained fixed form rejects argument mismatches; confirmed {maintained_warning_count} COMMON-alignment warnings.")
    print(f"Declaration formatting preserves all {sum(map(len, reviewed_inventory.values()))} compiler records, "
          f"including intrinsics; combined {formatting.intents_combined} intents and {formatting.dimensions_combined} dimensions.")
    print("Declaration formatting preserves non-declaration statements and comment text/order.")
    print(f"Removed {cleanup_report['removed']} plain terminal RETURNs in the final fixed-form cleanup.")
    print(f'Argument declarations precede local types; reordered {ordering.changed_procedures} procedures, '
          f'with {len(ordering.prerequisite_locals)} required local dependency groups.')
    if intents:
        counts = {mode: sum(v == mode for e in intents["procedures"].values() for v in e["arguments"].values())
                  for mode in ("IN", "OUT", "INOUT")}
        print("Confirmed reviewed argument intents: " + ", ".join(f"{n} {mode}" for mode, n in counts.items()) + ".")
    reviews = manifest.get("subroutine_classification_reviews", {})
    if reviews:
        print(f"Checked {sum(map(len, reviews.values()))} reviewed forwarded subroutine classifications.")
    functions = manifest.get("forwarded_function_reviews", {})
    if functions:
        print(f"Checked {sum(map(len, functions.values()))} forwarded function types against original definitions or workers.")
    if args.unformatted_output:
        with args.unformatted_output.open('xb') as output:
            output.write(unformatted_source)
        print(f"Wrote verified unformatted intermediate: {args.unformatted_output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
