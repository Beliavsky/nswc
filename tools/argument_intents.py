"""Infer conservative input intents with xintent, and apply reviewed manifests.

Analysis needs an external Fortran-Tools directory; applying the manifest does
not. The maintained fixed-form source is changed only by an explicit apply.
Output intents are deliberately outside this first pass.
"""

import argparse
import importlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

from explicit_typing import digest, units
from fixed_to_free import convert_text
from name_procedure_ends import ConversionError, statements
from validate_explicit_typing import symbols

DEFAULT_MANIFEST = Path(__file__).with_name("argument-intents.json")
IDENTIFIER = re.compile(r"^[A-Z][A-Z0-9_]*$")
INTENT_LINE = re.compile(r"^\s*INTENT\s*\(", re.I)
UNSAFE_STORAGE = re.compile(r"^\s*(?:COMMON|EQUIVALENCE|ENTRY|POINTER)\b", re.I)
UNSUPPORTED_IO = re.compile(r"^\s*(?:READ|OPEN|CLOSE|INQUIRE|BACKSPACE|ENDFILE|REWIND|WAIT|FLUSH)\b", re.I)
CONTROL_WORDS = {"if", "elseif", "do", "while", "select", "case", "where", "write", "format"}
SPECIFICATION = re.compile(r"^\s*(?:integer|real|complex|logical|character|double\s+precision|implicit|dimension|external|intrinsic|save|data|parameter)\b", re.I)


def invocations(code):
    """Find nested NAME(...) uses without discarding IF conditions or strings.

    Quoted contents are blanked, so parentheses, commas, and variable-like
    words inside a string literal cannot affect the dependency analysis.
    """
    masked = list(code.lower())
    quote = None
    i = 0
    while i < len(masked):
        char = masked[i]
        if quote:
            masked[i] = " "
            if char == quote:
                if i + 1 < len(masked) and masked[i + 1] == quote:
                    masked[i + 1] = " "
                    i += 1
                else:
                    quote = None
        elif char in "'\"":
            quote = char
            masked[i] = " "
        i += 1
    text = "".join(masked)
    stack = []
    calls = []
    for i, char in enumerate(text):
        if char == "(":
            name = re.search(r"([a-z][a-z0-9_]*)\s*$", text[:i])
            stack.append((i, name[1] if name else None))
        elif char == ")" and stack:
            start, name = stack.pop()
            if name:
                inner = text[start + 1:i]
                depth, last, args = 0, 0, []
                for j, part in enumerate(inner):
                    if part == "(":
                        depth += 1
                    elif part == ")":
                        depth -= 1
                    elif part == "," and depth == 0:
                        args.append(inner[last:j].strip())
                        last = j + 1
                if inner.strip() or args:
                    args.append(inner[last:].strip())
                calls.append((name, args))
    return calls


def intent_lines(arguments):
    names = sorted(arguments)
    if not names or any(not IDENTIFIER.fullmatch(n) or arguments[n] != "IN" for n in names):
        raise ConversionError("Only named INTENT(IN) arguments are supported")
    result = []
    line = "      INTENT(IN) "
    for name in names:
        if len(line + name) > 72:
            result.append(line.rstrip(", "))
            line = "      INTENT(IN) "
        line += name + ", "
    result.append(line.rstrip(", "))
    return result


def apply_intents(data, manifest, strip=False):
    lines, procedures = units(data)
    insertions = {}
    original_lines = list(lines)
    for name, entry in manifest["procedures"].items():
        start, insert, end = procedures[name]
        body = list(statements(lines[start:end]))
        if len(body) < 2 or body[1].code.strip().upper() != "IMPLICIT NONE":
            raise ConversionError(f"Explicit typing is required first: {name}")
        header = body[0].code
        dummy_text = header[header.index("(") + 1:header.rindex(")")]
        dummies = {n.strip().upper() for n in dummy_text.split(",")}
        if set(entry["arguments"]) - dummies:
            raise ConversionError(f"Not a dummy argument: {name}")
        position = start + body[1].lines[-1] + 1
        newline = "\r\n" if lines[start].endswith("\r\n") else "\n"
        block = [line + newline for line in intent_lines(entry["arguments"])]
        applied = lines[position:position + len(block)] == block
        bare = lines[start:position] + lines[position + len(block):end] if applied else lines[start:end]
        if digest("".join(bare).encode("latin-1")) != entry["sha256"]:
            raise ConversionError(f"Procedure changed since intent review: {name}")
        if any(INTENT_LINE.match(s.code) or re.search(r"\bINTENT\s*\(", s.code, re.I)
               for s in statements(bare)):
            raise ConversionError(f"Existing intent requires separate review: {name}")
        if applied:
            for i in range(position, position + len(block)):
                original_lines[i] = ""
        else:
            insertions[position] = block
    if digest("".join(original_lines).encode("latin-1")) != manifest["input_sha256"]:
        raise ConversionError("Source changed since whole-library intent analysis")
    if strip:
        return "".join(original_lines).encode("latin-1")
    result = []
    for i, line in enumerate(lines):
        result.extend(insertions.get(i, []))
        result.append(line)
    return "".join(result).encode("latin-1")


