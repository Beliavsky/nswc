[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-336"></a>
## Curve Fitting

<small>Original source: [View scanned PDF page 336](../scans/page_0336.png)</small>

<a id="topic-336-01"></a>
### Linear Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TRP` | `FUNCTION` | `A, N, X, Y` | [`L93051`](../source_parts/nswc_part_09.f90#L8172) |


Let a be a real number and (21,41), ...,(%n, Yn) @ sequence of points. The following function performs a linear interpolation at point a.

```fortran
TRP(A, N, X, Y)
```

It ia assumed that n > 2 and 2] < +++ < a. X and ¥ are arrays containing the abscissas 21, ..., 2, and ordinates y;, ...,Yn respectively. TRP(a,n, X,Y) = 6 where b is the value of the interpolation at a.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 337](../scans/page_0337.png)</small>

<a id="topic-337-01"></a>
### Lagrange Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [`L93088`](../source_parts/nswc_part_09.f90#L8209) |


Let {(z:,yi:): $ = 1,...,n} be a set of n > 2 points where 21 < +++ < 2,,m be an integer where 2 < m < n, and £1,...,%,% be k > 1 points at which m point Lagrange interpolation is to be performed. The subroutine LTRP is available for performing this interpolation.

```fortran
CALL LTRP(M, X, Y, N, XI, YI, NI, T, IERR)
```

X is an array containing :t),...,2,, Y an array containing y;,...,y,, XI an array containing %;,...,Z,, and YI an array of dimension k or larger. When LTRP is called, if no input errors are detected then interpolation is performed at each Z; and the result stored in YI(j) for 7 = 1,...,k.

T is an array of dimension m or larger. The array is used as a temporary storage area by the routine.

**Error Return.** JERR is a variable that is set by the routine. If no input errors are detected then IERR is assigned the value 0. Otherwise, IERR is assigned one of the following values:

```text
IERR = 1 ifm < 2.
IERR =2 ifm>n.
IERR =3 ifk <1.
```

When an error is detected LE RP immediately terminates.

**Algorithm.** If z; = (x; -+2;4m)/2 for some #, then (z,, ys), ..-,(Zs4m—1) Yit¢m—1) are the m data points used in the Lagrange interpolation at Z;. Otherwise, the data points selected for the interpolation are those m points (2,, yi) whose abscissas are closest to Z,.

Linear Interpolation. For m = 2, if the abscissae x; are not equally spaced then LTRP can produce different results than the linear interpolating function TRP. If z; lies in the interval [7,;,2;,1) then TRP always uses the data points (2,,y;) and (241, Y%41) to find the interpolated value at z;. However, the operation of LTRP is somewhat different. For example, if the point Z; in (2, . 7;1.1) is closer to 2,;_1 than to 2,44, then (z;_1, y—1) ane (z;,y:) will be the data points employed in the interpolation. Thus, TRP will normally be the procedure that will be desired for linear interpolation.

**Programming.** Developed by A. H. Morris. The portion of the code for finding the subinterval containing £; was written by Rendall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 338](../scans/page_0338.png)</small>

<a id="topic-338-01"></a>
### Hermite Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [`L93244`](../source_parts/nswc_part_09.f90#L8365) |


Let r1,...,%% be k > 1 distinct points. For each x; assume that we are given nj > 1 values y;, yi, we yl ) ifn = nm, +--+: + n,, then there exists a unique polynomial of degree n -— 1 which satisfies

```text
Pas) = ys
p(23) = y
```

for each t = 1, ...,4. The subroutine HTRP is available for obtaining this polynomial.

```fortran
CALL HTRP(N, X, Y, A, T, IERR)
```

```text
X and Y are arrays of dimension n containing the following information: X(7) =
zy for j = 1,...,ny and Y(1),...,¥ (m1) contain the values y, ,y}, ey ye, For
t= 2,...,k let my = ny +--+ + ny. Then X(m +7) = x for j = 1,...,n; and
```

Y(m, +1), ...,¥(m,-+ n,)} contain the values y;, y/, ..., yr,

A is an array of dimension n and JERR an integer variable. When HTRP is called, if no errors are detected then IERR is assigned the value O and the coefficients a, of the

n-1

```text
polynomial p(x) = ao + 55 a;(z—- X(1)}--- (2 — X(z)) are computed and stored in A(j +1)
jg=1
```

for 7 =0,1,...,n-—1

WK is an array of dimension n or larger that is a work space for the routine.

**Error Return.** If an error is detected then IERR is assigned one of the following values:

TERR = 1 The argument n is not positive.

TERR = 2 There exists integers 1 and @ for which X/s) = X(@) but X(t) # X(j) for some j where t < 7 < @. In this case, the values t and & are stored (in floating point form) in WK(i) and WK(2).

When an error is detected, the routine immediately terminates

```text
Example. If ;(G) = 2, p(--1) = 1, and p'(~1) = 2 where x, = 0 and 22 = ~-1, then HTRP
stores 2,1,-1lin A. Hence, p(z) = 2+ 7% — 2(z + 1) is the desired polynomial.
```

n-1 Remark. ‘The Newton representation ag >> a;(z - X(1))---(z@~ X(y)) of the polynomial gal n— p(z) can be converted to the Taylor series representation > c,(z ~ a}? by the subroutine gra

PCOEFF

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 339](../scans/page_0339.png)</small>

<a id="topic-339-01"></a>
### Conversion Of Real Polynomials From Newton To Taylor Series Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [`L93297`](../source_parts/nswc_part_09.f90#L8418) |


n—-1 For n > 1 let p(z) = ag + SD a;(x - 21)--- (a — z;). Then for any real number a, y=l the subroutine PCOEFF is available for converting the polynomial p(z) to the Taylor series

n-1 . form >> ¢,(z — @)?. jg=0

```fortran
CALL PCOEFF(ALPHA, N, X, A, C, T)
```

X is a single precision real array containing 21, ...,%,— 1, A a single precision real array containing @9,4@), ...,@,—1 where a, is stored in A(j +1) for 7 = 0,1,...,n-—1, and C a single precision real array of dimension n or larger. When PCOEFF is called then the coefficients c; of the Taylor series representation are computed and stored in C(j + 1) for 7=0,1,...,2-1.

T is a double precision array of dimension n or larger. The array is a work space for the routine. (The conversion of the coefficients is done in double precision.)

**Note.** A and C may reference the same storage area, in which case the results c; will overwrite the input data a;.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 340](../scans/page_0340.png)</small>

<a id="topic-340-01"></a>
### Least Squares Polynomial Fit

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [`L93329`](../source_parts/nswc_part_09.f90#L8450) |


Let {(2;,4;):# = 1,...,m} be a set of m > 2 points where 2; 4 xz; for i #7. Then for any positive integer n where n<m, the subroutine PFIT is available for obtaining the

```text
(unique) nt} degree polynomial p(z) = > a;z? which minimizes x (p(zs) ~ ys)?.
g==0
```

```fortran
CALL PFIT(ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR)
```

X is an array containing 21,...,2%m, Y an array containing y1,...,¥m, and A an array of dimension n+ 1 or larger. RNORM and JERR are variables. When PFIT is called, if no input errors are detected then IERR is set to 0, the coefficients a, of p(x) are stored in A(j +1) for 7 =0,1,...,n, and RNORM is assigned the value Jds(p(z;) — ys)?.

PHI is an array of dimension 2(n + 1) or larger, and WK is an array of dimension 4m or larger. PHI and WK are work spaces for the routine.

**Error Return.** JERR =1 ifn <lorn>m.

**Algorithm.** The abscissas x; are first mapped into values in the interval [-1,1]. Then the Forsythe procedure is used.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 341](../scans/page_0341.png)</small>

<a id="topic-341-01"></a>
### Weighted Least Squares Polynomial Fit

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [`L93490`](../source_parts/nswc_part_09.f90#L8611) |


Let {(2,,y:) : # = 1,...,m} be a set of m > 2 points where 2, 4 x; fort #7, and let w, > O(1 = 1, ...,m) be weights. It is assumed that m,, > 2 where m, is the number of nonzero weights. For any positive integer n where n < m,, the subroutine WPFIT is

bi . available for finding the (unique) n‘® degree polynomial p(z) = )>ajz7 which minimizes

mm 3=0

Ls ws(p(zs) — yi)?.

=

```fortran
CALL WPFIT(ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR)
```

X is an array containing 41, ...,2m, Y an array containing yi,...,ym, W an array containing w;,...,wWm,, and A an array of dimension n + 1 or larger. RNORM and IERR are variables. When WPFIT is called, if no input errors are detected then IERR is set to 0, the coefficients a; of p(x) are computed and stored in A(j +1) for 7 = 0,J,...,n, and RNORM is assigned the value \/D,;w,(p(z;) — yx)?.

PHI is an array of dimension 2(n + 1) or larger, and WK is an array of dimension 4m or larger. PHI and WK are work spaces for the routine.

**Error Return.** IERR = 1 ifn <lorn> my, and IERR = 3 if some w, is negative.

**Algorithm.** The abscissas zx; corresponding to the positive weights are first mapped into values in the interval [—1,1]. Then the Forsythe procedure is used.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 342](../scans/page_0342.png)</small>

<a id="topic-342-01"></a>
### Cubic Spline Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [`L93667`](../source_parts/nswc_part_09.f90#L8788) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [`L93801`](../source_parts/nswc_part_09.f90#L8922) |


Given z; < +--+ < ay. A function f(z) is a cubic spline having the nodes(knots) Z1,...,;%y if f is a polynomial of degree < 3 on the interval [z,,2;41] fori =1,...,n—-1, and the first and second derivatives f’(2) and f(x) exist and are continuous for all z. If f{; denotes the polynomial for the interval [z;, 2,41] then f; has the form:

fi(z) = yt ac(x — 2;) + by(z ~— 2)? + oy (2 — 2,)%.

Consequently, the function f is obtained by fitting the polynomials f,, ..., fx—1 together at the points 72,...,¢%,-1. For 2 < 2, f(z) = fi(z), and for x > 2, f{z) = fa_i(z). Also f(z.) = ys for? =1,...,n—1. Hence, if f(z.) = y, then f interpolates the points (z,, y;) fort 1,...,n.

Assume now that the ordinates y;,...,Y, are given. Then there exist an infinitude of splines with nodes 21, ..., 2, that interpolate the points (2,,y,). In general, two independent conditions must be imposed to uniquely specify the interpolating spline f which is of interest. Frequently, f is restricted on the first interval [x1,22] by requiring that f(x) or f(z) has a given value, or that f is continuous at zz. Also, f is restricted on the last interval [z,_1,2,] by requiring that f’(z,) or f’(z,) has a given value, or that f is continuous at 2,1. The subroutine CBSPL is available for obtaining the spline when these restrictions are employed. Alternatively, f may be required to satisfy the conditions

{"(a1) = af"(z2) 1 B lal < 1

when n > 4. Then the subroutine SPLIFT is available for obtaining the spline. CALL CBSPL(X,Y, A, B,C, n,t1,%2, wi, wz, TERR)

X and Y are arrays containing the abscissas 21, ...,2,, and ordinates yy, -.., Yn. It is assumed that rp. 77) so 2, andr 3. A,B and C are arrays of dimension mn or larger, and TERR an integer variable. When CBSPL is called , if no input errors are detected then IERR is set to OQ. Also, the coefficients ay,d,e. (8 1,0... 1) of the interpolating spline {(2) are stored in A,B,C, and A(n) is set to f'(r,,).

The arguments 1,,%2, tw), wy specify the conditions that the spline f(z) must satisfy. tt

is assumed that t) and rg have the values O,1,2 where:

tO fis continuous at ry. t, O fos continuous at or, 7. 1) ! f'(r1) has the value wy), Ly ! f'(4,) has the value us). ty 2 of" (ry) has the value wy. ty 2 f(r) has the value w,,

