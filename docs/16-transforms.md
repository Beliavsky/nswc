[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-317"></a>
## Transforms

<small>Original source: [View scanned PDF page 317](../scans/page_0317.png)</small>

<a id="topic-317-01"></a>
### Inversion Of The Laplace Transform

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [`L82267`](../source_parts/nswc_part_08.f90#L8178) |


Let f(t) be a complex-valued function that is continuous for t > 0 except possibly at a countable set of values t, having no finite limit points. Then for complex z the Laplace transform F(z) of f(t) is defined by

F(z) = i e** f(t) dt

when the integral converges. If the integral converges for Re(z) > c but does not exist for Re(z) < c, then c is called the abscissa of convergence of F(z). If [5° |f(t}le~* dt < co for some real constant a, then F(z) is analytic for all z where Re(z) > a. Also, for any point t for which f(i) is continuous and sufficiently well-behaved, the value f(t) can be obtained from F by the inversion formula

1 a+tT

{i =— li eR(Ad\ (f= V-1)

\- li Qn T-+00 awT

for any a > a. If f(t) is real for t > 0, then F(z) = F(Z). Given a transform F(z) where F(z) = F(z), then the following subroutine is available for computing f(t) for t > 0.

```fortran
CALL LAINV(MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR)
```

Ty is assumed that F(z) = F(z). The argument FUN is the name of a user defined subroutine for computing F(z). FUN has the format: CALL FUN(z, y, A, B) A and B are variables. For real arguments z and y, A and B are assigned the values A = Re[F(x + iy)] and B = Im[F (zc + ty)]. FUN must be declared in the calling program to be of type EXTERNAL.

IERR is a variable that is used both for input and output purposes. If TERR > 0 on input then it is assumed that the abscissa of convergence is known and that ¢ = the abscissa of convergence. Otherwise, if IERR< © then the abscissa of convergence must be computed. In this case, c is a variable. LAINV sets c to the value that is obtained for the abscissa of convergence.

MO is an integer which specifies the search procedure to be used for finding the abscissa of convergence c when TERR < 0 on input. A one-pass procedure is employed when MO # 0, and a two-pass procedure when MO =: 0. Normally, the one-pass procedure should be used. However, if all the singularities of F(z) are known to be real, then the two-pass procedure (MQ == 0) will be more efficient.

It is assumed that t > O and that Y is a variable. When LAINV is called ¥ is set to the value obtained for f(£).

AERR and RERR are the absolute and relative error tolerances to be used in computing

M(t) (AERR > 0 and RERR > 0). If one wants accuracy to k significant digits then set RERR -- i0°*. WRERR | 0 then it is assumed that f(t) is to be computed to machine


<small>Original source: [View scanned PDF page 318](../scans/page_0318.png)</small>

accuracy. LAINV attempts to find a value Y which satisfies |Y — f]| < max{ AEFRR,RERR-

f(t) }.

ERROR and NUM are variables that are set by the routine. When LAINV terminates, ERROR is a rough estimate of the absolute error |¥ — f(t}| and NUM is the number of calls that were made to the subroutine FUN.

When LAINV terminates, IERR reports the status of the results. IERR is assigned one of the following values:

IERR = 0 Y was obtained to the desired accuracy.

JERR = 1 Y was obtained, but it may not be accurate because of inaccuracy in the computation of c. This setting occurs only when IERR < 0 on input.

TERR = 2 Y could not be obtained, possibly because too much accuracy was requested. Increase AERR and RERR, and rerun the problem.

IERR = 3 Y could not be obtained, possibly because of inaccuracy in the computation of c or too much accuracy was requested. Increase AERR and KERR, and rerun the problem. This setting occurs only when IERR < 0 on input.

IERR = 4 (Input error) The argument ¢ is not positive. Y and ERROR are assigned the values 0 and 1.

```text
IERR = 5 The abscissa of convergence c could not be found in the interval
[-10*, 104]. Y, c, and ERROR are assigned the values 0, 0, and
1. This setting occurs only when IERR < 0 on input.
```

JERR = 6 The argument ¢ 1s too large for f(t) to be computed. Y and ERROR are assigned the values O and t.

**Remarks.**

```text
(1) Accuracy decreases when ¢ is near a discontinuity of f(t).
(2) The calculation may lose accuracy or fail when F(t) is oscillatory.
```

**Algorithm.** Given c, f(#) is computed by a modification of the subroutine DLAINV developed by R. Piessens and R. Huysmans, where the real Wynn ¢-algorithm has been replaced with the complex Wynn ¢-algorithm.

When JERR < 0, ¢ is calculated by the subroutine ABCGN or the subroutine AB- CONT. In ABCON, which is a two-pass search procedure, the abscissa z, of the rightmost.

singularity in the strip ~104 < x < 10%, |y| < .O1 is first determined. Then the abscissa of the rightmost singularity in the half-plane Re(z) > 21 18 found. In ABCONL these calculations are cornb‘ned into a single-pass procedure.

In ABCON and ABCONI], the function F(z)/(z~ 21-4 1)? is integrated along paths Cy and Cy defined as follows: C) is the straight line segment from (2,,0) te (zy, 01), followed by the straight line segment from (xy, 01) to (co,.01), and C’y is the straight line segment from (21,00) to (x;,0), followed by the straight line segment from (71,6) to (00,0). ‘The integral along Cy vanishes if no singularity lies to the right of ry in the strip fy} OF, and the integral along (2 vanishes if no singularity tes im Re(e) = ay. Otherwise, these

integrals are nonzero in most applications. Siipson’s rule suffices for integrating along the


<small>Original source: [View scanned PDF page 319](../scans/page_0319.png)</small>

finite line segment from (21,0) to (zy, 01).

**Example.** Let F(z) = 1/(1+ 27), in which case f(t) = sint. The following code may be used for computing f(t) at ¢ = 1,1.1,1.2,...,1.9 and storing the results in the array W.

REAL W(10) EXTERNAL FT

AERR. = 1.E-30

RERR = 1.E-12

IERR = --1

T=10

DO 101 = 1,10 CALL LAINV (1, FT, T, AERR, RERR, W(i), C, ERR, N, IERR) IF (IERR .GT. 1) STOP T=T+01

10 CONTINUE

Here FT may be defined by:

SUBROUTINE FT(X, Y, A, B) COMPLEX Z,W

‘?)

Z = CMPLX(X,Y)

```text
W = 1.0/(1.0 + Z++2)
A = RWAL{W)
```

B:= AIMAG(W) RETURN

DND

**Programming.** LAINV employs the subroutines ABCON, ABCONI, SRCH, ACOND, XCOND, LAINV1, CQEXT, QAG/1, QAGIEI, QELG, QK15/1, @PSRYT, CDIVID, CREC and functions ACONDF, ACONDG, XCONDX, XCONDY, SPMPAR, EXPARG. LAINV and ARCON were written by Andrew H. van Tuy! (NSWC) and modified by A.H. Morris. ABCONI was written by A.H. Morris. LAINV1I was written by Robert Piessens and Rudi Huysmans (University of Leuven, Herverlee, Belgium) and modified by Andrew van Tuyl. QAGIL is a modification of QAGI by Andrew van Tuyl and A.H. Morris.

Preference. Piessens, R. and Huysmans, R., “Algorithm 619. Automatic Numerical Inversion of the Laplace Transform,” ACM Trans. Math Software 10 (1084), pp. 348-353.


<small>Original source: [View scanned PDF page 320](../scans/page_0320.png)</small>

<a id="topic-320-01"></a>
### Fast Fourier Transform

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [`L84300`](../source_parts/nswc_part_08.f90#L10211) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [`L84318`](../source_parts/nswc_part_08.f90#L10229) |


Let n be a positive integer and 6; = 2xj/n for 7 = 0,1,...,n — 1. For any complex valued functions f and g defined on the points 6; let (f,g) = >I f(8;) 9(0;). Then (f,g) is an inner product when f and g are regarded as functions defined only on 6,;. Also e29(7 = 0, i, ...,2—1) form an orthogonal set of functions where each e*?* has norm \/n.' Thus, if f is 2 function that is approximated by f(#) = DI c,e'7® then each cy = 4{f (6), e7%). The

j=0 mapping f(8;) + ¢,; given by

ale

n-l - > f(O,)e7 27IR/" k=0

cj; >=

is called the discrete Fourier transform and its inverse

n—-I . f(8;) _- > cpet™ takin k=0 the inverse discrete Fourier transform. The following subroutines are available for computing these transforms.

```fortran
CALL FFT(C, N, ISN, IERR)
CALL FFT1(A, B, N, ISN, IERR)
```

Let c; = a, +1b,(7 = 0,1, ...,n - 1) be the data to be transformed. If FFT is called then C is a complex array containing ¢o,¢1,..-,¢n—1 (where C(j + 1) = c,; for 7 < n). Otherwise, if FFT1 is called then A and B are real arrays containing ao,4,, .-.,;@,—4 and bo, b1, ...,b,_1 respectively.

The argument @ may have the values 1 or —1, and IERR is a variable. When FFT or FFT I is called, if there are no input errors then IERR is set. to 0 and

n-l tik a... 5 Qn Cy, = Dp, cperry in k=0

is computed. The results é; -- @, | 6, replace the original data c, = a, +46; in C (or A

and B).

Restrictions on the argument n. When FFT and FFT! are called, n is factored by the routine into its prime factors. It is assumed that the largest prime factor of nis < 28. If n~ p?’n where n is the square free portion of n, then it is further assumed that n < 210 whenever nis a product of two or more primes.

Throughout this section a / E.


<small>Original source: [View scanned PDF page 321](../scans/page_0321.png)</small>

**Error Return.** If an input error is detected then IERR is set as follows:

IERR =1 ifn <1,

IERR = 2 if n has too many factors.

IERR = 3 if n has a prime factor greater than 23 or the square free portion of n is greater than 210,

IERR = 4 if @4 41.

The setting IERR = 2 can occur only when n > 4251528.

**Remark.** The complex array C is interpreted by FFT as a real array of dimension 2n. If this association is not permitted by the FORTRAN being employed then use FFT'1.

**Programming.** FFT and FFT! are interface routines for the subroutine SFFT, which was written by Richard C. Singleton (Stanford Research Institute).

**Reference.** Singleton, R. C., “An Algorithm for Computing the Mixed Radix Fast Fourier Transform,” IEEE Trans. Audio and Electroacoustics, vol. AU-17T (1969), pp. 93-103.


<small>Original source: [View scanned PDF page 322](../scans/page_0322.png)</small>

<a id="topic-322-01"></a>
### Multivariate Fast Fourier Transform

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [`L84331`](../source_parts/nswc_part_08.f90#L10242) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [`L84370`](../source_parts/nswc_part_08.f90#L10281) |


```text
Let nj, ...,%m be positive integers. For any J = (j1, ---:Jm) Where j, =0,...,n,—1
(v = 1,...,m) let 6; denote the point (2*j,/ny, ..+,2%jm/nm). Also, for any complex
valued functions f and g defined on the points 6, let (f,g) = Dy f(8s) 9(07). Then (f,9)
is an inner product when f and g are regarded as functions defined only on 97. Also the
functions $;(0) = exp(ij,6')---exp(iz,9”) form an orthogonal set where each gy has the
norm \/nj-"-fim.’ Thus, if f is a function that is approximated by f = Dycy¢y then each
cy = al (f,¢7). The mapping f(¢7) ++ cy given by
```

ey =-+— oy S(O) exp(—2atj, ki /ny) +--+ exp(—2atjnkm/Mm)

nyo Nm

is called the discrete multivariate Fourier transform and its inverse f(87) = ox ew exp(2at71ky/ny,)+-- exp(27tjmkm /Nm)

the inverse discrete multivariate Fourier transform. The sums Dx are for all K = (ky, ...,4m) where ky = 0,1,...,n, -1(v = 1, ...,m). The following subroutines are available for computing these transforms.

```fortran
CALL MFFT(C, N, NDIM, ISN, IERR)
CALL MFFT1(A, B, N, NDIM, ISN, IERR)
```

Let cy = ay + 1b, be the data to be transformed where J = (g:, ---)Jm) for gp = 0,1,...,.2, -1 (v = 1,...,m). If MFFT is called then C is a 1-dimensional complex array containing the values cy where cy = C(1+ 9, +jony t+ jgnyng +--+ + ImM1°°* m1). Otherwise, if MFFT1 is called then A and B are 1-dimensional real arrays containing the data ay and by respectively.

**Note.** If MFFT is used and m = 2 or 3, then instead of having to store the m-dimensional data cy into a 1-dimensional array C, the data may be stored in C where C is defined to be an m-dimensional array. If m= 2 then C may be declared to be of dimension ny X na, in which case C(j: + 1,972 + 1) = cy for all J ~ (51,32). Similarly, if m = 3 then C may be declared to be of dimension n, x ng x ns, in which case Cait byge + 1,93 + 1) = cy for all J > (91, 92,3). Similar comments hold for A and B if MFETL is employed.

N is an array containing the integers nj, ...,n,,. The argument @ may have the values 1 and -1, and IERR is a variable. When MFFT or MFFT' is called, if there are no input errors then TERR is set to 0 and the transform

6, > Don crexp(2a lrg ky/ny) -- exp(27bt jn ky /tm )

is computed. The results éy ~ a) | tb) replace the original data cy ay} tb, in Co (or A and #3).

‘Throughout this section + Land @ (6), 22,0) denotes an arbitrary point.


