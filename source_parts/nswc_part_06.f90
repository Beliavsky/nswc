subroutine dbsl (a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer :: ml1, ml2
! ----------------------------------------------------------------------
!
!     dbsl SOLVES THE REAL BAND SYSTEM a*X = b OR TRANS(a)*X = b
!     using the factors computed by dbfa.
!
!                         ----------
!     On entry
!
!        A       DOUBLE PRECISION(lda, NC)
!                the output from dbfa.
!                NC MUST BE .GE. 2*ml+mu+1 .
!
!        lda     INTEGER
!                the leading dimension of the array a.
!
!        n       INTEGER
!                the order of the original matrix.
!
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!
!        ipvt    INTEGER(n)
!                the pivot vector from dbfa.
!
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  a*X = b .
!                = NONZERO   TO SOLVE  TRANS(a)*X = b , WHERE
!                            TRANS(a)  is the transpose.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda.  It will not occur if dbfa and dbsl are
!        CALLED CORRECTLY AND dbfa HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     Subroutines and functions
!      daxpy,ddot
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
integer, intent(in) :: lda, n, ml, mu, job
double precision, intent(in) :: a(lda,*)
double precision, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
double precision :: ddot, t
integer :: k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
!
m = mu + ml + 1
if (m .eq. 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job .ne. 0) go to 50
!
!     job = 0 , SOLVE  a * X = b
!       FIRST SOLVE l*Y = b
!
if (ml .eq. 0) go to 30
do k = 1,nm1
   lm = min0(ml,n-k)
   l = ipvt(k)
   t = b(l)
   if (l .eq. k) go to 10
      b(l) = b(k)
      b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call daxpy(lm, t, a(klm,mlm), ldb, b(k+1), 1)
end do
!
!       NOW SOLVE  U*X = Y
!
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min0(k,m) - 1
   lb = k - lm
   t = -b(k)
   call daxpy(lm, t, a(k-1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       FIRST SOLVE  TRANS(U)*Y = b
!
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min0(k,m) - 1
   lb = k - lm
   t = ddot(lm, a(k-1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml .eq. 0) return
!
!       NOW SOLVE TRANS(l)*X = Y
!
do 70 kb = 1,nm1
   k = n - kb
   lm = min0(ml,n-k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + ddot(lm, a(klm,mlm), ldb, b(k+1), 1)
   l = ipvt(k)
   if (l .eq. k) go to 70
      t = b(l)
      b(l) = b(k)
      b(k) = t
70 continue
return
!
!     CASE WHEN ml = 0 AND mu = 0
!
100 do 110 k = 1,n
110 b(k) = b(k)/a(k,1)
return
end subroutine dbsl

subroutine b1cnd (a, ka, n, ml, mu, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, ml, mu, n
real, intent(out) :: cond
integer :: isgn, iter, iv, ix, j, jump, kase
real :: ainorm, anorm
real :: b1nrm
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a banded matrix a
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,*), wk(*)
integer, intent(inout) :: iwk(*)
!-----------------------
!     real wk(2*n)
!     integer iwk(2*n)
!-----------------------
cond = 0.0
if (n .le. 0 .or. ka .lt. n) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
anorm = b1nrm(a, ka, n, n, ml, mu)
if (anorm .eq. 0.0) go to 40
!
ix = 1
iv = n + 1
isgn = n + 1
!
kase = 0
ainorm = 0.0
call sonest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
call bslv (0, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
!
!     Check if A is singular
!
if (ierr .gt. 0) go to 40
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
10 call sonest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
if (kase .eq. 0) go to 30
if (kase .ne. 1) go to 20
   call bslv (1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
   go to 10
20 call bslv1 (1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
!
!     Compute the value of cond
!
30 cond = anorm*ainorm
return
!
!     Singular case
!
40 ierr = 1
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine b1cnd

subroutine db1cnd (a, ka, n, ml, mu, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, ml, mu, n
integer :: isgn, iter, iv, ix, j, jump, kase
!-----------------------------------------------------------------------
!            Computation of the L1 condition number of
!               a double precision banded matrix a
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
integer, intent(inout) :: iwk(*)
double precision :: anorm, ainorm
double precision :: db1nrm
!-----------------------
!     double precision wk(2*n)
!     integer iwk(2*n)
!-----------------------
cond = 0.d0
if (n .le. 0 .or. ka .lt. n) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
anorm = db1nrm(a, ka, n, n, ml, mu)
if (anorm .eq. 0.d0) go to 40
!
ix = 1
iv = n + 1
isgn = n + 1
!
kase = 0
ainorm = 0.d0
call donest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
call dbslv (0, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
!
!     Check if A is singular
!
if (ierr .gt. 0) go to 40
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
10 call donest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
if (kase .eq. 0) go to 30
if (kase .ne. 1) go to 20
   call dbslv (1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
   go to 10
20 call dbslv1 (1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
!
!     Compute the value of cond
!
30 cond = anorm*ainorm
return
!
!     Singular case
!
40 ierr = 1
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine db1cnd

subroutine cbslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
! ----------------------------------------------------------------------
!     cbslv employs Gauss elimination with row interchanges to solve
!     THE NXN COMPLEX BANDED SYSTEM AX = b. THE ARGUMENT m0 SPECIFIES
!     if cbslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) AN LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     ON SUBSEQUENT CALLS (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED
!     using the decomposition obtained on the initial call to cbslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n AND M.GE.2*ml+mu+1. THE FIRST ml+mu+1
!               columns contain the matrix a in banded form.
!               A is a complex array.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT
!               hand side data.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 IF THE SOLUTION OF AX = b IS OBTAINED.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to cbslv, the routine may be recalled
!     WITH m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT
!     A,ka,n,ml,mu,iwk have not been modified. cbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     cbslv AND SOLVES THE NEW EQUATIONS AX = b. IN THIS CASE ierr
!     is not referenced.
! ----------------------------------------------------------------------
complex, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     Error checking
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     Obtain an LU decomposition of A
!
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call cbsl(a,ka,n,ml,mu,iwk,b,0)
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine cbslv

subroutine cbslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
! ----------------------------------------------------------------------
!     cbslv1 employs Gauss elimination with row interchanges to solve
!     THE NXN COMPLEX BANDED SYSTEM XA = b. THE ARGUMENT m0 SPECIFIES
!     if cbslv1 is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) AN LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     ON SUBSEQUENT CALLS (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED
!     using the decomposition obtained on the initial call to cbslv1.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n AND M.GE.2*ml+mu+1. THE FIRST ml+mu+1
!               columns contain the matrix a in banded form.
!               A is a complex array.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT
!               hand side data.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 IF THE SOLUTION OF XA = b IS OBTAINED.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to cbslv1, the routine may be recalled
!     WITH m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT
!     A,ka,n,ml,mu,iwk have not been modified. cbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     cbslv1 AND SOLVES THE NEW EQUATIONS XA = b. IN THIS CASE ierr
!     is not referenced.
! ----------------------------------------------------------------------
complex, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     Error checking
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     Obtain an LU decomposition of A
!
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call cbsl(a,ka,n,ml,mu,iwk,b,1)
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine cbslv1

subroutine cbfa (a, lda, n, ml, mu, ipvt, info)
implicit none
integer :: i, j, j1, jj, k, l, ldb, ll, lm, lm1, lm2, lmk, m, mb, &
&ml1, mp, n1
integer :: icamax
! ----------------------------------------------------------------------
!
!               cbfa factors a complex band matrix BY elimination.
!
!                              ----------
!     On entry
!
!        A       COMPLEX(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!
!        lda     INTEGER
!                the leading dimension of the array a. It is
!                ASSUMED THAT lda .GE. n.
!
!        n       INTEGER
!                the order of the original matrix.
!
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!                0 .LE. ml .LT. n .
!
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!                0 .LE. mu .LT. n .
!                MORE EFFICIENT IF ml .LE. mu .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                THE FACTORIZATION CAN BE WRITTEN  a = l*U  WHERE
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =k  IF  U(k,k) .EQ. 0. THIS IS NOT AN ERROR
!                condition for this subroutine, but it does
!                indicate that cbsl will divide by zero if
!                it is called.
!
!     Band storage
!
!           If A0 is the matrix THEN the following code will store
!           A0 in band form.
!
!                   ml = (BAND WIDTH BELOW THE DIAGONAL)
!                   mu = (BAND WIDTH ABOVE THE DIAGONAL)
!                   do 20 i = 1, n
!                      j1 = max0(1, i-ml)
!                      j2 = min0(n, i+mu)
!                      do 10 j = j1, j2
!                         k = j - i + ml + 1
!                         a(i,k) = a0(i,j)
!                10    continue
!                20 continue
!
!           This uses columns 1 through  ml + mu + 1  of A.
!           Furthermore, ml additional columns are needed in
!           A (starting with column  ml+mu+2) for elements
!           generated during the triangularization. The total
!           number of columns needed in A is  2*ml+mu+1 .
!
!     Example..  if the original matrix is
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  n = 6, ml = 1, mu = 2, lda .GE. 6  AND A SHOULD CONTAIN
!
!              11 12 13  +     , + = USED FOR PIVOTING
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!
!     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     Subroutines and functions
!        MIN0,icamax,caxpy,cscal,cswap
! ----------------------------------------------------------------------
integer, intent(in) :: lda, n, ml, mu
integer, intent(out) :: info
complex, intent(inout) :: a(lda,*)
integer, intent(inout) :: ipvt(n)
complex :: t
!
info = 0
if (ml .eq. 0) go to 100
m = ml + mu + 1
!
!     Set fill-in columns to zero
!
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = (0.0,0.0)
   end do
end do
!
!     Gaussian elimination with partial pivoting
!
ml1 = ml + 1
mb = ml + mu
n1 = n - 1
ldb = lda - 1
do 40 k = 1,n1
  lm = min0(n-k,ml)
  lmk = lm + k
  lm1 = lm + 1
  lm2 = ml1 - lm
!
!     Search for pivot index
!
  l = -icamax(lm1, a(lmk,lm2), ldb) + lm1 + k
  ipvt(k) = l
  mp = min0(mb,n-k)
!
!     Swap rows if necessary
!
  ll = ml1 + k - l
  if (l .ne. k) call cswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     Skip column reduction if pivot is zero
!
  if (a(k,ml1) .ne. (0.0,0.0)) go to 20
     info = k
     go to 40
!
!     Compute multipliers
!
20 t = (-1.0,0.0)/a(k,ml1)
  call cscal(lm, t, a(lmk,lm2), ldb)
!
!     Row elimination with column indexing
!
  do j = 1,mp
     jj = ml1 + j
     j1 = lm2 + j
     call caxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
  end do
40 continue
!
ipvt(n) = n
if (a(n,ml1) .eq. (0.0,0.0)) info = n
return
!
!     CASE WHEN ml = 0
!
100 do k = 1,n
  ipvt(k) = k
  if (a(k,1) .eq. (0.0,0.0)) info = k
end do
return
end subroutine cbfa

subroutine cbsl (a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer :: ml1, ml2
! ----------------------------------------------------------------------
!
!     cbsl SOLVES THE COMPLEX BAND SYSTEM a*X = b OR TRANS(a)*X = b
!     using the factors computed by cbfa.
!
!                         ----------
!     On entry
!
!        A       COMPLEX(lda, NC)
!                the output from cbfa.
!                NC MUST BE .GE. 2*ml+mu+1 .
!
!        lda     INTEGER
!                the leading dimension of the array a.
!
!        n       INTEGER
!                the order of the original matrix.
!
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!
!        ipvt    INTEGER(n)
!                the pivot vector from cbfa.
!
!        b       COMPLEX(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  a*X = b .
!                = NONZERO   TO SOLVE  TRANS(a)*X = b , WHERE
!                            TRANS(a)  is the transpose.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda.  It will not occur if cbfa and cbsl are
!        CALLED CORRECTLY AND cbfa HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     ADAPTED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     Subroutines and functions
!      caxpy,cdotu
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
integer, intent(in) :: lda, n, ml, mu, job
complex, intent(in) :: a(lda,*)
complex, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
complex :: cdotu, t
integer :: k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
!
m = mu + ml + 1
if (m .eq. 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job .ne. 0) go to 50
!
!     job = 0 , SOLVE  a * X = b
!       FIRST SOLVE l*Y = b
!
if (ml .eq. 0) go to 30
do k = 1,nm1
   lm = min0(ml,n-k)
   l = ipvt(k)
   t = b(l)
   if (l .eq. k) go to 10
      b(l) = b(k)
      b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call caxpy(lm, t, a(klm,mlm), ldb, b(k+1), 1)
end do
!
!       NOW SOLVE  U*X = Y
!
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min0(k,m) - 1
   lb = k - lm
   t = -b(k)
   call caxpy(lm, t, a(k-1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       FIRST SOLVE  TRANS(U)*Y = b
!
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min0(k,m) - 1
   lb = k - lm
   t = cdotu(lm, a(k-1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml .eq. 0) return
!
!       NOW SOLVE TRANS(l)*X = Y
!
do 70 kb = 1, nm1
   k = n - kb
   lm = min0(ml,n-k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + cdotu(lm, a(klm,mlm), ldb, b(k+1), 1)
   l = ipvt(k)
   if (l .eq. k) go to 70
      t = b(l)
      b(l) = b(k)
      b(k) = t
70 continue
return
!
!     CASE WHEN ml = 0 AND mu = 0
!
100 do 110 k = 1,n
110 b(k) = b(k)/a(k,1)
return
end subroutine cbsl

subroutine cvrs (a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
integer :: i, ip, j
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
!
!                 Store the i-TH row
!
ip = 1
do i = 1,m
   ib(i) = ip
   do 10 j = 1,n
      if (a(i,j) .eq. 0.0) go to 10
      if (ip .gt. num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10 continue
end do
!
!                 Complete the setup
!
ib(m + 1) = ip
ierr = 0
return
!
!                   Error return
!
20 ierr = i
return
end subroutine cvrs

subroutine cvds (a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
integer :: i, ip, j
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
!
!                 Store the i-TH row
!
ip = 1
do i = 1,m
   ib(i) = ip
   do 10 j = 1,n
      if (a(i,j) .eq. 0.d0) go to 10
      if (ip .gt. num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10 continue
end do
!
!                 Complete the setup
!
ib(m + 1) = ip
ierr = 0
return
!
!                   Error return
!
20 ierr = i
return
end subroutine cvds

subroutine cvcs (a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
integer :: i, ip, j
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(*)
complex :: zero
integer, intent(inout) :: ib(*), jb(*)
data zero /(0.0,0.0)/
!
!                 Store the i-TH row
!
ip = 1
do i = 1,m
   ib(i) = ip
   do 10 j = 1,n
      if (a(i,j) .eq. zero) go to 10
      if (ip .gt. num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10 continue
end do
!
!                 Complete the setup
!
ib(m + 1) = ip
ierr = 0
return
!
!                   Error return
!
20 ierr = i
return
end subroutine cvcs

subroutine cvsr (a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
integer :: i, ip, ipmax, ipmin, j
real, intent(in) :: a(*)
real, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
!
do 30 i = 1,m
!
!                 Clear the i-TH row
!
   do j = 1,n
      b(i,j) = 0.0
   end do
!
!                 Store the i-TH row
!
   ipmin = ia(i)
   ipmax = ia(i+1) - 1
   if (ipmin .gt. ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
!
30 continue
return
end subroutine cvsr

subroutine cvsd (a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
integer :: i, ip, ipmax, ipmin, j
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
!
do 30 i = 1,m
!
!                 Clear the i-TH row
!
   do j = 1,n
      b(i,j) = 0.d0
   end do
!
!                 Store the i-TH row
!
   ipmin = ia(i)
   ipmax = ia(i+1) - 1
   if (ipmin .gt. ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
!
30 continue
return
end subroutine cvsd

subroutine cvsc (a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
integer :: i, ip, ipmax, ipmin, j
complex, intent(in) :: a(*)
complex, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
!
do 30 i = 1,m
!
!                 Clear the i-TH row
!
   do j = 1,n
      b(i,j) = (0.0,0.0)
   end do
!
!                 Store the i-TH row
!
   ipmin = ia(i)
   ipmax = ia(i+1) - 1
   if (ipmin .gt. ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
!
30 continue
return
end subroutine cvsc

subroutine scvrd (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
real, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) .eq. 0.0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine scvrd

subroutine scvdr (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
double precision, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) .eq. 0.d0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine scvdr

subroutine csreal (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
real :: t
!-----------------------------------------------------------------------
!              Real part of a sparse complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      t = real(a(ip))
      if (t .eq. 0.0) go to 10
      b(l) = t
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine csreal

subroutine csimag (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
real :: t
!-----------------------------------------------------------------------
!            Imaginary part of a sparse complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      t = aimag(a(ip))
      if (t .eq. 0.0) go to 10
      b(l) = t
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine csimag

subroutine scvrc (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!       Compute a + BI for the sparse real matrices A and b
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: wk(n)
complex, intent(inout) :: c(*)
complex :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = 0.0
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      if (b(l) .eq. 0.0) go to 31
      j = jb(l)
      t = cmplx (wk(j), b(l))
      wk(j) = 0.0
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. 0.0) go to 41
      if (ip .gt. num) go to 50
      c(ip) = cmplx (wk(j), 0.0)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine scvrc

subroutine rscopy (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
!-----------------------------------------------------------------------
!                  Copying a sparse real matrix
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) .eq. 0.0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine rscopy

subroutine dscopy (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
!-----------------------------------------------------------------------
!              Copying a sparse double precision matrix
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) .eq. 0.d0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine dscopy

subroutine cscopy (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
!-----------------------------------------------------------------------
!                 Copying a sparse complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
complex :: zero
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
data zero /(0.0,0.0)/
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i+1) - 1
   if (ibeg .gt. iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) .eq. zero) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10 continue
20 continue
ib(m + 1) = l
return
end subroutine cscopy

subroutine sconj (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l, mp1
!-----------------------------------------------------------------------
!     Computation of the conjugate of a sparse complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
mp1 = m + 1
l = ia(1) - 1
do i = 1,mp1
   ib(i) = ia(i) - l
end do
!
ibeg = ia(1)
iend = ia(mp1) - 1
if (ibeg .gt. iend) return
l = 1
do ip = ibeg,iend
   b(l) = conjg(a(ip))
   jb(l) = ja(ip)
   l = l + 1
end do
return
end subroutine sconj

subroutine rpose (a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!                 Transposing a sparse real matrix
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
ipmin = ia(1)
ipmax = ia(m+1) - 1
if (ipmin .gt. ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i+1) - 1
   if (ipmin .gt. ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j+1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j+1) = jp + 1
   end do
31 continue
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
end subroutine rpose

subroutine rpose1 (p, a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ii, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!                 Transposing a sparse real matrix
!                 where the rows are interchanged
!-----------------------------------------------------------------------
integer, intent(in) :: p(m)
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
ipmin = ia(1)
ipmax = ia(m+1) - 1
if (ipmin .gt. ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
   ii = p(i)
   ipmin = ia(ii)
   ipmax = ia(ii+1) - 1
   if (ipmin .gt. ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j+1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j+1) = jp + 1
   end do
31 continue
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
end subroutine rpose1

subroutine dpose (a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!           Transposing a sparse double precision matrix
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
ipmin = ia(1)
ipmax = ia(m+1) - 1
if (ipmin .gt. ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i+1) - 1
   if (ipmin .gt. ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j+1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j+1) = jp + 1
   end do
31 continue
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
end subroutine dpose

subroutine dpose1 (p, a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ii, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!           Transposing a sparse double precision matrix
!                 where the rows are interchanged
!-----------------------------------------------------------------------
integer, intent(in) :: p(m)
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
ipmin = ia(1)
ipmax = ia(m+1) - 1
if (ipmin .gt. ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
   ii = p(i)
   ipmin = ia(ii)
   ipmax = ia(ii+1) - 1
   if (ipmin .gt. ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j+1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j+1) = jp + 1
   end do
31 continue
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
end subroutine dpose1

subroutine cpose (a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!               Transposing a sparse complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
ipmin = ia(1)
ipmax = ia(m+1) - 1
if (ipmin .gt. ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i+1) - 1
   if (ipmin .gt. ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j+1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j+1) = jp + 1
   end do
31 continue
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
end subroutine cpose

subroutine cpose1 (p, a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ii, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!               Transposing a sparse complex matrix
!                 where the rows are interchanged
!-----------------------------------------------------------------------
integer, intent(in) :: p(m)
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
ipmin = ia(1)
ipmax = ia(m+1) - 1
if (ipmin .gt. ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
   ii = p(i)
   ipmin = ia(ii)
   ipmax = ia(ii+1) - 1
   if (ipmin .gt. ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j+1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j+1) = jp + 1
   end do
31 continue
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
end subroutine cpose1

subroutine sadd (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!               Addition of sparse real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*), wk(n)
real :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = 0.0
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = 0.0
      if (t .eq. 0.0) go to 31
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. 0.0) go to 41
      if (ip .gt. num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine sadd

subroutine dsadd (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!         Addition of sparse double precision matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*), wk(n)
double precision :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = 0.d0
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = 0.d0
      if (t .eq. 0.d0) go to 31
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. 0.d0) go to 41
      if (ip .gt. num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.d0
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine dsadd

subroutine csadd (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!              Addition of sparse complex matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(*)
complex, intent(inout) :: c(*), wk(n)
complex :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = (0.0, 0.0)
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = (0.0, 0.0)
      if (t .eq. (0.0, 0.0)) go to 31
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. (0.0, 0.0)) go to 41
      if (ip .gt. num) go to 50
      c(ip) = wk(j)
      wk(j) = (0.0, 0.0)
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine csadd

subroutine ssubt (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!             Subtraction of sparse real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*), wk(n)
real :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = 0.0
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = 0.0
      if (t .eq. 0.0) go to 31
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. 0.0) go to 41
      if (ip .gt. num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine ssubt

subroutine dssubt (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!        Subtraction of sparse double precision matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*), wk(n)
double precision :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = 0.d0
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = 0.d0
      if (t .eq. 0.d0) go to 31
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. 0.d0) go to 41
      if (ip .gt. num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.d0
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine dssubt

subroutine cssubt (a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
integer :: i, ip, j, l, maxa, maxb, mina, minb
!-----------------------------------------------------------------------
!            Subtraction of sparse complex matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(*)
complex, intent(inout) :: c(*), wk(n)
complex :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do j = 1,n
   wk(j) = (0.0, 0.0)
end do
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i+1) - 1
   if (mina .gt. maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i+1) - 1
   if (minb .gt. maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = (0.0, 0.0)
      if (t .eq. (0.0, 0.0)) go to 31
      if (ip .gt. num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31 continue
!
40 if (mina .gt. maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) .eq. (0.0, 0.0)) go to 41
      if (ip .gt. num) go to 50
      c(ip) = wk(j)
      wk(j) = (0.0, 0.0)
      jc(ip) = j
      ip = ip + 1
41 continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
end subroutine cssubt

subroutine sprod (a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, num
integer :: i, ip, j, jp, jpmax, jpmin, k, kp, kpmax, kpmin
!-----------------------------------------------------------------------
!               Multiplication of sparse real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*), wk(n)
real :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do k = 1,n
   wk(k) = 0.0
end do
!
!                     Compute the i-TH row of c
!
ip = 1
do 31 i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i+1) - 1
   if (jpmin .gt. jpmax) go to 31
!
   do 21 jp = jpmin,jpmax
      t = a(jp)
      if (t .eq. 0.0) go to 21
      j = ja(jp)
      kpmin = ib(j)
      kpmax = ib(j+1) - 1
      if (kpmin .gt. kpmax) go to 21
      do kp = kpmin,kpmax
         k = jb(kp)
         wk(k) = wk(k) + t*b(kp)
      end do
21 continue
!
   do 30 k = 1,n
      if (wk(k) .eq. 0.0) go to 30
      if (ip .gt. num) go to 40
      c(ip) = wk(k)
      wk(k) = 0.0
      jc(ip) = k
      ip = ip + 1
30 continue
31 continue
ic(l + 1) = ip
ierr = 0
return
!
!                           Error return
!
40 ierr = i
return
end subroutine sprod

subroutine dsprod (a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, num
integer :: i, ip, j, jp, jpmax, jpmin, k, kp, kpmax, kpmin
!-----------------------------------------------------------------------
!         Multiplication of sparse double precision matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*), wk(n)
double precision :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do k = 1,n
   wk(k) = 0.d0
end do
!
!                     Compute the i-TH row of c
!
ip = 1
do 31 i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i+1) - 1
   if (jpmin .gt. jpmax) go to 31
!
   do 21 jp = jpmin,jpmax
      t = a(jp)
      if (t .eq. 0.d0) go to 21
      j = ja(jp)
      kpmin = ib(j)
      kpmax = ib(j+1) - 1
      if (kpmin .gt. kpmax) go to 21
      do kp = kpmin,kpmax
         k = jb(kp)
         wk(k) = wk(k) + t*b(kp)
      end do
21 continue
!
   do 30 k = 1,n
      if (wk(k) .eq. 0.d0) go to 30
      if (ip .gt. num) go to 40
      c(ip) = wk(k)
      wk(k) = 0.d0
      jc(ip) = k
      ip = ip + 1
30 continue
31 continue
ic(l + 1) = ip
ierr = 0
return
!
!                           Error return
!
40 ierr = i
return
end subroutine dsprod

subroutine csprod (a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, num
integer :: i, ip, j, jp, jpmax, jpmin, k, kp, kpmax, kpmin
!-----------------------------------------------------------------------
!             Multiplication of sparse complex matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(*)
complex, intent(inout) :: c(*), wk(n)
complex :: t
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
!-------------------------
do k = 1,n
   wk(k) = (0.0, 0.0)
end do
!
!                     Compute the i-TH row of c
!
ip = 1
do 31 i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i+1) - 1
   if (jpmin .gt. jpmax) go to 31
!
   do 21 jp = jpmin,jpmax
      t = a(jp)
      if (t .eq. (0.0, 0.0)) go to 21
      j = ja(jp)
      kpmin = ib(j)
      kpmax = ib(j+1) - 1
      if (kpmin .gt. kpmax) go to 21
      do kp = kpmin,kpmax
         k = jb(kp)
         wk(k) = wk(k) + t*b(kp)
      end do
21 continue
!
   do 30 k = 1,n
      if (wk(k) .eq. (0.0, 0.0)) go to 30
      if (ip .gt. num) go to 40
      c(ip) = wk(k)
      wk(k) = (0.0, 0.0)
      jc(ip) = k
      ip = ip + 1
30 continue
31 continue
ic(l + 1) = ip
ierr = 0
return
!
!                           Error return
!
40 ierr = i
return
end subroutine csprod

subroutine mvprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(m)
real :: sum
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   sum = 0.0
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
end subroutine mvprd

subroutine mvprd1 (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!     SET y = a*x + y WHERE A IS A SPARSE MATRIX AND x,y ARE VECTORS
!-----------------------------------------------------------------------
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(m)
real :: sum
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
end subroutine mvprd1

subroutine mtprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
real, intent(in) :: a(*), x(m)
real, intent(inout) :: y(n)
real :: t
integer, intent(in) :: ia(*), ja(*)
!
do j = 1,n
   y(j) = 0.0
end do
!
do 21 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
return
end subroutine mtprd

subroutine mtprd1 (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!     SET y = x*a + y WHERE A IS A SPARSE MATRIX AND x,y ARE VECTORS
!-----------------------------------------------------------------------
real, intent(in) :: a(*), x(m)
real, intent(inout) :: y(n)
real :: t
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
return
end subroutine mtprd1

subroutine dvprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(m)
double precision :: sum
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   sum = 0.d0
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
end subroutine dvprd

subroutine dvprd1 (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!     SET y = a*x + y WHERE A IS A SPARSE MATRIX AND x,y ARE VECTORS
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(m)
double precision :: sum
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
end subroutine dvprd1

subroutine dtprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), x(m)
double precision, intent(inout) :: y(n)
double precision :: t
integer, intent(in) :: ia(*), ja(*)
!
do j = 1,n
   y(j) = 0.d0
end do
!
do 21 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
return
end subroutine dtprd

subroutine dtprd1 (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!     SET y = x*a + y WHERE A IS A SPARSE MATRIX AND x,y ARE VECTORS
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), x(m)
double precision, intent(inout) :: y(n)
double precision :: t
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
return
end subroutine dtprd1

subroutine cvprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), x(n)
complex, intent(inout) :: y(m)
complex :: sum
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   sum = (0.0, 0.0)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
end subroutine cvprd

subroutine cvprd1 (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!     SET y = a*x + y WHERE A IS A SPARSE MATRIX AND x,y ARE VECTORS
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), x(n)
complex, intent(inout) :: y(m)
complex :: sum
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
end subroutine cvprd1

subroutine ctprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), x(m)
complex, intent(inout) :: y(n)
complex :: t
integer, intent(in) :: ia(*), ja(*)
!
do j = 1,n
   y(j) = (0.0, 0.0)
end do
!
do 21 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
return
end subroutine ctprd

subroutine ctprd1 (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!     SET y = x*a + y WHERE A IS A SPARSE MATRIX AND x,y ARE VECTORS
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), x(m)
complex, intent(inout) :: y(n)
complex :: t
integer, intent(in) :: ia(*), ja(*)
!
do 11 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i+1) - 1
   if (lmin .gt. lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
return
end subroutine ctprd1

real function snrm (a, ia, ja, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ip, ipmax, ipmin
real :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                      real sparse matrix a
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
integer, intent(in) :: ia(*), ja(*)
!
snrm = 0.0
do 20 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin .gt. ipmax) go to 20
   sum = 0.0
   do ip = ipmin,ipmax
      sum = sum + abs(a(ip))
   end do
   snrm = amax1(snrm, sum)
20 continue
return
end function snrm

subroutine s1nrm (a, ia, ja, m, n, anorm, wk)
implicit none
integer, intent(in) :: m, n
real, intent(out) :: anorm
integer :: ip, ipmax, ipmin, j
!-----------------------------------------------------------------------
!        Computation of the L1 norm of a real sparse matrix a
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: wk(n)
integer, intent(in) :: ia(*), ja(*)
!
anorm = 0.0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin .gt. ipmax) return
!
!     Compute the L1 norm of A
!
do j = 1,n
   wk(j) = 0.0
end do
!
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + abs(a(ip))
end do
!
do j = 1,n
   anorm = amax1(anorm,wk(j))
end do
return
end subroutine s1nrm

double precision function dsnrm (a, ia, ja, m, n)
implicit none
integer, intent(in) :: m, n
integer :: i, ip, ipmax, ipmin
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                double precision sparse matrix a
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision :: sum
integer, intent(in) :: ia(*), ja(*)
!
dsnrm = 0.d0
do 20 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin .gt. ipmax) go to 20
   sum = 0.d0
   do ip = ipmin,ipmax
      sum = sum + dabs(a(ip))
   end do
   dsnrm = dmax1(dsnrm, sum)
20 continue
return
end function dsnrm

subroutine ds1nrm (a, ia, ja, m, n, anorm, wk)
implicit none
integer, intent(in) :: m, n
integer :: ip, ipmax, ipmin, j
!-----------------------------------------------------------------------
!               Computation of the L1 norm of a sparse
!                     double precision matrix a
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(out) :: anorm
double precision, intent(inout) :: wk(n)
integer, intent(in) :: ia(*), ja(*)
!
anorm = 0.d0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin .gt. ipmax) return
!
!     Compute the L1 norm of A
!
do j = 1,n
   wk(j) = 0.d0
end do
!
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + dabs(a(ip))
end do
!
do j = 1,n
   anorm = dmax1(anorm,wk(j))
end do
return
end subroutine ds1nrm

subroutine spord (m, n, ia, r, iwk)
implicit none
integer, intent(in) :: m, n
integer :: i, ii, k, l, np1, num
!-----------------------------------------------------------------------
!        spord orders the rows of an MXN sparse matrix A,ia,JA
!        by increasing length. The row ordering is given in r.
!-----------------------------------------------------------------------
!     iwk is a work space of dimension m + n + 1.
!----------------------
integer, intent(in) :: ia(*)
integer, intent(inout) :: r(m), iwk(*)
!
np1 = n + 1
do i = 1,np1
   iwk(i) = 0
end do
!
i = m
do ii = 1,m
   num = ia(i+1) - ia(i) + 1
   l = np1 + i
   iwk(l) = iwk(num)
   iwk(num) = i
   i = i - 1
end do
!
num = 1
k = iwk(num)
do i = 1,m
30 if (k .ne. 0) go to 31
      num = num + 1
      k = iwk(num)
      go to 30
31 r(i) = k
   l = np1 + k
   k = iwk(l)
end do
return
end subroutine spord

subroutine blkord (n, ia, ja, r, c, ib, num, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer :: n
integer, intent(inout) :: num
integer :: i, length, li, np1, npi
!-----------------------------------------------------------------------
!        Reordering a sparse matrix into block triangular form
!-----------------------------------------------------------------------
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: r(n), c(n), ib(n)
!     integer iwk(5*n)
integer, intent(inout) :: iwk(*)
!
np1 = n + 1
length = ia(np1) - ia(1)
do i = 1,n
   iwk(i) = ia(i+1) - ia(i)
end do
call mc21a(n,ja,length,ia,iwk(1),r,num,iwk(np1))
ierr = n - num
if (ierr .ne. 0) return
!
do i = 1,n
   li = r(i)
   iwk(i) = ia(li)
   npi = n + i
   iwk(npi) = ia(li+1) - ia(li)
end do
call mc13d(n,ja,length,iwk(1),iwk(np1),c,ib,num,iwk(2*n+1))
!
do i = 1,n
   li = c(i)
   iwk(i) = r(li)
end do
do i = 1,n
   r(i) = iwk(i)
end do
return
end subroutine blkord

subroutine mc21a (n,icn,licn,ip,lenr,iperm,numnz,iw)
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: numnz
!-----------------------------------------------------------------------
! Description of parameters.
! INPUT VARIABLES   n,icn,licn,ip,lenr
! output variables  iperm,numnz
!
! n   ORDER OF MATRIX.
! icn array containing the column indices of the non-zeros.  Those
!     belonging to a single row must be contiguous but the ordering
!     of column indices within each row is unimportant and wasted
!     space between rows is permitted.
! licn  length of array icn.
! ip  ip(I), I=1,2,...n, IS THE POSITION IN ARRAY icn OF THE FIRST
!     column index of a non-zero in row I.
! lenr  lenr(I) IS THE NUMBER OF NON-ZEROS IN ROW I, I=1,2,..n.
! iperm contains permutation to make diagonal have the smallest
!     NUMBER OF ZEROS ON IT.  ELEMENTS (iperm(I),I) I=1, ... n ARE
!     non-zero at the end of the algorithm unless matrix
!     is structurally singular.  In this case, (iperm(I),I) will
!     be zero for n-numnz entries.
! numnz number of non-zeros on diagonal of permuted matrix.
! iw  work array  ..  see later comments.
!-----------------------------------------------------------------------
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), iw(n,4)
!
call mc21b (n,icn,licn,ip,lenr,iperm,numnz,iw(1,1),iw(1,2), &
&iw(1,3),iw(1,4))
return
end subroutine mc21a

subroutine mc21b (n,icn,licn,ip,lenr,iperm,numnz,pr,arp,cv,out)
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: numnz
integer :: i, ii, in1, in2, ioutk, j, j1, jord, k, kk
!-----------------------------------------------------------------------
!     Division of work array is now described.
!
! pr(i) is the previous row to i in the depth first search.
! arp(i) is one less than the number of non-zeros in row i
!     which have not been scanned when looking for a cheap assignment.
! cv(i) is the most recent row extension at which column i
!     was visited.
! out(i) is one less than the number of non-zeros in row i
!     which have not been scanned during one pass through the
!     main loop.
!-----------------------------------------------------------------------
integer, intent(in) :: ip(n), icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), pr(n), cv(n), arp(n), out(n)
!
!     Initialization of arrays
!
do i = 1,n
   arp(i) = lenr(i) - 1
   cv(i) = 0
   iperm(i) = 0
end do
numnz = 0
!
!     Main loop.
!     Each pass round this loop either results in a new assignment
!     or gives a row with no assignment.
!
do 130 jord = 1,n
j = jord
pr(j) = -1
do 100 k = 1,jord
!
!     Look for a cheap assignment
!
in1 = arp(j)
if (in1 .lt. 0) go to 60
in2 = ip(j) + lenr(j) - 1
in1 = in2 - in1
do ii = in1,in2
   i = icn(ii)
   if (iperm(i) .eq. 0) go to 110
end do
!
!     No cheap assignment in row
!
arp(j) = -1
!
!     Begin looking for assignment chain starting with row j
!
60 out(j) = lenr(j) - 1
!
!     Inner loop.  Extends chain by one or backtracks.
!
do kk = 1,jord
   in1 = out(j)
   if (in1 .lt. 0) go to 80
   in2 = ip(j) + lenr(j) - 1
   in1 = in2 - in1
!
!        Forward scan
!
   do 70 ii = in1,in2
      i = icn(ii)
      if (cv(i) .eq. jord) go to 70
!
!           Column i has not yet been accessed during this pass
!
      j1 = j
      j = iperm(i)
      cv(i) = jord
      pr(j) = j1
      out(j1) = in2 - ii - 1
      go to 100
70 continue
!
!        Backtracking step
!
80 j = pr(j)
   if (j .eq. -1) go to 130
end do
!
100 continue
!
!     New assignment is made
!
110 iperm(i) = j
arp(j) = in2 - ii - 1
numnz = numnz + 1
do k = 1,jord
   j = pr(j)
   if (j .eq. -1) go to 130
   ii = ip(j) + lenr(j) - out(j) - 2
   i = icn(ii)
   iperm(i) = j
end do
!
130 continue
!
!     If matrix is structurally singular, we now complete the
!     permutation iperm.
!
if (numnz .eq. n) go to 500
do i = 1,n
   arp(i) = 0
end do
k = 0
do 160 i = 1,n
   if (iperm(i) .ne. 0) go to 150
      k = k + 1
      out(k) = i
      go to 160
150 j = iperm(i)
   arp(j) = i
160 continue
k = 0
do 170 i = 1,n
   if (arp(i) .ne. 0) go to 170
   k = k + 1
   ioutk = out(k)
   iperm(ioutk) = i
170 continue
500 return
end subroutine mc21b

subroutine mc13d(n, icn, licn, ip, lenr, ior, ib, num, iw)
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: num
!
! Description of parameters.
! Input variables  .... n,icn,licn,ip,lenr.
! Output variables  ior,ib,num.
!
! n   ORDER OF THE MATRIX.
! icn array containing the column indices of the non-zeros.  Those
!     belonging to a single row must be contiguous but the ordering
!     of column indices within each row is unimportant and wasted
!     space between rows is permitted.
! licn  length of array icn.
! ip  ip(I), I=1,2,...n, IS THE POSITION IN ARRAY icn OF THE FIRST
!     column index of a non-zero in row I.
! lenr  lenr(I) IS THE NUMBER OF NON-ZEROS IN ROW I, I=1,2,...n.
! ior  ior(I) gives the position in the original ordering of the row
!     OR COLUMN WHICH IS IN POSITION I IN THE PERMUTED FORM, I=1,2,..n.
! ib  ib(I) is the row number in the permuted matrix of the beginning
!     OF BLOCK I, I=1,2,...num.
! num number of blocks found.
! iw  work array of length 3*n.
!
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: ior(n), ib(n), iw(n,3)
!
call mc13e(n, icn, licn, ip, lenr, ior, ib, num, iw(1,1), &
&iw(1,2), iw(1,3))
return
end subroutine mc13d

subroutine mc13e(n, icn, licn, ip, lenr, arp, ib, num, lowl, &
&numb, prev)
implicit none
integer, intent(in) :: licn, n
integer, intent(out) :: num
integer :: i, i1, i2, icnt, ii, isn, ist, ist1, iv, iw, j, k, &
&lcnt, nnm1
integer :: stp, dummy
integer, intent(in) :: ip(n)
!
! arp(i) is one less than the number of unsearched edges leaving
!     node i.  At the end of the algorithm it is set to A
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
!
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: arp(n), ib(n), lowl(n), numb(n), prev(n)
!
!   icnt is the number of nodes whose positions in final ordering have
!     been found.
!
icnt = 0
! num is the number of blocks that have been found.
num = 0
nnm1 = n + n - 1
!
! Initialization of arrays.
!
do j=1,n
  numb(j) = 0
  arp(j) = lenr(j) - 1
end do
!
!
do 90 isn = 1,n
! Look for a starting node
  if (numb(isn).ne.0) go to 90
  iv = isn
! ist is the number of nodes on the stack ... it is the stack pointer.
  ist = 1
! Put node iv at beginning of stack.
  lowl(iv) = 1
  numb(iv) = 1
  ib(n) = iv
!
! The body of this loop puts a new node on the stack or backtracks.
!
  do 80 dummy = 1,nnm1
    i1 = arp(iv)
! Have all edges leaving node iv been searched.
    if (i1.lt.0) go to 30
    i2 = ip(iv) + lenr(iv) - 1
    i1 = i2 - i1
!
! Look at edges leaving node iv until one enters a new node or
!     all edges are exhausted.
!
    do ii=i1,i2
      iw = icn(ii)
! Has node iw been on stack already.
      if (numb(iw).eq.0) go to 70
! Update value of lowl(iv) if necessary.
      if (lowl(iw).lt.lowl(iv)) lowl(iv) = lowl(iw)
    end do
!
! There are no more edges leaving node iv.
!
    arp(iv) = -1
! Is node iv the root of a block.
30 if (lowl(iv).lt.numb(iv)) go to 60
!
! Order nodes in a block.
!
    num = num + 1
    ist1 = n + 1 - ist
    lcnt = icnt + 1
!
! Peel block off the top of the stack starting at the top and
!     working down to the root of the block.
!
    do stp=ist1,n
      iw = ib(stp)
      lowl(iw) = n + 1
      icnt = icnt + 1
      numb(iw) = icnt
      if (iw.eq.iv) go to 50
    end do
50 ist = n - stp
    ib(num) = lcnt
! Are there any nodes left on the stack.
    if (ist.ne.0) go to 60
! Have all the nodes been ordered.
    if (icnt.lt.n) go to 90
    go to 100
!
! Backtrack to previous node on path.
!
60 iw = iv
    iv = prev(iv)
! Update value of lowl(iv) if necessary.
    if (lowl(iw).lt.lowl(iv)) lowl(iv) = lowl(iw)
    go to 80
!
! Put new node on the stack.
!
70 arp(iv) = i2 - ii - 1
    prev(iw) = iv
    iv = iw
    ist = ist + 1
    lowl(iv) = ist
    numb(iv) = ist
    k = n + 1 - ist
    ib(k) = iv
80 continue
!
90 continue
!
! Put permutation in the required form.
!
100 do i=1,n
  ii = numb(i)
  arp(ii) = i
end do
return
end subroutine mc13e

subroutine spslv (n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
integer :: k, l
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!  spslv calls nspiv1 which uses sparse Gaussian elimination with
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A x = b.  THE
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  The solution
!  PHASE SOLVES u x = y.
!
!  Input arguments---
!
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
!         actual nonzeros.  (See matrix storage description below)
!
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!
!  b      REAL ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., The elimination order for the equations)
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!
!  rtemp  real array of n + max entries for internal use
!
!
!  Output arguments---
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!
!  x      REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!
!         ierr values are---
!
!         0 LT ierr             SUCCESSFUL COMPLETION. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!
!         ierr = 0              ERROR.  n IS LESS THAN OR EQUAL TO 0
!
!         -n LE ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!
!         -2*n LE ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!
!         -3*n LE ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!
!         -4*n LE ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., If the nonzero stored in a(k) is in
!  COLUMN J, THEN ja(k) = J).  THE ARRAY ia CONTAINS POINTERS TO THE
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) IS SET SO THAT ia(n+1) - ia(1) = THE NUMBER OF NONZERO
!  elements in A.
!------------------------
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: iu, ju, u, y, p
!
ierr = 0
if (n .le. 0) return
!
!  Set indices to divide temporary storage for nspiv1
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  Compute the inverse permutation of c
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL nspiv1 TO PERFORM COMPUTATIONS
!
call nspiv1 (n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
&itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr .eq. 0) ierr = 1
return
end subroutine spslv

subroutine nspiv1 (n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, &
&nzcnt
!
!
!  nspiv1 uses sparse Gaussian elimination with
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A x = b.  THE
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  The solution
!  PHASE SOLVES u x = y.
!
!
!  See spslv for descriptions of all input and output arguments
!  other than those described below
!
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic IS BOTH AN INPUT AND OUTPUT
!      argument.
!
!  Input arguments (used internally only)---
!
!  y   REAL ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!
!  u   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., If the nonzero stored in a(k) is in
!  COLUMN j, THEN ja(k) = j).  THE ARRAY ia CONTAINS POINTERS TO THE
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) IS SET SO THAT ia(n+1) - ia(1) = THE NUMBER OF NONZEROS IN
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!
!
real, intent(in) :: a(*), b(n)
real, intent(inout) :: u(max), x(n), y(n)
real :: dk, lki, xpv, xpvmax, yk
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
integer :: ck, pk, ppk, pv, v, vi, vj, vk
!
!  Initialize work storage and pointers to ju
!
do j = 1,n
  x(j) = 0.0
end do
iu(1) = 1
juptr = 0
!
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
!
do 170 k = 1,n
!
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
!
  p(n+1) = n+1
  vk = r(k)
!
!  Set up adjacency list for vk, ordered in
!  current column order of u.  The loop index
!  goes downward to exploit any columns
!  from A in correct relative order
!
  jmin = ia(vk)
  jmax = ia(vk+1) - 1
  if (jmin .gt. jmax)  go to 1002
  j = jmax
20 jaj = ja(j)
    vj = ic(jaj)
!
!  Store a(k,j) in work vector
!
    x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
    ppk = n+1
30 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  30,1003,40
40 p(vj) = ppk
    p(pk) = vj
    j = j - 1
    if (j .ge. jmin) go to 20
!
!  The following code computes the k-TH row of u
!
  vi = n+1
  yk = b(vk)
50 vi = p(vi)
  if (vi .ge. k) go to 110
!
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
!
  lki = - x(vi)
  x(vi) = 0.0
!
!  Adjust right hand side to reflect elimination
!
  yk = yk + lki * y(vi)
  ppk = vi
  jmin = iu(vi)
  jmax = iu(vi+1) - 1
  if (jmin .gt. jmax)  go to 50
  do j = jmin,jmax
    juj = ju(j)
    vj = ic(juj)
!
!  If vj is already in the adjacency of vk,
!  skip the insertion
!
    if (x(vj) .ne. 0.0)  go to 90
!
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
!
    if (vj - ppk) 60,90,70
60 ppk = vi
70 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  70,90,80
80 p(vj) = ppk
    p(pk) = vj
    ppk = vj
!
!  COMPUTE L(k,j) = L(k,j) - L(k,i)*u(i,j) FOR L(k,i) NONZERO
!  COMPUTE u*(k,j) = u*(k,j) - L(k,i)*u(i,j) FOR u(k,j) NONZERO
!  (u*(k,j) = u(k,j)*D(k,k))
!
90 x(vj) = x(vj) + lki * u(j)
  end do
  go to 50
!
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!
!  Find largest entry, counting off-diagonal nonzeros
!
110 if (vi .gt. n) go to 1004
  xpvmax = abs(x(vi))
  maxc = vi
  nzcnt = 0
  pv = vi
120 v = pv
    pv = p(pv)
    if (pv .gt. n) go to 130
    nzcnt = nzcnt + 1
    xpv = abs(x(pv))
    if (xpv .le. xpvmax) go to 120
    xpvmax = xpv
    maxc = pv
    maxcl = v
    go to 120
130 if (xpvmax .eq. 0.0) go to 1004
!
!  IF vi = k, THEN THERE IS AN ENTRY FOR DIAGONAL
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
!
  if (vi .eq. k) go to 140
  if (vi .eq. maxc) go to 140
  p(maxcl) = p(maxc)
  go to 150
140 vi = p(vi)
!
!  COMPUTE D(k) = 1/L(k,k) AND PERFORM INTERCHANGE.
!
150 dk = 1.0 / x(maxc)
  x(maxc) = x(k)
  i = c(k)
  c(k) = c(maxc)
  c(maxc) = i
  ck = c(k)
  ic(ck) = k
  ic(i) = maxc
  x(k) = 0.0
!
!  Update right hand side.
!
  y(k) = yk * dk
!
!  Compute value for iu(k+1) and check for storage overflow
!
  iu(k+1) = iu(k) + nzcnt
  if (iu(k+1) .gt. max+1) go to 1005
!
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
!
  if (vi .gt. n)  go to 170
  j = vi
160 juptr = juptr + 1
    ju(juptr) = c(j)
    u(juptr) = x(j) * dk
    x(j) = 0.0
    j = p(j)
    if (j .le. n) go to 160
170 continue
!
!  BACKSOLVE u x = y, AND REORDER x TO CORRESPOND WITH A
!
k = n
do i = 1,n
  yk = y(k)
  jmin = iu(k)
  jmax = iu(k+1) - 1
  if (jmin .gt. jmax)  go to 190
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
!
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
!
ierr = iu(n+1) - iu(1)
return
!
!  Error returns
!
!  Row k of A is null
!
1002 ierr = -k
return
!
!  Row k of A has a duplicate entry
!
1003 ierr = -(n+k)
return
!
!  Zero pivot in row k
!
1004 ierr = -(2*n+k)
return
!
!  Storage for u exceeded on row k
!
1005 ierr = -(3*n+k)
return
end subroutine nspiv1

subroutine rslv (m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
integer :: it, iu, jt, k, l
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!     rslv employs Gaussian elimination with column interchanges to
!     SOLVE THE NXN LINEAR SYSTEM AX = b. THE ARGUMENT m0 SPECIFIES
!     if rslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) THE LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     obtained on the initial call to rslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the matrix a stored in sparse form.
!
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = b IS OBTAINED THEN ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              ENTRIES OF l AND U. OTHERWISE ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to rslv, the routine may be recalled with
!     m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to rslv
!     AND SOLVES THE NEW EQUATIONS AX = b. IN THIS CASE A,ia,ja,MAX,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call splu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call rslv1 (n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
&b,x,wk(y))
return
end subroutine rslv

subroutine rslv1 (n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, jmax, jmin, k, lj, lk
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
real :: sum
!
!            SOLVE LY = b BY FORWARD SUBSTITUTION
!
do 11 k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin .gt. jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
!
!            SOLVE UX = b BY BACKWARD SUBSTITUTION
!             and reorder x to correspond with A
!
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k+1) - 1
   if (jmin .gt. jmax) go to 21
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
return
end subroutine rslv1

subroutine tslv (m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
integer :: it, iu, jt, k, l
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!     tslv employs Gaussian elimination with column interchanges to
!     SOLVE THE NXN LINEAR SYSTEM XA = b. THE ARGUMENT m0 SPECIFIES
!     if tslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) THE LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     obtained on the initial call to tslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the matrix a stored in sparse form.
!
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = b IS OBTAINED THEN ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              ENTRIES OF l AND U. OTHERWISE ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to tslv, the routine may be recalled with
!     m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to tslv
!     AND SOLVES THE NEW EQUATIONS XA = b. IN THIS CASE A,ia,ja,MAX,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call splu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call tslv1 (n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
&b,x,wk(y))
return
end subroutine tslv

subroutine tslv1 (n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, jmax, jmin, k, lj, lk
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
!
!            SOLVE YU = b BY FORWARD SUBSTITUTION
!
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
!
do 21 k = 1,n
   if (y(k) .eq. 0.0) go to 21
   jmin = iu(k)
   jmax = it(k+1) - 1
   if (jmin .gt. jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
!
!            SOLVE XL = y BY BACKWARD SUBSTITUTION
!
x(n) = y(n)/d(n)
if (n .eq. 1) return
!
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin .gt. jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
!
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
return
end subroutine tslv1

subroutine splu (a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, &
&maxil
!-----------------------------------------------------------------------
!     splu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a real sparse matrix.
!     U is a unit upper triangular matrix.
!
!
!     Input arguments ---
!
!     A,ia,ja  the sparse matrix to be decomposed.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic IS ALSO AN OUTPUT ARGUMENT.
!
!     n        ORDER OF THE MATRIX a.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!
!
!     Output arguments ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!
!     d        REAL ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. FOR i = 1,...,n THE OFF-DIAGONAL NONZERO ELEMENTS
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., For each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU DECOMPOSITION IS OBTAINED THEN ierr = THE NUMBER
!              of off-diagonal entries of L and U which were stored
!              in t. Otherwise ierr is assigned a negative value.
!
!
!     Work spaces ---
!
!     w        REAL ARRAY OF DIMENSION n.
!
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
integer :: pm
real :: const, wi, wmax
!
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.0
end do
!
!     Perform the LU factorization of the r(k)-TH row of A
!
do 100 k = 1,n
lk = r(k)
jmin = ia(lk)
jmax = ia(lk+1) - 1
if (jmin .gt. jmax) go to 200
!
!     Set p to the reordered row of A
!
p(n+1) = n + 1
jj = jmax
20 lj = ja(jj)
j = ic(lj)
w(j) = a(jj)
pm = n + 1
21 m = pm
pm = p(m)
if (pm - j) 21,210,22
22 p(m) = j
p(j) = pm
jj = jj - 1
if (jj .ge. jmin) go to 20
!
!     Process the entries in the lower triangle of A
!
i = n + 1
30 i = p(i)
if (i .ge. k) go to 50
if (w(i) .eq. 0.0) go to 30
!
!     L(k,i) is nonzero. Therefore store it in L.
!
jptr = jptr + 1
if (jptr .gt. max) go to 230
const = w(i)
t(jptr) = const
jt(jptr) = c(i)
w(i) = 0.0
!
!     Perform elimination using the i-TH row of U
!
jmin = iu(i)
jmax = it(i+1) - 1
if (jmin .gt. jmax) go to 30
pm = i
do 43 jj = jmin,jmax
   lj = jt(jj)
   j = ic(lj)
   if (w(j) .ne. 0.0) go to 43
   if (j - pm) 40,43,41
40 pm = i
41 m = pm
      pm = p(m)
      if (pm - j) 41,43,42
42 p(m) = j
      p(j) = pm
      pm = j
43 w(j) = w(j) - const*t(jj)
go to 30
!
!     Search for the k-TH pivot element
!
50 if (i .gt. n) go to 220
wmax = abs(w(i))
maxi = i
pm = i
51 m = pm
pm = p(m)
if (pm .gt. n) go to 60
wi = abs(w(pm))
if (wi .le. wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!
!     Store the pivot in d
!
60 if (wmax .eq. 0.0) go to 220
d(k) = w(maxi)
!
!     Perform the column interchange
!
if (i .eq. k) go to 70
if (i .eq. maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
!
80 w(maxi) = w(k)
w(k) = 0.0
lk = c(k)
ll = c(maxi)
c(k) = ll
c(maxi) = lk
ic(lk) = maxi
ic(ll) = k
!
!     The remaining elements of p form the k-TH row of U
!
iu(k) = jptr + 1
90 if (i .gt. n) go to 100
if (w(i) .eq. 0.0) go to 91
   jptr = jptr + 1
   if (jptr .gt. max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = 0.0
91 i = p(i)
go to 90
!
!     Prepare for the next row
!
100 it(k+1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- Error return --------------------
!
!     Row r(k) is null
!
200 ierr = -k
return
!
!     Row r(k) has a duplicate entry
!
210 ierr = -(n + k)
return
!
!     Zero pivot in row r(k)
!
220 ierr = -(2*n + k)
return
!
!     Storage for L and U exceeded on row r(k)
!
230 ierr = -(3*n + k)
return
end subroutine splu

subroutine dspslv (n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
integer :: k, l
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!  dspslv calls dnspiv which uses sparse Gaussian elimination with
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A x = b.  THE
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  The solution
!  PHASE SOLVES u x = y.
!
!  Input arguments---
!
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      DOUBLE PRECISION ARRAY WITH ONE ENTRY PER NONZERO IN A,
!         containing the actual nonzeros. (See the matrix storage
!         description below)
!
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!
!  b      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE RIGHT
!         hand side data
!
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., The elimination order for the equations)
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!
!  rtemp  double precision array of n + max entries for internal use
!
!
!  Output arguments---
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!
!  x      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!         solution vector
!
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!
!         ierr values are---
!
!         0 LT ierr             SUCCESSFUL COMPLETION. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!
!         ierr = 0              ERROR.  n IS LESS THAN OR EQUAL TO 0
!
!         -n LE ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!
!         -2*n LE ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!
!         -3*n LE ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!
!         -4*n LE ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., If the nonzero stored in a(k) is in
!  COLUMN J, THEN ja(k) = J).  THE ARRAY ia CONTAINS POINTERS TO THE
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) IS SET SO THAT ia(n+1) - ia(1) = THE NUMBER OF NONZERO
!  elements in A.
!------------------------
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: iu, ju, u, y, p
!
ierr = 0
if (n .le. 0) return
!
!  Set indices to divide temporary storage for dnspiv
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  Compute the inverse permutation of c
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL dnspiv TO PERFORM COMPUTATIONS
!
call dnspiv (n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
&itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr .eq. 0) ierr = 1
return
end subroutine dspslv

subroutine dnspiv (n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, &
&nzcnt
!
!
!  dnspiv uses sparse Gaussian elimination with
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A x = b.  THE
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  The solution
!  PHASE SOLVES u x = y.
!
!
!  See dspslv for descriptions of all input and output arguments
!  other than those described below
!
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic IS BOTH AN INPUT AND OUTPUT
!      argument.
!
!  Input arguments (used internally only)---
!
!  y   DOUBLE PRECISION ARRAY OF n ENTRIES USED TO COMPUTE
!      the updated right hand side
!
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!
!  u   DOUBLE PRECISION ARRAY OF MAX ENTRIES USED FOR THE ACTUAL
!      nonzeros in the strict upper triangle of u. (See matrix
!      storage description below)
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., If the nonzero stored in a(k) is in
!  COLUMN j, THEN ja(k) = j).  THE ARRAY ia CONTAINS POINTERS TO THE
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) IS SET SO THAT ia(n+1) - ia(1) = THE NUMBER OF NONZEROS IN
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!
!
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: u(max), x(n), y(n)
double precision :: dk, lki, xpv, xpvmax, yk
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
integer :: ck, pk, ppk, pv, v, vi, vj, vk
!
!  Initialize work storage and pointers to ju
!
do j = 1,n
  x(j) = 0.d0
end do
iu(1) = 1
juptr = 0
!
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
!
do 170 k = 1,n
!
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
!
  p(n+1) = n+1
  vk = r(k)
!
!  Set up adjacency list for vk, ordered in
!  current column order of u.  The loop index
!  goes downward to exploit any columns
!  from A in correct relative order
!
  jmin = ia(vk)
  jmax = ia(vk+1) - 1
  if (jmin .gt. jmax)  go to 1002
  j = jmax
20 jaj = ja(j)
    vj = ic(jaj)
!
!  Store a(k,j) in work vector
!
    x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
    ppk = n+1
30 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  30,1003,40
40 p(vj) = ppk
    p(pk) = vj
    j = j - 1
    if (j .ge. jmin) go to 20
!
!  The following code computes the k-TH row of u
!
  vi = n+1
  yk = b(vk)
50 vi = p(vi)
  if (vi .ge. k) go to 110
!
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
!
  lki = - x(vi)
  x(vi) = 0.d0
!
!  Adjust right hand side to reflect elimination
!
  yk = yk + lki * y(vi)
  ppk = vi
  jmin = iu(vi)
  jmax = iu(vi+1) - 1
  if (jmin .gt. jmax)  go to 50
  do j = jmin,jmax
    juj = ju(j)
    vj = ic(juj)
!
!  If vj is already in the adjacency of vk,
!  skip the insertion
!
    if (x(vj) .ne. 0.d0)  go to 90
!
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
!
    if (vj - ppk) 60,90,70
60 ppk = vi
70 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  70,90,80
80 p(vj) = ppk
    p(pk) = vj
    ppk = vj
!
!  COMPUTE L(k,j) = L(k,j) - L(k,i)*u(i,j) FOR L(k,i) NONZERO
!  COMPUTE u*(k,j) = u*(k,j) - L(k,i)*u(i,j) FOR u(k,j) NONZERO
!  (u*(k,j) = u(k,j)*D(k,k))
!
90 x(vj) = x(vj) + lki * u(j)
  end do
  go to 50
!
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!
!  Find largest entry, counting off-diagonal nonzeros
!
110 if (vi .gt. n) go to 1004
  xpvmax = dabs(x(vi))
  maxc = vi
  nzcnt = 0
  pv = vi
120 v = pv
    pv = p(pv)
    if (pv .gt. n) go to 130
    nzcnt = nzcnt + 1
    xpv = dabs(x(pv))
    if (xpv .le. xpvmax) go to 120
    xpvmax = xpv
    maxc = pv
    maxcl = v
    go to 120
130 if (xpvmax .eq. 0.d0) go to 1004
!
!  IF vi = k, THEN THERE IS AN ENTRY FOR DIAGONAL
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
!
  if (vi .eq. k) go to 140
  if (vi .eq. maxc) go to 140
  p(maxcl) = p(maxc)
  go to 150
140 vi = p(vi)
!
!  COMPUTE D(k) = 1/L(k,k) AND PERFORM INTERCHANGE.
!
150 dk = 1.d0 / x(maxc)
  x(maxc) = x(k)
  i = c(k)
  c(k) = c(maxc)
  c(maxc) = i
  ck = c(k)
  ic(ck) = k
  ic(i) = maxc
  x(k) = 0.d0
!
!  Update right hand side.
!
  y(k) = yk * dk
!
!  Compute value for iu(k+1) and check for storage overflow
!
  iu(k+1) = iu(k) + nzcnt
  if (iu(k+1) .gt. max+1) go to 1005
!
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
!
  if (vi .gt. n)  go to 170
  j = vi
160 juptr = juptr + 1
    ju(juptr) = c(j)
    u(juptr) = x(j) * dk
    x(j) = 0.d0
    j = p(j)
    if (j .le. n) go to 160
170 continue
!
!  BACKSOLVE u x = y, AND REORDER x TO CORRESPOND WITH A
!
k = n
do i = 1,n
  yk = y(k)
  jmin = iu(k)
  jmax = iu(k+1) - 1
  if (jmin .gt. jmax)  go to 190
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
!
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
!
ierr = iu(n+1) - iu(1)
return
!
!  Error returns
!
!  Row k of A is null
!
1002 ierr = -k
return
!
!  Row k of A has a duplicate entry
!
1003 ierr = -(n+k)
return
!
!  Zero pivot in row k
!
1004 ierr = -(2*n+k)
return
!
!  Storage for u exceeded on row k
!
1005 ierr = -(3*n+k)
return
end subroutine dnspiv

subroutine dslv (m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
integer :: it, iu, jt, k, l
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!     dslv employs Gaussian elimination with column interchanges to
!     SOLVE THE NXN LINEAR SYSTEM AX = b. THE ARGUMENT m0 SPECIFIES
!     if dslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) THE LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     obtained on the initial call to dslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the double precision matrix a stored in sparse form.
!
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = b IS OBTAINED THEN ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              ENTRIES OF l AND U. OTHERWISE ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to dslv, the routine may be recalled with
!     m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dslv
!     AND SOLVES THE NEW EQUATIONS AX = b. IN THIS CASE A,ia,ja,MAX,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call dsplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call dslv1 (n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
&b,x,wk(y))
return
end subroutine dslv

subroutine dslv1 (n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, jmax, jmin, k, lj, lk
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
double precision :: sum
!
!            SOLVE LY = b BY FORWARD SUBSTITUTION
!
do 11 k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin .gt. jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
!
!            SOLVE UX = b BY BACKWARD SUBSTITUTION
!             and reorder x to correspond with A
!
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k+1) - 1
   if (jmin .gt. jmax) go to 21
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
return
end subroutine dslv1

subroutine dtslv (m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
integer :: it, iu, jt, k, l
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!     dtslv employs Gaussian elimination with column interchanges to
!     SOLVE THE NXN LINEAR SYSTEM XA = b. THE ARGUMENT m0 SPECIFIES
!     if dtslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) THE LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     obtained on the initial call to dtslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the double precision matrix a stored in sparse form.
!
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = b IS OBTAINED THEN ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              ENTRIES OF l AND U. OTHERWISE ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to dtslv, the routine may be recalled with
!     m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dtslv
!     AND SOLVES THE NEW EQUATIONS XA = b. IN THIS CASE A,ia,ja,MAX,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call dsplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call dtslv1 (n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
&b,x,wk(y))
return
end subroutine dtslv

subroutine dtslv1 (n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, jmax, jmin, k, lj, lk
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
!
!            SOLVE YU = b BY FORWARD SUBSTITUTION
!
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
!
do 21 k = 1,n
   if (y(k) .eq. 0.d0) go to 21
   jmin = iu(k)
   jmax = it(k+1) - 1
   if (jmin .gt. jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
!
!            SOLVE XL = y BY BACKWARD SUBSTITUTION
!
x(n) = y(n)/d(n)
if (n .eq. 1) return
!
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin .gt. jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
!
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
return
end subroutine dtslv1

subroutine dsplu (a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, &
&maxil
!-----------------------------------------------------------------------
!     dsplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a double precision sparse
!     matrix. U is a unit upper triangular matrix.
!
!
!     Input arguments ---
!
!     A,ia,ja  the sparse matrix to be decomposed.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic IS ALSO AN OUTPUT ARGUMENT.
!
!     n        ORDER OF THE MATRIX a.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!
!
!     Output arguments ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!
!     d        DOUBLE PRECISION ARRAY CONTAINING THE n DIAGONAL
!              elements of L.
!
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. FOR i = 1,...,n THE OFF-DIAGONAL NONZERO ELEMENTS
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., For each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU DECOMPOSITION IS OBTAINED THEN ierr = THE NUMBER
!              of off-diagonal entries of L and U which were stored
!              in t. Otherwise ierr is assigned a negative value.
!
!
!     Work spaces ---
!
!     w        DOUBLE PRECISION ARRAY OF DIMENSION n.
!
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
integer :: pm
double precision :: const, wi, wmax
!
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.d0
end do
!
!     Perform the LU factorization of the r(k)-TH row of A
!
do 100 k = 1,n
lk = r(k)
jmin = ia(lk)
jmax = ia(lk+1) - 1
if (jmin .gt. jmax) go to 200
!
!     Set p to the reordered row of A
!
p(n+1) = n + 1
jj = jmax
20 lj = ja(jj)
j = ic(lj)
w(j) = a(jj)
pm = n + 1
21 m = pm
pm = p(m)
if (pm - j) 21,210,22
22 p(m) = j
p(j) = pm
jj = jj - 1
if (jj .ge. jmin) go to 20
!
!     Process the entries in the lower triangle of A
!
i = n + 1
30 i = p(i)
if (i .ge. k) go to 50
if (w(i) .eq. 0.d0) go to 30
!
!     L(k,i) is nonzero. Therefore store it in L.
!
jptr = jptr + 1
if (jptr .gt. max) go to 230
const = w(i)
t(jptr) = const
jt(jptr) = c(i)
w(i) = 0.d0
!
!     Perform elimination using the i-TH row of U
!
jmin = iu(i)
jmax = it(i+1) - 1
if (jmin .gt. jmax) go to 30
pm = i
do 43 jj = jmin,jmax
   lj = jt(jj)
   j = ic(lj)
   if (w(j) .ne. 0.d0) go to 43
   if (j - pm) 40,43,41
40 pm = i
41 m = pm
      pm = p(m)
      if (pm - j) 41,43,42
42 p(m) = j
      p(j) = pm
      pm = j
43 w(j) = w(j) - const*t(jj)
go to 30
!
!     Search for the k-TH pivot element
!
50 if (i .gt. n) go to 220
wmax = dabs(w(i))
maxi = i
pm = i
51 m = pm
pm = p(m)
if (pm .gt. n) go to 60
wi = dabs(w(pm))
if (wi .le. wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!
!     Store the pivot in d
!
60 if (wmax .eq. 0.d0) go to 220
d(k) = w(maxi)
!
!     Perform the column interchange
!
if (i .eq. k) go to 70
if (i .eq. maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
!
80 w(maxi) = w(k)
w(k) = 0.d0
lk = c(k)
ll = c(maxi)
c(k) = ll
c(maxi) = lk
ic(lk) = maxi
ic(ll) = k
!
!     The remaining elements of p form the k-TH row of U
!
iu(k) = jptr + 1
90 if (i .gt. n) go to 100
if (w(i) .eq. 0.d0) go to 91
   jptr = jptr + 1
   if (jptr .gt. max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = 0.d0
91 i = p(i)
go to 90
!
!     Prepare for the next row
!
100 it(k+1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- Error return --------------------
!
!     Row r(k) is null
!
200 ierr = -k
return
!
!     Row r(k) has a duplicate entry
!
210 ierr = -(n + k)
return
!
!     Zero pivot in row r(k)
!
220 ierr = -(2*n + k)
return
!
!     Storage for L and U exceeded on row r(k)
!
230 ierr = -(3*n + k)
return
end subroutine dsplu

subroutine s1cnd (n, a, ia, ja, r, c, max, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(out) :: cond
integer :: isgn, iter, iv, ix, j, jump, kase
real :: ainorm, anorm
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a sparse matrix a
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: wk(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
!-----------------------
!     real wk(4*n + max)
!     integer iwk(5*n + max + 2)
!-----------------------
cond = 0.0
call s1nrm (a, ia, ja, n, n, anorm, wk)
if (anorm .eq. 0.0) go to 50
!
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
!
kase = 0
ainorm = 0.0
call sonest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
call rslv (0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
&iwk(1), wk(1), ierr)
!
!     Check if A is singular or if there are errors
!
if (ierr .gt. 0) go to 20
if (iabs(ierr) .le. n) go to 50
ierr = ierr + n
if (iabs(ierr) .le. n) return
ierr = ierr + n
if (iabs(ierr) .le. n) go to 50
return
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
20 call sonest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
if (kase .eq. 0) go to 40
if (kase .ne. 1) go to 30
   call rslv (1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
&iwk(1), wk(1), ierr)
   go to 20
30 call tslv (1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
&iwk(1), wk(1), ierr)
go to 20
!
!     Compute the value of cond
!
40 cond = anorm*ainorm
return
!
!     Singular case
!
50 ierr = 0
return
end subroutine s1cnd

subroutine ds1cnd (n, a, ia, ja, r, c, max, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: isgn, iter, iv, ix, j, jump, kase
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a sparse matrix a
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
double precision :: anorm, ainorm
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
!-----------------------
!     double precision wk(4*n + max)
!     integer iwk(5*n + max + 2)
!-----------------------
cond = 0.d0
call ds1nrm (a, ia, ja, n, n, anorm, wk)
if (anorm .eq. 0.d0) go to 50
!
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
!
kase = 0
ainorm = 0.d0
call donest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
call dslv (0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
&iwk(1), wk(1), ierr)
!
!     Check if A is singular or if there are errors
!
if (ierr .gt. 0) go to 20
if (iabs(ierr) .le. n) go to 50
ierr = ierr + n
if (iabs(ierr) .le. n) return
ierr = ierr + n
if (iabs(ierr) .le. n) go to 50
return
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
20 call donest (n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
&iter, j, jump)
if (kase .eq. 0) go to 40
if (kase .ne. 1) go to 30
   call dslv (1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
&iwk(1), wk(1), ierr)
   go to 20
30 call dtslv (1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
&iwk(1), wk(1), ierr)
go to 20
!
!     Compute the value of cond
!
40 cond = anorm*ainorm
return
!
!     Singular case
!
50 ierr = 0
return
end subroutine ds1cnd

subroutine sonest (n, v, x, isgn, anorm, kase, iter, j, jump)
implicit none
integer, intent(inout) :: iter, j, jump, kase
integer, intent(in) :: n
real, intent(inout) :: anorm
integer :: i, itmax, jlast, l
real :: altsgn, anrm, t
integer :: isamax
real :: sasum
real, intent(inout) :: v(n), x(n)
integer, intent(inout) :: isgn(n)
!-----------------------------------------------------------------------
!
!     sonest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!
!     On entry
!
!        n       THE ORDER OF THE MATRIX.  n .GE. 1.
!
!        kase    INTEGER  (= 0).
!
!     On intermediate returns
!
!        kase    = 1 or 2.
!
!        x       MUST BE OVERWRITTEN BY
!
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!
!                And sonest must be RE-called, with all the other
!                parameters unchanged.
!
!        ITER    NUMBER OF THE CURRENT ITERATION.
!
!     On final return
!
!        kase    = 0.
!
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!
!        ITER    NUMBER OF INTERATIONS TAKEN.
!
!        WRITTEN BY NICK HIGHAM, UNIVERSITY OF MANCHESTER. MODIFIED
!        BY A.H. MORRIS (NSWC).
!
!     REFERENCE
!     N.J. HIGHAM (1987) FORTRAN CODES FOR ESTIMATING
!     THE 1-NORM OF A REAL OR COMPLEX MATRIX, WITH APPLICATIONS
!     TO CONDITION  ESTIMATION, NUMERICAL ANALYSIS REPORT NO. 135,
!     UNIVERSITY OF MANCHESTER, MANCHESTER M13 9PL, ENGLAND.
!
!-----------------------------------------------------------------------
data itmax /5/
!
if (kase .ne. 0) go to 20
   t = 1.0/float(n)
   do i = 1,n
      x(i) = t
   end do
   iter = 0
   kase = 1
   jump = 1
   return
20 go to (100, 200, 300, 400, 500), jump
!
!     ................ ENTRY   (jump = 1)
!     FIRST ITERATION.  x HAS BEEN OVERWRITTEN BY A*x.
!
100 iter = 1
if (n .gt. 1) go to 110
   v(1) = x(1)
   anorm = abs(v(1))
   go to 510
!
110 anorm = sasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) .lt. 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!
!     ................ ENTRY   (jump = 2)
!     FIRST ITERATION.  x HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*x.
!
200 iter = 2
j = isamax(n,x,1)
!
!     Main loop - iterations 2,3,...,itmax.
!
210 do i = 1,n
   x(i) = 0.0
end do
x(j) = 1.0
kase = 1
jump = 3
return
!
!     ................ ENTRY   (jump = 3)
!     x HAS BEEN OVERWRITTEN BY A*x.
!
300 call scopy (n,x,1,v,1)
anrm = anorm
anorm = sasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) .lt. 0.0) l = -1
   if (l .ne. isgn(i)) go to 320
end do
!     Repeated sign vector detected, hence algorithm has converged.
go to 410
!
!     Test for cycling.
!
320 if (anorm .le. anrm) go to 410
!
do i = 1,n
   isgn(i) = 1
   if (x(i) .lt. 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!
!     ................ ENTRY   (jump = 4)
!     x HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*x.
!
400 jlast = j
j = isamax(n,x,1)
if (x(jlast) .eq. abs(x(j)) .or. &
&iter .ge. itmax) go to 410
iter = iter + 1
go to 210
!
!     Iteration complete.  Final stage.
!
410 altsgn = 1.0
do i = 1,n
   x(i) = altsgn * (1.0 + float(i-1)/float(n-1))
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!
!     ................ ENTRY   (jump = 5)
!     x HAS BEEN OVERWRITTEN BY A*x.
!
500 anrm = 2.0*sasum(n,x,1)/float(3*n)
if (anrm .le. anorm) go to 510
   call scopy (n,x,1,v,1)
   anorm = anrm
510 kase = 0
return
end subroutine sonest

subroutine donest (n, v, x, isgn, anorm, kase, iter, j, jump)
implicit none
integer, intent(inout) :: iter, j, jump, kase
integer, intent(in) :: n
integer :: i, itmax, jlast, l
integer :: idamax
double precision, intent(inout) :: anorm, v(n), x(n)
integer, intent(inout) :: isgn(n)
double precision :: altsgn, an, anm1, anrm, t
double precision :: dasum
!-----------------------------------------------------------------------
!
!     donest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!
!     On entry
!
!        n       THE ORDER OF THE MATRIX.  n .GE. 1.
!
!        kase    INTEGER  (= 0).
!
!     On intermediate returns
!
!        kase    = 1 or 2.
!
!        x       MUST BE OVERWRITTEN BY
!
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!
!                And donest must be RE-called, with all the other
!                parameters unchanged.
!
!        ITER    NUMBER OF THE CURRENT ITERATION.
!
!     On final return
!
!        kase    = 0.
!
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!
!        ITER    NUMBER OF INTERATIONS TAKEN.
!
!        WRITTEN BY NICK HIGHAM, UNIVERSITY OF MANCHESTER. MODIFIED
!        BY A.H. MORRIS (NSWC).
!
!     REFERENCE
!     N.J. HIGHAM (1987) FORTRAN CODES FOR ESTIMATING
!     THE 1-NORM OF A REAL OR COMPLEX MATRIX, WITH APPLICATIONS
!     TO CONDITION  ESTIMATION, NUMERICAL ANALYSIS REPORT NO. 135,
!     UNIVERSITY OF MANCHESTER, MANCHESTER M13 9PL, ENGLAND.
!
!-----------------------------------------------------------------------
data itmax /5/
!
an = n
anm1 = n - 1
if (kase .ne. 0) go to 20
   t = 1.d0/an
   do i = 1,n
      x(i) = t
   end do
   iter = 0
   kase = 1
   jump = 1
   return
20 go to (100, 200, 300, 400, 500), jump
!
!     ................ ENTRY   (jump = 1)
!     FIRST ITERATION.  x HAS BEEN OVERWRITTEN BY A*x.
!
100 iter = 1
if (n .gt. 1) go to 110
   v(1) = x(1)
   anorm = dabs(v(1))
   go to 510
!
110 anorm = dasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) .lt. 0.d0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!
!     ................ ENTRY   (jump = 2)
!     FIRST ITERATION.  x HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*x.
!
200 iter = 2
j = idamax(n,x,1)
!
!     Main loop - iterations 2,3,...,itmax.
!
210 do i = 1,n
   x(i) = 0.d0
end do
x(j) = 1.d0
kase = 1
jump = 3
return
!
!     ................ ENTRY   (jump = 3)
!     x HAS BEEN OVERWRITTEN BY A*x.
!
300 call dcopy (n,x,1,v,1)
anrm = anorm
anorm = dasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) .lt. 0.d0) l = -1
   if (l .ne. isgn(i)) go to 320
end do
!     Repeated sign vector detected, hence algorithm has converged.
go to 410
!
!     Test for cycling.
!
320 if (anorm .le. anrm) go to 410
!
do i = 1,n
   isgn(i) = 1
   if (x(i) .lt. 0.d0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!
!     ................ ENTRY   (jump = 4)
!     x HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*x.
!
400 jlast = j
j = idamax(n,x,1)
if (x(jlast) .eq. dabs(x(j)) .or. &
&iter .ge. itmax) go to 410
iter = iter + 1
go to 210
!
!     Iteration complete.  Final stage.
!
410 altsgn = 1.d0
do i = 1,n
   t = i - 1
   x(i) = altsgn * (1.d0 + t/anm1)
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!
!     ................ ENTRY   (jump = 5)
!     x HAS BEEN OVERWRITTEN BY A*x.
!
500 anrm = 2.d0*dasum(n,x,1)/(3.d0*an)
if (anrm .le. anorm) go to 510
   call dcopy (n,x,1,v,1)
   anorm = anrm
510 kase = 0
return
end subroutine donest

subroutine cspslv (n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
integer :: k, l
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!  spslv calls cnspiv which uses sparse Gaussian elimination with
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A x = b.  THE
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  The solution
!  PHASE SOLVES u x = y.
!
!  Input arguments---
!
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      COMPLEX ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         the actual nonzeros.  (See storage description below)
!
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!
!  b      COMPLEX ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., The elimination order for the equations)
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!
!  rtemp  complex array of n + max entries for internal use
!
!
!  Output arguments---
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!
!  x      COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!
!         ierr values are---
!
!         0 LT ierr             SUCCESSFUL COMPLETION. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!
!         ierr = 0              ERROR.  n IS LESS THAN OR EQUAL TO 0
!
!         -n LE ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!
!         -2*n LE ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!
!         -3*n LE ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!
!         -4*n LE ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., If the nonzero stored in a(k) is in
!  COLUMN J, THEN ja(k) = J).  THE ARRAY ia CONTAINS POINTERS TO THE
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) IS SET SO THAT ia(n+1) - ia(1) = THE NUMBER OF NONZERO
!  elements in A.
!------------------------
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: iu, ju, u, y, p
!
ierr = 0
if (n .le. 0) return
!
!  Set indices to divide temporary storage for cnspiv
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  Compute the inverse permutation of c
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL cnspiv TO PERFORM COMPUTATIONS
!
call cnspiv (n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
&itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr .eq. 0) ierr = 1
return
end subroutine cspslv

subroutine cnspiv (n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, &
&nzcnt
!
!
!  cnspiv uses sparse Gaussian elimination with
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A x = b.  THE
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  The solution
!  PHASE SOLVES u x = y.
!
!
!  See cspslv for descriptions of all input and output arguments
!  other than those described below
!
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic IS BOTH AN INPUT AND OUTPUT
!      argument.
!
!  Input arguments (used internally only)---
!
!  y   COMPLEX ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!
!  u   COMPLEX ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., If the nonzero stored in a(k) is in
!  COLUMN j, THEN ja(k) = j).  THE ARRAY ia CONTAINS POINTERS TO THE
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) IS SET SO THAT ia(n+1) - ia(1) = THE NUMBER OF NONZEROS IN
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!
!
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: u(max), x(n), y(n)
complex :: dk, lki, one, yk, zero
real :: xpv, xpvmax
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
integer :: ck, pk, ppk, pv, v, vi, vj, vk
!
one = (1.0,0.0)
zero = (0.0,0.0)
!
!  Initialize work storage and pointers to ju
!
do j = 1,n
  x(j) = zero
end do
iu(1) = 1
juptr = 0
!
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
!
do 170 k = 1,n
!
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
!
  p(n+1) = n+1
  vk = r(k)
!
!  Set up adjacency list for vk, ordered in
!  current column order of u.  The loop index
!  goes downward to exploit any columns
!  from A in correct relative order
!
  jmin = ia(vk)
  jmax = ia(vk+1) - 1
  if (jmin .gt. jmax)  go to 1002
  j = jmax
20 jaj = ja(j)
    vj = ic(jaj)
!
!  Store a(k,j) in work vector
!
    x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
    ppk = n+1
30 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  30,1003,40
40 p(vj) = ppk
    p(pk) = vj
    j = j - 1
    if (j .ge. jmin) go to 20
!
!  The following code computes the k-TH row of u
!
  vi = n+1
  yk = b(vk)
50 vi = p(vi)
  if (vi .ge. k) go to 110
!
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
!
  lki = - x(vi)
  x(vi) = zero
!
!  Adjust right hand side to reflect elimination
!
  yk = yk + lki * y(vi)
  ppk = vi
  jmin = iu(vi)
  jmax = iu(vi+1) - 1
  if (jmin .gt. jmax)  go to 50
  do j = jmin,jmax
    juj = ju(j)
    vj = ic(juj)
!
!  If vj is already in the adjacency of vk,
!  skip the insertion
!
    if (x(vj) .ne. zero)  go to 90
!
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
!
    if (vj - ppk) 60,90,70
60 ppk = vi
70 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  70,90,80
80 p(vj) = ppk
    p(pk) = vj
    ppk = vj
!
!  COMPUTE L(k,j) = L(k,j) - L(k,i)*u(i,j) FOR L(k,i) NONZERO
!  COMPUTE u*(k,j) = u*(k,j) - L(k,i)*u(i,j) FOR u(k,j) NONZERO
!  (u*(k,j) = u(k,j)*D(k,k))
!
90 x(vj) = x(vj) + lki * u(j)
  end do
  go to 50
!
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!
!  Find largest entry, counting off-diagonal nonzeros
!
110 if (vi .gt. n) go to 1004
  xpvmax = abs(real(x(vi))) + abs(aimag(x(vi)))
  maxc = vi
  nzcnt = 0
  pv = vi
120 v = pv
    pv = p(pv)
    if (pv .gt. n) go to 130
    nzcnt = nzcnt + 1
    xpv = abs(real(x(pv))) + abs(aimag(x(pv)))
    if (xpv .le. xpvmax) go to 120
    xpvmax = xpv
    maxc = pv
    maxcl = v
    go to 120
130 if (xpvmax .eq. 0.0) go to 1004
!
!  IF vi = k, THEN THERE IS AN ENTRY FOR DIAGONAL
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
!
  if (vi .eq. k) go to 140
  if (vi .eq. maxc) go to 140
  p(maxcl) = p(maxc)
  go to 150
140 vi = p(vi)
!
!  COMPUTE D(k) = 1/L(k,k) AND PERFORM INTERCHANGE.
!
150 dk = one / x(maxc)
  x(maxc) = x(k)
  i = c(k)
  c(k) = c(maxc)
  c(maxc) = i
  ck = c(k)
  ic(ck) = k
  ic(i) = maxc
  x(k) = zero
!
!  Update right hand side.
!
  y(k) = yk * dk
!
!  Compute value for iu(k+1) and check for storage overflow
!
  iu(k+1) = iu(k) + nzcnt
  if (iu(k+1) .gt. max+1) go to 1005
!
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
!
  if (vi .gt. n)  go to 170
  j = vi
160 juptr = juptr + 1
    ju(juptr) = c(j)
    u(juptr) = x(j) * dk
    x(j) = zero
    j = p(j)
    if (j .le. n) go to 160
170 continue
!
!  BACKSOLVE u x = y, AND REORDER x TO CORRESPOND WITH A
!
k = n
do i = 1,n
  yk = y(k)
  jmin = iu(k)
  jmax = iu(k+1) - 1
  if (jmin .gt. jmax)  go to 190
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
!
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
!
ierr = iu(n+1) - iu(1)
return
!
!  Error returns
!
!  Row k of A is null
!
1002 ierr = -k
return
!
!  Row k of A has a duplicate entry
!
1003 ierr = -(n+k)
return
!
!  Zero pivot in row k
!
1004 ierr = -(2*n+k)
return
!
!  Storage for u exceeded on row k
!
1005 ierr = -(3*n+k)
return
end subroutine cnspiv

subroutine cslv (m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
integer :: it, iu, jt, k, l
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!     cslv employs Gaussian elimination with column interchanges to
!     SOLVE THE NXN COMPLEX SYSTEM AX = b. THE ARGUMENT m0 SPECIFIES
!     if cslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) THE LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     obtained on the initial call to cslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the complex matrix a stored in sparse form.
!
!     b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!              side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = b IS OBTAINED THEN ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              ENTRIES OF l AND U. OTHERWISE ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to cslv, the routine may be recalled with
!     m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to cslv
!     AND SOLVES THE NEW EQUATIONS AX = b. IN THIS CASE A,ia,ja,MAX,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call csplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call cslv1 (n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
&b,x,wk(y))
return
end subroutine cslv

subroutine cslv1 (n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, jmax, jmin, k, lj, lk
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
complex, intent(in) :: b(n), d(n), t(*)
complex, intent(inout) :: x(n), y(n)
complex :: sum
!
!            SOLVE LY = b BY FORWARD SUBSTITUTION
!
do 11 k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin .gt. jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
!
!            SOLVE UX = b BY BACKWARD SUBSTITUTION
!             and reorder x to correspond with A
!
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k+1) - 1
   if (jmin .gt. jmax) go to 21
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
return
end subroutine cslv1

subroutine ctslv (m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
integer :: it, iu, jt, k, l
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!     ctslv employs Gaussian elimination with column interchanges to
!     SOLVE THE NXN COMPLEX SYSTEM XA = b. THE ARGUMENT m0 SPECIFIES
!     if ctslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) THE LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     obtained on the initial call to ctslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the complex matrix a stored in sparse form.
!
!     b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!              side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = b IS OBTAINED THEN ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              ENTRIES OF l AND U. OTHERWISE ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to ctslv, the routine may be recalled with
!     m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to ctslv
!     AND SOLVES THE NEW EQUATIONS XA = b. IN THIS CASE A,ia,ja,MAX,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call csplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call ctslv1 (n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
&b,x,wk(y))
return
end subroutine ctslv

subroutine ctslv1 (n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, jmax, jmin, k, lj, lk
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
complex, intent(in) :: b(n), d(n), t(*)
complex, intent(inout) :: x(n), y(n)
!
!            SOLVE YU = b BY FORWARD SUBSTITUTION
!
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
!
do 21 k = 1,n
   if (y(k) .eq. (0.0, 0.0)) go to 21
   jmin = iu(k)
   jmax = it(k+1) - 1
   if (jmin .gt. jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
!
!            SOLVE XL = y BY BACKWARD SUBSTITUTION
!
x(n) = y(n)/d(n)
if (n .eq. 1) return
!
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin .gt. jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
!
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
return
end subroutine ctslv1

subroutine csplu (a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, &
&maxil
!-----------------------------------------------------------------------
!     csplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a complex sparse matrix.
!     U is a unit upper triangular matrix.
!
!
!     Input arguments ---
!
!     A,ia,ja  the complex sparse matrix to be decomposed.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic IS ALSO AN OUTPUT ARGUMENT.
!
!     n        ORDER OF THE MATRIX a.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!
!
!     Output arguments ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!
!     d        COMPLEX ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. FOR i = 1,...,n THE OFF-DIAGONAL NONZERO ELEMENTS
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t. t is a complex array.
!
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., For each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU DECOMPOSITION IS OBTAINED THEN ierr = THE NUMBER
!              of off-diagonal entries of L and U which were stored
!              in t. Otherwise ierr is assigned a negative value.
!
!
!     Work spaces ---
!
!     w        COMPLEX ARRAY OF DIMENSION n.
!
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
complex, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
integer :: pm
complex :: const, zero
real :: wi, wmax
!--------------------
data zero /(0.0, 0.0)/
!--------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = zero
end do
!
!     Perform the LU factorization of the r(k)-TH row of A
!
do 100 k = 1,n
lk = r(k)
jmin = ia(lk)
jmax = ia(lk+1) - 1
if (jmin .gt. jmax) go to 200
!
!     Set p to the reordered row of A
!
p(n+1) = n + 1
jj = jmax
20 lj = ja(jj)
j = ic(lj)
w(j) = a(jj)
pm = n + 1
21 m = pm
pm = p(m)
if (pm - j) 21,210,22
22 p(m) = j
p(j) = pm
jj = jj - 1
if (jj .ge. jmin) go to 20
!
!     Process the entries in the lower triangle of A
!
i = n + 1
30 i = p(i)
if (i .ge. k) go to 50
if (w(i) .eq. zero) go to 30
!
!     L(k,i) is nonzero. Therefore store it in L.
!
jptr = jptr + 1
if (jptr .gt. max) go to 230
const = w(i)
t(jptr) = const
jt(jptr) = c(i)
w(i) = zero
!
!     Perform elimination using the i-TH row of U
!
jmin = iu(i)
jmax = it(i+1) - 1
if (jmin .gt. jmax) go to 30
pm = i
do 43 jj = jmin,jmax
   lj = jt(jj)
   j = ic(lj)
   if (w(j) .ne. zero) go to 43
   if (j - pm) 40,43,41
40 pm = i
41 m = pm
      pm = p(m)
      if (pm - j) 41,43,42
42 p(m) = j
      p(j) = pm
      pm = j
43 w(j) = w(j) - const*t(jj)
go to 30
!
!     Search for the k-TH pivot element
!
50 if (i .gt. n) go to 220
wmax = abs(real(w(i))) + abs(aimag(w(i)))
maxi = i
pm = i
51 m = pm
pm = p(m)
if (pm .gt. n) go to 60
wi = abs(real(w(pm))) + abs(aimag(w(pm)))
if (wi .le. wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!
!     Store the pivot in d
!
60 if (wmax .eq. 0.0) go to 220
d(k) = w(maxi)
!
!     Perform the column interchange
!
if (i .eq. k) go to 70
if (i .eq. maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
!
80 w(maxi) = w(k)
w(k) = zero
lk = c(k)
ll = c(maxi)
c(k) = ll
c(maxi) = lk
ic(lk) = maxi
ic(ll) = k
!
!     The remaining elements of p form the k-TH row of U
!
iu(k) = jptr + 1
90 if (i .gt. n) go to 100
if (w(i) .eq. zero) go to 91
   jptr = jptr + 1
   if (jptr .gt. max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = zero
91 i = p(i)
go to 90
!
!     Prepare for the next row
!
100 it(k+1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- Error return --------------------
!
!     Row r(k) is null
!
200 ierr = -k
return
!
!     Row r(k) has a duplicate entry
!
210 ierr = -(n + k)
return
!
!     Zero pivot in row r(k)
!
220 ierr = -(2*n + k)
return
!
!     Storage for L and U exceeded on row r(k)
!
230 ierr = -(3*n + k)
return
end subroutine csplu

subroutine eig (ibal,a,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!                    Eigenvalues of real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), wr(n), wi(n)
!
low = 1
igh = n
if (ibal .ne. 0) call balanc (ka,n,a,low,igh,wr)
call elmhs0 (ka,n,low,igh,a,wr)
call hqr (ka,n,low,igh,a,wr,wi,ierr)
return
end subroutine eig

subroutine eig1 (ibal,a,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!                    Eigenvalues of real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), wr(n), wi(n)
!
low = 1
igh = n
if (ibal .ne. 0) call balanc (ka,n,a,low,igh,wr)
call orthes (ka,n,low,igh,a,wr)
call hqr (ka,n,low,igh,a,wr,wi,ierr)
return
end subroutine eig1

subroutine eigv (ibal,a,ka,n,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, j, k, kp1, low
!-----------------------------------------------------------------------
!           Eigenvalues and eigenvectors of real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), wr(n), wi(n), zr(ka,n), zi(ka,n)
!
low = 1
igh = n
if (ibal .ne. 0) call balanc (ka,n,a,low,igh,zi)
call elmhs0 (ka,n,low,igh,a,wr)
call eltrn0 (ka,n,low,igh,a,wr,zr)
call hqr2 (ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr .ne. 0) return
if (ibal .ne. 0) call balbak (ka,n,low,igh,zi,n,zr)
!
do 30 k = 1,n
   if (wi(k)) 30,10,20
10 do 11 j = 1,n
11 zi(j,k) = 0.0
   go to 30
20 kp1 = k + 1
   do 21 j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
21 zi(j,kp1) = -zi(j,k)
30 continue
return
end subroutine eigv

subroutine eigv1 (ibal,a,ka,n,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, j, k, kp1, low
!-----------------------------------------------------------------------
!           Eigenvalues and eigenvectors of real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), wr(n), wi(n), zr(ka,n), zi(ka,n)
!
low = 1
igh = n
if (ibal .ne. 0) call balanc (ka,n,a,low,igh,zi)
call orthes (ka,n,low,igh,a,wr)
call ortran (ka,n,low,igh,a,wr,zr)
call hqr2 (ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr .ne. 0) return
if (ibal .ne. 0) call balbak (ka,n,low,igh,zi,n,zr)
!
do 30 k = 1,n
   if (wi(k)) 30,10,20
10 do 11 j = 1,n
11 zi(j,k) = 0.0
   go to 30
20 kp1 = k + 1
   do 21 j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
21 zi(j,kp1) = -zi(j,k)
30 continue
return
end subroutine eigv1

subroutine balanc(nm,n,a,low,igh,scale)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: jj
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
integer :: iexc
real, intent(inout) :: a(nm,n), scale(n)
real :: c, f, g, r, s, b2, radix
integer :: ipmpar
!     real abs
logical :: noconv
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!
!     This subroutine balances a real matrix and isolates
!     eigenvalues whenever possible.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the input matrix to be balanced.
!
!     On output-
!
!        A contains the balanced matrix,
!
!        Low and igh are two integers such that a(i,j)
!          is equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!
!        Scale contains information determining the
!           permutations and scaling factors used.
!
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j),      j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!
!     Note that 1 is returned for igh if igh is zero formally.
!
!     The Algol procedure exc contained in balance appears in
!     balanc  in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!
!-----------------------------------------------------------------------
!
!     ********** radix IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the base of the machine floating point representation.
!
           radix = ipmpar(4)
!
!                **********
!
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** IN-LINE PROCEDURE FOR ROW AND
!                COLUMN EXCHANGE **********
20 scale(m) = j
if (j .eq. m) go to 50
!
do i = 1, l
   f = a(i,j)
   a(i,j) = a(i,m)
   a(i,m) = f
end do
!
do i = k, n
   f = a(j,i)
   a(j,i) = a(m,i)
   a(m,i) = f
end do
!
50 go to (80,130), iexc
!     ********** SEARCH FOR ROWS ISOLATING AN EIGENVALUE
!                AND PUSH THEM DOWN **********
80 if (l .eq. 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do 120 jj = 1, l
   j = l + 1 - jj
!
   do 110 i = 1, l
      if (i .eq. j) go to 110
      if (a(j,i) .ne. 0.0) go to 120
110 continue
!
   m = l
   iexc = 1
   go to 20
120 continue
!
go to 140
!     ********** SEARCH FOR COLUMNS ISOLATING AN EIGENVALUE
!                AND PUSH THEM LEFT **********
130 k = k + 1
!
140 do 170 j = k, l
!
   do 150 i = k, l
      if (i .eq. j) go to 150
      if (a(i,j) .ne. 0.0) go to 170
150 continue
!
   m = k
   iexc = 2
   go to 20
170 continue
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS k TO l **********
do 180 i = k, l
180 scale(i) = 1.0
!     ********** ITERATIVE LOOP FOR NORM REDUCTION **********
190 noconv = .false.
!
do 270 i = k, l
   c = 0.0
   r = 0.0
!
   do 200 j = k, l
      if (j .eq. i) go to 200
      c = c + abs(a(j,i))
      r = r + abs(a(i,j))
200 continue
!     ********** GUARD AGAINST ZERO c OR r DUE TO UNDERFLOW **********
   if (c .eq. 0.0 .or. r .eq. 0.0) go to 270
   g = r / radix
   f = 1.0
   s = c + r
210 if (c .ge. g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c .lt. g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** NOW BALANCE **********
240 if ((c + r) / f .ge. 0.95 * s) go to 270
   g = 1.0 / f
   scale(i) = scale(i) * f
   noconv = .true.
!
   do 250 j = k, n
250 a(i,j) = a(i,j) * g
!
   do 260 j = 1, l
260 a(j,i) = a(j,i) * f
!
270 continue
!
if (noconv) go to 190
!
280 low = k
igh = l
return
end subroutine balanc

subroutine balinv (nz,n,z,low,igh,scale)
implicit none
integer :: i, j, k
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nz, igh, low
real, intent(inout) :: z(nz,n)
real, intent(in) :: scale(n)
real :: s
!-----------------------------------------------------------------------
!        Given A matrix A of order n. balanc transforms A into
!     the matrix B by the similarity transformation
!             b = d**(-1)*transpose(p)*a*p*d
!     where D is a diagonal matrix and P a permutation matrix.
!     The information concerning D and P is stored in igh, low,
!     and scale. The order in which the interchanges were made
!     is n to igh + 1, and then 1 to low - 1.
!
!        z is a matrix of order n. balinv transforms z into the
!     matrix W using the inverse similarity transform
!             w = p*d*z*d**(-1)*transpose(p)
!
!     On input-
!
!        nz is the row dimension of the matrix z in the calling
!          program,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by  balanc,
!
!        Scale contains information determining the permutations
!          and scaling factors used by  balanc,
!
!     On output-
!
!        z contains the transformed matrix W
!
!-----------------------------------------------------------------------
!
if (igh .eq. low) go to 30
!
do i = low, igh
s = scale(i)
   do 10 j = 1, n
10 z(i,j) = z(i,j) * s
end do
!
do j = low, igh
s = 1.0/scale(j)
   do 20 i = 1, n
20 z(i,j) = z(i,j) * s
end do
!
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
!
30 do 60 ii = 1, n
   i = ii
   if (i .ge. low .and. i .le. igh) go to 60
   if (i .lt. low) i = low - ii
   k = scale(i)
   if (k .eq. i) go to 60
!
   do 40 j = 1, n
      s = z(i,j)
      z(i,j) = z(k,j)
40 z(k,j) = s
!
   do 50 j = 1, n
      s = z(j,i)
      z(j,i) = z(j,k)
50 z(j,k) = s
60 continue
return
end subroutine balinv

subroutine elmhes(nm,n,low,igh,a,int)
implicit none
!
integer :: i, j, m
integer, intent(in) :: n
integer :: la
integer, intent(in) :: nm, igh
integer :: kp1
integer, intent(in) :: low
integer :: mm1, mp1
real, intent(inout) :: a(nm,n)
real :: x, y
!     real abs
integer, intent(inout) :: int(igh)
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure elmhes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     stabilized elementary similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  The multipliers
!          which were used in the reduction are stored in the
!          remaining triangle under the Hessenberg matrix,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la .lt. kp1) go to 200
!
do 180 m = kp1, la
   mm1 = m - 1
   x = 0.0
   i = m
!
   do 100 j = m, igh
      if (abs(a(j,mm1)) .le. abs(x)) go to 100
      x = a(j,mm1)
      i = j
100 continue
!
   int(m) = i
   if (i .eq. m) go to 130
!    ********** INTERCHANGE ROWS AND COLUMNS OF a **********
   do j = mm1, n
      y = a(i,j)
      a(i,j) = a(m,j)
      a(m,j) = y
   end do
!
   do j = 1, igh
      y = a(j,i)
      a(j,i) = a(j,m)
      a(j,m) = y
   end do
!    ********** END INTERCHANGE **********
130 if (x .eq. 0.0) go to 180
   mp1 = m + 1
!
   do 160 i = mp1, igh
      y = a(i,mm1)
      if (y .eq. 0.0) go to 160
      y = y / x
      a(i,mm1) = y
!
      do 140 j = m, n
140 a(i,j) = a(i,j) - y * a(m,j)
!
      do 150 j = 1, igh
150 a(j,m) = a(j,m) + y * a(j,i)
!
160 continue
!
180 continue
!
200 return
end subroutine elmhes

subroutine elmhs0(nm,n,low,igh,a,int)
implicit none
!
integer :: i, j, m
integer, intent(in) :: n
integer :: la
integer, intent(in) :: nm, igh
integer :: kp1
integer, intent(in) :: low
integer :: mm1, mp1
real, intent(inout) :: a(nm,n)
real :: x, y
!     real abs
real, intent(inout) :: int(igh)
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure elmhes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     stabilized elementary similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  The multipliers
!          which were used in the reduction are stored in the
!          remaining triangle under the Hessenberg matrix,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la .lt. kp1) go to 200
!
do 180 m = kp1, la
   mm1 = m - 1
   x = 0.0
   i = m
!
   do 100 j = m, igh
      if (abs(a(j,mm1)) .le. abs(x)) go to 100
      x = a(j,mm1)
      i = j
100 continue
!
   int(m) = i
   if (i .eq. m) go to 130
!    ********** INTERCHANGE ROWS AND COLUMNS OF a **********
   do j = mm1, n
      y = a(i,j)
      a(i,j) = a(m,j)
      a(m,j) = y
   end do
!
   do j = 1, igh
      y = a(j,i)
      a(j,i) = a(j,m)
      a(j,m) = y
   end do
!    ********** END INTERCHANGE **********
130 if (x .eq. 0.0) go to 180
   mp1 = m + 1
!
   do 160 i = mp1, igh
      y = a(i,mm1)
      if (y .eq. 0.0) go to 160
      y = y / x
      a(i,mm1) = y
!
      do 140 j = m, n
140 a(i,j) = a(i,j) - y * a(m,j)
!
      do 150 j = 1, igh
150 a(j,m) = a(j,m) + y * a(j,i)
!
160 continue
!
180 continue
!
200 return
end subroutine elmhs0

subroutine orthes(nm,n,low,igh,a,ort)
implicit none
!
integer :: i, j, m
integer, intent(in) :: n
integer :: ii, jj, la, mp
integer, intent(in) :: nm, igh
integer :: kp1
integer, intent(in) :: low
real, intent(inout) :: a(nm,n), ort(igh)
real :: f, g, h, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure orthes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  Information about
!          the orthogonal transformations used in the reduction
!          is stored in the remaining triangle under the
!          Hessenberg matrix,
!
!        Ort contains further information about the transformations.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la .lt. kp1) go to 200
!
do 180 m = kp1, la
   h = 0.0
   ort(m) = 0.0
   scale = 0.0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + abs(a(i,m-1))
!
   if (scale .eq. 0.0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ort(i) = a(i,m-1) / scale
      h = h + ort(i) * ort(i)
   end do
!
   g = sqrt(h)
   if (ort(m) .ge. 0.0) g = -g
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
!
      f = f / h
!
      do 120 i = m, igh
120 a(i,j) = a(i,j) - f * ort(i)
!
   end do
!     ********** FORM (i-(U*UT)/h)*a*(i-(U*UT)/h) **********
   do i = 1, igh
      f = 0.0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         f = f + ort(j) * a(i,j)
      end do
!
      f = f / h
!
      do 150 j = m, igh
150 a(i,j) = a(i,j) - f * ort(j)
!
   end do
!
   ort(m) = scale * ort(m)
   a(m,m-1) = scale * g
180 continue
!
200 return
end subroutine orthes

subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ll, mm, na
integer, intent(in) :: nm, igh
integer :: its
integer, intent(in) :: low
integer :: mp2, enm2
integer, intent(out) :: ierr
real, intent(inout) :: h(nm,n), wr(n), wi(n)
real :: p, q, r, s, t, w, x, y, zz, norm, machep, spmpar
!     real sqrt,abs
!     integer min0
logical :: notlas
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure hqr,
!     NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!
!     This subroutine finds the eigenvalues of a real
!     upper Hessenberg matrix BY the QR method.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        h contains the upper Hessenberg matrix.  Information about
!          the transformations used in the reduction to Hessenberg
!          form by  elmhes  or  orthes, if performed, is stored
!          in the remaining triangle under the Hessenberg matrix.
!
!     On output-
!
!        h has been destroyed.  Therefore, it must be saved
!          before calling  hqr  if subsequent calculation and
!          back transformation of eigenvectors is to be performed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
norm = 0.0
k = 1
!     ********** STORE ROOTS ISOLATED BY balanc
!                AND COMPUTE MATRIX norm **********
do 50 i = 1, n
!
   do 40 j = k, n
40 norm = norm + abs(h(i,j))
!
   k = i
   if (i .ge. low .and. i .le. igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.0
50 continue
!
en = igh
t = 0.0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
60 if (en .lt. low) go to 1001
its = 0
na = en - 1
enm2 = na - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
70 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 100
   s = abs(h(l-1,l-1)) + abs(h(l,l))
   if (s .eq. 0.0) s = norm
   if (abs(h(l,l-1)) .le. machep * s) go to 100
end do
!     ********** FORM SHIFT **********
100 x = h(en,en)
if (l .eq. en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l .eq. na) go to 280
if (its .eq. 30) go to 1000
if (its .ne. 10 .and. its .ne. 20) go to 130
!     ********** FORM EXCEPTIONAL SHIFT **********
t = t + x
!
do 120 i = low, en
120 h(i,i) = h(i,i) - x
!
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75 * s
y = x
w = -0.4375 * s * s
130 its = its + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m+1,m) + h(m,m+1)
   q = h(m+1,m+1) - zz - r - s
   r = h(m+2,m+1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m .eq. l) go to 150
   if (abs(h(m,m-1)) * (abs(q) + abs(r)) .le. machep * abs(p) &
&* (abs(h(m-1,m-1)) + abs(zz) + abs(h(m+1,m+1)))) go to 150
end do
!
150 mp2 = m + 2
!
do 160 i = mp2, en
   h(i,i-2) = 0.0
   if (i .eq. mp2) go to 160
   h(i,i-3) = 0.0
160 continue
!     ********** DOUBLE QR STEP INVOLVING ROWS l TO en AND
!                COLUMNS m TO en **********
do 260 k = m, na
   notlas = k .ne. na
   if (k .eq. m) go to 170
   p = h(k,k-1)
   q = h(k+1,k-1)
   r = 0.0
   if (notlas) r = h(k+2,k-1)
   x = abs(p) + abs(q) + abs(r)
   if (x .eq. 0.0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p .lt. 0.0) s = -s
   if (k .eq. m) go to 180
   h(k,k-1) = -s * x
   go to 190
180 if (l .ne. m) h(k,k-1) = -h(k,k-1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** ROW MODIFICATION **********
   do j = k, en
      p = h(k,j) + q * h(k+1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k+2,j)
      h(k+2,j) = h(k+2,j) - p * zz
200 h(k+1,j) = h(k+1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
!
   j = min0(en,k+3)
!     ********** COLUMN MODIFICATION **********
   do i = l, j
      p = x * h(i,k) + y * h(i,k+1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k+2)
      h(i,k+2) = h(i,k+2) - p * r
220 h(i,k+1) = h(i,k+1) - p * q
      h(i,k) = h(i,k) - p
   end do
!
260 continue
!
go to 70
!     ********** ONE ROOT FOUND **********
270 wr(en) = x + t
wi(en) = 0.0
en = na
go to 60
!     ********** TWO ROOTS FOUND **********
280 p = (y - x) / 2.0
q = p * p + w
zz = sqrt(abs(q))
x = x + t
if (q .lt. 0.0) go to 320
!     ********** REAL PAIR **********
if (p .lt. 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz .ne. 0.0) wr(en) = x - w / zz
wi(na) = 0.0
wi(en) = 0.0
go to 330
!     ********** COMPLEX PAIR **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = en
1001 return
end subroutine hqr

subroutine balbak(nm,n,low,igh,scale,m,z)
implicit none
!
integer :: i, j, k
integer, intent(in) :: m, n
integer :: ii
integer, intent(in) :: nm, igh, low
real, intent(in) :: scale(n)
real, intent(inout) :: z(nm,m)
real :: s
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!
!     This subroutine forms the eigenvectors of a real general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by  balanc.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by  balanc,
!
!        Scale contains information determining the permutations
!          and scaling factors used by  balanc,
!
!        m is the number of columns of z to be back transformed,
!
!        z contains the real and imaginary parts of the eigen-
!          vectors to be back transformed in its first m columns.
!
!     On output-
!
!        z contains the real and imaginary parts of the
!          transformed eigenvectors in its first m columns.
!
!-----------------------------------------------------------------------
!
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do 100 j = 1, m
100 z(i,j) = z(i,j) * s
!
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
120 do 140 ii = 1, n
   i = ii
   if (i .ge. low .and. i .le. igh) go to 140
   if (i .lt. low) i = low - ii
   k = scale(i)
   if (k .eq. i) go to 140
!
   do j = 1, m
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
!
140 continue
!
200 return
end subroutine balbak

subroutine eltran(nm,n,low,igh,a,int,z)
implicit none
!
integer :: i, j
integer, intent(in) :: n
integer :: kl, mm, mp
integer, intent(in) :: nm, igh, low
integer :: mp1
real, intent(in) :: a(nm,igh)
real, intent(inout) :: z(nm,n)
integer, intent(in) :: int(igh)
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ELMTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the stabilized elementary
!     similarity transformations used in the reduction of A
!     real general matrix to upper Hessenberg form by  elmhes.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains the multipliers which were used in the
!          reduction by  elmhes  in its lower triangle
!          below the subdiagonal,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction by  elmhes.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  elmhes.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE z TO IDENTITY MATRIX **********
do i = 1, n
!
   do 60 j = 1, n
60 z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl .lt. 1) go to 200
!     ********** FOR mp=igh-1 STEP -1 UNTIL low+1 DO -- **********
do 140 mm = 1, kl
   mp = igh - mm
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100 z(i,mp) = a(i,mp-1)
!
   i = int(mp)
   if (i .eq. mp) go to 140
!
   do j = mp, igh
      z(mp,j) = z(i,j)
      z(i,j) = 0.0
   end do
!
   z(i,mp) = 1.0
140 continue
!
200 return
end subroutine eltran

subroutine eltrn0(nm,n,low,igh,a,int,z)
implicit none
!
integer :: i, j
integer, intent(in) :: n
integer :: kl, mm, mp
integer, intent(in) :: nm, igh, low
integer :: mp1
real, intent(in) :: a(nm,igh)
real, intent(inout) :: z(nm,n)
real, intent(in) :: int(igh)
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ELMTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the stabilized elementary
!     similarity transformations used in the reduction of A
!     real general matrix to upper Hessenberg form by  elmhs0.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains the multipliers which were used in the
!          reduction by  elmhs0  in its lower triangle
!          below the subdiagonal,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction by  elmhs0.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  elmhs0.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE z TO IDENTITY MATRIX **********
do i = 1, n
!
   do 60 j = 1, n
60 z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl .lt. 1) go to 200
!     ********** FOR mp=igh-1 STEP -1 UNTIL low+1 DO -- **********
do 140 mm = 1, kl
   mp = igh - mm
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100 z(i,mp) = a(i,mp-1)
!
   i = int(mp)
   if (i .eq. mp) go to 140
!
   do j = mp, igh
      z(mp,j) = z(i,j)
      z(i,j) = 0.0
   end do
!
   z(i,mp) = 1.0
140 continue
!
200 return
end subroutine eltrn0

subroutine ortran(nm,n,low,igh,a,ort,z)
implicit none
!
integer :: i, j
integer, intent(in) :: n
integer :: kl, mm, mp
integer, intent(in) :: nm, igh, low
integer :: mp1
real, intent(in) :: a(nm,igh)
real, intent(inout) :: ort(igh), z(nm,n)
real :: g
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real general
!     matrix to upper Hessenberg form by  orthes.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction by  orthes
!          in its strict lower triangle,
!
!        Ort contains further information about the trans-
!          formations used in the reduction by  orthes.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  orthes,
!
!        Ort has been altered.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE z TO IDENTITY MATRIX **********
do i = 1, n
!
   do 60 j = 1, n
60 z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl .lt. 1) go to 200
!     ********** FOR mp=igh-1 STEP -1 UNTIL low+1 DO -- **********
do 140 mm = 1, kl
   mp = igh - mm
   if (a(mp,mp-1) .eq. 0.0) go to 140
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100 ort(i) = a(i,mp-1)
!
   do j = mp, igh
      g = 0.0
!
      do 110 i = mp, igh
110 g = g + ort(i) * z(i,j)
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN orthes.
!                DOUBLE DIVISION AVOIDS POSSIBLE UNDERFLOW **********
      g = (g / ort(mp)) / a(mp,mp-1)
!
      do 120 i = mp, igh
120 z(i,j) = z(i,j) + g * ort(i)
!
   end do
!
140 continue
!
200 return
end subroutine ortran

subroutine ortrn1(n,low,igh,a,na,z,nz,ort)
implicit none
!
integer :: i, j
integer, intent(in) :: n
integer :: kl, mm, mp
integer, intent(in) :: na, igh, low
integer :: mp1
integer, intent(in) :: nz
real, intent(in) :: a(na,igh)
real, intent(inout) :: ort(igh), z(nz,n)
real :: g
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real general
!     matrix to upper Hessenberg form by  orthes.
!
!     On input-
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction by  orthes
!          in its strict lower triangle,
!
!        na must be set to the row dimension of the 2-dimensional
!          array parameter  a  as declared in the calling program
!          dimension statement,
!
!        nz must be set to the row dimension of the 2-dimensional
!          array parameter  z  as declared in the calling program
!          dimension statement,
!
!        Ort contains further information about the trans-
!          formations used in the reduction by  orthes.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  orthes,
!
!        Ort has been altered.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE z TO IDENTITY MATRIX **********
do i = 1, n
!
   do 60 j = 1, n
60 z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl .lt. 1) go to 200
!     ********** FOR mp=igh-1 STEP -1 UNTIL low+1 DO -- **********
do 140 mm = 1, kl
   mp = igh - mm
   if (a(mp,mp-1) .eq. 0.0) go to 140
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100 ort(i) = a(i,mp-1)
!
   do j = mp, igh
      g = 0.0
!
      do 110 i = mp, igh
110 g = g + ort(i) * z(i,j)
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN orthes.
!                DOUBLE DIVISION AVOIDS POSSIBLE UNDERFLOW **********
      g = (g / ort(mp)) / a(mp,mp-1)
!
      do 120 i = mp, igh
120 z(i,j) = z(i,j) + g * ort(i)
!
   end do
!
140 continue
!
200 return
end subroutine ortrn1

subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ii, jj, ll, mm, na
integer, intent(in) :: nm
integer :: nn
integer, intent(in) :: igh
integer :: its
integer, intent(in) :: low
integer :: mp2, enm2
integer, intent(out) :: ierr
real, intent(inout) :: h(nm,n), wr(n), wi(n), z(nm,n)
real :: p, q, r, s, t, w, x, y, ra, sa, vi, vr, zz, norm, machep, &
&spmpar
!     real sqrt,abs
!     integer min0
logical :: notlas
complex :: z3
!     complex cmplx
!     real real,aimag
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure hqr2,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a real upper Hessenberg matrix BY the QR method.  The
!     eigenvectors of a real general matrix can also be found
!     if  elmhes  and  eltran  or  orthes  and  ortran  have
!     been used to reduce this general matrix to Hessenberg form
!     and to accumulate the similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n,
!
!        h contains the upper Hessenberg matrix,
!
!        z contains the transformation matrix produced by  eltran
!          after the reduction by  elmhes, or by  ortran  after the
!          reduction by  orthes, if performed.  If the eigenvectors
!          of the Hessenberg matrix are desired, z must contain the
!          identity matrix.
!
!     On output-
!
!        h has been destroyed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        z contains the real and imaginary parts of the eigenvectors.
!          If the i-TH eigenvalue is real, the i-TH column of z
!          contains its eigenvector.  If the i-TH eigenvalue is complex
!          with positive imaginary part, the i-TH and (i+1)-TH
!          columns of z contain the real and imaginary parts of its
!          eigenvector.  The eigenvectors are unnormalized.  If an
!          error exit is made, none of the eigenvectors has been found,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
norm = 0.0
k = 1
!     ********** STORE ROOTS ISOLATED BY balanc
!                AND COMPUTE MATRIX norm **********
do 50 i = 1, n
!
   do 40 j = k, n
40 norm = norm + abs(h(i,j))
!
   k = i
   if (i .ge. low .and. i .le. igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.0
50 continue
!
en = igh
t = 0.0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
60 if (en .lt. low) go to 340
its = 0
na = en - 1
enm2 = na - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
70 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 100
   s = abs(h(l-1,l-1)) + abs(h(l,l))
   if (s .eq. 0.0) s = norm
   if (abs(h(l,l-1)) .le. machep * s) go to 100
end do
!     ********** FORM SHIFT **********
100 x = h(en,en)
if (l .eq. en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l .eq. na) go to 280
if (its .eq. 30) go to 1000
if (its .ne. 10 .and. its .ne. 20) go to 130
!     ********** FORM EXCEPTIONAL SHIFT **********
t = t + x
!
do 120 i = low, en
120 h(i,i) = h(i,i) - x
!
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75 * s
y = x
w = -0.4375 * s * s
130 its = its + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m+1,m) + h(m,m+1)
   q = h(m+1,m+1) - zz - r - s
   r = h(m+2,m+1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m .eq. l) go to 150
   if (abs(h(m,m-1)) * (abs(q) + abs(r)) .le. machep * abs(p) &
&* (abs(h(m-1,m-1)) + abs(zz) + abs(h(m+1,m+1)))) go to 150
end do
!
150 mp2 = m + 2
!
do 160 i = mp2, en
   h(i,i-2) = 0.0
   if (i .eq. mp2) go to 160
   h(i,i-3) = 0.0
160 continue
!     ********** DOUBLE QR STEP INVOLVING ROWS l TO en AND
!                COLUMNS m TO en **********
do 260 k = m, na
   notlas = k .ne. na
   if (k .eq. m) go to 170
   p = h(k,k-1)
   q = h(k+1,k-1)
   r = 0.0
   if (notlas) r = h(k+2,k-1)
   x = abs(p) + abs(q) + abs(r)
   if (x .eq. 0.0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p .lt. 0.0) s = -s
   if (k .eq. m) go to 180
   h(k,k-1) = -s * x
   go to 190
180 if (l .ne. m) h(k,k-1) = -h(k,k-1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** ROW MODIFICATION **********
   do j = k, n
      p = h(k,j) + q * h(k+1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k+2,j)
      h(k+2,j) = h(k+2,j) - p * zz
200 h(k+1,j) = h(k+1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
!
   j = min0(en,k+3)
!     ********** COLUMN MODIFICATION **********
   do i = 1, j
      p = x * h(i,k) + y * h(i,k+1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k+2)
      h(i,k+2) = h(i,k+2) - p * r
220 h(i,k+1) = h(i,k+1) - p * q
      h(i,k) = h(i,k) - p
   end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
   do i = low, igh
      p = x * z(i,k) + y * z(i,k+1)
      if (.not. notlas) go to 240
      p = p + zz * z(i,k+2)
      z(i,k+2) = z(i,k+2) - p * r
240 z(i,k+1) = z(i,k+1) - p * q
      z(i,k) = z(i,k) - p
   end do
!
260 continue
!
go to 70
!     ********** ONE ROOT FOUND **********
270 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.0
en = na
go to 60
!     ********** TWO ROOTS FOUND **********
280 p = (y - x) / 2.0
q = p * p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q .lt. 0.0) go to 320
!     ********** REAL PAIR **********
if (p .lt. 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz .ne. 0.0) wr(en) = x - w / zz
wi(na) = 0.0
wi(en) = 0.0
x = h(en,na)
s = abs(x) + abs(zz)
p = x / s
q = zz / s
r = sqrt(p*p+q*q)
p = p / r
q = q / r
!     ********** ROW MODIFICATION **********
do j = na, n
   zz = h(na,j)
   h(na,j) = q * zz + p * h(en,j)
   h(en,j) = q * h(en,j) - p * zz
end do
!     ********** COLUMN MODIFICATION **********
do i = 1, en
   zz = h(i,na)
   h(i,na) = q * zz + p * h(i,en)
   h(i,en) = q * h(i,en) - p * zz
end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
do i = low, igh
   zz = z(i,na)
   z(i,na) = q * zz + p * z(i,en)
   z(i,en) = q * z(i,en) - p * zz
end do
!
go to 330
!     ********** COMPLEX PAIR **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** ALL ROOTS FOUND.  BACKSUBSTITUTE TO FIND
!                VECTORS OF UPPER TRIANGULAR FORM **********
340 if (norm .eq. 0.0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 1 DO -- **********
do 800 nn = 1, n
   en = n + 1 - nn
   p = wr(en)
   q = wi(en)
   na = en - 1
   if (q) 710, 600, 800
!     ********** REAL VECTOR **********
600 m = en
   h(en,en) = 1.0
   if (na .eq. 0) go to 800
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do 700 ii = 1, na
      i = en - ii
      w = h(i,i) - p
      r = h(i,en)
      if (m .gt. na) go to 620
!
      do 610 j = m, na
610 r = r + h(i,j) * h(j,en)
!
620 if (wi(i) .ge. 0.0) go to 630
      zz = w
      s = r
      go to 700
630 m = i
      if (wi(i) .ne. 0.0) go to 640
      t = w
      if (w .eq. 0.0) t = machep * norm
      h(i,en) = -r / t
      go to 700
!     ********** SOLVE REAL EQUATIONS **********
640 x = h(i,i+1)
      y = h(i+1,i)
      q = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i)
      t = (x * s - zz * r) / q
      h(i,en) = t
      if (abs(x) .le. abs(zz)) go to 650
      h(i+1,en) = (-r - w * t) / x
      go to 700
650 h(i+1,en) = (-s - y * t) / zz
700 continue
!     ********** END REAL VECTOR **********
   go to 800
!     ********** COMPLEX VECTOR **********
710 m = na
!     ********** LAST VECTOR COMPONENT CHOSEN IMAGINARY SO THAT
!                EIGENVECTOR MATRIX IS TRIANGULAR **********
   if (abs(h(en,na)) .le. abs(h(na,en))) go to 720
   h(na,na) = q / h(en,na)
   h(na,en) = -(h(en,en) - p) / h(en,na)
   go to 730
720 z3 = cmplx(0.0,-h(na,en)) / cmplx(h(na,na)-p,q)
   h(na,na) = real(z3)
   h(na,en) = aimag(z3)
730 h(en,na) = 0.0
   h(en,en) = 1.0
   enm2 = na - 1
   if (enm2 .eq. 0) go to 800
!     ********** FOR i=en-2 STEP -1 UNTIL 1 DO -- **********
   do 790 ii = 1, enm2
      i = na - ii
      w = h(i,i) - p
      ra = 0.0
      sa = h(i,en)
!
      do j = m, na
         ra = ra + h(i,j) * h(j,na)
         sa = sa + h(i,j) * h(j,en)
      end do
!
      if (wi(i) .ge. 0.0) go to 770
      zz = w
      r = ra
      s = sa
      go to 790
770 m = i
      if (wi(i) .ne. 0.0) go to 780
      z3 = cmplx(-ra,-sa) / cmplx(w,q)
      h(i,na) = real(z3)
      h(i,en) = aimag(z3)
      go to 790
!     ********** SOLVE COMPLEX EQUATIONS **********
780 x = h(i,i+1)
      y = h(i+1,i)
      vr = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i) - q * q
      vi = (wr(i) - p) * 2.0 * q
      if (vr .eq. 0.0 .and. vi .eq. 0.0) vr = machep * norm &
&* (abs(w) + abs(q) + abs(x) + abs(y) + abs(zz))
      z3 = cmplx(x*r-zz*ra+q*sa,x*s-zz*sa-q*ra) / cmplx(vr,vi)
      h(i,na) = real(z3)
      h(i,en) = aimag(z3)
      if (abs(x) .le. abs(zz) + abs(q)) go to 785
      h(i+1,na) = (-ra - w * h(i,na) + q * h(i,en)) / x
      h(i+1,en) = (-sa - w * h(i,en) - q * h(i,na)) / x
      go to 790
785 z3 = cmplx(-r-y*h(i,na),-s-y*h(i,en)) / cmplx(zz,q)
      h(i+1,na) = real(z3)
      h(i+1,en) = aimag(z3)
790 continue
!     ********** END COMPLEX VECTOR **********
800 continue
!     ********** END BACK SUBSTITUTION.
!                VECTORS OF ISOLATED ROOTS **********
do 840 i = 1, n
   if (i .ge. low .and. i .le. igh) go to 840
!
   do 820 j = i, n
820 z(i,j) = h(i,j)
!
840 continue
!     ********** MULTIPLY BY TRANSFORMATION MATRIX TO GIVE
!                vectors of original full matrix.
!                FOR j=n STEP -1 UNTIL LOW DO -- **********
do 880 jj = low, n
   j = n + low - jj
   m = min0(j,igh)
!
   do 880 i = low, igh
      zz = 0.0
!
      do 860 k = low, m
860 zz = zz + z(i,k) * h(k,j)
!
      z(i,j) = zz
880 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = en
1001 return
end subroutine hqr2

subroutine deig (ibal,a,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!                Eigenvalues of double precision matrices
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,n), wr(n), wi(n)
!
low = 1
igh = n
if (ibal .ne. 0) call dbal (ka,n,a,low,igh,wr)
call dorth (ka,n,low,igh,a,wr)
call dhqr (ka,n,low,igh,a,wr,wi,ierr)
return
end subroutine deig

subroutine deigv (ibal,a,ka,n,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, j, k, kp1, low
!-----------------------------------------------------------------------
!     Eigenvalues and eigenvectors of double precision matrices
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,n), wr(n), wi(n), &
&zr(ka,n), zi(ka,n)
!
low = 1
igh = n
if (ibal .ne. 0) call dbal (ka,n,a,low,igh,zi)
call dorth (ka,n,low,igh,a,wr)
call dortrn (ka,n,low,igh,a,wr,zr)
call dhqr2 (ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr .ne. 0) return
if (ibal .ne. 0) call dbabk (ka,n,low,igh,zi,n,zr)
!
do 30 k = 1,n
   if (wi(k)) 30,10,20
10 do 11 j = 1,n
11 zi(j,k) = 0.d0
   go to 30
20 kp1 = k + 1
   do 21 j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
21 zi(j,kp1) = -zi(j,k)
30 continue
return
end subroutine deigv

subroutine dbal(nm,n,a,low,igh,scale)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: jj
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
integer :: iexc
double precision, intent(inout) :: a(nm,n), scale(n)
double precision :: c, f, g, r, s, b2, radix
integer :: ipmpar
!     double precision dabs
logical :: noconv
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!
!     Dbal balances a double precision real matrix and isolates
!     eigenvalues whenever possible.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the input matrix to be balanced.
!
!     On output-
!
!        A contains the balanced matrix,
!
!        Low and igh are two integers such that a(i,j)
!          is equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!
!        Scale contains information determining the
!           permutations and scaling factors used.
!
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j),      j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!
!     Note that 1 is returned for igh if igh is zero formally.
!
!     The Algol procedure exc contained in balance appears in
!     dbal in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!
!-----------------------------------------------------------------------
!
!     ********** radix IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the base of the machine floating point representation.
!
           radix = ipmpar(4)
!
!                **********
!
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** IN-LINE PROCEDURE FOR ROW AND
!                COLUMN EXCHANGE **********
20 scale(m) = j
if (j .eq. m) go to 50
!
do i = 1, l
   f = a(i,j)
   a(i,j) = a(i,m)
   a(i,m) = f
end do
!
do i = k, n
   f = a(j,i)
   a(j,i) = a(m,i)
   a(m,i) = f
end do
!
50 go to (80,130), iexc
!     ********** SEARCH FOR ROWS ISOLATING AN EIGENVALUE
!                AND PUSH THEM DOWN **********
80 if (l .eq. 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do 120 jj = 1, l
   j = l + 1 - jj
!
   do 110 i = 1, l
      if (i .eq. j) go to 110
      if (a(j,i) .ne. 0.d0) go to 120
110 continue
!
   m = l
   iexc = 1
   go to 20
120 continue
!
go to 140
!     ********** SEARCH FOR COLUMNS ISOLATING AN EIGENVALUE
!                AND PUSH THEM LEFT **********
130 k = k + 1
!
140 do 170 j = k, l
!
   do 150 i = k, l
      if (i .eq. j) go to 150
      if (a(i,j) .ne. 0.d0) go to 170
150 continue
!
   m = k
   iexc = 2
   go to 20
170 continue
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS k TO l **********
do 180 i = k, l
180 scale(i) = 1.d0
!     ********** ITERATIVE LOOP FOR NORM REDUCTION **********
190 noconv = .false.
!
do 270 i = k, l
   c = 0.d0
   r = 0.d0
!
   do 200 j = k, l
      if (j .eq. i) go to 200
      c = c + dabs(a(j,i))
      r = r + dabs(a(i,j))
200 continue
!     ********** GUARD AGAINST ZERO c OR r DUE TO UNDERFLOW **********
   if (c .eq. 0.d0 .or. r .eq. 0.d0) go to 270
   g = r / radix
   f = 1.d0
   s = c + r
210 if (c .ge. g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c .lt. g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** NOW BALANCE **********
240 if ((c + r) / f .ge. 0.95d0 * s) go to 270
   g = 1.d0 / f
   scale(i) = scale(i) * f
   noconv = .true.
!
   do 250 j = k, n
250 a(i,j) = a(i,j) * g
!
   do 260 j = 1, l
260 a(j,i) = a(j,i) * f
!
270 continue
!
if (noconv) go to 190
!
280 low = k
igh = l
return
end subroutine dbal

subroutine dbalnv (nz,n,z,low,igh,scale)
implicit none
integer :: i, j, k
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nz, igh, low
double precision, intent(inout) :: z(nz,n)
double precision, intent(in) :: scale(n)
double precision :: s
!-----------------------------------------------------------------------
!        Given A matrix A of order n. Dbal transforms A into
!     the matrix B by the similarity transformation
!             b = d**(-1)*transpose(p)*a*p*d
!     where D is a diagonal matrix and P a permutation matrix.
!     The information concerning D and P is stored in igh, low,
!     and scale. The order in which the interchanges were made
!     is n to igh + 1, and then 1 to low - 1.
!
!        z is a matrix of order n. dbalnv transforms z into the
!     matrix W using the inverse similarity transform
!             w = p*d*z*d**(-1)*transpose(p)
!
!     On input-
!
!        nz is the row dimension of the matrix z in the calling
!          program,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by  dbal,
!
!        Scale contains information determining the permutations
!          and scaling factors used by  dbal,
!
!     On output-
!
!        z contains the transformed matrix W
!
!-----------------------------------------------------------------------
!
if (igh .eq. low) go to 30
!
do i = low, igh
s = scale(i)
   do 10 j = 1, n
10 z(i,j) = z(i,j) * s
end do
!
do j = low, igh
s = 1.d0/scale(j)
   do 20 i = 1, n
20 z(i,j) = z(i,j) * s
end do
!
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
!
30 do 60 ii = 1, n
   i = ii
   if (i .ge. low .and. i .le. igh) go to 60
   if (i .lt. low) i = low - ii
   k = scale(i)
   if (k .eq. i) go to 60
!
   do 40 j = 1, n
      s = z(i,j)
      z(i,j) = z(k,j)
40 z(k,j) = s
!
   do 50 j = 1, n
      s = z(j,i)
      z(j,i) = z(j,k)
50 z(j,k) = s
60 continue
return
end subroutine dbalnv

subroutine dorth(nm,n,low,igh,a,ort)
implicit none
!
integer :: i, j, m
integer, intent(in) :: n
integer :: ii, jj, la, mp
integer, intent(in) :: nm, igh
integer :: kp1
integer, intent(in) :: low
double precision, intent(inout) :: a(nm,n), ort(igh)
double precision :: f, g, h, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure orthes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          SET low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  Information about
!          the orthogonal transformations used in the reduction
!          is stored in the remaining triangle under the
!          Hessenberg matrix,
!
!        Ort contains further information about the transformations.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la .lt. kp1) go to 200
!
do 180 m = kp1, la
   h = 0.d0
   ort(m) = 0.d0
   scale = 0.d0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + dabs(a(i,m-1))
!
   if (scale .eq. 0.d0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ort(i) = a(i,m-1) / scale
      h = h + ort(i) * ort(i)
   end do
!
   g = dsqrt(h)
   if (ort(m) .ge. 0.d0) g = -g
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
!
      f = f / h
!
      do 120 i = m, igh
120 a(i,j) = a(i,j) - f * ort(i)
!
   end do
!     ********** FORM (i-(U*UT)/h)*a*(i-(U*UT)/h) **********
   do i = 1, igh
      f = 0.d0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         f = f + ort(j) * a(i,j)
      end do
!
      f = f / h
!
      do 150 j = m, igh
150 a(i,j) = a(i,j) - f * ort(j)
!
   end do
!
   ort(m) = scale * ort(m)
   a(m,m-1) = scale * g
180 continue
!
200 return
end subroutine dorth

subroutine dhqr(nm,n,low,igh,h,wr,wi,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ll, mm, na
integer, intent(in) :: nm, igh
integer :: its
integer, intent(in) :: low
integer :: mp2, enm2
integer, intent(out) :: ierr
double precision, intent(inout) :: h(nm,n), wr(n), wi(n)
double precision :: p, q, r, s, t, w, x, y, zz, norm, machep, &
&dpmpar
!     double precision dsqrt,dabs
!     integer min0
logical :: notlas
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure hqr,
!     NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!
!     dhqr finds the eigenvalues of a double precision real
!     upper Hessenberg matrix BY the QR method.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          SET low=1, igh=n,
!
!        h contains the upper Hessenberg matrix.  Information about
!          the transformations used in the reduction to Hessenberg
!          form by dorth, if performed, is stored
!          in the remaining triangle under the Hessenberg matrix.
!
!     On output-
!
!        h has been destroyed.  Therefore, it must be saved
!          before calling  hqr  if subsequent calculation and
!          back transformation of eigenvectors is to be performed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0
!                in the double precision arithmetic being used.
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
norm = 0.d0
k = 1
!     ********** STORE ROOTS ISOLATED BY DBAL
!                AND COMPUTE MATRIX norm **********
do 50 i = 1, n
!
   do 40 j = k, n
40 norm = norm + dabs(h(i,j))
!
   k = i
   if (i .ge. low .and. i .le. igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.d0
50 continue
!
en = igh
t = 0.d0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
60 if (en .lt. low) go to 1001
its = 0
na = en - 1
enm2 = na - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
70 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 100
   s = dabs(h(l-1,l-1)) + dabs(h(l,l))
   if (s .eq. 0.d0) s = norm
   if (dabs(h(l,l-1)) .le. machep * s) go to 100
end do
!     ********** FORM SHIFT **********
100 x = h(en,en)
if (l .eq. en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l .eq. na) go to 280
if (its .eq. 50) go to 1000
if (its .ne. 10 .and. its .ne. 20 .and. its .ne. 30) go to 130
!     ********** FORM EXCEPTIONAL SHIFT **********
t = t + x
!
do 120 i = low, en
120 h(i,i) = h(i,i) - x
!
s = dabs(h(en,na)) + dabs(h(na,enm2))
x = .75d0 * s
y = x
w = -.4375d0 * s * s
130 its = its + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m+1,m) + h(m,m+1)
   q = h(m+1,m+1) - zz - r - s
   r = h(m+2,m+1)
   s = dabs(p) + dabs(q) + dabs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m .eq. l) go to 150
   if (dabs(h(m,m-1)) * (dabs(q) + dabs(r)) .le. machep * dabs(p) &
&* (dabs(h(m-1,m-1)) + dabs(zz) + dabs(h(m+1,m+1)))) go to 150
end do
!
150 mp2 = m + 2
!
do 160 i = mp2, en
   h(i,i-2) = 0.d0
   if (i .eq. mp2) go to 160
   h(i,i-3) = 0.d0
160 continue
!     ********** DOUBLE QR STEP INVOLVING ROWS l TO en AND
!                COLUMNS m TO en **********
do 260 k = m, na
   notlas = k .ne. na
   if (k .eq. m) go to 170
   p = h(k,k-1)
   q = h(k+1,k-1)
   r = 0.d0
   if (notlas) r = h(k+2,k-1)
   x = dabs(p) + dabs(q) + dabs(r)
   if (x .eq. 0.d0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = dsqrt(p*p + q*q + r*r)
   if (p .lt. 0.d0) s = -s
   if (k .eq. m) go to 180
   h(k,k-1) = -s * x
   go to 190
180 if (l .ne. m) h(k,k-1) = -h(k,k-1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** ROW MODIFICATION **********
   do j = k, en
      p = h(k,j) + q * h(k+1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k+2,j)
      h(k+2,j) = h(k+2,j) - p * zz
200 h(k+1,j) = h(k+1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
!
   j = min0(en,k+3)
!     ********** COLUMN MODIFICATION **********
   do i = l, j
      p = x * h(i,k) + y * h(i,k+1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k+2)
      h(i,k+2) = h(i,k+2) - p * r
220 h(i,k+1) = h(i,k+1) - p * q
      h(i,k) = h(i,k) - p
   end do
!
260 continue
!
go to 70
!     ********** ONE ROOT FOUND **********
270 wr(en) = x + t
wi(en) = 0.d0
en = na
go to 60
!     ********** TWO ROOTS FOUND **********
280 p = (y - x) / 2.d0
q = p * p + w
zz = dsqrt(dabs(q))
x = x + t
if (q .lt. 0.d0) go to 320
!     ********** REAL PAIR **********
if (p .lt. 0.d0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz .ne. 0.d0) wr(en) = x - w / zz
wi(na) = 0.d0
wi(en) = 0.d0
go to 330
!     ********** COMPLEX PAIR **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
1000 ierr = en
1001 return
end subroutine dhqr

subroutine dbabk(nm,n,low,igh,scale,m,z)
implicit none
!
integer :: i, j, k
integer, intent(in) :: m, n
integer :: ii
integer, intent(in) :: nm, igh, low
double precision, intent(in) :: scale(n)
double precision, intent(inout) :: z(nm,m)
double precision :: s
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!
!     This subroutine forms the eigenvectors of a real general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by dbal.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by dbal,
!
!        Scale contains information determining the permutations
!          and scaling factors used by dbal,
!
!        m is the number of columns of z to be back transformed,
!
!        z contains the real and imaginary parts of the eigen-
!          vectors to be back transformed in its first m columns.
!
!     On output-
!
!        z contains the real and imaginary parts of the
!          transformed eigenvectors in its first m columns.
!
!-----------------------------------------------------------------------
!
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do 100 j = 1, m
100 z(i,j) = z(i,j) * s
!
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
120 do 140 ii = 1, n
   i = ii
   if (i .ge. low .and. i .le. igh) go to 140
   if (i .lt. low) i = low - ii
   k = scale(i)
   if (k .eq. i) go to 140
!
   do j = 1, m
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
!
140 continue
!
200 return
end subroutine dbabk

subroutine dortrn(nm,n,low,igh,a,ort,z)
implicit none
!
integer :: i, j
integer, intent(in) :: n
integer :: kl, mm, mp
integer, intent(in) :: nm, igh, low
integer :: mp1
double precision, intent(in) :: a(nm,igh)
double precision, intent(inout) :: ort(igh), z(nm,n)
double precision :: g
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real double
!     precision matrix to upper Hessenberg form by dorth.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          SET low=1, igh=n,
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction by dorth
!          in its strict lower triangle,
!
!        Ort contains further information about the trans-
!          formations used in the reduction by dorth.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by dorth,
!
!        Ort has been altered.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE z TO IDENTITY MATRIX **********
do i = 1, n
!
   do 60 j = 1, n
60 z(i,j) = 0.d0
!
   z(i,i) = 1.d0
end do
!
kl = igh - low - 1
if (kl .lt. 1) go to 200
!     ********** FOR mp=igh-1 STEP -1 UNTIL low+1 DO -- **********
do 140 mm = 1, kl
   mp = igh - mm
   if (a(mp,mp-1) .eq. 0.d0) go to 140
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100 ort(i) = a(i,mp-1)
!
   do j = mp, igh
      g = 0.d0
!
      do 110 i = mp, igh
110 g = g + ort(i) * z(i,j)
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN orthes.
!                DOUBLE DIVISION AVOIDS POSSIBLE UNDERFLOW **********
      g = (g / ort(mp)) / a(mp,mp-1)
!
      do 120 i = mp, igh
120 z(i,j) = z(i,j) + g * ort(i)
!
   end do
!
140 continue
!
200 return
end subroutine dortrn

subroutine drtrn1(n,low,igh,a,na,z,nz,ort)
implicit none
!
integer :: i, j
integer, intent(in) :: n
integer :: kl, mm, mp
integer, intent(in) :: na, igh, low
integer :: mp1
integer, intent(in) :: nz
double precision, intent(in) :: a(na,igh)
double precision, intent(inout) :: ort(igh), z(nz,n)
double precision :: g
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real double
!     precision matrix to upper Hessenberg form by dorth.
!
!     On input-
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          SET low=1, igh=n,
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction by dorth
!          in its strict lower triangle,
!
!        na must be set to the row dimension of the 2-dimensional
!          array parameter  a  as declared in the calling program
!          dimension statement,
!
!        nz must be set to the row dimension of the 2-dimensional
!          array parameter  z  as declared in the calling program
!          dimension statement,
!
!        Ort contains further information about the trans-
!          formations used in the reduction by dorth.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by dorth,
!
!        Ort has been altered.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE z TO IDENTITY MATRIX **********
do i = 1, n
!
   do 60 j = 1, n
60 z(i,j) = 0.d0
!
   z(i,i) = 1.d0
end do
!
kl = igh - low - 1
if (kl .lt. 1) go to 200
!     ********** FOR mp=igh-1 STEP -1 UNTIL low+1 DO -- **********
do 140 mm = 1, kl
   mp = igh - mm
   if (a(mp,mp-1) .eq. 0.d0) go to 140
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100 ort(i) = a(i,mp-1)
!
   do j = mp, igh
      g = 0.d0
!
      do 110 i = mp, igh
110 g = g + ort(i) * z(i,j)
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN orthes.
!                DOUBLE DIVISION AVOIDS POSSIBLE UNDERFLOW **********
      g = (g / ort(mp)) / a(mp,mp-1)
!
      do 120 i = mp, igh
120 z(i,j) = z(i,j) + g * ort(i)
!
   end do
!
140 continue
!
200 return
end subroutine drtrn1

subroutine dhqr2(nm,n,low,igh,h,wr,wi,z,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ii, jj, ll, mm, na
integer, intent(in) :: nm
integer :: nn
integer, intent(in) :: igh
integer :: its
integer, intent(in) :: low
integer :: mp2, enm2
integer, intent(out) :: ierr
double precision, intent(inout) :: h(nm,n), wr(n), wi(n), z(nm,n)
double precision :: a, b, d, p, q, r, s, t, u, w, x, y
double precision :: ra, sa, vi, vr, zz, norm, machep
!     integer min0
!     double precision dsqrt,dabs
double precision :: dpmpar
logical :: notlas
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure hqr2,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a real double precision upper Hessenberg matrix BY the
!     QR method.  The eigenvectors of a real general matrix can
!     also be found if dorth and dortrn have been used to reduce
!     this general matrix to Hessenberg form and to accumulate
!     the similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dbal.  If dbal has not been used then
!          SET low=1, igh=n,
!
!        h contains the upper Hessenberg matrix,
!
!        z contains the transformation matrix produced by dortrn
!          after the reduction by dorth, if performed. If the
!          eigenvectors of the Hessenberg matrix are desired,
!          z must contain the identity matrix.
!
!     On output-
!
!        h has been destroyed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        z contains the real and imaginary parts of the eigenvectors.
!          If the i-TH eigenvalue is real, the i-TH column of z
!          contains its eigenvector.  If the i-TH eigenvalue is complex
!          with positive imaginary part, the i-TH and (i+1)-TH
!          columns of z contain the real and imaginary parts of its
!          eigenvector.  The eigenvectors are unnormalized.  If an
!          error exit is made, none of the eigenvectors has been found,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value u where u is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + u .GT. 1.0
!                in the double precision arithmetic being used.
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
norm = 0.d0
k = 1
!     ********** STORE ROOTS ISOLATED BY DBAL
!                AND COMPUTE MATRIX norm **********
do 50 i = 1, n
!
   do 40 j = k, n
40 norm = norm + dabs(h(i,j))
!
   k = i
   if (i .ge. low .and. i .le. igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.d0
50 continue
!
en = igh
t = 0.d0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
60 if (en .lt. low) go to 340
its = 0
na = en - 1
enm2 = na - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
70 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 100
   s = dabs(h(l-1,l-1)) + dabs(h(l,l))
   if (s .eq. 0.d0) s = norm
   if (dabs(h(l,l-1)) .le. machep * s) go to 100
end do
!     ********** FORM SHIFT **********
100 x = h(en,en)
if (l .eq. en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l .eq. na) go to 280
if (its .eq. 50) go to 1000
if (its .ne. 10 .and. its .ne. 20 .and. its .ne. 30) go to 130
!     ********** FORM EXCEPTIONAL SHIFT **********
t = t + x
!
do 120 i = low, en
120 h(i,i) = h(i,i) - x
!
s = dabs(h(en,na)) + dabs(h(na,enm2))
x = .75d0 * s
y = x
w = -.4375d0 * s * s
130 its = its + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m+1,m) + h(m,m+1)
   q = h(m+1,m+1) - zz - r - s
   r = h(m+2,m+1)
   s = dabs(p) + dabs(q) + dabs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m .eq. l) go to 150
   if (dabs(h(m,m-1)) * (dabs(q) + dabs(r)) .le. machep * dabs(p) &
&* (dabs(h(m-1,m-1)) + dabs(zz) + dabs(h(m+1,m+1)))) go to 150
end do
!
150 mp2 = m + 2
!
do 160 i = mp2, en
   h(i,i-2) = 0.d0
   if (i .eq. mp2) go to 160
   h(i,i-3) = 0.d0
160 continue
!     ********** DOUBLE QR STEP INVOLVING ROWS l TO en AND
!                COLUMNS m TO en **********
do 260 k = m, na
   notlas = k .ne. na
   if (k .eq. m) go to 170
   p = h(k,k-1)
   q = h(k+1,k-1)
   r = 0.d0
   if (notlas) r = h(k+2,k-1)
   x = dabs(p) + dabs(q) + dabs(r)
   if (x .eq. 0.d0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = dsqrt(p*p + q*q + r*r)
   if (p .lt. 0.d0) s = -s
   if (k .eq. m) go to 180
   h(k,k-1) = -s * x
   go to 190
180 if (l .ne. m) h(k,k-1) = -h(k,k-1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** ROW MODIFICATION **********
   do j = k, n
      p = h(k,j) + q * h(k+1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k+2,j)
      h(k+2,j) = h(k+2,j) - p * zz
200 h(k+1,j) = h(k+1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
!
   j = min0(en,k+3)
!     ********** COLUMN MODIFICATION **********
   do i = 1, j
      p = x * h(i,k) + y * h(i,k+1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k+2)
      h(i,k+2) = h(i,k+2) - p * r
220 h(i,k+1) = h(i,k+1) - p * q
      h(i,k) = h(i,k) - p
   end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
   do i = low, igh
      p = x * z(i,k) + y * z(i,k+1)
      if (.not. notlas) go to 240
      p = p + zz * z(i,k+2)
      z(i,k+2) = z(i,k+2) - p * r
240 z(i,k+1) = z(i,k+1) - p * q
      z(i,k) = z(i,k) - p
   end do
!
260 continue
!
go to 70
!     ********** ONE ROOT FOUND **********
270 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.d0
en = na
go to 60
!     ********** TWO ROOTS FOUND **********
280 p = (y - x) / 2.d0
q = p * p + w
zz = dsqrt(dabs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q .lt. 0.d0) go to 320
!     ********** REAL PAIR **********
if (p .lt. 0.d0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz .ne. 0.d0) wr(en) = x - w / zz
wi(na) = 0.d0
wi(en) = 0.d0
x = h(en,na)
s = dabs(x) + dabs(zz)
p = x / s
q = zz / s
r = dsqrt(p*p+q*q)
p = p / r
q = q / r
!     ********** ROW MODIFICATION **********
do j = na, n
   zz = h(na,j)
   h(na,j) = q * zz + p * h(en,j)
   h(en,j) = q * h(en,j) - p * zz
end do
!     ********** COLUMN MODIFICATION **********
do i = 1, en
   zz = h(i,na)
   h(i,na) = q * zz + p * h(i,en)
   h(i,en) = q * h(i,en) - p * zz
end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
do i = low, igh
   zz = z(i,na)
   z(i,na) = q * zz + p * z(i,en)
   z(i,en) = q * z(i,en) - p * zz
end do
!
go to 330
!     ********** COMPLEX PAIR **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** ALL ROOTS FOUND.  BACKSUBSTITUTE TO FIND
!                VECTORS OF UPPER TRIANGULAR FORM **********
340 if (norm .eq. 0.d0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 1 DO -- **********
do 800 nn = 1, n
   en = n + 1 - nn
   p = wr(en)
   q = wi(en)
   na = en - 1
   if (q) 710, 600, 800
!     ********** REAL VECTOR **********
600 m = en
   h(en,en) = 1.d0
   if (na .eq. 0) go to 800
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do 700 ii = 1, na
      i = en - ii
      w = h(i,i) - p
      r = h(i,en)
      if (m .gt. na) go to 620
!
      do 610 j = m, na
610 r = r + h(i,j) * h(j,en)
!
620 if (wi(i) .ge. 0.d0) go to 630
      zz = w
      s = r
      go to 700
630 m = i
      if (wi(i) .ne. 0.d0) go to 640
      t = w
      if (w .eq. 0.d0) t = machep * norm
      h(i,en) = -r / t
      go to 700
!     ********** SOLVE REAL EQUATIONS **********
640 x = h(i,i+1)
      y = h(i+1,i)
      q = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i)
      t = (x * s - zz * r) / q
      h(i,en) = t
      if (dabs(x) .le. dabs(zz)) go to 650
      h(i+1,en) = (-r - w * t) / x
      go to 700
650 h(i+1,en) = (-s - y * t) / zz
700 continue
!     ********** END REAL VECTOR **********
   go to 800
!     ********** COMPLEX VECTOR **********
710 m = na
!     ********** LAST VECTOR COMPONENT CHOSEN IMAGINARY SO THAT
!                EIGENVECTOR MATRIX IS TRIANGULAR **********
   if (dabs(h(en,na)) .le. dabs(h(na,en))) go to 720
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
   if (enm2 .eq. 0) go to 800
!     ********** FOR i=en-2 STEP -1 UNTIL 1 DO -- **********
   do 790 ii = 1, enm2
      i = na - ii
      w = h(i,i) - p
      ra = 0.d0
      sa = h(i,en)
!
      do j = m, na
         ra = ra + h(i,j) * h(j,na)
         sa = sa + h(i,j) * h(j,en)
      end do
!
      if (wi(i) .ge. 0.d0) go to 770
      zz = w
      r = ra
      s = sa
      go to 790
770 m = i
      if (wi(i) .ne. 0.d0) go to 780
      d = w * w + q * q
      h(i,na) = -(ra * w + sa * q) / d
      h(i,en) = (ra * q - sa * w) / d
      go to 790
!     ********** SOLVE COMPLEX EQUATIONS **********
780 x = h(i,i+1)
      y = h(i+1,i)
      vr = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i) - q * q
      vi = (wr(i) - p) * 2.d0 * q
      if (vr .eq. 0.d0 .and. vi .eq. 0.d0) vr = machep * norm &
&* (dabs(w) + dabs(q) + dabs(x) + dabs(y) + dabs(zz))
      a = x * r - zz * ra + q * sa
      b = x * s - zz * sa - q * ra
      d = vr * vr + vi * vi
      h(i,na) = (a * vr + b * vi) / d
      h(i,en) = (b * vr - a * vi) / d
      if (dabs(x) .le. dabs(zz) + dabs(q)) go to 785
      h(i+1,na) = (-ra - w * h(i,na) + q * h(i,en)) / x
      h(i+1,en) = (-sa - w * h(i,en) - q * h(i,na)) / x
      go to 790
785 a = -r - y * h(i,na)
      b = -s - y * h(i,en)
      d = zz * zz + q * q
      h(i+1,na) = (a * zz + b * q) / d
      h(i+1,en) = (b * zz - a * q) / d
790 continue
!     ********** END COMPLEX VECTOR **********
800 continue
!     ********** END BACK SUBSTITUTION.
!                VECTORS OF ISOLATED ROOTS **********
do 840 i = 1, n
   if (i .ge. low .and. i .le. igh) go to 840
!
   do 820 j = i, n
820 z(i,j) = h(i,j)
!
840 continue
!     ********** MULTIPLY BY TRANSFORMATION MATRIX TO GIVE
!                vectors of original full matrix.
!                FOR j=n STEP -1 UNTIL LOW DO -- **********
do 880 jj = low, n
   j = n + low - jj
   m = min0(j,igh)
!
   do 880 i = low, igh
      zz = 0.d0
!
      do 860 k = low, m
860 zz = zz + z(i,k) * h(k,j)
!
      z(i,j) = zz
880 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
1000 ierr = en
1001 return
end subroutine dhqr2

subroutine seig (a, ka, n, w, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka
integer :: n
integer :: l
!-----------------------------------------------------------------------
!               Eigenvalues of symmetric real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(*), w(n), t(*)
!
if (ka .eq. 0) go to 10
   call tred1 (ka, n, a, w, t(n+1), t(1))
   call tqlrat (n, w, t, ierr)
   return
10 l = n*(n + 1)
l = l/2
call tred3 (n, l, a, w, t(n+1), t(1))
call tqlrat (n, w, t, ierr)
return
end subroutine seig

subroutine seig1 (a, ka, n, w, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: l
!-----------------------------------------------------------------------
!               Eigenvalues of symmetric real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(*), w(n), t(n)
!
if (ka .eq. 0) go to 10
   call tred1 (ka, n, a, w, t, t)
   call imtql1 (n, w, t, ierr)
   return
10 l = n*(n + 1)
l = l/2
call tred3 (n, l, a, w, t, t)
call imtql1 (n, w, t, ierr)
return
end subroutine seig1

subroutine seigv (a, ka, n, w, z, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
!-----------------------------------------------------------------------
!        Eigenvalues and eigenvectors of symmetric real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n)
real, intent(inout) :: w(n), z(ka,n), t(n)
!
call tred2 (ka, n, a, w, t, z)
call tql2 (ka, n, w, t, z, ierr)
return
end subroutine seigv

subroutine seigv1 (a, ka, n, w, z, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
!-----------------------------------------------------------------------
!        Eigenvalues and eigenvectors of symmetric real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n)
real, intent(inout) :: w(n), z(ka,n), t(n)
!
call tred2 (ka, n, a, w, t, z)
call imtql2 (ka, n, w, t, z, ierr)
return
end subroutine seigv1

subroutine tred1(nm,n,a,d,e,e2)
implicit none
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nm
integer :: jp1
real, intent(inout) :: a(nm,n), d(n), e(n), e2(n)
real :: f, g, h, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tred1,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!
!     This subroutine reduces a real symmetric matrix
!     to a symmetric tridiagonal matrix using
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!
!     On output-
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction in its strict lower
!          triangle.  The full upper triangle of A is unaltered,
!
!        d contains the diagonal elements of the tridiagonal matrix,
!
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!
!-----------------------------------------------------------------------
!
do 100 i = 1, n
100 d(i) = a(i,i)
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   h = 0.0
   scale = 0.0
   if (l .lt. 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do 120 k = 1, l
120 scale = scale + abs(a(i,k))
!
   if (scale .ne. 0.0) go to 140
130 e(i) = 0.0
   e2(i) = 0.0
   go to 290
!
140 do k = 1, l
      a(i,k) = a(i,k) / scale
      h = h + a(i,k) * a(i,k)
   end do
!
   e2(i) = scale * scale * h
   f = a(i,l)
   g = sqrt(h)
   if (f .ge. 0.0) g = -g
   e(i) = scale * g
   h = h - f * g
   a(i,l) = f - g
   if (l .eq. 1) go to 270
   f = 0.0
!
   do j = 1, l
      g = 0.0
!     ********** FORM ELEMENT OF a*U **********
      do 180 k = 1, j
180 g = g + a(j,k) * a(i,k)
!
      jp1 = j + 1
      if (l .lt. jp1) go to 220
!
      do 200 k = jp1, l
200 g = g + a(k,j) * a(i,k)
!     ********** FORM ELEMENT OF P **********
220 e(j) = g / h
      f = f + e(j) * a(i,j)
   end do
!
   h = f / (h + h)
!     ********** FORM REDUCED a **********
   do 260 j = 1, l
      f = a(i,j)
      g = e(j) - h * f
      e(j) = g
!
      do 260 k = 1, j
         a(j,k) = a(j,k) - f * e(k) - g * a(i,k)
260 continue
!
270 do 280 k = 1, l
280 a(i,k) = scale * a(i,k)
!
290 h = d(i)
   d(i) = a(i,i)
   a(i,i) = h
end do
!
return
!     ********** LAST CARD OF tred1 **********
end subroutine tred1

subroutine tred3(n,nv,a,d,e,e2)
implicit none
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: ii, iz, jk
integer, intent(in) :: nv
real, intent(inout) :: a(nv), d(n), e(n), e2(n)
real :: f, g, h, hh, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tred3,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!
!     This subroutine reduces a real symmetric matrix, stored as
!     a one-dimensional array, to a symmetric tridiagonal matrix
!     using orthogonal similarity transformations.
!
!     On input-
!
!        n is the order of the matrix,
!
!        nv must be set to the dimension of the array parameter A
!          as declared in the calling program dimension statement,
!
!        A contains the lower triangle of the real symmetric
!          input matrix, stored row-wise as a one-dimensional
!          array, in its first n*(n+1)/2 positions.
!
!     On output-
!
!        A contains information about the orthogonal
!          transformations used in the reduction,
!
!        d contains the diagonal elements of the tridiagonal matrix,
!
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!
!-----------------------------------------------------------------------
!
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   iz = (i * l) / 2
   h = 0.0
   scale = 0.0
   if (l .lt. 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      iz = iz + 1
      d(k) = a(iz)
      scale = scale + abs(d(k))
   end do
!
   if (scale .ne. 0.0) go to 140
130 e(i) = 0.0
   e2(i) = 0.0
   go to 290
!
140 do k = 1, l
      d(k) = d(k) / scale
      h = h + d(k) * d(k)
   end do
!
   e2(i) = scale * scale * h
   f = d(l)
   g = sqrt(h)
   if (f .ge. 0.0) g = -g
   e(i) = scale * g
   h = h - f * g
   d(l) = f - g
   a(iz) = scale * d(l)
   if (l .eq. 1) go to 290
   f = 0.0
!
   do j = 1, l
      g = 0.0
      jk = (j * (j-1)) / 2
!     ********** FORM ELEMENT OF a*U **********
      do k = 1, l
         jk = jk + 1
         if (k .gt. j) jk = jk + k - 2
         g = g + a(jk) * d(k)
      end do
!     ********** FORM ELEMENT OF P **********
      e(j) = g / h
      f = f + e(j) * d(j)
   end do
!
   hh = f / (h + h)
   jk = 0
!     ********** FORM REDUCED a **********
   do 260 j = 1, l
      f = d(j)
      g = e(j) - hh * f
      e(j) = g
!
      do 260 k = 1, j
         jk = jk + 1
         a(jk) = a(jk) - f * e(k) - g * d(k)
260 continue
!
290 d(i) = a(iz+1)
   a(iz+1) = scale * sqrt(h)
end do
!
return
!     ********** LAST CARD OF tred3 **********
end subroutine tred3

subroutine tqlrat(n,d,e2,ierr)
implicit none
real :: spmpar
!
integer :: i, j, l, m
integer, intent(in) :: n
integer :: ii, l1, mml
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e2(n)
real :: b, c, f, g, h, p, r, s, machep
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tqlrat,
!     algorithm 464, comm. ACM 16, 689(1973) by Reinsch.
!
!     This subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!
!     On input-
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e2 contains the squares of the subdiagonal elements of the
!          input matrix in its last n-1 positions.  e2(1) is arbitrary.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!
!        e2 has been destroyed,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 1001
!
do 100 i = 2, n
100 e2(i-1) = e2(i)
!
f = 0.0
b = 0.0
e2(n) = 0.0
!
do l = 1, n
   j = 0
   h = machep * (abs(d(l)) + sqrt(e2(l)))
   if (b .gt. h) go to 105
   b = h
   c = b * b
!     ********** LOOK FOR SMALL SQUARED SUB-DIAGONAL ELEMENT **********
105 do m = l, n
      if (e2(m) .le. c) go to 120
!     ********** e2(n) IS ALWAYS ZERO, SO THERE IS NO EXIT
!                THROUGH THE BOTTOM OF THE LOOP **********
   end do
!
120 if (m .eq. l) go to 210
130 if (j .eq. 30) go to 1000
   j = j + 1
!     ********** FORM SHIFT **********
   l1 = l + 1
   s = sqrt(e2(l))
   g = d(l)
   p = (d(l1) - g) / (2.0 * s)
   r = sqrt(p*p+1.0)
   if (p .lt. 0.0) r = -r
   d(l) = s / (p + r)
   h = g - d(l)
!
   do 140 i = l1, n
140 d(i) = d(i) - h
!
   f = f + h
!     ********** RATIONAL QL TRANSFORMATION **********
   g = d(m)
   if (g .eq. 0.0) g = b
   h = g
   s = 0.0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      p = g * h
      r = p + e2(i)
      e2(i+1) = s * r
      s = e2(i) / r
      d(i+1) = h + s * (h + d(i))
      g = d(i) - e2(i) / g
      if (g .eq. 0.0) g = b
      h = g * p / r
   end do
!
   e2(l) = s * g
   d(l) = h
!     ********** GUARD AGAINST UNDERFLOW IN CONVERGENCE TEST **********
   if (h .eq. 0.0) go to 210
   if (abs(e2(l)) .le. abs(c/h)) go to 210
   e2(l) = h * e2(l)
   if (e2(l) .ne. 0.0) go to 130
210 p = d(l) + f
!     ********** ORDER EIGENVALUES **********
   if (l .eq. 1) go to 250
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2, l
      i = l + 2 - ii
      if (p .ge. d(i-1)) go to 270
      d(i) = d(i-1)
   end do
!
250 i = 1
270 d(i) = p
end do
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = l
1001 return
!     ********** LAST CARD OF tqlrat **********
end subroutine tqlrat

subroutine imtql1(n,d,e,ierr)
implicit none
real :: spmpar
!
integer :: i, j, l, m
integer, intent(in) :: n
integer :: ii, mml
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e(n)
real :: b, c, f, g, p, r, s, machep
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure imtql1,
!     NUM. Math. 12, 377-383(1968) By Martin and Wilkinson,
!     as modified in NUM. Math. 15, 450(1970) By Dubrulle.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 241-248(1971).
!
!     This subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the implicit QL method.
!
!     On input-
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!
!        e has been destroyed,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 1001
!
do 100 i = 2, n
100 e(i-1) = e(i)
!
e(n) = 0.0
!
do l = 1, n
   j = 0
!     ********** LOOK FOR SMALL SUB-DIAGONAL ELEMENT **********
105 do m = l, n
      if (m .eq. n) go to 120
      if (abs(e(m)) .le. machep * (abs(d(m)) + abs(d(m+1)))) &
&go to 120
   end do
!
120 p = d(l)
   if (m .eq. l) go to 215
   if (j .eq. 30) go to 1000
   j = j + 1
!     ********** FORM SHIFT **********
   g = (d(l+1) - p) / (2.0 * e(l))
   r = sqrt(g*g+1.0)
   if (g .lt. 0.0) r = -r
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
      if (abs(f) .lt. abs(g)) go to 150
      c = g / f
      r = sqrt(c*c+1.0)
      e(i+1) = f * r
      s = 1.0 / r
      c = c * s
      go to 160
150 s = f / g
      r = sqrt(s*s+1.0)
      e(i+1) = g * r
      c = 1.0 / r
      s = s * c
160 g = d(i+1) - p
      r = (d(i) - g) * s + 2.0 * c * b
      p = s * r
      d(i+1) = g + p
      g = c * r - b
   end do
!
   d(l) = d(l) - p
   e(l) = g
   e(m) = 0.0
   go to 105
!     ********** ORDER EIGENVALUES **********
215 if (l .eq. 1) go to 250
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2, l
      i = l + 2 - ii
      if (p .ge. d(i-1)) go to 270
      d(i) = d(i-1)
   end do
!
250 i = 1
270 d(i) = p
end do
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = l
1001 return
!     ********** LAST CARD OF imtql1 **********
end subroutine imtql1

subroutine tred2(nm,n,a,d,e,z)
implicit none
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nm
integer :: jp1
real, intent(in) :: a(nm,n)
real, intent(inout) :: d(n), e(n), z(nm,n)
real :: f, g, h, hh, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tred2,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!
!     This subroutine reduces a real symmetric matrix to A
!     symmetric tridiagonal matrix using and accumulating
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!
!     On output-
!
!        d contains the diagonal elements of the tridiagonal matrix,
!
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!
!        z contains the orthogonal transformation matrix
!          produced in the reduction,
!
!        A and z may coincide.  If distinct, A is unaltered.
!
!-----------------------------------------------------------------------
!
do 100 i = 1, n
!
   do 100 j = 1, i
      z(i,j) = a(i,j)
100 continue
!
if (n .eq. 1) go to 320
!     ********** FOR i=n STEP -1 UNTIL 2 DO -- **********
do ii = 2, n
   i = n + 2 - ii
   l = i - 1
   h = 0.0
   scale = 0.0
   if (l .lt. 2) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do 120 k = 1, l
120 scale = scale + abs(z(i,k))
!
   if (scale .ne. 0.0) go to 140
130 e(i) = z(i,l)
   go to 290
!
140 do k = 1, l
      z(i,k) = z(i,k) / scale
      h = h + z(i,k) * z(i,k)
   end do
!
   f = z(i,l)
   g = sqrt(h)
   if (f .ge. 0.0) g = -g
   e(i) = scale * g
   h = h - f * g
   z(i,l) = f - g
   f = 0.0
!
   do j = 1, l
      z(j,i) = z(i,j) / h
      g = 0.0
!     ********** FORM ELEMENT OF a*U **********
      do 180 k = 1, j
180 g = g + z(j,k) * z(i,k)
!
      jp1 = j + 1
      if (l .lt. jp1) go to 220
!
      do 200 k = jp1, l
200 g = g + z(k,j) * z(i,k)
!     ********** FORM ELEMENT OF P **********
220 e(j) = g / h
      f = f + e(j) * z(i,j)
   end do
!
   hh = f / (h + h)
!     ********** FORM REDUCED a **********
   do 260 j = 1, l
      f = z(i,j)
      g = e(j) - hh * f
      e(j) = g
!
      do 260 k = 1, j
         z(j,k) = z(j,k) - f * e(k) - g * z(i,k)
260 continue
!
290 d(i) = h
end do
!
320 d(1) = 0.0
e(1) = 0.0
!     ********** ACCUMULATION OF TRANSFORMATION MATRICES **********
do 500 i = 1, n
   l = i - 1
   if (d(i) .eq. 0.0) go to 380
!
   do 360 j = 1, l
      g = 0.0
!
      do 340 k = 1, l
340 g = g + z(i,k) * z(k,j)
!
      do 360 k = 1, l
         z(k,j) = z(k,j) - g * z(k,i)
360 continue
!
380 d(i) = z(i,i)
   z(i,i) = 1.0
   if (l .lt. 1) go to 500
!
   do j = 1, l
      z(i,j) = 0.0
      z(j,i) = 0.0
   end do
!
500 continue
!
return
!     ********** LAST CARD OF tred2 **********
end subroutine tred2

subroutine tql2(nm,n,d,e,z,ierr)
implicit none
real :: spmpar
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: ii, l1
integer, intent(in) :: nm
integer :: mml
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e(n), z(nm,n)
real :: b, c, f, g, h, p, r, s, machep
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tql2,
!     NUM. Math. 11, 293-306(1968) By Bowdler, Martin, Reinsch, and
!     Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 227-240(1971).
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a symmetric tridiagonal matrix BY the QL method.
!     The eigenvectors of a full symmetric matrix can also
!     be found if  tred2  has been used to reduce this
!     full matrix to tridiagonal form.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary,
!
!        z contains the transformation matrix produced in the
!          reduction by  tred2, if performed.  If the eigenvectors
!          of the tridiagonal matrix are desired, z must contain
!          the identity matrix.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct but
!          unordered for indices 1,2,...,ierr-1,
!
!        e has been destroyed,
!
!        z contains orthonormal eigenvectors of the symmetric
!          tridiagonal (or full) matrix.  If an error exit is made,
!          z contains the eigenvectors associated with the stored
!          eigenvalues,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 1001
!
do 100 i = 2, n
100 e(i-1) = e(i)
!
f = 0.0
b = 0.0
e(n) = 0.0
!
do l = 1, n
   j = 0
   h = machep * (abs(d(l)) + abs(e(l)))
   if (b .lt. h) b = h
!     ********** LOOK FOR SMALL SUB-DIAGONAL ELEMENT **********
   do m = l, n
      if (abs(e(m)) .le. b) go to 120
!     ********** e(n) IS ALWAYS ZERO, SO THERE IS NO EXIT
!                THROUGH THE BOTTOM OF THE LOOP **********
   end do
!
120 if (m .eq. l) go to 220
130 if (j .eq. 30) go to 1000
   j = j + 1
!     ********** FORM SHIFT **********
   l1 = l + 1
   g = d(l)
   p = (d(l1) - g) / (2.0 * e(l))
   r = sqrt(p*p+1.0)
   if (p .lt. 0.0) r = -r
   d(l) = e(l) / (p + r)
   h = g - d(l)
!
   do 140 i = l1, n
140 d(i) = d(i) - h
!
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
      if (abs(p) .lt. abs(e(i))) go to 150
      c = e(i) / p
      r = sqrt(c*c+1.0)
      e(i+1) = s * p * r
      s = c / r
      c = 1.0 / r
      go to 160
150 c = p / e(i)
      r = sqrt(c*c+1.0)
      e(i+1) = s * e(i) * r
      s = 1.0 / r
      c = c * s
160 p = c * d(i) - s * g
      d(i+1) = h + s * (c * g + s * d(i))
!     ********** FORM VECTOR **********
      do k = 1, n
         h = z(k,i+1)
         z(k,i+1) = s * z(k,i) + c * h
         z(k,i) = c * z(k,i) - s * h
      end do
!
   end do
!
   e(l) = s * p
   d(l) = c * p
   if (abs(e(l)) .gt. b) go to 130
220 d(l) = d(l) + f
end do
!     ********** ORDER EIGENVALUES AND EIGENVECTORS **********
do 300 ii = 2, n
   i = ii - 1
   k = i
   p = d(i)
!
   do 260 j = ii, n
      if (d(j) .ge. p) go to 260
      k = j
      p = d(j)
260 continue
!
   if (k .eq. i) go to 300
   d(k) = d(i)
   d(i) = p
!
   do j = 1, n
      p = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = p
   end do
!
300 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = l
1001 return
!     ********** LAST CARD OF tql2 **********
end subroutine tql2

subroutine imtql2(nm,n,d,e,z,ierr)
implicit none
real :: spmpar
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nm
integer :: mml
integer, intent(out) :: ierr
real, intent(inout) :: d(n), e(n), z(nm,n)
real :: b, c, f, g, p, r, s, machep
!     real sqrt,abs,spmpar
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure imtql2,
!     NUM. Math. 12, 377-383(1968) By Martin and Wilkinson,
!     as modified in NUM. Math. 15, 450(1970) By Dubrulle.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 241-248(1971).
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a symmetric tridiagonal matrix BY the implicit QL method.
!     The eigenvectors of a full symmetric matrix can also
!     be found if  tred2  has been used to reduce this
!     full matrix to tridiagonal form.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary,
!
!        z contains the transformation matrix produced in the
!          reduction by  tred2, if performed.  If the eigenvectors
!          of the tridiagonal matrix are desired, z must contain
!          the identity matrix.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct but
!          unordered for indices 1,2,...,ierr-1,
!
!        e has been destroyed,
!
!        z contains orthonormal eigenvectors of the symmetric
!          tridiagonal (or full) matrix.  If an error exit is made,
!          z contains the eigenvectors associated with the stored
!          eigenvalues,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 1001
!
do 100 i = 2, n
100 e(i-1) = e(i)
!
e(n) = 0.0
!
do 240 l = 1, n
   j = 0
!     ********** LOOK FOR SMALL SUB-DIAGONAL ELEMENT **********
105 do m = l, n
      if (m .eq. n) go to 120
      if (abs(e(m)) .le. machep * (abs(d(m)) + abs(d(m+1)))) &
&go to 120
   end do
!
120 p = d(l)
   if (m .eq. l) go to 240
   if (j .eq. 30) go to 1000
   j = j + 1
!     ********** FORM SHIFT **********
   g = (d(l+1) - p) / (2.0 * e(l))
   r = sqrt(g*g+1.0)
   if (g .lt. 0.0) r = -r
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
      if (abs(f) .lt. abs(g)) go to 150
      c = g / f
      r = sqrt(c*c+1.0)
      e(i+1) = f * r
      s = 1.0 / r
      c = c * s
      go to 160
150 s = f / g
      r = sqrt(s*s+1.0)
      e(i+1) = g * r
      c = 1.0 / r
      s = s * c
160 g = d(i+1) - p
      r = (d(i) - g) * s + 2.0 * c * b
      p = s * r
      d(i+1) = g + p
      g = c * r - b
!     ********** FORM VECTOR **********
      do k = 1, n
         f = z(k,i+1)
         z(k,i+1) = s * z(k,i) + c * f
         z(k,i) = c * z(k,i) - s * f
      end do
!
   end do
!
   d(l) = d(l) - p
   e(l) = g
   e(m) = 0.0
   go to 105
240 continue
!     ********** ORDER EIGENVALUES AND EIGENVECTORS **********
do 300 ii = 2, n
   i = ii - 1
   k = i
   p = d(i)
!
   do 260 j = ii, n
      if (d(j) .ge. p) go to 260
      k = j
      p = d(j)
260 continue
!
   if (k .eq. i) go to 300
   d(k) = d(i)
   d(i) = p
!
   do j = 1, n
      p = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = p
   end do
!
300 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = l
1001 return
!     ********** LAST CARD OF imtql2 **********
end subroutine imtql2

