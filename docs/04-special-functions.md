[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-046"></a>
## Special Functions

<small>Original source: [View scanned PDF page 46](../scans/page_0046.png)</small>

<a id="topic-046-01"></a>
### Error Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [`L5510`](../source_parts/nswc_part_01.f#L5510) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [`L5661`](../source_parts/nswc_part_01.f#L5661) |
| `ERF` | `REAL FUNCTION` | `X` | [`L5834`](../source_parts/nswc_part_01.f#L5834) |
| `ERFC` | `REAL FUNCTION` | `X` | [`L5893`](../source_parts/nswc_part_01.f#L5893) |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [`L5975`](../source_parts/nswc_part_01.f#L5975) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [`L6066`](../source_parts/nswc_part_01.f#L6066) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [`L6343`](../source_parts/nswc_part_01.f#L6343) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [`L6761`](../source_parts/nswc_part_01.f#L6761) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [`L6817`](../source_parts/nswc_part_01.f#L6817) |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [`L6879`](../source_parts/nswc_part_01.f#L6879) |


For any complex z the error function is defined by

ents) = a foe

and its complement by erfc(z) = 1 — erf(z). The subroutines CERF, CERFC, DCERF, and DCERFC are available for computing erf(z) and erfc(z) when z is complex, and the functions ERF, ERFC, ERFC1, DERF, DERFC, and DERFC1 are available for computing erf(z) and erfc(z) when z is real. DCERF, DCERFC, DERF, DERFC, and DERFC1 are double precision routines.

```fortran
CALL CERF(MO, Z, W)
```

MO is an integer, z a complex number, and w a complex variable. When CERF is called, w is assigned the value erf(z) if MO = O and the value erfc(z) if MO # 0.

**Algorithm.** For z= 2+ ty where x > 0, if z satisfies |z| < 1 or both of the inequalities 1 < |z| < V38 and 2: x? — y? + 06427y* < 0, then the series

)" gittl

(1) erf(z => es ath yi)

is used. If 1 < |z| < 38 and 2? — y? + .064z7y? > 0 then

~ 3?

(2) erf(2) = 1 - “T- vats

is employed. A, and ry, are the poles and residues of the rational function approximation for the complex Fresnel integral Et) given in the relerence. The error function is related to E(z) by erf(z) = 1 ~¢/2E(—z?) for jarg(z)| < /2. If |z| > 38 and x > .O1 then erf(z) is computed by the asymptotic expansion erf(z) = 1 — W(z) where

ye _ 1+3++-(2n~ 1) (3) YO) = Fels t LCD ae |

```text
Otherwise, if |z| > V/38 and 0 < x < .01 then erf(z) = —1(z) is employed. When x < 0
then the relation erf(--z) == —erf(z) is applied.
```

**Programming.** Written by Allen V. Hershey and A. H. Morris.

**Reference.** Hershey, A. ., Approximation of Functiona by Sets of Poles, Report TR- 2564, Naval Weapons Labora Dahlgren, Virginia, 1971.


<small>Original source: [View scanned PDF page 47](../scans/page_0047.png)</small>

```fortran
CALL CERFC(MO, Z, W)
```

MO is an integer, z a complex number, and w a complex variable. When CERFC is called, w is assigned the value erfc(z) if MO = 0 or Re(z) < 0. Otherwise, if MO # 0 and Re(z) > 0 then w is assigned the value e*erfc(z).

**Precision.** For MO # 0, Re(w) and Im(w) are accurate to within 1 unit of the 12°” significant digit when |Re(w)| > 10~28° and Im(w) # 0.

**Programming.** CERFC employs the subroutine CREC and functions EXPARG and IPM- PAR. CERFC was written by Allen V. Hershey and A. H. Morris.

**Reference.** Hershey, A. V, Approzimation of Functions by Sets of Polea, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.

ERF(z) ERF(2) = erf(x) for any real z. Precision. ERF(z) is accurate to within 2 units of the 14" significant digit for x # 0. Programmer. A. H. Morris

**Reference.** Cody, W. J., “Rational Chebyshev Approximations tor the Error Function,” Math Comp. 23 (1969), pp. 631-637.

ERFC(z) ERFC(z) = erfc(z) for any rea! z.

**Precision.** If « < 3 then ERFC(z) is accurate to within 2 units of the 14*” significant digit. Otherwise, if z > 3 then ERFC(z) is accurate to within 4 units of the 14'” significant digit when ERFC(2) # 0.

**Programming.** ERFC employs the functions EXPARG and IPMPAR. ERFC was written by A. H. Morris.

**Reference.** Cody, W. J., “Rational Chebyshev Approximations for the Error Function,” Math Comp. 23 (1969), pp. 631-637.

```fortran
ERFC1(IND, X)
```

IND is an integer and z a real number. ERFCI{IND,z) = erfc(z) when [ND = 0, and ERFCL(IND,z) = e”erfc(z) when IND # 0. Precision. If z < 3 then ERFC1(0,z) is accurate to within 2 units of the 14" significant digit. Otherwise, if x > 3 then ERFC1(0,z) is accurate to within 4 units of the 14¢*

significant digit when ERFCI(G,z) 4 0. If IND # O then ERFCI(IND,z) is accurate to


<small>Original source: [View scanned PDF page 48](../scans/page_0048.png)</small>

within 2 units of the 14** significant digit for z > —1.

**Programming.** ERFC1 employs the functions EXPARG and IPMPAR. ERFC1 was written by A. H. Morris.

**Reference.** Cody, W. J., “Rational Chebyshev Approximations for the Error Function,” Math Comp. 23 (1969), pp. 631-637.

```fortran
CALL DCERF(MO, Z, W)
```

MO is an integer, and Z and W are double precision arrays of dimension 2. It is assumed that Z(1) and Z(2) are the real and imaginary parts of a complex number z. If MO = 0 then the double precision value for w = erf(z) is computed, and if MO # 0 then the double precision value for w = erfc(z) is computed. W(1) and W(2) contain the real and imaginary parts of w, respectively.

**Algorithm.** For z = z+ ty where zx > 0, if |z| < 1 then (1) is used, and if |z — 2| < 1 and x < 2 then the Taylor series

(4) exfe(z) = erfola) + Jaen SS (1) Hnalaj(e—a)"/nt (a= 2)

Fe

is employed. Here H,(a) are the Hermite polynomials. If 1 < |z| < 2.5 then (4) and the Pade approximation A,(z?)/Bp,(z?) for /7(2z)~4e* erf(z) are used where

```text
Ap(z)=1  Ai(z)=1+ 42
3o(z)=1 By(z)=1~ 2z
```

(5)

and A, and B,, satisfy

22 4n{4n + 2)2?

(4n + 1)(4n +5) Br(z) + (4n — 1)(4n + 1)#(4n + 3)

(6) Bn+ilz) = Bn.-1(2)

(see pp. 191,192, and 422 of the reference). Also, if 2.5 < |z| < 12 then A,(z*)/B,(z?) and the Pade approximation G,,(z?)/H,»(z?) for \/ze* erfc(z) are employed where

Golz)=1 Gy(z)=24+ 22

(7) Ho(z)=1 Hy(z)=3+2z

and G,, and H,, satisfy

(8) Hygi(z) = (22 + 4n + 3) i, (z) ~ 2n(2n + 1) Hy-1(z)

(see pp. 201 and 422 of the reference). Otherwise, if |z| > 12 and x > .OL then the asymptotic expansion erfc(z) = w(z) is used where u(z) is given by (3). Also, if [z| > 12 and 0 < ¢ < .0} then erf(z) - ~(z) is employed. When x < 0 the relation erf(- z) -erf(z) is applied.


<small>Original source: [View scanned PDF page 49](../scans/page_0049.png)</small>

**Programming.** DCER#F calls the subroutines ERFCM2, CDIVID, and DCREC. DCERF and ERFCM2 were written by A. H. Morris. The function DPMPAR is also used.

**Reference.** Luke, Yudell L., The Special Functions and Their Approrimaitoas, Vol 2, Academic Press, New York, 1969.

```fortran
CALL DCERFC(MO, Z, W)
```

MO is an integer, and Z and W are double precision arrays of dimension 2. It is assumed that Z(1) and 27(2) are the real and imaginary parts of a complex number z. ff MO = 0 or Re(z) < 0 then the double precision value for w = erfc(z) is computed. Otherwise, if MO # 0 and Re(z) > 0 then the double precision value for w = e* erfe(z) is computed. W(1) and W’(2) contain the real and imaginary parts of w, respectively.

**Precision.** For MO # 0 and Re(z) > 0, W(1) and W(2) are accurate to within 3 units of the 26'” significant digit when W(2) 4 0.

**Programming.** DCERFC employs the subroutines ERFCM2, DCIVID, and DCREG, and functions DXPARG, DPMPAR,and IPMPAR. DCERFC and ERFCM2 were written by A. H. Morris.

```fortran
DERF(X)
```

The argument z is a double precision number. DERF(z) is the double precision value for erf(z).

**Remark.**DERF must be declared in the calling program to be of type DOUBLE PRECISION.

**Algorithm.** If jz| < 1 then the power series corresponding to the Chebyshev expansion given in the SLATEC library by Wayne Fullerton (Los Alamos) is used, and if |z| > 1 then minimax approximations are employed. The power series and minimax approximations were obtained by A. H. Morris.

**Precision.** DERF(z) is accurate to within 2 units of the 28"" significant digit for x 4 0.

**Programming.** DERF employs the function DERFCO. DERF was written by A. H. Morris. DERFC(z}

The argument x is a double precision number. DERFC(z) is the double precision value

for erfc(z).

**Remark.** DERFC must be declared in the calling program to be of type DOUBLE PRECISION.

Algorithm, If |z| < 1 then the power series corresponding to the Chebyshev expansion given in the SLATEC library by Wayne Fullerton (Los Alamos) is used. Otherwise, if 1 < jx] < 50


<small>Original source: [View scanned PDF page 50](../scans/page_0050.png)</small>

then minimax approximations are used, and if |z| > 50 then the asymptotic expansion (3) is employed. ‘Che power series and minimax approximations were obtained by A. H. Morris.

Frecision. DERFC(z) is accurate to within 2 units of the 28" significant digit for 2 < 2.

**Programming.** DERFC employs the functions DERF'CO, DXPARG, and IPMPAR. DERFC was written by A. H. Morris,

```fortran
DERFC1(IND, X)
```

IND is an integer and z a double precision number. DERFCI{IND,z) is the double precision value for erfc(z) when IND = 0, and DERFCI(IND,z) is the double precision value for e7 erfe(z) when IND £0.

**Remark.** DERFC1 must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DERFCi(IND,z) is accurate to within 2 units of the 28°" significant digit when IND = O and 2 < 2, and when IND #4 O and 2z> -1

**Programming.** DERFC1 employs the functions DERFCO, DXPARG, and IPMPAR. DERFCi was written by A. H. Morris.


<small>Original source: [View scanned PDF page 51](../scans/page_0051.png)</small>

<a id="topic-051-01"></a>
### Inverse Error Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ERFI` | `REAL FUNCTION` | `P, Q` | [`L7119`](../source_parts/nswc_part_01.f#L7119) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [`L7236`](../source_parts/nswc_part_01.f#L7236) |


For any 0 < x < 1, the following functions are available for obtaining the value w > 0 for which erf(w) = 2.

ERFi(z, y)

```text
It is assumed that z > 0, y > 0, and r+y= 1. Then ERFI(z,y) = w where w > 0
and erf(w) = x.
```

**Error Return.** ERFI(z, y) = —1 if z <0 or y < 0, and ERFI(z,y) = -2ifx+y# 1. Precision. ERFI(z, y) is accurate to within 3 units of the 14" significant digit.

**Programming.** ERFI was written by Armido R. DiDonato and modified by A. H. Morris. The function SPMPAR is used.

**Reference.** Blair, J. M., Edwards, C. A., and Johnson, J. H.,“Rational Chebyshev Approximations for the Inverse of the Error Function,” Math. Comp. 36 (1976), pp. 827-830.

```fortran
DERFI(P, Q)
```

```text
The arguments z and y are doukle precision numbers where z > 6, y > O, and x+y = 1.
DERFI(z, y) is the double precision value for w where w > 0 and erf(w) = z.
```

**Remark.** DERFI must be declared to be of type DOUBLE PRECISION in the calling program.

**Error Return.** DERFI(z,y) = —-1lif x < Oory <0, and DERFI(z,y) = -2ifz+y 1.

**Algorithm.** If « < 15/16 then an initial value for w is given Ly minimax approximations due to A. H. Morris. Otherwise, if z > 15/16 then an initial value for w is given by minimax approximations from the reference. These approximations are accurate to 17-18 digits. If inore accuracy is needed, then a single iterate of the Newton procedure for solving F(w) =: 0 is taken to obtain w to machine precision. Here

erflw) 2 if2< 3/4

F(w)} es 4 erfe(w) - y if 3/4 <2 < 15/16 Inferfe(w)} --In(y) if 2 > 15/16.

**Precision.** DERFI (2,7) is accurate to within | unit of the 27" significant digit.

**Programming.** DERFI employs the functions DERF, DERFC1, DERFCO, DXPARG, DPMPAR, and IPMPAR. DERFI was written by A. H. Morris.

**Reference.** Blair, J. M., Edwards, C. A., and Johnson, J. H.,“Rational Chebyshev Approximations for the Inverse of the Error Function,” Meth. Comp. 30 (1976), pp. 827 830.


<small>Original source: [View scanned PDF page 52](../scans/page_0052.png)</small>

<a id="topic-052-01"></a>
### Difference Of Error Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `AERF` | `REAL FUNCTION` | `X, H` | [`L7398`](../source_parts/nswc_part_01.f#L7398) |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [`L7519`](../source_parts/nswc_part_01.f#L7519) |


For any real x and h, let aerf(2,h) = erf(x+h) —erf(x~--h). Then the functions AERF and DAERF are available for computing aerf(z, A).

AERF(z, h) AERF(z,h) = aerf(z,h) for any z and A.

**Precision.** AERF(z,h) is accurate to within 6 units of the 12'" significant digit when AERF (sz, h) # 0.

**Programming.** AERF employs the functions ERF, ERFC, EPSLN, EXPARG, SPMPAR, and IPMPAR. AERF was written by Armide R. DiDonato and modified by A.H. Morris.

**Reference.** DiDonato, A.R., Signiffeant Digit Computation of the Elliptical Coverage Function, Report NSWC TR 90-513, Naval Surface Warfare Center, Dahlgren, Virginia, 1990.

```fortran
DAERF(X, H)
```

The arguments xz and h are double precision numbers. DAERF(z,h) is the double precision value for aerf(z, h).

**Remark.** DAERF must be declared to be of type DOUBLE PRECISION in the calling program.

**Programming.** DAERF employs the functions DERF, DERFC, DERFCO, DEPSLN, DX- PARG, DPMPAR, and IPMPAR. DAERF was written by Armido R. DiDonato and modified by A. H. Morris.

**Reference.** DiDonato, A.R., Significant Digit Computation of the Elliptical Coverage Function, Report NSWC TR 90-513, Naval Surface Warfare Center, Dahlgren, Virginia, 1990.


<small>Original source: [View scanned PDF page 53](../scans/page_0053.png)</small>

<a id="topic-053-01"></a>
### Normal Probability Distribution Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PNDF` | `FUNCTION` | `X, IND` | [`L7646`](../source_parts/nswc_part_01.f#L7646) |


Let $\Phi(x)$ be the standard normal cumulative distribution function,
$\overline\Phi(x)=1-\Phi(x)$ its upper-tail probability, and
$\phi(x)=(2\pi)^{-1/2}e^{-x^2/2}$ its density. The function `PNDF(X, IND)`
returns:

| Condition | `PNDF` result |
|---|---|
| `IND == 0`, `X >= -8` | $\Phi(x)$ |
| `IND == 0`, `X < -8` | $\phi(x)/\Phi(x)$ |
| `IND != 0`, `X <= 8` | $\overline\Phi(x)$ |
| `IND != 0`, `X > 8` | $\phi(x)/\overline\Phi(x)$ |

