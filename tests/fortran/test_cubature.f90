! Adapted from test_cubature_legacy.f90 in the amiller-nswc test suite.
program test_cubature
   implicit none
   interface
      subroutine cubrul(f, vec, p, idata, rdata)
         interface
            real function f(x, y, idata_arg, rdata_arg)
               real, intent(in) :: x
               real, intent(in) :: y
               integer, intent(in) :: idata_arg(*)
               real, intent(in) :: rdata_arg(*)
            end function f
         end interface
         real, intent(in) :: vec(2,3)
         real, intent(inout) :: p(*)
         integer, intent(in) :: idata(*)
         real, intent(in) :: rdata(*)
      end subroutine cubrul
      subroutine cubtri(f, t, eps, mcalls, ans, err, ncalls, w, nw, idata, rdata, ier)
         interface
            real function f(x, y, idata_arg, rdata_arg)
               real, intent(in) :: x
               real, intent(in) :: y
               integer, intent(in) :: idata_arg(*)
               real, intent(in) :: rdata_arg(*)
            end function f
         end interface
         real, intent(in) :: t(2,*)
         real, intent(in) :: eps
         integer, intent(in) :: mcalls
         real, intent(out) :: ans
         real, intent(out) :: err
         integer, intent(inout) :: ncalls
         real, intent(inout) :: w(*)
         integer, intent(in) :: nw
         integer, intent(in) :: idata(*)
         real, intent(in) :: rdata(*)
         integer, intent(out) :: ier
      end subroutine cubtri
   end interface
   real :: vec(2,3), p(6), t(2,3), w(300), ans, err
   real :: rdata(1)
   integer :: idata(1), ncalls, ier

   vec(:,1) = [1.0, 0.0]
   vec(:,2) = [0.0, 1.0]
   vec(:,3) = [0.0, 0.0]
   p = [0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
   idata = 0
   rdata = 0.0
   call cubrul(fun, vec, p, idata, rdata)
   if (abs(p(5) - 1.0/6.0) > 2.0e-6) error stop 'legacy cubrul'

   t = vec
   w = 0.0
   ncalls = 0
   call cubtri(fun, t, 1.0e-6, 1000, ans, err, ncalls, w, size(w), idata, rdata, ier)
   if (ier /= 0) error stop 'legacy cubtri status'
   if (abs(ans - 1.0/6.0) > 3.0e-6) error stop 'legacy cubtri value'
   if (ncalls /= 19) error stop 'legacy cubtri calls'

   print '(a,3es24.15)', 'Cubature integrals and error: ',p(5),ans,err
   print *, 'test_cubature: PASS'

contains

   real function fun(x, y, idata_arg, rdata_arg)
      real, intent(in) :: x
      real, intent(in) :: y
      integer, intent(in) :: idata_arg(*)
      real, intent(in) :: rdata_arg(*)
      fun = x + 0.0*y + 0.0*real(idata_arg(1)) + 0.0*rdata_arg(1)
   end function fun

end program test_cubature
