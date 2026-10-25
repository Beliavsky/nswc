! Adapted from C:/fortran/amiller-nswc/test/test_real_blas1_legacy.f90
! SAMAX is absent from this NSWC source; ISAMAX checks the maximum index.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_real_blas1
   implicit none
   interface
      real function sasum(n,x,incx)
         integer, intent(in) :: n, incx
         real, intent(in) :: x(*)
      end function sasum
      subroutine saxpy(n,sa,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         real, intent(in) :: sa, x(*)
         real, intent(inout) :: y(*)
      end subroutine saxpy
      subroutine scopy(n,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         real, intent(in) :: x(*)
         real, intent(inout) :: y(*)
      end subroutine scopy
      real function sdot(n,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         real, intent(in) :: x(*), y(*)
      end function sdot
      real function snrm2(n,x,incx)
         integer, intent(in) :: n, incx
         real, intent(in) :: x(*)
      end function snrm2
      subroutine srot(n,x,incx,y,incy,c,s)
         integer, intent(in) :: n, incx, incy
         real, intent(inout) :: x(*), y(*)
         real, intent(in) :: c, s
      end subroutine srot
      subroutine srotg(sa,sb,c,s)
         real, intent(inout) :: sa, sb
         real, intent(out) :: c, s
      end subroutine srotg
      subroutine srotm(n,x,incx,y,incy,sparam)
         integer, intent(in) :: n, incx, incy
         real, intent(inout) :: x(*), y(*)
         real, intent(in) :: sparam(*)
      end subroutine srotm
      subroutine srotmg(sd1,sd2,sx1,sy1,sparam)
         real, intent(inout) :: sd1, sd2, sx1
         real, intent(in) :: sy1
         real, intent(inout) :: sparam(*)
      end subroutine srotmg
      subroutine sscal(n,sa,x,incx)
         integer, intent(in) :: n, incx
         real, intent(in) :: sa
         real, intent(inout) :: x(*)
      end subroutine sscal
      subroutine sswap(n,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         real, intent(inout) :: x(*), y(*)
      end subroutine sswap
      integer function isamax(n,x,incx)
         integer, intent(in) :: n, incx
         real, intent(in) :: x(*)
      end function isamax
      double precision function dasum(n,x,incx)
         integer, intent(in) :: n, incx
         double precision, intent(in) :: x(*)
      end function dasum
      subroutine daxpy(n,da,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         double precision, intent(in) :: da, x(*)
         double precision, intent(inout) :: y(*)
      end subroutine daxpy
      subroutine dcopy(n,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         double precision, intent(in) :: x(*)
         double precision, intent(inout) :: y(*)
      end subroutine dcopy
      double precision function ddot(n,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         double precision, intent(in) :: x(*), y(*)
      end function ddot
      double precision function dnrm2(n,x,incx)
         integer, intent(in) :: n, incx
         double precision, intent(in) :: x(*)
      end function dnrm2
      subroutine drot(n,x,incx,y,incy,c,s)
         integer, intent(in) :: n, incx, incy
         double precision, intent(inout) :: x(*), y(*)
         double precision, intent(in) :: c, s
      end subroutine drot
      subroutine drotg(da,db,c,s)
         double precision, intent(inout) :: da, db
         double precision, intent(out) :: c, s
      end subroutine drotg
      subroutine dscal(n,da,x,incx)
         integer, intent(in) :: n, incx
         double precision, intent(in) :: da
         double precision, intent(inout) :: x(*)
      end subroutine dscal
      subroutine dswap(n,x,incx,y,incy)
         integer, intent(in) :: n, incx, incy
         double precision, intent(inout) :: x(*), y(*)
      end subroutine dswap
      integer function idamax(n,x,incx)
         integer, intent(in) :: n, incx
         double precision, intent(in) :: x(*)
      end function idamax
   end interface
   real, parameter :: stol = 8.0e-6
   double precision, parameter :: dtol = 3.0d-13
   real :: x(4), y(4), z(4), a, b, c, s, d1, d2, x1, param(5)
   double precision :: dx(4), dy(4), dz(4), da, db, dc, ds

   x = [1.0,-4.0,3.0,2.0]
   y = [2.0,1.0,-1.0,5.0]
   if (abs(sasum(2,x,2)-4.0) > stol) error stop 'legacy single reductions'
   if (isamax(4,x,1) /= 2) error stop 'legacy ISAMAX'
   z = y
   call saxpy(2,2.0,x,2,z,2)
   if (abs(z(1)-4.0) > stol .or. abs(z(3)-5.0) > stol) error stop 'legacy SAXPY'
   z = 0.0
   call scopy(2,x,2,z,1)
   if (maxval(abs(z(1:2)-[1.0,3.0])) > stol) error stop 'legacy SCOPY'
   z = -7.0
   call scopy(2,x,1,z,2)
   if (maxval(abs(z-[1.0,-7.0,-4.0,-7.0])) > stol) error stop 'SCOPY untouched elements'
   call scopy(0,x,1,z,1)
   if (maxval(abs(z-[1.0,-7.0,-4.0,-7.0])) > stol) error stop 'SCOPY zero length'
   if (abs(sdot(2,x,2,y,2)+1.0) > stol) error stop 'legacy SDOT'
   if (abs(snrm2(2,x,2)-sqrt(10.0)) > stol) error stop 'legacy SNRM2'
   z = x
   call sscal(2,-1.0,z,2)
   if (abs(z(1)+1.0) > stol .or. abs(z(3)+3.0) > stol) error stop 'legacy SSCAL'
   z = x
   call sswap(2,z,2,y,2)
   if (abs(z(1)-2.0) > stol .or. abs(z(3)+1.0) > stol) error stop 'legacy SSWAP'
   z(1:2) = [1.0,2.0]
   y(1:2) = [3.0,4.0]
   call srot(2,z,1,y,1,0.0,1.0)
   if (maxval(abs(z(1:2)-[3.0,4.0])) > stol .or. maxval(abs(y(1:2)+[1.0,2.0])) > stol) error stop 'legacy SROT'
   a = 3.0
   b = 4.0
   call srotg(a,b,c,s)
   if (abs(-s*3.0+c*4.0) > stol) error stop 'legacy SROTG'
   d1 = 1.0
   d2 = 1.0
   x1 = 1.0
   param = 0.0
   call srotmg(d1,d2,x1,2.0,param)
   z(1) = 1.0
   y(1) = 2.0
   call srotm(1,z,1,y,1,param)
   if (abs(z(1)-x1) > 2.0e-5 .or. abs(y(1)) > 2.0e-5) error stop 'legacy SROTMG/SROTM'

   dx = [1.0d0,-4.0d0,3.0d0,2.0d0]
   dy = [2.0d0,1.0d0,-1.0d0,5.0d0]
   if (abs(dasum(2,dx,2)-4.0d0) > dtol .or. idamax(4,dx,1) /= 2) error stop 'legacy double reductions'
   dz = dy
   call daxpy(2,2.0d0,dx,2,dz,2)
   if (abs(dz(1)-4.0d0) > dtol .or. abs(dz(3)-5.0d0) > dtol) error stop 'legacy DAXPY'
   dz = 0.0d0
   call dcopy(2,dx,2,dz,1)
   if (maxval(abs(dz(1:2)-[1.0d0,3.0d0])) > dtol) error stop 'legacy DCOPY'
   if (abs(ddot(2,dx,2,dy,2)+1.0d0) > dtol) error stop 'legacy DDOT'
   if (abs(dnrm2(2,dx,2)-sqrt(10.0d0)) > dtol) error stop 'legacy DNRM2'
   dz = dx
   call dscal(2,-1.0d0,dz,2)
   if (abs(dz(1)+1.0d0) > dtol .or. abs(dz(3)+3.0d0) > dtol) error stop 'legacy DSCAL'
   dz = dx
   call dswap(2,dz,2,dy,2)
   if (abs(dz(1)-2.0d0) > dtol .or. abs(dz(3)+1.0d0) > dtol) error stop 'legacy DSWAP'
   dz(1:2) = [1.0d0,2.0d0]
   dy(1:2) = [3.0d0,4.0d0]
   call drot(2,dz,1,dy,1,0.0d0,1.0d0)
   if (maxval(abs(dz(1:2)-[3.0d0,4.0d0])) > dtol) error stop 'legacy DROT x'
   da = 3.0d0
   db = 4.0d0
   call drotg(da,db,dc,ds)
   if (abs(-ds*3.0d0+dc*4.0d0) > dtol) error stop 'legacy DROTG'

   print '(a,4es25.16)', 'Double rotation parameters: ',da,db,dc,ds
   print *, 'test_real_blas1: PASS'
end program test_real_blas1
