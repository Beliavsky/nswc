[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-122"></a>
## Solutions of Nonlinear Equations

<small>Original source: [View scanned PDF page 122](../scans/page_0122.png)</small>

<a id="topic-122-01"></a>
### Zeros Of Continuous Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [`L28262`](../source_parts/nswc_part_03.f90#L7134) |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [`L28386`](../source_parts/nswc_part_03.f90#L7258) |


Let F(z) be a continuous real-valued function defined for a < x < 6, and assume that F(a) and F(b) have opposite signs. Then the following functions are available for finding a point z in the interval {a, 6] for which F(z) = 0.

```fortran
ZEROIN(F, AX, BX, AERR, RERR)
```

F(x) is a user defined function whose arguments and values are assumed to be real numbers. ZEROIN returns a value z in the interval [a, 6] for which F(x) = 0.

AERR and RERR are the absolute and relative tolerances to be satisfied (AERR. > 0 and RERR > 0). One may set RERR = 10~* if it is desired that x be accurate to k significant decimal digits. If RERR = 0 then it is assumed that machine accuracy is desired.

**Remark.** F must be declared in the calling program to he of type EXTERNAL.

**References.**

(1) Brent, Richard, Algorithms for Minimization without Derivatives, Prentice-Hall, 1973.

(2) Forsythe, G.E., Malcolm, M.A., and Moler, C.B., Computer Methods for Mathematical Computations, Prentice-Hall, 1977.

**Programming.** ZfROIN is a slightly modified translation of the ALGOL 60 procedure ZERO given in reference (1). The code was distributed by G. FE. Forsythe, M. A. Malcolm, and C. B. Moler (University of New Mexico), and modified by A. HE. Morris. The function SPMPAR is used.

```fortran
DZERO(F, AX, BX, AERR, RERR)
```

The arguments og, 6, AE RK, and RERR are double precision numbers, and P(x)is a user defined function whose arguments and values are assumed to be double precision numbers. DZERO returns a double precision value x in the interval ja,6! for which F(z) 0.

} [4,0 }

AERR and RERE are the absolute and relative tolerances to be satisfied (AERK > Qand RERR » 0). One may set RERK 10 * if it is desired that 2 be accurate to & significant decimal digits. [IP RERR 0 then it is assumed that machine accuracy is desired

**Remarks.** Pomust be declared in the calling program to be of type DOUBLE PRECISION and EXTERNAL, and DAR RO must be declared to be of type DOUBLE PRECISION

**References.**

```text
(1) Brent, Richard, Algorsthmae for Minimization utthout Dertvatirues, Prontice- Hall,
Lo7s
(2) Porsythe, G bo, Mialeolm, MOA | and Moler CoB) Computer Methods for Afatherat
```

seal Computations, Prentice tall, 1977


<small>Original source: [View scanned PDF page 123](../scans/page_0123.png)</small>

**Programming.** DZERO is a slightly modified translation of the ALGOL 60 procedure ZERO given in reference (1). The code was distributed by G. E. Forsythe, M. A. Malcolm, and C. B. Moler (University of New Mexico), and modified by A. H. Morris. The function DPMPAR is used.

p52


<small>Original source: [View scanned PDF page 124](../scans/page_0124.png)</small>

<a id="topic-124-01"></a>
### Solution Of Systems Of Nonlinear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [`L28510`](../source_parts/nswc_part_03.f90#L7382) |


Let f,(z) = O (¢ = 1,...,n) denote a system of n equations in n unknowns where z = (z1,...,%,). Assume that each f,(z) is differentiable and that an initial guess a = (a1, ...,@,) to a solution of the equations is given. Then the following subroutine is available for solving the equations to within a specified tolerance.

```fortran
CALL HBRD(FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA)
```

X and FVEC are arrays of dimension n or larger. On input X contains the starting -oint a = (a),...,@,). When HBRD terminates, X contains the final estimate x = (x1, ...,2n) of the solution vector and FVEC contains the values of the functions fy, ..., fn at the output point in X.

The argument F is the name of a user defined subroutine that has the format: CALL F(n, X,FVEC,IFLAG)

