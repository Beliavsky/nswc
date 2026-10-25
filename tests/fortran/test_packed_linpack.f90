! Adapted from test_packed_linpack_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_packed_linpack
   use, intrinsic :: iso_fortran_env, only : dp => real64
   implicit none

   interface
      subroutine dppfa(ap, n, info)
         import :: dp
         real(dp), intent(inout) :: ap(*)
         integer, intent(in) :: n
         integer, intent(out) :: info
      end subroutine dppfa
      subroutine dppsl(ap, n, b)
         import :: dp
         real(dp), intent(in) :: ap(*)
         integer, intent(in) :: n
         real(dp), intent(inout) :: b(*)
      end subroutine dppsl
      subroutine dppdi(ap, n, det, job)
         import :: dp
         real(dp), intent(inout) :: ap(*)
         integer, intent(in) :: n
         real(dp), intent(out) :: det(2)
         integer, intent(in) :: job
      end subroutine dppdi
      subroutine dspco(ap, n, kpvt, rcond, z)
         import :: dp
         real(dp), intent(inout) :: ap(*)
         integer, intent(in) :: n
         integer, intent(out) :: kpvt(*)
         real(dp), intent(out) :: rcond
         real(dp), intent(out) :: z(*)
      end subroutine dspco
      subroutine dspsl(ap, n, kpvt, b)
         import :: dp
         real(dp), intent(in) :: ap(*)
         integer, intent(in) :: n
         integer, intent(in) :: kpvt(*)
         real(dp), intent(inout) :: b(*)
      end subroutine dspsl
      subroutine dspdi(ap, n, kpvt, det, inert, work, job)
         import :: dp
         real(dp), intent(inout) :: ap(*)
         integer, intent(in) :: n
         integer, intent(in) :: kpvt(*)
         real(dp), intent(out) :: det(2)
         integer, intent(out) :: inert(3)
         real(dp), intent(out) :: work(*)
         integer, intent(in) :: job
      end subroutine dspdi
   end interface

   real(dp) :: ap(6), afac(6), b(3), det(2), rcond, rcond_singular, work(3), z(3)
   integer :: info, inert(3), kpvt(3)

   ap = [4.0_dp, 1.0_dp, 3.0_dp, 2.0_dp, 0.0_dp, 5.0_dp]
   afac = ap
   call dppfa(afac, 3, info)
   if (info /= 0) error stop 'legacy DPPFA status'
   b = [3.0_dp, -5.0_dp, 4.5_dp]
   call dppsl(afac, 3, b)
   if (maxval(abs(b - [1.0_dp,-2.0_dp,0.5_dp])) > 2.0e-13_dp) error stop 'legacy DPPSL solve'
   call dppdi(afac, 3, det, 10)
   if (abs(det(1)*10.0_dp**det(2) - 43.0_dp) > 2.0e-12_dp) error stop 'legacy DPPDI determinant'

   ap = [0.0_dp, 1.0_dp, 0.0_dp, 0.0_dp, 0.0_dp, 2.0_dp]
   afac = ap
   call dspco(afac, 3, kpvt, rcond, z)
   ! The exact reciprocal 1-norm condition is 0.5; DSPCO returns an estimate.
   ! Require it to be within a factor of two, rather than equal to the exact value.
   if (.not.(rcond>=0.25_dp .and. rcond<=1.0_dp)) error stop 'legacy DSPCO rcond'
   b = [2.0_dp, 1.0_dp, -2.0_dp]
   call dspsl(afac, 3, kpvt, b)
   if (maxval(abs(b - [1.0_dp,2.0_dp,-1.0_dp])) > 2.0e-13_dp) error stop 'legacy DSPSL solve'
   call dspdi(afac, 3, kpvt, det, inert, work, 110)
   if (abs(det(1)*10.0_dp**det(2) + 2.0_dp) > 2.0e-13_dp) error stop 'legacy DSPDI determinant'
   if (any(inert /= [2,1,0])) error stop 'legacy DSPDI inertia'

   ! An exactly singular diagonal matrix must produce a zero estimate.
   afac=[0.0_dp,0.0_dp,1.0_dp,0.0_dp,0.0_dp,2.0_dp]
   call dspco(afac,3,kpvt,rcond_singular,z)
   if (rcond_singular/=0.0_dp) error stop 'legacy DSPCO singular status'

   print '(a,3es25.16)', 'Packed indefinite solution: ',b
   print '(a,3es25.16)', 'Condition estimate and determinant: ',rcond,det
   print '(a,3i6)', 'Inertia: ',inert
   print *, 'test_packed_linpack: PASS'
end program test_packed_linpack
