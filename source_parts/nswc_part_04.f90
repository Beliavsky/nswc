subroutine orthos(au, ma, aa, na, ar)
!! <!-- nswc-ford:begin ORTHOS -->
!! Reference for `orthos`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for orthonormal polynomial synthesis
!!
!!      au = COORDINATE ARGUMENTS    (N ARRAY)
!!      ma = Number of columns       (m)
!!      aa = Matrix of polynomials   (NXM array)
!!      na = Number of rows          (N)
!!      ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ma, na
real, intent(inout) :: aa(*), ar(*)
real, intent(in) :: au(*)
!     beginning of local variable declarations
integer :: i, j, k, l, m
real :: rm, rn, sm, sn
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial synthesis
!     ******************************************************************
!     au = COORDINATE ARGUMENTS    (N ARRAY)
!     ma = Number of columns       (m)
!     aa = Matrix of polynomials   (NXM array)
!     na = Number of rows          (N)
!     ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
sn = na
rn = sqrt(sn)
do i = 1,na
   aa(i) = 1.0/rn
end do
if (ma == 1) return
sm = 0.0
do i = 1,na
   sm = sm + au(i)
end do
ar(2) = sm/sn
sm = 0.0
l = na
do i = 1,na
   l = l + 1
   aa(l) = au(i) - ar(2)
   sm = sm + aa(l)*aa(l)
end do
rm = sqrt(sm)
l = na
do i = 1,na
   l = l + 1
   aa(l) = aa(l)/rm
end do
sm = 0.0
l = na
do i = 1,na
   l = l + 1
   sm = sm + au(i)*aa(l)
end do
ar(1) = sm/rn
if (ma == 2) return
do m = 3,ma
   sm = 0.0
   k = (m - 2)*na
   do i = 1,na
      k = k + 1
      sm = sm + au(i)*aa(k)*aa(k)
   end do
   ar(2*m - 2) = sm
   sm = 0.0
   j = (m - 3)*na
   do i = 1,na
      j = j + 1
      k = j + na
      l = k + na
      aa(l) = au(i)*aa(k) - ar(2*m - 2)*aa(k) - ar(2*m - 5)*aa(j)
      sm = sm + aa(l)*aa(l)
   end do
   rm = sqrt(sm)
   l = (m - 1)*na
   do i = 1,na
      l = l + 1
      aa(l) = aa(l)/rm
   end do
   sm = 0.0
   k = (m - 2)*na
   do i = 1,na
      k = k + 1
      l = k + na
      sm = sm + au(i)*aa(k)*aa(l)
   end do
   ar(2*m - 3) = sm
end do
end subroutine orthos

subroutine orthov(mo, na, au, ar, nf, ff, df, sf)
!! <!-- nswc-ford:begin ORTHOV -->
!! Reference for `orthov`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for orthonormal polynomial evaluation
!!
!!      mo = Mode of operation
!!      na = Number of coordinates
!!      au = Argument of functions
!!      ar = RECURRENCE COEFFICIENTS                (2*M-2 ARRAY)
!!      nf = Number of functions                    (M)
!!      ff = ORTHONORMAL FUNCTIONS                  (M-ARRAY)
!!      df = FIRST DERIVATIVES                      (M-ARRAY)
!!      sf = SECOND DERIVATIVES                     (M-ARRAY)
!!      call orthov (0, na, au, ar, nf, ff)         for functions
!!      call orthov (1, na, au, ar, nf, ff, df)     for first derivatives
!!      call orthov (2, na, au, ar, nf, ff, df, sf) for second derivatives
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: mo, na, nf
real, intent(in) :: ar(*)
real, intent(in) :: au
real, intent(inout) :: df(*), ff(*), sf(*)
!     beginning of local variable declarations
integer :: k, l
real :: rn, sn
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial evaluation
!     ******************************************************************
!     mo = Mode of operation
!     na = Number of coordinates
!     au = Argument of functions
!     ar = RECURRENCE COEFFICIENTS                (2*M-2 ARRAY)
!     nf = Number of functions                    (M)
!     ff = ORTHONORMAL FUNCTIONS                  (M-ARRAY)
!     df = FIRST DERIVATIVES                      (M-ARRAY)
!     sf = SECOND DERIVATIVES                     (M-ARRAY)
!     call orthov (0, na, au, ar, nf, ff)         for functions
!     call orthov (1, na, au, ar, nf, ff, df)     for first derivatives
!     call orthov (2, na, au, ar, nf, ff, df, sf) for second derivatives
sn = na
rn = sqrt(sn)
ff(1) = 1.0/rn
if (nf <= 1) go to 003
ff(2) = (au - ar(2))*ff(1)/ar(1)
if (nf == 2) go to 003
l = 2
do k = 3,nf
   l = l + 2
   ff(k) = ((au - ar(l))*ff(k - 1) - ar(l - 3)*ff(k - 2))/ar(l - 1)
end do
003 if (mo <= 0) return
df(1) = 0.0
if (nf <= 1) go to 005
df(2) = ff(1)/ar(1)
if (nf == 2) go to 005
l = 2
do k = 3,nf
   l = l + 2
   df(k) = (ff(k - 1) + (au - ar(l))*df(k - 1) - ar(l - 3)*df(k - 2))/ar(l - 1)
end do
005 if (mo == 1) return
sf(1) = 0.0
if (nf <= 1) go to 007
sf(2) = 0.0
if (nf == 2) go to 007
l = 2
do k = 3,nf
   l = l + 2
   sf(k) = (2.0*df(k - 1) + (au - ar(l))*sf(k - 1) - ar(l - 3)*sf(k - 2))/ar(l - 1)
end do
007 return
end subroutine orthov

subroutine orthox(na, ar, nc, ac)
!! <!-- nswc-ford:begin ORTHOX -->
!! Reference for `orthox`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for orthonormal polynomial expansion
!!
!!      na = Number of arguments     (n)
!!      ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!!      nc = Number of coefficients  (m)
!!      ac = POLYNOMIAL COEFFICIENTS (m*m ARRAY)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: na, nc
real, intent(inout) :: ac(*)
real, intent(in) :: ar(*)
!     beginning of local variable declarations
integer :: j, k, l, m, n
real :: rn, sn, tm
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial expansion
!     ******************************************************************
!     na = Number of arguments     (n)
!     ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!     nc = Number of coefficients  (m)
!     ac = POLYNOMIAL COEFFICIENTS (m*m ARRAY)
do n = 1,nc
   ac(n) = 0.0
end do
sn = na
rn = sqrt(sn)
ac(1) = 1.0/rn
if (nc == 1) return
tm = 0.0
l = nc
do n = 1,nc
   l = l + 1
   ac(l) = (tm - ar(2)*ac(n))/ar(1)
   tm = ac(n)
end do
if (nc == 2) return
do m = 3,nc
   tm = 0.0
   j = (m - 3)*nc
   do n = 1,nc
      j = j + 1
      k = j + nc
      l = k + nc
      ac(l) = (tm - ar(2*m - 2)*ac(k) - ar(2*m - 5)*ac(j))/ar(2*m - 3)
      tm = ac(k)
   end do
end do
end subroutine orthox

real function zeroin(f, ax, bx, aerr, rerr)
!! <!-- nswc-ford:begin ZEROIN -->
!! Reference for `zeroin`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          Finding a zero of the function f(X) in the interval (ax,bx)
!!
!!   Input...
!!   f      FUNCTION SUBPROGRAM WHICH EVALUATES f(X) FOR ANY X IN THE
!!          closed interval (ax,bx). It is assumed that f is continuous,
!!          and that f(ax) and f(bx) have different signs.
!!   ax     LEFT ENDPOINT OF THE INTERVAL
!!   bx     RIGHT ENDPOINT OF THE INTERVAL
!!   aerr   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
!!   rerr   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
!!   output...
!!          abcissa approximating a zero of f in the interval (ax,bx)
!!
!!   zeroin is a slightly modified translation of the Algol procedure
!!   zero given by richard Brent in algorithms for minimization without
!!   derivatives, Prentice-Hall, inc. (1973).
!!
!!   Compute eps, the relative machine precision
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!         Finding a zero of the function f(X) in the interval (ax,bx)
!                       ------------------------
!  Input...
!  f      FUNCTION SUBPROGRAM WHICH EVALUATES f(X) FOR ANY X IN THE
!         closed interval (ax,bx). It is assumed that f is continuous,
!         and that f(ax) and f(bx) have different signs.
!  ax     LEFT ENDPOINT OF THE INTERVAL
!  bx     RIGHT ENDPOINT OF THE INTERVAL
!  aerr   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
!  rerr   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
!  output...
!         abcissa approximating a zero of f in the interval (ax,bx)
!-----------------------------------------------------------------------
!  zeroin is a slightly modified translation of the Algol procedure
!  zero given by richard Brent in algorithms for minimization without
!  derivatives, Prentice-Hall, inc. (1973).
!-----------------------------------------------------------------------
real :: f
real, intent(in) :: ax, bx, aerr, rerr
external f
!     beginning of local variable declarations
real :: a, b, c, d, e, eps, fa, fb, fc, tol, xm, p, q, r, s, atol, &
   & rtol
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!  Compute eps, the relative machine precision
eps = spmpar(1)
! Initialization
a = ax
b = bx
fa = f(a)
fb = f(b)
atol = 0.5*aerr
rtol = max(0.5*rerr,2.0*eps)
! Begin step
10 c = a
fc = fa
d = b - a
e = d
20 if (abs(fc) >= abs(fb)) go to 40
a = b
b = c
c = a
fa = fb
fb = fc
fc = fa
! Convergence test
40 tol = rtol*max(abs(b),abs(c)) + atol
xm = 0.5*(c - b)
if (abs(xm) <= tol) go to 90
if (fb == 0.0) go to 90
! Is bisection necessary
if (abs(e) < tol) go to 70
if (abs(fa) <= abs(fb)) go to 70
! Is quadratic interpolation possible
if (a /= c) go to 50
! Linear interpolation
s = fb/fc
p = (c - b)*s
q = 1.0 - s
go to 60
! Inverse quadratic interpolation
50 q = fa/fc
r = fb/fc
s = fb/fa
p = s*((c - b)*q*(q - r) - (b - a)*(r - 1.0))
q = (q - 1.0)*(r - 1.0)*(s - 1.0)
! Adjust signs
60 if (p > 0.0) q = -q
p = abs(p)
! Is interpolation acceptable
if (2.0*p >= (3.0*xm*q - abs(tol*q))) go to 70
if (p >= abs(0.5*e*q)) go to 70
e = d
d = p/q
go to 80
! Bisection
70 d = xm
e = d
! Complete step
80 a = b
fa = fb
if (abs(d) > tol) b = b + d
if (abs(d) <= tol) b = b + sign(tol,xm)
fb = f(b)
if ((fb*(fc/abs(fc))) > 0.0) go to 10
go to 20
! Done
90 zeroin = b
end function zeroin

double precision function dzero(f, ax, bx, aerr, rerr)
!! <!-- nswc-ford:begin DZERO -->
!! Reference for `dzero`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          Finding a zero of the function f(X) in the interval (ax,bx)
!!
!!   Input...
!!   f      FUNCTION SUBPROGRAM WHICH EVALUATES f(X) FOR ANY X IN THE
!!          closed interval (ax,bx). It is assumed that f is continuous,
!!          and that f(ax) and f(bx) have different signs.
!!   ax     LEFT ENDPOINT OF THE INTERVAL
!!   bx     RIGHT ENDPOINT OF THE INTERVAL
!!   aerr   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
!!   rerr   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
!!   output...
!!          abcissa approximating a zero of f in the interval (ax,bx)
!!
!!   dzero is a slightly modified translation of the Algol procedure
!!   zero given by richard Brent in algorithms for minimization without
!!   derivatives, Prentice-Hall, inc. (1973).
!!
!!   Compute eps, the relative machine precision
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!         Finding a zero of the function f(X) in the interval (ax,bx)
!                       ------------------------
!  Input...
!  f      FUNCTION SUBPROGRAM WHICH EVALUATES f(X) FOR ANY X IN THE
!         closed interval (ax,bx). It is assumed that f is continuous,
!         and that f(ax) and f(bx) have different signs.
!  ax     LEFT ENDPOINT OF THE INTERVAL
!  bx     RIGHT ENDPOINT OF THE INTERVAL
!  aerr   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
!  rerr   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
!  output...
!         abcissa approximating a zero of f in the interval (ax,bx)
!-----------------------------------------------------------------------
!  dzero is a slightly modified translation of the Algol procedure
!  zero given by richard Brent in algorithms for minimization without
!  derivatives, Prentice-Hall, inc. (1973).
!-----------------------------------------------------------------------
double precision :: f
double precision, intent(in) :: ax, bx, aerr, rerr
external f
!     beginning of local variable declarations
double precision :: a, b, c, d, e, eps, fa, fb, fc, tol, xm, p, q, &
   & r, s, atol, rtol
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!  Compute eps, the relative machine precision
eps = dpmpar(1)
! Initialization
a = ax
b = bx
fa = f(a)
fb = f(b)
atol = 0.5d0*aerr
rtol = max(0.5d0*rerr,2.d0*eps)
! Begin step
10 c = a
fc = fa
d = b - a
e = d
20 if (abs(fc) >= abs(fb)) go to 40
a = b
b = c
c = a
fa = fb
fb = fc
fc = fa
! Convergence test
40 tol = rtol*max(abs(b),abs(c)) + atol
xm = 0.5d0*(c - b)
if (abs(xm) <= tol) go to 90
if (fb == 0.d0) go to 90
! Is bisection necessary
if (abs(e) < tol) go to 70
if (abs(fa) <= abs(fb)) go to 70
! Is quadratic interpolation possible
if (a /= c) go to 50
! Linear interpolation
s = fb/fc
p = (c - b)*s
q = 1.d0 - s
go to 60
! Inverse quadratic interpolation
50 q = fa/fc
r = fb/fc
s = fb/fa
p = s*((c - b)*q*(q - r) - (b - a)*(r - 1.d0))
q = (q - 1.d0)*(r - 1.d0)*(s - 1.d0)
! Adjust signs
60 if (p > 0.d0) q = -q
p = abs(p)
! Is interpolation acceptable
if (2.d0*p >= (3.d0*xm*q - abs(tol*q))) go to 70
if (p >= abs(0.5d0*e*q)) go to 70
e = d
d = p/q
go to 80
! Bisection
70 d = xm
e = d
! Complete step
80 a = b
fa = fb
if (abs(d) > tol) b = b + d
if (abs(d) <= tol) b = b + sign(tol,xm)
fb = f(b)
if ((fb*(fc/abs(fc))) > 0.d0) go to 10
go to 20
! Done
90 dzero = b
end function dzero

subroutine hbrd(fcn,n,x,fvec,epsfcn,tol,info,wa,lwa)
!! <!-- nswc-ford:begin HBRD -->
!! Reference for `hbrd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      SUBROUTINE hbrd
!!        the purpose of hbrd is to find a zero of a system of
!!      n nonlinear functions in n variables by a modification
!!      of the Powell hybrid method. This is done by using the
!!      more general nonlinear equation solver hybrd. The user
!!      must provide a subroutine which calculates the functions.
!!      The Jacobian is then calculated by a forward-difference
!!      approximation.
!!      The subroutine statement is
!!        subroutine hbrd(fcn,n,x,fvec,epsfcn,tol,info,wa,lwa)
!!      where
!!        FCN is the name of the user-supplied subroutine which
!!          calculates the functions. FCN must be declared
!!          in an external statement in the user calling
!!          program, and should be written as follows.
!!          subroutine fcn(n,x,fvec,iflag)
!!          integer n,iflag
!!          real x(n),fvec(n)
!!
!!          Calculate the functions at x and
!!          RETURN THIS VECTOR IN fvec.
!!
!!          return
!!          end
!!          the value of IFLAG should not be changed by FCN unless
!!          the user wants to terminate the execution of hbrd.
!!          In this case set IFLAG to a negative integer.
!!        n is a positive integer input variable SET to the number
!!          of functions and variables.
!!        x is an array of length n. on input x must contain
!!          an initial estimate of the solution vector. On output x
!!          contains the final estimate of the solution vector.
!!        fvec is an output array of length n which contains
!!          the functions evaluated at the output x.
!!        epsfcn is an input variable used in determining a suitable
!!          step length for the forward-difference approximation. This
!!          approximation assumes that the relative errors in the
!!          functions are of the order of epsfcn. If epsfcn is less
!!          than the machine precision, it is assumed that the relative
!!          errors in the functions are of the order of the machine
!!          precision.
!!        tol is a nonnegative input variable. Termination occurs
!!          when the algorithm estimates that the relative error
!!          between x and the solution is at most tol.
!!        Info is an integer output variable. If the user has
!!          terminated execution, info is set to the (negative)
!!          value of IFLAG. See description of FCN. Otherwise,
!!          info is set as follows.
!!          info = 0   Improper input parameters.
!!          info = 1   Algorithm estimates that the relative error
!!                     between x and the solution is at most tol.
!!          info = 2   Number of calls to FCN has reached or exceeded
!!                     200*(n+1).
!!          info = 3   tol is too small. No further improvement in
!!                     the approximate solution x is possible.
!!          info = 4   Iteration is not making good progress.
!!        wa is a work array of length lwa.
!!        lwa is a positive integer input variable NOT less than
!!          (n*(3*n+13))/2.
!!      Subprograms called
!!        user-supplied ...... FCN
!!        MINPACK-supplied ... hybrd
!!      Argonne National Laboratory. MINPACK project. March 1980.
!!      Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer :: n
integer, intent(out) :: info
integer, intent(in) :: lwa
real, intent(in) :: epsfcn, tol
real, intent(inout) :: x(n), fvec(n), wa(lwa)
external fcn
!     beginning of local variable declarations
integer :: index, j, lr, maxfev, ml, mode, mu, nfev, nprint
real :: xtol
real, parameter :: factor = 1.0e2
real, parameter :: one = 1.0e0
real, parameter :: zero = 0.0e0
!     **********
!     SUBROUTINE hbrd
!       the purpose of hbrd is to find a zero of a system of
!     n nonlinear functions in n variables by a modification
!     of the Powell hybrid method. This is done by using the
!     more general nonlinear equation solver hybrd. The user
!     must provide a subroutine which calculates the functions.
!     The Jacobian is then calculated by a forward-difference
!     approximation.
!     The subroutine statement is
!       subroutine hbrd(fcn,n,x,fvec,epsfcn,tol,info,wa,lwa)
!     where
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!         subroutine fcn(n,x,fvec,iflag)
!         integer n,iflag
!         real x(n),fvec(n)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ---------
!         return
!         end
!         the value of IFLAG should not be changed by FCN unless
!         the user wants to terminate the execution of hbrd.
!         In this case set IFLAG to a negative integer.
!       n is a positive integer input variable SET to the number
!         of functions and variables.
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!       fvec is an output array of length n which contains
!         the functions evaluated at the output x.
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!       tol is a nonnegative input variable. Termination occurs
!         when the algorithm estimates that the relative error
!         between x and the solution is at most tol.
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of IFLAG. See description of FCN. Otherwise,
!         info is set as follows.
!         info = 0   Improper input parameters.
!         info = 1   Algorithm estimates that the relative error
!                    between x and the solution is at most tol.
!         info = 2   Number of calls to FCN has reached or exceeded
!                    200*(n+1).
!         info = 3   tol is too small. No further improvement in
!                    the approximate solution x is possible.
!         info = 4   Iteration is not making good progress.
!       wa is a work array of length lwa.
!       lwa is a positive integer input variable NOT less than
!         (n*(3*n+13))/2.
!     Subprograms called
!       user-supplied ...... FCN
!       MINPACK-supplied ... hybrd
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!     **********
info = 0
!     Check the input parameters for errors.
if (n <= 0 .or. epsfcn < zero .or. tol < zero .or. &
   & lwa < (n*(3*n + 13))/2) go to 20
!     CALL hybrd.
maxfev = 200*(n + 1)
xtol = tol
ml = n - 1
mu = n - 1
mode = 2
do j = 1, n
   wa(j) = one
end do
nprint = 0
lr = (n*(n + 1))/2
index = 6*n + lr
call hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,wa(1),mode, &
   & factor,nprint,info,nfev,wa(index + 1),n,wa(6*n + 1),lr, &
   & wa(n + 1),wa(2*n + 1),wa(3*n + 1),wa(4*n + 1),wa(5*n + 1))
if (info == 5) info = 4
20 continue
!     Last card of subroutine hbrd.
end subroutine hbrd

subroutine hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,diag, &
   & mode,factor,nprint,info,nfev,fjac,ldfjac,r,lr, &
   & qtf,wa1,wa2,wa3,wa4)
!! <!-- nswc-ford:begin HYBRD -->
!! Reference for `hybrd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      SUBROUTINE hybrd
!!      the purpose of hybrd is to find a zero of a system of
!!      n nonlinear functions in n variables by a modification
!!      of the Powell hybrid method. The user must provide A
!!      subroutine which calculates the functions. The Jacobian is
!!      then calculated by a forward-difference approximation.
!!      The subroutine statement is
!!        subroutine hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,
!!                         diag,mode,factor,nprint,info,nfev,fjac,
!!                         ldfjac,R,lr,QTF,WA1,WA2,WA3,wa4)
!!      where
!!        FCN is the name of the user-supplied subroutine which
!!          calculates the functions. FCN must be declared
!!          in an external statement in the user calling
!!          program, and should be written as follows.
!!          subroutine fcn(n,x,fvec,iflag)
!!          integer n,iflag
!!          real x(n),fvec(n)
!!
!!          Calculate the functions at x and
!!          RETURN THIS VECTOR IN fvec.
!!
!!          return
!!          end
!!          the value of iflag should not be changed by FCN unless
!!          the user wants to terminate execution of hybrd.
!!          In this case set iflag to a negative integer.
!!        n is a positive integer input variable SET to the number
!!          of functions and variables.
!!        x is an array of length n. on input x must contain
!!          an initial estimate of the solution vector. On output x
!!          contains the final estimate of the solution vector.
!!        fvec is an output array of length n which contains
!!          the functions evaluated at the output x.
!!        xtol is a nonnegative input variable. Termination
!!          occurs when the relative error between two consecutive
!!          iterates is at most xtol.
!!        maxfev is a positive integer input variable. Termination
!!          occurs when the number of calls to FCN is at least maxfev
!!          by the end of an iteration.
!!        ml is a nonnegative integer input variable which specifies
!!          the number of subdiagonals within the band of the
!!          Jacobian matrix. If the Jacobian is not banded, set
!!          ml to at least n - 1.
!!        mu is a nonnegative integer input variable which specifies
!!          the number of superdiagonals within the band of the
!!          Jacobian matrix. If the Jacobian is not banded, set
!!          mu to at least n - 1.
!!        epsfcn is an input variable used in determining a suitable
!!          step length for the forward-difference approximation. This
!!          approximation assumes that the relative errors in the
!!          functions are of the order of epsfcn. If epsfcn is less
!!          than the machine precision, it is assumed that the relative
!!          errors in the functions are of the order of the machine
!!          precision.
!!        Diag is an array of length n. if mode = 1 (see
!!          below), diag is internally set. If mode = 2, diag
!!          must contain positive entries that serve as
!!          multiplicative scale factors for the variables.
!!        Mode is an integer input variable. If mode = 1, the
!!          variables will be scaled internally. If mode = 2,
!!          the scaling is specified by the input diag. Other
!!          values of mode are equivalent to mode = 1.
!!        Factor is a positive input variable used in determining the
!!          initial step bound. This bound is set to the product of
!!          factor and the Euclidean norm of diag*x if nonzero, or else
!!          to factor itself. In most cases factor should lie in the
!!          interval (.1,100.). 100. Is a generally recommended value.
!!        nprint is an integer input variable that enables controlled
!!          printing of iterates if it is positive. In this case,
!!          FCN is called with iflag = 0 At the beginning of the first
!!          iteration and every nprint iterations thereafter and
!!          immediately prior to return, with x and fvec available
!!          for printing. If nprint is not positive, no special calls
!!          of FCN with iflag = 0 Are made.
!!        Info is an integer output variable. If the user has
!!          terminated execution, info is set to the (negative)
!!          value of iflag. See description of FCN. Otherwise,
!!          info is set as follows.
!!          info = 0   Improper input parameters.
!!          info = 1   Relative error between two consecutive iterates
!!                     is at most xtol.
!!          info = 2   Number of calls to FCN has reached or exceeded
!!                     maxfev.
!!          info = 3   xtol is too small. No further improvement in
!!                     the approximate solution x is possible.
!!          info = 4   Iteration is not making good progress, as
!!                     measured by the improvement from the last
!!                     five Jacobian evaluations.
!!          info = 5   Iteration is not making good progress, as
!!                     measured by the improvement from the last
!!                     ten iterations.
!!        nfev is an integer output variable SET to the number of
!!          calls to FCN.
!!        fjac is an output n by n array which contains the
!!          orthogonal matrix Q produced by the QR factorization
!!          of the final approximate Jacobian.
!!        ldfjac is a positive integer input variable NOT less than n
!!          which specifies the leading dimension of the array fjac.
!!        R is an output array of length lr which contains the
!!          upper triangular matrix produced by the QR factorization
!!          of the final approximate Jacobian, stored rowwise.
!!        lr is a positive integer input variable NOT less than
!!          (n*(n+1))/2.
!!        QTF is an output array of length n which contains
!!          the vector (Q transpose)*fvec.
!!        WA1, WA2, WA3, and wa4 are work arrays of length n.
!!      Subprograms called
!!        user-supplied ...... FCN
!!        MINPACK-supplied ... dogleg,spmpar,enorm,fdjac1,
!!                             qform,qrfac,r1mpyq,r1updt
!!        Fortran-supplied ... abs,AMAX1,AMIN1,MIN0,mod
!!      Argonne National Laboratory. MINPACK project. March 1980.
!!      Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!!
!!      epsmch is the machine precision.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer :: n
integer, intent(in) :: maxfev, ml, mu, mode, nprint
integer, intent(out) :: info, nfev
integer, intent(in) :: ldfjac, lr
real, intent(in) :: xtol, epsfcn, factor
real, intent(inout) :: x(n), fvec(n), diag(n), fjac(ldfjac,n), &
   & r(lr), qtf(n), wa1(n), wa2(n), wa3(n)
