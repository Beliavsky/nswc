"""Reproduce fixed-form RETURN cleanup and check all maintained variants."""
import json
from pathlib import Path

from remove_final_returns import transform_fixed, transform_free, verify
from validate_explicit_typing import fixed_stages

ROOT = Path(__file__).resolve().parents[1]


def main():
    original = fixed_stages()[3].data
    report = {}
    cleaned = transform_fixed(original, report)
    if cleaned != (ROOT / 'nswc.f').read_bytes():
        raise ValueError('Maintained fixed-form source differs from final RETURN cleanup')
    if report != json.loads((ROOT / 'tools/final-return-cleanup.json').read_text()):
        raise ValueError('Fixed-form cleanup report does not reproduce')
    verify(original, cleaned, 'fixed')
    for name in ('nswc.f90', 'nswc_mod.f90'):
        text = (ROOT / name).read_text(encoding='ascii')
        if transform_free(text) != text:
            raise ValueError(f'{name}: removable terminal RETURN statements remain')
    print(f"Removed {report['removed']} terminal RETURNs; all compiler records agree after omitting terminal RETURN nodes.")
    print('Fixed-form reconstruction and cleanup report reproduce; both free-form variants are clean.')


if __name__ == '__main__':
    main()
