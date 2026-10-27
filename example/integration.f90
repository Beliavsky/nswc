program integration
   use nswc_mod, only: qags
   implicit none
   real :: integral, error, work(400)
   integer :: evaluations, status, last, iwork(100)

   call qags(square, 0., 1., 1.e-6, 1.e-6, integral, error, evaluations, status, &
      100, 400, last, iwork, work)
   if (status /= 0) error stop 'quadrature failed'
   print '(a,f12.8,a,es12.4)', 'Integral of x**2 on [0,1]: ', integral, ', estimated error: ', error
   if (abs(integral - 1./3.) > 2.e-6) error stop 'integral'
contains
   real function square(x)
      real, intent(in) :: x
      square = x*x
   end function square
end program integration
