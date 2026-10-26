[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-110"></a>
## Polynomials

<small>Original source: [View scanned PDF page 110](../scans/page_0110.png)</small>

<a id="topic-110-01"></a>
### Copying Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [`L28427`](../source_parts/nswc_part_03.f90#L7264) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [`L28454`](../source_parts/nswc_part_03.f90#L7291) |


m--1 . If p(x) = > a;2? and the coefficients a; are stored in an array A, then the following j=0 subroutines are available fer copying the first n coefficients a, into an array B.

```fortran
CALL PLCOPY(A, KA, M, B, KB, N)
CALL DPCOPY(A, KA, M, B, KB, N)
```

A and & are arrays. PLCOPY is used if A and B are real arrays, and DPCOPY is used if A and B are double precision arrays.

The arguments m,n, ka, kb are positive integers. The coefficients a; are ¢ sumed to be stored in A where A(1+7-ku) = a; for 7 = 0,1,...,m-- 1. The routine stores the first n coefficients a; in B where B(1 + 7-kb) = a, for 7 =0,1,...,n—-1.

Note If n>m then B(1+7-kb) = 0 for 7 > m.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 111](../scans/page_0111.png)</small>

<a id="topic-111-01"></a>
### Addition Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28481`](../source_parts/nswc_part_03.f90#L7318) |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28504`](../source_parts/nswc_part_03.f90#L7341) |


```text
ted ; mot . . ; .
If p(x) = 24 a;z? and q(x) = ds b;27 then the following subroutines are available for
=C y=
computing the first n coefficients of the polynomial p(z) 4- q(x) = ar cx),
```

```fortran
CALL PADD(A, KA, L, B, KB, M, C, KC, N)
CALL DPADD(A, KA, L, B, KB, M, C, KC, N)
```

A, B and C are arrays. PADD is used if A, B and C are real arrays and DPADD is used if A, B and C are double precision arrays.

The arguments ¢,m,n,ka,kb,ke are positive integers. The coefficients a; and 5; are assumed to be stored in A and B where A(l+j-ka} =a; (7 =0,1,...,@~1) B(L+j-kb) = 6; (7 =0,1,...,m~1). The routine stores the first n coefficients c; of p(x) + q(x) in C where C(1 +-j-ke) = cy for jJ=O0,1,...,n-1.

**Remarks.** The array C' nay begin in the same location as A or B. If C begins in the same location as A then it is assumed that ke =: ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that ke = kb. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 112](../scans/page_0112.png)</small>

<a id="topic-112-01"></a>
### Subtraction Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28527`](../source_parts/nswc_part_03.f90#L7364) |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28550`](../source_parts/nswc_part_03.f90#L7387) |


£-1 m-- 1 : If p(z) = 33 a;: q{z) == 33 6,2? then the following subroutines are available for j=0 pd computing the first, ; ients of the polynomial p(x) ~ q(x) = 30, ¢;27. CALL PSU'S) ka, ¢, B, kb, m,C, ke, n) CALL DPSWUE I A, ka, é, Bj kb,m,C, ke, n) A, B and C are ari: PSUBT is used if A, B and C are real arrays and DPSUBT is used if A, B and C are! ble precision arrays. The arguments f, ka,kb,ke are positive integers. The coefficients a; and 6; are assumed to be stored nd B where A(l + 7+ka} (7 =0,1,...,8- 1) B(1 + 7-kb) (7 =0,1,...,m—1).

```text
The routine stores the si 1 coefficients c, of p(x) — q(z) in C where C(1 + y-ke) == ¢; for
j=0,1,...,n-1.
```

**Remarks.** The array C may begin in the same location as A cr B. If C begins in the same location as A then it is assumed that kc = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that kc = kb. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. More's.


<small>Original source: [View scanned PDF page 113](../scans/page_0113.png)</small>

<a id="topic-113-01"></a>
### Multiplication Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28573`](../source_parts/nswc_part_03.f90#L7410) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28615`](../source_parts/nswc_part_03.f90#L7452) |


t—1 : m—1 , If p(z) = 30 ayx? and g(x) = > 6,27 then the following subroutines are available for gr g=0

computing the first n coefficients of the polynomial p(x)q(z) = Dy c,x).

```fortran
CALL PMULT(A, KA, L, B, KB, M, C, KC, N)
CALL DPMULT(A, KA, L, B, KB, M, C, KC, N)
```

