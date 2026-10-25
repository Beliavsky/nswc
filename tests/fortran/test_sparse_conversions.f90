! Adapted from test_sparse_conversions_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_sparse_conversions
   implicit none
   integer, parameter :: dp = kind(1.0d0)
   interface
      subroutine csreal(a, ia, ja, b, ib, jb, m)
         complex, intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         real, intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(in) :: m
      end subroutine csreal
      subroutine csimag(a, ia, ja, b, ib, jb, m)
         complex, intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         real, intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(in) :: m
      end subroutine csimag
      subroutine sconj(a, ia, ja, b, ib, jb, m)
         complex, intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         complex, intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(in) :: m
      end subroutine sconj
      subroutine scvrd(a, ia, ja, b, ib, jb, m)
         integer, parameter :: dp_l = kind(1.0d0)
         real, intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         real(dp_l), intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(in) :: m
      end subroutine scvrd
      subroutine scvdr(a, ia, ja, b, ib, jb, m)
         integer, parameter :: dp_l = kind(1.0d0)
         real(dp_l), intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         real, intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(in) :: m
      end subroutine scvdr
      subroutine scvrc(a, ia, ja, b, ib, jb, c, ic, jc, m, n, num, wk, ierr)
         real, intent(in) :: a(*), b(*)
         integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
         complex, intent(out) :: c(*)
         integer, intent(out) :: ic(*), jc(*)
         integer, intent(in) :: m, n, num
         real, intent(inout) :: wk(n)
         integer, intent(out) :: ierr
      end subroutine scvrc
      subroutine cvcs(a, ka, m, n, b, ib, jb, num, ierr)
         integer, intent(in) :: ka, m, n, num
         complex, intent(in) :: a(ka, n)
         complex, intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(out) :: ierr
      end subroutine cvcs
      subroutine cvsc(a, ia, ja, b, kb, m, n)
         complex, intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         integer, intent(in) :: kb, m, n
         complex, intent(out) :: b(kb, n)
      end subroutine cvsc
      subroutine cvrs(a, ka, m, n, b, ib, jb, num, ierr)
         integer, intent(in) :: ka, m, n, num
         real, intent(in) :: a(ka, n)
         real, intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(out) :: ierr
      end subroutine cvrs
      subroutine cvsr(a, ia, ja, b, kb, m, n)
         real, intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         integer, intent(in) :: kb, m, n
         real, intent(out) :: b(kb, n)
      end subroutine cvsr
      subroutine cvds(a, ka, m, n, b, ib, jb, num, ierr)
         integer, parameter :: dp_l = kind(1.0d0)
         integer, intent(in) :: ka, m, n, num
         real(dp_l), intent(in) :: a(ka, n)
         real(dp_l), intent(out) :: b(*)
         integer, intent(out) :: ib(*), jb(*)
         integer, intent(out) :: ierr
      end subroutine cvds
      subroutine cvsd(a, ia, ja, b, kb, m, n)
         integer, parameter :: dp_l = kind(1.0d0)
         real(dp_l), intent(in) :: a(*)
         integer, intent(in) :: ia(*), ja(*)
         integer, intent(in) :: kb, m, n
         real(dp_l), intent(out) :: b(kb, n)
      end subroutine cvsd
   end interface

   complex :: cmat(3, 2), cs(4), cb(4), cback(3, 2)
   real :: rmat(3, 2), rs(4), rback(3, 2), part(4)
   real(dp) :: dmat(3, 2), ds(4), dback(3, 2), dconv(4)
   real :: rconv(4), imag_s(4), wk(2)
   complex :: joined(6)
   integer :: ia(4), ja(4), ib(4), jb(4), ic(4), jc(6), ierr

   cmat = cmplx(0.0, 0.0)
   cmat(1, 1) = cmplx(1.0, 2.0)
   cmat(2, 2) = cmplx(-3.0, 4.0)
   cmat(3, 1) = cmplx(5.0, 0.0)
   call cvcs(cmat, 3, 3, 2, cs, ia, ja, 4, ierr)
   if (ierr /= 0) error stop 'legacy CVCS status'
   call cvsc(cs, ia, ja, cback, 3, 3, 2)
   if (maxval(abs(cback - cmat)) > 2.0e-6) error stop 'legacy CVSC roundtrip'

   call csreal(cs, ia, ja, part, ib, jb, 3)
   if (any(ib /= [1, 2, 3, 4])) error stop 'legacy CSREAL pointers'
   if (maxval(abs(part(1:3) - [1.0, -3.0, 5.0])) > 2.0e-6) error stop 'legacy CSREAL values'
   call csimag(cs, ia, ja, part, ib, jb, 3)
   if (any(ib /= [1, 2, 3, 3])) error stop 'legacy CSIMAG pointers'
   if (maxval(abs(part(1:2) - [2.0, 4.0])) > 2.0e-6) error stop 'legacy CSIMAG values'
   call sconj(cs, ia, ja, cb, ib, jb, 3)
   if (maxval(abs(cb(1:3) - conjg(cs(1:3)))) > 2.0e-6) error stop 'legacy SCONJ values'

   rmat = reshape([1.0, 0.0, -2.0, 0.0, 3.0, 0.0], shape(rmat))
   call cvrs(rmat, 3, 3, 2, rs, ia, ja, 4, ierr)
   if (ierr /= 0) error stop 'legacy CVRS status'
   call cvsr(rs, ia, ja, rback, 3, 3, 2)
   if (maxval(abs(rback - rmat)) > 2.0e-6) error stop 'legacy CVSR roundtrip'

   dmat = real(rmat, dp)
   dmat(2, 2) = 1.0_dp + 4.0e-14_dp
   call cvds(dmat, 3, 3, 2, ds, ia, ja, 4, ierr)
   if (ierr /= 0) error stop 'legacy CVDS status'
   call cvsd(ds, ia, ja, dback, 3, 3, 2)
   if (maxval(abs(dback - dmat)) > 5.0e-13_dp) error stop 'legacy CVSD roundtrip'


   call scvrd(rs, ia, ja, dconv, ib, jb, 3)
   if (any(ib /= ia)) error stop 'legacy SCVRD pointers'
   if (maxval(abs(dconv(1:3) - real(rs(1:3), dp))) > 5.0e-13_dp) error stop 'legacy SCVRD values'
   call scvdr(dconv, ib, jb, rconv, ic, jc, 3)
   if (any(ic /= ia)) error stop 'legacy SCVDR pointers'
   if (maxval(abs(rconv(1:3) - rs(1:3))) > 2.0e-6) error stop 'legacy SCVDR values'

   imag_s = 0.0
   imag_s(1:2) = [2.0, -4.0]
   wk = 0.0
   call scvrc(rs, ia, ja, imag_s, ia, ja, joined, ic, jc, 3, 2, 6, wk, ierr)
   if (ierr /= 0) error stop 'legacy SCVRC status'
   if (any(ic /= ia)) error stop 'legacy SCVRC pointers'
   if (maxval(abs(joined(1:3) - cmplx(rs(1:3), imag_s(1:3)))) > 2.0e-6) error stop 'legacy SCVRC values'

   print '(a,3es25.16)', 'Converted double entries: ',dconv(1:3)
   print '(a,6es25.16)', 'Joined complex entries: ',joined(1:3)
   print *, 'test_sparse_conversions: PASS'
end program test_sparse_conversions
