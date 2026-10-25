"""Compare GNU Fortran's inferred types before and after reviewed typing batches."""

import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile

from explicit_typing import apply_manifest, DEFAULT_MANIFEST
from modernize_do import transform as modernize_loops
from name_procedure_ends import transform as name_ends

ROOT = Path(__file__).resolve().parents[1]


def symbols(dump):
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
                    if not name.startswith("__") and "INTRINSIC-PROC" not in entry.get("attributes", "")}
            for scope, entries in result.items()}


def scope_preserved(before, after, reviewed_subroutines=()):
    """Allow only reviewed UNKNOWN external procedures to gain SUBROUTINE.

    IMPLICIT NONE lets GNU classify a forwarded, untyped EXTERNAL as a
    subroutine. The manifest names cases checked against their receiving
    workers' CALL statements. No return type or other attribute may change.
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
    return before == adjusted


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", default="gfortran")
    args = parser.parse_args()
    compiler = str(Path(args.compiler).resolve()) if Path(args.compiler).is_file() else args.compiler
    manifest = json.loads(DEFAULT_MANIFEST.read_text())
    before = modernize_loops(name_ends((ROOT / "nswc_orig.f").read_bytes()).data).data
    after = apply_manifest(before, manifest)
    if after != (ROOT / "nswc.f").read_bytes():
        raise RuntimeError("Maintained source does not reproduce the reviewed typing batches")
    inventories = []
    with tempfile.TemporaryDirectory(prefix="nswc-typing-") as folder:
        for label, data in (("before", before), ("after", after)):
            source = Path(folder) / (label + ".f")
            source.write_bytes(data)
            result = subprocess.run([compiler, "-fsyntax-only", "-std=legacy",
                                     "-fallow-argument-mismatch", "-fdump-fortran-original", str(source)],
                                    cwd=folder, capture_output=True, text=True, timeout=180)
            if result.returncode:
                raise RuntimeError(result.stderr)
            inventories.append(symbols(result.stdout))
    count = 0
    for name in manifest["procedures"]:
        if name not in inventories[0] or name not in inventories[1]:
            raise RuntimeError(f"Missing procedure in compiler dump: {name}")
        reviewed = manifest.get("subroutine_classification_reviews", {}).get(name, {})
        if not scope_preserved(inventories[0][name], inventories[1][name], reviewed):
            raise RuntimeError(f"Type, attributes, shape, or argument list changed: {name}")
        count += len(inventories[0][name])
    print(f"Preserved {count} compiler symbol records across {len(manifest['procedures'])} procedures.")
    reviews = manifest.get("subroutine_classification_reviews", {})
    if reviews:
        print(f"Checked {sum(map(len, reviews.values()))} reviewed forwarded subroutine classifications.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
