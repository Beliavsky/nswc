"""Reproduce the fixed-form intrinsic review and its compiler equivalence proof."""
import json
from pathlib import Path
from fixed_generic_intrinsics import MANIFEST, review, transform
from goto_to_exit import transform as exits
from normalize_fixed_spacing import transform as spacing
from remove_unused_labels import transform as labels
from source_comment_fixes import transform_fixed as comments
from structure_terminal_branches import transform as branches
from validate_unused_labels import baseline

ROOT = Path(__file__).resolve().parents[1]

def main():
    before = branches(spacing(exits(comments(labels(baseline())))))
    expected = json.loads(MANIFEST.read_text())
    actual = review(before)
    if actual != expected:
        raise ValueError('Fixed intrinsic binding review does not reproduce')
    after = transform(before,actual)
    from remove_redundant_copies import transform as copies
    from declaration_sections import transform as sections
    if sections(copies(after)) != (ROOT/'nswc.f').read_bytes() or transform(after,actual) != after:
        raise ValueError('Fixed generic source does not reproduce or is not idempotent')
    print(actual['summary'])
    print('Assembly, unreviewed symbols, executable trees and warning messages agree.')

if __name__ == '__main__':
    main()
