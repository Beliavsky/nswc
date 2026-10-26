"""Reconstruct the arithmetic IF pass and verify type/contract preservation."""
import json
from pathlib import Path

from modernize_arithmetic_if import MANIFEST, candidates, transform, verify
from modernize_deleted_do import transform as loops
from periodic_root_workspace import transform_fixed as workspace
from remove_final_returns import transform_fixed as returns
from validate_explicit_typing import fixed_stages
from modernize_remaining_features import transform as finish_remaining
from blktri_empty_factors import transform_fixed as correct_empty_factors
from remove_unused_labels import transform as clean_unused_labels

ROOT = Path(__file__).resolve().parents[1]


def main():
    before = loops(workspace(returns(fixed_stages()[3].data))).data
    manifest = json.loads(MANIFEST.read_text())
    after = transform(before, manifest)
    if clean_unused_labels(correct_empty_factors(finish_remaining(after))) != (ROOT / 'nswc.f').read_bytes():
        raise ValueError('Maintained fixed form differs from reviewed arithmetic IF conversion')
    verify(before, after, manifest)
    if candidates(after)[2] or transform(after, manifest) != after:
        raise ValueError('Arithmetic IF conversion is incomplete or not idempotent')
    # Re-run inference to check the recorded expression types independently.
    from modernize_arithmetic_if import review
    if review(before) != manifest:
        raise ValueError('Compiler expression-type review does not reproduce')
    print(f"Converted all {manifest['converted']} arithmetic IFs; expression types and original compiler symbols agree.")


if __name__ == '__main__':
    main()
