subroutine dslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
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
if (ka == 0) go to 10
call tred1(ka, n, a, w, t(n + 1), t(1))
call tqlrat(n, w, t, ierr)
return
10 l = n*(n + 1)
l = l/2
call tred3(n, l, a, w, t(n + 1), t(1))
call tqlrat(n, w, t, ierr)
end subroutine seig

pure subroutine seig1(a, ka, n, w, t, ierr)
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
if (ka == 0) go to 10
call tred1(ka, n, a, w, t, t)
call imtql1(n, w, t, ierr)
return
10 l = n*(n + 1)
l = l/2
call tred3(n, l, a, w, t, t)
call imtql1(n, w, t, ierr)
end subroutine seig1

pure subroutine seigv(a, ka, n, w, z, t, ierr)
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
if (ka == 0) go to 10
call dtred1(ka, n, a, w, t(n + 1), t(1))
call dtql(n, w, t, ierr)
return
10 l = n*(n + 1)
l = l/2
call dtred3(n, l, a, w, t(n + 1), t(1))
call dtql(n, w, t, ierr)
end subroutine dseig

pure subroutine dseigv(a, ka, n, w, z, t, ierr)
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

pure subroutine dtred2(nm,n,a,d,e,z)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
double precision, intent(in) :: a(nm,n)
double precision, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, jp1
double precision :: f, g, h, hh, scale
!     double precision dsqrt,dabs
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
   h = 0.d0
   scale = 0.d0
   if (l < 2) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      scale = scale + abs(z(i,k))
   end do
   if (scale /= 0.d0) go to 140
130 e(i) = z(i,l)
   go to 290
140 do k = 1, l
      z(i,k) = z(i,k) / scale
      h = h + z(i,k) * z(i,k)
   end do
   f = z(i,l)
   g = sqrt(h)
   if (f >= 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   z(i,l) = f - g
   f = 0.d0
   do j = 1, l
      z(j,i) = z(i,j) / h
      g = 0.d0
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
320 d(1) = 0.d0
e(1) = 0.d0
!     ********** Accumulation of transformation matrices **********
do i = 1, n
   l = i - 1
   if (d(i) == 0.d0) go to 380
   do j = 1, l
      g = 0.d0
      do k = 1, l
         g = g + z(i,k) * z(k,j)
      end do
      do k = 1, l
         z(k,j) = z(k,j) - g * z(k,i)
      end do
   end do
380 d(i) = z(i,i)
   z(i,i) = 1.d0
   if (l < 1) go to 500
   do j = 1, l
      z(i,j) = 0.d0
      z(j,i) = 0.d0
   end do
500 continue
end do
!     ********** Last card of dtred2 **********
end subroutine dtred2

pure subroutine dtql2(nm,n,d,e,z,ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(out) :: ierr
double precision, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, ii, l1, mml
double precision :: b, c, f, g, h, p, r, s, machep
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
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
   e(i - 1) = e(i)
end do
f = 0.d0
b = 0.d0
e(n) = 0.d0
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
130 if (j == 50) go to 1000
   j = j + 1
!     ********** Form shift **********
   l1 = l + 1
   g = d(l)
   p = (d(l1) - g) / (2.d0 * e(l))
   r = sqrt(p*p + 1.d0)
   if (p < 0.d0) r = -r
   d(l) = e(l) / (p + r)
   h = g - d(l)
   do i = l1, n
      d(i) = d(i) - h
   end do
   f = f + h
!     ********** QL TRANSFORMATION **********
   p = d(m)
   c = 1.d0
   s = 0.d0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      g = c * e(i)
      h = c * p
      if (abs(p) < abs(e(i))) go to 150
      c = e(i) / p
      r = sqrt(c*c + 1.d0)
      e(i + 1) = s * p * r
      s = c / r
      c = 1.d0 / r
      go to 160
150   c = p / e(i)
      r = sqrt(c*c + 1.d0)
      e(i + 1) = s * e(i) * r
      s = 1.d0 / r
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
!                eigenvalue after 50 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of dtql2 **********
end subroutine dtql2

pure subroutine ceig(ibal,ar,ai,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine cbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine cbal
   pure subroutine comqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: hr(nm,n)
      real, intent(inout) :: hi(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine comqr
   pure subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      real, intent(inout) :: ortr(igh)
      real, intent(inout) :: orti(igh)
   end subroutine corth
end interface
!-----------------------------------------------------------------------
!                Eigenvalues of complex matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call cbal(ka,n,ar,ai,low,igh,wr)
call corth(ka,n,low,igh,ar,ai,wr,wi)
call comqr(ka,n,low,igh,ar,ai,wr,wi,ierr)
end subroutine ceig

pure subroutine ceigv(ibal,ar,ai,ka,n,wr,wi,zr,zi,ierr,temp)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n), zr(ka,n), &
   & zi(ka,n), temp(*)
!     beginning of local variable declarations
integer :: i1, i2, i3, igh, low
interface
   pure subroutine cbabk2(nm,n,low,igh,scale,m,zr,zi)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(in) :: scale(n)
      real, intent(inout) :: zr(nm,m)
      real, intent(inout) :: zi(nm,m)
   end subroutine cbabk2
   pure subroutine cbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine cbal
   pure subroutine comqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi, &
      & ierr)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: ortr(igh)
      real, intent(inout) :: orti(igh)
      real, intent(inout) :: hr(nm,n)
      real, intent(inout) :: hi(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      real, intent(inout) :: zr(nm,n)
      real, intent(inout) :: zi(nm,n)
      integer, intent(out) :: ierr
   end subroutine comqr2
   pure subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      real, intent(inout) :: ortr(igh)
      real, intent(inout) :: orti(igh)
   end subroutine corth
end interface
!-----------------------------------------------------------------------
!          Eigenvalues and eigenvectors of complex matrices
!-----------------------------------------------------------------------
!----------------------
!     Temp is a temporary storage area
!        DIMENSION(TEMP) .GE. 2*n    IF ibal .EQ. 0
!        DIMENSION(TEMP) .GE. 3*n    IF ibal .NE. 0
!----------------------
i2 = 1
i3 = n + 1
i1 = n + i3
low = 1
igh = n
if (ibal /= 0) call cbal(ka,n,ar,ai,low,igh,temp(i1))
call corth(ka,n,low,igh,ar,ai,temp(i2),temp(i3))
call comqr2(ka,n,low,igh,temp(i2),temp(i3),ar,ai,wr,wi,zr,zi,ierr)
if (ierr /= 0) return
if (ibal /= 0) call cbabk2(ka,n,low,igh,temp(i1),n,zr,zi)
end subroutine ceigv

pure subroutine cbal(nm,n,ar,ai,low,igh,scale)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
real, intent(inout) :: ar(nm,n), ai(nm,n), scale(n)
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
!     This subroutine is a translation of the Algol procedure
!     CBALANCE, which is a complex version of balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!     This subroutine balances a complex matrix and isolates
!     eigenvalues whenever possible.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex matrix to be balanced.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the balanced matrix,
!        low and igh are two integers such that ar(i,j) and ai(i,j)
!          are equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!        scale contains information determining the
!           permutations and scaling factors used.
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j)       j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!     Note that 1 is returned for igh if igh is zero formally.
!     The Algol procedure exc contained in CBALANCE appears in
!     cbal  in line.  (Note that the Algol roles of identifiers
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
   f = ar(i,j)
   ar(i,j) = ar(i,m)
   ar(i,m) = f
   f = ai(i,j)
   ai(i,j) = ai(i,m)
   ai(i,m) = f
end do
do i = k, n
   f = ar(j,i)
   ar(j,i) = ar(m,i)
   ar(m,i) = f
   f = ai(j,i)
   ai(j,i) = ai(m,i)
   ai(m,i) = f
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
      if (ar(j,i) /= 0.0 .or. ai(j,i) /= 0.0) go to 120
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
      if (ar(i,j) /= 0.0 .or. ai(i,j) /= 0.0) go to 170
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
      c = c + abs(ar(j,i)) + abs(ai(j,i))
      r = r + abs(ar(i,j)) + abs(ai(i,j))
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
      ar(i,j) = ar(i,j) * g
      ai(i,j) = ai(i,j) * g
   end do
   do j = 1, l
      ar(j,i) = ar(j,i) * f
      ai(j,i) = ai(j,i) * f
   end do
270 continue
end do
if (noconv) go to 190
280 low = k
igh = l
!     ********** Last card of cbal **********
end subroutine cbal

pure subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: ar(nm,n), ai(nm,n), ortr(igh), orti(igh)
!     beginning of local variable declarations
integer :: i, j, m, ii, jj, la, mp, kp1
real :: f, g, h, fi, fr, scale
!     real sqrt,cabs,abs
!     complex cmplx
!-----------------------------------------------------------------------
!     This subroutine is a translation of a complex analogue of
!     the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!     by Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!     Given a complex general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     unitary similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          set low=1, igh=n,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex input matrix.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the Hessenberg matrix.  Information
!          about the unitary transformations used in the reduction
!          is stored in the remaining triangles under the
!          Hessenberg matrix,
!        ortr and orti contain further information about the
!          transformations.  Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   h = 0.0
   ortr(m) = 0.0
   orti(m) = 0.0
   scale = 0.0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do i = m, igh
      scale = scale + abs(ar(i,m - 1)) + abs(ai(i,m - 1))
   end do
   if (scale == 0.0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ortr(i) = ar(i,m - 1) / scale
      orti(i) = ai(i,m - 1) / scale
      h = h + ortr(i) * ortr(i) + orti(i) * orti(i)
   end do
   g = sqrt(h)
   f = abs(cmplx(ortr(m),orti(m)))
   if (f == 0.0) go to 103
   h = h + f * g
   g = g / f
   ortr(m) = (1.0 + g) * ortr(m)
   orti(m) = (1.0 + g) * orti(m)
   go to 105
103 ortr(m) = g
   ar(m,m - 1) = scale
!     ********** FORM (i-(U*UT)/h) * A **********
105 do j = m, n
      fr = 0.0
      fi = 0.0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         fr = fr + ortr(i) * ar(i,j) + orti(i) * ai(i,j)
         fi = fi + ortr(i) * ai(i,j) - orti(i) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do i = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(i) + fi * orti(i)
         ai(i,j) = ai(i,j) - fr * orti(i) - fi * ortr(i)
      end do
   end do
!     ********** FORM (i-(U*UT)/h)*A*(i-(U*UT)/h) **********
   do i = 1, igh
      fr = 0.0
      fi = 0.0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         fr = fr + ortr(j) * ar(i,j) - orti(j) * ai(i,j)
         fi = fi + ortr(j) * ai(i,j) + orti(j) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do j = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(j) - fi * orti(j)
         ai(i,j) = ai(i,j) + fr * orti(j) - fi * ortr(j)
      end do
   end do
   ortr(m) = scale * ortr(m)
   orti(m) = scale * orti(m)
   ar(m,m - 1) = -g * ar(m,m - 1)
   ai(m,m - 1) = -g * ai(m,m - 1)
180 continue
end do
200 return
!     ********** Last card of corth **********
end subroutine corth

pure subroutine comqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: i, j, l, en, ll, its, lp1, enm1
real :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep
complex :: z3
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     integer min0
!     real sqrt,cabs,abs,real,aimag
!     complex csqrt,cmplx
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues of a complex
!     upper Hessenberg matrix BY the QR method.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          set low=1, igh=n,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain
!          information about the unitary transformations used in
!          the reduction by  corth, if performed.
!     On output-
!        the upper Hessenberg portions of hr and hi have been
!          destroyed.  Therefore, they must be saved before
!          calling  comqr  if subsequent calculation of
!          eigenvectors is to be performed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division and use of the subroutines
!     CSQRT and cmplx in computing complex square roots.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = spmpar(1)
!                **********
ierr = 0
if (low == igh) go to 180
!     ********** Create real subdiagonal elements **********
l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.0) go to 170
   norm = abs(cmplx(hr(i,i - 1),hi(i,i - 1)))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.0
   do j = i, igh
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = low, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by cbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.0
ti = 0.0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 1001
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low  -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 30) go to 1000
if (its == 10 .or. its == 20) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.0 .and. xi == 0.0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.0
yi = (hi(enm1,enm1) - si) / 2.0
z3 = sqrt(cmplx(yr**2 - yi**2 + xr,2.0*yr*yi + xi))
zzr = real(z3)
zzi = aimag(z3)
if (yr * zzr + yi * zzi >= 0.0) go to 310
zzr = -zzr
zzi = -zzi
310 z3 = cmplx(xr,xi) / cmplx(yr + zzr,yi + zzi)
sr = sr - real(z3)
si = si - aimag(z3)
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.0
   hi(i,i - 1) = sr / norm
   do j = i, en
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.0) go to 540
norm = abs(cmplx(hr(en,en),si))
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.0
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = l, j
      yr = hr(i,j - 1)
      yi = 0.0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.0) go to 240