The ratios in the extreme tails are deliberate and avoid underflow of the
corresponding very small probabilities; **they are not ordinary CDF values**.
The source implements these calculations with `ERFC1`.

**Programming.** A. H. Morris. Original documentation:
[page 53](../scans/page_0053.png).


<a id="topic-054-01"></a>
### Inverse Normal Probability Distribution Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [`L7667`](../source_parts/nswc_part_01.f#L7667) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [`L7716`](../source_parts/nswc_part_01.f#L7716) |


For any real w, the normal probability distribution function P(w) (of mean 0 and variance 1) is defined by

P(w) = 0772 ge

1 w [ € V2 f and its complement by Q(w) = 1— P(w). For any 0 < p < 1 and q = 1 — p, the following subroutines are available for obtaining the value w for which P(w) = p and Q(w) = gq.

```fortran
CALL PNI(P, Q, D, W, IERR)
CALL DPNI(P, Q, D, W, IERR)
```

PNI is used when p, g, and d are real numbers and w is a real variable, and DPNI is used when p, g, and d are double precision numbers and w is a double precision variable.

It is assumed that p > 0, ¢ > 0, p+q = 1, and d= p— 1/2. TERR and w are variables. When PNI cr DPNI is called, if no input errors are detected then IERR is set to 0. Also, w is assigned the value for which P(w) = p and Q(w) = q.

```text
Error Return. IERR = 1 if p < 0,q < 0, or p+q #1, and IERR = 2 if d # p — 1/2.
Algorithm. For y > 0, let y =: erf~'(xr) when x == erf(y). If P(w) = p then the identities
```

-J/2erf(1-2p) ifO0<p<1/2 V2erf'(2p i) ifl>p>t/2

are applied.

**Precision.** {f PNI is called then w is accurate to within 3 units of the 14" significant digit. Otherwise, if DPN] is called then w is accurate to within L unit of the 27" significant digit.

**Programming.** PNI employs the functions FREI, SPMPAR, and IPMPAR, and DPNE employs the functions DERFI, DER, DERECI, DERECO, DXPARG, DPMPAR, and IPM- PAR. PNI was written by Armido R. DiDonato and modified by A. H. Morris. DPNI was adapted from PNE by A. EL. Morris,


<small>Original source: [View scanned PDF page 55](../scans/page_0055.png)</small>

<a id="topic-055-01"></a>
### Dawson's Integral

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DAW` | `REAL FUNCTION` | `X` | [`L7769`](../source_parts/nswc_part_01.f#L7769) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [`L7910`](../source_parts/nswc_part_01.f#L7910) |


Dawson's integral is

$$
F(x)=e^{-x^2}\int_0^x e^{t^2}\,dt.
$$

`DAW(X)` evaluates $F(x)$ in single precision, while `DPDAW(X)` provides
the double-precision counterpart.

**Programming.** `DAW` is derived from the FUNPACK special-function collection
at Argonne National Laboratory, with modifications by A. H. Morris.
`DPDAW` uses approximations derived from SLATEC Chebyshev expansions and
additional approximations by A. H. Morris.

**Reference.** W. J. Cody, K. A. Paciorek, and H. C. Thacher,
"Chebyshev Approximations for Dawson's Integral," *Mathematics of Computation*
**24** (1970), 171-178.

Original documentation: [page 55](../scans/page_0055.png).


<a id="topic-056-01"></a>
### Complex Fresnel Integral

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [`L8212`](../source_parts/nswc_part_01.f#L8212) |


For any omplex z not on the positive real axis the complex Fresnel integral E(z) can be defined by 1 f? et E @) ocr ---a_s —= tt. (*) Vor J ~ 00 Jt Here it is assumed that 0 < arg{z) < 2m and arg(,/z) == 1/2 arg{z). E(z) can be extended to the positive real :.xis by letting 0 < arg(z) < 2". Then erf(z) = 1 — i/2 E(—2z?) for —«/2< arg(z) < «/2 where erf{z) ia the error function and arg(—z?) = 4 + 2 arg(z). The following subrousine 3 is available for computing E(z).

```fortran
CALL CFRNLI(MO, Z, W)
```

MO is an integer, z a complex number, and w a comp!ex variable. When CFRNLI is called, w is assigned the value H(z) if MO == 0 and the value e~* H(z) if MO £0.

**Algorithm.** If z = z + ty satisfies !z| < 1 or both of the inequalities t < |z| < 38 and —z + .016y? < 0, then the series

F(z) ) = ~Jg+ Viale en

aint +1)

is used. If 1 < |z| < 38 and --z + .016y? > 0 then

E{2) = aed yo tte

> 38 and Im \/2z/m > .008 then E(z) is computed by the asymptotic expansion E(z) = (z) where

e 1-3---(2n —1) z) = pee fit S° v( ) /2nz at x (2z)"

**Precision.** For MO # 0, Refw)} aud im(w) are accurate to within 1 unit of the 12°" significant digit when Re(w) and Im(w) are nonzero.

**Programming.** CF RNLI employs the functions CPABS, EXPARG, and IPMPAR. CFRNLI was written by Allen V. Hershey and A. H. Morris.

Reierence. Hershey, A. V., Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virgmia, 1971.


<small>Original source: [View scanned PDF page 57](../scans/page_0057.png)</small>

<a id="topic-057-01"></a>
### Real Fresnel Integrals

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FRNL` | `SUBROUTINE` | `T, C, S` | [`L8383`](../source_parts/nswc_part_01.f#L8383) |


For any compicx z the Fresnel integrals C(z) and S(z) can be defined by Oz) =[ ccs (507) dt 0 2 / * x S(z) = [ sin (-t? | dt (z) I sin (F )

The following subroutine is available fer computing Cye} and 3 (z) when .: is real. CALL FRNL(z,C, S)

The argument x may be any real number. C and S are variables. When FRNL is called C’ is assigned the value C(z) and S is assigned the value S{z).

**Algorithm.** If 0 < xz < 1.65 then 27'C(z) and x“3S(z) are computed by minimax polynomial apprcximations. Otherwise, if « > 1.65 then the relations

lt S{a) =z - F(z) coss-2? — g(x) sins x?

are invoked. For 1.65 < 2 < 6,2f(z) and x°g(z) are computed by rational minimax approximaticns. Otherwise, for z >: 6 the auxiliary functions f(z) and g(z) are cornputea by the asymptotic expansions:

f(z) — 14 2| 1) (x2)? LOR, yh 8 (48 +1 g(t) =~ dal 4) Saar

x

Here m= 5. If x < 0 then the relations C(--r) = —C(2) and S(—<) = --S(z) are applied.

**Precision.** if |zj < 2 then FRNI is accurate to within 3 units of the 14 significant digit. Otherwise, if |z| > 2 then FRNL is accurate to within U unit of the 14" significant digit.

**Programming.** FRNL calls the functiowe SIN], COSI, and IPMPAR. FRNL was written by A. H. Morris.


<small>Original source: [View scanned PDF page 58](../scans/page_0058.png)</small>

<a id="topic-058-01"></a>
### Exponential Integral Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [`L8597`](../source_parts/nswc_part_01.f#L8597) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [`L8778`](../source_parts/nswc_part_01.f#L8778) |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [`L9110`](../source_parts/nswc_part_01.f#L9110) |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L9121`](../source_parts/nswc_part_01.f#L9121) |


For any couwnplex z # 0 not on the positive real axis the exponential integral function

Ei(z) is defined by

Bifz) = | ~~ dt, deco t Ki(z) is an analytic function. I€ z is ropiaced by -z and t by ~t we obtain the related

function PO ot

Ey(z) ~ ~Ei(~z) = | Sat

a

which is defined for all z # 0 not on the negative real axis. It, can be verified that Ei(z) = v 4+-In(—z) + ——~ Aa everywhere in the plans cut along the positive real axis where vy is the Euler constant. Thus, the values of Ei{z) on the upper and lower edges of the cut are Bi(x £10) = eifx) Fmt where ei(z) is the real function defined by

ar Ad ei(z) = vy + Ina + > --

n-n! n=i

for 2 > 0. The function ei(z), also known as the exponential integral function, has a zero i he point 29 = .37250 74107 81367 Ei(z) may be computed by the subroutine CEXPL whex z is complex, and Ei(z) and ei(z) may be computed by the subroutine EXPL£ and functions DET and DET] when z is real. DET and DEI! are double precision functions.

```fortran
CALL CEXPLI(MO, Z, W)
```

MO is an integer, z 4 0 a complex number, and w a complex variable. When CEXPL1 is called, w is assigned the valu2 Ei(z) if MO = © and the value e~? Ei(z) if MO #0.

**Remark.** If z is a positive real number and MO = 0 then w =» ei(z) +-9¢.

**Precision.** If MO = 0 then Re(w) and Im(w) are accurate to within 2 unts of the 12t significant digit when z is nov near a zero of Re(Ki{z)) or Im(Fi(z)).

**Programming.** CEXPLI employs the functions CPABS and SPMPAR. CEXPLI was initially written by Allen V. Hershey, and later rewritten by A. HL. Morris.

**Reference.** ilershey, A. V., Approzimations of Functions by Sets of Poles, veo. o TR 2564, Naval Weanons Laboratory, Dahler-on, Virginia, 1971.


<small>Original source: [View scanned PDF page 59](../scans/page_0059.png)</small>

```fortran
CALL EXPLI(INT, ARG, RESULT, IERR)
```

MO may have the values 1,2, or 3. The argument x is a nonzero real nurnber and w areal variable. When EXPi is called, if MO = 1 then w is assigned the value Ei(x) for a < O and the value eifx) tor > 0. If MU = 2 then it is assured that z > 0. In this case w is assigned the value £,(z}. Otherwise, if MO = 3 then w is assigned the value e~*Ei(z) for a < GO and the value e~” vi{z) for x > 0.

