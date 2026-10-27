"""Refresh review hashes after verified label cleanup or structured loop exits.

Normally only hashes and computed-transfer source line numbers may change.
The generics mode also repeats the downstream intrinsic binding review. Types,
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


def migrate(before, after, transformer=transform, review_generics=False):
    if transformer(before) != after:
        raise ValueError('Source change does not match the requested transformation')
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
    if review_generics:
        # Moving the reviewed generic pass into fixed form changes its input
        # inventory, so recheck bindings rather than just migrating hashes.
        from generic_intrinsics import review as intrinsic_review, compile_dump as intrinsic_dump
        with tempfile.TemporaryDirectory(prefix='nswc-fixed-generic-review-') as work:
            generic_new = intrinsic_review(new, symbols(intrinsic_dump(new, work)[0], True))
        gc = generic_new['summary']
    else:
        generic_new, gc = refresh(old, new, generic)
    old = returns(coalesce(generics(old, generic)))
    new = returns(coalesce(generics(new, generic_new)))
    with tempfile.TemporaryDirectory(prefix='nswc-label-review-') as work:
        obsolete_new = review(new, symbols(compile_dump(new, work)[0], True))
    if without_locations(obsolete_new) != without_locations(obsolete):
        raise ValueError('Control-flow cleanup changed the statement-function/transfer review')
    old = obsolescent(old, obsolete)
    new = obsolescent(new, obsolete_new)
    storage_new = copy.deepcopy(storage)
    storage_new.update(equivalence_review(new))
    if without_locations(storage_new) != without_locations(storage):
        raise ValueError('Control-flow cleanup changed equivalence bindings')
    old = equivalence_free(old, storage)
    new = equivalence_free(new, storage_new)
    if old != (ROOT/'nswc.f90').read_text():
        raise ValueError('Old pipeline does not reproduce maintained free form')
    state = {}
    module_state(module_source(new, modern_state=False, named_kinds=False), state)
    if state != storage['module_state']:
        raise ValueError('Control-flow cleanup changed private state bindings')
    return {'data-constants.json': data_new, 'procedure-purity.json': pure_new,
            'generic-intrinsics.json': generic_new, 'obsolescent-features.json': obsolete_new,
            'shared-storage.json': storage_new}, {'data': dc, 'purity': pc, 'generics': gc}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', type=Path)
    parser.add_argument('after', type=Path)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--conversion', choices=['labels', 'exits', 'generics', 'copies', 'sections'], default='labels')
    parser.add_argument('--compiler', help='Also verify fixed-form symbols, warnings and assembly')
    args = parser.parse_args()
    before, after = args.before.read_bytes(), args.after.read_bytes()
    transformer = transform
    if args.conversion == 'exits':
        from goto_to_exit import transform as transformer
    if args.conversion == 'generics':
        from fixed_generic_intrinsics import transform as transformer
    if args.conversion == 'sections':
        from declaration_sections import transform as transformer
        from validate_declaration_sections import verify as verify_sections
        verify_sections(before, after, args.compiler or 'gfortran')
    if args.conversion == 'copies':
        from remove_redundant_copies import transform as transformer
        from validate_redundant_copies import verify as verify_copies
        report = {}
        if transformer(before, report) != after:
            raise ValueError('Source change does not match copy cleanup')
        verify_copies(before, after, report, args.compiler or 'gfortran')
    if args.compiler and args.conversion not in ('copies', 'sections'):
        if args.conversion == 'generics':
            from fixed_generic_intrinsics import review as fixed_review, MANIFEST as fixed_manifest
            if fixed_review(before, args.compiler) != json.loads(fixed_manifest.read_text()):
                raise ValueError('Fixed intrinsic binding review is stale')
        elif args.conversion == 'exits':
            from goto_to_exit import verify
        else:
            from remove_unused_labels import verify
        if args.conversion != 'generics':
            verify(before, after, args.compiler)
    manifests, counts = migrate(before, after, transformer, review_generics=args.conversion == 'generics')
    if args.apply:
        for name, data in manifests.items():
            (ROOT/'tools'/name).write_text(json.dumps(data, indent=2)+'\n', newline='\n')
    print('Refreshed downstream reviews:', counts)


if __name__ == '__main__':
    main()
