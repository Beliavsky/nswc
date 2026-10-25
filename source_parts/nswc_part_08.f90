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
! Begin k-TH iteration step.
30 if (k.lt.2) go to 40
if (((64.*rdx2.lt.rdx1) .and. (rdx2.gt.eta2*rnx)) .or. &
&((64.*rdr2.lt.rdr1) .and. (rdr2.gt.eta2*rnr))) go to 40
go to 270
40 rdx1 = rdx2
rdr1 = rdr2
rdx2 = 0.0
rdr2 = 0.0
if (k.eq.0) go to 160
! New residuals.
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
! END k-TH ITERATION STEP.
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
! Subroutine solve3 is called only by subroutine solve2.
! This subroutine calculates new values of f.
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
! Subroutine covar uses results from the orthogonal decomposition
! stored in c, d and ipivot to compute the unscaled covariance matrix
! of the least squares coefficients.
! On entry, the first n rows and the first n columns of c contain the
! upper triangular matrix obtained from the decomposition.  This input
! matrix is destroyed in subsequent calculations.
! On exit, the lower triangular portion of the symmetric unscaled
! covariance matrix is contained in
!     c(1,1)
!     c(2,1) c(2,2)
!     . . .
!     c(n,1) c(n,2) ... c(n,n)
! if n1 is less than n, one or more columns of the matrix
! H = (sqrt(W))*a were rejected as being linearly dependent.  Whenever
! the k-TH column of H was so rejected, c(i,j) is set equal to zero,
! FOR i = k OR j = k, i.GE.J.
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
! Permute the columns and rows of matrix c to account for pivoting.
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
!     splsq finds a solution x to the following problems ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  a*x = B
!
!     2. Linear least squares  --    solve  a*x = B
!                                    in the least-squares sense
!
!     3. Damped least squares  --    solve  (   a    )*x = ( B )
!                                           ( damp*i )     ( 0 )
!                                    in the least-squares sense
!
!     Where A is a matrix with m rows and n columns, B an m-vector,
!     and damp a scalar. (All quantities are real.) The matrix a is
!     a sparse matrix stored rowwise in the arrays A,ia,ja.
!
!     The RHS vector B is input via u, and is subsequently overwritten.
!
!
!     Note. splsq uses an iterative method to approximate the solution.
!     The number of iterations required to reach a certain accuracy
!     depends strongly on the scaling of the problem. Poor scaling of
!     the rows or columns of A should therefore be avoided whenever
!     possible.
!
!     For example, in problem 1 the solution is unaltered by
!     row-scaling.  If a row of A is very small or large compared to
!     the other rows of A, the corresponding row of (A  B) should be
!     scaled up or down.
!
!     In problems 1 and 2, the solution x is easily recovered
!     following column scaling. In the absence of better information,
!     the nonzero columns of A should be scaled so that they all have
!     the same Euclidean norm (E.G.  1.0).
!
!     In problem 3, there is no freedom to RE-scale if damp is
!     nonzero. However, the value of damp should be assigned only
!     after attention has been paid to the scaling of A.
!
!     The parameter damp is intended to help regularize
!     ill-conditioned systems, by preventing the true solution from
!     being very large. Another aid to regularization is provided by
!     the parameter acond, which may be used to terminate iterations
!     before the computed solution becomes very large.
!
!
!     Notation
!     --------
!
!     The following quantities are used in discussing the subroutine
!     parameters...
!
!     abar   =  (   a    ),          bbar  =  ( b )
!               ( damp*i )                    ( 0 )
!
!     r      =  b  -  a*x,           rbar  =  bbar  -  abar*x
!
!     rnorm  =  sqrt( norm(r)**2  +  damp**2 * norm(x)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  The smallest floating point number for which
!               1 + RELPR .GT. 1.
!
!     splsq  minimizes the function rnorm with respect to x.
!
!
!     Parameters
!     ----------
!
!     m       INPUT      THE NUMBER OF ROWS IN A.
!
!     n       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     a,ia,ja INPUT      THE MATRIX a STORED ROWWISE IN SPARSE FORM.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (Damp  should be 0.0 for problems 1 and 2.)
!                        if the system  a*x = B  is incompatible, values
!                        of damp in the range 0 to sqrt(RELPR)*norm(a)
!                        will probably have a negligible effect.
!                        Larger values of damp will tend to decrease
!                        the norm of x and to reduce the number of
!                        iterations required by splsq.
!
!                        The work per iteration and the storage needed
!                        by splsq are the same for all values of damp.
!
!     u(m)    INPUT      THE RHS VECTOR B. BE AWARE THAT u IS
!                        over-written by splsq.
!
!     x(n)    OUTPUT     RETURNS THE COMPUTED SOLUTION x.
!
!     atol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the matrix a. for example,
!                        if A is accurate to about 6 digits, set
!                        atol = 1.0e-6 .
!
!     btol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the RHS vector B. for example,
!                        if B is accurate to about 6 digits, set
!                        btol = 1.0e-6 .
!
!     conlim  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        condition number of the matrix abar.
!                        Iterations will be terminated if a computed
!                        estimate of cond(ABAR) exceeds conlim.
!                        This is intended to prevent certain small or
!                        zero singular values of A or ABAR from
!                        coming into effect and causing unwanted growth
!                        in the computed solution.
!
!                        conlim and damp may be used separately or
!                        together to regularize ill-conditioned systems.
!
!                        Normally, conlim should be in the range
!                        1000  TO  1/RELPR.
!                        Suggested value --
!                        conlim = 1/(100*RELPR)  for compatible systems,
!                        conlim = 1/(10*sqrt(RELPR))  for least squares.
!
!             Note. If the user is not concerned about the parameters
!             atol, btol, and conlim, any or all of them may be set
!             to zero. The effect will be the same as the values
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     itnlim  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        Suggested value --
!                        itnlim = n/2     for well conditioned systems,
!                        itnlim = 4*n     OTHERWISE.
!
!     istop   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       x = 0  Is the exact solution.
!                        No iterations were performed.
!
!                1       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is sufficiently
!                        small, given the values of atol and btol.
!
!                2       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is sufficiently accurate,
!                        given the value of atol.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        conlim. The system  a*x = B  appears to be
!                        ill-conditioned.
!
!                4       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is as small as
!                        seems reasonable on this machine.
!
!                5       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is as accurate as seems
!                        reasonable on this machine.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        not much point in doing further iterations,
!                        given the precision of this machine.
!
!                7       THE ITERATION LIMIT itnlim WAS REACHED.
!
!
!     itn     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     acond   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        number of ABAR.
!
!     rnorm   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        the function being minimized (see notation
!                        above). This will be small if  a*x = B  has
!                        A SOLUTION.
!
!     xnorm   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        solution vector x.
!
!     w(2*n)             WORKSPACE
!
!     anorm   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        This is the square root of the sum of squares
!                        of the elements of ABAR.
!                        If damp is small and if the columns of A
!                        have all been scaled to have length  1.0,
!                        anorm should increase to roughly sqrt(n).
!
!     arnorm  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        norm( ABAR(transpose)*RBAR ), the norm of
!                        the residual for the usual normal equations.
!                        This should be small in all cases. (arnorm
!                        will often be smaller than the true value
!                        computed from the output vector x.)
!
!
!     Subroutines and functions used
!     ------------------------------
!
!                normlz,mvprd1,mtprd1
!     BLAS       scopy,snrm2,sscal  (SEE LAWSON ET AL. BELOW)
!                (snrm2 is used only in normlz)
!     FORTRAN    ABS,SQRT
!
!
!     References
!     ----------
!
!     Paige, C.C. and saunders, M.A.  lsqr, an algorithm for sparse
!        linear equations and sparse least squares.
!        ACM transactions on mathematical software 8, 1 (March 1982).
!
!     Lawson, C.L., Hanson, R.J., kincaid, D.R. and krogh, F.T.
!        BASIC linear algebra subprograms for Fortran usage.
!        ACM transactions on mathematical software 5, 3 (sept 1979),
!        308-323 and 324-325.
!
!     ------------------------------------------------------------------
!
!     Local variables
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
!     Initialize.
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
!     Set up the first vectors for the bidiagonalization.
!     These satisfy   beta*u = B,   alfa*w = a(transpose)*u.
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
!     Main iteration loop.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     Perform the next step of the bidiagonalization to obtain the
!     next  beta, u, alfa, w.  these satisfy the relations
!                beta*u  =  a*w  -  alfa*u,
!                alfa*w  =  a(TRANSPOSE)*u  -  beta*w.
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
!     Use a plane rotation to eliminate the damping parameter.
!     This alters the diagonal (RHOBAR) of the lower-bidiagonal matrix.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1    = rhobar/rhbar1
sn1    = damp/rhbar1
psi    = sn1*phibar
phibar = cs1*phibar
!
!
!     Use a plane rotation to eliminate the subdiagonal element (beta)
!     of the lower-bidiagonal matrix, giving an upper-bidiagonal matrix.
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
!     Update x and w(n+1),...,w(2*n)
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
!     Use a plane rotation on the right to eliminate the
!     super-diagonal element (THETA) of the upper-bidiagonal matrix.
!     Then use the result to estimate norm(x).
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
!     Test for convergence.
!     First, estimate the norm and condition of the matrix abar,
!     and the norms of RBAR and ABAR(transpose)*RBAR.
!
anorm  = sqrt(bbnorm)
acond  = anorm*sqrt(ddnorm)
res1   = phibar**2
res2   = res2 + psi**2
rnorm  = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     Now use these norms to estimate certain other quantities,
!     some of which will be small near a solution.
!
test1  = rnorm/bnorm
test2  = arnorm/(anorm*rnorm)
test3  = one/acond
t1     = test1/(one + anorm*xnorm/bnorm)
rtol   = btol +  atol*anorm*xnorm/bnorm
!
!     The following tests guard against extremely small values of
!     atol, btol, or CTOL.  (The user may have set any or all of
!     the parameters atol, btol, conlim to zero.)
!     the effect is equivalent to the normal tests using
!     atol = relpr,  btol = relpr,  conlim = 1/relpr.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn .ge. itnlim) istop = 7
if (t3  .le. one   ) istop = 6
if (t2  .le. one   ) istop = 5
if (t1  .le. one   ) istop = 4
!
!     Allow for tolerances set by the user.
!
if (test3 .le. ctol) istop = 3
if (test2 .le. atol) istop = 2
if (test1 .le. rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     The convergence criteria are required to be met on  nconv
!     consecutive iterations, where  nconv  is set below.
!     Suggested value --   nconv = 1, 2  or  3.
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
!     normlz computes the Euclidean norm of x and returns the
!     value in beta. If x is nonzero, then x is rescaled so
!     THAT NORM(x) = 1.
!
!     Functions and subroutines
!
!     BLAS       snrm2,sscal
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
!     stlsq finds a solution x to the following problems ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*x = B
!
!     2. Linear least squares  --    solve  A*x = B
!                                    in the least-squares sense
!
!     3. Damped least squares  --    solve  (   A    )*x = ( B )
!                                           ( damp*i )     ( 0 )
!                                    in the least-squares sense
!
!     Where A is a matrix with m rows and n columns, B an m-vector,
!     and damp A scalar. (All quantities are real.) The matrix A is
!     a sparse matrix whose transpose is stored rowwise in the arrays
!     ta,ita,jta.
!
!     The RHS vector B is input via u, and is subsequently overwritten.
!
!
!     Note. stlsq uses an iterative method to approximate the solution.
!     The number of iterations required to reach a certain accuracy
!     depends strongly on the scaling of the problem. Poor scaling of
!     the rows or columns of A should therefore be avoided whenever
!     possible.
!
!     For example, in problem 1 the solution is unaltered by
!     row-scaling.  If a row of A is very small or large compared to
!     the other rows of A, the corresponding row of (A  B) should be
!     scaled up or down.
!
!     In problems 1 and 2, the solution x is easily recovered
!     following column scaling. In the absence of better information,
!     the nonzero columns of A should be scaled so that they all have
!     the same Euclidean norm (E.G.  1.0).
!
!     In problem 3, there is no freedom to RE-scale if damp is
!     nonzero. However, the value of damp should be assigned only
!     after attention has been paid to the scaling of A.
!
!     The parameter damp is intended to help regularize
!     ill-conditioned systems, by preventing the true solution from
!     being very large. Another aid to regularization is provided by
!     the parameter acond, which may be used to terminate iterations
!     before the computed solution becomes very large.
!
!
!     Notation
!     --------
!
!     The following quantities are used in discussing the subroutine
!     parameters...
!
!     abar   =  (   a    ),          bbar  =  ( b )
!               ( damp*i )                    ( 0 )
!
!     r      =  b  -  a*x,           rbar  =  bbar  -  abar*x
!
!     rnorm  =  sqrt( norm(r)**2  +  damp**2 * norm(x)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  The smallest floating point number for which
!               1 + RELPR .GT. 1.
!
!     stlsq  minimizes the function rnorm with respect to x.
!
!
!     Parameters
!     ----------
!
!     m       INPUT      THE NUMBER OF ROWS IN A.
!
!     n       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     ta,ita  INPUT      THE TRANSPOSE OF THE MATRIX A IS STORED
!      jta               ROWWISE IN SPARSE FORM.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (Damp  should be 0.0 for problems 1 and 2.)
!                        if the system  A*x = B  is incompatible, values
!                        of damp in the range 0 to sqrt(RELPR)*norm(A)
!                        will probably have a negligible effect.
!                        Larger values of damp will tend to decrease
!                        the norm of x and to reduce the number of
!                        iterations required by stlsq.
!
!                        The work per iteration and the storage needed
!                        by stlsq are the same for all values of damp.
!
!     u(m)    INPUT      THE RHS VECTOR B. BE AWARE THAT u IS
!                        over-written by stlsq.
!
!     x(n)    OUTPUT     RETURNS THE COMPUTED SOLUTION x.
!
!     atol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the matrix A. for example,
!                        if A is accurate to about 6 digits, set
!                        atol = 1.0e-6 .
!
!     btol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the RHS vector B. for example,
!                        if B is accurate to about 6 digits, set
!                        btol = 1.0e-6 .
!
!     conlim  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        condition number of the matrix abar.
!                        Iterations will be terminated if a computed
!                        estimate of cond(ABAR) exceeds conlim.
!                        This is intended to prevent certain small or
!                        zero singular values of A or ABAR from
!                        coming into effect and causing unwanted growth
!                        in the computed solution.
!
!                        conlim and damp may be used separately or
!                        together to regularize ill-conditioned systems.
!
!                        Normally, conlim should be in the range
!                        1000  TO  1/RELPR.
!                        Suggested value --
!                        conlim = 1/(100*RELPR)  for compatible systems,
!                        conlim = 1/(10*sqrt(RELPR))  for least squares.
!
!             Note. If the user is not concerned about the parameters
!             atol, btol, and conlim, any or all of them may be set
!             to zero. The effect will be the same as the values
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     itnlim  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        Suggested value --
!                        itnlim = n/2     for well conditioned systems,
!                        itnlim = 4*n     OTHERWISE.
!
!     istop   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       x = 0  Is the exact solution.
!                        No iterations were performed.
!
!                1       The equations  A*x = B  are probably
!                        compatible. Norm(A*x - B) is sufficiently
!                        small, given the values of atol and btol.
!
!                2       The system  A*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is sufficiently accurate,
!                        given the value of atol.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        conlim. The system  A*x = B  appears to be
!                        ill-conditioned.
!
!                4       The equations  A*x = B  are probably
!                        compatible. Norm(A*x - B) is as small as
!                        seems reasonable on this machine.
!
!                5       The system  A*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is as accurate as seems
!                        reasonable on this machine.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        not much point in doing further iterations,
!                        given the precision of this machine.
!
!                7       THE ITERATION LIMIT itnlim WAS REACHED.
!
!
!     itn     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     acond   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        number of ABAR.
!
!     rnorm   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        the function being minimized (see notation
!                        above). This will be small if  A*x = B  has
!                        A SOLUTION.
!
!     xnorm   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        solution vector x.
!
!     w(2*n)             WORKSPACE
!
!     anorm   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        This is the square root of the sum of squares
!                        of the elements of ABAR.
!                        If damp is small and if the columns of A
!                        have all been scaled to have length  1.0,
!                        anorm should increase to roughly sqrt(n).
!
!     arnorm  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        norm( ABAR(transpose)*RBAR ), the norm of
!                        the residual for the usual normal equations.
!                        This should be small in all cases. (arnorm
!                        will often be smaller than the true value
!                        computed from the output vector x.)
!
!
!     Subroutines and functions used
!     ------------------------------
!
!                normlz,mvprd1,mtprd1
!     BLAS       scopy,snrm2,sscal  (SEE LAWSON ET AL. BELOW)
!                (snrm2 is used only in normlz)
!     FORTRAN    ABS,SQRT
!
!
!     References
!     ----------
!
!     Paige, C.C. and saunders, M.A.  lsqr, an algorithm for sparse
!        linear equations and sparse least squares.
!        ACM transactions on mathematical software 8, 1 (March 1982).
!
!     Lawson, C.L., Hanson, R.J., kincaid, D.R. and krogh, F.T.
!        BASIC linear algebra subprograms for Fortran usage.
!        ACM transactions on mathematical software 5, 3 (sept 1979),
!        308-323 and 324-325.
!
!     ------------------------------------------------------------------
!
!     Local variables
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
!     Initialize.
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
!     Set up the first vectors for the bidiagonalization.
!     These satisfy   beta*u = B,   alfa*w = A(transpose)*u.
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
!     Main iteration loop.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     Perform the next step of the bidiagonalization to obtain the
!     next  beta, u, alfa, w.  these satisfy the relations
!                beta*u  =  A*w  -  alfa*u,
!                alfa*w  =  A(TRANSPOSE)*u  -  beta*w.
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
!     Use a plane rotation to eliminate the damping parameter.
!     This alters the diagonal (RHOBAR) of the lower-bidiagonal matrix.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1    = rhobar/rhbar1
sn1    = damp/rhbar1
psi    = sn1*phibar
phibar = cs1*phibar
!
!
!     Use a plane rotation to eliminate the subdiagonal element (beta)
!     of the lower-bidiagonal matrix, giving an upper-bidiagonal matrix.
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
!     Update x and w(n+1),...,w(2*n)
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
!     Use a plane rotation on the right to eliminate the
!     super-diagonal element (THETA) of the upper-bidiagonal matrix.
!     Then use the result to estimate norm(x).
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
!     Test for convergence.
!     First, estimate the norm and condition of the matrix abar,
!     and the norms of RBAR and ABAR(transpose)*RBAR.
!
anorm  = sqrt(bbnorm)
acond  = anorm*sqrt(ddnorm)
res1   = phibar**2
res2   = res2 + psi**2
rnorm  = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     Now use these norms to estimate certain other quantities,
!     some of which will be small near a solution.
!
test1  = rnorm/bnorm
test2  = arnorm/(anorm*rnorm)
test3  = one/acond
t1     = test1/(one + anorm*xnorm/bnorm)
rtol   = btol +  atol*anorm*xnorm/bnorm
!
!     The following tests guard against extremely small values of
!     atol, btol, or CTOL.  (The user may have set any or all of
!     the parameters atol, btol, conlim to zero.)
!     the effect is equivalent to the normal tests using
!     atol = relpr,  btol = relpr,  conlim = 1/relpr.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn .ge. itnlim) istop = 7
if (t3  .le. one   ) istop = 6
if (t2  .le. one   ) istop = 5
if (t1  .le. one   ) istop = 4
!
!     Allow for tolerances set by the user.
!
if (test3 .le. ctol) istop = 3
if (test2 .le. atol) istop = 2
if (test1 .le. rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     The convergence criteria are required to be met on  nconv
!     consecutive iterations, where  nconv  is set below.
!     Suggested value --   nconv = 1, 2  or  3.
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
!     blsq finds a solution x to the following problems ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  a*x = B
!
!     2. Linear least squares  --    solve  a*x = B
!                                    in the least-squares sense
!
!     3. Damped least squares  --    solve  (   a    )*x = ( B )
!                                           ( damp*i )     ( 0 )
!                                    in the least-squares sense
!
!     Where A is a matrix with m rows and n columns, B an m-vector,
!     and damp a scalar. (All quantities are real.) The matrix a is
!     a banded matrix stored in band form.
!
!     The RHS vector B is input via u, and is subsequently overwritten.
!
!
!     Note. blsq uses an iterative method to approximate the solution.
!     The number of iterations required to reach a certain accuracy
!     depends strongly on the scaling of the problem. Poor scaling of
!     the rows or columns of A should therefore be avoided whenever
!     possible.
!
!     For example, in problem 1 the solution is unaltered by
!     row-scaling.  If a row of A is very small or large compared to
!     the other rows of A, the corresponding row of (A  B) should be
!     scaled up or down.
!
!     In problems 1 and 2, the solution x is easily recovered
!     following column scaling. In the absence of better information,
!     the nonzero columns of A should be scaled so that they all have
!     the same Euclidean norm (E.G.  1.0).
!
!     In problem 3, there is no freedom to RE-scale if damp is
!     nonzero. However, the value of damp should be assigned only
!     after attention has been paid to the scaling of A.
!
!     The parameter damp is intended to help regularize
!     ill-conditioned systems, by preventing the true solution from
!     being very large. Another aid to regularization is provided by
!     the parameter acond, which may be used to terminate iterations
!     before the computed solution becomes very large.
!
!
!     Notation
!     --------
!
!     The following quantities are used in discussing the subroutine
!     parameters...
!
!     abar   =  (   a    ),          bbar  =  ( b )
!               ( damp*i )                    ( 0 )
!
!     r      =  b  -  a*x,           rbar  =  bbar  -  abar*x
!
!     rnorm  =  sqrt( norm(r)**2  +  damp**2 * norm(x)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  The smallest floating point number for which
!               1 + RELPR .GT. 1.
!
!     blsq   MINIMIZES THE FUNCTION rnorm WITH RESPECT TO x.
!
!
!     Parameters
!     ----------
!
!     m       INPUT      THE NUMBER OF ROWS IN A.
!
!     n       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     a       INPUT      THE MATRIX a STORED IN BAND FORM.
!
!     ka      INPUT      THE NUMBER OF ROWS IN THE DIMENSION STATEMENT
!                        for A in the calling program.
!
!     ml      INPUT      THE LOWER BAND WIDTH OF A.
!
!     mu      INPUT      THE UPPER BAND WIDTH OF A.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (Damp  should be 0.0 for problems 1 and 2.)
!                        if the system  a*x = B  is incompatible, values
!                        of damp in the range 0 to sqrt(RELPR)*norm(a)
!                        will probably have a negligible effect.
!                        Larger values of damp will tend to decrease
!                        the norm of x and to reduce the number of
!                        iterations required by blsq.
!
!                        The work per iteration and the storage needed
!                        by blsq are the same for all values of damp.
!
!     u(m)    INPUT      THE RHS VECTOR B. BE AWARE THAT u IS
!                        over-written by blsq.
!
!     x(n)    OUTPUT     RETURNS THE COMPUTED SOLUTION x.
!
!     atol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the matrix a. for example,
!                        if A is accurate to about 6 digits, set
!                        atol = 1.0e-6 .
!
!     btol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the RHS vector B. for example,
!                        if B is accurate to about 6 digits, set
!                        btol = 1.0e-6 .
!
!     conlim  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        condition number of the matrix abar.
!                        Iterations will be terminated if a computed
!                        estimate of cond(ABAR) exceeds conlim.
!                        This is intended to prevent certain small or
!                        zero singular values of A or ABAR from
!                        coming into effect and causing unwanted growth
!                        in the computed solution.
!
!                        conlim and damp may be used separately or
!                        together to regularize ill-conditioned systems.
!
!                        Normally, conlim should be in the range
!                        1000  TO  1/RELPR.
!                        Suggested value --
!                        conlim = 1/(100*RELPR)  for compatible systems,
!                        conlim = 1/(10*sqrt(RELPR))  for least squares.
!
!             Note. If the user is not concerned about the parameters
!             atol, btol, and conlim, any or all of them may be set
!             to zero. The effect will be the same as the values
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     itnlim  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        Suggested value --
!                        itnlim = n/2     for well conditioned systems,
!                        itnlim = 4*n     OTHERWISE.
!
!     istop   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       x = 0  Is the exact solution.
!                        No iterations were performed.
!
!                1       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is sufficiently
!                        small, given the values of atol and btol.
!
!                2       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is sufficiently accurate,
!                        given the value of atol.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        conlim. The system  a*x = B  appears to be
!                        ill-conditioned.
!
!                4       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is as small as
!                        seems reasonable on this machine.
!
!                5       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is as accurate as seems
!                        reasonable on this machine.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        not much point in doing further iterations,
!                        given the precision of this machine.
!
!                7       THE ITERATION LIMIT itnlim WAS REACHED.
!
!
!     itn     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     acond   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        number of ABAR.
!
!     rnorm   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        the function being minimized (see notation
!                        above). This will be small if  a*x = B  has
!                        A SOLUTION.
!
!     xnorm   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        solution vector x.
!
!     w(2*n)             WORKSPACE
!
!     anorm   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        This is the square root of the sum of squares
!                        of the elements of ABAR.
!                        If damp is small and if the columns of A
!                        have all been scaled to have length  1.0,
!                        anorm should increase to roughly sqrt(n).
!
!     arnorm  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        norm( ABAR(transpose)*RBAR ), the norm of
!                        the residual for the usual normal equations.
!                        This should be small in all cases. (arnorm
!                        will often be smaller than the true value
!                        computed from the output vector x.)
!
!
!     Subroutines and functions used
!     ------------------------------
!
!                normlz,bvprd1,btprd1
!     BLAS       scopy,snrm2,sscal  (SEE LAWSON ET AL. BELOW)
!                (snrm2 is used only in normlz)
!     FORTRAN    ABS,SQRT
!
!
!     References
!     ----------
!
!     Paige, C.C. and saunders, M.A.  lsqr, an algorithm for sparse
!        linear equations and sparse least squares.
!        ACM transactions on mathematical software 8, 1 (March 1982).
!
!     Lawson, C.L., Hanson, R.J., kincaid, D.R. and krogh, F.T.
!        BASIC linear algebra subprograms for Fortran usage.
!        ACM transactions on mathematical software 5, 3 (sept 1979),
!        308-323 and 324-325.
!
!     ------------------------------------------------------------------
!
!     Local variables
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
!     Initialize.
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
!     Set up the first vectors for the bidiagonalization.
!     These satisfy   beta*u = B,   alfa*w = a(transpose)*u.
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
!     Main iteration loop.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     Perform the next step of the bidiagonalization to obtain the
!     next  beta, u, alfa, w.  these satisfy the relations
!                beta*u  =  a*w  -  alfa*u,
!                alfa*w  =  a(TRANSPOSE)*u  -  beta*w.
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
!     Use a plane rotation to eliminate the damping parameter.
!     This alters the diagonal (RHOBAR) of the lower-bidiagonal matrix.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1    = rhobar/rhbar1
sn1    = damp/rhbar1
psi    = sn1*phibar
phibar = cs1*phibar
!
!
!     Use a plane rotation to eliminate the subdiagonal element (beta)
!     of the lower-bidiagonal matrix, giving an upper-bidiagonal matrix.
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
!     Update x and w(n+1),...,w(2*n)
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
!     Use a plane rotation on the right to eliminate the
!     super-diagonal element (THETA) of the upper-bidiagonal matrix.
!     Then use the result to estimate norm(x).
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
!     Test for convergence.
!     First, estimate the norm and condition of the matrix abar,
!     and the norms of RBAR and ABAR(transpose)*RBAR.
!
anorm  = sqrt(bbnorm)
acond  = anorm*sqrt(ddnorm)
res1   = phibar**2
res2   = res2 + psi**2
rnorm  = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     Now use these norms to estimate certain other quantities,
!     some of which will be small near a solution.
!
test1  = rnorm/bnorm
test2  = arnorm/(anorm*rnorm)
test3  = one/acond
t1     = test1/(one + anorm*xnorm/bnorm)
rtol   = btol +  atol*anorm*xnorm/bnorm
!
!     The following tests guard against extremely small values of
!     atol, btol, or CTOL.  (The user may have set any or all of
!     the parameters atol, btol, conlim to zero.)
!     the effect is equivalent to the normal tests using
!     atol = relpr,  btol = relpr,  conlim = 1/relpr.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn .ge. itnlim) istop = 7
if (t3  .le. one   ) istop = 6
if (t2  .le. one   ) istop = 5
if (t1  .le. one   ) istop = 4
!
!     Allow for tolerances set by the user.
!
if (test3 .le. ctol) istop = 3
if (test2 .le. atol) istop = 2
if (test1 .le. rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     The convergence criteria are required to be met on  nconv
!     consecutive iterations, where  nconv  is set below.
!     Suggested value --   nconv = 1, 2  or  3.
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
!     Golden section minimization of a function f(T)
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
!     c1 = 1 - c2
!     c2 = 0.5*(-1 + sqrt(5))
!     -------------------
data eps0/5.e-3/
data c1/.3819660112501052/
data c2/.6180339887498948/
!     -------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
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
!        Location of the region of a local minimum
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
!              Check if 0 is a local minimum
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
!             Check if a0 is a local minimum
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
!             Check if b0 is a local minimum
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
!             Refinement of the local minimum
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
!        Checking the accuracy of the local minimum
!
220 if (e .le. amax1(rtol*abs(a),atol)) go to 240
if (abs(fv - fu) .gt. ftol*amax1(abs(fu),abs(fv))) go to 200
if (ind .eq. 1) go to 241
ind = 1
go to 201
!
!                    Report the results
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
!                 Interface to minimization package
!-----------------------------------------------------------------------
!
!     Input ...
!
!       FCN        NAME OF ROUTINE TO EVALUATE MINIMIZATION FUNCTION.
!                  Must be declared external in calling routine.
!       n          DIMENSION OF PROBLEM
!       rerr       RELATIVE ACCURACY OF SUBROUTINE fcn.
!
!     Input/output ...
!
!       ITER       ON INPUT ITER IS THE MAXIMUM NUMBER OF ITERATIONS
!                  that are permitted. On output iter is the number
!                  of iterations that were actually performed.
!       xpls(n)    LOCAL MINIMUM
!
!     Output ...
!
!       fpls       FUNCTION VALUE AT LOCAL MINIMUM xpls
!       ierr       TERMINATION CODE
!
!     Workspace ...
!
!       wrk(n,n+8)
!
!-----------------------------------------------------------------------
real, intent(inout) :: xpls(n), wrk(n,*)
external fcn
!
!     equivalence wrk(n,1) = x(n)
!                 wrk(n,2) = typsiz(n)
!                 wrk(n,3) = gpls(n)
!                 wrk(n,4) = g(n)
!                 wrk(n,5) = p(n)
!                 wrk(n,6) = wrk0(n)
!                 wrk(n,7) = wrk1(n)
!                 wrk(n,8) = wrk2(n)
!                 wrk(n,9) = a(n,n)
!
!
!     Set tolerances
!
eps = amax1(spmpar(1),abs(rerr))
gradtl = eps**0.4
stepmx = 0.0
steptl = eps
if (eps .le. 1.e-10) steptl = 10.0*eps
if (eps .lt. 1.e-13) steptl = 1.e2*eps
!
!     Initialization
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
!             Driver for non-linear optimization problem
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr         ROW DIMENSION OF MATRIX
!       n          DIMENSION OF PROBLEM
!       FCN        SUBROUTINE.  FCN EVALUATES THE FUNCTION TO BE
!                  optimized. FCN must be declared external in the
!                  calling program. The routine HAS the format
!                         call fcn (n, x, fval)
!                  where x is a point and FVAL is the value of the
!                  function at the point.
!       rerr       RELATIVE ACCURACY OF SUBROUTINE fcn. IT IS
!                  assumed that rerr is nonnegative. If rerr = 0
!                  then FCN is accurate to machine precision.
!       itnlim     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       gradtl     TOLERANCE AT WHICH THE GRADIENT IS CONSIDERED
!                  close enough to zero to terminate algorithm.
!                  (Used only in the subroutine opstp.)
!       steptl     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                  considered close enough to terminate algorithm
!
!     Input/output ...
!
!       mo         NUMBER OF RESCALINGS OF THE VARIABLES.
!       x(n)       ESTIMATE OF A LOCAL MINIMUM OF FCN
!       typsiz(n)  typical size for each component of x
!       fscale     ESTIMATE OF SCALE OF MINIMUM VALUE OF FCN.
!                  (Used only in the subroutine opstp.)
!       stepmx     MAXIMUM ALLOWABLE STEP SIZE
!
!     Output ...
!
!       itncnt     NUMBER OF ITERATIONS COMPLETED
!       XPLS(n)    ESTIMATE OF A LOCAL MINIMUM OF FCN
!       fpls       FUNCTION VALUE AT XPLS
!       gpls(n)    GRADIENT AT XPLS
!       ierr       TERMINATION CODE
!
!     Work spaces ...
!
!       a(n,n)     CHOLESKY DECOMPOSITION OF HESSIAN
!       g(n)       GRADIENT AT THE CURRENT ITERATE
!       p(n)       STEP
!       wrk0(n)    WORKSPACE
!       wrk1(n)    WORKSPACE
!       wrk2(n)    WORKSPACE
!
!-----------------------------------------------------------------------
!     Internal parameters ...
!
!       rnf        NOISE IN THE SUBROUTINE fcn
!       f          FUNCTION VALUE  FCN(x)
!       fstack(ns) stack of previous function values
!       ns         LENGTH OF THE ARRAY fstack
!       sptr       POINTER TO AN ELEMENT IN fstack
!-----------------------------------------------------------------------
integer :: sptr
logical :: mxtake, noupdt
external fcn
!
!     Initialization
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
!     Evaluate FCN(x)
!
call fcn(n,x,f)
!
!     Evaluate finite difference gradient
!
call fstofd (n, x, fcn, f, g, typsiz, sqrnf)
!
call opstp (n,x,f,g,wrk1,itncnt,icscmx,ierr,gradtl,steptl, &
&typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr .eq. 0) go to 10
if (mo .ne. 0) go to 210
!
!        Apply the fixed step coordinate descent procedure
!        for one step and check if the gradient is nonzero
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
!     The hessian will be obtained by secant updates.
!     Set A to the initial hessian.
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
!     Iteration
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
!     Solve  a*p = -g  for Newton step
!
105 do i = 1,n
  wrk1(i) = -g(i)
end do
call lltslv(nr,n,a,p,wrk1)
!
!     Take a step, arriving at the point XPLS
!
call lnsrch(n,x,f,g,p,xpls,fpls,fcn,mxtake,iretcd, &
&stepmx,steptl,typsiz)
!
!     If a satisfactory step could not be found and forward difference
!     gradient was used, retry using a central difference gradient.
!
if (iretcd .ne. 1 .or. iagflg .ne. 0) go to 120
!
!        Set iagflg for central differences
!
   iagflg = -1
   cbrnf = rnf**(1.0/3.0)
   call fstocd (n, x, fcn, typsiz, cbrnf, g)
   go to 105
!
!     Calculate gradient at XPLS
!
120 if (iagflg .eq. 0) go to 130
   call fstocd (n, xpls, fcn, typsiz, cbrnf, gpls)
   go to 140
130 call fstofd (n, xpls, fcn, fpls, gpls, typsiz, sqrnf)
!
!     Check whether the stopping criteria satisfied
!
140 call opstp (n,xpls,fpls,gpls,x,itncnt,icscmx,ierr,gradtl,steptl, &
&typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr .ne. 0) go to 200
!
!     Evaluate hessian at XPLS
!
call secfac(nr,n,x,g,a,xpls,gpls,itncnt,sqrnf, &
&noupdt,wrk0,wrk1,wrk2)
!
!     Update f, x, and g
!
f = fpls
do i = 1,n
  x(i) = xpls(i)
  g(i) = gpls(i)
end do
go to 100
!
!     Termination
!     -----------
!     Reset XPLS,fpls,gpls  if previous iterate solution
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
!                  Check input for reasonableness
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       x(n)       ESTIMATE OF MINIMUM OF FCN
!       gradtl     TOLERANCE AT WHICH GRADIENT CONSIDERED CLOSE
!                  enough to zero to terminate algorithm
!       itnlim     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       rerr       RELATIVE ACCURACY OF SUBROUTINE fcn
!
!     Input/output ...
!
!       typsiz(n)  scaling vector for x
!       fscale     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION fcn
!       stepmx     MAXIMUM STEP SIZE
!
!     Output ...
!
!       ierr       ERROR INDICATOR
!
!-----------------------------------------------------------------------
real, intent(in) :: x(n)
real, intent(inout) :: typsiz(n)
!
!     Check that parameters only take on acceptable values.
!     If not, set them to default values.
!
ierr = 0
!
!     Check dimension of problem
!
if (n .le. 0) go to 805
if (n .eq. 1) go to 810
!
!     Compute scale matrix
!
do i = 1,n
  typsiz(i) = abs(typsiz(i))
  if (typsiz(i) .eq. 0.0) typsiz(i) = 1.0
end do
!
!     Check maximum step size
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
!     Check function SCALE
!
fscale = abs(fscale)
if (fscale .eq. 0.0) fscale = 1.0
!
!     Check gradient tolerance
!
if (gradtl .lt. 0.0) go to 815
!
!     Check iteration limit
!
if (itnlim .le. 0) go to 820
!
!     Check the accuracy of FCN
!
if (rerr .lt. 0.0 .or. rerr .gt. 1.e-4) go to 825
return
!
!     Error exits
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
!            Unconstrained minimization stopping criteria
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       xpls(n)    NEW ITERATE x(K)
!       fpls       FUNCTION VALUE AT NEW ITERATE, F(xpls)
!       gpls(n)    GRADIENT AT NEW ITERATE, G(xpls), OR APPROXIMATE
!       x(n)       OLD ITERATE x(K-1)
!       itncnt     CURRENT ITERATION K
!       icscmx     number consecutive steps .GE. STEPMX
!       gradtl     TOLERANCE AT WHICH RELATIVE GRADIENT CONSIDERED CLOSE
!                  enough to zero to terminate algorithm
!       steptl     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                  considered close enough to terminate algorithm
!       typsiz(n)  scaling vector for x
!       itnlim     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       iretcd     CODE WHICH WAS SET WHEN THE POINT xpls WAS OBTAINED
!       mxtake     BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
!       ns         LENGTH OF THE ARRAY fstack
!
!     Input/output ...
!
!       fscale     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION
!       fstack(ns) stack of previous function values
!       sptr       POINTER TO AN ELEMENT IN fstack
!
!     Output ...
!
!       icscmx     number consecutive steps .GE. STEPMX
!                  (retain value between successive calls)
!       ierr       TERMINATION CODE
!
!-----------------------------------------------------------------------
real, intent(in) :: xpls(n), gpls(n), x(n), typsiz(n)
real, intent(inout) :: fstack(ns)
integer, intent(inout) :: sptr
logical, intent(in) :: mxtake
!
ierr = 0
!
!     Last global step failed to locate a point lower than x
!
if (iretcd .ne. 1) go to 10
   ierr = 3
   return
10 continue
!
!     Find direction in which relative gradient maximum.
!     Check whether within tolerance.
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
!     Find direction in which relative stepsize maximum
!     check whether within tolerance.
!
rsx = 0.0
do i = 1,n
   relstp = abs(xpls(i) - x(i))/amax1(abs(xpls(i)),typsiz(i))
   rsx = amax1(rsx,relstp)
end do
jerr = 2
if (rsx .le. steptl) go to 100
!
!     Check if fpls is sufficiently less than the ns-TH
!     previous value of FCN.
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
!     Check iteration limit
!
60 jerr = 4
if (itncnt .ge. itnlim) go to 100
!
!     Check number of consecutive steps of size STEPMX
!
if (mxtake) go to 70
   icscmx = 0
   return
70 icscmx = icscmx + 1
if (icscmx .ge. 20) ierr = 5
return
!
!     Terminate
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
!     Fixed step coordinate descent procedure / one iteration
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
!     Rescale the variables
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
!        Solution of AX = b where A has the form L(L-TRANSPOSE)
!           but only the lower triangular part L is stored.
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr       ROW DIMENSION OF MATRIX
!       n        ORDER OF THE MATRIX
!       a(n,n)   MATRIX OF FORM L(L-TRANSPOSE). A IS NOT
!                modified by the routine.
!       b(n)     RIGHT-HAND SIDE VECTOR
!
!     Output ...
!
!       x(n)     SOLUTION VECTOR
!
!-----------------------------------------------------------------------
!     Note.  b and x may share the same storage area.
!-----------------------------------------------------------------------
real, intent(in) :: a(nr,n)
real, intent(inout) :: x(n)
real, intent(in) :: b(n)
!
!                  Forward solve, result in x
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
!                   Back solve, result in x
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
!     Find forward difference approximation g to the first derivative
!     (gradient) of the function defined by FCN at the point x.
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       x(n)       POINT AT WHICH THE GRADIENT IS TO BE APPROXIMATED
!       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       FX         VALUE OF FCN AT THE POINT x
!       typsiz(n)  scaling vector for x
!       r          STEPSIZE FACTOR
!
!     Output ...
!
!       g(n)       FINITE DIFFERENCE APPROXIMATION TO THE GRADIENT
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
!     Find central difference approximation g to the first derivative
!     (gradient) of the function defined by FCN at the point x.
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       x(n)       POINT AT WHICH GRADIENT IS TO BE APPROXIMATED
!       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       typsiz(n)  scaling vector for x
!       r          STEPSIZE FACTOR
!
!     Output ...
!
!       g(n)       CENTRAL DIFFERENCE APPROXIMATION TO GRADIENT
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
real, intent(in) :: typsiz(n)
real, intent(inout) :: g(n)
external fcn
!
!     Find i-TH  stepsize, evaluate two neighbors in direction of
!     i-TH unit vector, and evaluate i-TH  component of gradient.
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
!             Find a next Newton iterate by line search
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n         DIMENSION OF PROBLEM
!       x(n)      OLD ITERATE x(K-1)
!       f         FUNCTION VALUE AT OLD ITERATE, f(x)
!       g(n)      GRADIENT AT OLD ITERATE, g(x)
!       p(n)      NON-ZERO NEWTON STEP
!       FCN       NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       stepmx    MAXIMUM ALLOWABLE STEP SIZE
!       steptl    RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                 considered close enough to terminate algorithm
!       typsiz(n) scaling vector for x
!
!     Output ...
!
!       xpls(n)   NEW ITERATE x(K)
!       fpls      FUNCTION VALUE AT NEW ITERATE, f(xpls)
!       iretcd    RETURN CODE
!       mxtake    BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
!
!-----------------------------------------------------------------------
!     Internal variables ...
!
!       sln      NEWTON LENGTH
!       rln      RELATIVE LENGTH OF NEWTON STEP
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
!     Newton step longer than maximum allowed
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
!     Loop.  Check if the new iterate is satisfactory.
!
100 do i = 1,n
  xpls(i) = x(i) + lambda*p(i)
end do
call fcn(n,xpls,fpls)
if (fpls .le. f + slp*1.e-4*lambda) go to 200
!
!     Solution not (yet) found
!
  if (lambda .lt. rmnlmb) go to 210
!
!     Calculate new lambda
!
  if (lambda .ne. 1.0) go to 120
!
!     First backtrack. Quadratic fit
!
      tlmbda = amin1(-slp/(2.0*(fpls - f - slp)), 0.9)
      go to 170
!
!     All subsequent backtracks. Cubic fit
!
120 t1 = (fpls - f - lambda*slp)/(lambda*lambda)
      t2 = (pfpls - f - plmbda*slp)/(plmbda*plmbda)
      t3 = 1.0/(lambda - plmbda)
      a = t3*(t1 - t2)
      b = t3*(t2*lambda - t1*plmbda)
      w = 10.0*abs(t1*t3)
      if ((abs(a) + w) .ne. w) go to 130
!
!     The cubic fit degenerates to a quadratic fit
!
         tlmbda = -slp/(2.0*b)
         go to 160
!
!     The cubic is nondegenerate
!
130 disc = b*b - 3.0*a*slp
      if (disc .le. b*b) go to 140
!
!     Only one positive critical point, must be minimum
!
         tlmbda = (-b + sign(1.0,a)*sqrt(disc))/(3.0*a)
         go to 160
!
!     Both critical points positive, first is minimum
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
!     A suitable value for xpls has been obtained
!
200 iretcd = 0
if (lambda .eq. 1.0 .and. sln .gt. 0.99*stepmx) mxtake =.true.
return
!
!     No satisfactory xpls found sufficiently distinct from x
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
!           Update hessian by the BFGS factored method
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr        ROW DIMENSION OF MATRIX
!       n         ORDER OF THE MATRIX
!       x(n)      OLD ITERATE x(K-1)
!       g(n)      GRADIENT AT THE OLD ITERATE
!       xpls(n)   NEW ITERATE x(K)
!       gpls(n)   GRADIENT AT THE NEW ITERATE
!       itncnt    ITERATION COUNT
!       tol       RELATIVE TOLERANCE TO BE USED FOR NOISE
!
!     Input/output ...
!
!       a(n,n)    ON ENTRY, CHOLESKY DECOMPOSITION OF HESSIAN IN
!                    the lower part and diagonal.
!                 On exit,  updated Cholesky decomposition of hessian
!                    in the lower triangular part and diagonal.
!       noupdt    BOOLEAN. NO UPDATE YET.
!
!     Work spaces ...  s(n), y(n), w(n)
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
!     SET s = TRANSPOSE(L)*s
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
!     Set alp = sqrt(den1/den2)
!
alp = sqrt(den1/den2)
if (.not.noupdt) go to 40
!
!        On the initial update set L = alp*L. then s must be
!        reset to alp*s. after this is done then den2 = den1
!        and alp has the value 1.
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
!     SET w = L*s
!
40 do i = 1,n
   sum = 0.0
   do j = 1,i
      sum = sum + a(i,j)*s(j)
   end do
   w(i) = sum
end do
!
!     If abs(y(i) - w(i)) is less than the estimated noise in y(i)
!     for each i, then the update is skipped.
!
do i = 1,n
if (abs(y(i) - w(i)) .ge. tol*amax1(abs(g(i)),abs(gpls(i)))) &
&go to 70
end do
return
!
!     w = y - alp*l*s
!
70 do i = 1,n
   w(i) = y(i) - alp*w(i)
end do
!
!     s = s/sqrt(den1*den2)
!
alp = alp/den1
do i = 1,n
   s(i) = alp*s(i)
end do
!
!     Copy L into upper triangular part.  Zero L.
!
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(j,i) = a(i,j)
      a(i,j) = 0.0
   end do
end do
!
!     Find Q and R such that  Q*R = (L+) + s*(w+)
!
call qrupdt (nr, n, a, s, w)
!
!     Upper triangular part and diagonal of a now contain updated
!     Cholesky decomposition of hessian.  Copy back to lower
!     triangular part.
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
!     Find an orthogonal matrix (Q*) and an upper triangular
!          MATRIX (r*) SUCH THAT (Q*)(r*) = r + u(v+)
!-----------------------------------------------------------------------
!
!     Parameters ...
!
!       nr      ROW DIMENSION OF THE MATRIX
!       n       ORDER OF THE MATRIX
!       a(n,n)  on input,  contains r
!               on output, contains (r*)
!       u(n)    VECTOR
!       v(n)    VECTOR
!
!-----------------------------------------------------------------------
real, intent(inout) :: a(nr,n), u(n)
real, intent(in) :: v(n)
!
!                Determine last non-zero in u
!
k = n
10 if (u(k) .ne. 0.0 .or. k .eq. 1) go to 20
   k = k - 1
   go to 10
!
!               k-1 Jacobi rotations transform
!             r + u(v+)  TO  (r*) + (u(1)*E1)(v+)
!                 which is upper Hessenberg
!
20 km1 = k - 1
if (k .le. 1) go to 40
do ii = 1,km1
   i = k - ii
   call jrot (nr,n,a,i,u(i),-u(i+1),r)
   u(i) = r
end do
!
! SET r = r + (u(1)*E1)(v+)
!
40 do j = 1,n
   a(1,j) = a(1,j) + u(1)*v(j)
end do
if (k .le. 1) return
!
!       k-1 Jacobi rotations transform upper Hessenberg r
!                   to upper triangular r*
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
!         Pre-multiplication of an upper Hessenberg matrix h
!               by the Jacobian rotation j(i,i+1,a,b)
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr      ROW DIMENSION OF THE MATRIX
!       n       ORDER OF THE MATRIX
!       h(n,n)  upper hessenber matrix
!       i       INDEX OF ROW
!       A,b     SCALARS
!
!     Output ...
!
!       h(n,n)  the modified Hessenberg matrix
!       r       r = sqrt(a*a + b*b)
!
!-----------------------------------------------------------------------
real, intent(inout) :: h(nr,n)
!
!                COMPUTE c = a/r  AND s = b/r
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
!            Apply the rotation when A is nonzero
!
20 do j = i,n
   t = h(i,j)
   z = h(i+1,j)
   h(i,j) = c*t - s*z
   h(i+1,j) = s*t + c*z
end do
return
!
!                     Case when a = 0
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
!     SUBROUTINE lmdiff
!
!     The purpose of lmdiff is to minimize the sum of the squares of
!     m nonlinear functions in n variables by a modification of the
!     Levenberg-Marquardt algorithm. This is done by using the more
!     general least-squares solver lmdif. The user must provide A
!     subroutine which calculates the functions. The Jacobian is
!     then calculated by a forward-difference approximation.
!
!     The subroutine statement is
!
!       subroutine lmdiff(fcn,m,n,x,fvec,epsfcn,tol,info,iwa,wa,lwa)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(m,n,x,fvec,iflag)
!         integer m,n,iflag
!         real x(n),fvec(m)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of IFLAG should not be changed by FCN unless
!         the user wants to terminate execution of lmdiff.
!         In this case set IFLAG to a negative integer.
!
!       m is a positive integer input variable SET to the number
!         of functions.
!
!       n is a positive integer input variable SET to the number
!         of variables. n must not exceed m.
!
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!
!       fvec is an output array of length m which contains
!         the functions evaluated at the output x.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       tol is a nonnegative input variable. Termination occurs
!         when the algorithm estimates either that the relative
!         error in the sum of squares is at most tol or that
!         the relative error between x and the solution is at
!         MOST tol.
!
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of IFLAG. See description of FCN. Otherwise,
!         info is set as follows.
!
!         info = 0  Improper input parameters.
!
!         info = 1  Algorithm estimates that the relative error
!                   in the sum of squares is at most tol.
!
!         info = 2  Algorithm estimates that the relative error
!                   between x and the solution is at most tol.
!
!         info = 3  Conditions for info = 1 And info = 2 Both hold.
!
!         info = 4  fvec is orthogonal to the columns of the
!                   Jacobian to machine precision.
!
!         info = 5  Number of calls to FCN has reached or
!                   EXCEEDED 200*(n+1).
!
!         info = 6  tol is too small. No further reduction in
!                   the sum of squares is possible.
!
!         info = 7  tol is too small. No further improvement in
!                   the approximate solution x is possible.
!
!       iwa is an integer work array of length n.
!
!       wa is a work array of length lwa.
!
!       lwa is a positive integer input variable NOT less than
!         m*n+5*n+m.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... lmdif
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge J. more
!
!     **********
integer :: maxfev, mode, mp5n, nfev, nprint
real :: factor, ftol, gtol, xtol
data factor /1.0e2/
info = 0
!
!     Check the input parameters for errors.
!
if (n .le. 0 .or. m .lt. n .or. epsfcn .lt. 0.0 &
&.or. tol .lt. 0.0 .or. lwa .lt. m*n + 5*n + m) go to 10
!
!     CALL lmdif.
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
!     SUBROUTINE lmdif
!
!     The purpose of lmdif is to minimize the sum of the squares of
!     m nonlinear functions in n variables by a modification of
!     the Levenberg-Marquardt algorithm. The user must provide A
!     subroutine which calculates the functions. The Jacobian is
!     then calculated by a forward-difference approximation.
!
!     The subroutine statement is
!
!       subroutine lmdif(fcn,m,n,x,fvec,ftol,xtol,gtol,maxfev,epsfcn,
!                        diag,mode,factor,nprint,info,nfev,fjac,
!                        ldfjac,ipvt,QTF,WA1,WA2,WA3,WA4)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(m,n,x,fvec,iflag)
!         integer m,n,iflag
!         real x(n),fvec(m)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of lmdif.
!         In this case set iflag to a negative integer.
!
!       m is a positive integer input variable SET to the number
!         of functions.
!
!       n is a positive integer input variable SET to the number
!         of variables. n must not exceed m.
!
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!
!       fvec is an output array of length m which contains
!         the functions evaluated at the output x.
!
!       ftol is a nonnegative input variable. Termination
!         occurs when both the actual and predicted relative
!         reductions in the sum of squares are at most ftol.
!         Therefore, ftol measures the relative error desired
!         in the sum of squares.
!
!       xtol is a nonnegative input variable. Termination
!         occurs when the relative error between two consecutive
!         iterates is at most xtol. Therefore, xtol measures the
!         relative error desired in the approximate solution.
!
!       gtol is a nonnegative input variable. Termination
!         occurs when the cosine of the angle between fvec and
!         any column of the Jacobian is at most gtol in absolute
!         value. Therefore, gtol measures the orthogonality
!         desired between the function vector and the columns
!         of the Jacobian.
!
!       maxfev is a positive integer input variable. Termination
!         occurs when the number of calls to FCN is at least
!         maxfev by the end of an iteration.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       Diag is an array of length n. if mode = 1 (see
!         below), diag is internally set. If mode = 2, diag
!         must contain positive entries that serve as
!         multiplicative scale factors for the variables.
!
!       Mode is an integer input variable. If mode = 1, the
!         variables will be scaled internally. If mode = 2,
!         the scaling is specified by the input diag. Other
!         values of mode are equivalent to mode = 1.
!
!       Factor is a positive input variable used in determining the
!         initial step bound. This bound is set to the product of
!         factor and the Euclidean norm of diag*x if nonzero, or else
!         to factor itself. In most cases factor should lie in the
!         interval (.1,100.). 100. Is a generally recommended value.
!
!       nprint is an integer input variable that enables controlled
!         printing of iterates if it is positive. In this case,
!         FCN is called with iflag = 0 At the beginning of the first
!         iteration and every nprint iterations thereafter and
!         immediately prior to return, with x and fvec available
!         for printing. If nprint is not positive, no special calls
!         of FCN with iflag = 0 Are made.
!
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of iflag. See description of FCN. Otherwise,
!         info is set as follows.
!
!         info = 0  Improper input parameters.
!
!         info = 1  Both actual and predicted relative reductions
!                   in the sum of squares are at most ftol.
!
!         info = 2  Relative error between two consecutive iterates
!                   is at most xtol.
!
!         info = 3  Conditions for info = 1 And info = 2 Both hold.
!
!         info = 4  The cosine of the angle between fvec and any
!                   column of the Jacobian is at most gtol in
!                   absolute value.
!
!         info = 5  Number of calls to FCN has reached or
!                   EXCEEDED maxfev.
!
!         info = 6  ftol is too small. No further reduction in
!                   the sum of squares is possible.
!
!         info = 7  xtol is too small. No further improvement in
!                   the approximate solution x is possible.
!
!         info = 8  gtol is too small. fvec is orthogonal to the
!                   columns of the Jacobian to machine precision.
!
!       nfev is an integer output variable SET to the number of
!         calls to FCN.
!
!       fjac is an output m by n array. The upper n by n submatrix
!         of fjac contains an upper triangular matrix R with
!         diagonal elements of nonincreasing magnitude such that
!
!                T     T           T
!               P *(JAC *JAC)*P = R *R,
!
!         Where P is a permutation matrix and JAC is the final
!         calculated Jacobian. Column j of P is column ipvt(j)
!         (see below) of the identity matrix. The lower trapezoidal
!         part of fjac contains information generated during
!         the computation of R.
!
!       ldfjac is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array fjac.
!
!       ipvt is an integer output array of length n. ipvt
!         defines a permutation matrix P such that JAC*P = Q*R,
!         where JAC is the final calculated Jacobian, Q is
!         orthogonal (not stored), and R is upper triangular
!         with diagonal elements of nonincreasing magnitude.
!         Column j of P is column ipvt(j) of the identity matrix.
!
!       QTF is an output array of length n which contains
!         the first n elements of the vector (Q transpose)*fvec.
!
!       WA1, WA2, and WA3 are work arrays of length n.
!
!       WA4 is a work array of length m.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... spmpar,enorm,fdjac2,lmpar,qrfac
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,sqrt,mod
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
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
!     Eps is the machine precision.
!
eps = spmpar(1)
!
info = 0
iflag = 0
nfev = 0
!
!     Check the input parameters for errors.
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
!     Evaluate the function at the starting point
!     and calculate its norm.
!
iflag = 1
call fcn(m,n,x,fvec,iflag)
nfev = 1
if (iflag .lt. 0) go to 300
fnorm = enorm(m,fvec)
!
!     Initialize Levenberg-Marquardt parameter and iteration counter.
!
par = 0.0
iter = 1
!
!     Beginning of the outer loop.
!
30 continue
!
!        Calculate the Jacobian matrix.
!
   iflag = 2
   call fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa4)
   nfev = nfev + n
   if (iflag .lt. 0) go to 300
!
!        If requested, call FCN to enable printing of iterates.
!
   if (nprint .le. 0) go to 40
   iflag = 0
   if (mod(iter-1,nprint) .eq. 0) call fcn(m,n,x,fvec,iflag)
   if (iflag .lt. 0) go to 300
40 continue
!
!        Compute the QR factorization of the Jacobian.
!
   call qrfac(m,n,fjac,ldfjac,.true.,ipvt,n,wa1,wa2,wa3)
!
!        On the first iteration and if mode is 1, scale according
!        to the norms of the columns of the initial Jacobian.
!
   if (iter .ne. 1) go to 80
   if (mode .eq. 2) go to 60
   do j = 1, n
      diag(j) = wa2(j)
      if (wa2(j) .eq. 0.0) diag(j) = 1.0
      end do
60 continue
!
!        On the first iteration, calculate the norm of the scaled x
!        and initialize the step bound delta.
!
   do j = 1, n
      wa3(j) = diag(j)*x(j)
      end do
   xnorm = enorm(n,wa3)
   delta = factor*xnorm
   if (delta .eq. 0.0) delta = factor
80 continue
!
!        Form (Q transpose)*fvec and store the first n components in
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
!        Compute the norm of the scaled gradient.
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
!        Test for convergence of the gradient norm.
!
   if (gnorm .le. gtol) info = 4
   if (info .ne. 0) go to 300
!
!        Rescale if necessary.
!
   if (mode .eq. 2) go to 190
   do j = 1, n
      diag(j) = amax1(diag(j),wa2(j))
      end do
190 continue
!
!        Beginning of the inner loop.
!
200 continue
!
!           Determine the Levenberg-Marquardt parameter.
!
      call lmpar(n,fjac,ldfjac,ipvt,diag,qtf,delta,par,wa1,wa2, &
&wa3,wa4)
!
!           Store the direction P and x + P. calculate the norm of P.
!
      do j = 1, n
         wa1(j) = -wa1(j)
         wa2(j) = x(j) + wa1(j)
         wa3(j) = diag(j)*wa1(j)
         end do
      pnorm = enorm(n,wa3)
!
!           On the first iteration, adjust the initial step bound.
!
      if (iter .eq. 1) delta = amin1(delta,pnorm)
!
!           Evaluate the function at x + P and calculate its norm.
!
      iflag = 1
      call fcn(m,n,wa2,wa4,iflag)
      nfev = nfev + 1
      if (iflag .lt. 0) go to 300
      fnorm1 = enorm(m,wa4)
!
!           Compute the scaled actual reduction.
!
      actred = -1.0
      if (p1*fnorm1 .lt. fnorm) actred = 1.0 - (fnorm1/fnorm)**2
!
!           Compute the scaled predicted reduction and
!           the scaled directional derivative.
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
!           Compute the ratio of the actual to the predicted
!           reduction.
!
      ratio = 0.0
      if (prered .ne. 0.0) ratio = actred/prered
!
!           Update the step bound.
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
!           Test for successful iteration.
!
      if (ratio .lt. p0001) go to 290
!
!           Successful iteration. Update x, fvec, and their norms.
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
!           Tests for convergence.
!
      if (abs(actred) .le. ftol .and. prered .le. ftol &
&.and. p5*ratio .le. 1.0) info = 1
      if (delta .le. xtol*xnorm) info = 2
      if (abs(actred) .le. ftol .and. prered .le. ftol &
&.and. p5*ratio .le. 1.0 .and. info .eq. 2) info = 3
      if (info .ne. 0) go to 300
!
!           Tests for termination and stringent tolerances.
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
!     Termination, either normal or user imposed.
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
!     FUNCTION enorm
!
!     Given an n-vector x, this function calculates the
!     Euclidean norm of x.
!
!     The Euclidean norm is computed by accumulating the sum of
!     squares in three different sums. The sums of squares for the
!     small and large components are scaled so that no overflows
!     occur. Non-destructive underflows are permitted. Underflows
!     and overflows do not occur in the computation of the unscaled
!     sum of squares for the intermediate components.
!     The definitions of small, intermediate and large components
!     depend on two constants, rdwarf and rgiant. The main
!     restrictions on these constants are that rdwarf**2 not
!     underflow and rgiant**2 not overflow. The constants
!     given here are suitable for every known computer.
!
!     The function statement is
!
!       REAL FUNCTION enorm(n,x)
!
!     Where
!
!       n is a positive integer input variable.
!
!       x is an input array of length n.
!
!     Subprograms called
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge J. more
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
!              Sum for large components.
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
!              Sum for small components.
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
!           Sum for intermediate components.
!
      s2 = s2 + xabs**2
80 continue
90 continue
!
!     Calculation of norm.
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
!     Subroutine dogleg
!
!     Given an M by n matrix A, an n by n nonsingular diagonal
!     matrix D, an M-vector B, and a positive number delta, the
!     problem is to determine the convex combination x of the
!     Gauss-Newton and scaled gradient directions that minimizes
!     (A*x - B) in the least squares sense, subject to the
!     restriction that the Euclidean norm of D*x be at most delta.
!
!     This subroutine completes the solution of the problem
!     if it is provided with the necessary information from the
!     QR factorization of A. that is, if A = Q*r, where Q has
!     orthogonal columns and r is an upper triangular matrix,
!     then dogleg expects the full upper triangle of r and
!     the first n components of (Q transpose)*B.
!
!     The subroutine statement is
!
!       subroutine dogleg(n,r,lr,diag,qtb,delta,x,wa1,wa2)
!
!     Where
!
!       n is a positive integer input variable SET to the order of r.
!
!       r is an input array of length lr which must contain the upper
!         triangular matrix r stored by rows.
!
!       lr is a positive integer input variable NOT less than
!         (n*(n+1))/2.
!
!       Diag is an input array of length n which must contain the
!         diagonal elements of the matrix D.
!
!       qtb is an input array of length n which must contain the first
!         n elements of the vector (Q transpose)*B.
!
!       delta is a positive input variable which specifies an upper
!         bound on the Euclidean norm of D*x.
!
!       x is an output array of length n which contains the desired
!         convex combination of the Gauss-Newton direction and the
!         scaled gradient direction.
!
!       wa1 and wa2 are work arrays of length n.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar,enorm
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j, jj, jp1, k, l
real :: alpha, bnorm, epsmch, gnorm, qnorm, sgnorm, sum, temp
real :: spmpar, enorm
!
!     epsmch is the machine precision.
!
epsmch = spmpar(1)
!
!     First, calculate the Gauss-Newton direction.
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
!     Test whether the Gauss-Newton direction is acceptable.
!
do j = 1, n
   wa1(j) = 0.0
   wa2(j) = diag(j)*x(j)
   end do
qnorm = enorm(n,wa2)
if (qnorm .le. delta) go to 140
!
!     The Gauss-Newton direction is not acceptable.
!     Next, calculate the scaled gradient direction.
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
!     Calculate the norm of the scaled gradient and test for
!     the special case in which the scaled gradient is zero.
!
gnorm = enorm(n,wa1)
sgnorm = 0.0
alpha = delta/qnorm
if (gnorm .eq. 0.0) go to 120
!
!     Calculate the point along the scaled gradient
!     at which the quadratic is minimized.
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
!     Test whether the scaled gradient direction is acceptable.
!
alpha = 0.0
if (sgnorm .ge. delta) go to 120
!
!     The scaled gradient direction is not acceptable.
!     Finally, calculate the point along the dogleg
!     at which the quadratic is minimized.
!
bnorm = enorm(n,qtb)
temp = (bnorm/gnorm)*(bnorm/qnorm)*(sgnorm/delta)
temp = temp - (delta/qnorm)*(sgnorm/delta)**2 &
&+ sqrt((temp-(delta/qnorm))**2 &
&+(1.0-(delta/qnorm)**2)*(1.0-(sgnorm/delta)**2))
alpha = ((delta/qnorm)*(1.0 - (sgnorm/delta)**2))/temp
120 continue
!
!     Form appropriate convex combination of the Gauss-Newton
!     direction and the scaled gradient direction.
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
!     SUBROUTINE fdjac1
!
!     This subroutine computes a forward-difference approximation
!     to the n by n Jacobian matrix associated with a specified
!     problem of n functions in n variables. If the Jacobian has
!     a banded form, then function evaluations are saved by only
!     approximating the nonzero terms.
!
!     The subroutine statement is
!
!       subroutine fdjac1(fcn,n,x,fvec,fjac,ldfjac,iflag,ml,mu,epsfcn,
!                         wa1,wa2)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(n,x,fvec,iflag)
!         integer n,iflag
!         real x(n),fvec(n)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of fdjac1.
!         In this case set iflag to a negative integer.
!
!       n is a positive integer input variable SET to the number
!         of functions and variables.
!
!       x is an input array of length n.
!
!       fvec is an input array of length n which must contain the
!         functions evaluated at x.
!
!       fjac is an output n by n array which contains the
!         approximation to the Jacobian matrix evaluated at x.
!
!       ldfjac is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array fjac.
!
!       iflag is an integer variable which can be used to terminate
!         the execution of fdjac1. See description of FCN.
!
!       ml is a nonnegative integer input variable which specifies
!         the number of subdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         ml to at least n - 1.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       mu is a nonnegative integer input variable which specifies
!         the number of superdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         mu to at least n - 1.
!
!       wa1 and wa2 are work arrays of length n. if ml + mu + 1 is at
!         least n, then the Jacobian is considered dense, and wa2 is
!         not referenced.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar
!
!       Fortran-supplied ... abs,AMAX1,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j, k, msum
real :: eps, epsmch, h, temp, zero
real :: spmpar
data zero /0.0e0/
!
!     epsmch is the machine precision.
!
epsmch = spmpar(1)
!
eps = sqrt(amax1(epsfcn,epsmch))
msum = ml + mu + 1
if (msum .lt. n) go to 40
!
!        Computation of dense approximate Jacobian.
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
!        Computation of banded approximate Jacobian.
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
!     Last card of subroutine fdjac1.
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
!     SUBROUTINE fdjac2
!
!     This subroutine computes a forward-difference approximation
!     to the m by n Jacobian matrix associated with a specified
!     problem of m functions in n variables.
!
!     The subroutine statement is
!
!       subroutine fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(m,n,x,fvec,iflag)
!         integer m,n,iflag
!         real x(n),fvec(m)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of fdjac2.
!         In this case set iflag to a negative integer.
!
!       m is a positive integer input variable SET to the number
!         of functions.
!
!       n is a positive integer input variable SET to the number
!         of variables. n must not exceed m.
!
!       x is an input array of length n.
!
!       fvec is an input array of length m which must contain the
!         functions evaluated at x.
!
!       fjac is an output m by n array which contains the
!         approximation to the Jacobian matrix evaluated at x.
!
!       ldfjac is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array fjac.
!
!       iflag is an integer variable which can be used to terminate
!         the execution of fdjac2. See description of FCN.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       wa is a work array of length m.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... spmpar
!
!       Fortran-supplied ... abs,AMAX1,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j
real :: eps, epsmch, h, temp, zero
real :: spmpar
data zero /0.0e0/
!
!     epsmch is the machine precision.
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
!     Last card of subroutine fdjac2.
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
!     SUBROUTINE lmpar
!
!     Given an M by n matrix A, an n by n nonsingular diagonal
!     matrix D, an M-vector B, and a positive number delta,
!     the problem is to determine a value for the parameter
!     par such that if x solves the system
!
!           A*x = B ,     sqrt(par)*D*x = 0 ,
!
!     In the least squares sense, and dxnorm is the Euclidean
!     norm of D*x, then either par is zero and
!
!           (dxnorm-delta) .LE. 0.1*delta ,
!
!     Or par is positive and
!
!           abs(dxnorm-delta) .LE. 0.1*delta .
!
!     This subroutine completes the solution of the problem
!     if it is provided with the necessary information from the
!     QR factorization, with column pivoting, of A. that is, if
!     A*P = Q*r, where P is a permutation matrix, Q has orthogonal
!     columns, and r is an upper triangular matrix with diagonal
!     elements of nonincreasing magnitude, then lmpar expects
!     the full upper triangle of r, the permutation matrix P,
!     and the first n components of (Q transpose)*B. on output
!     lmpar also provides an upper triangular matrix S such that
!
!            T   T                   T
!           P *(A *A + par*D*D)*P = S *S .
!
!     S is employed within lmpar and may be of separate interest.
!
!     Only a few iterations are generally needed for convergence
!     of the algorithm. If, however, the limit of 10 iterations
!     is reached, then the output par will contain the best
!     value obtained so far.
!
!     The subroutine statement is
!
!       subroutine lmpar(n,r,ldr,ipvt,diag,qtb,delta,par,x,sdiag,
!                        wa1,wa2)
!
!     Where
!
!       n is a positive integer input variable SET to the order of r.
!
!       r is an n by n array. On input the full upper triangle
!         must contain the full upper triangle of the matrix r.
!         On output the full upper triangle is unaltered, and the
!         strict lower triangle contains the strict upper triangle
!         (transposed) of the upper triangular matrix S.
!
!       ldr is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array r.
!
!       ipvt is an integer input array of length n which defines the
!         permutation matrix P such that A*P = Q*r. column j of P
!         is column ipvt(j) of the identity matrix.
!
!       Diag is an input array of length n which must contain the
!         diagonal elements of the matrix D.
!
!       qtb is an input array of length n which must contain the first
!         n elements of the vector (Q transpose)*B.
!
!       delta is a positive input variable which specifies an upper
!         bound on the Euclidean norm of D*x.
!
!       Par is a nonnegative variable. On input par contains an
!         initial estimate of the Levenberg-Marquardt parameter.
!         On output par contains the final estimate.
!
!       x is an output array of length n which contains the least
!         squares solution of the system A*x = B, sqrt(par)*D*x = 0,
!         for the output par.
!
!       sdiag is an output array of length n which contains the
!         diagonal elements of the upper triangular matrix S.
!
!       wa1 and wa2 are work arrays of length n.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar,enorm,qrsolv
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, iter, j, jm1, jp1, k, l, nsing
real :: dxnorm, dwarf, fp, gnorm, parc, parl, paru, p1, p001, sum, &
&temp, zero
real :: spmpar, enorm
data p1,p001,zero /1.0e-1,1.0e-3,0.0e0/
!
!     Dwarf is the smallest positive magnitude.
!
dwarf = spmpar(2)
!
!     Compute and store in x the Gauss-Newton direction. If the
!     Jacobian is rank-deficient, obtain a least squares solution.
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
!     Initialize the iteration counter.
!     Evaluate the function at the origin, and test
!     for acceptance of the Gauss-Newton direction.
!
iter = 0
do j = 1, n
   wa2(j) = diag(j)*x(j)
   end do
dxnorm = enorm(n,wa2)
fp = dxnorm - delta
if (fp .le. p1*delta) go to 220
!
!     If the Jacobian is not rank deficient, the Newton
!     step provides a lower bound, parl, for the zero of
!     the function. Otherwise set this bound to zero.
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
!     Calculate an upper bound, paru, for the zero of the function.
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
!     If the input par lies outside of the interval (parl,paru),
!     set par to the closer endpoint.
!
par = amax1(par,parl)
par = amin1(par,paru)
if (par .eq. zero) par = gnorm/dxnorm
!
!     Beginning of an iteration.
!
150 continue
   iter = iter + 1
!
!        Evaluate the function at the current value of par.
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
!        If the function is small enough, accept the current value
!        of par. Also test for the exceptional cases where parl
!        is zero or the number of iterations has reached 10.
!
   if (abs(fp) .le. p1*delta &
&.or. parl .eq. zero .and. fp .le. temp &
&.and. temp .lt. zero .or. iter .eq. 10) go to 220
!
!        Compute the Newton correction.
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
!        Depending on the sign of the function, update parl or paru.
!
   if (fp .gt. zero) parl = amax1(parl,par)
   if (fp .lt. zero) paru = amin1(paru,par)
!
!        Compute an improved estimate for par.
!
   par = amax1(parl,par+parc)
!
!        END OF AN ITERATION.
!
   go to 150
220 continue
!
!     Termination.
!
if (iter .eq. 0) par = zero
return
!
!     Last card of subroutine lmpar.
!
end subroutine lmpar

subroutine qform(m,n,q,ldq,wa)
implicit none
integer, intent(in) :: m, n, ldq
real, intent(inout) :: q(ldq,m), wa(m)
!     **********
!
!     SUBROUTINE qform
!
!     This subroutine proceeds from the computed QR factorization of
!     an m by n matrix A to accumulate the m by m orthogonal matrix
!     q from its factored form.
!
!     The subroutine statement is
!
!       subroutine qform(m,n,q,ldq,wa)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of A and the order of q.
!
!       n is a positive integer input variable SET to the number
!         of columns of A.
!
!       q is an m by m array. On input the full lower trapezoid in
!         the first min(m,n) columns of q contains the factored form.
!         On output q has been accumulated into a square matrix.
!
!       ldq is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array q.
!
!       wa is a work array of length m.
!
!     Subprograms called
!
!       Fortran-supplied ... MIN0
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j, jm1, k, l, minmn, np1
real :: one, sum, temp, zero
data one,zero /1.0e0,0.0e0/
!
!     Zero out upper triangle of q in the first min(m,n) columns.
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
!     Initialize remaining columns to those of the identity matrix.
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
!     Accumulate q from its factored form.
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
!     Last card of subroutine qform.
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
!     SUBROUTINE qrfac
!
!     This subroutine uses Householder transformations with column
!     pivoting (optional) to compute A QR factorization of the
!     m by n matrix a. that is, qrfac determines an orthogonal
!     matrix Q, a permutation matrix P, and an upper trapezoidal
!     matrix R with diagonal elements of nonincreasing magnitude,
!     such that a*P = Q*R. the Householder transformation for
!     column k, k = 1,2,...,min(m,n), is of the form
!
!                           T
!           i - (1/U(k))*U*U
!
!     Where U has zeros in the first k-1 positions. The form of
!     this transformation and the method of pivoting first
!     appeared in the corresponding LINPACK subroutine.
!
!     The subroutine statement is
!
!       subroutine qrfac(m,n,a,lda,pivot,ipvt,lipvt,rdiag,acnorm,wa)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of A.
!
!       n is a positive integer input variable SET to the number
!         of columns of A.
!
!       A is an m by n array. On input a contains the matrix for
!         which the QR factorization is to be computed. On output
!         the strict upper trapezoidal part of a contains the strict
!         upper trapezoidal part of R, and the lower trapezoidal
!         part of a contains a factored form of Q (the non-trivial
!         elements of the U vectors described above).
!
!       lda is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array a.
!
!       Pivot is a logical input variable. If pivot is set true,
!         then column pivoting is enforced. If pivot is set false,
!         then no column pivoting is done.
!
!       ipvt is an integer output array of length lipvt. ipvt
!         defines the permutation matrix P such that a*P = Q*R.
!         Column j of P is column ipvt(j) of the identity matrix.
!         If pivot is false, ipvt is not referenced.
!
!       lipvt is a positive integer input variable. If pivot is false,
!         then lipvt may be as small as 1. If pivot is true, then
!         lipvt must be at least n.
!
!       rdiag is an output array of length n which contains the
!         diagonal elements of R.
!
!       acnorm is an output array of length n which contains the
!         norms of the corresponding columns of the input matrix a.
!         If this information is not needed, then acnorm can coincide
!         WITH rdiag.
!
!       wa is a work array of length n. if pivot is false, then wa
!         can coincide with rdiag.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar,enorm
!
!       Fortran-supplied ... AMAX1,sqrt,MIN0
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j, jp1, k, kmax, minmn
real :: ajnorm, epsmch, one, p05, sum, temp, zero
real :: spmpar, enorm
data one,p05,zero /1.0e0,5.0e-2,0.0e0/
!
!     epsmch is the machine precision.
!
epsmch = spmpar(1)
!
!     Compute the initial column norms and initialize several arrays.
!
do j = 1, n
   acnorm(j) = enorm(m,a(1,j))
   rdiag(j) = acnorm(j)
   wa(j) = rdiag(j)
   if (pivot) ipvt(j) = j
   end do
!
!     Reduce A to R with Householder transformations.
!
minmn = min0(m,n)
do j = 1, minmn
   if (.not.pivot) go to 40
!
!        Bring the column of largest norm into the pivot position.
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
!        Compute the Householder transformation to reduce the
!        j-TH column of A to a multiple of the j-TH unit vector.
!
   ajnorm = enorm(m-j+1,a(j,j))
   if (ajnorm .eq. zero) go to 100
   if (a(j,j) .lt. zero) ajnorm = -ajnorm
   do i = j, m
      a(i,j) = a(i,j)/ajnorm
      end do
   a(j,j) = a(j,j) + one
!
!        Apply the transformation to the remaining columns
!        and update the norms.
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
!     Last card of subroutine qrfac.
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
!     SUBROUTINE qrsolv
!
!     Given an M by n matrix A, an n by n diagonal matrix D,
!     and an M-vector B, the problem is to determine an x which
!     solves the system
!
!           A*x = B ,     D*x = 0 ,
!
!     In the least squares sense.
!
!     This subroutine completes the solution of the problem
!     if it is provided with the necessary information from the
!     QR factorization, with column pivoting, of A. that is, if
!     A*P = Q*r, where P is a permutation matrix, Q has orthogonal
!     columns, and r is an upper triangular matrix with diagonal
!     elements of nonincreasing magnitude, then qrsolv expects
!     the full upper triangle of r, the permutation matrix P,
!     and the first n components of (Q transpose)*B. the system
!     A*x = B, D*x = 0, is then equivalent to
!
!                  T       T
!           r*Z = Q *B ,  P *D*P*Z = 0 ,
!
!     Where x = P*Z. if this system does not have full rank,
!     then a least squares solution is obtained. On output qrsolv
!     also provides an upper triangular matrix S such that
!
!            T   T               T
!           P *(A *A + D*D)*P = S *S .
!
!     S is computed within qrsolv and may be of separate interest.
!
!     The subroutine statement is
!
!       subroutine qrsolv(n,r,ldr,ipvt,diag,qtb,x,sdiag,wa)
!
!     Where
!
!       n is a positive integer input variable SET to the order of r.
!
!       r is an n by n array. On input the full upper triangle
!         must contain the full upper triangle of the matrix r.
!         On output the full upper triangle is unaltered, and the
!         strict lower triangle contains the strict upper triangle
!         (transposed) of the upper triangular matrix S.
!
!       ldr is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array r.
!
!       ipvt is an integer input array of length n which defines the
!         permutation matrix P such that A*P = Q*r. column j of P
!         is column ipvt(j) of the identity matrix.
!
!       Diag is an input array of length n which must contain the
!         diagonal elements of the matrix D.
!
!       qtb is an input array of length n which must contain the first
!         n elements of the vector (Q transpose)*B.
!
!       x is an output array of length n which contains the least
!         squares solution of the system A*x = B, D*x = 0.
!
!       sdiag is an output array of length n which contains the
!         diagonal elements of the upper triangular matrix S.
!
!       wa is a work array of length n.
!
!     Subprograms called
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j, jp1, k, kp1, l, nsing
real :: cos, cotan, p5, p25, qtbpj, sin, sum, tan, temp, zero
data p5,p25,zero /5.0e-1,2.5e-1,0.0e0/
!
!     Copy r and (Q transpose)*B to preserve input and initialize S.
!     In particular, save the diagonal elements of r in x.
!
do j = 1, n
   do i = j, n
      r(i,j) = r(j,i)
      end do
   x(j) = r(j,j)
   wa(j) = qtb(j)
   end do
!
!     Eliminate the diagonal matrix D using a Givens rotation.
!
do j = 1, n
!
!        Prepare the row of D to be eliminated, locating the
!        diagonal element using P from the QR factorization.
!
   l = ipvt(j)
   if (diag(l) .eq. zero) go to 90
   do k = j, n
      sdiag(k) = zero
      end do
   sdiag(j) = diag(l)
!
!        The transformations to eliminate the row of D
!        modify only a single element of (Q transpose)*B
!        beyond the first n, which is initially zero.
!
   qtbpj = zero
   do k = j, n
!
!           Determine a Givens rotation which eliminates the
!           appropriate element in the current row of D.
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
!           Compute the modified diagonal element of r and
!           the modified element of ((Q transpose)*B,0).
!
      r(k,k) = cos*r(k,k) + sin*sdiag(k)
      temp = cos*wa(k) + sin*qtbpj
      qtbpj = -sin*wa(k) + cos*qtbpj
      wa(k) = temp
!
!           Accumulate the tranformation in the row of S.
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
!        Store the diagonal element of S and restore
!        the corresponding diagonal element of r.
!
   sdiag(j) = r(j,j)
   r(j,j) = x(j)
   end do
!
!     Solve the triangular system for Z. if the system is
!     singular, then obtain a least squares solution.
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
!     Permute the components of Z back to components of x.
!
do j = 1, n
   l = ipvt(j)
   x(l) = wa(j)
   end do
return
!
!     Last card of subroutine qrsolv.
!
end subroutine qrsolv

subroutine r1mpyq(m,n,a,lda,v,w)
implicit none
integer, intent(in) :: m, n, lda
real, intent(inout) :: a(lda,n)
real, intent(in) :: v(n), w(n)
!     **********
!
!     SUBROUTINE r1mpyq
!
!     Given an m by n matrix a, this subroutine computes a*Q where
!     Q is the product of 2*(n - 1) transformations
!
!           GV(n-1)*...*GV(1)*GW(1)*...*GW(n-1)
!
!     And GV(i), GW(i) are Givens rotations in the (i,n) plane which
!     eliminate elements in the i-TH and n-TH planes, respectively.
!     Q itself is not given, rather the information to recover the
!     GV, GW ROTATIONS IS SUPPLIED.
!
!     The subroutine statement is
!
!       subroutine r1mpyq(m,n,a,lda,v,w)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of A.
!
!       n is a positive integer input variable SET to the number
!         of columns of A.
!
!       A is an m by n array. On input A must contain the matrix
!         to be postmultiplied by the orthogonal matrix Q
!         described above. On output a*Q has replaced A.
!
!       lda is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array a.
!
!       v is an input array of length n. v(i) must contain the
!         information necessary to recover the Givens rotation GV(i)
!         described above.
!
!       w is an input array of length n. w(i) must contain the
!         information necessary to recover the Givens rotation GW(i)
!         described above.
!
!     Subroutines called
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
integer :: i, j, nmj, nm1
real :: cos, one, sin, temp
data one /1.0e0/
!
!     Apply the first set of Givens rotations to A.
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
!     Apply the second set of Givens rotations to A.
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
!     Last card of subroutine r1mpyq.
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
!     SUBROUTINE r1updt
!
!     Given an m by n lower trapezoidal matrix s, an m-vector u,
!     and an n-vector v, the problem is to determine an
!     orthogonal matrix Q such that
!
!                   T
!           (s + u*v )*Q
!
!     Is again lower trapezoidal.
!
!     This subroutine determines Q as the product of 2*(n - 1)
!     transformations
!
!           GV(n-1)*...*GV(1)*GW(1)*...*GW(n-1)
!
!     Where GV(i), GW(i) are Givens rotations in the (i,n) plane
!     which eliminate elements in the i-TH and n-TH planes,
!     respectively. Q itself is not accumulated, rather the
!     information to recover the GV, GW rotations is returned.
!
!     The subroutine statement is
!
!       subroutine r1updt(m,n,s,ls,u,v,w,sing)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of s.
!
!       n is a positive integer input variable SET to the number
!         of columns of s. n must not exceed m.
!
!       s is an array of length ls. On input s must contain the lower
!         trapezoidal matrix s stored by columns. On output s contains
!         the lower trapezoidal matrix produced as described above.
!
!       ls is a positive integer input variable NOT less than
!         (n*(2*m-n+1))/2.
!
!       u is an input array of length m which must contain the
!         VECTOR u.
!
!       v is an array of length n. on input v must contain the vector
!         v. on output v(i) contains the information necessary to
!         recover the Givens rotation GV(i) described above.
!
!       w is an output array of length m. w(i) contains information
!         necessary to recover the Givens rotation GW(i) described
!         above.
!
!       Sing is a logical output variable. Sing is set true if any
!         of the diagonal elements of the output s are zero. Otherwise
!         sing is set false.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton s. Garbow, kenneth E. Hillstrom, jorge j. more,
!     john l. nazareth
!
!     **********
integer :: i, j, jj, l, nmj, nm1
real :: cos, cotan, giant, one, p5, p25, sin, tan, tau, temp, zero
real :: spmpar
data one,p5,p25,zero /1.0e0,5.0e-1,2.5e-1,0.0e0/
!
!     Giant is the largest magnitude.
!
giant = spmpar(3)
!
!     Initialize the diagonal element pointer.
!
jj = (n*(2*m - n + 1))/2 - (m - n)
!
!     Move the nontrivial part of the last column of s into w.
!
l = jj
do i = n, m
   w(i) = s(l)
   l = l + 1
   end do
!
!     Rotate the vector v into a multiple of the n-TH unit vector
!     in such a way that a spike is introduced into w.
!
nm1 = n - 1
if (nm1 .lt. 1) go to 70
do nmj = 1, nm1
   j = n - nmj
   jj = jj - (m - j + 1)
   w(j) = zero
   if (v(j) .eq. zero) go to 50
!
!        Determine a Givens rotation which eliminates the
!        j-TH element of v.
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
!        Apply the transformation to v and store the information
!        necessary to recover the Givens rotation.
!
   v(n) = sin*v(j) + cos*v(n)
   v(j) = tau
!
!        Apply the transformation to s and extend the spike in w.
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
!     Add the spike from the rank 1 update to w.
!
do i = 1, m
   w(i) = w(i) + v(n)*u(i)
   end do
!
!     Eliminate the spike.
!
sing = .false.
if (nm1 .lt. 1) go to 140
do j = 1, nm1
   if (w(j) .eq. zero) go to 120
!
!        Determine a Givens rotation which eliminates the
!        j-TH element of the spike.
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
!        Apply the transformation to s and reduce the spike in w.
!
   l = jj
   do i = j, m
      temp = cos*s(l) + sin*w(i)
      w(i) = -sin*s(l) + cos*w(i)
      s(l) = temp
      l = l + 1
      end do
!
!        Store the information necessary to recover the
!        Givens rotation.
!
   w(j) = tau
120 continue
!
!        Test for zero diagonal elements in the output s.
!
   if (s(jj) .eq. zero) sing = .true.
   jj = jj + (m - j + 1)
   end do
140 continue
!
!     Move w back into the last column of the output s.
!
l = jj
do i = n, m
   s(l) = w(i)
   l = l + 1
   end do
if (s(jj) .eq. zero) sing = .true.
return
!
!     Last card of subroutine r1updt.
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
!     Simplex procedure for solving linear programming problems
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!------------------------
!     Initial version  DEC  1977
!     LAST UPDATE      OCT  1990
!------------------------
dimension ibasis(m)
!------------------------
!     dimension x(n0+numle+numge)
!     dimension wk(2*m),iwk(2*m+n0)
!------------------------
!
!     ********** eps0 is a machine dependent parameter. Assign eps0
!                the value U where U is the smallest positive floating
!                point number such that 1.0 + U .GT. 1.0.
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
!     NSTEP = 1   Eliminate the negative variables
!     NSTEP = 2   Phase 1 of the simplex algorithm
!     NSTEP = 3   Phase 2 of the simplex algorithm
!----------------------
!     mxiter = The maximum number of iterations permitted
!     iter = The number of the current iteration
!     icount = The number of iterations since the last inversion
!----------------------
!     numle = The number of .LE. constraints
!     numge = The number of .GE. constraints
!----------------------
!     The routine assumes that the .LE. constraints precede the .GE.
!     Constraints and that the .EQ. constraints come last. There are
!     m constraints. X(n0+i) is the slack, surplus, or artificial
!     variable for the i-TH constraint (i=1,...,m).
!----------------------
!     n0 = The number of orginal variables
!     NS = The number of orginal and slack variables
!     N  = The number of orginal, slack, and surplus variables
!     NUM = The total number of variables
!----------------------
!     rerrmn = The smallest relative error tolerance used
!     rerrmx = The largest relative error TOLERACE used
!     rerr   = The estimated current relative error
!----------------------
!     Assume that
!         b0 = (b0(1),...,b0(m))
!         c  = (c(1),...,c(n0))
!         z  = c(1)*x(1)+...+c(n0)*x(n0)
!     the problem is to maximize z subject to
!         AX(le,EQ,GE)b0
!         X.GE.0
!----------------------
!     On input ind can have the values
!         ind = 0   No beginning basis is provided by the user
!         ind = 1   The array ibasis has been set by the user
!     on output ind is assigned one of the values
!         ind = 0   z was successfully maximized
!         ind = 1   The problem has no feasible solution
!         ind = 2   mxiter iterations were performed
!         ind = 3   Sufficient accuracy cannot be maintained
!         ind = 4   The problem has an unbounded solution
!         ind = 5   There is an input error
!         ind = 6   z was possibly maximized
!----------------------
!     Basis is an integer array of dimension n0+m. for j.LE.N
!         basis(j) = 1  If X(j) is a BASIC variable
!         basis(j) = 0  If X(j) is not a BASIC variable
!     if the BASIC variables are X(I1),...,X(IM) then
!         ibasis = (i1,...,im)
!     also xb(1),...,xb(m) are the corresponding values of the
!     BASIC variables.
!----------------------
!     bi is an MXM array containing the inverse of the basis matrix.
!----------------------
!     r is an array of dimension N. on output r contains the current
!     value of X. during computation r normally contains the reduced
!     costs used for the selection of the variable to be made BASIC.
!----------------------
real, intent(in) :: a(ka,n0), b0(m), c(n0)
real, intent(inout) :: bi(m,m), xb(m), y(m), r(*)
integer, intent(inout) :: ibasis(m), basis(*)
integer :: bflag
integer, intent(inout) :: index(m)
double precision :: dsum, dsump, dsumn, dt
!----------------------
!
!     ****** Xmax is a machine dependent constant. Xmax is the
!            largest positive floating point number.
!
           xmax = spmpar(3)
!
!----------------------
iter = 0
icount = 0
mcheck = min0(5,1 + m/15)
z = 0.0
!
!                Check for input errors
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
!     Formation of the ibasis and basis arrays. (If ind = 1
!     then the ibasis array is defined by the user.)
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
!          Calculation of xb and bi when ind = 0
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
!                  Reorder the basis
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
!            REINVERSION of the basis matrix
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
!         Check the accuracy of bi and reset rerr
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
!                 Recalculation of xb
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
!     Find the next vector a(--,JP) to be inserted into
!                       the basis
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
!     Insert the values of the orginal, slack, and surplus
!             variables into r. then terminate.
!
220 do 221 j = 1,n
221 r(j) = 0.0
do i = 1,m
   ki = ibasis(i)
   if (ki .le. n) r(ki) = xb(i)
end do
return
!
!             Completion of the NSTEP = 2 Case
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
!             Completion of the NSTEP = 3 Case
!
250 if (rerr .gt. 1.e-2) go to 251
   ind = 0
   go to 800
251 if (icount .ge. 5) go to 100
ind = 6
go to 800
!
!     If mxiter iterations have not been performed then
!     begin the next iteration. Compute the JP-TH column
!               of bi*a and store it in y.
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
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 1 Case
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
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 2 Case
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
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 3 Case
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
!              Tie breaking procedure
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
!               Transformation of xb
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
!               Transformation of bi
!
510 do 512 j = 1,m
   if (bi(ip,j) .eq. 0.0) go to 512
   const = bi(ip,j)/y(ip)
   do 511 i = 1,m
511 bi(i,j) = bi(i,j) - const*y(i)
   bi(ip,j) = const
512 continue
!
!             Updating ibasis and basis
!
iout = ibasis(ip)
ibasis(ip) = jp
basis(iout) = 0
basis(jp) = 1
if (iout .gt. n) num = num - 1
!
!        Check the accuracy of bi and reset rerr
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
!        The accuracy criteria are not satisfied
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
!       Set up the r array for the NSTEP = 1 Case
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
!       Set up the r array for the NSTEP = 2 Case
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
!      Set up a new r array for the NSTEP = 3 Case
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
!       Update the r array for the NSTEP = 3 Case
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
!               Refine xb and store the result in y
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
!         Check the refinement (NSTEP = 1)
!
860 do 861 i = 1,m
   if (y(i) .ge. 0.0) go to 861
   if (y(i) .lt. -rerrmx) go to 240
   y(i) = 0.0
861 xb(i) = y(i)
go to 630
!
!         Check the refinement (NSTEP = 2)
!
870 do 871 i = 1,m
   if (ibasis(i) .le. n) go to 871
   if (y(i) .gt. rerrmx) go to 240
   y(i) = 0.0
871 xb(i) = y(i)
go to 680
!
!              COMPUTE z  (NSTEP = 3)
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
!     Simplex procedure for solving linear programming problems
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!------------------------
!     Initial version  DEC  1977
!     LAST UPDATE      OCT  1990
!------------------------
dimension ibasis(m)
!------------------------
!     dimension x(n0+numle+numge)
!     dimension wk(2*m),iwk(2*m+n0)
!------------------------
!
!     ********** eps0 is a machine dependent parameter. Assign eps0
!                the value U where U is the smallest positive floating
!                point number such that 1.0 + U .GT. 1.0.
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
!     NSTEP = 1   Eliminate the negative variables
!     NSTEP = 2   Phase 1 of the simplex algorithm
!     NSTEP = 3   Phase 2 of the simplex algorithm
!----------------------
!     mxiter = The maximum number of iterations permitted
!     iter = The number of the current iteration
!     icount = The number of iterations since the last inversion
!----------------------
!     numle = The number of .LE. constraints
!     numge = The number of .GE. constraints
!----------------------
!     The routine assumes that the .LE. constraints precede the .GE.
!     Constraints and that the .EQ. constraints come last. There are
!     m constraints. X(n0+i) is the slack, surplus, or artificial
!     variable for the i-TH constraint (i=1,...,m).
!----------------------
!     n0 = The number of orginal variables
!     NS = The number of orginal and slack variables
!     N  = The number of orginal, slack, and surplus variables
!     NUM = The total number of variables
!----------------------
!     rerrmn = The smallest relative error tolerance used
!     rerrmx = The largest relative error tolerance used
!     rerr   = The estimated current relative error
!----------------------
!     Let a denote an MXN0 matrix. The transpose of A is stored in
!     sparse form in ta,ita,jta. Assume that
!         b0 = (b0(1),...,b0(m))
!         c  = (c(1),...,c(n0))
!         z  = c(1)*x(1)+...+c(n0)*x(n0)
!     the problem is to maximize z subject to
!         AX(le,EQ,GE)b0
!         X.GE.0
!----------------------
!     On input ind can have the values
!         ind = 0   No beginning basis is provided by the user
!         ind = 1   The array ibasis has been set by the user
!     on output ind is assigned one of the values
!         ind = 0   z was successfully maximized
!         ind = 1   The problem has no feasible solution
!         ind = 2   mxiter iterations were performed
!         ind = 3   Sufficient accuracy cannot be maintained
!         ind = 4   The problem has an unbounded solution
!         ind = 5   There is an input error
!         ind = 6   z was possibly maximized
!----------------------
!     Basis is an integer array of dimension n0+m. for j.LE.N
!         basis(j) = 1  If X(j) is a BASIC variable
!         basis(j) = 0  If X(j) is not a BASIC variable
!     if the BASIC variables are X(I1),...,X(IM) then
!         ibasis = (i1,...,im)
!     also xb(1),...,xb(m) are the corresponding values of the
!     BASIC variables.
!----------------------
!     bi is an MXM array containing the inverse of the basis matrix.
!----------------------
!     r is an array of dimension N. on output r contains the current
!     value of X. during computation r normally contains the reduced
!     costs used for the selection of the variable to be made BASIC.
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
!     ****** Xmax is a machine dependent constant. Xmax is the
!            largest positive floating point number.
!
           xmax = spmpar(3)
!
!----------------------
iter = 0
icount = 0
mcheck = min0(5,1 + m/15)
z = 0.0
!
!                Check for input errors
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
!     Formation of the ibasis and basis arrays. (If ind = 1
!     then the ibasis array is defined by the user.)
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
!          Calculation of xb and bi when ind = 0
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
!                  Reorder the basis
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
!            REINVERSION of the basis matrix
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
!         Check the accuracy of bi and reset rerr
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
!                 Recalculation of xb
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
!     Find the next vector A(--,JP) to be inserted into
!                       the basis
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
!     Insert the values of the orginal, slack, and surplus
!             variables into r. then terminate.
!
220 do 221 j = 1,n
221 r(j) = 0.0
do i = 1,m
   ki = ibasis(i)
   if (ki .le. n) r(ki) = xb(i)
end do
return
!
!             Completion of the NSTEP = 2 Case
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
!             Completion of the NSTEP = 3 Case
!
250 if (rerr .gt. 1.e-2) go to 251
   ind = 0
   go to 800
251 if (icount .ge. 5) go to 100
ind = 6
go to 800
!
!     If mxiter iterations have not been performed then
!     begin the next iteration. Compute the JP-TH column
!               of bi*A and store it in y.
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
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 1 Case
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
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 2 Case
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
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 3 Case
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
!              Tie breaking procedure
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
!               Transformation of xb
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
!               Transformation of bi
!
510 do 512 j = 1,m
   if (bi(ip,j) .eq. 0.0) go to 512
   const = bi(ip,j)/y(ip)
   do 511 i = 1,m
511 bi(i,j) = bi(i,j) - const*y(i)
   bi(ip,j) = const
512 continue
!
!             Updating ibasis and basis
!
iout = ibasis(ip)
ibasis(ip) = jp
basis(iout) = 0
basis(jp) = 1
if (iout .gt. n) num = num - 1
!
!        Check the accuracy of bi and reset rerr
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
!        The accuracy criteria are not satisfied
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
!       Set up the r array for the NSTEP = 1 Case
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
!       Set up the r array for the NSTEP = 2 Case
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
!      Set up a new r array for the NSTEP = 3 Case
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
!       Update the r array for the NSTEP = 3 Case
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
!               Refine xb and store the result in y
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
!         Check the refinement (NSTEP = 1)
!
860 do 861 i = 1,m
   if (y(i) .ge. 0.0) go to 861
   if (y(i) .lt. -rerrmx) go to 240
   y(i) = 0.0
861 xb(i) = y(i)
go to 630
!
!         Check the refinement (NSTEP = 2)
!
870 do 871 i = 1,m
   if (ibasis(i) .le. n) go to 871
   if (y(i) .gt. rerrmx) go to 240
   y(i) = 0.0
871 xb(i) = y(i)
go to 680
!
!              COMPUTE z  (NSTEP = 3)
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
double precision :: dsum
max = ka*n
mcol = iend*ka
if (iend .eq. 0) go to 100
!
!           Process the first iend columns of A
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
!           Process the remaining columns of A
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
!     Search for the k-TH pivot element (k=ibeg,...,n-1)
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
!              Interchanging rows k and L
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
!       Compute the k-TH row of U (k=ibeg,...,n-1)
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
!      Compute the k-TH column of L (k=ibeg+1,...,n)
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
!           Check the n-TH pivot element
!
190 ncol = max - ka
nn = ncol + n
c = abs(a(nn))
if (c .gt. pmin) go to 200
jp = n
if (c .eq. 0.0) go to 300
!
!          Replace L with the inverse of L
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
!       Solve UX = Y where Y is the inverse of L
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
!                 Column interchanges
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
!                    Error return
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
!     Solution of the assignment problem
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
np1 = n+1
do j=1,n
  c(j) = 0
  lz(j) = 0
  nz(j) = 0
  u(j) = 0
end do
u(np1) = 0
t = 0
! Reduction of the initial cost matrix
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
! Choice of the initial solution
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
! Research of a new assignment
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
! Reduction of the current cost matrix
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
! Assignment of a new row
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
! Error return - Integer overflow occurs
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
integer, intent(inout) :: p(n), w(n)
integer, intent(in) :: k(m)
integer, intent(inout) :: xstar(n), bck, vstar, iwk(num)
real, intent(inout) :: wk(n)
integer :: bb, bl, x, xl
integer :: b, ubb
integer :: f, pbl, q, v
integer :: bs, ps, ws, xs
!
!                    Check the input data
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
!             Reorder the arrays p and w so that
!                p(j)/w(j) .GE. p(j+1)/w(j+1)
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
!                Partition the work space iwk
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
!                     Solve the problem
!
call mkp1 (n, m, p, w, k, bck, xstar, vstar, np1, n5, &
&iwk(bb), iwk(bl), iwk(x), iwk(xl), &
&iwk(b), iwk(ubb), iwk(lx), iwk(lxi), &
&iwk(f), iwk(pbl), iwk(q), iwk(v), &
&iwk(bs), iwk(ps), iwk(ws), iwk(xs), iwk(1))
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
! Step 1 (initialization)
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
! Step 2 (heuristic)
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
! Step 3 (updating)
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
! Step 4 (backtracking)
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
! Particular case (0-1 single knapsack problem)
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
! Subroutine to compute an upper bound  ub  on the best
! final solution which can be obtained from the current
! solution.
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
! Subroutine to compute a feasible solution to the current
! problem. The solution is stored in array  xl , the
! corresponding value in  lb .
!
integer, intent(in) :: bb(m,n)
integer, intent(inout) :: bl(m,np1), xl(m,n), iwk(n5)
integer, intent(in) :: p(n), w(n), q(m), b(np1)
integer, intent(inout) :: pbl(m), v(m)
integer, intent(inout) :: bs(n), ps(np1), ws(np1), xs(n)
integer :: pb, qs, sb, u
!
! Step 1
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
! Step 2
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
! Step 3
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
! Subroutine for parametric computation of the upper bounds.
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
external fun
!
num = 0
ierc = -1
if (ierr .ge. 0) go to 10
!
!     Calculation of the abscissa of convergence.
!
if (mo .eq. 0) go to 5
   call abcon1 (fun,c,num,ierc)
   go to 10
5 call abcon (fun,c,num,ierc)
10 if (ierc .eq. 2) go to 100
!
!     Check if t is too large
!
a = c + 2.0/t
if (a*t .gt. exparg(0)) go to 110
!
!     Calculation of the inverse Laplace transform.
!
call lainv1 (fun,t,c,rerr,aerr,y,error,num1,ier)
num = num + num1
!
!     Report the status of the results.
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
logical :: find
external fun, acond, xcond
!
eta = 0.01
xmin = -1.00358e4
!
!     Calculation of the location of the singularity on the real
!     axis which is farthest to the right. Set this value to x0.
!
call srch(fun, xcond, xmin, eta, x0, num, ierr)
c = x0
if (ierr .eq. 2) go to 20
if (ierr .eq. 3) go to 10
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
if (ierr .eq. 3) c = 0.0
!
!     Termination
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
logical :: cnd
external fun, cond
ierr = 0
!
!     Search for an interval (x1, x2) containing x where
!     x1 .GE. 0.01269
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
!     Search for an interval (x1, x2) containing x where
!     x2 .LE. 0.01269
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
!     Search for x in the interval (x1, x2) by bisection
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
!     Final assembly
!
250 if(cnd) go to 275
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
!     Search for an interval (x1, x2) containing X where
!     x1 .GE. 0.01269
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
!     Search for an interval (x1, x2) containing X where
!     x2 .LE. 0.01269
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
!     Search for X in the interval (x1, x2) by bisection
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
!     Standard termination
!
80 c = x2
   return
!
!     Error return when X cannot be found in (-1.E4, 1.E4)
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
logical, intent(inout) :: cond
external fun, acondf, acondg
!--------------------------
data l /100/, m /400/
data aerr /1.e-30/, rerr /1.e-4/, tol /1.e-4/
!--------------------------
c = x
!
!     Calculation of the integral of acondf from x to infinity.
!
call qagi1 (acondf,fun,y,c,x,1,aerr,rerr,z1,error1,num1,ier1, &
&l,m,n,iwk,wk)
!
!     Calculation of the integral of acondg from 0 to infinity.
!
a = 0.0
call qagi1 (acondg,fun,y,c,a,1,aerr,rerr,z2,error2,num2,ier2, &
&l,m,n,iwk,wk)
num = num1 + num2
ier = max0(ier1, ier2)
!
!     Determination of cond.
!
cond = .false.
if (abs(z1 - z2) .le. tol*amax1(abs(z1),abs(z2))) cond = .true.
!
!     Set ierr and return
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
!        acondf is the function integrated along the x-axis in
!        acond. y is a dummy variable.
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
!        acondg is the function integrated along the line x = c
!        in acond. y is a dummy variable.
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
!     Numerical integration of the imaginary part of the integrand
!     along the line y = epsr.
!
call qagi1 (xcondy,fun,y,c,x,1,aerr,rerr,z,error,num,ierr, &
&l,m,n,iwk,wk)
if (ierr .ne. 0) go to 100
!
!     Determination of cond.
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
!     Error return
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
!     Real part of the integrand in xcond
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
!     Imaginary part of integrand in xcond
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
complex :: rex(52), cres, res3la(3)
integer :: i
integer, intent(out) :: ier
integer :: k, kc, kk, ks, m, nex, nres
integer, intent(out) :: num
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
data max/500/
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
if (t.le.0.0e+00) go to 999
!
!   PID16 is equal to pi/16
!
pid16 = atan(1.0e+00)/4.0e+00
!
!   Computation of the elements of the array si
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
!   Initialization of the summation of the Durbin formula.
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
!   Main loop for the summation
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
!   Extrapolation using the epsilon algorithm
!
  if(nex.ge.3) call cqext(nex,rex,cres,esterr,res3la,nres)
  if(nres.lt.4) go to 40
!
!   Computation of intermediate result and estimate of the
!   absolute error
!
  result = real(cres)
  result = result * bb
  esterr = esterr * bb
  if (esterr.lt.amax1(epsab,epsr1*abs(result)).and.abs(r*bb- &
&result).lt.5.0e-01*abs(result)) go to 999
40 continue
!
!   Set error flag in the case that the number of terms in the
!   summation is equal to max
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
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = cabs(e1-e0)+cabs(e2-e1)
!
  result = res
  abserr = err2+err3
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
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
!
  if(epsinf.gt.1.0e-04) go to 30
20 n = i+i-1
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
  k1 = k1-2
  error = err2+abs(c1-real(res))+err3
  if(error.gt.abserr) go to 40
  abserr = error
  result = res
40 continue
!
!           Shift the table.
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
!           Compute error estimate
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
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f, phi
!
!         Check validity of limit and lenw.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for qagie1.
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
logical :: extrap, noext
!
dimension iord(limit)
!
external f, phi
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
if (epsabs .lt. 0.0 .or. epsrel .lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach, 0.5e-14)
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
if (inf .eq. 2) boun = 0.0
call qk15i1 (f, phi, y, c, boun, inf, 0.0, 1.0, result, abserr, &
&defabs, resabs, epmach, uflow)
!
!           Test on accuracy
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
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with NRMAX-TH largest
!           error estimate.
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
!           Improve previous approximations to integral
!           and error and test for accuracy.
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
!           Test for roundoff error and eventually
!           set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of
!           subintervals equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.
!
  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
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
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with NRMAX-TH largest error estimate (to be
!           bisected next).
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
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if(abs(blist(maxerr)-alist(maxerr)).gt.small) go to 90
  extrap = .true.
  nrmax = 2
40 if(ierro.eq.3.or.erlarg.le.ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (ERLARG) and perform
!           extrapolation.
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
!           Perform extrapolation.
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
!            Prepare bisection of the smallest interval.
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
!           Set final result and error estimate.
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
!           Test on divergence
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
&defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
&.or. errsum .gt. abs(area)) ier = 6
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
real :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
!
external f, phi
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
dinf = min0(1,inf)
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1,y,c,phi)
if (inf .eq. 2) fval1 = fval1 + f(-tabsc1,y,c,phi)
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
!     The complex array c of dimension n is interpreted by the code
!     as a real array of dimension 2*n. if this association is not
!     permitted by the Fortran being used, then the user may use the
!     SUBROUTINE fft1.
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
!     Let ntot denote the product of n(1),...,n(ndim). The complex
!     array c of dimension ntot is interpreted by the routine as
!     a real array of dimension 2*ntot. If this association is not
!     permitted by the Fortran being used, then the user may use
!     the subroutine mfft1.
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
maxn=15
maxf=23
maxp=209
!  Set the following constants
!     rad=2.0*pi
!     s72=sin(rad/5.0)
!     c72=cos(rad/5.0)
!     s120=sqrt(0.75)
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
!  Determine the factors of n
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
!  Compute Fourier transform
100 sd=radf/float(kspan)
cd=2.0*sin(sd)**2
sd=sin(sd+sd)
kk=1
i=i+1
if(nfac(i) .ne. 2) go to 400
!  Transform for factor of 2 (including rotation factor)
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
!  The following three statements compensate for truncation error.
!    If rounded arithmetic is used then one may substitute
!     c1=ak
c1=1.5-0.5*(ak*ak+s1*s1)
s1=c1*s1
c1=c1*ak
kk=kk+jc
if(kk .lt. k2) go to 230
k1=k1+inc+inc
kk=(k1-kspan)/2+jc
if(kk .le. jc+jc) go to 220
go to 100
!  Transform for factor of 3 (optional code)
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
!  Transform for factor of 4
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
!  The following three statements compensate for truncation error.
!    If rounded arithmetic is used then one may substitute
!     c1=c2
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
!  Transform for factor of 5 (optional code)
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
!  Transform for odd factors
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
!  Multiply by rotation factor (except for factors of 2 and 4)
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
!  The following three statements compensate for truncation
!    error.  If rounded arithmetic is used then they may
!    be deleted.
c1=1.5-0.5*(c2*c2+s1*s1)
s1=c1*s1
c2=c1*c2
kk=kk-kspnn+jc
if(kk .le. kspan) go to 720
kk=kk-kspan+jc+inc
if(kk .le. jc+jc) go to 710
go to 100
!  Permute the results to normal order---done in two stages
!  permutation for square factors of n
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
!  Permutation for single-variate transform (optional code)
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
!  Permutation for multivariate transform
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
!  Permutation for square-free factors of n
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
!  Determine the permutation cycles of length greater than 1
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
!  Reorder A and b, following the permutation cycles
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
!  Error finish - There is an input error
1000 ierr=1
return
1001 ierr=2
return
1002 ierr=3
return
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
