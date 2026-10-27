"""Reproduce redundant-copy cleanup and compare optimized code and symbols."""
import json
from pathlib import Path
import subprocess
import tempfile
from explicit_typing import units
from remove_redundant_copies import transform, MANIFEST
from validate_explicit_typing import symbols
ROOT=Path(__file__).resolve().parents[1]


def verify(before,after,report,compiler='gfortran'):
    names={r['procedure'] for r in report['converted']}
    assemblies=[]; inventories=[]
    with tempfile.TemporaryDirectory(prefix='nswc-copy-proof-') as work:
        work=Path(work)
        for data in (before,after):
            lines,scopes=units(data)
            text=''.join(''.join(lines[a:c]) for n,(a,b,c) in scopes.items() if n in names)
            (work/'input.f').write_text(text,newline='\n')
            r=subprocess.run([compiler,'-std=f2023','-pedantic-errors','-O2','-S','-fdump-fortran-original','input.f'],cwd=work,capture_output=True,text=True,timeout=180)
            if r.returncode: raise RuntimeError(r.stderr)
            inventories.append(symbols(r.stdout,True))
            assemblies.append((work/'input.s').read_bytes())
        for row in report['converted']:
            inventories[0][row['procedure']].pop(row['temporary'].lower())
        if inventories[0]!=inventories[1]: raise ValueError('Unexpected compiler symbol change')
        if assemblies[0]!=assemblies[1]: raise ValueError('Optimized assembly changed')
    print('Reviewed temporary symbols removed; all remaining symbols and optimized assembly agree.')


def main():
    from validate_unused_labels import baseline
    from remove_unused_labels import transform as labels
    from source_comment_fixes import transform_fixed as comments
    from goto_to_exit import transform as exits
    from normalize_fixed_spacing import transform as spacing
    from structure_terminal_branches import transform as branches
    from fixed_generic_intrinsics import transform as generics
    before=generics(branches(spacing(exits(comments(labels(baseline()))))))
    report={}; after=transform(before,report)
    if report!=json.loads(MANIFEST.read_text()) or after!=(ROOT/'nswc.f').read_bytes():
        raise ValueError('Copy cleanup does not reproduce')
    if transform(after)!=after: raise ValueError('Cleanup is not idempotent')
    verify(before,after,report)

if __name__=='__main__': main()
