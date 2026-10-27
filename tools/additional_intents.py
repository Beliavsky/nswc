"""Review additional intents on current fixed source, including COMMON procedures.

COMMON is assessed per argument. ENTRY, EQUIVALENCE, pointers and unsupported
I/O still exclude a scope. Unknown calls block input inference. Shared actual
storage blocks new contracts, and this supplemental pass never infers OUT.
"""
import argparse
import json
from pathlib import Path
import re
import tempfile
from argument_intents import (invocations, prove_inputs, call_dependencies,
    CONTROL_WORDS, UNSUPPORTED_IO, intent_lines)
from writable_intents import (infer, mask_strings, strip_if, is_specification,
    data_dummies, variable_base, assignment)
from explicit_typing import units, digest
from name_procedure_ends import statements
from generic_intrinsics import compile_dump
from validate_explicit_typing import symbols
from combine_declarations import transform as combine

MANIFEST = Path(__file__).with_name('additional-intents.json')


def analyze(data, inventory, refinements=None):
    refinements = refinements or {}
    callback_modes = refinements.get('callback_modes', {})
    lines, scopes = units(data)
    existing = {'procedures': {}, 'input_sha256': digest(data)}
    formals, bodies, excluded = {}, {}, {}
    implicit_results = set()
    for p, (start, _, end) in scopes.items():
        stmts = list(statements(lines[start:end]))
        header = stmts[0].code.lower()
        if re.search(r'\bfunction\b', header) and not re.search(r'\bresult\s*\(', header):
            implicit_results.add(p)
        formals[p] = [s.strip() for s in header[header.index('(')+1:header.rindex(')')].split(',')] if '(' in header else []
        bodies[p] = [mask_strings(s.code).strip() for s in stmts[1:-1]]
        modes = {}
        for d in data_dummies(inventory[p]):
            match = re.search(r'DUMMY\((INOUT|IN|OUT)\)', inventory[p][d].get('attributes', ''))
            if match:
                modes[d.upper()] = match[1]
        if modes:
            existing['procedures'][p] = {'arguments': modes}
        if any(re.match(r'(equivalence|entry|pointer)\b', c) or UNSUPPORTED_IO.match(strip_if(c)) for c in bodies[p]) or any(
                re.search(r'\b(?:POINTER|ALLOCATABLE|TARGET)\b', e.get('attributes', '')) for e in inventory[p].values()):
            excluded[p] = 'Storage association, alternate entry, pointer, or unsupported I/O'
    # INTENT is part of a procedure's interface. Preserve the characteristics
    # of library procedures passed as callbacks until their contracts are reviewed.
    for p in scopes:
        for code in bodies[p]:
            if is_specification(code):
                continue
            for _, actuals in invocations(code):
                for actual in actuals:
                    attrs = inventory[p].get(actual, {}).get('attributes', '')
                    if refinements.get('function_results_are_data') and p in implicit_results and actual.upper() == p and 'FUNCTION' in attrs:
                        continue
                    if actual.upper() in scopes and 'PROCEDURE' in attrs and 'DUMMY' not in attrs and 'INTRINSIC-PROC' not in attrs:
                        excluded[actual.upper()] = 'Procedure passed as a callback: preserve its interface'
    writable = infer(data, inventory, existing, allow_common=True, callback_modes=callback_modes)
    potential, requirements, blocked, calls = set(), {}, {}, []
    for p in scopes:
        records = inventory[p]
        own = data_dummies(records)
        for d in own:
            key = (p, d)
            potential.add(key)
            requirements[key] = set()
            attrs = records[d].get('attributes', '')
            if p in excluded or 'IN-COMMON' in attrs or 'IN-EQUIVALENCE' in attrs:
                blocked[key] = excluded.get(p, 'Argument is storage associated')
            if 'DUMMY(OUT)' in attrs or 'DUMMY(INOUT)' in attrs:
                blocked[key] = 'Existing writable intent'
        writes = writable['procedures'].get(p, {}).get('arguments', {})
        for d, mode in writes.items():
            if mode != 'IN':
                blocked[(p, d.lower())] = 'Established write'
        for whole in bodies[p]:
            if is_specification(whole) or re.match(r'(common|equivalence)\b', whole):
                continue
            executable = strip_if(whole)
            if re.match(r'write\b', executable):
                for d in set(re.findall(r'\b[a-z]\w*\b', executable)) & own:
                    blocked[(p, d)] = 'I/O reference needs separate review'
            assigned = assignment(executable)
            direct = {assigned[0]} if assigned else set()
            iterator = re.match(r'do\s+(?:\d+\s+)?([a-z]\w*)\s*=', executable)
            if iterator:
                direct.add(iterator[1])
            direct.update(re.findall(r'\b(?:iostat|iomsg|size)\s*=\s*([a-z]\w*)', executable))
            for d in direct & own:
                blocked[(p, d)] = 'Direct write'
            for callee, actuals in invocations(whole):
                attrs = records.get(callee, {}).get('attributes', '')
                if callee in CONTROL_WORDS:
                    continue
                if 'INTRINSIC-PROC' in attrs:
                    if re.match(r'call\s+' + re.escape(callee) + r'\b', executable):
                        for actual in actuals:
                            for d in set(re.findall(r'\b[a-z]\w*\b', actual)) & own:
                                blocked[(p, d)] = 'Intrinsic subroutine effects need review'
                    continue
                if 'VARIABLE' in attrs and 'PROCEDURE' not in attrs:
                    continue
                target = callee.upper()
                if 'DUMMY' in attrs or target not in scopes:
                    modes = callback_modes.get(p + ':' + callee.upper())
                    if modes and len(modes) != len(actuals):
                        raise ValueError('Callback argument count changed')
                    for i, actual in enumerate(actuals):
                        if modes and modes[i] == 'IN':
                            continue
                        for d in set(re.findall(r'\b[a-z]\w*\b', actual)) & own:
                            blocked[(p, d)] = 'Unknown or callback effects: ' + callee
                    continue
                calls.append((p, target, actuals))
                for d, needed in call_dependencies(actuals, formals[target], own).items():
                    if needed is None:
                        blocked[(p, d)] = 'Unresolved call argument'
                    else:
                        requirements[(p, d)].update((target, f) for f in needed)
    # New contracts must not change the treatment of observed overlapping
    # arguments or actuals also visible through COMMON/EQUIVALENCE.
    hazards = {}
    trusted = {(p, d.lower()) for p, entry in existing['procedures'].items()
               for d, mode in entry['arguments'].items() if mode == 'IN' and (p, d.lower()) not in blocked} if refinements.get('trust_existing_inputs') else set()
    raw_requirements = {key: (None if key in blocked else set() if key in trusted else deps.copy()) for key, deps in requirements.items()}
    readonly = prove_inputs(potential, raw_requirements) if refinements.get('readonly_duplicates') else set()
    for p, callee, actuals in calls:
        records = inventory[p]
        if len(actuals) != len(formals[callee]) or any(re.match(r'[a-z]\w*\s*=(?!=)', a) for a in actuals):
            for formal in formals[callee]:
                hazards[(callee, formal)] = 'Keyword or incomplete call association needs review'
            continue
        bases = [variable_base(a, records, p.lower()) for a in actuals]
        for formal, base in zip(formals[callee], bases):
            attrs = records.get(base, {}).get('attributes', '') if base else ''
            repeated = bases.count(base) > 1 and not all((callee, f) in readonly for f, b in zip(formals[callee], bases) if b == base)
            if base and (repeated or 'IN-COMMON' in attrs or 'IN-EQUIVALENCE' in attrs or p in excluded):
                hazards[(callee, formal)] = 'Shared or storage-associated actual in ' + p
    # Forwarded workspace views can overlap even when their names differ in
    # this scope. Carry observed hazards down the call graph to a fixed point.
    while True:
        added = {}
        for p, callee, actuals in calls:
            for formal, actual in zip(formals[callee], actuals):
                key = (callee, formal)
                if key not in hazards and any((p, name) in hazards for name in re.findall(r'\b[a-z]\w*\b', actual)):
                    added[key] = 'Forwarded shared storage from ' + p
        if not added:
            break
        hazards.update(added)
    waived = {}
    for key in list(hazards):
        review = refinements.get('alias_safe', {}).get(key[0] + ':' + key[1].upper())
        if review and ('shared storage' in hazards[key].lower() or 'storage-associated actual' in hazards[key]):
            waived[key] = {'reason': hazards.pop(key), 'review': review}
    for key in potential:
        if key in trusted:
            requirements[key] = set()
        elif key in blocked or key in hazards:
            requirements[key] = None
    proved = prove_inputs(potential, requirements)
    result = {'input_sha256': digest(data), 'procedures': {}, 'remaining': {}}
    nonvariable = writable['writable_analysis']['nonvariable_actuals']
    for p in scopes:
        old = existing['procedures'].get(p, {}).get('arguments', {})
        new = {}
        for d in sorted(data_dummies(inventory[p])):
            if d.upper() in old:
                continue
            key = (p, d)
            suggested = writable['procedures'].get(p, {}).get('arguments', {}).get(d.upper())
            if key in hazards or p in excluded:
                reason = hazards.get(key, excluded.get(p))
            elif key in proved:
                new[d.upper()] = {'intent': 'IN', 'dependencies': [q+':'+a.upper() for q,a in sorted(requirements[key])]}
                continue
            elif suggested in ('INOUT', 'OUT'):
                evidence = writable['procedures'][p]['write_evidence'][d.upper()]
                new[d.upper()] = {'intent': 'INOUT', 'evidence': evidence}
                continue
            else:
                reason = blocked.get(key, 'Unproved call dependency or no established write')
                if p+':'+d.upper() in nonvariable:
                    reason = 'Non-definable actual at a known call'
            result['remaining'][p+':'+d.upper()] = reason
        if new:
            for d, entry in new.items():
                if (p, d.lower()) in waived:
                    entry['alias_review'] = waived[(p, d.lower())]
            result['procedures'][p] = new
    if refinements.get('select'):
        for p in list(result['procedures']):
            if p not in refinements['select']:
                for d in result['procedures'].pop(p):
                    result['remaining'][p + ':' + d] = 'Outside this reviewed batch'
    return result


