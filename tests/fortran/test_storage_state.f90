! Check packed ODE state, Singleton FFT aliases, and forced rounding storage.
program test_storage_state
implicit none
interface
   subroutine rsco(rsav,isav)
      real :: rsav(*)
      integer :: isav(*)
   end subroutine rsco
   subroutine svco(rsav,isav)
      real :: rsav(*)
      integer :: isav(*)
   end subroutine svco
   subroutine sfft(a,b,ntot,n,nspan,isn,ierr)
      integer :: ntot,n,nspan,isn,ierr
      real :: a(*),b(*)
   end subroutine sfft
   subroutine radix(ibeta)
      integer :: ibeta
   end subroutine radix
   real function rnderr(x,a,y,b)
      real :: x,a,y,b
   end function rnderr
end interface
real :: saved(218),restored(218),other(218)
integer :: isaved(33),irestored(33),iother(33)
real :: x(60),y(60),xr(60),yr(60),expected_x,expected_y,angle,twopi,small
integer :: i,j,k,n,pass,status,ibeta
integer, parameter :: sizes(7) = [6,7,12,20,21,45,60]

do i=1,218
   saved(i) = real(i)*0.125
end do
saved(1) = -0.0
do i=1,33
   isaved(i) = 17*i - 100
end do
other = -3.0*saved
iother = -isaved
do pass=1,3
   call rsco(saved,isaved)
   call svco(restored,irestored)
   if (any(transfer(saved,[0]) /= transfer(restored,[0]))) error stop 'ODE real state slots'
   if (any(isaved /= irestored)) error stop 'ODE integer state slots'
   call rsco(other,iother)
   call svco(restored,irestored)
   if (any(transfer(other,[0]) /= transfer(restored,[0]))) error stop 'ODE second real state'
   if (any(iother /= irestored)) error stop 'ODE second integer state'
end do

twopi = 8.0*atan(1.0)
do pass=1,size(sizes)
   n = sizes(pass)
   do i=1,n
      xr(i) = cos(0.3*real(i))
      yr(i) = sin(0.2*real(i))
   end do
   x(1:n) = xr(1:n)
   y(1:n) = yr(1:n)
   call sfft(x,y,n,n,n,-1,status)
   if (status /= 0) error stop 'Singleton FFT status'
   do k=0,n-1
      expected_x = 0.0
      expected_y = 0.0
      do j=0,n-1
         angle = -twopi*real(j*k)/real(n)
         expected_x = expected_x + xr(j+1)*cos(angle) - yr(j+1)*sin(angle)
         expected_y = expected_y + xr(j+1)*sin(angle) + yr(j+1)*cos(angle)
      end do
      if (abs(x(k+1)-expected_x) > 3.e-5*real(n)) error stop 'Singleton FFT real DFT'
      if (abs(y(k+1)-expected_y) > 3.e-5*real(n)) error stop 'Singleton FFT imaginary DFT'
   end do
   call sfft(x,y,n,n,n,1,status)
   if (status /= 0) error stop 'Singleton inverse status'
   if (maxval(abs(x(1:n)/real(n)-xr(1:n))) > 3.e-5) error stop 'Singleton real round trip'
   if (maxval(abs(y(1:n)/real(n)-yr(1:n))) > 3.e-5) error stop 'Singleton imaginary round trip'
end do

call radix(ibeta)
if (ibeta /= 2) error stop 'Stored machine radix'
small = 0.25*epsilon(1.0)
if (rnderr(1.0,small,1.0,small) /= -small) error stop 'Stored rounding intermediate'
print *, 'test_storage_state: PASS'
end program test_storage_state