A, B and C are arrays. PMULT is used if A, B and C are real arrays and DPMULT is used if A, B and C are double precision arrays.

The arguments £,m,n,ka,kb,ke are positive integers. The coefficients a; and b, are assumed to be stored in A and B where A(l+j-ka} =a; (f= 0,1,...,€-1) BIL + j+kb) = 6; (7 =0,1,...,m— 1). The routine stores the first n coefficients cy of p(z)q(x) in C where C(1 + j-ke) = cy for g=0,1,...,2-1.

**Remarks.** It is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 114](../scans/page_0114.png)</small>

<a id="topic-114-01"></a>
### Division Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [`L28657`](../source_parts/nswc_part_03.f90#L7494) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [`L28715`](../source_parts/nswc_part_03.f90#L7552) |


```text
t-) ; m—J .
If p(z) = 3) a;z? and qg(z) = 35 6,27 where bo # 0, then the following subroutines
g=0 p20
are available for computing the first. n coefficients of the series p(z)/q(z) = 2, C52).
```

```fortran
CALL PDIV(A, KA, L, B, KB, M, C, KC, N, IERR)
CALL DPDIV(A, KA, L, B, KB, M, C, KC, N, IERR)
```

A, B and C are arrays. PDIV is used if A, B and C are real arrays and DPDIV is used if A, 8 and C are double precision arrays.

The arguments £,m,n,ka,kb,ke are positive integers. The coefficients a; and 5; are assumed to be: stored in A and B where A(l+jka)=a; (7 =0,1,...,0-1) B(1 + 7-kb) = b, (7 =0,1,...,m— 1). TERR is a variable. When the routine is called, if b) 4 0 then IERR is assigned the value O and the first n coefficients c; of p(x)/q(x) are stored in C where C(1 + j-ke) = c,; for 7 =O0,l,...,n-1.

**Error Return.** JERR = 1 if bp = 0. In this case, ac computation is performed. Remarks. It is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 115](../scans/page_0115.png)</small>

<a id="topic-115-01"></a>
### Real Powers Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [`L28772`](../source_parts/nswc_part_03.f90#L7609) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [`L28829`](../source_parts/nswc_part_03.f90#L7666) |


```text
m-1 :
If r is real and p(x) = $5 a;z’ where ag > Q, then the following subroutines are
g=0
available for computing the first n coefficients of the series p(x)" = ; b,x).
```

CALL PLPWR(r, A, ka, m, B, kb,n, JERR) CALL DPLPWR(r, A, ka, m, B, kb, n, JERR) A and 8 are arrays. PLPWR is used if A and B are real arrays and r a real number,

and DPLPWR is used if A and B are double precision arrays and r a double precision number,

The arguments m,n, ka, kb are positive integers. The coefficients a; are assumed to be stored in A where A(1+ j-ka) = a; for 7 = 0,1,...,m— 1. TERR is a variable. When the routine is called, if ag > 0 then IERR is assigned the value 0 and the first n coefficients b; of p(x)" are stored in B where B(1 + j-kb) = b; for j =0,1,...,n—1.

**Error Return.** IERR = 1 if ap < 0. In this case, no computation is performed.

**Remark.** It is assumed that the arrays A and B do not overlap.

**Algorithm.** If ¢ = p" then pg’ = rqp' where p’ and q’ are the derivatives of p and q. ;

Consequently, 6; = = So (ri+a—- j)a,;b;_, is used for j > 1. Also bo = a}.

340

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 116](../scans/page_0116.png)</small>

<a id="topic-116-01"></a>
### Inverses Of Power Series

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [`L28885`](../source_parts/nswc_part_03.f90#L7722) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [`L28946`](../source_parts/nswc_part_03.f90#L7783) |


Given an analytic function w = f(z) = >> ayz* where f(0) =: 0. Then the inverse i>1 function z = f~!(w) exists when a; 4 0, and f~'(w) = 3 djw*. The subroutines PINV i>

and DPINV are available for obtaining the coefficients d, when the coefficients a; are real. DPINV is a double precision routine.

```fortran
CALL PINV(A, D, N, Q)
CALL DPINV(A, D, N, Q)
```

If PINV is called then A, D, and WK are real arrays. Otherwise, if DPINV is called then A, D, and WK are double precision arrays.

It is assumed that n > 2. Ais an array containing the coefficients a;,...,a, and D is an array of dimension n. When PINV or DPINV is called, the coefficients dy, ...,d, are computed and stored in D.

WK is an array of dimension n(n + 1)/2 or larger. WK is a work space for the routine. Programmer. A. H. Morris.

**Reference.** Chang, Feng-cheng,“Power Series Unification and Reversion,” Applied Math and Computation 23 (1987), pp. 7-23.


<small>Original source: [View scanned PDF page 117](../scans/page_0117.png)</small>

<a id="topic-117-01"></a>
### Derivatives And Integrals Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [`L29007`](../source_parts/nswc_part_03.f90#L7844) |


n--} . Let f(z) = 5) ayz* be a polynomial with real coefficients a,. The polynomial can be

