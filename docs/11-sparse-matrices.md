[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-225"></a>
## Sparse Matrices

<small>Original source: [View scanned PDF page 225](../scans/page_0225.png)</small>

<a id="topic-225-01"></a>
### Storage Of Sparse Matrices


A matrix is said to be sparse if it contains sufficiently many zero elements for it to be worthwhile to use special techniques that avoid storing and operating with the zeros. The scheme adopted for storing a sparse m X n matrix (a;;) requires three 1-dimensional arrays A, IA, JA. The array A contains the nonzero elements of the matrix, stored row by row. The array JA contains the column numbers of the corresponding elements of the A array; ie., if A(k) contains (a,;) then JA(k) = 7. The elements of a row of the matrix may be given in any order in A.

7A is an array containing m+ 1 integers which specify where the rows of the matrix are stored in A. For! < m, I A(t) is the index of the location in A where the 1** row information begins. It is assumed that the rows are stored sequentially; ie., that TA(1) <-+-< [A(m). IA(m+1) is set so that [A(m+1)—JA(1) = the number of elements stored in A. For 1 < m, if [A(t) < TA(t+ 1) then A(é) is the first entry of the :** row of the matrix in A where £ == [A(t). Otherwise, if JA(t) == JA(¢+ 1) then no entries for the :** row of the matrix are stored in A. This can occur only if the 1*" row of the matrix consists entirely of zeros. If this occurs then the t¢* row is called a nuél row of A. For any ¢ < m, JA(i +1) — IA(t) is the number of entries for the :** row of the matrix that are stored in A. For convenience, TA(s + 1) — IA(t) is called the length of the 1** row.

**Example.** The matrix

ay Gye 0 0 0 0 0 aia 0 0 0 0O OQ O O 0 0 0 0 0 0 0 Qa37 a38

can be stored as follows:

A: [aii [aie [aia [ 437 | ase | 243 |

The storage of the elements aj, @,2 ayg in the order a); a1g @)2 is permissible. The elements of a row of the matrix may be given in any order desired.

**Remark.** it is not required that each a,, in A be nonzero.


<small>Original source: [View scanned PDF page 226](../scans/page_0226.png)</small>

<a id="topic-226-01"></a>
### Conversion Of Sparse Matrices To And From The Standard Format

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [`L49073`](../source_parts/nswc_part_05.f90#L6912) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [`L49102`](../source_parts/nswc_part_05.f90#L6941) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [`L49131`](../source_parts/nswc_part_05.f90#L6970) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [`L49161`](../source_parts/nswc_part_05.f90#L7000) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [`L49185`](../source_parts/nswc_part_05.f90#L7024) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [`L49209`](../source_parts/nswc_part_05.f90#L7048) |


The following subroutines permit one to convert sparse matrices to and from the standard format.

```fortran
CALL CVRS(A, KA, M, N, B, IB, JB, NUM, IERR)
CALL CVDS(A, KA, M, N, B, IB, JB, NUM, IERR)
CALL CVCS(A, KA, M, N, B, IB, JB, NUM, IERR)
```

Ais an m X n matrix stored in the standard format. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that A is to be stored in sparse form in the arrays 3, 1B, JB. CVRS is used if A is a real matrix and B a real array, CVDS is used if 4 is a double precision matrix and B a double precision array, and CVCS is used if A is a complex matrix and B a complex array.

The input argument NUM is the estimated maximum number of elements that will appear in B and JB. It is assumed that B and JB are of dimension max{i, NUM} and that JB is of dimension m+ 1. IERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for B and JB, then A is stored in B, JB, JB and IERR is assigned the value 0.

**Error Return.** If it is found that there is not sufficient storage in B and JB for the i** row of A, then IERR is set tos and the routine terminates. In this case, ifs > 1 then the first t — 1 rows of A will have been stored in B and JB, and J B(1),...,7.B(i) will contain the appropriate row locations.

**Remark.** No zero elements of A are stored in B, and the elements of each row of B are ordered so that the column indices of the elements of the row are in ascending order.

**Example.** If A is the m x n zero matrix then NUM can be set to 0. In this case the result

**Note.** It is assumed that the storage areas A and HB do not overlap. Programmer. A. H. Morris.

```fortran
CALL CVSR(A, IA, JA, B, KB, M, N)
CALL CVSD(A, IA, JA, B, KB, M, N)
CALL CVSC(A, IA, JA, B, KB, M, N)
```

Ais an m Xm sparse matrix stored in the arrays A, (A, JA, and Bis a 2-dimensional array of dimension kb x m where kb > m. CVSR is used if A and J3 are real arrays, CVS) is used Wf A and JU are double precision arrays, and CVSC is used if A and # are complex arrays. When the routine is called, the matrix A is stored in the array # in the standard

format.


<small>Original source: [View scanned PDF page 227](../scans/page_0227.png)</small>

**Note.** It is assumed that the storage areas A and B do not overlap.

Programmer, A. H. Morris.


<small>Original source: [View scanned PDF page 228](../scans/page_0228.png)</small>

<a id="topic-228-01"></a>
### Conversion Of Sparse Real Matrices To And From Double Precision Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49233`](../source_parts/nswc_part_05.f90#L7072) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49259`](../source_parts/nswc_part_05.f90#L7098) |


The following subroutines are available for converting sparse real matrices to and from double precision form.

```fortran
CALL SCVRD(A, IA, JA, B, IB, JB, M)
```

A is a sparse real matrix stored in the arrays A, JA, JA. A is a real array and Ba double precision array. If A and JA contain k elements then it is assumed that B and JB are arrays of dimension k. It is also assumed that the matrix A has m > 1 rows and that IB is an array of dimension m+ 1. SCVRD stores the matrix A in double precision form in B, IB, JB.

**Remarks.**

```text
(1) No zero elements of A are stored in B.
(2) It is assumed that the arrays JA, JA and IB, JB reference different storage areas.
```

**Programmer.** A. H. Morris.

```fortran
CALL SCVDR(A, IA, JA, B, IB, JB, M)
```

A is a sparse double precision matrix stored in the arrays A, TA, iA. A is a double precision array and B a real array. If A and JA contain k elements then it is assumed that Band JB are arrays of dimension k. it is also assumed that the matrix A has m > | rows and that /8 is an array of dimension m+1. SCVDR stores the matrix A in single precision

form in 8, IB, JB.

```text
Remarks.
(1) No zero elements of A are stored in B.
(2) It is assumed that the arrays 7A, JA and IB, JB reference different storage areas.
```

**Programmer.** A. H. Morris,


<small>Original source: [View scanned PDF page 229](../scans/page_0229.png)</small>

<a id="topic-229-01"></a>
### The Real And Imaginary Parts Of A Sparse Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49285`](../source_parts/nswc_part_05.f90#L7124) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49316`](../source_parts/nswc_part_05.f90#L7155) |


If A = (a,;) is a complex matrix then let Re(A) = (Re({a,,;)) and Im(A) = (Im(a;;)) denote the real and imaginary parts of A. If the matrix A is stored in sparse form, then the following subroutines are available for obtaining Re(A) and Im(A) in sparse form.

```fortran
CALL CSREAL(A, IA, JA, B, IB, JB, M)
```

A is a sparse complex matrix stored in the arrays A, JA, JA. A is a complex array and B a real array. If A and JA contain k elements then it is assumed that Band JB are arrays of dimension k. It is also assumed that the matrix A has m > 1 rows and that 1B is an array of dimension m+ 1. CSREAL stores Re(A) in sparse form in B, IB, JB.

**Remarks.**

```text
(1) No zero eiements of Re(A) are stored in B.
(2) It is assumed that the arrays JA, JA and IB, JB reference different storage areas.
```

**Programmer.** A. H. Morris.

```fortran
CALL CSIMAG(A, IA, JA, B, IB, JB, M)
```

A is a sparse complex matrix stored in the arrays A, IA, JA. A is a complex array and B areal array. If A and JA contain k elements then it is assumed that B and JB are arrays of dimension k. It is also assumed that the matrix A has m > | rows and that 1B is an array of dimension m + 1. CSIMAG stores Im(A) in sparse form in B, 1B, JB.

```text
Remarks.
(1) No zere elements of Im(A) are stored in 3.
(2) It is assumed that the arrays (A, JA and 1/8, JB reference different storage areas.
```

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 230](../scans/page_0230.png)</small>

<a id="topic-230-01"></a>
### Computing A + Bi For Sparse Real Matrices A And B

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L49347`](../source_parts/nswc_part_05.f90#L7186) |


Given the real m x n matrices A and B stored in sparse form. Then the subroutine SCVRC is available for obtaining the complex matrix A+ Bit where t = /—1.

```fortran
CALL SCVRC(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
```

A and B are real m X n matrices stored in the arrays A,JA,JA and B,IB,JB. it is assumed that A+ Bs is to be stored in sparse form in the arrays C,JC,JC. A and B are real arrays and C a complex array. NUM is the estimated maximum number of elements that will appear in C and JC. It is assumed that C and JC are arrays of dimension max{1, NUM} and that JC is an array of dimension m + 1.

WK is a real array of dimension n or larger that is a work space for the routine.

TERR is an integer variable. When SCVRC is called, if NUM specifies sufficient storage for C and JC then A+ Bt is stored in C, IC, JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C and JC for the kt* sow of A+ Bi, then IERR is set to k and the routine terminates. In this case, if k > 1 then the first k — 1 rows of A + Bt will have been stored in C' and JC. Also IC(1),...,IC(k) will contain the appropriate row locations.

**Remark.** No zeros are stored in C.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 231](../scans/page_0231.png)</small>

<a id="topic-231-01"></a>
### Copying Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49410`](../source_parts/nswc_part_05.f90#L7249) |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49439`](../source_parts/nswc_part_05.f90#L7278) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49468`](../source_parts/nswc_part_05.f90#L7307) |


The following su routines are available for copying sparse matrices.

```fortran
CALL RSCOPY(A, IA, JA, B, IB, JB, M)
CALL DSCOPY(A, IA, JA, B, IB, JB, M)
CALL CSCOPY(A, IA, JA, B, IB, JB, M)
```

RSCOPY is used if A and B are real arrays, DSCOPY is used if A and B are double precision arrays, and CSCOPY is used if A and B are complex arrays.

A is a sparse matrix stored in the arrays A, [A,J A. If A and JA contain k elements then it is assumed that B and JB are arrays of dimension k. It is also assumed that the matrix A has m > 1 rows and that /B is an array of dimension m+ 1. The routine copies the matrix A and stores the copy in B,JB,JB.

**Remarks.**

```text
(1) No zero elements of A are stored in B.
(2) It is assumed that the arrays A, iA, JA and B, /B,JB reference different storage
areas.
```

**Programmer.** A. H. Morris.

OOS


<small>Original source: [View scanned PDF page 232](../scans/page_0232.png)</small>

<a id="topic-232-01"></a>
### Computing Conjugates Of Sparse Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L49498`](../source_parts/nswc_part_05.f90#L7337) |


```text
If A = (a,;) is a complex matrix stored in sparse form, ther the following subroutine
is available for computing the conjugate matrix A = (4,;).
```

```fortran
CALL SCONJ(A, IA, JA, B, IB, JB, M)
```

It is assumed that the sparse complex matrix A is stored in the arrays A, JA, JA. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k. A and B are complex arrays. It is assumed that the matrix A has m > 1 rows and that TB is an array of dimension m+ 1. When the routine is called, the conjugate matrix A is stored in B, 1B, JB.

**Remark.** The user may let B = A, /B = JA, and JB = JA when 1] A(1) = 1.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 233](../scans/page_0233.png)</small>

<a id="topic-233-01"></a>
### Transposing Sparse Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [`L49525`](../source_parts/nswc_part_05.f90#L7364) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [`L49581`](../source_parts/nswc_part_05.f90#L7420) |


The subroutines RPOSE and RPOSE! are available for transposing a sparse m x n real matrix A. RPOSE1 is more general than RPOSE. For any permutation 7 = {11, ...,1m} of {1,...,m} let P denote the corresponding ™ x m permutation matrix. Then RPOSE1 computes the matrix (P.A)’.

```fortran
CALL RPOSE(A, IA, JA, B, IB, JB, M, N)
```

It is assumed that the sparse matrix A is stored in the arrays A, JA, JA. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that 7B is an array of dimension n+ 1. When RPOSE is called, the transpose A’ is stored in B, IB, JB.

Remarks. RPOSE orders the elements of each row of .4° so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. if zero elements appear in the array A, then the zero elements will also appear in F.

Restriction. '¢ is assumed that the storage areas B, 1B, JB do not overlap with the storage areas A, ITA, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, F. G., “i'wo Fast Algorithms for Sparse Matrices: Mi. ‘tiplicatior. and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 250-269.

```fortran
CALL RPOSE1(P, A, IA, JA, B, IB, JB, M, N)
```

It is assumed that x is an integer array of dimension m containing the data (41, .-.,1m}; and that the sparse matrix A is stored in the arrays A, 1A, JA. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that 7B is an array of d‘mension n+ 1. When RPOSE1 is called, (PA)* is computed and the results are stored in B, 7B, JB.

**Remarks.** RPOSE! orders the elements of each row of (PA)! so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. Tf zero elements appear in the array A, then the zero elements will also

appear in 2.

Restriction. It is assumed that the storage areas 2, 1B, JB do not overlap with the storage areas A, JA, JA.

**Programmer.** A. if. Morris.

**Reference.** Gustavson, Fo G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 20) 269,

3OG


<small>Original source: [View scanned PDF page 234](../scans/page_0234.png)</small>

<a id="topic-234-01"></a>
### Transposing Sparse Double Precision Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [`L49640`](../source_parts/nswc_part_05.f90#L7479) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [`L49696`](../source_parts/nswc_part_05.f90#L7535) |


The subroutines DPOSE and DPOSE1 are available for transposing a sparse m x n double precision matrix A. DPOSE1 is more general than DPOSE. For any permutation mw = {81,...,tm} of {1, ...,m} let P denote the corresponding m x m permutation matrix. Then DPOSE1 computes the matrix (PA)‘.

```fortran
CALL DPOSE(A, IA, JA, B, IB, JB, M, N)
```

It is assumed that the sparse matrix A is stored in the arrays A, JA, JA. A and B are double precision arrays. If A and 7A contain k elements, then it is also assumed that B and JB are arrays of dimension /: and that 48 is an array of dimension n +1. When DPOSE is called, the transpose A® is stored |. B, IB, JB.

Remarks UPOST orders the elements of each row of A‘ so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. If zero elements appear in the array A, then the zero elements will also appear in B.

Restriction. Ji is assumed that the storage areas B, 1B, JB do not overlap with the storage areas A, JA, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, F. G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 250-269.

```fortran
CALL DFOSE1{x, A, fA, JA, B,1B,J3,m,n)
```

It is assumed that m ig an integer array of dimension m containing the data {11, ...,4m}, and that the sparse matrix A is stored in the arrays A, /A, JA. A and B are double precision arrays. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that /B is an array of dimension n +-1. When DPOSE1 is called, (PA)* is computed and the results are stored in B, 7B, JB.

Remarks, DPOSE1 orders the elements of each row of (7?A)! so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. if zero elements appear in the array A, then the zero elements will also

appear in J.

Restriction. It is assumed that the storage areas B, 7B, JB ao not overlap with the storage areas A, JA, JA.

**Programmer.** A. Hl. Morris.

**Reference.** Gustavson, Ff. G., “Two Fast) Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 261) 269


<small>Original source: [View scanned PDF page 235](../scans/page_0235.png)</small>

<a id="topic-235-01"></a>
### Transposing Sparse Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [`L49755`](../source_parts/nswc_part_05.f90#L7594) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [`L49811`](../source_parts/nswc_part_05.f90#L7650) |


The subroutines CPOSE and CPOSE] are available for transposing a sparse m x n complex matrix A. CPOSE1 is more general than CPOSE. For any permutation m = {$1,...,tm} of {1,...,m} let P denote the corresponding m x m permutation matrix. Then CPOSE1 computes the matrix (P.A)'.

```fortran
CALL CPOSE(A, IA, JA, B, IB, JB, M, N)
```

it is assumed that the sparse matrix A is stored in the arrays A, [A, JA. A and B are complex arrays. If A and JA contain k elements, then it is also assumed thai B and JB are arrays of dimension k and that 7B is an array of dimension n+ l. When CPOSE is called, the transpose A‘ is stored in B, /B, JB.

**Remarks.** CPOSE orders the elements of each row of A‘ so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. If zero elements appear in the array A, then the zero elements will also appear in B.

Restriction. It is assumed that the storage areas B, 1B, JB do not overlap with the storage areas A, IA, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, F. G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 250-269.

```fortran
CALL CPOSE1(P, A, IA, JA, B, IB, JB, M, N)
```

It is assumed that 7 is an integer array of dimension m containing the data {#;, ...,1m}, and that the sparse matrix A is stored in the arrays A, [A, JA. A and B are complex arrays. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that JB is an array of dimension n+ 1. When CPOSE1 is called, (PA)* 13 computed and the results are stored in #8, 1B, JB.

Remarks, CPOSE1 orders the elements of each row of (PA)! so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. [f zero elements appear in the array A, then the zero elements will also

appear in 7.

Restriction. It is assumed that the storage areas B, 1, J 28 do not overlap: with the storage areas A, 1A, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, Po G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” 4CM Trans. Math. Software d (1978), pp. 250. 269.


<small>Original source: [View scanned PDF page 236](../scans/page_0236.png)</small>

<a id="topic-236-01"></a>
### Addition of Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L49870`](../source_parts/nswc_part_05.f90#L7709) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L49932`](../source_parts/nswc_part_05.f90#L7771) |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L49994`](../source_parts/nswc_part_05.f90#L7833) |


The following subroutines are available for adding sparse matrices.

```fortran
CALL SADD(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL DSADD(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL CSADD(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
```

A and 8 are sparse m x n matrices stored in the arrays A,JA,JA and B,J B,JB. ‘4 is assumed that A -- B is to be stored in sparse form in the arrays C,IC,JC. NUM ‘s tie estimated maximum number of elements that will appear in C and JC. It is assumed that. C and JC are arrays of dimension max{i, NUM} and that JC is an array of dimension mot 1,

SADD is used if A,B,C, and WK are real arrays, DSADD is used if A,B,C, and WK are double precision arrays, and CSADD is used if A,B,C, and WK are complex arrays.

WK is an array of dimension n or larger that is a work space for the routine.

IERR is an integer variable. When the routine is called, if NUM specifies sufficient, storage for C and JC then A+ B is computed and stored in C,\JC,JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C and JC for the s** row of A+ B, then IERR is set to 1 and the routine terminates. In this case, if? > 1 then the first 1 — 1 rows of A+ B will have been computed and stored in C and JC. Also [C(1),...,/C(¢) will contain the appropriate row locations.

**Remarks.**

```text
(1) No zeros are stored in C.
(2) It is assumed that C,/C,JC reference different storage areas than A,/JA,JA and
B,IB,JB.
```

**Programmer.** A. H. Morris.

31h


<small>Original source: [View scanned PDF page 237](../scans/page_0237.png)</small>

<a id="topic-237-01"></a>
### Subtraction of Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L50056`](../source_parts/nswc_part_05.f90#L7895) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L50118`](../source_parts/nswc_part_05.f90#L7957) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L50180`](../source_parts/nswc_part_05.f90#L8019) |


The following subroutines are available for subtracting sparse matrices,

```fortran
CALL SSUBT(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL DSSUBT(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL CSSUBT(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
```

A and B are sparse m x n matrices stored in the arrays A,JA,JA and B,IB,JB. It is assumed that A -- B is to be stored in sparse form in the arrays C',JC,JC. NUM is the estimated maximum number of elements that will appear in C and JC. lt is assumed that C and JC’ are arrays of dimension max{1, NUM} and that IC is an array of dimension m+,

SSUBT is used if A,B,C, and WK are real arrays, DSSUBT is used if A,B,C, and WK are double precision arrays, and CSSUBT is used if A,B,C, and WK are complex arrays.

WK is an array of dimension n or larger that is a work space for the routine.

TERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for C and JC then A -— 8 is computed and stored in CJC JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C ard JC for the t** row of A — B, then IERR is set tot and the routine terminates. In this case, iff > 1 then the first ¢— 1 rows of A— B will have been computed and stored in C and JC. Also IC(1), ...,C(¢) will contain the appropriate crow locations.

**Remarks.**

```text
(1) No zeros are stored in C’.
(2) lt is assumed that C,/C’,JC reference different storage areas than A,JA,JA and
BIB, JE.
```

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 238](../scans/page_0238.png)</small>

<a id="topic-238-01"></a>
### Multiplication Of Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [`L50242`](../source_parts/nswc_part_05.f90#L8081) |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [`L50297`](../source_parts/nswc_part_05.f90#L8136) |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [`L50352`](../source_parts/nswc_part_05.f90#L8191) |


The following subroutines are available for multiplying sparse matrices.

```fortran
CALL SPROD(A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR)
CALL DSPROD(A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR)
CALL CSPROD(A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR)
```

A is a sparse £ x m matrix stored in the arrays A,JA,JA, and B a sparse m xX n matrix stored in the arrays B,/B,JB. It is assumed that AB is to be stored in sparse form in the arrays C,/C,JC. NUM is the estimated maximum number of elements that will appear in C and JC. It is assumed that C and JC are arrays of dimension max{1, NUM} and that IC is an array of dimension @+ 1.

SPROD is used if A,B,C, and WK are real arrays, DSPROD is used if A,B,C, and WK are double precision arrays, and CSPROD is used if A,B,C, and WK are complex arrays.

WK is an array of dimension n or larger that is a work space for the routine.

IERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for C and JC then AB is computed and stored in C,IC,JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C and JC for the 1** row of AB, then IERR is set tos and the routine terminates. In this case, if 1 > 1 then the first - 1 rows of AB will have been computed and stored in C and JC. Also 1C(1), ..., JC(#) will contain the appropriate row locations.

**Remarks.**

```text
(1) No zeros are stored in C’.
(2) It is assumed that C,/JC,JC reference different storage areas than A,/JA,JA and
B,1B,JB.
```

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 239](../scans/page_0239.png)</small>

<a id="topic-239-01"></a>
### Product Of A Real Sparse Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50407`](../source_parts/nswc_part_05.f90#L8246) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50431`](../source_parts/nswc_part_05.f90#L8270) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50455`](../source_parts/nswc_part_05.f90#L8294) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50482`](../source_parts/nswc_part_05.f90#L8321) |


Let A be a real mx n sparse matrix stored in the arrays A,/A,JA. Then the following subroutines are available for multiplying A with a real vector.

```fortran
CALL MVPRD(M, N, A, IA, JA, X, Y)
```

The argument z is a column vector of dimension n and y an array of dimension m. When MVPRD is called, Az is computed and stored in y.

**Remark.** It is assumed that the arrays A,2,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL MVPRD1(M, N, A, IA, JA, X, Y)
```

The arguments x and y are column vectors of dimension n and m respectively. When MVPRDt1 is called, Az + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,x,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL MTPRD(M, N, A, IA, JA, X, Y)
```

The argument x is a row vector of dimension m and y an array of dimension n. When MTPRD is called, A is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL MTPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are row vectors of dimension m and n respectively. When MTPRD1 is called, 2A + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 240](../scans/page_0240.png)</small>

<a id="topic-240-01"></a>
### Product Of A Double Precision Sparse Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50506`](../source_parts/nswc_part_05.f90#L8345) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50530`](../source_parts/nswc_part_05.f90#L8369) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50554`](../source_parts/nswc_part_05.f90#L8393) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50581`](../source_parts/nswc_part_05.f90#L8420) |


Let A be a double precision m x n sparse matrix stored in the arrays A, /A,JA. Then the following subroutines are available for multiplying A with a double precision vector.

~ CALL DVPRD(m,n, A, IA, JA, 2, y)

The argument z is a column vector of dimension n and y an array of dimension m. A, x, y are double precision arrays. When DVPRD is called, Az is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DVPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are column vectors of dimension n and m respectively. A, x, y are double precision arrays. When DVPRD1 is called, Ax + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DTPRD(M, N, A, IA, JA, X, Y)
```

The argument z is a row vector of dimension m and y an array of dimension n. A, z, y are double precision arrays. When DTPRD is called, 2A is computed and stored in y.

**Remark.** It is assumed that the arrays A,2,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DTPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are row vectors of dimension m and n respectively. A, x, y are double precision arrays. When DTPRDI is called, 2A + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 241](../scans/page_0241.png)</small>

<a id="topic-241-01"></a>
### Product Of A Complex Sparse Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50605`](../source_parts/nswc_part_05.f90#L8444) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50629`](../source_parts/nswc_part_05.f90#L8468) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50653`](../source_parts/nswc_part_05.f90#L8492) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L50680`](../source_parts/nswc_part_05.f90#L8519) |


Let A be a complex m x n sparse matrix stored in the arrays A,IA,JA. Then the following subroutines are available for multiplying A with a complex vector.

```fortran
CALL CVPRD(M, N, A, IA, JA, X, Y)
```

The argument x is a column vector of dimension n and y an array of dimension m. A,z,y ate complex arrays. When CVPRD is called, Ax is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CVPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are column vectors of dimension n and m respectively. A,a,y are complex arrays. When CVPRD1 is called, Az + y is computed ard stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CTPRD(M, N, A, IA, JA, X, Y)
```

The argument 2 is a row vector of dimension m and y an array of dimension n. A,z,y are complex arrays. When CTPRD is called, 2A is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do net overlap. Programmer. A. H. Morris.

```fortran
CALL CTPRD1i(m,n, A, 1A,/ 4,2, y)
```

The arguments x and y are row vectors of dimension m and n respectively. A,z,y are complex arrays. When CTPRDL is called, 2A + y is computed and stored in y.

**Remark.** Ii is assumed that the arrays A,z,y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 242](../scans/page_0242.png)</small>

<a id="topic-242-01"></a>
### L1 Norm of a Sparse Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [`L50729`](../source_parts/nswc_part_05.f90#L8568) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [`L50782`](../source_parts/nswc_part_05.f90#L8621) |


```text
If A = (a,;) is a sparse real matrix then the following subroutines are available for
computing the 2; norm ||Al|,; = max, U,{o,,;| of A.
```

```fortran
CALL SiNRM(A,/A,J.A,m,n,ANGRM,WK)
CALL DS1NRM(A, IA, JA, M, N, ANORM, WK)
```

S1NRM is used if A and WK are real arrays and ANORM areal variable, and DSINKM is used if A and WK are double precision arrays and ANORM a double precision variable.

A is a sparse m X n matrix stored in the arrays A, 1A, JA. When the routine is called, the variable ANORM is assigned the value || Alj1.

WK is an array of dimension n or larger that is a work space for the routine.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 243](../scans/page_0243.png)</small>

<a id="topic-243-01"></a>
### L-infinity Norm of a Sparse Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [`L50704`](../source_parts/nswc_part_05.f90#L8543) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [`L50757`](../source_parts/nswc_part_05.f90#L8596) |


```text
If A = (a,;) is a sparse real m x n matrix then the following functions are available for
computing the é,, norm ||Aj|.o = max, Z,|a,;| of A.
```

SNRM(4A,/A,JA,m,n) DSNRM(A.IA,JA,m,n)

SNRM is used if A is a real array and DSNRM is used if A is a double Precision array. SNRM is a real function and DSNRM a double precision function.

A is a sparse m X n matrix stored in the arrays A, IA, JA. When either of these functions is called then the function is assigned the value ||Al|oo-

**Remark.** DSNRM must be declared to be of type DOUBLE PRECISION in the calling program.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 244](../scans/page_0244.png)</small>

<a id="topic-244-01"></a>
### Ordering The Rows Of A Sparse Matrix By Increasing Length

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [`L50811`](../source_parts/nswc_part_05.f90#L8650) |


Let A be a sparse mxn matrix stored in the arrays A, JA, JA. The following subroutine is available for ordering the rows of the matrix by increasing length.

```fortran
CALL SPORD(M, N, IA, R, IWK)
```

R is an integer array of dimension m. When SPORD 1s called, the rows of the matrix are ordered by increasing length. The row ordering is given in R.

IWK is an integer array of dimension m+n-+1 or larger that is used for a work space.

**Remark.** If rows t;,...,%,% are the rows of length @, then the indices 1), ...,%% are listed in F in increasing sequence.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 245](../scans/page_0245.png)</small>

<a id="topic-245-01"></a>
### Reordering Sparse Matrices Into Block Triangular Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [`L50848`](../source_parts/nswc_part_05.f90#L8687) |


Let A be a sparse n x n matrix stored in the arrays A,/A,JA. Then the subroutine SLKORD is available for reordering the rows and columns of A so that one has a lower block triangular matrix

‘Ay 0 Az: Azz

(+) . . « Agr Ago... Akk

where the blocks A,,; are square and cannot themselves be reordered into lower block triangular form.

```fortran
CALL BLKORD(N, IA, JA, R, C, IB, NUM, IWK, IERR)
```

Rand C are integer arrays of dimension n, and IERR is an integer variable. When BLKORD is called, the rows of the matrix are first ordered so that the main diagonal contains @ maximum number of nonzeros. After this is done then IERR = the number of zeros that appear on the diagonal. If [ERR = 0 then the rows and columns of the matrix are ordered into block triangular form (*). The row ordering is given in R and the column ordering is given in C.

TB is an integer array of dimension n and k is an integer variable. When the matrix has been ordered into block triangular form (*) then k = the number of blocks A,;. Also 7B(t) — the row number in the block triangular matrix of the beginning of block A,,; (¢ = 1, ...,k).

IWK is an integer array of dimension 5n or larger that is used for a work space by the routine.

**Error Return.** If [FRR # 0 then the routine terminates. In this case, R contains the row ordering that gives the main diagonal with the maximum number of nonzeros.

**Remark.** JA,JA, and m are not modified by the routine.

**Programming.** BLKORD employs the subroutines MC2Z1A, MC21B, MCI3D, MCI3E designed by I. S. Duff and J. K. Reid (AE RE Harwell,England).

**References.**

(1) Duff, f.S., “On Algorithms for Obtaining a Maximum ‘Transversal,’ ACM Trans. Math Software 7 (1981), pp.315 330.

(2) Duff, £ S. and Reid, J. Ko, “An Implementation of Tarjan’s Algorithm for the Block Triangularization of a Matrix,” ACM Trans. Math Software 4 (i978), pp. 187 147,


<small>Original source: [View scanned PDF page 246](../scans/page_0246.png)</small>

<a id="topic-246-01"></a>
### Solution Of Sparse Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [`L51201`](../source_parts/nswc_part_05.f90#L9040) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L51510`](../source_parts/nswc_part_05.f90#L9349) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L51630`](../source_parts/nswc_part_05.f90#L9469) |


Let A be a nonsingular ». x n sparse real matrix stored in the arrays A,JA,JA and let 6 be areal column vector c dimension n. The subroutines SPSLV and RSLV are available for solving the system cf equations Ar = b, and the subroutine TSLV is available for solving the transposed system cf equations A’z = $. These routines employ partial pivot gauss elimination with column interchanges to first obtain an LU decomposition of A. If SPSLV is called then only the off-diagonal nonzero elements of U are stored, and then the equations are solved. However, if RSLV or TSLV is called then the off-diagonal nonzero elements of both L and U are stored. Thus RSLV and TSLV will frequently require at least double the amount of storage needed by SPSLV, but they can be recalled to solve other systems of equations Az = r and A'z = r without having to redecompose the matrix A. Moreover, since RSLV and TSLV will always generate the same LU decomposition of A, RSLV can be called to decompose A and solve a system of equations Ax = 5, and then TSLV can be called so solve a transposed system of equations Atz = r using the decomposition obtained by RSLV.

```fortran
CALL SPSLV(N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR)
```

It is assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations Az = 6 is computed and stored in X. A,JA, JA and 6 are not modified by the routine.

Rois ao integer array of n entries specifying the order in which the n rows of A are I y

to be examined and processed. For example, if R contains the entries 4), ...,t, then the algorithm first performs operations on row 7;, next on row tg, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of a subroutine such as SPSLV. ‘Thus 2 must be chosen judiciously.

R is not modified by the routine.

Cos an integer array of n entries which plays a role similar to 7. On input, © specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries jy, ..-, J, then it is suggested that the first pivot element may be from column jy, the second pivot element from column go, ete. However, since partial pivoting with column interchange is performed, on output Co may have been modified. On output, Co will contain the actual order of the m columns from

which the pivot elements were selected. his order will depend on A and R, and not on b.

IWK and WK are arrays for internal use by the routine, and MAX is an input argument When SPSLV is called, an LU decomposition of Ads first obtained where ois a limit upper triangular matrix. The offdiagonal portion of (ois stored in sparse form in PWR and Wis MAX is an estimate of the maximum number of off-diagonal elements of ( that might be nonzero and have to be stored (MAX so on(a 2) o2). IWR is cu integer array of dimension Bn ft MAN ¢ 2oor larger, and Whois areal array of dimension mob MPAX or dare


<small>Original source: [View scanned PDF page 247](../scans/page_0247.png)</small>

IERR is an integer variable that reports the status of the results. When the routine terminates, TERR has one of the following values:

IEk 2 > 0 Az = 6 was solved. IERR = max{1,m} where m is the number of off-diagonal nonzero elements of U.

IERR =0 ‘The argument n is nonpositive.

IERR = ~k Row R(k) of A is null.

IERR = — n— & Row R(k) of A has a duplicate entry.

IERR = —2n — k Row R(k) of A has been reduced to a row containing only zeros.

IERR = --3n — k Row & of the upper triangular matrix exceeds storage.

MAX must be increased.

When an error is detected, the routine immediately terminates.

**Remarks.** The amount of storage MAX depends critically on the row ordering given in R. If it is suspected that the rows and columns of .A can be reordered so that one has a lower block triangular matrix

Au {)

Az Azz

Ax Ak eae Akk

then the subroutine BLKORD should first be tried. This subroutine will specify an ordering for lower block triangular form if one exists. However, if such an ordering does not exist and one is uncertain how to order the rows, then the row ordering given by the subroutine SPORD frequently yields good results. In any case, the selection of an initial column ordering C is never bothersome since partial pivoting with column interchanges is performed. The initial ordering C(t) =: 1 (f = 1, ...,n) always suffices.

**Programming.** SPSLV is a modification by A. H. Morris of the subroutine NSPIV. SPSLV employs the subroutine NSPIV1. NSPIV and NSPIV1 were written by Andrew H. Sherman (University of Texas at Austin).

**Reference.** Sherman, Andrew H.,“Algorithms for Sparse Gaussian Elimination with Partial Pivoting,” “M Trans. Math Software 4 (1978), pp.330-~338.

```fortran
CALL RSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
CALL TSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
```

RSLV is called for solving Ar ~ 5, and TSLV is called for solving Abr <= 6. MO is an input argument which specifies if RSLV or TSLV is being called for the first time. On an initial call, MO ©. 0 and we have the following setup:

It is assumed that n° P and that X is an array of dimension re. Che solution of the system of equations is stored in X. A, JA, JA are not modified by the routines. X and b may share the same storage area. If A is a separate storage area then 6 is not modified by

the routines.


<small>Original source: [View scanned PDF page 248](../scans/page_0248.png)</small>

\# ig an integer array of entries specifying the order in which the n rows of A are to be examined and processed. For example, if R contains the entries ¢), ...,1, then che algorithm first performs operations on row tj, next on row fq, etc. It is well known that the or“er in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of subroutines such as RSLV and TSLV. Thus & must be chosen judiciously. & is net modified by the routine.

C is an integer array of « entries which plays a role similar to #. On input, C specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries 71, ...,j7, then it is suggested that the first pivot element may be from column j,, the second pivot element from column 33, etc. However, since partial pivoting with column interchange is performed, on output C’ may have been modified. On output, C will contain the actual order of the » columns from which tus pivot elements were selected. This order will depend on A and R, and not on 8.

iV¥K and WK are arrays for internal use by the routines, and MAX is an input argument. On an initial call to RSLV or TSLV, an LU decomposition of A is first obtained where J. is 4 lower triangular matrix and U a unit upper triangular matrix. The off-diagonal portions of 1 and 'J are stored in sparse form in IWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of £ and U that might be nonzero and have to be stored (MAX < n(n — 1)}. [WK is an integer array of dimension 4n + MAX + 2 or larger, and ‘VK is a real array of dimension 2n + MAX or larger.

On an initial call to RSLV or TSLV, JERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values: IERR > 0 The system of equations was solved. IERR=miax{1,m} where m is the total number of off-diagonal nonzero elements of L and U.

[ERR =0 The argument n is nonpositive.

IERit = -k Row R(k) of A is null.

JERR =~ n~- k Row R(k) of A has a duplicate entry.

TERR = --2n ~ k Row R(x} of A has been reduced to a row containing

only zeros. TERR =: ~3n -- k Row & of L or U exceeds storage. MAX must be increased,

When an error is detect 2d, the routine immediately terminates.

After an initial call to RSLV or TSLV, if IERR > 0 on output then either routine may be called with MO #0. When MO + 0 it is assumed that only 8 may have been modified. RSLV is called for solving the new set of equations Ax -~ 6, and TSLV is called for solving the new set of equations A'a = 6. The routine employs the LU decomposition obtained on the initial call to RSLV or TSLV to solve the new system of equations. The solution is stored in X. As before, Y and 6 may share the same storage area. H MO -4 0 then only n, A, CO, IWK, and WH are used. A, PA, JA, RTAX, and PERR are not referenced by the rOUtInG,

**Note.** The remarks concerning the ordering Gf the rows and columns of A when SPSLV is

LOT


<small>Original source: [View scanned PDF page 249](../scans/page_0249.png)</small>

used hold also fur RSLV and TSLV.

**Programming.** RSLV calls the subroutines RSLV1 and SPLU, and TSLV calls the subroutines TSLV1 and SPLU. These routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 250](../scans/page_0250.png)</small>

<a id="topic-250-01"></a>
### Computation Of The Condition Number Of A Real Sparse Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [`L52671`](../source_parts/nswc_part_06.f90#L1) |


If A is a real nXm sparse matrix then the following subroutine is available for estimating the €; condition number cond,(A) of A.

```fortran
CALL SiCND(n, A, A, JA, R, C,MAX,COND,IWK,WK,IERR)
```

A ig 4 sparse matrix stored in the arrays A,JA,Jsi. The arguments R, C, MAX, IWK, and WK are the same arguments used for the subroutines RSLV and TSLV, the only exceptions being that [WK now is an array of dimension 5n -+ MAX + 2 or larger, and WK is an array of dimension 4n + MAX or larger.

COND is a real variable. When S1CND is called, then the subroutine RSLV is first invoked to obtain an LU decomposition of A, which is stored in the arrays IWK and WK. Then COND is assigned the value 0 if A is singular and an approximation of the condition number cond,{A) if A is nonsingular.

IERR is an integer variable that reports the status of the results. When SiCND terminates, TERR has one of the following values:

JERR > 0 A is nonsingular. COND = an approximation of the condition number of A, and IERR = max{i,m} where m is the number of off-diagonal nonzero elements of Z and U.

iKRR = 0 A is singular and COND = 0,

TERR := ~k Row R{k) of A has a duplicate entry.

iIERR < -n Row R(k) of L or U exceeds storage where IERR = —(n + k). MAX must be increased.

When an error is detected, the routine immediately terminates.

Usage. After S1CND terminates, if IERR > 0 then RSLV or TSLV may be called with MO # O to solve a system of equations. In this case n,R,C,WK, and IWK are used by RSLV and TSLV, and must not be modified by the user.

**Algorithm.** A modification cf the Hager procedure by Nicholas J. Higham (University of Manchester, England) is used.

**Programming.** S1CND employs the subroutines SENRM, SONEST, SCOPY, RSLV, TSLV, RSLV1, PSLVI, and SPLU, and the functions SASUM and ISAMAX. S1CND was written by A. H. Morris. SONEST was written by Nod. Higham and modified by A. H. Morris.

**References.**

(1) higham, NJ. “FORTRAN Codes for Estimating the One Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACA Tran, Math Software 14 (1988), pep. USL 396,


<small>Original source: [View scanned PDF page 251](../scans/page_0251.png)</small>

ee “Algorithm 674: FORTRAN Codes for Estimating the One-Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 15 (1989), p. 168.


<small>Original source: [View scanned PDF page 252](../scans/page_0252.png)</small>

<a id="topic-252-01"></a>
### Double Precision Solution Of Sparse Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [`L51933`](../source_parts/nswc_part_05.f90#L9772) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L52245`](../source_parts/nswc_part_05.f90#L10084) |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L52366`](../source_parts/nswc_part_05.f90#L10205) |


Let A be a nonsingular n x n sparse double precision matrix stored in the arrays A, IA,JA and let 6 be a double precision column vector of dimension n. The subroutines DSPSLV and DSLV are available for solving the system of equations Az = 6, and the subroutine DTSLV is available for solving the transposed system of equations A’z = b. These routines employ partial pivot Gauss elimination with column interchanges to first obtain an LU decomposition of A. If DSPSLV is called then only the off-diagonal nonzero elements of U are stored, and then the equations are solved. However, if DSLV or DTSLV is called then the off-diagonal nonzero elements of both L and U are stored. Thus DSLV and DTSLV will frequently require at least double the amount of storage needed by DSPSLV, but they can be recalled to solve other systems of equations Ar = r and A‘z = r without having to redecompose the matrix A. Moreover, since DSLV and DTSLV will always generate the same LU decomposition of A, DSLV can be called to decompose A and solve a system of equations Az = 6, and then DTSLV can be called to solve a transposed system of equations Atz =r using the decomposition obtained by DSLV.

```fortran
CALL DSPSLV(N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR)
```

A, 6, and X are double precision arrays. It is assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations Ar = 6 is computed and stored in X. A,JA, JA and 5 are not modified by the routine.

Ris an integer array of n entries specifying the order in which the n rows of A are tr, be examined and processed. For example, if R contains the entries 11, ...,%, then the algorithm first performs operations on row t1, next on row f9, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of a subroutine such as DSPSLV. Thus R must be chosen judiciously. FR is not modified by the routine.

C is an integer array of n entries which plays a role similar to R. On input, C specifies a suggested order in which the n columns of A should be ordered fer selection of the pivot elements. For example, if C contains the entries 71, ...,jn then it is suggested that the first pivot element may be from column j;, the second pivot element from column jo, etc. However, since partial pivoting with column interchange is performed, on output C may have been modified. On output, C’ will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and R, and not on b.

{WK and WK are arrays for internal use by the routine, and MAX is an input argument. When DSPSLV is called, an LU decomposition of ¢. is first obtained where U is a unit upper triangular matrix. The off-diagonal portion of U is stored in sparse form in IWK and WK. MAX 1s an estimate of the maximum number of off-diagonal elements of U that might be nonzero and have to be stored (MAX < n(n -- 1)/2). {WK is an integer array of dimension an 4+ MAX -+ 2 or larger, and WK is a double precision array of dimension n + MAX or larger.


<small>Original source: [View scanned PDF page 253](../scans/page_0253.png)</small>

IERR is an integer variable that reports the status of the results. When the routine terminates, ERR has one of the following values:

IERR > 0 Ag = 6 was solved. IERR = max{1,m} where m is the number of off-diagonal nonzero elements of U.

IERR =0 The argument n is nonpositive.

IERR = --k Row R(k) of A is null.

IERR = — n—k Row R(k) of A has a duplicate entry.

IERR = --2n — k Row R(k) of A has been reduced to a row containing only zeros.

IERR = —3n—k Row k of the upper triangular matrix exceeds storage.

MAX must be increased.

When an error is detected, the routine immediately terminates.

**Remarks.** The amount of storage MAX depends critically on the row ordering given in R. If it is suspected that the rows and columns of A can be reordered so that one has a lower block triangular matrix

Ay 0 )

Az A2ze2

Agi Axa ...) Akk /

then the subroutine BLKORD should first be tried. This subroutine will specify an ordering for lower block triangular form if one exists. However, if such an ordering does not exist and one is uncertain how to order the rows, then the row ordering given by the subroutine SPORD frequently yields good results. In any case, the selection of an initial column ordering C is never bothersome since partial pivoting with column interchanges is performed. The initial ordering C(t) = 1 (t= 1, ...,n) always suffices.

**Programming.** DSPSLV an adaptation by A. H. Morris of the subroutine NSPIV written by Andrew H. Sherman (University of Texas at Austin). DSPSLV employs the subroutine DNSPIV.

**Reference.** Sherman, Andrew H.,“Algorithms for Sparse Gaussian Elimination with Partial Pivoting,” ACM Trans. Math Software 4 (1978), pp.330-338.

```fortran
CALL DSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
CALL DTSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
```

DSLV is called for solving Ax = 6, and DTSLV is called for solving Az = b. MO is an input argument which specifies if NSLV or DTSLV is being called for the first time. On an initial call, MO == 0 and we have the following setup:

A, b, and X are double precision arrays. {t ia assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations is stored in X. A, 1A, JA are not modified by the routines. X and 6 may share the same storage area. [f X is a separate storage area then 6 is not modified by the routines.


<small>Original source: [View scanned PDF page 254](../scans/page_0254.png)</small>

R is an integer array of n entries specifying the order in which the » rows of A are to be examined and processed. For example, if R contains the entries 11, ...,%, then the algorithm first performs operations on row s1, next on row ¢g, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of subroutines such as DSLV and DTSLV. Thus & must be chosen judiciously. # is not modified by the routine.

C is an integer array of n entries which plays a role similar to #. On input, C specifies a suggested order in which the m columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries j1,...,7, then it is suggested that the first pivot element may be from column j;, the second pivot element from column je, etc. However, since partial pivoting with column interchange is performed, on output C may have been modified. On output, C will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and R, and not on 6.

IWK and WK are arrays for internal use by the routines, and MAX is an input argument. On an initial call to DSLV or DTSLV, an LU decomposition of A is first obtained where L is a lower triangular matrix and U a unit upper triangular matrix. The off-diagonal portions of Z and U are stored in sparse form in IWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of L and U that might be nonzero and have to be stored (MAX < n(n — 1)). [WK is an integer array of dimension 4n + MAX + 2 or larger, and WK is a double precision array of dimension 2n + MAX or larger.

On an initial call to DSLV or DTSLV, IERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values:

IERR > 0 The system of equations was solved. IERR=max (1, m} where m is the total number of off-diagonal nonzero elements of L and U.

IERR =0 The argument n is nonpositive.

IERR = --k Row R(k) of A is null.

IERR = — »— k Row R(k) of A has a duplicate entry.

IERR = -2n. k Row Plk) of A has been reduced to a row containing only zeros.

IERR = ~—3n — k Row k of L or U exceeds storage. MAX must be increased.

When an error is detected, the routine immediately terminates.

After an initial call to DSLV or DTSLV, if FERR > 0 on output then either routine may ve called with MO #0. When MO ¥ 0 it is assumed that only 6 may have been modified. DSLV is called for solving the new set of equations Az = b, and DTSLV is called for solving the new set of equations A'r = 6. The routine employs the LU decomposition obtained on the initial call to DSLV or DTSLV to solve the new system of equations. The solution is stored in X. As before, X and 6 may share the same storage area. If MO # 0 then only n, A, C, (WK, and WK are used. A, JA, JA, MAX, and IERR are not referenced by the routine.

Note. The remarks concerning the ordering of the rows and columns of A when DSPSLV


<small>Original source: [View scanned PDF page 255](../scans/page_0255.png)</small>

is used hold also for DSLV and DTSLV.

**Programming.** DSLV calls the subroutines DSLV1 and DSPLU, and DTSLV calls the subroutines DTSLV1 and DSPLU. These routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 256](../scans/page_0256.png)</small>

<a id="topic-256-01"></a>
### Computation Of The Condition Number Of A Double Precision Sparse Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [`L52729`](../source_parts/nswc_part_06.f90#L59) |


If A is a double precision n x n sparse matrix then the following subroutine is available for estimating the £; condition number cond,(A) of A.

```fortran
CALL DS1CND(N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR)
```

A ig 4 sparse matrix stored in the arrays A,/A,JA where A is a double precision array. The arguments R, C, MAX, IWK, and WK are the same arguments used for the subroutines DSLV and DTSLV, the only exceptions being that [WK now is an array of dimension 5n + MAX + 2 or larger, and WK is an array of dimension 4m -+ MAX or larger.

COND is a double precision variable. When DS1CND is called, then the subroutine DSLV is first invoked to obtain an LU decomposition of A, which is stored in the arrays IWK and WK. Then COND is assigned the value 0 if A is singular and an approximation of the condition number cond,(A) if A is nonsingular.

TERK is an integer variable that reports the status of the results. When DS1CND terminates, JERR has one of the following values:

TERR > O A is nonsingular. COND = an approximation of the condition number of A, and [ERR = max{1,m} where m is the number of oi-diagonal nonzero elements of L and U.

TERR = O© Ais singular and COND = 0.

IERR = -k Row R(k) of A has a duplicate entry.

IERR < -n Row R(k) of L or U exceeds storage where [ERR = —(n + k). MAX must be increased.

When an error is detected, the routine immediately terminates.

Usage. After DS1CND terminates, if IW@Rix > 0 then DSLV or DTSLV may be called with MO +¥ 0 to solve a system of equations. In this case n, R,C,WK, and IWK are used by DSLV and DTSLV, and must not be modified by the user.

**Algorithm.** A modification of the Hager procedure by Nicholas J. Higham (University of Manchester, England) is used.

**Programming.** DS1CND employs the subroutines DSINRM, DONEST, DCOPY, DSLV, DSLV1, DTSLV, DTSLV1, and DSPLU, and the functions DASUM and IDAMAX. DS1CND was written by A. H. Morris. DONEST is the double precision form of the subroutine SON- EST, written by N. J. Higham and modified by A. H. Morris.

**References.**

(1) Higham, N.J.,“FORTRAN Codes for Estimating the One~Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 14 (1988), pp. 381-396.


<small>Original source: [View scanned PDF page 257](../scans/page_0257.png)</small>

ee »“Algorithm 674: FORTRAN Codes for Estimating the One--Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 15 (1989), p. 168.


<small>Original source: [View scanned PDF page 258](../scans/page_0258.png)</small>

<a id="topic-258-01"></a>
### Solution Of Sparse Systems Of Complex Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [`L53109`](../source_parts/nswc_part_06.f90#L439) |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L53421`](../source_parts/nswc_part_06.f90#L751) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L53542`](../source_parts/nswc_part_06.f90#L872) |


Let A be a nonsingular n x n sparse complex matrix stored in the arrays A, J A,JA and let b be a complex column vector of dimension n. The subroutines CSPSLV and CSLV are available for solving the system of equations Az = 8, and the subroutine CTSLV is available for solving the transposed system of equations A‘tz = b. These routines employ partial pivot Gauss elimination with column interchanges to first obtain an LU decomposition of A. If CSPSLV is called then only the off-diagonal nonzero elements of U are stored, and then the equations are solved. However, if CSLV or CTSLV is called then the off-diagonal nonzero elements of both L and U are stored. Thus CSLV and CTSLV will frequently require at least double the amount of storage needed by CSPSLV, but they can be recalled to solve other systems of equations Az = r and A‘z = r without having to redecompose the matrix A. Moreover, since CSLV and CTSLV will always generate the same LU decomposition of A, CSLV can be called to decompose A and solve a system cf equations Ar = b, and then CTSLV can be called to solve a transposed system of equations A’z = r using the decomposition obtained by CSLV.

```fortran
CALL CSPSLV(N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR)
```

A, b, and X are complex arrays. It is assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations Az = 6 is computed and stored in_X. A,IA, JA and 6 are not modified by the routine.

R is an integer array of n entries specifying the order in which the n rows of A are to be examined and processed. For example, if R contains the entries 11, ...,%, then the algorithm first performs operations on row 11, next on row t2, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of a subroutine such as CSPSLV. Thus A must be chosen judiciously. R is not modified by the routine.

C is an integer array of n entries which plays a role similar to R. On input, C specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C’ contains the entries Jiy+-+;dn then it is suggested that the first pivot element may be from column j,, the second pivot element from column 72, etc. However, since partial pivoting with column interchange is performed, on output Co may have been modified. On output, C will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and R, and not on 6.

IWK and WK are arrays for internal use by the routine, and MAX is an input argument, When CSPSLV is called, an LU decomposition of A is first obtained where U is a unit upper triangular matrix. The off-diagonal portion of U is stored in sparse form in TWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of U that might be nonzero and have to be stored (MAX < n(n ~ 1)/2). IWK is an integer array of dimension dn + MAX + 2 or larger, and WK is a complex array of dimension n | MAX or larger.

SAY


<small>Original source: [View scanned PDF page 259](../scans/page_0259.png)</small>

IERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values:

IERR > 0 Az = 6b was solved. IERR = max{1,m} where m is the number of off-diagonal nonzero elements of U.

IERR =0 The argument n is nonpositive.

IERR = —k Row R(k) of A is null.

JERR = — n-k Row R(k) of A has a duplicate entry.

IERR = —2n—k Row R(k) of A has been reduced to a row containing only zeros.

IERR = ~3n—k Row k of the upper triangular matrix exceeds storage.

MAX must be increased.

When an error is detected, the routine immediately terminates.

**Remarks.** The amount of storage “AX depends critically on the row ordering given in &. If it is suspected that the rows and columns of A can be reordered so that one has a lower block triangular matrix

{Au 0

Avi Ag

er Arka... Akg

then the subroutine BL} ORD should first be tried. This subroutine will specify an ordering for lower block triangular form if -ne exists. However, if such an ordering does not exist aad one is uncertain how ‘o order :he rows, then the row ordering given by the subroutine SPORD frequently yields good results. In any case, the selection of an initial column ordering C is never bothersome. since partial pivoting with column interchanges is performed. The initial ordering C(t) =: + (¢--1,...,n) always suffices.

**Programming.** CSP3LV is an adaptation by A. H. Morris of the subroutine NSP! V written by Andrew H. Sherman (University of Texas at Austin). CSPSLV employs the subroutine CNSPIV.

**Reference.** Sherman, Andrew H.,“Algorith us for Sparse Gaussian Elimination with Partial Pivoting,” ACM Trans. Math Software 4 (1978), pp.350. 338.

```fortran
CALL CSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
CALL C. SEV(MO,n, 4, 1A, JA, b, Rt, CMAX,XIWK WK ,IERR)
```

CSLV is called for solving Ag. 6, and C'VSLV is called for solving Abx 6. MO is an Input argument which specifies wf CSLV or CTSLYV is being called for the first time. On an initial call, MO: U and we have the following setup:

A, 6, and X are complex arrays. [tas assumed that nm 7 E and that XY is an array of dimension n. The solution of the system of equations is stored in NA, PA, JA are not modified by the routines. Xo and 6 may share the same storage area. HN is a separate

storage area then bis nei modified by the routines. 5 ’


<small>Original source: [View scanned PDF page 260](../scans/page_0260.png)</small>

R is an integer array of n entries specifying the order in which the n rows of A are to be examined and processed. For example, if R contains the entries 11, ...,1, then the algorithm first performs operations on row 11, next on row f2, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of subroutines such as CSLV and CTSLV. Thus R must be chosen judiciously, A is not modified by the routine.

C is an integer array of n entries which plays a role similar to R. On input, C' specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries 71, ...,j, then it is suggested that the first pivot element may be from column J), the second pivot element from column jo, etc. However, since partial pivoting with column interchange is performed, on output C’ may have been modified. On output, C will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and &, and not on 6.

IWK and WK are arrays for internal use by the routines, and MAX is an input argument. On an initial call to CSLV or CTSLV, an LU decomposition of A is first obtained where LF is a lower triangular matrix and U a unit upper triangular matrix. The off-diagonal portions of L and U are stored in sparse form in IWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of L and U that might be nonzero and have to be stored (MAX < n(n -- 1)). TWK is an integer array of dimension 4n + MAX + 2 or larger, and WK is a complex array of dimension 2n -+- MAX or larger.

On an initial call to CSLV or CTSLV, IERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values: IERR > 0 The system of equations was solved. INRR=max{1,m} where m is the total number of off-diagonal nonzero

elements of L and U.

IERR » 0 The argument nis nonpositive.

IERR = -k Row I(k) of A is null.

IE RR -n- k Row R(k) of A has a duplicate entry.

TERR én k Row R(k) of A has been reduced to a row containing only zeros

TERR 3n k Row kof Lo or U exceeds storage. Mi AX must be in-

creased.

When an error is detected, the routine immediately terminates,

After aa initial call to CSLY of CPSELV, of HeR RO} Coon output thee either routine ray be called with MO / 0. When MO / 0 it is assumed that only 6 may have been modified, CSLV is called for solving che new set of equations Arb, and CTSLV is called for solving the new set of equations Ale 6. The routine employs the LU decomposition obtained on the initial call te CSLY or CVSLYV to solve the pew system: of equations. The solution is stored in XY. As before, X and 6 may share the same storage area. IMO / 0 then only ny AOC, TWH, and WK are used A, PA, A, MAX, and PRR are not referenced by the routine,


<small>Original source: [View scanned PDF page 261](../scans/page_0261.png)</small>

**Note.** The remarks concerning the ordering of the rows and columns of A when CSPSLV is used hold also for CSLV and CTSLV.

**Programming.** CSLV calls the subroutines CSLV1 and CSPLU, and CTSLV calls the subroutines CTSLV1 and CSPLU. These routines were written by A. H. Morris.

