subroutine dbsl (a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer :: ml1, ml2
! ----------------------------------------------------------------------
!
!     DBSL SOLVES THE REAL BAND SYSTEM A*X = B OR TRANS(A)*X = B
!     USING THE FACTORS COMPUTED BY DBFA.
!
!                         ----------
!     ON ENTRY
!
!        A       DOUBLE PRECISION(LDA, NC)
!                THE OUTPUT FROM DBFA.
!                NC MUST BE .GE. 2*ML+MU+1 .
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!        IPVT    INTEGER(N)
!                THE PIVOT VECTOR FROM DBFA.
!
!        B       DOUBLE PRECISION(N)
!                THE RIGHT HAND SIDE VECTOR.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  A*X = B .
!                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
!                            TRANS(A)  IS THE TRANSPOSE.
!
!     ON RETURN
!
!        B       THE SOLUTION VECTOR  X .
!
!     ERROR CONDITION
!
!        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
!        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
!        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
!        SETTING OF LDA.  IT WILL NOT OCCUR IF DBFA AND DBSL ARE
!        CALLED CORRECTLY AND DBFA HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!      DAXPY,DDOT
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
!     JOB = 0 , SOLVE  A * X = B
!       FIRST SOLVE L*Y = B
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
!     JOB = NONZERO, SOLVE TRANS(A) * X = B
!       FIRST SOLVE  TRANS(U)*Y = B
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
!       NOW SOLVE TRANS(L)*X = Y
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
!     CASE WHEN ML = 0 AND MU = 0
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
!              COMPUTATION OF THE L1 CONDITION NUMBER
!                       OF A BANDED MATRIX A
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,*), wk(*)
integer, intent(inout) :: iwk(*)
!-----------------------
!     REAL WK(2*N)
!     INTEGER IWK(2*N)
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
!     CHECK IF A IS SINGULAR
!
if (ierr .gt. 0) go to 40
!
!     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
!     OF THE INVERSE OF A
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
!     COMPUTE THE VALUE OF COND
!
30 cond = anorm*ainorm
return
!
!     SINGULAR CASE
!
40 ierr = 1
return
!
!     ERROR RETURN
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
!            COMPUTATION OF THE L1 CONDITION NUMBER OF
!               A DOUBLE PRECISION BANDED MATRIX A
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
integer, intent(inout) :: iwk(*)
double precision :: anorm, ainorm
double precision :: db1nrm
!-----------------------
!     DOUBLE PRECISION WK(2*N)
!     INTEGER IWK(2*N)
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
!     CHECK IF A IS SINGULAR
!
if (ierr .gt. 0) go to 40
!
!     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
!     OF THE INVERSE OF A
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
!     COMPUTE THE VALUE OF COND
!
30 cond = anorm*ainorm
return
!
!     SINGULAR CASE
!
40 ierr = 1
return
!
!     ERROR RETURN
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
!     CBSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN COMPLEX BANDED SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF CBSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO CBSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!               A IS A COMPLEX ARRAY.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT
!               HAND SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO CBSLV, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. CBSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     CBSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
complex, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     ERROR CHECKING
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 call cbsl(a,ka,n,ml,mu,iwk,b,0)
return
!
!     ERROR RETURN
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
!     CBSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN COMPLEX BANDED SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF CBSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO CBSLV1.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!               A IS A COMPLEX ARRAY.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT
!               HAND SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO CBSLV1, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. CBSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     CBSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
complex, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     ERROR CHECKING
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 call cbsl(a,ka,n,ml,mu,iwk,b,1)
return
!
!     ERROR RETURN
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
!               CBFA FACTORS A COMPLEX BAND MATRIX BY ELIMINATION.
!
!                              ----------
!     ON ENTRY
!
!        A       COMPLEX(LDA, NC)
!                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
!                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
!                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
!                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
!                NC MUST BE .GE. 2*ML+MU+1 .
!                SEE THE COMMENTS BELOW FOR DETAILS.
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A. IT IS
!                ASSUMED THAT LDA .GE. N.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!                0 .LE. ML .LT. N .
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!                0 .LE. MU .LT. N .
!                MORE EFFICIENT IF ML .LE. MU .
!
!     ON RETURN
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
!                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
!                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
!
!        IPVT    INTEGER(N)
!                AN INTEGER VECTOR OF PIVOT INDICES.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
!                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
!                INDICATE THAT CBSL WILL DIVIDE BY ZERO IF
!                IT IS CALLED.
!
!     BAND STORAGE
!
!           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
!           A0 IN BAND FORM.
!
!                   ML = (BAND WIDTH BELOW THE DIAGONAL)
!                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
!                   DO 20 I = 1, N
!                      J1 = MAX0(1, I-ML)
!                      J2 = MIN0(N, I+MU)
!                      DO 10 J = J1, J2
!                         K = J - I + ML + 1
!                         A(I,K) = A0(I,J)
!                10    CONTINUE
!                20 CONTINUE
!
!           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
!           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
!           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
!           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
!           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
!
!     EXAMPLE..  IF THE ORIGINAL MATRIX IS
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
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
!     SUBROUTINES AND FUNCTIONS
!        MIN0,ICAMAX,CAXPY,CSCAL,CSWAP
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
!     SET FILL-IN COLUMNS TO ZERO
!
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = (0.0,0.0)
   end do
end do
!
!     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
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
!     SEARCH FOR PIVOT INDEX
!
  l = -icamax(lm1, a(lmk,lm2), ldb) + lm1 + k
  ipvt(k) = l
  mp = min0(mb,n-k)
!
!     SWAP ROWS IF NECESSARY
!
  ll = ml1 + k - l
  if (l .ne. k) call cswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
!
  if (a(k,ml1) .ne. (0.0,0.0)) go to 20
     info = k
     go to 40
!
!     COMPUTE MULTIPLIERS
!
20 t = (-1.0,0.0)/a(k,ml1)
  call cscal(lm, t, a(lmk,lm2), ldb)
!
!     ROW ELIMINATION WITH COLUMN INDEXING
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
!     CASE WHEN ML = 0
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
!     CBSL SOLVES THE COMPLEX BAND SYSTEM A*X = B OR TRANS(A)*X = B
!     USING THE FACTORS COMPUTED BY CBFA.
!
!                         ----------
!     ON ENTRY
!
!        A       COMPLEX(LDA, NC)
!                THE OUTPUT FROM CBFA.
!                NC MUST BE .GE. 2*ML+MU+1 .
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!        IPVT    INTEGER(N)
!                THE PIVOT VECTOR FROM CBFA.
!
!        B       COMPLEX(N)
!                THE RIGHT HAND SIDE VECTOR.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  A*X = B .
!                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
!                            TRANS(A)  IS THE TRANSPOSE.
!
!     ON RETURN
!
!        B       THE SOLUTION VECTOR  X .
!
!     ERROR CONDITION
!
!        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
!        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
!        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
!        SETTING OF LDA.  IT WILL NOT OCCUR IF CBFA AND CBSL ARE
!        CALLED CORRECTLY AND CBFA HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     ADAPTED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!      CAXPY,CDOTU
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
!     JOB = 0 , SOLVE  A * X = B
!       FIRST SOLVE L*Y = B
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
!     JOB = NONZERO, SOLVE TRANS(A) * X = B
!       FIRST SOLVE  TRANS(U)*Y = B
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
!       NOW SOLVE TRANS(L)*X = Y
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
!     CASE WHEN ML = 0 AND MU = 0
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
!                 STORE THE I-TH ROW
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
!                 COMPLETE THE SETUP
!
ib(m + 1) = ip
ierr = 0
return
!
!                   ERROR RETURN
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
!                 STORE THE I-TH ROW
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
!                 COMPLETE THE SETUP
!
ib(m + 1) = ip
ierr = 0
return
!
!                   ERROR RETURN
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
!                 STORE THE I-TH ROW
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
!                 COMPLETE THE SETUP
!
ib(m + 1) = ip
ierr = 0
return
!
!                   ERROR RETURN
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
!                 CLEAR THE I-TH ROW
!
   do j = 1,n
      b(i,j) = 0.0
   end do
!
!                 STORE THE I-TH ROW
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
!                 CLEAR THE I-TH ROW
!
   do j = 1,n
      b(i,j) = 0.d0
   end do
!
!                 STORE THE I-TH ROW
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
!                 CLEAR THE I-TH ROW
!
   do j = 1,n
      b(i,j) = (0.0,0.0)
   end do
!
!                 STORE THE I-TH ROW
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
!              REAL PART OF A SPARSE COMPLEX MATRIX
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
!            IMAGINARY PART OF A SPARSE COMPLEX MATRIX
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
!       COMPUTE A + BI FOR THE SPARSE REAL MATRICES A AND B
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
!
50 ierr = i
return
end subroutine scvrc

