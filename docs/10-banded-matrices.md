[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-195"></a>
## Banded Matrices

<small>Original source: [View scanned PDF page 195](../scans/page_0195.png)</small>

<a id="topic-195-01"></a>
### Band Matrix Storage


For an m X n matrix A -= (aij), let me be the number of diagonals below the main diagonal containing nonzero elements, and rm, the number of diagonals above the main diagonal containing nonzero elements. Then mg and my are called the lower and upper band widths of A, and my+my-+ 1 the total band width of A. It is clear that 0 < me<m and 0 < m, <n, and that aj; 4 0 only when d ~ me < J < ¢-+m,. If the band width my-+ my, + 1 is sufficiently small, then it is also clear that a considerable savings in storage can occur by storing only the nonzero diagonals of A. In the adopted band storage scheme, the nonzero diagonals are the columns of an m x (mg+m, +1) matrix B == (b;,). For each nonzero a,;, 6, = ayy where k = 7 -4-+ mz+1. The remaining 6,,’s are zeros.

Example. Consider the matrix

41; 12 413 0 0 0) 0

G21 G22 @23 G24 O 0 0

O agg 433 @34 @35 O 0

A= 0 0 443 G44 G45 Gag 0 9 0 QO adsq Gsg sq G57 0) 0) C QO adgs Gee ae7z 0 Q G 0 O a7 azz

. O 0 0 0 0 0 Gaz

where m, = 1 and my == 2. Then A will be stored in band form as follows:

O air Gi2 443 G21 Gag 423 do4 G32 G33 A340 G35 B G43 Gag G45 C46 sa 455 G56 G57 a65 @eg 57 0 ar7e TT 0 0 . 1R7 Q 0 0 /

**Remark.** The first m, columns of B contain the nonzero diagonals of A below the main diagonal, the (rm, + 1)** column of B contains the main diagonal, and the last. m,, columns of B contain the nonzero diagonals of A above the main diagonal.

el ion 7


<small>Original source: [View scanned PDF page 196](../scans/page_0196.png)</small>

