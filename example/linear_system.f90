program linear_system
   use nswc_mod, only: dgefa, dgesl
   implicit none
   double precision :: a(2,2), x(2)
   integer :: pivots(2), info

   ! Solve [3 1; 1 2] x = [9,8]. Factorization overwrites a; solving overwrites x.
   a = reshape([3.d0, 1.d0, 1.d0, 2.d0], [2,2])
   x = [9.d0, 8.d0]
   call dgefa(a, 2, 2, pivots, info)
   if (info /= 0) error stop 'singular matrix'
   call dgesl(a, 2, 2, pivots, x, 0)
   print '(a,2f10.5)', 'Solution: ', x
   if (maxval(abs(x - [2.d0, 3.d0])) > 1.d-12) error stop 'linear system'
end program linear_system
