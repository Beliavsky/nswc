! Adapted from test_real_eigensystem_compat_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_real_eigensystem_compat
   implicit none
   integer, parameter :: n=3
   real :: a0(n,n),a(n,n),h(n,n),z(n,n),ort(n),wr(n),wi(n),zr(n,n),zi(n,n),r(n,n)
   double precision :: da0(n,n),da(n,n),dh(n,n),dz(n,n),dort(n),dr(n,n)
   complex :: v(n),lambda,res(n)
   integer :: i,j,ierr,ibal

   interface
      subroutine orthes(nm,n,low,igh,a,ort)
         integer, intent(in) :: nm,n,low,igh
         real, intent(inout) :: a(nm,n)
         real, intent(out) :: ort(igh)
      end subroutine orthes
      subroutine ortran(nm,n,low,igh,a,ort,z)
         integer, intent(in) :: nm,n,low,igh
         real, intent(in) :: a(nm,igh)
         real, intent(inout) :: ort(igh)
         real, intent(out) :: z(nm,n)
      end subroutine ortran
      subroutine dorth(nm,n,low,igh,a,ort)
         integer, intent(in) :: nm,n,low,igh
         double precision, intent(inout) :: a(nm,n)
         double precision, intent(out) :: ort(igh)
      end subroutine dorth
      subroutine dortrn(nm,n,low,igh,a,ort,z)
         integer, intent(in) :: nm,n,low,igh
         double precision, intent(in) :: a(nm,igh)
         double precision, intent(inout) :: ort(igh)
         double precision, intent(out) :: z(nm,n)
      end subroutine dortrn
      subroutine eig1(ibal,a,ka,n,wr,wi,ierr)
         integer, intent(in) :: ibal,ka,n
         real, intent(inout) :: a(ka,n)
         real, intent(out) :: wr(n),wi(n)
         integer, intent(out) :: ierr
      end subroutine eig1
      subroutine eigv1(ibal,a,ka,n,wr,wi,zr,zi,ierr)
         integer, intent(in) :: ibal,ka,n
         real, intent(inout) :: a(ka,n)
         real, intent(out) :: wr(n),wi(n),zr(ka,n),zi(ka,n)
         integer, intent(out) :: ierr
      end subroutine eigv1
   end interface

   a0=reshape([1.0,3.0,2.0, 2.0,0.0,1.0, 0.0,1.0,2.0],[n,n])
   a=a0
   call orthes(n,n,1,n,a,ort)
   h=a
   call ortran(n,n,1,n,a,ort,z)
   do j=1,n
      do i=j+2,n
         h(i,j)=0.0
      end do
   end do
   r=matmul(transpose(z),matmul(a0,z))
   call require(maxval(abs(r-h))<2.0e-4,'legacy ORTRAN reconstruction')

   da0=dble(a0)
   da=da0
   call dorth(n,n,1,n,da,dort)
   dh=da
   call dortrn(n,n,1,n,da,dort,dz)
   do j=1,n
      do i=j+2,n
         dh(i,j)=0.0d0
      end do
   end do
   dr=matmul(transpose(dz),matmul(da0,dz))
   call require(maxval(abs(dr-dh))<2.0d-12,'legacy DORTRN reconstruction')

   a0=reshape([0.0,1.0,0.0, -1.0,0.0,0.0, 0.0,0.0,2.0],[n,n])
   a=a0
   call eig1(1,a,n,n,wr,wi,ierr)
   call require(ierr==0,'legacy EIG1 status')
   call require(minval(abs(cmplx(wr,wi)-cmplx(0.0,1.0)))<2.0e-4,'legacy EIG1 +i')
   call require(minval(abs(cmplx(wr,wi)-cmplx(0.0,-1.0)))<2.0e-4,'legacy EIG1 -i')
   call require(minval(abs(cmplx(wr,wi)-cmplx(2.0,0.0)))<2.0e-4,'legacy EIG1 2')

   do ibal=0,1
      a=a0
      call eigv1(ibal,a,n,n,wr,wi,zr,zi,ierr)
      call require(ierr==0,'legacy EIGV1 status')
      do j=1,n
         lambda=cmplx(wr(j),wi(j))
         v=cmplx(zr(:,j),zi(:,j))
         call require(maxval(abs(v))>0.0,'EIGV1 nonzero vector')
         res=matmul(cmplx(a0,0.0),v)-lambda*v
         call require(sqrt(sum(abs(res)**2))<3.0e-4,'legacy EIGV1 residual')
      end do

   end do

   print '(a,3es25.16)', 'Compatibility eigenvalue parts: ',wr
   print '(a,3es25.16)', 'Compatibility imaginary parts: ',wi
   print '(a)', 'test_real_eigensystem_compat: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not.ok) then
         write(*,'(a,1x,a)') 'FAIL:',trim(label)
         error stop 1
      end if
   end subroutine require
end program test_real_eigensystem_compat
