[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-327"></a>
## Approximation of Functions

<small>Original source: [View scanned PDF page 327](../scans/page_0327.png)</small>

<a id="topic-327-01"></a>
### Rational Minimax Approximation Of Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [`L79124`](../source_parts/nswc_part_08.f90#L4748) |


Let a < 6 and g(x) be a continuous nonvanishing function on the interval [a,b]. For any continuous function f(z), let |{f|| denote the weighted norm maz{|f(z)|/|g(z)| : a <x < b}. Also let ¢(2) be a continuous strictly monotonic mapping on [a, 6]. Then for any nonnegative integers € and m, the subroutine CHEBY is available for finding a rational function

R(x) = £2 + prd(z) +++ + ped(z)* qo + q19(z) + +++ + 4mG(z)™

which minimizes || — f||. The subroutine performs the calculations in double precision. It is assumed that the error curve (2) = (R(z) — f(z))/g(x) satisfies |6(z,}| = ||R — f|| at precisely £+ m-+ 2 critical points ro < 41 < --- < 2,(n = 2+ m-+1), and that 6(2,41) = —6(z,) for each t <n.

CALL CHEBY(a, 6, F,G, PHI, ¢, ITER,MXITER, £, m, P,Q, ERROR,IERR,WK)

The arguments a and 6 are double precision real numbers. F, G, and PHI are functions whose arguments and values are double precision real numbers. The functions must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL. The functions evaluate f(r), g(x), and ¢(z) respectively.

The argument ¢ is a double precision tolerance that is supplied by the user. If \ denotes the estimated value of || ~ f{], then the routine converges when the error curve 6(z) satisfies A(i - ©) < [6(z,5)| < ACL 4 ©) for each z,. Thus ¢ specifies the relative agreement that must be attained between ||f -- Ri] and the |5(z,)|. Normally the setting «© © 10°74 will give satisfactory results. It is required that 0 < ¢ < 10 ?.

The Remes-type algorithm designed by Cody, Fraser, and Hart is employed. This algorithm normally requires less than 20 iterations. The argument MXITER — the maximum number of iterations that may be performed. This argument is set by the user. The related argument ITER is an integer variable that is set by the routine. When CHEBY terminates, ITER will have for its value the number of iterations that were actually performed.

P is a double precision array of dimension @{ 1, Q a double precision array of dimension m-+1, ERROR a double precision variable, and JERR an integer variable. When CHEBY terminates, if the rational function approximation A(z) has been obtained then He RR is assigned the value 0 and ERROR is the estimated error (f/f ][. The coefficient p, of the numerator of R(s) is stored in P(r } 1) for s O,1,... 2, and the coefficient gq, of the denominator is stored in Q(7 fot) for py Ob... pa “Phe coefficient qa will always have

the value 1.

Leth @ fang 2. Then Whois a double precision array of dimension ACR ¢ S) or larger

that is used for a work space.


<small>Original source: [View scanned PDF page 328](../scans/page_0328.png)</small>

**Error Return.** IERR is assigned one of the following values when the desired minimizing rational function A(z) is not obtained.

```text
iERR = 1 An input error was detected. Either £< 0,m < 0,€ < 0,€ > 107?,
or g(z) = 0 for some point z.
```

IERR = 2 MXITER iterations were performed. More iterations are needed to obtain R(z). The system of linear equations that define the coefficients p,; and q,; was found to be singular. This indicates that for the current values of £ and m, the numerator and denominator of A(z) may have common factors. A nonmonotonic sequence of critical points z; was obtained. Modify 2 and/or m. The value of the error curve 6(x) at some critical point z; appears to be too large. This indicates that A(z) may have poles, and that m (or possibly a or 6) may have to be modified.

IERR =: 6 CHEBY completely failed to find (or roughly approximate) R(z).

All information in P,Q, and ERROR should be ignored.

If IERR = 2,3,4, or 5 then P and Q contain the coefficients of the most recent rational] function approximation R(z) obtained, and ERROR is an estimate of the error ||R — f|| of the approximation.

IERR

il es

IERR

ll an

IERR :

li uo

**Remark.** The two most common weighting functions employed are g(x) = 1 and g(z) = f(x). If g(x) = 1 then the absolute error is minimized in constructing A(z). If g(z) = f(z) then the relative error is minimized.

