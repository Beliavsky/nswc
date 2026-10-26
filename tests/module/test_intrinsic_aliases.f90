program test_intrinsic_aliases
   implicit none
   double precision, external :: drcomp
   external dginv
   double precision, parameter :: shapes(7) = [0.1d0,0.5d0,1d0,2d0,5d0,10d0,19d0]
   double precision, parameter :: points(6) = [0.01d0,0.1d0,0.5d0,1d0,3d0,7d0]
   double precision :: a, x, expected, p, q
   integer :: i, j, ierr
   do i = 1,size(shapes)
      a = shapes(i)
      do j = 1,size(points)
         expected = exp(a*log(points(j)) - points(j) - log_gamma(a))
         if (abs(drcomp(a,points(j)) - expected) > 5d-13*expected) stop 1
      end do
   end do
   do i = 1,2
      a = 0.5d0*real(i,kind(1d0))
      do j = 1,size(points)
         if (i == 1) then
            p = erf(sqrt(points(j)))
            q = erfc(sqrt(points(j)))
         else
            q = exp(-points(j))
            p = 1d0 - q
         end if
         ierr = 0
         call dginv(a,x,p,q,ierr)
         if (ierr < 0) stop 2
         if (abs(x - points(j)) > 1d-10*max(1d0,points(j))) stop 3
      end do
   end do
   print *, 'test_intrinsic_aliases: PASS'
end program test_intrinsic_aliases
