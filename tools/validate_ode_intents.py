"""Reproduce reviewed ODE intents and verify compiler semantics."""
import json
from pathlib import Path
from ode_intents import MANIFEST,analyze,transform
from validate_additional_intents import verify
ROOT=Path(__file__).resolve().parents[1]


def main():
    from validate_declaration_sections import historical_input
    from declaration_sections import transform as sections
    from additional_intents import transform as previous
    before=previous(sections(historical_input()))
    from structure_terminal_branches import transform_two_way
    after=transform(before)
    if transform_two_way(after)!=(ROOT/'nswc.f').read_bytes():
        raise ValueError('ODE intents and terminal branches do not reproduce')
    verify(before,after,json.loads(MANIFEST.read_text()),analyzer=analyze,transformer=transform)

if __name__=='__main__':main()
