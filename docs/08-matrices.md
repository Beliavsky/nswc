[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-142"></a>
## Matrices

<small>Original source: [View scanned PDF page 142](../scans/page_0142.png)</small>

<a id="topic-142-01"></a>
### Packing And Unpacking Symmetric Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [`L35796`](../source_parts/nswc_part_04.f90#L4083) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [`L35812`](../source_parts/nswc_part_04.f90#L4099) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [`L35828`](../source_parts/nswc_part_04.f90#L4115) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [`L35858`](../source_parts/nswc_part_04.f90#L4145) |


Ann Xn symmetric matrix A = (a,;) can be represented by either its lower triangular elements 411 412 G13 G21 @22 423 S3i_432_ 233

or its upper triangular elements. If the lower triangular elements are used, then the packed form for the matrix is an array of dimension n(n + 1)/2 containing the elements 011021092431439433-°+* Similarly, if the upper triangular elements are used then the packed form for the matrix is an array containing @11412-**@1n@22223°°*Goan-*- Currently the lower triangular elements are used for packing symmetric matrices. The following subroutines are available for packing and unpacking real symmetric matrices.

```fortran
CALL MCVFS(A, KA, N, B)
CALL DMCVFS(A, KA, N, B)
```

Ais ann Xn symmetric matrix and B an array whose dimension is equal to or greater than n(n + 1)/2. The routines store the packed form of A in B. MCVFS is used if A and B are real arrays and DMCVFS is used if A and B are double precision arrays. The input argument ka has the following value:

ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > n.

**Note.** A and B may begin in the same location. Programmer. A. H. Morris.

```fortran
CALL MCVSF(A, KA, N, B)
CALL DMCVSF(A, KA, N, B)
```

B is an array containing the elements of a packed n x n symmetric matrix and A is an array of dimension ka x n where ka > n. The routines unpack 3 and store the results in A. MCVSF is used if A and #3 are real arrays and DMCVSF is used if A and BD are double precision arrays.

**Note.** A and # may begin in the same location.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 143](../scans/page_0143.png)</small>

<a id="topic-143-01"></a>
### Conversion Of Real Matrices To And From Double Precision Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35888`](../source_parts/nswc_part_04.f90#L4175) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35902`](../source_parts/nswc_part_04.f90#L4189) |


The subroutines MCVRD and MCVDR are available for converting real matrices to and from double precision form.

```fortran
CALL MCVRD(M, N, A, KA, B, KB)
```

Ais areal mxn matrix and B a double precision 2-dimensional array. MCVRD stores the matrix in double precision form in the array B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL MCVDR(M, N, A, KA, B, KB)
```

A is a double precision m x n matrix and B a real 2-dimensional array. MCVDR stores the matrix in single precision form in the array B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 144](../scans/page_0144.png)</small>

<a id="topic-144-01"></a>
### Storage Of Real Matrices In The Complex Matrix Format

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35916`](../source_parts/nswc_part_04.f90#L4203) |


The following subroutine is available for storing a real matrix A in the complex matrix format.

```fortran
CALL MCVRC(M, N, A, KA, B, KB)
```

A is a real m x n matrix and B a complex 2-dimensional array. MCVRC stores the matrix in complex form in the array B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb == the number of rows in the dimension statement for B in the calling program it is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 145](../scans/page_0145.png)</small>

<a id="topic-145-01"></a>
### The Real And Imaginary Parts Of A Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35930`](../source_parts/nswc_part_04.f90#L4217) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35944`](../source_parts/nswc_part_04.f90#L4231) |


if A = (a,j) is a complex matrix then let Re(A) = (Re(a,,)) and Im(A) = (In(a,,)) denote the real and imaginary parts of A. The following subroutines are available for obtaining Re(A) and Im(A).

```fortran
CALL CMREAL(M, N, A, KA, B, KB)
```

A is a complex m X n matrix and B a real 2-dimensional array. CMREAL obtains Re(A) and stores it in B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL CMIMAG(M, N, A, KA, B, KB)
```

A is a complex m X n matrix and B a real 2-dimensional array. CMIMAG obtains Im(A) and stores it in B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 146](../scans/page_0146.png)</small>

<a id="topic-146-01"></a>
### Copying Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35958`](../source_parts/nswc_part_04.f90#L4245) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [`L35972`](../source_parts/nswc_part_04.f90#L4259) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35985`](../source_parts/nswc_part_04.f90#L4272) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35999`](../source_parts/nswc_part_04.f90#L4286) |


‘The following subroutines are available for copying matrices.

```fortran
CALL MCOPY(M, N, A, KA, B, KB)
```

A is a real m x n matrix and B a real 2-dimensional array. MCOPY makes a copy of the matrix A and stores it in B, The input arguments ka and kb have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program

It is assumed that ka > m and kt > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL SMCOPY(N, A, B)
```

A is areal packed n x n symmetric matrix and B a real array whose dimension is equal to or greater than n(n 4- 1)/2. SMCOPY makes a copy of the packed symmetric matrix A and stores it in B.

**Programmer.** A. H. Morris.

```fortran
CALL DMCOPY(M, N, A, KA, B, KB)
```

A is a double precision m x n matrix and B a double precision 2-dimensional array. DMCOPY makes a copy of the matrix A and stores it in B. The input arguments ka and kb nave the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kd > m, and that 8 contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL CMCOPY(M, N, A, KA, B, KB)
```

Ais a complex mxn matrix and B a complex 2-dimensional array, CMCOPY makes a copy of the matrix A and stores it in 8. The input arguments ke and kb have the following values:

ka <= the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 147](../scans/page_0147.png)</small>

<a id="topic-147-01"></a>
### Computation Of The Conjugate Of A Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36013`](../source_parts/nswc_part_04.f90#L4300) |


If A = (a,;) ig a complex matrix then let A = (a,;) denote the conjugate of A. The following subroutine is available for computing the conjugate matrix A: CALL CMCONJ(m,n, A, ka, B, kb}

Ais a complex mxn matrix and B a complex 2-dimensional array. CMCONJ computes A and stores the results in B. The input arguments ka and kb have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Remark.** A and B may reference the same storage area when ka = kb.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 148](../scans/page_0148.png)</small>

<a id="topic-148-01"></a>
### Transposing Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36027`](../source_parts/nswc_part_04.f90#L4314) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36041`](../source_parts/nswc_part_04.f90#L4328) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36055`](../source_parts/nswc_part_04.f90#L4342) |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [`L36069`](../source_parts/nswc_part_04.f90#L4356) |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [`L36194`](../source_parts/nswc_part_04.f90#L4481) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [`L36319`](../source_parts/nswc_part_04.f90#L4606) |


The subroutines TPOSE, DTPOSE, C £POSE and TIP, DTIP, CTIP are available for transposing a matrix A. TPOSE, DTPOSE, and CTPOSE are used if the results are to be stored in a separate storage area B. TIP, DTIP, and CTIP are used if the results are to be stored in A (i.e., if the transposition is to be done in place).

```fortran
CALL TPOSE(M, N, A, KA, B, KB)
CALL DTPOSE(M, N, A, KA, B, KB)
CALL CTPOSE(M, N, A, KA, B, KB)
```

TPOSE is called if A is a real matrix and 8 a real array, DTPOSE is called if A is a double precision matrix and B a double precision array, and CTPOSE is called if 4 is a complex matrix and B a complex array.

