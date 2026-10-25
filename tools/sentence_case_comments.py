"""Sentence-case selected uppercase prose in free-form Fortran comments.

Executable code, inline comments and directives are preserved. Commented Fortran
and identifiable code references use lowercase. Ordinary words and proper names come from reviewed
source-vocabulary files. Unrecognized words keep their spelling and case.
Only ASCII letter case can change; whitespace and physical lines stay fixed.
"""
import argparse
from collections import Counter
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
WORD = re.compile(r"[A-Za-z][A-Za-z0-9_]*(?:'[A-Za-z]+)?")
COMMENT = re.compile(r'^(\s*!)([^\r\n]*)(\r\n|\r|\n)?$')
CODE = re.compile(r'^(?:(?:CALL|GO\s*TO|GOTO|RETURN|CONTINUE|STOP|END|ELSE)\b|'
                  r'IMPLICIT\b|INTENT\s*\(|DO\s+(?:WHILE|CONCURRENT)\s*\(|'
                  r'(?:SUBROUTINE|FUNCTION)\s+\w+\s*\(|IF\s*\(|DO\s+\d|'
                  r'(?:READ|WRITE|FORMAT|PARAMETER)\s*\(|DATA\s+\w+\s*[/,(]|'
                  r'(?:INTEGER|REAL|COMPLEX|LOGICAL|DIMENSION|COMMON|EXTERNAL|EQUIVALENCE)\s+.*[,(/])', re.I)
FORMULA = re.compile(r'[=<>]|\*\*|\.(?:LE|GE|EQ|NE|LT|GT|AND|OR|NOT)\.', re.I)
CONTEXT = re.compile(r'\b(?:ARGUMENT|VARIABLE|ARRAY|MATRIX|VECTOR|FUNCTION|SUBROUTINE|'
                     r'PARAMETER|ROUTINE|FLAG|LABEL|BLOCK|FUNCTIONS|SUBROUTINES|ROUTINES)\s+(?:NAMED\s+)?(\w+)', re.I)


@dataclass
class Result:
    text: str
    changed_lines: int
    changed_paragraphs: int
    retained: dict
    unknown: dict
    uncertain: list
    technical_lines: int = 0

    def report(self, original):
        return {'input_sha256': hashlib.sha256(original.encode('ascii')).hexdigest(),
                'output_sha256': hashlib.sha256(self.text.encode('ascii')).hexdigest(),
                'rules_sha256': hashlib.sha256((HERE / 'comment-case-rules.json').read_bytes()).hexdigest(),
                'vocabulary_sha256': hashlib.sha256((HERE / 'comment-case-words.txt').read_bytes()).hexdigest(),
                'changed_lines': self.changed_lines, 'changed_paragraphs': self.changed_paragraphs,
                'technical_comment_lines': self.technical_lines,
                'retained_lines': self.retained, 'unrecognized_prose_words': self.unknown,
                'uncertain_prose': self.uncertain}


def settings():
    rules = json.loads((HERE / 'comment-case-rules.json').read_text())
    words = {line for line in (HERE / 'comment-case-words.txt').read_text().splitlines()
             if line and not line.startswith('#')}
    return words, rules