do i = l, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 wr(en) = hr(en,en) + tr
wi(en) = hi(en,en) + ti
en = enm1
go to 220
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
!     ********** Last card of comqr **********
end subroutine comqr

pure subroutine cbabk2(nm,n,low,igh,scale,m,zr,zi)
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
real, intent(in) :: scale(n)
real, intent(inout) :: zr(nm,m), zi(nm,m)
!     beginning of local variable declarations
integer :: i, j, k, ii
real :: s
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     cbabk2, which is a complex version of balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!     This subroutine forms the eigenvectors of a complex general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by  cbal.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by  cbal,
!        scale contains information determining the permutations
!          and scaling factors used by  cbal,
!        m is the number of eigenvectors to be back transformed,
!        zr and zi contain the real and imaginary parts,
!          respectively, of the eigenvectors to be
!          back transformed in their first m columns.
!     On output-
!        zr and zi contain the real and imaginary parts,
!          respectively, of the transformed eigenvectors
!          in their first m columns.
!-----------------------------------------------------------------------
if (m == 0) go to 200
if (igh == low) go to 120
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
end do
!     ********** FOR i=low-1 STEP -1 UNTIL 1,
!                igh+1 STEP 1 UNTIL n DO -- **********
120 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
   do j = 1, m
      s = zr(i,j)
      zr(i,j) = zr(k,j)
      zr(k,j) = s
      s = zi(i,j)
      zi(i,j) = zi(k,j)
      zi(k,j) = s
   end do
140 continue
end do
200 return
!     ********** Last card of cbabk2 **********
end subroutine cbabk2

pure subroutine comqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), wi(n), zr(nm,n), &
   & zi(nm,n), ortr(igh), orti(igh)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ii, jj, ll, nn, ip1, its, lp1, enm1, iend, nswc_ai_i4
real :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep
complex :: z3
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     integer min0
!     real sqrt,cabs,abs,real,aimag
!     complex csqrt,cmplx
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues and eigenvectors
!     of a complex upper Hessenberg matrix BY the QR
!     method.  The eigenvectors of a complex general matrix
!     can also be found if  corth  has been used to reduce
!     this general matrix to Hessenberg form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          set low=1, igh=n,
!        ORTR and ORTI contain information about the unitary trans-
!          formations used in the reduction by  corth, if performed.
!          Only elements low through igh are used.  If the eigenvectors
!          of the Hessenberg matrix are desired, set ORTR(j) and
!          ORTI(j) to 0.0 for these elements,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain further
!          information about the transformations which were used in the
!          reduction by  corth, if performed.  If the eigenvectors of
!          the Hessenberg matrix are desired, these elements may be
!          arbitrary.
!     On output-
!        ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!          have been destroyed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        zr and ZI contain the real and imaginary parts,
!          respectively, of the eigenvectors.  The eigenvectors
!          are unnormalized.  If an error exit is made, none of
!          the eigenvectors has been found,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division and use of the subroutines
!     CSQRT and cmplx in computing complex square roots.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = spmpar(1)
!                **********
ierr = 0
!     ********** Initialize eigenvector matrix **********
do i = 1, n
   do j = 1, n
      zr(i,j) = 0.0
      zi(i,j) = 0.0
      if (i == j) zr(i,j) = 1.0
   end do
end do
!     ********** Form the matrix of accumulated transformations
!                from the information left by corth **********
iend = igh - low - 1
nswc_ai_i4 = iend
if (nswc_ai_i4 < 0) go to 180
if (nswc_ai_i4 == 0) go to 150
go to 105
!     ********** For i=igh-1 step -1 Until low+1 do -- **********
105 do ii = 1, iend
   i = igh - ii
   if (ortr(i) == 0.0 .and. orti(i) == 0.0) go to 140
   if (hr(i,i - 1) == 0.0 .and. hi(i,i - 1) == 0.0) go to 140
!     ********** norm below is negative of H formed in corth **********
   norm = hr(i,i - 1) * ortr(i) + hi(i,i - 1) * orti(i)
   ip1 = i + 1
   do k = ip1, igh
      ortr(k) = hr(k,i - 1)
      orti(k) = hi(k,i - 1)
   end do
   do j = i, igh
      sr = 0.0
      si = 0.0
      do k = i, igh
         sr = sr + ortr(k) * zr(k,j) + orti(k) * zi(k,j)
         si = si + ortr(k) * zi(k,j) - orti(k) * zr(k,j)
      end do
      sr = sr / norm
      si = si / norm
      do k = i, igh
         zr(k,j) = zr(k,j) + sr * ortr(k) - si * orti(k)
         zi(k,j) = zi(k,j) + sr * orti(k) + si * ortr(k)
      end do
   end do
140 continue
end do
!     ********** Create real subdiagonal elements **********
150 l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.0) go to 170
   norm = abs(cmplx(hr(i,i - 1),hi(i,i - 1)))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.0
   do j = i, n
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = 1, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
   do j = low, igh
      si = yr * zi(j,i) + yi * zr(j,i)
      zr(j,i) = yr * zr(j,i) - yi * zi(j,i)
      zi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by cbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.0
ti = 0.0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 680
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 30) go to 1000
if (its == 10 .or. its == 20) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.0 .and. xi == 0.0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.0
yi = (hi(enm1,enm1) - si) / 2.0
z3 = sqrt(cmplx(yr**2 - yi**2 + xr,2.0*yr*yi + xi))
zzr = real(z3)
zzi = aimag(z3)
if (yr * zzr + yi * zzi >= 0.0) go to 310
zzr = -zzr
zzi = -zzi
310 z3 = cmplx(xr,xi) / cmplx(yr + zzr,yi + zzi)
sr = sr - real(z3)
si = si - aimag(z3)
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.0
   hi(i,i - 1) = sr / norm
   do j = i, n
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.0) go to 540
norm = abs(cmplx(hr(en,en),si))
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.0
if (en == n) go to 540
ip1 = en + 1
do j = ip1, n
   yr = hr(en,j)
   yi = hi(en,j)
   hr(en,j) = sr * yr + si * yi
   hi(en,j) = sr * yi - si * yr
end do
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = 1, j
      yr = hr(i,j - 1)
      yi = 0.0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
   do i = low, igh
      yr = zr(i,j - 1)
      yi = zi(i,j - 1)
      zzr = zr(i,j)
      zzi = zi(i,j)
      zr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      zi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
      zr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      zi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.0) go to 240
do i = 1, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
do i = low, igh
   yr = zr(i,en)
   yi = zi(i,en)
   zr(i,en) = sr * yr - si * yi
   zi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 hr(en,en) = hr(en,en) + tr
wr(en) = hr(en,en)
hi(en,en) = hi(en,en) + ti
wi(en) = hi(en,en)
en = enm1
go to 220
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
680 norm = 0.0
do i = 1, n
   do j = i, n
      norm = norm + abs(hr(i,j)) + abs(hi(i,j))
   end do