<a id="topic-196-01"></a>
### Conversion Of Banded Matrices To And From The Standard Format

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [`L50893`](../source_parts/nswc_part_05.f90#L8412) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L50967`](../source_parts/nswc_part_05.f90#L8486) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [`L51041`](../source_parts/nswc_part_05.f90#L8560) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [`L51112`](../source_parts/nswc_part_05.f90#L8631) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51186`](../source_parts/nswc_part_05.f90#L8705) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [`L51260`](../source_parts/nswc_part_05.f90#L8779) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [`L51331`](../source_parts/nswc_part_05.f90#L8850) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51405`](../source_parts/nswc_part_05.f90#L8924) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [`L51479`](../source_parts/nswc_part_05.f90#L8998) |


The following subroutines permit one to convert matrices to and from the standard format.

```fortran
CALL CVBR(B, KB, M, N, ML, MU, A, KA)
CALL CVBD(B, KB, M, N, ML, MU, A, KA)
CALL CVBC(B, KB, M, N, ML, MU, A, KA)
```

A is an m xX n matrix stored in band form, mg the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < ms < _m,0 < my <n,and ka > m.

B is a 2-dimensional array of dimension kb x n where kb > m. CVBR is used if A and B are real arrays, CVBD is used if A and B are double precision arrays, and CVBC is used if A and B are complex arrays. When the routine is called, the matrix A is stored in the array B in the standard format.

**Remark.** B may begin in the same location as A. If B begins in the same location then it is assumed that kb = ka. In this case, the result. B will overwrite the input data A. Otherwise, if B does not begin in the same location as A, then it is assumed that the storage areas A and 8 do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL CVRB(A, KA, M, N, ML, MU, B, KB)
CALL CVDB(A, KA, M, N, ML, MU, B, KB)
CALL CVCB(A, KA, M, N, ML, MU, B, KB)
```

Ais an m xX n matrix stored in the standard format, and re and m, are integers such that O < mz < mand 0< my <n. The arguiment ka is the number of rows in the dimension statement for A in the calling program. It is assumed that ka > m.

Bois a 2-dimension array of dimension kb x € where k6 > m and € > mg -+ my 4 I. CVRB is used if A and 2 are real arrays, CVDB is used if A and 8 are double precision arrays, and CVCB is used if A and 2 are complex arrays. When the routine is called, the m, diagonals of A immediately below the main diagonal, the main diagonal, and the mm, diagonals immediately above the main diagonal are stored in band form in B.

**Remarks.** (1) Given a matrix A> (a,,), then these routines may be used to convert A to band form

when the lower and upper bandwidths mu, and my of A are known. Efrng and mi are


<small>Original source: [View scanned PDF page 197](../scans/page_0197.png)</small>

not known, then the subroutines CVRB1, CVDB1, and CVCB1 described below can be used to convert A to band form.

B may begin in the same location as A. If B begins in the same location then it is assumed that kb = ka. In this case, the result B will overwrite the input data A. Otherwise, if 8 does not begin in the same location as A, then it is assumed that the storage areas A and B do not overlap.

Programmer. A. H. Morris.

```fortran
CALL CVRB1(A, KA, M, N, ML, MU, B, KB, NB, IERR)
CALL CVDB1(A, KA, M, N, ML, MU, B, KB, NB, IERR)
CALL CVCB1(A, KA, M, N, ML, MU, B, KB, NB, IERR)
```

A is an m X n matrix stored in the standard format. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that A is to be stored in band form in B. B is a 2-dimensional array of dimension kb x @ where kb > m. The argument 2 is an estimate of the maximum number of diagonals of A that will have to be stored.

CVRB1 is used if A and B are real arrays, CVDB1 is used if A and B are double precision arrays, and CVCBI is used if A and B are complex arrays. JERR, mz, and my, are integer variables. When the routine is called, if @ specifies sufficient storage for B then A is stored in band form in 8. Also IERR is assigned the value 0, m, = the number of diagonals of A below the main diagonal containing nonzero elements, and m, = the number of diagonals above the main diagonal containing nonzero elements.

**Error Return.** If £ does not specify sufficient storage for B, then IERR is assigned the value mz+m,, -+ 1. Reset @> IERR.

**Remark.** B may begin in the same location as A. If B begins in the same location then it is assumed that kb = ka. In this case, the result B will overwrite the input data A. Otherwise, if B does not begin in the same location as A, then it is assumed that the storage areas A and B do not overlap.

**Programming.** CVRB1 calls the subroutine CVRB, CVDBI calls the subroutine CVDB, and CVCBI calls the subroutine CVCB. These routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 198](../scans/page_0198.png)</small>

<a id="topic-198-01"></a>
### Conversion Of Banded Matrices To And From Sparse Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [`L51550`](../source_parts/nswc_part_05.f90#L9069) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [`L51616`](../source_parts/nswc_part_05.f90#L9135) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [`L51682`](../source_parts/nswc_part_05.f90#L9201) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [`L51748`](../source_parts/nswc_part_05.f90#L9267) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [`L51816`](../source_parts/nswc_part_05.f90#L9335) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [`L51884`](../source_parts/nswc_part_05.f90#L9403) |


The following subroutines permit one to convert matrices to and from sparse form.

```fortran
CALL MCVBS(A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR)
CALL DMCVBS(A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR)
CALL CMCVBS(A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR)
```

A is an m X n matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz, < m,0O < mu <n, and ka > m.

It is assumed that A is to be stored in sparse form in the arrays B,JB,/B. NUM is the estimated maximum number of elements that will appear in B and J&B. It is assumed that B and JB are of dimension max{1, NUM} and that /B is of dimension m + 1.

MCVE3 is used if A and B are real arrays, DMCVBS is used if A and B are double precision arrays, and CMCVBS is used if A and B are complex arrays. IERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for B and JB, then IERR is assigned the value 0 and A is stored in sparse form in B, 1B, JB.

**Error Return.** If there is not sufficient storage in B and JB for the 1** row of A, then IERR is set to 1 and the routine terminates. In this case, if: > 1 then the first : — 1 rows of A will have been stored in B and JB. Also [B(1), ...,1.B(s) will contain the appropriate row locations.

**Programmer.** A. H. Morris.

```fortran
CALL MCVSB(A, IA, JA, M, N, B, KB, NB, ML, MU, IERR)
CALL DMCVSB(A, IA, JA, M, N, B, KB, NB, ML, MU, IERR)
CALL CMCVSB(A, IA, JA, M, N, B, KB, NB, ML, MU, IERR)
```

A is an m Xn sparse matrix stored in the arrays A, A, JA. It is assumed that A is to be stored in band form in 8B. # is a 2-dimensional array of dimension kd x @ where kb > m. The argument @ is an estimate of the maximum number of diagonals of A that will have to be stored.

MCVSB is used if A and B are real arrays, DMCVSB is used if A and & are double precision arrays, and CMC VSB is used if A and B are complex arrays. TERR, my, and ig are integer variables. When the routine is called, if @ specifies sufficient storage for 8 then A is stored in band form in #. Also HERR is assigned the value 0, mg — the number of diagonals of A below the main diagonal containing nonzero elements, and my, > the number of diagonals above the main diagonal containing nonzero elements,


<small>Original source: [View scanned PDF page 199](../scans/page_0199.png)</small>

**Error Return.** If 2 does not specify sufficient storage for B, then IERR is assigned the value me+my +1. Reset 2> IERR.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 200](../scans/page_0200.png)</small>

<a id="topic-200-01"></a>
### Conversion Of Banded Real Matrices To And From Double Precision Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51952`](../source_parts/nswc_part_05.f90#L9471) |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51971`](../source_parts/nswc_part_05.f90#L9490) |


The following subroutines are available for converting banded real matrices to and from double precision form.

```fortran
CALL BCVRD(A, KA, M, N, ML, MU, B, KB)
```

A is an m xn real matrix stored in band form, mz the number of diagonals below the main diagonal! containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m, 0O<m,<n,and ka>m.,

B is a 2-dimensional double precision array of dimension kb x @ where kb > m and £>mze+m,+1. When BCVRD is called, A is stored in band form in B.

**Programmer.** A. H. Morris. CALL BCVDR(A, ka,m,n, mg,m,, B, kb)

Ais an mxn double precision matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and rn, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < m, < m,O0<m, <n, and ka >m.

B is a 2-dimensional real array of dimension kb x @ where kb > m and € > mz-+rny +1. When BCVDR is called, A is stored in band form in B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 201](../scans/page_0201.png)</small>

<a id="topic-201-01"></a>
### The Real And Imaginary Parts Of A Banded Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [`L51990`](../source_parts/nswc_part_05.f90#L9509) |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [`L52046`](../source_parts/nswc_part_05.f90#L9565) |


If A = (a,;) is a complex matrix then let Re(A) = (Re(a,;)) and Im(A) = {Im(c,;)}) denote the real and imaginary parts of A. If the matrix A is stored in band form, then the following subroutines are available for obtaining Re(A} and Im(A) in band form.

```fortran
CALL BREAL(A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR)
```

Ais an m xn complex matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A is the calling program. It is assumed that 0 < m,z < m, O< my <n,and ka>m.

B is a 2-dimensional real array of dimension kb x € where kb > m. The input argument é is an estimate of the maximum number of diagonals of Re(A) which will have to be stored (2 < me+ mu +1). TERR, ng, and ny are integer variables. When BREAL is called, if £ specifies sufficient storage for B then Re(A) is stored in band form in B. Also, IERR is assigned the value 0, ng = the number of diagonals of Re(A) below the main diagonal containing nonzero elements, and ny, = the number of diagonals of Re(A) above the main diagonal containing nonzero elements.

