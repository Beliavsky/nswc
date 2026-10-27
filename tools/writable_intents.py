"""Propose conservative OUT/INOUT annotations for the typed NSWC library.

INOUT preserves incoming storage, including partial arrays and early returns.
OUT is restricted to intrinsic scalars initialized in the initial straight-line
prefix, with no earlier reads, specification dependencies, or observed aliases.
Every internal call is checked for non-definable actual arguments. This is a
review generator for this library, not a general Fortran control-flow analyzer.
"""

import argparse
import copy
import json
from pathlib import Path
import re
import subprocess
import tempfile

from argument_intents import apply_intents, DEFAULT_MANIFEST, invocations, SPECIFICATION, UNSAFE_STORAGE, UNSUPPORTED_IO
from explicit_typing import digest, units
from name_procedure_ends import ConversionError, statements
from validate_explicit_typing import symbols


def mask_strings(code):
    chars = list(code.lower())
    quote = None
    i = 0
    while i < len(chars):
        char = chars[i]
        if quote:
            chars[i] = " "
            if char == quote:
                if i + 1 < len(chars) and chars[i + 1] == quote:
                    chars[i + 1] = " "
                    i += 1
                else:
                    quote = None
        elif char in "'\"":
            quote = char
            chars[i] = " "
        i += 1
    return "".join(chars)


def close_parenthesis(code, start):
    depth = 0
    for i in range(start, len(code)):
        if code[i] == "(":
            depth += 1
        elif code[i] == ")":
            depth -= 1
            if depth == 0:
                return i
    return None


def strip_if(code):
    match = re.match(r"\s*if\s*\(", code)
    if not match:
        return code
    end = close_parenthesis(code, match.end() - 1)
    return code[end + 1:].strip() if end is not None else code


def assignment(code):
    """Return a variable assignment; declarations and DO headers do not match."""
    depth = 0
    for i, char in enumerate(code):
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "=" and depth == 0:
            if (i and code[i - 1] in "=<>/") or code[i + 1:i + 2] in {"=", ">"}:
                continue
            left, right = code[:i].strip(), code[i + 1:].strip()
            match = re.fullmatch(r"([a-z]\w*)\s*(\(.*\))?", left)
            if match:
                return match[1], left, right
            return None
    return None


def is_specification(code):
    return (bool(SPECIFICATION.match(code)) and assignment(code) is None) or bool(re.match(r"format\s*\(", code))


def data_dummies(records):
    return {name for name, entry in records.items()
            if "DUMMY" in entry.get("attributes", "")
            and "PROCEDURE" not in entry.get("attributes", "")
            and re.match(r"type spec : \((?:INTEGER|REAL|COMPLEX|LOGICAL|CHARACTER)\b", entry.get("type spec", ""))}


def variable_base(actual, records, procedure):
    match = re.match(r"\s*([a-z]\w*)", actual)
    if not match:
        return None
    name = match[1]
    attrs = records.get(name, {}).get("attributes", "")
    if "VARIABLE" in attrs or (name == procedure and "FUNCTION" in attrs):
        return name
    return None


def definable_base(actual, records, procedure):
    """Accept bare variables/results or scalar-indexed array elements only."""
    text = actual.strip()
    name = variable_base(text, records, procedure)
    if not name:
        return None
    rest = text[len(name):].strip()
    if not rest:
        return name
    if not rest.startswith("(") or close_parenthesis(rest, 0) != len(rest) - 1 or ":" in rest:
        return None
    if "DIMENSION" not in records[name].get("attributes", ""):
        return None
    for used in re.findall(r"\b[a-z]\w*\b", rest):
        if "DIMENSION" in records.get(used, {}).get("attributes", ""):
            return None  # possible vector subscript
    return name


def initial_scalar_outputs(body, candidates, records, spec_reads):
    """Prove whole scalar initialization before any possible branch or read."""
    pending = {d for d in candidates if "DIMENSION" not in records[d].get("attributes", "") and d not in spec_reads}
    result = {}
    for line, code in body:
        if is_specification(code):
            continue
        if code.strip() == "continue":
            continue
        item = assignment(code)
        if not item:
            break
        name, left, right = item
        depth = 0
        top_comma = False
        for char in right:
            if char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
            elif char == "," and depth == 0:
                top_comma = True
        if top_comma or name not in records:
            break  # includes compact fixed-form DO10I=1,N loop headers
        if "PROCEDURE" in records.get(name, {}).get("attributes", ""):
            break  # statement function, not an executed assignment
        reads = set(re.findall(r"\b[a-z]\w*\b", right + " " + left[len(name):]))
        pending -= reads
        if name in pending and left == name:
            result[name] = {"line": line, "assignment": code.strip()}
            pending.remove(name)
    return result