def transform(data, manifest=None):
    manifest = manifest or json.loads(MANIFEST.read_text())
    if digest(data) == manifest.get('output_sha256'):
        return data
    if digest(data) != manifest['input_sha256']:
        raise ValueError('Source differs from additional intent review')
    lines, scopes = units(data)
    for p, args in sorted(manifest['procedures'].items(), key=lambda item: scopes[item[0]][0], reverse=True):
        start, _, end = scopes[p]
        stmts = list(statements(lines[start:end]))
        pos = start + stmts[1].lines[-1] + 1
        newline = '\r\n' if lines[start].endswith('\r\n') else '\n'
        block = lines[start:pos] + [s+newline for s in intent_lines({d:e['intent'] for d,e in args.items()})] + lines[pos:end]
        lines[start:end] = combine(''.join(block).encode('ascii')).data.decode('ascii').splitlines(True)
    return ''.join(lines).encode('ascii')


def review(data, compiler='gfortran'):
    with tempfile.TemporaryDirectory(prefix='nswc-extra-intents-') as work:
        dump = compile_dump(data.decode('ascii'), work, compiler, fixed=True)[0]
    result = analyze(data, symbols(dump, include_intrinsics=True))
    result['output_sha256'] = digest(transform(data, result))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    data = args.source.read_bytes()
    result = review(data)
    with args.report.open('x') as out:
        json.dump(result, out, indent=2); out.write('\n')
    if args.output:
        with args.output.open('xb') as out:
            out.write(transform(data, result))
    print({mode: sum(e['intent']==mode for a in result['procedures'].values() for e in a.values()) for mode in ('IN','INOUT')}, 'in', len(result['procedures']), 'procedures', flush=True)

if __name__ == '__main__':
    main()