**Error Return.** If @ does not specify sufficient storage for B, then IERR is assigned the value v where v is the number of columns needed for B. Reset £> v.

**Programmer.** A. H. Morris. CALL BIMAG(A, ka, m,n, mz, mu, B, kb, €, ne, ny TERR)

Ais an m Xn complex matrix stored in band form, mg the number of diagonals below the main diagonal containing nonzero elements, and m,, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m, O0< my <n, and ka > m.

B is a 2-dimensional real array of dimension kb x € where kb > m. The input argument éis an estimate of the maximum number of diagonals of Im(A) which will have to be stored (2< me+mu +1). TERR, ne, and ny are integer variables. When BIMAG is called, if é specifies sufficient storage for J3 then Im(A) is stored in band form in B. Also, TERR is assigned the value 0, ng == the number of diagonals of Im(A) below the main diagonal containing nonzero elements, and ny = the number of diagonals of fm(A) above the main diagonal containing nonzero elements.

**Error Return.** If @ does not specify sufficient storage for 8B, then IERE is assigned the value v where v is the number of columns needed for B. Reset @ > v.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 202](../scans/page_0202.png)</small>

<a id="topic-202-01"></a>
### Computing A + Bi For Banded Real Matrices A And B

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52102`](../source_parts/nswc_part_05.f90#L9621) |


Given the real m x n matrices A and B stored in band form. Then the subroutine BCVRC is available for obtaining the complex matrix A+ Bt where ¢ = /—1.

```fortran
CALL BCVRC(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
```

A and B are real m x n matrices stored in band form, m, the number of diagonals of A below the main diagonal containing nonzero elements, m, the number of diagonals of A above the main diagonal containing nonzero elements, nz the number of diagonals of B below the main diagonal containing nonzero elements, and n, the number of diagonals of B above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program.

It is assumed that A+ At is to be stored in band form in C. C is a 2~—dimensional complex array of dimension kcx @ where kc > The input argument @ is an estimate of the maximum number of diagonals of A-++ Bt which, will have to be stored (@ > max{mz,ne} + max{my,ny} +1). TERR, vz, and vw, are integer variables. When BCVRC is called, if @ specifies sufficient storage for C then A+ Br is stored in band form in C. Also IERR is assigned the value 0, v, == the number of diagonals of A+ Br below the main diagonal containing nonzero elements, and », = the number of diagonals of A + Bt above the main diagonal containing nonzero elements.

**Error Return.** If 2 does not specify sufficient storage for C, then IERR is assigned the value v where v is the number of columns needed for C. Reset @> v.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 203](../scans/page_0203.png)</small>

<a id="topic-203-01"></a>
### Transposing Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52188`](../source_parts/nswc_part_05.f90#L9707) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52246`](../source_parts/nswc_part_05.f90#L9765) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52304`](../source_parts/nswc_part_05.f90#L9823) |


The following subroutines are available for transposing banded matrices.

```fortran
CALL BPOSE(A, KA, M, N, ML, MU, B, KB)
CALL DBPOSE(A, KA, M, N, ML, MU, B, KB)
CALL CBPOSE(A, KA, M, N, ML, MU, B, KB)
```

A is an m X n matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < m, < m,O < my <n,and ka>m.

B is a 2-dimensional array of dimension kb x @ where kb > n and £ > m+ my, + 1. BPOSE is used if A and 8 are real arrays, DPOSE is used if A and 8 are double precision arrays, and CBPOSE is used if A and B are complex arrays. When the routine is called, the transpose A‘ of A is stored in band form in B.

**Note.** It is assumed that the storage areas A and B do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 204](../scans/page_0204.png)</small>

<a id="topic-204-01"></a>
### Addition Of Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52362`](../source_parts/nswc_part_05.f90#L9881) |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52518`](../source_parts/nswc_part_05.f90#L10037) |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52674`](../source_parts/nswc_part_05.f90#L10193) |


Let A and B be m x n matrices stored in band form. The following subroutines are available for computing the sum C = A+ B.

```fortran
CALL BADD(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL DBADD(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL CBADD(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
```

A and B are mm xX m matrices stored in band form, my, the number of diagonals of A below the main diagonal containing nonzero elements, m, the number of diagonals of A above the main diagonal containing nonzero elements, ng the number of diagonals of B below the main diagonal containing nonzero elements, and n, the number of diagonals of 2 above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program.

It is assumed that A-+ B is to be stored in band form in C. C ts a 2-dimensional array of dimension ke x € where kc > m. The input argument @ is an estimate of the maximum number of diagonals of A + B which will have to be stored (@€ < max{rny, ne} | max{my,nu} $1). BADD is used if A and B are real arrays, DBADD is used if A and [2 are double precision arrays, and CBADD is used if A and B are complex arrays. TERR, vy, and ™, are integer variables. When the routine is called, if @ specifies sufficient storage for C then A { Bois computed and stored in band form in C. Also TERR is assigned the value O, vg the number of diagonals of A} B below the main diagonal containing nonzero elements, and vy, the number of diagonals of A + B above the main diagonal containing

nonzero elements,

**Error Return.** If @ does not specify sufficient storage for C, then HOR R is assigned the value

v where v is the number of columns needed for ©. Reset @ ov,

Remarks foie omg then Co may bey iu Che same location as Al Tf Co begins in the sane location as A, then dois assumed that ke &a and that the arrays A and # do not overlap In this case, the result C@ will overwrite the input data Al Similarly, frag © one then ©) may bevin in the same bocamoaas 8 when ke Ab and A and 8 do not overlap. Otherwise, i ¢

does not begin in the same location as A or #8, then it is assumed that the storage ares to

C) does not overlap with the storage areas for A and # dn this case there is mo restric tic:

