# NSWC Fortran source interface inventory

This is a mechanically generated inventory of procedure declarations present in the
supplied source (preserved as `nswc_orig.f`), not an assertion that every routine is documented in the 1993
manual. Some entries are internal helpers. The original source was parsed as fixed-form
Fortran, including continuation lines. `ENTRY` statements would be listed, if present.

For source-verified interfaces grouped by mathematical topic, see [README.md](README.md). Links point into browsable source partitions; the displayed line numbers are positions in the recommended free-form `nswc.f90`.

- Source procedures: **1,062**
- Documented procedures mapped to manual topics: **576**
- Remaining procedures: **486** (largely support routines; some may warrant further manual review)

| Procedure | Kind | Arguments | Source line | Manual topic |
|---|---|---|---:|---|
| `ABCON` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [82255](source_parts/nswc_part_08.f90#L8291) | Not indexed |
| `ABCON1` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [82451](source_parts/nswc_part_08.f90#L8487) | Not indexed |
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [45202](source_parts/nswc_part_05.f90#L2997) | [Documented](docs/08-matrices.md#topic-186-01) |
| `ABSLV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [45285](source_parts/nswc_part_05.f90#L3080) | Not indexed |
| `ACOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [82580](source_parts/nswc_part_08.f90#L8616) | Not indexed |
| `ACONDF` | `FUNCTION` | `X, Y, C, FUN` | [82653](source_parts/nswc_part_08.f90#L8689) | Not indexed |
| `ACONDG` | `FUNCTION` | `X, Y, C, FUN` | [82671](source_parts/nswc_part_08.f90#L8707) | Not indexed |
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [86945](source_parts/nswc_part_09.f90#L2094) | [Documented](docs/17-approximation-of-functions.md#topic-329-01) |
| `ADAPT1` | `SUBROUTINE` | `F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [87037](source_parts/nswc_part_09.f90#L2186) | Not indexed |
| `ADCHK` | `SUBROUTINE` | `` | [87882](source_parts/nswc_part_09.f90#L3031) | Not indexed |
| `ADCOMP` | `SUBROUTINE` | `F` | [87496](source_parts/nswc_part_09.f90#L2645) | Not indexed |
| `ADNODE` | `SUBROUTINE` | `KK, X, Y, IADJ, IEND, IER` | [97371](source_parts/nswc_part_10.f90#L2004) | Not indexed |
| `ADPUT` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [87941](source_parts/nswc_part_09.f90#L3090) | Not indexed |
| `ADSET` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [87264](source_parts/nswc_part_09.f90#L2413) | Not indexed |
| `ADTAKE` | `SUBROUTINE` | `IERR` | [87410](source_parts/nswc_part_09.f90#L2559) | Not indexed |
| `ADTRAN` | `SUBROUTINE` | `D, POWERS` | [88029](source_parts/nswc_part_09.f90#L3178) | Not indexed |
| `AERF` | `REAL FUNCTION` | `X, H` | [7895](source_parts/nswc_part_01.f90#L7895) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `AI` | `REAL FUNCTION` | `X` | [23107](source_parts/nswc_part_03.f90#L2066) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AIA` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [22142](source_parts/nswc_part_03.f90#L1101) | Not indexed |
| `AIE` | `REAL FUNCTION` | `X` | [23211](source_parts/nswc_part_03.f90#L2170) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AII` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [22089](source_parts/nswc_part_03.f90#L1048) | Not indexed |
| `AIMP` | `SUBROUTINE` | `X, R, PHI` | [23607](source_parts/nswc_part_03.f90#L2566) | Not indexed |
| `AIRM` | `SUBROUTINE` | `IND, Z, AI, AIP, BI, BIP` | [21999](source_parts/nswc_part_03.f90#L958) | Not indexed |
| `ALGDIV` | `REAL FUNCTION` | `A, B` | [13601](source_parts/nswc_part_02.f90#L3069) | Not indexed |
| `ALI` | `REAL FUNCTION` | `X` | [10888](source_parts/nswc_part_02.f90#L356) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `ALLOT` | `SUBROUTINE` | `DEGREE, NPOLYS, NPTS, DIMEN, IWORK, IWKLEN, IREQD, DREQD, ERROR` | [100213](source_parts/nswc_part_10.f90#L4846) | Not indexed |
| `ALNREL` | `REAL FUNCTION` | `A` | [4248](source_parts/nswc_part_01.f90#L4248) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [3511](source_parts/nswc_part_01.f90#L3511) | [Documented](docs/02-elementary-operations.md#topic-032-01) |
| `AORD` | `SUBROUTINE` | `A, N` | [1999](source_parts/nswc_part_01.f90#L1999) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `APSER` | `REAL FUNCTION` | `A, B, X, EPS` | [16039](source_parts/nswc_part_02.f90#L5507) | Not indexed |
| `ARCEBE` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, PIVOT, X` | [39265](source_parts/nswc_part_04.f90#L7678) | Not indexed |
| `ARCEBM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [39239](source_parts/nswc_part_04.f90#L7652) | Not indexed |
| `ARCEBS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [39210](source_parts/nswc_part_04.f90#L7623) | Not indexed |
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [38270](source_parts/nswc_part_04.f90#L6683) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARCEDC` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, IFLAG` | [38412](source_parts/nswc_part_04.f90#L6825) | Not indexed |
| `ARCEFE` | `SUBROUTINE` | `BLOCK, NRWBLK, NRWPIV, PIVOT, B` | [39176](source_parts/nswc_part_04.f90#L7589) | Not indexed |
| `ARCEFM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, B, X` | [39150](source_parts/nswc_part_04.f90#L7563) | Not indexed |
| `ARCEFS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, B, X` | [39119](source_parts/nswc_part_04.f90#L7532) | Not indexed |
| `ARCEPC` | `SUBROUTINE` | `TOPBLK, NRWTOP, NOVRLP, BOTBLK, NRWBOT, NCLPIV, PIVOT, PIVMAX, IFLAG` | [38779](source_parts/nswc_part_04.f90#L7192) | Not indexed |
| `ARCEPR` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, PIVOT, PIVMAX, IFLAG` | [38668](source_parts/nswc_part_04.f90#L7081) | Not indexed |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [38894](source_parts/nswc_part_04.f90#L7307) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARTNQ` | `FUNCTION` | `Y, X` | [2977](source_parts/nswc_part_01.f90#L2977) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `ASIK` | `SUBROUTINE` | `X, FNU, KODE, FLGIK, RA, ARG, IN, TOL, Y` | [20596](source_parts/nswc_part_02.f90#L10064) | Not indexed |
| `ASJY` | `SUBROUTINE` | `FUNJY, X, FNU, FLGJY, IN, TOL, ELIM, Y, WK, IFLW` | [18643](source_parts/nswc_part_02.f90#L8111) | Not indexed |
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [80996](source_parts/nswc_part_08.f90#L7032) | [Documented](docs/15-optimization.md#topic-314-01) |
| `ASSGN1` | `SUBROUTINE` | `N, A, C, T, CH, LC, LR, LZ, NZ, RH, SLC, SLR, U, IERR` | [81018](source_parts/nswc_part_08.f90#L7054) | Not indexed |
| `ATN` | `COMPLEX FUNCTION` | `Z` | [24341](source_parts/nswc_part_03.f90#L3300) | Not indexed |
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [53230](source_parts/nswc_part_06.f90#L483) | [Documented](docs/10-banded-matrices.md#topic-217-01) |
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [52131](source_parts/nswc_part_05.f90#L9926) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [50167](source_parts/nswc_part_05.f90#L7962) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `BALANC` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [59527](source_parts/nswc_part_06.f90#L6780) | Not indexed |
| `BALBAK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [60310](source_parts/nswc_part_06.f90#L7563) | Not indexed |
| `BALINV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [59700](source_parts/nswc_part_06.f90#L6953) | Not indexed |
| `BANFAC` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, IFLAG` | [93943](source_parts/nswc_part_09.f90#L9092) | Not indexed |
| `BANSLV` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, B` | [94065](source_parts/nswc_part_09.f90#L9214) | Not indexed |
| `BASIZ` | `SUBROUTINE` | `DEGREE, NPTS, DIMEN, NPOLYS, ERROR` | [100419](source_parts/nswc_part_10.f90#L5052) | Not indexed |
| `BASYM` | `REAL FUNCTION` | `A, B, LAMBDA, EPS` | [16713](source_parts/nswc_part_02.f90#L6181) | Not indexed |
| `BCHFAC` | `SUBROUTINE` | `W, NB, N, DIAG, IFLAG` | [94222](source_parts/nswc_part_09.f90#L9371) | Not indexed |
| `BCHSLV` | `SUBROUTINE` | `W, NB, N, B` | [94341](source_parts/nswc_part_09.f90#L9490) | Not indexed |
| `BCHSV1` | `SUBROUTINE` | `W, NB, N, B, KB, M` | [96977](source_parts/nswc_part_10.f90#L1610) | Not indexed |
| `BCORR` | `REAL FUNCTION` | `A0, B0` | [13555](source_parts/nswc_part_02.f90#L3023) | Not indexed |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [49770](source_parts/nswc_part_05.f90#L7565) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [49906](source_parts/nswc_part_05.f90#L7701) | [Documented](docs/10-banded-matrices.md#topic-202-01) |
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [49748](source_parts/nswc_part_05.f90#L7543) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BDYADD` | `SUBROUTINE` | `KK, I1, I2, IADJ, IEND` | [97520](source_parts/nswc_part_10.f90#L2153) | Not indexed |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [20129](source_parts/nswc_part_02.f90#L9597) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [18171](source_parts/nswc_part_02.f90#L7639) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [13445](source_parts/nswc_part_02.f90#L2913) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [94402](source_parts/nswc_part_09.f90#L9551) | [Documented](docs/18-curve-fitting.md#topic-376-01) |
| `BFIT0` | `SUBROUTINE` | `NDATA, XDATA, YDATA, NORD, NBKPT, BKPT, NCONST, XCONST, YCONST, NDERIV, MODE, COEFF, RNORM, BF, G, MDG, W, MDW, WORK, IWORK` | [94645](source_parts/nswc_part_09.f90#L9794) | Not indexed |
| `BFRAC` | `REAL FUNCTION` | `A, B, X, Y, LAMBDA, EPS` | [16233](source_parts/nswc_part_02.f90#L5701) | Not indexed |
| `BGRAT` | `SUBROUTINE` | `A, B, X, Y, W, EPS, IERR` | [16539](source_parts/nswc_part_02.f90#L6007) | Not indexed |
| `BI` | `REAL FUNCTION` | `X` | [23317](source_parts/nswc_part_03.f90#L2276) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BIA` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [22424](source_parts/nswc_part_03.f90#L1383) | Not indexed |
| `BIE` | `REAL FUNCTION` | `X` | [23464](source_parts/nswc_part_03.f90#L2423) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BII` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [22360](source_parts/nswc_part_03.f90#L1319) | Not indexed |
| `BIM` | `SUBROUTINE` | `Z, CN, W` | [22791](source_parts/nswc_part_03.f90#L1750) | Not indexed |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [49849](source_parts/nswc_part_05.f90#L7644) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BJM` | `SUBROUTINE` | `Z, CN, W` | [22950](source_parts/nswc_part_03.f90#L1909) | Not indexed |
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [55788](source_parts/nswc_part_06.f90#L3041) | [Documented](docs/11-sparse-matrices.md#topic-245-01) |
| `BLKTR1` | `SUBROUTINE` | `N, AN, BN, CN, M, AM, BM, CM, IDIMY, Y, B, W1, W2, W3, WD, WW, WU, PRDCT, CPRDCT` | [117975](source_parts/nswc_part_12.f90#L1067) | Not indexed |
| `BLKTRI` | `SUBROUTINE` | `IFLG, NP, N, AN, BN, CN, MP, M, AM, BM, CM, IDIMY, Y, IERROR, W` | [117761](source_parts/nswc_part_12.f90#L853) | Not indexed |
| `BLND` | `REAL FUNCTION` | `A, B` | [17070](source_parts/nswc_part_02.f90#L6538) | Not indexed |
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [75125](source_parts/nswc_part_08.f90#L1161) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-302-01) |
| `BNDACC` | `SUBROUTINE` | `G, MDG, NB, IP, IR, MT, JT` | [94957](source_parts/nswc_part_09.f90#L10106) | Not indexed |
| `BNDSL` | `SUBROUTINE` | `MODE, G, MDG, NB, IP, IR, X, N, RNORM, IERR` | [95178](source_parts/nswc_part_09.f90#L10327) | Not indexed |
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [52107](source_parts/nswc_part_05.f90#L9902) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [49993](source_parts/nswc_part_05.f90#L7788) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [51043](source_parts/nswc_part_05.f90#L8838) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `BPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [16074](source_parts/nswc_part_02.f90#L5542) | Not indexed |
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [15779](source_parts/nswc_part_02.f90#L5247) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BRCMP1` | `REAL FUNCTION` | `MU, A, B, X, Y` | [16421](source_parts/nswc_part_02.f90#L5889) | Not indexed |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [16302](source_parts/nswc_part_02.f90#L5770) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [49792](source_parts/nswc_part_05.f90#L7587) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [111078](source_parts/nswc_part_11.f90#L4920) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-418-01) |
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [94127](source_parts/nswc_part_09.f90#L9276) | [Documented](docs/18-curve-fitting.md#topic-375-01) |
| `BSLSQ1` | `SUBROUTINE` | `TAU, WGT, NTAU, Z, KZ, M, T, N, K, A, KA, WK, Q, IERR` | [96864](source_parts/nswc_part_10.f90#L1497) | Not indexed |
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [96803](source_parts/nswc_part_10.f90#L1436) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-389-01) |
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [52266](source_parts/nswc_part_05.f90#L10061) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [52349](source_parts/nswc_part_05.f90#L10144) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [93400](source_parts/nswc_part_09.f90#L8549) | [Documented](docs/18-curve-fitting.md#topic-371-01) |
| `BSPVB` | `SUBROUTINE` | `T, K, JHIGH, J, X, LEFT, BLIST` | [93598](source_parts/nswc_part_09.f90#L8747) | Not indexed |
| `BSPVD` | `SUBROUTINE` | `T, K, X, LEFT, DBIATX, IDIM, NDERIV, A` | [93662](source_parts/nswc_part_09.f90#L8811) | Not indexed |
| `BSRH` | `FUNCTION` | `XLL, XRR, IZ, C, A, BH, F, SGN` | [119176](source_parts/nswc_part_12.f90#L2268) | Not indexed |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [19797](source_parts/nswc_part_02.f90#L9265) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [17859](source_parts/nswc_part_02.f90#L7327) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [21714](source_parts/nswc_part_03.f90#L673) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [19441](source_parts/nswc_part_02.f90#L8909) | [Documented](docs/04-special-functions.md#topic-081-01) |
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [93803](source_parts/nswc_part_09.f90#L8952) | [Documented](docs/18-curve-fitting.md#topic-373-01) |
| `BSTRP1` | `SUBROUTINE` | `X, Z, KZ, M, N, T, K, A, KA, WORK, IFLAG` | [96762](source_parts/nswc_part_10.f90#L1395) | Not indexed |
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [96710](source_parts/nswc_part_10.f90#L1343) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-388-01) |
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [50605](source_parts/nswc_part_05.f90#L8400) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51809](source_parts/nswc_part_05.f90#L9604) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51862](source_parts/nswc_part_05.f90#L9657) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [39303](source_parts/nswc_part_04.f90#L7716) | [Documented](docs/08-matrices.md#topic-171-01) |
| `BUP` | `REAL FUNCTION` | `A, B, X, Y, N, EPS` | [16161](source_parts/nswc_part_02.f90#L5629) | Not indexed |
| `BUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, II, K1, K2, N, M, NP1` | [5820](source_parts/nswc_part_01.f90#L5820) | Not indexed |
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [93074](source_parts/nswc_part_09.f90#L8223) | [Documented](docs/18-curve-fitting.md#topic-369-01) |
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [97059](source_parts/nswc_part_10.f90#L1692) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-391-01) |
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [93250](source_parts/nswc_part_09.f90#L8399) | [Documented](docs/18-curve-fitting.md#topic-370-01) |
| `BVALI0` | `SUBROUTINE` | `T, TNEW, BCOEF, N, K, X, W, WK` | [93297](source_parts/nswc_part_09.f90#L8446) | Not indexed |
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51505](source_parts/nswc_part_05.f90#L9300) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51559](source_parts/nswc_part_05.f90#L9354) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [21963](source_parts/nswc_part_03.f90#L922) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CALCSC` | `SUBROUTINE` | `TYPE, N, K, QK` | [31123](source_parts/nswc_part_03.f90#L10082) | Not indexed |
| `CALCT` | `SUBROUTINE` | `BOOL, N, SR, SI, TR, TI, PVR, PVI, ARE, HR, HI, QHR, QHI` | [31928](source_parts/nswc_part_04.f90#L341) | Not indexed |
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [3231](source_parts/nswc_part_01.f90#L3231) | [Documented](docs/02-elementary-operations.md#topic-028-02) |
| `CAUCHY` | `SUBROUTINE` | `NN, BND, PT, Q` | [31632](source_parts/nswc_part_04.f90#L45) | Not indexed |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [33837](source_parts/nswc_part_04.f90#L2250) | [Documented](docs/07-vectors.md#topic-138-01) |
| `CBABK2` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [64844](source_parts/nswc_part_07.f90#L1503) | Not indexed |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [50459](source_parts/nswc_part_05.f90#L8254) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `CBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [64288](source_parts/nswc_part_07.f90#L947) | Not indexed |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [29680](source_parts/nswc_part_03.f90#L8639) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `CBDB` | `SUBROUTINE` | `CZ, CNU, FN, W` | [17522](source_parts/nswc_part_02.f90#L6990) | Not indexed |
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [20726](source_parts/nswc_part_02.f90#L10194) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [53545](source_parts/nswc_part_06.f90#L798) | Not indexed |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [22324](source_parts/nswc_part_03.f90#L1283) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CBJA` | `SUBROUTINE` | `CZ, CNU, W` | [17758](source_parts/nswc_part_02.f90#L7226) | Not indexed |
| `CBJM` | `SUBROUTINE` | `Z, CNU, W` | [17415](source_parts/nswc_part_02.f90#L6883) | Not indexed |
| `CBKA` | `SUBROUTINE` | `Z, CNU, W` | [20872](source_parts/nswc_part_02.f90#L10340) | Not indexed |
| `CBKI` | `SUBROUTINE` | `Z, CNU, W` | [20844](source_parts/nswc_part_02.f90#L10312) | Not indexed |
| `CBKM` | `SUBROUTINE` | `Z, RZ, CNU, W` | [20923](source_parts/nswc_part_02.f90#L10391) | Not indexed |
| `CBKML` | `SUBROUTINE` | `Z, R, ZR, NU, N, W, W0` | [21168](source_parts/nswc_part_03.f90#L127) | Not indexed |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [32200](source_parts/nswc_part_04.f90#L613) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [50109](source_parts/nswc_part_05.f90#L7904) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [51351](source_parts/nswc_part_05.f90#L9146) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `CBRT` | `REAL FUNCTION` | `X` | [2939](source_parts/nswc_part_01.f90#L2939) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `CBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [53722](source_parts/nswc_part_06.f90#L975) | Not indexed |
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [53377](source_parts/nswc_part_06.f90#L630) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [53461](source_parts/nswc_part_06.f90#L714) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [89283](source_parts/nswc_part_09.f90#L4432) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [19759](source_parts/nswc_part_02.f90#L9227) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [17209](source_parts/nswc_part_02.f90#L6677) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [21286](source_parts/nswc_part_03.f90#L245) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [50897](source_parts/nswc_part_05.f90#L8692) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [52008](source_parts/nswc_part_05.f90#L9803) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [52061](source_parts/nswc_part_05.f90#L9856) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51708](source_parts/nswc_part_05.f90#L9503) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51762](source_parts/nswc_part_05.f90#L9557) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [32462](source_parts/nswc_part_04.f90#L875) | [Documented](docs/07-vectors.md#topic-130-01) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [45127](source_parts/nswc_part_05.f90#L2922) | [Documented](docs/08-matrices.md#topic-185-01) |
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [3106](source_parts/nswc_part_01.f90#L3106) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [3135](source_parts/nswc_part_01.f90#L3135) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [33505](source_parts/nswc_part_04.f90#L1918) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [33545](source_parts/nswc_part_04.f90#L1958) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CEEZ` | `SUBROUTINE` | `DEL1, DEL2, SIGMA, C1, C2, C3, N` | [92869](source_parts/nswc_part_09.f90#L8018) | Not indexed |
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [64241](source_parts/nswc_part_07.f90#L900) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-273-01) |
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [64260](source_parts/nswc_part_07.f90#L919) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-274-01) |
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [5933](source_parts/nswc_part_01.f90#L5933) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [6091](source_parts/nswc_part_01.f90#L6091) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERR` | `SUBROUTINE` | `T, FT, GT, PHIT, DEL, IERR, L, LP1, M, NP1, D` | [86900](source_parts/nswc_part_09.f90#L2049) | Not indexed |
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [10533](source_parts/nswc_part_02.f90#L1) | [Documented](docs/04-special-functions.md#topic-062-01) |
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [9160](source_parts/nswc_part_01.f90#L9160) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `CFLECT` | `COMPLEX FUNCTION` | `Z` | [23937](source_parts/nswc_part_03.f90#L2896) | Not indexed |
| `CFOD` | `SUBROUTINE` | `METH, ELCO, TESCO` | [115306](source_parts/nswc_part_11.f90#L9148) | Not indexed |
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [8756](source_parts/nswc_part_01.f90#L8756) | [Documented](docs/04-special-functions.md#topic-056-01) |
| `CGAM0` | `COMPLEX FUNCTION` | `Z` | [11290](source_parts/nswc_part_02.f90#L758) | Not indexed |
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [11048](source_parts/nswc_part_02.f90#L516) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `CGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [42599](source_parts/nswc_part_05.f90#L394) | Not indexed |
| `CGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [43033](source_parts/nswc_part_05.f90#L828) | Not indexed |
| `CGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [42800](source_parts/nswc_part_05.f90#L595) | Not indexed |
| `CGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [42911](source_parts/nswc_part_05.f90#L706) | Not indexed |
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [86576](source_parts/nswc_part_09.f90#L1725) | [Documented](docs/17-approximation-of-functions.md#topic-327-01) |
| `CHEBY1` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, LP1, MP1, LPM, N, NP1, X, XVAL, C, D, ERR, H` | [86613](source_parts/nswc_part_09.f90#L1762) | Not indexed |
| `CHKPRM` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, C, D, N, NBDCND, COFX, COFY, IDMN, MN, IERROR` | [117231](source_parts/nswc_part_12.f90#L323) | Not indexed |
| `CHKSNG` | `SUBROUTINE` | `MBDCND, NBDCND, ALPHA, BETA, GAMA, XNU, COFX, COFY, SINGLR` | [117306](source_parts/nswc_part_12.f90#L398) | Not indexed |
| `CIN` | `FUNCTION` | `X` | [10411](source_parts/nswc_part_01.f90#L10411) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [26770](source_parts/nswc_part_03.f90#L5729) | [Documented](docs/04-special-functions.md#topic-107-01) |
| `CK` | `COMPLEX FUNCTION` | `K, L` | [23709](source_parts/nswc_part_03.f90#L2668) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKA` | `SUBROUTINE` | `Z, NU, W` | [21411](source_parts/nswc_part_03.f90#L370) | Not indexed |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [24066](source_parts/nswc_part_03.f90#L3025) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKM` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [21462](source_parts/nswc_part_03.f90#L421) | Not indexed |
| `CKML` | `SUBROUTINE` | `Z, R, ZR, NU, K1, K2` | [21580](source_parts/nswc_part_03.f90#L539) | Not indexed |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [35922](source_parts/nswc_part_04.f90#L4335) | [Documented](docs/08-matrices.md#topic-160-01) |
| `CKPS` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [21042](source_parts/nswc_part_03.f90#L1) | Not indexed |
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [66416](source_parts/nswc_part_07.f90#L3075) | [Documented](docs/13-l1-solution-of-linear-equations.md#topic-279-01) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [48593](source_parts/nswc_part_05.f90#L6388) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `CLI` | `COMPLEX FUNCTION` | `Z` | [10769](source_parts/nswc_part_02.f90#L237) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `CLOC` | `LOGICAL FUNCTION` | `X, Y` | [35721](source_parts/nswc_part_04.f90#L4134) | Not indexed |
| `CLUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [42509](source_parts/nswc_part_05.f90#L304) | Not indexed |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [35284](source_parts/nswc_part_04.f90#L3697) | [Documented](docs/08-matrices.md#topic-151-01) |
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [35194](source_parts/nswc_part_04.f90#L3607) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34743](source_parts/nswc_part_04.f90#L3156) | [Documented](docs/08-matrices.md#topic-147-01) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34728](source_parts/nswc_part_04.f90#L3141) | [Documented](docs/08-matrices.md#topic-146-01) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [49494](source_parts/nswc_part_05.f90#L7289) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [49685](source_parts/nswc_part_05.f90#L7480) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34668](source_parts/nswc_part_04.f90#L3081) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [35664](source_parts/nswc_part_04.f90#L4077) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34652](source_parts/nswc_part_04.f90#L3065) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [42386](source_parts/nswc_part_05.f90#L181) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [42430](source_parts/nswc_part_05.f90#L225) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [35354](source_parts/nswc_part_04.f90#L3767) | [Documented](docs/08-matrices.md#topic-153-01) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [35433](source_parts/nswc_part_04.f90#L3846) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [58610](source_parts/nswc_part_06.f90#L5863) | Not indexed |
| `COMPB` | `SUBROUTINE` | `N, IERROR, AN, BN, CN, B, AH, BH` | [118718](source_parts/nswc_part_12.f90#L1810) | Not indexed |
| `COMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [64609](source_parts/nswc_part_07.f90#L1268) | Not indexed |
| `COMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [64927](source_parts/nswc_part_07.f90#L1586) | Not indexed |
| `CONEW` | `FUNCTION` | `COND, ELINSY, RELRSD, AVERR, PASTC, PASTRE` | [109472](source_parts/nswc_part_11.f90#L3314) | Not indexed |
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [3462](source_parts/nswc_part_01.f90#L3462) | [Documented](docs/02-elementary-operations.md#topic-031-01) |
| `CORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [64475](source_parts/nswc_part_07.f90#L1134) | Not indexed |
| `COS0` | `REAL FUNCTION` | `X` | [3569](source_parts/nswc_part_01.f90#L3569) | Not indexed |
| `COS1` | `REAL FUNCTION` | `X` | [3643](source_parts/nswc_part_01.f90#L3643) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [85020](source_parts/nswc_part_09.f90#L169) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQB1` | `SUBROUTINE` | `N, X, W, XH` | [85039](source_parts/nswc_part_09.f90#L188) | Not indexed |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [84921](source_parts/nswc_part_09.f90#L70) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQF1` | `SUBROUTINE` | `N, X, W, XH` | [84938](source_parts/nswc_part_09.f90#L87) | Not indexed |
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [84852](source_parts/nswc_part_09.f90#L1) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COVAR` | `SUBROUTINE` | `N, M1, N1, IPIVOT, C, D, Z, NN` | [74192](source_parts/nswc_part_08.f90#L228) | Not indexed |
| `CPABS` | `REAL FUNCTION` | `X, Y` | [3020](source_parts/nswc_part_01.f90#L3020) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [54623](source_parts/nswc_part_06.f90#L1876) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [54687](source_parts/nswc_part_06.f90#L1940) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, W, Y` | [118485](source_parts/nswc_part_12.f90#L1577) | Not indexed |
| `CPRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, U, Y` | [118590](source_parts/nswc_part_12.f90#L1682) | Not indexed |
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [88170](source_parts/nswc_part_09.f90#L3319) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `CPSI` | `SUBROUTINE` | `Z, W` | [12366](source_parts/nswc_part_02.f90#L1834) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `CQEXT` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES` | [83018](source_parts/nswc_part_08.f90#L9054) | Not indexed |
| `CQZHES` | `SUBROUTINE` | `NM, N, A, B, MATS, Z, F, G, H` | [47366](source_parts/nswc_part_05.f90#L5161) | Not indexed |
| `CQZIT` | `SUBROUTINE` | `NM, N, A, B, EPS1, MATS, Z, F, IERR` | [47578](source_parts/nswc_part_05.f90#L5373) | Not indexed |
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [3061](source_parts/nswc_part_01.f90#L3061) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [36063](source_parts/nswc_part_04.f90#L4476) | [Documented](docs/08-matrices.md#topic-163-01) |
| `CROUT1` | `SUBROUTINE` | `A, KA, N, IEND, INDEX, TEMP, JP, IERR` | [80765](source_parts/nswc_part_08.f90#L6801) | Not indexed |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [54882](source_parts/nswc_part_06.f90#L2135) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [33674](source_parts/nswc_part_04.f90#L2087) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54301](source_parts/nswc_part_06.f90#L1554) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [28256](source_parts/nswc_part_03.f90#L7215) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54146](source_parts/nswc_part_06.f90#L1399) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [90375](source_parts/nswc_part_09.f90#L5524) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [90477](source_parts/nswc_part_09.f90#L5626) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [90593](source_parts/nswc_part_09.f90#L5742) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [91083](source_parts/nswc_part_09.f90#L6232) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `CSLOP1` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, A, B, C, E, IERR` | [91120](source_parts/nswc_part_09.f90#L6269) | Not indexed |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [58888](source_parts/nswc_part_06.f90#L6141) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [58992](source_parts/nswc_part_06.f90#L6245) | Not indexed |
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [42474](source_parts/nswc_part_05.f90#L269) | [Documented](docs/08-matrices.md#topic-182-01) |
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [89646](source_parts/nswc_part_09.f90#L4795) | [Documented](docs/18-curve-fitting.md#topic-345-01) |
| `CSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [59199](source_parts/nswc_part_06.f90#L6452) | Not indexed |
| `CSPP` | `SUBROUTINE` | `T, A, KA, M, N, Z, KZ, DZ, KDZ` | [95506](source_parts/nswc_part_10.f90#L139) | Not indexed |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [55252](source_parts/nswc_part_06.f90#L2505) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [58489](source_parts/nswc_part_06.f90#L5742) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54114](source_parts/nswc_part_06.f90#L1367) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [95804](source_parts/nswc_part_10.f90#L437) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [95963](source_parts/nswc_part_10.f90#L596) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [32825](source_parts/nswc_part_04.f90#L1238) | [Documented](docs/07-vectors.md#topic-132-01) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [33704](source_parts/nswc_part_04.f90#L2117) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [55074](source_parts/nswc_part_06.f90#L2327) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [95621](source_parts/nswc_part_10.f90#L254) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [95785](source_parts/nswc_part_10.f90#L418) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [44469](source_parts/nswc_part_05.f90#L2264) | [Documented](docs/08-matrices.md#topic-183-01) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [32706](source_parts/nswc_part_04.f90#L1119) | [Documented](docs/07-vectors.md#topic-131-01) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [35033](source_parts/nswc_part_04.f90#L3446) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34788](source_parts/nswc_part_04.f90#L3201) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55567](source_parts/nswc_part_06.f90#L2820) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55596](source_parts/nswc_part_06.f90#L2849) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [35209](source_parts/nswc_part_04.f90#L3622) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [59039](source_parts/nswc_part_06.f90#L6292) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [59143](source_parts/nswc_part_06.f90#L6396) | Not indexed |
| `CUBRUL` | `SUBROUTINE` | `F, VEC, P, IDATA, RDATA` | [108766](source_parts/nswc_part_11.f90#L2608) | Not indexed |
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [108550](source_parts/nswc_part_11.f90#L2392) | [Documented](docs/22-numerical-integration.md#topic-408-01) |
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [91438](source_parts/nswc_part_09.f90#L6587) | [Documented](docs/18-curve-fitting.md#topic-357-01) |
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [91596](source_parts/nswc_part_09.f90#L6745) | [Documented](docs/18-curve-fitting.md#topic-359-01) |
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [91686](source_parts/nswc_part_09.f90#L6835) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [91768](source_parts/nswc_part_09.f90#L6917) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [49167](source_parts/nswc_part_05.f90#L6962) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [48970](source_parts/nswc_part_05.f90#L6765) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [48773](source_parts/nswc_part_05.f90#L6568) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [49238](source_parts/nswc_part_05.f90#L7033) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [49309](source_parts/nswc_part_05.f90#L7104) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [53931](source_parts/nswc_part_06.f90#L1184) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [49041](source_parts/nswc_part_05.f90#L6836) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [49112](source_parts/nswc_part_05.f90#L6907) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [53896](source_parts/nswc_part_06.f90#L1149) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55517](source_parts/nswc_part_06.f90#L2770) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55542](source_parts/nswc_part_06.f90#L2795) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [48844](source_parts/nswc_part_05.f90#L6639) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [48915](source_parts/nswc_part_05.f90#L6710) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [53861](source_parts/nswc_part_06.f90#L1114) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [54029](source_parts/nswc_part_06.f90#L1282) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [53998](source_parts/nswc_part_06.f90#L1251) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [53967](source_parts/nswc_part_06.f90#L1220) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CXP` | `COMPLEX FUNCTION` | `N, NU` | [21679](source_parts/nswc_part_03.f90#L638) | Not indexed |
| `CYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [35755](source_parts/nswc_part_04.f90#L4168) | Not indexed |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [45797](source_parts/nswc_part_05.f90#L3592) | [Documented](docs/08-matrices.md#topic-186-01) |
| `DABSV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [45880](source_parts/nswc_part_05.f90#L3675) | Not indexed |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [8026](source_parts/nswc_part_01.f90#L8026) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `DAORD` | `SUBROUTINE` | `A, N` | [2052](source_parts/nswc_part_01.f90#L2052) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [2999](source_parts/nswc_part_01.f90#L2999) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [33919](source_parts/nswc_part_04.f90#L2332) | [Documented](docs/07-vectors.md#topic-139-01) |
| `DAW` | `REAL FUNCTION` | `X` | [8302](source_parts/nswc_part_01.f90#L8302) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [33786](source_parts/nswc_part_04.f90#L2199) | [Documented](docs/07-vectors.md#topic-138-01) |
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [53304](source_parts/nswc_part_06.f90#L557) | [Documented](docs/10-banded-matrices.md#topic-221-01) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [52210](source_parts/nswc_part_05.f90#L10005) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `DBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [61773](source_parts/nswc_part_06.f90#L9026) | Not indexed |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [50313](source_parts/nswc_part_05.f90#L8108) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `DBAL` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [61187](source_parts/nswc_part_06.f90#L8440) | Not indexed |
| `DBALNV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [61360](source_parts/nswc_part_06.f90#L8613) | Not indexed |
| `DBCORR` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [13771](source_parts/nswc_part_02.f90#L3239) | Not indexed |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [13659](source_parts/nswc_part_02.f90#L3127) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `DBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [52914](source_parts/nswc_part_06.f90#L167) | Not indexed |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [52186](source_parts/nswc_part_05.f90#L9981) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [50051](source_parts/nswc_part_05.f90#L7846) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [51197](source_parts/nswc_part_05.f90#L8992) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `DBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [53091](source_parts/nswc_part_06.f90#L344) | Not indexed |
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [52748](source_parts/nswc_part_06.f90#L1) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [52831](source_parts/nswc_part_06.f90#L84) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [50751](source_parts/nswc_part_05.f90#L8546) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51908](source_parts/nswc_part_05.f90#L9703) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51962](source_parts/nswc_part_05.f90#L9757) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51606](source_parts/nswc_part_05.f90#L9401) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [51661](source_parts/nswc_part_05.f90#L9456) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DCBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [65931](source_parts/nswc_part_07.f90#L2590) | Not indexed |
| `DCBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [65381](source_parts/nswc_part_07.f90#L2040) | Not indexed |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [29883](source_parts/nswc_part_03.f90#L8842) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [2958](source_parts/nswc_part_01.f90#L2958) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [65331](source_parts/nswc_part_07.f90#L1990) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-276-01) |
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [65350](source_parts/nswc_part_07.f90#L2009) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-277-01) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [6522](source_parts/nswc_part_01.f90#L6522) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [6804](source_parts/nswc_part_01.f90#L6804) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCFACT` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, IERR` | [43205](source_parts/nswc_part_05.f90#L1000) | Not indexed |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [11719](source_parts/nswc_part_02.f90#L1187) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DCMINV` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, TEMP` | [43407](source_parts/nswc_part_05.f90#L1202) | Not indexed |
| `DCMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [66015](source_parts/nswc_part_07.f90#L2674) | Not indexed |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [43168](source_parts/nswc_part_05.f90#L963) | [Documented](docs/08-matrices.md#topic-178-01) |
| `DCOMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [65700](source_parts/nswc_part_07.f90#L2359) | Not indexed |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [32409](source_parts/nswc_part_04.f90#L822) | [Documented](docs/07-vectors.md#topic-130-01) |
| `DCORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [65567](source_parts/nswc_part_07.f90#L2226) | Not indexed |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [3798](source_parts/nswc_part_01.f90#L3798) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [3040](source_parts/nswc_part_01.f90#L3040) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `DCPLY1` | `SUBROUTINE` | `OPR, OPI, IDEG, IDP1, ZEROR, ZEROI, PR, PI, QPR, QPI, HR, HI, QHR, QHI, SHR, SHI, NUM` | [31437](source_parts/nswc_part_03.f90#L10396) | Not indexed |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [31368](source_parts/nswc_part_03.f90#L10327) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [88418](source_parts/nswc_part_09.f90#L3567) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [12685](source_parts/nswc_part_02.f90#L2153) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [3083](source_parts/nswc_part_01.f90#L3083) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [28286](source_parts/nswc_part_03.f90#L7245) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `DCSOL` | `SUBROUTINE` | `N, M, AR, AI, KA, BR, BI, KB, IPVT` | [43314](source_parts/nswc_part_05.f90#L1109) | Not indexed |
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [3171](source_parts/nswc_part_01.f90#L3171) | [Documented](docs/02-elementary-operations.md#topic-026-03) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [33454](source_parts/nswc_part_04.f90#L1867) | [Documented](docs/07-vectors.md#topic-136-01) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [1943](source_parts/nswc_part_01.f90#L1943) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DE1` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YY, WT, P, YP, YPOUT, PHI, ALPHA, BETA, SIG, V, W, G, PHASE1, PSI, X, H, HOLD, START, TOLD, DELSGN, NS, NORND, K, KOLD, ISNOLD` | [110313](source_parts/nswc_part_11.f90#L4155) | Not indexed |
| `DE1E` | `DOUBLE PRECISION FUNCTION` | `X` | [9720](source_parts/nswc_part_01.f90#L9720) | Not indexed |
| `DEC` | `SUBROUTINE` | `N, NDIM, A, IP, IER` | [36483](source_parts/nswc_part_04.f90#L4896) | Not indexed |
| `DECBT` | `SUBROUTINE` | `M, N, A, B, C, IP, IER` | [39323](source_parts/nswc_part_04.f90#L7736) | Not indexed |
| `DECOM2` | `SUBROUTINE` | `M, N, M1, ETA, TOL, QR, D, N1, IPIVOT, SING, MMPNN` | [73770](source_parts/nswc_part_07.f90#L10429) | Not indexed |
| `DEFER` | `SUBROUTINE` | `COFX, COFY, USOL, IDMN, GRHS, MN` | [117517](source_parts/nswc_part_12.f90#L609) | Not indexed |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [9691](source_parts/nswc_part_01.f90#L9691) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEI0` | `DOUBLE PRECISION FUNCTION` | `X, EPS` | [10194](source_parts/nswc_part_01.f90#L10194) | Not indexed |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [9705](source_parts/nswc_part_01.f90#L9705) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [61134](source_parts/nswc_part_06.f90#L8387) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-266-01) |
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [61153](source_parts/nswc_part_06.f90#L8406) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-267-01) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [24650](source_parts/nswc_part_03.f90#L3609) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [24858](source_parts/nswc_part_03.f90#L3817) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [1400](source_parts/nswc_part_01.f90#L1400) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [7233](source_parts/nswc_part_01.f90#L7233) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [7293](source_parts/nswc_part_01.f90#L7293) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC0` | `DOUBLE PRECISION FUNCTION` | `X` | [7442](source_parts/nswc_part_01.f90#L7442) | Not indexed |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [7359](source_parts/nswc_part_01.f90#L7359) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [7730](source_parts/nswc_part_01.f90#L7730) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `DESUM` | `DOUBLE PRECISION FUNCTION` | `MU, X` | [4030](source_parts/nswc_part_01.f90#L4030) | Not indexed |
| `DET` | `FUNCTION` | `A, KA, N, X` | [44981](source_parts/nswc_part_05.f90#L2776) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [121405](source_parts/nswc_part_12.f90#L4497) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `DGAM1` | `DOUBLE PRECISION FUNCTION` | `X` | [12141](source_parts/nswc_part_02.f90#L1609) | Not indexed |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [12309](source_parts/nswc_part_02.f90#L1777) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [11995](source_parts/nswc_part_02.f90#L1463) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [37712](source_parts/nswc_part_04.f90#L6125) | Not indexed |
| `DGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [38138](source_parts/nswc_part_04.f90#L6551) | Not indexed |
| `DGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [37909](source_parts/nswc_part_04.f90#L6322) | Not indexed |
| `DGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [38017](source_parts/nswc_part_04.f90#L6430) | Not indexed |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [15451](source_parts/nswc_part_02.f90#L4919) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `DGMLN1` | `DOUBLE PRECISION FUNCTION` | `X` | [12352](source_parts/nswc_part_02.f90#L1820) | Not indexed |
| `DGNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [101427](source_parts/nswc_part_10.f90#L6060) | Not indexed |
| `DGR17` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [15341](source_parts/nswc_part_02.f90#L4809) | Not indexed |
| `DGR29` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [15029](source_parts/nswc_part_02.f90#L4497) | Not indexed |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [14765](source_parts/nswc_part_02.f90#L4233) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DGSMLN` | `DOUBLE PRECISION FUNCTION` | `A, B` | [13750](source_parts/nswc_part_02.f90#L3218) | Not indexed |
| `DH12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [70836](source_parts/nswc_part_07.f90#L7495) | Not indexed |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [70309](source_parts/nswc_part_07.f90#L6968) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [70559](source_parts/nswc_part_07.f90#L7218) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [61544](source_parts/nswc_part_06.f90#L8797) | Not indexed |
| `DHQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [62024](source_parts/nswc_part_06.f90#L9277) | Not indexed |
| `DINCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [101508](source_parts/nswc_part_10.f90#L6141) | Not indexed |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [1886](source_parts/nswc_part_01.f90#L1886) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [35891](source_parts/nswc_part_04.f90#L4304) | [Documented](docs/08-matrices.md#topic-160-01) |
| `DLGDIV` | `DOUBLE PRECISION FUNCTION` | `A, B` | [13845](source_parts/nswc_part_02.f90#L3313) | Not indexed |
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [67249](source_parts/nswc_part_07.f90#L3908) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [4275](source_parts/nswc_part_01.f90#L4275) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DLOC` | `LOGICAL FUNCTION` | `X, Y` | [35619](source_parts/nswc_part_04.f90#L4032) | Not indexed |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [68593](source_parts/nswc_part_07.f90#L5252) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [35265](source_parts/nswc_part_04.f90#L3678) | [Documented](docs/08-matrices.md#topic-151-01) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34713](source_parts/nswc_part_04.f90#L3126) | [Documented](docs/08-matrices.md#topic-146-01) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [49429](source_parts/nswc_part_05.f90#L7224) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [34529](source_parts/nswc_part_04.f90#L2942) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [49622](source_parts/nswc_part_05.f90#L7417) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [34575](source_parts/nswc_part_04.f90#L2988) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [101781](source_parts/nswc_part_10.f90#L6414) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMEVL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [101937](source_parts/nswc_part_10.f90#L6570) | Not indexed |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [48088](source_parts/nswc_part_05.f90#L5883) | [Documented](docs/08-matrices.md#topic-191-01) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [101251](source_parts/nswc_part_10.f90#L5884) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [35562](source_parts/nswc_part_04.f90#L3975) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [37624](source_parts/nswc_part_04.f90#L6037) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [37668](source_parts/nswc_part_04.f90#L6081) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [35335](source_parts/nswc_part_04.f90#L3748) | [Documented](docs/08-matrices.md#topic-153-01) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [35410](source_parts/nswc_part_04.f90#L3823) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [34125](source_parts/nswc_part_04.f90#L2538) | [Documented](docs/07-vectors.md#topic-140-01) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [120279](source_parts/nswc_part_12.f90#L3371) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [120559](source_parts/nswc_part_12.f90#L3651) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [120696](source_parts/nswc_part_12.f90#L3788) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [57214](source_parts/nswc_part_06.f90#L4467) | Not indexed |
| `DOGLEG` | `SUBROUTINE` | `N, R, LR, DIAG, QTB, DELTA, X, WA1, WA2` | [77570](source_parts/nswc_part_08.f90#L3606) | Not indexed |
| `DONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [58321](source_parts/nswc_part_06.f90#L5574) | Not indexed |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [2863](source_parts/nswc_part_01.f90#L2863) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [67394](source_parts/nswc_part_07.f90#L4053) | Not indexed |
| `DORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [61435](source_parts/nswc_part_06.f90#L8688) | Not indexed |
| `DORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [67283](source_parts/nswc_part_07.f90#L3942) | Not indexed |
| `DORTRN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [61848](source_parts/nswc_part_06.f90#L9101) | Not indexed |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [27681](source_parts/nswc_part_03.f90#L6640) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [41882](source_parts/nswc_part_04.f90#L10295) | [Documented](docs/08-matrices.md#topic-176-01) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [27627](source_parts/nswc_part_03.f90#L6586) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [8447](source_parts/nswc_part_01.f90#L8447) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DPDAW0` | `DOUBLE PRECISION FUNCTION` | `X` | [8555](source_parts/nswc_part_01.f90#L8555) | Not indexed |
| `DPDEL` | `DOUBLE PRECISION FUNCTION` | `X` | [12097](source_parts/nswc_part_02.f90#L1565) | Not indexed |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [45055](source_parts/nswc_part_05.f90#L2850) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [27899](source_parts/nswc_part_03.f90#L6858) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [28134](source_parts/nswc_part_03.f90#L7093) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [48422](source_parts/nswc_part_05.f90#L6217) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [28016](source_parts/nswc_part_03.f90#L6975) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [1311](source_parts/nswc_part_01.f90#L1311) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [27798](source_parts/nswc_part_03.f90#L6757) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [8244](source_parts/nswc_part_01.f90#L8244) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [54492](source_parts/nswc_part_06.f90#L1745) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [54556](source_parts/nswc_part_06.f90#L1809) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [42075](source_parts/nswc_part_04.f90#L10488) | Not indexed |
| `DPPFA` | `SUBROUTINE` | `AP, N, INFO` | [41912](source_parts/nswc_part_04.f90#L10325) | Not indexed |
| `DPPSL` | `SUBROUTINE` | `AP, N, B` | [42005](source_parts/nswc_part_04.f90#L10418) | Not indexed |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [12861](source_parts/nswc_part_02.f90#L2329) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DPSI0` | `DOUBLE PRECISION FUNCTION` | `X` | [13055](source_parts/nswc_part_02.f90#L2523) | Not indexed |
| `DPSLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [36758](source_parts/nswc_part_04.f90#L5171) | Not indexed |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [27731](source_parts/nswc_part_03.f90#L6690) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [106351](source_parts/nswc_part_11.f90#L193) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `DQAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [106538](source_parts/nswc_part_11.f90#L380) | Not indexed |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [105525](source_parts/nswc_part_10.f90#L10158) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [105704](source_parts/nswc_part_10.f90#L10337) | Not indexed |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [29613](source_parts/nswc_part_03.f90#L8572) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [107337](source_parts/nswc_part_11.f90#L1179) | Not indexed |
| `DQK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [107006](source_parts/nswc_part_11.f90#L848) | Not indexed |
| `DQK21` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [106159](source_parts/nswc_part_11.f90#L1) | Not indexed |
| `DQPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [107200](source_parts/nswc_part_11.f90#L1042) | Not indexed |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [30258](source_parts/nswc_part_03.f90#L9217) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQXCPY` | `SUBROUTINE` | `A, B, L` | [108119](source_parts/nswc_part_11.f90#L1961) | Not indexed |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [107519](source_parts/nswc_part_11.f90#L1361) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [107692](source_parts/nswc_part_11.f90#L1534) | Not indexed |
| `DQXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [108136](source_parts/nswc_part_11.f90#L1978) | Not indexed |
| `DQXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [108452](source_parts/nswc_part_11.f90#L2294) | Not indexed |
| `DQXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [108252](source_parts/nswc_part_11.f90#L2094) | Not indexed |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [121203](source_parts/nswc_part_12.f90#L4295) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [120039](source_parts/nswc_part_12.f90#L3131) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `DRCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [120056](source_parts/nswc_part_12.f90#L3148) | Not indexed |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [14394](source_parts/nswc_part_02.f90#L3862) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DRCVL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [25787](source_parts/nswc_part_03.f90#L4746) | Not indexed |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [25276](source_parts/nswc_part_03.f90#L4235) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [4086](source_parts/nswc_part_01.f90#L4086) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `DREXP1` | `SUBROUTINE` | `X, E, W` | [4180](source_parts/nswc_part_01.f90#L4180) | Not indexed |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [25037](source_parts/nswc_part_03.f90#L3996) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [121044](source_parts/nswc_part_12.f90#L4136) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [25542](source_parts/nswc_part_03.f90#L4501) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [4434](source_parts/nswc_part_01.f90#L4434) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [4515](source_parts/nswc_part_01.f90#L4515) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [121811](source_parts/nswc_part_12.f90#L4903) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [120893](source_parts/nswc_part_12.f90#L3985) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [36008](source_parts/nswc_part_04.f90#L4421) | [Documented](docs/08-matrices.md#topic-161-01) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [120196](source_parts/nswc_part_12.f90#L3288) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [32785](source_parts/nswc_part_04.f90#L1198) | [Documented](docs/07-vectors.md#topic-132-01) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [3342](source_parts/nswc_part_01.f90#L3342) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [33288](source_parts/nswc_part_04.f90#L1701) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [33135](source_parts/nswc_part_04.f90#L1548) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DRPLY1` | `SUBROUTINE` | `OP, IDEG, IDP1, ZEROR, ZEROI, P, QP, K, QK, SVK, TEMP, PT, NUM` | [30485](source_parts/nswc_part_03.f90#L9444) | Not indexed |
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [30421](source_parts/nswc_part_03.f90#L9380) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DRTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [61934](source_parts/nswc_part_06.f90#L9187) | Not indexed |
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [58088](source_parts/nswc_part_06.f90#L5341) | [Documented](docs/11-sparse-matrices.md#topic-256-01) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [55710](source_parts/nswc_part_06.f90#L2963) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [54818](source_parts/nswc_part_06.f90#L2071) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [33629](source_parts/nswc_part_04.f90#L2042) | [Documented](docs/07-vectors.md#topic-137-01) |
| `DSCALD` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [101751](source_parts/nswc_part_10.f90#L6384) | Not indexed |
| `DSCALP` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [101712](source_parts/nswc_part_10.f90#L6345) | Not indexed |
| `DSCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [45997](source_parts/nswc_part_05.f90#L3792) | Not indexed |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54272](source_parts/nswc_part_06.f90#L1525) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [63510](source_parts/nswc_part_07.f90#L169) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-271-01) |
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [63533](source_parts/nswc_part_07.f90#L192) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-272-01) |
| `DSHSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [46275](source_parts/nswc_part_05.f90#L4070) | Not indexed |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [3700](source_parts/nswc_part_01.f90#L3700) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [57488](source_parts/nswc_part_06.f90#L4741) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [57592](source_parts/nswc_part_06.f90#L4845) | Not indexed |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [40532](source_parts/nswc_part_04.f90#L8945) | [Documented](docs/08-matrices.md#topic-173-01) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [55684](source_parts/nswc_part_06.f90#L2937) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `DSORT` | `SUBROUTINE` | `A, N` | [1835](source_parts/nswc_part_01.f90#L1835) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [40573](source_parts/nswc_part_04.f90#L8986) | Not indexed |
| `DSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [41315](source_parts/nswc_part_04.f90#L9728) | Not indexed |
| `DSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [40862](source_parts/nswc_part_04.f90#L9275) | Not indexed |
| `DSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [57799](source_parts/nswc_part_06.f90#L5052) | Not indexed |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [55195](source_parts/nswc_part_06.f90#L2448) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `DSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [41131](source_parts/nswc_part_04.f90#L9544) | Not indexed |
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [57090](source_parts/nswc_part_06.f90#L4343) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [55010](source_parts/nswc_part_06.f90#L2263) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `DSTOR2` | `SUBROUTINE` | `A, B` | [1240](source_parts/nswc_part_01.f90#L1240) | Not indexed |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [43985](source_parts/nswc_part_05.f90#L1780) | [Documented](docs/08-matrices.md#topic-183-01) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [35795](source_parts/nswc_part_04.f90#L4208) | [Documented](docs/08-matrices.md#topic-157-01) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [32647](source_parts/nswc_part_04.f90#L1060) | [Documented](docs/07-vectors.md#topic-131-01) |
| `DSYMSV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [46874](source_parts/nswc_part_05.f90#L4669) | Not indexed |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [46702](source_parts/nswc_part_05.f90#L4497) | [Documented](docs/08-matrices.md#topic-188-01) |
| `DTASV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [46765](source_parts/nswc_part_05.f90#L4560) | Not indexed |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [34918](source_parts/nswc_part_04.f90#L3331) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [42296](source_parts/nswc_part_05.f90#L91) | [Documented](docs/08-matrices.md#topic-177-01) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34773](source_parts/nswc_part_04.f90#L3186) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55463](source_parts/nswc_part_06.f90#L2716) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55492](source_parts/nswc_part_06.f90#L2745) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTQL` | `SUBROUTINE` | `N, D, E2, IERR` | [63784](source_parts/nswc_part_07.f90#L443) | Not indexed |
| `DTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [64065](source_parts/nswc_part_07.f90#L724) | Not indexed |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [121601](source_parts/nswc_part_12.f90#L4693) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `DTRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [63550](source_parts/nswc_part_07.f90#L209) | Not indexed |
| `DTRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [63923](source_parts/nswc_part_07.f90#L582) | Not indexed |
| `DTRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [63668](source_parts/nswc_part_07.f90#L327) | Not indexed |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [57639](source_parts/nswc_part_06.f90#L4892) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [57743](source_parts/nswc_part_06.f90#L4996) | Not indexed |
| `DU11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [68852](source_parts/nswc_part_07.f90#L5511) | Not indexed |
| `DU11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [69272](source_parts/nswc_part_07.f90#L5931) | Not indexed |
| `DU12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [69124](source_parts/nswc_part_07.f90#L5783) | Not indexed |
| `DU12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [69544](source_parts/nswc_part_07.f90#L6203) | Not indexed |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [119422](source_parts/nswc_part_12.f90#L2514) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `DURNG0` | `SUBROUTINE` | `IX, U, V` | [119575](source_parts/nswc_part_12.f90#L2667) | Not indexed |
| `DURNG1` | `SUBROUTINE` | `IX, U, V, D` | [119722](source_parts/nswc_part_12.f90#L2814) | Not indexed |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [119865](source_parts/nswc_part_12.f90#L2957) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55413](source_parts/nswc_part_06.f90#L2666) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55438](source_parts/nswc_part_06.f90#L2691) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DXFN` | `SUBROUTINE` | `U, IDMN, I, J, UXXX, UXXXX` | [117586](source_parts/nswc_part_12.f90#L678) | Not indexed |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [1469](source_parts/nswc_part_01.f90#L1469) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [35653](source_parts/nswc_part_04.f90#L4066) | Not indexed |
| `DYFN` | `SUBROUTINE` | `U, IDMN, I, J, UYYY, UYYYY` | [117673](source_parts/nswc_part_12.f90#L765) | Not indexed |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [28826](source_parts/nswc_part_03.f90#L7785) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [59421](source_parts/nswc_part_06.f90#L6674) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [59440](source_parts/nswc_part_06.f90#L6693) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [59459](source_parts/nswc_part_06.f90#L6712) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [59493](source_parts/nswc_part_06.f90#L6746) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EKL` | `SUBROUTINE` | `L, FK, FL, EK, EL, GK, GL` | [24408](source_parts/nswc_part_03.f90#L3367) | Not indexed |
| `EKM` | `SUBROUTINE` | `K2, FK, EK` | [24366](source_parts/nswc_part_03.f90#L3325) | Not indexed |
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [25883](source_parts/nswc_part_03.f90#L4842) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [24506](source_parts/nswc_part_03.f90#L3465) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `ELMHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [59775](source_parts/nswc_part_06.f90#L7028) | Not indexed |
| `ELMHS0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [59874](source_parts/nswc_part_06.f90#L7127) | Not indexed |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [26204](source_parts/nswc_part_03.f90#L5163) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [60385](source_parts/nswc_part_06.f90#L7638) | Not indexed |
| `ELTRN0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [60463](source_parts/nswc_part_06.f90#L7716) | Not indexed |
| `ENORM` | `REAL FUNCTION` | `N, X` | [77462](source_parts/nswc_part_08.f90#L3498) | Not indexed |
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [24794](source_parts/nswc_part_03.f90#L3753) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `EPSLN` | `REAL FUNCTION` | `L` | [1370](source_parts/nswc_part_01.f90#L1370) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `ERF` | `REAL FUNCTION` | `X` | [6272](source_parts/nswc_part_01.f90#L6272) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC` | `REAL FUNCTION` | `X` | [6336](source_parts/nswc_part_01.f90#L6336) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC0` | `SUBROUTINE` | `IND, X, E, Y` | [27024](source_parts/nswc_part_03.f90#L5983) | Not indexed |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [6424](source_parts/nswc_part_01.f90#L6424) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFCM2` | `SUBROUTINE` | `MO, Z, W` | [7091](source_parts/nswc_part_01.f90#L7091) | Not indexed |
| `ERFCR` | `REAL FUNCTION` | `X` | [27128](source_parts/nswc_part_03.f90#L6087) | Not indexed |
| `ERFI` | `REAL FUNCTION` | `P, Q` | [7607](source_parts/nswc_part_01.f90#L7607) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `ERREV` | `DOUBLE PRECISION FUNCTION` | `NN, QR, QI, MS, MP, ARE, MRE` | [32020](source_parts/nswc_part_04.f90#L433) | Not indexed |
| `ERRINT` | `DOUBLE PRECISION FUNCTION` | `F, FIT, AAA, BBB, POINTS, WEIGHT` | [87613](source_parts/nswc_part_09.f90#L2762) | Not indexed |
| `ESUM` | `REAL FUNCTION` | `MU, X` | [4002](source_parts/nswc_part_01.f90#L4002) | Not indexed |
| `EXPARG` | `REAL FUNCTION` | `L` | [1430](source_parts/nswc_part_01.f90#L1430) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [9351](source_parts/nswc_part_01.f90#L9351) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `EXTRA` | `SUBROUTINE` | `NEQN, YINC2, F2, T, H, YINC1, Y, F1, F, TEX, YEX, YPEX` | [111966](source_parts/nswc_part_11.f90#L5808) | Not indexed |
| `FDJAC1` | `SUBROUTINE` | `FCN, N, X, FVEC, FJAC, LDFJAC, IFLAG, ML, MU, EPSFCN, WA1, WA2` | [77746](source_parts/nswc_part_08.f90#L3782) | Not indexed |
| `FDJAC2` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FJAC, LDFJAC, IFLAG, EPSFCN, WA` | [77901](source_parts/nswc_part_08.f90#L3937) | Not indexed |
| `FEHL` | `SUBROUTINE` | `F, NEQN, Y, T, H, YP, F1, F2, F3, F4, F5, S` | [112556](source_parts/nswc_part_11.f90#L6398) | Not indexed |
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [84124](source_parts/nswc_part_08.f90#L10160) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [84142](source_parts/nswc_part_08.f90#L10178) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [75545](source_parts/nswc_part_08.f90#L1581) | [Documented](docs/15-optimization.md#topic-306-01) |
| `FPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [15998](source_parts/nswc_part_02.f90#L5466) | Not indexed |
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [121299](source_parts/nswc_part_12.f90#L4391) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `FRNL` | `SUBROUTINE` | `T, C, S` | [8936](source_parts/nswc_part_01.f90#L8936) | [Documented](docs/04-special-functions.md#topic-057-01) |
| `FSTOCD` | `SUBROUTINE` | `N, X, FCN, TYPSIZ, R, G` | [76401](source_parts/nswc_part_08.f90#L2437) | Not indexed |
| `FSTOFD` | `SUBROUTINE` | `N, X, FCN, FX, G, TYPSIZ, R` | [76360](source_parts/nswc_part_08.f90#L2396) | Not indexed |
| `FUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, I1, K1, N, M, NP1` | [5791](source_parts/nswc_part_01.f90#L5791) | Not indexed |
| `FXDEC` | `SUBROUTINE` | `FCN, N, X, FX, R` | [76231](source_parts/nswc_part_08.f90#L2267) | Not indexed |
| `FXSHFR` | `SUBROUTINE` | `L2, NZ, NN, P, QP, K, QK, SVK` | [30755](source_parts/nswc_part_03.f90#L9714) | Not indexed |
| `FXSHFT` | `SUBROUTINE` | `L2, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SHR, SHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [31739](source_parts/nswc_part_04.f90#L152) | Not indexed |
| `GAM1` | `REAL FUNCTION` | `A` | [11581](source_parts/nswc_part_02.f90#L1049) | Not indexed |
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [14426](source_parts/nswc_part_02.f90#L3894) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `GAMLN` | `REAL FUNCTION` | `A` | [11637](source_parts/nswc_part_02.f90#L1105) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GAMLN1` | `REAL FUNCTION` | `A` | [11682](source_parts/nswc_part_02.f90#L1150) | Not indexed |
| `GAMMA` | `REAL FUNCTION` | `A` | [11330](source_parts/nswc_part_02.f90#L798) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [112625](source_parts/nswc_part_11.f90#L6467) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-424-01) |
| `GERKS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, YP, H, F1, F2, F3, F4, F5, YG, YGP, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [112843](source_parts/nswc_part_11.f90#L6685) | Not indexed |
| `GETNP` | `SUBROUTINE` | `X, Y, IADJ, IEND, L, NPTS, DS, IER` | [99248](source_parts/nswc_part_10.f90#L3881) | Not indexed |
| `GLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [11465](source_parts/nswc_part_02.f90#L933) | Not indexed |
| `GNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [100656](source_parts/nswc_part_10.f90#L5289) | Not indexed |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [98581](source_parts/nswc_part_10.f90#L3214) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADG1` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, EPS, NIT, ZXZY, IER` | [98612](source_parts/nswc_part_10.f90#L3245) | Not indexed |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [98834](source_parts/nswc_part_10.f90#L3467) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADL1` | `SUBROUTINE` | `N, K, X, Y, Z, IADJ, IEND, DX, DY, IER` | [98865](source_parts/nswc_part_10.f90#L3498) | Not indexed |
| `GRAT1` | `SUBROUTINE` | `A, X, R, P, Q, EPS` | [16617](source_parts/nswc_part_02.f90#L6085) | Not indexed |
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [13923](source_parts/nswc_part_02.f90#L3391) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `GSUMLN` | `REAL FUNCTION` | `A, B` | [13534](source_parts/nswc_part_02.f90#L3002) | Not indexed |
| `H12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [70218](source_parts/nswc_part_07.f90#L6877) | Not indexed |
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [28951](source_parts/nswc_part_03.f90#L7910) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-124-01) |
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [5278](source_parts/nswc_part_01.f90#L5278) | [Documented](docs/03-geometry.md#topic-043-01) |
| `HC1` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, NP1, PC, AC, VR, VC, P, SUBR, RBUS, TOR, JR, K, IND0` | [5386](source_parts/nswc_part_01.f90#L5386) | Not indexed |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [69690](source_parts/nswc_part_07.f90#L6349) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [69940](source_parts/nswc_part_07.f90#L6599) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [60082](source_parts/nswc_part_06.f90#L7335) | Not indexed |
| `HQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [60717](source_parts/nswc_part_06.f90#L7970) | Not indexed |
| `HSTART` | `SUBROUTINE` | `F, NEQ, A, B, Y, YPRIME, ETOL, MORDER, SMALL, BIG, SPY, PV, YP, SF, RPAR, IPAR, H` | [114460](source_parts/nswc_part_11.f90#L8302) | Not indexed |
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [88896](source_parts/nswc_part_09.f90#L4045) | [Documented](docs/18-curve-fitting.md#topic-338-01) |
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [4849](source_parts/nswc_part_01.f90#L4849) | [Documented](docs/03-geometry.md#topic-041-01) |
| `HYBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, XTOL, MAXFEV, ML, MU, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, R, LR, QTF, WA1, WA2, WA3, WA4` | [29086](source_parts/nswc_part_03.f90#L8045) | Not indexed |
| `IA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [22677](source_parts/nswc_part_03.f90#L1636) | Not indexed |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [34468](source_parts/nswc_part_04.f90#L2881) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [34428](source_parts/nswc_part_04.f90#L2841) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IEGS` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, X, T, NT, NUP, MUP, IER, CUTOFF, ROOTRT, UNITRD, NHALF, LUFACT, KMM, KMN, KNM, RHS, R, RH, DELN, TM, TN, XM, XMZ, WM, WN, OLDX, SAVE, XN, SAVE2, ASIDE, ASIDE3, IMKNN` | [109080](source_parts/nswc_part_11.f90#L2922) | Not indexed |
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [108905](source_parts/nswc_part_11.f90#L2747) | [Documented](docs/23-integral-equations.md#topic-410-01) |
| `IMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [22723](source_parts/nswc_part_03.f90#L1682) | Not indexed |
| `IMTQL1` | `SUBROUTINE` | `N, D, E, IERR` | [62890](source_parts/nswc_part_06.f90#L10143) | Not indexed |
| `IMTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [63342](source_parts/nswc_part_07.f90#L1) | Not indexed |
| `INCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [100737](source_parts/nswc_part_10.f90#L5370) | Not indexed |
| `INDXA` | `SUBROUTINE` | `I, IR, IDXA, NA` | [118220](source_parts/nswc_part_12.f90#L1312) | Not indexed |
| `INDXB` | `SUBROUTINE` | `I, IR, IDX, IDP` | [118250](source_parts/nswc_part_12.f90#L1342) | Not indexed |
| `INDXC` | `SUBROUTINE` | `I, IR, IDXC, NC` | [118235](source_parts/nswc_part_12.f90#L1327) | Not indexed |
| `INFCTR` | `SUBROUTINE` | `N, IFACT, IPOWER, NEXP, NPOWER` | [35148](source_parts/nswc_part_04.f90#L3561) | Not indexed |
| `INTADD` | `SUBROUTINE` | `KK, I1, I2, I3, IADJ, IEND` | [97659](source_parts/nswc_part_10.f90#L2292) | Not indexed |
| `INTRC1` | `SUBROUTINE` | `N, PX, PY, X, Y, Z, IADJ, IEND, IFLAG, ZXZY, IST, PZ, IER` | [99463](source_parts/nswc_part_10.f90#L4096) | Not indexed |
| `INTRP` | `SUBROUTINE` | `X, Y, XOUT, YOUT, YPOUT, NEQN, KOLD, PHI, PSI` | [110992](source_parts/nswc_part_11.f90#L4834) | Not indexed |
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [93005](source_parts/nswc_part_09.f90#L8154) | [Documented](docs/18-curve-fitting.md#topic-368-01) |
| `INTYD` | `SUBROUTINE` | `T, K, YH, NYH, DKY, IFLAG` | [114763](source_parts/nswc_part_11.f90#L8605) | Not indexed |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [2713](source_parts/nswc_part_01.f90#L2713) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `IPATH` | `SUBROUTINE` | `I, J, SUBR, RBUS, AR, PR, S, N, NP, I1, I2, K, JR, M, NP1` | [5724](source_parts/nswc_part_01.f90#L5724) | Not indexed |
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [1](source_parts/nswc_part_01.f90#L1) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [34388](source_parts/nswc_part_04.f90#L2801) | [Documented](docs/07-vectors.md#topic-141-01) |
| `ISHELL` | `SUBROUTINE` | `A, N` | [1509](source_parts/nswc_part_01.f90#L1509) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [16816](source_parts/nswc_part_02.f90#L6284) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `ISWAP` | `SUBROUTINE` | `N, IX, INCX, IY, INCY` | [32498](source_parts/nswc_part_04.f90#L911) | Not indexed |
| `ITERT` | `SUBROUTINE` | `KERNEL, RHFCN, N, TN, WN, M, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, IFLG` | [109885](source_parts/nswc_part_11.f90#L3727) | Not indexed |
| `IUPD` | `SUBROUTINE` | `IA, IB, L, A1, A2, P1, P2, V1, V2, K1, N, M, NP1` | [5850](source_parts/nswc_part_01.f90#L5850) | Not indexed |
| `JA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [22836](source_parts/nswc_part_03.f90#L1795) | Not indexed |
| `JAIRY` | `SUBROUTINE` | `X, RX, C, AI, DAI` | [19089](source_parts/nswc_part_02.f90#L8557) | Not indexed |
| `JMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [22882](source_parts/nswc_part_03.f90#L1841) | Not indexed |
| `JROT` | `SUBROUTINE` | `NR, N, H, I, A, B, R` | [76794](source_parts/nswc_part_08.f90#L2830) | Not indexed |
| `KA` | `SUBROUTINE` | `IND, Z, K1, K2` | [22995](source_parts/nswc_part_03.f90#L1954) | Not indexed |
| `KL` | `SUBROUTINE` | `L, FK, FL` | [23992](source_parts/nswc_part_03.f90#L2951) | Not indexed |
| `KM` | `COMPLEX FUNCTION` | `K2` | [23955](source_parts/nswc_part_03.f90#L2914) | Not indexed |
| `KML` | `SUBROUTINE` | `IND, Z, K1, K2` | [23046](source_parts/nswc_part_03.f90#L2005) | Not indexed |
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [35860](source_parts/nswc_part_04.f90#L4273) | [Documented](docs/08-matrices.md#topic-160-01) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [36265](source_parts/nswc_part_04.f90#L4678) | [Documented](docs/08-matrices.md#topic-163-01) |
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [91945](source_parts/nswc_part_09.f90#L7094) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [92140](source_parts/nswc_part_09.f90#L7289) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [92248](source_parts/nswc_part_09.f90#L7397) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [92422](source_parts/nswc_part_09.f90#L7571) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [73353](source_parts/nswc_part_07.f90#L10012) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-299-01) |
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [82114](source_parts/nswc_part_08.f90#L8150) | [Documented](docs/16-transforms.md#topic-317-01) |
| `LAINV1` | `SUBROUTINE` | `FUN, T, C, EPSRE, EPSAB, RESULT, ESTERR, NUM, IER` | [82804](source_parts/nswc_part_08.f90#L8840) | Not indexed |
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [48251](source_parts/nswc_part_05.f90#L6046) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `LEAVE` | `SUBROUTINE` | `IERSET, NF, MF, XV, TV, WV, ERROR, KERNEL, RHFCN, EP, IFLAG, X, T, NT, IER, EPS, ELINSY, TN, WN, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, XNORM` | [109772](source_parts/nswc_part_11.f90#L3614) | Not indexed |
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [28314](source_parts/nswc_part_03.f90#L7273) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [28342](source_parts/nswc_part_03.f90#L7301) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [28456](source_parts/nswc_part_03.f90#L7415) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [66843](source_parts/nswc_part_07.f90#L3502) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [66877](source_parts/nswc_part_07.f90#L3536) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-286-01) |
| `LLTSLV` | `SUBROUTINE` | `NR, N, A, X, B` | [76301](source_parts/nswc_part_08.f90#L2337) | Not indexed |
| `LMDIF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FTOL, XTOL, GTOL, MAXFEV, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, IPVT, QTF, WA1, WA2, WA3, WA4` | [77005](source_parts/nswc_part_08.f90#L3041) | Not indexed |
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [76861](source_parts/nswc_part_08.f90#L2897) | [Documented](docs/15-optimization.md#topic-309-01) |
| `LMPAR` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, DELTA, PAR, X, SDIAG, WA1, WA2` | [78013](source_parts/nswc_part_08.f90#L4049) | Not indexed |
| `LNSRCH` | `SUBROUTINE` | `N, X, F, G, P, XPLS, FPLS, FCN, MXTAKE, IRETCD, STEPMX, STEPTL, TYPSIZ` | [76446](source_parts/nswc_part_08.f90#L2482) | Not indexed |
| `LNSYS` | `SUBROUTINE` | `A, D, M, N, B, X, OPTION, IERR` | [109977](source_parts/nswc_part_11.f90#L3819) | Not indexed |
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [4596](source_parts/nswc_part_01.f90#L4596) | [Documented](docs/03-geometry.md#topic-039-01) |
| `LOGAM` | `REAL FUNCTION` | `X` | [17084](source_parts/nswc_part_02.f90#L6552) | Not indexed |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [91285](source_parts/nswc_part_09.f90#L6434) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [91368](source_parts/nswc_part_09.f90#L6517) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LPDP` | `SUBROUTINE` | `A, MDA, M, N1, N2, PRGOPT, X, WNORM, MODE, WS, IS` | [71881](source_parts/nswc_part_07.f90#L8540) | Not indexed |
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [70924](source_parts/nswc_part_07.f90#L7583) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-292-01) |
| `LSI` | `SUBROUTINE` | `W, MDW, MA, MG, N, PRGOPT, X, RNORM, MODE, WS, IP` | [71516](source_parts/nswc_part_07.f90#L8175) | Not indexed |
| `LSOD1` | `SUBROUTINE` | `F, NEQ, T, Y, TOUT, RTOL, ATOL, IDID, YPOUT, YH, YH1, EWT, SAVF, ACOR, WM, IWM, JAC, INTOUT, TSTOP, TOLFAC, DELSGN, RPAR, IPAR` | [114142](source_parts/nswc_part_11.f90#L7984) | Not indexed |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [67487](source_parts/nswc_part_07.f90#L4146) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [88743](source_parts/nswc_part_09.f90#L3892) | [Documented](docs/18-curve-fitting.md#topic-337-01) |
| `LUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [36974](source_parts/nswc_part_04.f90#L5387) | Not indexed |
| `MACH` | `SUBROUTINE` | `MO, N, IBETA, IMAX, IDMAX, IMACH, RMACH, DMACH` | [438](source_parts/nswc_part_01.f90#L438) | Not indexed |
| `MACH1` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [739](source_parts/nswc_part_01.f90#L739) | Not indexed |
| `MACH2` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [996](source_parts/nswc_part_01.f90#L996) | Not indexed |
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [35246](source_parts/nswc_part_04.f90#L3659) | [Documented](docs/08-matrices.md#topic-151-01) |
| `MC13D` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW` | [55994](source_parts/nswc_part_06.f90#L3247) | Not indexed |
| `MC13E` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, ARP, IB, NUM, LOWL, NUMB, PREV` | [56028](source_parts/nswc_part_06.f90#L3281) | Not indexed |
| `MC21A` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, IW` | [55828](source_parts/nswc_part_06.f90#L3081) | Not indexed |
| `MC21B` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, PR, ARP, CV, OUT` | [55863](source_parts/nswc_part_06.f90#L3116) | Not indexed |
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34684](source_parts/nswc_part_04.f90#L3097) | [Documented](docs/08-matrices.md#topic-146-01) |
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [49364](source_parts/nswc_part_05.f90#L7159) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34620](source_parts/nswc_part_04.f90#L3033) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [34512](source_parts/nswc_part_04.f90#L2925) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34636](source_parts/nswc_part_04.f90#L3049) | [Documented](docs/08-matrices.md#topic-144-01) |
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34604](source_parts/nswc_part_04.f90#L3017) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [49559](source_parts/nswc_part_05.f90#L7354) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [34546](source_parts/nswc_part_04.f90#L2959) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [101010](source_parts/nswc_part_10.f90#L5643) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MEVAL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [101165](source_parts/nswc_part_10.f90#L5798) | Not indexed |
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [47933](source_parts/nswc_part_05.f90#L5728) | [Documented](docs/08-matrices.md#topic-191-01) |
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [84155](source_parts/nswc_part_08.f90#L10191) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [84195](source_parts/nswc_part_08.f90#L10231) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [100037](source_parts/nswc_part_10.f90#L4670) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MINSOL` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTB` | [117414](source_parts/nswc_part_12.f90#L506) | Not indexed |
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [81273](source_parts/nswc_part_08.f90#L7309) | [Documented](docs/15-optimization.md#topic-315-01) |
| `MKP1` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5, BB, BL, X, XL, B, UBB, LX, LXI, F, PBL, Q, V, BS, PS, WS, XS, IWK` | [81475](source_parts/nswc_part_08.f90#L7511) | Not indexed |
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [28196](source_parts/nswc_part_03.f90#L7155) | [Documented](docs/05-polynomials.md#topic-117-01) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [35456](source_parts/nswc_part_04.f90#L3869) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [36851](source_parts/nswc_part_04.f90#L5264) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [36895](source_parts/nswc_part_04.f90#L5308) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [35316](source_parts/nswc_part_04.f90#L3729) | [Documented](docs/08-matrices.md#topic-153-01) |
| `MTABLE` | `SUBROUTINE` | `DEGREE, DIMEN, NPOLYS, INDEXS, NEWKJ, ALFLP1` | [100508](source_parts/nswc_part_10.f90#L5141) | Not indexed |
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [35386](source_parts/nswc_part_04.f90#L3799) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55359](source_parts/nswc_part_06.f90#L2612) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55388](source_parts/nswc_part_06.f90#L2641) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55309](source_parts/nswc_part_06.f90#L2562) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [55334](source_parts/nswc_part_06.f90#L2587) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `NEWEST` | `SUBROUTINE` | `TYPE, UU, VV, NN, P, K` | [31235](source_parts/nswc_part_03.f90#L10194) | Not indexed |
| `NEWTON` | `SUBROUTINE` | `NL, NR, NI` | [87693](source_parts/nswc_part_09.f90#L2842) | Not indexed |
| `NEXTH` | `SUBROUTINE` | `BOOL, N, TR, TI, HR, HI, QPR, QPI, QHR, QHI` | [31956](source_parts/nswc_part_04.f90#L369) | Not indexed |
| `NEXTK` | `SUBROUTINE` | `TYPE, N, QP, K, QK` | [31182](source_parts/nswc_part_03.f90#L10141) | Not indexed |
| `NORMLZ` | `SUBROUTINE` | `N, X, BETA` | [74683](source_parts/nswc_part_08.f90#L719) | Not indexed |
| `NOSHFT` | `SUBROUTINE` | `L1, NN, TR, TI, ETA, PR, PI, HR, HI` | [31689](source_parts/nswc_part_04.f90#L102) | Not indexed |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [36603](source_parts/nswc_part_04.f90#L5016) | [Documented](docs/08-matrices.md#topic-163-01) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [120247](source_parts/nswc_part_12.f90#L3339) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [120312](source_parts/nswc_part_12.f90#L3404) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [120450](source_parts/nswc_part_12.f90#L3542) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NSPIV1` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [56288](source_parts/nswc_part_06.f90#L3541) | Not indexed |
| `NSTERP` | `SUBROUTINE` | `TM, WM, XM, M, TN, WN, XN, N, KERNEL, RHFCN, RHS, KMN, NHALF, NUP` | [109384](source_parts/nswc_part_11.f90#L3226) | Not indexed |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [96524](source_parts/nswc_part_10.f90#L1157) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [110145](source_parts/nswc_part_11.f90#L3987) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-415-01) |
| `OPCHK1` | `SUBROUTINE` | `N, X, TYPSIZ, FSCALE, GRADTL, ITNLIM, RERR, STEPMX, IERR` | [76013](source_parts/nswc_part_08.f90#L2049) | Not indexed |
| `OPSTP` | `SUBROUTINE` | `N, XPLS, FPLS, GPLS, X, ITNCNT, ICSCMX, IERR, GRADTL, STEPTL, TYPSIZ, FSCALE, ITNLIM, IRETCD, MXTAKE, FSTACK, NS, SPTR` | [76109](source_parts/nswc_part_08.f90#L2145) | Not indexed |
| `OPTDRV` | `SUBROUTINE` | `MO, NR, N, X, FCN, TYPSIZ, FSCALE, RERR, ITNLIM, ITNCNT, GRADTL, STEPMX, STEPTL, XPLS, FPLS, GPLS, IERR, A, G, P, WRK0, WRK1, WRK2` | [75800](source_parts/nswc_part_08.f90#L1836) | Not indexed |
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [75717](source_parts/nswc_part_08.f90#L1753) | [Documented](docs/15-optimization.md#topic-307-01) |
| `ORIMP` | `SUBROUTINE` | `M, N, A, KA, QR, MS, S, IP, B, X, R, EXIT` | [67130](source_parts/nswc_part_07.f90#L3789) | Not indexed |
| `ORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [67037](source_parts/nswc_part_07.f90#L3696) | Not indexed |
| `ORTHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [59973](source_parts/nswc_part_06.f90#L7226) | Not indexed |
| `ORTHG` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTRB` | [117363](source_parts/nswc_part_12.f90#L455) | Not indexed |
| `ORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [66926](source_parts/nswc_part_07.f90#L3585) | Not indexed |
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [28511](source_parts/nswc_part_03.f90#L7470) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [28596](source_parts/nswc_part_03.f90#L7555) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [28655](source_parts/nswc_part_03.f90#L7614) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [60541](source_parts/nswc_part_06.f90#L7794) | Not indexed |
| `ORTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [60627](source_parts/nswc_part_06.f90#L7880) | Not indexed |
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [27656](source_parts/nswc_part_03.f90#L6615) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `PARC` | `SUBROUTINE` | `I, II, UB, IFLAG, VB, LUB, LJ, LI, F, BB, Q, B, N, M, NP1, LX, LXI, LR, LRI, LUBI` | [81819](source_parts/nswc_part_08.f90#L7855) | Not indexed |
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [5240](source_parts/nswc_part_01.f90#L5240) | [Documented](docs/03-geometry.md#topic-042-01) |
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [41558](source_parts/nswc_part_04.f90#L9971) | [Documented](docs/08-matrices.md#topic-176-01) |
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [88948](source_parts/nswc_part_09.f90#L4097) | [Documented](docs/18-curve-fitting.md#topic-339-01) |
| `PDEDGE` | `SUBROUTINE` | `EDGE, INDX, INDY, IERR` | [116359](source_parts/nswc_part_11.f90#L10201) | Not indexed |
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [90820](source_parts/nswc_part_09.f90#L5969) | [Documented](docs/18-curve-fitting.md#topic-353-01) |
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [27840](source_parts/nswc_part_03.f90#L6799) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [90689](source_parts/nswc_part_09.f90#L5838) | [Documented](docs/18-curve-fitting.md#topic-352-01) |
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [26294](source_parts/nswc_part_03.f90#L5253) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [26339](source_parts/nswc_part_03.f90#L5298) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [4681](source_parts/nswc_part_01.f90#L4681) | [Documented](docs/03-geometry.md#topic-040-01) |
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [88978](source_parts/nswc_part_09.f90#L4127) | [Documented](docs/18-curve-fitting.md#topic-340-01) |
| `PI1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, BB, KUB, BL, LB, PBL, V, XL, NP1, N5, BS, PS, WS, XS, IWK` | [81721](source_parts/nswc_part_08.f90#L7757) | Not indexed |
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [28072](source_parts/nswc_part_03.f90#L7031) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `PJAC` | `SUBROUTINE` | `NEQ, Y, YH, NYH, EWT, FTEM, SAVF, WM, IWM, F, JAC, RPAR, IPAR` | [115422](source_parts/nswc_part_11.f90#L9264) | Not indexed |
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [27151](source_parts/nswc_part_03.f90#L6110) | [Documented](docs/04-special-functions.md#topic-109-01) |
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [27598](source_parts/nswc_part_03.f90#L6557) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [26386](source_parts/nswc_part_03.f90#L5345) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [26432](source_parts/nswc_part_03.f90#L5391) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [27957](source_parts/nswc_part_03.f90#L6916) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [27756](source_parts/nswc_part_03.f90#L6715) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `PNDF` | `FUNCTION` | `X, IND` | [8157](source_parts/nswc_part_01.f90#L8157) | [Documented](docs/04-special-functions.md#topic-053-01) |
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [8186](source_parts/nswc_part_01.f90#L8186) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [3221](source_parts/nswc_part_01.f90#L3221) | [Documented](docs/02-elementary-operations.md#topic-028-01) |
| `POLYDD` | `DOUBLE PRECISION FUNCTION` | `X` | [87840](source_parts/nswc_part_09.f90#L2989) | Not indexed |
| `POLYEV` | `SUBROUTINE` | `N, SR, SI, PR, PI, QR, QI, PVR, PVI` | [31993](source_parts/nswc_part_04.f90#L406) | Not indexed |
| `PPADD` | `SUBROUTINE` | `N, IERROR, A, C, CBP, BP, BH` | [118990](source_parts/nswc_part_12.f90#L2082) | Not indexed |
| `PPSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [119202](source_parts/nswc_part_12.f90#L2294) | Not indexed |
| `PPSPF` | `FUNCTION` | `X, IZ, C, A, BH` | [119219](source_parts/nswc_part_12.f90#L2311) | Not indexed |
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [93503](source_parts/nswc_part_09.f90#L8652) | [Documented](docs/18-curve-fitting.md#topic-372-01) |
| `PROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, W, U` | [118281](source_parts/nswc_part_12.f90#L1373) | Not indexed |
| `PRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, U, W` | [118375](source_parts/nswc_part_12.f90#L1467) | Not indexed |
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [90916](source_parts/nswc_part_09.f90#L6065) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [90996](source_parts/nswc_part_09.f90#L6145) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [119153](source_parts/nswc_part_12.f90#L2245) | Not indexed |
| `PSI` | `REAL FUNCTION` | `XX` | [12506](source_parts/nswc_part_02.f90#L1974) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [13128](source_parts/nswc_part_02.f90#L2596) | [Documented](docs/04-special-functions.md#topic-071-01) |
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [27706](source_parts/nswc_part_03.f90#L6665) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [103332](source_parts/nswc_part_10.f90#L7965) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `QAGI1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [83239](source_parts/nswc_part_08.f90#L9275) | Not indexed |
| `QAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [103519](source_parts/nswc_part_10.f90#L8152) | Not indexed |
| `QAGIE1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [83442](source_parts/nswc_part_08.f90#L9478) | Not indexed |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [102517](source_parts/nswc_part_10.f90#L7150) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [102697](source_parts/nswc_part_10.f90#L7330) | Not indexed |
| `QDCRT` | `SUBROUTINE` | `A, Z` | [29550](source_parts/nswc_part_03.f90#L8509) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [104311](source_parts/nswc_part_10.f90#L8944) | Not indexed |
| `QFORM` | `SUBROUTINE` | `M, N, Q, LDQ, WA` | [78279](source_parts/nswc_part_08.f90#L4315) | Not indexed |
| `QK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [103987](source_parts/nswc_part_10.f90#L8620) | Not indexed |
| `QK15I1` | `SUBROUTINE` | `F, PHI, Y, C, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [83928](source_parts/nswc_part_08.f90#L9964) | Not indexed |
| `QK21F` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [103152](source_parts/nswc_part_10.f90#L7785) | Not indexed |
| `QPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [104174](source_parts/nswc_part_10.f90#L8807) | Not indexed |
| `QRFAC` | `SUBROUTINE` | `M, N, A, LDA, PIVOT, IPVT, LIPVT, RDIAG, ACNORM, WA` | [78378](source_parts/nswc_part_08.f90#L4414) | Not indexed |
| `QRSOLV` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, X, SDIAG, WA` | [78546](source_parts/nswc_part_08.f90#L4582) | Not indexed |
| `QRUPDT` | `SUBROUTINE` | `NR, N, A, U, V` | [76735](source_parts/nswc_part_08.f90#L2771) | Not indexed |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [2509](source_parts/nswc_part_01.f90#L2509) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [2104](source_parts/nswc_part_01.f90#L2104) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [2306](source_parts/nswc_part_01.f90#L2306) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [102023](source_parts/nswc_part_10.f90#L6656) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [30106](source_parts/nswc_part_03.f90#L9065) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QUAD` | `SUBROUTINE` | `A, B, RESULT, K, EPSIL, NPTS, ICHECK, F` | [102174](source_parts/nswc_part_10.f90#L6807) | Not indexed |
| `QUADIT` | `SUBROUTINE` | `UU, VV, NZ, NN, P, QP, K, QK` | [30906](source_parts/nswc_part_03.f90#L9865) | Not indexed |
| `QUADPL` | `SUBROUTINE` | `A, B1, C, SR, SI, LR, LI` | [31311](source_parts/nswc_part_03.f90#L10270) | Not indexed |
| `QUADSD` | `SUBROUTINE` | `NN, U, V, P, Q, A, B` | [31285](source_parts/nswc_part_03.f90#L10244) | Not indexed |
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [92536](source_parts/nswc_part_09.f90#L7685) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [92757](source_parts/nswc_part_09.f90#L7906) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QXCPY` | `SUBROUTINE` | `A, B, L` | [105094](source_parts/nswc_part_10.f90#L9727) | Not indexed |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [104494](source_parts/nswc_part_10.f90#L9127) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [104667](source_parts/nswc_part_10.f90#L9300) | Not indexed |
| `QXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [105111](source_parts/nswc_part_10.f90#L9744) | Not indexed |
| `QXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [105427](source_parts/nswc_part_10.f90#L10060) | Not indexed |
| `QXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [105227](source_parts/nswc_part_10.f90#L9860) | Not indexed |
| `R1MPYQ` | `SUBROUTINE` | `M, N, A, LDA, V, W` | [78743](source_parts/nswc_part_08.f90#L4779) | Not indexed |
| `R1UPDT` | `SUBROUTINE` | `M, N, S, LS, U, V, W, SING` | [78839](source_parts/nswc_part_08.f90#L4875) | Not indexed |
| `RADB2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [85457](source_parts/nswc_part_09.f90#L606) | Not indexed |
| `RADB3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [85505](source_parts/nswc_part_09.f90#L654) | Not indexed |
| `RADB4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [85573](source_parts/nswc_part_09.f90#L722) | Not indexed |
| `RADB5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [85667](source_parts/nswc_part_09.f90#L816) | Not indexed |
| `RADBG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [85781](source_parts/nswc_part_09.f90#L930) | Not indexed |
| `RADF2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [86087](source_parts/nswc_part_09.f90#L1236) | Not indexed |
| `RADF3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [86135](source_parts/nswc_part_09.f90#L1284) | Not indexed |
| `RADF4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [86201](source_parts/nswc_part_09.f90#L1350) | Not indexed |
| `RADF5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [86291](source_parts/nswc_part_09.f90#L1440) | Not indexed |
| `RADFG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [86401](source_parts/nswc_part_09.f90#L1550) | Not indexed |
| `RADIX` | `SUBROUTINE` | `IBETA` | [712](source_parts/nswc_part_01.f90#L712) | Not indexed |
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [120805](source_parts/nswc_part_12.f90#L3897) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `RARC` | `SUBROUTINE` | `IA, IB, AR, AC, PR, PC, VR, VC, K1, JJ, LL, N, M, NP1` | [5885](source_parts/nswc_part_01.f90#L5885) | Not indexed |
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [121107](source_parts/nswc_part_12.f90#L4199) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [32044](source_parts/nswc_part_04.f90#L457) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [119933](source_parts/nswc_part_12.f90#L3025) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `RCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [119950](source_parts/nswc_part_12.f90#L3042) | Not indexed |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [14358](source_parts/nswc_part_02.f90#L3826) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `RCVAL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [25683](source_parts/nswc_part_03.f90#L4642) | Not indexed |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [25151](source_parts/nswc_part_03.f90#L4110) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `REALIT` | `SUBROUTINE` | `SSS, NZ, IFLAG, NN, P, QP, K, QK` | [31011](source_parts/nswc_part_03.f90#L9970) | Not indexed |
| `REXP` | `REAL FUNCTION` | `X` | [4058](source_parts/nswc_part_01.f90#L4058) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `REXP1` | `SUBROUTINE` | `X, E, W` | [4144](source_parts/nswc_part_01.f90#L4144) | Not indexed |
| `RFFTB` | `SUBROUTINE` | `N, R, WSAVE` | [85381](source_parts/nswc_part_09.f90#L530) | Not indexed |
| `RFFTB1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [85392](source_parts/nswc_part_09.f90#L541) | Not indexed |
| `RFFTF` | `SUBROUTINE` | `N, R, WSAVE` | [86010](source_parts/nswc_part_09.f90#L1159) | Not indexed |
| `RFFTF1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [86021](source_parts/nswc_part_09.f90#L1170) | Not indexed |
| `RFFTI` | `SUBROUTINE` | `N, WSAVE` | [85246](source_parts/nswc_part_09.f90#L395) | Not indexed |
| `RFFTI1` | `SUBROUTINE` | `N, WA, IFAC` | [85257](source_parts/nswc_part_09.f90#L406) | Not indexed |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [24923](source_parts/nswc_part_03.f90#L3882) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [120980](source_parts/nswc_part_12.f90#L4072) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [1720](source_parts/nswc_part_01.f90#L1720) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [25401](source_parts/nswc_part_03.f90#L4360) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [116013](source_parts/nswc_part_11.f90#L9855) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-431-01) |
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [116072](source_parts/nswc_part_11.f90#L9914) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-433-01) |
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [112015](source_parts/nswc_part_11.f90#L5857) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-421-01) |
| `RKFC` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, W, WP, X, HINT, H, Y1, Y2, F1, F2, F3, F4, F7, SAVRE, SAVAE, TOLD, NFE, JFLAG, KFLAG, ENDPNT, BLKOUT` | [111366](source_parts/nswc_part_11.f90#L5208) | Not indexed |
| `RKFS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YP, H, F1, F2, F3, F4, F5, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [112211](source_parts/nswc_part_11.f90#L6053) | Not indexed |
| `RLOC` | `LOGICAL FUNCTION` | `X, Y` | [35515](source_parts/nswc_part_04.f90#L3928) | Not indexed |
| `RLOG` | `REAL FUNCTION` | `X` | [4328](source_parts/nswc_part_01.f90#L4328) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RLOG1` | `REAL FUNCTION` | `X` | [4381](source_parts/nswc_part_01.f90#L4381) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RMIN` | `FUNCTION` | `N, M, COND, UNITRD, AVERR` | [109426](source_parts/nswc_part_11.f90#L3268) | Not indexed |
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [121690](source_parts/nswc_part_12.f90#L4782) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `RNDERR` | `FUNCTION` | `X, A, Y, B` | [108747](source_parts/nswc_part_11.f90#L2589) | Not indexed |
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [35953](source_parts/nswc_part_04.f90#L4366) | [Documented](docs/08-matrices.md#topic-161-01) |
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [120145](source_parts/nswc_part_12.f90#L3237) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `RNRM` | `REAL FUNCTION` | `X, Y, N, IFLAG` | [109448](source_parts/nswc_part_11.f90#L3290) | Not indexed |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [2787](source_parts/nswc_part_01.f90#L2787) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ROT3` | `SUBROUTINE` | `A, THETA` | [3418](source_parts/nswc_part_01.f90#L3418) | [Documented](docs/02-elementary-operations.md#topic-030-01) |
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [3252](source_parts/nswc_part_01.f90#L3252) | [Documented](docs/02-elementary-operations.md#topic-028-03) |
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [54361](source_parts/nswc_part_06.f90#L1614) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [54425](source_parts/nswc_part_06.f90#L1678) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RRSORT` | `SUBROUTINE` | `A, B, N` | [1778](source_parts/nswc_part_01.f90#L1778) | Not indexed |
| `RSCO` | `SUBROUTINE` | `RSAV, ISAV` | [114099](source_parts/nswc_part_11.f90#L7941) | Not indexed |
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54243](source_parts/nswc_part_06.f90#L1496) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [56562](source_parts/nswc_part_06.f90#L3815) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `RSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [56665](source_parts/nswc_part_06.f90#L3918) | Not indexed |
| `RSORT` | `SUBROUTINE` | `A, N` | [1668](source_parts/nswc_part_01.f90#L1668) | Not indexed |
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [58019](source_parts/nswc_part_06.f90#L5272) | [Documented](docs/11-sparse-matrices.md#topic-250-01) |
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [55648](source_parts/nswc_part_06.f90#L2901) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [54754](source_parts/nswc_part_06.f90#L2007) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [33874](source_parts/nswc_part_04.f90#L2287) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [33735](source_parts/nswc_part_04.f90#L2148) | [Documented](docs/07-vectors.md#topic-138-01) |
| `SCALCP` | `DOUBLE PRECISION FUNCTION` | `NN, PT, ETA, INFIN, SMALNO, BASE` | [31588](source_parts/nswc_part_04.f90#L1) | Not indexed |
| `SCALDN` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [100980](source_parts/nswc_part_10.f90#L5613) | Not indexed |
| `SCALEX` | `SUBROUTINE` | `MO, X, TYPSIZ, N, IERR` | [76266](source_parts/nswc_part_08.f90#L2302) | Not indexed |
| `SCALPM` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [100941](source_parts/nswc_part_10.f90#L5574) | Not indexed |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [33963](source_parts/nswc_part_04.f90#L2376) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SCD` | `SUBROUTINE` | `U, K, L, F, S, C, D` | [25976](source_parts/nswc_part_03.f90#L4935) | Not indexed |
| `SCDF` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [26057](source_parts/nswc_part_03.f90#L5016) | Not indexed |
| `SCDJ` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [26122](source_parts/nswc_part_03.f90#L5081) | Not indexed |
| `SCDM` | `SUBROUTINE` | `U, K, S, C, D` | [26031](source_parts/nswc_part_03.f90#L4990) | Not indexed |
| `SCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [45402](source_parts/nswc_part_05.f90#L3197) | Not indexed |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [34252](source_parts/nswc_part_04.f90#L2665) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [89731](source_parts/nswc_part_09.f90#L4880) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [89833](source_parts/nswc_part_09.f90#L4982) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [89937](source_parts/nswc_part_09.f90#L5086) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54331](source_parts/nswc_part_06.f90#L1584) | [Documented](docs/11-sparse-matrices.md#topic-232-01) |
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [32356](source_parts/nswc_part_04.f90#L769) | [Documented](docs/07-vectors.md#topic-130-01) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54087](source_parts/nswc_part_06.f90#L1340) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [54178](source_parts/nswc_part_06.f90#L1431) | [Documented](docs/11-sparse-matrices.md#topic-230-01) |
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [54060](source_parts/nswc_part_06.f90#L1313) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [33403](source_parts/nswc_part_04.f90#L1816) | [Documented](docs/07-vectors.md#topic-136-01) |
| `SECFAC` | `SUBROUTINE` | `NR, N, X, G, A, XPLS, GPLS, ITNCNT, TOL, NOUPDT, S, Y, W` | [76595](source_parts/nswc_part_08.f90#L2631) | Not indexed |
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [62442](source_parts/nswc_part_06.f90#L9695) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [62464](source_parts/nswc_part_06.f90#L9717) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [62486](source_parts/nswc_part_06.f90#L9739) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [62501](source_parts/nswc_part_06.f90#L9754) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [116147](source_parts/nswc_part_11.f90#L9989) | [Documented](docs/25-partial-differential-equations.md#topic-434-01) |
| `SEPEL1` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, AN, BN, CN, DN, UN, ZN, AM, BM, CM, DM, UM, ZM, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [116909](source_parts/nswc_part_12.f90#L1) | Not indexed |
| `SEPELL` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [116413](source_parts/nswc_part_11.f90#L10255) | Not indexed |
| `SETRM` | `SUBROUTINE` | `XK, YK, ZK, XI, YI, ZI, S1, S2, R, ROW` | [99162](source_parts/nswc_part_10.f90#L3795) | Not indexed |
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [90044](source_parts/nswc_part_09.f90#L5193) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [90153](source_parts/nswc_part_09.f90#L5302) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [90263](source_parts/nswc_part_09.f90#L5412) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SFFT` | `SUBROUTINE` | `A, B, NTOT, N, NSPAN, ISN, IERR` | [84228](source_parts/nswc_part_08.f90#L10264) | Not indexed |
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [113232](source_parts/nswc_part_11.f90#L7074) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [113260](source_parts/nswc_part_11.f90#L7102) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [99395](source_parts/nswc_part_10.f90#L4028) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [99427](source_parts/nswc_part_10.f90#L4060) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SGBFA` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, INFO` | [115660](source_parts/nswc_part_11.f90#L9502) | Not indexed |
| `SGBSL` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, B, JOB` | [115836](source_parts/nswc_part_11.f90#L9678) | Not indexed |
| `SGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [37066](source_parts/nswc_part_04.f90#L5479) | Not indexed |
| `SGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [37492](source_parts/nswc_part_04.f90#L5905) | Not indexed |
| `SGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [37263](source_parts/nswc_part_04.f90#L5676) | Not indexed |
| `SGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [37371](source_parts/nswc_part_04.f90#L5784) | Not indexed |
| `SHELL` | `SUBROUTINE` | `A, N` | [1559](source_parts/nswc_part_01.f90#L1559) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [1611](source_parts/nswc_part_01.f90#L1611) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHIFTD` | `SUBROUTINE` | `NFRST, NLAST, KK, IARR` | [97819](source_parts/nswc_part_10.f90#L2452) | Not indexed |
| `SHRSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [45680](source_parts/nswc_part_05.f90#L3475) | Not indexed |
| `SI` | `FUNCTION` | `X` | [10289](source_parts/nswc_part_01.f90#L10289) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `SIGMA1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, KUB, UB, NP1, N5, LX, LR, BS, PS, WS, XS, IWK` | [81672](source_parts/nswc_part_08.f90#L7708) | Not indexed |
| `SIN0` | `REAL FUNCTION` | `X` | [3550](source_parts/nswc_part_01.f90#L3550) | Not indexed |
| `SIN1` | `REAL FUNCTION` | `X` | [3586](source_parts/nswc_part_01.f90#L3586) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [85198](source_parts/nswc_part_09.f90#L347) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [85125](source_parts/nswc_part_09.f90#L274) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SKNP` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, N5, PS, WS, XS, IWK` | [81872](source_parts/nswc_part_08.f90#L7908) | Not indexed |
| `SKNP1` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, PS, WS, XS, D, MIN, PBAR, WBAR, ZBAR` | [81902](source_parts/nswc_part_08.f90#L7938) | Not indexed |
| `SLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [36663](source_parts/nswc_part_04.f90#L5076) | Not indexed |
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [36939](source_parts/nswc_part_04.f90#L5352) | [Documented](docs/08-matrices.md#topic-168-01) |
| `SLVS` | `SUBROUTINE` | `WM, IWM, X, TEM` | [115590](source_parts/nswc_part_11.f90#L9432) | Not indexed |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [35303](source_parts/nswc_part_04.f90#L3716) | [Documented](docs/08-matrices.md#topic-151-01) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [34699](source_parts/nswc_part_04.f90#L3112) | [Documented](docs/08-matrices.md#topic-146-01) |
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [79049](source_parts/nswc_part_08.f90#L5085) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SMPLX1` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [79095](source_parts/nswc_part_08.f90#L5131) | Not indexed |
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [35840](source_parts/nswc_part_04.f90#L4253) | [Documented](docs/08-matrices.md#topic-159-01) |
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [39506](source_parts/nswc_part_04.f90#L7919) | [Documented](docs/08-matrices.md#topic-173-01) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [35373](source_parts/nswc_part_04.f90#L3786) | [Documented](docs/08-matrices.md#topic-153-01) |
| `SNBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [52432](source_parts/nswc_part_05.f90#L10227) | Not indexed |
| `SNBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [52609](source_parts/nswc_part_05.f90#L10404) | Not indexed |
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [3896](source_parts/nswc_part_01.f90#L3896) | [Documented](docs/02-elementary-operations.md#topic-035-01) |
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [55621](source_parts/nswc_part_06.f90#L2874) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [33998](source_parts/nswc_part_04.f90#L2411) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SOL` | `SUBROUTINE` | `N, NDIM, A, B, IP` | [36556](source_parts/nswc_part_04.f90#L4969) | Not indexed |
| `SOLBT` | `SUBROUTINE` | `M, N, A, B, C, Y, IP` | [39436](source_parts/nswc_part_04.f90#L7849) | Not indexed |
| `SOLVE2` | `SUBROUTINE` | `M, N, M1, A, B, W, N1, IPIVOT, QR, D, ETA, FAIL, NUMIT, DIGITX, X, RES, WRES, Y1, Y2, Y, F, G, MM, MMPNN` | [73965](source_parts/nswc_part_08.f90#L1) | Not indexed |
| `SOLVE3` | `SUBROUTINE` | `F, M1, M, N1, QR, D, Y, MMPNN` | [74122](source_parts/nswc_part_08.f90#L158) | Not indexed |
| `SONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [58155](source_parts/nswc_part_06.f90#L5408) | Not indexed |
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [89580](source_parts/nswc_part_09.f90#L4729) | [Documented](docs/18-curve-fitting.md#topic-344-01) |
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [95368](source_parts/nswc_part_10.f90#L1) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-379-01) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [89417](source_parts/nswc_part_09.f90#L4566) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [74269](source_parts/nswc_part_08.f90#L305) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `SPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [56871](source_parts/nswc_part_06.f90#L4124) | Not indexed |
| `SPMPAR` | `REAL FUNCTION` | `I` | [1252](source_parts/nswc_part_01.f90#L1252) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [55746](source_parts/nswc_part_06.f90#L2999) | [Documented](docs/11-sparse-matrices.md#topic-244-01) |
| `SPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [41751](source_parts/nswc_part_04.f90#L10164) | Not indexed |
| `SPPFA` | `SUBROUTINE` | `AP, N, INFO` | [41588](source_parts/nswc_part_04.f90#L10001) | Not indexed |
| `SPPSL` | `SUBROUTINE` | `AP, N, B` | [41681](source_parts/nswc_part_04.f90#L10094) | Not indexed |
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [55138](source_parts/nswc_part_06.f90#L2391) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [56167](source_parts/nswc_part_06.f90#L3420) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `SQUIN2` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD, EYE, TEMP, NW, TOL, MAXITS, IERR` | [47114](source_parts/nswc_part_05.f90#L4909) | Not indexed |
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [47012](source_parts/nswc_part_05.f90#L4807) | [Documented](docs/08-matrices.md#topic-189-01) |
| `SRCH` | `SUBROUTINE` | `FUN, COND, XL, ETA, X, NUM, IERR` | [82328](source_parts/nswc_part_08.f90#L8364) | Not indexed |
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [32745](source_parts/nswc_part_04.f90#L1158) | [Documented](docs/07-vectors.md#topic-132-01) |
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [3265](source_parts/nswc_part_01.f90#L3265) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [33020](source_parts/nswc_part_04.f90#L1433) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [32867](source_parts/nswc_part_04.f90#L1280) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [33584](source_parts/nswc_part_04.f90#L1997) | [Documented](docs/07-vectors.md#topic-137-01) |
| `SSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [39547](source_parts/nswc_part_04.f90#L7960) | Not indexed |
| `SSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [40289](source_parts/nswc_part_04.f90#L8702) | Not indexed |
| `SSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [39836](source_parts/nswc_part_04.f90#L8249) | Not indexed |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [79892](source_parts/nswc_part_08.f90#L5928) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SSPLX1` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [79940](source_parts/nswc_part_08.f90#L5976) | Not indexed |
| `SSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [40105](source_parts/nswc_part_04.f90#L8518) | Not indexed |
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [54946](source_parts/nswc_part_06.f90#L2199) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [43501](source_parts/nswc_part_05.f90#L1296) | [Documented](docs/08-matrices.md#topic-183-01) |
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [32588](source_parts/nswc_part_04.f90#L1001) | [Documented](docs/07-vectors.md#topic-131-01) |
| `STEP1` | `SUBROUTINE` | `F, NEQN, Y, X, H, EPS, WT, START, HOLD, K, KOLD, CRASH, PHI, P, YP, PSI, ALPHA, BETA, SIG, V, W, G, PHASE1, NS, NORND` | [110479](source_parts/nswc_part_11.f90#L4321) | Not indexed |
| `STFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR, JAC` | [113300](source_parts/nswc_part_11.f90#L7142) | Not indexed |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [74709](source_parts/nswc_part_08.f90#L745) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `STOD` | `SUBROUTINE` | `NEQ, Y, YH, NYH, YH1, EWT, SAVF, ACOR, WM, IWM, F, JAC, RPAR, IPAR` | [114842](source_parts/nswc_part_11.f90#L8684) | Not indexed |
| `STORE2` | `SUBROUTINE` | `A, B` | [983](source_parts/nswc_part_01.f90#L983) | Not indexed |
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [95983](source_parts/nswc_part_10.f90#L616) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-384-01) |
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [96373](source_parts/nswc_part_10.f90#L1006) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `SVCO` | `SUBROUTINE` | `RSAV, ISAV` | [114119](source_parts/nswc_part_11.f90#L7961) | Not indexed |
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [35768](source_parts/nswc_part_04.f90#L4181) | [Documented](docs/08-matrices.md#topic-157-01) |
| `SWAPD` | `SUBROUTINE` | `NIN1, NIN2, NOUT1, NOUT2, IADJ, IEND` | [97934](source_parts/nswc_part_10.f90#L2567) | Not indexed |
| `SWPTST` | `LOGICAL FUNCTION` | `IN1, IN2, IO1, IO2, X, Y` | [98123](source_parts/nswc_part_10.f90#L2756) | Not indexed |
| `SYMSLV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [46564](source_parts/nswc_part_05.f90#L4359) | Not indexed |
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [46392](source_parts/nswc_part_05.f90#L4187) | [Documented](docs/08-matrices.md#topic-188-01) |
| `TASLV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [46455](source_parts/nswc_part_05.f90#L4250) | Not indexed |
| `TERMS` | `SUBROUTINE` | `DIAG, SDIAG, SIGMA, DEL` | [92950](source_parts/nswc_part_09.f90#L8099) | Not indexed |
| `TINDX` | `INTEGER FUNCTION` | `NVERTX, NABOR, IADJ, IEND` | [98225](source_parts/nswc_part_10.f90#L2858) | Not indexed |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [34803](source_parts/nswc_part_04.f90#L3216) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [35822](source_parts/nswc_part_04.f90#L4235) | [Documented](docs/08-matrices.md#topic-158-01) |
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [42206](source_parts/nswc_part_05.f90#L1) | [Documented](docs/08-matrices.md#topic-177-01) |
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [34758](source_parts/nswc_part_04.f90#L3171) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [63165](source_parts/nswc_part_06.f90#L10418) | Not indexed |
| `TQLRAT` | `SUBROUTINE` | `N, D, E2, IERR` | [62750](source_parts/nswc_part_06.f90#L10003) | Not indexed |
| `TQLRT0` | `SUBROUTINE` | `N, D, E2, IERR` | [118824](source_parts/nswc_part_12.f90#L1916) | Not indexed |
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [121512](source_parts/nswc_part_12.f90#L4604) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `TRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [62516](source_parts/nswc_part_06.f90#L9769) | Not indexed |
| `TRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [63023](source_parts/nswc_part_06.f90#L10276) | Not indexed |
| `TRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [62634](source_parts/nswc_part_06.f90#L9887) | Not indexed |
| `TRFIND` | `SUBROUTINE` | `NST, PX, PY, X, Y, IADJ, IEND, I1, I2, I3` | [98281](source_parts/nswc_part_10.f90#L2914) | Not indexed |
| `TRISLV` | `SUBROUTINE` | `NM, N, U, V, L, F, TEMP, IERR` | [47830](source_parts/nswc_part_05.f90#L5625) | Not indexed |
| `TRISP` | `SUBROUTINE` | `N, A, B, C, D, U, Z` | [117469](source_parts/nswc_part_12.f90#L561) | Not indexed |
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [97115](source_parts/nswc_part_10.f90#L1748) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `TRP` | `FUNCTION` | `A, N, X, Y` | [88704](source_parts/nswc_part_09.f90#L3853) | [Documented](docs/18-curve-fitting.md#topic-336-01) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [56712](source_parts/nswc_part_06.f90#L3965) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `TSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [56815](source_parts/nswc_part_06.f90#L4068) | Not indexed |
| `TVAL` | `SUBROUTINE` | `X, Y, X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3, ZX1, ZX2, ZX3, ZY1, ZY2, ZY3, IFLAG, W, WX, WY, IER` | [99743](source_parts/nswc_part_10.f90#L4376) | Not indexed |
| `U11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [67747](source_parts/nswc_part_07.f90#L4406) | Not indexed |
| `U11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [68171](source_parts/nswc_part_07.f90#L4830) | Not indexed |
| `U12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [68021](source_parts/nswc_part_07.f90#L4680) | Not indexed |
| `U12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [68445](source_parts/nswc_part_07.f90#L5104) | Not indexed |
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [119236](source_parts/nswc_part_12.f90#L2328) | [Documented](docs/26-discrete-random-number-generation.md#topic-438-01) |
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [119340](source_parts/nswc_part_12.f90#L2432) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `URNG0` | `SUBROUTINE` | `IX, U, V` | [119503](source_parts/nswc_part_12.f90#L2595) | Not indexed |
| `URNG1` | `SUBROUTINE` | `IX, U, V, D` | [119646](source_parts/nswc_part_12.f90#L2738) | Not indexed |
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [119797](source_parts/nswc_part_12.f90#L2889) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [26482](source_parts/nswc_part_03.f90#L5441) | [Documented](docs/04-special-functions.md#topic-105-01) |
| `VNORM` | `FUNCTION` | `V, NCOMP` | [115973](source_parts/nswc_part_11.f90#L9815) | Not indexed |
| `VNWRMS` | `REAL FUNCTION` | `N, V, W` | [115992](source_parts/nswc_part_11.f90#L9834) | Not indexed |
| `VRSHFT` | `SUBROUTINE` | `L3, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [31838](source_parts/nswc_part_04.f90#L251) | Not indexed |
| `WANDT` | `SUBROUTINE` | `WV, TV, N, A, B` | [109495](source_parts/nswc_part_11.f90#L3337) | Not indexed |
| `WNLIT` | `SUBROUTINE` | `W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM, IDOPE, DOPE, DONE` | [72961](source_parts/nswc_part_07.f90#L9620) | Not indexed |
| `WNLSM` | `SUBROUTINE` | `W, MDW, MME, MA, N, L, PRGOPT, X, RNORM, MODE, IPIVOT, ITYPE, WD, H, SCALE, Z, TEMP, D` | [72327](source_parts/nswc_part_07.f90#L8986) | Not indexed |
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [72060](source_parts/nswc_part_07.f90#L8719) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-296-01) |
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [89123](source_parts/nswc_part_09.f90#L4272) | [Documented](docs/18-curve-fitting.md#topic-341-01) |
| `XCOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [82691](source_parts/nswc_part_08.f90#L8727) | Not indexed |
| `XCONDX` | `FUNCTION` | `X, Y, C, FUN` | [82766](source_parts/nswc_part_08.f90#L8802) | Not indexed |
| `XCONDY` | `FUNCTION` | `X, Y, C, FUN` | [82785](source_parts/nswc_part_08.f90#L8821) | Not indexed |
| `XL1` | `SUBROUTINE` | `K, L, M, N, KLMD, KLM2D, NKLMD, N2D, Q, KODE, TOLER, ITER, X, RES, ERROR, CU, IU, S` | [66432](source_parts/nswc_part_07.f90#L3091) | Not indexed |
| `YCHG` | `SUBROUTINE` | `X, Y, YOLD` | [35550](source_parts/nswc_part_04.f90#L3963) | Not indexed |
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [28701](source_parts/nswc_part_03.f90#L7660) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `ZZZJAC` | `SUBROUTINE` | `T, Y, PD, N, RPAR, IPAR` | [113284](source_parts/nswc_part_11.f90#L7126) | Not indexed |
