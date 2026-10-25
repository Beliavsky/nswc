! Adapted from C:/fortran/amiller-nswc/test/test_double_special_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_double_special
   implicit none
   double precision, parameter :: pi=3.141592653589793238462643383279502884d0
   double precision :: x

   interface
      double precision function derf(x)
         double precision, intent(in) :: x
      end function derf
      double precision function derfc(x)
         double precision, intent(in) :: x
      end function derfc
      double precision function derfc1(ind,x)
         integer, intent(in) :: ind
         double precision, intent(in) :: x
      end function derfc1
      double precision function dgamma(a)
         double precision, intent(in) :: a
      end function dgamma
      double precision function dgamln(a)
         double precision, intent(in) :: a
      end function dgamln
      double precision function dgam1(x)
         double precision, intent(in) :: x
      end function dgam1
      double precision function dgmln1(x)
         double precision, intent(in) :: x
      end function dgmln1
      double precision function dpsi(a)
         double precision, intent(in) :: a
      end function dpsi
      double precision function dlnrel(a)
         double precision, intent(in) :: a
      end function dlnrel
      double precision function drexp(x)
         double precision, intent(in) :: x
      end function drexp
      double precision function drlog1(x)
         double precision, intent(in) :: x
      end function drlog1
   end interface

   call require(abs(derf(1.0d0)-erf(1.0d0))<3.0d-15,'legacy derf')
   call require(abs(derfc(1.0d0)-erfc(1.0d0))<3.0d-15,'legacy derfc')
   call require(abs(derfc1(1,2.0d0)-exp(4.0d0)*erfc(2.0d0))<3.0d-14,'legacy derfc1')
   call require(abs(dgamma(0.5d0)-sqrt(pi))<3.0d-14,'legacy dgamma')
   call require(abs(dgamln(3.5d0)-log_gamma(3.5d0))<3.0d-15,'legacy dgamln')
   call require(abs(dgam1(0.25d0)-(1.0d0/gamma(1.25d0)-1.0d0))<3.0d-15,'legacy dgam1')
   call require(abs(dgmln1(-0.25d0)-log_gamma(0.75d0))<3.0d-15,'legacy dgmln1')
   call require(abs(dpsi(1.0d0)+0.577215664901532860606512090082402431d0)<3.0d-14,'legacy dpsi')
   x=1.0d-10
   call require(abs(dlnrel(x)-log(1.0d0+x))<2.0d-16,'legacy dlnrel')
   call require(abs(drexp(x)-x)<1.0d-20,'legacy drexp')
   x=1.0d-6
   call require(abs(drlog1(x)-4.9999966666691667d-13)<2.0d-24,'legacy drlog1')

   print '(a,4es25.16)', 'Reference values: ',derf(1d0),derfc(1d0),dgamma(0.5d0),dpsi(1d0)
   print '(a)', 'test_double_special: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not.ok) then
         write(*,'(a,1x,a)') 'FAIL:',trim(label)
         error stop 1
      end if
   end subroutine require
end program test_double_special
