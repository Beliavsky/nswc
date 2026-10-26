[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-262"></a>
## Eigenvalues and Eigenvectors

<small>Original source: [View scanned PDF page 262](../scans/page_0262.png)</small>

<a id="topic-262-01"></a>
### Computation Of Eigenvalues Of General Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [`L61666`](../source_parts/nswc_part_06.f90#L8617) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [`L61715`](../source_parts/nswc_part_06.f90#L8666) |


The subroutines EIG and EIG1 are available for computing the eigenvalues of real matrices. These routines frequently yield results accurate to 13~—14 significant digits. Indeed, for symmetric matrices they may give 2 or more digits better accuracy than the routines designed specifically for symmetric matrices. However, if the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur when the matrix is not symmetric. In this case one should not expect more than 7-8 digit accuracy.

```fortran
CALL EIG(IBAL, A, KA, N, WR, WI, IERR)
CALL EIG1(IBAL, A, KA, N, WR, WI, IERR)
```

A is a matrix of order n > 1 and WP,WI are real arrays of 2! ~ension n or larger. When £IG or EIG1 is called then the eigenvalues Ay, ...,A, of A are computed. The real parts of the eigenvalues are stored in WR(1), ...,.WR(n) and the imaginary parts are stored in WI(1), ...,WJ(n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue having the positive imaginary part being first.

IBAL and ka are input arguments. The argument ke is the number of rows in the dimension statement for A in the calling program. JBAL may be any integer. If IBAL #0 then the routines balance A before they compute the eigenvalues. Otherwise, if IBAL = 0 then A is not balanced.

**Error Return.** JERR is an integer variable. If all the eigenvalues are found then IERR is set to 0. Otherwise, if more than 30 iterations are required to compute the j** eigenvalue A,, then IERR is set to 7 and the routine terminates. In this case, if 7 < n then the eigenvalues Aj+1,-+-)An will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

(1) Even though the balancing operation does not increase the theoretical bounds on the errors, nevertheless at times it may result in a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy by as much as 5-6 significant digits. Thus it is recommended that balancing be done.

(2) a is destroyed during computation. EIG and EIG1 reduce A to upper Hessenberg form and then apply the QR algorithm to obtain the eigenvalues. They differ only in the choice of transformations used to reduce A to upper Hessenberg form. EIG employs elementary similarity transformations and EIG1i employs orthogonal similarity transformations. in theory the use of orthogonal transformations assures one of a tighter bound on che errors. However, since in practice matrices infrequently arise for which the orthogonal transformations actually generate more accurate results, and since the orthogonal transformations normally require more time than the elementary transformations, therefore EIG is the recommended routine.


<small>Original source: [View scanned PDF page 263](../scans/page_0263.png)</small>

**Programming.** EIG and EIG1 are driver routines for the EISPACK. subroutines BALANCG, ELMHSO, ORTHES, and HQR. These subroutines were developed at Argonne National Laboratory. The functions SPMFPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., ct al., Matrix Eigensystem Routines - EISPACK Guide (Second Edition), Springer-Verlag, 1976.

ay we


<small>Original source: [View scanned PDF page 264](../scans/page_0264.png)</small>

<a id="topic-264-01"></a>
### Computation of Eigenvalues and Eigenvectors of General Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [`L61764`](../source_parts/nswc_part_06.f90#L8715) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [`L61852`](../source_parts/nswc_part_06.f90#L8803) |


The subroutines EIGV and EIGV1 are available for computing the eigenvalues and eigenvectors of real matrices. These routines are extensions of the respective eigenvalue routines EIG and EIG1. Thus all comments made concerning the accuracy of the eigenvalues produced by EIG and EIGi apply also to EIGV and EIGV1. In particular, EIGV and EIGV1 can frequently yield high precision results for the eigenvalues if they are distinct. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue ia correct to within 2-3 units of the 14'* significant digit, but the components of the corresponding eigenvector are only accurate to 9-10 significant digits. In the case of repeated eigenvalues the situation regarding the eigenvectors is totally unpredictable. The components of such an eigenvector n-:y be correct to 6-7 significant digits, or the eigenvector may not even be an eigenvector! In this case the results should be checked.

```fortran
CALL EIGV(IBAL, A, KA, N, WR, WI, ZR, ZI, IERR)
CALL EIGV1(IBAL, A, KA, N, WR, WI, ZR, ZI, IERR)
```

A is a matrix of order n > 1 and WR, WI are real arrays of dimension n or larger. When EIGV or EIGV1 is called the eigenvalues Aj, ...,4,, and corresponding eigenvectors Z1,..-,2n are computed. The real parts of the eigenvalues are stored in WR(1), ...,WRin) and the imaginary parts are stored in WI(1),...,WI{n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue

having the positive imaginary part being first.

The input argument ka is the number of rows in the dimension statement for A in the calling program. ZR and ZI are real arrays of dimension ka Xn. For 7 = 1,...,n the real parts of the components of the eigenvector z; are stored in the jt" column of ZR (in locations YRUL7), ...,2R(n,7)) and the (imaginary parts are stored in the j*® column of ZL.

The eigenvectors z,;, ...,2, are na. normalized. l> ] Lay

