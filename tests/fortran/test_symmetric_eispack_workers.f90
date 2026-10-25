! Adapted from test_symmetric_eispack_workers_legacy.f90 in the amiller-nswc test suite.
program test_symmetric_eispack_workers
   implicit none
   integer, parameter :: n=3, nm=3, nv=6
   real :: a(nm,n), a0(n,n), d(n), e(n), e2(n), z(nm,n), packed(nv)
   real :: residual(n,n)
   real, parameter :: rt2=sqrt(2.0), tol=3.0e-4
   integer :: ierr, i
   double precision :: dpacked(nv), dd(n), de(n), de2(n)

   interface
      subroutine tred1(nm,n,a,d,e,e2)
         integer, intent(in) :: nm, n
         real, intent(inout) :: a(nm,n)
         real, intent(out) :: d(n), e(n), e2(n)
      end subroutine tred1
      subroutine tred2(nm,n,a,d,e,z)
         integer, intent(in) :: nm, n
         real, intent(in) :: a(nm,n)
         real, intent(out) :: d(n), e(n), z(nm,n)
      end subroutine tred2
      subroutine tred3(n,nv,a,d,e,e2)
         integer, intent(in) :: n, nv
         real, intent(inout) :: a(nv)
         real, intent(out) :: d(n), e(n), e2(n)
      end subroutine tred3
      subroutine tql2(nm,n,d,e,z,ierr)
         integer, intent(in) :: nm, n
         real, intent(inout) :: d(n), e(n), z(nm,n)
         integer, intent(out) :: ierr
      end subroutine tql2
      subroutine tqlrat(n,d,e2,ierr)
         integer, intent(in) :: n
         real, intent(inout) :: d(n), e2(n)
         integer, intent(out) :: ierr
      end subroutine tqlrat
      subroutine imtql1(n,d,e,ierr)
         integer, intent(in) :: n
         real, intent(inout) :: d(n), e(n)
         integer, intent(out) :: ierr
      end subroutine imtql1
      subroutine imtql2(nm,n,d,e,z,ierr)
         integer, intent(in) :: nm, n
         real, intent(inout) :: d(n), e(n), z(nm,n)
         integer, intent(out) :: ierr
      end subroutine imtql2
      subroutine dtred3(n,nv,a,d,e,e2)
         integer :: n,nv
         double precision :: a(nv),d(n),e(n),e2(n)
      end subroutine dtred3
      subroutine dtql(n,d,e2,ierr)
         integer :: n,ierr
         double precision :: d(n),e2(n)
      end subroutine dtql
   end interface

   a0=reshape([2.0,1.0,0.0, 1.0,2.0,1.0, 0.0,1.0,2.0],[n,n])
   a=a0
   call tred2(nm,n,a,d,e,z)
   call tql2(nm,n,d,e,z,ierr)
   call require(ierr==0,'tred2/tql2 status')
   call require(maxval(abs(d-[2.0-rt2,2.0,2.0+rt2]))<tol,'tred2/tql2 spectrum')
   residual=matmul(a0,z)-z*spread(d,1,n)
   call require(maxval(abs(residual))<tol,'tred2/tql2 residual')

   a=a0
   call tred1(nm,n,a,d,e,e2)
   call tqlrat(n,d,e2,ierr)
   call require(ierr==0,'tred1/tqlrat status')
   call require(maxval(abs(d-[2.0-rt2,2.0,2.0+rt2]))<tol,'tred1/tqlrat spectrum')

   packed=[2.0,1.0,2.0,0.0,1.0,2.0]
   call tred3(n,nv,packed,d,e,e2)
   call imtql1(n,d,e,ierr)
   call require(ierr==0,'tred3/imtql1 status')
   call require(maxval(abs(d-[2.0-rt2,2.0,2.0+rt2]))<tol,'tred3/imtql1 spectrum')

   d=[2.0,2.0,2.0]
   e=[0.0,1.0,1.0]
   z=0.0
   do i=1,n
      z(i,i)=1.0
   end do
   call imtql2(nm,n,d,e,z,ierr)
   call require(ierr==0,'imtql2 status')

   call require(maxval(abs(d-[2.0-rt2,2.0,2.0+rt2]))<tol,'imtql2 spectrum')
   residual=matmul(a0,z)-z*spread(d,1,n)
   call require(maxval(abs(residual))<tol,'imtql2 residual')
   dpacked=[2.0d0,1.0d0,2.0d0,0.0d0,1.0d0,2.0d0]
   call dtred3(n,nv,dpacked,dd,de,de2)
   call dtql(n,dd,de2,ierr)
   call require(ierr==0,'dtred3/dtql status')
   call require(maxval(abs(dd-[2.0d0-sqrt(2.0d0),2.0d0,2.0d0+sqrt(2.0d0)]))<3.0d-13, &
      'dtred3/dtql spectrum')
   print '(a,3es24.15)', 'packed symmetric eigenvalues: ',dd
   print '(a)',  'test_symmetric_eispack_workers: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not.ok) then
         write(*,'(a,1x,a)') 'FAIL:',trim(label)
         error stop 1
      end if
   end subroutine require
end program test_symmetric_eispack_workers
