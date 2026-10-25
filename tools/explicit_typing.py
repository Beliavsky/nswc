"""Bridge reviewed ftnchek declarations into fixed-form external procedures.

Analyze produces a draft manifest; apply previews or applies that manifest.
The generator's undeclared-only output can omit external function return types:
review function return types and forwarded callbacks before applying a draft.
Procedure hashes prevent applying declarations to changed procedure bodies.
"""

import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

from name_procedure_ends import (
    ConversionError, ENDING, FUNCTION, SUBROUTINE, statements, transform as validate_source,
)

OPTIONS = "undeclared-only,suppress-array-dimensions,compact,use-continuation-lines"
DEFAULT_MANIFEST = Path(__file__).with_name("explicit-typing-pilot.json")


def digest(data):
    return hashlib.sha256(data).hexdigest()


def units(data):
    validate_source(data)
    lines = data.decode("latin-1").splitlines(keepends=True)
    result = {}
    for statement in statements(lines):
        code = re.sub(r"\s+", "", statement.code)
        declaration = FUNCTION.match(code) or SUBROUTINE.match(code)
        if declaration:
            name = declaration[1].upper()
            start, insert = statement.lines[0], statement.lines[-1] + 1
            if name in result:
                raise ConversionError(f"Duplicate procedure {name}")
        if ENDING.fullmatch(code):
            result[name] = (start, insert, statement.lines[-1] + 1)
    return lines, result


def parse_declarations(text):
    result = {}
    current = None
    for line in text.splitlines():
        match = re.match(r"C====>Begin Module\s+(\w+)", line)
        if match:
            current = match[1].upper()
            if current in result:
                raise ConversionError(f"Duplicate declaration section {current}")
            result[current] = []
        elif line.startswith("C====>End Module"):
            current = None
        elif current and line.strip() and not line.startswith("C"):
            if len(line) > 72 or len(line) < 7:
                raise ConversionError("Declaration is outside fixed-form columns")
            result[current].append(line.rstrip())
    return result


def analyze(data, names, executable):
    lines, procedures = units(data)
    missing = set(names) - procedures.keys()
    if missing:
        raise ConversionError(f"Unknown procedures: {sorted(missing)}")
    selected = "".join("".join(lines[a:c]) for name, (a, b, c) in procedures.items() if name in names)
    with tempfile.TemporaryDirectory(prefix="nswc-declarations-") as folder:
        source = Path(folder) / "trial.f"
        source.write_bytes(selected.encode("latin-1"))
        process = subprocess.run([executable, "-quiet", "-library", "-makedcls=" + OPTIONS, "trial.f"],
                                 cwd=folder, capture_output=True, text=True, timeout=120)
        log = process.stdout + process.stderr
        if process.returncode or re.search(r"\bsyntax error\b", log, re.I):
            raise ConversionError(f"ftnchek failed:\n{log}")
        dcl = source.with_suffix(".dcl")
        declarations = parse_declarations(dcl.read_text()) if dcl.exists() else {}
    manifest = {"generator": "ftnchek 3.3.1", "options": OPTIONS,
                "input_sha256": digest(data), "procedures": {}}
    for name, (start, insert, end) in procedures.items():
        if name in names:
            manifest["procedures"][name] = {
                "sha256": digest("".join(lines[start:end]).encode("latin-1")),
                "declarations": declarations.get(name, []),
            }
    return manifest, log


def apply_manifest(data, manifest):
    lines, procedures = units(data)
    changes = {}
    for name, entry in manifest["procedures"].items():
        if name not in procedures:
            raise ConversionError(f"Unknown procedure {name}")
        start, insert, end = procedures[name]
        newline = "\r\n" if lines[start].endswith("\r\n") else "\n"
        declarations = entry["declarations"]
        for line in declarations:
            if (len(line) > 72 or len(line) < 7 or "\n" in line or "\r" in line
                    or line[:5] != "     "):
                raise ConversionError(f"Invalid declaration for {name}")
        # Restrict the manifest to type declarations, including continuations.
        for statement in statements([line + newline for line in declarations]):
            if not re.match(r"\s*(?:INTEGER|REAL|DOUBLE\s+PRECISION|COMPLEX|LOGICAL|CHARACTER)\b",
                            statement.code, re.I):
                raise ConversionError(f"Not a type declaration for {name}")
        block = ["      IMPLICIT NONE" + newline, *[line + newline for line in declarations]]
        body = lines[start:end]
        if lines[insert:insert + len(block)] == block:
            body = lines[start:insert] + lines[insert + len(block):end]
            already_applied = True
        else:
            already_applied = False
        if digest("".join(body).encode("latin-1")) != entry["sha256"]:
            raise ConversionError(f"Procedure changed since declaration analysis: {name}")
        if not already_applied:
            if any(re.match(r"\s*IMPLICIT\b", s.code, re.I) for s in statements(body)):
                raise ConversionError(f"Existing IMPLICIT statement in {name}; review required")
            changes[insert] = block
    output = []
    for index, line in enumerate(lines):
        output.extend(changes.get(index, []))
        output.append(line)
    return "".join(output).encode("latin-1")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    analyze_parser = commands.add_parser("analyze", help="Generate a draft declaration manifest")
    analyze_parser.add_argument("source", type=Path)
    analyze_parser.add_argument("--ftnchek", required=True)
    analyze_parser.add_argument("--procedures", nargs="+", required=True)
    analyze_parser.add_argument("--output", type=Path, required=True)
    apply_parser = commands.add_parser("apply", help="Preview/apply a reviewed manifest")
    apply_parser.add_argument("source", type=Path)
    apply_parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    destination = apply_parser.add_mutually_exclusive_group()
    destination.add_argument("--output", type=Path)
    destination.add_argument("--in-place", action="store_true")
    args = parser.parse_args(argv)
    try:
        data = args.source.read_bytes()
        if args.command == "analyze":
            if args.output.exists():
                raise ConversionError(f"Output already exists: {args.output}")
            executable = args.ftnchek
            if Path(executable).is_file():
                executable = str(Path(executable).resolve())
            manifest, log = analyze(data, {n.upper() for n in args.procedures}, executable)
            with args.output.open("x", encoding="utf-8", newline="\n") as file:
                json.dump(manifest, file, indent=2)
                file.write("\n")
            print(log)
            print("Draft only: review return types and callbacks before applying.")
        else:
            manifest = json.loads(args.manifest.read_text())
            converted = apply_manifest(data, manifest)
            if args.output:
                with args.output.open("xb") as file:
                    file.write(converted)
            elif args.in_place and converted != data:
                with Path(str(args.source) + ".implicit.bak").open("xb") as file:
                    file.write(data)
                args.source.write_bytes(converted)
            print(f"Checked {len(manifest['procedures'])} procedures; "
                  f"{'changes proposed' if converted != data else 'no changes'}.")
        return 0
    except (OSError, ValueError, KeyError, subprocess.TimeoutExpired) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
