"""Refresh review hashes after compiler-verified unused-label cleanup.

Only hashes and computed-transfer source line numbers may change. Types,
constant values, purity/intents, calls, intrinsic bindings, helper expressions,
and COMMON layouts must agree with the existing reviews.
"""
import argparse
import copy
import json
from pathlib import Path
import tempfile

from refresh_do_review_hashes import (refresh, format_source, lowercase, convert_text,
    constants, sentence_case, portable, purity, style, fixes, generics, returns, coalesce)
from modernize_obsolescent import transform as obsolescent, review, compile_dump
from storage_modernization import equivalence_free, equivalence_review, module_state
from generate_module import module_source
from remove_unused_labels import transform
from validate_explicit_typing import symbols

ROOT = Path(__file__).resolve().parents[1]


def without_locations(value):
    if isinstance(value, dict):
        return {k: without_locations(v) for k, v in value.items()
                if k not in {'source_hash', 'output_hash', 'line'}}
    if isinstance(value, list):
        return [without_locations(v) for v in value]
    return value


def migrate(before, after):
    if transform(before) != after:
        raise ValueError('Source change is not exactly the unused-label cleanup')
    read = lambda name: json.loads((ROOT/'tools'/name).read_text())
    data, pure, generic, obsolete, storage = [read(n) for n in
        ('data-constants.json', 'procedure-purity.json', 'generic-intrinsics.json',
         'obsolescent-features.json', 'shared-storage.json')]
    old, new = [format_source(lowercase(convert_text(s.decode('ascii')))) for s in (before, after)]
    data_new, dc = refresh(old, new, data)
    old = portable(constants(sentence_case(old).text, data))
    new = portable(constants(sentence_case(new).text, data_new))
    pure_new, pc = refresh(old, new, pure, True)
    old = style(fixes(purity(old, pure)))
    new = style(fixes(purity(new, pure_new)))
    generic_new, gc = refresh(old, new, generic)
    old = returns(coalesce(generics(old, generic)))
    new = returns(coalesce(generics(new, generic_new)))
    with tempfile.TemporaryDirectory(prefix='nswc-label-review-') as work:
        obsolete_new = review(new, symbols(compile_dump(new, work)[0], True))
    if without_locations(obsolete_new) != without_locations(obsolete):
        raise ValueError('Label cleanup changed the statement-function/transfer review')
    old = obsolescent(old, obsolete)
    new = obsolescent(new, obsolete_new)
    storage_new = copy.deepcopy(storage)
    storage_new.update(equivalence_review(new))
    if without_locations(storage_new) != without_locations(storage):
        raise ValueError('Label cleanup changed equivalence bindings')
    old = equivalence_free(old, storage)
    new = equivalence_free(new, storage_new)
    if old != (ROOT/'nswc.f90').read_text():
        raise ValueError('Old pipeline does not reproduce maintained free form')
    state = {}
    module_state(module_source(new, modern_state=False), state)
    if state != storage['module_state']:
        raise ValueError('Label cleanup changed private state bindings')
    return {'data-constants.json': data_new, 'procedure-purity.json': pure_new,
            'generic-intrinsics.json': generic_new, 'obsolescent-features.json': obsolete_new,
            'shared-storage.json': storage_new}, {'data': dc, 'purity': pc, 'generics': gc}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', type=Path)
    parser.add_argument('after', type=Path)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--compiler', help='Also verify fixed-form symbols, warnings and assembly')
    args = parser.parse_args()
    before, after = args.before.read_bytes(), args.after.read_bytes()
    if args.compiler:
        from remove_unused_labels import verify
        verify(before, after, args.compiler)
    manifests, counts = migrate(before, after)
    if args.apply:
        for name, data in manifests.items():
            (ROOT/'tools'/name).write_text(json.dumps(data, indent=2)+'\n', newline='\n')
    print('Refreshed only hashes and computed-transfer line numbers:', counts)


if __name__ == '__main__':
    main()