def normalize_intents(inventory, manifest):
    """Check every reviewed intent, then remove only its compiler attribute."""
    result = {scope: {name: dict(entry) for name, entry in entries.items()}
              for scope, entries in inventory.items()}
    for scope, entry in manifest["procedures"].items():
        for name, intent in entry["arguments"].items():
            symbol = result[scope][name.lower()]
            marker = f"DUMMY({intent})"
            if marker not in symbol.get("attributes", ""):
                raise ConversionError(f"Compiler did not confirm {intent}: {scope}/{name}")
            symbol["attributes"] = symbol["attributes"].replace(marker, "DUMMY", 1)
    return result


def call_dependencies(arguments, formals, candidates):
    """Return required callee inputs; None means a call cannot be proved safe.

    Every candidate mentioned in an actual expression is checked, including
    array elements, nested calls, and arguments beyond the first identifier.
    """
    dependencies = {name: set() for name in candidates}
    for position, actual in enumerate(arguments):
        used = set(re.findall(r"\b[A-Za-z][A-Za-z0-9_]*\b", actual.lower())) & candidates
        if not used:
            continue
        keyword = re.match(r"\s*([a-z]\w*)\s*=(?!=|>)", actual, re.I)
        formal = keyword[1].lower() if keyword else (formals[position] if position < len(formals) else None)
        for name in used:
            if formal not in formals:
                dependencies[name] = None
            elif dependencies[name] is not None:
                dependencies[name].add(formal)
    return dependencies


def prove_inputs(potential, requirements):
    """Least fixed point: recursive cycles and unresolved calls stay unproved."""
    proved = set()
    while True:
        added = {key for key in potential - proved
                 if requirements[key] is not None and requirements[key] <= proved}
        if not added:
            return proved
        proved.update(added)


