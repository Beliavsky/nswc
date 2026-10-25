! Adapted from C:/fortran/amiller-nswc/test/test_matrix_utility_continuation_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_matrix_utility_continuation
   use, intrinsic :: iso_fortran_env, only : dp => real64
   implicit none
   real :: a(6), ref(2,3), expected(3,2), xmat(3,2), bmat(3,2), c(2,2)
   real :: gram(3), sp(6), x(3), y(3), dense(3,3)
   real(dp) :: da(6), dx(3), dy(3), dsp(6)
   complex :: ca(6), cexpected(6)
   integer :: moved(8), ndim, i
   interface
      subroutine tip(a,n1,n2,moved,nwork,ndim)
         integer, intent(in) :: n1,n2,nwork
         real, intent(inout) :: a(*)
         integer, intent(out) :: moved(*),ndim
      end subroutine tip
      subroutine dtip(a,n1,n2,moved,nwork,ndim)
         use, intrinsic :: iso_fortran_env, only : dp => real64
         integer, intent(in) :: n1,n2,nwork
         real(dp), intent(inout) :: a(*)
         integer, intent(out) :: moved(*),ndim
      end subroutine dtip
      subroutine ctip(a,n1,n2,moved,nwork,ndim)
         integer, intent(in) :: n1,n2,nwork
         complex, intent(inout) :: a(*)
         integer, intent(out) :: moved(*),ndim
      end subroutine ctip
      subroutine tmprod(m,n,l,a,ka,b,kb,c,kc)
         integer, intent(in) :: m,n,l,ka,kb,kc
         real, intent(in) :: a(ka,n),b(kb,l)
         real, intent(out) :: c(kc,l)
      end subroutine tmprod
      subroutine smprod(m,n,a,ka,b)
         integer, intent(in) :: m,n,ka
         real, intent(in) :: a(ka,n)
         real, intent(out) :: b(*)
      end subroutine smprod
      subroutine svprd(a,n,x,y)
         integer, intent(in) :: n
         real, intent(in) :: a(*),x(n)
         real, intent(out) :: y(n)
      end subroutine svprd
      subroutine dsvprd(a,n,x,y)
         use, intrinsic :: iso_fortran_env, only : dp => real64
         integer, intent(in) :: n
         real(dp), intent(in) :: a(*),x(n)
         real(dp), intent(out) :: y(n)
      end subroutine dsvprd
   end interface

   ref = reshape([1.0,2.0,3.0,4.0,5.0,6.0], shape(ref))
   expected = transpose(ref)
   a = reshape(ref,[6])
   call tip(a,2,3,moved,size(moved),ndim)
   if (maxval(abs(a-reshape(expected,[6]))) > 1.0e-6) error stop 'legacy TIP'
   da = real(reshape(ref,[6]),dp)
   call dtip(da,2,3,moved,size(moved),ndim)
   if (maxval(abs(da-real(reshape(expected,[6]),dp))) > 1.0e-13_dp) error stop 'legacy DTIP'
   ca = [(cmplx(real(i),0.2*real(i)),i=1,6)]
   cexpected = reshape(transpose(reshape(ca,[2,3])),[6])
   call ctip(ca,2,3,moved,size(moved),ndim)
   if (maxval(abs(ca-cexpected)) > 2.0e-6) error stop 'legacy CTIP'

   xmat = reshape([1.0,2.0,3.0,4.0,5.0,6.0], shape(xmat))
   bmat = reshape([2.0,-1.0,0.5,3.0,1.0,-2.0], shape(bmat))
   call tmprod(3,2,2,xmat,3,bmat,3,c,2)
   if (maxval(abs(c-matmul(transpose(xmat),bmat))) > 2.0e-6) error stop 'legacy TMPROD'
   call smprod(3,2,xmat,3,gram)
   if (maxval(abs(gram-[dot_product(xmat(:,1),xmat(:,1)), &
      dot_product(xmat(:,1),xmat(:,2)), dot_product(xmat(:,2),xmat(:,2))])) > 2.0e-6) error stop 'legacy SMPROD'

   sp = [2.0,-1.0,3.0,0.5,1.5,4.0]
   dense = reshape([2.0,-1.0,0.5,-1.0,3.0,1.5,0.5,1.5,4.0], shape(dense))
   x = [1.0,-2.0,0.5]
   call svprd(sp,3,x,y)
   if (maxval(abs(y-matmul(dense,x))) > 2.0e-6) error stop 'legacy SVPRD'
   dsp = real(sp,dp); dx = real(x,dp)
   call dsvprd(dsp,3,dx,dy)
   if (maxval(abs(dy-matmul(real(dense,dp),dx))) > 1.0e-13_dp) error stop 'legacy DSVPRD'

   print '(a,4es25.16)', 'Transpose product: ',c
   print '(a,3es25.16)', 'Packed symmetric product: ',dy
   print '(a)', 'test_matrix_utility_continuation: PASS'
end program test_matrix_utility_continuation
