[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-279"></a>
## L1 Solution of Linear Equations

<small>Original source: [View scanned PDF page 279](../scans/page_0279.png)</small>

<a id="topic-279-01"></a>
### L1 Solution Of Systems Of Linear Equations With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [`L63464`](../source_parts/nswc_part_06.f90#L10382) |


Let Abeakxn matrix, C an éxn matrix, and “an mxn matrix. Also let b,d, and f be column vectors of dimensions hk, @, and mm respectively. The following subroutine is available for obtaining a column vector of dimension n which minimizes || Ax -- b||) = > |A,x — 6! ead subject to the constraints

Here A; denotes the i*" row of A, and Hx < f means that every component of Ez is less than or equal to the corresponding component of f. CALL CL1(k, 6, m,n, Q,kq, KODE,TOL,ITER, X, RES,RNORM,WK,IWK)

It is assumed that k > 1,8 > 0,m ~~ 0, and n> 1. Q is a 2-dimensional array with kg rows and at least n -+- 2 columns where kg > k+ &+m4+2. The matrices A,C, © and vectors 6,d, f are stored in the first k + @+ m rows and n+ 1 columns of Q as follows:

Ab" Q=;1C a hf

Q is modified by the routine.

KODE is a variable used for input/output purposes, X an array of dimension n+ 2 or larger, and RES an array of dimension k + @+ m or larger. On input KODE is normally set by the user to 0. This indicates that ||Azx -~ 8]; is to be minimized subject only to the constraints Cz = d and Er < f. However, if it is also desired that one ar move variables x, satisfy x; < 0 or x; > O, or that one or more residuals 6; ~ A,z satisfy b; ~ Ayz < 0 or

b, - Aya > G, then the user may set KODE to a nonzero value. if KODE 4 O on input, then the user must also set X(j}) and RES(t) to the values

{-10 2, <0 X(j) > 0.0 2; is unrestricted 1.0 2;>0 { 10 b> Aya <0 RESG) 0.0 6 Aya is unrestricted

iO b&b Ayr > 0 for gy ook, ym anda co J,...,k to indicate the additional constraints which are desired,

INCOM is a variable When Ch} os called. if a vector gis found that minimizes HAs bl subject to the desired constraints, then ROOR © Quon output and the solution 4


<small>Original source: [View scanned PDF page 280](../scans/page_0280.png)</small>

is stored in X. Also RNORM is assigned the value ||Az — 4||},6 — Az is stored in the first k locations of RES, ¢ - Cx is stored in the next @ locations, and f — Ex is stored in the last m locations.

When CLI is called, a modified form of the simplex algorithm is used to minimize ||Az ~ b||,. The arguments TOL and ITER control the use of this algorithm. The input argument TOL is a positive tolerance. CLi will not pivot on any quantity whose magnitude is less than TOL. Normally the setting TOL = 10~?”/* suffices where v is the number of decimal digits of accuracy available.

Frequently the routine requires less than 5(k+é+m) iterations of the simplex algorithm to solve the problem. ITER is a variable used for input/output purposes. On input the user must set ITER to the maximum number of iterations that will be permitted. When the routine terminates, ITER has for its value the number of iterations that were performed.

On output KODE reports the status of the results. The routine assigns KODE one of the following values:

KODE = 0 The problem was solved.

KODE = 1 The problem has no solution.

KODE = 2 Sufficient accuracy cannot be maintained to solve the problem using the current value of TOL.

KODE = 3 The maximum number of iterations were performed. More iterations are needed.

When KODE > 1 on output, X contains the last vector = which was obtained, RNORM = ||Az — b||,, and RES contains the vectors b — A#,d— Cz, and f ~ Fi.

WK is an array of dimension 2(k + £+ m-+n) or larger, and IWK 1s an array of dimension 3(k + @+ m) + 2n or larger. WK and IWK are work spaces for the routine.

**Programming.** ClL1 calls the subroutine KL1. CL was written by I. Barrodale and F. D. K. Roberts (University of Victoria, British Columbia, Canada).

**References.**

(1) Barrodale, I. and Roberts, #. D. K., “An Improved Algorithm for Discrete @; Linear Approximation,” SIAM J. Numer. Analysis 10 (1973), pp. 839 848.

```text
(2) “An Efficient Algorithm for Discrete £; Linear Approximation with Linear
Constraints, » SIAM J. Numer. Analysts 15 (1978), pp. 603 611,
(3)  , “Algorithm 552, Solution of the Constrained @,; Linear Approximation
```

Problem,” ACM Trans. Math Software 6 (1980), pp. 231-235.

