#!/usr/bin/env python3
"""Fixed-to-free conversion adapted from C:/python/fortran/xfree.py.

Repository copy: adds DATA array spacing and wraps long FORMAT statements.
Used by regenerate_sources.py; this module does not write files.
"""

from __future__ import annotations

from dataclasses import dataclass
import re
from typing import List, Optional


@dataclass
class PendingStmt:
    """Track one in-progress fixed-form statement across continuations."""

    label: str
    parts: List[str]



def normalize_comment_line(raw: str) -> str:
    """Convert fixed-form comment markers in column 1 to free-form ! comments."""
    if not raw:
        return "!"
    first = raw[0]
    tail = raw[1:].rstrip("\r\n")
    if first == "!":
        return "!" + tail
    return "!" + tail


def normalize_exponent_blanks(code: str) -> str:
    """Normalize numeric exponent blanks such as '-1. D0' -> '-1.D0' outside strings."""
    def _fix_chunk(chunk: str) -> str:
        chunk = re.sub(
            r"(?i)([0-9.])\s+([deq])\s*([+-]?)\s*(\d+)",
            r"\1\2\3\4",
            chunk,
        )
        # Also handle no-blank-before-exponent forms with blank after exponent
        # letter, e.g. ".121699028117870E 1" -> ".121699028117870E1".
        chunk = re.sub(
            r"(?i)(?<=\d)([deq])\s+([+-]?\d+)",
            r"\1\2",
            chunk,
        )
        # Join split mantissa fragments in numeric literals continued with
        # blanks, including multiple groups:
        # "0.6931471805 5994530941 7232121458 18D0"
        # -> "0.69314718055994530941723212145818D0".
        def _join_split_real(m: re.Match[str]) -> str:
            return re.sub(r"\s+", "", m.group(0))
        chunk = re.sub(
            r"(?i)[+-]?(?:\d+\.\d*|\.\d+)(?:\s+\d+)+\s*[deq][+-]?\d+",
            _join_split_real,
            chunk,
        )
        # Join split decimal groups without exponent when followed by a
        # delimiter (common in complex constants), e.g.
        # "1.414213562 3730950488)" -> "1.4142135623730950488)".
        chunk = re.sub(
            r"(?i)([+-]?(?:\d+\.\d*|\.\d+)(?:\s+\d+)+)(?=\s*[,)/])",
            _join_split_real,
            chunk,
        )
        chunk = re.sub(
            r"(?i)\.(and|or|not|eqv|neqv|eq|ne|lt|le|gt|ge)\s+\.",
            lambda m: f".{m.group(1)}.",
            chunk,
        )
        chunk = re.sub(
            r"(?i)\.\s+(and|or|not|eqv|neqv|eq|ne|lt|le|gt|ge)\.",
            lambda m: f".{m.group(1)}.",
            chunk,
        )
        # Some fixed-form sources compact typed function headers, e.g.
        # "characterfunctionx(i)". Free form requires separators.
        chunk = re.sub(
            r"(?i)^(\s*)character\s*\*\s*(\d+)\s*function\s*([a-z_]\w*)",
            r"\1character*\2 function \3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*character\s*\*\s*)([0-9 ]+)([a-z_]\w*)\s*$",
            lambda m: f"{m.group(1)}{re.sub(r'\s+', '', m.group(2))} {m.group(3)}",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)double\s*precision\s*function\s*([a-z_]\w*)",
            r"\1double precision function \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)doubleprecisionfunction\s*([a-z_]\w*)",
            r"\1double precision function \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*(?:character\s*\*\s*(?:\d+|\([^)]*\))|character|"
            r"integer|real|logical|complex|double\s*precision))\s*function([a-z_]\w*)",
            r"\1 function \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)(character|integer|real|logical|complex)\s*function\s*([a-z_]\w*)",
            r"\1\2 function \3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)(character|integer|real|logical|complex)function\s*([a-z_]\w*)",
            r"\1\2 function \3",
            chunk,
        )
        type_prefix = (
            r"(?:character\s*\*\s*(?:\d+|\([^)]*\))|character|"
            r"integer\s*\*\s*\d+|integer|real\s*\*\s*\d+|real|"
            r"logical\s*\*\s*\d+|logical|complex\s*\*\s*\d+|complex|"
            r"double\s*precision)"
        )
        chunk = re.sub(
            rf"(?i)^(\s*)({type_prefix})\b\s*([a-z_])",
            lambda m: f"{m.group(1)}{m.group(2)} {m.group(3)}",
            chunk,
        )
        m_do = re.match(r"(?i)^(\s*)do\s*(\d+)\s*([a-z_]\w*)\s*=\s*(.+)$", chunk)
        if m_do:
            if "," in m_do.group(4):
                chunk = f"{m_do.group(1)}do {m_do.group(2)} {m_do.group(3)} = {m_do.group(4)}"
            else:
                chunk = f"{m_do.group(1)}do{m_do.group(2)}{m_do.group(3)} = {m_do.group(4)}"
        chunk = re.sub(
            r"(?i)^(\s*)do\s*(\d+)\s*while\s*(\(.*\))\s*$",
            r"\1do \2 while \3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)dowhile\s*(\(.*\))\s*$",
            r"\1do while \2",
            chunk,
        )
        # Fixed-form ignores blanks, so CALL statements can appear as CALLFOO(...).
        # Insert required blank after CALL token.
        chunk = re.sub(
            r"(?i)\bcall([a-z_]\w*)(\s*\()",
            r"call \1\2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)\bcall([a-z_]\w*)\b$",
            r"call \1",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*if\s*\([^)]*\)\s*)(goto|read|print|pause|stop|rewind|backspace|endfile)\s*(\d+)\s*$",
            r"\1\2 \3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*if\s*\([^)]*\)\s*)(read|print)\s*(\d+)(\s*,.*)$",
            r"\1\2 \3\4",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*if\s*\([^)]*\)\s*)return\s*(\d+)\s*$",
            r"\1return \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)assign\s*(\d+)\s*to\s*([a-z_]\w*)\s*$",
            r"\1assign \2 to \3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*\d*\s*)f\s*o\s*r\s*m\s*a\s*t\s*(\()",
            r"\1format \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)data([a-z_]\w*)(\s*(?:\([^/]*\))?\s*/.*)$",
            r"\1data \2\3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)data([a-z_]\w*)(?=\s*\()",
            r"\1data \2", chunk,
        )
        # Fixed form ignores blanks in names, so constructs like
        # "DATA AIF CS(1) / ... /" are equivalent to "DATA AIFCS(1) / ... /".
        # In free form, merge split identifier fragments in DATA object lists
        # when the second fragment is immediately followed by a subscript.
        md = re.match(r"(?i)^(\s*(?:\d+\s+)?data\s+)(.+)$", chunk)
        if md:
            head = md.group(1)
            tail = md.group(2)
            while True:
                new_tail = re.sub(
                    r"(?i)\b([a-z_]\w*)\s+([a-z_]\w*)(\s*\()",
                    r"\1\2\3",
                    tail,
                )
                if new_tail == tail:
                    break
                tail = new_tail
            chunk = head + tail
        chunk = re.sub(
            r"(?i)^(\s*)dimension([a-z_]\w*)(\s*\(.*)$",
            r"\1dimension \2\3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)external([a-z_]\w*)\s*$",
            r"\1external \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)save([a-z_]\w*)\s*$",
            r"\1save \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)intrinsic([a-z_]\w*)\s*$",
            r"\1intrinsic \2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)implicit(real|integer|logical|complex|character|double\s*precision)(\s*\(.*)$",
            r"\1implicit \2\3",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)implicitnone(\s*)$",
            r"\1implicit none\2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)blockdata(\s*)$",
            r"\1block data\2",
            chunk,
        )
        chunk = re.sub(
            r"(?i)^(\s*)blockdata([a-z_]\w*)\s*$",
            r"\1block data \2",
            chunk,
        )
        return chunk

    out: List[str] = []
    cur: List[str] = []
    in_single = False
    in_double = False
    for ch in code:
        if ch == "'" and not in_double:
            if not in_single:
                out.append(_fix_chunk("".join(cur)))
                cur = []
            in_single = not in_single
            out.append(ch)
            continue
        if ch == '"' and not in_single:
            if not in_double:
                out.append(_fix_chunk("".join(cur)))
                cur = []
            in_double = not in_double
            out.append(ch)
            continue
        if in_single or in_double:
            out.append(ch)
        else:
            cur.append(ch)
    if cur:
        out.append(_fix_chunk("".join(cur)))
    return "".join(out)


