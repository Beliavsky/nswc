subroutine mvprd(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin MVPRD -->
!! Reference for `mvprd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Product of a sparse matrix and a vector
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
real :: sum
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
do i = 1,m
   sum = 0.0
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine mvprd

subroutine mvprd1(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin MVPRD1 -->
!! Reference for `mvprd1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set y = a*x + y where A is a sparse matrix and x,y are vectors
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
real :: sum
!-----------------------------------------------------------------------
!     Set y = a*x + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine mvprd1

subroutine mtprd(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin MTPRD -->
!! Reference for `mtprd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Product of a vector and a sparse matrix
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(m)
real, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
real :: t
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
do j = 1,n
   y(j) = 0.0
end do
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
end do
end subroutine mtprd

subroutine mtprd1(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin MTPRD1 -->
!! Reference for `mtprd1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set y = x*a + y where A is a sparse matrix and x,y are vectors
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(m)
real, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
real :: t
!-----------------------------------------------------------------------
!     Set y = x*a + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
end do
end subroutine mtprd1

subroutine dvprd(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin DVPRD -->
!! Reference for `dvprd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Product of a sparse matrix and a vector
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
double precision :: sum
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
do i = 1,m
   sum = 0.d0
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine dvprd

subroutine dvprd1(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin DVPRD1 -->
!! Reference for `dvprd1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set y = a*x + y where A is a sparse matrix and x,y are vectors
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
double precision :: sum
!-----------------------------------------------------------------------
!     Set y = a*x + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine dvprd1

subroutine dtprd(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin DTPRD -->
!! Reference for `dtprd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Product of a vector and a sparse matrix
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(m)
double precision, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
double precision :: t
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
do j = 1,n
   y(j) = 0.d0
end do
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
end do
end subroutine dtprd

subroutine dtprd1(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin DTPRD1 -->
!! Reference for `dtprd1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set y = x*a + y where A is a sparse matrix and x,y are vectors
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(m)
double precision, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
double precision :: t
!-----------------------------------------------------------------------
!     Set y = x*a + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
end do
end subroutine dtprd1

subroutine cvprd(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin CVPRD -->
!! Reference for `cvprd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Product of a sparse matrix and a vector
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(n)
complex, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
complex :: sum
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
do i = 1,m
   sum = (0.0, 0.0)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine cvprd

subroutine cvprd1(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin CVPRD1 -->
!! Reference for `cvprd1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set y = a*x + y where A is a sparse matrix and x,y are vectors
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(n)
complex, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
complex :: sum
!-----------------------------------------------------------------------
!     Set y = a*x + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine cvprd1

subroutine ctprd(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin CTPRD -->
!! Reference for `ctprd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Product of a vector and a sparse matrix
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(m)
complex, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
complex :: t
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
do j = 1,n
   y(j) = (0.0, 0.0)
end do
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
end do
end subroutine ctprd

subroutine ctprd1(m, n, a, ia, ja, x, y)
!! <!-- nswc-ford:begin CTPRD1 -->
!! Reference for `ctprd1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set y = x*a + y where A is a sparse matrix and x,y are vectors
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(m)
complex, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, j, l, lmax, lmin
complex :: t
!-----------------------------------------------------------------------
!     Set y = x*a + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
end do
end subroutine ctprd1

real function snrm(a, ia, ja, m, n)
!! <!-- nswc-ford:begin SNRM -->
!! Reference for `snrm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Computation of the L-infinity norm of A
!!                       real sparse matrix a
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, ip, ipmax, ipmin
real :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                      real sparse matrix a
!-----------------------------------------------------------------------
snrm = 0.0
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 20
   sum = 0.0
   do ip = ipmin,ipmax
      sum = sum + abs(a(ip))
   end do
   snrm = max(snrm, sum)
20 continue
end do
end function snrm

subroutine s1nrm(a, ia, ja, m, n, anorm, wk)
!! <!-- nswc-ford:begin S1NRM -->
!! Reference for `s1nrm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Computation of the L1 norm of a real sparse matrix a
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
real, intent(out) :: anorm
real, intent(in) :: a(*)
real, intent(inout) :: wk(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: ip, ipmax, ipmin, j
!-----------------------------------------------------------------------
!        Computation of the L1 norm of a real sparse matrix a
!-----------------------------------------------------------------------
anorm = 0.0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) return
!     Compute the L1 norm of A
do j = 1,n
   wk(j) = 0.0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + abs(a(ip))
end do
do j = 1,n
   anorm = max(anorm,wk(j))
end do
end subroutine s1nrm

double precision function dsnrm(a, ia, ja, m, n)
!! <!-- nswc-ford:begin DSNRM -->
!! Reference for `dsnrm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Computation of the L-infinity norm of A
!!                 double precision sparse matrix a
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: i, ip, ipmax, ipmin
double precision :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                double precision sparse matrix a
!-----------------------------------------------------------------------
dsnrm = 0.d0
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 20
   sum = 0.d0
   do ip = ipmin,ipmax
      sum = sum + abs(a(ip))
   end do
   dsnrm = max(dsnrm, sum)
20 continue
end do
end function dsnrm

subroutine ds1nrm(a, ia, ja, m, n, anorm, wk)
!! <!-- nswc-ford:begin DS1NRM -->
!! Reference for `ds1nrm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                Computation of the L1 norm of a sparse
!!                      double precision matrix a
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*)
double precision, intent(out) :: anorm
double precision, intent(inout) :: wk(n)
integer, intent(in) :: ia(*), ja(*)
!     beginning of local variable declarations
integer :: ip, ipmax, ipmin, j
!-----------------------------------------------------------------------
!               Computation of the L1 norm of a sparse
!                     double precision matrix a
!-----------------------------------------------------------------------
anorm = 0.d0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) return
!     Compute the L1 norm of A
do j = 1,n
   wk(j) = 0.d0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + abs(a(ip))
end do
do j = 1,n
   anorm = max(anorm,wk(j))
end do
end subroutine ds1nrm

subroutine spord(m, n, ia, r, iwk)
!! <!-- nswc-ford:begin SPORD -->
!! Reference for `spord`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         spord orders the rows of an MXN sparse matrix A,ia,ja
!!         by increasing length. The row ordering is given in r.
!!
!!      iwk is a work space of dimension m + n + 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: ia(*)
integer, intent(inout) :: r(m), iwk(*)
!     beginning of local variable declarations
integer :: i, ii, k, l, np1, num
!-----------------------------------------------------------------------
!        spord orders the rows of an MXN sparse matrix A,ia,ja
!        by increasing length. The row ordering is given in r.
!-----------------------------------------------------------------------
!     iwk is a work space of dimension m + n + 1.
!----------------------
np1 = n + 1
do i = 1,np1
   iwk(i) = 0
end do
i = m
do ii = 1,m
   num = ia(i + 1) - ia(i) + 1
   l = np1 + i
   iwk(l) = iwk(num)
   iwk(num) = i
   i = i - 1
end do
num = 1
k = iwk(num)
do i = 1,m
30 if (k /= 0) go to 31
   num = num + 1
   k = iwk(num)
   go to 30
31 r(i) = k
   l = np1 + k
   k = iwk(l)
end do
end subroutine spord

subroutine blkord(n, ia, ja, r, c, ib, num, iwk, ierr)
!! <!-- nswc-ford:begin BLKORD -->
!! Reference for `blkord`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Reordering a sparse matrix into block triangular form
!!
!!      integer iwk(5*n)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer :: n
integer, intent(inout) :: num
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: r(n), c(n), ib(n)
integer, intent(inout) :: iwk(*)
!     beginning of local variable declarations
integer :: i, length, li, np1, npi
!-----------------------------------------------------------------------
!        Reordering a sparse matrix into block triangular form
!-----------------------------------------------------------------------
!     integer iwk(5*n)
np1 = n + 1
length = ia(np1) - ia(1)
do i = 1,n
   iwk(i) = ia(i + 1) - ia(i)
end do
call mc21a(n,ja,length,ia,iwk(1),r,num,iwk(np1))
ierr = n - num
if (ierr /= 0) return
do i = 1,n
   li = r(i)
   iwk(i) = ia(li)
   npi = n + i
   iwk(npi) = ia(li + 1) - ia(li)
end do
call mc13d(n,ja,length,iwk(1),iwk(np1),c,ib,num,iwk(2*n + 1))
do i = 1,n
   li = c(i)
   iwk(i) = r(li)
end do
do i = 1,n
   r(i) = iwk(i)
end do
end subroutine blkord

pure subroutine mc21a(n,icn,licn,ip,lenr,iperm,numnz,iw)
!! <!-- nswc-ford:begin MC21A -->
!! Reference for `mc21a`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Description of parameters.
!!  INPUT VARIABLES   n,icn,licn,ip,lenr
!!  output variables  iperm,numnz
!!  n   ORDER OF MATRIX.
!!  icn array containing the column indices of the non-zeros.  Those
!!      belonging to a single row must be contiguous but the ordering
!!      of column indices within each row is unimportant and wasted
!!      space between rows is permitted.
!!  licn  length of array icn.
!!  ip  ip(I), I=1,2,...n, is the position in array icn of the first
!!      column index of a non-zero in row I.
!!  lenr  lenr(I) is the number of non-zeros in row I, I=1,2,..N.
!!  iperm contains permutation to make diagonal have the smallest
!!      number of zeros on it.  Elements (iperm(I),I) I=1, ... n are
!!      non-zero at the end of the algorithm unless matrix
!!      is structurally singular.  In this case, (iperm(I),I) will
!!      be zero for n-numnz entries.
!!  numnz number of non-zeros on diagonal of permuted matrix.
!!  iw  work array  ..  see later comments.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: numnz
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), iw(n,4)
interface
   pure subroutine mc21b(n,icn,licn,ip,lenr,iperm,numnz,pr,arp, &
      & cv,out)
      implicit none
      integer, intent(in) :: licn
      integer, intent(in) :: n
      integer, intent(in) :: icn(licn)
      integer, intent(in) :: ip(n)
      integer, intent(in) :: lenr(n)
      integer, intent(inout) :: iperm(n)
      integer, intent(inout) :: numnz
      integer, intent(inout) :: pr(n)
      integer, intent(inout) :: arp(n)
      integer, intent(inout) :: cv(n)
      integer, intent(inout) :: out(n)
   end subroutine mc21b
end interface
!-----------------------------------------------------------------------
! Description of parameters.
! INPUT VARIABLES   n,icn,licn,ip,lenr
! output variables  iperm,numnz
! n   ORDER OF MATRIX.
! icn array containing the column indices of the non-zeros.  Those
!     belonging to a single row must be contiguous but the ordering
!     of column indices within each row is unimportant and wasted
!     space between rows is permitted.
! licn  length of array icn.
! ip  ip(I), I=1,2,...n, is the position in array icn of the first
!     column index of a non-zero in row I.
! lenr  lenr(I) is the number of non-zeros in row I, I=1,2,..N.
! iperm contains permutation to make diagonal have the smallest
!     number of zeros on it.  Elements (iperm(I),I) I=1, ... n are
!     non-zero at the end of the algorithm unless matrix
!     is structurally singular.  In this case, (iperm(I),I) will
!     be zero for n-numnz entries.
! numnz number of non-zeros on diagonal of permuted matrix.
! iw  work array  ..  see later comments.
!-----------------------------------------------------------------------
call mc21b(n,icn,licn,ip,lenr,iperm,numnz,iw(1,1),iw(1,2), &
   & iw(1,3),iw(1,4))
end subroutine mc21a

pure subroutine mc21b(n,icn,licn,ip,lenr,iperm,numnz,pr,arp,cv,out)
!! <!-- nswc-ford:begin MC21B -->
!! Reference for `mc21b`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Division of work array is now described.
!!  pr(i) is the previous row to i in the depth first search.
!!  arp(i) is one less than the number of non-zeros in row i
!!      which have not been scanned when looking for a cheap assignment.
!!  cv(i) is the most recent row extension at which column i
!!      was visited.
!!  out(i) is one less than the number of non-zeros in row i
!!      which have not been scanned during one pass through the
!!      main loop.
!!
!!      Initialization of arrays
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: numnz
integer, intent(in) :: ip(n), icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), pr(n), cv(n), arp(n), out(n)
!     beginning of local variable declarations
integer :: i, ii, in1, in2, ioutk, j, j1, jord, k, kk
!-----------------------------------------------------------------------
!     Division of work array is now described.
! pr(i) is the previous row to i in the depth first search.
! arp(i) is one less than the number of non-zeros in row i
!     which have not been scanned when looking for a cheap assignment.
! cv(i) is the most recent row extension at which column i
!     was visited.
! out(i) is one less than the number of non-zeros in row i
!     which have not been scanned during one pass through the
!     main loop.
!-----------------------------------------------------------------------
!     Initialization of arrays
do i = 1,n
   arp(i) = lenr(i) - 1
   cv(i) = 0
   iperm(i) = 0
end do
numnz = 0
!     Main loop.
!     Each pass round this loop either results in a new assignment
!     or gives a row with no assignment.
do jord = 1,n
   j = jord
   pr(j) = -1
   nswc_exit_1 : do k = 1 , jord
!     Look for a cheap assignment
      in1 = arp(j)
      if (in1 < 0) go to 60
      in2 = ip(j) + lenr(j) - 1
      in1 = in2 - in1
      do ii = in1,in2
         i = icn(ii)
         if (iperm(i) == 0) exit nswc_exit_1
      end do
!     No cheap assignment in row
      arp(j) = -1
!     Begin looking for assignment chain starting with row j
60    out(j) = lenr(j) - 1
!     Inner loop.  Extends chain by one or backtracks.
      nswc_exit_2 : do kk = 1 , jord
         in1 = out(j)
         if (in1 < 0) go to 80
         in2 = ip(j) + lenr(j) - 1
         in1 = in2 - in1
!        Forward scan
         do ii = in1,in2
            i = icn(ii)
            if (cv(i) == jord) go to 70
!           Column i has not yet been accessed during this pass
            j1 = j
            j = iperm(i)
            cv(i) = jord
            pr(j) = j1
            out(j1) = in2 - ii - 1
            exit nswc_exit_2
70          continue
         end do
!        Backtracking step
80       j = pr(j)
         if (j == -1) go to 130
      end do nswc_exit_2
   end do nswc_exit_1
!     New assignment is made
   iperm(i) = j
   arp(j) = in2 - ii - 1
   numnz = numnz + 1
   do k = 1,jord
      j = pr(j)
      if (j == - 1) exit
      ii = ip(j) + lenr(j) - out(j) - 2
      i = icn(ii)
      iperm(i) = j
   end do
130 continue
end do
!     If matrix is structurally singular, we now complete the
!     permutation iperm.
if (numnz == n) go to 500
do i = 1,n
   arp(i) = 0
end do
k = 0
do i = 1,n
   if (iperm(i) /= 0) go to 150
   k = k + 1
   out(k) = i
   go to 160
150 j = iperm(i)
   arp(j) = i
160 continue
end do
k = 0
do i = 1,n
   if (arp(i) /= 0) go to 170
   k = k + 1
   ioutk = out(k)
   iperm(ioutk) = i
170 continue
end do
500 return
end subroutine mc21b

pure subroutine mc13d(n, icn, licn, ip, lenr, ior, ib, num, iw)
!! <!-- nswc-ford:begin MC13D -->
!! Reference for `mc13d`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Description of parameters.
!!  Input variables  .... n,icn,licn,ip,lenr.
!!  Output variables  ior,ib,num.
!!  n   ORDER OF THE MATRIX.
!!  icn array containing the column indices of the non-zeros.  Those
!!      belonging to a single row must be contiguous but the ordering
!!      of column indices within each row is unimportant and wasted
!!      space between rows is permitted.
!!  licn  length of array icn.
!!  ip  ip(I), I=1,2,...n, is the position in array icn of the first
!!      column index of a non-zero in row I.
!!  lenr  lenr(I) is the number of non-zeros in row I, I=1,2,...N.
!!  ior  ior(I) gives the position in the original ordering of the row
!!      or column which is in position I in the permuted form, I=1,2,..N.
!!  ib  ib(I) is the row number in the permuted matrix of the beginning
!!      of block I, I=1,2,...NUM.
!!  num number of blocks found.
!!  iw  work array of length 3*n.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: num
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: ior(n), ib(n), iw(n,3)
interface
   pure subroutine mc13e(n,icn,licn,ip,lenr,arp,ib,num,lowl, &
      & numb,prev)
      implicit none
      integer, intent(in) :: licn
      integer, intent(in) :: n
      integer, intent(in) :: icn(licn)
      integer, intent(in) :: ip(n)
      integer, intent(in) :: lenr(n)
      integer, intent(inout) :: arp(n)
      integer, intent(inout) :: ib(n)
      integer, intent(out) :: num
      integer, intent(inout) :: lowl(n)
      integer, intent(inout) :: numb(n)
      integer, intent(inout) :: prev(n)
   end subroutine mc13e
end interface
! Description of parameters.
! Input variables  .... n,icn,licn,ip,lenr.
! Output variables  ior,ib,num.
! n   ORDER OF THE MATRIX.
! icn array containing the column indices of the non-zeros.  Those
!     belonging to a single row must be contiguous but the ordering
!     of column indices within each row is unimportant and wasted
!     space between rows is permitted.
! licn  length of array icn.
! ip  ip(I), I=1,2,...n, is the position in array icn of the first
!     column index of a non-zero in row I.
! lenr  lenr(I) is the number of non-zeros in row I, I=1,2,...N.
! ior  ior(I) gives the position in the original ordering of the row
!     or column which is in position I in the permuted form, I=1,2,..N.
! ib  ib(I) is the row number in the permuted matrix of the beginning
!     of block I, I=1,2,...NUM.
! num number of blocks found.
! iw  work array of length 3*n.
call mc13e(n, icn, licn, ip, lenr, ior, ib, num, iw(1,1), &
   & iw(1,2), iw(1,3))
end subroutine mc13d

pure subroutine mc13e(n, icn, licn, ip, lenr, arp, ib, num, lowl, &
   & numb, prev)
!! <!-- nswc-ford:begin MC13E -->
!! Reference for `mc13e`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  arp(i) is one less than the number of unsearched edges leaving
!!      node i.  at the end of the algorithm it is set to A
!!      permutation which puts the matrix in block lower
!!      triangular form.
!!  ib(i) is the position in the ordering of the start of the ith
!!      block.  ib(n+1-i) holds the node number of the ith node
!!      on the stack.
!!  lowl(i) is the smallest stack position of any node to which a path
!!      from node i has been found.  It is set to n+1 when node i
!!      is removed from the stack.
!!  numb(i) is the position of node i in the stack if it is on
!!      it, is the permuted order of node i for those nodes
!!      whose final position has been found and is otherwise zero.
!!  prev(i) is the node at the end of the path when node i was
!!      placed on the stack.
!!    icnt is the number of nodes whose positions in final ordering have
!!      been found.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: licn, n
integer, intent(out) :: num
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: arp(n), ib(n), lowl(n), numb(n), prev(n)
!     beginning of local variable declarations
integer :: i, i1, i2, icnt, ii, isn, ist, ist1, iv, iw, j, k, lcnt, nnm1, stp, dummy
! arp(i) is one less than the number of unsearched edges leaving
!     node i.  at the end of the algorithm it is set to A
!     permutation which puts the matrix in block lower
!     triangular form.
! ib(i) is the position in the ordering of the start of the ith
!     block.  ib(n+1-i) holds the node number of the ith node
!     on the stack.
! lowl(i) is the smallest stack position of any node to which a path
!     from node i has been found.  It is set to n+1 when node i
!     is removed from the stack.
! numb(i) is the position of node i in the stack if it is on
!     it, is the permuted order of node i for those nodes
!     whose final position has been found and is otherwise zero.
! prev(i) is the node at the end of the path when node i was
!     placed on the stack.
!   icnt is the number of nodes whose positions in final ordering have
!     been found.
icnt = 0
! num is the number of blocks that have been found.
num = 0
nnm1 = n + n - 1
! Initialization of arrays.
do j = 1,n
   numb(j) = 0
   arp(j) = lenr(j) - 1
end do
nswc_exit_1 : do isn = 1 , n
! Look for a starting node
   if (numb(isn) /= 0) go to 90
   iv = isn
! ist is the number of nodes on the stack ... it is the stack pointer.
   ist = 1
! Put node iv at beginning of stack.
   lowl(iv) = 1
   numb(iv) = 1
   ib(n) = iv
! The body of this loop puts a new node on the stack or backtracks.
   do dummy = 1,nnm1
      i1 = arp(iv)
! Have all edges leaving node iv been searched.
      if (i1 < 0) go to 30
      i2 = ip(iv) + lenr(iv) - 1
      i1 = i2 - i1
! Look at edges leaving node iv until one enters a new node or
!     all edges are exhausted.
      do ii = i1,i2
         iw = icn(ii)
! Has node iw been on stack already.
         if (numb(iw) == 0) go to 70
! Update value of lowl(iv) if necessary.
         if (lowl(iw) < lowl(iv)) lowl(iv) = lowl(iw)
      end do
! There are no more edges leaving node iv.
      arp(iv) = -1
! Is node iv the root of a block.
30    if (lowl(iv) < numb(iv)) go to 60
! Order nodes in a block.
      num = num + 1
      ist1 = n + 1 - ist
      lcnt = icnt + 1
! Peel block off the top of the stack starting at the top and
!     working down to the root of the block.
      do stp = ist1,n
         iw = ib(stp)
         lowl(iw) = n + 1
         icnt = icnt + 1
         numb(iw) = icnt
         if (iw == iv) exit
      end do
      ist = n - stp
      ib(num) = lcnt
! Are there any nodes left on the stack.
      if (ist /= 0) go to 60
! Have all the nodes been ordered.
      if (icnt < n) exit
      exit nswc_exit_1
! Backtrack to previous node on path.
60    iw = iv
      iv = prev(iv)
! Update value of lowl(iv) if necessary.
      if (lowl(iw) < lowl(iv)) lowl(iv) = lowl(iw)
      go to 80
! Put new node on the stack.
70    arp(iv) = i2 - ii - 1
      prev(iw) = iv
      iv = iw
      ist = ist + 1
      lowl(iv) = ist
      numb(iv) = ist
      k = n + 1 - ist
      ib(k) = iv
80    continue
   end do
90 continue
end do nswc_exit_1
! Put permutation in the required form.
do i = 1,n
   ii = numb(i)
   arp(ii) = i
end do
end subroutine mc13e

subroutine spslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
!! <!-- nswc-ford:begin SPSLV -->
!! Reference for `spslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Solution of real sparse equations
!!
!!   spslv calls nspiv1 which uses sparse Gaussian elimination with
!!   column interchanges to solve the linear system A x = b.  the
!!   elimination phase performs row operations on A and b to obtain
!!   a unit upper triangular matrix u and a vector y.  the solution
!!   phase solves u x = y.
!!   Input arguments---
!!   n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!!   A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
!!          actual nonzeros.  (See matrix storage description below)
!!   ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!!          (see matrix storage description below)
!!   ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!!          column numbers of the nonzeros of A.  (See matrix storage
!!          description below)
!!   b      REAL ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!!   r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          rows of A (I.E., the elimination order for the equations)
!!   c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          columns of A.  c is also an output argument
!!   MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!!          nonzero entries of u which may be stored
!!   itemp  integer array of 3*n + max + 2 entries, for internal use
!!   rtemp  real array of n + max entries for internal use
!!   output arguments---
!!   c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          columns of u.  c is also an input argument
!!   x      REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!!   ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!!          the actual number of off-diagonal entries in u (for
!!          successful completion)
!!          ierr values are---
!!          0 LT ierr             successful completion. ierr=max(1,M)
!!                                where M is the number of off-diagonal
!!                                nonzero entries of u.
!!          ierr = 0              Error.  n is less than or equal to 0
!!          -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!!                                is null
!!          -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!!                                duplicate entry
!!          -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!!                                has a zero pivot
!!          -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!!                                exceeds storage
!!   storage of sparse matrices---
!!   the sparse matrix a is stored using three arrays ia, ja, and a.
!!   The array a contains the nonzeros of the matrix ROW-by-ROW, not
!!   necessarily in order of increasing column number.  The array ja
!!   contains the column numbers corresponding to the nonzeros stored
!!   in the array a (I.E., if the nonzero stored in a(k) is in
!!   column J, then ja(k) = J).  The array ia contains pointers to the
!!   rows of nonzeros/column indices in the array a/ja (I.E.,
!!   a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!!   ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!!   elements in A.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
!     beginning of local variable declarations
integer :: k, l, iu, ju, u, y, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!  spslv calls nspiv1 which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  Input arguments---
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!  A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
!         actual nonzeros.  (See matrix storage description below)
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!  b      REAL ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!  rtemp  real array of n + max entries for internal use
!  output arguments---
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!  x      REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!         ierr values are---
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!         ierr = 0              Error.  n is less than or equal to 0
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column J, then ja(k) = J).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!  elements in A.
!------------------------
ierr = 0
if (n <= 0) return
!  Set indices to divide temporary storage for nspiv1
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!  Compute the inverse permutation of c
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!  CALL nspiv1 TO PERFORM COMPUTATIONS
call nspiv1(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
end subroutine spslv

subroutine nspiv1(n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
!! <!-- nswc-ford:begin NSPIV1 -->
!! Reference for `nspiv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   nspiv1 uses sparse Gaussian elimination with
!!   column interchanges to solve the linear system A x = b.  the
!!   elimination phase performs row operations on A and b to obtain
!!   a unit upper triangular matrix u and a vector y.  the solution
!!   phase solves u x = y.
!!   See spslv for descriptions of all input and output arguments
!!   other than those described below
!!   ic  integer array of n entries which is the inverse of c
!!       (I.E., ic(c(i)) = i). ic is both an input and output
!!       argument.
!!   Input arguments (used internally only)---
!!   y   REAL ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!!       right hand side
!!   p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!!       p(n+1) is the list header, and the entry following
!!       p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!!       item, p(p(n+1)) is the second, etc.  a pointer of
!!       n+1 marks the end of the list
!!   iu  integer array of n+1 entries used for row pointers to u
!!       (see matrix storage description below)
!!   ju  integer array of max entries used for column numbers of
!!       the nonzeros in the strict upper triangle of u.  (See
!!       matrix storage description below)
!!   u   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!!       the strict upper triangle of u.  (See matrix storage
!!       description below)
!!   storage of sparse matrices---
!!   the sparse matrix a is stored using three arrays ia, ja, and a.
!!   The array a contains the nonzeros of the matrix ROW-by-ROW, not
!!   necessarily in order of increasing column number.  The array ja
!!   contains the column numbers corresponding to the nonzeros stored
!!   in the array a (I.E., if the nonzero stored in a(k) is in
!!   column j, then ja(k) = j).  The array ia contains pointers to the
!!   rows of nonzeros/column indices in the array a/ja (I.E.,
!!   a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!!   ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!!   A.  iu, ju, and u are used in a similar way to store the strict upper
!!   triangle of u, except that ju actually contains c(j) instead of j
!!   initialize work storage and pointers to ju
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: u(max), x(n), y(n)
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
!     beginning of local variable declarations
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, nzcnt, ck, pk, ppk, pv, v, vi, vj, vk, nswc_ai_i4
real :: dk, lki, xpv, xpvmax, yk
!  nspiv1 uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  See spslv for descriptions of all input and output arguments
!  other than those described below
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!  Input arguments (used internally only)---
!  y   REAL ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!  u   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column j, then ja(k) = j).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!  initialize work storage and pointers to ju
do j = 1,n
   x(j) = 0.0
end do
iu(1) = 1
juptr = 0
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
do k = 1,n
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
   p(n + 1) = n + 1
   vk = r(k)
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!  Store a(k,j) in work vector
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   nswc_ai_i4 = ppk - vj
   if (nswc_ai_i4 < 0) go to 30
   if (nswc_ai_i4 == 0) go to 1003
   go to 40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!  The following code computes the k-TH row of u
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
   lki = - x(vi)
   x(vi) = 0.0
!  Adjust right hand side to reflect elimination
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!  If vj is already in the adjacency of vk,
!  skip the insertion
      if (x(vj) /= 0.0) go to 90
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
      nswc_ai_i4 = vj - ppk
      if (nswc_ai_i4 < 0) go to 60
      if (nswc_ai_i4 == 0) go to 90
      go to 70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      nswc_ai_i4 = ppk - vj
      if (nswc_ai_i4 < 0) go to 70
      if (nswc_ai_i4 == 0) go to 90
      go to 80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!  Find largest entry, counting off-diagonal nonzeros
110 if (vi > n) go to 1004
   xpvmax = abs(x(vi))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = abs(x(pv))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.0) go to 1004
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!  Compute D(k) = 1/L(k,k) and perform interchange.
150 dk = 1.0 / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = 0.0
!  Update right hand side.
   y(k) = yk * dk
!  Compute value for iu(k+1) and check for storage overflow
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = 0.0
   j = p(j)
   if (j <= n) go to 160
170 continue
end do
!  Backsolve u x = y, and reorder x to correspond with A
k = n
do i = 1,n
   yk = y(k)
   jmin = iu(k)
   jmax = iu(k + 1) - 1
   if (jmin > jmax) go to 190
   do j = jmin,jmax
      juj = ju(j)
      juj = ic(juj)
      yk = yk - u(j) * y(juj)
   end do
190 y(k) = yk
   ck = c(k)
   x(ck) = yk
   k = k - 1
end do
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
ierr = iu(n + 1) - iu(1)
return
!  Error returns
!  row k of A is null
1002 ierr = -k
return
!  Row k of A has a duplicate entry
1003 ierr = -(n + k)
return
!  Zero pivot in row k
1004 ierr = -(2*n + k)
return
!  Storage for u exceeded on row k
1005 ierr = -(3*n + k)
end subroutine nspiv1

subroutine rslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
!! <!-- nswc-ford:begin RSLV -->
!! Reference for `rslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Solution of real sparse equations
!!
!!      rslv employs Gaussian elimination with column interchanges to
!!      solve the NXN linear system AX = b. the argument m0 specifies
!!      if rslv is being called for the first time, or if it is being
!!      recalled where A is the same matrix but b has been modified.
!!      On an initial call to the routine (when m0=0) the LU DECOMPO-
!!      sition of A is obtained where U is a unit upper triangular
!!      matrix. Then the equations are solved. On subsequent calls
!!      (when m0.NE.0) the equations are solved using the decomposition
!!      obtained on the initial call to rslv.
!!      Input arguments when m0=0 ---
!!      n        NUMBER OF EQUATIONS AND UNKNOWNS.
!!      a,ia,ja  the matrix a stored in sparse form.
!!      b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of l and U which may be stored.
!!      Output arguments when m0=0 ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!!               b and x may share the same storage area.
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               solution of AX = b is obtained then ierr = max(1,M)
!!               where M is the total number of off-diagonal nonzero
!!               entries of l and U. otherwise ierr.LE.0.
!!      General storage areas ---
!!      iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!!      wk       REAL ARRAY OF DIMENSION 2*n + max.
!!      After an initial call to rslv, the routine may be recalled with
!!      m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!!      r,c,iwk,wk have not been modified. The routine retrieves the LU
!!      decomposition which was obtained on the initial call to rslv
!!      and solves the new equations AX = b. in this case A,ia,ja,max,
!!      and ierr are not referenced.
!!
!!      Set indices to divide temporary storage
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
!     beginning of local variable declarations
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!     rslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system AX = b. the argument m0 specifies
!     if rslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to rslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the matrix a stored in sparse form.
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!     After an initial call to rslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to rslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call splu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call rslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine rslv

pure subroutine rslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
!! <!-- nswc-ford:begin RSLV1 -->
!! Reference for `rslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Solve LY = b by forward substitution
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, k, lj, lk
real :: sum
!            Solve LY = b by forward substitution
do k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
end do
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
21 y(k) = sum
   lk = c(k)
   x(lk) = y(k)
   k = k - 1
end do
end subroutine rslv1

subroutine tslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
!! <!-- nswc-ford:begin TSLV -->
!! Reference for `tslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Solution of real sparse equations
!!
!!      tslv employs Gaussian elimination with column interchanges to
!!      solve the NXN linear system XA = b. the argument m0 specifies
!!      if tslv is being called for the first time, or if it is being
!!      recalled where A is the same matrix but b has been modified.
!!      On an initial call to the routine (when m0=0) the LU DECOMPO-
!!      sition of A is obtained where U is a unit upper triangular
!!      matrix. Then the equations are solved. On subsequent calls
!!      (when m0.NE.0) the equations are solved using the decomposition
!!      obtained on the initial call to tslv.
!!      Input arguments when m0=0 ---
!!      n        NUMBER OF EQUATIONS AND UNKNOWNS.
!!      a,ia,ja  the matrix a stored in sparse form.
!!      b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of l and U which may be stored.
!!      Output arguments when m0=0 ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!!               b and x may share the same storage area.
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               solution of AX = b is obtained then ierr = max(1,M)
!!               where M is the total number of off-diagonal nonzero
!!               entries of l and U. otherwise ierr.LE.0.
!!      General storage areas ---
!!      iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!!      wk       REAL ARRAY OF DIMENSION 2*n + max.
!!      After an initial call to tslv, the routine may be recalled with
!!      m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!!      r,c,iwk,wk have not been modified. The routine retrieves the LU
!!      decomposition which was obtained on the initial call to tslv
!!      and solves the new equations XA = b. in this case A,ia,ja,max,
!!      and ierr are not referenced.
!!
!!      Set indices to divide temporary storage
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
!     beginning of local variable declarations
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!     tslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system XA = b. the argument m0 specifies
!     if tslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to tslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the matrix a stored in sparse form.
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!     After an initial call to tslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to tslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call splu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call tslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine tslv

pure subroutine tslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
!! <!-- nswc-ford:begin TSLV1 -->
!! Reference for `tslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Solve YU = b by forward substitution
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, k, lj, lk
!            Solve YU = b by forward substitution
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
do k = 1,n
   if (y(k) == 0.0) go to 21
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
end do
!            Solve XL = y by backward substitution
x(n) = y(n)/d(n)
if (n == 1) return
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
end subroutine tslv1

subroutine splu(a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
!! <!-- nswc-ford:begin SPLU -->
!! Reference for `splu`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      splu employs Gaussian elimination with column interchanges
!!      to perform the LU decomposition of a real sparse matrix.
!!      U is a unit upper triangular matrix.
!!      Input arguments ---
!!      A,ia,ja  the sparse matrix to be decomposed.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!!               (I.E., ic(c(i)) = i). ic is also an output argument.
!!      n        ORDER OF THE MATRIX a.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of L and U which may be stored.
!!      Output arguments ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!!      d        REAL ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!!      t,it,iu  t contains the off-diagonal nonzero elements of L and
!!               U. for i = 1,...,n the off-diagonal nonzero elements
!!               of the i-TH row of L are stored in locations
!!               it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!!               elements of the i-TH row of U are stored in locations
!!               iu(i),...,it(i+1)-1 of t.
!!      jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!!               to the orginal column ordering) of the elements of t
!!               (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!!               corresponding column index in jt).
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               LU decomposition is obtained then ierr = The number
!!               of off-diagonal entries of L and U which were stored
!!               in t. otherwise ierr is assigned a negative value.
!!      Work spaces ---
!!      w        REAL ARRAY OF DIMENSION n.
!!      p        INTEGER ARRAY OF DIMENSION n+1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*)
real, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, maxil, pm, nswc_ai_i4
real :: const, wi, wmax
!-----------------------------------------------------------------------
!     splu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a real sparse matrix.
!     U is a unit upper triangular matrix.
!     Input arguments ---
!     A,ia,ja  the sparse matrix to be decomposed.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!     n        ORDER OF THE MATRIX a.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!     Output arguments ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!     d        REAL ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!     Work spaces ---
!     w        REAL ARRAY OF DIMENSION n.
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.0
end do
!     Perform the LU factorization of the r(k)-TH row of A
do k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!     Set p to the reordered row of A
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   nswc_ai_i4 = pm - j
   if (nswc_ai_i4 < 0) go to 21
   if (nswc_ai_i4 == 0) go to 210
   go to 22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!     Process the entries in the lower triangle of A
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == 0.0) go to 30
!     L(k,i) is nonzero. Therefore store it in L.
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = 0.0
!     Perform elimination using the i-TH row of U
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= 0.0) go to 43
      nswc_ai_i4 = j - pm
      if (nswc_ai_i4 < 0) go to 40
      if (nswc_ai_i4 == 0) go to 43
      go to 41
