program test_pure_elemental
   use nswc_interfaces, only: cbrt, dcbrt, cpabs, dcpabs, esum, desum, srotg, drotg
   implicit none
   real :: a(2), b(2), c(2), s(2), y(3)
   double precision :: da(2), db(2), dc(2), ds(2)

   y = pure_roots([-8.0, 0.0, 27.0])
   if (maxval(abs(y - [-2.0, 0.0, 3.0])) > 2.0e-5) error stop 'pure call chain'
   if (maxval(abs(cbrt([-8.0, 0.0, 27.0]) - y)) > 2.0e-5) error stop 'elemental cbrt'
   if (maxval(abs(dcbrt([-8.0d0, 0.0d0, 27.0d0]) - [-2.0d0, 0.0d0, 3.0d0])) > 1.0d-12) &
      error stop 'elemental dcbrt'
   if (maxval(abs(cpabs([3.0, 5.0], [4.0, 12.0]) - [5.0, 13.0])) > 1.0e-5) &
      error stop 'elemental cpabs'
   if (maxval(abs(dcpabs([3.0d0, 5.0d0], [4.0d0, 12.0d0]) - [5.0d0, 13.0d0])) > 1.0d-12) &
      error stop 'elemental dcpabs'
   if (maxval(abs(esum(2, [-1.0, 0.0, 1.0]) - exp([1.0, 2.0, 3.0]))) > 3.0e-5) &
      error stop 'elemental scalar broadcast'
   if (maxval(abs(desum(2, [-1.0d0, 0.0d0, 1.0d0]) - exp([1.0d0, 2.0d0, 3.0d0]))) > 1.0d-12) &
      error stop 'double elemental scalar broadcast'
   a = [3.0, 5.0]
   b = [4.0, 12.0]
   c = 0.0
   s = 0.0
   call srotg(a, b, c, s)
   if (maxval(abs(a - [5.0, 13.0])) > 1.0e-5) error stop 'elemental subroutine result'
   if (maxval(abs(c*c + s*s - 1.0)) > 1.0e-5) error stop 'elemental rotation'
   da = [3.0d0, 5.0d0]
   db = [4.0d0, 12.0d0]
   dc = 0.0d0
   ds = 0.0d0
   call drotg(da, db, dc, ds)
   if (maxval(abs(da - [5.0d0, 13.0d0])) > 1.0d-12) error stop 'double elemental subroutine'
   if (maxval(abs(dc*dc + ds*ds - 1.0d0)) > 1.0d-12) error stop 'double elemental rotation'
   print *, 'test_pure_elemental: PASS'
contains
   pure function pure_roots(x) result(y)
      use nswc_interfaces, only: scopy, cbrt
      real, intent(in) :: x(:)
      real :: y(size(x))
      y = 0.0
      call scopy(size(x), x, 1, y, 1)
      y = cbrt(y)
   end function pure_roots
end program test_pure_elemental