real :: wa4(n)
external fcn
!     beginning of local variable declarations
integer :: i, iflag, iter, j, jm1, l, msum, ncfail, ncsuc, nslow1, nslow2, iwa(1)
logical :: jeval, sing
real :: actred, delta, epsmch, fnorm, fnorm1, pnorm, prered, ratio, sum, temp, xnorm
real :: enorm
real, parameter :: one = 1.0e0
real, parameter :: p1 = 1.0e-1
real, parameter :: p5 = 5.0e-1
real, parameter :: p001 = 1.0e-3
real, parameter :: p0001 = 1.0e-4
real, parameter :: zero = 0.0e0
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     **********
!     SUBROUTINE hybrd
!     the purpose of hybrd is to find a zero of a system of
!     n nonlinear functions in n variables by a modification
!     of the Powell hybrid method. The user must provide A
!     subroutine which calculates the functions. The Jacobian is
!     then calculated by a forward-difference approximation.
!     The subroutine statement is
!       subroutine hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,
!                        diag,mode,factor,nprint,info,nfev,fjac,
!                        ldfjac,R,lr,QTF,WA1,WA2,WA3,wa4)
!     where
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!         subroutine fcn(n,x,fvec,iflag)
!         integer n,iflag
!         real x(n),fvec(n)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ---------
!         return
!         end
!         the value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of hybrd.
!         In this case set iflag to a negative integer.
!       n is a positive integer input variable SET to the number
!         of functions and variables.
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!       fvec is an output array of length n which contains
!         the functions evaluated at the output x.
!       xtol is a nonnegative input variable. Termination
!         occurs when the relative error between two consecutive
!         iterates is at most xtol.
!       maxfev is a positive integer input variable. Termination
!         occurs when the number of calls to FCN is at least maxfev
!         by the end of an iteration.
!       ml is a nonnegative integer input variable which specifies
!         the number of subdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         ml to at least n - 1.
!       mu is a nonnegative integer input variable which specifies
!         the number of superdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         mu to at least n - 1.
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!       Diag is an array of length n. if mode = 1 (see
!         below), diag is internally set. If mode = 2, diag
!         must contain positive entries that serve as
!         multiplicative scale factors for the variables.
!       Mode is an integer input variable. If mode = 1, the
!         variables will be scaled internally. If mode = 2,
!         the scaling is specified by the input diag. Other
!         values of mode are equivalent to mode = 1.
!       Factor is a positive input variable used in determining the
!         initial step bound. This bound is set to the product of
!         factor and the Euclidean norm of diag*x if nonzero, or else
!         to factor itself. In most cases factor should lie in the
!         interval (.1,100.). 100. Is a generally recommended value.
!       nprint is an integer input variable that enables controlled
!         printing of iterates if it is positive. In this case,
!         FCN is called with iflag = 0 At the beginning of the first
!         iteration and every nprint iterations thereafter and
!         immediately prior to return, with x and fvec available
!         for printing. If nprint is not positive, no special calls
!         of FCN with iflag = 0 Are made.
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of iflag. See description of FCN. Otherwise,
!         info is set as follows.
!         info = 0   Improper input parameters.
!         info = 1   Relative error between two consecutive iterates
!                    is at most xtol.
!         info = 2   Number of calls to FCN has reached or exceeded
!                    maxfev.
!         info = 3   xtol is too small. No further improvement in
!                    the approximate solution x is possible.
!         info = 4   Iteration is not making good progress, as
!                    measured by the improvement from the last
!                    five Jacobian evaluations.
!         info = 5   Iteration is not making good progress, as
!                    measured by the improvement from the last
!                    ten iterations.
!       nfev is an integer output variable SET to the number of
!         calls to FCN.
!       fjac is an output n by n array which contains the
!         orthogonal matrix Q produced by the QR factorization
!         of the final approximate Jacobian.
!       ldfjac is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array fjac.
!       R is an output array of length lr which contains the
!         upper triangular matrix produced by the QR factorization
!         of the final approximate Jacobian, stored rowwise.
!       lr is a positive integer input variable NOT less than
!         (n*(n+1))/2.
!       QTF is an output array of length n which contains
!         the vector (Q transpose)*fvec.
!       WA1, WA2, WA3, and wa4 are work arrays of length n.
!     Subprograms called
!       user-supplied ...... FCN
!       MINPACK-supplied ... dogleg,spmpar,enorm,fdjac1,
!                            qform,qrfac,r1mpyq,r1updt
!       Fortran-supplied ... abs,AMAX1,AMIN1,MIN0,mod
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!     **********
!     epsmch is the machine precision.
epsmch = spmpar(1)
info = 0
iflag = 0
nfev = 0
!     Check the input parameters for errors.
if (n <= 0 .or. xtol < zero .or. maxfev <= 0 &
   & .or. ml < 0 .or. mu < 0 .or. factor <= zero &
   & .or. ldfjac < n .or. lr < (n*(n + 1))/2) go to 300
if (mode /= 2) go to 20
do j = 1, n
   if (diag(j) <= zero) go to 300
end do
20 continue
!     Evaluate the function at the starting point
!     and calculate its norm.
iflag = 1
call fcn(n,x,fvec,iflag)
nfev = 1
if (iflag < 0) go to 300
fnorm = enorm(n,fvec)
!     Determine the number of calls to FCN needed to compute
!     the Jacobian matrix.
msum = min(ml + mu + 1,n)
!     Initialize iteration counter and monitors.
iter = 1
ncsuc = 0
ncfail = 0
nslow1 = 0
nslow2 = 0
!     Beginning of the outer loop.
30 continue
jeval = .true.
!        Calculate the Jacobian matrix.
iflag = 2
call fdjac1(fcn,n,x,fvec,fjac,ldfjac,iflag,ml,mu,epsfcn,wa1, &
   & wa2)
nfev = nfev + msum
if (iflag < 0) go to 300
!        Compute the QR factorization of the Jacobian.
call qrfac(n,n,fjac,ldfjac,.false.,iwa,1,wa1,wa2,wa3)
!        On the first iteration and if mode is 1, scale according
!        to the norms of the columns of the initial Jacobian.
if (iter /= 1) go to 70
if (mode == 2) go to 50
do j = 1, n
   diag(j) = wa2(j)
   if (wa2(j) == zero) diag(j) = one
end do
50 continue
!        On the first iteration, calculate the norm of the scaled x
!        and initialize the step bound delta.
do j = 1, n
   wa3(j) = diag(j)*x(j)
end do
xnorm = enorm(n,wa3)
delta = factor*xnorm
if (delta == zero) delta = factor
70 continue
!        Form (Q transpose)*fvec and store in QTF.
do i = 1, n
   qtf(i) = fvec(i)
end do
do j = 1, n
   if (fjac(j,j) == zero) go to 110
   sum = zero
   do i = j, n
      sum = sum + fjac(i,j)*qtf(i)
   end do
   temp = -sum/fjac(j,j)
   do i = j, n
      qtf(i) = qtf(i) + fjac(i,j)*temp
   end do
110 continue
end do
!        Copy the triangular factor of the QR factorization into R.
sing = .false.
do j = 1, n
   l = j
   jm1 = j - 1
   if (jm1 < 1) go to 140
   do i = 1, jm1
      r(l) = fjac(i,j)
      l = l + n - i
   end do
140 continue
   r(l) = wa1(j)
   if (wa1(j) == zero) sing = .true.
end do
!        Accumulate the orthogonal factor in fjac.
call qform(n,n,fjac,ldfjac,wa1)
!        Rescale if necessary.
if (mode == 2) go to 170
do j = 1, n
   diag(j) = max(diag(j),wa2(j))
end do
170 continue
!        Beginning of the inner loop.
180 continue
!           If requested, call FCN to enable printing of iterates.
if (nprint <= 0) go to 190
iflag = 0
if (mod(iter - 1,nprint) == 0) call fcn(n,x,fvec,iflag)
if (iflag < 0) go to 300
190 continue
!           Determine the direction P.
call dogleg(n,r,lr,diag,qtf,delta,wa1,wa2,wa3)
!           Store the direction P and x + P. calculate the norm of P.
do j = 1, n
   wa1(j) = -wa1(j)
   wa2(j) = x(j) + wa1(j)
   wa3(j) = diag(j)*wa1(j)
end do
pnorm = enorm(n,wa3)
!           On the first iteration, adjust the initial step bound.
if (iter == 1) delta = min(delta,pnorm)
!           Evaluate the function at x + P and calculate its norm.
iflag = 1
call fcn(n,wa2,wa4,iflag)
nfev = nfev + 1
if (iflag < 0) go to 300
fnorm1 = enorm(n,wa4)
!           Compute the scaled actual reduction.
actred = -one
if (fnorm1 < fnorm) actred = one - (fnorm1/fnorm)**2
!           Compute the scaled predicted reduction.
l = 1
do i = 1, n
   sum = zero
   do j = i, n
      sum = sum + r(l)*wa1(j)
      l = l + 1
   end do
   wa3(i) = qtf(i) + sum
end do
temp = enorm(n,wa3)
prered = zero
if (temp < fnorm) prered = one - (temp/fnorm)**2
!           Compute the ratio of the actual to the predicted
!           reduction.
ratio = zero
if (prered > zero) ratio = actred/prered
!           Update the step bound.
if (ratio >= p1) go to 230
ncsuc = 0
ncfail = ncfail + 1
delta = p5*delta
go to 240
230 continue
ncfail = 0
ncsuc = ncsuc + 1
if (ratio >= p5 .or. ncsuc > 1) &
   & delta = max(delta,pnorm/p5)
if (abs(ratio - one) <= p1) delta = pnorm/p5
240 continue
!           Test for successful iteration.
if (ratio < p0001) go to 260
!           Successful iteration. Update x, fvec, and their norms.
do j = 1, n
   x(j) = wa2(j)
   wa2(j) = diag(j)*x(j)
   fvec(j) = wa4(j)
end do
xnorm = enorm(n,wa2)
fnorm = fnorm1
iter = iter + 1
260 continue
!           Determine the progress of the iteration.
nslow1 = nslow1 + 1
if (actred >= p001) nslow1 = 0
if (jeval) nslow2 = nslow2 + 1
if (actred >= p1) nslow2 = 0
!           Test for convergence.
if (delta <= xtol*xnorm .or. fnorm == zero) info = 1
if (info /= 0) go to 300
!           Tests for termination and stringent tolerances.
if (nfev >= maxfev) info = 2
if (p1*max(p1*delta,pnorm) <= epsmch*xnorm) info = 3
if (nslow2 == 5) info = 4
if (nslow1 == 10) info = 5
if (info /= 0) go to 300
!           Criterion for recalculating Jacobian approximation
!           by forward differences.
if (ncfail == 2) go to 290
!           Calculate the rank one modification to the Jacobian
!           and update QTF if necessary.
do j = 1, n
   sum = zero
   do i = 1, n
      sum = sum + fjac(i,j)*wa4(i)
   end do
   wa2(j) = (sum - wa3(j))/pnorm
   wa1(j) = diag(j)*((diag(j)*wa1(j))/pnorm)
   if (ratio >= p0001) qtf(j) = sum
end do
!           Compute the QR factorization of the updated Jacobian.
call r1updt(n,n,r,lr,wa1,wa2,wa3,sing)
call r1mpyq(n,n,fjac,ldfjac,wa2,wa3)
call r1mpyq(1,n,qtf,1,wa2,wa3)
!           END OF THE INNER LOOP.
jeval = .false.
go to 180
290 continue
!        END OF THE OUTER LOOP.
go to 30
300 continue
!     Termination, either normal or user imposed.
if (iflag < 0) info = iflag
iflag = 0
if (nprint > 0) call fcn(n,x,fvec,iflag)
!     Last card of subroutine hybrd.
end subroutine hybrd

pure subroutine qdcrt(a, z)
!! <!-- nswc-ford:begin QDCRT -->
!! Reference for `qdcrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         qdcrt computes the roots of the real polynomial
!!               a(1) + a(2)*z + a(3)*z**2
!!      and stores the results in z. it is assumed that a(3)
!!      is nonzero.
!!
!!      ***** eps is a machine dependent constant. Eps is the
!!            smallest number such that 1.0 + eps .GT. 1.0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: a(3)
complex, intent(inout) :: z(2)
!     beginning of local variable declarations
real :: d, eps, r, w, x, y
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!        qdcrt computes the roots of the real polynomial
!              a(1) + a(2)*z + a(3)*z**2
!     and stores the results in z. it is assumed that a(3)
!     is nonzero.
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.0 + eps .GT. 1.0.
eps = spmpar(1)
!-------------------
if (a(1) == 0.0) go to 40
d = a(2)*a(2) - 4.0*a(1)*a(3)
if (abs(d) <= 2.0*eps*a(2)*a(2)) go to 20
r = sqrt(abs(d))
if (d < 0.0) go to 30
!                 Distinct real roots
if (a(2) /= 0.0) go to 10
x = abs(0.5*r/a(3))
z(1) = cmplx(x, 0.0)
z(2) = cmplx(-x, 0.0)
return
10 w = -(a(2) + sign(r,a(2)))
z(1) = cmplx(2.0*a(1)/w, 0.0)
z(2) = cmplx(0.5*w/a(3), 0.0)
return
!                  Equal real roots
20 z(1) = cmplx(-0.5*a(2)/a(3), 0.0)
z(2) = z(1)
return
!                   complex roots
30 x = -0.5*a(2)/a(3)
y = abs(0.5*r/a(3))
z(1) = cmplx(x, y)
z(2) = cmplx(x,-y)
return
!                 Case when a(1) = 0
40 z(1) = (0.0, 0.0)
z(2) = cmplx(-a(2)/a(3), 0.0)
end subroutine qdcrt

pure subroutine dqdcrt(a, zr, zi)
!! <!-- nswc-ford:begin DQDCRT -->
!! Reference for `dqdcrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         dqdcrt computes the roots of the real polynomial
!!                 a(1) + a(2)*Z + a(3)*Z**2
!!      and stores the results in zr and zi. It is assumed that
!!      a(3) is nonzero.
!!
!!      ***** eps is a machine dependent constant. Eps is the
!!            smallest number such that 1.D0 + eps .GT. 1.D0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!        dqdcrt computes the roots of the real polynomial
!                a(1) + a(2)*Z + a(3)*Z**2
!     and stores the results in zr and zi. It is assumed that
!     a(3) is nonzero.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(3)
double precision, intent(inout) :: zr(2), zi(2)
!     beginning of local variable declarations
double precision :: d, eps, r, w
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.D0 + eps .GT. 1.D0.
eps = dpmpar(1)
!-------------------
if (a(1) == 0.d0) go to 40
d = a(2)*a(2) - 4.d0*a(1)*a(3)
if (abs(d) <= 2.d0*eps*a(2)*a(2)) go to 20
r = sqrt(abs(d))
if (d < 0.d0) go to 30
!                 Distinct real roots
zi(1) = 0.d0
zi(2) = 0.d0
if (a(2) /= 0.d0) go to 10
zr(1) = abs(0.5d0*r/a(3))
zr(2) = -zr(1)
return
10 w = -(a(2) + sign(r,a(2)))
zr(1) = 2.d0*a(1)/w
zr(2) = 0.5d0*w/a(3)
return
!                  Equal real roots
20 zr(1) = -0.5d0*a(2)/a(3)
zr(2) = zr(1)
zi(1) = 0.d0
zi(2) = 0.d0
return
!                   complex roots
30 zr(1) = -0.5d0*a(2)/a(3)
zr(2) = zr(1)
zi(1) = abs(0.5d0*r/a(3))
zi(2) = -zi(1)
return
!                 Case when a(1) = 0
40 zr(1) = 0.d0
zr(2) = -a(2)/a(3)
zi(1) = 0.d0
zi(2) = 0.d0
end subroutine dqdcrt

pure subroutine cbcrt(a, z)
!! <!-- nswc-ford:begin CBCRT -->
!! Reference for `cbcrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         cbcrt computes the roots of the real polynomial
!!               a(1) + a(2)*z + a(3)*z**2 + a(4)*z**3
!!      and stores the results in z. it is assumed that a(4)
!!      is nonzero.
!!
!!      Written by Alfred H. Morris
!!         naval surface weapons center
!!         Dahlgren, Virginia
!!
!!      ***** eps is a machine dependent constant. Eps is the
!!            smallest number such that 1.0 + eps .GT. 1.0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: a(4)
complex, intent(inout) :: z(3)
!     beginning of local variable declarations
real :: arg, c, cf, d, eps, p, p1, q, q1, r, r1, ra, rb, rq, rt, s, sf, sq, sum, t, t1, tol, w, w1, w2, x, x1, x2, x3, y, y1, y2, &
   & y3, aq(3)
real, parameter :: rt3 = 1.7320508075689
interface
   pure elemental function cbrt(x)
      implicit none
      real, intent(in) :: x
      real :: cbrt
   end function cbrt
   pure subroutine qdcrt(a,z)
      implicit none
      real, intent(in) :: a(3)
      complex, intent(inout) :: z(2)
   end subroutine qdcrt
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!        cbcrt computes the roots of the real polynomial
!              a(1) + a(2)*z + a(3)*z**2 + a(4)*z**3
!     and stores the results in z. it is assumed that a(4)
!     is nonzero.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!-------------------
!-----------------------------------------------------------------------
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.0 + eps .GT. 1.0.
eps = spmpar(1)
!-------------------
if (a(1) == 0.0) go to 100
p = a(3)/(3.0*a(4))
q = a(2)/a(4)
r = a(1)/a(4)
tol = 4.0*eps
c = 0.0
t = a(2) - p*a(3)
if (abs(t) > tol*abs(a(2))) c = t/a(4)
t = 2.0*p*p - q
if (abs(t) <= tol*abs(q)) t = 0.0
d = r + p*t
if (abs(d) <= tol*abs(r)) go to 110
!           SET  SQ = (a(4)/S)**2 * (c**3/27 + d**2/4)
s = max(abs(a(1)),abs(a(2)),abs(a(3)))
p1 = a(3)/(3.0*s)
q1 = a(2)/s
r1 = a(1)/s
t1 = q - 2.25*p*p
if (abs(t1) <= tol*abs(q)) t1 = 0.0
w = 0.25*r1*r1
w1 = 0.5*p1*r1*t
w2 = q1*q1*t1/27.0
if (w1 < 0.0) go to 10
w = w + w1
sq = w + w2
go to 12
10 if (w2 < 0.0) go to 11
w = w + w2
sq = w + w1
go to 12
11 sq = w + (w1 + w2)
12 if (abs(sq) <= tol*w) sq = 0.0
rq = abs(s/a(4))*sqrt(abs(sq))
if (sq >= 0.0) go to 40
!                   All roots are real
arg = atan2(rq, -0.5*d)
cf = cos(arg/3.0)
sf = sin(arg/3.0)
rt = sqrt(-c/3.0)
y1 = 2.0*rt*cf
y2 = -rt*(cf + rt3*sf)
y3 = -(d/y1)/y2
x1 = y1 - p
x2 = y2 - p
x3 = y3 - p
if (abs(x1) <= abs(x2)) go to 20
t = x1
x1 = x2
x2 = t
20 if (abs(x2) <= abs(x3)) go to 30
t = x2
x2 = x3
x3 = t
if (abs(x1) <= abs(x2)) go to 30
t = x1
x1 = x2
x2 = t
30 w = x3
if (abs(x2) < 0.1*abs(x3)) go to 70
if (abs(x1) < 0.1*abs(x2)) x1 = - (r/x3)/x2
z(1) = cmplx(x1, 0.0)
z(2) = cmplx(x2, 0.0)
z(3) = cmplx(x3, 0.0)
return
!                  Real and complex roots
40 ra = cbrt(-0.5*d - sign(rq,d))
rb = -c/(3.0*ra)
t = ra + rb
w = -p
x = -p
if (abs(t) <= tol*abs(ra)) go to 41
w = t - p
x = -0.5*t - p
if (abs(x) <= tol*abs(p)) x = 0.0
41 t = abs(ra - rb)
y = 0.5*rt3*t
if (t <= tol*abs(ra)) go to 60
if (abs(x) < abs(y)) go to 50
s = abs(x)
t = y/x
go to 51
50 s = abs(y)
t = x/y
51 if (s < 0.1*abs(w)) go to 70
w1 = w/s
sum = 1.0 + t*t
if (w1*w1 < 0.01*sum) w = - ((r/sum)/s)/s
z(1) = cmplx(w,0.0)
z(2) = cmplx(x, y)
z(3) = cmplx(x,-y)
return
!               At least two roots are equal
60 if (abs(x) < abs(w)) go to 61
if (abs(w) < 0.1*abs(x)) w = - (r/x)/x
z(1) = cmplx(w, 0.0)
z(2) = cmplx(x, 0.0)
z(3) = z(2)
return
61 if (abs(x) < 0.1*abs(w)) go to 70
z(1) = cmplx(x, 0.0)
z(2) = z(1)
z(3) = cmplx(w, 0.0)
return
!     Here W is much larger in magnitude than the other roots.
!     As a result, the other roots may be exceedingly inaccurate
!     because of roundoff error. To deal with this, a quadratic
!     is formed whose roots are the same as the smaller roots of
!     the cubic. This quadratic is then solved.
!     This code was written by william L. Davis (NSWC).
70 aq(1) = a(1)
aq(2) = a(2) + a(1)/w
aq(3) = -a(4)*w
call qdcrt(aq, z)
z(3) = cmplx(w, 0.0)
if (aimag(z(1)) == 0.0) return
z(3) = z(2)
z(2) = z(1)
z(1) = cmplx(w, 0.0)
return
!-----------------------------------------------------------------------
!                  Case when a(1) = 0
100 z(1) = (0.0, 0.0)
call qdcrt(a(2), z(2))
return
!                   Case when d = 0
110 z(1) = cmplx(-p, 0.0)
w = sqrt(abs(c))
if (c < 0.0) go to 120
z(2) = cmplx(-p, w)
z(3) = cmplx(-p,-w)
return
120 if (p /= 0.0) go to 130
z(2) = cmplx(w, 0.0)
z(3) = cmplx(-w, 0.0)
return
130 x = -(p + sign(w,p))
z(3) = cmplx(x, 0.0)
t = 3.0*a(1)/(a(3)*x)
if (abs(p) > abs(t)) go to 131
z(2) = cmplx(t, 0.0)
return
131 z(2) = z(1)
z(1) = cmplx(t, 0.0)
end subroutine cbcrt

pure subroutine dcbcrt(a, zr, zi)
!! <!-- nswc-ford:begin DCBCRT -->
!! Reference for `dcbcrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         dcbcrt computes the roots of the real polynomial
!!               a(1) + a(2)*Z + a(3)*Z**2 + a(4)*Z**3
!!      and stores the results in zr and zi. It is assumed that
!!      a(4) is nonzero.
!!
!!      Written by Alfred H. Morris
!!         naval surface weapons center
!!         Dahlgren, Virginia
!!
!!      ***** eps is a machine dependent constant. Eps is the
!!            smallest number such that 1.D0 + eps .GT. 1.D0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!        dcbcrt computes the roots of the real polynomial
!              a(1) + a(2)*Z + a(3)*Z**2 + a(4)*Z**3
!     and stores the results in zr and zi. It is assumed that
!     a(4) is nonzero.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
double precision, intent(in) :: a(4)
double precision, intent(inout) :: zr(3), zi(3)
!     beginning of local variable declarations
double precision :: aq(3), arg, c, cf, d, eps, p, p1, q, q1, r, ra, rb, rq, rt, r1, s, sf, sq, sum, t, tol, t1, w, w1, w2, x, x1, &
   & x2, x3, y, y1, y2, y3
