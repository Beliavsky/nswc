! Adapted from test_symmetric_banded_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_symmetric_banded
   implicit none
   interface
      subroutine dpchol(mo,n,m,a,b,kb,ierr)
         integer, intent(in) :: mo,n,m,kb
         double precision, intent(inout) :: a(*),b(*)
         integer, intent(out) :: ierr
      end subroutine dpchol
      subroutine dsmslv(mo,n,m,a,b,kb,det,rcond,inert,ierr,ipvt,wk)
         integer, intent(in) :: mo,n,m,kb
         double precision, intent(inout) :: a(*),b(*)
         double precision, intent(out) :: det(2),rcond,wk(n)
         integer, intent(out) :: inert(3),ierr,ipvt(n)
      end subroutine dsmslv
      subroutine lltslv(nr,n,a,x,b)
         integer, intent(in) :: nr,n
         real, intent(in) :: a(nr,n),b(n)
         real, intent(out) :: x(n)
      end subroutine lltslv
      subroutine banfac(w,nroww,nrow,nbandl,nbandu,iflag)
         integer, intent(in) :: nroww,nrow,nbandl,nbandu
         real, intent(inout) :: w(nroww,nrow)
         integer, intent(out) :: iflag
      end subroutine banfac
      subroutine banslv(w,nroww,nrow,nbandl,nbandu,b)
         integer, intent(in) :: nroww,nrow,nbandl,nbandu
         real, intent(in) :: w(nroww,nrow)
         real, intent(inout) :: b(nrow)
      end subroutine banslv
      subroutine bchfac(w,nbands,nrow,diag,iflag)
         integer, intent(in) :: nbands,nrow
         real, intent(inout) :: w(nbands,nrow)
         real, intent(out) :: diag(nrow)
         integer, intent(out) :: iflag
      end subroutine bchfac
      subroutine bchslv(w,nbands,nrow,b)
         integer, intent(in) :: nbands,nrow
         real, intent(in) :: w(nbands,nrow)
         real, intent(inout) :: b(nrow)
      end subroutine bchslv
   end interface
   double precision :: ap(3),b2(2),det(2),rc,wk(2)
   real :: l(2,2),bb(2),xx(2),w(3,2),rhs(2),wc(2,2),dc(2),bc(2)
   integer :: ierr,inert(3),ipvt(2),iflag

   ap=[4d0,1d0,3d0]; b2=[6d0,7d0]
   call dpchol(1,2,1,ap,b2,2,ierr)
   if (ierr/=0 .or. maxval(abs(b2-[1d0,2d0]))>1d-13) error stop 'legacy DPCHOL'

   ap=[2d0,1d0,-1d0]; b2=[4d0,-1d0]
   call dsmslv(1,2,1,ap,b2,2,det,rc,inert,ierr,ipvt,wk)
   if (ierr/=0 .or. maxval(abs(b2-[1d0,2d0]))>1d-13) error stop 'legacy DSMSLV'

   l=reshape([2.0,1.0,0.0,1.0],[2,2]); l(1,2)=0.0
   bb=matmul(matmul(l,transpose(l)),[1.0,2.0])
   call lltslv(2,2,l,xx,bb)
   if (maxval(abs(xx-[1.0,2.0]))>2e-5) error stop 'legacy LLTSLV'

   w=0.0; w(2,:)=[4.0,3.0]; w(1,2)=1.0; w(3,1)=2.0; rhs=[6.0,8.0]
   call banfac(w,3,2,1,1,iflag); call banslv(w,3,2,1,1,rhs)
   if (iflag/=1 .or. maxval(abs(rhs-[1.0,2.0]))>2e-5) error stop 'legacy BANFAC'

   wc=0.0; wc(1,:)=[4.0,3.0]; wc(2,1)=1.0; bc=[6.0,7.0]
   call bchfac(wc,2,2,dc,iflag); call bchslv(wc,2,2,bc)
   if (iflag/=0 .or. maxval(abs(bc-[1.0,2.0]))>2e-5) error stop 'legacy BCHFAC'
   print '(a,2es25.16)', 'Packed symmetric solution: ',b2
   print '(a,2es25.16)', 'Banded Cholesky solution: ',bc
   print *, 'test_symmetric_banded: PASS'
end program test_symmetric_banded