**Error return.** TERR is a variable that reports the status of the results. If the requested value w is obtained then [ERR is set to 0. Otherwise, TERR is assigned one of the following values:

JERR = 1 Underflow occurs. In this case w = 0.

TERR = 2 Overflow cccurs.

IERR = 3 (Input error) 2 = 0.

IGRR = 4 (Input error) MO = 2 and x < 0. The variable w is not defined when IERR > 2.

**Algorithm.** If MO 4 2 and 4 < 2x < 8, then the Chebyshev expansion in the SLATHC library obtained by Wayne Fullerton (Los Alamos) is used. The remaining approximations employed are from the references.

**Precision.** If MO # 2 and x > 0, then w is accurate to within 4 units of the 14° significant digit when w 7 0. Otherwise, w is accurate to within 3 units of the 14" significant digit when wv #0.

**Programming.** EXPLI employs the functions ALNREL, CSEVL, EXPARG, and IPMPAR. EXPLI was written at Argonne National Laboratory for the FUNPACK package of special function subroutines. XPLI was modified by A. H. Morris.

**References.**

(1) Cody, W. J. and Thacher, H. C., “Rational Chebyshev Approximations for the Exponential Integral E,(«),” Math Comp. 22 (1968), pp. 641-649.

(2), “Chebyshev Approximations for the Exponential Integral Ei(z},” Math Comp. 23 (1969), pp. 289-303.

DEI(Cr) The argument x -f 0 is a double precision number. DEI(+) is the double precision value for Ei(z) when z < 0, and the double precizion value for ei(z) when x > 0.

**Remark.** DET must be declared in the calling program to be of type DOUBLE PRECISION.

Aigorithm. If 35 < 2 < 4 then the Taylor series expansion of elif; around zy is used. This expansion was obtained by A. Hf. Morris. Hf jx expansion for fi and ei is applied. Otherwise, the Chebyshev expansions in the SLATEK:

» 9O then the standard asymptotic

Hbrary obtained by Wayne Fullerton (los Alaries) are used,


<small>Original source: [View scanned PDF page 60](../scans/page_0060.png)</small>

**Programming.** DEI employs the functions DE1E and DEIO. These functions were written by A. H. Morris. The functions DCOSEVL and DPMPAR are also used.

DE!1(z) The argument 2 # 0 is a double precision number. DEIi(z) is the double precision value for e~* Ei(z) when z < 0, and the double precision value for e~* ei{z) when z > 0.

**Remark.** DEi1 must be declared in the calling program to be of type DOUBLE PRECISION.

**Algorithm.** If .35 < x < .4 then the Taylor series expansion of ei(z) around zo is used. This expansion was obtained by A. H. Morris. If |x| > 90 then the standard asymptotic expansion for Ei and ei is applied. Otherwise, the Chebyshev expansions in the SLATEC library obtained by Wayne Fullerton (Los Alamos) are used.

**Precision.** DEIi(z) ia accurate to within 4 units of the 28° significant digit when DEI1(z) £0.

**Programming.** DEI1 employs the functions DEIE and DEIO. These functions were written by A. H. Morris. The functions DCSEVL and DPMPAR are also used.


<small>Original source: [View scanned PDF page 61](../scans/page_0061.png)</small>

<a id="topic-061-01"></a>
### Sine and Cosine Integral Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SI` | `FUNCTION` | `X` | [`L9694`](../source_parts/nswc_part_01.f#L9694) |
| `CIN` | `FUNCTION` | `X` | [`L9808`](../source_parts/nswc_part_01.f#L9808) |


For any complex z the sine integral and cosine integral functions Si(z) and Cin(z) are

defined by

\* gin t Si = —_—— i(z) [ ; dt *1—cost

Cin(s) = f= E* at 0 t

These are entire functions. The following functions are available for computing Si(z) and Cin(z) when z is real.

SI(z) SI(z) = Si(z) for all real z. Precision. SI is accurate to within 2 units of the 14'” significant digit.

**Programming.** SI calls the function SPMPAR. SI was written by Donald E. Amos and Sharon L. Daniel (Sandia Laboratories), and modified by A. H. Morris.

CIN(z) CIN(z) = Cin(z) for all real z.

**Precision.** CIN is accurate to within 2 units of the 14" significant digit.

**Programming.** CIN calls the function SPMPAR. CIN was written by Donald E. Amos and Sharon L. Daniel (Sandia Laboratories), and modified by A. H. Morris.


<small>Original source: [View scanned PDF page 62](../scans/page_0062.png)</small>

<a id="topic-062-01"></a>
### Exponential Exponential Integral Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [`L9922`](../source_parts/nswc_part_01.f#L9922) |


For any complex z # O not on the positive real axis, the exponential exponential integral function #Et{z) can be defined by

EEi(z) = / ; — Ei(u) du

where E(u) is the exponential integral function. The following subroutine is available for computing #E£1(z), where EEi(z) is extended to the positive real axis by letting 0 < arg(z) < 2m.

```fortran
CALL CEXEXI(Z, W)
```

The argument z is a nonzero complex number and w is a complex variable. *Vhen CEXEXI is called, w is assigned the value EE1(z).

**Precision.** Re(w) and Im(w) are accurate to within 1 unit of the 12" significant digit when Re(EEi(w)) and Im(ZE1(w)) are not near 0.

**Programming.** CEXEXI was written by Allen V. Hershey and modified by A. H. Morris.

**Reference.** Hershey, A. V., Approzimation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.


<small>Original source: [View scanned PDF page 63](../scans/page_0063.png)</small>

<a id="topic-063-01"></a>
### Dilogarithm Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CLI` | `COMPLEX FUNCTION` | `Z` | [`L10152`](../source_parts/nswc_part_01.f#L10152) |
| `ALI` | `REAL FUNCTION` | `X` | [`L10266`](../source_parts/nswc_part_01.f#L10266) |


For any complex z where larg(1-+ z)}/ < #, the dilogarithm function L(z) may be defined by to t L{z) is real-valued fer any real z > —1, and -1 is a branch point. L(z) can be extended to

the negative rea! axis from --oo to ~1 by letting -a < arg(1 +z) < . Then for any real

E{z) = —1 6 +f mt) dt-+inin(—z) (f= V~1).

The function CLI is available for computing L(z) when z is complex, and the function ALI is available tor computing the real part of L(z) when z is real.

```fortran
CLK(z)
```

CLI is a complex-valued function where CLI(z) == L(z) for all complex z. CLI must be declared in the calling program to be of type COMPLEX.

**Algorithm.** For jz| < 1/2 the Maclaurin series

n>1 is used. If |z| > 3 then (2) L(z) = 7/6 — LA/z) + 1/210? z is applied, and if O < jz + 1| < 1/2 then (3) L({z) = —n?/6 -- L(-1 ~ z) +1n(--z) In(1 + z)

is applied. Otherwise,

L(z) = -| a4 d\ (Debye Function) F : (4)

~ Hy,w?” nit = ww 2/4- 2 ; (Gn pyr Jw] < Qa

is used where w = —Inj{l + z) and 32, are the Bernoulli numbers By, = 1/6, Bg ~- 1/30, .... In (3) we note that In(~z)in{1 +z). + 0 when z 9 ~1.

**Programming.** CLI is a modification by A. H. Morris of the subroutine CLGMCI, written by Allen V. Hershey.


<small>Original source: [View scanned PDF page 64](../scans/page_0064.png)</small>

**Reference.** Hershcy, A. V., Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahigren, Virginia, 1971.

ALI(z) ALI{z) = Re[L(x)j} for all real x.

**Algorithm.** Rational minimax approximations are used when —1/2 <x <1. if2 > 1 then (2) is applied, and if -2 < 2 < -l or ~1 < x < ~1/2 then (3) is applied. Otherwise, if x< —2 then

Re! L(t)] = --2?/3 — L(1/x) + 1/21n?(-2)

(which follows from (2)) is used except when -26.63 < x < —6.97. Since Ke[L(zo)] = 6 for to = ~-12.59517 ..., the Taylor series of Re[Z(z)] around zo is used when --14 < 2 < -11.1. Otherwise, if —11.1 < 2 < --6.97 or -26.63 < x < —14 then rational minimax approximations are employed.

**Precision.** ALI(z) is accurate to within 2 units of the 14" significant digit when z > 0. Otherwise, if 2 < 6 then ALI(z) is accurate to within 4 units of the 14" significant digit when ALI(z) # 0.

**Programmer.** A. E. Morris

**Reference.** Morris, Robert, “The Dilogarithin Function of a Real Argument,” Math. Comp. 33 (1979), pp. 778-787.


<small>Original source: [View scanned PDF page 65](../scans/page_0065.png)</small>

<a id="topic-065-01"></a>
### Gamma Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [`L10420`](../source_parts/nswc_part_01.f#L10420) |
| `GAMMA` | `REAL FUNCTION` | `A` | [`L10685`](../source_parts/nswc_part_02.f#L36) |
| `GAMLN` | `REAL FUNCTION` | `A` | [`L10974`](../source_parts/nswc_part_02.f#L325) |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [`L11043`](../source_parts/nswc_part_02.f#L394) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [`L11312`](../source_parts/nswc_part_02.f#L663) |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [`L11615`](../source_parts/nswc_part_02.f#L966) |


For any complex z # 0,-—1,-2,... the gamma function can be defined by

[(z) = > (-1)" i 4 [ ti g~t ge

n=0

Then F(z) is a meromorphic function having simple poles at 0,—-1, ~2,... ,and

r(z)= | t7~e* dt 0

for Re(z) > 0. Also ['(z) # 0 for all z. The subroutines CGAMMA and DCGAMA are available for computing ['(z) and InI'(z) when z is complex, and the functions GAMMA, GAMLN, DGAMMA, and DGAMLN are available for computing T(z) and InI'(z) when z is real. DCGAMA, DGUAMMA, and DGAMLN are double precision procedures.

```fortran
CALL CGAMMA(MO, Z, W)
```

MO is an integer, z a cornplex number satisfying z 4 0,-1,-2, .. ., and w a complex variable. When CGAMMA is cailed, w is assigned the value P'(z) if MO = 0 and the value InI'{z) if MO 40.

**Error return.** If z = 0,—1, --2,..., or if Re(z) < 0 and Re(z) is too large for In I'(z) to be computed, then w is assigned the value 0.

**Programming.** CGAMMA calls the functions REXP. SPMPAn, and IPMPAR. CGAMMA was written by A. H. Morris.

**References.**

(1) Kuki, Hirondo, “Complex Gamma Function with Error Control,” Comm. ACM 15 (1972), pp. 262-267.

(2) Spira, Robert, “Calculation of the Gamma Function by Sitirling’s Formula,” Math Comp. 25 (1971), pp 317-322.

```fortran
GAMMA(A)
```

The argument z's a real number, If (x) can be computed then G .MMA (z) is assigned the value U(z). Otherwise, if M(2) cannot be computed, then GAMMA(z) is set te 0.

**Algorithm.** If jz! < 15 then x is reduced to the interval (1,2) by Pia + 1) @P(a), and a rational mipimax approximation is employed. If 2 <- -15 then n


<small>Original source: [View scanned PDF page 66](../scans/page_0066.png)</small>

is applied. For x > 15 (2) ln T(z) = (x — $) nz - x + § In(2x) + A(z)

is computed where A(x) is a minimax approximation. The function A(x) is evaluated in single precision, and a double precision value is obtained for Inz. This yields a double precision value for In ['(z). If Int'\(z) = a4-6 where a is the leading portion of InI'(z), then P{z) is set to e%(1 + 6). This is permissible since 1 + 6 is the portion of the Taylor series expansion for e® that is significant.

The logarithm In is evaluated as follows: Let n be the largest integer less than or equal to z, and let ¢ = (x —n)/(x +n). Then x = n(1+t)/(1 — t) so that nz = Inn + In{(1 + t)/(1 — ¢)]. Also 0 < t < 1/(2n). The function In {(1+1¢)/(l— t)] is computed by a polynomial minimax approximation in single precision, and the value In n is stored in double precision.

**Precision.** If 0 < z < 2 then GAMMA(z) is accurate to within 2 units of the 14 significant digit. If s > 2 then GAMMA(z) is accurate to within 3 units of the 14" significant digit. Otherwise, GAMMA(z) is accurate to within 5 units of the 14"? significant digit.

**Programming.** GAMMA cails the functions GLOG and EXPARG. These functions were written by A. H. Morris. The functions SPMPAR and IPMPAR are also used.

GAMLN(z) GAMLN(z) = InI(z) for all positive real z. Algerithm. See p. 379 and appendix D of the reference.

**Precision.** GAMLN(z) is accurate to within 2 units of the 14°? significant digit when GAMLN(z) 4 0.

**Reference.** DiDonato, A. R. and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

**Programming.** GAMLN calls the function GAMLNI. These functions were written by A. H. Morris.

```fortran
CALL DCGAMA(MO, Z, W)
```

MO is an integer, and 4 and W are double precision arrays of dimension 2. It is assumed that Z(1) and 4(2) are the real and nnaginary parts of a complex number z. If MO... 0 then the double precision value for w — P(z) is computed. Otherwise, if MO 7 0 then the double precision value for w In P(z) is computed. W(1) and W(2) ‘contain the real and imaginary parts of w, respectively,

**Error Return.** [fz 0, ty) 2, orif Re(z) > O and Re(z} is too large for In P(2) to be computed, then W(1) and W (2) are assigned the value 0


<small>Original source: [View scanned PDF page 67](../scans/page_0067.png)</small>

**Programming.** DCGAMA calls the functions DREXP,DPMPAR, and IPMPAR. DCGAMA was written by A. H. Morris.

**References.**

(1) Kuki, Hirondo, “Complex Gamma Function with Error Control,” Comm. ACM 15 (1972), pp. 262-267.

(2) Spira, Robert, “Calculation of the Gamma Function by Stirling’s Formula,” Math Comp. 25 (1971), pp. 317-322.

```fortran
DGAMMA(A)
```

The argument z is a double precision number. DGAMMA(z) is the double precision value for I'(z) when ['(z) can be computed. Otherwise, DGAMMA(z) is set to 0 when ['() cannot be computed.

**Remark.** DGAMMA must be declared in calling program to be of type DOUBLE PRECI- SION.

**Algorithm.** Li |x| < 20 then z is reduced to the inte:val (1,2) by [(a+ 1) = aT (a), and minimax approximations are used. If z < —20 then (1) is applied, and if z > 20 then (2) is used. A(z) is computed by the power series corresponding to the Chebyshev expansion ii the SLATEC library given by Wayne Fullerton ‘Los Alamos). The power series and minimax approximations were obtained ly A. H. Morris.

**Precision.** If 0 < x < 2 then DGAMMA(r) is accu; ate to within 1 unit of the 28'" signifiant digit. Otherwise, if z > 2 then DGA'MM 1(z* is accurate to within 1 unit of the 25°" significant digit.

**Programming.** DGAMMA calls the functions DGAMI, DPDEL, DSIN1, and DX PARG. These functions were written by A. H. Morris. The functions DPMPAR and IPMIAR are also used.

```fortran
DGAMLN(A)
```

The argument 2 is a double precision positive number. DGAMLN(z) is the double precision value for In F(z).

**Remark.** DGAMLN must be declared in the calling program to be of type DOUBLE PRECISION,

**Algorithm.** If 5 <2 © 2.5 then mintinax approximations are used, and ifr + LO uhen (2) is applied. A(x) 1s computed by the power series corresponding to the Chebyshev expansion in the SLATEC hbrary given by Wayne Fullerton (Los Alamos), The power series and minimax approximations were obtained by A. HE. Morris.


<small>Original source: [View scanned PDF page 68](../scans/page_0068.png)</small>

**Precision.** DGAMLN(z) is accurate to within 2 units of the 28° significant digit when DGAMLN(s) # 0.

**Programming.** DGAMLN cails the functions DPDEL, DGMLN1, DGAMI, and DLNREL. These functions were written by A. H. Morris.


<small>Original source: [View scanned PDF page 69](../scans/page_0069.png)</small>

<a id="topic-069-01"></a>
### Digamma Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPSI` | `SUBROUTINE` | `Z, W` | [`L11665`](../source_parts/nswc_part_02.f#L1016) |
| `PSI` | `REAL FUNCTION` | `XX` | [`L11795`](../source_parts/nswc_part_02.f#L1146) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [`L11966`](../source_parts/nswc_part_02.f#L1317) |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [`L12136`](../source_parts/nswc_part_02.f#L1487) |


For any complex z # 0,—1,—2,... the digamma (or psi) function y(z) is defined by b(z) = I’(z)/T(z)

where ['(z) is the gamma function. For real z > 0,y(z) is an increasing function having a zero at the point 29 = 1.4616 32144 96836. The subroutines CPSI and DCPSI are available for computing (z) when z is complex, and the functions PSI and DPSI are available for computing ¥({z) when z is real. DCPSI and DPSI are double precision procedures.

```fortran
CALL CPSI{z, w)
```

The argument z is a complex number satisfying z # 0,—-1,—-2,..., and w is a complex variable. When CPSI is called, w is assigned the value #(z).

**Error Return.** If z = 0,—1,—-2,..., or if Re(z) < 0 and Re(z) is too large for (z) to be computed, then w is assigned the value 0.

**Algorithm.** If z == z4- ty satisfies « > O and |z| > 6, then the asymptotic expansion

1 SN Bam (1) w(z) = In a 2: _ »D Qmz2™

is employed. Otherwise, if z > 0 then the smallest nonnegative integer n is found for which iz 4+-n| > 6, and the relation

n--1 . dt y=0 is applied. When x < © then

is also used.

**Programming.** CPSI calls the functions REXP, SPMPAR, and IFMPAR. CPSI was written by ASH. Morris.

PSi(z)

The argumeat ris areal number. Hf y¥(z) can be coruputed then PS! (x) is assigned the value (2). Otherwise, if (a) cannot be computed then PSI(z) is set to 0.

**Precision.** If r+ O thea PSHry iy accurate to within 2 units of the 14% signiheant digit when PSitr) 4 0.


<small>Original source: [View scanned PDF page 70](../scans/page_0070.png)</small>

**Programming.** PSI calls the functions SPMPAR and IPMPAR. PSI was written at Argonte National Laboratory for the FUNPACK package of special function subroutines. PSI was modified by A. H. Morris.

**Reference.** Cody, W. J., Strecok, A. J., and Thacher, H. C., “Chebyshev Approximations for the Psi Function,” Math Comp. 27 (1973), pp. 123-127.

```fortran
CALL DCPSI(Z, W)
```

Z and W are double precision arrays of dimension 2. It 1s assumed that 7(1) and 2(2) are the 1al and imaginary parts of a complex number z. When DCPSI is called the double precision value for w = (z) is computed. W(1) and W(2) contain the zeal and imaginary parts of w, respectively.

**Error Return.** If z = 0,-1,-2,..., or if Re(z) < 0 and Re(z) is too large for ¥(z) to be computed, then W(1) and W(2) are assigned the value 0.

**Programming.** DCPSI calls the functions UDREXP, DPMPAR, and IPMPAR. DCPSI was written by A. H. Morris.

```fortran
DPSI(A)
```

The argument z is a double precision number. If (x) can be computed then DPSI(z) is the double precision value for ¥(z). Otherwise, if v/~. cannot be computed, then DPSI{z) is set to 0.

Remark DPSI must be declared in the calling program to be of type DOUBLE PRECISION.

**Algorithm.** If |z| < 10 then z is reduced to tke interval {1,2) by ¥(a+ 1) = 4+ ¥(a), and the Chebyshev expansion in the SLATEC library given by Wayne Fullerton (Los Alamios) is used when |x ~ zo| > 2-107. Otherwise, if |x — xo| < 2-107? then the Taylor serics around the zero ro 1s used. The coefficients for the Taylor series were obtained by A. H. Morris. If z < --10 then (2) is applied, and if 2 > 10 then (<) -- Inz is computed by the power series corresponding to the Chebyshev expansion in the SLATEC library given by Wayne Fullerton. The power series was obtained by A. H. Morris.

**Precision.** If 0 < x < lor z > 2 then DPSI{z) is accurate to within 2 units of the 28¢* significant digit. Otherwise, if 1 < 2 < 2 then DPSI(z) is accurate to within 5 units of the 28°" significant digit when DPSI(z) ¢ 0.

**Programming.** DPSI calls the functions DCSEVL, DPSIO, DPMPAR, and IPMPAR. DPSI was written by A. H. Morris.


<small>Original source: [View scanned PDF page 71](../scans/page_0071.png)</small>

<a id="topic-071-01"></a>
### Derivatives Of The Digamma Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [`L12394`](../source_parts/nswc_part_02.f#L1745) |


The following subroutine is available for computing the digamma function (zx) and its derivatives for real « > 0.

```fortran
CALL PSIDF(X, N, M, ANS, IFLAG)
```

```text
Let wa = —p(x) and w, = (-1)" ym anroye ) where p'")(z) is the n*® derivative of (z)
(mn =1,2,...).
```

The argument x is a positive real number, n and rm are integers where n > O and m > 1, and W is an array of dimension m or iarger. When PSIDF is called, wyy;_1 18 computed and stored in W(t) for t= 1, ...,m.

IERR is an integer variable that reports the status of the results. When PSIDF terminates, IERR. has one of the following values:

TERR = 0 The values w,, ...,Wptm— were obtained and stored in W.

TERR = 1 (Input errer) x <0,n <0,orm< 1.

IERR = 2 (Overflow) Either x is too small or n + m— 1 too large.

{ERR = 3 (Underflow) Either z is too large or n+ m— 1 too large.

TERR = 4 This setting can occur only ifn +m —1 > 100. When it occurs, Wn+m-1 cannot be computed since mn + m— 1 is too large for x. (However, wnim—1 may be computable for larger values of 2.)

**Remark.** Even though PSIDF may be used for computing wo = --¥(z), its primary purpose is for computing the sealed derivatives w,(n > 1) of w(x). For x > 3, wy is accurate to within 2 units of the 14° significant digit. However, far less accuracy is frequently obtained when x < 3. In the worst case, all relative accuracy is lost for w. when z is sufficiently near the zero Zo = 1.4616... of y(z). For x < 3, the function PSI should be used for computing

Wz).

**Precision.** For 1 <n < 30 and x < 1000, w, is accurate to within 1.5 units of the 12** significant digit.

**Programming.** PSID® employs the functions IPMPAR, SPMPAR, EPSLN, and EXPARG. PSIDF 1s a modification by A. H. Morris of the subroutine PSIFN, written by Donald E.

Amos (Sandia Laboratcries).

Reference Amos, D. E ,“Algorithm 610. A Portable Fortran Subroutine for Derivatives of the Psi Function,” ACAY Trans. Mati Software 9 (1983), pp. 494-502.


<small>Original source: [View scanned PDF page 72](../scans/page_0072.png)</small>

<a id="topic-072-01"></a>
### Incomplete Gamma Ratio Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [`L13141`](../source_parts/nswc_part_02.f#L2492) |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [`L13559`](../source_parts/nswc_part_02.f#L2910) |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [`L13587`](../source_parts/nswc_part_02.f#L2938) |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [`L13939`](../source_parts/nswc_part_02.f#L3290) |


For a > 0 and x > 0 let P(a,z) and Q(a,z) denote the functions defined by

1 * . P(a,z =a / e 43>! at (2) =a) J, _ 1 et pak On2) =575 | 2" ge~* dt.

Then 0 < P(a,z) < 1 and P(a,r) + Q(a,z) = 1. Also, P(a,z) > Land QO(a,z) — Ofer xz > 0 when a -+ 0. Hence, we may define P(0,xz) = 1 and Q(0,2) = C for zr > 0. The subroutines GRATIO and DGRAT are available for computing P(a,2) and Q(a,z2), aul the auriiiary functions RCOMP and DRCOMP are provided for computing e~7z*/T(a).

```fortran
CALL GRATIO(A, X, ANS, QANS, IND)
```

It is assumcd that @ > 0 and x > O, where a and z are not both 0. P and Q are variables. GRATIO assigns P the value P(a,z) and Q the value Qfa,x). The argument ¢ may be any integer. This argument specifies the desired accuracy of the results. If1 = 0 then the user is requesting as much accuracy as possible (up to 14 significant digits). Otherwise, if i = 1 then accuracy is requested to within 1 unit of the 6" significant digit, «1d if: # 0,1 then the accuracy is requested to within 1 unit of the 3" significant digit.

**Error Return.** P is assigned the value 2 when a or x is negative, when a = xz = 0, or when P(a,z) and Q(a,2) are indeterminant. P(a,2) and Q(a,z) are indeterminant when xz aan a is exceedingly large. On the CDC 6000-7000 series ccmputers this occurs when |z/a ~ 1| < 107" and a > 6.6E25.

**Programming.** GRATIO calls the junctions ERP, ERFC1, REXP, RLOG, RCOMP, GAM1, GAMMA, and SPMPAR. GAMMA employs the functions GLOG, iSXPARG, and IPMPAR, GRATIO was written by A. H. Morris,

**Reference.** Dibonato, A. R. and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Mats Software 12 (1986), pp. 377-398.

RCOMP (a, z) RCOMP(a,z) = e7*27/I'(a) for a > O and x > 0. Algorithm. See page 378 of the reference.

**Programming.** RCOMP employs the functions EXPARG, GAMMA, GAM]J, GLOG, and RLOG. These functions were written by A. H. Morris. The functions SPMPAR and iPM- PAR. are also used.


<small>Original source: [View scanned PDF page 73](../scans/page_0073.png)</small>

Reference, Dibouato, A. R. and Morris, A. W., “Computation of the Incomplete Gamma Function Ratios and their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

```fortran
CALL DGRAT(A, X, ANS, QANS, IERR)
```

The argurnents a and x are nonnegative double precision numbers, where a and « are not both G. P and Q ave double precision variatles, and JERR an integer variable. When DGRAT is called, if P(a, x) and Q(a,x) can be computed then IERR is set tc 0 and P and Q are assigned the double precision values for P(a,«) and Q{a,z).

**Error Return.** If P(a,x) and Q(e¢,z} cannot be computed then /° is set to 2 aad IERR is assigned one of the following values: IERR = ¢ @ or # is negative. IERR=2ua=2=0. IERR = 3 Pla,z) and Q(a,x) are indeterminant. This setting occurs only when z a aad a is exceedingly large.

**Algorithm.** A modification cf the algorithm given in the refereuce is used. The functions e,(z) appearing in the Tenure Expansion on page 381 are computed by minimax approximations designed by A. H. Morris.

**Programming.** DGRAT ernploys the subroutines DGR26 and DGR17, and the functions IPMPAR, DPMPAR, DXPARG, DREXP, DRLOG, DSIN1, DERF, DERFC1, DERFCO, DGAMMA, DGAM1, DRCOMP, and DPDEL. DGRAT was written by A. H. Morris.

**Reference.** DiDonato, A.R. and Morris, A.H.,“Computation of the Incomplete Gamma Function Ratiog and Their Inverse,” ACM Trans. Muth Software 12 (1986), pp. 577-393.

```fortran
ORCOMP(a.z)
```

The arguiaents a and x are double precision numbers where a > O and xz > 0. DRCOMP(a,z) is the double precision value for e~7z°/T(a).

**Remark.** DKCOIMP must be declared to be of type DOUBLE PRECISIC. in the calling program.

**Programming.** DRCOK/' employs the functions IPMPAR, DPMPAR, DAPARG, DRLOG, DSINIL, DGAMMA, DGAMLE, and DPDEL. DRCOMP was written by A. H. Morris.


<small>Original source: [View scanned PDF page 74](../scans/page_0074.png)</small>

<a id="topic-074-01"></a>
### Inverse Incomplete Gamma Ratio Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [`L13616`](../source_parts/nswc_part_02.f#L2967) |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [`L14631`](../source_parts/nswc_part_02.f#L3982) |


For a > 0 and z > 0 let P(a,z) and Q(a,z) denote the incomplete gamma ratio functions defined by

P) _ 1 * —tya-— F (2) =i | et?" dt Q(a, x) = poet ae

```text
Then 0 < P(a,z) < 1 and P(a,z) + Q(a,r) = 1. If we are given a, p, and g where
a>0,0<p<1, and p+q=1, then the subroutines GAMINV and DGINV are available
for obtaining the value 2 > 0 for which P(a,z) = p and Q(a,z) =q.
```

```fortran
CALL GAMINV(A, X, X0, P, Q, IERR)
```

X is a variable. If p = 0 then X is assigned the value O, and if g = 0 then X is set to the largest floating point number available. Otherwise, if p 4 0 and g # 0 then GAMINYV attempts to obtain a solution « for P(a,z) = p and G(a,z) = q that is correct to at least 10 significant digits.! If a solution is obtained then it is stored in X. The solution is normally computed by Schroder iteration. The argument zg is an optional initial approximation for x. If the user does not wish to supply an initial approximation then set ro < 0.

```text
IND is a variable that reports the status of the results. When GAMINV terminates,
IND has one of the following values:
```

IND = 0 The solution was obtained. Iteration was not used.

IND > 1 The solution was obtained. IND iterations were performed.

IND = -2 (Input error) a < 0.

IND = -3 No solution was obtained. The ratio Q/a is too large.

IND =: —4 (Input error) p<6,q<0,orp+q#1l.

IND = ~6 20 iterations were performed. The most recent value obtained for z is stored in X. This cannot occur if zg < 0.

IND = -7 Iteration failed. No value is given for 2. This may occur when zw 0.

IND = --8 A value for x is stored in X, but the routine is not certain of its

accuracy. iteration cannot be performed in this case. If zo < 0 then this can occur only when p + 0 or g # 0. If zo > 9 then this can occur when as x and a is exceedingly large (say a > 107°),

**Remark.** If ro < 0 then 3 or fewer iterations are required.

**Programming.** GAMINV employs the subroutines GRATIO and PNI, and functions ERF, ERFC1, ERFI, REXP, RLOG, ALNREL ,GAN MA, GLOG, GAMI, GAMLN, GAMELNI,

if a k digit floating point arithmetic is being used where & < 10, then the routine attempts to obtain a

solution that is correct to machine accuracy.


<small>Original source: [View scanned PDF page 75](../scans/page_0075.png)</small>

RCOMP, EXPARG, IPMPAR, and SPMPAR. GAMINV was written by A. H. Morris.

**Reference.** DiDonato, A.R. and Morris, A.H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

```fortran
CALL DGINV(A, X, P, Q, IERR)
```

The arguments a, p, g are double precision numbers and X a double precision variable. If p = 0 then X is assigned the value ©, and if g = 0 then X is set to the largest double precision number available. Otherwisc, i 9 AO and ¢ #40 then DGINV attempts to obtain a double precision solution z for P(a,z) = p and Q{a,z) = q that is correct to machine accuracy. If a solution is obtained then it is stored in X.

IND is a variable that reports the status of the results. When DGINV terminates, IND has one of the following values:

IND = 0 The solution was obtained. Iteration was not used.

IND > 1 The solution was obtained. IND iterations wei: >serformed.

IND = —2 (Input error) a < 0.

IND = —3 No solution was obtained. The ratio Q/a is too large.

IND = —4 (Input error) p< 0,¢ <O,orp+q#l.

IND = —6 10 iterations were performed. The most recent value obtained for x is stored in X. (This setting shouid never occur.)

IND = —7 Iteration failed. No value is given for 2. This may occur when zw.

IND = —8 A value for z is stored in X, but the routine is not certain of its

accuracy. Iteration cannot be performed in this case. This can eccur only when p Oorg 30

**Remarks.** Schroder iteration is normally used. On the CDC 6000-7000 series computers 4 or fewer interations are required.

**Programming.** DGINV employs the subroutines GAMINV, GRATIO, PNI, DGR17, DPNI, DGR29, and DGRAT, and functions RCOMP, DRCOMP, SPMPAR, DPMPAR, EXPARG, DXPARG, REXP, DREXP, ALNREL, DLNREL, RLOG, DRLOG, DSINi, ERF, EFRC1, DERF, DERFC1, DEFRCO, ERFI, DERFI, GAMMA, GLOG, GAM!, GAMLN, DGAM1, GAMLNI, DGAMMA, DPDEL, DGAMLN, DGMLN1, and IPMPAR. DGINV was written by A. H. Morris.


<small>Original source: [View scanned PDF page 76](../scans/page_0076.png)</small>

<a id="topic-076-01"></a>
### Logarithm Of The Beta Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [`L12704`](../source_parts/nswc_part_02.f#L2055) |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [`L12892`](../source_parts/nswc_part_02.f#L2243) |


For a,b > 0 the beta function B(a,b) can be defined by

1 B(a,b) = / e711 — t)?) de. 0 From this it follows that B(a,b) = ['(a)I'(b)/T(a + 6) where ['(a) is the gamma function. The functions BETALN and DBETLN are available for computing In B(a,b). DBETLN is a double precision function.

BETALN(a, 5) BETALN(a, 6) = In B(a, d) for a,b > 0.

**Algorithm.** See pages 19-21 of the reference.

**Precision.** BETALN(a,}) is accurate to within 4 units of the 14!" significant digit when a,b > 1 and BETALN(a, b) ¥ 0. In particular, when a,b > 15, BETALN(a, 6) is accurate to within 2 units of the 14‘ significant digit.

**Programming.** BETALN employs the functions ALNREL, ALGDIV, BCORR, GAMLN, GAMLNI1, and GSUMLN. These functions were written by A. H. Morris.

**Reference.** DiDonato, A. R. and Morris, A. H., “Algorithm 708 Significant Digit Computation of the Incomplete Beta Function Ratios,” ACM Trans. Math Software 18 (1992), pp. 360-373.

```fortran
DBETLN(A0, B0)
```

The arguments a and b are positive double precision numbers. DBETLN(a, 8) is the double precision value for In B(a,}).

**Remark.** DBETILN must be declared in the calling program to be of type DOUBLE PRECISION,

**Algorithm.** Vhe algorithm for In B(a, 6) on pages 19-21 of the reference is used. A(z} is computed by the power series corresponding to the Chebyshev expansion in the SLATEC library given by Wayne Fullerton (Los Alamos). The power series was obtained by A. H. Morris

**Programming.** DBETLN employs the functions DUNREL, DLGDIV, DBCORR, DPDEL, DGAMLN, DGMLN1, DGAMI and DGSMLN. These functions were written by A. Tl. Morris. The function DPMPAR is also used.

**Reference.** Diljonato, A. KR. and Morris, A. f., “Algorithm 708 Significant: Digit Compo:

tation of the Incomplete Het. Function Ratios,” ACM Trans. Math Software 18 P£OQ2), pp. 860-378.


<small>Original source: [View scanned PDF page 77](../scans/page_0077.png)</small>

<a id="topic-077-01"></a>
### Incomplete Beta Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [`L14952`](../source_parts/nswc_part_02.f#L4303) |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [`L15431`](../source_parts/nswc_part_02.f#L4782) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [`L15905`](../source_parts/nswc_part_02.f#L5256) |


For a,b > 0 and O < x < 1 the incomplete beta fuzction is defined by

1

-—_- ° a—lfy _ 4\b-1 I, (a,b) = aan | t (1-4)? dt

where B{a,5) is the beta function. Then we note that 0 < J,(a,b} < 1 and

```text
lim, I,(a,b) = 1 for zr #0
lim f,(a, 6) =: 0 for x # 1.
```

These limits permit [,(a,b) to be defined to be i when a = C and b ¥ 0,z ¥ O, and for I, (a,b) to be defined to be 0 when b = O and a # 0,z # 1. The subroutine BRATIO is available for computing I,(a,b) for arbitrary a,b > 0, and the subroutine ISUBX is available for computing I,(a, 6) for the highly specialized case +i on a and 6 are integers or half-integers. Also, the auxiliary function P*:\COMP is provided for computing x?y°/B(a,b) when O<2<landy=1-z.

```fortran
CALL BRATIO(A, B, X, Y, W, W1, IERR)
```

It is assumed that a > 0,6 > 0,0 < x < 1, and y=1- 2. W, W1, and IERR are variables. If no input errors are detected then IERR is set to 0, W is assigned the value I,(a,6), and W1 is assigned the value 1 -- [,(a, 6).

**Error Return.** When an input error is detected, then W and W1 are assigned the value 0 and IERR is set to one of the following values:

IERR = bifa<O0orb<0

TERR = 2 ifa=b=0

IERR = 8 ifs<Oorx> 1

IERR = 4 ify <Oory> 1

IERRs« 5 frty fl

TERR = 6 fe sae 0

IERR - 7 if yes 6 O Programming. BRATIO employs the subroutines BURAT and GRATI, and the funetions ALGDIV, ALNREL, APSER, BASYM, BCORR, BETAUN, BFRAC, BPSER, BR.- COMP, BROMPI, BUP, ERF, ERFCL, FPSER, GAMLN, GAM™UNI, GAMI, GSUMLIN. PST, bSUM, PXPARG, ReXP, and RLOGI. These subroutines an functions were written by A. HL. Morris. The functions SPMPAR and IPMEPAR are also ust

**Reference.** DiDonato, A. Ro ai Morris, A. HL, “Algorithm 708 Signi: ant Digit Compa tatiog of the fucamiplete Geta Paunction Ratios,” ACM Trans, Mth S ‘tware t8 PEGgy, pp. 360.373


<small>Original source: [View scanned PDF page 78](../scans/page_0078.png)</small>

```fortran
CALL ISUBX(A0, B0, X0, P, IERR, EPS)
```

```text
It is assumed that a,b, and x satisfy the following restrictions:
(1) a>0,6>0,andz2>0
(2) a > 1/2,1/2<b6<70,andz<1
(3) @ and 6 are integers or half-integers
```

EPS specifies the (absolute) accuracy that is desired. W is a real variable and IERR an integer variable. When ISUBX is called, if there are no input errors then W is assigned the value I,(a,6} and IERR is assigned the value 1.

**Error Return.** If an error is detected then IERR is assigned one of the following values:

```text
TERR = 2 if restrictions (1) are violated.
IERR = 3 if restrictions (2) are violated or a is too large.
IERR = 4 if re:irictions (3) are violated.
```

Also W is assigned the value 0. Remarks. ISUBX was designed for a maximum precision EPS = 10~!°

**Programming.** ISUBX employs the functions ALGDIV, ALNREL, BLND, IPMPAR, and LOGAM. ISUBX was written by A. H. Morris.

**Reference.** DiDonatc, A. R. and Jarnagin, M. P., “The Ffficient Calculation of the Incomplete Beta-function Ratio for Half-Integer Values of the Parameter a,b,” Math Comp. ‘1 (1967), pp. 652-662.

BRCOMP (a, b, x, y) BRCOMP(a, 6, z, y) =: z7y’ ‘B(a,8) for a,b > O and z,y 2» O where r+y = 1. Algorithm. See pages 19-21 of the reference. Programming. BRCOMP emplcys the functions ALGDIV, ALNREL, BCORR, BETALN, GAM1, GAMLN, GAMLNI, GSUMLN, and RLOG1. ‘These functions were written by A. ti, Morris. Reference. DiDonato, A. Rt. and Morris, A. tt, “Algorithm 708 Significant Digit Compu-

tation of the Incomplete Beta Funciion Ratios.” ACM Trans. Math Software 18 (1992), pp. 360 373,


<small>Original source: [View scanned PDF page 79](../scans/page_0079.png)</small>

<a id="topic-079-01"></a>
### Bessel Function J_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [`L16274`](../source_parts/nswc_part_02.f#L5625) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [`L16890`](../source_parts/nswc_part_02.f#L6241) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [`L17194`](../source_parts/nswc_part_02.f#L6545) |


If vy is complex then J,(z)} is defined by

wt kIT (v +k + 1)

for any z # 0 in the complex plane cut alorg the negative real axis. J,(z) is analytic in the region. jarg(z)| < 2, and J,(z) is an entire functior of v for any fixed z. J,(z) can be exiended to the negative real axis by letting ~m < arg(z) < x. If v is an integer then J,,(z) is also detined at O and is an entire function of 2. The following subroutines are available for computing J,{z).

```fortran
CALL CBSSLJ(Z, CNU, W)
```

The arguments z and v are complex numbers and w is a complex variable. It is assumed that z #0. When CBSSL, is called, w is assigned the value J,(z).

**Precision.** The real and imaginary parts of w are normally accurate to 11-12 significant digits when Re[J,(z)} and Im)J,(z)] are not near 0. The only exception tc this is when Re(z) x 0, Im(v) = 0, and 14 < jz! < 17.5+}4)v|?. Then Re(w) is accurate to 11-12 significant digits, but all accuracy for the small nonzero value Im(w) may be lost.