Ifa, Othen the argument wy as ignored, and ifa, O then wy is ignored

**Error Return.** TERR bafas SambleRR 2afar, cory. for somes


<small>Original source: [View scanned PDF page 343](../scans/page_0343.png)</small>

**Remarks.**

( ) B(n) and C(n) are used for temporary storage.

(2) Ift; =%2 =O and n = 3, then it is also assumed that f'(ze} + f'(zg) = 2( He =¥2).

(3} After A,B and C have been obtained, then SCOMP or SCOMP1 may be used to evaluate the spline at any point z. SEVAL or SEVAL1 may be used if derivatives are

also desired.

**Programming.** CBSPL is an adaptation by A. H. Morris of the subroutine CUBSPL, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978. CALL SPLIFT(X, Y, DY,DDY,n,W, IERR,MO, «, 8, &, 8)

X and Y are arrays containing the abscissas 71, ...,z,, and ordinates y1,..., Yn. It is assumed that 7; < +--+ <2, andn> 4. DY and DDY are arrays of dimension n or larger, and IERR an integer variable. When SPLIFT is called, if there are no input errors then IERR is assigned the value 0, the first derivatives f’(7,),.... f'(a,) are computed and stored in DY(1),...,DY(n), and the second derivatives f"{11),...,f"(zn) are computed and stored in DDY(1), ..., DDY(n).

W is an array of dimension 3n or larger that is used for a storage area. On the first call to SPLIFT the argument MO must be set to 0. When SPLIFT is initially called, certain calculations which depend only on the values of a, @, and 21, ...,2%, are performed and the results stored in W. On subsequent calls to SPLIFT, if only values of @,8 or y1,...,Yn are modified, then the information in W need not be recomputed. Set MO = 1 and the information in W will be reused.

Error Return if there is an input error then {ERR is set as follows: IERR = 1 if {aj > Lor jal > 1. IERR = 2 ifn < 4. TERR = 3 if the restriction 2; < +++ < x, 1s not satisfied. Remarks.

1) After DY and DDY have been obtained, then SCOMPL or SCOMP2 may be used to evaluate the spline at any point 2. SEVALT or SEVAL2 may be used if derivatives are also desired.

(2) Given the values y) and y!. Then there exists a unique interpolating cubic spline f that satisfies f’(z,) - y) and f'(rn) > yf. This spline can be obtained by setting ass ao = 1/2 and

ty +1 | 72 ry ry | .

**Programmer.** Rondall 2. Jones (Sandia Laboratories),

fe


<small>Original source: [View scanned PDF page 344](../scans/page_0344.png)</small>

<a id="topic-344-01"></a>
### Weighted Least Squares Cubic Spline Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [`L93963`](../source_parts/nswc_part_09.f90#L9084) |


Let ty < +++ < tg be a sequence where @ > 2, {(aj,y:):¢ =1,...,m} be a set of m > 4 points where ty <2) <-+- < 2, < te, and wy, ..., Wm be positive weights. Then the subroutine SPFIT is available for obtaining a cubic spline f(z) with the nodes ty, ...,te

mm which minimizes ) w; (f(z:) — y:)*. This spline is represented by tet

j{z) = 25 +a; (x ~ ty) 4 b5(2-- t;)? + cs (2 _ t;)°

fori, Sor < tya1 (7 = 1,...,€-1). if the nodes are selected so that £ < m — 2 and each interval (t;,;41) contains a data point z,,, then this least squares approximation is unique.

```fortran
CALL SPFIT(X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR)
```

X is an array containing 21,...,2%m, Y an array containing y1,...;Ym, W an array containing wy,,...,Wm, and T an array containing tj,...,t2. Z,A,B,C are arrays of dimension &— 1 or larger, and IERR is an integer variable. When SPFIT is called, if no input errors are detected then IERR is set to 0. Also, the coefficients z;,a;,6,,c; of the least squares approximating spline f(x) are computed and stored in Z, A, B,C.

WK is an array of dimension 7@+ 18 or larger that is a work space for the routine.

```text
Erroi Return. TERR is set to one of the following values when an input error is detected.
IERR = 1 iff < 2.
IERR = 2 if ty < +--+ < tis not satisfied.
IERR = 8 ifm > 4 and t; <2, <--- <2, < t, are not satisfied.
```

If an error is detected, the routine immediately terminates.

**Remarks.**

(1) Occasionally, accuracy can be lost when t, = rm. Therefore, it is recommended that te > Im.

(2) After A,B,C, and Z have been obtained, then SCOMP may be used to evaluate the spline at. any point z. SEVAL may be used if derivatives are also desired.

**Programming.** SPFIT employs the subroutines BSPP, BSLSQ, BSPVB, BCHFAC, and BCHSLV. SPFIT was written by A. H. Morris.


<small>Original source: [View scanned PDF page 345](../scans/page_0345.png)</small>

<a id="topic-345-01"></a>
### Least Squares Cubic Spline Fitting With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [`L94055`](../source_parts/nswc_part_09.f90#L9176) |


Let ty <++* < tg be a sequence where @ > 2, and {(t4,y:) : i = 1,...,m} be a set of pointe where t) < 2) < +++ < 2m, < tg. Then the subroutine CSPFIT is available for obtaining a cubic spline f(x) with the nodes t; ...,t, which minimizes DS (2s) — ys)? subject to a set of constraints. This spline is represented by

fort; S@<toyy Gad... f- 1.

```text
Notation. For any real x, f) (x) will denote the value f(z) if j = 0, the 7*® derivative of
f at vif 7 = ft or 2, and the right third derivative j/“(x+) if j = &.
```

```fortran
CALL CSPFIT(X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR)
```

X is an array containing 2), ...,2m, Y an array containing y,, ...,y¥m, and 7’ an array containing ¢,,...,i¢. The argument k is the number of constraints to be satisfied (k > 0) and XCON, it, NDER are arrays of dimension max{1, k} or larger.

if& > 1 then XCON contains the points #,, ...,&, at which the constraints are placed.

The points may be given in any order and need not be distinct. It is assumed that ti< Eo <tyfert=,...,6. At & any of the following types of constraints

itupe = 0 f)(%,) <r,

itype= Lf (2.) > 4,

‘uppe 2 fH) = ry

```text
itype = 3 fO(H) = FON(r,)
can be impused where 7 = 9,1,2, or 3. For the selected constraint, it is assume:} that
R(t} = rj and NDER(t) = itype + 47. Wf an itype 3 constraint is imposed then it is turther
ausumed that ty <r, < ty.
```

WK and IWK are arrays that are work spaces for the routine. On input, IWK(4) is the dimension of WK and IWK(2) the dimension of WK. If £ = 0 then one may set IWK(L) =- Nts and }WK(2} = @ where NB «= 7(@+ 7}. Otherwise, let v = £ + 3, m, be the number o¢ equality (i.e., “type 2 and 3) constraints, and m, the number of inequality (atype QO and 1) constraints. Then one must set

\

IWK(L) 2 NB + (eo 4 k)u td 2(m, tv) + (me tv) + (my + Q)lv + 8) IWKE2) > my + de.

**Remarks.**

(1) Wk > tthen one can let the routine determine the amount of storage that is needed for Wh and 1 Wh. Set WAHL) > Not anc IWK{2) - 2, in which case errors will occur

(sce the IND. 6,--7 error values below). (2) NDER(s} taay t+ assigned a negative value (¢ ~ 1, ..,k). 1 NDERQG) «hoa the i’ constraint (4 ignored


<small>Original source: [View scanned PDF page 346](../scans/page_0346.png)</small>

2, A, 2,C are arrays of dimension #-- 1 or larger, When CSPEIJT is cal’ad, if the cubic spline f(x) is obtained then the coefficients z;,a;,6,;, ¢; of the spline are store] in Z, A, B,C,

```text
iND is a variable that reports the status of the results. When CSPFIT terminates,
IND is assigned one of the following values:
```

IND = G The spline was obtained.

IND = 1 The equality (ie., itype 2 and 3) constraints are contradictory. The spline was obtained where the equality constraints were satisfied in a least squares sense.

IND = 2 The spline could not be obtained. The constraints are contradictory.

IND = -1 €< 2.

IND = -2 m<Qork <0.

IND == -3 t, > t;41 for some t.

IND = —4 The assumption ty < 21 <<-++< 2, < tz is not satisfied.

IND = -5 The t* constraint is incorrect for the value of ¢ stored in IWK(2).

IND = —6 Insufficient storage was specified for the WK array. IWK(1) has been reset, to the amount, of storage needed by WK.

IND = --7 Insufficient storage was specified for the IWK array. IWK{2) has been reset, to the amount of storage needed by IWK.

IWK{1) and IWK(2) are not modified when IND # —5, —6, --7.

**Example.** if one wants f to be convex on an interval [t;,¢;41], then this is equivalent to requiring that "(z) > Q on the interval. Thus, since f is a cubic polynomial on the interval, it suffices to require that f’(t;) > 0 and f'(ti41) > 0. For these two constraints, 9 is the

appropriate value for the NDER array.

**Programming.** CSPFIT employs the subroutines BFIT and BSPP, and the functions and subroutines used by BFIT. CSPFIT was written by A. H. Morris.


<small>Original source: [View scanned PDF page 347](../scans/page_0347.png)</small>

<a id="topic-347-01"></a>
### Cubic Spline Evaluation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [`L94139`](../source_parts/nswc_part_09.f90#L9260) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [`L94241`](../source_parts/nswc_part_09.f90#L9362) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [`L94345`](../source_parts/nswc_part_09.f90#L9466) |


Given a1 <i: <t,. A function f(r) is a cubic spline having the nodes (knots) €1,...,% If f is a polynomial of degree < 3 on the interval [2,,2,44.;] forts 1, ...,n— 1, and the first and second derivatives f’(«) and f‘(a) exist and are continuous for all x. If f; denotes the polynomial for the interval [z,, 244.1] then f; has the form:

Silz) = ye + ae(e — xy) + O;(x — 23)? 4+ (2 ~ 2,)*