def technical_comments(lines, vocabulary, proper_names):
    """Lowercase code references, using declarations in the enclosing procedure.

    English words that are also identifiers need explicit syntactic context.
    Quoted text, Hollerith payloads and compiler directives retain their case.
    """
    header = re.compile(r'^\s*(?:(?:integer|real|double precision|complex|logical|character)'
                        r'(?:\*\d+)?\s+)?(?:function|subroutine)\s+(\w+)', re.I)
    procedures = {m[1].upper() for line in lines if (m := header.match(line))}
    boundaries = [i for i, line in enumerate(lines) if header.match(line)] + [len(lines)]
    local = set()
    known_names = procedures
    boundary = 0
    count = 0
    for index, line in enumerate(lines):
        if boundary < len(boundaries) - 1 and index == boundaries[boundary]:
            block = lines[index:boundaries[boundary + 1]]
            local = set()
            for code in block:
                if not code.lstrip().startswith('!') and '::' in code:
                    # Declarations are generated without initialization; take entity
                    # names, not words from bounds, literals or inline comments.
                    entities = code.split('::', 1)[1].split('!', 1)[0]
                    entities = re.sub(r'\([^()]*\)', '', entities)
                    local.update(m[1].upper() for m in re.finditer(r'(?:^|,)\s*(\w+)', entities))
            boundary += 1
            known_names = local | procedures
        match = COMMENT.match(line)
        if not match:
            continue
        body = match[2]
        value = body.strip()
        if re.match(r'^(?:\$|[A-Z][A-Z0-9_]*\$|IBM\*|\*DECK)', value, re.I):
            continue
        statement = re.sub(r'^\d+\s+', '', value)
        example = bool(re.match(
            r'^(?:CALL\s+\w+\s*(?:\(|$)|(?:INTEGER|REAL|DOUBLE\s+PRECISION|COMPLEX|LOGICAL|CHARACTER|'
            r'DIMENSION|COMMON|EXTERNAL|EQUIVALENCE|SAVE)\s+\w+\s*(?:$|[,(/])|'
            r'IMPLICIT\s+NONE\s*$|DATA\s+\w+\s*[(/]|PARAMETER\s*\(|'
            r'(?:SUBROUTINE|FUNCTION)\s+\w+\s*\(|DO\s+(?:WHILE|CONCURRENT)\s*\(|'
            r'(?:READ|WRITE|FORMAT|IF|INTENT)\s*\(|DO\s+(?:\d+\s+)?\w+\s*=|'
            r'(?:RETURN|CONTINUE|END(?:\s+DO)?|STOP)\s*(?:\d+)?\s*$)', statement, re.I))
        assignment = re.match(r'^\w+(?:\([^)]*\))?\s*=', statement)
        if assignment and not re.search(r'[A-Za-z]+\s+[A-Za-z]+', statement[assignment.end():]):
            example = True
        # Protect strings (including doubled delimiters) and counted Hollerith data.
        protected = []
        token = re.compile(r"'(?:[^']|'')*'|\"(?:[^\"]|\"\")*\"|(?<!\w)(\d+)[hH]")
        end = 0
        for item in token.finditer(body):
            if item.start() < end:
                continue
            end = item.end() + (int(item[1]) if item[1] else 0)
            protected.append((item.start(), end))
        protected.extend(m.span() for m in re.finditer(r'\b(?:[A-Z]\.\s*){2,}', body))
        explicit = {m[1].upper() for m in CONTEXT.finditer(body)
                    if m[1].upper() in known_names or
                    (len(m[1]) > 1 and m[1].lower() not in vocabulary and m[1].upper() not in proper_names)}
        field = re.match(r'^\s*(\w+)\s*[-:=]', body)
        if field and field[1].upper() in local:
            explicit.add(field[1].upper())
        greek = {'ALPHA', 'BETA', 'GAMMA', 'DELTA', 'EPSILON', 'ZETA', 'ETA', 'THETA',
                 'IOTA', 'KAPPA', 'LAMBDA', 'MU', 'NU', 'XI', 'OMICRON', 'PI', 'RHO',
                 'SIGMA', 'TAU', 'UPSILON', 'PHI', 'CHI', 'PSI', 'OMEGA'}
        explicit.update(local & greek)
        intrinsic = {'ABS', 'DABS', 'SQRT', 'DSQRT', 'EXP', 'DEXP', 'LOG', 'DLOG',
                     'SIN', 'COS', 'TAN', 'MIN', 'MAX', 'MOD', 'SIGN', 'INT', 'REAL',
                     'DBLE', 'AIMAG', 'CMPLX', 'CONJG', 'LEN', 'SIZE', 'SUM'}
        # Function/array notation and purely symbolic parenthesized expressions.
        math = [m.span() for m in re.finditer(r'\b\w+\s*\([^)]*\)', body)
                if not re.search(r'[A-Za-z]+\s+[A-Za-z]+', m[0])]

        def replace(item):
            word, key = item[0], item[0].upper()
            if any(a <= item.start() < b for a, b in protected):
                return word
            symbolic = any(a <= item.start() < b for a, b in math)
            known = key in known_names
            function = key in intrinsic and re.match(r'\s*\(', body[item.end():])
            arithmetic = key in local and (re.search(r'[+*/=<>-]\s*$', body[:item.start()])
                                           or re.match(r'\s*(?:[+*/=<>-]|\.(?:LE|LT|GE|GT|EQ|NE)\.)', body[item.end():], re.I))
            suffix = key == 'JR' and re.match(r'\.', body[item.end():])
            operator = re.match(r'\.', body[item.end():]) and body[:item.start()].endswith('.')
            unambiguous = (key != 'A' and key.lower() not in vocabulary
                           and (key not in proper_names or (key == 'JR' and key in local and not suffix))
                           and not operator)
            if example or function or arithmetic or key in explicit or (symbolic and known) or (known and unambiguous):
                return word.lower()
            return word

        after = WORD.sub(replace, body)
        if after != body:
            lines[index] = match[1] + after + (match[3] or '')
            count += 1
    return count


