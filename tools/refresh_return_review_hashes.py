"""Refresh review hashes only after proving an exact final-RETURN-only edit.

All recorded constants, purity contracts, call graphs and intrinsic selections
are retained. This narrowly scoped migration refuses any other source change.
"""
import argparse
import copy
import json
from pathlib import Path

from data_constants import transform as constants
from fixed_to_free import convert_text
from format_free_form import format_source
from free_source_fixes import transform as fixes
from generic_intrinsics import transform as generics
from lowercase_fortran import lowercase
from portable_intrinsics import transform as portable
from procedure_purity import code_hash, transform as purity
from sentence_case_comments import sentence_case
from simplify_free_style import transform as style
from coalesce_local_declarations import transform as coalesce
from fortran_procedures import procedure_blocks
from remove_final_returns import transform_fixed, transform_free

ROOT = Path(__file__).resolve().parents[1]


def refresh(old, new, manifest, purity_manifest=False):
    if transform_free(old) != new:
        raise ValueError('Review migration requires an exact terminal-RETURN-only change')
    before, after = procedure_blocks(old), procedure_blocks(new)
    if before.keys() != after.keys():
        raise ValueError('Procedure inventory changed')
    result, count = copy.deepcopy(manifest), 0
    entries = result['source_hashes'] if purity_manifest else result['procedures']
    for name, entry in entries.items():
        actual = entry if purity_manifest else entry['source_hash']
        if actual != code_hash(before[name]):
            raise ValueError(f'{name}: old review hash does not match supplied source')
        updated = code_hash(after[name])
        if actual != updated:
            count += 1
        if purity_manifest:
            entries[name] = updated
        else:
            entry['source_hash'] = updated
    return result, count


def migrate(before, after):
    if transform_fixed(before) != after:
        raise ValueError('Fixed source change is not exactly the approved final-RETURN cleanup')
    read = lambda name: json.loads((ROOT / 'tools' / name).read_text())
    data_old, pure_old, generic_old = [read(name) for name in
                                      ('data-constants.json', 'procedure-purity.json', 'generic-intrinsics.json')]
    old = format_source(lowercase(convert_text(before.decode('ascii'))))
    new = format_source(lowercase(convert_text(after.decode('ascii'))))
    data_new, data_count = refresh(old, new, data_old)
    old = portable(constants(sentence_case(old).text, data_old))
    new = portable(constants(sentence_case(new).text, data_new))
    pure_new, pure_count = refresh(old, new, pure_old, True)
    old = style(fixes(purity(old, pure_old)))
    new = style(fixes(purity(new, pure_new)))
    generic_new, generic_count = refresh(old, new, generic_old)
    old = coalesce(generics(old, generic_old))
    new = coalesce(generics(new, generic_new))
    if old != (ROOT / 'nswc.f90').read_text(encoding='ascii'):
        raise ValueError('Existing free-form source does not reproduce from supplied old fixed source')
    if transform_free(old) != new:
        raise ValueError('Final free-form output changed beyond terminal RETURN removal')
    return {'data-constants.json': data_new, 'procedure-purity.json': pure_new,
            'generic-intrinsics.json': generic_new}, {
                'data_hashes': data_count, 'purity_hashes': pure_count, 'intrinsic_hashes': generic_count}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', type=Path)
    parser.add_argument('after', type=Path)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    manifests, counts = migrate(args.before.read_bytes(), args.after.read_bytes())
    if args.apply:
        for name, manifest in manifests.items():
            (ROOT / 'tools' / name).write_text(json.dumps(manifest, indent=2) + '\n', encoding='ascii', newline='\n')
    print(counts)
    print('Only review hashes change; constants, interfaces, intents and selection records are preserved.')


if __name__ == '__main__':
    main()
