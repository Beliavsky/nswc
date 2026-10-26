"""Reconstruct the reviewed second DO pass and verify GNU assembly/symbols."""
import csv
from collections import Counter
from io import StringIO
from pathlib import Path

from modernize_deleted_do import transform, verify
from modernize_do import Loop
from periodic_root_workspace import transform_fixed as workspace
from remove_final_returns import transform_fixed as returns
from validate_explicit_typing import fixed_stages
from modernize_arithmetic_if import transform as modernize_arithmetic_if
from modernize_remaining_features import transform as finish_remaining
from blktri_empty_factors import transform_fixed as correct_empty_factors
from remove_unused_labels import transform as clean_unused_labels
from source_comment_fixes import transform_fixed as fix_comments
from goto_to_exit import transform as convert_exits
from normalize_fixed_spacing import transform as normalize_spacing

ROOT = Path(__file__).resolve().parents[1]


def main():
    before = workspace(returns(fixed_stages()[3].data))
    result = transform(before)
    if normalize_spacing(convert_exits(fix_comments(clean_unused_labels(correct_empty_factors(finish_remaining(modernize_arithmetic_if(result.data))))))) != (ROOT / 'nswc.f').read_bytes():
        raise ValueError('Maintained fixed form does not reproduce DO modernization')
    output = StringIO(newline='')
    writer = csv.writer(output, lineterminator='\n')
    writer.writerow(Loop.__dataclass_fields__)
    writer.writerows(vars(r).values() for r in result.loops)
    if output.getvalue() != (ROOT / 'docs/deleted-do-review.csv').read_text():
        raise ValueError('Second DO pass report is stale')
    if transform(result.data).data != result.data:
        raise ValueError('Second DO pass is not idempotent')
    verify(before, result.data)
    print(Counter(r.status for r in result.loops))
    print('Compiler symbols and assembly agree; only runtime diagnostic line text may differ.')


if __name__ == '__main__':
    main()