subroutine rscopy (a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
integer :: i, ibeg, iend, ip, l
!-----------------------------------------------------------------------
!                  COPYING A SPARSE REAL MATRIX
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
!              COPYING A SPARSE DOUBLE PRECISION MATRIX
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
!                 COPYING A SPARSE COMPLEX MATRIX
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
!     COMPUTATION OF THE CONJUGATE OF A SPARSE COMPLEX MATRIX
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
!                 TRANSPOSING A SPARSE REAL MATRIX
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
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
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
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
!                    TRANSPOSE A ZERO MATRIX A
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
!                 TRANSPOSING A SPARSE REAL MATRIX
!                 WHERE THE ROWS ARE INTERCHANGED
!-----------------------------------------------------------------------
integer, intent(in) :: p(m)
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
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
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
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
!                    TRANSPOSE A ZERO MATRIX A
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
!           TRANSPOSING A SPARSE DOUBLE PRECISION MATRIX
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
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
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
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
!                    TRANSPOSE A ZERO MATRIX A
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
!           TRANSPOSING A SPARSE DOUBLE PRECISION MATRIX
!                 WHERE THE ROWS ARE INTERCHANGED
!-----------------------------------------------------------------------
integer, intent(in) :: p(m)
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
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
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
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
!                    TRANSPOSE A ZERO MATRIX A
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
!               TRANSPOSING A SPARSE COMPLEX MATRIX
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
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
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
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
!                    TRANSPOSE A ZERO MATRIX A
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
!               TRANSPOSING A SPARSE COMPLEX MATRIX
!                 WHERE THE ROWS ARE INTERCHANGED
!-----------------------------------------------------------------------
integer, intent(in) :: p(m)
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
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
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
num = ia(m+1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j+1) = num
   j = j - 1
end do
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
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
!                    TRANSPOSE A ZERO MATRIX A
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
!               ADDITION OF SPARSE REAL MATRICES
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
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
!         ADDITION OF SPARSE DOUBLE PRECISION MATRICES
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
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
!              ADDITION OF SPARSE COMPLEX MATRICES
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
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
!             SUBTRACTION OF SPARSE REAL MATRICES
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
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
!        SUBTRACTION OF SPARSE DOUBLE PRECISION MATRICES
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
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
!            SUBTRACTION OF SPARSE COMPLEX MATRICES
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
!                  COMPUTE THE I-TH ROW OF C
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
!                        ERROR RETURN
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
!               MULTIPLICATION OF SPARSE REAL MATRICES
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
!                     COMPUTE THE I-TH ROW OF C
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
!                           ERROR RETURN
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
!         MULTIPLICATION OF SPARSE DOUBLE PRECISION MATRICES
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
!                     COMPUTE THE I-TH ROW OF C
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
!                           ERROR RETURN
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
!             MULTIPLICATION OF SPARSE COMPLEX MATRICES
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
!                     COMPUTE THE I-TH ROW OF C
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
!                           ERROR RETURN
!
40 ierr = i
return
end subroutine csprod

subroutine mvprd (m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
integer :: i, j, l, lmax, lmin
!-----------------------------------------------------------------------
!              PRODUCT OF A SPARSE MATRIX AND A VECTOR
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
!     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
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
!              PRODUCT OF A VECTOR AND A SPARSE MATRIX
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
!     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
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
!              PRODUCT OF A SPARSE MATRIX AND A VECTOR
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
!     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
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
!              PRODUCT OF A VECTOR AND A SPARSE MATRIX
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
!     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
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
!              PRODUCT OF A SPARSE MATRIX AND A VECTOR
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
!     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
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
!              PRODUCT OF A VECTOR AND A SPARSE MATRIX
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
!     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
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
!             COMPUTATION OF THE L-INFINITY NORM OF A
!                      REAL SPARSE MATRIX A
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
!        COMPUTATION OF THE L1 NORM OF A REAL SPARSE MATRIX A
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
!     COMPUTE THE L1 NORM OF A
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
!             COMPUTATION OF THE L-INFINITY NORM OF A
!                DOUBLE PRECISION SPARSE MATRIX A
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
!               COMPUTATION OF THE L1 NORM OF A SPARSE
!                     DOUBLE PRECISION MATRIX A
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
!     COMPUTE THE L1 NORM OF A
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
!        SPORD ORDERS THE ROWS OF AN MXN SPARSE MATRIX A,IA,JA
!        BY INCREASING LENGTH. THE ROW ORDERING IS GIVEN IN R.
!-----------------------------------------------------------------------
!     IWK IS A WORK SPACE OF DIMENSION M + N + 1.
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
!        REORDERING A SPARSE MATRIX INTO BLOCK TRIANGULAR FORM
!-----------------------------------------------------------------------
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: r(n), c(n), ib(n)
!     INTEGER IWK(5*N)
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
! DESCRIPTION OF PARAMETERS.
! INPUT VARIABLES   N,ICN,LICN,IP,LENR
! OUTPUT VARIABLES  IPERM,NUMNZ
!
! N   ORDER OF MATRIX.
! ICN ARRAY CONTAINING THE COLUMN INDICES OF THE NON-ZEROS.  THOSE
!     BELONGING TO A SINGLE ROW MUST BE CONTIGUOUS BUT THE ORDERING
!     OF COLUMN INDICES WITHIN EACH ROW IS UNIMPORTANT AND WASTED
!     SPACE BETWEEN ROWS IS PERMITTED.
! LICN  LENGTH OF ARRAY ICN.
! IP  IP(I), I=1,2,...N, IS THE POSITION IN ARRAY ICN OF THE FIRST
!     COLUMN INDEX OF A NON-ZERO IN ROW I.
! LENR  LENR(I) IS THE NUMBER OF NON-ZEROS IN ROW I, I=1,2,..N.
! IPERM CONTAINS PERMUTATION TO MAKE DIAGONAL HAVE THE SMALLEST
!     NUMBER OF ZEROS ON IT.  ELEMENTS (IPERM(I),I) I=1, ... N ARE
!     NON-ZERO AT THE END OF THE ALGORITHM UNLESS MATRIX
!     IS STRUCTURALLY SINGULAR.  IN THIS CASE, (IPERM(I),I) WILL
!     BE ZERO FOR N-NUMNZ ENTRIES.
! NUMNZ NUMBER OF NON-ZEROS ON DIAGONAL OF PERMUTED MATRIX.
! IW  WORK ARRAY  ..  SEE LATER COMMENTS.
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
!     DIVISION OF WORK ARRAY IS NOW DESCRIBED.
!
! PR(I) IS THE PREVIOUS ROW TO I IN THE DEPTH FIRST SEARCH.
! ARP(I) IS ONE LESS THAN THE NUMBER OF NON-ZEROS IN ROW I
!     WHICH HAVE NOT BEEN SCANNED WHEN LOOKING FOR A CHEAP ASSIGNMENT.
! CV(I) IS THE MOST RECENT ROW EXTENSION AT WHICH COLUMN I
!     WAS VISITED.
! OUT(I) IS ONE LESS THAN THE NUMBER OF NON-ZEROS IN ROW I
!     WHICH HAVE NOT BEEN SCANNED DURING ONE PASS THROUGH THE
!     MAIN LOOP.
!-----------------------------------------------------------------------
integer, intent(in) :: ip(n), icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), pr(n), cv(n), arp(n), out(n)
!
!     INITIALIZATION OF ARRAYS
!
do i = 1,n
   arp(i) = lenr(i) - 1
   cv(i) = 0
   iperm(i) = 0
end do
numnz = 0
!
!     MAIN LOOP.
!     EACH PASS ROUND THIS LOOP EITHER RESULTS IN A NEW ASSIGNMENT
!     OR GIVES A ROW WITH NO ASSIGNMENT.
!
do 130 jord = 1,n
j = jord
pr(j) = -1
do 100 k = 1,jord
!
!     LOOK FOR A CHEAP ASSIGNMENT
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
!     NO CHEAP ASSIGNMENT IN ROW
!
arp(j) = -1
!
!     BEGIN LOOKING FOR ASSIGNMENT CHAIN STARTING WITH ROW J
!
60 out(j) = lenr(j) - 1
!
!     INNER LOOP.  EXTENDS CHAIN BY ONE OR BACKTRACKS.
!
do kk = 1,jord
   in1 = out(j)
   if (in1 .lt. 0) go to 80
   in2 = ip(j) + lenr(j) - 1
   in1 = in2 - in1
!
!        FORWARD SCAN
!
   do 70 ii = in1,in2
      i = icn(ii)
      if (cv(i) .eq. jord) go to 70
!
!           COLUMN I HAS NOT YET BEEN ACCESSED DURING THIS PASS
!
      j1 = j
      j = iperm(i)
      cv(i) = jord
      pr(j) = j1
      out(j1) = in2 - ii - 1
      go to 100
70 continue
!
!        BACKTRACKING STEP
!
80 j = pr(j)
   if (j .eq. -1) go to 130
end do
!
100 continue
!
!     NEW ASSIGNMENT IS MADE
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
!     IF MATRIX IS STRUCTURALLY SINGULAR, WE NOW COMPLETE THE
!     PERMUTATION IPERM.
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
! DESCRIPTION OF PARAMETERS.
! INPUT VARIABLES  .... N,ICN,LICN,IP,LENR.
! OUTPUT VARIABLES  IOR,IB,NUM.
!
! N   ORDER OF THE MATRIX.
! ICN ARRAY CONTAINING THE COLUMN INDICES OF THE NON-ZEROS.  THOSE
!     BELONGING TO A SINGLE ROW MUST BE CONTIGUOUS BUT THE ORDERING
!     OF COLUMN INDICES WITHIN EACH ROW IS UNIMPORTANT AND WASTED
!     SPACE BETWEEN ROWS IS PERMITTED.
! LICN  LENGTH OF ARRAY ICN.
! IP  IP(I), I=1,2,...N, IS THE POSITION IN ARRAY ICN OF THE FIRST
!     COLUMN INDEX OF A NON-ZERO IN ROW I.
! LENR  LENR(I) IS THE NUMBER OF NON-ZEROS IN ROW I, I=1,2,...N.
! IOR  IOR(I) GIVES THE POSITION IN THE ORIGINAL ORDERING OF THE ROW
!     OR COLUMN WHICH IS IN POSITION I IN THE PERMUTED FORM, I=1,2,..N.
! IB  IB(I) IS THE ROW NUMBER IN THE PERMUTED MATRIX OF THE BEGINNING
!     OF BLOCK I, I=1,2,...NUM.
! NUM NUMBER OF BLOCKS FOUND.
! IW  WORK ARRAY OF LENGTH 3*N.
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
! ARP(I) IS ONE LESS THAN THE NUMBER OF UNSEARCHED EDGES LEAVING
!     NODE I.  AT THE END OF THE ALGORITHM IT IS SET TO A
!     PERMUTATION WHICH PUTS THE MATRIX IN BLOCK LOWER
!     TRIANGULAR FORM.
! IB(I) IS THE POSITION IN THE ORDERING OF THE START OF THE ITH
!     BLOCK.  IB(N+1-I) HOLDS THE NODE NUMBER OF THE ITH NODE
!     ON THE STACK.
! LOWL(I) IS THE SMALLEST STACK POSITION OF ANY NODE TO WHICH A PATH
!     FROM NODE I HAS BEEN FOUND.  IT IS SET TO N+1 WHEN NODE I
!     IS REMOVED FROM THE STACK.
! NUMB(I) IS THE POSITION OF NODE I IN THE STACK IF IT IS ON
!     IT, IS THE PERMUTED ORDER OF NODE I FOR THOSE NODES
!     WHOSE FINAL POSITION HAS BEEN FOUND AND IS OTHERWISE ZERO.
! PREV(I) IS THE NODE AT THE END OF THE PATH WHEN NODE I WAS
!     PLACED ON THE STACK.
!
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: arp(n), ib(n), lowl(n), numb(n), prev(n)
!
!   ICNT IS THE NUMBER OF NODES WHOSE POSITIONS IN FINAL ORDERING HAVE
!     BEEN FOUND.
!
icnt = 0
! NUM IS THE NUMBER OF BLOCKS THAT HAVE BEEN FOUND.
num = 0
nnm1 = n + n - 1
!
! INITIALIZATION OF ARRAYS.
!
do j=1,n
  numb(j) = 0
  arp(j) = lenr(j) - 1
end do
!
!
do 90 isn = 1,n
! LOOK FOR A STARTING NODE
  if (numb(isn).ne.0) go to 90
  iv = isn
! IST IS THE NUMBER OF NODES ON THE STACK ... IT IS THE STACK POINTER.
  ist = 1
! PUT NODE IV AT BEGINNING OF STACK.
  lowl(iv) = 1
  numb(iv) = 1
  ib(n) = iv
!
! THE BODY OF THIS LOOP PUTS A NEW NODE ON THE STACK OR BACKTRACKS.
!
  do 80 dummy = 1,nnm1
    i1 = arp(iv)
! HAVE ALL EDGES LEAVING NODE IV BEEN SEARCHED.
    if (i1.lt.0) go to 30
    i2 = ip(iv) + lenr(iv) - 1
    i1 = i2 - i1
!
! LOOK AT EDGES LEAVING NODE IV UNTIL ONE ENTERS A NEW NODE OR
!     ALL EDGES ARE EXHAUSTED.
!
    do ii=i1,i2
      iw = icn(ii)
! HAS NODE IW BEEN ON STACK ALREADY.
      if (numb(iw).eq.0) go to 70
! UPDATE VALUE OF LOWL(IV) IF NECESSARY.
      if (lowl(iw).lt.lowl(iv)) lowl(iv) = lowl(iw)
    end do
!
! THERE ARE NO MORE EDGES LEAVING NODE IV.
!
    arp(iv) = -1
! IS NODE IV THE ROOT OF A BLOCK.
30 if (lowl(iv).lt.numb(iv)) go to 60
!
! ORDER NODES IN A BLOCK.
!
    num = num + 1
    ist1 = n + 1 - ist
    lcnt = icnt + 1
!
! PEEL BLOCK OFF THE TOP OF THE STACK STARTING AT THE TOP AND
!     WORKING DOWN TO THE ROOT OF THE BLOCK.
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
! ARE THERE ANY NODES LEFT ON THE STACK.
    if (ist.ne.0) go to 60
! HAVE ALL THE NODES BEEN ORDERED.
    if (icnt.lt.n) go to 90
    go to 100
!
! BACKTRACK TO PREVIOUS NODE ON PATH.
!
60 iw = iv
    iv = prev(iv)
! UPDATE VALUE OF LOWL(IV) IF NECESSARY.
    if (lowl(iw).lt.lowl(iv)) lowl(iv) = lowl(iw)
    go to 80
!
! PUT NEW NODE ON THE STACK.
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
! PUT PERMUTATION IN THE REQUIRED FORM.
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
!                 SOLUTION OF REAL SPARSE EQUATIONS
!-----------------------------------------------------------------------
!  SPSLV CALLS NSPIV1 WHICH USES SPARSE GAUSSIAN ELIMINATION WITH
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
!  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
!  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
!  PHASE SOLVES U X = Y.
!
!  INPUT ARGUMENTS---
!
!  N      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
!         ACTUAL NONZEROS.  (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  IA     INTEGER ARRAY OF N+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  JA     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         COLUMN NUMBERS OF THE NONZEROS OF A.  (SEE MATRIX STORAGE
!         DESCRIPTION BELOW)
!
!  B      REAL ARRAY OF N ENTRIES CONTAINING RIGHT HAND SIDE DATA
!
!  R      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         ROWS OF A (I.E., THE ELIMINATION ORDER FOR THE EQUATIONS)
!
!  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         COLUMNS OF A.  C IS ALSO AN OUTPUT ARGUMENT
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         NONZERO ENTRIES OF U WHICH MAY BE STORED
!
!  ITEMP  INTEGER ARRAY OF 3*N + MAX + 2 ENTRIES, FOR INTERNAL USE
!
!  RTEMP  REAL ARRAY OF N + MAX ENTRIES FOR INTERNAL USE
!
!
!  OUTPUT ARGUMENTS---
!
!  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         COLUMNS OF U.  C IS ALSO AN INPUT ARGUMENT
!
!  X      REAL ARRAY OF N ENTRIES CONTAINING THE SOLUTION VECTOR
!
!  IERR   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         THE ACTUAL NUMBER OF OFF-DIAGONAL ENTRIES IN U (FOR
!         SUCCESSFUL COMPLETION)
!
!         IERR VALUES ARE---
!
!         0 LT IERR             SUCCESSFUL COMPLETION. IERR=MAX(1,M)
!                               WHERE M IS THE NUMBER OF OFF-DIAGONAL
!                               NONZERO ENTRIES OF U.
!
!         IERR = 0              ERROR.  N IS LESS THAN OR EQUAL TO 0
!
!         -N LE IERR LT 0       ERROR.  ROW NUMBER IABS(IERR) OF A IS
!                               IS NULL
!
!         -2*N LE IERR LT -N    ERROR.  ROW NUMBER IABS(IERR+N) HAS A
!                               DUPLICATE ENTRY
!
!         -3*N LE IERR LT -2*N  ERROR.  ROW NUMBER IABS(IERR+2*N)
!                               HAS A ZERO PIVOT
!
!         -4*N LE IERR LT -3*N  ERROR.  ROW NUMBER IABS(IERR+3*N)
!                               EXCEEDS STORAGE
!
!
!  STORAGE OF SPARSE MATRICES---
!
!  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
!  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
!  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
!  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
!  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
!  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
!  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
!  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
!  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZERO
!  ELEMENTS IN A.
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
!  SET INDICES TO DIVIDE TEMPORARY STORAGE FOR NSPIV1
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  COMPUTE THE INVERSE PERMUTATION OF C
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL NSPIV1 TO PERFORM COMPUTATIONS
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
!  NSPIV1 USES SPARSE GAUSSIAN ELIMINATION WITH
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
!  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
!  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
!  PHASE SOLVES U X = Y.
!
!
!  SEE SPSLV FOR DESCRIPTIONS OF ALL INPUT AND OUTPUT ARGUMENTS
!  OTHER THAN THOSE DESCRIBED BELOW
!
!  IC  INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
!      (I.E., IC(C(I)) = I). IC IS BOTH AN INPUT AND OUTPUT
!      ARGUMENT.
!
!  INPUT ARGUMENTS (USED INTERNALLY ONLY)---
!
!  Y   REAL ARRAY OF N ENTRIES USED TO COMPUTE THE UPDATED
!      RIGHT HAND SIDE
!
!  P   INTEGER ARRAY OF N+1 ENTRIES USED FOR A LINKED LIST.
!      P(N+1) IS THE LIST HEADER, AND THE ENTRY FOLLOWING
!      P(K) IS IN P(P(K)).  THUS, P(N+1) IS THE FIRST DATA
!      ITEM, P(P(N+1)) IS THE SECOND, ETC.  A POINTER OF
!      N+1 MARKS THE END OF THE LIST
!
!  IU  INTEGER ARRAY OF N+1 ENTRIES USED FOR ROW POINTERS TO U
!      (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  JU  INTEGER ARRAY OF MAX ENTRIES USED FOR COLUMN NUMBERS OF
!      THE NONZEROS IN THE STRICT UPPER TRIANGLE OF U.  (SEE
!      MATRIX STORAGE DESCRIPTION BELOW)
!
!  U   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      THE STRICT UPPER TRIANGLE OF U.  (SEE MATRIX STORAGE
!      DESCRIPTION BELOW)
!
!
!  STORAGE OF SPARSE MATRICES---
!
!  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
!  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
!  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
!  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
!  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
!  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
!  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
!  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
!  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZEROS IN
!  A.  IU, JU, AND U ARE USED IN A SIMILAR WAY TO STORE THE STRICT UPPER
!  TRIANGLE OF U, EXCEPT THAT JU ACTUALLY CONTAINS C(J) INSTEAD OF J
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
!  INITIALIZE WORK STORAGE AND POINTERS TO JU
!
do j = 1,n
  x(j) = 0.0
end do
iu(1) = 1
juptr = 0
!
!  PERFORM SYMBOLIC AND NUMERIC FACTORIZATION ROW BY ROW
!  VK (VI,VJ) IS THE GRAPH VERTEX FOR ROW K (I,J) OF U
!
do 170 k = 1,n
!
!  INITIALIZE LINKED LIST AND FREE STORAGE FOR THIS ROW
!  THE R(K)-TH ROW OF A BECOMES THE K-TH ROW OF U.
!
  p(n+1) = n+1
  vk = r(k)
!
!  SET UP ADJACENCY LIST FOR VK, ORDERED IN
!  CURRENT COLUMN ORDER OF U.  THE LOOP INDEX
!  GOES DOWNWARD TO EXPLOIT ANY COLUMNS
!  FROM A IN CORRECT RELATIVE ORDER
!
  jmin = ia(vk)
  jmax = ia(vk+1) - 1
  if (jmin .gt. jmax)  go to 1002
  j = jmax
20 jaj = ja(j)
    vj = ic(jaj)
!
!  STORE A(K,J) IN WORK VECTOR
!
    x(vj) = a(j)
!  THIS CODE INSERTS VJ INTO ADJACENCY LIST OF VK
    ppk = n+1
30 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  30,1003,40
40 p(vj) = ppk
    p(pk) = vj
    j = j - 1
    if (j .ge. jmin) go to 20
!
!  THE FOLLOWING CODE COMPUTES THE K-TH ROW OF U
!
  vi = n+1
  yk = b(vk)
50 vi = p(vi)
  if (vi .ge. k) go to 110
!
!  VI LT VK -- PROCESS THE L(K,I) ELEMENT AND MERGE THE
!  ADJACENCY OF VI WITH THE ORDERED ADJACENCY OF VK
!
  lki = - x(vi)
  x(vi) = 0.0
!
!  ADJUST RIGHT HAND SIDE TO REFLECT ELIMINATION
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
!  IF VJ IS ALREADY IN THE ADJACENCY OF VK,
!  SKIP THE INSERTION
!
    if (x(vj) .ne. 0.0)  go to 90
!
!  INSERT VJ IN ADJACENCY LIST OF VK.
!  RESET PPK TO VI IF WE HAVE PASSED THE CORRECT
!  INSERTION SPOT.  (THIS HAPPENS WHEN THE ADJACENCY OF
!  VI IS NOT IN CURRENT COLUMN ORDER DUE TO PIVOTING.)
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
!  COMPUTE L(K,J) = L(K,J) - L(K,I)*U(I,J) FOR L(K,I) NONZERO
!  COMPUTE U*(K,J) = U*(K,J) - L(K,I)*U(I,J) FOR U(K,J) NONZERO
!  (U*(K,J) = U(K,J)*D(K,K))
!
90 x(vj) = x(vj) + lki * u(j)
  end do
  go to 50
!
!  PIVOT--INTERCHANGE LARGEST ENTRY OF K-TH ROW OF U WITH
!  THE DIAGONAL ENTRY.
!
!  FIND LARGEST ENTRY, COUNTING OFF-DIAGONAL NONZEROS
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
!  IF VI = K, THEN THERE IS AN ENTRY FOR DIAGONAL
!  WHICH MUST BE DELETED.  OTHERWISE, DELETE THE
!  ENTRY WHICH WILL BECOME THE DIAGONAL ENTRY
!
  if (vi .eq. k) go to 140
  if (vi .eq. maxc) go to 140
  p(maxcl) = p(maxc)
  go to 150
140 vi = p(vi)
!
!  COMPUTE D(K) = 1/L(K,K) AND PERFORM INTERCHANGE.
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
!  UPDATE RIGHT HAND SIDE.
!
  y(k) = yk * dk
!
!  COMPUTE VALUE FOR IU(K+1) AND CHECK FOR STORAGE OVERFLOW
!
  iu(k+1) = iu(k) + nzcnt
  if (iu(k+1) .gt. max+1) go to 1005
!
!  MOVE COLUMN INDICES FROM LINKED LIST TO JU.
!  COLUMNS ARE STORED IN CURRENT ORDER WITH ORIGINAL
!  COLUMN NUMBER (C(J)) STORED FOR CURRENT COLUMN J
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
!  BACKSOLVE U X = Y, AND REORDER X TO CORRESPOND WITH A
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
!  RETURN WITH IERR = NUMBER OF OFF-DIAGONAL NONZEROS IN U
!
ierr = iu(n+1) - iu(1)
return
!
!  ERROR RETURNS
!
!  ROW K OF A IS NULL
!
1002 ierr = -k
return
!
!  ROW K OF A HAS A DUPLICATE ENTRY
!
1003 ierr = -(n+k)
return
!
!  ZERO PIVOT IN ROW K
!
1004 ierr = -(2*n+k)
return
!
!  STORAGE FOR U EXCEEDED ON ROW K
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
!                 SOLUTION OF REAL SPARSE EQUATIONS
!-----------------------------------------------------------------------
!     RSLV EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES TO
!     SOLVE THE NXN LINEAR SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF RSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) THE LU DECOMPO-
!     SITION OF A IS OBTAINED WHERE U IS A UNIT UPPER TRIANGULAR
!     MATRIX. THEN THE EQUATIONS ARE SOLVED. ON SUBSEQUENT CALLS
!     (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     OBTAINED ON THE INITIAL CALL TO RSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     N        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     A,IA,JA  THE MATRIX A STORED IN SPARSE FORM.
!
!     B        ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     X        REAL ARRAY OF N ENTRIES CONTAINING THE SOLUTION.
!              B AND X MAY SHARE THE SAME STORAGE AREA.
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = B IS OBTAINED THEN IERR = MAX(1,M)
!              WHERE M IS THE TOTAL NUMBER OF OFF-DIAGONAL NONZERO
!              ENTRIES OF L AND U. OTHERWISE IERR.LE.0.
!
!
!     GENERAL STORAGE AREAS ---
!
!     IWK      INTEGER ARRAY OF DIMENSION 4*N + MAX + 2.
!
!     WK       REAL ARRAY OF DIMENSION 2*N + MAX.
!
!
!     AFTER AN INITIAL CALL TO RSLV, THE ROUTINE MAY BE RECALLED WITH
!     M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT N,A,IA,JA,
!     R,C,IWK,WK HAVE NOT BEEN MODIFIED. THE ROUTINE RETRIEVES THE LU
!     DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO RSLV
!     AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE A,IA,JA,MAX,
!     AND IERR ARE NOT REFERENCED.
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     SET INDICES TO DIVIDE TEMPORARY STORAGE
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     COMPUTE THE INVERSE PERMUTATION OF C
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     OBTAIN THE LU DECOMPOSITION OF A
!
call splu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     SOLVE THE SYSTEM OF EQUATIONS
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
!            SOLVE LY = B BY FORWARD SUBSTITUTION
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
!            SOLVE UX = B BY BACKWARD SUBSTITUTION
!             AND REORDER X TO CORRESPOND WITH A
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
!                 SOLUTION OF REAL SPARSE EQUATIONS
!-----------------------------------------------------------------------
!     TSLV EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES TO
!     SOLVE THE NXN LINEAR SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF TSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) THE LU DECOMPO-
!     SITION OF A IS OBTAINED WHERE U IS A UNIT UPPER TRIANGULAR
!     MATRIX. THEN THE EQUATIONS ARE SOLVED. ON SUBSEQUENT CALLS
!     (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     OBTAINED ON THE INITIAL CALL TO TSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     N        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     A,IA,JA  THE MATRIX A STORED IN SPARSE FORM.
!
!     B        ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     X        REAL ARRAY OF N ENTRIES CONTAINING THE SOLUTION.
!              B AND X MAY SHARE THE SAME STORAGE AREA.
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = B IS OBTAINED THEN IERR = MAX(1,M)
!              WHERE M IS THE TOTAL NUMBER OF OFF-DIAGONAL NONZERO
!              ENTRIES OF L AND U. OTHERWISE IERR.LE.0.
!
!
!     GENERAL STORAGE AREAS ---
!
!     IWK      INTEGER ARRAY OF DIMENSION 4*N + MAX + 2.
!
!     WK       REAL ARRAY OF DIMENSION 2*N + MAX.
!
!
!     AFTER AN INITIAL CALL TO TSLV, THE ROUTINE MAY BE RECALLED WITH
!     M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT N,A,IA,JA,
!     R,C,IWK,WK HAVE NOT BEEN MODIFIED. THE ROUTINE RETRIEVES THE LU
!     DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO TSLV
!     AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE A,IA,JA,MAX,
!     AND IERR ARE NOT REFERENCED.
!-----------------------------------------------------------------------
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     SET INDICES TO DIVIDE TEMPORARY STORAGE
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     COMPUTE THE INVERSE PERMUTATION OF C
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     OBTAIN THE LU DECOMPOSITION OF A
!
call splu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     SOLVE THE SYSTEM OF EQUATIONS
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
!            SOLVE YU = B BY FORWARD SUBSTITUTION
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
!            SOLVE XL = Y BY BACKWARD SUBSTITUTION
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
!     SPLU EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES
!     TO PERFORM THE LU DECOMPOSITION OF A REAL SPARSE MATRIX.
!     U IS A UNIT UPPER TRIANGULAR MATRIX.
!
!
!     INPUT ARGUMENTS ---
!
!     A,IA,JA  THE SPARSE MATRIX TO BE DECOMPOSED.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     IC       INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
!              (I.E., IC(C(I)) = I). IC IS ALSO AN OUTPUT ARGUMENT.
!
!     N        ORDER OF THE MATRIX A.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     IC       INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C.
!
!     D        REAL ARRAY CONTAINING THE N DIAGONAL ELEMENTS OF L.
!
!     T,IT,IU  T CONTAINS THE OFF-DIAGONAL NONZERO ELEMENTS OF L AND
!              U. FOR I = 1,...,N THE OFF-DIAGONAL NONZERO ELEMENTS
!              OF THE I-TH ROW OF L ARE STORED IN LOCATIONS
!              IT(I),...,IU(I)-1 OF T, AND THE OFF-DIAGONAL NONZERO
!              ELEMENTS OF THE I-TH ROW OF U ARE STORED IN LOCATIONS
!              IU(I),...,IT(I+1)-1 OF T.
!
!     JT       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              TO THE ORGINAL COLUMN ORDERING) OF THE ELEMENTS OF T
!              (I.E., FOR EACH L(I,J) AND U(I,J) IN T, C(J) IS THE
!              CORRESPONDING COLUMN INDEX IN JT).
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU DECOMPOSITION IS OBTAINED THEN IERR = THE NUMBER
!              OF OFF-DIAGONAL ENTRIES OF L AND U WHICH WERE STORED
!              IN T. OTHERWISE IERR IS ASSIGNED A NEGATIVE VALUE.
!
!
!     WORK SPACES ---
!
!     W        REAL ARRAY OF DIMENSION N.
!
!     P        INTEGER ARRAY OF DIMENSION N+1.
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
!     PERFORM THE LU FACTORIZATION OF THE R(K)-TH ROW OF A
!
do 100 k = 1,n
lk = r(k)
jmin = ia(lk)
jmax = ia(lk+1) - 1
if (jmin .gt. jmax) go to 200
!
!     SET P TO THE REORDERED ROW OF A
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
!     PROCESS THE ENTRIES IN THE LOWER TRIANGLE OF A
!
i = n + 1
30 i = p(i)
if (i .ge. k) go to 50
if (w(i) .eq. 0.0) go to 30
!
!     L(K,I) IS NONZERO. THEREFORE STORE IT IN L.
!
jptr = jptr + 1
if (jptr .gt. max) go to 230
const = w(i)
t(jptr) = const
jt(jptr) = c(i)
w(i) = 0.0
!
!     PERFORM ELIMINATION USING THE I-TH ROW OF U
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
!     SEARCH FOR THE K-TH PIVOT ELEMENT
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
!     STORE THE PIVOT IN D
!
60 if (wmax .eq. 0.0) go to 220
d(k) = w(maxi)
!
!     PERFORM THE COLUMN INTERCHANGE
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
!     THE REMAINING ELEMENTS OF P FORM THE K-TH ROW OF U
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
!     PREPARE FOR THE NEXT ROW
!
100 it(k+1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- ERROR RETURN --------------------
!
!     ROW R(K) IS NULL
!
200 ierr = -k
return
!
!     ROW R(K) HAS A DUPLICATE ENTRY
!
210 ierr = -(n + k)
return
!
!     ZERO PIVOT IN ROW R(K)
!
220 ierr = -(2*n + k)
return
!
!     STORAGE FOR L AND U EXCEEDED ON ROW R(K)
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
!          SOLUTION OF DOUBLE PRECISION SPARSE EQUATIONS
!-----------------------------------------------------------------------
!  DSPSLV CALLS DNSPIV WHICH USES SPARSE GAUSSIAN ELIMINATION WITH
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
!  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
!  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
!  PHASE SOLVES U X = Y.
!
!  INPUT ARGUMENTS---
!
!  N      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      DOUBLE PRECISION ARRAY WITH ONE ENTRY PER NONZERO IN A,
!         CONTAINING THE ACTUAL NONZEROS. (SEE THE MATRIX STORAGE
!         DESCRIPTION BELOW)
!
!  IA     INTEGER ARRAY OF N+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  JA     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         COLUMN NUMBERS OF THE NONZEROS OF A.  (SEE MATRIX STORAGE
!         DESCRIPTION BELOW)
!
!  B      DOUBLE PRECISION ARRAY OF N ENTRIES CONTAINING THE RIGHT
!         HAND SIDE DATA
!
!  R      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         ROWS OF A (I.E., THE ELIMINATION ORDER FOR THE EQUATIONS)
!
!  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         COLUMNS OF A.  C IS ALSO AN OUTPUT ARGUMENT
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         NONZERO ENTRIES OF U WHICH MAY BE STORED
!
!  ITEMP  INTEGER ARRAY OF 3*N + MAX + 2 ENTRIES, FOR INTERNAL USE
!
!  RTEMP  DOUBLE PRECISION ARRAY OF N + MAX ENTRIES FOR INTERNAL USE
!
!
!  OUTPUT ARGUMENTS---
!
!  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         COLUMNS OF U.  C IS ALSO AN INPUT ARGUMENT
!
!  X      DOUBLE PRECISION ARRAY OF N ENTRIES CONTAINING THE
!         SOLUTION VECTOR
!
!  IERR   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         THE ACTUAL NUMBER OF OFF-DIAGONAL ENTRIES IN U (FOR
!         SUCCESSFUL COMPLETION)
!
!         IERR VALUES ARE---
!
!         0 LT IERR             SUCCESSFUL COMPLETION. IERR=MAX(1,M)
!                               WHERE M IS THE NUMBER OF OFF-DIAGONAL
!                               NONZERO ENTRIES OF U.
!
!         IERR = 0              ERROR.  N IS LESS THAN OR EQUAL TO 0
!
!         -N LE IERR LT 0       ERROR.  ROW NUMBER IABS(IERR) OF A IS
!                               IS NULL
!
!         -2*N LE IERR LT -N    ERROR.  ROW NUMBER IABS(IERR+N) HAS A
!                               DUPLICATE ENTRY
!
!         -3*N LE IERR LT -2*N  ERROR.  ROW NUMBER IABS(IERR+2*N)
!                               HAS A ZERO PIVOT
!
!         -4*N LE IERR LT -3*N  ERROR.  ROW NUMBER IABS(IERR+3*N)
!                               EXCEEDS STORAGE
!
!
!  STORAGE OF SPARSE MATRICES---
!
!  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
!  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
!  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
!  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
!  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
!  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
!  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
!  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
!  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZERO
!  ELEMENTS IN A.
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
!  SET INDICES TO DIVIDE TEMPORARY STORAGE FOR DNSPIV
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  COMPUTE THE INVERSE PERMUTATION OF C
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL DNSPIV TO PERFORM COMPUTATIONS
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
!  DNSPIV USES SPARSE GAUSSIAN ELIMINATION WITH
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
!  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
!  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
!  PHASE SOLVES U X = Y.
!
!
!  SEE DSPSLV FOR DESCRIPTIONS OF ALL INPUT AND OUTPUT ARGUMENTS
!  OTHER THAN THOSE DESCRIBED BELOW
!
!  IC  INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
!      (I.E., IC(C(I)) = I). IC IS BOTH AN INPUT AND OUTPUT
!      ARGUMENT.
!
!  INPUT ARGUMENTS (USED INTERNALLY ONLY)---
!
!  Y   DOUBLE PRECISION ARRAY OF N ENTRIES USED TO COMPUTE
!      THE UPDATED RIGHT HAND SIDE
!
!  P   INTEGER ARRAY OF N+1 ENTRIES USED FOR A LINKED LIST.
!      P(N+1) IS THE LIST HEADER, AND THE ENTRY FOLLOWING
!      P(K) IS IN P(P(K)).  THUS, P(N+1) IS THE FIRST DATA
!      ITEM, P(P(N+1)) IS THE SECOND, ETC.  A POINTER OF
!      N+1 MARKS THE END OF THE LIST
!
!  IU  INTEGER ARRAY OF N+1 ENTRIES USED FOR ROW POINTERS TO U
!      (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  JU  INTEGER ARRAY OF MAX ENTRIES USED FOR COLUMN NUMBERS OF
!      THE NONZEROS IN THE STRICT UPPER TRIANGLE OF U.  (SEE
!      MATRIX STORAGE DESCRIPTION BELOW)
!
!  U   DOUBLE PRECISION ARRAY OF MAX ENTRIES USED FOR THE ACTUAL
!      NONZEROS IN THE STRICT UPPER TRIANGLE OF U. (SEE MATRIX
!      STORAGE DESCRIPTION BELOW)
!
!
!  STORAGE OF SPARSE MATRICES---
!
!  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
!  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
!  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
!  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
!  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
!  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
!  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
!  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
!  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZEROS IN
!  A.  IU, JU, AND U ARE USED IN A SIMILAR WAY TO STORE THE STRICT UPPER
!  TRIANGLE OF U, EXCEPT THAT JU ACTUALLY CONTAINS C(J) INSTEAD OF J
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
!  INITIALIZE WORK STORAGE AND POINTERS TO JU
!
do j = 1,n
  x(j) = 0.d0
end do
iu(1) = 1
juptr = 0
!
!  PERFORM SYMBOLIC AND NUMERIC FACTORIZATION ROW BY ROW
!  VK (VI,VJ) IS THE GRAPH VERTEX FOR ROW K (I,J) OF U
!
do 170 k = 1,n
!
!  INITIALIZE LINKED LIST AND FREE STORAGE FOR THIS ROW
!  THE R(K)-TH ROW OF A BECOMES THE K-TH ROW OF U.
!
  p(n+1) = n+1
  vk = r(k)
!
!  SET UP ADJACENCY LIST FOR VK, ORDERED IN
!  CURRENT COLUMN ORDER OF U.  THE LOOP INDEX
!  GOES DOWNWARD TO EXPLOIT ANY COLUMNS
!  FROM A IN CORRECT RELATIVE ORDER
!
  jmin = ia(vk)
  jmax = ia(vk+1) - 1
  if (jmin .gt. jmax)  go to 1002
  j = jmax
20 jaj = ja(j)
    vj = ic(jaj)
!
!  STORE A(K,J) IN WORK VECTOR
!
    x(vj) = a(j)
!  THIS CODE INSERTS VJ INTO ADJACENCY LIST OF VK
    ppk = n+1
30 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  30,1003,40
40 p(vj) = ppk
    p(pk) = vj
    j = j - 1
    if (j .ge. jmin) go to 20
!
!  THE FOLLOWING CODE COMPUTES THE K-TH ROW OF U
!
  vi = n+1
  yk = b(vk)
50 vi = p(vi)
  if (vi .ge. k) go to 110
!
!  VI LT VK -- PROCESS THE L(K,I) ELEMENT AND MERGE THE
!  ADJACENCY OF VI WITH THE ORDERED ADJACENCY OF VK
!
  lki = - x(vi)
  x(vi) = 0.d0
!
!  ADJUST RIGHT HAND SIDE TO REFLECT ELIMINATION
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
!  IF VJ IS ALREADY IN THE ADJACENCY OF VK,
!  SKIP THE INSERTION
!
    if (x(vj) .ne. 0.d0)  go to 90
!
!  INSERT VJ IN ADJACENCY LIST OF VK.
!  RESET PPK TO VI IF WE HAVE PASSED THE CORRECT
!  INSERTION SPOT.  (THIS HAPPENS WHEN THE ADJACENCY OF
!  VI IS NOT IN CURRENT COLUMN ORDER DUE TO PIVOTING.)
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
!  COMPUTE L(K,J) = L(K,J) - L(K,I)*U(I,J) FOR L(K,I) NONZERO
!  COMPUTE U*(K,J) = U*(K,J) - L(K,I)*U(I,J) FOR U(K,J) NONZERO
!  (U*(K,J) = U(K,J)*D(K,K))
!
90 x(vj) = x(vj) + lki * u(j)
  end do
  go to 50
!
!  PIVOT--INTERCHANGE LARGEST ENTRY OF K-TH ROW OF U WITH
!  THE DIAGONAL ENTRY.
!
!  FIND LARGEST ENTRY, COUNTING OFF-DIAGONAL NONZEROS
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
!  IF VI = K, THEN THERE IS AN ENTRY FOR DIAGONAL
!  WHICH MUST BE DELETED.  OTHERWISE, DELETE THE
!  ENTRY WHICH WILL BECOME THE DIAGONAL ENTRY
!
  if (vi .eq. k) go to 140
  if (vi .eq. maxc) go to 140
  p(maxcl) = p(maxc)
  go to 150
140 vi = p(vi)
!
!  COMPUTE D(K) = 1/L(K,K) AND PERFORM INTERCHANGE.
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
!  UPDATE RIGHT HAND SIDE.
!
  y(k) = yk * dk
!
!  COMPUTE VALUE FOR IU(K+1) AND CHECK FOR STORAGE OVERFLOW
!
  iu(k+1) = iu(k) + nzcnt
  if (iu(k+1) .gt. max+1) go to 1005
!
!  MOVE COLUMN INDICES FROM LINKED LIST TO JU.
!  COLUMNS ARE STORED IN CURRENT ORDER WITH ORIGINAL
!  COLUMN NUMBER (C(J)) STORED FOR CURRENT COLUMN J
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
!  BACKSOLVE U X = Y, AND REORDER X TO CORRESPOND WITH A
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
!  RETURN WITH IERR = NUMBER OF OFF-DIAGONAL NONZEROS IN U
!
ierr = iu(n+1) - iu(1)
return
!
!  ERROR RETURNS
!
!  ROW K OF A IS NULL
!
1002 ierr = -k
return
!
!  ROW K OF A HAS A DUPLICATE ENTRY
!
1003 ierr = -(n+k)
return
!
!  ZERO PIVOT IN ROW K
!
1004 ierr = -(2*n+k)
return
!
!  STORAGE FOR U EXCEEDED ON ROW K
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
!          SOLUTION OF DOUBLE PRECISION SPARSE EQUATIONS
!-----------------------------------------------------------------------
!     DSLV EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES TO
!     SOLVE THE NXN LINEAR SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF DSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) THE LU DECOMPO-
!     SITION OF A IS OBTAINED WHERE U IS A UNIT UPPER TRIANGULAR
!     MATRIX. THEN THE EQUATIONS ARE SOLVED. ON SUBSEQUENT CALLS
!     (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     OBTAINED ON THE INITIAL CALL TO DSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     N        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     A,IA,JA  THE DOUBLE PRECISION MATRIX A STORED IN SPARSE FORM.
!
!     B        DOUBLE PRECISION ARRAY OF N ENTRIES CONTAINING THE
!              RIGHT HAND SIDE DATA.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     X        DOUBLE PRECISION ARRAY OF N ENTRIES CONTAINING THE
!              SOLUTION. B AND X MAY SHARE THE SAME STORAGE AREA.
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = B IS OBTAINED THEN IERR = MAX(1,M)
!              WHERE M IS THE TOTAL NUMBER OF OFF-DIAGONAL NONZERO
!              ENTRIES OF L AND U. OTHERWISE IERR.LE.0.
!
!
!     GENERAL STORAGE AREAS ---
!
!     IWK      INTEGER ARRAY OF DIMENSION 4*N + MAX + 2.
!
!     WK       DOUBLE PRECISION ARRAY OF DIMENSION 2*N + MAX.
!
!
!     AFTER AN INITIAL CALL TO DSLV, THE ROUTINE MAY BE RECALLED WITH
!     M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT N,A,IA,JA,
!     R,C,IWK,WK HAVE NOT BEEN MODIFIED. THE ROUTINE RETRIEVES THE LU
!     DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO DSLV
!     AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE A,IA,JA,MAX,
!     AND IERR ARE NOT REFERENCED.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     SET INDICES TO DIVIDE TEMPORARY STORAGE
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     COMPUTE THE INVERSE PERMUTATION OF C
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     OBTAIN THE LU DECOMPOSITION OF A
!
call dsplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     SOLVE THE SYSTEM OF EQUATIONS
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
!            SOLVE LY = B BY FORWARD SUBSTITUTION
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
!            SOLVE UX = B BY BACKWARD SUBSTITUTION
!             AND REORDER X TO CORRESPOND WITH A
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
!          SOLUTION OF DOUBLE PRECISION SPARSE EQUATIONS
!-----------------------------------------------------------------------
!     DTSLV EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES TO
!     SOLVE THE NXN LINEAR SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF DTSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) THE LU DECOMPO-
!     SITION OF A IS OBTAINED WHERE U IS A UNIT UPPER TRIANGULAR
!     MATRIX. THEN THE EQUATIONS ARE SOLVED. ON SUBSEQUENT CALLS
!     (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     OBTAINED ON THE INITIAL CALL TO DTSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     N        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     A,IA,JA  THE DOUBLE PRECISION MATRIX A STORED IN SPARSE FORM.
!
!     B        DOUBLE PRECISION ARRAY OF N ENTRIES CONTAINING THE
!              RIGHT HAND SIDE DATA.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     X        DOUBLE PRECISION ARRAY OF N ENTRIES CONTAINING THE
!              SOLUTION. B AND X MAY SHARE THE SAME STORAGE AREA.
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = B IS OBTAINED THEN IERR = MAX(1,M)
!              WHERE M IS THE TOTAL NUMBER OF OFF-DIAGONAL NONZERO
!              ENTRIES OF L AND U. OTHERWISE IERR.LE.0.
!
!
!     GENERAL STORAGE AREAS ---
!
!     IWK      INTEGER ARRAY OF DIMENSION 4*N + MAX + 2.
!
!     WK       DOUBLE PRECISION ARRAY OF DIMENSION 2*N + MAX.
!
!
!     AFTER AN INITIAL CALL TO DTSLV, THE ROUTINE MAY BE RECALLED WITH
!     M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT N,A,IA,JA,
!     R,C,IWK,WK HAVE NOT BEEN MODIFIED. THE ROUTINE RETRIEVES THE LU
!     DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO DTSLV
!     AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE A,IA,JA,MAX,
!     AND IERR ARE NOT REFERENCED.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     SET INDICES TO DIVIDE TEMPORARY STORAGE
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     COMPUTE THE INVERSE PERMUTATION OF C
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     OBTAIN THE LU DECOMPOSITION OF A
!
call dsplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     SOLVE THE SYSTEM OF EQUATIONS
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
!            SOLVE YU = B BY FORWARD SUBSTITUTION
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
!            SOLVE XL = Y BY BACKWARD SUBSTITUTION
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
!     DSPLU EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES
!     TO PERFORM THE LU DECOMPOSITION OF A DOUBLE PRECISION SPARSE
!     MATRIX. U IS A UNIT UPPER TRIANGULAR MATRIX.
!
!
!     INPUT ARGUMENTS ---
!
!     A,IA,JA  THE SPARSE MATRIX TO BE DECOMPOSED.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     IC       INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
!              (I.E., IC(C(I)) = I). IC IS ALSO AN OUTPUT ARGUMENT.
!
!     N        ORDER OF THE MATRIX A.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     IC       INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C.
!
!     D        DOUBLE PRECISION ARRAY CONTAINING THE N DIAGONAL
!              ELEMENTS OF L.
!
!     T,IT,IU  T CONTAINS THE OFF-DIAGONAL NONZERO ELEMENTS OF L AND
!              U. FOR I = 1,...,N THE OFF-DIAGONAL NONZERO ELEMENTS
!              OF THE I-TH ROW OF L ARE STORED IN LOCATIONS
!              IT(I),...,IU(I)-1 OF T, AND THE OFF-DIAGONAL NONZERO
!              ELEMENTS OF THE I-TH ROW OF U ARE STORED IN LOCATIONS
!              IU(I),...,IT(I+1)-1 OF T.
!
!     JT       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              TO THE ORGINAL COLUMN ORDERING) OF THE ELEMENTS OF T
!              (I.E., FOR EACH L(I,J) AND U(I,J) IN T, C(J) IS THE
!              CORRESPONDING COLUMN INDEX IN JT).
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU DECOMPOSITION IS OBTAINED THEN IERR = THE NUMBER
!              OF OFF-DIAGONAL ENTRIES OF L AND U WHICH WERE STORED
!              IN T. OTHERWISE IERR IS ASSIGNED A NEGATIVE VALUE.
!
!
!     WORK SPACES ---
!
!     W        DOUBLE PRECISION ARRAY OF DIMENSION N.
!
!     P        INTEGER ARRAY OF DIMENSION N+1.
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
!     PERFORM THE LU FACTORIZATION OF THE R(K)-TH ROW OF A
!
do 100 k = 1,n
lk = r(k)
jmin = ia(lk)
jmax = ia(lk+1) - 1
if (jmin .gt. jmax) go to 200
!
!     SET P TO THE REORDERED ROW OF A
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
!     PROCESS THE ENTRIES IN THE LOWER TRIANGLE OF A
!
i = n + 1
30 i = p(i)
if (i .ge. k) go to 50
if (w(i) .eq. 0.d0) go to 30
!
!     L(K,I) IS NONZERO. THEREFORE STORE IT IN L.
!
jptr = jptr + 1
if (jptr .gt. max) go to 230
const = w(i)
t(jptr) = const
jt(jptr) = c(i)
w(i) = 0.d0
!
!     PERFORM ELIMINATION USING THE I-TH ROW OF U
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
!     SEARCH FOR THE K-TH PIVOT ELEMENT
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
!     STORE THE PIVOT IN D
!
60 if (wmax .eq. 0.d0) go to 220
d(k) = w(maxi)
!
!     PERFORM THE COLUMN INTERCHANGE
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
!     THE REMAINING ELEMENTS OF P FORM THE K-TH ROW OF U
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
!     PREPARE FOR THE NEXT ROW
!
100 it(k+1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- ERROR RETURN --------------------
!
!     ROW R(K) IS NULL
!
200 ierr = -k
return
!
!     ROW R(K) HAS A DUPLICATE ENTRY
!
210 ierr = -(n + k)
return
!
!     ZERO PIVOT IN ROW R(K)
!
220 ierr = -(2*n + k)
return
!
!     STORAGE FOR L AND U EXCEEDED ON ROW R(K)
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
!              COMPUTATION OF THE L1 CONDITION NUMBER
!                       OF A SPARSE MATRIX A
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: wk(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
!-----------------------
!     REAL WK(4*N + MAX)
!     INTEGER IWK(5*N + MAX + 2)
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
!     CHECK IF A IS SINGULAR OR IF THERE ARE ERRORS
!
if (ierr .gt. 0) go to 20
if (iabs(ierr) .le. n) go to 50
ierr = ierr + n
if (iabs(ierr) .le. n) return
ierr = ierr + n
if (iabs(ierr) .le. n) go to 50
return
!
!     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
!     OF THE INVERSE OF A
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
!     COMPUTE THE VALUE OF COND
!
40 cond = anorm*ainorm
return
!
!     SINGULAR CASE
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
!              COMPUTATION OF THE L1 CONDITION NUMBER
!                       OF A SPARSE MATRIX A
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
double precision :: anorm, ainorm
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
!-----------------------
!     DOUBLE PRECISION WK(4*N + MAX)
!     INTEGER IWK(5*N + MAX + 2)
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
!     CHECK IF A IS SINGULAR OR IF THERE ARE ERRORS
!
if (ierr .gt. 0) go to 20
if (iabs(ierr) .le. n) go to 50
ierr = ierr + n
if (iabs(ierr) .le. n) return
ierr = ierr + n
if (iabs(ierr) .le. n) go to 50
return
!
!     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
!     OF THE INVERSE OF A
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
!     COMPUTE THE VALUE OF COND
!
40 cond = anorm*ainorm
return
!
!     SINGULAR CASE
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
!     SONEST ESTIMATES THE 1-NORM OF A SQUARE, REAL MATRIX  A.
!     REVERSE COMMUNICATION IS USED FOR EVALUATING
!     MATRIX-VECTOR PRODUCTS.
!
!     ON ENTRY
!
!        N       THE ORDER OF THE MATRIX.  N .GE. 1.
!
!        KASE    INTEGER  (= 0).
!
!     ON INTERMEDIATE RETURNS
!
!        KASE    = 1 OR 2.
!
!        X       MUST BE OVERWRITTEN BY
!
!                     A*X,             IF KASE = 1,
!                     TRANSPOSE(A)*X,  IF KASE = 2,
!
!                AND SONEST MUST BE RE-CALLED, WITH ALL THE OTHER
!                PARAMETERS UNCHANGED.
!
!        ITER    NUMBER OF THE CURRENT ITERATION.
!
!     ON FINAL RETURN
!
!        KASE    = 0.
!
!        ANORM   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!
!        V       = A*W,   WHERE  ANORM = NORM(V)/NORM(W)
!                         (W  IS NOT RETURNED).
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
!     ................ ENTRY   (JUMP = 1)
!     FIRST ITERATION.  X HAS BEEN OVERWRITTEN BY A*X.
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
!     ................ ENTRY   (JUMP = 2)
!     FIRST ITERATION.  X HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*X.
!
200 iter = 2
j = isamax(n,x,1)
!
!     MAIN LOOP - ITERATIONS 2,3,...,ITMAX.
!
210 do i = 1,n
   x(i) = 0.0
end do
x(j) = 1.0
kase = 1
jump = 3
return
!
!     ................ ENTRY   (JUMP = 3)
!     X HAS BEEN OVERWRITTEN BY A*X.
!
300 call scopy (n,x,1,v,1)
anrm = anorm
anorm = sasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) .lt. 0.0) l = -1
   if (l .ne. isgn(i)) go to 320
end do
!     REPEATED SIGN VECTOR DETECTED, HENCE ALGORITHM HAS CONVERGED.
go to 410
!
!     TEST FOR CYCLING.
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
!     ................ ENTRY   (JUMP = 4)
!     X HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*X.
!
400 jlast = j
j = isamax(n,x,1)
if (x(jlast) .eq. abs(x(j)) .or. &
&iter .ge. itmax) go to 410
iter = iter + 1
go to 210
!
!     ITERATION COMPLETE.  FINAL STAGE.
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
!     ................ ENTRY   (JUMP = 5)
!     X HAS BEEN OVERWRITTEN BY A*X.
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
!     DONEST ESTIMATES THE 1-NORM OF A SQUARE, REAL MATRIX  A.
!     REVERSE COMMUNICATION IS USED FOR EVALUATING
!     MATRIX-VECTOR PRODUCTS.
!
!     ON ENTRY
!
!        N       THE ORDER OF THE MATRIX.  N .GE. 1.
!
!        KASE    INTEGER  (= 0).
!
!     ON INTERMEDIATE RETURNS
!
!        KASE    = 1 OR 2.
!
!        X       MUST BE OVERWRITTEN BY
!
!                     A*X,             IF KASE = 1,
!                     TRANSPOSE(A)*X,  IF KASE = 2,
!
!                AND DONEST MUST BE RE-CALLED, WITH ALL THE OTHER
!                PARAMETERS UNCHANGED.
!
!        ITER    NUMBER OF THE CURRENT ITERATION.
!
!     ON FINAL RETURN
!
!        KASE    = 0.
!
!        ANORM   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!
!        V       = A*W,   WHERE  ANORM = NORM(V)/NORM(W)
!                         (W  IS NOT RETURNED).
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
!     ................ ENTRY   (JUMP = 1)
!     FIRST ITERATION.  X HAS BEEN OVERWRITTEN BY A*X.
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
!     ................ ENTRY   (JUMP = 2)
!     FIRST ITERATION.  X HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*X.
!
200 iter = 2
j = idamax(n,x,1)
!
!     MAIN LOOP - ITERATIONS 2,3,...,ITMAX.
!
210 do i = 1,n
   x(i) = 0.d0
end do
x(j) = 1.d0
kase = 1
jump = 3
return
!
!     ................ ENTRY   (JUMP = 3)
!     X HAS BEEN OVERWRITTEN BY A*X.
!
300 call dcopy (n,x,1,v,1)
anrm = anorm
anorm = dasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) .lt. 0.d0) l = -1
   if (l .ne. isgn(i)) go to 320
end do
!     REPEATED SIGN VECTOR DETECTED, HENCE ALGORITHM HAS CONVERGED.
go to 410
!
!     TEST FOR CYCLING.
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
!     ................ ENTRY   (JUMP = 4)
!     X HAS BEEN OVERWRITTEN BY TRANSPOSE(A)*X.
!
400 jlast = j
j = idamax(n,x,1)
if (x(jlast) .eq. dabs(x(j)) .or. &
&iter .ge. itmax) go to 410
iter = iter + 1
go to 210
!
!     ITERATION COMPLETE.  FINAL STAGE.
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
!     ................ ENTRY   (JUMP = 5)
!     X HAS BEEN OVERWRITTEN BY A*X.
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
!                 SOLUTION OF COMPLEX SPARSE MATRICES
!-----------------------------------------------------------------------
!  SPSLV CALLS CNSPIV WHICH USES SPARSE GAUSSIAN ELIMINATION WITH
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
!  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
!  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
!  PHASE SOLVES U X = Y.
!
!  INPUT ARGUMENTS---
!
!  N      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      COMPLEX ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         THE ACTUAL NONZEROS.  (SEE STORAGE DESCRIPTION BELOW)
!
!  IA     INTEGER ARRAY OF N+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  JA     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         COLUMN NUMBERS OF THE NONZEROS OF A.  (SEE MATRIX STORAGE
!         DESCRIPTION BELOW)
!
!  B      COMPLEX ARRAY OF N ENTRIES CONTAINING RIGHT HAND SIDE DATA
!
!  R      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         ROWS OF A (I.E., THE ELIMINATION ORDER FOR THE EQUATIONS)
!
!  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         COLUMNS OF A.  C IS ALSO AN OUTPUT ARGUMENT
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         NONZERO ENTRIES OF U WHICH MAY BE STORED
!
!  ITEMP  INTEGER ARRAY OF 3*N + MAX + 2 ENTRIES, FOR INTERNAL USE
!
!  RTEMP  COMPLEX ARRAY OF N + MAX ENTRIES FOR INTERNAL USE
!
!
!  OUTPUT ARGUMENTS---
!
!  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
!         COLUMNS OF U.  C IS ALSO AN INPUT ARGUMENT
!
!  X      COMPLEX ARRAY OF N ENTRIES CONTAINING THE SOLUTION VECTOR
!
!  IERR   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         THE ACTUAL NUMBER OF OFF-DIAGONAL ENTRIES IN U (FOR
!         SUCCESSFUL COMPLETION)
!
!         IERR VALUES ARE---
!
!         0 LT IERR             SUCCESSFUL COMPLETION. IERR=MAX(1,M)
!                               WHERE M IS THE NUMBER OF OFF-DIAGONAL
!                               NONZERO ENTRIES OF U.
!
!         IERR = 0              ERROR.  N IS LESS THAN OR EQUAL TO 0
!
!         -N LE IERR LT 0       ERROR.  ROW NUMBER IABS(IERR) OF A IS
!                               IS NULL
!
!         -2*N LE IERR LT -N    ERROR.  ROW NUMBER IABS(IERR+N) HAS A
!                               DUPLICATE ENTRY
!
!         -3*N LE IERR LT -2*N  ERROR.  ROW NUMBER IABS(IERR+2*N)
!                               HAS A ZERO PIVOT
!
!         -4*N LE IERR LT -3*N  ERROR.  ROW NUMBER IABS(IERR+3*N)
!                               EXCEEDS STORAGE
!
!
!  STORAGE OF SPARSE MATRICES---
!
!  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
!  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
!  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
!  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
!  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
!  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
!  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
!  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
!  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZERO
!  ELEMENTS IN A.
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
!  SET INDICES TO DIVIDE TEMPORARY STORAGE FOR CNSPIV
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  COMPUTE THE INVERSE PERMUTATION OF C
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL CNSPIV TO PERFORM COMPUTATIONS
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
!  CNSPIV USES SPARSE GAUSSIAN ELIMINATION WITH
!  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
!  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
!  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
!  PHASE SOLVES U X = Y.
!
!
!  SEE CSPSLV FOR DESCRIPTIONS OF ALL INPUT AND OUTPUT ARGUMENTS
!  OTHER THAN THOSE DESCRIBED BELOW
!
!  IC  INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
!      (I.E., IC(C(I)) = I). IC IS BOTH AN INPUT AND OUTPUT
!      ARGUMENT.
!
!  INPUT ARGUMENTS (USED INTERNALLY ONLY)---
!
!  Y   COMPLEX ARRAY OF N ENTRIES USED TO COMPUTE THE UPDATED
!      RIGHT HAND SIDE
!
!  P   INTEGER ARRAY OF N+1 ENTRIES USED FOR A LINKED LIST.
!      P(N+1) IS THE LIST HEADER, AND THE ENTRY FOLLOWING
!      P(K) IS IN P(P(K)).  THUS, P(N+1) IS THE FIRST DATA
!      ITEM, P(P(N+1)) IS THE SECOND, ETC.  A POINTER OF
!      N+1 MARKS THE END OF THE LIST
!
!  IU  INTEGER ARRAY OF N+1 ENTRIES USED FOR ROW POINTERS TO U
!      (SEE MATRIX STORAGE DESCRIPTION BELOW)
!
!  JU  INTEGER ARRAY OF MAX ENTRIES USED FOR COLUMN NUMBERS OF
!      THE NONZEROS IN THE STRICT UPPER TRIANGLE OF U.  (SEE
!      MATRIX STORAGE DESCRIPTION BELOW)
!
!  U   COMPLEX ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      THE STRICT UPPER TRIANGLE OF U.  (SEE MATRIX STORAGE
!      DESCRIPTION BELOW)
!
!
!  STORAGE OF SPARSE MATRICES---
!
!  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
!  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
!  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
!  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
!  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
!  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
!  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
!  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
!  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZEROS IN
!  A.  IU, JU, AND U ARE USED IN A SIMILAR WAY TO STORE THE STRICT UPPER
!  TRIANGLE OF U, EXCEPT THAT JU ACTUALLY CONTAINS C(J) INSTEAD OF J
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
!  INITIALIZE WORK STORAGE AND POINTERS TO JU
!
do j = 1,n
  x(j) = zero
end do
iu(1) = 1
juptr = 0
!
!  PERFORM SYMBOLIC AND NUMERIC FACTORIZATION ROW BY ROW
!  VK (VI,VJ) IS THE GRAPH VERTEX FOR ROW K (I,J) OF U
!
do 170 k = 1,n
!
!  INITIALIZE LINKED LIST AND FREE STORAGE FOR THIS ROW
!  THE R(K)-TH ROW OF A BECOMES THE K-TH ROW OF U.
!
  p(n+1) = n+1
  vk = r(k)
!
!  SET UP ADJACENCY LIST FOR VK, ORDERED IN
!  CURRENT COLUMN ORDER OF U.  THE LOOP INDEX
!  GOES DOWNWARD TO EXPLOIT ANY COLUMNS
!  FROM A IN CORRECT RELATIVE ORDER
!
  jmin = ia(vk)
  jmax = ia(vk+1) - 1
  if (jmin .gt. jmax)  go to 1002
  j = jmax
20 jaj = ja(j)
    vj = ic(jaj)
!
!  STORE A(K,J) IN WORK VECTOR
!
    x(vj) = a(j)
!  THIS CODE INSERTS VJ INTO ADJACENCY LIST OF VK
    ppk = n+1
30 pk = ppk
    ppk = p(pk)
    if (ppk - vj)  30,1003,40
40 p(vj) = ppk
    p(pk) = vj
    j = j - 1
    if (j .ge. jmin) go to 20
!
!  THE FOLLOWING CODE COMPUTES THE K-TH ROW OF U
!
  vi = n+1
  yk = b(vk)
50 vi = p(vi)
  if (vi .ge. k) go to 110
!
!  VI LT VK -- PROCESS THE L(K,I) ELEMENT AND MERGE THE
!  ADJACENCY OF VI WITH THE ORDERED ADJACENCY OF VK
!
  lki = - x(vi)
  x(vi) = zero
!
!  ADJUST RIGHT HAND SIDE TO REFLECT ELIMINATION
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
!  IF VJ IS ALREADY IN THE ADJACENCY OF VK,
!  SKIP THE INSERTION
!
    if (x(vj) .ne. zero)  go to 90
!
!  INSERT VJ IN ADJACENCY LIST OF VK.
!  RESET PPK TO VI IF WE HAVE PASSED THE CORRECT
!  INSERTION SPOT.  (THIS HAPPENS WHEN THE ADJACENCY OF
!  VI IS NOT IN CURRENT COLUMN ORDER DUE TO PIVOTING.)
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
!  COMPUTE L(K,J) = L(K,J) - L(K,I)*U(I,J) FOR L(K,I) NONZERO
!  COMPUTE U*(K,J) = U*(K,J) - L(K,I)*U(I,J) FOR U(K,J) NONZERO
!  (U*(K,J) = U(K,J)*D(K,K))
!
90 x(vj) = x(vj) + lki * u(j)
  end do
  go to 50
!
!  PIVOT--INTERCHANGE LARGEST ENTRY OF K-TH ROW OF U WITH
!  THE DIAGONAL ENTRY.
!
!  FIND LARGEST ENTRY, COUNTING OFF-DIAGONAL NONZEROS
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
!  IF VI = K, THEN THERE IS AN ENTRY FOR DIAGONAL
!  WHICH MUST BE DELETED.  OTHERWISE, DELETE THE
!  ENTRY WHICH WILL BECOME THE DIAGONAL ENTRY
!
  if (vi .eq. k) go to 140
  if (vi .eq. maxc) go to 140
  p(maxcl) = p(maxc)
  go to 150
140 vi = p(vi)
!
!  COMPUTE D(K) = 1/L(K,K) AND PERFORM INTERCHANGE.
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
!  UPDATE RIGHT HAND SIDE.
!
  y(k) = yk * dk
!
!  COMPUTE VALUE FOR IU(K+1) AND CHECK FOR STORAGE OVERFLOW
!
  iu(k+1) = iu(k) + nzcnt
  if (iu(k+1) .gt. max+1) go to 1005
!
!  MOVE COLUMN INDICES FROM LINKED LIST TO JU.
!  COLUMNS ARE STORED IN CURRENT ORDER WITH ORIGINAL
!  COLUMN NUMBER (C(J)) STORED FOR CURRENT COLUMN J
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
!  BACKSOLVE U X = Y, AND REORDER X TO CORRESPOND WITH A
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
!  RETURN WITH IERR = NUMBER OF OFF-DIAGONAL NONZEROS IN U
!
ierr = iu(n+1) - iu(1)
return
!
!  ERROR RETURNS
!
!  ROW K OF A IS NULL
!
1002 ierr = -k
return
!
!  ROW K OF A HAS A DUPLICATE ENTRY
!
1003 ierr = -(n+k)
return
!
!  ZERO PIVOT IN ROW K
!
1004 ierr = -(2*n+k)
return
!
!  STORAGE FOR U EXCEEDED ON ROW K
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
!                 SOLUTION OF COMPLEX SPARSE MATRICES
!-----------------------------------------------------------------------
!     CSLV EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES TO
!     SOLVE THE NXN COMPLEX SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF CSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) THE LU DECOMPO-
!     SITION OF A IS OBTAINED WHERE U IS A UNIT UPPER TRIANGULAR
!     MATRIX. THEN THE EQUATIONS ARE SOLVED. ON SUBSEQUENT CALLS
!     (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     OBTAINED ON THE INITIAL CALL TO CSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     N        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     A,IA,JA  THE COMPLEX MATRIX A STORED IN SPARSE FORM.
!
!     B        COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
!              SIDE DATA.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     X        COMPLEX ARRAY OF N ENTRIES CONTAINING THE SOLUTION.
!              B AND X MAY SHARE THE SAME STORAGE AREA.
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = B IS OBTAINED THEN IERR = MAX(1,M)
!              WHERE M IS THE TOTAL NUMBER OF OFF-DIAGONAL NONZERO
!              ENTRIES OF L AND U. OTHERWISE IERR.LE.0.
!
!
!     GENERAL STORAGE AREAS ---
!
!     IWK      INTEGER ARRAY OF DIMENSION 4*N + MAX + 2.
!
!     WK       COMPLEX ARRAY OF DIMENSION 2*N + MAX.
!
!
!     AFTER AN INITIAL CALL TO CSLV, THE ROUTINE MAY BE RECALLED WITH
!     M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT N,A,IA,JA,
!     R,C,IWK,WK HAVE NOT BEEN MODIFIED. THE ROUTINE RETRIEVES THE LU
!     DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO CSLV
!     AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE A,IA,JA,MAX,
!     AND IERR ARE NOT REFERENCED.
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     SET INDICES TO DIVIDE TEMPORARY STORAGE
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     COMPUTE THE INVERSE PERMUTATION OF C
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     OBTAIN THE LU DECOMPOSITION OF A
!
call csplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     SOLVE THE SYSTEM OF EQUATIONS
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
!            SOLVE LY = B BY FORWARD SUBSTITUTION
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
!            SOLVE UX = B BY BACKWARD SUBSTITUTION
!             AND REORDER X TO CORRESPOND WITH A
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
!                 SOLUTION OF COMPLEX SPARSE MATRICES
!-----------------------------------------------------------------------
!     CTSLV EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES TO
!     SOLVE THE NXN COMPLEX SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF CTSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) THE LU DECOMPO-
!     SITION OF A IS OBTAINED WHERE U IS A UNIT UPPER TRIANGULAR
!     MATRIX. THEN THE EQUATIONS ARE SOLVED. ON SUBSEQUENT CALLS
!     (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED USING THE DECOMPOSITION
!     OBTAINED ON THE INITIAL CALL TO CTSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     N        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     A,IA,JA  THE COMPLEX MATRIX A STORED IN SPARSE FORM.
!
!     B        COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
!              SIDE DATA.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     X        COMPLEX ARRAY OF N ENTRIES CONTAINING THE SOLUTION.
!              B AND X MAY SHARE THE SAME STORAGE AREA.
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              SOLUTION OF AX = B IS OBTAINED THEN IERR = MAX(1,M)
!              WHERE M IS THE TOTAL NUMBER OF OFF-DIAGONAL NONZERO
!              ENTRIES OF L AND U. OTHERWISE IERR.LE.0.
!
!
!     GENERAL STORAGE AREAS ---
!
!     IWK      INTEGER ARRAY OF DIMENSION 4*N + MAX + 2.
!
!     WK       COMPLEX ARRAY OF DIMENSION 2*N + MAX.
!
!
!     AFTER AN INITIAL CALL TO CTSLV, THE ROUTINE MAY BE RECALLED WITH
!     M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT N,A,IA,JA,
!     R,C,IWK,WK HAVE NOT BEEN MODIFIED. THE ROUTINE RETRIEVES THE LU
!     DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO CTSLV
!     AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE A,IA,JA,MAX,
!     AND IERR ARE NOT REFERENCED.
!-----------------------------------------------------------------------
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: y, t, p
!
!     SET INDICES TO DIVIDE TEMPORARY STORAGE
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 .ne. 0) go to 20
!
!     COMPUTE THE INVERSE PERMUTATION OF C
!
ierr = 0
if (n .le. 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     OBTAIN THE LU DECOMPOSITION OF A
!
call csplu (a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
&iwk(iu),wk(y),iwk(p),ierr)
if (ierr .lt. 0) return
ierr = max0(1,ierr)
!
!     SOLVE THE SYSTEM OF EQUATIONS
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
!            SOLVE YU = B BY FORWARD SUBSTITUTION
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
!            SOLVE XL = Y BY BACKWARD SUBSTITUTION
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
!     CSPLU EMPLOYS GAUSSIAN ELIMINATION WITH COLUMN INTERCHANGES
!     TO PERFORM THE LU DECOMPOSITION OF A COMPLEX SPARSE MATRIX.
!     U IS A UNIT UPPER TRIANGULAR MATRIX.
!
!
!     INPUT ARGUMENTS ---
!
!     A,IA,JA  THE COMPLEX SPARSE MATRIX TO BE DECOMPOSED.
!
!     R        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE ROWS OF A.
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING A SUGGESTED
!              ORDER OF THE COLUMNS. C IS ALSO AN OUTPUT ARGUMENT.
!
!     IC       INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
!              (I.E., IC(C(I)) = I). IC IS ALSO AN OUTPUT ARGUMENT.
!
!     N        ORDER OF THE MATRIX A.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              NONZERO ENTRIES OF L AND U WHICH MAY BE STORED.
!
!
!     OUTPUT ARGUMENTS ---
!
!     C        INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF
!              THE COLUMNS THAT WAS SELECTED BY THE ROUTINE.
!
!     IC       INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C.
!
!     D        COMPLEX ARRAY CONTAINING THE N DIAGONAL ELEMENTS OF L.
!
!     T,IT,IU  T CONTAINS THE OFF-DIAGONAL NONZERO ELEMENTS OF L AND
!              U. FOR I = 1,...,N THE OFF-DIAGONAL NONZERO ELEMENTS
!              OF THE I-TH ROW OF L ARE STORED IN LOCATIONS
!              IT(I),...,IU(I)-1 OF T, AND THE OFF-DIAGONAL NONZERO
!              ELEMENTS OF THE I-TH ROW OF U ARE STORED IN LOCATIONS
!              IU(I),...,IT(I+1)-1 OF T. T IS A COMPLEX ARRAY.
!
!     JT       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              TO THE ORGINAL COLUMN ORDERING) OF THE ELEMENTS OF T
!              (I.E., FOR EACH L(I,J) AND U(I,J) IN T, C(J) IS THE
!              CORRESPONDING COLUMN INDEX IN JT).
!
!     IERR     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU DECOMPOSITION IS OBTAINED THEN IERR = THE NUMBER
!              OF OFF-DIAGONAL ENTRIES OF L AND U WHICH WERE STORED
!              IN T. OTHERWISE IERR IS ASSIGNED A NEGATIVE VALUE.
!
!
!     WORK SPACES ---
!
!     W        COMPLEX ARRAY OF DIMENSION N.
!
!     P        INTEGER ARRAY OF DIMENSION N+1.
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
!     PERFORM THE LU FACTORIZATION OF THE R(K)-TH ROW OF A
!
do 100 k = 1,n
lk = r(k)
jmin = ia(lk)
jmax = ia(lk+1) - 1
if (jmin .gt. jmax) go to 200
!
!     SET P TO THE REORDERED ROW OF A
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
!     PROCESS THE ENTRIES IN THE LOWER TRIANGLE OF A
!
i = n + 1
30 i = p(i)
if (i .ge. k) go to 50
if (w(i) .eq. zero) go to 30
!
!     L(K,I) IS NONZERO. THEREFORE STORE IT IN L.
!
jptr = jptr + 1
if (jptr .gt. max) go to 230
const = w(i)
t(jptr) = const
jt(jptr) = c(i)
w(i) = zero
!
!     PERFORM ELIMINATION USING THE I-TH ROW OF U
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
!     SEARCH FOR THE K-TH PIVOT ELEMENT
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
!     STORE THE PIVOT IN D
!
60 if (wmax .eq. 0.0) go to 220
d(k) = w(maxi)
!
!     PERFORM THE COLUMN INTERCHANGE
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
!     THE REMAINING ELEMENTS OF P FORM THE K-TH ROW OF U
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
!     PREPARE FOR THE NEXT ROW
!
100 it(k+1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- ERROR RETURN --------------------
!
!     ROW R(K) IS NULL
!
200 ierr = -k
return
!
!     ROW R(K) HAS A DUPLICATE ENTRY
!
210 ierr = -(n + k)
return
!
!     ZERO PIVOT IN ROW R(K)
!
220 ierr = -(2*n + k)
return
!
!     STORAGE FOR L AND U EXCEEDED ON ROW R(K)
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
!                    EIGENVALUES OF REAL MATRICES
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
!                    EIGENVALUES OF REAL MATRICES
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
!           EIGENVALUES AND EIGENVECTORS OF REAL MATRICES
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
!           EIGENVALUES AND EIGENVECTORS OF REAL MATRICES
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
!     REAL ABS
logical :: noconv
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE BALANCE,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     THIS SUBROUTINE BALANCES A REAL MATRIX AND ISOLATES
!     EIGENVALUES WHENEVER POSSIBLE.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        A CONTAINS THE INPUT MATRIX TO BE BALANCED.
!
!     ON OUTPUT-
!
!        A CONTAINS THE BALANCED MATRIX,
!
!        LOW AND IGH ARE TWO INTEGERS SUCH THAT A(I,J)
!          IS EQUAL TO ZERO IF
!           (1) I IS GREATER THAN J AND
!           (2) J=1,...,LOW-1 OR I=IGH+1,...,N,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE
!           PERMUTATIONS AND SCALING FACTORS USED.
!
!     SUPPOSE THAT THE PRINCIPAL SUBMATRIX IN ROWS LOW THROUGH IGH
!     HAS BEEN BALANCED, THAT P(J) DENOTES THE INDEX INTERCHANGED
!     WITH J DURING THE PERMUTATION STEP, AND THAT THE ELEMENTS
!     OF THE DIAGONAL MATRIX USED ARE DENOTED BY D(I,J).  THEN
!        SCALE(J) = P(J),    FOR J = 1,...,LOW-1
!                 = D(J,J),      J = LOW,...,IGH
!                 = P(J)         J = IGH+1,...,N.
!     THE ORDER IN WHICH THE INTERCHANGES ARE MADE IS N TO IGH+1,
!     THEN 1 TO LOW-1.
!
!     NOTE THAT 1 IS RETURNED FOR IGH IF IGH IS ZERO FORMALLY.
!
!     THE ALGOL PROCEDURE EXC CONTAINED IN BALANCE APPEARS IN
!     BALANC  IN LINE.  (NOTE THAT THE ALGOL ROLES OF IDENTIFIERS
!     K,L HAVE BEEN REVERSED.)
!
!-----------------------------------------------------------------------
!
!     ********** RADIX IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE BASE OF THE MACHINE FLOATING POINT REPRESENTATION.
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
!     ********** FOR J=L STEP -1 UNTIL 1 DO -- **********
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
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS K TO L **********
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
!     ********** GUARD AGAINST ZERO C OR R DUE TO UNDERFLOW **********
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
!        GIVEN A MATRIX A OF ORDER N. BALANC TRANSFORMS A INTO
!     THE MATRIX B BY THE SIMILARITY TRANSFORMATION
!             B = D**(-1)*TRANSPOSE(P)*A*P*D
!     WHERE D IS A DIAGONAL MATRIX AND P A PERMUTATION MATRIX.
!     THE INFORMATION CONCERNING D AND P IS STORED IN IGH, LOW,
!     AND SCALE. THE ORDER IN WHICH THE INTERCHANGES WERE MADE
!     IS N TO IGH + 1, AND THEN 1 TO LOW - 1.
!
!        Z IS A MATRIX OF ORDER N. BALINV TRANSFORMS Z INTO THE
!     MATRIX W USING THE INVERSE SIMILARITY TRANSFORM
!             W = P*D*Z*D**(-1)*TRANSPOSE(P)
!
!     ON INPUT-
!
!        NZ IS THE ROW DIMENSION OF THE MATRIX Z IN THE CALLING
!          PROGRAM,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY  BALANC,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE PERMUTATIONS
!          AND SCALING FACTORS USED BY  BALANC,
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMED MATRIX W
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
!     ********- FOR I=LOW-1 STEP -1 UNTIL 1,
!               IGH+1 STEP 1 UNTIL N DO -- **********
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
!     REAL ABS
integer, intent(inout) :: int(igh)
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ELMHES,
!     NUM. MATH. 12, 349-368(1968) BY MARTIN AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
!
!     GIVEN A REAL GENERAL MATRIX, THIS SUBROUTINE
!     REDUCES A SUBMATRIX SITUATED IN ROWS AND COLUMNS
!     LOW THROUGH IGH TO UPPER HESSENBERG FORM BY
!     STABILIZED ELEMENTARY SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS THE INPUT MATRIX.
!
!     ON OUTPUT-
!
!        A CONTAINS THE HESSENBERG MATRIX.  THE MULTIPLIERS
!          WHICH WERE USED IN THE REDUCTION ARE STORED IN THE
!          REMAINING TRIANGLE UNDER THE HESSENBERG MATRIX,
!
!        INT CONTAINS INFORMATION ON THE ROWS AND COLUMNS
!          INTERCHANGED IN THE REDUCTION.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
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
!    ********** INTERCHANGE ROWS AND COLUMNS OF A **********
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
!     REAL ABS
real, intent(inout) :: int(igh)
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ELMHES,
!     NUM. MATH. 12, 349-368(1968) BY MARTIN AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
!
!     GIVEN A REAL GENERAL MATRIX, THIS SUBROUTINE
!     REDUCES A SUBMATRIX SITUATED IN ROWS AND COLUMNS
!     LOW THROUGH IGH TO UPPER HESSENBERG FORM BY
!     STABILIZED ELEMENTARY SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS THE INPUT MATRIX.
!
!     ON OUTPUT-
!
!        A CONTAINS THE HESSENBERG MATRIX.  THE MULTIPLIERS
!          WHICH WERE USED IN THE REDUCTION ARE STORED IN THE
!          REMAINING TRIANGLE UNDER THE HESSENBERG MATRIX,
!
!        INT CONTAINS INFORMATION ON THE ROWS AND COLUMNS
!          INTERCHANGED IN THE REDUCTION.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
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
!    ********** INTERCHANGE ROWS AND COLUMNS OF A **********
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
!     REAL SQRT,ABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTHES,
!     NUM. MATH. 12, 349-368(1968) BY MARTIN AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
!
!     GIVEN A REAL GENERAL MATRIX, THIS SUBROUTINE
!     REDUCES A SUBMATRIX SITUATED IN ROWS AND COLUMNS
!     LOW THROUGH IGH TO UPPER HESSENBERG FORM BY
!     ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS THE INPUT MATRIX.
!
!     ON OUTPUT-
!
!        A CONTAINS THE HESSENBERG MATRIX.  INFORMATION ABOUT
!          THE ORTHOGONAL TRANSFORMATIONS USED IN THE REDUCTION
!          IS STORED IN THE REMAINING TRIANGLE UNDER THE
!          HESSENBERG MATRIX,
!
!        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANSFORMATIONS.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
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
!     ********** SCALE COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + abs(a(i,m-1))
!
   if (scale .eq. 0.0) go to 180
   mp = m + igh
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H) * A **********
   do j = m, n
      f = 0.0
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H)*A*(I-(U*UT)/H) **********
   do i = 1, igh
      f = 0.0