A is a matrix having m rows and n columns, and B a 2-dimensional array. The routine transposes A and stores the results in B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows ir the dimension statement for B in the calling program It is assumed that ka > m and kb > n, and that 2 contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL TIP(A, N1, N2, MOVED, NWORK, NDIM)
CALL DTIP(A, N1, N2, MOVED, NWORK, NDIM)
CALL CTIP(A, N1, N2, MOVED, NWORK, NDIM)
```

TIP is called if A is a real array, DTIP is called if A is a double precision array, and CTIP is called if A is a complex array.

A is an array of dimension mn which contains an m X n matrix to be transposed. The routine transposes the matrix and stores the results in A. Hf mi =: n then the arguments

MOVE, k, MDIM are ignored.

If m ¥# n then & may be any integer. If k < 0 then MOVE is ignored. Otherwise, if k > 1 then MOVE is assumed to be an array of dimension k. MOVE is a storage area for saving information that may help speed up the transposition process. If no information is saved then TIP, DTIP, and CTIP may run 2 10 times slower than TPOSE, DTPOSE, and CTPOSE, However, the use of a storage area may or may not actually speed up the transposition process. This depends entirely on the values of mi and mn. MDIM ts a variable that is set by the routine. After the routine terminates, MDIM will be the estimated optimum setting for & for the current values of me and n.

**Programming.** The routines TIP, DPTEP, and CVEP employ the subroutine INECTR, ‘The routines were written by Norman Brenner (Dept. of Marth and Planetary Sciences,

Massachusetts Institute of Technology), and modified by A. H. Morris.


<small>Original source: [View scanned PDF page 149](../scans/page_0149.png)</small>

**Reference.** Brenner, Norman, “Algorithm 467. Matrix Transposition in Place,” Comm. ACM 16 (1973), pp. 692-694.

LOG


<small>Original source: [View scanned PDF page 150](../scans/page_0150.png)</small>

<a id="topic-150-01"></a>
### Computing Adjoints Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36494`](../source_parts/nswc_part_04.f90#L4781) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [`L36508`](../source_parts/nswc_part_04.f90#L4795) |


If A = (a,;) then let A* = (a,;) denote the adjoint of A. The following subroutines are available for computing A”*.

```fortran
CALL CMADJ(M, N, A, KA, B, KB)
```

A is a complex m xn matrix and B a complex 2-dimensional array. CMADJ computes A* and stores the results in B. The input arguments ka and kb have the following values: ka = the number of rows in the dimension statement for A in the calling program ko = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb » n, and that B contains at least n columns.

**Remark.** CMADJ combines the following operations: CALL CTPOSE(m,n, A, ka, B, kh) CALL CMCONJ(n, m, B, &b, B, kb)

It is assumed that A and B are different storage areas.

**Programmer.** A. H. Morris. CALL CTRANS(ka, n, A)

A is a complex array of dimension ka xn which contains an n xX n matrix. CTRANS computes the adjoint of the matrix and stores the results in A. It is assumed that ka > n.

**Programmer.** George J. Davis (Georgia State University)


<small>Original source: [View scanned PDF page 151](../scans/page_0151.png)</small>

<a id="topic-151-01"></a>
### Matrix Addition

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36544`](../source_parts/nswc_part_04.f90#L4831) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36561`](../source_parts/nswc_part_04.f90#L4848) |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36578`](../source_parts/nswc_part_04.f90#L4865) |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [`L36595`](../source_parts/nswc_part_04.f90#L4882) |


The matrix sum C = A+ B can be computed by the following subroutines: CALL MADD(ta,n, A, ka, B, kb, C, kc)

A and B are real m x n matrices and C a real 2-dimensional array. MADD computes A+ B and stores the results in C. The input arguments ka, kb, kc have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program ke = the numb2r of rows in the dimension statement for C in the calling program It is assumed that ka > m, kb > m, ke > m, and that C contains at least n columns.

The array C' may begin in the same location as A or B. li C begins in the same location as A them it is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that ke == kb. Otherwise, if C dees not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage areas for A and 8B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

**Programmer.** A. H. Morris. CALL SMADD(n, A, B,C)

A and B are real packed nx" symmetric matrices and C is a real array whose dimension is equal to or greater than n(n +-1)/2. SMADD computes A+- B, which is also a symmetric matrix, and stores the results in packed form in C.

The array C may begin in the same location as A or B. If C begins in the same location as A then the result C’ will overwrite the input data A. Similarly, B will be overwritten if C begins in the same location as B. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage

areas for Aa! B.

**Programmer.** A. H. Morris. CALL DMADD(rm,n, A, ka, B, kb, Cy ke)

A and B are double precision m x n matrices and C a double precision 2-dimensional array. DMADD computes -t + B and stores the results in C. The arguments &a, kb, ke have the following values:

ka > the number of rows in the dimension statement for Ain the calling program

kb the number of rows in the dimension statement for ff in the calling program

Ac the number of rows tn the dimension statement for C ip the calling program [tis assumed that ka oom, Abo om, ke oor, and that © contains at least mn columns


<small>Original source: [View scanned PDF page 152](../scans/page_0152.png)</small>

The array C may begin in the same location as A or B. If C begins in the same location as A then it is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that ke = kt. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage «rea for C does not overlap with the storage areas fur A and B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

**Programmer.** A. H. Morris. CALL CMADD (m,n, A, ka, B, kb, C, ke)

A aid B are complex m xn matrices and C a complex 2-dimensional array. CMADD computes A+ B and stores the results in C. The arguments ka, kb, ke have the following ees:

“a = the number of rows in the dimension statement for A in the calling program

ke -= the number of rows in the dimension statement for B in the calling program

ke = the number of rows in the dimension statement for C in the calling program it is assumed that ka > m, kb > m, ke > m, and that C contains at least n columns.

The array C may begin in the same location as A or B. If C begins in the same location as A chen it is assumed that kc = ka. In this case, the result C’ will overwrite the input data 4. Similarly, if C begins in the same location as B then it is assumed that ke = kb. Otherwise, if C’ does not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage areas for A and @. In this case there is no restriction on ke (other than the customary restriction that ke > rm).

Programmer. A. H. Morris.


<small>Original source: [View scanned PDF page 153](../scans/page_0153.png)</small>

<a id="topic-153-01"></a>
### Matrix Subtraction

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36607`](../source_parts/nswc_part_04.f90#L4894) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36624`](../source_parts/nswc_part_04.f90#L4911) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36641`](../source_parts/nswc_part_04.f90#L4928) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [`L36658`](../source_parts/nswc_part_04.f90#L4945) |


The matrix difference C = A - B can be computed by the following subroutines: CALL MSUBT (m,n, A, ke, B, ke, C, ke)

A and B are real m.:n matrices and U a real 2-dimensional array. MSUBT computes A-- B and stores the results in C. ‘Che avout arguments Ke, kb, ke have the following values: ka = the number :f rows in the dimension statement :or A in the calling program kb == the number of rows in the dimension statement tur B in the calling program ke = the number o7 rows in the dimension statement for C in the calling program It is assumed that ka > mm, kb > m, ke > m, and that C’ contains at least n columns.

The array C may begin ii the same location as A or 3B. [fC begins in the same location as A then it is assumed that kc = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed what ke == kb. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage area for C' does not overlap with the storage areas for A and B. In this case there is no restriction on ke (other than the customary restriction that ke > mi}.

**Programmer.** A. H. Morris. CALL SMSUBT(n, A, B,C)

A and # are real packed nx n symmetric matrices and C is a real array whose dimension is equal to or greater than n(n+1)/2. SMSUBT computes A— &, which is also a symmetric matrix, and stores the results in packed form in C.

The array C may begin in the same location as A or B. Uf begins in che same location as A then the result C’ will overwrite the input data A. Similarly, B will be overwritten if C begins in the same location as B. Otherwise, if C does nos begin in the same location as A or B, then it is assumed that the storage area for © does not overlap with the storage areas for A and B.

**Programmer.** A. 1. Morris. CALL OMSUBT(m,n, A, ka, B, kb, C, kc)

A and B are double precision m xX n matrices and C' a double precision 2-dimensional array. DMSUBT computes A -- B and stores the results is C. The arguments ka, &b, kc have the following values:

ka = the number af news in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for Gin the calling program

ke = the number of rows tu the dimension statement for Cin the calling program It is assumed that ca So, ke Soa, Ac hom, and that C contains af least m columns,

vaus|


<small>Original source: [View scanned PDF page 154](../scans/page_0154.png)</small>

‘The array C may begin in the same location as A or B. fC begins in the game location ag A then it is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as 8 then it is assumed that ke =: kb. Otherwise, if C does not, begin in the same location as A or #, then it is assumed that the storage area for C devs not overlap with the storage areas for A and B. In this case there

~.

is no restriction on kc (other than the customary restriction that ke > m).

**Programmer.** A. H. Morris. CALL CMSUBT(m,n, A, ka, B, kb, C, ke)

A and & are complex rm x mn matrices and C a complex 2-dimensional array. CMSUBT computes A -- 8B and stores the results in C. The input arguments ka, kb, ke have the following values:

ka = the number of rows in the dimension statement for A in the calling program

ké = the number of rows in the dimension statement for B in the calling program

ke == the number of rows in the dimension statement for C' in the calling program It is assumed that ka > m, kb > m, ke > m, and that C has at least n columns.

The array C may begin in the same location as A or 8. If C begins in the same location as A thea 1 is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C’ begins in the same location as B then it is assumed that ke = kb. Otherwise, if C’ does net begin in the same location as A or B, then it is assumed that the storage area for C’ does not overlap with the storage areas for A and B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

Programmer. A. H. Morris.


<small>Original source: [View scanned PDF page 155](../scans/page_0155.png)</small>

<a id="topic-155-01"></a>
### Matrix Multiplication

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L36670`](../source_parts/nswc_part_04.f90#L4957) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L36692`](../source_parts/nswc_part_04.f90#L4979) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L36714`](../source_parts/nswc_part_04.f90#L5001) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [`L36736`](../source_parts/nswc_part_04.f90#L5023) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [`L36843`](../source_parts/nswc_part_04.f90#L5130) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [`L36950`](../source_parts/nswc_part_04.f90#L5237) |


The matrix product C -= AB may be computed by the subroutines MTMS, DMTMS, CMTMS cor MPROD, DMPROD, CMPROD. MTMS, DMTMS, and CMTMS can be used if the storage area for C does not overlap with the storage areas for A and 8. Otherwise, if the components of C are to be stored in the storage area for A or B, then MPROD, DMPROD, or CMPROD must be used.

```fortran
CALL MTMS(M, N, L, A, KA, B, KB, C, KC)
CALL DMTMS(M, N, L, A, KA, B, KB, C, KC)
CALL CMTMS(M, N, L, A, KA, B, KB, C, KC)
```

MTMS is used if A and B are real matrices and C a real array, DMTMS is used if A and B are double precision matrices and C’ a double precision array, and CMTMS is used if 4 and B are complex matrices and C’ a complex array.

A is a matrix having m rows and n columns, £ a matrix having n rows and £ columns, and C a 2-dimensional array. The routine computes the product AB and stores the results in C. The input arguments ka, kb, ke have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program

ke = the number of rows in the dimension statement for C in the calling program It is assumed that ka > m, kb > n, ke > m, and that C contains at least @ columns.

**Remark.** It is assumed that the storage area for C is separate from the storage areas for A

and B. Programmer. A. H. Morris.

```fortran
CALL MPROD(M, N, L, A, KA, B, KB, C, KC, ROW)
CALL DMPROD(M, N, L, A, KA, B, KB, C, KC, ROW)
CALL CMPROD(M, N, L, A, KA, B, KB, C, KC, ROW)
```

MPROD is used if A and B are real matrices and C and WK are real arrays, DMPROD is used if A and #% are double precision matrices and C and WK are double precision arrays, and CMPROD is used if A and B are complex matrices and C and WK are complex arrays.

A is a matrix having m rows and n columns, B a matrix having n rows and @ columns, and C a 2-dimensional array. The routine computes the product AB and stores the results in C. The input arguments ka, kb, kc have the following values:

ka == the number of rows in the dimension statement for A in the calling program

kb => the number of rows in the dimension statement for 8 in the calling program

ke :. the number of rows in the dimension statement for C in the calling program Ib is assumed that ka > m, kb > n, ke 2 m, and that C contains at least & columns.


<small>Original source: [View scanned PDF page 156](../scans/page_0156.png)</small>

WK is an array that serves as a temporary storage area. The matrix C may begin in the same location as A or B. If C begins in the same location as A, then it is assumed that ke = ka and that the dimension of WK. is equal to or greater than @. In this case, the result C’ will overwrite the input data A. Similarly, if C begins in the same location as B then if is assumed that ke =: kb and that the dimension of WK is equal to or greater than m. Otherwise, if C does not begin in the same location as A cr B, then it is assumed that the storage area for C does not overlap with the storage areas for A and B. In this case, the array WK is not referenced.

**Remark.** If C begins in the same location as A or B, then it is assumed that the storage areas for A and B are distinct storage areas.

**Programming.** MPROD employs the subroutines RLOC and YCHG, DMPROD employs

the subroutines DLOC and DYCHG, and CMPROD employs the subroutines CLOC and CYCHG. The routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 157](../scans/page_0157.png)</small>

<a id="topic-157-01"></a>
### Product Of A Packed Symmetric Matrix And A Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [`L37058`](../source_parts/nswc_part_04.f90#L5345) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [`L37085`](../source_parts/nswc_part_04.f90#L5372) |


Let A denote a packed symmetric matrix of order n and x a column vector of dimension vn where n > 1. Then the following subroutines are available for computing the product Az.

```fortran
CALL SVPRD(A, N, X, Y)
CALL DSVPRD(A, N, X, Y)
```

The argument y is an array of dimension n. SVPRD is called when A,z,y are real arrays and DSVPRD is called when A,z,y are double precision arrays. When either of these routines is called, Az is computed and stored in y.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 158](../scans/page_0158.png)</small>

<a id="topic-158-01"></a>
### Transpose Matrix Products

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L37112`](../source_parts/nswc_part_04.f90#L5399) |


If At denotes the transpose of A, then the matrix product C =: AtB can be computed by the following subroutine:

```fortran
CALL TMPROD(M, N, L, A, KA, B, KB, C, KC)
```

A is a real matrix having m rows and n columns, B a real matrix having m rows and @ columns, and C a real 2-dimensional array. TMPROD computes A‘B and stores the results in C’. The input arguments ka, kb, kc have the following values:

ka = the number cf rows in the dimension statement for A in the calling program

k5 =: the number of rows in the dimension statement for B in the calling program

kc = the number of rows in the dimension statement for C in the calling program Here it is assumed that ka > m, kb > m, ke > n, and that C contains at least & columns. Also it is assumed that the storage area for C does not overlap with the storage areas for A and B.

**Note.** All inner products >) a,,6,; are computed in double precision and the results stored k

in single precision.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 159](../scans/page_0159.png)</small>

<a id="topic-159-01"></a>
### Symmetric Matrix Products

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [`L37130`](../source_parts/nswc_part_04.f90#L5417) |


If A’ denotes the transpose of A, then the matrix product A&A can be computed and its packed form stored in the array B by the following subroutine:

```fortran
CALL SMPROD(M, N, A, KA, B)
```

A is a real m x n matrix and B a real array whose dimension is equal to or greater than n(n + 1)/2. SMPROD computes A‘A and stores its packed form in B. The input argument a has the following value:

ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > m.

**Note.** All inner products 5 4,:4,; are computed in double precision and the results stored k

in single precision.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 160](../scans/page_0160.png)</small>

<a id="topic-160-01"></a>
### Kronecker Product Of Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [`L37150`](../source_parts/nswc_part_04.f90#L5437) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [`L37179`](../source_parts/nswc_part_04.f90#L5466) |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [`L37208`](../source_parts/nswc_part_04.f90#L5495) |


If Ais anm xn matrix and Bak « @ matrix, then the Kronecker product A ® 8 is

defined by

A@B= Dod, aQm1B +: a)

From this definition we obtain:

(1) (Transpose Equality) (A @ B)' = At @ Bt.

(2) (A® B)@F= A@(B@ E) for any matrix EF.

(3) (A@ BY(C@ DL) = (AC) @(BD) iC is a matrix having n rows and D a matrix having £ rows.

If A and B are complex square matrices of orders m and k respectively, then from the Jordan

canonical forms of A and B the determinant equality det (A@ B) = (det A)* (det B)™ can

be verified. Moreover, if A and B are nonsingular then (A 2 B)~' =. A~* @ B™! from. (2).

The following subroutines are available for computing C = A B.

CALi KPRC D(A, ka, m,n, B, kb, k, ?,C, ke) CALL DKPROD(A, ka, m,n, B, kb, k, £,C, ke) CALL CKPROD(A, ka, m,n, B, kb, k:, €,C, ke)

It is assumed that A is an m X n matrix, B a k x @ matrix, and C' a 2-dimensional array. KPROD is used if A, B,C are real arrays, DKPROD its used if A, B,C are double precision arrays, and CKPROD is used if A, B,C’ are comp!ex arrays. When the routine is called, A ® B is computed and stored in C.

The arguments ka, kb, and ke have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program ke = the number of rows in the dimension statement for C in the calling program It is assumed that ka > m, kb > k, ke > mk, and that C contains at least né columns.

**Remark.** It is assumed that the array C does not overlap with «4 or B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 161](../scans/page_0161.png)</small>

<a id="topic-161-01"></a>
### Rank Of A Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [`L37237`](../source_parts/nswc_part_04.f90#L5524) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [`L37334`](../source_parts/nswc_part_04.f90#L5621) |


The following subroutines are available for obtaining lower and upper bounds for the rank of real matrix.

```fortran
CALL RNK(A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK)
CALL DRNK(A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK)
```

A and WK are real arrays and RERR and AERR real values if RNK is used. A and WK are double precision arrays and RERR and AERR double precision values if DRNK is used.

Ais anm Xn matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ke > m. A is destroyed by the routine.

RERR is an argument which specifies that relative accuracy of the data in A. If it is estimated that the elements in A are accurate to u significant digits then one may set RERR == 1074. It is required that RERR > 0. If RERR = 0 then it is assumed that, the elements in A are accurate to machine precision.

AERR is an argument which specifies the maximum absolute uncertainty of the data in A. For example, if it is estimated that the elements a,,; of A have the relative accuracy RERR except when |a,;;| < 107%°, then one may set AERR = 107°°. It is required that AERR > 0.

The arguments k and ko are variables. When RNK or DRNK is called, the rank of A is bounded from above and below using the tolerances RERR and AERR. The variable k is set to the upper bound and k, to the lower pound.

WK is an array of dimension 5- min{m,n} or larger, and 1WK an array of dimension m-+n or larger. WK and IWK are work spaces for the routines.

Remarks. Normally kp =: «, ia which case k is the rank of A. However, if ko 5“ « then it is recommended that the least squares routine HF TI2 or DHF T2 be used for obtaining the most appropriate value for che rank. When HFTI2 or DHF 12 is used, B may be selected to b. the m x m identity matrix, aud the size of the elements of the solution matrix X should be considered (in addition tu the values of the residual norms). Frequently, the lower bound ko will be found to be the most appropriate value for the rank.

**Programming.** RNK employs the subroutines ULILS, ULIUS, ISWAP, SSWAP, SAXPY, SSCAL and functions SDOT, SNRM®, [SMMAZX, SPMPAR, IPMPAR. DRNK employs the subroutines DULILS, DULIIUS, ISWAF, DSEWAP, DAXPY, DSCAL and functions DOOT, DNRM2, IDAMAX, DPMPAR, IPMPAR. KNK and DRNK were written by A. H. Morris, and O'ELS, UILUS, DULILS, PULINS, were written by T. Manteuffel (Los Alamos).

**Reference.** Manteuffel, U., An Interval Analysts Approach to Rank Determination


<small>Original source: [View scanned PDF page 162](../scans/page_0162.png)</small>

in Linear Least Squares Problems, Report SAND 80-0655, Sandia Laboratories, Albuquerque, New Mexico, 1980.


<small>Original source: [View scanned PDF page 163](../scans/page_0163.png)</small>

<a id="topic-163-01"></a>
### Inverting General Real Matrices And Solving General Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [`L37433`](../source_parts/nswc_part_04.f90#L5720) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [`L37646`](../source_parts/nswc_part_04.f90#L5933) |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [`L37998`](../source_parts/nswc_part_04.f90#L6285) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [`L38253`](../source_parts/nswc_part_04.f90#L6540) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [`L38297`](../source_parts/nswc_part_04.f90#L6584) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [`L39111`](../source_parts/nswc_part_04.f90#L7398) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [`L39155`](../source_parts/nswc_part_04.f90#L7442) |


The subroutines CROUT, KROUT, MSLV, MSLV1, NPIVOT, DMSLV, and DMSLV1 are available for inverting real matrices A and solving systems of real linear equations AX = B. CROUT, KROUT, MSLV, MSLV1, and NPIVOT solve single precision problems, and DMSLV and DMSLV1 solve double precision problems.

All the routines except NPIVOT are general-purpose, employing partial pivot Gauss elimination. NP{VOT can only occasionally be used since it uses Gauss-Jordan elimination with no pivot search. Normally CRO'/T and KROUT produce the same results, and M5LV and MSLV1 produce the same results. Since many of the calculations are performed in double precision in CROUT and KR DUT, these subroutines will be slower than MSLV and MSLV1, but they may be more accurate.

```fortran
CALL CROUT(MO, N, M, A, KA, B, KB, D, INDEX, TEMP)
```

A is areal matrix of order n where n > 1. If MO = 0 then the inverse of A is computed and stored in A. If MO #0 then the ‘verse is not computed.

The argument rm is a: integer. If m > 1 then B is a real matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in B. If m < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A un the calling program, and kb the number of rows in the dimension statement for B in the calling program. lf m<. 0 then the argument k6 is ignored.

D is a real variable. When CROUT is called, D is assigned the value det(A) where det(A) is the determinant of A. If D is found to have the value 0 then the routine immediately terminates.

INDICX is an array of dimension n ~ | or larger that is used by the routine for keeping track of the row interchanges that are made. If MO 4 0 then INDEX is ignored.

TEMP is a real array of dimension n or larger that is a work space for the routine. If MO / 0 then TEMP 13 ignored.

**Remarks.**

(1} KROUT should be used instead of CROU'P when the determinant 22 is not needed. Underflow or overflow in the calculation of 2) may cause CROU'T to terminate prematurely.

(2) ‘The matrix Ais destroyed.

21S


<small>Original source: [View scanned PDF page 164](../scans/page_0164.png)</small>

**Algorithm.** The Crout procedure is used. All inner products are computed in double precision and the results returned in single precision. Partial pivoting is performed.

**Programming.** CROUT calls the subroutine CROUTO. These routines were written by A. H. Morris.

```fortran
CALL KROUT(MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP)
```

A is a real matrix of order n where n > 1. If MO = 0 then the inverse of A is computed and stored in A. If MO # 0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a real matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in B. If m < O then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored.

[INDEX is an array of dimension n -- 1 or larger that is used by the routine for keeping track of the row interchanges that are made. If MO # 0 then INDEX is ignored.

TEMP is a real array of dimension n or larger that is a work space for the routine. If MO #0 then TEMP is ignored.

**Error Return.** [ERR is a variable that reports the status of the results. When the routine terminates JERR has one of the following values:

IERR = O The requested results were obtained.

IERR =: ~1 Either n, ka, or kb is incorrect. In this case, A and B have not been modified.

IERR = k& The kt column of A has been reduced to a column containing

only zeros.

When an error is detected, the routine immediately terminates. Remark. The matrix A is destroyed.

**Algorithm.** The CROUT procedure is used. All inner products are computed in double precision and the results returned in single precision, Partial pivoting is performed.

**Programming.** KROU'T calls the subroutine KROUTO. These routines were written by A. HL. Morris.

```fortran
CALL NPIVOT(N, M, A, KA, B, KB, D, IERR)
```

A is a real matrix of order n where n+ b When NPEVO’V is called the inverse of Ats

computed and stored my A,


<small>Original source: [View scanned PDF page 165](../scans/page_0165.png)</small>

The argument m is an integer. If m > 1 then B is a real matrix having n rows and m columns. In this case the matrix equation AX = 77 ia solved and the solution X is stored in 3. lfm <0 then there are no equations to be solved. In this case the argument B is ignored,

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program. If m <0 then kb is ignored.

D is a real variable. On input D must be assigned a value by the user. If the input value is 7, then when NPIVOT terminates D = rd where d is the determinant of A.

Error Return JERR is an integer variable. If inversion is successful then IERR is assigned the value 0. Otherwise, JERR = 1 if NPIVOT cannot invert the matrix.

**Algorithm.** The Gauss-Jordan procedure is used. However, no pivot searching is done. NPIVOT terminates (with IERR set to 1) whenever a zero pivot element is encountered.

**Remarks.** Since pivot search is frequently needed to invert a matrix, and since pivot search is normally required to obtain accurate results, NPIVOT should not be used except on those occasions when pivot search is known to be superfluous.

**Programmer.** A. H. Morris.

```fortran
CALL MSLV(MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK)
CALL DMSLV(MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK)
```

A is a matrix of order n where n > 1. If MO == 0 then the inverse of A is computed and stored in A. If MO # 0 then the inverse is not computed.

The argument rm is an integer. If m > 1 then B is a matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in 8. If m < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for 8 in the calling program. If m < 0 then the argument ké is ignored.

D is an array of dimension 2. When either routine 1s called the determinant det(A) of the matrix A is computed. If det{A) ~ d- 10* where 1 < |d| < 10 and k an integer, then d ig stored in (1) and the exponent & is stored in floating point form in D(2).

RCOND os a variable. When either routine is called, the routine makes an estimate c of the condition number of the matrix A (relative to the Ly norm), RCOOND ts assigned

the value L/e. IWK is an array of dimension nor larger that is used by the routines for ke. ping track


<small>Original source: [View scanned PDF page 166](../scans/page_0166.png)</small>

af the row interchanges that are made. WK is an array of dimension n or larger that. ig used as a work space.

**Remarks.**

(1) If MSLV is called then it is assumed that A and B are real matrices, D and WK real arrays, and RCOND a real variable. Otherwise, if DMSLV is called then it is assumed that A and B are double precision matrices, D and WK double precision arrays, and RCOND a double precision variable.

(2} RCOND satisfies 0 < RCOND < 1. If RCOND w 10~* then one can expect the results to have approximately k& fewer significant digits of accuracy than the elements of A. For example, if MSLV is used to invert a matrix in the 14 digit CDC sing!e precision arithmetic and RCOND = .4E~-3, then the computed coefficients of the inverse matrix should normally be accurate to about 11 digits. In general, RCOND characterizes how well or poorly conditioned the problem is. If RCOND #& 1 then one should expect the results to be almost as accurate as the original data A. However, if RCOND s 0 then one should expect the results to be nonsense.

(3) The matrix A is destroyed.

**Error Return.** JERR is an integer variable. If RCOND is sufficiently large so that 1+ RCOND > 1, then IERR is set to 0 and the problem is solved. Otherwise, if 14+-RCOND = 1 then {ERR is set to 1 and the routine terminates. In this case, A will have been destroyed but B will not have been modified. Also the determinant will not have been computed.

**Algorithm.** The partial pivot Gauss elimination procedure is used.

**Programming.** MSLV and DMSLV are driver routines for the LINPACK subroutines SGECO, SGEFA, SGESL, SGEDI and DGECO, DGEFA, DGESL, DGEDI. The subroutines were coded by Cleve Moler (University of New Mexico). The subroutines employ the vector routines SSWAP, SDOT, SSCAL, SAXPY, SASUM, iSAMAX and DSWAP, DDOT, DSCAL, DAXPY, DASUM, IDAMAX.

**References.**

(1) Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart. G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.

(2) Cline, A. K., Moler, C. B., Stewart, G. W., and Wilkinson, J. H., “An Estimate for the Condition Number of « Matrix,” SIAM Journal of Numerical Analysis 16 (1979), pp. 858-375.

```fortran
CALL MSLV1(MO, N, M, A, KA, B, KB, IERR, IPVT, WK)
CALL DMSLV1(MO, N, M, A, KA, B, KB, IERR, IPVT, WK)
```

Ais a matrix of order n where n > 1. If MO = 0 then the inverse of A 1s computed and stored in A. If MO 7 O then the inverse is not computed,

The argument m is an integer. [fw > i then 8 is a matrix having n rows and m columns. In this case the matrix equation AN Bois solved and the solution is stored in B. If m < U then there are no equations to be solved. In this case the


<small>Original source: [View scanned PDF page 167](../scans/page_0167.png)</small>

argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored,

IWK is an array of dimension m or larger that is used by the routines for keeping track of the row interchanges that are made. WK is an array of dimension n o¢ larger that is used for a work space. If MO 3 0 then WK is ignored.

Remarks.

(1) If MSLV1 is called then it is assumed that A and B are real matrices and WK i. real array. Otherwise, if DMSLV1 is called then it is assumed that A and B are double precision matrices and WK a double precision array.

(2) The matrix A is destroyed.

**Error Return.** TERR is a variable that reports the status of the results. When the routine terminates JERR has one of the following values:

TERR = 0 The requested results were obtained.

IERR = --1 Either n, ka, or kb is incorrect. In this case, A and B have not been modified.

IERR = &k The k*® column of A has been reduced to a column containing only zeros,

**Algorithm.** The partial pivot Gauss elimination procedure is used.

**Programming.** MSLV1 and DMSLV | are driver routines for the LINPACK subroutines SGEFA, SGESL, SGEDI and DGEFA, DGESL, DGEDI. The subroutines ‘vere coded by Cleve Moler (University of New Mexico). The subroutines employ the vector routines SSWAP, SDOT, SS- CAL, SAXPY, SASUM, ISAMAX and DSWAP, DDOT, DSCAL, DAXPY, DASUM, IDAMAX.

**References.**

(1) Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.

(2) Cline, A. K., Moler, C. B., Stewart, G W., and Wilkinson, J. H., “An Estimate for the Condition Number of a Matrix,” SIAM Journal of Numerical A: alysts 16 (1979), pp. 368-375.


<small>Original source: [View scanned PDF page 168](../scans/page_0168.png)</small>

<a id="topic-168-01"></a>
### Solution of Real Equations with Iterative Improvement

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [`L38338`](../source_parts/nswc_part_04.f90#L6625) |


Given a real n <1 matrix A and column vector 6. The following, subroutine is available for solving the equation Ax = 4. Iterative improvement 's performed to compute the solution x to machine accuracy,

```fortran
CALL SLVMP(MO, N, A, KA, B, X, WK, IWK, IERR)
```

MO is an input argument. which specifies if SLVMP is being called for ihe first time. On an initial call, MO = 0 and we have the following setup:

A is a 2-dimensional real array of dimension «a X n containing the matrix A, 6 « real vector of dimension », and X a real array of dimension n. When SLVMF is called, Ar = & is solved and the solution stored in X. A and $ are not modified by the routine.

WK is a real array of dimension n*+n or larger, and [WK an integer array of dimension n or larger. These arrays are for internal use by the routine. On un initial call to SLV MP, «1 LU decomposition is obtained for A and stored in WK and IWK. Then the equation Ax = 6 1s solved.

IND is an integer variable that reports the status of the results. On an initial call to SLVMP, when the routine terminates IND has one of the following values:

IND = 0 The solution X was obtained to machine accuracy.

IND = 1 X was obtained, but not to machine accuracy.

IND = —k The k** column of A was reduced to a column containing only zeros.

When IND = —k&, no solution is obtained.

After an initial call to SLVMP, if IND == 0 or 1 on output, then the routine may be called to solve a new set of equations Az == 6 without having to redecompose the matrix A. In this case, the input argument MO may be set to any nonzero value. When MO #0 it is assumed that only 6 has been modified. The routine employs the LU decomposition obtained on the initial call to SLYMP to solve the new set of equations Ar = 6. On output X will contain the solution to the new set uf equations. As before, A and b are not modified by the routine.

{f SLVMP is recalled with MO 4 0, then when the routine terminates IND has one of the following values:

IND = 0 The solution X was obtained to machine accuracy,

IND = 1 X was obtained, but not to machine accuracy. Programming. SLY MP calls the subroutine LUIMP. These routines were written by A. H Morris. The subroutines MCOPY, SGEPA, SGESL, SSCAL, SAXPY and functions SUM. PAR, SDOT, ISAMAX are also employed.


<small>Original source: [View scanned PDF page 169](../scans/page_0169.png)</small>

<a id="topic-169-01"></a>
### Solution Of Almost Block Diagonal Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [`L39831`](../source_parts/nswc_part_04.f90#L8118) |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [`L40474`](../source_parts/nswc_part_04.f90#L8761) |


Consider a system Az == 6 of linear equations where A is ann x n matrix having the block structure

Here it is assumed that A, is an r; x c¢; matrix ford = 1,...,m, and that A; and Ajai may m

have 6; >> 9 columns in common for ¢ < m, Thus SO rp n and block A, begins in column al

pany

», (cx ~ Oe) -+ L fer ¢ > 2. It is also assumed that three successive blacks Ay-1, Aj, Assi

k=

do not have columns in common, Thus 65.1 + & < ec; ford = 2, ...53 ~ 1. Ifm > 2 then

the following subroutines are available for solving Az = 6.

```fortran
CALL ARCECO(N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG)
```

mn Sis an array of dimension )% r,¢; or larger. On input S contains the blocks Ay, ..-;Am dak of the matrix A. The blocks are stored in sequence. A, is stored in the first rc, locations of S, Ag is stored in the next recy locations, etc. For each Ax, the columns of A; are stored

in sequence in S.

**Example.**

Pasy 12 43 0 G

2 0 0 [aso gs a4 7 G | ‘

aa Qz2 423 |

249 Gas esa |

0 0 Oo fa then noc 5

ya, 822, 0)3,423, 232,442, 433, %43, 134,444, Ass.

» mm 9 8, by = 2, and 62 = QO. Also, S is an array containing the data 11,421,

M'TR is an integer matrix of dimension 3 x m containing the block information of the matrix A:

MPRA1, 8) ss ry (f— 1, ...,m) MTR(Z,1) (t= 7, ...,m) MTR, £} & (g=-1,...,- 2)

For convenience, the routine sets MTR(3, m) . 0.

y

On

Perens


<small>Original source: [View scanned PDF page 170](../scans/page_0170.png)</small>

X is an array of dimension n or larger. When ARCECO is called, A is decomposed and then the equations Az = 6 are solved. The decomposition of A is stored in S, overwriting the initial input data A, and the solution 2 is stored in X. The vector 6 is destroyed by the routine.

IWK is an array of dimension n or larger for internal use by the routine. ‘The pivot indices involved in the decomposition of A are stored in IWK.

```text
IND is a variable that reports the status of the results. When ARCECO terminates,
IND has one of the following values:
```

IND = 0 The system of equations was solved.

IND = 1 (Input Error) Either n,m, or MTR is incorrect, or three successive blocks A,_1, Ay, Ay41 of A have columns in common.

IND =~—1 A is a singular matrix. The equations cannot be solved.

Usage. After a call to ARCECO, if IND = 0 on output then the subroutine ARCESI. (see below) may be called to solve a new set of equations Az = 6 without having to redecompose the matrix A. ARCESL employs the decomposition of A obtained by ARCECO.

**Algorithm.** A modification of the alternate row and column elimination procedure by Varah is used.

**Programming.** ARCECO employs the routines ARCEDC, ARCEPR, ARCEPC, ARCESL, ARCEFS, ARCEFM, ARCEFE, ARCEBS, ARCEBM, and ARCEBE. These routines were developed by J. C. Diaz (Mobil Research and Development Corp., Farmers Branch, Texas), G. Fairweather (University of Kentucky), and P. Keast (University of Toronto).

**Reference.** Diaz, J. C., Fairweather, G., and Keast, P., “FORTRAN Packages for Solving Certain Almost Block Diagonal Linear Systems by Modified Alternate Row and Column Elimination,” ACM Trane. Math Software 9 (1983), pp. 358-375.

```fortran
CALL ARCESL(ARRAY, MTRSTR, NMBLKS, PIVOT, B, X)
```

The argument m is the number of blocks A,,...,Am in the matrix A. ARCESL may be used only when IND = 0 on output from ARCECO. In this case, S contains the decomposition of A obtained by ARCECO and I5VK contains the pivot indices of the decomposition. The argument 6 is a vector of dimension n, and X an array of dimension nor larger. When ARCESL is called, the equations Az = 6 are solved and the solution stored in X. The vector 6 is destroyed by the routine.

**Programming.** ARCESL calls the subroutines ARCEFS, ARCEFM, ARCEFE, ARCEBS, ARCEBM, and ARCEBE. These routines were developed by J. ©. Diaz (Mobil Research and Development Corp.,Farmers Branch, Texas), G. Fairweather (University of Kentucky), and P. Keast (University of Tc onto).


<small>Original source: [View scanned PDF page 171](../scans/page_0171.png)</small>

<a id="topic-171-01"></a>
### Solution Of Almost Block Tridiagonal Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [`L40873`](../source_parts/nswc_part_04.f90#L9160) |


Consider a system J7'r =: 6 of linear equations where 7’ is a square matrix having the block structure

Ay By Ci Cy Ag By @) C's Ag Bz

Cn-1 Aner Bros B,, Cn Ay,

Here it is assumed that Ay, Be,Ce (k = 1,...,n) are mxm matrices, and that 6 is a column vector of dimension mn. If 2 > 4 the: he following subroutine is available for solving Tz = d.

```fortran
CALL BTSLV(MO, M, N, A, B, C, X, IP, IERR)
```

MO is an input argument which specifies if BT'SLV is being called for the first time. On an initial call, MO = 0 and we have the following setup:

A, B, C are 3- dimensional arrays of dimension m x mx n where the (t,7)-th elements of the matrices Aj, 3x,Cx are stored in A(t,j,k), B(t, j,k), C(i,9,k) for k = 1,...,n. A, B,C are modified by the routine.

X is an array of dimension mn or larger. On input, the vector 6 is stored in X. When BTSLV is called, 1! a solution x is obtained for T’z = 6 then the solution is stored in X.

IP is an array of dimension mn or larger that is used by the routine fv listing the row interchanges that are made.

On an initial call to the routine, a block IU decomposition is performed on T, the results of which are stored in A,B,C. This decomposition involves row interchanges only within the diagonal blocks Ax; i.e., no row interchanges are performed between rows of different blocks Ay and Ag. Thus it may occur that the decomposition of a nonsingular matrix T cannot be completed. IND is a variable that reports the status of the results. When BTSLV terminates, IND has one of the following values:

IND = 0 T was decomposed and the equations Tx = 6 solved.

IND =~1 (Input Error) Either m < Lorn < 4.

IND = k The decomposition process failed in the &'* diagonal block. The

routine cannot solve the equations in their present form.

After an initial call to BTSLV, if IND -: 0 then the routine may be recalled with MO # 0 and a new 6. When MO ¥ 0, then it is assumed that A,B,C, and IP have not. beer modified and that X contains the new 6. The routine retrieves from A,B,C, and IP the block decomposition that was obtained on the initial cali io BTSLV, and solves the nev


<small>Original source: [View scanned PDF page 172](../scans/page_0172.png)</small>

system of equations Tx =: 6. The solution is stored in X. In this case, IND 1s not referenced by the routine.

Programming. BTSLV employs the subroutines DECBT, SOLBT, DEC, and SOL. These subroutines were written by Alan C. Hindmarsh (Lawrence Livermore Laboratory).

**Reference.** Hindmarsh, A. C., Solution of Block-Tridiagonal Systems of Linear Algebraic Equations, Report UCID-30150, Lawrence Livermore Laboratory, 1977.


<small>Original source: [View scanned PDF page 173](../scans/page_0173.png)</small>

<a id="topic-173-01"></a>
### Inverting Symmetric Real Matrices And Solving Symmetric Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [`L41082`](../source_parts/nswc_part_04.f90#L9369) |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [`L42183`](../source_parts/nswc_part_04.f90#L10470) |


‘The subroutines SMSLV and DSMSLV are available for inverting symmetric real matrices A and solving systems of real linear equations AX = B. SMSLV handles single precision problems and DSMSLV handles double precision problems. it is assumed that the matrix A is in packed form. [f the inverse of A is computed, then the verse is a symmetric matrix which will be stored in packed form.

**Note.** All eigenvalues of a real symmetric matrix A are real. The inertia of A is the ordered triple (x,v,¢) where w ia the number of positive eigenvalues of A, v the number of negative eigenvalues of A, and ¢ the number of zero eigenvalues of A. Thus, if n is the order of A then w-+u+¢ =n. Also A is positive definite (positive semi-definite, negative definite, negative semi-definite) if m =n (v=0,v=n,x =O).

```fortran
CALL SMSLV(MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK)
CALL DSMSLV(MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK)
```

A is an array of dimension n(n + 1)/2 containing the elements of a packed n x n symmetric matrix where n > 1. If MO = 0 then the inverse of A is computed and stored in A in packed form. If MO # 0 then the inverse of A is not computed.

The argument m is an integer. If m > 1 then B is a matrix having n rows and m columns. In this case AX = B is solved and the solution X is stored in HB. If rn < © then there are no equations to be solved. In this case B is ignored.

The argument kb is the number cf rows in the dimension statement, for B in the calling program. If m < 0 i ‘en ké is ignored.

1 is an array of dimension 2. When either routine is called the determinant det(A) of the matrix A is computed. If det(A) = d- 10* where 1 < |d| < 10 and & an integer, then d is stored in D(1) and the exponent & is stored in floating point form in (2),

RCOND is a variable. When either routine is called, the routine makes an estimate ¢ of the condition number ef the matrix A (relative to the Ly norm). RCOND is assigned the value I/c.

INER'E is an integer array of dimension $. When either routine is called she inertia of the matrix Ais computed. INERT(L) is set to ti number of positive eigenvalues of A, INERT (2) is set to the number of negative eigenvalues and INFET(3) is set to the number

af vere: etgenvalse

IPV Po os as integer array of dimension reoor urge: tats used by the routines fir

keeping track of she row and column interchanges t) at are vde WK te array of dimension

root baw: that is used as a work space.


<small>Original source: [View scanned PDF page 174](../scans/page_0174.png)</small>

**Remarks.**

(1) If SMSLV is called then it is assumed that A and B are real matrices, D and WK are real arrays, and RCOND i» a real variable. Otherwise, if DSMSLV is called then it is assumed that A and 8 are double precision matrices, D and WK are double precision arrays, and RCOND is a double precision variable.

(2) RCOND satisfies 0 < RCOND < 1. If RCOND ® 10~* then one can expect the results to have approximately k fewer significant digits of accuracy than the elements of A. For example, if SMSLV is used to invert a matrix in the 14 digit CDC single precision arithmetic and RCOND -- .4E—3, then the computed coefficients of the inverse matrix should normally be accurate to about 11 digits. In general, RCOND characterizes how well or poorly conditioned the problem is. If RCOND #& 1 then one should expect the results to be almost as accurate as the original data A. However, if RCOND ~ 0 then ne should expect the results to be nonsense.

(3) ‘The data in A is destroyed.

Error Return, [IERR is an integer variable. If RCOND is sufficiently large so that 1 + RCOND > 1, then [ERR is set to 0 and the problem is solved. Otherwise, if 1 +- RCOND == 1 then JERR is set, to 1 and the routine terminates. In this case, A will have been destroyed but B will not have been modified. Also the determinant and inertia will not have been computed.

**Algorithm.** Toe diagonal pivoting factorization procedure is used. Partial pivoting is employed.

**Precision.** SMSLV and the more general routine MSLV have approximately the same accuracy, and DSMSLV and DMSLV have approximately the same accuracy.

Efficiency. iive: though SMSLV performs approximately half the number of multiplications and divisions as MSLV, normally one can expect SMSLV to take about 70-80% of the time required by MSLV. However, for sparse matrices SMSLV may be 20-30% slower than MSLYV. Similar comments hold for DSMSLV and DMSLV.

**Programming.** OMSLV and DSMSLV are driver routines for the LINPACK subroutines SSPCO,SSPFA,SSPSL, SsPDL and DSPCO, DSPFA, DSPSL, DSPDI. SSPCO and DS2CO were written by Cleve Moler (University of New Mexico). The remaining LINPACK subroutines were written by James Kuanch (University of California, San Diego}. The subroutines employ the vector routines SCOPY, SSWAP, SDOT, SSCAL, SAXPY, SASUM, ISAMAX and DSWAP, DDO'T, DSC AL, DAXPY, DASUM, IDAMAX.

**References.**

(1) Bureh, Jo Ro and Parlett, BON “Direct Methods for Solving Symmetric Indefinite Systems of Liner Equations,” SIAM J. Numerical Analysis 8 (1971), pp. @80 655,

f2) Bunch, JO Ro, CAnatysis of the Diagonal Pivefttie Method,” STAAT J. Numerical Analysis B CIS UE) pp. 656 GkO.


<small>Original source: [View scanned PDF page 175](../scans/page_0175.png)</small>

(3) Bunch, J. R., Kaufman, L., and Parlett, B.N., “Decomposition of a Symmetric Matrix,” Numerische Mathematik 27 (1975), pp. 95-109.

(4) Bunch, J., and Kaufman, L., “Some Stable Methods for Calculating Inertia and Solving Symmetric Linear Systems,” Math. Comp. 31 (1977), pp. 163-179.

(5) Cline, A. K., Moler, C. B., Stewart, G. W , and Wilkinson, J. H., “An Estimate for the Condition Number of a Matrix,” SIAM Numerical Analysis 16 (1979), pp. 368-375.

(6) Dongarra, J. J., Bunch, J. R., Moler, ©. B., and Stewart, G. W., LINPACK Vaers’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.


<small>Original source: [View scanned PDF page 176](../scans/page_0176.png)</small>

<a id="topic-176-01"></a>
### Inverting Positive Definite Symmetric Matrices And Solving Positive Definite Symmetric Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [`L43284`](../source_parts/nswc_part_05.f90#L1061) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [`L43630`](../source_parts/nswc_part_05.f90#L1407) |


The subroutines PCHOL and DPCHOL are available for inverting positive definite symmetric real matrices A and solving systems of real linear equations AX = B. PCHOL handles single precision problems and DPCHOL handles double precision problems. It is assumed that the matrix A is in packed form. If the inverse of A is computed then the inverse is a symmetric matrix which will be stored in packed form.

```fortran
CALL PCHOL(MO, N, M, A, B, KB, IERR)
CALL DPCHOL(MO, N, M, A, B, KB, IERR)
```

A is an array of dimension n(n + 1)/2 or larger containing the elements of a packed n Xn positive definite symmetric matrix where n > 1. If MO = 0 then the inverse of A is computed and stored in A in packed form. If MO # 0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a matrix having n rows and m columns. In this case AX = B is solved and the solution X is stored in B. If m < 0 then there are no equations to be solved. In this case B is ignored.

The argument kb is the number of rows in the dimension statement for B in the calling program. If m < 0 then kb is ignored.

**Remarks.**

(1) If PCHOL is called then it is assumed that A and 8 are real arrays, and if DPCHOL is called then it is assumed that A and B are double precision arrays.

(2) Te data in A is destroyed.

**Error Return.** [ERR is an integer variable. If A is positive definite then IERR is set to 0 and the problem is solved. Otherwise, IERE = & if the leading k x k submatrix of A is not positive definite.

**Algorithm.** The Cholesky procedure is used.

**Precision.** The results obtained by PCUOL and DPCHOL are occasionally less accurate (up to a significant digit) than the results obtained by SMSLV and DSMSLV.

Programming, PCHOL and DPCHOL are driver routines for the LINPACK subroutines SPPFA,SPPSE, SPPD} and DPPPA, DPPSL, DPPDI. These subroutines were written by Cleve Moler (University of New Mexico). ‘The functions SDO'T, DDOT and subroutines SAXPY, SSCAL, DAXPY

DSCAL are also used.

Y

Reference. Dongarra, J. J. Bunch, 3. Ro, Moler, (Bo, and Stewart, G. Wo, LIN PACK

Y

Us re’ Gourde, Society for Industrial and Applied Mathematics, Philadelphia, 1979


<small>Original source: [View scanned PDF page 177](../scans/page_0177.png)</small>

<a id="topic-177-01"></a>
### Solution Of Toeplitz Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [`L43976`](../source_parts/nswc_part_05.f90#L1753) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [`L44069`](../source_parts/nswc_part_05.f90#L1846) |


Ann xn Toeplitz matrix is a matrix of the form

ao a_+s a4 eee) Gong

ay ag a_y see Ain42

ag ay ao cee Gents Qn-1 Gn-2 An-g ... agp /

For convenience, we denote this matrix by A, forn > 1. If A, is a real matrix where ap 4 0 and 6 is a real column vector, then the subroutines TOPLX and DTOPLX are available for solving the system of equations A,z = 6. TOPLX is a single precision routine and DTOPLX a double precision routine.

```fortran
CALL TOPLX(A, B, X, N, G, H, IERR)
CALL DTOPLX(A, B, X, N, G, H, IERR)
```

TOPLX is used if A,b,z,G, H are real arrays, and DTOPLX is used if 4,b,2,G, H are double precision arrays.

A is an array of dimension 2n-1 or larger containing the coefficients A(j) =a,;_p (j= 1, ...,2n — 1) of the matrix A,. The argument 2 is an array of dimension n or larger, and TERR is an integer variable. When the routine is called, if A,z = 6 is solved then IERR is set to 0 and the solution is stored in x. A and 6b are not modified by the routine.

G and H are arrays of dimension n or larger that are work spaces for the routine. Error Return. TERR = i if the equations cannot be solved by the routine.

**Remarks.** The Levinson bordering procedure is used. This procedure is inductive, beginning with the solution 2, = 6;/ay of the equation agz, = by. Given a solution for a ee = b (# = 1,...,N) where N <n, then a solution for NM Ata, jtp = bh (r-

1, ...,N 41) is obtained where £1, ...,2y 4. is computed from z,,...,2y. This procedure fails when some submatrix Ay is singular (e.g, when eo -: 0). Also, the procedure may yield poor results when some Aw is exceedingly ill-conditioned. In such situations one must use a more general equation solver. In TOPELX and D'TOPLX 4(n 1)? floating additions and 4n(n 1) integer/floating multiplications an! divisions are used when n> 2. Consequently, these routines are considerably more efficient than general equation solvers such as

KROUT and ISMSLYV, but more restrictive and frequently less accurate.

**Programming.** TOPLX and DTOPLX are modifications by A. H. Morris of the subroutine TOEPLZ, written by George kybticki.

**Reference.** Press, Wo H., Piannecy, bP, Teukolsky, S. A.) and Vetterling, Wo Do, Nt

omericul Reetpes: The Art of Sctentaf>> Computing, Cambridge University Press, LOa6

po. 47 2.


<small>Original source: [View scanned PDF page 178](../scans/page_0178.png)</small>

<a id="topic-178-01"></a>
### Inverting General Complex Matrices And Solving General Systems Of Complex Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [`L44162`](../source_parts/nswc_part_05.f90#L1939) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [`L44206`](../source_parts/nswc_part_05.f90#L1983) |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [`L44996`](../source_parts/nswc_part_05.f90#L2773) |


The subroutines CMSLV, CMSLV1, and DCMSLV are available for inverting complex matrices and solving systems of complex linear equations. CMSLV and CMSLV1 solve single precision problems and DCMSLV solves double precision problems.

```fortran
CALL CMSLV(MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK)
```

A is a complex matrix of order n where n > 1. If MO = 0 then the inverse of A is computed and stored in A. If MO #0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a complex matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in EB. If m < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and the argument kb is the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored.

D is a complex array of dimension 2. When CMSLV is called the determinant det(A) of the matrix A is computed. If det(A) = d-10* where 1 < |Re(d)| + |!m(d)] < 10 and k an integer, then d is stored in D(1) and the exponent k is stored ax a complex number in D2).

RCOND is a real variable’ When CMSLV is called, the routine makes an estimate eof the condition number of the matrix A (relative to the modified L, norm where each absolute value |z| is replaced with |Re(z)] } [Im(z)]). RCOND is assigned the value L/c.

IPV'T is an integer array of dimension n or larger that is used by the routine for keeping track of the row interchanges that are made. WK is a complex array of dimension mn or

larger that is used as a work space.

**Remarks.**

(1) RCOND satisfies 0+ ROOND = 1 IF RCOND s& LO * then one can expect the results to have approximately & fewer significant digits of accuracy than the elements of 4 Por example, if CMSLV is used to invert a matrix in the bf digit CDC single precision arithmetic and ROCONDD 48 3) then the computed coefficients of the inverse matrix should normally be accurate to about EL digits. In general, ROOND characterizes tow well or poorly conditioned the problem is, I RCONDP ss b then one shouted expect the results to be almost as accurate as the original data cA However, af ROONE) oO then one should expect Che results to be nonsense

(2) ‘The matrix Ais always destroyed

**Error Return.** UEKR is an integer variable If RCOND) is sufficiently Large se that |


<small>Original source: [View scanned PDF page 179](../scans/page_0179.png)</small>

RCOND > 1, then IERR is set to 0 and the problem is solved. Otherwise, if 1-+RCOND = 1 then IERR is set to 1 and the routine terminates. In this case, A will have been destroyed but B will not have been modified. Also the determinant will not have been computed.

Algorithm. The partial pivot Gauss elimination procedure is used. The pivots ax; are selected so that |Re(a,,)! + |{m(a,,)| = max {jRe(a,,)| + |Im(a,,)| if = 9, ...,n}.

**Programming.** CMSLV calls the LINPACK subroutines CGECO, CGEFA, CGESL, and CGEDI. These subroutines were written by Cleve Moler (University of New Mexico). The subroutines CSWAP, CSCAL, CSSCAL, CAXPY and functions CDOTC, SCASUM, ICA- MAX are also used.

**References.**

(1) Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.

(2) Cline, A. K., Moler, C. B., Stewart, G. W., and Wilkinson, J. H., “An Estimate for the Condition Number of a Matrix,” SIAM Journal of Numerical Analysis 16 (1979), pp. 368-375.

```fortran
CALL CMSLV1(MO, N, M, A, KA, B, KB, IERR, IPVT, WK)
```

A is a complex matrix of order n where n > 1. If MO = 0 then the inverse of A 1s computed and stored in A. If MO + 0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a complex matrix having n rows aud m columns. In this case the matrix equation AX = B is solved and the solution X is stored in B. If n < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and the argument kb is the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored.

IPVT is an integer array of dimension n or larger that is used by the routines for keeping track of the row interchanges that are made.

WK is a complex array of dimension n or larger that ts a work space for the routine.

If MO 4 O then WK is ignored.

**Error Return.** JERR ts @ variable that reports the status of the results. When CMSLV1 terminates HERR has one of the following values: TERR O The requested results were obtained. Tok lo Mither n,ka, or Ab is incorrect. tn this case, A and #3 have not been modified, IERR ok The AM column of A has been reduced to a column containing

zeros. ‘The requested results cannot be obtained,


<small>Original source: [View scanned PDF page 180](../scans/page_0180.png)</small>

**Remarks.**

```text
(1) The matrix A is destroyed.
(2) CMSLY and CMSLVI produce the same resulis for X and the inverse of A.
```

**Algorithm.** The partial pivot Gauss elimination procedure is used. The pivots a,, are selected so that |Re(a,,)| + |Im(a,;)/ = max {|Re(a,,)| + |Im(a,,;)[:# = 3, ...,n}.

**Programming.** CMSLV1 calls the LINPACK subroutines CGEFA, CGESL, and CGEDI. These subroutines were written by Cleve Moler (University of New Mexico). The subroutines CSWAP, CSCAL, CAXPY and functions CDOTC, ICAMAX are also used.

**Reference.** Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, SIAM, 1979.

```fortran
CALL DCMSLV(MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK)
```

AR and AI are double precision matrices of order n > 1. AR and Al are the real and imaginary parts of the complex matrix A whose inverse is to be computed or for which AX = B is to be solved. If MO = 0 then the inverse of the complex matrix is computed and the results stored in AR and AI. If MO #0 then the inverse is not computed.

The argument m is an integer. If m > 1 then BR and BI are double precision matrices having m rows and m columns. In this case, BR and BI are the real and imaginary parts of the complex matrix B for which AX = B is to be solved. When DCMSLV is called, the real and imaginary parts of the solution X are computed and stored in BR and BI. If m < 0 then there are no equations to be solved. In this case BR and BI are ignored.

The argument ka is the number of rows in the dimension statements for AR and AI in the calling program, and the argument kb is the number of rows in the dimension statements for BR and BI in the calling program. If m <0 then the argument kb is ignored.

IPVT is an integer array of dimension n or larger that is used by the routine for keeping track of the row interchanges that are made.

WK is a double precision array of dimension 2n or larger that is a work space for the routine. If MO / 0 then WE is ignored,

**Error Return.** TERR is a variable that reports the status of the results. Wien, DCMSLV terminates TERR has one of the following values: IERR O The requested results were obtained. IERR { Either n, ka, or kb is incorrect. In this case, AR, Al, BR, BE have not been modified [ERR k The kf columns of AR and Al have been reduced to columns

containing zeros, The requested results were not obtained

**Remark.** The matrices AR and Al are destroyed.


<small>Original source: [View scanned PDF page 181](../scans/page_0181.png)</small>

**Algorithm.** The partial pivot, Gauss elimination procedure is used. The pivots A,, are selected so that |Re(a,,)| + {Im(a,;)| — max {/Re(a,;)| -+ [Im(asy)| if = 9, ...,7)-

**Programming.** DCMSLV calls the subroutines DCFACT, DCSOL, and DCMINV. These routines were written by A. H. Morris. The functions CDIVity and DPMPAR are also used.


<small>Original source: [View scanned PDF page 182](../scans/page_0182.png)</small>

<a id="topic-182-01"></a>
### Solution Of Complex Equations With Iterative Improvement

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [`L44248`](../source_parts/nswc_part_05.f90#L2025) |


Given a complex n x n matrix A and a complex column vector 5. The following routine is available for solving the equation Aa == b. Iterative improvement is performed to compute the solution x to machine accuracy.

```fortran
CALL CSLVMP/MO,,, A, ka, 6, X,WK,IWK,IND)
```

MO is an input argument which specifies if CSLVMP is being called for the first time. On an initial call, MO = O and we have the following setup:

A is a 2-dimensional complex array of dimension ka x n containing the matrix A, ba complex vector of dimension n, and X a complex array of dimension n. When CSLVMP is called, Ax = 6 is solved and the solution stored in X. A and 6 are not modified by the routine.

WK is a complex array of dimension n? + n or larger, and [WK an integer array of dimension n or larger. These arrays are for internal use by the routine. On an initial call to CSLVMP, an LU decomposition is obtained for A and stored in WK and IWK. Then the equation Az = b is solved.

IND is an integer variable that reports the status of the results. On an initial call to CSLVMP, when the routine terminates ND has one of the following values:

```text
IND = 0 The solution X was obtained to machine accuracy.
IND = 1 X was obtained, but not to machine accuracy.
IND =~k The k‘* columi of A was reduced to a column containing only
```

zeros. In this case no solution can be obtained.

After an initial call to CSLVMP, if IND = O or | on output, then the routine may be called to solve a new set of equations Az 6 without having to redecompose the matrix A. In this case, the input argument MO may be set to any nonzero value. When MO / 0 tis assumed that only 6 has been modified. The routine employs the LU decomposition obtained on the initial call to CSLVMP to solve the new set of equations At = 6 On output X will contain the solution to the new set ef equations. As before, A and 6 are iot modified by the routine.

If CSLVMP is recalled with MO / 0, then when the routine terminates IND has one of the following values:

IND O ‘The solution No was obtained to machine accuracy,

IND 1 Xo was obtained, bat not to machine accuracy,

Programming CSLV MIP calls the subroutine CLUIME. ('These routines were written hy AOH. Morna The subroutines CMCOPY, CGOEPA CORSE, CsCAL, CAXPY aad fur trong SUMPAR, COOVYPO) TOAMAN are also employed


<small>Original source: [View scanned PDF page 183](../scans/page_0183.png)</small>

<a id="topic-183-01"></a>
### Singular Value Decomposition Of A Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [`L45360`](../source_parts/nswc_part_05.f90#L3137) |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [`L45912`](../source_parts/nswc_part_05.f90#L3689) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [`L46464`](../source_parts/nswc_part_05.f90#L4241) |


If 4 is a complex m x n matrix then there exists an m x m unitary matrix U and an n Xn unitary matrix V such that D = U* AV is a diagonal matrix?. Let di,...,d, be the diagonal elements of D where & = min{m,n}. Then U and V can be selected so that the diagonal elements are real numbers and d,; > dz > ++: > dy > 0. The nonnegative diagonal elements d@,; are unique, and if A is a real matrix then U and V can be chosen to be real orthogonal matrices. The decomposition D = U* AV is called the singular value decomposition of A. The elements dy, ...,d, are the singular values of A, the columns of U are left singular vectors, and the columns of V are right stnguédar vectors.

**Remark.** For m > n, D = (2) where Dy = diag(di,...,dn). Consequently, if U is

partitioned into U = (U,,U2) where U; has n columns, then it follows that A = UDV* = U,;D,V"*. The decomposition A = U;D,V" is frequently also called the singular value decomposition, and in many applications it suffices.

The following subroutines are available for finding the singular value decomposition D = U* AV of a matrix A.

CALI. SSVDC(A, ka, m,n, D, EU, ku, V, kv, WORK ,JOB,INFO) CALL DSVDC(A, ka, m,n, D, E,U, ku, V, ku, WORK,JOB,INFO) CALL CSVDC(A,ka,m,n, D, E,U, ku, V, kv, WORK,JOB,INFO)

A is a 2-dimensional array of dimension ka « n containing the m x n matrix whose singular value decomposition is to be computed. D is an array of dimension min{m + 1, n}. When any of the routines is called, the singular values of A are computed and stored in descending order of magnitude in (1), ..., D(k) where k ~= min{m, n}.

JOB is an integer that controls the computation of the singular vectors. It is assumed that JOB — 1-10-+ J when J,J = 0,1, ...,9. J and J have the following meaning.

I =.0 Do not compute the left singular vectors.

i=: 1 Compute all m left singular vectors

1 > 3 Compute the first min{mi,n} left singular vectors. (Here we compute the decomposition A = Uy D,V*.)

J. 0 Do not compute the right singular vectors,

J > Q Compute the right singular vectors.

U is a 2-dimensional array which contains the left singular vectors that are requested, and $k_u$ is the number of rows in the dimension statement for U in the calling program. It is assumed that $k_u \geq m$. If no left singular vectors are requested (i.e., if JOB < 10) then U is ignored by the routines. Otherwise, U must be of dimension $k_u \times m$ if all m left singular vectors are requested, and U must be of dimension $k_u \times \min\{m,n\}$ if the first min{m,n} left singular vectors are requested.



$U^*$ denotes the adjoint matrix of $U$.


<small>Original source: [View scanned PDF page 184](../scans/page_0184.png)</small>

V is a 2-dimensional array which contains the right singular vectors that are requested, and kv is the number of rows in the dimension statement for V in the calling program. It is assumed that kv > n. If no right singular vectors are requested then V is ignored by the routines. Otherwise, V must be of dimension kv x n if the right singular vectors are requested.

F is an array of dimension n or larger, and WORK is an array of dimension m or larger. FE and WORK are storage areas for the routines.

**Remarks.**

(1) If SSVDC is called then it is assumed that the arrays A, D,E,U,V,WORK are real arrays, if DSVDC is called then it is assumed that the arrays are double precision arrays, and if CSVDC is called then it is assumed that the arrays are complex arrays.

(2) The contents of A are destroyed by the routines. If left singular vectors are requested and there is sufficient storage in A to hold the vectors (there will be sufficient storage if m <n or JOB > 20), then one may set U = A. Similarly, if right singular vectors are requested and m > n then one may set V = A. However, only one of the two arrays U and V may be identified with A.

**Error Return.** INFO is an integer variable. If all the singular values are found then INFO will be set to O and the array E will contain zeros. However, if the 7'” singular value cannot be found then INFO is set to 7. In this case, if 7 < k where k = min{m,n} then the singular values d;41, ...,d, will have been computed and stored in D. A will have been reduced to an upper bidiagonal matrix B with D as its diagonal and EF its super diagonal. If U and V have been requested then B = U* AV will be satisfied.

**Programming.** SSVDC, DSVDC, and CSVDC are part of the LINPACK package of matrix subroutines released by Argonne National Laboratory. The routines were coded by G. W. Stewart. (University of Maryland). The routines employ the vector subroutines SSWAP, SROT, SDOT, SSCAL, SAXPY, SNRM2, DSWAP, DROT, DDOT, DSCAL, DAXPY, DNRM2, and CSWAP, CSROT, CDOTC, CSCAL, CAXPY, SCNRM2, Also the subroutines SROTG and DRO'G are called.

**Reference.** Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematic., Philadelphia, 1979.

LAR


<small>Original source: [View scanned PDF page 185](../scans/page_0185.png)</small>

<a id="topic-185-01"></a>
### Evaluation Of The Characteristic Polynomial Of A Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DET` | `FUNCTION` | `A, KA, N, X` | [`L47056`](../source_parts/nswc_part_05.f90#L4833) |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [`L47132`](../source_parts/nswc_part_05.f90#L4909) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [`L47207`](../source_parts/nswc_part_05.f90#L4984) |


The following functions are available for computing the determinant of A -- x] where Ais an n X n matrix, « a number, and J the n x n identity matrix.