end do
if (n == 1 .or. norm == 0.0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 2 DO -- **********
do nn = 2, n
   en = n + 2 - nn
   xr = wr(en)
   xi = wi(en)
   enm1 = en - 1
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, enm1
      i = en - ii
      zzr = hr(i,en)
      zzi = hi(i,en)
      if (i == enm1) go to 760
      ip1 = i + 1
      do j = ip1, enm1
         zzr = zzr + hr(i,j) * hr(j,en) - hi(i,j) * hi(j,en)
         zzi = zzi + hr(i,j) * hi(j,en) + hi(i,j) * hr(j,en)
      end do
760   yr = xr - wr(i)
      yi = xi - wi(i)
      if (yr == 0.0 .and. yi == 0.0) yr = machep * norm
      z3 = cmplx(zzr,zzi) / cmplx(yr,yi)
      hr(i,en) = real(z3)
      hi(i,en) = aimag(z3)
   end do
end do
!     ********** End backsubstitution **********
enm1 = n - 1
!     ********** Vectors of isolated roots **********
do i = 1, enm1
   if (i >= low .and. i <= igh) go to 840
   ip1 = i + 1
   do j = ip1, n
      zr(i,j) = hr(i,j)
      zi(i,j) = hi(i,j)
   end do
840 continue
end do
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low+1 do -- **********
do jj = low, enm1
   j = n + low - jj
   m = min(j - 1,igh)
   do i = low, igh
      zzr = zr(i,j)
      zzi = zi(i,j)
      do k = low, m
         zzr = zzr + zr(i,k) * hr(k,j) - zi(i,k) * hi(k,j)
         zzi = zzi + zr(i,k) * hi(k,j) + zi(i,k) * hr(k,j)
      end do
      zr(i,j) = zzr
      zi(i,j) = zzi
   end do
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
!     ********** Last card of comqr2 **********
end subroutine comqr2

pure subroutine dceig(ibal,ar,ai,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
   & wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine dcbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      double precision, intent(inout) :: scale(n)
   end subroutine dcbal
   pure subroutine dcomqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(inout) :: hr(nm,n)
      double precision, intent(inout) :: hi(nm,n)
      double precision, intent(inout) :: wr(n)
      double precision, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine dcomqr
   pure subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      double precision, intent(inout) :: ortr(igh)
      double precision, intent(inout) :: orti(igh)
   end subroutine dcorth
end interface
!-----------------------------------------------------------------------
!            Eigenvalues of double precision complex matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call dcbal(ka,n,ar,ai,low,igh,wr)
call dcorth(ka,n,low,igh,ar,ai,wr,wi)
call dcomqr(ka,n,low,igh,ar,ai,wr,wi,ierr)
end subroutine dceig

pure subroutine dceigv(ibal,ar,ai,ka,n,wr,wi,zr,zi,ierr,temp)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
   & wi(n), zr(ka,n), zi(ka,n), temp(*)
!     beginning of local variable declarations
integer :: i1, i2, i3, igh, low
interface
   pure subroutine dcbabk(nm,n,low,igh,scale,m,zr,zi)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(in) :: scale(n)
      double precision, intent(inout) :: zr(nm,m)
      double precision, intent(inout) :: zi(nm,m)
   end subroutine dcbabk
   pure subroutine dcbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      double precision, intent(inout) :: scale(n)
   end subroutine dcbal
   pure subroutine dcmqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi, &
      & ierr)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: ortr(igh)
      double precision, intent(inout) :: orti(igh)
      double precision, intent(inout) :: hr(nm,n)
      double precision, intent(inout) :: hi(nm,n)
      double precision, intent(inout) :: wr(n)
      double precision, intent(inout) :: wi(n)
      double precision, intent(inout) :: zr(nm,n)
      double precision, intent(inout) :: zi(nm,n)
      integer, intent(out) :: ierr
   end subroutine dcmqr2
   pure subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      double precision, intent(inout) :: ortr(igh)
      double precision, intent(inout) :: orti(igh)
   end subroutine dcorth
end interface
!-----------------------------------------------------------------------
!                     Eigenvalues and eigenvectors
!                 of double precision complex matrices
!-----------------------------------------------------------------------
!----------------------
!     Temp is a temporary storage area
!        DIMENSION(TEMP) .GE. 2*n    IF ibal .EQ. 0
!        DIMENSION(TEMP) .GE. 3*n    IF ibal .NE. 0
!----------------------
i2 = 1
i3 = n + 1
i1 = n + i3
low = 1
igh = n
if (ibal /= 0) call dcbal(ka,n,ar,ai,low,igh,temp(i1))
call dcorth(ka,n,low,igh,ar,ai,temp(i2),temp(i3))
call dcmqr2(ka,n,low,igh,temp(i2),temp(i3),ar,ai,wr,wi, &
   & zr,zi,ierr)
if (ierr /= 0) return
if (ibal /= 0) call dcbabk(ka,n,low,igh,temp(i1),n,zr,zi)
end subroutine dceigv

pure subroutine dcbal(nm,n,ar,ai,low,igh,scale)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
double precision, intent(inout) :: ar(nm,n), ai(nm,n), scale(n)
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
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     CBALANCE, which is a complex version of balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!     dcbal balances a double precision complex matrix and
!     isolates eigenvalues whenever possible.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex matrix to be balanced.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the balanced matrix,
!        low and igh are two integers such that ar(i,j) and ai(i,j)
!          are equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!        scale contains information determining the
!           permutations and scaling factors used.
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j)       j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!     Note that 1 is returned for igh if igh is zero formally.
!     The Algol procedure exc contained in CBALANCE appears in
!     dcbal in line.  (Note that the Algol roles of identifiers
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
   f = ar(i,j)
   ar(i,j) = ar(i,m)
   ar(i,m) = f
   f = ai(i,j)
   ai(i,j) = ai(i,m)
   ai(i,m) = f
end do
do i = k, n
   f = ar(j,i)
   ar(j,i) = ar(m,i)
   ar(m,i) = f
   f = ai(j,i)
   ai(j,i) = ai(m,i)
   ai(m,i) = f
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
      if (ar(j,i) /= 0.d0 .or. ai(j,i) /= 0.d0) go to 120
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
      if (ar(i,j) /= 0.d0 .or. ai(i,j) /= 0.d0) go to 170
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
      c = c + abs(ar(j,i)) + abs(ai(j,i))
      r = r + abs(ar(i,j)) + abs(ai(i,j))
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
      ar(i,j) = ar(i,j) * g
      ai(i,j) = ai(i,j) * g
   end do
   do j = 1, l
      ar(j,i) = ar(j,i) * f
      ai(j,i) = ai(j,i) * f
   end do
270 continue
end do
if (noconv) go to 190
280 low = k
igh = l
!     ********** Last card of dcbal **********
end subroutine dcbal

pure subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
double precision, intent(inout) :: ar(nm,n), ai(nm,n), ortr(igh), &
   & orti(igh)
!     beginning of local variable declarations
integer :: i, j, m, ii, jj, la, mp, kp1
double precision :: f, g, h, fi, fr, scale
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of a complex analogue of
!     the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!     by Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!     Given a double precision complex matrix, dcorth
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     unitary similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          set low=1, igh=n,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex input matrix.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the Hessenberg matrix.  Information
!          about the unitary transformations used in the reduction
!          is stored in the remaining triangles under the
!          Hessenberg matrix,
!        ortr and ORTI contain further information about the
!          transformations.  Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   h = 0.d0
   ortr(m) = 0.d0
   orti(m) = 0.d0
   scale = 0.d0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do i = m, igh
      scale = scale + abs(ar(i,m - 1)) + abs(ai(i,m - 1))
   end do
   if (scale == 0.d0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ortr(i) = ar(i,m - 1) / scale
      orti(i) = ai(i,m - 1) / scale
      h = h + ortr(i) * ortr(i) + orti(i) * orti(i)
   end do
   g = sqrt(h)
   f = dcpabs(ortr(m),orti(m))
   if (f == 0.d0) go to 103
   h = h + f * g
   g = g / f
   ortr(m) = (1.d0 + g) * ortr(m)
   orti(m) = (1.d0 + g) * orti(m)
   go to 105
103 ortr(m) = g
   ar(m,m - 1) = scale
!     ********** FORM (i-(U*UT)/h) * A **********
105 do j = m, n
      fr = 0.d0
      fi = 0.d0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         fr = fr + ortr(i) * ar(i,j) + orti(i) * ai(i,j)
         fi = fi + ortr(i) * ai(i,j) - orti(i) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do i = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(i) + fi * orti(i)
         ai(i,j) = ai(i,j) - fr * orti(i) - fi * ortr(i)
      end do
   end do
!     ********** FORM (i-(U*UT)/h)*A*(i-(U*UT)/h) **********
   do i = 1, igh
      fr = 0.d0
      fi = 0.d0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         fr = fr + ortr(j) * ar(i,j) - orti(j) * ai(i,j)
         fi = fi + ortr(j) * ai(i,j) + orti(j) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do j = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(j) - fi * orti(j)
         ai(i,j) = ai(i,j) + fr * orti(j) - fi * ortr(j)
      end do
   end do
   ortr(m) = scale * ortr(m)
   orti(m) = scale * orti(m)
   ar(m,m - 1) = -g * ar(m,m - 1)
   ai(m,m - 1) = -g * ai(m,m - 1)
180 continue
end do
200 return
!     ********** Last card of dcorth **********
end subroutine dcorth

pure subroutine dcomqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), &
   & wi(n)
!     beginning of local variable declarations
integer :: i, j, l, en, ll, its, lp1, enm1
double precision :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep, r2, w(2), z(2)
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine dcsqrt(z,w)
      implicit none
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine dcsqrt
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues of a double precision
!     complex upper Hessenberg matrix BY the QR method.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          set low=1, igh=n,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain
!          information about the unitary transformations used in
!          the reduction by dcorth, if performed.
!     On output-
!        the upper Hessenberg portions of hr and hi have been
!          destroyed.  Therefore, they must be saved before
!          calling dcomqr if subsequent calculation of
!          eigenvectors is to be performed,
!        wr and WI contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** MACHEP is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = dpmpar(1)
!                **********
ierr = 0
if (low == igh) go to 180
!     ********** Create real subdiagonal elements **********
l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.d0) go to 170
   norm = dcpabs(hr(i,i - 1),hi(i,i - 1))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.d0
   do j = i, igh
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = low, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by dcbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.d0
ti = 0.d0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 1001
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low  -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 50) go to 1000
if (its == 10 .or. its == 20 .or. its == 30) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.d0 .and. xi == 0.d0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.d0
yi = (hi(enm1,enm1) - si) / 2.d0
z(1) = yr*yr - yi*yi + xr
z(2) = 2.d0*yr*yi + xi
call dcsqrt(z,w)
zzr = w(1)
zzi = w(2)
if (yr * zzr + yi * zzi >= 0.d0) go to 310
zzr = -zzr
zzi = -zzi
310 z(1) = yr + zzr
z(2) = yi + zzi
r2 = z(1)**2 + z(2)**2
sr = sr - (xr*z(1) + xi*z(2))/r2
si = si - (xi*z(1) - xr*z(2))/r2
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.d0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.d0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.d0
   hi(i,i - 1) = sr / norm
   do j = i, en
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.d0) go to 540
norm = dcpabs(hr(en,en),si)
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.d0
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = l, j
      yr = hr(i,j - 1)
      yi = 0.d0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.d0) go to 240
do i = l, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 wr(en) = hr(en,en) + tr
wi(en) = hi(en,en) + ti
en = enm1
go to 220
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = en
1001 return
end subroutine dcomqr

pure subroutine dcbabk(nm,n,low,igh,scale,m,zr,zi)
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
double precision, intent(in) :: scale(n)
double precision, intent(inout) :: zr(nm,m), zi(nm,m)
!     beginning of local variable declarations
integer :: i, j, k, ii
double precision :: s
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     cbabk2, which is a complex version of balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!     This subroutine forms the eigenvectors of a double precision
!     complex matrix BY back transforming those of the corresponding
!     balanced matrix determined by dcbal.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by dcbal,
!        scale contains information determining the permutations
!          and scaling factors used by dcbal,
!        m is the number of eigenvectors to be back transformed,
!        zr and zi contain the real and imaginary parts,
!          respectively, of the eigenvectors to be
!          back transformed in their first m columns.
!     On output-
!        zr and zi contain the real and imaginary parts,
!          respectively, of the transformed eigenvectors
!          in their first m columns.
!-----------------------------------------------------------------------
if (m == 0) go to 200
if (igh == low) go to 120
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
end do
!     ********** FOR i=low-1 STEP -1 UNTIL 1,
!                igh+1 STEP 1 UNTIL n DO -- **********
120 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
   do j = 1, m
      s = zr(i,j)
      zr(i,j) = zr(k,j)
      zr(k,j) = s
      s = zi(i,j)
      zi(i,j) = zi(k,j)
      zi(k,j) = s
   end do
140 continue
end do
200 return
!     ********** Last card of dcbabk **********
end subroutine dcbabk

pure subroutine dcmqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), &
   & wi(n), zr(nm,n), zi(nm,n), ortr(igh), orti(igh)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ii, jj, ll, nn, ip1, its, lp1, enm1, iend, nswc_ai_i4
double precision :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep, r2, w(2), z(2)
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine dcsqrt(z,w)
      implicit none
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine dcsqrt
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues and eigenvectors of
!     a double precision complex upper Hessenberg matrix BY the
!     QR method.  The eigenvectors of a complex general matrix
!     can also be found if dcorth has been used to reduce
!     this general matrix to Hessenberg form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          set low=1, igh=n,
!        ORTR and ORTI contain information about the unitary trans-
!          formations used in the reduction by dcorth, if performed.
!          Only elements low through igh are used.  If the eigenvectors
!          of the Hessenberg matrix are desired, set ORTR(j) and
!          ORTI(j) to 0.0 for these elements,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain further
!          information about the transformations which were used in the
!          reduction by dcorth, if performed.  If the eigenvectors of
!          the Hessenberg matrix are desired, these elements may be
!          arbitrary.
!     On output-
!        ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!          have been destroyed,
!        wr and WI contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ZR and ZI contain the real and imaginary parts,
!          respectively, of the eigenvectors.  The eigenvectors
!          are unnormalized.  If an error exit is made, none of
!          the eigenvectors has been found,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** MACHEP is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = dpmpar(1)
!                **********
ierr = 0
!     ********** Initialize eigenvector matrix **********
do i = 1, n
   do j = 1, n
      zr(i,j) = 0.d0
      zi(i,j) = 0.d0
      if (i == j) zr(i,j) = 1.d0
   end do
end do
!     ********** Form the matrix of accumulated transformations
!                from the information left by dcorth **********
iend = igh - low - 1
nswc_ai_i4 = iend
if (nswc_ai_i4 < 0) go to 180
if (nswc_ai_i4 == 0) go to 150
go to 105
!     ********** For i=igh-1 step -1 Until low+1 do -- **********
105 do ii = 1, iend
   i = igh - ii
   if (ortr(i) == 0.d0 .and. orti(i) == 0.d0) go to 140
   if (hr(i,i - 1) == 0.d0 .and. hi(i,i - 1) == 0.d0) go to 140
!     ********** Norm below is negative of H formed in dcorth **********
   norm = hr(i,i - 1) * ortr(i) + hi(i,i - 1) * orti(i)
   ip1 = i + 1
   do k = ip1, igh
      ortr(k) = hr(k,i - 1)
      orti(k) = hi(k,i - 1)
   end do
   do j = i, igh
      sr = 0.d0
      si = 0.d0
      do k = i, igh
         sr = sr + ortr(k) * zr(k,j) + orti(k) * zi(k,j)
         si = si + ortr(k) * zi(k,j) - orti(k) * zr(k,j)
      end do
      sr = sr / norm
      si = si / norm
      do k = i, igh
         zr(k,j) = zr(k,j) + sr * ortr(k) - si * orti(k)
         zi(k,j) = zi(k,j) + sr * orti(k) + si * ortr(k)
      end do
   end do
140 continue
end do
!     ********** Create real subdiagonal elements **********
150 l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.d0) go to 170
   norm = dcpabs(hr(i,i - 1),hi(i,i - 1))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.d0
   do j = i, n
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = 1, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
   do j = low, igh
      si = yr * zi(j,i) + yi * zr(j,i)
      zr(j,i) = yr * zr(j,i) - yi * zi(j,i)
      zi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by dcbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.d0
ti = 0.d0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 680
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 50) go to 1000
if (its == 10 .or. its == 20 .or. its == 30) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.d0 .and. xi == 0.d0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.d0
yi = (hi(enm1,enm1) - si) / 2.d0
z(1) = yr*yr - yi*yi + xr
z(2) = 2.d0*yr*yi + xi
call dcsqrt(z,w)
zzr = w(1)
zzi = w(2)
if (yr * zzr + yi * zzi >= 0.d0) go to 310
zzr = -zzr
zzi = -zzi
310 z(1) = yr + zzr
z(2) = yi + zzi
r2 = z(1)**2 + z(2)**2
sr = sr - (xr*z(1) + xi*z(2))/r2
si = si - (xi*z(1) - xr*z(2))/r2
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.d0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.d0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.d0
   hi(i,i - 1) = sr / norm
   do j = i, n
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.d0) go to 540
norm = dcpabs(hr(en,en),si)
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.d0
if (en == n) go to 540
ip1 = en + 1
do j = ip1, n
   yr = hr(en,j)
   yi = hi(en,j)
   hr(en,j) = sr * yr + si * yi
   hi(en,j) = sr * yi - si * yr
