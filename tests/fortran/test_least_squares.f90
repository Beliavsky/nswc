! Adapted from C:/fortran/amiller-nswc/test/test_least_squares_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_least_squares
   implicit none
   interface
      subroutine ortho(m,n,qr,ms,s,ip,exit)
         integer, intent(in) :: m,n,ms
         real, intent(inout) :: qr(ms,n)
         real, intent(out) :: s(n)
         integer, intent(out) :: ip(n)
         logical, intent(out) :: exit
      end subroutine ortho
      subroutine orsol(m,n,qr,ms,s,ip,x)
         integer, intent(in) :: m,n,ms
         real, intent(in) :: qr(ms,n),s(n)
         integer, intent(in) :: ip(n)
         real, intent(inout) :: x(m)
      end subroutine orsol
      subroutine blsq(m,n,a,ka,ml,mu,damp,u,x,atol,btol,conlim,itnlim,istop,itn,acond,rnorm,xnorm,w)
         integer, intent(in) :: m,n,ka,ml,mu,itnlim
         real, intent(in) :: a(ka,n),damp,atol,btol,conlim
         real, intent(inout) :: u(m)
         real, intent(out) :: x(n),acond,rnorm,xnorm,w(*)
         integer, intent(out) :: istop,itn
      end subroutine blsq
   end interface
   real :: qr(3,2),s(2),rhs(3),band(3,2),u(3),x(2),wk(4),acond,rnorm,xnorm
   integer :: ip(2),istop,itn
   logical :: ok
   qr=reshape([1.,1.,1.,0.,1.,2.],[3,2])
   rhs=[1.,3.,5.]
   call ortho(3,2,qr,3,s,ip,ok)
   if (.not.ok) error stop 'legacy ORTHO'
   call orsol(3,2,qr,3,s,ip,rhs)
   if (maxval(abs(rhs(1:2)-[1.,2.]))>3.0e-5) error stop 'legacy ORSOL'

   band=0.0
   ! ml=1, mu=0 compact row-band storage for [[1,0],[1,1],[0,1]].
   band(1,2)=1.
   band(2,1)=1.; band(2,2)=1.
   band(3,1)=1.
   u=[1.,3.,2.]
   call blsq(3,2,band,3,1,0,0.0,u,x,0.0,0.0,0.0,10,istop,itn,acond,rnorm,xnorm,wk)
   if (maxval(abs(x-[1.,2.]))>5.0e-4) error stop 'legacy BLSQ'
   print '(a,2es25.16)', 'Orthogonal solve: ',rhs(1:2)
   print '(a,2es25.16)', 'Banded least squares: ',x
   print *, 'test_least_squares: PASS'
end program test_least_squares
