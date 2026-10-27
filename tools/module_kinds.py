"""Use named real kinds only in the final generated module.

Keep literal constants and intrinsic conversion calls unchanged. The aliases
follow the compiler's default-real and double-precision kinds, rather than
requesting different storage sizes. Apply after COMMON/state modernization.
"""
import re
from collections import defaultdict

from format_free_form import TOKEN, groups, wrap_line
from fortran_procedures import HEADER

SP, DP = 'nswc_sp', 'nswc_dp'
DEFINITION = f'integer, parameter :: {SP} = kind(0.0), {DP} = kind(0.0d0)\n'
PREFIXES = {'pure', 'elemental', 'impure', 'recursive', 'module'}


def type_spec(words, start):
    """Return (end, replacement, alias) for a reviewed floating type spec."""
    if start >= len(words):
        return None
    word, end = words[start], start + 1
    if word == 'double' and words[end:end + 1] in (['precision'], ['complex']):
        typ = 'real' if words[end] == 'precision' else 'complex'
        return end + 1, f'{typ}({DP})', DP
    if word not in {'real', 'complex'}:
        return None
    alias = SP
    if words[end:end + 1] == ['(']:
        depth, closing = 1, end + 1
        while closing < len(words) and depth:
            depth += (words[closing] == '(') - (words[closing] == ')')
            closing += 1
        if depth:
            raise ValueError('Unclosed floating type kind')
        spec = ''.join(words[end + 1:closing - 1]).removeprefix('kind=')
        if spec in {SP, DP}:
            return None  # Already explicit.
        if spec in {'kind(0d0)', 'kind(0.d0)', 'kind(0.0d0)', 'kind(1d0)', 'kind(1.d0)', 'kind(1.0d0)'}:
            alias = DP
        elif spec not in {'kind(0.)', 'kind(0.0)', 'kind(1.)', 'kind(1.0)'}:
            return None  # Preserve other explicit kind selections.
        end = closing
    elif words[end:end + 1] == ['*']:
        raise ValueError('Nonstandard floating type size requires review')
    return end, f'{word}({alias})', alias


def transform(text):
    lines = text.splitlines(True)
    logical_groups = list(groups(lines))
    has_definition = DEFINITION in text
    if not has_definition and any(m[0].lower() in {SP, DP}
                                  for _, code in logical_groups for m in TOKEN.finditer(code)):
        raise ValueError('Reserved module kind name already exists')
    replacements, imports = defaultdict(list), defaultdict(list)
    interfaces = []
    for records, code in logical_groups:
        if re.match(r'^\s*(?:abstract\s+)?interface\b', code, re.I):
            interfaces.append(None)
            continue
        if re.match(r'^\s*end\s*interface\b', code, re.I):
            if not interfaces or interfaces.pop() is not None:
                raise ValueError('Unclosed interface procedure')
            continue
        if interfaces and HEADER.match(code):
            if interfaces[-1] is not None:
                raise ValueError('Nested interface procedure')
            interfaces[-1] = {'at': records[-1].index + 1, 'needed': set(), 'imported': set(), 'none': False}
        prototype = interfaces[-1] if interfaces else None
        if prototype is not None and re.match(r'^\s*import\b', code, re.I):
            names = {m[0].lower() for m in TOKEN.finditer(code)}
            prototype['imported'].update(names & {SP, DP})
            if code.strip().lower() == 'import' or 'all' in names:
                prototype['imported'].update({SP, DP})
            prototype['none'] |= 'none' in names
        tokens = [(r, m) for r in records for m in TOKEN.finditer(r.code) if m[0] != '&']
        words = [m[0].lower() for _, m in tokens]
        candidates = []
        first = 0
        while first < len(words) and words[first] in PREFIXES:
            first += 1
        spec = type_spec(words, first)
        if spec:
            end = spec[0]
            following = end
            while following < len(words) and words[following] in PREFIXES:
                following += 1
            if words[end:end + 1] == [','] or words[end:end + 2] == [':', ':'] or words[following:following + 1] == ['function']:
                candidates.append((first, spec))
        for i, word in enumerate(words):
            if word == '[' and (spec := type_spec(words, i + 1)) and words[spec[0]:spec[0] + 2] == [':', ':']:
                candidates.append((i + 1, spec))
        for start, (end, replacement, alias) in candidates:
            record, token = tokens[start]
            last_record, last_token = tokens[end - 1]
            if record.index != last_record.index or any(r.continued_string for r in records):
                raise ValueError('Split type specification needs review')
            replacements[record.index].append((token.start(), last_token.end(), replacement))
            if prototype is not None:
                prototype['needed'].add(alias)
        if prototype is not None and re.match(r'^\s*end\s*(?:subroutine|function)\b', code, re.I):
            missing = prototype['needed'] - prototype['imported']
            if missing and prototype['none']:
                raise ValueError('IMPORT NONE conflicts with named kinds')
            if missing:
                imports[prototype['at']].append('import :: ' + ', '.join(n for n in (SP, DP) if n in missing) + '\n')
            interfaces[-1] = None
    if interfaces:
        raise ValueError('Unclosed interface')
    for records, _ in logical_groups:
        for record in records:
            if record.index not in replacements:
                continue
            code = record.code
            for start, end, replacement in sorted(replacements[record.index], reverse=True):
                code = code[:start] + replacement + code[end:]
            prefix = re.match(r'\s*', code)[0]
            trailing = code.rstrip().endswith('&')
            body = code[len(prefix):].rstrip()
            if trailing:
                body = body[:-1].rstrip()
            tail = (' ' + record.comment) if record.comment else ''
            lines[record.index] = wrap_line(prefix, body, ' &' if trailing else '', tail, record.newline, len(prefix) + 3)
    if not has_definition:
        private = [i for i, line in enumerate(lines) if line.strip().lower() == 'private']
        if not private:
            raise ValueError('Expected a private module default')
        imports[private[0] + 1].insert(0, DEFINITION)
    return ''.join(''.join(imports[i]) + line for i, line in enumerate(lines))
