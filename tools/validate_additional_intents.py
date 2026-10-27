"""Reproduce and compiler-check the supplemental argument-intent review."""
import json
from pathlib import Path
import re
import tempfile
from additional_intents import MANIFEST, analyze, transform
from generic_intrinsics import compile_dump
from validate_explicit_typing import symbols
ROOT=Path(__file__).resolve().parents[1]


def verify(before, after, manifest, compiler='gfortran'):
    if transform(before,manifest)!=after or transform(after,manifest)!=after:
        raise ValueError('Additional intent transformation does not reproduce')
    with tempfile.TemporaryDirectory(prefix='nswc-intent-proof-') as folder:
        old=compile_dump(before.decode('ascii'),folder,compiler,fixed=True)
        new=compile_dump(after.decode('ascii'),folder,compiler,fixed=True)
    old_records=symbols(old[0],include_intrinsics=True)
    new_records=symbols(new[0],include_intrinsics=True)
    report=analyze(before,old_records)
    if report!={k:v for k,v in manifest.items() if k!='output_sha256'}:
        raise ValueError('Intent evidence does not reproduce')
    for p,args in manifest['procedures'].items():
        for d,e in args.items():
            attrs=new_records[p][d.lower()]['attributes']
            expected='DUMMY('+e['intent']+')'
            if expected not in attrs:raise ValueError('Missing compiler intent: '+p+':'+d)
            new_records[p][d.lower()]['attributes']=attrs.replace(expected,'DUMMY')
    if old_records!=new_records:raise ValueError('Unreviewed symbol changes')
    normalize=lambda text:re.sub(r'DUMMY\((?:IN|OUT|INOUT)\)', 'DUMMY', text)
    if normalize(old[0])!=normalize(new[0]):raise ValueError('Executable tree changed')
    if re.findall(r'Warning:.*',old[1])!=re.findall(r'Warning:.*',new[1]):raise ValueError('Warnings changed')
    print('Intent evidence, compiler attributes, executable trees, warnings and idempotence verified.',flush=True)


def main():
    from validate_declaration_sections import historical_input
    from declaration_sections import transform as sections
    before=sections(historical_input())
    verify(before,(ROOT/'nswc.f').read_bytes(),json.loads(MANIFEST.read_text()))

if __name__=='__main__':main()