!     ********** FOR J=IGH STEP -1 UNTIL M DO -- **********
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
!     REAL SQRT,ABS
!     INTEGER MIN0
logical :: notlas
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE HQR,
!     NUM. MATH. 14, 219-231(1970) BY MARTIN, PETERS, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 359-371(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES OF A REAL
!     UPPER HESSENBERG MATRIX BY THE QR METHOD.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        H CONTAINS THE UPPER HESSENBERG MATRIX.  INFORMATION ABOUT
!          THE TRANSFORMATIONS USED IN THE REDUCTION TO HESSENBERG
!          FORM BY  ELMHES  OR  ORTHES, IF PERFORMED, IS STORED
!          IN THE REMAINING TRIANGLE UNDER THE HESSENBERG MATRIX.
!
!     ON OUTPUT-
!
!        H HAS BEEN DESTROYED.  THEREFORE, IT MUST BE SAVED
!          BEFORE CALLING  HQR  IF SUBSEQUENT CALCULATION AND
!          BACK TRANSFORMATION OF EIGENVECTORS IS TO BE PERFORMED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
!          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
!          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
!          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
norm = 0.0
k = 1
!     ********** STORE ROOTS ISOLATED BY BALANC
!                AND COMPUTE MATRIX NORM **********
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
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
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
!                SUB-DIAGONAL ELEMENTS.
!                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
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
!     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
!                COLUMNS M TO EN **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE BALBAK,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     THIS SUBROUTINE FORMS THE EIGENVECTORS OF A REAL GENERAL
!     MATRIX BY BACK TRANSFORMING THOSE OF THE CORRESPONDING
!     BALANCED MATRIX DETERMINED BY  BALANC.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY  BALANC,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE PERMUTATIONS
!          AND SCALING FACTORS USED BY  BALANC,
!
!        M IS THE NUMBER OF COLUMNS OF Z TO BE BACK TRANSFORMED,
!
!        Z CONTAINS THE REAL AND IMAGINARY PARTS OF THE EIGEN-
!          VECTORS TO BE BACK TRANSFORMED IN ITS FIRST M COLUMNS.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE REAL AND IMAGINARY PARTS OF THE
!          TRANSFORMED EIGENVECTORS IN ITS FIRST M COLUMNS.
!
!-----------------------------------------------------------------------
!
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                IF THE FOREGOING STATEMENT IS REPLACED BY
!                S=1.0/SCALE(I). **********
   do 100 j = 1, m
100 z(i,j) = z(i,j) * s
!
end do
!     ********- FOR I=LOW-1 STEP -1 UNTIL 1,
!               IGH+1 STEP 1 UNTIL N DO -- **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ELMTRANS,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE ACCUMULATES THE STABILIZED ELEMENTARY
!     SIMILARITY TRANSFORMATIONS USED IN THE REDUCTION OF A
!     REAL GENERAL MATRIX TO UPPER HESSENBERG FORM BY  ELMHES.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS THE MULTIPLIERS WHICH WERE USED IN THE
!          REDUCTION BY  ELMHES  IN ITS LOWER TRIANGLE
!          BELOW THE SUBDIAGONAL,
!
!        INT CONTAINS INFORMATION ON THE ROWS AND COLUMNS
!          INTERCHANGED IN THE REDUCTION BY  ELMHES.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  ELMHES.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE Z TO IDENTITY MATRIX **********
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
!     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ELMTRANS,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE ACCUMULATES THE STABILIZED ELEMENTARY
!     SIMILARITY TRANSFORMATIONS USED IN THE REDUCTION OF A
!     REAL GENERAL MATRIX TO UPPER HESSENBERG FORM BY  ELMHS0.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS THE MULTIPLIERS WHICH WERE USED IN THE
!          REDUCTION BY  ELMHS0  IN ITS LOWER TRIANGLE
!          BELOW THE SUBDIAGONAL,
!
!        INT CONTAINS INFORMATION ON THE ROWS AND COLUMNS
!          INTERCHANGED IN THE REDUCTION BY  ELMHS0.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  ELMHS0.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE Z TO IDENTITY MATRIX **********
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
!     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTRANS,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE ACCUMULATES THE ORTHOGONAL SIMILARITY
!     TRANSFORMATIONS USED IN THE REDUCTION OF A REAL GENERAL
!     MATRIX TO UPPER HESSENBERG FORM BY  ORTHES.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
!          FORMATIONS USED IN THE REDUCTION BY  ORTHES
!          IN ITS STRICT LOWER TRIANGLE,
!
!        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANS-
!          FORMATIONS USED IN THE REDUCTION BY  ORTHES.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  ORTHES,
!
!        ORT HAS BEEN ALTERED.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE Z TO IDENTITY MATRIX **********
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
!     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
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
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN ORTHES.
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTRANS,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE ACCUMULATES THE ORTHOGONAL SIMILARITY
!     TRANSFORMATIONS USED IN THE REDUCTION OF A REAL GENERAL
!     MATRIX TO UPPER HESSENBERG FORM BY  ORTHES.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
!          FORMATIONS USED IN THE REDUCTION BY  ORTHES
!          IN ITS STRICT LOWER TRIANGLE,
!
!        NA MUST BE SET TO THE ROW DIMENSION OF THE 2-DIMENSIONAL
!          ARRAY PARAMETER  A  AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        NZ MUST BE SET TO THE ROW DIMENSION OF THE 2-DIMENSIONAL
!          ARRAY PARAMETER  Z  AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANS-
!          FORMATIONS USED IN THE REDUCTION BY  ORTHES.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  ORTHES,
!
!        ORT HAS BEEN ALTERED.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE Z TO IDENTITY MATRIX **********
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
!     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
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
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN ORTHES.
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
!     REAL SQRT,ABS
!     INTEGER MIN0
logical :: notlas
complex :: z3
!     COMPLEX CMPLX
!     REAL REAL,AIMAG
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE HQR2,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
!     OF A REAL UPPER HESSENBERG MATRIX BY THE QR METHOD.  THE
!     EIGENVECTORS OF A REAL GENERAL MATRIX CAN ALSO BE FOUND
!     IF  ELMHES  AND  ELTRAN  OR  ORTHES  AND  ORTRAN  HAVE
!     BEEN USED TO REDUCE THIS GENERAL MATRIX TO HESSENBERG FORM
!     AND TO ACCUMULATE THE SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        H CONTAINS THE UPPER HESSENBERG MATRIX,
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED BY  ELTRAN
!          AFTER THE REDUCTION BY  ELMHES, OR BY  ORTRAN  AFTER THE
!          REDUCTION BY  ORTHES, IF PERFORMED.  IF THE EIGENVECTORS
!          OF THE HESSENBERG MATRIX ARE DESIRED, Z MUST CONTAIN THE
!          IDENTITY MATRIX.
!
!     ON OUTPUT-
!
!        H HAS BEEN DESTROYED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
!          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
!          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
!          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        Z CONTAINS THE REAL AND IMAGINARY PARTS OF THE EIGENVECTORS.
!          IF THE I-TH EIGENVALUE IS REAL, THE I-TH COLUMN OF Z
!          CONTAINS ITS EIGENVECTOR.  IF THE I-TH EIGENVALUE IS COMPLEX
!          WITH POSITIVE IMAGINARY PART, THE I-TH AND (I+1)-TH
!          COLUMNS OF Z CONTAIN THE REAL AND IMAGINARY PARTS OF ITS
!          EIGENVECTOR.  THE EIGENVECTORS ARE UNNORMALIZED.  IF AN
!          ERROR EXIT IS MADE, NONE OF THE EIGENVECTORS HAS BEEN FOUND,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!     ARITHMETIC IS REAL EXCEPT FOR THE REPLACEMENT OF THE ALGOL
!     PROCEDURE CDIV BY COMPLEX DIVISION.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
norm = 0.0
k = 1
!     ********** STORE ROOTS ISOLATED BY BALANC
!                AND COMPUTE MATRIX NORM **********
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
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
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
!                SUB-DIAGONAL ELEMENTS.
!                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
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
!     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
!                COLUMNS M TO EN **********
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
!     ********** FOR EN=N STEP -1 UNTIL 1 DO -- **********
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
!     ********** FOR I=EN-1 STEP -1 UNTIL 1 DO -- **********
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
!     ********** FOR I=EN-2 STEP -1 UNTIL 1 DO -- **********
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
!                VECTORS OF ORIGINAL FULL MATRIX.
!                FOR J=N STEP -1 UNTIL LOW DO -- **********
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
!                EIGENVALUES OF DOUBLE PRECISION MATRICES
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
!     EIGENVALUES AND EIGENVECTORS OF DOUBLE PRECISION MATRICES
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
!     DOUBLE PRECISION DABS
logical :: noconv
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE BALANCE,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     DBAL BALANCES A DOUBLE PRECISION REAL MATRIX AND ISOLATES
!     EIGENVALUES WHENEVER POSSIBLE.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        A CONTAINS THE INPUT MATRIX TO BE BALANCED.
!
!     ON OUTPUT-
!
!        A CONTAINS THE BALANCED MATRIX,
!
!        LOW AND IGH ARE TWO INTEGERS SUCH THAT A(I,J)
!          IS EQUAL TO ZERO IF
!           (1) I IS GREATER THAN J AND
!           (2) J=1,...,LOW-1 OR I=IGH+1,...,N,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE
!           PERMUTATIONS AND SCALING FACTORS USED.
!
!     SUPPOSE THAT THE PRINCIPAL SUBMATRIX IN ROWS LOW THROUGH IGH
!     HAS BEEN BALANCED, THAT P(J) DENOTES THE INDEX INTERCHANGED
!     WITH J DURING THE PERMUTATION STEP, AND THAT THE ELEMENTS
!     OF THE DIAGONAL MATRIX USED ARE DENOTED BY D(I,J).  THEN
!        SCALE(J) = P(J),    FOR J = 1,...,LOW-1
!                 = D(J,J),      J = LOW,...,IGH
!                 = P(J)         J = IGH+1,...,N.
!     THE ORDER IN WHICH THE INTERCHANGES ARE MADE IS N TO IGH+1,
!     THEN 1 TO LOW-1.
!
!     NOTE THAT 1 IS RETURNED FOR IGH IF IGH IS ZERO FORMALLY.
!
!     THE ALGOL PROCEDURE EXC CONTAINED IN BALANCE APPEARS IN
!     DBAL IN LINE.  (NOTE THAT THE ALGOL ROLES OF IDENTIFIERS
!     K,L HAVE BEEN REVERSED.)
!
!-----------------------------------------------------------------------
!
!     ********** RADIX IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE BASE OF THE MACHINE FLOATING POINT REPRESENTATION.
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
!     ********** FOR J=L STEP -1 UNTIL 1 DO -- **********
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
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS K TO L **********
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
!     ********** GUARD AGAINST ZERO C OR R DUE TO UNDERFLOW **********
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
!        GIVEN A MATRIX A OF ORDER N. DBAL TRANSFORMS A INTO
!     THE MATRIX B BY THE SIMILARITY TRANSFORMATION
!             B = D**(-1)*TRANSPOSE(P)*A*P*D
!     WHERE D IS A DIAGONAL MATRIX AND P A PERMUTATION MATRIX.
!     THE INFORMATION CONCERNING D AND P IS STORED IN IGH, LOW,
!     AND SCALE. THE ORDER IN WHICH THE INTERCHANGES WERE MADE
!     IS N TO IGH + 1, AND THEN 1 TO LOW - 1.
!
!        Z IS A MATRIX OF ORDER N. DBALNV TRANSFORMS Z INTO THE
!     MATRIX W USING THE INVERSE SIMILARITY TRANSFORM
!             W = P*D*Z*D**(-1)*TRANSPOSE(P)
!
!     ON INPUT-
!
!        NZ IS THE ROW DIMENSION OF THE MATRIX Z IN THE CALLING
!          PROGRAM,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY  DBAL,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE PERMUTATIONS
!          AND SCALING FACTORS USED BY  DBAL,
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMED MATRIX W
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
!     ********- FOR I=LOW-1 STEP -1 UNTIL 1,
!               IGH+1 STEP 1 UNTIL N DO -- **********
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
!     DOUBLE PRECISION DSQRT,DABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTHES,
!     NUM. MATH. 12, 349-368(1968) BY MARTIN AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
!
!     GIVEN A REAL GENERAL MATRIX, THIS SUBROUTINE
!     REDUCES A SUBMATRIX SITUATED IN ROWS AND COLUMNS
!     LOW THROUGH IGH TO UPPER HESSENBERG FORM BY
!     ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DBAL.  IF DBAL HAS NOT BEEN USED THEN
!          SET LOW=1, IGH=N,
!
!        A CONTAINS THE INPUT MATRIX.
!
!     ON OUTPUT-
!
!        A CONTAINS THE HESSENBERG MATRIX.  INFORMATION ABOUT
!          THE ORTHOGONAL TRANSFORMATIONS USED IN THE REDUCTION
!          IS STORED IN THE REMAINING TRIANGLE UNDER THE
!          HESSENBERG MATRIX,
!
!        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANSFORMATIONS.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
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
!     ********** SCALE COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + dabs(a(i,m-1))
!
   if (scale .eq. 0.d0) go to 180
   mp = m + igh
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H) * A **********
   do j = m, n
      f = 0.d0
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H)*A*(I-(U*UT)/H) **********
   do i = 1, igh
      f = 0.d0
