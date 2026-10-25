[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-439"></a>
## Continuous Random Number Generation

<small>Original source: [View scanned PDF page 439](../scans/page_0439.png)</small>

<a id="topic-439-01"></a>
### Uniform Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [`L119330`](../source_parts/nswc_part_12.f90#L2432) |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [`L119412`](../source_parts/nswc_part_12.f90#L2514) |


The following subroutines are ‘available for generating a sequence of uniform variates in the open interval (0, 1).

```fortran
CALL URNG(IX, X, N, IERR)
CALL DURNG(IX, X, N, IERR)
```

A is an array of dimension n or larger where n > 1. URNG is used if A is a real array and DURNG is used if A is a double precision array.

The argument n is the number of variates to be generated, and tz and IERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < ix < 234-1. When URNG or DURNG is called, if no input errors are detected then JERR is set to 0 and n uniform variates are stored in A. On output, tz is a new seed for generating mere variates.

**Error Return.** IERR = 1 if n < 0 and IERR = 2 if tz is not a proper seed.

Usage. A given seed always initiates the same set. of variates. Thus, the following two sets of instructions

(1) IX = 103 CALL URNG(IX,A,30,JERR)

(2) IX =: 103 CALL URNG(IX,A,20,JERR) CALL URNG(IX,A(21),10,IERR)

generate the same 30 variates.

**Remark.** {t is assumed that the integer arithmetic being used handles ali integers ¢ in the interval |s| < 2°) — 4,

**Programming.** Written by Linus Schrage (University of Chicago). Adapted by A.H. Morris.

**Reference.** Schrage, Linus,“A More Portable Fortran Random Number Generator,” ACM Trans. Math Software 5 (1979), pp. 132-138.


<small>Original source: [View scanned PDF page 440](../scans/page_0440.png)</small>

<a id="topic-440-01"></a>
### Generating Points Uniformly in a Square

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [`L119787`](../source_parts/nswc_part_12.f90#L2889) |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [`L119855`](../source_parts/nswc_part_12.f90#L2957) |


The following subroutines are available for generating points (71,91), ..-,{2n, Yn) uniformly where 0 -< 2, < l and 0 < y, < 1 for each ¢.

```fortran
CALL URNG2(IX, X, Y, N, IERR)
CALL DURNG2(IX, X, Y, N, IERR)
```

and Y are arrays of dimension n or larger where n > 1. URNG2 is used if X and Y are real arrays, and DURNG2 is used if X and Y are double precision arrays.

The argument n is the number of points to be generated, and tz and JERR are variables. On input, tt is an integer (called a seed) for initializing the sequence of points. It is assumed shat 1 < te < 49! —1. When URNGZ or DURNG2 is called, if no input errors are detected then [ERR is set to 0 and n points are generated. The abscissas 2,,...,2,, of the points are stored in X and tie ordinates y,,...,y, are stored in Y. On output, tz is a new seed for generating more points,

**Error Return.** JERR = 1 ifn < G and IERR = 2 if ¢2 is not a proper seed.

Usage. A given seed always initiates the same set of points. Thus, the following two sets of instructions

(1) X= 4 CALL URNC 2 ‘IX,X,Y,30,IERR)

(2) IX = 4

```fortran
CALL URNG2(IX, X, Y, N, IERR)
CALL URNG2(IX, X, Y, N, IERR)
```

generate the same 30 points.

**Remark.** It is assumed that the integer arithmetic being used handles all integers t in the interval is| < 23) ~ 1,

**Programming.** Written by Linus Schrage (University of Chicago). Adapted by A.H. Morris.

**Reference.** Schrage, Linus,“A More Portable Fortran Random Number Generator,” ACM Trans. Math Software 5 (1979), pp. 132-138.


<small>Original source: [View scanned PDF page 441](../scans/page_0441.png)</small>

<a id="topic-441-01"></a>
### Generating Points Uniformly In A Circle

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [`L119923`](../source_parts/nswc_part_12.f90#L3025) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [`L120029`](../source_parts/nswc_part_12.f90#L3131) |


The following subroutines are available for generating points (21,91), ...,(2n, Yn) uniformly where z? + y? <1 for each ¢.

```fortran
CALL RCIR(N, IX, X, Y, IERR)
CALL DRCIR(N, IX, X, Y, IERR)
```

X and ¥ are arrays of dimension n oy larger Where i > i. RCOUR (3 used if X and Y are real arrays, and DRCIR is used \f X and Y are double precision arrays.

The argument n is the number of points to be generated, ad tz and IERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of points. It is assumed that 1 < tz < 2%! -- 1. When RCIR or DRCIR is called, if no input errors are detected then IERR is set to 0 and n points are generated. The abscissas 21, ...,2, of the points are stored in X and the ordinates y,, ...,¥, are stored in Y. On output, ix is a new seed for generating more points.

Error Return. [ERR = 1 ifm < 0 and IERR = 2 if fz is not a proper seed.

Usage. A given seed always initiates the same set of points. Thus, the following two sets of instructions

(1) IX=7 CALL RCIR(30,IX,X,Y,IERR)

(Q 1X7 CALL RCIR(20,1X,X,¥ ERR) CALL RCIR(10,IX,X(21),Y (21) JERR)

generate the same 30 points.

```text
Remarks.
(1) RCIR and DRCIR never generate the point (3,0)
(2) It is assumed that the uteger arithmetic being used handles all ictegers ¢ in the interval
```

li] < 2381,

Algorithm Points are generated uniformly in the square {(r,y) : Ja! < Land yf <b}. The procedure terminates when n points have been obtained which he in the unit circle

**Programming.** RCL? calls the subroutine RCIRG, and DRCIR cells the subroutine DI CIR. These routines were written by A. TE Morris,


<small>Original source: [View scanned PDF page 442](../scans/page_0442.png)</small>

<a id="topic-442-01"></a>
### Normal Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [`L120135`](../source_parts/nswc_part_12.f90#L3237) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [`L120186`](../source_parts/nswc_part_12.f90#L3288) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [`L120237`](../source_parts/nswc_part_12.f90#L3339) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [`L120269`](../source_parts/nswc_part_12.f90#L3371) |


Consider the normal distribution having the distribution function

Fc) = Ss [ ent 2 at ( } J2n J ~00

for all real x. This distribution has mean 0 and standard deviation 1. The following subroutines are available for generating normal variates from this distribution.

```fortran
CALL RNOR(IX, A, N, IERR)
CALL DRNOR(IX, A, N, IERR)
```

A is an array of dimension n or la:ger where n > 1. A is a real array if RNOR is used, and A is a double precision array if DRNOR is used.

The argument n is the number of variates to be generated, and tz and JERR are variables. On input, ¢z is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 <ta2 < 23! --1. When RNOR or DRNOR is called, if no input errors are detected then IERR is set to 0 and n variates are stored in A. On output, tz is a new seed for generating more variates.

**Error Return.** TERR = 1 ifm <0 and IERR = 2 if tz is not a proper seed. Algorithm, The polar algorithm is used.

Usage. Normal variates are generated in pairs. If n is odd then the last variate cy+,; generated is net stored. Also, a given seed always initiates the same sequence of variates. Thus, if we consider the following three sets of instructions

(1) IX =5 CALL RNOR(!X,A,30,]ERR)

```fortran
CALL RNOR(IX, A, N, IERR)
CALL RNOR(IX, A, N, IERR)
```

(3) [Xx ox 5 CALL RNOR(IX,A,9, JERR) CALL RNOR(IX,A(10),29 JERR)

thea we note that (1) and (2) generate the same 30 normal variates. Also (3) generates 29 of these $0 variates, skipping the £0"? variate, The reason for this is that. .¢ request in (2) for 9 variates requires LO variates to be generated, only J of winel: are used.


<small>Original source: [View scanned PDF page 443](../scans/page_0443.png)</small>

**Remarks.**

(1) If ay,...,@, ere variates from RNOR and v,; = ro + oa; fort = 1,...,n ando > 0, then vj, ...,0, are variates from a normal distribution with mean x9 and standard deviation «.

(2) It is assumed that the integer arithmetic being used handles all integers in the interval ye oy3t

**Programming.** RNOR calls the subroutine RCIR1, and DRNOR calls the subroutine DRCIR1. These routines are written by A. H. Morris.

**Reference.** Marsaglia, G. and Bray, T.A.,“A Convenient Method for Generating Normal Variables,” SIAM Review 6 (1964), pp. 260-264.

```fortran
CALL NRNG(IX, A, N, IERR)
CALL DNRNG(IX, A, N, IERR)
```

A is an array of dimension n or larger where n > 1. A is a real array if NRNG is used and .4 is a double precision array if DNRKNG is used.

The argument n is the number of variates to be generated, and tz and TERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < tz < 23! —1. When NPNG or DNRNG is called, if no input errors are detected then IERR is set to 0 and n variates are stared in A. On output, tz is a new seed for generating more variates.

Error Return, TERR = 1 ifn < C and IERR = 2 if tz is nct a proper seed. Algorithm. The Box-Muller algorithm is used.

Usage. Normal variates are generated in pairs. The usage of NRNG and DNRNG is identical to the usage of RNOR and DRNOR.

**Remarks.**

({) NRNG and DNRNG require 15-25% more time than RNOR and DRNOR.

(2) [tis assumed that the integer arithmetic being used handles all integers ¢ in the interval Ni cn

**Programming.** NRNG calls the subroutine URNG, and DNRNG calls the subroutine DURNG. NRNG aad DMIRNG were written by A. H. Morris,

**Reference.** Box, G.ELP. and Muller, M-E.,“A Note on the Generation of Random Normal Deviates,” Annale of Math Statistics 29 (1950), pp. 610-611.


<small>Original source: [View scanned PDF page 444](../scans/page_0444.png)</small>

<a id="topic-444-01"></a>
### Multivariate Normal Random Vector Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L120302`](../source_parts/nswc_part_12.f90#L3404) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L120440`](../source_parts/nswc_part_12.f90#L3542) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L120549`](../source_parts/nswc_part_12.f90#L3651) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L120686`](../source_parts/nswc_part_12.f90#L3788) |


Let A be a real symmetric positive definite matrix of order m, det(A) be the determinant of A (which must be positive), and pp = (#41,.-.,fm). Consider the multivariate normal distribution having the density function

1 -1L/2{a—p)A~*(z~p)* f(2) = —— eee /2(n—p) AW *(z~p)

J (2x) ™det(A)

for z = (21,...,2m) where all z; are real. This distribution has the covariance matrix A and mean vector yp. The subroutines NRVG and DNRVG are available for generating variates z from this distribution when A is an arbitrary positive definite matrix. If A is a diagonal matrix then the subroutines NRVG1 and DNRVGiI are also available for generating variates from the distribution.

```fortran
CALL NRVG(MO, IX, N, M, A, FMU, X, KX, IERR)
CALL DNRVG(MO, IX, N, M, A, FMU, X, KX, IERR)
```

It is assumed that m > 2. A is an array of dimension m(m +- 1)/2 or larger containing the positive definite matrix A in packed form,’ and p is an array of length m containing the mean vector of the distribution.

The argument. n is the number of vectors to be generated, and X is a 2-dimensional array of dimension kr x n. It is assumed that kr > m.

N&VG is used if A, 4, and X are real arrays, and DNRVG is used if A, zp, and X are double precision arrays.

MO is an argument which specifies if NRVG or DNRVG is being called for the first time, On an initial call, MO = 0 and we have the following setup:

The arguments tz and IERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of vectors. It is assumed that 1 < tz < 294 - 1. When NRVG or DNRVG is called, if no input errors are detected then TERR is set to 0 and n vectors x are stored in X. The j'” vector is stored in the 7** column of X. On output, tz is a new seed for generating more vectors.

```text
Error Return. IERR = Lifn <0, IERR = 2ifm < lorm> kz, LERR = 3 if Ais not a
positive definite matrix, and IFRR = 4 if tz is not a proper seed.
```

On an initial call to NRVG or DNRVG, the lower triangular matrix in the Cholesky decomposition of A replaces the original data in A. If IMRR -= 0 then the routine may be recalled with MO + 0 to generate more vectors. If MO / O then it is assumed that A and on have not been modified by the user. However, n, uw, X, and ka may be different.

‘See the section on packed symmetric matrices and the subroutines MICVES, MOVSF, DMCVEBS, and DMCOVSF.


<small>Original source: [View scanned PDF page 445](../scans/page_0445.png)</small>

The routine employs the lower triangular matrix obtained on the initial call to NRVG or DNRVG to generate n new vectors. As before, if no input errors are detected then IERR is set to 0 and the new vectors are stored in X.

Usage. A given seed always initiates the same set of vectors. Thus, the following two sets of instructions

(1) IX =3 CALL NRVG (0,IX,30,M,A,X0,X,KX,IERR) IF (IERR .NE. 0) STOP

(2) IX =3 CALL NRVG (0,IX,20,M,A,X0,X,KX,IERR) IF (IERR .NE. 0) STOP CALL NRVG (1,IX,10,M,A,X0,X(1,21),KX,IERR)

generate the same 30 vectors.

**Remark.** It is assumed that the integer arithmetic being used handles all integers 1 in the interval |#] < 25! — 1.

**Algorithm.** The lower triangular matrix D in the Cholesky decomposition of A is computed, and n vectors z = (21, ...,2m) are generated where the values z; are independent variates from the normal distribution with mean O and variance 1. The n variates x = Lz+ yp of the multivariate normal distribution are then computed.

Programming. NRVG employs the subroutines RNOR, RCIR1, SPPFA, and function SDOT, aad DNRVG employs the subroutines DRNOR, DRCIR1, DPPEFA, and function DDOT. NRVG and DNRVG were written by A. H. Morris.

**Reference.** Anderson, T.W., An Introduction to Multivariate Statistical Analysts, John Wiley and Sons, New York, 1958, pp. 5-27.

```fortran
CALL NRVG1(MO, IX, N, M, A, FMU, X, KX, IERR)
CALL DNRVG1(MO, IX, N, M, A, FMU, X, KX, IERR)
```

It is assumed that m > 2, and that A is a diagonal matrix whose diagonal elements are positive numbers. A is an array of dimension m or larger containing the diagonal elements. and y is an array of dimension m containing the mean vector of the distribution.

The argument n is the number of vectors to be generated, and X is a 2-dimensional array of dimension kz X n. It is assumed that kx > m.

NRVGI 1s used if A, wy and X are real arrays, and DNRVG1 is used if A, yz, and X are double precision arrays.

MO is an argument which specifies if NRVGI or DNRVGLI is being called for the first


<small>Original source: [View scanned PDF page 446](../scans/page_0446.png)</small>

time. On an initial call, MO = 0 and we have the following setup:

The argument tz and IERR are variables. On input, ta is an integer (called a seed) for initializing the sequence of vectors. It is assumed that 1 < tz < 284 — 1. When NRVG1 or DNRVG1 is called, if no input errors are detected then IERR is set to 0 and n vectors z are stored in X. The j*® vector is stored in the j** column of X. On output, iz is a new seed for generating more vectors.

```text
Error Return. IERR = 1 ifn < 0, JERR = 2 ifm < Lorm> kz, IERR = 3 if A(t) < 0 for
some 1, and IERR = 4 if fz is not a proper seed.
```

On an initial call to NRVGI or DNRVGI1, the square roots of the diagonal elements of the matrix are stored in A. If IERR = 0 then the routine may be recalled with MO # 0 to generate more vectors. If MO # 0 then it is assumed that A and m have not been modified by the user. However, n, », X, and kx may be different. The routine employs the roots obtained on the initial call to NRVG1 or DNRVGI to generate n new vectors. As before, if no input errors are detected then IERR is set to 0 and the new vectors are stored in X.

Usage. The usage of NRVGi and DNRVG1 is identical to the usage of NRVG and DNRVG.

**Remarks.**

```text
(1) NRVG and NRVG1 generate the same vectors when A is a diagonal matrix.
(2) It is assumed that the integer arithmetic being used handles all integers ¢ in the interval
js] < 272-1.
```

**Programming.** NRVG1 employs the subroutines RNOR and RCIR1, and DNRVG: employs the subroutines DRNOR and DRCIR1. NRVG1 and DNRVGI were written by A. H. Morris.


<small>Original source: [View scanned PDF page 447](../scans/page_0447.png)</small>

<a id="topic-447-01"></a>
### Exponential Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [`L120795`](../source_parts/nswc_part_12.f90#L3897) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [`L120883`](../source_parts/nswc_part_12.f90#L3985) |


For a > O consider the exponential distribution having the distribution function

; 1 f* F(z) = al e/4 dt =1—e7*/* (x >0). 0

a,

This distribution has the mean a and variance a?. The following subroutines are available for generating variates from this distribution.

```fortran
CALL RANEXP(N, A, ISEED, X, IERROR)
CALL DRNEXP(N, A, ISEED, X, IERROR)
```

X is an array of dimension n or larger where n > 1. The argument a is a real number and X a real array if RANEXP is used. Otherwise, a is a double precision number and X a double precision array if DRNEXP is used.

The argument n is the number of variates to be generated, and tz and IERR are variables. On input, iz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < tz < 23} —1. When RANEXP or DRNEXP is called, if no input errors are detected then IERR is set to 0 and n exponential variates are stored in X. On output, iz is a new seed for generating more variates.

Error Return, [ERR = 1 ifn < 0, IERR = 2 if a < 0, and IERR = 3 if rr is not a proper seed.

Usage. A given seed always initiates the same set of variates. Thus, the following two sets of instructions

(1) IX =3 CALL RANEXP(30,A,IX,X,IERR)

(2) IX =3 CALL RANEXP(20,A,IX,X,IERR) CALL RANEXP(10,A,[X,X(21),IERR)

generate the same 30 variates.

**Remark.** If is assumed that the integer arithmetic being used handles all integers + in the

interval |¢| < 2°) - 1.

**Programming.** RANEXP calls the subroutine URNu, and DRNEXP calls the subroutine DURNG. RANEXP and DRNEXP were written by John R. Crigler. RANEXP has been obtained from the STATLIB library.


<small>Original source: [View scanned PDF page 448](../scans/page_0448.png)</small>

**Reference.** Thomas, M.A., Gemmill,G.W., and Crigler,J.R., STATLIB: NSWC Library of Statistical Programs and Subroutines, Report NSWC TR. 89-97, Naval Surface Warfare Center, Dahlgren, Va., 1985.


<small>Original source: [View scanned PDF page 449](../scans/page_0449.png)</small>

<a id="topic-449-01"></a>
### Gamma Random Number Generator And The Chi-Square Distribution

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [`L120970`](../source_parts/nswc_part_12.f90#L4072) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [`L121034`](../source_parts/nswc_part_12.f90#L4136) |


For a > 0 consider the gamma distribution having the distribution function

/ gn tyort dt (2 > 0),

P(a,c) = =~ ra) Jo

and for v > O consider the chi-square distribution having the distribution function

cee en re = ~ vpe ‘ 6 > O). BG) = Tay [e wg (x >9) Then F,(r) = P(v/2,2/2), so that only the gamma distribution need be computed. The following subroutines are available for generating variates from the gamma distribution when a > 107}.

```fortran
CALL RGAM(IX, A, N, X, IERR)
CALL DRGAM(IX, A, N, X, IERR)
```

X is an array of dimension nv or larger where n > 1. The argument a is a real number and .X a real array if RGAM is used. Otherwise, a is a double precision number and X a double precision array if DRGAM is used.

It is assumed that a > 0.1 and that n is the number of variates to be generated. IERR and tz are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. it is assumed that 1 <i tz < 23! —~ 1. When RGAM or DRGAM is called, if no input errors are detected then JERR is set. to 0 and n gamma variates are stored in X. On output, iz 1s a new seed for generating more variates.

**Error Return.** ORR = Lifn <0, TERR == 2ifa < 0.1, and IERR = 3 if tz is not a proper seed.

Usage. A given seed always initiates the same set. of variates. Thus, the following two sets

of instructions

(1) IX =3 CALL RGAM(IX,A,30, X,IERR)

(2) IX 3

```fortran
CALL RGAM(IX, A, N, X, IERR)
CALL RGAM(IX, A, N, X, IERR)
```

OOS


<small>Original source: [View scanned PDF page 450](../scans/page_0450.png)</small>

generate the same 30 variates.

**Warning.** The double precision subroutine DRGAM can be quite slow. It is recommended that its speed be checked if thousands of variates are to be generated.

**Remarks.**

(1) Ifa = v/2 and x,,...,2, are variates for the gamma distribution given by P(a, x) then 221, ...,2%, are variates for the chi-square distribution given by F,(z).

(2) It is assumed that the integer arithmetic being used handles all integers ¢ in the interval jij < 234-1.

**Programming.** RGAM calls the subroutines URNGO and GAMINV, and DRGAM calls the subroutines DURNGO and DGINV. RGAM and DRGAM were written by A. H. Morris.

SOG


<small>Original source: [View scanned PDF page 451](../scans/page_0451.png)</small>

<a id="topic-451-01"></a>
### Beta Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L121097`](../source_parts/nswc_part_12.f90#L4199) |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L121193`](../source_parts/nswc_part_12.f90#L4295) |


For a,6 > 0 consider the beta distribution having the distribution function

_ 1 * a-l _ pyo-l 1.(0,8) = aay ft (—t)d (0<2<)),

where B(a,b) is the beta function. The following subroutines are available for generating variates from this distribution when a, 6 > 1/4

```fortran
CALL RBETA(N, A, B, IX, X, IERR)
CALL DRBETA(N, A, B, IX, X, IERR)
```

X is an array of dimension n or larger where n > 1. The arguments a and 8 are real numbers and X a real array if RBETA is «sed. Otherwise, a and 6 are double precision numbers and X a double precision array if ORBETA is used.

It is assumed that a,b > 1/4 and that n is the number of variates to be generated. TERR and tz are variables. On input, 1z is an integer (called a seed) for initializing the sequence of variates. It is assumed that } < ix < 23! — 1. When RBETA or DRBETA is called, if no input, errors are detected then IEF.R is set to O and n beta variates are stored in X. On output, tz is a new seed for generating more variates.

**Error Return.** IERR = 1 ifn < 0, IERK = 2 if a < 1/4 or 6 < 1/4, and IERR = 3 if tz is not a4 proper seed.

Usage. A given seed always initia‘es the same set of variates. Thus, the following two sets of instructions

(1) IX=7 CALL RBETA (30, A, B, EX, X, IERR)

(2) IX =7 CALL RBETA (20, A, B, EX, X, IERR) CALL RBETA (10, A, B, 1X, X(21), IERR)

generate the same 30 variates.

Warning, ‘The double precision subroutine ORBITA can be quite slow. It is recommended that its speed be checked if thousands of variates are to be generated,

**Remark.** [It is assumed that the integer arithmetic being used handles all integers ¢ in the

interval |e} = 294g. Programming. RBE’PA calls the subroutines OR NGO and GAMINY, and DRBR’PA calls

the subroutines DURNGO and DGINV. RBEPA and DRBE'PTA were written by Ao H. Morris.

O47


<small>Original source: [View scanned PDF page 452](../scans/page_0452.png)</small>

<a id="topic-452-01"></a>
### F-Distribution Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L121289`](../source_parts/nswc_part_12.f90#L4391) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L121395`](../source_parts/nswc_part_12.f90#L4497) |


For a,5 > 0 consider the F-distribution having the distribution function

a2/25b/2

Pol) = Ba], ]3)

F | t{2/2)-1(b 4. gt)—(9+8)/2 gt = (F > 0) Jo where B(a/2,6/2) is the beta function. The values a and 6 are called the numerator and denominator degrees of freedom of this distribution. The value F == (bs)/(at) is a variate from this distribution when s and t are independent variates from the gamma distributions with parameters a/2 and 6/2 respectively. The following subroutines are available for generating variates from the F-distribution when a,b > 1/2.

```fortran
CALL FRAN(N, A, B, IX, X, IERR)
CALL DFRAN(N, A, B, IX, X, IERR)
```

X is an array of dimension n or larger where n > 1. The arguments a and 6 are real numbers and X a real array if FRAN is used. Otherwise, a and 6 are double precision numbers and X a double precision array if DFRAN is used.

It is assumed that a,b - 1/2 and that n is the number of variates to be generated. TERR and tz are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < #2 < 23! ~ 1. When FRAN or DFRAN is called, if no input errors ace detected then IEKR is set to 0 and n variates are stored in X.

On output, tz is a new seed for generating more variates,

**Error Return.** TERR ~ 1 ifn < 0, IERR = 2 ifa < 1/2 or 6 < 1/2, IERR = 3 if 6 is too small for the floating arithmetic being used, and IERR = 4 if tx is not a proper seed. IFRR -- 3 can occur only if the floating arithmetic has a exceedingly limited range (say, its largest value is less than (07),

Usage. A given seed always initiates the same set of variates. Thus, the following two sets y , 8g

of instructions

(1) IX 3 CALL FRAN (30, A, B, IN, X, FERRER)

(2) 1X 3

```fortran
CALL FRAN(N, A, B, IX, X, IERR)
CALL FRAN(N, A, B, IX, X, IERR)
```

generate the same SO variates

Warning The double precision subroutine OPRAN can be quite stow. PO ds recommended

that its speed he cheeSed df thousands of variates are to be generated


<small>Original source: [View scanned PDF page 453](../scans/page_0453.png)</small>

**Remark.** It is assumed that the integer arithmetic being used handles all integers 7 in the interval |#| < 2°! -- 1.

**Programming.** FRAN calls the subroutines URNGO and GAMINV, and DF RAN calls the subroutines DURNGO and GINYV. FRAN ang DFRAN were w- iter by A. H. Morris.


<small>Original source: [View scanned PDF page 454](../scans/page_0454.png)</small>

<a id="topic-454-01"></a>
### Student T-Distribution Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [`L121502`](../source_parts/nswc_part_12.f90#L4604) |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [`L121591`](../source_parts/nswc_part_12.f90#L4693) |


For a > 0 consider the student t-distribution having the distribution function t

where B(1/2,a/2) is the beta function. he value t = z/\/w/a is a variate from this distribution when z is a variate from the normal distribution with mean O and variance 1, and w is an independent variate from the chi-square distribution with a degrees of freedom. The following subroutines are available for generating variates from the student t-distribution when a > 1/2.

```fortran
CALL TRAN(N, A, IX, X, IERR)
CALL DTRAN(N, A, IX, X, IERR)
```

X is an array of dimension n or larger where n > 1. The argument a is a real number and X a real array if TRAN is used. Otherwise, a is a double precision number and X a double precision array if DTRAN is used.

It is assumed that a > 1/2 and that n is the number of variates to be generated. IERR and ¢z are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < ¢z < 29! -- 1. \/hen TRAN or DTRAN is called, if no input errors are detected then IERR is set to 0 and n variates are stored in X. On output, tz is a new seed for generating more variates.

**Error Return.** IERR = 1 if n < 0, IERR = 2 ifa < 1/2, IERR = 3 if u is too small for the floating arithmetic being used, and IERR = 4 if tz is not a proper seed. IERR = 3 can occur only if the floating arithmetic has a exceedingly limited range (say, its smallest positive value is greater than 107°”),

Usage A given seed always initiates the same set of variates. Thus, the following two sets of instructions

(1) IX =3 CALL TRAN (30, A, EX, X, HERR)

(2) IX = 3

```fortran
CALL TRAN(N, A, IX, X, IERR)
CALL TRAN(N, A, IX, X, IERR)
```

generate the same 30 variates,

**Warning.** The double precision subroutine DT RAN can be quite slow. It is recommended that its speed be checked if thousands of variates are to be generated


<small>Original source: [View scanned PDF page 455](../scans/page_0455.png)</small>

**Remark.** It is assumed that the integer arithmetic being used handles all integers ¢ in the

interval |s! «¢ 23) — 1.

**Programming.** TRAN calls the subroutines URNGO, URNG1, PNI, and GAMINV, and DTRAN calls the routines DURNGO, DURNGI, DPNI, and DGINV. TRAN and DTRAN

were written by A. H. Morris.


<small>Original source: [View scanned PDF page 456](../scans/page_0456.png)</small>

<a id="topic-456-01"></a>
### First Order Markov Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [`L121680`](../source_parts/nswc_part_12.f90#L4782) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [`L121801`](../source_parts/nswc_part_12.f90#L4903) |


Given a sequence of independent variates z1,...,2n (mn > 2) from a norma! distribution with mean O and standard deviation o > 0. For any real to and fee] < 1 ict

(+)

ay == Ko -f @(ay-.1 — 20) + 2; (j = 2, ...,n).

Then aj,...,@, are variates from a normal distribution with mean rg and variances 9? /{ 1 — as. Since zi, ...,2, are independent variates, a; (j > 2) is considered to depend only on a;—1 for information from the past. Hence, a), ...,¢, forms a first order Markov ‘Le, first order autoregressive) process. Since the process is covariance stationary, the correlation

between terms a; and a, of the sequence becomes progressively weaker when |k— | increases.

For any %9,0,a, and n the following subroutines are available tor obtaining sequences 41, . ,@, of variates from (*).

```fortran
CALL RMKi(n, 20,0, a,12,.4, TERR)
CALL DRMK1(N, FMU, SIG, ALPHA, ISEED, X, IERROR)
```

The arguments 29,0, and @ are real numbers and A a real arr » if RMK1 ic used. Otherwise, 29,0, and @ are double precision numbers and A a double precision array when DRMK1 is used.

A is an array of dimension n or larger when n > 2, and t7 and TERR are variables. It is assumed that o > 0 and |a| < 1. On input, ¢¢ is an integer (called a seed) for initializing the sequence of variates z1,...,Z,. It is assumed that fk < fz < 23) — 4. When RMK1 or DRMK1 is called, if no input errors are detected then IERR is set to 0 and a sequence ay, ..-,@, is obtained and stored in A. On output, tz is a new seed for generating other sequences dy, ...,4n.-

```text
Error Return. TERR is set tc one of the following values if an input error is detected.
IERR =: 1 ifn < 2
[ERR = 2 ife <0
IERR = 2 if ja] > 1
JERR = 4 if ¢z is not a proper see.
```

**Remark.** It is assumed that the integer arithmetic being used handles all integers yin the interval |i] < 23t — y.

**Programming.** RMK1 employs the subroutines RNOR and ROERT, and DRME: employs the subroutines DRNOR and DRCIRL. RMK1 was written by John R. Crigler and modified by A. H. Morns. RMK1 is a modification of the subroutine RANMET, which resides in the STATLIB library. DRMK) was adapted from KMK1 by A. HH. Morris


<small>Original source: [View scanned PDF page 457](../scans/page_0457.png)</small>

**Reference.** Thomas, M.A., Gemmill, G.W., and Crigler, J.R., STATLIB: NSWC Library of Statistical Programs and Subroutines, Report NSWC TR 89-37, Naval Surface Warfare Center, Dahlgren, Virginia, °989.

