[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-395"></a>
## Manifold Fitting

<small>Original source: [View scanned PDF page 395](../scans/page_0395.png)</small>

<a id="topic-395-01"></a>
### Weighted Least Squares Fitting With Polynomials Of N Variables

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [`L105203`](../source_parts/nswc_part_10.f90#L9387) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [`L106210`](../source_parts/nswc_part_10.f90#L10394) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [`L106476`](../source_parts/nswc_part_11.f90#L88) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [`L107020`](../source_parts/nswc_part_11.f90#L632) |


Let {(2.°, at) faced, ... 46} be a set of f distinct points, z1,...,z¢ be the corresponding function values to be approximated, and w ,...,w, be positive weights. Then for any nonnegative integer IDEG where ("*!P®G) < @! the subroutines MFIT and DMFIT are available for obtaining the coefficients of the unique polynomial F(z, ...,2n)

of degree IDEG which minimizes }> w,{F(z),...,2,°) - z,|*. Also, the subroutines

teal MEVAL and DMEVAL are available for computing this polynomial. MFIT and MEVAL yield single precision results, and DMFIT and DMEVAL yield double precision results.

```fortran
CALL MFIT(DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD)
```

MIWK MWK) CALL DMFIT(n, IDG, 1m, @, X,keo, ZW, R, TER TWK,WhH,LIWK,LWK, MIWK MWK)

It is assumed that n > land €> 1. X is an @ xn matrix whose ¢4* row contains the point (2, ae vr")). i.e., X(4,7) ') forts o,...,@and 7 -1,...,m. 'The argument kx is the number of rows in the dimension statement for X in the calling program. Z is an array containing zy, ...,2, and W an array containing w;,...,tw,¢. X and 4 are modified

by the routine.

**Remark.** For IDEG © 0, ("'YPES) polynomials Lay, ...,7n,22,4122, ..- are needed for a basis of the space of polynomials of degree ~ TDG. The basis polynomials are ordered. For ko 1, the degree kL basis polynomials precede the degree A polynomials. ‘The degree k basis polynomials are xy, -+- 4, where Bs ay see) 6 ay som. Kor any two such polynomials 7,,--04,, andor, 7-4), let r be the smallest integer such that a, 4 7,. Then Hy, cca, precedes 2, -++2,, whens, © 9.

IDEG and om are variables. Tf EDC) + OG then the routine attempts to obtain the polynomial P(2zy, ....2,,) of degree (DEG which is the best least squares fit. Otherwise, if IDRG . O then it is assumed that - band that the first mi basis polynomials are to be used to obtain the least squares fit. When the routine terminates, EDNG the degree of the polynomial MQ, 002,27.) obtained andi the number of basis polynomials that are

actually used.

. : ; , \ (s) (ly o¢ , As an array of dimension for larger. Ava) fy Rory ry) fora l, é

when the routine terminates

IWR ois an array of dimension BEY aod WA ai array of dimension LWA) When the routine terminates, PWR and Whocoutar the information needed for computing the polynomial M(2,, 0-4, ) Sufficient store for DW and Who can be assured by setting LIWK and LWRoas follows HP db Gothen tet titel f ("" ua “yt and é Hoke:


<small>Original source: [View scanned PDF page 396](../scans/page_0396.png)</small>

Otherwise, if IDEG < 0 then let N = m and 6 be the smallest nonnegative integer such that ("*°) > m. Then set

LIWK > 4N + 6n LWK > 2N+¢n+14+@N + S(N ~ 1)(N - 2).

N is the maximum number of basis polynomials that will be used, and 6 is the degree of the polynomial F(z), ...,2,) if N basis polynomials are used.

MIWK and MWK are variables. MIWK is set by the routine to the dimension needed for IWK, and MWK is set to the dimension needed for WK. MIWK and MWK depend only on n, €,IDEG, and m.

If MFIT is called then X,Z,W, R, and WK are single precision real arrays. Otherwise, if DMFIT is called then X,Z,W,R, and WK are double precision arrays.

IER is a variable that reports the status of the results. When the routine terminates, JER has one of the following values: IER = 0 The desired polynomial was obtained. IER = ~1 Not all the basis polynomials could be used. IDEG is the degree of the polynomial obtained. This setting occurs when the problem ig not solvable or is too ill-conditioned for the requested degree.

IER = 1 Only @ basis polynomials were used. A polynomial (21, ...,2n) was obtained which solves the equations F(z" ; at )= x fors --1,...,8.

IER == 2 (Input error) IDEG < 0 and m < 0.

IER 3 (input error) n < Lor @< 1.

IWR = 4 (Input error) LIWK or LWK is too small. Set LIWK > MIWK and LWK > MWK.

When an input error is detected, the routine immediately terminates.

**Remark.** When IER © 1 then MEVAL or DMEVAL may be used to compute the polynomial obtained.

**Algorithm.** ‘The revised Gram-Schmidt orthogonalization procedure is used,

**Programming.** MEFUP employs the routines ALLOT, BASIZ, MPABLE, GNRTP, INGCIDG | SCALPM,SCALDN,and OME? employs the routines ALLOT,BASIZ MTA BLE,DGONR'EP, DINCDG, DSCALP, DSCALD. MEVP and DMETP are modifications by Al HE. Morris of CONSTR, written by Richard HW. Bartels (University of Waterloo) and John J. Jezioranski (Ontario Cancer Institute)

**References.** (1) Bartels, Rodb aud Jeviorauski, JoJo) “Least Squares Fitting using Orthogonal Multinomials,” ACA Trans Math Software EL (LO85), pp BOL LET, (2) ,Algorithm 034, CONS'PR and EVAL Routines for Fitting Multitorabs

Moa Least Squares Sense,” ACM Trans. Math Software LE CLSSs), pp. 2ES 22S