def flush_stmt(pending: Optional[PendingStmt], out_lines: List[str]) -> Optional[PendingStmt]:
    """Flush a pending statement into output lines."""
    if pending is None:
        return None
    parts = [p.rstrip() for p in pending.parts if p is not None]
    if not parts:
        return None

    # Some fixed-form sources rely on extension behavior for EXTERNAL/INTRINSIC
    # name lists split across continuation lines without a comma. In free form,
    # that can make the first line syntactically complete before '&'. Insert
    # a missing comma at continuation boundaries when both sides are names.
    head = parts[0].lstrip().upper()
    is_name_list_stmt = head.startswith("EXTERNAL") or head.startswith("INTRINSIC")
    if is_name_list_stmt:
        fixed_parts: List[str] = [parts[0]]
        for nxt in parts[1:]:
            prev = fixed_parts[-1]
            prev_r = prev.rstrip()
            nxt_l = nxt.lstrip()
            if (
                prev_r
                and nxt_l
                and re.search(r"[A-Z0-9_]$", prev_r, flags=re.IGNORECASE)
                and re.match(r"[A-Z_]", nxt_l, flags=re.IGNORECASE)
                and not prev_r.endswith(",")
            ):
                fixed_parts[-1] = prev_r + ","
            fixed_parts.append(nxt)
        parts = fixed_parts

    # Fixed form can continue in the middle of identifiers/numbers. Free form
    # cannot split lexical tokens across continuation lines, so merge such
    # fragments before emitting '&' continuations.
    merged_parts: List[str] = [parts[0]]
    for nxt in parts[1:]:
        prev_r = merged_parts[-1].rstrip()
        nxt_l = nxt.lstrip()
        join_lexical = (
            prev_r
            and nxt_l
            and re.search(r"[A-Z0-9_]$", prev_r, flags=re.IGNORECASE)
            and re.match(r"[A-Z0-9_]", nxt_l, flags=re.IGNORECASE)
        )
        # Fixed-form continuation can split logical operators:
        # ".AND" + ".X" => ".AND.X", "." + "OR.X" => ".OR.X"
        join_logop = (
            prev_r
            and nxt_l
            and (
                (
                    re.search(r"(?i)\.(?:and|or|not|eqv|neqv|eq|ne|lt|le|gt|ge)$", prev_r)
                    and nxt_l.startswith(".")
                )
                or (
                    prev_r.endswith(".")
                    and re.match(r"(?i)(?:and|or|not|eqv|neqv|eq|ne|lt|le|gt|ge)\.", nxt_l)
                )
            )
        )
        # Split exponent sign across continuation: "...E+" + "03".
        join_exponent = (
            prev_r
            and nxt_l
            and re.search(r"(?i)[deq][+-]$", prev_r)
            and re.match(r"^\d", nxt_l)
        )
        # Split exponent after a trailing decimal point: "0." + "E0".
        join_decimal_exp = (
            prev_r
            and nxt_l
            and re.search(r"(?i)\.$", prev_r)
            and re.match(r"(?i)^[deq][+-]?\d", nxt_l)
        )
        if (
            join_lexical
            or join_logop
            or join_exponent
            or join_decimal_exp
        ):
            # Keep a separating blank when a declaration keyword ends the prior
            # fragment (e.g. "INTEGER" + "NX,NY" should become "INTEGER NX,NY").
            if re.search(
                r"(?i)\b(?:integer|real|logical|complex|character|double\s*precision)\s*$",
                prev_r,
            ):
                merged_parts[-1] = prev_r + " " + nxt_l
            else:
                merged_parts[-1] = prev_r + nxt_l
        else:
            merged_parts.append(nxt_l)
    parts = merged_parts

    # Hollerith FORMAT text can be split across fixed-form continuation records.
    # In free form this must stay a single lexical token stream (continuation
    # with '&' inside the token is invalid), so collapse into one line.
    head0 = parts[0].lstrip()
    is_format_stmt = bool(re.match(r"(?i)^(?:\d+\s+)?format\b", head0))
    has_hollerith = any(re.search(r"(?i)\b\d+\s*h", p) for p in parts)
    if len(parts) > 1 and is_format_stmt and has_hollerith:
        merged = parts[0].rstrip()
        for nxt in parts[1:]:
            merged += nxt.lstrip()
        parts = [merged]

    # Re-run token normalizations after continuation merges, since fixed-form
    # split points can hide transforms (e.g. CALLX + ERROR(...) -> CALL XERROR).
    parts = [normalize_exponent_blanks(p) for p in parts]

    if len(parts) == 1:
        body = parts[0].rstrip()
        if not body:
            return None
        if pending.label:
            out_lines.append(f"{pending.label} {body.lstrip()}")
        else:
            out_lines.append(body)
        return None

    first = parts[0].rstrip()
    if pending.label:
        out_lines.append(f"{pending.label} {first.lstrip()} &")
    else:
        out_lines.append(f"{first} &")

    for mid in parts[1:-1]:
        out_lines.append(f"&{mid.lstrip()} &")
    out_lines.append(f"&{parts[-1].lstrip()}")
    return None


