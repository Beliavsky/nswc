[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-410"></a>
## Integral Equations

<small>Original source: [View scanned PDF page 410](../scans/page_0410.png)</small>

<a id="topic-410-01"></a>
### Solution of Fredholm Integral Equations of the Second Kind

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [`L106991`](../source_parts/nswc_part_11.f90#L1200) |


If k(s,t) and f(s) are continuous real-valued functions for a < s < 6 and a <t< 6, then the equation to be solved is

z(s) — / k(s,t)a(t} dt = f(s)

fora < s <b. Let K be the operator defined by (Kz)(s) = f k(s,t)z(t) dt for any real-valued function z continuous on [a,b]. Then (Az)(s) is continuous for « < s < b, and k is called the kernel of K. Also the above integral equation can be written in the form (I ~ K)z = f where I is the identity operator. This equation has a unique solution if and only if J — K is 1 — 1, in which case z = (I~ K)~!f. The subroutine IESLV is available for computing this solution.

**Remark.** If Ca, }| is the normed space of real-valued functions z continuous on [a, b| and having the norm |/z|| = maxr{ |z(t)| : @ < t < 6}, then K is a compact mapping

C{a, 6] —+ Cla, 6] having the norm ||K|j - maz, f |k(s,t)| dt.

```fortran
CALL IESLV(KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER)
```

It is assumed that a < 6, and that k(s,¢) and f(s) are user defined real-valued functions fora < 3,t <6. It is recommended that k and f be several times continuously differentiable. The functions k and f must be declared in the calling program to be of type EXTERNAL.

EPS is a variable and JFLAG an input argument whose values are 0 and 1. Ou Input EPS as the error tolerance that the solution must satisfy. If IFLAG QO then MPS is an absolute tolerance. Otherwise, if IFLAG ~ 1 then BPS is a relative tolerance. If HESLV solves the equation, then on output EPS is the estimated error of the result,

Before the remaining arguments s,v,f, 00. can be described, it is necessary to pave a brief outline of the algorithm used) When HeSLV is called, the integral equation ts

approximated by (+) rls) Sou kl ta draltad) fs) }

foras a+ 6 Here w,, and ¢,,, are the weights and nodes of Gauss-Legendre quadrature This equation ix treated as an interpolation for r(s) in terms of the values Paltaa). These

Values are obtained by solving: the equations

‘

wid (aa lindt (ta) flty,) i

(+6) ria(ty,)


<small>Original source: [View scanned PDF page 411](../scans/page_0411.png)</small>

fort = 1,...,n. This system of equations can be solved directly or iteratively. The following

algorithm is used:

(1) Set n = 2 and go to (2).

(2) The n equations are solved directly. Then set m == 2n and solve the m equations (+**} iteratively. Jf the rate of convergence is sufficiently rapid or n cannot be increased, then go to (3). Otherwise, set n = m, and go to (2).

(3) Here n remains fixed. Repeatedly double the value of m and solve the m equations (+**) iteratively until convergence occurs, m cannot be increased, or the iterations diverge.

When the algorithm terminates, values 2,(tim) will have been computed for the nodes tim(# = 1, ...,m). Then from (*}, 2(8) & 2m(s) can be interpolated for a < a < 6.

N and M are input arguments, and WK is an array that is a work space for the routine. N and M are upper limits for n and m in the algorithm, and WK is of dimension 5N? + 9(N + M) or larger. It is assumed that M > N > 2. Since n and m are always powers of 2, N and M need only be set to powers of 2. However, this is not required.

S and X are arrays, and £is a variable. On input it is assumed that @ > 0. If 2 > 0 then S is assumed to contain @ points 9), ...,8¢ at which the solution z(s) is to be evaluated. Also X is assumed to be an array of dimension @ or larger. When IESLV terminates, X contains the values obtained for r(s;), ...,2(s¢). (This is true irregardless of whether or not the desired accuracy has been achieved.) Otherwise, if @ = 0 then S and X are assumed to be arrays of dimension M or larger. When 1ESLV terminates @ = the final value obtained for m, S contains the Gaussian nodes t,,(t = 1, ...,@), and X contains the values obtained for x(t,).

NF and MF are variables. When the routine terminates, NF is the final value for n and MF the final value for mi.

NORMK 3s a real variable. If 2 > 0 on input, then when IESLV terminates, NORMK is an approximation for ||Aj|. Otherwise, if 2= 0 then NORMK = 0.

IERR is a variable that reports the status of the results. When the routine terminates, IERE. has one of the following values:

IERR = 0 The solution was obtained to the desired accuracy. EPS is the estimated error of the result.

IERR <1 The solution was not obtained to the desired accuracy. EPS is the estimated error of the result.

JERR =< 2 The solution was not obtained to the desired accuracy. It is not clear what accuracy (if any) has been achieved. EPS has been set to 0.

IERR =: 3 The input value for EPS was too small. This may be due to illcondit‘oning of the integral equation. The value of EPS was reset to a more realistic tolerance, which the solution satisfied.

JERR. 4 The solution 2(s) was obtained at the Gaussian nodes to the desired precision, However, the interpolation process may not preserve this accuracy for the evaluation of x(a) for other points s.

EPS is the estimated error of the solution at the Gaussian nodes.

PAG


<small>Original source: [View scanned PDF page 412](../scans/page_0412.png)</small>

JERR = 5 The solution z{s) was not obtained to the desired accuracy at the Gaussian nodes. EPS is the estimated error at these nodes. The interpolation process may not preserve this accuracy for the evaluation of 2(8) for other points s.

[ERR = 6 The input value for EPS was too small. This may be due to ill-conditioning of the integral equation. 'The value of EPS was reset to a more realistic tolerance, which the solution x(a) satisfied at the Gaussian nodes. The interpolation process may not preserve this accuracy for the evaluation of x(a) for other points s.

Difficulties can arise, causing IERR > 1, when the integral equation is ill-conditioned or the kernel &(¢,t) is not appropriate for standard Gaussian quadrature. Ill-conditioning can occur when the operator J - K is near singular or the norm ||K'|| is exceedingly large. Inappropriate kernels k(s,t) include those which are highly oscillatory or not continuously differentiable for s and t in the open interval (a, b).

**Programming.** IESLV employs the subroutines LEGS, NSTERP, WANDT,LEAVE, ITERT, LNSYS and functions RMIN,RNRM,CONEW. The routines save and exchange information in labeled common blocks. The block names are XXINFO and XXLIN. The routines were written by Kendall E. Atkinson (University of Iowa), and modified by A. H. Morris. The function SPMPAR is also used.

**Reference.** Atkinson, K. E.,“Ar Automatic Program for Linear Fredholm Integral Equations of the Second Kind,” ACM Trans. Math Software 2 (1976), pp. 154-171.

HAT

