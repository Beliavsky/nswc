"""Reproduce reviewed loop exits and compare optimized compiler output."""
import json
from pathlib import Path

from goto_to_exit import MANIFEST, transform, verify
from structure_terminal_branches import finish_fixed
from normalize_fixed_spacing import verify as verify_spacing
from remove_unused_labels import transform as remove_labels
from source_comment_fixes import transform_fixed as fix_comments
from validate_unused_labels import baseline

ROOT = Path(__file__).resolve().parents[1]


def main():
    before = fix_comments(remove_labels(baseline()))
    report = {}
    after = transform(before, report)
    if finish_fixed(after) != (ROOT/'nswc.f').read_bytes():
        raise ValueError('Maintained fixed form does not reproduce structured exits')
    if report != json.loads(MANIFEST.read_text()):
        raise ValueError('Structured-exit review report is stale')
    verify(before, after)
    from normalize_fixed_spacing import transform as spacing
    verify_spacing(after, spacing(after))
    print({key: report[key] for key in ('converted', 'named_exits')})
    print('Existing symbols, warnings, comments and optimized assembly agree.')


if __name__ == '__main__':
    main()
