[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-130"></a>
## Vectors

<small>Original source: [View scanned PDF page 130](../scans/page_0130.png)</small>

<a id="topic-130-01"></a>
### Copying Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [`L32288`](../source_parts/nswc_part_04.f90#L431) |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [`L32343`](../source_parts/nswc_part_04.f90#L486) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [`L32398`](../source_parts/nswc_part_04.f90#L541) |


A copy of a vector X = (a1, ...,2,) can be made and stored in the array Y by the following subroutines:

```fortran
CALL SCOPY(N, SX, INCX, SY, INCY)
CALL DCOPY(N, DX, INCX, DY, INCY)
CALL CCOPY(N, CX, INCX, CY, INCY)
```

The argument kz is an integer which specifies the interval between successive components z,; of the vector X. If kx > O then it is assumed that 2, is stored in X(1+(#-1)kz) for t= 1,...,n. Otherwise, if kx < 0 then it is assumed that z, is stored in X(1+(n —1)|kz]). Similarly, the argument ky specifies the spacing of the components of Y.

SCOPY is used if X and Y are real arrays, DCOPY is used if X and Y are double precision arrays, and CCOPY is used if X and Y are complex arrays. When any of these routines is called, if n < O then the routine immediately terminates. Otherwise, ifn > 1 then the components 2, of X are stored in Y according to the spacing specified by the ky parameter.

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 808-323.


<small>Original source: [View scanned PDF page 131](../scans/page_0131.png)</small>

<a id="topic-131-01"></a>
### Interchanging Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [`L32525`](../source_parts/nswc_part_04.f90#L668) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [`L32586`](../source_parts/nswc_part_04.f90#L729) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [`L32647`](../source_parts/nswc_part_04.f90#L790) |


The components of two vectors X = (x1, ...,2n) and Y = (yi, ..., yn) can be interchanged by the following subroutines:

```fortran
CALL SSWAP(N, SX, INCX, SY, INCY)
CALL DSWAP(N, DX, INCX, DY, INCY)
CALL CSWAP(N, CX, INCX, CY, INCY)
```

The argument kz is an integer which specifies the interval between successive components x, of the vector X. If kx > 0 then it is assumed that z, is stored in X(1+ (1—1)kz) for t=1,...,n. Otherwise, if kz < C then it is assumed that 2, is stored in X(1+(n--1)|kz|). Similarly, the argument ky specifies the spacing of the components of Y.

SSWAP is used if X and Y are real arrays, DSWAP is used if X and Y are double precision arrays, and CSWAP is used if X and Y are complex arrays. When any of these routines is called, if n < O then the routine immediately terminates. Otherwise, if n > 1 then the components z, and y, are interchanged for 1 = 1, ...,n. Thus, when the routine terminates X = (y1,..., Yn) and Y = (zy, ...,2y).

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.


<small>Original source: [View scanned PDF page 132](../scans/page_0132.png)</small>

<a id="topic-132-01"></a>
### Planar Rotation Of Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [`L32688`](../source_parts/nswc_part_04.f90#L831) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [`L32731`](../source_parts/nswc_part_04.f90#L874) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [`L32774`](../source_parts/nswc_part_04.f90#L917) |


Let X = (21,...,2n) and Y = (y1, ...,yn) be vectors and ec and ¢ be real numbers such that c? +e? = 1. X and Y can be replaced with cX + sY and —sX + cY by the following subroutines:

```fortran
CALL SROT(N, SX, INCX, SY, INCY, C, S)
CALL DROT(N, DX, INCX, DY, INCY, C, S)
CALL CSROT(N, CX, INCX, CY, INCY, C, S)
```

The argument kz is an integer which specifies the interval between successive components z, of the vector X. If kx > 0 then it is assumed that 2, is stored in X(1+(#—1)kz) for t= 1,...,n. Otherwise, if kz < 0 then it is assumed that z, is stored in X(1+ (n — s)|kz|). Similarly, the argument ky specifies the spacing of the components of Y.

SROT is used if X and Y are real arrays, DROT is used if X and Y are double precision arrays, and CSROT is used if X and Y are complex arrays. The arguments c and s are real numbers when SROT and CSROT are used, and are double precision numbers when DROT is used. When any of these routines is called, if n < 0 then the routine immediately terminates. Otherwise, if n > 1 then the components x; and y; are replaced with cx, + sy, and —sz,;+cy,; for f=1,...,n.

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. fT. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory)

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

1OS


<small>Original source: [View scanned PDF page 133](../scans/page_0133.png)</small>

<a id="topic-133-01"></a>
### Modified Givens Rotations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [`L32818`](../source_parts/nswc_part_04.f90#L961) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [`L32969`](../source_parts/nswc_part_04.f90#L1112) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [`L33082`](../source_parts/nswc_part_04.f90#L1225) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [`L33240`](../source_parts/nswc_part_04.f90#L1383) |


If a; and ag are real numbers where r* = a? + a? #% 0, then there is an orthogonal

; matrix G = ( c *) such that G (2) = (5). In this case c = a)/r and s = ag/r. —s c¢ a2 0 The matrix G represents what is called a Givens rotation. Given A = a , the matrix 2)

G is uniquely defined up to the sign of r.

Alternatively, assume that instead of having A we are given D = (4 i ) and B= 2

(3) where d, > 0 ({ = 1,2) and A= D¥/?B. Then there exist matrices D = (2 o ) 2

0 dy, hi hyp

and H = (is hos

) where d, and d2 are positive values and

~

by HB= (1) (0) GD? =6DV*H (o = +1).

In this case, GA = GDV/?8 = oD/?(HB).

If dyby > d2b? then H and D can be defined by

dob hod his = 222 i 1 by (2) : u- Lt Ayghey dy dy /u dy = dy/u, in which case by ub; and a sgu(c). Otherwise, if dpb? << d2b? then # and D can be defined by dy by A Ay. - 1 uM dy by ' by ( 3) h dt I h M2 bh. uo 1 ai Ayyhee dy do fu dy dy fu,

in which case hy 0 uby anda syu(s)

in7


<small>Original source: [View scanned PDF page 134](../scans/page_0134.png)</small>

Any H which satisfies (1) is called a modified Givens rotation matrix. H is frequently preferred to G since its use may require fewer multiplications, and square roots are avoided. For convenience, if b2 = G or d; = 0 then H is defined to be the identity matrix and D=D. Otherwise, if b; = 0 or dy = O then formulas (3) are applied.

It is normally assumed that dy > 0. However, there are applications where it is

convenient to let dp < 0. If dy > 0 and dy <0 then D and H can be defined by (2) or (3) depending on whether |d,b?| > |d,63| or {d.b?| < |d2b2|. If (8) are used and u # 0, then dy < 0, which is not compatible with the requirement d; > 0. Consequently, dz < 0 is permitted only when |d,b}| > |d2b3|, and we note that 0 < u < 1. Since u can be near 0, D and H may have to be rescaled to avoid overflow and underflow. Rescaling may also be needed when dz > 0 (in this case 1 <u < 2).

The subroutines SROTMG and DROTMG are available for obtaining D and A, and [ the subroutines SROTM and DROTM are available for computing H (=) for any (<).

```fortran
CALL SROTMG(SD1, SD2, SX1, SY1, SPARAM)
CALL DROTMG(DD1, DD2, DX1, DY1, DPARAM)
```

D,, De, By, Be are real variables and @ areal array if SROTMG 3s used, and Dy, De, Ry, Bz are double precision variables and Q a double precision array if DROTMG is used. Q is an array of dimension 5.

It is assumed that D, = dy and By = 6; (¢ = 1,2) on input and that d; > 0. The argument dz may be negative or nonnegative. If hh 7 0 then it is assumed that [d,b?| > |d263 |. When SROTMG or DROTMG is called, Dy and Dz are reset. to dy aud do, and 23, is reset to by. Be is not modified, and H is stored in Q as follows.

Q(1) is an indicator which specifies the elements of H that are stored in Q. IfQ(1) 1 then all the elements are stored and

QZ) -- hay Q(4) - Aas QB) ha QO(5) hay. Otherwise, Q(1) has one of the following values: Q(1) Q Hf as defined by (2). Q(3) 0 hay and Q(4) Aye. Q(2) and Q(5) are not defined. Q(t) 1 oH ‘ts defined by (3). O(2) 0 Aqy and Q(5) hay. Q(3) and Q(4) ae not de fhae d.

Q(1) 2 ?fis the identity matrix, Q(2),...,Q(5) are not defined.

**Error Return.** Hfdy © Oe fdp Oy} jdgb2] when dy © 0, then Doand Hoare set to the zero matrix and 6, Q. In this case, Q(t} Tand Q(t) O fora: 2.

Programming ‘These subroutines are part of the BLAS package of basic linear algebra subroutines designed by Co UL. Lawson, Ro Jo Hanson, DO Ro Kincaid, and Bo TO Krogh SROTUEM OG: and DROUOPNICO were modified oo Al EE Morris,


<small>Original source: [View scanned PDF page 135](../scans/page_0135.png)</small>

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

```fortran
CALL SROTM/n, X, kz, Y,ky,Q)
CALL DROTM(N, DX, INCX, DY, INCY, DPARAM)
```

Let X = (21, ...,2,) and Y = (y1, ..., yn) be vectors, and Q be the array obtained by SROTMG or DROTMG. If A is the modified Givens rotation matrix stored in Q, then SROTM and DROTM are available for computing (3) = H (=) (@=1,...,n).

The argument kz is an integer which specifies the interval between successive components z, of the vector X. If kx > O then it is assumed that z, is stored in X(1+(#~1)kz) for t= 1,...,n. Otherwise, if kx < 0 then it is assumed that z, is stored in X(4 + (n— 1)[kz}). Similarly, the argument ky specifies the spacing of the components of Y.

SROTM is used if X,Y, and @ are real arrays, and DROTM is used if X,Y, and Q are double precision arrays. When SROTM or DROTM is called, if n < 0 then the routine immediately terminates. Otherwise, ifn > 1 then the components zx, and y, are replaced with Z, and g, for i =1,...,n.

**Programming.** These subroutines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh.

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear

Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 808 323.

tee)


<small>Original source: [View scanned PDF page 136](../scans/page_0136.png)</small>

<a id="topic-136-01"></a>
### Dot Products Of Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [`L33356`](../source_parts/nswc_part_04.f90#L1499) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [`L33410`](../source_parts/nswc_part_04.f90#L1553) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [`L33464`](../source_parts/nswc_part_04.f90#L1607) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [`L33507`](../source_parts/nswc_part_04.f90#L1650) |


The following functions are available for computing the sums >>, 2,y; and 30. Z.iys where X = (21,...,%n) and Y = {y), ..., Yn) are real or complex vectors.

SDOT(n, X, kz, Y,ky) DDOT(n, X, kz, Y, ky) CDOTC(n, X, kz, Y, ky) CDOTU(n, X, kz, Y, ky)

The argument kz is an integer which specifies the interval between successive components x, of the vector X. If kz > 0 then it is assumed that z, is stored in X(1+(#—1)kz) for i=1,...,n. Otherwise, if kx < 0 then it is assumed that z, is stored in X(1+(n—1)|kzj). Similarly, the argument ky specifies the spacing of the components of Y’.

SDOT is used if X and Y are real arrays, and DDOT is used if X and Y are double precision arrays. SDOT is 2 real function and DDOT is a double precision function. When either of these two functions is called, if n < 0 then the function is assigned the value 0. Otherwise, ifn > 1 then the function is assigned the value >> 7,4.

scl

CDOTC and CDOTU are used if X and Y are complex arrays. CDOTC and CDOTU are complex functions. When either of these two functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if n > t then CDOTC(n, X,kz,Y, ky) is assigned

nm

nm the value 5” z,y, and CDOTU (n, X,kz,Y, ky) is assigned the value >7 2,y.. Remark. DDOT must be declared in the calling program to be of type DOUBLE PRECISION, and CDOTC and CDOTU must be declared to be of type COMPLEX.

**Programming.** These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. ‘The functions were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, ©. L., Hanson, R. J., Kincaid, 9. R., and Krogh, F.T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308 323


<small>Original source: [View scanned PDF page 137](../scans/page_0137.png)</small>

<a id="topic-137-01"></a>
### Scaling Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [`L33549`](../source_parts/nswc_part_04.f90#L1692) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [`L33597`](../source_parts/nswc_part_04.f90#L1740) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [`L33645`](../source_parts/nswc_part_04.f90#L1788) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [`L33676`](../source_parts/nswc_part_04.f90#L1819) |


If a is a real or complex number and X = (x1, ...,2,) a vector, then the vector X can be replaced with the vector aX by the following subroutines:

```fortran
CALL SSCAL(N, SA, SX, INCX)
CALL DSCAL(N, DA, DX, INCX)
CALL CSCAL(N, CA, CX, INCX)
CALL CSSCAL(N, SA, CX, INCX)
```

The argument kz is a positive integer. It is assumed that the component sz, is stored in X(1 + (¢ — 1)kx) for i = 1,...,n.

SSCAL is used if @ is a real number and X a real array, DSCAL is used if « is a double precision number and X a double precision array, CSCAL is used if a is a complex number and X a complex array, and CSSCAL is used if a is a real number and X a complex array. When any of these routines is called, if n < 0 then the routine immediately terminates. Otherwise, ifn > 1 then each z, is replaced with az,;. Thus when the routine terminates X = (az,,...,a2,).

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National ¥.aboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” A(TM 1'vans. Mata Software § (1979), pp. 308-323.


<small>Original source: [View scanned PDF page 138](../scans/page_0138.png)</small>

<a id="topic-138-01"></a>
### Vector Addition

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [`L33707`](../source_parts/nswc_part_04.f90#L1850) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [`L33761`](../source_parts/nswc_part_04.f90#L1904) |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [`L33815`](../source_parts/nswc_part_04.f90#L1958) |


```text
If a is a real or complex number and X == (71,...,%,) a vector, then any vector
Y = (y1, ..-,Yn) can be replaced with the vector aX + Y by the following subroutines:
```

```fortran
CALL SAXPY(N, SA, SX, INCX, SY, INCY)
CALL DAXPY(N, DA, DX, INCX, DY, INCY)
CALL CAXPY(N, CA, CX, INCX, CY, INCY)
```

The argument kz is an integer which specifies the interval between successive components 2, of the vector X. If kx > 0 then it is assumed that 2, is stored in X(1+(#—1)kz) for #=1,...,n. Otherwise, if kx < 0 then it i: assumed that 2, is stored in X(1+ (n —1)|kz]). Similarly, the argument ky specifies the spacing of the components of the vector Y.

SAXPY ‘s used if 418 a real number aid X, Y are real arrays, DAXPY is used if a ig a double precision number and X, Y are double precision arrays, and CAXPY is used if a is a complex number and X, Y are complex arrays. When any of these routines is called, if n < 0 or a = O then the routine immediately terminates. Otherwise, if n > 1 then y,; is replaced with az, + y; for + = 1,...,n. Thus when the routine terminates Y = (azy + yi, -..,@%n + Un).

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. 1., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math. Software 5 (1979), pp. 308-323.


<small>Original source: [View scanned PDF page 139](../scans/page_0139.png)</small>

<a id="topic-139-01"></a>
### L1 Norm of a Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [`L33855`](../source_parts/nswc_part_04.f90#L1998) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [`L33904`](../source_parts/nswc_part_04.f90#L2047) |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [`L33952`](../source_parts/nswc_part_04.f90#L2095) |


The following functions are available for computing the 2; norm of a real vector or a modified LZ, norm of a complex vector.

SASUM(n, X, kz) DASUM(n, X, kz; SCASUM(n, X, kz)

```text
X := (x1, ....2,) is a vector and kz a positive integer. It is assumed that 2, is stored
in X(1-+ (¢ ~ Ikz) ford =1,...,n,
```

SASUM is used if X is a real array and DASUM 1s used if X is a double precision array. SASUM is a real function and DASUM a double precision function. When either of these functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if

nm % > 1 then the function is assigned the value >> |x|. sol

SCASUM is used if X is a complex array. SCASUM is a real function. When SCASUM is called, if n < 0 then the function is assigned the value 0. Otherwise, if m > 1 then SCASUM(n, X, ka) is assigned the value > {|Re(z,)| + |Im(z,)|].

t=1 Remarks. (1) DASUM must be declared in the calling program to be of type DOUBLE PRECISION. (2} SCASUM(n, X, kx) is the norm of the complex vector X == (21,.. ,2n) when X is regarded as a real vector of dimension 2n. This norm is frequently preferred over the n standard Ly norm )> |z,| since it takes less time to compute. t=1 Programming. These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The functions were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math. Software 5 (1979),


<small>Original source: [View scanned PDF page 140](../scans/page_0140.png)</small>

<a id="topic-140-01"></a>
### L2 Norm of a Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [`L33988`](../source_parts/nswc_part_04.f90#L2131) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [`L34115`](../source_parts/nswc_part_04.f90#L2258) |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [`L34242`](../source_parts/nswc_part_04.f90#L2385) |


The following functions are available for computing the Zz norm of a real or complex vector.

SNRM2(n, X, kz) DNRM2(n, X, kz) SCNRM2(n, X, kz)

```text
X = (21, ...,2n) is a vector and kz a positive integer. It is assumed that 2, is store.
in X(14 (¢~- i)kr) ford = 1, ...,n.
```

SNRM2 is used if X is a real array, DNRM2 is used if X is a double precision array, and SCNRM2 is used if X is a complex array. SNRM2 and SCNRM2 are real functions and DNRM? a double precision function. When any of these functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if n > 1 then the function is assigned

n 2 the value p |z,| t=]

**Remark.** The function DNRM2 must be declared in the calling program to be of type DOUBLE PRECISION.

**Programming.** These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The functions were written by Charles Lawson (Jet Propulsion Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T. “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

L79


<small>Original source: [View scanned PDF page 141](../scans/page_0141.png)</small>

<a id="topic-141-01"></a>
### L-infinity Norm of a Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [`L34377`](../source_parts/nswc_part_04.f90#L2520) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [`L34420`](../source_parts/nswc_part_04.f90#L2563) |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [`L34463`](../source_parts/nswc_part_04.f90#L2606) |


The following functions are available for finding the largest component z, of a vector X = (r1,...,2n).

ISAMAX(n, X, kz) IDAMAX(n, X, kz) ICAMAX(n, X, kz)

The argument kz is a positive integer. It is assumed that the component 2, is stored in X(1+ ( — 1)kx) ford =1,...,n.

ISAMAX is used if X is a real array and IDAMAX is used if X is a double precision array. ISAMAX and IDAMAX are integer functions. When either of these functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if n > 1 then the function is assigned the value t where ¢ is the smallest index such that |z,| = max{!z,]:7 = 1,.. ,n}.

ICAMAX is also an integer function. It is used when X is a complex array. If n < 0 then ICAMAX(n, X, kz) is assigned the value G. Otherwise, if n > 1 then the function is assigned tue value ¢ where ¢ is the smallest index such that |Re(z,)| + |Im(z,)| -= max{|Re(z,)| + |Im(z,)|: 7 =1, ...,n}.

**Note.** he mapping X —+ max{|Re(z,)| + | m(z,;)|: 7 = 1,...,n} is the L,. norm of the complex vector X = (1, ...,2,) when X is regarded as a real n x 2 matrix. This norm is frequently preferred over the standard Lo. norm max{{z,;|: 7 = 1, ...,n} since it takes less

time to compute.

**Programming.** These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The functions were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