40    pm = i
41    m = pm
      pm = p(m)
      nswc_ai_i4 = pm - j
      if (nswc_ai_i4 < 0) go to 41
      if (nswc_ai_i4 == 0) go to 43
      go to 42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   end do
   go to 30
!     Search for the k-TH pivot element
50 if (i > n) go to 220
   wmax = abs(w(i))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = abs(w(pm))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!     Store the pivot in d
60 if (wmax == 0.0) go to 220
   d(k) = w(maxi)
!     Perform the column interchange
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
80 w(maxi) = w(k)
   w(k) = 0.0
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!     The remaining elements of p form the k-TH row of U
   iu(k) = jptr + 1
90 if (i > n) go to 100
   if (w(i) == 0.0) go to 91
   jptr = jptr + 1
   if (jptr > max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = 0.0
91 i = p(i)
   go to 90
!     Prepare for the next row
100 it(k + 1) = jptr + 1
end do
ierr = jptr
return
!     -------------------- Error return --------------------
!     row r(k) is null
200 ierr = -k
return
!     Row r(k) has a duplicate entry
210 ierr = -(n + k)
return
!     Zero pivot in row r(k)
220 ierr = -(2*n + k)
return
!     Storage for L and U exceeded on row r(k)
230 ierr = -(3*n + k)
end subroutine splu

subroutine dspslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
!! <!-- nswc-ford:begin DSPSLV -->
!! Reference for `dspslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Solution of double precision sparse equations
!!
!!   dspslv calls dnspiv which uses sparse Gaussian elimination with
!!   column interchanges to solve the linear system A x = b.  the
!!   elimination phase performs row operations on A and b to obtain
!!   a unit upper triangular matrix u and a vector y.  the solution
!!   phase solves u x = y.
!!   Input arguments---
!!   n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!!   A      DOUBLE PRECISION ARRAY WITH ONE ENTRY PER NONZERO IN A,
!!          containing the actual nonzeros. (See the matrix storage
!!          description below)
!!   ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!!          (see matrix storage description below)
!!   ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!!          column numbers of the nonzeros of A.  (See matrix storage
!!          description below)
!!   b      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE RIGHT
!!          hand side data
!!   r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          rows of A (I.E., the elimination order for the equations)
!!   c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          columns of A.  c is also an output argument
!!   MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!!          nonzero entries of u which may be stored
!!   itemp  integer array of 3*n + max + 2 entries, for internal use
!!   rtemp  double precision array of n + max entries for internal use
!!   output arguments---
!!   c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          columns of u.  c is also an input argument
!!   x      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!!          solution vector
!!   ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!!          the actual number of off-diagonal entries in u (for
!!          successful completion)
!!          ierr values are---
!!          0 LT ierr             successful completion. ierr=max(1,M)
!!                                where M is the number of off-diagonal
!!                                nonzero entries of u.
!!          ierr = 0              Error.  n is less than or equal to 0
!!          -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!!                                is null
!!          -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!!                                duplicate entry
!!          -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!!                                has a zero pivot
!!          -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!!                                exceeds storage
!!   storage of sparse matrices---
!!   the sparse matrix a is stored using three arrays ia, ja, and a.
!!   The array a contains the nonzeros of the matrix ROW-by-ROW, not
!!   necessarily in order of increasing column number.  The array ja
!!   contains the column numbers corresponding to the nonzeros stored
!!   in the array a (I.E., if the nonzero stored in a(k) is in
!!   column J, then ja(k) = J).  The array ia contains pointers to the
!!   rows of nonzeros/column indices in the array a/ja (I.E.,
!!   a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!!   ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!!   elements in A.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
!     beginning of local variable declarations
integer :: k, l, iu, ju, u, y, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!  dspslv calls dnspiv which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  Input arguments---
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!  A      DOUBLE PRECISION ARRAY WITH ONE ENTRY PER NONZERO IN A,
!         containing the actual nonzeros. (See the matrix storage
!         description below)
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!  b      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE RIGHT
!         hand side data
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!  rtemp  double precision array of n + max entries for internal use
!  output arguments---
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!  x      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!         solution vector
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!         ierr values are---
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!         ierr = 0              Error.  n is less than or equal to 0
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column J, then ja(k) = J).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!  elements in A.
!------------------------
ierr = 0
if (n <= 0) return
!  Set indices to divide temporary storage for dnspiv
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!  Compute the inverse permutation of c
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!  CALL dnspiv TO PERFORM COMPUTATIONS
call dnspiv(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
end subroutine dspslv

subroutine dnspiv(n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
!! <!-- nswc-ford:begin DNSPIV -->
!! Reference for `dnspiv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   dnspiv uses sparse Gaussian elimination with
!!   column interchanges to solve the linear system A x = b.  the
!!   elimination phase performs row operations on A and b to obtain
!!   a unit upper triangular matrix u and a vector y.  the solution
!!   phase solves u x = y.
!!   See dspslv for descriptions of all input and output arguments
!!   other than those described below
!!   ic  integer array of n entries which is the inverse of c
!!       (I.E., ic(c(i)) = i). ic is both an input and output
!!       argument.
!!   Input arguments (used internally only)---
!!   y   DOUBLE PRECISION ARRAY OF n ENTRIES USED TO COMPUTE
!!       the updated right hand side
!!   p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!!       p(n+1) is the list header, and the entry following
!!       p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!!       item, p(p(n+1)) is the second, etc.  a pointer of
!!       n+1 marks the end of the list
!!   iu  integer array of n+1 entries used for row pointers to u
!!       (see matrix storage description below)
!!   ju  integer array of max entries used for column numbers of
!!       the nonzeros in the strict upper triangle of u.  (See
!!       matrix storage description below)
!!   u   DOUBLE PRECISION ARRAY OF MAX ENTRIES USED FOR THE ACTUAL
!!       nonzeros in the strict upper triangle of u. (See matrix
!!       storage description below)
!!   storage of sparse matrices---
!!   the sparse matrix a is stored using three arrays ia, ja, and a.
!!   The array a contains the nonzeros of the matrix ROW-by-ROW, not
!!   necessarily in order of increasing column number.  The array ja
!!   contains the column numbers corresponding to the nonzeros stored
!!   in the array a (I.E., if the nonzero stored in a(k) is in
!!   column j, then ja(k) = j).  The array ia contains pointers to the
!!   rows of nonzeros/column indices in the array a/ja (I.E.,
!!   a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!!   ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!!   A.  iu, ju, and u are used in a similar way to store the strict upper
!!   triangle of u, except that ju actually contains c(j) instead of j
!!   initialize work storage and pointers to ju
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: u(max), x(n), y(n)
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
!     beginning of local variable declarations
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, nzcnt, ck, pk, ppk, pv, v, vi, vj, vk, nswc_ai_i4
double precision :: dk, lki, xpv, xpvmax, yk
!  dnspiv uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  See dspslv for descriptions of all input and output arguments
!  other than those described below
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!  Input arguments (used internally only)---
!  y   DOUBLE PRECISION ARRAY OF n ENTRIES USED TO COMPUTE
!      the updated right hand side
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!  u   DOUBLE PRECISION ARRAY OF MAX ENTRIES USED FOR THE ACTUAL
!      nonzeros in the strict upper triangle of u. (See matrix
!      storage description below)
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column j, then ja(k) = j).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!  initialize work storage and pointers to ju
do j = 1,n
   x(j) = 0.d0
end do
iu(1) = 1
juptr = 0
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
do k = 1,n
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
   p(n + 1) = n + 1
   vk = r(k)
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!  Store a(k,j) in work vector
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   nswc_ai_i4 = ppk - vj
   if (nswc_ai_i4 < 0) go to 30
   if (nswc_ai_i4 == 0) go to 1003
   go to 40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!  The following code computes the k-TH row of u
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
   lki = - x(vi)
   x(vi) = 0.d0
!  Adjust right hand side to reflect elimination
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!  If vj is already in the adjacency of vk,
!  skip the insertion
      if (x(vj) /= 0.d0) go to 90
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
      nswc_ai_i4 = vj - ppk
      if (nswc_ai_i4 < 0) go to 60
      if (nswc_ai_i4 == 0) go to 90
      go to 70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      nswc_ai_i4 = ppk - vj
      if (nswc_ai_i4 < 0) go to 70
      if (nswc_ai_i4 == 0) go to 90
      go to 80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!  Find largest entry, counting off-diagonal nonzeros
110 if (vi > n) go to 1004
   xpvmax = abs(x(vi))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = abs(x(pv))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.d0) go to 1004
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!  Compute D(k) = 1/L(k,k) and perform interchange.
150 dk = 1.d0 / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = 0.d0
!  Update right hand side.
   y(k) = yk * dk
!  Compute value for iu(k+1) and check for storage overflow
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = 0.d0
   j = p(j)
   if (j <= n) go to 160
170 continue
end do
!  Backsolve u x = y, and reorder x to correspond with A
k = n
do i = 1,n
   yk = y(k)
   jmin = iu(k)
   jmax = iu(k + 1) - 1
   if (jmin > jmax) go to 190
   do j = jmin,jmax
      juj = ju(j)
      juj = ic(juj)
      yk = yk - u(j) * y(juj)
   end do
190 y(k) = yk
   ck = c(k)
   x(ck) = yk
   k = k - 1
end do
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
ierr = iu(n + 1) - iu(1)
return
!  Error returns
!  row k of A is null
1002 ierr = -k
return
!  Row k of A has a duplicate entry
1003 ierr = -(n + k)
return
!  Zero pivot in row k
1004 ierr = -(2*n + k)
return
!  Storage for u exceeded on row k
1005 ierr = -(3*n + k)
end subroutine dnspiv

subroutine dslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
!! <!-- nswc-ford:begin DSLV -->
!! Reference for `dslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Solution of double precision sparse equations
!!
!!      dslv employs Gaussian elimination with column interchanges to
!!      solve the NXN linear system AX = b. the argument m0 specifies
!!      if dslv is being called for the first time, or if it is being
!!      recalled where A is the same matrix but b has been modified.
!!      On an initial call to the routine (when m0=0) the LU DECOMPO-
!!      sition of A is obtained where U is a unit upper triangular
!!      matrix. Then the equations are solved. On subsequent calls
!!      (when m0.NE.0) the equations are solved using the decomposition
!!      obtained on the initial call to dslv.
!!      Input arguments when m0=0 ---
!!      n        NUMBER OF EQUATIONS AND UNKNOWNS.
!!      a,ia,ja  the double precision matrix a stored in sparse form.
!!      b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!!               right hand side data.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of l and U which may be stored.
!!      Output arguments when m0=0 ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!!               solution. b and x may share the same storage area.
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               solution of AX = b is obtained then ierr = max(1,M)
!!               where M is the total number of off-diagonal nonzero
!!               entries of l and U. otherwise ierr.LE.0.
!!      General storage areas ---
!!      iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!!      wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!!      After an initial call to dslv, the routine may be recalled with
!!      m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!!      r,c,iwk,wk have not been modified. The routine retrieves the LU
!!      decomposition which was obtained on the initial call to dslv
!!      and solves the new equations AX = b. in this case A,ia,ja,max,
!!      and ierr are not referenced.
!!
!!      Set indices to divide temporary storage
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
!     beginning of local variable declarations
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!     dslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system AX = b. the argument m0 specifies
!     if dslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to dslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the double precision matrix a stored in sparse form.
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!     After an initial call to dslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call dsplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call dslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine dslv

pure subroutine dslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
!! <!-- nswc-ford:begin DSLV1 -->
!! Reference for `dslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Solve LY = b by forward substitution
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, k, lj, lk
double precision :: sum
!            Solve LY = b by forward substitution
do k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
end do
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
21 y(k) = sum
   lk = c(k)
   x(lk) = y(k)
   k = k - 1
end do
end subroutine dslv1

subroutine dtslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
!! <!-- nswc-ford:begin DTSLV -->
!! Reference for `dtslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Solution of double precision sparse equations
!!
!!      dtslv employs Gaussian elimination with column interchanges to
!!      solve the NXN linear system XA = b. the argument m0 specifies
!!      if dtslv is being called for the first time, or if it is being
!!      recalled where A is the same matrix but b has been modified.
!!      On an initial call to the routine (when m0=0) the LU DECOMPO-
!!      sition of A is obtained where U is a unit upper triangular
!!      matrix. Then the equations are solved. On subsequent calls
!!      (when m0.NE.0) the equations are solved using the decomposition
!!      obtained on the initial call to dtslv.
!!      Input arguments when m0=0 ---
!!      n        NUMBER OF EQUATIONS AND UNKNOWNS.
!!      a,ia,ja  the double precision matrix a stored in sparse form.
!!      b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!!               right hand side data.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of l and U which may be stored.
!!      Output arguments when m0=0 ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!!               solution. b and x may share the same storage area.
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               solution of AX = b is obtained then ierr = max(1,M)
!!               where M is the total number of off-diagonal nonzero
!!               entries of l and U. otherwise ierr.LE.0.
!!      General storage areas ---
!!      iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!!      wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!!      After an initial call to dtslv, the routine may be recalled with
!!      m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!!      r,c,iwk,wk have not been modified. The routine retrieves the LU
!!      decomposition which was obtained on the initial call to dtslv
!!      and solves the new equations XA = b. in this case A,ia,ja,max,
!!      and ierr are not referenced.
!!
!!      Set indices to divide temporary storage
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
!     beginning of local variable declarations
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!     dtslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system XA = b. the argument m0 specifies
!     if dtslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to dtslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the double precision matrix a stored in sparse form.
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!     After an initial call to dtslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dtslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call dsplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call dtslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine dtslv

pure subroutine dtslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
!! <!-- nswc-ford:begin DTSLV1 -->
!! Reference for `dtslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Solve YU = b by forward substitution
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, k, lj, lk
!            Solve YU = b by forward substitution
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
do k = 1,n
   if (y(k) == 0.d0) go to 21
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
end do
!            Solve XL = y by backward substitution
x(n) = y(n)/d(n)
if (n == 1) return
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
end subroutine dtslv1