**Algorithm.** A modification of the Hershey procedure for applying the Maclaurin, Debye, and asymptotic expansions is used.

Programmimg. CBSSLT emopioys the subroutines CREC, CGAMMA, CBJM, CBDB, CBJA aid functions (PPMPAR, SPMPAR, CPABS, CDIV, EXPARG, REXP, SIN1, COS], CGAMO, GAMMA, GLOG, CBSSLJ was written. by Andrew H. Van Tuyl and A. H. Morris.

**Reference.** Hershey, A. V., Computation of Special Functsons, Report TR-3788, Naval Surface Weapons Center, Dahlgren, Virginia, 1973, pp. 33-42.

```fortran
CALL BSSLJ(A, IN, W)
```

The argument 7 is a complex number, n is an integer, and w is a complex variable. When BSSL,i is called, w is assigned the value J,,(z).

**Precision.** BSSLJ is accurate to within 5-10 !4 for realO <2 < 35 andn 0,1.

**Programmer.** A.V. Hershey

**Reference.** Hershey, A. V., Computation of Special Functione, Report TR-3788, Naval Surface Weapons Center, Dahlgren, Virgima, 1978.


<small>Original source: [View scanned PDF page 80](../scans/page_0080.png)</small>

```fortran
CALL BESJ(X, ALPHA, N, Y, NZ)
```

