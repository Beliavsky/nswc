"""Reproduce two-way terminal branches and compare both paths numerically."""
import json
from pathlib import Path
import re
import subprocess
import tempfile
from explicit_typing import units
from structure_terminal_branches import transform_two_way as transform,TWO_WAY_MANIFEST as MANIFEST
from validate_explicit_typing import symbols
ROOT=Path(__file__).resolve().parents[1]
DRIVER='''program check_two_way
implicit none
real, external :: blnd_old,blnd_new,logam_old,logam_new,conew_old,conew_new
double precision, external :: glog_old,glog_new
complex, external :: cdiv_old,cdiv_new
real :: x,y,u,v,p,q,da,db,sa,sb,pc,pr,qc,qr,av,bv,f,g
real :: a(4),b(4),c(8),d(8),wa(2),wb(2),ta(4),tb(4)
double precision :: du,dv,dp,dq,ad(4),bd(4),wd(2),we(2),td(4),te(4)
complex :: z1,z2
integer :: i,j,k,n,ka,e1,e2
real, parameter :: logs(6)=[0.5,1.,20.,100.,100.5,1000.]
real, parameter :: glogs(5)=[15.,15.5,177.99,178.,1.e10]
real, parameter :: abeta(5)=[0.5,2.,20.,20.5,50.]
real, parameter :: sigmas(4)=[0.,-0.,0.5,10.]
real, parameter :: residuals(5)=[0.,-0.,0.25,1.,8.]
do i=-3,3
 do j=-3,3
  if(i==0.and.j==0) cycle
  x=real(i);y=real(j)
  call crec_old(x,y,u,v)
  call crec_new(x,y,p,q)
  call close(u,p);call close(v,q)
  call dcrec_old(dble(x),dble(y),du,dv)
  call dcrec_new(dble(x),dble(y),dp,dq)
  call close_d(du,dp);call close_d(dv,dq)
  z1=cdiv_old(cmplx(2.,-1.),cmplx(x,y))
  z2=cdiv_new(cmplx(2.,-1.),cmplx(x,y))
  call close(real(z1),real(z2));call close(aimag(z1),aimag(z2))
 end do
end do
do i=1,size(logs)
 call close(logam_old(logs(i)),logam_new(logs(i)))
end do
do i=1,size(glogs)
 call close_d(glog_old(glogs(i)),glog_new(glogs(i)))
end do
do i=1,size(abeta)
 call close(blnd_old(abeta(i),2.5),blnd_new(abeta(i),2.5))
end do
do i=1,size(sigmas)
 call terms_old(da,sa,sigmas(i),0.75)
 call terms_new(db,sb,sigmas(i),0.75)
 call close(da,db);call close(sa,sb)
end do
do i=1,size(residuals)
 pc=2.;pr=3.;qc=pc;qr=pr
 f=conew_old(9.,4.,residuals(i),av,pc,pr)
 g=conew_new(9.,4.,residuals(i),bv,qc,qr)
 call close(f,g);call close(av,bv);call close(pc,qc);call close(pr,qr)
end do
n=4
do i=-3,3
 a=[1.,2.,3.,4.];b=[0.5,0.,-0.5,0.]
 c(1:4)=a;c(5:8)=b;e1=-99;e2=e1
 call fft1_old(a,b,n,i,e1)
 call fft1_new(c(1:4),c(5:8),n,i,e2)
 if(e1/=e2) error stop 'FFT1 error code'
 if(abs(i)/=1.and.e1/=4) error stop 'FFT1 invalid sign'
 do j=1,4
  call close(a(j),c(j));call close(b(j),c(j+4))
 end do
 c=[1.,0.5,2.,0.,3.,-0.5,4.,0.];d=c;e1=-99;e2=e1
 call fft_old(c,n,i,e1)
 call fft_new(d,n,i,e2)
 if(e1/=e2) error stop 'FFT error code'
 if(abs(i)/=1.and.e1/=4) error stop 'FFT invalid sign'
 do j=1,8
  call close(c(j),d(j))
 end do
end do
n=2
do k=0,1
 ka=2*k
 do i=1,2
  if(ka==0) then
   a=[2.,1.,3.,0.]
  else
   a=[2.,1.,1.,3.]
  end if
  b=a;ta=0.;tb=0.;wa=0.;wb=0.;e1=-99;e2=e1
  if(i==1) then
   call seig_old(a,ka,n,wa,ta,e1)
   call seig_new(b,ka,n,wb,tb,e2)
  else
   call seig1_old(a,ka,n,wa,ta,e1)
   call seig1_new(b,ka,n,wb,tb,e2)
  end if
  if(e1/=e2) error stop 'SEIG error code'
  do j=1,2
   call close(wa(j),wb(j))
  end do
  do j=1,4
   call close(a(j),b(j));call close(ta(j),tb(j))
  end do
 end do
 if(ka==0) then
  ad=[2.d0,1.d0,3.d0,0.d0]
 else
  ad=[2.d0,1.d0,1.d0,3.d0]
 end if
 bd=ad;td=0.;te=0.;wd=0.;we=0.;e1=-99;e2=e1
 call dseig_old(ad,ka,n,wd,td,e1)
 call dseig_new(bd,ka,n,we,te,e2)
 if(e1/=e2) error stop 'DSEIG error code'
 do j=1,2
  call close_d(wd(j),we(j))
 end do
 do j=1,4
  call close_d(ad(j),bd(j));call close_d(td(j),te(j))
 end do
end do
print *, 'two-way terminal branches: PASS'
contains
subroutine close(x,y)
real,intent(in)::x,y
if(.not.(abs(x-y)<=4.e-6*max(1.,abs(x),abs(y)))) error stop 'real result differs'
end subroutine
subroutine close_d(x,y)
double precision,intent(in)::x,y
if(.not.(abs(x-y)<=8.d-14*max(1.d0,abs(x),abs(y)))) error stop 'double result differs'
end subroutine
end program
'''