end do
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = 1, j
      yr = hr(i,j - 1)
      yi = 0.d0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
   do i = low, igh
      yr = zr(i,j - 1)
      yi = zi(i,j - 1)
      zzr = zr(i,j)
      zzi = zi(i,j)
      zr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      zi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
      zr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      zi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.d0) go to 240
do i = 1, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
do i = low, igh
   yr = zr(i,en)
   yi = zi(i,en)
   zr(i,en) = sr * yr - si * yi
   zi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 hr(en,en) = hr(en,en) + tr
wr(en) = hr(en,en)
hi(en,en) = hi(en,en) + ti
wi(en) = hi(en,en)
en = enm1
go to 220
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
680 norm = 0.d0
do i = 1, n
   do j = i, n
      norm = norm + abs(hr(i,j)) + abs(hi(i,j))
   end do
end do
if (n == 1 .or. norm == 0.d0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 2 DO -- **********
do nn = 2, n
   en = n + 2 - nn
   xr = wr(en)
   xi = wi(en)
   enm1 = en - 1
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, enm1
      i = en - ii
      zzr = hr(i,en)
      zzi = hi(i,en)
      if (i == enm1) go to 760
      ip1 = i + 1
      do j = ip1, enm1
         zzr = zzr + hr(i,j) * hr(j,en) - hi(i,j) * hi(j,en)
         zzi = zzi + hr(i,j) * hi(j,en) + hi(i,j) * hr(j,en)
      end do
760   yr = xr - wr(i)
      yi = xi - wi(i)
      if (yr == 0.d0 .and. yi == 0.d0) yr = machep * norm
      r2 = yr*yr + yi*yi
      hr(i,en) = (zzr*yr + zzi*yi)/r2
      hi(i,en) = (zzi*yr - zzr*yi)/r2
   end do
end do
!     ********** End backsubstitution **********
enm1 = n - 1
!     ********** Vectors of isolated roots **********
do i = 1, enm1
   if (i >= low .and. i <= igh) go to 840
   ip1 = i + 1
   do j = ip1, n
      zr(i,j) = hr(i,j)
      zi(i,j) = hi(i,j)
   end do
840 continue
end do
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low+1 do -- **********
do jj = low, enm1
   j = n + low - jj
   m = min(j - 1,igh)
   do i = low, igh
      zzr = zr(i,j)
      zzi = zi(i,j)
      do k = low, m
         zzr = zzr + zr(i,k) * hr(k,j) - zi(i,k) * hi(k,j)
         zzi = zzi + zr(i,k) * hi(k,j) + zi(i,k) * hr(k,j)
      end do
      zr(i,j) = zzr
      zi(i,j) = zzi
   end do
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = en
1001 return
!     ********** Last card of dcmqr2 **********
end subroutine dcmqr2

pure subroutine cl1(k, l, m, n, q, kq, kode, toler, iter, x, res, &
   & error, wk, iwk)
implicit none
integer, intent(inout) :: iter, iwk(*)
integer, intent(in) :: k
integer, intent(inout) :: kode
integer, intent(in) :: kq, l, m, n
real, intent(inout) :: error, q(kq,*), res(*)
real, intent(in) :: toler
real, intent(inout) :: wk(*), x(*)
!     beginning of local variable declarations
integer :: klm
interface
   pure subroutine xl1(k,l,m,n,klmd,klm2d,nklmd,n2d,q,kode, &
      & toler,iter,x,res,error,cu,iu,s)
      implicit none
      integer, intent(in) :: n2d
      integer, intent(in) :: nklmd
      integer, intent(in) :: klm2d
      integer, intent(in) :: klmd
      integer, intent(in) :: k
      integer, intent(in) :: l
      integer, intent(in) :: m
      integer, intent(in) :: n
      real, intent(inout) :: q(klm2d,n2d)
      integer, intent(inout) :: kode
      real, intent(in) :: toler
      integer, intent(inout) :: iter
      real, intent(inout) :: x(n2d)
      real, intent(inout) :: res(klmd)
      real, intent(inout) :: error
      real, intent(inout) :: cu(2,nklmd)
      integer, intent(inout) :: iu(2,nklmd)
      integer, intent(inout) :: s(klmd)
   end subroutine xl1
end interface
!     -------------------
klm = k + l + m
call xl1(k, l, m, n, klm, kq, klm + n, n + 2, q, kode, toler, &
   & iter, x, res, error, wk, iwk(klm + 1), iwk(1))
end subroutine cl1

pure subroutine xl1(k, l, m, n, klmd, klm2d, nklmd, n2d, &
   & q, kode, toler, iter, x, res, error, cu, iu, s)
implicit none
! This subroutine uses a modification of the simplex
! method of linear programming to calculate an L1 solution
! to A k by n system of linear equations
!             ax=b
! subject to l linear equality constraints
!             cx=d
! and m linear inequality constraints
!             EX.LE.F.
! Description of parameters
! k      number of rows of the matrix A (k.GE.1).
! l      number of rows of the matrix C (l.GE.0).
! m      number of rows of the matrix E (m.GE.0).
! n      number of columns of the matrices A,C,E (n.GE.1).
! klmd   SET TO AT LEAST k+l+m FOR ADJUSTABLE DIMENSIONS.
! klm2d  set to at least k+l+m+2 for adjustable dimensions.
! nklmd  set to at least n+k+l+m for adjustable dimensions.
! n2d    SET TO AT LEAST n+2 FOR ADJUSTABLE DIMENSIONS
! q      TWO DIMENSIONAL REAL ARRAY WITH klm2d ROWS AND
!        at least n2d columns.
!        On entry the matrices A,C and E, and the vectors
!        B,D and F must be stored in the first k+l+m rows
!        and n+1 columns of q as follows
!             A B
!         q = C D
!             E F
!        these values are destroyed by the subroutine.
! kode   A CODE USED ON ENTRY TO, AND EXIT
!        from, the subroutine.
!        On entry, this should normally be set to 0.
!        However, if certain nonnegativity constraints
!        are to be included implicitly, rather than
!        explicitly in the constraints EX.LE.F, then kode
!        should be set to 1, and the nonnegativity
!        constraints included in the arrays x and
!        res (see below).
!        On exit, kode has one of the
!        following values
!             0- optimal solution found,
!             1- no feasible solution to the
!                constraints,
!             2- calculations terminated
!                prematurely due to rounding errors,
!             3- maximum number of iterations reached.
! toler  a small positive tolerance. Empirical
!        evidence suggests toler = 10**(-D*2/3),
!        where D represents the number of decimal
!        digits of accuracy available. Essentially,
!        the subroutine CANNOT distinguish between zero
!        and any quantity whose magnitude does not exceed
!        toler. In particular, it will not pivot on any
!        number whose magnitude does not exceed toler.
! ITER   ON ENTRY ITER MUST CONTAIN AN UPPER BOUND ON
!        the maximum number of iterations allowed.
!        A suggested value is 10*(k+l+m). On exit iter
!        gives the number of simplex iterations.
! x      ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST n2d.
!        On exit this array contains A
!        solution to the L1 problem. If kode=1
!        on entry, this array is also used to include
!        simple nonnegativity constraints on the
!        variables. The values -1, 0, or 1
!        for x(j) indicate that the j-TH variable
!        is restricted to be .LE.0, unrestricted,
!        OR .GE.0 RESPECTIVELY.
! RES    ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST klmd.
!        On exit this contains the residuals B-AX
!        in the first k components, D-CX in the
!        NEXT l COMPONENTS (THESE WILL BE =0),AND
!        F-EX in the next m components. If kode=1 On
!        entry, this array is also used to include simple
!        nonnegativity constraints on the residuals
!        B-AX. The values -1, 0, or 1 for res(i)
!        indicate that the i-TH residual (1.le.i.le.k) is
!        restricted to be .LE.0, unrestricted, or .GE.0
!        respectively.
! Error  on exit, this gives the minimum sum of
!        absolute values of the residuals.
! cu     A TWO DIMENSIONAL REAL ARRAY WITH TWO ROWS AND
!        at least nklmd columns used for workspace.
! iu     A TWO DIMENSIONAL INTEGER ARRAY WITH TWO ROWS AND
!        at least nklmd columns used for workspace.
! s      INTEGER ARRAY OF SIZE AT LEAST klmd, USED FOR
!        workspace.
! If your Fortran compiler permits a single column of a two
! dimensional array to be passed to a one dimensional array
! through a subroutine CALL, considerable savings in
! execution time may be achieved through the use of the
! following subroutine, which operates on column vectors.
!     subroutine col(v1, v2, xmlt, notrow, k)
! this subroutine adds to the vector v1 a multiple of the
! vector v2 (elements 1 through k excluding NOTROW).
!     dimension v1(k), v2(k)
!     kend = notrow - 1
!     kstart = notrow + 1
!     if (kend .lt. 1) go to 20
!     do 10 i=1,kend
!        v1(i) = v1(i) + xmlt*v2(i)
!  10 continue
!     if(kstart .gt. k) go to 40
!  20 do 30 i=kstart,k
!       v1(i) = v1(i) + xmlt*v2(i)
!  30 continue
!  40 return
!     end
! see comments following statement labelled 440 for
! instructions on the implementation of this modification.
real, intent(inout) :: q, x
real, intent(inout) :: cu
real, intent(inout) :: res
real, intent(inout) :: error
real, intent(in) :: toler
integer, intent(in) :: k, l, m, n
integer, intent(inout) :: s
integer, intent(inout) :: iu
integer, intent(in) :: n2d
integer, intent(inout) :: iter
integer, intent(in) :: klmd
integer, intent(inout) :: kode
integer, intent(in) :: klm2d
integer, intent(in) :: nklmd
dimension q(klm2d,n2d), x(n2d), res(klmd), cu(2,nklmd), &
   & iu(2,nklmd), s(klmd)
!     beginning of local variable declarations
double precision :: sum
real :: z, sn, zu, zv, cuv, xmax, xmin, pivot, tpivot, nswc_ai_r4
integer :: i, j, ia, ii, in, js, kk, nk, n1, n2, jmn, jpn, klm, nkl, nk1, iimn, iout, klm1, klm2, nklm, nkl1, maxit, iphase, &
   & kforce, iineg
! Initialization.
maxit = iter
n1 = n + 1
n2 = n + 2
nk = n + k
nk1 = nk + 1
nkl = nk + l
nkl1 = nkl + 1
klm = k + l + m
klm1 = klm + 1
klm2 = klm + 2
nklm = n + klm
kforce = 1
iter = 0
js = 1
ia = 0
! Set up labels in q.
do j = 1,n
   q(klm2,j) = j
end do
do i = 1,klm
   q(i,n2) = n + i
   if (q(i,n1) >= 0.) go to 30
   do j = 1,n2
      q(i,j) = -q(i,j)
   end do
30 continue
end do
! Set up phase 1 costs.
iphase = 2
do j = 1,nklm
   cu(1,j) = 0.
   cu(2,j) = 0.
   iu(1,j) = 0
   iu(2,j) = 0
end do
if (l == 0) go to 60
do j = nk1,nkl
   cu(1,j) = 1.
   cu(2,j) = 1.
   iu(1,j) = 1
   iu(2,j) = 1
end do
iphase = 1
60 if (m == 0) go to 80
do j = nkl1,nklm
   cu(2,j) = 1.
   iu(2,j) = 1
   jmn = j - n
   if (q(jmn,n2) < 0.) iphase = 1
end do
80 if (kode == 0) go to 150
do j = 1,n
   nswc_ai_r4 = x(j)
   if (nswc_ai_r4 < 0) go to 90
   if (nswc_ai_r4 == 0) go to 110
   go to 100
90 cu(1,j) = 1.
   iu(1,j) = 1
   go to 110
100 cu(2,j) = 1.
   iu(2,j) = 1
110 continue
end do
do j = 1,k
   jpn = j + n
   nswc_ai_r4 = res(j)
   if (nswc_ai_r4 < 0) go to 120
   if (nswc_ai_r4 == 0) go to 140
   go to 130
120 cu(1,jpn) = 1.
   iu(1,jpn) = 1
   if (q(j,n2) > 0.0) iphase = 1
   go to 140
130 cu(2,jpn) = 1.
   iu(2,jpn) = 1
   if (q(j,n2) < 0.0) iphase = 1
140 continue
end do
150 if (iphase == 2) go to 500
! Compute the marginal costs.
160 do j = js,n1
   sum = 0.d0
   do i = 1,klm
      ii = q(i,n2)
      if (ii < 0) go to 170
      z = cu(1,ii)
      go to 180
170   iineg = -ii
      z = cu(2,iineg)
180   sum = sum + dble(q(i,j))*dble(z)
   end do
   q(klm1,j) = sum
end do
do j = js,n
   ii = q(klm2,j)
   if (ii < 0) go to 210
   z = cu(1,ii)
   go to 220
210 iineg = -ii
   z = cu(2,iineg)
220 q(klm1,j) = q(klm1,j) - z
end do
! Determine the vector to enter the basis.
240 xmax = 0.
if (js > n) go to 490
do j = js,n
   zu = q(klm1,j)
   ii = q(klm2,j)
   if (ii > 0) go to 250
   ii = -ii
   zv = zu
   zu = -zu - cu(1,ii) - cu(2,ii)
   go to 260
250 zv = -zu - cu(1,ii) - cu(2,ii)
260 if (kforce == 1 .and. ii > n) go to 280
   if (iu(1,ii) == 1) go to 270
   if (zu <= xmax) go to 270
   xmax = zu
   in = j
270 if (iu(2,ii) == 1) go to 280
   if (zv <= xmax) go to 280
   xmax = zv
   in = j
280 continue
end do
if (xmax <= toler) go to 490
if (q(klm1,in) == xmax) go to 300
do i = 1,klm2
   q(i,in) = -q(i,in)
end do
q(klm1,in) = xmax
! Determine the vector to leave the basis.
300 if (iphase == 1 .or. ia == 0) go to 330
xmax = 0.
do i = 1,ia
   z = abs(q(i,in))
   if (z <= xmax) go to 310
   xmax = z
   iout = i
310 continue
end do
if (xmax <= toler) go to 330
do j = 1,n2
   z = q(ia,j)
   q(ia,j) = q(iout,j)
   q(iout,j) = z
end do
iout = ia
ia = ia - 1
pivot = q(iout,in)
go to 420
330 kk = 0
do i = 1,klm
   z = q(i,in)
   if (z <= toler) go to 340
   kk = kk + 1
   res(kk) = q(i,n1)/z
   s(kk) = i
340 continue
end do
350 if (kk > 0) go to 360
kode = 2
go to 590
360 xmin = res(1)
iout = s(1)
j = 1
if (kk == 1) go to 380
do i = 2,kk
   if (res(i) >= xmin) go to 370
   j = i
   xmin = res(i)
   iout = s(i)
370 continue
end do
res(j) = res(kk)
s(j) = s(kk)
380 kk = kk - 1
pivot = q(iout,in)
ii = q(iout,n2)
if (iphase == 1) go to 400
if (ii < 0) go to 390
if (iu(2,ii) == 1) go to 420
go to 400
390 iineg = -ii
if (iu(1,iineg) == 1) go to 420
400 ii = abs(ii)
cuv = cu(1,ii) + cu(2,ii)
if (q(klm1,in) - pivot*cuv <= toler) go to 420
! Bypass intermediate vertices.
do j = js,n1
   z = q(iout,j)
   q(klm1,j) = q(klm1,j) - z*cuv
   q(iout,j) = -z
end do
q(iout,n2) = -q(iout,n2)
go to 350
! Gauss-Jordan elimination.
420 if (iter < maxit) go to 430
kode = 3
go to 590
430 iter = iter + 1
do j = js,n1
   if (j /= in) q(iout,j) = q(iout,j)/pivot
end do
! If permitted, use subroutine col of the description
! section and replace the following seven statements down
! to and including statement number 460 by..
!     do 460 j=js,n1
!        if(j .eq. in) go to 460
!        z = -q(iout,j)
!        call col(q(1,j), q(1,in), z, iout, klm1)
! 460 continue
do j = js,n1
   if (j == in) go to 460
   z = -q(iout,j)
   do i = 1,klm1
      if (i /= iout) q(i,j) = q(i,j) + z*q(i,in)
   end do
460 continue
end do
tpivot = -pivot
do i = 1,klm1
   if (i /= iout) q(i,in) = q(i,in)/tpivot
end do
q(iout,in) = 1./pivot
z = q(iout,n2)
q(iout,n2) = q(klm2,in)
q(klm2,in) = z
ii = abs(z)
if (iu(1,ii) == 0 .or. iu(2,ii) == 0) go to 240
do i = 1,klm2
   z = q(i,in)
   q(i,in) = q(i,js)
   q(i,js) = z
end do
js = js + 1
go to 240
! Test for optimality.
490 if (kforce == 0) go to 580
if (iphase == 1 .and. q(klm1,n1) <= toler) go to 500
kforce = 0
go to 240
! Set up phase 2 costs.
500 iphase = 2
do j = 1,nklm
   cu(1,j) = 0.
   cu(2,j) = 0.
end do
do j = n1,nk
   cu(1,j) = 1.
   cu(2,j) = 1.
end do
do i = 1,klm
   ii = q(i,n2)
   if (ii > 0) go to 530
   ii = -ii
   if (iu(2,ii) == 0) go to 560
   cu(2,ii) = 0.
   go to 540
530 if (iu(1,ii) == 0) go to 560
   cu(1,ii) = 0.
540 ia = ia + 1
   do j = 1,n2
      z = q(ia,j)
      q(ia,j) = q(i,j)
      q(i,j) = z
   end do
560 continue
end do
go to 160
570 if (q(klm1,n1) <= toler) go to 500
kode = 1
go to 590
580 if (iphase == 1) go to 570
! Prepare output.
kode = 0
590 sum = 0.d0
do j = 1,n
   x(j) = 0.
end do
do i = 1,klm
   res(i) = 0.
end do
do i = 1,klm
   ii = q(i,n2)
   sn = 1.
   if (ii > 0) go to 620
   ii = -ii
   sn = -1.
620 if (ii > n) go to 630
   x(ii) = sn*q(i,n1)
   go to 640
630 iimn = ii - n
   res(iimn) = sn*q(i,n1)
   if (ii >= n1 .and. ii <= nk) sum = sum + &
      & dble(q(i,n1))
640 continue
end do
error = sum
end subroutine xl1

subroutine llsq(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: iwk
integer, intent(in) :: ka, kb, m, n, nb
real, intent(inout) :: a(ka,n), b(kb,nb), wk(n)
dimension iwk(n)
!     beginning of local variable declarations
integer :: i, j, np1
real :: rnorm
logical :: exit
!     --------------
ierr = 0
if (1 < n .and. n <= m) go to 10
ierr = 1
return
10 np1 = n + 1
call ortho(m,n,a,ka,wk,iwk,exit)
if (exit) go to 20
ierr = 2
return
20 do j = 1,nb
   call orsol(m,n,a,ka,wk,iwk,b(1,j))
   if (m == n) go to 22
   rnorm = 0.0
   do i = np1,m
      rnorm = rnorm + b(i,j)*b(i,j)
   end do
   b(np1,j) = sqrt(rnorm)
22 continue
end do
end subroutine llsq

subroutine llsqmp(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: iwk
integer, intent(in) :: ka, kb, m, n, nb
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,nb), wk(*)
dimension iwk(n)
!     beginning of local variable declarations
integer :: i, j, lq, lr, ls, np1
real :: rnorm
logical :: exit
!     -------------------
!     dimension wk(mn + 2m + n)
!     -------------------
ierr = 0
if (1 < n .and. n <= m) go to 10
ierr = 2
return
10 np1 = n + 1
lr = m + 1
ls = lr + m
lq = ls + n
call mcopy(m, n, a, ka, wk(lq), m)
call ortho(m, n, wk(lq), m, wk(ls), iwk, exit)
if (exit) go to 20
ierr = 3
return
20 do j = 1,nb
   do i = 1,m
      wk(i) = b(i,j)
   end do
   call orsol(m, n, wk(lq), m, wk(ls), iwk, wk(1))
   call orimp(m, n, a, ka, wk(lq), m, wk(ls), iwk, b(1,j), &
      & wk(1), wk(lr), exit)
   do i = 1,n
      b(i,j) = wk(i)
   end do
   if (.not.exit) ierr = 1
   if (m == n) go to 31
   rnorm = 0.0
   do i = np1,m
      rnorm = rnorm + wk(i)*wk(i)
   end do
   b(np1,j) = sqrt(rnorm)
31 continue
end do
end subroutine llsqmp

pure subroutine ortho(m, n, qr, ms, s, ip, exit)
implicit none
integer, intent(inout) :: ip
integer, intent(in) :: m, ms, n
real, intent(inout) :: qr(ms,n), s(n)
logical, intent(out) :: exit
dimension ip(n)
!     beginning of local variable declarations
integer :: i, j, jp, k, kj, nn
real :: ajj, sav, ss, y
!***********************************************************************
!      Identification
!        ortho - Orthogonal transformation of a given general m by n
!                matrix A to upper triangular form
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        ortho computes an implicit orthogonal matrix Q and an explicit
!        upper triangular matrix R and a permutation matrix P satisfying
!        qr = PA given an m by n real matrix A.  ortho is intended for
!        use with the subroutine orsol to produce the least squares
!        solution of the equation AX = B.
!      Control
!        dimension qr(ms,n), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call ortho(m, n, qr, ms, s, ip, exit)
!        where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. n .LE. m).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             qr(i,j), i .LE. j, and the relevant parts of Q in qr(i,j),
!             i .GT. j.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR in the calling program.
!        s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        ip   is an integer output array containing in ip(i), i=1,...,n,
!             the images of the permutation corresponding to the PERMU-
!             TATION matrix P.
!        Exit is set to the value .TRUE. if the rank of A is equal to n
!             and .FALSE. otherwise.
!      Method
!        the matrix A in the array qr is reduced to upper triangular
!        form using orthogonal transformation with partial pivoting.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
exit = .true.
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   ip(j) = j
   jp = j + 1
   kj = j
!                                       Search for pivot in the j-TH
!                                       column and interchange rows.
   do k = jp, m
      if (abs(qr(k,j)) > abs(qr(kj,j))) kj = k
   end do
   if (qr(kj,j) == 0.0) go to 90
   if (kj == j) go to 30
   ip(j) = kj
   do i = j, n
      sav = qr(j,i)
      qr(j,i) = qr(kj,i)
      qr(kj,i) = sav
   end do
!                                       Normalize the pivoting column
!                                       and find its norm.
30 ajj = qr(j,j)
   do i = jp, m
      qr(i,j) = qr(i,j)/ajj
   end do
   sav = 1.0
   do i = jp, m
      sav = sav + qr(i,j)*qr(i,j)
   end do
   s(j) = -sqrt(sav)
   qr(j,j) = s(j)*ajj
   if (jp > n) go to 80
!                                       Premultiply QR with the j-TH
!                                       orthogonal matrix.
   y = 1.0 - s(j)
   do k = jp, n
      sav = qr(j,k)
      do i = jp, m
         sav = sav + qr(i,j)*qr(i,k)
      end do
      ss = qr(j,k)
      qr(j,k) = sav/s(j)
      ss = (ss - qr(j,k))/y
      do i = jp, m
         qr(i,k) = qr(i,k) - qr(i,j)*ss
      end do
   end do
80 continue
end do
return
90 exit = .false.
end subroutine ortho

subroutine orsol(m, n, qr, ms, s, ip, x)
implicit none
integer, intent(in) :: ip
integer, intent(in) :: m, ms, n
real :: qr(ms,n), s(n)
real, intent(inout) :: x(m)
dimension ip(n)
!     beginning of local variable declarations
integer :: i, ij, j, jp, k, ni, nm, nn
real :: sav, ss, y
!***********************************************************************
!      Identification
!        orsol - Least squares solution of a linear system given an
!                orthogonal-triangular factorization of the coefficient
!                matrix produced by subroutine ortho
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        orsol computes the least squares solution of the linear system
!        QRX = Pax = B where Q, R, and P are determined from a by ortho.
!      Control
!        dimension qr(ms,n), s(n), ip(n), x(m)
!        .
!        .
!        .
!        call orsol(m, n, qr, ms, s, ip, x)
!        where
!        m  is an integer input variable, the number of rows of A.
!        n  is an integer input variable, the number of columns of A
!             (1 .LT. n .LE. m).
!        QR is a real input array, the orthogonal and triangular factors
!           of a produced by ortho.
!        ms is an integer input variable, the leading dimension of
!           QR in the calling program.
!        s  is a real input array, the relevant parts of Q produced by
!           ortho.
!        ip is an integer input array, the permutation information
!           produced by ortho.
!        x  as a real input array is the right-hand side B of AX = B.
!        x  as a real output array is x(i), i = 1, ..., n, the least
!           squares solution, and x(j), j = n+1, ..., m, the vector
!           whose length is the minimum of all residual B - AX.
!      Method
!        the factored system QRX = Pax = PB are solved in the sequence
!        of QY = PB and RX = y. full rank for the matrix A is assumed
!        which can be checked by interrogating the logical output
!        variable produced by ortho.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   jp = j + 1
   ij = ip(j)
   y = 1.0 - s(j)
   sav = x(j)
   x(j) = x(ij)
   x(ij) = sav
!                                       Premultiply x with the j-TH
!                                       orthogonal matrix.
   sav = x(j)
   do k = jp, m
      sav = sav + qr(k,j)*x(k)
   end do
   ss = x(j)
   x(j) = sav/s(j)
   ss = (ss - x(j))/y
   do k = jp, m
      x(k) = x(k) - qr(k,j)*ss
   end do
end do
!                                       Back substitute to find the
!                                       least squares solution.
x(n) = x(n)/qr(n,n)
nm = n - 1
do i = 1, nm
   ni = n - i
   nn = n
   do j = 1, i
      x(ni) = x(ni) - qr(ni,nn)*x(nn)
      nn = nn - 1
   end do
   x(ni) = x(ni)/qr(ni,ni)
end do
end subroutine orsol

subroutine orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
implicit none
integer, intent(in) :: ip
integer, intent(in) :: ka, m, ms, n
real, intent(in) :: a(ka,n), b(m)
real :: qr(ms,n)
real, intent(inout) :: r(m)
real :: s(n)
real, intent(inout) :: x(m)
logical, intent(out) :: exit
dimension ip(n)
!     beginning of local variable declarations
integer :: i, j, k, np1
real :: eps, eps2, rat, ratio, rnrm2, xnrm2
double precision :: dsum
real, parameter :: zero = 0.0
real, parameter :: one = 1.0
real, parameter :: four = 4.0
real, parameter :: fourth = 0.25
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!      Purpose
!        given an approximate least squares solution x of a linear
!        system AX = b obtained using orsol. orimp attempts to compute
!        an improved solution correct to machine precision.
!      Control
!        dimension a(ka,n), qr(ms,n), b(m), x(m), r(m), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
!        where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!             (1 .LT. n .LE. m).
!        A    IS A REAL INPUT ARRAY, THE GIVEN m BY n MATRIX.
!        QR   IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR
!             factors of a produced by ortho.
!        b    is a real input array, the right hand side of AX = b.
!        x    AS A REAL INPUT ARRAY IS THE APPROXIMATE LEAST SQUARES
!             solution together with the residual information produced
!             BY orsol.
!        x    AS A REAL OUTPUT ARRAY IS THE IMPROVED LEAST SQUARES
!             solution with a residual of minimum length.
!        r    IS A REAL OUTPUT ARRAY, THE CORRECTION VECTOR ADDED TO x.
!        ka   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             of A in the calling program.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             of QR in the calling program.
!        s    IS A REAL INPUT ARRAY, A RELEVANT PART OF Q PRODUCED BY
!             ortho.
!        ip   IS AN INTEGER INPUT ARRAY, THE PERMUTATION INFORMATION
!             produced by ortho.
!        Exit is set to the value .TRUE. if improvement of x is success-
!             ful with a gain in accuracy of at least 50 per cent each
!             iteration and .FALSE. otherwise.
!      Method
!        orimp executes the iteration cycle
!              (1)  AR = b - AX
!              (2)  x = x + r
!        with a given initial x.  the residual vector b - AX is computed
!        to high accuracy by double precision.  orsol is then used to
!        solve (1).
! ----------------------------------------------------------------------
!     ********** eps is a machine dependent parameter. Assign eps
!                the value U where U is the smallest positive floating
!                point number such that 1.0 + U .GT. 1.0.
eps = spmpar(1)
exit = .true.
np1 = n + 1
eps2 = eps*eps
xnrm2 = zero
do i = 1,n
   xnrm2 = xnrm2 + x(i)*x(i)
end do
if (xnrm2 == zero) return
ratio = one
!                                       Find the residual vector.
20 do k = 1,m
   dsum = b(k)
   do j = 1,n
      dsum = dsum - dble(a(k,j))*dble(x(j))
   end do
   r(k) = dsum
end do
!                                       Find the correction vector.
call orsol(m, n, qr, ms, s, ip, r)
rnrm2 = zero
do k = 1,n
   rnrm2 = rnrm2 + r(k)*r(k)
end do
if (rnrm2 <= eps2*xnrm2) return
!                                       Form new approximate solution.
do k = 1,n
   x(k) = x(k) + r(k)
end do
xnrm2 = zero
do k = 1,n
   xnrm2 = xnrm2 + x(k)*x(k)
end do
if (m == n) go to 50
do k = np1,m
   x(k) = r(k)
end do
50 if (xnrm2 == zero) return
rat = ratio
ratio = rnrm2/xnrm2
if (ratio <= fourth*rat) go to 20
if (ratio <= min(rat,four*eps2)) return
exit = .false.
end subroutine orimp

pure subroutine dllsq(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n, nb
double precision, intent(inout) :: a(ka,n), b(kb,nb), wk(n)
integer, intent(inout) :: iwk(n)
!     beginning of local variable declarations
integer :: i, j, np1
double precision :: rnorm
logical :: exit
interface
   pure subroutine dorsol(m,n,qr,ms,s,ip,x)
      implicit none
      integer, intent(in) :: ms
      integer, intent(in) :: n
      integer, intent(in) :: m
      double precision, intent(in) :: qr(ms,n)
      double precision, intent(in) :: s(n)
      integer, intent(in) :: ip(n)
      double precision, intent(inout) :: x(m)
   end subroutine dorsol
   pure subroutine dortho(m,n,qr,ms,s,ip,exit)
      implicit none
      integer, intent(in) :: ms
      integer, intent(in) :: n
      integer, intent(in) :: m
      double precision, intent(inout) :: qr(ms,n)
      double precision, intent(inout) :: s(n)
      integer, intent(inout) :: ip(n)
      logical, intent(out) :: exit
   end subroutine dortho
end interface
!     --------------
ierr = 0
if (1 < n .and. n <= m) go to 10
ierr = 1
return
10 np1 = n + 1
call dortho(m,n,a,ka,wk,iwk,exit)
if (exit) go to 20
ierr = 2
return
20 do j = 1,nb
   call dorsol(m,n,a,ka,wk,iwk,b(1,j))
   if (m == n) go to 22
   rnorm = 0.d0
   do i = np1,m
      rnorm = rnorm + b(i,j)*b(i,j)
   end do
   b(np1,j) = sqrt(rnorm)
22 continue
end do
end subroutine dllsq

pure subroutine dortho(m, n, qr, ms, s, ip, exit)
implicit none
integer, intent(in) :: m, ms, n
double precision, intent(inout) :: qr(ms,n), s(n)
integer, intent(inout) :: ip(n)
logical, intent(out) :: exit
!     beginning of local variable declarations
integer :: i, j, jp, k, kj, nn
double precision :: ajj, sav, ss, y
!***********************************************************************
!      Identification
!        dortho - Orthogonal transformation of a given general m by n
!                matrix A to upper triangular form
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        dortho computes an implicit orthogonal matrix Q and an explicit
!        upper triangular matrix R and a permutation matrix P satisfying
!        qr = PA given an m by n real matrix A.  dortho is intended for
!        use with the subroutine dorsol to produce the least squares
!        solution of the equation AX = B.
!      Control
!        dimension qr(ms,n), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call dortho(m, n, qr, ms, s, ip, exit)
!        where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. n .LE. m).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             qr(i,j), i .LE. j, and the relevant parts of Q in qr(i,j),
!             i .GT. j.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR in the calling program.
!        s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        ip   is an integer output array containing in ip(i), i=1,...,n,
!             the images of the permutation corresponding to the PERMU-
!             TATION matrix P.
!        Exit is set to the value .TRUE. if the rank of A is equal to n
!             and .FALSE. otherwise.
!      Method
!        the matrix A in the array qr is reduced to upper triangular
!        form using orthogonal transformation with partial pivoting.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
exit = .true.
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   ip(j) = j
   jp = j + 1
   kj = j
!                                       Search for pivot in the j-TH
!                                       column and interchange rows.
   do k = jp, m
      if (abs(qr(k,j)) > abs(qr(kj,j))) kj = k
   end do
   if (qr(kj,j) == 0.d0) go to 90
   if (kj == j) go to 30
   ip(j) = kj
   do i = j, n
      sav = qr(j,i)
      qr(j,i) = qr(kj,i)
      qr(kj,i) = sav
   end do
!                                       Normalize the pivoting column
!                                       and find its norm.
30 ajj = qr(j,j)
   do i = jp, m
      qr(i,j) = qr(i,j)/ajj
   end do
   sav = 1.d0
   do i = jp, m
      sav = sav + qr(i,j)*qr(i,j)
   end do
   s(j) = -sqrt(sav)
   qr(j,j) = s(j)*ajj
   if (jp > n) go to 80
!                                       Premultiply QR with the j-TH
!                                       orthogonal matrix.
   y = 1.d0 - s(j)
   do k = jp, n
      sav = qr(j,k)
      do i = jp, m
         sav = sav + qr(i,j)*qr(i,k)
      end do
      ss = qr(j,k)
      qr(j,k) = sav/s(j)
      ss = (ss - qr(j,k))/y
      do i = jp, m
         qr(i,k) = qr(i,k) - qr(i,j)*ss
      end do
   end do
80 continue
end do
return
90 exit = .false.
end subroutine dortho

pure subroutine dorsol(m, n, qr, ms, s, ip, x)
implicit none
integer, intent(in) :: m, ms, n
double precision, intent(in) :: qr(ms,n), s(n)
double precision, intent(inout) :: x(m)
integer, intent(in) :: ip(n)
!     beginning of local variable declarations
integer :: i, ij, j, jp, k, ni, nm, nn
double precision :: sav, ss, y
!***********************************************************************
!      Identification
!        dorsol - Least squares solution of a linear system given an
!                orthogonal-triangular factorization of the coefficient
!                matrix produced by subroutine dortho
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        dorsol computes the least squares solution of the linear system
!        QRX = Pax = B where Q, R, and P are determined from a by dortho
!      control
!        dimension qr(ms,n), s(n), ip(n), x(m)
!        .
!        .
!        .
!        call dorsol(m, n, qr, ms, s, ip, x)
!        where
!        m  is an integer input variable, the number of rows of A.
!        n  is an integer input variable, the number of columns of A
!             (1 .LT. n .LE. m).
!        QR is a real input array, the orthogonal and triangular factors
!           of a produced by dortho.
!        ms is an integer input variable, the leading dimension of
!           QR in the calling program.
!        s  is a real input array, the relevant parts of Q produced by
!           dortho.
!        ip is an integer input array, the permutation information
!           produced by dortho.
!        x  as a real input array is the right-hand side B of AX = B.
!        x  as a real output array is x(i), i = 1, ..., n, the least
!           squares solution, and x(j), j = n+1, ..., m, the vector
!           whose length is the minimum of all residual B - AX.
!      Method
!        the factored system QRX = Pax = PB are solved in the sequence
!        of QY = PB and RX = y. full rank for the matrix A is assumed
!        which can be checked by interrogating the logical output
!        variable produced by dortho.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   jp = j + 1
   ij = ip(j)
   y = 1.d0 - s(j)
   sav = x(j)
   x(j) = x(ij)
   x(ij) = sav
!                                       Premultiply x with the j-TH
!                                       orthogonal matrix.
   sav = x(j)
   do k = jp, m
      sav = sav + qr(k,j)*x(k)
   end do
   ss = x(j)
   x(j) = sav/s(j)
   ss = (ss - x(j))/y
   do k = jp, m
      x(k) = x(k) - qr(k,j)*ss
   end do
end do
!                                       Back substitute to find the
!                                       least squares solution.
x(n) = x(n)/qr(n,n)
nm = n - 1
do i = 1, nm
   ni = n - i
   nn = n
   do j = 1, i
      x(ni) = x(ni) - qr(ni,nn)*x(nn)
      nn = nn - 1
   end do
   x(ni) = x(ni)/qr(ni,ni)
end do
end subroutine dorsol

subroutine lsqr(ind, a, mda, m, n, b, mdb, nb, re, ae, krank, &
   & ksure, rnorm, work, lw, iwork, liw, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ind
integer, intent(inout) :: krank, ksure
integer, intent(in) :: liw, lw, m, mda, mdb, n, nb
real, intent(in) :: ae, re
real, intent(inout) :: a(mda,n), b(mdb,*), rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
!     beginning of local variable declarations
integer :: i, imax, info, m0, m1, m2, m3, m4, m5, mode, n0, np
real :: eps, rerr
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!              Least squares solution of linear equations
!                            --------------
!     lsqr solves both underdetermined and overdetermined linear
!     systems AX = b, where A is an m by n matrix and b is an m by
!     nb matrix of right hand sides. If m .GE. n, the least squares
!     solution is computed by decomposing the matrix a into the
!     product of an orthogonal matrix Q and upper triangular matrix
!     R (QR factorization). If m .LT. n, the minimal length solution
!     is computed by factoring the matrix a into the product of a
!     lower triangular matrix L and orthogonal matrix Q (LQ factor-
!     ization). If the matrix a is determined to be rank deficient,
!     then the minimal length least squares solution is computed.
!     User input bounds on the uncertainty of the elements of A are
!     used to detect numerical rank deficiency. The algorithm uses
!     a row and column pivot strategy to minimize the growth of
!     uncertainty and round-off errors.
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!     Input..
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   called for the first time.
!                      ind = 0      Original call
!                      ind .NE. 0   subsequent calls
!                   on subsequent calls a new set b of equations can
!                   be solved (using the same coefficient matrix a).
!                   It is assumed that A, mda, m, n, krank, iwork,
!                   liw, and the first 2*min(m,n) locations of work
!                   have not been modified by the user. re, ae, and
!                   ksure are not used.
!     a(,)          linear coefficient matrix of AX=b, with mda the
!      mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   m is the row dimension (no. of equations of the
!                   problem) and n the col dimension (no. of unknowns).
!                   Must have mda .GE. m.
!     b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!                   number of m by 1 right hand sides. Must have
!                   mdb .GE. max(m,n). If nb .LE. 0 then b and mdb
!                   are ignored.
!     re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   elements of the matrix a (0 .le. re .LT. 1).
!     ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   elements of the matrix a (ae .GE. 0).
!     work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!     lw            ACTUAL DIMENSION OF WORK
!     iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!     liw           ACTUAL DIMENSION OF iwork.
!     Output..
!     a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   and the transformation information. A and the first
!                   2*min(m,n) elements of work (see below) completely
!                   specify the factorization of the matrix a.
!     b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!     krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   and absolute bounds on uncertainty, is bounded
!                   above by krank and below by ksure. The algorithm
!                   returns a solution based on krank. ksure provides
!                   an indication of the precision of the rank.
!     rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!                   VECTORS  b(i) - AX(i), i=1,...,nb.
!     work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!                   the values necessary to reproduce the Householder
!                   factorization of A.
!     iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!                   which the rows and columns were used. If m .GE. n
!                   then the first n locations contain the order of
!                   the columns and the next m locations the order of
!                   the rows. If m .LT. n then the order of the rows
!                   precedes the order of the columns.
!     ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - Satisfactory completion
!                   .GT. 0  - Input error
!----------------
!     The subroutines u11ls, u12ls, u11us, and u12us were written by
!     T. Manteuffel (LANL) in 1981. The driver routine lsqr was written
!     by A.H. Morris (NSWC) in 1991.
!----------------
!     Reference.  Manteuffel, T., An interval analysis approach to rank
!                 determination in linear least squares problems,
!                 Sandia Laboratories report SAND80-0655, June, 1980.
!-----------------------------------------------------------------------
!----------------
!     np            if m .GE. n then the first np columns of A
!                   are never interchanged.
!                   If m .LT. n then the first np rows of A are
!                   never interchanged. np is not referenced on
!                   a continuation call to the routine.
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   is to react if rank deficiency is detected.
!                   If mode = 0 Return immediately, no solution
!                             1 compute truncated solution
!                             2 compute minimal length solution
!                   mode must not be modified on a continuation
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   first n locations of work are used.
!----------------
np = 0
mode = 2
!     Check the input
if (nb <= 0 .and. ind /= 0) go to 200
if (m < 1 .or. n < 1) go to 210
if (mda < m) go to 220
if (liw < m + n) go to 240
m0 = min(m,n)
n0 = max(m,n)
!     num = 0
if (nb <= 0) go to 10
if (mdb < n0) go to 230
if (ind /= 0) go to 100
10 if (lw < 5*m0) go to 250
if (re < 0.0 .or. ae < 0.0) go to 260
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
!     num = np
if (m < n) go to 40
call u11ls(a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
go to 100
40 call u11us(a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!     Solution phase
100 ierr = 0
info = 0
if (krank == m0) go to 110
if (krank == 0) go to 110
!     if (krank .lt. num) go to 280
!     if (mode .eq. 0) return
info = mode
110 if (nb <= 0) return
m1 = 1
m2 = 1 + m0
if (info == 2) go to 130
!     Only min(m,n) elements of work are needed
if (lw < m0) go to 250
if (m < n) go to 120
call u12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m1),iwork(m1),iwork(m2))
return
120 call u12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m1),iwork(m1),iwork(m2))
return
!     Here 2*min(m,n) elements of work are needed
130 if (lw < 2*m0) go to 250
if (m < n) go to 140
call u12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m2),iwork(m1),iwork(m2))
return
140 call u12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m2),iwork(m1),iwork(m2))
return
!     Error return
!                             nb .LE. 0  on a continuation call
200 ierr = 7
return
!                             m .LT. 1 OR n .LT. 1
210 ierr = 1
return
!                             mda .LT. m
220 ierr = 2
return
!                             mdb .LT. max(m,n)
230 ierr = 3
return
!                             liw .LT. m + n
240 ierr = 4
return
!                             lw too small
250 ierr = 5
return
!                             re or ae is negative
260 ierr = 6
!                             0 .LT. krank .LT. np
! 280 ierr = 8
!     return
end subroutine lsqr