Consequently, the function f is obtained by fitting the polynomials f,,..., fy—1 together at the points ro, ...,¢,-14. For 2 < 2, f(x) == fi(r), and for x > a, f(x) = fys(c). Also f(z,;) = y Tor f= 1,...,n-—1. Hence, if f(an} = y, then f interpolates the points (ty, 4) ford 4, 0. yn,

A cubic spline f given by the polynomials f,,...,f/,~1 is uniquely defined by any of the following three sets of data:

(1) the points (2,, ys) aad coefficients a,, b,c, for f= 4, ...,n-~1

(2) the points (z,, y:) and first derivatives f’(2,) for f= 1,...,n

(8) the points (#,;,y,) and second derivatives f"(z,) for 7= 1, ...,n The subroutines SCOMP, SCOMP!, SCOMP2 are available for computing the spline at any point z. SCOMP is used if data set (1) is given, SCOMP! is used if data set (2) is given, and SCOMP2 is used if data set (3) is given.

```fortran
CALL SCOMP(X, Y, A, B, C, N, XI, YI, NI, IERR)
```

Let N =n-—1. Then N is the number of polynomials * that form the spline, X and Y are arrays containing the abscissas 7,,...,24 and ordinates y,,...,yn, and A,B,C are arrays containing the coefficients a,,b;,c; (6 = 1,..., NM). It is assumed that N > i and that ay << oy,

Let £1,...,2m be the points at which the spline J 1s to be evaluated. XI is an array containing %,,...,2,,, YJ an array of dimension m or larger, and IERR a variable. When SCOMP is called, ifm < I then [ERE is set to 1 and the routine terminates. Otherwise, if m > | then IERR is set to 0 and f(#,) is computed and stored in YI(y) for 7 = 1, ...,m.

**Note.** SCOMP does not require f to be a spline. It is only required that f;(x) be a cubic polynomial y: 4 ay(a -- xz) + B(x — xy)" + ey(a ~ 2)? and that

f(a) = fylz) fora > ay.

In this case, SCOMEP computes the value ffa,+) for j <1, ..,m.

fol


<small>Original source: [View scanned PDF page 348](../scans/page_0348.png)</small>

**Programming.** Adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SCOMP1(X, Y, YP, N, XI, YI, NI, IERR)
```

X, Y, DY are arrays containing the abscissas 21,...,2,, ordinates y1,..., Yn, and first derivatives f'(x1),..., f’(an) respectively. It is assumed that n > 2 and 21 <+++ < gy.

Let 71, ...,Zm be the points at which the spline f is to be evaluated. X! is an array containing #1, ...,2%,,, YI an array of dimension mi or larger, and [ERR a variable. When SCOMPL is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, ifm > 1 then IERR is set to 0 and f(Z;) is computed and stored in YI(7) for 7 = 1, ...,m.

**Programming.** Adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SCOMP2(X, Y, YPP, N, XI, YI, NI, IERR)
```

X, ¥Y, DDY are arrays containing the abscissas <;,...,2,, ordinates y1,...,y, and second derivatives f"(z;),...,f"(zn) respectively. It is assumed that zy < +++ < 2, for n> 2,

Let %1,...,Z,, be the points at which the spline f is to be evaluated. XI is an array containing £1,...,%m, Yl an array of dimension m or larger, and JERR a variable. When SCOMP2 is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, ifm > 1 then IERR is set to O and f(Z,;) is computed and stored in YI(j) for j = 1, ...,m.

**Programmer.** Rondall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 349](../scans/page_0349.png)</small>

<a id="topic-349-01"></a>
### Cubic Spline Evaluation And Differentiation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [`L94452`](../source_parts/nswc_part_09.f90#L9573) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [`L94561`](../source_parts/nswc_part_09.f90#L9682) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [`L94671`](../source_parts/nswc_part_09.f90#L9792) |


Given 21 < +++ < rq. A function f(x) is a cubic spline having the nodes (knots) 1,...,2, if f is a polynomial of degree < 3 on the interval [2.,%s41] forf == 1,...,n—1, and the first and second derivatives f’(r) and f(x) exist and are continuous for all z. If f; denotes the polynomial for the interval {2,;,2,;41] then f; has the form:

f(z) = Y, + a,(x _ z;) Sa by (x _ x;)? “t+ (x - x,)°

```text
Consequently, the function f is obtained by fitting the polynomials f;, ..., fa—1 together
at the points %2,...,2%,-1. For z <2, f(z) = fy(x), and for z > x, f(x) = f,_4(zx). Also
f(z;) = y fori =1,...,n- 1. Hence, if f(z.) = yn then f interpolates the points (zx, yx)
for?=1,...,n.
```

A cubic spline f given by the polynomials f,,...,f,—1 is uniquely defined by any of the following three sets of data:

(1) the points (z;, y,;) and coefficients a;,b;,c; fort =1,...,n—1

(2) the points (z,,y,) and first derivatives f'(z,) for? =1,...,n

(3) the points (z,, y;) and second derivatives f"(a,) fori =1,...,n The subroutines SEVAL, SEVAL1, SEVAL2 are available for computing the spline and its first and second derivatives at any point 2. SEVAL is used if data set (1) is given, SEVAL1 is used if data set (2) is given, and SEVAL?2 is used if data set (3) is given.

```fortran
CALL SEVAL(X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR)
```

Let N =n-—1. Then N is the number of polynomials f; that form the spline, X and Y are arrays containing the abscissas 21, ...,zNn and ordinates y1, ..., yn, and A, B,C are arrays containing the coefficients a,,b,,c;(i = 1, ..., N). It is assumed that N > 1 and that Ty <eee S EN.

Let £1,...,2m be the points at which the spline f and its first two derivatives are to be evaluated. XT is an array containing £1, ...,%m, YI, DY!, DDYI are arrays of dimension m or larger, and IERR is a variable. When SEVAL is called, if m < 1 then IERR is set to i and the routine terminates. Otherwise, ifm > 1 then IERR is set to 0 and the values f(%;), £'(&;), f"(2;) are computed and stored in YI(j), DYI(7), DDYI(j) for 7 = 1, ...,m.

**Note.** SEVAL does not require f to be a spline. It is only required that fi{=) be a cubic polynomial y. 4 a,(xz — 2,;) + 6, (x — 2)? + ¢,(z — z,)® and that

```text
f(z) =fi(z) forz< 2
f(z) =fi(z) for 2, <2 < tiqy (L<t< N)
f(z) =fn(x) for2 > tn.
```

In this case, SEVAL computes the values f(2;+), f'(Z;+), {"(z,+) for j = 1,...,m.


<small>Original source: [View scanned PDF page 350](../scans/page_0350.png)</small>

**Programming.** Adaptation by A. II. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SEVAL1(X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR)
```

X, Y, DY are arrays containing the abscissas 21, ...,2,, ordinates y,, ..., Yn, and first derivatives f'(xi), ..., f’(xn) respectively. It is assumed that m > 2 and 21 <+++ < 2p.

Let %1,...,%m be the points at which the spline f and its first two derivatives are to be evaluated. XI is an array containing Z1, ...,2m, YI, DYI, DDYI are arrays of dimension m or larger,and IERR is a variable. When SEVAL1 is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, if m > 1 then [ERR is set to O and the values f(#;), f'(@;), f'"(,) ave computed and stored in YI(j), DYI(7), DDYI(y) for 7 = 1, ...,m.

**Programming.** Adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SEVAL2(X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR)
```

X, Y, DDY are arrays containing the abscissas 2,...,2%,, ordinates yj,...,y¥,, and second derivatives f"(x1),..., f"(2n) respectively. It is assumed that n > 2 and 21)<:++<ay.

Let %1,...,Zm be the points at which the spline f and its first two derivatives are to be evaluated. Xi is an array containing %;, ...,%m,Y{, DYI, DDYI are arrays of dimension m or larger,and IERR is a variable. When SEVAL2 is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, if m > 1 then IERR is set to 0 and the values {(2;), f'(Z;), f"(%;) are computed and stored in YI(7), DYI(j), DDYI(j) for j = 1, ...,m.

**Programmer.** Rondall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 351](../scans/page_0351.png)</small>

<a id="topic-351-01"></a>
### Integrals Of Cubic Splines

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [`L94783`](../source_parts/nswc_part_09.f90#L9904) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [`L94891`](../source_parts/nswc_part_09.f90#L10012) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [`L95013`](../source_parts/nswc_part_09.f90#L10134) |


Given x, <--> < 2,. A function f(x) is a cubic epline having the nodes (knots) Ty,...,%, 1f f is a polynomial of degree < 3 on the interval [z;, 241] fort =1,...,n — 1, and the first and second derivatives f’(2) and f(r) exist and are continuous for all x. If f; denotes the polynomial for the interval [z,, 2,41] then f; has the form:

```text
fiz) = ys + asf — 24) + b;(2 — 2)? + ¢;(2 — 2,)8
Consequently, the function f is obtained by fitting the polynomials f;, ..., f,—1 together
at the points x2, ...,%,—1. For z < 2, f(x) = f;(z), and for z > x, f(z) = fn—i(z). Also
f(2;) == yy for ¢ = 1, ...,n— 1. Hence, if f(z.) = yn then f interpolates the points {z,, y;)
fort =1,...,n.
```

A cubic spline f given by the polynomials f,, ..., fy.-1 is uniquely defined by any of the following three sets of data:

(1) the points (z,, y;) and coefficients a,,b;,c; fort? =1,...,n--1

(2) the points (z,,y;) and first derivatives f'(z,;) for i=1,...,n

(3) the paints (z,, y;) and second derivatives f"(z;) fori =1,...,% For any real a and f the functions CSINT, CSINT1, CSINT2 are available for computing the integral je f(t) dt. CSINT is used if data set (1) is given, CSINT1 is used if data set (2) is given, and CSINT2 is used if data set (3) is given,

```fortran
CSINT(X, Y, A, B, C, N, ALPHA, BETA)
```

Let N =n -~ 1. Then N is the number of polynomials f; that form the spline, X and Y are arrays containing the abscissas 41, ...,zy and ordinates y;,...,yn, and A, B,C are arrays containing the coefficients a,,b,,c,(1 = 1, ..., N)}. It is assumed that N > 1 and that

ry <+++< ay. Then CSINT has the value f? f(t) dé. Programming. CSINT calls the function INTRVL. CSINT was written by A. H. Morris.

```fortran
CSINT1(X, Y, YP, N, A, B)
```

X, Y, DY are arrays containing the abscissas 21, ...,Z,, ordinates y1, ...,,, and first derivatives f'(r1),..., f'(zn) respectively. It is assumed that n > 2 and ay < ++) < ay. Then CSINT1(X,Y,DY,n,a, 6) = J? f(t) de.

