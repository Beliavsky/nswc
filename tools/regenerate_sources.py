"""Generate free-form source, browseable partitions, and Markdown source links.

The maintained input is nswc.f. Run with --check to detect stale generated files.
Existing source links are resolved by procedure name before partitions are replaced.
"""

import argparse
import json
from pathlib import Path
import re

from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from sentence_case_comments import sentence_case


ROOT = Path(__file__).resolve().parents[1]
HEADER = re.compile(
    r"^\s*(?:(?:DOUBLE\s*PRECISION|DOUBLE\s*COMPLEX|REAL|INTEGER|COMPLEX|LOGICAL|CHARACTER)"
    r"(?:\*\d+)?\s+)?(?:SUBROUTINE|FUNCTION)\s+(\w+)", re.I)
LINK = re.compile(
    r"\[([^\]]*)\]\(([^()]*source_parts/(nswc_part_\d+\.(?:f90|f)))#L(\d+)\)")


def generate(root=ROOT):
    original_free = lowercase(convert_text((root / "nswc.f").read_text(encoding="ascii")))
    comments = sentence_case(original_free)
    free = comments.text
    lines = free.splitlines(keepends=True)
    declarations = {}
    for number, line in enumerate(lines, 1):
        match = HEADER.match(line)
        if match and not line.lstrip().startswith("!"):
            name = match[1].upper()
            if name in declarations:
                raise ValueError(f"Duplicate procedure: {name}")
            declarations[name] = number
    if len(declarations) != 1062:
        raise ValueError(f"Expected 1062 procedures, found {len(declarations)}")

    # Start each partition at a declaration; keep complete procedures together.
    starts = [1]
    for number in declarations.values():
        if number - starts[-1] >= 10500:
            starts.append(number)
    bounds = starts + [len(lines) + 1]
    outputs = {root / "nswc.f90": free,
               root / 'tools/comment-case-review.json': json.dumps(comments.report(original_free), indent=2) + '\n'}
    locations = {}
    for index, start in enumerate(starts):
        end = bounds[index + 1]
        filename = f"nswc_part_{index + 1:02d}.f90"
        outputs[root / "source_parts" / filename] = "".join(lines[start - 1:end - 1])
        for name, number in declarations.items():
            if start <= number < end:
                locations[name] = (filename, number - start + 1, number)

    old_parts = {}
    count = 0

    def update_link(match):
        nonlocal count
        label, target, filename, number = match.groups()
        if filename not in old_parts:
            old_parts[filename] = (root / "source_parts" / filename).read_text().splitlines()
        old_line = old_parts[filename][int(number) - 1]
        declaration = HEADER.match(old_line)
        if not declaration:
            raise ValueError(f"Source link does not target a declaration: {target}#L{number}")
        name = declaration[1].upper()
        new_file, local, absolute = locations[name]
        if re.fullmatch(r"`?L\d+`?", label):
            label = f"`L{absolute}`" if label.startswith("`") else f"L{absolute}"
        elif label.isdigit():
            label = str(absolute)
        prefix = target[:target.rindex("source_parts/")]
        count += 1
        return f"[{label}]({prefix}source_parts/{new_file}#L{local})"

    for path in [*root.glob("*.md"), *(root / "docs").glob("*.md")]:
        text = path.read_text(encoding="utf-8")
        updated = LINK.sub(update_link, text)
        if updated != text:
            outputs[path] = updated
    return outputs, count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Check without writing")
    args = parser.parse_args()
    outputs, links = generate()
    obsolete = [path for path in (ROOT / "source_parts").glob("nswc_part_*.f*")
                if re.fullmatch(r"nswc_part_\d+\.(?:f|f90)", path.name) and path not in outputs]
    changed = [path for path, text in outputs.items()
               if not path.exists() or path.read_bytes() != text.encode("utf-8")]
    if args.check:
        for path in changed + obsolete:
            print(f"Stale: {path.relative_to(ROOT)}")
        print(f"Checked 1062 procedures and {links} source links.")
        return int(bool(changed or obsolete))
    for path in changed:
        path.write_text(outputs[path], encoding="utf-8", newline="\n")
    for path in obsolete:
        path.unlink()
    print(f"Generated nswc.f90 and partitions; updated {links} source links.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
