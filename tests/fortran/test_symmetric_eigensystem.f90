! Adapted from C:/fortran/amiller-nswc/test/test_symmetric_eigensystem_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_symmetric_eigensystem
   implicit none
   integer, parameter :: n=3,ka=3
   real, parameter :: rt2=sqrt(2.0)
   real :: a(ka,n), a0(n,n), packed(6), w(n), z(ka,n), t(2*n), t1(n)
   real :: residual(n,n)
   integer :: ierr

   interface
      subroutine seig(a,ka,n,w,t,ierr)
         real, intent(inout) :: a(*)
         integer, intent(in) :: ka
         integer, intent(in) :: n
         real, intent(out) :: w(n)
         real, intent(out) :: t(*)
         integer, intent(out) :: ierr
      end subroutine seig
      subroutine seig1(a,ka,n,w,t,ierr)
         real, intent(inout) :: a(*)
         integer, intent(in) :: ka
         integer, intent(in) :: n
         real, intent(out) :: w(n)
         real, intent(out) :: t(n)
         integer, intent(out) :: ierr
      end subroutine seig1
      subroutine seigv(a,ka,n,w,z,t,ierr)
         integer, intent(in) :: ka
         integer, intent(in) :: n
         real, intent(in) :: a(ka,n)
         real, intent(out) :: w(n)
         real, intent(out) :: z(ka,n)
         real, intent(out) :: t(n)
         integer, intent(out) :: ierr
      end subroutine seigv
      subroutine seigv1(a,ka,n,w,z,t,ierr)
         integer, intent(in) :: ka
         integer, intent(in) :: n
         real, intent(in) :: a(ka,n)
         real, intent(out) :: w(n)
         real, intent(out) :: z(ka,n)
         real, intent(out) :: t(n)
         integer, intent(out) :: ierr
      end subroutine seigv1
   end interface

   a0=reshape([2.0,1.0,0.0, 1.0,2.0,1.0, 0.0,1.0,2.0],[n,n])
   a=a0
   call seig(a,ka,n,w,t,ierr)
   call require(ierr==0,'seig status')
   call require(maxval(abs(w-[2.0-rt2,2.0,2.0+rt2]))<2.0e-5,'seig eigenvalues')

   packed=[2.0,1.0,2.0,0.0,1.0,2.0]
   call seig1(packed,0,n,w,t1,ierr)
   call require(ierr==0,'seig1 status')

   a=a0
   call seigv(a,ka,n,w,z,t1,ierr)
   call require(ierr==0,'seigv status')
   residual=matmul(a0,z)-z*spread(w,1,n)
   call require(maxval(abs(residual))<3.0e-5,'seigv residual')

   call seigv1(a,ka,n,w,z,t1,ierr)
   call require(ierr==0,'seigv1 status')
   residual=matmul(a0,z)-z*spread(w,1,n)
   call require(maxval(abs(residual))<3.0e-5,'seigv1 residual')

   print '(a,3es25.16)', 'Eigenvalues: ',w
   print '(a,es25.16)', 'Maximum eigenvector residual: ',maxval(abs(residual))
   print '(a)', 'test_symmetric_eigensystem: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not.ok) then
         write(*,'(a,1x,a)') 'FAIL:',trim(label)
         error stop 1
      end if
   end subroutine require
end program test_symmetric_eigensystem
