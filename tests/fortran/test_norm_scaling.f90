! Exercise the assigned-label scaling states retained by the original BLAS norms.
program test_norm_scaling
implicit none
interface
   real function snrm2(n,x,incx)
      integer, intent(in) :: n,incx
      real, intent(in) :: x(*)
   end function snrm2
   double precision function dnrm2(n,x,incx)
      integer, intent(in) :: n,incx
      double precision, intent(in) :: x(*)
   end function dnrm2
   real function scnrm2(n,x,incx)
      integer, intent(in) :: n,incx
      complex, intent(in) :: x(*)
   end function scnrm2
end interface
real :: scales(3),x(4),a,value
double precision :: dscales(3),dx(4),da,dvalue
complex :: cx(4)
integer :: i
scales = [1.e-30,1.,1.e30]
dscales = [1.d-250,1.d0,1.d250]
do i=1,3
   a = scales(i)
   x = [3*a,9*a,4*a,9*a]
   value = snrm2(2,x,2)/(5*a)
   if (abs(value - 1.) > 3.e-6) error stop 'SNRM2 scaling/stride'
   cx = [cmplx(3*a,4*a),cmplx(9*a,9*a),cmplx(0.,0.),cmplx(9*a,9*a)]
   value = scnrm2(2,cx,2)/(5*a)
   if (abs(value - 1.) > 3.e-6) error stop 'SCNRM2 scaling/stride'
   da = dscales(i)
   dx = [3*da,9*da,4*da,9*da]
   dvalue = dnrm2(2,dx,2)/(5*da)
   if (abs(dvalue - 1.d0) > 3.d-14) error stop 'DNRM2 scaling/stride'
end do
x = [0.,1.e-30,1.,1.e30]
dx = [0.d0,1.d-250,1.d0,1.d250]
cx = [cmplx(0.,0.),cmplx(1.e-30,1.e-30),cmplx(1.,1.),cmplx(1.e30,0.)]
if (abs(snrm2(4,x,1)/1.e30 - 1.) > 3.e-6) error stop 'SNRM2 state transitions'
if (abs(dnrm2(4,dx,1)/1.d250 - 1.d0) > 3.d-14) error stop 'DNRM2 state transitions'
if (abs(scnrm2(4,cx,1)/1.e30 - 1.) > 3.e-6) error stop 'SCNRM2 state transitions'
x = 0.;dx = 0.d0;cx = (0.,0.)
if (snrm2(4,x,1) /= 0. .or. snrm2(0,x,1) /= 0.) error stop 'SNRM2 zero'
if (dnrm2(4,dx,1) /= 0.d0 .or. dnrm2(0,dx,1) /= 0.d0) error stop 'DNRM2 zero'
if (scnrm2(4,cx,1) /= 0. .or. scnrm2(0,cx,1) /= 0.) error stop 'SCNRM2 zero'
print *, 'test_norm_scaling: PASS'
end program test_norm_scaling
