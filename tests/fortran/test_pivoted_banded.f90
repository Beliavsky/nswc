! Adapted from test_pivoted_banded_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_pivoted_banded
   implicit none
   integer, parameter :: n = 3, ml = 1, mu = 1
   real :: ar(n,2*ml+mu+1), dr(n,n), br(n), xr(n)
   complex :: ac(n,2*ml+mu+1), dc(n,n), bc(n), xc(n)
   integer :: ierr, ipvt(n), iwk(n)

   interface
      subroutine snbfa(a, lda, n, ml, mu, ipvt, info)
         integer, intent(in) :: lda, n, ml, mu
         real, intent(inout) :: a(lda,*)
         integer, intent(out) :: ipvt(n), info
      end subroutine snbfa

      subroutine snbsl(a, lda, n, ml, mu, ipvt, b, job)
         integer, intent(in) :: lda, n, ml, mu, job
         real, intent(in) :: a(lda,*)
         integer, intent(in) :: ipvt(n)
         real, intent(inout) :: b(n)
      end subroutine snbsl

      subroutine bslv(m0, a, ka, n, ml, mu, b, iwk, ierr)
         integer, intent(in) :: m0, ka, n, ml, mu
         real, intent(inout) :: a(ka,*)
         real, intent(inout) :: b(n)
         integer, intent(inout) :: iwk(n), ierr
      end subroutine bslv

      subroutine bslv1(m0, a, ka, n, ml, mu, b, iwk, ierr)
         integer, intent(in) :: m0, ka, n, ml, mu
         real, intent(inout) :: a(ka,*)
         real, intent(inout) :: b(n)
         integer, intent(inout) :: iwk(n), ierr
      end subroutine bslv1

      subroutine cbfa(a, lda, n, ml, mu, ipvt, info)
         integer, intent(in) :: lda, n, ml, mu
         complex, intent(inout) :: a(lda,*)
         integer, intent(out) :: ipvt(n), info
      end subroutine cbfa

      subroutine cbsl(a, lda, n, ml, mu, ipvt, b, job)
         integer, intent(in) :: lda, n, ml, mu, job
         complex, intent(in) :: a(lda,*)
         integer, intent(in) :: ipvt(n)
         complex, intent(inout) :: b(n)
      end subroutine cbsl

      subroutine cbslv(m0, a, ka, n, ml, mu, b, iwk, ierr)
         integer, intent(in) :: m0, ka, n, ml, mu
         complex, intent(inout) :: a(ka,*)
         complex, intent(inout) :: b(n)
         integer, intent(inout) :: iwk(n), ierr
      end subroutine cbslv

      subroutine cbslv1(m0, a, ka, n, ml, mu, b, iwk, ierr)
         integer, intent(in) :: m0, ka, n, ml, mu
         complex, intent(inout) :: a(ka,*)
         complex, intent(inout) :: b(n)
         integer, intent(inout) :: iwk(n), ierr
      end subroutine cbslv1
   end interface

   dr = 0.0
   dr(1,1:2) = [0.1,1.5]
   dr(2,1:3) = [2.0,4.0,0.5]
   dr(3,2:3) = [1.0,3.0]
   xr = [1.0,-0.5,2.0]

   call pack_real(dr,ar)
   call snbfa(ar,n,n,ml,mu,ipvt,ierr)
   call require(ierr == 0 .and. ipvt(1) == 2, "legacy SNBFA")
   br = matmul(dr,xr)
   call snbsl(ar,n,n,ml,mu,ipvt,br,0)
   call require(maxval(abs(br-xr)) < 2.0e-5, "legacy SNBSL")

   call pack_real(dr,ar)
   br = matmul(dr,xr)
   ierr = -1
   call bslv(0,ar,n,n,ml,mu,br,iwk,ierr)
   call require(ierr == 0 .and. maxval(abs(br-xr)) < 2.0e-5, "legacy BSLV")

   call pack_real(dr,ar)
   br = matmul(transpose(dr),xr)
   ierr = -1
   call bslv1(0,ar,n,n,ml,mu,br,iwk,ierr)
   call require(ierr == 0 .and. maxval(abs(br-xr)) < 2.0e-5, "legacy BSLV1")

   dc = (0.0,0.0)
   dc(1,1) = cmplx(0.1,0.05)
   dc(1,2) = cmplx(1.5,-0.25)
   dc(2,1) = cmplx(2.0,0.5)
   dc(2,2) = cmplx(4.0,-0.5)
   dc(2,3) = cmplx(0.5,0.25)
   dc(3,2) = cmplx(1.0,-0.2)
   dc(3,3) = cmplx(3.0,0.75)
   xc = [cmplx(1.0,0.5),cmplx(-0.5,0.25),cmplx(2.0,-1.0)]

   call pack_complex(dc,ac)
   call cbfa(ac,n,n,ml,mu,ipvt,ierr)
   call require(ierr == 0 .and. ipvt(1) == 2, "legacy CBFA")
   bc = matmul(dc,xc)
   call cbsl(ac,n,n,ml,mu,ipvt,bc,0)
   call require(maxval(abs(bc-xc)) < 3.0e-5, "legacy CBSL")

   call pack_complex(dc,ac)
   bc = matmul(dc,xc)
   ierr = -1
   call cbslv(0,ac,n,n,ml,mu,bc,iwk,ierr)
   call require(ierr == 0 .and. maxval(abs(bc-xc)) < 3.0e-5, "legacy CBSLV")

   call pack_complex(dc,ac)
   bc = matmul(transpose(dc),xc)
   ierr = -1
   call cbslv1(0,ac,n,n,ml,mu,bc,iwk,ierr)
   call require(ierr == 0 .and. maxval(abs(bc-xc)) < 3.0e-5, "legacy CBSLV1")

   print '(a,3es25.16)', 'Real banded solution: ',br
   print '(a,6es25.16)', 'Complex banded solution: ',bc
   print *, "test_pivoted_banded: PASS"
contains
   subroutine pack_real(dense,a)
      real, intent(in) :: dense(n,n)
      real, intent(out) :: a(n,2*ml+mu+1)
      integer :: i, j

      a = 0.0
      do i = 1, n
         do j = max(1,i-ml), min(n,i+mu)
            a(i,j-i+ml+1) = dense(i,j)
         end do
      end do
   end subroutine pack_real

   subroutine pack_complex(dense,a)
      complex, intent(in) :: dense(n,n)
      complex, intent(out) :: a(n,2*ml+mu+1)
      integer :: i, j

      a = (0.0,0.0)
      do i = 1, n
         do j = max(1,i-ml), min(n,i+mu)
            a(i,j-i+ml+1) = dense(i,j)
         end do
      end do
   end subroutine pack_complex

   subroutine require(condition,message)
      logical, intent(in) :: condition
      character(len=*), intent(in) :: message

      if (.not. condition) then
         print *, "FAIL: ", trim(message)
         error stop 1
      end if
   end subroutine require
end program test_pivoted_banded