IBAL is an input argument that can b2 assigned an- integer value. IY IBAL 3 9 chen the routines balance A before they compute the eigenvalues and eigenvectors. Otherwise, if IBAL - 0 then A is not balanced.

Error Return. HERR is an integer variable. If all the eigenvalues and eigenvectors are found then IEFRR is set te 0. Otherwise, if more than 36 iterations are required to compute the j' eigenvalue A;, then POKER is ect to g and the routine terminates. [iy this case, if ¢ <n then the eigenvalues A,41, ....A, will have been computed and the results stored in the WR and WI arrays. However, none of the eigenvectors will have been computed. The eigenvectors are computed only after all the eigenvalues have been obtained,

, aaa)


<small>Original source: [View scanned PDF page 265](../scans/page_0265.png)</small>

Remarks,

(1) ven though the balancing operation does not increase the theoretical bounds on the

errors, nevertheless at times it may result in a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy of ‘he eigenvalues by as much as 5-6 significant digits. When this occurs balancing will normally be needed to obtain the eigenvectors. In general, 1 ig recommended that balancing be done.

A is destroyed during computation, EIGV and EIGVi both reduce A to upper Hessenberg form, apply the QR algorithm to the Hessenberg matrix to obtain the eigenvalues, and then backsubstitute to generate the eigenvectors. They differ only in the choice of transformations used to reduce A to upper Hessenberg form. EIGV employs elementary similarity transformations and E1G VY! employs orthogonal similarity transformations. In theory the use of orthogonal transformations assures one of a tighter bound on the errors. However, since in practice matrices infrequently arise fer which the orthogonal transformations actually generate more accurate results, and since the orthogonal transformations normally require more time than the elementary transformations, therefore HiGV is the recommended routine.

**Programming.** EIGV and EIGV1 are driver routines for the EISPACK subroutines BAL- ANC, HLMHSO, ORTHES, ELF RNO, ORTRAN, HQR2, and BALBAK. These subroutines were developed at Argonne National Laboratory. The functions SPiMPAR and TPMPAR are also weed,

Reference. Smith, BLT, Goyle, é. “., et al. Matrix Eigensystem Routines -- EISPACK

ad Edition}, Springer- Verlag, 1975.


<small>Original source: [View scanned PDF page 266](../scans/page_0266.png)</small>

<a id="topic-266-01"></a>
### Double Precision Computation Of Eigenvalues Of Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [`L63643`](../source_parts/nswc_part_07.f90#L1) |


The subroutine DEIG is available for the double precision computation of the eigenvalues of real matrices. This routine frequently yields results accurate to 26-28 significant digits. However, if the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect more than 13-14 digit accuracy.

```fortran
CALL DEIG(IBAL, A, KA, N, WR, WI, IERR)
```

