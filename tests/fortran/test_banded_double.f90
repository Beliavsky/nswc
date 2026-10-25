! Adapted from test_banded_double_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_banded_double
   implicit none
   integer, parameter :: dp=kind(1.0d0), m=3, n=4, nb=3, num=10
   real(dp) :: d(m,n), band(m,nb), back(m,n), vals(num), band2(m,nb)
   real(dp) :: bandb(m,nb), sum(m,5), trans(n,nb), x(n), y(m), xt(m), yt(n)
   real(dp) :: transback(n,m)
   real(dp) :: sym(2,2), sym2(2,2), pack(3)
   real :: rband(m,nb), rpart(m,nb), ipart(m,nb)
   complex :: zband(m,nb)
   integer :: ia(m+1),ja(num),ml,mu,ierr,i,j
   interface
      subroutine cvdb(a,ka,m,n,ml,mu,b,kb)
         import dp
         integer,intent(in)::ka,m,n,ml,mu,kb
         real(dp),intent(in)::a(ka,*)
         real(dp),intent(out)::b(kb,*)
      end subroutine cvdb
      subroutine cvbd(b,kb,m,n,ml,mu,a,ka)
         import dp
         integer,intent(in)::kb,m,n,ml,mu,ka
         real(dp),intent(in)::b(kb,*)
         real(dp),intent(out)::a(ka,*)
      end subroutine cvbd
      subroutine cvdb1(a,ka,m,n,ml,mu,b,kb,nb,ierr)
         import dp
         integer,intent(in)::ka,m,n,kb,nb
         real(dp),intent(in)::a(ka,*)
         integer,intent(out)::ml,mu,ierr
         real(dp),intent(out)::b(kb,*)
      end subroutine cvdb1
      subroutine dmcvbs(a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
         import dp
         integer,intent(in)::ka,m,n,ml,mu,num
         real(dp),intent(in)::a(ka,*)
         real(dp),intent(out)::b(*)
         integer,intent(out)::ib(*),jb(*),ierr
      end subroutine dmcvbs
      subroutine dmcvsb(a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
         import dp
         real(dp),intent(in)::a(*)
         integer,intent(in)::ia(*),ja(*),m,n,kb,nb
         real(dp),intent(out)::b(kb,nb)
         integer,intent(out)::ml,mu,ierr
      end subroutine dmcvsb
      subroutine dmcvfs(a,ka,n,b)
         import dp
         integer,intent(in)::ka,n
         real(dp),intent(in)::a(ka,n)
         real(dp),intent(out)::b(*)
      end subroutine dmcvfs
      subroutine dmcvsf(a,ka,n,b)
         import dp
         integer,intent(in)::ka,n
         real(dp),intent(out)::a(ka,n)
         real(dp),intent(in)::b(*)
      end subroutine dmcvsf
      subroutine bcvrd(a,ka,m,n,ml,mu,b,kb)
         import dp
         integer,intent(in)::ka,m,n,ml,mu,kb
         real,intent(in)::a(ka,*)
         real(dp),intent(out)::b(kb,*)
      end subroutine bcvrd
      subroutine bcvdr(a,ka,m,n,ml,mu,b,kb)
         import dp
         integer,intent(in)::ka,m,n,ml,mu,kb
         real(dp),intent(in)::a(ka,*)
         real,intent(out)::b(kb,*)
      end subroutine bcvdr
      subroutine breal(a,ka,m,n,ml,mu,b,kb,l,nl,nu,ierr)
         integer,intent(in)::ka,m,n,ml,mu,kb,l
         integer,intent(out)::nl,nu,ierr
         complex,intent(in)::a(ka,*)
         real,intent(out)::b(kb,*)
      end subroutine breal
      subroutine bimag(a,ka,m,n,ml,mu,b,kb,l,nl,nu,ierr)
         integer,intent(in)::ka,m,n,ml,mu,kb,l
         integer,intent(out)::nl,nu,ierr
         complex,intent(in)::a(ka,*)
         real,intent(out)::b(kb,*)
      end subroutine bimag
      subroutine dbadd(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
         import dp
         integer,intent(in)::m,n,ka,ml,mu,kb,nl,nu,kc,l
         real(dp),intent(in)::a(ka,*),b(kb,*)
         real(dp),intent(out)::c(kc,l)
         integer,intent(out)::mcl,mcu,ierr
      end subroutine dbadd
      subroutine dbsubt(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
         import dp
         integer,intent(in)::m,n,ka,ml,mu,kb,nl,nu,kc,l
         real(dp),intent(in)::a(ka,*),b(kb,*)
         real(dp),intent(out)::c(kc,l)
         integer,intent(out)::mcl,mcu,ierr
      end subroutine dbsubt
      subroutine dbpose(a,ka,m,n,ml,mu,b,kb)
         import dp
         integer,intent(in)::ka,m,n,ml,mu,kb
         real(dp),intent(in)::a(ka,*)
         real(dp),intent(out)::b(kb,*)
      end subroutine dbpose
      subroutine dbprod(m,n,l,a,ka,ml,mu,b,kb,nl,nu,c,kc,nc,mcl,mcu,ierr)
         import dp
         integer,intent(in)::m,n,l,ka,ml,mu,kb,nl,nu,kc,nc
         real(dp),intent(in)::a(ka,*),b(kb,*)
         real(dp),intent(out)::c(kc,nc)
         integer,intent(out)::mcl,mcu,ierr
      end subroutine dbprod
      subroutine dbtpd(m,n,a,ka,ml,mu,x,y)
         import dp
         integer,intent(in)::m,n,ka,ml,mu
         real(dp),intent(in)::a(ka,*),x(m)
         real(dp),intent(out)::y(n)
      end subroutine dbtpd
      subroutine dbtpd1(m,n,a,ka,ml,mu,x,y)
         import dp
         integer,intent(in)::m,n,ka,ml,mu
         real(dp),intent(in)::a(ka,*),x(m)
         real(dp),intent(inout)::y(n)
      end subroutine dbtpd1
      subroutine dbvpd(m,n,a,ka,ml,mu,x,y)
         import dp
         integer,intent(in)::m,n,ka,ml,mu
         real(dp),intent(in)::a(ka,*),x(n)
         real(dp),intent(out)::y(m)
      end subroutine dbvpd
      subroutine dbvpd1(m,n,a,ka,ml,mu,x,y)
         import dp
         integer,intent(in)::m,n,ka,ml,mu
         real(dp),intent(in)::a(ka,*),x(n)
         real(dp),intent(inout)::y(m)
      end subroutine dbvpd1
   end interface

   band=0.0_dp; band2=0.0_dp
   d=0.0_dp
   do i=1,m
      do j=max(1,i-1),min(n,i+1); d(i,j)=real(10*i+j,dp); end do
   end do
   call cvdb(d,m,m,n,1,1,band,m); call cvbd(band,m,m,n,1,1,back,m)
   if (maxval(abs(back-d)) > 1.0e-12_dp) error stop 'legacy CVDB/CVBD'
   call cvdb1(d,m,m,n,ml,mu,band,m,nb,ierr)
   if (ierr/=0 .or. ml/=1 .or. mu/=1) error stop 'legacy CVDB1'
   call dmcvbs(band,m,m,n,1,1,vals,ia,ja,num,ierr)
   if (ierr/=0) error stop 'legacy DMCVBS'
   call dmcvsb(vals,ia,ja,m,n,band2,m,nb,ml,mu,ierr)
   if (ierr/=0 .or. maxval(abs(band2-band))>1.0e-12_dp) error stop 'legacy DMCVSB'

   sym=reshape([1.0_dp,2.0_dp,2.0_dp,3.0_dp],[2,2])
   call dmcvfs(sym,2,2,pack); call dmcvsf(sym2,2,2,pack)
   if (maxval(abs(sym2-sym))>1.0e-12_dp) error stop 'legacy DMCVF*'

   rband=real(band); call bcvrd(rband,m,m,n,1,1,band2,m); call bcvdr(band2,m,m,n,1,1,rpart,m)
   if (maxval(abs(rpart-rband))>1.0e-6) error stop 'legacy BCVRD/BCVDR'
   ipart=0.5*rband; zband=cmplx(rband,ipart)
   call breal(zband,m,m,n,1,1,rpart,m,nb,ml,mu,ierr)
   if (ierr/=0 .or. ml/=1 .or. mu/=1) error stop 'BREAL status'
   if (maxval(abs(rpart-rband))>1.0e-6) error stop 'legacy BREAL'
   call bimag(zband,m,m,n,1,1,rpart,m,nb,ml,mu,ierr)
   if (ierr/=0 .or. ml/=1 .or. mu/=1) error stop 'BIMAG status'
   if (maxval(abs(rpart-ipart))>1.0e-6) error stop 'legacy BIMAG'

   bandb=2.0_dp*band
   call dbadd(m,n,band,m,1,1,bandb,m,1,1,sum,m,5,ml,mu,ierr)
   if (ierr/=0) error stop 'legacy DBADD'
   call cvbd(sum,m,m,n,ml,mu,back,m)
   if (maxval(abs(back-3.0_dp*d))>1.0e-12_dp) error stop 'DBADD values'
   call dbsubt(m,n,bandb,m,1,1,band,m,1,1,sum,m,5,ml,mu,ierr)
   if (ierr/=0) error stop 'legacy DBSUBT'
   call cvbd(sum,m,m,n,ml,mu,back,m)
   if (maxval(abs(back-d))>1.0e-12_dp) error stop 'DBSUBT values'
   call dbpose(band,m,m,n,1,1,trans,n)
   call cvbd(trans,n,n,m,1,1,transback,n)
   if (maxval(abs(transback-transpose(d)))>1.0e-12_dp) error stop 'DBPOSE values'

   x=[1.0_dp,2.0_dp,3.0_dp,4.0_dp]; xt=[-1.0_dp,0.5_dp,2.0_dp]
   call dbvpd(m,n,band,m,1,1,x,y); if (maxval(abs(y-matmul(d,x)))>1.0e-12_dp) error stop 'legacy DBVPD'
   call dbvpd1(m,n,band,m,1,1,x,y); if (maxval(abs(y-2.0_dp*matmul(d,x)))>1.0e-12_dp) error stop 'legacy DBVPD1'
   call dbtpd(m,n,band,m,1,1,xt,yt); if (maxval(abs(yt-matmul(xt,d)))>1.0e-12_dp) error stop 'legacy DBTPD'
   call dbtpd1(m,n,band,m,1,1,xt,yt); if (maxval(abs(yt-2.0_dp*matmul(xt,d)))>1.0e-12_dp) error stop 'legacy DBTPD1'

   ! Exercise DBPROD with a compatible n-by-2 band matrix.
   block
      real(dp) :: rhs(n,2), rhsb(n,nb), prod(m,5), exact(m,2), actual(m,2)
      rhs=0.0_dp
      do i=1,n; do j=max(1,i-1),min(2,i+1); rhs(i,j)=real(i+j,dp); end do; end do
      rhsb=0.0_dp
      do i=1,n; do j=max(1,i-1),min(2,i+1); rhsb(i,j-i+2)=rhs(i,j); end do; end do
      exact=matmul(d,rhs)
      call dbprod(m,n,2,band,m,1,1,rhsb,n,1,1,prod,m,5,ml,mu,ierr)
      if (ierr/=0) error stop 'legacy DBPROD status'
      call cvbd(prod,m,m,2,ml,mu,actual,m)
      if (maxval(abs(actual-exact))>1.0e-12_dp) error stop 'DBPROD values'
   end block

   print '(a,3es25.16)', 'Double band-vector product: ',y
   print '(a,4es25.16)', 'Double transpose product: ',yt
   print '(a)', 'test_banded_double: PASS'
end program test_banded_double