on ke (other than the customary restriction that Ae > ae) Example. If / Athen @ tay be assigned any value ood da this case, will oon! only the maim draroduabot the zero matrix Ae Hoanday ay 0

Programmer A EE Nforeis


<small>Original source: [View scanned PDF page 205](../scans/page_0205.png)</small>

<a id="topic-205-01"></a>
### Subtraction Of Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52830`](../source_parts/nswc_part_05.f90#L10349) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52986`](../source_parts/nswc_part_06.f90#L1) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L53142`](../source_parts/nswc_part_06.f90#L157) |


Let A and B be m xn matrices stored in band form. The following subroutines are available for computing the difference C = A —- B,

```fortran
CALL BSUBT(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL DBSUBT(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL CBSUBT(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
```

A and B are m x n matrices stored 1) band form, m, the number of diagonals of A below the main diagonal containing nonzero elements, m, the number of diagonals of A above the main diagonal containing nonzero elements, ng the number of diagonals of B below the main diagonal containing nonzero elements, and n, the number of diagonals of B above the main diagonal containing nonzero elements. The argument xa is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program.

It is assumed that A — B is to be stored in band form in C. C is a 2-dimensional array of dimension kc x @€ where ke > m. The input argument @ is an estimate of the maximum number of diagonals of A -- B which will have to be stored (€ < max{mz, ne} + max{mu,nu} + 1). BSUBT is used if A and B are real arrays, DBSUBT is used if A and B are double precision arrays, and CBSUBT is used if A and B are complex arrays. IERR, vy, and vy are integer variables. When the routine is called, if ? specifies sufficient storage for C then A — B is computed and stored ir band form in C. Also IEFRR is assigned the value 0, vg = the number of diagonals of A- B below the main diagonal containing nonzero elements, and v,, = the number of diagonals of A — B above the main diagonal containing nonzero elements.

**Error Return.** Hf @ does not specify sufficient storage for C, then IERR is assigned the value v where v is the number of columns needed for C. Reset 2 > v.

**Remarks.** If m; > n, then C' may begin in the same location as A. If C’ begins in the same location as A, then it is assumed that Ac = ka and that the arrays A and Z do not overlap. In this case, the result C will overwrite the input data A. Similarly, ifm, < nz then C may begin in the same location as B when ke -. kb and A and B do not overlap. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage areas for A and B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

Example If 3 A then @ may be assigned any value » f. In this case, C will contain only the main diagonal of the zero matrix Ao By and ve oy, 0.

**Programmer.** A. H. Morris

te cant _


<small>Original source: [View scanned PDF page 206](../scans/page_0206.png)</small>

<a id="topic-206-01"></a>
### Multiplication Of Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [`L53298`](../source_parts/nswc_part_06.f90#L313) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [`L53453`](../source_parts/nswc_part_06.f90#L468) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [`L53608`](../source_parts/nswc_part_06.f90#L623) |


Let A and B be matrices stored in band form. The following subroutines are available for computing the product C = AB.

```fortran
CALL BPROD(M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR)
CALL DBPROD(M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR)
CALL CBPROD(M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR)
```

A is an mX n matrix stored in band form, m, the number of diagonals of A below the main diagonal containing nonzero elements, and m,, the number of diagonals of A above the main diagonal containing nonzero elements. B is an n x € matrix stored in band form, nz the number of diagonals of B below the main diagonal containing nonzero elements, and ny, the number of diagonals of B above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for 8 in the calling program. I. is assumed that ka > m and kb > n.

It is assumed that, AB is to be stored in band form in C. C ia a 2-dimensional array of dimension ke X nc where kc > m. The input argument nc is an estimate of the maximum number of diagonals of AB which will have to be stored (ne < min{n - i,me-+ ne} + min{f- 1,my + nu} +1). BPROD is used if A,B, and C are real arrays, DBPROD is used if A,B, and C are double precision arrays, and CBPROD is used if A,B, and © are complex arrays. IERR, vs, and ™, are integer variables. When the routine is called, if nc specifies sufficient storage for C then AB is computed and stored in band form in C. Also, TERR is assigned the value 0, vz, = the number of diagonals of AB below the main diagonal containing nonzero elements, and v,, =: the number of diagonals of AB above the main diagonal] containing nonzero elements.

**Error Return.** If nc does not specify sufficient storage for C, then IERR is assigned the value v where v is the number of columns needed for C. Reset ne > v.

**Note.** It is assumed that the storage area for C does not overlap with the storage areas for A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 207](../scans/page_0207.png)</small>

<a id="topic-207-01"></a>
### Product Of A Real Banded Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53763`](../source_parts/nswc_part_06.f90#L778) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53815`](../source_parts/nswc_part_06.f90#L830) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54055`](../source_parts/nswc_part_06.f90#L1070) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54106`](../source_parts/nswc_part_06.f90#L1121) |


Let A be a real mi & m matrix stored in band form. Then the following subroutines are available for multiplying A with a real vector.

```fortran
CALL BVPRD(M, N, A, KA, ML, MU, X, Y)
```

A is an m X n matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal] containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < mz < m,0 < my <n, and ka > m.

The argument z is a column vector of dimension n and y an array of dimension m. When BVPRD is called, the product Az is computed and stored in y.

