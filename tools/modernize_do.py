"""Conservatively replace labelled DO/CONTINUE loops in fixed-form Fortran.

Adapted from the stack/candidate approach in C:/python/fortran/xloop.py.
This standalone version scopes labels to external procedures and only converts
single-record headers with unique, unreferenced CONTINUE terminators. Numeric
mentions are treated as possible label references, so uncertain cases are left
unchanged. Default: preview only. No files are modified unless requested.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
import csv
from dataclasses import dataclass
import difflib
from pathlib import Path
import re
import sys

from name_procedure_ends import (
    ConversionError, ENDING, FUNCTION, SUBROUTINE, UNSUPPORTED,
    code_comment, split_line, statements,
)


@dataclass(frozen=True)
class Loop:
    procedure: str
    line: int
    end_line: int | None
    label: str
    status: str
    reason: str


@dataclass(frozen=True)
class Result:
    data: bytes
    loops: tuple[Loop, ...]


def masked(code):
    """Hide literal contents so their digits cannot be mistaken for labels."""
    output = []
    i = 0
    while i < len(code):
        if code[i] in "\"'":
            quote = code[i]
            output.append(" ")
            i += 1
            while i < len(code):
                if code[i] == quote:
                    i += 1
                    if i < len(code) and code[i] == quote:
                        i += 1
                        continue
                    break
                i += 1
            continue
        h = re.match(r"(\d+)[hH]", code[i:]) if code[i].isdigit() else None
        if h and (i == 0 or not code[i - 1].isalnum()):
            i += len(h[0]) + int(h[1])
            output.append(" ")
            continue
        output.append(code[i])
        i += 1
    return "".join(output)


def has_comma(code):
    depth = 0
    for char in code:
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            return True
    return False


def analyze_unit(name, unit, lines):
    labels = {}
    mentions = defaultdict(set)
    headers = {}
    compact = [re.sub(r"\s+", "", masked(s.code)).upper() for s in unit]
    blocked = ""
    for index, (statement, code) in enumerate(zip(unit, compact)):
        label = lines[statement.lines[0]][:5].strip()
        if label:
            label = str(int(label))
            if label in labels:
                raise ConversionError(f"{name}: duplicate statement label {label}")
            labels[label] = index
        for token in re.findall(r"\d+", code):
            # Include integer mentions even in compact DO/ASSIGN syntax. This
            # deliberately overestimates references (array bounds, constants).
            mentions[str(int(token))].add(index)
        match = re.match(r"^DO(\d+)([A-Z][A-Z0-9_]*=.*)$", code)
        if match and has_comma(match[2]):
            headers[index] = str(int(match[1]))
        if re.search(r"GOTO[A-Z_]", code) or code.startswith("ASSIGN"):
            blocked = "procedure contains assigned/computed-indirect control flow"
        if re.match(r"^(?:[A-Z][A-Z0-9_]*:DO|DOCONCURRENT)", code):
            blocked = "procedure contains an unsupported loop construct"
    counts = Counter(headers.values())
    stack = []
    intervals = {}
    malformed = False
    for index, code in enumerate(compact):
        if index in headers:
            stack.append((index, headers[index]))
        elif re.match(r"^DO(?:[A-Z][A-Z0-9_]*=|WHILE\(|$)", code):
            stack.append((index, None))
        if code == "ENDDO" or code.startswith("ENDDO"):
            if not stack or stack[-1][1] is not None:
                malformed = True
            else:
                start, _ = stack.pop()
                intervals[start] = index
        label = lines[unit[index].lines[0]][:5].strip()
        label = str(int(label)) if label else None
        if label and any(target == label for _, target in stack):
            if stack[-1][1] != label:
                malformed = True
            while stack and stack[-1][1] == label:
                start, _ = stack.pop()
                intervals[start] = index
    if stack:
        malformed = True

    edits = {}
    records = []
    for start, target in headers.items():
        end = labels.get(target)
        reason = blocked
        if not reason and malformed:
            reason = "procedure has unmatched or crossing loop boundaries"
        if not reason and counts[target] != 1:
            reason = "shared termination label"
        if not reason and (end is None or end <= start or intervals.get(start) != end):
            reason = "missing or non-structured termination"
        if not reason and compact[end] != "CONTINUE":
            reason = "executable termination statement"
        if not reason and (len(unit[start].lines) != 1 or len(unit[end].lines) != 1):
            reason = "continued header or terminator"
        if not reason and mentions[target] - {start, end}:
            reason = "termination label mentioned elsewhere in procedure"
        if not reason:
            for label, position in labels.items():
                if start < position < end and any(
                    reference < start or reference > end for reference in mentions[label]
                ):
                    reason = "possible branch into loop body"
                    break
        if not reason:
            for position, ending in ((start, False), (end, True)):
                line_number = unit[position].lines[0]
                body, newline = split_line(lines[line_number])
                field, comment, _ = code_comment(body[6:72])
                indent = field[:len(field) - len(field.lstrip())]
                if ending:
                    replacement = "      " + indent + "END DO"
                else:
                    header = re.match(r"\s*DO\s*\d+\s*(.*)", field, re.I)
                    if not header:
                        raise ConversionError("Cannot locate physical DO header")
                    replacement = body[:6] + indent + "DO " + header[1].rstrip()
                if comment:
                    replacement += "  " + comment
                if len(replacement) > 72:
                    reason = "replacement exceeds column 72"
                    break
                if len(body) > 72:
                    replacement = replacement.ljust(72) + body[72:]
                edits[line_number] = replacement + newline
            if reason:
                for position in (start, end):
                    edits.pop(unit[position].lines[0], None)
        records.append(Loop(name, unit[start].lines[0] + 1,
                            unit[end].lines[0] + 1 if end is not None else None,
                            target, "skipped" if reason else "converted", reason))
    return edits, records


def transform(data):
    lines = data.decode("latin-1").splitlines(keepends=True)
    edits = {}
    records = []
    unit = []
    name = None
    for statement in statements(lines):
        code = re.sub(r"\s+", "", statement.code)
        if UNSUPPORTED.match(code):
            raise ConversionError("Only external functions/subroutines are supported")
        declaration = FUNCTION.match(code) or SUBROUTINE.match(code)
        if declaration:
            if name:
                raise ConversionError("Procedure declaration before preceding ending")
            name = declaration[1]
        if name is None:
            raise ConversionError("Statement outside an external procedure")
        unit.append(statement)
        if ENDING.fullmatch(code):
            changes, loops = analyze_unit(name, unit, lines)
            edits.update(changes)
            records.extend(loops)
            unit, name = [], None
    if name:
        raise ConversionError("Missing procedure ending")
    return Result("".join(edits.get(i, raw) for i, raw in enumerate(lines)).encode("latin-1"),
                  tuple(records))


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    destination = parser.add_mutually_exclusive_group()
    destination.add_argument("--output", type=Path)
    destination.add_argument("--in-place", action="store_true")
    parser.add_argument("--report", type=Path, help="New CSV file for candidates and skipped reasons")
    parser.add_argument("--diff", action="store_true")
    args = parser.parse_args(argv)
    try:
        original = args.source.read_bytes()
        result = transform(original)
        backup = Path(str(args.source) + ".loops.bak")
        if args.output and args.output.exists():
            raise ConversionError(f"Output already exists: {args.output}")
        if args.report and args.report.exists():
            raise ConversionError(f"Report already exists: {args.report}")
        if args.in_place and original != result.data and backup.exists():
            raise ConversionError(f"Backup already exists: {backup}")
        if args.output and args.report and args.output.resolve() == args.report.resolve():
            raise ConversionError("Output and report must be separate files")
        if args.report:
            with args.report.open("x", newline="", encoding="utf-8") as file:
                writer = csv.writer(file, lineterminator="\n")
                writer.writerow(Loop.__dataclass_fields__)
                writer.writerows(tuple(vars(loop).values()) for loop in result.loops)
        if args.output:
            with args.output.open("xb") as file:
                file.write(result.data)
        elif args.in_place and original != result.data:
            with backup.open("xb") as file:
                file.write(original)
            args.source.write_bytes(result.data)
        if args.diff:
            print("".join(difflib.unified_diff(original.decode("latin-1").splitlines(True),
                                             result.data.decode("latin-1").splitlines(True),
                                             str(args.source), "converted")), end="")
        counts = Counter(loop.status for loop in result.loops)
        print(f"{counts['converted']} loops converted; {counts['skipped']} skipped"
              + (" (preview only)." if not args.output and not args.in_place else "."))
        for reason, count in Counter(loop.reason for loop in result.loops if loop.reason).most_common():
            print(f"  {count}: {reason}")
        return 0
    except (OSError, ConversionError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
