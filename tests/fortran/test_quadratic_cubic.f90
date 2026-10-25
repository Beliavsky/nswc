! Quadratic roots, cubic zero-constant reductions, and untouched output storage.
program test_quadratic_cubic
   use, intrinsic :: iso_fortran_env, only: dp => real64
   implicit none
   interface
      subroutine dqdcrt(a,zr,zi)
         import dp
         real(dp), intent(in) :: a(3)
         real(dp), intent(inout) :: zr(*),zi(*)
      end subroutine dqdcrt
      subroutine dcbcrt(a,zr,zi)
         import dp
         real(dp), intent(in) :: a(4)
         real(dp), intent(inout) :: zr(3),zi(3)
      end subroutine dcbcrt
   end interface
   real(dp), parameter :: tol=2.0e-13_dp, guard=12345.0_dp
   real(dp), parameter :: cases(3,5)=reshape([ &
      -2.0_dp,1.0_dp,1.0_dp, 1.0_dp,-2.0_dp,1.0_dp, &
      1.0_dp,0.0_dp,1.0_dp, 0.0_dp,-2.0_dp,1.0_dp, &
      -1.0_dp,0.0_dp,1.0_dp], [3,5])
   real(dp) :: zr(4),zi(4),a(4),residual
   complex(dp) :: z(3)
   integer :: i,j

   residual=0.0_dp
   do i=1,size(cases,2)
      zr=guard
      zi=guard
      ! Three elements remain in each actual array, also satisfying the
      ! original routine's oversized three-element dummy declarations.
      call dqdcrt(cases(:,i),zr(2),zi(2))
      if (any(zr([1,4])/=guard) .or. any(zi([1,4])/=guard)) error stop 'quadratic output guards'
      z(1:2)=cmplx(zr(2:3),zi(2:3),dp)
      do j=1,2
         residual=max(residual,abs(cases(1,i)+z(j)*(cases(2,i)+z(j)*cases(3,i))))
      end do
      if (abs(sum(z(1:2))+cases(2,i)/cases(3,i))>tol) error stop 'quadratic sum'
      if (abs(product(z(1:2))-cases(1,i)/cases(3,i))>tol) error stop 'quadratic product'
      a=[0.0_dp,cases(:,i)]
      call dcbcrt(a,zr(1:3),zi(1:3))
      z=cmplx(zr(1:3),zi(1:3),dp)
      if (abs(z(1))>tol) error stop 'cubic zero root'
      do j=1,3
         residual=max(residual,abs(a(1)+z(j)*(a(2)+z(j)*(a(3)+z(j)*a(4)))))
      end do
      if (abs(sum(z)+a(3)/a(4))>tol) error stop 'cubic sum'
      if (abs(product(z(2:3))-a(2)/a(4))>tol) error stop 'cubic remaining roots'
   end do
   if (residual>tol) error stop 'polynomial residual'
   print '(a,es25.16)', 'Quadratic and cubic residual: ',residual
   print *, 'test_quadratic_cubic: PASS'
end program test_quadratic_cubic
