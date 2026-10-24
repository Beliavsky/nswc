[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-017"></a>
## Elementary Operations

<small>Original source: [View scanned PDF page 17](../scans/page_0017.png)</small>

<a id="topic-017-01"></a>
### Machine Constants

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [`L1`](../source_parts/nswc_part_01.f#L1) |
| `SPMPAR` | `REAL FUNCTION` | `I` | [`L1222`](../source_parts/nswc_part_01.f#L1222) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [`L1274`](../source_parts/nswc_part_01.f#L1274) |


For the integer arithmetic, let $a$ be the radix and $n$ the number of base-$a$
digits. The largest representable positive integer is $a^n-1$.

For floating-point arithmetic, let $b$ be the radix, $m$ the number of base-$b$
significand digits, and $e_{\min}$ and $e_{\max}$ the limiting normalized exponents.
The library represents nonzero floating-point values conceptually as

$$
\pm b^e \sum_{j=1}^{m} k_j b^{-j}, \qquad
1\leq k_1<b,\quad 0\leq k_j<b.
$$

The machine precision, smallest normalized positive magnitude, and largest finite
magnitude are, respectively,

$$
\epsilon=b^{1-m}, \qquad
x_{\min}=b^{e_{\min}-1}, \qquad
x_{\max}=b^{e_{\max}}(1-b^{-m}).
$$

`SPMPAR(I)` returns the corresponding constants for single precision and
`DPMPAR(I)` for double precision:

| `I` | Returned quantity |
|---:|---|
| 1 | Relative machine precision, $\epsilon$ |
| 2 | Smallest normalized positive magnitude, $x_{\min}$ |
| 3 | Largest finite positive magnitude, $x_{\max}$ |

The integer-valued function `IPMPAR(I)` exposes the arithmetic parameters:

| `I` | Quantity |
|---:|---|
| 1 | Integer radix $a$ |
| 2 | Integer digit count $n$ |
| 3 | Largest positive integer $a^n-1$ |
| 4 | Floating-point radix $b$ |
| 5 | Single-precision significand digits $m$ |
| 6 | Single-precision minimum exponent $e_{\min}$ |
| 7 | Single-precision maximum exponent $e_{\max}$ |
| 8 | Double-precision significand digits $m$ |
| 9 | Double-precision minimum exponent $e_{\min}$ |
| 10 | Double-precision maximum exponent $e_{\max}$ |

**Source configuration.** The supplied `nswc.f` has the IBM PC machine-constant
`DATA` statements activated. These are fixed numerical constants, **not** automatically
detected modern Fortran processor properties. Check `IPMPAR` when compiling for a
different arithmetic environment.

**Attribution.** `IPMPAR` is A. H. Morris's adaptation of `I1MACH` by
P. A. Fox, A. D. Hall, and N. L. Schryer. `SPMPAR` and `DPMPAR` are by A. H. Morris.

Original documentation: [page 17](../scans/page_0017.png),
[page 18](../scans/page_0018.png).


<a id="topic-019-01"></a>
### Argument Bounds for the Exponential Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EPSLN` | `REAL FUNCTION` | `L` | [`L1327`](../source_parts/nswc_part_01.f#L1327) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [`L1351`](../source_parts/nswc_part_01.f#L1351) |
| `EXPARG` | `REAL FUNCTION` | `L` | [`L1376`](../source_parts/nswc_part_01.f#L1376) |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [`L1409`](../source_parts/nswc_part_01.f#L1409) |


`EPSLN(L)` returns $\ln(\epsilon)$ for the single-precision arithmetic,
where $\epsilon=\texttt{SPMPAR(1)}$. `DEPSLN(L)` performs the corresponding
double-precision calculation using `DPMPAR(1)`. The argument `L` is ignored.

For the exponential functions, `EXPARG(L)` (single precision) and `DXPARG(L)`
(double precision) estimate argument bounds:

| Value of `L` | Result |
|---|---|
| `L == 0` | Largest positive argument for which `EXP` or `DEXP` can be evaluated without overflow |
| `L != 0` | Negative argument near the underflow limit for which the exponential remains nonzero |

These are **approximate safe bounds**, not values intended to represent an exact
IEEE-754 threshold. Both functions rely on the machine constants returned by
`IPMPAR`.

**Programming.** These four functions were written by A. H. Morris.

Original documentation: [page 19](../scans/page_0019.png),
[page 20](../scans/page_0020.png).


<a id="topic-021-01"></a>
### Sorting Lists

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ISHELL` | `SUBROUTINE` | `A, N` | [`L1443`](../source_parts/nswc_part_01.f#L1443) |
| `SHELL` | `SUBROUTINE` | `A, N` | [`L1487`](../source_parts/nswc_part_01.f#L1487) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [`L1532`](../source_parts/nswc_part_01.f#L1532) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [`L1627`](../source_parts/nswc_part_01.f#L1627) |
| `DSORT` | `SUBROUTINE` | `A, N` | [`L1728`](../source_parts/nswc_part_01.f#L1728) |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [`L1773`](../source_parts/nswc_part_01.f#L1773) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [`L1824`](../source_parts/nswc_part_01.f#L1824) |
| `AORD` | `SUBROUTINE` | `A, N` | [`L1874`](../source_parts/nswc_part_01.f#L1874) |
| `DAORD` | `SUBROUTINE` | `A, N` | [`L1920`](../source_parts/nswc_part_01.f#L1920) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [`L1966`](../source_parts/nswc_part_01.f#L1966) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [`L2164`](../source_parts/nswc_part_01.f#L2164) |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [`L2363`](../source_parts/nswc_part_01.f#L2363) |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [`L2563`](../source_parts/nswc_part_01.f#L2563) |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [`L2633`](../source_parts/nswc_part_01.f#L2633) |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [`L2705`](../source_parts/nswc_part_01.f#L2705) |


Let A be an array containing n > 1 elements aj, ...,a¢,. Then the following subroutines are available for reordering the elements of A.

```fortran
CALL ISHELL(A, N)
```

Tt is assumed that A is an integer array. When ISHELL is called, the elements of A are reordered so that a, < aj41 fort =1,...,n—1.

**Algorithm.** The Shell sorting algorithm with increments (3* — 1)/2 is employed. Programmer. A. H. Morris

**Reference.** Knuth, D. E., The Art of Computer Programming. Vol.3, Sorting and Searchtng. Addison-Wesley, Reading, Mass., 1973, pp. 84-95.

```fortran
CALL SHELL(A, N)
CALL AORD(A, N)
```

It is assumed that A is a real array. If SHELL is called, then the elements of A are reordered so that a; < a;4, for! = 1,...,n —1. Otherwise, if AORD is called, then the

elements of A are reordered so that |a,j < Jaj41| forf=1, ...,n-- 1.

**Programmer.** A. H. Morris CALL RISORT(A, L,n)

It is assumed that A is a real array and [ an integer array containing n elements. When RISORT is called, the elements of A are reordered so that a, < ay4; fort = 1,...,n — 1. The same permutations are perforrned on I as on A, thereby reordering the ele.nents of L so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris CALL SHELL2(A, B,n)

It is assumed that A and B are real arrays containing n elements. Waen SHELL? is called, the elements of A are reordered so that a; < a,;,4, for # = 1,...,n ~— 1. The same permutations are performed on B as on A, thereby reordering the elements of B so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris

```fortran
CALL DSORT(A, N)
CALL DAORD(A, N)
```


<small>Original source: [View scanned PDF page 22](../scans/page_0022.png)</small>

It ig assumed that A is a double precision array. If DSORT is called, then the elements of A are reordered so that a; < aj4, fort = 1, ..,n — 1. Otherwise, if DAORD is called, then the elements of A are reordered so that |a,{ < jas41| for? =1,...,n~ 1.

**Programmer.** A. H. Morris CALL DISORT(A, L, )

It is assumed that A is a double precision array and ZL an integer array containing n elements. When DISCRT is called, the elements of A are reordered go that a; < a4, for t= 1,...,2—1. The same permutations are performed on L as on A, thereby reordering the elements of LE so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris CALL DDSORT(A, B,n)

It is assumed that A and B are double precision arrays containing n elements. When DDSORT is called, the elements of A are reordered so that a; < a,4, forf =1,...,n—1. The same permutations are performed on B as on A, thereby reordering the elements of B so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris

```fortran
CALL QSORTI(X, IND, N)
CALL QSORTR(X, IND, N)
CALL QSORTD(X, IND, N)
```

QSORTI is used if A is an integer array, QOORTR is used if A is a real array, and QSORTD is used if A is a double precision array. It is assumed that n < 2097152 and that Lis an integer array of dimension n or larger. When the subroutine is called, the indices t1,...,% are stored in L where a, < ++: < a;,. A is not modified by the routine.

**Remarks.**

(1) After L has been obtained, A may be reordered so that a; < a;4, ford =i, ..,n-1 by IOKDER, RORDER, or DORDER (see below).

(2) QSORTI, QSORTR, and QSORTD employ a quick sort procedure. These routines frequently take less than half the time required by the corresponding subroutines ISHELL, SHELL, and DSORT, which use a SHELL sort procedure.

**Programmer.** Robert Renka (Oak Ridge Nationa) Laboratory).

```fortran
CALL IORDER(A, IP, N)
```

```fortran
CALL RORDER(A, IP, N)
CALL DORDER(A, IP, N)
```

tORDER is used if A is an integer array, RORDER is used if A is a real array, and DORDER is used if A is a double precision array. © is an integer array containing a


<small>Original source: [View scanned PDF page 23](../scans/page_0023.png)</small>

permutation #1,...,%, of 1,...,n. If A initially contains a),...,a, then A contains the reordered sequence a;,,... ,a;, when the subroutine terminates.

Programmers. Robert Renka (Oak Ridge National Laboratory).


<small>Original source: [View scanned PDF page 24](../scans/page_0024.png)</small>

<a id="topic-024-01"></a>
### Cube Root

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBRT` | `REAL FUNCTION` | `X` | [`L2777`](../source_parts/nswc_part_01.f#L2777) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [`L2791`](../source_parts/nswc_part_01.f#L2791) |


The following functions are available for computing the real cube root of a real number.

CBRT(z) DCBRT(z)

CBRT is used if x is a single precision number, and DCBRT is used if x is a double precision number. CBRT is a single precision function and DCBRT a double precision function. The value of the function is ~/z.

**Remark.** DCBRT must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** A. H. Morris

<a id="topic-024-02"></a>
### Four-Quadrant Arctangent

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ARTNQ` | `FUNCTION` | `Y, X` | [`L2807`](../source_parts/nswc_part_01.f#L2807) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [`L2824`](../source_parts/nswc_part_01.f#L2824) |


The function ARTNQ is similar to the ATAN2 function, the differences being that its value lies in the interval (0,27) and its value at the origin is 0. DARTNQ is the double precision counterpart of ARTNQ.

ARTNQ(y, z) DARTNQ(y, z)

ARTNQ is used if x and y are single precision values, and DARTNQ is used if x and y are double precision values. ARTNQ is a single precision function and DARTNQ is a double precision function.

if (z,y) is a point in the plane other than the origin (0,0), let L denote the straight line connecting the points (0,0) and (z,y). Then the function is assigned the value @ where 9 is the angle between L and the positive x-axis measured in a counterclockwise direction. Here 0 < 6 < 2. Otherwise, if (x,y) is the origin (0,0), then the function is assigned the value 0.

**Remark.** DARTNQ must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** Richard Pasto

<a id="topic-024-03"></a>
### Length Of A Two Dimensional Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPABS` | `REAL FUNCTION` | `X, Y` | [`L2842`](../source_parts/nswc_part_01.f#L2842) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [`L2857`](../source_parts/nswc_part_01.f#L2857) |


The following funetions are available for computing the length of a real vector (2, y).

CPABS(r, y) DCPABS (zs, y)


<small>Original source: [View scanned PDF page 25](../scans/page_0025.png)</small>

CPABS is used if x and y are single precision values, and DCPABS is used if a and y are double precision values. CPABS is a single precision function and DCPABS is a double precision function. The value of the function is fx? + y?.

**Remark.** DCPABS must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** A. H. Morris


<small>Original source: [View scanned PDF page 26](../scans/page_0026.png)</small>

<a id="topic-026-01"></a>
### Reciprocal Of A Complex Number

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [`L2875`](../source_parts/nswc_part_01.f#L2875) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [`L2891`](../source_parts/nswc_part_01.f#L2891) |


The following subroutines are available for computing the reciprocal of a complex number.

```fortran
CALL CREC(X, Y, U, V)
CALL DCREC(X, Y, U, V)
```

CREC is used if x and + are single precision real nurnbers and u and v real variables, and DCREC is used if x and y are double precision numbers and u and v double precision variables. It is assumed that x and y are the real and imaginary parts of a nonzero complex number z. When CR&C or DCREC is called, u and v are set to the real and imaginary parts of 1/z, respectively.

**Programmer.** A. H. Morris

<a id="topic-026-02"></a>
### Division Of Complex Numbers

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [`L2910`](../source_parts/nswc_part_01.f#L2910) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [`L2935`](../source_parts/nswc_part_01.f#L2935) |


The function CDIV and subroutine CDIVID ave available for dividing complex numbers.

CDIV(a, b) CDIV(a, 6) =: a/b for any complex numbers a and b where 6 7 6.

**Remark.** CDIV must. be declared in the calling program: to be of type COMPLEX.

**Programmer.** A. H. Morris. CALL CDIVID(a,, az, 6), 52, u,v)

The arguments 2,,@2,6,,0) are double precision numbers, and u and v are double precision variables, It is assumed that a, and ag are the real and imagiuiary parts of a complex number a, and that 6; and 6) are the real and iimaginery parts of a nonzero complex number 6 When CDIVID is called, u and v are set to the real and imaginary parts of a/b respectively.

**Programmer.** A. HI. Morris.

<a id="topic-026-03"></a>
### Square Root Of A Double Precision Complex Number

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [`L2967`](../source_parts/nswc_part_01.f#L2967) |


The following subroutine ts avaihible for voniputing the square root of a double precision

complex number.

```fortran
CALL DCSQRT(Z, W)
```


<small>Original source: [View scanned PDF page 27](../scans/page_0027.png)</small>

Z and W are double precision arrays of dimension 2. It ig assumed that Z(1) and Z(2) are the real and imaginary parts of a complex number z. When DCSQRT is called, if z = 0 then W(1) and W(2) are set to 0. Otherwise, if z 4 O then the square root w = \/z where -~x/2< arg(w) < 1/2 is computed and stored in W. W(1) and W(2) contain the real and imaginary parts of w, respectively.

**Note.** Z and W may reference the same storage area.

**Programming.** DCSQRT calls the function DCPABS. DCSQRT was written by A. H. Morris.


<small>Original source: [View scanned PDF page 28](../scans/page_0028.png)</small>

<a id="topic-028-01"></a>
### Conversion Of Polar To Cartesian Coordinates

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [`L3013`](../source_parts/nswc_part_01.f#L3013) |


The following subroutine is available for converting polar coordinates {r, @) to cartesian coordinates (2, y).

```fortran
CALL POCA(R, A, X, Y)
```

Let (r,@) be the polar coordinates of a point in the plane and let +,y be variables. When the routine is called, x and y are assigned the values x = r cos @ and y = rsin @.

<a id="topic-028-02"></a>
### Conversion Of Cartesian To Polar Coordinates

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [`L3018`](../source_parts/nswc_part_01.f#L3018) |


The following subroutine is available for converting cartesian coordinates (zx, y) to polar coordinates (r, 8).

```fortran
CALL CAPO(X, Y, R, THETA)
```

Let (z,y) be the cartesian coordinates of a point in the plane and lei r,@ be variables. If (z, y) is the origin then CAPO sets r = 0 = G. Otherwise, if (z,y) is a point other than the origin, let L denote the straight line connecting the points (0,C) and (x,y). Then when

CAPO is called, r is assigned the value \/2? + y? and @ is defined to be the angle between L and the positive x axis. Here -w <0 < 7m.

<a id="topic-028-03"></a>
### Rotation Of Axes

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [`L3033`](../source_parts/nswc_part_01.f#L3033) |


Let (r1,y1) be the (cartesian) coordinates for a point in the plane. The following subroutine computes the new coordinates (z2,y2) for the point after the z,y axes have been rotated py an angle @.

```fortran
CALL ROTA(X1, Y1, A, X2, Y2)
```

The arguments z2 and y are variables. When ROTA is called, x2 and yo are assigned the values:

Lo = Ly cos 6 + yy sin 9

yo <= ~2, sin 8+ y; cos 9

**Programmer.** A. I. Morris.

we in


<small>Original source: [View scanned PDF page 29](../scans/page_0029.png)</small>

<a id="topic-029-01"></a>
### Planar Givens Rotations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [`L3040`](../source_parts/nswc_part_01.f#L3040) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [`L3112`](../source_parts/nswc_part_01.f#L3112) |


If a and 6 are real numbers where a? + b? # 0, then there is an orthogonal matrix

(_§ 8) such that ($$) (2) = (J). tm this case #? = a2 + 08,¢ = a/r, and 9 = b/r

The matrix ( ° °) represents what is called a Gévens rotation. Given a and b, the matrix is uniquely defined up to the sign of r, For any real a, let sgn(a) = 1 if a > 0 and sgn(a) = ~1 ifa< 0. If we define r = oVa? + b? where

_ { sgn(a) if {a| > |6|

~ [sgnfd) if jal < (|

then for r # O we note that |c| > |s| implies ¢ > 0, and that |c| < |s| implies s > 0. For convenience, when r — 0 we set c= 1 ands =0.

The value o is not needed for the constuction of a Givens rotation matrix, but its use permits the representation of c and s by a single value z. For each c and ge, z is defined as

follows: ={3 if |s] <core=0

Ife O<|el<s

The mapping (c,s) + z is 1-1. If the user wishes to reconstruct c and s from z, then this can be done as follows:

```text
If z = 1 then set c = O and s = 1.
If |z| < 1 then set c= V1 — 2? and s = z.
If |z| > 1 then set, ¢ = 1/z and s = V1 — c?.
```

The subroutines SROTG and DROTG are available for computing c,s,r, and z. CROTG is used when a and 0 are single precision real numbers, and DROTG is used when a and b are double precision numbers.

```fortran
CALL SROTG(SA, SB, SC, SS)
CALL DROTG(DA, DB, DC, DS)
```

When SROTG is used then AR, BZ, C, and S are real variables. Otherwise, when DROTG is used then AR, BZ, C, and S are double precision variables. On input, AR = a and BZ = 6. When the routine terminates AR -: r, BZ = z,C = c,and S = s.

**Programming.** These rovtines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F.'T. Krogh. SROTG and DROVG were written by Charles Lawson (Jet Propulsion Laboratory).


<small>Original source: [View scanned PDF page 30](../scans/page_0030.png)</small>

<a id="topic-030-01"></a>
### Three-Dimensional Rotations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ROT3` | `SUBROUTINE` | `A, THETA` | [`L3185`](../source_parts/nswc_part_01.f#L3185) |


if A = (a,;) is a 3 x 3 orthogonal matrix, then A can be represented in the form

1 0 0 cos 82 O --sin 82\ Ry = (0 cos 6; sin a) Ra = ( 0 1 0

0 sin A, cos 8, sin 02 QO cos 6

cos 9, --sin @3 0 1 0 90 R3= (s= 63 cos O3 0) R= (0 1 oO ), 0 6) 1 0 0 +1/

R, represents a rotation around the z-axis, R2 a rotation around the y-axis, and R3 a rotation around the z-axis. Since A is orthogonal the determinant det(A) == +1. If det(A} = 1 then EF is the identity matrix and A is the combined rotation Rs R,R, . If dei(A) = -1 then A is composed of the rotation R3R,R, and the reflection E = diag(1,1,-1). The following subroutine is available for finding the angles 61,82,43 where —+ < 6; < m,|82| < n/2,and —w < 03 <n.

```fortran
CALL ROT3(A, THETA)
```

THETA is an array of dimension 3 or larger. When ROTS3 is called, the angles 6, 92,43 are computed and stored in THETA.

**Algorithm.** If ai; = a2, = 0 then let 03 = 0. Otherwise, let 0, = ATAN2(d21,@11). Then Tr Gi, 43 R3A= {| 0 a), agg | = A’ 431 432 433 where ry = Va? + a3,. Also, if 02 = ATAN2(ag1.1r1) then ro ay, ai!s R} A’ = 0 Abo A435 =: Al O ay_ a5.

```text
where rz = \/r?-+ a2,. Since rz > 0, by orthogonality it follows that rz = 1 and aff, >
ay, = O. Finally, if 6; = ATAN2(ag,, a4.) then
```

10 0 RYAY = (0 r3 Ay 0 0 ag,

where rg - \/(a5,)? 1 (a4,)?. Since rz > 0, by orthogonality we obtain rg 1, af, — 0,

and ay, tl.

**Programmer.** A. H. Morris


<small>Original source: [View scanned PDF page 31](../scans/page_0031.png)</small>

<a id="topic-031-01"></a>
### Rotation of a Point on the Unit Sphere to the North Pole

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [`L3224`](../source_parts/nswc_part_01.f#L3224) |


Given the point (x,y,z) where z? -+y? 42? = 1. Then there exist orthogonal matrices 1 0 0 cy 0 ~8, a= (6 Cy -s.] man = (4 i oO QO 8s, ey sy 0 fe

x 0)

such that Ry Rz ( | = (0) . R, represents a rotation about the z-axis and R, a rotation 1?

about the y-axis. The following subroutine is available for obtaining the values c,., 82,

Cy, Sy. CALL CONSTR(z, y, z,CX,SX,CY,SY) CX,SX,CY,SY are variables. When CONSTR is called, these variables are assigned

the values cz, 81,Cy, Sy.

**Programmer.** Robert J. Renka (Oak Ridge Nationai Laboratory)


<small>Original source: [View scanned PDF page 32](../scans/page_0032.png)</small>

<a id="topic-032-01"></a>
### Computation Of The Angle Between Two Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [`L3268`](../source_parts/nswc_part_01.f#L3268) |


Given the points z = (r1, ...,2,) and y= (yi, ..., yn) where n > 2,40, andy 40. Let L, denote the straight line connecting 0 and x, and L, the straight line connecting 0 and y. Then the function ANG is available for computing the angle ¢ between the two lines Lz, and Ly.

```fortran
ANG(N, X, Y)
```

X and ¥ are arrays of dimension n containing 21, ...,%, and yi, ..., yn. ANG(n, X,Y) = @whereOQ< <a,

**Error Return.** ANG(n, X,Y) = —-lifn < 2,2=0, ory =0.

**Programming.** ANG employs the function SNRM2. ANG was written by A. H. Morris.


<small>Original source: [View scanned PDF page 33](../scans/page_0033.png)</small>

<a id="topic-033-01"></a>
### Trigonometric Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SIN1` | `REAL FUNCTION` | `X` | [`L3326`](../source_parts/nswc_part_01.f#L3326) |
| `COS1` | `REAL FUNCTION` | `X` | [`L3376`](../source_parts/nswc_part_01.f#L3376) |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L3426`](../source_parts/nswc_part_01.f#L3426) |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L3519`](../source_parts/nswc_part_01.f#L3519) |


The following functions are available for computing sin xz and cos wz for real ‘x. SINi(z) SINI{z) = sin wa for all real z. Algorithm. Minimax approximations are used for sinaz and cos mz when |a2| < 1/4. Precision. SIN1(z) is accurate to within 1 unit of the 14" significant digit when 0 < z < 1. Programming. SIN1 was written by A.H. Morris. The function IPMPAR is used. COS1(z) COSI(z) = cos wz for all real z. Algorithm. Minimax approximations are used for sinaz and cosmz when |x| < 1/4.

**Precision.** COS1(x) is accurate to within L unit of the 14° significant digit when 0 < x < 1 and x # 1/2.

**Programming.** COSI was written by A. H. Morris. The function IPMPAR is used.

```fortran
DSIN1(X)
```

The argument z is a double precision number. DSIN1(z) is the double precision value for sin az.

**Remark.** DSIN1 must be declared to be of type DOUBLE PRECISION in the calling program.

**Algorithm.** For |z| < «/4, sin wx and cos wz are computed by the power series corresponding ta the Chebyshev expansions developed by J. L. Schonfelder (University of Birmingham, England). The power series were obtained by A. H. Morris.

**Precision.** DSIN1(z) is accurate to within | unit of the 28" significant digit when 0 < x < 1.

**Reference.** Schonfelder, J.L.,“Very High Accuracy Chebyshev Expansions for the Basic Trigonometric Functions,” Math Comp. 3-4 (1980), pp. 237-244.

**Programming.** DSIN1i was written by A.H. Morris. The function IPMPAR is used. DCOS1(z)

The argument x is a double precision npumber. DCOS1(z) is the doubie precision value

for cos mx.

the 1


<small>Original source: [View scanned PDF page 34](../scans/page_0034.png)</small>

**Remark.** DCOS1 must be declared to be of type DOUBLE PRECISION in the calling program.

Aigorithm. For |z| < 7/4, sin wz and cos wz are computed by the power series corresponding to the Chebyshev expansions developed by J. L. Schonfelder (University of Birmingham, England). The power series were obtained by A. H. Morris.

**Precision.** DCOS1(z) is accurate to within 1 unit of the 28°” significant digit when 0 < z<landz#1/2.

**References.** Schonfelder, J.L.,.“Very High Accuracy Chebyshev Expansions for the Basic Trigonometric Functions,” Math Comp. 34 (1980), pp. 237-244.

**Programming.** DCOS1 was written by A. H. Morris. The function IPMPAR is used.


<small>Original source: [View scanned PDF page 35](../scans/page_0035.png)</small>

<a id="topic-035-01"></a>
### Hyperbolic Sine And Cosine Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [`L3612`](../source_parts/nswc_part_01.f#L3612) |


The following subroutine is available for computing sinh(z) — z, cosh(z) — 1, and cosh(z) — 1 — x? /2 for real z.

```fortran
CALL SNHCSH(SINHM, COSHM, X, ISW)
```

```text
S and C are variables, and IND is an input argument which specifies the functions to
be computed. IND takes the values:
IND = ~1 if only sinh(z) — z is desired.
IND = 0 if sinh(x) -- x and cosh(z) — 1 are desired.
IND = 1 if only cosh(z) — 1 is desired.
IND = 2 if only cosh(z) — 1 — z?/2 is desired.
IND = 3 if sinh(x) - z and cosh(z) ~ 1 — 2?/2 are desired.
S is assigned the value sinh(z) — x if this function is requested. When cosh(x) — 1 or
cosh(z) — 1 - x?/2 is computed then the value is stored in C.
```

**Precision.** For all z, sinh(x) — x has a relative error less than 2.3E-14, cosh(z) — 1 has a relative error less than 2.2E-14, and cosh(z) — 1— 27/2 has a relative error less than 3.8E-14.

**Programming.** Written by A. K. Cline and R. J. Renka (University of Texas at Austin). Modified by A. H. Morris.


<small>Original source: [View scanned PDF page 36](../scans/page_0036.png)</small>

<a id="topic-036-01"></a>
### Exponentials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `REXP` | `REAL FUNCTION` | `X` | [`L3758`](../source_parts/nswc_part_01.f#L3758) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [`L3781`](../source_parts/nswc_part_01.f#L3781) |


The following functions compute $e^x-1$, including for arguments near zero,
where directly subtracting one from the exponential can lose significant digits.

```fortran
REXP(X)
DREXP(X)
```

`REXP` returns a single-precision value for real `X`.
`DREXP` returns the double-precision counterpart and must be declared
`DOUBLE PRECISION` in traditional Fortran calling code.

**Reference.** A. R. DiDonato and A. H. Morris, "Computation of the Incomplete
Gamma Function Ratios and Their Inverse," *ACM Transactions on Mathematical
Software* **12** (1986), 377-393.

**Programming.** A. H. Morris. Original documentation:
[page 36](../scans/page_0036.png).


<a id="topic-037-01"></a>
### Logarithms

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ALNREL` | `REAL FUNCTION` | `A` | [`L3929`](../source_parts/nswc_part_01.f#L3929) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [`L3951`](../source_parts/nswc_part_01.f#L3951) |
| `RLOG` | `REAL FUNCTION` | `X` | [`L4001`](../source_parts/nswc_part_01.f#L4001) |
| `RLOG1` | `REAL FUNCTION` | `X` | [`L4049`](../source_parts/nswc_part_01.f#L4049) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [`L4097`](../source_parts/nswc_part_01.f#L4097) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L4175`](../source_parts/nswc_part_01.f#L4175) |


The functions ALNREL, RLOG, RLOGI, DLNREL, DRLOG, and DRLOG1 are available for computing In(1 + a), z — 1 — In(z), and a — In(1+ a). DLNREL, DRLOG, and DRLOGI are double precision functions.

ALNREL(a) ALNREL(a) = In(1 + a) for a > -1. Algorithm. See page 378 and appendix A of the reference.

**Precision.** ALNREL(a) is accurate to within 2 units of the 14" significant digit when ALNREL(a) 4 0.

**Reference.** DiDonato, A. R., and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

**Programmer.** A. H. Morris. CLOG (zx) RLOG(x) == 2 -- 1 -- In(z) for x > 0. Aigorithm. See page 379 and appendix E of the reference.

**Precision.** RLOG(s) is accurate to within 2 units of the 14'* significant digit when RLOG(z) 54 0.

**Reference.** DiDonato, A. R., and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 877-383.

**Programmer.** A. H. Morris. RLOG1(a) RLOGI(a) = a In(t ¢ a) fora> © 1. Algorithm. See page 379 and appendix bof the reference.

Precision, RLOGI(a) is accurate to within 2 units of the 14" significant digit: when RLOGI{a) #4 0

**Reference.** DiDonato, A. BR, and Morris, A. H., “Computation of the incomplete Gata Function Ratios and Their Inverse,” ACM Trans, Math Software 12 (1986), pp. 377 U3.

Pregrammer. A. H. Morris.


<small>Original source: [View scanned PDF page 38](../scans/page_0038.png)</small>

```fortran
DLNREL(A)
```

The argument a is a double precision number where a > —1. DLNREL(a) is the double precision value for In(1 + a).

**Remark.** DLNREL must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DLNREL(a) is accurate to within 1 unit of the 28" significant digit when DLNREL(e) # 0.

**Programmer.** A. H. Morris.

```fortran
DRLOG(X)
```

The argument z is a positive double precision number. DRLOG(z) is the double precision value for z -- 1 — In(z).

**Remark.** DRLOG must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DRLOG(z) is accurate to within 1 unit of the 28" significant digit when DRLOG(z) #0.

**Programmer.** A. H. Morris. DORLOGI(a)

The argument a is a double precision number a > —i. DRLOGI(a) is the double precision value for a ~ In(1-+ a).

**Remark.** DRLOGI must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DRLOGI(a) is accurate to within i unit of the 28 significant digit when DRLOGI(a) 7 0.

**Programmer.** A. H. Morris.

