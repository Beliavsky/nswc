"""Verify coalescing for the complete external and module implementations."""
from pathlib import Path

from coalesce_local_declarations import transform, verify
from generic_intrinsics import transform as apply_generics
from generate_module import module_source
from validate_generic_intrinsics import baseline_source
from remove_final_returns import transform_free as remove_final_returns
from modernize_obsolescent import transform as modernize_obsolescent
from storage_modernization import equivalence_free

ROOT = Path(__file__).resolve().parents[1]


def main():
    original = apply_generics(baseline_source())
    combined = transform(original)
    modern = equivalence_free(modernize_obsolescent(remove_final_returns(combined)))
    if modern != (ROOT / 'nswc.f90').read_text(encoding='ascii'):
        raise ValueError('External declaration coalescing differs from maintained source')
    for name, before, after in [('nswc.f90', original, combined),
                              ('nswc_mod.f90', module_source(original, coalesce=False, modern_state=False, named_kinds=False), module_source(combined, modern_state=False, named_kinds=False))]:
        expected = modern if name == 'nswc.f90' else module_source(modern)
        if expected != (ROOT / name).read_text(encoding='ascii'):
            raise ValueError(f'{name}: generated source differs')
        if transform(after) != after:
            raise ValueError(f'{name}: declaration coalescing is not idempotent')
        verify(before, after)
        print(f'{name}: compiler records, executable trees and assembly agree; only diagnostic source lines may differ.', flush=True)


if __name__ == '__main__':
    main()
