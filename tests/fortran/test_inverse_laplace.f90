! Adapted from test_inverse_laplace_legacy.f90 in the amiller-nswc test suite.
program test_inverse_laplace
   implicit none

   abstract interface
      subroutine laplace_callback(x,y,a,b)
         real, intent(in) :: x
         real, intent(in) :: y
         real, intent(out) :: a
         real, intent(out) :: b
      end subroutine laplace_callback
   end interface

   interface
      subroutine lainv(mo,fun,t,aerr,rerr,y,c,error,num,ierr)
         import :: laplace_callback
         integer, intent(in) :: mo
         procedure(laplace_callback) :: fun
         real, intent(in) :: t
         real, intent(in) :: aerr
         real, intent(in) :: rerr
         real, intent(out) :: y
         real, intent(inout) :: c
         real, intent(out) :: error
         integer, intent(out) :: num
         integer, intent(inout) :: ierr
      end subroutine lainv

      subroutine lainv1(fun,t,c,epsre,epsab,result,esterr,num,ier)
         import :: laplace_callback
         procedure(laplace_callback) :: fun
         real, intent(in) :: t
         real, intent(in) :: c
         real, intent(in) :: epsre
         real, intent(in) :: epsab
         real, intent(out) :: result
         real, intent(out) :: esterr
         integer, intent(out) :: num
         integer, intent(out) :: ier
      end subroutine lainv1
      subroutine xcond(fun,x,cond,num,ierr)
         import :: laplace_callback
         procedure(laplace_callback) :: fun
         real :: x
         logical :: cond
         integer :: num,ierr
      end subroutine xcond
   end interface

   logical :: cond
   real :: y,c,error
   integer :: num,ierr

   call lainv1(transform,1.0,-1.0,1.0e-4,1.0e-5,y,error,num,ierr)
   call require(ierr == 0, 'legacy LAINV1 status')
   call require(abs(y-exp(-1.0)) < 2.0e-5, 'legacy LAINV1 value')

   c = -1.0
   ierr = 0
   call lainv(0,transform,2.0,1.0e-4,1.0e-4,y,c,error,num,ierr)
   call require(ierr == 0, 'legacy LAINV status')
   call require(abs(y-exp(-2.0)) < 2.0e-5, 'legacy LAINV value')

   call xcond(transform,0.0,cond,num,ierr)
   call require(ierr==0 .and. cond,'XCOND right of pole')
   call xcond(transform,-2.0,cond,num,ierr)
   call require(ierr==0 .and. .not.cond,'XCOND left of pole')
   print '(a,3es24.15)' , 'Laplace inverse diagnostics: ',y,c,error
   print *, 'test_inverse_laplace: PASS'

contains

   subroutine transform(x,y,a,b)
      real, intent(in) :: x,y
      real, intent(out) :: a,b
      complex :: z,f

      z = cmplx(x,y)
      f = cmplx(1.0,0.0)/(z+cmplx(1.0,0.0))
      a = real(f)
      b = aimag(f)
   end subroutine transform

   subroutine require(condition,message)
      logical, intent(in) :: condition
      character(len=*), intent(in) :: message

      if (.not. condition) then
         print *, 'FAIL: ', trim(message)
         error stop 1
      end if
   end subroutine require

end program test_inverse_laplace