**Remark.** [t is assumed that the arrays A, z, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL BVPRD1(M, N, A, KA, ML, MU, X, Y)
```

A is an m x n matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and mm, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m,0 < my, <n, and ka > m.

The arguments z and y are column vectors of dimension n and m respectively. When BVPRDL is called, Az + y is computed and stored in y.

**Remark.** It is assumed that the arrays A, 2, y do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL BTPRD(M, N, A, KA, ML, MU, X, Y)
```

A is an m xn matrix stored in band form, mg the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the

dimension statement for A in the calling program It is assumed that 0 < my < my <n, and ka > m.

m0 <

The argument x is a row vector of dimension m and y an array of dimension n. When BPPRD is called, the product 1A ts computed and stored in y.

**Remark.** It is assumed that the arrays A, 7, y do not overlap.


<small>Original source: [View scanned PDF page 208](../scans/page_0208.png)</small>

**Programmer.** A. H. Morris.

```fortran
CALL BTPRDi(m,n, A, ka, me, my, 2, y)
```

Aisanmxny stored in band form, yng the number of diagonals below the main diagonal conta. mzero elements, and ms, then number of diagonals above the main diagonal conta |. azero elements. The argument ka is the number of rows in the dimension statement iv: a the calling program. It is assumed that 0 < mg < m,0 <

my <mn,and ka >m.

The arguments 7 2: y are row vectors of dimension m and n respectively. When BTPRD1 is called, zA | —s computed and stored in y. Remark, It is assumed ‘1. the arrays A, 2, y do not overlap.

**Programmer.** A. H. ):


<small>Original source: [View scanned PDF page 209](../scans/page_0209.png)</small>

<a id="topic-209-01"></a>
### Product Of A Double Precision Banded Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53860`](../source_parts/nswc_part_06.f90#L875) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53913`](../source_parts/nswc_part_06.f90#L928) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54150`](../source_parts/nswc_part_06.f90#L1165) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54202`](../source_parts/nswc_part_06.f90#L1217) |


Let A +e a double precision m x nm matrix stored in band form. Then the following subroutines are available for multiplying A with a double precision vector.

```fortran
CALL DBVPD(M, N, A, KA, ML, MU, X, Y)
```

A is an m xX n matrix stored in band form, my, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < mz < m,0 < My <n, and ka > rm.

The argument z is a column vector of dimension m end y an array of dimension m. A,#,y are double precision arrays. When DBVPD is called, Az is computed and stored in y.

**Remark.** st is assumed that the arrays A, x, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DBVPDiI(m,n, A, ka, ong, mu,2,y)
```

A is an m xX n matrix stored in band form, m; the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < m, < m,0 < m, <n, and ka > m.

The arguments 2 and y are column vectors of dimension n and m respectively. A,2,y are double precision arrays. When DBVPD1 is called, Az + y is computed and stored in y.

**Remark.** it is assumed that the arrays A, zr, y do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL DBTPD(M, N, A, KA, ML, MU, X, Y)
```

Ais an m xX no matrix stored in band form, rg the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, J4 is assumed that O +. my < m,O -

ry <n, ard ka > oi,

The argument 218 a row vector of dimension mn and y an array of dimension nm. A,z,y are double precision arrays. When DBTPD is called, 74 is computed and stored in y


<small>Original source: [View scanned PDF page 210](../scans/page_0210.png)</small>

**Remark.** It is assume! that the arrays A, x, y do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL DBTPDi(m,n, A, ka, me, mu, 2, y)
```

A is an m X n matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the ‘dimension statement for A in the calling program. It is assumed that 0 < m, < m,0 < my <n, and ka > mi.

The arguments x and y are row vectors of dimension rn and n respectively. A,2z,y are double precision arrays. When DBTPD1 is called, xA + y is computed and stored in y.

**Remark.** It is assumed that the arrays A, x, y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 211](../scans/page_0211.png)</small>

<a id="topic-211-01"></a>
### Product Of A Complex Banded Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53958`](../source_parts/nswc_part_06.f90#L973) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54010`](../source_parts/nswc_part_06.f90#L1025) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54246`](../source_parts/nswc_part_06.f90#L1261) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54297`](../source_parts/nswc_part_06.f90#L1312) |


Let A be a complex m x n matrix stored in band form. Then the following subroutines are available for multiplying A with a complex vector.

```fortran
CALL CBVPD(M, N, A, KA, ML, MU, X, Y)
```

A is an m Xn matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mp < _m,0 < my <n, and ka > m.

The argument z is a column vector of dimension n and y an array of dimension m. A,2z,y are complex arrays. When CBVPD is called, Az is computed and stored in y.

**Remark.** It is assumed that the arrays A, x, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CBVPD1(M, N, A, KA, ML, MU, X, Y)
```

A is an m X n matrix stored in band form, m;, the number of diagonals below the main diagonal containing nonzero elements, and m,, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m,0 < my <n, and ka > m.

The arguments z and y are column vectors of dimension n and m respectively. A, x,y are complex arrays. When CBVPDI1 is called, Ax + y is computed and stored in y.

**Remark.** It is assumed that the arrays A, z, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CBTPE’ ‘m,n, A, ka, me, ru, 72, y)
```

A is an m Xn matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < mg < m,0O « my, <n, and ka > m.

The argument x is a row vector of dimension m and y an array of dimension n. A,x,y are complex arrays. When CBTPD is called, 2A is computed ind stored in y.

**Remark.** It is assumed that the arrays A, 2, y do not overlap.


<small>Original source: [View scanned PDF page 212](../scans/page_0212.png)</small>

Programmer, A. H. Morris.

```fortran
CALL CBTPD1(M, N, A, KA, ML, MU, X, Y)
```

A is an m Xn matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and rm, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the

dimension statement for A in the calling program. It is assumed that O < mz < m,0 < my, <n, and ka > m.

The arguments x and y are row vectors of dimension m and n respectively. A,z,y are complex arrays. When CBTPD1 is called, rA + y is computed and stored in y.

**Remark.** it is assumed that the arrays A, 2, y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 213](../scans/page_0213.png)</small>

