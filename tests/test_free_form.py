"""Check conversion, complete-library statements, and generated source links."""

from pathlib import Path
import re
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from fixed_to_free import convert_text
from regenerate_sources import generate, HEADER, LINK
from lowercase_fortran import lowercase
from sentence_case_comments import sentence_case
from format_free_form import format_source, semantic_statements
from procedure_purity import transform as apply_purity


def canonical(statement):
    """Ignore fixed-form whitespace while preserving quoted/Hollerith text."""
    output = []
    i = 0
    while i < len(statement):
        char = statement[i]
        if char in "\"'":
            quote = char
            start = i
            i += 1
            while i < len(statement):
                if statement[i] == quote:
                    i += 1
                    if i < len(statement) and statement[i] == quote:
                        i += 1
                        continue
                    break
                i += 1
            output.append(statement[start:i])
            continue
        hollerith = re.match(r"(\d+)[hH]", statement[i:]) if char.isdigit() else None
        if hollerith and (i == 0 or not statement[i - 1].isalnum()):
            length = len(hollerith[0])
            count = int(hollerith[1])
            output.append(hollerith[0].upper() + statement[i + length:i + length + count])
            i += length + count
            continue
        if char == "!":
            break
        if not char.isspace():
            output.append(char.upper())
        i += 1
    return "".join(output)


def statements(text, fixed):
    pending = ""
    results = []
    continuing = False
    for line in text.splitlines():
        if not line.strip() or (fixed and line[0] in "Cc*!") or line.lstrip().startswith("!"):
            continue
        if fixed:
            continued = len(line) > 5 and line[5] not in " 0"
            if not continued and pending:
                results.append(canonical(pending))
                pending = ""
            if not continued:
                pending = line[:5].strip() + " "
            pending += line[6:72]
        else:
            code = line.lstrip()
            if continuing and code.startswith("&"):
                code = code[1:]
            continuing = code.rstrip().endswith("&")
            pending += code.rstrip()[:-1] if continuing else code
            if not continuing:
                results.append(canonical(pending))
                pending = ""
    if pending:
        results.append(canonical(pending))
    return results


class FreeFormTests(unittest.TestCase):
    def test_compact_data_arrays(self):
        source = "      DATAA0(1) /1./\n      DATAP(1),P(2) /1.,2./\n"
        converted = convert_text(source)
        self.assertIn("data A0(1)", converted)
        self.assertIn("data P(1)", converted)
        self.assertEqual(statements(source, True), statements(converted, False))

    def test_hollerith_wrapping_preserves_text(self):
        literal = "a/b,c" * 10
        source = ("  100 FORMAT (50H" + literal + "/\n"
                  "     *50H" + literal + "/50H" + literal + ")\n")
        # Keep each original statement field within column 72.
        source = source.replace("/50H", "/\n     *50H")
        converted = convert_text(source)
        self.assertTrue(all(len(line) <= 132 for line in converted.splitlines()))
        self.assertEqual(statements(source, True), statements(converted, False))

    def test_complete_library_statements(self):
        source = (ROOT / "nswc.f").read_text()
        converted = lowercase(convert_text(source))
        # Full-line comments and every quoted value must survive conversion.
        original_free = convert_text(source)
        self.assertEqual(len(original_free), len(converted))
        for before, after in zip(original_free.splitlines(True), converted.splitlines(True)):
            if before.lstrip().startswith('!'):
                self.assertEqual(before, after)
            for old, new in zip(before, after):
                self.assertTrue(old == new or ('A' <= old <= 'Z' and new == old.lower()))
        self.assertEqual(statements(source, True), statements(converted, False))
        formatted = format_source(converted)
        self.assertEqual(semantic_statements(converted), semantic_statements(formatted))
        self.assertEqual(format_source(formatted), formatted)
        self.assertEqual([s for s in converted.splitlines(True) if s.lstrip().startswith('!')],
                         [s for s in formatted.splitlines(True) if s.lstrip().startswith('!')])
        comments = sentence_case(formatted)
        self.assertEqual(len(formatted), len(comments.text))
        self.assertEqual([s for s in formatted.splitlines(True) if not s.lstrip().startswith('!')],
                         [s for s in comments.text.splitlines(True) if not s.lstrip().startswith('!')])
        self.assertEqual(statements(formatted, False), statements(comments.text, False))
        self.assertEqual(sentence_case(comments.text).text, comments.text)
        self.assertEqual(apply_purity(comments.text), (ROOT / "nswc.f90").read_text())

    def test_generated_partitions_and_links(self):
        outputs, count = generate()
        self.assertEqual(count, 2214)
        for path, text in outputs.items():
            self.assertEqual(path.read_bytes(), text.encode("utf-8"), str(path))
        parts = sorted((ROOT / "source_parts").glob("nswc_part_*.f90"))
        self.assertEqual("".join(p.read_text() for p in parts), (ROOT / "nswc.f90").read_text())
        part_lines = {p.name: p.read_text().splitlines() for p in parts}
        for path in [*ROOT.glob("*.md"), *(ROOT / "docs").glob("*.md")]:
            for match in LINK.finditer(path.read_text(encoding="utf-8")):
                label, _, filename, number = match.groups()
                self.assertTrue(filename.endswith(".f90"))
                line = part_lines[filename][int(number) - 1]
                self.assertIsNotNone(HEADER.match(line), match[0])


if __name__ == "__main__":
    unittest.main()
