"""Reconstruct final control-flow modernization and compile all variants strictly."""
import json
from pathlib import Path
import subprocess
import tempfile

from modernize_remaining_features import MANIFEST, transform, verify, strict_standard
from modernize_arithmetic_if import transform as arithmetic
from modernize_deleted_do import transform as loops
from periodic_root_workspace import transform_fixed as workspace
from remove_final_returns import transform_fixed as returns
from validate_explicit_typing import fixed_stages
from blktri_empty_factors import transform_fixed as correct_empty_factors
from remove_unused_labels import transform as clean_unused_labels
from source_comment_fixes import transform_fixed as fix_comments

ROOT = Path(__file__).resolve().parents[1]


def main():
    before = arithmetic(loops(workspace(returns(fixed_stages()[3].data))).data)
    report = {}
    after = transform(before, report)
    if fix_comments(clean_unused_labels(correct_empty_factors(after))) != (ROOT / 'nswc.f').read_bytes():
        raise ValueError('Final control-flow source does not reproduce')
    if report != json.loads(MANIFEST.read_text()):
        raise ValueError('Final control-flow review report is stale')
    if transform(after) != after:
        raise ValueError('Final control-flow pass is not idempotent')
    verify(before, after)
    standard = strict_standard()
    with tempfile.TemporaryDirectory(prefix='nswc-strict-standard-') as work:
        for name in ('nswc.f', 'nswc.f90', 'nswc_mod.f90'):
            r = subprocess.run(['gfortran', standard, '-pedantic-errors', '-fsyntax-only', str(ROOT / name)],
                               cwd=work, capture_output=True, text=True, timeout=180)
            if r.returncode or 'deleted feature' in r.stderr.lower():
                raise RuntimeError(name + '\n' + r.stderr)
            print(f'{name}: {standard} -pedantic-errors accepted; no deleted features.', flush=True)
    print(report['transfer_counts'], report['loop_counts'])
    print('Existing compiler symbols agree except removal of ASSIGN flags; DO assembly agrees.')


if __name__ == '__main__':
    main()