def convert_text(text: str) -> str:
    """Convert fixed-form source text to free-form source text."""
    out_lines: List[str] = []
    pending: Optional[PendingStmt] = None
    deferred_comments: List[str] = []

    def flush_pending() -> None:
        nonlocal pending
        pending = flush_stmt(pending, out_lines)
        if deferred_comments:
            out_lines.extend(deferred_comments)
            deferred_comments.clear()

    for raw in text.splitlines():
        # Fixed-form columns are position-based; expand tabs before parsing
        # label/continuation fields to avoid misclassifying lines such as
        # "  60<TAB> CONTINUE" as continuations.
        fixed = raw.expandtabs(8)
        if raw.strip() == "":
            flush_pending()
            out_lines.append("")
            continue

        # Fixed-form full-line comments in column 1.
        if raw and raw[0] in {"c", "C", "*", "!"}:
            comment = normalize_comment_line(raw)
            if pending is None:
                out_lines.append(comment)
            else:
                # In fixed form, comment lines may appear between continuation
                # records without ending the statement.
                deferred_comments.append(comment)
            continue

        # Some sources place '!' in the fixed-form label field (columns 1-5).
        # Treat that as a full comment line.
        if "!" in fixed[:5]:
            bang = fixed[:5].find("!")
            if fixed[:bang].strip() == "":
                flush_pending()
                out_lines.append("!" + fixed[bang + 1 :].rstrip("\r\n"))
                continue

        # Preprocessor/directive lines in column 1.
        if raw and raw[0] == "#":
            flush_pending()
            out_lines.append(raw.rstrip("\r\n"))
            continue

        # Fixed-form fields.
        label = fixed[:5].strip() if len(fixed) >= 5 else fixed.strip()
        cont_col = fixed[5] if len(fixed) >= 6 else " "
        code = (fixed[6:72] if len(fixed) > 6 else "").rstrip()
        code = normalize_exponent_blanks(code)
        is_cont = (cont_col not in {" ", "0"})

        if code.lstrip().startswith("!"):
            flush_pending()
            out_lines.append(code.lstrip())
            continue

        if is_cont:
            if pending is None:
                pending = PendingStmt(label="", parts=[code])
            else:
                pending.parts.append(code)
            continue

        flush_pending()
        pending = PendingStmt(label=label, parts=[code])

    flush_pending()
    return "\n".join(wrap_format_lines(out_lines)) + "\n"


