! Adapted from C:/fortran/amiller-nswc/test/test_general_polynomial_roots_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_general_polynomial_roots
   use, intrinsic :: iso_fortran_env, only : dp => real64
   implicit none
   interface
      subroutine drpoly(op, ideg, zeror, zeroi, num, wk, dwk)
         import dp
         real(dp), intent(in) :: op(*)
         integer, intent(in) :: ideg
         real(dp), intent(out) :: zeror(*)
         real(dp), intent(out) :: zeroi(*)
         integer, intent(out) :: num
         real, intent(inout) :: wk(*)
         real(dp), intent(inout) :: dwk(*)
      end subroutine drpoly
      subroutine dcpoly(opr, opi, ideg, zeror, zeroi, num, wk)
         import dp
         real(dp), intent(in) :: opr(*)
         real(dp), intent(in) :: opi(*)
         integer, intent(in) :: ideg
         real(dp), intent(out) :: zeror(*)
         real(dp), intent(out) :: zeroi(*)
         integer, intent(out) :: num
         real(dp), intent(inout) :: wk(*)
      end subroutine dcpoly
   end interface
   real(dp) :: ar(7), zr(6), zi(6), dwk(42)
   real(dp) :: opr(6), opi(6), czr(5), czi(5), cwk(60)
   real :: swk(7)
   complex(dp) :: z
   integer :: i, num

   ar = [1.0_dp, -3.0_dp, 8.0_dp, 18.0_dp, -19.0_dp, 21.0_dp, -26.0_dp]
   swk = 0.0
   dwk = 0.0_dp
   call drpoly(ar, 6, zr, zi, num, swk, dwk)
   if (num /= 6) error stop "legacy drpoly root count"
   do i = 1, 6
      z = cmplx(zr(i), zi(i), dp)
      if (abs(poly_real_desc(ar, z)) >= 2.0e-11_dp) error stop "legacy drpoly residual"
   end do

   opr = [1.0_dp, -0.5_dp, -3.1875_dp, 1.71875_dp, 1.40625_dp, -4.1875_dp]
   opi = [0.0_dp, 1.25_dp, 1.5625_dp, -4.28125_dp, 7.03125_dp, 6.625_dp]
   cwk = 0.0_dp
   call dcpoly(opr, opi, 5, czr, czi, num, cwk)
   if (num /= 5) error stop "legacy dcpoly root count"
   do i = 1, 5
      z = cmplx(czr(i), czi(i), dp)
      if (abs(poly_complex_desc(cmplx(opr, opi, dp), z)) >= 2.0e-11_dp) &
         error stop "legacy dcpoly residual"
   end do

   print '(a,6es25.16)', 'Real polynomial roots: ',zr
   print '(a,6es25.16)', 'Real polynomial imaginary parts: ',zi
   print '(a,5es25.16)', 'Complex polynomial roots: ',czr
   print '(a,5es25.16)', 'Complex polynomial imaginary parts: ',czi
   print *, "test_general_polynomial_roots: PASS"
contains
   function poly_real_desc(a, z) result(p)
      real(dp), intent(in) :: a(:)
      complex(dp), intent(in) :: z
      complex(dp) :: p
      integer :: k

      p = cmplx(a(1), 0.0_dp, dp)
      do k = 2, size(a)
         p = p*z + a(k)
      end do
   end function poly_real_desc

   function poly_complex_desc(a, z) result(p)
      complex(dp), intent(in) :: a(:)
      complex(dp), intent(in) :: z
      complex(dp) :: p
      integer :: k

      p = a(1)
      do k = 2, size(a)
         p = p*z + a(k)
      end do
   end function poly_complex_desc
end program test_general_polynomial_roots