A is a double precision matrix of order n > 1 and WR, WI are double precision arrays of dimension n or larger. When DEIG is called then the eigenvalues A,, ...,A, of A are computed. The real parts of the eigenvalues are stored in WR(1),...,WR(n) and the imaginary parts are stored in WI(1), ...,WI(n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue having the positive imaginary part being first.

IBAL and ka are input arguments. The argument ka is the number of rows in the dimension statement for A in the calling program. IBAL may be any integer. If IBAL # 0 then the routine balances A before it computes the eigenvalues. Otherwise, if IBAL = 0 then A is not balanced.

**Error Return.** TERR is an integer variable. if all the eigenvalues are found then IERR is set to 0. Otherwise, if more than 50 iterations are required to compute the 7‘ eigenvalue A,, then TERK is set to 7 and the routine terminates. In this case, if 7 < n then the eigenvalues Aj+is+-+yAn Will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

```text
(1) A is destroyed during computation.
(2) DEIG is a double precision version of the eigenvalue routine EIG1.
```

**Programming.** DEIG is a driver routine for the subroutines DBAL, DORTH, and DHQR. These subroutines are double precision versions of the EISPACK subroutines BALANC, ORTHES, and HOR, developed at Argonne National Laboratory. The double precision versions were prepared by A. H. Morris. The functions DPMPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matrix Eigensystem Routines — EISPACK Guide (Second Edition), Springer-Verlag, 1976.

Se qn on


<small>Original source: [View scanned PDF page 267](../scans/page_0267.png)</small>

<a id="topic-267-01"></a>
### Double Precision Computation Of Eigenvalues And Eigenvectors Of Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [`L63692`](../source_parts/nswc_part_07.f90#L50) |


The subroutine DEIGV +> available for the double precision computation of the eigenvalues and eigenvectors of real matrices. This routine frequently yields values for the eigenvalues that are accurate to 26-28 significant digits. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. i: the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect the eigenvalues to have more than 13-14 digit accuracy.

```fortran
CALL DEIGV(IBAL, A, KA, N, WR, WI, ZR, ZI, IERR)
```

A is a double precision matrix of order n > 1 and WR, WI are double precision arrays of dimension n or larger. When DEIGV is called then the eigenvalues \1,...,A, and corresponding eigenvectors 21, ...,Z, are computed. The real parts of the eigenvalues are stored in WR(t),...,WR(n) and the imaginary parts are stored in Wi(1), ...,WI(n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue having the positive imaginary part, being first.

The input argument. ka is the number of rows in the dimension statement for A in the calling program. ZR ond ZI are double precision arrays of dimension ka x n. For J = 1,...,n the real vars: of the components of the eigenvector z,; are stored in the 7*h column of ZR (in locations ZR(i,7), ...,% R(n,7)) and the imaginary parts are stored in the

j** column of ZI. The eigenvectors 21, ...,Z, are not normalized.

IBAL is an input argument that can be assigned any integer value. If If AL # O then the routine balances A before it computes the eigenvalues and eigenvectors. Otherwise, if IBAL = 0 then A is not balanced.

**Error Return.** JERR is an integer variable. If all the eigenvalues and eigenvectors are found then IERR is set to 0. Otherwise, if more than 50 iterations are required to compute the 7*? eigenvalue 4;, then IERR is set to 7 and the routine terminates. In this case, if 7 <n then the eigenvalues A,41, ...,A, will have been computed and the results stored in the WR and WI arrays. However, none of the eigenvectors will have been computed. The eigenvectors are computed only after all the eigenvalues have been obtained.

**Remarks.**

```text
(1) A is destroyed during computation.
(2) DEIGY is a double precision version of the elgenvalue/-igenvector routine BIG VIL.
```


<small>Original source: [View scanned PDF page 268](../scans/page_0268.png)</small>

**Programming.** DEIGV is a driver routine for the subroutines DBAL, DORTH, DORTRN, DHQR2, and DBABK. These subroutines are double precision versions of the EISPACK routines BALANC, ORTHES, ORTRAN, HQR2, and BALBAK, developed at Argonne National Laboratory. The double precision versions were prepared by A. H. Morris. The functions DPMPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matréz Eigensystem Routines - EISPACK Guide (Second Edition), Springer-Verlag, 1976.


<small>Original source: [View scanned PDF page 269](../scans/page_0269.png)</small>

<a id="topic-269-01"></a>
### Computation Of Eigenvalues Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [`L65108`](../source_parts/nswc_part_07.f90#L1466) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [`L65129`](../source_parts/nswc_part_07.f90#L1487) |


The subroutines SEIG and SEIGt are available for computing the eigenvalues of symmetric real matrices. These routines frequently yield high precision results, SIG is faster than SEIG1, but at times SEIG1 will produce better results when the symmetric matrix is tridiagonal. For arbitrary symmetric matrices it is not clear if there is any difference ia the reliability of the routines.

```fortran
CALL SEIG(A, KA, N, W, T, IERR)
CALL SEIG1(A, KA, N, W, T, IERR)
```

A is a symmetric matrix of order n > | and W an array of dimension n or larger. When SEIG or SEIG1 is called the eigenvalues A,,...,A, are computed and stored in W(1),...,W(n). The eigenvalues are ordered so that Ay < +--+ < X,.

A may be packed or in standard form.) The input argument ka is a nonnegative

integer. If ka =O then A is assumed to be packed. Otherwise, if ka 4 0 then A is assumed to be in the standard format. In this case ka has the value:

ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > n. However, it is not r ju ved that A(#,7) be defined for i < J. Only the lower triangular ele: ts of A are used.

T is an array used for temporary storage. If SEIG is called then T must be of dimension 2n. However, if SEIG1 is called then 7 need only be of dimension n.

Error Return. [ERR is an integer variable. Ii all the eigenvalues are found then IERR is set to 0, Otherwise, if more than 30 iterations of the QL algorithm are required to compute the 7" eigenvalue A;, then TERR is set to 7. In this case, if 7 > 1 then the eigenvalues At, ..-,Ayz--1 will have been computed and stored ia W. The eigenvalues are ordered so that Ay < ++: < A;_1. However, they need not be the smallest eigenvalues of A.

**Remark.** A is destroyed during computation.

**Programming.** SEIG and SEIG1 are driver routines for the EISPACK subroutines TRED1, TRED3, TQLRAT, aid IMTQL1. ‘These subroutines were developed at Argonne National Laboratory. The function SPMPAR is also used.

**Reference.** Smith, B. T., Boyle, J. M., et ., Matrix Kigensystem Routines - EISPACK Guide (Second Edition), Springer-Verlag, 1976.

TRor details othe parked format see the section on packing acl umpe oo symmetric ¢oatrices

3OG


<small>Original source: [View scanned PDF page 270](../scans/page_0270.png)</small>

<a id="topic-270-01"></a>
### Computation Of Eigenvalues And Eigenvectors Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [`L65176`](../source_parts/nswc_part_07.f90#L1534) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [`L65210`](../source_parts/nswc_part_07.f90#L1568) |


The subroutines SEIGV and SEIC: Vi are available for computing the eigenvalues and eigenvectors of symmetric real matrices. These routines frequently yield high precision results for the eigenvalues. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue is correct to within 2-3 units of the 14'* significant digit, but the components of the corresponding eigenvector are only accurate tc 9--10 significant digits. SEIGV is faster than SEICVI1, but at times SEIGV1 will produce better results when the symmetric matrix is tridiagonal. For arbitrary symmetric matrices it is not clear if there is any difference in the reliability of the routines.

```fortran
CALL SEIGV(A, KA, N, W, Z, T, IERR)
CALL SEIGV1(A, KA, N, W, Z, T, IERR)
```

Ais asymmetric matrix of order n > 1 and W an array of dimension n or larger. When SEIGV or SEIGV1 is called the eigenvalues Ay, ...,A, and corresponding orthonormal eigenvectors z,,...,2, are computed. The eigenvalues are stored in W(1)},...,W(n) and are ordered so that Ay <--- < Ay.

A must ve in the standard format, having the dimension ka x n. It is assumed that ka > n. However, it ‘s not required that A{i,,s) be defined for: < 7. Only the lower triangular elements of A are used.

4 is an array of dimension ka X n or larger. For 7 = 1, ...,n the components of the eigenvector z; are stored in the jt* column of Z (in locations Z(1,9), ...,Z(n,7)). To conserve memory one may let A and Z denote the same array.

T is an array of dimension 1 used for temporary storage.

**Error Return.** [TERR is an integer variable. If all the eigenvalues and eigenvectors are found then IEFRR is set to 0. Otherwise, if more than 3U iterations of the QL algorithm are required to compute the j‘ eigenvalue A,, then TERR is set to 7. In this case, if 7 > 1 then the eigenvalues 4,,...,A,~1 and eigenvectors z,,...,2;.1 Will have been computed and stored in the W and Z arrays. However, the eigenvalues will be unordered.

**Remark.** A is not modified except when A and 4 denote the same array. Programming. SEIGV and SEICVi are driver routines for the EISPACK subroutines TRED2, TQL2, and IMTQL2. These subroutines were developed at Argonne National

Laboratory. The function SPMPAR is also used.

**Reference.** Smith, BoOP., Boyle, J. M., et al., Matrix Eigensystem Routines EISPACK Guide Second Edition), Springer-Verlag, 1976.


<small>Original source: [View scanned PDF page 271](../scans/page_0271.png)</small>

<a id="topic-271-01"></a>
### Double Precision Computation Of Eigenvalues Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [`L66289`](../source_parts/nswc_part_07.f90#L2647) |


The subroutine DSEIG is available for the double precision computation of the eigenvalues of symmetric real matrices. The subroutine frequently yields results accurate to 27-28 significant digits.

```fortran
CALL DSEIG(A, KA, N, W, T, IERR)
```

A is a double precision symmetric matrix of order n > 1 and W a double precision array of dimension n or larger. When DSEIG is called the eigenvalues \1, ...,A,, are computed and stored in W(i),...,W(n). The eigenvalues are ordered so that \y < +++ < An.

A may be packed or in standard form.! The input argument ka is a nonnegative

integer. If ka =O then A is assumed to be packed. Otherwise, if ka 4 0 then A is assumed tu be in the standard format. Ia this case ka has the value: ka = the number of rows in the dimension statement for A in the calling program

It is assumed that ko > n. However, it is not required that A(t, 7) be defined for 1 < 7. Only the lower triangular elements of A are used.

T is a double precision array of dimension 2n or larger that is a work space for the routine,

**Error Return.** IERR is an integer variable. If all the eigenvalues are found then IERR is set to 0. Otherwise, if more than 50 iterations of the QL algorithm are required to compute the j*® eigenvalue 4,;, then IERR is set to 7. In this case, if 7 > 1 then the eigenvalues Ay,..-,A;—1 Will have been computed and stored in W. The eigenvalues are ordered so that Ay < +++ < Ay_1. However, they need not be the smallest eigenvalues of A.

**Remarks.** (1) A is destroyed during computation.

(2) DSEIG is a double precision version of the eigenvalue routine SEIG.

**Programming.** DSEIG is a driver routine fur the subroutines DT REDI, DIT REDS, and DTQC. These subroutines are double precision versions of the EISPACK routines TRED I, TRED3, and TQLRAT, developed at Argonne National Laboratory. The double precision versions were prepared by A. H. Morris. The function DPMPAR is also used.

**Reference.** Smith, 8. 'P., Boyle, J. M., et at, Matrix Eigensystem Routines EISPACK Guide (Second Edition), Springer-Verlag, 1976. Mor tals um che packed crmat vee the section ou packing and unpacking symmetric matrices.


<small>Original source: [View scanned PDF page 272](../scans/page_0272.png)</small>

<a id="topic-272-01"></a>
### Double Precision Computation Of Eigenvalues And Eigenvectors Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [`L66311`](../source_parts/nswc_part_07.f90#L2669) |


The subroutine DSEIGV is available for the double precision computation of the eigenvalues and eigenvectors of symmetric real matrices. This subroutine frequently yields values for the eigenvalues that are accurate to 26-28 significant digits. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue is correct to within 2-3 units of the 28" significant digit, but the components of the eigenvector are only accurate to 22-24 significant digits.

```fortran
CALL DSEIGV(A, KA, N, W, Z, T, IERR)
```

A is a double precision symmetric matrix of order n > i, and W a double precision array of dimension n or larger. When DSEIGV is called the eigenvalues \1,...,An and corresponding eigenvectors z1,...,Z, are computed. The eigenvalues are stored in W(1),...,W(n) and are ordered so that Ay < +++ < Ag.

A must be in the standard format, having the dimension ka x n. It is assumed that ka > n. However, it is not required that Aft,j) be defined for 1 < 7. Only the lower triangular elements of A are used.

2 is a double precision array of dimension ke xn or larger. For j = 1, ...,n the components of the eigenvector z, are stored in the j'" column of Z (in locations Z(1,7), ...,Z(n,J)).

‘To conserve memory one may let A and Z denote the same array.

T is a double precision array of dimension mn or larger that is a work space for the routine.

Error Return. TERR is an integer variable. If a!l the eigenvalues and eigenvectors are found then IERR is set to 0. Otherwise, if more than 50 iterations of the QL algorithm are required to compute the 7'" eigenvalue A;, then IERR is set to 7. In this case, if 7 > 1 then the eigenvalues A,,...,A,., and eigenvectors z,,...,2;..1 will have been computed and stored in the W and Z arrays. However, the eigenvalues will be unordered.

```text
Remarks.
(1) Ais not modified except when A and Z denote the same arcay.
(2) DSEIG V is a double precision version of the eigenvalue /eigenvector subroutine SHEIGV,
```

Programming. DSEIGV as a driver routine for the subroutines D'PRED2 and DTQLY.

T: ese subroutines are double precision versions of the KISPACN subroutines PRED? and

TPQL2 developed at Argonne National Laboratory. The double precision versions were prepared by A. HL. Morris. The function DPMPAR is also used.

**Reference.** Sruth, 8. T., Boyle, Jo Mo, et al, Matrix Eigensystem Routines EISPACK Gute (Second Edition), Springer-Verlag, Love


<small>Original source: [View scanned PDF page 273](../scans/page_0273.png)</small>

<a id="topic-273-01"></a>
### Computation Of Eigenvalues Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [`L67073`](../source_parts/nswc_part_07.f90#L3431) |


The subroutine CEIG is available for computing the eigenvalues of complex matrices. This routine frequently yields results accurate to 13-14 significant digits. However, if the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect more than 7-8 digit accuracy.

```fortran
CALL CEIG(IBAL, AR, AI, KA, N, WR, WI, IERR)
```

AR and AI are real matrices of order n > 1, and WR and WI are real arrays of dimension n or larger. AR and Al are the real and imaginary portions of the complex matrix whose eigenvalues are to be computed. When CEIG is called the eigenvalues 41, ...,An are computed. The real parts of the eigenvalues are stored in WR(i),...,WR(n) and the imaginary parts ace stored in WI{1), ...,WI(n). The eigenvalues are unordered.

IBAL and ka are input arguments. It is assumed that ka is the number of rows in the dimension statements for AR and AI in the calling program. IBALL may be any integer. If IBAL 4 0 then the complex matrix (represented by AR and AJ) is balanced before the eigenvalues are computed. Otherwise, if IBAL = 0 then the complex matrix is not balanced.

**Error Return.** JERR is an integer variable. if all the eigenvalues are found then IERR is set tc 0. Otherwise, if more than 30 iterations are required to compute the j*" eigenvalue 4,, then IERR is set to 7 and the routine terminates. In this case, if 7 < n then the eigenvalues

Aj41)+++)An will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