pure subroutine u11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
   & ic,ir)
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
real, intent(inout) :: a(mda,n), db(n), eb(n), h(n), ub(n), w(n)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
   & kp1, kz, l, lm1, mm, nmk
real :: bb, r2, rmin, sum, t, temp, tn, tt
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine iswap(n,ix,incx,iy,incy)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix(*)
      integer, intent(in) :: incx
      integer, intent(inout) :: iy(*)
      integer, intent(in) :: incy
   end subroutine iswap
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
!       This routine performs A QR factorization of A
!       using Householder transformations. Row and
!       column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!        Initialization
j = 0
krank = n
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!        Determine rel and abs error vectors
!        calculate col length
do i = 1,n
   h(i) = snrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!         Initialize error bounds
do i = 1,n
   eb(i) = max(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!          Discard self dependent columns
i = 1
50 if (eb(i) >= h(i)) go to 60
if (i == krank) go to 70
i = i + 1
go to 50
!          Matrix reduction
60 kk = krank
krank = krank - 1
if (mode == 0) return
if (i <= np) go to 400
if (i > krank) go to 70
call sswap(1,eb(i),1,eb(kk),1)
call sswap(1,ub(i),1,ub(kk),1)
call sswap(1,w(i),1,w(kk),1)
call sswap(1,h(i),1,h(kk),1)
call iswap(1,ic(i),1,ic(kk),1)
call sswap(m,a(1,i),1,a(1,kk),1)
go to 50
!           Test for zero rank
70 if (krank > 0) go to 100
krank = 0
ksure = 0
return
!        m A i n    L O O P
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j <= np) kz = j
!        Each col has MM=m-j+1 components
mm = m - j + 1
!         ub determines column pivot
110 imin = j
if (h(j) == 0.0) go to 170
rmin = ub(j)/h(j)
do i = j,kz
   if (ub(i) >= h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
end do
!     Test for rank deficiency
if (rmin < 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt >= 1.0) go to 170
!     Compute exact ub
do i = 1,jm1
   w(i) = a(i,imin)
end do
l = jm1
130 w(l) = w(l)/a(l,l)
if (l == 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(lm1,i)*w(i)
end do
l = lm1
go to 130
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) >= 1.0) go to 170
go to 200
!        Matrix reduction
170 kk = krank
krank = krank - 1
kz = krank
if (mode == 0) return
if (j <= np) go to 410
if (imin > krank) go to 180
call iswap(1,ic(imin),1,ic(kk),1)
call sswap(m,a(1,imin),1,a(1,kk),1)
call sswap(1,eb(imin),1,eb(kk),1)
call sswap(1,ub(imin),1,ub(kk),1)
call sswap(1,db(imin),1,db(kk),1)
call sswap(1,w(imin),1,w(kk),1)
call sswap(1,h(imin),1,h(kk),1)
180 if (j > krank) go to 300
go to 110
!        Column pivot
200 if (imin == j) go to 210
call sswap(1,h(j),1,h(imin),1)
call sswap(m,a(1,j),1,a(1,imin),1)
call sswap(1,eb(j),1,eb(imin),1)
call sswap(1,ub(j),1,ub(imin),1)
call sswap(1,db(j),1,db(imin),1)
call sswap(1,w(j),1,w(imin),1)
call iswap(1,ic(j),1,ic(imin),1)
!        Row pivot
210 jmax = isamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax == j) go to 220
call sswap(n,a(j,1),mda,a(jmax,1),mda)
call iswap(1,ir(j),1,ir(jmax),1)
!     Apply Householder transformation
220 tn = snrm2(mm,a(j,j),1)
if (tn == 0.0) go to 170
if (a(j,j) /= 0.0) tn = sign(tn,a(j,j))
call sscal(mm,1.0/tn,a(j,j),1)
a(j,j) = a(j,j) + 1.0
if (j == n) go to 250
do i = jp1,n
   bb = -sdot(mm,a(j,j),1,a(j,i),1)/a(j,j)
   call saxpy(mm,bb,a(j,j),1,a(j,i),1)
   if (i <= np) go to 240
   if (h(i) == 0.0) go to 240
   tt = 1.0 - (a(j,i)/h(i))**2
   tt = max(tt,0.0)
   t = tt
   tt = 1.0 + 0.05*tt*(h(i)/w(i))**2
   if (tt == 1.0) go to 230
   h(i) = h(i)*sqrt(t)
   go to 240