<small>Original source: [View scanned PDF page 397](../scans/page_0397.png)</small>

```fortran
CALL MEVAL(DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP)
CALL DMEVAL(DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP)
```

MEVAL (DMEVAL) computes the polynomial obtained by MFIT (DMFIT), or a portion thereof. Let IDEG and m be the output values given by MFIT (DMFIT).

The argument 77 is a variable. If KDEG < 0 then it is assumed that 1 < m < m and that the polynomial using the first #7i basis polynomials is to be computed. In this case, the polynomial computed is the best least squares fit for the basis polynomials involved.

If KDEG > 0 then it is assumed that KDEG < IDEG. In this case, when the routine terminates, 7m = the number of basis polynomials used. If m < m (which will be the case when KDEG < IDEG), then the polynomial computed is the polynomial of degree KDEG which 13 the best least squares fit.

Usage. If IER = +1 when MFIT(DMFIT) terminates, then the setting KDEG = IDEG normally causes an error to occur since 7m > m. Hence, if it is desired that the full polynomial obtained by MFIT(DMFIT) be computed, no matter whether the value for IER is O or +1, then KDEG should be assigned a negative value and fi = m.

It is assumed that the polynomial is to be computed at the points (#{, Et?) fort = 1,...,@ Xlig an @x n matrix whose t** row contains the point (z,, .. Ee), The argument zt is the number of rows in the dimension statement for XI in the calling program. ZI is an array of dimension @ or larger. When the routine terminates, ZI(s) contains the value of the polynomial at the point (z,, _ ,z,() fori =1,...,6.

IWK and WK are the arrays obtained from MFIT or DMFIT. LIWK is the dimension of IWK and LWK the dimension of WK. T is an array of dimension n or larger that is a work space for the routine.

If MEVAL is called then XI, ZI, WK and T are single precision arrays. Otherwise, if DMEVAL is called then XI, ZI, WK and 7 are double precision arrays.

```text
IND is a variable that reports the status of the results. When the routine terminates,
IND has one of the following values:
```

IND -- © The desired computation was performed.

IND = ~1 (Input error) 7i < lor wi > m.

IND — ~2 (Input error) n < bor @< 1.

**Programming.** MEVAL calls the subroutine MEVALI and DMEVAL calls the subroutine DMEVLI. MEVAL and DMEVAL are modifications by A. H. Morris of EVAL, written by Richard H. Bartels (University of Waterloo) and John J. Jezioranski (Ontario Cancer Institute).

H29