(1) Even though the balancing operation does not increase the theoretical bounds on the errors, nevertheless at. times it may result in a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy by as touch as 5-6 significant digits. Thus it is recommended that balancing be done.

(2) AR and Al are destroyed during computation. CEIG reduces the complex matrix (represented by AR and Al) to upper Hessenberg form with unitary similarity transformations. Then the QR algorithm is used to obtain the eigenvalues.

Usage. If one has a complex matrix A, then AR sad lean be obtained using the matrix subroutines CMREAL and CMIMAG,

**Programming.** ClEIG is a driver routine for the EISPACK subroutines CBAL, CORTE and COMQR. These subroutines were developed at Argonne National Laboratory. ‘The functions SPMPAR and IPMPAR are also used,

**Reference.** Suuth, BoP, Boyle, do Moyet al. Matrix Eigensystem Routines EISPACK

trurde (Second Edition), Springer Verlag, £6


<small>Original source: [View scanned PDF page 274](../scans/page_0274.png)</small>

<a id="topic-274-01"></a>
### Computation Of Eigenvalues And Eigenvectors Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [`L67126`](../source_parts/nswc_part_07.f90#L3484) |


The subroutine CEIGV is available for computing the eigenvalues and eigenvectors of complex matrices. This routine frequently yields values for the eigenvalues that are accurate to 13-14 significant digits. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue is correct to within 2-3 units of the 14** significant digit, but the components of the corresponding eigenvector are only a-curate to 9-10 significant digits. If the eigenvalues of a matrix are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect the eigenvalues to have more than 7-8 digit accuracy, and the situation regarding the eigenvectors is totally unpredictable. The components of such an eigenvector may be correct to 6-7 significant digits, or the eigenvector may not even be an eigenvector! In this case the results should be checked.

