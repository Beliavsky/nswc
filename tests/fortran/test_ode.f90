! Adapted from C:/fortran/amiller-nswc/test/test_ode_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_ode
   implicit none

   interface
      subroutine rk(n,t,h,a,f)
         integer, intent(in) :: n
         real, intent(inout) :: t
         real, intent(in) :: h
         real, intent(inout) :: a(*)
         external :: f
      end subroutine rk
      subroutine rk8(n,t,h,y,dy,w,f)
         integer, intent(in) :: n
         real, intent(inout) :: t
         real, intent(in) :: h
         real, intent(inout) :: y(n),dy(n),w(*)
         external :: f
      end subroutine rk8
      subroutine fehl(f,neqn,y,t,h,yp,f1,f2,f3,f4,f5,s)
         external :: f
         integer, intent(in) :: neqn
         real, intent(in) :: y(neqn),t,h,yp(neqn)
         real, intent(out) :: f1(neqn),f2(neqn),f3(neqn),f4(neqn),f5(neqn),s(neqn)
      end subroutine fehl
      subroutine rkf45(f,neqn,y,t,tout,relerr,abserr,iflag,work,iwork)
         external :: f
         integer, intent(in) :: neqn
         real, intent(inout) :: y(neqn),t,relerr,work(*)
         real, intent(in) :: tout,abserr
         integer, intent(inout) :: iflag,iwork(5)
      end subroutine rkf45
      subroutine rkfs(f,neqn,y,t,tout,relerr,abserr,iflag,yp,h,f1,f2,f3,f4,f5, &
         savre,savae,nfe,kop,init,jflag,kflag)
         external :: f
         integer, intent(in) :: neqn
         real, intent(inout) :: y(neqn),t,relerr,yp(neqn),h,f1(neqn),f2(neqn),f3(neqn),f4(neqn),f5(neqn)
         real, intent(in) :: tout,abserr
         real, intent(inout) :: savre,savae
         integer, intent(inout) :: iflag,nfe,kop,init,jflag,kflag
      end subroutine rkfs
      subroutine gerk(f,neqn,y,t,tout,relerr,abserr,iflag,gerror,work,iwork)
         external :: f
         integer, intent(in) :: neqn
         real, intent(inout) :: y(neqn),t,relerr,work(*)
         real, intent(in) :: tout,abserr
         integer, intent(inout) :: iflag,iwork(5)
         real, intent(out) :: gerror(neqn)
      end subroutine gerk
      subroutine gerks(f,neqn,y,t,tout,relerr,abserr,iflag,gerror,yp,h,f1,f2,f3,f4,f5, &
         yg,ygp,savre,savae,nfe,kop,init,jflag,kflag)
         external :: f
         integer, intent(in) :: neqn
         real, intent(inout) :: y(neqn),t,relerr
         real, intent(in) :: tout,abserr
         integer, intent(inout) :: iflag
         real, intent(out) :: gerror(neqn)
         real, intent(inout) :: yp(neqn),h,f1(neqn),f2(neqn),f3(neqn),f4(neqn),f5(neqn)
         real, intent(inout) :: yg(neqn),ygp(neqn),savre,savae
         integer, intent(inout) :: nfe,kop,init,jflag,kflag
      end subroutine gerks
   end interface

   real :: a(3),y(1),dy(1),w8(8),t,yp(1),f1(1),f2(1),f3(1),f4(1),f5(1),s(1)
   real :: work(9),gwork(11),gerror(1),relerr,h,savre,savae,yg(1),ygp(1)
   integer :: iflag,iwork(5),nfe,kop,init,jflag,kflag

   t=0.0
   a=0.0
   a(1)=1.0
   call rk(1,t,0.0,a,rhs_inplace)
   call rk(1,t,0.25,a,rhs_inplace)
   if (abs(a(1)-exp(0.25))>2.0e-4) error stop 'legacy rk'

   t=0.0
   y=1.0
   dy=1.0
   w8=0.0
   call rk8(1,t,0.5,y,dy,w8,rhs_inplace)
   if (abs(y(1)-exp(0.5))>3.0e-5) error stop 'legacy rk8'

   y=1.0
   yp=1.0
   call fehl(rhs,1,y,0.0,0.25,yp,f1,f2,f3,f4,f5,s)
   if (abs(s(1)-exp(0.25))>3.0e-6) error stop 'legacy fehl'

   t=0.0
   y=1.0
   relerr=1.0e-6
   iflag=1
   work=0.0
   iwork=0
   call rkf45(rhs,1,y,t,1.0,relerr,1.0e-8,iflag,work,iwork)
   if (iflag/=2 .or. abs(y(1)-exp(1.0))>5.0e-5) error stop 'legacy rkf45'

   t=0.0
   y=1.0
   relerr=1.0e-6
   iflag=1
   yp=0.0
   h=0.0
   f1=0.0; f2=0.0; f3=0.0; f4=0.0; f5=0.0
   savre=0.0; savae=0.0
   nfe=0; kop=0; init=0; jflag=0; kflag=0
   call rkfs(rhs,1,y,t,0.5,relerr,1.0e-8,iflag,yp,h,f1,f2,f3,f4,f5, &
      savre,savae,nfe,kop,init,jflag,kflag)
   if (iflag/=2 .or. abs(y(1)-exp(0.5))>5.0e-5) error stop 'legacy rkfs'

   t=0.0
   y=1.0
   relerr=1.0e-5
   iflag=1
   gwork=0.0
   iwork=0
   call gerk(rhs,1,y,t,1.0,relerr,1.0e-7,iflag,gerror,gwork,iwork)
   if (iflag/=2 .or. abs(y(1)-exp(1.0))>2.0e-5) error stop 'legacy gerk'

   t=0.0
   y=1.0
   relerr=1.0e-5
   iflag=1
   yp=0.0
   h=0.0
   f1=0.0; f2=0.0; f3=0.0; f4=0.0; f5=0.0
   yg=0.0; ygp=0.0
   savre=0.0; savae=0.0
   nfe=0; kop=0; init=0; jflag=0; kflag=0
   call gerks(rhs,1,y,t,0.5,relerr,1.0e-7,iflag,gerror,yp,h,f1,f2,f3,f4,f5, &
      yg,ygp,savre,savae,nfe,kop,init,jflag,kflag)
   if (iflag/=2 .or. abs(y(1)-exp(0.5))>1.0e-5) error stop 'legacy gerks'

   print '(a,2es25.16)', 'Final time and solution: ',t,y
   print '(a)', 'test_ode: PASS'

contains

   subroutine rhs_inplace(x,u)
      real, intent(in) :: x
      real, intent(inout) :: u(*)
      u(1)=u(1)+0.0*x
   end subroutine rhs_inplace

   subroutine rhs(x,u,up)
      real, intent(in) :: x
      real, intent(in) :: u(*)
      real, intent(out) :: up(*)
      up(1)=u(1)+0.0*x
   end subroutine rhs

end program test_ode