Here X and FVEC are arrays of dimension n and IFLAG is an integer variable. The array X contains a point z = (z1,...,2,). Normally F will evaluate the functions f1,..., fn at this point and store the results in FVEC. However, if x does not lie in the domain of fi,---,fn then this cannot be done. In this case, the argument IFLAG (which will have been assigned a nonnegative value by HBRD) should be reset by F to a negative value. This will signal HBRD to terminate. F must be declared in the calling program to be of type EXTERNAL.

EPS is an input argument which specifies the relative accuracy of F. If it is estimated that the subroutine F produces results accurate to k significant decimal] digits then one may set EPS := 107*. It is required that EPS > 0. If EPS = 0 then it is assumed that F produces results accurate to machine precision.

TOL is an input argument which specifies the desired accuracy of the solution. The Euclidean norm ||z|| == \/2,22 is employed. If ¢ denotes an actual solution of the equations, then HBRD terminates when an iterate 2 is generated for which it is estimated that |[z - x|| < TOL: |[z]] is satisfied. It is required that ‘TOL > 0. In order for the convergence test to work properly, it is recommended that TOL always be smaller than 107°,

WK is an array of dimension @ that is used for a work space. It is assumed that the argument @ is greater than or equal to n(3n | 13)/2.

INFO is an integer variable that reports the status of the results. When HBRD terminates, INFO has one of the following values: INFO <0) This occurs when the user terminates the execution of HEBRID hy resetting the argument IFLAG in the subroutine F to a negative value. “Then INFO tho negative value of IPLAC. INPO 0G (Input Error) no 1, EPS © 0, POL « O, or @« m(Sn ob £8)/2. INFO ob A solution having the desired accuracy was obtained.


<small>Original source: [View scanned PDF page 125](../scans/page_0125.png)</small>

INFO = 2 The number of calls to the subroutine F has reached or exceeded 200(n + 1). INFO = 3 TOL is too small. No further improvement in the accuracy of x is possible. INFO = 4 The routine is making very poor progress. When HBRD terminates, if INFO # 0 then X contains the final iterate that was generated. Also, if INFO > 1 then FVEC contains the values of the functions f,,...,f, at this iterate. If INFO = 2 then it may be helpful to continue the procedure by recalling HBRD with the current point in X as the new starting point. However, this is not advisable when INFO = 4. This setting can arise when x = 0 is a solution or when entrapment occurs. HBRD searches for a solution to the equations by minimizing }°, f.(z)?. In doing this, it can become trapped in a region where the minimum does not correspond to a solution of the equations. This is what occurs when the equations have no solution. When entrapment occurs and the equations are known to have a solution, then it is recommended that the user try a different starting point.

Scaling. If the convergence criterion ||z — z|| < TOL- ||z|| is satisfied and TOL = 10~*, then the larger components of the final iterate z may be accurate to k significant digits but not the smaller components. For example, if TOL = 107° and x = (1.2,.34E-4), then 1.2 may be accurate to 5 significant digits while .34E-4 is accurate to only 1 significant digit. If it is suspected that the smaller components do not have acceptable accuracy, then it is recommended that the variables in the original problem be rescaled and the problem rerun.

**Algorithm.** A modified form of the hybrid Powell procedure is employed.

**Programming.** HBRD is a slightly modified version of the MINPACK-—1i subroutine HY- BRD1. The MINPACK-~-1 subroutines HYBRD, ENORM, DOGLEG, FDJAC1, QFORM, QRFAC, RIMPYQ, and RIUPDT are employed. The subroutines were written by Jorge J. More, Burton S. Garbow, and Kenneth E. Hillstrom (Argonne National Laboratory). The function SPMPAR is also used.

**References.**

(1) More, J. J., Garbow, B.S., and Hillstrom, K. E., User Guide for MINPACK-1, Argonne Nation Laboratory Report ANL 80-74, Argonne, Illinois, (980.

(2) Powell, M.J.D., A Hybrid Method for Nonlinear Equations,” Numerical Methods for Nonlinear Algebraic Equations, P. Rabinowitz (ed.), Gordon and Breach, London, 1970.


<small>Original source: [View scanned PDF page 126](../scans/page_0126.png)</small>

<a id="topic-126-01"></a>
### Solutions Of Quadratic, Cubic, And Quartic Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QDCRT` | `SUBROUTINE` | `A, Z` | [`L29102`](../source_parts/nswc_part_03.f90#L7974) |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [`L29163`](../source_parts/nswc_part_03.f90#L8035) |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [`L29228`](../source_parts/nswc_part_03.f90#L8100) |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [`L29429`](../source_parts/nswc_part_03.f90#L8301) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [`L29650`](../source_parts/nswc_part_03.f90#L8522) |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [`L29800`](../source_parts/nswc_part_03.f90#L8672) |


Given a polynomial ag + a)z +--+ 4,2" with real coefficients where a, # O and n = 2,3 or 4. The following subroutines are available for computing the roots 2, ...,2y of the polynomial.