```fortran
CALL CEIGV(IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP)
```

AR and AI are real matrices of order n > i and WR and WI are real arrays of dimension n or larger. AK and Al are the real and imaginary portions of the complex matrix whose eigenvalues and eigenvectors are to be computed. When CEIGV is called the eigenvalues Aj, ...,A, and corresponding eigenvectors z,,...,2, are computed. The real parts of the eigenvalues are stored in WR(1), ... W&(m) and che imaginary parts are stored in WI(1),...,WI(n). The eigenvalues are unordered.

(tis assumed that the input argument ka is the number of rows in the dimension statements for AR and Al in the calling program. ZR and Al are real arrays of dimension

ka xn, For j= 1,...,n the real parts of the components of the eigenvector z, are stored in the jt? column of ZR (in locations ZR(1,7), ...,ZR(n,7)) and the imaginary parts arc stored in the gj" column of ZI. ‘The eigenvectors 2, ...,¢, are not normalized.

IBAL is an input argument that can be assigned any integer value. If ISAL / 0 then the complex matrix (represented by AR and Al) is balanced before the eigenvalues and eigenvectors are computed. Otherwise, ff EBAL 0 then the complex matrix is not

balanced.

EMP is a real array used for temporary storage by the routine. Pf no balancing is tc be done (Le, if IBALL 0) then TEMP must be of dimension 2n or larger. Otherwise, if

balancing is to be performed then TREMP must be of dimension On or larger.

Error Return. He Rois an integer variable. Uf ail the eigenvalues and eigenvectors are found then HERR is set to 0. Otherwise, if mice than 30 iterations are required Co compute they! eigenvalue A), then TERR is set tog and the routine terminates. In this case, uy > on then the eigenvalues Ay, 4,000.4, will have been computed and the results stored up the WER aid Wi arrays However, none of the eigenvectors will have been computed. The eigenvectors