double precision, parameter :: rt3 = 1.732050807568877293527446341505872366943d0
interface
   pure elemental function dcbrt(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dcbrt
   end function dcbrt
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure subroutine dqdcrt(a,zr,zi)
      implicit none
      double precision, intent(in) :: a(3)
      double precision, intent(inout) :: zr(2)
      double precision, intent(inout) :: zi(2)
   end subroutine dqdcrt
end interface
!-------------------
!-----------------------------------------------------------------------
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.D0 + eps .GT. 1.D0.
eps = dpmpar(1)
!-------------------
if (a(1) == 0.d0) go to 100
p = a(3)/(3.d0*a(4))
q = a(2)/a(4)
r = a(1)/a(4)
tol = 4.d0*eps
c = 0.d0
t = a(2) - p*a(3)
if (abs(t) > tol*abs(a(2))) c = t/a(4)
t = 2.d0*p*p - q
if (abs(t) <= tol*abs(q)) t = 0.d0
d = r + p*t
if (abs(d) <= tol*abs(r)) go to 110
!           SET  SQ = (a(4)/S)**2 * (c**3/27 + d**2/4)
s = max(abs(a(1)),abs(a(2)),abs(a(3)))
p1 = a(3)/(3.d0*s)
q1 = a(2)/s
r1 = a(1)/s
t1 = q - 2.25d0*p*p
if (abs(t1) <= tol*abs(q)) t1 = 0.d0
w = 0.25d0*r1*r1
w1 = 0.5d0*p1*r1*t
w2 = q1*q1*t1/27.d0
if (w1 < 0.d0) go to 10
w = w + w1
sq = w + w2
go to 12
10 if (w2 < 0.d0) go to 11
w = w + w2
sq = w + w1
go to 12
11 sq = w + (w1 + w2)
12 if (abs(sq) <= tol*w) sq = 0.d0
rq = abs(s/a(4))*sqrt(abs(sq))
if (sq >= 0.d0) go to 40
!                   All roots are real
arg = atan2(rq, -0.5d0*d)
cf = cos(arg/3.d0)
sf = sin(arg/3.d0)
rt = sqrt(-c/3.d0)
y1 = 2.d0*rt*cf
y2 = -rt*(cf + rt3*sf)
y3 = -(d/y1)/y2
x1 = y1 - p
x2 = y2 - p
x3 = y3 - p
if (abs(x1) <= abs(x2)) go to 20
t = x1
x1 = x2
x2 = t
20 if (abs(x2) <= abs(x3)) go to 30
t = x2
x2 = x3
x3 = t
if (abs(x1) <= abs(x2)) go to 30
t = x1
x1 = x2
x2 = t
30 w = x3
if (abs(x2) < 0.1d0*abs(x3)) go to 70
if (abs(x1) < 0.1d0*abs(x2)) x1 = - (r/x3)/x2
zr(1) = x1
zr(2) = x2
zr(3) = x3
zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
return
!                  Real and complex roots
40 ra = dcbrt(-0.5d0*d - sign(rq,d))
rb = -c/(3.d0*ra)
t = ra + rb
w = -p
x = -p
if (abs(t) <= tol*abs(ra)) go to 41
w = t - p
x = -0.5d0*t - p
if (abs(x) <= tol*abs(p)) x = 0.d0
41 t = abs(ra - rb)
y = 0.5d0*rt3*t
if (t <= tol*abs(ra)) go to 60
if (abs(x) < abs(y)) go to 50
s = abs(x)
t = y/x
go to 51
50 s = abs(y)
t = x/y
51 if (s < 0.1d0*abs(w)) go to 70
w1 = w/s
sum = 1.d0 + t*t
if (w1*w1 < 1.d-2*sum) w = - ((r/sum)/s)/s
zr(1) = w
zr(2) = x
zr(3) = x
zi(1) = 0.d0
zi(2) = y
zi(3) = -y
return
!               At least two roots are equal
60 zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
if (abs(x) < abs(w)) go to 61
if (abs(w) < 0.1d0*abs(x)) w = - (r/x)/x
zr(1) = w
zr(2) = x
zr(3) = x
return
61 if (abs(x) < 0.1d0*abs(w)) go to 70
zr(1) = x
zr(2) = x
zr(3) = w
return
!     Here W is much larger in magnitude than the other roots.
!     As a result, the other roots may be exceedingly inaccurate
!     because of roundoff error. To deal with this, a quadratic
!     is formed whose roots are the same as the smaller roots of
!     the cubic. This quadratic is then solved.
!     This code was written by william L. Davis (NSWC).
70 aq(1) = a(1)
aq(2) = a(2) + a(1)/w
aq(3) = -a(4)*w
call dqdcrt(aq, zr, zi)
zr(3) = w
zi(3) = 0.d0
if (zi(1) == 0.d0) return
zr(3) = zr(2)
zi(3) = zi(2)
zr(2) = zr(1)
zi(2) = zi(1)
zr(1) = w
zi(1) = 0.d0
return
!-----------------------------------------------------------------------
!                  Case when a(1) = 0
100 zr(1) = 0.d0
zi(1) = 0.d0
call dqdcrt(a(2), zr(2), zi(2))
return
!                   Case when d = 0
110 zr(1) = -p
zi(1) = 0.d0
w = sqrt(abs(c))
if (c < 0.d0) go to 120
zr(2) = -p
zr(3) = zr(2)
zi(2) = w
zi(3) = -w
return
120 if (p /= 0.d0) go to 130
zr(2) = w
zr(3) = -w
zi(2) = 0.d0
zi(3) = 0.d0
return
130 x = -(p + sign(w,p))
zr(3) = x
zi(2) = 0.d0
zi(3) = 0.d0
t = 3.d0*a(1)/(a(3)*x)
if (abs(p) > abs(t)) go to 131
zr(2) = t
return
131 zr(2) = zr(1)
zr(1) = t
end subroutine dcbcrt

pure subroutine qtcrt(a, z)
!! <!-- nswc-ford:begin QTCRT -->
!! Reference for `qtcrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          qtcrt computes the roots of the real polynomial
!!                a(1) + a(2)*z + ... + a(5)*z**4
!!          and stores the results in z. it is assumed that a(5)
!!          is nonzero.
!!
!!      Written by Alfred h. Morris
!!         naval surface weapons center
!!         Dahlgren, Virginia
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: a(5)
complex, intent(inout) :: z(4)
!     beginning of local variable declarations
real :: b, b2, c, d, e, h, p, q, r, t, u, v, v1, v2, x, x1, x2, x3, y, temp(4), nswc_ai_r4
complex :: w
interface
   pure subroutine aord(a,n)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: a(n)
   end subroutine aord
   pure subroutine cbcrt(a,z)
      implicit none
      real, intent(in) :: a(4)
      complex, intent(inout) :: z(3)
   end subroutine cbcrt
end interface
!-----------------------------------------------------------------------
!         qtcrt computes the roots of the real polynomial
!               a(1) + a(2)*z + ... + a(5)*z**4
!         and stores the results in z. it is assumed that a(5)
!         is nonzero.
!-----------------------------------------------------------------------
!     Written by Alfred h. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
if (a(1) == 0.0) go to 100
b = a(4)/(4.0*a(5))
c = a(3)/a(5)
d = a(2)/a(5)
e = a(1)/a(5)
b2 = b*b
p = 0.5*(c - 6.0*b2)
q = d - 2.0*b*(c - 4.0*b2)
r = b2*(c - 3.0*b2) - b*d + e
!          Solve the resolvent cubic equation. The cubic has
!          at least one nonnegative real root. If W1, W2, W3
!          are the roots of the cubic then the roots of the
!          originial equation are
!             z = -b + csqrt(w1) + csqrt(w2) + csqrt(w3)
!          where the signs of the square roots are chosen so
!          THAT CSQRT(W1) * CSQRT(W2) * CSQRT(W3) = -q/8.
temp(1) = -q*q/64.0
temp(2) = 0.25*(p*p - r)
temp(3) = p
temp(4) = 1.0
call cbcrt(temp,z)
if (aimag(z(2)) /= 0.0) go to 60
!               The resolvent cubic has only real roots
!                reorder the roots in increasing order
x1 = real(z(1))
x2 = real(z(2))
x3 = real(z(3))
if (x1 <= x2) go to 10
t = x1
x1 = x2
x2 = t
10 if (x2 <= x3) go to 20
t = x2
x2 = x3
x3 = t
if (x1 <= x2) go to 20
t = x1
x1 = x2
x2 = t
20 u = 0.0
if (x3 > 0.0) u = sqrt(x3)
if (x2 <= 0.0) go to 41
if (x1 >= 0.0) go to 30
if (abs(x1) > x2) go to 40
x1 = 0.0
30 x1 = sqrt(x1)
x2 = sqrt(x2)
if (q > 0.0) x1 = -x1
temp(1) = ((x1 + x2) + u) - b
temp(2) = ((-x1 - x2) + u) - b
temp(3) = ((x1 - x2) - u) - b
temp(4) = ((-x1 + x2) - u) - b
call aord(temp,4)
if (abs(temp(1)) >= 0.1*abs(temp(4))) go to 31
t = temp(2)*temp(3)*temp(4)
if (t /= 0.0) temp(1) = e/t
31 z(1) = cmplx(temp(1), 0.0)
z(2) = cmplx(temp(2), 0.0)
z(3) = cmplx(temp(3), 0.0)
z(4) = cmplx(temp(4), 0.0)
return
40 v1 = sqrt(abs(x1))
v2 = 0.0
go to 50
41 v1 = sqrt(abs(x1))
v2 = sqrt(abs(x2))
if (q < 0.0) u = -u
50 x = -u - b
y = v1 - v2
z(1) = cmplx(x, y)
z(2) = cmplx(x,-y)
x = u - b
y = v1 + v2
z(3) = cmplx(x, y)
z(4) = cmplx(x,-y)
return
!                The resolvent cubic has complex roots
60 t = real(z(1))
x = 0.0
nswc_ai_r4 = t
if (nswc_ai_r4 < 0) go to 61
if (nswc_ai_r4 == 0) go to 70
go to 62
61 h = abs(real(z(2))) + abs(aimag(z(2)))
if (abs(t) <= h) go to 70
go to 80
62 x = sqrt(t)
if (q > 0.0) x = -x
70 w = sqrt(z(2))
u = 2.0*real(w)
v = 2.0*abs(aimag(w))
t = x - b
x1 = t + u
x2 = t - u
if (abs(x1) <= abs(x2)) go to 71
t = x1
x1 = x2
x2 = t
71 u = -x - b
h = u*u + v*v
if (x1*x1 < 0.01*min(x2*x2,h)) x1 = e/(x2*h)
z(1) = cmplx(x1, 0.0)
z(2) = cmplx(x2, 0.0)
z(3) = cmplx(u, v)
z(4) = cmplx(u,-v)
return
80 v = sqrt(abs(t))
z(1) = cmplx(-b, v)
z(2) = cmplx(-b,-v)
z(3) = z(1)
z(4) = z(2)
return
!                         Case when a(1) = 0
100 z(1) = (0.0, 0.0)
call cbcrt(a(2), z(2))
end subroutine qtcrt

pure subroutine dqtcrt(a, zr, zi)
!! <!-- nswc-ford:begin DQTCRT -->
!! Reference for `dqtcrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          dqtcrt computes the roots of the real polynomial
!!                a(1) + a(2)*Z + ... + a(5)*Z**4
!!          and stores the results in zr and zi. It is assumed
!!          that a(5) is nonzero.
!!
!!      Written by Alfred h. Morris
!!         naval surface weapons center
!!         Dahlgren, Virginia
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!         dqtcrt computes the roots of the real polynomial
!               a(1) + a(2)*Z + ... + a(5)*Z**4
!         and stores the results in zr and zi. It is assumed
!         that a(5) is nonzero.
!-----------------------------------------------------------------------
!     Written by Alfred h. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
double precision, intent(in) :: a(5)
double precision, intent(inout) :: zr(4), zi(4)
!     beginning of local variable declarations
double precision :: b, b2, c, d, e, h, p, q, r, t, temp(4), u, v, v1, v2, w(2), x, x1, x2, x3, nswc_ai_r8
interface
   pure subroutine daord(a,n)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: a(n)
   end subroutine daord
   pure subroutine dcbcrt(a,zr,zi)
      implicit none
      double precision, intent(in) :: a(4)
      double precision, intent(inout) :: zr(3)
      double precision, intent(inout) :: zi(3)
   end subroutine dcbcrt
   pure subroutine dcsqrt(z,w)
      implicit none
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine dcsqrt
end interface
if (a(1) == 0.d0) go to 100
b = a(4)/(4.d0*a(5))
c = a(3)/a(5)
d = a(2)/a(5)
e = a(1)/a(5)
b2 = b*b
p = 0.5d0*(c - 6.d0*b2)
q = d - 2.d0*b*(c - 4.d0*b2)
r = b2*(c - 3.d0*b2) - b*d + e
!          Solve the resolvent cubic equation. The cubic has
!          at least one nonnegative real root. If W1, W2, W3
!          are the roots of the cubic then the roots of the
!          originial equation are
!             z = -b + csqrt(w1) + csqrt(w2) + csqrt(w3)
!          where the signs of the square roots are chosen so
!          THAT CSQRT(W1) * CSQRT(W2) * CSQRT(W3) = -q/8.
temp(1) = -q*q/64.d0
temp(2) = 0.25d0*(p*p - r)
temp(3) = p
temp(4) = 1.d0
call dcbcrt(temp, zr, zi)
if (zi(2) /= 0.d0) go to 60
!               The resolvent cubic has only real roots
!                reorder the roots in increasing order
x1 = zr(1)
x2 = zr(2)
x3 = zr(3)
if (x1 <= x2) go to 10
t = x1
x1 = x2
x2 = t
10 if (x2 <= x3) go to 20
t = x2
x2 = x3
x3 = t
if (x1 <= x2) go to 20
t = x1
x1 = x2
x2 = t
20 u = 0.d0
if (x3 > 0.d0) u = sqrt(x3)
if (x2 <= 0.d0) go to 41
if (x1 >= 0.d0) go to 30
if (abs(x1) > x2) go to 40
x1 = 0.d0
30 x1 = sqrt(x1)
x2 = sqrt(x2)
if (q > 0.d0) x1 = -x1
zr(1) = ((x1 + x2) + u) - b
zr(2) = ((-x1 - x2) + u) - b
zr(3) = ((x1 - x2) - u) - b
zr(4) = ((-x1 + x2) - u) - b
call daord(zr, 4)
if (abs(zr(1)) >= 0.1d0*abs(zr(4))) go to 31
t = zr(2)*zr(3)*zr(4)
if (t /= 0.d0) zr(1) = e/t
31 zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
zi(4) = 0.d0
return
40 v1 = sqrt(abs(x1))
v2 = 0.d0
go to 50
41 v1 = sqrt(abs(x1))
v2 = sqrt(abs(x2))
if (q < 0.d0) u = -u
50 zr(1) = -u - b
zi(1) = v1 - v2
zr(2) = zr(1)
zi(2) = -zi(1)
zr(3) = u - b
zi(3) = v1 + v2
zr(4) = zr(3)
zi(4) = -zi(3)
return
!                The resolvent cubic has complex roots
60 t = zr(1)
x = 0.d0
nswc_ai_r8 = t
if (nswc_ai_r8 < 0) go to 61
if (nswc_ai_r8 == 0) go to 70
go to 62
61 h = abs(zr(2)) + abs(zi(2))
if (abs(t) <= h) go to 70
go to 80
62 x = sqrt(t)
if (q > 0.d0) x = -x
70 w(1) = zr(2)
w(2) = zi(2)
call dcsqrt(w, w)
u = 2.d0*w(1)
v = 2.d0*abs(w(2))
t = x - b
x1 = t + u
x2 = t - u
if (abs(x1) <= abs(x2)) go to 71
t = x1
x1 = x2
x2 = t
71 u = -x - b
h = u*u + v*v
if (x1*x1 < 1.d-2*min(x2*x2,h)) x1 = e/(x2*h)
zr(1) = x1
zr(2) = x2
zi(1) = 0.d0
zi(2) = 0.d0
zr(3) = u
zr(4) = u
zi(3) = v
zi(4) = -v
return
80 v = sqrt(abs(t))
zr(1) = -b
zr(2) = -b
zr(3) = -b
zr(4) = -b
zi(1) = v
zi(2) = -v
zi(3) = v
zi(4) = -v
return
!                         Case when a(1) = 0
100 zr(1) = 0.d0
zi(1) = 0.d0
call dcbcrt(a(2), zr(2), zi(2))
end subroutine dqtcrt

subroutine drpoly(op, ideg, zeror, zeroi, num, wk, dwk)
!! <!-- nswc-ford:begin DRPOLY -->
!! Reference for `drpoly`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine finds the zeros of a real polynomial.
!!      op          - Double precision array of length ideg + 1.
!!                    On input this array contains the coefficients
!!                    in order of decreasing powers.
!!      ideg        - Integer degree of the polynomial.
!!      zeror,zeroi - Double precision arrays if length ideg.
!!                    On output these arrays contain the real and
!!                    imaginary parts of the zeros.
!!      num         - Variable that reports the status of the results.
!!                    If num = -1 Then the leading coefficient of the
!!                    polynomial is 0 or ideg .LT. 1. Otherwise, num
!!                    is the number of zeros that were obtained. If
!!                    num .GE. 1 then the real and imaginary parts of
!!                    the zeros are stored in zeror(J) and zeroi(J)
!!                    FOR J = 1,...,num.
!!      wk          - Real array of length ideg + 1. The array is
!!                    a work space for the routine.
!!      DWK         - Double precision array of length 6*(ideg + 1).
!!                    The array is a work space for the routine.
!!      The subroutine uses single precision calculations for scaling,
!!      bounds, and error calculations. All other calculations are done
!!      in double precision.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer :: ideg
integer, intent(inout) :: num
double precision, intent(in) :: op(*)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), &
   & dwk(*)
real, intent(inout) :: wk(*)
!     beginning of local variable declarations
integer :: idp1, p, qp, k, qk, svk, tmp
!     This subroutine finds the zeros of a real polynomial.
!     op          - Double precision array of length ideg + 1.
!                   On input this array contains the coefficients
!                   in order of decreasing powers.
!     ideg        - Integer degree of the polynomial.
!     zeror,zeroi - Double precision arrays if length ideg.
!                   On output these arrays contain the real and
!                   imaginary parts of the zeros.
!     num         - Variable that reports the status of the results.
!                   If num = -1 Then the leading coefficient of the
!                   polynomial is 0 or ideg .LT. 1. Otherwise, num
!                   is the number of zeros that were obtained. If
!                   num .GE. 1 then the real and imaginary parts of
!                   the zeros are stored in zeror(J) and zeroi(J)
!                   FOR J = 1,...,num.
!     wk          - Real array of length ideg + 1. The array is
!                   a work space for the routine.
!     DWK         - Double precision array of length 6*(ideg + 1).
!                   The array is a work space for the routine.
!     The subroutine uses single precision calculations for scaling,
!     bounds, and error calculations. All other calculations are done
!     in double precision.
if (ideg < 1) go to 10
!     Partition the workspace DWK and obtain the zeros
idp1 = ideg + 1
p = 1
qp = p + idp1
k = qp + idp1
qk = k + idp1
svk = qk + idp1
tmp = svk + idp1
call drply1(op,ideg,idp1,zeror,zeroi,dwk(p),dwk(qp),dwk(k), &
   & dwk(qk),dwk(svk),dwk(tmp),wk,num)
return
!     Error return
10 num = -1
end subroutine drpoly

subroutine drply1(op,ideg,idp1,zeror,zeroi,p,qp,k,qk,svk, &
   & temp,pt,num)
!! <!-- nswc-ford:begin DRPLY1 -->
!! Reference for `drply1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      The following statements set the machine constants used
!!      in the code. The meaning of the constants are ...
!!      eta     THE SMALLEST POSITIVE NUMBER SUCH THAT
!!              1.D0 + eta is greater than 1.D0
!!      SMALNO  the smallest positive floating point number.
!!              If the exponent range differs in single and
!!              double precision then SMALNO and infin
!!              should indicate the smaller range.
!!      INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
!!      BASE    THE BASE OF THE FLOATING POINT ARITHMETICS
!!              being used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer :: ideg
integer, intent(in) :: idp1
integer, intent(inout) :: num
double precision, intent(in) :: op(idp1)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg)
double precision :: p(idp1), qp(idp1), k(idp1), qk(idp1), &
   & svk(idp1), temp(idp1)
real, intent(inout) :: pt(idp1)
!     beginning of local variable declarations
integer :: i, j, jj, l, n, nm1, nn, nz, cnt
double precision :: aa, bb, cc, factor, t
real :: lo, max, min, xx, yy, cosr, sinr, x, xxx, sc, bnd, xm, ff, &
   & df, dx, base, smalno, infin
logical :: zerok
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental subroutine quadpl(a,b1,c,sr,si,lr,li)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: b1
      double precision, intent(in) :: c
      double precision, intent(inout) :: sr
      double precision, intent(inout) :: si
      double precision, intent(inout) :: lr
      double precision, intent(inout) :: li
   end subroutine quadpl
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-------------------------
!-------------------------
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!-------------------------
!     The following statements set the machine constants used
!     in the code. The meaning of the constants are ...
!     eta     THE SMALLEST POSITIVE NUMBER SUCH THAT
!             1.D0 + eta is greater than 1.D0
!     SMALNO  the smallest positive floating point number.
!             If the exponent range differs in single and
!             double precision then SMALNO and infin
!             should indicate the smaller range.
!     INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
!     BASE    THE BASE OF THE FLOATING POINT ARITHMETICS
!             being used.
eta = dpmpar(1)
smalno = spmpar(2)
infin = spmpar(3)
base = ipmpar(4)
!-------------------------
!     Are and mre refer to the unit error in + and *
!     respectively. They are assumed to be the same as eta.
are = eta
mre = eta
lo = smalno/eta
!     Initialization of constants for shift rotation
xx = .70710678
yy = -xx
cosr = -.069756474
sinr = .99756405
n = ideg
nn = idp1
num = 0
!     Algorithm fails if the leading coefficient is zero.
if (op(1) /= 0.d0) go to 10
num = -1
return
!     Remove the zeros at the origin if any
10 if (op(nn) /= 0.0d0) go to 20
num = num + 1
zeror(num) = 0.d0
zeroi(num) = 0.d0
nn = nn - 1
n = n - 1
go to 10
!     Make a copy of the coefficients
20 do i = 1,nn
   p(i) = op(i)
end do
!     Start the algorithm for obtaining a zero
40 if (n > 2) go to 60
if (n < 1) return
!     Calculate the final zero or pair of zeros
num = ideg
if (n == 2) go to 50
zeror(ideg) = -p(2)/p(1)
zeroi(ideg) = 0.0d0
return
50 call quadpl(p(1), p(2), p(3), zeror(ideg - 1), zeroi(ideg - 1), &
   & zeror(ideg), zeroi(ideg))
return
!     Find largest and smallest moduli of coefficients.
60 max = 0.0
min = infin
do i = 1,nn
   x = abs(sngl(p(i)))
   if (x > max) max = x
   if (x /= 0.0 .and. x < min) min = x
end do
!     Scale if there are large or very small coefficients.
!     Computes a scale factor to multiply the
!     coefficients of the polynomial. The scaling is done
!     to avoid overflow and to avoid undetected underflow
!     interfering with the convergence criterion.
!     The factor is a power of the base.
sc = lo/min
if (sc > 1.0) go to 80
if (max < 10.0) go to 110
if (sc == 0.0) sc = smalno
go to 90
80 if (infin/sc < max) go to 110
90 l = log(sc)/log(base) + 0.5
factor = dble(base)**l
if (factor == 1.d0) go to 110
do i = 1,nn
   p(i) = factor*p(i)
end do
!     Compute lower bound on moduli of zeros.
110 do i = 1,nn
   pt(i) = abs(sngl(p(i)))
end do
pt(nn) = -pt(nn)
!     Compute upper estimate of bound
x = exp((log(-pt(nn)) - log(pt(1)))/float(n))
if (pt(n) == 0.0) go to 130
!     If the Newton step at the origin is better then use it.
xm = -pt(nn)/pt(n)
if (xm < x) x = xm
!     Chop the interval (0,x) until ff .LE. 0.
130 xm = x*.1
ff = pt(1)
do i = 2,nn
   ff = ff*xm + pt(i)
end do
if (ff <= 0.0) go to 150
x = xm
go to 130
150 dx = x
!     Do Newton iteration until x converges to two decimal places.
160 if (abs(dx/x) <= 0.005) go to 180
ff = pt(1)
df = ff
do i = 2,n
   ff = ff*x + pt(i)
   df = df*x + ff
end do
ff = ff*x + pt(nn)
dx = ff/df
x = x - dx
go to 160
180 bnd = x
!     Compute the derivative as the intial k polynomial
!     and do 5 steps with no shift.
nm1 = n - 1
do i = 2,n
   k(i) = float(nn - i)*p(i)/float(n)
end do
k(1) = p(1)
aa = p(nn)
bb = p(n)
zerok = k(n) == 0.d0
do jj = 1,5
   cc = k(n)
   if (zerok) go to 210
!     Use scaled form of recurrence if value of k at 0 is nonzero.
   t = -aa/cc
   do i = 1,nm1
      j = nn - i
      k(j) = t*k(j - 1) + p(j)
   end do
   k(1) = p(1)
   zerok = abs(k(n)) <= abs(bb)*eta*10.
   go to 230
!     Use unscaled form of recurrence
210 do i = 1,nm1
      j = nn - i
      k(j) = k(j - 1)
   end do
   k(1) = 0.d0
   zerok = k(n) == 0.d0
230 continue
end do
!     Save k for restarts with new shifts
do i = 1,n
   temp(i) = k(i)
end do
!     Loop to select the quadratic  corresponding to each
!     new shift
do cnt = 1,20
!     Quadratic corresponds to a double shift to A
!     non-real point and its complex conjugate. The point
!     has modulus bnd and amplitude rotated by 94 degrees
!     from the previous shift.
   xxx = cosr*xx - sinr*yy
   yy = sinr*xx + cosr*yy
   xx = xxx
   sr = bnd*xx
   si = bnd*yy
   u = -2.0d0*sr
   v = bnd
!     Second stage calculation, fixed quadratic. The second stage
!     jumps directly to one of the third stage iterations.
   call fxshfr(20*cnt, nz, nn, p, qp, k, qk, svk)
   if (nz /= 0) go to 300
!     If the iteration is unsuccessful another quadratic
!     is chosen after restoring k.
   do i = 1,n
      k(i) = temp(i)
   end do
end do
!     Convergence was not achieved after 20 shifts.
return
!     Store the zeros obtained and deflate the polynomial.
300 num = num + 1
zeror(num) = szr
zeroi(num) = szi
nn = nn - nz
n = nn - 1
do i = 1,nn
   p(i) = qp(i)
end do
if (nz == 1) go to 40
num = num + 1
zeror(num) = lzr
zeroi(num) = lzi
go to 40
end subroutine drply1

subroutine fxshfr(l2, nz, nn, p, qp, k, qk, svk)
!! <!-- nswc-ford:begin FXSHFR -->
!! Reference for `fxshfr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Computes up to  l2  fixed shift k-polynomials,
!!      testing for convergence in the linear or quadratic
!!      case. Initiates one of the variable SHIFT
!!      iterations and returns with the number of zeros
!!      found.
!!      l2 - Limit of fixed shift steps
!!      nz - Number of zeros found
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
double precision :: p(nn), qp(nn), k(nn), qk(nn), svk(nn)
integer, intent(in) :: l2
integer, intent(inout) :: nz
!     beginning of local variable declarations
integer :: n, type, i, j, iflag
double precision :: svu, svv, ui, vi, s
real :: betas, betav, oss, ovv, ss, vv, ts, tv, ots, otv, tvv, tss
logical :: vpass, spass, vtry, stry
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!     Computes up to  l2  fixed shift k-polynomials,
!     testing for convergence in the linear or quadratic
!     case. Initiates one of the variable SHIFT
!     iterations and returns with the number of zeros
!     found.
!     l2 - Limit of fixed shift steps
!     nz - Number of zeros found
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
n = nn - 1
nz = 0
betav = .25
betas = .25
oss = sr
ovv = v
!     Evaluate polynomial by synthetic division
call quadsd(nn, u, v, p, qp, a, b)
call calcsc(type, n, k, qk)
do j = 1,l2
!     Calculate next k polynomial and estimate v
   call nextk(type, n, qp, k, qk)
   call calcsc(type, n, k, qk)
   call newest(type, ui, vi, nn, p, k)
   vv = vi
!     Estimate s
   ss = 0.0
   if (k(n) /= 0.d0) ss = -p(nn)/k(n)
   tv = 1.0
   ts = 1.0
   if (j == 1 .or. type == 3) go to 70
!     Compute relative measures of convergence of s and v
!     sequences
   if (vv /= 0.0) tv = abs((vv - ovv)/vv)
   if (ss /= 0.0) ts = abs((ss - oss)/ss)
!     If decreasing, multiply two most recent
!     convergence measures
   tvv = 1.0
   if (tv < otv) tvv = tv*otv
   tss = 1.0
   if (ts < ots) tss = ts*ots
!     Compare with convergence criteria
   vpass = tvv < betav
   spass = tss < betas
   if (.not.(spass .or. vpass)) go to 70
!     At least one sequence has passed the convergence
!     test. Store variables before iterating
   svu = u
   svv = v
   do i = 1,n
      svk(i) = k(i)
   end do
   s = ss
!     Choose iteration according to the fastest
!     converging sequence
   vtry = .false.
   stry = .false.
   if (spass .and. ((.not.vpass) .or. &
      & tss < tvv)) go to 40
20 call quadit(ui, vi, nz, nn, p, qp, k, qk)
   if (nz > 0) return
!     Quadratic iteration has failed. Flag that it has
!     been tried and decrease the convergence criterion.
   vtry = .true.
   betav = betav*0.25
!     Try linear iteration if it has not been tried and
!     the s sequence is converging
   if (stry .or. (.not.spass)) go to 50
   do i = 1,n
      k(i) = svk(i)
   end do
40 call realit(s, nz, iflag, nn, p, qp, k, qk)
   if (nz > 0) return
!     Linear iteration has failed. Flag that it has been
!     tried and decrease the convergence criterion
   stry = .true.
   betas = betas*0.25
   if (iflag == 0) go to 50
!     If linear iteration signals an almost double real
!     zero attempt quadratic interation
   ui = -(s + s)
   vi = s*s
   go to 20
!     Restore variables
50 u = svu
   v = svv
   do i = 1,n
      k(i) = svk(i)
   end do
!     Try quadratic iteration if it has not been tried
!     and the v sequence is converging
   if (vpass .and. (.not.vtry)) go to 20
!     Recompute qp and scalar values to continue the
!     second stage
   call quadsd(nn, u, v, p, qp, a, b)
   call calcsc(type, n, k, qk)
70 ovv = vv
   oss = ss
   otv = tv
   ots = ts
end do
end subroutine fxshfr

subroutine quadit(uu, vv, nz, nn, p, qp, k, qk)
!! <!-- nswc-ford:begin QUADIT -->
!! Reference for `quadit`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Variable-shift k-polynomial iteration for A
!!      quadratic factor converges only if the zeros are
!!      equimodular or nearly so.
!!      uu,vv - Coefficients of starting quadratic
!!      nz - Number of zero found
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: uu, vv
double precision :: p(nn), qp(nn), k(nn), qk(nn)
integer, intent(inout) :: nz
!     beginning of local variable declarations
integer :: n, type, i, j
double precision :: ui, vi
real :: mp, omp, ee, relstp, t, zm
logical :: tried
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
interface
   pure elemental subroutine quadpl(a,b1,c,sr,si,lr,li)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: b1
      double precision, intent(in) :: c
      double precision, intent(inout) :: sr
      double precision, intent(inout) :: si
      double precision, intent(inout) :: lr
      double precision, intent(inout) :: li
   end subroutine quadpl
end interface
!     Variable-shift k-polynomial iteration for A
!     quadratic factor converges only if the zeros are
!     equimodular or nearly so.
!     uu,vv - Coefficients of starting quadratic
!     nz - Number of zero found
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
n = nn - 1
nz = 0
tried = .false.
u = uu
v = vv
j = 0
! Main loop
10 call quadpl(1.d0, u, v, szr, szi, lzr, lzi)
!     RETURN IF ROOTS OF THE QUADRATIC ARE REAL AND NOT CLOSE
!     to multiple or nearly equal and of opposite sign
if (abs(abs(szr) - abs(lzr)) > 1.d-2*abs(lzr)) &
   & return
