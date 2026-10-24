#!/usr/bin/env python3
"""Name external procedure endings and separate procedures in fixed-form Fortran.

By default, only report proposed changes. Use --output to write a separate copy,
or --in-place to update the input after creating a non-overwriting .bak backup.
This is a conservative scanner for external functions/subroutines, not a general
Fortran parser. Programs, modules, internal procedures, preprocessor directives,
tab-form source, and multiple statements on a line are deliberately rejected.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import difflib
from pathlib import Path
import re
import sys


NAME = r"[A-Z][A-Z0-9_]*"
TYPE = r"(?:DOUBLEPRECISION|DOUBLECOMPLEX|INTEGER|REAL|COMPLEX|LOGICAL|CHARACTER)"
TYPE_SPEC = TYPE + r"(?:\*(?:\d+|\([^)]*\))|\([^)]*\))?"
FUNCTION = re.compile(rf"^(?:{TYPE_SPEC})?FUNCTION({NAME})\(", re.I)
SUBROUTINE = re.compile(rf"^SUBROUTINE({NAME})(?:\(|$)", re.I)
ENDING = re.compile(rf"^END(?:(FUNCTION|SUBROUTINE)({NAME})?)?$", re.I)
UNSUPPORTED = re.compile(r"^(?:PROGRAM|BLOCKDATA|MODULE|SUBMODULE|CONTAINS|INTERFACE|ABSTRACTINTERFACE)", re.I)


class ConversionError(ValueError):
    """The input cannot be transformed without guessing its structure."""


@dataclass(frozen=True)
class Statement:
    lines: tuple[int, ...]
    code: str


@dataclass(frozen=True)
class Result:
    data: bytes
    procedures: int
    endings_changed: int
    blank_lines_added: int


def split_line(line: str) -> tuple[str, str]:
    body = line.rstrip("\r\n")
    return body, line[len(body):]


def code_comment(field: str, quote: str = "") -> tuple[str, str, str]:
    """Split an inline comment, respecting quoted strings and doubled quotes."""
    i = 0
    while i < len(field):
        char = field[i]
        if quote:
            if char == quote:
                if i + 1 < len(field) and field[i + 1] == quote:
                    i += 2
                    continue
                quote = ""
        elif char in "'\"":
            quote = char
        elif char == "!":
            return field[:i], field[i:], quote
        elif char == ";":
            raise ConversionError("multiple statements/semicolon syntax is unsupported")
        i += 1
    return field, "", quote


def statements(lines: list[str]):
    """Read columns 7-72; join column-6 continuations across comments/blanks."""
    indices: list[int] = []
    pieces: list[str] = []
    quote = ""
    for index, raw in enumerate(lines):
        body, _ = split_line(raw)
        if not body.strip() or body[0] in "Cc*!":
            continue
        if body.lstrip().startswith("#"):
            raise ConversionError(f"line {index + 1}: preprocessor directives are unsupported")
        if "\t" in body or any(char not in " 0123456789" for char in body[:5]):
            raise ConversionError(f"line {index + 1}: expected fixed-form columns without tabs/debug lines")
        continuation = len(body) > 5 and body[5] not in " 0"
        field = body[6:72]
        if not field.strip() or field.lstrip().startswith("!"):
            continue
        if not continuation:
            if indices:
                yield Statement(tuple(indices), "".join(pieces))
            indices, pieces, quote = [], [], ""
        elif not indices:
            raise ConversionError(f"line {index + 1}: continuation without a preceding statement")
        try:
            code, _, quote = code_comment(field, quote)
        except ConversionError as error:
            raise ConversionError(f"line {index + 1}: {error}") from error
        indices.append(index)
        pieces.append(code)
    if indices:
        yield Statement(tuple(indices), "".join(pieces))


def named_ending(raw: str, kind: str, name: str) -> str:
    body, newline = split_line(raw)
    field, comment, _ = code_comment(body[6:72])
    indent = field[:len(field) - len(field.lstrip())]
    replacement = body[:6] + indent + f"END {kind} {name}"
    if comment:
        replacement += "  " + comment
    if len(replacement) > 72:
        raise ConversionError("named ending/comment would extend past fixed-form column 72")
    # Preserve sequence fields in columns 73 onward at their original positions.
    if len(body) > 72:
        replacement = replacement.ljust(72) + body[72:]
    return replacement + newline


def transform(data: bytes) -> Result:
    # Latin-1 is a byte-for-byte mapping: non-ASCII comments and line endings
    # survive unchanged, without assuming an encoding or silently losing bytes.
    text = data.decode("latin-1")
    lines = re.findall(r"[^\r\n]*(?:\r\n|\r|\n|$)", text)
    if lines and lines[-1] == "":
        lines.pop()
    edits: dict[int, str] = {}
    units: list[tuple[int, int]] = []
    current: tuple[str, str, int] | None = None
    for statement in statements(lines):
        line = statement.lines[0] + 1
        compact = re.sub(r"\s+", "", statement.code)
        if UNSUPPORTED.match(compact):
            raise ConversionError(f"line {line}: only external functions/subroutines are supported")
        match = FUNCTION.match(compact)
        kind = "FUNCTION"
        if not match:
            match = SUBROUTINE.match(compact)
            kind = "SUBROUTINE"
        if match:
            if current:
                raise ConversionError(f"line {line}: new procedure before {current[1]} has ended")
            current = kind, match[1], statement.lines[0]
            continue
        end = ENDING.fullmatch(compact)
        if end:
            if not current:
                raise ConversionError(f"line {line}: ending without an open procedure")
            kind, name, start = current
            if end[1] and end[1].upper() != kind:
                raise ConversionError(f"line {line}: ending kind does not match {kind} {name}")
            if end[2] and end[2].upper() != name.upper():
                raise ConversionError(f"line {line}: ending name does not match {name}")
            if len(statement.lines) != 1:
                raise ConversionError(f"line {line}: continued procedure endings are unsupported")
            if not end[2]:
                try:
                    edits[statement.lines[0]] = named_ending(lines[statement.lines[0]], kind, name)
                except ConversionError as error:
                    raise ConversionError(f"line {line}: {error}") from error
            units.append((start, statement.lines[-1]))
            current = None
        elif not current:
            raise ConversionError(f"line {line}: statement outside an external procedure")
    if current:
        raise ConversionError(f"line {current[2] + 1}: {current[1]} has no ending")

    newline = next((split_line(raw)[1] for raw in lines if split_line(raw)[1]), "\n")
    separators = {end for _, end in units[:-1] if lines[end + 1].strip()}
    output: list[str] = []
    for index, raw in enumerate(lines):
        output.append(edits.get(index, raw))
        if index in separators:
            output.append(newline)
    return Result("".join(output).encode("latin-1"), len(units), len(edits), len(separators))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="fixed-form Fortran source")
    destination = parser.add_mutually_exclusive_group()
    destination.add_argument("-o", "--output", type=Path, help="write a new file; refuse to overwrite an existing file")
    destination.add_argument("--in-place", action="store_true", help="update source after creating source.bak; refuse an existing backup")
    parser.add_argument("--diff", action="store_true", help="also print a unified diff")
    args = parser.parse_args(argv)
    try:
        original = args.source.read_bytes()
        result = transform(original)
        if args.diff:
            sys.stdout.writelines(difflib.unified_diff(
                original.decode("latin-1").splitlines(keepends=True),
                result.data.decode("latin-1").splitlines(keepends=True),
                fromfile=str(args.source), tofile=str(args.output or args.source)))
        if args.output:
            with args.output.open("xb") as stream:
                stream.write(result.data)
        elif args.in_place and result.data != original:
            backup = args.source.with_name(args.source.name + ".bak")
            with backup.open("xb") as stream:
                stream.write(original)
            args.source.write_bytes(result.data)
        action = "Written" if args.output or args.in_place else "Preview (no files changed)"
        print(f"{action}: {result.procedures} procedures; "
              f"{result.endings_changed} endings named; {result.blank_lines_added} blank lines added.")
        return 0
    except (OSError, ConversionError, UnicodeError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
