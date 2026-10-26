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
| `ABCON` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [87441](source_parts/nswc_part_09.f90#L2704) | Not indexed |
| `ABCON1` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [87637](source_parts/nswc_part_09.f90#L2900) | Not indexed |
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [47347](source_parts/nswc_part_05.f90#L5062) | [Documented](docs/08-matrices.md#topic-186-01) |
| `ABSLV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [47431](source_parts/nswc_part_05.f90#L5146) | Not indexed |
| `ACOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [87765](source_parts/nswc_part_09.f90#L3028) | Not indexed |
| `ACONDF` | `FUNCTION` | `X, Y, C, FUN` | [87838](source_parts/nswc_part_09.f90#L3101) | Not indexed |
| `ACONDG` | `FUNCTION` | `X, Y, C, FUN` | [87856](source_parts/nswc_part_09.f90#L3119) | Not indexed |
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [92166](source_parts/nswc_part_09.f90#L7429) | [Documented](docs/17-approximation-of-functions.md#topic-329-01) |
| `ADAPT1` | `SUBROUTINE` | `F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [92255](source_parts/nswc_part_09.f90#L7518) | Not indexed |
| `ADCHK` | `SUBROUTINE` | `` | [93099](source_parts/nswc_part_09.f90#L8362) | Not indexed |
| `ADCOMP` | `SUBROUTINE` | `F` | [92717](source_parts/nswc_part_09.f90#L7980) | Not indexed |
| `ADNODE` | `SUBROUTINE` | `KK, X, Y, IADJ, IEND, IER` | [103415](source_parts/nswc_part_10.f90#L8103) | Not indexed |
| `ADPUT` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [93160](source_parts/nswc_part_09.f90#L8423) | Not indexed |
| `ADSET` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [92479](source_parts/nswc_part_09.f90#L7742) | Not indexed |
| `ADTAKE` | `SUBROUTINE` | `IERR` | [92634](source_parts/nswc_part_09.f90#L7897) | Not indexed |
| `ADTRAN` | `SUBROUTINE` | `D, POWERS` | [93246](source_parts/nswc_part_09.f90#L8509) | Not indexed |
| `AERF` | `REAL FUNCTION` | `X, H` | [7996](source_parts/nswc_part_01.f90#L7996) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `AI` | `REAL FUNCTION` | `X` | [23547](source_parts/nswc_part_03.f90#L2420) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AIA` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [22508](source_parts/nswc_part_03.f90#L1381) | Not indexed |
| `AIE` | `REAL FUNCTION` | `X` | [23686](source_parts/nswc_part_03.f90#L2559) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AII` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [22441](source_parts/nswc_part_03.f90#L1314) | Not indexed |
| `AIMP` | `SUBROUTINE` | `X, R, PHI` | [24203](source_parts/nswc_part_03.f90#L3076) | Not indexed |
| `AIRM` | `SUBROUTINE` | `IND, Z, AI, AIP, BI, BIP` | [22360](source_parts/nswc_part_03.f90#L1233) | Not indexed |
| `ALGDIV` | `REAL FUNCTION` | `A, B` | [13433](source_parts/nswc_part_02.f90#L2848) | Not indexed |
| `ALI` | `REAL FUNCTION` | `X` | [10702](source_parts/nswc_part_02.f90#L117) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `ALLOT` | `SUBROUTINE` | `DEGREE, NPOLYS, NPTS, DIMEN, IWORK, IWKLEN, IREQD, DREQD, ERROR` | [106408](source_parts/nswc_part_11.f90#L466) | Not indexed |
| `ALNREL` | `REAL FUNCTION` | `A` | [4250](source_parts/nswc_part_01.f90#L4250) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [3497](source_parts/nswc_part_01.f90#L3497) | [Documented](docs/02-elementary-operations.md#topic-032-01) |
| `AORD` | `SUBROUTINE` | `A, N` | [1984](source_parts/nswc_part_01.f90#L1984) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `APSER` | `REAL FUNCTION` | `A, B, X, EPS` | [16046](source_parts/nswc_part_02.f90#L5461) | Not indexed |
| `ARCEBE` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, PIVOT, X` | [40897](source_parts/nswc_part_04.f90#L9122) | Not indexed |
| `ARCEBM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [40872](source_parts/nswc_part_04.f90#L9097) | Not indexed |
| `ARCEBS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [40845](source_parts/nswc_part_04.f90#L9070) | Not indexed |
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [39893](source_parts/nswc_part_04.f90#L8118) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARCEDC` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, IFLAG` | [40032](source_parts/nswc_part_04.f90#L8257) | Not indexed |
| `ARCEFE` | `SUBROUTINE` | `BLOCK, NRWBLK, NRWPIV, PIVOT, B` | [40813](source_parts/nswc_part_04.f90#L9038) | Not indexed |
| `ARCEFM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, B, X` | [40788](source_parts/nswc_part_04.f90#L9013) | Not indexed |
| `ARCEFS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, B, X` | [40759](source_parts/nswc_part_04.f90#L8984) | Not indexed |
| `ARCEPC` | `SUBROUTINE` | `TOPBLK, NRWTOP, NOVRLP, BOTBLK, NRWBOT, NCLPIV, PIVOT, PIVMAX, IFLAG` | [40422](source_parts/nswc_part_04.f90#L8647) | Not indexed |
| `ARCEPR` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, PIVOT, PIVMAX, IFLAG` | [40312](source_parts/nswc_part_04.f90#L8537) | Not indexed |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [40536](source_parts/nswc_part_04.f90#L8761) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARTNQ` | `FUNCTION` | `Y, X` | [2956](source_parts/nswc_part_01.f90#L2956) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `ASIK` | `SUBROUTINE` | `X, FNU, KODE, FLGIK, RA, ARG, IN, TOL, Y` | [20786](source_parts/nswc_part_02.f90#L10201) | Not indexed |
| `ASJY` | `SUBROUTINE` | `FUNJY, X, FNU, FLGJY, IN, TOL, ELIM, Y, WK, IFLW` | [18841](source_parts/nswc_part_02.f90#L8256) | Not indexed |
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [85968](source_parts/nswc_part_09.f90#L1231) | [Documented](docs/15-optimization.md#topic-314-01) |
| `ASSGN1` | `SUBROUTINE` | `N, A, C, T, CH, LC, LR, LZ, NZ, RH, SLC, SLR, U, IERR` | [86007](source_parts/nswc_part_09.f90#L1270) | Not indexed |
| `ATN` | `COMPLEX FUNCTION` | `Z` | [24999](source_parts/nswc_part_03.f90#L3872) | Not indexed |
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [55812](source_parts/nswc_part_06.f90#L2983) | [Documented](docs/10-banded-matrices.md#topic-217-01) |
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [54519](source_parts/nswc_part_06.f90#L1690) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [52518](source_parts/nswc_part_05.f90#L10233) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `BALANC` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [62583](source_parts/nswc_part_06.f90#L9754) | Not indexed |
| `BALBAK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [63421](source_parts/nswc_part_07.f90#L1) | Not indexed |
| `BALINV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [62776](source_parts/nswc_part_06.f90#L9947) | Not indexed |
| `BANFAC` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, IFLAG` | [99653](source_parts/nswc_part_10.f90#L4341) | Not indexed |
| `BANSLV` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, B` | [99780](source_parts/nswc_part_10.f90#L4468) | Not indexed |
| `BASIZ` | `SUBROUTINE` | `DEGREE, NPTS, DIMEN, NPOLYS, ERROR` | [106634](source_parts/nswc_part_11.f90#L692) | Not indexed |
| `BASYM` | `REAL FUNCTION` | `A, B, LAMBDA, EPS` | [16879](source_parts/nswc_part_02.f90#L6294) | Not indexed |
| `BCHFAC` | `SUBROUTINE` | `W, NB, N, DIAG, IFLAG` | [99965](source_parts/nswc_part_10.f90#L4653) | Not indexed |
| `BCHSLV` | `SUBROUTINE` | `W, NB, N, B` | [100083](source_parts/nswc_part_10.f90#L4771) | Not indexed |
| `BCHSV1` | `SUBROUTINE` | `W, NB, N, B, KB, M` | [103006](source_parts/nswc_part_10.f90#L7694) | Not indexed |
| `BCORR` | `REAL FUNCTION` | `A0, B0` | [13387](source_parts/nswc_part_02.f90#L2802) | Not indexed |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [52127](source_parts/nswc_part_05.f90#L9842) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [52258](source_parts/nswc_part_05.f90#L9973) | [Documented](docs/10-banded-matrices.md#topic-202-01) |
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [52108](source_parts/nswc_part_05.f90#L9823) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BDYADD` | `SUBROUTINE` | `KK, I1, I2, IADJ, IEND` | [103562](source_parts/nswc_part_10.f90#L8250) | Not indexed |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [20264](source_parts/nswc_part_02.f90#L9679) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [18326](source_parts/nswc_part_02.f90#L7741) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [13241](source_parts/nswc_part_02.f90#L2656) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [100143](source_parts/nswc_part_10.f90#L4831) | [Documented](docs/18-curve-fitting.md#topic-376-01) |
| `BFIT0` | `SUBROUTINE` | `NDATA, XDATA, YDATA, NORD, NBKPT, BKPT, NCONST, XCONST, YCONST, NDERIV, MODE, COEFF, RNORM, BF, G, MDG, W, MDW, WORK, IWORK` | [100385](source_parts/nswc_part_10.f90#L5073) | Not indexed |
| `BFRAC` | `REAL FUNCTION` | `A, B, X, Y, LAMBDA, EPS` | [16276](source_parts/nswc_part_02.f90#L5691) | Not indexed |
| `BGRAT` | `SUBROUTINE` | `A, B, X, Y, W, EPS, IERR` | [16666](source_parts/nswc_part_02.f90#L6081) | Not indexed |
| `BI` | `REAL FUNCTION` | `X` | [23823](source_parts/nswc_part_03.f90#L2696) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BIA` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [22827](source_parts/nswc_part_03.f90#L1700) | Not indexed |
| `BIE` | `REAL FUNCTION` | `X` | [24017](source_parts/nswc_part_03.f90#L2890) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BII` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [22749](source_parts/nswc_part_03.f90#L1622) | Not indexed |
| `BIM` | `SUBROUTINE` | `Z, CN, W` | [23191](source_parts/nswc_part_03.f90#L2064) | Not indexed |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [52202](source_parts/nswc_part_05.f90#L9917) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BJM` | `SUBROUTINE` | `Z, CN, W` | [23359](source_parts/nswc_part_03.f90#L2232) | Not indexed |
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [58504](source_parts/nswc_part_06.f90#L5675) | [Documented](docs/11-sparse-matrices.md#topic-245-01) |
| `BLKTR1` | `SUBROUTINE` | `N, AN, BN, CN, M, AM, BM, CM, IDIMY, Y, B, W1, W2, W3, WD, WW, WU, PRDCT, CPRDCT` | [124412](source_parts/nswc_part_12.f90#L7957) | Not indexed |
| `BLKTRI` | `SUBROUTINE` | `IFLG, NP, N, AN, BN, CN, MP, M, AM, BM, CM, IDIMY, Y, IERROR, W` | [124192](source_parts/nswc_part_12.f90#L7737) | Not indexed |
| `BLND` | `REAL FUNCTION` | `A, B` | [17268](source_parts/nswc_part_02.f90#L6683) | Not indexed |
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [79726](source_parts/nswc_part_08.f90#L5766) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-302-01) |
| `BNDACC` | `SUBROUTINE` | `G, MDG, NB, IP, IR, MT, JT` | [100701](source_parts/nswc_part_10.f90#L5389) | Not indexed |
| `BNDSL` | `SUBROUTINE` | `MODE, G, MDG, NB, IP, IR, X, N, RNORM, IERR` | [100935](source_parts/nswc_part_10.f90#L5623) | Not indexed |
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [54497](source_parts/nswc_part_06.f90#L1668) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [52344](source_parts/nswc_part_05.f90#L10059) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [53454](source_parts/nswc_part_06.f90#L625) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `BPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [16084](source_parts/nswc_part_02.f90#L5499) | Not indexed |
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [15717](source_parts/nswc_part_02.f90#L5132) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BRCMP1` | `REAL FUNCTION` | `MU, A, B, X, Y` | [16506](source_parts/nswc_part_02.f90#L5921) | Not indexed |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [16351](source_parts/nswc_part_02.f90#L5766) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [52146](source_parts/nswc_part_05.f90#L9861) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [117267](source_parts/nswc_part_12.f90#L812) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-418-01) |
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [99844](source_parts/nswc_part_10.f90#L4532) | [Documented](docs/18-curve-fitting.md#topic-375-01) |
| `BSLSQ1` | `SUBROUTINE` | `TAU, WGT, NTAU, Z, KZ, M, T, N, K, A, KA, WK, Q, IERR` | [102865](source_parts/nswc_part_10.f90#L7553) | Not indexed |
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [102786](source_parts/nswc_part_10.f90#L7474) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-389-01) |
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [54666](source_parts/nswc_part_06.f90#L1837) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [54770](source_parts/nswc_part_06.f90#L1941) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [99060](source_parts/nswc_part_10.f90#L3748) | [Documented](docs/18-curve-fitting.md#topic-371-01) |
| `BSPVB` | `SUBROUTINE` | `T, K, JHIGH, J, X, LEFT, BLIST` | [99263](source_parts/nswc_part_10.f90#L3951) | Not indexed |
| `BSPVD` | `SUBROUTINE` | `T, K, X, LEFT, DBIATX, IDIM, NDERIV, A` | [99326](source_parts/nswc_part_10.f90#L4014) | Not indexed |
| `BSRH` | `FUNCTION` | `XLL, XRR, IZ, C, A, BH, F, SGN` | [125718](source_parts/nswc_part_12.f90#L9263) | Not indexed |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [19950](source_parts/nswc_part_02.f90#L9365) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [18033](source_parts/nswc_part_02.f90#L7448) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [22051](source_parts/nswc_part_03.f90#L924) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [19573](source_parts/nswc_part_02.f90#L8988) | [Documented](docs/04-special-functions.md#topic-081-01) |
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [99482](source_parts/nswc_part_10.f90#L4170) | [Documented](docs/18-curve-fitting.md#topic-373-01) |
| `BSTRP1` | `SUBROUTINE` | `X, Z, KZ, M, N, T, K, A, KA, WORK, IFLAG` | [102734](source_parts/nswc_part_10.f90#L7422) | Not indexed |
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [102667](source_parts/nswc_part_10.f90#L7355) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-388-01) |
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [52986](source_parts/nswc_part_06.f90#L157) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54211](source_parts/nswc_part_06.f90#L1382) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54262](source_parts/nswc_part_06.f90#L1433) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [40935](source_parts/nswc_part_04.f90#L9160) | [Documented](docs/08-matrices.md#topic-171-01) |
| `BUP` | `REAL FUNCTION` | `A, B, X, Y, N, EPS` | [16192](source_parts/nswc_part_02.f90#L5607) | Not indexed |
| `BUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, II, K1, K2, N, M, NP1` | [5955](source_parts/nswc_part_01.f90#L5955) | Not indexed |
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [98706](source_parts/nswc_part_10.f90#L3394) | [Documented](docs/18-curve-fitting.md#topic-369-01) |
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [103087](source_parts/nswc_part_10.f90#L7775) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-391-01) |
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [98891](source_parts/nswc_part_10.f90#L3579) | [Documented](docs/18-curve-fitting.md#topic-370-01) |
| `BVALI0` | `SUBROUTINE` | `T, TNEW, BCOEF, N, K, X, W, WK` | [98949](source_parts/nswc_part_10.f90#L3637) | Not indexed |
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [53919](source_parts/nswc_part_06.f90#L1090) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [53971](source_parts/nswc_part_06.f90#L1142) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [22300](source_parts/nswc_part_03.f90#L1173) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CALCSC` | `SUBROUTINE` | `TYPE, N, K, QK` | [32156](source_parts/nswc_part_04.f90#L381) | Not indexed |
| `CALCT` | `SUBROUTINE` | `BOOL, N, SR, SI, TR, TI, PVR, PVI, ARE, HR, HI, QHR, QHI` | [33136](source_parts/nswc_part_04.f90#L1361) | Not indexed |
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [3226](source_parts/nswc_part_01.f90#L3226) | [Documented](docs/02-elementary-operations.md#topic-028-02) |
| `CAUCHY` | `SUBROUTINE` | `NN, BND, PT, Q` | [32680](source_parts/nswc_part_04.f90#L905) | Not indexed |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [35131](source_parts/nswc_part_04.f90#L3356) | [Documented](docs/07-vectors.md#topic-138-01) |
| `CBABK2` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [68456](source_parts/nswc_part_07.f90#L5036) | Not indexed |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [52830](source_parts/nswc_part_06.f90#L1) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `CBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [67870](source_parts/nswc_part_07.f90#L4450) | Not indexed |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [30623](source_parts/nswc_part_03.f90#L9496) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `CBDB` | `SUBROUTINE` | `CZ, CNU, FN, W` | [17710](source_parts/nswc_part_02.f90#L7125) | Not indexed |
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [20894](source_parts/nswc_part_02.f90#L10309) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [56213](source_parts/nswc_part_06.f90#L3384) | Not indexed |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [22689](source_parts/nswc_part_03.f90#L1562) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CBJA` | `SUBROUTINE` | `CZ, CNU, W` | [17908](source_parts/nswc_part_02.f90#L7323) | Not indexed |
| `CBJM` | `SUBROUTINE` | `Z, CNU, W` | [17587](source_parts/nswc_part_02.f90#L7002) | Not indexed |
| `CBKA` | `SUBROUTINE` | `Z, CNU, W` | [21060](source_parts/nswc_part_02.f90#L10475) | Not indexed |
| `CBKI` | `SUBROUTINE` | `Z, CNU, W` | [21018](source_parts/nswc_part_02.f90#L10433) | Not indexed |
| `CBKM` | `SUBROUTINE` | `Z, RZ, CNU, W` | [21128](source_parts/nswc_part_03.f90#L1) | Not indexed |
| `CBKML` | `SUBROUTINE` | `Z, R, ZR, NU, N, W, W0` | [21417](source_parts/nswc_part_03.f90#L290) | Not indexed |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [33457](source_parts/nswc_part_04.f90#L1682) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [52460](source_parts/nswc_part_05.f90#L10175) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [53764](source_parts/nswc_part_06.f90#L935) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `CBRT` | `REAL FUNCTION` | `X` | [2915](source_parts/nswc_part_01.f90#L2915) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `CBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [56388](source_parts/nswc_part_06.f90#L3559) | Not indexed |
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [56049](source_parts/nswc_part_06.f90#L3220) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [56131](source_parts/nswc_part_06.f90#L3302) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [94608](source_parts/nswc_part_09.f90#L9871) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [19899](source_parts/nswc_part_02.f90#L9314) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [17347](source_parts/nswc_part_02.f90#L6762) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [21543](source_parts/nswc_part_03.f90#L416) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [53298](source_parts/nswc_part_06.f90#L469) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54402](source_parts/nswc_part_06.f90#L1573) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54453](source_parts/nswc_part_06.f90#L1624) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54114](source_parts/nswc_part_06.f90#L1285) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54166](source_parts/nswc_part_06.f90#L1337) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [33733](source_parts/nswc_part_04.f90#L1958) | [Documented](docs/07-vectors.md#topic-130-01) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [47269](source_parts/nswc_part_05.f90#L4984) | [Documented](docs/08-matrices.md#topic-185-01) |
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [3093](source_parts/nswc_part_01.f90#L3093) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [3120](source_parts/nswc_part_01.f90#L3120) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [34798](source_parts/nswc_part_04.f90#L3023) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [34839](source_parts/nswc_part_04.f90#L3064) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CEEZ` | `SUBROUTINE` | `DEL1, DEL2, SIGMA, C1, C2, C3, N` | [98485](source_parts/nswc_part_10.f90#L3173) | Not indexed |
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [67738](source_parts/nswc_part_07.f90#L4318) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-273-01) |
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [67791](source_parts/nswc_part_07.f90#L4371) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-274-01) |
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [6073](source_parts/nswc_part_01.f90#L6073) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [6218](source_parts/nswc_part_01.f90#L6218) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERR` | `SUBROUTINE` | `T, FT, GT, PHIT, DEL, IERR, L, LP1, M, NP1, D` | [92118](source_parts/nswc_part_09.f90#L7381) | Not indexed |
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [10386](source_parts/nswc_part_01.f90#L10386) | [Documented](docs/04-special-functions.md#topic-062-01) |
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [9233](source_parts/nswc_part_01.f90#L9233) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `CFLECT` | `COMPLEX FUNCTION` | `Z` | [24566](source_parts/nswc_part_03.f90#L3439) | Not indexed |
| `CFOD` | `SUBROUTINE` | `METH, ELCO, TESCO` | [121638](source_parts/nswc_part_12.f90#L5183) | Not indexed |
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [8852](source_parts/nswc_part_01.f90#L8852) | [Documented](docs/04-special-functions.md#topic-056-01) |
| `CGAM0` | `COMPLEX FUNCTION` | `Z` | [11092](source_parts/nswc_part_02.f90#L507) | Not indexed |
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [10844](source_parts/nswc_part_02.f90#L259) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `CGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [44455](source_parts/nswc_part_05.f90#L2170) | Not indexed |
| `CGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [44921](source_parts/nswc_part_05.f90#L2636) | Not indexed |
| `CGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [44666](source_parts/nswc_part_05.f90#L2381) | Not indexed |
| `CGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [44781](source_parts/nswc_part_05.f90#L2496) | Not indexed |
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [91776](source_parts/nswc_part_09.f90#L7039) | [Documented](docs/17-approximation-of-functions.md#topic-327-01) |
| `CHEBY1` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, LP1, MP1, LPM, N, NP1, X, XVAL, C, D, ERR, H` | [91814](source_parts/nswc_part_09.f90#L7077) | Not indexed |
| `CHKPRM` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, C, D, N, NBDCND, COFX, COFY, IDMN, MN, IERROR` | [123679](source_parts/nswc_part_12.f90#L7224) | Not indexed |
| `CHKSNG` | `SUBROUTINE` | `MBDCND, NBDCND, ALPHA, BETA, GAMA, XNU, COFX, COFY, SINGLR` | [123752](source_parts/nswc_part_12.f90#L7297) | Not indexed |
| `CIN` | `FUNCTION` | `X` | [10272](source_parts/nswc_part_01.f90#L10272) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [27660](source_parts/nswc_part_03.f90#L6533) | [Documented](docs/04-special-functions.md#topic-107-01) |
| `CK` | `COMPLEX FUNCTION` | `K, L` | [24332](source_parts/nswc_part_03.f90#L3205) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKA` | `SUBROUTINE` | `Z, NU, W` | [21703](source_parts/nswc_part_03.f90#L576) | Not indexed |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [24708](source_parts/nswc_part_03.f90#L3581) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKM` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [21771](source_parts/nswc_part_03.f90#L644) | Not indexed |
| `CKML` | `SUBROUTINE` | `Z, R, ZR, NU, K1, K2` | [21900](source_parts/nswc_part_03.f90#L773) | Not indexed |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [37270](source_parts/nswc_part_04.f90#L5495) | [Documented](docs/08-matrices.md#topic-160-01) |
| `CKPS` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [21268](source_parts/nswc_part_03.f90#L141) | Not indexed |
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [70216](source_parts/nswc_part_07.f90#L6796) | [Documented](docs/13-l1-solution-of-linear-equations.md#topic-279-01) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [50860](source_parts/nswc_part_05.f90#L8575) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `CLI` | `COMPLEX FUNCTION` | `Z` | [10586](source_parts/nswc_part_02.f90#L1) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `CLOC` | `LOGICAL FUNCTION` | `X, Y` | [37075](source_parts/nswc_part_04.f90#L5300) | Not indexed |
| `CLUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [44346](source_parts/nswc_part_05.f90#L2061) | Not indexed |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [36640](source_parts/nswc_part_04.f90#L4865) | [Documented](docs/08-matrices.md#topic-151-01) |
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36556](source_parts/nswc_part_04.f90#L4781) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36075](source_parts/nswc_part_04.f90#L4300) | [Documented](docs/08-matrices.md#topic-147-01) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36061](source_parts/nswc_part_04.f90#L4286) | [Documented](docs/08-matrices.md#topic-146-01) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [51838](source_parts/nswc_part_05.f90#L9553) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [52040](source_parts/nswc_part_05.f90#L9755) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36006](source_parts/nswc_part_04.f90#L4231) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [37012](source_parts/nswc_part_04.f90#L5237) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [35992](source_parts/nswc_part_04.f90#L4217) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [44224](source_parts/nswc_part_05.f90#L1939) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [44268](source_parts/nswc_part_05.f90#L1983) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [36703](source_parts/nswc_part_04.f90#L4928) | [Documented](docs/08-matrices.md#topic-153-01) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [36776](source_parts/nswc_part_04.f90#L5001) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [61465](source_parts/nswc_part_06.f90#L8636) | Not indexed |
| `COMPB` | `SUBROUTINE` | `N, IERROR, AN, BN, CN, B, AH, BH` | [125219](source_parts/nswc_part_12.f90#L8764) | Not indexed |
| `COMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [68212](source_parts/nswc_part_07.f90#L4792) | Not indexed |
| `COMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [68541](source_parts/nswc_part_07.f90#L5121) | Not indexed |
| `CONEW` | `FUNCTION` | `COND, ELINSY, RELRSD, AVERR, PASTC, PASTRE` | [115704](source_parts/nswc_part_11.f90#L9762) | Not indexed |
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [3450](source_parts/nswc_part_01.f90#L3450) | [Documented](docs/02-elementary-operations.md#topic-031-01) |
| `CORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [68075](source_parts/nswc_part_07.f90#L4655) | Not indexed |
| `COS0` | `REAL FUNCTION` | `X` | [3562](source_parts/nswc_part_01.f90#L3562) | Not indexed |
| `COS1` | `REAL FUNCTION` | `X` | [3647](source_parts/nswc_part_01.f90#L3647) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [90254](source_parts/nswc_part_09.f90#L5517) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQB1` | `SUBROUTINE` | `N, X, W, XH` | [90274](source_parts/nswc_part_09.f90#L5537) | Not indexed |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [90156](source_parts/nswc_part_09.f90#L5419) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQF1` | `SUBROUTINE` | `N, X, W, XH` | [90174](source_parts/nswc_part_09.f90#L5437) | Not indexed |
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [90090](source_parts/nswc_part_09.f90#L5353) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COVAR` | `SUBROUTINE` | `N, M1, N1, IPIVOT, C, D, Z, NN` | [78777](source_parts/nswc_part_08.f90#L4817) | Not indexed |
| `CPABS` | `REAL FUNCTION` | `X, Y` | [3015](source_parts/nswc_part_01.f90#L3015) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [57311](source_parts/nswc_part_06.f90#L4482) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [57375](source_parts/nswc_part_06.f90#L4546) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, W, Y` | [124975](source_parts/nswc_part_12.f90#L8520) | Not indexed |
| `CPRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, U, Y` | [125086](source_parts/nswc_part_12.f90#L8631) | Not indexed |
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [93386](source_parts/nswc_part_09.f90#L8649) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `CPSI` | `SUBROUTINE` | `Z, W` | [12173](source_parts/nswc_part_02.f90#L1588) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `CQEXT` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES` | [88235](source_parts/nswc_part_09.f90#L3498) | Not indexed |
| `CQZHES` | `SUBROUTINE` | `NM, N, A, B, MATS, Z, F, G, H` | [49595](source_parts/nswc_part_05.f90#L7310) | Not indexed |
| `CQZIT` | `SUBROUTINE` | `NM, N, A, B, EPS1, MATS, Z, F, IERR` | [49813](source_parts/nswc_part_05.f90#L7528) | Not indexed |
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [3052](source_parts/nswc_part_01.f90#L3052) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [37495](source_parts/nswc_part_04.f90#L5720) | [Documented](docs/08-matrices.md#topic-163-01) |
| `CROUT1` | `SUBROUTINE` | `A, KA, N, IEND, INDEX, TEMP, JP, IERR` | [85715](source_parts/nswc_part_09.f90#L978) | Not indexed |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [57578](source_parts/nswc_part_06.f90#L4749) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [34969](source_parts/nswc_part_04.f90#L3194) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56989](source_parts/nswc_part_06.f90#L4160) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [29174](source_parts/nswc_part_03.f90#L8047) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56828](source_parts/nswc_part_06.f90#L3999) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [95775](source_parts/nswc_part_10.f90#L463) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [95883](source_parts/nswc_part_10.f90#L571) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [96005](source_parts/nswc_part_10.f90#L693) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [96509](source_parts/nswc_part_10.f90#L1197) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `CSLOP1` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, A, B, C, E, IERR` | [96562](source_parts/nswc_part_10.f90#L1250) | Not indexed |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [61756](source_parts/nswc_part_06.f90#L8927) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [61861](source_parts/nswc_part_06.f90#L9032) | Not indexed |
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [44310](source_parts/nswc_part_05.f90#L2025) | [Documented](docs/08-matrices.md#topic-182-01) |
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [95010](source_parts/nswc_part_09.f90#L10273) | [Documented](docs/18-curve-fitting.md#topic-345-01) |
| `CSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [62068](source_parts/nswc_part_06.f90#L9239) | Not indexed |
| `CSPP` | `SUBROUTINE` | `T, A, KA, M, N, Z, KZ, DZ, KDZ` | [101303](source_parts/nswc_part_10.f90#L5991) | Not indexed |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [57972](source_parts/nswc_part_06.f90#L5143) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [61346](source_parts/nswc_part_06.f90#L8517) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56796](source_parts/nswc_part_06.f90#L3967) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [101641](source_parts/nswc_part_10.f90#L6329) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [101819](source_parts/nswc_part_10.f90#L6507) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [34098](source_parts/nswc_part_04.f90#L2323) | [Documented](docs/07-vectors.md#topic-132-01) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [34998](source_parts/nswc_part_04.f90#L3223) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [57782](source_parts/nswc_part_06.f90#L4953) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [101415](source_parts/nswc_part_10.f90#L6103) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [101598](source_parts/nswc_part_10.f90#L6286) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [46526](source_parts/nswc_part_05.f90#L4241) | [Documented](docs/08-matrices.md#topic-183-01) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [33977](source_parts/nswc_part_04.f90#L2202) | [Documented](docs/07-vectors.md#topic-131-01) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [36381](source_parts/nswc_part_04.f90#L4606) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36117](source_parts/nswc_part_04.f90#L4342) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58291](source_parts/nswc_part_06.f90#L5462) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58320](source_parts/nswc_part_06.f90#L5491) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [36570](source_parts/nswc_part_04.f90#L4795) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [61908](source_parts/nswc_part_06.f90#L9079) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [62013](source_parts/nswc_part_06.f90#L9184) | Not indexed |
| `CUBRUL` | `SUBROUTINE` | `F, VEC, P, IDATA, RDATA` | [114973](source_parts/nswc_part_11.f90#L9031) | Not indexed |
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [114755](source_parts/nswc_part_11.f90#L8813) | [Documented](docs/22-numerical-integration.md#topic-408-01) |
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [96893](source_parts/nswc_part_10.f90#L1581) | [Documented](docs/18-curve-fitting.md#topic-357-01) |
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [97071](source_parts/nswc_part_10.f90#L1759) | [Documented](docs/18-curve-fitting.md#topic-359-01) |
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [97174](source_parts/nswc_part_10.f90#L1862) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [97270](source_parts/nswc_part_10.f90#L1958) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [51487](source_parts/nswc_part_05.f90#L9202) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [51268](source_parts/nswc_part_05.f90#L8983) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [51049](source_parts/nswc_part_05.f90#L8764) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [51561](source_parts/nswc_part_05.f90#L9276) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [51635](source_parts/nswc_part_05.f90#L9350) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [56616](source_parts/nswc_part_06.f90#L3787) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [51342](source_parts/nswc_part_05.f90#L9057) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [51416](source_parts/nswc_part_05.f90#L9131) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [56581](source_parts/nswc_part_06.f90#L3752) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58241](source_parts/nswc_part_06.f90#L5412) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58266](source_parts/nswc_part_06.f90#L5437) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [51123](source_parts/nswc_part_05.f90#L8838) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [51197](source_parts/nswc_part_05.f90#L8912) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [56546](source_parts/nswc_part_06.f90#L3717) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [56712](source_parts/nswc_part_06.f90#L3883) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [56682](source_parts/nswc_part_06.f90#L3853) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [56652](source_parts/nswc_part_06.f90#L3823) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CXP` | `COMPLEX FUNCTION` | `N, NU` | [22008](source_parts/nswc_part_03.f90#L881) | Not indexed |
| `CYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [37108](source_parts/nswc_part_04.f90#L5333) | Not indexed |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [47964](source_parts/nswc_part_05.f90#L5679) | [Documented](docs/08-matrices.md#topic-186-01) |
| `DABSV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [48049](source_parts/nswc_part_05.f90#L5764) | Not indexed |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [8139](source_parts/nswc_part_01.f90#L8139) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `DAORD` | `SUBROUTINE` | `A, N` | [2035](source_parts/nswc_part_01.f90#L2035) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [2986](source_parts/nswc_part_01.f90#L2986) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [35215](source_parts/nswc_part_04.f90#L3440) | [Documented](docs/07-vectors.md#topic-139-01) |
| `DAW` | `REAL FUNCTION` | `X` | [8453](source_parts/nswc_part_01.f90#L8453) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [35079](source_parts/nswc_part_04.f90#L3304) | [Documented](docs/07-vectors.md#topic-138-01) |
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [55930](source_parts/nswc_part_06.f90#L3101) | [Documented](docs/10-banded-matrices.md#topic-221-01) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [54603](source_parts/nswc_part_06.f90#L1774) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `DBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [65065](source_parts/nswc_part_07.f90#L1645) | Not indexed |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [52674](source_parts/nswc_part_05.f90#L10389) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `DBAL` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [64436](source_parts/nswc_part_07.f90#L1016) | Not indexed |
| `DBALNV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [64629](source_parts/nswc_part_07.f90#L1209) | Not indexed |
| `DBCORR` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [13646](source_parts/nswc_part_02.f90#L3061) | Not indexed |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [13497](source_parts/nswc_part_02.f90#L2912) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `DBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [55447](source_parts/nswc_part_06.f90#L2618) | Not indexed |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [54581](source_parts/nswc_part_06.f90#L1752) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [52402](source_parts/nswc_part_05.f90#L10117) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [53609](source_parts/nswc_part_06.f90#L780) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `DBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [55654](source_parts/nswc_part_06.f90#L2825) | Not indexed |
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [55239](source_parts/nswc_part_06.f90#L2410) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [55343](source_parts/nswc_part_06.f90#L2514) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [53142](source_parts/nswc_part_06.f90#L313) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54306](source_parts/nswc_part_06.f90#L1477) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54358](source_parts/nswc_part_06.f90#L1529) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54016](source_parts/nswc_part_06.f90#L1187) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [54069](source_parts/nswc_part_06.f90#L1240) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DCBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [69699](source_parts/nswc_part_07.f90#L6279) | Not indexed |
| `DCBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [69100](source_parts/nswc_part_07.f90#L5680) | Not indexed |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [30837](source_parts/nswc_part_03.f90#L9710) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [2935](source_parts/nswc_part_01.f90#L2935) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [68965](source_parts/nswc_part_07.f90#L5545) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-276-01) |
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [69019](source_parts/nswc_part_07.f90#L5599) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-277-01) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [6628](source_parts/nswc_part_01.f90#L6628) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [6940](source_parts/nswc_part_01.f90#L6940) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCFACT` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, IERR` | [45095](source_parts/nswc_part_05.f90#L2810) | Not indexed |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [11487](source_parts/nswc_part_02.f90#L902) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DCMINV` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, TEMP` | [45317](source_parts/nswc_part_05.f90#L3032) | Not indexed |
| `DCMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [69785](source_parts/nswc_part_07.f90#L6365) | Not indexed |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [45058](source_parts/nswc_part_05.f90#L2773) | [Documented](docs/08-matrices.md#topic-178-01) |
| `DCOMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [69448](source_parts/nswc_part_07.f90#L6028) | Not indexed |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [33680](source_parts/nswc_part_04.f90#L1905) | [Documented](docs/07-vectors.md#topic-130-01) |
| `DCORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [69304](source_parts/nswc_part_07.f90#L5884) | Not indexed |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [3812](source_parts/nswc_part_01.f90#L3812) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [3033](source_parts/nswc_part_01.f90#L3033) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `DCPLY1` | `SUBROUTINE` | `OPR, OPI, IDEG, IDP1, ZEROR, ZEROI, PR, PI, QPR, QPI, HR, HI, QHR, QHI, SHR, SHI, NUM` | [32464](source_parts/nswc_part_04.f90#L689) | Not indexed |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [32398](source_parts/nswc_part_04.f90#L623) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [93658](source_parts/nswc_part_09.f90#L8921) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [12500](source_parts/nswc_part_02.f90#L1915) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [3072](source_parts/nswc_part_01.f90#L3072) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [29202](source_parts/nswc_part_03.f90#L8075) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `DCSOL` | `SUBROUTINE` | `N, M, AR, AI, KA, BR, BI, KB, IPVT` | [45214](source_parts/nswc_part_05.f90#L2929) | Not indexed |
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [3160](source_parts/nswc_part_01.f90#L3160) | [Documented](docs/02-elementary-operations.md#topic-026-03) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [34746](source_parts/nswc_part_04.f90#L2971) | [Documented](docs/07-vectors.md#topic-136-01) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [1930](source_parts/nswc_part_01.f90#L1930) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DE1` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YY, WT, P, YP, YPOUT, PHI, ALPHA, BETA, SIG, V, W, G, PHASE1, PSI, X, H, HOLD, START, TOLD, DELSGN, NS, NORND, K, KOLD, ISNOLD` | [116456](source_parts/nswc_part_12.f90#L1) | Not indexed |
| `DE1E` | `DOUBLE PRECISION FUNCTION` | `X` | [9794](source_parts/nswc_part_01.f90#L9794) | Not indexed |
| `DEC` | `SUBROUTINE` | `N, NDIM, A, IP, IER` | [37937](source_parts/nswc_part_04.f90#L6162) | Not indexed |
| `DECBT` | `SUBROUTINE` | `M, N, A, B, C, IP, IER` | [40954](source_parts/nswc_part_04.f90#L9179) | Not indexed |
| `DECOM2` | `SUBROUTINE` | `M, N, M1, ETA, TOL, QR, D, N1, IPIVOT, SING, MMPNN` | [78331](source_parts/nswc_part_08.f90#L4371) | Not indexed |
| `DEFER` | `SUBROUTINE` | `COFX, COFY, USOL, IDMN, GRHS, MN` | [123954](source_parts/nswc_part_12.f90#L7499) | Not indexed |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [9757](source_parts/nswc_part_01.f90#L9757) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEI0` | `DOUBLE PRECISION FUNCTION` | `X, EPS` | [10081](source_parts/nswc_part_01.f90#L10081) | Not indexed |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [9775](source_parts/nswc_part_01.f90#L9775) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [64294](source_parts/nswc_part_07.f90#L874) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-266-01) |
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [64343](source_parts/nswc_part_07.f90#L923) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-267-01) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [25332](source_parts/nswc_part_03.f90#L4205) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [25569](source_parts/nswc_part_03.f90#L4442) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [1394](source_parts/nswc_part_01.f90#L1394) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [7380](source_parts/nswc_part_01.f90#L7380) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [7432](source_parts/nswc_part_01.f90#L7432) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC0` | `DOUBLE PRECISION FUNCTION` | `X` | [7575](source_parts/nswc_part_01.f90#L7575) | Not indexed |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [7495](source_parts/nswc_part_01.f90#L7495) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [7840](source_parts/nswc_part_01.f90#L7840) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `DESUM` | `DOUBLE PRECISION FUNCTION` | `MU, X` | [4038](source_parts/nswc_part_01.f90#L4038) | Not indexed |
| `DET` | `FUNCTION` | `A, KA, N, X` | [47118](source_parts/nswc_part_05.f90#L4833) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [128150](source_parts/nswc_part_13.f90#L1085) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `DGAM1` | `DOUBLE PRECISION FUNCTION` | `X` | [11928](source_parts/nswc_part_02.f90#L1343) | Not indexed |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [12094](source_parts/nswc_part_02.f90#L1509) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [11761](source_parts/nswc_part_02.f90#L1176) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [39258](source_parts/nswc_part_04.f90#L7483) | Not indexed |
| `DGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [39764](source_parts/nswc_part_04.f90#L7989) | Not indexed |
| `DGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [39494](source_parts/nswc_part_04.f90#L7719) | Not indexed |
| `DGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [39625](source_parts/nswc_part_04.f90#L7850) | Not indexed |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [15339](source_parts/nswc_part_02.f90#L4754) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `DGMLN1` | `DOUBLE PRECISION FUNCTION` | `X` | [12149](source_parts/nswc_part_02.f90#L1564) | Not indexed |
| `DGNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [107686](source_parts/nswc_part_11.f90#L1744) | Not indexed |
| `DGR17` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [15233](source_parts/nswc_part_02.f90#L4648) | Not indexed |
| `DGR29` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [15028](source_parts/nswc_part_02.f90#L4443) | Not indexed |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [14715](source_parts/nswc_part_02.f90#L4130) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DGSMLN` | `DOUBLE PRECISION FUNCTION` | `A, B` | [13615](source_parts/nswc_part_02.f90#L3030) | Not indexed |
| `DH12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [75225](source_parts/nswc_part_08.f90#L1265) | Not indexed |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [74638](source_parts/nswc_part_08.f90#L678) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [74917](source_parts/nswc_part_08.f90#L957) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [64823](source_parts/nswc_part_07.f90#L1403) | Not indexed |
| `DHQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [65332](source_parts/nswc_part_07.f90#L1912) | Not indexed |
| `DINCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [107775](source_parts/nswc_part_11.f90#L1833) | Not indexed |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [1875](source_parts/nswc_part_01.f90#L1875) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [37241](source_parts/nswc_part_04.f90#L5466) | [Documented](docs/08-matrices.md#topic-160-01) |
| `DLGDIV` | `DOUBLE PRECISION FUNCTION` | `A, B` | [13711](source_parts/nswc_part_02.f90#L3126) | Not indexed |
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [71122](source_parts/nswc_part_07.f90#L7702) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [4277](source_parts/nswc_part_01.f90#L4277) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DLOC` | `LOGICAL FUNCTION` | `X, Y` | [36969](source_parts/nswc_part_04.f90#L5194) | Not indexed |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [72603](source_parts/nswc_part_07.f90#L9183) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [36623](source_parts/nswc_part_04.f90#L4848) | [Documented](docs/08-matrices.md#topic-151-01) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36047](source_parts/nswc_part_04.f90#L4272) | [Documented](docs/08-matrices.md#topic-146-01) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [51772](source_parts/nswc_part_05.f90#L9487) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [35874](source_parts/nswc_part_04.f90#L4099) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [51972](source_parts/nswc_part_05.f90#L9687) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [35920](source_parts/nswc_part_04.f90#L4145) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [108058](source_parts/nswc_part_11.f90#L2116) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMEVL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [108239](source_parts/nswc_part_11.f90#L2297) | Not indexed |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [50338](source_parts/nswc_part_05.f90#L8053) | [Documented](docs/08-matrices.md#topic-191-01) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [107510](source_parts/nswc_part_11.f90#L1568) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [36905](source_parts/nswc_part_04.f90#L5130) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [39173](source_parts/nswc_part_04.f90#L7398) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [39217](source_parts/nswc_part_04.f90#L7442) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [36686](source_parts/nswc_part_04.f90#L4911) | [Documented](docs/08-matrices.md#topic-153-01) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [36754](source_parts/nswc_part_04.f90#L4979) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [35431](source_parts/nswc_part_04.f90#L3656) | [Documented](docs/07-vectors.md#topic-140-01) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [126871](source_parts/nswc_part_12.f90#L10416) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [127184](source_parts/nswc_part_13.f90#L119) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [127338](source_parts/nswc_part_13.f90#L273) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [59984](source_parts/nswc_part_06.f90#L7155) | Not indexed |
| `DOGLEG` | `SUBROUTINE` | `N, R, LR, DIAG, QTB, DELTA, X, WA1, WA2` | [82239](source_parts/nswc_part_08.f90#L8279) | Not indexed |
| `DONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [61147](source_parts/nswc_part_06.f90#L8318) | Not indexed |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [2840](source_parts/nswc_part_01.f90#L2840) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [71290](source_parts/nswc_part_07.f90#L7870) | Not indexed |
| `DORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [64709](source_parts/nswc_part_07.f90#L1289) | Not indexed |
| `DORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [71177](source_parts/nswc_part_07.f90#L7757) | Not indexed |
| `DORTRN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [65143](source_parts/nswc_part_07.f90#L1723) | Not indexed |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [28612](source_parts/nswc_part_03.f90#L7485) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [43692](source_parts/nswc_part_05.f90#L1407) | [Documented](docs/08-matrices.md#topic-176-01) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [28562](source_parts/nswc_part_03.f90#L7435) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [8584](source_parts/nswc_part_01.f90#L8584) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DPDAW0` | `DOUBLE PRECISION FUNCTION` | `X` | [8664](source_parts/nswc_part_01.f90#L8664) | Not indexed |
| `DPDEL` | `DOUBLE PRECISION FUNCTION` | `X` | [11893](source_parts/nswc_part_02.f90#L1308) | Not indexed |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [47194](source_parts/nswc_part_05.f90#L4909) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [28823](source_parts/nswc_part_03.f90#L7696) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [29054](source_parts/nswc_part_03.f90#L7927) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [50682](source_parts/nswc_part_05.f90#L8397) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [28937](source_parts/nswc_part_03.f90#L7810) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [1299](source_parts/nswc_part_01.f90#L1299) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [28723](source_parts/nswc_part_03.f90#L7596) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [8385](source_parts/nswc_part_01.f90#L8385) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [57180](source_parts/nswc_part_06.f90#L4351) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [57244](source_parts/nswc_part_06.f90#L4415) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [43910](source_parts/nswc_part_05.f90#L1625) | Not indexed |
| `DPPFA` | `SUBROUTINE` | `AP, N, INFO` | [43721](source_parts/nswc_part_05.f90#L1436) | Not indexed |
| `DPPSL` | `SUBROUTINE` | `AP, N, B` | [43822](source_parts/nswc_part_05.f90#L1537) | Not indexed |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [12675](source_parts/nswc_part_02.f90#L2090) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DPSI0` | `DOUBLE PRECISION FUNCTION` | `X` | [12859](source_parts/nswc_part_02.f90#L2274) | Not indexed |
| `DPSLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [38217](source_parts/nswc_part_04.f90#L6442) | Not indexed |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [28658](source_parts/nswc_part_03.f90#L7531) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [112537](source_parts/nswc_part_11.f90#L6595) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `DQAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [112729](source_parts/nswc_part_11.f90#L6787) | Not indexed |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [111703](source_parts/nswc_part_11.f90#L5761) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [111887](source_parts/nswc_part_11.f90#L5945) | Not indexed |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [30552](source_parts/nswc_part_03.f90#L9425) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [113536](source_parts/nswc_part_11.f90#L7594) | Not indexed |
| `DQK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [113215](source_parts/nswc_part_11.f90#L7273) | Not indexed |
| `DQK21` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [112360](source_parts/nswc_part_11.f90#L6418) | Not indexed |
| `DQPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [113398](source_parts/nswc_part_11.f90#L7456) | Not indexed |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [31238](source_parts/nswc_part_03.f90#L10111) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQXCPY` | `SUBROUTINE` | `A, B, L` | [114341](source_parts/nswc_part_11.f90#L8399) | Not indexed |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [113720](source_parts/nswc_part_11.f90#L7778) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [113899](source_parts/nswc_part_11.f90#L7957) | Not indexed |
| `DQXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [114357](source_parts/nswc_part_11.f90#L8415) | Not indexed |
| `DQXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [114656](source_parts/nswc_part_11.f90#L8714) | Not indexed |
| `DQXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [114477](source_parts/nswc_part_11.f90#L8535) | Not indexed |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [127914](source_parts/nswc_part_13.f90#L849) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [126593](source_parts/nswc_part_12.f90#L10138) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `DRCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [126620](source_parts/nswc_part_12.f90#L10165) | Not indexed |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [14288](source_parts/nswc_part_02.f90#L3703) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DRCVL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [26576](source_parts/nswc_part_03.f90#L5449) | Not indexed |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [26025](source_parts/nswc_part_03.f90#L4898) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [4094](source_parts/nswc_part_01.f90#L4094) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `DREXP1` | `SUBROUTINE` | `X, E, W` | [4185](source_parts/nswc_part_01.f90#L4185) | Not indexed |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [25774](source_parts/nswc_part_03.f90#L4647) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [127725](source_parts/nswc_part_13.f90#L660) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [26311](source_parts/nswc_part_03.f90#L5184) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [4433](source_parts/nswc_part_01.f90#L4433) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [4510](source_parts/nswc_part_01.f90#L4510) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [128642](source_parts/nswc_part_13.f90#L1577) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [127551](source_parts/nswc_part_13.f90#L486) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [37396](source_parts/nswc_part_04.f90#L5621) | [Documented](docs/08-matrices.md#topic-161-01) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [126770](source_parts/nswc_part_12.f90#L10315) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [34057](source_parts/nswc_part_04.f90#L2282) | [Documented](docs/07-vectors.md#topic-132-01) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [3333](source_parts/nswc_part_01.f90#L3333) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [34574](source_parts/nswc_part_04.f90#L2799) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [34415](source_parts/nswc_part_04.f90#L2640) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DRPLY1` | `SUBROUTINE` | `OP, IDEG, IDP1, ZEROR, ZEROI, P, QP, K, QK, SVK, TEMP, PT, NUM` | [31483](source_parts/nswc_part_03.f90#L10356) | Not indexed |
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [31419](source_parts/nswc_part_03.f90#L10292) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DRTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [65235](source_parts/nswc_part_07.f90#L1815) | Not indexed |
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [60882](source_parts/nswc_part_06.f90#L8053) | [Documented](docs/11-sparse-matrices.md#topic-256-01) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [58430](source_parts/nswc_part_06.f90#L5601) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [57510](source_parts/nswc_part_06.f90#L4681) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [34924](source_parts/nswc_part_04.f90#L3149) | [Documented](docs/07-vectors.md#topic-137-01) |
| `DSCALD` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [108029](source_parts/nswc_part_11.f90#L2087) | Not indexed |
| `DSCALP` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [107990](source_parts/nswc_part_11.f90#L2048) | Not indexed |
| `DSCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [48169](source_parts/nswc_part_05.f90#L5884) | Not indexed |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56959](source_parts/nswc_part_06.f90#L4130) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [66954](source_parts/nswc_part_07.f90#L3534) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-271-01) |
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [66976](source_parts/nswc_part_07.f90#L3556) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-272-01) |
| `DSHSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [48451](source_parts/nswc_part_05.f90#L6166) | Not indexed |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [3714](source_parts/nswc_part_01.f90#L3714) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [60271](source_parts/nswc_part_06.f90#L7442) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [60376](source_parts/nswc_part_06.f90#L7547) | Not indexed |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [42245](source_parts/nswc_part_04.f90#L10470) | [Documented](docs/08-matrices.md#topic-173-01) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [58404](source_parts/nswc_part_06.f90#L5575) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `DSORT` | `SUBROUTINE` | `A, N` | [1825](source_parts/nswc_part_01.f90#L1825) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [42286](source_parts/nswc_part_05.f90#L1) | Not indexed |
| `DSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [43105](source_parts/nswc_part_05.f90#L820) | Not indexed |
| `DSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [42612](source_parts/nswc_part_05.f90#L327) | Not indexed |
| `DSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [60583](source_parts/nswc_part_06.f90#L7754) | Not indexed |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [57911](source_parts/nswc_part_06.f90#L5082) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `DSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [42903](source_parts/nswc_part_05.f90#L618) | Not indexed |
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [59862](source_parts/nswc_part_06.f90#L7033) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [57714](source_parts/nswc_part_06.f90#L4885) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `DSTOR2` | `SUBROUTINE` | `A, B` | [1225](source_parts/nswc_part_01.f90#L1225) | Not indexed |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [45974](source_parts/nswc_part_05.f90#L3689) | [Documented](docs/08-matrices.md#topic-183-01) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [37147](source_parts/nswc_part_04.f90#L5372) | [Documented](docs/08-matrices.md#topic-157-01) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [33918](source_parts/nswc_part_04.f90#L2143) | [Documented](docs/07-vectors.md#topic-131-01) |
| `DSYMSV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [49082](source_parts/nswc_part_05.f90#L6797) | Not indexed |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [48909](source_parts/nswc_part_05.f90#L6624) | [Documented](docs/08-matrices.md#topic-188-01) |
| `DTASV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [48972](source_parts/nswc_part_05.f90#L6687) | Not indexed |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [36256](source_parts/nswc_part_04.f90#L4481) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [44131](source_parts/nswc_part_05.f90#L1846) | [Documented](docs/08-matrices.md#topic-177-01) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36103](source_parts/nswc_part_04.f90#L4328) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58187](source_parts/nswc_part_06.f90#L5358) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58216](source_parts/nswc_part_06.f90#L5387) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTQL` | `SUBROUTINE` | `N, D, E2, IERR` | [67253](source_parts/nswc_part_07.f90#L3833) | Not indexed |
| `DTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [67552](source_parts/nswc_part_07.f90#L4132) | Not indexed |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [128395](source_parts/nswc_part_13.f90#L1330) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `DTRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [67012](source_parts/nswc_part_07.f90#L3592) | Not indexed |
| `DTRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [67399](source_parts/nswc_part_07.f90#L3979) | Not indexed |
| `DTRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [67136](source_parts/nswc_part_07.f90#L3716) | Not indexed |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [60423](source_parts/nswc_part_06.f90#L7594) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [60528](source_parts/nswc_part_06.f90#L7699) | Not indexed |
| `DU11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [72944](source_parts/nswc_part_07.f90#L9524) | Not indexed |
| `DU11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [73453](source_parts/nswc_part_07.f90#L10033) | Not indexed |
| `DU12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [73273](source_parts/nswc_part_07.f90#L9853) | Not indexed |
| `DU12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [73782](source_parts/nswc_part_07.f90#L10362) | Not indexed |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [125964](source_parts/nswc_part_12.f90#L9509) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `DURNG0` | `SUBROUTINE` | `IX, U, V` | [126117](source_parts/nswc_part_12.f90#L9662) | Not indexed |
| `DURNG1` | `SUBROUTINE` | `IX, U, V, D` | [126265](source_parts/nswc_part_12.f90#L9810) | Not indexed |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [126409](source_parts/nswc_part_12.f90#L9954) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58137](source_parts/nswc_part_06.f90#L5308) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58162](source_parts/nswc_part_06.f90#L5333) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DXFN` | `SUBROUTINE` | `U, IDMN, I, J, UXXX, UXXXX` | [124021](source_parts/nswc_part_12.f90#L7566) | Not indexed |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [1470](source_parts/nswc_part_01.f90#L1470) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [37002](source_parts/nswc_part_04.f90#L5227) | Not indexed |
| `DYFN` | `SUBROUTINE` | `U, IDMN, I, J, UYYY, UYYYY` | [124106](source_parts/nswc_part_12.f90#L7651) | Not indexed |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [29747](source_parts/nswc_part_03.f90#L8620) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [62301](source_parts/nswc_part_06.f90#L9472) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [62350](source_parts/nswc_part_06.f90#L9521) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [62399](source_parts/nswc_part_06.f90#L9570) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [62491](source_parts/nswc_part_06.f90#L9662) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EKL` | `SUBROUTINE` | `L, FK, FL, EK, EL, GK, GL` | [25074](source_parts/nswc_part_03.f90#L3947) | Not indexed |
| `EKM` | `SUBROUTINE` | `K2, FK, EK` | [25028](source_parts/nswc_part_03.f90#L3901) | Not indexed |
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [26678](source_parts/nswc_part_03.f90#L5551) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [25179](source_parts/nswc_part_03.f90#L4052) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `ELMHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [62856](source_parts/nswc_part_06.f90#L10027) | Not indexed |
| `ELMHS0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [62961](source_parts/nswc_part_06.f90#L10132) | Not indexed |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [27084](source_parts/nswc_part_03.f90#L5957) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [63499](source_parts/nswc_part_07.f90#L79) | Not indexed |
| `ELTRN0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [63581](source_parts/nswc_part_07.f90#L161) | Not indexed |
| `ENORM` | `REAL FUNCTION` | `N, X` | [82131](source_parts/nswc_part_08.f90#L8171) | Not indexed |
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [25484](source_parts/nswc_part_03.f90#L4357) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `EPSLN` | `REAL FUNCTION` | `L` | [1361](source_parts/nswc_part_01.f90#L1361) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `ERF` | `REAL FUNCTION` | `X` | [6399](source_parts/nswc_part_01.f90#L6399) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC` | `REAL FUNCTION` | `X` | [6452](source_parts/nswc_part_01.f90#L6452) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC0` | `SUBROUTINE` | `IND, X, E, Y` | [27950](source_parts/nswc_part_03.f90#L6823) | Not indexed |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [6535](source_parts/nswc_part_01.f90#L6535) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFCM2` | `SUBROUTINE` | `MO, Z, W` | [7262](source_parts/nswc_part_01.f90#L7262) | Not indexed |
| `ERFCR` | `REAL FUNCTION` | `X` | [28044](source_parts/nswc_part_03.f90#L6917) | Not indexed |
| `ERFI` | `REAL FUNCTION` | `P, Q` | [7728](source_parts/nswc_part_01.f90#L7728) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `ERREV` | `DOUBLE PRECISION FUNCTION` | `NN, QR, QI, MS, MP, ARE, MRE` | [33255](source_parts/nswc_part_04.f90#L1480) | Not indexed |
| `ERRINT` | `DOUBLE PRECISION FUNCTION` | `F, FIT, AAA, BBB, POINTS, WEIGHT` | [92834](source_parts/nswc_part_09.f90#L8097) | Not indexed |
| `ESUM` | `REAL FUNCTION` | `MU, X` | [4012](source_parts/nswc_part_01.f90#L4012) | Not indexed |
| `EXPARG` | `REAL FUNCTION` | `L` | [1428](source_parts/nswc_part_01.f90#L1428) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [9426](source_parts/nswc_part_01.f90#L9426) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `EXTRA` | `SUBROUTINE` | `NEQN, YINC2, F2, T, H, YINC1, Y, F1, F, TEX, YEX, YPEX` | [118191](source_parts/nswc_part_12.f90#L1736) | Not indexed |
| `FDJAC1` | `SUBROUTINE` | `FCN, N, X, FVEC, FJAC, LDFJAC, IFLAG, ML, MU, EPSFCN, WA1, WA2` | [82425](source_parts/nswc_part_08.f90#L8465) | Not indexed |
| `FDJAC2` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FJAC, LDFJAC, IFLAG, EPSFCN, WA` | [82590](source_parts/nswc_part_08.f90#L8630) | Not indexed |
| `FEHL` | `SUBROUTINE` | `F, NEQN, Y, T, H, YP, F1, F2, F3, F4, F5, S` | [118796](source_parts/nswc_part_12.f90#L2341) | Not indexed |
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [89367](source_parts/nswc_part_09.f90#L4630) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [89384](source_parts/nswc_part_09.f90#L4647) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [80148](source_parts/nswc_part_08.f90#L6188) | [Documented](docs/15-optimization.md#topic-306-01) |
| `FPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [16001](source_parts/nswc_part_02.f90#L5416) | Not indexed |
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [128025](source_parts/nswc_part_13.f90#L960) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `FRNL` | `SUBROUTINE` | `T, C, S` | [9030](source_parts/nswc_part_01.f90#L9030) | [Documented](docs/04-special-functions.md#topic-057-01) |
| `FSTOCD` | `SUBROUTINE` | `N, X, FCN, TYPSIZ, R, G` | [81036](source_parts/nswc_part_08.f90#L7076) | Not indexed |
| `FSTOFD` | `SUBROUTINE` | `N, X, FCN, FX, G, TYPSIZ, R` | [80995](source_parts/nswc_part_08.f90#L7035) | Not indexed |
| `FUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, I1, K1, N, M, NP1` | [5926](source_parts/nswc_part_01.f90#L5926) | Not indexed |
| `FXDEC` | `SUBROUTINE` | `FCN, N, X, FX, R` | [80861](source_parts/nswc_part_08.f90#L6901) | Not indexed |
| `FXSHFR` | `SUBROUTINE` | `L2, NZ, NN, P, QP, K, QK, SVK` | [31776](source_parts/nswc_part_04.f90#L1) | Not indexed |
| `FXSHFT` | `SUBROUTINE` | `L2, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SHR, SHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [32804](source_parts/nswc_part_04.f90#L1029) | Not indexed |
| `GAM1` | `REAL FUNCTION` | `A` | [11337](source_parts/nswc_part_02.f90#L752) | Not indexed |
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [14341](source_parts/nswc_part_02.f90#L3756) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `GAMLN` | `REAL FUNCTION` | `A` | [11388](source_parts/nswc_part_02.f90#L803) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GAMLN1` | `REAL FUNCTION` | `A` | [11442](source_parts/nswc_part_02.f90#L857) | Not indexed |
| `GAMMA` | `REAL FUNCTION` | `A` | [11124](source_parts/nswc_part_02.f90#L539) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [118872](source_parts/nswc_part_12.f90#L2417) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-424-01) |
| `GERKS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, YP, H, F1, F2, F3, F4, F5, YG, YGP, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [119092](source_parts/nswc_part_12.f90#L2637) | Not indexed |
| `GETNP` | `SUBROUTINE` | `X, Y, IADJ, IEND, L, NPTS, DS, IER` | [105411](source_parts/nswc_part_10.f90#L10099) | Not indexed |
| `GLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [11275](source_parts/nswc_part_02.f90#L690) | Not indexed |
| `GNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [106871](source_parts/nswc_part_11.f90#L929) | Not indexed |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [104664](source_parts/nswc_part_10.f90#L9352) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADG1` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, EPS, NIT, ZXZY, IER` | [104709](source_parts/nswc_part_10.f90#L9397) | Not indexed |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [104931](source_parts/nswc_part_10.f90#L9619) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADL1` | `SUBROUTINE` | `N, K, X, Y, Z, IADJ, IEND, DX, DY, IER` | [104977](source_parts/nswc_part_10.f90#L9665) | Not indexed |
| `GRAT1` | `SUBROUTINE` | `A, X, R, P, Q, EPS` | [16768](source_parts/nswc_part_02.f90#L6183) | Not indexed |
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [13785](source_parts/nswc_part_02.f90#L3200) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `GSUMLN` | `REAL FUNCTION` | `A, B` | [13357](source_parts/nswc_part_02.f90#L2772) | Not indexed |
| `H12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [74544](source_parts/nswc_part_08.f90#L584) | Not indexed |
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [29878](source_parts/nswc_part_03.f90#L8751) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-124-01) |
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [5291](source_parts/nswc_part_01.f90#L5291) | [Documented](docs/03-geometry.md#topic-043-01) |
| `HC1` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, NP1, PC, AC, VR, VC, P, SUBR, RBUS, TOR, JR, K, IND0` | [5424](source_parts/nswc_part_01.f90#L5424) | Not indexed |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [73961](source_parts/nswc_part_08.f90#L1) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [74237](source_parts/nswc_part_08.f90#L277) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [63180](source_parts/nswc_part_06.f90#L10351) | Not indexed |
| `HQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [63852](source_parts/nswc_part_07.f90#L432) | Not indexed |
| `HSTART` | `SUBROUTINE` | `F, NEQ, A, B, Y, YPRIME, ETOL, MORDER, SMALL, BIG, SPY, PV, YP, SF, RPAR, IPAR, H` | [120750](source_parts/nswc_part_12.f90#L4295) | Not indexed |
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [94180](source_parts/nswc_part_09.f90#L9443) | [Documented](docs/18-curve-fitting.md#topic-338-01) |
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [4848](source_parts/nswc_part_01.f90#L4848) | [Documented](docs/03-geometry.md#topic-041-01) |
| `HYBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, XTOL, MAXFEV, ML, MU, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, R, LR, QTF, WA1, WA2, WA3, WA4` | [30013](source_parts/nswc_part_03.f90#L8886) | Not indexed |
| `IA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [23078](source_parts/nswc_part_03.f90#L1951) | Not indexed |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [35808](source_parts/nswc_part_04.f90#L4033) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [35766](source_parts/nswc_part_04.f90#L3991) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IEGS` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, X, T, NT, NUP, MUP, IER, CUTOFF, ROOTRT, UNITRD, NHALF, LUFACT, KMM, KMN, KNM, RHS, R, RH, DELN, TM, TN, XM, XMZ, WM, WN, OLDX, SAVE, XN, SAVE2, ASIDE, ASIDE3, IMKNN` | [115284](source_parts/nswc_part_11.f90#L9342) | Not indexed |
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [115106](source_parts/nswc_part_11.f90#L9164) | [Documented](docs/23-integral-equations.md#topic-410-01) |
| `IMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [23124](source_parts/nswc_part_03.f90#L1997) | Not indexed |
| `IMTQL1` | `SUBROUTINE` | `N, D, E, IERR` | [66297](source_parts/nswc_part_07.f90#L2877) | Not indexed |
| `IMTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [66776](source_parts/nswc_part_07.f90#L3356) | Not indexed |
| `INCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [106957](source_parts/nswc_part_11.f90#L1015) | Not indexed |
| `INDXA` | `SUBROUTINE` | `I, IR, IDXA, NA` | [124672](source_parts/nswc_part_12.f90#L8217) | Not indexed |
| `INDXB` | `SUBROUTINE` | `I, IR, IDX, IDP` | [124704](source_parts/nswc_part_12.f90#L8249) | Not indexed |
| `INDXC` | `SUBROUTINE` | `I, IR, IDXC, NC` | [124688](source_parts/nswc_part_12.f90#L8233) | Not indexed |
| `INFCTR` | `SUBROUTINE` | `N, IFACT, IPOWER, NEXP, NPOWER` | [36506](source_parts/nswc_part_04.f90#L4731) | Not indexed |
| `INTADD` | `SUBROUTINE` | `KK, I1, I2, I3, IADJ, IEND` | [103710](source_parts/nswc_part_10.f90#L8398) | Not indexed |
| `INTRC1` | `SUBROUTINE` | `N, PX, PY, X, Y, Z, IADJ, IEND, IFLAG, ZXZY, IST, PZ, IER` | [105633](source_parts/nswc_part_10.f90#L10321) | Not indexed |
| `INTRP` | `SUBROUTINE` | `X, Y, XOUT, YOUT, YPOUT, NEQN, KOLD, PHI, PSI` | [117176](source_parts/nswc_part_12.f90#L721) | Not indexed |
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [98636](source_parts/nswc_part_10.f90#L3324) | [Documented](docs/18-curve-fitting.md#topic-368-01) |
| `INTYD` | `SUBROUTINE` | `T, K, YH, NYH, DKY, IFLAG` | [121067](source_parts/nswc_part_12.f90#L4612) | Not indexed |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [2692](source_parts/nswc_part_01.f90#L2692) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `IPATH` | `SUBROUTINE` | `I, J, SUBR, RBUS, AR, PR, S, N, NP, I1, I2, K, JR, M, NP1` | [5854](source_parts/nswc_part_01.f90#L5854) | Not indexed |
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [1](source_parts/nswc_part_01.f90#L1) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [35724](source_parts/nswc_part_04.f90#L3949) | [Documented](docs/07-vectors.md#topic-141-01) |
| `ISHELL` | `SUBROUTINE` | `A, N` | [1513](source_parts/nswc_part_01.f90#L1513) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [17001](source_parts/nswc_part_02.f90#L6416) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `ISWAP` | `SUBROUTINE` | `N, IX, INCX, IY, INCY` | [33769](source_parts/nswc_part_04.f90#L1994) | Not indexed |
| `ITERT` | `SUBROUTINE` | `KERNEL, RHFCN, N, TN, WN, M, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, IFLG` | [115973](source_parts/nswc_part_11.f90#L10031) | Not indexed |
| `IUPD` | `SUBROUTINE` | `IA, IB, L, A1, A2, P1, P2, V1, V2, K1, N, M, NP1` | [5985](source_parts/nswc_part_01.f90#L5985) | Not indexed |
| `JA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [23246](source_parts/nswc_part_03.f90#L2119) | Not indexed |
| `JAIRY` | `SUBROUTINE` | `X, RX, C, AI, DAI` | [19288](source_parts/nswc_part_02.f90#L8703) | Not indexed |
| `JMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [23292](source_parts/nswc_part_03.f90#L2165) | Not indexed |
| `JROT` | `SUBROUTINE` | `NR, N, H, I, A, B, R` | [81461](source_parts/nswc_part_08.f90#L7501) | Not indexed |
| `KA` | `SUBROUTINE` | `IND, Z, K1, K2` | [23414](source_parts/nswc_part_03.f90#L2287) | Not indexed |
| `KL` | `SUBROUTINE` | `L, FK, FL` | [24627](source_parts/nswc_part_03.f90#L3500) | Not indexed |
| `KM` | `COMPLEX FUNCTION` | `K2` | [24586](source_parts/nswc_part_03.f90#L3459) | Not indexed |
| `KML` | `SUBROUTINE` | `IND, Z, K1, K2` | [23473](source_parts/nswc_part_03.f90#L2346) | Not indexed |
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [37212](source_parts/nswc_part_04.f90#L5437) | [Documented](docs/08-matrices.md#topic-160-01) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [37708](source_parts/nswc_part_04.f90#L5933) | [Documented](docs/08-matrices.md#topic-163-01) |
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [97467](source_parts/nswc_part_10.f90#L2155) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [97682](source_parts/nswc_part_10.f90#L2370) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [97804](source_parts/nswc_part_10.f90#L2492) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [97990](source_parts/nswc_part_10.f90#L2678) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [77851](source_parts/nswc_part_08.f90#L3891) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-299-01) |
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [87293](source_parts/nswc_part_09.f90#L2556) | [Documented](docs/16-transforms.md#topic-317-01) |
| `LAINV1` | `SUBROUTINE` | `FUN, T, C, EPSRE, EPSAB, RESULT, ESTERR, NUM, IER` | [88013](source_parts/nswc_part_09.f90#L3276) | Not indexed |
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [50504](source_parts/nswc_part_05.f90#L8219) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `LEAVE` | `SUBROUTINE` | `IERSET, NF, MF, XV, TV, WV, ERROR, KERNEL, RHFCN, EP, IFLAG, X, T, NT, IER, EPS, ELINSY, TN, WN, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, XNORM` | [115852](source_parts/nswc_part_11.f90#L9910) | Not indexed |
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [29229](source_parts/nswc_part_03.f90#L8102) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [29255](source_parts/nswc_part_03.f90#L8128) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [29374](source_parts/nswc_part_03.f90#L8247) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [70692](source_parts/nswc_part_07.f90#L7272) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [70726](source_parts/nswc_part_07.f90#L7306) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-286-01) |
| `LLTSLV` | `SUBROUTINE` | `NR, N, A, X, B` | [80937](source_parts/nswc_part_08.f90#L6977) | Not indexed |
| `LMDIF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FTOL, XTOL, GTOL, MAXFEV, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, IPVT, QTF, WA1, WA2, WA3, WA4` | [81668](source_parts/nswc_part_08.f90#L7708) | Not indexed |
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [81526](source_parts/nswc_part_08.f90#L7566) | [Documented](docs/15-optimization.md#topic-309-01) |
| `LMPAR` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, DELTA, PAR, X, SDIAG, WA1, WA2` | [82710](source_parts/nswc_part_08.f90#L8750) | Not indexed |
| `LNSRCH` | `SUBROUTINE` | `N, X, F, G, P, XPLS, FPLS, FCN, MXTAKE, IRETCD, STEPMX, STEPTL, TYPSIZ` | [81080](source_parts/nswc_part_08.f90#L7120) | Not indexed |
| `LNSYS` | `SUBROUTINE` | `A, D, M, N, B, X, OPTION, IERR` | [116087](source_parts/nswc_part_11.f90#L10145) | Not indexed |
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [4587](source_parts/nswc_part_01.f90#L4587) | [Documented](docs/03-geometry.md#topic-039-01) |
| `LOGAM` | `REAL FUNCTION` | `X` | [17291](source_parts/nswc_part_02.f90#L6706) | Not indexed |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [96734](source_parts/nswc_part_10.f90#L1422) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [96822](source_parts/nswc_part_10.f90#L1510) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LPDP` | `SUBROUTINE` | `A, MDA, M, N1, N2, PRGOPT, X, WNORM, MODE, WS, IS` | [76298](source_parts/nswc_part_08.f90#L2338) | Not indexed |
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [75317](source_parts/nswc_part_08.f90#L1357) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-292-01) |
| `LSI` | `SUBROUTINE` | `W, MDW, MA, MG, N, PRGOPT, X, RNORM, MODE, WS, IP` | [75922](source_parts/nswc_part_08.f90#L1962) | Not indexed |
| `LSOD1` | `SUBROUTINE` | `F, NEQ, T, Y, TOUT, RTOL, ATOL, IDID, YPOUT, YH, YH1, EWT, SAVF, ACOR, WM, IWM, JAC, INTOUT, TSTOP, TOLFAC, DELSGN, RPAR, IPAR` | [120420](source_parts/nswc_part_12.f90#L3965) | Not indexed |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [71384](source_parts/nswc_part_07.f90#L7964) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [94003](source_parts/nswc_part_09.f90#L9266) | [Documented](docs/18-curve-fitting.md#topic-337-01) |
| `LUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [38435](source_parts/nswc_part_04.f90#L6660) | Not indexed |
| `MACH` | `SUBROUTINE` | `MO, N, IBETA, IMAX, IDMAX, IMACH, RMACH, DMACH` | [426](source_parts/nswc_part_01.f90#L426) | Not indexed |
| `MACH1` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [724](source_parts/nswc_part_01.f90#L724) | Not indexed |
| `MACH2` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [980](source_parts/nswc_part_01.f90#L980) | Not indexed |
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [36606](source_parts/nswc_part_04.f90#L4831) | [Documented](docs/08-matrices.md#topic-151-01) |
| `MC13D` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW` | [58730](source_parts/nswc_part_06.f90#L5901) | Not indexed |
| `MC13E` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, ARP, IB, NUM, LOWL, NUMB, PREV` | [58780](source_parts/nswc_part_06.f90#L5951) | Not indexed |
| `MC21A` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, IW` | [58544](source_parts/nswc_part_06.f90#L5715) | Not indexed |
| `MC21B` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, PR, ARP, CV, OUT` | [58595](source_parts/nswc_part_06.f90#L5766) | Not indexed |
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36020](source_parts/nswc_part_04.f90#L4245) | [Documented](docs/08-matrices.md#topic-146-01) |
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [51706](source_parts/nswc_part_05.f90#L9421) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [35964](source_parts/nswc_part_04.f90#L4189) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [35858](source_parts/nswc_part_04.f90#L4083) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [35978](source_parts/nswc_part_04.f90#L4203) | [Documented](docs/08-matrices.md#topic-144-01) |
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [35950](source_parts/nswc_part_04.f90#L4175) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [51904](source_parts/nswc_part_05.f90#L9619) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [35890](source_parts/nswc_part_04.f90#L4115) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [107240](source_parts/nswc_part_11.f90#L1298) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MEVAL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [107420](source_parts/nswc_part_11.f90#L1478) | Not indexed |
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [50175](source_parts/nswc_part_05.f90#L7890) | [Documented](docs/08-matrices.md#topic-191-01) |
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [89396](source_parts/nswc_part_09.f90#L4659) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [89434](source_parts/nswc_part_09.f90#L4697) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [106234](source_parts/nswc_part_11.f90#L292) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MINSOL` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTB` | [123857](source_parts/nswc_part_12.f90#L7402) | Not indexed |
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [86276](source_parts/nswc_part_09.f90#L1539) | [Documented](docs/15-optimization.md#topic-315-01) |
| `MKP1` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5, BB, BL, X, XL, B, UBB, LX, LXI, F, PBL, Q, V, BS, PS, WS, XS, IWK` | [86511](source_parts/nswc_part_09.f90#L1774) | Not indexed |
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [29115](source_parts/nswc_part_03.f90#L7988) | [Documented](docs/05-polynomials.md#topic-117-01) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [36798](source_parts/nswc_part_04.f90#L5023) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [38315](source_parts/nswc_part_04.f90#L6540) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [38359](source_parts/nswc_part_04.f90#L6584) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [36669](source_parts/nswc_part_04.f90#L4894) | [Documented](docs/08-matrices.md#topic-153-01) |
| `MTABLE` | `SUBROUTINE` | `DEGREE, DIMEN, NPOLYS, INDEXS, NEWKJ, ALFLP1` | [106723](source_parts/nswc_part_11.f90#L781) | Not indexed |
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [36732](source_parts/nswc_part_04.f90#L4957) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58083](source_parts/nswc_part_06.f90#L5254) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58112](source_parts/nswc_part_06.f90#L5283) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58033](source_parts/nswc_part_06.f90#L5204) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [58058](source_parts/nswc_part_06.f90#L5229) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `NEWEST` | `SUBROUTINE` | `TYPE, UU, VV, NN, P, K` | [32267](source_parts/nswc_part_04.f90#L492) | Not indexed |
| `NEWTON` | `SUBROUTINE` | `NL, NR, NI` | [92912](source_parts/nswc_part_09.f90#L8175) | Not indexed |
| `NEXTH` | `SUBROUTINE` | `BOOL, N, TR, TI, HR, HI, QPR, QPI, QHR, QHI` | [33192](source_parts/nswc_part_04.f90#L1417) | Not indexed |
| `NEXTK` | `SUBROUTINE` | `TYPE, N, QP, K, QK` | [32214](source_parts/nswc_part_04.f90#L439) | Not indexed |
| `NORMLZ` | `SUBROUTINE` | `N, X, BETA` | [79269](source_parts/nswc_part_08.f90#L5309) | Not indexed |
| `NOSHFT` | `SUBROUTINE` | `L1, NN, TR, TI, ETA, PR, PI, HR, HI` | [32736](source_parts/nswc_part_04.f90#L961) | Not indexed |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [38060](source_parts/nswc_part_04.f90#L6285) | [Documented](docs/08-matrices.md#topic-163-01) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [126831](source_parts/nswc_part_12.f90#L10376) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [126912](source_parts/nswc_part_12.f90#L10457) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [127066](source_parts/nswc_part_13.f90#L1) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NSPIV1` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [59035](source_parts/nswc_part_06.f90#L6206) | Not indexed |
| `NSTERP` | `SUBROUTINE` | `TM, WM, XM, M, TN, WN, XN, N, KERNEL, RHFCN, RHS, KMN, NHALF, NUP` | [115613](source_parts/nswc_part_11.f90#L9671) | Not indexed |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [102470](source_parts/nswc_part_10.f90#L7158) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [116278](source_parts/nswc_part_11.f90#L10336) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-415-01) |
| `OPCHK1` | `SUBROUTINE` | `N, X, TYPSIZ, FSCALE, GRADTL, ITNLIM, RERR, STEPMX, IERR` | [80641](source_parts/nswc_part_08.f90#L6681) | Not indexed |
| `OPSTP` | `SUBROUTINE` | `N, XPLS, FPLS, GPLS, X, ITNCNT, ICSCMX, IERR, GRADTL, STEPTL, TYPSIZ, FSCALE, ITNLIM, IRETCD, MXTAKE, FSTACK, NS, SPTR` | [80738](source_parts/nswc_part_08.f90#L6778) | Not indexed |
| `OPTDRV` | `SUBROUTINE` | `MO, NR, N, X, FCN, TYPSIZ, FSCALE, RERR, ITNLIM, ITNCNT, GRADTL, STEPMX, STEPTL, XPLS, FPLS, GPLS, IERR, A, G, P, WRK0, WRK1, WRK2` | [80421](source_parts/nswc_part_08.f90#L6461) | Not indexed |
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [80331](source_parts/nswc_part_08.f90#L6371) | [Documented](docs/15-optimization.md#topic-307-01) |
| `ORIMP` | `SUBROUTINE` | `M, N, A, KA, QR, MS, S, IP, B, X, R, EXIT` | [70987](source_parts/nswc_part_07.f90#L7567) | Not indexed |
| `ORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [70892](source_parts/nswc_part_07.f90#L7472) | Not indexed |
| `ORTHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [63066](source_parts/nswc_part_06.f90#L10237) | Not indexed |
| `ORTHG` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTRB` | [123808](source_parts/nswc_part_12.f90#L7353) | Not indexed |
| `ORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [70778](source_parts/nswc_part_07.f90#L7358) | Not indexed |
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [29429](source_parts/nswc_part_03.f90#L8302) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [29513](source_parts/nswc_part_03.f90#L8386) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [29572](source_parts/nswc_part_03.f90#L8445) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [63663](source_parts/nswc_part_07.f90#L243) | Not indexed |
| `ORTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [63755](source_parts/nswc_part_07.f90#L335) | Not indexed |
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [28589](source_parts/nswc_part_03.f90#L7462) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `PARC` | `SUBROUTINE` | `I, II, UB, IFLAG, VB, LUB, LJ, LI, F, BB, Q, B, N, M, NP1, LX, LXI, LR, LRI, LUBI` | [86978](source_parts/nswc_part_09.f90#L2241) | Not indexed |
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [5251](source_parts/nswc_part_01.f90#L5251) | [Documented](docs/03-geometry.md#topic-042-01) |
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [43346](source_parts/nswc_part_05.f90#L1061) | [Documented](docs/08-matrices.md#topic-176-01) |
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [94235](source_parts/nswc_part_09.f90#L9498) | [Documented](docs/18-curve-fitting.md#topic-339-01) |
| `PDEDGE` | `SUBROUTINE` | `EDGE, INDX, INDY, IERR` | [122781](source_parts/nswc_part_12.f90#L6326) | Not indexed |
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [96237](source_parts/nswc_part_10.f90#L925) | [Documented](docs/18-curve-fitting.md#topic-353-01) |
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [28765](source_parts/nswc_part_03.f90#L7638) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [96107](source_parts/nswc_part_10.f90#L795) | [Documented](docs/18-curve-fitting.md#topic-352-01) |
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [27183](source_parts/nswc_part_03.f90#L6056) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [27228](source_parts/nswc_part_03.f90#L6101) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [4676](source_parts/nswc_part_01.f90#L4676) | [Documented](docs/03-geometry.md#topic-040-01) |
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [94267](source_parts/nswc_part_09.f90#L9530) | [Documented](docs/18-curve-fitting.md#topic-340-01) |
| `PI1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, BB, KUB, BL, LB, PBL, V, XL, NP1, N5, BS, PS, WS, XS, IWK` | [86859](source_parts/nswc_part_09.f90#L2122) | Not indexed |
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [28993](source_parts/nswc_part_03.f90#L7866) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `PJAC` | `SUBROUTINE` | `NEQ, Y, YH, NYH, EWT, FTEM, SAVF, WM, IWM, F, JAC, RPAR, IPAR` | [121761](source_parts/nswc_part_12.f90#L5306) | Not indexed |
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [28062](source_parts/nswc_part_03.f90#L6935) | [Documented](docs/04-special-functions.md#topic-109-01) |
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [28535](source_parts/nswc_part_03.f90#L7408) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [27275](source_parts/nswc_part_03.f90#L6148) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [27322](source_parts/nswc_part_03.f90#L6195) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [28880](source_parts/nswc_part_03.f90#L7753) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [28681](source_parts/nswc_part_03.f90#L7554) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `PNDF` | `FUNCTION` | `X, IND` | [8284](source_parts/nswc_part_01.f90#L8284) | [Documented](docs/04-special-functions.md#topic-053-01) |
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [8318](source_parts/nswc_part_01.f90#L8318) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [3218](source_parts/nswc_part_01.f90#L3218) | [Documented](docs/02-elementary-operations.md#topic-028-01) |
| `POLYDD` | `DOUBLE PRECISION FUNCTION` | `X` | [93059](source_parts/nswc_part_09.f90#L8322) | Not indexed |
| `POLYEV` | `SUBROUTINE` | `N, SR, SI, PR, PI, QR, QI, PVR, PVI` | [33228](source_parts/nswc_part_04.f90#L1453) | Not indexed |
| `PPADD` | `SUBROUTINE` | `N, IERROR, A, C, CBP, BP, BH` | [125508](source_parts/nswc_part_12.f90#L9053) | Not indexed |
| `PPSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [125747](source_parts/nswc_part_12.f90#L9292) | Not indexed |
| `PPSPF` | `FUNCTION` | `X, IZ, C, A, BH` | [125762](source_parts/nswc_part_12.f90#L9307) | Not indexed |
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [99164](source_parts/nswc_part_10.f90#L3852) | [Documented](docs/18-curve-fitting.md#topic-372-01) |
| `PROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, W, U` | [124742](source_parts/nswc_part_12.f90#L8287) | Not indexed |
| `PRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, U, W` | [124851](source_parts/nswc_part_12.f90#L8396) | Not indexed |
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [96330](source_parts/nswc_part_10.f90#L1018) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [96416](source_parts/nswc_part_10.f90#L1104) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [125696](source_parts/nswc_part_12.f90#L9241) | Not indexed |
| `PSI` | `REAL FUNCTION` | `XX` | [12320](source_parts/nswc_part_02.f90#L1735) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [12920](source_parts/nswc_part_02.f90#L2335) | [Documented](docs/04-special-functions.md#topic-071-01) |
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [28635](source_parts/nswc_part_03.f90#L7508) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [109499](source_parts/nswc_part_11.f90#L3557) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `QAGI1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [88471](source_parts/nswc_part_09.f90#L3734) | Not indexed |
| `QAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [109688](source_parts/nswc_part_11.f90#L3746) | Not indexed |
| `QAGIE1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [88679](source_parts/nswc_part_09.f90#L3942) | Not indexed |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [108679](source_parts/nswc_part_11.f90#L2737) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [108860](source_parts/nswc_part_11.f90#L2918) | Not indexed |
| `QDCRT` | `SUBROUTINE` | `A, Z` | [30486](source_parts/nswc_part_03.f90#L9359) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [110486](source_parts/nswc_part_11.f90#L4544) | Not indexed |
| `QFORM` | `SUBROUTINE` | `M, N, Q, LDQ, WA` | [83003](source_parts/nswc_part_08.f90#L9043) | Not indexed |
| `QK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [110173](source_parts/nswc_part_11.f90#L4231) | Not indexed |
| `QK15I1` | `SUBROUTINE` | `F, PHI, Y, C, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [89181](source_parts/nswc_part_09.f90#L4444) | Not indexed |
| `QK21F` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [109332](source_parts/nswc_part_11.f90#L3390) | Not indexed |
| `QPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [110348](source_parts/nswc_part_11.f90#L4406) | Not indexed |
| `QRFAC` | `SUBROUTINE` | `M, N, A, LDA, PIVOT, IPVT, LIPVT, RDIAG, ACNORM, WA` | [83100](source_parts/nswc_part_08.f90#L9140) | Not indexed |
| `QRSOLV` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, X, SDIAG, WA` | [83279](source_parts/nswc_part_08.f90#L9319) | Not indexed |
| `QRUPDT` | `SUBROUTINE` | `NR, N, A, U, V` | [81392](source_parts/nswc_part_08.f90#L7432) | Not indexed |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [2489](source_parts/nswc_part_01.f90#L2489) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [2086](source_parts/nswc_part_01.f90#L2086) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [2287](source_parts/nswc_part_01.f90#L2287) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [108329](source_parts/nswc_part_11.f90#L2387) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [31073](source_parts/nswc_part_03.f90#L9946) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QUAD` | `SUBROUTINE` | `A, B, RESULT, K, EPSIL, NPTS, ICHECK, F` | [108486](source_parts/nswc_part_11.f90#L2544) | Not indexed |
| `QUADIT` | `SUBROUTINE` | `UU, VV, NZ, NN, P, QP, K, QK` | [31925](source_parts/nswc_part_04.f90#L150) | Not indexed |
| `QUADPL` | `SUBROUTINE` | `A, B1, C, SR, SI, LR, LI` | [32342](source_parts/nswc_part_04.f90#L567) | Not indexed |
| `QUADSD` | `SUBROUTINE` | `NN, U, V, P, Q, A, B` | [32316](source_parts/nswc_part_04.f90#L541) | Not indexed |
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [98118](source_parts/nswc_part_10.f90#L2806) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [98359](source_parts/nswc_part_10.f90#L3047) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QXCPY` | `SUBROUTINE` | `A, B, L` | [111289](source_parts/nswc_part_11.f90#L5347) | Not indexed |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [110668](source_parts/nswc_part_11.f90#L4726) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [110847](source_parts/nswc_part_11.f90#L4905) | Not indexed |
| `QXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [111305](source_parts/nswc_part_11.f90#L5363) | Not indexed |
| `QXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [111604](source_parts/nswc_part_11.f90#L5662) | Not indexed |
| `QXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [111425](source_parts/nswc_part_11.f90#L5483) | Not indexed |
| `R1MPYQ` | `SUBROUTINE` | `M, N, A, LDA, V, W` | [83477](source_parts/nswc_part_08.f90#L9517) | Not indexed |
| `R1UPDT` | `SUBROUTINE` | `M, N, S, LS, U, V, W, SING` | [83571](source_parts/nswc_part_08.f90#L9611) | Not indexed |
| `RADB2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [90675](source_parts/nswc_part_09.f90#L5938) | Not indexed |
| `RADB3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [90724](source_parts/nswc_part_09.f90#L5987) | Not indexed |
| `RADB4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [90790](source_parts/nswc_part_09.f90#L6053) | Not indexed |
| `RADB5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [90884](source_parts/nswc_part_09.f90#L6147) | Not indexed |
| `RADBG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [90995](source_parts/nswc_part_09.f90#L6258) | Not indexed |
| `RADF2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [91295](source_parts/nswc_part_09.f90#L6558) | Not indexed |
| `RADF3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [91344](source_parts/nswc_part_09.f90#L6607) | Not indexed |
| `RADF4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [91408](source_parts/nswc_part_09.f90#L6671) | Not indexed |
| `RADF5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [91498](source_parts/nswc_part_09.f90#L6761) | Not indexed |
| `RADFG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [91605](source_parts/nswc_part_09.f90#L6868) | Not indexed |
| `RADIX` | `SUBROUTINE` | `IBETA` | [698](source_parts/nswc_part_01.f90#L698) | Not indexed |
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [127456](source_parts/nswc_part_13.f90#L391) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `RARC` | `SUBROUTINE` | `IA, IB, AR, AC, PR, PC, VR, VC, K1, JJ, LL, N, M, NP1` | [6021](source_parts/nswc_part_01.f90#L6021) | Not indexed |
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [127803](source_parts/nswc_part_13.f90#L738) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [33286](source_parts/nswc_part_04.f90#L1511) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [126477](source_parts/nswc_part_12.f90#L10022) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `RCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [126504](source_parts/nswc_part_12.f90#L10049) | Not indexed |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [14240](source_parts/nswc_part_02.f90#L3655) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `RCVAL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [26466](source_parts/nswc_part_03.f90#L5339) | Not indexed |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [25894](source_parts/nswc_part_03.f90#L4767) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `REALIT` | `SUBROUTINE` | `SSS, NZ, IFLAG, NN, P, QP, K, QK` | [32043](source_parts/nswc_part_04.f90#L268) | Not indexed |
| `REXP` | `REAL FUNCTION` | `X` | [4065](source_parts/nswc_part_01.f90#L4065) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `REXP1` | `SUBROUTINE` | `X, E, W` | [4149](source_parts/nswc_part_01.f90#L4149) | Not indexed |
| `RFFTB` | `SUBROUTINE` | `N, R, WSAVE` | [90603](source_parts/nswc_part_09.f90#L5866) | Not indexed |
| `RFFTB1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [90611](source_parts/nswc_part_09.f90#L5874) | Not indexed |
| `RFFTF` | `SUBROUTINE` | `N, R, WSAVE` | [91222](source_parts/nswc_part_09.f90#L6485) | Not indexed |
| `RFFTF1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [91230](source_parts/nswc_part_09.f90#L6493) | Not indexed |
| `RFFTI` | `SUBROUTINE` | `N, WSAVE` | [90473](source_parts/nswc_part_09.f90#L5736) | Not indexed |
| `RFFTI1` | `SUBROUTINE` | `N, WA, IFAC` | [90481](source_parts/nswc_part_09.f90#L5744) | Not indexed |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [25655](source_parts/nswc_part_03.f90#L4528) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [127646](source_parts/nswc_part_13.f90#L581) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [1716](source_parts/nswc_part_01.f90#L1716) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [26156](source_parts/nswc_part_03.f90#L5029) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [122423](source_parts/nswc_part_12.f90#L5968) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-431-01) |
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [122485](source_parts/nswc_part_12.f90#L6030) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-433-01) |
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [118240](source_parts/nswc_part_12.f90#L1785) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-421-01) |
| `RKFC` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, W, WP, X, HINT, H, Y1, Y2, F1, F2, F3, F4, F7, SAVRE, SAVAE, TOLD, NFE, JFLAG, KFLAG, ENDPNT, BLKOUT` | [117555](source_parts/nswc_part_12.f90#L1100) | Not indexed |
| `RKFS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YP, H, F1, F2, F3, F4, F5, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [118438](source_parts/nswc_part_12.f90#L1983) | Not indexed |
| `RLOC` | `LOGICAL FUNCTION` | `X, Y` | [36862](source_parts/nswc_part_04.f90#L5087) | Not indexed |
| `RLOG` | `REAL FUNCTION` | `X` | [4327](source_parts/nswc_part_01.f90#L4327) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RLOG1` | `REAL FUNCTION` | `X` | [4380](source_parts/nswc_part_01.f90#L4380) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RMIN` | `FUNCTION` | `N, M, COND, UNITRD, AVERR` | [115661](source_parts/nswc_part_11.f90#L9719) | Not indexed |
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [128514](source_parts/nswc_part_13.f90#L1449) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `RNDERR` | `FUNCTION` | `X, A, Y, B` | [114955](source_parts/nswc_part_11.f90#L9013) | Not indexed |
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [37299](source_parts/nswc_part_04.f90#L5524) | [Documented](docs/08-matrices.md#topic-161-01) |
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [126709](source_parts/nswc_part_12.f90#L10254) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `RNRM` | `REAL FUNCTION` | `X, Y, N, IFLAG` | [115681](source_parts/nswc_part_11.f90#L9739) | Not indexed |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [2765](source_parts/nswc_part_01.f90#L2765) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ROT3` | `SUBROUTINE` | `A, THETA` | [3408](source_parts/nswc_part_01.f90#L3408) | [Documented](docs/02-elementary-operations.md#topic-030-01) |
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [3245](source_parts/nswc_part_01.f90#L3245) | [Documented](docs/02-elementary-operations.md#topic-028-03) |
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [57049](source_parts/nswc_part_06.f90#L4220) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [57113](source_parts/nswc_part_06.f90#L4284) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RRSORT` | `SUBROUTINE` | `A, B, N` | [1771](source_parts/nswc_part_01.f90#L1771) | Not indexed |
| `RSCO` | `SUBROUTINE` | `RSAV, ISAV` | [120371](source_parts/nswc_part_12.f90#L3916) | Not indexed |
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56929](source_parts/nswc_part_06.f90#L4100) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [59322](source_parts/nswc_part_06.f90#L6493) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `RSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [59426](source_parts/nswc_part_06.f90#L6597) | Not indexed |
| `RSORT` | `SUBROUTINE` | `A, N` | [1666](source_parts/nswc_part_01.f90#L1666) | Not indexed |
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [60814](source_parts/nswc_part_06.f90#L7985) | [Documented](docs/11-sparse-matrices.md#topic-250-01) |
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [58371](source_parts/nswc_part_06.f90#L5542) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [57442](source_parts/nswc_part_06.f90#L4613) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [35169](source_parts/nswc_part_04.f90#L3394) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [35027](source_parts/nswc_part_04.f90#L3252) | [Documented](docs/07-vectors.md#topic-138-01) |
| `SCALCP` | `DOUBLE PRECISION FUNCTION` | `NN, PT, ETA, INFIN, SMALNO, BASE` | [32638](source_parts/nswc_part_04.f90#L863) | Not indexed |
| `SCALDN` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [107211](source_parts/nswc_part_11.f90#L1269) | Not indexed |
| `SCALEX` | `SUBROUTINE` | `MO, X, TYPSIZ, N, IERR` | [80895](source_parts/nswc_part_08.f90#L6935) | Not indexed |
| `SCALPM` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [107172](source_parts/nswc_part_11.f90#L1230) | Not indexed |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [35260](source_parts/nswc_part_04.f90#L3485) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SCD` | `SUBROUTINE` | `U, K, L, F, S, C, D` | [26799](source_parts/nswc_part_03.f90#L5672) | Not indexed |
| `SCDF` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [26920](source_parts/nswc_part_03.f90#L5793) | Not indexed |
| `SCDJ` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [26990](source_parts/nswc_part_03.f90#L5863) | Not indexed |
| `SCDM` | `SUBROUTINE` | `U, K, S, C, D` | [26896](source_parts/nswc_part_03.f90#L5769) | Not indexed |
| `SCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [47551](source_parts/nswc_part_05.f90#L5266) | Not indexed |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [35568](source_parts/nswc_part_04.f90#L3793) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [95095](source_parts/nswc_part_09.f90#L10358) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [95203](source_parts/nswc_part_09.f90#L10466) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [95313](source_parts/nswc_part_10.f90#L1) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [57020](source_parts/nswc_part_06.f90#L4191) | [Documented](docs/11-sparse-matrices.md#topic-232-01) |
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [33627](source_parts/nswc_part_04.f90#L1852) | [Documented](docs/07-vectors.md#topic-130-01) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56769](source_parts/nswc_part_06.f90#L3940) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [56860](source_parts/nswc_part_06.f90#L4031) | [Documented](docs/11-sparse-matrices.md#topic-230-01) |
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [56742](source_parts/nswc_part_06.f90#L3913) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [34694](source_parts/nswc_part_04.f90#L2919) | [Documented](docs/07-vectors.md#topic-136-01) |
| `SECFAC` | `SUBROUTINE` | `NR, N, X, G, A, XPLS, GPLS, ITNCNT, TOL, NOUPDT, S, Y, W` | [81231](source_parts/nswc_part_08.f90#L7271) | Not indexed |
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [65773](source_parts/nswc_part_07.f90#L2353) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [65794](source_parts/nswc_part_07.f90#L2374) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [65841](source_parts/nswc_part_07.f90#L2421) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [65875](source_parts/nswc_part_07.f90#L2455) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [122561](source_parts/nswc_part_12.f90#L6106) | [Documented](docs/25-partial-differential-equations.md#topic-434-01) |
| `SEPEL1` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, AN, BN, CN, DN, UN, ZN, AM, BM, CM, DM, UM, ZM, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [123338](source_parts/nswc_part_12.f90#L6883) | Not indexed |
| `SEPELL` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [122839](source_parts/nswc_part_12.f90#L6384) | Not indexed |
| `SETRM` | `SUBROUTINE` | `XK, YK, ZK, XI, YI, ZI, S1, S2, R, ROW` | [105326](source_parts/nswc_part_10.f90#L10014) | Not indexed |
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [95426](source_parts/nswc_part_10.f90#L114) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [95541](source_parts/nswc_part_10.f90#L229) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [95657](source_parts/nswc_part_10.f90#L345) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SFFT` | `SUBROUTINE` | `A, B, NTOT, N, NSPAN, ISN, IERR` | [89466](source_parts/nswc_part_09.f90#L4729) | Not indexed |
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [119495](source_parts/nswc_part_12.f90#L3040) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [119530](source_parts/nswc_part_12.f90#L3075) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [105562](source_parts/nswc_part_10.f90#L10250) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [105596](source_parts/nswc_part_10.f90#L10284) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SGBFA` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, INFO` | [122031](source_parts/nswc_part_12.f90#L5576) | Not indexed |
| `SGBSL` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, B, JOB` | [122230](source_parts/nswc_part_12.f90#L5775) | Not indexed |
| `SGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [38538](source_parts/nswc_part_04.f90#L6763) | Not indexed |
| `SGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [39044](source_parts/nswc_part_04.f90#L7269) | Not indexed |
| `SGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [38774](source_parts/nswc_part_04.f90#L6999) | Not indexed |
| `SGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [38905](source_parts/nswc_part_04.f90#L7130) | Not indexed |
| `SHELL` | `SUBROUTINE` | `A, N` | [1562](source_parts/nswc_part_01.f90#L1562) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [1612](source_parts/nswc_part_01.f90#L1612) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHIFTD` | `SUBROUTINE` | `NFRST, NLAST, KK, IARR` | [103878](source_parts/nswc_part_10.f90#L8566) | Not indexed |
| `SHRSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [47832](source_parts/nswc_part_05.f90#L5547) | Not indexed |
| `SI` | `FUNCTION` | `X` | [10158](source_parts/nswc_part_01.f90#L10158) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `SIGMA1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, KUB, UB, NP1, N5, LX, LR, BS, PS, WS, XS, IWK` | [86794](source_parts/nswc_part_09.f90#L2057) | Not indexed |
| `SIN0` | `REAL FUNCTION` | `X` | [3542](source_parts/nswc_part_01.f90#L3542) | Not indexed |
| `SIN1` | `REAL FUNCTION` | `X` | [3580](source_parts/nswc_part_01.f90#L3580) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [90428](source_parts/nswc_part_09.f90#L5691) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [90358](source_parts/nswc_part_09.f90#L5621) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SKNP` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, N5, PS, WS, XS, IWK` | [87031](source_parts/nswc_part_09.f90#L2294) | Not indexed |
| `SKNP1` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, PS, WS, XS, D, MIN, PBAR, WBAR, ZBAR` | [87078](source_parts/nswc_part_09.f90#L2341) | Not indexed |
| `SLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [38118](source_parts/nswc_part_04.f90#L6343) | Not indexed |
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [38400](source_parts/nswc_part_04.f90#L6625) | [Documented](docs/08-matrices.md#topic-168-01) |
| `SLVS` | `SUBROUTINE` | `WM, IWM, X, TEM` | [121949](source_parts/nswc_part_12.f90#L5494) | Not indexed |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [36657](source_parts/nswc_part_04.f90#L4882) | [Documented](docs/08-matrices.md#topic-151-01) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [36034](source_parts/nswc_part_04.f90#L4259) | [Documented](docs/08-matrices.md#topic-146-01) |
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [83789](source_parts/nswc_part_08.f90#L9829) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SMPLX1` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [83842](source_parts/nswc_part_08.f90#L9882) | Not indexed |
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [37192](source_parts/nswc_part_04.f90#L5417) | [Documented](docs/08-matrices.md#topic-159-01) |
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [41144](source_parts/nswc_part_04.f90#L9369) | [Documented](docs/08-matrices.md#topic-173-01) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [36720](source_parts/nswc_part_04.f90#L4945) | [Documented](docs/08-matrices.md#topic-153-01) |
| `SNBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [54874](source_parts/nswc_part_06.f90#L2045) | Not indexed |
| `SNBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [55081](source_parts/nswc_part_06.f90#L2252) | Not indexed |
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [3910](source_parts/nswc_part_01.f90#L3910) | [Documented](docs/02-elementary-operations.md#topic-035-01) |
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [58345](source_parts/nswc_part_06.f90#L5516) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [35294](source_parts/nswc_part_04.f90#L3519) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SOL` | `SUBROUTINE` | `N, NDIM, A, B, IP` | [38012](source_parts/nswc_part_04.f90#L6237) | Not indexed |
| `SOLBT` | `SUBROUTINE` | `M, N, A, B, C, Y, IP` | [41071](source_parts/nswc_part_04.f90#L9296) | Not indexed |
| `SOLVE2` | `SUBROUTINE` | `M, N, M1, A, B, W, N1, IPIVOT, QR, D, ETA, FAIL, NUMIT, DIGITX, X, RES, WRES, Y1, Y2, Y, F, G, MM, MMPNN` | [78530](source_parts/nswc_part_08.f90#L4570) | Not indexed |
| `SOLVE3` | `SUBROUTINE` | `F, M1, M, N1, QR, D, Y, MMPNN` | [78706](source_parts/nswc_part_08.f90#L4746) | Not indexed |
| `SONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [60950](source_parts/nswc_part_06.f90#L8121) | Not indexed |
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [94917](source_parts/nswc_part_09.f90#L10180) | [Documented](docs/18-curve-fitting.md#topic-344-01) |
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [101130](source_parts/nswc_part_10.f90#L5818) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-379-01) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [94748](source_parts/nswc_part_09.f90#L10011) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [78853](source_parts/nswc_part_08.f90#L4893) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `SPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [59632](source_parts/nswc_part_06.f90#L6803) | Not indexed |
| `SPMPAR` | `REAL FUNCTION` | `I` | [1237](source_parts/nswc_part_01.f90#L1237) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [58464](source_parts/nswc_part_06.f90#L5635) | [Documented](docs/11-sparse-matrices.md#topic-244-01) |
| `SPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [43564](source_parts/nswc_part_05.f90#L1279) | Not indexed |
| `SPPFA` | `SUBROUTINE` | `AP, N, INFO` | [43375](source_parts/nswc_part_05.f90#L1090) | Not indexed |
| `SPPSL` | `SUBROUTINE` | `AP, N, B` | [43476](source_parts/nswc_part_05.f90#L1191) | Not indexed |
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [57850](source_parts/nswc_part_06.f90#L5021) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [58916](source_parts/nswc_part_06.f90#L6087) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `SQUIN2` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD, EYE, TEMP, NW, TOL, MAXITS, IERR` | [49338](source_parts/nswc_part_05.f90#L7053) | Not indexed |
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [49236](source_parts/nswc_part_05.f90#L6951) | [Documented](docs/08-matrices.md#topic-189-01) |
| `SRCH` | `SUBROUTINE` | `FUN, COND, XL, ETA, X, NUM, IERR` | [87513](source_parts/nswc_part_09.f90#L2776) | Not indexed |
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [34016](source_parts/nswc_part_04.f90#L2241) | [Documented](docs/07-vectors.md#topic-132-01) |
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [3258](source_parts/nswc_part_01.f90#L3258) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [34296](source_parts/nswc_part_04.f90#L2521) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [34140](source_parts/nswc_part_04.f90#L2365) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [34879](source_parts/nswc_part_04.f90#L3104) | [Documented](docs/07-vectors.md#topic-137-01) |
| `SSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [41185](source_parts/nswc_part_04.f90#L9410) | Not indexed |
| `SSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [42004](source_parts/nswc_part_04.f90#L10229) | Not indexed |
| `SSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [41511](source_parts/nswc_part_04.f90#L9736) | Not indexed |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [84738](source_parts/nswc_part_09.f90#L1) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SSPLX1` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [84792](source_parts/nswc_part_09.f90#L55) | Not indexed |
| `SSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [41802](source_parts/nswc_part_04.f90#L10027) | Not indexed |
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [57646](source_parts/nswc_part_06.f90#L4817) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [45422](source_parts/nswc_part_05.f90#L3137) | [Documented](docs/08-matrices.md#topic-183-01) |
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [33859](source_parts/nswc_part_04.f90#L2084) | [Documented](docs/07-vectors.md#topic-131-01) |
| `STEP1` | `SUBROUTINE` | `F, NEQN, Y, X, H, EPS, WT, START, HOLD, K, KOLD, CRASH, PHI, P, YP, PSI, ALPHA, BETA, SIG, V, W, G, PHASE1, NS, NORND` | [116632](source_parts/nswc_part_12.f90#L177) | Not indexed |
| `STFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR, JAC` | [119573](source_parts/nswc_part_12.f90#L3118) | Not indexed |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [79308](source_parts/nswc_part_08.f90#L5348) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `STOD` | `SUBROUTINE` | `NEQ, Y, YH, NYH, YH1, EWT, SAVF, ACOR, WM, IWM, F, JAC, RPAR, IPAR` | [121149](source_parts/nswc_part_12.f90#L4694) | Not indexed |
| `STORE2` | `SUBROUTINE` | `A, B` | [968](source_parts/nswc_part_01.f90#L968) | Not indexed |
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [101863](source_parts/nswc_part_10.f90#L6551) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-384-01) |
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [102301](source_parts/nswc_part_10.f90#L6989) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `SVCO` | `SUBROUTINE` | `RSAV, ISAV` | [120394](source_parts/nswc_part_12.f90#L3939) | Not indexed |
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [37120](source_parts/nswc_part_04.f90#L5345) | [Documented](docs/08-matrices.md#topic-157-01) |
| `SWAPD` | `SUBROUTINE` | `NIN1, NIN2, NOUT1, NOUT2, IADJ, IEND` | [103993](source_parts/nswc_part_10.f90#L8681) | Not indexed |
| `SWPTST` | `LOGICAL FUNCTION` | `IN1, IN2, IO1, IO2, X, Y` | [104204](source_parts/nswc_part_10.f90#L8892) | Not indexed |
| `SYMSLV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [48755](source_parts/nswc_part_05.f90#L6470) | Not indexed |
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [48583](source_parts/nswc_part_05.f90#L6298) | [Documented](docs/08-matrices.md#topic-188-01) |
| `TASLV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [48646](source_parts/nswc_part_05.f90#L6361) | Not indexed |
| `TERMS` | `SUBROUTINE` | `DIAG, SDIAG, SIGMA, DEL` | [98574](source_parts/nswc_part_10.f90#L3262) | Not indexed |
| `TINDX` | `INTEGER FUNCTION` | `NVERTX, NABOR, IADJ, IEND` | [104304](source_parts/nswc_part_10.f90#L8992) | Not indexed |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [36131](source_parts/nswc_part_04.f90#L4356) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [37174](source_parts/nswc_part_04.f90#L5399) | [Documented](docs/08-matrices.md#topic-158-01) |
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [44038](source_parts/nswc_part_05.f90#L1753) | [Documented](docs/08-matrices.md#topic-177-01) |
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [36089](source_parts/nswc_part_04.f90#L4314) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [66589](source_parts/nswc_part_07.f90#L3169) | Not indexed |
| `TQLRAT` | `SUBROUTINE` | `N, D, E2, IERR` | [66150](source_parts/nswc_part_07.f90#L2730) | Not indexed |
| `TQLRT0` | `SUBROUTINE` | `N, D, E2, IERR` | [125344](source_parts/nswc_part_12.f90#L8889) | Not indexed |
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [128276](source_parts/nswc_part_13.f90#L1211) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `TRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [65909](source_parts/nswc_part_07.f90#L2489) | Not indexed |
| `TRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [66436](source_parts/nswc_part_07.f90#L3016) | Not indexed |
| `TRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [66033](source_parts/nswc_part_07.f90#L2613) | Not indexed |
| `TRFIND` | `SUBROUTINE` | `NST, PX, PY, X, Y, IADJ, IEND, I1, I2, I3` | [104358](source_parts/nswc_part_10.f90#L9046) | Not indexed |
| `TRISLV` | `SUBROUTINE` | `NM, N, U, V, L, F, TEMP, IERR` | [50072](source_parts/nswc_part_05.f90#L7787) | Not indexed |
| `TRISP` | `SUBROUTINE` | `N, A, B, C, D, U, Z` | [123910](source_parts/nswc_part_12.f90#L7455) | Not indexed |
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [103160](source_parts/nswc_part_10.f90#L7848) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `TRP` | `FUNCTION` | `A, N, X, Y` | [93962](source_parts/nswc_part_09.f90#L9225) | [Documented](docs/18-curve-fitting.md#topic-336-01) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [59473](source_parts/nswc_part_06.f90#L6644) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `TSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [59577](source_parts/nswc_part_06.f90#L6748) | Not indexed |
| `TVAL` | `SUBROUTINE` | `X, Y, X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3, ZX1, ZX2, ZX3, ZY1, ZY2, ZY3, IFLAG, W, WX, WY, IER` | [105943](source_parts/nswc_part_11.f90#L1) | Not indexed |
| `U11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [71650](source_parts/nswc_part_07.f90#L8230) | Not indexed |
| `U11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [72127](source_parts/nswc_part_07.f90#L8707) | Not indexed |
| `U12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [71978](source_parts/nswc_part_07.f90#L8558) | Not indexed |
| `U12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [72455](source_parts/nswc_part_07.f90#L9035) | Not indexed |
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [125777](source_parts/nswc_part_12.f90#L9322) | [Documented](docs/26-discrete-random-number-generation.md#topic-438-01) |
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [125882](source_parts/nswc_part_12.f90#L9427) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `URNG0` | `SUBROUTINE` | `IX, U, V` | [126045](source_parts/nswc_part_12.f90#L9590) | Not indexed |
| `URNG1` | `SUBROUTINE` | `IX, U, V, D` | [126189](source_parts/nswc_part_12.f90#L9734) | Not indexed |
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [126341](source_parts/nswc_part_12.f90#L9886) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [27372](source_parts/nswc_part_03.f90#L6245) | [Documented](docs/04-special-functions.md#topic-105-01) |
| `VNORM` | `FUNCTION` | `V, NCOMP` | [122385](source_parts/nswc_part_12.f90#L5930) | Not indexed |
| `VNWRMS` | `REAL FUNCTION` | `N, V, W` | [122402](source_parts/nswc_part_12.f90#L5947) | Not indexed |
| `VRSHFT` | `SUBROUTINE` | `L3, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [32982](source_parts/nswc_part_04.f90#L1207) | Not indexed |
| `WANDT` | `SUBROUTINE` | `WV, TV, N, A, B` | [115726](source_parts/nswc_part_11.f90#L9784) | Not indexed |
| `WNLIT` | `SUBROUTINE` | `W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM, IDOPE, DOPE, DONE` | [77428](source_parts/nswc_part_08.f90#L3468) | Not indexed |
| `WNLSM` | `SUBROUTINE` | `W, MDW, MME, MA, N, L, PRGOPT, X, RNORM, MODE, IPIVOT, ITYPE, WD, H, SCALE, Z, TEMP, D` | [76747](source_parts/nswc_part_08.f90#L2787) | Not indexed |
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [76480](source_parts/nswc_part_08.f90#L2520) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-296-01) |
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [94428](source_parts/nswc_part_09.f90#L9691) | [Documented](docs/18-curve-fitting.md#topic-341-01) |
| `XCOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [87884](source_parts/nswc_part_09.f90#L3147) | Not indexed |
| `XCONDX` | `FUNCTION` | `X, Y, C, FUN` | [87959](source_parts/nswc_part_09.f90#L3222) | Not indexed |
| `XCONDY` | `FUNCTION` | `X, Y, C, FUN` | [87986](source_parts/nswc_part_09.f90#L3249) | Not indexed |
| `XL1` | `SUBROUTINE` | `K, L, M, N, KLMD, KLM2D, NKLMD, N2D, Q, KODE, TOLER, ITER, X, RES, ERROR, CU, IU, S` | [70257](source_parts/nswc_part_07.f90#L6837) | Not indexed |
| `YCHG` | `SUBROUTINE` | `X, Y, YOLD` | [36895](source_parts/nswc_part_04.f90#L5120) | Not indexed |
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [29616](source_parts/nswc_part_03.f90#L8489) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `ZZZJAC` | `SUBROUTINE` | `T, Y, PD, N, RPAR, IPAR` | [119559](source_parts/nswc_part_12.f90#L3104) | Not indexed |