!     Evaluate polynomial by quadratic synthetic division
call quadsd(nn, u, v, p, qp, a, b)
mp = abs(a - szr*b) + abs(szi*b)
!     Compute a rigorous bound on the rounding error in
!     EVALUTING p
zm = sqrt(abs(sngl(v)))
ee = 2.0*abs(sngl(qp(1)))
t = -szr*b
do i = 2,n
   ee = ee*zm + abs(sngl(qp(i)))
end do
ee = ee*zm + abs(sngl(a) + t)
ee = (5.0*mre + 4.0*are)*ee - (5.0*mre + 2.0*are)* &
   & (abs(sngl(a) + t) + abs(sngl(b))*zm) + &
   & 2.0*are*abs(t)
!     Iteration has converged sufficiently if the
!     polynomial value is less than 20 times this bound
if (mp > 20.0*ee) go to 30
nz = 2
return
30 j = j + 1
!     STOP ITERATION AFTER 20 STEPS
if (j > 20) return
if (j < 2) go to 50
if (relstp > 0.01 .or. mp < omp .or. tried) go to 50
!     A cluster appears to be stalling the convergence.
!     Five fixed shift steps are taken with A u,v close
!     to the cluster
if (relstp < eta) relstp = eta
relstp = sqrt(relstp)
u = u - u*relstp
v = v + v*relstp
call quadsd(nn, u, v, p, qp, a, b)
do i = 1,5
   call calcsc(type, n, k, qk)
   call nextk(type, n, qp, k, qk)
end do
tried = .true.
j = 0
50 omp = mp
!     Calculate next k polynomial and new u and v
call calcsc(type, n, k, qk)
call nextk(type, n, qp, k, qk)
call calcsc(type, n, k, qk)
call newest(type, ui, vi, nn, p, k)
!     If vi is zero the iteration is not converging
if (vi == 0.d0) return
relstp = abs((vi - v)/vi)
u = ui
v = vi
go to 10
end subroutine quadit

subroutine realit(sss, nz, iflag, nn, p, qp, k, qk)
!! <!-- nswc-ford:begin REALIT -->
!! Reference for `realit`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Variable-shift H polynomial iteration for a real zero.
!!      sss   - Starting iterate
!!      nz    - Number of zero found
!!      iflag - Flag to indicate a pair of zeros near the real
!!              axis.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nn
integer, intent(inout) :: nz
double precision, intent(inout) :: sss
double precision :: p(nn), qp(nn), k(nn), qk(nn)
!     beginning of local variable declarations
integer :: i, j, n
double precision :: pv, kv, t, s
real :: ms, mp, omp, ee
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!     Variable-shift H polynomial iteration for a real zero.
!     sss   - Starting iterate
!     nz    - Number of zero found
!     iflag - Flag to indicate a pair of zeros near the real
!             axis.
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
n = nn - 1
nz = 0
s = sss
iflag = 0
j = 0
!     Evaluate p at s
10 pv = p(1)
qp(1) = pv
do i = 2,nn
   pv = pv*s + p(i)
   qp(i) = pv
end do
mp = abs(pv)
!     Compute a rigorous bound on the error in evaluating p
ms = abs(s)
ee = (mre/(are + mre))*abs(sngl(qp(1)))
do i = 2,nn
   ee = ee*ms + abs(sngl(qp(i)))
end do
!     Iteration has converged sufficiently if the
!     polynomial value is less than 20 times this bound
if (mp > 20.0*((are + mre)*ee - mre*mp)) go to 40
nz = 1
szr = s
szi = 0.d0
return
40 j = j + 1
!     STOP ITERATION AFTER 10 STEPS
if (j > 10) return
if (j < 2) go to 50
if (abs(t) > 1.d-3*abs(s - t) .or. mp <= omp) &
   & go to 50
!     A cluster of zeros near the real axis has been
!     encountered return with iflag set to initiate A
!     quadratic iteration
iflag = 1
sss = s
return
!     RETURN IF THE POLYNOMIAL VALUE HAS INCREASED
!     significantly
50 omp = mp
!     Compute t, the next polynomial, and the new iterate
kv = k(1)
qk(1) = kv
do i = 2,n
   kv = kv*s + k(i)
   qk(i) = kv
end do
if (abs(kv) <= abs(k(n))*10.*eta) go to 80
!     Use the scaled form of the recurrence if the value
!     of k at s is nonzero
t = -pv/kv
k(1) = qp(1)
do i = 2,n
   k(i) = t*qk(i - 1) + qp(i)
end do
go to 100
!     Use unscaled form
80 k(1) = 0.0d0
do i = 2,n
   k(i) = qk(i - 1)
end do
100 kv = k(1)
do i = 2,n
   kv = kv*s + k(i)
end do
t = 0.d0
if (abs(kv) > abs(k(n))*10.*eta) t = -pv/kv
s = s + t
go to 10
end subroutine realit

subroutine calcsc(type, n, k, qk)
!! <!-- nswc-ford:begin CALCSC -->
!! Reference for `calcsc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This routine calculates scalar quantities used to
!!      compute the next k polynomial and new estimates of
!!      the quadratic coefficients.
!!      type - Integer variable SET here indicating how the
!!             calculations are normalized to avoid overflow
!!      Synthetic division of k by the quadratic 1,u,v
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(inout) :: type
double precision :: k(n), qk(n)
!     beginning of local variable declarations
double precision :: tol
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!     This routine calculates scalar quantities used to
!     compute the next k polynomial and new estimates of
!     the quadratic coefficients.
!     type - Integer variable SET here indicating how the
!            calculations are normalized to avoid overflow
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!     Synthetic division of k by the quadratic 1,u,v
call quadsd(n, u, v, k, qk, c, d)
tol = 100.0*eta
if (abs(c) > tol*abs(k(n))) go to 10
if (abs(d) > tol*abs(k(n - 1))) go to 10
type = 3
!     type=3 Indicates the quadratic is almost a factor of k
return
10 if (abs(d) < abs(c)) go to 20
type = 2
!     type=2 Indicates that all formulas are divided by d
e = a/d
f = c/d
g = u*b
h = v*b
a3 = (a + g)*e + h*(b/d)
a1 = b*f - a
a7 = (f + u)*a + h
return
20 type = 1
!     type=1 Indicates that all formulas are divided by c
e = a/c
f = d/c
g = u*e
h = v*b
a3 = a*e + (h/c + g)*b
a1 = b - a*(d/c)
a7 = a + g*d + h*f
end subroutine calcsc

subroutine nextk(type, n, qp, k, qk)
!! <!-- nswc-ford:begin NEXTK -->
!! Reference for `nextk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Computes the next k polynomials using the scalars
!!      computed in calcsc.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: type
double precision :: qp(n), k(n), qk(n)
!     beginning of local variable declarations
integer :: i
double precision :: temp
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!     Computes the next k polynomials using the scalars
!     computed in calcsc.
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
if (type == 3) go to 40
temp = a
if (type == 1) temp = b
if (abs(a1) > abs(temp)*eta*10.) go to 20
!     If a1 is nearly zero then use a special form of the
!     recurrence
k(1) = 0.d0
k(2) = -a7*qp(1)
do i = 3,n
   k(i) = a3*qk(i - 2) - a7*qp(i - 1)
end do
return
!     Use scaled form of the recurrence
20 a7 = a7/a1
a3 = a3/a1
k(1) = qp(1)
k(2) = qp(2) - a7*qp(1)
do i = 3,n
   k(i) = a3*qk(i - 2) - a7*qp(i - 1) + qp(i)
end do
return
!     Use unscaled form of the recurrence if type is 3
40 k(1) = 0.d0
k(2) = 0.d0
do i = 3,n
   k(i) = qk(i - 2)
end do
end subroutine nextk

subroutine newest(type, uu, vv, nn, p, k)
!! <!-- nswc-ford:begin NEWEST -->
!! Reference for `newest`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Compute new estimates of the quadratic coefficients
!!      using the scalars computed in calcsc.
!!      Use formulas appropriate to setting of type.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
integer, intent(in) :: type
double precision, intent(inout) :: uu, vv
double precision :: p(nn), k(nn)
!     beginning of local variable declarations
integer :: n
double precision :: a4, a5, b1, b2, c1, c2, c3, c4, temp
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!     Compute new estimates of the quadratic coefficients
!     using the scalars computed in calcsc.
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!     Use formulas appropriate to setting of type.
n = nn - 1
if (type == 3) go to 30
if (type == 2) go to 10
a4 = a + u*b + h*f
a5 = c + (u + v*f)*d
go to 20
10 a4 = (a + g)*f + h
a5 = (f + u)*c + v*d
!     Evaluate new quadratic coefficients.
20 b1 = -k(n)/p(nn)
b2 = -(k(n - 1) + b1*p(n))/p(nn)
c1 = v*b2*a1
c2 = b1*a7
c3 = b1*b1*a3
c4 = c1 - c2 - c3
temp = a5 + b1*a4 - c4
if (temp == 0.d0) go to 30
uu = u - (u*(c3 + c2) + v*(b1*a1 + b2*a7))/temp
vv = v*(1.d0 + c4/temp)
return
!     If type=3 The quadratic is zeroed
30 uu = 0.d0
vv = 0.d0
end subroutine newest

pure subroutine quadsd(nn, u, v, p, q, a, b)
!! <!-- nswc-ford:begin QUADSD -->
!! Reference for `quadsd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Divides p by the quadratic  1,u,v  placing the
!!      quotient in q and the remainder in A,b.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: p(nn)
double precision, intent(inout) :: q(nn)
double precision, intent(in) :: u, v
double precision, intent(out) :: a, b
!     beginning of local variable declarations
integer :: i
double precision :: c
!     Divides p by the quadratic  1,u,v  placing the
!     quotient in q and the remainder in A,b.
b = p(1)
q(1) = b
a = p(2) - u*b
q(2) = a
do i = 3,nn
   c = p(i) - u*a - v*b
   q(i) = c
   b = a
   a = c
end do
end subroutine quadsd

pure elemental subroutine quadpl(a, b1, c, sr, si, lr, li)
!! <!-- nswc-ford:begin QUADPL -->
!! Reference for `quadpl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculate the zeros of the quadratic a*Z**2+b1*Z+c.
!!      The quadratic formula, modified to avoid overflow,
!!      is used to find the larger zero if the zeros are
!!      real, and both zeros if the zeros are complex.
!!      The smaller real zero is found directly from the
!!      product of the zeros c/a.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Calculate the zeros of the quadratic a*Z**2+b1*Z+c.
!     The quadratic formula, modified to avoid overflow,
!     is used to find the larger zero if the zeros are
!     real, and both zeros if the zeros are complex.
!     The smaller real zero is found directly from the
!     product of the zeros c/a.
double precision, intent(in) :: a, b1, c
double precision, intent(inout) :: sr, si, lr, li
!     beginning of local variable declarations
double precision :: b, d, e
if (a /= 0.d0) go to 20
sr = 0.d0
if (b1 /= 0.d0) sr = -c/b1
lr = 0.d0
10 si = 0.d0
li = 0.d0
return
20 if (c /= 0.d0) go to 30
sr = 0.d0
lr = -b1/a
go to 10
!     Compute discriminant avoiding overflow
30 b = b1/2.d0
if (abs(b) < abs(c)) go to 40
e = 1.d0 - (a/b)*(c/b)
d = sqrt(abs(e))*abs(b)
go to 50
40 e = a
if (c < 0.d0) e = -a
e = b*(b/abs(c)) - e
d = sqrt(abs(e))*sqrt(abs(c))
50 if (e < 0.d0) go to 60
!     real zeros
if (b >= 0.d0) d = -d
lr = (-b + d)/a
sr = 0.d0
if (lr /= 0.d0) sr = (c/lr)/a
go to 10
!     Complex conjugate zeros
60 sr = -b/a
lr = sr
si = abs(d/a)
li = -si
end subroutine quadpl

subroutine dcpoly(opr,opi,ideg,zeror,zeroi,num,wk)
!! <!-- nswc-ford:begin DCPOLY -->
!! Reference for `dcpoly`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine finds the zeros of a complex polynomial.
!!      opr,opi     - DOUBLE PRECISION ARRAYS OF LENGTH ideg + 1.
!!                    On input these arrays contain the real and imaginary
!!                    parts of the coefficients in order of decreasing
!!                    powers.
!!      ideg        - Integer degree of the polynomial.
!!      zeror,zeroi - Double precision arrays of length ideg.
!!                    On output these arrays contain the real and
!!                    imaginary parts of the zeros.
!!      num         - Variable that reports the status of the results.
!!                    If num = -1 Then the leading coefficient of the
!!                    polynomial is 0 or ideg .LT. 1. Otherwise, num
!!                    is the number of zeros that were obtained. If
!!                    num .GE. 1 then the real and imaginary parts of
!!                    the zeros are stored in zeror(J) and zeroi(J)
!!                    FOR J = 1,...,num.
!!      wk          - Double precision array of length 10*(ideg + 1).
!!                    The array is a work space for the routine.
!!      The code has been written to reduce the chance of overflow
!!      occurring. If it does occur, there is still a possibility that
!!      the zerofinder will work provided the overflowed quantity is
!!      replaced by a large number.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: num
integer :: ideg
double precision, intent(in) :: opr(*), opi(*)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), wk(*)
!     beginning of local variable declarations
integer :: idp1, pr, pi, qpr, qpi, hr, hi, qhr, qhi, shr, shi
!     This subroutine finds the zeros of a complex polynomial.
!     opr,opi     - DOUBLE PRECISION ARRAYS OF LENGTH ideg + 1.
!                   On input these arrays contain the real and imaginary
!                   parts of the coefficients in order of decreasing
!                   powers.
!     ideg        - Integer degree of the polynomial.
!     zeror,zeroi - Double precision arrays of length ideg.
!                   On output these arrays contain the real and
!                   imaginary parts of the zeros.
!     num         - Variable that reports the status of the results.
!                   If num = -1 Then the leading coefficient of the
!                   polynomial is 0 or ideg .LT. 1. Otherwise, num
!                   is the number of zeros that were obtained. If
!                   num .GE. 1 then the real and imaginary parts of
!                   the zeros are stored in zeror(J) and zeroi(J)
!                   FOR J = 1,...,num.
!     wk          - Double precision array of length 10*(ideg + 1).
!                   The array is a work space for the routine.
!     The code has been written to reduce the chance of overflow
!     occurring. If it does occur, there is still a possibility that
!     the zerofinder will work provided the overflowed quantity is
!     replaced by a large number.
if (ideg < 1) go to 10
!     Partition the workspace and obtain the zeros
idp1 = ideg + 1
pr = 1
pi = pr + idp1
qpr = pi + idp1
qpi = qpr + idp1
hr = qpi + idp1
hi = hr + idp1
qhr = hi + idp1
qhi = qhr + idp1
shr = qhi + idp1
shi = shr + idp1
call dcply1(opr,opi,ideg,idp1,zeror,zeroi,wk(pr),wk(pi), &
   & wk(qpr),wk(qpi),wk(hr),wk(hi),wk(qhr),wk(qhi), &
   & wk(shr),wk(shi),num)
return
!     Error return
10 num = -1
end subroutine dcpoly

subroutine dcply1(opr,opi,ideg,idp1,zeror,zeroi,pr,pi,qpr,qpi, &
   & hr,hi,qhr,qhi,shr,shi,num)
!! <!-- nswc-ford:begin DCPLY1 -->
!! Reference for `dcply1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      The following statements set the machine constants used
!!      in the code. The meaning of the constants are ...
!!      eta     THE SMALLEST POSITIVE NUMBER SUCH THAT
!!              1.D0 + eta is greater than 1.D0
!!      smalno  the smallest positive floating point number.
!!      INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
!!      BASE    THE BASE OF THE FLOATING POINT ARITHMETIC
!!              being used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer :: ideg
integer, intent(in) :: idp1
integer, intent(out) :: num
double precision, intent(in) :: opr(idp1), opi(idp1)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), &
   & pr(idp1), pi(idp1), qpr(idp1), qpi(idp1), hr(idp1), hi(idp1), &
   & qhr(idp1), qhi(idp1), shr(idp1), shi(idp1)
!     beginning of local variable declarations
integer :: i, nn
double precision :: sr, si, tr, ti, pvr, pvi, are, mre, eta, infin
double precision :: xx, yy, cosr, sinr, smalno, base, xxx, zr, zi, bnd, scalcp
logical :: conv
integer :: cnt1, cnt2
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
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-------------------------
!-------------------------
!     The following statements set the machine constants used
!     in the code. The meaning of the constants are ...
!     eta     THE SMALLEST POSITIVE NUMBER SUCH THAT
!             1.D0 + eta is greater than 1.D0
!     smalno  the smallest positive floating point number.
!     INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
!     BASE    THE BASE OF THE FLOATING POINT ARITHMETIC
!             being used.
eta = dpmpar(1)
smalno = dpmpar(2)
infin = dpmpar(3)
base = ipmpar(4)
!-------------------------
!     Initialization
are = eta
mre = 2.d0*sqrt(2.d0)*eta
xx = .70710678
yy = -xx
cosr = -.069756474
sinr = .99756405
num = 0
nn = idp1
!     The algorithm fails if the leading coefficient is zero
if (opr(1) /= 0.d0 .or. opi(1) /= 0.d0) go to 10
num = -1
return
!     Remove the zeros at the origin if any.
10 if (opr(nn) /= 0.d0 .or. opi(nn) /= 0.d0) go to 20
num = num + 1
zeror(num) = 0.d0
zeroi(num) = 0.d0
nn = nn - 1
go to 10
!     Make a copy of the coefficients.
20 if (nn < 2) return
do i = 1,nn
   pr(i) = opr(i)
   pi(i) = opi(i)
   shr(i) = dcpabs(pr(i),pi(i))
end do
!     Scale the polynomial.
bnd = scalcp(nn,shr,eta,infin,smalno,base)
if (bnd == 1.d0) go to 40
do i = 1,nn
   pr(i) = bnd*pr(i)
   pi(i) = bnd*pi(i)
end do
!     Start the algorithm for obtaining a zero.
40 if (nn > 2) go to 50
num = ideg
call cdivid(-pr(2),-pi(2),pr(1),pi(1),zeror(ideg), &
   & zeroi(ideg))
return
!     Calculate BND, a lower bound on the modulus of the zeros.
50 do i = 1,nn
   shr(i) = dcpabs(pr(i),pi(i))
end do
call cauchy(nn,bnd,shr,shi)
!     Outer loop to control two major passes with different
!     sequences of shifts.
do cnt1 = 1,2
!     First stage calculation. No shift.
   call noshft(5,nn,tr,ti,eta,pr,pi,hr,hi)
!     Inner loop to select a shift.
   do cnt2 = 1,9
!     The shift is chosen with modulus BND and amplitude rotated
!     by 94 degrees from the previous shift.
      xxx = cosr*xx - sinr*yy
      yy = sinr*xx + cosr*yy
      xx = xxx
      sr = bnd*xx
      si = bnd*yy
!     Second stage calculation, fixed shift. The second stage jumps
!     directly to the third stage iteration.
      call fxshft(10*cnt2,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi, &
         & qhr,qhi,shr,shi,sr,si,tr,ti,pvr,pvi, &
         & are,mre,eta,infin)
      if (conv) go to 100
!     If the iteration is unsuccessful another shift is chosen.
   end do
!     If 9 shifts fail, the outer loop is repeated with another
!     sequence of shifts.
end do
return
!     A zero has been obtained. Store the zero and deflate
!     the polynomial.
100 num = num + 1
zeror(num) = zr
zeroi(num) = zi
nn = nn - 1
do i = 1,nn
   pr(i) = qpr(i)
   pi(i) = qpi(i)
end do
go to 40
end subroutine dcply1

pure double precision function scalcp(nn,pt,eta,infin,smalno,base)
!! <!-- nswc-ford:begin SCALCP -->
!! Reference for `scalcp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Returns a scale factor to multiply the coefficients of the
!!      polynomial. The scaling is done to avoid overflow and to avoid
!!      undetected underflow interfering with the convergence criterion.
!!      The factor is a power of the base.
!!      pt - Modulus of the coefficients of P
!!      eta,infin,smalno,base - Constants describing the
!!             floating point arithmetic.
!!      Find the largest and smallest moduli of coefficients.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: pt(nn), eta, infin, smalno, base
!     beginning of local variable declarations
integer :: i, l
double precision :: hi, lo, max, min, x, sc
!     Returns a scale factor to multiply the coefficients of the
!     polynomial. The scaling is done to avoid overflow and to avoid
!     undetected underflow interfering with the convergence criterion.
!     The factor is a power of the base.
!     pt - Modulus of the coefficients of P
!     eta,infin,smalno,base - Constants describing the
!            floating point arithmetic.
!     Find the largest and smallest moduli of coefficients.
hi = sqrt(infin)
lo = smalno/eta
max = 0.d0
min = infin
do i = 1,nn
   x = pt(i)
   if (x > max) max = x
   if (x /= 0.d0 .and. x < min) min = x
end do
!     Scale only if there are very large or very small coefficients.
scalcp = 1.d0
sc = lo/min
if (sc > 1.d0) go to 20
if (max <= hi) return
sc = 1.d0/(sqrt(max)*sqrt(min))
go to 30
20 if (infin/sc < max) return
30 l = log(sc)/log(base) + 0.5d0
scalcp = base**l
end function scalcp