The arguments z and @ are nonnegative real numbers, n is a positive integer, and W is an array of dimension n or larger. When BESJ is called J.4,;-1(z) is computed and stored in W(t) forf=1,...,n.

The argument k is an integer variable that is set by the routine. If all Ja4;—1(z) are computed then k is set to 0. Otherwise, k is assigned cne of the following values:

k = ~—1 The argument z is negative.

k == ~2 The argument a is negative.

k = -—3 The requirement n > 1 is violated.

k> 0 The last k components of W have Leen set to 0 because of underflow,

**Precision.** For 0 < z < 35 and 0 < a < 1, BESJ is accurate to within 8- 107?%.

**Programming.** BESJ calls the subroutines ASJY and JAIRY, and the functions GAMLN, SPMPAR, and IPMPAR. The subroutines were written by Donald E. Amos, Sharon L. Daniei, and M. Katherine Weston (Sandia Laboratories).

**References.**

(1) Amos, D.E., Daniel, S. L., and Weston, M. K., CDC 6600 Subroutines for Bessel Functions J,(z),z > 0,v > Oand Atry Functions A,(z),Ai(x),—0o < < oo. Report SAND 75-0147, Sandia Laboratories, Albuquerque, New Mexico, 1975.

(2) ee , “CDC 6600 Subroutines IBESS and JBESS for Bessel Functions I, (x) and J,(z),z2 > 0,v > 0,” ACM Trans. Math Software 3 (1977), pp. 76-92.


<small>Original source: [View scanned PDF page 81](../scans/page_0081.png)</small>

<a id="topic-081-01"></a>
### Bessel Function Y_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [`L18448`](../source_parts/nswc_part_02.f#L7799) |


If » is any complex number not an integer, then Y,(z) can be defined by

_ JL(z) cosux — J_,(z)

YL(z) =

sin vr

for any z # O in the complex plane cut along the negative real axis. For any lateger n we can also define Y,,(z) = lim Y,(z). Then for any complex v, Y,(z) is analytic in the region von

jarg(z)| < x. Also, Y,(z) is an entire function of v for any fixed z. The following subroutine is available for computing Y,(z) when rv is an integer.

```fortran
CALL BSSLY(A, IN, W)
```

The argument z is a complex number, n is an integer, and w is a complex variable. It is assumed that larg(z)| < *. When BSSLY is called, w is assigned the value Y,,(z).

**Precision.** If .005 < z < .785 then Yo(z) and Yi (x) are accurate to within 3 units of the 14' significant digit. Otherwise, if z > .785 then Yo(z) and Y;(z) are accurate to within 4-107%4,

**Programmer.** A. V. Hershey

**Reference.** Hershey, A. V., Computation of Spectal Functions, Report TR-3788, Naval Surface Weapons Center, Dahlgren, Virginia, 1978.


<small>Original source: [View scanned PDF page 82](../scans/page_0082.png)</small>

<a id="topic-082-01"></a>
### Modified Bessel Function I_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [`L18758`](../source_parts/nswc_part_02.f#L8109) |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [`L18788`](../source_parts/nswc_part_02.f#L8139) |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [`L19112`](../source_parts/nswc_part_02.f#L8463) |


If v is complex then [,,(z) is defined by (z/2) yytek H(z) = 3 <kID(y +k +1)

for any z # 0 in the complex plane cut along the negative real axis. J,(z) is analytic in the region |arg(z)| < 7, and I,(z} is an entire function of v for any fixed z. [,(z) can be extended to the negative real axis by letting —x < arg(z) < m. If v is an integer then J,,(z) is also defined at (C and is an entire function of z. The following subroutines are available for computing J,,(z).

```fortran
CALL CBSSilI(z,, w)
```

The arguments z and v are complex numbers and w is a complex variable. It is assumed that z #0. When CBSSLI is called, w is assigned the value /,(z).

**Algorithm.** The evaluation of J,,(z) is reduced to J,(z) using

I,(z) = evri/2 J, (ze™ **/?) ~B< arg(z) <m T(z) eo ¥™? JT (ze™/?) - aw < arg(z) < §.

**Programming.** CBSSLI calls the subroutine CBSSLJ and functions EXPARG, COSI], and SINT. Also, the functions and subroutines needed for CBSSLJ are used. CBSSLI was written by Andrew H. Van ‘Puyl and A. H. Morris

CALL BSSLI(MO, z,n, w) MO ts an integer, z a complex number, n an integer, and w acomplex variable. If MO f O then it is assured that jarg(z)}) «oo. When BSSLI is called, w is assigned the value

Liz} afMO | O and the value e 7/,(z2) 1f MO 7/9

Precision, BSSL!is accurate to withip 5 unite of the 18" significant dipit for realO <2 - and nm O,1,... AU.

**Programmer.** Allen V. Hershey

**Reference.** Hershey, A. V., Computation of Spectal Furicttona, Report TR-38788, Naval Sorface Weapons Center, Dahleren, Virginia, (978,

```fortran
CALL BESI(X, ALPHA, KODE, N, Y, NZ)
```

MO ormay be bor 2.) The crguments rand @ are nonnegative ceal mumaibers, ris a

positive integer, and ous an array of dimension mn or farger. When BiSt is called, if MEO


<small>Original source: [View scanned PDF page 83](../scans/page_0083.png)</small>

= 1 then [,4,-1(7) is computed and stored in W(t) for? = 1, ...,n. Otherwise, if MO = 2 then e~*/y4.4-1(z) is computed and stored in W(t}

The argument k is an integer variable that is set by the routine. If all Ja4,-1(z) or ¢-*I.44-1(z) are computed then k is set to 0. Otherwise, k is assigned one of the following values:

if]

= —l The argument z is negative. =: —2 The argument a is negative. - ~8 The requirement n > i is violated. —4 MO is not 1 or 2. = -5 The argument z is too large for MO = 1. > 0 The last k components of W have been set to 0 because of underflow.

i

i

k k k k k k

**Precision.** For 0 < 2 < 35 andO <a <l,or0 <2 < 35 and a= 1,2...,40, i,(z) is accurate to within 2 units of the 12‘ significant digit.

**Programming.** BESI calls the subroutine ASIK and the functions GAMLN, SPMPAR, and IPMPAR. BESI and ASIK were writien by D. E. Amos and S. L. Daniel (Sandia Laboratories).

**References.**

(1) Amos, D. E. and Daniel, S. I., A CDC 6600 Subroutine for Bessel Functions I,(z),v > 0,2 > 0. Report SAND 75-0152, Sandia Laboratories, Albuquerque, New Mexico, 1975.

(2) Amos, D. E., Daniel, S. L., and Weston, M. K., “CDC 6600 Subroutines [BESS and JBESS for Bessel Functions I, (rx) and J,(x), r > 0, v > 0,” ACM Trans. Math Software 3 (1977), pp. 76-92.


<small>Original source: [View scanned PDF page 84](../scans/page_0084.png)</small>

<a id="topic-084-01"></a>
### Modified Bessel Function K_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [`L19701`](../source_parts/nswc_part_02.f#L9052) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [`L20214`](../source_parts/nswc_part_02.f#L9565) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [`L20599`](../source_parts/nswc_part_02.f#L9950) |


If v is any complex number not an integer, then K,{z) is defined by

(*) K,(z) = 7 ee) -L@)

2 sin vr

for any z # 0 in the conplex plane cut along the negative real axis. For any integer n we can also define K,,(z) = lim K,(z). Then for any complex v, K,(z) is analytic in the von

regien |arg(z)| < a. Also, AK,(z) is an entire function of v for any fixed 2. K,(z) can be extended to the negative real axis by letting —*x < arg(z) < . The following subroutines are available for computing K,(z).

```fortran
CALL CBESK(Z, CNU, W)
```

The arguments z and v are complex numbers and w is a complex variable. It is assumed that z #0. When CBESK is called, w is assigned the value K,{z).

**Algorithm.** A,(z) is computed using (+), the asymptotic expansion

/ Ke) = (Fo) eth + Seay) 4

”) (4v? — 1) --- (4v? — (2k - 1)?) (0) eg

the relation

(2) Keyile) = 2 KV(2) + Reale)

along with the Miller algorithm and the power series Ki(z) - 32 cafe and K,41(z) k>O

€ “a

>> ce(pe ~ Kfe) given in the references, and the analytic continuation formulae a k>O

Ky{z) -e °K fe 2) -ami(e ™2z) (0 < arg(z) < 7)

Ky{z) oe’ KK (e"'z) + andy (e™*z) ( a + argfz) < 0). Precision. Frequently, 11 18 digit accuracy is obtained. Fer 10 ? © Jz) < 50, CBESK maintains accuracy to within 3 units of the 8"? significant digit except when RelA, (2)! or Im|{K L(2)] is near O, or occasionally when 2 is on the negative real axis. Leta atarae For 50 < lz) < 100, Refw) and Jm(w) are normally accurate to within 3 uniis of the 8" significant digit when, ™ Land ro 1/2. However, for £/2. 7) Land v not real, aeecurarcy gracually decreases as jz] iicreases.

‘

Programming, CBESK employs the subroutines CBHKA, CBKI, CBRM, CBA ATE, CAPS,


<small>Original source: [View scanned PDF page 85](../scans/page_0085.png)</small>

CGAMMA, CBSSLI, CBSSLJ, CREC and functions CDIV, CG AMO, COSO, COSI, SINO, SINI, CPABS, CXP, EXPARG, SPMPAR, IPMPAR. Also, the functions and subroutines needed for CBSSLJ are used. CBESK was written by Andrew H. Van Tuyl and A. H. Moiris.

**References.**

(1) Amos, D.E., Computation of Bessel Functions of Complex Argument, Report SAND 83-0086, Sandia Laboratories, Albuquerque, New Mexico, i983.

(2) Temme, N.M., “On the Numerical Evaluation of tne Modified Bessel Function of the Third Kind,” J. Comp. Physics 19 (1975), pp. 324--337.

```fortran
CALL CBSSLK(Z, R, W)
```

The argument z ig a nonzero complex number, ¢ 2 real number, and w a complex variable. When CBSSLK is called, w is assigned the value K,(z).

**Algorithm.** The algorithm employed by CBESi. is used. For real r, (+) is not needed.

**Programming.** CBSSLK employs the subroutines CBSSLJ, CKA, CKM, CKML, CREC and functions CPABS, COSO, CXP, GAM1, SINO, SPMPAR, IPMPAR. Also, the functions and subroutines needed for CBSSLJ are used. CBSSLK was written by Andrew H. Van Tuyl and modified by A. H. Morris.

```fortran
CALL BSSLK(MO, A, IN, W)
```

