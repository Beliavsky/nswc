program cube_roots
   use nswc_mod, only: cbrt, dcbrt
   implicit none
   real :: x(3) = [-8.0, 0.0, 27.0]
   double precision :: dx(3) = [-8.0d0, 0.0d0, 27.0d0]

   print '(a,3f10.5)', 'Single precision roots: ', cbrt(x)
   print '(a,3f10.5)', 'Double precision roots: ', dcbrt(dx)
   if (maxval(abs(cbrt(x) - [-2.0, 0.0, 3.0])) > 2.e-5) error stop 'cube roots'
end program cube_roots