def infer(base, inventory, existing, allow_common=False, callback_modes=None):
    """Infer writes; COMMON opt-in requires the supplemental alias checks."""
    lines, scopes = units(base)
    formal_order, bodies, direct, calls, excluded, spec_reads = {}, {}, {}, {}, {}, {}
    for name, (start, insert, end) in scopes.items():
        code = list(statements(lines[start:end]))
        header = code[0].code
        ordered = header[header.index("(") + 1:header.rindex(")")].lower().split(",") if "(" in header else []
        formal_order[name] = [d.strip() for d in ordered]
        body = [(start + s.lines[0] + 1, mask_strings(s.code).strip()) for s in code[1:-1]]
        bodies[name], direct[name], calls[name], spec_reads[name] = body, {}, [], set()
        records = inventory[name]
        dummies = data_dummies(records)
        for line, whole in body:
            executable = strip_if(whole)
            unsafe = UNSAFE_STORAGE.match(whole)
            if (unsafe and not (allow_common and re.match(r'common\b', whole))) or UNSUPPORTED_IO.match(executable):
                excluded[name] = "Storage association, alternate entry, pointer, or unsupported I/O"
            if is_specification(whole):
                # Dummy bounds and character lengths use incoming values.
                depth = 0
                inside = []
                for char in whole:
                    if char == "(":
                        depth += 1
                    elif char == ")":
                        depth -= 1
                    elif depth:
                        inside.append(char)
                    else:
                        inside.append(" ")
                spec_reads[name].update(set(re.findall(r"\b[a-z]\w*\b", "".join(inside))) & dummies)
                spec_reads[name].update(set(re.findall(r"\*\s*([a-z]\w*)", whole)) & dummies)
                continue
            assigned = assignment(executable)
            if assigned and "STATEMENT-PROC" in records.get(assigned[0], {}).get("attributes", ""):
                continue
            if assigned and assigned[0] in dummies:
                direct[name].setdefault(assigned[0], []).append({"line": line, "statement": whole})
            iterator = re.match(r"do\s+(?:\d+\s+)?([a-z]\w*)\s*=", executable)
            assigned_label = re.match(r"assign\s+\d+\s+to\s+([a-z]\w*)", executable)
            writes = set(re.findall(r"\b(?:iostat|iomsg)\s*=\s*([a-z]\w*)", executable))
            if iterator:
                writes.add(iterator[1])
            if assigned_label:
                writes.add(assigned_label[1])
            for d in writes & dummies:
                direct[name].setdefault(d, []).append({"line": line, "statement": whole})
            for callee, actuals in invocations(whole):
                record = records.get(callee, {})
                attrs = record.get("attributes", "")
                modes = (callback_modes or {}).get(name + ':' + callee.upper())
                if modes and 'DUMMY' in attrs and 'PROCEDURE' in attrs:
                    if len(modes) != len(actuals):
                        raise ConversionError('Callback argument count changed: ' + name + ':' + callee)
                    for mode, actual in zip(modes, actuals):
                        target = definable_base(actual, records, name.lower())
                        if mode in ('OUT', 'INOUT') and target in dummies:
                            direct[name].setdefault(target, []).append({'line': line, 'statement': whole,
                                'callback_contract': name + ':' + callee.upper()})
                if (callee.upper() not in scopes or "INTRINSIC-PROC" in attrs
                        or ("DUMMY" in attrs and "PROCEDURE" in attrs)
                        or ("VARIABLE" in attrs and "PROCEDURE" not in attrs)):
                    continue
                calls[name].append((callee.upper(), actuals, line))
    modified = {(p, d) for p in scopes for d in direct[p]}
    via = {}
    while True:
        added = set()
        for p in scopes:
            dummies = data_dummies(inventory[p])
            for callee, actuals, line in calls[p]:
                for formal, actual in zip(formal_order[callee], actuals):
                    key = (p, definable_base(actual, inventory[p], p.lower()))
                    if (callee, formal) in modified and key[1] in dummies and key not in modified:
                        added.add(key)
                        via.setdefault(key, []).append({"line": line, "callee": callee, "argument": formal.upper()})
        if not added:
            break
        modified.update(added)
    old_inputs = {(p, d.lower()) for p, entry in existing["procedures"].items()
                  for d, mode in entry["arguments"].items() if mode == "IN"}
    if modified & old_inputs:
        raise ConversionError(f"Earlier input annotation may be writable: {sorted(modified & old_inputs)}")
    nonvariable, aliases = {}, set()
    for p in scopes:
        for callee, actuals, line in calls[p]:
            bases = [variable_base(a, inventory[p], p.lower()) for a in actuals]
            for i, (formal, actual) in enumerate(zip(formal_order[callee], actuals)):
                key = (callee, formal)
                if key not in modified:
                    continue
                if definable_base(actual, inventory[p], p.lower()) is None:
                    nonvariable.setdefault(key, []).append({"caller": p, "line": line, "actual": actual})
                if bases[i] and bases.count(bases[i]) > 1:
                    aliases.add(key)
    manifest = copy.deepcopy(existing)
    counts = {"OUT": 0, "INOUT": 0}
    for name, (start, insert, end) in scopes.items():
        if name in excluded:
            continue
        old = manifest["procedures"].get(name, {}).get("arguments", {})
        writable = {d for p, d in modified if p == name and d.upper() not in old and (p, d) not in nonvariable}
        scalar_out = initial_scalar_outputs(bodies[name], writable, inventory[name], spec_reads[name])
        for d in sorted(writable):
            mode = "OUT" if d in scalar_out and (name, d) not in aliases else "INOUT"
            entry = manifest["procedures"].setdefault(name, {
                "sha256": digest("".join(lines[start:end]).encode("latin-1")), "arguments": {}, "dependencies": {}})
            entry["arguments"][d.upper()] = mode
            evidence = {"intent": mode, "direct_writes": direct[name].get(d, []), "via": via.get((name, d), [])}
            if mode == "OUT":
                evidence["initialization"] = scalar_out[d]
            if (name, d) in aliases:
                evidence["preservation"] = "Observed shared actual storage: kept INOUT, not OUT"
            entry.setdefault("write_evidence", {})[d.upper()] = evidence
            counts[mode] += 1
    manifest["writable_analysis"] = {"generator": "Direct writes and known-call write propagation; initial scalar definitions",
                                      "counts": counts, "excluded_procedures": excluded,
                                      "nonvariable_actuals": {p + ":" + d.upper(): evidence for (p, d), evidence in sorted(nonvariable.items())}}
    totals = {mode: sum(v == mode for e in manifest["procedures"].values() for v in e["arguments"].values())
              for mode in ("IN", "OUT", "INOUT")}
    data_arguments = sum(len(data_dummies(inventory[p])) for p in scopes)
    manifest["coverage"] = {**totals, "data_arguments": data_arguments,
                            "unannotated_data_arguments": data_arguments - sum(totals.values()),
                            "procedures": len(manifest["procedures"])}
    return manifest


def analyze(data, manifest, compiler="gfortran"):
    base = apply_intents(data, manifest, strip=True)
    with tempfile.TemporaryDirectory(prefix="nswc-writable-") as folder:
        path = Path(folder) / "typed.f"
        path.write_bytes(base)
        result = subprocess.run([compiler, "-fsyntax-only", "-std=legacy", "-fallow-argument-mismatch",
                                 "-fdump-fortran-original", str(path)], cwd=folder, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise ConversionError(result.stderr)
        return infer(base, symbols(result.stdout, include_intrinsics=True), manifest)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--compiler", default="gfortran")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)
    result = analyze(args.source.read_bytes(), json.loads(args.manifest.read_text()), args.compiler)
    with args.output.open("x", encoding="utf-8", newline="\n") as out:
        json.dump(result, out, indent=2)
        out.write("\n")
    print("Draft writable annotations:", result["writable_analysis"]["counts"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
