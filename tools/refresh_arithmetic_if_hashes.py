"""Refresh only pipeline review hashes after verified arithmetic IF conversion."""
import argparse
import json
from pathlib import Path

from modernize_arithmetic_if import MANIFEST, verify
from refresh_do_review_hashes import ROOT, migrate_reviewed_pipeline


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', type=Path)
    parser.add_argument('after', type=Path)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--baseline-free', type=Path,
                        help='Verified old free source when repeating a migration after generation')
    args = parser.parse_args()
    before, after = args.before.read_bytes(), args.after.read_bytes()
    verify(before, after, json.loads(MANIFEST.read_text()))
    expected = args.baseline_free.read_text(encoding='ascii') if args.baseline_free else None
    manifests, counts = migrate_reviewed_pipeline(before, after, expected)
    if args.apply:
        for name, data in manifests.items():
            (ROOT / 'tools' / name).write_text(json.dumps(data, indent=2) + '\n', newline='\n')
    print('Verified arithmetic IF replacements; refreshed only hashes:', counts)


if __name__ == '__main__':
    main()