MO is an integer, z a complex number, n an integer, and w a complex variable. It is assurnea that |arg(z)| < *. When BSSLK is called, w is assigned the value K,,(z) if MO = 0 and the value e*A{,(z) if MO # 0.

**Precision.** BSSLK is accurate to within 6 units of the 14'* significant digit for real z and n-=-0,1.

**Programmer.** Allen V. Hershey.

**Reference.** Hershey, A. V., Computation of Special Functions, Report TR-37868, Naval Surface Weapons Center, Dahlgren, Virginina, 1978.


<small>Original source: [View scanned PDF page 86](../scans/page_0086.png)</small>

<a id="topic-086-01"></a>
### Airy Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [`L20840`](../source_parts/nswc_part_02.f#L10191) |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [`L21168`](../source_parts/nswc_part_03.f#L1) |
| `AI` | `REAL FUNCTION` | `X` | [`L21877`](../source_parts/nswc_part_03.f#L710) |
| `AIE` | `REAL FUNCTION` | `X` | [`L21969`](../source_parts/nswc_part_03.f#L802) |
| `BI` | `REAL FUNCTION` | `X` | [`L22065`](../source_parts/nswc_part_03.f#L898) |
| `BIE` | `REAL FUNCTION` | `X` | [`L22198`](../source_parts/nswc_part_03.f#L1031) |


3

For any series w = ‘°° a,z" satisfying the differential ecuation w” = zw, it follows y La a

```text
n=0
that w = aof(z) + aig(z) where
```

1-4-+:(8n~2) ¢ z) = 1+ 35 -——. 7 He) n>1 (3n)!

g(z) = 1+ ESET

In particular, the Airy functions As(z) and Bi(z) are independent solutions of w” = zw where

Ai(z) = e1f(2) ~ ca9(2)

Bi(z) = v3 lei f(z) + c2g(z)]

for cy = 377/3/[(2/3) and cg = 371/3/P(1/3). Ai(z) and Bi(z) are entire functions.

The subroutines CAI and CBI are available for computing At(z) and Bi(z) when z is complex, aid the functions AI, ATE, BI, and BIE are available for computing A1(z) and Bi(z) when z is real. CAI and CBI also provide the dervatives Ai’(z) and Bi'(z) of Ar(z) and Bi(z).

```fortran
CALL CAI(IND, Z, AI, AIP, IERR)
```

IND is an integer, z a complex number, and w and w’ complex variables. When CAI is called, w is assigned the value As(z) and w’ the value At’(z) when IND = 0. Otherwise, if IND #0 then w = eS Ai(z) and w! = ef Ai'(z) where ¢ = 2239/2,

LERR is a variable that is set by the routine. When CAI terminates, IERR has one of the following values: tERR =: O The desired values were obtained. IERR = 1 z ts too large for the desired values to be computed. In this case w and wu’ are assigned the value 0. Precision. Fur IND 4 0 the real and imaginary parts of w and w’ are accurate to within 2 units of the '2'* significant digit except near points where they vanish.

**Programming.** CAI employs the subroutines AIRM, AIl, ATA, JA, oMC, BIM, KA, KML, IMC, and BIM. These routines were written by Andrew HE Van Tuy) and modified hy A. Uy Merris. The subroutines CAPO and CREC, and functions CPABS, EXPARG, IPMPAR, and SPMPAR are also used.

```fortran
CALL CBHIND 2,w, wu’ IRAN)
```


<small>Original source: [View scanned PDF page 87](../scans/page_0087.png)</small>

IND is an integer, z a complex number, and w and w’ complex variables. When CBI is called, w is assigned the value Bi(z) and w’ the value Bs’(z) when IND = 0. Otherwise,

if IND #0 then _ { eS Bi(z) — if jarg(<)| < 1/3 ~ | eS Bi(z) otherwise _ { e~SBi'(z) if jarg(z)| < 1/3 ~ | ef Bi'(z) otherwise

where ¢ = 2 8/2

IERR is a variable that is set by the routine. When CBI terminates, IERR has one of the following values:

TERR = 0 The desired values were obtained. IERR = 1 z is too large for the desired values to be computed. In this case w and w’ are assigned the value 0.

**Precision.** For IND # 0 the real and imaginary parts of w and w’ are accurate to within 2 units of the 12" significant digit except near points where they vanish.

**Programming.** CBI employs the subroutines AIRM, BII, BIA, IA, IMC, BIM, JA, JMC, and BJM. These routines were written by Andrew H. Van Tuy! and modified by A. H. Morris. The subroutine CREC and functions CPABS, EXPARG, IPMPAR, and SPMPAR are also used.

Al(z)

Al(z) = At(z) for real 2.

**Algorithm.** Rational minimax approximations are used. If x < —1 then R and @ are computed where At(x) = 2 sin(a/4-+ 8).

**Precision.** For xc > - J, Al{z) is accurate to within 2 units of the 12¢" significant digit when » All g &

Al(z) #0.

**Programming.** Al calls the subroutine AIMP and function EXPARG. These subprograms were written by A. H. Morris. The function IPMPAR is also used.

```fortran
AIE(X)
```

Ifx > Othen AlM(2} > e At(z) where ¢ = 39/7. Otherwise, if 2 < 0 then AIF (2)

Algorithm.. tabhonal minimax approximations are used. Ifa « Lthen Wand @ are computed where Artix) HR sinfoe /4 i @).

**Precision.** Fora > t, Allez) is accurate to within 2 units of the ¢4°? sipifteant cigit

i0O


<small>Original source: [View scanned PDF page 88](../scans/page_0088.png)</small>

**Programming.** AIE calls the subroutine AIMP. AIE and AIMP were written by A. H. Morris.

Bi(z)

BI(z) = Bi(x) for real z. If z is a positive value for which Bi(z) is too large to be computed, then BI(z) is assigned the value 0.

**Algorithm.** Rational minimax approximations are used. If 2 < —1 then R and @ are computed where B1(r) = R cos(x/4 + 8).

**Precision.** For z > —1, BI(z) is accurate to within 2 units of the 12** significant digit when Bi(z) # 0.

**Programming.** BI calls the subroutine AIMP and function EXPARG. These subprograms were written by A. H. Morris. The function IPMPAR is also used.

```fortran
BIE(X)
```

If zc > 0 then BIE(z) = e~$ Bi(z) where ¢ = 223/?. Otherwise, if x < 0 then BIE(z) = Bi(z).

**Algorithm.** Rational minimax approximations are used. If 2 < --1 then R and @ are computed where Bi(x) = R cos(x/4 + 9).

**Precision.** For z > ~—1, BIK(z) is accurate to within 2 units of the 14‘ significant digit.

**Programming.** BIE calls the subroutine AIMP. BIE and AIMP were written by A. H. Morris.

10i


<small>Original source: [View scanned PDF page 89](../scans/page_0089.png)</small>

