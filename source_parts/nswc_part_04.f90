pure subroutine dtip(a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
double precision, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
   & npower, ifact(8), ipower(8), nexp(8), iexp(8)
double precision :: atemp, btemp
interface
   pure subroutine infctr(n,ifact,ipower,nexp,npower)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ifact(*)
      integer, intent(inout) :: ipower(*)
      integer, intent(inout) :: nexp(*)
      integer, intent(inout) :: npower
   end subroutine infctr
end interface
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
if (n1 < 2 .or. n2 < 2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1 /= n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max = n,m,n
   i2 = i1min + n - 1
   do i1 = i1min,i1max
      atemp = a(i1)
      a(i1) = a(i2)
      a(i2) = atemp
      i2 = i2 + n
   end do
   i1min = i1min + n + 1
end do
return
! Modulus M is factored into prime powers.  Eight factors
! suffice up to M = 2*3*5*7*11*13*17*19 = 9,767,520.
30 ndim = 0
call infctr(m, ifact, ipower, nexp, npower)
do ip = 1,npower
   iexp(ip) = 0
end do
! Generate every divisor of M less than M/2
idiv = 1
mhalf = m/2
50 if (idiv >= mhalf) return
! The number of elements whose index is divisible by idiv
! and by no other divisor of M is the Euler totient
! function, phi(M/idiv).
ncount = m/idiv
do ip = 1,npower
   if (iexp(ip) == nexp(ip)) go to 60
   ncount = (ncount/ifact(ip))*(ifact(ip) - 1)
60 continue
end do
if (nwork <= 0) go to 75
do i = 1,nwork
   moved(i) = 0
end do
75 istart = idiv
! The starting point of a subcycle is divisible only by idiv
! and must not appear in any other subcycle.
80 mmist = m - istart
if (istart == idiv) go to 120
ndim = max(ndim,istart)
if (istart > nwork) go to 90
if (moved(istart) /= 0) go to 160
90 isoid = istart/idiv
do ip = 1,npower
   if (iexp(ip) == nexp(ip)) go to 100
   if (mod(isoid,ifact(ip)) == 0) go to 160
100 continue
end do
if (istart <= nwork) go to 120
itest = istart
110 itest = mod(n*itest,m)
if (itest < istart .or. itest > mmist) go to 160
if (itest > istart .and. itest < mmist) go to 110
120 atemp = a(istart + 1)
btemp = a(mmist + 1)
ia1 = istart
130 ia2 = mod(n*ia1,m)
mmia1 = m - ia1
mmia2 = m - ia2
if (ia1 <= nwork) moved(ia1) = 1
if (mmia1 <= nwork) moved(mmia1) = 1
ncount = ncount - 2
! Move two elements, the second from the negative
! subcycle.  Check first for subcycle closure.
if (ia2 == istart) go to 140
if (mmia2 == istart) go to 150
a(ia1 + 1) = a(ia2 + 1)
a(mmia1 + 1) = a(mmia2 + 1)
ia1 = ia2
go to 130
140 a(ia1 + 1) = atemp
a(mmia1 + 1) = btemp
go to 160
150 a(ia1 + 1) = btemp
a(mmia1 + 1) = atemp
160 istart = istart + idiv
if (ncount > 0) go to 80
do ip = 1,npower
   if (iexp(ip) == nexp(ip)) go to 170
   iexp(ip) = iexp(ip) + 1
   idiv = idiv*ifact(ip)
   go to 50
170 iexp(ip) = 0
   idiv = idiv/ipower(ip)
end do
return
200 if (n1 /= n2) ndim = 0
end subroutine dtip

pure subroutine ctip(a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
complex, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
   & npower, ifact(8), ipower(8), nexp(8), iexp(8)
complex :: atemp, btemp
interface
   pure subroutine infctr(n,ifact,ipower,nexp,npower)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ifact(*)
      integer, intent(inout) :: ipower(*)
      integer, intent(inout) :: nexp(*)
      integer, intent(inout) :: npower
   end subroutine infctr
end interface
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
if (n1 < 2 .or. n2 < 2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1 /= n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max = n,m,n
   i2 = i1min + n - 1
   do i1 = i1min,i1max
      atemp = a(i1)
      a(i1) = a(i2)
      a(i2) = atemp
      i2 = i2 + n
   end do
   i1min = i1min + n + 1
end do
return
! Modulus M is factored into prime powers.  Eight factors
! suffice up to M = 2*3*5*7*11*13*17*19 = 9,767,520.
30 ndim = 0
call infctr(m, ifact, ipower, nexp, npower)
do ip = 1,npower
   iexp(ip) = 0
end do
! Generate every divisor of M less than M/2
idiv = 1
mhalf = m/2
50 if (idiv >= mhalf) return
! The number of elements whose index is divisible by idiv
! and by no other divisor of M is the Euler totient
! function, phi(M/idiv).
ncount = m/idiv
do ip = 1,npower
   if (iexp(ip) == nexp(ip)) go to 60
   ncount = (ncount/ifact(ip))*(ifact(ip) - 1)
60 continue
end do
if (nwork <= 0) go to 75
do i = 1,nwork
   moved(i) = 0
end do
75 istart = idiv
! The starting point of a subcycle is divisible only by idiv
! and must not appear in any other subcycle.
80 mmist = m - istart
if (istart == idiv) go to 120
ndim = max(ndim,istart)
if (istart > nwork) go to 90
if (moved(istart) /= 0) go to 160
90 isoid = istart/idiv
do ip = 1,npower
   if (iexp(ip) == nexp(ip)) go to 100
   if (mod(isoid,ifact(ip)) == 0) go to 160
100 continue
end do
if (istart <= nwork) go to 120
itest = istart
110 itest = mod(n*itest,m)
if (itest < istart .or. itest > mmist) go to 160
if (itest > istart .and. itest < mmist) go to 110
120 atemp = a(istart + 1)
btemp = a(mmist + 1)
ia1 = istart
130 ia2 = mod(n*ia1,m)
mmia1 = m - ia1
mmia2 = m - ia2
if (ia1 <= nwork) moved(ia1) = 1
if (mmia1 <= nwork) moved(mmia1) = 1
ncount = ncount - 2
! Move two elements, the second from the negative
! subcycle.  Check first for subcycle closure.
if (ia2 == istart) go to 140
if (mmia2 == istart) go to 150
a(ia1 + 1) = a(ia2 + 1)
a(mmia1 + 1) = a(mmia2 + 1)
ia1 = ia2
go to 130
140 a(ia1 + 1) = atemp
a(mmia1 + 1) = btemp
go to 160
150 a(ia1 + 1) = btemp
a(mmia1 + 1) = atemp
160 istart = istart + idiv
if (ncount > 0) go to 80
do ip = 1,npower
   if (iexp(ip) == nexp(ip)) go to 170
   iexp(ip) = iexp(ip) + 1
   idiv = idiv*ifact(ip)
   go to 50
170 iexp(ip) = 0
   idiv = idiv/ipower(ip)
end do
return
200 if (n1 /= n2) ndim = 0
end subroutine ctip

pure subroutine infctr(n, ifact, ipower, nexp, npower)
implicit none
integer, intent(inout) :: ifact(*), ipower(*)
integer, intent(in) :: n
integer, intent(inout) :: nexp(*), npower
integer :: idiv, ifcur, ip, iquot, npart
! Factor n into its prime powers, npower in number.
! E.G., FOR n=1960=2**3 *5 *7**2, npower=3, ifact=2,5,7,
! ipower=8,5,49, AND nexp=3,1,2.
ip = 0
ifcur = 0
npart = n
idiv = 2
10 iquot = npart/idiv
if ( ( npart - idiv * iquot ) == 0 ) go to 20
go to 60
20 if ( ( idiv - ifcur ) <= 0 ) go to 40
go to 30
30 ip = ip + 1
ifact(ip) = idiv
ipower(ip) = idiv
ifcur = idiv
nexp(ip) = 1
go to 50
40 ipower(ip) = idiv*ipower(ip)
nexp(ip) = nexp(ip) + 1
50 npart = iquot
go to 10
60 if ( ( iquot - idiv ) <= 0 ) go to 100
go to 70
70 if ( ( idiv - 2 ) <= 0 ) go to 80
go to 90
80 idiv = 3
go to 10
90 idiv = idiv + 2
go to 10
100 if ( ( npart - 1 ) <= 0 ) go to 140
go to 110
110 if ( ( npart - ifcur ) <= 0 ) go to 130
go to 120
120 ip = ip + 1
ifact(ip) = npart
ipower(ip) = npart
nexp(ip) = 1
go to 140
130 ipower(ip) = npart*ipower(ip)
nexp(ip) = nexp(ip) + 1
140 npower = ip
end subroutine infctr

pure subroutine cmadj(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
integer :: i, j
do j = 1,n
   do i = 1,m
      b(j,i) = conjg(a(i,j))
   end do
end do
end subroutine cmadj

pure subroutine ctrans(nm, n, a)
implicit none
!     Subroutine ctrans finds the complex conjugate of an input
!     matrix.
!     On entry,
!     nm is the leading dimension of matrix a in the main program.
!     n  is the order of matrix a.
!     A  is the input matrix.
!     On return,
!     a  contains its conjugate transpose.
integer, intent(in) :: n, nm
complex, intent(inout) :: a(nm,n)
integer :: i, j
complex :: temp
do i = 1,n
   do j = i,n
      temp = a(i,j)
      a(i,j) = conjg(a(j,i))
      a(j,i) = conjg(temp)
   end do
end do
end subroutine ctrans

pure subroutine madd(m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                      Addition of real matrices
!-----------------------------------------------------------------------
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
end subroutine madd

pure subroutine dmadd(m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                Addition of double precision matrices
!-----------------------------------------------------------------------
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
end subroutine dmadd

pure subroutine cmadd(m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                   Addition of complex matrices
!-----------------------------------------------------------------------
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
end subroutine cmadd

pure subroutine smadd(n,a,b,c)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: k, m
m = (n*(n + 1))/2
do k = 1,m
   c(k) = a(k) + b(k)
end do
end subroutine smadd

pure subroutine msubt(m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                     Subtraction of real matrices
!-----------------------------------------------------------------------
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
end subroutine msubt

pure subroutine dmsubt(m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!              Subtraction of double precision matrices
!-----------------------------------------------------------------------
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
end subroutine dmsubt

pure subroutine cmsubt(m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                  Subtraction of complex matrices
!-----------------------------------------------------------------------
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
end subroutine cmsubt

pure subroutine smsubt(n,a,b,c)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: k, m
m = (n*(n + 1))/2
do k = 1,m
   c(k) = a(k) - b(k)
end do
end subroutine smsubt

pure subroutine mtms(m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
integer :: i, j, k
double precision :: w
!-----------------------------------------------------------------------
!                     Product of real matrices
!-----------------------------------------------------------------------
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + dble(a(i,k))*dble(b(k,j))
      end do
      c(i,j) = w
   end do
end do
end subroutine mtms

pure subroutine dmtms(m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,l)
integer :: i, j, k
double precision :: w
!-----------------------------------------------------------------------
!                Product of double precision matrices
!-----------------------------------------------------------------------
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      c(i,j) = w
   end do
end do
end subroutine dmtms

pure subroutine cmtms(m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,l)
integer :: i, j, k
complex :: w
!-----------------------------------------------------------------------
!                   Product of complex matrices
!-----------------------------------------------------------------------
do j = 1,l
   do i = 1,m
      w = (0.0,0.0)
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      c(i,j) = w
   end do
end do
end subroutine cmtms

subroutine mprod(m, n, l, a, ka, b, kb, c, kc, row)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
integer :: i, j, k
real :: save
double precision :: w
logical :: rloc
!-----------------------------------------------------------------------
!                     Product of real matrices
!-----------------------------------------------------------------------
save = c(1,1)
c(1,1) = 1.0
if (rloc(c,a)) go to 20
if (rloc(c,b)) go to 30
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + dble(a(i,k))*dble(b(k,j))
      end do
      c(i,j) = w
   end do
end do
return
!     Here c begins in the same location as A. the dimension of row
!     must be greater than or equal to l. it is assumed that kc=ka.
20 a(1,1) = save
do i = 1,m
   do j = 1,l
      w = 0.d0
      do k = 1,n
         w = w + dble(a(i,k))*dble(b(k,j))
      end do
      row(j) = w
   end do
   do j = 1,l
      a(i,j) = row(j)
   end do
end do
return
!     Here c begins in the same location as b. the dimension of row
!     must be greater than or equal to m. it is assumed that kc=kb.
30 b(1,1) = save
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + dble(a(i,k))*dble(b(k,j))
      end do
      row(i) = w
   end do
   do i = 1,m
      b(i,j) = row(i)
   end do
end do
end subroutine mprod

logical function rloc(x, y)
implicit none
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
real :: xold, yold
!-----------------------------------------------------------------------
!     x and y are arrays. It is assumed that x(1) and y(1) contain data.
!     rloc(x,y) = .TRUE.   if x and y begin in the same location
!     rloc(x,y) = .FALSE.  if x and y begin in different locations
!     it is recommended that this coding not be optimized by eliminating
!     the subroutine ychg. If it is optimized then rloc may not compile
!     properly.
!-----------------------------------------------------------------------
xold = x(1)
yold = y(1)
call ychg(x,y,yold)
if (x(1) == xold) go to 10
!     x and y begin in the same location
y(1) = yold
rloc = .true.
return
!     x and y begin in different locations
10 y(1) = yold
rloc = .false.
end function rloc

pure subroutine ychg(x, y, yold)
implicit none
real, intent(in) :: yold
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
y(1) = 0.0
if (yold == 0.0) y(1) = 1.0
end subroutine ychg

subroutine dmprod(m, n, l, a, ka, b, kb, c, kc, row)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), &
   & row(*)
integer :: i, j, k
double precision :: w
logical :: dloc
!-----------------------------------------------------------------------
!                Product of double precision matrices
!-----------------------------------------------------------------------
w = c(1,1)
c(1,1) = 1.d0
if (dloc(c,a)) go to 20
if (dloc(c,b)) go to 30
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      c(i,j) = w
   end do
end do
return
!     Here c begins in the same location as A. the dimension of row
!     must be greater than or equal to l. it is assumed that kc=ka.
20 a(1,1) = w
do i = 1,m
   do j = 1,l
      w = 0.d0
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      row(j) = w
   end do
   do j = 1,l
      a(i,j) = row(j)
   end do
end do
return
!     Here c begins in the same location as b. the dimension of row
!     must be greater than or equal to m. it is assumed that kc=kb.
30 b(1,1) = w
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      row(i) = w
   end do
   do i = 1,m
      b(i,j) = row(i)
   end do
end do
end subroutine dmprod

logical function dloc(x, y)
implicit none
!-----------------------------------------------------------------------
!     x and y are arrays. It is assumed that x(1) and y(1) contain data.
!     dloc(x,y) = .TRUE.   if x and y begin in the same location
!     dloc(x,y) = .FALSE.  if x and y begin in different locations
!     it is recommended that this coding not be optimized by eliminating
!     the subroutine dychg. If it is optimized then dloc may not compile
!     properly.
!-----------------------------------------------------------------------
double precision, intent(in) :: x(*)
double precision, intent(inout) :: y(*)
double precision :: xold, yold
xold = x(1)
yold = y(1)
call dychg(x,y,yold)
if (x(1) == xold) go to 10
!     x and y begin in the same location
y(1) = yold
dloc = .true.
return
!     x and y begin in different locations
10 y(1) = yold
dloc = .false.
end function dloc

pure subroutine dychg(x, y, yold)
implicit none
double precision, intent(in) :: x(*)
double precision, intent(inout) :: y(*)
double precision, intent(in) :: yold
y(1) = 0.d0
if (yold == 0.d0) y(1) = 1.d0
end subroutine dychg

subroutine cmprod(m, n, l, a, ka, b, kb, c, kc, row)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
complex, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
integer :: i, j, k
complex :: w
logical :: cloc
!-----------------------------------------------------------------------
!                   Product of complex matrices
!-----------------------------------------------------------------------
w = c(1,1)
c(1,1) = (1.0,0.0)
if (cloc(c,a)) go to 20
if (cloc(c,b)) go to 30
do j = 1,l
   do i = 1,m
      w = (0.0,0.0)
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      c(i,j) = w
   end do
end do
return
!     Here c begins in the same location as A. the dimension of row
!     must be greater than or equal to l. it is assumed that kc=ka.
20 a(1,1) = w
do i = 1,m
   do j = 1,l
      w = (0.0,0.0)
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      row(j) = w
   end do
   do j = 1,l
      a(i,j) = row(j)
   end do
end do
return
!     Here c begins in the same location as b. the dimension of row
!     must be greater than or equal to m. it is assumed that kc=kb.
30 b(1,1) = w
do j = 1,l
   do i = 1,m
      w = (0.0,0.0)
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      row(i) = w
   end do
   do i = 1,m
      b(i,j) = row(i)
   end do
end do
end subroutine cmprod

logical function cloc(x, y)
implicit none
!-----------------------------------------------------------------------
!     x and y are arrays. It is assumed that x(1) and y(1) contain data.
!     cloc(x,y) = .TRUE.   if x and y begin in the same location
!     cloc(x,y) = .FALSE.  if x and y begin in different locations
!     it is recommended that this coding not be optimized by eliminating
!     the subroutine cychg. If it is optimized then cloc may not compile
!     properly.
!-----------------------------------------------------------------------
complex, intent(in) :: x(*)
complex, intent(inout) :: y(*)
complex :: xold, yold
xold = x(1)
yold = y(1)
call cychg(x,y,yold)
if (x(1) == xold) go to 10
!     x and y begin in the same location
y(1) = yold
cloc = .true.
return
!     x and y begin in different locations
10 y(1) = yold
cloc = .false.
end function cloc

pure subroutine cychg(x, y, yold)
implicit none
complex, intent(in) :: x(*)
complex, intent(inout) :: y(*)
complex, intent(in) :: yold
complex, parameter :: zero = (0.0,0.0)
complex, parameter :: one = (1.0,0.0)
y(1) = zero
if (yold == zero) y(1) = one
end subroutine cychg

pure subroutine svprd(a,n,x,y)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(n)
integer :: i, k, km1, l
real :: xk, yk
y(1) = a(1)*x(1)
if (n == 1) return
l = 1
do k = 2,n
   km1 = k - 1
   xk = x(k)
   yk = 0.0
   do i = 1,km1
      l = l + 1
      y(i) = y(i) + a(l)*xk
      yk = yk + a(l)*x(i)
   end do
   l = l + 1
   y(k) = yk + a(l)*xk
end do
end subroutine svprd

pure subroutine dsvprd(a,n,x,y)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(n)
integer :: i, k, km1, l
double precision :: xk, yk
y(1) = a(1)*x(1)
if (n == 1) return
l = 1
do k = 2,n
   km1 = k - 1
   xk = x(k)
   yk = 0.d0
   do i = 1,km1
      l = l + 1
      y(i) = y(i) + a(l)*xk
      yk = yk + a(l)*x(i)
   end do
   l = l + 1
   y(k) = yk + a(l)*xk
end do
end subroutine dsvprd

pure subroutine tmprod(m,n,l,a,ka,b,kb,c,kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
integer :: i, j, k
double precision :: s
do j = 1,l
   do i = 1,n
      s = 0.d0
      do k = 1,m
         s = s + dble(a(k,i))*dble(b(k,j))
      end do
      c(i,j) = s
   end do
end do
end subroutine tmprod

pure subroutine smprod(m,n,a,ka,b)
implicit none
integer, intent(in) :: ka, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
integer :: i, ii, j, k
double precision :: s
ii = 1
do i = 1,n
   do j = 1,i
      s = 0.d0
      do k = 1,m
         s = s + dble(a(k,i))*dble(a(k,j))
      end do
      b(ii) = s
      ii = ii + 1
   end do
end do
end subroutine smprod

pure subroutine kprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,*)
integer :: i, ii, j, jj, r, s
!     ******************************************************************
!     Kronecker product of real matrices A and b
!     ******************************************************************
j = 0
do s = 1,n
   do jj = 1,l
      j = j + 1
!        Compute the j-TH column of c
      i = 0
      do r = 1,m
         do ii = 1,k
            i = i + 1
            c(i,j) = a(r,s)*b(ii,jj)
         end do
      end do
   end do
end do
end subroutine kprod

pure subroutine dkprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,*)
integer :: i, ii, j, jj, r, s
!     ******************************************************************
!     Kronecker product of double precision matrices A and b
!     ******************************************************************
j = 0
do s = 1,n
   do jj = 1,l
      j = j + 1
!        Compute the j-TH column of c
      i = 0
      do r = 1,m
         do ii = 1,k
            i = i + 1
            c(i,j) = a(r,s)*b(ii,jj)
         end do
      end do
   end do
end do
end subroutine dkprod

pure subroutine ckprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,*)
integer :: i, ii, j, jj, r, s
!     ******************************************************************
!     Kronecker product of complex matrices A and b
!     ******************************************************************
j = 0
do s = 1,n
   do jj = 1,l
      j = j + 1
!        Compute the j-TH column of c
      i = 0
      do r = 1,m
         do ii = 1,k
            i = i + 1
            c(i,j) = a(r,s)*b(ii,jj)
         end do
      end do
   end do
end do
end subroutine ckprod

pure subroutine rnk(a, mda, m, n, re, ae, krank, ksure, work, iwork)
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
real, intent(in) :: ae, re
real, intent(inout) :: a(mda,n), work(*)
integer, intent(inout) :: iwork(*)
integer :: i, imax, m0, m1, m2, m3, m4, m5
real :: eps, rerr
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
   pure subroutine u11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
      & ic,ir)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      real, intent(inout) :: a(mda,n)
      real, intent(inout) :: ub(n)
      real, intent(inout) :: db(n)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      real, intent(inout) :: h(n)
      real, intent(inout) :: w(n)
      real, intent(inout) :: eb(n)
      integer, intent(inout) :: ic(n)
      integer, intent(inout) :: ir(m)
   end subroutine u11ls
   pure subroutine u11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
      & ir,ic)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      real, intent(inout) :: a(mda,n)
      real, intent(inout) :: ub(m)
      real, intent(inout) :: db(m)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      real, intent(inout) :: h(m)
      real, intent(inout) :: w(m)
      real, intent(inout) :: eb(m)
      integer, intent(inout) :: ir(m)
      integer, intent(inout) :: ic(n)
   end subroutine u11us
end interface
!-----------------------------------------------------------------------
!          Upper and lower bounds of the rank of a real matrix
!-----------------------------------------------------------------------
!     real work(5*m0)  where m0 = 5*min0(m,n)
!     integer iwork(m + n)
!--------------------
m0 = min(m,n)
!     Define the relative and absolute tolerance lists
m1 = 1
m2 = m1 + m0
m3 = m2 + m0
m4 = m3 + m0
m5 = m4 + m0
eps = 10.0*spmpar(1)
rerr = max(eps,re)
imax = m5 - 1
do i = m4,imax
   work(i) = rerr
end do
imax = imax + m0
do i = m5,imax
   work(i) = ae
end do
!     Factor the matrix a
if (m < n) go to 40
call u11ls(a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
40 call u11us(a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
end subroutine rnk

pure subroutine drnk(a, mda, m, n, re, ae, krank, ksure, work, iwork)
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
double precision, intent(inout) :: a(mda,n)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: work(*)
integer, intent(inout) :: iwork(*)
integer :: i, imax, m0, m1, m2, m3, m4, m5
double precision :: eps, rerr
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure subroutine du11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb &
      & ,ic,ir)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      double precision, intent(inout) :: a(mda,n)
      double precision, intent(inout) :: ub(n)
      double precision, intent(inout) :: db(n)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      double precision, intent(inout) :: h(n)
      double precision, intent(inout) :: w(n)
      double precision, intent(inout) :: eb(n)
      integer, intent(inout) :: ic(n)
      integer, intent(inout) :: ir(m)
   end subroutine du11ls
   pure subroutine du11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb &
      & ,ir,ic)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      double precision, intent(inout) :: a(mda,n)
      double precision, intent(inout) :: ub(m)
      double precision, intent(inout) :: db(m)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      double precision, intent(inout) :: h(m)
      double precision, intent(inout) :: w(m)
      double precision, intent(inout) :: eb(m)
      integer, intent(inout) :: ir(m)
      integer, intent(inout) :: ic(n)
   end subroutine du11us
end interface
!-----------------------------------------------------------------------
!              Upper and lower bounds of the rank of A
!                      double precision matrix
!-----------------------------------------------------------------------
!     double precision work(5*m0)  where m0 = 5*min0(m,n)
!     integer iwork(m + n)
!--------------------
m0 = min(m,n)
!     Define the relative and absolute tolerance lists
m1 = 1
m2 = m1 + m0
m3 = m2 + m0
m4 = m3 + m0
m5 = m4 + m0
eps = 10.d0*dpmpar(1)
rerr = max(eps,re)
imax = m5 - 1
do i = m4,imax
   work(i) = rerr
end do
imax = imax + m0
do i = m5,imax
   work(i) = ae
end do
!     Factor the matrix a
if (m < n) go to 40
call du11ls(a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
40 call du11us(a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
end subroutine drnk

pure subroutine crout(mo,n,m,a,ka,b,kb,d,index,temp)
implicit none
integer, intent(inout) :: index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), d, temp(*)
integer :: i, im1, j, jp1, k, kj, km1, kp1, l, lj, maxb, nj, nm1, nmj, nmk, onej
real :: p, t
double precision :: dsum
!-----------------------------------------------------------------------
!     crout procedure for inverting matrices and solving equations
!-----------------------------------------------------------------------
!     A is a matrix of order n where n is greater than or equal to 1.
!     If mo=0 Then the inverse of A is computed and stored in A. if mo
!     is not 0 then the inverse is not computed.
!     If m is greater than 0 then b is a matrix having n rows and m
!     columns. In this case AX=b is solved and the solution X is stored
!     in b. if m=0 Then there are no equations to be solved.
!     ka = The length of the columns of the array a
!     kb = The length of the columns of the array b (if m.GT.0)
!     the determinant d of A is always computed. If d=0 Then the
!     routine immediately terminates.
!     Index is an array of dimension n-1 or larger that is used by the
!     routine for keeping track of the row interchanges that are made.
!     If mo is not 0 then this array is not needed.
!     Temp is an array of dimension n or larger that is used when A
!     is inverted. If mo is not 0 then this array is not needed.
!-----------------------------------------------------------------------
if (n < 2) go to 200
d = 1.0
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!               Search for the k-TH pivot element
   p = abs(a(k,k))
   l = k
   do i = kp1,n
      t = abs(a(i,k))
      if (p >= t) go to 10
      p = t
      l = i
10    continue
   end do
   p = a(l,k)
   d = p*d
   if (d == 0.0) return
   if (mo == 0) index(k) = l
   if (k == l) go to 40
   d = -d
!                  Interchanging rows k and l
   do j = 1,n
      t = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = t
   end do
   if (m <= 0) go to 40
   kj = k
   lj = l
   do j = 1,m
      t = b(kj)
      b(kj) = b(lj)
      b(lj) = t
      kj = kj + kb
      lj = lj + kb
   end do
!                  Compute the k-TH row of U
40 if (k > 1) go to 50
   do j = kp1,n
      a(k,j) = a(k,j)/p
   end do
   go to 60
50 do j = kp1,n
      dsum = a(k,j)
      do l = 1,km1
         dsum = dsum - dble(a(k,l))*dble(a(l,j))
      end do
      a(k,j) = sngl(dsum)/p
   end do
!               Compute the (k+1)-ST column of l
60 do i = kp1,n
      dsum = a(i,kp1)
      do l = 1,k
         dsum = dsum - dble(a(i,l))*dble(a(l,kp1))
      end do
      a(i,kp1) = dsum
   end do
   km1 = k
end do
!                 Check the n-TH pivot element
d = a(n,n)*d
if (d == 0.0) return
!                 Solving the equation LY = b
if (m <= 0) go to 120
maxb = kb*m
do onej = 1,maxb,kb
   kj = onej
   b(kj) = b(kj)/a(1,1)
   do k = 2,n
      kj = kj + 1
      dsum = b(kj)
      km1 = k - 1
      lj = onej
      do l = 1,km1
         dsum = dsum - dble(a(k,l))*dble(b(lj))
         lj = lj + 1
      end do
      b(kj) = sngl(dsum)/a(k,k)
   end do
end do
!                 Solving the equation UX = Y
do nj = n,maxb,kb
   kj = nj
   do nmk = 1,nm1
      k = n - nmk
      lj = kj
      kj = kj - 1
      dsum = b(kj)
      kp1 = k + 1
      do l = kp1,n
         dsum = dsum - dble(a(k,l))*dble(b(lj))
         lj = lj + 1
      end do
      b(kj) = dsum
   end do
end do
!               Replace l with the inverse of l
120 if (mo /= 0) return
do j = 1,nm1
   a(j,j) = 1.0/a(j,j)
   jp1 = j + 1
   do i = jp1,n
      dsum = 0.d0
      im1 = i - 1
      do l = j,im1
         dsum = dsum + dble(a(i,l))*dble(a(l,j))
      end do
      a(i,j) = -sngl(dsum)/a(i,i)
   end do
end do
a(n,n) = 1.0/a(n,n)
!           Solve UX = Y where Y is the inverse of l
do nmk = 1,nm1
   k = n - nmk
   kp1 = k + 1
   do j = kp1,n
      temp(j) = a(k,j)
      a(k,j) = 0.0
   end do
   do j = 1,n
      dsum = a(k,j)
      do l = kp1,n
         dsum = dsum - dble(temp(l))*dble(a(l,j))
      end do
      a(k,j) = dsum
   end do
end do
!                    Column interchanges
do nmj = 1,nm1
   j = n - nmj
   k = index(j)
   if (j == k) go to 161
   do i = 1,n
      t = a(i,j)
      a(i,j) = a(i,k)
      a(i,k) = t
   end do
161 continue
end do
return
!                      Case when n = 1
200 d = a(1,1)
if (d == 0.0) return
if (mo == 0) a(1,1) = 1.0/d
if (m <= 0) return
maxb = kb*m
do kj = 1,maxb,kb
   b(kj) = b(kj)/d
end do
end subroutine crout

pure subroutine krout(mo,n,m,a,ka,b,kb,ierr,index,temp)
implicit none
integer, intent(inout) :: ierr, index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), temp(*)
integer :: i, im1, j, jp1, k, kj, km1, kp1, l, lj, maxb, nj, nm1, nmj, nmk, onej
real :: d, p, t
double precision :: dsum
!-----------------------------------------------------------------------
!     crout procedure for inverting matrices and solving equations
!-----------------------------------------------------------------------
!     A is a matrix of order n where n is greater than or equal to 1.
!     If mo=0 Then the inverse of A is computed and stored in A. if mo
!     is not 0 then the inverse is not computed.
!     If m is greater than 0 then b is a matrix having n rows and m
!     columns. In this case AX=b is solved and the solution X is stored
!     in b. if m=0 Then there are no equations to be solved.
!     ka = The length of the columns of the array a
!     kb = The length of the columns of the array b (if m.GT.0)
!     ierr is a variable that reports the status of the results. When
!     the routine terminates ierr has one of the following values ...
!        ierr =  0   The requested task was performed.
!        ierr = -1   Either n, ka, or kb is incorrect.
!        ierr =  k   the k-TH pivot element is 0.
!     Index is an array of dimension n-1 or larger that is used by the
!     routine for keeping track of the row interchanges that are made.
!     If mo is not 0 then this array is not needed.
!     Temp is an array of dimension n or larger that is used when A
!     is inverted. If mo is not 0 then this array is not needed.
!-----------------------------------------------------------------------
if (n < 1 .or. ka < n) go to 320
if (m <= 0) go to 5
if (kb < n) go to 320
5 ierr = 0
if (n < 2) go to 200
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!               Search for the k-TH pivot element
   p = abs(a(k,k))
   l = k
   do i = kp1,n
      t = abs(a(i,k))
      if (p >= t) go to 10
      p = t
      l = i
10    continue
   end do
   if (p == 0.0) go to 300
   p = a(l,k)
   if (mo == 0) index(k) = l
   if (k == l) go to 40
!                  Interchanging rows k and l
   do j = 1,n
      t = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = t
   end do
   if (m <= 0) go to 40
   kj = k
   lj = l
   do j = 1,m
      t = b(kj)
      b(kj) = b(lj)
      b(lj) = t
      kj = kj + kb
      lj = lj + kb
   end do
!                  Compute the k-TH row of U
40 if (k > 1) go to 50
   do j = kp1,n
      a(k,j) = a(k,j)/p
   end do
   go to 60
50 do j = kp1,n
      dsum = a(k,j)
      do l = 1,km1
         dsum = dsum - dble(a(k,l))*dble(a(l,j))
      end do
      a(k,j) = sngl(dsum)/p
   end do
!               Compute the (k+1)-ST column of l
60 do i = kp1,n
      dsum = a(i,kp1)
      do l = 1,k
         dsum = dsum - dble(a(i,l))*dble(a(l,kp1))
      end do
      a(i,kp1) = dsum
   end do
   km1 = k
end do
!                 Check the n-TH pivot element
if (a(n,n) == 0.0) go to 310
!                 Solving the equation LY = b
if (m <= 0) go to 120
maxb = kb*m
do onej = 1,maxb,kb
   kj = onej
   b(kj) = b(kj)/a(1,1)
   do k = 2,n
      kj = kj + 1
      dsum = b(kj)
      km1 = k - 1
      lj = onej
      do l = 1,km1
         dsum = dsum - dble(a(k,l))*dble(b(lj))
         lj = lj + 1
      end do
      b(kj) = sngl(dsum)/a(k,k)
   end do
end do
!                 Solving the equation UX = Y
do nj = n,maxb,kb
   kj = nj
   do nmk = 1,nm1
      k = n - nmk
      lj = kj
      kj = kj - 1
      dsum = b(kj)
      kp1 = k + 1
      do l = kp1,n
         dsum = dsum - dble(a(k,l))*dble(b(lj))
         lj = lj + 1
      end do
      b(kj) = dsum
   end do
end do
!               Replace l with the inverse of l
120 if (mo /= 0) return
do j = 1,nm1
   a(j,j) = 1.0/a(j,j)
   jp1 = j + 1
   do i = jp1,n
      dsum = 0.d0
      im1 = i - 1
      do l = j,im1
         dsum = dsum + dble(a(i,l))*dble(a(l,j))
      end do
      a(i,j) = -sngl(dsum)/a(i,i)
   end do
end do
a(n,n) = 1.0/a(n,n)
!           Solve UX = Y where Y is the inverse of l
do nmk = 1,nm1
   k = n - nmk
   kp1 = k + 1
   do j = kp1,n
      temp(j) = a(k,j)
      a(k,j) = 0.0
   end do
   do j = 1,n
      dsum = a(k,j)
      do l = kp1,n
         dsum = dsum - dble(temp(l))*dble(a(l,j))
      end do
      a(k,j) = dsum
   end do
end do
!                    Column interchanges
do nmj = 1,nm1
   j = n - nmj
   k = index(j)
   if (j == k) go to 161
   do i = 1,n
      t = a(i,j)
      a(i,j) = a(i,k)
      a(i,k) = t
   end do
161 continue
end do
return
!                      Case when n = 1
200 d = a(1,1)
if (d == 0.0) go to 310
if (mo == 0) a(1,1) = 1.0/d
if (m <= 0) return
maxb = kb*m
do kj = 1,maxb,kb
   b(kj) = b(kj)/d
end do
return
!                  k-TH pivot element is 0
300 ierr = k
return
310 ierr = n
return
!                        Input error
320 ierr = -1
end subroutine krout

pure subroutine dec(n, ndim, a, ip, ier)
implicit none
!-----------------------------------------------------------------------
! Matrix triangularization by Gaussian elimination.
! Input..
!    n = Order of matrix.
!    ndim = Declared dimension of array  a .
!    a = Matrix to be triangularized.
! Output..
!    a(i,j), i.LE.j = Upper triangular factor, U .
!    a(i,j), i.GT.j = Multipliers = Lower triangular factor, i - L.
!    ip(k), k.LT.n = Index of k-TH pivot row.
!    ip(n) = (-1)**(number of interchanges) or O .
!    ier = 0 If a nonsingular, or k if a found to be
!          singular at stage k.
! Use  sol  to obtain solution of linear system.
! determ(a) = ip(n)*a(1,1)*a(2,2)*...*a(n,n).
! If ip(n)=0, A is singular, sol will divide by zero.
! Interchanges finished in U , only partly in L .
! Reference..
! C. B. Moler, algorithm 423, linear equation solver,
! comm. Assoc. COMPUT. Mach., 15 (1972), P. 274.
!-----------------------------------------------------------------------
integer, intent(out) :: ier
integer, intent(inout) :: ip
integer, intent(in) :: n, ndim
real, intent(inout) :: a(ndim,n)
integer :: i, j, k, kp1, m, nm1
real :: t
dimension ip(n)
ier = 0
ip(n) = 1
if (n == 1) go to 70
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!  Find the pivot in column k.  search rows k to n. --------------------
   m = k
   do i = kp1,n
      if (abs(a(i,k)) > abs(a(m,k))) m = i
   end do
   ip(k) = m
!  Interchange elements in rows k and m. -------------------------------
   t = a(m,k)
   if (m == k) go to 20
   ip(n) = -ip(n)
   a(m,k) = a(k,k)
   a(k,k) = t
20 if (t == 0.0) go to 80
!  Store multipliers in a(i,k), i = k+1,...,n. -------------------------
   t = 1.0/t
   do i = kp1,n
      a(i,k) = -a(i,k)*t
   end do
!  Apply multipliers to other columns of A. ----------------------------
   do j = kp1,n
      t = a(m,j)
      a(m,j) = a(k,j)
      a(k,j) = t
      if (t == 0.0) go to 50
      do i = kp1,n
         a(i,j) = a(i,j) + a(i,k)*t
      end do
50    continue
   end do
end do
70 k = n
if (a(n,n) == 0.0) go to 80
return
80 ier = k
ip(n) = 0
end subroutine dec

subroutine sol(n, ndim, a, b, ip)
implicit none
!-----------------------------------------------------------------------
! Solution of linear system, a*X = b .
! Input..
!   n = Order of matrix.
!   ndim = Declared dimension of array  a .
!   a = Triangularized matrix obtained from DEC.
!   b = Right hand side vector.
!   ip = Pivot vector obtained from DEC.
! Do not use if DEC has set ier .NE. 0.
! Output..
!   b = Solution vector, X .
!-----------------------------------------------------------------------
integer :: ip
integer, intent(in) :: n, ndim
real :: a(ndim, n)
real, intent(inout) :: b(n)
integer :: i, k, kb, km1, kp1, m, nm1
real :: t
dimension ip(n)
if (n == 1) go to 50
nm1 = n - 1
!  Apply row permutations and multipliers to b. ------------------------
do k = 1,nm1
   kp1 = k + 1
   m = ip(k)
   t = b(m)
   b(m) = b(k)
   b(k) = t
   do i = kp1,n
      b(i) = b(i) + a(i,k)*t
   end do
end do
!  Back solve. ---------------------------------------------------------
do kb = 1,nm1
   km1 = n - kb
   k = km1 + 1
   b(k) = b(k)/a(k,k)
   t = -b(k)
   do i = 1,km1
      b(i) = b(i) + a(i,k)*t
   end do
end do
50 b(1) = b(1)/a(1,1)
end subroutine sol

pure subroutine npivot(n, m, a, ka, b, kb, d, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: d
real, intent(inout) :: a(ka,n), b(*)
integer :: j, jl, k, kl, l, maxb
real :: pivot, t
!-----------------------------------------------------------------------
!     Matrix inversion/equation solving without pivot search
!-----------------------------------------------------------------------
ierr = 0
maxb = kb*m
do k = 1,n
!     Examine the pivot element
   pivot = a(k,k)
   d = d*pivot
   if (pivot /= 0.0) go to 10
   ierr = 1
   return
!     Divide the pivot row by the pivot element
10 a(k,k) = 1.0
   do l = 1,n
      a(k,l) = a(k,l)/pivot
   end do
   if (m <= 0) go to 40
   do kl = k,maxb,kb
      b(kl) = b(kl)/pivot
   end do
!     Reduce the non-pivot rows
40 do j = 1,n
      if (j == k) go to 70
      t = a(j,k)
      a(j,k) = 0.0
      do l = 1,n
         a(j,l) = a(j,l) - a(k,l)*t
      end do
      if (m <= 0) go to 70
      kl = k
      do jl = j,maxb,kb
         b(jl) = b(jl) - b(kl)*t
         kl = kl + kb
      end do
70    continue
   end do
end do
end subroutine npivot

pure subroutine slv(n, m, a, ka, b, kb, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: a(ka,n), b(kb,m)
integer :: i, ip1, j, jp1, k, l, nm1
real :: p, sum, t
!     ------------------------------------------------------------------
!     Partial pivot solution of a*X = b where A is a matrix of
!     order n and b is a matrix having n rows and m columns.
!     The solution matrix X is stored in b.
!     ierr is a variable that reports the status of the results.
!        ierr = 0   The equations have been solved.
!        ierr = j   the j-TH pivot element was found to be 0.
!     ------------------------------------------------------------------
ierr = 0
nm1 = n - 1
if (nm1 == 0) go to 140
do j = 1,nm1
!     Search for the j-TH pivot element
   p = 0.0
   do i = j,n
      t = abs(a(i,j))
      if (t <= p) go to 10
      p = t
      l = i
10    continue
   end do
   if (p == 0.0) go to 210
   if (j == l) go to 40
!     Interchange rows j and l
   do k = j,n
      t = a(j,k)
      a(j,k) = a(l,k)
      a(l,k) = t
   end do
   do k = 1,m
      t = b(j,k)
      b(j,k) = b(l,k)
      b(l,k) = t
   end do
!     Eliminate the coefficients of X(j) in rows i = j+1,...,n
40 p = a(j,j)
   jp1 = j + 1
   do i = jp1,n
      t = a(i,j)/p
      do k = jp1,n
         a(i,k) = a(i,k) - t*a(j,k)
      end do
      do k = 1,m
         b(i,k) = b(i,k) - t*b(j,k)
      end do
   end do
end do
if (a(n,n) == 0.0) go to 220
!     Backsolve the triangular set of equations
do j = 1,m
   b(n,j) = b(n,j)/a(n,n)
end do
do l = 1,nm1
   i = n - l
   ip1 = i + 1
   do j = 1,m
      sum = b(i,j)
      do k = ip1,n
         sum = sum - a(i,k)*b(k,j)
      end do
      b(i,j) = sum/a(i,i)
   end do
end do
return
!     Case when n = 1
140 if (a(1,1) == 0.0) go to 200
do j = 1,m
   b(1,j) = b(1,j)/a(1,1)
end do
return
!     Error return
200 ierr = 1
return
210 ierr = j
return
220 ierr = n
end subroutine slv

pure subroutine dpslv(n, m, a, ka, b, kb, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
double precision, intent(inout) :: a(ka,n), b(kb,m)
integer :: i, j, k, km1, kp1, l, nm1
double precision :: p, t
!     ------------------------------------------------------------------
!     Partial pivot solution of a*X = b where A is a matrix of
!     order n and b is a matrix having n rows and m columns.
!     The solution matrix X is stored in b.
!     ierr is a variable that reports the status of the results.
!        ierr = 0   The equations have been solved.
!        ierr = j   the j-TH pivot element was found to be 0.
!     ------------------------------------------------------------------
ierr = 0
nm1 = n - 1
if (nm1 == 0) go to 140
do k = 1,nm1
!     Search for the k-TH pivot element
   p = 0.d0
   do i = k,n
      t = abs(a(i,k))
      if (p >= t) go to 10
      p = t
      l = i
10    continue
   end do
   if (p == 0.d0) go to 210
   if (k == l) go to 40
!     Interchange rows k and l
   do j = k,n
      t = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = t
   end do
   do j = 1,m
      t = b(k,j)
      b(k,j) = b(l,j)
      b(l,j) = t
   end do
!     Eliminate the coefficients of X(k) in rows i = k+1,...,n
40 p = a(k,k)
   kp1 = k + 1
   do i = kp1,n
      t = a(i,k)/p
      do j = kp1,n
         a(i,j) = a(i,j) - t*a(k,j)
      end do
      do j = 1,m
         b(i,j) = b(i,j) - t*b(k,j)
      end do
   end do
end do
if (a(n,n) == 0.d0) go to 220
!     Backsolve the triangular set of equations
do j = 1,m
   k = n
   km1 = nm1
   do l = 2,n
      b(k,j) = b(k,j)/a(k,k)
      t = b(k,j)
      do i = 1,km1
         b(i,j) = b(i,j) - t*a(i,k)
      end do
      k = km1
      km1 = k - 1
   end do
   b(1,j) = b(1,j)/a(1,1)
end do
return
!     Case when n = 1
140 if (a(1,1) == 0.d0) go to 200
do j = 1,m
   b(1,j) = b(1,j)/a(1,1)
end do
return
!     Error return
200 ierr = 1
return
210 ierr = k
return
220 ierr = n
end subroutine dpslv

subroutine mslv(mo,n,m,a,ka,b,kb,det,rcond,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*)
real, intent(inout) :: det(2), rcond
real, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
integer :: j, job, onej
real :: t
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting real matrices
!     and solving real equations
!-----------------------------------------------------------------------
!          Matrix factorization and computation of rcond
ierr = 0
call sgeco(a, ka, n, ipvt, rcond, wk)
t = 1.0 + rcond
if (t == 1.0) go to 30
!                  Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call sgesl(a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!             Calculation of det and the inverse of A
20 job = 10
if (mo == 0) job = 11
call sgedi(a, ka, n, ipvt, det, wk, job)
return
!                  The problem cannot be solved
30 ierr = 1
end subroutine mslv

subroutine mslv1(mo,n,m,a,ka,b,kb,ierr,ipvt,wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
integer :: j, onej
real :: det(2)
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting real matrices
!     and solving real equations
!-----------------------------------------------------------------------
if (n < 1 .or. ka < n) go to 40
if (m <= 0) go to 10
if (kb < n) go to 40
!                      Matrix factorization
10 call sgefa(a, ka, n, ipvt, ierr)
if (ierr /= 0) return
!                  Solution of the equation AX=b
if (m <= 0) go to 30
onej = 1
do j = 1,m
   call sgesl(a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!                 Calculation of the inverse of A
30 if (mo == 0) call sgedi(a, ka, n, ipvt, det, wk, 1)
return
!                          Error return
40 ierr = -1
end subroutine mslv1

subroutine slvmp(mo, n, a, ka, b, x, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr, iwk
integer, intent(in) :: ka, mo, n
real :: a(ka,n), b(n)
real, intent(inout) :: wk(*), x(n)
integer :: i, ir
!     ******************************************************************
!     Solution of real linear equations with iterative improvement
!     ******************************************************************
dimension iwk(n)
!     -------------------
!     dimension wk(n*n + n)
!     -------------------
if (mo /= 0) go to 10
!             Compute the LU decomposition of A
call mcopy(n, n, a, ka, wk, n)
call sgefa(wk, n, n, iwk, ierr)
if (ierr == 0) go to 10
ierr = -ierr
return
!            Solve the system of equations AX = b
10 do i = 1,n
   x(i) = b(i)
end do
ir = n*n + 1
call sgesl(wk, n, n, iwk, x, 0)
call luimp(a, ka, n, wk(1), n, iwk, b, x, wk(ir), ierr)
end subroutine slvmp

subroutine luimp(a, ka, n, q, kq, ipvt, b, x, r, ind)
implicit none
integer, intent(out) :: ind
integer :: ipvt
integer, intent(in) :: ka, kq, n
real :: a(ka,n), b(n), q(kq,n)
real, intent(inout) :: r(n), x(n)
integer :: i, j
real :: eps, eps2, rat, ratio, rnrm, xnrm
double precision :: dsum
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!     Purpose
!       given an approximate solution x of a linear system AX = b
!       obtained using sgeco or sgefa. luimp attempts to compute
!       an improved solution correct to machine precision.
!     Parameters
!       A    AN ARRAY OF DIMENSION (ka,n) CONTAINING THE MATRIX
!            A of order n.
!       q    AN ARRAY OF DIMENSION (kq,n) CONTAINING THE LU
!            decomposition of a produced by sgeco or sgefa.
!       ipvt an array of dimension n containing the permutation
!            information given by sgeco or sgefa.
!       b    the right hand side of the equation AX = b.
!       x    on input x is the approximate solution of AX = b to
!            be improved. On output x is the solution obtained.
!       r    AN ARRAY FOR INTERNAL USE BY THE ROUTINE.
!       Ind  variable that reports the status of the results.
!            ind = 0 If improvement of x is successful with A
!            gain in accuracy of at least 50 per cent each
!            iteration. Otherwise ind = 1.
!     Method
!       luimp executes the iteration cycle
!            (1)  AR = b - AX
!            (2)  x = x + r
!       with an initial given x. the residual vector b - AX is
!       computed to high accuracy using double precision. sgesl
!       is then used to solve (1).
! ----------------------------------------------------------------------
dimension ipvt(n)
!     ********** eps is a machine dependent parameter. Assign eps
!                the value U where U is the smallest floating point
!                number such that 1.0 + U .GT. 1.0.
eps = spmpar(1)
ind = 0
xnrm = 0.0
do i = 1,n
   xnrm = xnrm + x(i)*x(i)
end do
if (xnrm == 0.0) return
eps2 = eps*eps
ratio = 1.0
!                  Compute the residual vector
20 do i = 1,n
   dsum = b(i)
   do j = 1,n
      dsum = dsum - dble(a(i,j))*dble(x(j))
   end do
   r(i) = dsum
end do
!                  Find the correction vector
call sgesl(q, kq, n, ipvt, r, 0)
rnrm = 0.0
do i = 1,n
   rnrm = rnrm + r(i)*r(i)
end do
if (rnrm <= eps2*xnrm) return
!                Form a new approximate solution
do i = 1,n
   x(i) = x(i) + r(i)
end do
xnrm = 0.0
do i = 1,n
   xnrm = xnrm + x(i)*x(i)
end do
if (xnrm == 0.0) return
rat = ratio
ratio = rnrm/xnrm
if (ratio <= 0.25*rat) go to 20
if (ratio > min(rat,4.0*eps2)) ind = 1
end subroutine luimp

pure subroutine sgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
real, intent(inout) :: a(lda,*), z(*)
real, intent(inout) :: rcond
real :: ek, t, wk, wkm, anorm, s, sm, ynorm
integer :: info, j, k, kb, kp1, l
interface
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
   pure subroutine sgefa(a,lda,n,ipvt,info)
      implicit none
      integer, intent(in) :: lda
      real, intent(inout) :: a(lda,*)
      integer, intent(in) :: n
      integer, intent(inout) :: ipvt(*)
      integer, intent(out) :: info
   end subroutine sgefa
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
end interface
!     sgeco factors a real matrix BY Gaussian elimination
!     and estimates the condition of the matrix.
!     If  rcond  is not needed, sgefa is slightly faster.
!     To solve  a*X = B , follow sgeco by sgesl.
!     To compute  inverse(a)*C , follow sgeco by sgesl.
!     To compute  determinant(a) , follow sgeco by sgedi.
!     To compute  inverse(a) , follow sgeco by sgedi.
!     On entry
!        A       real(lda, n)
!                the matrix to be factored.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        rcond   REAL
!                an estimate of the reciprocal condition of  A .
!                For the system  a*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!        z       real(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     LINPACK sgefa
!     BLAS saxpy,sdot,sscal,sasum
!     Fortran abs,AMAX1,sign
!     internal variables
!     compute 1-norm of A
anorm = 0.0e0
do j = 1, n
   anorm = max(anorm,sasum(n,a(1,j),1))
end do
!     Factor
call sgefa(a,lda,n,ipvt,info)
!     rcond = 1/(norm(a)*(estimate of norm(inverse(a)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  a*z = Y  AND  TRANS(a)*Y = E .
!     Trans(a)  is the transpose of A .  The components of  E  are
!     chosen to cause maximum local growth in the elements of W  where
!     trans(U)*W = E .  The vectors are frequently rescaled to avoid
!     overflow.
!     SOLVE TRANS(U)*W = E
ek = 1.0e0
do j = 1, n
   z(j) = 0.0e0
end do
do k = 1, n
   if (z(k) /= 0.0e0) ek = sign(ek,-z(k))
   if (abs(ek - z(k)) <= abs(a(k,k))) go to 30
   s = abs(a(k,k))/abs(ek - z(k))
   call sscal(n,s,z,1)
   ek = s*ek
30 continue
   wk = ek - z(k)
   wkm = -ek - z(k)
   s = abs(wk)
   sm = abs(wkm)
   if (a(k,k) == 0.0e0) go to 40
   wk = wk/a(k,k)
   wkm = wkm/a(k,k)
   go to 50
40 continue
   wk = 1.0e0
   wkm = 1.0e0
50 continue
   kp1 = k + 1
   if (kp1 > n) go to 90
   do j = kp1, n
      sm = sm + abs(z(j) + wkm*a(k,j))
      z(j) = z(j) + wk*a(k,j)
      s = s + abs(z(j))
   end do
   if (s >= sm) go to 80
   t = wkm - wk
   wk = wkm
   do j = kp1, n
      z(j) = z(j) + t*a(k,j)
   end do
80 continue
90 continue
   z(k) = wk
end do
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
!     SOLVE TRANS(l)*Y = W
do kb = 1, n
   k = n + 1 - kb
   if (k < n) z(k) = z(k) + sdot(n - k,a(k + 1,k),1,z(k + 1),1)
   if (abs(z(k)) <= 1.0e0) go to 110
   s = 1.0e0/abs(z(k))
   call sscal(n,s,z,1)
110 continue
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
end do
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = 1.0e0
!     SOLVE l*V = Y
do k = 1, n
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
   if (k < n) call saxpy(n - k,t,a(k + 1,k),1,z(k + 1),1)
   if (abs(z(k)) <= 1.0e0) go to 130
   s = 1.0e0/abs(z(k))
   call sscal(n,s,z,1)
   ynorm = s*ynorm
130 continue
end do
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
!     SOLVE  U*z = V
do kb = 1, n
   k = n + 1 - kb
   if (abs(z(k)) <= abs(a(k,k))) go to 150
   s = abs(a(k,k))/abs(z(k))
   call sscal(n,s,z,1)
   ynorm = s*ynorm
150 continue
   if (a(k,k) /= 0.0e0) z(k) = z(k)/a(k,k)
   if (a(k,k) == 0.0e0) z(k) = 1.0e0
   t = -z(k)
   call saxpy(k - 1,t,a(1,k),1,z(1),1)
end do
!     MAKE ZNORM = 1.0
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
if (anorm /= 0.0e0) rcond = ynorm/anorm
if (anorm == 0.0e0) rcond = 0.0e0
end subroutine sgeco

pure subroutine sgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
real, intent(inout) :: a(lda,*)
real :: t
integer :: j, k, kp1, l, nm1
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
end interface
!     sgefa factors a real matrix BY Gaussian elimination.
!     sgefa is usually called by sgeco, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for sgeco) = (1 + 9/n)*(time for sgefa) .
!     On entry
!        A       real(lda, n)
!                the matrix to be factored.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!                     condition for this subroutine, but it does
!                     indicate that sgesl or sgedi will divide by zero
!                     if called.  Use  RCOND  in sgeco for a reliable
!                     indication of singularity.
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS saxpy,sscal,isamax
!     internal variables
!     Gaussian elimination with partial pivoting
info = 0
nm1 = n - 1
if (nm1 < 1) go to 70
do k = 1, nm1
   kp1 = k + 1
!        Find l = Pivot index
   l = isamax(n - k + 1,a(k,k),1) + k - 1
   ipvt(k) = l
!        Zero pivot implies this column already triangularized
   if (a(l,k) == 0.0e0) go to 40
!           Interchange if necessary
   if (l == k) go to 10
   t = a(l,k)
   a(l,k) = a(k,k)
   a(k,k) = t
10 continue
!           Compute multipliers
   t = -1.0e0/a(k,k)
   call sscal(n - k,t,a(k + 1,k),1)
!           Row elimination with column indexing
   do j = kp1, n
      t = a(l,j)
      if (l == k) go to 20
      a(l,j) = a(k,j)
      a(k,j) = t
20    continue
      call saxpy(n - k,t,a(k + 1,k),1,a(k + 1,j),1)
   end do
   go to 50
40 continue
   info = k
50 continue
end do
70 continue
ipvt(n) = n
if (a(n,n) == 0.0e0) info = n
end subroutine sgefa

pure subroutine sgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
real, intent(in) :: a(lda,*)
real, intent(inout) :: b(*)
real :: t
integer :: k, kb, l, nm1
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!     sgesl solves the real system
!     a * X = b  OR  TRANS(a) * X = b
!     using the factors computed by sgeco or sgefa.
!     On entry
!        A       real(lda, n)
!                the output from sgeco or sgefa.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!        ipvt    INTEGER(n)
!                the pivot vector from sgeco or sgefa.
!        b       real(n)
!                the right hand side vector.
!        JOB     INTEGER
!                = 0         To solve  a*X = b ,
!                = Nonzero   to solve  trans(a)*X = b  where
!                            trans(a)  is the transpose.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda .  It will not occur if the subroutines are
!        called correctly and if sgeco has set RCOND .GT. 0.0
!        or sgefa has set info .EQ. 0 .
!     to compute  inverse(a) * C  where  C  is a matrix
!     with  P  columns
!           call sgeco(a,lda,n,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call sgesl(a,lda,n,ipvt,c(1,j),0)
!        10 continue
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS saxpy,sdot
!     internal variables
nm1 = n - 1
if (job /= 0) go to 50
!        job = 0 , SOLVE  a * X = b
!        first solve  l*Y = b
if (nm1 < 1) go to 30
do k = 1, nm1
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 continue
   call saxpy(n - k,t,a(k + 1,k),1,b(k + 1),1)
end do
30 continue
!        Now solve  U*X = Y
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/a(k,k)
   t = -b(k)
   call saxpy(k - 1,t,a(1,k),1,b(1),1)
end do
go to 100
50 continue
!        job = NONZERO, SOLVE  TRANS(a) * X = b
!        first solve  trans(U)*Y = b
do k = 1, n
   t = sdot(k - 1,a(1,k),1,b(1),1)
   b(k) = (b(k) - t)/a(k,k)
end do
!        Now solve trans(l)*X = Y
if (nm1 < 1) go to 90
do kb = 1, nm1
   k = n - kb
   b(k) = b(k) + sdot(n - k,a(k + 1,k),1,b(k + 1),1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
90 continue
100 continue
end subroutine sgesl

subroutine sgedi(a,lda,n,ipvt,det,work,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
real, intent(inout) :: a(lda,*), det(2), work(*)
real :: t, ten
integer :: i, j, k, kb, kp1, l, nm1
!     sgedi computes the determinant and inverse of a matrix
!     using the factors computed by sgeco or sgefa.
!     On entry
!        A       real(lda, n)
!                the output from sgeco or sgefa.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!        ipvt    INTEGER(n)
!                the pivot vector from sgeco or sgefa.
!        WORK    real(n)
!                work vector.  Contents destroyed.
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!     On return
!        A       INVERSE OF ORIGINAL MATRIX IF REQUESTED.
!                Otherwise unchanged.
!        det     real(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. abs(det(1)) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if sgeco has set RCOND .GT. 0.0 or sgefa has set
!        INFO .EQ. 0 .
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS saxpy,sscal,sswap
!     Fortran abs,mod
!     internal variables
!     compute determinant
if (job/10 == 0) go to 70
det(1) = 1.0e0
det(2) = 0.0e0
ten = 10.0e0
do i = 1, n
   if (ipvt(i) /= i) det(1) = -det(1)
   det(1) = a(i,i)*det(1)
!        ...Exit
   if ( det( 1 ) == 0.0e0 ) exit
10 if (abs(det(1)) >= 1.0e0) go to 20
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0e0
   go to 10
20 continue
30 if (abs(det(1)) < ten) go to 40
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0e0
   go to 30
40 continue
end do
70 continue
!     Compute inverse(U)
if (mod(job,10) == 0) go to 150
do k = 1, n
   a(k,k) = 1.0e0/a(k,k)
   t = -a(k,k)
   call sscal(k - 1,t,a(1,k),1)
   kp1 = k + 1
   if (n < kp1) go to 90
   do j = kp1, n
      t = a(k,j)
      a(k,j) = 0.0e0
      call saxpy(k,t,a(1,k),1,a(1,j),1)
   end do
90 continue
end do
!        Form inverse(U)*inverse(l)
nm1 = n - 1
if (nm1 < 1) go to 140
do kb = 1, nm1
   k = n - kb
   kp1 = k + 1
   do i = kp1, n
      work(i) = a(i,k)
      a(i,k) = 0.0e0
   end do
   do j = kp1, n
      t = work(j)
      call saxpy(n,t,a(1,j),1,a(1,k),1)
   end do
   l = ipvt(k)
   if (l /= k) call sswap(n,a(1,k),1,a(1,l),1)
end do
140 continue
150 continue
end subroutine sgedi

subroutine dmslv(mo,n,m,a,ka,b,kb,det,rcond,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
double precision, intent(inout) :: a(ka,n), b(*)
double precision, intent(inout) :: det(2), rcond
double precision, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
integer :: j, job, onej
double precision :: t
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     real matrices and solving double precision real equations
!-----------------------------------------------------------------------
!          Matrix factorization and computation of rcond
ierr = 0
call dgeco(a, ka, n, ipvt, rcond, wk)
t = 1.d0 + rcond
if (t == 1.d0) go to 30
!                  Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call dgesl(a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!             Calculation of det and the inverse of A
20 job = 10
if (mo == 0) job = 11
call dgedi(a, ka, n, ipvt, det, wk, job)
return
!                  The problem cannot be solved
30 ierr = 1
end subroutine dmslv

subroutine dmslv1(mo,n,m,a,ka,b,kb,ierr,ipvt,wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
double precision, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
integer :: j, onej
double precision :: det(2)
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     real matrices and solving double precision real equations
!-----------------------------------------------------------------------
if (n < 1 .or. ka < n) go to 40
if (m <= 0) go to 10
if (kb < n) go to 40
!                      Matrix factorization
10 call dgefa(a, ka, n, ipvt, ierr)
if (ierr /= 0) return
!                  Solution of the equation AX=b
if (m <= 0) go to 30
onej = 1
do j = 1,m
   call dgesl(a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!                 Calculation of the inverse of A
30 if (mo == 0) call dgedi(a, ka, n, ipvt, det, wk, 1)
return
!                          Error return
40 ierr = -1
end subroutine dmslv1

pure subroutine dgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
double precision, intent(inout) :: a(lda,*), z(*)
double precision, intent(inout) :: rcond
double precision :: ek, t, wk, wkm, anorm, s, sm, ynorm
integer :: info, j, k, kb, kp1, l
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
   pure subroutine dgefa(a,lda,n,ipvt,info)
      implicit none
      integer, intent(in) :: lda
      double precision, intent(inout) :: a(lda,*)
      integer, intent(in) :: n
      integer, intent(inout) :: ipvt(*)
      integer, intent(out) :: info
   end subroutine dgefa
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
end interface
!     dgeco factors a double precision matrix BY Gaussian elimination
!     and estimates the condition of the matrix.
!     If  rcond  is not needed, dgefa is slightly faster.
!     To solve  a*X = B , follow dgeco by dgesl.
!     To compute  inverse(a)*C , follow dgeco by dgesl.
!     To compute  determinant(a) , follow dgeco by dgedi.
!     To compute  inverse(a) , follow dgeco by dgedi.
!     On entry
!        A       DOUBLE PRECISION(lda, n)
!                the matrix to be factored.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        rcond   DOUBLE PRECISION
!                an estimate of the reciprocal condition of  A .
!                For the system  a*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!        z       DOUBLE PRECISION(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     LINPACK dgefa
!     BLAS daxpy,ddot,dscal,dasum
!     Fortran dabs,DMAX1,DSIGN
!     internal variables
!     compute 1-norm of A
anorm = 0.0d0
do j = 1, n
   anorm = max(anorm,dasum(n,a(1,j),1))
end do
!     Factor
call dgefa(a,lda,n,ipvt,info)
!     rcond = 1/(norm(a)*(estimate of norm(inverse(a)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  a*z = Y  AND  TRANS(a)*Y = E .
!     Trans(a)  is the transpose of A .  The components of  E  are
!     chosen to cause maximum local growth in the elements of W  where
!     trans(U)*W = E .  The vectors are frequently rescaled to avoid
!     overflow.
!     SOLVE TRANS(U)*W = E
ek = 1.0d0
do j = 1, n
   z(j) = 0.0d0
end do
do k = 1, n
   if (z(k) /= 0.0d0) ek = sign(ek,-z(k))
   if (abs(ek - z(k)) <= abs(a(k,k))) go to 30
   s = abs(a(k,k))/abs(ek - z(k))
   call dscal(n,s,z,1)
   ek = s*ek
30 continue
   wk = ek - z(k)
   wkm = -ek - z(k)
   s = abs(wk)
   sm = abs(wkm)
   if (a(k,k) == 0.0d0) go to 40
   wk = wk/a(k,k)
   wkm = wkm/a(k,k)
   go to 50
40 continue
   wk = 1.0d0
   wkm = 1.0d0
50 continue
   kp1 = k + 1
   if (kp1 > n) go to 90
   do j = kp1, n
      sm = sm + abs(z(j) + wkm*a(k,j))
      z(j) = z(j) + wk*a(k,j)
      s = s + abs(z(j))
   end do
   if (s >= sm) go to 80
   t = wkm - wk
   wk = wkm
   do j = kp1, n
      z(j) = z(j) + t*a(k,j)
   end do
80 continue
90 continue
   z(k) = wk
end do
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
!     SOLVE TRANS(l)*Y = W
do kb = 1, n
   k = n + 1 - kb
   if (k < n) z(k) = z(k) + ddot(n - k,a(k + 1,k),1,z(k + 1),1)
   if (abs(z(k)) <= 1.0d0) go to 110
   s = 1.0d0/abs(z(k))
   call dscal(n,s,z,1)
110 continue
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
end do
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = 1.0d0
!     SOLVE l*V = Y
do k = 1, n
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
   if (k < n) call daxpy(n - k,t,a(k + 1,k),1,z(k + 1),1)
   if (abs(z(k)) <= 1.0d0) go to 130
   s = 1.0d0/abs(z(k))
   call dscal(n,s,z,1)
   ynorm = s*ynorm
130 continue
end do
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
!     SOLVE  U*z = V
do kb = 1, n
   k = n + 1 - kb
   if (abs(z(k)) <= abs(a(k,k))) go to 150
   s = abs(a(k,k))/abs(z(k))
   call dscal(n,s,z,1)
   ynorm = s*ynorm
150 continue
   if (a(k,k) /= 0.0d0) z(k) = z(k)/a(k,k)
   if (a(k,k) == 0.0d0) z(k) = 1.0d0
   t = -z(k)
   call daxpy(k - 1,t,a(1,k),1,z(1),1)
end do
!     MAKE ZNORM = 1.0
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
if (anorm /= 0.0d0) rcond = ynorm/anorm
if (anorm == 0.0d0) rcond = 0.0d0
end subroutine dgeco

pure subroutine dgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
double precision, intent(inout) :: a(lda,*)
double precision :: t
integer :: j, k, kp1, l, nm1
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
end interface
!     dgefa factors a double precision matrix BY Gaussian elimination.
!     dgefa is usually called by dgeco, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for dgeco) = (1 + 9/n)*(time for dgefa) .
!     On entry
!        A       DOUBLE PRECISION(lda, n)
!                the matrix to be factored.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!                     condition for this subroutine, but it does
!                     indicate that dgesl or dgedi will divide by zero
!                     if called.  Use  RCOND  in dgeco for a reliable
!                     indication of singularity.
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS daxpy,dscal,idamax
!     internal variables
!     Gaussian elimination with partial pivoting
info = 0
nm1 = n - 1
if (nm1 < 1) go to 70
do k = 1, nm1
   kp1 = k + 1
!        Find l = Pivot index
   l = idamax(n - k + 1,a(k,k),1) + k - 1
   ipvt(k) = l
!        Zero pivot implies this column already triangularized
   if (a(l,k) == 0.0d0) go to 40
!           Interchange if necessary
   if (l == k) go to 10
   t = a(l,k)
   a(l,k) = a(k,k)
   a(k,k) = t
10 continue
!           Compute multipliers
   t = -1.0d0/a(k,k)
   call dscal(n - k,t,a(k + 1,k),1)
!           Row elimination with column indexing
   do j = kp1, n
      t = a(l,j)
      if (l == k) go to 20
      a(l,j) = a(k,j)
      a(k,j) = t
20    continue
      call daxpy(n - k,t,a(k + 1,k),1,a(k + 1,j),1)
   end do
   go to 50
40 continue
   info = k
50 continue
end do
70 continue
ipvt(n) = n
if (a(n,n) == 0.0d0) info = n
end subroutine dgefa

pure subroutine dgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
double precision, intent(in) :: a(lda,*)
double precision, intent(inout) :: b(*)
double precision :: t
integer :: k, kb, l, nm1
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
end interface
!     dgesl solves the double precision system
!     a * X = b  OR  TRANS(a) * X = b
!     using the factors computed by dgeco or dgefa.
!     On entry
!        A       DOUBLE PRECISION(lda, n)
!                the output from dgeco or dgefa.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!        ipvt    INTEGER(n)
!                the pivot vector from dgeco or dgefa.
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!        JOB     INTEGER
!                = 0         To solve  a*X = b ,
!                = Nonzero   to solve  trans(a)*X = b  where
!                            trans(a)  is the transpose.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda .  It will not occur if the subroutines are
!        called correctly and if dgeco has set RCOND .GT. 0.0
!        or dgefa has set info .EQ. 0 .
!     to compute  inverse(a) * C  where  C  is a matrix
!     with  P  columns
!           call dgeco(a,lda,n,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call dgesl(a,lda,n,ipvt,c(1,j),0)
!        10 continue
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS daxpy,ddot
!     internal variables
nm1 = n - 1
if (job /= 0) go to 50
!        job = 0 , SOLVE  a * X = b
!        first solve  l*Y = b
if (nm1 < 1) go to 30
do k = 1, nm1
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 continue
   call daxpy(n - k,t,a(k + 1,k),1,b(k + 1),1)
end do
30 continue
!        Now solve  U*X = Y
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/a(k,k)
   t = -b(k)
   call daxpy(k - 1,t,a(1,k),1,b(1),1)
end do
go to 100
50 continue
!        job = NONZERO, SOLVE  TRANS(a) * X = b
!        first solve  trans(U)*Y = b
do k = 1, n
   t = ddot(k - 1,a(1,k),1,b(1),1)
   b(k) = (b(k) - t)/a(k,k)
end do
!        Now solve trans(l)*X = Y
if (nm1 < 1) go to 90
do kb = 1, nm1
   k = n - kb
   b(k) = b(k) + ddot(n - k,a(k + 1,k),1,b(k + 1),1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
90 continue
100 continue
end subroutine dgesl

subroutine dgedi(a,lda,n,ipvt,det,work,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
double precision, intent(inout) :: a(lda,*), det(2), work(*)
double precision :: t, ten
integer :: i, j, k, kb, kp1, l, nm1
!     dgedi computes the determinant and inverse of a matrix
!     using the factors computed by dgeco or dgefa.
!     On entry
!        A       DOUBLE PRECISION(lda, n)
!                the output from dgeco or dgefa.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!        ipvt    INTEGER(n)
!                the pivot vector from dgeco or dgefa.
!        WORK    DOUBLE PRECISION(n)
!                work vector.  Contents destroyed.
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!     On return
!        A       INVERSE OF ORIGINAL MATRIX IF REQUESTED.
!                Otherwise unchanged.
!        det     DOUBLE PRECISION(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. dabs(det(1)) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if dgeco has set RCOND .GT. 0.0 or dgefa has set
!        INFO .EQ. 0 .
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS daxpy,dscal,dswap
!     Fortran dabs,mod
!     internal variables
!     compute determinant
if (job/10 == 0) go to 70
det(1) = 1.0d0
det(2) = 0.0d0
ten = 10.0d0
do i = 1, n
   if (ipvt(i) /= i) det(1) = -det(1)
   det(1) = a(i,i)*det(1)
!        ...Exit
   if ( det( 1 ) == 0.0d0 ) exit
10 if (abs(det(1)) >= 1.0d0) go to 20
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0d0
   go to 10
20 continue
30 if (abs(det(1)) < ten) go to 40
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0d0
   go to 30
40 continue
end do
70 continue
!     Compute inverse(U)
if (mod(job,10) == 0) go to 150
do k = 1, n
   a(k,k) = 1.0d0/a(k,k)
   t = -a(k,k)
   call dscal(k - 1,t,a(1,k),1)
   kp1 = k + 1
   if (n < kp1) go to 90
   do j = kp1, n
      t = a(k,j)
      a(k,j) = 0.0d0
      call daxpy(k,t,a(1,k),1,a(1,j),1)
   end do
90 continue
end do
!        Form inverse(U)*inverse(l)
nm1 = n - 1
if (nm1 < 1) go to 140
do kb = 1, nm1
   k = n - kb
   kp1 = k + 1
   do i = kp1, n
      work(i) = a(i,k)
      a(i,k) = 0.0d0
   end do
   do j = kp1, n
      t = work(j)
      call daxpy(n,t,a(1,j),1,a(1,k),1)
   end do
   l = ipvt(k)
   if (l /= k) call dswap(n,a(1,k),1,a(1,l),1)
end do
140 continue
150 continue
end subroutine dgedi

subroutine arceco(n, array, mtrstr, nmblks, pivot, b, x, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: n, nmblks
real, intent(inout) :: array(*), b(*), x(*)
integer, intent(inout) :: mtrstr(3,*), pivot(*)
!***************************************************************
!  This program solves the linear system  A*x = b  where  A is
!  an almost block diagonal matrix.  The method implemented is
!  based on Gauss elimination with alternate row and column
!  elimination with partial pivoting, which produces a stable
!  decomposition of the matrix  A  without introducing fill-in.
!***************************************************************
!               *****  PARAMETERS  *****
!       *** on entry ...
!                n     - INTEGER
!                         the order of the linear system, where
!                           n = sum(mtrstr(1,k),k=1,nmblks)
!                array - real(NUMELS)
!                         where
!                          numels = sum(mtrstr(1,k)*mtrstr(2,k),
!                               k=1,nmblks).
!                         Contains the entries of the almost
!                         block diagonal matrix  A  whose block
!                         structure is given by the integer array
!                         mtrstr. The elements of A are stored by
!                         columns, in blocks corresponding to the
!                         given structure.
!               mtrstr - INTEGER(3,nmblks)
!                         describes the block structure of  A ...
!                           mtrstr(1,K)  = Number of rows in
!                                            block K.
!                           mtrstr(2,K)  = Number of columns in
!                                            block K.
!                           mtrstr(3,K)  = Number of columns
!                                          overlapped by block K
!                                          and block (K+1).
!                        mtrstr must satisfy some restrictions.
!                         In order that A be square, we need
!                         sum(mtrstr(1,K),K=1,nmblks) = n =
!                         sum((mtrstr(2,K)-mtrstr(3,K)),K=1,nmblks).
!                        In addition, to ensure that three success-
!                         ive blocks do not have columns in common,
!                         mtrstr must satisfy
!                         mtrstr(3,K-1)+mtrstr(3,K).LE.mtrstr(2,K),
!                         FOR K = 2,nmblks.
!                        Finally,  A R C E C O,  sets
!                         mtrstr(3,nmblks) = 0, IN ARCECD.
!               nmblks - INTEGER
!                         total number of blocks in  A
!                pivot - Integer(n)
!                         work space
!                    b - real(n)
!                         the right hand side vector
!                    x - real(n)
!                         work space
!       *** on return  ...
!                array - real(NUMELS)
!                         contains the modified alternate row
!                         and column decomposition of  A (if
!                         iflag = 0)
!                pivot - Integer(n)
!                         records the pivoting indices deter-
!                         mined in the decomposition
!                    x - real(n)
!                         the solution vector (if iflag = 0)
!                iflag - INTEGER
!                         =  1,if input parameters are invalid
!                         = -1, if matrix is singular
!                         =  0, OTHERWISE
!***************************************************************
!               *****  Auxiliary programs  *****
!            arcedc(array,mtrstr,nmblks,pivot,iflag)
!               - Decomposes the matrix  A  using modified
!                 alternate row and column elimination
!                 with partial pivoting, and is used for
!                 this purpose in  A R C E C O.
!                 The arguments are all as in A R C E C O.
!            arcesl(array,mtrstr,nmblks,pivot,b,x)
!               - Solves the system  A*x = b  once  A  is
!                 decomposed.
!                 The arguments are all as in A R C E C O .
!***************************************************************
!               *****  Block structure of  A  *****
!  the nmblks blocks of A are stored consecutively in the one
!  dimensional matrix  array, the entries of  A  being stored
!  as follows ...
!       IN array(1)     THE (1,1) ENTRY OF THE TOP BLOCK,
!       in array(INDEX) the (1,1) entry of the ith block where
!                       index = 1 + sum(mtrstr(1,j)*mtrstr(2,j),
!                               j=1,i-1), i=2,nmblks.
!***************************************************************
!       The subroutine  A R C E C O  automatically solves the
!  input system when iflag=0.  A R C E C O  is called only once
!  for a given system. The solution for a sequence of P right
!  hand sides can be obtained by one call to  A R C E C O  and
!  P-1 calls to arcesl only. Since the arrays array and
!  pivot contain, respectively, the decomposition of the given
!  coefficient matrix and pivoting information on return from
!  A R C E C O , they must not be altered between successive
!  calls to arcesl with the same right hand sides. For the
!  same reason, if the user wishes to save the coefficient
!  matrix, the array array must be copied before a call
!  TO  A R C E C O .
!**********************************************************************
call arcedc(n, array, mtrstr, nmblks, pivot, iflag)
if (iflag /= 0) return
call arcesl(array, mtrstr, nmblks, pivot, b, x)
end subroutine arceco

pure subroutine arcedc(n, array, mtrstr, nmblks, pivot, iflag)
implicit none
integer, intent(inout) :: iflag, mtrstr(3,*)
integer, intent(in) :: n, nmblks
real, intent(inout) :: array(*)
integer, intent(inout) :: pivot(*)
integer :: index1, index2, index3, indpiv, isum1, isum2, k, &
   & nclblk, nclpiv, novrlp, nrwbk2, nrwblk, nrwpiv
real :: pivmax
real, parameter :: zero = 0.0
interface
   pure subroutine arcepc(topblk,nrwtop,novrlp,botblk,nrwbot, &
      & nclpiv,pivot,pivmax,iflag)
      implicit none
      integer, intent(in) :: nrwbot
      integer, intent(in) :: novrlp
      integer, intent(in) :: nrwtop
      real, intent(inout) :: topblk(nrwtop,novrlp)
      real, intent(inout) :: botblk(nrwbot,novrlp)
      integer, intent(in) :: nclpiv
      integer, intent(inout) :: pivot(nrwtop)
      real, intent(inout) :: pivmax
      integer, intent(inout) :: iflag
   end subroutine arcepc
   pure subroutine arcepr(block,nrwblk,nclblk,nrwpiv,pivot, &
      & pivmax,iflag)
      implicit none
      integer, intent(in) :: nclblk
      integer, intent(in) :: nrwblk
      real, intent(inout) :: block(nrwblk,nclblk)
      integer, intent(in) :: nrwpiv
      integer, intent(inout) :: pivot(nrwblk)
      real, intent(inout) :: pivmax
      integer, intent(inout) :: iflag
   end subroutine arcepr
end interface
!***************************************************************
!  A R C E D C supervises the modified alternate row and column
!  decomposition with partial pivoting of the almost block
!  DIAGONAL MATRIX  A   STORED IN THE ARRAYS A R R A Y  AND
!  M T R S T R .
!***************************************************************
!               *****  PARAMETERS  *****
!       *** on entry ...
!                n     - INTEGER
!                         the order of the linear system, where
!                           n = sum(mtrstr(1,k),k=1,nmblks)
!                array - real(NUMELS)
!                         where
!                          numels = sum(mtrstr(1,k)*mtrstr(2,k),
!                               k=1,nmblks).
!                         Contains the entries of the almost
!                         block diagonal matrix  A  whose block
!                         structure is given by the integer array
!                         mtrstr. The elements of A are stored by
!                         columns, in blocks corresponding to the
!                         given structure.
!               mtrstr - INTEGER(3,nmblks)
!                         describes the block structure of  A ...
!                           mtrstr(1,k)  = Number of rows in
!                                            block k.
!                           mtrstr(2,k)  = Number of columns in
!                                            block k.
!                           mtrstr(3,k)  = Number of columns
!                                          overlapped by block k
!                                          and block (k+1).
!                        mtrstr must satisfy some restrictions.
!                         In order that A be square, we need
!                         sum(mtrstr(1,k),k=1,nmblks) = n =
!                         sum((mtrstr(2,k)-mtrstr(3,k)),k=1,nmblks).
!                        In addition, to ensure that three success-
!                         ive blocks do not have columns in common,
!                         mtrstr must satisfy
!                         mtrstr(3,k-1)+mtrstr(3,k).LE.mtrstr(2,k),
!                         FOR k = 2,nmblks.
!                        Finally,  A R C E C O,  sets
!                         mtrstr(3,nmblks) = 0, IN ARCECD.
!               nmblks - INTEGER
!                         total number of blocks
!                pivot - Integer(n)
!                         work space
!       *** on return  ...
!                array - real(NUMELS)
!                         contains the modified alternate row
!                         and column decomposition of  A (if
!                         iflag = 0)
!                pivot - Integer(n)
!                         records the pivoting indices deter-
!                         mined in the decomposition
!                iflag - INTEGER
!                         =  1, if input parameters are invalid
!                         = -1, if matrix is singular
!                         =  0, OTHERWISE
!***************************************************************
!               *****  Auxiliary programs  *****
!       arcepr(BLOCK,NRWBLK,NCLBLK,NRWPIV,pivot,pivmax,iflag)
!        carries out the row eliminations
!       arcepc(TOPBLK,NRWTOP,NOVRLP,BOTBLK,NRWBOT,NCLPIV,
!            PIVOT,pivmax,iflag)
!        carries out the column eliminations
!***************************************************************
!***************************************************************
!       ****  Check validity of the input parameters....
!            if parameters are invalid then terminate at 7,
!                                      ELSE CONTINUE AT 8.
!***************************************************************
mtrstr(3,nmblks) = 0
do k = 2,nmblks
   if (mtrstr(3,k - 1) + mtrstr(3,k) > mtrstr(2,k)) go to 30
end do
isum1 = 0
isum2 = 0
do k = 1,nmblks
   isum1 = isum1 + mtrstr(1,k)
   isum2 = isum2 + mtrstr(2,k) - mtrstr(3,k)
end do
if (isum1 /= isum2) go to 30
if (isum1 /= n) go to 30
!Ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          parameters are acceptable - Continue at 8
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
go to 40
30 continue
!Cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!        parameters are invalid.  Set iflag = 1, and terminate
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
iflag = 1
return
40 continue
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C  internal parameters ...
!       C
!       C       index1  POINTER TO THE ELEMENT IN THE COLUMN
!       C               WHERE ROW PIVOTING STARTS.
!       C
!       C       index2  POINTER TO THE ELEMENT IN THE COLUMN
!       C               WHERE COLUMN PIVOTING STARTS.
!       C
!       C       index3  POINTER TO 1ST ELEMENT IN 1ST COLUMN
!       C               OF NEXT BLOCK.
!       C
!       C       indpiv  POINTER TO 1ST ELEMENT OF BLOCK OF PIVOT
!       C
!       C       NRWBLK  NUMBER OF ROWS IN BLOCK.
!       C
!       C       NRWBK2  NUMBER OF ROWS IN NEXT BLOCK.
!       C
!       C       NRWPIV  NUMBER OF ROW ELIMINATIONS.
!       C
!       C       NCLBLK  NUMBER OF COLUMNS IN BLOCK TO BE
!       C               ROW PIVOTED.
!       C
!       C       NCLPIV  NUMBER OF COLUMN ELIMINATIONS.
!       C
!       C       NOVRLP  NUMBER OF COLUMNS OVERLAPPED BY THE
!       C               CURRENT BLOCK AND THE NEXT BLOCK.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
pivmax = zero
iflag = 0
index1 = 1
indpiv = 1
nrwblk = mtrstr(1,1)
nclblk = mtrstr(2,1)
novrlp = mtrstr(3,1)
nrwpiv = nclblk - novrlp
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       CALL arcepr TO PERFORM NRWPIV ROW ELIMINATIONS
!       C               ON TOP BLOCK.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
if (nrwpiv > 0) call arcepr(array(index1), nrwblk, nclblk, &
   & nrwpiv, pivot(indpiv), pivmax, iflag)
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       IF MATRIX SINGULAR RETURN.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
if (iflag < 0) return
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       NOW DO DECOMPOSITION PROCEEDING ONE BLOCK AT A
!       C               TIME.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
do k = 2,nmblks
   indpiv = indpiv + nrwpiv
   index2 = index1 + nrwblk*nrwpiv
   index3 = index2 + nrwblk*novrlp
   nclpiv = nrwblk - nrwpiv
   nrwbk2 = mtrstr(1,k)
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C  call arcepc to perform NCLPIV column eliminations.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nclpiv == 0) go to 50
   call arcepc(array(index2), nrwblk, novrlp, array(index3), &
      & nrwbk2, nclpiv, pivot(indpiv), pivmax, iflag)
!             Cccccccccccccccccccccccccccccccccccccccccccccccccc
!             C
!             C    IF MATRIX IS SINGULAR RETURN.
!             C
!             cccccccccccccccccccccccccccccccccccccccccccccccccc
   if (iflag < 0) return
50 continue
   nrwblk = nrwbk2
   index1 = index3 + nrwblk*nclpiv
   nclblk = mtrstr(2,k) - nclpiv
   novrlp = mtrstr(3,k)
   nrwpiv = nclblk - novrlp
   indpiv = indpiv + nclpiv
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcepr TO PERFORM NRWPIV ROW ELIMINATIONS.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nrwpiv == 0) go to 60
   call arcepr(array(index1), nrwblk, nclblk, nrwpiv, &
      & pivot(indpiv), pivmax, iflag)
!             Cccccccccccccccccccccccccccccccccccccccccccccccccc
!             C
!             C    IF MATRIX IS SINGULAR RETURN.
!             C
!             cccccccccccccccccccccccccccccccccccccccccccccccccc
   if (iflag < 0) return
60 continue
end do
end subroutine arcedc

pure subroutine arcepr(block, nrwblk, nclblk, nrwpiv, pivot, pivmax, &
   & iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nclblk, nrwblk, nrwpiv
integer, intent(inout) :: pivot(nrwblk)
real, intent(inout) :: block(nrwblk,nclblk)
real, intent(inout) :: pivmax
integer :: i1, j, j1, jplus1, l1, max
real :: rowmax, tempiv, rowpiv, swap
!***************************************************************
!  A R C E P R  performs  nrwpiv  row eliminations on the matrix
!               block
!***************************************************************
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C        PERFORM nrwpiv ROW ELIMINATIONS...
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
do j = 1,nrwpiv
   jplus1 = j + 1
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    DETERMINE ROW PIVOT AND PIVOT INDEX
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   max = j
   rowmax = abs(block(j,j))
   if (j == nrwblk) go to 30
   do i1 = jplus1,nrwblk
      tempiv = abs(block(i1,j))
      if (tempiv <= rowmax) go to 10
      rowmax = tempiv
      max = i1
10    continue
   end do
30 continue
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    TEST FOR SINGULARITY ...
!          C
!          C             IF SINGULAR THEN TERMINATE AT 90,
!          C                         ELSE CONTINUE.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (pivmax + rowmax == pivmax) go to 100
   pivmax = amax1(pivmax,rowmax)
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    IF NECESSARY INTERCHANGE ROWS
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   pivot(j) = max
   if (j == max) go to 50
   do j1 = j,nclblk
      swap = block(max,j1)
      block(max,j1) = block(j,j1)
      block(j,j1) = swap
   end do
50 continue
   if (j == nrwblk) return
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    COMPUTE THE MULTIPLIERS
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   rowpiv = block(j,j)
   do i1 = jplus1,nrwblk
      block(i1,j) = block(i1,j)/rowpiv
   end do
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    PERFORM ROW ELIMINATIONS WITH COLUMN INDEXING
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   do j1 = jplus1,nclblk
      do l1 = jplus1,nrwblk
         block(l1,j1) = block(l1,j1) - block(l1,j)*block(j,j1)
      end do
   end do
end do
return
100 continue
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       matrix is singular - Set iflag = -1.
!       C                            TERMINATE AT 90.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
iflag = -1
end subroutine arcepr

pure subroutine arcepc(topblk, nrwtop, novrlp, botblk, nrwbot, nclpiv, &
   & pivot, pivmax, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nclpiv, novrlp, nrwbot, nrwtop
real, intent(inout) :: topblk(nrwtop,novrlp), &
   & botblk(nrwbot,novrlp)
real, intent(inout) :: pivmax
integer, intent(inout) :: pivot(nrwtop)
integer :: i, i1, i2, iplus1, j, j1, jplus1, l1, max
real :: colmax, colmlt, tempiv, swap
!***************************************************************
!     A R C E P C performs nclpiv column eliminations on the
!                 matrices topblk and BOTBLK
!***************************************************************
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       PERFORM THE COLUMN ELIMINATIONS ON A LOOP.
!       C
!       ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
do j = 1,nclpiv
   i = nrwtop - nclpiv + j
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    DETERMINE COLUMN PIVOT AND PIVOT INDEX
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   max = j
   colmax = abs(topblk(i,j))
   if (j == novrlp) go to 30
   jplus1 = j + 1
   do j1 = jplus1,novrlp
      tempiv = abs(topblk(i,j1))
      if (tempiv <= colmax) go to 10
      colmax = tempiv
      max = j1
10    continue
   end do
30 continue
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    TEST FOR SINGULARITY ...
!          C
!          C             IF SINGULAR THEN TERMINATE AT 110,
!          C                         ELSE CONTINUE.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (pivmax + colmax == pivmax) go to 120
   pivmax = amax1(pivmax,colmax)
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    IF NECESSARY INTERCHANGE COLUMNS
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   pivot(j) = max
   if (j == max) go to 60
   do i1 = i,nrwtop
      swap = topblk(i1,j)
      topblk(i1,j) = topblk(i1,max)
      topblk(i1,max) = swap
   end do
   do i2 = 1,nrwbot
      swap = botblk(i2,j)
      botblk(i2,j) = botblk(i2,max)
      botblk(i2,max) = swap
   end do
60 continue
   if (j == novrlp) return
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    COMPUTE MULTIPLIERS AND PERFORM COLUMN
!          C            ELIMINATION
!          C
!          cccccccccccccccccccccccccccccccccccccccccccccccccccccc
   do j1 = jplus1,novrlp
      colmlt = topblk(i,j1)/topblk(i,j)
      topblk(i,j1) = colmlt
      if (i == nrwtop) go to 80
      iplus1 = i + 1
      do l1 = iplus1,nrwtop
         topblk(l1,j1) = topblk(l1,j1) - colmlt*topblk(l1,j)
      end do
80    continue
      do l1 = 1,nrwbot
         botblk(l1,j1) = botblk(l1,j1) - colmlt*botblk(l1,j)
      end do
   end do
end do
return
120 continue
!       Ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       matrix is singular - Set iflag = -1.
!       C                            TERMINATE AT 110.
!       C
!       ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
iflag = -1
end subroutine arcepc

subroutine arcesl(array, mtrstr, nmblks, pivot, b, x)
implicit none
integer :: mtrstr(3,*)
integer, intent(in) :: nmblks
real :: array(*)
real, intent(inout) :: b(*), x(*)
integer, intent(in) :: pivot(*)
integer :: indexa, indpiv, k, ll, nclblk, nclpiv, novrlp, nrwblk, &
   & nrwpiv
!***************************************************************
!  A R C E S L  supervises the solution of the linear system
!                          A*x = b
!  using the decomposition of the matrix  A  already generated
!  in  A R C E D C.  it involves two loops, the forward loop,
!  consisting of forward solution, forward modification, and
!  forward elimination, and the backward loop, consisting of
!  backward solution, backward modification, and backward
!  elimination.
!***************************************************************
!               *****  PARAMETERS  *****
!       *** on entry ...
!                array - real(NUMELS)
!                         where
!                          numels = sum(mtrstr(1,k)*mtrstr(2,k),
!                               k=1,nmblks).
!                         Output from A R C E D C
!               mtrstr - INTEGER(3,nmblks)
!                         describes the block structure of  A ...
!                           mtrstr(1,k)  = Number of rows in
!                                            block k.
!                           mtrstr(2,k)  = Number of columns in
!                                            block k.
!                           mtrstr(3,k)  = Number of columns
!                                          overlapped by block k
!                                          and block (k+1).
!                        The linear system is of order
!                           n  = sum(mtrstr(1,k),k=1,nmblks)
!               nmblks - INTEGER
!                         total number of blocks in  A
!                pivot - Integer(N)
!                         output from A R C E D C
!                    b - real(N)
!                         the right hand side vector
!                    x - real(N)
!                         work space
!       *** on return  ...
!                    x - real(N)
!                         the solution vector
!***************************************************************
!               *****  Auxiliary programs  *****
!       arcefs - Performs forward solution step
!       arcefm - Performs forward modification step
!       arcefe - Performs forward elimination step
!       arcebs - Performs backward solution step
!       arcebm - Performs backward modification step
!       arcebe - Performs backward elimination step
!***************************************************************
indpiv = 1
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C  internal parameters ...
!       C
!       C       indexa  POINTER TO 1ST ELEMENT OF BLOCK OF A.
!       C
!       C       INDEXB  POINTER TO 1ST ELEMENT OF BLOCK OF b.
!       C
!       C       indpiv,nrwblk,NRWPIV,nclblk,nclpiv,novrlp
!       C       ARE AS IN arcedc.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
indexa = 1
nrwblk = mtrstr(1,1)
nclblk = mtrstr(2,1)
novrlp = mtrstr(3,1)
nrwpiv = nclblk - novrlp
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       CALL arcefe TO PERFORM FORWARD ELIMINATION.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
if (nrwpiv > 0) call arcefe(array(indexa), nrwblk, nrwpiv, &
   & pivot(indpiv), b(indpiv))
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       FORWARD LOOP
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
do k = 2,nmblks
   indexa = indexa + nrwblk*nrwpiv
   nclpiv = nrwblk - nrwpiv
   indpiv = indpiv + nrwpiv
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcefs TO PERFORM FORWARD SOLUTION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nclpiv > 0) call arcefs(array(indexa), nrwblk, nclpiv, &
      & novrlp, b(indpiv), x(indpiv))
   indexa = indexa + novrlp*nrwblk
   nrwblk = mtrstr(1,k)
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcefm TO PERFORM FORWARD MODIFICATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nclpiv > 0) call arcefm(array(indexa), nrwblk, nclpiv, &
      & b(indpiv), x(indpiv))
   indexa = indexa + nrwblk*nclpiv
   nclblk = mtrstr(2,k) - nclpiv
   novrlp = mtrstr(3,k)
   nrwpiv = nclblk - novrlp
   indpiv = indpiv + nclpiv
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcefe TO PERFORM FORWARD ELIMINATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nrwpiv > 0) call arcefe(array(indexa), nrwblk, nrwpiv, &
      & pivot(indpiv), b(indpiv))
end do
!     indexb = indpiv + nrwpiv - 1
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       BACKWARD LOOP
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
do ll = 2,nmblks
   k = nmblks - ll + 1
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebm TO PERFORM BACKWARD MODIFICATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nrwpiv == 0) go to 20
   if (nrwpiv /= nclblk) call arcebm(array(indexa), nrwblk, &
      & nclblk, nrwpiv, b(indpiv), x(indpiv))
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebs TO PERFORM BACKWARD SOLUTION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   call arcebs(array(indexa), nrwblk, nclblk, nrwpiv, b(indpiv), &
      & x(indpiv))
20 continue
   indexa = indexa - nrwblk*nclpiv
   nrwblk = mtrstr(1,k)
   novrlp = mtrstr(3,k)
   indexa = indexa - nrwblk*novrlp
   indpiv = indpiv - nclpiv
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebe TO PERFORM BACKWARD ELIMINATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
   if (nclpiv > 0) call arcebe(array(indexa), nrwblk, nclpiv, &
      & novrlp, pivot(indpiv), x(indpiv))
   nrwpiv = nrwblk - nclpiv
   nclblk = novrlp + nrwpiv
   indexa = indexa - nrwblk*nrwpiv
   indpiv = indpiv - nrwpiv
   nclpiv = mtrstr(2,k) - nclblk
end do
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       IF ROW ELIMINATIONS WERE DONE IN TOPBLOCK, CALL
!       C       arcebs TO PERFORM BACKWARD SOLUTION
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
if (nrwpiv == 0) return
if (nrwpiv /= nclblk) call arcebm(array(indexa), nrwblk, nclblk, &
   & nrwpiv, b(indpiv), x(indpiv))
call arcebs(array(indexa), nrwblk, nclblk, nrwpiv, b(indpiv), &
   & x(indpiv))
end subroutine arcesl

subroutine arcefs(block, nrwblk, nclpiv, novrlp, b, x)
implicit none
integer, intent(in) :: nclpiv, novrlp, nrwblk
real :: block(nrwblk,novrlp)
real, intent(inout) :: b(*), x(*)
integer :: i, iplusl, j, jplusl, l, long
real :: xj
!***************************************************************
!  A R C E F S performs the forward solution step in the
!  solution phase of  A R C E C O.
!***************************************************************
do j = 1,nclpiv
   i = nrwblk - nclpiv + j
   x(j) = b(j)/block(i,j)
   if (i == nrwblk) return
   long = nrwblk - i
   xj = x(j)
   do l = 1,long
      iplusl = i + l
      jplusl = j + l
      b(jplusl) = b(jplusl) - block(iplusl,j)*xj
   end do
end do
end subroutine arcefs

subroutine arcefm(block, nrwblk, nclpiv, b, x)
implicit none
integer, intent(in) :: nclpiv, nrwblk
real :: block(nrwblk,nclpiv)
real, intent(inout) :: b(*)
real :: x(*)
integer :: j, l, nclpvl
real :: xj
!***************************************************************
!  A R C E F M  performs the forward modification step in the
!  solution phase of  A R C E C O.
!***************************************************************
do j = 1,nclpiv
   xj = x(j)
   do l = 1,nrwblk
      nclpvl = nclpiv + l
      b(nclpvl) = b(nclpvl) - block(l,j)*xj
   end do
end do
end subroutine arcefm

subroutine arcefe(block, nrwblk, nrwpiv, pivot, b)
implicit none
integer, intent(in) :: nrwblk, nrwpiv
real :: block(nrwblk,nrwpiv)
real, intent(inout) :: b(*)
integer, intent(in) :: pivot(nrwpiv)
integer :: i, iplus1, l, pivoti
real :: bi, swap
!***************************************************************
!  A R C E F E  performs the forward elimination step in the
!  solution phase of  A R C E C O.
!***************************************************************
do i = 1,nrwpiv
   pivoti = pivot(i)
   if (pivoti == i) go to 10
   swap = b(i)
   b(i) = b(pivoti)
   b(pivoti) = swap
10 continue
   if (i == nrwblk) return
   bi = b(i)
   iplus1 = i + 1
   do l = iplus1,nrwblk
      b(l) = b(l) - block(l,i)*bi
   end do
end do
end subroutine arcefe

subroutine arcebs(block, nrwblk, nclblk, nrwpiv, b, x)
implicit none
integer, intent(in) :: nclblk, nrwblk, nrwpiv
real :: block(nrwblk,nclblk)
real, intent(inout) :: b(*), x(*)
integer :: j, jmin1, l, nj
real :: xj
!***************************************************************
!  A R C E b S performs the backward solution step in the
!  solution phase of  A R C E C O.
!***************************************************************
do nj = 1,nrwpiv
   j = nrwpiv - nj + 1
   x(j) = b(j)/block(j,j)
   if (j == 1) return
   jmin1 = j - 1
   xj = x(j)
   do l = 1,jmin1
      b(l) = b(l) - block(l,j)*xj
   end do
end do
end subroutine arcebs

subroutine arcebm(block, nrwblk, nclblk, nrwpiv, b, x)
implicit none
integer, intent(in) :: nclblk, nrwblk, nrwpiv
real :: block(nrwblk,nclblk)
real, intent(inout) :: b(*)
real :: x(*)
integer :: j, l, nrwpv1
real :: xj
!***************************************************************
!  A R C E b M  performs the backward modification step in the
!  solution phase of  A R C E C O.
!***************************************************************
nrwpv1 = nrwpiv + 1
do j = nrwpv1,nclblk
   xj = x(j)
   do l = 1,nrwpiv
      b(l) = b(l) - block(l,j)*xj
   end do
end do
end subroutine arcebm

subroutine arcebe(block, nrwblk, nclpiv, novrlp, pivot, x)
implicit none
integer, intent(in) :: nclpiv, novrlp, nrwblk
real :: block(nrwblk,novrlp)
real, intent(inout) :: x(*)
integer, intent(in) :: pivot(nrwblk)
integer :: i, j, j1, jplus1, nj, pivotj
real :: dotprd, swap
!***************************************************************
!  A R C E B E performs the backward elimination step in the
!  solution phase of  A R C E C O.
!***************************************************************
do nj = 1,nclpiv
   j = nclpiv + 1 - nj
   i = nrwblk + 1 - nj
   dotprd = x(j)
   if (j == novrlp) go to 20
   jplus1 = j + 1
   do j1 = jplus1,novrlp
      dotprd = dotprd - x(j1)*block(i,j1)
   end do
20 continue
   x(j) = dotprd
   pivotj = pivot(j)
   if (pivotj == j) go to 30
   swap = x(pivotj)
   x(pivotj) = x(j)
   x(j) = swap
30 continue
end do
end subroutine arcebe

subroutine btslv(mo, m, n, a, b, c, x, ip, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo, m
integer :: n
integer, intent(inout) :: ip(m,n)
real, intent(inout) :: a(m,m,n), b(m,m,n), c(m,m,n), x(*)
!     Decompose the coefficient matrix
if (mo /= 0) go to 10
call decbt(m, n, a, b, c, ip, ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call solbt(m, n, a, b, c, x, ip)
end subroutine btslv

subroutine decbt(m, n, a, b, c, ip, ier)
implicit none
integer, intent(in) :: m
integer :: n
integer, intent(inout) :: ip(m,n), ier
real, intent(inout) :: a(m,m,n), b(m,m,n), c(m,m,n)
integer :: nm1, nm2, km1, i, j, k, l
real :: dp
!-----------------------------------------------------------------------
! Block-tridiagonal matrix decomposition routine.
! Written by A. C. Hindmarsh.
! Latest revision January 26, 1977  (AG)
! reference.. UCID-30150
!             solution of block-tridiagonal systems of linear
!             algebraic equations
!             A.C. Hindmarsh
!             February 1977
! the input matrix contains three blocks of elements in each block-row,
! including blocks in the (1,3) and (n,n-2) block positions.
! decbt uses block Gauss elimination and subroutines dec and sol
! for solution of blocks.  Partial pivoting is done within
! block-rows only.
! Input..
!     m = Order of each block.
!     n = Number of blocks in each direction of the matrix.
!         n must be 4 or more.  The complete matrix HAS order m*n.
!     a = m by m by n array containing diagonal blocks.
!         a(i,j,k) contains the (i,j) element of the k-TH block.
!     b = m by m by n array containing the super-diagonal blocks
!         (in b(*,*,k) for k = 1,...,n-1) and the block in the (n,n-2)
!         block position (in b(*,*,n)).
!     c = m by m by n array containing the subdiagonal blocks
!         (in c(*,*,k) for k = 2,3,...,n) and the block in the
!         (1,3) block position (in c(*,*,1)).
!    ip = Integer array of length m*n for working storage.
! Output..
! A,b,c = m by m by n arrays containing the block LU decomposition
!         of the input matrix.
!    ip = m by n array of pivot information.  ip(*,k) contains
!         information for the k-TH DIGONAL block.
!   ier = 0  If no trouble occurred, or
!       = -1 If the input value of m or n was illegal, or
!       = k  if a singular matrix was found in the k-TH diagonal block.
! Use solbt to solve the associated linear system.
! decbt calls subroutines  dec(m,M0,a,ip,ier)  and  sol(m,M0,a,Y,ip)
! for solution of m by m linear systems.
!-----------------------------------------------------------------------
if (m < 1 .or. n < 4) go to 210
nm1 = n - 1
nm2 = n - 2
! Process the first block-row. -----------------------------------------
call dec(m, m, a, ip, ier)
k = 1
if (ier /= 0) go to 200
do j = 1,m
   call sol(m, m, a, b(1,j,1), ip)
   call sol(m, m, a, c(1,j,1), ip)
end do
! Adjust b(*,*,2). -----------------------------------------------------
do j = 1,m
   do i = 1,m
      dp = 0.
      do l = 1,m
         dp = dp + c(i,l,2)*c(l,j,1)
      end do
      b(i,j,2) = b(i,j,2) - dp
   end do
end do
! Main loop.  Process block-rows 2 to n-1. -----------------------------
do k = 2,nm1
   km1 = k - 1
   do j = 1,m
      do i = 1,m
         dp = 0.
         do l = 1,m
            dp = dp + c(i,l,k)*b(l,j,km1)
         end do
         a(i,j,k) = a(i,j,k) - dp
      end do
   end do
   call dec(m, m, a(1,1,k), ip(1,k), ier)
   if (ier /= 0) go to 200
   do j = 1,m
      call sol(m, m, a(1,1,k), b(1,j,k), ip(1,k))
   end do
end do
! Process last block-row and return. -----------------------------------
do j = 1,m
   do i = 1,m
      dp = 0.
      do l = 1,m
         dp = dp + b(i,l,n)*b(l,j,nm2)
      end do
      c(i,j,n) = c(i,j,n) - dp
   end do
end do
do j = 1,m
   do i = 1,m
      dp = 0.
      do l = 1,m
         dp = dp + c(i,l,n)*b(l,j,nm1)
      end do
      a(i,j,n) = a(i,j,n) - dp
   end do
end do
call dec(m, m, a(1,1,n), ip(1,n), ier)
k = n
if (ier /= 0) go to 200
return
! Error returns. -------------------------------------------------------
200 ier = k
return
210 ier = -1
!-----------------------  End of subroutine decbt  ---------------------
end subroutine decbt

subroutine solbt(m, n, a, b, c, y, ip)
implicit none
integer, intent(in) :: m
integer :: n, ip(m,n)
real :: a(m,m,n)
real, intent(in) :: b(m,m,n), c(m,m,n)
real, intent(inout) :: y(m,n)
integer :: kb, kp1, nm1, nm2, km1, i, j, k
real :: dp
!-----------------------------------------------------------------------
! Solution of block-tridiagonal linear system.
! Coefficient matrix must have been previously processed by decbt.
! m, n, A, b, c, and ip  must not have been changed since call to decbt.
! Written by A. C. Hindmarsh.
! Input..
!     m = Order of each block.
!     n = Number of blocks in each direction of matrix.
! A,b,c = m by m by n arrays containing block LU decomposition
!         of coefficient matrix from decbt.
!    ip = m by n integer array of pivot information from decbt.
!     y = Array of length m*n containing the right-hand side vector
!         (treated as an m by n array here).
! Output..
!     y = Solution vector, of length m*n.
! solbt makes calls to subroutine sol(m,M0,a,y,ip)
! for solution of m by m linear systems.
!-----------------------------------------------------------------------
nm1 = n - 1
nm2 = n - 2
! Forward solution sweep. ----------------------------------------------
call sol(m, m, a, y, ip)
do k = 2,nm1
   km1 = k - 1
   do i = 1,m
      dp = 0.
      do j = 1,m
         dp = dp + c(i,j,k)*y(j,km1)
      end do
      y(i,k) = y(i,k) - dp
   end do
   call sol(m, m, a(1,1,k), y(1,k), ip(1,k))
end do
do i = 1,m
   dp = 0.
   do j = 1,m
      dp = dp + c(i,j,n)*y(j,nm1) + b(i,j,n)*y(j,nm2)
   end do
   y(i,n) = y(i,n) - dp
end do
call sol(m, m, a(1,1,n), y(1,n), ip(1,n))
! Backward solution sweep. ---------------------------------------------
do kb = 1,nm1
   k = n - kb
   kp1 = k + 1
   do i = 1,m
      dp = 0.
      do j = 1,m
         dp = dp + b(i,j,k)*y(j,kp1)
      end do
      y(i,k) = y(i,k) - dp
   end do
end do
do i = 1,m
   dp = 0.
   do j = 1,m
      dp = dp + c(i,j,1)*y(j,3)
   end do
   y(i,1) = y(i,1) - dp
end do
!-----------------------  End of subroutine solbt  ---------------------
end subroutine solbt

subroutine smslv(mo,n,m,a,b,kb,det,rcond,inert,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: kb, m, mo, n
real, intent(inout) :: a(*), b(*)
real, intent(inout) :: det(2), rcond
real, intent(inout) :: wk(n)
integer, intent(inout) :: inert(3), ipvt(n)
integer :: j, job, onej
real :: t
!     ------------------
!     ------------------
!          Matrix factorization and computation of rcond
ierr = 0
call sspco(a,n,ipvt,rcond,wk)
t = 1.0 + rcond
if (t == 1.0) go to 30
!                  Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call sspsl(a,n,ipvt,b(onej))
   onej = onej + kb
end do
!             Calculation of det and the inverse of A
20 job = 110
if (mo == 0) job = 111
call sspdi(a,n,ipvt,det,inert,wk,job)
return
!                  The problem cannot be solved
30 ierr = 1
end subroutine smslv

pure subroutine sspco(ap,n,kpvt,rcond,z)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
real, intent(inout) :: ap(*), z(*)
real, intent(inout) :: rcond
real :: ak, akm1, bk, bkm1, denom, ek, t, anorm, s, ynorm
integer :: i, ij, ik, ikm1, ikp1, info, j, jm1, j1, k, kk, km1k, km1km1, kp, kps, ks
interface
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
   pure subroutine sspfa(ap,n,kpvt,info)
      implicit none
      real, intent(inout) :: ap(*)
      integer, intent(in) :: n
      integer, intent(inout) :: kpvt(*)
      integer, intent(out) :: info
   end subroutine sspfa
end interface
!     sspco factors a real symmetric matrix stored in packed
!     form by elimination with symmetric pivoting and estimates
!     the condition of the matrix.
!     If  rcond  is not needed, sspfa is slightly faster.
!     To solve  A*X = B , follow sspco by sspsl.
!     To compute  inverse(A)*C , follow sspco by sspsl.
!     To compute  inverse(A) , follow sspco by sspdi.
!     To compute  determinant(A) , follow sspco by sspdi.
!     To compute  inertia(A), follow sspco by sspdi.
!     On entry
!        ap      real (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!        n       INTEGER
!                the order of the matrix  A .
!     Output
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!        rcond   REAL
!                an estimate of the reciprocal condition of  A .
!                For the system  A*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!        z       real(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!     Packed storage
!          the following program segment will pack the upper
!          triangle of a symmetric matrix.
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k) = a(i,j)
!             10    continue
!             20 continue
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     LINPACK sspfa
!     BLAS saxpy,sdot,sscal,sasum
!     Fortran abs,AMAX1,IABS,sign
!     internal variables
!     find norm of a using only upper half
j1 = 1
do j = 1, n
   z(j) = sasum(j,ap(j1),1)
   ij = j1
   j1 = j1 + j
   jm1 = j - 1
   if (jm1 < 1) go to 20
   do i = 1, jm1
      z(i) = z(i) + abs(ap(ij))
      ij = ij + 1
   end do
20 continue
end do
anorm = 0.0e0
do j = 1, n
   anorm = max(anorm,z(j))
end do
!     Factor
call sspfa(ap,n,kpvt,info)
!     rcond = 1/(norm(A)*(estimate of norm(inverse(A)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  A*z = Y  AND  A*Y = E .
!     The components of  E  are chosen to cause maximum local
!     growth in the elements of W  where  U*D*W = E .
!     The vectors are frequently rescaled to avoid overflow.
!     SOLVE U*D*W = E
ek = 1.0e0
do j = 1, n
   z(j) = 0.0e0
end do
k = n
ik = (n*(n - 1))/2
60 if (k == 0) go to 120
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) < 0) ks = 2
kp = abs(kpvt(k))
kps = k + 1 - ks
if (kp == kps) go to 70
t = z(kps)
z(kps) = z(kp)
z(kp) = t
70 continue
if (z(k) /= 0.0e0) ek = sign(ek,z(k))
z(k) = z(k) + ek
call saxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks == 1) go to 80
if (z(k - 1) /= 0.0e0) ek = sign(ek,z(k - 1))
z(k - 1) = z(k - 1) + ek
call saxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
80 continue
if (ks == 2) go to 100
if (abs(z(k)) <= abs(ap(kk))) go to 90
s = abs(ap(kk))/abs(z(k))
call sscal(n,s,z,1)
ek = s*ek
90 continue
if (ap(kk) /= 0.0e0) z(k) = z(k)/ap(kk)
if (ap(kk) == 0.0e0) z(k) = 1.0e0
go to 110
100 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0e0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
110 continue
k = k - ks
ik = ik - k
if (ks == 2) ik = ik - (k + 1)
go to 60
120 continue
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
!     SOLVE TRANS(U)*Y = W
k = 1
ik = 0
130 if (k > n) go to 160
ks = 1
if (kpvt(k) < 0) ks = 2
if (k == 1) go to 150
z(k) = z(k) + sdot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks == 2) &
   & z(k + 1) = z(k + 1) + sdot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = abs(kpvt(k))
if (kp == k) go to 140
t = z(k)
z(k) = z(kp)
z(kp) = t
140 continue
150 continue
ik = ik + k
if (ks == 2) ik = ik + (k + 1)
k = k + ks
go to 130
160 continue
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = 1.0e0
!     SOLVE U*D*V = Y
k = n
ik = n*(n - 1)/2
170 if (k == 0) go to 230
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) < 0) ks = 2
if (k == ks) go to 190
kp = abs(kpvt(k))
kps = k + 1 - ks
if (kp == kps) go to 180
t = z(kps)
z(kps) = z(kp)
z(kp) = t
180 continue
call saxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks == 2) call saxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
190 continue
if (ks == 2) go to 210
if (abs(z(k)) <= abs(ap(kk))) go to 200
s = abs(ap(kk))/abs(z(k))
call sscal(n,s,z,1)
ynorm = s*ynorm
200 continue
if (ap(kk) /= 0.0e0) z(k) = z(k)/ap(kk)
if (ap(kk) == 0.0e0) z(k) = 1.0e0
go to 220
210 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0e0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
220 continue
k = k - ks
ik = ik - k
if (ks == 2) ik = ik - (k + 1)
go to 170
230 continue
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
!     SOLVE TRANS(U)*z = V
k = 1
ik = 0
240 if (k > n) go to 270
ks = 1
if (kpvt(k) < 0) ks = 2
if (k == 1) go to 260
z(k) = z(k) + sdot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks == 2) &
   & z(k + 1) = z(k + 1) + sdot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = abs(kpvt(k))
if (kp == k) go to 250
t = z(k)
z(k) = z(kp)
z(kp) = t
250 continue
260 continue
ik = ik + k
if (ks == 2) ik = ik + (k + 1)
k = k + ks
go to 240
270 continue
!     MAKE ZNORM = 1.0
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
if (anorm /= 0.0e0) rcond = ynorm/anorm
if (anorm == 0.0e0) rcond = 0.0e0
end subroutine sspco

pure subroutine sspfa(ap,n,kpvt,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
integer, intent(out) :: info
real, intent(inout) :: ap(*)
real :: ak, akm1, bk, bkm1, denom, mulk, mulkm1, t, absakk, alpha, colmax, rowmax
integer :: ij, ijj, ik, ikm1, im, imax, imaxp1, imim, imj, imk, j, jj, jk, jkm1, jmax, jmim, k, kk, km1, km1k, km1km1, km2, kstep
logical :: swap
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure subroutine sswap(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine sswap
end interface
!     sspfa factors a real symmetric matrix stored in
!     packed form by elimination with symmetric pivoting.
!     To solve  A*X = B , follow sspfa by sspsl.
!     To compute  inverse(A)*C , follow sspfa by sspsl.
!     To compute  determinant(A) , follow sspfa by sspdi.
!     To compute  inertia(A) , follow sspfa by sspdi.
!     To compute  inverse(A) , follow sspfa by sspdi.
!     On entry
!        ap      real (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!        n       INTEGER
!                the order of the matrix  A .
!     Output
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if the k-TH pivot block is singular. This is
!                     not an error condition for this subroutine,
!                     but it does indicate that sspsl or sspdi may
!                     divide by zero if called.
!     Packed storage
!          the following program segment will pack the upper
!          triangle of a symmetric matrix.
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k)  = a(i,j)
!             10    continue
!             20 continue
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!     Subroutines and functions
!     BLAS saxpy,sswap,isamax
!     Fortran abs,AMAX1,sqrt
!     internal variables
!     initialize
!     alpha is used in choosing pivot block SIZE.
alpha = (1.0e0 + sqrt(17.0e0))/8.0e0
info = 0
!     Main loop on k, which goes from n to 1.
k = n
ik = (n*(n - 1))/2
10 continue
!        Leave the loop if k=0 Or k=1.
!     ...Exit
if (k == 0) go to 200
if (k > 1) go to 20
kpvt(1) = 1
if (ap(1) == 0.0e0) info = 1
!     ......Exit
go to 200
20 continue
!        This section of code determines the kind of
!        elimination to be performed.  When it is completed,
!        KSTEP will be set to the size of the pivot block, and
!        swap will be set to .TRUE. if an interchange is
!        required.
km1 = k - 1
kk = ik + k
absakk = abs(ap(kk))
!        Determine the largest off-diagonal element in
!        column k.
imax = isamax(k - 1,ap(ik + 1),1)
imk = ik + imax
colmax = abs(ap(imk))
if (absakk < alpha*colmax) go to 30
kstep = 1
swap = .false.
go to 90
30 continue
!           Determine the largest off-diagonal element in
!           row imax.
rowmax = 0.0e0
imaxp1 = imax + 1
im = imax*(imax - 1)/2
imj = im + 2*imax
do j = imaxp1, k
   rowmax = max(rowmax,abs(ap(imj)))
   imj = imj + j
end do
if (imax == 1) go to 50
jmax = isamax(imax - 1,ap(im + 1),1)
jmim = jmax + im
rowmax = max(rowmax,abs(ap(jmim)))
50 continue
imim = imax + im
if (abs(ap(imim)) < alpha*rowmax) go to 60
kstep = 1
swap = .true.
go to 80
60 continue
if (absakk < alpha*colmax*(colmax/rowmax)) go to 70
kstep = 1
swap = .false.
go to 80
70 continue
kstep = 2
swap = imax /= km1
80 continue
90 continue
if (max(absakk,colmax) /= 0.0e0) go to 100
!           Column k is zero.  Set info and iterate the loop.
kpvt(k) = k
info = k
go to 190
100 continue
if (kstep == 2) go to 140
!           1 X 1 pivot block.
if (.not.swap) go to 120
!              Perform an interchange.
call sswap(imax,ap(im + 1),1,ap(ik + 1),1)
imj = ik + imax
do jj = imax, k
   j = k + imax - jj
   jk = ik + j
   t = ap(jk)
   ap(jk) = ap(imj)
   ap(imj) = t
   imj = imj - (j - 1)
end do
120 continue
!           Perform the elimination.
ij = ik - (k - 1)
do jj = 1, km1
   j = k - jj
   jk = ik + j
   mulk = -ap(jk)/ap(kk)
   t = mulk
   call saxpy(j,t,ap(ik + 1),1,ap(ij + 1),1)
   ijj = ij + j
   ap(jk) = mulk
   ij = ij - (j - 1)
end do
!           Set the pivot array.
kpvt(k) = k
if (swap) kpvt(k) = imax
go to 190
140 continue
!           2 X 2 pivot block.
km1k = ik + k - 1
ikm1 = ik - (k - 1)
if (.not.swap) go to 160
!              Perform an interchange.
call sswap(imax,ap(im + 1),1,ap(ikm1 + 1),1)
imj = ikm1 + imax
do jj = imax, km1
   j = km1 + imax - jj
   jkm1 = ikm1 + j
   t = ap(jkm1)
   ap(jkm1) = ap(imj)
   ap(imj) = t
   imj = imj - (j - 1)
end do
t = ap(km1k)
ap(km1k) = ap(imk)
ap(imk) = t
160 continue
!           Perform the elimination.
km2 = k - 2
if (km2 == 0) go to 180
ak = ap(kk)/ap(km1k)
km1km1 = ikm1 + k - 1
akm1 = ap(km1km1)/ap(km1k)
denom = 1.0e0 - ak*akm1
ij = ik - (k - 1) - (k - 2)
do jj = 1, km2
   j = km1 - jj
   jk = ik + j
   bk = ap(jk)/ap(km1k)
   jkm1 = ikm1 + j
   bkm1 = ap(jkm1)/ap(km1k)
   mulk = (akm1*bk - bkm1)/denom
   mulkm1 = (ak*bkm1 - bk)/denom
   t = mulk
   call saxpy(j,t,ap(ik + 1),1,ap(ij + 1),1)
   t = mulkm1
   call saxpy(j,t,ap(ikm1 + 1),1,ap(ij + 1),1)
   ap(jk) = mulk
   ap(jkm1) = mulkm1
   ijj = ij + j
   ij = ij - (j - 1)
end do
180 continue
!           Set the pivot array.
kpvt(k) = 1 - k
if (swap) kpvt(k) = -imax
kpvt(k - 1) = kpvt(k)
190 continue
ik = ik - (k - 1)
if (kstep == 2) ik = ik - (k - 2)
k = k - kstep
go to 10
200 continue
end subroutine sspfa

pure subroutine sspsl(ap,n,kpvt,b)
implicit none
integer, intent(in) :: n, kpvt(*)
real, intent(in) :: ap(*)
real, intent(inout) :: b(*)
real :: ak, akm1, bk, bkm1, denom, temp
integer :: ik, ikm1, ikp1, k, kk, km1k, km1km1, kp
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!     SSISL solves the real symmetric system
!     A * X = b
!     using the factors computed by sspfa.
!     On entry
!        ap      real(n*(n+1)/2)
!                the output from sspfa.
!        n       INTEGER
!                the order of the matrix  A .
!        kpvt    INTEGER(n)
!                the pivot vector from sspfa.
!        b       real(n)
!                the right hand side vector.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero may occur if  sspco  has set RCOND .EQ. 0.0
!        or  sspfa  has set info .NE. 0  .
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call sspfa(ap,n,kpvt,info)
!           if (info .ne. 0) go to ...
!           do 10 j = 1, p
!              call sspsl(ap,n,kpvt,c(1,j))
!        10 continue
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!     Subroutines and functions
!     BLAS saxpy,sdot
!     Fortran IABS
!     internal variables.
!     Loop backward applying the transformations and
!     D inverse to b.
k = n
ik = (n*(n - 1))/2
10 if (k == 0) go to 80
kk = ik + k
if (kpvt(k) < 0) go to 40
!           1 X 1 pivot block.
if (k == 1) go to 30
kp = kpvt(k)
if (kp == k) go to 20
!                 Interchange.
temp = b(k)
b(k) = b(kp)
b(kp) = temp
20 continue
!              Apply the transformation.
call saxpy(k - 1,b(k),ap(ik + 1),1,b(1),1)
30 continue
!           Apply D inverse.
b(k) = b(k)/ap(kk)
k = k - 1
ik = ik - k
go to 70
40 continue
!           2 X 2 pivot block.
ikm1 = ik - (k - 1)
if (k == 2) go to 60
kp = abs(kpvt(k))
if (kp == k - 1) go to 50
!                 Interchange.
temp = b(k - 1)
b(k - 1) = b(kp)
b(kp) = temp
50 continue
!              Apply the transformation.
call saxpy(k - 2,b(k),ap(ik + 1),1,b(1),1)
call saxpy(k - 2,b(k - 1),ap(ikm1 + 1),1,b(1),1)
60 continue
!           Apply D inverse.
km1k = ik + k - 1
kk = ik + k
ak = ap(kk)/ap(km1k)
km1km1 = ikm1 + k - 1
akm1 = ap(km1km1)/ap(km1k)
bk = b(k)/ap(km1k)
bkm1 = b(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0e0
b(k) = (akm1*bk - bkm1)/denom
b(k - 1) = (ak*bkm1 - bk)/denom
k = k - 2
ik = ik - (k + 1) - k
70 continue
go to 10
80 continue
!     Loop forward applying the transformations.
k = 1
ik = 0
90 if (k > n) go to 160
if (kpvt(k) < 0) go to 120
!           1 X 1 pivot block.
if (k == 1) go to 110
!              Apply the transformation.
b(k) = b(k) + sdot(k - 1,ap(ik + 1),1,b(1),1)
kp = kpvt(k)
if (kp == k) go to 100
!                 Interchange.
temp = b(k)
b(k) = b(kp)
b(kp) = temp
100 continue
110 continue
ik = ik + k
k = k + 1
go to 150
120 continue
!           2 X 2 pivot block.
if (k == 1) go to 140
!              Apply the transformation.
b(k) = b(k) + sdot(k - 1,ap(ik + 1),1,b(1),1)
ikp1 = ik + k
b(k + 1) = b(k + 1) + sdot(k - 1,ap(ikp1 + 1),1,b(1),1)
kp = abs(kpvt(k))
if (kp == k) go to 130
!                 Interchange.
temp = b(k)
b(k) = b(kp)
b(kp) = temp
130 continue
140 continue
ik = ik + k + k + 1
k = k + 2
150 continue
go to 90
160 continue
end subroutine sspsl

subroutine sspdi(ap,n,kpvt,det,inert,work,job)
implicit none
integer, intent(in) :: n, job
real, intent(inout) :: ap(*), work(*)
real, intent(inout) :: det(2)
integer, intent(in) :: kpvt(*)
integer, intent(inout) :: inert(3)
real :: akkp1, sdot, temp
real :: ten, d, t, ak, akp1
integer :: ij, ik, ikp1, iks, j, jb, jk, jkp1, k, kk, kkp1, km1, ks, ksj, kskp1, kstep
logical :: noinv, nodet, noert
!     sspdi computes the determinant, inertia and inverse
!     of a real symmetric matrix using the factors from sspfa,
!     where the matrix is stored in packed form.
!     On entry
!        ap      real (n*(n+1)/2)
!                the output from sspfa.
!        n       INTEGER
!                the order of the matrix A.
!        kpvt    INTEGER(n)
!                the pivot vector from sspfa.
!        WORK    real(n)
!                work vector.  Contents ignored.
!        JOB     INTEGER
!                job has the decimal expansion  abc  where
!                   if  C .NE. 0, the inverse is computed,
!                   if  B .NE. 0, the determinant is computed,
!                   if  A .NE. 0, the inertia is computed.
!                For example, job = 111  Gives all three.
!     On return
!        variables not requested by job are not used.
!        ap     CONTAINS THE UPPER TRIANGLE OF THE INVERSE OF
!               the original matrix, stored in packed form.
!               The columns of the upper triangle are stored
!               sequentially in a one-dimensional array.
!        det    real(2)
!               determinant of original matrix.
!               determinant = det(1) * 10.0**det(2)
!               WITH 1.0 .LE. abs(det(1)) .LT. 10.0
!               OR det(1) = 0.0.
!        Inert  integer(3)
!               the inertia of the original matrix.
!               inert(1)  =  Number of positive eigenvalues.
!               inert(2)  =  Number of negative eigenvalues.
!               inert(3)  =  Number of zero eigenvalues.
!     Error condition
!        a division by zero will occur if the inverse is requested
!        and  sspco  has set RCOND .EQ. 0.0
!        or  sspfa  has set  info .NE. 0 .
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!     Subroutines and functions
!     BLAS saxpy,scopy,sdot,sswap
!     Fortran abs,IABS,mod
!     internal variables.
noinv = mod(job,10) == 0
nodet = mod(job,100)/10 == 0
noert = mod(job,1000)/100 == 0
if (nodet .and. noert) go to 140
if (noert) go to 10
inert(1) = 0
inert(2) = 0
inert(3) = 0
10 continue
if (nodet) go to 20
det(1) = 1.0e0
det(2) = 0.0e0
ten = 10.0e0
20 continue
t = 0.0e0
ik = 0
do k = 1, n
   kk = ik + k
   d = ap(kk)
!           Check if 1 by 1
   if (kpvt(k) > 0) go to 50
!              2 By 2 block
!              USE det (d  S)  =  (d/t * C - t) * t  ,  t = abs(S)
!                      (S  C)
!              to avoid underflow/overflow troubles.
!              Take two passes through scaling.  Use  t  for flag.
   if (t /= 0.0e0) go to 30
   ikp1 = ik + k
   kkp1 = ikp1 + k
   t = abs(ap(kkp1))
   d = (d/t)*ap(kkp1 + 1) - t
   go to 40
30 continue
   d = t
   t = 0.0e0
40 continue
50 continue
   if (noert) go to 60
   if (d > 0.0e0) inert(1) = inert(1) + 1
   if (d < 0.0e0) inert(2) = inert(2) + 1
   if (d == 0.0e0) inert(3) = inert(3) + 1
60 continue
   if (nodet) go to 120
   det(1) = d*det(1)
   if (det(1) == 0.0e0) go to 110
70 if (abs(det(1)) >= 1.0e0) go to 80
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0e0
   go to 70
80 continue
90 if (abs(det(1)) < ten) go to 100
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0e0
   go to 90
100 continue
110 continue
120 continue
   ik = ik + k
end do
140 continue
!     Compute inverse(A)
if (noinv) go to 270
k = 1
ik = 0
150 if (k > n) go to 260
km1 = k - 1
kk = ik + k
ikp1 = ik + k
kkp1 = ikp1 + k
if (kpvt(k) < 0) go to 180
!              1 By 1
ap(kk) = 1.0e0/ap(kk)
if (km1 < 1) go to 170
call scopy(km1,ap(ik + 1),1,work,1)
ij = 0
do j = 1, km1
   jk = ik + j
   ap(jk) = sdot(j,ap(ij + 1),1,work,1)
   call saxpy(j - 1,work(j),ap(ij + 1),1,ap(ik + 1),1)
   ij = ij + j
end do
ap(kk) = ap(kk) + sdot(km1,work,1,ap(ik + 1),1)
170 continue
kstep = 1
go to 220
180 continue
!              2 By 2
t = abs(ap(kkp1))
ak = ap(kk)/t
akp1 = ap(kkp1 + 1)/t
akkp1 = ap(kkp1)/t
d = t*(ak*akp1 - 1.0e0)
ap(kk) = akp1/d
ap(kkp1 + 1) = ak/d
ap(kkp1) = -akkp1/d
if (km1 < 1) go to 210
call scopy(km1,ap(ikp1 + 1),1,work,1)
ij = 0
do j = 1, km1
   jkp1 = ikp1 + j
   ap(jkp1) = sdot(j,ap(ij + 1),1,work,1)
   call saxpy(j - 1,work(j),ap(ij + 1),1,ap(ikp1 + 1),1)
   ij = ij + j
end do
ap(kkp1 + 1) = ap(kkp1 + 1) &
   & + sdot(km1,work,1,ap(ikp1 + 1),1)
ap(kkp1) = ap(kkp1) &
   & + sdot(km1,ap(ik + 1),1,ap(ikp1 + 1),1)
call scopy(km1,ap(ik + 1),1,work,1)
ij = 0
do j = 1, km1
   jk = ik + j
   ap(jk) = sdot(j,ap(ij + 1),1,work,1)
   call saxpy(j - 1,work(j),ap(ij + 1),1,ap(ik + 1),1)
   ij = ij + j
end do
ap(kk) = ap(kk) + sdot(km1,work,1,ap(ik + 1),1)
210 continue
kstep = 2
220 continue
!           Swap
ks = abs(kpvt(k))
if (ks == k) go to 250
iks = (ks*(ks - 1))/2
call sswap(ks,ap(iks + 1),1,ap(ik + 1),1)
ksj = ik + ks
do jb = ks, k
   j = k + ks - jb
   jk = ik + j
   temp = ap(jk)
   ap(jk) = ap(ksj)
   ap(ksj) = temp
   ksj = ksj - (j - 1)
end do
if (kstep == 1) go to 240
kskp1 = ikp1 + ks
temp = ap(kskp1)
ap(kskp1) = ap(kkp1)
ap(kkp1) = temp
240 continue
250 continue
ik = ik + k
if (kstep == 2) ik = ik + k + 1
k = k + kstep
go to 150
260 continue
270 continue
end subroutine sspdi

subroutine dsmslv(mo,n,m,a,b,kb,det,rcond,inert,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: kb, m, mo, n
double precision, intent(inout) :: a(*), b(*)
double precision, intent(inout) :: det(2), rcond
double precision, intent(inout) :: wk(n)
integer, intent(inout) :: inert(3), ipvt(n)
integer :: j, job, onej
double precision :: t
!     ------------------
!     ------------------
!          Matrix factorization and computation of rcond
ierr = 0
call dspco(a,n,ipvt,rcond,wk)
t = 1.d0 + rcond
if (t == 1.d0) go to 30
!                  Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call dspsl(a,n,ipvt,b(onej))
   onej = onej + kb
end do
!             Calculation of det and the inverse of A
20 job = 110
if (mo == 0) job = 111
call dspdi(a,n,ipvt,det,inert,wk,job)
return
!                  The problem cannot be solved
30 ierr = 1
end subroutine dsmslv

pure subroutine dspco(ap,n,kpvt,rcond,z)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
double precision, intent(inout) :: ap(*), z(*)
double precision, intent(inout) :: rcond
double precision :: ak, akm1, bk, bkm1, denom, ek, t, anorm, s, ynorm
integer :: i, ij, ik, ikm1, ikp1, info, j, jm1, j1, k, kk, km1k, km1km1, kp, kps, ks
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure subroutine dspfa(ap,n,kpvt,info)
      implicit none
      double precision, intent(inout) :: ap(*)
      integer, intent(in) :: n
      integer, intent(inout) :: kpvt(*)
      integer, intent(out) :: info
   end subroutine dspfa
end interface
!     dspco factors a double precision symmetric matrix stored in
!     packed form by elimination with symmetric pivoting and estimates
!     the condition of the matrix.
!     If  rcond  is not needed, dspfa is slightly faster.
!     To solve  A*X = B , follow dspco by dspsl.
!     To compute  inverse(A)*C , follow dspco by dspsl.
!     To compute  inverse(A) , follow dspco by dspdi.
!     To compute  determinant(A) , follow dspco by dspdi.
!     To compute  inertia(A), follow dspco by dspdi.
!     On entry
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!        n       INTEGER
!                the order of the matrix  A .
!     Output
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!        rcond   DOUBLE PRECISION
!                an estimate of the reciprocal condition of  A .
!                For the system  A*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!        z       DOUBLE PRECISION(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!     Packed storage
!          the following program segment will pack the upper
!          triangle of a symmetric matrix.
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k) = a(i,j)
!             10    continue
!             20 continue
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     LINPACK dspfa
!     BLAS daxpy,ddot,dscal,dasum
!     Fortran dabs,DMAX1,IABS,DSIGN
!     internal variables
!     find norm of a using only upper half
j1 = 1
do j = 1, n
   z(j) = dasum(j,ap(j1),1)
   ij = j1
   j1 = j1 + j
   jm1 = j - 1
   if (jm1 < 1) go to 20
   do i = 1, jm1
      z(i) = z(i) + abs(ap(ij))
      ij = ij + 1
   end do
20 continue
end do
anorm = 0.0d0
do j = 1, n
   anorm = max(anorm,z(j))
end do
!     Factor
call dspfa(ap,n,kpvt,info)
!     rcond = 1/(norm(A)*(estimate of norm(inverse(A)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  A*z = Y  AND  A*Y = E .
!     The components of  E  are chosen to cause maximum local
!     growth in the elements of W  where  U*D*W = E .
!     The vectors are frequently rescaled to avoid overflow.
!     SOLVE U*D*W = E
ek = 1.0d0
do j = 1, n
   z(j) = 0.0d0
end do
k = n
ik = (n*(n - 1))/2
60 if (k == 0) go to 120
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) < 0) ks = 2
kp = abs(kpvt(k))
kps = k + 1 - ks
if (kp == kps) go to 70
t = z(kps)
z(kps) = z(kp)
z(kp) = t
70 continue
if (z(k) /= 0.0d0) ek = sign(ek,z(k))
z(k) = z(k) + ek
call daxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks == 1) go to 80
if (z(k - 1) /= 0.0d0) ek = sign(ek,z(k - 1))
z(k - 1) = z(k - 1) + ek
call daxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
80 continue
if (ks == 2) go to 100
if (abs(z(k)) <= abs(ap(kk))) go to 90
s = abs(ap(kk))/abs(z(k))
call dscal(n,s,z,1)
ek = s*ek
90 continue
if (ap(kk) /= 0.0d0) z(k) = z(k)/ap(kk)
if (ap(kk) == 0.0d0) z(k) = 1.0d0
go to 110
100 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0d0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
110 continue
k = k - ks
ik = ik - k
if (ks == 2) ik = ik - (k + 1)
go to 60
120 continue
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
!     SOLVE TRANS(U)*Y = W
k = 1
ik = 0
130 if (k > n) go to 160
ks = 1
if (kpvt(k) < 0) ks = 2
if (k == 1) go to 150
z(k) = z(k) + ddot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks == 2) &
   & z(k + 1) = z(k + 1) + ddot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = abs(kpvt(k))
if (kp == k) go to 140
t = z(k)
z(k) = z(kp)
z(kp) = t
140 continue
150 continue
ik = ik + k
if (ks == 2) ik = ik + (k + 1)
k = k + ks
go to 130
160 continue
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = 1.0d0
!     SOLVE U*D*V = Y
k = n
ik = n*(n - 1)/2
170 if (k == 0) go to 230
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) < 0) ks = 2
if (k == ks) go to 190
kp = abs(kpvt(k))
kps = k + 1 - ks
if (kp == kps) go to 180
t = z(kps)
z(kps) = z(kp)
z(kp) = t
180 continue
call daxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks == 2) call daxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
190 continue
if (ks == 2) go to 210
if (abs(z(k)) <= abs(ap(kk))) go to 200
s = abs(ap(kk))/abs(z(k))
call dscal(n,s,z,1)
ynorm = s*ynorm
200 continue
if (ap(kk) /= 0.0d0) z(k) = z(k)/ap(kk)
if (ap(kk) == 0.0d0) z(k) = 1.0d0
go to 220
210 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0d0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
220 continue
k = k - ks
ik = ik - k
if (ks == 2) ik = ik - (k + 1)
go to 170
230 continue
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
!     SOLVE TRANS(U)*z = V
k = 1
ik = 0
240 if (k > n) go to 270
ks = 1
if (kpvt(k) < 0) ks = 2
if (k == 1) go to 260
z(k) = z(k) + ddot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks == 2) &
   & z(k + 1) = z(k + 1) + ddot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = abs(kpvt(k))
if (kp == k) go to 250
t = z(k)
z(k) = z(kp)
z(kp) = t
250 continue
260 continue
ik = ik + k
if (ks == 2) ik = ik + (k + 1)
k = k + ks
go to 240
270 continue
!     MAKE ZNORM = 1.0
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
if (anorm /= 0.0d0) rcond = ynorm/anorm
if (anorm == 0.0d0) rcond = 0.0d0
end subroutine dspco

pure subroutine dspfa(ap,n,kpvt,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
integer, intent(out) :: info
double precision, intent(inout) :: ap(*)
double precision :: ak, akm1, bk, bkm1, denom, mulk, mulkm1, t, absakk, alpha, colmax, rowmax
integer :: ij, ijj, ik, ikm1, im, imax, imaxp1, imim, imj, imk, j, jj, jk, jkm1, jmax, jmim, k, kk, km1, km1k, km1km1, km2, kstep
logical :: swap
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
end interface
!     dspfa factors a double precision symmetric matrix stored in
!     packed form by elimination with symmetric pivoting.
!     To solve  A*X = B , follow dspfa by dspsl.
!     To compute  inverse(A)*C , follow dspfa by dspsl.
!     To compute  determinant(A) , follow dspfa by dspdi.
!     To compute  inertia(A) , follow dspfa by dspdi.
!     To compute  inverse(A) , follow dspfa by dspdi.
!     On entry
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!        n       INTEGER
!                the order of the matrix  A .
!     Output
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if the k-TH pivot block is singular. This is
!                     not an error condition for this subroutine,
!                     but it does indicate that dspsl or dspdi may
!                     divide by zero if called.
!     Packed storage
!          the following program segment will pack the upper
!          triangle of a symmetric matrix.
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k)  = a(i,j)
!             10    continue
!             20 continue
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!     Subroutines and functions
!     BLAS daxpy,dswap,idamax
!     Fortran dabs,DMAX1,DSQRT
!     internal variables
!     initialize
!     alpha is used in choosing pivot block SIZE.
alpha = (1.0d0 + sqrt(17.0d0))/8.0d0
info = 0
!     Main loop on k, which goes from n to 1.
k = n
ik = (n*(n - 1))/2
10 continue
!        Leave the loop if k=0 Or k=1.
!     ...Exit
if (k == 0) go to 200
if (k > 1) go to 20
kpvt(1) = 1
if (ap(1) == 0.0d0) info = 1
!     ......Exit
go to 200
20 continue
!        This section of code determines the kind of
!        elimination to be performed.  When it is completed,
!        KSTEP will be set to the size of the pivot block, and
!        swap will be set to .TRUE. if an interchange is
!        required.
km1 = k - 1
kk = ik + k
absakk = abs(ap(kk))
!        Determine the largest off-diagonal element in
!        column k.
imax = idamax(k - 1,ap(ik + 1),1)
imk = ik + imax
colmax = abs(ap(imk))
if (absakk < alpha*colmax) go to 30
kstep = 1
swap = .false.
go to 90
30 continue
!           Determine the largest off-diagonal element in
!           row imax.
rowmax = 0.0d0
imaxp1 = imax + 1
im = imax*(imax - 1)/2
imj = im + 2*imax
do j = imaxp1, k
   rowmax = max(rowmax,abs(ap(imj)))
   imj = imj + j
end do
if (imax == 1) go to 50
jmax = idamax(imax - 1,ap(im + 1),1)
jmim = jmax + im
rowmax = max(rowmax,abs(ap(jmim)))
50 continue
imim = imax + im
if (abs(ap(imim)) < alpha*rowmax) go to 60
kstep = 1
swap = .true.
go to 80
60 continue
if (absakk < alpha*colmax*(colmax/rowmax)) go to 70
kstep = 1
swap = .false.
go to 80
70 continue
kstep = 2
swap = imax /= km1
80 continue
90 continue
if (max(absakk,colmax) /= 0.0d0) go to 100
!           Column k is zero.  Set info and iterate the loop.
kpvt(k) = k
info = k
go to 190
100 continue
if (kstep == 2) go to 140
!           1 X 1 pivot block.
if (.not.swap) go to 120
!              Perform an interchange.
call dswap(imax,ap(im + 1),1,ap(ik + 1),1)
imj = ik + imax
do jj = imax, k
   j = k + imax - jj
   jk = ik + j
   t = ap(jk)
   ap(jk) = ap(imj)
   ap(imj) = t
   imj = imj - (j - 1)
end do
120 continue
!           Perform the elimination.
ij = ik - (k - 1)
do jj = 1, km1
   j = k - jj
   jk = ik + j
   mulk = -ap(jk)/ap(kk)
   t = mulk
   call daxpy(j,t,ap(ik + 1),1,ap(ij + 1),1)
   ijj = ij + j
   ap(jk) = mulk
   ij = ij - (j - 1)
end do
!           Set the pivot array.
kpvt(k) = k
if (swap) kpvt(k) = imax
go to 190
140 continue
!           2 X 2 pivot block.
km1k = ik + k - 1
ikm1 = ik - (k - 1)
if (.not.swap) go to 160
!              Perform an interchange.
call dswap(imax,ap(im + 1),1,ap(ikm1 + 1),1)
imj = ikm1 + imax
do jj = imax, km1
   j = km1 + imax - jj
   jkm1 = ikm1 + j
   t = ap(jkm1)
   ap(jkm1) = ap(imj)
   ap(imj) = t
   imj = imj - (j - 1)
end do
t = ap(km1k)
ap(km1k) = ap(imk)
ap(imk) = t
160 continue
!           Perform the elimination.
km2 = k - 2
if (km2 == 0) go to 180
ak = ap(kk)/ap(km1k)
km1km1 = ikm1 + k - 1
akm1 = ap(km1km1)/ap(km1k)
denom = 1.0d0 - ak*akm1
ij = ik - (k - 1) - (k - 2)
do jj = 1, km2
   j = km1 - jj
   jk = ik + j
   bk = ap(jk)/ap(km1k)
   jkm1 = ikm1 + j
   bkm1 = ap(jkm1)/ap(km1k)
   mulk = (akm1*bk - bkm1)/denom
   mulkm1 = (ak*bkm1 - bk)/denom
   t = mulk
   call daxpy(j,t,ap(ik + 1),1,ap(ij + 1),1)
   t = mulkm1
   call daxpy(j,t,ap(ikm1 + 1),1,ap(ij + 1),1)
   ap(jk) = mulk
   ap(jkm1) = mulkm1
   ijj = ij + j
   ij = ij - (j - 1)
end do
180 continue
!           Set the pivot array.
kpvt(k) = 1 - k
if (swap) kpvt(k) = -imax
kpvt(k - 1) = kpvt(k)
190 continue
ik = ik - (k - 1)
if (kstep == 2) ik = ik - (k - 2)
k = k - kstep
go to 10
200 continue
end subroutine dspfa

pure subroutine dspsl(ap,n,kpvt,b)
implicit none
integer, intent(in) :: n, kpvt(*)
double precision, intent(in) :: ap(*)
double precision, intent(inout) :: b(*)
double precision :: ak, akm1, bk, bkm1, denom, temp
integer :: ik, ikm1, ikp1, k, kk, km1k, km1km1, kp
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
end interface
!     DSISL solves the double precision symmetric system
!     A * X = b
!     using the factors computed by dspfa.
!     On entry
!        ap      DOUBLE PRECISION(n*(n+1)/2)
!                the output from dspfa.
!        n       INTEGER
!                the order of the matrix  A .
!        kpvt    INTEGER(n)
!                the pivot vector from dspfa.
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero may occur if  dspco  has set RCOND .EQ. 0.0
!        or  dspfa  has set info .NE. 0  .
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call dspfa(ap,n,kpvt,info)
!           if (info .ne. 0) go to ...
!           do 10 j = 1, p
!              call dspsl(ap,n,kpvt,c(1,j))
!        10 continue
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!     Subroutines and functions
!     BLAS daxpy,ddot
!     Fortran IABS
!     internal variables.
!     Loop backward applying the transformations and
!     D inverse to b.
k = n
ik = (n*(n - 1))/2
10 if (k == 0) go to 80
kk = ik + k
if (kpvt(k) < 0) go to 40
!           1 X 1 pivot block.
if (k == 1) go to 30
kp = kpvt(k)
if (kp == k) go to 20
!                 Interchange.
temp = b(k)
b(k) = b(kp)
b(kp) = temp
20 continue
!              Apply the transformation.
call daxpy(k - 1,b(k),ap(ik + 1),1,b(1),1)
30 continue
!           Apply D inverse.
b(k) = b(k)/ap(kk)
k = k - 1
ik = ik - k
go to 70
40 continue
!           2 X 2 pivot block.
ikm1 = ik - (k - 1)
if (k == 2) go to 60
kp = abs(kpvt(k))
if (kp == k - 1) go to 50
!                 Interchange.
temp = b(k - 1)
b(k - 1) = b(kp)
b(kp) = temp
50 continue
!              Apply the transformation.
call daxpy(k - 2,b(k),ap(ik + 1),1,b(1),1)
call daxpy(k - 2,b(k - 1),ap(ikm1 + 1),1,b(1),1)
60 continue
!           Apply D inverse.
km1k = ik + k - 1
kk = ik + k
ak = ap(kk)/ap(km1k)
km1km1 = ikm1 + k - 1
akm1 = ap(km1km1)/ap(km1k)
bk = b(k)/ap(km1k)
bkm1 = b(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0d0
b(k) = (akm1*bk - bkm1)/denom
b(k - 1) = (ak*bkm1 - bk)/denom
k = k - 2
ik = ik - (k + 1) - k
70 continue
go to 10
80 continue
!     Loop forward applying the transformations.
k = 1
ik = 0
90 if (k > n) go to 160
if (kpvt(k) < 0) go to 120
!           1 X 1 pivot block.
if (k == 1) go to 110
!              Apply the transformation.
b(k) = b(k) + ddot(k - 1,ap(ik + 1),1,b(1),1)
kp = kpvt(k)
if (kp == k) go to 100
!                 Interchange.
temp = b(k)
b(k) = b(kp)
b(kp) = temp
100 continue
110 continue
ik = ik + k
k = k + 1
go to 150
120 continue
!           2 X 2 pivot block.
if (k == 1) go to 140
!              Apply the transformation.
b(k) = b(k) + ddot(k - 1,ap(ik + 1),1,b(1),1)
ikp1 = ik + k
b(k + 1) = b(k + 1) + ddot(k - 1,ap(ikp1 + 1),1,b(1),1)
kp = abs(kpvt(k))
if (kp == k) go to 130
!                 Interchange.
temp = b(k)
b(k) = b(kp)
b(kp) = temp
130 continue
140 continue
ik = ik + k + k + 1
k = k + 2
150 continue
go to 90
160 continue
end subroutine dspsl

subroutine dspdi(ap,n,kpvt,det,inert,work,job)
implicit none
integer, intent(in) :: n, job
double precision, intent(inout) :: ap(*), work(*)
double precision, intent(inout) :: det(2)
integer, intent(in) :: kpvt(*)
integer, intent(inout) :: inert(3)
double precision :: akkp1, ddot, temp
double precision :: ten, d, t, ak, akp1
integer :: ij, ik, ikp1, iks, j, jb, jk, jkp1, k, kk, kkp1, km1, ks, ksj, kskp1, kstep
logical :: noinv, nodet, noert
!     dspdi computes the determinant, inertia and inverse
!     of a double precision symmetric matrix using the factors from
!     dspfa, where the matrix is stored in packed form.
!     On entry
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the output from dspfa.
!        n       INTEGER
!                the order of the matrix A.
!        kpvt    INTEGER(n)
!                the pivot vector from dspfa.
!        WORK    DOUBLE PRECISION(n)
!                work vector.  Contents ignored.
!        JOB     INTEGER
!                job has the decimal expansion  abc  where
!                   if  C .NE. 0, the inverse is computed,
!                   if  B .NE. 0, the determinant is computed,
!                   if  A .NE. 0, the inertia is computed.
!                For example, job = 111  Gives all three.
!     On return
!        variables not requested by job are not used.
!        ap     CONTAINS THE UPPER TRIANGLE OF THE INVERSE OF
!               the original matrix, stored in packed form.
!               The columns of the upper triangle are stored
!               sequentially in a one-dimensional array.
!        det    DOUBLE PRECISION(2)
!               determinant of original matrix.
!               determinant = det(1) * 10.0**det(2)
!               WITH 1.0 .LE. dabs(det(1)) .LT. 10.0
!               OR det(1) = 0.0.
!        Inert  integer(3)
!               the inertia of the original matrix.
!               inert(1)  =  Number of positive eigenvalues.
!               inert(2)  =  Number of negative eigenvalues.
!               inert(3)  =  Number of zero eigenvalues.
!     Error condition
!        a division by zero will occur if the inverse is requested
!        and  dspco  has set RCOND .EQ. 0.0
!        or  dspfa  has set  info .NE. 0 .
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!     Subroutines and functions
!     BLAS daxpy,dcopy,ddot,dswap
!     Fortran dabs,IABS,mod
!     internal variables.
noinv = mod(job,10) == 0
nodet = mod(job,100)/10 == 0
noert = mod(job,1000)/100 == 0
if (nodet .and. noert) go to 140
if (noert) go to 10
inert(1) = 0
inert(2) = 0
inert(3) = 0
10 continue
if (nodet) go to 20
det(1) = 1.0d0
det(2) = 0.0d0
ten = 10.0d0
20 continue
t = 0.0d0
ik = 0
do k = 1, n
   kk = ik + k
   d = ap(kk)
!           Check if 1 by 1
   if (kpvt(k) > 0) go to 50
!              2 By 2 block
!              USE det (d  S)  =  (d/t * C - t) * t  ,  t = dabs(S)
!                      (S  C)
!              to avoid underflow/overflow troubles.
!              Take two passes through scaling.  Use  t  for flag.
   if (t /= 0.0d0) go to 30
   ikp1 = ik + k
   kkp1 = ikp1 + k
   t = abs(ap(kkp1))
   d = (d/t)*ap(kkp1 + 1) - t
   go to 40
30 continue
   d = t
   t = 0.0d0
40 continue
50 continue
   if (noert) go to 60
   if (d > 0.0d0) inert(1) = inert(1) + 1
   if (d < 0.0d0) inert(2) = inert(2) + 1
   if (d == 0.0d0) inert(3) = inert(3) + 1
60 continue
   if (nodet) go to 120
   det(1) = d*det(1)
   if (det(1) == 0.0d0) go to 110
70 if (abs(det(1)) >= 1.0d0) go to 80
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0d0
   go to 70
80 continue
90 if (abs(det(1)) < ten) go to 100
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0d0
   go to 90
100 continue
110 continue
120 continue
   ik = ik + k
end do
140 continue
!     Compute inverse(A)
if (noinv) go to 270
k = 1
ik = 0
150 if (k > n) go to 260
km1 = k - 1
kk = ik + k
ikp1 = ik + k
kkp1 = ikp1 + k
if (kpvt(k) < 0) go to 180
!              1 By 1
ap(kk) = 1.0d0/ap(kk)
if (km1 < 1) go to 170
call dcopy(km1,ap(ik + 1),1,work,1)
ij = 0
do j = 1, km1
   jk = ik + j
   ap(jk) = ddot(j,ap(ij + 1),1,work,1)
   call daxpy(j - 1,work(j),ap(ij + 1),1,ap(ik + 1),1)
   ij = ij + j
end do
ap(kk) = ap(kk) + ddot(km1,work,1,ap(ik + 1),1)
170 continue
kstep = 1
go to 220
180 continue
!              2 By 2
t = abs(ap(kkp1))
ak = ap(kk)/t
akp1 = ap(kkp1 + 1)/t
akkp1 = ap(kkp1)/t
d = t*(ak*akp1 - 1.0d0)
ap(kk) = akp1/d
ap(kkp1 + 1) = ak/d
ap(kkp1) = -akkp1/d
if (km1 < 1) go to 210
call dcopy(km1,ap(ikp1 + 1),1,work,1)
ij = 0
do j = 1, km1
   jkp1 = ikp1 + j
   ap(jkp1) = ddot(j,ap(ij + 1),1,work,1)
   call daxpy(j - 1,work(j),ap(ij + 1),1,ap(ikp1 + 1),1)
   ij = ij + j
end do
ap(kkp1 + 1) = ap(kkp1 + 1) &
   & + ddot(km1,work,1,ap(ikp1 + 1),1)
ap(kkp1) = ap(kkp1) &
   & + ddot(km1,ap(ik + 1),1,ap(ikp1 + 1),1)
call dcopy(km1,ap(ik + 1),1,work,1)
ij = 0
do j = 1, km1
   jk = ik + j
   ap(jk) = ddot(j,ap(ij + 1),1,work,1)
   call daxpy(j - 1,work(j),ap(ij + 1),1,ap(ik + 1),1)
   ij = ij + j
end do
ap(kk) = ap(kk) + ddot(km1,work,1,ap(ik + 1),1)
210 continue
kstep = 2
220 continue
!           Swap
ks = abs(kpvt(k))
if (ks == k) go to 250
iks = (ks*(ks - 1))/2
call dswap(ks,ap(iks + 1),1,ap(ik + 1),1)
ksj = ik + ks
do jb = ks, k
   j = k + ks - jb
   jk = ik + j
   temp = ap(jk)
   ap(jk) = ap(ksj)
   ap(ksj) = temp
   ksj = ksj - (j - 1)
end do
if (kstep == 1) go to 240
kskp1 = ikp1 + ks
temp = ap(kskp1)
ap(kskp1) = ap(kkp1)
ap(kkp1) = temp
240 continue
250 continue
ik = ik + k
if (kstep == 2) ik = ik + k + 1
k = k + kstep
go to 150
260 continue
270 continue
end subroutine dspdi

subroutine pchol(mo,n,m,a,b,kb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m, mo, n
real, intent(inout) :: a(*), b(*)
integer :: j, onej
real :: d(2)
!     -----------------
!     -----------------
!              Matrix factorization
call sppfa(a,n,ierr)
if (ierr /= 0) return
!          Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call sppsl(a,n,b(onej))
   onej = onej + kb
end do
!         Computation of the inverse of A
20 if (mo == 0) call sppdi(a,n,d,1)
end subroutine pchol

pure subroutine sppfa(ap,n,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: info
real, intent(inout) :: ap(*)
real :: t, s
integer :: j, jj, jm1, k, kj, kk
interface
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!     sppfa factors a real symmetric positive definite matrix
!     stored in packed form.
!     sppfa is usually called by SPPCO, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for SPPCO) = (1 + 18/n)*(time for sppfa) .
!     On entry
!        ap      real (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!        n       INTEGER
!                the order of the matrix  A .
!     On return
!        ap      AN UPPER TRIANGULAR MATRIX  R , STORED IN PACKED
!                form, so that  A = Trans(R)*R .
!        INFO    INTEGER
!                = 0  For normal return.
!                = k  if the leading minor of order  k  is not
!                     positive definite.
!     Packed storage
!          the following program segment will pack the upper
!          triangle of a symmetric matrix.
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k) = a(i,j)
!             10    continue
!             20 continue
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS sdot
!     Fortran sqrt
!     internal variables
!     begin block with ...exits to 40
jj = 0
do j = 1, n
   info = j
   s = 0.0e0
   jm1 = j - 1
   kj = jj
   kk = 0
   if (jm1 < 1) go to 20
   do k = 1, jm1
      kj = kj + 1
      t = ap(kj) - sdot(k - 1,ap(kk + 1),1,ap(jj + 1),1)
      kk = kk + k
      t = t/ap(kk)
      ap(kj) = t
      s = s + t*t
   end do
20 continue
   jj = jj + j
   s = ap(jj) - s
!     ......Exit
   if (s <= 0.0e0) go to 40
   ap(jj) = sqrt(s)
end do
info = 0
40 continue
end subroutine sppfa

pure subroutine sppsl(ap,n,b)
implicit none
integer, intent(in) :: n
real, intent(in) :: ap(*)
real, intent(inout) :: b(*)
real :: t
integer :: k, kb, kk
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!     sppsl solves the real symmetric positive definite system
!     A * X = b
!     using the factors computed by SPPCO or sppfa.
!     On entry
!        ap      real (n*(n+1)/2)
!                the output from SPPCO or sppfa.
!        n       INTEGER
!                the order of the matrix  A .
!        b       real(n)
!                the right hand side vector.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal.  Technically this indicates
!        singularity but it is usually caused by improper subroutine
!        arguments.  It will not occur if the subroutines are called
!        correctly and  info .EQ. 0 .
!     to compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call sppco(ap,n,rcond,z,info)
!           if (rcond is too small .or. info .ne. 0) go to ...
!           do 10 j = 1, p
!              call sppsl(ap,n,c(1,j))
!        10 continue
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS saxpy,sdot
!     internal variables
kk = 0
do k = 1, n
   t = sdot(k - 1,ap(kk + 1),1,b(1),1)
   kk = kk + k
   b(k) = (b(k) - t)/ap(kk)
end do
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/ap(kk)
   kk = kk - k
   t = -b(k)
   call saxpy(k - 1,t,ap(kk + 1),1,b(1),1)
end do
end subroutine sppsl

subroutine sppdi(ap,n,det,job)
implicit none
integer, intent(in) :: n, job
real, intent(inout) :: ap(*)
real, intent(inout) :: det(2)
real :: t, s
integer :: i, ii, j, jj, jm1, j1, k, kj, kk, kp1, k1
!     sppdi computes the determinant and inverse
!     of a real symmetric positive definite matrix
!     using the factors computed by SPPCO or sppfa .
!     On entry
!        ap      real (n*(n+1)/2)
!                the output from SPPCO or sppfa.
!        n       INTEGER
!                the order of the matrix  A .
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!     On return
!        ap      THE UPPER TRIANGULAR HALF OF THE INVERSE .
!        det     real(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. det(1) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if SPOCO or SPOFA has set info .EQ. 0 .
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS saxpy,sscal
!     Fortran mod
!     internal variables
!     compute determinant
if (job/10 == 0) go to 70
det(1) = 1.0e0
det(2) = 0.0e0
s = 10.0e0
ii = 0
do i = 1, n
   ii = ii + i
   det(1) = ap(ii)**2*det(1)
!        ...Exit
   if ( det( 1 ) == 0.0e0 ) exit
10 if (det(1) >= 1.0e0) go to 20
   det(1) = s*det(1)
   det(2) = det(2) - 1.0e0
   go to 10
20 continue
30 if (det(1) < s) go to 40
   det(1) = det(1)/s
   det(2) = det(2) + 1.0e0
   go to 30
40 continue
end do
70 continue
!     Compute inverse(R)
if (mod(job,10) == 0) go to 140
kk = 0
do k = 1, n
   k1 = kk + 1
   kk = kk + k
   ap(kk) = 1.0e0/ap(kk)
   t = -ap(kk)
   call sscal(k - 1,t,ap(k1),1)
   kp1 = k + 1
   j1 = kk + 1
   kj = kk + k
   if (n < kp1) go to 90
   do j = kp1, n
      t = ap(kj)
      ap(kj) = 0.0e0
      call saxpy(k,t,ap(k1),1,ap(j1),1)
      j1 = j1 + j
      kj = kj + j
   end do
90 continue
end do
!        Form  inverse(R) * trans(inverse(R))
jj = 0
do j = 1, n
   j1 = jj + 1
   jj = jj + j
   jm1 = j - 1
   k1 = 1
   kj = j1
   if (jm1 < 1) go to 120
   do k = 1, jm1
      t = ap(kj)
      call saxpy(k,t,ap(j1),1,ap(k1),1)
      k1 = k1 + k
      kj = kj + 1
   end do
120 continue
   t = ap(jj)
   call sscal(j,t,ap(j1),1)
end do
140 continue
end subroutine sppdi

subroutine dpchol(mo,n,m,a,b,kb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m, mo, n
double precision, intent(inout) :: a(*), b(*)
integer :: j, onej
double precision :: d(2)
!     -----------------
!     -----------------
!              Matrix factorization
call dppfa(a,n,ierr)
if (ierr /= 0) return
!          Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call dppsl(a,n,b(onej))
   onej = onej + kb
end do
!         Computation of the inverse of A
20 if (mo == 0) call dppdi(a,n,d,1)
end subroutine dpchol

pure subroutine dppfa(ap,n,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: info
double precision, intent(inout) :: ap(*)
double precision :: t, s
integer :: j, jj, jm1, k, kj, kk
interface
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
end interface
!     dppfa factors a double precision symmetric positive definite
!     matrix stored in packed form.
!     dppfa is usually called by DPPCO, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for DPPCO) = (1 + 18/n)*(time for dppfa) .
!     On entry
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!        n       INTEGER
!                the order of the matrix  A .
!     On return
!        ap      AN UPPER TRIANGULAR MATRIX  R , STORED IN PACKED
!                form, so that  A = Trans(R)*R .
!        INFO    INTEGER
!                = 0  For normal return.
!                = k  if the leading minor of order  k  is not
!                     positive definite.
!     Packed storage
!          the following program segment will pack the upper
!          triangle of a symmetric matrix.
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k) = a(i,j)
!             10    continue
!             20 continue
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS ddot
!     Fortran DSQRT
!     internal variables
!     begin block with ...exits to 40
jj = 0
do j = 1, n
   info = j
   s = 0.0d0
   jm1 = j - 1
   kj = jj
   kk = 0
   if (jm1 < 1) go to 20
   do k = 1, jm1
      kj = kj + 1
      t = ap(kj) - ddot(k - 1,ap(kk + 1),1,ap(jj + 1),1)
      kk = kk + k
      t = t/ap(kk)
      ap(kj) = t
      s = s + t*t
   end do
20 continue
   jj = jj + j
   s = ap(jj) - s
!     ......Exit
   if (s <= 0.0d0) go to 40
   ap(jj) = sqrt(s)
end do
info = 0
40 continue
end subroutine dppfa

pure subroutine dppsl(ap,n,b)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: ap(*)
double precision, intent(inout) :: b(*)
double precision :: t
integer :: k, kb, kk
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
end interface
!     dppsl solves the double precision symmetric positive definite
!     SYSTEM A * X = b
!     using the factors computed by DPPCO or dppfa.
!     On entry
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the output from DPPCO or dppfa.
!        n       INTEGER
!                the order of the matrix  A .
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal.  Technically this indicates
!        singularity but it is usually caused by improper subroutine
!        arguments.  It will not occur if the subroutines are called
!        correctly and  info .EQ. 0 .
!     to compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call dppco(ap,n,rcond,z,info)
!           if (rcond is too small .or. info .ne. 0) go to ...
!           do 10 j = 1, p
!              call dppsl(ap,n,c(1,j))
!        10 continue
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS daxpy,ddot
!     internal variables
kk = 0
do k = 1, n
   t = ddot(k - 1,ap(kk + 1),1,b(1),1)
   kk = kk + k
   b(k) = (b(k) - t)/ap(kk)
end do
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/ap(kk)
   kk = kk - k
   t = -b(k)
   call daxpy(k - 1,t,ap(kk + 1),1,b(1),1)
end do
end subroutine dppsl

subroutine dppdi(ap,n,det,job)
implicit none
integer, intent(in) :: n, job
double precision, intent(inout) :: ap(*)
double precision, intent(inout) :: det(2)
double precision :: t, s
integer :: i, ii, j, jj, jm1, j1, k, kj, kk, kp1, k1
!     dppdi computes the determinant and inverse
!     of a double precision symmetric positive definite matrix
!     using the factors computed by DPPCO or dppfa .
!     On entry
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the output from DPPCO or dppfa.
!        n       INTEGER
!                the order of the matrix  A .
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!     On return
!        ap      THE UPPER TRIANGULAR HALF OF THE INVERSE .
!        det     DOUBLE PRECISION(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. det(1) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if DPOCO or DPOFA has set info .EQ. 0 .
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS daxpy,dscal
!     Fortran mod
!     internal variables
!     compute determinant
if (job/10 == 0) go to 70
det(1) = 1.0d0
det(2) = 0.0d0
s = 10.0d0
ii = 0
do i = 1, n
   ii = ii + i
   det(1) = ap(ii)**2*det(1)
!        ...Exit
   if ( det( 1 ) == 0.0d0 ) exit
10 if (det(1) >= 1.0d0) go to 20
   det(1) = s*det(1)
   det(2) = det(2) - 1.0d0
   go to 10
20 continue
30 if (det(1) < s) go to 40
   det(1) = det(1)/s
   det(2) = det(2) + 1.0d0
   go to 30
40 continue
end do
70 continue
!     Compute inverse(R)
if (mod(job,10) == 0) go to 140
kk = 0
do k = 1, n
   k1 = kk + 1
   kk = kk + k
   ap(kk) = 1.0d0/ap(kk)
   t = -ap(kk)
   call dscal(k - 1,t,ap(k1),1)
   kp1 = k + 1
   j1 = kk + 1
   kj = kk + k
   if (n < kp1) go to 90
   do j = kp1, n
      t = ap(kj)
      ap(kj) = 0.0d0
      call daxpy(k,t,ap(k1),1,ap(j1),1)
      j1 = j1 + j
      kj = kj + j
   end do
90 continue
end do
!        Form  inverse(R) * trans(inverse(R))
jj = 0
do j = 1, n
   j1 = jj + 1
   jj = jj + j
   jm1 = j - 1
   k1 = 1
   kj = j1
   if (jm1 < 1) go to 120
   do k = 1, jm1
      t = ap(kj)
      call daxpy(k,t,ap(j1),1,ap(k1),1)
      k1 = k1 + k
      kj = kj + 1
   end do
120 continue
   t = ap(jj)
   call dscal(j,t,ap(j1),1)
end do
140 continue
end subroutine dppdi

pure subroutine toplx(a, b, x, n, g, h, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), g(n), h(n)
integer :: j, k, l, m, max, mp1, nml, npl
real :: c, c1, c2, gd, gj, gk, gn, hj, hk, hn, xd, xn
!-----------------------------------------------------------------------
!            Solution of the Toeplitz system of equations
!               sum(j = 1,...,n) a(n+I-j)*x(j) = b(I)
!     FOR I = 1,...,n.
!-----------------------------------------------------------------------
!     real a(2*n - 1)
!----------------------
if (a(n) == 0.0) go to 100
ierr = 0
x(1) = b(1)/a(n)
if (n == 1) return
g(1) = a(n - 1)/a(n)
h(1) = a(n + 1)/a(n)
mp1 = 1
!     Compute numerator and denominator of x(m+1)
10 m = mp1
mp1 = m + 1
xn = -b(mp1)
xd = -a(n)
do j = 1,m
   l = mp1 - j
   npl = n + l
   xn = xn + a(npl)*x(j)
   xd = xd + a(npl)*g(l)
end do
if (xd == 0.0) go to 100
x(mp1) = xn/xd
!        Compute x
c = x(mp1)
do j = 1,m
   l = mp1 - j
   x(j) = x(j) - c*g(l)
end do
if (mp1 == n) return
!     Compute numerator and denominator of g(m+1) and h(m+1)
l = n - mp1
gn = -a(l)
gd = -a(n)
l = n + mp1
hn = -a(l)
do j = 1,m
   l = mp1 - j
   nml = n - l
   npl = n + l
   gn = gn + a(nml)*g(j)
   gd = gd + a(nml)*h(l)
   hn = hn + a(npl)*h(j)
end do
if (gd == 0.0) go to 100
g(mp1) = gn/gd
h(mp1) = hn/xd
!     Compute g and h
c1 = g(mp1)
c2 = h(mp1)
max = mp1/2
k = m
do j = 1,max
   gj = g(j)
   gk = g(k)
   hj = h(j)
   hk = h(k)
   g(j) = gj - c1*hk
   g(k) = gk - c1*hj
   h(j) = hj - c2*gk
   h(k) = hk - c2*gj
   k = k - 1
end do
go to 10
!     Error return
100 ierr = 1
end subroutine toplx

pure subroutine dtoplx(a, b, x, n, g, h, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), g(n), h(n)
integer :: j, k, l, m, max, mp1, nml, npl
double precision :: c, c1, c2, gd, gj, gk, gn, hj, hk, hn, xd, xn
!-----------------------------------------------------------------------
!            Solution of the Toeplitz system of equations
!               sum(j = 1,...,n) a(n+I-j)*x(j) = b(I)
!     FOR I = 1,...,n.
!-----------------------------------------------------------------------
!     double precision a(2*n - 1)
!----------------------
if (a(n) == 0.d0) go to 100
ierr = 0
x(1) = b(1)/a(n)
if (n == 1) return
g(1) = a(n - 1)/a(n)
h(1) = a(n + 1)/a(n)
mp1 = 1
!     Compute numerator and denominator of x(m+1)
10 m = mp1
mp1 = m + 1
xn = -b(mp1)
xd = -a(n)
do j = 1,m
   l = mp1 - j
   npl = n + l
   xn = xn + a(npl)*x(j)
   xd = xd + a(npl)*g(l)
end do
if (xd == 0.d0) go to 100
x(mp1) = xn/xd
!        Compute x
c = x(mp1)
do j = 1,m
   l = mp1 - j
   x(j) = x(j) - c*g(l)
end do
if (mp1 == n) return
!     Compute numerator and denominator of g(m+1) and h(m+1)
l = n - mp1
gn = -a(l)
gd = -a(n)
l = n + mp1
hn = -a(l)
do j = 1,m
   l = mp1 - j
   nml = n - l
   npl = n + l
   gn = gn + a(nml)*g(j)
   gd = gd + a(nml)*h(l)
   hn = hn + a(npl)*h(j)
end do
if (gd == 0.d0) go to 100
g(mp1) = gn/gd
h(mp1) = hn/xd
!     Compute g and h
c1 = g(mp1)
c2 = h(mp1)
max = mp1/2
k = m
do j = 1,max
   gj = g(j)
   gk = g(k)
   hj = h(j)
   hk = h(k)
   g(j) = gj - c1*hk
   g(k) = gk - c1*hj
   h(j) = hj - c2*gk
   h(k) = hk - c2*gj
   k = k - 1
end do
go to 10
!     Error return
100 ierr = 1
end subroutine dtoplx

subroutine cmslv(mo,n,m,a,ka,b,kb,det,rcond,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo
integer :: n
complex, intent(inout) :: a(ka,n), b(*), det(2), wk(n)
real, intent(inout) :: rcond
integer, intent(inout) :: ipvt(n)
integer :: j, job, onej
real :: t
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting complex matrices
!     and solving complex equations
!-----------------------------------------------------------------------
!          Matrix factorization and computation of rcond
ierr = 0
call cgeco(a, ka, n, ipvt, rcond, wk)
t = 1.0 + rcond
if (t == 1.0) go to 30
!                  Solution of the equation AX=b
if (m < 1) go to 20
onej = 1
do j = 1,m
   call cgesl(a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!             Calculation of det and the inverse of A
20 job = 10
if (mo == 0) job = 11
call cgedi(a, ka, n, ipvt, det, wk, job)
return
!                  The problem cannot be solved
30 ierr = 1
end subroutine cmslv

subroutine cmslv1(mo, n, m, a, ka, b, kb, ierr, ipvt, wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo
integer :: n
complex, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
integer :: j, onej
complex :: d(2)
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting complex matrices
!     and solving complex equations
!-----------------------------------------------------------------------
if (n < 1 .or. ka < n) go to 40
if (m <= 0) go to 10
if (kb < n) go to 40
!                      Matrix factorization
10 call cgefa(a, ka, n, ipvt, ierr)
if (ierr /= 0) return
!                 Solution of the equation AX = b
if (m <= 0) go to 30
onej = 1
do j = 1,m
   call cgesl(a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!                 Calculation of the inverse of A
30 if (mo == 0) call cgedi(a, ka, n, ipvt, d, wk, 1)
return
!                          Error return
40 ierr = -1
end subroutine cmslv1

subroutine cslvmp(mo, n, a, ka, b, x, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, mo
integer :: n
complex, intent(in) :: a(ka,n), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(inout) :: iwk(n)
integer :: i, ir
!     ******************************************************************
!     Solution of complex linear equations with iterative improvement
!     ******************************************************************
!     -----------------
!     complex wk(n*n + n)
!     -----------------
if (mo /= 0) go to 10
!             Compute the LU decomposition of A
call cmcopy(n, n, a, ka, wk, n)
call cgefa(wk, n, n, iwk, ierr)
if (ierr == 0) go to 10
ierr = -ierr
return
!            Solve the system of equations AX = b
10 do i = 1,n
   x(i) = b(i)
end do
ir = n*n + 1
call cgesl(wk, n, n, iwk, x, 0)
call cluimp(a, ka, n, wk(1), n, iwk, b, x, wk(ir), ierr)
end subroutine cslvmp

pure subroutine cluimp(a, ka, n, q, kq, ipvt, b, x, r, ind)
implicit none
integer, intent(out) :: ind
integer, intent(in) :: ka, kq, n
complex, intent(in) :: a(ka,n), q(kq,n), b(n)
complex, intent(inout) :: x(n), r(n)
integer, intent(in) :: ipvt(n)
integer :: i, j
real :: eps, eps2, rat, ratio, rnrm, xnrm
double precision :: ra, ia, rx, ix, rsum, isum
interface
   pure subroutine cgesl(a,lda,n,ipvt,b,job)
      implicit none
      integer, intent(in) :: lda
      complex, intent(in) :: a(lda,*)
      integer, intent(in) :: n
      integer, intent(in) :: ipvt(*)
      complex, intent(inout) :: b(*)
      integer, intent(in) :: job
   end subroutine cgesl
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!     Purpose
!       given an approximate solution x of a complex system AX = b
!       obtained using cgeco or cgefa. cluimp attempts to compute
!       an improved solution correct to machine precision.
!     Parameters
!       A    A COMPLEX ARRAY OF DIMENSION (ka,n) CONTAINING THE
!            matrix a of order n.
!       q    A COMPLEX ARRAY OF DIMENSION (kq,n) CONTAINING THE
!            LU decomposition of a produced by cgeco or cgefa.
!       ipvt an array of dimension n containing the permutation
!            information given by cgeco or cgefa.
!       b    the right hand side of the equation AX = b.
!       x    on input x is the approximate solution of AX = b to
!            be improved. On output x is the solution obtained.
!       r    A COMPLEX ARRAY FOR INTERNAL USE BY THE ROUTINE.
!       Ind  variable that reports the status of the results.
!            ind = 0 If improvement of x is successful with A
!            gain in accuracy of at least 50 per cent each
!            iteration. Otherwise ind = 1.
! ----------------------------------------------------------------------
!     ********** eps is a machine dependent parameter. Assign eps
!                the value U where U is the smallest floating point
!                number such that 1.0 + U .GT. 1.0.
eps = spmpar(1)
ind = 0
xnrm = 0.0
do i = 1,n
   xnrm = xnrm + (real(x(i))**2 + aimag(x(i))**2)
end do
if (xnrm == 0.0) return
eps2 = eps*eps
ratio = 1.0
!                  Compute the residual vector
20 do i = 1,n
   rsum = dble(real(b(i)))
   isum = dble(aimag(b(i)))
   do j = 1,n
      ra = dble(real(a(i,j)))
      ia = dble(aimag(a(i,j)))
      rx = dble(real(x(j)))
      ix = dble(aimag(x(j)))
      rsum = rsum - ra*rx + ia*ix
      isum = isum - ra*ix - ia*rx
   end do
   r(i) = cmplx(sngl(rsum),sngl(isum))
end do
!                  Find the correction vector
call cgesl(q, kq, n, ipvt, r, 0)
rnrm = 0.0
do i = 1,n
   rnrm = rnrm + (real(r(i))**2 + aimag(r(i))**2)
end do
if (rnrm <= eps2*xnrm) return
!                Form a new approximate solution
do i = 1,n
   x(i) = x(i) + r(i)
end do
xnrm = 0.0
do i = 1,n
   xnrm = xnrm + (real(x(i))**2 + aimag(x(i))**2)
end do
if (xnrm == 0.0) return
rat = ratio
ratio = rnrm/xnrm
if (ratio <= 0.25*rat) go to 20
if (ratio > min(rat,4.0*eps2)) ind = 1
end subroutine cluimp

subroutine cgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda
integer :: n
integer, intent(inout) :: ipvt(*)
complex, intent(inout) :: a(lda,*), z(*)
real, intent(inout) :: rcond
complex :: cdotc, ek, t, wk, wkm
real :: anorm, s, scasum, sm, ynorm
integer :: info, j, k, kb, kp1, l
complex :: zdum, zdum1, zdum2
!     cgeco factors a complex matrix BY Gaussian elimination
!     and estimates the condition of the matrix.
!     If  rcond  is not needed, cgefa is slightly faster.
!     To solve  a*X = B , follow cgeco by cgesl.
!     To compute  inverse(a)*C , follow cgeco by cgesl.
!     To compute  determinant(a) , follow cgeco by cgedi.
!     To compute  inverse(a) , follow cgeco by cgedi.
!     On entry
!        A       COMPLEX(lda, n)
!                the matrix to be factored.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        rcond   REAL
!                an estimate of the reciprocal condition of  A .
!                For the system  a*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!        z       COMPLEX(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     LINPACK cgefa
!     BLAS caxpy,cdotc,csscal,scasum
!     Fortran abs,aimag,AMAX1,cmplx,CONJG,real
!     internal variables
!     Compute 1-norm of A
anorm = 0.0e0
do j = 1, n
   anorm = max(anorm,scasum(n,a(1,j),1))
end do
!     Factor
call cgefa(a,lda,n,ipvt,info)
!     rcond = 1/(norm(a)*(estimate of norm(inverse(a)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  a*z = Y  AND  ctrans(a)*Y = E .
!     ctrans(a)  is the conjugate transpose of A .
!     The components of  E  are chosen to cause maximum local
!     growth in the elements of W  where  ctrans(U)*W = E .
!     The vectors are frequently rescaled to avoid overflow.
!     SOLVE ctrans(U)*W = E
ek = (1.0e0,0.0e0)
do j = 1, n
   z(j) = (0.0e0,0.0e0)
end do
do k = 1, n
   if (cabs1(z(k)) /= 0.0e0) ek = csign1(ek,-z(k))
   if (cabs1(ek - z(k)) <= cabs1(a(k,k))) go to 30
   s = cabs1(a(k,k))/cabs1(ek - z(k))
   call csscal(n,s,z,1)
   ek = cmplx(s,0.0e0)*ek
30 continue
   wk = ek - z(k)
   wkm = -ek - z(k)
   s = cabs1(wk)
   sm = cabs1(wkm)
   if (cabs1(a(k,k)) == 0.0e0) go to 40
   wk = wk/conjg(a(k,k))
   wkm = wkm/conjg(a(k,k))
   go to 50
40 continue
   wk = (1.0e0,0.0e0)
   wkm = (1.0e0,0.0e0)
50 continue
   kp1 = k + 1
   if (kp1 > n) go to 90
   do j = kp1, n
      sm = sm + cabs1(z(j) + wkm*conjg(a(k,j)))
      z(j) = z(j) + wk*conjg(a(k,j))
      s = s + cabs1(z(j))
   end do
   if (s >= sm) go to 80
   t = wkm - wk
   wk = wkm
   do j = kp1, n
      z(j) = z(j) + t*conjg(a(k,j))
   end do
80 continue
90 continue
   z(k) = wk
end do
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
!     SOLVE ctrans(l)*Y = W
do kb = 1, n
   k = n + 1 - kb
   if (k < n) z(k) = z(k) + cdotc(n - k,a(k + 1,k),1,z(k + 1),1)
   if (cabs1(z(k)) <= 1.0e0) go to 110
   s = 1.0e0/cabs1(z(k))
   call csscal(n,s,z,1)
110 continue
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
end do
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
ynorm = 1.0e0
!     SOLVE l*V = Y
do k = 1, n
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
   if (k < n) call caxpy(n - k,t,a(k + 1,k),1,z(k + 1),1)
   if (cabs1(z(k)) <= 1.0e0) go to 130
   s = 1.0e0/cabs1(z(k))
   call csscal(n,s,z,1)
   ynorm = s*ynorm
130 continue
end do
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
ynorm = s*ynorm
!     SOLVE  U*z = V
do kb = 1, n
   k = n + 1 - kb
   if (cabs1(z(k)) <= cabs1(a(k,k))) go to 150
   s = cabs1(a(k,k))/cabs1(z(k))
   call csscal(n,s,z,1)
   ynorm = s*ynorm
150 continue
   if (cabs1(a(k,k)) /= 0.0e0) z(k) = z(k)/a(k,k)
   if (cabs1(a(k,k)) == 0.0e0) z(k) = (1.0e0,0.0e0)
   t = -z(k)
   call caxpy(k - 1,t,a(1,k),1,z(1),1)
end do
!     MAKE ZNORM = 1.0
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
ynorm = s*ynorm
if (anorm /= 0.0e0) rcond = ynorm/anorm
if (anorm == 0.0e0) rcond = 0.0e0
contains
   pure function cabs1(zdum) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum
      real :: nswc_sf_result
      nswc_sf_result = abs(real(zdum)) + abs(aimag(zdum))
   end function cabs1
   pure function csign1(zdum1, zdum2) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum1
      complex, intent(in) :: zdum2
      complex :: nswc_sf_result
      nswc_sf_result = cabs1(zdum1)*(zdum2/cabs1(zdum2))
   end function csign1
end subroutine cgeco

subroutine cgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda
integer :: n
integer, intent(inout) :: ipvt(*), info
complex, intent(inout) :: a(lda,*)
complex :: t
integer :: icamax, j, k, kp1, l, nm1
complex :: zdum
!     cgefa factors a complex matrix BY Gaussian elimination.
!     cgefa is usually called by cgeco, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for cgeco) = (1 + 9/n)*(time for cgefa) .
!     On entry
!        A       COMPLEX(lda, n)
!                the matrix to be factored.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!                     condition for this subroutine, but it does
!                     indicate that cgesl or cgedi will divide by zero
!                     if called.  Use  RCOND  in cgeco for a reliable
!                     indication of singularity.
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS caxpy,cscal,icamax
!     Fortran abs,aimag,real
!     internal variables
!     Gaussian elimination with partial pivoting
info = 0
nm1 = n - 1
if (nm1 < 1) go to 70
do k = 1, nm1
   kp1 = k + 1
!        Find l = Pivot index
   l = icamax(n - k + 1,a(k,k),1) + k - 1
   ipvt(k) = l
!        Zero pivot implies this column already triangularized
   if (cabs1(a(l,k)) == 0.0e0) go to 40
!           Interchange if necessary
   if (l == k) go to 10
   t = a(l,k)
   a(l,k) = a(k,k)
   a(k,k) = t
10 continue
!           Compute multipliers
   t = -(1.0e0,0.0e0)/a(k,k)
   call cscal(n - k,t,a(k + 1,k),1)
!           Row elimination with column indexing
   do j = kp1, n
      t = a(l,j)
      if (l == k) go to 20
      a(l,j) = a(k,j)
      a(k,j) = t
20    continue
      call caxpy(n - k,t,a(k + 1,k),1,a(k + 1,j),1)
   end do
   go to 50
40 continue
   info = k
50 continue
end do
70 continue
ipvt(n) = n
if (cabs1(a(n,n)) == 0.0e0) info = n
contains
   pure function cabs1(zdum) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum
      real :: nswc_sf_result
      nswc_sf_result = abs(real(zdum)) + abs(aimag(zdum))
   end function cabs1
end subroutine cgefa

pure subroutine cgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
complex, intent(in) :: a(lda,*)
complex, intent(inout) :: b(*)
complex :: t
integer :: k, kb, l, nm1
interface
   pure subroutine caxpy(n,ca,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: ca
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(inout) :: cy(*)
      integer, intent(in) :: incy
   end subroutine caxpy
   pure function cdotc(n,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(in) :: cy(*)
      integer, intent(in) :: incy
      complex :: cdotc
   end function cdotc
end interface
!     cgesl solves the complex system
!     a * X = b  OR  ctrans(a) * X = b
!     using the factors computed by cgeco or cgefa.
!     On entry
!        A       COMPLEX(lda, n)
!                the output from cgeco or cgefa.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!        ipvt    INTEGER(n)
!                the pivot vector from cgeco or cgefa.
!        b       COMPLEX(n)
!                the right hand side vector.
!        JOB     INTEGER
!                = 0         To solve  a*X = b ,
!                = Nonzero   to solve  ctrans(a)*X = b  where
!                            ctrans(a)  is the conjugate transpose.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda .  It will not occur if the subroutines are
!        called correctly and if cgeco has set RCOND .GT. 0.0
!        or cgefa has set info .EQ. 0 .
!     to compute  inverse(a) * C  where  C  is a matrix
!     with  P  columns
!           call cgeco(a,lda,n,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call cgesl(a,lda,n,ipvt,c(1,j),0)
!        10 continue
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS caxpy,cdotc
!     Fortran CONJG
!     internal variables
nm1 = n - 1
if (job /= 0) go to 50
!        job = 0 , SOLVE  a * X = b
!        first solve  l*Y = b
if (nm1 < 1) go to 30
do k = 1, nm1
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 continue
   call caxpy(n - k,t,a(k + 1,k),1,b(k + 1),1)
end do
30 continue
!        Now solve  U*X = Y
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/a(k,k)
   t = -b(k)
   call caxpy(k - 1,t,a(1,k),1,b(1),1)
end do
go to 100
50 continue
!        job = NONZERO, SOLVE  ctrans(a) * X = b
!        first solve  ctrans(U)*Y = b
do k = 1, n
   t = cdotc(k - 1,a(1,k),1,b(1),1)
   b(k) = (b(k) - t)/conjg(a(k,k))
end do
!        Now solve ctrans(l)*X = Y
if (nm1 < 1) go to 90
do kb = 1, nm1
   k = n - kb
   b(k) = b(k) + cdotc(n - k,a(k + 1,k),1,b(k + 1),1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
90 continue
100 continue
end subroutine cgesl

subroutine cgedi(a,lda,n,ipvt,det,work,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
complex, intent(inout) :: a(lda,*), det(2), work(*)
complex :: t, zdum
real :: ten
integer :: i, j, k, kb, kp1, l, nm1
!     cgedi computes the determinant and inverse of a matrix
!     using the factors computed by cgeco or cgefa.
!     On entry
!        A       COMPLEX(lda, n)
!                the output from cgeco or cgefa.
!        lda     INTEGER
!                the leading dimension of the array  a .
!        n       INTEGER
!                the order of the matrix  a .
!        ipvt    INTEGER(n)
!                the pivot vector from cgeco or cgefa.
!        WORK    COMPLEX(n)
!                work vector.  Contents destroyed.
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!     On return
!        A       INVERSE OF ORIGINAL MATRIX IF REQUESTED.
!                Otherwise unchanged.
!        det     COMPLEX(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. cabs1(det(1)) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!     Error condition
!        a division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if cgeco has set RCOND .GT. 0.0 or cgefa has set
!        INFO .EQ. 0 .
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!     Subroutines and functions
!     BLAS caxpy,cscal,cswap
!     Fortran abs,aimag,cmplx,mod,real
!     internal variables
!     Compute determinant
if (job/10 == 0) go to 70
det(1) = (1.0e0,0.0e0)
det(2) = (0.0e0,0.0e0)
ten = 10.0e0
do i = 1, n
   if (ipvt(i) /= i) det(1) = -det(1)
   det(1) = a(i,i)*det(1)
!        ...Exit
   if ( cabs1 ( det( 1 ) ) == 0.0e0 ) exit
10 if (cabs1(det(1)) >= 1.0e0) go to 20
   det(1) = cmplx(ten,0.0e0)*det(1)
   det(2) = det(2) - (1.0e0,0.0e0)
   go to 10
20 continue
30 if (cabs1(det(1)) < ten) go to 40
   det(1) = det(1)/cmplx(ten,0.0e0)
   det(2) = det(2) + (1.0e0,0.0e0)
   go to 30
40 continue
end do
70 continue
!     Compute inverse(U)
if (mod(job,10) == 0) go to 150
do k = 1, n
   a(k,k) = (1.0e0,0.0e0)/a(k,k)
   t = -a(k,k)
   call cscal(k - 1,t,a(1,k),1)
   kp1 = k + 1
   if (n < kp1) go to 90
   do j = kp1, n
      t = a(k,j)
      a(k,j) = (0.0e0,0.0e0)
      call caxpy(k,t,a(1,k),1,a(1,j),1)
   end do
90 continue
end do
!        Form inverse(U)*inverse(l)
nm1 = n - 1
if (nm1 < 1) go to 140
do kb = 1, nm1
   k = n - kb
   kp1 = k + 1
   do i = kp1, n
      work(i) = a(i,k)
      a(i,k) = (0.0e0,0.0e0)
   end do
   do j = kp1, n
      t = work(j)
      call caxpy(n,t,a(1,j),1,a(1,k),1)
   end do
   l = ipvt(k)
   if (l /= k) call cswap(n,a(1,k),1,a(1,l),1)
end do
140 continue
150 continue
contains
   pure function cabs1(zdum) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum
      real :: nswc_sf_result
      nswc_sf_result = abs(real(zdum)) + abs(aimag(zdum))
   end function cabs1
end subroutine cgedi

subroutine dcmslv(mo,n,m,ar,ai,ka,br,bi,kb,ierr,ipvt,wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo
integer :: n
double precision, intent(inout) :: ar(ka,n), ai(ka,n), br(*), &
   & bi(*), wk(*)
integer, intent(inout) :: ipvt(n)
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     complex matrices and solving double precision complex equations
!-----------------------------------------------------------------------
if (n < 1 .or. ka < n) go to 30
if (m <= 0) go to 10
if (kb < n) go to 30
!                      Matrix factorization
10 call dcfact(ar, ai, ka, n, ipvt, ierr)
if (ierr /= 0) return
!                 Solution of the equation AX = B
if (m <= 0) go to 20
call dcsol(n, m, ar, ai, ka, br, bi, kb, ipvt)
!                 Calculation of the inverse of A
20 if (mo == 0) call dcminv(ar, ai, ka, n, ipvt, wk)
return
!                          Error return
30 ierr = -1
end subroutine dcmslv

pure subroutine dcfact(ar, ai, ka, n, ipvt, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: ar(ka,n), ai(ka,n)
integer, intent(inout) :: ipvt(n)
integer :: i, j, k, kp1, l, nm1
double precision :: p, pr, pi, t, tr, ti
interface
   pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
      implicit none
      double precision, intent(in) :: ar
      double precision, intent(in) :: ai
      double precision, intent(in) :: br
      double precision, intent(in) :: bi
      double precision, intent(inout) :: cr
      double precision, intent(inout) :: ci
   end subroutine cdivid
end interface
!-----------------------------------------------------------------------
!     Decomposes a complex matrix BY partial pivot Gauss elimination
!-----------------------------------------------------------------------
!     Input ...
!        ar and ai are the real and imaginary parts of the matrix A
!        to be decomposed.
!        ka = Declared row dimension of the arrays ar and ai
!        n  = Order of the matrix A
!     output ...
!        ar and ai contain an upper triangular matrix U and the
!        multipliers needed to construct l so that A = l*U .
!        ipvt = The pivot vector.
!            ipvt(i) = The index of the k-TH pivot row (i .LT. n)
!            ipvt(n) = (-1)**(number of interchanges)
!        ierr is a variable that reports the status of the results.
!        ierr has one of the following values ...
!            ierr = 0   The decomposition of A was obtained.
!            ierr = k   the k-TH pivot element is 0.
!     If ierr = 0 Then the determinant of A has the value ...
!        det(a) = ipvt(n) * a(1,1) * a(2,2) * ... * a(n,n)
!-----------------------------------------------------------------------
ierr = 0
ipvt(n) = 1
if (n == 1) go to 50
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!               Search for the k-TH pivot element
   p = abs(ar(k,k)) + abs(ai(k,k))
   l = k
   do i = kp1,n
      t = abs(ar(i,k)) + abs(ai(i,k))
      if (p >= t) go to 10
      p = t
      l = i
10    continue
   end do
   if (p == 0.d0) go to 100
   pr = ar(l,k)
   pi = ai(l,k)
   ipvt(k) = l
   if (l == k) go to 20
   ipvt(n) = -ipvt(n)
   ar(l,k) = ar(k,k)
   ar(k,k) = pr
   ai(l,k) = ai(k,k)
   ai(k,k) = pi
!                    Compute the multipliers
20 call cdivid(1.d0, 0.d0, pr, pi, pr, pi)
   do i = kp1,n
      tr = ar(i,k)
      ti = ai(i,k)
      ar(i,k) = tr*pr - ti*pi
      ai(i,k) = tr*pi + ti*pr
   end do
!              Interchange and eliminate by columns
   do j = kp1,n
      tr = ar(l,j)
      ar(l,j) = ar(k,j)
      ar(k,j) = tr
      ti = ai(l,j)
      ai(l,j) = ai(k,j)
      ai(k,j) = ti
      if (abs(tr) + abs(ti) == 0.d0) go to 31
      do i = kp1,n
         ar(i,j) = ar(i,j) - ar(i,k)*tr + ai(i,k)*ti
         ai(i,j) = ai(i,j) - ar(i,k)*ti - ai(i,k)*tr
      end do
31    continue
   end do
end do
!                  Check the n-TH pivot element
50 if (abs(ar(n,n)) + abs(ai(n,n)) == 0.d0) ierr = n
return
!                    k-TH pivot element is 0
100 ierr = k
end subroutine dcfact

pure subroutine dcsol(n, m, ar, ai, ka, br, bi, kb, ipvt)
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: ar(ka,n), ai(ka,n)
double precision, intent(inout) :: br(kb,m), bi(kb,m)
integer, intent(in) :: ipvt(n)
integer :: i, j, k, km1, kp1, l, nm1
double precision :: pr, pi, tr, ti
interface
   pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
      implicit none
      double precision, intent(in) :: ar
      double precision, intent(in) :: ai
      double precision, intent(in) :: br
      double precision, intent(in) :: bi
      double precision, intent(inout) :: cr
      double precision, intent(inout) :: ci
   end subroutine cdivid
end interface
!-----------------------------------------------------------------------
!     Solution of the system of m equations A*X = B using the
!     decomposition obtained by dcfact. This routine CANNOT be
!     used when dcfact terminates with nonzero IERR.
!-----------------------------------------------------------------------
!     Input ...
!        ar and ai contain the LU decomposition of the matrix
!        obtained by dcfact.
!        ka = Declared row dimension of the arrays ar and ai
!        n  = Order of the matrix
!        br and bi are the real and imaginary parts of the
!        right hand side matrix.
!        kb = Declared row dimension of the arrays br and bi
!        m  = Number of columns of B
!        ipvt = Pivot vector obtained from dcfact
!     output ...
!        br and bi contain the real and imaginary parts of the
!        solution X.
!-----------------------------------------------------------------------
!                    Forward elimination
if (n == 1) go to 50
nm1 = n - 1
do k = 1, nm1
   kp1 = k + 1
   l = ipvt(k)
   do j = 1,m
      tr = br(l,j)
      br(l,j) = br(k,j)
      br(k,j) = tr
      ti = bi(l,j)
      bi(l,j) = bi(k,j)
      bi(k,j) = ti
      if (abs(tr) + abs(ti) == 0.d0) go to 11
      do i = kp1, n
         br(i,j) = br(i,j) - ar(i,k)*tr + ai(i,k)*ti
         bi(i,j) = bi(i,j) - ar(i,k)*ti - ai(i,k)*tr
      end do
11    continue
   end do
end do
!                   Backward elimination
!               for the last n - 1 Variables
do l = 1,nm1
   km1 = n - l
   k = km1 + 1
   call cdivid(1.d0, 0.d0, ar(k,k), ai(k,k), pr, pi)
   do j = 1,m
      tr = br(k,j)
      ti = bi(k,j)
      br(k,j) = tr*pr - ti*pi
      bi(k,j) = tr*pi + ti*pr
      tr = br(k,j)
      ti = bi(k,j)
      do i = 1, km1
         br(i,j) = br(i,j) - ar(i,k)*tr + ai(i,k)*ti
         bi(i,j) = bi(i,j) - ar(i,k)*ti - ai(i,k)*tr
      end do
   end do
end do
50 call cdivid(1.d0, 0.d0, ar(1,1), ai(1,1), pr, pi)
do j = 1,m
   tr = br(1,j)
   ti = bi(1,j)
   br(1,j) = tr*pr - ti*pi
   bi(1,j) = tr*pi + ti*pr
end do
end subroutine dcsol

subroutine dcminv(ar, ai, ka, n, ipvt, temp)
implicit none
integer, intent(in) :: ka
integer :: n
double precision, intent(inout) :: ar(ka,n), ai(ka,n), temp(2,n)
integer, intent(in) :: ipvt(n)
integer :: i, ip1, j, jb, k, kp1, l, nm1, nmi, nmk, np1
double precision :: sr, si, tr, ti
interface
   pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
      implicit none
      double precision, intent(in) :: ar
      double precision, intent(in) :: ai
      double precision, intent(in) :: br
      double precision, intent(in) :: bi
      double precision, intent(inout) :: cr
      double precision, intent(inout) :: ci
   end subroutine cdivid
end interface
!-----------------------------------------------------------------------
!     Computation of the inverse of A matrix A using the LU
!     decomposition obtained by dcfact. This routine CANNOT
!     be used when dcfact terminates with nonzero IERR.
!-----------------------------------------------------------------------
!     Input ...
!        ar and ai contain the LU decomposition of the matrix
!        obtained by dcfact.
!        ka = Declared row dimension of the arrays ar and ai
!        n  = Order of the matrix
!        ipvt = Pivot vector obtained from dcfact
!        temp = Temporary storage area for the subroutine
!     output ...
!        ar and ai contain the inverse of the matrix.
!-----------------------------------------------------------------------
call cdivid(1.d0, 0.d0, ar(n,n), ai(n,n), ar(n,n), ai(n,n))
if (n == 1) return
np1 = n + 1
nm1 = n - 1
!                Replace U with the inverse of U
do nmi = 1,nm1
   i = n - nmi
   ip1 = i + 1
   call cdivid(1.d0, 0.d0, ar(i,i), ai(i,i), tr, ti)
   do jb = 1,nmi
      j = np1 - jb
      sr = 0.d0
      si = 0.d0
      do l = ip1,j
         sr = sr + ar(i,l)*ar(l,j) - ai(i,l)*ai(l,j)
         si = si + ar(i,l)*ai(l,j) + ai(i,l)*ar(l,j)
      end do
      ar(i,j) = -sr*tr + si*ti
      ai(i,j) = -sr*ti - si*tr
   end do
   ar(i,i) = tr
   ai(i,i) = ti
end do
!                Compute  inverse(U)*inverse(l)
do nmk = 1,nm1
   k = n - nmk
   kp1 = k + 1
   do i = kp1,n
      temp(1,i) = ar(i,k)
      temp(2,i) = ai(i,k)
      ar(i,k) = 0.d0
      ai(i,k) = 0.d0
   end do
   do j = kp1,n
      tr = temp(1,j)
      ti = temp(2,j)
      do i = 1,n
         ar(i,k) = ar(i,k) - ar(i,j)*tr + ai(i,j)*ti
         ai(i,k) = ai(i,k) - ar(i,j)*ti - ai(i,j)*tr
      end do
   end do
   l = ipvt(k)
   if (k == l) go to 60
   do i = 1,n
      tr = ar(i,k)
      ar(i,k) = ar(i,l)
      ar(i,l) = tr
      ti = ai(i,k)
      ai(i,k) = ai(i,l)
      ai(i,l) = ti
   end do
60 continue
end do
end subroutine dcminv

pure subroutine ssvdc(x,ldx,n,p,s,e,u,ldu,v,ldv,work,job,info)
implicit none
integer, intent(in) :: ldx, n, p, ldu, ldv, job
integer, intent(inout) :: info
real, intent(inout) :: x(ldx,*), s(*), e(*), u(ldu,*), v(ldv,*), &
   & work(*)
integer :: i, iter, j, jobu, k, kase, kk, l, ll, lls, lm1, lp1, &
   & ls, lu, m, maxit, mm, mm1, mp1, nct, nctp1, ncu, nrt, nrtp1
real :: t, b, c, cs, el, emm1, f, g, scale, shift, sl, sm, sn, smm1, t1, test, ztest
logical :: wantu, wantv
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
   pure function snrm2(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: snrm2
   end function snrm2
   pure subroutine srot(n,sx,incx,sy,incy,c,s)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
      real, intent(in) :: c
      real, intent(in) :: s
   end subroutine srot
   pure elemental subroutine srotg(sa,sb,sc,ss)
      implicit none
      real, intent(inout) :: sa
      real, intent(inout) :: sb
      real, intent(inout) :: sc
      real, intent(inout) :: ss
   end subroutine srotg
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
   pure subroutine sswap(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine sswap
end interface
!     ssvdc is a subroutine to reduce a real NXP matrix x by
!     orthogonal transformations u and v to diagonal form.  The
!     diagonal elements s(i) are the singular values of x.  the
!     columns of u are the corresponding left singular vectors,
!     and the columns of v the right singular vectors.
!     On entry
!         x         real(ldx,p), WHERE ldx.GE.N.
!                   x contains the matrix whose singular value
!                   decomposition is to be computed.  x is
!                   destroyed by ssvdc.
!         ldx       INTEGER.
!                   ldx is the leading dimension of the array x.
!         n         INTEGER.
!                   n is the number of rows of the matrix x.
!         p         INTEGER.
!                   p is the number of columns of the matrix x.
!         ldu       INTEGER.
!                   ldu is the leading dimension of the array u.
!                   (See below).
!         ldv       INTEGER.
!                   ldv is the leading dimension of the array v.
!                   (See below).
!         WORK      real(n).
!                   Work is a scratch array.
!         JOB       INTEGER.
!                   Job controls the computation of the singular
!                   vectors.  It has the decimal expansion AB
!                   with the following meaning
!                        A.EQ.0    do not compute the left singular
!                                  vectors.
!                        A.EQ.1    return the n left singular vectors
!                                  in u.
!                        A.GE.2    return the first min(n,p) singular
!                                  vectors in u.
!                        b.EQ.0    do not compute the right singular
!                                  vectors.
!                        b.EQ.1    return the right singular vectors
!                                  in v.
!     On return
!         s         real(MM), WHERE MM=min(n+1,p).
!                   The first min(n,p) entries of s contain the
!                   singular values of x arranged in descending
!                   order of magnitude.
!         e         real(p).
!                   e ordinarily contains zeros.  However see the
!                   discussion of info for exceptions.
!         u         real(ldu,k), WHERE ldu.GE.N.  IF JOBA.EQ.1 THEN
!                                   k.EQ.n, IF JOBA.GE.2 THEN
!                                   k.EQ.min(n,p).
!                   u contains the matrix of left singular vectors.
!                   u is not referenced if JOBA.EQ.0.  if n.LE.p
!                   or if JOBA.EQ.2, then u may be identified with x
!                   in the subroutine CALL.
!         v         real(ldv,p), WHERE ldv.GE.P.
!                   v contains the matrix of right singular vectors.
!                   v is not referenced if job.EQ.0.  if p.LE.n,
!                   then v may be identified with x in the
!                   subroutine CALL.
!         INFO      INTEGER.
!                   The singular values (and their corresponding
!                   singular vectors) s(info+1),s(info+2),...,s(M)
!                   are correct (here M=min(n,p)).  Thus if
!                   info.EQ.0, all the singular values and their
!                   vectors are correct.  In any event, the matrix
!                   b = Trans(u)*x*v is the bidiagonal matrix
!                   with the elements of s on its diagonal and the
!                   elements of e on its super-diagonal (trans(u)
!                   is the transpose of u).  Thus the singular
!                   values of x and b are the same.
!     LINPACK. This version dated 03/19/79 .
!     G.W. Stewart, university of maryland, Argonne National Lab.
!     ***** Uses the following functions and subprograms.
!     external srot
!     BLAS saxpy,sdot,sscal,sswap,snrm2,srotg
!     Fortran abs,AMAX1,MAX0,MIN0,mod,sqrt
!     internal variables
!     set the maximum number of iterations.
maxit = 30
!     Determine what is to be computed.
wantu = .false.
wantv = .false.
jobu = mod(job,100)/10
ncu = n
if (jobu > 1) ncu = min(n,p)
if (jobu /= 0) wantu = .true.
if (mod(job,10) /= 0) wantv = .true.
!     Reduce x to bidiagonal form, storing the diagonal elements
!     in s and the super-diagonal elements in e.
info = 0
nct = min(n - 1,p)
nrt = max(0,min(p - 2,n))
lu = max(nct,nrt)
if (lu < 1) go to 170
do l = 1, lu
   lp1 = l + 1
   if (l > nct) go to 20
!           Compute the transformation for the l-TH column and
!           place the l-TH diagonal in s(l).
   s(l) = snrm2(n - l + 1,x(l,l),1)
   if (s(l) == 0.0e0) go to 10
   if (x(l,l) /= 0.0e0) s(l) = sign(s(l),x(l,l))
   call sscal(n - l + 1,1.0e0/s(l),x(l,l),1)
   x(l,l) = 1.0e0 + x(l,l)
10 continue
   s(l) = -s(l)
20 continue
   if (p < lp1) go to 50
   do j = lp1, p
      if (l > nct) go to 30
      if (s(l) == 0.0e0) go to 30
!              Apply the transformation.
      t = -sdot(n - l + 1,x(l,l),1,x(l,j),1)/x(l,l)
      call saxpy(n - l + 1,t,x(l,l),1,x(l,j),1)
30    continue
!           Place the l-TH row of x into  e for the
!           subsequent calculation of the row transformation.
      e(j) = x(l,j)
   end do
50 continue
   if (.not.wantu .or. l > nct) go to 70
!           Place the transformation in u for subsequent back
!           multiplication.
   do i = l, n
      u(i,l) = x(i,l)
   end do
70 continue
   if (l > nrt) go to 150
!           Compute the l-TH row transformation and place the
!           l-TH super-diagonal in e(l).
   e(l) = snrm2(p - l,e(lp1),1)
   if (e(l) == 0.0e0) go to 80
   if (e(lp1) /= 0.0e0) e(l) = sign(e(l),e(lp1))
   call sscal(p - l,1.0e0/e(l),e(lp1),1)
   e(lp1) = 1.0e0 + e(lp1)
80 continue
   e(l) = -e(l)
   if (lp1 > n .or. e(l) == 0.0e0) go to 120
!              Apply the transformation.
   do i = lp1, n
      work(i) = 0.0e0
   end do
   do j = lp1, p
      call saxpy(n - l,e(j),x(lp1,j),1,work(lp1),1)
   end do
   do j = lp1, p
      call saxpy(n - l,-e(j)/e(lp1),work(lp1),1,x(lp1,j),1)
   end do
120 continue
   if (.not.wantv) go to 140
!              Place the transformation in v for subsequent
!              back multiplication.
   do i = lp1, p
      v(i,l) = e(i)
   end do
140 continue
150 continue
end do
170 continue
!     Set up the final bidiagonal matrix of order M.
m = min(p,n + 1)
nctp1 = nct + 1
nrtp1 = nrt + 1
if (nct < p) s(nctp1) = x(nctp1,nctp1)
if (n < m) s(m) = 0.0e0
if (nrtp1 < m) e(nrtp1) = x(nrtp1,m)
e(m) = 0.0e0
!     If required, generate u.
if (.not.wantu) go to 300
if (ncu < nctp1) go to 200
do j = nctp1, ncu
   do i = 1, n
      u(i,j) = 0.0e0
   end do
   u(j,j) = 1.0e0
end do
200 continue
if (nct < 1) go to 290
do ll = 1, nct
   l = nct - ll + 1
   if (s(l) == 0.0e0) go to 250
   lp1 = l + 1
   if (ncu < lp1) go to 220
   do j = lp1, ncu
      t = -sdot(n - l + 1,u(l,l),1,u(l,j),1)/u(l,l)
      call saxpy(n - l + 1,t,u(l,l),1,u(l,j),1)
   end do
220 continue
   call sscal(n - l + 1,-1.0e0,u(l,l),1)
   u(l,l) = 1.0e0 + u(l,l)
   lm1 = l - 1
   if (lm1 < 1) go to 240
   do i = 1, lm1
      u(i,l) = 0.0e0
   end do
240 continue
   go to 270
250 continue
   do i = 1, n
      u(i,l) = 0.0e0
   end do
   u(l,l) = 1.0e0
270 continue
end do
290 continue
300 continue
!     If it is required, generate v.
if (.not.wantv) go to 350
do ll = 1, p
   l = p - ll + 1
   lp1 = l + 1
   if (l > nrt) go to 320
   if (e(l) == 0.0e0) go to 320
   do j = lp1, p
      t = -sdot(p - l,v(lp1,l),1,v(lp1,j),1)/v(lp1,l)
      call saxpy(p - l,t,v(lp1,l),1,v(lp1,j),1)
   end do
320 continue
   do i = 1, p
      v(i,l) = 0.0e0
   end do
   v(l,l) = 1.0e0
end do
350 continue
!     Main iteration loop for the singular values.
mm = m
iter = 0
360 continue
!        Quit if all the singular values have been found.
!     ...Exit
if (m == 0) go to 620
!        If too many iterations have been performed, set
!        flag and return.
if (iter < maxit) go to 370
info = m
!     ......Exit
go to 620
370 continue
!        This section of the program inspects for
!        negligible elements in the s and e arrays.  On
!        completion the variables kase and l are set as follows.
!           kase = 1     If s(M) and e(l-1) are negligible and l.LT.M
!           kase = 2     If s(l) is negligible and l.LT.M
!           kase = 3     If e(l-1) is negligible, l.LT.M, and
!                        s(l), ..., s(M) are not negligible (QR step).
!           kase = 4     If e(M-1) is negligible (convergence).
do ll = 1, m
   l = m - ll
!        ...Exit
   if ( l == 0 ) exit
   test = abs(s(l)) + abs(s(l + 1))
   ztest = test + abs(e(l))
   if (ztest /= test) go to 380
   e(l) = 0.0e0
!        ......Exit
   exit
380 continue
end do
if (l /= m - 1) go to 410
kase = 4
go to 480
410 continue
lp1 = l + 1
mp1 = m + 1
do lls = lp1, mp1
   ls = m - lls + lp1
!           ...Exit
   if ( ls == l ) exit
   test = 0.0e0
   if (ls /= m) test = test + abs(e(ls))
   if (ls /= l + 1) test = test + abs(e(ls - 1))
   ztest = test + abs(s(ls))
   if (ztest /= test) go to 420
   s(ls) = 0.0e0
!           ......Exit
   exit
420 continue
end do
if (ls /= l) go to 450
kase = 3
go to 470
450 continue
if (ls /= m) go to 460
kase = 1
go to 470
460 continue
kase = 2
l = ls
470 continue
480 continue
l = l + 1
!        Perform the task indicated by kase.
select case (kase)
case (1)
   go to 490
case (2)
   go to 520
case (3)
   go to 540
case (4)
   go to 570
end select
!        Deflate negligible s(M).
490 continue
mm1 = m - 1
f = e(m - 1)
e(m - 1) = 0.0e0
do kk = l, mm1
   k = mm1 - kk + l
   t1 = s(k)
   call srotg(t1,f,cs,sn)
   s(k) = t1
   if (k == l) go to 500
   f = -sn*e(k - 1)
   e(k - 1) = cs*e(k - 1)
500 continue
   if (wantv) call srot(p,v(1,k),1,v(1,m),1,cs,sn)
end do
go to 610
!        Split at negligible s(l).
520 continue
f = e(l - 1)
e(l - 1) = 0.0e0
do k = l, m
   t1 = s(k)
   call srotg(t1,f,cs,sn)
   s(k) = t1
   f = -sn*e(k)
   e(k) = cs*e(k)
   if (wantu) call srot(n,u(1,k),1,u(1,l - 1),1,cs,sn)
end do
go to 610
!        Perform one QR step.
540 continue
!           Calculate the shift.
scale = max(abs(s(m)),abs(s(m - 1)),abs(e(m - 1)),abs(s(l)), &
   & abs(e(l)))
sm = s(m)/scale
smm1 = s(m - 1)/scale
emm1 = e(m - 1)/scale
sl = s(l)/scale
el = e(l)/scale
b = ((smm1 + sm)*(smm1 - sm) + emm1**2)/2.0e0
c = (sm*emm1)**2
shift = 0.0e0
if (b == 0.0e0 .and. c == 0.0e0) go to 550
shift = sqrt(b**2 + c)
if (b < 0.0e0) shift = -shift
shift = c/(b + shift)
550 continue
f = (sl + sm)*(sl - sm) - shift
g = sl*el
!           Chase zeros.
mm1 = m - 1
do k = l, mm1
   call srotg(f,g,cs,sn)
   if (k /= l) e(k - 1) = f
   f = cs*s(k) + sn*e(k)
   e(k) = cs*e(k) - sn*s(k)
   g = sn*s(k + 1)
   s(k + 1) = cs*s(k + 1)
   if (wantv) call srot(p,v(1,k),1,v(1,k + 1),1,cs,sn)
   call srotg(f,g,cs,sn)
   s(k) = f
   f = cs*e(k) + sn*s(k + 1)
   s(k + 1) = -sn*e(k) + cs*s(k + 1)
   g = sn*e(k + 1)
   e(k + 1) = cs*e(k + 1)
   if (wantu .and. k < n) &
      & call srot(n,u(1,k),1,u(1,k + 1),1,cs,sn)
end do
e(m - 1) = f
iter = iter + 1
go to 610
!        Convergence.
570 continue
!           Make the singular value  positive.
if (s(l) >= 0.0e0) go to 580
s(l) = -s(l)
if (wantv) call sscal(p,-1.0e0,v(1,l),1)
580 continue
!           Order the singular value.
590 if (l == mm) go to 600
!           ...Exit
if (s(l) >= s(l + 1)) go to 600
t = s(l)
s(l) = s(l + 1)
s(l + 1) = t
if (wantv .and. l < p) &
   & call sswap(p,v(1,l),1,v(1,l + 1),1)
if (wantu .and. l < n) &
   & call sswap(n,u(1,l),1,u(1,l + 1),1)
l = l + 1
go to 590
600 continue
iter = 0
m = m - 1
610 continue
go to 360
620 continue
end subroutine ssvdc

pure subroutine dsvdc(x,ldx,n,p,s,e,u,ldu,v,ldv,work,job,info)
implicit none
integer, intent(in) :: ldx, n, p, ldu, ldv, job
integer, intent(inout) :: info
double precision, intent(inout) :: x(ldx,*), s(*), e(*), u(ldu,*), &
   & v(ldv,*), work(*)
integer :: i, iter, j, jobu, k, kase, kk, l, ll, lls, lm1, lp1, &
   & ls, lu, m, maxit, mm, mm1, mp1, nct, nctp1, ncu, nrt, nrtp1
double precision :: t, b, c, cs, el, emm1, f, g, scale, shift, sl, sm, sn, smm1, t1, test, ztest
logical :: wantu, wantv
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
   pure function dnrm2(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dnrm2
   end function dnrm2
   pure subroutine drot(n,dx,incx,dy,incy,c,s)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
      double precision, intent(in) :: c
      double precision, intent(in) :: s
   end subroutine drot
   pure elemental subroutine drotg(da,db,dc,ds)
      implicit none
      double precision, intent(inout) :: da
      double precision, intent(inout) :: db
      double precision, intent(inout) :: dc
      double precision, intent(inout) :: ds
   end subroutine drotg
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
end interface
!     dsvdc is a subroutine to reduce a double precision NXP matrix x
!     by orthogonal transformations u and V to diagonal form.  The
!     diagonal elements s(i) are the singular values of x.  the
!     columns of u are the corresponding left singular vectors,
!     and the columns of V the right singular vectors.
!     On entry
!         x         DOUBLE PRECISION(ldx,p), WHERE ldx.GE.N.
!                   x contains the matrix whose singular value
!                   decomposition is to be computed.  x is
!                   destroyed by dsvdc.
!         ldx       INTEGER.
!                   ldx is the leading dimension of the array x.
!         n         INTEGER.
!                   n is the number of rows of the matrix x.
!         p         INTEGER.
!                   p is the number of columns of the matrix x.
!         ldu       INTEGER.
!                   ldu is the leading dimension of the array u.
!                   (See below).
!         ldv       INTEGER.
!                   ldv is the leading dimension of the array V.
!                   (See below).
!         WORK      DOUBLE PRECISION(n).
!                   Work is a scratch array.
!         JOB       INTEGER.
!                   Job controls the computation of the singular
!                   vectors.  It has the decimal expansion AB
!                   with the following meaning
!                        A.EQ.0    do not compute the left singular
!                                  vectors.
!                        A.EQ.1    return the n left singular vectors
!                                  in u.
!                        A.GE.2    return the first min(n,p) singular
!                                  vectors in u.
!                        b.EQ.0    do not compute the right singular
!                                  vectors.
!                        b.EQ.1    return the right singular vectors
!                                  in V.
!     On return
!         s         DOUBLE PRECISION(MM), WHERE MM=min(n+1,p).
!                   The first min(n,p) entries of s contain the
!                   singular values of x arranged in descending
!                   order of magnitude.
!         e         DOUBLE PRECISION(p).
!                   e ordinarily contains zeros.  However see the
!                   discussion of info for exceptions.
!         u         DOUBLE PRECISION(ldu,k), WHERE ldu.GE.N.  IF
!                                   JOBA.EQ.1 THEN k.EQ.n, IF JOBA.GE.2
!                                   THEN k.EQ.min(n,p).
!                   u contains the matrix of left singular vectors.
!                   u is not referenced if JOBA.EQ.0.  if n.LE.p
!                   or if JOBA.EQ.2, then u may be identified with x
!                   in the subroutine CALL.
!         V         DOUBLE PRECISION(ldv,p), WHERE ldv.GE.P.
!                   V contains the matrix of right singular vectors.
!                   V is not referenced if job.EQ.0.  if p.LE.n,
!                   then V may be identified with x in the
!                   subroutine CALL.
!         INFO      INTEGER.
!                   The singular values (and their corresponding
!                   singular vectors) s(info+1),s(info+2),...,s(M)
!                   are correct (here M=min(n,p)).  Thus if
!                   info.EQ.0, all the singular values and their
!                   vectors are correct.  In any event, the matrix
!                   b = Trans(u)*x*V is the bidiagonal matrix
!                   with the elements of s on its diagonal and the
!                   elements of e on its super-diagonal (trans(u)
!                   is the transpose of u).  Thus the singular
!                   values of x and b are the same.
!     LINPACK. This version dated 03/19/79 .
!     G.W. Stewart, university of maryland, Argonne National Lab.
!     dsvdc uses the following functions and subprograms.
!     external drot
!     BLAS daxpy,ddot,dscal,dswap,dnrm2,drotg
!     Fortran dabs,DMAX1,MAX0,MIN0,mod,DSQRT
!     internal variables
!     set the maximum number of iterations.
maxit = 30
!     Determine what is to be computed.
wantu = .false.
wantv = .false.
jobu = mod(job,100)/10
ncu = n
if (jobu > 1) ncu = min(n,p)
if (jobu /= 0) wantu = .true.
if (mod(job,10) /= 0) wantv = .true.
!     Reduce x to bidiagonal form, storing the diagonal elements
!     in s and the super-diagonal elements in e.
info = 0
nct = min(n - 1,p)
nrt = max(0,min(p - 2,n))
lu = max(nct,nrt)
if (lu < 1) go to 170
do l = 1, lu
   lp1 = l + 1
   if (l > nct) go to 20
!           Compute the transformation for the l-TH column and
!           place the l-TH diagonal in s(l).
   s(l) = dnrm2(n - l + 1,x(l,l),1)
   if (s(l) == 0.0d0) go to 10
   if (x(l,l) /= 0.0d0) s(l) = sign(s(l),x(l,l))
   call dscal(n - l + 1,1.0d0/s(l),x(l,l),1)
   x(l,l) = 1.0d0 + x(l,l)
10 continue
   s(l) = -s(l)
20 continue
   if (p < lp1) go to 50
   do j = lp1, p
      if (l > nct) go to 30
      if (s(l) == 0.0d0) go to 30
!              Apply the transformation.
      t = -ddot(n - l + 1,x(l,l),1,x(l,j),1)/x(l,l)
      call daxpy(n - l + 1,t,x(l,l),1,x(l,j),1)
30    continue
!           Place the l-TH row of x into  e for the
!           subsequent calculation of the row transformation.
      e(j) = x(l,j)
   end do
50 continue
   if (.not.wantu .or. l > nct) go to 70
!           Place the transformation in u for subsequent back
!           multiplication.
   do i = l, n
      u(i,l) = x(i,l)
   end do
70 continue
   if (l > nrt) go to 150
!           Compute the l-TH row transformation and place the
!           l-TH super-diagonal in e(l).
   e(l) = dnrm2(p - l,e(lp1),1)
   if (e(l) == 0.0d0) go to 80
   if (e(lp1) /= 0.0d0) e(l) = sign(e(l),e(lp1))
   call dscal(p - l,1.0d0/e(l),e(lp1),1)
   e(lp1) = 1.0d0 + e(lp1)
80 continue
   e(l) = -e(l)
   if (lp1 > n .or. e(l) == 0.0d0) go to 120
!              Apply the transformation.
   do i = lp1, n
      work(i) = 0.0d0
   end do
   do j = lp1, p
      call daxpy(n - l,e(j),x(lp1,j),1,work(lp1),1)
   end do
   do j = lp1, p
      call daxpy(n - l,-e(j)/e(lp1),work(lp1),1,x(lp1,j),1)
   end do
120 continue
   if (.not.wantv) go to 140
!              Place the transformation in V for subsequent
!              back multiplication.
   do i = lp1, p
      v(i,l) = e(i)
   end do
140 continue
150 continue
end do
170 continue
!     Set up the final bidiagonal matrix of order M.
m = min(p,n + 1)
nctp1 = nct + 1
nrtp1 = nrt + 1
if (nct < p) s(nctp1) = x(nctp1,nctp1)
if (n < m) s(m) = 0.0d0
if (nrtp1 < m) e(nrtp1) = x(nrtp1,m)
e(m) = 0.0d0
!     If required, generate u.
if (.not.wantu) go to 300
if (ncu < nctp1) go to 200
do j = nctp1, ncu
   do i = 1, n
      u(i,j) = 0.0d0
   end do
   u(j,j) = 1.0d0
end do
200 continue
if (nct < 1) go to 290
do ll = 1, nct
   l = nct - ll + 1
   if (s(l) == 0.0d0) go to 250
   lp1 = l + 1
   if (ncu < lp1) go to 220
   do j = lp1, ncu
      t = -ddot(n - l + 1,u(l,l),1,u(l,j),1)/u(l,l)
      call daxpy(n - l + 1,t,u(l,l),1,u(l,j),1)
   end do
220 continue
   call dscal(n - l + 1,-1.0d0,u(l,l),1)
   u(l,l) = 1.0d0 + u(l,l)
   lm1 = l - 1
   if (lm1 < 1) go to 240
   do i = 1, lm1
      u(i,l) = 0.0d0
   end do
240 continue
   go to 270
250 continue
   do i = 1, n
      u(i,l) = 0.0d0
   end do
   u(l,l) = 1.0d0
270 continue
end do
290 continue
300 continue
!     If it is required, generate V.
if (.not.wantv) go to 350
do ll = 1, p
   l = p - ll + 1
   lp1 = l + 1
   if (l > nrt) go to 320
   if (e(l) == 0.0d0) go to 320
   do j = lp1, p
      t = -ddot(p - l,v(lp1,l),1,v(lp1,j),1)/v(lp1,l)
      call daxpy(p - l,t,v(lp1,l),1,v(lp1,j),1)
   end do
320 continue
   do i = 1, p
      v(i,l) = 0.0d0
   end do
   v(l,l) = 1.0d0
end do
350 continue
!     Main iteration loop for the singular values.
mm = m
iter = 0
360 continue
!        Quit if all the singular values have been found.
!     ...Exit
if (m == 0) go to 620
!        If too many iterations have been performed, set
!        flag and return.
if (iter < maxit) go to 370
info = m
!     ......Exit
go to 620
370 continue
!        This section of the program inspects for
!        negligible elements in the s and e arrays.  On
!        completion the variables kase and l are set as follows.
!           kase = 1     If s(M) and e(l-1) are negligible and l.LT.M
!           kase = 2     If s(l) is negligible and l.LT.M
!           kase = 3     If e(l-1) is negligible, l.LT.M, and
!                        s(l), ..., s(M) are not negligible (QR step).
!           kase = 4     If e(M-1) is negligible (convergence).
do ll = 1, m
   l = m - ll
!        ...Exit
   if ( l == 0 ) exit
   test = abs(s(l)) + abs(s(l + 1))
   ztest = test + abs(e(l))
   if (ztest /= test) go to 380
   e(l) = 0.0d0
!        ......Exit
   exit
380 continue
end do
if (l /= m - 1) go to 410
kase = 4
go to 480
410 continue
lp1 = l + 1
mp1 = m + 1
do lls = lp1, mp1
   ls = m - lls + lp1
!           ...Exit
   if ( ls == l ) exit
   test = 0.0d0
   if (ls /= m) test = test + abs(e(ls))
   if (ls /= l + 1) test = test + abs(e(ls - 1))
   ztest = test + abs(s(ls))
   if (ztest /= test) go to 420
   s(ls) = 0.0d0
!           ......Exit
   exit
420 continue
end do
if (ls /= l) go to 450
kase = 3
go to 470
450 continue
if (ls /= m) go to 460
kase = 1
go to 470
460 continue
kase = 2
l = ls
470 continue
480 continue
l = l + 1
!        Perform the task indicated by kase.
select case (kase)
case (1)
   go to 490
case (2)
   go to 520
case (3)
   go to 540
case (4)
   go to 570
end select
!        Deflate negligible s(M).
490 continue
mm1 = m - 1
f = e(m - 1)
e(m - 1) = 0.0d0
do kk = l, mm1
   k = mm1 - kk + l
   t1 = s(k)
   call drotg(t1,f,cs,sn)
   s(k) = t1
   if (k == l) go to 500
   f = -sn*e(k - 1)
   e(k - 1) = cs*e(k - 1)
500 continue
   if (wantv) call drot(p,v(1,k),1,v(1,m),1,cs,sn)
end do
go to 610
!        Split at negligible s(l).
520 continue
f = e(l - 1)
e(l - 1) = 0.0d0
do k = l, m
   t1 = s(k)
   call drotg(t1,f,cs,sn)
   s(k) = t1
   f = -sn*e(k)
   e(k) = cs*e(k)
   if (wantu) call drot(n,u(1,k),1,u(1,l - 1),1,cs,sn)
end do
go to 610
!        Perform one QR step.
540 continue
!           Calculate the shift.
scale = max(abs(s(m)),abs(s(m - 1)),abs(e(m - 1)), &
   & abs(s(l)),abs(e(l)))
sm = s(m)/scale
smm1 = s(m - 1)/scale
emm1 = e(m - 1)/scale
sl = s(l)/scale
el = e(l)/scale
b = ((smm1 + sm)*(smm1 - sm) + emm1**2)/2.0d0
c = (sm*emm1)**2
shift = 0.0d0
if (b == 0.0d0 .and. c == 0.0d0) go to 550
shift = sqrt(b**2 + c)
if (b < 0.0d0) shift = -shift
shift = c/(b + shift)
550 continue
f = (sl + sm)*(sl - sm) - shift
g = sl*el
!           Chase zeros.
mm1 = m - 1
do k = l, mm1
   call drotg(f,g,cs,sn)
   if (k /= l) e(k - 1) = f
   f = cs*s(k) + sn*e(k)
   e(k) = cs*e(k) - sn*s(k)
   g = sn*s(k + 1)
   s(k + 1) = cs*s(k + 1)
   if (wantv) call drot(p,v(1,k),1,v(1,k + 1),1,cs,sn)
   call drotg(f,g,cs,sn)
   s(k) = f
   f = cs*e(k) + sn*s(k + 1)
   s(k + 1) = -sn*e(k) + cs*s(k + 1)
   g = sn*e(k + 1)
   e(k + 1) = cs*e(k + 1)
   if (wantu .and. k < n) &
      & call drot(n,u(1,k),1,u(1,k + 1),1,cs,sn)
end do
e(m - 1) = f
iter = iter + 1
go to 610
!        Convergence.
570 continue
!           Make the singular value  positive.
if (s(l) >= 0.0d0) go to 580
s(l) = -s(l)
if (wantv) call dscal(p,-1.0d0,v(1,l),1)
580 continue
!           Order the singular value.
590 if (l == mm) go to 600
!           ...Exit
if (s(l) >= s(l + 1)) go to 600
t = s(l)
s(l) = s(l + 1)
s(l + 1) = t
if (wantv .and. l < p) &
   & call dswap(p,v(1,l),1,v(1,l + 1),1)
if (wantu .and. l < n) &
   & call dswap(n,u(1,l),1,u(1,l + 1),1)
l = l + 1
go to 590
600 continue
iter = 0
m = m - 1
610 continue
go to 360
620 continue
end subroutine dsvdc

pure subroutine csvdc(x,ldx,n,p,s,e,u,ldu,v,ldv,work,job,info)
implicit none
integer, intent(in) :: ldx, n, p, ldu, ldv, job
integer, intent(inout) :: info
complex, intent(inout) :: x(ldx,*), s(*), e(*), u(ldu,*), &
   & v(ldv,*), work(*)
integer :: i, iter, j, jobu, k, kase, kk, l, ll, lls, lm1, lp1, &
   & ls, lu, m, maxit, mm, mm1, mp1, nct, nctp1, ncu, nrt, nrtp1
complex :: t, r
real :: b, c, cs, el, emm1, f, g, scale, shift, sl, sm, sn, smm1, t1, test, ztest
logical :: wantu, wantv
complex :: zdum, zdum1, zdum2
interface
   pure subroutine caxpy(n,ca,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: ca
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(inout) :: cy(*)
      integer, intent(in) :: incy
   end subroutine caxpy
   pure function cdotc(n,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(in) :: cy(*)
      integer, intent(in) :: incy
      complex :: cdotc
   end function cdotc
   pure subroutine cscal(n,ca,cx,incx)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: ca
      complex, intent(inout) :: cx(*)
      integer, intent(in) :: incx
   end subroutine cscal
   pure subroutine csrot(n,cx,incx,cy,incy,c,s)
      implicit none
      integer, intent(in) :: n
      complex, intent(inout) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(inout) :: cy(*)
      integer, intent(in) :: incy
      real, intent(in) :: c
      real, intent(in) :: s
   end subroutine csrot
   pure subroutine cswap(n,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(inout) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(inout) :: cy(*)
      integer, intent(in) :: incy
   end subroutine cswap
   pure function scnrm2(n,cx,incx)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      real :: scnrm2
   end function scnrm2
   pure elemental subroutine srotg(sa,sb,sc,ss)
      implicit none
      real, intent(inout) :: sa
      real, intent(inout) :: sb
      real, intent(inout) :: sc
      real, intent(inout) :: ss
   end subroutine srotg
end interface
!     csvdc is a subroutine to reduce a complex NXP matrix x by
!     unitary transformations u and V to diagonal form.  The
!     diagonal elements s(i) are the singular values of x.  the
!     columns of u are the corresponding left singular vectors,
!     and the columns of V the right singular vectors.
!     On entry
!         x         COMPLEX(ldx,p), WHERE ldx.GE.N.
!                   x contains the matrix whose singular value
!                   decomposition is to be computed.  x is
!                   destroyed by csvdc.
!         ldx       INTEGER.
!                   ldx is the leading dimension of the array x.
!         n         INTEGER.
!                   n is the number of rows of the matrix x.
!         p         INTEGER.
!                   p is the number of columns of the matrix x.
!         ldu       INTEGER.
!                   ldu is the leading dimension of the array u
!                   (see below).
!         ldv       INTEGER.
!                   ldv is the leading dimension of the array V
!                   (see below).
!         WORK      COMPLEX(n).
!                   Work is a scratch array.
!         JOB       INTEGER.
!                   Job controls the computation of the singular
!                   vectors.  It has the decimal expansion AB
!                   with the following meaning
!                        A.EQ.0    do not compute the left singular
!                                  vectors.
!                        A.EQ.1    return the n left singular vectors
!                                  in u.
!                        A.GE.2    returns the first min(n,p)
!                                  left singular vectors in u.
!                        b.EQ.0    do not compute the right singular
!                                  vectors.
!                        b.EQ.1    return the right singular vectors
!                                  in V.
!     On return
!         s         COMPLEX(MM), WHERE MM=min(n+1,p).
!                   The first min(n,p) entries of s contain the
!                   singular values of x arranged in descending
!                   order of magnitude.
!         e         COMPLEX(p).
!                   e ordinarily contains zeros.  However see the
!                   discussion of info for exceptions.
!         u         COMPLEX(ldu,k), WHERE ldu.GE.N.  IF JOBA.EQ.1 THEN
!                                   k.EQ.n, IF JOBA.GE.2 THEN
!                                   k.EQ.min(n,p).
!                   u contains the matrix of left singular vectors.
!                   u is not referenced if JOBA.EQ.0.  if n.LE.p
!                   or if JOBA.GT.2, then u may be identified with x
!                   in the subroutine CALL.
!         V         COMPLEX(ldv,p), WHERE ldv.GE.P.
!                   V contains the matrix of right singular vectors.
!                   V is not referenced if JOBB.EQ.0.  if p.LE.n,
!                   then V may be identified whth x in the
!                   subroutine CALL.
!         INFO      INTEGER.
!                   The singular values (and their corresponding
!                   singular vectors) s(info+1),s(info+2),...,s(M)
!                   are correct (here M=min(n,p)).  Thus if
!                   info.EQ.0, all the singular values and their
!                   vectors are correct.  In any event, the matrix
!                   b = ctrans(u)*x*V is the bidiagonal matrix
!                   with the elements of s on its diagonal and the
!                   elements of e on its super-diagonal (ctrans(u)
!                   is the conjugate-transpose of u).  Thus the
!                   singular values of x and b are the same.
!     LINPACK. This version dated 03/19/79 .
!     G.W. Stewart, university of maryland, Argonne National Lab.
!     csvdc uses the following functions and subprograms.
!     external csrot
!     BLAS caxpy,cdotc,cscal,cswap,scnrm2,srotg
!     Fortran abs,aimag,AMAX1,cabs,cmplx
!     Fortran CONJG,MAX0,MIN0,mod,real,sqrt
!     internal variables
!     Set the maximum number of iterations.
maxit = 30
!     Determine what is to be computed.
wantu = .false.
wantv = .false.
jobu = mod(job,100)/10
ncu = n
if (jobu > 1) ncu = min(n,p)
if (jobu /= 0) wantu = .true.
if (mod(job,10) /= 0) wantv = .true.
!     Reduce x to bidiagonal form, storing the diagonal elements
!     in s and the super-diagonal elements in e.
info = 0
nct = min(n - 1,p)
nrt = max(0,min(p - 2,n))
lu = max(nct,nrt)
if (lu < 1) go to 170
do l = 1, lu
   lp1 = l + 1
   if (l > nct) go to 20
!           Compute the transformation for the l-TH column and
!           place the l-TH diagonal in s(l).
   s(l) = cmplx(scnrm2(n - l + 1,x(l,l),1),0.0e0)
   if (cabs1(s(l)) == 0.0e0) go to 10
   if (cabs1(x(l,l)) /= 0.0e0) s(l) = csign(s(l),x(l,l))
   call cscal(n - l + 1,1.0e0/s(l),x(l,l),1)
   x(l,l) = (1.0e0,0.0e0) + x(l,l)
10 continue
   s(l) = -s(l)
20 continue
   if (p < lp1) go to 50
   do j = lp1, p
      if (l > nct) go to 30
      if (cabs1(s(l)) == 0.0e0) go to 30
!              Apply the transformation.
      t = -cdotc(n - l + 1,x(l,l),1,x(l,j),1)/x(l,l)
      call caxpy(n - l + 1,t,x(l,l),1,x(l,j),1)
30    continue
!           Place the l-TH row of x into  e for the
!           subsequent calculation of the row transformation.
      e(j) = conjg(x(l,j))
   end do
50 continue
   if (.not.wantu .or. l > nct) go to 70
!           Place the transformation in u for subsequent back
!           multiplication.
   do i = l, n
      u(i,l) = x(i,l)
   end do
70 continue
   if (l > nrt) go to 150
!           Compute the l-TH row transformation and place the
!           l-TH super-diagonal in e(l).
   e(l) = cmplx(scnrm2(p - l,e(lp1),1),0.0e0)
   if (cabs1(e(l)) == 0.0e0) go to 80
   if (cabs1(e(lp1)) /= 0.0e0) e(l) = csign(e(l),e(lp1))
   call cscal(p - l,1.0e0/e(l),e(lp1),1)
   e(lp1) = (1.0e0,0.0e0) + e(lp1)
80 continue
   e(l) = -conjg(e(l))
   if (lp1 > n .or. cabs1(e(l)) == 0.0e0) go to 120
!              Apply the transformation.
   do i = lp1, n
      work(i) = (0.0e0,0.0e0)
   end do
   do j = lp1, p
      call caxpy(n - l,e(j),x(lp1,j),1,work(lp1),1)
   end do
   do j = lp1, p
      call caxpy(n - l,conjg(-e(j)/e(lp1)),work(lp1),1, &
         & x(lp1,j),1)
   end do
120 continue
   if (.not.wantv) go to 140
!              Place the transformation in V for subsequent
!              back multiplication.
   do i = lp1, p
      v(i,l) = e(i)
   end do
140 continue
150 continue
end do
170 continue
!     Set up the final bidiagonal matrix of order M.
m = min(p,n + 1)
nctp1 = nct + 1
nrtp1 = nrt + 1
if (nct < p) s(nctp1) = x(nctp1,nctp1)
if (n < m) s(m) = (0.0e0,0.0e0)
if (nrtp1 < m) e(nrtp1) = x(nrtp1,m)
e(m) = (0.0e0,0.0e0)
!     If required, generate u.
if (.not.wantu) go to 300
if (ncu < nctp1) go to 200
do j = nctp1, ncu
   do i = 1, n
      u(i,j) = (0.0e0,0.0e0)
   end do
   u(j,j) = (1.0e0,0.0e0)
end do
200 continue
if (nct < 1) go to 290
do ll = 1, nct
   l = nct - ll + 1
   if (cabs1(s(l)) == 0.0e0) go to 250
   lp1 = l + 1
   if (ncu < lp1) go to 220
   do j = lp1, ncu
      t = -cdotc(n - l + 1,u(l,l),1,u(l,j),1)/u(l,l)
      call caxpy(n - l + 1,t,u(l,l),1,u(l,j),1)
   end do
220 continue
   call cscal(n - l + 1,(-1.0e0,0.0e0),u(l,l),1)
   u(l,l) = (1.0e0,0.0e0) + u(l,l)
   lm1 = l - 1
   if (lm1 < 1) go to 240
   do i = 1, lm1
      u(i,l) = (0.0e0,0.0e0)
   end do
240 continue
   go to 270
250 continue
   do i = 1, n
      u(i,l) = (0.0e0,0.0e0)
   end do
   u(l,l) = (1.0e0,0.0e0)
270 continue
end do
290 continue
300 continue
!     If it is required, generate V.
if (.not.wantv) go to 350
do ll = 1, p
   l = p - ll + 1
   lp1 = l + 1
   if (l > nrt) go to 320
   if (cabs1(e(l)) == 0.0e0) go to 320
   do j = lp1, p
      t = -cdotc(p - l,v(lp1,l),1,v(lp1,j),1)/v(lp1,l)
      call caxpy(p - l,t,v(lp1,l),1,v(lp1,j),1)
   end do
320 continue
   do i = 1, p
      v(i,l) = (0.0e0,0.0e0)
   end do
   v(l,l) = (1.0e0,0.0e0)
end do
350 continue
!     Transform s and e so that they are real.
do i = 1, m
   if (cabs1(s(i)) == 0.0e0) go to 360
   t = cmplx(abs(s(i)),0.0e0)
   r = s(i)/t
   s(i) = t
   if (i < m) e(i) = e(i)/r
   if (wantu) call cscal(n,r,u(1,i),1)
360 continue
!     ...Exit
   if ( i == m ) exit
   if (cabs1(e(i)) == 0.0e0) go to 370
   t = cmplx(abs(e(i)),0.0e0)
   r = t/e(i)
   e(i) = t
   s(i + 1) = s(i + 1)*r
   if (wantv) call cscal(p,r,v(1,i + 1),1)
370 continue
end do
!     Main iteration loop for the singular values.
mm = m
iter = 0
400 continue
!        Quit if all the singular values have been found.
!     ...Exit
if (m == 0) go to 660
!        If too many iterations have been performed, set
!        flag and return.
if (iter < maxit) go to 410
info = m
!     ......Exit
go to 660
410 continue
!        This section of the program inspects for
!        negligible elements in the s and e arrays.  On
!        completion the variables kase and l are set as follows.
!           kase = 1     If s(M) and e(l-1) are negligible and l.LT.M
!           kase = 2     If s(l) is negligible and l.LT.M
!           kase = 3     If e(l-1) is negligible, l.LT.M, and
!                        s(l), ..., s(M) are not negligible (QR step).
!           kase = 4     If e(M-1) is negligible (convergence).
do ll = 1, m
   l = m - ll
!        ...Exit
   if ( l == 0 ) exit
   test = abs(s(l)) + abs(s(l + 1))
   ztest = test + abs(e(l))
   if (ztest /= test) go to 420
   e(l) = (0.0e0,0.0e0)
!        ......Exit
   exit
420 continue
end do
if (l /= m - 1) go to 450
kase = 4
go to 520
450 continue
lp1 = l + 1
mp1 = m + 1
do lls = lp1, mp1
   ls = m - lls + lp1
!           ...Exit
   if ( ls == l ) exit
   test = 0.0e0
   if (ls /= m) test = test + abs(e(ls))
   if (ls /= l + 1) test = test + abs(e(ls - 1))
   ztest = test + abs(s(ls))
   if (ztest /= test) go to 460
   s(ls) = (0.0e0,0.0e0)
!           ......Exit
   exit
460 continue
end do
if (ls /= l) go to 490
kase = 3
go to 510
490 continue
if (ls /= m) go to 500
kase = 1
go to 510
500 continue
kase = 2
l = ls
510 continue
520 continue
l = l + 1
!        Perform the task indicated by kase.
select case (kase)
case (1)
   go to 530
case (2)
   go to 560
case (3)
   go to 580
case (4)
   go to 610
end select
!        Deflate negligible s(M).
530 continue
mm1 = m - 1
f = real(e(m - 1))
e(m - 1) = (0.0e0,0.0e0)
do kk = l, mm1
   k = mm1 - kk + l
   t1 = real(s(k))
   call srotg(t1,f,cs,sn)
   s(k) = cmplx(t1,0.0e0)
   if (k == l) go to 540
   f = -sn*real(e(k - 1))
   e(k - 1) = cs*e(k - 1)
540 continue
   if (wantv) call csrot(p,v(1,k),1,v(1,m),1,cs,sn)
end do
go to 650
!        Split at negligible s(l).
560 continue
f = real(e(l - 1))
e(l - 1) = (0.0e0,0.0e0)
do k = l, m
   t1 = real(s(k))
   call srotg(t1,f,cs,sn)
   s(k) = cmplx(t1,0.0e0)
   f = -sn*real(e(k))
   e(k) = cs*e(k)
   if (wantu) call csrot(n,u(1,k),1,u(1,l - 1),1,cs,sn)
end do
go to 650
!        Perform one QR step.
580 continue
!           Calculate the shift.
scale = max(abs(s(m)),abs(s(m - 1)),abs(e(m - 1)), &
   & abs(s(l)),abs(e(l)))
sm = real(s(m))/scale
smm1 = real(s(m - 1))/scale
emm1 = real(e(m - 1))/scale
sl = real(s(l))/scale
el = real(e(l))/scale
b = ((smm1 + sm)*(smm1 - sm) + emm1**2)/2.0e0
c = (sm*emm1)**2
shift = 0.0e0
if (b == 0.0e0 .and. c == 0.0e0) go to 590
shift = sqrt(b**2 + c)
if (b < 0.0e0) shift = -shift
shift = c/(b + shift)
590 continue
f = (sl + sm)*(sl - sm) - shift
g = sl*el
!           Chase zeros.
mm1 = m - 1
do k = l, mm1
   call srotg(f,g,cs,sn)
   if (k /= l) e(k - 1) = cmplx(f,0.0e0)
   f = cs*real(s(k)) + sn*real(e(k))
   e(k) = cs*e(k) - sn*s(k)
   g = sn*real(s(k + 1))
   s(k + 1) = cs*s(k + 1)
   if (wantv) call csrot(p,v(1,k),1,v(1,k + 1),1,cs,sn)
   call srotg(f,g,cs,sn)
   s(k) = cmplx(f,0.0e0)
   f = cs*real(e(k)) + sn*real(s(k + 1))
   s(k + 1) = -sn*e(k) + cs*s(k + 1)
   g = sn*real(e(k + 1))
   e(k + 1) = cs*e(k + 1)
   if (wantu .and. k < n) &
      & call csrot(n,u(1,k),1,u(1,k + 1),1,cs,sn)
end do
e(m - 1) = cmplx(f,0.0e0)
iter = iter + 1
go to 650
!        Convergence.
610 continue
!           Make the singular value  positive
if (real(s(l)) >= 0.0e0) go to 620
s(l) = -s(l)
if (wantv) call cscal(p,(-1.0e0,0.0e0),v(1,l),1)
620 continue
!           Order the singular value.
630 if (l == mm) go to 640
!           ...Exit
if (real(s(l)) >= real(s(l + 1))) go to 640
t = s(l)
s(l) = s(l + 1)
s(l + 1) = t
if (wantv .and. l < p) &
   & call cswap(p,v(1,l),1,v(1,l + 1),1)
if (wantu .and. l < n) &
   & call cswap(n,u(1,l),1,u(1,l + 1),1)
l = l + 1
go to 630
640 continue
iter = 0
m = m - 1
650 continue
go to 400
660 continue
contains
   pure function cabs1(zdum) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum
      real :: nswc_sf_result
      nswc_sf_result = abs(real(zdum)) + abs(aimag(zdum))
   end function cabs1
   pure function csign(zdum1, zdum2) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum1
      complex, intent(in) :: zdum2
      complex :: nswc_sf_result
      nswc_sf_result = abs(zdum1)*(zdum2/abs(zdum2))
   end function csign
end subroutine csvdc

function det(a,ka,n,x)
implicit none
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n)
real, intent(in) :: x
integer :: i, j, k, kp1, l, nm1
real :: c, pivot, s
real :: det
!     -------------------
!     Evaluation of the determinant of a-xi where A is an NXN matrix,
!     x is a scalar, and i is the NXN identity matrix.
!     -------------------
!     ka is the row dimension of A in the calling program. It is
!     assumed that ka is greater than or equal to n.
!     -------------------
if (n >= 2) go to 10
det = a(1,1) - x
return
!              Replace A with a-xi
10 if (x == 0.0) go to 20
do k = 1,n
   a(k,k) = a(k,k) - x
end do
!                Initialization
20 det = 1.0
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!       Search for the k-TH pivot element
   s = abs(a(k,k))
   l = k
   do i = kp1,n
      c = abs(a(i,k))
      if (s >= c) go to 30
      s = c
      l = i
30    continue
   end do
   pivot = a(l,k)
!         Update the calculation of det
   det = det*pivot
   if (det == 0.0) return
   if (k == l) go to 50
   det = -det
!          Interchanging rows k and l
   do j = k,n
      c = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = c
   end do
!        Reduction of the non-pivot rows
50 do i = kp1,n
      c = a(i,k)/pivot
      do j = kp1,n
         a(i,j) = a(i,j) - c*a(k,j)
      end do
   end do
end do
!         Final determinant calculation
det = det*a(n,n)
end function det

double precision function dpdet(a,ka,n,x)
implicit none
integer, intent(in) :: ka, n
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: x
integer :: i, j, k, kp1, l, nm1
double precision :: pivot, s, c
!     -------------------
!     Evaluation of the determinant of a-xi where A is an NXN matrix,
!     x is a scalar, and i is the NXN identity matrix.
!     -------------------
!     ka is the row dimension of A in the calling program. It is
!     assumed that ka is greater than or equal to n.
!     -------------------
if (n >= 2) go to 10
dpdet = a(1,1) - x
return
!              Replace A with a-xi
10 if (x == 0.d0) go to 20
do k = 1,n
   a(k,k) = a(k,k) - x
end do
!                Initialization
20 dpdet = 1.d0
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!       Search for the k-TH pivot element
   s = abs(a(k,k))
   l = k
   do i = kp1,n
      c = abs(a(i,k))
      if (s >= c) go to 30
      s = c
      l = i
30    continue
   end do
   pivot = a(l,k)
!         Update the calculation of det
   dpdet = dpdet*pivot
   if (dpdet == 0.d0) return
   if (k == l) go to 50
   dpdet = -dpdet
!          Interchanging rows k and l
   do j = k,n
      c = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = c
   end do
!        Reduction of the non-pivot rows
50 do i = kp1,n
      c = a(i,k)/pivot
      do j = kp1,n
         a(i,j) = a(i,j) - c*a(k,j)
      end do
   end do
end do
!         Final determinant calculation
dpdet = dpdet*a(n,n)
end function dpdet

complex function cdet(a,ka,n,x)
implicit none
integer, intent(in) :: ka, n
complex, intent(inout) :: a(ka,n)
complex, intent(in) :: x
integer :: i, j, k, kp1, l, nm1
complex :: pivot, t
real :: s, c
complex, parameter :: zero = (0.0,0.0)
!     -------------------
!     Evaluation of the determinant of a-xi where A is an NXN matrix,
!     x is a scalar, and i is the NXN identity matrix.
!     -------------------
!     ka is the row dimension of A in the calling program. It is
!     assumed that ka is greater than or equal to n.
!     -------------------
if (n >= 2) go to 10
cdet = a(1,1) - x
return
!              Replace A with a-xi
10 if (x == zero) go to 20
do k = 1,n
   a(k,k) = a(k,k) - x
end do
!                Initialization
20 cdet = (1.0,0.0)
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!       Search for the k-TH pivot element
   s = abs(real(a(k,k))) + abs(aimag(a(k,k)))
   l = k
   do i = kp1,n
      c = abs(real(a(i,k))) + abs(aimag(a(i,k)))
      if (s >= c) go to 30
      s = c
      l = i
30    continue
   end do
   pivot = a(l,k)
!         Update the calculation of cdet
   cdet = cdet*pivot
   if (cdet == zero) return
   if (k == l) go to 50
   cdet = -cdet
!          Interchanging rows k and l
   do j = k,n
      t = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = t
   end do
!        Reduction of the non-pivot rows
50 do i = kp1,n
      t = a(i,k)/pivot
      do j = kp1,n
         a(i,j) = a(i,j) - t*a(k,j)
      end do
   end do
end do
!         Final determinant calculation
cdet = cdet*a(n,n)
end function cdet

subroutine abslv(mo,m,n,a,na,b,nb,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc
real, intent(inout) :: a(na,m), b(nb,n), c(nc,n), wk(*)
integer :: iu, iv, iw
! ----------------------------------------------------------------------
!     abslv solves the real matrix equation AX + XB = c. A is reduced
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     being called for the first time. On an initial call mo = 0 And
!     we have the following setup.
!        a(na,m)
!           A is a matrix of order m. it is assumed that
!           na .GE. m .GE. 1.
!        b(nb,n)
!           b is a matrix of order n. it is assumed that
!           nb .GE. n .GE. 1.
!        c(nc,n)
!           c is a matrix having m rows and n columns.
!           It is assumed that nc .GE. m.
!        wk(---)
!           wk is an array of dimension m**2  + n**2 + 2K
!           WHERE K = max(m,n). wk IS A GENERAL STORAGE
!           area for the routine.
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!        ierr =  0  The solution was obtained and stored in c.
!        ierr =  1  The equations are inconsistent for A and b.
!                   The problem cannot be solved.
!        ierr = -1  A could not be reduced to lower Schur form.
!                   The problem cannot be solved.
!        ierr = -2  b could not be reduced to upper Schur form.
!                   The problem cannot be solved.
!     When ierr = 0, a contains the lower Schur form of the matrix a,
!     b contains the upper Schur form of the matrix b, and wk contains
!     the orthonal matrices involved in the Schur decompositions of
!     A and b. this information can be reused to solve a new set of
!     equations AX + XB = c without having to redecompose A and b.
!     The following options are available...
!        mo = 1      New matrices A and c are given. The data for b
!                    is reused in solving the new set of equations.
!        mo = 2      New matrices b and c are given. The data for A
!                    is reused in solving the new set of equations.
!     mo .NE. 0,1,2  a new matrix c is given. The data for A and b
!                    is reused in solving the new set of equations.
!     When abslv is recalled, it is assumed that m, n, and wk have
!     not been modified.
! ----------------------------------------------------------------------
!     This subroutine is a modification by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!     of the subroutine axpxb written by
!        R.H. Bartels and G.W.Stewart
!        University of Texas at Austin.
!     Reference. Bartels, R.H. and Stewart, G.W., algorithm 432,
!        solution of the matrix equation AX + XB = c, comm. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iu = 1
iv = m*m + 1
iw = n*n + iv
call abslv1(mo,m,n,a,na,wk(iu),m,b,nb,wk(iv),n, &
   & c,nc,wk(iw),ierr)
end subroutine abslv

subroutine abslv1(mo,m,n,a,na,u,nu,b,nb,v,nv,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc, nu, nv
real, intent(inout) :: a(na,m), b(nb,n), c(nc,n)
real, intent(inout) :: u(nu,m), v(nv,n)
real, intent(inout) :: wk(*)
integer :: i, j, k
real :: temp
! ----------------------------------------------------------------------
!     abslv1 solves the real matrix equation AX + XB = c. A is reduced
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
!     If required, reduce A to lower real Schur form
if (mo /= 0 .and. mo /= 1) go to 35
do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
call orthes(na,m,1,m,a,wk)
call ortrn1(m,1,m,a,na,u,nu,wk)
if (m == 1) go to 20
call schur(m,1,m,a,na,u,nu,wk(1),wk(m + 1),ierr)
if (ierr /= 0) go to 200
20 do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
!     If required, reduce b to upper real Schur form
35 if (mo /= 0 .and. mo /= 2) go to 45
call orthes(nb,n,1,n,b,wk)
call ortrn1(n,1,n,b,nb,v,nv,wk)
if (n == 1) go to 45
call schur(n,1,n,b,nb,v,nv,wk(1),wk(n + 1),ierr)
if (ierr /= 0) go to 210
!     Transform c
45 do j = 1,n
   do i = 1,m
      wk(i) = 0.0
      do k = 1,m
         wk(i) = wk(i) + u(k,i)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
do i = 1,m
   do j = 1,n
      wk(j) = 0.0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(k,j)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
!     Solve the transformed system
call shrslv(a,b,c,m,n,na,nb,nc,ierr)
if (ierr /= 0) go to 220
!     Transform c back to the solution
do j = 1,n
   do i = 1,m
      wk(i) = 0.0
      do k = 1,m
         wk(i) = wk(i) + u(i,k)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
do i = 1,m
   do j = 1,n
      wk(j) = 0.0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(j,k)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
return
!     Error return
200 ierr = -1
return
210 ierr = -2
return
220 ierr = 1
end subroutine abslv1

pure subroutine schur(n, low, igh, h, nh, z, nz, wr, wi, ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nh, nz, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: h(nh,n), wr(n), wi(n), z(nz,n)
integer :: ip1, i, j, k, l, m, en, ll, mm, na, its, mp2, enm2
real :: p, q, r, s, t, w, x, y, zz, norm, s1, s2
logical :: notlas
! ----------------------------------------------------------------------
!     It is assumed that h is an upper Hessenberg matrix. Schur
!     obtains an orthogonal matrix q for which transpose(q)*h*q
!     is in Schur form. The eigenvalues of h are also computed.
!     On input-
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n, (balanc is an EISPACK subroutine).
!        h contains the upper Hessenberg matrix,
!        nh is the first dimension of h,
!        z contains a matrix of order n,
!        nz is the first dimension of z.
!     On output-
!        h contains the transformed matrix in upper Schur form,
!        z contains the matrix z*q where q is the orthogonal
!          matrix which reduces h to upper Schur form,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n.
!        ierr is set to
!          0          FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
! -----------------
!     Written by jack dongarra
!          Argonne National Laboratory
!          may 1961
!     modified by A.H. Morris (NSWC)
! ----------------------------------------------------------------------
!     This subroutine is a modification of the EISPACK subroutine
!     hqr2,  which is based on the Algol procedure hqr by peters
!     and Wilkinson, NUM. Math. 16 (1970), PP.181-204.
! ----------------------------------------------------------------------
!     real sqrt, abs
!     integer min0
ierr = 0
norm = 0.0
k = 1
!     ********** Store roots isolated by balanc
!                and compute matrix norm **********
do i = 1,n
   do j = k,n
      norm = norm + abs(h(i,j))
   end do
   k = i
   if (i >= low .and. i <= igh) go to 20
   wr(i) = h(i,i)
   wi(i) = 0.0
20 continue
end do
en = igh
t = 0.0
!     ********** Search for next eigenvalues **********
30 if (en < low) go to 300
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
40 do ll = low,en
   l = en + low - ll
   if ( l == low ) exit
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.0) s = norm
   s1 = s
   s2 = s1 + abs(h(l,l - 1))
   if ( s1 == s2 ) exit
end do
!     ********** Form shift **********
x = h(en,en)
if (l == en) go to 220
y = h(na,na)
w = h(en,na)*h(na,en)
if (l == na) go to 230
if (its == 30) go to 290
if (its /= 10 .and. its /= 20) go to 80
!     ********** Form exceptional shift **********
t = t + x
do i = low,en
   h(i,i) = h(i,i) - x
end do
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75*s
y = x
w = -0.4375*s*s
80 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l,enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r*s - w)/h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p/s
   q = q/s
   r = r/s
   if ( m == l ) exit
   s1 = abs(p)*(abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))
   s2 = s1 + abs(h(m,m - 1))*(abs(q) + abs(r))
   if ( s1 == s2 ) exit
end do
mp2 = m + 2
do i = mp2,en
   h(i,i - 2) = 0.0
   if (i == mp2) go to 110
   h(i,i - 3) = 0.0
110 continue
end do
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do k = m,na
   notlas = k /= na
   if (k == m) go to 120
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.0) go to 210
   p = p/x
   q = q/x
   r = r/x
120 s = sqrt(p*p + q*q + r*r)
   if (p < 0.0) s = -s
   if (k == m) go to 130
   h(k,k - 1) = -s*x
   go to 140
130 if (l /= m) h(k,k - 1) = -h(k,k - 1)
140 p = p + s
   x = p/s
   y = q/s
   zz = r/s
   q = q/p
   r = r/p
!     ********** Row modification **********
   do j = k,n
      p = h(k,j) + q*h(k + 1,j)
      if (.not.notlas) go to 150
      p = p + r*h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p*zz
150   h(k + 1,j) = h(k + 1,j) - p*y
      h(k,j) = h(k,j) - p*x
   end do
   j = min(en,k + 3)
!     ********** Column modification **********
   do i = 1,j
      p = x*h(i,k) + y*h(i,k + 1)
      if (.not.notlas) go to 170
      p = p + zz*h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p*r
170   h(i,k + 1) = h(i,k + 1) - p*q
      h(i,k) = h(i,k) - p
   end do
!     ********** Accumulate transformations **********
   do i = low,igh
      p = x*z(i,k) + y*z(i,k + 1)
      if (.not.notlas) go to 190
      p = p + zz*z(i,k + 2)
      z(i,k + 2) = z(i,k + 2) - p*r
190   z(i,k + 1) = z(i,k + 1) - p*q
      z(i,k) = z(i,k) - p
   end do
210 continue
end do
go to 40
!     ********** One root found **********
220 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.0
en = na
go to 30
!     ********** Two roots found **********
230 p = (y - x)/2.0
q = p*p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q < 0.0) go to 270
!     ********** Real pair **********
if (p < 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.0) wr(en) = x - w/zz
wi(na) = 0.0
wi(en) = 0.0
x = h(en,na)
s = abs(x) + abs(zz)
p = x/s
q = zz/s
r = sqrt(p*p + q*q)
p = p/r
q = q/r
!     ********** Row modification **********
do j = na,n
   zz = h(na,j)
   h(na,j) = q*zz + p*h(en,j)
   h(en,j) = q*h(en,j) - p*zz
end do
!     ********** Column modification **********
do i = 1,en
   zz = h(i,na)
   h(i,na) = q*zz + p*h(i,en)
   h(i,en) = q*h(i,en) - p*zz
end do
!     ********** Accumulate transformations **********
do i = low,igh
   zz = z(i,na)
   z(i,na) = q*zz + p*z(i,en)
   z(i,en) = q*z(i,en) - p*zz
end do
go to 280
!     ********** Complex pair **********
270 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
280 en = enm2
go to 30
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
290 ierr = en
return
300 do i = 1,n
   ip1 = i + 1
   if (abs(wi(i)) /= 0.0) ip1 = ip1 + 1
   if (ip1 > n) go to 320
   do j = ip1,n
      h(j,i) = 0.0
   end do
320 continue
end do
end subroutine schur

pure subroutine shrslv(a,b,c,m,n,na,nb,nc,ierr)
implicit none
!     ------------------------------------------------------------------
!     shrslv solves the matrix equation AX + XB = c where
!     A is in lower Schur form and b in upper Schur form.
!     ------------------------------------------------------------------
integer, intent(in) :: m, n, na, nb, nc
integer, intent(inout) :: ierr
real, intent(in) :: a(na,m), b(nb,n)
real, intent(inout) :: c(nc,n)
real :: sum, p(4), t(4,4)
integer :: dk, dl, i, ib, j, ja, k, km1, kk, l, lm1, ll
interface
   pure subroutine slv(n,m,a,ka,b,kb,ierr)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: ka
      integer, intent(in) :: m
      integer, intent(in) :: n
      real, intent(inout) :: a(ka,n)
      real, intent(inout) :: b(kb,m)
      integer, intent(out) :: ierr
   end subroutine slv
end interface
l = 1
10 lm1 = l - 1
dl = 1
if (l == n) go to 15
if (b(l + 1,l) /= 0.0) dl = 2
15 ll = l + dl - 1
if (l == 1) go to 30
do j = l,ll
   do i = 1,m
      sum = c(i,j)
      do ib = 1,lm1
         sum = sum - c(i,ib)*b(ib,j)
      end do
      c(i,j) = sum
   end do
end do
30 k = 1
40 km1 = k - 1
dk = 1
if (k == m) go to 45
if (a(k,k + 1) /= 0.0) dk = 2
45 kk = k + dk - 1
if (k == 1) go to 60
do i = k,kk
   do j = l,ll
      sum = c(i,j)
      do ja = 1,km1
         sum = sum - a(i,ja)*c(ja,j)
      end do
      c(i,j) = sum
   end do
end do
60 if (dl == 2) go to 80
if (dk == 2) go to 70
t(1,1) = a(k,k) + b(l,l)
if (t(1,1) == 0.0) go to 200
c(k,l) = c(k,l)/t(1,1)
ierr = 0
go to 100
70 t(1,1) = a(k,k) + b(l,l)
t(1,2) = a(k,kk)
t(2,1) = a(kk,k)
t(2,2) = a(kk,kk) + b(l,l)
p(1) = c(k,l)
p(2) = c(kk,l)
call slv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
go to 100
80 if (dk == 2) go to 90
t(1,1) = a(k,k) + b(l,l)
t(1,2) = b(ll,l)
t(2,1) = b(l,ll)
t(2,2) = a(k,k) + b(ll,ll)
p(1) = c(k,l)
p(2) = c(k,ll)
call slv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(k,ll) = p(2)
go to 100
90 t(1,1) = a(k,k) + b(l,l)
t(1,2) = a(k,kk)
t(1,3) = b(ll,l)
t(1,4) = 0.0
t(2,1) = a(kk,k)
t(2,2) = a(kk,kk) + b(l,l)
t(2,3) = 0.0
t(2,4) = t(1,3)
t(3,1) = b(l,ll)
t(3,2) = 0.0
t(3,3) = a(k,k) + b(ll,ll)
t(3,4) = t(1,2)
t(4,1) = 0.0
t(4,2) = t(3,1)
t(4,3) = t(2,1)
t(4,4) = a(kk,kk) + b(ll,ll)
p(1) = c(k,l)
p(2) = c(kk,l)
p(3) = c(k,ll)
p(4) = c(kk,ll)
call slv(4, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
c(k,ll) = p(3)
c(kk,ll) = p(4)
100 k = k + dk
if (k <= m) go to 40
l = l + dl
if (l <= n) go to 10
return
!     Error return
200 ierr = 1
end subroutine shrslv

subroutine dabslv(mo,m,n,a,na,b,nb,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc
double precision, intent(inout) :: a(na,m), b(nb,n), c(nc,n), &
   & wk(*)
integer :: iu, iv, iw
! ----------------------------------------------------------------------
!     dabslv solves the real matrix equation AX + XB = c. A is reduced
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     being called for the first time. On an initial call mo = 0 And
!     we have the following setup.
!        a(na,m)
!           A is a matrix of order m. it is assumed that
!           na .GE. m .GE. 1.
!        b(nb,n)
!           b is a matrix of order n. it is assumed that
!           nb .GE. n .GE. 1.
!        c(nc,n)
!           c is a matrix having m rows and n columns.
!           It is assumed that nc .GE. m.
!        WK(---)
!           WK is an array of dimension m**2  + n**2 + 2K
!           WHERE K = max(m,n). WK IS A GENERAL STORAGE
!           area for the routine.
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!        ierr =  0  The solution was obtained and stored in c.
!        ierr =  1  The equations are inconsistent for A and b.
!                   The problem cannot be solved.
!        ierr = -1  A could not be reduced to lower Schur form.
!                   The problem cannot be solved.
!        ierr = -2  b could not be reduced to upper Schur form.
!                   The problem cannot be solved.
!     When ierr = 0, a contains the lower Schur form of the matrix a,
!     b contains the upper Schur form of the matrix b, and WK contains
!     the orthonal matrices involved in the Schur decompositions of
!     A and b. this information can be reused to solve a new set of
!     equations AX + XB = c without having to redecompose A and b.
!     The following options are available...
!        mo = 1      New matrices A and c are given. The data for b
!                    is reused in solving the new set of equations.
!        mo = 2      New matrices b and c are given. The data for A
!                    is reused in solving the new set of equations.
!     mo .NE. 0,1,2  a new matrix c is given. The data for A and b
!                    is reused in solving the new set of equations.
!     When dabslv is recalled, it is assumed that m, n, and WK have
!     not been modified.
! ----------------------------------------------------------------------
!     This subroutine is a modification by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!     of the subroutine axpxb written by
!        R.H. Bartels and G.W.Stewart
!        University of Texas at Austin.
!     Reference. Bartels, R.H. and Stewart, G.W., algorithm 432,
!        solution of the matrix equation AX + XB = c, comm. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iu = 1
iv = m*m + 1
iw = n*n + iv
call dabsv1(mo,m,n,a,na,wk(iu),m,b,nb,wk(iv),n, &
   & c,nc,wk(iw),ierr)
end subroutine dabslv

subroutine dabsv1(mo,m,n,a,na,u,nu,b,nb,v,nv,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc, nu, nv
double precision, intent(inout) :: a(na,m), b(nb,n), c(nc,n)
double precision, intent(inout) :: u(nu,m), v(nv,n)
double precision, intent(inout) :: wk(*)
integer :: i, j, k
double precision :: temp
! ----------------------------------------------------------------------
!     dabsv1 solves the real matrix equation AX + XB = c. A is reduced
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
!     If required, reduce A to lower real Schur form
if (mo /= 0 .and. mo /= 1) go to 35
do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
call dorth(na,m,1,m,a,wk)
call drtrn1(m,1,m,a,na,u,nu,wk)
if (m == 1) go to 20
call dschur(m,1,m,a,na,u,nu,wk(1),wk(m + 1),ierr)
if (ierr /= 0) go to 200
20 do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
!     If required, reduce b to upper real Schur form
35 if (mo /= 0 .and. mo /= 2) go to 45
call dorth(nb,n,1,n,b,wk)
call drtrn1(n,1,n,b,nb,v,nv,wk)
if (n == 1) go to 45
call dschur(n,1,n,b,nb,v,nv,wk(1),wk(n + 1),ierr)
if (ierr /= 0) go to 210
!     Transform c
45 do j = 1,n
   do i = 1,m
      wk(i) = 0.d0
      do k = 1,m
         wk(i) = wk(i) + u(k,i)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
do i = 1,m
   do j = 1,n
      wk(j) = 0.d0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(k,j)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
!     Solve the transformed system
call dshslv(a,b,c,m,n,na,nb,nc,ierr)
if (ierr /= 0) go to 220
!     Transform c back to the solution
do j = 1,n
   do i = 1,m
      wk(i) = 0.d0
      do k = 1,m
         wk(i) = wk(i) + u(i,k)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
do i = 1,m
   do j = 1,n
      wk(j) = 0.d0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(j,k)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
return
!     Error return
200 ierr = -1
return
210 ierr = -2
return
220 ierr = 1
end subroutine dabsv1

pure subroutine dschur(n, low, igh, h, nh, z, nz, wr, wi, ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nh, nz, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: h(nh,n), wr(n), wi(n), z(nz,n)
integer :: ip1, i, j, k, l, m, en, ll, mm, na, its, mp2, enm2
double precision :: p, q, r, s, t, w, x, y, zz, norm, s1, s2
logical :: notlas
! ----------------------------------------------------------------------
!     It is assumed that h is an upper Hessenberg matrix. dschur
!     obtains an orthogonal matrix q for which  transpose(q)*h*q
!     is in Schur form. The eigenvalues of h are also computed.
!     On input-
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dbal.  If  dbal  has not been used, set
!          low = 1, igh = n.
!        h contains the upper Hessenberg matrix,
!        nh is the first dimension of h,
!        z contains a matrix of order n,
!        nz is the first dimension of z.
!     On output-
!        h contains the transformed matrix in upper Schur form,
!        z contains the matrix z*q where q is the orthogonal
!          matrix which reduces h to upper Schur form,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n.
!        ierr is set to
!          0          FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
! -----------------
!     Written by jack dongarra
!          Argonne National Laboratory
!          may 1961
!     modified by A.H. Morris (NSWC)
! ----------------------------------------------------------------------
!     This subroutine is a modification of the EISPACK subroutine
!     hqr2,  which is based on the Algol procedure hqr by peters
!     and Wilkinson, NUM. Math. 16 (1970), PP.181-204.
! ----------------------------------------------------------------------
!     double precision dsqrt, dabs
!     integer min0
ierr = 0
norm = 0.d0
k = 1
!     ********** Store roots isolated by balanc
!                and compute matrix norm **********
do i = 1,n
   do j = k,n
      norm = norm + abs(h(i,j))
   end do
   k = i
   if (i >= low .and. i <= igh) go to 20
   wr(i) = h(i,i)
   wi(i) = 0.d0
20 continue
end do
en = igh
t = 0.d0
!     ********** Search for next eigenvalues **********
30 if (en < low) go to 300
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
40 do ll = low,en
   l = en + low - ll
   if ( l == low ) exit
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.d0) s = norm
   s1 = s
   s2 = s1 + abs(h(l,l - 1))
   if ( s1 == s2 ) exit
end do
!     ********** Form shift **********
x = h(en,en)
if (l == en) go to 220
y = h(na,na)
w = h(en,na)*h(na,en)
if (l == na) go to 230
if (its == 50) go to 290
if (its /= 10 .and. its /= 20 .and. its /= 30) go to 80
!     ********** Form exceptional shift **********
t = t + x
do i = low,en
   h(i,i) = h(i,i) - x
end do
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75d0*s
y = x
w = -0.4375d0*s*s
80 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l,enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r*s - w)/h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p/s
   q = q/s
   r = r/s
   if ( m == l ) exit
   s1 = abs(p)*(abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))
   s2 = s1 + abs(h(m,m - 1))*(abs(q) + abs(r))
   if ( s1 == s2 ) exit
end do
mp2 = m + 2
do i = mp2,en
   h(i,i - 2) = 0.d0
   if (i == mp2) go to 110
   h(i,i - 3) = 0.d0
110 continue
end do
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do k = m,na
   notlas = k /= na
   if (k == m) go to 120
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.d0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.d0) go to 210
   p = p/x
   q = q/x
   r = r/x
120 s = sqrt(p*p + q*q + r*r)
   if (p < 0.d0) s = -s
   if (k == m) go to 130
   h(k,k - 1) = -s*x
   go to 140
130 if (l /= m) h(k,k - 1) = -h(k,k - 1)
140 p = p + s
   x = p/s
   y = q/s
   zz = r/s
   q = q/p
   r = r/p
!     ********** Row modification **********
   do j = k,n
      p = h(k,j) + q*h(k + 1,j)
      if (.not.notlas) go to 150
      p = p + r*h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p*zz
150   h(k + 1,j) = h(k + 1,j) - p*y
      h(k,j) = h(k,j) - p*x
   end do
   j = min(en,k + 3)
!     ********** Column modification **********
   do i = 1,j
      p = x*h(i,k) + y*h(i,k + 1)
      if (.not.notlas) go to 170
      p = p + zz*h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p*r
170   h(i,k + 1) = h(i,k + 1) - p*q
      h(i,k) = h(i,k) - p
   end do
!     ********** Accumulate transformations **********
   do i = low,igh
      p = x*z(i,k) + y*z(i,k + 1)
      if (.not.notlas) go to 190
      p = p + zz*z(i,k + 2)
      z(i,k + 2) = z(i,k + 2) - p*r
190   z(i,k + 1) = z(i,k + 1) - p*q
      z(i,k) = z(i,k) - p
   end do
210 continue
end do
go to 40
!     ********** One root found **********
220 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.d0
en = na
go to 30
!     ********** Two roots found **********
230 p = (y - x)/2.d0
q = p*p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q < 0.d0) go to 270
!     ********** Real pair **********
if (p < 0.d0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.d0) wr(en) = x - w/zz
wi(na) = 0.d0
wi(en) = 0.d0
x = h(en,na)
s = abs(x) + abs(zz)
p = x/s
q = zz/s
r = sqrt(p*p + q*q)
p = p/r
q = q/r
!     ********** Row modification **********
do j = na,n
   zz = h(na,j)
   h(na,j) = q*zz + p*h(en,j)
   h(en,j) = q*h(en,j) - p*zz
end do
!     ********** Column modification **********
do i = 1,en
   zz = h(i,na)
   h(i,na) = q*zz + p*h(i,en)
   h(i,en) = q*h(i,en) - p*zz
end do
!     ********** Accumulate transformations **********
do i = low,igh
   zz = z(i,na)
   z(i,na) = q*zz + p*z(i,en)
   z(i,en) = q*z(i,en) - p*zz
end do
go to 280
!     ********** Complex pair **********
270 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
280 en = enm2
go to 30
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
290 ierr = en
return
300 do i = 1,n
   ip1 = i + 1
   if (abs(wi(i)) /= 0.d0) ip1 = ip1 + 1
   if (ip1 > n) go to 320
   do j = ip1,n
      h(j,i) = 0.d0
   end do
320 continue
end do
end subroutine dschur

pure subroutine dshslv(a,b,c,m,n,na,nb,nc,ierr)
implicit none
!     ------------------------------------------------------------------
!     dshslv solves the matrix equation AX + XB = c where
!     A is in lower Schur form and b in upper Schur form.
!     ------------------------------------------------------------------
integer, intent(in) :: m, n, na, nb, nc
integer, intent(inout) :: ierr
double precision, intent(in) :: a(na,m), b(nb,n)
double precision, intent(inout) :: c(nc,n)
double precision :: sum, p(4), t(4,4)
integer :: dk, dl, i, ib, j, ja, k, km1, kk, l, lm1, ll
interface
   pure subroutine dpslv(n,m,a,ka,b,kb,ierr)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: ka
      integer, intent(in) :: m
      integer, intent(in) :: n
      double precision, intent(inout) :: a(ka,n)
      double precision, intent(inout) :: b(kb,m)
      integer, intent(out) :: ierr
   end subroutine dpslv
end interface
l = 1
10 lm1 = l - 1
dl = 1
if (l == n) go to 15
if (b(l + 1,l) /= 0.d0) dl = 2
15 ll = l + dl - 1
if (l == 1) go to 30
do j = l,ll
   do i = 1,m
      sum = c(i,j)
      do ib = 1,lm1
         sum = sum - c(i,ib)*b(ib,j)
      end do
      c(i,j) = sum
   end do
end do
30 k = 1
40 km1 = k - 1
dk = 1
if (k == m) go to 45
if (a(k,k + 1) /= 0.d0) dk = 2
45 kk = k + dk - 1
if (k == 1) go to 60
do i = k,kk
   do j = l,ll
      sum = c(i,j)
      do ja = 1,km1
         sum = sum - a(i,ja)*c(ja,j)
      end do
      c(i,j) = sum
   end do
end do
60 if (dl == 2) go to 80
if (dk == 2) go to 70
t(1,1) = a(k,k) + b(l,l)
if (t(1,1) == 0.d0) go to 200
c(k,l) = c(k,l)/t(1,1)
ierr = 0
go to 100
70 t(1,1) = a(k,k) + b(l,l)
t(1,2) = a(k,kk)
t(2,1) = a(kk,k)
t(2,2) = a(kk,kk) + b(l,l)
p(1) = c(k,l)
p(2) = c(kk,l)
call dpslv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
go to 100
80 if (dk == 2) go to 90
t(1,1) = a(k,k) + b(l,l)
t(1,2) = b(ll,l)
t(2,1) = b(l,ll)
t(2,2) = a(k,k) + b(ll,ll)
p(1) = c(k,l)
p(2) = c(k,ll)
call dpslv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(k,ll) = p(2)
go to 100
90 t(1,1) = a(k,k) + b(l,l)
t(1,2) = a(k,kk)
t(1,3) = b(ll,l)
t(1,4) = 0.d0
t(2,1) = a(kk,k)
t(2,2) = a(kk,kk) + b(l,l)
t(2,3) = 0.d0
t(2,4) = t(1,3)
t(3,1) = b(l,ll)
t(3,2) = 0.d0
t(3,3) = a(k,k) + b(ll,ll)
t(3,4) = t(1,2)
t(4,1) = 0.d0
t(4,2) = t(3,1)
t(4,3) = t(2,1)
t(4,4) = a(kk,kk) + b(ll,ll)
p(1) = c(k,l)
p(2) = c(kk,l)
p(3) = c(k,ll)
p(4) = c(kk,ll)
call dpslv(4, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
c(k,ll) = p(3)
c(kk,ll) = p(4)
100 k = k + dk
if (k <= m) go to 40
l = l + dl
if (l <= n) go to 10
return
!     Error return
200 ierr = 1
end subroutine dshslv

subroutine taslv(mo,n,a,na,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc
real, intent(inout) :: a(na,n), c(nc,n), wk(*)
integer :: iw
! ----------------------------------------------------------------------
!     taslv solves the real matrix equation transpose(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     being called for the first time. On an initial call mo = 0 And
!     we have the following setup.
!        a(na,n)
!           A is a matrix of order n. it is assumed that
!           na .GE. n .GE. 1.
!        c(nc,n)
!           c is a symmetric matrix of order n. it is
!           assumed that nc .GE. n.
!        wk(---)
!           wk is an array of dimension n**2 + 2n that
!           is a general storage area for the routine.
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!        ierr =  0  The solution was obtained and stored in c.
!        ierr =  1  The equations are inconsistent for A. the
!                   problem cannot be solved.
!        ierr = -1  A could not be REDUCEDTO upper Schur form.
!                   The problem cannot be solved.
!     When ierr = 0, a contains the upper Schur form of the matrix
!     A and wk contains the orthogonal matrix involved in the Schur
!     decomposition of A. this information can be reused to solve A
!     new set of equations transpose(a)*X + X*a = c without having
!     to redecompose A. in this case, the input argument mo may be
!     set to any nonzero value. When mo .NE. 0, it is assumed that
!     only c has been modified. On output the solution for the new
!     set of equations is stored in c.
! ----------------------------------------------------------------------
!     This subroutine is a modification by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!     of the subroutine atxpxa written by
!        R.H. Bartels and G.W. Stewart
!        University of Texas at Austin.
!     Reference. Bartels, R.H. and Stewart, G.W., algorithm 432,
!        solution of the matrix equation AX + XB = c, comm. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iw = n*n + 1
call taslv1(mo,n,a,na,wk(1),n,c,nc,wk(iw),ierr)
end subroutine taslv