**Programming.** CSINT1 calls the function INTRVL. CSINT1 was written by A. H. Morris. CSINT2(X, Y,DDY, n, «, #)

X, Y, DDY are arrays containing the abscissas r,,...,2,, ordinates yj,...,yn, and

second derivatives f"(21),...,f"(zn) respectively. It is assumed that n> 2 and 2y)<:++<z,.

Then CSINT2(X,¥,DDY,n,a, A) f" f(t) dt.

**Programming.** CSINT2 calls the function INTRVL. CSINT2 was written by A. H. Morris.


<small>Original source: [View scanned PDF page 352](../scans/page_0352.png)</small>

<a id="topic-352-01"></a>
### Periodic Cubic Spline Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [`L95115`](../source_parts/nswc_part_09.f90#L10236) |


Given w; < +++ < a,. A function f(x) is a cubic spline having the nodes (knots) %1,...,2, if f is a polynomial of degree < 3 on the interval [z,, 2,41] for ¢ = 1,...,n - 1, and the first and second derivatives /'(z) and f(x) exist and are continuous for all z. If f, denotes the polynomial for the interval [z,;,2;:,] then f; has the form:

filz) = ys + aj(x ~ x4) + b:(x — ay)? + cy(x - 2,)°. Consequently, the function f ir obtained by fitting tue polynomials f,, ..., fy—1 together at the points 22, ...,2%y--4.

```text
Normally, a cubic spline f is defined for x ¢ [z1,x,,) by letting f(x) = f(x) for 2 < 21
and f(r) = fy-.1(z) for z > ay. However, if
```

f'(zit) = f'(an-) f"(21+) _ f"(tn~) are satisfied then f may be defined for x ¢ (x1, z,] by requiring that f(z +p) = f(z) for

all c where p = 2,, — 21. The function f is called a periodic spline when this is done.

Now if the values yi, ...,4n—1 ate given, then there exists a unique periodic cubic spline f having the nodes z;,...,2, and satisfying f(2s) = uy; for? = 1,..,n-1. The following subroutine is available for obtaining the coefficients a;,b,,¢; of this spline,

```fortran
CALL PDSPL(X, Y, A, B, C, N, T, IERR)
```

X is an array containing 21, ...,%, and Y an array containing y1,...,Yn—1. It is

assumed that 4; < +++ < 2, and m > 3. A,B,C are arrays of dimension n — 1 or larger, and IERR a variable. When PSP? is called, if ro input errors are detected then [ERR is set to 0 and the coefficients a,;,6,,c, of the interpolating periodic cubic spline are stored in A,B,C.

WK is an array of dimension n ~ 2 or larger that is 1 work space for the routine.

**Error Return.** [ERR = 1 if n < 3 and IPRR = 2 if 2; > £441 for some ¢.

**Remark.** After A, B, and C' have been obtained, then PSCMP may be used to evaluate the periodic spline at any point zr. PSEVL may be used if derivatives are also desired.

**Programmer.** A. HH. Morris.

AGT


<small>Original source: [View scanned PDF page 353](../scans/page_0353.png)</small>

<a id="topic-353-01"></a>
### Least Squares Periodic Cubic Spline Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [`L95245`](../source_parts/nswc_part_09.f90#L10366) |


Let t) <+-+ < t, be a sequence where é > 2 and { (2;,4;) :¢ =1, ...,m} a set of points where t) < 21 < +++ < am < te. Then the following subroutine is available for obtaining a periodic cubic spline f(x) with the nodes ¢;, ...,t¢ which minimizes >°>,(f(z;) — y:)?. This spline is represented by

fx) = 25 +a;(x—t;) +6; (2 - t;)? + ¢;(2 — t,)* fort; <2 <tj;4: G=1,...,@—1). CALL PDFIT(X,Y,m,T,@, Z, A, B,C,WKIWK,IERR)

X is an array containing 21, ...,2m, Y an array containing y,, ...,Y%m, and T an array containing t1,...,te. Z,A, B,C are arrays of dimension £— 1 or larger. When PDFIT is called, if the desired periodic cubic spline is obtained then the coefficients z;,a;,b;,¢; of the spline are stored in Z, A, B,C.

WK and [WK are arrays that are work spaces for the routine. On input TWK(1) is the dimension of WK and IWK(2) the dimension of IWK. It is required that IWK(1) > (é+-6)(€-+ 15) + 10 and IWK(2) > 2¢+- 6.

TERR is a variable that reports the status cf the results. When PDFIT terminates, IERR has one cf the following values:

IERR = 0 The desired spline was obtained.

IERK = 1 The spline could not be obtained.

IERR = 2 Either m <0 or @ < 2.

TERR. = 3 t; > t;41 for some 7.

TERR = 4 The assumption t, < 21 <-:+< 2, < t¢ is not satisfied.

IERR =: 5 Insufficient storage was specified for the WK array. IWK(1) has been reset to the amount of storage needed by WK.

TERR = 6 Insufficient storage was specified for the IWK array. TWK(2) has been reset to the amount of storage needed by TWK.

If an error is detected, then JERR > 2 and the routine terminates.

**Remark.** After A, 8,C, and Z have been obtained, then PSCMP may be used to evaluate the periodic spline at any point x. PSEVL may be used if derivatives are also desired.

**Programming.** PDFIT employs the subroutines BSPP, BFIT, BFITO, ENDACC, BNDSL,

BSPVB, BSPVD, LSEI, and the subroutines and functions used by LSEL PDEIP was written by A. H. Morris.


<small>Original source: [View scanned PDF page 354](../scans/page_0354.png)</small>

<a id="topic-354-01"></a>
### Periodic Cubic Spline Evaluation And Differentiation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [`L95337`](../source_parts/nswc_part_09.f90#L10458) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [`L95417`](../source_parts/nswc_part_10.f90#L1) |


Let z1 <+++ < zy be a sequence where n > 2, and f a periodic cubic spline where f(z) = yy + a(x — 2) + (2 — x;)? + (x _ z;)°

fora, <2 < 24) ($= 1,...,n- 1). Then the subroutine PSCMP is available for evaluating the spline for all points x, and the subroutine PSEVL is available for computing its derivatives.

```fortran
CALL PSCMP(X, Y, A, B, C, N, XI, YI, M, IERR)
```

X is an array containing 71, ...,2%,, Y an array containing y,,...,Yn—1, and A,B,C arrays containing the coefficients a,,6;,¢; (( = 1, ...,n—1). It is assumed that 21 <-++ <2, and n> 3.

Let Z), ...,%,, be the points at which the periodic spline is to be evaluated. XI is an array containing Z;, ...,2%m, YI an array of dimension m or larger, and JERR a variable. When PSCMP is called, if no input errors are detected then IERR is set to 0 and f(z,) is computed and stored in YI(7) for 7 = 1, ...,m.

**Error Return.** IERR = 1 ifn <3 or m< 0.

**Programmer.** A. H. Morris. CALL PSEVL(X,Y, A, B,C,n,XLYI,DYI,DDYI,m, IERR)

X is an array containing 21,...,2,, Y an array containing yi, ...,Yn—1, and A,B,C

arrays containing the coefficients a,b,c; (= 1, ...,n~1). It is assumed that 1; <-++ < 2, and n > 3.

Let £1, ...,2m be the points at which the periodic spline and its first two derivatives are to be evaluated. XJ is an array containing %1,...,%m, YI, DYI, DDYI are arrays of

dimension m or larger, and IERR a variable. When PSEVL is called, if no input errors are detected then IERR is set to 0 and f(#,), f‘(2;), f(#,) are computed and stored in YI(j), DYI{j), DDYI(j) for 7 = 1, ...,m.

**Error Return.** ERR = 1ifn <3 orm <0.

**Programmer.** A. Hl Morris.

A71}


<small>Original source: [View scanned PDF page 355](../scans/page_0355.png)</small>

<a id="topic-355-01"></a>
### N-Dimensional Cubic Spline Closed Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [`L95504`](../source_parts/nswc_part_10.f90#L88) |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [`L95729`](../source_parts/nswc_part_10.f90#L313) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [`L95811`](../source_parts/nswc_part_10.f90#L395) |


Given m > 2 points x = (x41, ..+)%in) Where n > 2. One procedure for fitting a closed curve to the points is to first let s; = 0,8; = 9;-,+ [25 —2y~1|| for ¢ = 2, ...,m, and 8m+1 = 9m + ||t1 — Zm||,1 next let t; = 8:/8m+1 fori =1,.. ,m-+1, and then to find for each j <n the periodic cubic spline +,(t) having the knots ty, ... rtmii where 7;(t,) = 2, for i < m. The mapping 7(t} = (y1(t), ...,7(t)) then defines on the interval (0, 1] a closed curve which traverses the points (¢1,21), ...,(tm,2m), (1,21) and satisfies ¥'(0) = ¥'(1) and ¥"(0) = 7"(1). For t < 0 and t > 1, ¥(t) is defined by periodicity (having period 1). The subroutine CSLOOP is available for obtaining the derivatives ¥;(ts) which characterize this curve, the subroutine LOPCMP is available for computing the curve, and the subroutine LOPDF is available for differentiating the curve.

```fortran
CALL CSLOOP(M, N, X, KX, T, DX, KDX, WK, IERR)
```

X is an mxXn matrix whose i'" row contains the point 2; = (211, -.-;2sn), Where mm > 2

and n > 2. It is assumed shat the points 21, ..., 2, are indexed in the order that they are to be traversed by the curve -/(t). It is also assumed that 2; 4 241 forts 1,...,m—-! and that 2, 4 2;.

DX is a 2-dimensional a) ray containing at least m rows and n columns. The arguments kx and kdz have the following values:

kx = the number of rows in the dimension statement for X in the calling program

kdz = the number of rows in the dimension statement for DX in the calling program It is required that kx © m and kdr > m.