subroutine dsplu(a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
!! <!-- nswc-ford:begin DSPLU -->
!! Reference for `dsplu`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dsplu employs Gaussian elimination with column interchanges
!!      to perform the LU decomposition of a double precision sparse
!!      matrix. U is a unit upper triangular matrix.
!!      Input arguments ---
!!      A,ia,ja  the sparse matrix to be decomposed.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!!               (I.E., ic(c(i)) = i). ic is also an output argument.
!!      n        ORDER OF THE MATRIX a.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of L and U which may be stored.
!!      Output arguments ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!!      d        DOUBLE PRECISION ARRAY CONTAINING THE n DIAGONAL
!!               elements of L.
!!      t,it,iu  t contains the off-diagonal nonzero elements of L and
!!               U. for i = 1,...,n the off-diagonal nonzero elements
!!               of the i-TH row of L are stored in locations
!!               it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!!               elements of the i-TH row of U are stored in locations
!!               iu(i),...,it(i+1)-1 of t.
!!      jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!!               to the orginal column ordering) of the elements of t
!!               (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!!               corresponding column index in jt).
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               LU decomposition is obtained then ierr = The number
!!               of off-diagonal entries of L and U which were stored
!!               in t. otherwise ierr is assigned a negative value.
!!      Work spaces ---
!!      w        DOUBLE PRECISION ARRAY OF DIMENSION n.
!!      p        INTEGER ARRAY OF DIMENSION n+1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, maxil, pm, nswc_ai_i4
double precision :: const, wi, wmax
!-----------------------------------------------------------------------
!     dsplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a double precision sparse
!     matrix. U is a unit upper triangular matrix.
!     Input arguments ---
!     A,ia,ja  the sparse matrix to be decomposed.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!     n        ORDER OF THE MATRIX a.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!     Output arguments ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!     d        DOUBLE PRECISION ARRAY CONTAINING THE n DIAGONAL
!              elements of L.
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!     Work spaces ---
!     w        DOUBLE PRECISION ARRAY OF DIMENSION n.
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.d0
end do
!     Perform the LU factorization of the r(k)-TH row of A
do k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!     Set p to the reordered row of A
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   nswc_ai_i4 = pm - j
   if (nswc_ai_i4 < 0) go to 21
   if (nswc_ai_i4 == 0) go to 210
   go to 22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!     Process the entries in the lower triangle of A
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == 0.d0) go to 30
!     L(k,i) is nonzero. Therefore store it in L.
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = 0.d0
!     Perform elimination using the i-TH row of U
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= 0.d0) go to 43
      nswc_ai_i4 = j - pm
      if (nswc_ai_i4 < 0) go to 40
      if (nswc_ai_i4 == 0) go to 43
      go to 41
40    pm = i
41    m = pm
      pm = p(m)
      nswc_ai_i4 = pm - j
      if (nswc_ai_i4 < 0) go to 41
      if (nswc_ai_i4 == 0) go to 43
      go to 42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   end do
   go to 30
!     Search for the k-TH pivot element
50 if (i > n) go to 220
   wmax = abs(w(i))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = abs(w(pm))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!     Store the pivot in d
60 if (wmax == 0.d0) go to 220
   d(k) = w(maxi)
!     Perform the column interchange
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
80 w(maxi) = w(k)
   w(k) = 0.d0
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!     The remaining elements of p form the k-TH row of U
   iu(k) = jptr + 1
90 if (i > n) go to 100
   if (w(i) == 0.d0) go to 91
   jptr = jptr + 1
   if (jptr > max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = 0.d0
91 i = p(i)
   go to 90
!     Prepare for the next row
100 it(k + 1) = jptr + 1
end do
ierr = jptr
return
!     -------------------- Error return --------------------
!     row r(k) is null
200 ierr = -k
return
!     Row r(k) has a duplicate entry
210 ierr = -(n + k)
return
!     Zero pivot in row r(k)
220 ierr = -(2*n + k)
return
!     Storage for L and U exceeded on row r(k)
230 ierr = -(3*n + k)
end subroutine dsplu

subroutine s1cnd(n, a, ia, ja, r, c, max, cond, iwk, wk, ierr)
!! <!-- nswc-ford:begin S1CND -->
!! Reference for `s1cnd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Computation of the L1 condition number
!!                        of a sparse matrix a
!!
!!      real wk(4*n + max)
!!      integer iwk(5*n + max + 2)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(out) :: cond
real, intent(in) :: a(*)
real, intent(inout) :: wk(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
!     beginning of local variable declarations
integer :: isgn, iter, iv, ix, j, jump, kase
real :: ainorm, anorm
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a sparse matrix a
!-----------------------------------------------------------------------
!-----------------------
!     real wk(4*n + max)
!     integer iwk(5*n + max + 2)
!-----------------------
cond = 0.0
call s1nrm(a, ia, ja, n, n, anorm, wk)
if (anorm == 0.0) go to 50
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
kase = 0
ainorm = 0.0
call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call rslv(0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
!     Check if A is singular or if there are errors
if (ierr > 0) go to 20
if (abs(ierr) <= n) go to 50
ierr = ierr + n
if (abs(ierr) <= n) return
ierr = ierr + n
if (abs(ierr) <= n) go to 50
return
!     General loop to estimate the norm  ainorm
!     of the inverse of A
20 call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 40
if (kase /= 1) go to 30
call rslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
30 call tslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
!     Compute the value of cond
40 cond = anorm*ainorm
return
!     Singular case
50 ierr = 0
end subroutine s1cnd

subroutine ds1cnd(n, a, ia, ja, r, c, max, cond, iwk, wk, ierr)
!! <!-- nswc-ford:begin DS1CND -->
!! Reference for `ds1cnd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Computation of the L1 condition number
!!                        of a sparse matrix a
!!
!!      double precision wk(4*n + max)
!!      integer iwk(5*n + max + 2)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
!     beginning of local variable declarations
integer :: isgn, iter, iv, ix, j, jump, kase
double precision :: anorm, ainorm
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a sparse matrix a
!-----------------------------------------------------------------------
!-----------------------
!     double precision wk(4*n + max)
!     integer iwk(5*n + max + 2)
!-----------------------
cond = 0.d0
call ds1nrm(a, ia, ja, n, n, anorm, wk)
if (anorm == 0.d0) go to 50
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
kase = 0
ainorm = 0.d0
call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call dslv(0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
!     Check if A is singular or if there are errors
if (ierr > 0) go to 20
if (abs(ierr) <= n) go to 50
ierr = ierr + n
if (abs(ierr) <= n) return
ierr = ierr + n
if (abs(ierr) <= n) go to 50
return
!     General loop to estimate the norm  ainorm
!     of the inverse of A
20 call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 40
if (kase /= 1) go to 30
call dslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
30 call dtslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
!     Compute the value of cond
40 cond = anorm*ainorm
return
!     Singular case
50 ierr = 0
end subroutine ds1cnd

pure subroutine sonest(n, v, x, isgn, anorm, kase, iter, j, jump)
!! <!-- nswc-ford:begin SONEST -->
!! Reference for `sonest`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      sonest estimates the 1-norm of A square, real matrix  A.
!!      Reverse communication is used for evaluating
!!      matrix-vector products.
!!      On entry
!!         n       the order of the matrix.  n .GE. 1.
!!         kase    INTEGER  (= 0).
!!      On intermediate returns
!!         kase    = 1 or 2.
!!         x       MUST BE OVERWRITTEN BY
!!                      A*x,             IF kase = 1,
!!                      TRANSPOSE(A)*x,  IF kase = 2,
!!                 and sonest must be RE-called, with all the other
!!                 parameters unchanged.
!!         ITER    NUMBER OF THE CURRENT ITERATION.
!!      On final return
!!         kase    = 0.
!!         anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!!         v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!!                          (W  is not returned).
!!         ITER    NUMBER OF INTERATIONS TAKEN.
!!         Written by nick Higham, university of manchester. Modified
!!         by A.H. Morris (NSWC).
!!      Reference
!!      N.J. Higham (1987) Fortran codes for estimating
!!      the 1-norm of a real or complex matrix, with applications
!!      to condition  estimation, numerical analysis report no. 135,
!!      university of manchester, manchester M13 9PL, england.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iter, j, jump, kase
integer, intent(in) :: n
real, intent(inout) :: anorm
real, intent(inout) :: v(n), x(n)
integer, intent(inout) :: isgn(n)
!     beginning of local variable declarations
integer :: i, jlast, l
real :: altsgn, anrm, t
integer, parameter :: itmax = 5
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
   pure subroutine scopy(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine scopy
end interface
!-----------------------------------------------------------------------
!     sonest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!     On entry
!        n       the order of the matrix.  n .GE. 1.
!        kase    INTEGER  (= 0).
!     On intermediate returns
!        kase    = 1 or 2.
!        x       MUST BE OVERWRITTEN BY
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!                and sonest must be RE-called, with all the other
!                parameters unchanged.
!        ITER    NUMBER OF THE CURRENT ITERATION.
!     On final return
!        kase    = 0.
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!        ITER    NUMBER OF INTERATIONS TAKEN.
!        Written by nick Higham, university of manchester. Modified
!        by A.H. Morris (NSWC).
!     Reference
!     N.J. Higham (1987) Fortran codes for estimating
!     the 1-norm of a real or complex matrix, with applications
!     to condition  estimation, numerical analysis report no. 135,
!     university of manchester, manchester M13 9PL, england.
!-----------------------------------------------------------------------
if (kase /= 0) go to 20
t = 1.0/float(n)
do i = 1,n
   x(i) = t
end do
iter = 0
kase = 1
jump = 1
return
20 select case (jump)
case (1)
   go to 100
case (2)
   go to 200
case (3)
   go to 300
case (4)
   go to 400
case (5)
   go to 500
end select
!     ................ ENTRY   (jump = 1)
!     first iteration.  x has been overwritten by A*x.
100 iter = 1
if (n > 1) go to 110
v(1) = x(1)
anorm = abs(v(1))
go to 510
110 anorm = sasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!     ................ ENTRY   (jump = 2)
!     first iteration.  x has been overwritten by transpose(A)*x.
200 iter = 2
j = isamax(n,x,1)
!     Main loop - Iterations 2,3,...,itmax.
210 do i = 1,n
   x(i) = 0.0
end do
x(j) = 1.0
kase = 1
jump = 3
return
!     ................ ENTRY   (jump = 3)
!     x has been overwritten by A*x.
300 call scopy(n,x,1,v,1)
anrm = anorm
anorm = sasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) < 0.0) l = -1
   if (l /= isgn(i)) go to 320
end do
!     Repeated sign vector detected, hence algorithm has converged.
go to 410
!     Test for cycling.
320 if (anorm <= anrm) go to 410
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!     ................ ENTRY   (jump = 4)
!     x has been overwritten by transpose(A)*x.
400 jlast = j
j = isamax(n,x,1)
if (x(jlast) == abs(x(j)) .or. &
   & iter >= itmax) go to 410
iter = iter + 1
go to 210
!     Iteration complete.  Final stage.
410 altsgn = 1.0
do i = 1,n
   x(i) = altsgn * (1.0 + float(i - 1)/float(n - 1))
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!     ................ ENTRY   (jump = 5)
!     x has been overwritten by A*x.
500 anrm = 2.0*sasum(n,x,1)/float(3*n)
if (anrm <= anorm) go to 510
call scopy(n,x,1,v,1)
anorm = anrm
510 kase = 0
end subroutine sonest

pure subroutine donest(n, v, x, isgn, anorm, kase, iter, j, jump)
!! <!-- nswc-ford:begin DONEST -->
!! Reference for `donest`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      donest estimates the 1-norm of A square, real matrix  A.
!!      Reverse communication is used for evaluating
!!      matrix-vector products.
!!      On entry
!!         n       the order of the matrix.  n .GE. 1.
!!         kase    INTEGER  (= 0).
!!      On intermediate returns
!!         kase    = 1 or 2.
!!         x       MUST BE OVERWRITTEN BY
!!                      A*x,             IF kase = 1,
!!                      TRANSPOSE(A)*x,  IF kase = 2,
!!                 and donest must be RE-called, with all the other
!!                 parameters unchanged.
!!         ITER    NUMBER OF THE CURRENT ITERATION.
!!      On final return
!!         kase    = 0.
!!         anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!!         v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!!                          (W  is not returned).
!!         ITER    NUMBER OF INTERATIONS TAKEN.
!!         Written by nick Higham, university of manchester. Modified
!!         by A.H. Morris (NSWC).
!!      Reference
!!      N.J. Higham (1987) Fortran codes for estimating
!!      the 1-norm of a real or complex matrix, with applications
!!      to condition  estimation, numerical analysis report no. 135,
!!      university of manchester, manchester M13 9PL, england.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iter, j, jump, kase
integer, intent(in) :: n
double precision, intent(inout) :: anorm, v(n), x(n)
integer, intent(inout) :: isgn(n)
!     beginning of local variable declarations
integer :: i, jlast, l
double precision :: altsgn, an, anm1, anrm, t
integer, parameter :: itmax = 5
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
   pure subroutine dcopy(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dcopy
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
end interface
!-----------------------------------------------------------------------
!     donest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!     On entry
!        n       the order of the matrix.  n .GE. 1.
!        kase    INTEGER  (= 0).
!     On intermediate returns
!        kase    = 1 or 2.
!        x       MUST BE OVERWRITTEN BY
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!                and donest must be RE-called, with all the other
!                parameters unchanged.
!        ITER    NUMBER OF THE CURRENT ITERATION.
!     On final return
!        kase    = 0.
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!        ITER    NUMBER OF INTERATIONS TAKEN.
!        Written by nick Higham, university of manchester. Modified
!        by A.H. Morris (NSWC).
!     Reference
!     N.J. Higham (1987) Fortran codes for estimating
!     the 1-norm of a real or complex matrix, with applications
!     to condition  estimation, numerical analysis report no. 135,
!     university of manchester, manchester M13 9PL, england.
!-----------------------------------------------------------------------
an = n
anm1 = n - 1
if (kase /= 0) go to 20
t = 1.d0/an
do i = 1,n
   x(i) = t
end do
iter = 0
kase = 1
jump = 1
return
20 select case (jump)
case (1)
   go to 100
case (2)
   go to 200
case (3)
   go to 300
case (4)
   go to 400
case (5)
   go to 500
end select
!     ................ ENTRY   (jump = 1)
!     first iteration.  x has been overwritten by A*x.
100 iter = 1
if (n > 1) go to 110
v(1) = x(1)
anorm = abs(v(1))
go to 510
110 anorm = dasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.d0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!     ................ ENTRY   (jump = 2)
!     first iteration.  x has been overwritten by transpose(A)*x.
200 iter = 2
j = idamax(n,x,1)
!     Main loop - Iterations 2,3,...,itmax.
210 do i = 1,n
   x(i) = 0.d0
end do
x(j) = 1.d0
kase = 1
jump = 3
return
!     ................ ENTRY   (jump = 3)
!     x has been overwritten by A*x.
300 call dcopy(n,x,1,v,1)
anrm = anorm
anorm = dasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) < 0.d0) l = -1
   if (l /= isgn(i)) go to 320
end do
!     Repeated sign vector detected, hence algorithm has converged.
go to 410
!     Test for cycling.
320 if (anorm <= anrm) go to 410
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.d0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!     ................ ENTRY   (jump = 4)
!     x has been overwritten by transpose(A)*x.
400 jlast = j
j = idamax(n,x,1)
if (x(jlast) == abs(x(j)) .or. &
   & iter >= itmax) go to 410
iter = iter + 1
go to 210
!     Iteration complete.  Final stage.
410 altsgn = 1.d0
do i = 1,n
   t = i - 1
   x(i) = altsgn * (1.d0 + t/anm1)
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!     ................ ENTRY   (jump = 5)
!     x has been overwritten by A*x.
500 anrm = 2.d0*dasum(n,x,1)/(3.d0*an)
if (anrm <= anorm) go to 510
call dcopy(n,x,1,v,1)
anorm = anrm
510 kase = 0
end subroutine donest

subroutine cspslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
!! <!-- nswc-ford:begin CSPSLV -->
!! Reference for `cspslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Solution of complex sparse matrices
!!
!!   spslv calls cnspiv which uses sparse Gaussian elimination with
!!   column interchanges to solve the linear system A x = b.  the
!!   elimination phase performs row operations on A and b to obtain
!!   a unit upper triangular matrix u and a vector y.  the solution
!!   phase solves u x = y.
!!   Input arguments---
!!   n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!!   A      COMPLEX ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!!          the actual nonzeros.  (See storage description below)
!!   ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!!          (see matrix storage description below)
!!   ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!!          column numbers of the nonzeros of A.  (See matrix storage
!!          description below)
!!   b      COMPLEX ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!!   r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          rows of A (I.E., the elimination order for the equations)
!!   c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          columns of A.  c is also an output argument
!!   MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!!          nonzero entries of u which may be stored
!!   itemp  integer array of 3*n + max + 2 entries, for internal use
!!   rtemp  complex array of n + max entries for internal use
!!   output arguments---
!!   c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!!          columns of u.  c is also an input argument
!!   x      COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!!   ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!!          the actual number of off-diagonal entries in u (for
!!          successful completion)
!!          ierr values are---
!!          0 LT ierr             successful completion. ierr=max(1,M)
!!                                where M is the number of off-diagonal
!!                                nonzero entries of u.
!!          ierr = 0              Error.  n is less than or equal to 0
!!          -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!!                                is null
!!          -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!!                                duplicate entry
!!          -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!!                                has a zero pivot
!!          -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!!                                exceeds storage
!!   storage of sparse matrices---
!!   the sparse matrix a is stored using three arrays ia, ja, and a.
!!   The array a contains the nonzeros of the matrix ROW-by-ROW, not
!!   necessarily in order of increasing column number.  The array ja
!!   contains the column numbers corresponding to the nonzeros stored
!!   in the array a (I.E., if the nonzero stored in a(k) is in
!!   column J, then ja(k) = J).  The array ia contains pointers to the
!!   rows of nonzeros/column indices in the array a/ja (I.E.,
!!   a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!!   ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!!   elements in A.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
!     beginning of local variable declarations
integer :: k, l, iu, ju, u, y, p
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!  spslv calls cnspiv which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  Input arguments---
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!  A      COMPLEX ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         the actual nonzeros.  (See storage description below)
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!  b      COMPLEX ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!  rtemp  complex array of n + max entries for internal use
!  output arguments---
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!  x      COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!         ierr values are---
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!         ierr = 0              Error.  n is less than or equal to 0
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column J, then ja(k) = J).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!  elements in A.
!------------------------
ierr = 0
if (n <= 0) return
!  Set indices to divide temporary storage for cnspiv
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!  Compute the inverse permutation of c
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!  CALL cnspiv TO PERFORM COMPUTATIONS
call cnspiv(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
end subroutine cspslv

subroutine cnspiv(n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
!! <!-- nswc-ford:begin CNSPIV -->
!! Reference for `cnspiv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   cnspiv uses sparse Gaussian elimination with
!!   column interchanges to solve the linear system A x = b.  the
!!   elimination phase performs row operations on A and b to obtain
!!   a unit upper triangular matrix u and a vector y.  the solution
!!   phase solves u x = y.
!!   See cspslv for descriptions of all input and output arguments
!!   other than those described below
!!   ic  integer array of n entries which is the inverse of c
!!       (I.E., ic(c(i)) = i). ic is both an input and output
!!       argument.
!!   Input arguments (used internally only)---
!!   y   COMPLEX ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!!       right hand side
!!   p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!!       p(n+1) is the list header, and the entry following
!!       p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!!       item, p(p(n+1)) is the second, etc.  a pointer of
!!       n+1 marks the end of the list
!!   iu  integer array of n+1 entries used for row pointers to u
!!       (see matrix storage description below)
!!   ju  integer array of max entries used for column numbers of
!!       the nonzeros in the strict upper triangle of u.  (See
!!       matrix storage description below)
!!   u   COMPLEX ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!!       the strict upper triangle of u.  (See matrix storage
!!       description below)
!!   storage of sparse matrices---
!!   the sparse matrix a is stored using three arrays ia, ja, and a.
!!   The array a contains the nonzeros of the matrix ROW-by-ROW, not
!!   necessarily in order of increasing column number.  The array ja
!!   contains the column numbers corresponding to the nonzeros stored
!!   in the array a (I.E., if the nonzero stored in a(k) is in
!!   column j, then ja(k) = j).  The array ia contains pointers to the
!!   rows of nonzeros/column indices in the array a/ja (I.E.,
!!   a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!!   ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!!   A.  iu, ju, and u are used in a similar way to store the strict upper
!!   triangle of u, except that ju actually contains c(j) instead of j
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: u(max), x(n), y(n)
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
!     beginning of local variable declarations
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, nzcnt, ck, pk, ppk, pv, v, vi, vj, vk, nswc_ai_i4
complex :: dk, lki, one, yk, zero
real :: xpv, xpvmax
!  cnspiv uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  See cspslv for descriptions of all input and output arguments
!  other than those described below
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!  Input arguments (used internally only)---
!  y   COMPLEX ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!  u   COMPLEX ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column j, then ja(k) = j).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
one = (1.0,0.0)
zero = (0.0,0.0)
!  Initialize work storage and pointers to ju
do j = 1,n
   x(j) = zero
end do
iu(1) = 1
juptr = 0
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
do k = 1,n
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
   p(n + 1) = n + 1
   vk = r(k)
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!  Store a(k,j) in work vector
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   nswc_ai_i4 = ppk - vj
   if (nswc_ai_i4 < 0) go to 30
   if (nswc_ai_i4 == 0) go to 1003
   go to 40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!  The following code computes the k-TH row of u
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
   lki = - x(vi)
   x(vi) = zero
!  Adjust right hand side to reflect elimination
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!  If vj is already in the adjacency of vk,
!  skip the insertion
      if (x(vj) /= zero) go to 90
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
      nswc_ai_i4 = vj - ppk
      if (nswc_ai_i4 < 0) go to 60
      if (nswc_ai_i4 == 0) go to 90
      go to 70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      nswc_ai_i4 = ppk - vj
      if (nswc_ai_i4 < 0) go to 70
      if (nswc_ai_i4 == 0) go to 90
      go to 80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!  Find largest entry, counting off-diagonal nonzeros
110 if (vi > n) go to 1004
   xpvmax = abs(real(x(vi))) + abs(aimag(x(vi)))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = abs(real(x(pv))) + abs(aimag(x(pv)))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.0) go to 1004
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!  Compute D(k) = 1/L(k,k) and perform interchange.
150 dk = one / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = zero
!  Update right hand side.
   y(k) = yk * dk
!  Compute value for iu(k+1) and check for storage overflow
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = zero
   j = p(j)
   if (j <= n) go to 160
170 continue
end do
!  Backsolve u x = y, and reorder x to correspond with A
k = n
do i = 1,n
   yk = y(k)
   jmin = iu(k)
   jmax = iu(k + 1) - 1
   if (jmin > jmax) go to 190
   do j = jmin,jmax
      juj = ju(j)
      juj = ic(juj)
      yk = yk - u(j) * y(juj)
   end do
190 y(k) = yk
   ck = c(k)
   x(ck) = yk
   k = k - 1
end do
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
ierr = iu(n + 1) - iu(1)
return
!  Error returns
!  row k of A is null
1002 ierr = -k
return
!  Row k of A has a duplicate entry
1003 ierr = -(n + k)
return
!  Zero pivot in row k
1004 ierr = -(2*n + k)
return
!  Storage for u exceeded on row k
1005 ierr = -(3*n + k)
end subroutine cnspiv

subroutine cslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
!! <!-- nswc-ford:begin CSLV -->
!! Reference for `cslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Solution of complex sparse matrices
!!
!!      cslv employs Gaussian elimination with column interchanges to
!!      solve the NXN complex system AX = b. the argument m0 specifies
!!      if cslv is being called for the first time, or if it is being
!!      recalled where A is the same matrix but b has been modified.
!!      On an initial call to the routine (when m0=0) the LU DECOMPO-
!!      sition of A is obtained where U is a unit upper triangular
!!      matrix. Then the equations are solved. On subsequent calls
!!      (when m0.NE.0) the equations are solved using the decomposition
!!      obtained on the initial call to cslv.
!!      Input arguments when m0=0 ---
!!      n        NUMBER OF EQUATIONS AND UNKNOWNS.
!!      a,ia,ja  the complex matrix a stored in sparse form.
!!      b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!!               side data.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of l and U which may be stored.
!!      Output arguments when m0=0 ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!!               b and x may share the same storage area.
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               solution of AX = b is obtained then ierr = max(1,M)
!!               where M is the total number of off-diagonal nonzero
!!               entries of l and U. otherwise ierr.LE.0.
!!      General storage areas ---
!!      iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!!      wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!!      After an initial call to cslv, the routine may be recalled with
!!      m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!!      r,c,iwk,wk have not been modified. The routine retrieves the LU
!!      decomposition which was obtained on the initial call to cslv
!!      and solves the new equations AX = b. in this case A,ia,ja,max,
!!      and ierr are not referenced.
!!
!!      Set indices to divide temporary storage
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
!     beginning of local variable declarations
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!     cslv employs Gaussian elimination with column interchanges to
!     solve the NXN complex system AX = b. the argument m0 specifies
!     if cslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to cslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the complex matrix a stored in sparse form.
!     b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!              side data.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!     After an initial call to cslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to cslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call csplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call cslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine cslv

pure subroutine cslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
!! <!-- nswc-ford:begin CSLV1 -->
!! Reference for `cslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Solve LY = b by forward substitution
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
complex, intent(in) :: b(n), d(n), t(*)
complex, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, k, lj, lk
complex :: sum
!            Solve LY = b by forward substitution
do k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
end do
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
21 y(k) = sum
   lk = c(k)
   x(lk) = y(k)
   k = k - 1
