! Adapted from test_complex_hessenberg_legacy.f90 in the amiller-nswc test suite.
program test_complex_hessenberg
   implicit none
   integer, parameter :: n = 3
   real :: ar(n, n), ai(n, n), ortr(n), orti(n), wr(n), wi(n), zr(n, n), zi(n, n)
   double precision :: dar(n, n), dai(n, n), dortr(n), dorti(n), dwr(n), dwi(n), dzr(n, n), dzi(n, n)
   integer :: ierr,j
   complex :: a0(n,n),v(n),res(n)
   complex(kind(1d0)) :: da0(n,n),dv(n),dres(n)

   interface
      subroutine corth(nm, n, low, igh, ar, ai, ortr, orti)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         real, intent(inout) :: ar(nm, n)
         real, intent(inout) :: ai(nm, n)
         real, intent(out) :: ortr(*)
         real, intent(out) :: orti(*)
      end subroutine corth
      subroutine dcorth(nm, n, low, igh, ar, ai, ortr, orti)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         double precision, intent(inout) :: ar(nm, n)
         double precision, intent(inout) :: ai(nm, n)
         double precision, intent(out) :: ortr(*)
         double precision, intent(out) :: orti(*)
      end subroutine dcorth
      subroutine comqr(nm, n, low, igh, hr, hi, wr, wi, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         real, intent(inout) :: hr(nm, n)
         real, intent(inout) :: hi(nm, n)
         real, intent(out) :: wr(n)
         real, intent(out) :: wi(n)
         integer, intent(out) :: ierr
      end subroutine comqr
      subroutine dcomqr(nm, n, low, igh, hr, hi, wr, wi, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         double precision, intent(inout) :: hr(nm, n)
         double precision, intent(inout) :: hi(nm, n)
         double precision, intent(out) :: wr(n)
         double precision, intent(out) :: wi(n)
         integer, intent(out) :: ierr
      end subroutine dcomqr
      subroutine comqr2(nm, n, low, igh, ortr, orti, hr, hi, wr, wi, zr, zi, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         real, intent(inout) :: ortr(*)
         real, intent(inout) :: orti(*)
         real, intent(inout) :: hr(nm, n)
         real, intent(inout) :: hi(nm, n)
         real, intent(out) :: wr(n)
         real, intent(out) :: wi(n)
         real, intent(out) :: zr(nm, n)
         real, intent(out) :: zi(nm, n)
         integer, intent(out) :: ierr
      end subroutine comqr2
      subroutine dcmqr2(nm, n, low, igh, ortr, orti, hr, hi, wr, wi, zr, zi, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         double precision, intent(inout) :: ortr(*)
         double precision, intent(inout) :: orti(*)
         double precision, intent(inout) :: hr(nm, n)
         double precision, intent(inout) :: hi(nm, n)
         double precision, intent(out) :: wr(n)
         double precision, intent(out) :: wi(n)
         double precision, intent(out) :: zr(nm, n)
         double precision, intent(out) :: zi(nm, n)
         integer, intent(out) :: ierr
      end subroutine dcmqr2
   end interface

   ar = reshape([2.0, 1.0, -0.5, 3.0, 4.0, 1.25, -1.0, 2.5, 6.0], [n, n])
   ai = reshape([0.2, -0.4, 0.3, 0.5, -0.6, 0.2, 0.1, -0.3, 0.4], [n, n])
   a0=cmplx(ar,ai)
   call corth(n, n, 1, n, ar, ai, ortr, orti)
   call comqr2(n, n, 1, n, ortr, orti, ar, ai, wr, wi, zr, zi, ierr)
   call require(ierr == 0, 'legacy CORTH/COMQR2')
   do j=1,n
      v=cmplx(zr(:,j),zi(:,j))
      call require(maxval(abs(v))>0.1,'COMQR2 nonzero vector')
      res=matmul(a0,v)-cmplx(wr(j),wi(j))*v
      call require(maxval(abs(res))<3.0e-4*maxval(abs(v)),'COMQR2 residual')
   end do
   print '(a,6es24.15)', 'complex QR eigenvalues: ',wr,wi

   dar = reshape([2.0d0, 1.0d0, -0.5d0, 3.0d0, 4.0d0, 1.25d0, -1.0d0, 2.5d0, 6.0d0], [n, n])
   dai = reshape([0.2d0, -0.4d0, 0.3d0, 0.5d0, -0.6d0, 0.2d0, 0.1d0, -0.3d0, 0.4d0], [n, n])
   da0=cmplx(dar,dai,kind(1d0))
   call dcorth(n, n, 1, n, dar, dai, dortr, dorti)
   call dcmqr2(n, n, 1, n, dortr, dorti, dar, dai, dwr, dwi, dzr, dzi, ierr)
   call require(ierr == 0, 'legacy DCORTH/DCMQR2')
   do j=1,n
      dv=cmplx(dzr(:,j),dzi(:,j),kind(1d0))
      call require(maxval(abs(dv))>0.1d0,'DCMQR2 nonzero vector')
      dres=matmul(da0,dv)-cmplx(dwr(j),dwi(j),kind(1d0))*dv
      call require(maxval(abs(dres))<3.0d-12*maxval(abs(dv)),'DCMQR2 residual')
   end do
   print '(a,6es24.15)', 'double complex QR eigenvalues: ',dwr,dwi

   ar = 0.0
   ai = 0.0
   ar(1, 1) = 1.0
   ar(1, 2) = 2.0
   ar(2, 2) = 3.0
   ar(2, 3) = -1.0
   ar(3, 3) = 5.0
   call comqr(n, n, 1, n, ar, ai, wr, wi, ierr)
   call require(ierr == 0, 'legacy COMQR')
   call require(maxval(abs(wr-[1.0,3.0,5.0]))<1.0e-5,'COMQR spectrum')
   call require(maxval(abs(wi))<1.0e-5,'COMQR imaginary spectrum')

   dar = 0.0d0
   dai = 0.0d0
   dar(1, 1) = 1.0d0
   dar(1, 2) = 2.0d0
   dar(2, 2) = 3.0d0
   dar(2, 3) = -1.0d0
   dar(3, 3) = 5.0d0
   call dcomqr(n, n, 1, n, dar, dai, dwr, dwi, ierr)
   call require(ierr == 0, 'legacy DCOMQR')
   call require(maxval(abs(dwr-[1.0d0,3.0d0,5.0d0]))<1.0d-13,'DCOMQR spectrum')
   call require(maxval(abs(dwi))<1.0d-13,'DCOMQR imaginary spectrum')

   print '(a)', 'test_complex_hessenberg: PASS'
contains
   subroutine require(ok, label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not. ok) then
         write(*, '(a,1x,a)') 'FAIL:', trim(label)
         error stop 1
      end if
   end subroutine require
end program test_complex_hessenberg