<a id="topic-089-01"></a>
### Complete Complex Elliptic Integrals Of The First And Second Kinds

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CK` | `COMPLEX FUNCTION` | `K, L` | [`L22419`](../source_parts/nswc_part_03.f#L1252) |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [`L22752`](../source_parts/nswc_part_03.f#L1585) |


If k is complex then the complete elliptic integrals of the first and second kinds can be defined by

x/2 K(k) = i (1 — k? sin?t)~1/? de ) x/2 E(k) = / (i — k® sin?t)!/? de o for jarg(1 — k?)| < m. K(k) and E(k) can be extended to - < arg(1—k?) < x. Foz |k| <1

K(k) = So enk™

(1 - 1 n kin Bb) = — 9 Do ong 7 n>0 2n)! , where cy = ry . Also, if €? = 1 ~- k? where |€} < 1 and —x < arg(é”) < a, then ni

(2) B(k) = =[K (0) ~ B(0)] loge

m: noo

K(k) = K(O Ing - Seen re m(om 1) n en - 2

n>! ~ a sy cn D ay 2a ey =f -1 rif (2m - 1) t

_

The function CK js available for computing A (k), and the subroutine CK for computing K(k} and E(k).

CK (k, €)

CK(k, @) = K(k) for any complex k aud @where k? | #?) Land £4 0. CK is acomples valued function which must be declared in the calling program to be of type COMPLEX,

**Error Return.** CK(k. 0) Of For kh? OAD.

```text
Remarks.
(1) CK(A, &) may underflow, yielding the value O, when [Al is sufficiently large
(2) CI and the subroutine CAE employ the same algorithm for A (4)
```

1038


<small>Original source: [View scanned PDF page 90](../scans/page_0090.png)</small>

**Precision.** If k is real and |k| < 1 then the relative error of CK is less than 10715. Also, if k is purely imaginary then the relative error is less than 10738. K(k) is real-valued for only these values of k. Otherwise, let ex = 1071? if |k| < 0.8,¢, = 2- 10713 if 0.8 < |k| < 2, and €, = 107}8 if |k| > 2. Then the relative errors of the real and imaginary parts of CK are less than €, except when underflow occurs, |k| < 1 and |arg(+:k)| < 107787, or |k{ < 1035 and |x/2—~— arg(tk)| < 10~*8°. In the latter two cases the relative error of the real part of CK is less than €,, but all relative accuracy for the imaginary part may be loss.

**Programming.** CK calls the subroutine KL and functions ALNREL, CFLECT, KM, and SPMPAR. Ck, KL, and KM were written by Andrew H. Van Tuy! and modified by A. H. Morris.

```fortran
CALL CKE(K, L, CK, CE, IERR)
```

The arguments k and @ are complex number: where k? + €? = 1 and £7 0,K and E are complex variables, and [ERR an integer variavie. When CKE is called, if no errors are detected then TERR is set to 0, K is assigned the value K(k), and E is assigned the value

**Error Return.** IERR = 1 if €= 0 and IERR = 2 if k? + @? #1. In these cases, K and EF are not detined.

**Algorithm.** For & = 0 or ~1/2 < arg(k) < «/2, formulae (2) are used if |é| < .55, (1) are used if |@| > .55 and |kj < .55, and approximations of the form N

Na, K(k) = £7 5 Para

N . bak b,k ae | .

are t ed af [@) > 65 and .55 > [k] ~ Lo (3) are obtained from integral representations for K(k) and i(k) by numerical quadrature. If }é| > .55,|k] > 1, and [k] « |@ thes (4) (kK) B(k Y/e, fy. ii? are apphed where the sign in Ay is selected so that) ow/2 © arg(k1) + mf2. Otherwise, if

OL HS, TR) 1, and [AL + [A det xy I/k and @y pr€/k where the sipm is selected su that 2/2 < arg(#,) > 2/2. Then A(A) fyov(ky) ps A(e,)| (5) Athy) FP AAS) as (h(E) ADI (ELD)


<small>Original source: [View scanned PDF page 91](../scans/page_0091.png)</small>

```text
are applied where ¢ = 1 if Im(k) > O and 9 = ~1 if Im(k) < 0. If arg(k) > 2/2 or
arg(k) < —7/2, then K(k) = K(~k) and #(k) = E(--k) are applied.
```

**Precision.** If & is real and {k| < 1, or & is purely imaginary, the he relative crror of /y is less than 107'8. #k) is real-valucd for only these values of k. Otherwise, let ¢, = 10°}? if of E are less than e, except whvu wadertlow occurs, [k| < 1 and jarg(+:&)| < 10°78, or [kj < 104® and | /2— arg(t+k)| ~ 107?®°. In the latter two cases the relative error of the real part of @ is teas than 2,, but all relative accuracy for the imaginary part may be lost.

**Programming.** CKE calls the subroutines EKI, and EKM, and the functions ALNREL, ATN, CF’ ECT, and SF MPAR. CKE wa: written by Andrew H. Van Tuyl,


<small>Original source: [View scanned PDF page 92](../scans/page_0092.png)</small>

<a id="topic-092-01"></a>
### Real Elliptic Integrals Of The First And Second Kinds

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [`L23163`](../source_parts/nswc_part_03.f#L1996) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [`L23296`](../source_parts/nswc_part_03.f#L2129) |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [`L23554`](../source_parts/nswc_part_03.f#L2387) |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [`L23664`](../source_parts/nswc_part_03.f#L2497) |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [`L23774`](../source_parts/nswc_part_03.f#L2607) |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [`L23895`](../source_parts/nswc_part_03.f#L2728) |


1°0 < $< w/2, then the elliptic integrals of the first and second kinds are defined by

$ F(¢,*) =| (1 — k? sin?t)~'/? at 0

¢ E($¢,k) = | (1 ~ k* sin?t)!/? dé 0 for any real k wh ce k? < 1 and 1— k? sin?g #0. Alternatively, we may consider l oO Rp a,b,c) 5 / [( + @)(t-+ 8)(E + c)}~1/? de 0 where a,b,c wre nonnegative and at mos. one of them is 0, and 3 “ i « Rp(a, b,c) == 5 / (t+ a)~ 2 (t + by 2 (t 4 ec) 9/? at JO

where a and 6 are nonnegative such that a+ > 0, and ¢ 1s positive. [fa <b <canda<c then

ect? Bc 8/4 [ apaoy

where cos & = afe and k? = (¢ ~ b)/(e ~ a). If @ = 2/2 then the integrals F(¢,&) and E(¢,k} ary said to be complete. Otherwise, if ¢ < w/2 then the integrals are said to be tncompi-te. The subroutines ELLPI, REVAL, RDVAL, DELLPI, DREVAL, and DRDVAL are available for computing £'(¢,&), E(¢,k), Re(a,6,c) and Rp(a,d,c). DELLPIL, DREVAL, and DRDVAL are double precision routines.

```fortran
CALL ELLP.(¢, ok. ¢ F, 2, IERR)
```

The arguments ¢, y,4, @ are rear numbers which satisfy ¢ - O.y * O,@ 1 bo #/2, and k? | @? 1. Also. if yp 9 06 then it is assumed that @ f O. FF) and TERR are variables When ELLPHis called. if ue input errors are detected then TREAT as set to 0, Fis assigned

the value #(¢, kj, aud /7 is assigned the value H(¢, k)

**Error Return.** Fo an input error is detected then PRR is set os lows: IERR - i @< 0 wy. 0 JERR . 2 jAl co) Toor if) > 1 IERR - S Ww Oand @> 0


<small>Original source: [View scanned PDF page 93](../scans/page_0093.png)</small>

**Precision.** ELUPI is accurate to within 4 units of the 14" significant digit.

**Programming.** ELLPI calls the functions ALNREL and CPABS. ELLPI was written by Allen V. Hershey and modified by A. H. Morris.

**Reference.** DiDonato, A. R. and Hershey, A. V., “New Formulas for Computing Incomplete Elliptic Integrals of the First and Second Kind,” JACM 6 (1959), pp. 515-526.

```fortran
CALL RFVAL(X, Y, Z, RF, IERR)
```

The arguments 2, b,c are nonnegative real numbers, only one of which can be 0. IERR and w are variables. When RFVAL is called, if no input errors are detected then IERR is set to 0 and w is assigned the value Rp(a, b,c).

**Error Return.** If an input error is detected then IERR has one of the following values: IERR = 1 Either a,b, or c is negative.

```text
IERR = 2 Either a+ 6,a+c, or b+ ¢ is too small.
IERR = 3 Either a,b, or c is too large.
```

**Precision.** RFVAL is accurate to within 4 units of the 14" significant digit.

**Programming.** REVAL was written by B. C. Carlson and Elaine M. Notis (Iowa State Universit: \, and modified by A. H. Morvis. The function SPMPAR is used.

**References.** (1) Carlson, B. C., “Computing Elliptic Integrals by Duplicstion,” Numertsche Mathematik 33 (1979), pp. 1-16. and Notis, E. M., “Algorithm 577. Algorithms for Incomplete Eiliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398-403.

(2)

```fortran
CALL RDVAL(X, Y, Z, RD, IERR)
```

The arguments a and 6 are nonnegative real numbers where a + 6 > 0, anJ «is a positive real number. JERR and w are variables. When RDVAL is called, if no inpus error. are detected then JERR is set to O and w is assigned the value Rp(a, b,c).

**Error Return.** If an input error is detected then HERR has one of the following values:

IERR = | Either a,6, or ¢ is negative. JERR 2 Either a-+ 6 or ¢ is too small. [ERR - 3 Either a,b, or ¢ is too large.

Precision. RDVAL is accurate to within 4 units of the 14" significant digit

**Programming.** RDVAL was written by B.C. Carlson and Klaine M. Notis (Iowa State University), and modified by A. H. Morris. The function SPMPAR is used.


<small>Original source: [View scanned PDF page 94](../scans/page_0094.png)</small>

**References.**

(1) Carlson, B. C., “Computing Elliptic Integrals by Duplication,” Numertsche Mathematik 33 (1979), pp. 1-16.

(2) and Notis, E. M., “Algorithm 577, Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398-403.

```fortran
CALL DELLPI(PHI, CPHI, K, L, F, E, IERR)
```

The arguments ¢, ), k, £ are double precision numbers where ¢ > 0, > 0,¢+-p = 7/2, and k? + é? = 1, Also, if » =O then it is assumed that @4 0. F and E are double precision variables, and IERR is an integer variable. When DELLPI is called, if no input errors are detected then IERR is set to 0, F is assigned the double precision value for F({¢,k), and # is assigned the double precision value for E(¢, k).

```text
Error Return. If an input error is detected then IERR is set as follows:
IERR = 1¢<O0ory<0O
IERR = 2 |k| > 1 or [i > 1
IERR = 3 py =Oand @=0
```

**Precision.** DEI LPI is accurate to within 5 units of the 28'" significant digit.

**Programming.** DELLPI employs the functions DCPABS, DLNREL, and DPMPAR. DELLPi was written by Allea V. Hershey and modified by A. H. Morris.

**Reference.** DiDonato, A. R. and Hershey, A. V.,“New Formulas for Computing Incomplete Elliptic Integrals of the First and Second Kind,” JACM 6 (1959), pp. 515-526.

```fortran
CALL DRFVAL(X, Y, Z, RF, IERR)
```

The arguments a,6,c are nonnegative double precision nuinbers, only one of which can be 0. TERR is an integer variable and w a double precision variable. When DRFVAL is called, if no input errors are detected then IERR is set to 0 and w is assigned the double precision value for Rr(a, 6,c).

**Error Return.** if an input error is detected then JERR has one of the following values:

```text
IERR = 1 Either a,6, or c is negative.
TERR =: 2 Either a + 6,a-+ c, or 6 ¢ cis too small.
IERR =: 3 Either a, 6, or ¢ is too large.
```

**Programming.** DRFVAL was written by B.C. Carlsou and Blaine M. Notis (lowa State University), and modified by A. H. Morris. The function DPMPAR is used.

**References.** ‘farlson, B. C., “Computing Elhptic Integrals by Dupheation,” Nurmerssche Mathei) Carl B.C., “Com; g belly Integrals by Dupl N he Math matik 33 (1979), pp. 1 16.


<small>Original source: [View scanned PDF page 95](../scans/page_0095.png)</small>

(2) and Notis, E. M., “Algorithm 577, Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398-403.

```fortran
CALL DRDVAL(X, Y, Z, RD, IERR)
```

The arguments a and b are nonnegative double precision numbers where a-+ b > 0, and ¢ is a positive double precision number. IERR is an integer variable and w a double precision variable. When DRDVAL is called, if no input errors are detected then IERR is set to 0 and w is assigned the double precision value for Rp(a, },c).

```text
Error Return. If an input error is detected then IERR has one of the following values:
[ERR = 1 Either a, 8, or c is negative.
IERR = 2 Either e+ 6 or ¢ is too small.
IERR = 3 Either a, 6, or c is too large.
```

**Programming.** DRDVAL was written by B. C. Carlson and Elaine M. Notis (Iowa State University), and modified by A. H. Morris. The function DPMPAR is used.

**References.**

(i) Carlson, B. C., “Computing Elliptic Integrals by Duplication,” Numerische Mathematik 33 (1979), pp. 1-16.

(2) _____ and Notis, E. M., “Algorithm 577, Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398--403.


<small>Original source: [View scanned PDF page 96](../scans/page_0096.png)</small>

<a id="topic-096-01"></a>
### Real Elliptic Integrals Of The Third Kind

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [`L23435`](../source_parts/nswc_part_03.f#L2268) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [`L23494`](../source_parts/nswc_part_03.f#L2327) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [`L24016`](../source_parts/nswc_part_03.f#L2849) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [`L24153`](../source_parts/nswc_part_03.f#L2986) |


For any 0 < ¢ < 1/2 the elliptic integral I{¢,n, x) is defined by ¢ II(¢,n,k) = / (1 — nsin? 6)~1(1 — k? sin? 6)~ 3d0 0

where n is any real number such that 1 — nsin? ¢ 4 0, and & any real number such that k? <1 and 1—k?sin?¢40. Alternatively, for any r 7 0 we may consider

3 f° ; R,(a,b,c,r) = > (tr) ie + a)(t + b)(t-+6)]~ tae 0

where a,b,c are nonnegative and at most one of them is 0. Ifa <6< c anda <_ec then

_3 Ry(a,b,c,r) = ey lili m) ~ F($,k)]

nsin where F(¢, k) is the elliptic integral of the first kind, cos? ¢ = a/c,k? = (c — b)/(¢ -- a), and n== (c~r)/(c — a). lf 6 = /2 then the elliptic integral II(¢,n, k) is said to be complete. Otherwise, if ¢ < w/2 then the integral is said to Le iscomplete. The subroutines EPI, RJVAL, DEPI, and DRJVAL are available for computing II(¢,n,k) and Ry(a,b,c,r). DEPI and DRJVAL are double precision routines.

```fortran
CALL EPI(PHI, CPHI, K2, L2, N, M, P, IERR)
```

The arguments ¢,y, k?,@?,n,m are real numbers where ¢ > 0, > Od + n/2, hk? p €7 2 9, |nf < 1, and n tom. 1. Also, if w -- 0 then it is assumed that €? 4 0 and m 7 (. TERR and w are variables.) When EPI is called, if no input errors are detected then IERR is set to O and w is assigned the value II(d,n, &).

**Error Return.** if an input error is detected then TERR has one of the following values: IERR ot Either @ or yo is negative, or @ bof #2. HERR © 2 Hither inf > borm fom 4 4. IFRR | 3 Bither &? or €? is negative, or k? 4 6? / 1. IFRR 4 Bither Y and mi are too close to O, or y and €? are too close to 0 peth

**Precision.** EF Piis accurate to within 4 units of the surmibesnt dipat

Progrannaing Eb PLemploys the subroutines, REVAL, RIVAL, ROVALE and function SPM PAI. LPT was written by AH. Morris

```fortran
CALL RJVAL(X, Y, Z, P, RJ, IERR)
```

The arguments a,6,¢ are nonnegative real numbers, only one of which can be O, and r

isa positive real number. TR RR and w are variables. When RIVAL os called. ufino raprt


<small>Original source: [View scanned PDF page 97](../scans/page_0097.png)</small>

errors are detected then IERR is set to 0 and w is assigned the value Rj(a,},c,r).

```text
Error Return. If an input error is detected then TERR has one of the following values:
TERR = 1 Either a,},c, or r is negative.
[ERR = 2 Either a+ b,a+-,6-+-c, o'r is too small.
JERR == 3 Either a,b,c, or r is too large.
```

**Precision.** RJVAL is accurate to within 4 units of the 14‘ significant digit.

**Programming.** RJVAL calls the subroutine RCVAL1. These subroutines were written by B.C, Carlson and Elaine M. Notis (lowa State University), and modified by A.B. Morris. The function SPMPAR is also used.

**References.**

(1) Carlson, B. C., “Computing Elliptic Integrals by Duplication.” Numerische Mathematik 33 ('979), pp. 1--16.

(2) = and Notis, E. M., “Algorithm 577,Algorithms for Incomplete Elliptic Integrals.” ACM Trans. Math Software 7 (1981), pp. 398-403.

```fortran
CALL DEPI(PHI, CPHI, K2, L2, N, M, P, IERR)
```

The arguments ¢, w, k?, £?,n,m are double precision numbers where ¢ > 0, > 0,¢ + y= 0/2, k? + €? = 1, |n| < 1, andn+m= 1. Also, if y = 0 then it is assumed that @? 4 0 and m # 0. IERR is an integer variable and w a double precision variable. When DEPI is called, if no input errors are detected then IERR is set to 0 and w is assigned the double precision value for TI(@, n, k).

```text
Error Return. If an input error is detected then 1ERR has one of the following values:
IERR = 1 Either ¢ or » is negative, or 6+ ¢ 4 1/2.
IERK = 2 Hither |n| > torn+m#1.
IERR = 3 Either k? or €? is negative, or k? -+ €? 4 1,
TERR = 4 Either p and m are too close to 0, or w and €? are too close to 0.
```

**Programming.** DEPI employs the subroutines DRE VAL, DRJIVAL, DRCVL1 and function DPMPAR. DEPI was written by A.H. Morris. CALL DRJVAL(o, b,c,r, w, JERR) The arguments a,b,c are nonnegative double precision numbers, only one of which can be 0, and r is a positive double precision number. HERR is an integer variable and w a double precision variable. When DRJVAL is called, if no input errors are detected then TERE is set to O and wis assigned the double precision vie for Ry{a,4,e,r).

**Error Returns.** If an input error is detected then TERR has one of the following values:

JERR = 1 Either a,6,c, or r is negative.

pay

IeRR = 2 Either a@ } b,a 4 oe,60 + ¢, or r is toe sinall,


<small>Original source: [View scanned PDF page 98](../scans/page_0098.png)</small>

TERR == 3 hither a,6,c, or r is too large.

**Programming.** DRJVAL calls the subroutine DRCVLI. These subroutines were written by

B.C. Carlson and Elaine M. Notis (Iowa State University), and modified by A.H. Morris. The function DPMPAR is also used.

**References.**

(1) Carlson, B. C., “Computing Elliptic Integrals by Duplication.” Numertsche Mathematik 33 (1979), pp. 1-16. (2)

_ and Notis, E. M., “Algorithm 577,Algorithms for Incomplete Elliptic Integrals.” ACM Trans. Math Software 7 (1981), pp. 398-403.


<small>Original source: [View scanned PDF page 99](../scans/page_0099.png)</small>

<a id="topic-099-01"></a>
### Jacobian Elliptic Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [`L24482`](../source_parts/nswc_part_03.f#L3315) |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [`L24764`](../source_parts/nswc_part_03.f#L3597) |


For any complex number k # 0,+1 the elliptic function sn(z,#) may be defined as the meromorphic function w(z) that satisfies

(42) = wy He

¢

(4)

w(0) = 0, w'(0) = 1.

) If k = 0 then sn(z,0) = sin z satisfies (1), and if k = -:1 then an(z,k) = tanhz satisfies (1). Alternatively, sn(z,k) = sind where ¢(z) satisfies

dp\* 2. (2) (<2) = 1-k*sin' ¢ #0) =9, (0) =1.

The elliptic functions en(z,k) and dn(z,k) may be defined by

dn(z,k) = \/1 — k?sn(z, ky?

where the roots take the value 1 for z = 0. In particular, if & =: 0 then en(z,0) == cosz and dn(z,0) = 1, and if k = +1 then en(z,k) = dn(z,k) = 1/cosh~. The subroutines ELLPF and ELPFC1 are available for computing sn(z, k&),cn(z,b), and da(z,k) when & is a real value such that [ki < 1. ELLPF may be used when z is real and ELPFC1 when z is complex.

```fortran
CALL ELLPF(U, K, L, S, C, D, IERR)
```

It is assumed that u,k, and @ are real numbers where k*? } €? -- 1. S,C, and D are real variables. When BLLPE is called, S,C, and D are assigned the values S ~ sn(u,k), C = en(u,k), and D.. dn(n,k).

JERR ts a variable that reports the status of the results. When the routine terminates, TERK has oue of the following values:

IERR = 0 ‘The elliptic functions were computed.

IERR 4 (Input error) k* +) @? 1.

TERR. 2 «is too large for k

When JERR & 1, no computation is performed.

**Precision.** Let A(k) be the complete eliiptic integral of the first kind. Por [Ay < .99995 the relative errors of sn(u,k) and dn(u,k) are less than 10 1? when O © u < Ak), and the 12 when O~ us 9TH (kK).

relative error of cn(u,k) is less than 10


<small>Original source: [View scanned PDF page 100](../scans/page_0100.png)</small>

**Algorithm.** Let K = A(k) be the complete elliptic integral of the first kind. For O < u < K/2 (when € # 0), the Maclaurin expansion

(1+ k7)u> (14 14k? + kt)u an(u, k) =u a a

```text
is employed when u < .01. Otherwise, if u > .01 let K’ = K(é), q = exp(—7K'/K), and
r= exp(--7K/&'). Then
```

Qn Ss gute | (2n41)ru

en(u, k) == kK a ]—qintl sin OK n>0 is used when k < @ and 7 Tu w(-1)?r?? | Oru sn(u,k) = ER? tanh anit 2» iyi sinh Ki

is used when k > @. The functions cn{u,k) and dn(u, &) are obtained from

```text
sn(u,k)? + en(u,k)? = 1
dn(u,k)? + k?sn(u,k)? = 1.
```

For K/2<u< K the identities

```text
sn(u, k) = en(v,k)/dn(v, k)
cn(u,k) = [éisn(v, k)/dn(v, k)
dn(u,k) = |é|/dn(v, k)
```

are applied. Here v = HW -- u.

**Programming.** HLLPF employs the subroutines SCD, SCDF, SCDJ, SCDM, ELLPI, SNHCSH and functions ALNREL, CPABS, SPMPAR, IPMPAR. ELLPF was written by Andrew H. Van Tuyl and modified by A. H. Morris.

```fortran
CALL ELPFC1(U, K, L, S, C, D, IERR)
```

The argument z is complex, and k and @ are real numbers where k? + €? = 1. S,C, and D are complex variables. When ELPFC1 is called S,C, and D are assigned the values Ss» gn(z,k), C = enfz,k), and D> dn(z,k).

JERR is a variable that reports the status of the results) When the routine (- -munates, IER has one of the following values:

IERR — O The elliptic functions were computed,

[ERR OT (Input error) A? 4 © of 4.

PRR © 2 zis too large for &.

JERR -- 3 zis a pole for the elliptic functions.


<small>Original source: [View scanned PDF page 101](../scans/page_0101.png)</small>

When JERR > 1, no computation is performed.

**Precision.** Let x = Re(z), y = Im(z}, K = K(k) be the elliptic integral of the first kind for k, and K’ = K(é). For |k| < .99995 the relative errors of the real and imaginary parts of sn(z,k) are less than 1071? when 0 < z < K and 0 < y < .992K’, and the relative errors of the real and imaginary parts of cn(z,k) and dn(z,k) are less than 107?? when O<2< 97K andO<y< 97K’.

**Algorithm.** For z = 2 + ty let s = en(z,k) 8, = sn(y, 2) ec = en(z,k) cy, = en(y, 2) d = dn(z,k) d, = dn(y, £) and D = c3 + k*s?s?. Then an(z,k) = (sd, + teds,c,)/D en(z,k) = (cc, — #sds,4,)/D dn(z,k) — (deyd, — tk? scs;)/D are applied when D # 0. Programming. ELPFC1 calls ELLPF, which employs the subroutines SCD, SCDF, SCDJ,

SCDM, ELLPI, SNHCSH and functions ALNREL, CPABS, SPMPAR, IPMPAR. ELPFCI was written by Andrew H. Van Tuyi.


<small>Original source: [View scanned PDF page 102](../scans/page_0102.png)</small>

<a id="topic-102-01"></a>
### Weierstrass Elliptic Function for the Equianharmonic and Lemniscatic Cases

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [`L24847`](../source_parts/nswc_part_03.f#L3680) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [`L24888`](../source_parts/nswc_part_03.f#L3721) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [`L24931`](../source_parts/nswc_part_03.f#L3764) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [`L24974`](../source_parts/nswc_part_03.f#L3807) |


Lei w and w’ be complex numbers where Im(w’/w) > 0, and Wm, = 2mw + 2nw’ for all integers m,n. Then for any complex z, the Weierstrass elliptic function P(z;w,w') can be

defined by t 1 P(z;w,w’) gt yo i oet

(z- - Wmn) Whan

where &’ denotes the sum for all m,n = 0,+1,+2,... except m=n = 0. If w= re’? and w! = r'e® where ¢! = $46 for 0 < @ < 2, then the restriction Im(w’/w) > 0 is equivalent to assuming that 0 < 0 < m. P(z;w,w’) is analytic everywhere except at the points Wmn, which are poles, and

P(z+2w;w,w') = P(z; wu, w'

P(z+ 2w';w,w’) = P(z,w,w’) for all z. The reiations

P(-2;w,w') = P(z;w,w’)

P(dAz; Aw, Aw’) = AW? Pz; w,w') AAO also hold. A somewhat surprising fact is that only the values gg = 602'wy4 and gz = 1400/w76 are needed for computing P(z; w,w’) at a point z. Hence, P(z; w, w’) is frequently denoted I by P(z392,93). For A A0

g2(Aw, Aw’) = Av*go(w, w’)

g3(Aw, Aw’) = 48 g3(w, w’) also hold. We now consider the following cases:

(1) Equianharmonic (gz = 0 and gg is a positive real nurnber)

```text
(2)  Lemniscatic (gz is a positive real number and g3 = 0)
(1) occurs when 2w = § ~ YB and 2w! = $+ By, and (2) occurs when 2w = 1 and
2w! = 4. The following subroutines are available for computing P(z; w, w’) and its derivative
P'(z;w,w') for these two choices of (w, w’).
```

```fortran
CALL PEQ(Z, W, IERR)
```

The argument z is a complex number, e is a complex variable, and IER is an integer variable. It is assumed that the periods are 2w =: 5 ~ v3 4 and 2w! = ‘ 4. ran . When PEQ is called, if z is not a pole then TERE is assigned the value 0 and e is assigned the value

P(z;w,w’). Error Return. !f z 0 wy, for some m,n then INR is assigned the value I and e = 0.

**Precision.** If |P(z;w,w’)| ~ i then the absolute error is less than 7-10 18. Otherwise, the

relative error ig less than 7. FO FS

**Programming.** Written by Uinch WKekhardt (University of Hamburg, West Germany). Modified by A. H. Morris.


<small>Original source: [View scanned PDF page 103](../scans/page_0103.png)</small>

**References.**

(1) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Mati: Software 4 (1980), pp. 112-i20.

\- ee ,“A Rational Approximation to Weierstrass’ P-Function,” Math Comp. 30 (1976), pp. 818-826.

```fortran
CALL PEQ1(Z, W, IERR)
```

The argument z is a complex number, e is a complex variable, and IERR is an integer

variable. It is assumed that the periods are 2w = ; - v3; and 2w’ = 5+ vB, When PEQI

is called, if z is not a pole then JERR is assigned the value 0 and e is assigned the value P'(z; w,w’).

**Error Return.** If z = wmy for some m,n then IERR is assigned the value 1 and e = O.

**Precision.** If |P’(z; w,w’)| < 1 then the absolute error is less than 7-10-15. Otherwise, the relative error is less than 7- 10719.

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.

**References.**

(i) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Math Software 4 (1980), pp. 112-120.

(2) sss “A Rational Approximation to Weierstrass’ P-Function,” Math Comp. 30 (1976), pp. 818-826.

CALL PLEM(z, e, IERR) The argument z is a complex number, ¢ is a complex variable, and LERR is an integer variable. It is assumed that the periods are 2w = 1 and 2w! = 1. When PLEM is called, if z is not a pole then TERR is assigned the value 0 and e is assigned the value P(z;w,w').

**Error Return.** If z == wm, for some m,n then IERR is assigned the value ! and e =: 0.

**Precision.** If |P(z;w,w’)| < 1 then the absclute error is less than 6- 10713. Otherwise, the relative error is less than 6-107 !9.

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.

**References.**

(1) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ ElHptic Functions,” ACM Trans. Math Software 4 (1980), pp. 1f2 120.


<small>Original source: [View scanned PDF page 104](../scans/page_0104.png)</small>

(2) ____, “A Rational Approximation to Weierstrass’ P-Function. II: The Lemniscatic Case,” Computing (Arch. Elektron. Rechnen) 18 (1977), pp. 341-348.

```fortran
CALL PLEM1(Z, W, IERR)
```

The argument z is a complex number, ¢ is a complex variable, and [ERR is an integer variable. It is assumed that the periods are 2w =: 1 and 2w’ = +. When PLEMI is called, if z is not a pole then IERR is assigned the value O and e is assigned the value P’(z; w, w’).

**Error Return.** If z = Wamp, for same m,n then IERR is assigned the value 1 and e = 0.

**Precision.** If |P’(z;w,w’)| < 1 then the absolute error is less than 6 10713. Otherwise, the relative error is less than 6 - 10715.

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.

**References.**

(1) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Math Software 4 (1980), pp. 112-120.

(2) ,»“A Rational Approximation to Weierstrass’ P-Function. II: The Lem-

niscatic Case,” Computing (Arch. Elektron. Rechnen) 18 (1977), pp. 341-349.


<small>Original source: [View scanned PDF page 105](../scans/page_0105.png)</small>

<a id="topic-105-01"></a>
### Integral of the Bivariate Density Function over Arbitrary Polygons and Semi-Infinite Angular Regions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [`L25020`](../source_parts/nswc_part_03.f#L3853) |


Given a sequence of points », = (z,,y)(f = 1,...,n +1) where n > 3 and Vy41 = Vy. Let r denote the polygon whose beundary @r is a polygonal line which begins at point v1, traverses the points v, in the order that they are indexed, and is the straight line segment connecting v; to ¥;4, for each t = 1,...,n where y, 4 %41. Then the subroutine VALR2 is available for computing the integral

1 2 2 P(r) -: — — (2° +y")/2 g. (7) == 5 IE xdy

r

and the associated function A(r) = ff dzxdy. If the boundary @7 is a simple positively

_ (negatively) oriented closed curve, then P(r) and A(r) are positive (negative) and |A(r)| = the area of r. However, Or need not be simple. It may be self-intersecting or have overlapping line segments. If AQ, is the angle between the vectors vy ~ Ww_; and 441, — 4% (where Vo = v,), then it may occur that A@, -: m fur some t, in which case a portion of the polygon may be degenerate. In general, —x < A6; < m for each 1 where the sign of the angle is positive (negative) if the angle is measured in a counterclockwise (clockwise) direction from

a) vy Wy to 441 ~ 4. VALR2 also computes the value k(r) ~ a y Aé,, which is an

t=1 integer. If the boundary is a simple closed curve, then k(r) is the winding number of the curve around any terior point of the polygon r.

Alternatively, assume that we are given three points v, — (z.,y¥,)(¢ = 1,2,3) and let 4é denote the angle between the vectors vz - vy and v3 v;. In this case, assume that the angle A@ is measured in a counterclockwise direction from V2 - by to vg: vy, so that O< O¢ < 2m. Let € denote the straight line beginning at point 71 and passing through point, v2, and let @ denote the straight line beginning at v; and passing through v3. Then the subroutine VALR2 is also available for computing P(r) when 7 is the semi-infinite angular region bounded by @ and é, and having the angle A@, 0 P(r) ~ 1 for any angular region t, and P(r) > 1 when A@ >» 2m.

is . !

. -— Angutar region 1 . oN Ae

a

```fortran
CALL VALR2(X, Y, N0, P, IOP, A, IND, KO)
```

The argument. mis either Lor the number of points involved in defining a pulypou Ifn f then it is assumed that 7 is a semi-infinite angucar region defined by the points vy (ay) (f 1,23), and that NY and VY are arrays vonlaimiig. 2), fy,ta and yay ye, ye Otherwise, ifn / To then it is assumed that a is a polygou defined by the poms +

13 ae


<small>Original source: [View scanned PDF page 106](../scans/page_0106.png)</small>

(ti, 4) (¢ = 1,...,n+ 1) where n > 3 and v4, = 44. In this case, X and Y are arrays containing the abscissae z1,...,%,4 1 and ordinates y1,...,Yn¢i. Since Yai, = vy, the values 2,41 and yny1 need not be supplied by the user. The routine automatically stores x, and y; in X(n + 1) and Y(n +1).

P, A, and k are variables. If n = 1 then P is assigned the value P(r) for the angular region 7 and A is assigned the value 0. In this case, k is not defined. Otherwise, if n > 3 then P is assigned the value P(r), A is assigned the value A(r), and k is assigned the value k(x) for the polygon r.

IOP is an input argument which specifies the (relative) precision to which P{r) is to be computed. IOP is set to 1, 2, or 3 for 3, 6, or 9 decimal digit accuracy.

```text
IND is the variable that reports the status of the results. The routine assigns IND one
of the following values:
IND = ’ The desired values were obtained.
IND = 1 {Input error) 1; is either equal to vz or v3, or is too close to v2 or
v3 to compute P(r) for >e angular region r. In this case, P is set
```

to 5.

IND = 2 The desired values were obtained. If n = 1 then A@ x x. Otherwise, ifn > 3 then |AQ,| ~ m for some ¢.

IND = 3 (Input error) E Kither n < Lorn = 2.

**Remarks.** VALR2 can be used for computing the integral of the general bivariate density function over an arbitrary polygon or semi-infinite angular region 7. Consider

where B = (1 - p?)>1/?/(2n0V02), (44,Hs) is the mean, o, and o, are the (nonzero) variances, and p is the correlation coefficient satisfying |p| <1. Consider also

oy tlw pe z fz Zz pz x 7) 2 p and oy . Oz | oO, Since this transformation maps straight lines into straight lines, 7 is mapped ont a polygon

or angular region 7 and we obtain P(7) P(r). Moreover, if 7 is a polygon ten A(7)

Jf dds g tal p* A(z).

**Programming.** VALR2 employs the functions ERE, ERFCI, and SPMPAR. VALR2 was designed by Armido R. DiDoaato and Richard K. Hageman, and modified by A. H. Morris.

**Reference.** Gilonate, A. Ro, and Hageman, Ro K , Computation of the Integral of the Dia variate Normal Dratribution over Arbitrary Polygons, Report TR 80.166, Naval Surface Weapons Center, Dahlgren, Virginia, £980.


<small>Original source: [View scanned PDF page 107](../scans/page_0107.png)</small>

<a id="topic-107-01"></a>
### Circular Coverage Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [`L25295`](../source_parts/nswc_part_03.f#L4128) |


The subroutine CIRCV is available for computing the circular coverage function P(R, d) and the generalized circular error function V(K,c). V is the integral of an uncorrelated elliptical Gaussian disiribution with standard deviations o, and oy, over a circle of radius Ko, centered at the mean of the distribution. If o, > o, then

1 K 6 gg? v(K)= 2 fi [exp{ Ze [4 et + (1 ~ 2%) cove] | r doar

where c = o,/oz. P is the integral of a circular Gaussian distribution with comimon standard deviation o over a circle of radius Ro whose center is offset a distance de from the mean of the distribution.

1 of” f?* P(R,d) = an / [ exp {-3 [(d + rcos@)? + r? sin? 6] \ rd0dr )

40 Alternatively,

K V(K,c) = ! / e Br" 1(Ar?)rdr (ce # 0) 0

c.

R P(R,d) > Qn] e !?Iy(ed)r dr i) where A (1 ¢?)/(4e?), B= (1 + ¢?)/(4e7), and Ig is the modified Bessel function of the first kind and order 0. Since V(K,c) + erf(K/\/2) when ¢ + 0, we may define V(K,0) — erf(K/y/2).

```fortran
CALL CIRCV(R, D, J, P, IERR)
```

The argument ¢ may be any integer. If O then the arguinents a and a are assumed to have the values ¢ © A anda oocwhere A > O and 0%. ¢* 1. Otherwise, if / 0 then r Randa dwhere BR > Oand d > 0.

IER and tw are variables. When CERCY as called, fino input errors are detected then IP RR is assigned the value 0. Also, w = W{A,ye) if) Oandw PCR, d)ifia 7 0.

Error Retorn. Hoan input error is detected then TERR is set as follows: TERR Por Ois not satished, IE RK 20-0 e. bord + Ois not satished

When either of Chese errors is detected, was assigned the value I

Precision [ft Qthen owas accurate te within Lounit of the PS'P sqemificant digst when VON eo) os not near OQ) Otherwise, fa ¢ O them tis accurate to within fourm of the ppb

siymificant diyat when (Ald) is not near 4


<small>Original source: [View scanned PDF page 108](../scans/page_0108.png)</small>

**Algorithm.** If AK? < t4 then V(K,c) = SO. 7T, is employed where

oyn>0

2a 2 go — _l pv BK 1 | -BK “O ~ Tepe To = g.pil- 2 f - _ { AK? _. 2n-1 A? AK? A\ Ak? Sa = (4°) Syo1 Ty = “tn BT Tao. - \ ine + 4) “on Snot (n ? 1).

Otherwise, if AK? > 14 then the asymptotic expansion V(K,c) = 1~ e7K’/? ono Mn is used where 7

-2; - My =: Fe eric( & a: wd. 2. 2 - 1 é (5) zy ee Ke &6=-Vl-e _. On-1 _¢? - Un l 2n-} Masi = ees 1 Soy (rn ~ M,) Inti = In 4AK? Tn (n > 1).

~

If 2 < 1.7 or Rd < 16 then P(R,d) > S054 7, is employed where Th Oe i ety, 2 | 6 d?/2 0 y RP/2.

Otherwise, if Rd > 16 and R >» 1.7 then the asymip otic expansion

re ik d t 1 3 1} te 7 (8; ¢ s2)] if Rod

eT ee ee fy. Hyd y> oN wo is used where z [A di/V2, 1 aed Seo May 82 Siied yoy Tn, and ; 1 Pa 7 wei Af, e erfe(z) - zn loan ot iT oe » . Fav an aka 7 Mavi on aralta 7 My) (n° I).

**Programming.** CIRCV employs the functions ERE, ERECE, ERROR, EXPARG, GAMMA, GAMI, GLOG, RCOMP, REXP, RLOG and subroutanes HRECO, GRATIO. Phe functions SPMPAR and IPMPAR are also used) CIROV was written by Armudo Ro Dibonato aid modified by A. H. Morris

**References.**

(1) DiDonato, ALR | Bee Statistical Programa in BASIC for Desktop Computers, Report NSW UP r 83.03) Naval Surface Weapons Center, Dahlgren, Virgniua, Pose

(2) and Jarnagin, MP, A Method for Computing the Generalized Cireular Error Function and the ¢ areular Coverage Function, Report P78, Naval

Weapous Laboratory, Dahtpren, Virginia, 62


<small>Original source: [View scanned PDF page 109](../scans/page_0109.png)</small>

<a id="topic-109-01"></a>
### Elliptical Coverage Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [`L25648`](../source_parts/nswc_part_03.f#L4481) |


The subroutine PKILL is available for evaluating the integral of an uncorrelated elliptical Gaussian distribution over the area A of a circle (x — h)* + (y—k)? = R?. The probability to be computed is given by

1 L/z? y? P(R,oz,0y,h,k) = Inasa0 II. exe|-3( 5 + “)I dz dy

v

where ¢z is the standard deviation in the z direction and oy is the standard deviation in the y direction. Then

P(R, a2, 0,,h,k) = P(R,oy,o2,k,h),

P(R,oz,0,,h,k) = P(R, oz, oy, |Al,|k]), and

P(R,02,0,,h,k) = P(aR, aoz, aoy, ah, ak)

for any a> 0. Also P=Q when R= 0. CALL PKILL(R,oz,0,,h,k, P)

R,o;,,0,,h,k are real numbers and P is a variable. Jt is assumed that R > 0, oz > 0, and a, > 0. When PKILL is called, P is assigned the value P(R,oz,0,,h,k).

**error Return.** P = --107° ifo, <Ooro, <0.

**Precision.** P is accurate to within 1 unit of the 6" significant digit when P > 107?° and |i, |k|, VA? + k? are not near R.

**Programming.** PKILL employs the subroutine GRATIO and functions SPMPAR, ERF, IPMPAR, EPSUN, EXPARG, REXP, RLOG, ERFC, ERFC1, AERF, GAMMA, GAMI, GLOG. PKILL was written by Armido R. DiDonato.

**Reference.** DiDonato, A. R., Significant Digit Computation of the Elliptical Coverage Function, Report NSWC TR 90 513, Naval Surface Warfare Center, Dahlgren, Virginia, 1990.