pure subroutine cauchy(nn,bnd,pt,q)
!! <!-- nswc-ford:begin CAUCHY -->
!! Reference for `cauchy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Cauchy computes a lower bound bnd on the moduli of the zeros
!!      of a polynomial. pt is the modulus of the coefficients.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
double precision, intent(inout) :: q(nn), pt(nn)
double precision, intent(inout) :: bnd
!     beginning of local variable declarations
integer :: i, n
double precision :: x, xm, f, dx, df
!     Cauchy computes a lower bound bnd on the moduli of the zeros
!     of a polynomial. pt is the modulus of the coefficients.
pt(nn) = -pt(nn)
!     Compute upper estimate of bound.
n = nn - 1
x = exp((log(-pt(nn)) - log(pt(1)))/dble(float(n)))
if (pt(n) == 0.d0) go to 20
!     If the Newton step at the origin is better then use it.
xm = -pt(nn)/pt(n)
if (xm < x) x = xm
!     Chop the interval (0,x) until f .LE. 0.
20 xm = 0.1d0*x
f = pt(1)
do i = 2,nn
   f = f*xm + pt(i)
end do
if (f <= 0.d0) go to 40
x = xm
go to 20
40 dx = x
!     Do Newton iteration until x converges to two decimal places.
50 if (abs(dx/x) <= 0.005d0) go to 70
q(1) = pt(1)
do i = 2,nn
   q(i) = q(i - 1)*x + pt(i)
end do
f = q(nn)
df = q(1)
do i = 2,n
   df = df*x + q(i)
end do
dx = f/df
x = x - dx
go to 50
70 bnd = x
end subroutine cauchy

pure subroutine noshft(l1,nn,tr,ti,eta,pr,pi,hr,hi)
!! <!-- nswc-ford:begin NOSHFT -->
!! Reference for `noshft`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Computes the derivative polynomial as the initial H
!!      polynomial and computes l1 no-shift H polynomials.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l1, nn
double precision, intent(inout) :: tr, ti
double precision, intent(in) :: eta, pr(nn), pi(nn)
double precision, intent(inout) :: hr(nn), hi(nn)
!     beginning of local variable declarations
integer :: i, j, jj, n, nm1
double precision :: dn, t1, t2, xni
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
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
!     Computes the derivative polynomial as the initial H
!     polynomial and computes l1 no-shift H polynomials.
n = nn - 1
nm1 = n - 1
dn = n
do i = 1,n
   xni = nn - i
   hr(i) = xni*pr(i)/dn
   hi(i) = xni*pi(i)/dn
end do
do jj = 1,l1
   if (dcpabs(hr(n),hi(n)) <= 10.d0*eta*dcpabs(pr(n),pi(n))) &
      & go to 30
   call cdivid(-pr(nn),-pi(nn),hr(n),hi(n),tr,ti)
   do i = 1,nm1
      j = nn - i
      t1 = hr(j - 1)
      t2 = hi(j - 1)
      hr(j) = tr*t1 - ti*t2 + pr(j)
      hi(j) = tr*t2 + ti*t1 + pi(j)
   end do
   hr(1) = pr(1)
   hi(1) = pi(1)
   go to 50
!     If the constant term is essentially zero, shift H coefficients.
30 do i = 1,nm1
      j = nn - i
      hr(j) = hr(j - 1)
      hi(j) = hi(j - 1)
   end do
   hr(1) = 0.d0
   hi(1) = 0.d0
50 continue
end do
end subroutine noshft

pure subroutine fxshft(l2,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi, &
   & qhr,qhi,shr,shi,sr,si,tr,ti,pvr,pvi, &
   & are,mre,eta,infin)
!! <!-- nswc-ford:begin FXSHFT -->
!! Reference for `fxshft`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Computes l2 fixed-shift H polynomials and tests for convergence.
!!      Initiates a variable-shift iteration and returns with the
!!      approximate zero if successful.
!!      l2 - Limit of fixed-shift steps
!!      zr,zi - Approximate zero if conv is .TRUE.
!!      conv - Logical variable indicating convergence of stage 3
!!             iteration
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l2, nn
double precision, intent(inout) :: sr, si, tr, ti, pvr, pvi
double precision, intent(in) :: are, mre, eta, infin, pr(nn), &
   & pi(nn)
double precision, intent(inout) :: qpr(nn), qpi(nn), hr(nn), &
   & hi(nn), qhr(nn), qhi(nn), shr(nn), shi(nn)
double precision, intent(inout) :: zr, zi
logical, intent(inout) :: conv
!     beginning of local variable declarations
integer :: i, j, n
double precision :: otr, oti, svsr, svsi
logical :: test, pasd, bool
interface
   pure subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr, &
      & qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(inout) :: bool
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(inout) :: tr
      double precision, intent(inout) :: ti
      double precision, intent(in) :: pvr
      double precision, intent(in) :: pvi
      double precision, intent(in) :: are
      double precision, intent(in) :: hr(n)
      double precision, intent(in) :: hi(n)
      double precision, intent(inout) :: qhr(n)
      double precision, intent(inout) :: qhi(n)
   end subroutine calct
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(in) :: bool
      double precision, intent(in) :: tr
      double precision, intent(in) :: ti
      double precision, intent(inout) :: hr(n)
      double precision, intent(inout) :: hi(n)
      double precision, intent(in) :: qpr(n)
      double precision, intent(in) :: qpi(n)
      double precision, intent(in) :: qhr(n)
      double precision, intent(in) :: qhi(n)
   end subroutine nexth
   pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(in) :: pr(n)
      double precision, intent(in) :: pi(n)
      double precision, intent(inout) :: qr(n)
      double precision, intent(inout) :: qi(n)
      double precision, intent(out) :: pvr
      double precision, intent(out) :: pvi
   end subroutine polyev
   pure subroutine vrshft(l3,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr, &
      & qhi,sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
      implicit none
      integer, intent(in) :: nn
      integer, intent(in) :: l3
      double precision, intent(inout) :: zr
      double precision, intent(inout) :: zi
      logical, intent(out) :: conv
      double precision, intent(in) :: pr(nn)
      double precision, intent(in) :: pi(nn)
      double precision, intent(inout) :: hr(nn)
      double precision, intent(inout) :: hi(nn)
      double precision, intent(inout) :: qpr(nn)
      double precision, intent(inout) :: qpi(nn)
      double precision, intent(inout) :: qhr(nn)
      double precision, intent(inout) :: qhi(nn)
      double precision, intent(out) :: sr
      double precision, intent(out) :: si
      double precision, intent(inout) :: tr
      double precision, intent(inout) :: ti
      double precision, intent(inout) :: pvr
      double precision, intent(inout) :: pvi
      double precision, intent(in) :: are
      double precision, intent(in) :: mre
      double precision, intent(in) :: eta
      double precision, intent(in) :: infin
   end subroutine vrshft
end interface
!     Computes l2 fixed-shift H polynomials and tests for convergence.
!     Initiates a variable-shift iteration and returns with the
!     approximate zero if successful.
!     l2 - Limit of fixed-shift steps
!     zr,zi - Approximate zero if conv is .TRUE.
!     conv - Logical variable indicating convergence of stage 3
!            iteration
n = nn - 1
!     Evaluate P at S
call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
test = .true.
pasd = .false.
!     CALCULATE T = -P(S)/H(S)
call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
!     Main loop for one second stage step.
do j = 1,l2
   otr = tr
   oti = ti
!     Compute next H polynomial and new T.
   call nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
   call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
   zr = sr + tr
   zi = si + ti
!     Test for convergence unless stage 3 has failed once or this
!     is the last H polynomial.
   if (bool .or. (.not. test) .or. j == l2) go to 50
   if (dcpabs(tr - otr,ti - oti) >= 0.5d0*dcpabs(zr,zi)) &
      & go to 40
   if (.not. pasd) go to 30
!     The weak convergence test has been passed twice. Start the
!     third shift iteration after saving the current H polynomial
!     and shift.
   do i = 1,n
      shr(i) = hr(i)
      shi(i) = hi(i)
   end do
   svsr = sr
   svsi = si
   call vrshft(10,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr, &
      & qhi,sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
   if (conv) return
!     The iteration failed to converge. Turn off testing and restore
!     H,S,PV AND T.
   test = .false.
   do i = 1,n
      hr(i) = shr(i)
      hi(i) = shi(i)
   end do
   sr = svsr
   si = svsi
   call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
   call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
   go to 50
30 pasd = .true.
   go to 50
40 pasd = .false.
50 continue
end do
!     Attempt an iteration with final H polynomial from second stage.
call vrshft(10,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr,qhi, &
   & sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
end subroutine fxshft

pure subroutine vrshft(l3,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr,qhi, &
   & sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
!! <!-- nswc-ford:begin VRSHFT -->
!! Reference for `vrshft`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Carries out the third stage iteration.
!!      l3 - Limit of steps in stage 3.
!!      zr,zi - On entry contain the initial iterate. If the
!!              iteration converges zr,zi contain the final
!!              iterate on exit.
!!      conv  - The value is .TRUE. if the iteration converges.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l3, nn
double precision, intent(out) :: sr, si
double precision, intent(inout) :: tr, ti, pvr, pvi
double precision, intent(in) :: are, mre, eta, infin, pr(nn), &
   & pi(nn)
double precision, intent(inout) :: qpr(nn), qpi(nn), hr(nn), &
   & hi(nn), qhr(nn), qhi(nn)
double precision, intent(inout) :: zr, zi
logical, intent(out) :: conv
!     beginning of local variable declarations
integer :: i, j, n
double precision :: mp, ms, omp, relstp, r1, r2, tp
logical :: b, bool
interface
   pure subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr, &
      & qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(inout) :: bool
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(inout) :: tr
      double precision, intent(inout) :: ti
      double precision, intent(in) :: pvr
      double precision, intent(in) :: pvi
      double precision, intent(in) :: are
      double precision, intent(in) :: hr(n)
      double precision, intent(in) :: hi(n)
      double precision, intent(inout) :: qhr(n)
      double precision, intent(inout) :: qhi(n)
   end subroutine calct
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure function errev(nn,qr,qi,ms,mp,are,mre)
      implicit none
      integer, intent(in) :: nn
      double precision, intent(in) :: qr(nn)
      double precision, intent(in) :: qi(nn)
      double precision, intent(in) :: ms
      double precision, intent(in) :: mp
      double precision, intent(in) :: are
      double precision, intent(in) :: mre
      double precision :: errev
   end function errev
   pure subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(in) :: bool
      double precision, intent(in) :: tr
      double precision, intent(in) :: ti
      double precision, intent(inout) :: hr(n)
      double precision, intent(inout) :: hi(n)
      double precision, intent(in) :: qpr(n)
      double precision, intent(in) :: qpi(n)
      double precision, intent(in) :: qhr(n)
      double precision, intent(in) :: qhi(n)
   end subroutine nexth
   pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(in) :: pr(n)
      double precision, intent(in) :: pi(n)
      double precision, intent(inout) :: qr(n)
      double precision, intent(inout) :: qi(n)
      double precision, intent(out) :: pvr
      double precision, intent(out) :: pvi
   end subroutine polyev
end interface
!     Carries out the third stage iteration.
!     l3 - Limit of steps in stage 3.
!     zr,zi - On entry contain the initial iterate. If the
!             iteration converges zr,zi contain the final
!             iterate on exit.
!     conv  - The value is .TRUE. if the iteration converges.
conv = .false.
b = .false.
sr = zr
si = zi
n = nn - 1
!     Main loop for stage 3.
do i = 1,l3
!     Evaluate P at S and test for convergence.
   call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
   mp = dcpabs(pvr,pvi)
   ms = dcpabs(sr,si)
   if (mp > 20.d0*errev(nn,qpr,qpi,ms,mp,are,mre)) &
      & go to 10
!     Polynomial value is smaller than a bound on the error
!     in evaluating P. terminate the iteration.
   conv = .true.
   zr = sr
   zi = si
   return
10 if (i == 1) go to 40
   if (b .or. mp < omp .or. relstp >= 0.05d0) &
      & go to 30
!     Iteration has stalled. Probably a cluster of zeros. Do 5 fixed
!     shift steps into the cluster to force one zero to dominate.
   tp = relstp
   b = .true.
   if (relstp < eta) tp = eta
   r1 = sqrt(tp)
   r2 = sr*(1.d0 + r1) - si*r1
   si = sr*r1 + si*(1.d0 + r1)
   sr = r2
   call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
   do j = 1,5
      call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
      call nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
   end do
   omp = infin
   go to 50
!     Exit if the polynomial value increases significantly.
30 if (0.1d0*mp > omp) return
!     Calculate the next iterate.
40 omp = mp
50 call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
   call nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
   call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
   if (bool) go to 60
   relstp = dcpabs(tr,ti)/dcpabs(sr,si)
   sr = sr + tr
   si = si + ti
60 continue
end do
end subroutine vrshft

pure subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
!! <!-- nswc-ford:begin CALCT -->
!! Reference for `calct`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine computes T = -P(S)/H(S)
!!      bool - Logical variable, which is set to .TRUE. if H(S) is
!!             essentially zero.
!!      Evaluate H(S)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
logical, intent(inout) :: bool
double precision, intent(in) :: sr, si
double precision, intent(inout) :: tr, ti
double precision, intent(in) :: pvr, pvi, are, hr(n), hi(n)
double precision, intent(inout) :: qhr(n), qhi(n)
!     beginning of local variable declarations
double precision :: hvr, hvi
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
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(in) :: pr(n)
      double precision, intent(in) :: pi(n)
      double precision, intent(inout) :: qr(n)
      double precision, intent(inout) :: qi(n)
      double precision, intent(out) :: pvr
      double precision, intent(out) :: pvi
   end subroutine polyev
end interface
!     This subroutine computes T = -P(S)/H(S)
!     bool - Logical variable, which is set to .TRUE. if H(S) is
!            essentially zero.
!     Evaluate H(S)
call polyev(n,sr,si,hr,hi,qhr,qhi,hvr,hvi)
bool = dcpabs(hvr,hvi) <= 10.d0*are*dcpabs(hr(n),hi(n))
if (bool) go to 10
call cdivid(-pvr,-pvi,hvr,hvi,tr,ti)
return
10 tr = 0.d0
ti = 0.d0
end subroutine calct

pure subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
!! <!-- nswc-ford:begin NEXTH -->
!! Reference for `nexth`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the next shifted H polynomial.
!!      bool - Logical variable. If .TRUE. H(S) is essentially zero.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
logical, intent(in) :: bool
double precision, intent(in) :: tr, ti
double precision, intent(inout) :: hr(n), hi(n)
double precision, intent(in) :: qpr(n), qpi(n), qhr(n), qhi(n)
!     beginning of local variable declarations
integer :: j
double precision :: t1, t2
!     Calculates the next shifted H polynomial.
!     bool - Logical variable. If .TRUE. H(S) is essentially zero.
if (bool) go to 20
do j = 2,n
   t1 = qhr(j - 1)
   t2 = qhi(j - 1)
   hr(j) = tr*t1 - ti*t2 + qpr(j)
   hi(j) = tr*t2 + ti*t1 + qpi(j)
end do
hr(1) = qpr(1)
hi(1) = qpi(1)
return
!     If H(S) is zero then replace H with QH.
20 do j = 2,n
   hr(j) = qhr(j - 1)
   hi(j) = qhi(j - 1)
end do
hr(1) = 0.d0
hi(1) = 0.d0
end subroutine nexth

pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
!! <!-- nswc-ford:begin POLYEV -->
!! Reference for `polyev`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Evaluates a polynomial P at S by the Horner recurrence algo.,
!!      placing the partial sums in Q and the computed value in PV.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
double precision, intent(in) :: pr(n), pi(n)
double precision, intent(inout) :: qr(n), qi(n)
double precision, intent(in) :: sr, si
double precision, intent(out) :: pvr, pvi
!     beginning of local variable declarations
integer :: i
double precision :: t
!     Evaluates a polynomial P at S by the Horner recurrence algo.,
!     placing the partial sums in Q and the computed value in PV.
qr(1) = pr(1)
qi(1) = pi(1)
pvr = qr(1)
pvi = qi(1)
do i = 2,n
   t = pvr*sr - pvi*si + pr(i)
   pvi = pvr*si + pvi*sr + pi(i)
   pvr = t
   qr(i) = pvr
   qi(i) = pvi
end do
end subroutine polyev

pure double precision function errev(nn,qr,qi,ms,mp,are,mre)
!! <!-- nswc-ford:begin ERREV -->
!! Reference for `errev`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Bounds the error in evaluating the polynomial by the Horner
!!      recurrence algorithm.
!!      QR,qi   - THE PARTIAL SUMS
!!      ms      - Modulus of the point
!!      mp      - Modulus of the polynomial value
!!      are,mre - Error bounds on complex addition and multiplication
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: qr(nn), qi(nn), ms, mp, are, mre
!     beginning of local variable declarations
integer :: i
double precision :: e
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
!     Bounds the error in evaluating the polynomial by the Horner
!     recurrence algorithm.
!     QR,qi   - THE PARTIAL SUMS
!     ms      - Modulus of the point
!     mp      - Modulus of the polynomial value
!     are,mre - Error bounds on complex addition and multiplication
e = dcpabs(qr(1),qi(1))*mre/(are + mre)
do i = 1,nn
   e = e*ms + dcpabs(qr(i),qi(i))
end do
errev = e*(are + mre) - mp*mre
end function errev

pure subroutine rbnd(n, c, w, abserr, relerr, klust, ker)
!! <!-- nswc-ford:begin RBND -->
!! Reference for `rbnd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Abstract
!!          this routine computes error bounds and cluster counts
!!          for approximate zeros of a polynomial with real coefficients.
!!          The zeros may have been computed by any appropriate routine.
!!          The method used is based on the fact that the value of A
!!          polynomial at any point is equal to the leading coefficient
!!          times the product of the distances from that point to each
!!          of the zeros.  Given the value of the polynomial at an
!!          approximate zero, rbnd computes for each approximate zero
!!          the radius of a circle about that approximate zero which
!!          contains a true zero of the polynomial.  Using the known
!!          distribution of approximate zeros, an iterative procedure
!!          is used to shrink the radii of the circles.
!!      Description of arguments
!!          input---
!!          n      - Degree of the polynomial (number of zeros).
!!          c      - Real array of n+1 coefficients of the polynomial
!!                   c(1) + c(2)*z + ... + c(n+1)*z**n
!!          w      - Complex array of n approximate zeros.
!!          Output--
!!          abserr - Real array of n absolute error bounds.  abserr(I) is
!!                   the absolute error bound in the zero (WR(I),WI(I)).
!!          relerr - Real array of n relative error bounds.  relerr(I) is
!!                   the relative error bound in the zero (WR(I),WI(I)).
!!          klust  - Integer array of cluster counts for zeros.  The true
!!                   zero corresponding to I-TH approximate zero lies in
!!                   a circle of radius abserr(I). klust(I) is the number
!!                   of circles including the I-TH circle which overlap
!!                   the I-TH circle.  The cluster count often indicates
!!                   the multiplicity of a zero.
!!          ker    - An error flag
!!                 --normal code
!!                   0  means the bounds and counts were computed.
!!                 --Abnormal codes
!!                   1  n (DEGREE) must be .GE. 1
!!                   2  leading coefficient is zero
!!
!!      Written by carl b. bailey and modified by william r. gavin
!!         Sandia Laboratories
!!         albuquerque, new mexico
!!         January 1976
!!      modified by A.H. Morris (NSWC)
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ker
integer, intent(in) :: n
complex, intent(in) :: w(n)
integer, intent(inout) :: klust(n)
real, intent(in) :: c(*)
real, intent(inout) :: abserr(n), relerr(n)
!     beginning of local variable declarations
integer :: j, jp1, k, l, m, nm1, np1
real :: b, cert, dist, eps, olderr, p, power, r, rat, wnrm, wrad
complex :: z
double precision :: xr, xi, vr, vi, vt
logical :: shrunk
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Abstract
!         this routine computes error bounds and cluster counts
!         for approximate zeros of a polynomial with real coefficients.
!         The zeros may have been computed by any appropriate routine.
!         The method used is based on the fact that the value of A
!         polynomial at any point is equal to the leading coefficient
!         times the product of the distances from that point to each
!         of the zeros.  Given the value of the polynomial at an
!         approximate zero, rbnd computes for each approximate zero
!         the radius of a circle about that approximate zero which
!         contains a true zero of the polynomial.  Using the known
!         distribution of approximate zeros, an iterative procedure
!         is used to shrink the radii of the circles.
!     Description of arguments
!         input---
!         n      - Degree of the polynomial (number of zeros).
!         c      - Real array of n+1 coefficients of the polynomial
!                  c(1) + c(2)*z + ... + c(n+1)*z**n
!         w      - Complex array of n approximate zeros.
!         Output--
!         abserr - Real array of n absolute error bounds.  abserr(I) is
!                  the absolute error bound in the zero (WR(I),WI(I)).
!         relerr - Real array of n relative error bounds.  relerr(I) is
!                  the relative error bound in the zero (WR(I),WI(I)).
!         klust  - Integer array of cluster counts for zeros.  The true
!                  zero corresponding to I-TH approximate zero lies in
!                  a circle of radius abserr(I). klust(I) is the number
!                  of circles including the I-TH circle which overlap
!                  the I-TH circle.  The cluster count often indicates
!                  the multiplicity of a zero.
!         ker    - An error flag
!                --normal code
!                  0  means the bounds and counts were computed.
!                --Abnormal codes
!                  1  n (DEGREE) must be .GE. 1
!                  2  leading coefficient is zero
!-------------------
!     Written by carl b. bailey and modified by william r. gavin
!        Sandia Laboratories
!        albuquerque, new mexico
!        January 1976
!     modified by A.H. Morris (NSWC)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-----------------------------------------------------------------------
if (n < 1) go to 200
np1 = n + 1
power = 1.0/float(n)
p = abs(c(np1))
if (p == 0.0) go to 210
rat = 4.0*eps*abs(c(1))/p
do l = 1,n
   xr = real(w(l))
   xi = aimag(w(l))
   vr = c(np1)
   vi = 0.0d0
   do j = 1,n
      m = np1 - j
      vt = xr*vr - xi*vi + dble(c(m))
      vi = xr*vi + xi*vr
      vr = vt
   end do
   b = max(rat,cpabs(sngl(vr),sngl(vi))/p)
!        Save product of distances temporarily
   relerr(l) = b
   abserr(l) = b ** power
end do
30 shrunk = .false.
do j = 1,n
   if (abserr(j) == 0.0) go to 50
   p = 1.0
   m = n
   do k = 1,n
      if (k == j) go to 40
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      cert = dist - abserr(k)
      if (cert < abserr(j)) go to 40
      p = p*cert
      m = m - 1
40    continue
   end do
   olderr = abserr(j)
   abserr(j) = relerr(j)/p
   if (m > 1) abserr(j) = abserr(j)**(1.0/float(m))
   if (abserr(j) < olderr*0.99) shrunk = .true.
50 continue
end do
if (shrunk) go to 30
do j = 1,n
   klust(j) = 1
   wrad = abserr(j)
   wnrm = cpabs(real(w(j)),aimag(w(j)))
   if (wrad /= 0.0) go to 60
   r = 0.0
   go to 80
60 if (wnrm /= 0.0) go to 70
   r = -1.0
   go to 80
70 r = wrad/wnrm
80 relerr(j) = r
end do
nm1 = n - 1
do j = 1,nm1
   jp1 = j + 1
   do k = jp1,n
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      if (dist > (abserr(j) + abserr(k))) go to 90
      klust(j) = klust(j) + 1
      klust(k) = klust(k) + 1
90    continue
   end do
end do
ker = 0
return
!             Error return
200 ker = 1
return
210 ker = 2
end subroutine rbnd

pure subroutine cbnd(n, c, w, abserr, relerr, klust, ker)
!! <!-- nswc-ford:begin CBND -->
!! Reference for `cbnd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Abstract
!!          this routine computes error bounds and cluster counts for
!!          approximate zeros of a polynomial with complex coefficients.
!!          The zeros may have been computed by any appropriate routine.
!!          The method used is based on the fact that the value of A
!!          polynomial at any point is equal to the leading coefficient
!!          times the product of the distances from that point to each
!!          of the zeros.  Given the value of the polynomial at an
!!          approximate zero, cbnd computes for each approximate zero
!!          the radius of a circle about that approximate zero which
!!          contains a true zero of the polynomial.  Using the known
!!          distribution of approximate zeros, an iterative procedure
!!          is used to shrink the radii of the circles.
!!      Description of arguments
!!          input---
!!          n      - Degree of the polynomial (number of zeros).
!!          c      - Complex array of n+1 coefficients of the polynomial
!!                   c(1) + c(2)*z + ... + c(n+1)*z**n
!!          w      - Complex array of n approximate zeros.
!!          Output--
!!          abserr - Real array of absolute error bounds.  abserr(I) is
!!                   the absolute error bound in the zero (WR(I),WI(I)).
!!          relerr - Real array of relative error bounds.  relerr(I) is
!!                   the relative error bound in the zero (WR(I),WI(I)).
!!          klust  - Integer array of cluster counts for zeros.  The true
!!                   zero corresponding to I-TH approximate zero lies in
!!                   a circle of radius abserr(I).  klust(I) is the number
!!                   of circles including the I-TH circle which overlap
!!                   the I-TH circle.  The cluster count often indicates
!!                   the multiplicity of a zero.
!!          ker    - An error code
!!                 --normal codes
!!                   0  means the bounds and counts were computed.
!!                 --Abnormal codes
!!                   1  n (DEGREE) must be .GE. 1
!!                   2  leading coefficient is zero
!!
!!      Written by carl b. bailey and modified by william r. gavin
!!         Sandia Laboratories
!!         albuquerque, new mexico
!!         January 1976
!!      modified by A.H. Morris (NSWC)
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ker
integer, intent(in) :: n
complex, intent(in) :: c(*), w(n)
integer, intent(inout) :: klust(n)
real, intent(inout) :: abserr(n), relerr(n)
!     beginning of local variable declarations
integer :: j, jp1, k, l, m, nm1, np1
real :: b, cert, dist, eps, olderr, p, power, r, rat, wnrm, wrad
complex :: z
double precision :: xr, xi, vr, vi, vt
logical :: shrunk
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Abstract
!         this routine computes error bounds and cluster counts for
!         approximate zeros of a polynomial with complex coefficients.
!         The zeros may have been computed by any appropriate routine.
!         The method used is based on the fact that the value of A
!         polynomial at any point is equal to the leading coefficient
!         times the product of the distances from that point to each
!         of the zeros.  Given the value of the polynomial at an
!         approximate zero, cbnd computes for each approximate zero
!         the radius of a circle about that approximate zero which
!         contains a true zero of the polynomial.  Using the known
!         distribution of approximate zeros, an iterative procedure
!         is used to shrink the radii of the circles.
!     Description of arguments
!         input---
!         n      - Degree of the polynomial (number of zeros).
!         c      - Complex array of n+1 coefficients of the polynomial
!                  c(1) + c(2)*z + ... + c(n+1)*z**n
!         w      - Complex array of n approximate zeros.
!         Output--
!         abserr - Real array of absolute error bounds.  abserr(I) is
!                  the absolute error bound in the zero (WR(I),WI(I)).
!         relerr - Real array of relative error bounds.  relerr(I) is
!                  the relative error bound in the zero (WR(I),WI(I)).
!         klust  - Integer array of cluster counts for zeros.  The true
!                  zero corresponding to I-TH approximate zero lies in
!                  a circle of radius abserr(I).  klust(I) is the number
!                  of circles including the I-TH circle which overlap
!                  the I-TH circle.  The cluster count often indicates
!                  the multiplicity of a zero.
!         ker    - An error code
!                --normal codes
!                  0  means the bounds and counts were computed.
!                --Abnormal codes
!                  1  n (DEGREE) must be .GE. 1
!                  2  leading coefficient is zero
!-------------------
!     Written by carl b. bailey and modified by william r. gavin
!        Sandia Laboratories
!        albuquerque, new mexico
!        January 1976
!     modified by A.H. Morris (NSWC)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-----------------------------------------------------------------------
if (n < 1) go to 200
np1 = n + 1
power = 1.0/float(n)
p = cpabs(real(c(np1)),aimag(c(np1)))
if (p == 0.0) go to 210
rat = 4.0*eps*cpabs(real(c(1)),aimag(c(1)))/p
do l = 1,n
   xr = real(w(l))
   xi = aimag(w(l))
   vr = real(c(np1))
   vi = aimag(c(np1))
   do j = 1,n
      m = np1 - j
      vt = xr*vr - xi*vi + dble(real(c(m)))
      vi = xr*vi + xi*vr + dble(aimag(c(m)))
      vr = vt
   end do
   b = max(rat,cpabs(sngl(vr),sngl(vi))/p)
!        Save product of distances temporarily
   relerr(l) = b
   abserr(l) = b ** power
end do
30 shrunk = .false.
do j = 1,n
   if (abserr(j) == 0.0) go to 50
   p = 1.0
   m = n
   do k = 1,n
      if (k == j) go to 40
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      cert = dist - abserr(k)
      if (cert < abserr(j)) go to 40
      p = p*cert
      m = m - 1
40    continue
   end do
   olderr = abserr(j)
   abserr(j) = relerr(j)/p
   if (m > 1) abserr(j) = abserr(j)**(1.0/float(m))
   if (abserr(j) < olderr*0.99) shrunk = .true.
50 continue
end do
if (shrunk) go to 30
do j = 1,n
   klust(j) = 1
   wrad = abserr(j)
   wnrm = cpabs(real(w(j)),aimag(w(j)))
   if (wrad /= 0.0) go to 60
   r = 0.0
   go to 80
60 if (wnrm /= 0.0) go to 70
   r = -1.0
   go to 80
70 r = wrad/wnrm
80 relerr(j) = r
end do
nm1 = n - 1
do j = 1,nm1
   jp1 = j + 1
   do k = jp1,n
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      if (dist > (abserr(j) + abserr(k))) go to 90
      klust(j) = klust(j) + 1
      klust(k) = klust(k) + 1
90    continue
   end do
end do
ker = 0
return
!             Error return
200 ker = 1
return
210 ker = 2
end subroutine cbnd

pure subroutine  scopy(n,sx,incx,sy,incy)
!! <!-- nswc-ford:begin SCOPY -->
!! Reference for `scopy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Copies a vector, X, to a vector, Y.
!!      Uses unrolled loops for increments equal to 1.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Copies a vector, X, to a vector, Y.
!     Uses unrolled loops for increments equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(in) :: sx(*)
real, intent(inout) :: sy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, ix, iy, m, mp1
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   sy(iy) = sx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!        Code for both increments equal to 1
!        clean-up loop
20 m = mod(n,7)
if (m == 0) go to 40
do i = 1,m
   sy(i) = sx(i)
end do
if (n < 7) return
40 mp1 = m + 1
do i = mp1,n,7
   sy(i) = sx(i)
   sy(i + 1) = sx(i + 1)
   sy(i + 2) = sx(i + 2)
   sy(i + 3) = sx(i + 3)
   sy(i + 4) = sx(i + 4)
   sy(i + 5) = sx(i + 5)
   sy(i + 6) = sx(i + 6)
end do
end subroutine scopy

pure subroutine  dcopy(n,dx,incx,dy,incy)
!! <!-- nswc-ford:begin DCOPY -->
!! Reference for `dcopy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Copies a vector, X, to a vector, Y.
!!      Uses unrolled loops for increments equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Copies a vector, X, to a vector, Y.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(in) :: dx(*)
double precision, intent(inout) :: dy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, ix, iy, m, mp1
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   dy(iy) = dx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!        Code for both increments equal to 1
!        clean-up loop
20 m = mod(n,7)
if (m == 0) go to 40
do i = 1,m
   dy(i) = dx(i)
end do
if (n < 7) return
40 mp1 = m + 1
do i = mp1,n,7
   dy(i) = dx(i)
   dy(i + 1) = dx(i + 1)
   dy(i + 2) = dx(i + 2)
   dy(i + 3) = dx(i + 3)
   dy(i + 4) = dx(i + 4)
   dy(i + 5) = dx(i + 5)
   dy(i + 6) = dx(i + 6)
end do
end subroutine dcopy

pure subroutine  ccopy(n,cx,incx,cy,incy)
!! <!-- nswc-ford:begin CCOPY -->
!! Reference for `ccopy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Copies a vector, X, to a vector, Y.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Copies a vector, X, to a vector, Y.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(in) :: cx(*)
complex, intent(inout) :: cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, ix, iy
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   cy(iy) = cx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!        Code for both increments equal to 1
20 do i = 1,n
   cy(i) = cx(i)
end do
end subroutine ccopy

pure subroutine iswap(n,ix,incx,iy,incy)
!! <!-- nswc-ford:begin ISWAP -->
!! Reference for `iswap`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Extended B L A S  subprogram
!!     description of parameters
!!      --input--
!!         n  number of elements in input vector(S)
!!        ix  integer vector with n elements
!!      incx  storage spacing between elements of ix
!!        iy  integer vector with n elements
!!      incy  storage spacing between elements of iy
!!      --output--
!!        ix  INPUT VECTOR iy (UNCHANGED IF n .LE. 0)
!!        iy  INPUT VECTOR ix (UNCHANGED IF n .LE. 0)
!!      interchange integer ix and integer iy.
!!      For i = 0 To n-1, interchange  ix(LX+i*incx) and iy(LY+i*incy),
!!      WHERE LX = 1 IF incx .GE. 0, ELSE LX = (-incx)*n, AND LY IS
!!      defined in a similar way using incy.
!! ***AUTHOR  VANDEVENDER, W. (SNLA), 1985
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: incx, incy, n
integer, intent(inout) :: ix(*), iy(*)
!     beginning of local variable declarations
integer :: i, iix, iiy, m, mp1, ns, itemp1, itemp2, itemp3, nswc_ai_i4
!                Extended B L A S  subprogram
!    description of parameters
!     --input--
!        n  number of elements in input vector(S)
!       ix  integer vector with n elements
!     incx  storage spacing between elements of ix
!       iy  integer vector with n elements
!     incy  storage spacing between elements of iy
!     --output--
!       ix  INPUT VECTOR iy (UNCHANGED IF n .LE. 0)
!       iy  INPUT VECTOR ix (UNCHANGED IF n .LE. 0)
!     interchange integer ix and integer iy.
!     For i = 0 To n-1, interchange  ix(LX+i*incx) and iy(LY+i*incy),
!     WHERE LX = 1 IF incx .GE. 0, ELSE LX = (-incx)*n, AND LY IS
!     defined in a similar way using incy.
!***AUTHOR  VANDEVENDER, W. (SNLA), 1985
if (n <= 0) return
if (incx /= incy) go to 5
nswc_ai_i4 = incx - 1
if (nswc_ai_i4 < 0) go to 5
if (nswc_ai_i4 == 0) go to 20
go to 60
5 continue
!       Code for unequal or nonpositive increments.
iix = 1
iiy = 1
if (incx < 0) iix = (1 - n)*incx + 1
if (incy < 0) iiy = (1 - n)*incy + 1
do i = 1,n
   itemp1 = ix(iix)
   ix(iix) = iy(iiy)
   iy(iiy) = itemp1
   iix = iix + incx
   iiy = iiy + incy