def verify(before,after,report,compiler='gfortran'):
    if transform(before)!=after or transform(after)!=after:raise ValueError('Transformation is not exact and idempotent')
    names={r['procedure'] for r in report['converted']}
    expected={'CREC','DCREC','CDIV','GLOG','BLND','LOGAM','SEIG','SEIG1','DSEIG','FFT','FFT1','TERMS','CONEW'}
    if names!=expected:raise ValueError('Update numerical probes for changed candidate inventory: '+str(names^expected))
    sources=[]
    for data in (before,after):
        lines,scopes=units(data)
        sources.append(''.join(''.join(lines[a:c]) for n,(a,_,c) in scopes.items() if n in names))
    with tempfile.TemporaryDirectory(prefix='nswc-two-way-check-') as work:
        folder=Path(work);inventories=[]
        for source in sources:
            (folder/'input.f').write_text(source,newline='\n')
            r=subprocess.run([compiler,'-std=f2023','-pedantic-errors','-fsyntax-only','-fdump-fortran-original','input.f'],cwd=folder,capture_output=True,text=True,timeout=120)
            if r.returncode:raise RuntimeError(r.stderr)
            inventories.append(symbols(r.stdout,True))
        if inventories[0]!=inventories[1]:raise ValueError('Compiler symbol records changed')
        (folder/'library.f').write_bytes(before)
        r=subprocess.run([compiler,'-std=f2023','-c','library.f','-o','library.o'],cwd=folder,capture_output=True,text=True,timeout=180)
        if r.returncode:raise RuntimeError(r.stderr)
        for suffix,source in zip(('old','new'),sources):
            for name in sorted(names,key=len,reverse=True):source=re.sub(r'\b'+name+r'\b',name+'_'+suffix,source,flags=re.I)
            (folder/(suffix+'.f')).write_text(source,newline='\n')
        (folder/'driver.f90').write_text(DRIVER,newline='\n')
        for opt in ('0','2'):
            r=subprocess.run([compiler,'-std=f2023','-pedantic-errors','-ffixed-line-length-none','-O'+opt,'old.f','new.f','driver.f90','library.o','-o','check.exe'],cwd=folder,capture_output=True,text=True,timeout=180)
            if r.returncode:raise RuntimeError(r.stderr)
            r=subprocess.run([str(folder/'check.exe')],cwd=folder,capture_output=True,text=True,timeout=30)
            if r.returncode or 'two-way terminal branches: PASS' not in r.stdout:raise RuntimeError(r.stdout+r.stderr)
            print('-O'+opt+': '+r.stdout.strip(),flush=True)
    print('All 13 routines exercised through both branches; compiler symbols unchanged.',flush=True)


def main():
    from validate_declaration_sections import historical_input
    from declaration_sections import transform as sections
    from additional_intents import transform as intents
    from ode_intents import transform as ode
    before=ode(intents(sections(historical_input())));report={};after=transform(before,report)
    if after!=(ROOT/'nswc.f').read_bytes() or report!=json.loads(MANIFEST.read_text()):raise ValueError('Two-way branch source or review does not reproduce')
    verify(before,after,report)

if __name__=='__main__':main()