def analyze(data, tool_dir, compiler="gfortran"):
    sys.path.insert(0, str(Path(tool_dir).resolve()))
    xi = importlib.import_module("xintent")
    fs = importlib.import_module("fortran_scan")
    with tempfile.TemporaryDirectory(prefix="nswc-intents-") as folder:
        probe = Path(folder) / "header_probe.f90"
        probe.write_text("subroutine probe(x)\nreal :: x\nprint *,x\nend subroutine probe\n", encoding="ascii")
        probe_files, _ = fs.load_source_files([probe])
        probe_inputs = xi.analyze_intent_suggestions(
            probe_files[0], target_intent="in", interproc=True,
            call_sigs=xi.collect_proc_call_signatures(probe_files))
        if {(s.proc_name, s.dummy) for s in probe_inputs} != {("probe", "x")}:
            raise ConversionError("Analyzer failed the header regression; apply fortran-tools-intent-header.patch first")
        fixed = Path(folder) / "library.f"
        free = Path(folder) / "library.f90"
        fixed.write_bytes(data)
        free.write_text(convert_text(data.decode("ascii")), encoding="ascii")
        compiled = subprocess.run([compiler, "-fsyntax-only", "-std=legacy", "-fallow-argument-mismatch",
                                   "-fdump-fortran-original", str(fixed)], capture_output=True, text=True,
                                  cwd=folder, timeout=180)
        if compiled.returncode:
            raise ConversionError(compiled.stderr)
        inventory = symbols(compiled.stdout, include_intrinsics=True)
        files, missing = fs.load_source_files([free])
        if missing or len(files) != 1:
            raise ConversionError("Cannot load converted analysis source")
        info = files[0]
        fixed_lines, fixed_units = units(data)
        if set(fixed_units) != {p.name.upper() for p in info.procedures}:
            raise ConversionError("Fixed/free procedure inventories disagree")
        signatures = xi.collect_proc_call_signatures(files)
        # This permissive candidate pass is followed by an independent proof.
        # No assumed call intent is ever written directly to the manifest.
        for signature in signatures.values():
            if signature:
                signature.intent_by_dummy.update({d: "in" for d in signature.ordered_dummies})
        suggestions = xi.analyze_intent_suggestions(info, target_intent="in", call_sigs=signatures,
                                                    interproc=True)
        potential = {(s.proc_name.lower(), s.dummy.lower()) for s in suggestions}
        requirements = {key: set() for key in potential}
        all_statements = fs.iter_fortran_statements(info.parsed_lines)
        excluded = {}
        for proc in info.procedures:
            own = {d for p, d in potential if p == proc.name.lower()}
            body = [(ln, code) for ln, code in all_statements if proc.start < ln < proc.end]
            if any(UNSAFE_STORAGE.match(code) or UNSUPPORTED_IO.match(code) for ln, code in body):
                excluded[proc.name.upper()] = "Legacy storage association, alternate entry, or unsupported I/O"
                for d in own:
                    requirements[(proc.name.lower(), d)] = None
                continue
            local = inventory[proc.name.upper()]
            for d in own:
                attrs = local[d].get("attributes", "")
                if "DUMMY" not in attrs or "PROCEDURE" in attrs:
                    requirements[(proc.name.lower(), d)] = None
            for ln, code in body:
                whole = xi.strip_statement_label(code.lower())
                low = xi.strip_one_line_if_prefix(whole)
                if SPECIFICATION.match(low) and xi.split_assignment(low) is None:
                    continue
                # These write forms are additional guards beyond xintent.
                assigned = re.match(r"assign\s+\d+\s+to\s+(\w+)", low)
                writes = ({assigned[1]} if assigned else set())
                writes.update(re.findall(r"\b(?:iostat|iomsg|size)\s*=\s*([a-z]\w*)", low))
                for d in own & writes:
                    requirements[(proc.name.lower(), d)] = None
                calls = []
                called = xi.parse_call_name_and_args(low)
                if called:
                    calls.append(called)
                for name, actuals in invocations(whole):
                    if called and name == called[0]:
                        continue
                    record = local.get(name, {})
                    attrs = record.get("attributes", "")
                    if name in CONTROL_WORDS or "INTRINSIC-PROC" in attrs:
                        continue
                    if "VARIABLE" in attrs and "PROCEDURE" not in attrs:
                        continue  # array references, not function invocations
                    calls.append((name, actuals))
                for callee, actuals in calls:
                    signature = signatures.get(callee)
                    formals = signature.ordered_dummies if signature else []
                    dependencies = call_dependencies(actuals, formals, own)
                    for d, needed in dependencies.items():
                        key = (proc.name.lower(), d)
                        if requirements[key] is None:
                            continue
                        if needed is None:
                            requirements[key] = None
                        else:
                            requirements[key].update((callee, f) for f in needed)
        proved = prove_inputs(potential, requirements)
        manifest = {"generator": "Fortran-Tools xintent with compiler-guided input proof",
                    "input_sha256": digest(data), "procedures": {},
                    "analysis": {"candidates": len(potential), "proved": len(proved),
                                 "excluded_procedures": excluded,
                                 "tool_files": {name: digest((Path(tool_dir) / name).read_bytes().replace(b"\r\n", b"\n"))
                                                for name in ("xintent.py", "fortran_scan.py", "fortran_build.py", "cli_paths.py")}}}
        for name, (a, b, c) in fixed_units.items():
            arguments = {d.upper(): "IN" for p, d in sorted(proved) if p == name.lower()}
            if arguments:
                manifest["procedures"][name] = {"sha256": digest("".join(fixed_lines[a:c]).encode("latin-1")),
                                                 "arguments": arguments,
                                                 "dependencies": {d: [p.upper() + ":" + arg.upper()
                                                                      for p, arg in sorted(requirements[(name.lower(), d.lower())])]
                                                                  for d in arguments if requirements[(name.lower(), d.lower())]}}
        return manifest


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    draft = commands.add_parser("analyze")
    draft.add_argument("source", type=Path)
    draft.add_argument("--tool-dir", type=Path, required=True)
    draft.add_argument("--compiler", default="gfortran")
    draft.add_argument("--output", type=Path, required=True)
    apply = commands.add_parser("apply")
    apply.add_argument("source", type=Path)
    apply.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    apply.add_argument("--output", type=Path)
    baseline = commands.add_parser("baseline", help="Recover the typed source before reviewed intents")
    baseline.add_argument("source", type=Path)
    baseline.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    baseline.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)
    if args.command == "analyze":
        manifest = analyze(args.source.read_bytes(), args.tool_dir, args.compiler)
        with args.output.open("x", encoding="utf-8", newline="\n") as out:
            json.dump(manifest, out, indent=2)
            out.write("\n")
        print(f"Draft: {manifest['analysis']['proved']} input arguments in {len(manifest['procedures'])} procedures.")
    else:
        manifest = json.loads(args.manifest.read_text())
        before = args.source.read_bytes()
        after = apply_intents(before, manifest, strip=args.command == "baseline")
        if args.output:
            with args.output.open("xb") as out:
                out.write(after)
        print(f"Checked {len(manifest['procedures'])} procedures; changes {'proposed' if before != after else 'already applied'}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