end do
end subroutine cslv1

subroutine ctslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
!! <!-- nswc-ford:begin CTSLV -->
!! Reference for `ctslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Solution of complex sparse matrices
!!
!!      ctslv employs Gaussian elimination with column interchanges to
!!      solve the NXN complex system XA = b. the argument m0 specifies
!!      if ctslv is being called for the first time, or if it is being
!!      recalled where A is the same matrix but b has been modified.
!!      On an initial call to the routine (when m0=0) the LU DECOMPO-
!!      sition of A is obtained where U is a unit upper triangular
!!      matrix. Then the equations are solved. On subsequent calls
!!      (when m0.NE.0) the equations are solved using the decomposition
!!      obtained on the initial call to ctslv.
!!      Input arguments when m0=0 ---
!!      n        NUMBER OF EQUATIONS AND UNKNOWNS.
!!      a,ia,ja  the complex matrix a stored in sparse form.
!!      b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!!               side data.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of l and U which may be stored.
!!      Output arguments when m0=0 ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!!               b and x may share the same storage area.
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               solution of AX = b is obtained then ierr = max(1,M)
!!               where M is the total number of off-diagonal nonzero
!!               entries of l and U. otherwise ierr.LE.0.
!!      General storage areas ---
!!      iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!!      wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!!      After an initial call to ctslv, the routine may be recalled with
!!      m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!!      r,c,iwk,wk have not been modified. The routine retrieves the LU
!!      decomposition which was obtained on the initial call to ctslv
!!      and solves the new equations XA = b. in this case A,ia,ja,max,
!!      and ierr are not referenced.
!!
!!      Set indices to divide temporary storage
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
!     beginning of local variable declarations
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!     ctslv employs Gaussian elimination with column interchanges to
!     solve the NXN complex system XA = b. the argument m0 specifies
!     if ctslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to ctslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the complex matrix a stored in sparse form.
!     b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!              side data.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!     After an initial call to ctslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to ctslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call csplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call ctslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine ctslv

pure subroutine ctslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
!! <!-- nswc-ford:begin CTSLV1 -->
!! Reference for `ctslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Solve YU = b by forward substitution
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
complex, intent(in) :: b(n), d(n), t(*)
complex, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, k, lj, lk
!            Solve YU = b by forward substitution
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
do k = 1,n
   if (y(k) == (0.0, 0.0)) go to 21
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
end do
!            Solve XL = y by backward substitution
x(n) = y(n)/d(n)
if (n == 1) return
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
end subroutine ctslv1

subroutine csplu(a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
!! <!-- nswc-ford:begin CSPLU -->
!! Reference for `csplu`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      csplu employs Gaussian elimination with column interchanges
!!      to perform the LU decomposition of a complex sparse matrix.
!!      U is a unit upper triangular matrix.
!!      Input arguments ---
!!      A,ia,ja  the complex sparse matrix to be decomposed.
!!      r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the rows of A.
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!!               order of the columns. c is also an output argument.
!!      ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!!               (I.E., ic(c(i)) = i). ic is also an output argument.
!!      n        ORDER OF THE MATRIX a.
!!      MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!!               nonzero entries of L and U which may be stored.
!!      Output arguments ---
!!      c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!!               the columns that was selected by the routine.
!!      ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!!      d        COMPLEX ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!!      t,it,iu  t contains the off-diagonal nonzero elements of L and
!!               U. for i = 1,...,n the off-diagonal nonzero elements
!!               of the i-TH row of L are stored in locations
!!               it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!!               elements of the i-TH row of U are stored in locations
!!               iu(i),...,it(i+1)-1 of t. t is a complex array.
!!      jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!!               to the orginal column ordering) of the elements of t
!!               (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!!               corresponding column index in jt).
!!      ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!!               LU decomposition is obtained then ierr = The number
!!               of off-diagonal entries of L and U which were stored
!!               in t. otherwise ierr is assigned a negative value.
!!      Work spaces ---
!!      w        COMPLEX ARRAY OF DIMENSION n.
!!      p        INTEGER ARRAY OF DIMENSION n+1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
complex, intent(in) :: a(*)
complex, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
!     beginning of local variable declarations
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, maxil, pm, nswc_ai_i4
complex :: const
real :: wi, wmax
complex, parameter :: zero = (0.0, 0.0)
!-----------------------------------------------------------------------
!     csplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a complex sparse matrix.
!     U is a unit upper triangular matrix.
!     Input arguments ---
!     A,ia,ja  the complex sparse matrix to be decomposed.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!     n        ORDER OF THE MATRIX a.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!     Output arguments ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!     d        COMPLEX ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t. t is a complex array.
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!     Work spaces ---
!     w        COMPLEX ARRAY OF DIMENSION n.
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
!--------------------
!--------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = zero
end do
!     Perform the LU factorization of the r(k)-TH row of A
do k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!     Set p to the reordered row of A
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   nswc_ai_i4 = pm - j
   if (nswc_ai_i4 < 0) go to 21
   if (nswc_ai_i4 == 0) go to 210
   go to 22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!     Process the entries in the lower triangle of A
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == zero) go to 30
!     L(k,i) is nonzero. Therefore store it in L.
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = zero
!     Perform elimination using the i-TH row of U
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= zero) go to 43
      nswc_ai_i4 = j - pm
      if (nswc_ai_i4 < 0) go to 40
      if (nswc_ai_i4 == 0) go to 43
      go to 41
40    pm = i
41    m = pm
      pm = p(m)
      nswc_ai_i4 = pm - j
      if (nswc_ai_i4 < 0) go to 41
      if (nswc_ai_i4 == 0) go to 43
      go to 42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   end do
   go to 30
!     Search for the k-TH pivot element
50 if (i > n) go to 220
   wmax = abs(real(w(i))) + abs(aimag(w(i)))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = abs(real(w(pm))) + abs(aimag(w(pm)))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!     Store the pivot in d
60 if (wmax == 0.0) go to 220
   d(k) = w(maxi)
!     Perform the column interchange
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
80 w(maxi) = w(k)
   w(k) = zero
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!     The remaining elements of p form the k-TH row of U
   iu(k) = jptr + 1
90 if (i > n) go to 100
   if (w(i) == zero) go to 91
   jptr = jptr + 1
   if (jptr > max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = zero
91 i = p(i)
   go to 90
!     Prepare for the next row
100 it(k + 1) = jptr + 1
end do
ierr = jptr
return
!     -------------------- Error return --------------------
!     row r(k) is null
200 ierr = -k
return
!     Row r(k) has a duplicate entry
210 ierr = -(n + k)
return
!     Zero pivot in row r(k)
220 ierr = -(2*n + k)
return
!     Storage for L and U exceeded on row r(k)
230 ierr = -(3*n + k)
end subroutine csplu

pure subroutine eig(ibal,a,ka,n,wr,wi,ierr)
!! <!-- nswc-ford:begin EIG -->
!! Reference for `eig`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                     Eigenvalues of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine elmhs0(nm,n,low,igh,a,int)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: int(igh)
   end subroutine elmhs0
   pure subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine hqr
end interface
!-----------------------------------------------------------------------
!                    Eigenvalues of real matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,wr)
call elmhs0(ka,n,low,igh,a,wr)
call hqr(ka,n,low,igh,a,wr,wi,ierr)
end subroutine eig

pure subroutine eig1(ibal,a,ka,n,wr,wi,ierr)
!! <!-- nswc-ford:begin EIG1 -->
!! Reference for `eig1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                     Eigenvalues of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine hqr
   pure subroutine orthes(nm,n,low,igh,a,ort)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: ort(igh)
   end subroutine orthes
end interface
!-----------------------------------------------------------------------
!                    Eigenvalues of real matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,wr)
call orthes(ka,n,low,igh,a,wr)
call hqr(ka,n,low,igh,a,wr,wi,ierr)
end subroutine eig1

pure subroutine eigv(ibal,a,ka,n,wr,wi,zr,zi,ierr)
!! <!-- nswc-ford:begin EIGV -->
!! Reference for `eigv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!            Eigenvalues and eigenvectors of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n), zr(ka,n), zi(ka,n)
!     beginning of local variable declarations
integer :: igh, j, k, kp1, low
real :: nswc_ai_r4
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine balbak(nm,n,low,igh,scale,m,z)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(in) :: scale(n)
      real, intent(inout) :: z(nm,m)
   end subroutine balbak
   pure subroutine elmhs0(nm,n,low,igh,a,int)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: int(igh)
   end subroutine elmhs0
   pure subroutine eltrn0(nm,n,low,igh,a,int,z)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(in) :: a(nm,igh)
      real, intent(in) :: int(igh)
      real, intent(inout) :: z(nm,n)
   end subroutine eltrn0
   pure subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      real, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine hqr2
end interface
!-----------------------------------------------------------------------
!           Eigenvalues and eigenvectors of real matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,zi)
call elmhs0(ka,n,low,igh,a,wr)
call eltrn0(ka,n,low,igh,a,wr,zr)
call hqr2(ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr /= 0) return
if (ibal /= 0) call balbak(ka,n,low,igh,zi,n,zr)
do k = 1,n
   nswc_ai_r4 = wi(k)
   if (nswc_ai_r4 < 0) go to 30
   if (nswc_ai_r4 == 0) go to 10
   go to 20
10 do j = 1,n
      zi(j,k) = 0.0
   end do
   go to 30
20 kp1 = k + 1
   do j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
      zi(j,kp1) = -zi(j,k)
   end do
30 continue
end do
end subroutine eigv

pure subroutine eigv1(ibal,a,ka,n,wr,wi,zr,zi,ierr)
!! <!-- nswc-ford:begin EIGV1 -->
!! Reference for `eigv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!            Eigenvalues and eigenvectors of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n), zr(ka,n), zi(ka,n)
!     beginning of local variable declarations
integer :: igh, j, k, kp1, low
real :: nswc_ai_r4
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine balbak(nm,n,low,igh,scale,m,z)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(in) :: scale(n)
      real, intent(inout) :: z(nm,m)
   end subroutine balbak
   pure subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      real, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine hqr2
   pure subroutine orthes(nm,n,low,igh,a,ort)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: ort(igh)
   end subroutine orthes
   pure subroutine ortran(nm,n,low,igh,a,ort,z)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(in) :: a(nm,igh)
      real, intent(inout) :: ort(igh)
      real, intent(inout) :: z(nm,n)
   end subroutine ortran
end interface
!-----------------------------------------------------------------------
!           Eigenvalues and eigenvectors of real matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,zi)
call orthes(ka,n,low,igh,a,wr)
call ortran(ka,n,low,igh,a,wr,zr)
call hqr2(ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr /= 0) return
if (ibal /= 0) call balbak(ka,n,low,igh,zi,n,zr)
do k = 1,n
   nswc_ai_r4 = wi(k)
   if (nswc_ai_r4 < 0) go to 30
   if (nswc_ai_r4 == 0) go to 10
   go to 20
10 do j = 1,n
      zi(j,k) = 0.0
   end do
   go to 30
20 kp1 = k + 1
   do j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
      zi(j,kp1) = -zi(j,k)
   end do
30 continue
end do
end subroutine eigv1

pure subroutine balanc(nm,n,a,low,igh,scale)
!! <!-- nswc-ford:begin BALANC -->
!! Reference for `balanc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real abs
!!
!!      This subroutine is a translation of the Algol procedure balance,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!!      This subroutine balances a real matrix and isolates
!!      eigenvalues whenever possible.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         a contains the input matrix to be balanced.
!!      On output-
!!         a contains the balanced matrix,
!!         low and igh are two integers such that a(i,j)
!!           is equal to zero if
!!            (1) i is greater than j and
!!            (2) j=1,...,low-1 OR i=igh+1,...,n,
!!         scale contains information determining the
!!            permutations and scaling factors used.
!!      Suppose that the principal submatrix in rows low through igh
!!      has been balanced, that P(j) denotes the index interchanged
!!      with j during the permutation step, and that the elements
!!      of the diagonal matrix used are denoted by D(i,j).  Then
!!         scale(j) = P(j),    FOR j = 1,...,low-1
!!                  = D(j,j),      j = low,...,igh
!!                  = P(j)         j = igh+1,...,n.
!!      The order in which the interchanges are made is n to igh+1,
!!      then 1 to low-1.
!!      Note that 1 is returned for igh if igh is zero formally.
!!      The Algol procedure exc contained in balance appears in
!!      balanc  in line.  (Note that the Algol roles of identifiers
!!      k,l have been reversed.)
!!
!!      ********** radix is a machine dependent parameter specifying
!!                 the base of the machine floating point representation.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
real, intent(inout) :: a(nm,n), scale(n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, jj, iexc
real :: c, f, g, r, s, b2, radix
logical :: noconv
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!     real abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!     This subroutine balances a real matrix and isolates
!     eigenvalues whenever possible.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        a contains the input matrix to be balanced.
!     On output-
!        a contains the balanced matrix,
!        low and igh are two integers such that a(i,j)
!          is equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!        scale contains information determining the
!           permutations and scaling factors used.
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j),      j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!     Note that 1 is returned for igh if igh is zero formally.
!     The Algol procedure exc contained in balance appears in
!     balanc  in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!-----------------------------------------------------------------------
!     ********** radix is a machine dependent parameter specifying
!                the base of the machine floating point representation.
radix = ipmpar(4)
!                **********
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** In-line procedure for row and
!                column exchange **********
20 scale(m) = j
if (j == m) go to 50
do i = 1, l
   f = a(i,j)
   a(i,j) = a(i,m)
   a(i,m) = f
end do
do i = k, n
   f = a(j,i)
   a(j,i) = a(m,i)
   a(m,i) = f
end do
50 select case (iexc)
case (1)
   go to 80
case (2)
   go to 130
end select
!     ********** Search for rows isolating an eigenvalue
!                and push them down **********
80 if (l == 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do jj = 1, l
   j = l + 1 - jj
   do i = 1, l
      if (i == j) go to 110
      if (a(j,i) /= 0.0) go to 120
110   continue
   end do
   m = l
   iexc = 1
   go to 20
120 continue
end do
go to 140
!     ********** Search for columns isolating an eigenvalue
!                and push them left **********
130 k = k + 1
140 do j = k, l
   do i = k, l
      if (i == j) go to 150
      if (a(i,j) /= 0.0) go to 170
150   continue
   end do
   m = k
   iexc = 2
   go to 20
170 continue
end do
!     ********** Now balance the submatrix in rows k to l **********
do i = k, l
   scale(i) = 1.0
end do
!     ********** Iterative loop for norm reduction **********
190 noconv = .false.
do i = k, l
   c = 0.0
   r = 0.0
   do j = k, l
      if (j == i) go to 200
      c = c + abs(a(j,i))
      r = r + abs(a(i,j))
200   continue
   end do
!     ********** Guard against zero c or r due to underflow **********
   if (c == 0.0 .or. r == 0.0) go to 270
   g = r / radix
   f = 1.0
   s = c + r
210 if (c >= g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c < g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** Now balance **********
240 if ((c + r) / f >= 0.95 * s) go to 270
   g = 1.0 / f
   scale(i) = scale(i) * f
   noconv = .true.
   do j = k, n
      a(i,j) = a(i,j) * g
   end do
   do j = 1, l
      a(j,i) = a(j,i) * f
   end do
270 continue
end do
if (noconv) go to 190
280 low = k
igh = l
end subroutine balanc

pure subroutine balinv(nz,n,z,low,igh,scale)
!! <!-- nswc-ford:begin BALINV -->
!! Reference for `balinv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Given A matrix A of order n. balanc transforms A into
!!      the matrix B by the similarity transformation
!!              b = d**(-1)*transpose(p)*a*p*d
!!      where D is a diagonal matrix and P a permutation matrix.
!!      The information concerning D and P is stored in igh, low,
!!      and scale. The order in which the interchanges were made
!!      is n to igh + 1, and then 1 to low - 1.
!!         z is a matrix of order n. balinv transforms z into the
!!      matrix W using the inverse similarity transform
!!              w = p*d*z*d**(-1)*transpose(p)
!!      on input-
!!         nz is the row dimension of the matrix z in the calling
!!           program,
!!         n is the order of the matrix,
!!         low and igh are integers determined by  balanc,
!!         scale contains information determining the permutations
!!           and scaling factors used by  balanc,
!!      on output-
!!         z contains the transformed matrix W
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nz, igh, low
real, intent(inout) :: z(nz,n)
real, intent(in) :: scale(n)
!     beginning of local variable declarations
integer :: i, j, k, ii
real :: s
!-----------------------------------------------------------------------
!        Given A matrix A of order n. balanc transforms A into
!     the matrix B by the similarity transformation
!             b = d**(-1)*transpose(p)*a*p*d
!     where D is a diagonal matrix and P a permutation matrix.
!     The information concerning D and P is stored in igh, low,
!     and scale. The order in which the interchanges were made
!     is n to igh + 1, and then 1 to low - 1.
!        z is a matrix of order n. balinv transforms z into the
!     matrix W using the inverse similarity transform
!             w = p*d*z*d**(-1)*transpose(p)
!     on input-
!        nz is the row dimension of the matrix z in the calling
!          program,
!        n is the order of the matrix,
!        low and igh are integers determined by  balanc,
!        scale contains information determining the permutations
!          and scaling factors used by  balanc,
!     on output-
!        z contains the transformed matrix W
!-----------------------------------------------------------------------
if (igh == low) go to 30
do i = low, igh
   s = scale(i)
   do j = 1, n
      z(i,j) = z(i,j) * s
   end do
end do
do j = low, igh
   s = 1.0/scale(j)
   do i = 1, n
      z(i,j) = z(i,j) * s
   end do
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
30 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 60
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 60
   do j = 1, n
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
   do j = 1, n
      s = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = s
   end do
60 continue
end do
end subroutine balinv

pure subroutine elmhes(nm,n,low,igh,a,int)
!! <!-- nswc-ford:begin ELMHES -->
!! Reference for `elmhes`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real abs
!!
!!      This subroutine is a translation of the Algol procedure elmhes,
!!      NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!!      Given a real general matrix, this subroutine
!!      reduces a submatrix situated in rows and columns
!!      low through igh to upper Hessenberg form by
!!      stabilized elementary similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains the input matrix.
!!      On output-
!!         a contains the Hessenberg matrix.  The multipliers
!!           which were used in the reduction are stored in the
!!           remaining triangle under the Hessenberg matrix,
!!         int contains information on the rows and columns
!!           interchanged in the reduction.
!!           Only elements low through igh are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: a(nm,n)
integer, intent(inout) :: int(igh)
!     beginning of local variable declarations
integer :: i, j, m, la, kp1, mm1, mp1
real :: x, y
!     real abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure elmhes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     stabilized elementary similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains the input matrix.
!     On output-
!        a contains the Hessenberg matrix.  The multipliers
!          which were used in the reduction are stored in the
!          remaining triangle under the Hessenberg matrix,
!        int contains information on the rows and columns
!          interchanged in the reduction.
!          Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   mm1 = m - 1
   x = 0.0
   i = m
   do j = m, igh
      if (abs(a(j,mm1)) <= abs(x)) go to 100
      x = a(j,mm1)
      i = j
100   continue
   end do
   int(m) = i
   if (i == m) go to 130
!    ********** Interchange rows and columns of a **********
   do j = mm1, n
      y = a(i,j)
      a(i,j) = a(m,j)
      a(m,j) = y
   end do
   do j = 1, igh
      y = a(j,i)
      a(j,i) = a(j,m)
      a(j,m) = y
   end do
!    ********** End interchange **********
130 if (x == 0.0) go to 180
   mp1 = m + 1
   do i = mp1, igh
      y = a(i,mm1)
      if (y == 0.0) go to 160
      y = y / x
      a(i,mm1) = y
      do j = m, n
         a(i,j) = a(i,j) - y * a(m,j)
      end do
      do j = 1, igh
         a(j,m) = a(j,m) + y * a(j,i)
      end do
160   continue
   end do
180 continue
end do
200 return
end subroutine elmhes

pure subroutine elmhs0(nm,n,low,igh,a,int)
!! <!-- nswc-ford:begin ELMHS0 -->
!! Reference for `elmhs0`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real abs
!!
!!      This subroutine is a translation of the Algol procedure elmhes,
!!      NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!!      Given a real general matrix, this subroutine
!!      reduces a submatrix situated in rows and columns
!!      low through igh to upper Hessenberg form by
!!      stabilized elementary similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains the input matrix.
!!      On output-
!!         a contains the Hessenberg matrix.  The multipliers
!!           which were used in the reduction are stored in the
!!           remaining triangle under the Hessenberg matrix,
!!         int contains information on the rows and columns
!!           interchanged in the reduction.
!!           Only elements low through igh are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: a(nm,n)
real, intent(inout) :: int(igh)
!     beginning of local variable declarations
integer :: i, j, m, la, kp1, mm1, mp1
real :: x, y
!     real abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure elmhes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     stabilized elementary similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains the input matrix.
!     On output-
!        a contains the Hessenberg matrix.  The multipliers
!          which were used in the reduction are stored in the
!          remaining triangle under the Hessenberg matrix,
!        int contains information on the rows and columns
!          interchanged in the reduction.
!          Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   mm1 = m - 1
   x = 0.0
   i = m
   do j = m, igh
      if (abs(a(j,mm1)) <= abs(x)) go to 100
      x = a(j,mm1)
      i = j
100   continue
   end do
   int(m) = i
   if (i == m) go to 130
!    ********** Interchange rows and columns of a **********
   do j = mm1, n
      y = a(i,j)
      a(i,j) = a(m,j)
      a(m,j) = y
   end do
   do j = 1, igh
      y = a(j,i)
      a(j,i) = a(j,m)
      a(j,m) = y
   end do
!    ********** End interchange **********
130 if (x == 0.0) go to 180
   mp1 = m + 1
   do i = mp1, igh
      y = a(i,mm1)
      if (y == 0.0) go to 160
      y = y / x
      a(i,mm1) = y
      do j = m, n
         a(i,j) = a(i,j) - y * a(m,j)
      end do
      do j = 1, igh
         a(j,m) = a(j,m) + y * a(j,i)
      end do
160   continue
   end do
180 continue
end do
200 return
end subroutine elmhs0

pure subroutine orthes(nm,n,low,igh,a,ort)
!! <!-- nswc-ford:begin ORTHES -->
!! Reference for `orthes`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs
!!
!!      This subroutine is a translation of the Algol procedure orthes,
!!      NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!!      Given a real general matrix, this subroutine
!!      reduces a submatrix situated in rows and columns
!!      low through igh to upper Hessenberg form by
!!      orthogonal similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains the input matrix.
!!      On output-
!!         a contains the Hessenberg matrix.  Information about
!!           the orthogonal transformations used in the reduction
!!           is stored in the remaining triangle under the
!!           Hessenberg matrix,
!!         ort contains further information about the transformations.
!!           Only elements low through igh are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: a(nm,n), ort(igh)
!     beginning of local variable declarations
integer :: i, j, m, ii, jj, la, mp, kp1
real :: f, g, h, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure orthes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     orthogonal similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains the input matrix.
!     On output-
!        a contains the Hessenberg matrix.  Information about
!          the orthogonal transformations used in the reduction
!          is stored in the remaining triangle under the
!          Hessenberg matrix,
!        ort contains further information about the transformations.
!          Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   h = 0.0
   ort(m) = 0.0
   scale = 0.0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do i = m, igh
      scale = scale + abs(a(i,m - 1))
   end do
   if (scale == 0.0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ort(i) = a(i,m - 1) / scale
      h = h + ort(i) * ort(i)
   end do
   g = sqrt(h)
   if (ort(m) >= 0.0) g = -g
   h = h - ort(m) * g
   ort(m) = ort(m) - g
!     ********** FORM (i-(U*UT)/h) * a **********
   do j = m, n
      f = 0.0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         f = f + ort(i) * a(i,j)
      end do
      f = f / h
      do i = m, igh
         a(i,j) = a(i,j) - f * ort(i)
      end do
   end do
!     ********** FORM (i-(U*UT)/h)*a*(i-(U*UT)/h) **********
   do i = 1, igh
      f = 0.0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         f = f + ort(j) * a(i,j)
      end do
      f = f / h
      do j = m, igh
         a(i,j) = a(i,j) - f * ort(j)
      end do
   end do
   ort(m) = scale * ort(m)
   a(m,m - 1) = scale * g
180 continue
end do
200 return
end subroutine orthes

pure subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
!! <!-- nswc-ford:begin HQR -->
!! Reference for `hqr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs
!!      integer min0
!!
!!      This subroutine is a translation of the Algol procedure hqr,
!!      NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!!      This subroutine finds the eigenvalues of a real
!!      upper Hessenberg matrix BY the QR method.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         h contains the upper Hessenberg matrix.  Information about
!!           the transformations used in the reduction to Hessenberg
!!           form by  elmhes  or  orthes, if performed, is stored
!!           in the remaining triangle under the Hessenberg matrix.
!!      On output-
!!         h has been destroyed.  Therefore, it must be saved
!!           before calling  hqr  if subsequent calculation and
!!           back transformation of eigenvectors is to be performed,
!!         wr and wi contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  The eigenvalues
!!           are unordered except that complex conjugate pairs
!!           of values appear consecutively with the eigenvalue
!!           having the positive imaginary part first.  If an
!!           error exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: h(nm,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ll, mm, na, its, mp2, enm2
real :: p, q, r, s, t, w, x, y, zz, norm, machep
logical :: notlas
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs
!     integer min0
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure hqr,
!     NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!     This subroutine finds the eigenvalues of a real
!     upper Hessenberg matrix BY the QR method.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        h contains the upper Hessenberg matrix.  Information about
!          the transformations used in the reduction to Hessenberg
!          form by  elmhes  or  orthes, if performed, is stored
!          in the remaining triangle under the Hessenberg matrix.
!     On output-
!        h has been destroyed.  Therefore, it must be saved
!          before calling  hqr  if subsequent calculation and
!          back transformation of eigenvectors is to be performed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = spmpar(1)
!                **********
ierr = 0
norm = 0.0
k = 1
!     ********** Store roots isolated by balanc
!                and compute matrix norm **********
do i = 1, n
   do j = k, n
      norm = norm + abs(h(i,j))
   end do
   k = i
   if (i >= low .and. i <= igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.0
50 continue
end do
en = igh
t = 0.0
!     ********** Search for next eigenvalues **********
60 if (en < low) go to 1001
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
70 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.0) s = norm
   if (abs(h(l , l - 1)) <= machep * s) exit
end do
!     ********** Form shift **********
x = h(en,en)
if (l == en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l == na) go to 280
if (its == 30) go to 1000
if (its /= 10 .and. its /= 20) go to 130
!     ********** Form exceptional shift **********
t = t + x
do i = low, en
   h(i,i) = h(i,i) - x
end do
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75 * s
y = x
w = -0.4375 * s * s
130 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m == l) exit
   if (abs(h(m,m - 1)) * (abs(q) + abs(r)) <= machep * abs(p) &
      & * (abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))) go to 150
end do
150 mp2 = m + 2
do i = mp2, en
   h(i,i - 2) = 0.0
   if (i == mp2) go to 160
   h(i,i - 3) = 0.0
160 continue
end do
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do k = m, na
   notlas = k /= na
   if (k == m) go to 170
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p < 0.0) s = -s
   if (k == m) go to 180
   h(k,k - 1) = -s * x
   go to 190