<a id="topic-213-01"></a>
### L1 Norm of a Real Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [`L54363`](../source_parts/nswc_part_06.f90#L1378) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [`L54447`](../source_parts/nswc_part_06.f90#L1462) |


```text
If A = (a,;) is a real banded matrix then the following functions are available for
computing the £, norm ||Al|1 == max, Zy|a,;| of A.
```

BANRM(A, ka, m,n, m,,m,) DBINRM(A, ka, m,n, me, mu)

BiINRM is used if A is a real array and DBINRM is used if A is a double precision array. BINRM is a real function and DBINRM a double precision function.

The function has the value ||A||; for any m x n matrix A stored in band form. The argument mg, is the number of diagonals below the main diagonal containing nonzero elements, mm, the number of diagonals above the main diagonal containing nonzero elements, and ka the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz, < m, 0 < my, <n, and ka > m,

**Remark.** DB1INRM must be declared to be of type DOUBLE. PRECISION in the calling program.

**Programming.** BINRM calls the function SASUM and DBiNRM calls the function DASUM. BINRM and DBINRM were written by A. H. Morris.


<small>Original source: [View scanned PDF page 214](../scans/page_0214.png)</small>

<a id="topic-214-01"></a>
### L-infinity Norm of a Real Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [`L54341`](../source_parts/nswc_part_06.f90#L1356) |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [`L54425`](../source_parts/nswc_part_06.f90#L1440) |


```text
If A = (a,;) is a real banded matrix then the following functions are available for
computing the €,, norm ||A||,.o = max, ,|a,,| of A.
```

BNRM(A, ka, m,n, mz, my) DBNRM(A, ke, m,n, me, mu)

BNRM is used if A is a real array and DBNRM is used if A is a double precision array. BNRM is a real function and DBNRM a double precision function.

The function has the value ||Aj|.. for any m x n matrix A stored in band form. The argument mz is the number of diagonals below the main diagonal containing nonzero elements, m,, the number of diagonals above the main diagonal containing nonzero elements, and ka the number of rows in the dimension statement for A in the calling program. It is assumed that O< my, <m,0< m, <n, and ka >m.

**Remark.** DBNRM must be declared to be of type DOUBLE PRECISION in the calling program.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 215](../scans/page_0215.png)</small>

<a id="topic-215-01"></a>
### Solution Of Banded Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L54510`](../source_parts/nswc_part_06.f90#L1525) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L54614`](../source_parts/nswc_part_06.f90#L1629) |


Let A be a nonsingular nx n real matrix stored in band form and 6a real column vector of dimension n. The subroutine BSLV is available for solving the system of equations Ax = 6, and the subroutine BSLV1 is available for solving the transposed system of equations Atz = b. On an initial call to either routine, partial pivot Gauss elimination is first employed to obtain an LU decomposition of A, and then the equations are solved. BSLV and BSLV1 always generate the same LU decomposition of A. After the decomposition is obtained on an initial call to BSLV or BSLV, either routine may be called to solve a new system of equations Az = r or A’r = r without having to redecompose the matrix A.

```fortran
CALL BSLV(M0, A, KA, N, ML, MU, B, IWK, IERR)
CALL BSLV1(M0, A, KA, N, ML, MU, B, IWK, IERR)
```

BSLV is called for solving Az = 6 and BSLV1 is called for solving Atz == b. The argument m, is the number of diagonals below the main diagonal of A containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. It is assumed that n > 1,0 < mz <n, and 0 < m, < n. MO is an input argument which specifies if BSLV or BSLV1 is being called for the first time. On an initial call, MO = 0 and we have the following setup:

A is a 2-dimensional array of dimension ka x m where ka > n and m > 2mz,-+ my, + 1. On input, the first m, + m, + 1 columns of the array contain the matrix A in band form. When the routine terminates, the array A will contain the upper triangular matrix U of the LU decomposition and the multipliers which were used to obtain it.

X is an array of dimension n or larger. On input, X contains the vector b. On output, X will contain the solution of the system of equations.

IWK is an array of dimension n or larger for internal use by the routine. The pivot indices involved in the LU decomposition are stored in IWK.

On an initial call to BSLV or BSLV1I, IND ts an integer variable that reports the status of the results. When the routine terminates, IND has one of the following values:

IND = 0 The system of equations was solved.

IND = -1 Either n < Oor ka <n.

IND =: -2 Either mz, < O or my > n.

IND 3 Either m, < 0 or my > n.

IND - & Column & of A has been reduced to a column containing only

Zeros.

After an initial call to BSLV or BSLVI, if IND | Ooon output then either routine iuy be called with MO 400 When MO / Q it is assumed that only @ may have been modified BSLV is called for solving the new set of equations Ag 9b, and MWSEV 1 is called for solving the new vet of equations Abr — 6. The routine employs the Lt! decomposition obtained on the initial call te BSLY or BSLVE to solve the new set of equations. Onoimput, Xo contain:

L285


<small>Original source: [View scanned PDF page 216](../scans/page_0216.png)</small>

the new vector 6. On output, X will contain the solution to the new set of equations. In this case, IND is not referenced by the routine.

**Programming.** BSLV and BSLV1 employ the subroutines SNBFA,SNBSL,SAXPY,SSCAL, SS WAP and the functions ISAMAX and SDOT. SNBFA and SNBSL were written by E. A. Voorhees (Los Alamos Scientific Laboratory) and modified by A. H. Morris. The original versions of SNBFA and SNBSL are distributed by the SLATEC library.


<small>Original source: [View scanned PDF page 217](../scans/page_0217.png)</small>

<a id="topic-217-01"></a>
### Computation Of The Condition Number Of A Real Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [`L55656`](../source_parts/nswc_part_06.f90#L2671) |


If A is a real mn x n banded matrix then the following subroutine is available for estimating the £, condition number cond,(A) of A.