!     ********** FOR J=IGH STEP -1 UNTIL M DO -- **********
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
!     DOUBLE PRECISION DSQRT,DABS
!     INTEGER MIN0
logical :: notlas
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE HQR,
!     NUM. MATH. 14, 219-231(1970) BY MARTIN, PETERS, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 359-371(1971).
!
!     DHQR FINDS THE EIGENVALUES OF A DOUBLE PRECISION REAL
!     UPPER HESSENBERG MATRIX BY THE QR METHOD.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DBAL.  IF DBAL HAS NOT BEEN USED THEN
!          SET LOW=1, IGH=N,
!
!        H CONTAINS THE UPPER HESSENBERG MATRIX.  INFORMATION ABOUT
!          THE TRANSFORMATIONS USED IN THE REDUCTION TO HESSENBERG
!          FORM BY DORTH, IF PERFORMED, IS STORED
!          IN THE REMAINING TRIANGLE UNDER THE HESSENBERG MATRIX.
!
!     ON OUTPUT-
!
!        H HAS BEEN DESTROYED.  THEREFORE, IT MUST BE SAVED
!          BEFORE CALLING  HQR  IF SUBSEQUENT CALCULATION AND
!          BACK TRANSFORMATION OF EIGENVECTORS IS TO BE PERFORMED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
!          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
!          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
!          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0
!                IN THE DOUBLE PRECISION ARITHMETIC BEING USED.
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
norm = 0.d0
k = 1
!     ********** STORE ROOTS ISOLATED BY DBAL
!                AND COMPUTE MATRIX NORM **********
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
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
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
!                SUB-DIAGONAL ELEMENTS.
!                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
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
!     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
!                COLUMNS M TO EN **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE BALBAK,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     THIS SUBROUTINE FORMS THE EIGENVECTORS OF A REAL GENERAL
!     MATRIX BY BACK TRANSFORMING THOSE OF THE CORRESPONDING
!     BALANCED MATRIX DETERMINED BY DBAL.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY DBAL,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE PERMUTATIONS
!          AND SCALING FACTORS USED BY DBAL,
!
!        M IS THE NUMBER OF COLUMNS OF Z TO BE BACK TRANSFORMED,
!
!        Z CONTAINS THE REAL AND IMAGINARY PARTS OF THE EIGEN-
!          VECTORS TO BE BACK TRANSFORMED IN ITS FIRST M COLUMNS.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE REAL AND IMAGINARY PARTS OF THE
!          TRANSFORMED EIGENVECTORS IN ITS FIRST M COLUMNS.
!
!-----------------------------------------------------------------------
!
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                IF THE FOREGOING STATEMENT IS REPLACED BY
!                S=1.0/SCALE(I). **********
   do 100 j = 1, m