180 if (l /= m) h(k,k - 1) = -h(k,k - 1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** Row modification **********
   do j = k, en
      p = h(k,j) + q * h(k + 1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p * zz
200   h(k + 1,j) = h(k + 1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
   j = min(en,k + 3)
!     ********** Column modification **********
   do i = l, j
      p = x * h(i,k) + y * h(i,k + 1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p * r
220   h(i,k + 1) = h(i,k + 1) - p * q
      h(i,k) = h(i,k) - p
   end do
260 continue
end do
go to 70
!     ********** One root found **********
270 wr(en) = x + t
wi(en) = 0.0
en = na
go to 60
!     ********** Two roots found **********
280 p = (y - x) / 2.0
q = p * p + w
zz = sqrt(abs(q))
x = x + t
if (q < 0.0) go to 320
!     ********** Real pair **********
if (p < 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.0) wr(en) = x - w / zz
wi(na) = 0.0
wi(en) = 0.0
go to 330
!     ********** Complex pair **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
end subroutine hqr

pure subroutine balbak(nm,n,low,igh,scale,m,z)
!! <!-- nswc-ford:begin BALBAK -->
!! Reference for `balbak`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure balbak,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!!      This subroutine forms the eigenvectors of a real general
!!      matrix BY back transforming those of the corresponding
!!      balanced matrix determined by  balanc.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by  balanc,
!!         scale contains information determining the permutations
!!           and scaling factors used by  balanc,
!!         m is the number of columns of z to be back transformed,
!!         z contains the real and imaginary parts of the eigen-
!!           vectors to be back transformed in its first m columns.
!!      On output-
!!         z contains the real and imaginary parts of the
!!           transformed eigenvectors in its first m columns.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
real, intent(in) :: scale(n)
real, intent(inout) :: z(nm,m)
!     beginning of local variable declarations
integer :: i, j, k, ii
real :: s
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!     This subroutine forms the eigenvectors of a real general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by  balanc.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by  balanc,
!        scale contains information determining the permutations
!          and scaling factors used by  balanc,
!        m is the number of columns of z to be back transformed,
!        z contains the real and imaginary parts of the eigen-
!          vectors to be back transformed in its first m columns.
!     On output-
!        z contains the real and imaginary parts of the
!          transformed eigenvectors in its first m columns.
!-----------------------------------------------------------------------
if (m == 0) go to 200
if (igh == low) go to 120
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      z(i,j) = z(i,j) * s
   end do
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
120 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
   do j = 1, m
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
140 continue
end do
200 return
end subroutine balbak

pure subroutine eltran(nm,n,low,igh,a,int,z)
!! <!-- nswc-ford:begin ELTRAN -->
!! Reference for `eltran`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure ELMTRANS,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!!      This subroutine accumulates the stabilized elementary
!!      similarity transformations used in the reduction of A
!!      real general matrix to upper Hessenberg form by  elmhes.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains the multipliers which were used in the
!!           reduction by  elmhes  in its lower triangle
!!           below the subdiagonal,
!!         int contains information on the rows and columns
!!           interchanged in the reduction by  elmhes.
!!           Only elements low through igh are used.
!!      On output-
!!         z contains the transformation matrix produced in the
!!           reduction by  elmhes.
!!
!!      ********** Initialize z to identity matrix **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
real, intent(in) :: a(nm,igh)
real, intent(inout) :: z(nm,n)
integer, intent(in) :: int(igh)
!     beginning of local variable declarations
integer :: i, j, kl, mm, mp, mp1
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure ELMTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!     This subroutine accumulates the stabilized elementary
!     similarity transformations used in the reduction of A
!     real general matrix to upper Hessenberg form by  elmhes.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains the multipliers which were used in the
!          reduction by  elmhes  in its lower triangle
!          below the subdiagonal,
!        int contains information on the rows and columns
!          interchanged in the reduction by  elmhes.
!          Only elements low through igh are used.
!     On output-
!        z contains the transformation matrix produced in the
!          reduction by  elmhes.
!-----------------------------------------------------------------------
!     ********** Initialize z to identity matrix **********
do i = 1, n
   do j = 1, n
      z(i,j) = 0.0
   end do
   z(i,i) = 1.0
end do
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do mm = 1, kl
   mp = igh - mm
   mp1 = mp + 1
   do i = mp1, igh
      z(i,mp) = a(i,mp - 1)
   end do
   i = int(mp)
   if (i == mp) go to 140
   do j = mp, igh
      z(mp,j) = z(i,j)
      z(i,j) = 0.0
   end do
   z(i,mp) = 1.0
140 continue
end do
200 return
end subroutine eltran

pure subroutine eltrn0(nm,n,low,igh,a,int,z)
!! <!-- nswc-ford:begin ELTRN0 -->
!! Reference for `eltrn0`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure ELMTRANS,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!!      This subroutine accumulates the stabilized elementary
!!      similarity transformations used in the reduction of A
!!      real general matrix to upper Hessenberg form by  elmhs0.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains the multipliers which were used in the
!!           reduction by  elmhs0  in its lower triangle
!!           below the subdiagonal,
!!         int contains information on the rows and columns
!!           interchanged in the reduction by  elmhs0.
!!           Only elements low through igh are used.
!!      On output-
!!         z contains the transformation matrix produced in the
!!           reduction by  elmhs0.
!!
!!      ********** Initialize z to identity matrix **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
real, intent(in) :: a(nm,igh)
real, intent(inout) :: z(nm,n)
real, intent(in) :: int(igh)
!     beginning of local variable declarations
integer :: i, j, kl, mm, mp, mp1
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure ELMTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!     This subroutine accumulates the stabilized elementary
!     similarity transformations used in the reduction of A
!     real general matrix to upper Hessenberg form by  elmhs0.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains the multipliers which were used in the
!          reduction by  elmhs0  in its lower triangle
!          below the subdiagonal,
!        int contains information on the rows and columns
!          interchanged in the reduction by  elmhs0.
!          Only elements low through igh are used.
!     On output-
!        z contains the transformation matrix produced in the
!          reduction by  elmhs0.
!-----------------------------------------------------------------------
!     ********** Initialize z to identity matrix **********
do i = 1, n
   do j = 1, n
      z(i,j) = 0.0
   end do
   z(i,i) = 1.0
end do
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do mm = 1, kl
   mp = igh - mm
   mp1 = mp + 1
   do i = mp1, igh
      z(i,mp) = a(i,mp - 1)
   end do
   i = int(mp)
   if (i == mp) go to 140
   do j = mp, igh
      z(mp,j) = z(i,j)
      z(i,j) = 0.0
   end do
   z(i,mp) = 1.0
140 continue
end do
200 return
end subroutine eltrn0

pure subroutine ortran(nm,n,low,igh,a,ort,z)
!! <!-- nswc-ford:begin ORTRAN -->
!! Reference for `ortran`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure ORTRANS,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!!      This subroutine accumulates the orthogonal similarity
!!      transformations used in the reduction of a real general
!!      matrix to upper Hessenberg form by  orthes.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains information about the orthogonal trans-
!!           formations used in the reduction by  orthes
!!           in its strict lower triangle,
!!         ort contains further information about the trans-
!!           formations used in the reduction by  orthes.
!!           Only elements low through igh are used.
!!      On output-
!!         z contains the transformation matrix produced in the
!!           reduction by  orthes,
!!         ort has been altered.
!!
!!      ********** Initialize z to identity matrix **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
real, intent(in) :: a(nm,igh)
real, intent(inout) :: ort(igh), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, kl, mm, mp, mp1
real :: g
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real general
!     matrix to upper Hessenberg form by  orthes.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains information about the orthogonal trans-
!          formations used in the reduction by  orthes
!          in its strict lower triangle,
!        ort contains further information about the trans-
!          formations used in the reduction by  orthes.
!          Only elements low through igh are used.
!     On output-
!        z contains the transformation matrix produced in the
!          reduction by  orthes,
!        ort has been altered.
!-----------------------------------------------------------------------
!     ********** Initialize z to identity matrix **********
do i = 1, n
   do j = 1, n
      z(i,j) = 0.0
   end do
   z(i,i) = 1.0
end do
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do mm = 1, kl
   mp = igh - mm
   if (a(mp,mp - 1) == 0.0) go to 140
   mp1 = mp + 1
   do i = mp1, igh
      ort(i) = a(i,mp - 1)
   end do
   do j = mp, igh
      g = 0.0
      do i = mp, igh
         g = g + ort(i) * z(i,j)
      end do
!     ********** Divisor below is negative of H formed in orthes.
!                Double division avoids possible underflow **********
      g = (g / ort(mp)) / a(mp,mp - 1)
      do i = mp, igh
         z(i,j) = z(i,j) + g * ort(i)
      end do
   end do
140 continue
end do
200 return
end subroutine ortran

pure subroutine ortrn1(n,low,igh,a,na,z,nz,ort)
!! <!-- nswc-ford:begin ORTRN1 -->
!! Reference for `ortrn1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure ORTRANS,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!!      This subroutine accumulates the orthogonal similarity
!!      transformations used in the reduction of a real general
!!      matrix to upper Hessenberg form by  orthes.
!!      On input-
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         a contains information about the orthogonal trans-
!!           formations used in the reduction by  orthes
!!           in its strict lower triangle,
!!         na must be set to the row dimension of the 2-dimensional
!!           array parameter  a  as declared in the calling program
!!           dimension statement,
!!         nz must be set to the row dimension of the 2-dimensional
!!           array parameter  z  as declared in the calling program
!!           dimension statement,
!!         ort contains further information about the trans-
!!           formations used in the reduction by  orthes.
!!           Only elements low through igh are used.
!!      On output-
!!         z contains the transformation matrix produced in the
!!           reduction by  orthes,
!!         ort has been altered.
!!
!!      ********** Initialize z to identity matrix **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: na, igh, low
integer, intent(in) :: nz
real, intent(in) :: a(na,igh)
real, intent(inout) :: ort(igh), z(nz,n)
!     beginning of local variable declarations
integer :: i, j, kl, mm, mp, mp1
real :: g
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real general
!     matrix to upper Hessenberg form by  orthes.
!     On input-
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        a contains information about the orthogonal trans-
!          formations used in the reduction by  orthes
!          in its strict lower triangle,
!        na must be set to the row dimension of the 2-dimensional
!          array parameter  a  as declared in the calling program
!          dimension statement,
!        nz must be set to the row dimension of the 2-dimensional
!          array parameter  z  as declared in the calling program
!          dimension statement,
!        ort contains further information about the trans-
!          formations used in the reduction by  orthes.
!          Only elements low through igh are used.
!     On output-
!        z contains the transformation matrix produced in the
!          reduction by  orthes,
!        ort has been altered.
!-----------------------------------------------------------------------
!     ********** Initialize z to identity matrix **********
do i = 1, n
   do j = 1, n
      z(i,j) = 0.0
   end do
   z(i,i) = 1.0
end do
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do mm = 1, kl
   mp = igh - mm
   if (a(mp,mp - 1) == 0.0) go to 140
   mp1 = mp + 1
   do i = mp1, igh
      ort(i) = a(i,mp - 1)
   end do
   do j = mp, igh
      g = 0.0
      do i = mp, igh
         g = g + ort(i) * z(i,j)
      end do
!     ********** Divisor below is negative of H formed in orthes.
!                Double division avoids possible underflow **********
      g = (g / ort(mp)) / a(mp,mp - 1)
      do i = mp, igh
         z(i,j) = z(i,j) + g * ort(i)
      end do
   end do
140 continue
end do
200 return
end subroutine ortrn1

pure subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
!! <!-- nswc-ford:begin HQR2 -->
!! Reference for `hqr2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs
!!      integer min0
!!      complex cmplx
!!      real real,aimag
!!
!!      This subroutine is a translation of the Algol procedure hqr2,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!!      This subroutine finds the eigenvalues and eigenvectors
!!      of a real upper Hessenberg matrix BY the QR method.  The
!!      eigenvectors of a real general matrix can also be found
!!      if  elmhes  and  eltran  or  orthes  and  ortran  have
!!      been used to reduce this general matrix to Hessenberg form
!!      and to accumulate the similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  balanc.  If  balanc  has not been used,
!!           set low=1, igh=n,
!!         h contains the upper Hessenberg matrix,
!!         z contains the transformation matrix produced by  eltran
!!           after the reduction by  elmhes, or by  ortran  after the
!!           reduction by  orthes, if performed.  If the eigenvectors
!!           of the Hessenberg matrix are desired, z must contain the
!!           identity matrix.
!!      On output-
!!         h has been destroyed,
!!         wr and wi contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  The eigenvalues
!!           are unordered except that complex conjugate pairs
!!           of values appear consecutively with the eigenvalue
!!           having the positive imaginary part first.  If an
!!           error exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         z contains the real and imaginary parts of the eigenvectors.
!!           If the i-TH eigenvalue is real, the i-TH column of z
!!           contains its eigenvector.  If the i-TH eigenvalue is complex
!!           with positive imaginary part, the i-TH and (i+1)-TH
!!           columns of z contain the real and imaginary parts of its
!!           eigenvector.  The eigenvectors are unnormalized.  If an
!!           error exit is made, none of the eigenvectors has been found,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!      Arithmetic is real except for the replacement of the Algol
!!      procedure cdiv by complex division.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: h(nm,n), wr(n), wi(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ii, jj, ll, mm, na, nn, its, mp2, enm2
real :: p, q, r, s, t, w, x, y, ra, sa, vi, vr, zz, norm, machep, nswc_ai_r4
logical :: notlas
complex :: z3
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs
!     integer min0
!     complex cmplx
!     real real,aimag
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure hqr2,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     This subroutine finds the eigenvalues and eigenvectors
!     of a real upper Hessenberg matrix BY the QR method.  The
!     eigenvectors of a real general matrix can also be found
!     if  elmhes  and  eltran  or  orthes  and  ortran  have
!     been used to reduce this general matrix to Hessenberg form
!     and to accumulate the similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!        h contains the upper Hessenberg matrix,
!        z contains the transformation matrix produced by  eltran
!          after the reduction by  elmhes, or by  ortran  after the
!          reduction by  orthes, if performed.  If the eigenvectors
!          of the Hessenberg matrix are desired, z must contain the
!          identity matrix.
!     On output-
!        h has been destroyed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        z contains the real and imaginary parts of the eigenvectors.
!          If the i-TH eigenvalue is real, the i-TH column of z
!          contains its eigenvector.  If the i-TH eigenvalue is complex
!          with positive imaginary part, the i-TH and (i+1)-TH
!          columns of z contain the real and imaginary parts of its
!          eigenvector.  The eigenvectors are unnormalized.  If an
!          error exit is made, none of the eigenvectors has been found,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = spmpar(1)
!                **********
ierr = 0
norm = 0.0
k = 1
!     ********** Store roots isolated by balanc
!                and compute matrix norm **********
do i = 1, n
   do j = k, n
      norm = norm + abs(h(i,j))
   end do
   k = i
   if (i >= low .and. i <= igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.0
50 continue
end do
en = igh
t = 0.0
!     ********** Search for next eigenvalues **********
60 if (en < low) go to 340
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
70 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.0) s = norm
   if (abs(h(l , l - 1)) <= machep * s) exit
end do
!     ********** Form shift **********
x = h(en,en)
if (l == en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l == na) go to 280
if (its == 30) go to 1000
if (its /= 10 .and. its /= 20) go to 130
!     ********** Form exceptional shift **********
t = t + x
do i = low, en
   h(i,i) = h(i,i) - x
end do
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75 * s
y = x
w = -0.4375 * s * s
130 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m == l) exit
   if (abs(h(m,m - 1)) * (abs(q) + abs(r)) <= machep * abs(p) &
      & * (abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))) go to 150
end do
150 mp2 = m + 2
do i = mp2, en
   h(i,i - 2) = 0.0
   if (i == mp2) go to 160
   h(i,i - 3) = 0.0
160 continue
end do
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do k = m, na
   notlas = k /= na
   if (k == m) go to 170
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p < 0.0) s = -s
   if (k == m) go to 180
   h(k,k - 1) = -s * x
   go to 190
180 if (l /= m) h(k,k - 1) = -h(k,k - 1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** Row modification **********
   do j = k, n
      p = h(k,j) + q * h(k + 1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p * zz
200   h(k + 1,j) = h(k + 1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
   j = min(en,k + 3)
!     ********** Column modification **********
   do i = 1, j
      p = x * h(i,k) + y * h(i,k + 1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p * r
220   h(i,k + 1) = h(i,k + 1) - p * q
      h(i,k) = h(i,k) - p
   end do
!     ********** Accumulate transformations **********
   do i = low, igh
      p = x * z(i,k) + y * z(i,k + 1)
      if (.not. notlas) go to 240
      p = p + zz * z(i,k + 2)
      z(i,k + 2) = z(i,k + 2) - p * r
240   z(i,k + 1) = z(i,k + 1) - p * q
      z(i,k) = z(i,k) - p
   end do
260 continue
end do
go to 70
!     ********** One root found **********
270 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.0
en = na
go to 60
!     ********** Two roots found **********
280 p = (y - x) / 2.0
q = p * p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q < 0.0) go to 320
!     ********** Real pair **********
if (p < 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.0) wr(en) = x - w / zz
wi(na) = 0.0
wi(en) = 0.0
x = h(en,na)
s = abs(x) + abs(zz)
p = x / s
q = zz / s
r = sqrt(p*p + q*q)
p = p / r
q = q / r
!     ********** Row modification **********
do j = na, n
   zz = h(na,j)
   h(na,j) = q * zz + p * h(en,j)
   h(en,j) = q * h(en,j) - p * zz
end do
!     ********** Column modification **********
do i = 1, en
   zz = h(i,na)
   h(i,na) = q * zz + p * h(i,en)
   h(i,en) = q * h(i,en) - p * zz
end do
!     ********** Accumulate transformations **********
do i = low, igh
   zz = z(i,na)
   z(i,na) = q * zz + p * z(i,en)
   z(i,en) = q * z(i,en) - p * zz
end do
go to 330
!     ********** Complex pair **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
340 if (norm == 0.0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 1 DO -- **********
do nn = 1, n
   en = n + 1 - nn
   p = wr(en)
   q = wi(en)
   na = en - 1
   nswc_ai_r4 = q
   if (nswc_ai_r4 < 0) go to 710
   if (nswc_ai_r4 == 0) go to 600
   go to 800
!     ********** Real vector **********
600 m = en
   h(en,en) = 1.0
   if (na == 0) go to 800
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, na
      i = en - ii
      w = h(i,i) - p
      r = h(i,en)
      if (m > na) go to 620
      do j = m, na
         r = r + h(i,j) * h(j,en)
      end do
620   if (wi(i) >= 0.0) go to 630
      zz = w
      s = r
      go to 700
630   m = i
      if (wi(i) /= 0.0) go to 640
      t = w
      if (w == 0.0) t = machep * norm
      h(i,en) = -r / t
      go to 700
!     ********** Solve real equations **********
640   x = h(i,i + 1)
      y = h(i + 1,i)
      q = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i)
      t = (x * s - zz * r) / q
      h(i,en) = t
      if (abs(x) <= abs(zz)) go to 650
      h(i + 1,en) = (-r - w * t) / x
      go to 700
650   h(i + 1,en) = (-s - y * t) / zz
700   continue
   end do
!     ********** End real vector **********
   go to 800
!     ********** Complex vector **********
710 m = na
!     ********** Last vector component chosen imaginary so that
!                eigenvector matrix is triangular **********
   if (abs(h(en,na)) <= abs(h(na,en))) go to 720
   h(na,na) = q / h(en,na)
   h(na,en) = -(h(en,en) - p) / h(en,na)
   go to 730
720 z3 = cmplx(0.0,-h(na,en)) / cmplx(h(na,na) - p,q)
   h(na,na) = real(z3)
   h(na,en) = aimag(z3)
730 h(en,na) = 0.0
   h(en,en) = 1.0
   enm2 = na - 1
   if (enm2 == 0) go to 800
!     ********** FOR i=en-2 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, enm2
      i = na - ii
      w = h(i,i) - p
      ra = 0.0
      sa = h(i,en)
      do j = m, na
         ra = ra + h(i,j) * h(j,na)
         sa = sa + h(i,j) * h(j,en)
      end do
      if (wi(i) >= 0.0) go to 770
      zz = w
      r = ra
      s = sa
      go to 790
770   m = i
      if (wi(i) /= 0.0) go to 780
      z3 = cmplx(-ra,-sa) / cmplx(w,q)
      h(i,na) = real(z3)
      h(i,en) = aimag(z3)
      go to 790
!     ********** Solve complex equations **********
780   x = h(i,i + 1)
      y = h(i + 1,i)
      vr = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i) - q * q
      vi = (wr(i) - p) * 2.0 * q
      if (vr == 0.0 .and. vi == 0.0) vr = machep * norm &
         & * (abs(w) + abs(q) + abs(x) + abs(y) + abs(zz))
      z3 = cmplx(x*r - zz*ra + q*sa,x*s - zz*sa - q*ra) / cmplx(vr,vi)
      h(i,na) = real(z3)
      h(i,en) = aimag(z3)
      if (abs(x) <= abs(zz) + abs(q)) go to 785
      h(i + 1,na) = (-ra - w * h(i,na) + q * h(i,en)) / x
      h(i + 1,en) = (-sa - w * h(i,en) - q * h(i,na)) / x
      go to 790
785   z3 = cmplx(-r - y*h(i,na),-s - y*h(i,en)) / cmplx(zz,q)
      h(i + 1,na) = real(z3)
      h(i + 1,en) = aimag(z3)
790   continue
   end do
!     ********** End complex vector **********
800 continue
end do
!     ********** End back substitution.
!                Vectors of isolated roots **********
do i = 1, n
   if (i >= low .and. i <= igh) go to 840
   do j = i, n
      z(i,j) = h(i,j)
   end do
840 continue
end do
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low do -- **********
do jj = low, n
   j = n + low - jj
   m = min(j,igh)
   do i = low, igh
      zz = 0.0
      do k = low, m
         zz = zz + z(i,k) * h(k,j)
      end do
      z(i,j) = zz
   end do
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
end subroutine hqr2

pure subroutine deig(ibal,a,ka,n,wr,wi,ierr)
!! <!-- nswc-ford:begin DEIG -->
!! Reference for `deig`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Eigenvalues of double precision matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: a(ka,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine dbal(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      double precision, intent(inout) :: scale(n)
   end subroutine dbal
   pure subroutine dhqr(nm,n,low,igh,h,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(inout) :: h(nm,n)
      double precision, intent(inout) :: wr(n)
      double precision, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine dhqr
   pure subroutine dorth(nm,n,low,igh,a,ort)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: a(nm,n)
      double precision, intent(inout) :: ort(igh)
   end subroutine dorth
end interface
!-----------------------------------------------------------------------
!                Eigenvalues of double precision matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call dbal(ka,n,a,low,igh,wr)
call dorth(ka,n,low,igh,a,wr)
call dhqr(ka,n,low,igh,a,wr,wi,ierr)
end subroutine deig

pure subroutine deigv(ibal,a,ka,n,wr,wi,zr,zi,ierr)
!! <!-- nswc-ford:begin DEIGV -->
!! Reference for `deigv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Eigenvalues and eigenvectors of double precision matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: a(ka,n), wr(n), wi(n), &
   & zr(ka,n), zi(ka,n)
!     beginning of local variable declarations
integer :: igh, j, k, kp1, low
double precision :: nswc_ai_r8
interface
   pure subroutine dbabk(nm,n,low,igh,scale,m,z)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(in) :: scale(n)
      double precision, intent(inout) :: z(nm,m)
   end subroutine dbabk
   pure subroutine dbal(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      double precision, intent(inout) :: scale(n)
   end subroutine dbal
   pure subroutine dhqr2(nm,n,low,igh,h,wr,wi,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(inout) :: h(nm,n)
      double precision, intent(inout) :: wr(n)
      double precision, intent(inout) :: wi(n)
      double precision, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine dhqr2
   pure subroutine dorth(nm,n,low,igh,a,ort)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: a(nm,n)
      double precision, intent(inout) :: ort(igh)
   end subroutine dorth
   pure subroutine dortrn(nm,n,low,igh,a,ort,z)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(in) :: a(nm,igh)
      double precision, intent(inout) :: ort(igh)
      double precision, intent(inout) :: z(nm,n)
   end subroutine dortrn
end interface
!-----------------------------------------------------------------------
!     Eigenvalues and eigenvectors of double precision matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call dbal(ka,n,a,low,igh,zi)
call dorth(ka,n,low,igh,a,wr)
call dortrn(ka,n,low,igh,a,wr,zr)
call dhqr2(ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr /= 0) return
if (ibal /= 0) call dbabk(ka,n,low,igh,zi,n,zr)
do k = 1,n
   nswc_ai_r8 = wi(k)
   if (nswc_ai_r8 < 0) go to 30
   if (nswc_ai_r8 == 0) go to 10
   go to 20
10 do j = 1,n
      zi(j,k) = 0.d0
   end do
   go to 30
20 kp1 = k + 1
   do j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
      zi(j,kp1) = -zi(j,k)
   end do
30 continue
end do
end subroutine deigv

pure subroutine dbal(nm,n,a,low,igh,scale)
!! <!-- nswc-ford:begin DBAL -->
!! Reference for `dbal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision dabs
!!
!!      This subroutine is a translation of the Algol procedure balance,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!!      Dbal balances a double precision real matrix and isolates
!!      eigenvalues whenever possible.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         a contains the input matrix to be balanced.
!!      On output-
!!         a contains the balanced matrix,
!!         low and igh are two integers such that a(i,j)
!!           is equal to zero if
!!            (1) i is greater than j and
!!            (2) j=1,...,low-1 OR i=igh+1,...,n,
!!         scale contains information determining the
!!            permutations and scaling factors used.
!!      Suppose that the principal submatrix in rows low through igh
!!      has been balanced, that P(j) denotes the index interchanged
!!      with j during the permutation step, and that the elements
!!      of the diagonal matrix used are denoted by D(i,j).  Then
!!         scale(j) = P(j),    FOR j = 1,...,low-1
!!                  = D(j,j),      j = low,...,igh
!!                  = P(j)         j = igh+1,...,n.
!!      The order in which the interchanges are made is n to igh+1,
!!      then 1 to low-1.
!!      Note that 1 is returned for igh if igh is zero formally.
!!      The Algol procedure exc contained in balance appears in
!!      dbal in line.  (Note that the Algol roles of identifiers
!!      k,l have been reversed.)
!!
!!      ********** radix is a machine dependent parameter specifying
!!                 the base of the machine floating point representation.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
double precision, intent(inout) :: a(nm,n), scale(n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, jj, iexc
double precision :: c, f, g, r, s, b2, radix
logical :: noconv
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!     double precision dabs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!     Dbal balances a double precision real matrix and isolates
!     eigenvalues whenever possible.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        a contains the input matrix to be balanced.
!     On output-
!        a contains the balanced matrix,
!        low and igh are two integers such that a(i,j)
!          is equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!        scale contains information determining the
!           permutations and scaling factors used.
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j),      j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!     Note that 1 is returned for igh if igh is zero formally.
!     The Algol procedure exc contained in balance appears in
!     dbal in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!-----------------------------------------------------------------------
!     ********** radix is a machine dependent parameter specifying
!                the base of the machine floating point representation.
radix = ipmpar(4)
!                **********
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** In-line procedure for row and
!                column exchange **********
20 scale(m) = j
if (j == m) go to 50
do i = 1, l
   f = a(i,j)
   a(i,j) = a(i,m)
   a(i,m) = f
end do
do i = k, n
   f = a(j,i)
   a(j,i) = a(m,i)
   a(m,i) = f
end do
50 select case (iexc)
case (1)
   go to 80
case (2)
   go to 130
end select
!     ********** Search for rows isolating an eigenvalue
!                and push them down **********
80 if (l == 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do jj = 1, l
   j = l + 1 - jj
   do i = 1, l
      if (i == j) go to 110
      if (a(j,i) /= 0.d0) go to 120
110   continue
   end do
   m = l
   iexc = 1
   go to 20
120 continue
end do
go to 140
!     ********** Search for columns isolating an eigenvalue
!                and push them left **********
130 k = k + 1
140 do j = k, l
   do i = k, l
      if (i == j) go to 150
      if (a(i,j) /= 0.d0) go to 170
150   continue
   end do
   m = k
   iexc = 2
   go to 20
170 continue
end do
!     ********** Now balance the submatrix in rows k to l **********
do i = k, l
   scale(i) = 1.d0
end do
!     ********** Iterative loop for norm reduction **********
190 noconv = .false.
do i = k, l
   c = 0.d0
   r = 0.d0
   do j = k, l
      if (j == i) go to 200
      c = c + abs(a(j,i))
      r = r + abs(a(i,j))
200   continue
   end do
!     ********** Guard against zero c or r due to underflow **********
   if (c == 0.d0 .or. r == 0.d0) go to 270
   g = r / radix
   f = 1.d0
   s = c + r
210 if (c >= g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c < g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** Now balance **********
240 if ((c + r) / f >= 0.95d0 * s) go to 270
   g = 1.d0 / f
   scale(i) = scale(i) * f
   noconv = .true.
   do j = k, n
      a(i,j) = a(i,j) * g
   end do
   do j = 1, l
      a(j,i) = a(j,i) * f
   end do
270 continue
end do
if (noconv) go to 190
280 low = k
igh = l
end subroutine dbal

pure subroutine dbalnv(nz,n,z,low,igh,scale)
!! <!-- nswc-ford:begin DBALNV -->
!! Reference for `dbalnv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Given A matrix A of order n. dbal transforms A into
!!      the matrix B by the similarity transformation
!!              b = d**(-1)*transpose(p)*a*p*d
!!      where D is a diagonal matrix and P a permutation matrix.
!!      The information concerning D and P is stored in igh, low,
!!      and scale. The order in which the interchanges were made
!!      is n to igh + 1, and then 1 to low - 1.
!!         z is a matrix of order n. dbalnv transforms z into the
!!      matrix W using the inverse similarity transform
!!              w = p*d*z*d**(-1)*transpose(p)
!!      on input-
!!         nz is the row dimension of the matrix z in the calling
!!           program,
!!         n is the order of the matrix,
!!         low and igh are integers determined by  dbal,
!!         scale contains information determining the permutations
!!           and scaling factors used by  dbal,
!!      on output-
!!         z contains the transformed matrix W
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nz, igh, low
double precision, intent(inout) :: z(nz,n)
double precision, intent(in) :: scale(n)
!     beginning of local variable declarations
integer :: i, j, k, ii
double precision :: s
!-----------------------------------------------------------------------
!        Given A matrix A of order n. dbal transforms A into
!     the matrix B by the similarity transformation
!             b = d**(-1)*transpose(p)*a*p*d
!     where D is a diagonal matrix and P a permutation matrix.
!     The information concerning D and P is stored in igh, low,
!     and scale. The order in which the interchanges were made
!     is n to igh + 1, and then 1 to low - 1.
!        z is a matrix of order n. dbalnv transforms z into the
!     matrix W using the inverse similarity transform
!             w = p*d*z*d**(-1)*transpose(p)
!     on input-
!        nz is the row dimension of the matrix z in the calling
!          program,
!        n is the order of the matrix,
!        low and igh are integers determined by  dbal,
!        scale contains information determining the permutations
!          and scaling factors used by  dbal,
!     on output-
!        z contains the transformed matrix W
!-----------------------------------------------------------------------
if (igh == low) go to 30
do i = low, igh
   s = scale(i)
   do j = 1, n
      z(i,j) = z(i,j) * s
   end do
end do
do j = low, igh
   s = 1.d0/scale(j)
   do i = 1, n
      z(i,j) = z(i,j) * s
   end do
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
30 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 60
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 60
   do j = 1, n
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
   do j = 1, n
      s = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = s
   end do
60 continue
end do
end subroutine dbalnv

pure subroutine dorth(nm,n,low,igh,a,ort)
!! <!-- nswc-ford:begin DORTH -->
!! Reference for `dorth`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision dsqrt,dabs
!!
!!      This subroutine is a translation of the Algol procedure orthes,
!!      NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!!      Given a real general matrix, this subroutine
!!      reduces a submatrix situated in rows and columns
!!      low through igh to upper Hessenberg form by
!!      orthogonal similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dbal.  If dbal has not been used then
!!           set low=1, igh=n,
!!         a contains the input matrix.
!!      On output-
!!         a contains the Hessenberg matrix.  Information about
!!           the orthogonal transformations used in the reduction
!!           is stored in the remaining triangle under the
!!           Hessenberg matrix,
!!         ort contains further information about the transformations.
!!           Only elements low through igh are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
double precision, intent(inout) :: a(nm,n), ort(igh)
!     beginning of local variable declarations
integer :: i, j, m, ii, jj, la, mp, kp1
double precision :: f, g, h, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure orthes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     orthogonal similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          set low=1, igh=n,
!        a contains the input matrix.
!     On output-
!        a contains the Hessenberg matrix.  Information about
!          the orthogonal transformations used in the reduction
!          is stored in the remaining triangle under the
!          Hessenberg matrix,
!        ort contains further information about the transformations.
!          Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   h = 0.d0
   ort(m) = 0.d0
   scale = 0.d0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do i = m, igh
      scale = scale + abs(a(i,m - 1))
   end do
   if (scale == 0.d0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ort(i) = a(i,m - 1) / scale
      h = h + ort(i) * ort(i)
   end do
   g = sqrt(h)
   if (ort(m) >= 0.d0) g = -g
   h = h - ort(m) * g
   ort(m) = ort(m) - g
!     ********** FORM (i-(U*UT)/h) * a **********
   do j = m, n
      f = 0.d0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         f = f + ort(i) * a(i,j)
      end do
      f = f / h
      do i = m, igh
         a(i,j) = a(i,j) - f * ort(i)
      end do
   end do
!     ********** FORM (i-(U*UT)/h)*a*(i-(U*UT)/h) **********
   do i = 1, igh
      f = 0.d0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         f = f + ort(j) * a(i,j)
      end do
      f = f / h
      do j = m, igh
         a(i,j) = a(i,j) - f * ort(j)
      end do
   end do
   ort(m) = scale * ort(m)
   a(m,m - 1) = scale * g
180 continue
end do
200 return
end subroutine dorth

pure subroutine dhqr(nm,n,low,igh,h,wr,wi,ierr)
!! <!-- nswc-ford:begin DHQR -->
!! Reference for `dhqr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision dsqrt,dabs
!!      integer min0
!!
!!      This subroutine is a translation of the Algol procedure hqr,
!!      NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!!      dhqr finds the eigenvalues of a double precision real
!!      upper Hessenberg matrix BY the QR method.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dbal.  If dbal has not been used then
!!           set low=1, igh=n,
!!         h contains the upper Hessenberg matrix.  Information about
!!           the transformations used in the reduction to Hessenberg
!!           form by dorth, if performed, is stored
!!           in the remaining triangle under the Hessenberg matrix.
!!      On output-
!!         h has been destroyed.  Therefore, it must be saved
!!           before calling  hqr  if subsequent calculation and
!!           back transformation of eigenvectors is to be performed,
!!         wr and wi contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  The eigenvalues
!!           are unordered except that complex conjugate pairs
!!           of values appear consecutively with the eigenvalue
!!           having the positive imaginary part first.  If an
!!           error exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 50 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0
!!                 in the double precision arithmetic being used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: h(nm,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ll, mm, na, its, mp2, enm2
double precision :: p, q, r, s, t, w, x, y, zz, norm, machep
logical :: notlas
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!     double precision dsqrt,dabs
!     integer min0
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure hqr,
!     NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!     dhqr finds the eigenvalues of a double precision real
!     upper Hessenberg matrix BY the QR method.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          set low=1, igh=n,
!        h contains the upper Hessenberg matrix.  Information about
!          the transformations used in the reduction to Hessenberg
!          form by dorth, if performed, is stored
!          in the remaining triangle under the Hessenberg matrix.
!     On output-
!        h has been destroyed.  Therefore, it must be saved
!          before calling  hqr  if subsequent calculation and
!          back transformation of eigenvectors is to be performed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0
!                in the double precision arithmetic being used.
machep = dpmpar(1)
!                **********
ierr = 0
norm = 0.d0
k = 1
!     ********** Store roots isolated by dbal
!                and compute matrix norm **********
do i = 1, n
   do j = k, n
      norm = norm + abs(h(i,j))
   end do
   k = i
   if (i >= low .and. i <= igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.d0
50 continue
end do
en = igh
t = 0.d0
!     ********** Search for next eigenvalues **********
60 if (en < low) go to 1001
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
70 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.d0) s = norm
   if (abs(h(l , l - 1)) <= machep * s) exit
end do
!     ********** Form shift **********
x = h(en,en)
if (l == en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l == na) go to 280
if (its == 50) go to 1000
if (its /= 10 .and. its /= 20 .and. its /= 30) go to 130
!     ********** Form exceptional shift **********
t = t + x
do i = low, en
   h(i,i) = h(i,i) - x
end do
s = abs(h(en,na)) + abs(h(na,enm2))
x = .75d0 * s
y = x
w = -.4375d0 * s * s
130 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m == l) exit
   if (abs(h(m,m - 1)) * (abs(q) + abs(r)) <= machep * abs(p) &
      & * (abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))) go to 150
end do
150 mp2 = m + 2
do i = mp2, en
   h(i,i - 2) = 0.d0
   if (i == mp2) go to 160
   h(i,i - 3) = 0.d0
160 continue
end do
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do k = m, na
   notlas = k /= na
   if (k == m) go to 170
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.d0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.d0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p < 0.d0) s = -s
   if (k == m) go to 180
   h(k,k - 1) = -s * x
   go to 190
180 if (l /= m) h(k,k - 1) = -h(k,k - 1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** Row modification **********
   do j = k, en
      p = h(k,j) + q * h(k + 1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p * zz
200   h(k + 1,j) = h(k + 1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
   j = min(en,k + 3)
!     ********** Column modification **********
   do i = l, j
      p = x * h(i,k) + y * h(i,k + 1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p * r
220   h(i,k + 1) = h(i,k + 1) - p * q
      h(i,k) = h(i,k) - p
   end do
260 continue
end do
go to 70
!     ********** One root found **********
270 wr(en) = x + t
wi(en) = 0.d0
en = na
go to 60
!     ********** Two roots found **********
280 p = (y - x) / 2.d0
q = p * p + w
zz = sqrt(abs(q))
x = x + t
if (q < 0.d0) go to 320
!     ********** Real pair **********
if (p < 0.d0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.d0) wr(en) = x - w / zz
wi(na) = 0.d0
wi(en) = 0.d0
go to 330
!     ********** Complex pair **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = en
1001 return
end subroutine dhqr

pure subroutine dbabk(nm,n,low,igh,scale,m,z)
!! <!-- nswc-ford:begin DBABK -->
!! Reference for `dbabk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure balbak,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!!      This subroutine forms the eigenvectors of a real general
!!      matrix BY back transforming those of the corresponding
!!      balanced matrix determined by dbal.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by dbal,
!!         scale contains information determining the permutations
!!           and scaling factors used by dbal,
!!         m is the number of columns of z to be back transformed,
!!         z contains the real and imaginary parts of the eigen-
!!           vectors to be back transformed in its first m columns.
!!      On output-
!!         z contains the real and imaginary parts of the
!!           transformed eigenvectors in its first m columns.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
double precision, intent(in) :: scale(n)
double precision, intent(inout) :: z(nm,m)
!     beginning of local variable declarations
integer :: i, j, k, ii
double precision :: s
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!     This subroutine forms the eigenvectors of a real general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by dbal.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by dbal,
!        scale contains information determining the permutations
!          and scaling factors used by dbal,
!        m is the number of columns of z to be back transformed,
!        z contains the real and imaginary parts of the eigen-
!          vectors to be back transformed in its first m columns.
!     On output-
!        z contains the real and imaginary parts of the
!          transformed eigenvectors in its first m columns.
!-----------------------------------------------------------------------
if (m == 0) go to 200
if (igh == low) go to 120
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      z(i,j) = z(i,j) * s
   end do
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
120 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
   do j = 1, m
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
140 continue
end do
200 return
end subroutine dbabk

pure subroutine dortrn(nm,n,low,igh,a,ort,z)
!! <!-- nswc-ford:begin DORTRN -->
!! Reference for `dortrn`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure ORTRANS,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!!      This subroutine accumulates the orthogonal similarity
!!      transformations used in the reduction of a real double
!!      precision matrix to upper Hessenberg form by dorth.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dbal.  If dbal has not been used then
!!           set low=1, igh=n,
!!         a contains information about the orthogonal trans-
!!           formations used in the reduction by dorth
!!           in its strict lower triangle,
!!         ort contains further information about the trans-
!!           formations used in the reduction by dorth.
!!           Only elements low through igh are used.
!!      On output-
!!         z contains the transformation matrix produced in the
!!           reduction by dorth,
!!         ort has been altered.
!!
!!      ********** Initialize z to identity matrix **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
double precision, intent(in) :: a(nm,igh)
double precision, intent(inout) :: ort(igh), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, kl, mm, mp, mp1
double precision :: g
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real double
!     precision matrix to upper Hessenberg form by dorth.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          set low=1, igh=n,
!        a contains information about the orthogonal trans-
!          formations used in the reduction by dorth
!          in its strict lower triangle,
!        ort contains further information about the trans-
!          formations used in the reduction by dorth.
!          Only elements low through igh are used.
!     On output-
!        z contains the transformation matrix produced in the
!          reduction by dorth,
!        ort has been altered.
!-----------------------------------------------------------------------
!     ********** Initialize z to identity matrix **********
do i = 1, n
   do j = 1, n
      z(i,j) = 0.d0
   end do
   z(i,i) = 1.d0
end do
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do mm = 1, kl
   mp = igh - mm
   if (a(mp,mp - 1) == 0.d0) go to 140
   mp1 = mp + 1
   do i = mp1, igh
      ort(i) = a(i,mp - 1)
   end do
   do j = mp, igh
      g = 0.d0
      do i = mp, igh
         g = g + ort(i) * z(i,j)
      end do
!     ********** Divisor below is negative of H formed in orthes.
!                Double division avoids possible underflow **********
      g = (g / ort(mp)) / a(mp,mp - 1)
      do i = mp, igh
         z(i,j) = z(i,j) + g * ort(i)
      end do
   end do
140 continue
end do
200 return
end subroutine dortrn

pure subroutine drtrn1(n,low,igh,a,na,z,nz,ort)
!! <!-- nswc-ford:begin DRTRN1 -->
!! Reference for `drtrn1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure ORTRANS,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!!      This subroutine accumulates the orthogonal similarity
!!      transformations used in the reduction of a real double
!!      precision matrix to upper Hessenberg form by dorth.
!!      On input-
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dbal.  If dbal has not been used then
!!           set low=1, igh=n,
!!         a contains information about the orthogonal trans-
!!           formations used in the reduction by dorth
!!           in its strict lower triangle,
!!         na must be set to the row dimension of the 2-dimensional
!!           array parameter  a  as declared in the calling program
!!           dimension statement,
!!         nz must be set to the row dimension of the 2-dimensional
!!           array parameter  z  as declared in the calling program
!!           dimension statement,
!!         ort contains further information about the trans-
!!           formations used in the reduction by dorth.
!!           Only elements low through igh are used.
!!      On output-
!!         z contains the transformation matrix produced in the
!!           reduction by dorth,
!!         ort has been altered.
!!
!!      ********** Initialize z to identity matrix **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: na, igh, low
integer, intent(in) :: nz
double precision, intent(in) :: a(na,igh)
double precision, intent(inout) :: ort(igh), z(nz,n)
!     beginning of local variable declarations
integer :: i, j, kl, mm, mp, mp1
double precision :: g
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real double
!     precision matrix to upper Hessenberg form by dorth.
!     On input-
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          set low=1, igh=n,
!        a contains information about the orthogonal trans-
!          formations used in the reduction by dorth
!          in its strict lower triangle,
!        na must be set to the row dimension of the 2-dimensional
!          array parameter  a  as declared in the calling program
!          dimension statement,
!        nz must be set to the row dimension of the 2-dimensional
!          array parameter  z  as declared in the calling program
!          dimension statement,
!        ort contains further information about the trans-
!          formations used in the reduction by dorth.
!          Only elements low through igh are used.
!     On output-
!        z contains the transformation matrix produced in the
!          reduction by dorth,
!        ort has been altered.
!-----------------------------------------------------------------------
!     ********** Initialize z to identity matrix **********
do i = 1, n
   do j = 1, n
      z(i,j) = 0.d0
   end do
   z(i,i) = 1.d0
end do
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do mm = 1, kl
   mp = igh - mm
   if (a(mp,mp - 1) == 0.d0) go to 140
   mp1 = mp + 1
   do i = mp1, igh
      ort(i) = a(i,mp - 1)
   end do
   do j = mp, igh
      g = 0.d0
      do i = mp, igh
         g = g + ort(i) * z(i,j)
      end do
!     ********** Divisor below is negative of H formed in orthes.
!                Double division avoids possible underflow **********
      g = (g / ort(mp)) / a(mp,mp - 1)
      do i = mp, igh
         z(i,j) = z(i,j) + g * ort(i)
      end do
   end do
140 continue
end do
200 return
end subroutine drtrn1

pure subroutine dhqr2(nm,n,low,igh,h,wr,wi,z,ierr)
!! <!-- nswc-ford:begin DHQR2 -->
!! Reference for `dhqr2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      integer min0
!!      double precision dsqrt,dabs
!!
!!      This subroutine is a translation of the Algol procedure hqr2,
!!      NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!!      This subroutine finds the eigenvalues and eigenvectors
!!      of a real double precision upper Hessenberg matrix BY the
!!      QR method.  The eigenvectors of a real general matrix can
!!      also be found if dorth and dortrn have been used to reduce
!!      this general matrix to Hessenberg form and to accumulate
!!      the similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dbal.  If dbal has not been used then
!!           set low=1, igh=n,
!!         h contains the upper Hessenberg matrix,
!!         z contains the transformation matrix produced by dortrn
!!           after the reduction by dorth, if performed. If the
!!           eigenvectors of the Hessenberg matrix are desired,
!!           z must contain the identity matrix.
!!      On output-
!!         h has been destroyed,
!!         wr and wi contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  The eigenvalues
!!           are unordered except that complex conjugate pairs
!!           of values appear consecutively with the eigenvalue
!!           having the positive imaginary part first.  If an
!!           error exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         z contains the real and imaginary parts of the eigenvectors.
!!           If the i-TH eigenvalue is real, the i-TH column of z
!!           contains its eigenvector.  If the i-TH eigenvalue is complex
!!           with positive imaginary part, the i-TH and (i+1)-TH
!!           columns of z contain the real and imaginary parts of its
!!           eigenvector.  The eigenvectors are unnormalized.  If an
!!           error exit is made, none of the eigenvectors has been found,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 50 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value u where u is the smallest positive
!!                 floating point number such that 1.0 + u .GT. 1.0
!!                 in the double precision arithmetic being used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: h(nm,n), wr(n), wi(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ii, jj, ll, mm, na, nn, its, mp2, enm2
double precision :: a, b, d, p, q, r, s, t, u, w, x, y, ra, sa, vi, vr, zz, norm, machep, nswc_ai_r8
logical :: notlas
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!     integer min0
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure hqr2,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     This subroutine finds the eigenvalues and eigenvectors
!     of a real double precision upper Hessenberg matrix BY the
!     QR method.  The eigenvectors of a real general matrix can
!     also be found if dorth and dortrn have been used to reduce
!     this general matrix to Hessenberg form and to accumulate
!     the similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          set low=1, igh=n,
!        h contains the upper Hessenberg matrix,
!        z contains the transformation matrix produced by dortrn
!          after the reduction by dorth, if performed. If the
!          eigenvectors of the Hessenberg matrix are desired,
!          z must contain the identity matrix.
!     On output-
!        h has been destroyed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        z contains the real and imaginary parts of the eigenvectors.
!          If the i-TH eigenvalue is real, the i-TH column of z
!          contains its eigenvector.  If the i-TH eigenvalue is complex
!          with positive imaginary part, the i-TH and (i+1)-TH
!          columns of z contain the real and imaginary parts of its
!          eigenvector.  The eigenvectors are unnormalized.  If an
!          error exit is made, none of the eigenvectors has been found,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value u where u is the smallest positive
!                floating point number such that 1.0 + u .GT. 1.0
!                in the double precision arithmetic being used.
machep = dpmpar(1)
!                **********
ierr = 0
norm = 0.d0
k = 1
!     ********** Store roots isolated by dbal
!                and compute matrix norm **********
do i = 1, n
   do j = k, n
      norm = norm + abs(h(i,j))
   end do
   k = i
   if (i >= low .and. i <= igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.d0
50 continue
end do
en = igh
t = 0.d0
!     ********** Search for next eigenvalues **********
60 if (en < low) go to 340
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
70 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.d0) s = norm
   if (abs(h(l , l - 1)) <= machep * s) exit
end do
!     ********** Form shift **********
x = h(en,en)
if (l == en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l == na) go to 280
if (its == 50) go to 1000
if (its /= 10 .and. its /= 20 .and. its /= 30) go to 130
!     ********** Form exceptional shift **********
t = t + x
do i = low, en
   h(i,i) = h(i,i) - x
end do
s = abs(h(en,na)) + abs(h(na,enm2))
x = .75d0 * s
y = x
w = -.4375d0 * s * s
130 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m == l) exit
   if (abs(h(m,m - 1)) * (abs(q) + abs(r)) <= machep * abs(p) &
      & * (abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))) go to 150
end do
150 mp2 = m + 2
do i = mp2, en
   h(i,i - 2) = 0.d0
   if (i == mp2) go to 160
   h(i,i - 3) = 0.d0
160 continue
end do
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do k = m, na
   notlas = k /= na
   if (k == m) go to 170
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.d0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.d0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p < 0.d0) s = -s
   if (k == m) go to 180
   h(k,k - 1) = -s * x
   go to 190
180 if (l /= m) h(k,k - 1) = -h(k,k - 1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** Row modification **********
   do j = k, n
      p = h(k,j) + q * h(k + 1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p * zz
200   h(k + 1,j) = h(k + 1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
   j = min(en,k + 3)
!     ********** Column modification **********
   do i = 1, j
      p = x * h(i,k) + y * h(i,k + 1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p * r
220   h(i,k + 1) = h(i,k + 1) - p * q
      h(i,k) = h(i,k) - p
   end do
!     ********** Accumulate transformations **********
   do i = low, igh
      p = x * z(i,k) + y * z(i,k + 1)
      if (.not. notlas) go to 240
      p = p + zz * z(i,k + 2)
      z(i,k + 2) = z(i,k + 2) - p * r
240   z(i,k + 1) = z(i,k + 1) - p * q
      z(i,k) = z(i,k) - p
   end do
260 continue
end do
go to 70
!     ********** One root found **********
270 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.d0
en = na
go to 60
!     ********** Two roots found **********
280 p = (y - x) / 2.d0
q = p * p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q < 0.d0) go to 320
!     ********** Real pair **********
if (p < 0.d0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.d0) wr(en) = x - w / zz
wi(na) = 0.d0
wi(en) = 0.d0
x = h(en,na)
s = abs(x) + abs(zz)
p = x / s
q = zz / s
r = sqrt(p*p + q*q)
p = p / r
q = q / r
!     ********** Row modification **********
do j = na, n
   zz = h(na,j)
   h(na,j) = q * zz + p * h(en,j)
   h(en,j) = q * h(en,j) - p * zz
end do
!     ********** Column modification **********
do i = 1, en
   zz = h(i,na)
   h(i,na) = q * zz + p * h(i,en)
   h(i,en) = q * h(i,en) - p * zz
end do
!     ********** Accumulate transformations **********
do i = low, igh
   zz = z(i,na)
   z(i,na) = q * zz + p * z(i,en)
   z(i,en) = q * z(i,en) - p * zz
end do
go to 330
!     ********** Complex pair **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
340 if (norm == 0.d0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 1 DO -- **********
do nn = 1, n
   en = n + 1 - nn
   p = wr(en)
   q = wi(en)
   na = en - 1
   nswc_ai_r8 = q
   if (nswc_ai_r8 < 0) go to 710
   if (nswc_ai_r8 == 0) go to 600
   go to 800
!     ********** Real vector **********
600 m = en
   h(en,en) = 1.d0
   if (na == 0) go to 800
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, na
      i = en - ii
      w = h(i,i) - p
      r = h(i,en)
      if (m > na) go to 620
      do j = m, na
         r = r + h(i,j) * h(j,en)
      end do
620   if (wi(i) >= 0.d0) go to 630
      zz = w
      s = r
      go to 700
630   m = i
      if (wi(i) /= 0.d0) go to 640
      t = w
      if (w == 0.d0) t = machep * norm
      h(i,en) = -r / t
      go to 700
!     ********** Solve real equations **********
640   x = h(i,i + 1)
      y = h(i + 1,i)
      q = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i)
      t = (x * s - zz * r) / q
      h(i,en) = t
      if (abs(x) <= abs(zz)) go to 650
      h(i + 1,en) = (-r - w * t) / x
      go to 700
650   h(i + 1,en) = (-s - y * t) / zz
700   continue
   end do
!     ********** End real vector **********
   go to 800
!     ********** Complex vector **********
710 m = na
!     ********** Last vector component chosen imaginary so that
!                eigenvector matrix is triangular **********
   if (abs(h(en,na)) <= abs(h(na,en))) go to 720
   h(na,na) = q / h(en,na)
   h(na,en) = -(h(en,en) - p) / h(en,na)
   go to 730
720 u = h(na,na) - p
   b = -h(na,en) / (u * u + q * q)
   h(na,na) = b * q
   h(na,en) = b * u
730 h(en,na) = 0.d0
   h(en,en) = 1.d0
   enm2 = na - 1
   if (enm2 == 0) go to 800
!     ********** FOR i=en-2 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, enm2
      i = na - ii
      w = h(i,i) - p
      ra = 0.d0
      sa = h(i,en)
      do j = m, na
         ra = ra + h(i,j) * h(j,na)
         sa = sa + h(i,j) * h(j,en)
      end do
      if (wi(i) >= 0.d0) go to 770
      zz = w
      r = ra
      s = sa
      go to 790
770   m = i
      if (wi(i) /= 0.d0) go to 780
      d = w * w + q * q
      h(i,na) = -(ra * w + sa * q) / d
      h(i,en) = (ra * q - sa * w) / d
      go to 790
!     ********** Solve complex equations **********
780   x = h(i,i + 1)
      y = h(i + 1,i)
      vr = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i) - q * q
      vi = (wr(i) - p) * 2.d0 * q
      if (vr == 0.d0 .and. vi == 0.d0) vr = machep * norm &
         & * (abs(w) + abs(q) + abs(x) + abs(y) + abs(zz))
      a = x * r - zz * ra + q * sa
      b = x * s - zz * sa - q * ra
      d = vr * vr + vi * vi
      h(i,na) = (a * vr + b * vi) / d
      h(i,en) = (b * vr - a * vi) / d
      if (abs(x) <= abs(zz) + abs(q)) go to 785
      h(i + 1,na) = (-ra - w * h(i,na) + q * h(i,en)) / x
      h(i + 1,en) = (-sa - w * h(i,en) - q * h(i,na)) / x
      go to 790
785   a = -r - y * h(i,na)
      b = -s - y * h(i,en)
      d = zz * zz + q * q
      h(i + 1,na) = (a * zz + b * q) / d
      h(i + 1,en) = (b * zz - a * q) / d
790   continue
   end do
!     ********** End complex vector **********
800 continue
end do
!     ********** End back substitution.
!                Vectors of isolated roots **********
do i = 1, n
   if (i >= low .and. i <= igh) go to 840
   do j = i, n
      z(i,j) = h(i,j)
   end do
840 continue
end do
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low do -- **********
do jj = low, n
   j = n + low - jj
   m = min(j,igh)
   do i = low, igh
      zz = 0.d0
      do k = low, m
         zz = zz + z(i,k) * h(k,j)
      end do
      z(i,j) = zz
   end do
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = en
1001 return
end subroutine dhqr2

subroutine seig(a, ka, n, w, t, ierr)
!! <!-- nswc-ford:begin SEIG -->
!! Reference for `seig`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                Eigenvalues of symmetric real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka
integer :: n
real, intent(inout) :: a(*), w(n), t(*)
!     beginning of local variable declarations
integer :: l
!-----------------------------------------------------------------------
!               Eigenvalues of symmetric real matrices
!-----------------------------------------------------------------------
if (ka == 0) then
   l = n*(n + 1)
   l = l/2
   call tred3(n, l, a, w, t(n + 1), t(1))
   call tqlrat(n, w, t, ierr)
else
   call tred1(ka, n, a, w, t(n + 1), t(1))
   call tqlrat(n, w, t, ierr)
end if
end subroutine seig

pure subroutine seig1(a, ka, n, w, t, ierr)
!! <!-- nswc-ford:begin SEIG1 -->
!! Reference for `seig1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                Eigenvalues of symmetric real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(*), w(n), t(n)
!     beginning of local variable declarations
integer :: l
interface
   pure subroutine imtql1(n,d,e,ierr)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      integer, intent(out) :: ierr
   end subroutine imtql1
   pure subroutine tred1(nm,n,a,d,e,e2)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      real, intent(inout) :: e2(n)
   end subroutine tred1
   pure subroutine tred3(n,nv,a,d,e,e2)
      implicit none
      integer, intent(in) :: nv
      integer, intent(in) :: n
      real, intent(inout) :: a(nv)
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      real, intent(inout) :: e2(n)
   end subroutine tred3
end interface
!-----------------------------------------------------------------------
!               Eigenvalues of symmetric real matrices
!-----------------------------------------------------------------------
if (ka == 0) then
   l = n*(n + 1)
   l = l/2
   call tred3(n, l, a, w, t, t)
   call imtql1(n, w, t, ierr)
else
   call tred1(ka, n, a, w, t, t)
   call imtql1(n, w, t, ierr)
end if
end subroutine seig1

pure subroutine seigv(a, ka, n, w, z, t, ierr)
!! <!-- nswc-ford:begin SEIGV -->
!! Reference for `seigv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Eigenvalues and eigenvectors of symmetric real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: w(n), z(ka,n), t(n)
interface
   pure subroutine tql2(nm,n,d,e,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      real, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine tql2
   pure subroutine tred2(nm,n,a,d,e,z)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(in) :: a(nm,n)
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      real, intent(inout) :: z(nm,n)
   end subroutine tred2
end interface
!-----------------------------------------------------------------------
!        Eigenvalues and eigenvectors of symmetric real matrices
!-----------------------------------------------------------------------
call tred2(ka, n, a, w, t, z)
call tql2(ka, n, w, t, z, ierr)
end subroutine seigv

pure subroutine seigv1(a, ka, n, w, z, t, ierr)
!! <!-- nswc-ford:begin SEIGV1 -->
!! Reference for `seigv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Eigenvalues and eigenvectors of symmetric real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: w(n), z(ka,n), t(n)
interface
   pure subroutine imtql2(nm,n,d,e,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      real, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine imtql2
   pure subroutine tred2(nm,n,a,d,e,z)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(in) :: a(nm,n)
      real, intent(inout) :: d(n)
      real, intent(inout) :: e(n)
      real, intent(inout) :: z(nm,n)
   end subroutine tred2
end interface
!-----------------------------------------------------------------------
!        Eigenvalues and eigenvectors of symmetric real matrices
!-----------------------------------------------------------------------
call tred2(ka, n, a, w, t, z)
call imtql2(ka, n, w, t, z, ierr)
end subroutine seigv1

pure subroutine tred1(nm,n,a,d,e,e2)
!! <!-- nswc-ford:begin TRED1 -->
!! Reference for `tred1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs
!!
!!      This subroutine is a translation of the Algol procedure tred1,
!!      NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!!      This subroutine reduces a real symmetric matrix
!!      to a symmetric tridiagonal matrix using
!!      orthogonal similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         a contains the real symmetric input matrix.  Only the
!!           lower triangle of the matrix need be supplied.
!!      On output-
!!         a contains information about the orthogonal trans-
!!           formations used in the reduction in its strict lower
!!           triangle.  The full upper triangle of A is unaltered,
!!         d contains the diagonal elements of the tridiagonal matrix,
!!         e contains the subdiagonal elements of the tridiagonal
!!           matrix in its last n-1 positions.  e(1) is set to zero,
!!         e2 contains the squares of the corresponding elements of e.
!!           e2 may coincide with e if the squares are not needed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
real, intent(inout) :: a(nm,n), d(n), e(n), e2(n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, jp1
real :: f, g, h, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tred1,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!     This subroutine reduces a real symmetric matrix
!     to a symmetric tridiagonal matrix using
!     orthogonal similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        a contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!     On output-
!        a contains information about the orthogonal trans-
!          formations used in the reduction in its strict lower
!          triangle.  The full upper triangle of A is unaltered,
!        d contains the diagonal elements of the tridiagonal matrix,
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!-----------------------------------------------------------------------
do i = 1, n
   d(i) = a(i,i)
end do
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   h = 0.0
   scale = 0.0
   if (l < 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      scale = scale + abs(a(i,k))
   end do
   if (scale /= 0.0) go to 140
130 e(i) = 0.0
   e2(i) = 0.0
   go to 290
140 do k = 1, l
      a(i,k) = a(i,k) / scale
      h = h + a(i,k) * a(i,k)
   end do
   e2(i) = scale * scale * h
   f = a(i,l)
   g = sqrt(h)
   if (f >= 0.0) g = -g
   e(i) = scale * g
   h = h - f * g
   a(i,l) = f - g
   if (l == 1) go to 270
   f = 0.0
   do j = 1, l
      g = 0.0
!     ********** Form element of a*U **********
      do k = 1, j
         g = g + a(j,k) * a(i,k)
      end do
      jp1 = j + 1
      if (l < jp1) go to 220
      do k = jp1, l
         g = g + a(k,j) * a(i,k)
      end do
!     ********** Form element of P **********
220   e(j) = g / h
      f = f + e(j) * a(i,j)
   end do
   h = f / (h + h)
!     ********** Form reduced a **********
   do j = 1, l
      f = a(i,j)
      g = e(j) - h * f
      e(j) = g
      do k = 1, j
         a(j,k) = a(j,k) - f * e(k) - g * a(i,k)
      end do
   end do
270 do k = 1, l
      a(i,k) = scale * a(i,k)
   end do
290 h = d(i)
   d(i) = a(i,i)
   a(i,i) = h
end do
!     ********** Last card of tred1 **********
end subroutine tred1

pure subroutine tred3(n,nv,a,d,e,e2)
!! <!-- nswc-ford:begin TRED3 -->
!! Reference for `tred3`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs
!!
!!      This subroutine is a translation of the Algol procedure tred3,
!!      NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!!      This subroutine reduces a real symmetric matrix, stored as
!!      a one-dimensional array, to a symmetric tridiagonal matrix
!!      using orthogonal similarity transformations.
!!      On input-
!!         n is the order of the matrix,
!!         nv must be set to the dimension of the array parameter A
!!           as declared in the calling program dimension statement,
!!         a contains the lower triangle of the real symmetric
!!           input matrix, stored row-wise as a one-dimensional
!!           array, in its first n*(n+1)/2 positions.
!!      On output-
!!         a contains information about the orthogonal
!!           transformations used in the reduction,
!!         d contains the diagonal elements of the tridiagonal matrix,
!!         e contains the subdiagonal elements of the tridiagonal
!!           matrix in its last n-1 positions.  e(1) is set to zero,
!!         e2 contains the squares of the corresponding elements of e.
!!           e2 may coincide with e if the squares are not needed.
!!
!!      ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nv
real, intent(inout) :: a(nv), d(n), e(n), e2(n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, iz, jk
real :: f, g, h, hh, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tred3,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!     This subroutine reduces a real symmetric matrix, stored as
!     a one-dimensional array, to a symmetric tridiagonal matrix
!     using orthogonal similarity transformations.
!     On input-
!        n is the order of the matrix,
!        nv must be set to the dimension of the array parameter A
!          as declared in the calling program dimension statement,
!        a contains the lower triangle of the real symmetric
!          input matrix, stored row-wise as a one-dimensional
!          array, in its first n*(n+1)/2 positions.
!     On output-
!        a contains information about the orthogonal
!          transformations used in the reduction,
!        d contains the diagonal elements of the tridiagonal matrix,
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!-----------------------------------------------------------------------
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   iz = (i * l) / 2
   h = 0.0
   scale = 0.0
   if (l < 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      iz = iz + 1
      d(k) = a(iz)
      scale = scale + abs(d(k))
   end do
   if (scale /= 0.0) go to 140
130 e(i) = 0.0
   e2(i) = 0.0
   go to 290
140 do k = 1, l
      d(k) = d(k) / scale
      h = h + d(k) * d(k)
   end do
   e2(i) = scale * scale * h
   f = d(l)
   g = sqrt(h)
   if (f >= 0.0) g = -g
   e(i) = scale * g
   h = h - f * g
   d(l) = f - g
   a(iz) = scale * d(l)
   if (l == 1) go to 290
   f = 0.0
   do j = 1, l
      g = 0.0
      jk = (j * (j - 1)) / 2
!     ********** Form element of a*U **********
      do k = 1, l
         jk = jk + 1
         if (k > j) jk = jk + k - 2
         g = g + a(jk) * d(k)
      end do
!     ********** Form element of P **********
      e(j) = g / h
      f = f + e(j) * d(j)
   end do
   hh = f / (h + h)
   jk = 0
!     ********** Form reduced a **********
   do j = 1, l
      f = d(j)
      g = e(j) - hh * f
      e(j) = g
      do k = 1, j
         jk = jk + 1
         a(jk) = a(jk) - f * e(k) - g * d(k)
      end do
   end do
290 d(i) = a(iz + 1)
   a(iz + 1) = scale * sqrt(h)
end do
!     ********** Last card of tred3 **********
end subroutine tred3

pure subroutine tqlrat(n,d,e2,ierr)
!! <!-- nswc-ford:begin TQLRAT -->
!! Reference for `tqlrat`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs,spmpar
!!
!!      This subroutine is a translation of the Algol procedure tqlrat,
!!      algorithm 464, comm. ACM 16, 689(1973) by Reinsch.
!!      This subroutine finds the eigenvalues of a symmetric
!!      tridiagonal matrix BY the rational QL method.
!!      On input-
!!         n is the order of the matrix,
!!         d contains the diagonal elements of the input matrix,
!!         e2 contains the squares of the subdiagonal elements of the
!!           input matrix in its last n-1 positions.  e2(1) is arbitrary.
!!       On output-
!!         d contains the eigenvalues in ascending order.  If an
!!           error exit is made, the eigenvalues are correct and
!!           ordered for indices 1,2,...ierr-1, but may not be
!!           the smallest eigenvalues,
!!         e2 has been destroyed,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e2(n)
!     beginning of local variable declarations
integer :: i, j, l, m, ii, l1, mml
real :: b, c, f, g, h, p, r, s, machep
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tqlrat,
!     algorithm 464, comm. ACM 16, 689(1973) by Reinsch.
!     This subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!     On input-
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e2 contains the squares of the subdiagonal elements of the
!          input matrix in its last n-1 positions.  e2(1) is arbitrary.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!        e2 has been destroyed,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = spmpar(1)
!                **********
ierr = 0
if (n == 1) go to 1001
do i = 2, n
   e2(i - 1) = e2(i)
end do
f = 0.0
b = 0.0
e2(n) = 0.0
do l = 1, n
   j = 0
   h = machep * (abs(d(l)) + sqrt(e2(l)))
   if (b > h) go to 105
   b = h
   c = b * b
!     ********** Look for small squared sub-diagonal element **********
105 do m = l, n
      if (e2(m) <= c) exit
!     ********** e2(n) is always zero, so there is no exit
!                through the bottom of the loop **********
   end do
   if (m == l) go to 210
130 if (j == 30) go to 1000
   j = j + 1
!     ********** Form shift **********
   l1 = l + 1
   s = sqrt(e2(l))
   g = d(l)
   p = (d(l1) - g) / (2.0 * s)
   r = sqrt(p*p + 1.0)
   if (p < 0.0) r = -r
   d(l) = s / (p + r)
   h = g - d(l)
   do i = l1, n
      d(i) = d(i) - h
   end do
   f = f + h
!     ********** RATIONAL QL TRANSFORMATION **********
   g = d(m)
   if (g == 0.0) g = b
   h = g
   s = 0.0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      p = g * h
      r = p + e2(i)
      e2(i + 1) = s * r
      s = e2(i) / r
      d(i + 1) = h + s * (h + d(i))
      g = d(i) - e2(i) / g
      if (g == 0.0) g = b
      h = g * p / r
   end do
   e2(l) = s * g
   d(l) = h
!     ********** Guard against underflow in convergence test **********
   if (h == 0.0) go to 210
   if (abs(e2(l)) <= abs(c/h)) go to 210
   e2(l) = h * e2(l)
   if (e2(l) /= 0.0) go to 130
210 p = d(l) + f
!     ********** Order eigenvalues **********
   if (l == 1) go to 250
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2, l
      i = l + 2 - ii
      if (p >= d(i - 1)) go to 270
      d(i) = d(i - 1)
   end do
250 i = 1
270 d(i) = p
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of tqlrat **********
end subroutine tqlrat

pure subroutine imtql1(n,d,e,ierr)
!! <!-- nswc-ford:begin IMTQL1 -->
!! Reference for `imtql1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs,spmpar
!!
!!      This subroutine is a translation of the Algol procedure imtql1,
!!      NUM. Math. 12, 377-383(1968) By Martin and Wilkinson,
!!      as modified in NUM. Math. 15, 450(1970) By Dubrulle.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 241-248(1971).
!!      This subroutine finds the eigenvalues of a symmetric
!!      tridiagonal matrix BY the implicit QL method.
!!      On input-
!!         n is the order of the matrix,
!!         d contains the diagonal elements of the input matrix,
!!         e contains the subdiagonal elements of the input matrix
!!           in its last n-1 positions.  e(1) is arbitrary.
!!       On output-
!!         d contains the eigenvalues in ascending order.  If an
!!           error exit is made, the eigenvalues are correct and
!!           ordered for indices 1,2,...ierr-1, but may not be
!!           the smallest eigenvalues,
!!         e has been destroyed,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e(n)
!     beginning of local variable declarations
integer :: i, j, l, m, ii, mml
real :: b, c, f, g, p, r, s, machep
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure imtql1,
!     NUM. Math. 12, 377-383(1968) By Martin and Wilkinson,
!     as modified in NUM. Math. 15, 450(1970) By Dubrulle.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 241-248(1971).
!     This subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the implicit QL method.
!     On input-
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!        e has been destroyed,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = spmpar(1)
!                **********
ierr = 0
if (n == 1) go to 1001
do i = 2, n
   e(i - 1) = e(i)
end do
e(n) = 0.0
do l = 1, n
   j = 0
!     ********** Look for small sub-diagonal element **********
105 do m = l, n
      if (m == n) exit
      if (abs(e(m)) <= machep * (abs(d(m)) + abs(d(m + 1)))) &
         & go to 120
   end do
120 p = d(l)
   if (m == l) go to 215
   if (j == 30) go to 1000
   j = j + 1
!     ********** Form shift **********
   g = (d(l + 1) - p) / (2.0 * e(l))
   r = sqrt(g*g + 1.0)
   if (g < 0.0) r = -r
   g = d(m) - p + e(l) / (g + r)
   s = 1.0
   c = 1.0
   p = 0.0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      f = s * e(i)
      b = c * e(i)
      if (abs(f) < abs(g)) go to 150
      c = g / f
      r = sqrt(c*c + 1.0)
      e(i + 1) = f * r
      s = 1.0 / r
      c = c * s
      go to 160
150   s = f / g
      r = sqrt(s*s + 1.0)
      e(i + 1) = g * r
      c = 1.0 / r
      s = s * c
160   g = d(i + 1) - p
      r = (d(i) - g) * s + 2.0 * c * b
      p = s * r
      d(i + 1) = g + p
      g = c * r - b
   end do
   d(l) = d(l) - p
   e(l) = g
   e(m) = 0.0
   go to 105
!     ********** Order eigenvalues **********
215 if (l == 1) go to 250
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2, l
      i = l + 2 - ii
      if (p >= d(i - 1)) go to 270
      d(i) = d(i - 1)
   end do
250 i = 1
270 d(i) = p
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of imtql1 **********
end subroutine imtql1

pure subroutine tred2(nm,n,a,d,e,z)
!! <!-- nswc-ford:begin TRED2 -->
!! Reference for `tred2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs
!!
!!      This subroutine is a translation of the Algol procedure tred2,
!!      NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!!      This subroutine reduces a real symmetric matrix to A
!!      symmetric tridiagonal matrix using and accumulating
!!      orthogonal similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         a contains the real symmetric input matrix.  Only the
!!           lower triangle of the matrix need be supplied.
!!      On output-
!!         d contains the diagonal elements of the tridiagonal matrix,
!!         e contains the subdiagonal elements of the tridiagonal
!!           matrix in its last n-1 positions.  e(1) is set to zero,
!!         z contains the orthogonal transformation matrix
!!           produced in the reduction,
!!         A and z may coincide.  If distinct, A is unaltered.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
real, intent(in) :: a(nm,n)
real, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, jp1
real :: f, g, h, hh, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tred2,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!     This subroutine reduces a real symmetric matrix to A
!     symmetric tridiagonal matrix using and accumulating
!     orthogonal similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        a contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!     On output-
!        d contains the diagonal elements of the tridiagonal matrix,
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!        z contains the orthogonal transformation matrix
!          produced in the reduction,
!        A and z may coincide.  If distinct, A is unaltered.
!-----------------------------------------------------------------------
do i = 1, n
   do j = 1, i
      z(i,j) = a(i,j)
   end do
end do
if (n == 1) go to 320
!     ********** FOR i=n STEP -1 UNTIL 2 DO -- **********
do ii = 2, n
   i = n + 2 - ii
   l = i - 1
   h = 0.0
   scale = 0.0
   if (l < 2) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      scale = scale + abs(z(i,k))
   end do
   if (scale /= 0.0) go to 140
130 e(i) = z(i,l)
   go to 290
140 do k = 1, l
      z(i,k) = z(i,k) / scale
      h = h + z(i,k) * z(i,k)
   end do
   f = z(i,l)
   g = sqrt(h)
   if (f >= 0.0) g = -g
   e(i) = scale * g
   h = h - f * g
   z(i,l) = f - g
   f = 0.0
   do j = 1, l
      z(j,i) = z(i,j) / h
      g = 0.0
!     ********** Form element of a*U **********
      do k = 1, j
         g = g + z(j,k) * z(i,k)
      end do
      jp1 = j + 1
      if (l < jp1) go to 220
      do k = jp1, l
         g = g + z(k,j) * z(i,k)
      end do
!     ********** Form element of P **********
220   e(j) = g / h
      f = f + e(j) * z(i,j)
   end do
   hh = f / (h + h)
!     ********** Form reduced a **********
   do j = 1, l
      f = z(i,j)
      g = e(j) - hh * f
      e(j) = g
      do k = 1, j
         z(j,k) = z(j,k) - f * e(k) - g * z(i,k)
      end do
   end do
290 d(i) = h
end do
320 d(1) = 0.0
e(1) = 0.0
!     ********** Accumulation of transformation matrices **********
do i = 1, n
   l = i - 1
   if (d(i) == 0.0) go to 380
   do j = 1, l
      g = 0.0
      do k = 1, l
         g = g + z(i,k) * z(k,j)
      end do
      do k = 1, l
         z(k,j) = z(k,j) - g * z(k,i)
      end do
   end do
380 d(i) = z(i,i)
   z(i,i) = 1.0
   if (l < 1) go to 500
   do j = 1, l
      z(i,j) = 0.0
      z(j,i) = 0.0
   end do
500 continue
end do
!     ********** Last card of tred2 **********
end subroutine tred2

pure subroutine tql2(nm,n,d,e,z,ierr)
!! <!-- nswc-ford:begin TQL2 -->
!! Reference for `tql2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs,spmpar
!!
!!      This subroutine is a translation of the Algol procedure tql2,
!!      NUM. Math. 11, 293-306(1968) By Bowdler, Martin, Reinsch, and
!!      Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 227-240(1971).
!!      This subroutine finds the eigenvalues and eigenvectors
!!      of a symmetric tridiagonal matrix BY the QL method.
!!      The eigenvectors of a full symmetric matrix can also
!!      be found if  tred2  has been used to reduce this
!!      full matrix to tridiagonal form.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         d contains the diagonal elements of the input matrix,
!!         e contains the subdiagonal elements of the input matrix
!!           in its last n-1 positions.  e(1) is arbitrary,
!!         z contains the transformation matrix produced in the
!!           reduction by  tred2, if performed.  If the eigenvectors
!!           of the tridiagonal matrix are desired, z must contain
!!           the identity matrix.
!!       On output-
!!         d contains the eigenvalues in ascending order.  If an
!!           error exit is made, the eigenvalues are correct but
!!           unordered for indices 1,2,...,ierr-1,
!!         e has been destroyed,
!!         z contains orthonormal eigenvectors of the symmetric
!!           tridiagonal (or full) matrix.  If an error exit is made,
!!           z contains the eigenvectors associated with the stored
!!           eigenvalues,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, ii, l1, mml
real :: b, c, f, g, h, p, r, s, machep
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tql2,
!     NUM. Math. 11, 293-306(1968) By Bowdler, Martin, Reinsch, and
!     Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 227-240(1971).
!     This subroutine finds the eigenvalues and eigenvectors
!     of a symmetric tridiagonal matrix BY the QL method.
!     The eigenvectors of a full symmetric matrix can also
!     be found if  tred2  has been used to reduce this
!     full matrix to tridiagonal form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary,
!        z contains the transformation matrix produced in the
!          reduction by  tred2, if performed.  If the eigenvectors
!          of the tridiagonal matrix are desired, z must contain
!          the identity matrix.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct but
!          unordered for indices 1,2,...,ierr-1,
!        e has been destroyed,
!        z contains orthonormal eigenvectors of the symmetric
!          tridiagonal (or full) matrix.  If an error exit is made,
!          z contains the eigenvectors associated with the stored
!          eigenvalues,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = spmpar(1)
!                **********
ierr = 0
if (n == 1) go to 1001
do i = 2, n
   e(i - 1) = e(i)
end do
f = 0.0
b = 0.0
e(n) = 0.0
do l = 1, n
   j = 0
   h = machep * (abs(d(l)) + abs(e(l)))
   if (b < h) b = h
!     ********** Look for small sub-diagonal element **********
   do m = l, n
      if (abs(e(m)) <= b) exit
!     ********** e(n) is always zero, so there is no exit
!                through the bottom of the loop **********
   end do
   if (m == l) go to 220
130 if (j == 30) go to 1000
   j = j + 1
!     ********** Form shift **********
   l1 = l + 1
   g = d(l)
   p = (d(l1) - g) / (2.0 * e(l))
   r = sqrt(p*p + 1.0)
   if (p < 0.0) r = -r
   d(l) = e(l) / (p + r)
   h = g - d(l)
   do i = l1, n
      d(i) = d(i) - h
   end do
   f = f + h
!     ********** QL TRANSFORMATION **********
   p = d(m)
   c = 1.0
   s = 0.0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      g = c * e(i)
      h = c * p
      if (abs(p) < abs(e(i))) go to 150
      c = e(i) / p
      r = sqrt(c*c + 1.0)
      e(i + 1) = s * p * r
      s = c / r
      c = 1.0 / r
      go to 160
150   c = p / e(i)
      r = sqrt(c*c + 1.0)
      e(i + 1) = s * e(i) * r
      s = 1.0 / r
      c = c * s
160   p = c * d(i) - s * g
      d(i + 1) = h + s * (c * g + s * d(i))
!     ********** Form vector **********
      do k = 1, n
         h = z(k,i + 1)
         z(k,i + 1) = s * z(k,i) + c * h
         z(k,i) = c * z(k,i) - s * h
      end do
   end do
   e(l) = s * p
   d(l) = c * p
   if (abs(e(l)) > b) go to 130
220 d(l) = d(l) + f
end do
!     ********** Order eigenvalues and eigenvectors **********
do ii = 2, n
   i = ii - 1
   k = i
   p = d(i)
   do j = ii, n
      if (d(j) >= p) go to 260
      k = j
      p = d(j)
260   continue
   end do
   if (k == i) go to 300
   d(k) = d(i)
   d(i) = p
   do j = 1, n
      p = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = p
   end do
300 continue
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of tql2 **********
end subroutine tql2

pure subroutine imtql2(nm,n,d,e,z,ierr)
!! <!-- nswc-ford:begin IMTQL2 -->
!! Reference for `imtql2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,abs,spmpar
!!
!!      This subroutine is a translation of the Algol procedure imtql2,
!!      NUM. Math. 12, 377-383(1968) By Martin and Wilkinson,
!!      as modified in NUM. Math. 15, 450(1970) By Dubrulle.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 241-248(1971).
!!      This subroutine finds the eigenvalues and eigenvectors
!!      of a symmetric tridiagonal matrix BY the implicit QL method.
!!      The eigenvectors of a full symmetric matrix can also
!!      be found if  tred2  has been used to reduce this
!!      full matrix to tridiagonal form.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         d contains the diagonal elements of the input matrix,
!!         e contains the subdiagonal elements of the input matrix
!!           in its last n-1 positions.  e(1) is arbitrary,
!!         z contains the transformation matrix produced in the
!!           reduction by  tred2, if performed.  If the eigenvectors
!!           of the tridiagonal matrix are desired, z must contain
!!           the identity matrix.
!!       On output-
!!         d contains the eigenvalues in ascending order.  If an
!!           error exit is made, the eigenvalues are correct but
!!           unordered for indices 1,2,...,ierr-1,
!!         e has been destroyed,
!!         z contains orthonormal eigenvectors of the symmetric
!!           tridiagonal (or full) matrix.  If an error exit is made,
!!           z contains the eigenvectors associated with the stored
!!           eigenvalues,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, ii, mml
real :: b, c, f, g, p, r, s, machep
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure imtql2,
!     NUM. Math. 12, 377-383(1968) By Martin and Wilkinson,
!     as modified in NUM. Math. 15, 450(1970) By Dubrulle.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 241-248(1971).
!     This subroutine finds the eigenvalues and eigenvectors
!     of a symmetric tridiagonal matrix BY the implicit QL method.
!     The eigenvectors of a full symmetric matrix can also
!     be found if  tred2  has been used to reduce this
!     full matrix to tridiagonal form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary,
!        z contains the transformation matrix produced in the
!          reduction by  tred2, if performed.  If the eigenvectors
!          of the tridiagonal matrix are desired, z must contain
!          the identity matrix.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct but
!          unordered for indices 1,2,...,ierr-1,
!        e has been destroyed,
!        z contains orthonormal eigenvectors of the symmetric
!          tridiagonal (or full) matrix.  If an error exit is made,
!          z contains the eigenvectors associated with the stored
!          eigenvalues,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = spmpar(1)
!                **********
ierr = 0
if (n == 1) go to 1001
do i = 2, n
   e(i - 1) = e(i)
end do
e(n) = 0.0
do l = 1, n
   j = 0
!     ********** Look for small sub-diagonal element **********
105 do m = l, n
      if (m == n) exit
      if (abs(e(m)) <= machep * (abs(d(m)) + abs(d(m + 1)))) &
         & go to 120
   end do
120 p = d(l)
   if (m == l) go to 240
   if (j == 30) go to 1000
   j = j + 1
!     ********** Form shift **********
   g = (d(l + 1) - p) / (2.0 * e(l))
   r = sqrt(g*g + 1.0)
   if (g < 0.0) r = -r
   g = d(m) - p + e(l) / (g + r)
   s = 1.0
   c = 1.0
   p = 0.0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      f = s * e(i)
      b = c * e(i)
      if (abs(f) < abs(g)) go to 150
      c = g / f
      r = sqrt(c*c + 1.0)
      e(i + 1) = f * r
      s = 1.0 / r
      c = c * s
      go to 160
150   s = f / g
      r = sqrt(s*s + 1.0)
      e(i + 1) = g * r
      c = 1.0 / r
      s = s * c
160   g = d(i + 1) - p
      r = (d(i) - g) * s + 2.0 * c * b
      p = s * r
      d(i + 1) = g + p
      g = c * r - b
!     ********** Form vector **********
      do k = 1, n
         f = z(k,i + 1)
         z(k,i + 1) = s * z(k,i) + c * f
         z(k,i) = c * z(k,i) - s * f
      end do
   end do
   d(l) = d(l) - p
   e(l) = g
   e(m) = 0.0
   go to 105
240 continue
end do
!     ********** Order eigenvalues and eigenvectors **********
do ii = 2, n
   i = ii - 1
   k = i
   p = d(i)
   do j = ii, n
      if (d(j) >= p) go to 260
      k = j
      p = d(j)
260   continue
   end do
   if (k == i) go to 300
   d(k) = d(i)
   d(i) = p
   do j = 1, n
      p = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = p
   end do
300 continue
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of imtql2 **********
end subroutine imtql2

subroutine dseig(a, ka, n, w, t, ierr)
!! <!-- nswc-ford:begin DSEIG -->
!! Reference for `dseig`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Double precision computation of the
!!                eigenvalues of symmetric real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka
integer :: n
double precision, intent(inout) :: a(*), w(n), t(*)
!     beginning of local variable declarations
integer :: l
!-----------------------------------------------------------------------
!                Double precision computation of the
!               eigenvalues of symmetric real matrices
!-----------------------------------------------------------------------
if (ka == 0) then
   l = n*(n + 1)
   l = l/2
   call dtred3(n, l, a, w, t(n + 1), t(1))
   call dtql(n, w, t, ierr)
else
   call dtred1(ka, n, a, w, t(n + 1), t(1))
   call dtql(n, w, t, ierr)
end if
end subroutine dseig

pure subroutine dseigv(a, ka, n, w, z, t, ierr)
!! <!-- nswc-ford:begin DSEIGV -->
!! Reference for `dseigv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Double precision computation of
!!                  eigenvalues and eigenvectors of
!!                      symmetric real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: w(n), z(ka,n), t(n)
interface
   pure subroutine dtql2(nm,n,d,e,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: d(n)
      double precision, intent(inout) :: e(n)
      double precision, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine dtql2
   pure subroutine dtred2(nm,n,a,d,e,z)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(in) :: a(nm,n)
      double precision, intent(inout) :: d(n)
      double precision, intent(inout) :: e(n)
      double precision, intent(inout) :: z(nm,n)
   end subroutine dtred2
end interface
!-----------------------------------------------------------------------
!                 Double precision computation of
!                 eigenvalues and eigenvectors of
!                     symmetric real matrices
!-----------------------------------------------------------------------
call dtred2(ka, n, a, w, t, z)
call dtql2(ka, n, w, t, z, ierr)
end subroutine dseigv

pure subroutine dtred1(nm,n,a,d,e,e2)
!! <!-- nswc-ford:begin DTRED1 -->
!! Reference for `dtred1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision dsqrt,dabs
!!
!!      This subroutine is a translation of the Algol procedure tred1,
!!      NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!!      This subroutine reduces a real symmetric matrix
!!      to a symmetric tridiagonal matrix using
!!      orthogonal similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         a contains the real symmetric input matrix.  Only the
!!           lower triangle of the matrix need be supplied.
!!      On output-
!!         a contains information about the orthogonal trans-
!!           formations used in the reduction in its strict lower
!!           triangle.  The full upper triangle of A is unaltered,
!!         d contains the diagonal elements of the tridiagonal matrix,
!!         e contains the subdiagonal elements of the tridiagonal
!!           matrix in its last n-1 positions.  e(1) is set to zero,
!!         e2 contains the squares of the corresponding elements of e.
!!           e2 may coincide with e if the squares are not needed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
double precision, intent(inout) :: a(nm,n), d(n), e(n), e2(n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, jp1
double precision :: f, g, h, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tred1,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!     This subroutine reduces a real symmetric matrix
!     to a symmetric tridiagonal matrix using
!     orthogonal similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        a contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!     On output-
!        a contains information about the orthogonal trans-
!          formations used in the reduction in its strict lower
!          triangle.  The full upper triangle of A is unaltered,
!        d contains the diagonal elements of the tridiagonal matrix,
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!-----------------------------------------------------------------------
do i = 1, n
   d(i) = a(i,i)
end do
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   h = 0.d0
   scale = 0.d0
   if (l < 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      scale = scale + abs(a(i,k))
   end do
   if (scale /= 0.d0) go to 140
130 e(i) = 0.d0
   e2(i) = 0.d0
   go to 290
140 do k = 1, l
      a(i,k) = a(i,k) / scale
      h = h + a(i,k) * a(i,k)
   end do
   e2(i) = scale * scale * h
   f = a(i,l)
   g = sqrt(h)
   if (f >= 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   a(i,l) = f - g
   if (l == 1) go to 270
   f = 0.d0
   do j = 1, l
      g = 0.d0
!     ********** Form element of a*U **********
      do k = 1, j
         g = g + a(j,k) * a(i,k)
      end do
      jp1 = j + 1
      if (l < jp1) go to 220
      do k = jp1, l
         g = g + a(k,j) * a(i,k)
      end do
!     ********** Form element of P **********
220   e(j) = g / h
      f = f + e(j) * a(i,j)
   end do
   h = f / (h + h)
!     ********** Form reduced a **********
   do j = 1, l
      f = a(i,j)
      g = e(j) - h * f
      e(j) = g
      do k = 1, j
         a(j,k) = a(j,k) - f * e(k) - g * a(i,k)
      end do
   end do
270 do k = 1, l
      a(i,k) = scale * a(i,k)
   end do
290 h = d(i)
   d(i) = a(i,i)
   a(i,i) = h
end do
!     ********** Last card of dtred1 **********
end subroutine dtred1

pure subroutine dtred3(n,nv,a,d,e,e2)
!! <!-- nswc-ford:begin DTRED3 -->
!! Reference for `dtred3`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision dsqrt,dabs
!!
!!      This subroutine is a translation of the Algol procedure tred3,
!!      NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!!      This subroutine reduces a real symmetric matrix, stored as
!!      a one-dimensional array, to a symmetric tridiagonal matrix
!!      using orthogonal similarity transformations.
!!      On input-
!!         n is the order of the matrix,
!!         nv must be set to the dimension of the array parameter A
!!           as declared in the calling program dimension statement,
!!         a contains the lower triangle of the real symmetric
!!           input matrix, stored row-wise as a one-dimensional
!!           array, in its first n*(n+1)/2 positions.
!!      On output-
!!         a contains information about the orthogonal
!!           transformations used in the reduction,
!!         d contains the diagonal elements of the tridiagonal matrix,
!!         e contains the subdiagonal elements of the tridiagonal
!!           matrix in its last n-1 positions.  e(1) is set to zero,
!!         e2 contains the squares of the corresponding elements of e.
!!           e2 may coincide with e if the squares are not needed.
!!
!!      ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nv
double precision, intent(inout) :: a(nv), d(n), e(n), e2(n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, iz, jk
double precision :: f, g, h, hh, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tred3,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!     This subroutine reduces a real symmetric matrix, stored as
!     a one-dimensional array, to a symmetric tridiagonal matrix
!     using orthogonal similarity transformations.
!     On input-
!        n is the order of the matrix,
!        nv must be set to the dimension of the array parameter A
!          as declared in the calling program dimension statement,
!        a contains the lower triangle of the real symmetric
!          input matrix, stored row-wise as a one-dimensional
!          array, in its first n*(n+1)/2 positions.
!     On output-
!        a contains information about the orthogonal
!          transformations used in the reduction,
!        d contains the diagonal elements of the tridiagonal matrix,
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!-----------------------------------------------------------------------
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   iz = (i * l) / 2
   h = 0.d0
   scale = 0.d0
   if (l < 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      iz = iz + 1
      d(k) = a(iz)
      scale = scale + abs(d(k))
   end do
   if (scale /= 0.d0) go to 140
130 e(i) = 0.d0
   e2(i) = 0.d0
   go to 290
140 do k = 1, l
      d(k) = d(k) / scale
      h = h + d(k) * d(k)
   end do
   e2(i) = scale * scale * h
   f = d(l)
   g = sqrt(h)
   if (f >= 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   d(l) = f - g
   a(iz) = scale * d(l)
   if (l == 1) go to 290
   f = 0.d0
   do j = 1, l
      g = 0.d0
      jk = (j * (j - 1)) / 2
!     ********** Form element of a*U **********
      do k = 1, l
         jk = jk + 1
         if (k > j) jk = jk + k - 2
         g = g + a(jk) * d(k)
      end do
!     ********** Form element of P **********
      e(j) = g / h
      f = f + e(j) * d(j)
   end do
   hh = f / (h + h)
   jk = 0
!     ********** Form reduced a **********
   do j = 1, l
      f = d(j)
      g = e(j) - hh * f
      e(j) = g
      do k = 1, j
         jk = jk + 1
         a(jk) = a(jk) - f * e(k) - g * d(k)
      end do
   end do
290 d(i) = a(iz + 1)
   a(iz + 1) = scale * sqrt(h)
end do
!     ********** Last card of dtred3 **********
end subroutine dtred3

pure subroutine dtql(n,d,e2,ierr)
!! <!-- nswc-ford:begin DTQL -->
!! Reference for `dtql`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure tqlrat,
!!      algorithm 464, comm. ACM 16, 689(1973) by Reinsch.
!!      This subroutine finds the eigenvalues of a symmetric
!!      tridiagonal matrix BY the rational QL method.
!!      On input-
!!         n is the order of the matrix,
!!         d contains the diagonal elements of the input matrix,
!!         e2 contains the squares of the subdiagonal elements of the
!!           input matrix in its last n-1 positions.  e2(1) is arbitrary.
!!       On output-
!!         d contains the eigenvalues in ascending order.  If an
!!           error exit is made, the eigenvalues are correct and
!!           ordered for indices 1,2,...ierr-1, but may not be
!!           the smallest eigenvalues,
!!         e2 has been destroyed,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 50 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(out) :: ierr
double precision, intent(inout) :: d(n), e2(n)
!     beginning of local variable declarations
integer :: i, j, l, m, ii, l1, mml
double precision :: b, c, f, g, h, p, r, s, machep
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tqlrat,
!     algorithm 464, comm. ACM 16, 689(1973) by Reinsch.
!     This subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!     On input-
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e2 contains the squares of the subdiagonal elements of the
!          input matrix in its last n-1 positions.  e2(1) is arbitrary.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!        e2 has been destroyed,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = dpmpar(1)
!                **********
ierr = 0
if (n == 1) go to 1001
do i = 2, n
   e2(i - 1) = e2(i)
end do
f = 0.d0
b = 0.d0
e2(n) = 0.d0
do l = 1, n
   j = 0
   h = machep * (abs(d(l)) + sqrt(e2(l)))
   if (b > h) go to 105
   b = h
   c = b * b
!     ********** Look for small squared sub-diagonal element **********
105 do m = l, n
      if (e2(m) <= c) exit
!     ********** e2(n) is always zero, so there is no exit
!                through the bottom of the loop **********
   end do
   if (m == l) go to 210
130 if (j == 50) go to 1000
   j = j + 1
!     ********** Form shift **********
   l1 = l + 1
   s = sqrt(e2(l))
   g = d(l)
   p = (d(l1) - g) / (2.d0 * s)
   r = sqrt(p*p + 1.d0)
   if (p < 0.d0) r = -r
   d(l) = s / (p + r)
   h = g - d(l)
   do i = l1, n
      d(i) = d(i) - h
   end do
   f = f + h
!     ********** RATIONAL QL TRANSFORMATION **********
   g = d(m)
   if (g == 0.d0) g = b
   h = g
   s = 0.d0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      p = g * h
      r = p + e2(i)
      e2(i + 1) = s * r
      s = e2(i) / r
      d(i + 1) = h + s * (h + d(i))
      g = d(i) - e2(i) / g
      if (g == 0.d0) g = b
      h = g * p / r
   end do
   e2(l) = s * g
   d(l) = h
!     ********** Guard against underflow in convergence test **********
   if (h == 0.d0) go to 210
   if (abs(e2(l)) <= abs(c/h)) go to 210
   e2(l) = h * e2(l)
   if (e2(l) /= 0.d0) go to 130
210 p = d(l) + f
!     ********** Order eigenvalues **********
   if (l == 1) go to 250
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2, l
      i = l + 2 - ii
      if (p >= d(i - 1)) go to 270
      d(i) = d(i - 1)
   end do
250 i = 1
270 d(i) = p
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of dtql **********
end subroutine dtql

