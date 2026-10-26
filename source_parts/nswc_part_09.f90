pure subroutine crout1(a,ka,n,iend,index,temp,jp,ierr)
implicit none
integer, intent(in) :: iend
integer, intent(inout) :: ierr, index(*), jp
integer, intent(in) :: ka, n
real, intent(inout) :: a(*), temp(n)
integer :: i, ibeg, ij, ik, il, j, jcol, jj, k, kcol, kcount, kj, &
   & kj0, kk, kl, km1, kp1, l, lj, lj0, lk, lmin, max, mcol, ncol, nk, &
   & nm1, nmj, nmk, nn
real :: c, pmin, s, nswc_ai_r4
double precision :: dsum
!     ******************************************************************
!     crout procedure for inverting matrices
!     ******************************************************************
!     A is a matrix of order n where n is greater than or equal to 1.
!     The inverse of A is computed and stored in A.
!
!     ka = Length of the columns of the array a
!     jp = The number of the column that contains the smallest pivot
!
!     iend may be 0,1,...,n-1.  It is assumed that each of the first
!     iend columns of the matrix a contains only one nonzero element
!     and that the nonzero element is 1 or -1.
!
!     Index is an array of dimension n-1 or larger that is used by the
!     routine for keeping track of the row interchanges that are made.
!
!     Temp is a temporary storage array.
!
!     ierr reports the status of the results. If A is nonsingular then
!     the inverse of A is computed and ierr=0. Otherwise if A is found
!     to be singular then ierr=1 And the routine terminates.
!     --------------------
max = ka*n
mcol = iend*ka
if (iend == 0) go to 100
!
!           Process the first iend columns of A
!
kcol = 0
do k = 1,iend
   kk = kcol + k
   nk = kcol + n
   do lk = kk,nk
      nswc_ai_r4 = a ( lk )
      if ( nswc_ai_r4 < 0 ) go to 20
      if ( nswc_ai_r4 == 0 ) go to 10
      go to 30
10    continue
   end do
   jp = k
   go to 300
!
20 l = lk - kcol
   lj0 = mcol + l
   do lj = lj0,max,ka
21    a(lj) = -a(lj)
   end do
!
30 l = lk - kcol
   index(k) = l
   if (k == l) go to 32
   lj = lk
   do kj = kk,max,ka
      c = a(kj)
      a(kj) = a(lj)
      a(lj) = c
31    lj = lj + ka
   end do
32 kcol = kcol + ka
end do
!
!           Process the remaining columns of A
!
100 nm1 = n - 1
jp = 1
ierr = 0
pmin = 0.0
ibeg = iend + 1
if (ibeg == n) go to 190
!
k = ibeg
km1 = iend
kp1 = k + 1
kcol = mcol
kk = kcol + k
do kcount = ibeg,nm1
!
!     Search for the k-TH pivot element (k=ibeg,...,n-1)
!
   l = k
   s = abs(a(kk))
   do i = kp1,n
      ik = kcol + i
      c = abs(a(ik))
      if (s >= c) go to 110
      l = i
      s = c
110   continue
   end do
!
   if (k > ibeg .and. s >= pmin) go to 120
   jp = k
   pmin = s
   if (s == 0.0) go to 300
!
!              Interchanging rows k and L
!
120 index(k) = l
   if (k == l) go to 130
   kj0 = mcol + k
   lj = mcol + l
   do kj = kj0,max,ka
      c = a(kj)
      a(kj) = a(lj)
      a(lj) = c
121   lj = lj + ka
   end do
!
!       Compute the k-TH row of U (k=ibeg,...,n-1)
!
130 c = a(kk)
   if (k > ibeg) go to 140
   kj0 = kk + ka
   do kj = kj0,max,ka
131   a(kj) = a(kj)/c
   end do
   go to 160
!
140 kl = mcol + k
   do l = ibeg,km1
      temp(l) = a(kl)
141   kl = kl + ka
   end do
!
   kj0 = kk + ka
   do kj = kj0,max,ka
      jcol = kj - k
      dsum = -a(kj)
      do l = ibeg,km1
         lj = jcol + l
150      dsum = dsum + dble(temp(l))*dble(a(lj))
      end do
151   a(kj) = sngl(-dsum)/c
   end do
!
!      Compute the k-TH column of L (k=ibeg+1,...,n)
!
160 km1 = k
   k = kp1
   kp1 = k + 1
   kcol = kcol + ka
   kk = kcol + k
   do l = ibeg,km1
      lk = kcol + l
161   temp(l) = a(lk)
   end do
!
   do i = k,n
      il = mcol + i
      dsum = 0.d0
      do l = ibeg,km1
         dsum = dsum + dble(a(il))*dble(temp(l))
170      il = il + ka
      end do
171   a(il) = dble(a(il)) - dsum
   end do
end do
!
!           Check the n-TH pivot element
!
190 ncol = max - ka
nn = ncol + n
c = abs(a(nn))
if (c > pmin) go to 200
jp = n
if (c == 0.0) go to 300
!
!          Replace L with the inverse of L
!
200 if (ibeg == n) go to 213
jj = mcol + ibeg
i = ka + 1
do j = ibeg,nm1
   a(jj) = 1.0/a(jj)
   temp(j) = a(jj)
   kj = jj
   do km1 = j,nm1
      k = km1 + 1
      kj = kj + 1
      dsum = 0.d0
      kl = kj
      do l = j,km1
         dsum = dsum + dble(a(kl)*temp(l))
210      kl = kl + ka
      end do
      a(kj) = sngl(-dsum)/a(kl)
211   temp(k) = a(kj)
   end do
212 jj = jj + i
end do
213 a(nn) = 1.0/a(nn)
if (n == 1) return
!
!       Solve UX = Y where Y is the inverse of L
!
do nmk = 1,nm1
   k = n - nmk
   lmin = max0(ibeg,k + 1)
   kl = (lmin - 1)*ka + k
   do l = lmin,n
      temp(l) = a(kl)
      a(kl) = 0.0
230   kl = kl + ka
   end do
!
   kj0 = mcol + k
   do kj = kj0,max,ka
      dsum = -a(kj)
      lj = (kj - k) + lmin
      do l = lmin,n
         dsum = dsum + dble(temp(l)*a(lj))
240      lj = lj + 1
      end do
241   a(kj) = -dsum
   end do
end do
!
!                 Column interchanges
!
jcol = ncol - ka
do nmj = 1,nm1
   j = n - nmj
   k = index(j)
   if (j == k) go to 251
   ij = jcol
   ik = (k - 1)*ka
   do i = 1,n
      ij = ij + 1
      ik = ik + 1
      c = a(ij)
      a(ij) = a(ik)
250   a(ik) = c
   end do
251 jcol = jcol - ka
end do
return
!
!                    Error return
!
300 ierr = 1
end subroutine crout1

