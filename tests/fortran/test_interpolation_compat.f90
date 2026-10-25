! Adapted from C:/fortran/amiller-nswc/test/test_interpolation_compat_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_interpolation_compat
   implicit none
   real :: x(4),y(4),xi(3),yi(3),t(4)
   real :: xp(2),a(2,2),xq(3),yq(3)
   real :: px(4),py(4)
   integer :: ierr

   interface
      subroutine ltrp(m,x,y,n,xi,yi,ni,t,ierr)
         integer, intent(in) :: m,n,ni
         real, intent(in) :: x(n),y(n),xi(ni)
         real, intent(out) :: yi(ni),t(m)
         integer, intent(out) :: ierr
      end subroutine ltrp
      subroutine ppval(x,a,l,n,xi,yi,ni)
         integer, intent(in) :: l,n,ni
         real, intent(in) :: x(n),a(l,n),xi(ni)
         real, intent(out) :: yi(ni)
      end subroutine ppval
      real function parea(x,y,nb)
         integer, intent(in) :: nb
         real, intent(in) :: x(nb),y(nb)
      end function parea
   end interface

   x=[0.0,1.0,2.0,3.0]
   y=2.0*x**3-x+4.0
   xi=[-1.0,1.5,4.0]
   call ltrp(4,x,y,4,xi,yi,3,t,ierr)
   if (ierr/=0) error stop 'legacy LTRP status'
   if (maxval(abs(yi-(2.0*xi**3-xi+4.0)))>3.0e-5) error stop 'legacy LTRP values'

   xp=[0.0,2.0]
   a(:,1)=[1.0,3.0]
   a(:,2)=[7.0,-2.0]
   xq=[-1.0,1.0,3.0]
   call ppval(xp,a,2,2,xq,yq,3)
   if (maxval(abs(yq-[-2.0,4.0,5.0]))>2.0e-6) error stop 'legacy PPVAL values'

   px=[0.0,2.0,2.0,0.0]
   py=[0.0,0.0,1.0,1.0]
   if (abs(parea(px,py,4)-2.0)>2.0e-6) error stop 'legacy PAREA value'

   print '(a,3es25.16)', 'Interpolated values: ',yi
   print '(a,3es25.16)', 'Piecewise values: ',yq
   print '(a)', 'test_interpolation_compat: PASS'
end program test_interpolation_compat