JERR 1s a variable) and 7 an array of dimension m or larger. When CSLJOP is called, if no input errors are detected then IERR is assigned the value 0 and ¢;, ... ,'m are computed and stored in 7. Also, the derivatives 1; (ts) are computed ind stored in DX, where the 1!" row of DX contains y'(t,) == (y{ (ti), -.., 74 (ts).

WK is ar array of dimension 4(m 1) or larger that is a work space for the routine. Error Return. ERR reports the following input errors: IERR lo ifm<2orn< 2

JERR =. 2 fa, 2,4, for some t.

IERR- 3 ifay, ry.

**Remark.** After 17 and DX are obtained, LOPCMP may be used to compute the curve aud LOPDF may be used to differentiate the curve.

**Programming.** CSLOOP calls the subroutine CSLOPL and function SNRM2. CSLOOP and CSLOPI were written by A. HL Morris

miEsn Veve2 for any cs (43, 2... 2).


<small>Original source: [View scanned PDF page 356](../scans/page_0356.png)</small>

```fortran
CALL LOPCMP(M, N, T, X, KX, DX, KDX, L, TI, Z, KZ)
```

T is an array containing the knots t;, ...,tm, X an mxn matrix whose 1*%

row contains the point z;, and DX an m x n matrix whose #*” row contains the derivative '(t;). The arguments kz and kdz have the following values: kz = the number of rows in the dimension statement for X in the calling program kdz = the number of rows in the dimension statement for DX in the calling program

It is assumed that m > 2,n > 2, kx > m, and kdzr > m.

Let t,,...,¢, be the points at which the curve y is to be evaluated. TI is an array containing ¢;, ...,¢, and Z a 2-dimensional array containing at least & rows and n columns. The argument kz is the row dimension for Z in the calling program. It is assumed that

```text
€> 1 and kz > @. When LOPCMP is called, y(t;) = (41(t,), -.., m(t;)) is computed and
stored in the #'" row of Z for1=1,...,2.
```

**Programmer.** A. H. Morris.

```fortran
CALL LOPDF(M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ)
```

T is an array containing the knots ¢;,...,t,,, X an ms X n matrix whose 1*4 row contains the point z;, DX an m x n matrix whose 1°” row contains the derivative 7'(t,). The arguments kz and kdr have the following values:

kz = the number of rows in the dimension statement for X in the calling program

kdz = the number of rows in the dimension statement for DX in the calling program

It is assumed that m > 2,n > 2, kr > m, and kdz > m.

4, DZ, and DDZ are arrays of dimension n. For any real to, y(to) == (a1(ts), ---, In{to)), ¥'(to) == (yi (to), ---, 7, (to)), and 4/(to) = (ai/(ta), -.., 7% (to)) are computed and stored in Z, DZ, and DDZ respectively.

**Programmer.** A. H. Morris.

Aid


<small>Original source: [View scanned PDF page 357](../scans/page_0357.png)</small>

<a id="topic-357-01"></a>
### Spline Under Tension Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [`L95879`](../source_parts/nswc_part_10.f90#L463) |


Given real og anda, <---<z,. A function f(z) isa spline having the tension factor o and the nodes (knots) x1, ...,2, if f(x) and its first two derivatives are continuous on [t1,2n], and f(x) — 6? f(z) = ayz + 6, on the interval [z,, 2541] for # = 1,...,n- 1, Here @ = jo|(n -- 1)/{a_ ~ v1) and a,, 6; are constants. For zy < 2 < 2,41 f(z) can be represented by

```text
J (x) = Aysinha(z — z;) + Bysinh @(2,41 - x) - (ajz + 6,)/e?
when o #0, and by a cubic polynomial when o = 0.
```

Assume now that n ordinates y;, ...,y, are given. Then there exist an infinitude of splines f(z) having tension o for which f(z,) = y (f = 1,...,). However, if values y{ and y/, are given then oily one of these splines will satisfy f/{z,) = yj and f’({r,) = y/,. For convenience, denote this spline by f,. If o = 0 then it is clear that f, ia the standard cubic spline. Also it can be verified that when a — oo, f, converges uniformly on [z1, zy] to the piecewise linear function é(z) where €(x) = y; + m,(z — 2;) for xy < z < ay41 (¢=1,...,n-—1). Here mn, = (ysa1 ~ ys)/(2i41 — 24). The following subroutine is available for obtaining the spline f,.

```fortran
CALL CURV1(N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR)
```

X and Y are arrays containing the abscissas x1, ...,2,, aud ordinates y1,...,Yn- [tis assumed that n > 2 and rz; <+-- < ay.

```text
SLP1 and SLPN are assigned the values y} and y). The user may omit values for
either or both of these arguments. IND specifies the information that is provided.
IND = 0 Values are supplied for SLP] and SLPN.
IND =1 A value is sunphed for SLPi but not for SLPN.
IND = 2 A value is supplied for SLPN but not for SLP1.
IND = 3 Values are not supplied for SLPI and SUPN.
```

If a value is not supplied by the user, then the routing provides a value. DDY is an array of dimension rv or larger, and [ERK is an integer variable. When

CURV 1 is called, if no input errors are detected then HERR is assigned the value 0 and the second derivatives f7/(21), ..., f0/(2,) are computed and stored in DDY.

TEMP ts an array of dimension mn or larger that 1s used fur a work space.

**Error Return.** fle RK reports the following input errors: HERR - bafae 2.

IPRR 2 of ey coe) \ ay is not satisfied

When either of (oese errors as detected, the routine immediately terminates,


<small>Original source: [View scanned PDF page 358](../scans/page_0358.png)</small>

```text
Remarks.
(1) After DDY is obtained then CURV2 may be used to evaluate the spline at any point z.
(2) X, ¥Y, na, SLP1, SLPN, IND, o are not modified by CURV3.
```

**Programming.** CURV1 employs the subroutines CEEZ, TERMS, and SNHCSH. CURVI, CEEZ, and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

**Reference.** Cline, A. K.,“Scalar and Planar Valued Curve Fitting using Splines under Tension,” Comm. ACM 17 (1974), pp. 218-220.


<small>Original source: [View scanned PDF page 359](../scans/page_0359.png)</small>

<a id="topic-359-01"></a>
### Spline Under Tension Evaluation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [`L96057`](../source_parts/nswc_part_10.f90#L641) |


Given o and 2 < +++ < ty. A function f(x) is 4 spline having the tension factor o and the nodes (knots) «,, ...,2, if /(x) and its first two derivatives are continuous on [1,2], and f(r) — #? f(z) = age + b, on the interval la;,2ia1] ford = 1,...,n—- 1%. Here @ = |o|(n—1)/(2, ~ #1) and aj, d, are constants. If f(z) = f(x) for aysarcoyy, then f(x) can be represented by

fi(z) = Ay sinh (2 - z,) + Bysinh F(ay41 - 2) — (ax + b)/a?

```text
when ¢#0, and by a cubic polynomial when g = 0. For v < zy we let {(z) = fi(z), and for
x > ty we let f(z) = fa—1{z).
```

Assume now that f(z;) = y; for ¢ = 1,...,n. Then for a fixed o, f(z) is uniquely defined by the points {2,,y,;) and the second derivatives {"(x,)(¢ = 1,...,n). When this data is available, the following function may be used to compute the spline at any point ¢,

CURV2(t,n, X,Y, DDY,o}

\* and Y are arrays containing the abscissas 11, ...,2, and ordinates ys, .o +3 Yn, and DDY is an array containing the second derivatives f"(z1),...,f(z,). It is assumed that n>2 and a <+++ < a,. CURV2(t,n, X,Y DDY, a) = f(t) for any real t.

**Remark.** After DDY has been obtained, CURV2 may be repeatedly called to evaluate the curve at different points so long as the tension factor o remains fixed. However, if ¢ is modified then the derivative information in DDY will have to be recomputed before CURV2 can be used with the new tension factor.

**Programming.** CURV2 employs the function INTRVL and subroutine SNHCSH. CURV2 was written by A. K. Cline and R. J. Renka (University of Texas at Austin). INTRVL was written by A. H. Morris.

**Reference.** Cline, A. K., “Scalar and Planar Valued Curve Fitting using Splines under Tension,” Comm. ACM 17 (1974), pp. 218-220.


<small>Original source: [View scanned PDF page 360](../scans/page_0360.png)</small>

<a id="topic-360-01"></a>
### Differentiation And Integration Of Splines Under Tension

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [`L96160`](../source_parts/nswc_part_10.f90#L744) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [`L96256`](../source_parts/nswc_part_10.f90#L840) |


Let f(x) be a spline having the tension factor o and the nodes 21, ...,%n. Assume that f(ts) = ye ford = 1,..., 2. If the second derivatives f'(r;), ..., f" (zp) are known then the following functions may be used for differentiating and integrating the spline.

```fortran
CURVD(T, N, X, Y, YP, SIGMA)
```

X and Y are arrays containing the abscissas 7), ...,2%, and ordinates y1,...,yn, and DDY is an array containing the second derivatives f"(i71),..., (ay). It is assumed thai n> 2and gj <++: < 2,. For any real ¢, the derivative f’(é} is computed and assigned to be the value of CURVD(t,n, X,Y, DDY,¢).

Programming. CURVD employs the function INTRVL and subroutine SNHCSH. CURVD was written hy A. K. Cline and R. J. Renka (University of Texas at Austin). INTRYL was written by A. H. Morris.

```fortran
CURVI(XL, XU, N, X, Y, YP, SIGMA)
```

X and Y are arrays containing the abscissas z,, ...,%,_ and ordinates yi,.. ,y,, and DDY is an array containing the second derivatives f"(r,),...,f"(2,). It is assumed thai n> 2and rz <+++ <a,. CURVI(a,b,n,X,Y,DDY,o) = f° f(t)dt for any real 2 and 6.

**Note.** It is not required that a < A. Programming. CURVI employs the function INTRVL and subroutine SNHCSH. CURVI

was written by A. K. Cline and R. J. Renka (University of Texas at Austin). INTRVL was written by A. H. Morris.

AT9


<small>Original source: [View scanned PDF page 361](../scans/page_0361.png)</small>

<a id="topic-361-01"></a>
### Two Dimensional Spline Under Tension Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [`L96447`](../source_parts/nswc_part_10.f90#L1031) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [`L96661`](../source_parts/nswc_part_10.f90#L1245) |


Given a sequence of points (21,41), ...,(@n, Yn). One procedure for fitting a curve to she points is to let a, = 0 and 8; = 4,.1 + \ (xg ~ ays )® + yy ~ 1)? for ¥ = 2,...,n, and than to find two splines #(s) and y(s) with tension o that satisfy a{s;) == a, and yl) ss y fort =: ],...,n. Tf 8, and 6, ere the desired angles for the curve 6 ++ (x(s), y(s)) at. the points (1,41) ‘and (zn, Yn}, then the splines z(s) and y(s) can be selected so that a'(s;) = cos; and y'(s;) = sin@, for f = 1,n. The curve « +> (x(s),y(s)) then passes through the points (z,,y,) and has the required slopes at the end points. The subroutine KURVL is available for obtaining the second derivatives 2(s,;),y"(a,)(¢ = 1, ...,n) which characterize this curve, and the subroutine KURV2 is available for computing the curve.

```fortran
CALL KURV1(N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR)
```

\* and Y are arrays containing the abscissas 21, ...,2%, and ordinates y1, ...,Yn. It is assumed that n > 2 and that tne points (~;, y;) are indexed in the order that they are to be traversed by the curve. It is also assumed that (24, Ys) # (S41, 441) for P= 1,...,n-- 1.

SLPi and SLPN are assigned the values 0; and @,,. These angles are measured counterclockwise (in radians} from the positive x-axis. The user may oi‘ values for SLP! and/or SUPN. IND specifies the information that is provided.

IND == 0 Values are supplied for SLP1 and SLPN.

```text
IND = 1 A value is supplied for SLP1 but not for SLPN.
UNT} = 2 A value is supplied for SLPN but not for SLP1,
IND = 2 Values are not supplied for SLP1 and SLPN.
```

If a value is not supplied by the user, then the routine provides a value.

a is the tension factor to be employed. If |¢i is small, say jo! < 107%, then z(s) and u(e)} approximate cubic splines. Otherwise, if |o| is large, say |o| > 100, then the resulting curve approximates the polygonal line from (2;, 41) to (21, Yn).

HERR is an integer variable and S, WDX, DDY are arrays cf dimension n or larger. Whoa KOURV1 is called, if no input errors are detected then TERR is assigned the value O aud the values 51, ...,@, are computed and stored in S. Also, the second derivatives wis... 2(s,) and y(s1),...,y"(8_) are computed and stored in DDX and DDY.

EMP is an array of dimension n or larger that is used for a work space. Error Return. IERR reports the following input errors: [ERR = Liffn < 2. TERR = 2 if (ty, ys) © (tsa, ue4i) for some ft. When either of these errors is detected, the routine immediately terminates. Remark. After S, DDX, DDY are obtained, KURV2 may be used to compute the curve.

**Programming.** KURVI employs the subroutines CEEZ, TERMS, and SNHCSH. KURVI,


<small>Original source: [View scanned PDF page 362](../scans/page_0362.png)</small>

CEEZ, and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

```fortran
CALL KURV2(T, XS, YS, N, X, Y, XP, YP, S, SIGMA)
```

X and Y are arrays containing the abscissas 1, ...,<, and ordinates yj,...,Yn, 5 is an array containing 81,...,8,, and DDX and DDY are arrays containing the second derivatives 2(91),...,2"(8,) and y"(s1), ...,y"(s,).

Now consider the change of variables ¢ = ¢/s,, and let t ++ (Z(t), 9(t)) denote the curve in terms of the new parameter t. XT and YT are real variables. For any O < ¢ < 1, KURV2 computes the point (z(t), g(t)) on the curve and assigns XT the value Z(t) and YT the value

g(t).

**Remark.** After DDX and DDY have been obtained, KURV2 may be repeatedly called to evaluate the curve at different points so long as the tension factor ao remains fixed. However, if o is modified then the derivative information in DDX and DDY will have to be recomputed before KURV2 can be used with the new tension factor.

Programming. KURV2 employs the function INTRVL and subroutine SNHCSH. KURV2

was written by A. K. Cline and R. J. Renka (University of Texas at Austin). INTRVL was written by A. H. Morris.


<small>Original source: [View scanned PDF page 363](../scans/page_0363.png)</small>

<a id="topic-363-01"></a>
### Two Dimensional Spline Under Tension Closed Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [`L96783`](../source_parts/nswc_part_10.f90#L1367) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [`L96967`](../source_parts/nswc_part_10.f90#L1551) |


Given n > 2 points (21,41), ..., (2a, Yn)- One procedure for fitting a closed curve to the points is to let ¢; = JV (21 ~ tn)? + (yi — yn)? and 3, = sg.4 + V(x ~ 2-1)? + (yi — yyy)? for t= 2,...,n,and then to find periodic splines x(¢) and y(s) with tension o that pass through the points (91,7.), ...,(91,2n),(81 + 8,21) and (81,y)), . -+5(8n; Yn), (81 + 8n, 41). The mapping 8 +-+ (2:(s), y(s)) then defines a closed curve that passes through the points (25, ys). The subroutine KURVP1 is available for obtaining the second derivatives x"(s,), y"(8,)(t = 1,...,n) which characterize this curve, and the subroutine KURVP2 is available for com-

puting the curve.

```fortran
CALL KURVP1(N, X, Y, XP, YP, TEMP, S, SIGMA, IERR)
```

X and ¥Y are arrays containing the abscissa 21, ...,2, and ordinates y,, te) Yn Lb is assumed that n > 2 and that the points (z,, y;) are indexed in the order that they are to be traversed by the curve. It is also assumed that (2,, yi) # (2s41, yep1) for? =1,...,n - 1.

g is the tension factor to be employed. If |o| is small, say |o| < 107, then 2(s) aud y(s) approximate periodic cubic splines. Otherwise, if |o| is large, say |a| > 100, then the curve approximates the closed polygonal path that traverses the points (2, ys).

TERK is an integer variable and S, DDX, DDY are arrays of dimension n or larger. When KURVPL is called, if no input errors are detected then IERR ie assigned the value O and the values 81, ...,8, are computed and stored in S. Also, the second derivatives z"(s1),. ,# (sn) and y"(s1), ...,y”(s,) are computed and stored in DDX and DDY.

TEMP is an array of dimension 2n or larger that is used for . work space.

**Error Return.** [FRR reports the following input errors:

```text
IERR = 1 ifn < 2.
TERR = 2 if (2, ys) = (441, 41) for some 4.
```

When either of these errors is detected, the routine immediately terminates. Remark. After S, DDX, DDY are obtained, KURVP2 may be used to compute the curve.

**Programming.** KURVP1 employs the subroutines TERMS and SNHCSH. KURVP1 and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

```fortran
CALL KURVP2(T, XS, YS, N, X, Y, XP, YP, S, SIGMA)
```

X and Y are arrays containing the abscissas x1, ...,2, and ordinates y, . Ya, 5 is an array containing 8,,...,%,, and DX and DDY are arrays containing the second derivatives x"(s1),...,0(Sn) and y(s1),... y"(s,).


<small>Original source: [View scanned PDF page 364](../scans/page_0364.png)</small>

Now consider the change of variables t = (@ - 31)/8,, and let ¢ ++ (Z(¢), y(t)) denote

the curve in terms of the new parameter ¢. Then ¢ +> (#(t),y(¢)} maps 0 and 1 onto the point (r1,y1), and t-» (z(t), y(t)) is a periodic function (with period 1).

XT and YT are real variables. For any real t, KURVP2 computes the point (Z(t), #(¢)) on the curve and assigns XT the value #(t) and YT the value y(t).

**Remark.** After DDX and DDY have been obtained, KURVP2 may be repeatedly called to evaluate the curve at different points so long as the tension factor o remains fixed. However, if v is modified then the derivative information in DDX and DDY will have to be recomputed before KURVP2 can be used with the new tension factor,

**Programming.** KURVP2 employs the function INT RVL and subroutine SNHCSH. KURVP2

was written by A. K. Cline and R. J. Renka (University of Texas at. Austin). INTRVL was written by A. H. Morris.

ABA


<small>Original source: [View scanned PDF page 365](../scans/page_0365.png)</small>

<a id="topic-365-01"></a>
### Three Dimensional Spline Under Tension Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [`L97095`](../source_parts/nswc_part_10.f90#L1679) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [`L97335`](../source_parts/nswc_part_10.f90#L1919) |


Given n > 2 points (x1, y1, 21), -++) (Zn; Yn, 2n). One procedure for fitting a curve to

the points is to let s; = O and s; = 8,1 + J (ai - xy—1)? + (yi - ys—1)? + (25 — z%-1)? for t=: 2,...,m, and then to find splines a(s),y(s),2(s) with tension o that satisfy r(3,) = t;,4(9;) = w, and 2(s,;) = 2; fort =1,...,n. If (zi, yi, 24) aud (x), y!,2/), are the desired slopes for the curve s ++ (x(s), y(s), z(s)) at the points (z1, yz, z1) and (tn, Yn, 2n), then the

splines z(s), y{s), z(s) can be selected so that 2'(s,;) == 2!, y'(s;) = yf, and 2z'(s,;) = 2! for

% t= I,n. The curve s+ (x(s), y(s),z(s)) then passes ‘ ough the points (x5, ys, 2) and has the required slopes at the end points. The subroutine QURV1 is available for obtaining the second derivatives x"(s;), y’(s;),2"(s;) (¢ = 1,...,n) which characterize this curve, and the subroutine QURV?2 is available for computing the curve.

CALi QURV1(n, x, Y, 4, SLP1X,SUPLY SLP1Z,SLPNX,SLPNY, SLPNZ,IND,DDX,DDY,DDZ,TEMP, S, 7, IERR)

X is an array containing 2,,...,. VY an array containing yy, ...,Y,, and Z an array containing z;,. ,z, It is assumed tat n > 2 and that the points (2;,y,,2;) are indexed in the order that they are to be traversed by the curve. It is also assumed that (x3, Yes Wa )F(Ti4 1, Yir1,2041) for 4 = 1, a Sie

SLP1X, SLP1Y, SLP1Z and SLPNX, SLPNY, SLPNZ are assigned the values L,Y, 24 and z},,y),z). The user may omit values for SLP1X, SLPLY, SLPIZ and/or SLPNX, SLPNY, SLPNZ. The argument IND specifies the information that is provided.

IND = © Values are supplied for SLP1X,SLP1Y,SLPIZ and SUPNX,SLPNY, SLPNZ.

INE) = 1 Values are supplied for SLP1X,SLP1Y,SLP1Z but not for SLPNX, SLPNY, SLPNZ.

IND = 2 Values are supplied for SLPNX,SLPNY,SLPNZ but not for SLPLX, SLPLY, SLPiZ.

IND = 3 No values are supplied for SLUPIX, SUPLY, SLP1Z and SLPNX, SLPNY, SLPNZ.

If a value is not supplied by the user, then the routine provides a value.

7 is the tension factor to be « mployed. If |a| is small, say jo] < 1073, then x(s),y(s), z(s) approximate cubic splines. Otherwise, if |o| is large, say |o| > 100, then the resulting curve approximates the polygonal line from (r:, 41, 2;) to (Zn, Yn; 2n)-