end do
return
!       Code for both increments equal to 1
!       clean-up loop so remaining vector LENGTH is a multiple of 3.
20 m = mod(n,3)
if (m == 0) go to 40
do i = 1,m
   itemp1 = ix(i)
   ix(i) = iy(i)
   iy(i) = itemp1
end do
if (n < 3) return
40 mp1 = m + 1
do i = mp1,n,3
   itemp1 = ix(i)
   itemp2 = ix(i + 1)
   itemp3 = ix(i + 2)
   ix(i) = iy(i)
   ix(i + 1) = iy(i + 1)
   ix(i + 2) = iy(i + 2)
   iy(i) = itemp1
   iy(i + 1) = itemp2
   iy(i + 2) = itemp3
end do
return
!     Code for equal, positive, nonunit increments.
60 ns = n*incx
do i = 1,ns,incx
   itemp1 = ix(i)
   ix(i) = iy(i)
   iy(i) = itemp1
end do
end subroutine iswap

pure subroutine  sswap(n,sx,incx,sy,incy)
!! <!-- nswc-ford:begin SSWAP -->
!! Reference for `sswap`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Interchanges two vectors.
!!      Uses unrolled loops for increments equal to 1.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Interchanges two vectors.
!     Uses unrolled loops for increments equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(inout) :: sx(*), sy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
real :: stemp
integer :: i, ix, iy, m, mp1
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!       Code for unequal increments or equal increments not equal
!         to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   stemp = sx(ix)
   sx(ix) = sy(iy)
   sy(iy) = stemp
   ix = ix + incx
   iy = iy + incy
end do
return
!       Code for both increments equal to 1
!       clean-up loop
20 m = mod(n,3)
if (m == 0) go to 40
do i = 1,m
   stemp = sx(i)
   sx(i) = sy(i)
   sy(i) = stemp
end do
if (n < 3) return
40 mp1 = m + 1
do i = mp1,n,3
   stemp = sx(i)
   sx(i) = sy(i)
   sy(i) = stemp
   stemp = sx(i + 1)
   sx(i + 1) = sy(i + 1)
   sy(i + 1) = stemp
   stemp = sx(i + 2)
   sx(i + 2) = sy(i + 2)
   sy(i + 2) = stemp
end do
end subroutine sswap

pure subroutine  dswap(n,dx,incx,dy,incy)
!! <!-- nswc-ford:begin DSWAP -->
!! Reference for `dswap`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Interchanges two vectors.
!!      Uses unrolled loops for increments equal one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Interchanges two vectors.
!     Uses unrolled loops for increments equal one.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(inout) :: dx(*), dy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
double precision :: dtemp
integer :: i, ix, iy, m, mp1
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!       Code for unequal increments or equal increments not equal
!         to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   dtemp = dx(ix)
   dx(ix) = dy(iy)
   dy(iy) = dtemp
   ix = ix + incx
   iy = iy + incy
end do
return
!       Code for both increments equal to 1
!       clean-up loop
20 m = mod(n,3)
if (m == 0) go to 40
do i = 1,m
   dtemp = dx(i)
   dx(i) = dy(i)
   dy(i) = dtemp
end do
if (n < 3) return
40 mp1 = m + 1
do i = mp1,n,3
   dtemp = dx(i)
   dx(i) = dy(i)
   dy(i) = dtemp
   dtemp = dx(i + 1)
   dx(i + 1) = dy(i + 1)
   dy(i + 1) = dtemp
   dtemp = dx(i + 2)
   dx(i + 2) = dy(i + 2)
   dy(i + 2) = dtemp
end do
end subroutine dswap

pure subroutine  cswap(n,cx,incx,cy,incy)
!! <!-- nswc-ford:begin CSWAP -->
!! Reference for `cswap`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Interchanges two vectors.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Interchanges two vectors.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(inout) :: cx(*), cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
complex :: ctemp
integer :: i, ix, iy
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!       Code for unequal increments or equal increments not equal
!         to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = cx(ix)
   cx(ix) = cy(iy)
   cy(iy) = ctemp
   ix = ix + incx
   iy = iy + incy
end do
return
!       Code for both increments equal to 1
20 do i = 1,n
   ctemp = cx(i)
   cx(i) = cy(i)
   cy(i) = ctemp
end do
end subroutine cswap

pure subroutine  srot(n,sx,incx,sy,incy,c,s)
!! <!-- nswc-ford:begin SROT -->
!! Reference for `srot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Applies a plane rotation.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Applies a plane rotation.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(inout) :: sx(*), sy(*)
real, intent(in) :: c, s
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
real :: stemp
integer :: i, ix, iy
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!       Code for unequal increments or equal increments not equal
!         to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   stemp = c*sx(ix) + s*sy(iy)
   sy(iy) = c*sy(iy) - s*sx(ix)
   sx(ix) = stemp
   ix = ix + incx
   iy = iy + incy
end do
return
!       Code for both increments equal to 1
20 do i = 1,n
   stemp = c*sx(i) + s*sy(i)
   sy(i) = c*sy(i) - s*sx(i)
   sx(i) = stemp
end do
end subroutine srot

pure subroutine  drot(n,dx,incx,dy,incy,c,s)
!! <!-- nswc-ford:begin DROT -->
!! Reference for `drot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Applies a plane rotation.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Applies a plane rotation.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(inout) :: dx(*), dy(*)
double precision, intent(in) :: c, s
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
double precision :: dtemp
integer :: i, ix, iy
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!       Code for unequal increments or equal increments not equal
!         to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   dtemp = c*dx(ix) + s*dy(iy)
   dy(iy) = c*dy(iy) - s*dx(ix)
   dx(ix) = dtemp
   ix = ix + incx
   iy = iy + incy
end do
return
!       Code for both increments equal to 1
20 do i = 1,n
   dtemp = c*dx(i) + s*dy(i)
   dy(i) = c*dy(i) - s*dx(i)
   dx(i) = dtemp
end do
end subroutine drot

pure subroutine  csrot(n,cx,incx,cy,incy,c,s)
!! <!-- nswc-ford:begin CSROT -->
!! Reference for `csrot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Applies a plane rotation, where the cos and sin (c and s) are real
!!      and the vectors cx and cy are complex.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Applies a plane rotation, where the cos and sin (c and s) are real
!     and the vectors cx and cy are complex.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(inout) :: cx(*), cy(*)
real, intent(in) :: c, s
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
complex :: ctemp
integer :: i, ix, iy
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!       Code for unequal increments or equal increments not equal
!         to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = c*cx(ix) + s*cy(iy)
   cy(iy) = c*cy(iy) - s*cx(ix)
   cx(ix) = ctemp
   ix = ix + incx
   iy = iy + incy
end do
return
!       Code for both increments equal to 1
20 do i = 1,n
   ctemp = c*cx(i) + s*cy(i)
   cy(i) = c*cy(i) - s*cx(i)
   cx(i) = ctemp
end do
end subroutine csrot

pure subroutine srotmg(sd1,sd2,sx1,sy1,sparam)
!! <!-- nswc-ford:begin SROTMG -->
!! Reference for `srotmg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Construct the modified Givens transformation matrix H which zeros
!!      the second component of the 2-vector  (sqrt(sd1)*sx1,sqrt(sd2)*
!!      sy1)**T.
!!      With sparam(1)=sflag, H has one of the following forms..
!!      sflag=-1.e0     sflag=0.e0        sflag=1.e0     sflag=-2.e0
!!        (sh11  sh12)    (1.E0  sh12)    (sh11  1.E0)    (1.E0  0.E0)
!!      h=(          )    (          )    (          )    (          )
!!        (sh21  sh22),   (sh21  1.E0),   (-1.E0 sh22),   (0.E0  1.E0).
!!      Locations 2-4 of sparam contain sh11,sh21,sh12, and sh22
!!      respectively. (Values of 1.E0, -1.E0, or 0.E0 implied by the
!!      value of sparam(1) are not stored in sparam.)
!!      it is assumed that gamsq = gam*gam and rgamsq = one/(gam*gam).
!!      The values of gamsq and rgamsq set in the data statement may be
!!      inexact.  This is OK as they are only used for testing the size
!!      of sd1 and sd2.  All actual scaling of data is done using gam.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(inout) :: sd1, sd2, sparam(5), sx1
real, intent(in) :: sy1
!     beginning of local variable declarations
real :: sflag, sh11, sh12, sh21, sh22, sp1, sp2, sq1, sq2, stemp, su, nswc_ai_r4
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: two = 2.e0
real, parameter :: gam = 4096.e0
real, parameter :: gamsq = 1.67772e7
real, parameter :: rgamsq = 5.96046e-8
!     Construct the modified Givens transformation matrix H which zeros
!     the second component of the 2-vector  (sqrt(sd1)*sx1,sqrt(sd2)*
!     sy1)**T.
!     With sparam(1)=sflag, H has one of the following forms..
!     sflag=-1.e0     sflag=0.e0        sflag=1.e0     sflag=-2.e0
!       (sh11  sh12)    (1.E0  sh12)    (sh11  1.E0)    (1.E0  0.E0)
!     h=(          )    (          )    (          )    (          )
!       (sh21  sh22),   (sh21  1.E0),   (-1.E0 sh22),   (0.E0  1.E0).
!     Locations 2-4 of sparam contain sh11,sh21,sh12, and sh22
!     respectively. (Values of 1.E0, -1.E0, or 0.E0 implied by the
!     value of sparam(1) are not stored in sparam.)
!     it is assumed that gamsq = gam*gam and rgamsq = one/(gam*gam).
!     The values of gamsq and rgamsq set in the data statement may be
!     inexact.  This is OK as they are only used for testing the size
!     of sd1 and sd2.  All actual scaling of data is done using gam.
if (sd1 < zero) go to 60
sp2 = sd2*sy1
if (sp2 /= zero) go to 20
sflag = -two
go to 260
!     Regular-case..
20 sp1 = sd1*sx1
sq1 = sp1*sx1
sq2 = sp2*sy1
if (abs(sq1) <= abs(sq2)) go to 40
sh21 = -sy1/sx1
sh12 = sp2/sp1
su = one - sh12*sh21
if (su <= zero) go to 60
sflag = zero
sh11 = one
sh22 = one
sd1 = sd1/su
sd2 = sd2/su
sx1 = sx1*su
!         Go scale-check..
go to 100
40 continue
if (sd2 < zero) go to 60
sflag = one
sh11 = sp1/sp2
sh21 = -one
sh12 = one
sh22 = sx1/sy1
su = one + sh11*sh22
stemp = sd2/su
sd2 = sd1/su
sd1 = stemp
sx1 = sy1*su
!         Go scale-check
go to 100
!     Procedure..zero-H-D-and-sx1..
60 continue
sflag = -one
sh11 = zero
sh12 = zero
sh21 = zero
sh22 = zero
sd1 = zero
sd2 = zero
sx1 = zero
go to 250
!     Procedure..scale-check
100 continue
110 continue
if (sd1 > rgamsq) go to 130
if (sd1 == zero) go to 160
sflag = -one
sd1 = sd1*(gam*gam)
sx1 = sx1/gam
sh11 = sh11/gam
sh12 = sh12/gam
go to 110
130 continue
140 continue
if (sd1 < gamsq) go to 160
sflag = -one
sd1 = sd1/(gam*gam)
sx1 = sx1*gam
sh11 = sh11*gam
sh12 = sh12*gam
go to 140
160 continue
170 continue
if (abs(sd2) > rgamsq) go to 190
if (sd2 == zero) go to 220
sflag = -one
sd2 = sd2*(gam*gam)
sh21 = sh21/gam
sh22 = sh22/gam
go to 170
190 continue
200 continue
if (abs(sd2) < gamsq) go to 220
sflag = -one
sd2 = sd2/(gam*gam)
sh21 = sh21*gam
sh22 = sh22*gam
go to 200
220 continue
nswc_ai_r4 = sflag
if (nswc_ai_r4 < 0) go to 250
if (nswc_ai_r4 == 0) go to 230
go to 240
230 continue
sparam(3) = sh21
sparam(4) = sh12
go to 260
240 continue
sparam(2) = sh11
sparam(5) = sh22
go to 260
250 continue
sparam(2) = sh11
sparam(3) = sh21
sparam(4) = sh12
sparam(5) = sh22
260 continue
sparam(1) = sflag
end subroutine srotmg

subroutine srotm(n,sx,incx,sy,incy,sparam)
!! <!-- nswc-ford:begin SROTM -->
!! Reference for `srotm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Apply the modified Givens transformation, H, to the 2 by n matrix
!!      (sx**T), where **T indicates transpose. The elements of sx are in
!!      (sy**T)
!!      sx(LX+i*incx), i = 0 TO n-1, WHERE LX = 1 IF incx .GE. 0, ELSE
!!      LX = (-incx)*n, and similarly for sy using using LY and incy.
!!      With sparam(1)=sflag, H has one of the following forms..
!!      sflag=-1.e0     sflag=0.e0        sflag=1.e0     sflag=-2.e0
!!        (sh11  sh12)    (1.E0  sh12)    (sh11  1.E0)    (1.E0  0.E0)
!!      h=(          )    (          )    (          )    (          )
!!        (sh21  sh22),   (sh21  1.E0),   (-1.E0 sh22),   (0.E0  1.E0).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: incx, incy, n
real, intent(in) :: sparam(5)
real, intent(inout) :: sx(*), sy(*)
!     beginning of local variable declarations
integer :: i, kx, ky, nsteps
real :: sflag, sh11, sh12, sh21, sh22, w, z, nswc_ai_r4
real, parameter :: zero = 0.e0
real, parameter :: two = 2.e0
!     Apply the modified Givens transformation, H, to the 2 by n matrix
!     (sx**T), where **T indicates transpose. The elements of sx are in
!     (sy**T)
!     sx(LX+i*incx), i = 0 TO n-1, WHERE LX = 1 IF incx .GE. 0, ELSE
!     LX = (-incx)*n, and similarly for sy using using LY and incy.
!     With sparam(1)=sflag, H has one of the following forms..
!     sflag=-1.e0     sflag=0.e0        sflag=1.e0     sflag=-2.e0
!       (sh11  sh12)    (1.E0  sh12)    (sh11  1.E0)    (1.E0  0.E0)
!     h=(          )    (          )    (          )    (          )
!       (sh21  sh22),   (sh21  1.E0),   (-1.E0 sh22),   (0.E0  1.E0).
sflag = sparam(1)
if (n <= 0 .or.(sflag + two == zero)) go to 140
if (.not.(incx == incy.and. incx > 0)) go to 70
nsteps = n*incx
nswc_ai_r4 = sflag
if (nswc_ai_r4 < 0) go to 50
if (nswc_ai_r4 == 0) go to 10
go to 30
10 continue
sh21 = sparam(3)
sh12 = sparam(4)
do i = 1,nsteps,incx
   w = sx(i)
   z = sy(i)
   sx(i) = w + z*sh12
   sy(i) = w*sh21 + z
end do
go to 140
30 continue
sh11 = sparam(2)
sh22 = sparam(5)
do i = 1,nsteps,incx
   w = sx(i)
   z = sy(i)
   sx(i) = w*sh11 + z
   sy(i) = -w + sh22*z
end do
go to 140
50 continue
sh11 = sparam(2)
sh21 = sparam(3)
sh12 = sparam(4)
sh22 = sparam(5)
do i = 1,nsteps,incx
   w = sx(i)
   z = sy(i)
   sx(i) = w*sh11 + z*sh12
   sy(i) = w*sh21 + z*sh22
end do
go to 140
70 continue
kx = 1
ky = 1
if (incx < 0) kx = 1 + (1 - n)*incx
if (incy < 0) ky = 1 + (1 - n)*incy
nswc_ai_r4 = sflag
if (nswc_ai_r4 < 0) go to 120
if (nswc_ai_r4 == 0) go to 80
go to 100
80 continue
sh21 = sparam(3)
sh12 = sparam(4)
do i = 1,n
   w = sx(kx)
   z = sy(ky)
   sx(kx) = w + z*sh12
   sy(ky) = w*sh21 + z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
100 continue
sh11 = sparam(2)
sh22 = sparam(5)
do i = 1,n
   w = sx(kx)
   z = sy(ky)
   sx(kx) = w*sh11 + z
   sy(ky) = -w + sh22*z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
120 continue
sh11 = sparam(2)
sh21 = sparam(3)
sh12 = sparam(4)
sh22 = sparam(5)
do i = 1,n
   w = sx(kx)
   z = sy(ky)
   sx(kx) = w*sh11 + z*sh12
   sy(ky) = w*sh21 + z*sh22
   kx = kx + incx
   ky = ky + incy
end do
140 continue
end subroutine srotm

pure subroutine drotmg(dd1,dd2,dx1,dy1,dparam)
!! <!-- nswc-ford:begin DROTMG -->
!! Reference for `drotmg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Construct the modified Givens transformation matrix H which zeros
!!      the second component of the 2-vector  (dsqrt(dd1)*dx1,dsqrt(dd2)*
!!      dy1)**T.
!!      With dparam(1)=dflag, H has one of the following forms..
!!      dflag=-1.d0     dflag=0.d0        dflag=1.d0     dflag=-2.d0
!!        (dh11  dh12)    (1.D0  dh12)    (dh11  1.D0)    (1.D0  0.D0)
!!      h=(          )    (          )    (          )    (          )
!!        (dh21  dh22),   (dh21  1.D0),   (-1.D0 dh22),   (0.D0  1.D0).
!!      Locations 2-4 of dparam contain dh11,dh21,dh12, and dh22
!!      respectively. (Values of 1.D0, -1.D0, or 0.D0 implied by the
!!      value of dparam(1) are not stored in dparam.)
!!      it is assumed that gamsq = gam*gam and rgamsq = one/(gam*gam).
!!      The values of gamsq and rgamsq set in the data statement may be
!!      inexact.  This is OK as they are only used for testing the size
!!      of dd1 and dd2.  All actual scaling of data is done using gam.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Construct the modified Givens transformation matrix H which zeros
!     the second component of the 2-vector  (dsqrt(dd1)*dx1,dsqrt(dd2)*
!     dy1)**T.
!     With dparam(1)=dflag, H has one of the following forms..
!     dflag=-1.d0     dflag=0.d0        dflag=1.d0     dflag=-2.d0
!       (dh11  dh12)    (1.D0  dh12)    (dh11  1.D0)    (1.D0  0.D0)
!     h=(          )    (          )    (          )    (          )
!       (dh21  dh22),   (dh21  1.D0),   (-1.D0 dh22),   (0.D0  1.D0).
!     Locations 2-4 of dparam contain dh11,dh21,dh12, and dh22
!     respectively. (Values of 1.D0, -1.D0, or 0.D0 implied by the
!     value of dparam(1) are not stored in dparam.)
!     it is assumed that gamsq = gam*gam and rgamsq = one/(gam*gam).
!     The values of gamsq and rgamsq set in the data statement may be
!     inexact.  This is OK as they are only used for testing the size
!     of dd1 and dd2.  All actual scaling of data is done using gam.
double precision, intent(inout) :: dd2
double precision, intent(inout) :: dparam(5)
double precision, intent(in) :: dy1
double precision, intent(inout) :: dd1
double precision, intent(inout) :: dx1
!     beginning of local variable declarations
double precision :: dh11, dh21, dp2, dq2, du, dflag, dh12, dh22, dp1, dq1, dtemp, nswc_ai_r8
double precision, parameter :: zero = 0.d0
double precision, parameter :: one = 1.d0
double precision, parameter :: two = 2.d0
double precision, parameter :: gam = 4096.d0
double precision, parameter :: gamsq = 16777216.d0
double precision, parameter :: rgamsq = 5.9604645d-8
if (dd1 < zero) go to 60
dp2 = dd2*dy1
if (dp2 /= zero) go to 20
dflag = -two
go to 260
!     Regular-case..
20 dp1 = dd1*dx1
dq1 = dp1*dx1
dq2 = dp2*dy1
if (abs(dq1) <= abs(dq2)) go to 40
dh21 = -dy1/dx1
dh12 = dp2/dp1
du = one - dh12*dh21
if (du <= zero) go to 60
dflag = zero
dh11 = one
dh22 = one
dd1 = dd1/du
dd2 = dd2/du
dx1 = dx1*du
!         Go scale-check..
go to 100
40 continue
if (dd2 < zero) go to 60
dflag = one
dh11 = dp1/dp2
dh21 = -one
dh12 = one
dh22 = dx1/dy1
du = one + dh11*dh22
dtemp = dd2/du
dd2 = dd1/du
dd1 = dtemp
dx1 = dy1*du
!         Go scale-check
go to 100
!     Procedure..zero-H-D-and-dx1..
60 continue
dflag = -one
dh11 = zero
dh12 = zero
dh21 = zero
dh22 = zero
dd1 = zero
dd2 = zero
dx1 = zero
go to 250
!     Procedure..scale-check
100 continue
110 continue
if (dd1 > rgamsq) go to 130
if (dd1 == zero) go to 160
dflag = -one
dd1 = dd1*(gam*gam)
dx1 = dx1/gam
dh11 = dh11/gam
dh12 = dh12/gam
go to 110
130 continue
140 continue
if (dd1 < gamsq) go to 160
dflag = -one
dd1 = dd1/(gam*gam)
dx1 = dx1*gam
dh11 = dh11*gam
dh12 = dh12*gam
go to 140
160 continue
170 continue
if (abs(dd2) > rgamsq) go to 190
if (dd2 == zero) go to 220
dflag = -one
dd2 = dd2*(gam*gam)
dh21 = dh21/gam
dh22 = dh22/gam
go to 170
190 continue
200 continue
if (abs(dd2) < gamsq) go to 220
dflag = -one
dd2 = dd2/(gam*gam)
dh21 = dh21*gam
dh22 = dh22*gam
go to 200
220 continue
nswc_ai_r8 = dflag
if (nswc_ai_r8 < 0) go to 250
if (nswc_ai_r8 == 0) go to 230
go to 240
230 continue
dparam(3) = dh21
dparam(4) = dh12
go to 260
240 continue
dparam(2) = dh11
dparam(5) = dh22
go to 260
250 continue
dparam(2) = dh11
dparam(3) = dh21
dparam(4) = dh12
dparam(5) = dh22
260 continue
dparam(1) = dflag
end subroutine drotmg

subroutine drotm(n,dx,incx,dy,incy,dparam)
!! <!-- nswc-ford:begin DROTM -->
!! Reference for `drotm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Apply the modified Givens transformation, H, to the 2 by n matrix
!!      (dx**T), where **T indicates transpose. The elements of dx are in
!!      (dy**T)
!!      dx(LX+i*incx), i = 0 TO n-1, WHERE LX = 1 IF incx .GE. 0, ELSE
!!      LX = (-incx)*n, and similarly for SY using LY and incy.
!!      With dparam(1)=dflag, H has one of the following forms..
!!      dflag=-1.d0     dflag=0.d0        dflag=1.d0     dflag=-2.d0
!!        (dh11  dh12)    (1.D0  dh12)    (dh11  1.D0)    (1.D0  0.D0)
!!      h=(          )    (          )    (          )    (          )
!!        (dh21  dh22),   (dh21  1.D0),   (-1.D0 dh22),   (0.D0  1.D0).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: incx, incy, n
double precision, intent(inout) :: dx(*)
double precision, intent(in) :: dparam(5)
double precision, intent(inout) :: dy(*)
!     beginning of local variable declarations
integer :: i, kx, ky, nsteps
double precision :: dflag, dh12, dh22, z, dh11, dh21, w, nswc_ai_r8
double precision, parameter :: zero = 0.d0
double precision, parameter :: two = 2.d0
!     Apply the modified Givens transformation, H, to the 2 by n matrix
!     (dx**T), where **T indicates transpose. The elements of dx are in
!     (dy**T)
!     dx(LX+i*incx), i = 0 TO n-1, WHERE LX = 1 IF incx .GE. 0, ELSE
!     LX = (-incx)*n, and similarly for SY using LY and incy.
!     With dparam(1)=dflag, H has one of the following forms..
!     dflag=-1.d0     dflag=0.d0        dflag=1.d0     dflag=-2.d0
!       (dh11  dh12)    (1.D0  dh12)    (dh11  1.D0)    (1.D0  0.D0)
!     h=(          )    (          )    (          )    (          )
!       (dh21  dh22),   (dh21  1.D0),   (-1.D0 dh22),   (0.D0  1.D0).
dflag = dparam(1)
if (n <= 0 .or.(dflag + two == zero)) go to 140
if (.not.(incx == incy.and. incx > 0)) go to 70
nsteps = n*incx
nswc_ai_r8 = dflag
if (nswc_ai_r8 < 0) go to 50
if (nswc_ai_r8 == 0) go to 10
go to 30
10 continue
dh21 = dparam(3)
dh12 = dparam(4)
do i = 1,nsteps,incx
   w = dx(i)
   z = dy(i)
   dx(i) = w + z*dh12
   dy(i) = w*dh21 + z
end do
go to 140
30 continue
dh11 = dparam(2)
dh22 = dparam(5)
do i = 1,nsteps,incx
   w = dx(i)
   z = dy(i)
   dx(i) = w*dh11 + z
   dy(i) = -w + dh22*z
end do
go to 140
50 continue
dh11 = dparam(2)
dh21 = dparam(3)
dh12 = dparam(4)
dh22 = dparam(5)
do i = 1,nsteps,incx
   w = dx(i)
   z = dy(i)
   dx(i) = w*dh11 + z*dh12
   dy(i) = w*dh21 + z*dh22
end do
go to 140
70 continue
kx = 1
ky = 1
if (incx < 0) kx = 1 + (1 - n)*incx
if (incy < 0) ky = 1 + (1 - n)*incy
nswc_ai_r8 = dflag
if (nswc_ai_r8 < 0) go to 120
if (nswc_ai_r8 == 0) go to 80
go to 100
80 continue
dh21 = dparam(3)
dh12 = dparam(4)
do i = 1,n
   w = dx(kx)
   z = dy(ky)
   dx(kx) = w + z*dh12
   dy(ky) = w*dh21 + z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
100 continue
dh11 = dparam(2)
dh22 = dparam(5)
do i = 1,n
   w = dx(kx)
   z = dy(ky)
   dx(kx) = w*dh11 + z
   dy(ky) = -w + dh22*z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
120 continue
dh11 = dparam(2)
dh21 = dparam(3)
dh12 = dparam(4)
dh22 = dparam(5)
do i = 1,n
   w = dx(kx)
   z = dy(ky)
   dx(kx) = w*dh11 + z*dh12
   dy(ky) = w*dh21 + z*dh22
   kx = kx + incx
   ky = ky + incy
end do
140 continue
end subroutine drotm

pure real function sdot(n,sx,incx,sy,incy)
!! <!-- nswc-ford:begin SDOT -->
!! Reference for `sdot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Forms the dot product of two vectors.
!!      Uses unrolled loops for increments equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Forms the dot product of two vectors.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(in) :: sx(*), sy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
real :: stemp
integer :: i, ix, iy, m, mp1
stemp = 0.0e0
sdot = 0.0e0
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   stemp = stemp + sx(ix)*sy(iy)
   ix = ix + incx
   iy = iy + incy
