"""Modernize reviewed free-form computed transfers and statement functions.

Only compiler-confirmed statement functions qualify. Their scalar dummy/result
types are recorded before conversion. Expressions and captured host variables
are preserved. Internal helpers are pure; compilation verifies that assertion.
Computed transfers use ordinal CASE values, including repeated destinations,
and no default branch, preserving out-of-range fall-through.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from combine_declarations import type_declaration
from format_free_form import groups, wrap_line
from format_free_form import TOKEN
from fortran_procedures import procedure_spans, procedure_blocks
from procedure_purity import code_hash

MANIFEST = Path(__file__).with_name('obsolescent-features.json')
COMPUTED = re.compile(r'^\s*go\s*to\s*\(([\d,\s]+)\)\s*,?\s*(.+?)\s*$', re.I)
TYPES = {'INTEGER 4': 'integer', 'REAL 4': 'real', 'REAL 8': 'double precision',
         'COMPLEX 4': 'complex', 'COMPLEX 8': 'complex(kind=kind(0d0))', 'LOGICAL 4': 'logical'}


def scalar_type(record):
    spec = record.get('type spec', '').removeprefix('type spec : (').removesuffix(')')
    if spec not in TYPES or record.get('Array spec'):
        raise ValueError('Unsupported statement-function scalar type: ' + str(record))
    return TYPES[spec]


def computed_gotos(text, report=None):
    lines, edits, removed, changes = text.splitlines(True), {}, set(), []
    for host, first, end in procedure_spans(text):
        for physical, code in groups(lines[first:end]):
            match = COMPUTED.fullmatch(code)
            if not match or match[2].lstrip().startswith('='):
                continue
            if any(r.continued_string for r in physical):
                raise ValueError(f'{host}: continued string in computed transfer')
            labels = [int(s) for s in match[1].split(',')]
            if not labels:
                raise ValueError(f'{host}: empty computed transfer')
            record = physical[0]
            label = re.match(r'\s*(\d+\s+)?', record.code)[1] or ''
            indent = re.match(r'\s*', record.code)[0]
            code_lines = [f'select case ({match[2]})']
            for ordinal, target in enumerate(labels, 1):
                code_lines += [f'case ({ordinal})', f'   go to {target}']
            code_lines += ['end select']
            replacement = ''.join(wrap_line(indent + (label if i == 0 else ''), c, '', '', record.newline, 3)
                                  for i, c in enumerate(code_lines))
            # Keep all intervening comments at their original positions. Inline
            # comments become full comment lines at their statement position.
            comments = ''.join(indent + r.comment + r.newline for r in physical if r.comment)
            edits[first + record.index] = replacement + comments
            removed.update(first + r.index for r in physical)
            changes.append({'procedure': host, 'line': first + record.index + 1,
                            'selector': match[2], 'targets': labels})
    result = ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines))
    if report is not None:
        report.extend(changes)
    return result


def review(text, inventory):
    entries = {}
    for host, body in procedure_blocks(text).items():
        records = inventory[host]
        functions = {}
        for name, record in records.items():
            if 'STATEMENT-PROC' not in record.get('attributes', ''):
                continue
            args = record['Formal arglist'].removeprefix('Formal arglist:').split()
            functions[name] = {'type': scalar_type(record),
                               'arguments': {arg: scalar_type(records[arg]) for arg in args}}
        if functions:
            for _, code in groups(body.splitlines(True)):
                match = re.match(r'^\s*(\w+)\s*\(([^()]*)\)\s*=\s*(.*)$', code, re.I)
                if match and match[1].lower() in functions:
                    function = functions[match[1].lower()]
                    function['expression'] = match[3]
                    names = {m[0].lower() for m in TOKEN.finditer(match[3])}
                    function['captures'] = sorted(n for n in names - function['arguments'].keys()
                                                  if 'VARIABLE' in records.get(n, {}).get('attributes', ''))
            entries[host] = {'source_hash': code_hash(body), 'functions': functions}
    transfers = []
    computed_gotos(text, transfers)
    manifest = {'procedures': entries, 'computed_gotos': transfers,
                'summary': {'procedures': len(entries), 'computed_gotos': len(transfers),
                            'statement_functions': sum(len(e['functions']) for e in entries.values())}}
    converted = transform(text, manifest)
    blocks = procedure_blocks(converted)
    for name, entry in entries.items():
        entry['output_hash'] = code_hash(blocks[name])
    return manifest


def statement_functions(text, manifest):
    lines, edits, removed = text.splitlines(True), {}, set()
    for host, start, end in procedure_spans(text):
        entry = manifest['procedures'].get(host)
        if entry is None:
            continue
        body = ''.join(lines[start:end])
        # An already converted procedure is left untouched.
        if re.search(r'^\s*contains\s*$', body, re.M | re.I):
            if code_hash(body) == entry.get('output_hash') and all(re.search(r'\bfunction\s+' + re.escape(n) + r'\s*\(', body, re.I)
                   for n in entry['functions']):
                continue
            raise ValueError(f'{host}: existing internal procedures require review')
        if code_hash(body) != entry['source_hash']:
            raise ValueError(f'{host}: statement-function source changed since review')
        functions, expressions = entry['functions'], {}
        interface = 0
        for physical, code in groups(body.splitlines(True)):
            if re.match(r'^\s*(?:abstract\s+)?interface\b', code, re.I):
                interface += 1
            if re.match(r'^\s*end\s*interface\b', code, re.I):
                interface -= 1
                continue
            if interface:
                continue
            decl = None if re.search(r',\s*parameter\b', code, re.I) else type_declaration(code)
            if decl and set(functions) & {n.lower() for n, _, _ in decl[2]}:
                kept = [n + shape + length for n, shape, length in decl[2] if n.lower() not in functions]
                replacement = code.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(kept) if kept else ''
            else:
                match = re.match(r'^\s*(\w+)\s*\(([^()]*)\)\s*=\s*(.*)$', code, re.I)
                if not match or match[1].lower() not in functions:
                    continue
                name = match[1].lower()
                if name in expressions or [s.strip().lower() for s in match[2].split(',')] != list(functions[name]['arguments']):
                    raise ValueError(f'{host}:{name}: statement-function arguments differ')
                expressions[name] = match[3]
                if match[3] != functions[name]['expression']:
                    raise ValueError(f'{host}:{name}: reviewed expression differs')
                replacement = ''
            first = physical[0]
            if re.match(r'^\s*\d+\s', first.code) or any(r.continued_string for r in physical):
                raise ValueError(f'{host}: labelled/continued-string statement function requires review')
            comments = ''.join(r.comment + r.newline for r in physical if r.comment)
            edits[start + first.index] = (wrap_line('', replacement, '', '', first.newline, 3) if replacement else '') + comments
            removed.update(start + r.index for r in physical)
        if expressions.keys() != functions.keys():
            raise ValueError(f'{host}: statement-function definition inventory differs')
        helpers = ['contains\n']
        for name, function in functions.items():
            result = 'nswc_sf_result'
            if re.search(r'\b' + result + r'\b', body, re.I):
                raise ValueError(f'{host}: helper result name collision')
            helpers += [f"   pure function {name}({', '.join(function['arguments'])}) result({result})\n",
                        '      implicit none\n']
            helpers += [f'      {typ}, intent(in) :: {arg}\n' for arg, typ in function['arguments'].items()]
            helpers += [f"      {function['type']} :: {result}\n",
                        wrap_line('      ', result + ' = ' + expressions[name], '', '', '\n', 3),
                        f'   end function {name}\n']
        edits[end - 1] = ''.join(helpers) + lines[end - 1]
    return ''.join(edits.get(i, '' if i in removed else line) for i, line in enumerate(lines))


def transform(text, manifest=None, report=None):
    manifest = json.loads(MANIFEST.read_text()) if manifest is None else manifest
    # Review hashes refer to the source before computed GO TO conversion.
    result = computed_gotos(statement_functions(text, manifest))
    if report is not None:
        transfers = []
        computed_gotos(text, transfers)
        report.update({'input_sha256': hashlib.sha256(text.encode('ascii')).hexdigest(),
                       'output_sha256': hashlib.sha256(result.encode('ascii')).hexdigest(),
                       'transfers': transfers, **manifest['summary']})
    return result


def compile_dump(text, work, compiler='gfortran'):
    path = Path(work) / 'input.f90'
    path.write_text(text, encoding='ascii', newline='\n')
    r = subprocess.run([compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                        '-fsyntax-only', '-fdump-fortran-original', str(path)],
                       cwd=work, capture_output=True, text=True, timeout=180)
    if r.returncode:
        raise RuntimeError(r.stderr[:12000])
    return r.stdout, r.stderr


def main():
    from validate_explicit_typing import symbols
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--review', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--manifest', type=Path, default=MANIFEST)
    args = parser.parse_args()
    text = args.source.read_text(encoding='ascii')
    if args.review:
        if args.review.exists():
            parser.error('Review output must name a new file')
        with tempfile.TemporaryDirectory(prefix='nswc-obsolescent-review-') as work:
            manifest = review(text, symbols(compile_dump(text, work)[0], True))
            compile_dump(transform(text, manifest), work)
        args.review.write_text(json.dumps(manifest, indent=2) + '\n', encoding='ascii', newline='\n')
        print(manifest['summary'])
    if args.output:
        if args.output.exists():
            parser.error('Source output must name a new file')
        manifest_path = args.review or args.manifest
        args.output.write_text(transform(text, json.loads(manifest_path.read_text())), encoding='ascii', newline='\n')


if __name__ == '__main__':
    main()
