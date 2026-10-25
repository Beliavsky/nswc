! Adapted and extended from test_sparse_arithmetic_legacy.f90,
! test_sparse_arithmetic_double_legacy.f90, and
! test_sparse_arithmetic_complex_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_sparse_operations
   use, intrinsic :: iso_fortran_env, only : dp => real64
   implicit none
   integer :: ia(4),ja(4),ib(4),jb(4),ic(4),jc(9),it(4),jt(9),ierr
   real :: ar(4),br(4),cr(9),wr(3),tr(9),xr(3),yr(3),anorm
   real :: dense_r(3,3),other_r(3,3)
   real(dp) :: ad(4),bd(4),cd(9),wd(3),td(9),xd(3),yd(3),dnorm
   real(dp) :: dense_d(3,3),other_d(3,3)
   complex :: ac(4),bc(4),cc(9),wc(3),tc(9),xc(3),yc(3)
   complex :: dense_c(3,3),other_c(3,3)
   interface
      subroutine sadd(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),m,n,num,ierr
         real :: a(*),b(*),c(*),wk(n)
      end subroutine sadd
      subroutine ssubt(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),m,n,num,ierr
         real :: a(*),b(*),c(*),wk(n)
      end subroutine ssubt
      subroutine sprod(a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),l,m,n,num,ierr
         real :: a(*),b(*),c(*),wk(n)
      end subroutine sprod
      subroutine rpose(a,ia,ja,b,ib,jb,m,n)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),m,n
         real :: a(*),b(*)
      end subroutine rpose
      subroutine mvprd(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real :: a(*),x(n),y(m)
      end subroutine mvprd
      subroutine mvprd1(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real :: a(*),x(n),y(m)
      end subroutine mvprd1
      subroutine mtprd(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real :: a(*),x(m),y(n)
      end subroutine mtprd
      subroutine mtprd1(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real :: a(*),x(m),y(n)
      end subroutine mtprd1
      subroutine dsadd(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),m,n,num,ierr
         real(dp) :: a(*),b(*),c(*),wk(n)
      end subroutine dsadd
      subroutine dssubt(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),m,n,num,ierr
         real(dp) :: a(*),b(*),c(*),wk(n)
      end subroutine dssubt
      subroutine dsprod(a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),l,m,n,num,ierr
         real(dp) :: a(*),b(*),c(*),wk(n)
      end subroutine dsprod
      subroutine dpose(a,ia,ja,b,ib,jb,m,n)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),m,n
         real(dp) :: a(*),b(*)
      end subroutine dpose
      subroutine dvprd(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real(dp) :: a(*),x(n),y(m)
      end subroutine dvprd
      subroutine dvprd1(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real(dp) :: a(*),x(n),y(m)
      end subroutine dvprd1
      subroutine dtprd(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real(dp) :: a(*),x(m),y(n)
      end subroutine dtprd
      subroutine dtprd1(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         real(dp) :: a(*),x(m),y(n)
      end subroutine dtprd1
      subroutine csadd(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),m,n,num,ierr
         complex :: a(*),b(*),c(*),wk(n)
      end subroutine csadd
      subroutine cssubt(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),m,n,num,ierr
         complex :: a(*),b(*),c(*),wk(n)
      end subroutine cssubt
      subroutine csprod(a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),ic(*),jc(*),l,m,n,num,ierr
         complex :: a(*),b(*),c(*),wk(n)
      end subroutine csprod
      subroutine cpose(a,ia,ja,b,ib,jb,m,n)
         import dp
         integer :: ia(*),ja(*),ib(*),jb(*),m,n
         complex :: a(*),b(*)
      end subroutine cpose
      subroutine cvprd(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         complex :: a(*),x(n),y(m)
      end subroutine cvprd
      subroutine cvprd1(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         complex :: a(*),x(n),y(m)
      end subroutine cvprd1
      subroutine ctprd(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         complex :: a(*),x(m),y(n)
      end subroutine ctprd
      subroutine ctprd1(m,n,a,ia,ja,x,y)
         import dp
         integer :: m,n,ia(*),ja(*)
         complex :: a(*),x(m),y(n)
      end subroutine ctprd1
      function snrm(a,ia,ja,m,n) result(value)
         import dp
         integer :: ia(*),ja(*),m,n
         real :: a(*),value
      end function snrm
      subroutine s1nrm(a,ia,ja,m,n,anorm,wk)
         import dp
         integer :: ia(*),ja(*),m,n
         real :: a(*),anorm,wk(n)
      end subroutine s1nrm
      function dsnrm(a,ia,ja,m,n) result(value)
         import dp
         integer :: ia(*),ja(*),m,n
         real(dp) :: a(*),value
      end function dsnrm
      subroutine ds1nrm(a,ia,ja,m,n,anorm,wk)
         import dp
         integer :: ia(*),ja(*),m,n
         real(dp) :: a(*),anorm,wk(n)
      end subroutine ds1nrm
      subroutine rpose1(p,a,ia,ja,b,ib,jb,m,n)
         import dp
         integer :: m,n,p(m),ia(*),ja(*),ib(*),jb(*)
         real :: a(*),b(*)
      end subroutine rpose1
      subroutine dpose1(p,a,ia,ja,b,ib,jb,m,n)
         import dp
         integer :: m,n,p(m),ia(*),ja(*),ib(*),jb(*)
         real(dp) :: a(*),b(*)
      end subroutine dpose1
      subroutine cpose1(p,a,ia,ja,b,ib,jb,m,n)
         import dp
         integer :: m,n,p(m),ia(*),ja(*),ib(*),jb(*)
         complex :: a(*),b(*)
      end subroutine cpose1
   end interface

   ! A has an empty middle row; A+B cancels the final diagonal entry.
   ia=[1,3,3,5]; ja=[1,3,2,3]
   ib=[1,2,4,5]; jb=[1,1,2,3]
   ar=[1.,-2.,3.,4.]; br=[2.,1.,5.,-4.]
   ad=real(ar,dp); bd=real(br,dp)
   ac=cmplx(ar,0.5*ar); bc=cmplx(br,0.5*br)
   dense_r=unpack_r(ar,ia,ja); other_r=unpack_r(br,ib,jb)
   dense_d=unpack_d(ad,ia,ja); other_d=unpack_d(bd,ib,jb)
   dense_c=unpack_c(ac,ia,ja); other_c=unpack_c(bc,ib,jb)
   xr=[1.,-2.,0.5]; xd=real(xr,dp); xc=cmplx(xr,-0.25*xr)
   call sadd(ar,ia,ja,br,ib,jb,cr,ic,jc,3,3,9,wr,ierr)
   call require(ierr==0,'SADD status')
   call require(maxval(abs(unpack_r(cr,ic,jc)-(dense_r+other_r)))<1e-5,'SADD values')
   call ssubt(ar,ia,ja,br,ib,jb,cr,ic,jc,3,3,9,wr,ierr)
   call require(ierr==0,'SSUBT status')
   call require(maxval(abs(unpack_r(cr,ic,jc)-(dense_r-other_r)))<1e-5,'SSUBT values')
   call sprod(ar,ia,ja,br,ib,jb,cr,ic,jc,3,3,3,9,wr,ierr)
   call require(ierr==0,'SPROD status')
   call require(maxval(abs(unpack_r(cr,ic,jc)-matmul(dense_r,other_r)))<1e-5,'SPROD values')
   call rpose(ar,ia,ja,tr,it,jt,3,3)
   call require(maxval(abs(unpack_r(tr,it,jt)-transpose(dense_r)))<1e-5,'RPOSE')
   call mvprd(3,3,ar,ia,ja,xr,yr)
   call require(maxval(abs(yr-matmul(dense_r,xr)))<1e-5,'MVPRD')
   yr=xr
   call mvprd1(3,3,ar,ia,ja,xr,yr)
   call require(maxval(abs(yr-(xr+matmul(dense_r,xr))))<1e-5,'MVPRD1')
   call mtprd(3,3,ar,ia,ja,xr,yr)
   call require(maxval(abs(yr-matmul(xr,dense_r)))<1e-5,'MTPRD')
   yr=xr
   call mtprd1(3,3,ar,ia,ja,xr,yr)
   call require(maxval(abs(yr-(xr+matmul(xr,dense_r))))<1e-5,'MTPRD1')
   call sadd(ar,ia,ja,br,ib,jb,cr,ic,jc,3,3,1,wr,ierr)
   call require(ierr>0,'SADD insufficient storage')
   call dsadd(ad,ia,ja,bd,ib,jb,cd,ic,jc,3,3,9,wd,ierr)
   call require(ierr==0,'DSADD status')
   call require(maxval(abs(unpack_d(cd,ic,jc)-(dense_d+other_d)))<1e-12_dp,'DSADD values')
   call dssubt(ad,ia,ja,bd,ib,jb,cd,ic,jc,3,3,9,wd,ierr)
   call require(ierr==0,'DSSUBT status')
   call require(maxval(abs(unpack_d(cd,ic,jc)-(dense_d-other_d)))<1e-12_dp,'DSSUBT values')
   call dsprod(ad,ia,ja,bd,ib,jb,cd,ic,jc,3,3,3,9,wd,ierr)
   call require(ierr==0,'DSPROD status')
   call require(maxval(abs(unpack_d(cd,ic,jc)-matmul(dense_d,other_d)))<1e-12_dp,'DSPROD values')
   call dpose(ad,ia,ja,td,it,jt,3,3)
   call require(maxval(abs(unpack_d(td,it,jt)-transpose(dense_d)))<1e-12_dp,'DPOSE')
   call dvprd(3,3,ad,ia,ja,xd,yd)
   call require(maxval(abs(yd-matmul(dense_d,xd)))<1e-12_dp,'DVPRD')
   yd=xd
   call dvprd1(3,3,ad,ia,ja,xd,yd)
   call require(maxval(abs(yd-(xd+matmul(dense_d,xd))))<1e-12_dp,'DVPRD1')
   call dtprd(3,3,ad,ia,ja,xd,yd)
   call require(maxval(abs(yd-matmul(xd,dense_d)))<1e-12_dp,'DTPRD')
   yd=xd
   call dtprd1(3,3,ad,ia,ja,xd,yd)
   call require(maxval(abs(yd-(xd+matmul(xd,dense_d))))<1e-12_dp,'DTPRD1')
   call dsadd(ad,ia,ja,bd,ib,jb,cd,ic,jc,3,3,1,wd,ierr)
   call require(ierr>0,'DSADD insufficient storage')
   call csadd(ac,ia,ja,bc,ib,jb,cc,ic,jc,3,3,9,wc,ierr)
   call require(ierr==0,'CSADD status')
   call require(maxval(abs(unpack_c(cc,ic,jc)-(dense_c+other_c)))<1e-5,'CSADD values')
   call cssubt(ac,ia,ja,bc,ib,jb,cc,ic,jc,3,3,9,wc,ierr)
   call require(ierr==0,'CSSUBT status')
   call require(maxval(abs(unpack_c(cc,ic,jc)-(dense_c-other_c)))<1e-5,'CSSUBT values')
   call csprod(ac,ia,ja,bc,ib,jb,cc,ic,jc,3,3,3,9,wc,ierr)
   call require(ierr==0,'CSPROD status')
   call require(maxval(abs(unpack_c(cc,ic,jc)-matmul(dense_c,other_c)))<1e-5,'CSPROD values')
   call cpose(ac,ia,ja,tc,it,jt,3,3)
   call require(maxval(abs(unpack_c(tc,it,jt)-transpose(dense_c)))<1e-5,'CPOSE')
   call cvprd(3,3,ac,ia,ja,xc,yc)
   call require(maxval(abs(yc-matmul(dense_c,xc)))<1e-5,'CVPRD')
   yc=xc
   call cvprd1(3,3,ac,ia,ja,xc,yc)
   call require(maxval(abs(yc-(xc+matmul(dense_c,xc))))<1e-5,'CVPRD1')
   call ctprd(3,3,ac,ia,ja,xc,yc)
   call require(maxval(abs(yc-matmul(xc,dense_c)))<1e-5,'CTPRD')
   yc=xc
   call ctprd1(3,3,ac,ia,ja,xc,yc)
   call require(maxval(abs(yc-(xc+matmul(xc,dense_c))))<1e-5,'CTPRD1')
   call csadd(ac,ia,ja,bc,ib,jb,cc,ic,jc,3,3,1,wc,ierr)
   call require(ierr>0,'CSADD insufficient storage')
   call require(abs(snrm(ar,ia,ja,3,3)-maxval(sum(abs(dense_r),dim=2)))<1e-6,'SNRM')
   call s1nrm(ar,ia,ja,3,3,anorm,wr)
   call require(abs(anorm-maxval(sum(abs(dense_r),dim=1)))<1e-6,'S1NRM')
   call require(abs(dsnrm(ad,ia,ja,3,3)-maxval(sum(abs(dense_d),dim=2)))<1e-12_dp,'DSNRM')
   call ds1nrm(ad,ia,ja,3,3,dnorm,wd)
   call require(abs(dnorm-maxval(sum(abs(dense_d),dim=1)))<1e-12_dp,'DS1NRM')
   call rpose1([3,1,2],ar,ia,ja,tr,it,jt,3,3)
   call require(maxval(abs(unpack_r(tr,it,jt)-transpose(dense_r([3,1,2],:))))<1e-5,'RPOSE1')
   call dpose1([3,1,2],ad,ia,ja,td,it,jt,3,3)
   call require(maxval(abs(unpack_d(td,it,jt)-transpose(dense_d([3,1,2],:))))<1e-12_dp,'DPOSE1')
   call cpose1([3,1,2],ac,ia,ja,tc,it,jt,3,3)
   call require(maxval(abs(unpack_c(tc,it,jt)-transpose(dense_c([3,1,2],:))))<1e-5,'CPOSE1')
   print '(a,3es25.16)', 'Real accumulated transpose product: ',yr
   print '(a,3es25.16)', 'Double accumulated transpose product: ',yd
   print '(a,6es25.16)', 'Complex accumulated transpose product: ',yc
   print '(a,2es25.16)', 'Sparse one-norms: ',anorm,dnorm
   print '(a)', 'test_sparse_operations: PASS'
contains
   function unpack_r(values,ptr,col) result(dense)
      real, intent(in) :: values(*)
      integer, intent(in) :: ptr(4),col(*)
      real :: dense(3,3)
      integer :: i,k
      call require(ptr(1)==1 .and. ptr(4)<=10,'sparse pointer bounds')
      call require(all(ptr(2:4)>=ptr(1:3)),'sparse pointer order')
      dense=0
      do i=1,3
         do k=ptr(i),ptr(i+1)-1
            call require(col(k)>=1 .and. col(k)<=3,'sparse column bounds')
            dense(i,col(k))=dense(i,col(k))+values(k)
         end do
      end do
   end function unpack_r
   function unpack_d(values,ptr,col) result(dense)
      real(dp), intent(in) :: values(*)
      integer, intent(in) :: ptr(4),col(*)
      real(dp) :: dense(3,3)
      integer :: i,k
      call require(ptr(1)==1 .and. ptr(4)<=10,'sparse pointer bounds')
      call require(all(ptr(2:4)>=ptr(1:3)),'sparse pointer order')
      dense=0
      do i=1,3
         do k=ptr(i),ptr(i+1)-1
            call require(col(k)>=1 .and. col(k)<=3,'sparse column bounds')
            dense(i,col(k))=dense(i,col(k))+values(k)
         end do
      end do
   end function unpack_d
   function unpack_c(values,ptr,col) result(dense)
      complex, intent(in) :: values(*)
      integer, intent(in) :: ptr(4),col(*)
      complex :: dense(3,3)
      integer :: i,k
      call require(ptr(1)==1 .and. ptr(4)<=10,'sparse pointer bounds')
      call require(all(ptr(2:4)>=ptr(1:3)),'sparse pointer order')
      dense=0
      do i=1,3
         do k=ptr(i),ptr(i+1)-1
            call require(col(k)>=1 .and. col(k)<=3,'sparse column bounds')
            dense(i,col(k))=dense(i,col(k))+values(k)
         end do
      end do
   end function unpack_c
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(*), intent(in) :: label
      if (.not.ok) then
         print *, 'FAIL: ',label
         error stop 1
      end if
   end subroutine require
end program test_sparse_operations
