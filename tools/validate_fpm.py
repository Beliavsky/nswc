"""Test an isolated Fortran-only package and a downstream fpm consumer."""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from generate_fpm import outputs,obsolete,ROOT
from generate_interfaces import compiler_environment


def run(command,folder,env):
    print('Running: '+' '.join(map(str,command)),flush=True)
    result=subprocess.run(command,cwd=folder,env=env,capture_output=True,text=True,timeout=1200)
    if result.returncode:
        raise RuntimeError(result.stdout+'\n'+result.stderr)
    return result.stdout+'\n'+result.stderr


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--compiler',default='gfortran');p.add_argument('--fpm',default='fpm')
    p.add_argument('--profile',choices=['debug','release'],action='append')
    p.add_argument('--intel-env',type=Path);args=p.parse_args()
    env=compiler_environment(args.intel_env);fpm=shutil.which(args.fpm,path=env.get('PATH'))
    if not fpm:raise ValueError('fpm executable was not found')
    expected=outputs()
    if obsolete(ROOT,expected) or any(not path.is_file() or path.read_bytes()!=text.encode('ascii') for path,text in expected.items()):
        raise ValueError('Generated fpm sources are stale')
    if {p.name for p in (ROOT/'src').glob('*.f90')}!={'nswc_mod.f90'}:
        raise ValueError('The fpm library must contain only the module implementation')
    tests=[p.stem for p in expected if p.parent.name=='test']
    profiles=args.profile or ['debug','release']
    with tempfile.TemporaryDirectory(prefix='nswc-fpm-check-') as work:
        folder=Path(work);package=folder/'package';package.mkdir()
        shutil.copy2(ROOT/'fpm.toml',package/'fpm.toml')
        for name in ['src','test','example']:shutil.copytree(ROOT/name,package/name)
        for profile in profiles:
            flags=['--compiler',args.compiler,'--profile',profile]
            output=run([fpm,'test',*flags],package,env)
            missing=[name for name in tests if not re.search(r'^\s*'+re.escape(name)+r': PASS\s*$',output,re.M)]
            if missing:raise ValueError('Test completion markers missing: '+str(missing))
            print(f'{args.compiler} / {profile}: all {len(tests)} numerical drivers passed.',flush=True)
            output=run([fpm,'run','--example','--all',*flags],package,env)
            for marker in ['Single precision roots:','Solution:','Integral of x**2 on [0,1]:']:
                if marker not in output:raise ValueError('Example did not complete: '+marker)
            print(f'{args.compiler} / {profile}: all three examples passed.',flush=True)
        consumer=folder/'consumer';(consumer/'app').mkdir(parents=True)
        (consumer/'fpm.toml').write_text('name = "nswc-consumer"\n[dependencies]\nnswc = { path = "../package" }\n',newline='\n')
        (consumer/'app/main.f90').write_text('''program consumer
use nswc_mod, only: cbrt, ddot
implicit none
double precision :: a(2)=[1.d0,2.d0], b(2)=[3.d0,4.d0]
if (abs(cbrt(-8.)+2.)>2.e-5) error stop 'cube root dependency'
if (abs(ddot(2,a,1,b,1)-11.d0)>1.d-12) error stop 'dot product dependency'
print *, 'fpm dependency: PASS'
end program consumer
''',newline='\n')
        output=run([fpm,'run','--compiler',args.compiler,'--profile','debug'],consumer,env)
        if 'fpm dependency: PASS' not in output:raise ValueError('Downstream dependency test did not complete')
        print(f'{args.compiler}: downstream dependency and Fortran-only package passed.',flush=True)

if __name__=='__main__':main()
