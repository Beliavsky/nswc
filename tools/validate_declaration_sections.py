"""Reproduce declaration sections and verify unchanged GNU semantic trees."""
import json
from pathlib import Path
import re
import tempfile
from declaration_sections import transform,MARKER,MANIFEST
from generic_intrinsics import compile_dump
ROOT=Path(__file__).resolve().parents[1]


def verify(before,after,compiler='gfortran'):
    def comments(data):
        return [s for s in data.decode('latin-1').splitlines() if s and s[0] in 'Cc*!' and s.strip().lower()!=MARKER.lower()]
    if comments(before)!=comments(after): raise ValueError('Original comment stream changed')
    if transform(after)!=after: raise ValueError('Declaration sections are not idempotent')
    with tempfile.TemporaryDirectory(prefix='nswc-section-proof-') as folder:
        old=compile_dump(before.decode('ascii'),folder,compiler,fixed=True)
        new=compile_dump(after.decode('ascii'),folder,compiler,fixed=True)
        if old[0]!=new[0]: raise ValueError('Compiler symbol records or executable trees changed')
        warnings=lambda text:re.findall(r'Warning:.*',text)
        if warnings(old[1])!=warnings(new[1]):raise ValueError('Compiler warning messages changed')
    print('GNU symbols, executable trees, warnings, and original comments agree; second application is unchanged.',flush=True)


def historical_input():
    from validate_unused_labels import baseline
    from remove_unused_labels import transform as labels
    from source_comment_fixes import transform_fixed as comments
    from goto_to_exit import transform as exits
    from normalize_fixed_spacing import transform as spacing
    from structure_terminal_branches import transform as branches
    from fixed_generic_intrinsics import transform as generics
    from remove_redundant_copies import transform as copies
    return copies(generics(branches(spacing(exits(comments(labels(baseline())))))))


def main():
    before=historical_input();report={};after=transform(before,report)
    from ode_intents import finish as intents
    if report!=json.loads(MANIFEST.read_text()) or intents(after)!=(ROOT/'nswc.f').read_bytes():
        raise ValueError('Declaration sections or review do not reproduce')
    verify(before,after)
    print(len(report['marked']),'procedures marked;',len(report['reordered']),'reorganized.')

if __name__=='__main__':main()
