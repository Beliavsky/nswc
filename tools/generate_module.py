"""Generate module procedures from the external free-form library.

Remove only library-procedure declarations, preserving dummy callbacks and
data objects with the same names. The reviewed call graph distinguishes
function references from ordinary data declarations. No compiler is needed.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile

from combine_declarations import split_list, type_declaration
from fortran_procedures import HEADER, procedure_spans
from format_free_form import TOKEN, groups, wrap_line
from procedure_purity import MANIFEST, code_hash
from coalesce_local_declarations import transform as coalesce_locals
from remove_final_returns import transform_free as remove_final_returns

ROOT = Path(__file__).resolve().parents[1]
BINDINGS = Path(__file__).with_name('module-bindings.json')
INTRINSIC_ALIASES = {'DGAMMA': 'GAMMA'}


def module_source(text, calls=None, intrinsics=None, coalesce=True):
    if calls is None:
        calls = json.loads(MANIFEST.read_text())['calls']
        review = json.loads(BINDINGS.read_text())
        intrinsics = review['intrinsic_overrides']
    intrinsics = intrinsics or {}
    lines = text.splitlines(True)
    spans = list(procedure_spans(text))
    library = {n for n, _, _ in spans}
    output, previous = [], 0
    for name, start, end in spans:
        body = lines[start:end]
        logical_groups = list(groups(body))
        header = logical_groups[0][1]
        arguments = re.search(r'\b(?:function|subroutine)\s+\w+\s*\(([^)]*)\)', header, re.I)
        dummies = {n.strip().upper() for n in arguments[1].split(',') if n.strip()} if arguments else set()
        references = set(calls.get(name, [])) & library - dummies - {name}
        intrinsic_names = {n.upper() for n in intrinsics.get(name, [])}
        references -= intrinsic_names
        aliases = {n: INTRINSIC_ALIASES[n] for n in intrinsic_names if n in INTRINSIC_ALIASES}
        references.update(aliases)
        intrinsic_names = {aliases.get(n, n) for n in intrinsic_names}
        removed, replacements = set(), {}
        called_dummies, declared_callbacks = set(), set()
        declared_intrinsics = set()
        interface_start = None
        for i, line in enumerate(body):
            if re.match(r'^\s*interface\s*$', line, re.I):
                if interface_start is not None:
                    raise ValueError(f'{name}: nested interface needs review')
                interface_start = i
            elif re.match(r'^\s*end\s*interface\b', line, re.I) and interface_start is not None:
                prototypes = {m[1].upper() for s in body[interface_start:i] if (m := HEADER.match(s))}
                declared_callbacks.update(prototypes & dummies)
                internal = prototypes & library - dummies
                if internal and internal != prototypes:
                    raise ValueError(f'{name}: mixed interface needs review')
                if internal:
                    references.update(internal)
                    removed.update(range(interface_start, i + 1))
                interface_start = None
        for records, logical in logical_groups:
            if records[0].index in removed:
                continue
            external = re.match(r'^\s*external\s+(?:::)?\s*(.*)', logical, re.I)
            intrinsic = re.match(r'^\s*intrinsic\s+(?:::)?\s*(.*)', logical, re.I)
            if intrinsic:
                declared_intrinsics.update(n.upper() for n in split_list(intrinsic[1]))
            if external:
                declared_callbacks.update(n.upper() for n in split_list(external[1]))
                references.update(n.upper() for n in split_list(external[1]) if n.upper() in library - dummies - {name})
            tokens = [m[0] for m in TOKEN.finditer(logical)]
            called_dummies.update(following.upper() for token, following in zip(tokens, tokens[1:])
                                  if token.lower() == 'call' and following.upper() in dummies)
        for records, logical in logical_groups:
            if records[0].index in removed:
                continue
            constant = bool(re.match(r'^\s*(?:integer|real|double\s+(?:precision|complex)|complex|logical|character)\b.*?,\s*parameter\b', logical, re.I))
            declaration = None if constant else type_declaration(logical)
            external = re.match(r'^\s*external\s+(?:::)?\s*(.*)', logical, re.I)
            if declaration:
                kept = [(n, shape, length) for n, shape, length in declaration[2] if n.upper() not in references]
                if len(kept) == len(declaration[2]):
                    continue
                if '::' not in logical:
                    raise ValueError(f'{name}: expected combined declarations')
                replacement = logical.split('::', 1)[0].rstrip() + ' :: ' + ', '.join(n + s + l for n, s, l in kept) if kept else ''
            elif external:
                names = split_list(external[1])
                kept = [n for n in names if n.upper() not in references]
                if names == kept:
                    continue
                replacement = 'external ' + ', '.join(kept) if kept else ''
            else:
                continue
            removed.update(r.index for r in records)
            comments = ''.join(r.comment + r.newline for r in records if r.comment)
            replacements[records[0].index] = (wrap_line('', replacement, '', '', records[0].newline, 3) if replacement else '') + comments
        output.extend(lines[previous:start])
        missing = sorted(called_dummies - declared_callbacks)
        intrinsic_names -= declared_intrinsics
        for i, line in enumerate(body):
            output.append(replacements.get(i, '') + (line if i not in removed else ''))
            if (missing or intrinsic_names) and i not in removed and re.match(r'^\s*implicit\s+none\s*$', line, re.I):
                if missing:
                    output.append('external ' + ', '.join(n.lower() for n in missing) + '\n')
                if intrinsic_names:
                    output.append('intrinsic :: ' + ', '.join(n.lower() for n in sorted(intrinsic_names)) + '\n')
                missing = []
                intrinsic_names = set()
        previous = end
    output.extend(lines[previous:])
    result = ''.join(output)
    # Rename only reviewed intrinsic references, never strings or comments.
    renamed = result.splitlines(True)
    for name, start, end in procedure_spans(result):
        aliases = {n: INTRINSIC_ALIASES[n] for n in (v.upper() for v in intrinsics.get(name, [])) if n in INTRINSIC_ALIASES}
        for i in range(start, end):
            if not aliases or renamed[i].lstrip().startswith('!'):
                continue
            line = renamed[i]
            tokens = []
            for token in TOKEN.finditer(line):
                if token[0] == '!':
                    break
                tokens.append(token)
            for token in reversed(tokens):
                if token[0].upper() in aliases:
                    line = line[:token.start()] + aliases[token[0].upper()].lower() + line[token.end():]
            renamed[i] = line
    generated = ('! Generated by tools/generate_module.py; edit the maintained inputs instead.\n'
            'module nswc_mod\nimplicit none\nprivate\n' +
            ''.join('public :: ' + n.lower() + '\n' for n, _, _ in spans) +
            'contains\n' + ''.join(renamed) + 'end module nswc_mod\n')
    return remove_final_returns(coalesce_locals(generated) if coalesce else generated)


def review_intrinsics(text, compiler):
    from validate_explicit_typing import symbols
    names = set(n for n, _, _ in procedure_spans(text))
    with tempfile.TemporaryDirectory(prefix='nswc-intrinsic-review-') as work:
        path = Path(work) / 'source.f90'
        path.write_text(text, encoding='ascii', newline='\n')
        result = subprocess.run([compiler, '-std=legacy', '-fno-allow-argument-mismatch',
                                 '-fsyntax-only', '-fdump-fortran-original', str(path)],
                                cwd=work, capture_output=True, text=True, timeout=180)
        if result.returncode:
            raise RuntimeError(result.stderr)
    inventory = symbols(result.stdout, include_intrinsics=True)
    overrides = {scope: sorted(n for n, r in records.items() if n.upper() in names and
                              'INTRINSIC-PROC' in r.get('attributes', '')) for scope, records in inventory.items()}
    overrides = {n: v for n, v in overrides.items() if v}
    version = subprocess.run([compiler, '--version'], capture_output=True, text=True, check=True)
    review = {'code_sha256': code_hash(text), 'compiler': version.stdout.splitlines()[0],
              'intrinsic_overrides': overrides}
    BINDINGS.write_text(json.dumps(review, indent=2) + '\n', encoding='ascii', newline='\n')
    print(f'Reviewed {sum(map(len, overrides.values()))} intrinsic bindings.', flush=True)


def check_binding_review(text):
    if json.loads(BINDINGS.read_text())['code_sha256'] != code_hash(text):
        raise ValueError('Module intrinsic bindings need review: run generate_module.py --review-intrinsics')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--review-intrinsics', action='store_true')
    parser.add_argument('--compiler', default='gfortran')
    args = parser.parse_args()
    target = ROOT / 'nswc_mod.f90'
    source = (ROOT / 'nswc.f90').read_text(encoding='ascii')
    if args.review_intrinsics:
        review_intrinsics(source, args.compiler)
    if args.check:
        check_binding_review(source)
    generated = module_source(source)
    if args.check:
        if not target.exists() or target.read_bytes() != generated.encode('ascii'):
            raise ValueError('Generated module is stale')
    else:
        target.write_text(generated, encoding='ascii', newline='\n')
    print('Checked 1062 generated module procedures.' if args.check else 'Generated nswc_mod.f90.')


if __name__ == '__main__':
    main()