end do
sdot = stemp
return
!        Code for both increments equal to 1
!        clean-up loop
20 m = mod(n,5)
if (m == 0) go to 40
do i = 1,m
   stemp = stemp + sx(i)*sy(i)
end do
if (n < 5) go to 60
40 mp1 = m + 1
do i = mp1,n,5
   stemp = stemp + sx(i)*sy(i) + sx(i + 1)*sy(i + 1) + &
      & sx(i + 2)*sy(i + 2) + sx(i + 3)*sy(i + 3) + sx(i + 4)*sy(i + 4)
end do
60 sdot = stemp
end function sdot

pure double precision function ddot(n,dx,incx,dy,incy)
!! <!-- nswc-ford:begin DDOT -->
!! Reference for `ddot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Forms the dot product of two vectors.
!!      Uses unrolled loops for increments equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Forms the dot product of two vectors.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(in) :: dx(*), dy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
double precision :: dtemp
integer :: i, ix, iy, m, mp1
ddot = 0.0d0
dtemp = 0.0d0
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   dtemp = dtemp + dx(ix)*dy(iy)
   ix = ix + incx
   iy = iy + incy
end do
ddot = dtemp
return
!        Code for both increments equal to 1
!        clean-up loop
20 m = mod(n,5)
if (m == 0) go to 40
do i = 1,m
   dtemp = dtemp + dx(i)*dy(i)
end do
if (n < 5) go to 60
40 mp1 = m + 1
do i = mp1,n,5
   dtemp = dtemp + dx(i)*dy(i) + dx(i + 1)*dy(i + 1) + &
      & dx(i + 2)*dy(i + 2) + dx(i + 3)*dy(i + 3) + dx(i + 4)*dy(i + 4)
end do
60 ddot = dtemp
end function ddot

pure complex function cdotc(n,cx,incx,cy,incy)
!! <!-- nswc-ford:begin CDOTC -->
!! Reference for `cdotc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Forms the dot product of two vectors, conjugating the first
!!      vector.
!!      Jack dongarra, LINPACK,  3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Forms the dot product of two vectors, conjugating the first
!     vector.
!     Jack dongarra, LINPACK,  3/11/78.
complex, intent(in) :: cx(*), cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
complex :: ctemp
integer :: i, ix, iy
ctemp = (0.0,0.0)
cdotc = (0.0,0.0)
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = ctemp + conjg(cx(ix))*cy(iy)
   ix = ix + incx
   iy = iy + incy
end do
cdotc = ctemp
return
!        Code for both increments equal to 1
20 do i = 1,n
   ctemp = ctemp + conjg(cx(i))*cy(i)
end do
cdotc = ctemp
end function cdotc