DET(A,ka,n, x) DPDET(A, ka, n,z) CDET(A, ka, n, z)

DET is a real function that is used when A is a real matrix and 2 a real number, DPDET is a double precision function that is used when A is a double precision matrix and z a double precision number, and CDET is a complex function that is used when A is a complex matrix and x a complex number.

The value of the appropriate function is the determinant of the matrix A — 2/. The

argument ka has the value: ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > n > 1.

**Note.** A is destroyed during computation. Algorithm. Gauss partial pivoting is performed to reduce A -— zJ to upper triangular form. In CDET the pivots a,; are selected so that |Re(a,,)| + |Im(a,;)| = Max{|Re(a,,)| +

\Im(a,;;)| :# = 7, ...,n} rather than |a,,;| = max{|a,;|:1 = 7, ...,n}.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 186](../scans/page_0186.png)</small>

<a id="topic-186-01"></a>
### Solution Of The Matrix Equation Ax + Xb = C

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [`L47285`](../source_parts/nswc_part_05.f90#L5062) |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [`L47902`](../source_parts/nswc_part_05.f90#L5679) |


Given ap m xX m matrix A, n X n matrix B, and mx n matrix C. The subroutines ABSLV and DABSLV are available for obtaining the m x n matrix X which solves the equation AX + XB =C. ABSLV yields single precision results and DABSLV yields double precision results.

```fortran
CALL ABSLV(MO, M, N, A, NA, B, NB, C, NC, WK, IERR)
CALL DABSLV(MO, M, N, A, NA, B, NB, C, NC, WK, IERR)
```

If ABSLV is called then it is assumed that A, B,C, and W % are real arrays. Otherwise, if DABSLV is called then it is assumed that A, B,C, and Wh are double precision arrays.

It is assumed that m > iandn 1. The input arguments ka, kb, ke have the following values:

ka =: the number of rows in the dimension statement for A in the calling program

kb - the number of rows in the dimension statement for B in the calling program

ke == the number of rows in the dimension statement for C in the calling program It is required that ka > m, kb > n, ke > m.

WK is an array of dimension rm? 4-n? + 2k or larger where k = max{m,n}. WE is a general storage area for the routine.

MO is an input argument which specifies if the routine is being called for the first time. On an initial call MO <= 0. In this case, A is reduced to lower real Schur form, B is reduced oO upper real Schur form, and then the transformed system of equations is solved.

ND is # variable that reports the status of the results. When the routine terminates, INF) cat cue of the following values: a?

```text
Qk 9 The solution was obtained and stored in ©.
IND 1 The equations are inconsistent for A and 73.
IND ‘i could mot be reduced tu lower Schur form.
IND - 2 8 could met be reduced to upper Schur form.
```

I IND 4 O then no solution © is obtained.

When INE QO, A ce itains the lower Schur forma of the matrix A, B contains the upper Schur form of the matrix fo and WK contains the orthogonal matrices involved an the decompositions of A and Bo This information can be reused to solve a new set ool

equations. The following options are available: i BO}

MO i New matrices A and C' are given. The data foc ff ts reused in solving the new set of equations

MO) s Sew matrices &@ and ¢*" are given. “The data fer ber otpaedd ant solving the new set of equations

