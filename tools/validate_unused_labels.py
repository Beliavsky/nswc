"""Reproduce label cleanup and verify symbols, warnings, comments and assembly."""
import json
from pathlib import Path

from remove_unused_labels import MANIFEST, transform, verify
from source_comment_fixes import transform_fixed as fix_comments
from goto_to_exit import transform as convert_exits

ROOT = Path(__file__).resolve().parents[1]


def baseline():
    from validate_explicit_typing import fixed_stages
    from remove_final_returns import transform_fixed as returns
    from periodic_root_workspace import transform_fixed as workspace
    from modernize_deleted_do import transform as loops
    from modernize_arithmetic_if import transform as arithmetic
    from modernize_remaining_features import transform as remaining
    from blktri_empty_factors import transform_fixed as bounds
    return bounds(remaining(arithmetic(loops(workspace(returns(fixed_stages()[3].data))).data)))


def main():
    before = baseline()
    report = {}
    after = transform(before, report)
    if convert_exits(fix_comments(after)) != (ROOT/'nswc.f').read_bytes():
        raise ValueError('Maintained fixed form does not reproduce label cleanup')
    if report != json.loads(MANIFEST.read_text()):
        raise ValueError('Unused-label review report is stale')
    verify(before, after)
    print(report['counts'])
    print('Compiler symbols, warnings and assembly agree; comments are preserved.')


if __name__ == '__main__':
    main()