```fortran
CALL QDCRT(A, Z)
CALL CBCRT(A, Z)
CALL QTCRT(A, Z)
```

It is assumed that A is a real array and Z a complex array. QDCRT is used if n = 2, CBCRT is used if n = 3, and QTCRT is used if n = 4. A is the array of coefficients where A{k) = a,_, for k = 1,2,...,n+ 1, and Z is an array of dimension n. When the appropriate subroutine is called, the roots z;,...,z,, are stored in Z. The real roots precede the complex roots. The real roots are ordered so that |z,| < |z,4:|. The complex roots are unordered except that complex conjugate pairs of roots appear consecutively with the root having the positive imaginary part being first.

**Programming.** Q’i'CRT calls the subroutines CBCRT and AORD, and CBCRT calls the subroutine QDCRT and function CBRT. The routines were written by A. H. Morris and CBCRT was modified by Wm. Davis (NSWC). The function SPMPAR is also used.

```fortran
CALL DQDCRT(A, ZR, ZI)
CALL DCBCRT(A, ZR, ZI)
CALL DQTCRT(A, ZR, ZI)
```

it is assumed that A,ZR, and ZI are double precision arrays. DQDCRT is used if n = 2, DCB: RT is used if n = 3, and DQOTCRT is used if n = 4. A is the array of coefficients where 4(k) = ax—1 fork = 1,2,...,n+1, and ZR and Zi} are arrays of dimension n. When the appropriate subroutine is called, the real parts of the roots Z1,-..,2, are stored in ZR and the imaginary parts are stored in ZI. The real roots precede the complex roots. The real roots are ordered so that [z,| < |z;41). The complex roots are unordered except that complex conjugate pairs of roots appear consecutively with the root having the positive imaginary part being first.

**Programming.** DQTCRI calls the routines DAORD, DCSQRT, and DCBCRT. DCBCRT calls the subroutine DQNDCRT and function DCBRT. The routines were written by A. H. Morris. The function DUMPAR is also used.


<small>Original source: [View scanned PDF page 127](../scans/page_0127.png)</small>

<a id="topic-127-01"></a>
### Double Precision Roots of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [`L29961`](../source_parts/nswc_part_03.f90#L8833) |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [`L30902`](../source_parts/nswc_part_03.f90#L9774) |


Given a polynomial ag + ayz-++-+- + a,2" of degree n > 1. The subroutines DRPOLY and DCPOLY are available for obtaining the roots z,, ...,2, of the polynomial. DRPOLY may be used if the coefficients a; are real, and DCPOLY is applicable if the coefficients are complex. These subroutines perform the calculations in double precision.

```fortran
CALL DRPOLY(OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK)
```

A is a double precision array containing the coefficients where A(7) = an—741 for g=l,...,n+1. ZR and ZI are double precision arrays of dimension n or larger, and NUM ig an integer variable. When IDRPOLY is called, if no errors are detected then NUM = the number of roots that are obtained. If NUM > 1 then the real parts of the roots are stored in ZR(j) and the imaginary parts in ZI{y) for 7 = 1, ..., NUM. The roots are unordered except that complex conjugate pairs of roots appear consecutively with the positive imaginary part being first.

WK is a real array of dimension n + 1 or larger, and DWK is a double precision array of dimension 6(n -+ L) or larger. WK and DWK are work spaces for the routine.

**Error Return.** NUM = —Lifn < lor a, = 0.

**Programming.** DRPOLY employs the subroutines DRPLY1,FXSHFR.QUADIT,REALIT, CALCSC, NEXTK, NEWEST, QUADSD, and QUADPL. These routines exchange information in a labeled common block named GLOBAL. The routines were written by M. A. Jenkins (Queen’s University, Kingston, Ontario), and modified by A. H. Morris. The functions SPMPAR, DPMPAR, and IPMFAR are also used.