are computed only after all (he eigenvalues have been obtained

Sana


<small>Original source: [View scanned PDF page 275](../scans/page_0275.png)</small>

**Remarks.**

(1) Even though the balancing operation does not increase the theoretical bounds on the errors, nevertheless at times it may result i: a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy of the eigenvalues by as much as 5-6 significant digits. When this occurs balancing will normally be needed to obtain the eigenvectors. In general, it is recommended that balancing be done.

(2) AR and AI are destroyed during computation. CEIGV reduces the complex matrix (represented by AR and AI) to upper Hessenberg form with unitary similarity transformations. Then the QR algorithm is employed to obtain the eigenvalues, and backsubstitution is performed to generate the eigenvectors.

Usage. lf one has a complex matrix A, then AR and AI can be obtained using the matrix subroutines CMREAL and CMIMAG.

**Programming.** CEIGV is a driver routine for the EISPACK subroutines CBAL, CORTH, COMQR2, and CBABK2. These subroutines were developed at Argonne National Laboratory. The functions SPMPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matrix Eigensystem Routines — EISPACK Guide (Second Edition), Springer-Verlag, 1976.


<small>Original source: [View scanned PDF page 276](../scans/page_0276.png)</small>

<a id="topic-276-01"></a>
### Double Precision Computation Of Eigenvalues Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [`L68292`](../source_parts/nswc_part_07.f90#L4650) |


The subroutine DCEIG is available for the double precision computation of the eigenvalues of complex matrices. This routine frequently yields results accurate to 26-28 significant digits. However, if the eigenvalues are not distinct ur if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect more than 13-14 digit accuracy.

```fortran
CALL DCEIG(IBAL, AR, AI, KA, N, WR, WI, IERR)
```

AR and AI are double precision matrices of order n > 1, and WR and WI are double precision arrays of dimension n or larger. AR and AI are the real and imaginary parts of the matrix whose eigenvalues are to be computed. When DCEIG is called the eigenvalues Ay, ---,)An, are computed. The real parts of the eigenvalues are stored in WR(!), ..., WR(n) and the imaginary parts are stored in WI(1),..., WI(n). The eigenvalues are unordered.

