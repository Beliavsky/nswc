! Adapted from test_adaptive_approx_legacy.f90 in the amiller-nswc test suite.
program test_adaptive_approx_compat
implicit none
integer, parameter :: dp=kind(1d0), kmax=16
real(dp) :: xknots(kmax+1),coefs(kmax,20),brakpt(1),vallft(1),valrgt(1),errest
integer :: kdiff(1),npiece,ierr,pass
abstract interface
   function adapt_callback(x,fderv) result(fx)
      import dp
      real(dp),intent(in) :: x
      real(dp),intent(out) :: fderv(*)
      real(dp) :: fx
   end function adapt_callback
end interface
interface
   subroutine adapt(fn,xlft,xrgt,epsln,npiece,errest,xknots,coefs, &
                    ierr,kmax,ndeg,nsmth,anorm,dx,mo,kbreak,brakpt,kdiff,vallft,valrgt)
      import dp,adapt_callback
      procedure(adapt_callback) :: fn
      integer,intent(in) :: kmax,ndeg,nsmth,mo,kbreak,kdiff(*)
      integer,intent(out) :: npiece,ierr
      real(dp),intent(in) :: xlft,xrgt,epsln,anorm,dx,brakpt(*),vallft(*),valrgt(*)
      real(dp),intent(out) :: errest,xknots(*),coefs(kmax,*)
   end subroutine adapt
end interface
brakpt=0d0
vallft=0d0
valrgt=0d0
kdiff=0
do pass=1,3
   call adapt(poly3,0d0,1d0,1d-11,npiece,errest,xknots,coefs, &
              ierr,kmax,3,1,2d0,1d0,0,0,brakpt,kdiff,vallft,valrgt)
   if(ierr/=0.or.npiece/=2) error stop 'ADAPT cubic status'
   if(abs(coefs(1,4)-1d0)>1d-11) error stop 'ADAPT cubic coefficient'
   call adapt(poly5,0d0,1d0,1d-10,npiece,errest,xknots,coefs, &
              ierr,kmax,5,2,2d0,1d0,0,0,brakpt,kdiff,vallft,valrgt)
   if(ierr/=0.or.npiece/=2) error stop 'ADAPT quintic status'
   if(abs(coefs(1,6)-1d0)>1d-9) error stop 'ADAPT quintic coefficient'
end do
print *, 'test_adaptive_approx_compat: PASS'
contains
   function poly3(x,fderv) result(fx)
      real(dp),intent(in) :: x
      real(dp),intent(out) :: fderv(*)
      real(dp) :: fx
      fx=x**3-2d0*x+1d0
      fderv(1)=3d0*x*x-2d0
      fderv(2)=6d0*x
      fderv(3)=6d0
   end function poly3
   function poly5(x,fderv) result(fx)
      real(dp),intent(in) :: x
      real(dp),intent(out) :: fderv(*)
      real(dp) :: fx
      fx=x**5
      fderv(1)=5d0*x**4
      fderv(2)=20d0*x**3
      fderv(3)=60d0*x*x
      fderv(4)=120d0*x
      fderv(5)=120d0
   end function poly5
end program test_adaptive_approx_compat