230 h(i) = snrm2(m - j,a(j + 1,i),1)
   w(i) = h(i)
240 continue
end do
250 h(j) = a(j,j)
a(j,j) = -tn
!          Update ub, db
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j == krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(j,i))*ub(j)
   db(i) = db(i) - a(j,i)*db(j)
end do
go to 100
!        E n D    m A i n    L O O P
300 continue
!        Compute ksure
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do ii = 1,kmi
      if (ub(ii) <= ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310   continue
   end do
   if (is == 0) exit
end do
ksure = 0
sum = 0.0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum >= 1.0) exit
   sum = sum + r2
   ksure = ksure + 1
end do
!     If system is of reduced rank and mode = 2
!     complete the decomposition for shortest least squares solution
if (krank == n .or. mode < 2) return
nmk = n - krank
kp1 = krank + 1
i = krank
340 tn = snrm2(nmk,a(i,kp1),mda)/a(i,i)
tn = a(i,i)*sqrt(1.0 + tn*tn)
call sscal(nmk,1.0/tn,a(i,kp1),mda)
w(i) = a(i,i)/tn + 1.0
a(i,i) = -tn
if (i == 1) go to 350
im1 = i - 1
do ii = 1,im1
   tt = -sdot(nmk,a(ii,kp1),mda,a(i,kp1),mda)/w(i)
   tt = tt - a(ii,i)
   call saxpy(nmk,tt,a(i,kp1),mda,a(ii,kp1),mda)
   a(ii,i) = a(ii,i) + tt*w(i)