Mabe 09,2 Aonew matrix (os given. ‘The data for A and fo tensed an Se yti Che tra w set oof equations,


<small>Original source: [View scanned PDF page 187](../scans/page_0187.png)</small>

When the routine ix recalled, it is assumed that m,n, and Wik have not been modified.

**Programming.** ABSLV employs the subrouti- 3 ABSLVI, ORTHES, ORTRN1, SCHUR, SHRSLV, SLV, and DABSLV employs che rout. s DABSV1, DORTH, DRTRN1, DSCHUR, DSHSLV, DPSI-VY. ABSLV and DABSLY are adaptations by A. H. Morris of the subroutine AXPXB written by R. H. Bartels and G. W. Stewart (University of Texas at Austin).

**Reference.** Bartels. R. H. and Stewart, G. W., “Algorithm 432, Solution of the Matrix Equation AX | X Bo 0.” Comm. ACM 15 (1972), pp. 820-826.


<small>Original source: [View scanned PDF page 188](../scans/page_0188.png)</small>

<a id="topic-188-01"></a>
### Solution of the Matrix Equation A^T X + XA = C When C Is Symmetric

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [`L48521`](../source_parts/nswc_part_05.f90#L6298) |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [`L48847`](../source_parts/nswc_part_05.f90#L6624) |


Given matrices A and C of order 2 where C is symmetric. Then she subroutines TASLV and DTASLV are available for obtaining the symmetric matrix X which solves the equation A‘X + X 4=:C. TASLV yields single precision results and DTASLV yields double precision results.

```fortran
CALL TASLV(MO, N, A, NA, C, NC, WK, IERR)
CALL DTASLV(MO, N, A, NA, C, NC, WK, IERR)
```

If TASLV is called then it is assumed that A, C and WK are real arrays. Otherwise, if TASLV is called then it is assumed that A, C, and WK are double precision arrays.

It is a sumed .1at n >... The input arguments ka and ke have the following values: ka = the numbe: of rows in the dimension statement for A in the calling program ke = the number >f rows in the dimension statement for C in the calling program

{t is required that ka > n and ke > n.

WK is an array of dimension n* + 2: or larger that is a general storage area for the routine.

MO is an input argument, which specifies if the routine is being called for the first time. On an initial call MO = 0. In this case, A is reduced to upper real Schur form and then the transformed system of equations is solved.

```text
IND is a variable that reporis the status of the results. When the routme terminates,
IND has one of the following values:
```

```text
IND = 0 ‘The solution was obtained and stcred in C.
IND = 1 The equations are inconsistent.
IND. -1 A could not be reduced to upper Schur form,
```

WIND ¥ 0 then no solution is obtained.

When IND . 0, A contains the upper Schur form of the matrix 4 and WH contains the orthogonal matrix involved in the decomposition of A. ‘This data can be reused to solve a rew set of equations A'X + XA C. In this case, MO can be vet to any nonzero Value. When MO # Oit is assumed that only C has been modified. When the o-t) + terminates, toe solution for the new set of equations is stored in © Programming. TASLV employs the subroutines VASEVE, OR THES, ORPRNE, SCHUR, SYR SEV, SUV and DTASLV employs the routine DPASVI,ORTHDRERE EL DSCTEER, DSY VSV, LIPSEY. VASLV and DTASIV are adaptations by AJ HE Morus of toe subroutine ATAPSA written by Rofl Bartels and ce Woot wart (University of Texas at Austin).

**Reference.** Bartels, Ro No and Stewart, G. W Algorithm ¢32 Hear of the Matrix equation AX) NE CS Comm. ACM ES (6), pp, X20


<small>Original source: [View scanned PDF page 189](../scans/page_0189.png)</small>

<a id="topic-189-01"></a>
### Solution of the Matrix Equation AX^2 + BX + C = 0

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [`L49174`](../source_parts/nswc_part_05.f90#L6951) |


Given complex n x n matrices A,B, and C. The following subroutine is available for obtaining a complex n X n matrix X which solves the equation AX* + BX +C = 0.

```fortran
CALL SQUINT(NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR)
```

It is assumed that A, B,C, and X are 2-dimensional complex arrays of dimension mx n where sm > n. When SQUINT is called, the n x n complex matrix solution obtained for AX? + BX +C =:0 is stored in X. A,B, and C are modified by the routine.

IND is an integer variable. On input, if IND + 0 then it is assumed that an initial approximation for the desired solution is provided in X by the user. Otherwise, if IND = 0 then the routine provides its own initial approximation. Then Newton iteration is performed. On output, IND = the number of iterations that were performed to compute X.

WK is a complex array of dimension @ that is a work space for tue routine. It is assumed that > Tn? +n. When SQUINT terminates, WK(1) is a complex number whose real part is the norm ||AX? + BX +Clloo.

The argument 7 is a real number. If r < 0 then X is computed to machine precision. Otherwise, if 7 > 0 then iteration terminates when || AX? + BX +C|| <r.

MAX is a variable. If MAX > 0 then MAX is the maximum number of iterations that may be performed. If MAX < 0 then it is reset by the routine to 30, the default) maximum number of iterations.

**Error Return.** [ERR is a variable that is set by the routine. If a solution X is obtained, then IF RR is assigned the value 0. Otherwise, JERR has one of the following values:

IERR = J MAX iterations were performed. More iterations are needed. [ERR ~> 2,3 Factorization of the equations could not be completed.

X cannot be computed. IERR 10 4 nm Newton iteration failed on iteration mn. Possibly fo sancti accuracy was requested. X cannot be computed. IERR — 999 (Input Error) Either n= Les nor &< TnF don. When IERR |. 1 occurs, X contains the most recent value obtained for the solution and

WK(1) is a complex number whose real part is the latest value obtained for the nor

|AN?7 | BN 4 Clee.

Programming, SQUEN’T employs the subroutines SQUIN?, CQZHES, CQZIP TRISLY, and CPRANS. These routines were designed by (reorge Jo Davis (Georgia State University, Atlanta, Georgia), CQOZHES and CQSET are modifications of the EISPACK subroutine QAHES and QZ17T, developed at Argonne National Laboratory. “The function SPMEPAR &

also used,

O40


<small>Original source: [View scanned PDF page 190](../scans/page_0190.png)</small>

**References.**

(i) Davis, G. J., “Algorithm 598. Ai: Algorithm to Compute Solvents of the Matrix Equation AX? + BX + =U,” ACM Trans. Math Software 9 (1983), pp. 246-254.

(2) Garbow, B.S., et al., Matrix Eigensystems Routines - EISPACK Guide Extension, Springer-Verlag, 1977.


<small>Original source: [View scanned PDF page 191](../scans/page_0191.png)</small>

<a id="topic-191-01"></a>
### Exponential Of A Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [`L50113`](../source_parts/nswc_part_05.f90#L7890) |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [`L50276`](../source_parts/nswc_part_05.f90#L8053) |


Let A be a real matrix of order n > 1. Then the subroutines MEXP and DMEXP oo . are available for computing the exponential matrix e4 = )7> A'/t!, MEXP yields single t= 0 precision results and DMEXP yields double precision results.

```fortran
CALL MEXP(A, KA, N, Z, KZ, WK, IERR)
```

A is a real matrix of order n > 1 and Z a real 2-dimensional array. MEXP computes e4 and stores the results in Z. The arguments ka and kz have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kz = the number of rows in the dimension statement for Z in the calling program It is assumed that ka > n, kz > n, and that A and Z are different storage areas. If n > 1 then A is destroyed.

WK is a real array of dimension n(n +8) or larger that is a work space for the routine.

IERR is a variable that reports the status of the results. When MEXP terminates, JERR is assigned one of the following values: IERR = 0 The exponential was computed. HERR -— 1 The norm {[All, = max, >°; ja] is too large. e puted. IFRR | 2 The Pade denominator matrix is singular. (This should never

4 cannot be com-

occur.)

**Algorithm.** Ais balanced, yielding a matrix BD ' P!' APD where D is a diagonal matrix, Pa permutation matrix, and || B][y < {|All;. Next m is set to the smallest nonnegative integer such that min {/]2)[q, [i Billo} < 2™, and the 8 diagonal Pade approximation for eis used to compute exp($/2™). Then ¢? > fexp(2/2™)?" is obtained by ra squarings, and e4 PDe® DPD EPlas applied.

**Programming.** MXP calls the subroutines BALANC, BALINV, and SLV ‘The function IPMPAR as also used. MEXP was written by A. HL. Morris

**Reference.** Ward, Robert, Co, “Numerical Computation of the Matrix Exponential with Accuracy Estimate,” SEAM J. Numerical Analysis 14 (1977), pp 600 GEO

```fortran
CALL DMEXP(A, KA, N, Z, KZ, WK, IERR)
```

Aas a double precision matrix of order noo band 4 a double precision 2 dimensional array. DMEXP computes e* and stores the results am 2 The arguments ka and be lave the following values:

Aa the number of rows in the dimension statement fo cl in the callin prostate

ke the number of rows ie the dimension statement fe. 4 i the calling prorat


<small>Original source: [View scanned PDF page 192](../scans/page_0192.png)</small>

It is assumed that ka > n, kz > n, and that A and Z ave different storage areas. If n > 1 then A is destroyed.

WK is a double precision array of dimension n(n + 12) or larger that is a work space for the routine.

IERR is a variable that reports the status of the results. When DMEXP terminates, TERR is assigned one of the following values:

TERR = 0 The exponential was computed.

TERR = 1 The norm ||.4||; is too large. e4 cannot be computed.

IERR = 2 The Pade denominator matrix is singular. (This should never occur.)

**Programming.** DMEXP calls the subroutines DBAL, DBALNV, and DPSLV. The function IPMPAR is also used. DMEXP was written by A. H. Morris.

**Reference.** Ward, Robert C., “Numerical Computation of the Matrix Exponential with Accuracy Estimate,” SIAM J. Numerical Analysis 14 (1977), pp. 600-610.