a0 differentiated and integrated by the following subroutine:

```fortran
CALL MPLNMV(MO, AU, NC, AC, FV)
```

A is an array containing the coefficients a, where A(t) = ay_1 fort = 1,...,n. The argument Zo is an arbitrary real number and w is a variable. MO may have the values ~1,0,1,2. When MPLNMV is called w is assigned the value:

```text
( f2f(a)dx if MO=-1
f (zo) ifMO= 0
f'(co) ifMO= 1
feo) ifMO= 2
```

if

Programmer, Allen V. Hershey.


<small>Original source: [View scanned PDF page 118](../scans/page_0118.png)</small>

<a id="topic-118-01"></a>
### Evaluation Of Chebyshev Expansions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [`L29065`](../source_parts/nswc_part_03.f90#L7902) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [`L29093`](../source_parts/nswc_part_03.f90#L7930) |


```text
for any complex number z and integer n = 0,1, ... let
To(z) =3 1, Ti(z) =z
```

Ta42(2) = 22zTa4i(z) — Tr(z).

Then 7,(z) is a polynomial of degree n having the leading coefficient 2"~'! when n > 1.

Also Tn(t) =: cos(n@) when t = cos0(G < 0 < m), so that |7),{t)| < 1 for real t where

|t} < 1. The polynomials 7,,{z) are called the Chebyshev polynomials (of the first kind). If -1

f(z) = ao/2+ >> a;T,(x) where a, is real, then the following functions are available for computing f(z) when z is real. CSEVL(z, A,n)

It is assumed that n > } and that A is an array containing ao, 1, ...,@,—1 where A(t) == ay-1(¢ = 1,...,n). Then CSEVL(2, A,n) == f(z) for any real z.

**Programmer.** A. H. Morris. DCSEVL(z, A,n) It is assumed that n > 1 and A is a double precision array containing @9,41, ...,@n—1 where A(i) = a;3(f = 1, ...,n). Then for any double precision value x, DCSEVL(z, A,n)

is the double precision value of f(z).

**Remark.** DCSEVL must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 119](../scans/page_0119.png)</small>

<a id="topic-119-01"></a>
### Lagrange Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [`L29120`](../source_parts/nswc_part_03.f90#L7957) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [`L29146`](../source_parts/nswc_part_03.f90#L7983) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [`L29265`](../source_parts/nswc_part_03.f90#L8102) |


Let ay, ...,@n be n distinct real numbers. Then the t** Lagrange polynomial is defined by

(a; — a4) (a; ~ a2) +++ (ay ~ as—1) (ay — as4i) +++ (as — Qn)

```text
for? = 1,2, ...,n. The Lagrange polynomials have the property that ¢;(a,) = 1,¢,;(a;) = 0
n
for 7 #1, and p(x) = >> p(a,)¢,(zr) for any polynomial of degree n ~— 1. For convenience,
t=1
```

dy = (a; — a1) (a; ~ a2) +++ (ay — ag-—1) (ay — spi) +++ (ay — an) is called the normalization divisor of ¢,(r). The following subroutines are available for

computing the Lagrange polynomials and their normalization divisors.

```fortran
CALL LGRNGN(AU, NA, AN)
```

A and D are arrays of dimension n. The arguments a), ...,@, are given in the array A. The normalization divisors d,, ...,d, are computed by the routine and stored in D.

**Programmer.** Allen V. Hershey.

```fortran
CALL LGRNGV(MO, NA, QU, AU, AN, FF, DF, SF)
```

A and D are arrays of dimension n. The arguments a;,...,@, are given in A and the normalization divisors d,,...,d¢, are given in D. The argument zo is an arbitrary real number and F,DF,ODF are arrays of dimension n.

