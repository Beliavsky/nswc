! Adapted from test_sfode_legacy.f90 in the amiller-nswc test suite.
program test_sfode
   implicit none

   interface
      subroutine sfode(f,neq,y,t,tout,info,rerr,aerr,idid,rwork,lrw,iwork,liw,rpar,ipar)
         external :: f
         integer, intent(in) :: neq,lrw,liw
         real, intent(inout) :: y(neq),t,rerr,aerr,rwork(lrw),rpar(*)
         real, intent(in) :: tout
         integer, intent(inout) :: info(*),iwork(liw),ipar(*)
         integer, intent(out) :: idid
      end subroutine sfode
      subroutine sfode1(f,neq,y,t,tout,info,rtol,atol,idid,rwork,lrw,iwork,liw,rpar,ipar)
         external :: f
         integer, intent(in) :: neq,lrw,liw
         real, intent(inout) :: y(neq),t,rtol(neq),atol(neq),rwork(lrw),rpar(*)
         real, intent(in) :: tout
         integer, intent(inout) :: info(*),iwork(liw),ipar(*)
         integer, intent(out) :: idid
      end subroutine sfode1
   end interface

   integer, parameter :: n=1
   integer, parameter :: lrw=250+10*n+n*n
   integer, parameter :: liw=55+n
   real :: y(n),t,rerr,aerr,rtol(n),atol(n),rwork(lrw),rpar(1)
   integer :: info(4),iwork(liw),ipar(1),idid

   call init_common()
   rerr=1.0e-4
   aerr=1.0e-6
   call sfode(rhs,n,y,t,1.0,info,rerr,aerr,idid,rwork,lrw,iwork,liw,rpar,ipar)
   if (idid/=2 .and. idid/=3) error stop 'legacy sfode status'
   if (abs(y(1)-cos(1.0))>3.0e-3) error stop 'legacy sfode solution'
   call check_callback_state()

   call init_common()
   rtol=1.0e-4
   atol=1.0e-6
   call sfode1(rhs,n,y,t,1.0,info,rtol,atol,idid,rwork,lrw,iwork,liw,rpar,ipar)
   if (idid/=2 .and. idid/=3) error stop 'legacy sfode1 status'
   if (abs(y(1)-cos(1.0))>3.0e-3) error stop 'legacy sfode1 solution'
   call check_callback_state()

   print '(a,3es24.15)', 'Stiff ODE diagnostics: ',t,y(1),y(1)-cos(t)
   print '(a)', 'test_sfode: PASS'

contains

   subroutine init_common()
      y=1.0
      t=0.0
      rwork=0.0
      iwork=0
      info=0
      rpar=17.0
      ipar=23
   end subroutine init_common

   subroutine check_callback_state()
      if (ipar(1)<=23) error stop 'ODE callback updates not returned'
      if (rpar(1)-17.0/=real(ipar(1)-23)) error stop 'ODE callback state not preserved'
   end subroutine check_callback_state

   subroutine rhs(x,u,up,rp,ip)
      real, intent(in) :: x
      real, intent(in) :: u(*)
      real, intent(out) :: up(*)
      real, intent(inout) :: rp(*)
      integer, intent(inout) :: ip(*)
      up(1)=-1000.0*(u(1)-cos(x))-sin(x)
      rp(1)=rp(1)+1.0
      ip(1)=ip(1)+1
   end subroutine rhs

end program test_sfode