<small>Original source: [View scanned PDF page 323](../scans/page_0323.png)</small>

Restrictions on the arguments nj, ...,%m. When MFFT and MFFT1 are called, each n, is factored by the routine into its prime factors. It is assumed that the largest prime factor of n, is < 23. Ifn, = pwn, where fi, is the square free portion of n,, then it is further assumed that fi, < 210 whenever ni, is a product of two or more primes.

**Error Return.** If an input error is detected then IERR is set as follows:

IERR = 1 if some n, < 1.

IERR = 2 if some n, has too many factors.

[ERR = 3 if some n, has a prime factor greater than 23 or the square free portion of some n, is greater than 210.

IERR = 4 if 24 +1.

IERR = 5 if nm < 0.

The setting JERR == 2 can occur only when some n, > 4251528.

**Remark.** The complex array C of dimension ny--+n,, is interpreted by MFFT as a real array of dimension 2n,--+n,,. If this association is not permitted by the FORTRAN being employed then use MFFTi.

**Programming.** MFFT and MFFT1 are interface routines for the subroutine SFFT, which was written by Richard C. Singleton (Stanford Research Institute).

**Reference.** Singleton, R. C., “An Algorithm for Computing the Mixed Radix Fast Fourier Transform,” IEEE Trans. Audio and Electroacoustics, vol. AU-17 (1969), pp 93-103.


<small>Original source: [View scanned PDF page 324](../scans/page_0324.png)</small>

<a id="topic-324-01"></a>
### Discrete Cosine And Sine Transforms

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [`L85024`](../source_parts/nswc_part_09.f90#L1) |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [`L85091`](../source_parts/nswc_part_09.f90#L68) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [`L85187`](../source_parts/nswc_part_09.f90#L164) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [`L85289`](../source_parts/nswc_part_09.f90#L266) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [`L85360`](../source_parts/nswc_part_09.f90#L337) |


Let n be a positive integer and 0, = (v +1/2)x/n for vy = 0,i,...,2-—1. For any “a real valued functions f and g defined on the points 6, let (f,g) = p> f(8.) 9(6.). Then (f,g) is an inner product when f{ and g are regarded as functions defined only on 6,.

```text
Also cos j@ (7 = 0,1,...,n — 1) form an orthogonal set of functions where cos j@ has
norm 2 when j = 0 and norm \/n/2 when j > 1. Thus, if f is a function that is
```

n-1 approximated by f(9) = ao + 25> a;cos 7@ then each a; = +(f(6),cos 70). The mapmal

3 ping f(0,) ++ a; is called the discrete cosine transform and its inverse a; ‘+ f{(6,} the inverse discrete cosine transform.

Alternatively, the functions sin 7@ for 7 = 1, ...,n also form an orthogonal set where sin 7? has norm /n/2 when Z < rand norm Ja when jzn. Thus, if f is » function that

is approximated by f(0) = 2 by by sin 3@ + 5, sin n@ then each 6; = +(f(),sin j9). The

mapping {(@,) by i is called ‘the discrete sine transform and its inverse b; +> f(0,) the inverse discrete sine transform.

The subroutines COSQB and COSQF are available for computing the discrete cosine transform and its inverse, and the subroutines SINQB and SINQF are available for computing the discrete sine transform and its inverse. The subroutine COSQI provides information that is needed for the cosine and sine transform routines.

```fortran
CALL COSQI(N, WSAVE)
```

WK is an array of dimension 3n 4+ 15 or larger that is a work space for the routines COSQB, COSQF, SINQB, and SINQF. COSQI stores in WK information needed for the fast Fourier computation of the discrete cosine and sine transforms and their inverses. A preliminary call must be made to COSQI before COSQB, COSQF, SINQB, and SINQF can be used. After this preliminary call, COSQ!] need only be recalled when n is modified.

**Programming.** COSQ! employs the subroutines REF TL and REETHL. These routines were written by Pau) N. Swarztrauber (National Center for Atmospheric Research, Boulder,

Colorado). CALL COSQB(n, X, WK)

Nos an array of dimension sm oor larger. On input it is assumed that X contains the data f(9o), f(@1), .. f{(8n aj}. When COSQB is called, 4na, is computed and stored in X(7) f)fory¢ O,b,.. oye oF.

Wits an array of dimension $n ¢ 15 or larger that is a work space for the routine. WR must be set up by Gis routine COSQI before COSQB can be used.

ALO


<small>Original source: [View scanned PDF page 325](../scans/page_0325.png)</small>

**Programming.** COSQB employs the subroutines COSB1, RFFTB, RFFTB1, RADB2, RADB3, RADB4, RADBS, and RADBG. These routines were written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

```fortran
CALL COSQF(N, X, WSAVE)
```

X is an array of dimension n or larger. On input it is assumed that X contains the data a9, 41, ...,@,-1. When COSQF is called, f(9,) is computed and stored in X({v + 1) for vy =0,1,...,n -1.

WK is an array of dimension 3n + 15 or larger that is a work space for the routine. WK must be set up by the routine COSQI before COSQF can be used.

**Example.** Assume that X contains the data f(90), ...,f(@,-1). When the statements CALL COSQI(n,WK) CALL COSQB(n, X,WK) CALL COSQF(n, X,WK) are called, COSQB stores 4nao, ...,4na,_1 in X and COSQF then sets X{v+1) = 4nf(@_) for vy = 0,1,...,n — 1. Thus, the terms of the original sequence X are multiplied by 4n.

**Programming.** COSQF employs the subroutines COSQF1, RFFTF, RFFTF1, RADF2, RADF3, RADF4, RADF5, and RADFG. These routines were written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

```fortran
CALL SINQB(N, X, WSAVE)
```

X is an array of dimension n or larger. On input it is assumed that X contains the data f(90), ...,f(@n—1). When SINQB is called, 4nb, is computed and stored in X(j) for geel,...,n.

WK is an array of dimension 3n-| 15 or larger that is a work space for the routine. WK must be set up by the routine COSQI before SINQB can be used.

**Programming.** SiNQB calls the subroutine COSQB. SINQB was written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

```fortran
CALL SINQF(N, X, WSAVE)
```

X is an array of dimension mn or larger. On input it is assumed that XY contains the data 6;,...,6,. When SINQF is called, f(0.) is computed and stored in X(v + 1) for

yo O,f, ee. ym oT.

WK is an array of dimension Gn + 15 or larger that is a work space for the routine, WK must be set up by the routine COSQI before SINQF can be used.

**Example.** Assume that X contains the data 6,,... 26,0 When the statements CALL COSQI(n, WK) CALL SINQF(n, 8 WK) CALL SINQB(n, Y¥ WH)


<small>Original source: [View scanned PDF page 326](../scans/page_0326.png)</small>

```text
are called, SINQF stores f(@),...,f(@,-1) in X and SINQB then sets X(j) = 4nb, for
j=1,...,n. Thus, the terms of the original sequence X are multiplied by 4n.
```

**Programming.** SINQF calls the subroutine COSQF. The routine SINQF was written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

AST

