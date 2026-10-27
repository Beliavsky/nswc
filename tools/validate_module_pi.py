"""Verify shared pi constants, compiler output, and module regeneration."""
import argparse
import copy
import json
from pathlib import Path
import tempfile
from module_pi_constants import transform, MANIFEST, NAMES, DEFINITIONS
from module_kinds import DEFINITION as KINDS
from generic_intrinsics import compile_dump
from validate_explicit_typing import symbols
from validate_interfaces import command_run
from generate_interfaces import compiler_environment
ROOT=Path(__file__).resolve().parents[1]


def normalize_records(external,module,review):
    """Restore only reviewed parameter names after checking types/attributes."""
    result=copy.deepcopy(module)
    parent=result['NSWC_MOD']
    for constant in NAMES:
        record=parent[constant]
        if 'PARAMETER' not in record.get('attributes',''):
            raise ValueError('Shared constant is not a parameter: '+constant)
    for row in review['declarations']:
        scope,name,constant=row['procedure'],row['name'],row['constant']
        old=external[scope][name]
        if name in result[scope] or 'PARAMETER' not in old.get('attributes',''):
            raise ValueError('Expected removed local parameter: '+scope+'::'+name)
        if old.get('type spec')!=parent[constant].get('type spec') or 'Array spec' in old:
            raise ValueError('Shared parameter type changed: '+scope+'::'+name)
        result[scope][name]=old
    for scope in result.values():
        for name in NAMES: scope.pop(name,None)
    return result


def probe_source(review):
    rows=sorted({(r['literal'],r['constant']) for r in review['declarations']+review['literals']})
    declarations=[];checks=[]
    for i,(literal,constant) in enumerate(rows):
        kind=constant.rsplit('_',1)[1]
        declarations.append(f'real(nswc_{kind}), parameter :: old_{i} = {literal}\n')
        checks.append(f'if (any(transfer(old_{i}, [0_int8]) /= transfer({constant}, [0_int8]))) error stop {i+1}\n')
    return ('program check_pi\nuse iso_fortran_env, only: int8\nimplicit none\n'+KINDS+DEFINITIONS+
            ''.join(declarations)+
            "if (storage_size(0.0) /= 32 .or. storage_size(0.0d0) /= 64) error stop 'Expected binary32/binary64'\n"+
            ''.join(checks)+"print *, 'pi bit patterns: PASS'\nend program check_pi\n")


def verify_values(review,compiler='gfortran',intel=False,env=None):
    with tempfile.TemporaryDirectory(prefix='nswc-pi-values-') as folder:
        folder=Path(folder);(folder/'probe.f90').write_text(probe_source(review),newline='\n')
        exe=folder/'probe.exe'
        command=([compiler,'/nologo','/fp:strict','probe.f90','/exe:'+str(exe)] if intel else
                 [compiler,'-std=f2023','-pedantic-errors','probe.f90','-o',str(exe)])
        command_run(command,folder,env)
        result=command_run([str(exe)],folder,env)
        if 'pi bit patterns: PASS' not in result.stdout: raise ValueError(result.stdout)
        print(('Intel' if intel else 'GNU')+': '+result.stdout.strip(),flush=True)


def verify_assembly(before,after,review):
    with tempfile.TemporaryDirectory(prefix='nswc-pi-assembly-') as folder:
        old=compile_dump(before,folder)
        new=compile_dump(after,folder)
        if old[3]!=new[3]:
            mismatches=[(i,a,b) for i,(a,b) in enumerate(zip(old[3],new[3])) if a!=b]
            raise ValueError('Assembly changed: '+str(mismatches[:8]))
        original=symbols(old[0],True,True)
        adjusted=normalize_records(original,symbols(new[0],True,True),review)
        if original!=adjusted: raise ValueError('Unexpected compiler symbol changes')
    print('GNU assembly and all unreviewed compiler symbols agree with source locations aligned.',flush=True)


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--ifx');p.add_argument('--intel-env',type=Path)
    args=p.parse_args()
    from generate_module import module_source
    before=module_source((ROOT/'nswc.f90').read_text(),pi_constants=False)
    report={};aligned=[];after=transform(before,report,aligned)
    if report!=json.loads(MANIFEST.read_text()) or after!=(ROOT/'nswc_mod.f90').read_text():
        raise ValueError('Shared pi generation or review does not reproduce')
    if transform(after)!=after: raise ValueError('Pi cleanup is not idempotent')
    verify_values(report)
    if args.ifx: verify_values(report,args.ifx,True,compiler_environment(args.intel_env))
    verify_assembly(*aligned,report)

if __name__=='__main__':main()