pure complex function cdotu(n,cx,incx,cy,incy)
!! <!-- nswc-ford:begin CDOTU -->
!! Reference for `cdotu`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Forms the dot product of two vectors.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Forms the dot product of two vectors.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(in) :: cx(*), cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
complex :: ctemp
integer :: i, ix, iy
ctemp = (0.0,0.0)
cdotu = (0.0,0.0)
if (n <= 0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = ctemp + cx(ix)*cy(iy)
   ix = ix + incx
   iy = iy + incy
end do
cdotu = ctemp
return
!        Code for both increments equal to 1
20 do i = 1,n
   ctemp = ctemp + cx(i)*cy(i)
end do
cdotu = ctemp
end function cdotu

pure subroutine  sscal(n,sa,sx,incx)
!! <!-- nswc-ford:begin SSCAL -->
!! Reference for `sscal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Scales a vector BY a constant.
!!      Uses unrolled loops for increment equal to 1.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Scales a vector BY a constant.
!     Uses unrolled loops for increment equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(in) :: sa
real, intent(inout) :: sx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, m, mp1, nincx
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   sx(i) = sa*sx(i)
end do
return
!        Code for increment equal to 1
!        clean-up loop
20 m = mod(n,5)
if (m == 0) go to 40
do i = 1,m
   sx(i) = sa*sx(i)
end do
if (n < 5) return
40 mp1 = m + 1
do i = mp1,n,5
   sx(i) = sa*sx(i)
   sx(i + 1) = sa*sx(i + 1)
   sx(i + 2) = sa*sx(i + 2)
   sx(i + 3) = sa*sx(i + 3)
   sx(i + 4) = sa*sx(i + 4)
end do
end subroutine sscal

pure subroutine  dscal(n,da,dx,incx)
!! <!-- nswc-ford:begin DSCAL -->
!! Reference for `dscal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Scales a vector BY a constant.
!!      Uses unrolled loops for increment equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Scales a vector BY a constant.
!     Uses unrolled loops for increment equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(in) :: da
double precision, intent(inout) :: dx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, m, mp1, nincx
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   dx(i) = da*dx(i)
end do
return
!        Code for increment equal to 1
!        clean-up loop
20 m = mod(n,5)
if (m == 0) go to 40
do i = 1,m
   dx(i) = da*dx(i)
end do
if (n < 5) return
40 mp1 = m + 1
do i = mp1,n,5
   dx(i) = da*dx(i)
   dx(i + 1) = da*dx(i + 1)
   dx(i + 2) = da*dx(i + 2)
   dx(i + 3) = da*dx(i + 3)
   dx(i + 4) = da*dx(i + 4)
end do
end subroutine dscal

pure subroutine  cscal(n,ca,cx,incx)
!! <!-- nswc-ford:begin CSCAL -->
!! Reference for `cscal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Scales a vector BY a constant.
!!      Jack dongarra, LINPACK,  3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Scales a vector BY a constant.
!     Jack dongarra, LINPACK,  3/11/78.
complex, intent(in) :: ca
complex, intent(inout) :: cx(*)
integer, intent(in) :: incx, n
!     beginning of local variable declarations
integer :: i, nincx
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   cx(i) = ca*cx(i)
end do
return
!        Code for increment equal to 1
20 do i = 1,n
   cx(i) = ca*cx(i)
end do
end subroutine cscal

pure subroutine  csscal(n,sa,cx,incx)
!! <!-- nswc-ford:begin CSSCAL -->
!! Reference for `csscal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Scales a complex vector BY a real constant.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Scales a complex vector BY a real constant.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(inout) :: cx(*)
real, intent(in) :: sa
integer, intent(in) :: incx, n
!     beginning of local variable declarations
integer :: i, nincx
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   cx(i) = cmplx(sa*real(cx(i)),sa*aimag(cx(i)))
end do
return
!        Code for increment equal to 1
20 do i = 1,n
   cx(i) = cmplx(sa*real(cx(i)),sa*aimag(cx(i)))
end do
end subroutine csscal

pure subroutine saxpy(n,sa,sx,incx,sy,incy)
!! <!-- nswc-ford:begin SAXPY -->
!! Reference for `saxpy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Constant times a vector plus a vector.
!!      Uses unrolled loop for increments equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Constant times a vector plus a vector.
!     Uses unrolled loop for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(in) :: sx(*)
real, intent(inout) :: sy(*)
real, intent(in) :: sa
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, ix, iy, m, mp1
if (n <= 0) return
if (sa == 0.0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   sy(iy) = sy(iy) + sa*sx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!        Code for both increments equal to 1
!        clean-up loop
20 m = mod(n,4)
if (m == 0) go to 40
do i = 1,m
   sy(i) = sy(i) + sa*sx(i)
end do
if (n < 4) return
40 mp1 = m + 1
do i = mp1,n,4
   sy(i) = sy(i) + sa*sx(i)
   sy(i + 1) = sy(i + 1) + sa*sx(i + 1)
   sy(i + 2) = sy(i + 2) + sa*sx(i + 2)
   sy(i + 3) = sy(i + 3) + sa*sx(i + 3)
end do
end subroutine saxpy

pure subroutine daxpy(n,da,dx,incx,dy,incy)
!! <!-- nswc-ford:begin DAXPY -->
!! Reference for `daxpy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Constant times a vector plus a vector.
!!      Uses unrolled loops for increments equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Constant times a vector plus a vector.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(in) :: dx(*)
double precision, intent(inout) :: dy(*)
double precision, intent(in) :: da
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, ix, iy, m, mp1
if (n <= 0) return
if (da == 0.0d0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   dy(iy) = dy(iy) + da*dx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!        Code for both increments equal to 1
!        clean-up loop
20 m = mod(n,4)
if (m == 0) go to 40
do i = 1,m
   dy(i) = dy(i) + da*dx(i)
end do
if (n < 4) return
40 mp1 = m + 1
do i = mp1,n,4
   dy(i) = dy(i) + da*dx(i)
   dy(i + 1) = dy(i + 1) + da*dx(i + 1)
   dy(i + 2) = dy(i + 2) + da*dx(i + 2)
   dy(i + 3) = dy(i + 3) + da*dx(i + 3)
end do
end subroutine daxpy

pure subroutine caxpy(n,ca,cx,incx,cy,incy)
!! <!-- nswc-ford:begin CAXPY -->
!! Reference for `caxpy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Constant times a vector plus a vector.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Constant times a vector plus a vector.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(in) :: cx(*)
complex, intent(inout) :: cy(*)
complex, intent(in) :: ca
integer, intent(in) :: incx, incy
integer, intent(in) :: n
!     beginning of local variable declarations
integer :: i, ix, iy
if (n <= 0) return
if (abs(real(ca)) + abs(aimag(ca)) == 0.0) return
if (incx == 1.and.incy == 1) go to 20
!        Code for unequal increments or equal increments
!          not equal to 1
ix = 1
iy = 1
if (incx < 0) ix = (-n + 1)*incx + 1
if (incy < 0) iy = (-n + 1)*incy + 1
do i = 1,n
   cy(iy) = cy(iy) + ca*cx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!        Code for both increments equal to 1
20 do i = 1,n
   cy(i) = cy(i) + ca*cx(i)
end do
end subroutine caxpy

pure real function sasum(n,sx,incx)
!! <!-- nswc-ford:begin SASUM -->
!! Reference for `sasum`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Takes the sum of the absolute values.
!!      Uses unrolled loops for increment equal to one.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Takes the sum of the absolute values.
!     Uses unrolled loops for increment equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(in) :: sx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
real :: stemp
integer :: i, m, mp1, nincx
sasum = 0.0e0
stemp = 0.0e0
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   stemp = stemp + abs(sx(i))
end do
sasum = stemp
return
!        Code for increment equal to 1
!        clean-up loop
20 m = mod(n,6)
if (m == 0) go to 40
do i = 1,m
   stemp = stemp + abs(sx(i))
end do
if (n < 6) go to 60
40 mp1 = m + 1
do i = mp1,n,6
   stemp = stemp + abs(sx(i)) + abs(sx(i + 1)) + abs(sx(i + 2)) &
      & + abs(sx(i + 3)) + abs(sx(i + 4)) + abs(sx(i + 5))
end do
60 sasum = stemp
end function sasum

pure double precision function dasum(n,dx,incx)
!! <!-- nswc-ford:begin DASUM -->
!! Reference for `dasum`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Takes the sum of the absolute values.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Takes the sum of the absolute values.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(in) :: dx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
double precision :: dtemp
integer :: i, m, mp1, nincx
dasum = 0.0d0
dtemp = 0.0d0
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   dtemp = dtemp + abs(dx(i))
end do
dasum = dtemp
return
!        Code for increment equal to 1
!        clean-up loop
20 m = mod(n,6)
if (m == 0) go to 40
do i = 1,m
   dtemp = dtemp + abs(dx(i))
end do
if (n < 6) go to 60
40 mp1 = m + 1
do i = mp1,n,6
   dtemp = dtemp + abs(dx(i)) + abs(dx(i + 1)) + abs(dx(i + 2)) &
      & + abs(dx(i + 3)) + abs(dx(i + 4)) + abs(dx(i + 5))
end do
60 dasum = dtemp
end function dasum

pure real function scasum(n,cx,incx)
!! <!-- nswc-ford:begin SCASUM -->
!! Reference for `scasum`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Takes the sum of the absolute values of a complex vector and
!!      returns a single precision result.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Takes the sum of the absolute values of a complex vector and
!     returns a single precision result.
!     Jack dongarra, LINPACK, 3/11/78.
complex, intent(in) :: cx(*)
integer, intent(in) :: incx, n
!     beginning of local variable declarations
real :: stemp
integer :: i, nincx
scasum = 0.0e0
stemp = 0.0e0
if (n <= 0) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
nincx = n*incx
do i = 1,nincx,incx
   stemp = stemp + abs(real(cx(i))) + abs(aimag(cx(i)))
end do
scasum = stemp
return
!        Code for increment equal to 1
20 do i = 1,n
   stemp = stemp + abs(real(cx(i))) + abs(aimag(cx(i)))
end do
scasum = stemp
end function scasum

pure real function snrm2(n, sx, incx)
!! <!-- nswc-ford:begin SNRM2 -->
!! Reference for `snrm2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Euclidean norm of the n-vector stored in sx() with storage
!!      increment incx .
!!      If    n .LE. 0 return with result = 0.
!!      If n .GE. 1 then incx must be .GE. 1
!!            C.L.Lawson, 1978 jan 08
!!      FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!!      hopefully applicable to all machines.
!!          cutlo = Maximum of  sqrt(U/EPS)  over all known machines.
!!          cuthi = Minimum of  sqrt(V)      over all known machines.
!!      Where
!!          eps = Smallest no. such that eps + 1. .GT. 1.
!!          U   = Smallest positive no.   (underflow limit)
!!          V   = Largest  no.            (overflow  limit)
!!      brief outline of algorithm..
!!      PHASE 1    SCANS ZERO COMPONENTS.
!!      Move to phase 2 when a component is nonzero and .LE. cutlo
!!      move to phase 3 when a component is .GT. cutlo
!!      move to phase 4 when a component is .GE. cuthi/M
!!      where M = n for X() real and M = 2*n for complex.
!!      Values for cutlo and cuthi..
!!      From the environmental parameters listed in the IMSL converter
!!      document the limiting values are as follows..
!!      cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!!                    Univac and DEC at 2**(-103)
!!                    THUS cutlo = 2**(-51) = 4.44089E-16
!!      cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!!                    THUS cuthi = 2**(63.5) = 1.30438E19
!!      cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!!                    THUS cutlo = 2**(-33.5) = 8.23181D-11
!!      cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!!      DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!!      DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: incx, n
real, intent(in) :: sx(*)
!     beginning of local variable declarations
integer :: i, j, nn, next
real :: hitest, sum, xmax
real, parameter :: zero = 0.0e0
real, parameter :: one = 1.0e0
real, parameter :: cutlo = 4.441e-16
real, parameter :: cuthi = 1.304e19
!     Euclidean norm of the n-vector stored in sx() with storage
!     increment incx .
!     If    n .LE. 0 return with result = 0.
!     If n .GE. 1 then incx must be .GE. 1
!           C.L.Lawson, 1978 jan 08
!     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!     hopefully applicable to all machines.
!         cutlo = Maximum of  sqrt(U/EPS)  over all known machines.
!         cuthi = Minimum of  sqrt(V)      over all known machines.
!     Where
!         eps = Smallest no. such that eps + 1. .GT. 1.
!         U   = Smallest positive no.   (underflow limit)
!         V   = Largest  no.            (overflow  limit)
!     brief outline of algorithm..
!     PHASE 1    SCANS ZERO COMPONENTS.
!     Move to phase 2 when a component is nonzero and .LE. cutlo
!     move to phase 3 when a component is .GT. cutlo
!     move to phase 4 when a component is .GE. cuthi/M
!     where M = n for X() real and M = 2*n for complex.
!     Values for cutlo and cuthi..
!     From the environmental parameters listed in the IMSL converter
!     document the limiting values are as follows..
!     cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!                   Univac and DEC at 2**(-103)
!                   THUS cutlo = 2**(-51) = 4.44089E-16
!     cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!                   THUS cuthi = 2**(63.5) = 1.30438E19
!     cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!                   THUS cutlo = 2**(-33.5) = 8.23181D-11
!     cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!     DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!     DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
if (n > 0) go to 10
snrm2 = zero
go to 300
10 next = 30
sum = zero
nn = n * incx
!                                                 Begin main loop
i = 1
20 select case (next)
case (30)
   go to 30
case (50)
   go to 50
case (70)
   go to 70
case (110)
   go to 110
end select
30 if (abs(sx(i)) > cutlo) go to 85
next = 50
xmax = zero
!                        Phase 1.  Sum is zero
50 if (sx(i) == zero) go to 200
if (abs(sx(i)) > cutlo) go to 85
!                                Prepare for phase 2.
next = 70
go to 105
!                                Prepare for phase 4.
100 i = j
next = 110
sum = (sum / sx(i)) / sx(i)
105 xmax = abs(sx(i))
go to 115
!                   Phase 2.  Sum is small.
!                             Scale to avoid destructive underflow.
70 if (abs(sx(i)) > cutlo) go to 75
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
110 if (abs(sx(i)) <= xmax) go to 115
sum = one + sum * (xmax / sx(i))**2
xmax = abs(sx(i))
go to 200
115 sum = sum + (sx(i)/xmax)**2
go to 200
!                  Prepare for phase 3.
75 sum = (sum * xmax) * xmax
!     For real or D.P. set hitest = cuthi/n
!     for complex      set hitest = cuthi/(2*n)
85 hitest = cuthi/float(n)
!                   Phase 3.  Sum is mid-range.  No scaling.
do j = i,nn,incx
   if (abs(sx(j)) >= hitest) go to 100
   sum = sum + sx(j)**2
end do
snrm2 = sqrt(sum)
go to 300
200 continue
i = i + incx
if (i <= nn) go to 20
!              END OF MAIN LOOP.
!              Compute square root and adjust for scaling.
snrm2 = xmax * sqrt(sum)
300 continue
end function snrm2

pure double precision function dnrm2(n, dx, incx)
!! <!-- nswc-ford:begin DNRM2 -->
!! Reference for `dnrm2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Euclidean norm of the n-vector stored in dx() with storage
!!      increment incx .
!!      If    n .LE. 0 return with result = 0.
!!      If n .GE. 1 then incx must be .GE. 1
!!            C.L.Lawson, 1978 jan 08
!!      FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!!      hopefully applicable to all machines.
!!          cutlo = Maximum of  dsqrt(U/EPS)  over all known machines.
!!          cuthi = Minimum of  dsqrt(V)      over all known machines.
!!      Where
!!          eps = Smallest no. such that eps + 1. .GT. 1.
!!          U   = Smallest positive no.   (underflow limit)
!!          V   = Largest  no.            (overflow  limit)
!!      brief outline of algorithm..
!!      PHASE 1    SCANS ZERO COMPONENTS.
!!      Move to phase 2 when a component is nonzero and .LE. cutlo
!!      move to phase 3 when a component is .GT. cutlo
!!      move to phase 4 when a component is .GE. cuthi/M
!!      where M = n for X() real and M = 2*n for complex.
!!      Values for cutlo and cuthi..
!!      From the environmental parameters listed in the IMSL converter
!!      document the limiting values are as follows..
!!      cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!!                    Univac and DEC at 2**(-103)
!!                    THUS cutlo = 2**(-51) = 4.44089E-16
!!      cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!!                    THUS cuthi = 2**(63.5) = 1.30438E19
!!      cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!!                    THUS cutlo = 2**(-33.5) = 8.23181D-11
!!      cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!!      DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!!      DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: incx, n
double precision, intent(in) :: dx(*)
!     beginning of local variable declarations
integer :: i, j, nn, next
double precision :: hitest, sum, xmax
double precision, parameter :: zero = 0.0d0
double precision, parameter :: one = 1.0d0
double precision, parameter :: cutlo = 8.232d-11
double precision, parameter :: cuthi = 1.304d19
!     Euclidean norm of the n-vector stored in dx() with storage
!     increment incx .
!     If    n .LE. 0 return with result = 0.
!     If n .GE. 1 then incx must be .GE. 1
!           C.L.Lawson, 1978 jan 08
!     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!     hopefully applicable to all machines.
!         cutlo = Maximum of  dsqrt(U/EPS)  over all known machines.
!         cuthi = Minimum of  dsqrt(V)      over all known machines.
!     Where
!         eps = Smallest no. such that eps + 1. .GT. 1.
!         U   = Smallest positive no.   (underflow limit)
!         V   = Largest  no.            (overflow  limit)
!     brief outline of algorithm..
!     PHASE 1    SCANS ZERO COMPONENTS.
!     Move to phase 2 when a component is nonzero and .LE. cutlo
!     move to phase 3 when a component is .GT. cutlo
!     move to phase 4 when a component is .GE. cuthi/M
!     where M = n for X() real and M = 2*n for complex.
!     Values for cutlo and cuthi..
!     From the environmental parameters listed in the IMSL converter
!     document the limiting values are as follows..
!     cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!                   Univac and DEC at 2**(-103)
!                   THUS cutlo = 2**(-51) = 4.44089E-16
!     cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!                   THUS cuthi = 2**(63.5) = 1.30438E19
!     cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!                   THUS cutlo = 2**(-33.5) = 8.23181D-11
!     cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!     DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!     DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
if (n > 0) go to 10
dnrm2 = zero
go to 300
10 next = 30
sum = zero
nn = n * incx
!                                                 Begin main loop
i = 1
20 select case (next)
case (30)
   go to 30
case (50)
   go to 50
case (70)
   go to 70
case (110)
   go to 110
end select
30 if (abs(dx(i)) > cutlo) go to 85
next = 50
xmax = zero
!                        Phase 1.  Sum is zero
50 if (dx(i) == zero) go to 200
if (abs(dx(i)) > cutlo) go to 85
!                                Prepare for phase 2.
next = 70
go to 105
!                                Prepare for phase 4.
100 i = j
next = 110
sum = (sum / dx(i)) / dx(i)
105 xmax = abs(dx(i))
go to 115
!                   Phase 2.  Sum is small.
!                             Scale to avoid destructive underflow.
70 if (abs(dx(i)) > cutlo) go to 75
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
110 if (abs(dx(i)) <= xmax) go to 115
sum = one + sum * (xmax / dx(i))**2
xmax = abs(dx(i))
go to 200
115 sum = sum + (dx(i)/xmax)**2
go to 200
!                  Prepare for phase 3.
75 sum = (sum * xmax) * xmax
!     For real or D.P. set hitest = cuthi/n
!     for complex      set hitest = cuthi/(2*n)
85 hitest = cuthi/float(n)
!                   Phase 3.  Sum is mid-range.  No scaling.
do j = i,nn,incx
   if (abs(dx(j)) >= hitest) go to 100
   sum = sum + dx(j)**2
end do
dnrm2 = sqrt(sum)
go to 300
200 continue
i = i + incx
if (i <= nn) go to 20
!              END OF MAIN LOOP.
!              Compute square root and adjust for scaling.
dnrm2 = xmax * sqrt(sum)
300 continue
end function dnrm2

pure real function scnrm2(n, cx, incx)
!! <!-- nswc-ford:begin SCNRM2 -->
!! Reference for `scnrm2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Unitary norm of the complex n-vector stored in cx() with storage
!!      increment incx .
!!      If    n .LE. 0 return with result = 0.
!!      If n .GE. 1 then incx must be .GE. 1
!!            C.L.Lawson , 1978 jan 08
!!      FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!!      hopefully applicable to all machines.
!!          cutlo = Maximum of  sqrt(U/EPS)  over all known machines.
!!          cuthi = Minimum of  sqrt(V)      over all known machines.
!!      Where
!!          eps = Smallest no. such that eps + 1. .GT. 1.
!!          U   = Smallest positive no.   (underflow limit)
!!          V   = Largest  no.            (overflow  limit)
!!      brief outline of algorithm..
!!      PHASE 1    SCANS ZERO COMPONENTS.
!!      Move to phase 2 when a component is nonzero and .LE. cutlo
!!      move to phase 3 when a component is .GT. cutlo
!!      move to phase 4 when a component is .GE. cuthi/M
!!      where M = n for X() real and M = 2*n for complex.
!!      Values for cutlo and cuthi..
!!      From the environmental parameters listed in the IMSL converter
!!      document the limiting values are as follows..
!!      cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!!                    Univac and DEC at 2**(-103)
!!                    THUS cutlo = 2**(-51) = 4.44089E-16
!!      cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!!                    THUS cuthi = 2**(63.5) = 1.30438E19
!!      cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!!                    THUS cutlo = 2**(-33.5) = 8.23181D-11
!!      cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!!      DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!!      DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: incx, n
complex, intent(in) :: cx(*)
!     beginning of local variable declarations
integer :: i, nn, next
logical :: imag, scale
real :: hitest, sum, xmax, absx
real, parameter :: zero = 0.0e0
real, parameter :: one = 1.0e0
real, parameter :: cutlo = 4.441e-16
real, parameter :: cuthi = 1.304e19
!     Unitary norm of the complex n-vector stored in cx() with storage
!     increment incx .
!     If    n .LE. 0 return with result = 0.
!     If n .GE. 1 then incx must be .GE. 1
!           C.L.Lawson , 1978 jan 08
!     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!     hopefully applicable to all machines.
!         cutlo = Maximum of  sqrt(U/EPS)  over all known machines.
!         cuthi = Minimum of  sqrt(V)      over all known machines.
!     Where
!         eps = Smallest no. such that eps + 1. .GT. 1.
!         U   = Smallest positive no.   (underflow limit)
!         V   = Largest  no.            (overflow  limit)
!     brief outline of algorithm..
!     PHASE 1    SCANS ZERO COMPONENTS.
!     Move to phase 2 when a component is nonzero and .LE. cutlo
!     move to phase 3 when a component is .GT. cutlo
!     move to phase 4 when a component is .GE. cuthi/M
!     where M = n for X() real and M = 2*n for complex.
!     Values for cutlo and cuthi..
!     From the environmental parameters listed in the IMSL converter
!     document the limiting values are as follows..
!     cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!                   Univac and DEC at 2**(-103)
!                   THUS cutlo = 2**(-51) = 4.44089E-16
!     cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!                   THUS cuthi = 2**(63.5) = 1.30438E19
!     cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!                   THUS cutlo = 2**(-33.5) = 8.23181D-11
!     cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!     DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!     DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
if (n > 0) go to 10
scnrm2 = zero
go to 300
10 next = 30
sum = zero
nn = n * incx
!                                                 Begin main loop
do i = 1,nn,incx
   absx = abs(real(cx(i)))
   imag = .false.
   select case (next)
   case (30)
      go to 30
   case (50)
      go to 50
   case (70)
      go to 70
   case (90)
      go to 90
   case (110)
      go to 110
   end select
30 if (absx > cutlo) go to 85
   next = 50
   scale = .false.
!                        Phase 1.  Sum is zero
50 if (absx == zero) go to 200
   if (absx > cutlo) go to 85
!                                Prepare for phase 2.
   next = 70
   go to 105
!                                Prepare for phase 4.
100 next = 110
   sum = (sum / absx) / absx
105 scale = .true.
   xmax = absx
   go to 115
!                   Phase 2.  Sum is small.
!                             Scale to avoid destructive underflow.
70 if (absx > cutlo) go to 75
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
110 if (absx <= xmax) go to 115
   sum = one + sum * (xmax / absx)**2
   xmax = absx
   go to 200
115 sum = sum + (absx/xmax)**2
   go to 200
!                  Prepare for phase 3.
75 sum = (sum * xmax) * xmax
85 next = 90
   scale = .false.
!     For real or D.P. set hitest = cuthi/n
!     for complex      set hitest = cuthi/(2*n)
   hitest = cuthi/float(n)
   hitest = hitest * 0.5
!                   Phase 3.  Sum is mid-range.  No scaling.
90 if (absx >= hitest) go to 100
   sum = sum + absx**2
200 continue
!                  Control selection of real and imaginary parts.
   if (imag) go to 210
   absx = abs(aimag(cx(i)))
   imag = .true.
   select case (next)
   case (50)
      go to 50
   case (70)
      go to 70
   case (90)
      go to 90
   case (110)
      go to 110
   end select
210 continue
end do
!              END OF MAIN LOOP.
!              Compute square root and adjust for scaling.
scnrm2 = sqrt(sum)
if (scale) scnrm2 = scnrm2 * xmax
300 continue
end function scnrm2

pure integer function isamax(n,sx,incx)
!! <!-- nswc-ford:begin ISAMAX -->
!! Reference for `isamax`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Finds the index of element having max. Absolute value.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
real, intent(in) :: sx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
real :: smax
integer :: i, ix
isamax = 0
if (n < 1) return
isamax = 1
if (n == 1) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
ix = 1
smax = abs(sx(1))
ix = ix + incx
do i = 2,n
   if (abs(sx(ix)) <= smax) go to 5
   isamax = i
   smax = abs(sx(ix))
5  ix = ix + incx
end do
return
!        Code for increment equal to 1
20 smax = abs(sx(1))
do i = 2,n
   if (abs(sx(i)) <= smax) go to 30
   isamax = i
   smax = abs(sx(i))
30 continue
end do
end function isamax

pure integer function idamax(n,dx,incx)
!! <!-- nswc-ford:begin IDAMAX -->
!! Reference for `idamax`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Finds the index of element having max. Absolute value.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
double precision, intent(in) :: dx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
double precision :: dmax
integer :: i, ix
idamax = 0
if (n < 1) return
idamax = 1
if (n == 1) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
ix = 1
dmax = abs(dx(1))
ix = ix + incx
do i = 2,n
   if (abs(dx(ix)) <= dmax) go to 5
   idamax = i
   dmax = abs(dx(ix))
5  ix = ix + incx
end do
return
!        Code for increment equal to 1
20 dmax = abs(dx(1))
do i = 2,n
   if (abs(dx(i)) <= dmax) go to 30
   idamax = i
   dmax = abs(dx(i))
30 continue
end do
end function idamax

integer function icamax(n,cx,incx)
!! <!-- nswc-ford:begin ICAMAX -->
!! Reference for `icamax`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Finds the index of element having max. Absolute value.
!!      Jack dongarra, LINPACK, 3/11/78.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
complex :: cx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
!     beginning of local variable declarations
real :: smax
integer :: i, ix
complex :: zdum
icamax = 0
if (n < 1) return
icamax = 1
if (n == 1) return
if (incx == 1) go to 20
!        Code for increment not equal to 1
ix = 1
smax = cabs1(cx(1))
ix = ix + incx
do i = 2,n
   if (cabs1(cx(ix)) <= smax) go to 5
   icamax = i
   smax = cabs1(cx(ix))
5  ix = ix + incx
end do
return
!        Code for increment equal to 1
20 smax = cabs1(cx(1))
do i = 2,n
   if (cabs1(cx(i)) <= smax) go to 30
   icamax = i
   smax = cabs1(cx(i))
30 continue
end do
contains
   pure function cabs1(zdum) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: zdum
      real :: nswc_sf_result
      nswc_sf_result = abs(real(zdum)) + abs(aimag(zdum))
   end function cabs1
end function icamax

pure subroutine mcvfs(a,ka,n,b)
!! <!-- nswc-ford:begin MCVFS -->
!! Reference for `mcvfs`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
!     beginning of local variable declarations
integer :: i, j, l
l = 0
do j = 1,n
   do i = 1,j
      l = l + 1
      b(l) = a(i,j)
   end do
end do
end subroutine mcvfs

pure subroutine dmcvfs(a,ka,n,b)
!! <!-- nswc-ford:begin DMCVFS -->
!! Reference for `dmcvfs`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(*)
!     beginning of local variable declarations
integer :: i, j, l
l = 0
do j = 1,n
   do i = 1,j
      l = l + 1
      b(l) = a(i,j)
   end do
end do
end subroutine dmcvfs

pure subroutine mcvsf(a,ka,n,b)
!! <!-- nswc-ford:begin MCVSF -->
!! Reference for `mcvsf`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n)
real, intent(in) :: b(*)
!     beginning of local variable declarations
integer :: i, ii, im1, j, jj, l
a(1,1) = b(1)
if (n < 2) return
l = (n*(n + 1))/2
j = n
do jj = 2,n
   i = j
   do ii = 1,j
      a(i,j) = b(l)
      i = i - 1
      l = l - 1
   end do
   j = j - 1
end do
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(i,j) = a(j,i)
   end do
end do
end subroutine mcvsf

pure subroutine dmcvsf(a,ka,n,b)
!! <!-- nswc-ford:begin DMCVSF -->
!! Reference for `dmcvsf`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, n
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: b(*)
!     beginning of local variable declarations
integer :: i, ii, im1, j, jj, l
a(1,1) = b(1)
if (n < 2) return
l = (n*(n + 1))/2
j = n
do jj = 2,n
   i = j
   do ii = 1,j
      a(i,j) = b(l)
      i = i - 1
      l = l - 1
   end do
   j = j - 1
end do
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(i,j) = a(j,i)
   end do
end do
end subroutine dmcvsf

pure subroutine mcvrd(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin MCVRD -->
!! Reference for `mcvrd`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine mcvrd

pure subroutine mcvdr(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin MCVDR -->
!! Reference for `mcvdr`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine mcvdr

pure subroutine mcvrc(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin MCVRC -->
!! Reference for `mcvrc`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = cmplx(a(i,j),0.0)
   end do
end do
end subroutine mcvrc

pure subroutine cmreal(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin CMREAL -->
!! Reference for `cmreal`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = real(a(i,j))
   end do
end do
end subroutine cmreal

pure subroutine cmimag(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin CMIMAG -->
!! Reference for `cmimag`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = aimag(a(i,j))
   end do
end do
end subroutine cmimag

pure subroutine mcopy(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin MCOPY -->
!! Reference for `mcopy`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine mcopy

pure subroutine smcopy(n,a,b)
!! <!-- nswc-ford:begin SMCOPY -->
!! Reference for `smcopy`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
!     beginning of local variable declarations
integer :: k, l
l = (n*(n + 1))/2
do k = 1,l
   b(k) = a(k)
end do
end subroutine smcopy

pure subroutine dmcopy(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin DMCOPY -->
!! Reference for `dmcopy`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine dmcopy

pure subroutine cmcopy(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin CMCOPY -->
!! Reference for `cmcopy`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine cmcopy

pure subroutine cmconj(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin CMCONJ -->
!! Reference for `cmconj`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(i,j) = conjg(a(i,j))
   end do
end do
end subroutine cmconj

pure subroutine tpose(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin TPOSE -->
!! Reference for `tpose`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,m)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(j,i) = a(i,j)
   end do
end do
end subroutine tpose

pure subroutine dtpose(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin DTPOSE -->
!! Reference for `dtpose`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,m)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(j,i) = a(i,j)
   end do
end do
end subroutine dtpose

pure subroutine ctpose(m,n,a,ka,b,kb)
!! <!-- nswc-ford:begin CTPOSE -->
!! Reference for `ctpose`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(j,i) = a(i,j)
   end do
end do
end subroutine ctpose

pure subroutine tip(a, n1, n2, moved, nwork, ndim)
!! <!-- nswc-ford:begin TIP -->
!! Reference for `tip`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Transposition of a rectangular matrix in situ.
!!  By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
!!  Transposition of the n1 by n2 matrix a amounts to
!!  replacing the element at vector position i (0-ORIGIN)
!!  with the element at position n1*i (mod n1*n2-1).
!!  Each subcycle of this permutation is completed in order.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
real, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
!     beginning of local variable declarations
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
   & npower, ifact(8), ipower(8), nexp(8), iexp(8)
real :: atemp, btemp
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
end subroutine tip

pure subroutine dtip(a, n1, n2, moved, nwork, ndim)
!! <!-- nswc-ford:begin DTIP -->
!! Reference for `dtip`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Transposition of a rectangular matrix in situ.
!!  By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
!!  Transposition of the n1 by n2 matrix a amounts to
!!  replacing the element at vector position i (0-ORIGIN)
!!  with the element at position n1*i (mod n1*n2-1).
!!  Each subcycle of this permutation is completed in order.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
double precision, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CTIP -->
!! Reference for `ctip`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Transposition of a rectangular matrix in situ.
!!  By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
!!  Transposition of the n1 by n2 matrix a amounts to
!!  replacing the element at vector position i (0-ORIGIN)
!!  with the element at position n1*i (mod n1*n2-1).
!!  Each subcycle of this permutation is completed in order.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
complex, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin INFCTR -->
!! Reference for `infctr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Factor n into its prime powers, npower in number.
!!  E.G., FOR n=1960=2**3 *5 *7**2, npower=3, ifact=2,5,7,
!!  ipower=8,5,49, AND nexp=3,1,2.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ifact(*), ipower(*)
integer, intent(in) :: n
integer, intent(inout) :: nexp(*), npower
!     beginning of local variable declarations
integer :: idiv, ifcur, ip, iquot, npart
! Factor n into its prime powers, npower in number.
! E.G., FOR n=1960=2**3 *5 *7**2, npower=3, ifact=2,5,7,
! ipower=8,5,49, AND nexp=3,1,2.
ip = 0
ifcur = 0
npart = n
idiv = 2
10 iquot = npart/idiv
if ((npart - idiv * iquot) == 0) go to 20
go to 60
20 if ((idiv - ifcur) <= 0) go to 40
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
60 if ((iquot - idiv) <= 0) go to 100
go to 70
70 if ((idiv - 2) <= 0) go to 80
go to 90
80 idiv = 3
go to 10
90 idiv = idiv + 2
go to 10
100 if ((npart - 1) <= 0) go to 140
go to 110
110 if ((npart - ifcur) <= 0) go to 130
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
!! <!-- nswc-ford:begin CMADJ -->
!! Reference for `cmadj`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
!     beginning of local variable declarations
integer :: i, j
do j = 1,n
   do i = 1,m
      b(j,i) = conjg(a(i,j))
   end do
end do
end subroutine cmadj

pure subroutine ctrans(nm, n, a)
!! <!-- nswc-ford:begin CTRANS -->
!! Reference for `ctrans`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Subroutine ctrans finds the complex conjugate of an input
!!      matrix.
!!      On entry,
!!      nm is the leading dimension of matrix a in the main program.
!!      n  is the order of matrix a.
!!      A  is the input matrix.
!!      On return,
!!      a  contains its conjugate transpose.
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin MADD -->
!! Reference for `madd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       Addition of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, m, n
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DMADD -->
!! Reference for `dmadd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Addition of double precision matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, m, n
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CMADD -->
!! Reference for `cmadd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Addition of complex matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, m, n
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SMADD -->
!! Reference for `smadd`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: k, m
m = (n*(n + 1))/2
do k = 1,m
   c(k) = a(k) + b(k)
end do
end subroutine smadd

pure subroutine msubt(m, n, a, ka, b, kb, c, kc)
!! <!-- nswc-ford:begin MSUBT -->
!! Reference for `msubt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                      Subtraction of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, m, n
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DMSUBT -->
!! Reference for `dmsubt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Subtraction of double precision matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, m, n
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CMSUBT -->
!! Reference for `cmsubt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                   Subtraction of complex matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, m, n
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SMSUBT -->
!! Reference for `smsubt`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: k, m
m = (n*(n + 1))/2
do k = 1,m
   c(k) = a(k) - b(k)
end do
end subroutine smsubt

pure subroutine mtms(m, n, l, a, ka, b, kb, c, kc)
!! <!-- nswc-ford:begin MTMS -->
!! Reference for `mtms`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                      Product of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DMTMS -->
!! Reference for `dmtms`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Product of double precision matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,l)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CMTMS -->
!! Reference for `cmtms`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Product of complex matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,l)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin MPROD -->
!! Reference for `mprod`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                      Product of real matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin RLOC -->
!! Reference for `rloc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      x and y are arrays. It is assumed that x(1) and y(1) contain data.
!!      rloc(x,y) = .TRUE.   if x and y begin in the same location
!!      rloc(x,y) = .FALSE.  if x and y begin in different locations
!!      it is recommended that this coding not be optimized by eliminating
!!      the subroutine ychg. If it is optimized then rloc may not compile
!!      properly.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin YCHG -->
!! Reference for `ychg`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: yold
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
y(1) = 0.0
if (yold == 0.0) y(1) = 1.0
end subroutine ychg

subroutine dmprod(m, n, l, a, ka, b, kb, c, kc, row)
!! <!-- nswc-ford:begin DMPROD -->
!! Reference for `dmprod`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Product of double precision matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), &
   & row(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DLOC -->
!! Reference for `dloc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      x and y are arrays. It is assumed that x(1) and y(1) contain data.
!!      dloc(x,y) = .TRUE.   if x and y begin in the same location
!!      dloc(x,y) = .FALSE.  if x and y begin in different locations
!!      it is recommended that this coding not be optimized by eliminating
!!      the subroutine dychg. If it is optimized then dloc may not compile
!!      properly.
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DYCHG -->
!! Reference for `dychg`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
double precision, intent(in) :: x(*)
double precision, intent(inout) :: y(*)
double precision, intent(in) :: yold
y(1) = 0.d0
if (yold == 0.d0) y(1) = 1.d0
end subroutine dychg

subroutine cmprod(m, n, l, a, ka, b, kb, c, kc, row)
!! <!-- nswc-ford:begin CMPROD -->
!! Reference for `cmprod`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Product of complex matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
complex, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CLOC -->
!! Reference for `cloc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      x and y are arrays. It is assumed that x(1) and y(1) contain data.
!!      cloc(x,y) = .TRUE.   if x and y begin in the same location
!!      cloc(x,y) = .FALSE.  if x and y begin in different locations
!!      it is recommended that this coding not be optimized by eliminating
!!      the subroutine cychg. If it is optimized then cloc may not compile
!!      properly.
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CYCHG -->
!! Reference for `cychg`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: x(*)
complex, intent(inout) :: y(*)
complex, intent(in) :: yold
!     beginning of local variable declarations
complex, parameter :: zero = (0.0,0.0)
complex, parameter :: one = (1.0,0.0)
y(1) = zero
if (yold == zero) y(1) = one
end subroutine cychg

pure subroutine svprd(a,n,x,y)
!! <!-- nswc-ford:begin SVPRD -->
!! Reference for `svprd`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DSVPRD -->
!! Reference for `dsvprd`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin TMPROD -->
!! Reference for `tmprod`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SMPROD -->
!! Reference for `smprod`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin KPROD -->
!! Reference for `kprod`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Kronecker product of real matrices A and b
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DKPROD -->
!! Reference for `dkprod`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Kronecker product of double precision matrices A and b
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CKPROD -->
!! Reference for `ckprod`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Kronecker product of complex matrices A and b
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin RNK -->
!! Reference for `rnk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Upper and lower bounds of the rank of a real matrix
!!
!!      real work(5*m0)  where m0 = 5*min0(m,n)
!!      integer iwork(m + n)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
real, intent(in) :: ae, re
real, intent(inout) :: a(mda,n), work(*)
integer, intent(inout) :: iwork(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DRNK -->
!! Reference for `drnk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Upper and lower bounds of the rank of A
!!                       double precision matrix
!!
!!      double precision work(5*m0)  where m0 = 5*min0(m,n)
!!      integer iwork(m + n)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
double precision, intent(inout) :: a(mda,n)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: work(*)
integer, intent(inout) :: iwork(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CROUT -->
!! Reference for `crout`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      crout procedure for inverting matrices and solving equations
!!
!!      A is a matrix of order n where n is greater than or equal to 1.
!!      If mo=0 Then the inverse of A is computed and stored in A. if mo
!!      is not 0 then the inverse is not computed.
!!      If m is greater than 0 then b is a matrix having n rows and m
!!      columns. In this case AX=b is solved and the solution X is stored
!!      in b. if m=0 Then there are no equations to be solved.
!!      ka = The length of the columns of the array a
!!      kb = The length of the columns of the array b (if m.GT.0)
!!      the determinant d of A is always computed. If d=0 Then the
!!      routine immediately terminates.
!!      Index is an array of dimension n-1 or larger that is used by the
!!      routine for keeping track of the row interchanges that are made.
!!      If mo is not 0 then this array is not needed.
!!      Temp is an array of dimension n or larger that is used when A
!!      is inverted. If mo is not 0 then this array is not needed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), d, temp(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin KROUT -->
!! Reference for `krout`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      crout procedure for inverting matrices and solving equations
!!
!!      A is a matrix of order n where n is greater than or equal to 1.
!!      If mo=0 Then the inverse of A is computed and stored in A. if mo
!!      is not 0 then the inverse is not computed.
!!      If m is greater than 0 then b is a matrix having n rows and m
!!      columns. In this case AX=b is solved and the solution X is stored
!!      in b. if m=0 Then there are no equations to be solved.
!!      ka = The length of the columns of the array a
!!      kb = The length of the columns of the array b (if m.GT.0)
!!      ierr is a variable that reports the status of the results. When
!!      the routine terminates ierr has one of the following values ...
!!         ierr =  0   The requested task was performed.
!!         ierr = -1   Either n, ka, or kb is incorrect.
!!         ierr =  k   the k-TH pivot element is 0.
!!      Index is an array of dimension n-1 or larger that is used by the
!!      routine for keeping track of the row interchanges that are made.
!!      If mo is not 0 then this array is not needed.
!!      Temp is an array of dimension n or larger that is used when A
!!      is inverted. If mo is not 0 then this array is not needed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr, index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), temp(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DEC -->
!! Reference for `dec`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Matrix triangularization by Gaussian elimination.
!!  Input..
!!     n = Order of matrix.
!!     ndim = Declared dimension of array  a .
!!     a = Matrix to be triangularized.
!!  Output..
!!     a(i,j), i.LE.j = Upper triangular factor, U .
!!     a(i,j), i.GT.j = Multipliers = Lower triangular factor, i - L.
!!     ip(k), k.LT.n = Index of k-TH pivot row.
!!     ip(n) = (-1)**(number of interchanges) or O .
!!     ier = 0 If a nonsingular, or k if a found to be
!!           singular at stage k.
!!  Use  sol  to obtain solution of linear system.
!!  determ(a) = ip(n)*a(1,1)*a(2,2)*...*a(n,n).
!!  If ip(n)=0, A is singular, sol will divide by zero.
!!  Interchanges finished in U , only partly in L .
!!  Reference..
!!  C. B. Moler, algorithm 423, linear equation solver,
!!  comm. Assoc. COMPUT. Mach., 15 (1972), P. 274.
!! ```
!! <!-- nswc-ford:end -->
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
dimension ip(n)
!     beginning of local variable declarations
integer :: i, j, k, kp1, m, nm1
real :: t
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
!! <!-- nswc-ford:begin SOL -->
!! Reference for `sol`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Solution of linear system, a*X = b .
!!  Input..
!!    n = Order of matrix.
!!    ndim = Declared dimension of array  a .
!!    a = Triangularized matrix obtained from DEC.
!!    b = Right hand side vector.
!!    ip = Pivot vector obtained from DEC.
!!  Do not use if DEC has set ier .NE. 0.
!!  Output..
!!    b = Solution vector, X .
!! ```
!! <!-- nswc-ford:end -->
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
integer, intent(in) :: ip
integer, intent(in) :: n, ndim
real, intent(in) :: a(ndim, n)
real, intent(inout) :: b(n)
dimension ip(n)
!     beginning of local variable declarations
integer :: i, k, kb, km1, kp1, m, nm1
real :: t
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
!! <!-- nswc-ford:begin NPIVOT -->
!! Reference for `npivot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Matrix inversion/equation solving without pivot search
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: d
real, intent(inout) :: a(ka,n), b(*)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SLV -->
!! Reference for `slv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Partial pivot solution of a*X = b where A is a matrix of
!!      order n and b is a matrix having n rows and m columns.
!!      The solution matrix X is stored in b.
!!      ierr is a variable that reports the status of the results.
!!         ierr = 0   The equations have been solved.
!!         ierr = j   the j-TH pivot element was found to be 0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: a(ka,n), b(kb,m)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin DPSLV -->
!! Reference for `dpslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Partial pivot solution of a*X = b where A is a matrix of
!!      order n and b is a matrix having n rows and m columns.
!!      The solution matrix X is stored in b.
!!      ierr is a variable that reports the status of the results.
!!         ierr = 0   The equations have been solved.
!!         ierr = j   the j-TH pivot element was found to be 0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
double precision, intent(inout) :: a(ka,n), b(kb,m)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin MSLV -->
!! Reference for `mslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Partial pivot Gauss procedure for inverting real matrices
!!      and solving real equations
!!
!!           Matrix factorization and computation of rcond
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*)
real, intent(inout) :: det(2), rcond
real, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin MSLV1 -->
!! Reference for `mslv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Partial pivot Gauss procedure for inverting real matrices
!!      and solving real equations
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SLVMP -->
!! Reference for `slvmp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Solution of real linear equations with iterative improvement
!!
!!      dimension wk(n*n + n)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr, iwk
integer, intent(in) :: ka, mo, n
real, intent(in) :: a(ka,n), b(n)
real, intent(inout) :: wk(*), x(n)
dimension iwk(n)
!     beginning of local variable declarations
integer :: i, ir
!     ******************************************************************
!     Solution of real linear equations with iterative improvement
!     ******************************************************************
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
!! <!-- nswc-ford:begin LUIMP -->
!! Reference for `luimp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!        given an approximate solution x of a linear system AX = b
!!        obtained using sgeco or sgefa. luimp attempts to compute
!!        an improved solution correct to machine precision.
!!      Parameters
!!        A    AN ARRAY OF DIMENSION (ka,n) CONTAINING THE MATRIX
!!             A of order n.
!!        q    AN ARRAY OF DIMENSION (kq,n) CONTAINING THE LU
!!             decomposition of a produced by sgeco or sgefa.
!!        ipvt an array of dimension n containing the permutation
!!             information given by sgeco or sgefa.
!!        b    the right hand side of the equation AX = b.
!!        x    on input x is the approximate solution of AX = b to
!!             be improved. On output x is the solution obtained.
!!        r    AN ARRAY FOR INTERNAL USE BY THE ROUTINE.
!!        Ind  variable that reports the status of the results.
!!             ind = 0 If improvement of x is successful with A
!!             gain in accuracy of at least 50 per cent each
!!             iteration. Otherwise ind = 1.
!!      Method
!!        luimp executes the iteration cycle
!!             (1)  AR = b - AX
!!             (2)  x = x + r
!!        with an initial given x. the residual vector b - AX is
!!        computed to high accuracy using double precision. sgesl
!!        is then used to solve (1).
!!
!!      ********** eps is a machine dependent parameter. Assign eps
!!                 the value U where U is the smallest floating point
!!                 number such that 1.0 + U .GT. 1.0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ind
integer, intent(in) :: ipvt
integer, intent(in) :: ka, kq, n
real, intent(in) :: a(ka,n), b(n)
real :: q(kq,n)
real, intent(inout) :: r(n), x(n)
dimension ipvt(n)
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SGECO -->
!! Reference for `sgeco`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      sgeco factors a real matrix BY Gaussian elimination
!!      and estimates the condition of the matrix.
!!      If  rcond  is not needed, sgefa is slightly faster.
!!      To solve  a*X = B , follow sgeco by sgesl.
!!      To compute  inverse(a)*C , follow sgeco by sgesl.
!!      To compute  determinant(a) , follow sgeco by sgedi.
!!      To compute  inverse(a) , follow sgeco by sgedi.
!!      On entry
!!         A       real(lda, n)
!!                 the matrix to be factored.
!!         lda     INTEGER
!!                 the leading dimension of the array  a .
!!         n       INTEGER
!!                 the order of the matrix  a .
!!      On return
!!         A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!!                 which were used to obtain it.
!!                 The factorization can be written  a = l*U  where
!!                 l  is a product of permutation and unit lower
!!                 triangular matrices and  U  is upper triangular.
!!         ipvt    INTEGER(n)
!!                 an integer vector of pivot indices.
!!         rcond   REAL
!!                 an estimate of the reciprocal condition of  A .
!!                 For the system  a*X = B , relative perturbations
!!                 in  A  and  B  of size  epsilon  may cause
!!                 relative perturbations in  X  of size  epsilon/rcond .
!!                 If  rcond  is so small that the logical expression
!!                            1.0 + rcond .EQ. 1.0
!!                 is true, then  A  may be singular to working
!!                 precision.  In particular,  rcond  is zero  if
!!                 exact singularity is detected or the estimate
!!                 underflows.
!!         z       real(n)
!!                 a work vector whose contents are usually unimportant.
!!                 If  A  is close to a singular matrix, then  z  is
!!                 an approximate null vector in the sense that
!!                 norm(a*z) = rcond*norm(a)*norm(z) .
!!      LINPACK. This version dated 08/14/78 .
!!      Cleve Moler, University of New Mexico, Argonne National Lab.
!!      Subroutines and functions
!!      LINPACK sgefa
!!      BLAS saxpy,sdot,sscal,sasum
!!      Fortran abs,AMAX1,sign
!!      internal variables
!!      compute 1-norm of A
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
real, intent(inout) :: a(lda,*), z(*)
real, intent(inout) :: rcond
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin SGEFA -->
!! Reference for `sgefa`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      sgefa factors a real matrix BY Gaussian elimination.
!!      sgefa is usually called by sgeco, but it can be called
!!      directly with a saving in time if  RCOND  is not needed.
!!      (Time for sgeco) = (1 + 9/n)*(time for sgefa) .
!!      On entry
!!         A       real(lda, n)
!!                 the matrix to be factored.
!!         lda     INTEGER
!!                 the leading dimension of the array  a .
!!         n       INTEGER
!!                 the order of the matrix  a .
!!      On return
!!         A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!!                 which were used to obtain it.
!!                 The factorization can be written  a = l*U  where
!!                 l  is a product of permutation and unit lower
!!                 triangular matrices and  U  is upper triangular.
!!         ipvt    INTEGER(n)
!!                 an integer vector of pivot indices.
!!         INFO    INTEGER
!!                 = 0  Normal value.
!!                 = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!!                      condition for this subroutine, but it does
!!                      indicate that sgesl or sgedi will divide by zero
!!                      if called.  Use  RCOND  in sgeco for a reliable
!!                      indication of singularity.
!!      LINPACK. This version dated 08/14/78 .
!!      Cleve Moler, University of New Mexico, Argonne National Lab.
!!      Subroutines and functions
!!      BLAS saxpy,sscal,isamax
!!      internal variables
!!      Gaussian elimination with partial pivoting
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
real, intent(inout) :: a(lda,*)
!     beginning of local variable declarations
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

