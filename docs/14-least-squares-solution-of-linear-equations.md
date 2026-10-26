[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-281"></a>
## Least Squares Solution of Linear Equations

<small>Original source: [View scanned PDF page 281](../scans/page_0281.png)</small>

<a id="topic-281-01"></a>
### Least Squares Solution Of Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [`L66965`](../source_parts/nswc_part_07.f90#L3403) |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [`L67602`](../source_parts/nswc_part_07.f90#L4040) |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [`L69803`](../source_parts/nswc_part_07.f90#L6241) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [`L70051`](../source_parts/nswc_part_07.f90#L6489) |


Given an m X n matrix A and an mx @ matrix B. The column vectors b;,..., 6, of B specify @ distinct linear least squares problems

This set of problems can be written in the form AX = B where X is the n x @ matrix having the column vectors z1, ...,2¢. There always exists 4 unique minimum length least squares solution 2, for each Ar; = b;. If B is the m x m identity matrix, then the matrix whose columns are the minimum length solution vectors z; is called the pseudoinverse of A.

For any B, the subroutines LLSQ, LSQR, HFTI, and HFTI2 are available for obtaining the matrix X whose columns are the minimum length solution vectors. LSQR, HFTi, and HFTI2 are more general than LLSQ, begin able to solve arbitrary systems AX = B. LLSQ assumes that m > n > 1 and that the rank of A is n. LSQR employs a more involved procedure than HFTI and HFTI2. LSQR computes the rank of A, whereas HFTI and HFTI2 leave the determination of the rank to the user.

```fortran
CALL LLSQ(M, N, A, KA, B, KB, NB, WK, IWK, IERR)
```

It is assumed that m > n > 1 and that the rank of Ais n. The input arguments ka and k6 have the following values:

ka = the number ai rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is required that ka > m and kb > m.

```text
IERR is an integer variable. When LLSQ is called, if no input errors are detected then
IERR is set to 0 and the solution matrix X stored in B. Also, if m #n then the residual
norm || Az, -- 6;{|| is computed and stored in B(n-+ 1,7) for gj = 1,..., 83
```

WK and IWK are arrays of dimension n or larger that are work spaces for the routine.

**Error Return.** (ERR 4 O when m > n> 1 is not satisfied (IERR > 1) or the rank of A ts less than n (IERR © 2).

**Note.** A is destroyed during computation.

**Programming.** LLSQ ts a driver for the subroutines ORTHO and ORSOL, written by Nai- Kuan Tsao and Paul J. Nikolai (Aerospace Research Laboratories, Wright-Patterson Air Force Base).

**Reference.** ‘Tsao, N. Ko and Nikola, P. J., Procedures using Orthogonal Transformations for Linear Least Squares Problems, Report ARL PR 74-0124, Aerospace Research Laboratories, Wright-Patterson Air Force Base, [97-4

{Throughout this section fief; Sie far any vector Che ce Say de g eh \ : y Leds uv

vid ode


<small>Original source: [View scanned PDF page 282](../scans/page_0282.png)</small>

CALL LSQR(MO,A, ka, m,n, B, kb, 6RERR,AERR,k,ko, RNORM, WK ,éw, [WK fiw TERR)

MO is an argument which specifies if LSQR is being used for the first time. On an

Ais an m xn matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ka > m. A is destroyed by the routine.

The argument @ is an integer. I’ 2> 1 then B is an m x € matrix and kb is the number of rows in the dimension statement jor B in the calling program. Also, RNORM is an array of dimension @ or larger (for output). It is required that kb > max{m,n}. If @ < 0 then there are no equations to be solved, and B, kb, and RNORNA are not used.

RERR is an argument which specifies the relative accuracy of the data in A. If it is estimated that the elements in A ar: accurate to p significant decimal digits then one may set RERR = 1074. It is required that RERR > 0. If RERR = 0 then it is assumed that the elements in A are accurate to m ‘chine precision.

AERR is an argument which specifies the maximum absolute uncertainty of the data in A. For example, jf it is estimated that the elements a,; of A have the relative accuracy RERR except when |a,;| < 107°°, then one may set AERR = 107~*°. It is required that AERR > 0.

The arguments k, kj, and IERR are variables. When LSQR is called, if no input errors are detected then IERR is set to O and the rank of .4 is bounded from above and below using the tolerances RERR and AERR. The variable k is set. to the upper bound and ky to the lowe: bo. nd. If @ > 1 then the n x @ matrix X whose columns are the minimum length solution vectors is computed (using k as the rank) and stored in B. Also, the residual norm A: 6 || is computed and stored in RNORM()) for j = 1, ...,2.

WK is cn array of dimension fw where @w > S- min{m,n}. and EWK is an array of dimension rw where fiw > em fon. WK and IWh are work spaces for the routine,

**Error Return.** (ERR is as signed one of the following values where au error is detected:

TERR os fom < bor) <0. IFRR = 3 ka < mi.

Lo 2R 0 S kbs maxicu,n} TERR «4 fru orm fom.

TERR © 5

HeRE 6 RERR or AdeacR os negative. FIERRO 7 MO / Oand #- 0.

fwoas too small.

No computation is performed when an error is detected

After an initial o all to LSQER. if TERR Oo then the routine aisy be cable fw N,

POO. In this onse af gs assumed that only GO has been modified and fiat the aes


<small>Original source: [View scanned PDF page 283](../scans/page_0283.png)</small>

equations AX = 2 are to be solved. The routine employs the Householder factorization of A stored in A, WK, and [WK 9n the initial call to LSQR.

When MO # 0, it is assumed that A,ka,m,jn,/. VK, and éw have not been modified by the user. If k ==: 0 or & == min{rm,n} then only th. first min{m,n} elements of WK are needed and one may sot fw > min} m,n}. Otherwise, it is required that éw > 2-min{m, n}.

RERR, AERR, and kp are not used when MO + 0. The only assumptions concerning the new 8, kb, and ? are that &b > max{m,n}, @ > 1, and the dimension cf RNORM is now the nev value of € When LSQR is called, if no input errors are detected then IERR is set. to O and the new solution matrix X obtained. As before, X is stored in B and the residual norms are computed and stored in RNORM.

**Remarks.**Normally ko = £ in which case & is the rank of 4. However, if ko # & then it is recommended that Ho Vi be used for obtaining the most appropriate value for the rank and solving (4 = B. WOITETES 3 used, the sizes of the elements of the solution matrix X should be considered (in addition to the values of the residual norms). Frequently, the lower bound &y will be found te be the most appropriate value for the rank.

Programming. GSQR employs the subroutines JIILS, ULZLS, ULLUS, U1208, [SWAP, SSWAP, SAXPY, SSCAL and functions SNOT, SNRM2, ISAMAX, SPMPAR, IPMPAR. LSOR was written by A. H. Morris and Utils, U1208, O1LUS5, UL2US were written by T. Manteuffel (1.08 Alamos).

References. *& anteuffel, T., An Interval Analysts Approach to Rank Determination in Linear Least Squares Problems, Report SAND 80-0655, Sandia Laboratories, Albuquerque, New Mexico, 1980.

CA HETICA, ka, sin, 8, kb, 27, kJ RNORD! GIP) CR.) HETI2(A, ka, m,n, 8, kb, 2, D7, kRNORM, 1G IPLERR)

yas ae. ont matrix where ion * 1) and Aa ois the number of rows in the dimension

staboameatiar ¢ a the calling program, It is required that &uco> rn The argument @ ais an integer. Wo @ > fd then 8 is an om x @ matrix and &f is the

dioathers cows in the dimension statement for Bin the calling program. Htas required that ko ong) aomd. iff « O then t cre are no equations te be solved, and ff and kd are not

bP then RNORN an array of dimension &@ or larger Otherwise, if & O then

RN EM oncsed. When GE Tbor HET is called, af 0 then the na @rmatria whose heat cok ff minimum length solution vectors is computed acd stored am J Aisa, the bof eG) is eotopaated dd stored ip RING Ay) Bop po dF