end do
i = i - 1
go to 340
350 continue
return
!     First np columns are linearly dependent
400 krank = i - 1
return
410 krank = j - 1
end subroutine u11ls

subroutine u12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ic,ir)
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
real, intent(inout) :: a(mda,n), b(mdb,nb)
real :: h(n)
real, intent(inout) :: rnorm(nb)
real :: w(n)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ij, im1, j, jb, k, kp1, nmk
real :: bb, tt
real :: snrm2
real :: sdot
!        Given the Householder QR factorization of A, this
!        subroutine solves the system AX=b. if the system
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!       Note - If mode.NE.2, w is never accessed.
k = krank
kp1 = k + 1
if (k > 0) go to 30
!        rank=0
do jb = 1,nb
   rnorm(jb) = snrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
return
30 i = 0
!     Reorder b to reflect row interchanges
40 i = i + 1
if (i == m) go to 100
j = ir(i)
if (j == i) go to 40
if (j < 0) go to 40
ir(i) = -ir(i)
do jb = 1,nb
   rnorm(jb) = b(i,jb)
end do
ij = i
60 do jb = 1,nb
   b(ij,jb) = b(j,jb)
end do
ij = j
j = ir(ij)
ir(ij) = -ir(ij)
if (j /= i) go to 60
do jb = 1,nb
   b(ij,jb) = rnorm(jb)
