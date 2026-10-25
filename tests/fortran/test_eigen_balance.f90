! Adapted from test_eigen_balance_legacy.f90 in the amiller-nswc test suite.
program test_eigen_balance
   implicit none
   integer, parameter :: n=3
   real :: a0(n,n),a(n,n),b(n,n),scale(n),zr(n,n),zi(n,n)
   double precision :: da0(n,n),da(n,n),db(n,n),dscale(n),dzr(n,n),dzi(n,n)
   integer :: low,igh

   interface
      subroutine balanc(nm,n,a,low,igh,scale)
         integer, intent(in) :: nm,n
         real, intent(inout) :: a(nm,n)
         integer, intent(out) :: low,igh
         real, intent(out) :: scale(n)
      end subroutine balanc
      subroutine balbak(nm,n,low,igh,scale,m,z)
         integer, intent(in) :: nm,n,low,igh,m
         real, intent(in) :: scale(n)
         real, intent(inout) :: z(nm,m)
      end subroutine balbak
      subroutine balinv(nz,n,z,low,igh,scale)
         integer, intent(in) :: nz,n,low,igh
         real, intent(inout) :: z(nz,n)
         real, intent(in) :: scale(n)
      end subroutine balinv
      subroutine dbal(nm,n,a,low,igh,scale)
         integer, intent(in) :: nm,n
         double precision, intent(inout) :: a(nm,n)
         integer, intent(out) :: low,igh
         double precision, intent(out) :: scale(n)
      end subroutine dbal
      subroutine dbabk(nm,n,low,igh,scale,m,z)
         integer, intent(in) :: nm,n,low,igh,m
         double precision, intent(in) :: scale(n)
         double precision, intent(inout) :: z(nm,m)
      end subroutine dbabk
      subroutine dbalnv(nz,n,z,low,igh,scale)
         integer, intent(in) :: nz,n,low,igh
         double precision, intent(inout) :: z(nz,n)
         double precision, intent(in) :: scale(n)
      end subroutine dbalnv
      subroutine cbal(nm,n,ar,ai,low,igh,scale)
         integer, intent(in) :: nm,n
         real, intent(inout) :: ar(nm,n),ai(nm,n)
         integer, intent(out) :: low,igh
         real, intent(out) :: scale(n)
      end subroutine cbal
      subroutine cbabk2(nm,n,low,igh,scale,m,zr,zi)
         integer, intent(in) :: nm,n,low,igh,m
         real, intent(in) :: scale(n)
         real, intent(inout) :: zr(nm,m),zi(nm,m)
      end subroutine cbabk2
      subroutine dcbal(nm,n,ar,ai,low,igh,scale)
         integer, intent(in) :: nm,n
         double precision, intent(inout) :: ar(nm,n),ai(nm,n)
         integer, intent(out) :: low,igh
         double precision, intent(out) :: scale(n)
      end subroutine dcbal
      subroutine dcbabk(nm,n,low,igh,scale,m,zr,zi)
         integer, intent(in) :: nm,n,low,igh,m
         double precision, intent(in) :: scale(n)
         double precision, intent(inout) :: zr(nm,m),zi(nm,m)
      end subroutine dcbabk
   end interface

   a0=0.0
   a0(1,1)=1.0
   a0(1,3)=1.0e4
   a0(2,2)=5.0
   a0(3,1)=1.0e-4
   a0(3,3)=4.0
   a=a0
   call balanc(n,n,a,low,igh,scale)
   b=a
   call balinv(n,n,b,low,igh,scale)
   call require(maxval(abs(b-a0))/maxval(abs(a0))<2.0e-6,'legacy BALANC/BALINV')

   da0=dble(a0)
   da0(1,3)=1.0d10
   da0(3,1)=1.0d-10
   da=da0
   call dbal(n,n,da,low,igh,dscale)
   db=da
   call dbalnv(n,n,db,low,igh,dscale)
   call require(maxval(abs(db-da0))/maxval(abs(da0))<2.0d-14,'legacy DBAL/DBALNV')

   zr=1.0
   zi=2.0
   scale=[16.0,0.0625,1.0]
   call balbak(n,n,1,3,scale,n,zr)
   call require(abs(zr(1,1)-16.0)<1.0e-6 .and. abs(zr(2,1)-0.0625)<1.0e-6,'legacy BALBAK')
   call cbabk2(n,n,1,3,scale,n,zr,zi)
   call require(abs(zi(1,1)-32.0)<1.0e-6 .and. abs(zi(2,1)-0.125)<1.0e-6,'legacy CBABK2')

   dzr=1.0d0
   dzi=2.0d0
   dscale=[16.0d0,0.0625d0,1.0d0]
   call dbabk(n,n,1,3,dscale,n,dzr)
   call require(abs(dzr(1,1)-16.0d0)<1.0d-12 .and. abs(dzr(2,1)-0.0625d0)<1.0d-12,'legacy DBABK')
   call dcbabk(n,n,1,3,dscale,n,dzr,dzi)
   call require(abs(dzi(1,1)-32.0d0)<1.0d-12 .and. abs(dzi(2,1)-0.125d0)<1.0d-12,'legacy DCBABK')

   a=a0
   b=0.0
   call cbal(n,n,a,b,low,igh,scale)
   call balinv(n,n,a,low,igh,scale)
   call require(maxval(abs(a-a0))/maxval(abs(a0))<2.0e-6,'CBAL inverse')
   call require(maxval(abs(b))==0.0,'CBAL zero imaginary part')
   da=da0
   db=0.0d0
   call dcbal(n,n,da,db,low,igh,dscale)

   call dbalnv(n,n,da,low,igh,dscale)
   call require(maxval(abs(da-da0))/maxval(abs(da0))<2.0d-14,'DCBAL inverse')
   call require(maxval(abs(db))==0.0d0,'DCBAL zero imaginary part')
   print '(a,3es24.15)', 'balancing diagnostics: ',sum(a),sum(da),sum(dzi)
   print '(a)',  'test_eigen_balance: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not.ok) then
         write(*,'(a,1x,a)') 'FAIL:',trim(label)
         error stop 1
      end if
   end subroutine require
end program test_eigen_balance