ceecarrays of dimension on os bargee hot are work spaces For the routine:

three aoe tee and 2)

ae mow a tolerance That rs cet by the user os sortable and f)oan siray f


<small>Original source: [View scanned PDF page 284](../scans/page_0284.png)</small>

dimension win{m,n} or larger. It is assumed that r > 0. Normally 7 = 0 is the setting that is used. D and & are set by the routings.

In order to understand the use of r,k, and D one must be briefly acquainted with the processing of .4. The routines first reduce A to a triangular matrix C where A = QCP. Q is an orthogonal matrix and FP a permutation matrix. P is defined so that the diagonal elements c,; of C satisfy lew] > |ei+i,41| for each 1. The variable k is set to the largest integer such that |c,,| > 7, and if HF TI2 is used then the diagonal elements c,; are stored

in D. C is now regarded as the partitioned matrix C, C C= 1 2 0 C3 whe : Cy isa kx k matrix. Minimum length least squares solutions 2, are then computed

for the problems As; = 6; using only the first k rows of C. This is equivalent to replacing A with

x C Co A=al 1 \P ,o 0

and solving Az; = 6b, forjg=1,...,8.

Since fey] > ++: > |cee| > > clearly k& is the rank of A. It is also true that the ratio 1¢1,| /|cgs| is 4 lower bound on the condition number of Cy (relative to the spectral norm). Thus, if the ratio is extremely large (say > 108) then a severe loss of accuracy can be expected. A large ratio may be due all or in part to rank deficiency (or near rank deficiency) of the matrix A. Fortunately, rank deficiency is frequently not too difficult to detect and cure. When A is rank deficient then machine roundoff may assign cg, a small value, say 19714, when it should be (. The cure is to examine the diagonal elements c,, which are stored in D, to reset 7 so as to eliminate the unwanted ¢,,’s, and then to rerun the problem, This will reduce the order of Cy, thereby lowering the rank of the replacement matrix A. Cy will now be better conditioned, but the value of the residual norms [jAr, 6]! may be larger. If the norms do increase, then the solution obtained will be satisfactory only if the size of the increased norms fall within acceptable bounds

**Remarks.**

(1) The variable & is set to Oaf all le] oor. Hk G thea the zero matrix fs the solution for AX 2 B.

(2) if @< 0 then the decomposition A QCP is performed, the clawed elements of are stored in D, and & is computed.

```text
(2) Phe contents of 4 are destroyed by the rou ines,
(4) EIR TP and HETI2 yield the same results.
```

Error Return TER Ros a variable that a cet by the routine. Teno put errors ce detected

then PR RE as set to O) Otherwise, TERR as assipoes one of the following valine. Lhoig ht boifen o> kea LPR woah @ - band Ads max crn}

When an error ais detected, the routine immediately terminates


<small>Original source: [View scanned PDF page 285](../scans/page_0285.png)</small>

**Programming.** HF TI and HFTI2 call the subroutine H12. These routines were written by Charles L. Lawson and Richard J. Hanson (Jet Propulsion Laboratory}, and modified by A. H. Morris.

**Reference.** Lawson, C. L., and Hanson, R. J., Solving Least Squares Problems, Prentice- Hall, Inc., Englewood Cliffs, New Jersey, 1974.


<small>Original source: [View scanned PDF page 286](../scans/page_0286.png)</small>

<a id="topic-286-01"></a>
### Least Squares Solution of Overdetermined Systems of Linear Equations with Iterative Improvement

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [`L66998`](../source_parts/nswc_part_07.f90#L3436) |


Given an m Xn matrix A and an mx £ matrix B. The column vectors b;,...,6, of B specify @ distinct linear least. squares problems

This set of problems can be written in the form AX = B where X is the n x @ matrix having the column vectors 2}, ...,z2. Assume that m > n > 1 and that the rank of Ais n. Then there exists a unique least squares solution z; for each Az, = b;. The subroutine LLSQMP is available for obtaining the solution matrix X. Iterative improvement is performed to compute X to machine accuracy.

```fortran
CALL LLSQMP(M, N, A, KA, B, KB, NB, WK, IWK, IERR)
```

It is assumed that m > n > 1 and that the rank of A is n. The input arguments ka and «6 have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb == the number of rows in the dimension statement for B in the calling program It is required that ka > mand kb > m.

When LLSQMP is called, the solution X is computed and stored in B. Also, ifm 7#on then the residual norm ||Ax, ~ 5,{| is computed and stored in B(n + 1,7) for jg = 1,...,6.1 Ais not modified by the routine.

WK is an array of dimension min ¢ 2: { on or larger, and EW an array of dimension nor larger. WK and [WK are work spaces for the routine.

JERR is a variable that is set by the routine. When LLSQMP terminates, [eRR has one of the following values:

JERR OO ‘The solution XY was computed to machine accuracy.

HERR oft X was obtained, but not to machine accuracy.

IERR | 2 ‘The restriction mi > a> Lis not satisfied

IERR 3 ‘The rank of Aas less than n.

**Programming.** LLSQMP is a driver for the subroutines ORTHO, ORSOL, and ORIMP. These subroutines were written by NaieKuan Tsao and Paul J. Nikolat (Aerospace Research Laboratories, Wright-Patterson Air Force Base). ORIMPE was modified by A. TH. Morris. The function SUMPAR and subroutine MCOPY are also used

**Reference.** Tsao, NO Ko and Nikola, Pod, Procedures using Orthogonal Transformations

for Linear Least Squares Problems, Report ARD TR 74-0124, Aerospace Research Laboratories, Wright-Patterson Air Force Base, 1974

Mere hey Vlaet for any vector: tea, ean)


<small>Original source: [View scanned PDF page 287](../scans/page_0287.png)</small>

<a id="topic-287-01"></a>
### Double Precision Least Squares Solution Of Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [`L67370`](../source_parts/nswc_part_07.f90#L3808) |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [`L68705`](../source_parts/nswc_part_07.f90#L5143) |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [`L70417`](../source_parts/nswc_part_07.f90#L6855) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [`L70667`](../source_parts/nswc_part_07.f90#L7105) |


Given an mx n matrix A and an mx 2 matrix B. The column vectors b;, ...,6, of B specify @ distinct linear least squares problems

Ar; =b; (g=1,..., 8).

This set of problems can be written in the form AX = B where X is the nx £ matrix having the column vectors 11, ...,Z¢. There always exists a unique minimum length least squares solution z, for each Az; = b,. If B is the m > m identity matrix, then the matrix whose columns are the minimum length solution vectors x; is called the pseudoinverse of A.

For any £2, the subroutines DLLSQ, DLSQR, DHFTI, and DHFTI2 are available for obtaining the matrix X whose columns are the minimum length solution vectors. DLSQR, DHFTI, and DHFTI2 are more general than DLLSQ, begin able to solve arbitrary systems AX = B. DLISQ assumes that m > nm > 1 and that the rank of A is n. DLSQR employs a more involved procedure than DHF TI and DHFTI2. DLSQR computes the rank of A, whereas DHET1L and DHFTI2 leave the determination of the rank to the user. he subroutines perform all calculations in double precision.

```fortran
CALL DLLSQ(M, N, A, KA, B, KB, NB, WK, IWK, IERR)
```

A and B are double precision arrays. It is assumed that m > n > I and that the rank of Ais mn. The input arguments ka and kb have the following values:

ka ~ the number of rows in the dimension statement for A in the calling program

kb the number of rows in the dimension statement for Bin the calling program It is required that ka ©: rn and kb > m,

IK EGR is an integer variable. When DLLSQ is called, af no input errors are detected then TORR is set to O and the solution matrix X stored in’ Bo Also, ifern fon then the a

residual norm [}4a. bf as computed and stored in Btn i Ly) for 7 1 i é via i y

a Wik and PWR are arrays of dimension a or larger that are work spaces for the routine

Wks a double precision array.

Error Return TRKR ¢ O when wi con - bas not satisfied (EER Ej) er the rank of Ac less Chan on (HERE 2)

Note Adis destroyed during computation Programming ULDSQ is a driver for the subroutines DORVHO and DORSOE These sub

routines are double precision versions of ORTHO and QRSOEL, written by Nat huan Psa

apd Paul Jo Nikolas (Aerospace Research Laboratories, Wright) Patterson Ai Pore Rae}

