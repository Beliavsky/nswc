subroutine solve2(m, n, m1, a, b, w, n1, ipivot, qr, d, &
&eta, fail, numit, digitx, &
&x, res, wres, y1, y2, y, f, g, mm, mmpnn)
implicit none
integer, intent(in) :: m, m1, mm, mmpnn, n, n1
integer, intent(out) :: numit
integer :: i, j, k, kz, l, mp1, mpn, n1p1, np, ns
integer, intent(in) :: ipivot(n)
real, intent(in) :: a(mm,n), b(*)
real :: c
real, intent(in) :: d(*)
real, intent(inout) :: f(*), g(*)
real, intent(in) :: qr(mmpnn,n)
real, intent(inout) :: res(*)
real, intent(in) :: w(m)
real, intent(inout) :: wres(*), x(*), y(*), y1(*), y2(*)
real, intent(inout) :: digitx
real :: dxnorm
real, intent(in) :: eta
real :: eta2, rdr1, rdr2, rdx1, rdx2, rnr, rnx, xnorm
double precision :: sum
logical, intent(inout) :: fail
numit = 0
kz = 0
eta2 = eta*eta
mp1 = m + 1
mpn = m + n
n1p1 = n1 + 1
do 10 i = 1,m
  f(i) = b(i)*w(i)
  g(i) = 0.0
  wres(i) = 0.0
  res(i) = 0.0
  y1(i) = 0.0
  if (w(i).eq.0.0) kz = kz + 1
10 continue
do ns=1,n
  j = m + ns
  f(j) = 0.0
  g(j) = 0.0
  x(ns) = 0.0
  y2(ns) = 0.0
end do
k = 0
rdx2 = 0.0
rdr2 = 0.0
! BEGIN K-TH ITERATION STEP.
30 if (k.lt.2) go to 40
if (((64.*rdx2.lt.rdx1) .and. (rdx2.gt.eta2*rnx)) .or. &
&((64.*rdr2.lt.rdr1) .and. (rdr2.gt.eta2*rnr))) go to 40
go to 270
40 rdx1 = rdx2
rdr1 = rdr2
rdx2 = 0.0
rdr2 = 0.0
if (k.eq.0) go to 160
! NEW RESIDUALS.
do 50 i = 1,m
  wres(i) = wres(i) + f(i)*w(i)
  if (w(i).eq.0.0) go to 50
  res(i) = res(i) + f(i)/w(i)
  y1(i) = y1(i) + g(i)
50 continue
do 100 ns = 1,n
  j = m + ns
  np = ipivot(ns)
  x(np) = x(np) + f(j)
  y2(np) = y2(np) + g(j)
  sum = -dble(x(np))
  do l=1,m
    sum = sum + dble(a(l,np))*dble(y1(l))
  end do
  g(j) = -sum
  if (ns.gt.n1) go to 70
  go to 80
70 f(j) = 0.0
  go to 100
80 sum = 0.0
  do l=1,m
    sum = sum + dble(a(l,np))*dble(wres(l))
  end do
  f(j) = -sum
100 continue
do i=1,m
  sum = 0.0
  if (i.gt.m1) sum = dble(res(i))
  do l=1,n
    sum = sum + dble(a(i,l))*dble(x(l))
  end do
  sum = sum - dble(b(i))
  f(i) = -sum
  f(i) = f(i)*w(i)
  if (w(i).eq.0.0) res(i) = dble(res(i)) - sum
  sum = 0.0
  if (i.gt.m1) sum = dble(y1(i))
  do l=1,n
    sum = sum + dble(a(i,l))*dble(y2(l))
  end do
  g(i) = -sum
end do
if (n1p1.gt.n) go to 160
do i=n1p1,n
  ns = n + n1p1 - i
  j = m + ns
  sum = 0.0
  do l=1,j
    sum = sum + dble(qr(l,ns))*dble(g(l))
  end do
  g(j) = sum
end do
! END NEW RESIDUALS.
!
160 call solve3(f, m1, m, n1, qr, d, y, mmpnn)
!
if (n1p1.gt.n) go to 200
do ns=n1p1,n
  j = m + ns
  sum = dble(g(j))
  do l=mp1,j
    sum = sum + dble(qr(l,ns))*dble(f(l))
  end do
  c = sum
  c = c/d(ns)
  do i=1,j
    f(i) = f(i) - c*qr(i,ns)
  end do
end do
200 do j=mp1,mpn
  g(j) = 0.0
  if (j.le.m+n1) g(j) = g(j) + f(j)
end do
!
call solve3(g, m1, m, n1, qr, d, y, mmpnn)
!
do i=1,m
  rdr2 = rdr2 + f(i)*f(i)
end do
do i=mp1,mpn
  rdx2 = rdx2 + f(i)*f(i)
end do
if (k.ne.0) go to 240
rnr = rdr2
rnx = rdx2
240 if (k.ne.1) go to 260
xnorm = sqrt(rnx)
dxnorm = sqrt(rdx2)
if (xnorm.ne.0.0) go to 250
digitx = -alog10(eta)
go to 260
250 digitx = -alog10(amax1(dxnorm/xnorm,eta))
! END K-TH ITERATION STEP.
260 numit = k
k = k + 1
go to 30
270 if ((m1+kz.eq.m) .and. (rdx2.gt.4.*eta2*rnx)) go to 280
if ((rdr2.gt.4.*eta2*rnr) .and. &
&(rdx2.gt.4.*eta2*rnx)) go to 280
fail = .false.
return
280 fail = .true.
return
end subroutine solve2

subroutine solve3(f, m1, m, n1, qr, d, y, mmpnn)
implicit none
integer, intent(in) :: m, m1, mmpnn, n1
integer :: j, l, lmm, mh, mpl, mpn1, mv, ns, nsm1
! SUBROUTINE SOLVE3 IS CALLED ONLY BY SUBROUTINE SOLVE2.
! THIS SUBROUTINE CALCULATES NEW VALUES OF F.
real :: c
real, intent(in) :: d(*)
real, intent(inout) :: f(*)
real, intent(in) :: qr(mmpnn,n1)
real, intent(inout) :: y(*)
double precision :: sum
mv = 1
mh = m1
do ns=1,n1
  j = m + ns
  if (ns.eq.m1+1) go to 10
  go to 20
10 mv = m1 + 1
  mh = m
20 nsm1 = ns - 1
  sum = -dble(f(j))
  if (ns.eq.1) go to 40
  do l=1,nsm1
    mpl = m + l
    sum = sum + dble(qr(mpl,ns))*dble(y(l))
  end do
40 y(ns) = -sum
  if (ns.gt.m1) go to 50
  go to 60
50 c = -y(ns)
  go to 70
60 c = 0.0
70 sum = dble(c)
  do l=mv,mh
    sum = sum + dble(qr(l,ns))*dble(f(l))
  end do
  c = sum
  c = c/d(ns)
  f(j) = c
  do l=mv,m
    f(l) = f(l) - c*qr(l,ns)
  end do
end do
if (1.gt.m1) go to 150
do l=1,m1
  f(l) = 0.0
end do
do ns=1,m1
  sum = -dble(y(ns))
  do l=1,m
    sum = sum + dble(qr(l,ns))*dble(f(l))
  end do
  c = sum
  c = c/d(ns)
  do l=1,m1
    f(l) = f(l) - c*qr(l,ns)
  end do
end do
150 do ns=1,n1
  j = m + n1 + 1 - ns
  mpn1 = m + n1
  sum = 0.0
  do l=j,mpn1
    lmm = l - m
    sum = sum + dble(qr(j,lmm))*dble(f(l))
  end do
  f(j) = -sum
end do
return
end subroutine solve3

subroutine covar(n, m1, n1, ipivot, c, d, z, nn)
implicit none
integer, intent(in) :: m1, n, n1, nn
integer :: i, j, k, ka, l, n1p1
! SUBROUTINE COVAR USES RESULTS FROM THE ORTHOGONAL DECOMPOSITION
! STORED IN C, D AND IPIVOT TO COMPUTE THE UNSCALED COVARIANCE MATRIX
! OF THE LEAST SQUARES COEFFICIENTS.
! ON ENTRY, THE FIRST N ROWS AND THE FIRST N COLUMNS OF C CONTAIN THE
! UPPER TRIANGULAR MATRIX OBTAINED FROM THE DECOMPOSITION.  THIS INPUT
! MATRIX IS DESTROYED IN SUBSEQUENT CALCULATIONS.
! ON EXIT, THE LOWER TRIANGULAR PORTION OF THE SYMMETRIC UNSCALED
! COVARIANCE MATRIX IS CONTAINED IN
!     C(1,1)
!     C(2,1) C(2,2)
!     . . .
!     C(N,1) C(N,2) ... C(N,N)
! IF N1 IS LESS THAN N, ONE OR MORE COLUMNS OF THE MATRIX
! H = (SQRT(W))*A WERE REJECTED AS BEING LINEARLY DEPENDENT.  WHENEVER
! THE K-TH COLUMN OF H WAS SO REJECTED, C(I,J) IS SET EQUAL TO ZERO,
! FOR I = K OR J = K, I.GE.J.
integer, intent(in) :: ipivot(n)
real, intent(inout) :: c(nn,n)
real, intent(in) :: d(*)
real, intent(inout) :: z(*)
double precision :: sum
l = n1
if (l.gt.m1) c(l,l) = 1.0/d(l)
if (l.eq.1) go to 60
10 j = l - 1
if (j.gt.m1) c(j,j) = 1.0/d(j)
do k=l,n1
  z(k) = c(j,k)
end do
i = n1
do ka=j,n1
  sum = 0.0
  if (i.eq.j) sum = dble(c(i,j))
  do k=l,n1
    sum = sum - dble(z(k))*dble(c(k,i))
  end do
  c(i,j) = sum
  i = i - 1
end do
do k=l,n1
  c(j,k) = c(k,j)
end do
l = l - 1
if (l.gt.1) go to 10
60 if (n1.eq.n) go to 90
n1p1 = n1 + 1
do i=1,n
  do j=n1p1,n
    c(i,j) = 0.0
  end do
end do
! PERMUTE THE COLUMNS AND ROWS OF MATRIX C TO ACCOUNT FOR PIVOTING.
90 do i=1,n
  do j=1,n
    k = ipivot(j)
    z(k) = c(i,j)
  end do
  do j=1,n
    c(i,j) = z(j)
  end do
end do
do i=1,n
  do j=1,n
    k = ipivot(j)
    z(k) = c(j,i)
  end do
  do j=i,n
    c(j,i) = z(j)
  end do
end do
return
end subroutine covar

subroutine splsq(m,n,a,ia,ja,damp,u,x,atol,btol,conlim,itnlim, &
&istop,itn,acond,rnorm,xnorm,w)
implicit none
integer :: npi
!
integer, intent(in) :: m
integer :: n
integer, intent(in) :: itnlim
integer, intent(inout) :: istop
integer, intent(in) :: ia(*), ja(*)
real, intent(in) :: a(*), damp
real, intent(inout) :: u(m), x(n)
real, intent(in) :: atol, btol, conlim
real, intent(inout) :: acond, rnorm, xnorm, w(*)
!     ------------------------------------------------------------------
!
!     SPLSQ FINDS A SOLUTION X TO THE FOLLOWING PROBLEMS ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*X = B
!
!     2. LINEAR LEAST SQUARES  --    SOLVE  A*X = B
!                                    IN THE LEAST-SQUARES SENSE
!
!     3. DAMPED LEAST SQUARES  --    SOLVE  (   A    )*X = ( B )
!                                           ( DAMP*I )     ( 0 )
!                                    IN THE LEAST-SQUARES SENSE
!
!     WHERE A IS A MATRIX WITH M ROWS AND N COLUMNS, B AN M-VECTOR,
!     AND DAMP A SCALAR. (ALL QUANTITIES ARE REAL.) THE MATRIX A IS
!     A SPARSE MATRIX STORED ROWWISE IN THE ARRAYS A,IA,JA.
!
!     THE RHS VECTOR B IS INPUT VIA U, AND IS SUBSEQUENTLY OVERWRITTEN.
!
!
!     NOTE. SPLSQ USES AN ITERATIVE METHOD TO APPROXIMATE THE SOLUTION.
!     THE NUMBER OF ITERATIONS REQUIRED TO REACH A CERTAIN ACCURACY
!     DEPENDS STRONGLY ON THE SCALING OF THE PROBLEM. POOR SCALING OF
!     THE ROWS OR COLUMNS OF A SHOULD THEREFORE BE AVOIDED WHENEVER
!     POSSIBLE.
!
!     FOR EXAMPLE, IN PROBLEM 1 THE SOLUTION IS UNALTERED BY
!     ROW-SCALING.  IF A ROW OF A IS VERY SMALL OR LARGE COMPARED TO
!     THE OTHER ROWS OF A, THE CORRESPONDING ROW OF (A  B) SHOULD BE
!     SCALED UP OR DOWN.
!
!     IN PROBLEMS 1 AND 2, THE SOLUTION X IS EASILY RECOVERED
!     FOLLOWING COLUMN SCALING. IN THE ABSENCE OF BETTER INFORMATION,
!     THE NONZERO COLUMNS OF A SHOULD BE SCALED SO THAT THEY ALL HAVE
!     THE SAME EUCLIDEAN NORM (E.G.  1.0).
!
!     IN PROBLEM 3, THERE IS NO FREEDOM TO RE-SCALE IF DAMP IS
!     NONZERO. HOWEVER, THE VALUE OF DAMP SHOULD BE ASSIGNED ONLY
!     AFTER ATTENTION HAS BEEN PAID TO THE SCALING OF A.
!
!     THE PARAMETER DAMP IS INTENDED TO HELP REGULARIZE
!     ILL-CONDITIONED SYSTEMS, BY PREVENTING THE TRUE SOLUTION FROM
!     BEING VERY LARGE. ANOTHER AID TO REGULARIZATION IS PROVIDED BY
!     THE PARAMETER ACOND, WHICH MAY BE USED TO TERMINATE ITERATIONS
!     BEFORE THE COMPUTED SOLUTION BECOMES VERY LARGE.
!
!
!     NOTATION
!     --------
!
!     THE FOLLOWING QUANTITIES ARE USED IN DISCUSSING THE SUBROUTINE
!     PARAMETERS...
!
!     ABAR   =  (   A    ),          BBAR  =  ( B )
!               ( DAMP*I )                    ( 0 )
!
!     R      =  B  -  A*X,           RBAR  =  BBAR  -  ABAR*X
!
!     RNORM  =  SQRT( NORM(R)**2  +  DAMP**2 * NORM(X)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  THE SMALLEST FLOATING POINT NUMBER FOR WHICH
!               1 + RELPR .GT. 1.
!
!     SPLSQ  MINIMIZES THE FUNCTION RNORM WITH RESPECT TO X.
!
!
!     PARAMETERS
!     ----------
!
!     M       INPUT      THE NUMBER OF ROWS IN A.
!
!     N       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     A,IA,JA INPUT      THE MATRIX A STORED ROWWISE IN SPARSE FORM.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (DAMP  SHOULD BE 0.0 FOR PROBLEMS 1 AND 2.)
!                        IF THE SYSTEM  A*X = B  IS INCOMPATIBLE, VALUES
!                        OF DAMP IN THE RANGE 0 TO SQRT(RELPR)*NORM(A)
!                        WILL PROBABLY HAVE A NEGLIGIBLE EFFECT.
!                        LARGER VALUES OF DAMP WILL TEND TO DECREASE
!                        THE NORM OF X AND TO REDUCE THE NUMBER OF
!                        ITERATIONS REQUIRED BY SPLSQ.
!
!                        THE WORK PER ITERATION AND THE STORAGE NEEDED
!                        BY SPLSQ ARE THE SAME FOR ALL VALUES OF DAMP.
!
!     U(M)    INPUT      THE RHS VECTOR B. BE AWARE THAT U IS
!                        OVER-WRITTEN BY SPLSQ.
!
!     X(N)    OUTPUT     RETURNS THE COMPUTED SOLUTION X.
!
!     ATOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        DEFINING THE MATRIX A. FOR EXAMPLE,
!                        IF A IS ACCURATE TO ABOUT 6 DIGITS, SET
!                        ATOL = 1.0E-6 .
!
!     BTOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        DEFINING THE RHS VECTOR B. FOR EXAMPLE,
!                        IF B IS ACCURATE TO ABOUT 6 DIGITS, SET
!                        BTOL = 1.0E-6 .
!
!     CONLIM  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        CONDITION NUMBER OF THE MATRIX ABAR.
!                        ITERATIONS WILL BE TERMINATED IF A COMPUTED
!                        ESTIMATE OF COND(ABAR) EXCEEDS CONLIM.
!                        THIS IS INTENDED TO PREVENT CERTAIN SMALL OR
!                        ZERO SINGULAR VALUES OF A OR ABAR FROM
!                        COMING INTO EFFECT AND CAUSING UNWANTED GROWTH
!                        IN THE COMPUTED SOLUTION.
!
!                        CONLIM AND DAMP MAY BE USED SEPARATELY OR
!                        TOGETHER TO REGULARIZE ILL-CONDITIONED SYSTEMS.
!
!                        NORMALLY, CONLIM SHOULD BE IN THE RANGE
!                        1000  TO  1/RELPR.
!                        SUGGESTED VALUE --
!                        CONLIM = 1/(100*RELPR)  FOR COMPATIBLE SYSTEMS,
!                        CONLIM = 1/(10*SQRT(RELPR))  FOR LEAST SQUARES.
!
!             NOTE. IF THE USER IS NOT CONCERNED ABOUT THE PARAMETERS
!             ATOL, BTOL, AND CONLIM, ANY OR ALL OF THEM MAY BE SET
!             TO ZERO. THE EFFECT WILL BE THE SAME AS THE VALUES
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     ITNLIM  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        SUGGESTED VALUE --
!                        ITNLIM = N/2     FOR WELL CONDITIONED SYSTEMS,
!                        ITNLIM = 4*N     OTHERWISE.
!
!     ISTOP   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       X = 0  IS THE EXACT SOLUTION.
!                        NO ITERATIONS WERE PERFORMED.
!
!                1       THE EQUATIONS  A*X = B  ARE PROBABLY
!                        COMPATIBLE. NORM(A*X - B) IS SUFFICIENTLY
!                        SMALL, GIVEN THE VALUES OF ATOL AND BTOL.
!
!                2       THE SYSTEM  A*X = B  IS PROBABLY NOT
!                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
!                        BEEN OBTAINED WHICH IS SUFFICIENTLY ACCURATE,
!                        GIVEN THE VALUE OF ATOL.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        CONLIM. THE SYSTEM  A*X = B  APPEARS TO BE
!                        ILL-CONDITIONED.
!
!                4       THE EQUATIONS  A*X = B  ARE PROBABLY
!                        COMPATIBLE. NORM(A*X - B) IS AS SMALL AS
!                        SEEMS REASONABLE ON THIS MACHINE.
!
!                5       THE SYSTEM  A*X = B  IS PROBABLY NOT
!                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
!                        BEEN OBTAINED WHICH IS AS ACCURATE AS SEEMS
!                        REASONABLE ON THIS MACHINE.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        NOT MUCH POINT IN DOING FURTHER ITERATIONS,
!                        GIVEN THE PRECISION OF THIS MACHINE.
!
!                7       THE ITERATION LIMIT ITNLIM WAS REACHED.
!
!
!     ITN     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     ACOND   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        NUMBER OF ABAR.
!
!     RNORM   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        THE FUNCTION BEING MINIMIZED (SEE NOTATION
!                        ABOVE). THIS WILL BE SMALL IF  A*X = B  HAS
!                        A SOLUTION.
!
!     XNORM   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        SOLUTION VECTOR X.
!
!     W(2*N)             WORKSPACE
!
!     ANORM   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        THIS IS THE SQUARE ROOT OF THE SUM OF SQUARES
!                        OF THE ELEMENTS OF ABAR.
!                        IF DAMP IS SMALL AND IF THE COLUMNS OF A
!                        HAVE ALL BEEN SCALED TO HAVE LENGTH  1.0,
!                        ANORM SHOULD INCREASE TO ROUGHLY SQRT(N).
!
!     ARNORM  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        NORM( ABAR(TRANSPOSE)*RBAR ), THE NORM OF
!                        THE RESIDUAL FOR THE USUAL NORMAL EQUATIONS.
!                        THIS SHOULD BE SMALL IN ALL CASES. (ARNORM
!                        WILL OFTEN BE SMALLER THAN THE TRUE VALUE
!                        COMPUTED FROM THE OUTPUT VECTOR X.)
!
!
!     SUBROUTINES AND FUNCTIONS USED
!     ------------------------------
!
!                NORMLZ,MVPRD1,MTPRD1
!     BLAS       SCOPY,SNRM2,SSCAL  (SEE LAWSON ET AL. BELOW)
!                (SNRM2 IS USED ONLY IN NORMLZ)
!     FORTRAN    ABS,SQRT
!
!
!     REFERENCES
!     ----------
!
!     PAIGE, C.C. AND SAUNDERS, M.A.  LSQR, AN ALGORITHM FOR SPARSE
!        LINEAR EQUATIONS AND SPARSE LEAST SQUARES.
!        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 8, 1 (MARCH 1982).
!
!     LAWSON, C.L., HANSON, R.J., KINCAID, D.R. AND KROGH, F.T.
!        BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE.
!        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 5, 3 (SEPT 1979),
!        308-323 AND 324-325.
!
!     ------------------------------------------------------------------
!
!     LOCAL VARIABLES
!
integer :: i
integer, intent(inout) :: itn
integer :: nconv, nstop
real :: alfa, anorm, arnorm, bbnorm, beta, bnorm, cs, cs1, cs2, &
&ctol, dampsq, ddnorm, delta, gamma, gambar, one, phi, phibar, psi, &
&res1, res2, rho, rhobar, rhbar1, rhbar2, rhs, rtol, sn, sn1, sn2, &
&t, tau, test1, test2, test3, theta, t1, t2, t3, xxnorm, z, zbar, &
&zero
!
!
!     INITIALIZE.
!
zero   = 0.0
one    = 1.0
ctol   = zero
if (conlim .gt. zero) ctol = one/conlim
dampsq = damp**2
anorm  = zero
acond  = zero
bbnorm = zero
ddnorm = zero
res2   = zero
xnorm  = zero
xxnorm = zero
cs2    = -one
sn2    = zero
z      = zero
itn    = 0
istop  = 0
nstop  = 0
!
do i = 1, n
   w(i) = zero
   x(i) = zero
end do
!
!     SET UP THE FIRST VECTORS FOR THE BIDIAGONALIZATION.
!     THESE SATISFY   BETA*U = B,   ALFA*W = A(TRANSPOSE)*U.
!
call normlz(m,u,beta)
call mtprd1(m,n,a,ia,ja,u,w)
call normlz(n,w,alfa)
call scopy (n,w,1,w(n+1),1)
!
rhobar = alfa
phibar = beta
bnorm  = beta
rnorm  = beta
arnorm = alfa*beta
if (arnorm .le. zero) go to 800
!
!     ------------------------------------------------------------------
!     MAIN ITERATION LOOP.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     PERFORM THE NEXT STEP OF THE BIDIAGONALIZATION TO OBTAIN THE
!     NEXT  BETA, U, ALFA, W.  THESE SATISFY THE RELATIONS
!                BETA*U  =  A*W  -  ALFA*U,
!                ALFA*W  =  A(TRANSPOSE)*U  -  BETA*W.
!
call sscal (m,(-alfa),u,1)
call mvprd1(m,n,a,ia,ja,w,u)
call normlz(m,u,beta)
bbnorm = bbnorm + alfa**2 + beta**2 + dampsq
call sscal (n,(-beta),w,1)
call mtprd1(m,n,a,ia,ja,u,w)
call normlz(n,w,alfa)
!
!
!     USE A PLANE ROTATION TO ELIMINATE THE DAMPING PARAMETER.
!     THIS ALTERS THE DIAGONAL (RHOBAR) OF THE LOWER-BIDIAGONAL MATRIX.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1    = rhobar/rhbar1
sn1    = damp/rhbar1
psi    = sn1*phibar
phibar = cs1*phibar
!
!
!     USE A PLANE ROTATION TO ELIMINATE THE SUBDIAGONAL ELEMENT (BETA)
!     OF THE LOWER-BIDIAGONAL MATRIX, GIVING AN UPPER-BIDIAGONAL MATRIX.
!
rho    = sqrt(rhbar2 + beta**2)
cs     = rhbar1/rho
sn     = beta/rho
theta  =  sn*alfa
rhobar = -cs*alfa
phi    =  cs*phibar
phibar =  sn*phibar
tau    =  sn*phi
!
!
!     UPDATE X AND W(N+1),...,W(2*N)
!
t1 =    phi/rho
t2 = -theta/rho
t3 =    one/rho
!
do i = 1, n
   npi   = n + i
   t     = w(npi)
   x(i)  = t1*t + x(i)
   w(npi)= t2*t + w(i)
   t     =(t3*t)**2
   ddnorm= t + ddnorm
end do
!
!
!     USE A PLANE ROTATION ON THE RIGHT TO ELIMINATE THE
!     SUPER-DIAGONAL ELEMENT (THETA) OF THE UPPER-BIDIAGONAL MATRIX.
!     THEN USE THE RESULT TO ESTIMATE NORM(X).
!
delta  =  sn2*rho
gambar = -cs2*rho
rhs    = phi - delta*z
zbar   = rhs/gambar
xnorm  = sqrt(xxnorm + zbar**2)
gamma  = sqrt(gambar**2 + theta**2)
cs2    = gambar/gamma
sn2    = theta/gamma
z      = rhs/gamma
xxnorm = xxnorm + z**2
!
!
!     TEST FOR CONVERGENCE.
!     FIRST, ESTIMATE THE NORM AND CONDITION OF THE MATRIX ABAR,
!     AND THE NORMS OF RBAR AND ABAR(TRANSPOSE)*RBAR.
!
anorm  = sqrt(bbnorm)
acond  = anorm*sqrt(ddnorm)
res1   = phibar**2
res2   = res2 + psi**2
rnorm  = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     NOW USE THESE NORMS TO ESTIMATE CERTAIN OTHER QUANTITIES,
!     SOME OF WHICH WILL BE SMALL NEAR A SOLUTION.
!
test1  = rnorm/bnorm
test2  = arnorm/(anorm*rnorm)
test3  = one/acond
t1     = test1/(one + anorm*xnorm/bnorm)
rtol   = btol +  atol*anorm*xnorm/bnorm
!
!     THE FOLLOWING TESTS GUARD AGAINST EXTREMELY SMALL VALUES OF
!     ATOL, BTOL, OR CTOL.  (THE USER MAY HAVE SET ANY OR ALL OF
!     THE PARAMETERS ATOL, BTOL, CONLIM TO ZERO.)
!     THE EFFECT IS EQUIVALENT TO THE NORMAL TESTS USING
!     ATOL = RELPR,  BTOL = RELPR,  CONLIM = 1/RELPR.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn .ge. itnlim) istop = 7
if (t3  .le. one   ) istop = 6
if (t2  .le. one   ) istop = 5
if (t1  .le. one   ) istop = 4
!
!     ALLOW FOR TOLERANCES SET BY THE USER.
!
if (test3 .le. ctol) istop = 3
if (test2 .le. atol) istop = 2
if (test1 .le. rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     THE CONVERGENCE CRITERIA ARE REQUIRED TO BE MET ON  NCONV
!     CONSECUTIVE ITERATIONS, WHERE  NCONV  IS SET BELOW.
!     SUGGESTED VALUE --   NCONV = 1, 2  OR  3.
!
if (istop .eq. 0) nstop = 0
if (istop .eq. 0) go to 100
nconv = 1
nstop = nstop + 1
if (nstop .lt. nconv  .and.  itn .lt. itnlim) istop = 0
if (istop .eq. 0) go to 100
!     ------------------------------------------------------------------
!     END OF ITERATION LOOP.
!     ------------------------------------------------------------------
!
800 return
end subroutine splsq

subroutine normlz(n,x,beta)
implicit none
integer, intent(in) :: n
real, intent(inout) :: x(n)
real, intent(out) :: beta
!
!     NORMLZ COMPUTES THE EUCLIDEAN NORM OF X AND RETURNS THE
!     VALUE IN BETA. IF X IS NONZERO, THEN X IS RESCALED SO
!     THAT NORM(X) = 1.
!
!     FUNCTIONS AND SUBROUTINES
!
!     BLAS       SNRM2,SSCAL
!
real :: one, snrm2, zero
!
data zero/0.0/, one/1.0/
!
!
beta = snrm2(n,x,1)
if (beta .gt. zero) call sscal(n,(one/beta),x,1)
return
end subroutine normlz

subroutine stlsq(m,n,ta,ita,jta,damp,u,x,atol,btol,conlim, &
&itnlim,istop,itn,acond,rnorm,xnorm,w)
implicit none
integer :: npi
!
integer, intent(in) :: m
integer :: n
integer, intent(in) :: itnlim
integer, intent(inout) :: istop
integer, intent(in) :: ita(*), jta(*)
real, intent(in) :: ta(*), damp
real, intent(inout) :: u(m), x(n)
real, intent(in) :: atol, btol, conlim
real, intent(inout) :: acond, rnorm, xnorm, w(*)
!     ------------------------------------------------------------------
!
!     STLSQ FINDS A SOLUTION X TO THE FOLLOWING PROBLEMS ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*X = B
!
!     2. LINEAR LEAST SQUARES  --    SOLVE  A*X = B
!                                    IN THE LEAST-SQUARES SENSE
!
!     3. DAMPED LEAST SQUARES  --    SOLVE  (   A    )*X = ( B )
!                                           ( DAMP*I )     ( 0 )
!                                    IN THE LEAST-SQUARES SENSE
!
!     WHERE A IS A MATRIX WITH M ROWS AND N COLUMNS, B AN M-VECTOR,
!     AND DAMP A SCALAR. (ALL QUANTITIES ARE REAL.) THE MATRIX A IS
!     A SPARSE MATRIX WHOSE TRANSPOSE IS STORED ROWWISE IN THE ARRAYS
!     TA,ITA,JTA.
!
!     THE RHS VECTOR B IS INPUT VIA U, AND IS SUBSEQUENTLY OVERWRITTEN.
!
!
!     NOTE. STLSQ USES AN ITERATIVE METHOD TO APPROXIMATE THE SOLUTION.
!     THE NUMBER OF ITERATIONS REQUIRED TO REACH A CERTAIN ACCURACY
!     DEPENDS STRONGLY ON THE SCALING OF THE PROBLEM. POOR SCALING OF
!     THE ROWS OR COLUMNS OF A SHOULD THEREFORE BE AVOIDED WHENEVER
!     POSSIBLE.
!
!     FOR EXAMPLE, IN PROBLEM 1 THE SOLUTION IS UNALTERED BY
!     ROW-SCALING.  IF A ROW OF A IS VERY SMALL OR LARGE COMPARED TO
!     THE OTHER ROWS OF A, THE CORRESPONDING ROW OF (A  B) SHOULD BE
!     SCALED UP OR DOWN.
!
!     IN PROBLEMS 1 AND 2, THE SOLUTION X IS EASILY RECOVERED
!     FOLLOWING COLUMN SCALING. IN THE ABSENCE OF BETTER INFORMATION,
!     THE NONZERO COLUMNS OF A SHOULD BE SCALED SO THAT THEY ALL HAVE
!     THE SAME EUCLIDEAN NORM (E.G.  1.0).
!
!     IN PROBLEM 3, THERE IS NO FREEDOM TO RE-SCALE IF DAMP IS
!     NONZERO. HOWEVER, THE VALUE OF DAMP SHOULD BE ASSIGNED ONLY
!     AFTER ATTENTION HAS BEEN PAID TO THE SCALING OF A.
!
!     THE PARAMETER DAMP IS INTENDED TO HELP REGULARIZE
!     ILL-CONDITIONED SYSTEMS, BY PREVENTING THE TRUE SOLUTION FROM
!     BEING VERY LARGE. ANOTHER AID TO REGULARIZATION IS PROVIDED BY
!     THE PARAMETER ACOND, WHICH MAY BE USED TO TERMINATE ITERATIONS
!     BEFORE THE COMPUTED SOLUTION BECOMES VERY LARGE.
!
!
!     NOTATION
!     --------
!
!     THE FOLLOWING QUANTITIES ARE USED IN DISCUSSING THE SUBROUTINE
!     PARAMETERS...
!
!     ABAR   =  (   A    ),          BBAR  =  ( B )
!               ( DAMP*I )                    ( 0 )
!
!     R      =  B  -  A*X,           RBAR  =  BBAR  -  ABAR*X
!
!     RNORM  =  SQRT( NORM(R)**2  +  DAMP**2 * NORM(X)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  THE SMALLEST FLOATING POINT NUMBER FOR WHICH
!               1 + RELPR .GT. 1.
!
!     STLSQ  MINIMIZES THE FUNCTION RNORM WITH RESPECT TO X.
!
!
!     PARAMETERS
!     ----------
!
!     M       INPUT      THE NUMBER OF ROWS IN A.
!
!     N       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     TA,ITA  INPUT      THE TRANSPOSE OF THE MATRIX A IS STORED
!      JTA               ROWWISE IN SPARSE FORM.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (DAMP  SHOULD BE 0.0 FOR PROBLEMS 1 AND 2.)
!                        IF THE SYSTEM  A*X = B  IS INCOMPATIBLE, VALUES
!                        OF DAMP IN THE RANGE 0 TO SQRT(RELPR)*NORM(A)
!                        WILL PROBABLY HAVE A NEGLIGIBLE EFFECT.
!                        LARGER VALUES OF DAMP WILL TEND TO DECREASE
!                        THE NORM OF X AND TO REDUCE THE NUMBER OF
!                        ITERATIONS REQUIRED BY STLSQ.
!
!                        THE WORK PER ITERATION AND THE STORAGE NEEDED
!                        BY STLSQ ARE THE SAME FOR ALL VALUES OF DAMP.
!
!     U(M)    INPUT      THE RHS VECTOR B. BE AWARE THAT U IS
!                        OVER-WRITTEN BY STLSQ.
!
!     X(N)    OUTPUT     RETURNS THE COMPUTED SOLUTION X.
!
!     ATOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        DEFINING THE MATRIX A. FOR EXAMPLE,
!                        IF A IS ACCURATE TO ABOUT 6 DIGITS, SET
!                        ATOL = 1.0E-6 .
!
!     BTOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        DEFINING THE RHS VECTOR B. FOR EXAMPLE,
!                        IF B IS ACCURATE TO ABOUT 6 DIGITS, SET
!                        BTOL = 1.0E-6 .
!
!     CONLIM  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        CONDITION NUMBER OF THE MATRIX ABAR.
!                        ITERATIONS WILL BE TERMINATED IF A COMPUTED
!                        ESTIMATE OF COND(ABAR) EXCEEDS CONLIM.
!                        THIS IS INTENDED TO PREVENT CERTAIN SMALL OR
!                        ZERO SINGULAR VALUES OF A OR ABAR FROM
!                        COMING INTO EFFECT AND CAUSING UNWANTED GROWTH
!                        IN THE COMPUTED SOLUTION.
!
!                        CONLIM AND DAMP MAY BE USED SEPARATELY OR
!                        TOGETHER TO REGULARIZE ILL-CONDITIONED SYSTEMS.
!
!                        NORMALLY, CONLIM SHOULD BE IN THE RANGE
!                        1000  TO  1/RELPR.
!                        SUGGESTED VALUE --
!                        CONLIM = 1/(100*RELPR)  FOR COMPATIBLE SYSTEMS,
!                        CONLIM = 1/(10*SQRT(RELPR))  FOR LEAST SQUARES.
!
!             NOTE. IF THE USER IS NOT CONCERNED ABOUT THE PARAMETERS
!             ATOL, BTOL, AND CONLIM, ANY OR ALL OF THEM MAY BE SET
!             TO ZERO. THE EFFECT WILL BE THE SAME AS THE VALUES
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     ITNLIM  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        SUGGESTED VALUE --
!                        ITNLIM = N/2     FOR WELL CONDITIONED SYSTEMS,
!                        ITNLIM = 4*N     OTHERWISE.
!
!     ISTOP   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       X = 0  IS THE EXACT SOLUTION.
!                        NO ITERATIONS WERE PERFORMED.
!
!                1       THE EQUATIONS  A*X = B  ARE PROBABLY
!                        COMPATIBLE. NORM(A*X - B) IS SUFFICIENTLY
!                        SMALL, GIVEN THE VALUES OF ATOL AND BTOL.
!
!                2       THE SYSTEM  A*X = B  IS PROBABLY NOT
!                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
!                        BEEN OBTAINED WHICH IS SUFFICIENTLY ACCURATE,
!                        GIVEN THE VALUE OF ATOL.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        CONLIM. THE SYSTEM  A*X = B  APPEARS TO BE
!                        ILL-CONDITIONED.
!
!                4       THE EQUATIONS  A*X = B  ARE PROBABLY
!                        COMPATIBLE. NORM(A*X - B) IS AS SMALL AS
!                        SEEMS REASONABLE ON THIS MACHINE.
!
!                5       THE SYSTEM  A*X = B  IS PROBABLY NOT
!                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
!                        BEEN OBTAINED WHICH IS AS ACCURATE AS SEEMS
!                        REASONABLE ON THIS MACHINE.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        NOT MUCH POINT IN DOING FURTHER ITERATIONS,
!                        GIVEN THE PRECISION OF THIS MACHINE.
!
!                7       THE ITERATION LIMIT ITNLIM WAS REACHED.
!
!
!     ITN     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     ACOND   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        NUMBER OF ABAR.
!
!     RNORM   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        THE FUNCTION BEING MINIMIZED (SEE NOTATION
!                        ABOVE). THIS WILL BE SMALL IF  A*X = B  HAS
!                        A SOLUTION.
!
!     XNORM   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        SOLUTION VECTOR X.
!
!     W(2*N)             WORKSPACE
!
!     ANORM   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        THIS IS THE SQUARE ROOT OF THE SUM OF SQUARES
!                        OF THE ELEMENTS OF ABAR.
!                        IF DAMP IS SMALL AND IF THE COLUMNS OF A
!                        HAVE ALL BEEN SCALED TO HAVE LENGTH  1.0,
!                        ANORM SHOULD INCREASE TO ROUGHLY SQRT(N).
!
!     ARNORM  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        NORM( ABAR(TRANSPOSE)*RBAR ), THE NORM OF
!                        THE RESIDUAL FOR THE USUAL NORMAL EQUATIONS.
!                        THIS SHOULD BE SMALL IN ALL CASES. (ARNORM
!                        WILL OFTEN BE SMALLER THAN THE TRUE VALUE
!                        COMPUTED FROM THE OUTPUT VECTOR X.)
!
!
!     SUBROUTINES AND FUNCTIONS USED
!     ------------------------------
!
!                NORMLZ,MVPRD1,MTPRD1
!     BLAS       SCOPY,SNRM2,SSCAL  (SEE LAWSON ET AL. BELOW)
!                (SNRM2 IS USED ONLY IN NORMLZ)
!     FORTRAN    ABS,SQRT
!
!
!     REFERENCES
!     ----------
!
!     PAIGE, C.C. AND SAUNDERS, M.A.  LSQR, AN ALGORITHM FOR SPARSE
!        LINEAR EQUATIONS AND SPARSE LEAST SQUARES.
!        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 8, 1 (MARCH 1982).
!
!     LAWSON, C.L., HANSON, R.J., KINCAID, D.R. AND KROGH, F.T.
!        BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE.
!        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 5, 3 (SEPT 1979),
!        308-323 AND 324-325.
!
!     ------------------------------------------------------------------
!
!     LOCAL VARIABLES
!
integer :: i
integer, intent(inout) :: itn
integer :: nconv, nstop
real :: alfa, anorm, arnorm, bbnorm, beta, bnorm, cs, cs1, cs2, &
&ctol, dampsq, ddnorm, delta, gamma, gambar, one, phi, phibar, psi, &
&res1, res2, rho, rhobar, rhbar1, rhbar2, rhs, rtol, sn, sn1, sn2, &
&t, tau, test1, test2, test3, theta, t1, t2, t3, xxnorm, z, zbar, &
&zero
!
!
!     INITIALIZE.
!
zero   = 0.0
one    = 1.0
ctol   = zero
if (conlim .gt. zero) ctol = one/conlim
dampsq = damp**2
anorm  = zero
acond  = zero
bbnorm = zero
ddnorm = zero
res2   = zero
xnorm  = zero
xxnorm = zero
cs2    = -one
sn2    = zero
z      = zero
itn    = 0
istop  = 0
nstop  = 0
!
do i = 1, n
   w(i) = zero
   x(i) = zero
end do
!
!     SET UP THE FIRST VECTORS FOR THE BIDIAGONALIZATION.
!     THESE SATISFY   BETA*U = B,   ALFA*W = A(TRANSPOSE)*U.
!
call normlz(m,u,beta)
call mvprd1(n,m,ta,ita,jta,u,w)
call normlz(n,w,alfa)
call scopy (n,w,1,w(n+1),1)
!
rhobar = alfa
phibar = beta
bnorm  = beta
rnorm  = beta
arnorm = alfa*beta
if (arnorm .le. zero) go to 800
!
!     ------------------------------------------------------------------
!     MAIN ITERATION LOOP.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     PERFORM THE NEXT STEP OF THE BIDIAGONALIZATION TO OBTAIN THE
!     NEXT  BETA, U, ALFA, W.  THESE SATISFY THE RELATIONS
!                BETA*U  =  A*W  -  ALFA*U,
!                ALFA*W  =  A(TRANSPOSE)*U  -  BETA*W.
!
call sscal (m,(-alfa),u,1)
call mtprd1(n,m,ta,ita,jta,w,u)
call normlz(m,u,beta)
bbnorm = bbnorm + alfa**2 + beta**2 + dampsq
call sscal (n,(-beta),w,1)
call mvprd1(n,m,ta,ita,jta,u,w)
call normlz(n,w,alfa)
!
!
!     USE A PLANE ROTATION TO ELIMINATE THE DAMPING PARAMETER.
!     THIS ALTERS THE DIAGONAL (RHOBAR) OF THE LOWER-BIDIAGONAL MATRIX.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1    = rhobar/rhbar1
sn1    = damp/rhbar1
psi    = sn1*phibar
phibar = cs1*phibar
!
!
!     USE A PLANE ROTATION TO ELIMINATE THE SUBDIAGONAL ELEMENT (BETA)
!     OF THE LOWER-BIDIAGONAL MATRIX, GIVING AN UPPER-BIDIAGONAL MATRIX.
!
rho    = sqrt(rhbar2 + beta**2)
cs     = rhbar1/rho
sn     = beta/rho
theta  =  sn*alfa
rhobar = -cs*alfa
phi    =  cs*phibar
phibar =  sn*phibar
tau    =  sn*phi
!
!
!     UPDATE X AND W(N+1),...,W(2*N)
!
t1 =    phi/rho
t2 = -theta/rho
t3 =    one/rho
!
do i = 1, n
   npi   = n + i
   t     = w(npi)
   x(i)  = t1*t + x(i)
   w(npi)= t2*t + w(i)
   t     =(t3*t)**2
   ddnorm= t + ddnorm
end do
!
!
!     USE A PLANE ROTATION ON THE RIGHT TO ELIMINATE THE
!     SUPER-DIAGONAL ELEMENT (THETA) OF THE UPPER-BIDIAGONAL MATRIX.
!     THEN USE THE RESULT TO ESTIMATE NORM(X).
!
delta  =  sn2*rho
gambar = -cs2*rho
rhs    = phi - delta*z
zbar   = rhs/gambar
xnorm  = sqrt(xxnorm + zbar**2)
gamma  = sqrt(gambar**2 + theta**2)
cs2    = gambar/gamma
sn2    = theta/gamma
z      = rhs/gamma
xxnorm = xxnorm + z**2
!
!
!     TEST FOR CONVERGENCE.
!     FIRST, ESTIMATE THE NORM AND CONDITION OF THE MATRIX ABAR,
!     AND THE NORMS OF RBAR AND ABAR(TRANSPOSE)*RBAR.
!
anorm  = sqrt(bbnorm)
acond  = anorm*sqrt(ddnorm)
res1   = phibar**2
res2   = res2 + psi**2
rnorm  = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     NOW USE THESE NORMS TO ESTIMATE CERTAIN OTHER QUANTITIES,
!     SOME OF WHICH WILL BE SMALL NEAR A SOLUTION.
!
test1  = rnorm/bnorm
test2  = arnorm/(anorm*rnorm)
test3  = one/acond
t1     = test1/(one + anorm*xnorm/bnorm)
rtol   = btol +  atol*anorm*xnorm/bnorm
!
!     THE FOLLOWING TESTS GUARD AGAINST EXTREMELY SMALL VALUES OF
!     ATOL, BTOL, OR CTOL.  (THE USER MAY HAVE SET ANY OR ALL OF
!     THE PARAMETERS ATOL, BTOL, CONLIM TO ZERO.)
!     THE EFFECT IS EQUIVALENT TO THE NORMAL TESTS USING
!     ATOL = RELPR,  BTOL = RELPR,  CONLIM = 1/RELPR.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn .ge. itnlim) istop = 7
if (t3  .le. one   ) istop = 6
if (t2  .le. one   ) istop = 5
if (t1  .le. one   ) istop = 4
!
!     ALLOW FOR TOLERANCES SET BY THE USER.
!
if (test3 .le. ctol) istop = 3
if (test2 .le. atol) istop = 2
if (test1 .le. rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     THE CONVERGENCE CRITERIA ARE REQUIRED TO BE MET ON  NCONV
!     CONSECUTIVE ITERATIONS, WHERE  NCONV  IS SET BELOW.
!     SUGGESTED VALUE --   NCONV = 1, 2  OR  3.
!
if (istop .eq. 0) nstop = 0
if (istop .eq. 0) go to 100
nconv = 1
nstop = nstop + 1
if (nstop .lt. nconv  .and.  itn .lt. itnlim) istop = 0
if (istop .eq. 0) go to 100
!     ------------------------------------------------------------------
!     END OF ITERATION LOOP.
!     ------------------------------------------------------------------
!
800 return
end subroutine stlsq

subroutine blsq(m,n,a,ka,ml,mu,damp,u,x,atol,btol,conlim,itnlim, &
&istop,itn,acond,rnorm,xnorm,w)
implicit none
integer :: npi
!
integer, intent(in) :: m
integer :: n
integer, intent(in) :: ka, ml, mu, itnlim
integer, intent(inout) :: istop
real, intent(in) :: a(ka,n), damp
real, intent(inout) :: u(m), x(n)
real, intent(in) :: atol, btol, conlim
real, intent(inout) :: acond, rnorm, xnorm, w(*)
!     ------------------------------------------------------------------
!
!     BLSQ FINDS A SOLUTION X TO THE FOLLOWING PROBLEMS ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*X = B
!
!     2. LINEAR LEAST SQUARES  --    SOLVE  A*X = B
!                                    IN THE LEAST-SQUARES SENSE
!
!     3. DAMPED LEAST SQUARES  --    SOLVE  (   A    )*X = ( B )
!                                           ( DAMP*I )     ( 0 )
!                                    IN THE LEAST-SQUARES SENSE
!
!     WHERE A IS A MATRIX WITH M ROWS AND N COLUMNS, B AN M-VECTOR,
!     AND DAMP A SCALAR. (ALL QUANTITIES ARE REAL.) THE MATRIX A IS
!     A BANDED MATRIX STORED IN BAND FORM.
!
!     THE RHS VECTOR B IS INPUT VIA U, AND IS SUBSEQUENTLY OVERWRITTEN.
!
!
!     NOTE. BLSQ USES AN ITERATIVE METHOD TO APPROXIMATE THE SOLUTION.
!     THE NUMBER OF ITERATIONS REQUIRED TO REACH A CERTAIN ACCURACY
!     DEPENDS STRONGLY ON THE SCALING OF THE PROBLEM. POOR SCALING OF
!     THE ROWS OR COLUMNS OF A SHOULD THEREFORE BE AVOIDED WHENEVER
!     POSSIBLE.
!
!     FOR EXAMPLE, IN PROBLEM 1 THE SOLUTION IS UNALTERED BY
!     ROW-SCALING.  IF A ROW OF A IS VERY SMALL OR LARGE COMPARED TO
!     THE OTHER ROWS OF A, THE CORRESPONDING ROW OF (A  B) SHOULD BE
!     SCALED UP OR DOWN.
!
!     IN PROBLEMS 1 AND 2, THE SOLUTION X IS EASILY RECOVERED
!     FOLLOWING COLUMN SCALING. IN THE ABSENCE OF BETTER INFORMATION,
!     THE NONZERO COLUMNS OF A SHOULD BE SCALED SO THAT THEY ALL HAVE
!     THE SAME EUCLIDEAN NORM (E.G.  1.0).
!
!     IN PROBLEM 3, THERE IS NO FREEDOM TO RE-SCALE IF DAMP IS
!     NONZERO. HOWEVER, THE VALUE OF DAMP SHOULD BE ASSIGNED ONLY
!     AFTER ATTENTION HAS BEEN PAID TO THE SCALING OF A.
!
!     THE PARAMETER DAMP IS INTENDED TO HELP REGULARIZE
!     ILL-CONDITIONED SYSTEMS, BY PREVENTING THE TRUE SOLUTION FROM
!     BEING VERY LARGE. ANOTHER AID TO REGULARIZATION IS PROVIDED BY
!     THE PARAMETER ACOND, WHICH MAY BE USED TO TERMINATE ITERATIONS
!     BEFORE THE COMPUTED SOLUTION BECOMES VERY LARGE.
!
!
!     NOTATION
!     --------
!
!     THE FOLLOWING QUANTITIES ARE USED IN DISCUSSING THE SUBROUTINE
!     PARAMETERS...
!
!     ABAR   =  (   A    ),          BBAR  =  ( B )
!               ( DAMP*I )                    ( 0 )
!
!     R      =  B  -  A*X,           RBAR  =  BBAR  -  ABAR*X
!
!     RNORM  =  SQRT( NORM(R)**2  +  DAMP**2 * NORM(X)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  THE SMALLEST FLOATING POINT NUMBER FOR WHICH
!               1 + RELPR .GT. 1.
!
!     BLSQ   MINIMIZES THE FUNCTION RNORM WITH RESPECT TO X.
!
!
!     PARAMETERS
!     ----------
!
!     M       INPUT      THE NUMBER OF ROWS IN A.
!
!     N       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     A       INPUT      THE MATRIX A STORED IN BAND FORM.
!
!     KA      INPUT      THE NUMBER OF ROWS IN THE DIMENSION STATEMENT
!                        FOR A IN THE CALLING PROGRAM.
!
!     ML      INPUT      THE LOWER BAND WIDTH OF A.
!
!     MU      INPUT      THE UPPER BAND WIDTH OF A.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (DAMP  SHOULD BE 0.0 FOR PROBLEMS 1 AND 2.)
!                        IF THE SYSTEM  A*X = B  IS INCOMPATIBLE, VALUES
!                        OF DAMP IN THE RANGE 0 TO SQRT(RELPR)*NORM(A)
!                        WILL PROBABLY HAVE A NEGLIGIBLE EFFECT.
!                        LARGER VALUES OF DAMP WILL TEND TO DECREASE
!                        THE NORM OF X AND TO REDUCE THE NUMBER OF
!                        ITERATIONS REQUIRED BY BLSQ.
!
!                        THE WORK PER ITERATION AND THE STORAGE NEEDED
!                        BY BLSQ ARE THE SAME FOR ALL VALUES OF DAMP.
!
!     U(M)    INPUT      THE RHS VECTOR B. BE AWARE THAT U IS
!                        OVER-WRITTEN BY BLSQ.
!
!     X(N)    OUTPUT     RETURNS THE COMPUTED SOLUTION X.
!
!     ATOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        DEFINING THE MATRIX A. FOR EXAMPLE,
!                        IF A IS ACCURATE TO ABOUT 6 DIGITS, SET
!                        ATOL = 1.0E-6 .
!
!     BTOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        DEFINING THE RHS VECTOR B. FOR EXAMPLE,
!                        IF B IS ACCURATE TO ABOUT 6 DIGITS, SET
!                        BTOL = 1.0E-6 .
!
!     CONLIM  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        CONDITION NUMBER OF THE MATRIX ABAR.
!                        ITERATIONS WILL BE TERMINATED IF A COMPUTED
!                        ESTIMATE OF COND(ABAR) EXCEEDS CONLIM.
!                        THIS IS INTENDED TO PREVENT CERTAIN SMALL OR
!                        ZERO SINGULAR VALUES OF A OR ABAR FROM
!                        COMING INTO EFFECT AND CAUSING UNWANTED GROWTH
!                        IN THE COMPUTED SOLUTION.
!
!                        CONLIM AND DAMP MAY BE USED SEPARATELY OR
!                        TOGETHER TO REGULARIZE ILL-CONDITIONED SYSTEMS.
!
!                        NORMALLY, CONLIM SHOULD BE IN THE RANGE
!                        1000  TO  1/RELPR.
!                        SUGGESTED VALUE --
!                        CONLIM = 1/(100*RELPR)  FOR COMPATIBLE SYSTEMS,
!                        CONLIM = 1/(10*SQRT(RELPR))  FOR LEAST SQUARES.
!
!             NOTE. IF THE USER IS NOT CONCERNED ABOUT THE PARAMETERS
!             ATOL, BTOL, AND CONLIM, ANY OR ALL OF THEM MAY BE SET
!             TO ZERO. THE EFFECT WILL BE THE SAME AS THE VALUES
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     ITNLIM  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        SUGGESTED VALUE --
!                        ITNLIM = N/2     FOR WELL CONDITIONED SYSTEMS,
!                        ITNLIM = 4*N     OTHERWISE.
!
!     ISTOP   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       X = 0  IS THE EXACT SOLUTION.
!                        NO ITERATIONS WERE PERFORMED.
!
!                1       THE EQUATIONS  A*X = B  ARE PROBABLY
!                        COMPATIBLE. NORM(A*X - B) IS SUFFICIENTLY
!                        SMALL, GIVEN THE VALUES OF ATOL AND BTOL.
!
!                2       THE SYSTEM  A*X = B  IS PROBABLY NOT
!                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
!                        BEEN OBTAINED WHICH IS SUFFICIENTLY ACCURATE,
!                        GIVEN THE VALUE OF ATOL.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        CONLIM. THE SYSTEM  A*X = B  APPEARS TO BE
!                        ILL-CONDITIONED.
!
!                4       THE EQUATIONS  A*X = B  ARE PROBABLY
!                        COMPATIBLE. NORM(A*X - B) IS AS SMALL AS
!                        SEEMS REASONABLE ON THIS MACHINE.
!
!                5       THE SYSTEM  A*X = B  IS PROBABLY NOT
!                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
!                        BEEN OBTAINED WHICH IS AS ACCURATE AS SEEMS
!                        REASONABLE ON THIS MACHINE.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        NOT MUCH POINT IN DOING FURTHER ITERATIONS,
!                        GIVEN THE PRECISION OF THIS MACHINE.
!
!                7       THE ITERATION LIMIT ITNLIM WAS REACHED.
!
!
!     ITN     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     ACOND   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        NUMBER OF ABAR.
!
!     RNORM   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        THE FUNCTION BEING MINIMIZED (SEE NOTATION
!                        ABOVE). THIS WILL BE SMALL IF  A*X = B  HAS
!                        A SOLUTION.
!
!     XNORM   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        SOLUTION VECTOR X.
!
!     W(2*N)             WORKSPACE
!
!     ANORM   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        THIS IS THE SQUARE ROOT OF THE SUM OF SQUARES
!                        OF THE ELEMENTS OF ABAR.
!                        IF DAMP IS SMALL AND IF THE COLUMNS OF A
!                        HAVE ALL BEEN SCALED TO HAVE LENGTH  1.0,
!                        ANORM SHOULD INCREASE TO ROUGHLY SQRT(N).
!
!     ARNORM  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        NORM( ABAR(TRANSPOSE)*RBAR ), THE NORM OF
!                        THE RESIDUAL FOR THE USUAL NORMAL EQUATIONS.
!                        THIS SHOULD BE SMALL IN ALL CASES. (ARNORM
!                        WILL OFTEN BE SMALLER THAN THE TRUE VALUE
!                        COMPUTED FROM THE OUTPUT VECTOR X.)
!
!
!     SUBROUTINES AND FUNCTIONS USED
!     ------------------------------
!
!                NORMLZ,BVPRD1,BTPRD1
!     BLAS       SCOPY,SNRM2,SSCAL  (SEE LAWSON ET AL. BELOW)
!                (SNRM2 IS USED ONLY IN NORMLZ)
!     FORTRAN    ABS,SQRT
!
!
!     REFERENCES
!     ----------
!
!     PAIGE, C.C. AND SAUNDERS, M.A.  LSQR, AN ALGORITHM FOR SPARSE
!        LINEAR EQUATIONS AND SPARSE LEAST SQUARES.
!        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 8, 1 (MARCH 1982).
!
!     LAWSON, C.L., HANSON, R.J., KINCAID, D.R. AND KROGH, F.T.
!        BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE.
!        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 5, 3 (SEPT 1979),
!        308-323 AND 324-325.
!
!     ------------------------------------------------------------------
!
!     LOCAL VARIABLES
!
integer :: i
integer, intent(inout) :: itn
integer :: nconv, nstop
real :: alfa, anorm, arnorm, bbnorm, beta, bnorm, cs, cs1, cs2, &
&ctol, dampsq, ddnorm, delta, gamma, gambar, one, phi, phibar, psi, &
&res1, res2, rho, rhobar, rhbar1, rhbar2, rhs, rtol, sn, sn1, sn2, &
&t, tau, test1, test2, test3, theta, t1, t2, t3, xxnorm, z, zbar, &
&zero
!
!
!     INITIALIZE.
!
zero   = 0.0
one    = 1.0
ctol   = zero
if (conlim .gt. zero) ctol = one/conlim
dampsq = damp**2
anorm  = zero
acond  = zero
bbnorm = zero
ddnorm = zero
res2   = zero
xnorm  = zero
xxnorm = zero
cs2    = -one
sn2    = zero
z      = zero
itn    = 0
istop  = 0
nstop  = 0
!
do i = 1, n
   w(i) = zero
   x(i) = zero
end do
!
!     SET UP THE FIRST VECTORS FOR THE BIDIAGONALIZATION.
!     THESE SATISFY   BETA*U = B,   ALFA*W = A(TRANSPOSE)*U.
!
call normlz(m,u,beta)
call btprd1(m,n,a,ka,ml,mu,u,w)
call normlz(n,w,alfa)
call scopy (n,w,1,w(n+1),1)
!
rhobar = alfa
phibar = beta
bnorm  = beta
rnorm  = beta
arnorm = alfa*beta
if (arnorm .le. zero) go to 800
!
!     ------------------------------------------------------------------
!     MAIN ITERATION LOOP.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     PERFORM THE NEXT STEP OF THE BIDIAGONALIZATION TO OBTAIN THE
!     NEXT  BETA, U, ALFA, W.  THESE SATISFY THE RELATIONS
!                BETA*U  =  A*W  -  ALFA*U,
!                ALFA*W  =  A(TRANSPOSE)*U  -  BETA*W.
!
call sscal (m,(-alfa),u,1)
call bvprd1(m,n,a,ka,ml,mu,w,u)
call normlz(m,u,beta)
bbnorm = bbnorm + alfa**2 + beta**2 + dampsq
call sscal (n,(-beta),w,1)
call btprd1(m,n,a,ka,ml,mu,u,w)
call normlz(n,w,alfa)
!
!
!     USE A PLANE ROTATION TO ELIMINATE THE DAMPING PARAMETER.
!     THIS ALTERS THE DIAGONAL (RHOBAR) OF THE LOWER-BIDIAGONAL MATRIX.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1    = rhobar/rhbar1
sn1    = damp/rhbar1
psi    = sn1*phibar
phibar = cs1*phibar
!
!
!     USE A PLANE ROTATION TO ELIMINATE THE SUBDIAGONAL ELEMENT (BETA)
!     OF THE LOWER-BIDIAGONAL MATRIX, GIVING AN UPPER-BIDIAGONAL MATRIX.
!
rho    = sqrt(rhbar2 + beta**2)
cs     = rhbar1/rho
sn     = beta/rho
theta  =  sn*alfa
rhobar = -cs*alfa
phi    =  cs*phibar
phibar =  sn*phibar
tau    =  sn*phi
!
!
!     UPDATE X AND W(N+1),...,W(2*N)
!
t1 =    phi/rho
t2 = -theta/rho
t3 =    one/rho
!
do i = 1, n
   npi   = n + i
   t     = w(npi)
   x(i)  = t1*t + x(i)
   w(npi)= t2*t + w(i)
   t     =(t3*t)**2
   ddnorm= t + ddnorm
end do
!
!
!     USE A PLANE ROTATION ON THE RIGHT TO ELIMINATE THE
!     SUPER-DIAGONAL ELEMENT (THETA) OF THE UPPER-BIDIAGONAL MATRIX.
!     THEN USE THE RESULT TO ESTIMATE NORM(X).
!
delta  =  sn2*rho
gambar = -cs2*rho
rhs    = phi - delta*z
zbar   = rhs/gambar
xnorm  = sqrt(xxnorm + zbar**2)
gamma  = sqrt(gambar**2 + theta**2)
cs2    = gambar/gamma
sn2    = theta/gamma
z      = rhs/gamma
xxnorm = xxnorm + z**2
!
!
!     TEST FOR CONVERGENCE.
!     FIRST, ESTIMATE THE NORM AND CONDITION OF THE MATRIX ABAR,
!     AND THE NORMS OF RBAR AND ABAR(TRANSPOSE)*RBAR.
!
anorm  = sqrt(bbnorm)
acond  = anorm*sqrt(ddnorm)
res1   = phibar**2
res2   = res2 + psi**2
rnorm  = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     NOW USE THESE NORMS TO ESTIMATE CERTAIN OTHER QUANTITIES,
!     SOME OF WHICH WILL BE SMALL NEAR A SOLUTION.
!
test1  = rnorm/bnorm
test2  = arnorm/(anorm*rnorm)
test3  = one/acond
t1     = test1/(one + anorm*xnorm/bnorm)
rtol   = btol +  atol*anorm*xnorm/bnorm
!
!     THE FOLLOWING TESTS GUARD AGAINST EXTREMELY SMALL VALUES OF
!     ATOL, BTOL, OR CTOL.  (THE USER MAY HAVE SET ANY OR ALL OF
!     THE PARAMETERS ATOL, BTOL, CONLIM TO ZERO.)
!     THE EFFECT IS EQUIVALENT TO THE NORMAL TESTS USING
!     ATOL = RELPR,  BTOL = RELPR,  CONLIM = 1/RELPR.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn .ge. itnlim) istop = 7
if (t3  .le. one   ) istop = 6
if (t2  .le. one   ) istop = 5
if (t1  .le. one   ) istop = 4
!
!     ALLOW FOR TOLERANCES SET BY THE USER.
!
if (test3 .le. ctol) istop = 3
if (test2 .le. atol) istop = 2
if (test1 .le. rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     THE CONVERGENCE CRITERIA ARE REQUIRED TO BE MET ON  NCONV
!     CONSECUTIVE ITERATIONS, WHERE  NCONV  IS SET BELOW.
!     SUGGESTED VALUE --   NCONV = 1, 2  OR  3.
!
if (istop .eq. 0) nstop = 0
if (istop .eq. 0) go to 100
nconv = 1
nstop = nstop + 1
if (nstop .lt. nconv  .and.  itn .lt. itnlim) istop = 0
if (istop .eq. 0) go to 100
!     ------------------------------------------------------------------
!     END OF ITERATION LOOP.
!     ------------------------------------------------------------------
!
800 return
end subroutine blsq

subroutine fmin(f, a0, b0, x, w, aerr, rerr, error, ind)
implicit none
integer, intent(out) :: ind
!     ******************************************************************
!     GOLDEN SECTION MINIMIZATION OF A FUNCTION F(T)
!     ******************************************************************
real :: f
real, intent(in) :: a0, b0
real, intent(inout) :: x, w
real, intent(in) :: aerr, rerr
real, intent(inout) :: error
real :: eps, eps0, atol, ftol, rtol, tol
real :: a, b, c1, c2, e, fu, fv, u, v
real :: spmpar
external f
!     -------------------
!     C1 = 1 - C2
!     C2 = 0.5*(-1 + SQRT(5))
!     -------------------
data eps0/5.e-3/
data c1/.3819660112501052/
data c2/.6180339887498948/
!     -------------------
!     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
!
             eps = spmpar(1)
!     -------------------
a = a0
b = b0
ind = 0
atol = amax1(aerr,1.e-20)
ftol = amax1(2.0*eps,rerr)
rtol = amax1(7.0*eps,rerr)
!
e = b - a
u = a + c1*e
v = a + c2*e
fu = f(u)
fv = f(v)
!
!        LOCATION OF THE REGION OF A LOCAL MINIMUM
!
10 if (e .le. eps0*(1.0 + abs(a))) go to 40
if (fu - fv) 20,11,30
11 if (fu .gt. f(b)) go to 30
!
20 b = v
e = b - a
v = u
u = a + c1*e
fv = fu
fu = f(u)
go to 10
!
30 a = u
e = b - a
u = v
v = a + c2*e
fu = fv
fv = f(v)
go to 10
!
40 if (a .gt. 0.0 .or. b .lt. 0.0) go to 41
   w = f(0.0)
   if (w .le. amin1(fu,fv)) go to 100
41 if (a .ne. a0) go to 42
   if (a .eq. 0.0) go to 201
   w = f(a)
   if (w .le. amin1(fu,fv)) go to 130
   go to 201
42 if (b .ne. b0) go to 201
   if (b .eq. 0.0) go to 201
   w = f(b)
   if (w .le. amin1(fu,fv)) go to 150
   go to 201
!
!              CHECK IF 0 IS A LOCAL MINIMUM
!
100 if (b .le. atol) go to 110
x = 0.01*b
if (w .gt. f(x)) go to 180
b = x
go to 100
!
110 if (abs(a) .le. atol) go to 120
x = 0.01*a
if (w .gt. f(x)) go to 180
a = x
go to 110
!
120 x = 0.0
error = amax1(abs(a),b)
return
!
!             CHECK IF A0 IS A LOCAL MINIMUM
!
130 tol = amax1(rtol*abs(a),atol)
131 x = a + 0.01*e
if (w .gt. f(x)) go to 180
b = x
e = b - a
if (e .gt. tol) go to 131
!
x = a
error = e
return
!
!             CHECK IF B0 IS A LOCAL MINIMUM
!
150 tol = amax1(rtol*abs(b),atol)
151 x = b - 0.01*e
if (w .gt. f(x)) go to 180
a = x
e = b - a
if (e .gt. tol) go to 151
!
x = b
error = e
return
!
180 e = b - a
u = a + c1*e
v = a + c2*e
fu = f(u)
fv = f(v)
!
!             REFINEMENT OF THE LOCAL MINIMUM
!
200 ind = 0
201 if (fu .gt. fv) go to 210
!
b = v
e = b - a
v = u
u = a + c1*e
fv = fu
fu = f(u)
go to 220
!
210 a = u
e = b - a
u = v
v = a + c2*e
fu = fv
fv = f(v)
!
!        CHECKING THE ACCURACY OF THE LOCAL MINIMUM
!
220 if (e .le. amax1(rtol*abs(a),atol)) go to 240
if (abs(fv - fu) .gt. ftol*amax1(abs(fu),abs(fv))) go to 200
if (ind .eq. 1) go to 241
ind = 1
go to 201
!
!                    REPORT THE RESULTS
!
240 ind = 0
241 if (fu - fv) 242,243,244
242 x = u
w = fu
error = c1*e
return
243 x = v
w = fv
error = e
return
244 x = v
w = fv
error = c1*e
return
end subroutine fmin

subroutine optf (fcn,n,rerr,iter,xpls,fpls,ierr,wrk)
implicit none
integer, intent(inout) :: ierr, iter
integer :: n
real, intent(inout) :: fpls
real, intent(in) :: rerr
integer :: i, itncnt, itnlim, mo
real :: eps, fscale, gradtl, stepmx, steptl
real :: spmpar
!-----------------------------------------------------------------------
!                 INTERFACE TO MINIMIZATION PACKAGE
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       FCN        NAME OF ROUTINE TO EVALUATE MINIMIZATION FUNCTION.
!                  MUST BE DECLARED EXTERNAL IN CALLING ROUTINE.
!       N          DIMENSION OF PROBLEM
!       RERR       RELATIVE ACCURACY OF SUBROUTINE FCN.
!
!     INPUT/OUTPUT ...
!
!       ITER       ON INPUT ITER IS THE MAXIMUM NUMBER OF ITERATIONS
!                  THAT ARE PERMITTED. ON OUTPUT ITER IS THE NUMBER
!                  OF ITERATIONS THAT WERE ACTUALLY PERFORMED.
!       XPLS(N)    LOCAL MINIMUM
!
!     OUTPUT ...
!
!       FPLS       FUNCTION VALUE AT LOCAL MINIMUM XPLS
!       IERR       TERMINATION CODE
!
!     WORKSPACE ...
!
!       WRK(N,N+8)
!
!-----------------------------------------------------------------------
real, intent(inout) :: xpls(n), wrk(n,*)
external fcn
!
!     EQUIVALENCE WRK(N,1) = X(N)
!                 WRK(N,2) = TYPSIZ(N)
!                 WRK(N,3) = GPLS(N)
!                 WRK(N,4) = G(N)
!                 WRK(N,5) = P(N)
!                 WRK(N,6) = WRK0(N)
!                 WRK(N,7) = WRK1(N)
!                 WRK(N,8) = WRK2(N)
!                 WRK(N,9) = A(N,N)
!
!
!     SET TOLERANCES
!
eps = amax1(spmpar(1),abs(rerr))
gradtl = eps**0.4
stepmx = 0.0
steptl = eps
if (eps .le. 1.e-10) steptl = 10.0*eps
if (eps .lt. 1.e-13) steptl = 1.e2*eps
!
!     INITIALIZATION
!
mo = 0
itnlim = iter
iter = 0
do 10 i = 1,n
   wrk(i,1) = xpls(i)
   wrk(i,2) = 1.0
10 continue
fscale = 1.0
!
!     OPTIMIZE FCN
!
20 call optdrv(mo,n,n,wrk(1,1),fcn,wrk(1,2),fscale,rerr, &
&itnlim,itncnt,gradtl,stepmx,steptl,xpls,fpls,wrk(1,3), &
&ierr,wrk(1,9),wrk(1,4),wrk(1,5),wrk(1,6),wrk(1,7), &
&wrk(1,8))
iter = iter + itncnt
if (ierr .ne. -10) return
itnlim = itnlim - itncnt
go to 20
end subroutine optf

subroutine optdrv (mo,nr,n,x,fcn,typsiz,fscale,rerr, &
&itnlim,itncnt,gradtl,stepmx,steptl,xpls,fpls,gpls, &
&ierr,a,g,p,wrk0,wrk1,wrk2)
implicit none
integer, intent(inout) :: ierr, itncnt
integer, intent(in) :: itnlim
integer, intent(inout) :: mo
integer :: n
integer, intent(in) :: nr
real, intent(inout) :: a(nr,n), fpls, fscale, g(n), gpls(n)
real, intent(in) :: gradtl
real, intent(inout) :: p(n)
real, intent(in) :: rerr
real, intent(inout) :: stepmx
real, intent(in) :: steptl
real, intent(inout) :: typsiz(n), wrk0(n), wrk1(n), wrk2(n), x(n), &
&xpls(n)
integer :: i, iagflg, icscmx, iretcd, j, jp1, nm1, ns
real :: cbrnf, f, fstack(30), rnf, sqrnf, stmx
real :: spmpar
!-----------------------------------------------------------------------
!             DRIVER FOR NON-LINEAR OPTIMIZATION PROBLEM
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       NR         ROW DIMENSION OF MATRIX
!       N          DIMENSION OF PROBLEM
!       FCN        SUBROUTINE.  FCN EVALUATES THE FUNCTION TO BE
!                  OPTIMIZED. FCN MUST BE DECLARED EXTERNAL IN THE
!                  CALLING PROGRAM. THE ROUTINE HAS THE FORMAT
!                         CALL FCN (N, X, FVAL)
!                  WHERE X IS A POINT AND FVAL IS THE VALUE OF THE
!                  FUNCTION AT THE POINT.
!       RERR       RELATIVE ACCURACY OF SUBROUTINE FCN. IT IS
!                  ASSUMED THAT RERR IS NONNEGATIVE. IF RERR = 0
!                  THEN FCN IS ACCURATE TO MACHINE PRECISION.
!       ITNLIM     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       GRADTL     TOLERANCE AT WHICH THE GRADIENT IS CONSIDERED
!                  CLOSE ENOUGH TO ZERO TO TERMINATE ALGORITHM.
!                  (USED ONLY IN THE SUBROUTINE OPSTP.)
!       STEPTL     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                  CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
!
!     INPUT/OUTPUT ...
!
!       MO         NUMBER OF RESCALINGS OF THE VARIABLES.
!       X(N)       ESTIMATE OF A LOCAL MINIMUM OF FCN
!       TYPSIZ(N)  TYPICAL SIZE FOR EACH COMPONENT OF X
!       FSCALE     ESTIMATE OF SCALE OF MINIMUM VALUE OF FCN.
!                  (USED ONLY IN THE SUBROUTINE OPSTP.)
!       STEPMX     MAXIMUM ALLOWABLE STEP SIZE
!
!     OUTPUT ...
!
!       ITNCNT     NUMBER OF ITERATIONS COMPLETED
!       XPLS(N)    ESTIMATE OF A LOCAL MINIMUM OF FCN
!       FPLS       FUNCTION VALUE AT XPLS
!       GPLS(N)    GRADIENT AT XPLS
!       IERR       TERMINATION CODE
!
!     WORK SPACES ...
!
!       A(N,N)     CHOLESKY DECOMPOSITION OF HESSIAN
!       G(N)       GRADIENT AT THE CURRENT ITERATE
!       P(N)       STEP
!       WRK0(N)    WORKSPACE
!       WRK1(N)    WORKSPACE
!       WRK2(N)    WORKSPACE
!
!-----------------------------------------------------------------------
!     INTERNAL PARAMETERS ...
!
!       RNF        NOISE IN THE SUBROUTINE FCN
!       F          FUNCTION VALUE  FCN(X)
!       FSTACK(NS) STACK OF PREVIOUS FUNCTION VALUES
!       NS         LENGTH OF THE ARRAY FSTACK
!       SPTR       POINTER TO AN ELEMENT IN FSTACK
!-----------------------------------------------------------------------
integer :: sptr
logical :: mxtake, noupdt
external fcn
!
!     INITIALIZATION
!     --------------
ns = 30
stmx = stepmx
stepmx = 0.0
call opchk1 (n,x,typsiz,fscale,gradtl,itnlim,rerr,stepmx,ierr)
if (ierr .lt. 0) return
if (mo .ne. 0) stepmx = amax1(stmx,stepmx)
!
rnf = 2.0*amax1(rerr,spmpar(1))
sqrnf = sqrt(rnf)
!
itncnt = 0
iagflg = 0
iretcd = -1
icscmx = 0
!
!     EVALUATE FCN(X)
!
call fcn(n,x,f)
!
!     EVALUATE FINITE DIFFERENCE GRADIENT
!
call fstofd (n, x, fcn, f, g, typsiz, sqrnf)
!
call opstp (n,x,f,g,wrk1,itncnt,icscmx,ierr,gradtl,steptl, &
&typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr .eq. 0) go to 10
if (mo .ne. 0) go to 210
!
!        APPLY THE FIXED STEP COORDINATE DESCENT PROCEDURE
!        FOR ONE STEP AND CHECK IF THE GRADIENT IS NONZERO
!
   call fxdec (fcn, n, x, f, 10.0)
!
   stepmx = 0.0
   call opchk1 (n,x,typsiz,fscale,gradtl,itnlim,rerr,stepmx,ierr)
   call fstofd (n, x, fcn, f, g, typsiz, sqrnf)
   call opstp (n,x,f,g,wrk1,itncnt,icscmx,ierr,gradtl,steptl, &
&typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
   if (ierr .ne. 0) go to 210
!
!     THE HESSIAN WILL BE OBTAINED BY SECANT UPDATES.
!     SET A TO THE INITIAL HESSIAN.
!
10 nm1 = n - 1
do j = 1,nm1
   a(j,j) = 1.0/typsiz(j)
   jp1 = j + 1
   do i = jp1,n
      a(i,j) = 0.0
   end do
end do
a(n,n) = 1.0/typsiz(n)
go to 101
!
!
!     ITERATION
!     ---------
100 if (mo .gt. 1) go to 101
if (mod(itncnt,10) .ne. 0) go to 101
if (itncnt + 10 .ge. itnlim) go to 101
   call scalex (mo, x, typsiz, n, ierr)
   if (ierr .eq. 0) go to 101
   mo = mo + 1
   return
101 itncnt = itncnt + 1
!
!     SOLVE  A*P = -G  FOR NEWTON STEP
!
105 do i = 1,n
  wrk1(i) = -g(i)
end do
call lltslv(nr,n,a,p,wrk1)
!
!     TAKE A STEP, ARRIVING AT THE POINT XPLS
!
call lnsrch(n,x,f,g,p,xpls,fpls,fcn,mxtake,iretcd, &
&stepmx,steptl,typsiz)
!
!     IF A SATISFACTORY STEP COULD NOT BE FOUND AND FORWARD DIFFERENCE
!     GRADIENT WAS USED, RETRY USING A CENTRAL DIFFERENCE GRADIENT.
!
if (iretcd .ne. 1 .or. iagflg .ne. 0) go to 120
!
!        SET IAGFLG FOR CENTRAL DIFFERENCES
!
   iagflg = -1
   cbrnf = rnf**(1.0/3.0)
   call fstocd (n, x, fcn, typsiz, cbrnf, g)
   go to 105
!
!     CALCULATE GRADIENT AT XPLS
!
120 if (iagflg .eq. 0) go to 130
   call fstocd (n, xpls, fcn, typsiz, cbrnf, gpls)
   go to 140
130 call fstofd (n, xpls, fcn, fpls, gpls, typsiz, sqrnf)
!
!     CHECK WHETHER THE STOPPING CRITERIA SATISFIED
!
140 call opstp (n,xpls,fpls,gpls,x,itncnt,icscmx,ierr,gradtl,steptl, &
&typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr .ne. 0) go to 200
!
!     EVALUATE HESSIAN AT XPLS
!
call secfac(nr,n,x,g,a,xpls,gpls,itncnt,sqrnf, &
&noupdt,wrk0,wrk1,wrk2)
!
!     UPDATE F, X, AND G
!
f = fpls
do i = 1,n
  x(i) = xpls(i)
  g(i) = gpls(i)
end do
go to 100
!
!     TERMINATION
!     -----------
!     RESET XPLS,FPLS,GPLS  IF PREVIOUS ITERATE SOLUTION
!
200 if (ierr .ne. 3) return
!
210 fpls = f
do i = 1,n
   xpls(i) = x(i)
   gpls(i) = g(i)
end do
return
end subroutine optdrv

subroutine opchk1 (n,x,typsiz,fscale,gradtl,itnlim,rerr, &
&stepmx,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: itnlim, n
real, intent(inout) :: fscale
real, intent(in) :: gradtl, rerr
real, intent(inout) :: stepmx
integer :: i
real :: stpsiz
!-----------------------------------------------------------------------
!                  CHECK INPUT FOR REASONABLENESS
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       N          DIMENSION OF PROBLEM
!       X(N)       ESTIMATE OF MINIMUM OF FCN
!       GRADTL     TOLERANCE AT WHICH GRADIENT CONSIDERED CLOSE
!                  ENOUGH TO ZERO TO TERMINATE ALGORITHM
!       ITNLIM     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       RERR       RELATIVE ACCURACY OF SUBROUTINE FCN
!
!     INPUT/OUTPUT ...
!
!       TYPSIZ(N)  SCALING VECTOR FOR X
!       FSCALE     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION FCN
!       STEPMX     MAXIMUM STEP SIZE
!
!     OUTPUT ...
!
!       IERR       ERROR INDICATOR
!
!-----------------------------------------------------------------------
real, intent(in) :: x(n)
real, intent(inout) :: typsiz(n)
!
!     CHECK THAT PARAMETERS ONLY TAKE ON ACCEPTABLE VALUES.
!     IF NOT, SET THEM TO DEFAULT VALUES.
!
ierr = 0
!
!     CHECK DIMENSION OF PROBLEM
!
if (n .le. 0) go to 805
if (n .eq. 1) go to 810
!
!     COMPUTE SCALE MATRIX
!
do i = 1,n
  typsiz(i) = abs(typsiz(i))
  if (typsiz(i) .eq. 0.0) typsiz(i) = 1.0
end do
!
!     CHECK MAXIMUM STEP SIZE
!
if (stepmx .gt. 0.0) go to 20
stpsiz = 0.0
do i = 1, n
   stpsiz = stpsiz + (x(i)/typsiz(i))**2
end do
stpsiz = sqrt(stpsiz)
stepmx = amax1(1.0e3*stpsiz, 1.0e3)
20 continue
!
!     CHECK FUNCTION SCALE
!
fscale = abs(fscale)
if (fscale .eq. 0.0) fscale = 1.0
!
!     CHECK GRADIENT TOLERANCE
!
if (gradtl .lt. 0.0) go to 815
!
!     CHECK ITERATION LIMIT
!
if (itnlim .le. 0) go to 820
!
!     CHECK THE ACCURACY OF FCN
!
if (rerr .lt. 0.0 .or. rerr .gt. 1.e-4) go to 825
return
!
!     ERROR EXITS
!
805 ierr = -1
go to 895
810 ierr = -2
go to 895
815 ierr = -3
go to 895
820 ierr = -4
go to 895
825 ierr = -5
895 return
end subroutine opchk1

subroutine opstp(n,xpls,fpls,gpls,x,itncnt,icscmx,ierr, &
&gradtl,steptl,typsiz,fscale,itnlim,iretcd,mxtake, &
&fstack,ns,sptr)
implicit none
integer, intent(inout) :: icscmx
integer, intent(out) :: ierr
integer, intent(in) :: iretcd, itncnt, itnlim, n, ns
real, intent(in) :: fpls
real, intent(inout) :: fscale
real, intent(in) :: gradtl, steptl
integer :: i, jerr
real :: d, grd, relstp, rgx, rsx
!-----------------------------------------------------------------------
!            UNCONSTRAINED MINIMIZATION STOPPING CRITERIA
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       N          DIMENSION OF PROBLEM
!       XPLS(N)    NEW ITERATE X(K)
!       FPLS       FUNCTION VALUE AT NEW ITERATE, F(XPLS)
!       GPLS(N)    GRADIENT AT NEW ITERATE, G(XPLS), OR APPROXIMATE
!       X(N)       OLD ITERATE X(K-1)
!       ITNCNT     CURRENT ITERATION K
!       ICSCMX     NUMBER CONSECUTIVE STEPS .GE. STEPMX
!       GRADTL     TOLERANCE AT WHICH RELATIVE GRADIENT CONSIDERED CLOSE
!                  ENOUGH TO ZERO TO TERMINATE ALGORITHM
!       STEPTL     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                  CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
!       TYPSIZ(N)  SCALING VECTOR FOR X
!       ITNLIM     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       IRETCD     CODE WHICH WAS SET WHEN THE POINT XPLS WAS OBTAINED
!       MXTAKE     BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
!       NS         LENGTH OF THE ARRAY FSTACK
!
!     INPUT/OUTPUT ...
!
!       FSCALE     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION
!       FSTACK(NS) STACK OF PREVIOUS FUNCTION VALUES
!       SPTR       POINTER TO AN ELEMENT IN FSTACK
!
!     OUTPUT ...
!
!       ICSCMX     NUMBER CONSECUTIVE STEPS .GE. STEPMX
!                  (RETAIN VALUE BETWEEN SUCCESSIVE CALLS)
!       IERR       TERMINATION CODE
!
!-----------------------------------------------------------------------
real, intent(in) :: xpls(n), gpls(n), x(n), typsiz(n)
real, intent(inout) :: fstack(ns)
integer, intent(inout) :: sptr
logical, intent(in) :: mxtake
!
ierr = 0
!
!     LAST GLOBAL STEP FAILED TO LOCATE A POINT LOWER THAN X
!
if (iretcd .ne. 1) go to 10
   ierr = 3
   return
10 continue
!
!     FIND DIRECTION IN WHICH RELATIVE GRADIENT MAXIMUM.
!     CHECK WHETHER WITHIN TOLERANCE.
!
d = amax1(abs(fpls),fscale)
rgx = 0.0
do 20 i = 1,n
   grd = abs(gpls(i))*amax1(abs(xpls(i)),typsiz(i))
   rgx = amax1(rgx, grd)
20 continue
jerr = 1
if (rgx .gt. gradtl*d) go to 30
   if (abs(fpls) .le. 1.e-9) go to 100
   if (abs(fpls) .gt. 0.5*fscale) go to 100
   fscale = abs(fpls)
30 if (itncnt .eq. 0) return
!
!     FIND DIRECTION IN WHICH RELATIVE STEPSIZE MAXIMUM
!     CHECK WHETHER WITHIN TOLERANCE.
!
rsx = 0.0
do i = 1,n
   relstp = abs(xpls(i) - x(i))/amax1(abs(xpls(i)),typsiz(i))
   rsx = amax1(rsx,relstp)
end do
jerr = 2
if (rsx .le. steptl) go to 100
!
!     CHECK IF FPLS IS SUFFICIENTLY LESS THAN THE NS-TH
!     PREVIOUS VALUE OF FCN.
!
if (itncnt .gt. ns) go to 50
   sptr = itncnt
   fstack(sptr) = fpls
   go to 60
50 sptr = sptr + 1
if (sptr .gt. ns) sptr = 1
jerr = 3
if (fpls .ge. (fstack(sptr) - 1.e-3*abs(fstack(sptr)))) &
&go to 100
fstack(sptr) = fpls
!
!     CHECK ITERATION LIMIT
!
60 jerr = 4
if (itncnt .ge. itnlim) go to 100
!
!     CHECK NUMBER OF CONSECUTIVE STEPS OF SIZE STEPMX
!
if (mxtake) go to 70
   icscmx = 0
   return
70 icscmx = icscmx + 1
if (icscmx .ge. 20) ierr = 5
return
!
!     TERMINATE
!
100 ierr = jerr
return
end subroutine opstp

subroutine fxdec (fcn, n, x, fx, r)
implicit none
integer :: n
real, intent(inout) :: fx
real, intent(in) :: r
integer :: i
real :: fminus, fplus, h, xi, xminus, xplus
!-----------------------------------------------------------------------
!     FIXED STEP COORDINATE DESCENT PROCEDURE / ONE ITERATION
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
external fcn
!
do 20 i = 1,n
   h = r * amax1(abs(x(i)), 1.0)
   xi = x(i)
   xplus = xi + h
   x(i) = xplus
   call fcn (n, x, fplus)
   xminus = xi - 1.1*h
   x(i) = xminus
   call fcn (n, x, fminus)
   x(i) = xi
!
   if (fx .le. fplus) go to 10
      fx = fplus
      x(i) = xplus
10 if (fx .le. fminus) go to 20
      fx = fminus
      x(i) = xminus
20 continue
return
end subroutine fxdec

subroutine scalex (mo, x, typsiz, n, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo, n
integer :: i
real :: big, c, t, xmin
real :: spmpar
real, intent(in) :: x(n)
real, intent(inout) :: typsiz(n)
!-----------------------------------------------------------------------
!     RESCALE THE VARIABLES
!-----------------------------------------------------------------------
xmin = 1.e-5*spmpar(3)
do 10 i = 1,n
   t = amax1(abs(x(i)), 1.e-20)
   xmin = amin1(t, xmin)
10 continue
!
c = 1.e3
if (mo .ne. 0) c = 1.e2
big = c*xmin
do 20 i = 1,n
   if (abs(x(i)) .ge. big) go to 30
20 continue
ierr = 0
return
!
30 do i = 1,n
   t = abs(x(i))/c
   typsiz(i) = amax1(t, xmin)
end do
ierr = -10
return
end subroutine scalex

subroutine lltslv (nr,n,a,x,b)
implicit none
integer, intent(in) :: n, nr
integer :: i, ii, im1, ip1, j
real :: sum
!-----------------------------------------------------------------------
!        SOLUTION OF AX = B WHERE A HAS THE FORM L(L-TRANSPOSE)
!           BUT ONLY THE LOWER TRIANGULAR PART L IS STORED.
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       NR       ROW DIMENSION OF MATRIX
!       N        ORDER OF THE MATRIX
!       A(N,N)   MATRIX OF FORM L(L-TRANSPOSE). A IS NOT
!                MODIFIED BY THE ROUTINE.
!       B(N)     RIGHT-HAND SIDE VECTOR
!
!     OUTPUT ...
!
!       X(N)     SOLUTION VECTOR
!
!-----------------------------------------------------------------------
!     NOTE.  B AND X MAY SHARE THE SAME STORAGE AREA.
!-----------------------------------------------------------------------
real, intent(in) :: a(nr,n)
real, intent(inout) :: x(n)
real, intent(in) :: b(n)
!
!                  FORWARD SOLVE, RESULT IN X
!
x(1) = b(1)/a(1,1)
if (n .eq. 1) go to 30
do i = 2,n
   sum = 0.0
   im1 = i - 1
   do j = 1,im1
      sum = sum + a(i,j)*x(j)
   end do
   x(i) = (b(i) - sum)/a(i,i)
end do
!
!                   BACK SOLVE, RESULT IN X
!
30 x(n) = x(n)/a(n,n)
if (n .eq. 1) return
i = n
do ii = 2,n
   ip1 = i
   i = i - 1
   sum = 0.0
   do j = ip1,n
      sum = sum + a(j,i)*x(j)
   end do
   x(i) = (x(i) - sum)/a(i,i)
end do
return
end subroutine lltslv

subroutine fstofd (n, x, fcn, fx, g, typsiz, r)
implicit none
integer :: n
real, intent(in) :: fx
real, intent(inout) :: g(n)
real, intent(in) :: r
real :: typsiz(n)
real, intent(inout) :: x(n)
integer :: j
real :: fplus, stepsz, xtmpj
!-----------------------------------------------------------------------
!     FIND FORWARD DIFFERENCE APPROXIMATION G TO THE FIRST DERIVATIVE
!     (GRADIENT) OF THE FUNCTION DEFINED BY FCN AT THE POINT X.
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       N          DIMENSION OF PROBLEM
!       X(N)       POINT AT WHICH THE GRADIENT IS TO BE APPROXIMATED
!       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       FX         VALUE OF FCN AT THE POINT X
!       TYPSIZ(N)  SCALING VECTOR FOR X
!       R          STEPSIZE FACTOR
!
!     OUTPUT ...
!
!       G(N)       FINITE DIFFERENCE APPROXIMATION TO THE GRADIENT
!
!-----------------------------------------------------------------------
external fcn
!
do j = 1,n
  stepsz = r * amax1(abs(x(j)),typsiz(j))
  xtmpj = x(j)
  x(j) = xtmpj + stepsz
  call fcn (n, x, fplus)
  x(j) = xtmpj
  g(j) = (fplus - fx)/stepsz
end do
return
end subroutine fstofd

subroutine fstocd (n, x, fcn, typsiz, r, g)
implicit none
integer :: n
real, intent(in) :: r
integer :: i
real :: fminus, fplus, stepi, xtempi
!-----------------------------------------------------------------------
!     FIND CENTRAL DIFFERENCE APPROXIMATION G TO THE FIRST DERIVATIVE
!     (GRADIENT) OF THE FUNCTION DEFINED BY FCN AT THE POINT X.
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       N          DIMENSION OF PROBLEM
!       X(N)       POINT AT WHICH GRADIENT IS TO BE APPROXIMATED
!       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       TYPSIZ(N)  SCALING VECTOR FOR X
!       R          STEPSIZE FACTOR
!
!     OUTPUT ...
!
!       G(N)       CENTRAL DIFFERENCE APPROXIMATION TO GRADIENT
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
real, intent(in) :: typsiz(n)
real, intent(inout) :: g(n)
external fcn
!
!     FIND I-TH  STEPSIZE, EVALUATE TWO NEIGHBORS IN DIRECTION OF
!     I-TH UNIT VECTOR, AND EVALUATE I-TH  COMPONENT OF GRADIENT.
!
do i = 1, n
   stepi = r * amax1(abs(x(i)),typsiz(i))
   xtempi = x(i)
   x(i) = xtempi + stepi
   call fcn (n, x, fplus)
   x(i) = xtempi - stepi
   call fcn (n, x, fminus)
   x(i) = xtempi
   g(i) = (fplus - fminus)/(2.0*stepi)
end do
return
end subroutine fstocd

subroutine lnsrch(n,x,f,g,p,xpls,fpls,fcn,mxtake,iretcd, &
&stepmx,steptl,typsiz)
implicit none
integer, intent(out) :: iretcd
integer :: n
real, intent(in) :: f
real :: fpls
real, intent(in) :: stepmx, steptl
integer :: i
real :: a, b, disc, pfpls, plmbda, rln, rmnlmb, scl, sln, slp, t1, &
&t2, t3, tlmbda, tmp, w
real :: sdot
!-----------------------------------------------------------------------
!             FIND A NEXT NEWTON ITERATE BY LINE SEARCH
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       N         DIMENSION OF PROBLEM
!       X(N)      OLD ITERATE X(K-1)
!       F         FUNCTION VALUE AT OLD ITERATE, F(X)
!       G(N)      GRADIENT AT OLD ITERATE, G(X)
!       P(N)      NON-ZERO NEWTON STEP
!       FCN       NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       STEPMX    MAXIMUM ALLOWABLE STEP SIZE
!       STEPTL    RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                 CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
!       TYPSIZ(N) SCALING VECTOR FOR X
!
!     OUTPUT ...
!
!       XPLS(N)   NEW ITERATE X(K)
!       FPLS      FUNCTION VALUE AT NEW ITERATE, F(XPLS)
!       IRETCD    RETURN CODE
!       MXTAKE    BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
!
!-----------------------------------------------------------------------
!     INTERNAL VARIABLES ...
!
!       SLN      NEWTON LENGTH
!       RLN      RELATIVE LENGTH OF NEWTON STEP
!-----------------------------------------------------------------------
real, intent(in) :: x(n), g(n)
real, intent(inout) :: p(n), xpls(n)
real, intent(in) :: typsiz(n)
real :: lambda
logical, intent(out) :: mxtake
external fcn
!
mxtake = .false.
iretcd = 2
tmp = 0.0
do 10 i = 1,n
   tmp = tmp + (p(i)/typsiz(i))**2
10 continue
sln = sqrt(tmp)
!
if (sln .le. stepmx) go to 30
!
!     NEWTON STEP LONGER THAN MAXIMUM ALLOWED
!
   scl = stepmx/sln
   do i = 1,n
      p(i) = scl*p(i)
   end do
   sln = stepmx
!
30 slp = sdot(n,g,1,p,1)
rln = 0.0
do i = 1,n
   rln = amax1(rln,abs(p(i))/amax1(abs(x(i)),typsiz(i)))
end do
rmnlmb = steptl/rln
lambda = 1.0
!
!     LOOP.  CHECK IF THE NEW ITERATE IS SATISFACTORY.
!
100 do i = 1,n
  xpls(i) = x(i) + lambda*p(i)
end do
call fcn(n,xpls,fpls)
if (fpls .le. f + slp*1.e-4*lambda) go to 200
!
!     SOLUTION NOT (YET) FOUND
!
  if (lambda .lt. rmnlmb) go to 210
!
!     CALCULATE NEW LAMBDA
!
  if (lambda .ne. 1.0) go to 120
!
!     FIRST BACKTRACK. QUADRATIC FIT
!
      tlmbda = amin1(-slp/(2.0*(fpls - f - slp)), 0.9)
      go to 170
!
!     ALL SUBSEQUENT BACKTRACKS. CUBIC FIT
!
120 t1 = (fpls - f - lambda*slp)/(lambda*lambda)
      t2 = (pfpls - f - plmbda*slp)/(plmbda*plmbda)
      t3 = 1.0/(lambda - plmbda)
      a = t3*(t1 - t2)
      b = t3*(t2*lambda - t1*plmbda)
      w = 10.0*abs(t1*t3)
      if ((abs(a) + w) .ne. w) go to 130
!
!     THE CUBIC FIT DEGENERATES TO A QUADRATIC FIT
!
         tlmbda = -slp/(2.0*b)
         go to 160
!
!     THE CUBIC IS NONDEGENERATE
!
130 disc = b*b - 3.0*a*slp
      if (disc .le. b*b) go to 140
!
!     ONLY ONE POSITIVE CRITICAL POINT, MUST BE MINIMUM
!
         tlmbda = (-b + sign(1.0,a)*sqrt(disc))/(3.0*a)
         go to 160
!
!     BOTH CRITICAL POINTS POSITIVE, FIRST IS MINIMUM
!
140 if (disc .gt. 0.0) go to 150
            tlmbda = -b/(3.0*a)
            go to 160
150 tlmbda = (-b - sign(1.0,a)*sqrt(disc))/(3.0*a)
!
160 if (tlmbda .gt. 0.5*lambda) tlmbda = 0.5*lambda
!
!
170 plmbda = lambda
    pfpls = fpls
    if (tlmbda .ge. lambda*0.1) go to 180
      lambda = lambda*0.1
      go to 100
180 lambda = tlmbda
    go to 100
!
!     A SUITABLE VALUE FOR XPLS HAS BEEN OBTAINED
!
200 iretcd = 0
if (lambda .eq. 1.0 .and. sln .gt. 0.99*stepmx) mxtake =.true.
return
!
!     NO SATISFACTORY XPLS FOUND SUFFICIENTLY DISTINCT FROM X
!
210 iretcd = 1
return
end subroutine lnsrch

subroutine secfac (nr,n,x,g,a,xpls,gpls,itncnt,tol, &
&noupdt,s,y,w)
implicit none
integer, intent(in) :: itncnt, n, nr
real, intent(in) :: tol
integer :: i, im1, j
real :: alp, den1, den2, snorm2, sum, ynrm2
real :: snrm2
real :: sdot
!-----------------------------------------------------------------------
!           UPDATE HESSIAN BY THE BFGS FACTORED METHOD
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       NR        ROW DIMENSION OF MATRIX
!       N         ORDER OF THE MATRIX
!       X(N)      OLD ITERATE X(K-1)
!       G(N)      GRADIENT AT THE OLD ITERATE
!       XPLS(N)   NEW ITERATE X(K)
!       GPLS(N)   GRADIENT AT THE NEW ITERATE
!       ITNCNT    ITERATION COUNT
!       TOL       RELATIVE TOLERANCE TO BE USED FOR NOISE
!
!     INPUT/OUTPUT ...
!
!       A(N,N)    ON ENTRY, CHOLESKY DECOMPOSITION OF HESSIAN IN
!                    THE LOWER PART AND DIAGONAL.
!                 ON EXIT,  UPDATED CHOLESKY DECOMPOSITION OF HESSIAN
!                    IN THE LOWER TRIANGULAR PART AND DIAGONAL.
!       NOUPDT    BOOLEAN. NO UPDATE YET.
!
!     WORK SPACES ...  S(N), Y(N), W(N)
!
!-----------------------------------------------------------------------
real, intent(in) :: x(n), xpls(n), g(n), gpls(n)
real, intent(inout) :: a(nr,n)
real, intent(inout) :: s(n), y(n), w(n)
logical, intent(inout) :: noupdt
!
if (itncnt .eq. 1) noupdt = .true.
do i = 1,n
   s(i) = xpls(i) - x(i)
   y(i) = gpls(i) - g(i)
end do
den1 = sdot(n,s,1,y,1)
snorm2 = snrm2(n,s,1)
ynrm2 = snrm2(n,y,1)
if (den1 .lt. tol*snorm2*ynrm2) return
!
!     SET S = TRANSPOSE(L)*S
!
do i = 1,n
   sum = 0.0
   do j = i,n
      sum = sum + a(j,i)*s(j)
   end do
   s(i) = sum
end do
den2 = sdot(n,s,1,s,1)
!
!     SET ALP = SQRT(DEN1/DEN2)
!
alp = sqrt(den1/den2)
if (.not.noupdt) go to 40
!
!        ON THE INITIAL UPDATE SET L = ALP*L. THEN S MUST BE
!        RESET TO ALP*S. AFTER THIS IS DONE THEN DEN2 = DEN1
!        AND ALP HAS THE VALUE 1.
!
   do j = 1,n
      s(j) = alp*s(j)
      do i = j,n
         a(i,j) = alp*a(i,j)
      end do
   end do
   noupdt = .false.
   alp = 1.0
!
!     SET W = L*S
!
40 do i = 1,n
   sum = 0.0
   do j = 1,i
      sum = sum + a(i,j)*s(j)
   end do
   w(i) = sum
end do
!
!     IF ABS(Y(I) - W(I)) IS LESS THAN THE ESTIMATED NOISE IN Y(I)
!     FOR EACH I, THEN THE UPDATE IS SKIPPED.
!
do i = 1,n
if (abs(y(i) - w(i)) .ge. tol*amax1(abs(g(i)),abs(gpls(i)))) &
&go to 70
end do
return
!
!     W = Y - ALP*L*S
!
70 do i = 1,n
   w(i) = y(i) - alp*w(i)
end do
!
!     S = S/SQRT(DEN1*DEN2)
!
alp = alp/den1
do i = 1,n
   s(i) = alp*s(i)
end do
!
!     COPY L INTO UPPER TRIANGULAR PART.  ZERO L.
!
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(j,i) = a(i,j)
      a(i,j) = 0.0
   end do
end do
!
!     FIND Q AND R SUCH THAT  Q*R = (L+) + S*(W+)
!
call qrupdt (nr, n, a, s, w)
!
!     UPPER TRIANGULAR PART AND DIAGONAL OF A NOW CONTAIN UPDATED
!     CHOLESKY DECOMPOSITION OF HESSIAN.  COPY BACK TO LOWER
!     TRIANGULAR PART.
!
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(i,j) = a(j,i)
   end do
end do
return
end subroutine secfac

subroutine qrupdt (nr,n,a,u,v)
implicit none
integer, intent(in) :: n, nr
integer :: i, ii, j, k, km1
real :: r
!-----------------------------------------------------------------------
!     FIND AN ORTHOGONAL MATRIX (Q*) AND AN UPPER TRIANGULAR
!          MATRIX (R*) SUCH THAT (Q*)(R*) = R + U(V+)
!-----------------------------------------------------------------------
!
!     PARAMETERS ...
!
!       NR      ROW DIMENSION OF THE MATRIX
!       N       ORDER OF THE MATRIX
!       A(N,N)  ON INPUT,  CONTAINS R
!               ON OUTPUT, CONTAINS (R*)
!       U(N)    VECTOR
!       V(N)    VECTOR
!
!-----------------------------------------------------------------------
real, intent(inout) :: a(nr,n), u(n)
real, intent(in) :: v(n)
!
!                DETERMINE LAST NON-ZERO IN U
!
k = n
10 if (u(k) .ne. 0.0 .or. k .eq. 1) go to 20
   k = k - 1
   go to 10
!
!               K-1 JACOBI ROTATIONS TRANSFORM
!             R + U(V+)  TO  (R*) + (U(1)*E1)(V+)
!                 WHICH IS UPPER HESSENBERG
!
20 km1 = k - 1
if (k .le. 1) go to 40
do ii = 1,km1
   i = k - ii
   call jrot (nr,n,a,i,u(i),-u(i+1),r)
   u(i) = r
end do
!
! SET R = R + (U(1)*E1)(V+)
!
40 do j = 1,n
   a(1,j) = a(1,j) + u(1)*v(j)
end do
if (k .le. 1) return
!
!       K-1 JACOBI ROTATIONS TRANSFORM UPPER HESSENBERG R
!                   TO UPPER TRIANGULAR R*
!
do i = 1,km1
   call jrot (nr,n,a,i,a(i,i),-a(i+1,i),r)
end do
return
end subroutine qrupdt

subroutine jrot (nr,n,h,i,a,b,r)
implicit none
integer, intent(in) :: i, n, nr
real, intent(in) :: a, b
real, intent(inout) :: r
integer :: j
real :: c, s, t, z
!-----------------------------------------------------------------------
!         PRE-MULTIPLICATION OF AN UPPER HESSENBERG MATRIX H
!               BY THE JACOBIAN ROTATION J(I,I+1,A,B)
!-----------------------------------------------------------------------
!
!     INPUT ...
!
!       NR      ROW DIMENSION OF THE MATRIX
!       N       ORDER OF THE MATRIX
!       H(N,N)  UPPER HESSENBER MATRIX
!       I       INDEX OF ROW
!       A,B     SCALARS
!
!     OUTPUT ...
!
!       H(N,N)  THE MODIFIED HESSENBERG MATRIX
!       R       R = SQRT(A*A + B*B)
!
!-----------------------------------------------------------------------
real, intent(inout) :: h(nr,n)
!
!                COMPUTE C = A/R  AND S = B/R
!
if (abs(a) .le. abs(b)) go to 10
   t = b/a
   z = sqrt(1.0 + t*t)
   c = sign(1.0/z, a)
   s = t*c
   r = z*abs(a)
   go to 20
10 if (a .eq. 0.0) go to 40
t = a/b
z = sqrt(1.0 + t*t)
s = sign(1.0/z, b)
c = t*s
r = z*abs(b)
!
!            APPLY THE ROTATION WHEN A IS NONZERO
!
20 do j = i,n
   t = h(i,j)
   z = h(i+1,j)
   h(i,j) = c*t - s*z
   h(i+1,j) = s*t + c*z
end do
return
!
!                     CASE WHEN A = 0
!
40 s = sign(1.0, b)
r = abs(b)
do j = i,n
   t = h(i,j)
   h(i,j) = - s*h(i+1,j)
   h(i+1,j) = s*t
end do
return
end subroutine jrot

subroutine lmdiff (fcn,m,n,x,fvec,epsfcn,tol,info,iwa,wa,lwa)
implicit none
integer :: m, n
integer, intent(out) :: info
integer, intent(in) :: lwa
integer, intent(inout) :: iwa(n)
real, intent(in) :: epsfcn, tol
real, intent(inout) :: x(n), fvec(m), wa(lwa)
external fcn
!     **********
!
!     SUBROUTINE LMDIFF
!
!     THE PURPOSE OF LMDIFF IS TO MINIMIZE THE SUM OF THE SQUARES OF
!     M NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION OF THE
!     LEVENBERG-MARQUARDT ALGORITHM. THIS IS DONE BY USING THE MORE
!     GENERAL LEAST-SQUARES SOLVER LMDIF. THE USER MUST PROVIDE A
!     SUBROUTINE WHICH CALCULATES THE FUNCTIONS. THE JACOBIAN IS
!     THEN CALCULATED BY A FORWARD-DIFFERENCE APPROXIMATION.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE LMDIFF(FCN,M,N,X,FVEC,EPSFCN,TOL,INFO,IWA,WA,LWA)
!
!     WHERE
!
!       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
!         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
!         IN AN EXTERNAL STATEMENT IN THE USER CALLING
!         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
!
!         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
!         INTEGER M,N,IFLAG
!         REAL X(N),FVEC(M)
!         ----------
!         CALCULATE THE FUNCTIONS AT X AND
!         RETURN THIS VECTOR IN FVEC.
!         ----------
!         RETURN
!         END
!
!         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
!         THE USER WANTS TO TERMINATE EXECUTION OF LMDIFF.
!         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF FUNCTIONS.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF VARIABLES. N MUST NOT EXCEED M.
!
!       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
!         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
!         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
!
!       FVEC IS AN OUTPUT ARRAY OF LENGTH M WHICH CONTAINS
!         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
!
!       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
!         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
!         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
!         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
!         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
!         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
!         PRECISION.
!
!       TOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION OCCURS
!         WHEN THE ALGORITHM ESTIMATES EITHER THAT THE RELATIVE
!         ERROR IN THE SUM OF SQUARES IS AT MOST TOL OR THAT
!         THE RELATIVE ERROR BETWEEN X AND THE SOLUTION IS AT
!         MOST TOL.
!
!       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
!         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
!         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
!         INFO IS SET AS FOLLOWS.
!
!         INFO = 0  IMPROPER INPUT PARAMETERS.
!
!         INFO = 1  ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
!                   IN THE SUM OF SQUARES IS AT MOST TOL.
!
!         INFO = 2  ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
!                   BETWEEN X AND THE SOLUTION IS AT MOST TOL.
!
!         INFO = 3  CONDITIONS FOR INFO = 1 AND INFO = 2 BOTH HOLD.
!
!         INFO = 4  FVEC IS ORTHOGONAL TO THE COLUMNS OF THE
!                   JACOBIAN TO MACHINE PRECISION.
!
!         INFO = 5  NUMBER OF CALLS TO FCN HAS REACHED OR
!                   EXCEEDED 200*(N+1).
!
!         INFO = 6  TOL IS TOO SMALL. NO FURTHER REDUCTION IN
!                   THE SUM OF SQUARES IS POSSIBLE.
!
!         INFO = 7  TOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
!                   THE APPROXIMATE SOLUTION X IS POSSIBLE.
!
!       IWA IS AN INTEGER WORK ARRAY OF LENGTH N.
!
!       WA IS A WORK ARRAY OF LENGTH LWA.
!
!       LWA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
!         M*N+5*N+M.
!
!     SUBPROGRAMS CALLED
!
!       USER-SUPPLIED ...... FCN
!
!       MINPACK-SUPPLIED ... LMDIF
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: maxfev, mode, mp5n, nfev, nprint
real :: factor, ftol, gtol, xtol
data factor /1.0e2/
info = 0
!
!     CHECK THE INPUT PARAMETERS FOR ERRORS.
!
if (n .le. 0 .or. m .lt. n .or. epsfcn .lt. 0.0 &
&.or. tol .lt. 0.0 .or. lwa .lt. m*n + 5*n + m) go to 10
!
!     CALL LMDIF.
!
maxfev = 200*(n + 1)
ftol = tol
xtol = tol
gtol = 0.0
mode = 1
nprint = 0
mp5n = m + 5*n
call lmdif(fcn,m,n,x,fvec,ftol,xtol,gtol,maxfev,epsfcn,wa(1), &
&mode,factor,nprint,info,nfev,wa(mp5n+1),m,iwa, &
&wa(n+1),wa(2*n+1),wa(3*n+1),wa(4*n+1),wa(5*n+1))
if (info .eq. 8) info = 4
10 continue
return
end subroutine lmdiff

subroutine lmdif(fcn,m,n,x,fvec,ftol,xtol,gtol,maxfev,epsfcn, &
&diag,mode,factor,nprint,info,nfev,fjac,ldfjac, &
&ipvt,qtf,wa1,wa2,wa3,wa4)
implicit none
integer :: m, n
integer, intent(in) :: maxfev, mode, nprint
integer, intent(out) :: info, nfev
integer, intent(in) :: ldfjac
integer, intent(inout) :: ipvt(n)
real, intent(in) :: ftol, xtol, gtol, epsfcn, factor
real, intent(inout) :: x(n), fvec(m), diag(n), fjac(ldfjac,n), &
&qtf(n), wa1(n), wa2(n), wa3(n), wa4(m)
external fcn
!     **********
!
!     SUBROUTINE LMDIF
!
!     THE PURPOSE OF LMDIF IS TO MINIMIZE THE SUM OF THE SQUARES OF
!     M NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION OF
!     THE LEVENBERG-MARQUARDT ALGORITHM. THE USER MUST PROVIDE A
!     SUBROUTINE WHICH CALCULATES THE FUNCTIONS. THE JACOBIAN IS
!     THEN CALCULATED BY A FORWARD-DIFFERENCE APPROXIMATION.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE LMDIF(FCN,M,N,X,FVEC,FTOL,XTOL,GTOL,MAXFEV,EPSFCN,
!                        DIAG,MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,
!                        LDFJAC,IPVT,QTF,WA1,WA2,WA3,WA4)
!
!     WHERE
!
!       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
!         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
!         IN AN EXTERNAL STATEMENT IN THE USER CALLING
!         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
!
!         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
!         INTEGER M,N,IFLAG
!         REAL X(N),FVEC(M)
!         ----------
!         CALCULATE THE FUNCTIONS AT X AND
!         RETURN THIS VECTOR IN FVEC.
!         ----------
!         RETURN
!         END
!
!         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
!         THE USER WANTS TO TERMINATE EXECUTION OF LMDIF.
!         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF FUNCTIONS.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF VARIABLES. N MUST NOT EXCEED M.
!
!       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
!         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
!         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
!
!       FVEC IS AN OUTPUT ARRAY OF LENGTH M WHICH CONTAINS
!         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
!
!       FTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
!         OCCURS WHEN BOTH THE ACTUAL AND PREDICTED RELATIVE
!         REDUCTIONS IN THE SUM OF SQUARES ARE AT MOST FTOL.
!         THEREFORE, FTOL MEASURES THE RELATIVE ERROR DESIRED
!         IN THE SUM OF SQUARES.
!
!       XTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
!         OCCURS WHEN THE RELATIVE ERROR BETWEEN TWO CONSECUTIVE
!         ITERATES IS AT MOST XTOL. THEREFORE, XTOL MEASURES THE
!         RELATIVE ERROR DESIRED IN THE APPROXIMATE SOLUTION.
!
!       GTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
!         OCCURS WHEN THE COSINE OF THE ANGLE BETWEEN FVEC AND
!         ANY COLUMN OF THE JACOBIAN IS AT MOST GTOL IN ABSOLUTE
!         VALUE. THEREFORE, GTOL MEASURES THE ORTHOGONALITY
!         DESIRED BETWEEN THE FUNCTION VECTOR AND THE COLUMNS
!         OF THE JACOBIAN.
!
!       MAXFEV IS A POSITIVE INTEGER INPUT VARIABLE. TERMINATION
!         OCCURS WHEN THE NUMBER OF CALLS TO FCN IS AT LEAST
!         MAXFEV BY THE END OF AN ITERATION.
!
!       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
!         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
!         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
!         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
!         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
!         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
!         PRECISION.
!
!       DIAG IS AN ARRAY OF LENGTH N. IF MODE = 1 (SEE
!         BELOW), DIAG IS INTERNALLY SET. IF MODE = 2, DIAG
!         MUST CONTAIN POSITIVE ENTRIES THAT SERVE AS
!         MULTIPLICATIVE SCALE FACTORS FOR THE VARIABLES.
!
!       MODE IS AN INTEGER INPUT VARIABLE. IF MODE = 1, THE
!         VARIABLES WILL BE SCALED INTERNALLY. IF MODE = 2,
!         THE SCALING IS SPECIFIED BY THE INPUT DIAG. OTHER
!         VALUES OF MODE ARE EQUIVALENT TO MODE = 1.
!
!       FACTOR IS A POSITIVE INPUT VARIABLE USED IN DETERMINING THE
!         INITIAL STEP BOUND. THIS BOUND IS SET TO THE PRODUCT OF
!         FACTOR AND THE EUCLIDEAN NORM OF DIAG*X IF NONZERO, OR ELSE
!         TO FACTOR ITSELF. IN MOST CASES FACTOR SHOULD LIE IN THE
!         INTERVAL (.1,100.). 100. IS A GENERALLY RECOMMENDED VALUE.
!
!       NPRINT IS AN INTEGER INPUT VARIABLE THAT ENABLES CONTROLLED
!         PRINTING OF ITERATES IF IT IS POSITIVE. IN THIS CASE,
!         FCN IS CALLED WITH IFLAG = 0 AT THE BEGINNING OF THE FIRST
!         ITERATION AND EVERY NPRINT ITERATIONS THEREAFTER AND
!         IMMEDIATELY PRIOR TO RETURN, WITH X AND FVEC AVAILABLE
!         FOR PRINTING. IF NPRINT IS NOT POSITIVE, NO SPECIAL CALLS
!         OF FCN WITH IFLAG = 0 ARE MADE.
!
!       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
!         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
!         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
!         INFO IS SET AS FOLLOWS.
!
!         INFO = 0  IMPROPER INPUT PARAMETERS.
!
!         INFO = 1  BOTH ACTUAL AND PREDICTED RELATIVE REDUCTIONS
!                   IN THE SUM OF SQUARES ARE AT MOST FTOL.
!
!         INFO = 2  RELATIVE ERROR BETWEEN TWO CONSECUTIVE ITERATES
!                   IS AT MOST XTOL.
!
!         INFO = 3  CONDITIONS FOR INFO = 1 AND INFO = 2 BOTH HOLD.
!
!         INFO = 4  THE COSINE OF THE ANGLE BETWEEN FVEC AND ANY
!                   COLUMN OF THE JACOBIAN IS AT MOST GTOL IN
!                   ABSOLUTE VALUE.
!
!         INFO = 5  NUMBER OF CALLS TO FCN HAS REACHED OR
!                   EXCEEDED MAXFEV.
!
!         INFO = 6  FTOL IS TOO SMALL. NO FURTHER REDUCTION IN
!                   THE SUM OF SQUARES IS POSSIBLE.
!
!         INFO = 7  XTOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
!                   THE APPROXIMATE SOLUTION X IS POSSIBLE.
!
!         INFO = 8  GTOL IS TOO SMALL. FVEC IS ORTHOGONAL TO THE
!                   COLUMNS OF THE JACOBIAN TO MACHINE PRECISION.
!
!       NFEV IS AN INTEGER OUTPUT VARIABLE SET TO THE NUMBER OF
!         CALLS TO FCN.
!
!       FJAC IS AN OUTPUT M BY N ARRAY. THE UPPER N BY N SUBMATRIX
!         OF FJAC CONTAINS AN UPPER TRIANGULAR MATRIX R WITH
!         DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE SUCH THAT
!
!                T     T           T
!               P *(JAC *JAC)*P = R *R,
!
!         WHERE P IS A PERMUTATION MATRIX AND JAC IS THE FINAL
!         CALCULATED JACOBIAN. COLUMN J OF P IS COLUMN IPVT(J)
!         (SEE BELOW) OF THE IDENTITY MATRIX. THE LOWER TRAPEZOIDAL
!         PART OF FJAC CONTAINS INFORMATION GENERATED DURING
!         THE COMPUTATION OF R.
!
!       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
!
!       IPVT IS AN INTEGER OUTPUT ARRAY OF LENGTH N. IPVT
!         DEFINES A PERMUTATION MATRIX P SUCH THAT JAC*P = Q*R,
!         WHERE JAC IS THE FINAL CALCULATED JACOBIAN, Q IS
!         ORTHOGONAL (NOT STORED), AND R IS UPPER TRIANGULAR
!         WITH DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE.
!         COLUMN J OF P IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
!
!       QTF IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
!         THE FIRST N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*FVEC.
!
!       WA1, WA2, AND WA3 ARE WORK ARRAYS OF LENGTH N.
!
!       WA4 IS A WORK ARRAY OF LENGTH M.
!
!     SUBPROGRAMS CALLED
!
!       USER-SUPPLIED ...... FCN
!
!       MINPACK-SUPPLIED ... SPMPAR,ENORM,FDJAC2,LMPAR,QRFAC
!
!       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,SQRT,MOD
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, iflag, iter, j, l
real :: actred, delta, dirder, eps, fnorm, fnorm1, gnorm, par, &
&pnorm, prered, p1, p5, p25, p75, p0001, ratio, sum, temp, temp1, &
&temp2, xnorm
real :: spmpar, enorm
data p1,p5,p25,p75,p0001 &
&/1.0e-1,5.0e-1,2.5e-1,7.5e-1,1.0e-4/
!
!     EPS IS THE MACHINE PRECISION.
!
eps = spmpar(1)
!
info = 0
iflag = 0
nfev = 0
!
!     CHECK THE INPUT PARAMETERS FOR ERRORS.
!
if (n .le. 0 .or. m .lt. n .or. ldfjac .lt. m &
&.or. ftol .lt. 0.0 .or. xtol .lt. 0.0 .or. gtol .lt. 0.0 &
&.or. maxfev .le. 0 .or. factor .le. 0.0) go to 300
if (mode .ne. 2) go to 20
do j = 1, n
   if (diag(j) .le. 0.0) go to 300
   end do
20 continue
!
!     EVALUATE THE FUNCTION AT THE STARTING POINT
!     AND CALCULATE ITS NORM.
!
iflag = 1
call fcn(m,n,x,fvec,iflag)
nfev = 1
if (iflag .lt. 0) go to 300
fnorm = enorm(m,fvec)
!
!     INITIALIZE LEVENBERG-MARQUARDT PARAMETER AND ITERATION COUNTER.
!
par = 0.0
iter = 1
!
!     BEGINNING OF THE OUTER LOOP.
!
30 continue
!
!        CALCULATE THE JACOBIAN MATRIX.
!
   iflag = 2
   call fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa4)
   nfev = nfev + n
   if (iflag .lt. 0) go to 300
!
!        IF REQUESTED, CALL FCN TO ENABLE PRINTING OF ITERATES.
!
   if (nprint .le. 0) go to 40
   iflag = 0
   if (mod(iter-1,nprint) .eq. 0) call fcn(m,n,x,fvec,iflag)
   if (iflag .lt. 0) go to 300
40 continue
!
!        COMPUTE THE QR FACTORIZATION OF THE JACOBIAN.
!
   call qrfac(m,n,fjac,ldfjac,.true.,ipvt,n,wa1,wa2,wa3)
!
!        ON THE FIRST ITERATION AND IF MODE IS 1, SCALE ACCORDING
!        TO THE NORMS OF THE COLUMNS OF THE INITIAL JACOBIAN.
!
   if (iter .ne. 1) go to 80
   if (mode .eq. 2) go to 60
   do j = 1, n
      diag(j) = wa2(j)
      if (wa2(j) .eq. 0.0) diag(j) = 1.0
      end do
60 continue
!
!        ON THE FIRST ITERATION, CALCULATE THE NORM OF THE SCALED X
!        AND INITIALIZE THE STEP BOUND DELTA.
!
   do j = 1, n
      wa3(j) = diag(j)*x(j)
      end do
   xnorm = enorm(n,wa3)
   delta = factor*xnorm
   if (delta .eq. 0.0) delta = factor
80 continue
!
!        FORM (Q TRANSPOSE)*FVEC AND STORE THE FIRST N COMPONENTS IN
!        QTF.
!
   do i = 1, m
      wa4(i) = fvec(i)
      end do
   do j = 1, n
      if (fjac(j,j) .eq. 0.0) go to 120
      sum = 0.0
      do i = j, m
         sum = sum + fjac(i,j)*wa4(i)
         end do
      temp = -sum/fjac(j,j)
      do i = j, m
         wa4(i) = wa4(i) + fjac(i,j)*temp
         end do
120 continue
      fjac(j,j) = wa1(j)
      qtf(j) = wa4(j)
      end do
!
!        COMPUTE THE NORM OF THE SCALED GRADIENT.
!
   gnorm = 0.0
   if (fnorm .eq. 0.0) go to 170
   do j = 1, n
      l = ipvt(j)
      if (wa2(l) .eq. 0.0) go to 150
      sum = 0.0
      do i = 1, j
         sum = sum + fjac(i,j)*(qtf(i)/fnorm)
         end do
      gnorm = amax1(gnorm,abs(sum/wa2(l)))
150 continue
      end do
170 continue
!
!        TEST FOR CONVERGENCE OF THE GRADIENT NORM.
!
   if (gnorm .le. gtol) info = 4
   if (info .ne. 0) go to 300
!
!        RESCALE IF NECESSARY.
!
   if (mode .eq. 2) go to 190
   do j = 1, n
      diag(j) = amax1(diag(j),wa2(j))
      end do
190 continue
!
!        BEGINNING OF THE INNER LOOP.
!
200 continue
!
!           DETERMINE THE LEVENBERG-MARQUARDT PARAMETER.
!
      call lmpar(n,fjac,ldfjac,ipvt,diag,qtf,delta,par,wa1,wa2, &
&wa3,wa4)
!
!           STORE THE DIRECTION P AND X + P. CALCULATE THE NORM OF P.
!
      do j = 1, n
         wa1(j) = -wa1(j)
         wa2(j) = x(j) + wa1(j)
         wa3(j) = diag(j)*wa1(j)
         end do
      pnorm = enorm(n,wa3)
!
!           ON THE FIRST ITERATION, ADJUST THE INITIAL STEP BOUND.
!
      if (iter .eq. 1) delta = amin1(delta,pnorm)
!
!           EVALUATE THE FUNCTION AT X + P AND CALCULATE ITS NORM.
!
      iflag = 1
      call fcn(m,n,wa2,wa4,iflag)
      nfev = nfev + 1
      if (iflag .lt. 0) go to 300
      fnorm1 = enorm(m,wa4)
!
!           COMPUTE THE SCALED ACTUAL REDUCTION.
!
      actred = -1.0
      if (p1*fnorm1 .lt. fnorm) actred = 1.0 - (fnorm1/fnorm)**2
!
!           COMPUTE THE SCALED PREDICTED REDUCTION AND
!           THE SCALED DIRECTIONAL DERIVATIVE.
!
      do j = 1, n
         wa3(j) = 0.0
         l = ipvt(j)
         temp = wa1(l)
         do i = 1, j
            wa3(i) = wa3(i) + fjac(i,j)*temp
            end do
         end do
      temp1 = enorm(n,wa3)/fnorm
      temp2 = (sqrt(par)*pnorm)/fnorm
      prered = temp1**2 + temp2**2/p5
      dirder = -(temp1**2 + temp2**2)
!
!           COMPUTE THE RATIO OF THE ACTUAL TO THE PREDICTED
!           REDUCTION.
!
      ratio = 0.0
      if (prered .ne. 0.0) ratio = actred/prered
!
!           UPDATE THE STEP BOUND.
!
      if (ratio .gt. p25) go to 240
         if (actred .ge. 0.0) temp = p5
         if (actred .lt. 0.0) &
&temp = p5*dirder/(dirder + p5*actred)
         if (p1*fnorm1 .ge. fnorm .or. temp .lt. p1) temp = p1
         delta = temp*amin1(delta,pnorm/p1)
         par = par/temp
         go to 260
240 continue
         if (par .ne. 0.0 .and. ratio .lt. p75) go to 250
         delta = pnorm/p5
         par = p5*par
250 continue
260 continue
!
!           TEST FOR SUCCESSFUL ITERATION.
!
      if (ratio .lt. p0001) go to 290
!
!           SUCCESSFUL ITERATION. UPDATE X, FVEC, AND THEIR NORMS.
!
      do j = 1, n
         x(j) = wa2(j)
         wa2(j) = diag(j)*x(j)
         end do
      do i = 1, m
         fvec(i) = wa4(i)
         end do
      xnorm = enorm(n,wa2)
      fnorm = fnorm1
      iter = iter + 1
290 continue
!
!           TESTS FOR CONVERGENCE.
!
      if (abs(actred) .le. ftol .and. prered .le. ftol &
&.and. p5*ratio .le. 1.0) info = 1
      if (delta .le. xtol*xnorm) info = 2
      if (abs(actred) .le. ftol .and. prered .le. ftol &
&.and. p5*ratio .le. 1.0 .and. info .eq. 2) info = 3
      if (info .ne. 0) go to 300
!
!           TESTS FOR TERMINATION AND STRINGENT TOLERANCES.
!
      if (nfev .ge. maxfev) info = 5
      if (abs(actred) .le. eps .and. prered .le. eps &
&.and. p5*ratio .le. 1.0) info = 6
      if (delta .le. eps*xnorm) info = 7
      if (gnorm .le. eps) info = 8
      if (info .ne. 0) go to 300
!
!           END OF THE INNER LOOP. REPEAT IF ITERATION UNSUCCESSFUL.
!
      if (ratio .lt. p0001) go to 200
!
!        END OF THE OUTER LOOP.
!
   go to 30
300 continue
!
!     TERMINATION, EITHER NORMAL OR USER IMPOSED.
!
if (iflag .lt. 0) info = iflag
iflag = 0
if (nprint .gt. 0) call fcn(m,n,x,fvec,iflag)
return
end subroutine lmdif

real function enorm(n,x)
implicit none
integer, intent(in) :: n
real, intent(in) :: x(n)
!     **********
!
!     FUNCTION ENORM
!
!     GIVEN AN N-VECTOR X, THIS FUNCTION CALCULATES THE
!     EUCLIDEAN NORM OF X.
!
!     THE EUCLIDEAN NORM IS COMPUTED BY ACCUMULATING THE SUM OF
!     SQUARES IN THREE DIFFERENT SUMS. THE SUMS OF SQUARES FOR THE
!     SMALL AND LARGE COMPONENTS ARE SCALED SO THAT NO OVERFLOWS
!     OCCUR. NON-DESTRUCTIVE UNDERFLOWS ARE PERMITTED. UNDERFLOWS
!     AND OVERFLOWS DO NOT OCCUR IN THE COMPUTATION OF THE UNSCALED
!     SUM OF SQUARES FOR THE INTERMEDIATE COMPONENTS.
!     THE DEFINITIONS OF SMALL, INTERMEDIATE AND LARGE COMPONENTS
!     DEPEND ON TWO CONSTANTS, RDWARF AND RGIANT. THE MAIN
!     RESTRICTIONS ON THESE CONSTANTS ARE THAT RDWARF**2 NOT
!     UNDERFLOW AND RGIANT**2 NOT OVERFLOW. THE CONSTANTS
!     GIVEN HERE ARE SUITABLE FOR EVERY KNOWN COMPUTER.
!
!     THE FUNCTION STATEMENT IS
!
!       REAL FUNCTION ENORM(N,X)
!
!     WHERE
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE.
!
!       X IS AN INPUT ARRAY OF LENGTH N.
!
!     SUBPROGRAMS CALLED
!
!       FORTRAN-SUPPLIED ... ABS,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i
real :: agiant, floatn, rdwarf, rgiant, s1, s2, s3, xabs, x1max, &
&x3max
data rdwarf,rgiant /3.834e-20,1.304e19/
!
s1 = 0.0
s2 = 0.0
s3 = 0.0
x1max = 0.0
x3max = 0.0
floatn = n
agiant = rgiant/floatn
do 90 i = 1, n
   xabs = abs(x(i))
   if (xabs .gt. rdwarf .and. xabs .lt. agiant) go to 70
      if (xabs .le. rdwarf) go to 30
!
!              SUM FOR LARGE COMPONENTS.
!
         if (xabs .le. x1max) go to 10
            s1 = 1.0 + s1*(x1max/xabs)**2
            x1max = xabs
            go to 20
10 continue
            s1 = s1 + (xabs/x1max)**2
20 continue
         go to 60
30 continue
!
!              SUM FOR SMALL COMPONENTS.
!
         if (xabs .le. x3max) go to 40
            s3 = 1.0 + s3*(x3max/xabs)**2
            x3max = xabs
            go to 50
40 continue
            if (xabs .ne. 0.0) s3 = s3 + (xabs/x3max)**2
50 continue
60 continue
      go to 80
70 continue
!
!           SUM FOR INTERMEDIATE COMPONENTS.
!
      s2 = s2 + xabs**2
80 continue
90 continue
!
!     CALCULATION OF NORM.
!
if (s1 .eq. 0.0) go to 100
   enorm = x1max*sqrt(s1 + (s2/x1max)/x1max)
   go to 130
100 continue
   if (s2 .eq. 0.0) go to 110
      if (s2 .ge. x3max) &
&enorm = sqrt(s2*(1.0 + (x3max/s2)*(x3max*s3)))
      if (s2 .lt. x3max) &
&enorm = sqrt(x3max*((s2/x3max) + (x3max*s3)))
      go to 120
110 continue
      enorm = x3max*sqrt(s3)
120 continue
130 continue
return
end function enorm

subroutine dogleg(n,r,lr,diag,qtb,delta,x,wa1,wa2)
implicit none
integer, intent(in) :: n, lr
real, intent(in) :: delta
real, intent(in) :: r(lr), diag(n), qtb(n)
real, intent(inout) :: x(n), wa1(n), wa2(n)
!     **********
!
!     SUBROUTINE DOGLEG
!
!     GIVEN AN M BY N MATRIX A, AN N BY N NONSINGULAR DIAGONAL
!     MATRIX D, AN M-VECTOR B, AND A POSITIVE NUMBER DELTA, THE
!     PROBLEM IS TO DETERMINE THE CONVEX COMBINATION X OF THE
!     GAUSS-NEWTON AND SCALED GRADIENT DIRECTIONS THAT MINIMIZES
!     (A*X - B) IN THE LEAST SQUARES SENSE, SUBJECT TO THE
!     RESTRICTION THAT THE EUCLIDEAN NORM OF D*X BE AT MOST DELTA.
!
!     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
!     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
!     QR FACTORIZATION OF A. THAT IS, IF A = Q*R, WHERE Q HAS
!     ORTHOGONAL COLUMNS AND R IS AN UPPER TRIANGULAR MATRIX,
!     THEN DOGLEG EXPECTS THE FULL UPPER TRIANGLE OF R AND
!     THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE DOGLEG(N,R,LR,DIAG,QTB,DELTA,X,WA1,WA2)
!
!     WHERE
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
!
!       R IS AN INPUT ARRAY OF LENGTH LR WHICH MUST CONTAIN THE UPPER
!         TRIANGULAR MATRIX R STORED BY ROWS.
!
!       LR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
!         (N*(N+1))/2.
!
!       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
!         DIAGONAL ELEMENTS OF THE MATRIX D.
!
!       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
!         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
!
!       DELTA IS A POSITIVE INPUT VARIABLE WHICH SPECIFIES AN UPPER
!         BOUND ON THE EUCLIDEAN NORM OF D*X.
!
!       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE DESIRED
!         CONVEX COMBINATION OF THE GAUSS-NEWTON DIRECTION AND THE
!         SCALED GRADIENT DIRECTION.
!
!       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N.
!
!     SUBPROGRAMS CALLED
!
!       MINPACK-SUPPLIED ... SPMPAR,ENORM
!
!       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j, jj, jp1, k, l
real :: alpha, bnorm, epsmch, gnorm, qnorm, sgnorm, sum, temp
real :: spmpar, enorm
!
!     EPSMCH IS THE MACHINE PRECISION.
!
epsmch = spmpar(1)
!
!     FIRST, CALCULATE THE GAUSS-NEWTON DIRECTION.
!
jj = (n*(n + 1))/2 + 1
do k = 1, n
   j = n - k + 1
   jp1 = j + 1
   jj = jj - k
   l = jj + 1
   sum = 0.0
   if (n .lt. jp1) go to 20
   do i = jp1, n
      sum = sum + r(l)*x(i)
      l = l + 1
      end do
20 continue
   temp = r(jj)
   if (temp .ne. 0.0) go to 40
   l = j
   do i = 1, j
      temp = amax1(temp,abs(r(l)))
      l = l + n - i
      end do
   temp = epsmch*temp
   if (temp .eq. 0.0) temp = epsmch
40 continue
   x(j) = (qtb(j) - sum)/temp
   end do
!
!     TEST WHETHER THE GAUSS-NEWTON DIRECTION IS ACCEPTABLE.
!
do j = 1, n
   wa1(j) = 0.0
   wa2(j) = diag(j)*x(j)
   end do
qnorm = enorm(n,wa2)
if (qnorm .le. delta) go to 140
!
!     THE GAUSS-NEWTON DIRECTION IS NOT ACCEPTABLE.
!     NEXT, CALCULATE THE SCALED GRADIENT DIRECTION.
!
l = 1
do j = 1, n
   temp = qtb(j)
   do i = j, n
      wa1(i) = wa1(i) + r(l)*temp
      l = l + 1
      end do
   wa1(j) = wa1(j)/diag(j)
   end do
!
!     CALCULATE THE NORM OF THE SCALED GRADIENT AND TEST FOR
!     THE SPECIAL CASE IN WHICH THE SCALED GRADIENT IS ZERO.
!
gnorm = enorm(n,wa1)
sgnorm = 0.0
alpha = delta/qnorm
if (gnorm .eq. 0.0) go to 120
!
!     CALCULATE THE POINT ALONG THE SCALED GRADIENT
!     AT WHICH THE QUADRATIC IS MINIMIZED.
!
do j = 1, n
   wa1(j) = (wa1(j)/gnorm)/diag(j)
   end do
l = 1
do j = 1, n
   sum = 0.0
   do i = j, n
      sum = sum + r(l)*wa1(i)
      l = l + 1
      end do
   wa2(j) = sum
   end do
temp = enorm(n,wa2)
sgnorm = (gnorm/temp)/temp
!
!     TEST WHETHER THE SCALED GRADIENT DIRECTION IS ACCEPTABLE.
!
alpha = 0.0
if (sgnorm .ge. delta) go to 120
!
!     THE SCALED GRADIENT DIRECTION IS NOT ACCEPTABLE.
!     FINALLY, CALCULATE THE POINT ALONG THE DOGLEG
!     AT WHICH THE QUADRATIC IS MINIMIZED.
!
bnorm = enorm(n,qtb)
temp = (bnorm/gnorm)*(bnorm/qnorm)*(sgnorm/delta)
temp = temp - (delta/qnorm)*(sgnorm/delta)**2 &
&+ sqrt((temp-(delta/qnorm))**2 &
&+(1.0-(delta/qnorm)**2)*(1.0-(sgnorm/delta)**2))
alpha = ((delta/qnorm)*(1.0 - (sgnorm/delta)**2))/temp
120 continue
!
!     FORM APPROPRIATE CONVEX COMBINATION OF THE GAUSS-NEWTON
!     DIRECTION AND THE SCALED GRADIENT DIRECTION.
!
temp = (1.0 - alpha)*amin1(sgnorm,delta)
do j = 1, n
   x(j) = temp*wa1(j) + alpha*x(j)
   end do
140 continue
return
end subroutine dogleg

subroutine fdjac1(fcn,n,x,fvec,fjac,ldfjac,iflag,ml,mu,epsfcn, &
&wa1,wa2)
implicit none
integer :: n
integer, intent(in) :: ldfjac
integer :: iflag
integer, intent(in) :: ml, mu
real, intent(in) :: epsfcn
real, intent(inout) :: x(n)
real, intent(in) :: fvec(n)
real, intent(inout) :: fjac(ldfjac,n)
real :: wa1(n)
real, intent(inout) :: wa2(n)
external fcn
!     **********
!
!     SUBROUTINE FDJAC1
!
!     THIS SUBROUTINE COMPUTES A FORWARD-DIFFERENCE APPROXIMATION
!     TO THE N BY N JACOBIAN MATRIX ASSOCIATED WITH A SPECIFIED
!     PROBLEM OF N FUNCTIONS IN N VARIABLES. IF THE JACOBIAN HAS
!     A BANDED FORM, THEN FUNCTION EVALUATIONS ARE SAVED BY ONLY
!     APPROXIMATING THE NONZERO TERMS.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE FDJAC1(FCN,N,X,FVEC,FJAC,LDFJAC,IFLAG,ML,MU,EPSFCN,
!                         WA1,WA2)
!
!     WHERE
!
!       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
!         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
!         IN AN EXTERNAL STATEMENT IN THE USER CALLING
!         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
!
!         SUBROUTINE FCN(N,X,FVEC,IFLAG)
!         INTEGER N,IFLAG
!         REAL X(N),FVEC(N)
!         ----------
!         CALCULATE THE FUNCTIONS AT X AND
!         RETURN THIS VECTOR IN FVEC.
!         ----------
!         RETURN
!         END
!
!         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
!         THE USER WANTS TO TERMINATE EXECUTION OF FDJAC1.
!         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF FUNCTIONS AND VARIABLES.
!
!       X IS AN INPUT ARRAY OF LENGTH N.
!
!       FVEC IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
!         FUNCTIONS EVALUATED AT X.
!
!       FJAC IS AN OUTPUT N BY N ARRAY WHICH CONTAINS THE
!         APPROXIMATION TO THE JACOBIAN MATRIX EVALUATED AT X.
!
!       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
!
!       IFLAG IS AN INTEGER VARIABLE WHICH CAN BE USED TO TERMINATE
!         THE EXECUTION OF FDJAC1. SEE DESCRIPTION OF FCN.
!
!       ML IS A NONNEGATIVE INTEGER INPUT VARIABLE WHICH SPECIFIES
!         THE NUMBER OF SUBDIAGONALS WITHIN THE BAND OF THE
!         JACOBIAN MATRIX. IF THE JACOBIAN IS NOT BANDED, SET
!         ML TO AT LEAST N - 1.
!
!       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
!         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
!         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
!         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
!         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
!         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
!         PRECISION.
!
!       MU IS A NONNEGATIVE INTEGER INPUT VARIABLE WHICH SPECIFIES
!         THE NUMBER OF SUPERDIAGONALS WITHIN THE BAND OF THE
!         JACOBIAN MATRIX. IF THE JACOBIAN IS NOT BANDED, SET
!         MU TO AT LEAST N - 1.
!
!       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N. IF ML + MU + 1 IS AT
!         LEAST N, THEN THE JACOBIAN IS CONSIDERED DENSE, AND WA2 IS
!         NOT REFERENCED.
!
!     SUBPROGRAMS CALLED
!
!       MINPACK-SUPPLIED ... SPMPAR
!
!       FORTRAN-SUPPLIED ... ABS,AMAX1,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j, k, msum
real :: eps, epsmch, h, temp, zero
real :: spmpar
data zero /0.0e0/
!
!     EPSMCH IS THE MACHINE PRECISION.
!
epsmch = spmpar(1)
!
eps = sqrt(amax1(epsfcn,epsmch))
msum = ml + mu + 1
if (msum .lt. n) go to 40
!
!        COMPUTATION OF DENSE APPROXIMATE JACOBIAN.
!
   do j = 1, n
      temp = x(j)
      h = eps*abs(temp)
      if (h .eq. zero) h = eps
      x(j) = temp + h
      call fcn(n,x,wa1,iflag)
      if (iflag .lt. 0) go to 30
      x(j) = temp
      do i = 1, n
         fjac(i,j) = (wa1(i) - fvec(i))/h
         end do
      end do
30 continue
   go to 110
40 continue
!
!        COMPUTATION OF BANDED APPROXIMATE JACOBIAN.
!
   do k = 1, msum
      do j = k, n, msum
         wa2(j) = x(j)
         h = eps*abs(wa2(j))
         if (h .eq. zero) h = eps
         x(j) = wa2(j) + h
         end do
      call fcn(n,x,wa1,iflag)
      if (iflag .lt. 0) go to 100
      do j = k, n, msum
         x(j) = wa2(j)
         h = eps*abs(wa2(j))
         if (h .eq. zero) h = eps
         do i = 1, n
            fjac(i,j) = zero
            if (i .ge. j - mu .and. i .le. j + ml) &
&fjac(i,j) = (wa1(i) - fvec(i))/h
            end do
         end do
      end do
100 continue
110 continue
return
!
!     LAST CARD OF SUBROUTINE FDJAC1.
!
end subroutine fdjac1

subroutine fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa)
implicit none
integer :: m, n
integer, intent(in) :: ldfjac
integer :: iflag
real, intent(in) :: epsfcn
real, intent(inout) :: x(n)
real, intent(in) :: fvec(m)
real, intent(inout) :: fjac(ldfjac,n)
real :: wa(m)
external fcn
!     **********
!
!     SUBROUTINE FDJAC2
!
!     THIS SUBROUTINE COMPUTES A FORWARD-DIFFERENCE APPROXIMATION
!     TO THE M BY N JACOBIAN MATRIX ASSOCIATED WITH A SPECIFIED
!     PROBLEM OF M FUNCTIONS IN N VARIABLES.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA)
!
!     WHERE
!
!       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
!         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
!         IN AN EXTERNAL STATEMENT IN THE USER CALLING
!         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
!
!         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
!         INTEGER M,N,IFLAG
!         REAL X(N),FVEC(M)
!         ----------
!         CALCULATE THE FUNCTIONS AT X AND
!         RETURN THIS VECTOR IN FVEC.
!         ----------
!         RETURN
!         END
!
!         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
!         THE USER WANTS TO TERMINATE EXECUTION OF FDJAC2.
!         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF FUNCTIONS.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF VARIABLES. N MUST NOT EXCEED M.
!
!       X IS AN INPUT ARRAY OF LENGTH N.
!
!       FVEC IS AN INPUT ARRAY OF LENGTH M WHICH MUST CONTAIN THE
!         FUNCTIONS EVALUATED AT X.
!
!       FJAC IS AN OUTPUT M BY N ARRAY WHICH CONTAINS THE
!         APPROXIMATION TO THE JACOBIAN MATRIX EVALUATED AT X.
!
!       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
!
!       IFLAG IS AN INTEGER VARIABLE WHICH CAN BE USED TO TERMINATE
!         THE EXECUTION OF FDJAC2. SEE DESCRIPTION OF FCN.
!
!       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
!         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
!         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
!         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
!         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
!         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
!         PRECISION.
!
!       WA IS A WORK ARRAY OF LENGTH M.
!
!     SUBPROGRAMS CALLED
!
!       USER-SUPPLIED ...... FCN
!
!       MINPACK-SUPPLIED ... SPMPAR
!
!       FORTRAN-SUPPLIED ... ABS,AMAX1,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j
real :: eps, epsmch, h, temp, zero
real :: spmpar
data zero /0.0e0/
!
!     EPSMCH IS THE MACHINE PRECISION.
!
epsmch = spmpar(1)
!
eps = sqrt(amax1(epsfcn,epsmch))
do j = 1, n
   temp = x(j)
   h = eps*abs(temp)
   if (h .eq. zero) h = eps
   x(j) = temp + h
   call fcn(m,n,x,wa,iflag)
   if (iflag .lt. 0) go to 30
   x(j) = temp
   do i = 1, m
      fjac(i,j) = (wa(i) - fvec(i))/h
      end do
   end do
30 continue
return
!
!     LAST CARD OF SUBROUTINE FDJAC2.
!
end subroutine fdjac2

subroutine lmpar(n,r,ldr,ipvt,diag,qtb,delta,par,x,sdiag,wa1, &
&wa2)
implicit none
integer, intent(in) :: n, ldr
integer, intent(in) :: ipvt(n)
real, intent(in) :: delta
real, intent(inout) :: par
real, intent(inout) :: r(ldr,n)
real, intent(in) :: diag(n), qtb(n)
real, intent(inout) :: x(n), sdiag(n), wa1(n), wa2(n)
!     **********
!
!     SUBROUTINE LMPAR
!
!     GIVEN AN M BY N MATRIX A, AN N BY N NONSINGULAR DIAGONAL
!     MATRIX D, AN M-VECTOR B, AND A POSITIVE NUMBER DELTA,
!     THE PROBLEM IS TO DETERMINE A VALUE FOR THE PARAMETER
!     PAR SUCH THAT IF X SOLVES THE SYSTEM
!
!           A*X = B ,     SQRT(PAR)*D*X = 0 ,
!
!     IN THE LEAST SQUARES SENSE, AND DXNORM IS THE EUCLIDEAN
!     NORM OF D*X, THEN EITHER PAR IS ZERO AND
!
!           (DXNORM-DELTA) .LE. 0.1*DELTA ,
!
!     OR PAR IS POSITIVE AND
!
!           ABS(DXNORM-DELTA) .LE. 0.1*DELTA .
!
!     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
!     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
!     QR FACTORIZATION, WITH COLUMN PIVOTING, OF A. THAT IS, IF
!     A*P = Q*R, WHERE P IS A PERMUTATION MATRIX, Q HAS ORTHOGONAL
!     COLUMNS, AND R IS AN UPPER TRIANGULAR MATRIX WITH DIAGONAL
!     ELEMENTS OF NONINCREASING MAGNITUDE, THEN LMPAR EXPECTS
!     THE FULL UPPER TRIANGLE OF R, THE PERMUTATION MATRIX P,
!     AND THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B. ON OUTPUT
!     LMPAR ALSO PROVIDES AN UPPER TRIANGULAR MATRIX S SUCH THAT
!
!            T   T                   T
!           P *(A *A + PAR*D*D)*P = S *S .
!
!     S IS EMPLOYED WITHIN LMPAR AND MAY BE OF SEPARATE INTEREST.
!
!     ONLY A FEW ITERATIONS ARE GENERALLY NEEDED FOR CONVERGENCE
!     OF THE ALGORITHM. IF, HOWEVER, THE LIMIT OF 10 ITERATIONS
!     IS REACHED, THEN THE OUTPUT PAR WILL CONTAIN THE BEST
!     VALUE OBTAINED SO FAR.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE LMPAR(N,R,LDR,IPVT,DIAG,QTB,DELTA,PAR,X,SDIAG,
!                        WA1,WA2)
!
!     WHERE
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
!
!       R IS AN N BY N ARRAY. ON INPUT THE FULL UPPER TRIANGLE
!         MUST CONTAIN THE FULL UPPER TRIANGLE OF THE MATRIX R.
!         ON OUTPUT THE FULL UPPER TRIANGLE IS UNALTERED, AND THE
!         STRICT LOWER TRIANGLE CONTAINS THE STRICT UPPER TRIANGLE
!         (TRANSPOSED) OF THE UPPER TRIANGULAR MATRIX S.
!
!       LDR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY R.
!
!       IPVT IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH DEFINES THE
!         PERMUTATION MATRIX P SUCH THAT A*P = Q*R. COLUMN J OF P
!         IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
!
!       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
!         DIAGONAL ELEMENTS OF THE MATRIX D.
!
!       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
!         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
!
!       DELTA IS A POSITIVE INPUT VARIABLE WHICH SPECIFIES AN UPPER
!         BOUND ON THE EUCLIDEAN NORM OF D*X.
!
!       PAR IS A NONNEGATIVE VARIABLE. ON INPUT PAR CONTAINS AN
!         INITIAL ESTIMATE OF THE LEVENBERG-MARQUARDT PARAMETER.
!         ON OUTPUT PAR CONTAINS THE FINAL ESTIMATE.
!
!       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE LEAST
!         SQUARES SOLUTION OF THE SYSTEM A*X = B, SQRT(PAR)*D*X = 0,
!         FOR THE OUTPUT PAR.
!
!       SDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
!         DIAGONAL ELEMENTS OF THE UPPER TRIANGULAR MATRIX S.
!
!       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N.
!
!     SUBPROGRAMS CALLED
!
!       MINPACK-SUPPLIED ... SPMPAR,ENORM,QRSOLV
!
!       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, iter, j, jm1, jp1, k, l, nsing
real :: dxnorm, dwarf, fp, gnorm, parc, parl, paru, p1, p001, sum, &
&temp, zero
real :: spmpar, enorm
data p1,p001,zero /1.0e-1,1.0e-3,0.0e0/
!
!     DWARF IS THE SMALLEST POSITIVE MAGNITUDE.
!
dwarf = spmpar(2)
!
!     COMPUTE AND STORE IN X THE GAUSS-NEWTON DIRECTION. IF THE
!     JACOBIAN IS RANK-DEFICIENT, OBTAIN A LEAST SQUARES SOLUTION.
!
nsing = n
do 10 j = 1, n
   wa1(j) = qtb(j)
   if (r(j,j) .eq. zero .and. nsing .eq. n) nsing = j - 1
   if (nsing .lt. n) wa1(j) = zero
10 continue
if (nsing .lt. 1) go to 50
do k = 1, nsing
   j = nsing - k + 1
   wa1(j) = wa1(j)/r(j,j)
   temp = wa1(j)
   jm1 = j - 1
   if (jm1 .lt. 1) go to 30
   do i = 1, jm1
      wa1(i) = wa1(i) - r(i,j)*temp
      end do
30 continue
   end do
50 continue
do j = 1, n
   l = ipvt(j)
   x(l) = wa1(j)
   end do
!
!     INITIALIZE THE ITERATION COUNTER.
!     EVALUATE THE FUNCTION AT THE ORIGIN, AND TEST
!     FOR ACCEPTANCE OF THE GAUSS-NEWTON DIRECTION.
!
iter = 0
do j = 1, n
   wa2(j) = diag(j)*x(j)
   end do
dxnorm = enorm(n,wa2)
fp = dxnorm - delta
if (fp .le. p1*delta) go to 220
!
!     IF THE JACOBIAN IS NOT RANK DEFICIENT, THE NEWTON
!     STEP PROVIDES A LOWER BOUND, PARL, FOR THE ZERO OF
!     THE FUNCTION. OTHERWISE SET THIS BOUND TO ZERO.
!
parl = zero
if (nsing .lt. n) go to 120
do j = 1, n
   l = ipvt(j)
   wa1(j) = diag(l)*(wa2(l)/dxnorm)
   end do
do j = 1, n
   sum = zero
   jm1 = j - 1
   if (jm1 .lt. 1) go to 100
   do i = 1, jm1
      sum = sum + r(i,j)*wa1(i)
      end do
100 continue
   wa1(j) = (wa1(j) - sum)/r(j,j)
   end do
temp = enorm(n,wa1)
parl = ((fp/delta)/temp)/temp
120 continue
!
!     CALCULATE AN UPPER BOUND, PARU, FOR THE ZERO OF THE FUNCTION.
!
do j = 1, n
   sum = zero
   do i = 1, j
      sum = sum + r(i,j)*qtb(i)
      end do
   l = ipvt(j)
   wa1(j) = sum/diag(l)
   end do
gnorm = enorm(n,wa1)
paru = gnorm/delta
if (paru .eq. zero) paru = dwarf/amin1(delta,p1)
!
!     IF THE INPUT PAR LIES OUTSIDE OF THE INTERVAL (PARL,PARU),
!     SET PAR TO THE CLOSER ENDPOINT.
!
par = amax1(par,parl)
par = amin1(par,paru)
if (par .eq. zero) par = gnorm/dxnorm
!
!     BEGINNING OF AN ITERATION.
!
150 continue
   iter = iter + 1
!
!        EVALUATE THE FUNCTION AT THE CURRENT VALUE OF PAR.
!
   if (par .eq. zero) par = amax1(dwarf,p001*paru)
   temp = sqrt(par)
   do j = 1, n
      wa1(j) = temp*diag(j)
      end do
   call qrsolv(n,r,ldr,ipvt,wa1,qtb,x,sdiag,wa2)
   do j = 1, n
      wa2(j) = diag(j)*x(j)
      end do
   dxnorm = enorm(n,wa2)
   temp = fp
   fp = dxnorm - delta
!
!        IF THE FUNCTION IS SMALL ENOUGH, ACCEPT THE CURRENT VALUE
!        OF PAR. ALSO TEST FOR THE EXCEPTIONAL CASES WHERE PARL
!        IS ZERO OR THE NUMBER OF ITERATIONS HAS REACHED 10.
!
   if (abs(fp) .le. p1*delta &
&.or. parl .eq. zero .and. fp .le. temp &
&.and. temp .lt. zero .or. iter .eq. 10) go to 220
!
!        COMPUTE THE NEWTON CORRECTION.
!
   do j = 1, n
      l = ipvt(j)
      wa1(j) = diag(l)*(wa2(l)/dxnorm)
      end do
   do j = 1, n
      wa1(j) = wa1(j)/sdiag(j)
      temp = wa1(j)
      jp1 = j + 1
      if (n .lt. jp1) go to 200
      do i = jp1, n
         wa1(i) = wa1(i) - r(i,j)*temp
         end do
200 continue
      end do
   temp = enorm(n,wa1)
   parc = ((fp/delta)/temp)/temp
!
!        DEPENDING ON THE SIGN OF THE FUNCTION, UPDATE PARL OR PARU.
!
   if (fp .gt. zero) parl = amax1(parl,par)
   if (fp .lt. zero) paru = amin1(paru,par)
!
!        COMPUTE AN IMPROVED ESTIMATE FOR PAR.
!
   par = amax1(parl,par+parc)
!
!        END OF AN ITERATION.
!
   go to 150
220 continue
!
!     TERMINATION.
!
if (iter .eq. 0) par = zero
return
!
!     LAST CARD OF SUBROUTINE LMPAR.
!
end subroutine lmpar

subroutine qform(m,n,q,ldq,wa)
implicit none
integer, intent(in) :: m, n, ldq
real, intent(inout) :: q(ldq,m), wa(m)
!     **********
!
!     SUBROUTINE QFORM
!
!     THIS SUBROUTINE PROCEEDS FROM THE COMPUTED QR FACTORIZATION OF
!     AN M BY N MATRIX A TO ACCUMULATE THE M BY M ORTHOGONAL MATRIX
!     Q FROM ITS FACTORED FORM.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE QFORM(M,N,Q,LDQ,WA)
!
!     WHERE
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF ROWS OF A AND THE ORDER OF Q.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF COLUMNS OF A.
!
!       Q IS AN M BY M ARRAY. ON INPUT THE FULL LOWER TRAPEZOID IN
!         THE FIRST MIN(M,N) COLUMNS OF Q CONTAINS THE FACTORED FORM.
!         ON OUTPUT Q HAS BEEN ACCUMULATED INTO A SQUARE MATRIX.
!
!       LDQ IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY Q.
!
!       WA IS A WORK ARRAY OF LENGTH M.
!
!     SUBPROGRAMS CALLED
!
!       FORTRAN-SUPPLIED ... MIN0
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j, jm1, k, l, minmn, np1
real :: one, sum, temp, zero
data one,zero /1.0e0,0.0e0/
!
!     ZERO OUT UPPER TRIANGLE OF Q IN THE FIRST MIN(M,N) COLUMNS.
!
minmn = min0(m,n)
if (minmn .lt. 2) go to 30
do j = 2, minmn
   jm1 = j - 1
   do i = 1, jm1
      q(i,j) = zero
      end do
   end do
30 continue
!
!     INITIALIZE REMAINING COLUMNS TO THOSE OF THE IDENTITY MATRIX.
!
np1 = n + 1
if (m .lt. np1) go to 60
do j = np1, m
   do i = 1, m
      q(i,j) = zero
      end do
   q(j,j) = one
   end do
60 continue
!
!     ACCUMULATE Q FROM ITS FACTORED FORM.
!
do l = 1, minmn
   k = minmn - l + 1
   do i = k, m
      wa(i) = q(i,k)
      q(i,k) = zero
      end do
   q(k,k) = one
   if (wa(k) .eq. zero) go to 110
   do j = k, m
      sum = zero
      do i = k, m
         sum = sum + q(i,j)*wa(i)
         end do
      temp = sum/wa(k)
      do i = k, m
         q(i,j) = q(i,j) - temp*wa(i)
         end do
      end do
110 continue
   end do
return
!
!     LAST CARD OF SUBROUTINE QFORM.
!
end subroutine qform

subroutine qrfac(m,n,a,lda,pivot,ipvt,lipvt,rdiag,acnorm,wa)
implicit none
integer, intent(in) :: m, n, lda, lipvt
integer, intent(inout) :: ipvt(lipvt)
logical, intent(in) :: pivot
real, intent(inout) :: a(lda,n), rdiag(n), acnorm(n), wa(n)
!     **********
!
!     SUBROUTINE QRFAC
!
!     THIS SUBROUTINE USES HOUSEHOLDER TRANSFORMATIONS WITH COLUMN
!     PIVOTING (OPTIONAL) TO COMPUTE A QR FACTORIZATION OF THE
!     M BY N MATRIX A. THAT IS, QRFAC DETERMINES AN ORTHOGONAL
!     MATRIX Q, A PERMUTATION MATRIX P, AND AN UPPER TRAPEZOIDAL
!     MATRIX R WITH DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE,
!     SUCH THAT A*P = Q*R. THE HOUSEHOLDER TRANSFORMATION FOR
!     COLUMN K, K = 1,2,...,MIN(M,N), IS OF THE FORM
!
!                           T
!           I - (1/U(K))*U*U
!
!     WHERE U HAS ZEROS IN THE FIRST K-1 POSITIONS. THE FORM OF
!     THIS TRANSFORMATION AND THE METHOD OF PIVOTING FIRST
!     APPEARED IN THE CORRESPONDING LINPACK SUBROUTINE.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE QRFAC(M,N,A,LDA,PIVOT,IPVT,LIPVT,RDIAG,ACNORM,WA)
!
!     WHERE
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF ROWS OF A.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF COLUMNS OF A.
!
!       A IS AN M BY N ARRAY. ON INPUT A CONTAINS THE MATRIX FOR
!         WHICH THE QR FACTORIZATION IS TO BE COMPUTED. ON OUTPUT
!         THE STRICT UPPER TRAPEZOIDAL PART OF A CONTAINS THE STRICT
!         UPPER TRAPEZOIDAL PART OF R, AND THE LOWER TRAPEZOIDAL
!         PART OF A CONTAINS A FACTORED FORM OF Q (THE NON-TRIVIAL
!         ELEMENTS OF THE U VECTORS DESCRIBED ABOVE).
!
!       LDA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY A.
!
!       PIVOT IS A LOGICAL INPUT VARIABLE. IF PIVOT IS SET TRUE,
!         THEN COLUMN PIVOTING IS ENFORCED. IF PIVOT IS SET FALSE,
!         THEN NO COLUMN PIVOTING IS DONE.
!
!       IPVT IS AN INTEGER OUTPUT ARRAY OF LENGTH LIPVT. IPVT
!         DEFINES THE PERMUTATION MATRIX P SUCH THAT A*P = Q*R.
!         COLUMN J OF P IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
!         IF PIVOT IS FALSE, IPVT IS NOT REFERENCED.
!
!       LIPVT IS A POSITIVE INTEGER INPUT VARIABLE. IF PIVOT IS FALSE,
!         THEN LIPVT MAY BE AS SMALL AS 1. IF PIVOT IS TRUE, THEN
!         LIPVT MUST BE AT LEAST N.
!
!       RDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
!         DIAGONAL ELEMENTS OF R.
!
!       ACNORM IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
!         NORMS OF THE CORRESPONDING COLUMNS OF THE INPUT MATRIX A.
!         IF THIS INFORMATION IS NOT NEEDED, THEN ACNORM CAN COINCIDE
!         WITH RDIAG.
!
!       WA IS A WORK ARRAY OF LENGTH N. IF PIVOT IS FALSE, THEN WA
!         CAN COINCIDE WITH RDIAG.
!
!     SUBPROGRAMS CALLED
!
!       MINPACK-SUPPLIED ... SPMPAR,ENORM
!
!       FORTRAN-SUPPLIED ... AMAX1,SQRT,MIN0
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j, jp1, k, kmax, minmn
real :: ajnorm, epsmch, one, p05, sum, temp, zero
real :: spmpar, enorm
data one,p05,zero /1.0e0,5.0e-2,0.0e0/
!
!     EPSMCH IS THE MACHINE PRECISION.
!
epsmch = spmpar(1)
!
!     COMPUTE THE INITIAL COLUMN NORMS AND INITIALIZE SEVERAL ARRAYS.
!
do j = 1, n
   acnorm(j) = enorm(m,a(1,j))
   rdiag(j) = acnorm(j)
   wa(j) = rdiag(j)
   if (pivot) ipvt(j) = j
   end do
!
!     REDUCE A TO R WITH HOUSEHOLDER TRANSFORMATIONS.
!
minmn = min0(m,n)
do j = 1, minmn
   if (.not.pivot) go to 40
!
!        BRING THE COLUMN OF LARGEST NORM INTO THE PIVOT POSITION.
!
   kmax = j
   do k = j, n
      if (rdiag(k) .gt. rdiag(kmax)) kmax = k
      end do
   if (kmax .eq. j) go to 40
   do i = 1, m
      temp = a(i,j)
      a(i,j) = a(i,kmax)
      a(i,kmax) = temp
      end do
   rdiag(kmax) = rdiag(j)
   wa(kmax) = wa(j)
   k = ipvt(j)
   ipvt(j) = ipvt(kmax)
   ipvt(kmax) = k
40 continue
!
!        COMPUTE THE HOUSEHOLDER TRANSFORMATION TO REDUCE THE
!        J-TH COLUMN OF A TO A MULTIPLE OF THE J-TH UNIT VECTOR.
!
   ajnorm = enorm(m-j+1,a(j,j))
   if (ajnorm .eq. zero) go to 100
   if (a(j,j) .lt. zero) ajnorm = -ajnorm
   do i = j, m
      a(i,j) = a(i,j)/ajnorm
      end do
   a(j,j) = a(j,j) + one
!
!        APPLY THE TRANSFORMATION TO THE REMAINING COLUMNS
!        AND UPDATE THE NORMS.
!
   jp1 = j + 1
   if (n .lt. jp1) go to 100
   do k = jp1, n
      sum = zero
      do i = j, m
         sum = sum + a(i,j)*a(i,k)
         end do
      temp = sum/a(j,j)
      do i = j, m
         a(i,k) = a(i,k) - temp*a(i,j)
         end do
      if (.not.pivot .or. rdiag(k) .eq. zero) go to 80
      temp = a(j,k)/rdiag(k)
      rdiag(k) = rdiag(k)*sqrt(amax1(zero,one-temp**2))
      if (p05*(rdiag(k)/wa(k))**2 .gt. epsmch) go to 80
      rdiag(k) = enorm(m-j,a(jp1,k))
      wa(k) = rdiag(k)
80 continue
      end do
100 continue
   rdiag(j) = -ajnorm
   end do
return
!
!     LAST CARD OF SUBROUTINE QRFAC.
!
end subroutine qrfac

subroutine qrsolv(n,r,ldr,ipvt,diag,qtb,x,sdiag,wa)
implicit none
integer, intent(in) :: n, ldr
integer, intent(in) :: ipvt(n)
real, intent(inout) :: r(ldr,n)
real, intent(in) :: diag(n), qtb(n)
real, intent(inout) :: x(n), sdiag(n), wa(n)
!     **********
!
!     SUBROUTINE QRSOLV
!
!     GIVEN AN M BY N MATRIX A, AN N BY N DIAGONAL MATRIX D,
!     AND AN M-VECTOR B, THE PROBLEM IS TO DETERMINE AN X WHICH
!     SOLVES THE SYSTEM
!
!           A*X = B ,     D*X = 0 ,
!
!     IN THE LEAST SQUARES SENSE.
!
!     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
!     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
!     QR FACTORIZATION, WITH COLUMN PIVOTING, OF A. THAT IS, IF
!     A*P = Q*R, WHERE P IS A PERMUTATION MATRIX, Q HAS ORTHOGONAL
!     COLUMNS, AND R IS AN UPPER TRIANGULAR MATRIX WITH DIAGONAL
!     ELEMENTS OF NONINCREASING MAGNITUDE, THEN QRSOLV EXPECTS
!     THE FULL UPPER TRIANGLE OF R, THE PERMUTATION MATRIX P,
!     AND THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B. THE SYSTEM
!     A*X = B, D*X = 0, IS THEN EQUIVALENT TO
!
!                  T       T
!           R*Z = Q *B ,  P *D*P*Z = 0 ,
!
!     WHERE X = P*Z. IF THIS SYSTEM DOES NOT HAVE FULL RANK,
!     THEN A LEAST SQUARES SOLUTION IS OBTAINED. ON OUTPUT QRSOLV
!     ALSO PROVIDES AN UPPER TRIANGULAR MATRIX S SUCH THAT
!
!            T   T               T
!           P *(A *A + D*D)*P = S *S .
!
!     S IS COMPUTED WITHIN QRSOLV AND MAY BE OF SEPARATE INTEREST.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE QRSOLV(N,R,LDR,IPVT,DIAG,QTB,X,SDIAG,WA)
!
!     WHERE
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
!
!       R IS AN N BY N ARRAY. ON INPUT THE FULL UPPER TRIANGLE
!         MUST CONTAIN THE FULL UPPER TRIANGLE OF THE MATRIX R.
!         ON OUTPUT THE FULL UPPER TRIANGLE IS UNALTERED, AND THE
!         STRICT LOWER TRIANGLE CONTAINS THE STRICT UPPER TRIANGLE
!         (TRANSPOSED) OF THE UPPER TRIANGULAR MATRIX S.
!
!       LDR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY R.
!
!       IPVT IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH DEFINES THE
!         PERMUTATION MATRIX P SUCH THAT A*P = Q*R. COLUMN J OF P
!         IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
!
!       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
!         DIAGONAL ELEMENTS OF THE MATRIX D.
!
!       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
!         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
!
!       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE LEAST
!         SQUARES SOLUTION OF THE SYSTEM A*X = B, D*X = 0.
!
!       SDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
!         DIAGONAL ELEMENTS OF THE UPPER TRIANGULAR MATRIX S.
!
!       WA IS A WORK ARRAY OF LENGTH N.
!
!     SUBPROGRAMS CALLED
!
!       FORTRAN-SUPPLIED ... ABS,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j, jp1, k, kp1, l, nsing
real :: cos, cotan, p5, p25, qtbpj, sin, sum, tan, temp, zero
data p5,p25,zero /5.0e-1,2.5e-1,0.0e0/
!
!     COPY R AND (Q TRANSPOSE)*B TO PRESERVE INPUT AND INITIALIZE S.
!     IN PARTICULAR, SAVE THE DIAGONAL ELEMENTS OF R IN X.
!
do j = 1, n
   do i = j, n
      r(i,j) = r(j,i)
      end do
   x(j) = r(j,j)
   wa(j) = qtb(j)
   end do
!
!     ELIMINATE THE DIAGONAL MATRIX D USING A GIVENS ROTATION.
!
do j = 1, n
!
!        PREPARE THE ROW OF D TO BE ELIMINATED, LOCATING THE
!        DIAGONAL ELEMENT USING P FROM THE QR FACTORIZATION.
!
   l = ipvt(j)
   if (diag(l) .eq. zero) go to 90
   do k = j, n
      sdiag(k) = zero
      end do
   sdiag(j) = diag(l)
!
!        THE TRANSFORMATIONS TO ELIMINATE THE ROW OF D
!        MODIFY ONLY A SINGLE ELEMENT OF (Q TRANSPOSE)*B
!        BEYOND THE FIRST N, WHICH IS INITIALLY ZERO.
!
   qtbpj = zero
   do k = j, n
!
!           DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
!           APPROPRIATE ELEMENT IN THE CURRENT ROW OF D.
!
      if (sdiag(k) .eq. zero) go to 70
      if (abs(r(k,k)) .ge. abs(sdiag(k))) go to 40
         cotan = r(k,k)/sdiag(k)
         sin = p5/sqrt(p25+p25*cotan**2)
         cos = sin*cotan
         go to 50
40 continue
         tan = sdiag(k)/r(k,k)
         cos = p5/sqrt(p25+p25*tan**2)
         sin = cos*tan
50 continue
!
!           COMPUTE THE MODIFIED DIAGONAL ELEMENT OF R AND
!           THE MODIFIED ELEMENT OF ((Q TRANSPOSE)*B,0).
!
      r(k,k) = cos*r(k,k) + sin*sdiag(k)
      temp = cos*wa(k) + sin*qtbpj
      qtbpj = -sin*wa(k) + cos*qtbpj
      wa(k) = temp
!
!           ACCUMULATE THE TRANFORMATION IN THE ROW OF S.
!
      kp1 = k + 1
      if (n .lt. kp1) go to 70
      do i = kp1, n
         temp = cos*r(i,k) + sin*sdiag(i)
         sdiag(i) = -sin*r(i,k) + cos*sdiag(i)
         r(i,k) = temp
         end do
70 continue
      end do
90 continue
!
!        STORE THE DIAGONAL ELEMENT OF S AND RESTORE
!        THE CORRESPONDING DIAGONAL ELEMENT OF R.
!
   sdiag(j) = r(j,j)
   r(j,j) = x(j)
   end do
!
!     SOLVE THE TRIANGULAR SYSTEM FOR Z. IF THE SYSTEM IS
!     SINGULAR, THEN OBTAIN A LEAST SQUARES SOLUTION.
!
nsing = n
do j = 1, n
   if (sdiag(j) .eq. zero .and. nsing .eq. n) nsing = j - 1
   if (nsing .lt. n) wa(j) = zero
   end do
if (nsing .lt. 1) go to 150
do k = 1, nsing
   j = nsing - k + 1
   sum = zero
   jp1 = j + 1
   if (nsing .lt. jp1) go to 130
   do i = jp1, nsing
      sum = sum + r(i,j)*wa(i)
      end do
130 continue
   wa(j) = (wa(j) - sum)/sdiag(j)
   end do
150 continue
!
!     PERMUTE THE COMPONENTS OF Z BACK TO COMPONENTS OF X.
!
do j = 1, n
   l = ipvt(j)
   x(l) = wa(j)
   end do
return
!
!     LAST CARD OF SUBROUTINE QRSOLV.
!
end subroutine qrsolv

subroutine r1mpyq(m,n,a,lda,v,w)
implicit none
integer, intent(in) :: m, n, lda
real, intent(inout) :: a(lda,n)
real, intent(in) :: v(n), w(n)
!     **********
!
!     SUBROUTINE R1MPYQ
!
!     GIVEN AN M BY N MATRIX A, THIS SUBROUTINE COMPUTES A*Q WHERE
!     Q IS THE PRODUCT OF 2*(N - 1) TRANSFORMATIONS
!
!           GV(N-1)*...*GV(1)*GW(1)*...*GW(N-1)
!
!     AND GV(I), GW(I) ARE GIVENS ROTATIONS IN THE (I,N) PLANE WHICH
!     ELIMINATE ELEMENTS IN THE I-TH AND N-TH PLANES, RESPECTIVELY.
!     Q ITSELF IS NOT GIVEN, RATHER THE INFORMATION TO RECOVER THE
!     GV, GW ROTATIONS IS SUPPLIED.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE R1MPYQ(M,N,A,LDA,V,W)
!
!     WHERE
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF ROWS OF A.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF COLUMNS OF A.
!
!       A IS AN M BY N ARRAY. ON INPUT A MUST CONTAIN THE MATRIX
!         TO BE POSTMULTIPLIED BY THE ORTHOGONAL MATRIX Q
!         DESCRIBED ABOVE. ON OUTPUT A*Q HAS REPLACED A.
!
!       LDA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
!         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY A.
!
!       V IS AN INPUT ARRAY OF LENGTH N. V(I) MUST CONTAIN THE
!         INFORMATION NECESSARY TO RECOVER THE GIVENS ROTATION GV(I)
!         DESCRIBED ABOVE.
!
!       W IS AN INPUT ARRAY OF LENGTH N. W(I) MUST CONTAIN THE
!         INFORMATION NECESSARY TO RECOVER THE GIVENS ROTATION GW(I)
!         DESCRIBED ABOVE.
!
!     SUBROUTINES CALLED
!
!       FORTRAN-SUPPLIED ... ABS,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
!
!     **********
integer :: i, j, nmj, nm1
real :: cos, one, sin, temp
data one /1.0e0/
!
!     APPLY THE FIRST SET OF GIVENS ROTATIONS TO A.
!
nm1 = n - 1
if (nm1 .lt. 1) go to 50
do nmj = 1, nm1
   j = n - nmj
   if (abs(v(j)) .gt. one) cos = one/v(j)
   if (abs(v(j)) .gt. one) sin = sqrt(one-cos**2)
   if (abs(v(j)) .le. one) sin = v(j)
   if (abs(v(j)) .le. one) cos = sqrt(one-sin**2)
   do i = 1, m
      temp = cos*a(i,j) - sin*a(i,n)
      a(i,n) = sin*a(i,j) + cos*a(i,n)
      a(i,j) = temp
      end do
   end do
!
!     APPLY THE SECOND SET OF GIVENS ROTATIONS TO A.
!
do j = 1, nm1
   if (abs(w(j)) .gt. one) cos = one/w(j)
   if (abs(w(j)) .gt. one) sin = sqrt(one-cos**2)
   if (abs(w(j)) .le. one) sin = w(j)
   if (abs(w(j)) .le. one) cos = sqrt(one-sin**2)
   do i = 1, m
      temp = cos*a(i,j) + sin*a(i,n)
      a(i,n) = -sin*a(i,j) + cos*a(i,n)
      a(i,j) = temp
      end do
   end do
50 continue
return
!
!     LAST CARD OF SUBROUTINE R1MPYQ.
!
end subroutine r1mpyq

subroutine r1updt(m,n,s,ls,u,v,w,sing)
implicit none
integer, intent(in) :: m, n, ls
logical, intent(inout) :: sing
real, intent(inout) :: s(ls)
real, intent(in) :: u(m)
real, intent(inout) :: v(n), w(m)
!     **********
!
!     SUBROUTINE R1UPDT
!
!     GIVEN AN M BY N LOWER TRAPEZOIDAL MATRIX S, AN M-VECTOR U,
!     AND AN N-VECTOR V, THE PROBLEM IS TO DETERMINE AN
!     ORTHOGONAL MATRIX Q SUCH THAT
!
!                   T
!           (S + U*V )*Q
!
!     IS AGAIN LOWER TRAPEZOIDAL.
!
!     THIS SUBROUTINE DETERMINES Q AS THE PRODUCT OF 2*(N - 1)
!     TRANSFORMATIONS
!
!           GV(N-1)*...*GV(1)*GW(1)*...*GW(N-1)
!
!     WHERE GV(I), GW(I) ARE GIVENS ROTATIONS IN THE (I,N) PLANE
!     WHICH ELIMINATE ELEMENTS IN THE I-TH AND N-TH PLANES,
!     RESPECTIVELY. Q ITSELF IS NOT ACCUMULATED, RATHER THE
!     INFORMATION TO RECOVER THE GV, GW ROTATIONS IS RETURNED.
!
!     THE SUBROUTINE STATEMENT IS
!
!       SUBROUTINE R1UPDT(M,N,S,LS,U,V,W,SING)
!
!     WHERE
!
!       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF ROWS OF S.
!
!       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
!         OF COLUMNS OF S. N MUST NOT EXCEED M.
!
!       S IS AN ARRAY OF LENGTH LS. ON INPUT S MUST CONTAIN THE LOWER
!         TRAPEZOIDAL MATRIX S STORED BY COLUMNS. ON OUTPUT S CONTAINS
!         THE LOWER TRAPEZOIDAL MATRIX PRODUCED AS DESCRIBED ABOVE.
!
!       LS IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
!         (N*(2*M-N+1))/2.
!
!       U IS AN INPUT ARRAY OF LENGTH M WHICH MUST CONTAIN THE
!         VECTOR U.
!
!       V IS AN ARRAY OF LENGTH N. ON INPUT V MUST CONTAIN THE VECTOR
!         V. ON OUTPUT V(I) CONTAINS THE INFORMATION NECESSARY TO
!         RECOVER THE GIVENS ROTATION GV(I) DESCRIBED ABOVE.
!
!       W IS AN OUTPUT ARRAY OF LENGTH M. W(I) CONTAINS INFORMATION
!         NECESSARY TO RECOVER THE GIVENS ROTATION GW(I) DESCRIBED
!         ABOVE.
!
!       SING IS A LOGICAL OUTPUT VARIABLE. SING IS SET TRUE IF ANY
!         OF THE DIAGONAL ELEMENTS OF THE OUTPUT S ARE ZERO. OTHERWISE
!         SING IS SET FALSE.
!
!     SUBPROGRAMS CALLED
!
!       MINPACK-SUPPLIED ... SPMPAR
!
!       FORTRAN-SUPPLIED ... ABS,SQRT
!
!     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
!     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE,
!     JOHN L. NAZARETH
!
!     **********
integer :: i, j, jj, l, nmj, nm1
real :: cos, cotan, giant, one, p5, p25, sin, tan, tau, temp, zero
real :: spmpar
data one,p5,p25,zero /1.0e0,5.0e-1,2.5e-1,0.0e0/
!
!     GIANT IS THE LARGEST MAGNITUDE.
!
giant = spmpar(3)
!
!     INITIALIZE THE DIAGONAL ELEMENT POINTER.
!
jj = (n*(2*m - n + 1))/2 - (m - n)
!
!     MOVE THE NONTRIVIAL PART OF THE LAST COLUMN OF S INTO W.
!
l = jj
do i = n, m
   w(i) = s(l)
   l = l + 1
   end do
!
!     ROTATE THE VECTOR V INTO A MULTIPLE OF THE N-TH UNIT VECTOR
!     IN SUCH A WAY THAT A SPIKE IS INTRODUCED INTO W.
!
nm1 = n - 1
if (nm1 .lt. 1) go to 70
do nmj = 1, nm1
   j = n - nmj
   jj = jj - (m - j + 1)
   w(j) = zero
   if (v(j) .eq. zero) go to 50
!
!        DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
!        J-TH ELEMENT OF V.
!
   if (abs(v(n)) .ge. abs(v(j))) go to 20
      cotan = v(n)/v(j)
      sin = p5/sqrt(p25+p25*cotan**2)
      cos = sin*cotan
      tau = one
      if (abs(cos)*giant .gt. one) tau = one/cos
      go to 30
20 continue
      tan = v(j)/v(n)
      cos = p5/sqrt(p25+p25*tan**2)
      sin = cos*tan
      tau = sin
30 continue
!
!        APPLY THE TRANSFORMATION TO V AND STORE THE INFORMATION
!        NECESSARY TO RECOVER THE GIVENS ROTATION.
!
   v(n) = sin*v(j) + cos*v(n)
   v(j) = tau
!
!        APPLY THE TRANSFORMATION TO S AND EXTEND THE SPIKE IN W.
!
   l = jj
   do i = j, m
      temp = cos*s(l) - sin*w(i)
      w(i) = sin*s(l) + cos*w(i)
      s(l) = temp
      l = l + 1
      end do
50 continue
   end do
70 continue
!
!     ADD THE SPIKE FROM THE RANK 1 UPDATE TO W.
!
do i = 1, m
   w(i) = w(i) + v(n)*u(i)
   end do
!
!     ELIMINATE THE SPIKE.
!
sing = .false.
if (nm1 .lt. 1) go to 140
do j = 1, nm1
   if (w(j) .eq. zero) go to 120
!
!        DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
!        J-TH ELEMENT OF THE SPIKE.
!
   if (abs(s(jj)) .ge. abs(w(j))) go to 90
      cotan = s(jj)/w(j)
      sin = p5/sqrt(p25+p25*cotan**2)
      cos = sin*cotan
      tau = one
      if (abs(cos)*giant .gt. one) tau = one/cos
      go to 100
90 continue
      tan = w(j)/s(jj)
      cos = p5/sqrt(p25+p25*tan**2)
      sin = cos*tan
      tau = sin
100 continue
!
!        APPLY THE TRANSFORMATION TO S AND REDUCE THE SPIKE IN W.
!
   l = jj
   do i = j, m
      temp = cos*s(l) + sin*w(i)
      w(i) = -sin*s(l) + cos*w(i)
      s(l) = temp
      l = l + 1
      end do
!
!        STORE THE INFORMATION NECESSARY TO RECOVER THE
!        GIVENS ROTATION.
!
   w(j) = tau
120 continue
!
!        TEST FOR ZERO DIAGONAL ELEMENTS IN THE OUTPUT S.
!
   if (s(jj) .eq. zero) sing = .true.
   jj = jj + (m - j + 1)
   end do
140 continue
!
!     MOVE W BACK INTO THE LAST COLUMN OF THE OUTPUT S.
!
l = jj
do i = n, m
   s(l) = w(i)
   l = l + 1
   end do
if (s(jj) .eq. zero) sing = .true.
return
!
!     LAST CARD OF SUBROUTINE R1UPDT.
!
end subroutine r1updt

subroutine smplx (a,b0,c,ka,m,n0,ind,ibasis,x,z,iter,mxiter, &
&numle,numge,bi,wk,iwk)
implicit none
integer, intent(inout) :: ibasis, ind, iter, iwk(*)
integer, intent(in) :: ka
integer :: m
integer, intent(in) :: mxiter, n0, numge, numle
real :: a(ka,n0), b0(m)
real, intent(inout) :: bi(m,m)
real :: c(n0)
real, intent(inout) :: wk(*), x(*), z
integer :: ip
real :: eps0, rerr, rerrmn, rerrmx
real :: spmpar
!-----------------------------------------------------------------------
!     SIMPLEX PROCEDURE FOR SOLVING LINEAR PROGRAMMING PROBLEMS
!-----------------------------------------------------------------------
!     WRITTEN BY ALFRED H. MORRIS JR.
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN, VIRGINIA
!------------------------
!     INITIAL VERSION  DEC  1977
!     LAST UPDATE      OCT  1990
!------------------------
dimension ibasis(m)
!------------------------
!     DIMENSION X(N0+NUMLE+NUMGE)
!     DIMENSION WK(2*M),IWK(2*M+N0)
!------------------------
!
!     ********** EPS0 IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS0
!                THE VALUE U WHERE U IS THE SMALLEST POSITIVE FLOATING
!                POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0.
!
                    eps0 = spmpar(1)
!
!------------------------
rerrmn = 10.0*eps0
rerrmx = 1.e-4
if (eps0 .lt. 1.e-13) rerrmx = 1.e-5
!
ip = m + n0 + 1
call smplx1(a,b0,c,ka,m,n0,ind,ibasis,x,z,iter,mxiter, &
&eps0,rerrmn,rerrmx,rerr,numle,numge,bi, &
&wk(1),wk(m+1),iwk(1),iwk(ip))
return
end subroutine smplx

subroutine smplx1 (a,b0,c,ka,m,n0,ind,ibasis,r,z,iter,mxiter, &
&eps0,rerrmn,rerrmx,rerr,numle,numge,bi,xb,y,basis,index)
implicit none
integer, intent(inout) :: ind
integer, intent(out) :: iter
integer, intent(in) :: ka, m, mxiter, n0, numge, numle
real, intent(in) :: eps0
real, intent(inout) :: rerr
real, intent(in) :: rerrmn, rerrmx
real, intent(out) :: z
integer :: i, ibeg, icount, iend, ierr, ii, il, imin, iout, ip, j, &
&jcol, jj, jmin, jp, k, ki, kj, l, ll, lrow, m0, mcheck, ms, n, &
&npos, nrow, ns, nstep, num
real :: amax, binorm, bmax, bmin, bnorm, cmin, const, eps, epsi, &
&ratio, rerr1, rmin, rtol, s, sgn, sum, t, tol, w, xmax
real :: spmpar
!----------------------
!     NSTEP = 1   ELIMINATE THE NEGATIVE VARIABLES
!     NSTEP = 2   PHASE 1 OF THE SIMPLEX ALGORITHM
!     NSTEP = 3   PHASE 2 OF THE SIMPLEX ALGORITHM
!----------------------
!     MXITER = THE MAXIMUM NUMBER OF ITERATIONS PERMITTED
!     ITER = THE NUMBER OF THE CURRENT ITERATION
!     ICOUNT = THE NUMBER OF ITERATIONS SINCE THE LAST INVERSION
!----------------------
!     NUMLE = THE NUMBER OF .LE. CONSTRAINTS
!     NUMGE = THE NUMBER OF .GE. CONSTRAINTS
!----------------------
!     THE ROUTINE ASSUMES THAT THE .LE. CONSTRAINTS PRECEDE THE .GE.
!     CONSTRAINTS AND THAT THE .EQ. CONSTRAINTS COME LAST. THERE ARE
!     M CONSTRAINTS. X(N0+I) IS THE SLACK, SURPLUS, OR ARTIFICIAL
!     VARIABLE FOR THE I-TH CONSTRAINT (I=1,...,M).
!----------------------
!     N0 = THE NUMBER OF ORGINAL VARIABLES
!     NS = THE NUMBER OF ORGINAL AND SLACK VARIABLES
!     N  = THE NUMBER OF ORGINAL, SLACK, AND SURPLUS VARIABLES
!     NUM = THE TOTAL NUMBER OF VARIABLES
!----------------------
!     RERRMN = THE SMALLEST RELATIVE ERROR TOLERANCE USED
!     RERRMX = THE LARGEST RELATIVE ERROR TOLERACE USED
!     RERR   = THE ESTIMATED CURRENT RELATIVE ERROR
!----------------------
!     ASSUME THAT
!         B0 = (B0(1),...,B0(M))
!         C  = (C(1),...,C(N0))
!         Z  = C(1)*X(1)+...+C(N0)*X(N0)
!     THE PROBLEM IS TO MAXIMIZE Z SUBJECT TO
!         AX(LE,EQ,GE)B0
!         X.GE.0
!----------------------
!     ON INPUT IND CAN HAVE THE VALUES
!         IND = 0   NO BEGINNING BASIS IS PROVIDED BY THE USER
!         IND = 1   THE ARRAY IBASIS HAS BEEN SET BY THE USER
!     ON OUTPUT IND IS ASSIGNED ONE OF THE VALUES
!         IND = 0   Z WAS SUCCESSFULLY MAXIMIZED
!         IND = 1   THE PROBLEM HAS NO FEASIBLE SOLUTION
!         IND = 2   MXITER ITERATIONS WERE PERFORMED
!         IND = 3   SUFFICIENT ACCURACY CANNOT BE MAINTAINED
!         IND = 4   THE PROBLEM HAS AN UNBOUNDED SOLUTION
!         IND = 5   THERE IS AN INPUT ERROR
!         IND = 6   Z WAS POSSIBLY MAXIMIZED
!----------------------
!     BASIS IS AN INTEGER ARRAY OF DIMENSION N0+M. FOR J.LE.N
!         BASIS(J) = 1  IF X(J) IS A BASIC VARIABLE
!         BASIS(J) = 0  IF X(J) IS NOT A BASIC VARIABLE
!     IF THE BASIC VARIABLES ARE X(I1),...,X(IM) THEN
!         IBASIS = (I1,...,IM)
!     ALSO XB(1),...,XB(M) ARE THE CORRESPONDING VALUES OF THE
!     BASIC VARIABLES.
!----------------------
!     BI IS AN MXM ARRAY CONTAINING THE INVERSE OF THE BASIS MATRIX.
!----------------------
!     R IS AN ARRAY OF DIMENSION N. ON OUTPUT R CONTAINS THE CURRENT
!     VALUE OF X. DURING COMPUTATION R NORMALLY CONTAINS THE REDUCED
!     COSTS USED FOR THE SELECTION OF THE VARIABLE TO BE MADE BASIC.
!----------------------
real, intent(in) :: a(ka,n0), b0(m), c(n0)
real, intent(inout) :: bi(m,m), xb(m), y(m), r(*)
integer, intent(inout) :: ibasis(m), basis(*)
integer :: bflag
integer, intent(inout) :: index(m)
double precision :: dsum, dsump, dsumn, dt
!----------------------
!
!     ****** XMAX IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
!            LARGEST POSITIVE FLOATING POINT NUMBER.
!
           xmax = spmpar(3)
!
!----------------------
iter = 0
icount = 0
mcheck = min0(5,1 + m/15)
z = 0.0
!
!                CHECK FOR INPUT ERRORS
!
ms = numle + numge
if (m .lt. 2 .or. n0 .lt. 2 .or. ms .gt. m .or. ka .lt. m) &
&go to 12
do 10 i = 1,m
   if (b0(i) .lt. 0.0) go to 12
10 xb(i) = 0.0
rtol = xmax
do i = 1,n0
   if (c(i) .ne. 0.0) rtol = amin1(abs(c(i)),rtol)
end do
rtol = rerrmx*rtol
go to 20
!
12 ind = 5
return
!
!     FORMATION OF THE IBASIS AND BASIS ARRAYS. (IF IND = 1
!     THEN THE IBASIS ARRAY IS DEFINED BY THE USER.)
!
20 ns = n0 + numle
n = ns + numge
if (ind .eq. 0) go to 30
num = n
do i = 1,m
   if (ibasis(i) .gt. n) num = num + 1
end do
go to 32
22 if (ind .eq. 0) go to 590
ind = 0
!
30 num = n0 + m
do 31 i = 1,m
31 ibasis(i) = n0 + i
32 bflag = 0
do 33 i = 1,n
33 basis(i) = 0
do 34 i = 1,m
   ki = ibasis(i)
34 basis(ki) = 1
if (ind .eq. 1) go to 100
!
!          CALCULATION OF XB AND BI WHEN IND = 0
!
rerr = rerrmn
do j = 1,m
   xb(j) = b0(j)
   do 40 i = 1,m
40 bi(i,j) = 0.0
   bi(j,j) = 1.0
end do
if (numge .eq. 0) go to 630
jmin = numle + 1
do j = jmin,ms
   xb(j) = -xb(j)
   bi(j,j) = -1.0
end do
go to 601
!
!                  REORDER THE BASIS
!
100 ibeg = 1
iend = m
do 102 i = 1,m
   if (ibasis(i) .le. n0) go to 101
      index(ibeg) = ibasis(i)
      ibeg = ibeg + 1
      go to 102
101 index(iend) = ibasis(i)
   iend = iend - 1
102 continue
if (iend .eq. m) go to 22
do 103 i = 1,m
103 ibasis(i) = index(i)
!
!            REINVERSION OF THE BASIS MATRIX
!
do 132 j = 1,m
   kj = ibasis(j)
   if (kj .le. n0) go to 110
   if (kj .le. ns) go to 120
   if (kj .le. n) go to 130
   go to 120
!
110 do 111 i = 1,m
111 bi(i,j) = a(i,kj)
   go to 132
!
120 l = kj - n0
   do 121 i = 1,m
121 bi(i,j) = 0.0
   bi(l,j) = 1.0
   go to 132
!
130 l = kj - n0
   do 131 i = 1,m
131 bi(i,j) = 0.0
   bi(l,j) = -1.0
132 continue
!
icount = 0
call crout1 (bi, m, m, iend, index, y, jcol, ierr)
if (ierr .ne. 0) go to 580
!
!         CHECK THE ACCURACY OF BI AND RESET RERR
!
bnorm = 0.0
do 142 j = 1,m
   kj = ibasis(j)
   if (kj .le. n0) go to 140
      sum = 1.0
      go to 142
140 sum = 0.0
   do 141 i = 1,m
141 sum = sum + abs(a(i,kj))
142 bnorm = amax1(bnorm,sum)
!
binorm = 0.0
do j = 1,m
   sum = 0.0
   do 150 i = 1,m
150 sum = sum + abs(bi(i,j))
   binorm = amax1(binorm,sum)
end do
rerr = amax1(rerrmn,eps0*bnorm*binorm)
if (rerr .gt. 1.e-2) go to 580
bflag = 0
!
!                 RECALCULATION OF XB
!
180 do i = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do 182 l = 1,m
      dt = bi(i,l)*b0(l)
      if (dt .gt. 0.d0) go to 181
         dsumn = dsumn + dt
         go to 182
181 dsump = dsump + dt
182 continue
   xb(i) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*amax1(s,-t)
   if (abs(xb(i)) .lt. tol) xb(i) = 0.0
end do
go to 601
!
!     FIND THE NEXT VECTOR A(--,JP) TO BE INSERTED INTO
!                       THE BASIS
!
200 jp = 0
rmin = 0.0
if (nstep .eq. 3) rmin = -rtol
do 201 j = 1,n0
   if (basis(j) .ne. 0) go to 201
   if (r(j) .ge. rmin) go to 201
   jp = j
   rmin = r(j)
201 continue
if (n0 .eq. n) go to 203
jmin = n0 + 1
rmin = rmin*1.1
do 202 j = jmin,n
   if (basis(j) .ne. 0) go to 202
   if (r(j) .ge. rmin) go to 202
   jp = j
   rmin = r(j)
202 continue
203 if (jp .ne. 0) go to 300
if (nstep - 2) 800,230,250
!
!     INSERT THE VALUES OF THE ORGINAL, SLACK, AND SURPLUS
!             VARIABLES INTO R. THEN TERMINATE.
!
220 do 221 j = 1,n
221 r(j) = 0.0
do i = 1,m
   ki = ibasis(i)
   if (ki .le. n) r(ki) = xb(i)
end do
return
!
!             COMPLETION OF THE NSTEP = 2 CASE
!
230 do 231 i = 1,m
   if (ibasis(i) .le. n) go to 231
   if (xb(i) .gt. 0.0) go to 800
231 continue
go to 680
!
240 if (icount .ge. 5) go to 100
ind = 1
go to 220
!
!             COMPLETION OF THE NSTEP = 3 CASE
!
250 if (rerr .gt. 1.e-2) go to 251
   ind = 0
   go to 800
251 if (icount .ge. 5) go to 100
ind = 6
go to 800
!
!     IF MXITER ITERATIONS HAVE NOT BEEN PERFORMED THEN
!     BEGIN THE NEXT ITERATION. COMPUTE THE JP-TH COLUMN
!               OF BI*A AND STORE IT IN Y.
!
300 if (iter .lt. mxiter) go to 301
   ind = 2
   go to 220
301 iter = iter + 1
icount = icount + 1
if (jp .gt. ns) go to 330
if (jp .gt. n0) go to 320
!
nrow = 0
amax = 0.0
do 305 i = 1,m
   if (a(i,jp) .eq. 0.0) go to 305
   nrow = nrow + 1
   index(nrow) = i
   amax = amax1(abs(a(i,jp)),amax)
305 continue
if (nrow .ne. 0) go to 310
ind = 4
go to 220
!
310 rerr1 = rerrmx*amax
do 313 i = 1,m
   dsum = 0.d0
   do ll = 1,nrow
      l = index(ll)
      dsum = dsum + dble(bi(i,l)*a(l,jp))
   end do
   y(i) = dsum
   if (abs(y(i)) .ge. 5.e-3) go to 313
   bmax = 0.0
   do l = 1,m
      bmax = amax1(abs(bi(i,l)),bmax)
   end do
   tol = rerr1*bmax
   if (abs(y(i)) .lt. tol) y(i) = 0.0
313 continue
go to 350
!
320 l = jp - n0
do i = 1,m
   y(i) = bi(i,l)
end do
go to 350
!
330 l = jp - n0
do i = 1,m
   y(i) = -bi(i,l)
end do
!
350 do i = 1,m
   if (y(i) .ne. 0.0) go to 360
end do
r(jp) = 0.0
iter = iter - 1
icount = icount - 1
go to 200
!
360 if (nstep - 2) 400,430,440
!
!     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
!               FOR THE NSTEP = 1 CASE
!
400 npos = 0
ip = 0
eps = 0.0
epsi = xmax
do 403 i = 1,m
   if (xb(i) .lt. 0.0 .or. y(i) .le. 0.0) go to 403
   ratio = xb(i)/y(i)
   if (ratio - epsi) 401,402,403
401 epsi = ratio
   npos = 1
   index(1) = i
   go to 403
402 npos = npos + 1
   index(npos) = i
403 continue
if (npos .eq. 0) go to 420
if (epsi .eq. 0.0) go to 460
!
do 410 i = 1,m
   if (xb(i) .ge. 0.0 .or. y(i) .ge. 0.0) go to 410
   ratio = xb(i)/y(i)
   if (ratio .gt. epsi) go to 410
   if (ratio .lt. eps) go to 410
   eps = ratio
   ip = i
410 continue
if (ip .ne. 0) go to 500
go to 460
!
420 do 421 i = 1,m
   if (xb(i) .ge. 0.0 .or. y(i) .ge. 0.0) go to 421
   ratio = xb(i)/y(i)
   if (ratio .lt. eps) go to 421
   eps = ratio
   ip = i
421 continue
go to 500
!
!     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
!               FOR THE NSTEP = 2 CASE
!
430 npos = 0
epsi = xmax
do 433 i = 1,m
   if (y(i) .le. 0.0) go to 433
   ratio = xb(i)/y(i)
   if (ratio - epsi) 431,432,433
431 epsi = ratio
   npos = 1
   index(1) = i
   go to 433
432 npos = npos + 1
   index(npos) = i
433 continue
go to 450
!
!     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
!               FOR THE NSTEP = 3 CASE
!
440 npos = 0
epsi = xmax
do 445 i = 1,m
   if (y(i)) 441,445,442
441 if (ibasis(i) .le. n) go to 445
   ip = i
   go to 500
442 ratio = xb(i)/y(i)
   if (ratio - epsi) 443,444,445
443 epsi = ratio
      npos = 1
      index(1) = i
      go to 445
444 npos = npos + 1
      index(npos) = i
445 continue
!
450 if (npos .ne. 0) go to 460
if (icount .ge. 5) go to 100
ind = 4
go to 220
!
!              TIE BREAKING PROCEDURE
!
460 ip = index(1)
if (npos .eq. 1) go to 500
ip = 0
bmin = xmax
cmin = xmax
do 464 ii = 1,npos
   i = index(ii)
   l = ibasis(i)
   if (l .gt. n0) go to 461
      if (c(l) .le. 0.0) cmin = amin1(0.0,cmin)
      if (c(l) .gt. cmin) go to 464
      imin = i
      cmin = c(l)
      go to 464
461 if (l .le. n) go to 462
      ip = i
      go to 500
462 lrow = l - n0
   s = b0(lrow)
   if (lrow .gt. numle) go to 463
      if (s .gt. bmin) go to 464
      ip = i
      bmin = s
      go to 464
463 s = -s
   bmin = amin1(0.0,bmin)
   if (s .gt. bmin) go to 464
   ip = i
   bmin = s
464 continue
if (cmin .le. 0.0 .or. ip .eq. 0) ip = imin
!
!               TRANSFORMATION OF XB
!
500 if (xb(ip) .eq. 0.0) go to 510
const = xb(ip)/y(ip)
do 501 i = 1,m
   s = xb(i)
   xb(i) = xb(i) - const*y(i)
   if (xb(i) .ge. 0.0) go to 501
   if (s .ge. 0.0 .or. xb(i) .ge. rerrmx*s) xb(i) = 0.0
501 continue
xb(ip) = const
!
!               TRANSFORMATION OF BI
!
510 do 512 j = 1,m
   if (bi(ip,j) .eq. 0.0) go to 512
   const = bi(ip,j)/y(ip)
   do 511 i = 1,m
511 bi(i,j) = bi(i,j) - const*y(i)
   bi(ip,j) = const
512 continue
!
!             UPDATING IBASIS AND BASIS
!
iout = ibasis(ip)
ibasis(ip) = jp
basis(iout) = 0
basis(jp) = 1
if (iout .gt. n) num = num - 1
!
!        CHECK THE ACCURACY OF BI AND RESET RERR
!
if (rerr .gt. 1.e-2) go to 530
k = 0
do 521 j = 1,m
   kj = ibasis(j)
   if (kj .gt. n0) go to 521
   sum = 0.0
   do l = 1,m
      if (a(l,kj) .ne. 0.0) sum = sum + bi(j,l)*a(l,kj)
   end do
   rerr = amax1(rerr,abs(1.0 - sum))
   k = k + 1
   if (k .ge. mcheck) go to 522
521 continue
522 if (rerr .le. 1.e-2) go to 600
!
!        THE ACCURACY CRITERIA ARE NOT SATISFIED
!
530 if (icount .lt. 5) go to 600
bflag = 1
go to 100
!
580 if (iter .eq. 0) go to 12
if (bflag .eq. 0) go to 590
bflag = 0
do ip = 1,m
   if (jp .eq. ibasis(ip)) go to 582
end do
582 ibasis(ip) = iout
basis(jp) = 0
basis(iout) = 1
if (iout .gt. n) num = num + 1
go to 100
!
590 ind = 3
go to 220
!
!       SET UP THE R ARRAY FOR THE NSTEP = 1 CASE
!
600 if (nstep - 2) 601,630,700
601 do j = 1,m
   if (xb(j) .lt. 0.0) go to 610
end do
go to 630
!
610 nstep = 1
m0 = 0
do 611 l = 1,m
   if (xb(l) .ge. 0.0) go to 611
   m0 = m0 + 1
   index(m0) = l
611 continue
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do 622 ll = 1,m0
      l = index(ll)
      if (bi(l,j)) 620,622,621
620 dsumn = dsumn + dble(bi(l,j))
      go to 622
621 dsump = dsump + dble(bi(l,j))
622 continue
   y(j) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*amax1(s,-t)
   if (abs(y(j)) .lt. tol) y(j) = 0.0
end do
go to 650
!
!       SET UP THE R ARRAY FOR THE NSTEP = 2 CASE
!
630 if (n .eq. num) go to 680
nstep = 2
m0 = 0
do 631 l = 1,m
   if (ibasis(l) .le. n) go to 631
   m0 = m0 + 1
   index(m0) = l
631 continue
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do 642 ll = 1,m0
      l = index(ll)
      if (bi(l,j)) 640,642,641
640 dsumn = dsumn + dble(bi(l,j))
      go to 642
641 dsump = dsump + dble(bi(l,j))
642 continue
   y(j) = -(dsump + dsumn)
   s = dsump
   t = dsumn
   tol = rerrmx*amax1(s,-t)
   if (abs(y(j)) .lt. tol) y(j) = 0.0
end do
!
650 do 652 j = 1,n0
   sum = 0.0
   if (basis(j) .ne. 0) go to 652
   do l = 1,m
      if (a(l,j) .ne. 0.0) sum = sum + y(l)*a(l,j)
   end do
652 r(j) = sum
!
660 if (n0 .eq. ns) go to 670
jmin = n0 + 1
do 661 j = jmin,ns
   r(j) = 0.0
   if (basis(j) .ne. 0) go to 661
   jj = j - n0
   r(j) = y(jj)
661 continue
!
670 if (ns .eq. n) go to 200
jmin = ns + 1
do 671 j = jmin,n
   r(j) = 0.0
   if (basis(j) .ne. 0) go to 671
   jj = j - n0
   r(j) = -y(jj)
671 continue
go to 200
!
!      SET UP A NEW R ARRAY FOR THE NSTEP = 3 CASE
!
680 nstep = 3
do 682 j = 1,m
   dsum = 0.d0
   do l = 1,m
      il = ibasis(l)
      if (il .le. n0) dsum = dsum + dble(c(il)*bi(l,j))
   end do
682 y(j) = dsum
!
do 691 j = 1,n0
   r(j) = 0.0
   if (basis(j) .ne. 0) go to 691
   dsum = -c(j)
   do l = 1,m
      if (a(l,j) .ne. 0.0) dsum = dsum + dble(y(l)*a(l,j))
   end do
   r(j) = dsum
   if (r(j) .ge. 0.0) go to 691
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) .lt. tol) r(j) = 0.0
691 continue
go to 660
!
!       UPDATE THE R ARRAY FOR THE NSTEP = 3 CASE
!
700 const = r(jp)
do 703 j = 1,n0
   if (basis(j) .eq. 0) go to 701
      r(j) = 0.0
      go to 703
701 sum = 0.0
   do l = 1,m
      if (a(l,j) .ne. 0.0) sum = sum + bi(ip,l)*a(l,j)
   end do
   r(j) = r(j) - const*sum
   if (r(j) .ge. 0.0) go to 703
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) .lt. tol) r(j) = 0.0
703 continue
!
710 if (n0 .eq. ns) go to 720
jmin = n0 + 1
do 712 j = jmin,ns
   if (basis(j) .eq. 0) go to 711
      r(j) = 0.0
      go to 712
711 jj = j - n0
   r(j) = r(j) - const*bi(ip,jj)
712 continue
!
720 if (ns .eq. n) go to 200
jmin = ns + 1
do 722 j = jmin,n
   if (basis(j) .eq. 0) go to 721
      r(j) = 0.0
      go to 722
721 jj = j - n0
   r(j) = r(j) + const*bi(ip,jj)
722 continue
go to 200
!-----------------------------------------------------------------------
!               REFINE XB AND STORE THE RESULT IN Y
!-----------------------------------------------------------------------
800 do i = 1,m
   y(i) = 0.0
end do
!
m0 = 0
do 831 j = 1,m
   kj = ibasis(j)
   if (kj .le. n0) go to 810
   if (kj .le. ns) go to 820
   if (kj .le. n) go to 830
   go to 820
!
810 m0 = m0 + 1
   index(m0) = j
   go to 831
!
820 l = kj - n0
   y(l) = xb(j)
   go to 831
!
830 l = kj - n0
   y(l) = -xb(j)
831 continue
!
if (m0 .ne. 0) go to 841
   do 840 i = 1,m
840 r(i) = b0(i) - y(i)
   go to 850
841 do i = 1,m
   dsum = y(i)
   do jj = 1,m0
      j = index(jj)
      kj = ibasis(j)
      dsum = dsum + dble(a(i,kj)*xb(j))
   end do
   r(i) = b0(i) - dsum
end do
!
850 rerr1 = amin1(rerrmx,rerr)
do 856 i = 1,m
   y(i) = 0.0
   if (xb(i)) 851,856,852
851 sgn = -1.0
   dsump = 0.d0
   dsumn = xb(i)
   go to 853
852 sgn = 1.0
   dsump = xb(i)
   dsumn = 0.d0
853 do 855 l = 1,m
      dt = bi(i,l)*r(l)
      if (dt .gt. 0.d0) go to 854
         dsumn = dsumn + dt
         go to 855
854 dsump = dsump + dt
855 continue
   w = dsump + dsumn
   if (w .eq. 0.0) go to 856
   if (sgn .ne. sign(1.0,w)) go to 856
   s = dsump
   t = dsumn
   tol = rerr1*amax1(s,-t)
   if (abs(w) .gt. tol) y(i) = w
856 continue
if (nstep - 2) 860,870,880
!
!         CHECK THE REFINEMENT (NSTEP = 1)
!
860 do 861 i = 1,m
   if (y(i) .ge. 0.0) go to 861
   if (y(i) .lt. -rerrmx) go to 240
   y(i) = 0.0
861 xb(i) = y(i)
go to 630
!
!         CHECK THE REFINEMENT (NSTEP = 2)
!
870 do 871 i = 1,m
   if (ibasis(i) .le. n) go to 871
   if (y(i) .gt. rerrmx) go to 240
   y(i) = 0.0
871 xb(i) = y(i)
go to 680
!
!              COMPUTE Z  (NSTEP = 3)
!
880 dsum = 0.d0
do 881 i = 1,m
   ki = ibasis(i)
   if (ki .gt. n0) go to 881
   dsum = dsum + dble(c(ki)*y(i))
881 xb(i) = y(i)
z = dsum
go to 220
end subroutine smplx1

subroutine ssplx (ta,ita,jta,b0,c,m,n0,ind,ibasis,x,z,iter,mxiter, &
&numle,numge,bi,wk,iwk)
implicit none
integer, intent(inout) :: ibasis, ind
integer :: ita(*)
integer, intent(inout) :: iter, iwk(*)
integer :: jta(*), m
integer, intent(in) :: mxiter, n0, numge, numle
real :: b0(m)
real, intent(inout) :: bi(m,m)
real :: c(n0), ta(*)
real, intent(inout) :: wk(*), x(*), z
integer :: ip
real :: eps0, rerr, rerrmn, rerrmx
real :: spmpar
!-----------------------------------------------------------------------
!     SIMPLEX PROCEDURE FOR SOLVING LINEAR PROGRAMMING PROBLEMS
!-----------------------------------------------------------------------
!     WRITTEN BY ALFRED H. MORRIS JR.
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN, VIRGINIA
!------------------------
!     INITIAL VERSION  DEC  1977
!     LAST UPDATE      OCT  1990
!------------------------
dimension ibasis(m)
!------------------------
!     DIMENSION X(N0+NUMLE+NUMGE)
!     DIMENSION WK(2*M),IWK(2*M+N0)
!------------------------
!
!     ********** EPS0 IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS0
!                THE VALUE U WHERE U IS THE SMALLEST POSITIVE FLOATING
!                POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0.
!
                    eps0 = spmpar(1)
!
!------------------------
rerrmn = 10.0*eps0
rerrmx = 1.e-4
if (eps0 .lt. 1.e-13) rerrmx = 1.e-5
!
ip = m + n0 + 1
call ssplx1(ta,ita,jta,b0,c,m,n0,ind,ibasis,x,z,iter,mxiter, &
&eps0,rerrmn,rerrmx,rerr,numle,numge,bi, &
&wk(1),wk(m+1),iwk(1),iwk(ip))
return
end subroutine ssplx

subroutine ssplx1 (ta,ita,jta,b0,c,m,n0,ind,ibasis,r,z, &
&iter,mxiter,eps0,rerrmn,rerrmx,rerr,numle,numge, &
&bi,xb,y,basis,index)
implicit none
integer, intent(inout) :: ind
integer, intent(out) :: iter
integer, intent(in) :: m, mxiter, n0, numge, numle
real, intent(in) :: eps0
real, intent(inout) :: rerr
real, intent(in) :: rerrmn, rerrmx
real, intent(out) :: z
integer :: i, ibeg, icount, iend, ierr, ii, il, imin, iout, ip, j, &
&jcol, jj, jmin, jp, k, ki, kj, l, ll, lmax, lmin, lrow, m0, &
&mcheck, ms, n, npos, ns, nstep, num
real :: amax, binorm, bmax, bmin, bnorm, cmin, const, eps, epsi, &
&ratio, rerr1, rmin, rtol, s, sgn, sum, t, tol, w, xmax
real :: spmpar
!----------------------
!     NSTEP = 1   ELIMINATE THE NEGATIVE VARIABLES
!     NSTEP = 2   PHASE 1 OF THE SIMPLEX ALGORITHM
!     NSTEP = 3   PHASE 2 OF THE SIMPLEX ALGORITHM
!----------------------
!     MXITER = THE MAXIMUM NUMBER OF ITERATIONS PERMITTED
!     ITER = THE NUMBER OF THE CURRENT ITERATION
!     ICOUNT = THE NUMBER OF ITERATIONS SINCE THE LAST INVERSION
!----------------------
!     NUMLE = THE NUMBER OF .LE. CONSTRAINTS
!     NUMGE = THE NUMBER OF .GE. CONSTRAINTS
!----------------------
!     THE ROUTINE ASSUMES THAT THE .LE. CONSTRAINTS PRECEDE THE .GE.
!     CONSTRAINTS AND THAT THE .EQ. CONSTRAINTS COME LAST. THERE ARE
!     M CONSTRAINTS. X(N0+I) IS THE SLACK, SURPLUS, OR ARTIFICIAL
!     VARIABLE FOR THE I-TH CONSTRAINT (I=1,...,M).
!----------------------
!     N0 = THE NUMBER OF ORGINAL VARIABLES
!     NS = THE NUMBER OF ORGINAL AND SLACK VARIABLES
!     N  = THE NUMBER OF ORGINAL, SLACK, AND SURPLUS VARIABLES
!     NUM = THE TOTAL NUMBER OF VARIABLES
!----------------------
!     RERRMN = THE SMALLEST RELATIVE ERROR TOLERANCE USED
!     RERRMX = THE LARGEST RELATIVE ERROR TOLERANCE USED
!     RERR   = THE ESTIMATED CURRENT RELATIVE ERROR
!----------------------
!     LET A DENOTE AN MXN0 MATRIX. THE TRANSPOSE OF A IS STORED IN
!     SPARSE FORM IN TA,ITA,JTA. ASSUME THAT
!         B0 = (B0(1),...,B0(M))
!         C  = (C(1),...,C(N0))
!         Z  = C(1)*X(1)+...+C(N0)*X(N0)
!     THE PROBLEM IS TO MAXIMIZE Z SUBJECT TO
!         AX(LE,EQ,GE)B0
!         X.GE.0
!----------------------
!     ON INPUT IND CAN HAVE THE VALUES
!         IND = 0   NO BEGINNING BASIS IS PROVIDED BY THE USER
!         IND = 1   THE ARRAY IBASIS HAS BEEN SET BY THE USER
!     ON OUTPUT IND IS ASSIGNED ONE OF THE VALUES
!         IND = 0   Z WAS SUCCESSFULLY MAXIMIZED
!         IND = 1   THE PROBLEM HAS NO FEASIBLE SOLUTION
!         IND = 2   MXITER ITERATIONS WERE PERFORMED
!         IND = 3   SUFFICIENT ACCURACY CANNOT BE MAINTAINED
!         IND = 4   THE PROBLEM HAS AN UNBOUNDED SOLUTION
!         IND = 5   THERE IS AN INPUT ERROR
!         IND = 6   Z WAS POSSIBLY MAXIMIZED
!----------------------
!     BASIS IS AN INTEGER ARRAY OF DIMENSION N0+M. FOR J.LE.N
!         BASIS(J) = 1  IF X(J) IS A BASIC VARIABLE
!         BASIS(J) = 0  IF X(J) IS NOT A BASIC VARIABLE
!     IF THE BASIC VARIABLES ARE X(I1),...,X(IM) THEN
!         IBASIS = (I1,...,IM)
!     ALSO XB(1),...,XB(M) ARE THE CORRESPONDING VALUES OF THE
!     BASIC VARIABLES.
!----------------------
!     BI IS AN MXM ARRAY CONTAINING THE INVERSE OF THE BASIS MATRIX.
!----------------------
!     R IS AN ARRAY OF DIMENSION N. ON OUTPUT R CONTAINS THE CURRENT
!     VALUE OF X. DURING COMPUTATION R NORMALLY CONTAINS THE REDUCED
!     COSTS USED FOR THE SELECTION OF THE VARIABLE TO BE MADE BASIC.
!----------------------
real, intent(in) :: ta(*), b0(m), c(n0)
real, intent(inout) :: bi(m,m), xb(m), y(m), r(*)
integer, intent(in) :: ita(*), jta(*)
integer, intent(inout) :: ibasis(m), basis(*)
integer :: bflag
integer, intent(inout) :: index(m)
double precision :: dsum, dsump, dsumn, dt
!----------------------
!
!     ****** XMAX IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
!            LARGEST POSITIVE FLOATING POINT NUMBER.
!
           xmax = spmpar(3)
!
!----------------------
iter = 0
icount = 0
mcheck = min0(5,1 + m/15)
z = 0.0
!
!                CHECK FOR INPUT ERRORS
!
ms = numle + numge
if (m .lt. 2 .or. n0 .lt. 2 .or. ms .gt. m) go to 12
do 10 i = 1,m
   if (b0(i) .lt. 0.0) go to 12
10 xb(i) = 0.0
rtol = xmax
do i = 1,n0
   if (c(i) .ne. 0.0) rtol = amin1(abs(c(i)),rtol)
end do
rtol = rerrmx*rtol
go to 20
!
12 ind = 5
return
!
!     FORMATION OF THE IBASIS AND BASIS ARRAYS. (IF IND = 1
!     THEN THE IBASIS ARRAY IS DEFINED BY THE USER.)
!
20 ns = n0 + numle
n = ns + numge
if (ind .eq. 0) go to 30
num = n
do i = 1,m
   if (ibasis(i) .gt. n) num = num + 1
end do
go to 32
22 if (ind .eq. 0) go to 590
ind = 0
!
30 num = n0 + m
do 31 i = 1,m
31 ibasis(i) = n0 + i
32 bflag = 0
do 33 i = 1,n
33 basis(i) = 0
do 34 i = 1,m
   ki = ibasis(i)
34 basis(ki) = 1
if (ind .eq. 1) go to 100
!
!          CALCULATION OF XB AND BI WHEN IND = 0
!
rerr = rerrmn
do j = 1,m
   xb(j) = b0(j)
   do 40 i = 1,m
40 bi(i,j) = 0.0
   bi(j,j) = 1.0
end do
if (numge .eq. 0) go to 630
jmin = numle + 1
do j = jmin,ms
   xb(j) = -xb(j)
   bi(j,j) = -1.0
end do
go to 601
!
!                  REORDER THE BASIS
!
100 ibeg = 1
iend = m
do 102 i = 1,m
   if (ibasis(i) .le. n0) go to 101
      index(ibeg) = ibasis(i)
      ibeg = ibeg + 1
      go to 102
101 index(iend) = ibasis(i)
   iend = iend - 1
102 continue
if (iend .eq. m) go to 22
do 103 i = 1,m
103 ibasis(i) = index(i)
!
!            REINVERSION OF THE BASIS MATRIX
!
do 132 j = 1,m
   kj = ibasis(j)
   if (kj .le. n0) go to 110
   if (kj .le. ns) go to 120
   if (kj .le. n) go to 130
   go to 120
!
110 do 111 i = 1,m
111 bi(i,j) = 0.0
   lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   if (lmin .gt. lmax) go to 132
   do 112 ll = lmin,lmax
      l = jta(ll)
112 bi(l,j) = ta(ll)
   go to 132
!
120 l = kj - n0
   do 121 i = 1,m
121 bi(i,j) = 0.0
   bi(l,j) = 1.0
   go to 132
!
130 l = kj - n0
   do 131 i = 1,m
131 bi(i,j) = 0.0
   bi(l,j) = -1.0
132 continue
!
icount = 0
call crout1 (bi, m, m, iend, index, y, jcol, ierr)
if (ierr .ne. 0) go to 580
!
!         CHECK THE ACCURACY OF BI AND RESET RERR
!
bnorm = 0.0
do 142 j = 1,m
   kj = ibasis(j)
   if (kj .le. n0) go to 140
      sum = 1.0
      go to 142
140 sum = 0.0
   lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   do 141 ll = lmin,lmax
141 sum = sum + abs(ta(ll))
142 bnorm = amax1(bnorm,sum)
!
binorm = 0.0
do j = 1,m
   sum = 0.0
   do 150 i = 1,m
150 sum = sum + abs(bi(i,j))
   binorm = amax1(binorm,sum)
end do
rerr = amax1(rerrmn,eps0*bnorm*binorm)
if (rerr .gt. 1.e-2) go to 580
bflag = 0
!
!                 RECALCULATION OF XB
!
180 do i = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do 182 l = 1,m
      dt = bi(i,l)*b0(l)
      if (dt .gt. 0.d0) go to 181
         dsumn = dsumn + dt
         go to 182
181 dsump = dsump + dt
182 continue
   xb(i) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*amax1(s,-t)
   if (abs(xb(i)) .lt. tol) xb(i) = 0.0
end do
go to 601
!
!     FIND THE NEXT VECTOR A(--,JP) TO BE INSERTED INTO
!                       THE BASIS
!
200 jp = 0
rmin = 0.0
if (nstep .eq. 3) rmin = -rtol
do 201 j = 1,n0
   if (basis(j) .ne. 0) go to 201
   if (r(j) .ge. rmin) go to 201
   jp = j
   rmin = r(j)
201 continue
if (n0 .eq. n) go to 203
jmin = n0 + 1
rmin = rmin*1.1
do 202 j = jmin,n
   if (basis(j) .ne. 0) go to 202
   if (r(j) .ge. rmin) go to 202
   jp = j
   rmin = r(j)
202 continue
203 if (jp .ne. 0) go to 300
if (nstep - 2) 800,230,250
!
!     INSERT THE VALUES OF THE ORGINAL, SLACK, AND SURPLUS
!             VARIABLES INTO R. THEN TERMINATE.
!
220 do 221 j = 1,n
221 r(j) = 0.0
do i = 1,m
   ki = ibasis(i)
   if (ki .le. n) r(ki) = xb(i)
end do
return
!
!             COMPLETION OF THE NSTEP = 2 CASE
!
230 do 231 i = 1,m
   if (ibasis(i) .le. n) go to 231
   if (xb(i) .gt. 0.0) go to 800
231 continue
go to 680
!
240 if (icount .ge. 5) go to 100
ind = 1
go to 220
!
!             COMPLETION OF THE NSTEP = 3 CASE
!
250 if (rerr .gt. 1.e-2) go to 251
   ind = 0
   go to 800
251 if (icount .ge. 5) go to 100
ind = 6
go to 800
!
!     IF MXITER ITERATIONS HAVE NOT BEEN PERFORMED THEN
!     BEGIN THE NEXT ITERATION. COMPUTE THE JP-TH COLUMN
!               OF BI*A AND STORE IT IN Y.
!
300 if (iter .lt. mxiter) go to 301
   ind = 2
   go to 220
301 iter = iter + 1
icount = icount + 1
if (jp .gt. ns) go to 330
if (jp .gt. n0) go to 320
!
lmin = ita(jp)
lmax = ita(jp + 1) - 1
if (lmin .le. lmax) go to 305
   ind = 4
   go to 220
305 amax = 0.0
do ll = lmin,lmax
   amax = amax1(abs(ta(ll)),amax)
end do
!
310 rerr1 = rerrmx*amax
do 313 i = 1,m
   dsum = 0.d0
   do ll = lmin,lmax
      l = jta(ll)
      dsum = dsum + dble(bi(i,l)*ta(ll))
   end do
   y(i) = dsum
   if (abs(y(i)) .ge. 5.e-3) go to 313
   bmax = 0.0
   do l = 1,m
      bmax = amax1(abs(bi(i,l)),bmax)
   end do
   tol = rerr1*bmax
   if (abs(y(i)) .lt. tol) y(i) = 0.0
313 continue
go to 350
!
320 l = jp - n0
do i = 1,m
   y(i) = bi(i,l)
end do
go to 350
!
330 l = jp - n0
do i = 1,m
   y(i) = -bi(i,l)
end do
!
350 do i = 1,m
   if (y(i) .ne. 0.0) go to 360
end do
r(jp) = 0.0
iter = iter - 1
icount = icount - 1
go to 200
!
360 if (nstep - 2) 400,430,440
!
!     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
!               FOR THE NSTEP = 1 CASE
!
400 npos = 0
ip = 0
eps = 0.0
epsi = xmax
do 403 i = 1,m
   if (xb(i) .lt. 0.0 .or. y(i) .le. 0.0) go to 403
   ratio = xb(i)/y(i)
   if (ratio - epsi) 401,402,403
401 epsi = ratio
   npos = 1
   index(1) = i
   go to 403
402 npos = npos + 1
   index(npos) = i
403 continue
if (npos .eq. 0) go to 420
if (epsi .eq. 0.0) go to 460
!
do 410 i = 1,m
   if (xb(i) .ge. 0.0 .or. y(i) .ge. 0.0) go to 410
   ratio = xb(i)/y(i)
   if (ratio .gt. epsi) go to 410
   if (ratio .lt. eps) go to 410
   eps = ratio
   ip = i
410 continue
if (ip .ne. 0) go to 500
go to 460
!
420 do 421 i = 1,m
   if (xb(i) .ge. 0.0 .or. y(i) .ge. 0.0) go to 421
   ratio = xb(i)/y(i)
   if (ratio .lt. eps) go to 421
   eps = ratio
   ip = i
421 continue
go to 500
!
!     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
!               FOR THE NSTEP = 2 CASE
!
430 npos = 0
epsi = xmax
do 433 i = 1,m
   if (y(i) .le. 0.0) go to 433
   ratio = xb(i)/y(i)
   if (ratio - epsi) 431,432,433
431 epsi = ratio
   npos = 1
   index(1) = i
   go to 433
432 npos = npos + 1
   index(npos) = i
433 continue
go to 450
!
!     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
!               FOR THE NSTEP = 3 CASE
!
440 npos = 0
epsi = xmax
do 445 i = 1,m
   if (y(i)) 441,445,442
441 if (ibasis(i) .le. n) go to 445
   ip = i
   go to 500
442 ratio = xb(i)/y(i)
   if (ratio - epsi) 443,444,445
443 epsi = ratio
      npos = 1
      index(1) = i
      go to 445
444 npos = npos + 1
      index(npos) = i
445 continue
!
450 if (npos .ne. 0) go to 460
if (icount .ge. 5) go to 100
ind = 4
go to 220
!
!              TIE BREAKING PROCEDURE
!
460 ip = index(1)
if (npos .eq. 1) go to 500
ip = 0
bmin = xmax
cmin = xmax
do 464 ii = 1,npos
   i = index(ii)
   l = ibasis(i)
   if (l .gt. n0) go to 461
      if (c(l) .le. 0.0) cmin = amin1(0.0,cmin)
      if (c(l) .gt. cmin) go to 464
      imin = i
      cmin = c(l)
      go to 464
461 if (l .le. n) go to 462
      ip = i
      go to 500
462 lrow = l - n0
   s = b0(lrow)
   if (lrow .gt. numle) go to 463
      if (s .gt. bmin) go to 464
      ip = i
      bmin = s
      go to 464
463 s = -s
   bmin = amin1(0.0,bmin)
   if (s .gt. bmin) go to 464
   ip = i
   bmin = s
464 continue
if (cmin .le. 0.0 .or. ip .eq. 0) ip = imin
!
!               TRANSFORMATION OF XB
!
500 if (xb(ip) .eq. 0.0) go to 510
const = xb(ip)/y(ip)
do 501 i = 1,m
   s = xb(i)
   xb(i) = xb(i) - const*y(i)
   if (xb(i) .ge. 0.0) go to 501
   if (s .ge. 0.0 .or. xb(i) .ge. rerrmx*s) xb(i) = 0.0
501 continue
xb(ip) = const
!
!               TRANSFORMATION OF BI
!
510 do 512 j = 1,m
   if (bi(ip,j) .eq. 0.0) go to 512
   const = bi(ip,j)/y(ip)
   do 511 i = 1,m
511 bi(i,j) = bi(i,j) - const*y(i)
   bi(ip,j) = const
512 continue
!
!             UPDATING IBASIS AND BASIS
!
iout = ibasis(ip)
ibasis(ip) = jp
basis(iout) = 0
basis(jp) = 1
if (iout .gt. n) num = num - 1
!
!        CHECK THE ACCURACY OF BI AND RESET RERR
!
if (rerr .gt. 1.e-2) go to 530
k = 0
do 521 j = 1,m
   kj = ibasis(j)
   if (kj .gt. n0) go to 521
   sum = 0.0
   lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   do ll = lmin,lmax
      l = jta(ll)
      sum = sum + bi(j,l)*ta(ll)
   end do
   rerr = amax1(rerr,abs(1.0-sum))
   k = k + 1
   if (k .ge. mcheck) go to 522
521 continue
522 if (rerr .le. 1.e-2) go to 600
!
!        THE ACCURACY CRITERIA ARE NOT SATISFIED
!
530 if (icount .lt. 5) go to 600
bflag = 1
go to 100
!
580 if (iter .eq. 0) go to 12
if (bflag .eq. 0) go to 590
bflag = 0
do ip = 1,m
   if (jp .eq. ibasis(ip)) go to 582
end do
582 ibasis(ip) = iout
basis(jp) = 0
basis(iout) = 1
if (iout .gt. n) num = num + 1
go to 100
!
590 ind = 3
go to 220
!
!       SET UP THE R ARRAY FOR THE NSTEP = 1 CASE
!
600 if (nstep - 2) 601,630,700
601 do j = 1,m
   if (xb(j) .lt. 0.0) go to 610
end do
go to 630
!
610 nstep = 1
m0 = 0
do 611 l = 1,m
   if (xb(l) .ge. 0.0) go to 611
   m0 = m0 + 1
   index(m0) = l
611 continue
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do 622 ll = 1,m0
      l = index(ll)
      if (bi(l,j)) 620,622,621
620 dsumn = dsumn + dble(bi(l,j))
      go to 622
621 dsump = dsump + dble(bi(l,j))
622 continue
   y(j) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*amax1(s,-t)
   if (abs(y(j)) .lt. tol) y(j) = 0.0
end do
go to 650
!
!       SET UP THE R ARRAY FOR THE NSTEP = 2 CASE
!
630 if (n .eq. num) go to 680
nstep = 2
m0 = 0
do 631 l = 1,m
   if (ibasis(l) .le. n) go to 631
   m0 = m0 + 1
   index(m0) = l
631 continue
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do 642 ll = 1,m0
      l = index(ll)
      if (bi(l,j)) 640,642,641
640 dsumn = dsumn + dble(bi(l,j))
      go to 642
641 dsump = dsump + dble(bi(l,j))
642 continue
   y(j) = -(dsump + dsumn)
   s = dsump
   t = dsumn
   tol = rerrmx*amax1(s,-t)
   if (abs(y(j)) .lt. tol) y(j) = 0.0
end do
!
650 do 652 j = 1,n0
   sum = 0.0
   if (basis(j) .ne. 0) go to 652
   lmin = ita(j)
   lmax = ita(j + 1) - 1
   if (lmin .gt. lmax) go to 652
   do ll = lmin,lmax
      l = jta(ll)
      sum = sum + y(l)*ta(ll)
   end do
652 r(j)=sum
!
660 if (n0 .eq. ns) go to 670
jmin = n0 + 1
do 661 j = jmin,ns
   r(j) = 0.0
   if (basis(j) .ne. 0) go to 661
   jj = j - n0
   r(j) = y(jj)
661 continue
!
670 if (ns .eq. n) go to 200
jmin = ns + 1
do 671 j = jmin,n
   r(j) = 0.0
   if (basis(j) .ne. 0) go to 671
   jj = j - n0
   r(j) = -y(jj)
671 continue
go to 200
!
!      SET UP A NEW R ARRAY FOR THE NSTEP = 3 CASE
!
680 nstep = 3
do 682 j = 1,m
   dsum = 0.d0
   do l = 1,m
      il = ibasis(l)
      if (il .le. n0) dsum = dsum + dble(c(il)*bi(l,j))
   end do
682 y(j) = dsum
!
do 691 j = 1,n0
   r(j) = 0.0
   if (basis(j) .ne. 0) go to 691
   dsum = -c(j)
   lmin = ita(j)
   lmax = ita(j + 1) - 1
   r(j) = -c(j)
   if (lmin .gt. lmax) go to 691
   do ll = lmin,lmax
      l = jta(ll)
      dsum = dsum + dble(y(l)*ta(ll))
   end do
   r(j) = dsum
   if (r(j) .ge. 0.0) go to 691
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) .lt. tol) r(j) = 0.0
691 continue
go to 660
!
!       UPDATE THE R ARRAY FOR THE NSTEP = 3 CASE
!
700 const = r(jp)
do 703 j = 1,n0
   if (basis(j) .eq. 0) go to 701
      r(j) = 0.0
      go to 703
701 sum = 0.0
   lmin = ita(j)
   lmax = ita(j + 1) - 1
   if (lmin .gt. lmax) go to 703
   do ll = lmin,lmax
      l = jta(ll)
      sum = sum + bi(ip,l)*ta(ll)
   end do
   r(j) = r(j) - const*sum
   if (r(j) .ge. 0.0) go to 703
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) .lt. tol) r(j) = 0.0
703 continue
!
710 if (n0 .eq. ns) go to 720
jmin = n0 + 1
do 712 j = jmin,ns
   if (basis(j) .eq. 0) go to 711
      r(j) = 0.0
      go to 712
711 jj = j - n0
   r(j) = r(j) - const*bi(ip,jj)
712 continue
!
720 if (ns .eq. n) go to 200
jmin = ns + 1
do 722 j = jmin,n
   if (basis(j) .eq. 0) go to 721
      r(j) = 0.0
      go to 722
721 jj = j - n0
   r(j) = r(j) + const*bi(ip,jj)
722 continue
go to 200
!-----------------------------------------------------------------------
!               REFINE XB AND STORE THE RESULT IN Y
!-----------------------------------------------------------------------
800 do i = 1,m
   r(i) = 0.0
   y(i) = 0.0
end do
!
do 831 j = 1,m
   kj = ibasis(j)
   if (kj .le. n0) go to 810
   if (kj .le. ns) go to 820
   if (kj .le. n) go to 830
   go to 820
!
810 lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   do ll = lmin,lmax
      l = jta(ll)
      dt = dble(r(l)) + dble(y(l))
      dt = dt + dble(ta(ll)*xb(j))
      r(l) = dt
      y(l) = dt - dble(r(l))
   end do
   go to 831
!
820 l = kj - n0
   dt = dble(r(l)) + dble(y(l))
   dt = dt + dble(xb(j))
   r(l) = dt
   y(l) = dt - dble(r(l))
   go to 831
!
830 l = kj - n0
   dt = dble(r(l)) + dble(y(l))
   dt = dt - dble(xb(j))
   r(l) = dt
   y(l) = dt - dble(r(l))
831 continue
!
do i = 1,m
   dt = dble(r(i)) + dble(y(i))
   r(i) = dble(b0(i)) - dt
end do
!
850 rerr1 = amin1(rerrmx,rerr)
do 856 i = 1,m
   y(i) = 0.0
   if (xb(i)) 851,856,852
851 sgn = -1.0
   dsump = 0.d0
   dsumn = xb(i)
   go to 853
852 sgn = 1.0
   dsump = xb(i)
   dsumn = 0.d0
853 do 855 l = 1,m
      dt = bi(i,l)*r(l)
      if (dt .gt. 0.d0) go to 854
         dsumn = dsumn + dt
         go to 855
854 dsump = dsump + dt
855 continue
   w = dsump + dsumn
   if (w .eq. 0.0) go to 856
   if (sgn .ne. sign(1.0,w)) go to 856
   s = dsump
   t = dsumn
   tol = rerr1*amax1(s,-t)
   if (abs(w) .gt. tol) y(i) = w
856 continue
if (nstep - 2) 860,870,880
!
!         CHECK THE REFINEMENT (NSTEP = 1)
!
860 do 861 i = 1,m
   if (y(i) .ge. 0.0) go to 861
   if (y(i) .lt. -rerrmx) go to 240
   y(i) = 0.0
861 xb(i) = y(i)
go to 630
!
!         CHECK THE REFINEMENT (NSTEP = 2)
!
870 do 871 i = 1,m
   if (ibasis(i) .le. n) go to 871
   if (y(i) .gt. rerrmx) go to 240
   y(i) = 0.0
871 xb(i) = y(i)
go to 680
!
!              COMPUTE Z  (NSTEP = 3)
!
880 dsum = 0.d0
do 881 i = 1,m
   ki = ibasis(i)
   if (ki .gt. n0) go to 881
   dsum = dsum + dble(c(ki)*y(i))
881 xb(i) = y(i)
z = dsum
go to 220
end subroutine ssplx1

subroutine crout1(a,ka,n,iend,index,temp,jp,ierr)
implicit none
integer, intent(in) :: iend
integer, intent(inout) :: ierr, index(*), jp
integer, intent(in) :: ka, n
real, intent(inout) :: a(*), temp(n)
integer :: i, ibeg, ij, ik, il, j, jcol, jj, k, kcol, kcount, kj, &
&kj0, kk, kl, km1, kp1, l, lj, lj0, lk, lmin, max, mcol, ncol, nk, &
&nm1, nmj, nmk, nn
real :: c, pmin, s
!     ******************************************************************
!     CROUT PROCEDURE FOR INVERTING MATRICES
!     ******************************************************************
!     A IS A MATRIX OF ORDER N WHERE N IS GREATER THAN OR EQUAL TO 1.
!     THE INVERSE OF A IS COMPUTED AND STORED IN A.
!
!     KA = LENGTH OF THE COLUMNS OF THE ARRAY A
!     JP = THE NUMBER OF THE COLUMN THAT CONTAINS THE SMALLEST PIVOT
!
!     IEND MAY BE 0,1,...,N-1.  IT IS ASSUMED THAT EACH OF THE FIRST
!     IEND COLUMNS OF THE MATRIX A CONTAINS ONLY ONE NONZERO ELEMENT
!     AND THAT THE NONZERO ELEMENT IS 1 OR -1.
!
!     INDEX IS AN ARRAY OF DIMENSION N-1 OR LARGER THAT IS USED BY THE
!     ROUTINE FOR KEEPING TRACK OF THE ROW INTERCHANGES THAT ARE MADE.
!
!     TEMP IS A TEMPORARY STORAGE ARRAY.
!
!     IERR REPORTS THE STATUS OF THE RESULTS. IF A IS NONSINGULAR THEN
!     THE INVERSE OF A IS COMPUTED AND IERR=0. OTHERWISE IF A IS FOUND
!     TO BE SINGULAR THEN IERR=1 AND THE ROUTINE TERMINATES.
!     --------------------
double precision :: dsum
max = ka*n
mcol = iend*ka
if (iend .eq. 0) go to 100
!
!           PROCESS THE FIRST IEND COLUMNS OF A
!
kcol = 0
do 32 k = 1,iend
kk = kcol + k
nk = kcol + n
do 10 lk = kk,nk
if (a(lk)) 20,10,30
10 continue
jp = k
go to 300
!
20 l = lk - kcol
lj0 = mcol + l
do 21 lj = lj0,max,ka
21 a(lj) = -a(lj)
!
30 l = lk - kcol
index(k) = l
if (k .eq. l) go to 32
lj = lk
do 31 kj = kk,max,ka
c = a(kj)
a(kj) = a(lj)
a(lj) = c
31 lj = lj + ka
32 kcol = kcol + ka
!
!           PROCESS THE REMAINING COLUMNS OF A
!
100 nm1 = n - 1
jp = 1
ierr = 0
pmin = 0.0
ibeg = iend + 1
if (ibeg .eq. n) go to 190
!
k = ibeg
km1 = iend
kp1 = k + 1
kcol = mcol
kk = kcol + k
do kcount = ibeg,nm1
!
!     SEARCH FOR THE K-TH PIVOT ELEMENT (K=IBEG,...,N-1)
!
l = k
s = abs(a(kk))
do 110 i = kp1,n
ik = kcol + i
c = abs(a(ik))
if (s .ge. c) go to 110
l = i
s = c
110 continue
!
if (k.gt.ibeg .and. s.ge.pmin) go to 120
jp = k
pmin = s
if (s .eq. 0.0) go to 300
!
!              INTERCHANGING ROWS K AND L
!
120 index(k) = l
if (k .eq. l) go to 130
kj0 = mcol + k
lj  = mcol + l
do 121 kj = kj0,max,ka
c = a(kj)
a(kj) = a(lj)
a(lj) = c
121 lj = lj + ka
!
!       COMPUTE THE K-TH ROW OF U (K=IBEG,...,N-1)
!
130 c = a(kk)
if (k .gt. ibeg) go to 140
kj0 = kk + ka
do 131 kj = kj0,max,ka
131 a(kj) = a(kj)/c
go to 160
!
140 kl = mcol + k
do 141 l = ibeg,km1
temp(l) = a(kl)
141 kl = kl + ka
!
kj0 = kk + ka
do 151 kj = kj0,max,ka
jcol = kj - k
dsum = -a(kj)
  do 150 l = ibeg,km1
  lj = jcol + l
150 dsum = dsum + dble(temp(l))*dble(a(lj))
151 a(kj) = sngl(-dsum)/c
!
!      COMPUTE THE K-TH COLUMN OF L (K=IBEG+1,...,N)
!
160 km1 = k
k = kp1
kp1 = k + 1
kcol = kcol + ka
kk = kcol + k
do 161 l = ibeg,km1
lk = kcol + l
161 temp(l) = a(lk)
!
do 171 i = k,n
il = mcol + i
dsum = 0.d0
  do 170 l = ibeg,km1
  dsum = dsum + dble(a(il))*dble(temp(l))
170 il = il + ka
171 a(il) = dble(a(il)) - dsum
end do
!
!           CHECK THE N-TH PIVOT ELEMENT
!
190 ncol = max - ka
nn = ncol + n
c = abs(a(nn))
if (c .gt. pmin) go to 200
jp = n
if (c .eq. 0.0) go to 300
!
!          REPLACE L WITH THE INVERSE OF L
!
200 if (ibeg .eq. n) go to 213
jj = mcol + ibeg
i = ka + 1
do 212 j = ibeg,nm1
a(jj) = 1.0/a(jj)
temp(j) = a(jj)
kj = jj
  do 211 km1 = j,nm1
  k = km1 + 1
  kj = kj + 1
  dsum = 0.d0
  kl = kj
    do 210 l = j,km1
    dsum = dsum + dble(a(kl)*temp(l))
210 kl = kl + ka
  a(kj) = sngl(-dsum)/a(kl)
211 temp(k) = a(kj)
212 jj = jj + i
213 a(nn) = 1.0/a(nn)
if (n .eq. 1) return
!
!       SOLVE UX = Y WHERE Y IS THE INVERSE OF L
!
do nmk = 1,nm1
k = n - nmk
lmin = max0(ibeg,k+1)
kl = (lmin-1)*ka + k
  do 230 l = lmin,n
  temp(l) = a(kl)
  a(kl) = 0.0
230 kl = kl + ka
!
kj0 = mcol + k
  do 241 kj = kj0,max,ka
  dsum = -a(kj)
  lj = (kj - k) + lmin
    do 240 l = lmin,n
    dsum = dsum + dble(temp(l)*a(lj))
240 lj = lj + 1
241 a(kj) = -dsum
end do
!
!                 COLUMN INTERCHANGES
!
jcol = ncol - ka
do 251 nmj = 1,nm1
j = n - nmj
k = index(j)
if (j .eq. k) go to 251
ij = jcol
ik = (k-1)*ka
  do 250 i = 1,n
  ij = ij + 1
  ik = ik + 1
  c = a(ij)
  a(ij) = a(ik)
250 a(ik) = c
251 jcol = jcol - ka
return
!
!                    ERROR RETURN
!
300 ierr = 1
return
end subroutine crout1

subroutine assgn (n,a,c,t,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer :: i1, i2, i3, i4, i5, i6
!     -------------------
!     SOLUTION OF THE ASSIGNMENT PROBLEM
!     -------------------
integer, intent(inout) :: a(n,*), c(n), t, iwk(*)
!
i1 = n + 1
i2 = i1 + n
i3 = i2 + n
i4 = i3 + n + 1
i5 = i4 + n
i6 = i5 + n
call assgn1(n,a,c,t,iwk(1),iwk(i1),iwk(i2),iwk(i3),iwk(1), &
&iwk(i3),iwk(i4),iwk(i5),iwk(i6),ierr)
return
end subroutine assgn

subroutine assgn1(n,a,c,t,ch,lc,lr,lz,nz,rh,slc,slr, &
&u,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: n
integer :: i, j, k, kslc, kslr, l, lj, lm, m, maxnum, mm, nl, nm, &
&np1
integer :: ipmpar
integer, intent(inout) :: a(n,*), c(n), ch(n), lc(n), lr(n), &
&lz(n), nz(n), rh(*), slc(n), slr(n), u(*)
integer :: h, q, r, s
integer, intent(inout) :: t
!
! THIS SUBROUTINE SOLVES THE SQUARE ASSIGNMENT PROBLEM
! THE MEANING OF THE INPUT PARAMETERS IS
! N = NUMBER OF ROWS AND COLUMNS OF THE COST MATRIX
! A(I,J) = ELEMENT IN ROW I AND COLUMN J OF THE COST MATRIX
! ( AT THE END OF COMPUTATION THE ELEMENTS OF A ARE CHANGED)
! THE MEANING OF THE OUTPUT PARAMETERS IS
! C(J) = ROW ASSIGNED TO COLUMN J (J=1,N)
! T = COST OF THE OPTIMAL ASSIGNMENT
! ALL PARAMETERS ARE INTEGER
! THE MEANING OF THE LOCAL VARIABLES IS
! A(I,J) = ELEMENT OF THE COST MATRIX IF A(I,J) IS POSITIVE,
!          COLUMN OF THE UNASSIGNED ZERO FOLLOWING IN ROW I
!          (I=1,N) THE UNASSIGNED ZERO OF COLUMN J (J=1,N)
!          IF A(I,J) IS NOT POSITIVE
! A(I,N+1) = COLUMN OF THE FIRST UNASSIGNED ZERO OF ROW I
!            (I=1,N)
! CH(I) = COLUMN OF THE NEXT UNEXPLORED AND UNASSIGNED ZERO
!         OF ROW I (I=1,N)
! LC(J) = LABEL OF COLUMN J (J=1,N)
! LR(I) = LABEL OF ROW I (I=1,N)
! LZ(I) = COLUMN OF THE LAST UNASSIGNED ZERO OF ROW I(I=1,N)
! NZ(I) = COLUMN OF THE NEXT UNASSIGNED ZERO OF ROW I(I=1,N)
! RH(I) = UNEXPLORED ROW FOLLOWING THE UNEXPLORED ROW I
!         (I=1,N)
! RH(N+1) = FIRST UNEXPLORED ROW
! SLC(K) = K-TH ELEMENT CONTAINED IN THE SET OF THE LABELLED
!          COLUMNS
! SLR(K) = K-TH ELEMENT CONTAINED IN THE SET OF THE LABELLED
!          ROWS
! U(I) = UNASSIGNED ROW FOLLOWING THE UNASSIGNED ROW I
!        (I=1,N)
! U(N+1) = FIRST UNASSIGNED ROW
! IERR = 0 IF THE ROUTINE TERMINATES SUCCESSFULLY. OTHERWISE
!          IERR = 1
!
! THE VECTORS C,CH,LC,LR,LZ,NZ,SLC,SLR MUST BE DIMENSIONED
! AT LEAST AT (N), THE VECTORS RH,U AT  LEAST AT (N+1),
! AND THE MATRIX A AT LEAST AT (N,N+1). TO SAVE STORAGE
! LZ AND RH MAY USE THE SAME STORAGE AREA, AND NZ AND CH
! MAY USE THE SAME STORAGE AREA.
!
! INITIALIZATION
maxnum = ipmpar(3)
ierr = 0
np1 = n+1
do j=1,n
  c(j) = 0
  lz(j) = 0
  nz(j) = 0
  u(j) = 0
end do
u(np1) = 0
t = 0
! REDUCTION OF THE INITIAL COST MATRIX
do 40 j = 1,n
  s = a(1,j)
  do l=2,n
    if ( a(l,j) .lt. s ) s = a(l,j)
  end do
  if (s) 20,40,30
20 mm = maxnum + s
  if (t .lt. -mm) go to 400
  t = t + s
  do i = 1,n
    if (a(i,j) .gt. mm) go to 400
    a(i,j) = a(i,j) - s
  end do
  go to 40
30 mm = maxnum - s
  if (t .gt. mm) go to 400
  t = t + s
  do i = 1,n
    a(i,j) = a(i,j) - s
  end do
40 continue
do i=1,n
  q = a(i,1)
  do l=2,n
    if ( a(i,l) .lt. q ) q = a(i,l)
  end do
  mm = maxnum - q
  if (t .gt. mm) go to 400
  t = t + q
  l = np1
  do 60 j = 1,n
    a(i,j) = a(i,j)-q
    if ( a(i,j) .ne. 0 ) go to 60
    a(i,l) = -j
    l = j
60 continue
end do
! CHOICE OF THE INITIAL SOLUTION
k = np1
do 140 i = 1,n
  lj = np1
  j = -a(i,np1)
80 if ( c(j) .eq. 0 ) go to 130
  lj = j
  j = -a(i,j)
  if ( j .ne. 0 ) go to 80
  lj = np1
  j = -a(i,np1)
90 r = c(j)
  lm = lz(r)
  m = nz(r)
100 if ( m .eq. 0 ) go to 110
  if ( c(m) .eq. 0 ) go to 120
  lm = m
  m = -a(r,m)
  go to 100
110 lj = j
  j = -a(i,j)
  if ( j .ne. 0 ) go to 90
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
! RESEARCH OF A NEW ASSIGNMENT
150 if ( u(np1) .eq. 0 ) return
do i=1,n
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
if ( a(r,np1) .eq. 0 ) go to 220
170 l = -a(r,np1)
if ( a(r,l) .eq. 0 ) go to 180
if ( rh(r) .ne. 0 ) go to 180
rh(r) = rh(np1)
ch(r) = -a(r,l)
rh(np1) = r
180 if ( lc(l) .eq. 0 ) go to 200
if ( rh(r) .eq. 0 ) go to 210
190 l = ch(r)
ch(r) = -a(r,l)
if ( a(r,l) .ne. 0 ) go to 180
rh(np1) = rh(r)
rh(r) = 0
go to 180
200 lc(l) = r
if ( c(l) .eq. 0 ) go to 360
kslc = kslc+1
slc(kslc) = l
r = c(l)
lr(r) = l
kslr = kslr+1
slr(kslr) = r
if ( a(r,np1) .ne. 0 ) go to 170
210 continue
if ( rh(np1) .gt. 0 ) go to 350
! REDUCTION OF THE CURRENT COST MATRIX
220 h = maxnum
do 240 j = 1,n
  if ( lc(j) .ne. 0 ) go to 240
  do k=1,kslr
    i = slr(k)
    if ( a(i,j) .lt. h ) h = a(i,j)
  end do
240 continue
mm = maxnum - h
if (mm .eq. 0 .or. t .gt. mm) go to 400
t = t + h
do 290 j = 1,n
  if ( lc(j) .ne. 0 ) go to 290
  do 280 k = 1,kslr
    i = slr(k)
    a(i,j) = a(i,j)-h
    if ( a(i,j) .ne. 0 ) go to 280
    if ( rh(i) .ne. 0 ) go to 250
    rh(i) = rh(np1)
    ch(i) = j
    rh(np1) = i
250 l = np1
260 nl = -a(i,l)
    if ( nl .eq. 0 ) go to 270
    l = nl
    go to 260
270 a(i,l) = -j
280 continue
290 continue
if ( kslc .eq. 0 ) go to 350
do 340 i = 1,n
  if ( lr(i) .ne. 0 ) go to 340
  do 330 k = 1,kslc
    j = slc(k)
    if ( a(i,j) .gt. 0 ) go to 320
    l = np1
300 nl = - a(i,l)
    if ( nl .eq. j ) go to 310
    l = nl
    go to 300
310 a(i,l) = a(i,j)
    a(i,j) = h
    go to 330
320 mm = maxnum - h
    if (a(i,j) .gt. mm) go to 400
    a(i,j) = a(i,j) + h
330 continue
340 continue
350 r = rh(np1)
go to 190
! ASSIGNMENT OF A NEW ROW
360 c(l) = r
m = np1
370 nm = -a(r,m)
if ( nm .eq. l ) go to 380
m = nm
go to 370
380 a(r,m) = a(r,l)
a(r,l) = 0
if ( lr(r) .lt. 0 ) go to 390
l = lr(r)
a(r,l) = a(r,np1)
a(r,np1) = -l
r = lc(l)
go to 360
390 u(np1) = u(r)
u(r) = 0
go to 150
! ERROR RETURN - INTEGER OVERFLOW OCCURS
400 ierr = 1
return
end subroutine assgn1

subroutine mkp (n,m,p,w,k,bck,xstar,vstar,wk,iwk,num)
implicit none
integer, intent(in) :: m, n, num
integer :: i, isumw, j, jj, jn, jnn, l, lx, lxi, maxw, minw, mn, &
&n5, np1, npl
real :: ap, aw
!
! SUBROUTINE TO SOLVE A 0-1 MULTIPLE KNAPSACK PROBLEM OF N
! ITEMS (WITH  N .GE. 2) AND  M  KNAPSACKS (WITH  M .GE. 1 ,
! I.E. ALSO SUITABLE FOR A 0-1 SINGLE KNAPSACK PROBLEM).
! THE PROBLEM TO BE SOLVED IS
!
! MAXIMIZE  VSTAR = P(1)*(X(1,1) + ... + X(M,1)) + ...
!                   ... + P(N)*(X(1,N) + ... + X(M,N))
! SUBJECT TO
! W(1)*X(I,1) + ... + W(N)*X(I,N) .LE. K(I)   FOR  I=1,...,M
! X(1,J) + ... + X(M,J) .LE. 1   FOR  J=1,...,N
! X(I,J) = 0 OR 1   FOR  I=1,...,M ,  J=1,...,N ,
!
! WHERE ALL P(J), W(J), AND K(I) ARE POSITIVE INTEGERS.
! BEFORE MKP IS CALLED, ARRAY K MUST BE SORTED SO THAT
! K(1) .LE. K(2) .LE. ... .LE. K(M) .
!
! MEANING OF THE INPUT PARAMETERS ...
!
! N    = NUMBER OF ITEMS.
! M    = NUMBER OF KNAPSACKS.
! P(J) = PROFIT OF ITEM  J  (J=1,...,N) .
! W(J) = WEIGHT OF ITEM  J  (J=1,...,N) .
! K(I) = CAPACITY OF KNAPSACK  I  (I=1,...,M) .
! BCK  = -1  IF EXACT SOLUTION IS REQUIRED.
!      = MAXIMUM NUMBER OF BACKTRACKINGS TO BE PERFORMED, IF
!        HEURISTIC SOLUTION IS REQUIRED.
! WK   = REAL WORK SPACE OF DIMENSION N.
! IWK  = WORK SPACE OF DIMENSION .GE. 5*M + 14*N + 4*M*N + 3
! NUM  = DIMENSION OF IWK
!
! MEANING OF THE OUTPUT PARAMETERS ...
!
! XSTAR(J) = 0  IF ITEM  J  IS NOT IN THE OPTIMAL SOLUTION
!               (I.E. IF  X(I,J) = 0  FOR ALL  I ).
!          = KNAPSACK WHERE ITEM  J  IS INSERTED, OTHERWISE
!            (I.E. IF  X(XSTAR(J),J) = 1 ).
! VSTAR    = VALUE OF THE OPTIMAL SOLUTION IF  VSTAR .GT. 0.
!          = ERROR CONDITION (INFEASIBILITY OR TRIVIALITY)
!            IN THE INPUT DATA IF  VSTAR .LT. 0 .
!            = -1  IF  N .LT. 2  OR  M .LT. 1 .
!            = -2  IF SOME  P(J) ,  W(J)  OR  K(I) ARE NOT
!                  POSITIVE.
!            = -3  IF A KNAPSACK CANNOT CONTAIN ANY ITEM.
!            = -4  IF AN ITEM CANNOT FIT INTO ANY KNAPSACK.
!            = -5  IF KNAPSACK  M  CONTAINS ALL THE ITEMS.
!            = -7  IF ARRAY  K IS NOT CORRECTLY SORTED.
!            = -8  IF NUM .LT. 5*M + 14*N + 4*M*N + 3.
!
!            (IN ALL THE ABOVE CASES ARRAY  XSTAR IS NOT
!            DEFINED).
!
! ALL THE PARAMETERS EXCEPT WK ARE OF INTEGER TYPE. WHEN MKP
! TERMINATES, ALL THE INPUT PARAMETERS ARE UNCHANGED EXCEPT
! BCK, WHICH GIVES THE NUMBER OF BACKTRACKINGS PERFORMED.
!
integer, intent(inout) :: p(n), w(n)
integer, intent(in) :: k(m)
integer, intent(inout) :: xstar(n), bck, vstar, iwk(num)
real, intent(inout) :: wk(n)
integer :: bb, bl, x, xl
integer :: b, ubb
integer :: f, pbl, q, v
integer :: bs, ps, ws, xs
!
!                    CHECK THE INPUT DATA
!
if (m .lt. 1 .or. n .lt. 2) go to 100
mn = m*n
if (num .lt. 5*m + 14*n + 4*mn + 3) go to 160
!
if (p(1) .le. 0 .or. w(1) .le. 0) go to 110
ap = p(1)
aw = w(1)
wk(1) = -ap/aw
maxw = w(1)
minw = w(1)
isumw = w(1)
do j = 2,n
   if (p(j) .le. 0 .or. w(j) .le. 0) go to 110
   ap = p(j)
   aw = w(j)
   wk(j) = -ap/aw
   if (w(j) .gt. maxw) maxw = w(j)
   if (w(j) .lt. minw) minw = w(j)
   isumw = isumw + w(j)
end do
!
if (k(1) .le. 0) go to 110
if (m .eq. 1) go to 30
do i = 2,m
   if (k(i) .le. 0) go to 110
   if (k(i) .lt. k(i-1)) go to 150
end do
!
30 if (minw .gt. k(1)) go to 120
if (maxw .gt. k(m)) go to 130
if (isumw .le. k(m)) go to 140
vstar = 0
!
!             REORDER THE ARRAYS P AND W SO THAT
!                P(J)/W(J) .GE. P(J+1)/W(J+1)
!
n5 = 5*n
do j = 1,n
   jj = n5 + j
   iwk(jj) = j
end do
call risort (wk, iwk(n5 + 1), n)
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
!                PARTITION THE WORK SPACE IWK
!
lx =  jj + 1
lxi = lx + n
bs = lxi + n
xs =  bs + n
ubb = xs + n
!
np1 = n + 1
b = ubb + n
ps = b  + np1
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
!                     SOLVE THE PROBLEM
!
call mkp1 (n, m, p, w, k, bck, xstar, vstar, np1, n5, &
&iwk(bb), iwk(bl), iwk(x), iwk(xl), &
&iwk(b), iwk(ubb), iwk(lx), iwk(lxi), &
&iwk(f), iwk(pbl), iwk(q), iwk(v), &
&iwk(bs), iwk(ps), iwk(ws), iwk(xs), iwk(1))
!
!           RESTORE THE INITIAL ORDERING TO P AND W,
!                AND REORDER XSTAR ACCORDINGLY
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
!                        ERROR RETURN
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
return
end subroutine mkp

subroutine mkp1 (n, m, p, w, k, bck, xstar, vstar, np1, n5, &
&bb, bl, x, xl, b, ubb, lx, lxi, &
&f, pbl, q, v, bs, ps, ws, xs, iwk)
implicit none
integer, intent(in) :: m, n, n5, np1
integer :: i, i1, ibv, iflag, ii, ip, ip1, iuv, j, jbck, jj, k1, &
&kub, lb, li, lj, lr, lri, lub, lubi, m1, n1
!
! MEANING OF THE MAIN INTERNAL VARIABLES AND ARRAYS ...
!
! I       = KNAPSACK CURRENTLY CONSIDERED.
! LB      = LOWER BOUND ON THE OPTIMAL SOLUTION.
! UB      = UPPER BOUND ON THE OPTIMAL SOLUTION.
! VB      = VALUE OF THE CURRENT SOLUTION.
! X(I,J)  = 1  IF ITEM  J  IS INSERTED IN KNAPSACK  I  IN
!              THE CURRENT SOLUTION.
!         = 0  OTHERWISE.
! F(I)    = POINTER TO THE LAST ITEM INSERTED IN KNAPSACK  I
!           ( = -1  IF KNAPSACK  I  IS EMPTY).
! BB(I,J) = POINTER TO THE ITEM INSERTED IN KNAPSACK  I
!           JUST BEFORE ITEM  J ( = -1  IF  J  IS THE FIRST
!           ITEM INSERTED IN KNAPSACK  I ).
! Q(I)    = CURRENT AVAILABLE CAPACITY OF KNAPSACK  I .
! B(J)    = 1  IF ITEM  J  IS NOT INSERTED IN ANY KNAPSACK.
!         = 0  IF ITEM  J  IS INSERTED IN A KNAPSACK.
! PBL(I)  = NUMBER OF THE ITEMS WHICH CAN BE INSERTED IN
!           KNAPSACK  I .
! BL(I,S) = POINTER TO THE  S-TH  ITEM WHICH CAN BE INSERTED
!           IN KNAPSACK  I .
! XL(I,J) = 1  IF ITEM  J  WAS INSERTED IN KNAPSACK  I  IN
!              THE LAST EXECUTION OF SUBROUTINE PI1.
!         = 0  OTHERWISE.
! IWK       WORK SPACE FOR THE SUBROUTINE SKNP.
!
integer, intent(in) :: p(n), w(n), k(m)
integer, intent(inout) :: xstar(n), bck, vstar
integer, intent(inout) :: bb(m,n), bl(m,np1), x(m,n), xl(m,n)
integer, intent(inout) :: b(np1), ubb(n), lx(n), lxi(n)
integer, intent(inout) :: f(m), pbl(m), q(m), v(m)
integer, intent(inout) :: bs(n), ps(np1), ws(np1), xs(n), iwk(n5)
integer :: s, u, ub, vb
!
if (m .eq. 1) go to 250
!
! STEP 1 (INITIALIZATION)
!
jbck = bck
bck = 0
kub = 0
n1 = n + 1
b(n1) = 1
m1 = m - 1
do j=1,n
  b(j) = 1
  do i=1,m
    x(i,j) = 0
    bb(i,j) = 0
  end do
end do
do i=1,m1
  q(i) = k(i)
  f(i) = -1
end do
q(m) = k(m)
vstar = 0
vb = 0
i = 1
call sigma1 (n,m,p,w,k,1,b,kub,ub,np1,n5,lx,lr, &
&bs,ps,ws,xs,iwk)
do j=1,n
  lxi(j) = lx(j)
end do
lri = lr
lubi = ub
iflag = 0
!
! STEP 2 (HEURISTIC)
!
70 kub = vstar - vb
call pi1 (n,m,p,w,q,i,b,bb,kub,bl,lb,pbl,v,xl, &
&np1,n5,bs,ps,ws,xs,iwk)
if ( lb + vb .le. vstar ) go to 140
vstar = lb + vb
do 90 j = 1,n
  xstar(j) = 0
  do 80 s = 1,i
    if ( x(s,j) .eq. 0 ) go to 80
    xstar(j) = s
    go to 90
80 continue
90 continue
ip = pbl(i)
if ( ip .eq. 0 ) go to 110
do j=1,ip
  jj = bl(i,j)
  if ( xl(i,j) .eq. 1 ) xstar(jj) = i
end do
110 i1 = i + 1
do 130 ii = i1,m
  ip = pbl(ii)
  if ( ip .eq. 0 ) go to 130
  do j=1,ip
    jj = bl(ii,j)
    if ( xl(ii,j) .eq. 1 ) xstar(jj) = ii
  end do
130 continue
if ( ub .eq. lb ) go to 200
!
! STEP 3 (UPDATING)
!
140 if ( v(i) .eq. 0 ) go to 180
iuv = ub + vb
u = pbl(i)
ibv = 0
do 170 s = 1,u
  if ( xl(i,s) .eq. 0 ) go to 170
  j = bl(i,s)
  x(i,j) = 1
  q(i) = q(i) - w(j)
  vb = vb + p(j)
  b(j) = 0
  bb(i,j) = f(i)
  ubb(j) = iuv
  if ( iflag .eq. 1 ) go to 150
  lub = iuv
  lj = j
  li = i
150 f(i) = j
  ibv = ibv + p(j)
  if ( ibv .eq. v(i) ) go to 180
  call parc (i,i,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m,np1, &
&lx,lxi,lr,lri,lubi)
  if ( iflag .eq. 1 ) go to 160
  kub = vstar - vb
  call sigma1 (n,m,p,w,q,i,b,kub,ub,np1,n5,lx,lr, &
&bs,ps,ws,xs,iwk)
  lj = n1
160 iuv = ub + vb
  if ( iuv .le. vstar ) go to 200
170 continue
180 if ( i .eq. m - 1 ) go to 200
ip1 = i + 1
call parc (ip1,i,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m,np1, &
&lx,lxi,lr,lri,lubi)
if ( iflag .eq. 1 ) go to 190
kub = vstar - vb
call sigma1 (n,m,p,w,q,ip1,b,kub,ub,np1,n5,lx,lr, &
&bs,ps,ws,xs,iwk)
lj = n1
190 if ( ub + vb .le. vstar ) go to 200
i = i + 1
go to 140
!
! STEP 4 (BACKTRACKING)
!
200 if ( i .gt. 0 ) go to 210
bck = bck - 1
return
210 if ( bck .eq. jbck ) return
bck = bck + 1
if ( f(i) .ne. (-1) ) go to 230
do j=1,n
  bb(i,j) = 0
end do
i = i - 1
go to 200
230 j = f(i)
x(i,j) = 0
b(j) = 1
vb = vb - p(j)
q(i) = q(i) + w(j)
do s=1,n
  if ( bb(i,s) .eq. j ) bb(i,s) = 0
end do
f(i) = bb(i,j)
if ( ubb(j) .le. vstar ) go to 200
ub = ubb(j) - vb
iflag = 1
go to 70
!
! PARTICULAR CASE (0-1 SINGLE KNAPSACK PROBLEM)
!
250 k1 = k(1)
do j=1,n
  ps(j) = p(j)
  ws(j) = w(j)
end do
call sknp (n,k1,0,vstar,n,np1,n5,ps,ws,xs,iwk)
do j=1,n
  xstar(j) = xs(j)
end do
bck = 0
return
end subroutine mkp1

subroutine sigma1 (n,m,p,w,q,i,b,kub,ub,np1,n5,lx,lr, &
&bs,ps,ws,xs,iwk)
implicit none
integer, intent(in) :: i, kub
integer, intent(inout) :: lr
integer, intent(in) :: m, n, n5, np1
integer :: j, jj, ns
!
! SUBROUTINE TO COMPUTE AN UPPER BOUND  UB  ON THE BEST
! FINAL SOLUTION WHICH CAN BE OBTAINED FROM THE CURRENT
! SOLUTION.
!
integer, intent(in) :: p(n), w(n), q(m), b(np1)
integer, intent(inout) :: ub, iwk(n5)
integer, intent(inout) :: lx(n), bs(n), ps(np1), ws(np1), xs(n)
integer :: qs, sb
!
ns = 0
qs = 0
do j=i,m
  qs = qs + q(j)
end do
sb = 0
do 20 j = 1,n
  lx(j) = 0
  if ( b(j) .eq. 0 ) go to 20
  ns = ns + 1
  bs(ns) = j
  ps(ns) = p(j)
  ws(ns) = w(j)
  sb = sb + w(j)
20 continue
if ( sb .gt. qs ) go to 40
lr = qs - sb
ub = 0
if ( ns .eq. 0 ) return
do j=1,ns
  ub = ub + ps(j)
  xs(j) = 1
end do
go to 50
40 call sknp (ns,qs,kub,ub,n,np1,n5,ps,ws,xs,iwk)
lr = qs
50 do j=1,ns
  jj = bs(j)
  lx(jj) = xs(j)
end do
return
end subroutine sigma1

subroutine pi1 (n,m,p,w,q,i,b,bb,kub,bl,lb,pbl,v,xl, &
&np1,n5,bs,ps,ws,xs,iwk)
implicit none
integer, intent(in) :: i
integer, intent(inout) :: kub, lb
integer, intent(in) :: m, n, n5, np1
integer :: ii, ikub, j, jb, jbs, jj, ns
!
! SUBROUTINE TO COMPUTE A FEASIBLE SOLUTION TO THE CURRENT
! PROBLEM. THE SOLUTION IS STORED IN ARRAY  XL , THE
! CORRESPONDING VALUE IN  LB .
!
integer, intent(in) :: bb(m,n)
integer, intent(inout) :: bl(m,np1), xl(m,n), iwk(n5)
integer, intent(in) :: p(n), w(n), q(m), b(np1)
integer, intent(inout) :: pbl(m), v(m)
integer, intent(inout) :: bs(n), ps(np1), ws(np1), xs(n)
integer :: pb, qs, sb, u
!
! STEP 1
!
u = 0
do 10 j = 1,n
  if ( b(j) .eq. 0 ) go to 10
  u = u + 1
  bs(u) = j
10 continue
do j=i,m
  pbl(j) = 0
  v(j) = 0
end do
lb = 0
ikub = kub
if ( u .eq. 0 ) return
ns = 0
sb = 0
do 30 j = 1,u
  jj = bs(j)
  if ( bb(i,jj) .ne. 0 ) go to 30
  if ( w(jj) .gt. q(i) ) go to 30
  ns = ns + 1
  sb = sb + w(jj)
  bl(i,ns) = jj
  ps(ns) = p(jj)
  ws(ns) = w(jj)
30 continue
ii = i
!
! STEP 2
!
40 pbl(ii) = ns
if ( sb .gt. q(ii) ) go to 60
pb = 0
if ( ns .eq. 0 ) go to 80
do j=1,ns
  pb = pb + ps(j)
  xl(ii,j) = 1
end do
go to 80
60 qs = q(ii)
kub = 0
if ( ii .eq. m ) kub = ikub
call sknp (ns,qs,kub,pb,n,np1,n5,ps,ws,xs,iwk)
do j=1,ns
  xl(ii,j) = xs(j)
end do
80 lb = lb + pb
ikub = ikub - pb
v(ii) = pb
bl(ii,ns+1) = n + 1
!
! STEP 3
!
if ( ii .eq. m ) return
jb = 1
jbs = 0
do 100 j = 1,u
  if ( bs(j) .lt. bl(ii,jb) ) go to 90
  jb = jb + 1
  if ( xl(ii,jb-1) .eq. 1 ) go to 100
90 jbs = jbs + 1
  bs(jbs) = bs(j)
100 continue
u = jbs
if ( u .eq. 0 ) return
ns = 0
sb = 0
ii = ii + 1
do 110 j = 1,u
  jj = bs(j)
  if( w(jj) .gt. q(ii) ) go to 110
  ns = ns + 1
  sb = sb + w(jj)
  bl(ii,ns) = jj
  ps(ns) = p(jj)
  ws(ns) =  w(jj)
110 continue
go to 40
end subroutine pi1

subroutine parc (i,ii,ub,iflag,vb,lub,lj,li,f,bb,q,b,n,m,np1, &
&lx,lxi,lr,lri,lubi)
implicit none
integer, intent(in) :: i
integer, intent(out) :: iflag
integer, intent(in) :: ii, li, lj, lr, lri, lub, lubi, m, n, np1
integer :: i1, iq, j
!
! SUBROUTINE FOR PARAMETRIC COMPUTATION OF THE UPPER BOUNDS.
!
integer, intent(in) :: f(m), bb(m,n), q(m), b(np1)
integer, intent(inout) :: ub
integer, intent(in) :: vb
integer :: r, s
integer, intent(in) :: lx(n), lxi(n)
!
iflag = 0
if ( b(lj) .ne. 0 ) go to 60
i1 = i - 1
if ( i1 .lt. li ) go to 20
iq = 0
do r=li,i1
  iq = iq + q(r)
end do
if ( iq .gt. lr ) return
20 r = ii
s = f(r)
30 if ( s .ne. (-1) ) go to 40
r = r - 1
s = f(r)
go to 30
40 if ( lx(s) .eq. 0 ) return
if ( s .eq. lj ) go to 50
s = bb(r,s)
go to 30
50 ub = lub - vb
iflag = 1
return
60 i1 = i - 1
if ( i1 .lt. 1 ) go to 80
iq = 0
do r=1,i1
  iq = iq + q(r)
end do
if ( iq .gt. lri ) return
80 do 90 j = 1,n
  if ( b(j) .eq. 1 ) go to 90
  if ( lxi(j) .eq. 0 ) return
90 continue
ub = lubi - vb
iflag = 1
return
end subroutine parc

subroutine sknp (ns,qs,kub,vs,n,np1,n5,ps,ws,xs,iwk)
implicit none
integer, intent(in) :: kub, n, n5, np1, ns
integer :: i1, i2, i3, i4, i5
!
! SUBROUTINE TO SOLVE THE 0-1 SINGLE KNAPSACK PROBLEM
!
! MAXIMIZE    VS = PS(1)*XS(1) + ... + PS(NS)*XS(NS)
! SUBJECT TO       WS(1)*XS(1) + ... + WS(NS)*XS(NS) .LE. QS
!                  XS(J) = 0 OR 1   FOR  J=1,...,NS
!                  VS .GT. KUB
!
! THIS SUBROUTINE IS A MODIFIED VERSION OF SUBROUTINE KP01
! WHICH APPEARED IN  COMPUTING 21, 81-86(1978).
!
integer, intent(inout) :: qs, vs
integer, intent(inout) :: ps(np1), ws(np1), xs(n), iwk(n5)
!
i1 = 1
i2 = i1 + n
i3 = i2 + n
i4 = i3 + n
i5 = i4 + n
call sknp1 (ns,qs,kub,vs,n,np1,ps,ws,xs,iwk(i1),iwk(i2), &
&iwk(i3),iwk(i4),iwk(i5))
return
end subroutine sknp

subroutine sknp1 (ns,qs,kub,vs,n,np1,ps,ws,xs,d,min, &
&pbar,wbar,zbar)
implicit none
integer, intent(in) :: kub, n, np1, ns
integer :: ii, ii1, in, ip, j, j1, jj, kk, l, lim, lim1, ll, lold, &
&mfirst, mink, ms, n1, nn
real :: a, b, c
!
! SUBROUTINE TO SOLVE THE 0-1 SINGLE KNAPSACK PROBLEM
!
! MAXIMIZE    VS = PS(1)*XS(1) + ... + PS(NS)*XS(NS)
! SUBJECT TO       WS(1)*XS(1) + ... + WS(NS)*XS(NS) .LE. QS
!                  XS(J) = 0 OR 1   FOR  J=1,...,NS
!                  VS .GT. KUB
!
! THIS SUBROUTINE IS A MODIFIED VERSION OF SUBROUTINE KP01
! WHICH APPEARED IN  COMPUTING 21, 81-86(1978).
!
integer, intent(inout) :: qs
integer, intent(out) :: vs
integer :: diff, pr, r, t
integer, intent(inout) :: ps(np1), ws(np1), xs(n)
integer, intent(inout) :: d(n), min(n), pbar(n), wbar(n), zbar(n)
!
vs = kub
ip = 0
ms = qs
do l=1,ns
  ll = l
  if ( ws(l) .gt. ms ) go to 20
  ip = ip + ps(l)
  ms = ms - ws(l)
end do
20 ll = ll - 1
if ( ms .eq. 0 ) go to 50
ps(ns+1) = 0
ws(ns+1) = qs + 1
lim = ip + (ms*ps(ll+2))/ws(ll+2)
a = ip + ps(ll+1)
b = (ws(ll+1) - ms)*ps(ll)
c = ws(ll)
lim1 = a - b/c
if ( lim1 .gt. lim ) lim = lim1
if ( lim .le. vs ) return
mink = qs + 1
min(ns) = mink
do j=2,ns
  kk = ns + 2 - j
  if ( ws(kk) .lt. mink ) mink = ws(kk)
  min(kk-1) = mink
end do
do j=1,ns
  d(j) = 0
end do
pr = 0
lold = ns
ii = 1
go to 170
50 if ( vs .ge. ip ) return
vs = ip
do j=1,ll
  xs(j) = 1
end do
nn = ll + 1
do j=nn,ns
  xs(j) = 0
end do
qs = 0
return
80 if ( ws(ii) .le. qs ) go to 90
ii1 = ii + 1
if ( vs .ge. (qs*ps(ii1))/ws(ii1) + pr ) go to 280
ii = ii1
go to 80
90 ip = pbar(ii)
ms = qs - wbar(ii)
in = zbar(ii)
ll = ns
if ( in .gt. ns) go to 110
do l=in,ns
  ll = l
  if ( ws(l) .gt. ms ) go to 160
  ip = ip + ps(l)
  ms = ms - ws(l)
end do
110 if ( vs .ge. ip + pr ) go to 280
vs = ip + pr
mfirst = ms
nn = ii - 1
do j=1,nn
  xs(j) = d(j)
end do
do j=ii,ll
  xs(j) = 1
end do
if ( ll .eq. ns ) go to 150
nn = ll + 1
do j=nn,ns
  xs(j) = 0
end do
150 if ( vs .ne. lim ) go to 280
qs = mfirst
return
160 l = ll
ll = ll - 1
if ( ms .eq. 0 ) go to 110
if ( vs .ge. pr + ip + (ms*ps(l))/ws(l) ) go to 280
170 wbar(ii) = qs - ms
pbar(ii) = ip
zbar(ii) = ll + 1
d(ii) = 1
nn = ll - 1
if ( nn .lt. ii ) go to 190
do j=ii,nn
  wbar(j+1) = wbar(j) - ws(j)
  pbar(j+1) = pbar(j) - ps(j)
  zbar(j+1) = ll + 1
  d(j+1) = 1
end do
190 j1 = ll + 1
do j=j1,lold
  wbar(j) = 0
  pbar(j) = 0
  zbar(j) = j
end do
lold = ll
qs = ms
pr = pr + ip
if ( ll - (ns - 2) ) 240, 220, 210
210 ii = ns
go to 250
220 if ( qs .lt. ws(ns) ) go to 230
qs = qs - ws(ns)
pr = pr + ps(ns)
d(ns) = 1
230 ii = ns - 1
go to 250
240 ii = ll + 2
if ( qs .ge. min(ii-1) ) go to 80
250 if ( vs .ge. pr ) go to 270
vs = pr
do j=1,ns
  xs(j) = d(j)
end do
mfirst = qs
if ( vs .eq. lim ) return
270 if ( d(ns) .eq. 0 ) go to 280
d(ns) = 0
qs = qs + ws(ns)
pr = pr - ps(ns)
280 nn = ii - 1
if ( nn .eq. 0 ) go to 300
do j=1,nn
  kk = ii - j
  if ( d(kk) .eq. 1 ) go to 310
end do
300 qs = mfirst
return
310 r = qs
qs = qs + ws(kk)
pr = pr - ps(kk)
d(kk) = 0
if ( r .lt. min(kk) ) go to 320
ii = kk + 1
go to 80
320 nn = kk + 1
ii = kk
330 if ( vs .ge. pr + (qs*ps(nn))/ws(nn) ) go to 280
diff = ws(nn) - ws(kk)
if ( diff ) 390, 340, 350
340 nn = nn + 1
go to 330
350 if ( diff .gt. r ) go to 340
if ( vs .ge. pr + ps(nn) ) go to 340
vs = pr + ps(nn)
do j=1,kk
  xs(j) = d(j)
end do
jj = kk + 1
do j=jj,ns
  xs(j) = 0
end do
xs(nn) = 1
mfirst = qs - ws(nn)
if ( vs .ne. lim ) go to 380
qs = mfirst
return
380 r = r - diff
kk = nn
nn = nn + 1
go to 330
390 t = r - diff
if ( t .lt. min(nn) ) go to 340
n1 = nn + 1
if ( vs .ge. pr + ps(nn) + (t*ps(n1))/ws(n1) ) go to 280
qs = qs - ws(nn)
pr = pr + ps(nn)
d(nn) = 1
ii = nn + 1
wbar(nn) = ws(nn)
pbar(nn) = ps(nn)
zbar(nn) = ii
do j=n1,lold
  wbar(j) = 0
  pbar(j) = 0
  zbar(j) = j
end do
lold = nn
go to 80
end subroutine sknp1

subroutine lainv (mo,fun,t,aerr,rerr,y,c,error,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer, intent(out) :: num
real, intent(in) :: aerr
real, intent(inout) :: c, error
real, intent(in) :: rerr, t
real, intent(inout) :: y
integer :: ier, ierc, num1
real :: a
real :: exparg
!-----------------------------------------------------------------------
!
!             COMPUTATION OF THE INVERSE LAPLACE TRANSFORM
!              OF A FUNCTION WHICH IS NOT TOO OSCILLATORY
!
!                          ------------------
!
!     MO IS AN INPUT INTEGER WHICH SPECIFIES THE SEARCH PROCEDURE
!     FOR DETERMINATION OF C.  A TWO-PASS PROCEDURE IS USED WHEN
!     MO = 0 , AND A ONE-PASS PROCEDURE IS USED WHEN MO IS NOT ZERO.
!     WHEN ALL SINGULARITIES OF F(Z) ARE EXPECTED TO BE REAL, MO = 0
!     IS PREFERABLE.
!
!     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
!     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     FUN HAS THE ARGUMENTS X, Y, A, AND B.
!
!     T IS A POSITIVE VALUE OF THE INDEPENDENT VARIABLE FOR WHICH
!     THE INVERSE LAPLACE TRANSFORM IS TO BE CALCULATED.
!
!     C IS THE ABSCISSA OF CONVERGENCE.  IT MAY BE EITHER GIVEN
!     OR CALCULATED BY LAINV.
!
!     Y IS THE CALCULATED VALUE OF THE INVERSE LAPLACE TRANSFORM.
!
!     AERR IS THE ABSOLUTE ACCURACY REQUESTED.
!     RERR IS THE RELATIVE ACCURACY REQUESTED.  THE SUBROUTINE
!     ATTEMPTS TO SATISFY THE LESS STRINGENT OF THE TWO REQUIREMENTS.
!     IT IS ASSUMED THAT AERR AND RERR ARE .GE. 0.  IF ONE WANTS
!     ACCURACY TO K SIGNIFICANT FIGURES, THEN RERR SHOULD BE
!     SET = 10.0**(-K).
!
!     ERROR IS THE ESTIMATED ABSOLUTE ERROR OF Y.
!
!     NUM IS THE NUMBER OF EVALUATIONS OF FUN IN LAINV.
!
!     IERR MAY BE EITHER AN INPUT INTEGER OR AN OUTPUT INTEGER.  WHEN
!     IERR IS EQUAL TO ANY NEGATIVE INTEGER AT THE BEGINNING OF LAINV,
!     THE ABSCISSA OF CONVERGENCE IS CALCULATED AND THE VALUE OBTAINED
!     IS ASSIGNED TO THE ARGUMENT C.  OTHERWISE, C MUST BE INPUT BY
!     THE USER.  AFTER COMPLETION OF LAINV, IERR HAS ONE OF THE
!     FOLLOWING VALUES...
!
!        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
!
!        IERR = 1   THE CALCULATED VALUE OF Y MAY NOT BE ACCURATE
!                   DUE TO POSSIBLE INACCURACY IN THE CALCULATION
!                   OF C.  THIS VALUE OF IERR MAY OCCUR ONLY WHEN
!                   IERR IS INITIALLY NEGATIVE.
!
!        IERR = 2   THE CALCULATION OF Y DID NOT CONVERGE, WHILE
!                   THE GIVEN OR CALCULATED VALUE OF C MAY BE
!                   CONSIDERED ACCURATE.
!
!        IERR = 3   THE CALCULATION OF Y DID NOT CONVERGE, AND THE
!                   CALCULATED VALUE OF C MAY BE INACCURATE.  THIS
!                   VALUE OF IERR MAY OCCUR ONLY WHEN IERR IS
!                   INITIALLY NEGATIVE.
!
!        IERR = 4   THE VALUE OF T IS LESS THAN OR EQUAL TO 0.
!                   THE SPECIAL VALUES Y = 0.0 AND ERROR = 1.0
!                   ARE ASSIGNED.
!
!        IERR = 5   C WAS NOT FOUND IN THE INTERVAL (-1.0E4,1.0E4).
!                   THE SPECIAL VALUES C = 0.0, Y = 0.0, AND
!                   ERROR = 1.0 ARE ASSIGNED.
!                   THIS VALUE OF IERR MAY OCCUR ONLY WHEN
!                   IERR IS INITIALLY NEGATIVE.
!
!        IERR = 6   T IS TOO LARGE FOR THE INVERSE TRANSFORM TO BE
!                   COMPUTED. THE VALUES Y = 0.0 AND ERROR = 1.0
!                   ARE ASSIGNED.
!
!-----------------------------------------------------------------------
external fun
!
num = 0
ierc = -1
if (ierr .ge. 0) go to 10
!
!     CALCULATION OF THE ABSCISSA OF CONVERGENCE.
!
if (mo .eq. 0) go to 5
   call abcon1 (fun,c,num,ierc)
   go to 10
5 call abcon (fun,c,num,ierc)
10 if (ierc .eq. 2) go to 100
!
!     CHECK IF T IS TOO LARGE
!
a = c + 2.0/t
if (a*t .gt. exparg(0)) go to 110
!
!     CALCULATION OF THE INVERSE LAPLACE TRANSFORM.
!
call lainv1 (fun,t,c,rerr,aerr,y,error,num1,ier)
num = num + num1
!
!     REPORT THE STATUS OF THE RESULTS.
!
if (ierc .ge. 0) go to 20
if (ier  .eq. 0) go to 30
if (ier  .eq. 1) go to 50
20 if (ier  .eq. 2) go to 80
if (ier  .eq. 1) go to 60
if (ierc .eq. 1) go to 40
!
30 ierr = 0
return
40 ierr = 1
return
50 ierr = 2
return
60 if (ierc .eq. 1) go to 70
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
return
end subroutine lainv

subroutine abcon (fun, c, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real, intent(inout) :: c
integer :: num1
real :: eta, x0, xmin
!-----------------------------------------------------------------------
!
!             COMPUTATION OF THE ABSCISSA OF CONVERGENCE
!             OF A FUNCTION WHICH IS NOT TOO OSCILLATORY
!
!                         -----------------
!
!     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
!     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     FUN HAS THE ARGUMENTS X, Y, A, AND B.
!
!     C IS THE CALCULATED VALUE OF THE ABSCISSA OF CONVERGENCE.
!
!     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
!     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
!
!     IERR IS AN OUTPUT INTEGER REPORTING THE STATUS OF THE
!     CALCULATION OF C.  IERR IS ASSIGNED VALUES AS FOLLOWS...
!
!        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
!
!        IERR = 1   THE REQUESTED ACCURACY MAY NOT HAVE BEEN
!                   OBTAINED.  MORE SUBINTERVALS MAY BE REQUIRED
!                   IN THE NUMERICAL QUADRATURES IN SUBROUTINES
!                   ACOND AND XCOND.
!
!        IERR = 2   C COULD NOT BE CALCULATED WITH SUFFICIENT
!                   ACCURACY, OR AN INTERVAL CONTAINING C COULD
!                   NOT BE FOUND. THE SPECIAL VALUE C = 0.0 IS
!                   ASSIGNED.
!
!-----------------------------------------------------------------------
logical :: find
external fun, acond, xcond
!
eta = 0.01
xmin = -1.00358e4
!
!     CALCULATION OF THE LOCATION OF THE SINGULARITY ON THE REAL
!     AXIS WHICH IS FARTHEST TO THE RIGHT. SET THIS VALUE TO X0.
!
call srch(fun, xcond, xmin, eta, x0, num, ierr)
c = x0
if (ierr .eq. 2) go to 20
if (ierr .eq. 3) go to 10
!
!     CHECK IF X0 IS ON THE RIGHT OR LEFT OF THE ABSCISSA OF
!     CONVERGENCE. IF IT IS ON THE RIGHT THEN WE ARE DONE.
!
call acond(fun, x0, find, num1, ierr)
num = num + num1
if (find) go to 20
!
!     SEARCH TO THE RIGHT OF X0 TO FIND THE ABSCISSA OF
!     CONVERGENCE.
!
10 call srch(fun, acond, x0, eta, c, num1, ierr)
num = num + num1
if (ierr .eq. 3) c = 0.0
!
!     TERMINATION
!
20 ierr = min0(ierr,2)
return
end subroutine abcon

subroutine srch (fun,cond,xl,eta,x,num,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: num
real, intent(in) :: eta
real, intent(inout) :: x
real, intent(in) :: xl
integer :: i, ier, num1
real :: dx, tol, x1, x2, xbar, xm
!-----------------------------------------------------------------------
!     SRCH COMPUTES AN UPPER BOUND FOR THE SMALLEST NUMBER X SUCH
!     THAT A GIVEN CONDITION IS SATISFIED. IT IS ASSUMED THAT THE
!     CONDITION IS SATISFIED FOR SUFFICIENTLY LARGE X.
!-----------------------------------------------------------------------
!     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
!     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     FUN HAS THE ARGUMENTS X, Y, A, AND B.
!
!     COND IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
!     FOR COND NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     COND HAS THE ARGUMENTS FUN, X, CND, AND IER, WHERE CND IS
!     A LOGICAL VARIABLE.
!
!     XL IS THE SMALLEST VALUE OF X FOR WHICH A SEARCH IS MADE.  IT
!     SHOULD LIE IN THE RANGE - 1.0E4 .LE. XL .LT. 1.0E4.  IT IS
!     ASSUMED THAT THE LOGICAL VARIABLE CND CALCULATED BY COND IS
!     .FALSE. WHEN X = XL.
!
!     ETA IS THE RELATIVE TOLERANCE TO WHICH THE RESULT IS TO BE
!     DETERMINED. IT IS A POSITIVE REAL NUMBER. WHEN THIS SUBROUTINE
!     IS USED TO CALCULATE C FOR USE IN THE PIESSENS CODE LAINV1
!     (ALGORITHM 619), IT IS USUALLY SUFFICIENT TO TAKE ETA = 0.01.
!
!     X IS THE CALCULATED RESULT.  IT IS LARGER THAN THE EXACT
!     RESULT BY AN AMOUNT LESS THAN ETA*X.
!
!     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
!     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
!
!     IERR IS AN OUTPUT INTEGER REPORTING THE STATUS OF THE
!     CALCULATION OF X.  IERR IS ASSIGNED VALUES AS FOLLOWS...
!
!          IERR = 0     THE CALCULATION WAS FULLY SUCCESSFUL.
!
!          IERR = 1     X MAY BE IN ERROR DUE TO THE CALCULATION
!                       OF COND.
!
!          IERR = 2     CND IS .FALSE. WHEN X = 1.0E4.  X IS SET = 0.0.
!
!          IERR = 3     CND IS .TRUE. FOR  X .GE. XL.  X IS SET TO XL.
!
logical :: cnd
external fun, cond
ierr = 0
!
!     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
!     X1 .GE. 0.01269
!
x1 = amax1(.01269, xl)
call cond(fun,x1,cnd,num,ier)
if (cnd) go to 20
!
   x2 = 10.1269
   do 10 i = 1,4
      if (x2 .le. x1) go to 10
      call cond(fun,x2,cnd,num1,ier)
      num = num + num1
      if (cnd) go to 200
      x1 = x2
10 x2 = 10.0*x2
   go to 300
!
20 if (x1 .eq. xl) go to 400
!
!     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
!     X2 .LE. 0.01269
!
   x2 = x1
   x1 = -.100358
   do 30 i = 1,6
      x1 = amax1(x1, xl)
      call cond(fun,x1,cnd,num1,ier)
      num = num + num1
      if(.not. cnd) go to 200
      x2 = x1
      if (x1 .eq. xl) go to 400
30 x1 = 10.0*x1
!
!     SEARCH FOR X IN THE INTERVAL (X1, X2) BY BISECTION
!
200 dx = x2 - x1
      xbar = x1 + dx/2.0
      call cond(fun,xbar,cnd,num1,ierr)
      num = num + num1
      xm = amax1(abs(x1), abs(x2))
      tol = eta
      if (xm .gt. 1.0) tol = eta*xm
      if (dx .le. tol) go to 250
         if(cnd) go to 225
            x1 = xbar
            go to 200
225 x2 = xbar
         go to 200
!
!     FINAL ASSEMBLY
!
250 if(cnd) go to 275
         x = x2
         return
275 x = xbar
      return
!
!     ERROR RETURN WHEN X COULD NOT BE FOUND IN THE INTERVAL
!     (-1.0E4, 1.OE4).
!
300 x = 0.0
ierr = 2
return
400 x = xl
ierr = 3
return
end subroutine srch

subroutine abcon1 (fun, c, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real, intent(inout) :: c
integer :: i, num1
real :: dx, eta, tol, x1, x2, xbar, xm
!-----------------------------------------------------------------------
!
!             COMPUTATION OF THE ABSCISSA OF CONVERGENCE
!             OF A FUNCTION WHICH IS NOT TOO OSCILLATORY
!
!                         -----------------
!
!     FUN IS A REAL SUBROUTINE DEFINED BY THE USER. THE ACTUAL NAME
!     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     FUN HAS THE ARGUMENTS X, Y, A, AND B.
!
!     C IS THE CALCULATED VALUE OF THE ABSCISSA OF CONVERGENCE.
!
!     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
!     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
!
!     IERR IS AN OUTPUT INTEGER REPORTING THE STATUS OF THE
!     CALCULATION OF C.  IERR IS ASSIGNED VALUES AS FOLLOWS...
!
!        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
!
!        IERR = 1   THE REQUESTED ACCURACY MAY NOT HAVE BEEN
!                   OBTAINED.  MORE SUBINTERVALS MAY BE REQUIRED
!                   IN THE NUMERICAL QUADRATURES IN SUBROUTINES
!                   ACOND AND XCOND.
!
!        IERR = 2   C COULD NOT BE CALCULATED WITH SUFFICIENT
!                   ACCURACY, OR AN INTERVAL CONTAINING C COULD
!                   NOT BE FOUND. THE SPECIAL VALUE C = 0.0 IS
!                   ASSIGNED.
!
!-----------------------------------------------------------------------
logical :: cmplex, iend, right
external fun, acond, xcond
!
eta = 0.01
cmplex = .false.
!
x1 = .01269
call xcond (fun,x1,right,num,ierr)
if (.not. right) go to 10
call acond (fun,x1,right,num1,ierr)
num = num + num1
if (right) go to 30
cmplex = .true.
!
!     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
!     X1 .GE. 0.01269
!
10 x2 = 10.1269
   do i = 1,4
      if (cmplex) go to 20
         call xcond (fun,x2,right,num1,ierr)
         num = num + num1
         if (.not. right) go to 21
20 call acond (fun,x2,right,num1,ierr)
      num = num + num1
      if (right) go to 50
      cmplex = .true.
21 x1 = x2
      x2 = 10.0*x2
   end do
   go to 100
!
!     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
!     X2 .LE. 0.01269
!
30 x2 = x1
   x1 = -.100358
   do i = 1,6
      call xcond (fun,x1,right,num1,ierr)
      num = num + num1
      if (.not. right) go to 50
      call acond (fun,x1,right,num1,ierr)
      num = num + num1
      if (.not. right) go to 45
      x2 = x1
      x1 = 10.0*x1
   end do
   go to 100
!
45 cmplex = .true.
!
!     SEARCH FOR X IN THE INTERVAL (X1, X2) BY BISECTION
!
50 dx = x2 - x1
      xbar = x1 + dx/2.0
      xm = amax1(abs(x1), abs(x2))
      tol = eta
      if (xm .gt. 1.0) tol = eta*xm
      iend =  dx .le. tol
!
      if (cmplex) go to 60
      call xcond (fun,xbar,right,num1,ierr)
      num = num + num1
      if (right) go to 60
         if (iend) go to 80
         x1 = xbar
         go to 50
!
60 call acond (fun,xbar,right,num1,ierr)
      num = num + num1
      if (right) go to 70
         if (iend) go to 80
         x1 = xbar
         cmplex = .true.
         go to 50
70 x2 = xbar
      if (.not. iend) go to 50
!
!     STANDARD TERMINATION
!
80 c = x2
   return
!
!     ERROR RETURN WHEN X CANNOT BE FOUND IN (-1.E4, 1.E4)
!
100 c = 0.0
ierr = 2
return
end subroutine abcon1

subroutine acond (fun, x, cond, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real, intent(in) :: x
integer :: ier, ier1, ier2, iwk(100), l, m, n, num1, num2
real :: a, aerr, c, error1, error2, rerr, tol, wk(400), y, z1, z2
real :: acondg
real :: acondf
!-----------------------------------------------------------------------
!
!        THIS SUBROUTINE TESTS WHETHER OR NOT A GIVEN VALUE OF X
!        LIES TO THE RIGHT OF THE ABSCISSA OF CONVERGENCE OF THE
!        COMPLEX FUNCTION DEFINED BY FUN WHEN NO SINGULARITIES LIE
!        ON THE REAL AXIS.
!
!                      ----------------
!
!     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
!     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     FUN HAS THE ARGUMENTS X, Y, A, AND B.
!
!     X IS A REAL NUMBER. THE LOGICAL VARIABLE COND = .TRUE. IF
!     X .GT. C, WHERE C IS THE ABSCISSA OF CONVERGENCE, AND .FALSE.
!     IF X .LT. C.
!
!     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
!     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
!
!     IERR IS AN OUTPUT INTEGER INDICATING THE STATUS OF THE
!     CALCULATION. IT IS ASSIGNED VALUES AS FOLLOWS...
!
!        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
!
!        IERR = 1   THE CALCULATION OF COND MAY NOT BE
!                   ACCURATE FOR ALL VALUES OF X.
!
!-----------------------------------------------------------------------
logical, intent(inout) :: cond
external fun, acondf, acondg
!--------------------------
data l /100/, m /400/
data aerr /1.e-30/, rerr /1.e-4/, tol /1.e-4/
!--------------------------
c = x
!
!     CALCULATION OF THE INTEGRAL OF ACONDF FROM X TO INFINITY.
!
call qagi1 (acondf,fun,y,c,x,1,aerr,rerr,z1,error1,num1,ier1, &
&l,m,n,iwk,wk)
!
!     CALCULATION OF THE INTEGRAL OF ACONDG FROM 0 TO INFINITY.
!
a = 0.0
call qagi1 (acondg,fun,y,c,a,1,aerr,rerr,z2,error2,num2,ier2, &
&l,m,n,iwk,wk)
num = num1 + num2
ier = max0(ier1, ier2)
!
!     DETERMINATION OF COND.
!
cond = .false.
if (abs(z1 - z2) .le. tol*amax1(abs(z1),abs(z2))) cond = .true.
!
!     SET IERR AND RETURN
!
ierr = 0
if (ier .gt. 4) ierr = 1
return
end subroutine acond

function acondf (x, y, c, fun)
implicit none
real, intent(in) :: c
real :: x
real, intent(in) :: y
real :: a, b, t
real :: acondf
!-----------------------------------------------------------------------
!        ACONDF IS THE FUNCTION INTEGRATED ALONG THE X-AXIS IN
!        ACOND. Y IS A DUMMY VARIABLE.
!-----------------------------------------------------------------------
external fun
!
call fun (x, 0.0, a, b)
t = 1.0/((x - c) + 1.0)
acondf = a*t*t
return
end function acondf

function acondg (x, y, c, fun)
implicit none
real :: c, x
real, intent(in) :: y
real :: a, b, s, t, u, v
real :: acondg
!-----------------------------------------------------------------------
!        ACONDG IS THE FUNCTION INTEGRATED ALONG THE LINE X = C
!        IN ACOND. Y IS A DUMMY VARIABLE.
!-----------------------------------------------------------------------
external fun
!
call fun (c, x, a, b)
call crec (1.0, x, s, t)
u = s*s - t*t
v = 2.0*s*t
acondg = -(a*v + b*u)
return
end function acondg

subroutine xcond (fun, x, cond, num, ierr)
implicit none
integer, intent(inout) :: ierr, num
real :: x
integer :: iwk(100), l, m, n
real :: aerr, c, epsr, error, rerr, t, tol, wk(400), y, y1, z
real :: xcondy
real :: xcondx
!-----------------------------------------------------------------------
!
!        THIS SUBROUTINE TESTS WHETHER OR NOT A GIVEN VALUE OF X
!        LIES TO THE RIGHT OF ALL SINGULARITIES OF THE COMPLEX
!        FUNCTION DEFINED BY FUN WHICH LIE ON THE REAL AXIS.
!
!                         ------------
!
!     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
!     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
!     FUN HAS THE ARGUMENTS X, Y, A, AND B.
!
!     X IS A REAL NUMBER.  THE LOGICAL VARIABLE COND = .TRUE IF
!     X .GT. C, WHERE C IS THE ABSCISSA OF THE SINGULARITY ON THE
!     REAL AXIS WHICH LIES FARTHEST TO THE RIGHT, AND .FALSE. IF
!     X .LT. C.
!
!     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
!     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
!
!     IERR IS AN OUTPUT INTEGER INDICATING THE STATUS OF THE
!     CALCULATION.  IT IS ASSIGNED VALUES AS FOLLOWS...
!
!        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
!
!        IERR = 1   THE CALCULATION OF COND MAY NOT BE
!                   ACCURATE FOR ALL VALUES OF X.
!
!-----------------------------------------------------------------------
logical, intent(out) :: cond
external fun, xcondx, xcondy
!--------------------------
data l /100/, m /400/
data aerr /1.e-30/, rerr /1.e-4/, tol /1.e-4/
data epsr /1.e-2/
!--------------------------
c = 1.0 - x
y = epsr
cond = .false.
!
!     NUMERICAL INTEGRATION OF THE IMAGINARY PART OF THE INTEGRAND
!     ALONG THE LINE Y = EPSR.
!
call qagi1 (xcondy,fun,y,c,x,1,aerr,rerr,z,error,num,ierr, &
&l,m,n,iwk,wk)
if (ierr .ne. 0) go to 100
!
!     DETERMINATION OF COND.
!
y1 = 0.5*y
t = (xcondx(x,y,c,fun) + 4.0*xcondx(x,y1,c,fun) + &
&xcondx(x,0.0,c,fun))*epsr/6.0
num = num + 3
if (t*z .gt. 0.0) return
if (abs(t + z) .gt. tol*amax1(abs(t), abs(z))) return
   cond = .true.
   return
!
!     ERROR RETURN
!
100 ierr = 1
return
end subroutine xcond

function xcondx (x,y,c,fun)
implicit none
real, intent(in) :: c
real :: x, y
real :: a, b, s, t, u, v
real :: xcondx
!
!     REAL PART OF THE INTEGRAND IN XCOND
!
external fun
!
call fun (x, y, a, b)
call crec (x + c, y, s, t)
u = s*s - t*t
v = 2.0*s*t
xcondx = a*u - b*v
return
end function xcondx

function xcondy (x,y,c,fun)
implicit none
real, intent(in) :: c
real :: x, y
real :: a, b, s, t, u, v
real :: xcondy
!
!     IMAGINARY PART OF INTEGRAND IN XCOND
!
external fun
!
call fun (x, y, a, b)
call crec (x + c, y, s, t)
u = s*s - t*t
v = 2.0*s*t
xcondy = a*v + b*u
return
end function xcondy

 subroutine lainv1(fun,t,c,epsre,epsab,result,esterr,num, &
&ier)
implicit none
real, intent(in) :: c, epsab, epsre
real, intent(out) :: esterr, result
real, intent(in) :: t
integer :: max
real :: a, aim, ak, are, arg, b, bb, e, eps, epsr1, f, fim, fre, &
&pid16, r, s, si(32), tol
real :: spmpar
!
! ......................................................................
!
!   1. LAINV1
!        INVERSION OF LAPLACE TRANSFORM USING THE DURBIN FORMULA
!        IN COMBINATION WITH THE EPSILON ALGORITHM
!
!   2. PURPOSE
!        THE ROUTINE CALCULATES AN APPROXIMATION RESULT TO THE
!        INVERSE LAPLACE TRANSFORM F(T) OF FUN, FOR THE VALUE
!        OF THE INDEPENDENT VARIABLE EQUAL TO T, HOPEFULLY
!        SATISFYING THE FOLLOWING CLAIM FOR ACCURACY ....
!        ABS(F(T)-RESULT).LE.MAX(EPSAB,EPSRE*ABS(F(T)))
!
!   3. CALLING SEQUENCE
!        CALL LAINV1(FUN,T,C,EPSRE,EPSAB,RESULT,ESTERR,NUM,IER)
!
!      INPUT PARAMETERS
!        FUN    - REAL
!                 SUBROUTINE DEFINING THE LAPLACE TRANSFORM AS
!                 A COMPLEX FUNCTION.  THE CALLING SEQUENCE OF
!                 FUN IS CALL FUN(A,B,C,D) WHERE
!                 A - REAL
!                     REAL PART OF THE INDEPENDENT VARIABLE
!                     OF THE LAPLACE TRANSFORM (INPUT)
!                 B - REAL
!                     IMAGINARY PART OF THE INDEPENDENT
!                     VARIABLE OF THE LAPLACE TRANSFORM (INPUT)
!                 C - REAL
!                     REAL PART OF THE VALUE OF THE LAPLACE
!                     TRANSFORM (OUTPUT)
!                 D - REAL
!                     IMAGINARY PART OF THE VALUE OF THE
!                     LAPLACE TRANSFORM (OUTPUT)
!                 THE ACTUAL NAME FOR FUN NEEDS TO BE DECLARED
!                 EXTERNAL IN THE DRIVER PROGRAM.
!
!        T      - REAL
!                 VALUE OF THE INDEPENDENT VARIABLE FOR WHICH THE
!                 INVERSE LAPLACE TRANSFORM HAS TO BE COMPUTED.
!                 T SHOULD BE GREATER THAN ZERO.
!
!        C      - REAL
!                 ABSCISSA OF CONVERGENCE OF THE LAPLACE TRANSFORM
!
!        EPSRE  - REAL
!                 RELATIVE ACCURACY REQUESTED.  IT IS ASSUMED THAT
!                 EPSRE .GE. 0.  IF ONE WANTS ACCURACY TO K SIGNIFICANT
!                 FIGURES, THEN RERR SHOULD BE SET = 10.0**(-K).
!
!        EPSAB  - REAL
!                 ABSOLUTE ACCURACY REQUESTED.  IT IS ASSUMED THAT
!                 EPSAB .GE. 0.  THE ROUTINE TRIES TO SATISFY THE
!                 LEAST STRINGENT OF BOTH ACCURACY REQUIREMENTS.
!
!      OUTPUT PARAMETERS
!        RESULT - REAL
!                 INVERSE LAPLACE TRANSFORM
!
!        ESTERR - REAL
!                 ESTIMATE OF THE ABSOLUTE ERROR ABS(F(T)-RESULT)
!
!        NUM    - INTEGER
!                 NUMBER OF EVALUATIONS OF FUN
!
!        IER    - INTEGER
!                 PARAMETER GIVING INFORMATION ON THE TERMINATION
!                 OF THE ALGORITHM
!                 IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                         ROUTINE
!                 IER = 1 THE COMPUTATIONS ARE TERMINATED BECAUSE
!                         THE BOUND ON THE NUMBER OF EVALUATIONS
!                         OF FUN HAS BEEN ACHIEVED.  THIS BOUND
!                         IS EQUAL TO 8*MAX+5 WHERE  MAX  IS A
!                         NUMBER INITIALIZED IN A DATA
!                         STATEMENT.  ONE CAN ALLOW MORE FUNCTION
!                         EVALUATIONS BY INCREASING THE VALUE OF
!                         MAX IN THE DATA-STATEMENT.
!                 IER = 2 THE VALUE OF T IS LESS THAN OR EQUAL
!                         TO ZERO.
!
!   4. SUBROUTINES OR FUNCTIONS NEEDED
!                FUN - USER PROVIDED SUBROUTINE
!                CQEXT - EPSILON ALGORITHM
!                SPMPAR - THIS FUNCTION IS CALLED BY
!                          CQEXT, AND PROVIDES MACHINE CONSTANTS
!                ATAN, EXP, AMAX1, SIN, ABS,
!                DBLE, CMPLX, REAL - FORTRAN FUNCTIONS
!
! ......................................................................
!
complex :: rex(52), cres, res3la(3)
integer :: i
integer, intent(out) :: ier
integer :: k, kc, kk, ks, m, nex, nres
integer, intent(out) :: num
!
!   THE ARRAY SI CONTAINS VALUES OF THE SINE AND COSINE FUNCTIONS
!   REQUIRED IN THE DURBIN FORMULA. SI(8) AND SI(16) ARE GIVEN IN
!   THE FOLLOWING DATA STATEMENT. THE OTHER VALUES ARE COMPUTED.
!
data si(8),si(16)/ 1.0e+00,0.0e+00/
!
!   MAX IS A BOUND ON THE NUMBER OF TERMS USED IN THE DURBIN
!   FORMULA.
!
data max/500/
! ....................................................
!
!   EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
!   SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
!
eps = spmpar(1)
! ....................................................
!
!   CALCULATION OF THE RELATIVE TOLERANCE USED.
!
tol = 10.0*eps
epsr1 = amax1(tol,epsre)
!
!   TEST ON VALIDITY OF THE INPUT PARAMETER T
!
ier = 2
result = 0.0e+00
esterr = 1.0e+00
num = 0
if (t.le.0.0e+00) go to 999
!
!   PID16 IS EQUAL TO PI/16
!
pid16 = atan(1.0e+00)/4.0e+00
!
!   COMPUTATION OF THE ELEMENTS OF THE ARRAY SI
!
ak = 1.0e+00
do 10 k = 1,7
  si(k) = sin(ak*pid16)
  ak = ak+1.0e+00
  kk = 16-k
  si(kk) = si(k)
10 continue
ier = 0
nres = 0
do k=17,32
  si(k) = -si(k-16)
end do
!
!   INITIALIZATION OF THE SUMMATION OF THE DURBIN FORMULA.
!
arg = pid16/t
are = c+2.0e+00/t
aim = 0.0e+00
bb = exp(are*t)/(1.6e+01*t)
call fun (are,aim,fre,fim)
num = 5
r = 5.0e-01*fre
s = 0.0
nex = 0
kc = 8
ks = 0
!
!   MAIN LOOP FOR THE SUMMATION
!
do 40 i = 1,max
  m = 8
  if (i.eq.1) m = 12
  do k=1,m
    aim = aim+arg
    kc = kc+1
    ks = ks+1
    if (kc.gt.32) kc = 1
    if (ks.gt.32) ks = 1
    call fun(are,aim,fre,fim)
a = fre*si(kc)
b = -fim*si(ks)
r = dble(r) + dble(a) + dble(b)
e = fre*si(ks)
f = fim*si(kc)
s = dble(s) + dble(e) + dble(f)
  end do
  num = num+8
  nex = nex+1
  rex(nex) = cmplx(r, s)
!
!   EXTRAPOLATION USING THE EPSILON ALGORITHM
!
  if(nex.ge.3) call cqext(nex,rex,cres,esterr,res3la,nres)
  if(nres.lt.4) go to 40
!
!   COMPUTATION OF INTERMEDIATE RESULT AND ESTIMATE OF THE
!   ABSOLUTE ERROR
!
  result = real(cres)
  result = result * bb
  esterr = esterr * bb
  if (esterr.lt.amax1(epsab,epsr1*abs(result)).and.abs(r*bb- &
&result).lt.5.0e-01*abs(result)) go to 999
40 continue
!
!   SET ERROR FLAG IN THE CASE THAT THE NUMBER OF TERMS IN THE
!   SUMMATION IS EQUAL TO MAX
!
ier = 1
999 return
end subroutine lainv1

subroutine cqext(n,epstab,result,abserr,res3la,nres)
implicit none
real, intent(out) :: abserr
real :: a1, a2, b1, b2, c1, c2, d1, d2, e1abs, epmach, epsinf, &
&err1, err2, err3, error, oflow, res1, res2
real :: spmpar
!
! 1.        CQEXT
!           EPSILON ALGORITHM
!              STANDARD FORTRAN SUBROUTINE
!              COMPLEX VERSION
!
! 2.        PURPOSE
!              THE ROUTINE DETERMINES THE LIMIT OF A GIVEN SEQUENCE OF
!              APPROXIMATIONS, BY MEANS OF THE EPSILON ALGORITHM
!              OF P. WYNN.
!              AN ESTIMATE OF THE ABSOLUTE ERROR IS ALSO GIVEN.
!              THE CONDENSED EPSILON TABLE IS COMPUTED. ONLY THOSE
!              ELEMENTS NEEDED FOR THE COMPUTATION OF THE NEXT DIAGONAL
!              ARE PRESERVED.
!
! 3.        CALLING SEQUENCE
!              CALL CQEXT(N,EPSTAB,RESULT,ABSERR,RES3LA,NRES)
!
!           PARAMETERS
!              N      - INTEGER
!                       EPSTAB(N) CONTAINS THE NEW ELEMENT IN THE
!                       FIRST COLUMN OF THE EPSILON TABLE.
!
!              EPSTAB - COMPLEX
!                       VECTOR OF DIMENSION 52 CONTAINING THE ELEMENTS
!                       OF THE TWO LOWER DIAGONALS OF THE
!                       TRIANGULAR EPSILON TABLE
!                       THE ELEMENTS ARE NUMBERED STARTING AT THE
!                       RIGHT-HAND CORNER OF THE TRIANGLE.
!
!              RESULT - COMPLEX
!                       RESULTING APPROXIMATION TO THE INTEGRAL
!
!              ABSERR - REAL
!                       ESTIMATE OF THE ABSOLUTE ERROR OF THE REAL
!                       PART OF RESULT COMPUTED FROM RESULT AND
!                       THE 3 PREVIOUS RESULTS
!
!              RES3LA - COMPLEX
!                       VECTOR OF DIMENSION 3 CONTAINING THE LAST 3
!                       RESULTS
!
!              NRES   - INTEGER
!                       NUMBER OF CALLS TO THE ROUTINE
!                       (SHOULD BE ZERO AT FIRST CALL)
!
! 4.        SUBROUTINES OR FUNCTIONS NEEDED
!                     - SPMPAR, CDIVID
!                     - FORTRAN ABS, AMAX1, CABS, CMPLX,
!                       REAL, AIMAG, SNGL
!
!     ..................................................................
!
complex :: delta1, delta2, delta3
complex, intent(inout) :: epstab(52)
complex :: e0, e1, e2, e3, res
complex, intent(out) :: result
complex, intent(inout) :: res3la(3)
complex :: ss
double precision :: r, s, u1, u2, u3, v1, v2, v3, ss1, ss2, w1, w2
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp
integer, intent(inout) :: n
integer :: newelm
integer, intent(inout) :: nres
integer :: num
!
!           LIST OF MAJOR VARIABLES
!           -----------------------
!
!           E0     - THE 4 ELEMENTS ON WHICH THE
!           E1       COMPUTATION OF A NEW ELEMENT IN
!           E2       THE EPSILON TABLE IS BASED
!           E3                 E0
!                        E3    E1    NEW
!                              E2
!           NEWELM - NUMBER OF ELEMENTS TO BE COMPUTED IN THE NEW
!                    DIAGONAL
!           ERROR  - ERROR = ABS(E1-E0)+ABS(E2-E1)+ABS(NEW-E2)
!           RESULT - THE ELEMENT IN THE NEW DIAGONAL WITH LEAST VALUE
!                    OF ERROR
!
!           MACHINE DEPENDENT CONSTANTS
!           ---------------------------
!
!           EPMACH IS THE LARGEST RELATIVE SPACING.
!           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
!           LIMEXP IS THE MAXIMUM NUMBER OF ELEMENTS THE EPSILON
!           TABLE CAN CONTAIN. IF THIS NUMBER IS REACHED, THE UPPER
!           DIAGONAL OF THE EPSILON TABLE IS DELETED.
!
!***FIRST EXECUTABLE STATEMENT
oflow = spmpar(3)
epmach = spmpar(1)
nres = nres+1
abserr = oflow
result = epstab(n)
if(n.lt.3) go to 100
limexp = 50
epstab(n+2) = epstab(n)
newelm = (n-1)/2
epstab(n) = cmplx(oflow,0.0)
num = n
k1 = n
do 40 i = 1,newelm
  k2 = k1-1
  k3 = k1-2
  res = epstab(k1+2)
  e0 = epstab(k3)
  e1 = epstab(k2)
  e2 = res
  e1abs = cabs(e1)
  a1 = real(e0)
  a2 = aimag(e0)
  b1 = real(e1)
  b2 = aimag(e1)
  c1 = real(e2)
  c2 = aimag(e2)
  err2 = abs(c1 - b1)
  err3 = abs(b1 - a1)
  if(abs(a1-b1) .gt. epmach*amax1(abs(a1),abs(b1)) .or. &
&abs(a2-b2) .gt. epmach*amax1(abs(a2),abs(b2))) go to 10
  if(abs(b1-c1) .gt. epmach*amax1(abs(b1),abs(c1)) .or. &
&abs(b2-c2) .gt. epmach*amax1(abs(b2),abs(c2))) go to 10
!
!           IF E0, E1 AND E2 ARE EQUAL TO WITHIN MACHINE
!           ACCURACY, CONVERGENCE IS ASSUMED.
!           RESULT = E2
!           ABSERR = CABS(E1-E0)+CABS(E2-E1)
!
  result = res
  abserr = err2+err3
!***JUMP OUT OF DO-LOOP
  go to 100
10 e3 = epstab(k1)
  epstab(k1) = e1
  d1 = real(e3)
  d2 = aimag(e3)
  err1 = abs(b1 - d1)
!
!           IF TWO ELEMENTS ARE VERY CLOSE TO EACH OTHER, OMIT
!           A PART OF THE TABLE BY ADJUSTING THE VALUE OF N
!
  delta1 = e1 - e3
  delta2 = e2 - e1
  delta3 = e1 - e0
  if(cabs(delta1) .le. epmach*amax1(e1abs,cabs(e3))) go to 20
  if(cabs(delta2) .le. epmach*amax1(e1abs,cabs(e2))) go to 20
  if(cabs(delta3) .le. epmach*amax1(cabs(e0),e1abs)) go to 20
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
  epsinf = cabs(ss*e1)
!
!           TEST TO DETECT IRREGULAR BEHAVIOUR IN THE TABLE, AND
!           EVENTUALLY OMIT A PART OF THE TABLE ADJUSTING THE VALUE
!           OF N.
!
  if(epsinf.gt.1.0e-04) go to 30
20 n = i+i-1
!***JUMP OUT OF DO-LOOP
  go to 50
!
!           COMPUTE A NEW ELEMENT AND EVENTUALLY ADJUST
!           THE VALUE OF RESULT.
!
30 call cdivid(1.d0,0.d0,ss1,ss2,w1,w2)
  res1 = real(e1) + sngl(w1)
  res2 = aimag(e1) + sngl(w2)
  res = cmplx(res1,res2)
  epstab(k1) = res
  k1 = k1-2
  error = err2+abs(c1-real(res))+err3
  if(error.gt.abserr) go to 40
  abserr = error
  result = res
40 continue
!
!           SHIFT THE TABLE.
!
50 if(n.eq.limexp) n = 2*(limexp/2)-1
ib = 1
if((num/2)*2.eq.num) ib = 2
ie = newelm+1
do i=1,ie
  ib2 = ib+2
  epstab(ib) = epstab(ib2)
  ib = ib2
end do
if(num.eq.n) go to 80
indx = num-n+1
do i = 1,n
  epstab(i)= epstab(indx)
  indx = indx+1
end do
80 if(nres.ge.4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!
!           COMPUTE ERROR ESTIMATE
!
90 abserr = abs(real(result-res3la(3)))+abs(real(result-res3la(2))) &
&+abs(real(result-res3la(1)))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = amax1(abserr,5.0e+00*epmach*abs(real(result)))
return
end subroutine cqext

subroutine qagi1(f,phi,y,c,bound,inf,epsabs,epsrel,result,abserr, &
&neval,ier,limit,lenw,last,iwork,work)
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
integer :: l1, l2, l3
real :: f
!-----------------------------------------------------------------------
!
!                   INTEGRATION OVER INFINITE INTERVALS
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)). F HAS THE
!           ARGUMENTS X AND PHI WHERE PHI IS A FUNCTION.
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!                     F HAS THE ARGUMENTS X AND PHI.
!
!            PHI    - REAL
!                     FUNCTION SUBPROGRAM HAVING A SINGLE REAL ARGUMENT.
!                     THE ACTUAL NAME FOR PHI MUST BE DECLARED EXTERNAL
!                     IN THE DRIVER PROGRAM.
!
!            BOUND  - REAL
!                     FINITE BOUND OF INTEGRATION RANGE
!                     (HAS NO MEANING IF INTERVAL IS DOUBLY-INFINITE)
!
!            Y      - REAL
!                     PARAMETER FOR USE IN XCOND.  ORDINATE OF
!                     HORIZONTAL LINE ALONG WHICH INTEGRATION
!                     IS PERFORMED.
!
!            C       - REAL
!                      PARAMETER FOR USE IN ACOND AND XCOND.
!
!            INF    - INTEGER
!                     INDICATING THE KIND OF INTEGRATION RANGE
!                     INVOLVED
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             ESTIMATES FOR RESULT AND ERROR ARE LESS
!                             RELIABLE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS NOT BEEN ACHIEVED.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE
!                             SUBDIVISIONS BY INCREASING THE VALUE
!                             OF LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A LOCAL
!                             DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE
!                             SUBRANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             DETECTED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             AT SOME POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             ROUNDOFF ERROR IS DETECTED IN THE
!                             EXTRAPOLATION TABLE.
!                             IT IS ASSUMED THAT THE REQUESTED TOLERANCE
!                             CANNOT BE ACHIEVED, AND THAT THE RETURNED
!                             RESULT IS THE BEST WHICH CAN BE OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
!                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
!                             OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             RESULT, ABSERR, NEVAL, LAST ARE
!                             SET TO ZERO.
!
!         DIMENSIONING PARAMETERS
!            LIMIT - INTEGER
!                    DIMENSIONING PARAMETER FOR IWORK
!                    LIMIT DETERMINES THE MAXIMUM NUMBER
!                    OF SUBINTERVALS IN THE PARTITION OF THE GIVEN
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    DIMENSIONING PARAMETER FOR WORK
!                    LENW MUST BE AT LEAST LIMIT*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LAST  - INTEGER
!                    ON RETURN, LAST EQUALS THE NUMBER OF
!                    SUBINTERVALS PRODUCED IN THE SUBDIVISION
!                    PROCESS, WHICH DETERMINES THE NUMBER OF SIGNIFICANT
!                    ELEMENTS ACTUALLY IN THE WORK ARRAYS.
!
!         WORK ARRAYS
!            IWORK - INTEGER
!                    VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                    K ELEMENTS OF WHICH CONTAIN POINTERS
!                    TO THE ERROR ESTIMATES OVER THE SUBINTERVALS,
!                    SUCH THAT WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) FORM A DECREASING
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            WORK  - REAL
!                    VECTOR OF DIMENSION AT LEAST LENW
!                    ON RETURN
!                    WORK(1), ..., WORK(LAST) CONTAIN THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     PARTITION OF (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) CONTAIN
!                     THE RIGHT END POINTS,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     CONTAIN THE INTEGRAL APPROXIMATIONS OVER
!                     THE SUBINTERVALS,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     CONTAIN THE ERROR ESTIMATES.
!
!        SUBROUTINES OR FUNCTIONS NEEDED
!              - QAGIE1
!              - QK15I1
!              - QPSRT
!              - QELG
!              - F (USER PROVIDED FUNCTION)
!              - PHI (USER PROVIDED FUNCTION)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f, phi
!
!         CHECK VALIDITY OF LIMIT AND LENW.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         PREPARE CALL FOR QAGIE1.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call qagie1(f,phi,y,c,bound,inf,epsabs,epsrel,limit,result,abserr, &
&neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine qagi1

subroutine qagie1(f,phi,y,c,bound,inf,epsabs,epsrel,limit,result, &
&abserr,neval,ier,alist,blist,rlist,elist,iord,last)
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
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, &
&ktmin, maxerr, nres, nrmax, numrl2
real :: a1, a2, abseps, area, area1, area12, area2, b1, b2, boun, &
&correc, defab1, defab2, defabs, dres, epmach, erlarg, erlast, &
&errbnd, errmax, erro12, error1, error2, errsum, ertest, oflow, &
&rerr, res3la(3), resabs, reseps, rlist2(52), small, t, uflow
real :: spmpar
real :: f
!-----------------------------------------------------------------------
!
!                   INTEGRATION OVER INFINITE INTERVALS
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!                     F HAS THE ARGUMENTS X AND PHI.
!
!            PHI    - REAL
!                     FUNCTION SUBPROGRAM HAVING A SINGLE REAL ARGUMENT.
!                     THE ACTUAL NAME FOR PHI MUST BE DECLARED EXTERNAL
!                     IN THE DRIVER PROGRAM.
!
!            BOUND  - REAL
!                     FINITE BOUND OF INTEGRATION RANGE
!                     (HAS NO MEANING IF INTERVAL IS DOUBLY-INFINITE)
!
!            Y      - REAL
!                     PARAMETER FOR USE IN XCOND.  ORDINATE OF
!                     HORIZONTAL LINE ALONG WHICH INTEGRATION
!                     IS PERFORMED.
!
!            C      - REAL
!                     PARAMETER FOR USE IN ACOND AND XCOND.
!
!            INF    - INTEGER
!                     INDICATING THE KIND OF INTEGRATION RANGE
!                     INVOLVED
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!            LIMIT  - INTEGER
!                     GIVES AN UPPER BOUND ON THE NUMBER OF
!                     SUBINTERVALS IN THE PARTITION OF (A,B),
!                     LIMIT.GE.1
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             ESTIMATES FOR RESULT AND ERROR ARE LESS
!                             RELIABLE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS NOT BEEN ACHIEVED.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE
!                             SUBDIVISIONS BY INCREASING THE VALUE
!                             OF LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A LOCAL
!                             DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE
!                             SUBRANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             DETECTED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             AT SOME POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             ROUNDOFF ERROR IS DETECTED IN THE
!                             EXTRAPOLATION TABLE.
!                             IT IS ASSUMED THAT THE REQUESTED TOLERANCE
!                             CANNOT BE ACHIEVED, AND THAT THE RETURNED
!                             RESULT IS THE BEST WHICH CAN BE OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
!                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
!                             OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE.
!                             RESULT, ABSERR, NEVAL, LAST, RLIST(1),
!                             ELIST(1) AND IORD(1) ARE SET TO ZERO.
!                             ALIST(1) AND BLIST(1) ARE SET TO 0
!                             AND 1 RESPECTIVELY.
!
!            ALIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE TRANSFORMED INTEGRATION RANGE (0,1).
!
!            BLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE RIGHT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE TRANSFORMED INTEGRATION RANGE (0,1).
!
!            RLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE INTEGRAL
!                     APPROXIMATIONS ON THE SUBINTERVALS
!
!            ELIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT,  THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE MODULI
!                     OF THE ABSOLUTE ERROR ESTIMATES ON THE
!                     SUBINTERVALS
!
!            IORD   - INTEGER
!                     VECTOR OF DIMENSION LIMIT, THE FIRST K
!                     ELEMENTS OF WHICH ARE POINTERS TO THE
!                     ERROR ESTIMATES OVER THE SUBINTERVALS,
!                     SUCH THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     OTHERWISE
!
!            LAST   - INTEGER
!                     NUMBER OF SUBINTERVALS ACTUALLY PRODUCED
!                     IN THE SUBDIVISION PROCESS
!
!        SUBROUTINES OR FUNCTIONS NEEDED
!              - QK15I1
!              - QPSRT
!              - QELG
!              - F (USER-PROVIDED FUNCTION)
!              - PHI (USER-PROVIDED FUNCTION)
!              - SPMPAR
!
!-----------------------------------------------------------------------
logical :: extrap, noext
!
dimension iord(limit)
!
external f, phi
!
!            THE DIMENSION OF RLIST2 IS DETERMINED BY THE VALUE OF
!            LIMEXP IN SUBROUTINE QELG.
!
!
!            LIST OF MAJOR VARIABLES
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           RLIST(I)  - APPROXIMATION TO THE INTEGRAL OVER
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST (LIMEXP+2),
!                       CONTAINING THE PART OF THE EPSILON TABLE
!                       WICH IS STILL NEEDED FOR FURTHER COMPUTATIONS
!           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       ESTIMATE
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (BEFORE THAT SUBDIVISION HAS TAKEN PLACE)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
!           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       APPROPRIATE APPROXIMATION TO THE COMPOUNDED
!                       INTEGRAL HAS BEEN OBTAINED, IT IS PUT IN
!                       RLIST2(NUMRL2) AFTER NUMRL2 HAS BEEN INCREASED
!                       BY ONE.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED UP
!                       TO NOW, MULTIPLIED BY 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       THAN THE SMALLEST INTERVAL CONSIDERED UP TO NOW
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       IS ATTEMPTING TO PERFORM EXTRAPOLATION. I.E.
!                       BEFORE SUBDIVIDING THE SMALLEST INTERVAL WE
!                       TRY TO DECREASE THE VALUE OF ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       IS NO LONGER ALLOWED (TRUE-VALUE)
!
!            MACHINE DEPENDENT CONSTANTS
!            ---------------------------
!
!           EPMACH IS THE LARGEST RELATIVE SPACING.
!           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
!           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!           TEST ON VALIDITY OF PARAMETERS
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
if (epsabs .lt. 0.0 .or. epsrel .lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach, 0.5e-14)
!
!           FIRST APPROXIMATION TO THE INTEGRAL
!           -----------------------------------
!
!           DETERMINE THE INTERVAL TO BE MAPPED ONTO (0,1).
!           IF INF = 2 THE INTEGRAL IS COMPUTED AS I = I1+I2, WHERE
!           I1 = INTEGRAL OF F OVER (-INFINITY,0),
!           I2 = INTEGRAL OF F OVER (0,+INFINITY).
!
boun = bound
if (inf .eq. 2) boun = 0.0
call qk15i1 (f, phi, y, c, boun, inf, 0.0, 1.0, result, abserr, &
&defabs, resabs, epmach, uflow)
!
!           TEST ON ACCURACY
!
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = amax1(epsabs,rerr*dres)
if (abserr .le. 100.0*epmach*defabs .and. abserr .gt. errbnd) &
&ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr .le. errbnd .and. abserr .ne. resabs) &
&.or. abserr .eq. 0.0) go to 130
!
!           INITIALIZATION
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
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           MAIN DO-LOOP
!           ------------
!
do 90 last = 2,limit
!
!           BISECT THE SUBINTERVAL WITH NRMAX-TH LARGEST
!           ERROR ESTIMATE.
!
  a1 = alist(maxerr)
  b1 = 0.5*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call qk15i1 (f, phi, y, c, boun, inf, a1, b1, area1, error1, &
&resabs, defab1, epmach, uflow)
  call qk15i1 (f, phi, y, c, boun, inf, a2, b2, area2, error2, &
&resabs, defab2, epmach, uflow)
!
!           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
!           AND ERROR AND TEST FOR ACCURACY.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (abs(rlist(maxerr) - area12) .gt. 0.1e-04*abs(area12) &
&.or. erro12 .lt. 0.99*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last .gt. 10 .and. erro12 .gt. errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = amax1(epsabs,rerr*abs(area))
!
!           TEST FOR ROUNDOFF ERROR AND EVENTUALLY
!           SET ERROR FLAG.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF
!           SUBINTERVALS EQUALS LIMIT.
!
  if (last .eq. limit) ier = 1
!
!           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
!           AT SOME POINTS OF THE INTEGRATION RANGE.
!
  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
!
  if (error2 .gt. error1) go to 20
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
!           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
!           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
!           SUBINTERVAL WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE
!           BISECTED NEXT).
!
30 call qpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
  if(errsum.le.errbnd) go to 115
  if(ier.ne.0) go to 100
  if(last.eq.2) go to 80
  if(noext) go to 90
  erlarg = erlarg-erlast
  if(abs(b1-a1).gt.small) erlarg = erlarg+erro12
  if(extrap) go to 40
!
!           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
!           SMALLEST INTERVAL.
!
  if(abs(blist(maxerr)-alist(maxerr)).gt.small) go to 90
  extrap = .true.
  nrmax = 2
40 if(ierro.eq.3.or.erlarg.le.ertest) go to 60
!
!           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
!           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS
!           OVER THE LARGER INTERVALS (ERLARG) AND PERFORM
!           EXTRAPOLATION.
!
  id = nrmax
  jupbnd = last
  if(last.gt.(2+limit/2)) jupbnd = limit+3-last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
    if(abs(blist(maxerr)-alist(maxerr)).gt.small) go to 90
    nrmax = nrmax+1
50 continue
!
!           PERFORM EXTRAPOLATION.
!
60 numrl2 = numrl2+1
  rlist2(numrl2) = area
  call qelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
&epmach, oflow)
  ktmin = ktmin+1
  if(ktmin.gt.5.and.abserr.lt.0.1e-02*errsum) ier = 5
  if(abseps.ge.abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = amax1(epsabs,rerr*abs(reseps))
  if(abserr.le.ertest) go to 100
!
!            PREPARE BISECTION OF THE SMALLEST INTERVAL.
!
70 if(numrl2.eq.1) noext = .true.
  if(ier.eq.5) go to 100
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
!
!           SET FINAL RESULT AND ERROR ESTIMATE.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.0 .and. area .ne. 0.0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.0) go to 130
go to 110
105 if (abserr/abs(result) .gt. errsum/abs(area)) go to 115
!
!           TEST ON DIVERGENCE
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
&defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
&.or. errsum .gt. abs(area)) ier = 6
go to 130
!
!           COMPUTE GLOBAL INTEGRAL SUM.
!
115 result = 0.0
do k = 1,last
  result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf .eq. 2) neval = 2*neval
if (ier .gt. 2) ier = ier - 1
999 return
end subroutine qagie1

subroutine qk15i1 (f, phi, y, c, boun, inf, a, b, result, abserr, &
&resabs, resasc, epmach, uflow)
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
integer :: j
real :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, &
&hlgth, resg, resk, reskh, tabsc1, tabsc2, tol
real :: f
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              THE ORIGINAL (INFINITE) INTEGRATION RANGE IS MAPPED
!              ONTO THE INTERVAL (0,1) AND (A,B) IS A PART OF (0,1).
!              IT IS THE PURPOSE TO COMPUTE
!              I = INTEGRAL OF TRANSFORMED INTEGRAND OVER (A,B),
!              J = INTEGRAL OF ABS(TRANSFORMED INTEGRAND) OVER (A,B).
!
! 2.        PARAMETERS
!            ON ENTRY
!              F      - REAL
!                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       TO BE DECLARED E X T E R N A L IN THE
!                       CALLING PROGRAM. F HAS THE ARGUMENTS X AND
!                       PHI.
!
!              PHI    - REAL
!                       FUNCTION SUBPROGRAM HAVING A SINGLE REAL
!                       ARGUMENT. THE ACTUAL NAME FOR PHI MUST BE
!                       DECHARED EXTERNAL IN THE DRIVER PROGRAM.
!
!              BOUN   - REAL
!                       FINITE BOUND OF ORIGINAL INTEGRATION
!                       RANGE (SET TO ZERO IF INF = +2)
!
!              INF    - INTEGER
!                       IF INF = -1, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,BOUND),
!                       IF INF = +1, THE ORIGINAL INTERVAL IS
!                                   (BOUND,+INFINITY),
!                       IF INF = +2, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,+INFINITY) AND
!                       THE INTEGRAL IS COMPUTED AS THE SUM OF TWO
!                       INTEGRALS, ONE OVER (-INFINITY,0)
!                       AND ONE OVER (0,+INFINITY).
!
!              A      - REAL
!                       LOWER LIMIT FOR INTEGRATION OVER SUBRANGE
!                       OF (0,1)
!
!              B      - REAL
!                       UPPER LIMIT FOR INTEGRATION OVER SUBRANGE
!                       OF (0,1)
!
!              EPMACH - REAL
!                       THE RELATIVE PRECISION OF THE FLOATING
!                       ARITHMETIC BEING USED.
!
!              UFLOW  - REAL
!                       THE SMALLEST POSITIVE MAGNITUDE.
!
!            ON RETURN
!              RESULT - REAL
!                       APPROXIMATION TO THE INTEGRAL I
!                       RESULT IS COMPUTED BY APPLYING THE 15-POINT
!                       KRONROD RULE(RESK) OBTAINED BY OPTIMAL
!                       ADDITION OF ABSCISSAE TO THE 7-POINT GAUSS
!                       RULE(RESG).
!
!              ABSERR - REAL
!                       ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                       WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!              RESABS - REAL
!                       APPROXIMATION TO THE INTEGRAL J
!
!              RESASC - REAL
!                       APPROXIMATION TO THE INTEGRAL OF
!                       ABS((TRANSFORMED INTEGRAND)-I/(B-A))
!                       OVER (A,B)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (USER-PROVIDED FUNCTION)
!                 - PHI (USER-PROVIDED FUNCTION)
!
!-----------------------------------------------------------------------
real :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
!
external f, phi
!
!           THE ABSCISSAE AND WEIGHTS ARE SUPPLIED FOR THE INTERVAL
!           (-1,1).  BECAUSE OF SYMMETRY ONLY THE POSITIVE ABSCISSAE AND
!           THEIR CORRESPONDING WEIGHTS ARE GIVEN.
!
!           XGK    - ABSCISSAE OF THE 15-POINT KRONROD RULE
!                    XGK(2), XGK(4), ... ABSCISSAE OF THE 7-POINT
!                    GAUSS RULE
!                    XGK(1), XGK(3), ...  ABSCISSAE WHICH ARE OPTIMALLY
!                    ADDED TO THE 7-POINT GAUSS RULE
!
!           WGK    - WEIGHTS OF THE 15-POINT KRONROD RULE
!
!           WG     - WEIGHTS OF THE 7-POINT GAUSS RULE, CORRESPONDING
!                    TO THE ABSCISSAE XGK(2), XGK(4), ...
!                    WG(1), WG(3), ... ARE SET TO ZERO.
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
&xgk(8)/ &
&0.9914553711208126e+00,     0.9491079123427585e+00, &
&0.8648644233597691e+00,     0.7415311855993944e+00, &
&0.5860872354676911e+00,     0.4058451513773972e+00, &
&0.2077849550078985e+00,     0.0000000000000000e+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
&wgk(8)/ &
&0.2293532201052922e-01,     0.6309209262997855e-01, &
&0.1047900103222502e+00,     0.1406532597155259e+00, &
&0.1690047266392679e+00,     0.1903505780647854e+00, &
&0.2044329400752989e+00,     0.2094821410847278e+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5),wg(6),wg(7),wg(8)/ &
&0.0000000000000000e+00,     0.1294849661688697e+00, &
&0.0000000000000000e+00,     0.2797053914892767e+00, &
&0.0000000000000000e+00,     0.3818300505051189e+00, &
&0.0000000000000000e+00,     0.4179591836734694e+00/
!
!
!           LIST OF MAJOR VARIABLES
!           -----------------------
!
!           CENTR  - MID POINT OF THE INTERVAL
!           HLGTH  - HALF-LENGTH OF THE INTERVAL
!           ABSC*  - ABSCISSA
!           TABSC* - TRANSFORMED ABSCISSA
!           FVAL*  - FUNCTION VALUE
!           RESG   - RESULT OF THE 7-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 15-POINT KRONROD FORMULA
!           RESKH  - APPROXIMATION TO THE MEAN VALUE OF THE TRANSFORMED
!                    INTEGRAND OVER (A,B), I.E. TO I/(B-A)
!
!
dinf = min0(1,inf)
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1,y,c,phi)
if (inf .eq. 2) fval1 = fval1 + f(-tabsc1,y,c,phi)
fc = (fval1/centr)/centr
!
!           COMPUTE THE 15-POINT KRONROD APPROXIMATION TO
!           THE INTEGRAL, AND ESTIMATE THE ERROR.
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
  if (inf .eq. 2) fval1 = fval1 + f(-tabsc1,y,c,phi)
  if (inf .eq. 2) fval2 = fval2 + f(-tabsc2,y,c,phi)
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
  resasc = resasc + wgk(j)*(abs(fv1(j)-reskh) + &
&abs(fv2(j)-reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc .ne. 0.0 .and. abserr .ne. 0.0) abserr = resasc* &
&amin1(1.0, (0.2e+03*abserr/resasc)**1.5)
tol = 50.0*epmach
if (resabs .gt. uflow/tol) abserr = amax1(abserr, tol*resabs)
return
end subroutine qk15i1

subroutine fft (c,n,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: isn, n
real, intent(inout) :: c(*)
!-----------------------------------------------------------------------
!     THE COMPLEX ARRAY C OF DIMENSION N IS INTERPRETED BY THE CODE
!     AS A REAL ARRAY OF DIMENSION 2*N. IF THIS ASSOCIATION IS NOT
!     PERMITTED BY THE FORTRAN BEING USED, THEN THE USER MAY USE THE
!     SUBROUTINE FFT1.
!-----------------------------------------------------------------------
if (iabs(isn) .ne. 1) go to 10
call sfft (c(1),c(2),n,n,n,isn+isn,ierr)
return
10 ierr = 4
return
end subroutine fft

subroutine fft1 (a,b,n,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: isn, n
real, intent(inout) :: a(n), b(n)
!     ------------
if (iabs(isn) .ne. 1) go to 10
call sfft (a,b,n,n,n,isn,ierr)
return
10 ierr = 4
return
end subroutine fft1

subroutine mfft (c,n,ndim,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: isn, ndim
integer :: i, isign, nspan, ntot
real, intent(inout) :: c(*)
integer :: n(ndim)
!-----------------------------------------------------------------------
!     LET NTOT DENOTE THE PRODUCT OF N(1),...,N(NDIM). THE COMPLEX
!     ARRAY C OF DIMENSION NTOT IS INTERPRETED BY THE ROUTINE AS
!     A REAL ARRAY OF DIMENSION 2*NTOT. IF THIS ASSOCIATION IS NOT
!     PERMITTED BY THE FORTRAN BEING USED, THEN THE USER MAY USE
!     THE SUBROUTINE MFFT1.
!-----------------------------------------------------------------------
if (iabs(isn) .ne. 1) go to 40
if (ndim .le. 0) go to 50
ntot = 1
do i = 1,ndim
   ntot = n(i)*ntot
end do
if (ntot .lt. 1) go to 30
!
isign = isn + isn
nspan = 1
do i = 1,ndim
   nspan = n(i)*nspan
   call sfft (c(1),c(2),ntot,n(i),nspan,isign,ierr)
   if (ierr .ne. 0) return
end do
return
!
30 ierr = 1
return
40 ierr = 4
return
50 ierr = 5
return
end subroutine mfft

subroutine mfft1 (a,b,n,ndim,isn,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: isn
integer, intent(in) :: ndim
integer :: i, nspan, ntot
real, intent(inout) :: a(*), b(*)
integer :: n(ndim)
!     ------------
if (iabs(isn) .ne. 1) go to 40
if (ndim .le. 0) go to 50
ntot = 1
do i = 1,ndim
   ntot = n(i)*ntot
end do
if (ntot .lt. 1) go to 30
!
nspan = 1
do i = 1,ndim
   nspan = n(i)*nspan
   call sfft (a,b,ntot,n(i),nspan,isn,ierr)
   if (ierr .ne. 0) return
end do
return
!
30 ierr = 1
return
40 ierr = 4
return
50 ierr = 5
return
end subroutine mfft1

subroutine sfft(a,b,ntot,n,nspan,isn,ierr)
implicit none
integer :: ierr, isn, n, nspan, ntot
real :: a(*), b(*)
integer :: i, ii, inc, j, jc, jf, jj, k, k1, k2, k3, k4, kk, ks, &
&kspan, kspnn, kt, l, m, max, maxf, maxn, maxp, nfac(15), nn, &
&np(209), nt, num
real :: aa, aj, ajm, ajp, ak, akm, akp, at(23), bb, bj, bjm, bjp, &
&bk, bkm, bkp, bt(23), c1, c2, c3, c72, cd, ck(23), rad, radf, s1, &
&s120, s2, s3, s72, sd, sk(23), u, v
!  MULTIVARIATE COMPLEX FOURIER TRANSFORM, COMPUTED IN PLACE
!    USING MIXED-RADIX FAST FOURIER TRANSFORM ALGORITHM.
!  BY R. C. SINGLETON, STANFORD RESEARCH INSTITUTE, OCT. 1968
!    MODIFIED BY A. H. MORRIS, NSWC/DL, DAHLGREN VA
!  ARRAYS A AND B ORIGINALLY HOLD THE REAL AND IMAGINARY
!    COMPONENTS OF THE DATA, AND RETURN THE REAL AND
!    IMAGINARY COMPONENTS OF THE RESULTING FOURIER COEFFICIENTS.
!  MULTIVARIATE DATA IS INDEXED ACCORDING TO THE FORTRAN
!    ARRAY ELEMENT SUCCESSOR FUNCTION, WITHOUT LIMIT
!    ON THE NUMBER OF IMPLIED MULTIPLE SUBSCRIPTS.
!    THE SUBROUTINE IS CALLED ONCE FOR EACH VARIATE.
!    THE CALLS FOR A MULTIVARIATE TRANSFORM MAY BE IN ANY ORDER.
!  NTOT IS THE TOTAL NUMBER OF COMPLEX DATA VALUES.
!  N IS THE DIMENSION OF THE CURRENT VARIABLE.
!  NSPAN/N IS THE SPACING OF CONSECUTIVE DATA VALUES
!    WHILE INDEXING THE CURRENT VARIABLE.
!  THE SIGN OF ISN DETERMINES THE SIGN OF THE COMPLEX
!    EXPONENTIAL, AND THE MAGNITUDE OF ISN IS NORMALLY ONE.
!  A TRI-VARIATE TRANSFORM WITH A(N1,N2,N3), B(N1,N2,N3)
!    IS COMPUTED BY
!      CALL SFFT(A,B,N1*N2*N3,N1,N1,1,IERR)
!      CALL SFFT(A,B,N1*N2*N3,N2,N1*N2,1,IERR)
!      CALL SFFT(A,B,N1*N2*N3,N3,N1*N2*N3,1,IERR)
!  FOR A SINGLE-VARIATE TRANSFORM,
!    NTOT = N = NSPAN = (NUMBER OF COMPLEX DATA VALUES), E.G.
!      CALL SFFT(A,B,N,N,N,1,IERR)
!  THE DATA MAY ALTERNATIVELY BE STORED IN A SINGLE COMPLEX
!    ARRAY A, THEN THE MAGNITUDE OF ISN CHANGED TO TWO TO
!    GIVE THE CORRECT INDEXING INCREMENT AND A(2) USED TO
!    PASS THE INITIAL ADDRESS FOR THE SEQUENCE OF IMAGINARY
!    VALUES, E.G.
!      CALL SFFT(A,A(2),NTOT,N,NSPAN,2,IERR)
!  ARRAYS NFAC(MAXN),NP(MAXP),AT(MAXF),CK(MAXF),BT(MAXF),SK(MAXF)
!    ARE USED FOR TEMPORARY STORAGE.
!    MAXN MUST BE .GE. THE NUMBER OF FACTORS OF N
!    MAXF MUST BE .GE. THE MAXIMUM PRIME FACTOR OF N.
!    MAXP MUST BE .GT. THE NUMBER OF PRIME FACTORS OF N.
!    IN ADDITION, MAXN IS ASSUMED TO BE ODD.
!    IF THE SQUARE-FREE PORTION K OF N HAS TWO OR MORE PRIME
!    FACTORS, THEN MAXP MUST BE .GE. K-1.
!  IERR IS A VARIABLE. IERR IS SET TO 0 IF NO INPUT ERRORS ARE
!    DETECTED. OTHERWISE, IERR IS ASSIGNED ONE OF THE VALUES
!      IERR=1    N IS LESS THAN 1
!      IERR=2    N HAS MORE THAN MAXN FACTORS
!      IERR=3    N HAS A PRIME FACTOR GREATER THAN
!                MAXF OR THE SQUARE-FREE PORTION OF
!                N IS GREATER THAN MAXP+1
!  ARRAY STORAGE IN NFAC FOR A MAXIMUM OF 15 FACTORS OF N.
!  IF N HAS MORE THAN ONE SQUARE-FREE FACTOR, THE PRODUCT OF THE
!    SQUARE-FREE FACTORS MUST BE .LE. 210
!  ARRAY STORAGE FOR MAXIMUM PRIME FACTOR OF 23
equivalence (i,ii)
!  THE FOLLOWING CONSTANTS SHOULD AGREE WITH THE ARRAY DIMENSIONS.
maxn=15
maxf=23
maxp=209
!  SET THE FOLLOWING CONSTANTS
!     RAD=2.0*PI
!     S72=SIN(RAD/5.0)
!     C72=COS(RAD/5.0)
!     S120=SQRT(0.75)
rad=6.2831853071796
s72=.951056516295154
c72=.309016994374947
s120=.86602540378444
!
ierr=0
if(n-1) 1000,960,5
5 inc=isn
if(isn .ge. 0) go to 10
s72=-s72
s120=-s120
rad=-rad
inc=-inc
10 nt=inc*ntot
ks=inc*nspan
kspan=ks
nn=nt-inc
jc=ks/n
radf=rad*float(jc)*0.5
i=0
jf=0
!  DETERMINE THE FACTORS OF N
m=0
k=n
max=maxn/2
go to 20
15 if(m .eq. max) go to 1001
m=m+1
nfac(m)=4
k=l
20 l=k/16
if(k .eq. l*16) go to 15
j=3
jj=9
go to 30
25 if(m .eq. max) go to 1001
m=m+1
nfac(m)=j
k=k/jj
30 if(mod(k,jj) .eq. 0) go to 25
j=j+2
jj=j**2
if(j .le. maxf .and. jj .le. k) go to 30
if(k .gt. 4) go to 40
kt=m
nfac(m+1)=k
if(k .ne. 1) m=m+1
go to 80
40 l=k/4
if(k .ne. l*4) go to 50
if(m .eq. max) go to 1001
m=m+1
nfac(m)=2
k=l
kt=m
if(k .eq. 1) go to 85
50 kt=m
if(k-1 .gt. maxp) go to 1002
num=maxn-kt-kt
j=2
60 if(mod(k,j) .ne. 0) go to 70
m=m+1
nfac(m)=j
num=num-1
k=k/j
if(k .eq. 1) go to 80
if(num .le. 0) go to 1001
70 l=(j+1)/2
j=l+l+1
if(j .le. maxf) go to 60
go to 1002
80 if(kt .eq. 0) go to 100
85 j=kt
90 m=m+1
nfac(m)=nfac(j)
j=j-1
if(j .ne. 0) go to 90
!  COMPUTE FOURIER TRANSFORM
100 sd=radf/float(kspan)
cd=2.0*sin(sd)**2
sd=sin(sd+sd)
kk=1
i=i+1
if(nfac(i) .ne. 2) go to 400
!  TRANSFORM FOR FACTOR OF 2 (INCLUDING ROTATION FACTOR)
kspan=kspan/2
k1=kspan+2
210 k2=kk+kspan
ak=a(k2)
bk=b(k2)
a(k2)=a(kk)-ak
b(k2)=b(kk)-bk
a(kk)=a(kk)+ak
b(kk)=b(kk)+bk
kk=k2+kspan
if(kk .le. nn) go to 210
kk=kk-nn
if(kk .le. jc) go to 210
if(kk .gt. kspan) go to 800
220 c1=1.0-cd
s1=sd
230 k2=kk+kspan
ak=a(kk)-a(k2)
bk=b(kk)-b(k2)
a(kk)=a(kk)+a(k2)
b(kk)=b(kk)+b(k2)
a(k2)=c1*ak-s1*bk
b(k2)=s1*ak+c1*bk
kk=k2+kspan
if(kk .lt. nt) go to 230
k2=kk-nt
c1=-c1
kk=k1-k2
if(kk .gt. k2) go to 230
u=sd*s1+cd*c1
v=sd*c1-cd*s1
ak=c1-u
s1=s1+v
!  THE FOLLOWING THREE STATEMENTS COMPENSATE FOR TRUNCATION ERROR.
!    IF ROUNDED ARITHMETIC IS USED THEN ONE MAY SUBSTITUTE
!     C1=AK
c1=1.5-0.5*(ak*ak+s1*s1)
s1=c1*s1
c1=c1*ak
kk=kk+jc
if(kk .lt. k2) go to 230
k1=k1+inc+inc
kk=(k1-kspan)/2+jc
if(kk .le. jc+jc) go to 220
go to 100
!  TRANSFORM FOR FACTOR OF 3 (OPTIONAL CODE)
320 k1=kk+kspan
k2=k1+kspan
ak=a(kk)
bk=b(kk)
aj=a(k1)+a(k2)
bj=b(k1)+b(k2)
a(kk)=ak+aj
b(kk)=bk+bj
ak=-0.5*aj+ak
bk=-0.5*bj+bk
aj=(a(k1)-a(k2))*s120
bj=(b(k1)-b(k2))*s120
a(k1)=ak-bj
b(k1)=bk+aj
a(k2)=ak+bj
b(k2)=bk-aj
kk=k2+kspan
if(kk .lt. nn) go to 320
kk=kk-nn
if(kk .le. kspan) go to 320
go to 700
!  TRANSFORM FOR FACTOR OF 4
400 if(nfac(i) .ne. 4) go to 600
kspnn=kspan
kspan=kspan/4
410 c1=1.0
s1=0.0
420 k1=kk+kspan
k2=k1+kspan
k3=k2+kspan
akp=a(kk)+a(k2)
akm=a(kk)-a(k2)
ajp=a(k1)+a(k3)
ajm=a(k1)-a(k3)
a(kk)=akp+ajp
ajp=akp-ajp
bkp=b(kk)+b(k2)
bkm=b(kk)-b(k2)
bjp=b(k1)+b(k3)
bjm=b(k1)-b(k3)
b(kk)=bkp+bjp
bjp=bkp-bjp
if(isn .lt. 0) go to 450
akp=akm-bjm
akm=akm+bjm
bkp=bkm+ajm
bkm=bkm-ajm
if(s1 .eq. 0.0) go to 460
430 a(k1)=akp*c1-bkp*s1
b(k1)=akp*s1+bkp*c1
a(k2)=ajp*c2-bjp*s2
b(k2)=ajp*s2+bjp*c2
a(k3)=akm*c3-bkm*s3
b(k3)=akm*s3+bkm*c3
kk=k3+kspan
if(kk .le. nt) go to 420
440 u=sd*s1+cd*c1
v=sd*c1-cd*s1
c2=c1-u
s1=s1+v
!  THE FOLLOWING THREE STATEMENTS COMPENSATE FOR TRUNCATION ERROR.
!    IF ROUNDED ARITHMETIC IS USED THEN ONE MAY SUBSTITUTE
!     C1=C2
c1=1.5-0.5*(c2*c2+s1*s1)
s1=c1*s1
c1=c1*c2
c2=c1*c1-s1*s1
s2=2.0*c1*s1
c3=c2*c1-s2*s1
s3=c2*s1+s2*c1
kk=kk-nt+jc
if(kk .le. kspan) go to 420
kk=kk-kspan+inc
if(kk .le. jc) go to 410
if(kspan .eq. jc) go to 800
go to 100
450 akp=akm+bjm
akm=akm-bjm
bkp=bkm-ajm
bkm=bkm+ajm
if(s1 .ne. 0.0) go to 430
460 a(k1)=akp
b(k1)=bkp
a(k2)=ajp
b(k2)=bjp
a(k3)=akm
b(k3)=bkm
kk=k3+kspan
if(kk .le. nt) go to 420
go to 440
!  TRANSFORM FOR FACTOR OF 5 (OPTIONAL CODE)
510 c2=c72**2-s72**2
s2=2.0*c72*s72
520 k1=kk+kspan
k2=k1+kspan
k3=k2+kspan
k4=k3+kspan
akp=a(k1)+a(k4)
akm=a(k1)-a(k4)
bkp=b(k1)+b(k4)
bkm=b(k1)-b(k4)
ajp=a(k2)+a(k3)
ajm=a(k2)-a(k3)
bjp=b(k2)+b(k3)
bjm=b(k2)-b(k3)
aa=a(kk)
bb=b(kk)
a(kk)=aa+akp+ajp
b(kk)=bb+bkp+bjp
ak=akp*c72+ajp*c2+aa
bk=bkp*c72+bjp*c2+bb
aj=akm*s72+ajm*s2
bj=bkm*s72+bjm*s2
a(k1)=ak-bj
a(k4)=ak+bj
b(k1)=bk+aj
b(k4)=bk-aj
ak=akp*c2+ajp*c72+aa
bk=bkp*c2+bjp*c72+bb
aj=akm*s2-ajm*s72
bj=bkm*s2-bjm*s72
a(k2)=ak-bj
a(k3)=ak+bj
b(k2)=bk+aj
b(k3)=bk-aj
kk=k4+kspan
if(kk .lt. nn) go to 520
kk=kk-nn
if(kk .le. kspan) go to 520
go to 700
!  TRANSFORM FOR ODD FACTORS
600 k=nfac(i)
kspnn=kspan
kspan=kspan/k
if(k .eq. 3) go to 320
if(k .eq. 5) go to 510
if(k .eq. jf) go to 640
jf=k
s1=rad/float(k)
c1=cos(s1)
s1=sin(s1)
ck(jf)=1.0
sk(jf)=0.0
j=1
630 ck(j)=ck(k)*c1+sk(k)*s1
sk(j)=ck(k)*s1-sk(k)*c1
k=k-1
ck(k)=ck(j)
sk(k)=-sk(j)
j=j+1
if(j .lt. k) go to 630
640 k1=kk
k2=kk+kspnn
aa=a(kk)
bb=b(kk)
ak=aa
bk=bb
j=1
k1=k1+kspan
650 k2=k2-kspan
j=j+1
at(j)=a(k1)+a(k2)
ak=at(j)+ak
bt(j)=b(k1)+b(k2)
bk=bt(j)+bk
j=j+1
at(j)=a(k1)-a(k2)
bt(j)=b(k1)-b(k2)
k1=k1+kspan
if(k1 .lt. k2) go to 650
a(kk)=ak
b(kk)=bk
k1=kk
k2=kk+kspnn
j=1
660 k1=k1+kspan
k2=k2-kspan
jj=j
ak=aa
bk=bb
aj=0.0
bj=0.0
k=1
670 k=k+1
ak=at(k)*ck(jj)+ak
bk=bt(k)*ck(jj)+bk
k=k+1
aj=at(k)*sk(jj)+aj
bj=bt(k)*sk(jj)+bj
jj=jj+j
if(jj .gt. jf) jj=jj-jf
if(k .lt. jf) go to 670
k=jf-j
a(k1)=ak-bj
b(k1)=bk+aj
a(k2)=ak+bj
b(k2)=bk-aj
j=j+1
if(j .lt. k) go to 660
kk=kk+kspnn
if(kk .le. nn) go to 640
kk=kk-nn
if(kk .le. kspan) go to 640
!  MULTIPLY BY ROTATION FACTOR (EXCEPT FOR FACTORS OF 2 AND 4)
700 if(i .eq. m) go to 800
kk=jc+1
710 c2=1.0-cd
s1=sd
720 c1=c2
s2=s1
kk=kk+kspan
730 ak=a(kk)
a(kk)=c2*ak-s2*b(kk)
b(kk)=s2*ak+c2*b(kk)
kk=kk+kspnn
if(kk .le. nt) go to 730
ak=s1*s2
s2=s1*c2+c1*s2
c2=c1*c2-ak
kk=kk-nt+kspan
if(kk .le. kspnn) go to 730
u=sd*s1+cd*c1
v=sd*c1-cd*s1
c2=c1-u
s1=s1+v
!  THE FOLLOWING THREE STATEMENTS COMPENSATE FOR TRUNCATION
!    ERROR.  IF ROUNDED ARITHMETIC IS USED THEN THEY MAY
!    BE DELETED.
c1=1.5-0.5*(c2*c2+s1*s1)
s1=c1*s1
c2=c1*c2
kk=kk-kspnn+jc
if(kk .le. kspan) go to 720
kk=kk-kspan+jc+inc
if(kk .le. jc+jc) go to 710
go to 100
!  PERMUTE THE RESULTS TO NORMAL ORDER---DONE IN TWO STAGES
!  PERMUTATION FOR SQUARE FACTORS OF N
800 np(1)=ks
if(kt .eq. 0) go to 890
k=kt+kt+1
if(m .lt. k) k=k-1
j=1
np(k+1)=jc
810 np(j+1)=np(j)/nfac(j)
np(k)=np(k+1)*nfac(j)
j=j+1
k=k-1
if(j .lt. k) go to 810
k3=np(k+1)
kspan=np(2)
kk=jc+1
k2=kspan+1
j=1
if(n .ne. ntot) go to 850
!  PERMUTATION FOR SINGLE-VARIATE TRANSFORM (OPTIONAL CODE)
820 ak=a(kk)
a(kk)=a(k2)
a(k2)=ak
bk=b(kk)
b(kk)=b(k2)
b(k2)=bk
kk=kk+inc
k2=kspan+k2
if(k2 .lt. ks) go to 820
830 k2=k2-np(j)
j=j+1
k2=np(j+1)+k2
if(k2 .gt. np(j)) go to 830
j=1
840 if(kk .lt. k2) go to 820
kk=kk+inc
k2=kspan+k2
if(k2 .lt. ks) go to 840
if(kk .lt. ks) go to 830
jc=k3
go to 890
!  PERMUTATION FOR MULTIVARIATE TRANSFORM
850 k=kk+jc
860 ak=a(kk)
a(kk)=a(k2)
a(k2)=ak
bk=b(kk)
b(kk)=b(k2)
b(k2)=bk
kk=kk+inc
k2=k2+inc
if(kk .lt. k) go to 860
kk=kk+ks-jc
k2=k2+ks-jc
if(kk .lt. nt) go to 850
k2=k2-nt+kspan
kk=kk-nt+jc
if(k2 .lt. ks) go to 850
870 k2=k2-np(j)
j=j+1
k2=np(j+1)+k2
if(k2 .gt. np(j)) go to 870
j=1
880 if(kk .lt. k2) go to 850
kk=kk+jc
k2=kspan+k2
if(k2 .lt. ks) go to 880
if(kk .lt. ks) go to 870
jc=k3
890 if(2*kt+1 .ge. m) return
kspnn=np(kt+1)
!  PERMUTATION FOR SQUARE-FREE FACTORS OF N
j=m-kt
nfac(j+1)=1
900 nfac(j)=nfac(j)*nfac(j+1)
j=j-1
if(j .ne. kt) go to 900
kt=kt+1
nn=nfac(kt)-1
jj=0
j=0
go to 906
902 jj=jj-k2
k2=kk
k=k+1
kk=nfac(k)
904 jj=kk+jj
if(jj .ge. k2) go to 902
np(j)=jj
906 k2=nfac(kt)
k=kt+1
kk=nfac(k)
j=j+1
if(j .le. nn) go to 904
!  DETERMINE THE PERMUTATION CYCLES OF LENGTH GREATER THAN 1
j=0
go to 914
910 k=kk
kk=np(k)
np(k)=-kk
if(kk .ne. j) go to 910
k3=kk
914 j=j+1
kk=np(j)
if(kk .lt. 0) go to 914
if(kk .ne. j) go to 910
np(j)=-j
if(j .ne. nn) go to 914
maxf=inc*maxf
!  REORDER A AND B, FOLLOWING THE PERMUTATION CYCLES
go to 950
924 j=j-1
if(np(j) .lt. 0) go to 924
jj=jc
926 kspan=jj
if(jj .gt. maxf) kspan=maxf
jj=jj-kspan
k=np(j)
kk=jc*k+ii+jj
k1=kk+kspan
k2=0
928 k2=k2+1
at(k2)=a(k1)
bt(k2)=b(k1)
k1=k1-inc
if(k1 .ne. kk) go to 928
932 k1=kk+kspan
k2=k1-jc*(k+np(k))
k=-np(k)
936 a(k1)=a(k2)
b(k1)=b(k2)
k1=k1-inc
k2=k2-inc
if(k1 .ne. kk) go to 936
kk=k2
if(k .ne. j) go to 932
k1=kk+kspan
k2=0
940 k2=k2+1
a(k1)=at(k2)
b(k1)=bt(k2)
k1=k1-inc
if(k1 .ne. kk) go to 940
if(jj .ne. 0) go to 926
if(j .ne. 1) go to 924
950 j=k3+1
nt=nt-kspnn
ii=nt-inc+1
if(nt .ge. 0) go to 924
960 return
!  ERROR FINISH - THERE IS AN INPUT ERROR
1000 ierr=1
return
1001 ierr=2
return
1002 ierr=3
return
end subroutine sfft

!     ******************************************************************
!
!     SUBROUTINE COSQI(N,WSAVE)
!
!     ******************************************************************
!
!     SUBROUTINE COSQI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN
!     BOTH COSQF AND COSQB. THE PRIME FACTORIZATION OF N TOGETHER WITH
!     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND
!     STORED IN WSAVE.
!
!     INPUT PARAMETER
!
!     N       THE LENGTH OF THE ARRAY TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!
!     OUTPUT PARAMETER
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
!             THE SAME WORK ARRAY CAN BE USED FOR BOTH COSQF AND COSQB
!             AS LONG AS N REMAINS UNCHANGED. DIFFERENT WSAVE ARRAYS
!             ARE REQUIRED FOR DIFFERENT VALUES OF N. THE CONTENTS OF
!             WSAVE MUST NOT BE CHANGED BETWEEN CALLS OF COSQF OR COSQB.
!