IBAL and ka are input arguments. It is assumed that ka is the number of rows in the dimension statements for AR and AI in the calling program. IBAL may be any integer. If IBAL ¥ 0 then the complex matrix {represented by AR and Al) is balanced before the eigenvalues are computed. Otherwise, if IBAL == 0 then the complex matrix is not balanced.

**Error Return.** IERR is an integer variable. If all the eigenvalues are found then IERR is set to 0. Othe wise, if more than 50 iterations are required to compute the jt eigenvalue A}; then IERR is set to 7 and the routine terminates. In this case, if 7 <n then the eigenvalues Ajy41)---,An will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

```text
(1) AR and AT are destroyed during computation.
(2) DCEIG is a double precision version of the eigenvalue routine CEIG.
```

**Programming.** DCEIG is a driver routine for the subroutines DCBAL, DCORTH, and DCOMAQR. These subroutines are double precision versions of the EISPACK subroutines CBAL, CORTH, and COMQR, developed at Argonne National Laboratory. The double precision versions were prepared by A Ho Morris. The functions DCPABS, DPMPAR, IPMPAR and subroutine DCSQRT are also used.

**Reference.** Sruth, Bo T., Boyle, Jo Mo. et al, Matrix Eigensystem Routines EISPACK Guide (Second Edition), Springer Verlag, EQ76


