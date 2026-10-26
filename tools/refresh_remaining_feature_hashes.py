"""Migrate only review hashes after verified assigned-label and DO conversion."""
import argparse
import json
from pathlib import Path

from modernize_remaining_features import verify
from refresh_do_review_hashes import ROOT, migrate_reviewed_pipeline


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before', type=Path)
    parser.add_argument('after', type=Path)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    before, after = args.before.read_bytes(), args.after.read_bytes()
    verify(before, after)
    manifests, counts = migrate_reviewed_pipeline(before, after)
    if args.apply:
        for name, data in manifests.items():
            (ROOT / 'tools' / name).write_text(json.dumps(data, indent=2) + '\n', newline='\n')
    print('Verified selector mappings, compiler symbols and DO assembly; refreshed only hashes:', counts)


if __name__ == '__main__':
    main()
