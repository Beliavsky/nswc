[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-306"></a>
## Optimization

<small>Original source: [View scanned PDF page 306](../scans/page_0306.png)</small>

<a id="topic-306-01"></a>
### Minimization Of Functions Of A Single Variable

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [`L71914`](../source_parts/nswc_part_07.f90#L8406) |


Let F(z) be a continuous real-valued function defined for a < z < b. Then the following subroutine is available for finding a local minimum of F(z}.

```fortran
CALL FMIN(F, A0, B0, X, W, AERR, RERR, ERROR, IND)
```

It is assumed that a < 6. FMIN finds a value z in the interval [a,b] which is a local minimum of F. ERROR and w are variables. When FMIN terminates, w = F(x) and ERROR is the estimated maximum absolute error of z.

The input arguments AERR and RERR are the absolute and relative error tolerances to be satisfied. For example, if k significant digit accuracy is desired then one may set RERR -= 107*. It is assumed that AERR > 0 and RERR > 0. The setting AERR = 0 is equivalent to the setting AERR = 10779, and the setting RERK = 0 is a request for machine precision.

IND is a variable that reports the status of the results. IND = 0 if z is found to the desired accuracy. Otherwise, IND = 1 when z cannot be obtained to the desired accuracy. In this case, w satisfies the tolerances AERR and RERR.

**Note.** F must be declared in the calling program to be of type EXTERNAL.

**Algorithm.** The golden section search procedure is used.

**Programming.** The function SPMPAR is called. FMIN was written by A. H. Morris.

AQT


<small>Original source: [View scanned PDF page 307](../scans/page_0307.png)</small>

<a id="topic-307-01"></a>
### Minimization Of Functions Of N Variables

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [`L72081`](../source_parts/nswc_part_07.f90#L8573) |


Let f(x) be a real-valued function of n variables x =: (z1,..,2,) where n > 2. If f(z) is twice continuously differentiable then the following subroutine is available for finding a local minimum of f(z).

```fortran
CALL OPTF(FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK)
```

X is an array of dimension n and FVAL a variable. On input, X contains an initial guess a = (a,...,a,) to a minimum of f. When OPTF terminates, X contains the final estimate z = (21,...,2,) of a local minimum of f and FVAL = f(z).

The argument F is the name of a user defined subroutine that has the format: CALL F(n, X,F VAL) Here X is an array of dimension n containing a point x = (z1,...,%,), and FVAL is a variable. F sets FVAL to the value of the function f at the point z. F must be declared in the calling program to be of type EXTERNAL.

RERR is an input argument that specifies the relative accuracy of F. If it is estimated that the subroutine F produces results accurate to k significant digits then one may set RERR = 10-*. It is required that RERR > O. If RERR = 0 then it is assumed that F produces results accurate to machine precision.

When OPTF is called, line search iteration is performed to find the local minimum of f. ITER is a variable. On input, ITER is the maximum number of iterations that are permitted. When the routine terminates, ITER = the number of iterations that were actually performed.

WK is an array of dimension n(n + 8) or larger that is a work space for the routine.

```text
IND is a variable that reports the status of the results. When the routine terminates,
IND has one of the following values:
```

IND = —1 (Input error) n < 0.

IND = ~2 (Input error) n = f.

IND — —4 (Input error) ITER < 0.

IND = -5 (Input error) Either RERR < 0 or RERR > 1074.

IND = 1 A local minimum x was found. The gradient of f at x was considered to be sufficiently small.

IND = 2 The steps taken became so small that OP'TF had to terminate. X is probably a local minimum, but it need not be a local minimum. The algorithm frequently requires exceedingly small steps to be taken, no matter whether X is close to or far from a local

minimum.

IND = 3 A local minimum has possibly been found. OPT could not find a point for which f would take a smaller value.

IND. 4 ITER iterations were performed.

IND - 5 The algorithm appears to be diverging This generally occurs

when f is unbounded from below.


<small>Original source: [View scanned PDF page 308](../scans/page_0308.png)</small>

When an input error is detected, the routine immediately terminates.

Accuracy and Efficiency. OPTF is frequently extremely efficient in finding a value FVAL which roughly approximates a local minimum value f(z), but at times it can be quite slow in obtaining FVAL to greater precision. A rough approximation is often obtained in 20--30 iterations. If f(z) # 0 then FVAL may be accurate to 4-6 significant digits after 20-30 additional iterations, or FVAL may not be accurate to 1 significant digit after several hundred iterations. 4-6 digit accuracy is the greatest precision that can be expected. In general, it is recommended that ITER < 200. Each iteration can take considerable time, even if the subroutine F is cheap to evaluate.

**Remark.** OPTF can be quite sensitive to the scaling of the variables (z,,...,2,). The routine tends to operate more efficiently when the components of a local minimum z = (z1,...,%n) are all roughly of the same magnitude. If the components are of considerably different magnitudes (say |x| * 107° and |x2| » 105) then convergence may be extremely slow. In such a case, OP TF attempts to rescale the variables, but the rescaling is not always helpful.

**Algorithm.** The line search algorithm given in pp. 325-327 of the reference is employed. Also, BFGS secant updates for the hessian are used.

**Programming.** OPTF employs the subroutines OPTDRV, OPCHK1, OPSTe’, FXDEC, SCALEX, LLTSLV, FSTOFD, FSTOCD, LNSRCH, SECFAC, QRUPDT, and JROT. OPTF, FXDEC, and SCALEX were written by A.H. Morris. The remaining subroutines were written by Robert B. Schnabel (University of Colorado at Boulder) and modified by A.H. Morris. The functions SDOT, SNRM2, and SPMPAR are also used.

**Reference.** Dennis, J.E. and Schnabel, R.B., Numerical Methods for Unconstrained Optimization and Nonlinear Equations, Prentice-Hall, Englewood Cliffs, NJ, 1983.


<small>Original source: [View scanned PDF page 309](../scans/page_0309.png)</small>

<a id="topic-309-01"></a>
### Unconstrained Minimum Of The Sum Of Squares Of Nonlinear Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [`L73124`](../source_parts/nswc_part_07.f90#L9616) |


Let fi(z), ...,fm(z) be m real-valued functions of n real variables x = (zy, ...,2,) where m > n. The problem under consideration is to find a point x which minimizes the bid

```text
function ¢(z) = 5° fi(z)*. Assume that each f,(z) is differentiable and that an initial
i=1
```

guess a = (a), 1.5 Qn) to a minimum of ¢(z) is given. Then the following subroutine is available for finding a point which minimizes ¢(z).

```fortran
CALL LMDIFF(FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA)
```

X is an array of dimension n and FVEC an array of dimension m. On input X contains the starting point a = (a;,...,a,). When LMDIFF terminates, X contains the final estimate 7 = (21, ...,%n) of a minimum of ¢ and FVEC contains the values of the functions fy, ...,f/m at the output point in X,

The argument F is the name of a user defined subroutine that has the format: CALL F(m,n, X, VEC, IFLAG)

Here X is an array of dimension n, FVEC an array of dimension m, and IFLAG an integer variable. The array X contains a point x = (z1,...,%n). Normally F evaluates the functions f,,..., fm at this point and stores the results in FVEC. However, if < does not lie in the domain of f1,..., fm then this cannot be done. In this case, the argument IFLAG (which will have been assigned a nonnegative value by LMDIFF) should be reset by F to a negative value. This will signal LMDIFF to terminate. F must be declared in the calling program to be of type EXTERNAL.

EPS is an input argument which specifies the relative accuracy of F. If it is estimated that the subroutine F produces results accurate to k significant decimal digits then one may set, EPS = 10-*. It is required that EPS > 0. If EPS = 0 then it is assumed that F produces results accurate to machine precision.

TOL is an input argument which specifies the desired accuracy to be attained. The Euclidean norm ||z|| = \/2,2? is employed. If ¢ denotes an actual minimum of ¢, then LMDIiFF terminates when an iterate x is generated for which it is estimated that

(1) O(z) < (1 + TOL)?$(z) or

(2) || D(z ~ #)|| < TOL - || Dz|| is satisfied. In (2) z and & are regarded as column vectors, and D is a diagonal matrix generated by LMDIFF whose entries are scaling factors. For convenience, criterion (1) is called the F-convergence (or ¢-convergence) test and criterion (2) is called the z-convergence test. It is required that TOL > 0. In order for the convergence tests to work properly, it is recommended that TOL always be smaller than 10° ®,

IWK is an array of dimension n and WK is an array of dimension @. IWK and WK y

are work spaces. It is assumed that @ > mn + 52 tom.


<small>Original source: [View scanned PDF page 310](../scans/page_0310.png)</small>

INFO is an integer variable that reports the status of the results. When LMDIFF terminates, INFO has one of the following values:

INFO <0 This occurs when the user terminates the execution of LMDIFF by resetting the argument IFLAG in the subroutine F to a negative value. Then INFO = the negative value of IFLAG.

{NFO =: 0 (Input error)! <n < m,EPS > 0,TOL > O,or 2> mn +5n+-n ig violated.

INFO =1 The F-convergence test has been satisfied.

INFO = 2 The z-convergence test has been satisfied.

INFO =: 3 The F-convergence and z-convergence tests have been satisfied.

INFO = 4 The gradient of ¢ is O at point X.

INFO =5 The number of calls to the subroutine F has reached or exceeded 200(n + 1).

INFO =6 TOL is too small. No further reduction in the value of ¢(z) is possible.

INFO = 7 TOL is too small. No further improvement in the accuracy of X is possible.

When LMDIFF terminates, if INFO + 0 then X contains the final iterate that was generated. Also, if INFO > 1 then FVEC contains the values of the functions f;,..., fm at this iterate. If INFO = 4 then X should be examined very closely. The gradient of ¢ can be 0 when X is a local minimum or maximum, or when X is a saddle point. If INFO = 5 then it may (or may not) be helpful to continue the procedure by recalling LMDIFF with the current point in X as the new starting point. Since TOL is a relative tolerance, this setting can occur when $(0) = 0.

**Algorithm.** A modified form of the Levenberg-Marquardt algorithm is employed.

**Programming.** LMDIFF is a slightly modified version of the MINPACK-1 subroutine LMDIF1. The MINPACK-1 subroutines LMDIF, SPMPAR, ENORM, FDJAC2, LMPAR, QRFAC, and QRSOLV are employed. The subroutines were written by Jorge J. More, Burton S. Garbow, and Kenneth E. Hillstrom (Argonne National Laboratory).

References,

(1) More, J. J., Garbow, 8. S., and Hillstrom, K. §., User Guide for MINPACK-1, Argonne National Laboratory Report ANL- 80-74, Argonne, Illinois, 1980.

(2) More, J. J., “The Levenberg-Marquardt Algorithm: Implementation and Theory,” Numerical Analysis, G. A. Watson {ed.), Springer-Verlag, 1977.


<small>Original source: [View scanned PDF page 311](../scans/page_0311.png)</small>

<a id="topic-311-01"></a>
### Linear Programming

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [`L75274`](../source_parts/nswc_part_08.f90#L1128) |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [`L76096`](../source_parts/nswc_part_08.f90#L1950) |


Let A = (¢,;;) be an mx n matrix, B an array containing 61, ...,6m, and C an array containing cy, ...,¢€, where a,;,6,,c; are real. Consider the problem of finding nonnegative values 21, ...,2, which maximize or minimize the function cy7y +-++° + en2, subject to the constraints:

4112) +++ + Qintn{S,=, >} by

Amity tet @mntn{S, =, > Son

In each constraint O12, +++? + Ain tn{<, =, 2}5,

only one of the relations <,=,> is used, but the relation may vary from constraint to constraint. The following subroutines are available for solving this problem.

CALL SMPLX(A, B,C, ka, m,n, IND,IBASIS, X, z, ITER,MXITER, NUMLE,NUMGE,BI,WK,IWK)

CALL SSPLX(TA,ITA,JTA, B,C, m,n, IND,IBASIS, X, z, ITER,MXITER, NUMLE,NUMGE,BI,WK,IWK)

Jt is assumed that m > 2,n > 2, and that each b; > 0. If SMPLX is called then ka is the number of rows in the dimension statement for A in the calling program. Otherwise, if SSPLX is called then TA, ITA, JTA are arrays containing the transpose matrix A‘ in sparse form.

The constraints a,;z7, +--+: - + GinIn{<, =, ~}b; are assumed to be ordered so that the < constraints are followed by the > constraints, and the = constraints come last. NUMLE and NUMGE have the values:

NUMLE =: the number of < constraints.

NUMGE =: the number of > constraints.

It is assumed that NUMLE > 0, NUMGE > 0, and NUMLE + NUMGE «< mu.

When SMPLX or SSPLX is called, the routine attempts to maximize S,¢,1, subject to the constraints. A modified form of the primal simplex algorithm is employed. Frequently the procedure requires less than 5 iterations to perform the task. The argument MXITER has the value:

MXITER + the maximum number of iterations that may be performed. This argument is provided by the user. The related argument VPER is a variable that is set. by the routine. When the routine terminates, PPER has for its value the number of iterations that were performed. IND is a variable and fRASIS an array of dimension ma. ERASIS contains Che indices of the current basic variables zy, and END) is used for input/output purposes. On it put IND is normally set by the user to 0. if END Q then the routine selects its own


<small>Original source: [View scanned PDF page 312](../scans/page_0312.png)</small>

beginning basis and stores the appropriate indices in IBASIS. [The remainder of this paragraph may be skipped by anyone not acquainted with the simplex algorithm.| If the user wishes to use his own beginning basis, then IND must be set to 1 and the indices of the initial basic variables stored in IBASIS. It ts not required that the initial basts be selected so that the baste variables are nonnegative. The initial basic variables may be original, slack, surplus, or artificial variables. Slack and surplus variables are automatically provided for the < and > constraints, and artificial variables for the = constraints. The routine defines z,,,,; to be the slack, surplus, or artificial variable for the ¢** constraint 4512, +++: + Qintn{<,=, >}b;. lf IND = 0 then the slack, surplus, and artificial variables are the initial basic variables that are employed.

On output [ND reports the status of the results. The routine assigns IND one of the following values:

IND =0 The problem was solved.

IND = 1 The problem has no solution.

```text
IND = 2 MXITER iterations were performed. More iterations are needed.
IND = 3 Sufficient accuracy cannot be maintained to solve the problem.
IND = 4 The problem has an unbounded solution.
```

IND = 5 An input error was detected. (See below)

IND =: 6 A possible solution was obtained. The routine is not certain if the solution is correct.

X is an array of dimension n + NUMLE -++ NUMGE and z is a variable. If IND = 0 or IND = 6, then z has for its value the maximum value obtained for D,c;z,; and X contains the values obtained for the original, slack, and surplus variables. If IND #4 5 then IBASIS contains the indices of the basic variables currently in effect when the routine terminates.

BI is an array of dimension m? that is used for storing the inverse of the basis matrix. The order of the column vectors of the basis matrix corresponds to the order of the basic variables given in IBASIS. If IND #4 3,5 on output then BI contains the inverse of the basis matrix currently in effect when the routine terminates.

WK is an array of dimension 2m: or larger, and [WK is an array of dimension 2m +n or larger. WK and IWK are work spaces,

**Input Errors.** IND 5 occurs on output when one of the following conditions is violated:

(1) n > 2 and ka om > 2.

2) NUMLE + NUMOIB ©) pre.

3) Bach 6, > 0.

4) ‘The basis matrix specified by the user in EBASIS (when IND 1 on input) is nonsingular and sufficiently well conditioned so that its inverse can be computed.

( ( (

**Remarks.** (EH) ASA CPA WPA PPA are not modified by the routines (2) ‘The routines maximize Soeja,0 Phos function can be minimized by maximizing (0 e,)0,

and then change the sign of the result

alt


<small>Original source: [View scanned PDF page 313](../scans/page_0313.png)</small>

(3) SMPLX and SSPLX generate the same results. For efficiency, SSPLX should be used

when A is sparse.

Algorithm. A three step procedure is used. The first step eliminates the negative variables. Then phases (1) and (2) of the primal simplex algorithm are invoked. Negative variables are eliminated as follows: Let 751, ...,2Bm be the basic variables and y,,; the components of the simplex tableau.

(1)

(2)

Compute d; = U{y,; for each nonbasic variable x; where the sum Zi is for ali ts wh ve rp, < 0. If ail d; > 0 then the problem has no feasible solution. Otherwise, select k so that d, = min,d;. Then x, is the variable to be made basic.

If tg; > 0 and y,, > O for some 7 then go to (3). Otherwise, select a negative variable <p, to become nonbasic where zp,/yrx = max{zp;/yj~ 2B; < Oand y;_ < O}. Then update the basis and go to (5).

Compute € = minizg,/¥j% : TB; > O and y,,4 > O} and check if a negative variable rp; exists that satisfies the conditions:

(«) yye <O and « > rp;/y;n

If such a variable exists then go to (4). Otherwise, select a nonnegative variable zg, to become nonbasic where y,, > 0 and rp,/y,-~% = €. Then update the basis and go to (1). Select a negative variable 23, to become nonbasic where tp,/yrx = max{zp;/Yjk : Zp; < Cand zp; satisfies(*)}. Then update the basis and go to (5).

Check if there are any remaining negative variables. If not, then we are finished. Otherwise go to {1).

**Programming.** SMPLX and SSPLX employ the subroutines SMPLX1, SSPLX1, and CROUTI. These routines were written by A. H. Morris. The function SPMPAR is also used,


<small>Original source: [View scanned PDF page 314](../scans/page_0314.png)</small>

<a id="topic-314-01"></a>
### The Assignment Problem

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [`L77169`](../source_parts/nswc_part_08.f90#L3023) |


Let C = (¢,;) be ann x n matrix (the cost matrix). The problem under consideration

n Lay is to find an n x n matrix x = (z,,) which minimizes T = 3> Y° c,,z,, and satisfies: s=1 y--1

(1) So xy, 5 bP for j-1,...,n tro]

(2) Soa, - fort -1,...,n

g=l 3) Each x,,~ Our 1 3

Bach x which satisfies (1)-(3) is called an assignment. For each such z, from (1) and (3) we note that for each 7 there exists a unique integer x(j)} such that Ix(3},7 = 1. Also, (2) and (3) assert that ~ is a permutation of {1,...,n}. Conversely, for any permutation 7

there corresponds an assignment. z defined by Tx ( 1 and z,, = O fors # w(y). Thus,

9).2 n the problem is to find a permutation » of {1,...,n} which minimizes T —~ 3° Cx(y),7- The gol following subroutine is available for solving this problem when all Cy, are integers.

```fortran
CALL ASSGN(N, A, C, T, IWK, IERR)
```

C is a 2-dimensional integer array of dimension n x (n + 1), JC an integer array of dimension n, and 7 an integer variable. It is assumed that n > 2 and that the first. n columns of © contain the cost matrix (c,,). [The (nm + 1)" column of C is a work space for

When ASSGN ts called, the desired permutation 7 is obtained and the values

the routine. a(1),..., a(n) stored in JC Also Tis assigned the minimized value LCs),

IWK is an array of dimension 7n + 2 or larger that is a work space for the routine.

IRR ows a variable that is set by the routine. If JC and 7 are obtained then IERR is assigned the value OQ) Otherwise, if the problem cannot be solved because of integer overflow,

then IERR I.

```text
Remarks.
(1) Cois destroyed by the coutine
(2) ASSGN tmuintimizes 7 Pag) Phis function can be maximized by minimizing
```

MC eye, ,) and then changing the sign of the result Programming ASSGN calls the subroutine ASSGNE ASSGNI was written by Giorgia Carpaneto and Paolo Toth (University of Bologna, Italy), and modified by AH. Morris The function EPMPAR is also used Reference ( Carpanero. (0 and Toth. be, “Algorithm S48.) Solution of the Assignment

Probie.” ACA Trans Aath Software ti (U8) pp lod TLE

tle


<small>Original source: [View scanned PDF page 315](../scans/page_0315.png)</small>

<a id="topic-315-01"></a>
### 0-1 Knapsack Problem

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [`L77434`](../source_parts/nswc_part_08.f90#L3288) |


Given n > 2 items, each having a profit p; > 0 and weight w; > 0, and m > 1 containers (knapsacks), each having a capacity k, > 0. Let z,; = 1 if item 7 is assigned to knapsack 1. Otherwise, let z;; == 0. Then the problem is to find an assignment z,; of the

m on items to the knapsacks which maximizes 0 = )> 5) p,2,; subject to s=ls=1

(1) SO wyay; < ke for f= 1,...,m, and

m (2) 33 a5 <1 for g=1,...,n.

Condition (2} states that each item may be assigned to a (single) knapsack or be rejected. It can be assumed, without loss of generality, that

(a) the knapsacks are ordered so that ky <+++ < km,

(b) min{ wy,..., wy } < ki,

(c) max{wy,...,Wn} < km, and

(d) do yh. wy > kn.

Then the following subroutine is available for solving this problem when all p,;, w,, and k, are positive integers.

```fortran
CALL MKP(N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM)
```

P and W are integer arrays containing pi,...,Pn and w,,...,w,, and K an integer array containing ky,...,k,. £ is an integer array of dimension n or larger, and o an integer variable. When MKP is called, if no input errors are detected then the maximum value for o is obtained. Also, L(j) = 1 if item 7 has been assigned to knapsack ¢ (7 = 1,...,n)}, and L(j) = 0 if item 7 does not appear in the solution (i.e., if 2; = +++ = an; = 9).

A depth-first tree search employing backtracking is used. if no bound is placed on the number of back tracks that may be performed, then the exact maximum a 3s assured. However, if the number of back tracks must be restricted, then only an approximation to the maximum may be obtained. The argument NBCK is available for limiting the backtracking. NBCK is a variable. On input, if NBCK = -1 then no restrictions are placed on the backtracking. Otherwise, if NBCK # ~—1, then it is assumed that NBCK is the maximum number of back tracks that are permitted. When the routine terminates, NBCK <= the number of back tracks that were actually performed.

TEMP 1s a real array of dimension n or larger, and I'TEMP an integer array of dimension NUM. It is assumed that NUM > 5m 4 14n-+4mn-+ 3. TEMP and ITEMP are work spaces for the routine. It should be noted that TEMP is the only argument of MKP that is not of integer type.

**Error return.** If an input error is detected then @ 148 set to one of the following values:

od -Lifrn es Lorn < 2.


<small>Original source: [View scanned PDF page 316](../scans/page_0316.png)</small>

o = ~—2 if some p;,w,, or k; is not, positive.

o = —8 if min{wy,...,wa} > ki; ie. if a knapsack cannot contain any item.

go —4 if max{wi, ..., Wp} > km; Le., if an item cannot fit in any knapsack.

o=—5 if Djw,; < kn; ie., if knapsack m can contain all the items.

o = ~7 if the knapsacks are not ordered so that ky <--- < ky.

o0 = -8 if NUM < 5m+ l4n+ 4mn4 3.

Backtracking. For NBCK = —1, the time required for finding the exact maximum depends primarily on the value of m, and can increase quite dramatically for very small increases in the value of m. It is recommended that this setting never be used when m > 10. Instead, if m > 10 then a setting of NBCK < 50 frequently suffices.

**Programming.** MKP employs the subroutines MKP1, S(GMA1, PI1, PARC, SKNP, and SKNP1. The interface subroutine MKP was written by A.H. Morris. The remaining subroutines were written by Silvano Martello (University of Bologna) and Paolo Toth (University of Florence) and modified by A.H. Morris. The subroutine RISORT is also used.

**Reference.** Martello, S. and Toth, P.,“Algorithm 632. A Program for the 0-1 Multiple Knapsack Problem,” ACM Trans. Math Software 11 (1985), pp. 135-140.