```fortran
CALL B1CND(A, KA, N, ML, MU, COND, IWK, WK, IERR)
```

A is a real n X n matrix stored in band form. A,ka,m,,m,, and IWK are the same arguments used for the subroutines BSLV and BSLV1, the only exception being that [WK now is an array of dimension 2n or larger.

COND is a real variable. When B1CND is called, then the subroutine BSLV is first invoked to obtain an LU decomposition of A which is stored in A and IWK. Then COND is assigned the value Oif A is singular and an approximation of the condition number cond, (A) if A is nonsingular.

WK is an array of dimension 2n or larger that is a work space for the routine.

IND is an integer variable that reports the status of the results. When B1CND terminates, IND has one of the following values:

IND = 1 A is singular and COND =. 0.

IND .- O Ais nonsingular and COND is an approximation of the condition number of A.

IND © - 1 Either n < Qor ka <n.

IND 2 Either my < O or mney > n.

IND 3 Either my, < Oor my, > n.

When an error is detected, the routine immediately terminates.

Usage. After BECND terminates, if IND Q then BSLV or BSLV may be called with MO / U to solve a system of equations. In this cause A, &a,nomiy,m, and EW are used by BSLV and BSLV, and must not be modified by the user.

**Algorithm.** A modification of the Hager procedure by Nicholas J. Higham (University of £ i J y B \ ;

Manchester, England) is used.

**Programming.** BECND employs the subroutines SONEST, BSLV, BSLV Ei, SNBEFALSNBSE, SCOPY, SAXPY, SSCAL, and SSWAP. and the functions BINRM, SDO'PR, SASUM), and ISAMAX. BEOND was written by Ao TL Morris, SONEST was written by No Jo Tiga

and modified by A. TE Morris.

**References.**

(t) Higham, NS FORTRAN codes for Estimating the One Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans, Math Software Ld (HOSS) pp SSP 396


<small>Original source: [View scanned PDF page 218](../scans/page_0218.png)</small>

(2) , “Algorithm 674: “FORTRAN codes for Estimating the One-Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 15 (1989), p. 168.

2SS


<small>Original source: [View scanned PDF page 219](../scans/page_0219.png)</small>

<a id="topic-219-01"></a>
### Double Precision Solution Of Banded Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55083`](../source_parts/nswc_part_06.f90#L2098) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55187`](../source_parts/nswc_part_06.f90#L2202) |


Let A be a nonsingular n x n double precision matrix stored in band form and 6 a double precision column vector of dimension n. The subroutine DBSLV is available for solving the system of equations Ax == b, and the subroutine DBSLV1 is available for solving the transposed system of equations A‘z == 6. On an initial call to either routine, partial pivot Gauss elimination is first employed to obtain an LU decomposition of A, and then the equations are solved. DBSLV and DBSLV1 always generate the same LU decomposition of A. After the decomposition is obtained on an initial call to DBSLV or DBSLV1, either routine may be called to solve a new system of equations Az = r or A'z = r without having to redecompose the matrix A.

```fortran
CALL DBSLV(M0, A, KA, N, ML, MU, B, IWK, IERR)
CALL DBSLVi(MO,A, ka, n, mz, mu, X IWK,IND)
```

DBSLV is called for solving Az = 6 and DBSLV1 is called for solving Atr = 6. The argument m, is the number of diagonals below the main diagonal of A containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. It is assumed that n > 1, 0 < mz, <n, and 0 < m, < n. MO is an input argument which specifies if DBSLV or DBSLV1 is being called for the first time. Cn an initial call, MO = 0 and we have the following setup:

A is a double precision 2-dimensional array of dimension ka x m where ka > n and m > 2mg4-my+1. On input, the first me+m,-+1 columns of the array contain the matrix Ain band form. When the routine terminates, the array A will contain the upper triangular matrix U of the LU decomposition and the multipliers which were used to obtain it.

X is a double precision array of dimension n or larger. Cn input, X contains the vector 6. On output, X will contain the solution of the system of equations.

IWK is an array of dimension n or larger for internal use by the routine. The pivot indices involved in the LU decomposition are stored in [WK.

On an initial call to DBSLV or DBSLV1, IND is an integer variable that reports the status of the results. When the routine terminates, IND has one of the following values:

```text
IND =; 0 The system of equations was solved.
IND — - 1 Hither n < Oor ka <n.
IND «= -2 Either my < O or my > n.
```

```text
IND = -3 Either my, <0 or my > n.
IND --  &
```

© Column k of A has been reduced to a column containing only

zeros,

After an initial call to DBSLV or DBSLVE, GP IND © 0 on output then either routine may be called with MO 7 0. When MO / Oot is assumed that only 6 may have been modified. DBSLY is called for solving the new set of equations Ac 6, and DBSLVE is called


<small>Original source: [View scanned PDF page 220](../scans/page_0220.png)</small>

for solving the new set of equations A'z = 4. The routine employs the LU decomposition obtained on the initial call to DBSLV or DBSLV1 to solve the new set of equations. On input, X contains the new vector b. On output, X will contain the solution to the new set of equations. In this case, IND is not referenced by the routine.

Programming DBSLV and DBSLV1 employ the subroutines DBFA, DBSL, DAXPY, DSCAL, DSWAP and the functions IDAMAX and DDOT. DBFA and DBSL are adaptations by A. H. Morris of the subroutines SNBFA and SNBSL, written by E. A. Voorhees (Los Alamos Scientific Laboratory). SNBFA and SNBSL are distributed by the SLATEC library.

200)


<small>Original source: [View scanned PDF page 221](../scans/page_0221.png)</small>

<a id="topic-221-01"></a>
### Computation Of The Condition Number Of A Double Precision Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [`L55774`](../source_parts/nswc_part_06.f90#L2789) |


If A is a double precision n x n banded matrix then the following subroutine is available for estimating the @; condition number cond,(A) of A.

```fortran
CALL DB1CND(A, KA, N, ML, MU, COND, IWK, WK, IERR)
```

A is a double precision n x n matrix stored in band form. A,ka,mz,m,, and IWK are the same arguments used for the subroutines DBSLV and DBSLVI1, the only exception being that IWK now is an array of dimension 2n or larger.

COND is a double precision variable. When DB1CND is called, then the subroutine DBSLV is first invoked to obtain an LU decomposition of A which is stored in A and IWK. Then COND is assigned the value 0 if A is singular and an approximation of the condition number cond,(A) if A is nonsingular.

WK is a double precision array of dimension 2n or larger that is a work space for the routine.

IND is ar integer variable that reports the status of the results, When DB1CND terminates, IND has one of the following values:

IND = 1 Ais singular and COND = 0.

IND = 0 Ais nonsingular and COND is an approximation of the condition

number of A.

IND = —-1 Either n < Oor ka <n.

IND = —2 Either me < 0 or my > n.

IND = ~—3 Either m, <Oormy > n.

When an error is detected, the routine immediately terminates.

Usage. After DBLCND terminates, if IND = 0 then DBSLV or DBSLVI may be called with MO z: 9 to solve a system of equations. In this case A,ra,n,m¢,my and [WK are used by DBSLV and DBSLV1, and must not be modified by the user.

**Algorithm.** A modification of the Hager procedure by Nicholas J. Higham (University of

Manchester, England) ig u-d.

**Programming.** DB1CND employs the subroutines DONEST, DBSLV, DBSLVI, DBFA, DBSL, DCOPY, DAXPY, DSCAL, and DSWAP, and the functions DBINRM, DDOT, DASUM, and IDAMAX. DISECND was written by A. TH. Morris§ DONES'T is the double precision form of the subroutine SONEST, written by No J. Higham and modified by A. HD. Morris.

**References.**

(1) Higham, NAP, FORTRAN codes for Estimating the One Norm of a Real or Complex Matrix. with Applications to Condition Estimation,’ ACM Trans. Math Software 14 (1988), pp. Seb 396.


<small>Original source: [View scanned PDF page 222](../scans/page_0222.png)</small>

(2) __, “Algorithm 674: “FORTRAN codes for Estimating the One-Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math

Software 15 (1989), p. 168.


<small>Original source: [View scanned PDF page 223](../scans/page_0223.png)</small>

<a id="topic-223-01"></a>
### Solution Of Banded Systems Of Complex Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55893`](../source_parts/nswc_part_06.f90#L2908) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55975`](../source_parts/nswc_part_06.f90#L2990) |


Let A be a nonsingular n x n complex matrix stored in band form and 6a complex column vector of dimension n. The subroutine CBSLV is available for solving the system of equations Az = 6, and the subroutine CBSLV1 is available for solving the transposed system of equations A’z = b. On an initial call to either routine, partial pivot Gauss elimination is first employed to obtain an LU decomposition of A, and then the equations are solved. CBSLV and CBSLV1 always generate the same LU decomposition of A. After the decomposition is obtained oa an initial call to CBSLV or CBSLVI, either routine may be called to solve a new system of equations Az = r or A‘z = r without having to redecompose the matrix A.

```fortran
CALL CBSLV(M0, A, KA, N, ML, MU, B, IWK, IERR)
CALL CBSLV1(M0, A, KA, N, ML, MU, B, IWK, IERR)
```

CBSLV is called for solving Az = 6 and CBSLV1 is called for solving A’z =: b. The argument mg is the number of diagonals below the main diagonal of A containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. It is assumed that n > 1,0 < mg <n, and O < m, <n. MO is an input argument which specifies if CBSLV or CBSLV1 is being called for the first time. On an initial call, MO = 0 and we have the following setup:

A is a complex array of dimension ka x m where ka > n and m > 2m,+ my+i1. On input, the first mg+m, +1 columns of the array contain the matrix Ain band form. When the routine terminates, the array A will contain the upper triangular matrix U of the LU decomposition and the multipliers which were used to obtain it.

X ig a complex array of dimension r or larger. On input, X contains the vector 6. On output, X will contain the solution of the system of equations.

JWK is an array of dimension n or larger for internal use by the routine. The pivot indices involved in the LU decomposition are stored in [WK.

On an initial call to CBSLV or CBSLV1, IND is an integer variable that reports the status of the results. When the routine terminates, {ND has one of the following values:

IND = 0 The system of equations was solved.

IND =: --i Either n <Oor ka <n,

IND = --2 Either m, <0 or mz > n.

IND = --3 Either my < 0 or my > n.

IND == k Column & of A has been reduced to a column containing only Zeros,

After an initial cali to CBSLV or CRSLV1, if IND ~ 0 on output then either routine may be called with MO / 0. When MO ¥# 0 it is assumed that only 6 may have been modified. CBSLV is called for solving the new set of equations Az = 6, and CBSELV4 is called for solving the new set of equations Afz = 6. The routine employs the LU decomposition


<small>Original source: [View scanned PDF page 224](../scans/page_0224.png)</small>

obtained on the initial call to CBSLV or CBSLV1 to solve the new set of equations. On input, X contains the new vector 6. On output, X will contain the solution to the new set of equations. In this case, IND is not referenced by the routine.

**Programming.** CBSLV and CBSLVI employ the subroutines CBFA, CBSL, CAXPY, CSCAL, CSWAP and the functions ICAMAX and CDOTU. CBFA and CBSL are adaptations by A. H. Morris of the subroutines SNBFA and SNBSL, written by E. A. Voorhees (Los Alamos Scientific Laboratory). SNBFA and SNBSL are distributed by the SLATEC library.

