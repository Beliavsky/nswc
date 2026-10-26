[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-193"></a>
## Large Dense Systems of Linear Equations

<small>Original source: [View scanned PDF page 193](../scans/page_0193.png)</small>

<a id="topic-193-01"></a>
### Solving Systems Of 200-400 Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [`L49675`](../source_parts/nswc_part_05.f90#L7428) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [`L49844`](../source_parts/nswc_part_05.f90#L7597) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [`L50013`](../source_parts/nswc_part_05.f90#L7766) |


For n > 1, let A denote ann x n matrix and 6 a column vector of dimension n. Then the subroutines LE, DPLE, and CLE are available for solving the equations Az = 6 where A is not stored in-core. For large n, these routines require a work space of dimension x n?7/4. This permits the solution of systems of equations of double the order permitted by the standard solution procedures.

```fortran
CALL LE(ROWK, N, B, C, D, IP, IERR)
CALL DPLE(ROWK, N, B, C, D, IP, IERR)
CALL CLE(ROWK, N, B, C, D, IP, IERR)
```

X is an array of dimension n and [ERR an integer variable. When the equations are solved, then IERR is set to 0 and the solution is stored in X.

ROWK ie the na-ie of a user defined subroutine that has the format: CALL ROWK(n,k, R) R is an array of dimension n and k = t,...,n. When ROWK is called, the k** row of the matrix A is stored in R. ROWK must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension [n?/4] +n +3 or larger,’ and iWK is an integer array of dimension max{1,n -- 1} or larger. WK and IWK are work spaces for the routines.

**Error Return.** IERR = k when the first k rows of A are found to be linearly dependent.

**Remarks.**

(i) When LE is called then it is assumed that 6, X, WK and the array R in ROWK are real arrays. When DPLE is called then it is assumed that these arrays are double precision arrays, and when CLE is called then it is assumed that the arrays are complex.

(2) When the equations are solved, ROWK is called to attach the first row of A, then the second row, etc. Each row of A is attached only once.

(3) The array 6 is not modified by the routines.

**Algorithm.** The partial pivot Henderson-Wassyng procedure is used.

**Programming.** LE, DPLE, and CLE are modified versions by A. Hl. Morris of the subroutine TE, written by A. Wassyng (University of the Witwatersrand, Johannesburg, South: Africa).

**Example.** Consider a system of n = 300 real linear equations b where the rows of A are stored, one row per logical record, in sequence in an unformatted file (say file 4). Then the following code can be used to solve the equations:

Mere [n?/4] denotes the largest integer < 7.7/4,

ee Press)


<small>Original source: [View scanned PDF page 194](../scans/page_0194.png)</small>

REAL B(300),X(300), WK (22803) INTEGER IWK(300) EXTERNAL GETROW

DATA N/300/

REWIND 4 CALL LE(GETROW,N,B,X,WK,IWK,IERR)

Here GETROW may be defined by:

SUBROUTINE GETROW(N,1R) REAL R(N)

READ(4) (R(J),J=i,N) RETURN

END

**Reference.** Wassyng, A., “Solving Az = 6: A Method with Reduced Storage Requirements,” SIAM J. Numerical Analysts 19 (1982), pp. 197-204.