**Programming.** CHEBY employs the subroutines CHEBY1, CERR, and DPSLV. These routines were written by A. H. Morris. CHEBY, CHEBY1, and CERR are slightly modified translations of the ALGOL 60 procedures Chebychev, lineq, del, and surmis given in the

**reference.**

Reference, Cody, W. J., Fraser, W., and Hart, J. F. “Rational Chebychev Approximation using Linear Equations,” Numerische Mathematik 12 (1968), pp. 242 251,


<small>Original source: [View scanned PDF page 329](../scans/page_0329.png)</small>

<a id="topic-329-01"></a>
### Lp Approximation of Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [`L79470`](../source_parts/nswc_part_08.f90#L5094) |


For any continuous real-valued function f(z) defined on the interval [a,b], let ||f|I, denote the Z, norm defined by

file = (2 Le (ei? day ff I<p<oo

([fllp= max{|f(z)|:@<a2<b} if p=oo. If p = oo then the norm is also known as the Chebyshev norm. For any continuous function f, 0 < p < oo, and € > O, the subroutine ADAPT 1s available for finding a continuous piecewise polynomial function ¢ that satisfies |j/f — @||, < €.

CALL ADAPT(F, a, 6, ¢, k, ERROR,XKNOTS, C, IND, y, n, £, ANORM, DX,MO,m,XBREAK,KDIFF ,DLEFT,DRIGHT)

It is assumed that the polynomials which form the approximation ¢ are of degree < n. The argument n must satisfy 1 <n < 19, and IND is a variable. When ADAPT is called, if there are no input errors and ¢ is successfully constructed, then IND is set to 0, a sequence of points a = zy < +++ < 2e_y < ry = 5 is selected, and ¢ takes the form

```text
P(r) = cso + ea (e— 2y)+-++en(2— 2)" 4 SoS a4
fors=1,...,k—1. The points 2,,. .,2, are called the knots (or nodes) of ¢.
```

The argument yz is the maximum number of polynomials that may be used :n forming @. ERROR and & are variables, XKNOTS an array of dimension p+ 1 or larger, and C a 2-dimensional array of dimension pz x (n +1). ADAPT sets & to the number of knots that are generated. The knots 21, ...,2, are stored in the XKNOTS array, and the coefficients Cic, ---yCin are stored 3: C(t,1),...,C(i,n +1) fort = 1,...,k — 1. FRROR is a rough estimate of the error ||f — ¢]|p.

The argument @ specifies the degree of smoothness that the approximation ¢ must satisfy. it is assumed that 0 < @< 10 and n > 2é. If @ == O then it is only required that @ Ye continuous on the interval [a,6]. Otherwise, if @ > 1 then it is assumed that f is of class C'f on [a,}] except at possibly a finite number of points (called break points), and it is required that ¢ be of class C* on [a,b] except possibly at the break points.

The argument mi specifies the number of break points of f. It 1s assumed that m < 20. If mn = O then the arguments XBREAK,KDIFF,DLEFT, and DRIGH'S can be ignored. Otherwise, ifm > 1 then it is assumed that XBREAK,KOIFF DLEFT, and DRIGHT are arrays of dimension m or larger, and that

XBREAK(s) © the i break point, call it uy,

K DIFF (+) the smallest integer v, for which the vu" derivative of f does not exist or is not continuous at u,, DLEFT(s) the value from the left f the vf" derivative at v,, and DRIGHT(:) the value from the right of the v.* derivative atu, for: ot, ...,ma tas also assumed that as uy eo -++ So uy ct Gand no Qe, for each oy.


<small>Original source: [View scanned PDF page 330](../scans/page_0330.png)</small>

F is the name of a user defined function that has the value F(z, D) = f(z) fora < x < 6. If 2 = 0 then 1 can be ignored. (However, D must still be given as an argument of /’.) Otherwise, if 2 > 1 then D is an array of dimension greater than or equal to @. For any x not a break point in XBREAK, the user must set D(j) = the j** derivative of f at x for j < €. However, if x = XBREAK(s) then the user need only set. D(7) = the j** derivative of f at z for J < KDIFF(#). The function F must be declared in the calling program to be of type EXTERNAL.

The argument DX specifies the maximum distance to be permitted between the knots a;, and the argument ASIORM specifies the norm to be used. Set ANORM = +£1.0 for Ly approximation. ANORM = +2. for Lz (least. squares) approximation. ANORM = 3.0 for £.. (minimax) approximation. ANORM = ~-pfor L, 0 < p< oc) approximation.

ll

Before considering the argument MO, one should be briefly acquainted with how ADAPT operates. ADAFT employs the following procedure to construct ¢.

(1) Set I = [a,b] and & = 1. Let a be the first knot of ¢.

(2) If the interior of i contains no break points then go to (3). Otherwise, if J = [c,d] then partition J into the subintervals [c,u] and [u,d] where u is the smallest. break point greater than c. Stack the right subinterval {u,d] and reset I to [{c, ul.

(3) Construct a polynomial ¢; on J using Hermite interpolation. If the length of the interval Tis < DX and ¢, satisfactorily approximates f on J, then go to (4). Otherwise go to

(4) Set k to be K+ 1. Let dy; be the (kK — 1)* polynomial forming ¢ and let the right end point of J be the k** knot of d. If the interval stack is empty then the procedure is finished. Otherwise, obtain from the stack the next interval I to be considered and return to (2).

(5) The polynomial ¢; cannot be used. Partition 4 into halves, stack the right subinterval and reset J to be the left subinterval. Then go to (3).

The argument MO specifies the accuracy criterion that che approximation ¢ ig to satisfy on a subinterval I == [c,d] of (a, 6]. It is assumed that MO = 0,1,2. If the L., norm is used

then MC is ignored! and ¢ is required to satisfy | f(z) — d(z)| <« fer e < 2 < d. Otherwise,

if the Lp, (0 < p < o) norm is used then ¢ is required to satisfy:

d doe / Lf (2) - p(x) [P da = hogs for MO =. O ad | \f(z) - b(a)/P deo for MO: 2

The setting MO © 0, which is the most commonly used setting, requires the total error

oy Hf ty < «. The alternate setting MO. 2 employs ¢ to control local accuracy. If ¢ consists of kT polynomials then the total error If bil, (& HP Phis setting can

THowever, it ds still required that MQ - 0,1,2


<small>Original source: [View scanned PDF page 331](../scans/page_0331.png)</small>

be useful when f is rough. A (heuristic) compromise strategy is provided when MO = 1. At each step in the formation of ¢, the MO = 1 strategy estimates the total number of subintervals that will finally be needed and adjusts the error requirement for the subinterval I accordingly. This strategy attempts to keep the total error to a minimum while relaxing the local accuracy criterion demanded by the MO = 0 setting.

**Remarks.** IND, &, »,n, €, MO, m, and KDIFF are integer arguments. All other arguments (including F) are double precision arguments.

**Error Return.** ADAPT assigns IND cone of the following values:

IND = 0 The approximation was successfully constructed.

IND = —1 Hither a > 6 or one of the arguments €, n, 2, ANORM, MO, m is assigned an incorrect value.

IND = —2 [a,}] is too small an interval.

IND = ~3 DX is less than (b — a)/y. Since only y subintervals can be used and each subinterval must be of length < DX, the interval |u, 6] cannot be covered. Make DX or yp larger.

IND = —4 The restriction a < uy < +--+ < ty < 5 on the break point» is violated.

IND = --5 Either KDIFF(:) <0 or KDIFF() > (n ~ 1)/2 for some ¢.

IND = J ADAPT selected 4: +1 knots. More knots are needed to complete the problem.

IND = 2 A subinterval J = [c,d] must be partitioned into subintervals [c, u] and |u,d] where u is a break point. However, this cannot be done either because the interval stack is full, or partitioning will produce too small an interval. (The stack can hold only 50 subintervals).

IND = 3 A subinterval must be partitioned because its length is greater than DX. However, this cannot be done since the interval stack is full.

IND = 4 A subinterval must be partitioned so that the accuracy criterion

can be satisfied. However, this cannot be done either because the stack is full, or partitioning will produce too small! an interval.

If an input error is detected (i.e., if IND < 0) then no cornputation is performed. Otherwise, if IND > O then when ADAPT terminates k := the number of knots generated, XKNO'US contains the knots, C contains the coefficients of the polynomials generated, and EathOR contains the error estimate for f ~- ¢ over the interval covered.

**Remarks.**

(1) if the Z,, norm is used then ¢ controls absolute accuracy, not relative accuracy. This should be kept in mind when ¢€ is to be set for any Lp norm.

(2) ADAPT requires more time when £ > 2 than when € ~~ O or 1. However, the choice of the norm normally has little effect on the efficiency of the routine.

(8) ADAPT can yield excellent results even when the derivatives of f have singularities. The one major exception is when the first derivative of fis not bounded. Then the routine can be expected to fail.


<small>Original source: [View scanned PDF page 332](../scans/page_0332.png)</small>

**Example.** The following code can be used for approximating f(r) = e” on the interval (0, 1).

DOUBLE PRECISION Ff, A, B, EPS, ERROR, ANORM, DX DOUBLE PRECISION XKNOTS (11), C(16,20) INTEGER KDIFF(1) DOUBLF PRECISICN XBREAK(1),DLEFT(1),DRIGHT(1) EXTERNAL F DATA MAX, A, B, DX/19, 0.D0, 1.D0, 1.D0/ N=8 L=1 EPS = 1.D-12 ANORM == 3.D0 CALL ADAPT(F,A,B,EPS,K ,ERROR,XKNOTS,C,IND, * MAX,N,L,ANORM,DX,0,0,XBREAK,KDIFF,DLEFT,DRIGHT)

Here F° may be defined by:

DOUBLE PRECISION FUNCTION F(X,D) DOUBLE PRECISION X,P(1)

F == DEXP(X)

D(1) =

RETURN

END

In the ADAPT statement XBREAK, KDIFF, DLEFT, and DRIGHT are ignored since m= 0,

**Programming.** ADAPT employs the subroutines ADAPT1, ADSET, ADTAKE, ADCOMP, NEWTON, ADCHK, ADPUT, ADTRAN and functions ERRINT, POLYDD. These routines exchange information in labeled common blocks. The block names are 1NPUTZ, RESULZ, KON'TRL, and COMDIF. The routines were written by John R. Rice (Purdue University) and modified by A. H. Morris. The function DPMPAR is also used.

**References.**

(1) Rice, J. R.,“Algorithm 525. ADAPT, Adaptive Smooth Curve Fitting,” ACM Trans. Math Software 4 (1$78), pp. 82-94.

(2) _, “Adaptive Approximation,” J. Approx. Theory 16 (1976), pp. 329-337.


<small>Original source: [View scanned PDF page 333](../scans/page_0333.png)</small>

<a id="topic-333-01"></a>
### Calculation Of The Taylor Series Of A Complex Analytic Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [`L80512`](../source_parts/nswc_part_08.f90#L6136) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [`L80741`](../source_parts/nswc_part_08.f90#L6365) |


Let f(z) = 37 an(z — zo)” denote the Taylor series of an analytic function f around

n>0 a point 2). Then the subroutines CPSC and DCPSC are available for obtaining the coefficients a, of the series. CPSC obtains single precision results and DCPSC obtains double precision results.

```fortran
CALL CPSC(F, Z, N, IC, TOL, R, RS, ERR)
```

it is assumed that f(z) is a user defined function whose arguments and values are complex numbers. The argument f must be declared in the calling program to be of types COMPLEX and EXTERNAL.

The argument zo is complex, n is an integer where 1 < n < 51, and Ais a complex array of dimension n or larger. IND may be any integer. If IND == 0 then a, is computed and stored in A(j +1) for j = Q,1,...,n — 1. Otherwise, if IND # 0 then {(zo) and the derivatives f'(zo), ...,f'"-1)(z9) are computed and stored in A.

The argument € specifies the relative accuracy of f. If it is estimated that f produces results accurate to k significant decimal digits then one may set ¢ = 10-*. It is assumed that ¢ > O. If « = 0 then the results of f are assumed to be correct to machine precision,

When CPSC is called, {(z) is «valuated on circles of various radii around the point zo. R is a real variable. On input, # is the radius of the first circle on which f(z) is to be evaluated. After using this radius, the radius is repeatedly modified {first by factors of 2 or 1/2) until a suitable final radius r, is obtained for deriving the values cf the coefficients a;. This radius, whose value depends on e, is called the computational radius of the series Ya;(z -- zo)". When the routine terminates, F is assigned the value r,.

ERR is a real array of dimension n or larger. On output, ERR(j) is the estimated absolute error of A(j) for j = 1,...,n.

Usage. Given a radius R, f(z) is evaluated on k equidistant points on the circle of radius R around zg where k= & when bin <6, k= 16 when 7 <n < 12, kw 82 when $3 <n < 25, k = 64 when 26 <n < 51. it is assumed that f(<) has at least one nonzero coefficient a, among the first k/2 coefficients, and at least one nonzero coefficient among the next k/2 coefficients. Thus, the routine should not be used to obtain coefficients of a low degree polynomial such as f(z)eo 1 ~ 2%, In such cases, the results will normally be incorrect, In general, the selection of the radius Roof tie first circle on which f (2) is evaluated is not bothersome. A randomly selected value of moderate size, such as A 6.2738, almost

AB9


<small>Original source: [View scanned PDF page 334](../scans/page_0334.png)</small>

always suffices. No difficulties normally arise when the initial radius R is greater than the radius of convergence of the series Na;(z ~ zo)?. However, difficulties do arise when

(1) the routine attempts to evaluate f too close to (or exactly at) a singularity,

(2) f has a Taylor series expansion which contains one or more extremely large isolated terms (e.g., f(z) = 10° + sinz),

(3) f has a branch point near zo, or

(4) The initial radius R is too far from the computational radius r, (see the error return section below).

The risk of (1) occurring is minimized by the random selection of an initial radius R. For (2) and (3), a severe loss of accuracy can occur when a large number of coefficients are requested. In these cases, any loss of accuracy is reported by the ERR array.

Error return. A(j) is assigned the value 0 and ERR(j) is set to 10!° for 7 = 1,...,n when the initial radius R differs from r, by a factor of 30000 or greater.

**Programming.** CPSC was written by Bengt Fornberg (California Institute of Technology) and modified by A.H. Morris. CPSC employs the function SPMPAR.

**References.**

(1) Fornberg, B.,“Numerical Differentiation of Analytic Functions,” ACM Trans. Math Software 7, 1981, pp. 512-526.

(2) sis “Algorithm 579. CPSC: Complex Power Series Coefficients,” ACM Trans. Math Software 7, 1981, pp. 542-547.

```fortran
CALL DCPSC(FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR)
```

F is the name of a user defined subroutine that has the format: CALL F(z, y, u,v) This subroutine is used for evaluating f(z) at point z. The arguments x and y are the real and imaginary parts of z, and u and v are the real and imaginary parts of f(z). The arguments x and y have double precision values, and u and v are double precision variables. F must be declared in the calling program to be of type EXTERNAL.

The arguments x9 and yo, which have double precision values, are the real and imaginary parts of z9. The argument n is an integer where 1 < n < 51, and AR and AI are double

real and imaginary parts of a, are stored in AR(j +1) and AI(j+ 1) for 7 =0,1, ...,n—- 1. Otherwise, if IND # 0 then the real and imaginary parts of f(zo) and the derivatives f'(zo), - wy f(z) are stored in AR and AI respectively.

The argument ¢, which has double precision values, specifies the relative accuracy of the subroutine F. If it is estimated that # produces results accurate to k decimal digits then one may set ¢ ~ JO°*. It is assumed that « > O. Ife © O then the results of F are assumed to be correct to machine precision.

When DCPSC is called, f(z) is evaluated on circles of various radii around the point zo. fis a double precision variable. On input, A is the radius of the first circle on which


<small>Original source: [View scanned PDF page 335](../scans/page_0335.png)</small>

f(z) is to be evaluated. After using this radius, the radius is repeatedly modified (first by factors of 2 or 1/2) until a suitable final radius r, is obtained for deriving the values of the coefficients a;. This radius, whose value depends on ¢, is called the computational radius of the series Da,(z — zo)?. When the routine terminates R is assigned the value rg.

ERR is a double precision array of dimension n or larger. On output, ERR(j) is the estimated absolute error of the complex value stored in AR(j) and Al{j) for j= 1, ...,n.

Usage. DCPSC is used in the same manner as CPSC. See the usage section for CPSC.

**Error return.** AR(j) and AI{j) are assigned the value 0 and ERR(j) is set to 161° for j=1,...,n when the initial radius R differs from r, by a factor of 30000 or greater.

**Programming.** DCPSC is an adaptation by A.H. Morris of the subroutine CPSC, written by Bengt Fornberg (California Institute of Technology). (31CPSC employs the function DPMPAR.

**References.**

(i) Fornberg, B.,“Numerical Differentiation of Analytic Functions,” ACM Trans. Math Software 7, i981, pp. 512-526.

(2) __, “Algorithm 579. CPSC: Complex Power Series Coefficients,” ACM Trans. Math Software 7, 1981, pp. 542-547.

