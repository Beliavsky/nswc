"""Migrate review hashes for the verified second labelled-DO modernization pass.

Reject any other fixed-source edit. Require equal GNU assembly and data/procedure
symbols before updating hashes. All constant values, intents, purity selections,
call graphs and intrinsic selections are carried forward unchanged.
"""
import argparse
import copy
import json
from pathlib import Path

from coalesce_local_declarations import transform as coalesce
from data_constants import transform as constants
from fixed_to_free import convert_text
from format_free_form import format_source
from fortran_procedures import procedure_blocks
from free_source_fixes import transform as fixes
from generic_intrinsics import transform as generics
from lowercase_fortran import lowercase
from modernize_deleted_do import transform, verify
from portable_intrinsics import transform as portable
from procedure_purity import code_hash, transform as purity
from remove_final_returns import transform_free as returns
from sentence_case_comments import sentence_case
from simplify_free_style import transform as style
from modernize_obsolescent import transform as modernize_obsolescent

ROOT = Path(__file__).resolve().parents[1]


def refresh(old, new, manifest, purity_manifest=False):
    before, after = procedure_blocks(old), procedure_blocks(new)
    if before.keys() != after.keys():
        raise ValueError('DO migration changed the procedure inventory')
    result, count = copy.deepcopy(manifest), 0
    entries = result['source_hashes'] if purity_manifest else result['procedures']
    for name, entry in entries.items():
        expected = entry if purity_manifest else entry['source_hash']
        if expected != code_hash(before[name]):
            raise ValueError(f'{name}: old review hash does not match source')
        updated = code_hash(after[name])
        count += expected != updated
        if purity_manifest:
            entries[name] = updated
        else:
            entry['source_hash'] = updated
    return result, count


def migrate(before, after):
    if transform(before).data != after:
        raise ValueError('Source change is not exactly the reviewed DO transformation')
    verify(before, after)
    return migrate_reviewed_pipeline(before, after)


def migrate_reviewed_pipeline(before, after, expected_free=None):
    """Refresh hashes after the calling migration has verified its exact edit."""
    read = lambda name: json.loads((ROOT / 'tools' / name).read_text())
    data_old, pure_old, generic_old = [read(n) for n in
                                      ('data-constants.json', 'procedure-purity.json', 'generic-intrinsics.json')]
    old, new = [format_source(lowercase(convert_text(s.decode('ascii')))) for s in (before, after)]
    data_new, dc = refresh(old, new, data_old)
    old = portable(constants(sentence_case(old).text, data_old))
    new = portable(constants(sentence_case(new).text, data_new))
    pure_new, pc = refresh(old, new, pure_old, True)
    old = style(fixes(purity(old, pure_old)))
    new = style(fixes(purity(new, pure_new)))
    generic_new, gc = refresh(old, new, generic_old)
    old = returns(coalesce(generics(old, generic_old)))
    new = returns(coalesce(generics(new, generic_new)))
    if expected_free is None:
        expected_free = (ROOT / 'nswc.f90').read_text(encoding='ascii')
        old = modernize_obsolescent(old)
    if old != expected_free:
        raise ValueError('Old reviewed pipeline does not reproduce maintained free form')
    return {'data-constants.json': data_new, 'procedure-purity.json': pure_new,
            'generic-intrinsics.json': generic_new}, {'data': dc, 'purity': pc, 'generics': gc}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', type=Path)
    parser.add_argument('after', type=Path)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    manifests, counts = migrate(args.before.read_bytes(), args.after.read_bytes())
    if args.apply:
        for name, data in manifests.items():
            (ROOT / 'tools' / name).write_text(json.dumps(data, indent=2) + '\n', newline='\n')
    print('Verified fixed-source assembly/symbol preservation; refreshed only hashes:', counts)


if __name__ == '__main__':
    main()
