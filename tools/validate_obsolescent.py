"""Verify free-form obsolescent cleanup, helper scopes, types and signatures."""
from ford_documentation import strip as strip_ford
import copy
import json
from pathlib import Path
import re
import subprocess
import tempfile

from coalesce_local_declarations import transform as coalesce
from generic_intrinsics import transform as generics
from modernize_obsolescent import (MANIFEST, compile_dump, computed_gotos, review,
                                  scalar_type, transform)
from modernize_remaining_features import strict_standard
from remove_final_returns import transform_free as returns
from validate_explicit_typing import symbols
from validate_generic_intrinsics import baseline_source
from validate_interfaces import compare_signatures
from storage_modernization import equivalence_free

ROOT = Path(__file__).resolve().parents[1]


def baseline():
    return returns(coalesce(generics(baseline_source())))


def verify(before, after, manifest, work):
    old_dump, old_warnings = compile_dump(before, work)
    transfer_dump, _ = compile_dump(computed_gotos(before), work)
    if old_dump != transfer_dump:
        raise ValueError('Computed GO TO conversion changed compiler symbols or executable trees')
    if review(before, symbols(old_dump, True)) != manifest:
        raise ValueError('Obsolescent-feature review does not reproduce')
    new_dump, new_warnings = compile_dump(after, work)
    old, new = symbols(old_dump), symbols(new_dump)
    count = compare_signatures(old, new)
    adjusted = copy.deepcopy(new)
    internal = symbols(new_dump, include_internal=True)
    for host, entry in manifest['procedures'].items():
        captures = set()
        for name, function in entry['functions'].items():
            a, b = old[host][name], adjusted[host][name]
            attrs = set(a['attributes'].removeprefix('attributes: (').removesuffix(')').split())
            expected = attrs - {'STATEMENT-PROC'} | {'INTERNAL-PROC', 'PURE', 'CONTAINED'}
            actual = set(b['attributes'].removeprefix('attributes: (').removesuffix(')').split())
            if actual != expected or {k: v for k, v in a.items() if k != 'attributes'} != {k: v for k, v in b.items() if k != 'attributes'}:
                raise ValueError(f'{host}:{name}: helper characteristics changed')
            adjusted[host][name] = a
            helper = internal[host + '::' + name.upper()]
            if scalar_type(helper['nswc_sf_result']) != function['type']:
                raise ValueError(f'{host}:{name}: helper result kind differs')
            for arg, typ in function['arguments'].items():
                if scalar_type(helper[arg]) != typ or 'DUMMY(IN)' not in helper[arg]['attributes']:
                    raise ValueError(f'{host}:{name}:{arg}: helper argument kind/intent differs')
            captures.update(function['captures'])
        for name in captures:
            value = adjusted[host][name]['attributes']
            if 'HOST-ASSOC' not in old[host][name]['attributes']:
                adjusted[host][name]['attributes'] = value.replace(' HOST-ASSOC', '')
    if adjusted != old:
        raise ValueError('Obsolescent cleanup changed unreviewed host data/procedure records')
    warnings = lambda s: re.findall(r'^Warning:.*', s, re.M)
    if warnings(old_warnings) != warnings(new_warnings):
        raise ValueError('Obsolescent cleanup changed legacy-build warnings')
    print(f'Confirmed {count} unchanged interface records; helper kinds, intents and captured host data agree.', flush=True)
    print('Computed transfers have identical compiler symbols and executable trees.', flush=True)


def main():
    before = baseline()
    manifest = json.loads(MANIFEST.read_text())
    after = transform(before, manifest)
    if equivalence_free(after) != strip_ford((ROOT / 'nswc.f90').read_text(encoding='ascii')):
        raise ValueError('Obsolescent-feature generation differs from maintained free form')
    if transform(after, manifest) != after:
        raise ValueError('Obsolescent cleanup is not idempotent')
    with tempfile.TemporaryDirectory(prefix='nswc-obsolescent-check-') as work:
        verify(before, after, manifest, work)
        for name in ('nswc.f90', 'nswc_mod.f90'):
            source = (ROOT / name).read_text(encoding='ascii')
            if computed_gotos(source) != source:
                raise ValueError(name + ': computed transfers remain')
            dump, _ = compile_dump(source, work)
            if 'STATEMENT-PROC' in dump:
                raise ValueError(name + ': statement functions remain')
            r = subprocess.run(['gfortran', strict_standard(), '-pedantic-errors', '-fsyntax-only',
                                str(ROOT / name)], cwd=work, capture_output=True, text=True, timeout=180)
            if r.returncode or re.search(r'(?:statement function|computed go\s*to)', r.stderr, re.I):
                raise RuntimeError(name + ': strict compilation failed\n' + r.stderr[:12000])
            print(name + ': strict compilation accepted; neither target feature remains.', flush=True)
    print(manifest['summary'])


if __name__ == '__main__':
    main()
