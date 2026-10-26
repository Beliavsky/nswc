"""Review xpure suggestions against compiler symbols and compile each contract.

Pass --tool-dir for an installed Fortran-Tools checkout containing xpure.py.
The adapter recognizes DOUBLE PRECISION and splits declaration entities at
top-level commas. Compiler diagnostics reject or downgrade heuristic candidates;
impurity is propagated to callers. The checked-in result needs only stdlib to
apply during regeneration.
"""
import argparse
from collections import Counter
import functools
import hashlib
import importlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from format_free_form import format_source, semantic_statements
from sentence_case_comments import sentence_case
from fortran_procedures import HEADER, procedure_blocks, procedure_spans
from interface_variants import legacy_interfaces
from procedure_purity import code_hash, transform
from validate_explicit_typing import symbols

ROOT = Path(__file__).resolve().parents[1]


def analyze(tool_dir, source):
    sys.path.insert(0, str(tool_dir.resolve()))
    xpure = importlib.import_module('xpure')
    scan = importlib.import_module('fortran_scan')
    xpure.TYPE_DECL_RE = re.compile(r'^\s*(double\s+(?:precision|complex)|integer|real|logical|character|complex|type\b|class\b|procedure\b)', re.I)
    def declared(line):
        result = set()
        for item in xpure.split_top_level_commas(line.split('::', 1)[1]):
            match = re.match(r'\s*([a-z]\w*)', item, re.I)
            if match:
                result.add(match[1].lower())
        return result
    xpure.parse_declared_names_from_decl = declared
    original = xpure.parse_procedures
    @functools.lru_cache(maxsize=4)
    def parsed(lines):
        return original(lines)
    xpure.parse_procedures = lambda lines: parsed(tuple(lines))
    for name in ('line_identifiers', 'executable_action', 'parse_declared_names_any', 'parse_declared_entities', 'has_function_reference'):
        setattr(xpure, name, functools.lru_cache(maxsize=None)(getattr(xpure, name)))
    files, missing = scan.load_source_files([source])
    if missing:
        raise ValueError('Analyzer could not load the baseline source')
    result = next(iter(xpure.analyze_source_files_fixed_point(files, strict_unknown_calls=True).values()))
    return {'pure': [p.name.upper() for p in result.candidates],
            'elemental': [p.name.upper() for p in xpure.suggest_elemental_candidates(result)],
            'rejected': {p.name.upper(): reasons for p, reasons in result.rejected},
            'procedure_actuals': sorted(result.procedure_actual_names)}


def calls_in(block, inventory, definitions):
    used = set()
    for _, values in semantic_statements(block):
        for i, word in enumerate(values):
            if values[i + 1:i + 2] == ('(',) or (i and values[i - 1].lower() == 'call'):
                used.add(word.upper())
    return sorted(n.upper() for n, value in inventory.items() if n.upper() in used & definitions
                  and 'PROCEDURE' in value.get('attributes', '') and 'DUMMY' not in value.get('attributes', ''))


def diagnostic_owners(text):
    lines, owners = text.splitlines(), {}
    for name, start, end in procedure_spans(text):
        nested, local = 0, None
        for i in range(start, end):
            line = lines[i]
            if re.match(r'^\s*interface\b', line, re.I):
                nested += 1
            if nested and (match := HEADER.match(line)):
                local = match[1].upper()
            owners[i + 1] = local or name
            if nested and re.match(r'^\s*end\s+(?:function|subroutine)\b', line, re.I):
                local = None
            if re.match(r'^\s*end\s*interface\b', line, re.I):
                nested -= 1
    return owners


def compile_source(compiler, path, dump=False):
    return subprocess.run([compiler, '-fsyntax-only', '-std=legacy', '-fallow-argument-mismatch',
                           *(['-fdump-fortran-original'] if dump else []), str(path)],
                          cwd=path.parent, capture_output=True, text=True, timeout=180)


