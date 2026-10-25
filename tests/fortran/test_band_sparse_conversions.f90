! Adapted from test_band_sparse_conversions_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_band_sparse_conversions
   implicit none
   integer, parameter :: m=4, n=5, nb=4, num=12
   real :: band(m,nb), band2(m,nb), val(num)
   complex :: cband(m,nb), cband2(m,nb), cval(num)
   integer :: ia(m+1), ja(num), ml, mu, ierr
   real :: sym(3,3), sym2(3,3), pack(6)

   interface
      subroutine mcvfs(a,ka,n,b)
         integer, intent(in) :: ka,n
         real, intent(in) :: a(ka,n)
         real, intent(out) :: b(*)
      end subroutine mcvfs
      subroutine mcvsf(a,ka,n,b)
         integer, intent(in) :: ka,n
         real, intent(out) :: a(ka,n)
         real, intent(in) :: b(*)
      end subroutine mcvsf
      subroutine mcvbs(a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
         integer, intent(in) :: ka,m,n,ml,mu,num
         real, intent(in) :: a(ka,*)
         real, intent(out) :: b(*)
         integer, intent(out) :: ib(*),jb(*),ierr
      end subroutine mcvbs
      subroutine mcvsb(a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
         real, intent(in) :: a(*)
         integer, intent(in) :: ia(*),ja(*),m,n,kb,nb
         real, intent(out) :: b(kb,nb)
         integer, intent(out) :: ml,mu,ierr
      end subroutine mcvsb
      subroutine cmcvbs(a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
         integer, intent(in) :: ka,m,n,ml,mu,num
         complex, intent(in) :: a(ka,*)
         complex, intent(out) :: b(*)
         integer, intent(out) :: ib(*),jb(*),ierr
      end subroutine cmcvbs
      subroutine cmcvsb(a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
         complex, intent(in) :: a(*)
         integer, intent(in) :: ia(*),ja(*),m,n,kb,nb
         complex, intent(out) :: b(kb,nb)
         integer, intent(out) :: ml,mu,ierr
      end subroutine cmcvsb
   end interface

   band2 = 0.0; cband2 = cmplx(0.0,0.0)
   band = 0.0
   band(1,:) = [0.,1.,2.,3.]
   band(2,:) = [4.,5.,0.,6.]
   band(3,:) = [7.,8.,0.,9.]
   band(4,:) = [10.,11.,0.,0.]
   call mcvbs(band,m,m,n,1,2,val,ia,ja,num,ierr)
   if (ierr /= 0) error stop 'legacy MCVBS status'
   call mcvsb(val,ia,ja,m,n,band2,m,nb,ml,mu,ierr)
   if (ierr /= 0 .or. ml /= 1 .or. mu /= 2) error stop 'legacy MCVSB status'
   if (maxval(abs(band2-band)) > 1.0e-6) error stop 'legacy real round trip'

   cband = cmplx(band,0.5*band)
   call cmcvbs(cband,m,m,n,1,2,cval,ia,ja,num,ierr)
   if (ierr /= 0) error stop 'legacy CMCVBS status'
   call cmcvsb(cval,ia,ja,m,n,cband2,m,nb,ml,mu,ierr)
   if (ierr /= 0 .or. ml /= 1 .or. mu /= 2) error stop 'legacy CMCVSB status'
   if (maxval(abs(cband2-cband)) > 2.0e-6) error stop 'legacy complex round trip'

   sym = reshape([1.,2.,3.,2.,4.,5.,3.,5.,6.],[3,3])
   call mcvfs(sym,3,3,pack)
   if (maxval(abs(pack-[1.,2.,4.,3.,5.,6.])) > 1.0e-6) error stop 'legacy MCVFS'
   call mcvsf(sym2,3,3,pack)
   if (maxval(abs(sym2-sym)) > 1.0e-6) error stop 'legacy MCVSF'

   print '(a,4es25.16)', 'Reconstructed real band row: ',band2(2,:)
   print '(a,8es25.16)', 'Reconstructed complex band row: ',cband2(2,:)
   print '(a)', 'test_band_sparse_conversions: PASS'
end program test_band_sparse_conversions