pure subroutine assgn(n,a,c,t,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer, intent(inout) :: a(n,*), c(n), t, iwk(*)
integer :: i1, i2, i3, i4, i5, i6
interface
   pure subroutine assgn1(n,a,c,t,ch,lc,lr,lz,nz,rh,slc,slr,u,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: a(n,*)
      integer, intent(inout) :: c(n)
      integer, intent(inout) :: t
      integer, intent(inout) :: ch(n)
      integer, intent(inout) :: lc(n)
      integer, intent(inout) :: lr(n)
      integer, intent(inout) :: lz(n)
      integer, intent(inout) :: nz(n)
      integer, intent(inout) :: rh(*)
      integer, intent(inout) :: slc(n)
      integer, intent(inout) :: slr(n)
      integer, intent(inout) :: u(*)
      integer, intent(out) :: ierr
   end subroutine assgn1
end interface
!     -------------------
!     Solution of the assignment problem
!     -------------------
!
i1 = n + 1
i2 = i1 + n
i3 = i2 + n
i4 = i3 + n + 1
i5 = i4 + n
i6 = i5 + n
call assgn1(n,a,c,t,iwk(1),iwk(i1),iwk(i2),iwk(i3),iwk(1), &
   & iwk(i3),iwk(i4),iwk(i5),iwk(i6),ierr)
end subroutine assgn

pure subroutine assgn1(n,a,c,t,ch,lc,lr,lz,nz,rh,slc,slr, &
   & u,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: n
integer, intent(inout) :: a(n,*), c(n), ch(n), lc(n), lr(n), &
   & lz(n), nz(n), rh(*), slc(n), slr(n), u(*)
integer, intent(inout) :: t
integer :: i, j, k, kslc, kslr, l, lj, lm, m, maxnum, mm, nl, nm, np1, h, q, r, s, nswc_ai_i4
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!
! This subroutine solves the square assignment problem
! the meaning of the input parameters is
! n = Number of rows and columns of the cost matrix
! a(i,j) = Element in row i and column j of the cost matrix
! ( at the end of computation the elements of A are changed)
! the meaning of the output parameters is
! c(j) = Row assigned to column j (j=1,n)
! t = Cost of the optimal assignment
! all parameters are integer
! the meaning of the local variables is
! a(i,j) = Element of the cost matrix IF a(i,j) is positive,
!          column of the unassigned zero following in row i
!          (i=1,n) the unassigned zero of column j (j=1,n)
!          if a(i,j) is not positive
! a(i,n+1) = Column of the first unassigned zero of row i
!            (i=1,n)
! ch(i) = Column of the next unexplored and unassigned zero
!         of row i (i=1,n)
! lc(j) = Label of column j (j=1,n)
! lr(i) = Label of row i (i=1,n)
! LZ(i) = Column of the last unassigned zero of row i(i=1,n)
! NZ(i) = Column of the next unassigned zero of row i(i=1,n)
! RH(i) = Unexplored row following the unexplored row i
!         (i=1,n)
! RH(n+1) = First unexplored row
! SLC(k) = k-TH element contained in the set of the labelled
!          columns
! slr(k) = k-TH element contained in the set of the labelled
!          rows
! U(i) = Unassigned row following the unassigned row i
!        (i=1,n)
! U(n+1) = First unassigned row
! ierr = 0 If the routine terminates successfully. Otherwise
!          ierr = 1
!
! The vectors c,ch,lc,lr,LZ,NZ,SLC,slr must be dimensioned
! at least at (n), the vectors RH,U at  least at (n+1),
! and the matrix a at least at (n,n+1). To save storage
! LZ and RH may use the same storage area, and NZ and ch
! may use the same storage area.
!
! Initialization
maxnum = ipmpar(3)
ierr = 0
np1 = n + 1
do j = 1,n
   c(j) = 0
   lz(j) = 0
   nz(j) = 0
   u(j) = 0
end do
u(np1) = 0
t = 0
! Reduction of the initial cost matrix
do j = 1,n
   s = a(1,j)
   do l = 2,n
      if ( a(l,j) < s ) s = a(l,j)
   end do
   nswc_ai_i4 = s
   if ( nswc_ai_i4 < 0 ) go to 20
   if ( nswc_ai_i4 == 0 ) go to 40
   go to 30
20 mm = maxnum + s
   if (t < -mm) go to 400
   t = t + s
   do i = 1,n
      if (a(i,j) > mm) go to 400
      a(i,j) = a(i,j) - s
   end do
   go to 40
30 mm = maxnum - s
   if (t > mm) go to 400
   t = t + s
   do i = 1,n
      a(i,j) = a(i,j) - s
   end do
40 continue
end do
do i = 1,n
   q = a(i,1)
   do l = 2,n
      if ( a(i,l) < q ) q = a(i,l)
   end do
   mm = maxnum - q
   if (t > mm) go to 400
   t = t + q
   l = np1
   do j = 1,n
      a(i,j) = a(i,j) - q
      if ( a(i,j) /= 0 ) go to 60
      a(i,l) = -j
      l = j
60    continue
   end do
end do
! Choice of the initial solution
k = np1
do i = 1,n
   lj = np1
   j = -a(i,np1)
80 if ( c(j) == 0 ) go to 130
   lj = j
   j = -a(i,j)
   if ( j /= 0 ) go to 80
   lj = np1
   j = -a(i,np1)
90 r = c(j)
   lm = lz(r)
   m = nz(r)
100 if ( m == 0 ) go to 110
   if ( c(m) == 0 ) go to 120
   lm = m
   m = -a(r,m)
   go to 100
110 lj = j
   j = -a(i,j)
   if ( j /= 0 ) go to 90
   u(k) = i
   k = i
   go to 140
120 nz(r) = -a(r,m)
   lz(r) = j
   a(r,lm) = -j
   a(r,j) = a(r,m)
   a(r,m) = 0
   c(m) = r
130 c(j) = i
   a(i,lj) = a(i,j)
   nz(i) = -a(i,j)
   lz(i) = lj
   a(i,j) = 0
140 continue
end do
! Research of a new assignment
150 if ( u(np1) == 0 ) return
do i = 1,n
   ch(i) = 0
   lc(i) = 0
   lr(i) = 0
   rh(i) = 0
end do
rh(np1) = -1
kslc = 0
kslr = 1
r = u(np1)
lr(r) = -1
slr(1) = r
if ( a(r,np1) == 0 ) go to 220
170 l = -a(r,np1)
if ( a(r,l) == 0 ) go to 180
if ( rh(r) /= 0 ) go to 180
rh(r) = rh(np1)
ch(r) = -a(r,l)
rh(np1) = r
180 if ( lc(l) == 0 ) go to 200
if ( rh(r) == 0 ) go to 210
190 l = ch(r)
ch(r) = -a(r,l)
if ( a(r,l) /= 0 ) go to 180
rh(np1) = rh(r)
rh(r) = 0
go to 180
200 lc(l) = r
if ( c(l) == 0 ) go to 360
kslc = kslc + 1
slc(kslc) = l
r = c(l)
lr(r) = l
kslr = kslr + 1
slr(kslr) = r
if ( a(r,np1) /= 0 ) go to 170
210 continue
if ( rh(np1) > 0 ) go to 350
! Reduction of the current cost matrix
220 h = maxnum
do j = 1,n
   if ( lc(j) /= 0 ) go to 240
   do k = 1,kslr
      i = slr(k)
      if ( a(i,j) < h ) h = a(i,j)
   end do
240 continue
end do
mm = maxnum - h
if (mm == 0 .or. t > mm) go to 400
t = t + h
do j = 1,n
   if ( lc(j) /= 0 ) go to 290
   do k = 1,kslr
      i = slr(k)
      a(i,j) = a(i,j) - h
      if ( a(i,j) /= 0 ) go to 280
      if ( rh(i) /= 0 ) go to 250
      rh(i) = rh(np1)
      ch(i) = j
      rh(np1) = i
250   l = np1
260   nl = -a(i,l)
      if ( nl == 0 ) go to 270
      l = nl
      go to 260
270   a(i,l) = -j
280   continue
   end do
290 continue
end do
if ( kslc == 0 ) go to 350
do i = 1,n
   if ( lr(i) /= 0 ) go to 340
   do k = 1,kslc
      j = slc(k)
      if ( a(i,j) > 0 ) go to 320
      l = np1
300   nl = - a(i,l)
      if ( nl == j ) go to 310
      l = nl
      go to 300
310   a(i,l) = a(i,j)
      a(i,j) = h
      go to 330
320   mm = maxnum - h
      if (a(i,j) > mm) go to 400
      a(i,j) = a(i,j) + h
330   continue
   end do
340 continue
end do
350 r = rh(np1)
go to 190
! Assignment of a new row
360 c(l) = r
m = np1
370 nm = -a(r,m)
if ( nm == l ) go to 380
m = nm
go to 370
380 a(r,m) = a(r,l)
a(r,l) = 0
if ( lr(r) < 0 ) go to 390
l = lr(r)
a(r,l) = a(r,np1)
a(r,np1) = -l
r = lc(l)
go to 360
390 u(np1) = u(r)
u(r) = 0
go to 150
! Error return - Integer overflow occurs
400 ierr = 1
end subroutine assgn1

pure subroutine mkp(n,m,p,w,k,bck,xstar,vstar,wk,iwk,num)
implicit none
integer, intent(in) :: m, n, num
integer, intent(inout) :: p(n), w(n)
integer, intent(in) :: k(m)
integer, intent(inout) :: xstar(n), bck, vstar, iwk(num)
real, intent(inout) :: wk(n)
integer :: i, isumw, j, jj, jn, jnn, l, lx, lxi, maxw, minw, mn, n5, np1, npl, bb, bl, x, xl, b, ubb, f, pbl, q, v, bs, ps, ws, xs
real :: ap, aw
interface
   pure subroutine mkp1(n,m,p,w,k,bck,xstar,vstar,np1,n5,bb,bl, &
      & x,xl,b,ubb,lx,lxi,f,pbl,q,v,bs,ps,ws,xs,iwk)
      implicit none
      integer, intent(in) :: n5
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: p(n)
      integer, intent(in) :: w(n)
      integer, intent(in) :: k(m)
      integer, intent(inout) :: bck
      integer, intent(inout) :: xstar(n)
      integer, intent(inout) :: vstar
      integer, intent(inout) :: bb(m,n)
      integer, intent(inout) :: bl(m,np1)
      integer, intent(inout) :: x(m,n)
      integer, intent(inout) :: xl(m,n)
      integer, intent(inout) :: b(np1)
      integer, intent(inout) :: ubb(n)
      integer, intent(inout) :: lx(n)
      integer, intent(inout) :: lxi(n)
      integer, intent(inout) :: f(m)
      integer, intent(inout) :: pbl(m)
      integer, intent(inout) :: q(m)
      integer, intent(inout) :: v(m)
      integer, intent(inout) :: bs(n)
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: iwk(n5)
   end subroutine mkp1
   pure subroutine risort(a,m,n)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: a(n)
      integer, intent(inout) :: m(n)
   end subroutine risort
end interface
!
! Subroutine to solve A 0-1 multiple knapsack problem of n
! ITEMS (WITH  n .GE. 2) AND  m  KNAPSACKS (WITH  m .GE. 1 ,
! I.E. also suitable for A 0-1 single knapsack problem).
! The problem to be solved is
!
! MAXIMIZE  vstar = p(1)*(x(1,1) + ... + x(m,1)) + ...
!                   ... + p(n)*(x(1,n) + ... + x(m,n))
! subject to
! w(1)*x(i,1) + ... + w(n)*x(i,n) .LE. k(i)   FOR  i=1,...,m
! x(1,j) + ... + x(m,j) .LE. 1   FOR  j=1,...,n
! x(i,j) = 0 OR 1   FOR  i=1,...,m ,  j=1,...,n ,
!
! Where all p(j), w(j), and k(i) are positive integers.
! Before mkp is called, array k must be sorted so that
! k(1) .LE. k(2) .LE. ... .LE. k(m) .
!
! Meaning of the input parameters ...
!
! n    = Number of items.
! m    = Number of knapsacks.
! p(j) = Profit of item  j  (j=1,...,n) .
! w(j) = Weight of item  j  (j=1,...,n) .
! k(i) = Capacity of knapsack  i  (i=1,...,m) .
! bck  = -1  If exact solution is required.
!      = Maximum number of backtrackings to be performed, if
!        heuristic solution is required.
! wk   = Real work space of dimension n.
! iwk  = Work space of dimension .GE. 5*m + 14*n + 4*m*n + 3
! num  = Dimension of iwk
!
! Meaning of the output parameters ...
!
! xstar(j) = 0  If item  j  is not in the optimal solution
!               (I.E. if  x(i,j) = 0  For all  i ).
!          = Knapsack where item  j  is inserted, otherwise
!            (I.E. IF  x(xstar(j),j) = 1 ).
! vstar    = Value of the optimal solution if  vstar .GT. 0.
!          = ERROR CONDITION (INFEASIBILITY OR TRIVIALITY)
!            in the input data if  vstar .LT. 0 .
!            = -1  IF  n .LT. 2  OR  m .LT. 1 .
!            = -2  If some  p(j) ,  w(j)  or  k(i) are not
!                  positive.
!            = -3  If a knapsack cannot contain any item.
!            = -4  If an item cannot fit into any knapsack.
!            = -5  If knapsack  m  contains all the items.
!            = -7  If array  k is not correctly sorted.
!            = -8  IF num .LT. 5*m + 14*n + 4*m*n + 3.
!
!            (In all the above cases array  xstar is not
!            defined).
!
! All the parameters except wk are of integer type. When mkp
! terminates, all the input parameters are unchanged except
! bck, which gives the number of backtrackings performed.
!
!
!                    Check the input data
!
if (m < 1 .or. n < 2) go to 100
mn = m*n
if (num < 5*m + 14*n + 4*mn + 3) go to 160
!
if (p(1) <= 0 .or. w(1) <= 0) go to 110
ap = p(1)
aw = w(1)
wk(1) = -ap/aw
maxw = w(1)
minw = w(1)
isumw = w(1)
do j = 2,n
   if (p(j) <= 0 .or. w(j) <= 0) go to 110
   ap = p(j)
   aw = w(j)
   wk(j) = -ap/aw
   if (w(j) > maxw) maxw = w(j)
   if (w(j) < minw) minw = w(j)
   isumw = isumw + w(j)
end do
!
if (k(1) <= 0) go to 110
if (m == 1) go to 30
do i = 2,m
   if (k(i) <= 0) go to 110
   if (k(i) < k(i - 1)) go to 150
end do
!
30 if (minw > k(1)) go to 120
if (maxw > k(m)) go to 130
if (isumw <= k(m)) go to 140
vstar = 0
!
!             Reorder the arrays p and w so that
!                p(j)/w(j) .GE. p(j+1)/w(j+1)
!
n5 = 5*n
do j = 1,n
   jj = n5 + j
   iwk(jj) = j
end do
call risort(wk, iwk(n5 + 1), n)
!
do j = 1,n
   iwk(j) = p(j)
   jn = j + n
   iwk(jn) = w(j)
end do
!
do j = 1,n
   jj = n5 + j
   l = iwk(jj)
   p(j) = iwk(l)
   npl = n + l
   w(j) = iwk(npl)
end do
!
!                Partition the work space iwk
!
lx = jj + 1
lxi = lx + n
bs = lxi + n
xs = bs + n
ubb = xs + n
!
np1 = n + 1
b = ubb + n
ps = b + np1
ws = ps + np1
!
f = ws + np1
pbl = f + m
q = pbl + m
v = q + m
!
bb = v + m
x = bb + mn
xl = x + mn
!
bl = xl + mn
!
!                     Solve the problem
!
call mkp1(n, m, p, w, k, bck, xstar, vstar, np1, n5, &
   & iwk(bb), iwk(bl), iwk(x), iwk(xl), &
   & iwk(b), iwk(ubb), iwk(lx), iwk(lxi), &
   & iwk(f), iwk(pbl), iwk(q), iwk(v), &
   & iwk(bs), iwk(ps), iwk(ws), iwk(xs), iwk(1))
!
!           Restore the initial ordering to p and w,
!                and reorder xstar accordingly
!
do j = 1,n
   iwk(j) = p(j)
   jn = j + n
   iwk(jn) = w(j)
   jnn = jn + n
   iwk(jnn) = xstar(j)
end do
!
do j = 1,n
   jj = n5 + j
   l = iwk(jj)
   p(l) = iwk(j)
   jn = j + n
   w(l) = iwk(jn)
   jnn = jn + n
   xstar(l) = iwk(jnn)
end do
return
!
!                        Error return
!
100 vstar = -1
return
110 vstar = -2
return
120 vstar = -3
return
130 vstar = -4
return
140 vstar = -5
return
150 vstar = -7
return
160 vstar = -8
end subroutine mkp

pure subroutine mkp1(n, m, p, w, k, bck, xstar, vstar, np1, n5, &
   & bb, bl, x, xl, b, ubb, lx, lxi, &
   & f, pbl, q, v, bs, ps, ws, xs, iwk)
implicit none
integer, intent(in) :: m, n, n5, np1
integer, intent(in) :: p(n), w(n), k(m)
integer, intent(inout) :: xstar(n), bck, vstar
integer, intent(inout) :: bb(m,n), bl(m,np1), x(m,n), xl(m,n)
integer, intent(inout) :: b(np1), ubb(n), lx(n), lxi(n)
integer, intent(inout) :: f(m), pbl(m), q(m), v(m)
integer, intent(inout) :: bs(n), ps(np1), ws(np1), xs(n), iwk(n5)
integer :: i, i1, ibv, iflag, ii, ip, ip1, iuv, j, jbck, jj, k1, kub, lb, li, lj, lr, lri, lub, lubi, m1, n1, s, u, ub, vb
interface
   pure subroutine parc(i,ii,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m &
      & ,np1,lx,lxi,lr,lri,lubi)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: i
      integer, intent(in) :: ii
      integer, intent(inout) :: ub
      integer, intent(out) :: iflag
      integer, intent(in) :: vb
      integer, intent(in) :: lub
      integer, intent(in) :: lj
      integer, intent(in) :: li
      integer, intent(in) :: f(m)
      integer, intent(in) :: bb(m,n)
      integer, intent(in) :: q(m)
      integer, intent(in) :: b(np1)
      integer, intent(in) :: lx(n)
      integer, intent(in) :: lxi(n)
      integer, intent(in) :: lr
      integer, intent(in) :: lri
      integer, intent(in) :: lubi
   end subroutine parc
   pure subroutine pi1(n,m,p,w,q,i,b,bb,kub,bl,lb,pbl,v,xl,np1, &
      & n5,bs,ps,ws,xs,iwk)
      implicit none
      integer, intent(in) :: n5
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: p(n)
      integer, intent(in) :: w(n)
      integer, intent(in) :: q(m)
      integer, intent(in) :: i
      integer, intent(in) :: b(np1)
      integer, intent(in) :: bb(m,n)
      integer, intent(inout) :: kub
      integer, intent(inout) :: bl(m,np1)
      integer, intent(inout) :: lb
      integer, intent(inout) :: pbl(m)
      integer, intent(inout) :: v(m)
      integer, intent(inout) :: xl(m,n)
      integer, intent(inout) :: bs(n)
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: iwk(n5)
   end subroutine pi1
   pure subroutine sigma1(n,m,p,w,q,i,b,kub,ub,np1,n5,lx,lr,bs, &
      & ps,ws,xs,iwk)
      implicit none
      integer, intent(in) :: n5
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: p(n)
      integer, intent(in) :: w(n)
      integer, intent(in) :: q(m)
      integer, intent(in) :: i
      integer, intent(in) :: b(np1)
      integer, intent(in) :: kub
      integer, intent(inout) :: ub
      integer, intent(inout) :: lx(n)
      integer, intent(inout) :: lr
      integer, intent(inout) :: bs(n)
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: iwk(n5)
   end subroutine sigma1
   pure subroutine sknp(ns,qs,kub,vs,n,np1,n5,ps,ws,xs,iwk)
      implicit none
      integer, intent(in) :: n5
      integer, intent(in) :: np1
      integer, intent(in) :: n
      integer, intent(in) :: ns
      integer, intent(inout) :: qs
      integer, intent(in) :: kub
      integer, intent(inout) :: vs
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: iwk(n5)
   end subroutine sknp
end interface
!
! Meaning of the main internal variables and arrays ...
!
! i       = Knapsack currently considered.
! LB      = Lower bound on the optimal solution.
! ub      = Upper bound on the optimal solution.
! vb      = Value of the current solution.
! x(i,j)  = 1  If item  j  is inserted in knapsack  i  in
!              the current solution.
!         = 0  OTHERWISE.
! f(i)    = Pointer to the last item inserted in knapsack  i
!           ( = -1  If knapsack  i  is empty).
! bb(i,j) = Pointer to the item inserted in knapsack  i
!           just before item  j ( = -1  If  j  is the first
!           item inserted in knapsack  i ).
! q(i)    = Current available capacity of knapsack  i .
! b(j)    = 1  If item  j  is not inserted in any knapsack.
!         = 0  If item  j  is inserted in a knapsack.
! pbl(i)  = Number of the items which can be inserted in
!           KNAPSACK  i .
! bl(i,s) = Pointer to the  s-TH  item which can be inserted
!           in knapsack  i .
! xl(i,j) = 1  If item  j  was inserted in knapsack  i  in
!              the last execution of subroutine pi1.
!         = 0  OTHERWISE.
! iwk       WORK SPACE FOR THE SUBROUTINE sknp.
!
!
if (m == 1) go to 250
!
! Step 1 (initialization)
!
jbck = bck
bck = 0
kub = 0
n1 = n + 1
b(n1) = 1
m1 = m - 1
do j = 1,n
   b(j) = 1
   do i = 1,m
      x(i,j) = 0
      bb(i,j) = 0
   end do
end do
do i = 1,m1
   q(i) = k(i)
   f(i) = -1
end do
q(m) = k(m)
vstar = 0
vb = 0
i = 1
call sigma1(n,m,p,w,k,1,b,kub,ub,np1,n5,lx,lr, &
   & bs,ps,ws,xs,iwk)
do j = 1,n
   lxi(j) = lx(j)
end do
lri = lr
lubi = ub
iflag = 0
!
! Step 2 (heuristic)
!
70 kub = vstar - vb
call pi1(n,m,p,w,q,i,b,bb,kub,bl,lb,pbl,v,xl, &
   & np1,n5,bs,ps,ws,xs,iwk)
if ( lb + vb <= vstar ) go to 140
vstar = lb + vb
do j = 1,n
   xstar(j) = 0
   do s = 1,i
      if ( x(s,j) == 0 ) go to 80
      xstar(j) = s
      go to 90
80    continue
   end do
90 continue
end do
ip = pbl(i)
if ( ip == 0 ) go to 110
do j = 1,ip
   jj = bl(i,j)
   if ( xl(i,j) == 1 ) xstar(jj) = i
end do
110 i1 = i + 1
do ii = i1,m
   ip = pbl(ii)
   if ( ip == 0 ) go to 130
   do j = 1,ip
      jj = bl(ii,j)
      if ( xl(ii,j) == 1 ) xstar(jj) = ii
   end do
130 continue
end do
if ( ub == lb ) go to 200
!
! Step 3 (updating)
!
140 if ( v(i) == 0 ) go to 180
iuv = ub + vb
u = pbl(i)
ibv = 0
do s = 1,u
   if ( xl(i,s) == 0 ) go to 170
   j = bl(i,s)
   x(i,j) = 1
   q(i) = q(i) - w(j)
   vb = vb + p(j)
   b(j) = 0
   bb(i,j) = f(i)
   ubb(j) = iuv
   if ( iflag == 1 ) go to 150
   lub = iuv
   lj = j
   li = i
150 f(i) = j
   ibv = ibv + p(j)
   if ( ibv == v(i) ) go to 180
   call parc(i,i,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m,np1, &
      & lx,lxi,lr,lri,lubi)
   if ( iflag == 1 ) go to 160
   kub = vstar - vb
   call sigma1(n,m,p,w,q,i,b,kub,ub,np1,n5,lx,lr, &
      & bs,ps,ws,xs,iwk)
   lj = n1
160 iuv = ub + vb
   if ( iuv <= vstar ) go to 200
170 continue
end do
180 if ( i == m - 1 ) go to 200
ip1 = i + 1
call parc(ip1,i,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m,np1, &
   & lx,lxi,lr,lri,lubi)
if ( iflag == 1 ) go to 190
kub = vstar - vb
call sigma1(n,m,p,w,q,ip1,b,kub,ub,np1,n5,lx,lr, &
   & bs,ps,ws,xs,iwk)
lj = n1
190 if ( ub + vb <= vstar ) go to 200
i = i + 1
go to 140
!
! Step 4 (backtracking)
!
200 if ( i > 0 ) go to 210
bck = bck - 1
return
210 if ( bck == jbck ) return
bck = bck + 1
if ( f(i) /= (-1) ) go to 230
do j = 1,n
   bb(i,j) = 0
end do
i = i - 1
go to 200
230 j = f(i)
x(i,j) = 0
b(j) = 1
vb = vb - p(j)
q(i) = q(i) + w(j)
do s = 1,n
   if ( bb(i,s) == j ) bb(i,s) = 0
end do
f(i) = bb(i,j)
if ( ubb(j) <= vstar ) go to 200
ub = ubb(j) - vb
iflag = 1
go to 70
!
! Particular case (0-1 single knapsack problem)
!
250 k1 = k(1)
do j = 1,n
   ps(j) = p(j)
   ws(j) = w(j)
end do
call sknp(n,k1,0,vstar,n,np1,n5,ps,ws,xs,iwk)
do j = 1,n
   xstar(j) = xs(j)
end do
bck = 0
end subroutine mkp1

pure subroutine sigma1(n,m,p,w,q,i,b,kub,ub,np1,n5,lx,lr, &
   & bs,ps,ws,xs,iwk)
implicit none
integer, intent(in) :: i, kub
integer, intent(inout) :: lr
integer, intent(in) :: m, n, n5, np1
integer, intent(in) :: p(n), w(n), q(m), b(np1)
integer, intent(inout) :: ub, iwk(n5)
integer, intent(inout) :: lx(n), bs(n), ps(np1), ws(np1), xs(n)
integer :: j, jj, ns, qs, sb
interface
   pure subroutine sknp(ns,qs,kub,vs,n,np1,n5,ps,ws,xs,iwk)
      implicit none
      integer, intent(in) :: n5
      integer, intent(in) :: np1
      integer, intent(in) :: n
      integer, intent(in) :: ns
      integer, intent(inout) :: qs
      integer, intent(in) :: kub
      integer, intent(inout) :: vs
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: iwk(n5)
   end subroutine sknp
end interface
!
! Subroutine to compute an upper bound  ub  on the best
! final solution which can be obtained from the current
! solution.
!
!
ns = 0
qs = 0
do j = i,m
   qs = qs + q(j)
end do
sb = 0
do j = 1,n
   lx(j) = 0
   if ( b(j) == 0 ) go to 20
   ns = ns + 1
   bs(ns) = j
   ps(ns) = p(j)
   ws(ns) = w(j)
   sb = sb + w(j)
20 continue
end do
if ( sb > qs ) go to 40
lr = qs - sb
ub = 0
if ( ns == 0 ) return
do j = 1,ns
   ub = ub + ps(j)
   xs(j) = 1
end do
go to 50
40 call sknp(ns,qs,kub,ub,n,np1,n5,ps,ws,xs,iwk)
lr = qs
50 do j = 1,ns
   jj = bs(j)
   lx(jj) = xs(j)
end do
end subroutine sigma1

pure subroutine pi1(n,m,p,w,q,i,b,bb,kub,bl,lb,pbl,v,xl, &
   & np1,n5,bs,ps,ws,xs,iwk)
implicit none
integer, intent(in) :: i
integer, intent(inout) :: kub, lb
integer, intent(in) :: m, n, n5, np1
integer, intent(in) :: bb(m,n)
integer, intent(inout) :: bl(m,np1), xl(m,n), iwk(n5)
integer, intent(in) :: p(n), w(n), q(m), b(np1)
integer, intent(inout) :: pbl(m), v(m)
integer, intent(inout) :: bs(n), ps(np1), ws(np1), xs(n)
integer :: ii, ikub, j, jb, jbs, jj, ns, pb, qs, sb, u
interface
   pure subroutine sknp(ns,qs,kub,vs,n,np1,n5,ps,ws,xs,iwk)
      implicit none
      integer, intent(in) :: n5
      integer, intent(in) :: np1
      integer, intent(in) :: n
      integer, intent(in) :: ns
      integer, intent(inout) :: qs
      integer, intent(in) :: kub
      integer, intent(inout) :: vs
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: iwk(n5)
   end subroutine sknp
end interface
!
! Subroutine to compute a feasible solution to the current
! problem. The solution is stored in array  xl , the
! corresponding value in  lb .
!
!
! Step 1
!
u = 0
do j = 1,n
   if ( b(j) == 0 ) go to 10
   u = u + 1
   bs(u) = j
10 continue
end do
do j = i,m
   pbl(j) = 0
   v(j) = 0
end do
lb = 0
ikub = kub
if ( u == 0 ) return
ns = 0
sb = 0
do j = 1,u
   jj = bs(j)
   if ( bb(i,jj) /= 0 ) go to 30
   if ( w(jj) > q(i) ) go to 30
   ns = ns + 1
   sb = sb + w(jj)
   bl(i,ns) = jj
   ps(ns) = p(jj)
   ws(ns) = w(jj)
30 continue
end do
ii = i
!
! Step 2
!
40 pbl(ii) = ns
if ( sb > q(ii) ) go to 60
pb = 0
if ( ns == 0 ) go to 80
do j = 1,ns
   pb = pb + ps(j)
   xl(ii,j) = 1
end do
go to 80
60 qs = q(ii)
kub = 0
if ( ii == m ) kub = ikub
call sknp(ns,qs,kub,pb,n,np1,n5,ps,ws,xs,iwk)
do j = 1,ns
   xl(ii,j) = xs(j)
end do
80 lb = lb + pb
ikub = ikub - pb
v(ii) = pb
bl(ii,ns + 1) = n + 1
!
! Step 3
!
if ( ii == m ) return
jb = 1
jbs = 0
do j = 1,u
   if ( bs(j) < bl(ii,jb) ) go to 90
   jb = jb + 1
   if ( xl(ii,jb - 1) == 1 ) go to 100
90 jbs = jbs + 1
   bs(jbs) = bs(j)
100 continue
end do
u = jbs
if ( u == 0 ) return
ns = 0
sb = 0
ii = ii + 1
do j = 1,u
   jj = bs(j)
   if ( w(jj) > q(ii) ) go to 110
   ns = ns + 1
   sb = sb + w(jj)
   bl(ii,ns) = jj
   ps(ns) = p(jj)
   ws(ns) = w(jj)
110 continue
end do
go to 40
end subroutine pi1

pure subroutine parc(i,ii,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m,np1, &
   & lx,lxi,lr,lri,lubi)
implicit none
integer, intent(in) :: i
integer, intent(out) :: iflag
integer, intent(in) :: ii, li, lj, lr, lri, lub, lubi, m, n, np1
integer, intent(in) :: f(m), bb(m,n), q(m), b(np1)
integer, intent(inout) :: ub
integer, intent(in) :: vb
integer, intent(in) :: lx(n), lxi(n)
integer :: i1, iq, j, r, s
!
! Subroutine for parametric computation of the upper bounds.
!
!
iflag = 0
if ( b(lj) /= 0 ) go to 60
i1 = i - 1
if ( i1 < li ) go to 20
iq = 0
do r = li,i1
   iq = iq + q(r)
end do
if ( iq > lr ) return
20 r = ii
s = f(r)
30 if ( s /= (-1) ) go to 40
r = r - 1
s = f(r)
go to 30
40 if ( lx(s) == 0 ) return
if ( s == lj ) go to 50
s = bb(r,s)
go to 30
50 ub = lub - vb
iflag = 1
return
60 i1 = i - 1
if ( i1 < 1 ) go to 80
iq = 0
do r = 1,i1
   iq = iq + q(r)
end do
if ( iq > lri ) return
80 do j = 1,n
   if ( b(j) == 1 ) go to 90
   if ( lxi(j) == 0 ) return
90 continue
end do
ub = lubi - vb
iflag = 1
end subroutine parc

pure subroutine sknp(ns,qs,kub,vs,n,np1,n5,ps,ws,xs,iwk)
implicit none
integer, intent(in) :: kub, n, n5, np1, ns
integer, intent(inout) :: qs, vs
integer, intent(inout) :: ps(np1), ws(np1), xs(n), iwk(n5)
integer :: i1, i2, i3, i4, i5
interface
   pure subroutine sknp1(ns,qs,kub,vs,n,np1,ps,ws,xs,d,min,pbar &
      & ,wbar,zbar)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: n
      integer, intent(in) :: ns
      integer, intent(inout) :: qs
      integer, intent(in) :: kub
      integer, intent(out) :: vs
      integer, intent(inout) :: ps(np1)
      integer, intent(inout) :: ws(np1)
      integer, intent(inout) :: xs(n)
      integer, intent(inout) :: d(n)
      integer, intent(inout) :: min(n)
      integer, intent(inout) :: pbar(n)
      integer, intent(inout) :: wbar(n)
      integer, intent(inout) :: zbar(n)
   end subroutine sknp1
end interface
!
! Subroutine to solve the 0-1 single knapsack problem
!
! Maximize    vs = ps(1)*xs(1) + ... + ps(ns)*xs(ns)
! subject to       ws(1)*xs(1) + ... + ws(ns)*xs(ns) .LE. qs
!                  xs(J) = 0 OR 1   FOR  J=1,...,ns
!                  vs .GT. kub
!
! This subroutine is a modified version of subroutine kp01
! which appeared in  computing 21, 81-86(1978).
!
!
i1 = 1
i2 = i1 + n
i3 = i2 + n
i4 = i3 + n
i5 = i4 + n
call sknp1(ns,qs,kub,vs,n,np1,ps,ws,xs,iwk(i1),iwk(i2), &
   & iwk(i3),iwk(i4),iwk(i5))
end subroutine sknp

pure subroutine sknp1(ns,qs,kub,vs,n,np1,ps,ws,xs,d,min, &
   & pbar,wbar,zbar)
implicit none
integer, intent(in) :: kub, n, np1, ns
integer, intent(inout) :: qs
integer, intent(out) :: vs
integer, intent(inout) :: ps(np1), ws(np1), xs(n)
integer, intent(inout) :: d(n), min(n), pbar(n), wbar(n), zbar(n)
integer :: ii, ii1, in, ip, j, j1, jj, kk, l, lim, lim1, ll, lold, mfirst, mink, ms, n1, nn, diff, pr, r, t, nswc_ai_i4
real :: a, b, c
!
! Subroutine to solve the 0-1 single knapsack problem
!
! Maximize    vs = ps(1)*xs(1) + ... + ps(ns)*xs(ns)
! subject to       ws(1)*xs(1) + ... + ws(ns)*xs(ns) .LE. qs
!                  xs(j) = 0 OR 1   FOR  j=1,...,ns
!                  vs .GT. kub
!
! This subroutine is a modified version of subroutine kp01
! which appeared in  computing 21, 81-86(1978).
!
!
vs = kub
ip = 0
ms = qs
do l = 1,ns
   ll = l
   if ( ws(l) > ms ) go to 20
   ip = ip + ps(l)
   ms = ms - ws(l)
end do
20 ll = ll - 1
if ( ms == 0 ) go to 50
ps(ns + 1) = 0
ws(ns + 1) = qs + 1
lim = ip + (ms*ps(ll + 2))/ws(ll + 2)
a = ip + ps(ll + 1)
b = (ws(ll + 1) - ms)*ps(ll)
c = ws(ll)
lim1 = a - b/c
if ( lim1 > lim ) lim = lim1
if ( lim <= vs ) return
mink = qs + 1
min(ns) = mink
do j = 2,ns
   kk = ns + 2 - j
   if ( ws(kk) < mink ) mink = ws(kk)
   min(kk - 1) = mink
end do
do j = 1,ns
   d(j) = 0
end do
pr = 0
lold = ns
ii = 1
go to 170
50 if ( vs >= ip ) return
vs = ip
do j = 1,ll
   xs(j) = 1
end do
nn = ll + 1
do j = nn,ns
   xs(j) = 0
end do
qs = 0
return
80 if ( ws(ii) <= qs ) go to 90
ii1 = ii + 1
if ( vs >= (qs*ps(ii1))/ws(ii1) + pr ) go to 280
ii = ii1
go to 80
90 ip = pbar(ii)
ms = qs - wbar(ii)
in = zbar(ii)
ll = ns
if ( in > ns) go to 110
do l = in,ns
   ll = l
   if ( ws(l) > ms ) go to 160
   ip = ip + ps(l)
   ms = ms - ws(l)
end do
110 if ( vs >= ip + pr ) go to 280
vs = ip + pr
mfirst = ms
nn = ii - 1
do j = 1,nn
   xs(j) = d(j)
end do
do j = ii,ll
   xs(j) = 1
end do
if ( ll == ns ) go to 150
nn = ll + 1
do j = nn,ns
   xs(j) = 0
end do
150 if ( vs /= lim ) go to 280
qs = mfirst
return
160 l = ll
ll = ll - 1
if ( ms == 0 ) go to 110
if ( vs >= pr + ip + (ms*ps(l))/ws(l) ) go to 280
170 wbar(ii) = qs - ms
pbar(ii) = ip
zbar(ii) = ll + 1
d(ii) = 1
nn = ll - 1
if ( nn < ii ) go to 190
do j = ii,nn
   wbar(j + 1) = wbar(j) - ws(j)
   pbar(j + 1) = pbar(j) - ps(j)
   zbar(j + 1) = ll + 1
   d(j + 1) = 1
end do
190 j1 = ll + 1
do j = j1,lold
   wbar(j) = 0
   pbar(j) = 0
   zbar(j) = j
end do
lold = ll
qs = ms
pr = pr + ip
nswc_ai_i4 = ll - ( ns - 2 )
if ( nswc_ai_i4 < 0 ) go to 240
if ( nswc_ai_i4 == 0 ) go to 220
go to 210
210 ii = ns
go to 250
220 if ( qs < ws(ns) ) go to 230
qs = qs - ws(ns)
pr = pr + ps(ns)
d(ns) = 1
230 ii = ns - 1
go to 250
240 ii = ll + 2
if ( qs >= min(ii - 1) ) go to 80
250 if ( vs >= pr ) go to 270
vs = pr
do j = 1,ns
   xs(j) = d(j)
end do
mfirst = qs
if ( vs == lim ) return
270 if ( d(ns) == 0 ) go to 280
d(ns) = 0
qs = qs + ws(ns)
pr = pr - ps(ns)
280 nn = ii - 1
if ( nn == 0 ) go to 300
do j = 1,nn
   kk = ii - j
   if ( d(kk) == 1 ) go to 310
end do
300 qs = mfirst
return
310 r = qs
qs = qs + ws(kk)
pr = pr - ps(kk)
d(kk) = 0
if ( r < min(kk) ) go to 320
ii = kk + 1
go to 80
320 nn = kk + 1
ii = kk
330 if ( vs >= pr + (qs*ps(nn))/ws(nn) ) go to 280
diff = ws(nn) - ws(kk)
nswc_ai_i4 = diff
if ( nswc_ai_i4 < 0 ) go to 390
if ( nswc_ai_i4 == 0 ) go to 340
go to 350
340 nn = nn + 1
go to 330
350 if ( diff > r ) go to 340
if ( vs >= pr + ps(nn) ) go to 340
vs = pr + ps(nn)
do j = 1,kk
   xs(j) = d(j)
end do
jj = kk + 1
do j = jj,ns
   xs(j) = 0
end do
xs(nn) = 1
mfirst = qs - ws(nn)
if ( vs /= lim ) go to 380
qs = mfirst
return
380 r = r - diff
kk = nn
nn = nn + 1
go to 330
390 t = r - diff
if ( t < min(nn) ) go to 340
n1 = nn + 1
if ( vs >= pr + ps(nn) + (t*ps(n1))/ws(n1) ) go to 280
qs = qs - ws(nn)
pr = pr + ps(nn)
d(nn) = 1
ii = nn + 1
wbar(nn) = ws(nn)
pbar(nn) = ps(nn)
zbar(nn) = ii
do j = n1,lold
   wbar(j) = 0
   pbar(j) = 0
   zbar(j) = j
end do
lold = nn
go to 80
end subroutine sknp1

subroutine lainv(mo,fun,t,aerr,rerr,y,c,error,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer, intent(out) :: num
real, intent(in) :: aerr
real, intent(inout) :: c, error
real, intent(in) :: rerr, t
real, intent(inout) :: y
external fun
integer :: ier, ierc, num1
real :: a
interface
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!
!             Computation of the inverse Laplace transform
!              of a function which is not too oscillatory
!
!                          ------------------
!
!     mo is an input integer which specifies the search procedure
!     for determination of c.  a two-pass procedure is used when
!     mo = 0 , and a one-pass procedure is used when mo is not zero.
!     When all singularities of F(Z) are expected to be real, mo = 0
!     is preferable.
!
!     Fun is a real subroutine defined by the user.  The actual name
!     for fun needs to be declared external in the driver program.
!     Fun has the arguments X, y, A, and B.
!
!     t is a positive value of the independent variable for which
!     the inverse Laplace transform is to be calculated.
!
!     c is the abscissa of convergence.  It may be either given
!     or calculated by lainv.
!
!     y is the calculated value of the inverse Laplace transform.
!
!     aerr is the absolute accuracy requested.
!     rerr is the relative accuracy requested.  The subroutine
!     attempts to satisfy the less stringent of the two requirements.
!     It is assumed that aerr and rerr are .GE. 0.  If one wants
!     accuracy to K significant figures, then rerr should be
!     set = 10.0**(-k).
!
!     Error is the estimated absolute error of y.
!
!     num is the number of evaluations of fun in lainv.
!
!     ierr may be either an input integer or an output integer.  When
!     ierr is equal to any negative integer at the beginning of lainv,
!     the abscissa of convergence is calculated and the value obtained
!     is assigned to the argument c.  otherwise, c must be input by
!     the user.  After completion of lainv, ierr has one of the
!     following values...
!
!        ierr = 0   The calculation was successful.
!
!        ierr = 1   The calculated value of y may not be accurate
!                   due to possible inaccuracy in the calculation
!                   of c.  this value of ierr may occur only when
!                   ierr is initially negative.
!
!        ierr = 2   The calculation of y did not converge, while
!                   the given or calculated value of c may be
!                   considered accurate.
!
!        ierr = 3   The calculation of y did not converge, and the
!                   calculated value of c may be inaccurate.  This
!                   value of ierr may occur only when ierr is
!                   initially negative.
!
!        ierr = 4   The value of t is less than or equal to 0.
!                   The special values y = 0.0 and error = 1.0
!                   are assigned.
!
!        ierr = 5   c was not found in the interval (-1.0E4,1.0E4).
!                   The special values c = 0.0, y = 0.0, and
!                   error = 1.0 are assigned.
!                   This value of ierr may occur only when
!                   ierr is initially negative.
!
!        ierr = 6   t is too large for the inverse transform to be
!                   computed. The values y = 0.0 and error = 1.0
!                   are assigned.
!
!-----------------------------------------------------------------------
!
num = 0
ierc = -1
if (ierr >= 0) go to 10
!
!     Calculation of the abscissa of convergence.
!
if (mo == 0) go to 5
call abcon1(fun,c,num,ierc)
go to 10
5 call abcon(fun,c,num,ierc)
10 if (ierc == 2) go to 100
!
!     Check if t is too large
!
a = c + 2.0/t
if (a*t > exparg(0)) go to 110
!
!     Calculation of the inverse Laplace transform.
!
call lainv1(fun,t,c,rerr,aerr,y,error,num1,ier)
num = num + num1
!
!     Report the status of the results.
!
if (ierc >= 0) go to 20
if (ier == 0) go to 30
if (ier == 1) go to 50
20 if (ier == 2) go to 80
if (ier == 1) go to 60
if (ierc == 1) go to 40
!
30 ierr = 0
return
40 ierr = 1
return
50 ierr = 2
return
60 if (ierc == 1) go to 70
ierr = 2
return
70 ierr = 3
return
80 ierr = 4
return
!
100 y = 0.0
error = 1.0
ierr = 5
return
110 y = 0.0
error = 1.0
ierr = 6
end subroutine lainv

subroutine abcon(fun, c, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real, intent(inout) :: c
external fun
integer :: num1
real :: eta, x0, xmin
logical :: find
external acond, xcond
!-----------------------------------------------------------------------
!
!             Computation of the abscissa of convergence
!             of a function which is not too oscillatory
!
!                         -----------------
!
!     Fun is a real subroutine defined by the user.  The actual name
!     for fun needs to be declared external in the driver program.
!     Fun has the arguments X, Y, A, and B.
!
!     c is the calculated value of the abscissa of convergence.
!
!     num is a variable. On output it has for its value the number
!     of evaluations of fun that were performed.
!
!     ierr is an output integer reporting the status of the
!     calculation of c.  ierr is assigned values as follows...
!
!        ierr = 0   The calculation was successful.
!
!        ierr = 1   The requested accuracy may not have been
!                   obtained.  More subintervals may be required
!                   in the numerical quadratures in subroutines
!                   acond AND xcond.
!
!        ierr = 2   c could not be calculated with sufficient
!                   accuracy, or an interval containing c could
!                   not be found. The special value c = 0.0 is
!                   assigned.
!
!-----------------------------------------------------------------------
!
eta = 0.01
xmin = -1.00358e4
!
!     Calculation of the location of the singularity on the real
!     axis which is farthest to the right. Set this value to x0.
!
call srch(fun, xcond, xmin, eta, x0, num, ierr)
c = x0
if (ierr == 2) go to 20
if (ierr == 3) go to 10
!
!     Check if x0 is on the right or left of the abscissa of
!     convergence. If it is on the right then we are done.
!
call acond(fun, x0, find, num1, ierr)
num = num + num1
if (find) go to 20
!
!     Search to the right of x0 to find the abscissa of
!     convergence.
!
10 call srch(fun, acond, x0, eta, c, num1, ierr)
num = num + num1
if (ierr == 3) c = 0.0
!
!     Termination
!
20 ierr = min(ierr,2)
end subroutine abcon

subroutine srch(fun,cond,xl,eta,x,num,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: num
real, intent(in) :: eta
real, intent(inout) :: x
real, intent(in) :: xl
external fun, cond
integer :: i, ier, num1
real :: dx, tol, x1, x2, xbar, xm
logical :: cnd
!-----------------------------------------------------------------------
!     srch computes an upper bound for the smallest number x such
!     that a given condition is satisfied. It is assumed that the
!     condition is satisfied for sufficiently large x.
!-----------------------------------------------------------------------
!     Fun is a real subroutine defined by the user.  The actual name
!     for fun needs to be declared external in the driver program.
!     Fun has the arguments x, Y, A, and B.
!
!     Cond is a real subroutine defined by the user.  The actual name
!     for cond needs to be declared external in the driver program.
!     Cond has the arguments fun, x, cnd, and ier, where cnd is
!     a logical variable.
!
!     xl is the smallest value of x for which a search is made.  It
!     should lie in the range - 1.0E4 .LE. xl .LT. 1.0E4.  It is
!     assumed that the logical variable cnd calculated by cond is
!     .FALSE. WHEN x = xl.
!
!     eta is the relative tolerance to which the result is to be
!     determined. It is a positive real number. When this subroutine
!     is used to calculate C for use in the piessens code lainv1
!     (algorithm 619), it is usually sufficient to take eta = 0.01.
!
!     x is the calculated result.  It is larger than the exact
!     result by an amount less than eta*x.
!
!     num is a variable. On output it has for its value the number
!     of evaluations of fun that were performed.
!
!     ierr is an output integer reporting the status of the
!     calculation of x.  ierr is assigned values as follows...
!
!          ierr = 0     The calculation was fully successful.
!
!          ierr = 1     x may be in error due to the calculation
!                       of cond.
!
!          ierr = 2     cnd IS .FALSE. WHEN x = 1.0E4.  x IS SET = 0.0.
!
!          ierr = 3     cnd is .TRUE. for  x .GE. xl.  x is set to xl.
!
ierr = 0
!
!     Search for an interval (x1, x2) containing x where
!     x1 .GE. 0.01269
!
x1 = max(.01269, xl)
call cond(fun,x1,cnd,num,ier)
if (cnd) go to 20
!
x2 = 10.1269
do i = 1,4
   if (x2 <= x1) go to 10
   call cond(fun,x2,cnd,num1,ier)
   num = num + num1
   if (cnd) go to 200
   x1 = x2
10 x2 = 10.0*x2
end do
go to 300
!
20 if (x1 == xl) go to 400
!
!     Search for an interval (x1, x2) containing x where
!     x2 .LE. 0.01269
!
x2 = x1
x1 = -.100358
do i = 1,6
   x1 = max(x1, xl)
   call cond(fun,x1,cnd,num1,ier)
   num = num + num1
   if (.not. cnd) go to 200
   x2 = x1
   if (x1 == xl) go to 400
30 x1 = 10.0*x1
end do
!
!     Search for x in the interval (x1, x2) by bisection
!
200 dx = x2 - x1
xbar = x1 + dx/2.0
call cond(fun,xbar,cnd,num1,ierr)
num = num + num1
xm = max(abs(x1), abs(x2))
tol = eta
if (xm > 1.0) tol = eta*xm
if (dx <= tol) go to 250
if (cnd) go to 225
x1 = xbar
go to 200
225 x2 = xbar
go to 200
!
!     Final assembly
!
250 if (cnd) go to 275
x = x2
return
275 x = xbar
return
!
!     Error return when x could not be found in the interval
!     (-1.0E4, 1.OE4).
!
300 x = 0.0
ierr = 2
return
400 x = xl
ierr = 3
end subroutine srch

subroutine abcon1(fun, c, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real, intent(inout) :: c
external fun
integer :: i, num1
real :: dx, eta, tol, x1, x2, xbar, xm
logical :: cmplex, iend, right
external acond, xcond
!-----------------------------------------------------------------------
!
!             Computation of the abscissa of convergence
!             of a function which is not too oscillatory
!
!                         -----------------
!
!     Fun is a real subroutine defined by the user. The actual name
!     for fun needs to be declared external in the driver program.
!     Fun has the arguments X, Y, A, and B.
!
!     c is the calculated value of the abscissa of convergence.
!
!     num is a variable. On output it has for its value the number
!     of evaluations of fun that were performed.
!
!     ierr is an output integer reporting the status of the
!     calculation of c.  ierr is assigned values as follows...
!
!        ierr = 0   The calculation was successful.
!
!        ierr = 1   The requested accuracy may not have been
!                   obtained.  More subintervals may be required
!                   in the numerical quadratures in subroutines
!                   acond AND xcond.
!
!        ierr = 2   c could not be calculated with sufficient
!                   accuracy, or an interval containing c could
!                   not be found. The special value c = 0.0 is
!                   assigned.
!
!-----------------------------------------------------------------------
!
eta = 0.01
cmplex = .false.
!
x1 = .01269
call xcond(fun,x1,right,num,ierr)
if (.not. right) go to 10
call acond(fun,x1,right,num1,ierr)
num = num + num1
if (right) go to 30
cmplex = .true.
!
!     Search for an interval (x1, x2) containing X where
!     x1 .GE. 0.01269
!
10 x2 = 10.1269
do i = 1,4
   if (cmplex) go to 20
   call xcond(fun,x2,right,num1,ierr)
   num = num + num1
   if (.not. right) go to 21
20 call acond(fun,x2,right,num1,ierr)
   num = num + num1
   if (right) go to 50
   cmplex = .true.
21 x1 = x2
   x2 = 10.0*x2
end do
go to 100
!
!     Search for an interval (x1, x2) containing X where
!     x2 .LE. 0.01269
!
30 x2 = x1
x1 = -.100358
do i = 1,6
   call xcond(fun,x1,right,num1,ierr)
   num = num + num1
   if (.not. right) go to 50
   call acond(fun,x1,right,num1,ierr)
   num = num + num1
   if (.not. right) go to 45
   x2 = x1
   x1 = 10.0*x1
end do
go to 100
!
45 cmplex = .true.
!
!     Search for X in the interval (x1, x2) by bisection
!
50 dx = x2 - x1
xbar = x1 + dx/2.0
xm = max(abs(x1), abs(x2))
tol = eta
if (xm > 1.0) tol = eta*xm
iend = dx <= tol
!
if (cmplex) go to 60
call xcond(fun,xbar,right,num1,ierr)
num = num + num1
if (right) go to 60
if (iend) go to 80
x1 = xbar
go to 50
!
60 call acond(fun,xbar,right,num1,ierr)
num = num + num1
if (right) go to 70
if (iend) go to 80
x1 = xbar
cmplex = .true.
go to 50
70 x2 = xbar
if (.not. iend) go to 50
!
!     Standard termination
!
80 c = x2
return
!
!     Error return when X cannot be found in (-1.E4, 1.E4)
!
100 c = 0.0
ierr = 2
end subroutine abcon1

subroutine acond(fun, x, cond, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real, intent(in) :: x
logical, intent(inout) :: cond
external fun
integer :: ier, ier1, ier2, iwk(100), n, num1, num2
real :: a, c, error1, error2, wk(400), y, z1, z2
real :: acondg
real :: acondf
external acondf, acondg
integer, parameter :: l = 100
integer, parameter :: m = 400
real, parameter :: aerr = 1.e-30
real, parameter :: rerr = 1.e-4
real, parameter :: tol = 1.e-4
!-----------------------------------------------------------------------
!
!        This subroutine tests whether or not a given value of x
!        lies to the right of the abscissa of convergence of the
!        complex function defined by fun when no singularities lie
!        on the real axis.
!
!                      ----------------
!
!     Fun is a real subroutine defined by the user.  The actual name
!     for fun needs to be declared external in the driver program.
!     Fun has the arguments x, y, A, and B.
!
!     x is a real number. The logical variable cond = .TRUE. if
!     x .GT. c, where c is the abscissa of convergence, and .FALSE.
!     IF x .LT. c.
!
!     num is a variable. On output it has for its value the number
!     of evaluations of fun that were performed.
!
!     ierr is an output integer indicating the status of the
!     calculation. It is assigned values as follows...
!
!        ierr = 0   The calculation was successful.
!
!        ierr = 1   The calculation of cond may not be
!                   accurate for all values of x.
!
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
c = x
!
!     Calculation of the integral of acondf from x to infinity.
!
call qagi1(acondf,fun,y,c,x,1,aerr,rerr,z1,error1,num1,ier1, &
   & l,m,n,iwk,wk)
!
!     Calculation of the integral of acondg from 0 to infinity.
!
a = 0.0
call qagi1(acondg,fun,y,c,a,1,aerr,rerr,z2,error2,num2,ier2, &
   & l,m,n,iwk,wk)
num = num1 + num2
ier = max(ier1, ier2)
!
!     Determination of cond.
!
cond = .false.
if (abs(z1 - z2) <= tol*max(abs(z1),abs(z2))) cond = .true.
!
!     Set ierr and return
!
ierr = 0
if (ier > 4) ierr = 1
end subroutine acond

function acondf(x, y, c, fun)
implicit none
real, intent(in) :: c
real :: x
real, intent(in) :: y
external fun
real :: a, b, t
real :: acondf
!-----------------------------------------------------------------------
!        acondf is the function integrated along the x-axis in
!        acond. y is a dummy variable.
!-----------------------------------------------------------------------
!
call fun(x, 0.0, a, b)
t = 1.0/((x - c) + 1.0)
acondf = a*t*t
end function acondf

function acondg(x, y, c, fun)
implicit none
real :: c, x
real, intent(in) :: y
external fun
real :: a, b, s, t, u, v
real :: acondg
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
end interface
!-----------------------------------------------------------------------
!        acondg is the function integrated along the line x = c
!        in acond. y is a dummy variable.
!-----------------------------------------------------------------------
!
call fun(c, x, a, b)
call crec(1.0, x, s, t)
u = s*s - t*t
v = 2.0*s*t
acondg = -(a*v + b*u)
end function acondg

subroutine xcond(fun, x, cond, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real :: x
logical, intent(out) :: cond
external fun
integer :: iwk(100), n
real :: c, error, t, wk(400), y, y1, z
real :: xcondy
real :: xcondx
external xcondx, xcondy
integer, parameter :: l = 100
integer, parameter :: m = 400
real, parameter :: aerr = 1.e-30
real, parameter :: rerr = 1.e-4
real, parameter :: tol = 1.e-4
real, parameter :: epsr = 1.e-2
!-----------------------------------------------------------------------
!
!        This subroutine tests whether or not a given value of x
!        lies to the right of all singularities of the complex
!        function defined by fun which lie on the real axis.
!
!                         ------------
!
!     Fun is a real subroutine defined by the user.  The actual name
!     for fun needs to be declared external in the driver program.
!     Fun has the arguments x, y, A, and B.
!
!     x is a real number.  The logical variable cond = .True if
!     x .GT. c, where c is the abscissa of the singularity on the
!     REAL AXIS WHICH LIES FARTHEST TO THE RIGHT, AND .FALSE. IF
!     x .LT. c.
!
!     num is a variable. On output it has for its value the number
!     of evaluations of fun that were performed.
!
!     ierr is an output integer indicating the status of the
!     calculation.  It is assigned values as follows...
!
!        ierr = 0   The calculation was successful.
!
!        ierr = 1   The calculation of cond may not be
!                   accurate for all values of x.
!
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
c = 1.0 - x
y = epsr
cond = .false.
!
!     Numerical integration of the imaginary part of the integrand
!     along the line y = epsr.
!
call qagi1(xcondy,fun,y,c,x,1,aerr,rerr,z,error,num,ierr, &
   & l,m,n,iwk,wk)
if (ierr /= 0) go to 100
!
!     Determination of cond.
!
y1 = 0.5*y
t = (xcondx(x,y,c,fun) + 4.0*xcondx(x,y1,c,fun) + &
   & xcondx(x,0.0,c,fun))*epsr/6.0
num = num + 3
if (t*z > 0.0) return
if (abs(t + z) > tol*max(abs(t), abs(z))) return
cond = .true.
return
!
!     Error return
!
100 ierr = 1
end subroutine xcond

function xcondx(x,y,c,fun)
implicit none
real, intent(in) :: c
real :: x, y
external fun
real :: a, b, s, t, u, v
real :: xcondx
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
end interface
!
!     Real part of the integrand in xcond
!
!
call fun(x, y, a, b)
call crec(x + c, y, s, t)
u = s*s - t*t
v = 2.0*s*t
xcondx = a*u - b*v
end function xcondx

function xcondy(x,y,c,fun)
implicit none
real, intent(in) :: c
real :: x, y
external fun
real :: a, b, s, t, u, v
real :: xcondy
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
end interface
!
!     Imaginary part of integrand in xcond
!
!
call fun(x, y, a, b)
call crec(x + c, y, s, t)
u = s*s - t*t
v = 2.0*s*t
xcondy = a*v + b*u
end function xcondy

subroutine lainv1(fun,t,c,epsre,epsab,result,esterr,num, &
   & ier)
implicit none
real, intent(in) :: c, epsab, epsre
real, intent(out) :: esterr, result
real, intent(in) :: t
integer, intent(out) :: ier
integer, intent(out) :: num
real :: a, aim, ak, are, arg, b, bb, e, eps, epsr1, f, fim, fre, &
   & pid16, r, s, si(32), tol
complex :: rex(52), cres, res3la(3)
integer :: i, k, kc, kk, ks, m, nex, nres
integer, parameter :: max = 500
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
! ......................................................................
!
!   1. lainv1
!        inversion of Laplace transform using the Durbin formula
!        in combination with the epsilon algorithm
!
!   2. Purpose
!        the routine calculates an approximation result to the
!        inverse Laplace transform f(t) of fun, for the value
!        of the independent variable equal to t, hopefully
!        satisfying the following claim for accuracy ....
!        abs(f(t)-result).LE.max(epsab,epsre*abs(f(t)))
!
!   3. Calling sequence
!        call lainv1(fun,t,c,epsre,epsab,result,esterr,num,ier)
!
!      Input parameters
!        FUN    - REAL
!                 subroutine defining the Laplace transform as
!                 a complex function.  The calling sequence of
!                 fun is call fun(a,b,c,D) where
!                 a - REAL
!                     real part of the independent variable
!                     of the Laplace transform (input)
!                 b - REAL
!                     imaginary part of the independent
!                     variable of the Laplace transform (input)
!                 c - REAL
!                     real part of the value of the Laplace
!                     transform (OUTPUT)
!                 D - REAL
!                     imaginary part of the value of the
!                     Laplace transform (OUTPUT)
!                 the actual name for fun needs to be declared
!                 external in the driver program.
!
!        t      - REAL
!                 value of the independent variable for which the
!                 inverse Laplace transform has to be computed.
!                 t should be greater than zero.
!
!        c      - REAL
!                 abscissa of convergence of the Laplace transform
!
!        epsre  - REAL
!                 relative accuracy requested.  It is assumed that
!                 epsre .GE. 0.  If one wants accuracy to k significant
!                 figures, then RERR should be set = 10.0**(-k).
!
!        epsab  - REAL
!                 absolute accuracy requested.  It is assumed that
!                 epsab .GE. 0.  The routine tries to satisfy the
!                 least stringent of both accuracy requirements.
!
!      Output parameters
!        result - Real
!                 inverse Laplace transform
!
!        esterr - REAL
!                 estimate of the absolute error abs(f(t)-result)
!
!        num    - INTEGER
!                 number of evaluations of fun
!
!        ier    - INTEGER
!                 parameter giving information on the termination
!                 of the algorithm
!                 ier = 0 Normal and reliable termination of the
!                         routine
!                 ier = 1 The computations are terminated because
!                         the bound on the number of evaluations
!                         of fun has been achieved.  This bound
!                         is equal to 8*max+5 where  max  is A
!                         number initialized in a data
!                         statement.  One can allow more function
!                         evaluations by increasing the value of
!                         max in the data-statement.
!                 ier = 2 The value of t is less than or equal
!                         to zero.
!
!   4. Subroutines or functions needed
!                fun - User provided subroutine
!                cqext - Epsilon algorithm
!                spmpar - This function is called by
!                          cqext, and provides machine constants
!                atan, exp, AMAX1, sin, abs,
!                DBLE, cmplx, real - Fortran functions
!
! ......................................................................
!
!
!   The array si contains values of the sine and cosine functions
!   required in the Durbin formula. si(8) and si(16) are given in
!   the following data statement. The other values are computed.
!
data si(8),si(16)/ 1.0e+00,0.0e+00/
!
!   Max is a bound on the number of terms used in the Durbin
!   formula.
!
! ....................................................
!
!   Eps is a machine dependent constant.  Eps is the
!   smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
! ....................................................
!
!   Calculation of the relative tolerance used.
!
tol = 10.0*eps
epsr1 = amax1(tol,epsre)
!
!   Test on validity of the input parameter t
!
ier = 2
result = 0.0e+00
esterr = 1.0e+00
num = 0
if (t <= 0.0e+00) go to 999
!
!   PID16 is equal to pi/16
!
pid16 = atan(1.0e+00)/4.0e+00
!
!   Computation of the elements of the array si
!
ak = 1.0e+00
do k = 1,7
   si(k) = sin(ak*pid16)
   ak = ak + 1.0e+00
   kk = 16 - k
   si(kk) = si(k)
10 continue
end do
ier = 0
nres = 0
do k = 17,32
   si(k) = -si(k - 16)
end do
!
!   Initialization of the summation of the Durbin formula.
!
arg = pid16/t
are = c + 2.0e+00/t
aim = 0.0e+00
bb = exp(are*t)/(1.6e+01*t)
call fun(are,aim,fre,fim)
num = 5
r = 5.0e-01*fre
s = 0.0
nex = 0
kc = 8
ks = 0
!
!   Main loop for the summation
!
do i = 1,max
   m = 8
   if (i == 1) m = 12
   do k = 1,m
      aim = aim + arg
      kc = kc + 1
      ks = ks + 1
      if (kc > 32) kc = 1
      if (ks > 32) ks = 1
      call fun(are,aim,fre,fim)
      a = fre*si(kc)
      b = -fim*si(ks)
      r = dble(r) + dble(a) + dble(b)
      e = fre*si(ks)
      f = fim*si(kc)
      s = dble(s) + dble(e) + dble(f)
   end do
   num = num + 8
   nex = nex + 1
   rex(nex) = cmplx(r, s)
!
!   Extrapolation using the epsilon algorithm
!
   if (nex >= 3) call cqext(nex,rex,cres,esterr,res3la,nres)
   if (nres < 4) go to 40
!
!   Computation of intermediate result and estimate of the
!   absolute error
!
   result = real(cres)
   result = result * bb
   esterr = esterr * bb
   if (esterr < amax1(epsab,epsr1*abs(result)).and.abs(r*bb - &
      & result) < 5.0e-01*abs(result)) go to 999
40 continue
end do
!
!   Set error flag in the case that the number of terms in the
!   summation is equal to max
!
ier = 1
999 return
end subroutine lainv1

pure subroutine cqext(n,epstab,result,abserr,res3la,nres)
implicit none
real, intent(out) :: abserr
complex, intent(inout) :: epstab(52)
complex, intent(out) :: result
complex, intent(inout) :: res3la(3)
integer, intent(inout) :: n
integer, intent(inout) :: nres
real :: a1, a2, b1, b2, c1, c2, d1, d2, e1abs, epmach, epsinf, &
   & err1, err2, err3, error, oflow, res1, res2
complex :: delta1, delta2, delta3, e0, e1, e2, e3, res, ss
double precision :: r, s, u1, u2, u3, v1, v2, v3, ss1, ss2, w1, w2
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp, newelm, num
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
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
! 1.        cqext
!           epsilon algorithm
!              standard Fortran subroutine
!              complex version
!
! 2.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
!
! 3.        CALLING SEQUENCE
!              call cqext(n,epstab,result,abserr,res3la,nres)
!
!           Parameters
!              n      - INTEGER
!                       epstab(n) contains the new element in the
!                       first column of the epsilon table.
!
!              epstab - COMPLEX
!                       vector of dimension 52 containing the elements
!                       of the two lower diagonals of the
!                       triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!
!              result - Complex
!                       resulting approximation to the integral
!
!              abserr - REAL
!                       estimate of the absolute error of the real
!                       part of result computed from result and
!                       the 3 previous results
!
!              res3la - COMPLEX
!                       vector of dimension 3 containing the last 3
!                       results
!
!              nres   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!
! 4.        SUBROUTINES OR FUNCTIONS NEEDED
!                     - spmpar, cdivid
!                     - Fortran abs, AMAX1, cabs, cmplx,
!                       real, aimag, SNGL
!
!     ..................................................................
!
!
!           List of major variables
!           -----------------------
!
!           e0     - The 4 elements on which the
!           e1       COMPUTATION OF A NEW ELEMENT IN
!           e2       THE EPSILON TABLE IS BASED
!           e3                 e0
!                        e3    e1    NEW
!                              e2
!           newelm - Number of elements to be computed in the new
!                    diagonal
!           ERROR  - ERROR = abs(e1-e0)+abs(e2-e1)+abs(NEW-e2)
!           result - The element in the new diagonal with least value
!                    of error
!
!           Machine dependent constants
!           ---------------------------
!
!           epmach is the largest relative spacing.
!           OFLOW is the largest positive magnitude.
!           limexp is the maximum number of elements the epsilon
!           table can contain. If this number is reached, the upper
!           diagonal of the epsilon table is deleted.
!
!***First executable statement
oflow = spmpar(3)
epmach = spmpar(1)
nres = nres + 1
abserr = oflow
result = epstab(n)
if (n < 3) go to 100
limexp = 50
epstab(n + 2) = epstab(n)
newelm = (n - 1)/2
epstab(n) = cmplx(oflow,0.0)
num = n
k1 = n
do i = 1,newelm
   k2 = k1 - 1
   k3 = k1 - 2
   res = epstab(k1 + 2)
   e0 = epstab(k3)
   e1 = epstab(k2)
   e2 = res
   e1abs = abs(e1)
   a1 = real(e0)
   a2 = aimag(e0)
   b1 = real(e1)
   b2 = aimag(e1)
   c1 = real(e2)
   c2 = aimag(e2)
   err2 = abs(c1 - b1)
   err3 = abs(b1 - a1)
   if (abs(a1 - b1) > epmach*max(abs(a1),abs(b1)) .or. &
      & abs(a2 - b2) > epmach*max(abs(a2),abs(b2))) go to 10
   if (abs(b1 - c1) > epmach*max(abs(b1),abs(c1)) .or. &
      & abs(b2 - c2) > epmach*max(abs(b2),abs(c2))) go to 10
!
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = cabs(e1-e0)+cabs(e2-e1)
!
   result = res
   abserr = err2 + err3
!***Jump out of do-loop
   go to 100
10 e3 = epstab(k1)
   epstab(k1) = e1
   d1 = real(e3)
   d2 = aimag(e3)
   err1 = abs(b1 - d1)
!
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of n
!
   delta1 = e1 - e3
   delta2 = e2 - e1
   delta3 = e1 - e0
   if (abs(delta1) <= epmach*max(e1abs,abs(e3))) go to 20
   if (abs(delta2) <= epmach*max(e1abs,abs(e2))) go to 20
   if (abs(delta3) <= epmach*max(abs(e0),e1abs)) go to 20
   r = real(delta1)
   s = aimag(delta1)
   call cdivid(1.d0,0.d0,r,s,u1,v1)
   r = real(delta2)
   s = aimag(delta2)
   call cdivid(1.d0,0.d0,r,s,u2,v2)
   r = real(delta3)
   s = aimag(delta3)
   call cdivid(1.d0,0.d0,r,s,u3,v3)
   ss1 = u1 + u2 - u3
   ss2 = v1 + v2 - v3
   ss = cmplx(sngl(ss1), sngl(ss2))
   epsinf = abs(ss*e1)
!
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
!
   if (epsinf > 1.0e-04) go to 30
20 n = i + i - 1
!***Jump out of do-loop
   go to 50
!
!           Compute a new element and eventually adjust
!           the value of result.
!
30 call cdivid(1.d0,0.d0,ss1,ss2,w1,w2)
   res1 = real(e1) + sngl(w1)
   res2 = aimag(e1) + sngl(w2)
   res = cmplx(res1,res2)
   epstab(k1) = res
   k1 = k1 - 2
   error = err2 + abs(c1 - real(res)) + err3
   if (error > abserr) go to 40
   abserr = error
   result = res
40 continue
end do
!
!           Shift the table.
!
50 if (n == limexp) n = 2*(limexp/2) - 1
ib = 1
if ((num/2)*2 == num) ib = 2
ie = newelm + 1
do i = 1,ie
   ib2 = ib + 2
   epstab(ib) = epstab(ib2)
   ib = ib2
end do
if (num == n) go to 80
indx = num - n + 1
do i = 1,n
   epstab(i) = epstab(indx)
   indx = indx + 1
end do
80 if (nres >= 4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!
!           Compute error estimate
!
90 abserr = abs(real(result - res3la(3))) + abs(real(result - res3la(2))) &
   & + abs(real(result - res3la(1)))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = max(abserr,5.0e+00*epmach*abs(real(result)))
end subroutine cqext

subroutine qagi1(f,phi,y,c,bound,inf,epsabs,epsrel,result,abserr, &
   & neval,ier,limit,lenw,last,iwork,work)
implicit none
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(out) :: last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(out) :: abserr
real, intent(in) :: bound
real :: c
real, intent(in) :: epsabs, epsrel
real, intent(out) :: result
real :: y
real :: f
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f, phi
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)). f HAS THE
!           arguments X and phi where phi is a function.
!
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!                     f has the arguments X and phi.
!
!            PHI    - REAL
!                     function subprogram having a single real argument.
!                     The actual name for phi must be declared external
!                     in the driver program.
!
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            y      - REAL
!                     parameter for use in xcond.  Ordinate of
!                     horizontal line along which integration
!                     is performed.
!
!            c       - REAL
!                      parameter for use in acond and xcond.
!
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!
!            epsabs - REAL
!                     absolute accuracy requested
!
!            epsrel - REAL
!                     relative accuracy requested
!
!         On return
!            result - Real
!                     approximation to the integral
!
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!
!        Subroutines or functions needed
!              - qagie1
!              - qk15i1
!              - qpsrt
!              - qelg
!              - f (user provided function)
!              - Phi (user provided function)
!              - spmpar
!
!-----------------------------------------------------------------------
!
!         Check validity of limit and lenw.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. lenw < limit*4) return
!
!         Prepare call for qagie1.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call qagie1(f,phi,y,c,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine qagi1

subroutine qagie1(f,phi,y,c,bound,inf,epsabs,epsrel,limit,result, &
   & abserr,neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
real, intent(out) :: abserr
real, intent(inout) :: alist(limit), blist(limit)
real, intent(in) :: bound
real :: c
real, intent(inout) :: elist(limit)
real, intent(in) :: epsabs, epsrel
real, intent(out) :: result
real, intent(inout) :: rlist(limit)
real :: y
real :: f
external f, phi
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, &
   & ktmin, maxerr, nres, nrmax, numrl2
real :: a1, a2, abseps, area, area1, area12, area2, b1, b2, boun, &
   & correc, defab1, defab2, defabs, dres, epmach, erlarg, erlast, &
   & errbnd, errmax, erro12, error1, error2, errsum, ertest, oflow, &
   & rerr, res3la(3), resabs, reseps, rlist2(52), small, t, uflow
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!                     f has the arguments X and phi.
!
!            PHI    - REAL
!                     function subprogram having a single real argument.
!                     The actual name for phi must be declared external
!                     in the driver program.
!
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            y      - REAL
!                     parameter for use in xcond.  Ordinate of
!                     horizontal line along which integration
!                     is performed.
!
!            c      - REAL
!                     parameter for use in acond and xcond.
!
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!
!            epsabs - REAL
!                     absolute accuracy requested
!
!            epsrel - REAL
!                     relative accuracy requested
!
!            limit  - Integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     limit.GE.1
!
!         On return
!            result - Real
!                     approximation to the integral
!
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             elist(1) and iord(1) are set to zero.
!                             alist(1) and blist(1) are set to 0
!                             and 1 respectively.
!
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            elist  - REAL
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!
!            iord   - INTEGER
!                     vector of dimension limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!
!            last   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!
!        Subroutines or functions needed
!              - qk15i1
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - Phi (user-provided function)
!              - spmpar
!
!-----------------------------------------------------------------------
!
dimension iord(limit)
!
!
!            The dimension of RLIST2 is determined by the value of
!            LIMEXP in subroutine qelg.
!
!
!            List of major variables
!            -----------------------
!
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           RLIST2    - Array of dimension at least (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           MAXERR    - Pointer to the interval with largest error
!                       estimate
!           ERRMAX    - elist(MAXERR)
!           ERLAST    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           ERRBND    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left subinterval
!           *****2    - Variable for the right subinterval
!           last      - Index for subdivision
!           NRES      - Number of calls to the extrapolation routine
!           NUMRL2    - Number of elements currently in RLIST2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       RLIST2(NUMRL2) after NUMRL2 has been increased
!                       by one.
!           Small     - Length of the smallest interval considered up
!                       to now, multiplied by 1.5
!           ERLARG    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of ERLARG.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (TRUE-VALUE)
!
!            Machine dependent constants
!            ---------------------------
!
!           EPMACH is the largest relative spacing.
!           UFLOW is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!           Test on validity of parameters
!           -----------------------------
!
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = 0.0
blist(1) = 1.0
rlist(1) = 0.0
elist(1) = 0.0
iord(1) = 0
ier = 6
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach, 0.5e-14)
!
!           First approximation to the integral
!           -----------------------------------
!
!           Determine the interval to be mapped onto (0,1).
!           If inf = 2 The integral is computed as I = I1+I2, where
!           I1 = Integral of f over (-INFINITY,0),
!           I2 = Integral of f over (0,+INFINITY).
!
boun = bound
if (inf == 2) boun = 0.0
call qk15i1(f, phi, y, c, boun, inf, 0.0, 1.0, result, abserr, &
   & defabs, resabs, epmach, uflow)
!
!           Test on accuracy
!
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
if (abserr <= 100.0*epmach*defabs .and. abserr > errbnd) &
   & ier = 2
if (limit == 1) ier = 1
if (ier /= 0 .or. (abserr <= errbnd .and. abserr /= resabs) &
   & .or. abserr == 0.0) go to 130
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.0
nrmax = 1
nres = 0
ktmin = 0
numrl2 = 2
extrap = .false.
noext = .false.
ierro = 0
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do last = 2,limit
!
!           Bisect the subinterval with NRMAX-TH largest
!           error estimate.
!
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qk15i1(f, phi, y, c, boun, inf, a1, b1, area1, error1, &
      & resabs, defab1, epmach, uflow)
   call qk15i1(f, phi, y, c, boun, inf, a2, b2, area2, error2, &
      & resabs, defab2, epmach, uflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!
!           Test for roundoff error and eventually
!           set error flag.
!
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!
!           Set error flag in the case that the number of
!           subintervals equals limit.
!
   if (last == limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.
!
   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
   if (error2 > error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   go to 30
20 alist(maxerr) = a2
   alist(last) = a1
   blist(last) = b1
   rlist(maxerr) = area2
   rlist(last) = area1
   elist(maxerr) = error2
   elist(last) = error1
!
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with NRMAX-TH largest error estimate (to be
!           bisected next).
!
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
   if (errsum <= errbnd) go to 115
   if (ier /= 0) go to 100
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3.or.erlarg <= ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (ERLARG) and perform
!           extrapolation.
!
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
50    continue
   end do
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5.and.abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
   if (abserr <= ertest) go to 100
!
!            Prepare bisection of the smallest interval.
!
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) go to 100
   maxerr = iord(1)
   errmax = elist(maxerr)
   nrmax = 1
   extrap = .false.
   small = small*0.5e+00
   erlarg = errsum
   go to 90
80 small = 0.375e+00
   erlarg = errsum
   ertest = errbnd
   rlist2(2) = area
90 continue
end do
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!
!           Test on divergence
!
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area) .or. (result/area) > 0.1e+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf == 2) neval = 2*neval
if (ier > 2) ier = ier - 1
999 return
end subroutine qagie1

subroutine qk15i1(f, phi, y, c, boun, inf, a, b, result, abserr, &
   & resabs, resasc, epmach, uflow)
implicit none
integer, intent(in) :: inf
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, boun
real :: c
real, intent(in) :: epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
real :: y
real :: f
external f, phi
integer :: j
real :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, hlgth, resg, resk, reskh, tabsc1, tabsc2, tol, fv1(7), fv2(7)
real, parameter :: xgk(8) = [0.9914553711208126e+00, 0.9491079123427585e+00, 0.8648644233597691e+00, &
   & 0.7415311855993944e+00, 0.5860872354676911e+00, 0.4058451513773972e+00, 0.2077849550078985e+00, 0.0000000000000000e+00]
real, parameter :: wgk(8) = [0.2293532201052922e-01, 0.6309209262997855e-01, 0.1047900103222502e+00, &
   & 0.1406532597155259e+00, 0.1690047266392679e+00, 0.1903505780647854e+00, 0.2044329400752989e+00, 0.2094821410847278e+00]
real, parameter :: wg(8) = [0.0000000000000000e+00, 0.1294849661688697e+00, 0.0000000000000000e+00, 0.2797053914892767e+00 &
   & , 0.0000000000000000e+00, 0.3818300505051189e+00, 0.0000000000000000e+00, 0.4179591836734694e+00]
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (a,b) is a part of (0,1).
!              It is the purpose to compute
!              I = Integral of transformed integrand over (a,b),
!              j = Integral of abs(transformed integrand) over (a,b).
!
! 2.        PARAMETERS
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program. f has the arguments X and
!                       phi.
!
!              PHI    - REAL
!                       function subprogram having a single real
!                       argument. The actual name for phi must be
!                       dechared external in the driver program.
!
!              boun   - REAL
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF inf = +2)
!
!              inf    - INTEGER
!                       if inf = -1, the original interval is
!                                   (-INFINITY,BOUND),
!                       if inf = +1, the original interval is
!                                   (BOUND,+INFINITY),
!                       if inf = +2, the original interval is
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!
!              a      - REAL
!                       lower limit for integration over subrange
!                       of (0,1)
!
!              b      - REAL
!                       upper limit for integration over subrange
!                       of (0,1)
!
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              uflow  - REAL
!                       the smallest positive magnitude.
!
!            On return
!              result - Real
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod rule(RESK) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(RESG).
!
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed abs(I-result)
!
!              resabs - REAL
!                       approximation to the integral j
!
!              resasc - REAL
!                       approximation to the integral of
!                       abs((transformed integrand)-I/(b-a))
!                       OVER (a,b)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!                 - Phi (user-provided function)
!
!-----------------------------------------------------------------------
!
!
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!
!           xgk    - Abscissae of the 15-point Kronrod rule
!                    xgk(2), xgk(4), ... abscissae of the 7-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!
!           wgk    - Weights of the 15-point Kronrod rule
!
!           wg     - Weights of the 7-point Gauss rule, corresponding
!                    to the abscissae xgk(2), xgk(4), ...
!                    wg(1), wg(3), ... are set to zero.
!
!
!
!
!
!           List of major variables
!           -----------------------
!
!           centr  - Mid point of the interval
!           HLGTH  - Half-length of the interval
!           absc*  - ABSCISSA
!           TABSC* - Transformed abscissa
!           FVAL*  - Function VALUE
!           RESG   - result of the 7-point Gauss formula
!           RESK   - result of the 15-point Kronrod formula
!           RESKH  - Approximation to the mean value of the transformed
!                    integrand over (a,b), I.E. to I/(b-a)
!
!
dinf = min(1,inf)
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1,y,c,phi)
if (inf == 2) fval1 = fval1 + f(-tabsc1,y,c,phi)
fc = (fval1/centr)/centr
!
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
!
resg = wg(8)*fc
resk = wgk(8)*fc
resabs = abs(resk)
do j = 1,7
   absc = hlgth*xgk(j)
   absc1 = centr - absc
   absc2 = centr + absc
   tabsc1 = boun + dinf*(1.0 - absc1)/absc1
   tabsc2 = boun + dinf*(1.0 - absc2)/absc2
   fval1 = f(tabsc1,y,c,phi)
   fval2 = f(tabsc2,y,c,phi)
   if (inf == 2) fval1 = fval1 + f(-tabsc1,y,c,phi)
   if (inf == 2) fval2 = fval2 + f(-tabsc2,y,c,phi)
   fval1 = (fval1/absc1)/absc1
   fval2 = (fval2/absc2)/absc2
   fv1(j) = fval1
   fv2(j) = fval2
   fsum = fval1 + fval2
   resg = resg + wg(j)*fsum
   resk = resk + wgk(j)*fsum
   resabs = resabs + wgk(j)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5
resasc = wgk(8)*abs(fc - reskh)
do j = 1,7
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + &
      & abs(fv2(j) - reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.0 .and. abserr /= 0.0) abserr = resasc* &
   & min(1.0, (0.2e+03*abserr/resasc)**1.5)
tol = 50.0*epmach
if (resabs > uflow/tol) abserr = max(abserr, tol*resabs)
end subroutine qk15i1

subroutine fft(c,n,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: isn, n
real, intent(inout) :: c(*)
!-----------------------------------------------------------------------
!     The complex array c of dimension n is interpreted by the code
!     as a real array of dimension 2*n. if this association is not
!     permitted by the Fortran being used, then the user may use the
!     SUBROUTINE fft1.
!-----------------------------------------------------------------------
if (abs(isn) /= 1) go to 10
call sfft(c(1),c(2),n,n,n,isn + isn,ierr)
return
10 ierr = 4
end subroutine fft

subroutine fft1(a,b,n,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: isn, n
real, intent(inout) :: a(n), b(n)
!     ------------
if (abs(isn) /= 1) go to 10
call sfft(a,b,n,n,n,isn,ierr)
return
10 ierr = 4
end subroutine fft1

subroutine mfft(c,n,ndim,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: isn, ndim
real, intent(inout) :: c(*)
integer :: n(ndim)
integer :: i, isign, nspan, ntot
!-----------------------------------------------------------------------
!     Let ntot denote the product of n(1),...,n(ndim). The complex
!     array c of dimension ntot is interpreted by the routine as
!     a real array of dimension 2*ntot. If this association is not
!     permitted by the Fortran being used, then the user may use
!     the subroutine mfft1.
!-----------------------------------------------------------------------
if (abs(isn) /= 1) go to 40
if (ndim <= 0) go to 50
ntot = 1
do i = 1,ndim
   ntot = n(i)*ntot
end do
if (ntot < 1) go to 30
!
isign = isn + isn
nspan = 1
do i = 1,ndim
   nspan = n(i)*nspan
   call sfft(c(1),c(2),ntot,n(i),nspan,isign,ierr)
   if (ierr /= 0) return
end do
return
!
30 ierr = 1
return
40 ierr = 4
return
50 ierr = 5
end subroutine mfft

subroutine mfft1(a,b,n,ndim,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: isn
integer, intent(in) :: ndim
real, intent(inout) :: a(*), b(*)
integer :: n(ndim)
integer :: i, nspan, ntot
!     ------------
if (abs(isn) /= 1) go to 40
if (ndim <= 0) go to 50
ntot = 1
do i = 1,ndim
   ntot = n(i)*ntot
end do
if (ntot < 1) go to 30
!
nspan = 1
do i = 1,ndim
   nspan = n(i)*nspan
   call sfft(a,b,ntot,n(i),nspan,isn,ierr)
   if (ierr /= 0) return
end do
return
!
30 ierr = 1
return
40 ierr = 4
return
50 ierr = 5
end subroutine mfft1

subroutine sfft(a,b,ntot,n,nspan,isn,ierr)
implicit none
integer :: ierr, isn, n, nspan, ntot
real :: a(*), b(*)
integer :: i, ii, inc, j, jc, jf, jj, k, k1, k2, k3, k4, kk, ks, &
   & kspan, kspnn, kt, l, m, max, maxf, maxn, maxp, nfac(15), nn, &
   & np(209), nt, num
real :: aa, aj, ajm, ajp, ak, akm, akp, at(23), bb, bj, bjm, bjp, &
   & bk, bkm, bkp, bt(23), c1, c2, c3, c72, cd, ck(23), rad, radf, s1, &
   & s120, s2, s3, s72, sd, sk(23), u, v
integer :: nswc_ai_i4
!  Multivariate complex Fourier transform, computed in place
!    using mixed-radix fast Fourier transform algorithm.
!  By R. C. Singleton, Stanford Research Institute, oct. 1968
!    modified by A. H. Morris, NSWC/DL, Dahlgren VA
!  arrays A and b originally hold the real and imaginary
!    components of the data, and return the real and
!    imaginary components of the resulting Fourier coefficients.
!  Multivariate data is indexed according to the Fortran
!    array element successor function, without limit
!    on the number of implied multiple subscripts.
!    The subroutine is called once for each variate.
!    The calls for a multivariate transform may be in any order.
!  ntot is the total number of complex data values.
!  n is the dimension of the current variable.
!  nspan/n is the spacing of consecutive data values
!    while indexing the current variable.
!  The sign of isn determines the sign of the complex
!    exponential, and the magnitude of isn is normally one.
!  A TRI-variate transform with a(N1,N2,N3), b(N1,N2,N3)
!    is computed by
!      call sfft(a,b,n1*n2*n3,n1,n1,1,ierr)
!      call sfft(a,b,n1*n2*n3,n2,n1*n2,1,ierr)
!      call sfft(a,b,n1*n2*n3,n3,n1*n2*n3,1,ierr)
!  for a single-variate transform,
!    ntot = n = nspan = (number of complex data values), E.G.
!      call sfft(a,b,n,n,n,1,ierr)
!  the data may alternatively be stored in a single complex
!    array a, then the magnitude of isn changed to two to
!    give the correct indexing increment and a(2) used to
!    pass the initial address for the sequence of imaginary
!    values, E.G.
!      call sfft(a,a(2),ntot,n,nspan,2,ierr)
!  arrays NFAC(MAXN),NP(MAXP),at(MAXF),ck(MAXF),BT(MAXF),SK(MAXF)
!    are used for temporary storage.
!    MAXN must be .GE. the number of factors of n
!    MAXF must be .GE. the maximum prime factor of n.
!    MAXP must be .GT. the number of prime factors of n.
!    In addition, MAXN is assumed to be odd.
!    If the square-free portion k of n has two or more prime
!    factors, then MAXP must be .GE. k-1.
!  ierr is a variable. ierr is set to 0 if no input errors are
!    detected. Otherwise, ierr is assigned one of the values
!      ierr=1    n is less than 1
!      ierr=2    n has more than MAXN factors
!      ierr=3    n has a prime factor greater than
!                MAXF or the square-free portion of
!                n is greater than MAXP+1
!  array storage in NFAC for a maximum of 15 factors of n.
!  If n has more than one square-free factor, the product of the
!    square-free factors must be .LE. 210
!  array storage for maximum prime factor of 23
equivalence (i,ii)
!  The following constants should agree with the array dimensions.
maxn = 15
maxf = 23
maxp = 209
!  Set the following constants
!     rad=2.0*pi
!     s72=sin(rad/5.0)
!     c72=cos(rad/5.0)
!     s120=sqrt(0.75)
rad = 6.2831853071796
s72 = .951056516295154
c72 = .309016994374947
s120 = .86602540378444
!
ierr = 0
nswc_ai_i4 = n - 1
if ( nswc_ai_i4 < 0 ) go to 1000
if ( nswc_ai_i4 == 0 ) go to 960
go to 5
5 inc = isn
if (isn >= 0) go to 10
s72 = -s72
s120 = -s120
rad = -rad
inc = -inc
10 nt = inc*ntot
ks = inc*nspan
kspan = ks
nn = nt - inc
jc = ks/n
radf = rad*float(jc)*0.5
i = 0
jf = 0
!  Determine the factors of n
m = 0
k = n
max = maxn/2
go to 20
15 if (m == max) go to 1001
m = m + 1
nfac(m) = 4
k = l
20 l = k/16
if (k == l*16) go to 15
j = 3
jj = 9
go to 30
25 if (m == max) go to 1001
m = m + 1
nfac(m) = j
k = k/jj
30 if (mod(k,jj) == 0) go to 25
j = j + 2
jj = j**2
if (j <= maxf .and. jj <= k) go to 30
if (k > 4) go to 40
kt = m
nfac(m + 1) = k
if (k /= 1) m = m + 1
go to 80
40 l = k/4
if (k /= l*4) go to 50
if (m == max) go to 1001
m = m + 1
nfac(m) = 2
k = l
kt = m
if (k == 1) go to 85
50 kt = m
if (k - 1 > maxp) go to 1002
num = maxn - kt - kt
j = 2
60 if (mod(k,j) /= 0) go to 70
m = m + 1
nfac(m) = j
num = num - 1
k = k/j
if (k == 1) go to 80
if (num <= 0) go to 1001
70 l = (j + 1)/2
j = l + l + 1
if (j <= maxf) go to 60
go to 1002
80 if (kt == 0) go to 100
85 j = kt
90 m = m + 1
nfac(m) = nfac(j)
j = j - 1
if (j /= 0) go to 90
!  Compute Fourier transform
100 sd = radf/float(kspan)
cd = 2.0*sin(sd)**2
sd = sin(sd + sd)
kk = 1
i = i + 1
if (nfac(i) /= 2) go to 400
!  Transform for factor of 2 (including rotation factor)
kspan = kspan/2
k1 = kspan + 2
210 k2 = kk + kspan
ak = a(k2)
bk = b(k2)
a(k2) = a(kk) - ak
b(k2) = b(kk) - bk
a(kk) = a(kk) + ak
b(kk) = b(kk) + bk
kk = k2 + kspan
if (kk <= nn) go to 210
kk = kk - nn
if (kk <= jc) go to 210
if (kk > kspan) go to 800
220 c1 = 1.0 - cd
s1 = sd
230 k2 = kk + kspan
ak = a(kk) - a(k2)
bk = b(kk) - b(k2)
a(kk) = a(kk) + a(k2)
b(kk) = b(kk) + b(k2)
a(k2) = c1*ak - s1*bk
b(k2) = s1*ak + c1*bk
kk = k2 + kspan
if (kk < nt) go to 230
k2 = kk - nt
c1 = -c1
kk = k1 - k2
if (kk > k2) go to 230
u = sd*s1 + cd*c1
v = sd*c1 - cd*s1
ak = c1 - u
s1 = s1 + v
!  The following three statements compensate for truncation error.
!    If rounded arithmetic is used then one may substitute
!     c1=ak
c1 = 1.5 - 0.5*(ak*ak + s1*s1)
s1 = c1*s1
c1 = c1*ak
kk = kk + jc
if (kk < k2) go to 230
k1 = k1 + inc + inc
kk = (k1 - kspan)/2 + jc
if (kk <= jc + jc) go to 220
go to 100
!  Transform for factor of 3 (optional code)
320 k1 = kk + kspan
k2 = k1 + kspan
ak = a(kk)
bk = b(kk)
aj = a(k1) + a(k2)
bj = b(k1) + b(k2)
a(kk) = ak + aj
b(kk) = bk + bj
ak = -0.5*aj + ak
bk = -0.5*bj + bk
aj = (a(k1) - a(k2))*s120
bj = (b(k1) - b(k2))*s120
a(k1) = ak - bj
b(k1) = bk + aj
a(k2) = ak + bj
b(k2) = bk - aj
kk = k2 + kspan
if (kk < nn) go to 320
kk = kk - nn
if (kk <= kspan) go to 320
go to 700
!  Transform for factor of 4
400 if (nfac(i) /= 4) go to 600
kspnn = kspan
kspan = kspan/4
410 c1 = 1.0
s1 = 0.0
420 k1 = kk + kspan
k2 = k1 + kspan
k3 = k2 + kspan
akp = a(kk) + a(k2)
akm = a(kk) - a(k2)
ajp = a(k1) + a(k3)
ajm = a(k1) - a(k3)
a(kk) = akp + ajp
ajp = akp - ajp
bkp = b(kk) + b(k2)
bkm = b(kk) - b(k2)
bjp = b(k1) + b(k3)
bjm = b(k1) - b(k3)
b(kk) = bkp + bjp
bjp = bkp - bjp
if (isn < 0) go to 450
akp = akm - bjm
akm = akm + bjm
bkp = bkm + ajm
bkm = bkm - ajm
if (s1 == 0.0) go to 460
430 a(k1) = akp*c1 - bkp*s1
b(k1) = akp*s1 + bkp*c1
a(k2) = ajp*c2 - bjp*s2
b(k2) = ajp*s2 + bjp*c2
a(k3) = akm*c3 - bkm*s3
b(k3) = akm*s3 + bkm*c3
kk = k3 + kspan
if (kk <= nt) go to 420
440 u = sd*s1 + cd*c1
v = sd*c1 - cd*s1
c2 = c1 - u
s1 = s1 + v
!  The following three statements compensate for truncation error.
!    If rounded arithmetic is used then one may substitute
!     c1=c2
c1 = 1.5 - 0.5*(c2*c2 + s1*s1)
s1 = c1*s1
c1 = c1*c2
c2 = c1*c1 - s1*s1
s2 = 2.0*c1*s1
c3 = c2*c1 - s2*s1
s3 = c2*s1 + s2*c1
kk = kk - nt + jc
if (kk <= kspan) go to 420
kk = kk - kspan + inc
if (kk <= jc) go to 410
if (kspan == jc) go to 800
go to 100
450 akp = akm + bjm
akm = akm - bjm
bkp = bkm - ajm
bkm = bkm + ajm
if (s1 /= 0.0) go to 430
460 a(k1) = akp
b(k1) = bkp
a(k2) = ajp
b(k2) = bjp
a(k3) = akm
b(k3) = bkm
kk = k3 + kspan
if (kk <= nt) go to 420
go to 440
!  Transform for factor of 5 (optional code)
510 c2 = c72**2 - s72**2
s2 = 2.0*c72*s72
520 k1 = kk + kspan
k2 = k1 + kspan
k3 = k2 + kspan
k4 = k3 + kspan
akp = a(k1) + a(k4)
akm = a(k1) - a(k4)
bkp = b(k1) + b(k4)
bkm = b(k1) - b(k4)
ajp = a(k2) + a(k3)
ajm = a(k2) - a(k3)
bjp = b(k2) + b(k3)
bjm = b(k2) - b(k3)
aa = a(kk)
bb = b(kk)
a(kk) = aa + akp + ajp
b(kk) = bb + bkp + bjp
ak = akp*c72 + ajp*c2 + aa
bk = bkp*c72 + bjp*c2 + bb
aj = akm*s72 + ajm*s2
bj = bkm*s72 + bjm*s2
a(k1) = ak - bj
a(k4) = ak + bj
b(k1) = bk + aj
b(k4) = bk - aj
ak = akp*c2 + ajp*c72 + aa
bk = bkp*c2 + bjp*c72 + bb
aj = akm*s2 - ajm*s72
bj = bkm*s2 - bjm*s72
a(k2) = ak - bj
a(k3) = ak + bj
b(k2) = bk + aj
b(k3) = bk - aj
kk = k4 + kspan
if (kk < nn) go to 520
kk = kk - nn
if (kk <= kspan) go to 520
go to 700
!  Transform for odd factors
600 k = nfac(i)
kspnn = kspan
kspan = kspan/k
if (k == 3) go to 320
if (k == 5) go to 510
if (k == jf) go to 640
jf = k
s1 = rad/float(k)
c1 = cos(s1)
s1 = sin(s1)
ck(jf) = 1.0
sk(jf) = 0.0
j = 1
630 ck(j) = ck(k)*c1 + sk(k)*s1
sk(j) = ck(k)*s1 - sk(k)*c1
k = k - 1
ck(k) = ck(j)
sk(k) = -sk(j)
j = j + 1
if (j < k) go to 630
640 k1 = kk
k2 = kk + kspnn
aa = a(kk)
bb = b(kk)
ak = aa
bk = bb
j = 1
k1 = k1 + kspan
650 k2 = k2 - kspan
j = j + 1
at(j) = a(k1) + a(k2)
ak = at(j) + ak
bt(j) = b(k1) + b(k2)
bk = bt(j) + bk
j = j + 1
at(j) = a(k1) - a(k2)
bt(j) = b(k1) - b(k2)
k1 = k1 + kspan
if (k1 < k2) go to 650
a(kk) = ak
b(kk) = bk
k1 = kk
k2 = kk + kspnn
j = 1
660 k1 = k1 + kspan
k2 = k2 - kspan
jj = j
ak = aa
bk = bb
aj = 0.0
bj = 0.0
k = 1
670 k = k + 1
ak = at(k)*ck(jj) + ak
bk = bt(k)*ck(jj) + bk
k = k + 1
aj = at(k)*sk(jj) + aj
bj = bt(k)*sk(jj) + bj
jj = jj + j
if (jj > jf) jj = jj - jf
if (k < jf) go to 670
k = jf - j
a(k1) = ak - bj
b(k1) = bk + aj
a(k2) = ak + bj
b(k2) = bk - aj
j = j + 1
if (j < k) go to 660
kk = kk + kspnn
if (kk <= nn) go to 640
kk = kk - nn
if (kk <= kspan) go to 640
!  Multiply by rotation factor (except for factors of 2 and 4)
700 if (i == m) go to 800
kk = jc + 1
710 c2 = 1.0 - cd
s1 = sd
720 c1 = c2
s2 = s1
kk = kk + kspan
730 ak = a(kk)
a(kk) = c2*ak - s2*b(kk)
b(kk) = s2*ak + c2*b(kk)
kk = kk + kspnn
if (kk <= nt) go to 730
ak = s1*s2
s2 = s1*c2 + c1*s2
c2 = c1*c2 - ak
kk = kk - nt + kspan
if (kk <= kspnn) go to 730
u = sd*s1 + cd*c1
v = sd*c1 - cd*s1
c2 = c1 - u
s1 = s1 + v
!  The following three statements compensate for truncation
!    error.  If rounded arithmetic is used then they may
!    be deleted.
c1 = 1.5 - 0.5*(c2*c2 + s1*s1)
s1 = c1*s1
c2 = c1*c2
kk = kk - kspnn + jc
if (kk <= kspan) go to 720
kk = kk - kspan + jc + inc
if (kk <= jc + jc) go to 710
go to 100
!  Permute the results to normal order---done in two stages
!  permutation for square factors of n
800 np(1) = ks
if (kt == 0) go to 890
k = kt + kt + 1
if (m < k) k = k - 1
j = 1
np(k + 1) = jc
810 np(j + 1) = np(j)/nfac(j)
np(k) = np(k + 1)*nfac(j)
j = j + 1
k = k - 1
if (j < k) go to 810
k3 = np(k + 1)
kspan = np(2)
kk = jc + 1
k2 = kspan + 1
j = 1
if (n /= ntot) go to 850
!  Permutation for single-variate transform (optional code)
820 ak = a(kk)
a(kk) = a(k2)
a(k2) = ak
bk = b(kk)
b(kk) = b(k2)
b(k2) = bk
kk = kk + inc
k2 = kspan + k2
if (k2 < ks) go to 820
830 k2 = k2 - np(j)
j = j + 1
k2 = np(j + 1) + k2
if (k2 > np(j)) go to 830
j = 1
840 if (kk < k2) go to 820
kk = kk + inc
k2 = kspan + k2
if (k2 < ks) go to 840
if (kk < ks) go to 830
jc = k3
go to 890
!  Permutation for multivariate transform
850 k = kk + jc
860 ak = a(kk)
a(kk) = a(k2)
a(k2) = ak
bk = b(kk)
b(kk) = b(k2)
b(k2) = bk
kk = kk + inc
k2 = k2 + inc
if (kk < k) go to 860
kk = kk + ks - jc
k2 = k2 + ks - jc
if (kk < nt) go to 850
k2 = k2 - nt + kspan
kk = kk - nt + jc
if (k2 < ks) go to 850
870 k2 = k2 - np(j)
j = j + 1
k2 = np(j + 1) + k2
if (k2 > np(j)) go to 870
j = 1
880 if (kk < k2) go to 850
kk = kk + jc
k2 = kspan + k2
if (k2 < ks) go to 880
if (kk < ks) go to 870
jc = k3
890 if (2*kt + 1 >= m) return
kspnn = np(kt + 1)
!  Permutation for square-free factors of n
j = m - kt
nfac(j + 1) = 1
900 nfac(j) = nfac(j)*nfac(j + 1)
j = j - 1
if (j /= kt) go to 900
kt = kt + 1
nn = nfac(kt) - 1
jj = 0
j = 0
go to 906
902 jj = jj - k2
k2 = kk
k = k + 1
kk = nfac(k)
904 jj = kk + jj
if (jj >= k2) go to 902
np(j) = jj
906 k2 = nfac(kt)
k = kt + 1
kk = nfac(k)
j = j + 1
if (j <= nn) go to 904
!  Determine the permutation cycles of length greater than 1
j = 0
go to 914
910 k = kk
kk = np(k)
np(k) = -kk
if (kk /= j) go to 910
k3 = kk
914 j = j + 1
kk = np(j)
if (kk < 0) go to 914
if (kk /= j) go to 910
np(j) = -j
if (j /= nn) go to 914
maxf = inc*maxf
!  Reorder A and b, following the permutation cycles
go to 950
924 j = j - 1
if (np(j) < 0) go to 924
jj = jc
926 kspan = jj
if (jj > maxf) kspan = maxf
jj = jj - kspan
k = np(j)
kk = jc*k + ii + jj
k1 = kk + kspan
k2 = 0
928 k2 = k2 + 1
at(k2) = a(k1)
bt(k2) = b(k1)
k1 = k1 - inc
if (k1 /= kk) go to 928
932 k1 = kk + kspan
k2 = k1 - jc*(k + np(k))
k = -np(k)
936 a(k1) = a(k2)
b(k1) = b(k2)
k1 = k1 - inc
k2 = k2 - inc
if (k1 /= kk) go to 936
kk = k2
if (k /= j) go to 932
k1 = kk + kspan
k2 = 0
940 k2 = k2 + 1
a(k1) = at(k2)
b(k1) = bt(k2)
k1 = k1 - inc
if (k1 /= kk) go to 940
if (jj /= 0) go to 926
if (j /= 1) go to 924
950 j = k3 + 1
nt = nt - kspnn
ii = nt - inc + 1
if (nt >= 0) go to 924
960 return
!  Error finish - There is an input error
1000 ierr = 1
return
1001 ierr = 2
return
1002 ierr = 3
end subroutine sfft

!     ******************************************************************
!
!     subroutine cosqi(n,wsave)
!
!     ******************************************************************
!
!     Subroutine cosqi initializes the array wsave which is used in
!     both cosqf and cosqb. The prime factorization of n together with
!     a tabulation of the trigonometric functions are computed and
!     stored in WSAVE.
!
!     Input parameter
!
!     n       THE LENGTH OF THE ARRAY TO BE TRANSFORMED.  THE METHOD
!             is most efficient when n is a product of small primes.
!
!     Output parameter
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*n+15.
!             The same work array can be used for both cosqf and cosqb
!             as long as n remains unchanged. Different WSAVE arrays
!             are required for different values of n. the contents of
!             WSAVE must not be changed between calls of cosqf or cosqb.
!
subroutine cosqi(n,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*)
integer :: k
real :: dt, fk
real, parameter :: pih = 1.57079632679491
dt = pih/float(n)
fk = 0.
do k = 1,n
   fk = fk + 1.
   wsave(k) = cos(fk*dt)
end do
call rffti(n,wsave(n + 1))
end subroutine cosqi

!     ******************************************************************
!
!     subroutine cosqf(n,x,wsave)
!
!     ******************************************************************
!
!     Subroutine cosqf computes the fast Fourier transform of quarter
!     wave data. That is , cosqf computes the coefficients in a cosine
!     series representation with only odd wave numbers. The transform
!     is defined below at output parameter X
!
!     cosqf is the unnormalized inverse of cosqb since a call of cosqf
!     followed by a call of cosqb will multiply the input sequence X
!     BY 4*n.
!
!     The array wsave which is used by subroutine cosqf must be
!     initialized by calling subroutine cosqi(n,wsave).
!
!
!     Input parameters
!
!     n       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             is most efficient when n is a product of small primes.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     wsave   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*n+15
!             in the program that calls cosqf. The wsave array must be
!             initialized by calling subroutine cosqi(n,wsave) and A
!             different wsave array must be used for each different
!             value of n. this initialization does not have to be
!             repeated so long as n remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     X       FOR I=1,...,n
!
!                  X(I) = X(1) plus the sum from k=2 To k=n of
!
!                     2*X(k)*cos((2*I-1)*(k-1)*pi/(2*n))
!
!                  A call of cosqf followed by a call of
!                  cosqb will multiply the sequence X by 4*n.
!                  Therefore cosqb is the unnormalized inverse
!                  OF cosqf.
!
!     wsave   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of cosqf or cosqb.
!
subroutine cosqf(n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
real :: tsqx
integer :: nswc_ai_i4
real, parameter :: sqrt2 = 1.4142135623731
nswc_ai_i4 = n - 2
if ( nswc_ai_i4 < 0 ) go to 102
if ( nswc_ai_i4 == 0 ) go to 101
go to 103
101 tsqx = sqrt2*x(2)
x(2) = x(1) - tsqx
x(1) = x(1) + tsqx
102 return
103 call cosqf1(n,x,wsave,wsave(n + 1))
end subroutine cosqf

subroutine cosqf1(n,x,w,xh)
implicit none
integer :: n
real :: w(*)
real, intent(inout) :: x(*), xh(*)
integer :: i, k, kc, modn, np2, ns2
real :: xim1
ns2 = (n + 1)/2
np2 = n + 2
do k = 2,ns2
   kc = np2 - k
   xh(k) = x(k) + x(kc)
   xh(kc) = x(k) - x(kc)
end do
modn = mod(n,2)
if (modn == 0) xh(ns2 + 1) = x(ns2 + 1) + x(ns2 + 1)
do k = 2,ns2
   kc = np2 - k
   x(k) = w(k - 1)*xh(kc) + w(kc - 1)*xh(k)
   x(kc) = w(k - 1)*xh(k) - w(kc - 1)*xh(kc)
end do
if (modn == 0) x(ns2 + 1) = w(ns2)*xh(ns2 + 1)
call rfftf(n,x,xh)
do i = 3,n,2
   xim1 = x(i - 1) - x(i)
   x(i) = x(i - 1) + x(i)
   x(i - 1) = xim1
end do
end subroutine cosqf1

!     ******************************************************************
!
!     subroutine cosqb(n,x,wsave)
!
!     ******************************************************************
!
!     Subroutine cosqb computes the fast Fourier transform of quarter
!     wave data. That is , cosqb computes a sequence from its
!     representation in terms of a cosine series with odd wave numbers.
!     The transform is defined below at output parameter x.
!
!     cosqb is the unnormalized inverse of cosqf since a call of cosqb
!     followed by a call of cosqf will multiply the input sequence x
!     BY 4*n.
!
!     The array wsave which is used by subroutine cosqb must be
!     initialized by calling subroutine cosqi(n,WSAVE).
!
!
!     Input parameters
!
!     n       THE LENGTH OF THE ARRAY x TO BE TRANSFORMED.  THE METHOD
!             is most efficient when n is a product of small primes.
!
!     x       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY THAT MUST BE DIMENSIONED AT LEAST 3*n+15
!             in the program that calls cosqb. The WSAVE array must be
!             initialized by calling subroutine cosqi(n,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of n. this initialization does not have to be
!             repeated so long as n remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     x       FOR i=1,...,n
!
!                  x(i)= The sum from k=1 To k=n of
!
!                    4*x(k)*cos((2*k-1)*(i-1)*pi/(2*n))
!
!                  A call of cosqb followed by a call of
!                  cosqf will multiply the sequence x by 4*n.
!                  Therefore cosqf is the unnormalized inverse
!                  OF cosqb.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of cosqb or cosqf.
!
subroutine cosqb(n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
real :: x1
integer :: nswc_ai_i4
real, parameter :: tsqrt2 = 2.82842712474619
nswc_ai_i4 = n - 2
if ( nswc_ai_i4 < 0 ) go to 101
if ( nswc_ai_i4 == 0 ) go to 102
go to 103
101 x(1) = 4.*x(1)
return
102 x1 = 4.*(x(1) + x(2))
x(2) = tsqrt2*(x(1) - x(2))
x(1) = x1
return
103 call cosqb1(n,x,wsave,wsave(n + 1))
end subroutine cosqb

subroutine cosqb1(n,x,w,xh)
implicit none
integer :: n
real :: w(*)
real, intent(inout) :: x(*), xh(*)
integer :: i, k, kc, modn, np2, ns2
real :: xim1
ns2 = (n + 1)/2
np2 = n + 2
do i = 3,n,2
   xim1 = x(i - 1) + x(i)
   x(i) = x(i) - x(i - 1)
   x(i - 1) = xim1
end do
x(1) = x(1) + x(1)
modn = mod(n,2)
if (modn == 0) x(n) = x(n) + x(n)
call rfftb(n,x,xh)
do k = 2,ns2
   kc = np2 - k
   xh(k) = w(k - 1)*x(kc) + w(kc - 1)*x(k)
   xh(kc) = w(k - 1)*x(k) - w(kc - 1)*x(kc)
end do
if (modn == 0) x(ns2 + 1) = w(ns2)*(x(ns2 + 1) + x(ns2 + 1))
do k = 2,ns2
   kc = np2 - k
   x(k) = xh(k) + xh(kc)
   x(kc) = xh(k) - xh(kc)
end do
x(1) = x(1) + x(1)
end subroutine cosqb1

!     ******************************************************************
!
!     subroutine sinqf(n,x,wsave)
!
!     ******************************************************************
!
!     Subroutine sinqf computes the fast Fourier transform of quarter
!     wave data. That is , sinqf computes the coefficients in a sine
!     series representation with only odd wave numbers. The transform
!     is defined below at output parameter x.
!
!     sinqb is the unnormalized inverse of sinqf since a call of sinqf
!     followed by a call of sinqb will multiply the input sequence x
!     BY 4*n.
!
!     The array wsave which is used by subroutine sinqf must be
!     initialized by calling subroutine sinqi(n,WSAVE).
!
!
!     Input parameters
!
!     n       THE LENGTH OF THE ARRAY x TO BE TRANSFORMED.  THE METHOD
!             is most efficient when n is a product of small primes.
!
!     x       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*n+15.
!             In the program that calls sinqf. The WSAVE array must be
!             initialized by calling subroutine sinqi(n,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of n. this initialization does not have to be
!             repeated so long as n remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     x       FOR i=1,...,n
!
!                  x(i) = (-1)**(i-1)*x(n)
!
!                     + The sum from k=1 To k=n-1 of
!
!                     2*x(k)*sin((2*i-1)*k*pi/(2*n))
!
!                  A call of sinqf followed by a call of
!                  sinqb will multiply the sequence x by 4*n.
!                  Therefore sinqb is the unnormalized inverse
!                  OF sinqf.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of sinqf or sinqb.
!
subroutine sinqf(n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
integer :: k, kc, ns2
real :: xhold
if (n == 1) return
ns2 = n/2
do k = 1,ns2
   kc = n - k
   xhold = x(k)
   x(k) = x(kc + 1)
   x(kc + 1) = xhold
end do
call cosqf(n,x,wsave)
do k = 2,n,2
   x(k) = -x(k)
end do
end subroutine sinqf

!     ******************************************************************
!
!     subroutine sinqb(n,x,wsave)
!
!     ******************************************************************
!
!     Subroutine sinqb computes the fast Fourier transform of quarter
!     wave data. That is , sinqb computes a sequence from its
!     representation in terms of a sine series with odd wave numbers.
!     The transform is defined below at output parameter x.
!
!     sinqf is the unnormalized inverse of sinqb since a call of sinqb
!     followed by a call of sinqf will multiply the input sequence x
!     BY 4*n.
!
!     The array wsave which is used by subroutine sinqb must be
!     initialized by calling subroutine sinqi(n,wsave).
!
!
!     Input parameters
!
!     n       THE LENGTH OF THE ARRAY x TO BE TRANSFORMED.  THE METHOD
!             is most efficient when n is a product of small primes.
!
!     x       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     wsave   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*n+15.
!             In the program that calls sinqb. The wsave array must be
!             initialized by calling subroutine sinqi(n,wsave) and A
!             different wsave array must be used for each different
!             value of n. this initialization does not have to be
!             repeated so long as n remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     x       FOR I=1,...,n
!
!                  x(I)= The sum from k=1 To k=n of
!
!                    4*x(k)*sin((2k-1)*I*pi/(2*n))
!
!                  A call of sinqb followed by a call of
!                  sinqf will multiply the sequence x by 4*n.
!                  Therefore sinqf is the unnormalized inverse
!                  OF sinqb.
!
!     wsave   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of sinqb or sinqf.
!
subroutine sinqb(n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
integer :: k, kc, ns2
real :: xhold
if (n > 1) go to 101
x(1) = 4.*x(1)
return
101 ns2 = n/2
do k = 2,n,2
   x(k) = -x(k)
end do
call cosqb(n,x,wsave)
do k = 1,ns2
   kc = n - k
   xhold = x(k)
   x(k) = x(kc + 1)
   x(kc + 1) = xhold
end do
end subroutine sinqb

!     ******************************************************************
!
!     subroutine rffti(n,wsave)
!
!       ****************************************************************
!
!     Subroutine rffti initializes the array wsave which is used in
!     both rfftf and rfftb. The prime factorization of n together with
!     a tabulation of the trigonometric functions are computed and
!     stored in wsave.
!
!     Input parameter
!
!     n       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED.
!
!     Output parameter
!
!     wsave   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*n+15.
!             The same work array can be used for both rfftf and rfftb
!             as long as n remains unchanged. Different wsave arrays
!             are required for different values of n. the contents of
!             wsave must not be changed between calls of rfftf or rfftb.
!
subroutine rffti(n,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*)
if (n == 1) return
call rffti1(n,wsave(n + 1),wsave(2*n + 1))
end subroutine rffti

pure subroutine rffti1(n,wa,ifac)
implicit none
integer, intent(in) :: n
real, intent(inout) :: wa(*), ifac(*)
integer :: i, ib, ido, ii, ip, ipm, is, j, k1, l1, l2, ld, nf, &
   & nfm1, nl, nq, nr, ntry
real :: arg, argh, argld, fi, tpi
integer, parameter :: ntryh(4) = [4, 2, 3, 5]
nl = n
nf = 0
j = 0
101 j = j + 1
if ( ( j - 4 ) <= 0 ) go to 102
go to 103
102 ntry = ntryh(j)
go to 104
103 ntry = ntry + 2
104 nq = nl/ntry
nr = nl - ntry*nq
if ( ( nr ) == 0 ) go to 105
go to 101
105 nf = nf + 1
ifac(nf + 2) = ntry
nl = nq
if (ntry /= 2) go to 107
if (nf == 1) go to 107
do i = 2,nf
   ib = nf - i + 2
   ifac(ib + 2) = ifac(ib + 1)
end do
ifac(3) = 2
107 if (nl /= 1) go to 104
ifac(1) = n
ifac(2) = nf
tpi = 6.28318530717959
argh = tpi/float(n)
is = 0
nfm1 = nf - 1
l1 = 1
if (nfm1 == 0) return
do k1 = 1,nfm1
   ip = ifac(k1 + 2)
   ld = 0
   l2 = l1*ip
   ido = n/l2
   ipm = ip - 1
   do j = 1,ipm
      ld = ld + l1
      i = is
      argld = float(ld)*argh
      fi = 0.
      do ii = 3,ido,2
         i = i + 2
         fi = fi + 1.
         arg = fi*argld
         wa(i - 1) = cos(arg)
         wa(i) = sin(arg)
      end do
      is = is + ido
   end do
   l1 = l2
end do
end subroutine rffti1

!     ******************************************************************
!
!     subroutine rfftb(n,r,wsave)
!
!     ******************************************************************
!
!     Subroutine rfftb computes the real perodic sequence from its
!     Fourier coefficients (Fourier synthesis). The transform is defined
!     below at output parameter R.
!
!     Input parameters
!
!     n       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
!             is most efficient when n is a product of small primes.
!             n may change so long as different work arrays are provided
!
!     R       A REAL ARRAY OF LENGTH n WHICH CONTAINS THE SEQUENCE
!             to be transformed
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*n+15.
!             In the program that calls rfftb. The WSAVE array must be
!             initialized by calling subroutine rffti(n,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of n. this initialization does not have to be
!             repeated so long as n remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!             The same WSAVE array can be used by rfftf and rfftb.
!
!
!     Output parameters
!
!     R       for n even and for i = 1,...,n
!
!                  r(i) = r(1)+(-1)**(i-1)*r(n)
!
!                       Plus the sum from K=2 To K=n/2 of
!
!                        2.*R(2*K-2)*cos((K-1)*(i-1)*2*pi/n)
!
!                       -2.*R(2*K-1)*sin((K-1)*(i-1)*2*pi/n)
!
!             For n odd and for i = 1,...,n
!
!                  R(i) = R(1) plus the sum from K=2 To K=(n+1)/2 of
!
!                       2.*R(2*K-2)*cos((K-1)*(i-1)*2*pi/n)
!
!                      -2.*R(2*K-1)*sin((K-1)*(i-1)*2*pi/n)
!
!      *****  NOTE
!                  this transform is unnormalized since a call of rfftf
!                  followed by a call of rfftb will multiply the input
!                  sequence by n.
!
!     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
!             calls of rfftb or rfftf.
!
!
subroutine rfftb(n,r,wsave)
implicit none
integer :: n
real, intent(inout) :: r(*), wsave(*)
if (n == 1) return
call rfftb1(n,r,wsave,wsave(n + 1),wsave(2*n + 1))
end subroutine rfftb

subroutine rfftb1(n,c,ch,wa,ifac)
implicit none
integer, intent(in) :: n
real, intent(inout) :: c(*), ch(*)
real :: wa(*)
real, intent(in) :: ifac(*)
integer :: i, idl1, ido, ip, iw, ix2, ix3, ix4, k1, l1, l2, na, nf
nf = ifac(2)
na = 0
l1 = 1
iw = 1
do k1 = 1,nf
   ip = ifac(k1 + 2)
   l2 = ip*l1
   ido = n/l2
   idl1 = ido*l1
   if (ip /= 4) go to 103
   ix2 = iw + ido
   ix3 = ix2 + ido
   if (na /= 0) go to 101
   call radb4(ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3))
   go to 102
101 call radb4(ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3))
102 na = 1 - na
   go to 115
103 if (ip /= 2) go to 106
   if (na /= 0) go to 104
   call radb2(ido,l1,c,ch,wa(iw))
   go to 105
104 call radb2(ido,l1,ch,c,wa(iw))
105 na = 1 - na
   go to 115
106 if (ip /= 3) go to 109
   ix2 = iw + ido
   if (na /= 0) go to 107
   call radb3(ido,l1,c,ch,wa(iw),wa(ix2))
   go to 108
107 call radb3(ido,l1,ch,c,wa(iw),wa(ix2))
108 na = 1 - na
   go to 115
109 if (ip /= 5) go to 112
   ix2 = iw + ido
   ix3 = ix2 + ido
   ix4 = ix3 + ido
   if (na /= 0) go to 110
   call radb5(ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3),wa(ix4))
   go to 111
110 call radb5(ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3),wa(ix4))
111 na = 1 - na
   go to 115
112 if (na /= 0) go to 113
   call radbg(ido,ip,l1,idl1,c,c,c,ch,ch,wa(iw))
   go to 114
113 call radbg(ido,ip,l1,idl1,ch,ch,ch,c,c,wa(iw))
114 if (ido == 1) na = 1 - na
115 l1 = l2
   iw = iw + (ip - 1)*ido
end do
if (na == 0) return
do i = 1,n
   c(i) = ch(i)
end do
end subroutine rfftb1

subroutine radb2(ido,l1,cc,ch,wa1)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,2,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*)
integer :: i, ic, idp2, k, nswc_ai_i4
real :: ti2, tr2
do k = 1,l1
   ch(1,k,1) = cc(1,1,k) + cc(ido,2,k)
   ch(1,k,2) = cc(1,1,k) - cc(ido,2,k)
end do
nswc_ai_i4 = ido - 2
if ( nswc_ai_i4 < 0 ) go to 107
if ( nswc_ai_i4 == 0 ) go to 105
go to 102
102 idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 108
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      ch(i - 1,k,1) = cc(i - 1,1,k) + cc(ic - 1,2,k)
      tr2 = cc(i - 1,1,k) - cc(ic - 1,2,k)
      ch(i,k,1) = cc(i,1,k) - cc(ic,2,k)
      ti2 = cc(i,1,k) + cc(ic,2,k)
      ch(i - 1,k,2) = wa1(i - 2)*tr2 - wa1(i - 1)*ti2
      ch(i,k,2) = wa1(i - 2)*ti2 + wa1(i - 1)*tr2
   end do
end do
go to 111
108 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      ch(i - 1,k,1) = cc(i - 1,1,k) + cc(ic - 1,2,k)
      tr2 = cc(i - 1,1,k) - cc(ic - 1,2,k)
      ch(i,k,1) = cc(i,1,k) - cc(ic,2,k)
      ti2 = cc(i,1,k) + cc(ic,2,k)
      ch(i - 1,k,2) = wa1(i - 2)*tr2 - wa1(i - 1)*ti2
      ch(i,k,2) = wa1(i - 2)*ti2 + wa1(i - 1)*tr2
   end do
end do
111 if (mod(ido,2) == 1) return
105 do k = 1,l1
   ch(ido,k,1) = cc(ido,1,k) + cc(ido,1,k)
   ch(ido,k,2) = -(cc(1,2,k) + cc(1,2,k))
end do
107 return
end subroutine radb2

subroutine radb3(ido,l1,cc,ch,wa1,wa2)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,3,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*), wa2(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, cr2, cr3, di2, di3, dr2, dr3, ti2, tr2
real, parameter :: taur = -.5
real, parameter :: taui = .866025403784439
do k = 1,l1
   tr2 = cc(ido,2,k) + cc(ido,2,k)
   cr2 = cc(1,1,k) + taur*tr2
   ch(1,k,1) = cc(1,1,k) + tr2
   ci3 = taui*(cc(1,3,k) + cc(1,3,k))
   ch(1,k,2) = cr2 - ci3
   ch(1,k,3) = cr2 + ci3
end do
if (ido == 1) return
idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 104
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      tr2 = cc(i - 1,3,k) + cc(ic - 1,2,k)
      cr2 = cc(i - 1,1,k) + taur*tr2
      ch(i - 1,k,1) = cc(i - 1,1,k) + tr2
      ti2 = cc(i,3,k) - cc(ic,2,k)
      ci2 = cc(i,1,k) + taur*ti2
      ch(i,k,1) = cc(i,1,k) + ti2
      cr3 = taui*(cc(i - 1,3,k) - cc(ic - 1,2,k))
      ci3 = taui*(cc(i,3,k) + cc(ic,2,k))
      dr2 = cr2 - ci3
      dr3 = cr2 + ci3
      di2 = ci2 + cr3
      di3 = ci2 - cr3
      ch(i - 1,k,2) = wa1(i - 2)*dr2 - wa1(i - 1)*di2
      ch(i,k,2) = wa1(i - 2)*di2 + wa1(i - 1)*dr2
      ch(i - 1,k,3) = wa2(i - 2)*dr3 - wa2(i - 1)*di3
      ch(i,k,3) = wa2(i - 2)*di3 + wa2(i - 1)*dr3
   end do
end do
return
104 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      tr2 = cc(i - 1,3,k) + cc(ic - 1,2,k)
      cr2 = cc(i - 1,1,k) + taur*tr2
      ch(i - 1,k,1) = cc(i - 1,1,k) + tr2
      ti2 = cc(i,3,k) - cc(ic,2,k)
      ci2 = cc(i,1,k) + taur*ti2
      ch(i,k,1) = cc(i,1,k) + ti2
      cr3 = taui*(cc(i - 1,3,k) - cc(ic - 1,2,k))
      ci3 = taui*(cc(i,3,k) + cc(ic,2,k))
      dr2 = cr2 - ci3
      dr3 = cr2 + ci3
      di2 = ci2 + cr3
      di3 = ci2 - cr3
      ch(i - 1,k,2) = wa1(i - 2)*dr2 - wa1(i - 1)*di2
      ch(i,k,2) = wa1(i - 2)*di2 + wa1(i - 1)*dr2
      ch(i - 1,k,3) = wa2(i - 2)*dr3 - wa2(i - 1)*di3
      ch(i,k,3) = wa2(i - 2)*di3 + wa2(i - 1)*dr3
   end do
end do
end subroutine radb3

subroutine radb4(ido,l1,cc,ch,wa1,wa2,wa3)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,4,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*), wa2(*), wa3(*)
integer :: i, ic, idp2, k, nswc_ai_i4
real :: ci2, ci3, ci4, cr2, cr3, cr4, ti1, ti2, ti3, ti4, tr1, tr2, tr3, tr4
real, parameter :: sqrt2 = 1.414213562373095
do k = 1,l1
   tr1 = cc(1,1,k) - cc(ido,4,k)
   tr2 = cc(1,1,k) + cc(ido,4,k)
   tr3 = cc(ido,2,k) + cc(ido,2,k)
   tr4 = cc(1,3,k) + cc(1,3,k)
   ch(1,k,1) = tr2 + tr3
   ch(1,k,2) = tr1 - tr4
   ch(1,k,3) = tr2 - tr3
   ch(1,k,4) = tr1 + tr4
end do
nswc_ai_i4 = ido - 2
if ( nswc_ai_i4 < 0 ) go to 107
if ( nswc_ai_i4 == 0 ) go to 105
go to 102
102 idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 108
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      ti1 = cc(i,1,k) + cc(ic,4,k)
      ti2 = cc(i,1,k) - cc(ic,4,k)
      ti3 = cc(i,3,k) - cc(ic,2,k)
      tr4 = cc(i,3,k) + cc(ic,2,k)
      tr1 = cc(i - 1,1,k) - cc(ic - 1,4,k)
      tr2 = cc(i - 1,1,k) + cc(ic - 1,4,k)
      ti4 = cc(i - 1,3,k) - cc(ic - 1,2,k)
      tr3 = cc(i - 1,3,k) + cc(ic - 1,2,k)
      ch(i - 1,k,1) = tr2 + tr3
      cr3 = tr2 - tr3
      ch(i,k,1) = ti2 + ti3
      ci3 = ti2 - ti3
      cr2 = tr1 - tr4
      cr4 = tr1 + tr4
      ci2 = ti1 + ti4
      ci4 = ti1 - ti4
      ch(i - 1,k,2) = wa1(i - 2)*cr2 - wa1(i - 1)*ci2
      ch(i,k,2) = wa1(i - 2)*ci2 + wa1(i - 1)*cr2
      ch(i - 1,k,3) = wa2(i - 2)*cr3 - wa2(i - 1)*ci3
      ch(i,k,3) = wa2(i - 2)*ci3 + wa2(i - 1)*cr3
      ch(i - 1,k,4) = wa3(i - 2)*cr4 - wa3(i - 1)*ci4
      ch(i,k,4) = wa3(i - 2)*ci4 + wa3(i - 1)*cr4
   end do
end do
go to 111
108 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      ti1 = cc(i,1,k) + cc(ic,4,k)
      ti2 = cc(i,1,k) - cc(ic,4,k)
      ti3 = cc(i,3,k) - cc(ic,2,k)
      tr4 = cc(i,3,k) + cc(ic,2,k)
      tr1 = cc(i - 1,1,k) - cc(ic - 1,4,k)
      tr2 = cc(i - 1,1,k) + cc(ic - 1,4,k)
      ti4 = cc(i - 1,3,k) - cc(ic - 1,2,k)
      tr3 = cc(i - 1,3,k) + cc(ic - 1,2,k)
      ch(i - 1,k,1) = tr2 + tr3
      cr3 = tr2 - tr3
      ch(i,k,1) = ti2 + ti3
      ci3 = ti2 - ti3
      cr2 = tr1 - tr4
      cr4 = tr1 + tr4
      ci2 = ti1 + ti4
      ci4 = ti1 - ti4
      ch(i - 1,k,2) = wa1(i - 2)*cr2 - wa1(i - 1)*ci2
      ch(i,k,2) = wa1(i - 2)*ci2 + wa1(i - 1)*cr2
      ch(i - 1,k,3) = wa2(i - 2)*cr3 - wa2(i - 1)*ci3
      ch(i,k,3) = wa2(i - 2)*ci3 + wa2(i - 1)*cr3
      ch(i - 1,k,4) = wa3(i - 2)*cr4 - wa3(i - 1)*ci4
      ch(i,k,4) = wa3(i - 2)*ci4 + wa3(i - 1)*cr4
   end do
end do
111 if (mod(ido,2) == 1) return
105 do k = 1,l1
   ti1 = cc(1,2,k) + cc(1,4,k)
   ti2 = cc(1,4,k) - cc(1,2,k)
   tr1 = cc(ido,1,k) - cc(ido,3,k)
   tr2 = cc(ido,1,k) + cc(ido,3,k)
   ch(ido,k,1) = tr2 + tr2
   ch(ido,k,2) = sqrt2*(tr1 - ti1)
   ch(ido,k,3) = ti2 + ti2
   ch(ido,k,4) = -sqrt2*(tr1 + ti1)
end do
107 return
end subroutine radb4

subroutine radb5(ido,l1,cc,ch,wa1,wa2,wa3,wa4)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,5,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*), wa2(*), wa3(*), wa4(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, ci4, ci5, cr2, cr3, cr4, cr5, di2, di3, di4, di5, dr2, dr3, dr4, dr5, ti2, ti3, ti4, ti5, tr2, tr3, tr4, tr5
real, parameter :: tr11 = .309016994374947
real, parameter :: ti11 = .951056516295154
real, parameter :: tr12 = -.809016994374947
real, parameter :: ti12 = .587785252292473
do k = 1,l1
   ti5 = cc(1,3,k) + cc(1,3,k)
   ti4 = cc(1,5,k) + cc(1,5,k)
   tr2 = cc(ido,2,k) + cc(ido,2,k)
   tr3 = cc(ido,4,k) + cc(ido,4,k)
   ch(1,k,1) = cc(1,1,k) + tr2 + tr3
   cr2 = cc(1,1,k) + tr11*tr2 + tr12*tr3
   cr3 = cc(1,1,k) + tr12*tr2 + tr11*tr3
   ci5 = ti11*ti5 + ti12*ti4
   ci4 = ti12*ti5 - ti11*ti4
   ch(1,k,2) = cr2 - ci5
   ch(1,k,3) = cr3 - ci4
   ch(1,k,4) = cr3 + ci4
   ch(1,k,5) = cr2 + ci5
end do
if (ido == 1) return
idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 104
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      ti5 = cc(i,3,k) + cc(ic,2,k)
      ti2 = cc(i,3,k) - cc(ic,2,k)
      ti4 = cc(i,5,k) + cc(ic,4,k)
      ti3 = cc(i,5,k) - cc(ic,4,k)
      tr5 = cc(i - 1,3,k) - cc(ic - 1,2,k)
      tr2 = cc(i - 1,3,k) + cc(ic - 1,2,k)
      tr4 = cc(i - 1,5,k) - cc(ic - 1,4,k)
      tr3 = cc(i - 1,5,k) + cc(ic - 1,4,k)
      ch(i - 1,k,1) = cc(i - 1,1,k) + tr2 + tr3
      ch(i,k,1) = cc(i,1,k) + ti2 + ti3
      cr2 = cc(i - 1,1,k) + tr11*tr2 + tr12*tr3
      ci2 = cc(i,1,k) + tr11*ti2 + tr12*ti3
      cr3 = cc(i - 1,1,k) + tr12*tr2 + tr11*tr3
      ci3 = cc(i,1,k) + tr12*ti2 + tr11*ti3
      cr5 = ti11*tr5 + ti12*tr4
      ci5 = ti11*ti5 + ti12*ti4
      cr4 = ti12*tr5 - ti11*tr4
      ci4 = ti12*ti5 - ti11*ti4
      dr3 = cr3 - ci4
      dr4 = cr3 + ci4
      di3 = ci3 + cr4
      di4 = ci3 - cr4
      dr5 = cr2 + ci5
      dr2 = cr2 - ci5
      di5 = ci2 - cr5
      di2 = ci2 + cr5
      ch(i - 1,k,2) = wa1(i - 2)*dr2 - wa1(i - 1)*di2
      ch(i,k,2) = wa1(i - 2)*di2 + wa1(i - 1)*dr2
      ch(i - 1,k,3) = wa2(i - 2)*dr3 - wa2(i - 1)*di3
      ch(i,k,3) = wa2(i - 2)*di3 + wa2(i - 1)*dr3
      ch(i - 1,k,4) = wa3(i - 2)*dr4 - wa3(i - 1)*di4
      ch(i,k,4) = wa3(i - 2)*di4 + wa3(i - 1)*dr4
      ch(i - 1,k,5) = wa4(i - 2)*dr5 - wa4(i - 1)*di5
      ch(i,k,5) = wa4(i - 2)*di5 + wa4(i - 1)*dr5
   end do
end do
return
104 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      ti5 = cc(i,3,k) + cc(ic,2,k)
      ti2 = cc(i,3,k) - cc(ic,2,k)
      ti4 = cc(i,5,k) + cc(ic,4,k)
      ti3 = cc(i,5,k) - cc(ic,4,k)
      tr5 = cc(i - 1,3,k) - cc(ic - 1,2,k)
      tr2 = cc(i - 1,3,k) + cc(ic - 1,2,k)
      tr4 = cc(i - 1,5,k) - cc(ic - 1,4,k)
      tr3 = cc(i - 1,5,k) + cc(ic - 1,4,k)
      ch(i - 1,k,1) = cc(i - 1,1,k) + tr2 + tr3
      ch(i,k,1) = cc(i,1,k) + ti2 + ti3
      cr2 = cc(i - 1,1,k) + tr11*tr2 + tr12*tr3
      ci2 = cc(i,1,k) + tr11*ti2 + tr12*ti3
      cr3 = cc(i - 1,1,k) + tr12*tr2 + tr11*tr3
      ci3 = cc(i,1,k) + tr12*ti2 + tr11*ti3
      cr5 = ti11*tr5 + ti12*tr4
      ci5 = ti11*ti5 + ti12*ti4
      cr4 = ti12*tr5 - ti11*tr4
      ci4 = ti12*ti5 - ti11*ti4
      dr3 = cr3 - ci4
      dr4 = cr3 + ci4
      di3 = ci3 + cr4
      di4 = ci3 - cr4
      dr5 = cr2 + ci5
      dr2 = cr2 - ci5
      di5 = ci2 - cr5
      di2 = ci2 + cr5
      ch(i - 1,k,2) = wa1(i - 2)*dr2 - wa1(i - 1)*di2
      ch(i,k,2) = wa1(i - 2)*di2 + wa1(i - 1)*dr2
      ch(i - 1,k,3) = wa2(i - 2)*dr3 - wa2(i - 1)*di3
      ch(i,k,3) = wa2(i - 2)*di3 + wa2(i - 1)*dr3
      ch(i - 1,k,4) = wa3(i - 2)*dr4 - wa3(i - 1)*di4
      ch(i,k,4) = wa3(i - 2)*di4 + wa3(i - 1)*dr4
      ch(i - 1,k,5) = wa4(i - 2)*dr5 - wa4(i - 1)*di5
      ch(i,k,5) = wa4(i - 2)*di5 + wa4(i - 1)*dr5
   end do
end do
end subroutine radb5

subroutine radbg(ido,ip,l1,idl1,cc,c1,c2,ch,ch2,wa)
implicit none
integer, intent(in) :: idl1, ido, ip, l1
real, intent(inout) :: c1(ido,l1,ip), c2(idl1,ip)
real :: cc(ido,ip,l1)
real, intent(inout) :: ch(ido,l1,ip), ch2(idl1,ip)
real :: wa(*)
integer :: i, ic, idij, idp2, ik, ipp2, ipph, is, j, j2, jc, k, l, &
   & lc, nbd
real :: ai1, ai2, ar1, ar1h, ar2, ar2h, arg, dc2, dcp, ds2, dsp
real, parameter :: tpi = 6.28318530717959
arg = tpi/float(ip)
dcp = cos(arg)
dsp = sin(arg)
idp2 = ido + 2
nbd = (ido - 1)/2
ipp2 = ip + 2
ipph = (ip + 1)/2
if (ido < l1) go to 103
do k = 1,l1
   do i = 1,ido
      ch(i,k,1) = cc(i,1,k)
   end do
end do
go to 106
103 do i = 1,ido
   do k = 1,l1
      ch(i,k,1) = cc(i,1,k)
   end do
end do
106 do j = 2,ipph
   jc = ipp2 - j
   j2 = j + j
   do k = 1,l1
      ch(1,k,j) = cc(ido,j2 - 2,k) + cc(ido,j2 - 2,k)
      ch(1,k,jc) = cc(1,j2 - 1,k) + cc(1,j2 - 1,k)
   end do
end do
if (ido == 1) go to 116
if (nbd < l1) go to 112
do j = 2,ipph
   jc = ipp2 - j
   do k = 1,l1
      do i = 3,ido,2
         ic = idp2 - i
         ch(i - 1,k,j) = cc(i - 1,2*j - 1,k) + cc(ic - 1,2*j - 2,k)
         ch(i - 1,k,jc) = cc(i - 1,2*j - 1,k) - cc(ic - 1,2*j - 2,k)
         ch(i,k,j) = cc(i,2*j - 1,k) - cc(ic,2*j - 2,k)
         ch(i,k,jc) = cc(i,2*j - 1,k) + cc(ic,2*j - 2,k)
      end do
   end do
end do
go to 116
112 do j = 2,ipph
   jc = ipp2 - j
   do i = 3,ido,2
      ic = idp2 - i
      do k = 1,l1
         ch(i - 1,k,j) = cc(i - 1,2*j - 1,k) + cc(ic - 1,2*j - 2,k)
         ch(i - 1,k,jc) = cc(i - 1,2*j - 1,k) - cc(ic - 1,2*j - 2,k)
         ch(i,k,j) = cc(i,2*j - 1,k) - cc(ic,2*j - 2,k)
         ch(i,k,jc) = cc(i,2*j - 1,k) + cc(ic,2*j - 2,k)
      end do
   end do
end do
116 ar1 = 1.
ai1 = 0.
do l = 2,ipph
   lc = ipp2 - l
   ar1h = dcp*ar1 - dsp*ai1
   ai1 = dcp*ai1 + dsp*ar1
   ar1 = ar1h
   do ik = 1,idl1
      c2(ik,l) = ch2(ik,1) + ar1*ch2(ik,2)
      c2(ik,lc) = ai1*ch2(ik,ip)
   end do
   dc2 = ar1
   ds2 = ai1
   ar2 = ar1
   ai2 = ai1
   do j = 3,ipph
      jc = ipp2 - j
      ar2h = dc2*ar2 - ds2*ai2
      ai2 = dc2*ai2 + ds2*ar2
      ar2 = ar2h
      do ik = 1,idl1
         c2(ik,l) = c2(ik,l) + ar2*ch2(ik,j)
         c2(ik,lc) = c2(ik,lc) + ai2*ch2(ik,jc)
      end do
   end do
end do
do j = 2,ipph
   do ik = 1,idl1
      ch2(ik,1) = ch2(ik,1) + ch2(ik,j)
   end do
end do
do j = 2,ipph
   jc = ipp2 - j
   do k = 1,l1
      ch(1,k,j) = c1(1,k,j) - c1(1,k,jc)
      ch(1,k,jc) = c1(1,k,j) + c1(1,k,jc)
   end do
end do
if (ido == 1) go to 132
if (nbd < l1) go to 128
do j = 2,ipph
   jc = ipp2 - j
   do k = 1,l1
      do i = 3,ido,2
         ch(i - 1,k,j) = c1(i - 1,k,j) - c1(i,k,jc)
         ch(i - 1,k,jc) = c1(i - 1,k,j) + c1(i,k,jc)
         ch(i,k,j) = c1(i,k,j) + c1(i - 1,k,jc)
         ch(i,k,jc) = c1(i,k,j) - c1(i - 1,k,jc)
      end do
   end do
end do
go to 132
128 do j = 2,ipph
   jc = ipp2 - j
   do i = 3,ido,2
      do k = 1,l1
         ch(i - 1,k,j) = c1(i - 1,k,j) - c1(i,k,jc)
         ch(i - 1,k,jc) = c1(i - 1,k,j) + c1(i,k,jc)
         ch(i,k,j) = c1(i,k,j) + c1(i - 1,k,jc)
         ch(i,k,jc) = c1(i,k,j) - c1(i - 1,k,jc)
      end do
   end do
end do
132 continue
if (ido == 1) return
do ik = 1,idl1
   c2(ik,1) = ch2(ik,1)
end do
do j = 2,ip
   do k = 1,l1
      c1(1,k,j) = ch(1,k,j)
   end do
end do
if (nbd > l1) go to 139
is = -ido
do j = 2,ip
   is = is + ido
   idij = is
   do i = 3,ido,2
      idij = idij + 2
      do k = 1,l1
         c1(i - 1,k,j) = wa(idij - 1)*ch(i - 1,k,j) - wa(idij)*ch(i,k,j)
         c1(i,k,j) = wa(idij - 1)*ch(i,k,j) + wa(idij)*ch(i - 1,k,j)
      end do
   end do
end do
go to 143
139 is = -ido
do j = 2,ip
   is = is + ido
   do k = 1,l1
      idij = is
      do i = 3,ido,2
         idij = idij + 2
         c1(i - 1,k,j) = wa(idij - 1)*ch(i - 1,k,j) - wa(idij)*ch(i,k,j)
         c1(i,k,j) = wa(idij - 1)*ch(i,k,j) + wa(idij)*ch(i - 1,k,j)
      end do
   end do
end do
143 return
end subroutine radbg

!     ******************************************************************
!
!     subroutine rfftf(n,r,wsave)
!
!     ******************************************************************
!
!     Subroutine rfftf computes the Fourier coefficients of a real
!     perodic sequence (Fourier analysis). The transform is defined
!     below at output parameter R.
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!             N may change so long as different work arrays are provided
!
!     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
!             to be transformed
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             In the program that calls rfftf. The WSAVE array must be
!             initialized by calling subroutine rffti(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. this initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!             The same WSAVE array can be used by rfftf and rfftb.
!
!
!     Output parameters
!
!     R       R(1) = The sum from i=1 To i=N of R(i)
!
!             If N is even set l =N/2   , if N is odd set l = (N+1)/2
!
!               Then for k = 2,...,l
!
!                  R(2*k-2) = The sum from i = 1 To i = N of
!
!                       R(i)*cos((k-1)*(i-1)*2*pi/N)
!
!                  R(2*k-1) = The sum from i = 1 To i = N of
!
!                      -R(i)*sin((k-1)*(i-1)*2*pi/N)
!
!             If N is even
!
!                  R(N) = The sum from i = 1 To i = N of
!
!                       (-1)**(i-1)*R(i)
!
!      *****  NOTE
!                  this transform is unnormalized since a call of rfftf
!                  followed by a call of rfftb will multiply the input
!                  sequence by N.
!
!     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
!             calls of rfftf or rfftb.
!
!
subroutine rfftf(n,r,wsave)
implicit none
integer :: n
real, intent(inout) :: r(*), wsave(*)
if (n == 1) return
call rfftf1(n,r,wsave,wsave(n + 1),wsave(2*n + 1))
end subroutine rfftf

subroutine rfftf1(n,c,ch,wa,ifac)
implicit none
integer, intent(in) :: n
real, intent(inout) :: c(*), ch(*)
real :: wa(*)
real, intent(in) :: ifac(*)
integer :: i, idl1, ido, ip, iw, ix2, ix3, ix4, k1, kh, l1, l2, &
   & na, nf
nf = ifac(2)
na = 1
l2 = n
iw = n
do k1 = 1,nf
   kh = nf - k1
   ip = ifac(kh + 3)
   l1 = l2/ip
   ido = n/l2
   idl1 = ido*l1
   iw = iw - (ip - 1)*ido
   na = 1 - na
   if (ip /= 4) go to 102
   ix2 = iw + ido
   ix3 = ix2 + ido
   if (na /= 0) go to 101
   call radf4(ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3))
   go to 110
101 call radf4(ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3))
   go to 110
102 if (ip /= 2) go to 104
   if (na /= 0) go to 103
   call radf2(ido,l1,c,ch,wa(iw))
   go to 110
103 call radf2(ido,l1,ch,c,wa(iw))
   go to 110
104 if (ip /= 3) go to 106
   ix2 = iw + ido
   if (na /= 0) go to 105
   call radf3(ido,l1,c,ch,wa(iw),wa(ix2))
   go to 110
105 call radf3(ido,l1,ch,c,wa(iw),wa(ix2))
   go to 110
106 if (ip /= 5) go to 108
   ix2 = iw + ido
   ix3 = ix2 + ido
   ix4 = ix3 + ido
   if (na /= 0) go to 107
   call radf5(ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3),wa(ix4))
   go to 110
107 call radf5(ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3),wa(ix4))
   go to 110
108 if (ido == 1) na = 1 - na
   if (na /= 0) go to 109
   call radfg(ido,ip,l1,idl1,c,c,c,ch,ch,wa(iw))
   na = 1
   go to 110
109 call radfg(ido,ip,l1,idl1,ch,ch,ch,c,c,wa(iw))
   na = 0
110 l2 = l1
end do
if (na == 1) return
do i = 1,n
   c(i) = ch(i)
end do
end subroutine rfftf1

subroutine radf2(ido,l1,cc,ch,wa1)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,2,l1)
real :: wa1(*)
integer :: i, ic, idp2, k, nswc_ai_i4
real :: ti2, tr2
do k = 1,l1
   ch(1,1,k) = cc(1,k,1) + cc(1,k,2)
   ch(ido,2,k) = cc(1,k,1) - cc(1,k,2)
end do
nswc_ai_i4 = ido - 2
if ( nswc_ai_i4 < 0 ) go to 107
if ( nswc_ai_i4 == 0 ) go to 105
go to 102
102 idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 108
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      tr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      ti2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      ch(i,1,k) = cc(i,k,1) + ti2
      ch(ic,2,k) = ti2 - cc(i,k,1)
      ch(i - 1,1,k) = cc(i - 1,k,1) + tr2
      ch(ic - 1,2,k) = cc(i - 1,k,1) - tr2
   end do
end do
go to 111
108 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      tr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      ti2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      ch(i,1,k) = cc(i,k,1) + ti2
      ch(ic,2,k) = ti2 - cc(i,k,1)
      ch(i - 1,1,k) = cc(i - 1,k,1) + tr2
      ch(ic - 1,2,k) = cc(i - 1,k,1) - tr2
   end do
end do
111 if (mod(ido,2) == 1) return
105 do k = 1,l1
   ch(1,2,k) = -cc(ido,k,2)
   ch(ido,1,k) = cc(ido,k,1)
end do
107 return
end subroutine radf2

subroutine radf3(ido,l1,cc,ch,wa1,wa2)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,3,l1)
real :: wa1(*), wa2(*)
integer :: i, ic, idp2, k
real :: ci2, cr2, di2, di3, dr2, dr3, ti2, ti3, tr2, tr3
real, parameter :: taur = -.5
real, parameter :: taui = .866025403784439
do k = 1,l1
   cr2 = cc(1,k,2) + cc(1,k,3)
   ch(1,1,k) = cc(1,k,1) + cr2
   ch(1,3,k) = taui*(cc(1,k,3) - cc(1,k,2))
   ch(ido,2,k) = cc(1,k,1) + taur*cr2
end do
if (ido == 1) return
idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 104
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      dr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      di2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      dr3 = wa2(i - 2)*cc(i - 1,k,3) + wa2(i - 1)*cc(i,k,3)
      di3 = wa2(i - 2)*cc(i,k,3) - wa2(i - 1)*cc(i - 1,k,3)
      cr2 = dr2 + dr3
      ci2 = di2 + di3
      ch(i - 1,1,k) = cc(i - 1,k,1) + cr2
      ch(i,1,k) = cc(i,k,1) + ci2
      tr2 = cc(i - 1,k,1) + taur*cr2
      ti2 = cc(i,k,1) + taur*ci2
      tr3 = taui*(di2 - di3)
      ti3 = taui*(dr3 - dr2)
      ch(i - 1,3,k) = tr2 + tr3
      ch(ic - 1,2,k) = tr2 - tr3
      ch(i,3,k) = ti2 + ti3
      ch(ic,2,k) = ti3 - ti2
   end do
end do
return
104 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      dr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      di2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      dr3 = wa2(i - 2)*cc(i - 1,k,3) + wa2(i - 1)*cc(i,k,3)
      di3 = wa2(i - 2)*cc(i,k,3) - wa2(i - 1)*cc(i - 1,k,3)
      cr2 = dr2 + dr3
      ci2 = di2 + di3
      ch(i - 1,1,k) = cc(i - 1,k,1) + cr2
      ch(i,1,k) = cc(i,k,1) + ci2
      tr2 = cc(i - 1,k,1) + taur*cr2
      ti2 = cc(i,k,1) + taur*ci2
      tr3 = taui*(di2 - di3)
      ti3 = taui*(dr3 - dr2)
      ch(i - 1,3,k) = tr2 + tr3
      ch(ic - 1,2,k) = tr2 - tr3
      ch(i,3,k) = ti2 + ti3
      ch(ic,2,k) = ti3 - ti2
   end do
end do
end subroutine radf3

subroutine radf4(ido,l1,cc,ch,wa1,wa2,wa3)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,4,l1)
real :: wa1(*), wa2(*), wa3(*)
integer :: i, ic, idp2, k, nswc_ai_i4
real :: ci2, ci3, ci4, cr2, cr3, cr4, ti1, ti2, ti3, ti4, tr1, tr2, tr3, tr4
real, parameter :: hsqt2 = .7071067811865475
do k = 1,l1
   tr1 = cc(1,k,2) + cc(1,k,4)
   tr2 = cc(1,k,1) + cc(1,k,3)
   ch(1,1,k) = tr1 + tr2
   ch(ido,4,k) = tr2 - tr1
   ch(ido,2,k) = cc(1,k,1) - cc(1,k,3)
   ch(1,3,k) = cc(1,k,4) - cc(1,k,2)
end do
nswc_ai_i4 = ido - 2
if ( nswc_ai_i4 < 0 ) go to 107
if ( nswc_ai_i4 == 0 ) go to 105
go to 102
102 idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 111
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      cr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      ci2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      cr3 = wa2(i - 2)*cc(i - 1,k,3) + wa2(i - 1)*cc(i,k,3)
      ci3 = wa2(i - 2)*cc(i,k,3) - wa2(i - 1)*cc(i - 1,k,3)
      cr4 = wa3(i - 2)*cc(i - 1,k,4) + wa3(i - 1)*cc(i,k,4)
      ci4 = wa3(i - 2)*cc(i,k,4) - wa3(i - 1)*cc(i - 1,k,4)
      tr1 = cr2 + cr4
      tr4 = cr4 - cr2
      ti1 = ci2 + ci4
      ti4 = ci2 - ci4
      ti2 = cc(i,k,1) + ci3
      ti3 = cc(i,k,1) - ci3
      tr2 = cc(i - 1,k,1) + cr3
      tr3 = cc(i - 1,k,1) - cr3
      ch(i - 1,1,k) = tr1 + tr2
      ch(ic - 1,4,k) = tr2 - tr1
      ch(i,1,k) = ti1 + ti2
      ch(ic,4,k) = ti1 - ti2
      ch(i - 1,3,k) = ti4 + tr3
      ch(ic - 1,2,k) = tr3 - ti4
      ch(i,3,k) = tr4 + ti3
      ch(ic,2,k) = tr4 - ti3
   end do
end do
go to 110
111 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      cr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      ci2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      cr3 = wa2(i - 2)*cc(i - 1,k,3) + wa2(i - 1)*cc(i,k,3)
      ci3 = wa2(i - 2)*cc(i,k,3) - wa2(i - 1)*cc(i - 1,k,3)
      cr4 = wa3(i - 2)*cc(i - 1,k,4) + wa3(i - 1)*cc(i,k,4)
      ci4 = wa3(i - 2)*cc(i,k,4) - wa3(i - 1)*cc(i - 1,k,4)
      tr1 = cr2 + cr4
      tr4 = cr4 - cr2
      ti1 = ci2 + ci4
      ti4 = ci2 - ci4
      ti2 = cc(i,k,1) + ci3
      ti3 = cc(i,k,1) - ci3
      tr2 = cc(i - 1,k,1) + cr3
      tr3 = cc(i - 1,k,1) - cr3
      ch(i - 1,1,k) = tr1 + tr2
      ch(ic - 1,4,k) = tr2 - tr1
      ch(i,1,k) = ti1 + ti2
      ch(ic,4,k) = ti1 - ti2
      ch(i - 1,3,k) = ti4 + tr3
      ch(ic - 1,2,k) = tr3 - ti4
      ch(i,3,k) = tr4 + ti3
      ch(ic,2,k) = tr4 - ti3
   end do
end do
110 if (mod(ido,2) == 1) return
105 do k = 1,l1
   ti1 = -hsqt2*(cc(ido,k,2) + cc(ido,k,4))
   tr1 = hsqt2*(cc(ido,k,2) - cc(ido,k,4))
   ch(ido,1,k) = tr1 + cc(ido,k,1)
   ch(ido,3,k) = cc(ido,k,1) - tr1
   ch(1,2,k) = ti1 - cc(ido,k,3)
   ch(1,4,k) = ti1 + cc(ido,k,3)
end do
107 return
end subroutine radf4

subroutine radf5(ido,l1,cc,ch,wa1,wa2,wa3,wa4)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,5,l1)
real :: wa1(*), wa2(*), wa3(*), wa4(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, ci4, ci5, cr2, cr3, cr4, cr5, di2, di3, di4, di5, dr2, dr3, dr4, dr5, ti2, ti3, ti4, ti5, tr2, tr3, tr4, tr5
real, parameter :: tr11 = .309016994374947
real, parameter :: ti11 = .951056516295154
real, parameter :: tr12 = -.809016994374947
real, parameter :: ti12 = .587785252292473
do k = 1,l1
   cr2 = cc(1,k,5) + cc(1,k,2)
   ci5 = cc(1,k,5) - cc(1,k,2)
   cr3 = cc(1,k,4) + cc(1,k,3)
   ci4 = cc(1,k,4) - cc(1,k,3)
   ch(1,1,k) = cc(1,k,1) + cr2 + cr3
   ch(ido,2,k) = cc(1,k,1) + tr11*cr2 + tr12*cr3
   ch(1,3,k) = ti11*ci5 + ti12*ci4
   ch(ido,4,k) = cc(1,k,1) + tr12*cr2 + tr11*cr3
   ch(1,5,k) = ti12*ci5 - ti11*ci4
end do
if (ido == 1) return
idp2 = ido + 2
if ((ido - 1)/2 < l1) go to 104
do k = 1,l1
   do i = 3,ido,2
      ic = idp2 - i
      dr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      di2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      dr3 = wa2(i - 2)*cc(i - 1,k,3) + wa2(i - 1)*cc(i,k,3)
      di3 = wa2(i - 2)*cc(i,k,3) - wa2(i - 1)*cc(i - 1,k,3)
      dr4 = wa3(i - 2)*cc(i - 1,k,4) + wa3(i - 1)*cc(i,k,4)
      di4 = wa3(i - 2)*cc(i,k,4) - wa3(i - 1)*cc(i - 1,k,4)
      dr5 = wa4(i - 2)*cc(i - 1,k,5) + wa4(i - 1)*cc(i,k,5)
      di5 = wa4(i - 2)*cc(i,k,5) - wa4(i - 1)*cc(i - 1,k,5)
      cr2 = dr2 + dr5
      ci5 = dr5 - dr2
      cr5 = di2 - di5
      ci2 = di2 + di5
      cr3 = dr3 + dr4
      ci4 = dr4 - dr3
      cr4 = di3 - di4
      ci3 = di3 + di4
      ch(i - 1,1,k) = cc(i - 1,k,1) + cr2 + cr3
      ch(i,1,k) = cc(i,k,1) + ci2 + ci3
      tr2 = cc(i - 1,k,1) + tr11*cr2 + tr12*cr3
      ti2 = cc(i,k,1) + tr11*ci2 + tr12*ci3
      tr3 = cc(i - 1,k,1) + tr12*cr2 + tr11*cr3
      ti3 = cc(i,k,1) + tr12*ci2 + tr11*ci3
      tr5 = ti11*cr5 + ti12*cr4
      ti5 = ti11*ci5 + ti12*ci4
      tr4 = ti12*cr5 - ti11*cr4
      ti4 = ti12*ci5 - ti11*ci4
      ch(i - 1,3,k) = tr2 + tr5
      ch(ic - 1,2,k) = tr2 - tr5
      ch(i,3,k) = ti2 + ti5
      ch(ic,2,k) = ti5 - ti2
      ch(i - 1,5,k) = tr3 + tr4
      ch(ic - 1,4,k) = tr3 - tr4
      ch(i,5,k) = ti3 + ti4
      ch(ic,4,k) = ti4 - ti3
   end do
end do
return
104 do i = 3,ido,2
   ic = idp2 - i
   do k = 1,l1
      dr2 = wa1(i - 2)*cc(i - 1,k,2) + wa1(i - 1)*cc(i,k,2)
      di2 = wa1(i - 2)*cc(i,k,2) - wa1(i - 1)*cc(i - 1,k,2)
      dr3 = wa2(i - 2)*cc(i - 1,k,3) + wa2(i - 1)*cc(i,k,3)
      di3 = wa2(i - 2)*cc(i,k,3) - wa2(i - 1)*cc(i - 1,k,3)
      dr4 = wa3(i - 2)*cc(i - 1,k,4) + wa3(i - 1)*cc(i,k,4)
      di4 = wa3(i - 2)*cc(i,k,4) - wa3(i - 1)*cc(i - 1,k,4)
      dr5 = wa4(i - 2)*cc(i - 1,k,5) + wa4(i - 1)*cc(i,k,5)
      di5 = wa4(i - 2)*cc(i,k,5) - wa4(i - 1)*cc(i - 1,k,5)
      cr2 = dr2 + dr5
      ci5 = dr5 - dr2
      cr5 = di2 - di5
      ci2 = di2 + di5
      cr3 = dr3 + dr4
      ci4 = dr4 - dr3
      cr4 = di3 - di4
      ci3 = di3 + di4
      ch(i - 1,1,k) = cc(i - 1,k,1) + cr2 + cr3
      ch(i,1,k) = cc(i,k,1) + ci2 + ci3
      tr2 = cc(i - 1,k,1) + tr11*cr2 + tr12*cr3
      ti2 = cc(i,k,1) + tr11*ci2 + tr12*ci3
      tr3 = cc(i - 1,k,1) + tr12*cr2 + tr11*cr3
      ti3 = cc(i,k,1) + tr12*ci2 + tr11*ci3
      tr5 = ti11*cr5 + ti12*cr4
      ti5 = ti11*ci5 + ti12*ci4
      tr4 = ti12*cr5 - ti11*cr4
      ti4 = ti12*ci5 - ti11*ci4
      ch(i - 1,3,k) = tr2 + tr5
      ch(ic - 1,2,k) = tr2 - tr5
      ch(i,3,k) = ti2 + ti5
      ch(ic,2,k) = ti5 - ti2
      ch(i - 1,5,k) = tr3 + tr4
      ch(ic - 1,4,k) = tr3 - tr4
      ch(i,5,k) = ti3 + ti4
      ch(ic,4,k) = ti4 - ti3
   end do
end do
end subroutine radf5

subroutine radfg(ido,ip,l1,idl1,cc,c1,c2,ch,ch2,wa)
implicit none
integer, intent(in) :: idl1, ido, ip, l1
real, intent(inout) :: c1(ido,l1,ip), c2(idl1,ip), cc(ido,ip,l1), &
   & ch(ido,l1,ip), ch2(idl1,ip)
real :: wa(*)
integer :: i, ic, idij, idp2, ik, ipp2, ipph, is, j, j2, jc, k, l, &
   & lc, nbd
real :: ai1, ai2, ar1, ar1h, ar2, ar2h, arg, dc2, dcp, ds2, dsp
real, parameter :: tpi = 6.28318530717959
arg = tpi/float(ip)
dcp = cos(arg)
dsp = sin(arg)
ipph = (ip + 1)/2
ipp2 = ip + 2
idp2 = ido + 2
nbd = (ido - 1)/2
if (ido == 1) go to 119
do ik = 1,idl1
   ch2(ik,1) = c2(ik,1)
end do
do j = 2,ip
   do k = 1,l1
      ch(1,k,j) = c1(1,k,j)
   end do
end do
if (nbd > l1) go to 107
is = -ido
do j = 2,ip
   is = is + ido
   idij = is
   do i = 3,ido,2
      idij = idij + 2
      do k = 1,l1
         ch(i - 1,k,j) = wa(idij - 1)*c1(i - 1,k,j) + wa(idij)*c1(i,k,j)
         ch(i,k,j) = wa(idij - 1)*c1(i,k,j) - wa(idij)*c1(i - 1,k,j)
      end do
   end do
end do
go to 111
107 is = -ido
do j = 2,ip
   is = is + ido
   do k = 1,l1
      idij = is
      do i = 3,ido,2
         idij = idij + 2
         ch(i - 1,k,j) = wa(idij - 1)*c1(i - 1,k,j) + wa(idij)*c1(i,k,j)
         ch(i,k,j) = wa(idij - 1)*c1(i,k,j) - wa(idij)*c1(i - 1,k,j)
      end do
   end do
end do
111 if (nbd < l1) go to 115
do j = 2,ipph
   jc = ipp2 - j
   do k = 1,l1
      do i = 3,ido,2
         c1(i - 1,k,j) = ch(i - 1,k,j) + ch(i - 1,k,jc)
         c1(i - 1,k,jc) = ch(i,k,j) - ch(i,k,jc)
         c1(i,k,j) = ch(i,k,j) + ch(i,k,jc)
         c1(i,k,jc) = ch(i - 1,k,jc) - ch(i - 1,k,j)
      end do
   end do
end do
go to 121
115 do j = 2,ipph
   jc = ipp2 - j
   do i = 3,ido,2
      do k = 1,l1
         c1(i - 1,k,j) = ch(i - 1,k,j) + ch(i - 1,k,jc)
         c1(i - 1,k,jc) = ch(i,k,j) - ch(i,k,jc)
         c1(i,k,j) = ch(i,k,j) + ch(i,k,jc)
         c1(i,k,jc) = ch(i - 1,k,jc) - ch(i - 1,k,j)
      end do
   end do
end do
go to 121
119 do ik = 1,idl1
   c2(ik,1) = ch2(ik,1)
end do
121 do j = 2,ipph
   jc = ipp2 - j
   do k = 1,l1
      c1(1,k,j) = ch(1,k,j) + ch(1,k,jc)
      c1(1,k,jc) = ch(1,k,jc) - ch(1,k,j)
   end do
end do
!
ar1 = 1.
ai1 = 0.
do l = 2,ipph
   lc = ipp2 - l
   ar1h = dcp*ar1 - dsp*ai1
   ai1 = dcp*ai1 + dsp*ar1
   ar1 = ar1h
   do ik = 1,idl1
      ch2(ik,l) = c2(ik,1) + ar1*c2(ik,2)
      ch2(ik,lc) = ai1*c2(ik,ip)
   end do
   dc2 = ar1
   ds2 = ai1
   ar2 = ar1
   ai2 = ai1
   do j = 3,ipph
      jc = ipp2 - j
      ar2h = dc2*ar2 - ds2*ai2
      ai2 = dc2*ai2 + ds2*ar2
      ar2 = ar2h
      do ik = 1,idl1
         ch2(ik,l) = ch2(ik,l) + ar2*c2(ik,j)
         ch2(ik,lc) = ch2(ik,lc) + ai2*c2(ik,jc)
      end do
   end do
end do
do j = 2,ipph
   do ik = 1,idl1
      ch2(ik,1) = ch2(ik,1) + c2(ik,j)
   end do
end do
!
if (ido < l1) go to 132
do k = 1,l1
   do i = 1,ido
      cc(i,1,k) = ch(i,k,1)
   end do
end do
go to 135
132 do i = 1,ido
   do k = 1,l1
      cc(i,1,k) = ch(i,k,1)
   end do
end do
135 do j = 2,ipph
   jc = ipp2 - j
   j2 = j + j
   do k = 1,l1
      cc(ido,j2 - 2,k) = ch(1,k,j)
      cc(1,j2 - 1,k) = ch(1,k,jc)
   end do
end do
if (ido == 1) return
if (nbd < l1) go to 141
do j = 2,ipph
   jc = ipp2 - j
   j2 = j + j
   do k = 1,l1
      do i = 3,ido,2
         ic = idp2 - i
         cc(i - 1,j2 - 1,k) = ch(i - 1,k,j) + ch(i - 1,k,jc)
         cc(ic - 1,j2 - 2,k) = ch(i - 1,k,j) - ch(i - 1,k,jc)
         cc(i,j2 - 1,k) = ch(i,k,j) + ch(i,k,jc)
         cc(ic,j2 - 2,k) = ch(i,k,jc) - ch(i,k,j)
      end do
   end do
end do
return
141 do j = 2,ipph
   jc = ipp2 - j
   j2 = j + j
   do i = 3,ido,2
      ic = idp2 - i
      do k = 1,l1
         cc(i - 1,j2 - 1,k) = ch(i - 1,k,j) + ch(i - 1,k,jc)
         cc(ic - 1,j2 - 2,k) = ch(i - 1,k,j) - ch(i - 1,k,jc)
         cc(i,j2 - 1,k) = ch(i,k,j) + ch(i,k,jc)
         cc(ic,j2 - 2,k) = ch(i,k,jc) - ch(i,k,j)
      end do
   end do
end do
end subroutine radfg

subroutine cheby(a, b, f, g, phi, eps, itno, mxiter, l, m, &
   & p, q, error, ierr, w)
implicit none
integer, intent(inout) :: ierr, itno
integer, intent(in) :: l, m, mxiter
double precision, intent(in) :: a, b
double precision :: f, g, phi
double precision, intent(in) :: eps
double precision, intent(inout) :: error
double precision, intent(inout) :: p(*), q(*), w(*)
external f, g, phi
integer :: i1, i2, i3, i4, i5, lp1, lpm, mp1, n, np1
!     ******************************************************************
!     Rational Chebychev approximation of continuous functions
!     ******************************************************************
!     -------------------
if (l < 0 .or. m < 0) go to 10
lp1 = l + 1
mp1 = m + 1
lpm = l + m
n = lpm + 1
np1 = n + 1
!     -------------------
i1 = np1 + 1
i2 = i1 + np1
i3 = i2 + np1*np1
i4 = i3 + np1
i5 = i4 + np1
call cheby1(a, b, f, g, phi, eps, itno, mxiter, l, m, p, q, &
   & error, ierr, lp1, mp1, lpm, n, np1, w(1), &
   & w(i1), w(i2), w(i3), w(i4), w(i5))
return
!     ------------------------------------------------------------------
!     Error return
!     ------------------------------------------------------------------
10 ierr = 1
end subroutine cheby

subroutine cheby1(a, b, f, g, phi, eps, itno, mxiter, l, m, &
   & p, q, error, ierr, lp1, mp1, lpm, n, np1, &
   & x, xval, c, d, err, h)
implicit none
integer, intent(inout) :: ierr, itno
integer, intent(in) :: l, lp1, lpm, m, mp1, mxiter, n, np1
double precision, intent(in) :: a, b
double precision :: f, g, phi
double precision, intent(in) :: eps
double precision, intent(out) :: error
double precision, intent(inout) :: p(lp1), q(mp1), x(np1), &
   & xval(np1), c(np1,np1), d(np1), err(np1), h(np1)
external f, g, phi
integer :: i, ii, j, k, kount, lpi
double precision :: b1, del, dn, dnp1, h1, olderr, sign, sum, templ, test, u, xi, xlb, xm1, y, y2, y3, z, zz, z1, z2, z3
double precision, parameter :: pi = 3.14159265358979323846264338328d0
double precision, parameter :: zero = 0.d0
double precision, parameter :: half = .5d0
double precision, parameter :: one = 1.d0
double precision, parameter :: ten = 10.d0
double precision, parameter :: eps0 = 1.d-2
double precision, parameter :: tau = .015d0
double precision, parameter :: c0 = .0625d0
!     ------------------------------------------------------------------
!     -------------------
!     -------------------
error = zero
if (eps <= zero .or. eps >= eps0) go to 200
ierr = 0
!
itno = 1
xlb = zero
dn = n
dnp1 = np1
!
do i = 1,lp1
10 p(i) = zero
end do
do i = 1,mp1
11 q(i) = zero
end do
q(1) = one
!
!     Compute initial approximations of the critical points
!
x(1) = a
x(np1) = b
k = n/2
if (k <= 0) go to 30
b1 = half*(b - a)
xm1 = half*(a + b)
do i = 1,k
   xi = i
   z = -b1*cos(pi*(xi/dn))
   x(i + 1) = z + xm1
   ii = np1 - i
20 x(ii) = xm1 - z
end do
!
!     Evaluate phi at the critical points
!
30 do i = 1,np1
31 xval(i) = phi(x(i))
end do
kount = 1
!
!     Set up the linear equations
!
40 k = l + 2
sign = one
do i = 1,np1
   sign = -sign
   c(i,1) = one
   if (l <= 0) go to 42
   do j = 2,lp1
41    c(i,j) = c(i,j - 1)*xval(i)
   end do
42 d(i) = f(x(i))
   if (m <= 0) go to 44
   templ = sign*xlb*g(x(i)) - d(i)
   c(i,k) = xval(i)*templ
   if (k > lpm) go to 44
   do j = k,lpm
43    c(i,j + 1) = c(i,j)*xval(i)
   end do
44 c(i,np1) = sign*g(x(i))
end do
!
!     Solve the equations CX = D and store the results in D
!
call dpslv(np1, 1, c, np1, d, np1, ierr)
if (ierr /= 0) go to 220
if (kount > 1) go to 50
!
!     Redefine the equations and solve
!
xlb = (d(np1) + xlb*dn)/dnp1
if (m <= 0) go to 61
kount = 2
go to 40
!
50 test = abs(xlb - d(np1))
xlb = (d(np1) + xlb*dn)/dnp1
kount = kount + 1
if (kount <= 4 .and. test > eps0*abs(xlb)) go to 40
!
!     Store the results in p and q
!
do i = 2,mp1
   lpi = l + i
60 q(i) = d(lpi)
end do
61 do i = 1,lp1
62 p(i) = d(i)
end do
!
!     Search for new critical points
!
olderr = error
error = zero
z1 = zero
u = one
if (xlb < zero) u = -u
!
if (n > 1) go to 70
h(1) = tau*(x(2) - x(1))
h(2) = -h(1)
go to 72
70 do i = 2,n
71 h(i) = tau*(x(i + 1) - x(i - 1))
end do
h(1) = half*h(2)
h(np1) = -half*h(n)
72 continue
!
do i = 1,np1
   y2 = x(i)
   h1 = h(i)
   y3 = y2 + h1
   call cerr(y2, f(y2), g(y2), phi(y2), del, ierr, l, lp1, m, np1, d)
   if (ierr /= 0) return
   z2 = u*del
   call cerr(y3, f(y3), g(y3), phi(y3), del, ierr, l, lp1, m, np1, d)
   if (ierr /= 0) return
   z3 = u*del
   if (z2 < z3) go to 80
   h1 = -h1
   z = z3
   z3 = z2
   z2 = z
   y = y3
   y3 = y2
   y2 = y
!
80 y = y3 + h1
   if (y >= a) go to 81
   y = a
   go to 90
81 if (y <= b) go to 82
   y = b
   go to 90
82 call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
   if (ierr /= 0) return
   z = u*del
   if (z <= z3) go to 83
   y2 = y3
   y3 = y
   z2 = z3
   z3 = z
   go to 80
83 y = (z - z3) + (z2 - z3)
   if (y /= zero) go to 84
   y = y3
   go to 90
84 y = half*(y2 + y3) + h1*(z2 - z3)/y
!
90 x(i) = y
   call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
   if (ierr /= 0) return
   err(i) = del
   u = -u
   if (i == 1) go to 91
   if (x(i) <= x(i - 1)) go to 230
91 z = abs(err(i))
   error = max(error, z)
   if (z >= ten) go to 240
   y = abs(xlb)
   zz = one
   if (y /= zero) zz = abs(z - y)/y
   if (z1 < zz) z1 = zz
end do
!
!     Search for an extra extremal point between the endpoints
!     of the interval and the critical points
!
if (x(1) <= a) go to 110
h1 = c0*(x(1) - a)
u = one
if (xlb >= zero) u = -u
z3 = zero
y = a
do i = 1,16
   call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
   if (ierr /= 0) return
   z = u*del
   if (z <= z3) go to 100
   z3 = z
   z2 = y
100 y = y + h1
end do
error = max(error, z3)
z = abs(xlb)
if (z3 <= z) go to 110
i = np1
do ii = 2,np1
   err(i) = err(i - 1)
   x(i) = x(i - 1)
101 i = i - 1
end do
x(1) = z2
err(1) = u*z3
go to 113
!
110 if (x(np1) >= b) go to 120
h1 = c0*(b - x(np1))
u = one
if (err(np1) >= zero) u = -u
z3 = zero
y = b
do i = 1,16
   call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
   if (ierr /= 0) return
   z = u*del
   if (z <= z3) go to 111
   z3 = z
   z2 = y
111 y = y - h1
end do
error = max(error, z3)
z = abs(xlb)
if (z3 <= z) go to 120
do i = 1,n
   err(i) = err(i + 1)
112 x(i) = x(i + 1)
end do
x(np1) = z2
err(np1) = u*z3
113 xlb = -xlb
zz = one
if (z /= zero) zz = abs(z3 - z)/z
if (z1 < zz) z1 = zz
!
!     Check for convergence
!
120 if (z1 <= eps) return
!
!     Set up for the next iteration
!
if (itno >= mxiter) go to 210
sum = zero
sign = one
do i = 1,np1
   sum = sum + sign*err(i)
130 sign = -sign
end do
xlb = sum/dnp1
itno = itno + 1
go to 30
!     ------------------------------------------------------------------
!     Error return
!     ------------------------------------------------------------------
!     Input error
!
200 ierr = 1
return
!
!     mxiter iterations were performed - More iterations are needed
!
210 ierr = 2
return
!
!     The linear equations cannot be solved
!
220 if (itno == 1) go to 250
ierr = 3
return
!
!     The sequence of critical points is not monotonically increasing
!
230 ierr = 4
if (i <= n) error = olderr
return
!
!     It appears that the algorithm has failed to converge
!     there may be poles in the rational approximation
!
240 ierr = 5
return
!
!     The routine HAS completely failed - The results should be ignored
!
250 ierr = 6
end subroutine cheby1

pure subroutine cerr(t, ft, gt, phit, del, ierr, l, lp1, m, np1, d)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, lp1, m, np1
double precision, intent(in) :: t, ft, gt, phit
double precision, intent(inout) :: del
double precision, intent(in) :: d(np1)
integer :: i, ii
double precision :: p, q, r
double precision, parameter :: zero = 0.d0
double precision, parameter :: one = 1.d0
!     ------------------------------------------------------------------
!     Compute the approximation error at point t
!     ------------------------------------------------------------------
!     -------------------
p = d(lp1)
if (l <= 0) go to 20
do i = 1,l
   ii = lp1 - i
10 p = p*phit + d(ii)
end do
!
20 q = zero
if (m <= 0) go to 22
do i = 1,m
   ii = np1 - i
21 q = (q + d(ii))*phit
end do
22 q = q + one
!
if (q == zero) go to 110
if (gt == zero) go to 100
r = p/q
del = (r - ft)/gt
return
!     ------------------------------------------------------------------
!     Error return
!     ------------------------------------------------------------------
!     The function G is zero at point t
!
100 ierr = 1
return
!
!     The routine HAS completely failed - The results should be ignored
!
110 ierr = 6
end subroutine cerr

subroutine adapt(f, xlft, xrgt, epsln, npiece, errest, xknots, &
   & coefs, ierr, kmax, ndeg, nsmth, anorm, dx, mo, kbreak, brakpt, &
   & kdiff, vallft, valrgt)
implicit none
integer :: ierr, kbreak, kdiff(kbreak), kmax, mo, ndeg, npiece, &
   & nsmth
double precision :: xknots(*), coefs(kmax,*)
double precision :: anorm, brakpt(kbreak), dx, epsln, errest, &
   & vallft(kbreak), valrgt(kbreak), xlft, xrgt
double precision :: f
external f
integer :: k, kdimen, ndimen
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
!
!        ===============================================================
!
!     Tabulation of the internal and external names of the arguments.
!
!
!    INTERNAL   EXTERNAL
!     f          f
!     A          XLFT
!     b          XRGT
!     accur      epsln
!     KNOTS      npiece
!     ERROR      errest
!     xknots     xknots
!     coefs      coefs
!     ierr       ierr
!     kmax       kmax
!     DEGREE     ndeg
!     SMOOTH     NSMTH
!     NORM       anorm
!     charf      dx
!     edist      mo
!     nbreak     kbreak
!     XBREAK     brakpt
!     dbreak     kdiff
!     bleft      VALLFT
!     BRIGHT     VALRGT
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!
!
10 a = xlft
b = xrgt
accur = epsln
degree = ndeg
smooth = nsmth
norm = anorm
charf = dx
edist = mo
nbreak = kbreak
if (nbreak <= 0 .or. nbreak >= 21) go to 30
do k = 1,nbreak
   xbreak(k) = brakpt(k)
   dbreak(k) = kdiff(k)
   bleft(k) = vallft(k)
   bright(k) = valrgt(k)
20 continue
end do
30 continue
!
kdimen = kmax + 1
ndimen = ndeg + 1
call adapt1(f, xknots, coefs, kdimen, kmax, ndimen, ierr)
npiece = knots
errest = error
end subroutine adapt

subroutine adapt1(f, xknots, coefs, kdimen, kmax, ndimen, ierr)
implicit none
integer :: ierr, kdimen, kmax, ndimen
double precision :: xknots(kdimen), coefs(kmax,ndimen)
double precision :: f
external f
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
!
!     This algorithm computes a piecewise polynomial approximation
!  of specified smoothness, accuracy and degree.  The input to the
!  computation is
!
!   f      - Function being approximated. It must provide values of
!            derivatives up to the order of smoothness specified for
!            the approximation.  The calling sequence is f(X,FDERV) and
!            FDERV contains the derivatives( see constraint below)
!   A,b    - THE ENDPOINTS OF THE INTERVAL OF APPROXIMATION
!   accur  - The accuracy required for the approximation
!   smooth - The smoothness required for the approximation
!              = 0  Means continuous
!              = 1  Means continuous slope
!              = 2  Means continuous second derivative, etc.
!   degree - The degree of the polynomial pieces.
!            Must have degree GT 2*smooth
!   charf  - Characteristic length of the function f(X). Pieces are not
!            longer than this length.
!   Norm   - Norm to measure the approximation error
!              = 1  L1 APPROXIMATION (LEAST DEVIATIONS)
!              = 2  L2 APPROXIMATION (LEAST SQUARES)
!              = 3  TCHEBYCHEFF (MINIMAX) APPROXIMATION
!              =-P  (NEGATIVE VALUE) GENERAL LP APPROXIMATION
!   nbreak - Number of special break points in the approximation.
!            Associated input variables are
!              XBREAK(J)  - Location of break points
!              dbreak(J)  - Derivative broken at XBREAK
!              bleft (J)  - Value from left for dbreak derivative
!              bright(J)  -   -    -   right -    -        -
!   edist  - Switch to change from proportional error distribution
!            to fixed distribution. This is primarily of use in
!            approximation of functions with singularities. One should
!            use norm = 1. Or so in such cases
!              = 0  Proportional distribution
!              = 1  Approximate fixed error distribution
!                   attempts to achieve specified accuracy value accur
!              = 2  True fixed error distribution
!
!  ********** OUTPUT **********
!     the output of the computation consists of 4 parts, each returned
!     to the user in a different way. They are
!
!   xknots,coefs - Arrays defining the piecewise polynomial result.
!            xknots(K)  = knots of the approximation ( K = 1 To knots)
!                         the last one is right end point of interval
!            coefs(K,N) = Coefficient of (X - XKNOT(K))**(N-1) in the
!                         interval XKNOT(K) to XKNOT(K+1)
!                           K = 1 To knots-1  and  N = 1 To degree+1
!            these arrays are passed as arguments so as to use variable
!            dimensions. The arrays are of dimension xknots(kdimen) and
!            coefs(kmax,ndimen). It is assumed that kdimen = kmax+1.
!               ***** Note ***** several small arrays here have fixed
!                        dimensions that limit degree and thus ndimen
!                        should not exceed this limit (currently = 20)
!
!   RESULZ - a labeled common block containing knots and error
!              knots - Number of knots of the approximation
!              error - Estimated accuracy of the approximation
!
!   ierr - Status indicator. ierr takes the values
!      0   THE APPROXIMATION WAS SUCCESSFULLY CONSTRUCTED.
!     -1   INPUT ERROR REPORTED BY adset.
!     -2   A AND b ARE TOO CLOSE.
!     -3   charf IS TOO SMALL.
!     -4   EITHER ALL THE BREAK POINTS ARE NOT BETWEEN A AND b, OR
!          XBREAK(I).GE.XBREAK(I+1) for some I.
!     -5   dbreak(I).LT.0 .OR. dbreak(I).GT.(degree-1)/2 for some I.
!      1   THE KNOT LIMIT WAS EXCEEDED.
!      2   BREAK POINT ADJUSTMENT REQUIRES THAT A SUBINTERVAL BE
!          partitioned. However, this cannot be done either because
!          the interval stack is full, or partitioning will produce
!          too small an interval.
!      3   A SUBINTERVAL MUST BE PARTITIONED BECAUSE ITS LENGTH IS
!          greater than charf. However, this cannot be done since the
!          interval stack is full.
!      4   A SUBINTERVAL MUST BE PARTITIONED SO THAT THE ACCURACY
!          criteria can be satisfied. However, this cannot be done
!          either because the interval stack is full, or partitioning
!          will produce too small an interval.
!
!  ********** Dimension constraints **********
!     maxknt - Max number of knots taken from user via kdimen
!              arrays with this dimension (or related values)
!                   coefs   xknots
!     maxpar - Max number of parameters per interval (currently = 20)
!                   user provided ndimen must have ndimen le maxpar
!                   must have  degree + 1 le maxpar
!              arrays with this dimension (or related values)
!                D       DDTEMP  FDERVL  FDERVR  FDUMB   FACTOR
!                FINTRP  FLEFT   FRIGHT  POWERS  XTEMP   XINTRP  XDD
!              ***** note ***** maxpar also affects argument fderv
!              of function f.  FDERVL, FDERVR are also involved.
!              Should declare FDERV of size 10 in f to be safe.
!     maxaux - Maximum number of auxiliary input ( = 20 Now ). Arrays
!                 XBREAK  dbreak  bleft   BRIGHT
!     maxstk - Max size of active interval stack
!              min interval length is 2**(-maxstk)*(b-a). Arrays
!                 XLEFT   XRIGHT
!
!  **********  Portability considerations  **********
!
!     All the routines in this package (except adapt) are written in
!     ANSI standard Fortran. In addition, they meet all the requirements
!     of the Bell labs portable Fortran -PFORT-.  Nevertheless, the
!     routines are affected by a change in machine word length and
!     changing to single precision.
!
!     ***** The Gauss weights and abscissae in adcomp are given to
!           30 digits. The parameter eps0 in adset specifies the
!           accuracy of these constants. If the accuracy is changed
!           to K decimal digits then set EPS0 = 10**(-K).
!
!     ***** The interval stack size maxstk is defined in adset to
!           be 50. If maxstk is modified then set the dimensions of
!           XLEFT and XRIGHT to the new value for maxstk. Note that
!           the minimum interval length is 2**(-maxstk)*(b-a).
!
!  Single precision conversion -- requires four steps
!     1. Declare all double precision variables to be real.
!
!     2. Change all double precision numbers in the data statements.
!        (Floating point numbers appear only in data statements.)
!
!     3. Change dabs,DMAX1,DMIN1 at many places.
!
!     4. Change dpmpar to spmpar in adset.
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
!                      kntdim - kdimen, name changed to put in common
!                      npardm - ndimen, name changed to put in common
common /resulz/ error, knots
!                      knots = Final no. of knots, includes b as one.
!                      Error = Estimate of error actually achieved.
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
!             KONTRL contains generally useful variables
!                      maxstk - See comments above
!                      buffer - The machine dependent tolerance used
!                               by the algorithm
!                      NSTACK - Counter for interval stack, consists of
!                               (XLEFT(J),XRIGHT(J))  J = 1 TO NSTACK
!                      ERRORI - Error estimate for top interval
!                      DSCTOL - Tolerance to check discarding intervals
!                      discrd - Switch to signal discard of top interval
!                      factor - Array of factorials
!                      NPAR   - Number of PAREMETERS = degree + 1
!                      interp - Number of interior interpolation points
!                               in the normal interval
!                      ibreak - Counter on break points
!                      break  - Switch for break point in top interval
!                               0     = No break present
!                               left  = break at XLEFT(NSTACK)
!                               right = break at XRIGHT(NSTACK)
!                               both  = break at both ends
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!             COMDIF contains variables used only by adcomp and friends.
!                      nintrp - Number of interior interpolation points
!                               for the current interval
!                      XINTRP - Interior interpolation points
!                      FINTRP - f values at XINTRP points
!                      leftx  - Multiplicity of interpolation at XLEFT
!                               = No. of derivatives matched at XLEFT
!                      FLEFT  - Values of f and its derivatives at XLEFT
!                      rightx - Multiplicity of interpolation at XRIGHT
!                      fright - Values of f and derivatives at XRIGHT
!                      DDTEMP - The array of divided differences
!                      XDD    - The X values for DDTEMP with proper
!                               multiplicities of XLEFT and XRIGHT
!
!------------------------ Main control program -------------------------
!
!            Check the input and initialize all the parameters
!
call adset(xknots, coefs, kdimen, kmax, ndimen, ierr)
if (ierr /= 0) return
!
!                  Loop over processing of intervals
!
10 call adtake(ierr)
if (ierr /= 0) return
call adcomp(f)
!
!                   Check for discarding intervals
!
call adchk
!
!            Put new intervals on stack or discard, update status
!
call adput(xknots, coefs, kdimen, kmax, ndimen, ierr)
if (ierr /= 0) return
!
!                    Test for normal termination
!
if (nstack == 0) return
!
!                Check on the number of knots generated
!
if (knots < maxknt) go to 10
ierr = 1
end subroutine adapt1

subroutine adset(xknots, coefs, kdimen, kmax, ndimen, ierr)
implicit none
integer :: ierr, kdimen, kmax, ndimen
double precision :: xknots(kdimen), coefs(kmax,ndimen)
integer :: j, k, limsm
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: akmax, eps, km1, ratio
!
!        ===============================================================
!
! **  This program checks the input data and initializes the computation
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
double precision, parameter :: eps0 = 1.d-30
double precision, parameter :: zero = 0.d0
double precision, parameter :: one = 1.d0
double precision, parameter :: two = 2.d0
double precision, parameter :: three = 3.d0
double precision, parameter :: c100 = 100.d0
integer, parameter :: kleft = 1
integer, parameter :: kright = 2
integer, parameter :: kboth = 3
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!
!
eps = dpmpar(1)
buffer = c100*max(eps,eps0)
!
!         Put data statement items into common variables
!
left = kleft
right = kright
both = kboth
!
! -------- Set current values of limits on dimensions ------------------
!
kntdim = kdimen
npardm = ndimen
maxknt = kntdim
maxstk = 50
maxpar = min(20,npardm)
maxaux = 20
!
! -------- Check input data --------------------------------------------
!
ierr = 0
if (a >= b .or. accur <= zero) go to 200
if (degree >= maxpar .or. 2*smooth >= degree) go to 200
akmax = kmax
ratio = (b - a)/(abs(a) + abs(b))
if (ratio <= two*buffer*akmax) go to 210
if (charf < (b - a)/akmax) go to 220
if (norm >= zero .and. (norm - one)*(norm - two)*(norm - three) /= zero) &
   & go to 200
if (edist*(edist - 1)*(edist - 2) /= 0) go to 200
if (nbreak < 0 .or. nbreak > maxaux) go to 200
if (nbreak == 0) go to 150
!
!         Check the break point data, monotonicity and degree
!
j = 1
if (xbreak(1) < a .or. xbreak(nbreak) > b) go to 230
if (nbreak == 1) go to 110
do j = 2,nbreak
   if (xbreak(j - 1) >= xbreak(j)) go to 230
100 continue
end do
110 limsm = (degree - 1)/2
do j = 1,nbreak
   if (dbreak(j) < 0 .or. dbreak(j) > limsm) go to 240
end do
!
! -------- Initialization of variables ---------------------------------
!
!             Active interval stack
!
150 nstack = 1
xleft(1) = a
xright(1) = b
!
!             Termination and error values
!
error = zero
dsctol = accur**abs(norm)
if (edist == 0) dsctol = dsctol/(b - a)
if (norm == three) dsctol = accur
!
!             Miscellaneous variables and pointers
!
ibreak = 1
knots = 1
interp = degree + 2 - 2*smooth
xknots(1) = a
npar = degree + 1
!
!             Compute array of NPAR factorials
!
factor(1) = one
factor(2) = one
do k = 3,npar
   km1 = k - 1
   factor(k) = km1*factor(k - 1)
end do
return
!
! -------- Error return ------------------------------------------------
!
200 ierr = -1
return
!
!         A and b are too close
!
210 ierr = -2
return
!
!         charf is too small
!
220 ierr = -3
return
!
!         Break points are not monotonic
!
230 ierr = -4
return
!
!         Bad value in derivative breaks
!
240 ierr = -5
end subroutine adset

subroutine adtake(ierr)
implicit none
integer :: ierr
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: dx, ratio
!
!        ===============================================================
!
! **  This program takes an active interval off the top of the stack
!     it also does most of the work of locating and handling
!     break points
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!
!         Check for break point
break = 0
if (nbreak == 0 .or. ibreak > nbreak) go to 20
if (xbreak(ibreak) > xright(nstack)) go to 20
!
!               Set control variable break, check for location
if (xbreak(ibreak) > xleft(nstack)) go to 10
break = left
if (ibreak == nbreak) go to 20
!             Check for second break point in this interval
if (xbreak(ibreak + 1) >= xright(nstack)) go to 20
!                 Next break is inside interval, split top interval
break = both
!                  Check exceeding stack limit. If so, stop
if (nstack == maxstk) go to 30
!                     Dont split very small intervals, stop instead
dx = xbreak(ibreak + 1) - xleft(nstack)
ratio = dx/(abs(a) + abs(b))
if (ratio <= buffer) go to 30
nstack = nstack + 1
xleft(nstack) = xleft(nstack - 1)
xright(nstack) = xbreak(ibreak + 1)
xleft(nstack - 1) = xright(nstack)
go to 20
!
10 break = right
!                 Check to see if break is already at right end point
if (xbreak(ibreak) >= xright(nstack)) go to 20
!                 The break is inside interval, split top interval
!                  check exceeding stack limit. If so, stop
if (nstack == maxstk) go to 30
!                     Dont split very small intervals, stop instead
dx = xbreak(ibreak) - xleft(nstack)
ratio = dx/(abs(a) + abs(b))
if (ratio <= buffer) go to 30
nstack = nstack + 1
xleft(nstack) = xleft(nstack - 1)
xright(nstack) = xbreak(ibreak)
xleft(nstack - 1) = xright(nstack)
20 continue
return
!
!        A break point is in the interior of the top subinterval of
!        the stack.  The subinterval cannot be partitioned either
!        because the stack is full, or because partitioning leads to
!        too small an interval.
!
30 ierr = 2
end subroutine adtake

subroutine adcomp(f)
implicit none
double precision :: f
external f
integer :: j
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: absc(4), aj, dx, fdervl(9), fdervr(9), &
   & fdumb(9), r, wgts(4)
double precision :: errint, polydd
external polydd
!
!        ===============================================================
!
! **  This program computes the piecewise polynomial approximation on
!     the current interval. It also estimates the error
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!
equivalence (fleft(2),fdervl(1)), (fright(2),fdervr(1))
data r/1.5d0/
!
!     Thirty digit values for the Gauss integration constants
!                    .861136311594052575223946488893D0
!                    .339981043584856264802665759103D0
!                    .347854845137453857373063949222D0
!                    .652145154862546142626936050778D0
!
!     ***** The ABSISSAE and weights are given below to 30 digits.
!           The parameter eps0 in adset specifies the accuracy of
!           these constants. If the accuracy is changed to K decimal
!           digits then set EPS0 = 10**(-K).
!
data absc(1) /-.861136311594052575223946488893d0 /
data absc(2) /-.339981043584856264802665759103d0 /
data absc(3) / .339981043584856264802665759103d0 /
data absc(4) / .861136311594052575223946488893d0 /
data wgts(1) / .347854845137453857373063949222d0 /
data wgts(2) / .652145154862546142626936050778d0 /
data wgts(3) / .652145154862546142626936050778d0 /
data wgts(4) / .347854845137453857373063949222d0 /
!
!             Compute interpolation information
nintrp = degree - 2*smooth - 1
!
!          Increase number of interpolation points if break points are
!          specified with fewer derivatives than smooth
if (break == left .or. break == right) nintrp = nintrp + smooth - &
   & dbreak(ibreak)
if (break == both) nintrp = nintrp + 2*smooth - dbreak(ibreak) - &
   & dbreak(ibreak + 1)
if (nintrp == 0) go to 20
!
!             Generate equal spaced interpolation points
aj = nintrp + 1
dx = (xright(nstack) - xleft(nstack))/aj
do j = 1,nintrp
   aj = j
   xintrp(j) = xleft(nstack) + aj*dx
10 continue
end do
!
!             Get left and right f-values, put f-value in first element
!             of arrays FLEFT and fright.  Get derivatives back as
!             other elements via the subarrays fdervl and fdervr.
20 fleft(1) = f(xleft(nstack),fdervl)
fright(1) = f(xright(nstack),fdervr)
leftx = smooth + 1
rightx = leftx
!            Get f-values at other interpolation points, if any
if (nintrp == 0) go to 40
do j = 1,nintrp
   fintrp(j) = f(xintrp(j),fdumb)
end do
!
!          Check for break points, modify values if necessary
40 continue
if (break /= left) go to 50
leftx = dbreak(ibreak) + 1
fleft(leftx) = bright(ibreak)
50 if (break /= right) go to 60
rightx = dbreak(ibreak) + 1
fright(rightx) = bleft(ibreak)
60 if (break /= both) go to 70
leftx = dbreak(ibreak) + 1
rightx = dbreak(ibreak + 1) + 1
fleft(leftx) = bright(ibreak)
fright(rightx) = bleft(ibreak + 1)
70 continue
!
!           Compute divided differences, Newton form of polynomial
call newton(leftx, rightx, nintrp)
!
!         Compute norm of error of this appromimation using four pts
!         add 50 percent fudge factor
errori = errint(f,polydd,xleft(nstack),xright(nstack),absc,wgts)
errori = r*errori
end subroutine adcomp

double precision function errint(f, fit, aaa, bbb, points, weight)
implicit none
double precision :: aaa, bbb, fit, points(*), weight(*)
double precision :: f
external f, fit
integer :: j
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: abmid, ba, fdumb(9), p, pj, er, f1, f2
!
!        ===============================================================
!
! **  This function does a four point integration rule for the
!     absolute value of the difference of two functions( f and fit )
!                   abs( f(X) - fit(X) )**NORM
!     the integration uses the points and weights given and scaled
!     from (-1,1) to (aaa,bbb)
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
double precision, parameter :: two = 2.0d0
double precision, parameter :: three = 3.0d0
!
!
!         Compute midpoint = abmid and half length = ba of interval
abmid = (aaa + bbb)/two
ba = (bbb - aaa)/two
pj = abmid + ba*points(1)
!
!         Test for Tchebycheff (minimax) norm which uses special code
if (norm == three) go to 20
!
!         Have general LP norm or least squares or least deviations
p = abs(norm)
!              Initialize the quadrature rule
errint = abs(f(pj,fdumb) - fit(pj))**p*weight(1)
!              Loop through remaining points
do j = 2,4
   pj = abmid + ba*points(j)
   f1 = f(pj,fdumb)
   f2 = fit(pj)
   er = abs(f1 - f2)**p
   errint = errint + abs(f(pj,fdumb) - fit(pj))**p*weight(j)
10 continue
end do
errint = errint*ba
go to 40
!
!         Tchebycheff norm
20 continue
!             Find max error on points
!               initialize
errint = abs(f(pj,fdumb) - fit(pj))
!              Loop through the remaining points
do j = 2,4
   pj = abmid + ba*points(j)
   errint = max(errint,abs(f(pj,fdumb) - fit(pj)))
end do
40 continue
end function errint

subroutine newton(nl, nr, ni)
implicit none
integer :: ni, nl, nr
integer :: idif, ipt, ipt2, j, k, nddx, nl1, nl2, nr1, nr2, nrl, &
   & nrlj, nrlj1
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: difff, diffx
!
!        ===============================================================
!
! **  This program computes the divided differences array as follows
!         nl COALESCED POINTS ON left   - DERIV VALUES IN FLEFT
!         nr COALESCED POINTS ON right  -   -      -    - FRIGHT
!         ni DISTINCT  POINTS INBETWEEN - FNCTN    -    - FINTRP
!
!     The points are ordered XL = XLEFT (NSTACK)
!                            xr = xright(nstack)
!                            XINTRP ARRAY
!
!         Layout of the DDTEMP divided difference array
!
!     nl=6    llllll****ii
!     nr=4    Lllll****II     L = First triangle
!     ni=2    llll****ii
!             LLL****II       R = Second triangle
!             LL****II
!             L****II         * = Fill between triangles
!             RRRRII
!             RRRII           I = Completion for interpolation points
!             RRII
!             RII       idif = Horizontal coord. = Difference order
!             II        ipt  = Vertical coord. Associated with points
!             I
!
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!
!                 Main calculation of divided differences
!         define a few short constants
nl1 = nl - 1
nl2 = nl + 1
nr1 = nr - 1
nr2 = nr + 1
nrl = nr + nl
!
!         Put X-values in a single array with nddx = nl+nr+ni points
do nddx = 1,nl
   xdd(nddx) = xleft(nstack)
10 continue
end do
nddx = nl
do k = 1,nr
   nddx = nddx + 1
   xdd(nddx) = xright(nstack)
20 continue
end do
!            Check if there are any interpolation points to add to XDD
if (ni == 0) go to 40
do k = 1,ni
   nddx = nddx + 1
   xdd(nddx) = xintrp(k)
end do
!
!           Fill border of first triangle - Size nl.
40 continue
!         Top border
do idif = 1,nl
   ddtemp(idif,1) = fleft(idif)/factor(idif)
50 continue
end do
if (nl1 == 0) go to 70
!                   Bottom border
do idif = 1,nl1
   ipt = nl2 - idif
   ddtemp(idif,ipt) = ddtemp(idif,1)
end do
!
!          Fill border of second triangle - Size nr
70 continue
!         Top border
do idif = 1,nr
   ddtemp(idif,nl2) = fright(idif)/factor(idif)
end do
if (nrl == nl2) go to 100
!                   Bottom border
do idif = 1,nr1
   ipt = nrl + 1 - idif
   ddtemp(idif,ipt) = ddtemp(idif,nl2)
end do
!
!           Fill parallogram between the two triangles just filled
!          fill entries parallel to bottom of first triangle
100 continue
!
!         Loop stepping along top side of second triangle
do j = 2,nr2
   idif = j
!             Loop stepping parallel to bottom side of first triangle
   do k = 2,nl2
      ipt = nl + 2 - k
      difff = ddtemp(idif - 1,ipt + 1) - ddtemp(idif - 1,ipt)
      ipt2 = ipt - 1 + idif
      diffx = xdd(ipt2) - xdd(ipt)
      ddtemp(idif,ipt) = difff/diffx
      idif = idif + 1
   end do
end do
!
!         Fill in bottom diagonals for interpolation points, if any
if (ni == 0) go to 150
!         Loop through the interpolatation points
do j = 1,ni
   idif = 2
   nrlj = nrl + j
   ddtemp(1,nrlj) = fintrp(j)
!         Loop through the differences (idif index)
   nrlj1 = nrlj - 1
   do k = 1,nrlj1
      ipt = nrlj - k
      difff = ddtemp(idif - 1,ipt + 1) - ddtemp(idif - 1,ipt)
      diffx = xdd(nrlj) - xdd(ipt)
      ddtemp(idif,ipt) = difff/diffx
      idif = idif + 1
   end do
end do
150 continue
end subroutine newton

double precision function polydd(x)
implicit none
double precision :: x
integer :: j, k
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
!
!        ===============================================================
!
! **  This function evaluates the current polynomial piece represented
!     by the divided differences DDTEMP on the point set XDD.
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!
polydd = ddtemp(degree + 1,1)
do k = 1,degree
   j = degree + 1 - k
   polydd = ddtemp(j,1) + (x - xdd(j))*polydd
10 continue
end do
end function polydd

subroutine adchk
implicit none
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: aknots, dtest, dx
integer :: nswc_ai_i4
!
!        ===============================================================
!
! **  This program checks for discarding interval, applies various
!     tests about discarding involving edist and charf.
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
double precision, parameter :: three = 3.0d0
double precision, parameter :: five = 5.0d0
!
!
discrd = .false.
dx = xright(nstack) - xleft(nstack)
if (dx > charf) return
!
!         Compute dtest for the local error criterion
!
if (norm == three) go to 30
nswc_ai_i4 = edist - 1
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 20
go to 30
10 dtest = dx*dsctol
go to 40
!         For the approximate fixed error distribution type we estimate
!         the final number of knots by( limiting it a little )
!             (NSTACK+knots+2)((b-a)/(XRIGHT-a))
20 aknots = nstack + knots + 2
dtest = dsctol/(aknots*min((b - a)/(xright(nstack) - a),five))
go to 40
30 dtest = dsctol
!
!             Check for discard of interval
!
40 if (errori <= dtest) discrd = .true.
end subroutine adchk

subroutine adput(xknots, coefs, kdimen, kmax, ndimen, ierr)
implicit none
integer :: ierr, kdimen, kmax, ndimen
double precision :: xknots(kdimen), coefs(kmax,ndimen)
integer :: k
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: dx, powers(20), p, ratio
!
!        ===============================================================
! **  This program puts intervals on the stack or discards them.
!     When an interval is discarded a new knot is found. Then this
!     program updates the error estimate, the XKNOT array, transforms
!     the polynomial to the power form and put the coefficients into
!     the array coefs.  It also checks for passing break points
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
double precision, parameter :: half = .5d0
double precision, parameter :: one = 1.d0
double precision, parameter :: three = 3.d0
!
!
!            Check for discarding the interval
if (discrd) go to 30
!
!         Subdivide interval and place on stack
if (nstack < maxstk) go to 10
!             Fatal error, exceeded active stack size
ierr = 4
dx = xright(nstack) - xleft(nstack)
if (dx > charf) ierr = 3
return
!
10 dx = (xright(nstack) - xleft(nstack))*half
!              Check for small intervals
ratio = dx/(abs(a) + abs(b))
if (ratio > buffer) go to 20
ierr = 4
return
!
20 nstack = nstack + 1
xleft(nstack) = xleft(nstack - 1)
xleft(nstack - 1) = xright(nstack - 1) - dx
xright(nstack) = xleft(nstack - 1)
return
!
!            Discard interval, update global error, xknots and coefs
30 p = abs(norm)
if (norm == three) error = max(error,errori)
if (norm /= three) error = (error**p + errori)**(one/p)
!
!              Check for passing break points
if (break == left .or. break == both) ibreak = ibreak + 1
!
!             Transform representation of polynomial from divided
!             differences to powers of X with origin at xknots (knots)
call adtran(ddtemp, powers)
!
!             Put coefs into the main array
do k = 1,npar
   coefs(knots,k) = powers(k)
end do
!            Put the new knots in xknots
knots = knots + 1
xknots(knots) = xright(nstack)
nstack = nstack - 1
end subroutine adput

subroutine adtran(d, powers)
implicit none
double precision :: d(20,*), powers(*)
integer :: i, ii, j, k, khi, koef, l, ltop, ni, ni1, nl, nr, nri, &
   & nri1, nrl, nrli, nrlk
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack
integer :: knots
double precision :: a, accur, b, bleft(20), bright(20), charf, &
   & ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
   & fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
   & xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
   & smooth
logical :: discrd
double precision :: shift, xl, xr, xtemp(20)
!
!        ===============================================================
!
! **  This program converts polynomial representation from divided
!     difference to power form.  There are coalesced points on each
!     END OF THE INTERVAL (xl,xr) = (XLEFT(NSTACK),XRIGHT(NSTACK)).
!     The number coalesced at each end is leftx and rightx.
!     And there are nintrp other pts XINTRP(k)  inbetween them.
!     See subroutine newton for more details
!
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
   & dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
   & factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
   & npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
   & leftx, nintrp, rightx
!
!         Set some short local variable names
!
xl = xleft(nstack)
xr = xright(nstack)
nl = leftx
nr = rightx
ni = nintrp
nrl = nr + nl
nri = nr + ni
nri1 = nri - 1
nrli = nrl + ni
!
!         Starting representation is (assuming xl = 0 )
!
!    d(1) +d(2)X +d(3)X**2 + --- +d(nl)X**(nl-1)
!   +(X**nl)*( d(nl+1)(+d(nl+2)(X-xr)**2 + --- +d(nl+nr)*(X-xr)**(nr-1)
!        *((X-xr)**nr)*(d(nl+nr+1) + d(nl+nr+2)*(X-XINTRP(1))
!                      +d(nl+nr+3)*(X-XINTRP(1))(X-XINTRP(2)) + ---))
!
!         Strategy is to first convert the part from the interp. Pts.
!         To poly in (X-xr).  This poly then has origin shifted to xl.
!
!     The conversion of the interp part is done explicitly for degree
!     two or less and done by synthetic division for higher degrees
!
!   D1 + D2(X-X1) +D3(X**2-(X1+X2)X +X1*X2)
!
!     The resulting coefficients are put in the array powers
!
if (ni == 0) go to 100
!
!             Build up the polynomial for the interpolation points
!
!         Use special formulas for ni less than 3
if (ni == 1) go to 10
if (ni == 2) go to 20
go to 30
10 powers(1) = d(nrl + 1,1)
go to 80
20 powers(1) = d(nrl + 1,1) + (xr - xintrp(1))*d(nrl + 2,1)
powers(2) = d(nrl + 2,1)
go to 80
!
!         Conversion by repeated synthetic division
30 ni1 = ni - 1
!         Initialize the powers and xtemp arrays
do k = 1,ni
   xtemp(k) = xintrp(k)
   nrlk = nrl + k
   powers(k) = d(nrlk,1)
end do
!
!         Do the repeated synthetic division to replace the xtemp
!         = XINTRP points of the Newton expansion by the xr points
do k = 1,ni1
!              powers(ni) is fixed and set above
   do ii = 1,ni1
      i = ni - ii
      powers(i) = powers(i) + (xr - xtemp(i))*powers(i + 1)
50    continue
   end do
!              Shift the Newton expansion pts. Up, put in one more xr
   do ii = 1,ni1
      i = ni - ii
      xtemp(i + 1) = xtemp(i)
   end do
   xtemp(1) = xr
70 continue
end do
80 continue
!             Shift the coefficients to the top of the powers array
do k = 1,ni
   l = ni + 1 - k
   ltop = l + nrl
   powers(ltop) = powers(l)
end do
!
!             Have the interpolation PT. COEFS. In the array powers
100 continue
!             Put the remaining divided diffs into the powers array
do j = 1,nrl
   powers(j) = d(j,1)
end do
!
!         Transform the origin of the polynomial from xr to xl
!         we use repeated synthetic division
if (nri == 1) go to 140
shift = xr - xl
khi = nri1
!             Loop through the coefficients
do j = 2,nri
!                   Synthetic division loop
   do k = 1,khi
      koef = nrli - k
      powers(koef) = powers(koef) - shift*powers(koef + 1)
   end do
   khi = khi - 1
end do
140 continue
!     The coefficients are now of the power form with origin xl
end subroutine adtran

subroutine cpsc(f, z, n, ic, tol, r, rs, err)
implicit none
integer, intent(in) :: ic, n
real, intent(inout) :: err(n), r
real, intent(in) :: tol
complex :: f
complex, intent(inout) :: rs(n)
complex :: z
integer :: i, ia, inr, iq, is, it, ix, j, jn, kl, km, kn, l, l1, l2, lf, ln, m, np, nr
real :: ang, b, c(4), cm, cp, ct, cx, ep6, eps, eps0, fac, fact, &
   & fc(3), pi, r1, ra, re, sc(4), sf, sp, sr
complex :: a(64), v
complex :: rt(51,3), fv(6), u, w, t, rv(3), rq, s, xk, mult, co
integer, parameter :: iw(7) = [1, 2, 4, 8, 16, 32, 64]
integer, parameter :: ip(32) = [64, 32, 48, 16, 56, 24, 40, 8, 60, 28, 44, 12, 52, 20, 36, 4, 62, 30, 46, 14, 54, 22, &
   & 38, 6, 58, 26, 42, 10, 50, 18, 34, 2]
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
!  Evaluation of complex power series coefficients or derivatives.
!
!  *** Input parameters ***
!    f   COMPLEX FUNCTION, OF WHICH THE COEFFICIENTS OR DERIVATIVES
!        are sought. This function must be declared external in the
!        calling program.
!    z   COMPLEX POINT AROUND WHICH f IS TO BE EXPANDED OR AT WHICH
!        derivatives are to be evaluated.
!    n   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
!        n must be GE 1 and le 51.
!    ic  selects between power series coefficients and derivatives.
!        ic .EQ. 0   routine returns power series coefficients in rs.
!        ic .NE. 0   routine returns derivatives in rs.
!    tol estimated relative accuracy of f. it is assumed that tol
!        is nonnegative. If tol = 0 Then f is assumed to be correct
!        to machine accuracy.
!
!  *** Input and output parameter ***
!    r   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
!        radius is left in r. the provided guess may be in error with at
!        most a factor of 3.E4 .
!
!  *** Output parameters ***
!    rs  complex array rs(n) containing the n first
!        coefficients (corresponding to the powers 0 to n-1) or deriva-
!        tives (orders 0 to n-1).
!    err real array err(n) containing absolute error estimates for the
!        numbers in rs.
!
!
!  List of the variables initialized in the data statement below.
!   iw   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
!   ip   PERMUTATION CONSTANTS FOR THE FFT.
!   rv   CONSTANTS FOR THE LAURENT SERIES TEST.
!
data rv(1)/(-.4,.3)/, rv(2)/(.7,.2)/, rv(3)/(.02,-.06)/
!
!  Statement function for multiplication of a complex number
!  by a real number.
!
mult(re,co) = cmplx(re*real(co),re*aimag(co))
!
!  -------------------
!
!  ****** eps0 is a machine dependent constant. eps0 is the
!         smallest number such that 1 + eps0 .GT. 1.
!
eps0 = spmpar(1)
!
!  -------------------
!
!  Initialization.
!
eps = max(eps0,tol)
sc(1) = .125
c(1) = eps**(1./28.)
ep6 = c(1)**6
pi = 4.0*atan(1.0)
fv(1) = (-1.,0.)
fv(2) = (0.,-1.)
r1 = sqrt(0.5)
ra = 1.0/r1
fv(3) = cmplx(r1,-r1)
do i = 2,4
   sc(i) = .5*sc(i - 1)
   c(i) = sqrt(c(i - 1))
   ang = pi*sc(i - 1)
10 fv(i + 2) = cmplx(cos(ang),-sin(ang))
end do
!
!  Start execution.
!
if (n > 51 .or. n < 1) go to 260
l2 = 1
lf = 0
np = 0
m = 0
nr = -1
!
!  Find if A FFT over 8, 16, 32, or 64 points should be used.
!
kl = 1
if (n > 6) kl = 2
if (n > 12) kl = 3
if (n > 25) kl = 4
km = kl + 2
kn = 7 - km
ix = iw(km + 1)
is = iw(kn)
30 v = cmplx(r,0.0)
!
!  Function values of f are stored ready permutated for the FFT.
!
do i = is,32,is
   iq = ip(i)
   v = v*fv(km)
   a(iq) = f(z + v)
40 a(iq - 1) = f(z - v)
end do
ln = 2
jn = 1
!
!  The loop  do 70 ... constitutes the FFT.
!
do l = 1,km
   u = (1.,0.)
   w = fv(l)
   do j = 1,jn
      do i = j,ix,ln
         it = i + jn
         t = a(it)*u
         a(it) = a(i) - t
50       a(i) = a(i) + t
      end do
60    u = u*w
   end do
   ln = ln + ln
70 jn = jn + jn
end do
cx = 0.0
b = 1.0
!
!  Test on how fast the coefficients obtained decrease.
!
do i = 1,ix
   ct = abs(a(i))/b
   if (ct < cx) go to 80
   cx = ct
   inr = i
80 b = b*c(kl)
end do
if (m <= 1) go to 100
!
!  Estimate of the rounding error level for the last radius.
!
err(1) = cx*eps
do i = 2,n
90 err(i) = err(i - 1)/r
end do
100 sf = sc(kl)
do i = 1,ix
   a(i) = mult(sf,a(i))
110 sf = sf/r
end do
l1 = l2
l2 = 1
if (inr > iw(km)) go to 150
if (lf == 1) go to 140
!
!  Test if the series is a Taylor or a Laurent series.
!
sr = 0.0
sp = 0.0
do j = 1,3
   rq = mult(r,rv(j))
   s = a(ix)
   do i = 2,ix
      ia = ix + 1 - i
120   s = s*rq + a(ia)
   end do
   cp = abs(s)
   if (cp > sp) sp = cp
   cm = abs(s - f(z + rq))
130 if (cm > sr) sr = cm
end do
if (sr > 1.e-3*sp) go to 150
lf = 1
140 l2 = -1
!
!  Determination of the next radius to be used.
!
150 if (nr >= 0) go to 160
fact = 2.0
if (l2 == 1) fact = 0.5
l1 = l2
nr = 0
160 if (l1 /= l2) go to 180
if (nr > 0) go to 170
np = np + 1
if ( ( np - 15 ) <= 0 ) go to 190
go to 260
170 fact = 1.0/fact
180 fact = 1.0/sqrt(fact)
nr = nr + 1
190 r = r*fact
m = nr - kl - 1
if (m <= 0) go to 30
!
!  The results for the last three radii are stored.
!
do i = 1,n
200 rt(i,m) = a(i)
end do
if (m == 1) go to 220
!
!  Extrapolation.
!
do i = 1,n
   xk = rt(i,m - 1) - rt(i,m)
210 rt(i,m - 1) = rt(i,m) - mult(fc(m - 1),xk)
end do
if (m == 3) go to 230
!
!  Calculation of the extrapolation constants.
!
220 fc(m) = 1.5 + sign(.5,fact - 1.)
if (m == 2) fc(m) = fc(m) + ra
if (fact > 1.0) fc(m) = -fc(m)
go to 30
230 fc(3) = fc(1)*fc(2)/(fc(1) + fc(2) + 1.0)
!
!  Final extrapolation and error estimate.
!
do i = 1,n
   xk = rt(i,1) - rt(i,2)
   err(i) = err(i) + ep6*abs(xk)
240 rs(i) = rt(i,2) - mult(fc(3),xk)
end do
!
!  Multiply power series coefficients and error estimate by factorials
!  if derivatives wanted.
!
if (ic == 0) return
fac = 0.0
fact = 1.0
do i = 1,n
   rs(i) = mult(fact,rs(i))
   err(i) = fact*err(i)
   fac = fac + 1.0
250 fact = fact*fac
end do
return
!
!  Error return.
!
260 do i = 1,n
   rs(i) = (0.,0.)
270 err(i) = 1.e10
end do
end subroutine cpsc

subroutine dcpsc(fun, x, y, n, ic, tol, r, rs1, rs2, err)
implicit none
integer, intent(in) :: ic, n
double precision :: x, y
double precision, intent(in) :: tol
double precision, intent(inout) :: r, rs1(n), rs2(n), err(n)
integer :: i, ia, inr, iq, is, it, ix, j, jn, kl, km, kn, l, l1, &
   & l2, lf, ln, m, mm1, np, nr
double precision :: ang, b, cm, cp, ct, cx, eps, eps0, ep6, fac, fact, pi, ra, r1, s, sf, sp, sr, t, u, v, w, c(4), fc(3), sc(4), &
   & a1(64), a2(64), fv1(6), fv2(6), rt1(51,3), rt2(51,3)
integer, parameter :: iw(7) = [1, 2, 4, 8, 16, 32, 64]
integer, parameter :: ip(32) = [64, 32, 48, 16, 56, 24, 40, 8, 60, 28, 44, 12, 52, 20, 36, 4, 62, 30, 46, 14, 54, 22, &
   & 38, 6, 58, 26, 42, 10, 50, 18, 34, 2]
double precision, parameter :: rv1(3) = [-.4d0, .7d0, .02d0]
double precision, parameter :: rv2(3) = [.3d0, .2d0, -.06d0]
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!
!  Evaluation of complex power series coefficients or derivatives.
!
!  *** Input parameters ***
!    fun subroutine which computes the complex function F for which
!        the coefficients or derivatives are sought. We write
!                   call fun(u1,u2,w1,w2)
!        when W = F(U) is to be computed for the complex argument U.
!        Here U1 and U2 are the real and imaginary parts of U, and W1
!        and W2 are the real and imaginary parts of W.  U1,U2,W1,W2
!        have double precision values. The subroutine FUN must be
!        declared in the calling program to be of type external.
!    x   REAL PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
!        expanded or at which its derivatives are to be computed.
!    y   IMAGINARY PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
!        expanded or at which its derivatives are to be computed.
!    n   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
!        n must be GE 1 and le 51.
!    ic  selects between power series coefficients and derivatives.
!        ic .EQ. 0   routine returns power series coefficients in
!                    rs1 AND rs2.
!        ic .NE. 0   routine returns derivatives in rs1 and rs2.
!    tol estimated relative accuracy of fun. It is assumed that tol
!        is nonnegative. If tol = 0 Then fun is assumed to be correct
!        to machine accuracy.
!
!  *** Input and output parameter ***
!    r   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
!        radius is left in r. the provided guess may be in error with at
!        most a factor of 3.E4 .
!
!  *** Output parameters ***
!    rs1 array rs1(n) containing the real parts of the first n complex
!        coefficients (corresponding to the powers 0 to n-1) or deriva-
!        tives (orders 0 to n-1).
!    rs2 array rs2(n) containing the imaginary parts of the first n
!        coefficients (corresponding to the powers 0 to n-1) or deriva-
!        tives (orders 0 to n-1).
!    err real array err(n) containing absolute error estimates for the
!        COMPLEX NUMBERS WHOSE REAL AND IMAGINARY PARTS ARE IN rs1,rs2.
!
!
!  List of the variables initialized in the data statement below.
!   iw   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
!   ip   PERMUTATION CONSTANTS FOR THE FFT.
!   RV1  real parts of the constants for the Laurent series test.
!   RV2  imaginary parts of the constants for the Laurent series test.
!
!
!  -------------------
!
!  ****** eps0 is a machine dependent constant. eps0 is the
!         smallest number such that 1 + eps0 .GT. 1.
!
eps0 = dpmpar(1)
!
!  -------------------
!
!  Initialization.
!
eps = max(eps0,tol)
sc(1) = .125d0
c(1) = eps**(1.d0/28.d0)
ep6 = c(1)**6
pi = 4.d0*atan(1.d0)
fv1(1) = -1.d0
fv2(1) = 0.d0
fv1(2) = 0.d0
fv2(2) = -1.d0
r1 = sqrt(0.5d0)
ra = 1.d0/r1
fv1(3) = r1
fv2(3) = -r1
do i = 2,4
   sc(i) = 0.5d0*sc(i - 1)
   c(i) = sqrt(c(i - 1))
   ang = pi*sc(i - 1)
   fv1(i + 2) = cos(ang)
10 fv2(i + 2) = -sin(ang)
end do
!
!  Start execution.
!
if (n > 51 .or. n < 1) go to 260
l2 = 1
lf = 0
np = 0
m = 0
nr = -1
!
!  Find if A FFT over 8, 16, 32, or 64 points should be used.
!
kl = 1
if (n > 6) kl = 2
if (n > 12) kl = 3
if (n > 25) kl = 4
km = kl + 2
kn = 7 - km
ix = iw(km + 1)
is = iw(kn)
30 u = r
v = 0.d0
!
!  Function values of F are stored ready permutated for the FFT.
!
do i = is,32,is
   iq = ip(i)
   t = u*fv1(km) - v*fv2(km)
   v = u*fv2(km) + v*fv1(km)
   u = t
   call fun(x + u, y + v, a1(iq), a2(iq))
   call fun(x - u, y - v, a1(iq - 1), a2(iq - 1))
40 continue
end do
ln = 2
jn = 1
!
!  The loop  do 70 ... constitutes the FFT.
!
do l = 1,km
   u = 1.0
   v = 0.0
   do j = 1,jn
      do i = j,ix,ln
         it = i + jn
         s = u*a1(it) - v*a2(it)
         t = u*a2(it) + v*a1(it)
         a1(it) = a1(i) - s
         a2(it) = a2(i) - t
         a1(i) = a1(i) + s
50       a2(i) = a2(i) + t
      end do
      t = u*fv1(l) - v*fv2(l)
      v = u*fv2(l) + v*fv1(l)
60    u = t
   end do
   ln = ln + ln
70 jn = jn + jn
end do
cx = 0.d0
b = 1.d0
!
!  Test on how fast the coefficients obtained decrease.
!
do i = 1,ix
   ct = dcpabs(a1(i),a2(i))/b
   if (ct < cx) go to 80
   cx = ct
   inr = i
80 b = b*c(kl)
end do
if (m <= 1) go to 100
!
!  Estimate of the rounding error level for the last radius.
!
err(1) = cx*eps
do i = 2,n
90 err(i) = err(i - 1)/r
end do
!
100 sf = sc(kl)
do i = 1,ix
   a1(i) = sf*a1(i)
   a2(i) = sf*a2(i)
110 sf = sf/r
end do
l1 = l2
l2 = 1
if (inr > iw(km)) go to 150
if (lf == 1) go to 140
!
!  Test if the series is a Taylor or a Laurent series.
!
sr = 0.d0
sp = 0.d0
do j = 1,3
   s = a1(ix)
   t = a2(ix)
   u = r*rv1(j)
   v = r*rv2(j)
   do i = 2,ix
      ia = ix + 1 - i
      w = (s*u - t*v) + a1(ia)
      t = (s*v + t*u) + a2(ia)
120   s = w
   end do
   cp = dcpabs(s,t)
   if (cp > sp) sp = cp
   call fun(x + u, y + v, u, v)
   cm = dcpabs(s - u, t - v)
130 if (cm > sr) sr = cm
end do
if (sr > 1.d-3*sp) go to 150
lf = 1
140 l2 = -1
!
!  Determination of the next radius to be used.
!
150 if (nr >= 0) go to 160
fact = 2.d0
if (l2 == 1) fact = 0.5d0
l1 = l2
nr = 0
160 if (l1 /= l2) go to 180
if (nr > 0) go to 170
np = np + 1
if ( ( np - 15 ) <= 0 ) go to 190
go to 260
170 fact = 1.d0/fact
180 fact = 1.d0/sqrt(fact)
nr = nr + 1
190 r = r*fact
m = nr - kl - 1
if (m <= 0) go to 30
!
!  The results for the last three radii are stored.
!
do i = 1,n
   rt1(i,m) = a1(i)
200 rt2(i,m) = a2(i)
end do
if (m == 1) go to 220
!
!  Extrapolation.
!
mm1 = m - 1
do i = 1,n
   u = rt1(i,mm1) - rt1(i,m)
   v = rt2(i,mm1) - rt2(i,m)
   rt1(i,mm1) = rt1(i,m) - fc(mm1)*u
210 rt2(i,mm1) = rt2(i,m) - fc(mm1)*v
end do
if (m == 3) go to 230
!
!  Calculation of the extrapolation constants.
!
220 fc(m) = 1.5d0 + sign(0.5d0,fact - 1.d0)
if (m == 2) fc(m) = fc(m) + ra
if (fact > 1.d0) fc(m) = -fc(m)
go to 30
230 fc(3) = fc(1)*fc(2)/(fc(1) + fc(2) + 1.d0)
!
!  Final extrapolation and error estimate.
!
do i = 1,n
   u = rt1(i,1) - rt1(i,2)
   v = rt2(i,1) - rt2(i,2)
   err(i) = err(i) + ep6*dcpabs(u,v)
   rs1(i) = rt1(i,2) - fc(3)*u
240 rs2(i) = rt2(i,2) - fc(3)*v
end do
!
!  Multiply power series coefficients and error estimate by factorials
!  if derivatives wanted.
!
if (ic == 0) return
fac = 0.d0
fact = 1.d0
do i = 1,n
   rs1(i) = fact*rs1(i)
   rs2(i) = fact*rs2(i)
   err(i) = fact*err(i)
   fac = fac + 1.d0
250 fact = fact*fac
end do
return
!
!  Error return.
!
260 do i = 1,n
   rs1(i) = 0.d0
   rs2(i) = 0.d0
270 err(i) = 1.d10
end do
end subroutine dcpsc

function trp(a,n,x,y)
implicit none
integer, intent(in) :: n
real, intent(in) :: a
real :: x(n), y(n)
integer :: i, il, ir, nm1
real :: r
real :: trp
real :: nswc_ai_r4
!
nm1 = n - 1
if (a < x(2)) go to 50
if (a >= x(nm1)) go to 40
il = 2
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 60
nswc_ai_r4 = a - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 60
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     a.LT.x(2) .OR. a.GE.x(n-1)
!
40 i = nm1
go to 60
50 i = 1
!
!     Evaluation
!
60 r = (a - x(i))/(x(i + 1) - x(i))
trp = y(i) + r*(y(i + 1) - y(i))
end function trp

subroutine ltrp(m,x,y,n,xi,yi,ni,t,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, ni
real, intent(inout) :: t(m)
real :: x(n), xi(ni), y(n)
real, intent(inout) :: yi(ni)
integer :: i, ii, il, ilm1, ilold, ipm, ir, istep, j, jmax, k, l, &
   & mm1, num
real :: dl, dr, xx, nswc_ai_r4
!     ******************************************************************
!     Lagrange interpolation
!     ******************************************************************
!
!     Check input
!
if (m < 2) go to 130
if (m > n) go to 131
if (ni < 1) go to 132
ierr = 0
!
!     Initialization
!
mm1 = m - 1
k = 1
xx = xi(1)
ilold = 0
!
!     Find the subinterval which contains xx. i = 1 If xx.LT.x(2)
!     AND i = n IF xx.GE.x(n). OTHERWISE x(i).LE.xx.LT.x(i+1).
!
nswc_ai_r4 = xx - x ( 1 )
if ( nswc_ai_r4 < 0 ) go to 10
if ( nswc_ai_r4 == 0 ) go to 11
go to 20
10 i = 1
il = 1
ir = m
go to 80
11 i = 1
yi(k) = y(1)
go to 110
!
20 nswc_ai_r4 = x ( n ) - xx
if ( nswc_ai_r4 < 0 ) go to 21
if ( nswc_ai_r4 == 0 ) go to 22
go to 23
21 i = n
il = n - m + 1
ir = n
go to 80
22 i = n
yi(k) = y(n)
go to 110
23 il = 1
ir = n
!
!     Bisection search
!
30 i = (il + ir)/2
if (i == il) go to 50
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 31
if ( nswc_ai_r4 == 0 ) go to 32
go to 33
31 ir = i
go to 30
32 yi(k) = y(i)
go to 110
33 il = i
go to 30
!
!     Linear forward search
!
40 nswc_ai_r4 = xx - x ( i + 1 )
if ( nswc_ai_r4 < 0 ) go to 50
if ( nswc_ai_r4 == 0 ) go to 41
go to 42
41 i = i + 1
yi(k) = y(i)
go to 110
42 i = i + 1
go to 40
!
!     Point xx lies in the open subinterval (x(i),x(i+1)).
!     Find the m closest points x(il),...,x(ir) to xx.
!
50 if (i > m) go to 51
il = 1
num = i
go to 60
51 il = i - m + 1
num = m
!
60 ipm = i + m
if (ipm <= n) go to 61
ir = n
num = num + n - i
go to 70
61 ir = ipm
num = num + m
!
70 num = num - m
if (num == 0) go to 80
dl = xx - x(il)
dr = x(ir) - xx
do l = 1,num
   if (dl <= dr) go to 71
   il = il + 1
   dl = xx - x(il)
   go to 72
71 ir = ir - 1
   dr = x(ir) - xx
72 continue
end do
!
!     Compute the coefficients t(1),...,t(m) of the backward
!     Newton form of the interpolating polynomial.
!
80 if (il == ilold) go to 100
ilold = il
ilm1 = il - 1
do j = 1,m
   l = ilm1 + j
81 t(j) = y(l)
end do
!
do istep = 1,mm1
   jmax = m - istep
   do j = 1,jmax
      ii = ilm1 + j
      l = ii + istep
90    t(j) = (t(j) - t(j + 1))/(x(ii) - x(l))
   end do
end do
!
!     Evaluation of the interpolating polynomial
!
100 yi(k) = t(1)
do j = 2,m
   l = ilm1 + j
101 yi(k) = t(j) + yi(k)*(xx - x(l))
end do
!
!     Next point
!
110 if (k >= ni) return
k = k + 1
xx = xi(k)
nswc_ai_r4 = xx - x ( 1 )
if ( nswc_ai_r4 < 0 ) go to 10
if ( nswc_ai_r4 == 0 ) go to 11
go to 111
111 nswc_ai_r4 = x ( n ) - xx
if ( nswc_ai_r4 < 0 ) go to 21
if ( nswc_ai_r4 == 0 ) go to 22
go to 120
!
120 nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 121
if ( nswc_ai_r4 == 0 ) go to 122
go to 40
121 il = 1
ir = min(i + 1,n)
go to 30
122 yi(k) = yi(k - 1)
go to 110
!
!     Error return
!
130 ierr = 1
return
131 ierr = 2
return
132 ierr = 3
end subroutine ltrp

subroutine htrp(n,x,y,a,t,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(inout) :: a(n), t(n)
real :: x(n), y(n)
integer :: i, ibeg, iend, k
real :: diff, f, r
!     ******************************************************************
!     Hermite interpolation
!     ******************************************************************
if (n <= 0) go to 30
ierr = 0
a(1) = y(1)
if (n == 1) return
f = 1.0
r = 0.0
iend = 0
ibeg = 1
!
do k = 2,n
   if ( ( x ( k ) - x ( k - 1 ) ) == 0 ) go to 20
   go to 10
!
10 f = 1.0
   r = 0.0
   iend = k - 1
   ibeg = k
   t(1) = y(k)
   do i = 1,iend
      diff = x(i) - x(k)
      if ( ( diff ) == 0 ) go to 31
      go to 11
11    t(i + 1) = (a(i) - t(i))/diff
   end do
   go to 22
!
20 r = r + 1.0
   f = f*r
   t(1) = y(k)/f
   if (iend == 0) go to 22
   do i = 1,iend
21    t(i + 1) = (t(i + 1) - t(i))/(x(i) - x(k))
   end do
22 a(k) = t(ibeg)
end do
return
!
30 ierr = 1
return
31 ierr = 2
t(1) = i
t(2) = k
end subroutine htrp

pure subroutine pcoeff(alpha,n,x,a,c,t)
implicit none
integer, intent(in) :: n
real, intent(in) :: alpha
real, intent(in) :: x(*), a(n)
real, intent(inout) :: c(n)
double precision, intent(inout) :: t(n)
integer :: i, j, k, nm1
double precision :: xx, r
if (n > 1) go to 10
c(1) = a(1)
return
!
10 xx = alpha
nm1 = n - 1
do i = 1,n
11 t(i) = a(i)
end do
!
do i = 1,nm1
   j = n - i
   r = xx - dble(x(j))
   do k = j,nm1
20    t(k) = t(k) + r*t(k + 1)
   end do
end do
!
do i = 1,n
30 c(i) = t(i)
end do
end subroutine pcoeff

pure subroutine pfit(nd,np,x,y,a,rnorm,phi,phix,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: nd, np
real, intent(inout) :: rnorm
real, intent(in) :: x(np), y(np)
real, intent(inout) :: a(*), phi(2,*), phix(4,np)
integer :: k, la, lb, ls, m, mp1, nd1
real :: alpha, c, temp, xmax, xmin, za, zb, lambda
double precision :: dalpha, dsum
!     ******************************************************************
!     Unweighted least squares polynomial fit
!     ******************************************************************
!     ---------------------
ierr = 0
if (1 <= nd.and.nd < np) go to 10
ierr = 1
return
!
!                      Initialization
!
10 nd1 = nd + 1
do k = 1,nd1
   a(k) = 0.0
   phi(1,k) = 0.0
11 phi(2,k) = 0.0
end do
!
!                SET Z=a+B*x WHERE abs(Z).LE.1
!
xmin = x(1)
xmax = x(1)
do k = 2,np
   if (x(k) >= xmin) go to 20
   xmin = x(k)
   go to 21
20 if (x(k) > xmax) xmax = x(k)
21 continue
end do
zb = 2.0/(xmax - xmin)
za = -xmin*zb - 1.0
do k = 1,np
22 phix(3,k) = za + zb*x(k)
end do
!
!           Compute the closest polynomial of degree 0
!
lambda = np
phi(1,1) = 1.0/sqrt(lambda)
dalpha = 0.d0
dsum = 0.d0
do k = 1,np
   phix(1,k) = phi(1,1)
   dalpha = dalpha + dble(phix(3,k))
30 dsum = dsum + dble(y(k))
end do
alpha = sngl(dalpha)/lambda
a(1) = sngl(dsum)/lambda
do k = 1,np
31 phix(4,k) = a(1)
end do
!
la = 2
lb = 1
do m = 1,nd
   mp1 = m + 1
!
!          Generate lambda(m)*phi(m) and evaluate it at Z
!
   if (m /= 1) go to 50
   phi(2,1) = -alpha*phi(1,1)
   phi(2,2) = phi(1,1)
   do k = 1,np
40    phix(2,k) = (phix(3,k) - alpha)*phi(1,1)
   end do
   go to 60
!
50 c = 0.0
   do k = 1,m
      phi(la,k) = dble(c) - dble(alpha*phi(lb,k)) - dble(lambda*phi(la,k))
51    c = phi(lb,k)
   end do
   phi(la,mp1) = c
   do k = 1,np
52    phix(la,k) = (phix(3,k) - alpha)*phix(lb,k) - lambda*phix(la,k)
   end do
!
!                Compute alpha(m) and lambda(m)
!
60 dalpha = 0.d0
   dsum = 0.d0
   do k = 1,np
      c = phix(la,k)*phix(la,k)
      dalpha = dalpha + dble(c*phix(3,k))
61    dsum = dsum + dble(c)
   end do
   lambda = dsum
   alpha = sngl(dalpha)/lambda
   lambda = sqrt(lambda)
!
!              Generate phi(m) and evaluate it at Z
!
   do k = 1,mp1
70    phi(la,k) = phi(la,k)/lambda
   end do
   do k = 1,np
71    phix(la,k) = phix(la,k)/lambda
   end do
!
!        Compute the closest polynomial of degree m or less
!                     and evaluate it at Z
!
   dsum = 0.d0
   do k = 1,np
80    dsum = dsum + dble((y(k) - phix(4,k))*phix(la,k))
   end do
   c = dsum
   do k = 1,mp1
81    a(k) = a(k) + c*phi(la,k)
   end do
   do k = 1,np
82    phix(4,k) = phix(4,k) + c*phix(la,k)
   end do
!
   ls = la
   la = lb
90 lb = ls
end do
!
!                        Compute rnorm
!
dsum = 0.d0
do k = 1,np
95 dsum = dsum + dble((y(k) - phix(4,k))**2)
end do
rnorm = sqrt(sngl(dsum))
!
!        Convert the closest polynomial from a polynomial
!                  in Z to a polynomial in x
!
a(1) = a(1) + za*a(2)
a(2) = zb*a(2)
if (nd == 1) return
phi(1,1) = za
phi(1,2) = zb
do m = 2,nd
   mp1 = m + 1
   c = 0.0
   do k = 1,m
      temp = phi(1,k)*zb
      phi(1,k) = phi(1,k)*za + c
100   c = temp
   end do
   phi(1,mp1) = c
   do k = 1,m
101   a(k) = a(k) + a(mp1)*phi(1,k)
   end do
102 a(mp1) = a(mp1)*phi(1,mp1)
end do
end subroutine pfit

pure subroutine wpfit(nd,np,x,y,w,a,rnorm,phi,phix,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: nd, np
real, intent(inout) :: rnorm
real, intent(in) :: x(np), y(np), w(np)
real, intent(inout) :: a(*), phi(2,*), phix(4,np)
integer :: k, la, lb, ls, m, mp1, nd1, nw
real :: alpha, c, temp, xmax, xmin, za, zb, lambda, nswc_ai_r4
double precision :: dalpha, dsum
!     ******************************************************************
!     Weighted least squares polynomial fit
!     ******************************************************************
!     ---------------------
!
!                      Error checking
!
if (nd < 1.or.np < 2) go to 200
nw = 0
dsum = 0.d0
do k = 1,np
   nswc_ai_r4 = w ( k )
   if ( nswc_ai_r4 < 0 ) go to 202
   if ( nswc_ai_r4 == 0 ) go to 13
   go to 10
10 nw = nw + 1
   dsum = dsum + dble(w(k))
   if (nw > 1) go to 11
   xmin = x(k)
   xmax = x(k)
   go to 13
11 if (x(k) >= xmin) go to 12
   xmin = x(k)
   go to 13
12 if (x(k) > xmax) xmax = x(k)
13 continue
end do
if (nd >= nw) go to 200
!
!                      Initialization
!
ierr = 0
nd1 = nd + 1
do k = 1,nd1
   a(k) = 0.0
   phi(1,k) = 0.0
20 phi(2,k) = 0.0
end do
!
!                SET Z=a+B*x WHERE abs(Z).LE.1
!
zb = 2.0/(xmax - xmin)
za = -xmin*zb - 1.0
do k = 1,np
25 phix(3,k) = za + zb*x(k)
end do
!
!           Compute the closest polynomial of degree 0
!
lambda = dsum
phi(1,1) = 1.0/sqrt(lambda)
dalpha = 0.d0
dsum = 0.d0
do k = 1,np
   phix(1,k) = phi(1,1)
   dalpha = dalpha + dble(w(k)*phix(3,k))
30 dsum = dsum + dble(w(k)*y(k))
end do
alpha = sngl(dalpha)/lambda
a(1) = sngl(dsum)/lambda
do k = 1,np
31 phix(4,k) = a(1)
end do
!
la = 2
lb = 1
do m = 1,nd
   mp1 = m + 1
!
!          Generate lambda(m)*phi(m) and evaluate it at Z
!
   if (m /= 1) go to 50
   phi(2,1) = -alpha*phi(1,1)
   phi(2,2) = phi(1,1)
   do k = 1,np
40    phix(2,k) = (phix(3,k) - alpha)*phi(1,1)
   end do
   go to 60
!
50 c = 0.0
   do k = 1,m
      phi(la,k) = dble(c) - dble(alpha*phi(lb,k)) - dble(lambda*phi(la,k))
51    c = phi(lb,k)
   end do
   phi(la,mp1) = c
   do k = 1,np
52    phix(la,k) = (phix(3,k) - alpha)*phix(lb,k) - lambda*phix(la,k)
   end do
!
!                Compute alpha(m) and lambda(m)
!
60 dalpha = 0.d0
   dsum = 0.d0
   do k = 1,np
      c = w(k)*phix(la,k)*phix(la,k)
      dalpha = dalpha + dble(c*phix(3,k))
61    dsum = dsum + dble(c)
   end do
   lambda = dsum
   alpha = sngl(dalpha)/lambda
   lambda = sqrt(lambda)
!
!              Generate phi(m) and evaluate it at Z
!
   do k = 1,mp1
70    phi(la,k) = phi(la,k)/lambda
   end do
   do k = 1,np
71    phix(la,k) = phix(la,k)/lambda
   end do
!
!        Compute the closest polynomial of degree m or less
!                     and evaluate it at Z
!
   dsum = 0.d0
   do k = 1,np
80    dsum = dsum + dble(w(k)*(y(k) - phix(4,k))*phix(la,k))
   end do
   c = dsum
   do k = 1,mp1
81    a(k) = a(k) + c*phi(la,k)
   end do
   do k = 1,np
82    phix(4,k) = phix(4,k) + c*phix(la,k)
   end do
!
   ls = la
   la = lb
90 lb = ls
end do
!
!                        Compute rnorm
!
dsum = 0.d0
do k = 1,np
95 dsum = dsum + dble(w(k)*(y(k) - phix(4,k))**2)
end do
rnorm = sqrt(sngl(dsum))
!
!        Convert the closest polynomial from a polynomial
!                  in Z to a polynomial in x
!
a(1) = a(1) + za*a(2)
a(2) = zb*a(2)
if (nd == 1) return
phi(1,1) = za
phi(1,2) = zb
do m = 2,nd
   mp1 = m + 1
   c = 0.0
   do k = 1,m
      temp = phi(1,k)*zb
      phi(1,k) = phi(1,k)*za + c
100   c = temp
   end do
   phi(1,mp1) = c
   do k = 1,m
101   a(k) = a(k) + a(mp1)*phi(1,k)
   end do
102 a(mp1) = a(mp1)*phi(1,mp1)
end do
return
!
!                        Error return
!
200 ierr = 1
return
202 ierr = 3
end subroutine wpfit

pure subroutine cbspl(x, y, a, b, c, n, ibeg, iend, alpha, beta, ierr)
implicit none
integer, intent(in) :: ibeg, iend
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: alpha, beta
real, intent(in) :: x(n), y(n)
real, intent(inout) :: a(n), b(n), c(n)
integer :: i, j, m, nm1, nswc_ai_i4
real :: del, h, r, t
!-----------------------------------------------------------------------
!                   Cubic spline interpolation
!-----------------------------------------------------------------------
!
if (n < 3) go to 200

!     A tridiagonal linear system for the unknown slopes S(i) of
!     F at x(i), i=1,...,n, is generated and then solved by Gauss
!     elimination, with S(i) ending up in a(i) for all i. A, b, c
!     are used initially for work spaces.
!
do m = 2,n
   b(m) = x(m) - x(m - 1)
   if (b(m) <= 0.0) go to 210
   c(m) = (y(m) - y(m - 1))/b(m)
end do
ierr = 0
!
!     Construct the first equation from the boundary condition, of
!     the form
!
!             c(1)*S(1) + b(1)*S(2) = a(1)
!
nswc_ai_i4 = ibeg - 1
if ( nswc_ai_i4 < 0 ) go to 20
if ( nswc_ai_i4 == 0 ) go to 30
go to 40
!
!     No condition at left end.
!
20 c(1) = b(3)
b(1) = x(3) - x(1)
a(1) = ((b(2) + 2.0*b(1))*b(3)*c(2) + b(2)*b(2)*c(3))/b(1)
go to 50
!
!     Slope prescribed at left end.
!
30 c(1) = 1.0
b(1) = 0.0
a(1) = alpha
go to 50
!
!     Second derivative prescribed at left end.
!
40 c(1) = 2.0
b(1) = 1.0
a(1) = 3.0*c(2) - 0.5*alpha*b(2)
!
!     For the interior knots, generate the corresponding equations and
!     carry out the forward pass of Gauss elimination, after which the
!     m-TH EQUATION READS  c(m)*S(m) + b(m)*S(m+1) = a(m).
!
50 nm1 = n - 1
do m = 2,nm1
   t = -b(m + 1)/c(m - 1)
   a(m) = t*a(m - 1) + 3.0*(b(m)*c(m + 1) + b(m + 1)*c(m))
   c(m) = t*b(m - 1) + 2.0*(b(m) + b(m + 1))
end do
!
!     If the slope at the right end is given, then set a(n) to the
!     slope and go to back substitution. Otherwise, construct the
!     last equation from the second boundary condition, of the form
!
!                r*S(n-1) + c(n)*S(n) = a(n)
!
nswc_ai_i4 = iend - 1
if ( nswc_ai_i4 < 0 ) go to 60
if ( nswc_ai_i4 == 0 ) go to 80
go to 90
60 if (n == 3 .and. ibeg == 0) go to 70
!
!     No condition at the right end. Either  n .GE. 4  or
!     there is a condition at the left end.
!
r = x(n) - x(n - 2)
del = (y(nm1) - y(n - 2))/b(nm1)
a(n) = ((b(n) + 2.0*r)*b(nm1)*c(n) + b(n)*b(n)*del)/r
c(n) = b(nm1)
go to 100
!
!     No conditions at the end points and n = 3. In this case,
!     the second boundary condition does not provide us with A
!     new equation. For convenience, we use the following...
!
70 a(n) = 2.0*c(n)
c(n) = 1.0
r = 1.0
go to 100
!
!     Slope prescribed at right end.
!
80 a(n) = beta
go to 110
!
!     Second derivative prescribed at right end.
!
90 a(n) = 3.0*c(n) + 0.5*beta*b(n)
c(n) = 2.0
r = 1.0
!
!     Complete forward pass of Gauss elimination.
!
100 t = -r/c(nm1)
a(n) = (t*a(nm1) + a(n))/(t*b(nm1) + c(n))
!
!     Carry out back substitution.
!
110 do i = 1,nm1
   j = n - i
   a(j) = (a(j) - b(j)*a(j + 1))/c(j)
end do
!
!     Generate the cubic coefficients b(i) and c(i).
!
do i = 1,nm1
   h = b(i + 1)
   del = (y(i + 1) - y(i))/h
   t = a(i) + a(i + 1) - 2.0*del
   b(i) = (del - a(i) - t)/h
   c(i) = (t/h)/h
end do
return
!
!     Error return
!
200 ierr = 1
return
210 ierr = 2
end subroutine cbspl

pure subroutine splift(x,y,yp,ypp,n,w,ierr,isx,a1,b1,an,bn)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: isx, n
real, intent(in) :: a1, an, b1, bn
real, intent(in) :: x(n), y(n)
real, intent(inout) :: yp(n), ypp(n), w(n,3)
integer :: i, j, nm1, nm2
real :: dnew, dold, h
!
!     Written by Rondall E. Jones
!        Sandia Laboratories
!        albuquerque, new mexico  87115
!        January 1976
!
!     Abstract
!         splift fits an interpolating cubic spline to the n data points
!         given in x and y and returns the first and second derivatives
!         in yp and ypp.
!
!     Description of arguments
!
!       --Input--
!
!         x    - Array of abscissas of data (in increasing order)
!         y    - Array of ordinates of data
!         n    - The number of data points.  The arrays x, y, yp, and
!                ypp must be dimensioned at least n.  (n .GE. 4)
!         isx  - Must be zero on the initial call to splift.
!                If a spline is to be fitted to a second set of data
!                that has the same set of abscissas as a previous set,
!                and if the contents of w have not been changed since
!                that previous fit was computed, then isx may be
!                set to one for faster execution.
!         a1,b1,an,bn - Specify the end conditions for the spline which
!                are expressed as constraints on the second derivative
!                of the spline at the end points (see ypp).
!                The end condition constraints are
!                        ypp(1) = a1*ypp(2) + b1
!                and
!                        ypp(n) = an*ypp(n-1) + bn
!                where
!                        abs(a1).LT. 1.0  AND  abs(an).LT. 1.0.
!
!                The smoothest spline (I.E., least integral of square
!                of second derivative) is obtained by a1=b1=an=bn=0.
!                In this case there is an inflection at x(1) and x(n).
!                If the data is to be extrapolated (say, by using splint
!                to evaluate the spline outside the range x(1) to x(n)),
!                then taking a1=an=0.5 and b1=bn=0 May yield better
!                results.  In this case there is an inflection
!                at x(1) - (x(2)-x(1)) and at x(n) + (x(n)-x(n-1)).
!                In the more general case of a1=an=A  and b1=bn=0,
!                there is an inflection at x(1) - (x(2)-x(1))*A/(1.0-A)
!                and at x(n) + (x(n)-x(n-1))*A/(1.0-A).
!
!                A spline that has a given first derivative YP1 at x(1)
!                and YPN at y(n) may be defined by using the
!                following conditions.
!
!                a1=-0.5
!
!                b1= 3.0*((y(2)-y(1))/(x(2)-x(1))-yp1)/(x(2)-x(1))
!
!                an=-0.5
!
!                bn=-3.0*((y(n)-y(n-1))/(x(n)-x(n-1))-ypn)/(x(n)-x(n-1))
!
!       --Output--
!
!         yp   - Array of first derivatives of spline (at the x(i))
!         ypp  - Array of second derivatives of spline (at the x(i))
!         ierr - A status code
!              --normal code
!                 0 means that the requested spline was computed.
!              --Abnormal codes
!                 1 means that abs(a1) or abs(an) was .GE. 1.
!                 2 Means that n, the number of points, was .LT. 4.
!                 3 Means the abscissas were not strictly increasing.
!
!       --Work--
!
!         w    - Array of working storage dimensioned at least 3n.
!
!
if (abs(a1) >= 1.0 .or. abs(an) >= 1.0) go to 100
if (n < 4) go to 200
nm1 = n - 1
nm2 = n - 2
if (isx > 0) go to 40
do i = 2,n
   if (x(i) <= x(i - 1)) go to 300
10 continue
end do
!
!     Define the tridiagonal matrix
!
w(1,3) = x(2) - x(1)
do i = 2,nm1
   w(i,2) = w(i - 1,3)
   w(i,3) = x(i + 1) - x(i)
   w(i,1) = 2.0*(w(i,2) + w(i,3))
20 continue
end do
w(1,1) = 4.0
w(1,3) = -4.0*a1
w(n,1) = 4.0
w(n,2) = -4.0*an
!
!     LU decomposition
!
do i = 2,n
   w(i - 1,3) = w(i - 1,3)/w(i - 1,1)
   w(i,1) = w(i,1) - w(i,2)*w(i - 1,3)
30 continue
end do
!
!     Define *constant* vector
!
40 ypp(1) = 4.0*b1
dold = (y(2) - y(1))/w(2,2)
do i = 2,nm2
   dnew = (y(i + 1) - y(i))/w(i + 1,2)
   ypp(i) = 6.0*(dnew - dold)
   yp(i) = dold
   dold = dnew
50 continue
end do
dnew = (y(n) - y(nm1))/(x(n) - x(nm1))
ypp(nm1) = 6.0*(dnew - dold)
ypp(n) = 4.0*bn
yp(nm1) = dold
yp(n) = dnew
!
!     Forward substitution
!
ypp(1) = ypp(1)/w(1,1)
do i = 2,n
   ypp(i) = (ypp(i) - w(i,2)*ypp(i - 1))/w(i,1)
60 continue
end do
!
!     Backward substitution
!
do j = 1,nm1
   i = n - j
   ypp(i) = ypp(i) - w(i,3)*ypp(i + 1)
70 continue
end do
!
!     Compute first derivatives
!
h = x(2) - x(1)
yp(1) = (y(2) - y(1))/h - h*(2.0*ypp(1) + ypp(2))/6.0
do i = 2,nm1
   yp(i) = yp(i) + w(i,2)*(ypp(i - 1) + 2.0*ypp(i))/6.0
80 continue
end do
yp(n) = yp(n) + (x(n) - x(nm1))*(ypp(nm1) + 2.0*ypp(n))/6.0
ierr = 0
return
!
100 ierr = 1
return
200 ierr = 2
return
300 ierr = 3
end subroutine splift

pure subroutine spfit(x, y, wgt, m, break, l, z, a, b, c, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m
real, intent(in) :: x(m), y(m), wgt(m)
real, intent(inout) :: break(l)
real, intent(inout) :: z(*), a(*), b(*), c(*), wk(*)
integer :: j, k, la, lm1, lq, lw, n
real :: temp(20)
interface
   pure subroutine bslsq(tau,gtau,wgt,ntau,t,n,k,a,wk,q,ierr)
      implicit none
      integer, intent(in) :: k
      integer, intent(in) :: n
      integer, intent(in) :: ntau
      real, intent(in) :: tau(ntau)
      real, intent(in) :: gtau(ntau)
      real, intent(in) :: wgt(ntau)
      real, intent(in) :: t(*)
      real, intent(inout) :: a(n)
      real, intent(inout) :: wk(n)
      real, intent(inout) :: q(k,n)
      integer, intent(inout) :: ierr
   end subroutine bslsq
   pure subroutine bspp(t,a,n,k,break,c,l,wk)
      implicit none
      integer, intent(in) :: k
      integer, intent(in) :: n
      real, intent(in) :: t(*)
      real, intent(in) :: a(n)
      real, intent(inout) :: break(*)
      real, intent(inout) :: c(k,*)
      integer, intent(out) :: l
      real, intent(inout) :: wk(k,*)
   end subroutine bspp
end interface
!-----------------------------------------------------------------------
!            Weighted least squares cubic spline fitting
!-----------------------------------------------------------------------
!---------------------
!     real z(l-1), a(l-1), b(l-1), c(l-1), wk(7*l + 18)
!---------------------
if (l < 2) go to 100
n = l + 2
!
!                Define the knots for the b-splines
!
wk(1) = break(1)
wk(2) = break(1)
wk(3) = break(1)
wk(4) = break(1)
do j = 2,l
   if (break(j - 1) >= break(j)) go to 110
   wk(j + 3) = break(j)
end do
wk(l + 4) = break(l)
wk(l + 5) = break(l)
wk(l + 6) = break(l)
!
!     Obtain the b-spline coefficients of the least squares fit
!
la = n + 5
lw = la + n
lq = lw + n
call bslsq(x, y, wgt, m, wk(1), n, 4, wk(la), &
   & wk(lw), wk(lq), ierr)
if (ierr < 0) go to 120
ierr = 0
!
!     Obtain the coefficients of the fit in Taylor series form
!
call bspp(wk(1), wk(la), n, 4, break, &
   & wk(lq), lm1, temp)
k = lq
do j = 1,lm1
   z(j) = wk(k)
   a(j) = wk(k + 1)
   b(j) = wk(k + 2)
   c(j) = wk(k + 3)
   k = k + 4
20 continue
end do
return
!
!                       Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine spfit

subroutine cspfit(x, y, m, break, l, xcon, con, nder, nc, &
   & z, a, b, c, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, nc
real, intent(in) :: x(m), y(m)
real, intent(inout) :: break(l)
real, intent(in) :: xcon(*), con(*)
real, intent(inout) :: z(*), a(*), b(*), c(*), wk(*)
integer, intent(in) :: nder(*)
integer, intent(inout) :: iwk(*)
integer :: j, k, la, lm1, lw, n
real :: r, temp(20)
!-----------------------------------------------------------------------
!                Least squares cubic spline fitting with
!                  equality and inequality constraints
!-----------------------------------------------------------------------
!
!---------------------
!     xcon, con, nder are arrays of dimension max(1,nc).
!     z, A, b, c are arrays of dimension l - 1.
!     wk and iwk are arrays of dimension iwk(1) and iwk(2)
!        respectively. It is required that iwk(2) .GE. 2
!        and iwk(1) .GE. 7(l + 7) for all nc. If nc .GE. 1
!        then more storage will be needed.
!---------------------
if (l < 2) go to 100
n = l + 2
!
!                Define the knots for the b-splines
!
wk(1) = break(1)
wk(2) = break(1)
wk(3) = break(1)
wk(4) = break(1)
do j = 2,l
   if (break(j - 1) >= break(j)) go to 110
   wk(j + 3) = break(j)
end do
wk(l + 4) = break(l)
wk(l + 5) = break(l)
wk(l + 6) = break(l)
!
!     Obtain the b-spline coefficients of the least squares fit
!
k = 7*n + 35
if (iwk(1) < k) go to 120
la = n + 5
lw = la + n
ierr = 0
!
k = lw - 1
iwk(1) = iwk(1) - k
call bfit(wk(1), n, 4, x, y, m, xcon, con, nder, nc, ierr, &
   & wk(la), r, wk(lw), iwk)
iwk(1) = iwk(1) + k
if (ierr < 0 .or. ierr == 2) return
!
!     Obtain the coefficients of the fit in Taylor series form
!
call bspp(wk(1), wk(la), n, 4, break, &
   & wk(lw), lm1, temp)
k = lw
do j = 1,lm1
   z(j) = wk(k)
   a(j) = wk(k + 1)
   b(j) = wk(k + 2)
   c(j) = wk(k + 3)
   k = k + 4
20 continue
end do
return
!
!                       Error return
!
100 ierr = -1
return
!
110 ierr = -3
return
!
120 ierr = -6
iwk(1) = k
end subroutine cspfit

pure subroutine scomp(x,y,a,b,c,n,xi,yi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
real, intent(in) :: x(n), y(n), a(n), b(n), c(n), xi(ni)
real, intent(inout) :: yi(ni)
integer :: i, il, ir, k
real :: dx, xx, nswc_ai_r4
!
!     Abstract
!
!         scomp evaluates a cubic spline at the abscissas in xi.
!         It is assumed that the coefficients of the polynomials
!         which form the spline are provided.
!
!     Description of arguments
!
!       --Input--
!
!         x   - Array of the first n abscissas (in increasing order)
!               that define the spline.
!         y   - Array of the first n ordinates that define the spline.
!         A,b,c arrays that contain the coefficients of the polynomials
!               which form the spline. If i = 1,...,n  then the spline
!               has the value
!                    y(i) + a(i)*dx + b(i)*dx**2 + c(i)*dx**3
!               FOR x(i) .LE. xx .LE. x(i+1).  HERE dx = xx-x(i).
!         n   - The number of polynomials that define the spline.
!               The arrays x, y, A, b, c  must be dimensioned at
!               least n.  n must be greater than or equal to 1.
!         xi  - The abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         ni  - The number of abscissas at which the spline is to be
!               evaluated.  If ni is greater than 1 then xi and yi
!               must be arrays of dimension ni or larger.
!               It is assumed that ni is greater than or equal to 1.
!
!       --Output--
!
!         yi  - Array of values of the spline (ordinates) at xi.
!         ierr- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - ni is not positive.
!
!
!     Check input
!
if (ni > 0) go to 1
ierr = 1
return
1 ierr = 0
!
!     k is index on value of xi being worked on.  xx is that value.
!     i is current index into x array.
!
k = 1
xx = xi(1)
if (xx < x(1)) go to 90
if (xx >= x(n)) go to 80
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx < x(i + 1)) go to 100
i = i + 1
go to 50
!
!     xx is greater than x(n) or less than x(1)
!
80 i = n
go to 100
90 i = 1
!
!     Evaluation
!
100 dx = xx - x(i)
yi(k) = y(i) + dx*(a(i) + dx*(b(i) + dx*c(i)))
!
!     Next point
!
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(n)) go to 80
nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 110
if ( nswc_ai_r4 == 0 ) go to 100
go to 50
110 il = 1
ir = min(i + 1,n)
go to 10
end subroutine scomp

pure subroutine scomp1(x,y,yp,n,xi,yi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
real, intent(in) :: x(n), y(n), yp(n), xi(ni)
real, intent(inout) :: yi(ni)
integer :: i, il, ir, k, nm1
real :: a, b, c, d, dx, h, xx, nswc_ai_r4
!
!     Abstract
!
!         scomp1 evaluates a cubic spline at the abscissas in xi.
!         It is assumed that the first derivatives at the nodes
!         have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         x   - Array of abscissas (in increasing order) that define the
!               spline.
!         y   - Array of ordinates that define the spline.
!         yp  - Array of first derivatives that define the spline.
!         n   - The number of data points that define the spline.
!               The arrays x, y, and yp must be dimensioned at least n.
!               n must be greater than or equal to 2.
!         xi  - The abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         ni  - The number of abscissas at which the spline is to be
!               evaluated.  If ni is greater than 1 then xi and yi
!               must be arrays of dimension ni or larger.
!               It is assumed that ni is greater than or equal to 1.
!
!       --Output--
!
!         yi  - Array of values of the spline (ordinates) at xi.
!         ierr- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - ni is not positive.
!
!
!     Check input
!
if (ni > 0) go to 1
ierr = 1
return
1 ierr = 0
nm1 = n - 1
!
!     k is index on value of xi being worked on.  xx is that value.
!     i is current index into x array.
!
k = 1
xx = xi(1)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx < x(i + 1)) go to 100
i = i + 1
go to 50
!
!     xx is greater than x(n) or less than x(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h = x(i + 1) - x(i)
d = (y(i + 1) - y(i))/h
a = yp(i) + yp(i + 1)
b = (-a - yp(i) + 3.0*d)/h
c = (a - d - d)/(h*h)
dx = xx - x(i)
yi(k) = y(i) + dx*(yp(i) + dx*(b + dx*c))
!
!     Next point
!
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 110
if ( nswc_ai_r4 == 0 ) go to 100
go to 50
110 il = 1
ir = min(i + 1,nm1)
go to 10
end subroutine scomp1

pure subroutine scomp2(x,y,ypp,n,xi,yi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
real, intent(in) :: x(n), y(n), ypp(n), xi(ni)
real, intent(inout) :: yi(ni)
integer :: i, il, ir, k, nm1
real :: h, h2, xl, xl2, xl3, xr, xr2, xr3, xx, nswc_ai_r4
!
!     Abstract
!
!         scomp2 evaluates a cubic spline at the abscissas in xi.
!         It is assumed that the second derivatives at the nodes
!         have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         x   - Array of abscissas (in increasing order) that define the
!               spline.
!         y   - Array of ordinates that define the spline.
!         ypp - Array of second derivatives that define the spline.
!         n   - The number of data points that define the spline.
!               The arrays x, y, and ypp must be dimensioned at least n.
!               n must be greater than or equal to 2.
!         xi  - The abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         ni  - The number of abscissas at which the spline is to be
!               evaluated.  If ni is greater than 1 then xi and yi
!               must be arrays of dimension ni or larger.
!               It is assumed that ni is greater than or equal to 1.
!
!       --Output--
!
!         yi  - Array of values of the spline (ordinates) at xi.
!         ierr- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - ni is not positive.
!
!
!     Check input
!
if (ni > 0) go to 1
ierr = 1
return
1 ierr = 0
nm1 = n - 1
!
!     k is index on value of xi being worked on.  xx is that value.
!     i is current index into x array.
!
k = 1
xx = xi(1)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx < x(i + 1)) go to 100
i = i + 1
go to 50
!
!     xx is greater than x(n) or less than x(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h = x(i + 1) - x(i)
h2 = h*h
xr = (x(i + 1) - xx)/h
xr2 = xr*xr
xr3 = xr*xr2
xl = (xx - x(i))/h
xl2 = xl*xl
xl3 = xl*xl2
yi(k) = y(i)*xr + y(i + 1)*xl &
   & - h2*(ypp(i)*(xr - xr3) + ypp(i + 1)*(xl - xl3))/6.0
!
!     Next point
!
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 110
if ( nswc_ai_r4 == 0 ) go to 100
go to 50
110 il = 1
ir = min(i + 1,nm1)
go to 10
end subroutine scomp2

pure subroutine seval(x,y,a,b,c,n,xi,yi,ypi,yppi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
real, intent(in) :: x(n), y(n), a(n), b(n), c(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
integer :: i, il, ir, k
real :: bi, ci, dx, xx, nswc_ai_r4
!
!     Abstract
!
!         seval evaluates a cubic spline and its first and second
!         derivatives at the abscissas in xi.  It is assumed that
!         the coefficients of the polynomials which form the spline
!         are provided.
!
!     Description of arguments
!
!       --Input--
!
!         x   - Array of the first n abscissas (in increasing order)
!               that define the spline.
!         y   - Array of the first n ordinates that define the spline.
!         A,b,c arrays that contain the coefficients of the polynomials
!               which form the spline. If i = 1,...,n  then the spline
!               has the value
!                    y(i) + a(i)*dx + b(i)*dx**2 + c(i)*dx**3
!               FOR x(i) .LE. xx .LE. x(i+1).  HERE dx = xx-x(i).
!         n   - The number of polynomials that define the spline.
!               The arrays x, y, A, b, c  must be dimensioned at
!               least n.  n must be greater than or equal to 1.
!         xi  - The abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         ni  - The number of abscissas at which the spline is to be
!               evaluated.  If ni is greater than 1, then xi, yi, ypi,
!               and yppi must be arrays dimensioned at least ni.
!               ni must be greater than or equal to 1.
!
!       --Output--
!
!         yi  - Array of values of the spline (ordinates) at xi.
!         ypi - Array of values of the first derivative of spline at xi.
!         yppi- array of values of second derivatives of spline at xi.
!         ierr- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - ni is not positive.
!
!
!     Check input
!
if (ni > 0) go to 1
ierr = 1
return
1 ierr = 0
!
!     k is index on value of xi being worked on.  xx is that value.
!     i is current index into x array.
!
k = 1
xx = xi(1)
if (xx < x(1)) go to 90
if (xx >= x(n)) go to 80
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx < x(i + 1)) go to 100
i = i + 1
go to 50
!
!     xx is greater than x(n) or less than x(1)
!
80 i = n
go to 100
90 i = 1
!
!     Evaluation
!
100 dx = xx - x(i)
yi(k) = y(i) + dx*(a(i) + dx*(b(i) + dx*c(i)))
bi = b(i) + b(i)
ci = 3.0*c(i)
ypi(k) = a(i) + dx*(bi + dx*ci)
yppi(k) = bi + dx*(ci + ci)
!
!     Next point
!
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(n)) go to 80
nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 110
if ( nswc_ai_r4 == 0 ) go to 100
go to 50
110 il = 1
ir = min(i + 1,n)
go to 10
end subroutine seval

pure subroutine seval1(x,y,yp,n,xi,yi,ypi,yppi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
real, intent(in) :: x(n), y(n), yp(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
integer :: i, il, ir, k, nm1
real :: a, b, c, d, dx, h, xx, nswc_ai_r4
!
!     Abstract
!
!         seval1 evaluates a cubic spline and its first and second
!         derivatives at the abscissas in xi.  It is assumed that
!         the first derivatives at the nodes have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         x   - Array of abscissas (in increasing order) that define the
!               spline.
!         y   - Array of ordinates that define the spline.
!         yp  - Array of first derivatives that define the spline.
!         n   - The number of data points that define the spline.
!               The arrays x, y, and yp must be dimensioned at least n.
!               n must be greater than or equal to 2.
!         xi  - The abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         ni  - The number of abscissas at which the spline is to be
!               evaluated.  If ni is greater than 1, then xi, yi, ypi,
!               and yppi must be arrays dimensioned at least ni.
!               ni must be greater than or equal to 1.
!
!       --Output--
!
!         yi  - Array of values of the spline (ordinates) at xi.
!         ypi - Array of values of the first derivative of spline at xi.
!         yppi- array of values of second derivatives of spline at xi.
!         ierr- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - ni is not positive.
!
!
!     Check input
!
if (ni > 0) go to 1
ierr = 1
return
1 ierr = 0
nm1 = n - 1
!
!     k is index on value of xi being worked on.  xx is that value.
!     i is current index into x array.
!
k = 1
xx = xi(1)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx < x(i + 1)) go to 100
i = i + 1
go to 50
!
!     xx is greater than x(n) or less than x(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h = x(i + 1) - x(i)
d = (y(i + 1) - y(i))/h
a = yp(i) + yp(i + 1)
b = (-a - yp(i) + 3.0*d)/h
c = (a - d - d)/(h*h)
dx = xx - x(i)
yi(k) = y(i) + dx*(yp(i) + dx*(b + dx*c))
b = b + b
c = 3.0*c
ypi(k) = yp(i) + dx*(b + dx*c)
yppi(k) = b + dx*(c + c)
!
!     Next point
!
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 110
if ( nswc_ai_r4 == 0 ) go to 100
go to 50
110 il = 1
ir = min(i + 1,nm1)
go to 10
end subroutine seval1

pure subroutine seval2(x,y,ypp,n,xi,yi,ypi,yppi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
real, intent(in) :: x(n), y(n), ypp(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
integer :: i, il, ir, k, nm1
real :: h, h2, xl, xl2, xl3, xr, xr2, xr3, xx, nswc_ai_r4
!
!     Abstract
!
!         seval2 evaluates a cubic spline and its first and second
!         derivatives at the abscissas in xi.  It is assumed that
!         the second derivatives at the nodes have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         x   - Array of abscissas (in increasing order) that define the
!               spline.
!         y   - Array of ordinates that define the spline.
!         ypp - Array of second derivatives that define the spline.
!         n   - The number of data points that define the spline.
!               The arrays x, y, and ypp must be dimensioned at least n.
!               n must be greater than or equal to 2.
!         xi  - The abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         ni  - The number of abscissas at which the spline is to be
!               evaluated.  If ni is greater than 1, then xi, yi, ypi,
!               and yppi must be arrays dimensioned at least ni.
!               ni must be greater than or equal to 1.
!
!       --Output--
!
!         yi  - Array of values of the spline (ordinates) at xi.
!         ypi - Array of values of the first derivative of spline at xi.
!         yppi- array of values of second derivatives of spline at xi.
!         ierr- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - ni is not positive.
!
!
!     Check input
!
if (ni > 0) go to 1
ierr = 1
return
1 ierr = 0
nm1 = n - 1
!
!     k is index on value of xi being worked on.  xx is that value.
!     i is current index into x array.
!
k = 1
xx = xi(1)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x ( i )
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx < x(i + 1)) go to 100
i = i + 1
go to 50
!
!     xx is greater than x(n) or less than x(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h = x(i + 1) - x(i)
h2 = h*h
xr = (x(i + 1) - xx)/h
xr2 = xr*xr
xr3 = xr*xr2
xl = (xx - x(i))/h
xl2 = xl*xl
xl3 = xl*xl2
yi(k) = y(i)*xr + y(i + 1)*xl &
   & - h2*(ypp(i)*(xr - xr3) + ypp(i + 1)*(xl - xl3))/6.0
ypi(k) = (y(i + 1) - y(i))/h &
   & + h*(ypp(i)*(1.0 - 3.0*xr2) - ypp(i + 1)*(1.0 - 3.0*xl2))/6.0
yppi(k) = ypp(i)*xr + ypp(i + 1)*xl
!
!     Next point
!
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(nm1)) go to 80
nswc_ai_r4 = xx - xi ( k - 1 )
if ( nswc_ai_r4 < 0 ) go to 110
if ( nswc_ai_r4 == 0 ) go to 100
go to 50
110 il = 1
ir = min(i + 1,nm1)
go to 10
end subroutine seval2

pure real function csint(x, y, a, b, c, n, alpha, beta)
implicit none
integer, intent(in) :: n
real, intent(in) :: alpha, beta
real, intent(in) :: x(n), y(n), a(n), b(n), c(n)
integer :: i, k, kp1, l, lm1
real :: a0, b0, d, d2, h, h2, r, s, sum
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!
!                    Integrating a cubic spline
!
!                         --------------
!
!     x      ARRAY OF THE FIRST n ABSCISSAS (IN INCREASING ORDER)
!            that define the spline.
!
!     y      ARRAY OF THE FIRST n ORDINATES THAT DEFINE THE SPLINE.
!
!     A,b,c  arrays that contain the coefficients of the polynomials
!            which form the spline. If i = 1,...,n  then the spline
!            has the value
!                    y(i) + a(i)*DX + b(i)*DX**2 + c(i)*DX**3
!            FOR x(i) .LE. XX .LE. x(i+1). HERE DX = XX - x(i).
!
!     n      THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!            The arrays x, y, A, b, c  must be dimensioned at
!            least n.  n must be greater than or equal to 1.
!
!     alpha  lower limit of the integral.
!
!     beta   UPPER LIMIT OF THE INTEGRAL. beta MAY BE LESS THAN
!            or greater than alpha.
!
!-----------------------------------------------------------------------
!
csint = 0.0
h = beta - alpha
if (h == 0.0) return
if (h > 0.0) go to 10
a0 = beta
b0 = alpha
go to 20
10 a0 = alpha
b0 = beta
!
!     Locate the intervals containing a0 and b0
!
20 if (n == 1) go to 50
if (a0 >= x(n)) go to 50
k = intrvl(a0, x, n)
l = intrvl(b0, x, n)
if (b0 >= x(n)) l = n
if (k == l) go to 51
!
!     Integrate from a0 to x(k + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*a(k)*r + b(k)*(s + h*d)/3.0 &
   & + 0.25*c(k)*r*s
sum = (x(kp1) - a0)*sum
!
!     Integrate over the interior intervals
!
if (kp1 == l) go to 40
lm1 = l - 1
do i = kp1,lm1
   h = x(i + 1) - x(i)
   s = (((0.25*c(i)*h + b(i)/3.0)*h + 0.5*a(i))*h + y(i))*h
   sum = sum + s
end do
!
!     Integrate from x(l) to b0
!
40 h = b0 - x(l)
s = (((0.25*c(l)*h + b(l)/3.0)*h + 0.5*a(l))*h + y(l))*h
csint = sum + s
if (alpha > beta) csint = -csint
return
!
!     Case when a0 and b0 are in the same interval
!
50 k = n
51 h = b0 - x(k)
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*a(k)*r + b(k)*(s + h*d)/3.0 &
   & + 0.25*c(k)*r*s
csint = (beta - alpha)*sum
end function csint

pure real function csint1(x, y, yp, n, a, b)
implicit none
integer, intent(in) :: n
real, intent(in) :: a, b
real, intent(in) :: x(n), y(n), yp(n)
integer :: i, ip1, k, kp1, l, lm1, lp1
real :: a0, b0, bi, ci, d, d2, h, h2, r, s, sum
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!
!                    Integrating a cubic spline
!
!                         --------------
!
!     x    ARRAY OF THE FIRST n ABSCISSAS (IN INCREASING ORDER)
!          that define the spline.
!
!     y    ARRAY OF THE FIRST n ORDINATES THAT DEFINE THE SPLINE.
!
!     yp   ARRAY OF THE FIRST DERIVATIVES THAT DEFINE THE SPLINE.
!
!     n    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS x, y,
!          and yp must have dimension at least n where n .GE. 2.
!
!     A    LOWER LIMIT OF THE INTEGRAL.
!
!     b    UPPER LIMIT OF THE INTEGRAL. b MAY BE LESS THAN
!          or greater than A.
!
!-----------------------------------------------------------------------
!
csint1 = 0.0
h = b - a
if (h == 0.0) return
if (h > 0.0) go to 10
a0 = b
b0 = a
go to 20
10 a0 = a
b0 = b
!
!     Locate the intervals containing a0 and b0
!
20 k = intrvl(a0, x, n)
l = intrvl(b0, x, n)
if (k == l) go to 50
!
!     Integrate from a0 to x(k + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = (y(kp1) - y(k))/h
r = yp(k) + yp(kp1)
bi = (-r - yp(k) + 3.0*d)/h
ci = (r - d - d)/(h*h)
!
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*yp(k)*r + bi*(s + h*d)/3.0 &
   & + 0.25*ci*r*s
sum = (x(kp1) - a0)*sum
!
!     Integrate over the interior intervals
!
if (kp1 == l) go to 40
lm1 = l - 1
do i = kp1,lm1
   ip1 = i + 1
   h = x(ip1) - x(i)
   d = (y(ip1) - y(i))/h
   r = yp(i) + yp(ip1)
   bi = (-r - yp(i) + 3.0*d)/h
   ci = (r - d - d)/(h*h)
   s = (((0.25*ci*h + bi/3.0)*h + 0.5*yp(i))*h + y(i))*h
   sum = sum + s
end do
!
!     Integrate from x(l) to b0
!
40 lp1 = l + 1
h = x(lp1) - x(l)
d = (y(lp1) - y(l))/h
r = yp(l) + yp(lp1)
bi = (-r - yp(l) + 3.0*d)/h
ci = (r - d - d)/(h*h)
h = b0 - x(l)
s = (((0.25*ci*h + bi/3.0)*h + 0.5*yp(l))*h + y(l))*h
csint1 = sum + s
if (a > b) csint1 = -csint1
return
!
!     Case when a0 and b0 are in the same interval
!
50 kp1 = k + 1
h = x(kp1) - x(k)
d = (y(kp1) - y(k))/h
r = yp(k) + yp(kp1)
bi = (-r - yp(k) + 3.0*d)/h
ci = (r - d - d)/(h*h)
!
h = b0 - x(k)
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*yp(k)*r + bi*(s + h*d)/3.0 &
   & + 0.25*ci*r*s
csint1 = (b - a)*sum
end function csint1

pure real function csint2(x, y, ypp, n, a, b)
implicit none
integer, intent(in) :: n
real, intent(in) :: a, b
real, intent(in) :: x(n), y(n), ypp(n)
integer :: i, ip1, k, kp1, l, lm1, lp1
real :: a0, b0, d, dma, dmb, dpa, dpb, h, r, s, sum
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!
!                    Integrating a cubic spline
!
!                         --------------
!
!     x    ARRAY OF THE FIRST n ABSCISSAS (IN INCREASING ORDER)
!          that define the spline.
!
!     y    ARRAY OF THE FIRST n ORDINATES THAT DEFINE THE SPLINE.
!
!     ypp  array of the second derivatives that define the spline.
!
!     n    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS x, y,
!          and ypp must have dimension at least n where n .GE. 2.
!
!     A    LOWER LIMIT OF THE INTEGRAL.
!
!     b    UPPER LIMIT OF THE INTEGRAL. b MAY BE LESS THAN
!          or greater than A.
!
!-----------------------------------------------------------------------
!
csint2 = 0.0
h = b - a
if (h == 0.0) return
if (h > 0.0) go to 10
a0 = b
b0 = a
go to 20
10 a0 = a
b0 = b
!
!     Locate the intervals containing a0 and b0
!
20 k = intrvl(a0, x, n)
l = intrvl(b0, x, n)
if (k == l) go to 50
!
!     Integrate from a0 to x(k + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = (x(kp1) - a0)/h
r = y(k)*d + y(kp1)*(2.0 - d)
s = ypp(k)*(2.0 - d*d) + ypp(kp1)*(2.0 - d)**2
sum = h*d*(0.5*r - h*h*d*s/24.0)
!
!
!     Integrate over the interior intervals
!
if (kp1 == l) go to 40
lm1 = l - 1
do i = kp1,lm1
   ip1 = i + 1
   h = x(ip1) - x(i)
   r = y(i) + y(ip1)
   s = ypp(i) + ypp(ip1)
   sum = sum + h*(0.5*r - h*h*s/24.0)
end do
!
!     Integrate from x(l) to b0
!
40 lp1 = l + 1
h = x(lp1) - x(l)
d = (b0 - x(l))/h
r = y(l)*(2.0 - d) + y(lp1)*d
s = ypp(l)*(2.0 - d)**2 + ypp(lp1)*(2.0 - d*d)
csint2 = sum + h*d*(0.5*r - h*h*d*s/24.0)
if (a > b) csint2 = -csint2
return
!
!     Case when a0 and b0 are in the same interval
!
50 kp1 = k + 1
h = x(kp1) - x(k)
dma = (a - x(k))/h
dmb = (b - x(k))/h
dpa = (x(kp1) - a)/h
dpb = (x(kp1) - b)/h
r = (dpa + dpb)*y(k) + (dma + dmb)*y(kp1)
s = ypp(k) * (dpa + dpb)*(dma*(2.0 - dma) + dmb*(2.0 - dmb)) + &
   & ypp(kp1)*(dma + dmb)*(dpa*(2.0 - dpa) + dpb*(2.0 - dpb))
csint2 = (b - a)*(0.5*r - h*h*s/24.0)
end function csint2

pure subroutine pdspl(x, y, a, b, c, n, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: x(n), y(*)
real, intent(inout) :: a(*), b(*), c(*), t(*)
integer :: i, j, nm1, nm2, nm3
real :: alpha, del, del0, deli, delta, e, h, hi, r, s, si, w
!-----------------------------------------------------------------------
!                Periodic cubic spline interpolation
!-----------------------------------------------------------------------
!----------------------
!     real x(n), y(n-1), a(n-1), b(n-1), c(n-1), t(n-2)
!----------------------
if (n < 3) go to 100
nm1 = n - 1
nm2 = n - 2
nm3 = n - 3
!
!     A strictly diagonally dominant set of equations for the
!     slopes s(i) of the spline at x(i) (i = 1,...,n-1) is
!     generated and solved by Gauss elimination. The first of
!     these equations is obtained from the requirement that
!     the spline be periodic. This equation has the form ...
!
!        a(1)*s(1) + b(1)*s(2) + c(1)*s(n-1) = t(1)
!
b(1) = x(n) - x(nm1)
h = x(2) - x(1)
if (h <= 0.0 .or. b(1) <= 0.0) go to 110
del = (y(1) - y(nm1))/b(1)
deli = (y(2) - y(1))/h
!
c(1) = h
a(1) = 2.0*(h + b(1))
t(1) = 3.0*(h*del + b(1)*deli)
if (n == 3) go to 20
!
!     For the knots x(i) (i = 2,...n-2) generate the correspond-
!     ing equations and carry out the pivot reduction of Gauss
!     elimination. Then the i-TH equation has the form ...
!
!        a(i)*s(i) + b(i)*s(i+1) + c(i)*s(n-1) = t(i)
!
do i = 2,nm2
   b(i) = h
   h = x(i + 1) - x(i)
   if (h <= 0.0) go to 110
!
   e = h/a(i - 1)
   c(i) = - e*c(i - 1)
   a(i) = 2.0*(b(i) + h) - e*b(i - 1)
!
   del0 = deli
   deli = (y(i + 1) - y(i))/h
   t(i) = 3.0*(h*del0 + b(i)*deli) - e*t(i - 1)
end do
!
20 ierr = 0
b(nm1) = h
!
!     Since it is required that the spline be periodic, the
!     equation for the knot x(n-1) has the form ...
!
!        alpha*s(1) + b(1)*s(n-2) + delta*s(n-1) = r
!
!     Applying the pivots to this equation, one obtains after
!     each pivot operation the modified equation ...
!
!        alpha*s(i+1) + b(1)*s(n-2) + delta*s(n-1) = r
!
!     Thus, when this pivot reduction is complete, the (n-1)-ST
!     equation to be solved has the form ...
!
!        (alpha + b(1))*s(n-2) + delta*s(n-1) = r
!
alpha = h
delta = 2.0*(h + b(1))
r = 3.0*(b(1)*deli + h*del)
if (n == 3) go to 40
!
do i = 1,nm3
   e = alpha/a(i)
   alpha = - e*b(i)
   delta = delta - e*c(i)
   r = r - e*t(i)
end do
!
!     Solve the last two equations for s(n-1) and s(n-2), and
!     store these slopes in A.
!
40 e = (alpha + b(1))/a(nm2)
w = b(nm2) + c(nm2)
s = (r - e*t(nm2))/(delta - e*w)
a(nm1) = s
a(nm2) = (t(nm2) - w*s)/a(nm2)
if (n == 3) go to 60
!
!     Back substitution to obtain the remaining slopes s(i).
!     These slopes are stored in A.
!
si = a(nm2)
do j = 3,nm1
   i = n - j
   si = (t(i) - b(i)*si - c(i)*s)/a(i)
   a(i) = si
end do
!
!     Generate the cubic coefficients b(i) and c(i)
!
60 h = b(1)
do i = 1,nm2
   hi = b(i + 1)
   deli = (y(i + 1) - y(i))/hi
   w = a(i) + a(i + 1) - 2.0*deli
   b(i) = (deli - a(i) - w)/hi
   c(i) = (w/hi)/hi
end do
w = a(1) + a(nm1) - 2.0*del
b(nm1) = (del - a(nm1) - w)/h
c(nm1) = (w/h)/h
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
end subroutine pdspl