te

Throughout this section 3 \ : foroany weber (yy coy an

O85


<small>Original source: [View scanned PDF page 288](../scans/page_0288.png)</small>

**Reference.** Tsao, N. K. and Nikolai, P. J., Procedures using Orthogonal Transformations for Linear Least Squares Problems. Report ARL TR 74-0124, Aerospace Research Laboratories, Wright-Patterson Air Force Base, 1974.

CALL DLSQR(MO,A, ka, m,n, B, kb, ,RERR,AERR,k,ko. RNORM, WK, éw,IWK,@iw,IERR)

MO is an argument which specifies if DLSQR is being used for the first time. On an initial call, MO = 0 and we have the following setup:

A is a double precision m x n matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ka > m. Ais destroyed by the routine.

The argument @ is an integer. If £> 1 then B is a double precision m x @ matrix and xb is the number of rows in the dimension statement for B in the calling program. Also, RNORM is a double precision array of dimension @ or larger (for output). It is required that kb > max{m,n}. If @ < 0 then there are no equations to be solved, and 6, kb, and RNORM are not used.

RERR is a double precision value which specifies the relative accuracy of the data in A. If it is estimated that the elements in A are accurate to p significant decimal digits then one may set RERR = 1074. It is required that RERR > 0. If RERR — 0 then it is assumed that the elements in A are accurate to machine precision.

AERR is a double precision value which specifies the maximum absolute uncertainty of the data in A. For example, if it is estimated that the elements a,; of A have the relative

~ 10 3° then one may set AFRR 10 “8. It is required

accuracy RERR except when fa,, thet AERR > 0.

The arguments &, ky, and HERR are variables. When DLSQR is called, if no input errors are detected then HERR is set to O and the rank of A ois bounded from above and below using the tolerances RERR and AFRR. The variable Ais set to the upper bound and ky to the lower bound. (ff © dl then the nos f@rmatrixc No whose caiatnus are the minimum length solution vectors is computed (using & as the rank) and stored in A. Also, the residual norm [fAr, 8,{) is computed and stored i RNORM()) for 7 bo 0&

WK is a double precision array of dimension @w where éw o> 5-muingmyn}, and IWA

is an integer array of dimension fru where @ie som toa WR and PWR are work spaces tor

the routine

**Error Return.** TERR is assigned one of the following values where an erie is detected TR boas bern: 1 IER 2 kus orn [RRR 3 kb - miasdral nd TERR Hofstra ron TERR DQ fies toa small

Osb


<small>Original source: [View scanned PDF page 289](../scans/page_0289.png)</small>

```text
TERR = 6 RERR or AERR is negative.
IERR =: 7 MO 40 and @< 0.
```

No computation is performed when an error is detected.

After an initial call to DLSQR, J IERR = 0 then the routine may be called with MO 7% 0. In this case, it is assumed that only B has been modified and that the new set of equations AX = B are to be solved. The routine employs the Householder factorization of A stored in A, WK, and IWK on the initial call to DLSQR.

When MO +# 0, it is assumed that A,ka,m,n,k,IWK, and érw have not been modified by the user. If k == 0 or k = min{m,n} then only the first min{m, n} elements of WK are needed and one may set éw > min{m,n}. Otherwise, it is required that €w > 2-min{m,n}.

RERL, AERR, and ko are not used when MO # 0. The only assumptions concerning the new B, kb, and € are that kb > max{m,n}, @ > 1, and the dimension of RNORM is now the new value of @. When DLSQR is called, if no input errors are detected then IERR is set to 0 and the new solution matrix X obtained. As before, X is stored in B and the residual norms are computed and stored in RNORM.

**Remarks.**Normally ko =k, in which case k is the rank of A. However, if ko # k then it is recommended that DHFTI2 be used for obtaining the most appropriate value for the rank and solving AX = B. If DHFTI2 is used, the sizes of the elements of the solution matrix X should be considered (in addition to the values of the residual norms). Frequently, the lower bound kp will be found to be the most appropriate value for the rank.

**Programming.** DLSQR employs the subroutines DUIILS, DU12L8S, DU11US, DU12US, ISWAP, DSWAP, DAXPY, DSCAL and functions DDOT, DNRM2, IDAMAX, DPMPAR, IPMPAR. DLSQR was written by A. H. Morris and DUIILS, DU12LS, DU11US, DU12US were written by T. Manteuffel (Los Alamos).

**References.** Manteuel, T., An Interval Analysts Approach to Rank Determination tn Linear Least Squares Problems, Report SAND 80-0655, Sandia Laboratories, Albuquerque, New Mexico, 1980.

```fortran
CALL DHFTI(A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP)
CALL DHFTI2(A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR)
```

A is a double precision m x n matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ka > m.

The argument @ is an integer. If €> 1 then B is a double precision m x @ matrix and kb is the number of rows in the dimension statement for B in the calling program. [t is required that kb > maxfm,n}. If é@ < 0 then there re po equations to be solved, and 2 and kb are not used.

If @> | then RNORM is a double precision array of dimension € or larger. Otherwise, ih @< O then RNORM ts ignored, When DHETE or DHE PE is called, if @ > 1 then the

n>» @ matrix X whose columns are the minimum length solution vectors is computed and


<small>Original source: [View scanned PDF page 290](../scans/page_0290.png)</small>

stored in J. Also, the residual norm || Az, — 6,|| is computed and stored in RNORM(j) for 7=l,...,8

H,G, and IP are arrays of dimension n or larger that are work spaces for the routines. HW and G are double precision arrays.

The parameters r,k, and D.

vy is a double precision tolerance that is set by the user, * an integer variable, and D a double precision array of dimension min{m,n} ox larger. It is assumed that r > 0. Normally 7 = 0 is the setting that is used. D and & are set by the routines.

In order to understand the use of r,k, and D one must be briefly acquainted with the processing of A. The routines first reduce A to a triangular matrix C where A = QCP. Q is an orthogonal matrix and P a permutation matrix. P is defined so that the diagonal elements c,; of C satisfy |c.| > |ev41,:41| for each 1. The variable k is set to the largest integer such that |c,,| > 7, and if DHFTI2 is used then the diagonal elements ¢,;; are stored in D. C is now regarded as the partitioned matrix

\+ C1 C4 c= (5 é]

where Cy is ak x k matrix. Minimum length least squares solutions 2, are then computed for the problems Az, = b, using only the first k rows of C. This is equivalent to replacing

A with ~ Cy C2

and solving Az; = 6, forj=1,...,@.

Since ley] > -«- > |ex,| > 7 clearly k is the rank of A. It is also true that the ratio |c11| / |exx| is a lower bound on the condition number of C, (relative to the spectral norm). Thus, if the ratio is extremely large (say > 10%) then a severe loss of accuracy can be expected. A large ratio may be due all or in part to rank deficiency (or near rank deficiency) of the matrix A. Fortunately, rank deficiency is frequently rot too difficult to detect and cure. When A is rank deficient then machine roundoff may assign cy, a small value, say 10-78, when it should be 0. The cure is to examine the diagonal elements c,, which are stored in D, to reset r so as to eliminate the unwanted c¢,,’s, and then to rerun the problem. This will reduce the order of C;, thereby lowering the rank of the replacement matrix A. C will now be better conditioned, but the value of the residual norms {| Az, ~ 6,|| may be larger. If the norms do increase, then the solution obtained will be satisfactory only if the size of the increased norms fall within acceptable bounds.

**Remarks.**

(1) The variable k is set to O if all les, for AX BB.

(2) If € < 0 then the decomposition A =. QCP is performed, the diagonal elements of C are stored in D, and & is computed.

<a. Uf Ao O then the zero matrix is the solution

(3) The contents of A are destroyed by the routines,

OQ ard


<small>Original source: [View scanned PDF page 291](../scans/page_0291.png)</small>

(4) DHFTI and DHFTI2 yield the same results. These routines are double precision versions of the subroutines HFTI and HFTI2.

**Error Return.** IERR is a variable that is set by the routine. If no input errors are detected then IERR is set to 0. Otherwise, JERR is assigned one of the following values:

```text
IERR = 1 if m> ka
IERR = 2 if 2> 1 and kb < max {m,n}
```

When an error is detected, the routine immediately terminates.

**Programming.** DH®TI and DHFTI2 call the subroutine DH12. These routines are modifications by A. H. Morris of the subroutines HFTI and H12, written by Charles L. Lawson and Richard J. Hanson (Jet Propulsion Laboratory).

**Reference.** Lawson, C. L., and Hanson, R. J., Solving Least Squares Problems, Prentice- Hall, Inc., Englewood Cliffs, New Jersey, 1974.


<small>Original source: [View scanned PDF page 292](../scans/page_0292.png)</small>

<a id="topic-292-01"></a>
### Least Squares Solution Of Systems Of Linear Equations With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [`L71031`](../source_parts/nswc_part_07.f90#L7469) |


Let A be an m, Xn matrix, H anim, Xn matrix, G an m, xn matrix, 6 a column vector of dimension m,, f a column vector of dimension m,, and A a column vector of dimension m,. The subroutine LSEi is available for finding a column vector z of dimension n that minimizes || Ax -- 6|| subject to the constraints?

Er =~ f Gx >h.

Ka ~ f states that 2 is a least squares solution of the equation Ex = f, and Gz > h means that every component of the vector Gz must be equal to or greater than the corresponding component of hk. It is assured that m, > 0, m, > 0, and m, > 0.

CALL LSEI(W. kw, m.,ma,m,,n, OPT, z, RNORME,RNORMA, IERR,WK,IWK)

Ifm =m, +m, +m, then W is the m x (n + 1) matrix:

‘Ef W (4 | Goh The input argument kw is assumed to have the value:

kw = the number of rows in the dimension statement for W in the calling program Thus it is required that kw > m.

RNORME and RNORMA are real variables. When LSE is called, if the constraints Eig ~ f and Gx > A are consistent then 2 is computed, RNORMF is assigned the value |x ~ f||,? and RNORMA is assigned the value {|Az - 6]].

OP'T is an array, called the option vector, which permits the user to take advantage of certain options that are supplied by the routine. If no options are desired then OPT may be declared to have dimension 1 and OPT(1L) must be assigned the value 1. The details concerning the available options and how to specify them in OPT are given below.

IWK is an array of dimension my, | 2n-+ 2 or larger, and WK is an array of dimension 2(m, +n) 4 max {my +my,n} ot (m, + 2)(n + 7) or larger. EWK and WK are work spaces. When LST is called, using a solution for Wa -~ f, a reduced least squares problem with inequality constraints is obtained and solved. When the routine terminates IWK(1), IWK(2), IWK(3) contain the following information:

‘SY Throughout this section [leq] denotes the worn Via for any vector er (eyseu, oj.

“Ifon. . Othen RNOKME OG.


<small>Original source: [View scanned PDF page 293](../scans/page_0293.png)</small>

```text
{WK(i) = the estimated rank of the matrix EF
IWK(2) = the estimated rank of the reduced problem
IWK(3} = the amount of storage in the array WK that was actually needed
```

```text
IERR is a variable that is set by the routine. When LSEI terminates, IERR has one
of the following values:
IERR = O The solution xz was obtained. The equality Ex = f is satisfied
when m, #0.
IERR = 1 The solution z was obtained. In this case || Zz — f|| > 0.
IERR = 2 The problem cannot be solved. The constraints are inconsistent.
IERR = 4 (Input error) Either kw < m, the covariance matrix is requested
and kw <n, or the option vector OPT is not defined properly,
```

If IERR > 2 then z, RNORME, and RNORMA are not defined.

**Remarks.**

(1) W is modified by the routine.

(2) If m, +m, <0 orn <0 then IERR is set to O and the routine terminates.

The option vector OPT. If no options are desired then OPT may be declared to be of dimension | and OPT(1) must have the value 1. Otherwise, OPT is a linked list consisting of groups of data link,, key,;, data; (¢ = 1,...,8). Each link; and key, is an integer. The amount of storage required by data; depends on the value of key;. The general layout of OPT is as follows:

```text
OPT(1) = link, (index of the first entry of the next group)
OPT(2) = key; {key to the option)
OPT(3) = the first word of the data (data,) for this option
```

```text
OPT(link;) = linky (index of the first entry of the next group)
OPT (link; + 1) == key2 (key to the option)
OPT(link; + 2) = the first word of the data (data2) for this option
```

OPT(link,) = 1.0 (There are no more options to be considered.) The following options are available:

key © 1 It is assured that &w > n. Compute the n xn covariance matrix and store it in the first n rows and columns of W. The data for this option is a single value. It must be nonzero for the covariance

matrix to be computed. BE key | 2 Scale the nonzero columns of the matrix (+) so that they have GG


<small>Original source: [View scanned PDF page 294](../scans/page_0294.png)</small>

key = 3

key = 4

key =

Also the key 8 and 9 options for the least squares subroutine WNNLS are permitted. (WNNLS is employed by LSEI.) The order of the options in the array OPT is arbitrary. If an option has an unrecognized key then the option is ignored. It is assumed that the dimension of OPT is no greater than 100000 and that the number of options is < 1000. If either of these assumptions is violated then IERR is set to 4 and the routine terminates. {t is also required that link, 4 link, for ¢ # 7. If this restriction is not satisfied then the

length 1. The data for this option is a single value. It must be nonzero for the scaling to be performed.

E Scale the columns of the matrix (4). The data for this option

consists of n scaling factors, one for each matrix column.

Change the internal tolerance r which is used for determining the rank of #. The data for this option is the new tolerance. + may be set to any value > € where ¢ is the smallest floating point number for which 1+ ¢€ > 1{e = 2~*? for the CDC 6700). If the new value is less than ¢ then it is ignored and r is set to «. The default value employed for r is \/e.

Change the internal tolerance + which is used for rank determination in the reduced least squares problem. The data for this option is the new tolerance. r may be set to any value > ¢ where € is the smallest floating point number for which 1+ € > 1. If the new value is less than € then it is ignored and r is set to €«. The default value employed for r is \/e.

linked list OPT is circular and we again have an [ERR = 4 error.

**Example.** Assume that we have an array D containing n scaling factors for the columns of

; E the matrix (4

, and that the tolerance TOL is always to be used for rank determination.

G/ Then OPT will have to be of dimension > n+ 9 and OPT can be defined as follows:

```fortran
OPT(1)
```

=N+3 (Scaling option)

```text
OPT(2) = 3.0
DG 101 =1,N
```

```text
10 = OPT(I +2) = D(D
OPT(N +3)=N+6 (Matrix E tolerance option)
OPT(N +4) = 4.0
OPT(N +5) = TOL
OPT(N 4-6) = N49 (Reduced problem tolerance option)
OPT(N +7) = 5.0
OPT(N +8) = TOL
OPT(N + 9) = 1.0 (There are ne more options.)
Remarks.
```

(1) LSEL may perform poorly if the norms of the rows of A and #7 differ by many orders

of magnitude, or if the norms of the rows of F are exceedingly small.

(2) ‘The covariance matrix obtained by the key = | option may not be meaningful when


<small>Original source: [View scanned PDF page 295](../scans/page_0295.png)</small>

there are inequality constraints Ga > h. This matrix assumes that any inequalities which are selected by the algorithm to be equalities remain equalities when the solution is perturbed. This, of course, may not be the case.

**Programming.** LSEI employs the subroutine LSI, LPDP, WNNLS, WNLSM, and WNLIT. These routines were written by Karen H. Haskell and Richard J. Hanson (Sandia Laboratories) and modified by A. H. Morris. The subroutines HF TI, H12, SROTM, SROTMG, SCOPY, SSWAP, SSCAL, SAXPY and functions SPMPAR, SDOT, SASUM, SNRM2, ISAMAX are also used.

**References.**

(1) Hanson, R. J. and Haskell, K. H., “Algorithm 587: Two Algorithms for the Linearly Constrained Least Squares Problem,” ACM Trans. Math Software 8 (1982), pp. 323-333.

(2) Haskell, K. H. and Hanson, R. J., “An Algorithm for Linear Least Squares Problems with Equality and Nonnegativity Constraints,” Math. Programming 21 (1981), pp. 98-118.


<small>Original source: [View scanned PDF page 296](../scans/page_0296.png)</small>

<a id="topic-296-01"></a>
### Least Squares Solution Of Systems Of Linear Equations With Equality And Nonnegativity Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [`L72171`](../source_parts/nswc_part_07.f90#L8609) |


Let A be an m, Xn matrix, FE an m, x n matrix, b a column vector of dimension m,, and f a column vector of dimension m, The subroutine WNNLS is available for finding a column vector z = (zy, ...,2,)* that minimizes || Az — || subject to the constraints!

Be~ za; > Ofor?t> &.

Ex = f states that z is a least squares solution of the equation Ex = f. It is assumed that m, 2 0,m, > 0, andO< @<n. If m, = 0 then WNNLS solves Ex ~ f subject to the constraints z; > 0 (> ¢),

```fortran
CALL WNNLS(W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK)
```

ifm =m, +m, then W is the m x (n + 1) matrix:

_(#f w= (J \)

The input argument kw is assumed to have the value: kw = the number of rows in the dimension statement for W in the calling program Thus it is required that kw > m.

RNOKM is a variable. When WNNLS is called, 2 is computed and RNORM is assigned

the value \/ Az — b||? +]

OPT is an array, called the option vector, which permits the user to take advantage of certain options that are supplied by the routine. If no options are desired then OPT may be declared to have dimension | and OPT(1) must be assigned the value 1. The details concerning the available options and how to specify them in OPT are given below.

IWK is an array of dimension mm {nor larger, and WK is an array of dimension mi} 5n or larger. IWK and WK are work spaces for the routine.

**Error Return.** MODE is an integer variable that is set by the routine. If the problem is solved then MODE is assigned the value 0. Otherwise, MODI is assigned one of the following values: MODE — 1 The maximum umber of iterations (3(n — @) iterations) was exceeded. An approximate solution and its residual norm are stored in 2 and RNORM. MODE — 2 (input error) Hither kw > mor 0 < & < n is violated, or the option vector OPT is not properly defined.

'Throughout this section |jcj! denotes the norm Jue for any vector ¢ > (cy,¢a,...)- *ifrag O then RNORM — He fil, and ifm, © 0 then RNGRM Ax if.


<small>Original source: [View scanned PDF page 297](../scans/page_0297.png)</small>

When an input error is detected, the routine immediately terminates. In this case x and

RNORM are not defined.

**Remarks.**

```text
1) W is modified by the routine.
7 y
(2) If m <0 orn <0 then MODE is set to 0 and the routine terminates.
```

The option vector OPT. If no options are desired then OPT may be declared to be of dimension 1 and OPT(1) must have the value 1. Otherwise, OPT is a linked list consisting of groups of data link,, key;, data; (¢ = i, ...,8). Each link, and key, is an integer. The amount of storage required by data; depends on the value of key,. The general layout of OPT is as follows:

```text
OPT(1) = link; (index of the first entry of the next group)
OPT(2) = key; (key to the option)
OPT(3) = the first word of the data (data,) for this opficn
```

```text
OPT(link,) = link2 (index of the first entry of the next group
OPT(link; + 1) = keyz, (key to the option)
OPT(link; + 2) = the first word of the data (dataz) for this option
```

```fortran
OPT(link ) = 1.0 (There are no more options to be considered.)
```

The following options are permitted:

key = 6 Scale the nonzero columns of the matrix (4) so that they have length 1. The data for this option is a single value. It must be nonzero for the scaling to be performed.

key = 7 Scale the columns of the matrix (4). The data for this option consists of n scaling factors, one for each matrix column.

key ~ 8 Change the internal tolerance 7 which is used for rank determination. The data for this option is the new tolerance. 7 may be set

~,

to any value > ¢ where ¢ is the smallest floating point number for which 1+e > 1. (¢> 2 47 for the CDC 6700.) If the new value is less than ¢ then it is ignored and 7 is set to ¢. The default value employed for r is \/e.

key = 9 Change the parameter BLOWUP. The reciprocal of this parameter ig used in determining when solution components are too large. The data for this option is the new value for BLOWUP. It is assumed that BLOWUP < 1. BLOWUP may be set to any value > ¢ where ¢ is the smallest number for which Lt «> E If the new value is less than ¢ then it is ignored and BLOWUP is set to e. The default value used for BLOWUP us \/e.


<small>Original source: [View scanned PDF page 298](../scans/page_0298.png)</small>

The order of the options in the array OPT is arbitrary. If an option has an unrecognized key then the option is ignored. It is assumed that the dimension of OPT is no greater than 100000 and that the number of options < L000. If either of these assumptions is violated then MODE is set to 2 and the routine terminates. [t is also required that link, 4 link, for 1: 7. if this restriction is not satisfied then the linked list OPT is circular and we again have a MODE = 2 error.

**Example.** Assume that we have an array D containing n scaling factors for the columns of the matrix (”), and that TOL is the tolerance to be used for rank determination. Then OPT will have to be of dimension > n+ 6 and OPT can be defined as follows:

```text
OPT) = N +3 (Scaling option)
OPT(2) = 7.0
DO 10 T= 1,N
10 OPT(I+2) = D(n
OPT(N + 3)=N+6 (Tolerance option)
OPT(N + 4) = 8.0
OPT(N + 5) = TOL
OPT(N + 6) = 1.0 ( here are no more options.)
```

**Remark.** WNNLS may perform poorly if the norms of the rows of A and F differ by many orders of magnitude, or if the norms of the rows of E are exceedingly small.

**Programming.** WNNLS employs the subroutines WNLSM and WNLIT. These routines were written by Karen H. Haskell and Richard J. Hanson (Sandia Laboratories), and modified by A. H. Morris and Virgis Dadurkevicius (Astronomical Observatory, Vilnius University, Lithuania). The subroutines H12, SROTM, SROTMG, SCOP Y, SSWAP, SSCAL, SAXPY and functions SPMPAR, SASUM, SNRMzZ, ISAMAX are also used.

**References.**

(1) Dadurkevicius,V.,“Remark on Algorithm 587,"ACM Trans. Math Software 15 (1989),

pp. 257-261

Hanson, R. J. and Haskell, K. H., “Algorithm 587: ‘Two Algorithms for the Linearly

Constrained Least Squares Problem,” ACM Trans. Math Software 8 (1982), pp. 323-

333.

(3) Haskell, K. Ho and Hanson, Ro Jo, “An Algorithm for Linear Least Squares Problems with Equality and Nonnegativity Constraints,” Math. Programming 2 (1981), pp. 98 118.

(2

—


<small>Original source: [View scanned PDF page 299](../scans/page_0299.png)</small>

<a id="topic-299-01"></a>
### Least Squares Iterative Improvement Solution Of Systems Of Linear Equations With Equality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [`L73470`](../source_parts/nswc_part_07.f90#L9908) |


Let A be an m, x n matrix, E an m, Xn matrix, 3 an m, x & matrix, and F an m, x &€ matrix. It is assumed that 0 < m, < n and that the rank of Eis m,. Let by, ...,5¢ denote the column vectors of B and fi, ...,f¢ the column vectors of F. The subroutine L2SLV is available for finding the unique minimum length column vector z, of dimension n that minimizes ||/Az, — 6,;|| subject to the equality constraints Ez, = f, (if there are any) for 7 = 1,...,@ Iterative improvement is performed to compute the vectors Z1,.-.4,2¢ to machine accuracy. It is assumed that ma > 0. If mg = 0 then L2SLV finds the unique minimum length solution z,; to fz; = f; forj=1,...,€.

CALL L2SLV(m,n,m,, ¢, A, ka, B, kb, WGTS,TOL,NLIPIVOT, X,kz, R, kr,T, kt, WK,IERR)

if m= m,+ mg then A is the mx n matrix (7) and B is the m x & matrix (3): The Input arguments ka and kb have the values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement, for B in the calling program It is assumed that m > 1,n > 1,0> 1,ka > m, and kb >m. A and B are not modified by the routine.

WGTS is an array containing m nonnegative weights. The first m, weights are set to 1.0 by the routine. Let w;, ...,Wm, denote the remaining weights (i.e., let w, = WGTS(m, +1) for t =: J ma). The remaining weights are supplied by the user. In effect, w, is the weighting that is given to the t'* equation in the least squares problem Ar, ~ 6,. If W denotes the mg x m, diagonal matrix diag(w1, ...,wm,) then L2SLV finds the unique minimum length vector that minimizes ||WAz, W,|| subject to Ez, = f, forj = 1,...,€@

yor gy

For convenience, W will denote the m x m diagonal matrix diag (1,...,1,w., ...,Wm,)-

X is ann x @ matrix that contains the solution vectors 2), ...,2¢ when the routine terminates. The input argument kx is the number of rows in the dimension statement for X in the calling program. It is assumed that kar o> on.

Ris anim * @ matrix. Let 6, denote the jy"

Py of Bfor yg 1,048

column vector Then L25LV stores the residual vector r, Wb, WaAz, in the 7" column of Ro The input argument kris tee number of rows in the dimension statement for Hin the calling program.

It is assumed that kr o> yn.

WK is an array of dimension G(r 4 om) + 2@ or larger that is used for a work space When L2SLV terminates, for 7° 1, ...,8

fon, if iterative improvement of the solution #, converged

nm, if iterative improvement of 1, farted to converge 'Throughout this section fj denotes the norm yiae? for any vector ec feq, ang?


<small>Original source: [View scanned PDF page 300](../scans/page_0300.png)</small>

where n, is the number of iterations in the iterative improvement process that were performed in computing z,. Also

WK(é+ 7) = the estimated number of correct digits in z, before iterative improvement was performed for g-:1,...,8

TOL and N1 correspond to the parameters r and k in the least squares subroutines HFTI and HFTI2. TOL is a nonnegative number that is specified by the user, and NI is a variable that is set by the routine. When L2SLV is called, modified Gram-Schmidt orthogonalization with column pivoting is used to reduce WA to the form (A; Az) where A; is an mx N, matrix having rank N,. A, is of the form QU where Q'Q ~ diag(d1, ...,dn,) and U is an upper unit triangular matrix. The values d,,d2, ... correspond to the diagonal elements cy1,C22, ... generated by HFTI and HFTI2 (d, > c?. fort = 1,2,...). The values are ordered so that d, > d,,1, and d;,d2,... are stored in WK(2@ + 1), WK(2@ + 2),.... If m -m, then N11 is assigned the value m,. Otherwise, ifm > m, then N1 is the largest integer k for which dy, > 7. Herer TOLif TOL > 0, and rt ~ (ne)?dya. yp. where ¢ is the smallest value for which 1+ ¢ > E(e 2 47 on the CDC 6700) if TOL = 0. Thus, if TOL

0 then a tolerance based on the computer precision is used to determine the rank of Ny of WA, Otherwise, if TOL ©- 0 then TOL is the tolerance that is used to specify the rank of the problem to be solved. If the user inadvertently sets TOL to be negative then L2SLV resets TOL to be 0.

IPIVO'T is an array of dimension nor larger that is used by L2SLV to record the order in Which the columns of WA are selected by the pivoting procedure when WA is reduced to (A, Aa). If NI. om then the first Ni elements of IPIVOT are the indices of the columns of

~

WA from which the matrix A, is generated,

Tosa 2-dimensional array of dimension kt x n that is used for temporary storage. it is assumed that kl cm +n When L2SLV terminates, if NE nothen the unscaled m+ on covariance matrix is stored in the first a rows and columns of 7.) Iterative improvement is

not performed on the covariance matrix

Error Return PRR is an integer variable Ghat as set by the routine. If no input errors are detected and the results appear to be satisfactory, then EER is set to 0) Otherwise, TERR

is assigned one of the following values

ERR To Either min, or @as not positive

TERR 2° The restriction O + on, tanger p is not satisfied

IRE Sobither ka com kb con Aa ton Rr som or kt ory reas violated TERR A WOPPS()) is negative for some a + ora,

[ERR Oo Either WA Gor Boo IE RR @ The rank of boas less than oa,

IRR fo Iterative improvement of all the solutions ary, oy farted ta con Wwergres

ie oanen & Iterative improvement of cue or more solutions fared to converge

HEAR Oo More than go iterations of the iterative improvement procedure Were performed ta connpatitg: seme a, (Here it is assumed that oa

tional


<small>Original source: [View scanned PDF page 301](../scans/page_0301.png)</small>

p decimal digit floating-point arithmetic is being used. yw = 14 for the CDC 6700.) TERR = 10 The accuracy of some x; before iterative improvement was estimated to be less than half a decimal digit. TERR = IL One ox more of the computed diagonal elements of the covariance matrix is negative. This is due to roundoff error. Theoretically, all the diagonal elements should be nonnegative. No evidence of severe ill-conditioning was detected. IERR = 12 One or more of the computed diagonal elements of the covariance matrix is negative This is due to roundoff error. Theoretically, all the diagonal elements should be nonnegative. The problem appears to be extremely ill-conditioned. When an input error is detected (IERR = 1,2, ...,6} thea L2SLV immediately terminates. If evidence of severe ill-conditioning is detected, then FRR is sct to 8,5, or 10 aad computation of the solutions continues. If iterative improvement appears to converge for one or more of the solutions, then the covariance matrix is also computed (when N1 = n). However, if iterative improvement fails for all the solutions r,,...,2, then IERP is set to 7 and the covariance matrix is not computed.

**Note.** WK(1), ...,WK(22) should be examined when severe ill-conditioning is detected.

**Programming.** L2SLV employs the subroutines DECOM2, SOLVE2, SOLVE3, and CO- VAR. These routines were written by Roy Wampler (National Bureau of Standards). L2SLV is a slightly modified version by A. H. Morris of the subroutine L2B discussed in reference (4). The algorithm employed for finding and iteratively improving the least squares solutions is described in references (1)-(3). The function SPMPAR is also used.

**References.** (1) Bjorck, Ake, “Solving Linear Least Squares Problems by Gram-Schmidt Orthogonalization,” BIT'7 (1967), pp. 1-21.

```text
(2) si (“ws “Iterative Refinement of Linear Least Squares Solutions I,” BIT 7
(1967), pp. 257-278.
(3) | _.  , “Iterative Refinement of Linear Least Squares Solutions II,” BIT 8
```

(1988), pp. 8-30.

(4) Wampler, Roy, “Solutions to Weighted Least Squares Problems by Modified Gram- Schmidt with Iterative Refinement,” ACM Trans. Math Software 5 (1979), pp. 457- 465.


<small>Original source: [View scanned PDF page 302](../scans/page_0302.png)</small>

<a id="topic-302-01"></a>
### Iterative Least Squares Solution Of Banded Linear

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [`L75265`](../source_parts/nswc_part_08.f90#L1175) |


EQUATIONS

Given an m x nm matrix A, a column vector 6 of dimension m, and a real number A

Let A = (“) where I is the n x n identity matrix, and let b = (8). The problem is to find

a column vector z of dimension n which is a least squares solution of Ax = 6. If A is stored in band form then the following subroutine is available for solving this problem.

CALL BLSQ(m,n, A, ka, mz, my, d, 6, z, ATOL,BTOL,CONLIM,MXITER, IND,ITER,COND,RNORM,XNORM, WK)

A is an m xX n matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < me < m,0 < m, <n, and ka > m. When BLSQ is called, an iterative procedure is used to obtain a least squares solution x of Ax = b. The vector 6 is modified by the routine.

ATOL and BTOL are input arguments which specify the relative accuracy of A and 6 respectively. For example, if it ig estimated that b is accurate to & decimal digits then one may set BTOL = 107*. It is required that ATOL > 0 and BTOL > 0. If ATOL = 0 or BTOL = 0, then it is assumed that A or 6 is accurate to machine precision.

Let cond(A) denote the condition number of A relative to the Frobenius norm.! In

each iteration of the algorithm being used, an estimate is made of the condition number cond(A). The estimates form a monotonically nondecreasing sequence. The input argument CONLIM is an upper limit on cond(A). If CONLIM > 0 then BLSQ terminates when an estimate of cond(A) exceeds CONLIM. This termination may be needed to prevent small or zero singular values of A from coming into effect and causing damage to the solution z. CONLIM may be ignored by being set to 0. It is assumed that CONLIM > 0.

The input argument MXITER is the maximum number of iterations that are permitted. Normally BLSQ requires less than 4n iterations. The related argument ITER is a variable. When the routine terminates ITER =: the number of iterations that were performed.

COND,RNORM, and XNORM are variables. When BLSQ terminates COND -. the last estimate made for cond(A), RNORM = ||Az -- 6||, and XNORM = j/z|].?

WK is an array of dimension 2n or larger that is a work space for the routine.

The equations Arb are considered to be compatible if for any least squares solution z,||Ax -- 6|| = OQ. IND is a variable that reports the status of the results. When BLSQ terminates, IND bas one of the following values:

Teond (A) |[Al]ei/ Abie where Al is the pseudoinverse of AL Here []C|| ¢ Jack for any matrix Co (eyy). *|ell Vie? for any vector co (ey,eu,..-).


<small>Original source: [View scanned PDF page 303](../scans/page_0303.png)</small>

```text
IND = 0
IND = 1
```

IND = 2

IND = 3

```text
IND = 4
IND = 5
IND = 6
IND = 7
Remarks.
```

(1) A large estimate of the condition number cond(A) may be due to rank deficiency or near rank deficiency of the matrix A. If it is suspected that a large estimate of cond(A) has occurred for this reason, then it is recommended tha, CONLIM be set to a moderate value such as \/e where ¢ is the smallest value such that 14 © 6000-7000 series computers). Setting CONLIM to 0 is equivalent to setting CONLIM

toe—!.

The solut’on is x =: 0. No iterations were performed.

The equations Ar -- b are probably compatible. A solution x has been obtained which is sufficiently accurate, given the values ATOL and BTOL.

The equations Ar = b are probably not compatible. A least squares solution z has been obtained which is sufficiently accurate, given the value ATOL.

An estimate COND of cond(A) exceeds CONLIM. The vector z is the most recent approximation of a solution for Az = 6b.

The equations Az = 6 are probably compatible. A solution zt has been obtained which is as accurate as seems reasonable on this machine.

The equations Ax = 6 are probably not compatible. A least, squares solution z has been obtained which is as accurate as seems reasonable on this machine.

cond(A) appears to be so large that there is not much point in doing further iterations. The vector x is the most recent approximation of a solution for Az = 3.

MXITER iterations were performed. More iterations are needed. The vector z is the most recent approximation of a solution for Ax = b.

(2) The vector } is the only input argument modified by the routine.

**Algorithm.** BLSQ employs an iterative algorithm developed by Golub and Kahan.

**Programming.**

subroutine LSQR, written by Christopher C and Michael A.

**References.**

(1) Paige, C. C. and Saunders, M. A

BLSQ calls the subroutines NORMLZ, BVPRD1, BTPRD1, SCOPY, and . The function SNRM2 is also used. BSLQ is an adaptation by A. H. Morris of the . Paige (McGill University, Montreal, Cana’a)

Saunders (Stanford University).

and Sparse Least Squares,” ACM Trans. Math Software & (1982), pp. 43-71.

(2)

Problems, ”

__. “Algorithm 583. LSQR: Sparse Linear Equations and Least Squares ACM Trans. Math Software 8 (1982), pp. 195-209.

404

> 1(€ = 27*7 for the CDC

, “LSQR: An Algorithm for Sparse Linear Equations


<small>Original source: [View scanned PDF page 304](../scans/page_0304.png)</small>

<a id="topic-304-01"></a>
### Iterative Least Squares Solution Of Sparse Linear

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [`L74403`](../source_parts/nswc_part_08.f90#L313) |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [`L74845`](../source_parts/nswc_part_08.f90#L755) |


EQUATIONS Given ai n matrix A, a column vector 6 of dimension m, and a real number 4. Let A= 4 vi: +0 is the n x n identity matrix, and let 6 = (3). The problem is to find a column vec tor: of dimension n which is a least squares solution of Az =: b. If A is sparse

then the following subroutines are available for solving this problem.

Cait :PLSQ(m,n, A,IA,JA, A, b, 2, ATOL,BTOL,CONLIM,MXITER, IND,ITER,COND,RNORM,XNORM,WK)

Cf" ITLSQ(m,n, TA,ITA,JTA, A, 6, 2, ATOL,BTOL,CONLIM,MXITER, IND,ITER,COND,RNORM,XNORM, WK)

if SPLS¢ ‘led then A,IA, JA are arrays containing the matrix A in sparse form. Otherwise, ifS 4: Q is called then TA, ITA, JTA are arrays containing the transpose matrix A‘ in sparse fo.m. An iterative procedure is used to obtain a least squares solution 2 of

Az =: 6. The vector b is modified by the routines.

ATOL and BTOL are input arguments which specify the relative accuracy of A and b respectively. For example, if it is estimated that b is accurate to k decimal digits then one may set BTOL = 107*. It is required that ATOL > 0 and BTOL > 0. If ATOL = 0 or BTOL = 0, then it is assumed that A or } is accurate to machine precision.

Let cond(A} denote the condition number of A relative to the Frobenius norm.! In each iteration of che algorithm being used, an estimate is made of the condition number cond(A). The estimates form a monotonically nondecreasing sequence. The input argument CONLIM is an upper limit on cond (A). If CONLIM > 0 then the routines terminate when an estimate of cond(A) exceeds CONLIM. This termination may be needed to prevent small! or zero singular values of A from coming into effect and causing damage to the solution x.

CONLIM may be ignored by being set to 0. It is assumed that-CONLIM > 0.

The input argument MXITER is the maximum number of iterations that are permitted. Normally the routines require less than 4n iterations. The related argument ITER is a variable. When the routines terminate ITER = the number of iterations that were performed.

```text
COND, RNORM, and XNORM are variables. When the routines terminate COND =
the last estimate made for cond(A), RNORM = ||/Az ~ b||, and XNORM = ||z||.?
```

WK is an array of dimension 2n or larger that is a work space for the routines.

```text
feond (A) = ||Allp[|At lle where At is the pseudoinverse of A. Here (Cllp Sree, for any matrix
Ie] fried for any vector ¢ =. (cy,e9,...).
```

A0S


<small>Original source: [View scanned PDF page 305](../scans/page_0305.png)</small>

The equations Az -. 6 are considered to be compatible if for any least. squares solution x, || Aa ~ bl] = 0. IND is a variable that reports the status of the results. When the routines

terminate, IND has one of the following values:

IND = 1 The equations Az - 6 are probably compatible. A solution z has been obtained which is sufficiently accurate, given the values ATOL and BTOL.

IND = 2 The equations Az ~—b are probably not compatible. A least squares solution x has been obtained which is sufficiently accurate, given the value ATOD.

IND = 3 An estimate COND of cond(A) exceeds CONLIM. The vector x is the most recent approximation of a solution for Az — 6.

IND = 4 The equations Az — b are probably compatible. A solution z has been obtained which ig as accurate as seems reasonable on this machine.

IND = 5 The equations Az- 6 are probably not compatible. A least squares solution z has been obtained which is accurate as seems reasonable on this machine.

IND = 6 cond(A) appears to be so large that there is not much point in doing further iterations. The vector x is the most recent approximation of a solution for Az — 6.

IND = 7 MXITER iterations were performed. More iterations are needed. The vector x is the most recent approximation of a solution for Ax = b.

**Remarks.**

(1) A large estimate of the condition number cond(A) may be due to rank deficiency or near rank deficiency of the matrix A. If it is suspected that a large estimate of cond(A) has occurred for this reason, then it is recommended that CONLIM be set to a moderate value such as \/e where € is the smallest value such that 1+e¢ > 1 (¢ = 27‘? for the CDC 6000--7000 series computers). Setting CONLIM to 0 is equivalent to setting CONLIM toeTt,

(2) The vector 6 is the only input argument modified by the routine.

**Algorithm.** SPLSQ and STLSQ employ an iterative algorithm developed by Golub and Kahan.

**Programming.** SPLSQ and STLSQ call the subroutines NORMLZ, MVPRDI, MTPRD1, SCOPY, and SSCAL. The function SNRM2 is also used. SPLSQ and STLSQ are: adaptations by A. H. Morris of the subroutine LSQR, written by Christopher C. Paige (McGill University, Montreal, Canada) and Michael A. Saunders (Stanford University).

**References.**

(1) Paige, C. C. and Saunders, M. A , “LSQR: An Algorithm for Sparse Linear Equations and Sparse Least Squares,” ACM Trans. Math Software 8 (1982), pp. 43-71.

(2) 2 0 , ‘Algorithm 583. LSQR: Sparse Linear Equations and Least Squares Problems,” ACM Trans. Math Software 8 (1982), pp. 195-209

