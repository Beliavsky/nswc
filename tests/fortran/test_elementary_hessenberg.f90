! Adapted from test_elementary_hessenberg_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_elementary_hessenberg
   implicit none
   integer, parameter :: n=4
   real :: a0(n,n),a(n,n),h(n,n),z(n,n),rw(n)
   integer :: ind(n),i,j

   interface
      subroutine elmhes(nm,n,low,igh,a,ind)
         integer, intent(in) :: nm,n,low,igh
         real, intent(inout) :: a(nm,n)
         integer, intent(out) :: ind(igh)
      end subroutine elmhes
      subroutine elmhs0(nm,n,low,igh,a,ind)
         integer, intent(in) :: nm,n,low,igh
         real, intent(inout) :: a(nm,n)
         real, intent(out) :: ind(igh)
      end subroutine elmhs0
      subroutine eltran(nm,n,low,igh,a,ind,z)
         integer, intent(in) :: nm,n,low,igh
         real, intent(in) :: a(nm,igh)
         integer, intent(in) :: ind(igh)
         real, intent(out) :: z(nm,n)
      end subroutine eltran
      subroutine eltrn0(nm,n,low,igh,a,ind,z)
         integer, intent(in) :: nm,n,low,igh
         real, intent(in) :: a(nm,igh)
         real, intent(in) :: ind(igh)
         real, intent(out) :: z(nm,n)
      end subroutine eltrn0
   end interface

   a0(1,:)=[7.0/3.0,-5.0/3.0,5.0/3.0,-5.0]
   a0(2,:)=[1.0/3.0,4.0/3.0,5.0/3.0,-2.0]
   a0(3,:)=[-4.0/3.0,5.0/3.0,4.0/3.0,-1.0]
   a0(4,:)=[5.0/3.0,-1.0/3.0,1.0/3.0,-3.0]

   a=a0
   call elmhes(n,n,1,n,a,ind)
   call eltran(n,n,1,n,a,ind,z)
   h=a
   do j=1,n
      do i=j+2,n
         h(i,j)=0.0
      end do
   end do
   call require(maxval(abs(matmul(a0,z)-matmul(z,h)))<3.0e-5,'legacy ELMHES/ELTRAN')

   a=a0
   call elmhs0(n,n,1,n,a,rw)
   call eltrn0(n,n,1,n,a,rw,z)
   h=a
   do j=1,n
      do i=j+2,n
         h(i,j)=0.0
      end do
   end do
   call require(maxval(abs(matmul(a0,z)-matmul(z,h)))<3.0e-5,'legacy ELMHS0/ELTRN0')

   print '(a,es25.16)', 'Elementary Hessenberg residual: ',maxval(abs(matmul(a0,z)-matmul(z,h)))
   print '(a)', 'test_elementary_hessenberg: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(len=*), intent(in) :: label
      if (.not.ok) then
         write(*,'(a,1x,a)') 'FAIL:',trim(label)
         error stop 1
      end if
   end subroutine require
end program test_elementary_hessenberg