def wrap_format_lines(lines: List[str]) -> List[str]:
    """Wrap long FORMATs between descriptors, never inside Hollerith text."""
    output = []
    for line in lines:
        if len(line) <= 132 or line.lstrip().startswith("!"):
            output.append(line)
            continue
        if not re.match(r"(?i)^\s*(?:\d+\s+)?format\s*\(", line):
            raise ValueError("Unexpected code line longer than 132 columns")
        breaks = []
        i = 0
        while i < len(line):
            if line[i] in "\"'":
                quote = line[i]
                i += 1
                while i < len(line):
                    if line[i] == quote:
                        i += 1
                        if i < len(line) and line[i] == quote:
                            i += 1
                            continue
                        break
                    i += 1
                continue
            hollerith = re.match(r"(\d+)[hH]", line[i:])
            if hollerith:
                i += len(hollerith[0]) + int(hollerith[1])
                continue
            if line[i] in "/,":
                breaks.append(i + 1)
            i += 1
        start = 0
        while len(line) - start > 120:
            choices = [pos for pos in breaks if start < pos <= start + 116]
            if not choices:
                raise ValueError("FORMAT cannot be wrapped outside literal text")
            stop = max(choices)
            output.append(("&" if start else "") + line[start:stop] + " &")
            start = stop
        output.append(("&" if start else "") + line[start:])
    return output