TERR is an integer variable and S$, i) OX, DDY, DDZ are arrays of dimension n or larger When QURVI is called, if no input errors are detected then HEK? ig assigned the value O an the values 8), ..., 3, are computed aud stored in S. Also, the second derivatives "(sj yl") 2s) (Ft, jn) are compute and stored in Di &, DDY, DD4Z.

ThM? os an array of dimension mor la ger i! vt is used for a work space,


<small>Original source: [View scanned PDF page 366](../scans/page_0366.png)</small>

```text
Error Return. IERR reports the following input errors:
IERR = 1 ifn <2.
IERR = 2 if (zy, y3, 26) = (2541, vit1, 241) for gome ft.
```

When either of these errors is detected, the routine immediately terminates.

**Remark.** After S, DDX, DDY, DDZ are obtained, QURV2 may be used to compute the curve.

**Programming.** QURV1 employs the subroutines CEEZ, TERMS, and SNHCSH. QURV1, CEEZ, and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

```fortran
CALL QURV2(T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA)
```

X is an array containing 7), ...,Z,, Y an array containing yi, ...,Yn, and 4 an array containing 21, ...,2,. © is an array containing s;,...,8,, and DDX, DDY, DD2d are arrays containing the second derivatives z"(s,), y(s;),2"(s.} (¢ = 1, ...,n}.