end do
go to 40
100 do i = 1,m
   ir(i) = abs(ir(i))
end do
!     Apply Householder transformations to b
do j = 1,k
   tt = a(j,j)
   a(j,j) = h(j)
   do i = 1,nb
      bb = -sdot(m - j + 1,a(j,j),1,b(j,i),1)/h(j)
      call saxpy(m - j + 1,bb,a(j,j),1,b(j,i),1)
   end do
   a(j,j) = tt
end do
!        Find norms of residual vector(S)..(before overwrite b)
do jb = 1,nb
   rnorm(jb) = snrm2(m - k,b(kp1,jb),1)
end do
!     Back solve upper triangular R
i = k
150 do jb = 1,nb
   b(i,jb) = b(i,jb)/a(i,i)
end do
if (i == 1) go to 200
im1 = i - 1
do jb = 1,nb
   call saxpy(im1,-b(i,jb),a(1,i),1,b(1,jb),1)
end do
i = im1
go to 150
!     RANK LT n
!      truncated solution
200 if (k == n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
if (mode == 1) go to 230
!      Minimal length solution
nmk = n - k
do jb = 1,nb
   do i = 1,k
      tt = -sdot(nmk,a(i,kp1),mda,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call saxpy(nmk,tt,a(i,kp1),mda,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!     Reorder b to reflect column interchanges
230 i = 0
240 i = i + 1
if (i == n) go to 260
j = ic(i)
if (j == i) go to 240
if (j < 0) go to 240
ic(i) = -ic(i)
250 call sswap(nb,b(j,1),mdb,b(i,1),mdb)
ij = ic(j)
ic(j) = -ic(j)
j = ij
if (j /= i) go to 250
go to 240
260 do i = 1,n
   ic(i) = abs(ic(i))
end do
end subroutine u12ls

pure subroutine u11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
   & ir,ic)
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
real, intent(inout) :: a(mda,n), db(m), eb(m), h(m), ub(m), w(m)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
   & kp1, kz, l, lm1, mmk, nn
real :: bb, r2, rmin, sum, t, temp, tn, tt
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine iswap(n,ix,incx,iy,incy)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix(*)
      integer, intent(in) :: incx
      integer, intent(inout) :: iy(*)
      integer, intent(in) :: incy
   end subroutine iswap
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
!       This routine performs an LQ factorization of the
!       matrix a using Householder transformations. Row
!       and column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!        Initialization
j = 0
krank = m
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!        Determine rel and abs error vectors
!        calculate row length
do i = 1,m
   h(i) = snrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!         Initialize error bounds
do i = 1,m
   eb(i) = max(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!          Discard self dependent rows
i = 1
50 if (eb(i) >= h(i)) go to 60
if (i == krank) go to 70
i = i + 1
go to 50
!          Matrix reduction
60 kk = krank
krank = krank - 1
if (mode == 0) return
if (i <= np) go to 400
if (i > krank) go to 70
call sswap(1,eb(i),1,eb(kk),1)
call sswap(1,ub(i),1,ub(kk),1)
call sswap(1,w(i),1,w(kk),1)
call sswap(1,h(i),1,h(kk),1)
call iswap(1,ir(i),1,ir(kk),1)
call sswap(n,a(i,1),mda,a(kk,1),mda)
go to 50
!           Test for zero rank
70 if (krank > 0) go to 100
krank = 0
ksure = 0
return
!        m A i n    L O O P
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j <= np) kz = j
!        Each row has NN=n-j+1 components
nn = n - j + 1
!         ub determines row pivot
110 imin = j
if (h(j) == 0.0) go to 170
rmin = ub(j)/h(j)
do i = j,kz
   if (ub(i) >= h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
end do
!     Test for rank deficiency
if (rmin < 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt >= 1.0) go to 170
!     Compute exact ub
do i = 1,jm1
   w(i) = a(imin,i)
end do
l = jm1
130 w(l) = w(l)/a(l,l)
if (l == 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(i,lm1)*w(i)
end do
l = lm1
go to 130
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) >= 1.0) go to 170
go to 200
!        Matrix reduction
170 kk = krank
krank = krank - 1
kz = krank
if (mode == 0) return
if (j <= np) go to 410
if (imin > krank) go to 180
call iswap(1,ir(imin),1,ir(kk),1)
call sswap(n,a(imin,1),mda,a(kk,1),mda)
call sswap(1,eb(imin),1,eb(kk),1)
call sswap(1,ub(imin),1,ub(kk),1)
call sswap(1,db(imin),1,db(kk),1)
call sswap(1,w(imin),1,w(kk),1)
call sswap(1,h(imin),1,h(kk),1)
180 if (j > krank) go to 300
go to 110
!        Row pivot
200 if (imin == j) go to 210
call sswap(1,h(j),1,h(imin),1)
call sswap(n,a(j,1),mda,a(imin,1),mda)
call sswap(1,eb(j),1,eb(imin),1)
call sswap(1,ub(j),1,ub(imin),1)
call sswap(1,db(j),1,db(imin),1)
call sswap(1,w(j),1,w(imin),1)
call iswap(1,ir(j),1,ir(imin),1)
!        Column pivot
210 jmax = isamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax == j) go to 220
call sswap(m,a(1,j),1,a(1,jmax),1)
call iswap(1,ic(j),1,ic(jmax),1)
!     Apply Householder transformation
220 tn = snrm2(nn,a(j,j),mda)
if (tn == 0.0) go to 170
if (a(j,j) /= 0.0) tn = sign(tn,a(j,j))
call sscal(nn,1.0/tn,a(j,j),mda)
a(j,j) = a(j,j) + 1.0
if (j == m) go to 250
do i = jp1,m
   bb = -sdot(nn,a(j,j),mda,a(i,j),mda)/a(j,j)
   call saxpy(nn,bb,a(j,j),mda,a(i,j),mda)
   if (i <= np) go to 240
   if (h(i) == 0.0) go to 240
   tt = 1.0 - (a(i,j)/h(i))**2
   tt = max(tt,0.0)
   t = tt
   tt = 1.0 + 0.05*tt*(h(i)/w(i))**2
   if (tt == 1.0) go to 230
   h(i) = h(i)*sqrt(t)
   go to 240
230 h(i) = snrm2(n - j,a(i,j + 1),mda)
   w(i) = h(i)
240 continue
end do
250 h(j) = a(j,j)
a(j,j) = -tn
!          Update ub, db
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j == krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(i,j))*ub(j)
   db(i) = db(i) - a(i,j)*db(j)
end do
go to 100
!        E n D    m A i n    L O O P
300 continue
!        Compute ksure
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do ii = 1,kmi
      if (ub(ii) <= ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310   continue
   end do
   if (is == 0) exit
end do
ksure = 0
sum = 0.0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum >= 1.0) exit
   sum = sum + r2
   ksure = ksure + 1
end do
!     If system is of reduced rank and mode = 2
!     complete the decomposition for shortest least squares solution
if (krank == m .or. mode < 2) return
mmk = m - krank
kp1 = krank + 1
i = krank
340 tn = snrm2(mmk,a(kp1,i),1)/a(i,i)
tn = a(i,i)*sqrt(1.0 + tn*tn)
call sscal(mmk,1.0/tn,a(kp1,i),1)
w(i) = a(i,i)/tn + 1.0
a(i,i) = -tn
if (i == 1) go to 350
im1 = i - 1
do ii = 1,im1
   tt = -sdot(mmk,a(kp1,ii),1,a(kp1,i),1)/w(i)
   tt = tt - a(i,ii)
   call saxpy(mmk,tt,a(kp1,i),1,a(kp1,ii),1)
   a(i,ii) = a(i,ii) + tt*w(i)
end do
i = i - 1
go to 340
350 continue
return
!     First np rows are linearly dependent
400 krank = i - 1
return
410 krank = j - 1
end subroutine u11us

subroutine u12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ir,ic)
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
real, intent(inout) :: a(mda,n), b(mdb,nb)
real :: h(m)
real, intent(inout) :: rnorm(nb)
real :: w(m)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ij, ip1, j, jb, k, kp1, mmk
real :: bb, tt
real :: snrm2
real :: sdot
!        Given the Householder LQ factorization of A, this
!        subroutine solves the system AX=b. if the system
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!       Note - If mode.NE.2, w is never accessed.
k = krank
kp1 = k + 1
if (k > 0) go to 30
!        rank=0
do jb = 1,nb
   rnorm(jb) = snrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
return
30 i = 0
!     Reorder b to reflect row interchanges
40 i = i + 1
if (i == m) go to 100
j = ir(i)
if (j == i) go to 40
if (j < 0) go to 40
ir(i) = -ir(i)
do jb = 1,nb
   rnorm(jb) = b(i,jb)
end do
ij = i
60 do jb = 1,nb
   b(ij,jb) = b(j,jb)
end do
ij = j
j = ir(ij)
ir(ij) = -ir(ij)
if (j /= i) go to 60
do jb = 1,nb
   b(ij,jb) = rnorm(jb)
end do
go to 40
100 do i = 1,m
   ir(i) = abs(ir(i))
end do
!     If A is of reduced rank and mode=2,
!     apply Householder transformations to b
if (mode < 2 .or. k == m) go to 140
mmk = m - k
do jb = 1,nb
   do j = 1,k
      i = kp1 - j
      tt = -sdot(mmk,a(kp1,i),1,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call saxpy(mmk,tt,a(kp1,i),1,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!     Find norms of residual vector(S)..(before overwrite b)
140 do jb = 1,nb
   rnorm(jb) = snrm2(m - k,b(kp1,jb),1)
end do
!     Back solve lower triangular L
do jb = 1,nb
   do i = 1,k
      b(i,jb) = b(i,jb)/a(i,i)
      if (i == k) exit
      ip1 = i + 1
      call saxpy(k - i,-b(i,jb),a(ip1,i),1,b(ip1,jb),1)
   end do
end do
!      Truncated solution
if (k == n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
!     Apply Householder transformations to b
210 do i = 1,k
   j = kp1 - i
   tt = a(j,j)
   a(j,j) = h(j)
   do jb = 1,nb
      bb = -sdot(n - j + 1,a(j,j),mda,b(j,jb),1)/h(j)
      call saxpy(n - j + 1,bb,a(j,j),mda,b(j,jb),1)
   end do
   a(j,j) = tt
end do
!     Reorder b to reflect column interchanges
i = 0
240 i = i + 1
if (i == n) go to 260
j = ic(i)
if (j == i) go to 240
if (j < 0) go to 240
ic(i) = -ic(i)
250 call sswap(nb,b(j,1),mdb,b(i,1),mdb)
ij = ic(j)
ic(j) = -ic(j)
j = ij
if (j /= i) go to 250
go to 240
260 do i = 1,n
   ic(i) = abs(ic(i))
end do
end subroutine u12us

