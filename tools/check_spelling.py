"""Check Markdown prose; keep original line/column positions in CSV reports.

Dependencies: npm ci; python -m pip install -r requirements-spelling.txt
No document is changed by this script. See docs/spelling-checks.md.
"""

import argparse
from collections import Counter, defaultdict
import csv
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
BASELINE = ROOT / "tools/spelling-baseline.json"


def blank(match):
    return re.sub(r"[^\r\n]", " ", match.group())


def prose(text):
    # Mask rather than remove text, so reports refer to the original documents.
    text = re.sub(r"(?ms)^(`{3,}|~{3,})[^\n]*\n.*?^\1[ \t]*\r?$", blank, text)
    # OCR sometimes contains stray math delimiters. Only pair display delimiters
    # on their own lines, so one bad symbol cannot hide whole manual chapters.
    text = re.sub(r"(?ms)^[ \t]*\$\$[ \t]*\r?\n.*?^[ \t]*\$\$[ \t]*\r?$", blank, text)
    text = re.sub(r"(?ms)^[ \t]*\\\[[ \t]*\r?\n.*?^[ \t]*\\\][ \t]*\r?$", blank, text)
    text = re.sub(r"\$\$[^\n]*?\$\$|\\\[[^\n]*?\\\]|\\\([^\n]*?\\\)", blank, text)
    text = re.sub(r"(?m)(?<!\\)\$[^\n$]+(?<!\\)\$|`+[^`\n]*`+", blank, text)
    text = re.sub(r"(?s)<!--.*?-->|<[^>\n]+>", blank, text)
    text = re.sub(r"(?<=\])\([^\n)]*\)|https?://[^\s<>]+", blank, text)
    # Interface/index tables contain identifiers, not narrative prose.
    text = re.sub(r"(?m)^[ \t]*\|[^\n]*", blank, text)
    return text


def routine_names():
    source = (ROOT / "nswc.f").read_text(encoding="utf-8")
    statements = []
    for line in source.splitlines():
        if len(line) < 7 or line[0] in "Cc*!":
            continue
        if line[5] not in " 0" and statements:
            statements[-1] += " " + line[6:72]
        else:
            statements.append(line[6:72])
    names = set()
    for statement in statements:
        match = re.match(
            r"(?i)\s*(?:(?:DOUBLE PRECISION|REAL|INTEGER|COMPLEX|LOGICAL)(?:\*\d+)?\s+)?"
            r"(?:SUBROUTINE|FUNCTION)\s+([A-Z][A-Z0-9_]*)\s*(?:\(([^)]*)\))?", statement)
        if match:
            names.add(match[1])
            names.update(re.findall(r"[A-Za-z][A-Za-z0-9_]*", match[2] or ""))
    return sorted(names)