def review(text, signature_text, draft, compiler, folder):
    source = folder / 'before.f90'
    source.write_text(text, encoding='ascii', newline='\n')
    baseline = compile_source(compiler, source, True)
    if baseline.returncode:
        raise RuntimeError(baseline.stderr)
    inventory = symbols(baseline.stdout, True)
    blocks = procedure_blocks(text)
    signatures = procedure_blocks(legacy_interfaces(signature_text))
    selected, rejected, downgrades = {}, {}, {}
    for name in draft['pure']:
        scope = inventory[name]
        args = scope[name.lower()].get('Formal arglist', '').split(':', 1)[-1].split()
        bad = []
        for arg in args:
            attrs = scope[arg].get('attributes', '')
            mode = re.search(r'DUMMY\((INOUT|OUT|IN)\)', attrs)
            function = re.search(r'\bFUNCTION\b', scope[name.lower()].get('attributes', ''))
            if 'PROCEDURE' in attrs or (not mode and 'VALUE' not in attrs) or (function and mode and mode[1] != 'IN'):
                bad.append(f'argument {arg} has no compatible pure data-argument contract')
        if bad:
            rejected[name] = bad
            continue
        elemental = name in draft['elemental'] and all('Array spec' not in scope[n] for n in args + [name.lower()])
        attribute = 'pure elemental' if elemental else 'pure'
        if name in draft['elemental'] and not elemental:
            downgrades[name] = ['compiler symbols identify an array dummy or result']
        signature = re.sub(r'^(\s*)', lambda m: m[0] + attribute + ' ', lowercase(signatures[name]), count=1)
        selected[name] = {'attribute': attribute, 'interface': signature}
    calls = {name: [n for n in calls_in(block, inventory[name], set(blocks)) if n != name] for name, block in blocks.items()}
    manifest = {'source_hashes': {n: code_hash(b) for n, b in blocks.items()}, 'calls': calls,
                'procedures': selected, 'analyzer_rejections': draft['rejected'],
                'compiler_rejections': rejected, 'elemental_downgrades': downgrades,
                'procedure_actuals': draft['procedure_actuals']}
    while True:
        while True:
            blocked = {n: [c for c in calls[n] if c not in selected] for n in selected}
            blocked = {n: c for n, c in blocked.items() if c}
            if not blocked:
                break
            for name, dependencies in blocked.items():
                rejected[name] = ['calls a procedure without a pure contract: ' + ', '.join(dependencies)]
                del selected[name]
        trial = transform(text, manifest)
        path = folder / 'trial.f90'
        path.write_text(trial, encoding='ascii', newline='\n')
        result = compile_source(compiler, path)
        if not result.returncode:
            break
        owners, failures = diagnostic_owners(trial), {}
        pattern = r'^[^\r\n]+:(\d+):\d+:\n(.*?)(?=^[^\r\n]+:\d+:\d+:\n|\Z)'
        for match in re.finditer(pattern, result.stderr, re.M | re.S):
            messages = re.findall(r'^Error: (.*)', match[2], re.M)
            if messages:
                owner = owners.get(int(match[1]))
                if owner not in selected:
                    raise RuntimeError('Unexpected compiler error outside candidates:\n' + match[0])
                failures.setdefault(owner, []).extend(messages)
        if not failures:
            raise RuntimeError('Unrecognized compiler diagnostics:\n' + result.stderr)
        for name, reasons in failures.items():
            if selected[name]['attribute'] == 'pure elemental':
                downgrades.setdefault(name, []).extend(reasons)
                selected[name]['attribute'] = 'pure'
                selected[name]['interface'] = re.sub(r'\belemental\s+', '', selected[name]['interface'], flags=re.I)
            else:
                rejected[name] = reasons
                del selected[name]
        print('Compiler refinement:', len(selected), 'candidates remain.', flush=True)
    manifest['summary'] = {'procedures': len(blocks), 'annotated': len(selected),
                           'pure_elemental': sum(v['attribute'] == 'pure elemental' for v in selected.values()),
                           'pure_only': sum(v['attribute'] == 'pure' for v in selected.values())}
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tool-dir', type=Path, required=True)
    parser.add_argument('--compiler', default='gfortran')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--draft', type=Path, help='Reuse a temporary analyzer draft while reviewing compiler diagnostics')
    args = parser.parse_args()
    if args.output.exists():
        parser.error('Output must name a new file')
    text = sentence_case(format_source(lowercase(convert_text((ROOT / 'nswc.f').read_text(encoding='ascii'))))).text
    with tempfile.TemporaryDirectory(prefix='nswc-purity-review-') as work:
        folder = Path(work)
        source = folder / 'baseline.f90'
        source.write_text(text, encoding='ascii', newline='\n')
        draft = json.loads(args.draft.read_text()) if args.draft else analyze(args.tool_dir, source)
        manifest = review(text, (ROOT / 'nswc_interfaces.f90').read_text(), draft, args.compiler, folder)
    manifest['analyzer'] = {'name': 'Fortran-Tools/xpure.py',
                            'url': 'https://github.com/Beliavsky/Fortran-Tools/blob/main/xpure.py',
                            'sha256': hashlib.sha256((args.tool_dir / 'xpure.py').read_bytes()).hexdigest(),
                            'adapter': 'DOUBLE PRECISION declarations and top-level entity splitting; strict unknown calls'}
    args.output.write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8', newline='\n')
    print(json.dumps(manifest['summary']), flush=True)


if __name__ == '__main__':
    main()
