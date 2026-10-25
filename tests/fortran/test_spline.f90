! Adapted from C:/fortran/amiller-nswc/test/test_spline_legacy.f90
! BSPEV is absent from this NSWC source; its separate check is omitted.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_spline
   implicit none
   interface
      subroutine splift(x,y,yp,ypp,n,w,ierr,isx,a1,b1,an,bn)
         integer, intent(in) :: n,isx
         real, intent(in) :: x(n),y(n),a1,b1,an,bn
         real, intent(out) :: yp(n),ypp(n)
         real, intent(inout) :: w(n,3)
         integer, intent(out) :: ierr
      end subroutine
      subroutine cbspl(x,y,a,b,c,n,ibeg,iend,alpha,beta,ierr)
         integer, intent(in) :: n,ibeg,iend
         real, intent(in) :: x(n),y(n),alpha,beta
         real, intent(out) :: a(n),b(n),c(n)
         integer, intent(out) :: ierr
      end subroutine
      function csint(x,y,a,b,c,n,alpha,beta) result(v)
         integer, intent(in) :: n
         real, intent(in) :: x(n),y(n),a(n),b(n),c(n),alpha,beta
         real :: v
      end function
      function csint1(x,y,yp,n,alpha,beta) result(v)
         integer, intent(in) :: n
         real, intent(in) :: x(n),y(n),yp(n),alpha,beta
         real :: v
      end function
      function csint2(x,y,ypp,n,alpha,beta) result(v)
         integer, intent(in) :: n
         real, intent(in) :: x(n),y(n),ypp(n),alpha,beta
         real :: v
      end function
      subroutine csloop(m,n,x,kx,t,dx,kdx,wk,ierr)
         integer, intent(in) :: m,n,kx,kdx
         real, intent(in) :: x(kx,n)
         real, intent(out) :: t(m),dx(kdx,n)
         real, intent(inout) :: wk(*)
         integer, intent(out) :: ierr
      end subroutine
      subroutine curv1(n,x,y,slp1,slpn,islpsw,yp,temp,sigma,ierr)
         integer, intent(in) :: n,islpsw
         real, intent(in) :: x(n),y(n),slp1,slpn,sigma
         real, intent(out) :: yp(n)
         real, intent(inout) :: temp(n)
         integer, intent(out) :: ierr
      end subroutine
      function curv2(t,n,x,y,yp,sigma) result(v)
         integer, intent(in) :: n
         real, intent(in) :: t,x(n),y(n),yp(n),sigma
         real :: v
      end function
      function curvd(t,n,x,y,yp,sigma) result(v)
         integer, intent(in) :: n
         real, intent(in) :: t,x(n),y(n),yp(n),sigma
         real :: v
      end function
      function curvi(xl,xu,n,x,y,yp,sigma) result(v)
         integer, intent(in) :: n
         real, intent(in) :: xl,xu,x(n),y(n),yp(n),sigma
         real :: v
      end function
      subroutine kurv1(n,x,y,slp1,slpn,islpsw,xp,yp,temp,s,sigma,ierr)
         integer, intent(in) :: n,islpsw
         real, intent(in) :: x(n),y(n),slp1,slpn,sigma
         real, intent(out) :: xp(n),yp(n),s(n)
         real, intent(inout) :: temp(n)
         integer, intent(out) :: ierr
      end subroutine
      subroutine kurv2(t,xs,ys,n,x,y,xp,yp,s,sigma)
         integer, intent(in) :: n
         real, intent(in) :: t,x(n),y(n),xp(n),yp(n),s(n),sigma
         real, intent(out) :: xs,ys
      end subroutine
      subroutine qurv1(n,x,y,z,slp1x,slp1y,slp1z,slpnx,slpny,slpnz,islpsw,xp,yp,zp,temp,s,sigma,ierr)
         integer, intent(in) :: n,islpsw
         real, intent(in) :: x(n),y(n),z(n)
         real, intent(in) :: slp1x,slp1y,slp1z,slpnx,slpny,slpnz,sigma
         real, intent(out) :: xp(n),yp(n),zp(n),s(n)
         real, intent(inout) :: temp(n)
         integer, intent(out) :: ierr
      end subroutine
      subroutine qurv2(t,xs,ys,zs,n,x,y,z,xp,yp,zp,s,sigma)
         integer, intent(in) :: n
         real, intent(in) :: t,x(n),y(n),z(n),xp(n),yp(n),zp(n),s(n),sigma
         real, intent(out) :: xs,ys,zs
      end subroutine
      subroutine kurvp1(n,x,y,xp,yp,temp,s,sigma,ierr)
         integer, intent(in) :: n
         real, intent(in) :: x(n),y(n),sigma
         real, intent(out) :: xp(n),yp(n),s(n)
         real, intent(inout) :: temp(*)
         integer, intent(out) :: ierr
      end subroutine
      subroutine kurvp2(t,xs,ys,n,x,y,xp,yp,s,sigma)
         integer, intent(in) :: n
         real, intent(in) :: t,x(n),y(n),xp(n),yp(n),s(n),sigma
         real, intent(out) :: xs,ys
      end subroutine
   end interface
   real :: x(4),y(4),yp(4),ypp(4),w(4,3),ca(4),cb(4),cc(4),want
   real :: xc(4,2),tc(4),dxc(4,2),wkc(12),ctmp(4)
   real :: kx(4),ky(4),kxp(4),kyp(4),ks(4),ktmp(8),kxs,kys
   real :: qz(4),qxp(4),qyp(4),qzp(4),qtemp(4),qs(4),qxs,qys,qzs
   integer :: ierr
   x=[0.,1.,2.,3.]; y=x*x; w=0.
   call splift(x,y,yp,ypp,4,w,ierr,0,0.,0.,0.,0.)
   if (ierr/=0) error stop 'legacy splift'
   x=[0.,1.,2.,3.]; y=x**3; yp=3.0*x**2; ypp=6.0*x
   call cbspl(x,y,ca,cb,cc,4,1,1,yp(1),yp(4),ierr)
   if (ierr/=0) error stop 'legacy cbspl'
   want=(2.5**4-0.25**4)/4.0
   if (abs(csint(x,y,ca,cb,cc,4,0.25,2.5)-want)>5.0e-5) error stop 'legacy csint'
   if (abs(csint1(x,y,yp,4,0.25,2.5)-want)>5.0e-5) error stop 'legacy csint1'
   if (abs(csint2(x,y,ypp,4,0.25,2.5)-want)>5.0e-5) error stop 'legacy csint2'
   xc(1,:)=[0.,0.]; xc(2,:)=[1.,0.]; xc(3,:)=[1.,1.]; xc(4,:)=[0.,1.]; wkc=0.
   call csloop(4,2,xc,4,tc,dxc,4,wkc,ierr)
   if (ierr/=0 .or. maxval(abs(tc-[0.,0.25,0.5,0.75]))>2.0e-5) error stop 'legacy csloop'
   x=[0.,1.,2.,3.]; y=x**3; ctmp=0.
   call curv1(4,x,y,0.,27.,0,yp,ctmp,0.,ierr)
   if (ierr/=0) error stop 'legacy curv1'
   if (abs(curv2(1.25,4,x,y,yp,0.)-1.25**3)>2.0e-4) error stop 'legacy curv2'
   if (abs(curvd(1.25,4,x,y,yp,0.)-3.*1.25**2)>3.0e-4) error stop 'legacy curvd'
   if (abs(curvi(0.25,2.5,4,x,y,yp,0.)-want)>5.0e-4) error stop 'legacy curvi'
   kx=[0.,1.,2.,3.]; ky=0.; ktmp=0.
   call kurv1(4,kx,ky,0.,0.,0,kxp,kyp,ktmp(1:4),ks,1.,ierr)
   if (ierr/=0) error stop 'legacy kurv1'
   call kurv2(0.5,kxs,kys,4,kx,ky,kxp,kyp,ks,1.)
   if (abs(kxs-1.5)>3.0e-4 .or. abs(kys)>3.0e-4) error stop 'legacy kurv2'
   kx=[0.,1.,1.,0.]; ky=[0.,0.,1.,1.]; ktmp=0.
   call kurvp1(4,kx,ky,kxp,kyp,ktmp,ks,0.,ierr)
   if (ierr/=0) error stop 'legacy kurvp1'
   call kurvp2(1.25,kxs,kys,4,kx,ky,kxp,kyp,ks,0.)
   if (abs(kxs-1.)>4.0e-4 .or. abs(kys)>4.0e-4) error stop 'legacy kurvp2'
   kx=[0.,1.,2.,3.]; ky=2.*kx; qz=-kx; qtemp=0.
   call qurv1(4,kx,ky,qz,1.,2.,-1.,1.,2.,-1.,0,qxp,qyp,qzp,qtemp,qs,1.,ierr)
   if (ierr/=0) error stop 'legacy qurv1'
   call qurv2(0.5,qxs,qys,qzs,4,kx,ky,qz,qxp,qyp,qzp,qs,1.)
   if (abs(qxs-1.5)>4.0e-4 .or. abs(qys-3.)>4.0e-4 .or. abs(qzs+1.5)>4.0e-4) &
      error stop 'legacy qurv2'
   print '(a,3es25.16)', 'Space curve coordinates: ',qxs,qys,qzs
   print *, 'test_spline: PASS'
end program test_spline