def run(command, cwd, allowed=(0, 1)):
    result = subprocess.run(command, cwd=cwd, capture_output=True, encoding="utf-8", timeout=180)
    if result.returncode not in allowed or result.stderr.strip():
        raise RuntimeError(f"Check failed: {command[0]}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def check():
    files = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "--", "*.md"],
        cwd=ROOT, encoding="utf-8").splitlines()
    files = sorted(set(files))
    issues = []
    originals = {}
    with tempfile.TemporaryDirectory(prefix="nswc-spelling-") as folder:
        temp = Path(folder)
        for name in files:
            original = (ROOT / name).read_text(encoding="utf-8")
            originals[name] = original.splitlines()
            target = temp / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(prose(original), encoding="utf-8")
        config = json.loads((ROOT / "cspell.json").read_text(encoding="utf-8"))
        config["words"] += routine_names()
        (temp / "cspell.json").write_text(json.dumps(config), encoding="utf-8")
        cspell = ROOT / "node_modules/cspell/bin.mjs"
        output = run(["node", str(cspell), "lint", "**/*.md", "--no-progress",
                      "--no-summary", "--no-color", "--max-file-size", "5MB",
                      "--issue-template", "$filename\t$row\t$col\t$text"], temp)
        for line in output.splitlines():
            parts = line.split("\t")
            if len(parts) != 4:
                raise RuntimeError(f"Unexpected CSpell output: {line}")
            name, row, col, word = parts
            path = Path(name)
            if path.is_absolute():
                name = path.relative_to(temp).as_posix()
            else:
                name = path.as_posix()
            issues.append(dict(tool="cspell", file=name, line=int(row),
                               column=int(col), word=word, suggestion=""))
        output = run([sys.executable, "-m", "codespell_lib", "--builtin", "clear",
                      "--ignore-words-list", ",".join(name.lower() for name in config["words"]),
                      "--disable-colors", *files], temp, allowed=(0, 65))
        for line in output.splitlines():
            match = re.match(r"(.+?):(\d+): (\S+) ==> (.*)", line)
            if not match:
                raise RuntimeError(f"Unexpected Codespell output: {line}")
            name, row, word, suggestion = match.groups()
            name = Path(name).as_posix()
            issues.append(dict(tool="codespell", file=name, line=int(row),
                               column="", word=word, suggestion=suggestion))
        # OCR can produce short valid fragments that dictionary tools miss.
        for name in files:
            for row, line in enumerate((temp / name).read_text(encoding="utf-8").splitlines(), 1):
                for match in re.finditer(r"\b(?:[Ii]t ig|[Tt]t is) assumed\b", line):
                    issues.append(dict(tool="ocr", file=name, line=row,
                                       column=match.start() + 1, word=match.group(),
                                       suggestion="It is assumed" if match.group()[0].isupper() else "it is assumed"))
    for issue in issues:
        issue["context"] = originals[issue["file"]][issue["line"] - 1].strip()
    return files, issues


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report-only", action="store_true", help="Do not fail on spelling findings")
    parser.add_argument("--update-baseline", action="store_true", help="Record current unresolved findings")
    args = parser.parse_args()
    files, issues = check()
    report = ROOT / "reports"
    report.mkdir(exist_ok=True)
    issues.sort(key=lambda x: (x["word"].casefold(), x["tool"], x["file"], x["line"]))
    with (report / "spelling.csv").open("w", newline="", encoding="utf-8-sig") as stream:
        writer = csv.DictWriter(stream, fieldnames=["tool", "file", "line", "column", "word", "suggestion", "context"])
        writer.writeheader()
        writer.writerows(issues)
    groups = defaultdict(list)
    for issue in issues:
        groups[(issue["tool"], issue["word"].casefold())].append(issue)
    with (report / "spelling-grouped.csv").open("w", newline="", encoding="utf-8-sig") as stream:
        writer = csv.writer(stream)
        writer.writerow(["tool", "word", "occurrences", "suggestions", "locations"])
        for (tool, word), group in sorted(groups.items()):
            writer.writerow([tool, word, len(group),
                             "; ".join(sorted({i["suggestion"] for i in group if i["suggestion"]})),
                             "; ".join(f'{i["file"]}:{i["line"]}' for i in group)])
    counts = Counter({f"{tool}:{word}": len(group) for (tool, word), group in groups.items()})
    if args.update_baseline:
        BASELINE.write_text(json.dumps(dict(sorted(counts.items())), indent=2) + "\n", encoding="utf-8")
    baseline = json.loads(BASELINE.read_text(encoding="utf-8")) if BASELINE.exists() else {}
    new = {key: count - baseline.get(key, 0) for key, count in counts.items() if count > baseline.get(key, 0)}
    print(f"Checked {len(files)} Markdown files: {len(issues)} findings in {len(groups)} groups.")
    print("Reports: reports/spelling.csv and reports/spelling-grouped.csv")
    for key, count in sorted(new.items()):
        print(f"  +{count} {key}")
    print(f"{sum(new.values())} findings exceed the existing baseline.")
    return 1 if new and not args.report_only else 0


if __name__ == "__main__":
    sys.exit(main())