100 z(i,j) = z(i,j) * s
!
end do
!     ********- FOR I=LOW-1 STEP -1 UNTIL 1,
!               IGH+1 STEP 1 UNTIL N DO -- **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTRANS,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE ACCUMULATES THE ORTHOGONAL SIMILARITY
!     TRANSFORMATIONS USED IN THE REDUCTION OF A REAL DOUBLE
!     PRECISION MATRIX TO UPPER HESSENBERG FORM BY DORTH.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DBAL.  IF DBAL HAS NOT BEEN USED THEN
!          SET LOW=1, IGH=N,
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
!          FORMATIONS USED IN THE REDUCTION BY DORTH
!          IN ITS STRICT LOWER TRIANGLE,
!
!        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANS-
!          FORMATIONS USED IN THE REDUCTION BY DORTH.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY DORTH,
!
!        ORT HAS BEEN ALTERED.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE Z TO IDENTITY MATRIX **********
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
!     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
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
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN ORTHES.
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTRANS,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE ACCUMULATES THE ORTHOGONAL SIMILARITY
!     TRANSFORMATIONS USED IN THE REDUCTION OF A REAL DOUBLE
!     PRECISION MATRIX TO UPPER HESSENBERG FORM BY DORTH.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DBAL.  IF DBAL HAS NOT BEEN USED THEN
!          SET LOW=1, IGH=N,
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
!          FORMATIONS USED IN THE REDUCTION BY DORTH
!          IN ITS STRICT LOWER TRIANGLE,
!
!        NA MUST BE SET TO THE ROW DIMENSION OF THE 2-DIMENSIONAL
!          ARRAY PARAMETER  A  AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        NZ MUST BE SET TO THE ROW DIMENSION OF THE 2-DIMENSIONAL
!          ARRAY PARAMETER  Z  AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANS-
!          FORMATIONS USED IN THE REDUCTION BY DORTH.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
!
!     ON OUTPUT-
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY DORTH,
!
!        ORT HAS BEEN ALTERED.
!
!-----------------------------------------------------------------------
!
!     ********** INITIALIZE Z TO IDENTITY MATRIX **********
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
!     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
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
!     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN ORTHES.
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
!     INTEGER MIN0
!     DOUBLE PRECISION DSQRT,DABS
double precision :: dpmpar
logical :: notlas
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE HQR2,
!     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
!     OF A REAL DOUBLE PRECISION UPPER HESSENBERG MATRIX BY THE
!     QR METHOD.  THE EIGENVECTORS OF A REAL GENERAL MATRIX CAN
!     ALSO BE FOUND IF DORTH AND DORTRN HAVE BEEN USED TO REDUCE
!     THIS GENERAL MATRIX TO HESSENBERG FORM AND TO ACCUMULATE
!     THE SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DBAL.  IF DBAL HAS NOT BEEN USED THEN
!          SET LOW=1, IGH=N,
!
!        H CONTAINS THE UPPER HESSENBERG MATRIX,
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED BY DORTRN
!          AFTER THE REDUCTION BY DORTH, IF PERFORMED. IF THE
!          EIGENVECTORS OF THE HESSENBERG MATRIX ARE DESIRED,
!          Z MUST CONTAIN THE IDENTITY MATRIX.
!
!     ON OUTPUT-
!
!        H HAS BEEN DESTROYED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
!          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
!          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
!          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        Z CONTAINS THE REAL AND IMAGINARY PARTS OF THE EIGENVECTORS.
!          IF THE I-TH EIGENVALUE IS REAL, THE I-TH COLUMN OF Z
!          CONTAINS ITS EIGENVECTOR.  IF THE I-TH EIGENVALUE IS COMPLEX
!          WITH POSITIVE IMAGINARY PART, THE I-TH AND (I+1)-TH
!          COLUMNS OF Z CONTAIN THE REAL AND IMAGINARY PARTS OF ITS
!          EIGENVECTOR.  THE EIGENVECTORS ARE UNNORMALIZED.  IF AN
!          ERROR EXIT IS MADE, NONE OF THE EIGENVECTORS HAS BEEN FOUND,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0
!                IN THE DOUBLE PRECISION ARITHMETIC BEING USED.
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
norm = 0.d0
k = 1
!     ********** STORE ROOTS ISOLATED BY DBAL
!                AND COMPUTE MATRIX NORM **********
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
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
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
!                SUB-DIAGONAL ELEMENTS.
!                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
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
!     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
!                COLUMNS M TO EN **********
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
!     ********** FOR EN=N STEP -1 UNTIL 1 DO -- **********
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
!     ********** FOR I=EN-1 STEP -1 UNTIL 1 DO -- **********
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
!     ********** FOR I=EN-2 STEP -1 UNTIL 1 DO -- **********
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
!                VECTORS OF ORIGINAL FULL MATRIX.
!                FOR J=N STEP -1 UNTIL LOW DO -- **********
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
!               EIGENVALUES OF SYMMETRIC REAL MATRICES
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
!               EIGENVALUES OF SYMMETRIC REAL MATRICES
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
!        EIGENVALUES AND EIGENVECTORS OF SYMMETRIC REAL MATRICES
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
!        EIGENVALUES AND EIGENVECTORS OF SYMMETRIC REAL MATRICES
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
!     REAL SQRT,ABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TRED1,
!     NUM. MATH. 11, 181-195(1968) BY MARTIN, REINSCH, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 212-226(1971).
!
!     THIS SUBROUTINE REDUCES A REAL SYMMETRIC MATRIX
!     TO A SYMMETRIC TRIDIAGONAL MATRIX USING
!     ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        A CONTAINS THE REAL SYMMETRIC INPUT MATRIX.  ONLY THE
!          LOWER TRIANGLE OF THE MATRIX NEED BE SUPPLIED.
!
!     ON OUTPUT-
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
!          FORMATIONS USED IN THE REDUCTION IN ITS STRICT LOWER
!          TRIANGLE.  THE FULL UPPER TRIANGLE OF A IS UNALTERED,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
!          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO,
!
!        E2 CONTAINS THE SQUARES OF THE CORRESPONDING ELEMENTS OF E.
!          E2 MAY COINCIDE WITH E IF THE SQUARES ARE NOT NEEDED.
!
!-----------------------------------------------------------------------
!
do 100 i = 1, n
100 d(i) = a(i,i)
!     ********** FOR I=N STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   h = 0.0
   scale = 0.0
   if (l .lt. 1) go to 130
