! Adapted from test_real_hessenberg_qr_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_real_hessenberg_qr
   implicit none
   integer, parameter :: n = 3
   real :: h(n, n), wr(n), wi(n), z(n, n)
   double precision :: dh(n, n), dwr(n), dwi(n), dz(n, n)
   integer :: ierr,j
   real :: h0(n,n)
   double precision :: dh0(n,n)
   complex :: v(n),lambda
   complex(kind(1.0d0)) :: dv(n),dlambda

   interface
      subroutine hqr(nm, n, low, igh, h, wr, wi, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         real, intent(inout) :: h(nm, n)
         real, intent(out) :: wr(n)
         real, intent(out) :: wi(n)
         integer, intent(out) :: ierr
      end subroutine hqr
      subroutine hqr2(nm, n, low, igh, h, wr, wi, z, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         real, intent(inout) :: h(nm, n)
         real, intent(out) :: wr(n)
         real, intent(out) :: wi(n)
         real, intent(inout) :: z(nm, n)
         integer, intent(out) :: ierr
      end subroutine hqr2
      subroutine dhqr(nm, n, low, igh, h, wr, wi, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         double precision, intent(inout) :: h(nm, n)
         double precision, intent(out) :: wr(n)
         double precision, intent(out) :: wi(n)
         integer, intent(out) :: ierr
      end subroutine dhqr
      subroutine dhqr2(nm, n, low, igh, h, wr, wi, z, ierr)
         integer, intent(in) :: nm
         integer, intent(in) :: n
         integer, intent(in) :: low
         integer, intent(in) :: igh
         double precision, intent(inout) :: h(nm, n)
         double precision, intent(out) :: wr(n)
         double precision, intent(out) :: wi(n)
         double precision, intent(inout) :: z(nm, n)
         integer, intent(out) :: ierr
      end subroutine dhqr2
   end interface

   call fill_single(h)
   call hqr(n, n, 1, n, h, wr, wi, ierr)
   call require(ierr == 0, 'legacy HQR')
   call require(minval(abs(cmplx(wr,wi)-(1.,2.)))<2e-4,'single +pair')
   call require(minval(abs(cmplx(wr,wi)-(1.,-2.)))<2e-4,'single -pair')
   call require(minval(abs(cmplx(wr,wi)-(3.,0.)))<2e-4,'single real root')

   call fill_single(h)
   z = 0.0
   z(1, 1) = 1.0
   z(2, 2) = 1.0
   z(3, 3) = 1.0
   call hqr2(n, n, 1, n, h, wr, wi, z, ierr)
   call require(ierr == 0, 'legacy HQR2')
   call require(minval(abs(cmplx(wr,wi)-(1.,2.)))<2e-4,'single +pair')
   call require(minval(abs(cmplx(wr,wi)-(1.,-2.)))<2e-4,'single -pair')
   call require(minval(abs(cmplx(wr,wi)-(3.,0.)))<2e-4,'single real root')
   call require(wi(1) >= 0.0, 'legacy HQR2 pair ordering')

   call fill_double(dh)
   call dhqr(n, n, 1, n, dh, dwr, dwi, ierr)
   call require(ierr == 0, 'legacy DHQR')
   call require(minval(abs(cmplx(dwr,dwi,kind(1d0))-(1d0,2d0)))<2d-12,'double +pair')
   call require(minval(abs(cmplx(dwr,dwi,kind(1d0))-(1d0,-2d0)))<2d-12,'double -pair')
   call require(minval(abs(cmplx(dwr,dwi,kind(1d0))-(3d0,0d0)))<2d-12,'double real root')

   call fill_double(dh)
   dz = 0.0d0
   dz(1, 1) = 1.0d0
   dz(2, 2) = 1.0d0
   dz(3, 3) = 1.0d0
   call dhqr2(n, n, 1, n, dh, dwr, dwi, dz, ierr)
   call require(ierr == 0, 'legacy DHQR2')
   call require(minval(abs(cmplx(dwr,dwi,kind(1d0))-(1d0,2d0)))<2d-12,'double +pair')
   call require(minval(abs(cmplx(dwr,dwi,kind(1d0))-(1d0,-2d0)))<2d-12,'double -pair')
   call require(minval(abs(cmplx(dwr,dwi,kind(1d0))-(3d0,0d0)))<2d-12,'double real root')

   call fill_single(h0)
   call fill_double(dh0)
   do j=1,n
      v=cmplx(z(:,j),0.0)
      if (wi(j)>0.0) v=cmplx(z(:,j),z(:,j+1))
      if (wi(j)<0.0) v=cmplx(z(:,j-1),-z(:,j))
      lambda=cmplx(wr(j),wi(j))
      call require(maxval(abs(v))>0.0,'HQR2 nonzero vector')
      call require(maxval(abs(matmul(cmplx(h0,0.0),v)-lambda*v))<3e-4,'HQR2 residual')
      dv=cmplx(dz(:,j),0d0,kind(1d0))
      if (dwi(j)>0d0) dv=cmplx(dz(:,j),dz(:,j+1),kind(1d0))
      if (dwi(j)<0d0) dv=cmplx(dz(:,j-1),-dz(:,j),kind(1d0))
      dlambda=cmplx(dwr(j),dwi(j),kind(1d0))
      call require(maxval(abs(dv))>0d0,'DHQR2 nonzero vector')
      call require(maxval(abs(matmul(cmplx(dh0,0d0,kind(1d0)),dv)-dlambda*dv))<3d-12,'DHQR2 residual')
   end do
   print '(a,3es25.16)', 'QR eigenvalue parts: ',dwr
   print '(a,3es25.16)', 'QR imaginary parts: ',dwi
   print '(a)', 'test_real_hessenberg_qr: PASS'
contains
   subroutine fill_single(a)
      real, intent(out) :: a(n, n)
      a = 0.0
      a(1, 1) = 1.0
      a(1, 2) = -2.0
      a(2, 1) = 2.0
      a(2, 2) = 1.0
      a(3, 3) = 3.0
   end subroutine fill_single

   subroutine fill_double(a)
      double precision, intent(out) :: a(n, n)
      a = 0.0d0
      a(1, 1) = 1.0d0
      a(1, 2) = -2.0d0
      a(2, 1) = 2.0d0
      a(2, 2) = 1.0d0
      a(3, 3) = 3.0d0
   end subroutine fill_double

   subroutine require(ok, label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not. ok) then
         write(*, '(a,1x,a)') 'FAIL:', trim(label)
         error stop 1
      end if
   end subroutine require
end program test_real_hessenberg_qr
