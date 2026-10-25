! Adapted from C:/fortran/amiller-nswc/test/test_random_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_random
   implicit none
   real :: u(2),z(2)
   integer :: seed,ierr
   interface
      subroutine urng(ix,x,n,ierr)
         integer, intent(inout) :: ix
         real, intent(out) :: x(*)
         integer, intent(in) :: n
         integer, intent(out) :: ierr
      end subroutine urng
      subroutine nrng(ix,a,n,ierr)
         integer, intent(inout) :: ix
         real, intent(out) :: a(*)
         integer, intent(in) :: n
         integer, intent(out) :: ierr
      end subroutine nrng
   end interface

   seed=1
   call urng(seed,u,2,ierr)
   if (ierr/=0 .or. seed/=282475249) error stop 'legacy URNG'
   seed=1
   call nrng(seed,z,2,ierr)
   if (ierr/=0 .or. seed/=282475249) error stop 'legacy NRNG seed'
   if (maxval(abs(z-[3.2852871,3.5669190]))>3.0e-6) error stop 'legacy NRNG sequence'

   print '(a,2es25.16)', 'Uniform sequence: ',u
   print '(a,2es25.16)', 'Normal sequence: ',z
   print *, 'test_random: PASS'
end program test_random
