"""Sentence-case selected uppercase prose in free-form Fortran comments.

Code, inline comments, directives, formulas, tables, examples and bibliographic
paragraphs are preserved. Ordinary words and proper names come from reviewed
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

    def report(self, original):
        return {'input_sha256': hashlib.sha256(original.encode('ascii')).hexdigest(),
                'output_sha256': hashlib.sha256(self.text.encode('ascii')).hexdigest(),
                'rules_sha256': hashlib.sha256((HERE / 'comment-case-rules.json').read_bytes()).hexdigest(),
                'vocabulary_sha256': hashlib.sha256((HERE / 'comment-case-words.txt').read_bytes()).hexdigest(),
                'changed_lines': self.changed_lines, 'changed_paragraphs': self.changed_paragraphs,
                'retained_lines': self.retained, 'unrecognized_prose_words': self.unknown,
                'uncertain_prose': self.uncertain}


def settings():
    rules = json.loads((HERE / 'comment-case-rules.json').read_text())
    words = {line for line in (HERE / 'comment-case-words.txt').read_text().splitlines()
             if line and not line.startswith('#')}
    return words, rules


def sentence_case(text, vocabulary=None, rules=None):
    if vocabulary is None or rules is None:
        vocabulary, rules = settings()
    names, abbreviations = rules['proper_case'], set(rules['abbreviations'])
    citation = re.compile(rules['reference_cues'], re.I)
    lines = text.splitlines(keepends=True)
    code_names = {w.upper() for line in lines if not line.lstrip().startswith('!') for w in WORD.findall(line)}
    retained, unknown, uncertain = Counter(), {}, []
    changed_lines = changed_paragraphs = 0

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
        if FORMULA.search(value):
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
        spans = [m.span() for m in re.finditer(r"'[^']*'|\"[^\"]*\"|\b\w+\([^)]*\)", body)]
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
            if re.search(r'(?<!\.)[.!?](?![.\d])', gap) and previous not in abbreviations:
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
        if citation.search(' '.join(m[2] for m in block)):
            retained['reference/author/history paragraph'] += len(block)
            continue
        sentence_start, changed = True, False
        for offset, match in enumerate(block):
            kind = classify(match[2])
            if kind != 'prose':
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
    converted = ''.join(lines)
    if len(converted) != len(text) or any(a != b and not (a.isascii() and a.isalpha() and a.lower() == b.lower())
                                          for a, b in zip(text, converted)):
        raise ValueError('Comment transformation must change ASCII case only')
    # Independently guard every code line, including strings and inline comments.
    if [s for s in lines if not s.lstrip().startswith('!')] != [s for s in text.splitlines(True) if not s.lstrip().startswith('!')]:
        raise ValueError('Comment transformation changed code or quoted text')
    return Result(converted, changed_lines, changed_paragraphs, dict(retained), unknown, uncertain)


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
