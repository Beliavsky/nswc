! Adapted from C:/fortran/amiller-nswc/test/test_fftpack_workers_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_fftpack_workers
   implicit none
   integer, parameter :: n=8
   real, parameter :: tol=5.0e-4
   real :: x(n),x0(n),ch(n),wa(n),w(n),xh(2*n+15),ifac(15)
   integer :: i,j,k
   real :: expected(n),pi,angle,rfft_error,cosq_error
   interface
      subroutine rffti(n,wsave)
         integer, intent(in) :: n
         real, intent(inout) :: wsave(*)
      end subroutine rffti
      subroutine rffti1(n,wa,ifac)
         integer, intent(in) :: n
         real, intent(inout) :: wa(*),ifac(*)
      end subroutine rffti1
      subroutine rfftf1(n,c,ch,wa,ifac)
         integer, intent(in) :: n
         real, intent(inout) :: c(*),ch(*),wa(*),ifac(*)
      end subroutine rfftf1
      subroutine rfftb1(n,c,ch,wa,ifac)
         integer, intent(in) :: n
         real, intent(inout) :: c(*),ch(*),wa(*),ifac(*)
      end subroutine rfftb1
      subroutine cosqf1(n,x,w,xh)
         integer, intent(in) :: n
         real, intent(inout) :: x(*),w(*),xh(*)
      end subroutine cosqf1
      subroutine cosqb1(n,x,w,xh)
         integer, intent(in) :: n
         real, intent(inout) :: x(*),w(*),xh(*)
      end subroutine cosqb1
   end interface

   do i=1,n
      x(i)=0.1*real(i*i)-0.3*real(i)+sin(0.2*real(i))
   end do
   x0=x
   wa=0.0
   ifac=0.0
   ch=0.0
   call rffti1(n,wa,ifac)
   call rfftf1(n,x,ch,wa,ifac)
   ! Independent direct DFT in FFTPACK's packed real output order.
   pi=acos(-1.0)
   expected=0.0
   expected(1)=sum(x0)
   do k=1,(n-1)/2
      do j=1,n
         angle=2.0*pi*real(k*(j-1))/real(n)
         expected(2*k)=expected(2*k)+x0(j)*cos(angle)
         expected(2*k+1)=expected(2*k+1)-x0(j)*sin(angle)
      end do
   end do
   expected(n)=sum(x0*[(real((-1)**(j-1)),j=1,n)])
   rfft_error=maxval(abs(x-expected))
   call check(rfft_error<tol,'RFFT forward versus direct DFT')
   call rfftb1(n,x,ch,wa,ifac)
   call check(maxval(abs(x-real(n)*x0))<tol,'legacy RFFT worker round trip')

   do i=1,n
      w(i)=cos(0.5*acos(-1.0)*real(i)/real(n))
   end do
   x=x0
   xh=0.0
   ! Original workers require the RFFTI workspace; the Miller backend can
   ! initialize it on demand, but the historical library does not.
   call rffti(n,xh)
   call cosqf1(n,x,w,xh)
   expected=0.0
   do i=1,n
      expected(i)=x0(1)
      do j=2,n
         angle=real((2*i-1)*(j-1))*pi/real(2*n)
         expected(i)=expected(i)+2.0*x0(j)*cos(angle)
      end do
   end do
   cosq_error=maxval(abs(x-expected))
   call check(cosq_error<tol,'COSQ forward versus direct cosine sum')
   call cosqb1(n,x,w,xh)
   call check(maxval(abs(x-4.0*real(n)*x0))<2.0e-3,'legacy COSQ worker round trip')

   print '(a,2es16.7)', 'Forward transform errors: ',rfft_error,cosq_error
   print *, 'test_fftpack_workers: PASS'
contains
   subroutine check(ok,msg)
      logical, intent(in) :: ok
      character(*), intent(in) :: msg
      if (.not.ok) then
         print *, 'FAIL: ',trim(msg)
         error stop 1
      end if
   end subroutine check
end program test_fftpack_workers
