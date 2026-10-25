! Adapted from C:/fortran/amiller-nswc/test/test_dense_solvers_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_dense_solvers
   implicit none
   integer, parameter :: n = 3
   real :: a0(n,n), a(n,n), b(n,1), xtrue(n), det(2), rcond, wk(n)
   real :: x(n), rwk(n*n+n)
   complex :: ca0(2,2), ca(2,2), cb(2,1), cxtrue(2), cdet(2), cwk(2)
   integer :: ipvt(n), cipvt(2), iwk(n), ierr

   interface
      subroutine mslv(mo, n, m, a, ka, b, kb, det, rcond, ierr, ipvt, wk)
         integer, intent(in) :: mo, n, m, ka, kb
         real, intent(inout) :: a(ka,*), b(*)
         real, intent(out) :: det(2), rcond
         integer, intent(out) :: ierr, ipvt(n)
         real, intent(inout) :: wk(n)
      end subroutine mslv
      subroutine cmslv(mo, n, m, a, ka, b, kb, det, rcond, ierr, ipvt, wk)
         integer, intent(in) :: mo, n, m, ka, kb
         complex, intent(inout) :: a(ka,*), b(*)
         complex, intent(out) :: det(2)
         real, intent(out) :: rcond
         integer, intent(out) :: ierr, ipvt(n)
         complex, intent(inout) :: wk(n)
      end subroutine cmslv
      subroutine slvmp(mo, n, a, ka, b, x, wk, iwk, ierr)
         integer, intent(in) :: mo, n, ka
         real, intent(in) :: a(ka,n), b(n)
         real, intent(out) :: x(n)
         real, intent(inout) :: wk(*)
         integer, intent(inout) :: iwk(n)
         integer, intent(out) :: ierr
      end subroutine slvmp
   end interface

   a0(1,:) = [4.0, 1.0, 2.0]
   a0(2,:) = [1.0, 3.0, 0.0]
   a0(3,:) = [2.0, 0.0, 5.0]
   xtrue = [1.0, -2.0, 0.5]
   a = a0
   b(:,1) = matmul(a0, xtrue)
   call mslv(1, n, 1, a, n, b, n, det, rcond, ierr, ipvt, wk)
   if (ierr /= 0) error stop 'legacy MSLV status'
   if (maxval(abs(b(:,1) - xtrue)) > 2.0e-5) error stop 'legacy MSLV solution'

   b(:,1) = matmul(a0, xtrue)
   call slvmp(0, n, a0, n, b(:,1), x, rwk, iwk, ierr)
   if (ierr /= 0 .and. ierr /= 1) error stop 'legacy SLVMP status'
   if (maxval(abs(x - xtrue)) > 3.0e-5) error stop 'legacy SLVMP solution'

   ca0(1,:) = [cmplx(2.0,1.0), cmplx(-1.0,0.5)]
   ca0(2,:) = [cmplx(0.5,-1.0), cmplx(3.0,2.0)]
   cxtrue = [cmplx(1.0,-0.5), cmplx(-2.0,1.0)]
   ca = ca0
   cb(:,1) = matmul(ca0, cxtrue)
   call cmslv(1, 2, 1, ca, 2, cb, 2, cdet, rcond, ierr, cipvt, cwk)
   if (ierr /= 0) error stop 'legacy CMSLV status'
   if (maxval(abs(cb(:,1) - cxtrue)) > 3.0e-5) error stop 'legacy CMSLV solution'

   print '(a,3es25.16)', 'Real solution: ',x
   print '(a,4es25.16)', 'Complex solution: ',cb(:,1)
   print *, 'test_dense_solvers: PASS'
end program test_dense_solvers