Now consider the change of variables t = s/s, and let t + ((t),y(t),z(t)) denote the curve in terms of the new parameter t. XT, YT, ZT are real variables. For any 0 < ¢ < 1, QURV2 computes the point (Z(¢),y(t),Z(t)) on the curve and assigns XT, YT, ZT the values x(t), y(t) Z(t).

**Remark.** After DDX, DDY, DDZ have been obtained, QURV2 may be repeatedly called to evaluate the curve at different points so long as the tension factor o remains fixed. However, if o is modified then the derivative information in DDX, DDY, DDZ will have to be recomputed before QURV2 can be used with the new tension factor.

**Programming.** QURV2 employs the function INTRVL and subroutine SNHCSH. QURV2 was written by A. K. Cline and R. J. Renka (University of Texas at Austin).


<small>Original source: [View scanned PDF page 367](../scans/page_0367.png)</small>

B-SPLINES

```text
For k > 1 let f(t) = (t-- 2)*~! when t > x and f(t) = 0 when t < x. Then for
any sequence f; < -++ < ti4% where t; < tye, let Bys(z) = (ti4n — ta) f (ts, -.., teen] where
f(y, .--,ti4e] is the **” order divided difference of f(t). The function By, is called a
B-apline of order k. For k =: 1 it fol!ows that
```

Pal)={ 4 oe 0 otherwise.

More generally, for k > 2 By,(x) =O when 2 ¢ [t,,t:44). Fort; < 2 < tise

k~1

Li4k 2

By (x) = (24-2) when a tigk—2 and 1 t

k-1 [ rt, Bya(z) = \hoak — ) when t,41 = +++ == tyi.

Otherwise, if no point appears more than k -- 1 times in the sequence {t;, ...,t;4,} then tik - 2

~t, ‘ Bix (z) = —— By g(a) + Bi 1 ka (2). toge-a7 hy tote — tga

From these relations it follows that By,(z) > CG when t; <2 < tyy,.

Now let €: < +++ < €¢41 be a sequence of points where @ > 1. If m, is an integer where l<m,;< k-1 for 7 = 2,...,8@, let Pelé, ...,€e41; m2, ..., me] denote the collection of piecewise polynomials p(z) where p(x) is a polynomial of order < k (degree < k —- 1) on each interval [€5,€)41) (9 = 1,...,8, and p(r) is of class Ck-!~™ at each point €; (g = 2,...,@). Then €,...,£e1 are called the knots or break points for these piecewise polynomials, €2, ...,€/ the interior knots, and m2, ...,m¢g the multiplicities of the

interior knots.

Ifn=k+mg, + +++ + mgs, consider any sequence ty <--+ < ty4, where (1) th SS te < &, (2) tey1,---,, are the interior knots, where each interior knot €; appears exactly m, times, and

‘Then the B-splines Bix, ..., Bag ave piecewise polynomials in Py[E1,...,€e41;m2, -.., me], forming a basis for this vector space. Consequently, any piecewise polynomial p(x) in the space can be represented uniquely in the form p= 90°. , a,8,,. This representation is called a B-spline representation for p(x). Wp $3? , a, By, then we note that p(z) = Oif 2 < t

or ze > tyyk.

**Remark.** [If t, <2 << t,,, where ko gon, then Bya(r) / Oonly when td . 74 1 kyo. 7. Also », Bix (x) !

AS7


<small>Original source: [View scanned PDF page 368](../scans/page_0368.png)</small>

<a id="topic-368-01"></a>
### Finding The Interval That Contains A Point

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [`L97612`](../source_parts/nswc_part_10.f90#L2196) |


Let ty < +++ < ty, be a sequence where ty <t,,. Then for any ¢; < 2 < tm, the function INTRVL finds the interval [1,,t;41) that contains 2.

```fortran
INTRVL(X, T, M)
```

T is an array containing t,, ...,f,, and z areal number. Ift, < zx <t,, then INTRVL has the value ¢ where t; < z < t;,,. Otherwise,

1 ifz< ty

INTRVL(2,T,m) = |) taét fe>ty

where @ is the integer such that t, < tei, and tay, = ++ =ty.

**Programmer.** A. H. Morris.

48Q


<small>Original source: [View scanned PDF page 369](../scans/page_0369.png)</small>

<a id="topic-369-01"></a>
### Evaluation And Differentiation Of Piecewise Polynomials From Their B-Spline Representations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [`L97679`](../source_parts/nswc_part_10.f90#L2263) |


For n > k > 1 let ty < +++ < tay, be a sequence where t, < tyy, and ty < ti4, fort =1,...,n. If f(z) = S02, a: Bix(z) then the following subroutine is available for evaluating f(z) and computing its derivatives.

```fortran
CALL BVAL(T, BCOEF, N, K, X, JDERIV, W, WK)
```

TY is an array containing ?¢1,...,t,4, and A an array containing a,,...,@,. The argument 7 is a nonnegative integer, x is a real number at which f(z) or its j* derivative f(x) is to be computed, and w is a variable. If z # t,4, then w is assigned the value f(z+) if j =0 and the value f)(x+) if 7 > 1. Otherwise, if z = t,,4, then w = f(tnix—) if 7 =U and w= {O(tnae-) if 7 > 1.

WK is an array of dimension 3k or larger that is a work space for the routine.

**Remark.** The left limits f(tn4,—) and f?)(t,44—) are the only limits of interest when x =tny,, since f(z) =0 for all r > tyyg.

**Programming.** BVAIL employs the function INTRVL. BVAL is a modified version by A. H. Morris of the function BVALUE, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 370](../scans/page_0370.png)</small>

<a id="topic-370-01"></a>
### Evaluation Of The Indefinite Integral Of A Piecewise Polynomial From Its B-Spline Representation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [`L97864`](../source_parts/nswc_part_10.f90#L2448) |


Forn > k> 1 let ty < «+: < tay, be a sequence where t, < ty4; and t; < tj; for t=1,...,n. If f = 0%, a:Bs, then the following subroutine is available for computing

P(x) = fz f(t) de. CALL BVALI(T, A,n,k,z,w,WK)

T is an array containing t,,...,t,4% and A an array containing a;,...,@,. The argument z is a real number and w is a variable. When BVALI is called, w is assigned the value F(z).

WK is an array of dimension n+ 3(k +1) or larger that is a work space for the routine.

```text
Algorithm. For m= n+ &, let tii, ...,tm4e be any sequence where tm <tmyi1 Sc S
tmik If a < tm then F(z) = ny! 6; By e41(z) is used where b; = } yet a,(ty 4“ — ty)
fori =1,...,n and 6; = 6, forts =n+1,...,m-—1.
```

**Programming.** BVALI employs the subroutine BVALIO and the function INTRVL. BVALI was written by A. H. Morris.


<small>Original source: [View scanned PDF page 371](../scans/page_0371.png)</small>

<a id="topic-371-01"></a>
### Conversion Of Piecewise Polynomials From B-Spline To Taylor Series Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [`L98033`](../source_parts/nswc_part_10.f90#L2617) |


For n > k > 1 let ty < --- < tay, be a sequence where t; < ty4,% for: = 1,...,n. Further assume that t, <t,4; and let f(z) = > a; By. (xz) forth <2 < thar. If: <--- < €¢41 are the distinct points in the sequence {te .»tn41} then the piecewise polynomial f can be represented in the form f(r) = > cij(z — €;)'"} for €&; S 2 < 641 (7 = 1,...,2). The following subroutine is available for obtaining the coefficients c,,; of this representation.

```fortran
CALL BSPP(T, A, N, K, BREAK, C, L, WK)
```

T is an array containing t,, ...,t,4, and A an array containing aj,...,@,. BREAK is an array of dimension @ + 1 or larger, C a 2-dimensional array of dimension k x @, and i a variable. When BSPP is called then L is assigned the value & (which is computed by the routine), the break points €; < +--+ < € 41 are found and stored in BREAK, and the coefficients c,; are computed and stored inC. The j** column of the matrix C' then contains the coefficients of the j** polynomial forming f (j = 1, ...,@).

WK is an array of dimension k(k + 1) or larger that is a work space for the routine.

**Remarks.**

(1) Since 2<n~k+1, BREAK may be declared to be of dimension n — k + 2 and C to be of dimension k x (n — k +1).

(2) After C is obtained, then PPVAL may be used to evaluate f(x) for any z € [€1, €e41]. However, PP VAL cannot be used for evaluating f(x) if a < €; or x > €¢41. BVAL must be used in this case.

**Programming.** BSPP is a modified version by A. H. Morris of the subroutine BSPLPP, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 372](../scans/page_0372.png)</small>

<a id="topic-372-01"></a>
### Evaluation Of Piecewise Polynomials From The!Ir Taylor Ser'Es Representations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [`L98137`](../source_parts/nswc_part_10.f90#L2721) |


```text
k .
Given z1 <-++ < 2¢41. If f is a piecewise polynomial where f(x) == 3> ej;{x — x;)*~'
tw=l
for zy <x <a2y41 (7 = 1,...,@), then the following subroutine is available for computing
```

f at any point z.

```fortran
CALL PPVAL(X, A, L, N, XI, YI, NI)
```

X ig an array containing the knots z,,...,r¢ and C ak « € matrix containing the coefficients c,;. It is assumed that k > l and @> 1. Let Z1,...,Z, be the points at which f is to be evaluated. XI is an array containing Z,,...,Z,, and YI an array of dimension m

or larger. When PPVAL is called, f(Z,) is computed and stored in YI(j) for 7 = 1,...,m.

**Remarks.**

(1) X need not contain the knot r¢41.

(2) It is not required that f be continuous at an interior knot 2,. If z; appears in XI then f(xz.+) is computed.