!     ********** SCALE ROW (ALGOL TOL THEN NOT NEEDED) **********
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
!     ********** FORM ELEMENT OF A*U **********
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
!     ********** FORM REDUCED A **********
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
!     ********** LAST CARD OF TRED1 **********
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
!     REAL SQRT,ABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TRED3,
!     NUM. MATH. 11, 181-195(1968) BY MARTIN, REINSCH, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 212-226(1971).
!
!     THIS SUBROUTINE REDUCES A REAL SYMMETRIC MATRIX, STORED AS
!     A ONE-DIMENSIONAL ARRAY, TO A SYMMETRIC TRIDIAGONAL MATRIX
!     USING ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        NV MUST BE SET TO THE DIMENSION OF THE ARRAY PARAMETER A
!          AS DECLARED IN THE CALLING PROGRAM DIMENSION STATEMENT,
!
!        A CONTAINS THE LOWER TRIANGLE OF THE REAL SYMMETRIC
!          INPUT MATRIX, STORED ROW-WISE AS A ONE-DIMENSIONAL
!          ARRAY, IN ITS FIRST N*(N+1)/2 POSITIONS.
!
!     ON OUTPUT-
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL
!          TRANSFORMATIONS USED IN THE REDUCTION,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
!          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO,
!
!        E2 CONTAINS THE SQUARES OF THE CORRESPONDING ELEMENTS OF E.
!          E2 MAY COINCIDE WITH E IF THE SQUARES ARE NOT NEEDED.
!
!-----------------------------------------------------------------------
!
!     ********** FOR I=N STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   iz = (i * l) / 2
   h = 0.0
   scale = 0.0
   if (l .lt. 1) go to 130
