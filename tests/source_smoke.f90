! Representative checks; this is not a full numerical validation of NSWC.
program source_smoke
  implicit none
  double precision, external :: ddot, dgamma, dcsevl
  integer, external :: idamax
  real, external :: square
  double precision :: x(3), y(3), coefficients(3), values(4)
  real :: integral, error, work(400)
  integer :: evaluations, status, last, iwork(100)

  x = [1d0, 2d0, 3d0]
  y = [4d0, 5d0, 6d0]
  values(1) = ddot(3, x, 1, y, 1)
  if (abs(values(1) - 32d0) > 1d-12) stop 1
  call daxpy(3, 2d0, x, 1, y, 1)
  if (any(abs(y - [6d0, 9d0, 12d0]) > 1d-12)) stop 2
  if (idamax(3, y, 1) /= 3) stop 3
  values(2) = dgamma(5d0)
  if (abs(values(2) - 24d0) > 1d-10) stop 4
  coefficients = [2d0, 3d0, 4d0]
  values(3) = dcsevl(0d0, coefficients, 3)
  if (abs(values(3) + 3d0) > 1d-12) stop 5
  call qags(square, 0., 1., 1e-6, 1e-6, integral, error, &
            evaluations, status, 100, 400, last, iwork, work)
  if (status /= 0 .or. abs(integral - 1./3.) > 1e-6) stop 6
  values(4) = dble(integral)
  write (*, '(4ES25.16)') values
  write (*, '(3ES25.16)') y
  write (*, '(3I10)') evaluations, status, last
end program source_smoke

real function square(x)
  implicit none
  real, intent(in) :: x
  square = x*x
end function square