The argument MO may take the values 0,1,2. If MO = 0 then the polynomials ¢,(z) are evaluated at rq and the values ¢,({zo) stored in F. If MO = 1 then the function ¢,(z) and its derivative $/(z) are computed at zo. In this case, ¢,{r0) is stored in F(1) and ¢{ (zo) is stored in DF(t) for s = 1,...,n. Similarly, if MO = 2 then the function ¢,(2) and its first and second derivatives are computed at x9. The values ¢,(zo) are stored in F, the first derivatives are stored in DF, and the second derivatives are stored in DDF.

**Note.** If MO = O then DF and DDF are ignored by the routine. Similarly, if MO. 1 then DDF is ignored.

**Programmer.** Allen V. Hershey.

```fortran
CALL LGRNGX(AU, NA, AC)
```

Ais an array of dimension n and © an array of dimension n»® (n } 1}. The arguments

y | & @y,...,@, are given in A. The purpose of the routine is to compute the coefficients ¢,, of the Lagrange polynomials

mood ™ : i & Bt) do eerie”. k oO


<small>Original source: [View scanned PDF page 120](../scans/page_0120.png)</small>

When LGRNGX is called, the coefficients of $;(z) are stored in the j** column of C for j <n. Also, the first n coefficients of the polynomial

g(x) = (2 — a1) +++ (2 - ay) are stored in the (n + 1)** column of C.

**Programmer.** Allen V. Hershey.


<small>Original source: [View scanned PDF page 121](../scans/page_0121.png)</small>

<a id="topic-121-01"></a>
### Orthogonal Polynomials On Finite Sets

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [`L29318`](../source_parts/nswc_part_03.f90#L8155) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [`L29400`](../source_parts/nswc_part_03.f90#L8237) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [`L29458`](../source_parts/nswc_part_03.f90#L8295) |


Let uz, ...,U, be n distinct real numbers. For any real-valued functions ‘,g defined

a

```text
on the points u, let (f,g) = 35 f(us)g(us). Then (f,g) is an inner product when f and
t=1
```

g are regarded as functions defined only on u;. Thus, an orthonormal set of polynomials

{¢0, 1, --.,¢n—1} exists where the degree of ¢; 18 7 for 7 < n. The polynomials ¢, are defined recursively by

```text
1
oy4i1(u) = a. [(u ~ b;)6;(u) — a;-.16;-1(u)]
where a; = ($541, u¢;) and 6; = (¢;,u¢,). Here it is assumed that ¢.; = a_, = 0 and
do(u) = 1/\/n. The following subroutines are available for computing these polynomials.
```

```fortran
CALL ORTHOS(AU, MA, AA, NA, AR)
```

U is an array containing the values u,,...,u, and m is an integer such that 1 < m <n. P is an array of dimension n x m and R an array of dimension 2m — 2. When OQRTHOS is called, ¢;~1(u,;) is computed and stored in P(t,7) fort <n and j < m. Also the coefficients ao, bg, 41,6), ...,dm—2,6m-—2 are stored in R.

**Programmer.** Allen V. Hershey. CALL ORTHOV(MO,n, u, Ry m, F,DF,DDF) The argument u is a real number and m an integer such that 1 <m <n. BR is an

array containing the coefficients ag,6y, 4), 6), ...,@m-2,bm. 2 and PDE DDF are arrays of

dimension ma.

MO may take the values 0,1,2. If MO O then @o,¢@1,-.-.¢m . are evaluated at u and the values ¢, 1(u) stored in F. If MO I then ¢, 1 and its derivative @, are computed at u. In this case, 6, y(t) is stored in P(g) and ob (4) Is stored in DE() for y 1, ...,m. Similarly, if MO 2 then d, , and its first and second derivatives are evaluated at u. The values @, (1) are stored in F', the first derivatives are stored an DF,

and the second derivatives are stored in DDE.

**Note.** [fMO | O then DF and DDE are ignored by the routine. Similarly, if MO 1 then DDF is ignored.

**Programmer.** Allen Vo Hershey

```fortran
CALL ORTHOX(NA, AR, NC, AC)
```

The argument sais an integer such that bosom: on Alois an array containing, Clie

coefficients du,bo,ay, by, yn 2.4), pg and Coan array of dimension vs ra The purpose

