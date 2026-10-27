"""Verify shared constants, scope inventories and reproducible module generation."""
import argparse
import copy
import json
from pathlib import Path
import subprocess
import tempfile
from module_simple_constants import transform,MANIFEST,NAMES,DEFINITIONS
from module_kinds import DEFINITION as KINDS
from generate_interfaces import compiler_environment
from validate_interfaces import command_run
ROOT=Path(__file__).resolve().parents[1]


def verify_optimized(before,review):
    """Compare changed procedures and their transitive library dependencies."""
    from fortran_procedures import procedure_spans
    from validate_interfaces import restrict_public
    calls=json.loads((ROOT/'tools/procedure-purity.json').read_text())['calls']
    selected={row['procedure'] for row in review['selected']}
    pending=list(selected)
    while pending:
        for name in calls.get(pending.pop(),[]):
            if name not in selected:selected.add(name);pending.append(name)
    aligned=[];transform(before,aligned_sources=aligned);assembly=[]
    with tempfile.TemporaryDirectory(prefix='nswc-simple-optimized-') as work:
        folder=Path(work)
        for source in aligned:
            lines=source.splitlines(True)
            for name,a,b in procedure_spans(source):
                if name not in selected:
                    lines[a:b]=['\n']*(b-a)
            source=restrict_public(''.join(lines),selected)
            (folder/'input.f90').write_text(source,newline='\n')
            result=subprocess.run(['gfortran','-O2','-std=f2023','-S','input.f90','-o','input.s'],
                                  cwd=folder,capture_output=True,text=True,timeout=180)
            if result.returncode:raise ValueError(result.stderr)
            assembly.append((folder/'input.s').read_text())
        if assembly[0]!=assembly[1]:raise ValueError('Optimized assembly differs for affected procedures')
    print(f'GNU -O2: assembly unchanged for {len(selected)} affected procedures and dependencies.',flush=True)


def normalize_records(before,after,review):
    result=copy.deepcopy(after);parent=result['NSWC_MOD']
    for name in NAMES:
        if 'PARAMETER' not in parent[name].get('attributes',''):
            raise ValueError('Shared constant is not a parameter: '+name)
    for row in review['selected']:
        scope,name,constant=row['procedure'],row['name'],row['constant']
        old=before[scope][name]
        if name in result[scope] or 'Array spec' in old or old.get('type spec')!=parent[constant].get('type spec'):
            raise ValueError('Unexpected local constant/type change: '+scope+'::'+name)
        if ('PARAMETER' in old.get('attributes',''))!=(row['origin']=='parameter'):
            raise ValueError('Unexpected original declaration: '+scope+'::'+name)
        result[scope][name]=old
    for scope in result.values():
        for name in NAMES:scope.pop(name,None)
    return result


def verify_values(review,compiler='gfortran',intel=False,env=None):
    rows=sorted({(r['type'],r['literal'],r['constant']) for r in review['selected']})
    declarations=[];checks=[]
    for i,(typ,literal,constant) in enumerate(rows):
        declarations.append(f'{typ}, parameter :: old_{i} = {literal}\n')
        checks.append(f'if (any(transfer(old_{i}, [0_int8]) /= transfer({constant}, [0_int8]))) error stop {i+1}\n')
    source=('program probe\nuse iso_fortran_env, only: int8\nimplicit none\n'+KINDS+DEFINITIONS+
            ''.join(declarations)+''.join(checks)+"print *, 'simple constant bit patterns: PASS'\nend program probe\n")
    with tempfile.TemporaryDirectory(prefix='nswc-simple-values-') as work:
        folder=Path(work);(folder/'probe.f90').write_text(source,newline='\n');exe=folder/'probe.exe'
        command=([compiler,'/nologo','/fp:strict','probe.f90','/exe:'+str(exe)] if intel else
                 [compiler,'-std=f2023','-pedantic-errors','probe.f90','-o',str(exe)])
        command_run(command,folder,env);r=command_run([str(exe)],folder,env)
        if 'simple constant bit patterns: PASS' not in r.stdout:raise ValueError(r.stdout)
        print(('Intel' if intel else 'GNU')+': '+r.stdout.strip(),flush=True)


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--ifx');p.add_argument('--intel-env',type=Path)
    args=p.parse_args()
    from generate_module import module_source
    from ford_documentation import strip,transform as documentation
    from declaration_sections import remove_empty_free_markers
    source=(ROOT/'nswc.f90').read_text();before=strip(module_source(source,simple_constants=False))
    review={};after=transform(before,review)
    if review!=json.loads(MANIFEST.read_text()):raise ValueError('Simple constant review is stale')
    if documentation(remove_empty_free_markers(after))!=(ROOT/'nswc_mod.f90').read_text():raise ValueError('Shared constant generation is stale')
    if transform(after)!=after:raise ValueError('Pass is not idempotent')
    verify_values(review)
    if args.ifx:verify_values(review,args.ifx,True,compiler_environment(args.intel_env))
    from generic_intrinsics import compile_dump
    aligned=[];transform(before,variables=False,aligned_sources=aligned)
    with tempfile.TemporaryDirectory(prefix='nswc-simple-assembly-') as work:
        old=compile_dump(aligned[0],work);new=compile_dump(aligned[1],work)
        if old[3]!=new[3]:raise ValueError('Parameter consolidation changed GNU assembly')
    print('GNU: parameter-only consolidation preserves assembly with source locations aligned.',flush=True)
    verify_optimized(before,review)
    print(f'Confirmed {len(review["selected"])} shared local constants.',flush=True)

if __name__=='__main__':main()
