! Adapted from C:/fortran/amiller-nswc/test/test_dense_matrix_utils_legacy.f90
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_dense_matrix_utils
   use, intrinsic :: iso_fortran_env, only : dp => real64
   implicit none
   integer, parameter :: m=2, n=3, l=2
   real :: a(m,n), b(n,l), c(m,l), r(m,n), ri(m,n), rt(n,m), work(m)
   real(dp) :: da(m,n), db(n,l), dc(m,l), dr(m,n), dt(n,m), dwork(m)
   complex :: ca(m,n), cb(n,l), cc(m,l), cz(m,n), ct(n,m), cadj(n,m), cwork(m)
   complex :: square(n,n), sref(n,n)
   integer :: i
   interface
      subroutine madd(m,n,a,ka,b,kb,c,kc)
         integer, intent(in) :: m,n,ka,kb,kc
         real, intent(in) :: a(ka,n), b(kb,n)
         real, intent(out) :: c(kc,n)
      end subroutine madd
      subroutine tpose(m,n,a,ka,b,kb)
         integer, intent(in) :: m,n,ka,kb
         real, intent(in) :: a(ka,n)
         real, intent(out) :: b(kb,m)
      end subroutine tpose
      subroutine mprod(m,n,l,a,ka,b,kb,c,kc,row)
         integer, intent(in) :: m,n,l,ka,kb,kc
         real, intent(in) :: a(ka,n), b(kb,l)
         real, intent(out) :: c(kc,l)
         real, intent(inout) :: row(*)
      end subroutine mprod
      subroutine dmprod(m,n,l,a,ka,b,kb,c,kc,row)
         use, intrinsic :: iso_fortran_env, only : dp => real64
         integer, intent(in) :: m,n,l,ka,kb,kc
         real(dp), intent(in) :: a(ka,n), b(kb,l)
         real(dp), intent(out) :: c(kc,l)
         real(dp), intent(inout) :: row(*)
      end subroutine dmprod
      subroutine dtpose(m,n,a,ka,b,kb)
         use, intrinsic :: iso_fortran_env, only : dp => real64
         integer, intent(in) :: m,n,ka,kb
         real(dp), intent(in) :: a(ka,n)
         real(dp), intent(out) :: b(kb,m)
      end subroutine dtpose
      subroutine cmprod(m,n,l,a,ka,b,kb,c,kc,row)
         integer, intent(in) :: m,n,l,ka,kb,kc
         complex, intent(in) :: a(ka,n), b(kb,l)
         complex, intent(out) :: c(kc,l)
         complex, intent(inout) :: row(*)
      end subroutine cmprod
      subroutine ctpose(m,n,a,ka,b,kb)
         integer, intent(in) :: m,n,ka,kb
         complex, intent(in) :: a(ka,n)
         complex, intent(out) :: b(kb,m)
      end subroutine ctpose
      subroutine cmadj(m,n,a,ka,b,kb)
         integer, intent(in) :: m,n,ka,kb
         complex, intent(in) :: a(ka,n)
         complex, intent(out) :: b(kb,m)
      end subroutine cmadj
      subroutine ctrans(nm,n,a)
         integer, intent(in) :: nm,n
         complex, intent(inout) :: a(nm,n)
      end subroutine ctrans
      subroutine cmreal(m,n,a,ka,b,kb)
         integer, intent(in) :: m,n,ka,kb
         complex, intent(in) :: a(ka,n)
         real, intent(out) :: b(kb,n)
      end subroutine cmreal
      subroutine cmimag(m,n,a,ka,b,kb)
         integer, intent(in) :: m,n,ka,kb
         complex, intent(in) :: a(ka,n)
         real, intent(out) :: b(kb,n)
      end subroutine cmimag
      subroutine mcvrc(m,n,a,ka,b,kb)
         integer, intent(in) :: m,n,ka,kb
         real, intent(in) :: a(ka,n)
         complex, intent(out) :: b(kb,n)
      end subroutine mcvrc
      subroutine mcvrd(m,n,a,ka,b,kb)
         use, intrinsic :: iso_fortran_env, only : dp => real64
         integer, intent(in) :: m,n,ka,kb
         real, intent(in) :: a(ka,n)
         real(dp), intent(out) :: b(kb,n)
      end subroutine mcvrd
      subroutine mcvdr(m,n,a,ka,b,kb)
         use, intrinsic :: iso_fortran_env, only : dp => real64
         integer, intent(in) :: m,n,ka,kb
         real(dp), intent(in) :: a(ka,n)
         real, intent(out) :: b(kb,n)
      end subroutine mcvdr
   end interface

   a = reshape([1.0,4.0,2.0,5.0,3.0,6.0],shape(a))
   b = reshape([0.5,1.5,-1.0,2.0,0.25,-0.75],shape(b))
   call madd(m,n,a,m,a,m,r,m)
   if (maxval(abs(r-2.0*a)) > 1.0e-6) error stop 'legacy MADD'
   call tpose(m,n,a,m,rt,n)
   if (maxval(abs(rt-transpose(a))) > 1.0e-6) error stop 'legacy TPOSE'
   c = 0.0
   work = 0.0
   call mprod(m,n,l,a,m,b,n,c,m,work)
   if (maxval(abs(c-matmul(a,b))) > 2.0e-6) error stop 'legacy MPROD'

   da = real(a,dp)
   db = real(b,dp)
   dc = 0.0_dp
   dwork = 0.0_dp
   call dmprod(m,n,l,da,m,db,n,dc,m,dwork)
   if (maxval(abs(dc-matmul(da,db))) > 1.0e-13_dp) error stop 'legacy DMPROD'
   call dtpose(m,n,da,m,dt,n)
   if (maxval(abs(dt-transpose(da))) > 1.0e-13_dp) error stop 'legacy DTPOSE'

   ca = cmplx(a,0.1*a)
   cb = cmplx(b,-0.2*b)
   cc = cmplx(0.0,0.0)
   cwork = cmplx(0.0,0.0)
   call cmprod(m,n,l,ca,m,cb,n,cc,m,cwork)
   if (maxval(abs(cc-matmul(ca,cb))) > 4.0e-6) error stop 'legacy CMPROD'
   call ctpose(m,n,ca,m,ct,n)
   if (maxval(abs(ct-transpose(ca))) > 2.0e-6) error stop 'legacy CTPOSE'
   call cmadj(m,n,ca,m,cadj,n)
   if (maxval(abs(cadj-transpose(conjg(ca)))) > 2.0e-6) error stop 'legacy CMADJ'

   square = reshape([(cmplx(real(i),-0.1*real(i)),i=1,n*n)],shape(square))
   sref = square
   call ctrans(n,n,square)
   if (maxval(abs(square-transpose(conjg(sref)))) > 2.0e-6) error stop 'legacy CTRANS'

   call cmreal(m,n,ca,m,r,m)
   call cmimag(m,n,ca,m,ri,m)
   if (maxval(abs(r-real(ca))) > 1.0e-6) error stop 'legacy CMREAL'
   if (maxval(abs(ri-aimag(ca))) > 1.0e-6) error stop 'legacy CMIMAG'
   call mcvrc(m,n,a,m,cz,m)
   if (maxval(abs(cz-cmplx(a,0.0))) > 1.0e-6) error stop 'legacy MCVRC'
   call mcvrd(m,n,a,m,dr,m)
   if (maxval(abs(dr-real(a,dp))) > 1.0e-13_dp) error stop 'legacy MCVRD'
   call mcvdr(m,n,dr,m,r,m)
   if (maxval(abs(r-a)) > 1.0e-6) error stop 'legacy MCVDR'

   print '(a,4es25.16)', 'Real matrix product: ',c
   print '(a,4es25.16)', 'Double matrix product: ',dc
   print '(a,8es25.16)', 'Complex matrix product: ',cc
   print '(a)', 'test_dense_matrix_utils: PASS'
end program test_dense_matrix_utils
