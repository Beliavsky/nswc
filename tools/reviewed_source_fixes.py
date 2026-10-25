"""Apply recorded compiler-warning fixes before the explicit typing stage.

Each replacement is confined to a hashed procedure and preserves physical line
counts. The manifest records literal changes; this is not a source analyzer.
"""

import argparse
from collections import Counter
import json
from pathlib import Path
import re

from explicit_typing import digest, units
from name_procedure_ends import ConversionError

DEFAULT_MANIFEST = Path(__file__).with_name("reviewed-source-fixes.json")


def apply_fixes(data, manifest=None):
    if manifest is None:
        manifest = json.loads(DEFAULT_MANIFEST.read_text())
    lines, scopes = units(data)
    edits = {}
    for name, entry in manifest["procedures"].items():
        start, _, end = scopes[name]
        original = "".join(lines[start:end])
        if digest(original.encode("latin-1")) == entry["after_sha256"]:
            continue
        if digest(original.encode("latin-1")) != entry["before_sha256"]:
            raise ConversionError(f"Procedure changed since warning review: {name}")
        changed = original
        for replacement in entry["replacements"]:
            before, after = replacement["before"], replacement["after"]
            if changed.count(before) != 1:
                raise ConversionError(f"Replacement is not unique: {name}")
            changed = changed.replace(before, after, 1)
        if (len(changed.splitlines()) != len(original.splitlines())
                or any(len(line) > 72 for line in changed.splitlines() if line and line[0] not in 'Cc*!')):
            raise ConversionError(f"Fix changes physical lines or fixed-form width: {name}")
        if digest(changed.encode("latin-1")) != entry["after_sha256"]:
            raise ConversionError(f"Unexpected warning fix result: {name}")
        edits[start] = (end, changed)
    result = []
    index = 0
    while index < len(lines):
        if index in edits:
            index, changed = edits[index]
            result.append(changed)
        else:
            result.append(lines[index])
            index += 1
    return "".join(result).encode("latin-1")


def normalize_reviewed_symbols(before, after, manifest=None):
    """Verify the exact reviewed corrections before the preservation check."""
    if manifest is None:
        manifest = json.loads(DEFAULT_MANIFEST.read_text())
    result = {p: dict(entries) for p, entries in after.items()}
    for review in manifest["symbol_reviews"]:
        scope, name = review["procedure"], review["symbol"]
        for inventory, label in ((before, "before"), (after, "after")):
            actual = dict(inventory[scope][name])
            expected = dict(review[label])
            optional = set(review.get("optional_attributes", []))
            actual_attrs = set(re.findall(r"[A-Z][A-Z-]*", actual.pop("attributes"))) - optional
            expected_attrs = set(re.findall(r"[A-Z][A-Z-]*", expected.pop("attributes"))) - optional
            if actual != expected or actual_attrs != expected_attrs:
                raise ConversionError(f"Compiler did not confirm reviewed correction: {scope}/{name} ({label})")
        result[scope][name] = dict(before[scope][name])
    return result


def check_warning_inventory(stderr, data, manifest=None):
    """Reject added, missing, or relocated diagnostics in the reviewed build."""
    if manifest is None:
        manifest = json.loads(DEFAULT_MANIFEST.read_text())
    _, scopes = units(data)
    expected = Counter((r["procedure"], r["pattern"]) for r in manifest["remaining_warnings"])
    observed = Counter()
    location = None
    for line in stderr.splitlines():
        match = re.match(r"^.*:(\d+):\d*:\s*$", line)
        if match:
            location = int(match[1]) - 1
        if line.startswith("Warning:"):
            scope = next((p for p, (start, _, end) in scopes.items()
                          if location is not None and start <= location < end), None)
            matches = [(p, pattern) for p, pattern in expected
                       if p == scope and re.search(pattern, line)]
            if len(matches) != 1:
                raise ConversionError(f"Unreviewed compiler warning in {scope}: {line}")
            observed[matches[0]] += 1
    if observed != expected:
        raise ConversionError(f"Compiler warning inventory changed: expected {dict(expected)}, got {dict(observed)}")
    return sum(observed.values())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    changed = apply_fixes(args.source.read_bytes())
    with args.output.open("xb") as output:
        output.write(changed)


if __name__ == "__main__":
    main()