**References.**

(i) Jenkins, M. A.,“Zeros of a Real Polynomial,” ACM Trans. Math Software 1 (1975), pp. 178-189.

(2) Jenkins, M. A. and Traub, J. F.,.“A Three-Stage Algorithm for Real Polynomials using Quadratic Iterations,” SIAM J. Numerical Analysis 7 (1970), pp. 545-566.

```fortran
CALL DCPOL?(AR,ALn,Z2,Z1I.NUM,DWK)
```

AR and Al are double precision arrays containing the real and imaginary parts of the

and ZI are double precision arrays of dimension n or larger, and NUM is an integer variable. When DCPOLY 1s called, if no errors are detected then NUM = the number of roots that are obtained. [If NUM > 1 then the real parts of the roots are stored in ZR(j} and the imaginary parts in ZUG} for g =: 1, ...,NUM.

DWK is a double precision array of dimension 10(n + £) or larger that is a work space for the routine.


<small>Original source: [View scanned PDF page 128](../scans/page_0128.png)</small>

**Error Return.** NUM = -1 if n <1 or a, = 0.

**Programming.** DCPOLY employs the routines DCPLY1, CAUCHY, NOSHFT, FXSHFT, VRSHFT, CALCT, NEXTH, POLYEV, CDIVID, and the functions SCALCP, ERREV. These routines and functions were written by M.A. Jenkins (Queen’s University, Kingston, Ontario) and J. F. Traub (Bell Laboratories), and modified by A. H. Morris. The functions DPMPAR, IPMPAR, and DCPABS are also used.

**References.**

(1) Jenkins, M. A. and Traub, J. F., “Algorithm 419, Zeros of a Complex Polynomial,” Comm. AC'M 15 (1972), pp. 97-99.

(2) __—s—s—si, “A Three-Stage Variable-Shift Iteration for Polynomial Zeros and its Relation to Generalized Rayleigh Iteration,” Numer. Math 14 (1970), pp. 252-263.


<small>Original source: [View scanned PDF page 129](../scans/page_0129.png)</small>

<a id="topic-129-01"></a>
### Accuracy Of The Roots Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [`L31553`](../source_parts/nswc_part_03.f90#L10425) |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [`L31707`](../source_parts/nswc_part_04.f90#L1) |


Let z1,...,2, be approximations for the roots of a real or complex polynomial p(z) = Ap +a,z4+---+a,2" of degree n > 1. Then for each z,, the subroutines RBND and CBND obtain the radius 7; of a disk D; = {z : |z — %| < ri} centered at z; which contains a true zero of the polynomial. The radius r, is an upper bound on the absolute error of the approximation 2,.

For each z;, the subroutines also compute the number k, of disks D,; (including the disk D,} which overlap with D,;, The value k, is the number of roots of p(z) that are clustered near z,. If kj = 1 then z,; approximates a simple root.

**Example.** In the figure ky => 1, ke = 3, kg = 2, and k,g = 2.

```fortran
CALL RBND(N, C, W, ABSERR, RELERR, KLUST, KER)
CALL CBND(N, C, W, ABSERR, RELERR, KLUST, KER)
```

A is a real array if RBND is used, and A is a complex array if CBND is used. A contains the coefficients a9,a1,...,@, where A(t) = a.) (¢ = 1,...,n +1), and Z is a complex array containing the approximate roots z),... ,%n.

IERR is an integer variable, 2 a real array of dimension n or larger, and K an integer array of dimension n or larger. When RBND or CBND is called, if no input errors are detected then IERR is assigned the value 0, the radii ry), ...,r, are computed and stored in FR, and the values k,, ...,k, are computed and stored in K.

RERR is a real array of dimension n or larger. If z; = O then RERR{t) is set to — 1 by the routine, and if z, 4 O then RERR(x) © the estimated maximum relative error of z,.

**Error Return.** HORR -— 1 when n < ft and IERR ~ 2 when a, 0. In these cases no computation is performed.

**Programming.** RBND and CBND employ the functions CPABS and SPMPAR. RBND and CBND were written by Carl B. Bailey and modified by Wilham R. Gavin (Sandia Laboratories). The formats of the subroutines were modified by A. Hi. Morris.

