"""Apply reviewed ODE workspace and callback refinements to intent analysis."""
import json
from pathlib import Path
import tempfile
from additional_intents import analyze as general_analyze, transform as apply_manifest
from explicit_typing import digest
from generic_intrinsics import compile_dump
from validate_explicit_typing import symbols
CONTRACTS=Path(__file__).with_name('ode-intent-contracts.json')
MANIFEST=Path(__file__).with_name('ode-intents.json')


def analyze(data, inventory):
    review=json.loads(CONTRACTS.read_text())
    if digest(data)!=review['input_sha256']:
        raise ValueError('Source differs from the ODE workspace review')
    if digest(CONTRACTS.with_name('callback_interfaces.py').read_bytes())!=review['callback_source_sha256']:
        raise ValueError('ODE callback contracts changed')
    result=general_analyze(data,inventory,review)
    for p,args in result['procedures'].items():
        for d,entry in args.items():
            expected=review['alias_safe'].get(p+':'+d)
            if expected and entry['intent']!=expected['intent']:
                raise ValueError('Inferred intent differs from workspace review: '+p+':'+d)
    result['refinement_sha256']=digest(json.dumps(review, sort_keys=True).encode('ascii'))
    return result


def transform(data, manifest=None):
    return apply_manifest(data,manifest or json.loads(MANIFEST.read_text()))


def finish(data):
    from additional_intents import transform as previous
    return transform(previous(data))


def main():
    import argparse
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('source',type=Path);p.add_argument('--report',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();data=args.source.read_bytes()
    with tempfile.TemporaryDirectory(prefix='nswc-ode-intents-') as work:
        inventory=symbols(compile_dump(data.decode('ascii'),work,fixed=True)[0],True)
    result=analyze(data,inventory);after=transform(data,result);result['output_sha256']=digest(after)
    with args.report.open('x') as out:json.dump(result,out,indent=2);out.write('\n')
    with args.output.open('xb') as out:out.write(after)
    print({mode:sum(e['intent']==mode for a in result['procedures'].values() for e in a.values()) for mode in ('IN','INOUT')},flush=True)

if __name__=='__main__':main()