def sentence_case(text, vocabulary=None, rules=None):
    if vocabulary is None or rules is None:
        vocabulary, rules = settings()
    names, abbreviations = rules['proper_case'], set(rules['abbreviations'])
    citation = re.compile(rules['reference_cues'], re.I)
    lines = text.splitlines(keepends=True)
    code_names = {w.upper() for line in lines if not line.lstrip().startswith('!') for w in WORD.findall(line)}
    retained, unknown, uncertain = Counter(), {}, []
    changed_lines = changed_paragraphs = 0

    def has_prose(body):
        # Expressions and quoted text do not supply evidence of English prose.
        clean = re.sub(r"'[^']*'|\"[^\"]*\"|\b\w+\s*\([^)]*\)|\.[A-Za-z]+\.", ' ', body)
        return any(a.lower() in vocabulary and b.lower() in vocabulary
                   for a, b in re.findall(r'\b([A-Za-z]+)\s+([A-Za-z]+)\b', clean))

    def classify(body):
        value = body.strip()
        if not value or not re.search('[A-Za-z]', value):
            return 'separator'
        if re.match(r'^(?:\$|[A-Z][A-Z0-9_]*\$|IBM\*|\*DECK)', value, re.I):
            return 'directive'
        if CODE.match(value):
            return 'code example'
        if re.fullmatch(r'(?:INTEGER|REAL|DOUBLE\s+PRECISION|COMPLEX|LOGICAL|EXTERNAL|SAVE)\s+\w+', value, re.I):
            return 'code example'
        if re.match(r'^\w+(?:\([^)]*\))?\s+[-:]\s+', value) and has_prose(value):
            return 'descriptive expression'
        if FORMULA.search(value):
            if has_prose(value):
                return 'descriptive expression'
            return 'formula or status expression'
        if re.search(r'\S {3,}\S', value) or re.match(r'^\(?\d+[.)]?\s+\d', value):
            return 'table or aligned fields'
        letters = re.sub('[^A-Za-z]', '', value)
        if not letters.isupper():
            return 'existing mixed/lower case'
        tokens = WORD.findall(value)
        plain = sum(w.lower() in vocabulary or w.upper() in names for w in tokens)
        ordinary = sum(w.lower() in vocabulary or w.upper() in names or w.upper() in code_names or len(w) == 1 for w in tokens)
        leads = {'INITIALIZE','ESTIMATE','EVALUATE','INCREMENT','ADJUST','COMPUTE','TRANSFORM',
                 'SOLUTION','COLUMN','BLOCK','SMALL','LARGE','PERMUTATION','SOLVE','SET','SCALE',
                 'COPY','INTERCHANGE','UPDATE','DETERMINE','CHECK','FIND','FORM','MULTIPLY',
                 'DIVIDE','RESET','GENERATE','REPLACE','NORMALIZE','PREMULTIPLY'}
        minimum = 1 if len(tokens) == 1 or tokens[0].upper() in leads else 2
        if plain < minimum or ordinary / len(tokens) < .65:
            return 'uncertain prose'
        return 'prose'

    def convert(body, sentence_start, line_number):
        nonlocal unknown
        spans = [m.span() for m in re.finditer(r"'[^']*'|\"[^\"]*\"|\b(?:[A-Z]\.\s*){2,}|\.[A-Za-z]+\.", body)]
        for literal in re.finditer(r'(?<!\w)(\d+)[hH]', body):
            spans.append((literal.start(), literal.end() + int(literal[1])))
        for match in re.finditer(r'\([^)]*\)', body):
            inner = match[0][1:-1].strip()
            numeric = re.sub(r'\d+\.\d*(?:[ED][+-]?\d+)?', '0', inner, flags=re.I)
            if (re.fullmatch(r'[\w\s,+*/:\-]+', numeric) and
                (re.search(r'[,+*/:\-]', inner) and not re.search(r'[A-Za-z]+\s+[A-Za-z]+', inner)
                 or inner.upper() in code_names)):
                spans.append(match.span())
        stopwords = {'A','AN','THE','FOR','OF','IN','ON','AT','TO','AND','OR','IS','ARE','WAS','WHICH','THAT','WITH','BEING','USED','BE'}
        contextual = {m[1].upper() for m in CONTEXT.finditer(body)
                      if (m[1].upper() in code_names or len(m[1]) == 1)
                      and m[1].upper() not in stopwords - {'A'}}
        result, last, previous = [], 0, ''
        for match in WORD.finditer(body):
            word, key = match[0], match[0].upper()
            gap = body[last:match.start()]
            # Each list entry starts a description after its identifier/status.
            if re.search(r'(?:=|\s[-:])\s*(?:[+-]?\d+\s+)?$', gap):
                sentence_start = True
            initial = len(previous) == 1 and re.match(r'^\.\s*$', gap)
            operator_end = body[last:last + 1] == '.' and re.search(r'\.[A-Za-z]+$', body[:last])
            sentence_gap = gap[1:] if operator_end else gap
            if (re.search(r'(?<!\.)[.!?](?![.\d])', sentence_gap) and previous not in abbreviations
                    and not initial):
                sentence_start = True
            protected = any(a <= match.start() < b for a, b in spans) or key in contextual
            possessive = key.endswith("'S")
            base = key[:-2] if possessive else key
            if protected:
                replacement = word
            elif base in names:
                replacement = names[base] + ("'s" if possessive else '')
            elif (word.lower() in vocabulary or (possessive and base.lower() in vocabulary)
                  or (key == 'A' and (match.start() == 0 or body[match.start()-1] != '-') and
                      re.match(r'\s+[A-Za-z]', body[match.end():]) and
                      (next_word := WORD.search(body, match.end())) and next_word[0].lower() in vocabulary and
                      next_word[0].upper() not in stopwords | {'HAS','HAVE','MAY','MUST','CAN','SHOULD','WILL','WOULD','TIMES'})):
                replacement = word.lower()
                if sentence_start:
                    replacement = replacement[0].upper() + replacement[1:]
            else:
                replacement = word
                if len(word) > 1 and key not in code_names and not re.search(r'[0-9_]', key):
                    entry = unknown.setdefault(key, {'count': 0, 'first_line': line_number})
                    entry['count'] += 1
            result.extend((gap, replacement))
            last, previous, sentence_start = match.end(), key, False
        tail = body[last:]
        result.append(tail)
        converted = ''.join(result)
        for original, fixed in rules.get('proper_phrases', {}).items():
            converted = re.sub(r'\b' + re.escape(original) + r'\b',
                               lambda m: m[0] if any(a <= m.start() < b for a,b in spans) else fixed,
                               converted, flags=re.I)
        sentence_start = bool(re.search(r'[.!?]\s*$', tail)) and not tail.rstrip().endswith('...') and previous not in abbreviations
        return converted, sentence_start

    i = 0
    while i < len(lines):
        first = COMMENT.match(lines[i])
        if not first or classify(first[2]) == 'separator':
            i += 1
            continue
        start, block = i, []
        while i < len(lines):
            match = COMMENT.match(lines[i])
            if not match or classify(match[2]) == 'separator':
                break
            block.append(match)
            i += 1
        reference = bool(citation.search(' '.join(m[2] for m in block)))
        sentence_start, changed = True, False
        for offset, match in enumerate(block):
            kind = classify(match[2])
            if reference and kind in {'existing mixed/lower case', 'uncertain prose'}:
                kind = 'prose'
            if kind not in {'prose', 'descriptive expression'}:
                retained[kind] += 1
                if kind == 'uncertain prose':
                    uncertain.append({'line': start + offset + 1, 'text': match[2]})
                sentence_start = match[2].rstrip().endswith(('.', '!', '?'))
                continue
            after, sentence_start = convert(match[2], sentence_start, start + offset + 1)
            if after != match[2]:
                lines[start + offset] = match[1] + after + (match[3] or '')
                changed_lines += 1
                changed = True
        changed_paragraphs += changed
    technical_lines = technical_comments(lines, vocabulary, names)
    converted = ''.join(lines)
    changed_lines = sum(a != b for a, b in zip(text.splitlines(True), lines))
    if len(converted) != len(text) or any(a != b and not (a.isascii() and a.isalpha() and a.lower() == b.lower())
                                          for a, b in zip(text, converted)):
        raise ValueError('Comment transformation must change ASCII case only')
    # Independently guard every code line, including strings and inline comments.
    if [s for s in lines if not s.lstrip().startswith('!')] != [s for s in text.splitlines(True) if not s.lstrip().startswith('!')]:
        raise ValueError('Comment transformation changed code or quoted text')
    return Result(converted, changed_lines, changed_paragraphs, dict(retained), unknown, uncertain, technical_lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists() or args.report.exists() or args.output.resolve() == args.report.resolve():
        parser.error('Output and report must be distinct new files')
    data = args.source.read_bytes()
    result = sentence_case(data.decode('ascii'))
    converted = result.text.encode('ascii')
    report = result.report(data.decode('ascii'))
    with args.output.open('xb') as out:
        out.write(converted)
    with args.report.open('x', encoding='utf-8', newline='\n') as out:
        json.dump(report, out, indent=2)
        out.write('\n')
    print(f'{result.changed_lines} comment lines changed in {result.changed_paragraphs} paragraphs; '
          f'{len(result.unknown)} unfamiliar prose words retained for review.')


if __name__ == '__main__':
    main()