(3) It is not required that the output points Z, in XI be in the interval (71,2241). If Zy< 4 then )’, ey1(z ~ 2,)'~? is evaluated at Z,. Otherwise, if Z; > ze41 then d, te(z - re)*~? is evaluated at Z,.

**Programming.** PPVAL is an adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 373](../scans/page_0373.png)</small>

<a id="topic-373-01"></a>
### Piecewise Polynomial Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [`L98449`](../source_parts/nswc_part_10.f90#L3033) |


Forn > k > 1 fet ty < +--+ < thy, be a sequence wnere t; < tyy, fort = 1,...,n. Consider a set of points {(z,,y;) :f = 1,...,n} where t, < zy < +++ < gy < tnya. Then we wish to find a piecewise polynomial f = )°>?., a;B,~ which satisfies f(z,) = y for t= 1,...,n.! This problem has a unique :..lution when t; < z,; < ti44% for 1 <1 <n. The following subroutine is available for obtaining the coefficients a;, ...,a, of the interpolating piecewise polynomial,

```fortran
CALL BSTRP(TAU, GTAU, T, N, K, BCOEF, Q, IFLAG)
```

X ig an array containing z,,...,7,, Y an array containing yi, ...,¥,, and T an array containing t1,..-,tn4%- A is an array of dimension # or larger, and IFLAG an integer variable. On an initial call to the routine the user may assign IFLAG any nonzero value. In this case, if no errors are detected then IFLAG is reset by the routine to O and the B-spline coefficients aj, ...,a@, are computed and stored in A. The routine may be recalled with IFLAG = 0 on input when only Y is modified. In this case, no error checking is performed and IFLAG= 0 on output. Also the B-spline coefficients a, ...,a, of the new interpolating piecewise polynomial are computed and stored in A.

WK is an array of dimension (2k — 1)n or larger that is used for temporary storage by the routine. When BSTRP terminates, WK contains information needed for subsequent calls to the routine.

**Error Return.** IFLAG is assigned the value 1 if any of the conditions

Tp<c< zy

< ty S21 < tag tioayn<ty, fori<it<cn

ty < In < fad igs violated. When an error is detected, the routine immediately terminates.

**Remarks.**

(1) It is recommen ‘ed that t) = +--+ = ty and tyy, = ++ = tak.

(2) After the B-spline representation », a, By, is obtained, then the subroutine BVAL can be used to evaluate or differentiate the piecewise polynomial.

Example Given n> 4 data points (7,,y,), then for & done may set dy, +.) te ory, thas Z,,2 fore l,...,n ky and x, bingy cot tnin. Then ry,....2, 9 are the interior knots for the interpolating piecewise polynomial fo Here we have cubic spine

interpolation Where the data points ag and 7, 1. are not knots for f.

Moa tay then by fra} we died ‘fra )

Dae)


<small>Original source: [View scanned PDF page 374](../scans/page_0374.png)</small>

**Programming.** BSTRF calls the subroutines BSPVB, RANFAC, and BANSLV. BSTRP is a modified version by A. H. Morris of the subroutine SPLINT, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 375](../scans/page_0375.png)</small>

<a id="topic-375-01"></a>
### Weighted Least Squares Piecewise Polynomial Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [`L98809`](../source_parts/nswc_part_10.f90#L3393) |


Forn > k > 1 let ty < +++ < tyy«% be a sequence where t; < t,,, for s = 1,...,n. Consider a set of points { (2,;,y;):1 = 1,...,m} where ty < ay <+-+- < am < tay, and m > max{2,k}. Let wy > 0(¢ = 1,...,m) be weights. Then the following subroutine is available

for finding a piecewise polynomial f = S77, a; Bie which minimizes 7, w,y(f(2i) -— ys)? 2 CALL BSLSQ(X,Y,W,m,T, n,k, A,WK,Q, TERR)

X is an array containing 71,...,%m, Y an array containing y1,...,y¥m, W an array containing wy,...,Wm, and T an array containing t), ...,t,4,. Ais an array of dimension nor larger. When BSLSQ is called, if no input errors are detected then the coefficients 1, ---,@, of a least squares approximation f are computed and stored in A.

WK is an array of dimension n or larger, and Q an array of dimension kn or larger. WK and Q are work spaces for the routine.

```text
IERR is a variable that reports the status of the results. When BSLSQ terminates,
IERR has one of the following values:
```

TERR = O The coefficients were obtained. The least squares approximation is unique. IERR = 1 The coefficients for a least squares approximation were obtained.

The approximation is not unique. IERR = —1 (Input error) Either ¢, < 21 <-+++ < am < tn41 or m > max{2,k} is violated.

Selection cf t, < +--+ < tay, given the data (z,;,y;). It is recommended that the knots t, be selected so that there are data points 2,;, < +++ < a,, satisfying ¢) < t) < tye for v = 1,...,n. If these conditions are satisfied then the least squares approximation is unique.

**Remark.** After the B-spline representation is obtained, then the subroutine BYVAL can be used to evaluate or differentiate the piecewise polynomial.

**Programming.** BSLSQ calls the subroutines BSPVB, BCHFAC, and BCHSLV. BSLSQ is a modified version by A. H. Morris of the subroutine LEAPPR, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 376](../scans/page_0376.png)</small>

<a id="topic-376-01"></a>
### Least Squares Piecewise Polynomial Fitting With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [`L99108`](../source_parts/nswc_part_10.f90#L3692) |


```text
For n > k > 1 let t) < +++ < thax be a sequence where t, < ty4,% (§ = 1,...,n).
Consider a set of points { (z;,y;): 1 = 1,...,m} where &, < zy <+++ < am < tyyy. Then
the subroutine BFIT is available for obtaining a piecewise polynomial f = 30°, a: Bye
which minimizes )>,(f(z:) — yi)? subject to a set of constraints.
```

```text
Notation. If t, < z <tn41 then f%)(z) will denote the value f(x+) if 7 = 0, and the right
jth derivative fO (c+) if 7 > 1. Otherwise, if x = t,4, then f(z) = f(tagi—) if 7 =0
and f) (2) = fO)(tayi-) if 7 > 1.
```

```fortran
CALL BFIT(BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW)
```

T is an array containing t,...,tn44%, X an array containing 7), ...,2%m, and Y an array containing y,,...,Ym- The argument @ is the number of constraints to be satisfied (£ > 0) and XCON, C, NDER are arrays of dimension max{1, £} or larger.

If 2 > 1 then XCON contains the points 2), ...,£¢ at which the constraints are placed. The points Z; may be given in any order and need not be distinct. It is assumed that th <2; <thy1 fort =1,...,@ At @; any of the foilowing types of constraints itype = 0 f(z) < itype= 1 f)(B) > ey itype = 2 fO)(z,) = itype = 3 f)(%,) = fO (c,) can be imposed where 7 is a nonnegative integer. For the selected constraint, it is assumed that C(#) = c, and NDER(‘) = itype + 47. If an itype 3 constraint is imposed then it is further assumed that ty < cy < ty41.

WK and IWK are arrays that are work spaces for the routine. On input, IWK(1) is the dimension of WK and IWK(?2) the dimension of IWK. If @ = O then one ray set JWK(1) ~ NB and [WK(2) = 2 where NB = (n+ 3)(k #1) | k®. Otherwise, let ves n + 1, m, be the number of equality (i.e., itype 2 and 3) constraints, and m, the number of inequality (itype O and [} constraints. Then one must set

IWK(1) > NB + (v4 ey t 2fm,. tv) t+ (rm, tv) tf (ry | 2)fe + 6) IWK(2} > m, 4 2v.

**Remarks.**

(t) If € > t then one can let the routine determine the amount of storage that is needed for WK and IWK. Set WHI) NB and IWK(2)) . 2, 1m which case errors will occur (see the IND «6, > 7 error values below),

(2) NDER(1) may be assigned a negative value (1 hoo. jf) EE NDER(G) © 0 chen she

constraint is ignored


<small>Original source: [View scanned PDF page 377](../scans/page_0377.png)</small>

IND is a variable used for input/output purposes, A an array of dimension n or larger, and ra variable. IND must be set to 0 on an initial call to BEIT. When the routine is called, if f is found then IND is assigned the value 0 or 1, the coefficients. a), ...,ti, are

/ 5 stored in A, and r is assigned the value V du (f (zs) ~ yi).

After an initial call to BFIT, if only the constraints are modified, then the information in WK concerning X and Y can be reused. In this case, one may set IND to a nonzero value and recall BFIT to solve the new problem. The input setting IND # 0 can be used only when T,n,k,X,Y,m, and WK have not been modified since the last call to BFIT

When BFIT terminates, IND reports the status of the results. IND is assigned one of the following values: IND = 0 The piecewise polynomial f was obtained. IND = 1 The equality (i.e., itype 2 and 3) constraints are contradictory. The solution f was obtained where the equality constraints were satisfied in a least squares sense.

IND = 2 The problem could not be solved. The constraints are contradictory.

IND = -lLk<lork>n.

IND = --2 m<Ooré< 0.

IND = ~-3 t, > t,4.1 for some t.

IND = —4 The assumption t, < 21 < +++ < 2m < lnyy is not satisfied.

IN]} = —5 The ¢'® constraint is incorrect for the value of 1 stored in IWK(2).

IND = --6 Insufficient storage was specified for the WK array. }WK(1) has been reset to the amount of storage needed by WK.

IND = --7 Insufficient storage was specified fer the IWK array. IWK(2) has

been reset to the amount of storage needed by TWK. IWK(1) and IWK(2) are not modified when IND ¥ -—-5, ~6, --7.

**Example.** If one wants f to be convex on an interval {t;,¢:41), then this is equivalent to requiring that f"(2) > 0 on the interval. Thus, if k - 4 then it suffices to require that f"(t.+) > O and f"(tyya-) > 0. For these two constraints, 9 is the appropriate value for the NDER array.

**Programming.** BEIT employs the routines BFITO, BNDACC,BNDSL, BSPVB, BSP\ D, LSE], and the subroutines and functions used by LSEL BEET is a modification by AH. Morris of the subroutine PC, written by Richard Jo Hanson (Sandia Laboratories). ‘The subroutines BNDACC and BNDSL were written by Richard Jo Hanson aud Charles 1, Lawson (Jet Propulsion Laboratory), and are described in reference (2).

References

(1) Hanson, HJ), Constrained Least Squares Curve Fitting to Discrete Data using Le Splines A User’a Guide, Report SAND 78 129), Sandia Laboratories, Albuquerque, New Mexico, 1979.

(2) Lawson, Coto, and Wansen. HO, Solving Least Squares Problems, VPreutice t all,

Englewood Cliffs, New Jersey. BUT:

