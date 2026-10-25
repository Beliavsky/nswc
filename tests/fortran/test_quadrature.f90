! Adapted from C:/fortran/amiller-nswc/test/test_quadrature_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_quadrature
   implicit none
   interface
      subroutine quad(a,b,result,k,epsil,npts,icheck,f)
         real, intent(in) :: a,b,epsil
         real, intent(out) :: result(*)
         integer, intent(out) :: k,npts,icheck
         interface
            real function f(x)
               real, intent(in) :: x
            end function f
         end interface
      end subroutine quad
      real function qsuba(f,a,b,epsil,mcount,relerr,ind)
         interface
            real function f(x)
               real, intent(in) :: x
            end function f
         end interface
         real, intent(in) :: a,b,epsil
         integer, intent(in) :: mcount
         real, intent(out) :: relerr
         integer, intent(out) :: ind
      end function qsuba
      subroutine wandt(wv,tv,n,a,b)
         integer, intent(in) :: n
         real, intent(out) :: wv(n),tv(n)
         real, intent(in) :: a,b
      end subroutine wandt
   end interface
   real :: result(8),relerr,value,w(4),x(4)
   integer :: k,npts,icheck,ind

   call quad(0.0,1.0,result,k,1.0e-6,npts,icheck,fun)
   if (icheck/=0 .or. abs(result(k)-1.0/3.0)>2.0e-6) error stop 'legacy quad'

   value=qsuba(fun,0.0,1.0,1.0e-6,2000,relerr,ind)
   if (ind/=0 .or. abs(value-1.0/3.0)>2.0e-6) error stop 'legacy qsuba'

   call wandt(w,x,4,0.0,1.0)
   if (abs(sum(w)-1.0)>2.0e-6) error stop 'legacy wandt'
   print '(a,3es25.16)', 'Integral estimates and weight sum: ',result(k),value,sum(w)
   print *, 'test_quadrature: PASS'

contains

   real function fun(t)
      real, intent(in) :: t
      fun=t*t
   end function fun

end program test_quadrature
