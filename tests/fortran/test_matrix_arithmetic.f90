! Adapted and extended from test_symmetric_packed_utils_legacy.f90
! in the amiller-nswc test suite. Link one NSWC source version at a time.
program test_matrix_arithmetic
   use, intrinsic :: iso_fortran_env, only : dp => real64
   implicit none
   real :: a(2,3),b(2,3),r(2,3),right(3,2),product(2,2)
   real :: sym(3,3),full(3,3),packed(6),other(6),result(6)
   real :: small(2,2),kron(4,6),expected(4,6)
   real(dp) :: da(2,3),db(2,3),dr(2,3),dfull(3,3),dpacked(6)
   real(dp) :: dproduct(2,2),dkron(4,6)
   complex :: ca(2,3),cb(2,3),cr(2,3),cproduct(2,2),ckron(4,6),cexpected(4,6)
   integer :: i,j
   interface
      subroutine mcvfs(a,ka,n,b)
         import dp
         integer :: ka,n
         real :: a(ka,n),b(*)
      end subroutine mcvfs
      subroutine dmcvfs(a,ka,n,b)
         import dp
         integer :: ka,n
         real(dp) :: a(ka,n),b(*)
      end subroutine dmcvfs
      subroutine mcvsf(a,ka,n,b)
         import dp
         integer :: ka,n
         real :: a(ka,n),b(*)
      end subroutine mcvsf
      subroutine dmcvsf(a,ka,n,b)
         import dp
         integer :: ka,n
         real(dp) :: a(ka,n),b(*)
      end subroutine dmcvsf
      subroutine mcopy(m,n,a,ka,b,kb)
         import dp
         integer :: m,n,ka,kb
         real :: a(ka,n),b(kb,n)
      end subroutine mcopy
      subroutine dmcopy(m,n,a,ka,b,kb)
         import dp
         integer :: m,n,ka,kb
         real(dp) :: a(ka,n),b(kb,n)
      end subroutine dmcopy
      subroutine cmcopy(m,n,a,ka,b,kb)
         import dp
         integer :: m,n,ka,kb
         complex :: a(ka,n),b(kb,n)
      end subroutine cmcopy
      subroutine cmconj(m,n,a,ka,b,kb)
         import dp
         integer :: m,n,ka,kb
         complex :: a(ka,n),b(kb,n)
      end subroutine cmconj
      subroutine smcopy(n,a,b)
         integer :: n
         real :: a(*),b(*)
      end subroutine smcopy
      subroutine smadd(n,a,b,c)
         integer :: n
         real :: a(*),b(*),c(*)
      end subroutine smadd
      subroutine smsubt(n,a,b,c)
         integer :: n
         real :: a(*),b(*),c(*)
      end subroutine smsubt
      subroutine dmadd(m,n,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,ka,kb,kc
         real(dp) :: a(ka,n),b(kb,n),c(kc,n)
      end subroutine dmadd
      subroutine cmadd(m,n,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,ka,kb,kc
         complex :: a(ka,n),b(kb,n),c(kc,n)
      end subroutine cmadd
      subroutine msubt(m,n,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,ka,kb,kc
         real :: a(ka,n),b(kb,n),c(kc,n)
      end subroutine msubt
      subroutine dmsubt(m,n,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,ka,kb,kc
         real(dp) :: a(ka,n),b(kb,n),c(kc,n)
      end subroutine dmsubt
      subroutine cmsubt(m,n,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,ka,kb,kc
         complex :: a(ka,n),b(kb,n),c(kc,n)
      end subroutine cmsubt
      subroutine mtms(m,n,l,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,l,ka,kb,kc
         real :: a(ka,n),b(kb,l),c(kc,l)
      end subroutine mtms
      subroutine dmtms(m,n,l,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,l,ka,kb,kc
         real(dp) :: a(ka,n),b(kb,l),c(kc,l)
      end subroutine dmtms
      subroutine cmtms(m,n,l,a,ka,b,kb,c,kc)
         import dp
         integer :: m,n,l,ka,kb,kc
         complex :: a(ka,n),b(kb,l),c(kc,l)
      end subroutine cmtms
      subroutine kprod(a,ka,m,n,b,kb,k,l,c,kc)
         import dp
         integer :: ka,m,n,kb,k,l,kc
         real :: a(ka,n),b(kb,l),c(kc,*)
      end subroutine kprod
      subroutine dkprod(a,ka,m,n,b,kb,k,l,c,kc)
         import dp
         integer :: ka,m,n,kb,k,l,kc
         real(dp) :: a(ka,n),b(kb,l),c(kc,*)
      end subroutine dkprod
      subroutine ckprod(a,ka,m,n,b,kb,k,l,c,kc)
         import dp
         integer :: ka,m,n,kb,k,l,kc
         complex :: a(ka,n),b(kb,l),c(kc,*)
      end subroutine ckprod
   end interface

   a=reshape([1.,-2.,3.,4.,-5.,6.],shape(a))
   b=0.25*a+1.0
   da=real(a,dp); db=real(b,dp)
   ca=cmplx(a,0.5*a); cb=cmplx(b,-b)
   call mcopy(2,3,a,2,r,2)
   call require(maxval(abs(r-a))<1e-6,'MCOPY')
   call dmcopy(2,3,da,2,dr,2)
   call require(maxval(abs(dr-da))<1e-13_dp,'DMCOPY')
   call cmcopy(2,3,ca,2,cr,2)
   call require(maxval(abs(cr-ca))<1e-6,'CMCOPY')
   call cmconj(2,3,ca,2,cr,2)
   call require(maxval(abs(cr-conjg(ca)))<1e-6,'CMCONJ')

   call dmadd(2,3,da,2,db,2,dr,2)
   call require(maxval(abs(dr-(da+db)))<1e-13_dp,'DMADD')
   call cmadd(2,3,ca,2,cb,2,cr,2)
   call require(maxval(abs(cr-(ca+cb)))<1e-6,'CMADD')
   call msubt(2,3,a,2,b,2,r,2)
   call require(maxval(abs(r-(a-b)))<1e-6,'MSUBT')
   call dmsubt(2,3,da,2,db,2,dr,2)
   call require(maxval(abs(dr-(da-db)))<1e-13_dp,'DMSUBT')
   call cmsubt(2,3,ca,2,cb,2,cr,2)
   call require(maxval(abs(cr-(ca-cb)))<1e-6,'CMSUBT')

   packed=[1.,2.,3.,4.,5.,6.]
   other=[-1.,1.,2.,-2.,3.,4.]
   sym=reshape([1.,2.,4.,2.,3.,5.,4.,5.,6.],shape(sym))
   call mcvfs(sym,3,3,result)
   call require(maxval(abs(result-packed))<1e-6,'MCVFS')
   call mcvsf(full,3,3,packed)
   call require(maxval(abs(full-sym))<1e-6,'MCVSF')
   call dmcvfs(real(sym,dp),3,3,dpacked)
   call require(maxval(abs(dpacked-real(packed,dp)))<1e-13_dp,'DMCVFS')
   call dmcvsf(dfull,3,3,dpacked)
   call require(maxval(abs(dfull-real(sym,dp)))<1e-13_dp,'DMCVSF')
   call smcopy(3,packed,result)
   call require(maxval(abs(result-packed))<1e-6,'SMCOPY')
   call smadd(3,packed,other,result)
   call require(maxval(abs(result-(packed+other)))<1e-6,'SMADD')
   call smsubt(3,packed,other,result)
   call require(maxval(abs(result-(packed-other)))<1e-6,'SMSUBT')

   right=transpose(b)
   call mtms(2,3,2,a,2,right,3,product,2)
   call require(maxval(abs(product-matmul(a,right)))<1e-5,'MTMS')
   call dmtms(2,3,2,da,2,real(right,dp),3,dproduct,2)
   call require(maxval(abs(dproduct-matmul(da,real(right,dp))))<1e-13_dp,'DMTMS')
   call cmtms(2,3,2,ca,2,transpose(cb),3,cproduct,2)
   call require(maxval(abs(cproduct-matmul(ca,transpose(cb))))<1e-5,'CMTMS')

   small=reshape([1.,-2.,3.,0.5],shape(small))
   do j=1,3
      do i=1,2
         expected(2*i-1:2*i,2*j-1:2*j)=a(i,j)*small
         cexpected(2*i-1:2*i,2*j-1:2*j)=ca(i,j)*cmplx(small,-small)
      end do
   end do
   call kprod(a,2,2,3,small,2,2,2,kron,4)
   call require(maxval(abs(kron-expected))<1e-6,'KPROD')
   call dkprod(da,2,2,3,real(small,dp),2,2,2,dkron,4)
   call require(maxval(abs(dkron-real(expected,dp)))<1e-13_dp,'DKPROD')
   call ckprod(ca,2,2,3,cmplx(small,-small),2,2,2,ckron,4)
   call require(maxval(abs(ckron-cexpected))<1e-6,'CKPROD')

   print '(a,4es25.16)', 'Real matrix product: ',product
   print '(a,4es25.16)', 'Double matrix product: ',dproduct
   print '(a,8es25.16)', 'Complex matrix product: ',cproduct
   print '(a)', 'test_matrix_arithmetic: PASS'
contains
   subroutine require(ok,label)
      logical, intent(in) :: ok
      character(*), intent(in) :: label
      if (.not.ok) then
         print *, 'FAIL: ',label
         error stop 1
      end if
   end subroutine require
end program test_matrix_arithmetic