!     ********** SCALE ROW (ALGOL TOL THEN NOT NEEDED) **********
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
!     ********** FORM ELEMENT OF A*U **********
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
!     ********** FORM REDUCED A **********
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
!     ********** LAST CARD OF TRED3 **********
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
!     REAL SQRT,ABS,SPMPAR
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TQLRAT,
!     ALGORITHM 464, COMM. ACM 16, 689(1973) BY REINSCH.
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES OF A SYMMETRIC
!     TRIDIAGONAL MATRIX BY THE RATIONAL QL METHOD.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E2 CONTAINS THE SQUARES OF THE SUBDIAGONAL ELEMENTS OF THE
!          INPUT MATRIX IN ITS LAST N-1 POSITIONS.  E2(1) IS ARBITRARY.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT AND
!          ORDERED FOR INDICES 1,2,...IERR-1, BUT MAY NOT BE
!          THE SMALLEST EIGENVALUES,
!
!        E2 HAS BEEN DESTROYED,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
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
!     ********** E2(N) IS ALWAYS ZERO, SO THERE IS NO EXIT
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
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
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
!     ********** FOR I=L STEP -1 UNTIL 2 DO -- **********
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
!     ********** LAST CARD OF TQLRAT **********
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
!     REAL SQRT,ABS,SPMPAR
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE IMTQL1,
!     NUM. MATH. 12, 377-383(1968) BY MARTIN AND WILKINSON,
!     AS MODIFIED IN NUM. MATH. 15, 450(1970) BY DUBRULLE.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 241-248(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES OF A SYMMETRIC
!     TRIDIAGONAL MATRIX BY THE IMPLICIT QL METHOD.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE INPUT MATRIX
!          IN ITS LAST N-1 POSITIONS.  E(1) IS ARBITRARY.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT AND
!          ORDERED FOR INDICES 1,2,...IERR-1, BUT MAY NOT BE
!          THE SMALLEST EIGENVALUES,
!
!        E HAS BEEN DESTROYED,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
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
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
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
!     ********** FOR I=L STEP -1 UNTIL 2 DO -- **********
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
!     ********** LAST CARD OF IMTQL1 **********
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
!     REAL SQRT,ABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TRED2,
!     NUM. MATH. 11, 181-195(1968) BY MARTIN, REINSCH, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 212-226(1971).
!
!     THIS SUBROUTINE REDUCES A REAL SYMMETRIC MATRIX TO A
!     SYMMETRIC TRIDIAGONAL MATRIX USING AND ACCUMULATING
!     ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        A CONTAINS THE REAL SYMMETRIC INPUT MATRIX.  ONLY THE
!          LOWER TRIANGLE OF THE MATRIX NEED BE SUPPLIED.
!
!     ON OUTPUT-
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
!          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO,
!
!        Z CONTAINS THE ORTHOGONAL TRANSFORMATION MATRIX
!          PRODUCED IN THE REDUCTION,
!
!        A AND Z MAY COINCIDE.  IF DISTINCT, A IS UNALTERED.
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
!     ********** FOR I=N STEP -1 UNTIL 2 DO -- **********
do ii = 2, n
   i = n + 2 - ii
   l = i - 1
   h = 0.0
   scale = 0.0
   if (l .lt. 2) go to 130
!     ********** SCALE ROW (ALGOL TOL THEN NOT NEEDED) **********
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
!     ********** FORM ELEMENT OF A*U **********
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
!     ********** FORM REDUCED A **********
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
!     ********** LAST CARD OF TRED2 **********
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
!     REAL SQRT,ABS,SPMPAR
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TQL2,
!     NUM. MATH. 11, 293-306(1968) BY BOWDLER, MARTIN, REINSCH, AND
!     WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 227-240(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
!     OF A SYMMETRIC TRIDIAGONAL MATRIX BY THE QL METHOD.
!     THE EIGENVECTORS OF A FULL SYMMETRIC MATRIX CAN ALSO
!     BE FOUND IF  TRED2  HAS BEEN USED TO REDUCE THIS
!     FULL MATRIX TO TRIDIAGONAL FORM.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE INPUT MATRIX
!          IN ITS LAST N-1 POSITIONS.  E(1) IS ARBITRARY,
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  TRED2, IF PERFORMED.  IF THE EIGENVECTORS
!          OF THE TRIDIAGONAL MATRIX ARE DESIRED, Z MUST CONTAIN
!          THE IDENTITY MATRIX.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT BUT
!          UNORDERED FOR INDICES 1,2,...,IERR-1,
!
!        E HAS BEEN DESTROYED,
!
!        Z CONTAINS ORTHONORMAL EIGENVECTORS OF THE SYMMETRIC
!          TRIDIAGONAL (OR FULL) MATRIX.  IF AN ERROR EXIT IS MADE,
!          Z CONTAINS THE EIGENVECTORS ASSOCIATED WITH THE STORED
!          EIGENVALUES,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
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
!     ********** E(N) IS ALWAYS ZERO, SO THERE IS NO EXIT
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
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
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
!     ********** LAST CARD OF TQL2 **********
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
!     REAL SQRT,ABS,SPMPAR
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE IMTQL2,
!     NUM. MATH. 12, 377-383(1968) BY MARTIN AND WILKINSON,
!     AS MODIFIED IN NUM. MATH. 15, 450(1970) BY DUBRULLE.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 241-248(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
!     OF A SYMMETRIC TRIDIAGONAL MATRIX BY THE IMPLICIT QL METHOD.
!     THE EIGENVECTORS OF A FULL SYMMETRIC MATRIX CAN ALSO
!     BE FOUND IF  TRED2  HAS BEEN USED TO REDUCE THIS
!     FULL MATRIX TO TRIDIAGONAL FORM.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE INPUT MATRIX
!          IN ITS LAST N-1 POSITIONS.  E(1) IS ARBITRARY,
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  TRED2, IF PERFORMED.  IF THE EIGENVECTORS
!          OF THE TRIDIAGONAL MATRIX ARE DESIRED, Z MUST CONTAIN
!          THE IDENTITY MATRIX.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT BUT
!          UNORDERED FOR INDICES 1,2,...,IERR-1,
!
!        E HAS BEEN DESTROYED,
!
!        Z CONTAINS ORTHONORMAL EIGENVECTORS OF THE SYMMETRIC
!          TRIDIAGONAL (OR FULL) MATRIX.  IF AN ERROR EXIT IS MADE,
!          Z CONTAINS THE EIGENVECTORS ASSOCIATED WITH THE STORED
!          EIGENVALUES,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
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
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
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
!     ********** LAST CARD OF IMTQL2 **********
end subroutine imtql2