<small>Original source: [View scanned PDF page 277](../scans/page_0277.png)</small>

<a id="topic-277-01"></a>
### Double Precision Computation Of Eigenvalues And Eigenvectors Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [`L68346`](../source_parts/nswc_part_07.f90#L4704) |


The subroutine DCEIGV is available for the double precision computation of the eigenvalues and eigenvectors of comp!ex matrices. The routine frequently yields values for the eigenvalues that are accurate to 26-26 significant digits However, be aware that the errors in the eigenvalues, no matter bow seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. If the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect the eigenvalues to have more than 13-14 digit accuracy.

```fortran
CALL DCEIGV(IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP)
```

AR and AI are double precision matrices of order n > 1 and WR and WI are double precision arrays of dimension n or larger. AR and AI are the real and imaginary portions of the complex matrix whose eigenvalues and eigenvectors are to be computed. When DCEIG V is called the eigenvalues A,, ....A, and corresponding eigenvectors z), ...,Z,, are computed. The real parts of the eigenvalues are stored in WR(1),..., WR(n) and the imaginary parts are stored in WI(!),...,WI(n). The eigenvalues are unordered.

It is assumed that the input argument ka is the number of rows in the dimension statements for AR and AI in the calling program. ZR and ZI are double precision arrays of dimension ka x n. For 7 ~ 1, ...,n the real parts of the components of the eigenvector z, are stored in the 7*" column of ZR (in locations ZR(1, 7), ...,2R(n,j)) and the imaginary ports are stored in the jt? column of ZI. The eigenvectors z;,...,2, are not normalized.

IBAL is an input argument that can be assigned any integer value. If IBAL 7 0 then the complex matrix (represented by AR and Al) is balanced before the eigenvalues and eigenvectors are computed. Otherwise, if IBAL -= 0 then the complex matrix is not balanced.

TEMP is a double precision array used for temporary storage by the routine. If no balancing is to be done (ie., if IBAL 0) then TEMP must be of dimension 2n or larger. Otherwise, if balancing is to be performed then TEMP must be of dimension 3n or larger

**Error Return.** [EPR is an integer variable. If all the eigenvalues and eigenvectors are found then TERR 1s set to O. Otherwise, if more than 50 iterations are required to compute the j'? eigenvalue A,, then TERR is set to 7 and the routine terminates. In this case, if 7 <n then the eigenvalues A,41, -..,An will have been computed and the results stored in the WR and WI arrays. However, none of the eigenvectors will have been computed. The eigenvectors

are computed only after all the eigenvalues have been obtained

Remarks (1) AK and Al are destroyed during computation.

(2, DRCRIO Vos a double precision version of the eigenvalue/eigenvector routine ORIG V


<small>Original source: [View scanned PDF page 278](../scans/page_0278.png)</small>

gramming. DCEIGV is a driver for the subroutines DCBAL, DCORTH, DCMQR2,

. DCBABK. These subroutines are double precision versions of the EISPACK routines CUAL, CORTH, COMQR2, and CBABK2, developed at Argonne National Laboratory. ‘ne double precision versions were prepared by A. H. Morris. The functions DCPABS, DPMPAR, IPMFAR anc subroutine DCSQRT are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matrix Eigensystem Routines — EISPACK Guide (Second Edition), Springer-Verlag, 1976.

