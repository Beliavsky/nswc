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
| `ABCON` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [75991](source_parts/nswc_part_08.f90#L1598) | Not indexed |
| `ABCON1` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [76147](source_parts/nswc_part_08.f90#L1754) | Not indexed |
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [41627](source_parts/nswc_part_04.f90#L10003) | [Documented](docs/08-matrices.md#topic-186-01) |
| `ABSLV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [41700](source_parts/nswc_part_04.f90#L10076) | Not indexed |
| `ACOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [76251](source_parts/nswc_part_08.f90#L1858) | Not indexed |
| `ACONDF` | `FUNCTION` | `X, Y, C, FUN` | [76308](source_parts/nswc_part_08.f90#L1915) | Not indexed |
| `ACONDG` | `FUNCTION` | `X, Y, C, FUN` | [76326](source_parts/nswc_part_08.f90#L1933) | Not indexed |
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [80263](source_parts/nswc_part_08.f90#L5870) | [Documented](docs/17-approximation-of-functions.md#topic-329-01) |
| `ADAPT1` | `SUBROUTINE` | `F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [80347](source_parts/nswc_part_08.f90#L5954) | Not indexed |
| `ADCHK` | `SUBROUTINE` | `` | [81077](source_parts/nswc_part_08.f90#L6684) | Not indexed |
| `ADCOMP` | `SUBROUTINE` | `F` | [80743](source_parts/nswc_part_08.f90#L6350) | Not indexed |
| `ADNODE` | `SUBROUTINE` | `KK, X, Y, IADJ, IEND, IER` | [89768](source_parts/nswc_part_09.f90#L4835) | Not indexed |
| `ADPUT` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [81129](source_parts/nswc_part_08.f90#L6736) | Not indexed |
| `ADSET` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [80544](source_parts/nswc_part_08.f90#L6151) | Not indexed |
| `ADTAKE` | `SUBROUTINE` | `IERR` | [80668](source_parts/nswc_part_08.f90#L6275) | Not indexed |
| `ADTRAN` | `SUBROUTINE` | `D, POWERS` | [81206](source_parts/nswc_part_08.f90#L6813) | Not indexed |
| `AERF` | `REAL FUNCTION` | `X, H` | [6948](source_parts/nswc_part_01.f90#L6948) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `AI` | `REAL FUNCTION` | `X` | [20983](source_parts/nswc_part_02.f90#L10368) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AIA` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [20033](source_parts/nswc_part_02.f90#L9418) | Not indexed |
| `AIE` | `REAL FUNCTION` | `X` | [21117](source_parts/nswc_part_03.f90#L1) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AII` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [19971](source_parts/nswc_part_02.f90#L9356) | Not indexed |
| `AIMP` | `SUBROUTINE` | `X, R, PHI` | [21603](source_parts/nswc_part_03.f90#L487) | Not indexed |
| `AIRM` | `SUBROUTINE` | `IND, Z, AI, AIP, BI, BIP` | [19896](source_parts/nswc_part_02.f90#L9281) | Not indexed |
| `ALGDIV` | `REAL FUNCTION` | `A, B` | [11825](source_parts/nswc_part_02.f90#L1210) | Not indexed |
| `ALI` | `REAL FUNCTION` | `X` | [9372](source_parts/nswc_part_01.f90#L9372) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `ALLOT` | `SUBROUTINE` | `DEGREE, NPOLYS, NPTS, DIMEN, IWORK, IWKLEN, IREQD, DREQD, ERROR` | [92210](source_parts/nswc_part_09.f90#L7277) | Not indexed |
| `ALNREL` | `REAL FUNCTION` | `A` | [3602](source_parts/nswc_part_01.f90#L3602) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [2933](source_parts/nswc_part_01.f90#L2933) | [Documented](docs/02-elementary-operations.md#topic-032-01) |
| `AORD` | `SUBROUTINE` | `A, N` | [1707](source_parts/nswc_part_01.f90#L1707) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `APSER` | `REAL FUNCTION` | `A, B, X, EPS` | [14158](source_parts/nswc_part_02.f90#L3543) | Not indexed |
| `ARCEBE` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, PIVOT, X` | [36160](source_parts/nswc_part_04.f90#L4536) | Not indexed |
| `ARCEBM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [36138](source_parts/nswc_part_04.f90#L4514) | Not indexed |
| `ARCEBS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [36114](source_parts/nswc_part_04.f90#L4490) | Not indexed |
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [35325](source_parts/nswc_part_04.f90#L3701) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARCEDC` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, IFLAG` | [35435](source_parts/nswc_part_04.f90#L3811) | Not indexed |
| `ARCEFE` | `SUBROUTINE` | `BLOCK, NRWBLK, NRWPIV, PIVOT, B` | [36085](source_parts/nswc_part_04.f90#L4461) | Not indexed |
| `ARCEFM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, B, X` | [36063](source_parts/nswc_part_04.f90#L4439) | Not indexed |
| `ARCEFS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, B, X` | [36037](source_parts/nswc_part_04.f90#L4413) | Not indexed |
| `ARCEPC` | `SUBROUTINE` | `TOPBLK, NRWTOP, NOVRLP, BOTBLK, NRWBOT, NCLPIV, PIVOT, PIVMAX, IFLAG` | [35761](source_parts/nswc_part_04.f90#L4137) | Not indexed |
| `ARCEPR` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, PIVOT, PIVMAX, IFLAG` | [35668](source_parts/nswc_part_04.f90#L4044) | Not indexed |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [35861](source_parts/nswc_part_04.f90#L4237) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARTNQ` | `FUNCTION` | `Y, X` | [2458](source_parts/nswc_part_01.f90#L2458) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `ASIK` | `SUBROUTINE` | `X, FNU, KODE, FLGIK, RA, ARG, IN, TOL, Y` | [18472](source_parts/nswc_part_02.f90#L7857) | Not indexed |
| `ASJY` | `SUBROUTINE` | `FUNJY, X, FNU, FLGJY, IN, TOL, ELIM, Y, WK, IFLW` | [16694](source_parts/nswc_part_02.f90#L6079) | Not indexed |
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [74613](source_parts/nswc_part_08.f90#L220) | [Documented](docs/15-optimization.md#topic-314-01) |
| `ASSGN1` | `SUBROUTINE` | `N, A, C, T, CH, LC, LR, LZ, NZ, RH, SLC, SLR, U, IERR` | [74652](source_parts/nswc_part_08.f90#L259) | Not indexed |
| `ATN` | `COMPLEX FUNCTION` | `Z` | [22316](source_parts/nswc_part_03.f90#L1200) | Not indexed |
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [49003](source_parts/nswc_part_05.f90#L6822) | [Documented](docs/10-banded-matrices.md#topic-217-01) |
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [47944](source_parts/nswc_part_05.f90#L5763) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46163](source_parts/nswc_part_05.f90#L3982) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `BALANC` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [54733](source_parts/nswc_part_06.f90#L1902) | Not indexed |
| `BALBAK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [55429](source_parts/nswc_part_06.f90#L2598) | Not indexed |
| `BALINV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [54892](source_parts/nswc_part_06.f90#L2061) | Not indexed |
| `BANFAC` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, IFLAG` | [86575](source_parts/nswc_part_09.f90#L1642) | Not indexed |
| `BANSLV` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, B` | [86696](source_parts/nswc_part_09.f90#L1763) | Not indexed |
| `BASIZ` | `SUBROUTINE` | `DEGREE, NPTS, DIMEN, NPOLYS, ERROR` | [92402](source_parts/nswc_part_09.f90#L7469) | Not indexed |
| `BASYM` | `REAL FUNCTION` | `A, B, LAMBDA, EPS` | [14914](source_parts/nswc_part_02.f90#L4299) | Not indexed |
| `BCHFAC` | `SUBROUTINE` | `W, NB, N, DIAG, IFLAG` | [86857](source_parts/nswc_part_09.f90#L1924) | Not indexed |
| `BCHSLV` | `SUBROUTINE` | `W, NB, N, B` | [86959](source_parts/nswc_part_09.f90#L2026) | Not indexed |
| `BCHSV1` | `SUBROUTINE` | `W, NB, N, B, KB, M` | [89424](source_parts/nswc_part_09.f90#L4491) | Not indexed |
| `BCORR` | `REAL FUNCTION` | `A0, B0` | [11787](source_parts/nswc_part_02.f90#L1172) | Not indexed |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45816](source_parts/nswc_part_05.f90#L3635) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [45935](source_parts/nswc_part_05.f90#L3754) | [Documented](docs/10-banded-matrices.md#topic-202-01) |
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45797](source_parts/nswc_part_05.f90#L3616) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BDYADD` | `SUBROUTINE` | `KK, I1, I2, IADJ, IEND` | [89883](source_parts/nswc_part_09.f90#L4950) | Not indexed |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [17992](source_parts/nswc_part_02.f90#L7377) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [16223](source_parts/nswc_part_02.f90#L5608) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [11645](source_parts/nswc_part_02.f90#L1030) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [87009](source_parts/nswc_part_09.f90#L2076) | [Documented](docs/18-curve-fitting.md#topic-376-01) |
| `BFIT0` | `SUBROUTINE` | `NDATA, XDATA, YDATA, NORD, NBKPT, BKPT, NCONST, XCONST, YCONST, NDERIV, MODE, COEFF, RNORM, BF, G, MDG, W, MDW, WORK, IWORK` | [87201](source_parts/nswc_part_09.f90#L2268) | Not indexed |
| `BFRAC` | `REAL FUNCTION` | `A, B, X, Y, LAMBDA, EPS` | [14368](source_parts/nswc_part_02.f90#L3753) | Not indexed |
| `BGRAT` | `SUBROUTINE` | `A, B, X, Y, W, EPS, IERR` | [14720](source_parts/nswc_part_02.f90#L4105) | Not indexed |
| `BI` | `REAL FUNCTION` | `X` | [21244](source_parts/nswc_part_03.f90#L128) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BIA` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [20325](source_parts/nswc_part_02.f90#L9710) | Not indexed |
| `BIE` | `REAL FUNCTION` | `X` | [21428](source_parts/nswc_part_03.f90#L312) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BII` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [20253](source_parts/nswc_part_02.f90#L9638) | Not indexed |
| `BIM` | `SUBROUTINE` | `Z, CN, W` | [20661](source_parts/nswc_part_02.f90#L10046) | Not indexed |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [45885](source_parts/nswc_part_05.f90#L3704) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BJM` | `SUBROUTINE` | `Z, CN, W` | [20813](source_parts/nswc_part_02.f90#L10198) | Not indexed |
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [51424](source_parts/nswc_part_05.f90#L9243) | [Documented](docs/11-sparse-matrices.md#topic-245-01) |
| `BLKTR1` | `SUBROUTINE` | `N, AN, BN, CN, M, AM, BM, CM, IDIMY, Y, B, W1, W2, W3, WD, WW, WU, PRDCT, CPRDCT` | [107765](source_parts/nswc_part_11.f90#L1729) | Not indexed |
| `BLKTRI` | `SUBROUTINE` | `IFLG, NP, N, AN, BN, CN, MP, M, AM, BM, CM, IDIMY, Y, IERROR, W` | [107589](source_parts/nswc_part_11.f90#L1553) | Not indexed |
| `BLND` | `REAL FUNCTION` | `A, B` | [15256](source_parts/nswc_part_02.f90#L4641) | Not indexed |
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [69425](source_parts/nswc_part_07.f90#L6064) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-302-01) |
| `BNDACC` | `SUBROUTINE` | `G, MDG, NB, IP, IR, MT, JT` | [87468](source_parts/nswc_part_09.f90#L2535) | Not indexed |
| `BNDSL` | `SUBROUTINE` | `MODE, G, MDG, NB, IP, IR, X, N, RNORM, IERR` | [87659](source_parts/nswc_part_09.f90#L2726) | Not indexed |
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [47922](source_parts/nswc_part_05.f90#L5741) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [46010](source_parts/nswc_part_05.f90#L3829) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [46975](source_parts/nswc_part_05.f90#L4794) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `BPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [14195](source_parts/nswc_part_02.f90#L3580) | Not indexed |
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [13873](source_parts/nswc_part_02.f90#L3258) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BRCMP1` | `REAL FUNCTION` | `MU, A, B, X, Y` | [14574](source_parts/nswc_part_02.f90#L3959) | Not indexed |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [14433](source_parts/nswc_part_02.f90#L3818) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [45835](source_parts/nswc_part_05.f90#L3654) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [101663](source_parts/nswc_part_10.f90#L6220) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-418-01) |
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [86757](source_parts/nswc_part_09.f90#L1824) | [Documented](docs/18-curve-fitting.md#topic-375-01) |
| `BSLSQ1` | `SUBROUTINE` | `TAU, WGT, NTAU, Z, KZ, M, T, N, K, A, KA, WK, Q, IERR` | [89305](source_parts/nswc_part_09.f90#L4372) | Not indexed |
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [89237](source_parts/nswc_part_09.f90#L4304) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-389-01) |
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48079](source_parts/nswc_part_05.f90#L5898) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48160](source_parts/nswc_part_05.f90#L5979) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [86070](source_parts/nswc_part_09.f90#L1137) | [Documented](docs/18-curve-fitting.md#topic-371-01) |
| `BSPVB` | `SUBROUTINE` | `T, K, JHIGH, J, X, LEFT, BLIST` | [86240](source_parts/nswc_part_09.f90#L1307) | Not indexed |
| `BSPVD` | `SUBROUTINE` | `T, K, X, LEFT, DBIATX, IDIM, NDERIV, A` | [86294](source_parts/nswc_part_09.f90#L1361) | Not indexed |
| `BSRH` | `FUNCTION` | `XLL, XRR, IZ, C, A, BH, F, SGN` | [109002](source_parts/nswc_part_11.f90#L2966) | Not indexed |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [17679](source_parts/nswc_part_02.f90#L7064) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [15931](source_parts/nswc_part_02.f90#L5316) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [19592](source_parts/nswc_part_02.f90#L8977) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [17305](source_parts/nswc_part_02.f90#L6690) | [Documented](docs/04-special-functions.md#topic-081-01) |
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [86428](source_parts/nswc_part_09.f90#L1495) | [Documented](docs/18-curve-fitting.md#topic-373-01) |
| `BSTRP1` | `SUBROUTINE` | `X, Z, KZ, M, N, T, K, A, KA, WORK, IFLAG` | [89190](source_parts/nswc_part_09.f90#L4257) | Not indexed |
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [89133](source_parts/nswc_part_09.f90#L4200) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-388-01) |
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46569](source_parts/nswc_part_05.f90#L4388) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47660](source_parts/nswc_part_05.f90#L5479) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47706](source_parts/nswc_part_05.f90#L5525) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [36193](source_parts/nswc_part_04.f90#L4569) | [Documented](docs/08-matrices.md#topic-171-01) |
| `BUP` | `REAL FUNCTION` | `A, B, X, Y, N, EPS` | [14294](source_parts/nswc_part_02.f90#L3679) | Not indexed |
| `BUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, II, K1, K2, N, M, NP1` | [5121](source_parts/nswc_part_01.f90#L5121) | Not indexed |
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [85771](source_parts/nswc_part_09.f90#L838) | [Documented](docs/18-curve-fitting.md#topic-369-01) |
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [89495](source_parts/nswc_part_09.f90#L4562) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-391-01) |
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [85924](source_parts/nswc_part_09.f90#L991) | [Documented](docs/18-curve-fitting.md#topic-370-01) |
| `BVALI0` | `SUBROUTINE` | `T, TNEW, BCOEF, N, K, X, W, WK` | [85976](source_parts/nswc_part_09.f90#L1043) | Not indexed |
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47392](source_parts/nswc_part_05.f90#L5211) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47439](source_parts/nswc_part_05.f90#L5258) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [19841](source_parts/nswc_part_02.f90#L9226) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CALCSC` | `SUBROUTINE` | `TYPE, N, K, QK` | [28585](source_parts/nswc_part_03.f90#L7469) | Not indexed |
| `CALCT` | `SUBROUTINE` | `BOOL, N, SR, SI, TR, TI, PVR, PVI, ARE, HR, HI, QHR, QHI` | [29417](source_parts/nswc_part_03.f90#L8301) | Not indexed |
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [2723](source_parts/nswc_part_01.f90#L2723) | [Documented](docs/02-elementary-operations.md#topic-028-02) |
| `CAUCHY` | `SUBROUTINE` | `NN, BND, PT, Q` | [29018](source_parts/nswc_part_03.f90#L7902) | Not indexed |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [31147](source_parts/nswc_part_03.f90#L10031) | [Documented](docs/07-vectors.md#topic-138-01) |
| `CBABK2` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [59697](source_parts/nswc_part_06.f90#L6866) | Not indexed |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46433](source_parts/nswc_part_05.f90#L4252) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `CBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [59201](source_parts/nswc_part_06.f90#L6370) | Not indexed |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [27282](source_parts/nswc_part_03.f90#L6166) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `CBDB` | `SUBROUTINE` | `CZ, CNU, FN, W` | [15642](source_parts/nswc_part_02.f90#L5027) | Not indexed |
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [18569](source_parts/nswc_part_02.f90#L7954) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [49334](source_parts/nswc_part_05.f90#L7153) | Not indexed |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [20198](source_parts/nswc_part_02.f90#L9583) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CBJA` | `SUBROUTINE` | `CZ, CNU, W` | [15815](source_parts/nswc_part_02.f90#L5200) | Not indexed |
| `CBJM` | `SUBROUTINE` | `Z, CNU, W` | [15537](source_parts/nswc_part_02.f90#L4922) | Not indexed |
| `CBKA` | `SUBROUTINE` | `Z, CNU, W` | [18718](source_parts/nswc_part_02.f90#L8103) | Not indexed |
| `CBKI` | `SUBROUTINE` | `Z, CNU, W` | [18677](source_parts/nswc_part_02.f90#L8062) | Not indexed |
| `CBKM` | `SUBROUTINE` | `Z, RZ, CNU, W` | [18782](source_parts/nswc_part_02.f90#L8167) | Not indexed |
| `CBKML` | `SUBROUTINE` | `Z, R, ZR, NU, N, W, W0` | [19038](source_parts/nswc_part_02.f90#L8423) | Not indexed |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [29706](source_parts/nswc_part_03.f90#L8590) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [46112](source_parts/nswc_part_05.f90#L3931) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [47253](source_parts/nswc_part_05.f90#L5072) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `CBRT` | `REAL FUNCTION` | `X` | [2420](source_parts/nswc_part_01.f90#L2420) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `CBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [49471](source_parts/nswc_part_05.f90#L7290) | Not indexed |
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [49216](source_parts/nswc_part_05.f90#L7035) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [49275](source_parts/nswc_part_05.f90#L7094) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [82385](source_parts/nswc_part_08.f90#L7992) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [17631](source_parts/nswc_part_02.f90#L7016) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [15335](source_parts/nswc_part_02.f90#L4720) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [19145](source_parts/nswc_part_02.f90#L8530) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46839](source_parts/nswc_part_05.f90#L4658) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47835](source_parts/nswc_part_05.f90#L5654) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47881](source_parts/nswc_part_05.f90#L5700) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47571](source_parts/nswc_part_05.f90#L5390) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47618](source_parts/nswc_part_05.f90#L5437) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [29948](source_parts/nswc_part_03.f90#L8832) | [Documented](docs/07-vectors.md#topic-130-01) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [41563](source_parts/nswc_part_04.f90#L9939) | [Documented](docs/08-matrices.md#topic-185-01) |
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [2599](source_parts/nswc_part_01.f90#L2599) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [2625](source_parts/nswc_part_01.f90#L2625) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [30870](source_parts/nswc_part_03.f90#L9754) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [30905](source_parts/nswc_part_03.f90#L9789) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CEEZ` | `SUBROUTINE` | `DEL1, DEL2, SIGMA, C1, C2, C3, N` | [85600](source_parts/nswc_part_09.f90#L667) | Not indexed |
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [59068](source_parts/nswc_part_06.f90#L6237) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-273-01) |
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [59121](source_parts/nswc_part_06.f90#L6290) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-274-01) |
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [5231](source_parts/nswc_part_01.f90#L5231) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [5360](source_parts/nswc_part_01.f90#L5360) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERR` | `SUBROUTINE` | `T, FT, GT, PHIT, DEL, IERR, L, LP1, M, NP1, D` | [80219](source_parts/nswc_part_08.f90#L5826) | Not indexed |
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [9071](source_parts/nswc_part_01.f90#L9071) | [Documented](docs/04-special-functions.md#topic-062-01) |
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [8056](source_parts/nswc_part_01.f90#L8056) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `CFLECT` | `COMPLEX FUNCTION` | `Z` | [21930](source_parts/nswc_part_03.f90#L814) | Not indexed |
| `CFOD` | `SUBROUTINE` | `METH, ELCO, TESCO` | [105358](source_parts/nswc_part_10.f90#L9915) | Not indexed |
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [7707](source_parts/nswc_part_01.f90#L7707) | [Documented](docs/04-special-functions.md#topic-056-01) |
| `CGAM0` | `COMPLEX FUNCTION` | `Z` | [9709](source_parts/nswc_part_01.f90#L9709) | Not indexed |
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [9494](source_parts/nswc_part_01.f90#L9494) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `CGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [39191](source_parts/nswc_part_04.f90#L7567) | Not indexed |
| `CGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [39573](source_parts/nswc_part_04.f90#L7949) | Not indexed |
| `CGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [39371](source_parts/nswc_part_04.f90#L7747) | Not indexed |
| `CGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [39459](source_parts/nswc_part_04.f90#L7835) | Not indexed |
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [79914](source_parts/nswc_part_08.f90#L5521) | [Documented](docs/17-approximation-of-functions.md#topic-327-01) |
| `CHEBY1` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, LP1, MP1, LPM, N, NP1, X, XVAL, C, D, ERR, H` | [79953](source_parts/nswc_part_08.f90#L5560) | Not indexed |
| `CHKPRM` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, C, D, N, NBDCND, COFX, COFY, IDMN, MN, IERROR` | [107165](source_parts/nswc_part_11.f90#L1129) | Not indexed |
| `CHKSNG` | `SUBROUTINE` | `MBDCND, NBDCND, ALPHA, BETA, GAMA, XNU, COFX, COFY, SINGLR` | [107219](source_parts/nswc_part_11.f90#L1183) | Not indexed |
| `CIN` | `FUNCTION` | `X` | [8971](source_parts/nswc_part_01.f90#L8971) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [24643](source_parts/nswc_part_03.f90#L3527) | [Documented](docs/04-special-functions.md#topic-107-01) |
| `CK` | `COMPLEX FUNCTION` | `K, L` | [21729](source_parts/nswc_part_03.f90#L613) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKA` | `SUBROUTINE` | `Z, NU, W` | [19288](source_parts/nswc_part_02.f90#L8673) | Not indexed |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [22058](source_parts/nswc_part_03.f90#L942) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKM` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [19352](source_parts/nswc_part_02.f90#L8737) | Not indexed |
| `CKML` | `SUBROUTINE` | `Z, R, ZR, NU, K1, K2` | [19462](source_parts/nswc_part_02.f90#L8847) | Not indexed |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [33100](source_parts/nswc_part_04.f90#L1476) | [Documented](docs/08-matrices.md#topic-160-01) |
| `CKPS` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [18909](source_parts/nswc_part_02.f90#L8294) | Not indexed |
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [61211](source_parts/nswc_part_06.f90#L8380) | [Documented](docs/13-l1-solution-of-linear-equations.md#topic-279-01) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [44709](source_parts/nswc_part_05.f90#L2528) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `CLI` | `COMPLEX FUNCTION` | `Z` | [9263](source_parts/nswc_part_01.f90#L9263) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `CLOC` | `LOGICAL FUNCTION` | `X, Y` | [32919](source_parts/nswc_part_04.f90#L1295) | Not indexed |
| `CLUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [39095](source_parts/nswc_part_04.f90#L7471) | Not indexed |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32511](source_parts/nswc_part_04.f90#L887) | [Documented](docs/08-matrices.md#topic-151-01) |
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [32439](source_parts/nswc_part_04.f90#L815) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31954](source_parts/nswc_part_04.f90#L330) | [Documented](docs/08-matrices.md#topic-147-01) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31940](source_parts/nswc_part_04.f90#L316) | [Documented](docs/08-matrices.md#topic-146-01) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [45559](source_parts/nswc_part_05.f90#L3378) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [45737](source_parts/nswc_part_05.f90#L3556) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31885](source_parts/nswc_part_04.f90#L261) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [32861](source_parts/nswc_part_04.f90#L1237) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31871](source_parts/nswc_part_04.f90#L247) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [38993](source_parts/nswc_part_04.f90#L7369) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [39029](source_parts/nswc_part_04.f90#L7405) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32575](source_parts/nswc_part_04.f90#L951) | [Documented](docs/08-matrices.md#topic-153-01) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32649](source_parts/nswc_part_04.f90#L1025) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [53792](source_parts/nswc_part_06.f90#L961) | Not indexed |
| `COMPB` | `SUBROUTINE` | `N, IERROR, AN, BN, CN, B, AH, BH` | [108561](source_parts/nswc_part_11.f90#L2525) | Not indexed |
| `COMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [59486](source_parts/nswc_part_06.f90#L6655) | Not indexed |
| `COMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [59765](source_parts/nswc_part_06.f90#L6934) | Not indexed |
| `CONEW` | `FUNCTION` | `COND, ELINSY, RELRSD, AVERR, PASTC, PASTRE` | [100284](source_parts/nswc_part_10.f90#L4841) | Not indexed |
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [2898](source_parts/nswc_part_01.f90#L2898) | [Documented](docs/02-elementary-operations.md#topic-031-01) |
| `CORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [59372](source_parts/nswc_part_06.f90#L6541) | Not indexed |
| `COS0` | `REAL FUNCTION` | `X` | [2995](source_parts/nswc_part_01.f90#L2995) | Not indexed |
| `COS1` | `REAL FUNCTION` | `X` | [3072](source_parts/nswc_part_01.f90#L3072) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [78465](source_parts/nswc_part_08.f90#L4072) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQB1` | `SUBROUTINE` | `N, X, W, XH` | [78486](source_parts/nswc_part_08.f90#L4093) | Not indexed |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [78382](source_parts/nswc_part_08.f90#L3989) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQF1` | `SUBROUTINE` | `N, X, W, XH` | [78401](source_parts/nswc_part_08.f90#L4008) | Not indexed |
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [78332](source_parts/nswc_part_08.f90#L3939) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COVAR` | `SUBROUTINE` | `N, M1, N1, IPIVOT, C, D, Z, NN` | [68677](source_parts/nswc_part_07.f90#L5316) | Not indexed |
| `CPABS` | `REAL FUNCTION` | `X, Y` | [2519](source_parts/nswc_part_01.f90#L2519) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [50303](source_parts/nswc_part_05.f90#L8122) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [50360](source_parts/nswc_part_05.f90#L8179) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, W, Y` | [108335](source_parts/nswc_part_11.f90#L2299) | Not indexed |
| `CPRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, U, Y` | [108437](source_parts/nswc_part_11.f90#L2401) | Not indexed |
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [81327](source_parts/nswc_part_08.f90#L6934) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `CPSI` | `SUBROUTINE` | `Z, W` | [10693](source_parts/nswc_part_02.f90#L78) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `CQEXT` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES` | [76647](source_parts/nswc_part_08.f90#L2254) | Not indexed |
| `CQZHES` | `SUBROUTINE` | `NM, N, A, B, MATS, Z, F, G, H` | [43626](source_parts/nswc_part_05.f90#L1445) | Not indexed |
| `CQZIT` | `SUBROUTINE` | `NM, N, A, B, EPS1, MATS, Z, F, IERR` | [43822](source_parts/nswc_part_05.f90#L1641) | Not indexed |
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [2557](source_parts/nswc_part_01.f90#L2557) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [33302](source_parts/nswc_part_04.f90#L1678) | [Documented](docs/08-matrices.md#topic-163-01) |
| `CROUT1` | `SUBROUTINE` | `A, KA, N, IEND, INDEX, TEMP, JP, IERR` | [74394](source_parts/nswc_part_08.f90#L1) | Not indexed |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50546](source_parts/nswc_part_05.f90#L8365) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [31013](source_parts/nswc_part_03.f90#L9897) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [50010](source_parts/nswc_part_05.f90#L7829) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [26075](source_parts/nswc_part_03.f90#L4959) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49854](source_parts/nswc_part_05.f90#L7673) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [83339](source_parts/nswc_part_08.f90#L8946) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [83428](source_parts/nswc_part_08.f90#L9035) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [83529](source_parts/nswc_part_08.f90#L9136) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [83952](source_parts/nswc_part_08.f90#L9559) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `CSLOP1` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, A, B, C, E, IERR` | [84003](source_parts/nswc_part_08.f90#L9610) | Not indexed |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [54019](source_parts/nswc_part_06.f90#L1188) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [54098](source_parts/nswc_part_06.f90#L1267) | Not indexed |
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [39063](source_parts/nswc_part_04.f90#L7439) | [Documented](docs/08-matrices.md#topic-182-01) |
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [82712](source_parts/nswc_part_08.f90#L8319) | [Documented](docs/18-curve-fitting.md#topic-345-01) |
| `CSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [54270](source_parts/nswc_part_06.f90#L1439) | Not indexed |
| `CSPP` | `SUBROUTINE` | `T, A, KA, M, N, Z, KZ, DZ, KDZ` | [87969](source_parts/nswc_part_09.f90#L3036) | Not indexed |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [50910](source_parts/nswc_part_05.f90#L8729) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [53705](source_parts/nswc_part_06.f90#L874) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49822](source_parts/nswc_part_05.f90#L7641) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [88256](source_parts/nswc_part_09.f90#L3323) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [88405](source_parts/nswc_part_09.f90#L3472) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [30258](source_parts/nswc_part_03.f90#L9142) | [Documented](docs/07-vectors.md#topic-132-01) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [31036](source_parts/nswc_part_03.f90#L9920) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50735](source_parts/nswc_part_05.f90#L8554) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [88062](source_parts/nswc_part_09.f90#L3129) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [88216](source_parts/nswc_part_09.f90#L3283) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [40930](source_parts/nswc_part_04.f90#L9306) | [Documented](docs/08-matrices.md#topic-183-01) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [30154](source_parts/nswc_part_03.f90#L9038) | [Documented](docs/07-vectors.md#topic-131-01) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [32262](source_parts/nswc_part_04.f90#L638) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31996](source_parts/nswc_part_04.f90#L372) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51222](source_parts/nswc_part_05.f90#L9041) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51250](source_parts/nswc_part_05.f90#L9069) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [32453](source_parts/nswc_part_04.f90#L829) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [54142](source_parts/nswc_part_06.f90#L1311) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [54221](source_parts/nswc_part_06.f90#L1390) | Not indexed |
| `CUBRUL` | `SUBROUTINE` | `F, VEC, P, IDATA, RDATA` | [99570](source_parts/nswc_part_10.f90#L4127) | Not indexed |
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [99355](source_parts/nswc_part_10.f90#L3912) | [Documented](docs/22-numerical-integration.md#topic-408-01) |
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [84290](source_parts/nswc_part_08.f90#L9897) | [Documented](docs/18-curve-fitting.md#topic-357-01) |
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [84436](source_parts/nswc_part_08.f90#L10043) | [Documented](docs/18-curve-fitting.md#topic-359-01) |
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [84518](source_parts/nswc_part_08.f90#L10125) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [84593](source_parts/nswc_part_08.f90#L10200) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [45249](source_parts/nswc_part_05.f90#L3068) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [45055](source_parts/nswc_part_05.f90#L2874) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [44861](source_parts/nswc_part_05.f90#L2680) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45314](source_parts/nswc_part_05.f90#L3133) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [45379](source_parts/nswc_part_05.f90#L3198) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [49662](source_parts/nswc_part_05.f90#L7481) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45120](source_parts/nswc_part_05.f90#L2939) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [45185](source_parts/nswc_part_05.f90#L3004) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [49632](source_parts/nswc_part_05.f90#L7451) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51172](source_parts/nswc_part_05.f90#L8991) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51197](source_parts/nswc_part_05.f90#L9016) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [44926](source_parts/nswc_part_05.f90#L2745) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [44991](source_parts/nswc_part_05.f90#L2810) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [49602](source_parts/nswc_part_05.f90#L7421) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [49743](source_parts/nswc_part_05.f90#L7562) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [49718](source_parts/nswc_part_05.f90#L7537) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [49693](source_parts/nswc_part_05.f90#L7512) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CXP` | `COMPLEX FUNCTION` | `N, NU` | [19553](source_parts/nswc_part_02.f90#L8938) | Not indexed |
| `CYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [32946](source_parts/nswc_part_04.f90#L1322) | Not indexed |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [42182](source_parts/nswc_part_05.f90#L1) | [Documented](docs/08-matrices.md#topic-186-01) |
| `DABSV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [42256](source_parts/nswc_part_05.f90#L75) | Not indexed |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [7079](source_parts/nswc_part_01.f90#L7079) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `DAORD` | `SUBROUTINE` | `A, N` | [1751](source_parts/nswc_part_01.f90#L1751) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [2489](source_parts/nswc_part_01.f90#L2489) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [31217](source_parts/nswc_part_03.f90#L10101) | [Documented](docs/07-vectors.md#topic-139-01) |
| `DAW` | `REAL FUNCTION` | `X` | [7360](source_parts/nswc_part_01.f90#L7360) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [31103](source_parts/nswc_part_03.f90#L9987) | [Documented](docs/07-vectors.md#topic-138-01) |
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [49109](source_parts/nswc_part_05.f90#L6928) | [Documented](docs/10-banded-matrices.md#topic-221-01) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [48022](source_parts/nswc_part_05.f90#L5841) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `DBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [56828](source_parts/nswc_part_06.f90#L3997) | Not indexed |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46298](source_parts/nswc_part_05.f90#L4117) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `DBAL` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [56297](source_parts/nswc_part_06.f90#L3466) | Not indexed |
| `DBALNV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [56456](source_parts/nswc_part_06.f90#L3625) | Not indexed |
| `DBCORR` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [12024](source_parts/nswc_part_02.f90#L1409) | Not indexed |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [11880](source_parts/nswc_part_02.f90#L1265) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `DBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [48703](source_parts/nswc_part_05.f90#L6522) | Not indexed |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [48000](source_parts/nswc_part_05.f90#L5819) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [46061](source_parts/nswc_part_05.f90#L3880) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [47114](source_parts/nswc_part_05.f90#L4933) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `DBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [48872](source_parts/nswc_part_05.f90#L6691) | Not indexed |
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48541](source_parts/nswc_part_05.f90#L6360) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48622](source_parts/nswc_part_05.f90#L6441) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46704](source_parts/nswc_part_05.f90#L4523) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47747](source_parts/nswc_part_05.f90#L5566) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47794](source_parts/nswc_part_05.f90#L5613) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47481](source_parts/nswc_part_05.f90#L5300) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47529](source_parts/nswc_part_05.f90#L5348) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DCBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [60773](source_parts/nswc_part_06.f90#L7942) | Not indexed |
| `DCBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [60263](source_parts/nswc_part_06.f90#L7432) | Not indexed |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [27468](source_parts/nswc_part_03.f90#L6352) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [2439](source_parts/nswc_part_01.f90#L2439) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [60127](source_parts/nswc_part_06.f90#L7296) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-276-01) |
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [60181](source_parts/nswc_part_06.f90#L7350) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-277-01) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [5723](source_parts/nswc_part_01.f90#L5723) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [6002](source_parts/nswc_part_01.f90#L6002) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCFACT` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, IERR` | [39712](source_parts/nswc_part_04.f90#L8088) | Not indexed |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [10079](source_parts/nswc_part_01.f90#L10079) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DCMINV` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, TEMP` | [39898](source_parts/nswc_part_04.f90#L8274) | Not indexed |
| `DCMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [60841](source_parts/nswc_part_06.f90#L8010) | Not indexed |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [39684](source_parts/nswc_part_04.f90#L8060) | [Documented](docs/08-matrices.md#topic-178-01) |
| `DCOMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [60554](source_parts/nswc_part_06.f90#L7723) | Not indexed |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [29903](source_parts/nswc_part_03.f90#L8787) | [Documented](docs/07-vectors.md#topic-130-01) |
| `DCORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [60433](source_parts/nswc_part_06.f90#L7602) | Not indexed |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [3215](source_parts/nswc_part_01.f90#L3215) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [2538](source_parts/nswc_part_01.f90#L2538) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `DCPLY1` | `SUBROUTINE` | `OPR, OPI, IDEG, IDP1, ZEROR, ZEROI, PR, PI, QPR, QPI, HR, HI, QHR, QHI, SHR, SHI, NUM` | [28840](source_parts/nswc_part_03.f90#L7724) | Not indexed |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [28789](source_parts/nswc_part_03.f90#L7673) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [81557](source_parts/nswc_part_08.f90#L7164) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [10987](source_parts/nswc_part_02.f90#L372) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [2578](source_parts/nswc_part_01.f90#L2578) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [26102](source_parts/nswc_part_03.f90#L4986) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `DCSOL` | `SUBROUTINE` | `N, M, AR, AI, KA, BR, BI, KB, IPVT` | [39810](source_parts/nswc_part_04.f90#L8186) | Not indexed |
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [2662](source_parts/nswc_part_01.f90#L2662) | [Documented](docs/02-elementary-operations.md#topic-026-03) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [30826](source_parts/nswc_part_03.f90#L9710) | [Documented](docs/07-vectors.md#topic-136-01) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [1660](source_parts/nswc_part_01.f90#L1660) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DE1` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YY, WT, P, YP, YPOUT, PHI, ALPHA, BETA, SIG, V, W, G, PHASE1, PSI, X, H, HOLD, START, TOLD, DELSGN, NS, NORND, K, KOLD, ISNOLD` | [100986](source_parts/nswc_part_10.f90#L5543) | Not indexed |
| `DE1E` | `DOUBLE PRECISION FUNCTION` | `X` | [8549](source_parts/nswc_part_01.f90#L8549) | Not indexed |
| `DEC` | `SUBROUTINE` | `N, NDIM, A, IP, IER` | [33673](source_parts/nswc_part_04.f90#L2049) | Not indexed |
| `DECBT` | `SUBROUTINE` | `M, N, A, B, C, IP, IER` | [36208](source_parts/nswc_part_04.f90#L4584) | Not indexed |
| `DECOM2` | `SUBROUTINE` | `M, N, M1, ETA, TOL, QR, D, N1, IPIVOT, SING, MMPNN` | [68235](source_parts/nswc_part_07.f90#L4874) | Not indexed |
| `DEFER` | `SUBROUTINE` | `COFX, COFY, USOL, IDMN, GRHS, MN` | [107391](source_parts/nswc_part_11.f90#L1355) | Not indexed |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [8514](source_parts/nswc_part_01.f90#L8514) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEI0` | `DOUBLE PRECISION FUNCTION` | `X, EPS` | [8804](source_parts/nswc_part_01.f90#L8804) | Not indexed |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [8531](source_parts/nswc_part_01.f90#L8531) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [56156](source_parts/nswc_part_06.f90#L3325) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-266-01) |
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [56205](source_parts/nswc_part_06.f90#L3374) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-267-01) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [22622](source_parts/nswc_part_03.f90#L1506) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [22838](source_parts/nswc_part_03.f90#L1722) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [1187](source_parts/nswc_part_01.f90#L1187) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [6399](source_parts/nswc_part_01.f90#L6399) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [6445](source_parts/nswc_part_01.f90#L6445) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC0` | `DOUBLE PRECISION FUNCTION` | `X` | [6571](source_parts/nswc_part_01.f90#L6571) | Not indexed |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [6502](source_parts/nswc_part_01.f90#L6502) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [6811](source_parts/nswc_part_01.f90#L6811) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `DESUM` | `DOUBLE PRECISION FUNCTION` | `MU, X` | [3407](source_parts/nswc_part_01.f90#L3407) | Not indexed |
| `DET` | `FUNCTION` | `A, KA, N, X` | [41438](source_parts/nswc_part_04.f90#L9814) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [111017](source_parts/nswc_part_11.f90#L4981) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `DGAM1` | `DOUBLE PRECISION FUNCTION` | `X` | [10465](source_parts/nswc_part_01.f90#L10465) | Not indexed |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [10616](source_parts/nswc_part_02.f90#L1) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [10320](source_parts/nswc_part_01.f90#L10320) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [34800](source_parts/nswc_part_04.f90#L3176) | Not indexed |
| `DGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [35222](source_parts/nswc_part_04.f90#L3598) | Not indexed |
| `DGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [35005](source_parts/nswc_part_04.f90#L3381) | Not indexed |
| `DGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [35109](source_parts/nswc_part_04.f90#L3485) | Not indexed |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [13540](source_parts/nswc_part_02.f90#L2925) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `DGMLN1` | `DOUBLE PRECISION FUNCTION` | `X` | [10668](source_parts/nswc_part_02.f90#L53) | Not indexed |
| `DGNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [93302](source_parts/nswc_part_09.f90#L8369) | Not indexed |
| `DGR17` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [13438](source_parts/nswc_part_02.f90#L2823) | Not indexed |
| `DGR29` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [13237](source_parts/nswc_part_02.f90#L2622) | Not indexed |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [12965](source_parts/nswc_part_02.f90#L2350) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DGSMLN` | `DOUBLE PRECISION FUNCTION` | `A, B` | [11993](source_parts/nswc_part_02.f90#L1378) | Not indexed |
| `DH12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [65592](source_parts/nswc_part_07.f90#L2231) | Not indexed |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [65095](source_parts/nswc_part_07.f90#L1734) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [65332](source_parts/nswc_part_07.f90#L1971) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [56612](source_parts/nswc_part_06.f90#L3781) | Not indexed |
| `DHQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [57030](source_parts/nswc_part_06.f90#L4199) | Not indexed |
| `DINCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [93377](source_parts/nswc_part_09.f90#L8444) | Not indexed |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [1612](source_parts/nswc_part_01.f90#L1612) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [33074](source_parts/nswc_part_04.f90#L1450) | [Documented](docs/08-matrices.md#topic-160-01) |
| `DLGDIV` | `DOUBLE PRECISION FUNCTION` | `A, B` | [12077](source_parts/nswc_part_02.f90#L1462) | Not indexed |
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [62090](source_parts/nswc_part_06.f90#L9259) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [3629](source_parts/nswc_part_01.f90#L3629) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DLOC` | `LOGICAL FUNCTION` | `X, Y` | [32825](source_parts/nswc_part_04.f90#L1201) | Not indexed |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [63362](source_parts/nswc_part_07.f90#L1) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32494](source_parts/nswc_part_04.f90#L870) | [Documented](docs/08-matrices.md#topic-151-01) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31926](source_parts/nswc_part_04.f90#L302) | [Documented](docs/08-matrices.md#topic-146-01) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [45501](source_parts/nswc_part_05.f90#L3320) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [31757](source_parts/nswc_part_04.f90#L133) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [45677](source_parts/nswc_part_05.f90#L3496) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [31801](source_parts/nswc_part_04.f90#L177) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [93614](source_parts/nswc_part_09.f90#L8681) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMEVL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [93772](source_parts/nswc_part_09.f90#L8839) | Not indexed |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [44285](source_parts/nswc_part_05.f90#L2104) | [Documented](docs/08-matrices.md#topic-191-01) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [93151](source_parts/nswc_part_09.f90#L8218) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [32766](source_parts/nswc_part_04.f90#L1142) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [34731](source_parts/nswc_part_04.f90#L3107) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [34767](source_parts/nswc_part_04.f90#L3143) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32558](source_parts/nswc_part_04.f90#L934) | [Documented](docs/08-matrices.md#topic-153-01) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32627](source_parts/nswc_part_04.f90#L1003) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [31390](source_parts/nswc_part_03.f90#L10274) | [Documented](docs/07-vectors.md#topic-140-01) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [109975](source_parts/nswc_part_11.f90#L3939) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [110236](source_parts/nswc_part_11.f90#L4200) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [110362](source_parts/nswc_part_11.f90#L4326) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [52608](source_parts/nswc_part_05.f90#L10427) | Not indexed |
| `DOGLEG` | `SUBROUTINE` | `N, R, LR, DIAG, QTB, DELTA, X, WA1, WA2` | [71440](source_parts/nswc_part_07.f90#L8079) | Not indexed |
| `DONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [53542](source_parts/nswc_part_06.f90#L711) | Not indexed |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [2365](source_parts/nswc_part_01.f90#L2365) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [62254](source_parts/nswc_part_06.f90#L9423) | Not indexed |
| `DORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [56521](source_parts/nswc_part_06.f90#L3690) | Not indexed |
| `DORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [62144](source_parts/nswc_part_06.f90#L9313) | Not indexed |
| `DORTRN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [56888](source_parts/nswc_part_06.f90#L4057) | Not indexed |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25551](source_parts/nswc_part_03.f90#L4435) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [38545](source_parts/nswc_part_04.f90#L6921) | [Documented](docs/08-matrices.md#topic-176-01) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [25502](source_parts/nswc_part_03.f90#L4386) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [7459](source_parts/nswc_part_01.f90#L7459) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DPDAW0` | `DOUBLE PRECISION FUNCTION` | `X` | [7532](source_parts/nswc_part_01.f90#L7532) | Not indexed |
| `DPDEL` | `DOUBLE PRECISION FUNCTION` | `X` | [10434](source_parts/nswc_part_01.f90#L10434) | Not indexed |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [41501](source_parts/nswc_part_04.f90#L9877) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [25752](source_parts/nswc_part_03.f90#L4636) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [25961](source_parts/nswc_part_03.f90#L4845) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [44568](source_parts/nswc_part_05.f90#L2387) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [25854](source_parts/nswc_part_03.f90#L4738) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [1102](source_parts/nswc_part_01.f90#L1102) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25660](source_parts/nswc_part_03.f90#L4544) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [7303](source_parts/nswc_part_01.f90#L7303) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [50186](source_parts/nswc_part_05.f90#L8005) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [50243](source_parts/nswc_part_05.f90#L8062) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [38725](source_parts/nswc_part_04.f90#L7101) | Not indexed |
| `DPPFA` | `SUBROUTINE` | `AP, N, INFO` | [38569](source_parts/nswc_part_04.f90#L6945) | Not indexed |
| `DPPSL` | `SUBROUTINE` | `AP, N, B` | [38652](source_parts/nswc_part_04.f90#L7028) | Not indexed |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [11147](source_parts/nswc_part_02.f90#L532) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DPSI0` | `DOUBLE PRECISION FUNCTION` | `X` | [11305](source_parts/nswc_part_02.f90#L690) | Not indexed |
| `DPSLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [33930](source_parts/nswc_part_04.f90#L2306) | Not indexed |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25597](source_parts/nswc_part_03.f90#L4481) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [97459](source_parts/nswc_part_10.f90#L2016) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `DQAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [97625](source_parts/nswc_part_10.f90#L2182) | Not indexed |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [96748](source_parts/nswc_part_10.f90#L1305) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [96907](source_parts/nswc_part_10.f90#L1464) | Not indexed |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [27223](source_parts/nswc_part_03.f90#L6107) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [98310](source_parts/nswc_part_10.f90#L2867) | Not indexed |
| `DQK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [98041](source_parts/nswc_part_10.f90#L2598) | Not indexed |
| `DQK21` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [97312](source_parts/nswc_part_10.f90#L1869) | Not indexed |
| `DQPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [98196](source_parts/nswc_part_10.f90#L2753) | Not indexed |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [27822](source_parts/nswc_part_03.f90#L6706) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQXCPY` | `SUBROUTINE` | `A, B, L` | [99001](source_parts/nswc_part_10.f90#L3558) | Not indexed |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [98468](source_parts/nswc_part_10.f90#L3025) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [98624](source_parts/nswc_part_10.f90#L3181) | Not indexed |
| `DQXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [99015](source_parts/nswc_part_10.f90#L3572) | Not indexed |
| `DQXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [99269](source_parts/nswc_part_10.f90#L3826) | Not indexed |
| `DQXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [99111](source_parts/nswc_part_10.f90#L3668) | Not indexed |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [110823](source_parts/nswc_part_11.f90#L4787) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [109728](source_parts/nswc_part_11.f90#L3692) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `DRCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [109753](source_parts/nswc_part_11.f90#L3717) | Not indexed |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [12582](source_parts/nswc_part_02.f90#L1967) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DRCVL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [23686](source_parts/nswc_part_03.f90#L2570) | Not indexed |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [23221](source_parts/nswc_part_03.f90#L2105) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [3460](source_parts/nswc_part_01.f90#L3460) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `DREXP1` | `SUBROUTINE` | `X, E, W` | [3544](source_parts/nswc_part_01.f90#L3544) | Not indexed |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [23014](source_parts/nswc_part_03.f90#L1898) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [110668](source_parts/nswc_part_11.f90#L4632) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [23463](source_parts/nswc_part_03.f90#L2347) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [3767](source_parts/nswc_part_01.f90#L3767) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [3832](source_parts/nswc_part_01.f90#L3832) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [111424](source_parts/nswc_part_11.f90#L5388) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [110530](source_parts/nswc_part_11.f90#L4494) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [33213](source_parts/nswc_part_04.f90#L1589) | [Documented](docs/08-matrices.md#topic-161-01) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [109882](source_parts/nswc_part_11.f90#L3846) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [30223](source_parts/nswc_part_03.f90#L9107) | [Documented](docs/07-vectors.md#topic-132-01) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [2809](source_parts/nswc_part_01.f90#L2809) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [30672](source_parts/nswc_part_03.f90#L9556) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [30536](source_parts/nswc_part_03.f90#L9420) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DRPLY1` | `SUBROUTINE` | `OP, IDEG, IDP1, ZEROR, ZEROI, P, QP, K, QK, SVK, TEMP, PT, NUM` | [28032](source_parts/nswc_part_03.f90#L6916) | Not indexed |
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [27984](source_parts/nswc_part_03.f90#L6868) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DRTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [56957](source_parts/nswc_part_06.f90#L4126) | Not indexed |
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [53322](source_parts/nswc_part_06.f90#L491) | [Documented](docs/11-sparse-matrices.md#topic-256-01) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [51356](source_parts/nswc_part_05.f90#L9175) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50483](source_parts/nswc_part_05.f90#L8302) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [30976](source_parts/nswc_part_03.f90#L9860) | [Documented](docs/07-vectors.md#topic-137-01) |
| `DSCALD` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [93591](source_parts/nswc_part_09.f90#L8658) | Not indexed |
| `DSCALP` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [93559](source_parts/nswc_part_09.f90#L8626) | Not indexed |
| `DSCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [42360](source_parts/nswc_part_05.f90#L179) | Not indexed |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49980](source_parts/nswc_part_05.f90#L7799) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [58422](source_parts/nswc_part_06.f90#L5591) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-271-01) |
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [58444](source_parts/nswc_part_06.f90#L5613) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-272-01) |
| `DSHSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [42616](source_parts/nswc_part_05.f90#L435) | Not indexed |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [3130](source_parts/nswc_part_01.f90#L3130) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [52832](source_parts/nswc_part_06.f90#L1) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [52911](source_parts/nswc_part_06.f90#L80) | Not indexed |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [37329](source_parts/nswc_part_04.f90#L5705) | [Documented](docs/08-matrices.md#topic-173-01) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [51330](source_parts/nswc_part_05.f90#L9149) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `DSORT` | `SUBROUTINE` | `A, N` | [1569](source_parts/nswc_part_01.f90#L1569) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [37363](source_parts/nswc_part_04.f90#L5739) | Not indexed |
| `DSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [38054](source_parts/nswc_part_04.f90#L6430) | Not indexed |
| `DSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [37656](source_parts/nswc_part_04.f90#L6032) | Not indexed |
| `DSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [53083](source_parts/nswc_part_06.f90#L252) | Not indexed |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [50854](source_parts/nswc_part_05.f90#L8673) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `DSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [37899](source_parts/nswc_part_04.f90#L6275) | Not indexed |
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [52518](source_parts/nswc_part_05.f90#L10337) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50672](source_parts/nswc_part_05.f90#L8491) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `DSTOR2` | `SUBROUTINE` | `A, B` | [1036](source_parts/nswc_part_01.f90#L1036) | Not indexed |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [40459](source_parts/nswc_part_04.f90#L8835) | [Documented](docs/08-matrices.md#topic-183-01) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [32983](source_parts/nswc_part_04.f90#L1359) | [Documented](docs/08-matrices.md#topic-157-01) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [30103](source_parts/nswc_part_03.f90#L8987) | [Documented](docs/07-vectors.md#topic-131-01) |
| `DSYMSV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [43184](source_parts/nswc_part_05.f90#L1003) | Not indexed |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [43032](source_parts/nswc_part_05.f90#L851) | [Documented](docs/08-matrices.md#topic-188-01) |
| `DTASV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [43089](source_parts/nswc_part_05.f90#L908) | Not indexed |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [32136](source_parts/nswc_part_04.f90#L512) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [38912](source_parts/nswc_part_04.f90#L7288) | [Documented](docs/08-matrices.md#topic-177-01) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31982](source_parts/nswc_part_04.f90#L358) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51119](source_parts/nswc_part_05.f90#L8938) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51147](source_parts/nswc_part_05.f90#L8966) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTQL` | `SUBROUTINE` | `N, D, E2, IERR` | [58673](source_parts/nswc_part_06.f90#L5842) | Not indexed |
| `DTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [58913](source_parts/nswc_part_06.f90#L6082) | Not indexed |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [111224](source_parts/nswc_part_11.f90#L5188) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `DTRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [58479](source_parts/nswc_part_06.f90#L5648) | Not indexed |
| `DTRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [58795](source_parts/nswc_part_06.f90#L5964) | Not indexed |
| `DTRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [58578](source_parts/nswc_part_06.f90#L5747) | Not indexed |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [52955](source_parts/nswc_part_06.f90#L124) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [53034](source_parts/nswc_part_06.f90#L203) | Not indexed |
| `DU11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [63652](source_parts/nswc_part_07.f90#L291) | Not indexed |
| `DU11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [64085](source_parts/nswc_part_07.f90#L724) | Not indexed |
| `DU12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [63933](source_parts/nswc_part_07.f90#L572) | Not indexed |
| `DU12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [64366](source_parts/nswc_part_07.f90#L1005) | Not indexed |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [109217](source_parts/nswc_part_11.f90#L3181) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `DURNG0` | `SUBROUTINE` | `IX, U, V` | [109334](source_parts/nswc_part_11.f90#L3298) | Not indexed |
| `DURNG1` | `SUBROUTINE` | `IX, U, V, D` | [109448](source_parts/nswc_part_11.f90#L3412) | Not indexed |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [109568](source_parts/nswc_part_11.f90#L3532) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51069](source_parts/nswc_part_05.f90#L8888) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51094](source_parts/nswc_part_05.f90#L8913) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DXFN` | `SUBROUTINE` | `U, IDMN, I, J, UXXX, UXXXX` | [107448](source_parts/nswc_part_11.f90#L1412) | Not indexed |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [1259](source_parts/nswc_part_01.f90#L1259) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [32852](source_parts/nswc_part_04.f90#L1228) | Not indexed |
| `DYFN` | `SUBROUTINE` | `U, IDMN, I, J, UYYY, UYYYY` | [107518](source_parts/nswc_part_11.f90#L1482) | Not indexed |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [26606](source_parts/nswc_part_03.f90#L5490) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [54453](source_parts/nswc_part_06.f90#L1622) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [54502](source_parts/nswc_part_06.f90#L1671) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [54551](source_parts/nswc_part_06.f90#L1720) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [54642](source_parts/nswc_part_06.f90#L1811) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EKL` | `SUBROUTINE` | `L, FK, FL, EK, EL, GK, GL` | [22388](source_parts/nswc_part_03.f90#L1272) | Not indexed |
| `EKM` | `SUBROUTINE` | `K2, FK, EK` | [22346](source_parts/nswc_part_03.f90#L1230) | Not indexed |
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [23769](source_parts/nswc_part_03.f90#L2653) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [22483](source_parts/nswc_part_03.f90#L1367) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `ELMHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [54957](source_parts/nswc_part_06.f90#L2126) | Not indexed |
| `ELMHS0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [55040](source_parts/nswc_part_06.f90#L2209) | Not indexed |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [24134](source_parts/nswc_part_03.f90#L3018) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [55489](source_parts/nswc_part_06.f90#L2658) | Not indexed |
| `ELTRN0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [55551](source_parts/nswc_part_06.f90#L2720) | Not indexed |
| `ENORM` | `REAL FUNCTION` | `N, X` | [71353](source_parts/nswc_part_07.f90#L7992) | Not indexed |
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [22760](source_parts/nswc_part_03.f90#L1644) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `EPSLN` | `REAL FUNCTION` | `L` | [1155](source_parts/nswc_part_01.f90#L1155) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `ERF` | `REAL FUNCTION` | `X` | [5521](source_parts/nswc_part_01.f90#L5521) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC` | `REAL FUNCTION` | `X` | [5572](source_parts/nswc_part_01.f90#L5572) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC0` | `SUBROUTINE` | `IND, X, E, Y` | [24913](source_parts/nswc_part_03.f90#L3797) | Not indexed |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [5643](source_parts/nswc_part_01.f90#L5643) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFCM2` | `SUBROUTINE` | `MO, Z, W` | [6289](source_parts/nswc_part_01.f90#L6289) | Not indexed |
| `ERFCR` | `REAL FUNCTION` | `X` | [24993](source_parts/nswc_part_03.f90#L3877) | Not indexed |
| `ERFI` | `REAL FUNCTION` | `P, Q` | [6712](source_parts/nswc_part_01.f90#L6712) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `ERREV` | `DOUBLE PRECISION FUNCTION` | `NN, QR, QI, MS, MP, ARE, MRE` | [29525](source_parts/nswc_part_03.f90#L8409) | Not indexed |
| `ERRINT` | `DOUBLE PRECISION FUNCTION` | `F, FIT, AAA, BBB, POINTS, WEIGHT` | [80843](source_parts/nswc_part_08.f90#L6450) | Not indexed |
| `ESUM` | `REAL FUNCTION` | `MU, X` | [3383](source_parts/nswc_part_01.f90#L3383) | Not indexed |
| `EXPARG` | `REAL FUNCTION` | `L` | [1220](source_parts/nswc_part_01.f90#L1220) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [8229](source_parts/nswc_part_01.f90#L8229) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `EXTRA` | `SUBROUTINE` | `NEQN, YINC2, F2, T, H, YINC1, Y, F1, F, TEX, YEX, YPEX` | [102439](source_parts/nswc_part_10.f90#L6996) | Not indexed |
| `FDJAC1` | `SUBROUTINE` | `FCN, N, X, FVEC, FJAC, LDFJAC, IFLAG, ML, MU, EPSFCN, WA1, WA2` | [71590](source_parts/nswc_part_07.f90#L8229) | Not indexed |
| `FDJAC2` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FJAC, LDFJAC, IFLAG, EPSFCN, WA` | [71722](source_parts/nswc_part_07.f90#L8361) | Not indexed |
| `FEHL` | `SUBROUTINE` | `F, NEQN, Y, T, H, YP, F1, F2, F3, F4, F5, S` | [102917](source_parts/nswc_part_10.f90#L7474) | Not indexed |
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [77621](source_parts/nswc_part_08.f90#L3228) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [77638](source_parts/nswc_part_08.f90#L3245) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [69746](source_parts/nswc_part_07.f90#L6385) | [Documented](docs/15-optimization.md#topic-306-01) |
| `FPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [14120](source_parts/nswc_part_02.f90#L3505) | Not indexed |
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [110912](source_parts/nswc_part_11.f90#L4876) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `FRNL` | `SUBROUTINE` | `T, C, S` | [7863](source_parts/nswc_part_01.f90#L7863) | [Documented](docs/04-special-functions.md#topic-057-01) |
| `FSTOCD` | `SUBROUTINE` | `N, X, FCN, TYPSIZ, R, G` | [70486](source_parts/nswc_part_07.f90#L7125) | Not indexed |
| `FSTOFD` | `SUBROUTINE` | `N, X, FCN, FX, G, TYPSIZ, R` | [70450](source_parts/nswc_part_07.f90#L7089) | Not indexed |
| `FUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, I1, K1, N, M, NP1` | [5094](source_parts/nswc_part_01.f90#L5094) | Not indexed |
| `FXDEC` | `SUBROUTINE` | `FCN, N, X, FX, R` | [70328](source_parts/nswc_part_07.f90#L6967) | Not indexed |
| `FXSHFR` | `SUBROUTINE` | `L2, NZ, NN, P, QP, K, QK, SVK` | [28278](source_parts/nswc_part_03.f90#L7162) | Not indexed |
| `FXSHFT` | `SUBROUTINE` | `L2, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SHR, SHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [29125](source_parts/nswc_part_03.f90#L8009) | Not indexed |
| `GAM1` | `REAL FUNCTION` | `A` | [9932](source_parts/nswc_part_01.f90#L9932) | Not indexed |
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [12634](source_parts/nswc_part_02.f90#L2019) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `GAMLN` | `REAL FUNCTION` | `A` | [9981](source_parts/nswc_part_01.f90#L9981) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GAMLN1` | `REAL FUNCTION` | `A` | [10034](source_parts/nswc_part_01.f90#L10034) | Not indexed |
| `GAMMA` | `REAL FUNCTION` | `A` | [9740](source_parts/nswc_part_01.f90#L9740) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [102981](source_parts/nswc_part_10.f90#L7538) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-424-01) |
| `GERKS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, YP, H, F1, F2, F3, F4, F5, YG, YGP, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [103169](source_parts/nswc_part_10.f90#L7726) | Not indexed |
| `GETNP` | `SUBROUTINE` | `X, Y, IADJ, IEND, L, NPTS, DS, IER` | [91378](source_parts/nswc_part_09.f90#L6445) | Not indexed |
| `GLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [9871](source_parts/nswc_part_01.f90#L9871) | Not indexed |
| `GNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [92610](source_parts/nswc_part_09.f90#L7677) | Not indexed |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [90750](source_parts/nswc_part_09.f90#L5817) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADG1` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, EPS, NIT, ZXZY, IER` | [90792](source_parts/nswc_part_09.f90#L5859) | Not indexed |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [90970](source_parts/nswc_part_09.f90#L6037) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADL1` | `SUBROUTINE` | `N, K, X, Y, Z, IADJ, IEND, DX, DY, IER` | [91012](source_parts/nswc_part_09.f90#L6079) | Not indexed |
| `GRAT1` | `SUBROUTINE` | `A, X, R, P, Q, EPS` | [14815](source_parts/nswc_part_02.f90#L4200) | Not indexed |
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [12141](source_parts/nswc_part_02.f90#L1526) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `GSUMLN` | `REAL FUNCTION` | `A, B` | [11756](source_parts/nswc_part_02.f90#L1141) | Not indexed |
| `H12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [65010](source_parts/nswc_part_07.f90#L1649) | Not indexed |
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [26705](source_parts/nswc_part_03.f90#L5589) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-124-01) |
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [4504](source_parts/nswc_part_01.f90#L4504) | [Documented](docs/03-geometry.md#topic-043-01) |
| `HC1` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, NP1, PC, AC, VR, VC, P, SUBR, RBUS, TOR, JR, K, IND0` | [4623](source_parts/nswc_part_01.f90#L4623) | Not indexed |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [64517](source_parts/nswc_part_07.f90#L1156) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [64751](source_parts/nswc_part_07.f90#L1390) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [55214](source_parts/nswc_part_06.f90#L2383) | Not indexed |
| `HQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [55755](source_parts/nswc_part_06.f90#L2924) | Not indexed |
| `HSTART` | `SUBROUTINE` | `F, NEQ, A, B, Y, YPRIME, ETOL, MORDER, SMALL, BIG, SPY, PV, YP, SF, RPAR, IPAR, H` | [104523](source_parts/nswc_part_10.f90#L9080) | Not indexed |
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [82006](source_parts/nswc_part_08.f90#L7613) | [Documented](docs/18-curve-fitting.md#topic-338-01) |
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [4115](source_parts/nswc_part_01.f90#L4115) | [Documented](docs/03-geometry.md#topic-041-01) |
| `HYBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, XTOL, MAXFEV, ML, MU, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, R, LR, QTF, WA1, WA2, WA3, WA4` | [26809](source_parts/nswc_part_03.f90#L5693) | Not indexed |
| `IA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20558](source_parts/nswc_part_02.f90#L9943) | Not indexed |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [31697](source_parts/nswc_part_04.f90#L73) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [31661](source_parts/nswc_part_04.f90#L37) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IEGS` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, X, T, NT, NUP, MUP, IER, CUTOFF, ROOTRT, UNITRD, NHALF, LUFACT, KMM, KMN, KNM, RHS, R, RH, DELN, TM, TN, XM, XMZ, WM, WN, OLDX, SAVE, XN, SAVE2, ASIDE, ASIDE3, IMKNN` | [99866](source_parts/nswc_part_10.f90#L4423) | Not indexed |
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [99690](source_parts/nswc_part_10.f90#L4247) | [Documented](docs/23-integral-equations.md#topic-410-01) |
| `IMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20599](source_parts/nswc_part_02.f90#L9984) | Not indexed |
| `IMTQL1` | `SUBROUTINE` | `N, D, E, IERR` | [57882](source_parts/nswc_part_06.f90#L5051) | Not indexed |
| `IMTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [58273](source_parts/nswc_part_06.f90#L5442) | Not indexed |
| `INCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [92682](source_parts/nswc_part_09.f90#L7749) | Not indexed |
| `INDXA` | `SUBROUTINE` | `I, IR, IDXA, NA` | [108040](source_parts/nswc_part_11.f90#L2004) | Not indexed |
| `INDXB` | `SUBROUTINE` | `I, IR, IDX, IDP` | [108078](source_parts/nswc_part_11.f90#L2042) | Not indexed |
| `INDXC` | `SUBROUTINE` | `I, IR, IDXC, NC` | [108059](source_parts/nswc_part_11.f90#L2023) | Not indexed |
| `INFCTR` | `SUBROUTINE` | `N, IFACT, IPOWER, NEXP, NPOWER` | [32388](source_parts/nswc_part_04.f90#L764) | Not indexed |
| `INTADD` | `SUBROUTINE` | `KK, I1, I2, I3, IADJ, IEND` | [89998](source_parts/nswc_part_09.f90#L5065) | Not indexed |
| `INTRC1` | `SUBROUTINE` | `N, PX, PY, X, Y, Z, IADJ, IEND, IFLAG, ZXZY, IST, PZ, IER` | [91560](source_parts/nswc_part_09.f90#L6627) | Not indexed |
| `INTRP` | `SUBROUTINE` | `X, Y, XOUT, YOUT, YPOUT, NEQN, KOLD, PHI, PSI` | [101587](source_parts/nswc_part_10.f90#L6144) | Not indexed |
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [85717](source_parts/nswc_part_09.f90#L784) | [Documented](docs/18-curve-fitting.md#topic-368-01) |
| `INTYD` | `SUBROUTINE` | `T, K, YH, NYH, DKY, IFLAG` | [104787](source_parts/nswc_part_10.f90#L9344) | Not indexed |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [2257](source_parts/nswc_part_01.f90#L2257) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `IPATH` | `SUBROUTINE` | `I, J, SUBR, RBUS, AR, PR, S, N, NP, I1, I2, K, JR, M, NP1` | [5026](source_parts/nswc_part_01.f90#L5026) | Not indexed |
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [1](source_parts/nswc_part_01.f90#L1) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [31625](source_parts/nswc_part_04.f90#L1) | [Documented](docs/07-vectors.md#topic-141-01) |
| `ISHELL` | `SUBROUTINE` | `A, N` | [1299](source_parts/nswc_part_01.f90#L1299) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [15029](source_parts/nswc_part_02.f90#L4414) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `ISWAP` | `SUBROUTINE` | `N, IX, INCX, IY, INCY` | [29978](source_parts/nswc_part_03.f90#L8862) | Not indexed |
| `ITERT` | `SUBROUTINE` | `KERNEL, RHFCN, N, TN, WN, M, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, IFLG` | [100548](source_parts/nswc_part_10.f90#L5105) | Not indexed |
| `IUPD` | `SUBROUTINE` | `IA, IB, L, A1, A2, P1, P2, V1, V2, K1, N, M, NP1` | [5149](source_parts/nswc_part_01.f90#L5149) | Not indexed |
| `JA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20710](source_parts/nswc_part_02.f90#L10095) | Not indexed |
| `JAIRY` | `SUBROUTINE` | `X, RX, C, AI, DAI` | [17048](source_parts/nswc_part_02.f90#L6433) | Not indexed |
| `JMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20751](source_parts/nswc_part_02.f90#L10136) | Not indexed |
| `JROT` | `SUBROUTINE` | `NR, N, H, I, A, B, R` | [70833](source_parts/nswc_part_07.f90#L7472) | Not indexed |
| `KA` | `SUBROUTINE` | `IND, Z, K1, K2` | [20862](source_parts/nswc_part_02.f90#L10247) | Not indexed |
| `KL` | `SUBROUTINE` | `L, FK, FL` | [21987](source_parts/nswc_part_03.f90#L871) | Not indexed |
| `KM` | `COMPLEX FUNCTION` | `K2` | [21950](source_parts/nswc_part_03.f90#L834) | Not indexed |
| `KML` | `SUBROUTINE` | `IND, Z, K1, K2` | [20916](source_parts/nswc_part_02.f90#L10301) | Not indexed |
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [33048](source_parts/nswc_part_04.f90#L1424) | [Documented](docs/08-matrices.md#topic-160-01) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [33482](source_parts/nswc_part_04.f90#L1858) | [Documented](docs/08-matrices.md#topic-163-01) |
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [84755](source_parts/nswc_part_08.f90#L10362) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [84934](source_parts/nswc_part_09.f90#L1) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [85034](source_parts/nswc_part_09.f90#L101) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [85186](source_parts/nswc_part_09.f90#L253) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [67785](source_parts/nswc_part_07.f90#L4424) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-299-01) |
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [75872](source_parts/nswc_part_08.f90#L1479) | [Documented](docs/16-transforms.md#topic-317-01) |
| `LAINV1` | `SUBROUTINE` | `FUN, T, C, EPSRE, EPSAB, RESULT, ESTERR, NUM, IER` | [76465](source_parts/nswc_part_08.f90#L2072) | Not indexed |
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [44427](source_parts/nswc_part_05.f90#L2246) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `LEAVE` | `SUBROUTINE` | `IERSET, NF, MF, XV, TV, WV, ERROR, KERNEL, RHFCN, EP, IFLAG, X, T, NT, IER, EPS, ELINSY, TN, WN, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, XNORM` | [100430](source_parts/nswc_part_10.f90#L4987) | Not indexed |
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [26128](source_parts/nswc_part_03.f90#L5012) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [26154](source_parts/nswc_part_03.f90#L5038) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [26272](source_parts/nswc_part_03.f90#L5156) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [61685](source_parts/nswc_part_06.f90#L8854) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [61718](source_parts/nswc_part_06.f90#L8887) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-286-01) |
| `LLTSLV` | `SUBROUTINE` | `NR, N, A, X, B` | [70400](source_parts/nswc_part_07.f90#L7039) | Not indexed |
| `LMDIF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FTOL, XTOL, GTOL, MAXFEV, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, IPVT, QTF, WA1, WA2, WA3, WA4` | [70996](source_parts/nswc_part_07.f90#L7635) | Not indexed |
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [70888](source_parts/nswc_part_07.f90#L7527) | [Documented](docs/15-optimization.md#topic-309-01) |
| `LMPAR` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, DELTA, PAR, X, SDIAG, WA1, WA2` | [71814](source_parts/nswc_part_07.f90#L8453) | Not indexed |
| `LNSRCH` | `SUBROUTINE` | `N, X, F, G, P, XPLS, FPLS, FCN, MXTAKE, IRETCD, STEPMX, STEPTL, TYPSIZ` | [70524](source_parts/nswc_part_07.f90#L7163) | Not indexed |
| `LNSYS` | `SUBROUTINE` | `A, D, M, N, B, X, OPTION, IERR` | [100655](source_parts/nswc_part_10.f90#L5212) | Not indexed |
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [3897](source_parts/nswc_part_01.f90#L3897) | [Documented](docs/03-geometry.md#topic-039-01) |
| `LOGAM` | `REAL FUNCTION` | `X` | [15278](source_parts/nswc_part_02.f90#L4663) | Not indexed |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [84150](source_parts/nswc_part_08.f90#L9757) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [84226](source_parts/nswc_part_08.f90#L9833) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LPDP` | `SUBROUTINE` | `A, MDA, M, N1, N2, PRGOPT, X, WNORM, MODE, WS, IS` | [66485](source_parts/nswc_part_07.f90#L3124) | Not indexed |
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [65675](source_parts/nswc_part_07.f90#L2314) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-292-01) |
| `LSI` | `SUBROUTINE` | `W, MDW, MA, MG, N, PRGOPT, X, RNORM, MODE, WS, IP` | [66176](source_parts/nswc_part_07.f90#L2815) | Not indexed |
| `LSOD1` | `SUBROUTINE` | `F, NEQ, T, Y, TOUT, RTOL, ATOL, IDID, YPOUT, YH, YH1, EWT, SAVF, ACOR, WM, IWM, JAC, INTOUT, TSTOP, TOLFAC, DELSGN, RPAR, IPAR` | [104247](source_parts/nswc_part_10.f90#L8804) | Not indexed |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [62346](source_parts/nswc_part_06.f90#L9515) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [81853](source_parts/nswc_part_08.f90#L7460) | [Documented](docs/18-curve-fitting.md#topic-337-01) |
| `LUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [34116](source_parts/nswc_part_04.f90#L2492) | Not indexed |
| `MACH` | `SUBROUTINE` | `MO, N, IBETA, IMAX, IDMAX, IMACH, RMACH, DMACH` | [347](source_parts/nswc_part_01.f90#L347) | Not indexed |
| `MACH1` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [586](source_parts/nswc_part_01.f90#L586) | Not indexed |
| `MACH2` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [817](source_parts/nswc_part_01.f90#L817) | Not indexed |
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32477](source_parts/nswc_part_04.f90#L853) | [Documented](docs/08-matrices.md#topic-151-01) |
| `MC13D` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW` | [51621](source_parts/nswc_part_05.f90#L9440) | Not indexed |
| `MC13E` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, ARP, IB, NUM, LOWL, NUMB, PREV` | [51667](source_parts/nswc_part_05.f90#L9486) | Not indexed |
| `MC21A` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, IW` | [51462](source_parts/nswc_part_05.f90#L9281) | Not indexed |
| `MC21B` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, PR, ARP, CV, OUT` | [51511](source_parts/nswc_part_05.f90#L9330) | Not indexed |
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31899](source_parts/nswc_part_04.f90#L275) | [Documented](docs/08-matrices.md#topic-146-01) |
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [45443](source_parts/nswc_part_05.f90#L3262) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31843](source_parts/nswc_part_04.f90#L219) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [31741](source_parts/nswc_part_04.f90#L117) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31857](source_parts/nswc_part_04.f90#L233) | [Documented](docs/08-matrices.md#topic-144-01) |
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31829](source_parts/nswc_part_04.f90#L205) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [45617](source_parts/nswc_part_05.f90#L3436) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [31773](source_parts/nswc_part_04.f90#L149) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [92919](source_parts/nswc_part_09.f90#L7986) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MEVAL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [93076](source_parts/nswc_part_09.f90#L8143) | Not indexed |
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [44146](source_parts/nswc_part_05.f90#L1965) | [Documented](docs/08-matrices.md#topic-191-01) |
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [77650](source_parts/nswc_part_08.f90#L3257) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [77687](source_parts/nswc_part_08.f90#L3294) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [92061](source_parts/nswc_part_09.f90#L7128) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MINSOL` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTB` | [107306](source_parts/nswc_part_11.f90#L1270) | Not indexed |
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [74919](source_parts/nswc_part_08.f90#L526) | [Documented](docs/15-optimization.md#topic-315-01) |
| `MKP1` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5, BB, BL, X, XL, B, UBB, LX, LXI, F, PBL, Q, V, BS, PS, WS, XS, IWK` | [75123](source_parts/nswc_part_08.f90#L730) | Not indexed |
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [26018](source_parts/nswc_part_03.f90#L4902) | [Documented](docs/05-polynomials.md#topic-117-01) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [32671](source_parts/nswc_part_04.f90#L1047) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [34016](source_parts/nswc_part_04.f90#L2392) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [34052](source_parts/nswc_part_04.f90#L2428) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32541](source_parts/nswc_part_04.f90#L917) | [Documented](docs/08-matrices.md#topic-153-01) |
| `MTABLE` | `SUBROUTINE` | `DEGREE, DIMEN, NPOLYS, INDEXS, NEWKJ, ALFLP1` | [92483](source_parts/nswc_part_09.f90#L7550) | Not indexed |
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32605](source_parts/nswc_part_04.f90#L981) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51016](source_parts/nswc_part_05.f90#L8835) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [51044](source_parts/nswc_part_05.f90#L8863) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50966](source_parts/nswc_part_05.f90#L8785) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50991](source_parts/nswc_part_05.f90#L8810) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `NEWEST` | `SUBROUTINE` | `TYPE, UU, VV, NN, P, K` | [28676](source_parts/nswc_part_03.f90#L7560) | Not indexed |
| `NEWTON` | `SUBROUTINE` | `NL, NR, NI` | [80912](source_parts/nswc_part_08.f90#L6519) | Not indexed |
| `NEXTH` | `SUBROUTINE` | `BOOL, N, TR, TI, HR, HI, QPR, QPI, QHR, QHI` | [29469](source_parts/nswc_part_03.f90#L8353) | Not indexed |
| `NEXTK` | `SUBROUTINE` | `TYPE, N, QP, K, QK` | [28632](source_parts/nswc_part_03.f90#L7516) | Not indexed |
| `NORMLZ` | `SUBROUTINE` | `N, X, BETA` | [69072](source_parts/nswc_part_07.f90#L5711) | Not indexed |
| `NOSHFT` | `SUBROUTINE` | `L1, NN, TR, TI, ETA, PR, PI, HR, HI` | [29063](source_parts/nswc_part_03.f90#L7947) | Not indexed |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [33795](source_parts/nswc_part_04.f90#L2171) | [Documented](docs/08-matrices.md#topic-163-01) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [109937](source_parts/nswc_part_11.f90#L3901) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [110013](source_parts/nswc_part_11.f90#L3977) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [110139](source_parts/nswc_part_11.f90#L4103) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NSPIV1` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [51866](source_parts/nswc_part_05.f90#L9685) | Not indexed |
| `NSTERP` | `SUBROUTINE` | `TM, WM, XM, M, TN, WN, XN, N, KERNEL, RHFCN, RHS, KMN, NHALF, NUP` | [100197](source_parts/nswc_part_10.f90#L4754) | Not indexed |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [88964](source_parts/nswc_part_09.f90#L4031) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [100822](source_parts/nswc_part_10.f90#L5379) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-415-01) |
| `OPCHK1` | `SUBROUTINE` | `N, X, TYPSIZ, FSCALE, GRADTL, ITNLIM, RERR, STEPMX, IERR` | [70154](source_parts/nswc_part_07.f90#L6793) | Not indexed |
| `OPSTP` | `SUBROUTINE` | `N, XPLS, FPLS, GPLS, X, ITNCNT, ICSCMX, IERR, GRADTL, STEPTL, TYPSIZ, FSCALE, ITNLIM, IRETCD, MXTAKE, FSTACK, NS, SPTR` | [70227](source_parts/nswc_part_07.f90#L6866) | Not indexed |
| `OPTDRV` | `SUBROUTINE` | `MO, NR, N, X, FCN, TYPSIZ, FSCALE, RERR, ITNLIM, ITNCNT, GRADTL, STEPMX, STEPTL, XPLS, FPLS, GPLS, IERR, A, G, P, WRK0, WRK1, WRK2` | [69977](source_parts/nswc_part_07.f90#L6616) | Not indexed |
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [69904](source_parts/nswc_part_07.f90#L6543) | [Documented](docs/15-optimization.md#topic-307-01) |
| `ORIMP` | `SUBROUTINE` | `M, N, A, KA, QR, MS, S, IP, B, X, R, EXIT` | [61971](source_parts/nswc_part_06.f90#L9140) | Not indexed |
| `ORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [61878](source_parts/nswc_part_06.f90#L9047) | Not indexed |
| `ORTHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [55123](source_parts/nswc_part_06.f90#L2292) | Not indexed |
| `ORTHG` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTRB` | [107264](source_parts/nswc_part_11.f90#L1228) | Not indexed |
| `ORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [61767](source_parts/nswc_part_06.f90#L8936) | Not indexed |
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [26325](source_parts/nswc_part_03.f90#L5209) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [26407](source_parts/nswc_part_03.f90#L5291) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [26464](source_parts/nswc_part_03.f90#L5348) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [55613](source_parts/nswc_part_06.f90#L2782) | Not indexed |
| `ORTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [55682](source_parts/nswc_part_06.f90#L2851) | Not indexed |
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25528](source_parts/nswc_part_03.f90#L4412) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `PARC` | `SUBROUTINE` | `I, II, UB, IFLAG, VB, LUB, LJ, LI, F, BB, Q, B, N, M, NP1, LX, LXI, LR, LRI, LUBI` | [75567](source_parts/nswc_part_08.f90#L1174) | Not indexed |
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [4470](source_parts/nswc_part_01.f90#L4470) | [Documented](docs/03-geometry.md#topic-042-01) |
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [38259](source_parts/nswc_part_04.f90#L6635) | [Documented](docs/08-matrices.md#topic-176-01) |
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [82058](source_parts/nswc_part_08.f90#L7665) | [Documented](docs/18-curve-fitting.md#topic-339-01) |
| `PDEDGE` | `SUBROUTINE` | `EDGE, INDX, INDY, IERR` | [106391](source_parts/nswc_part_11.f90#L355) | Not indexed |
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [83716](source_parts/nswc_part_08.f90#L9323) | [Documented](docs/18-curve-fitting.md#topic-353-01) |
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [25700](source_parts/nswc_part_03.f90#L4584) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [83611](source_parts/nswc_part_08.f90#L9218) | [Documented](docs/18-curve-fitting.md#topic-352-01) |
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [24223](source_parts/nswc_part_03.f90#L3107) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [24261](source_parts/nswc_part_03.f90#L3145) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [3972](source_parts/nswc_part_01.f90#L3972) | [Documented](docs/03-geometry.md#topic-040-01) |
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [82088](source_parts/nswc_part_08.f90#L7695) | [Documented](docs/18-curve-fitting.md#topic-340-01) |
| `PI1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, BB, KUB, BL, LB, PBL, V, XL, NP1, N5, BS, PS, WS, XS, IWK` | [75455](source_parts/nswc_part_08.f90#L1062) | Not indexed |
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [25904](source_parts/nswc_part_03.f90#L4788) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `PJAC` | `SUBROUTINE` | `NEQ, Y, YH, NYH, EWT, FTEM, SAVF, WM, IWM, F, JAC, RPAR, IPAR` | [105475](source_parts/nswc_part_10.f90#L10032) | Not indexed |
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [25012](source_parts/nswc_part_03.f90#L3896) | [Documented](docs/04-special-functions.md#topic-109-01) |
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [25476](source_parts/nswc_part_03.f90#L4360) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [24301](source_parts/nswc_part_03.f90#L3185) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [24341](source_parts/nswc_part_03.f90#L3225) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [25803](source_parts/nswc_part_03.f90#L4687) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25620](source_parts/nswc_part_03.f90#L4504) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `PNDF` | `FUNCTION` | `X, IND` | [7212](source_parts/nswc_part_01.f90#L7212) | [Documented](docs/04-special-functions.md#topic-053-01) |
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [7247](source_parts/nswc_part_01.f90#L7247) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [2715](source_parts/nswc_part_01.f90#L2715) | [Documented](docs/02-elementary-operations.md#topic-028-01) |
| `POLYDD` | `DOUBLE PRECISION FUNCTION` | `X` | [81042](source_parts/nswc_part_08.f90#L6649) | Not indexed |
| `POLYEV` | `SUBROUTINE` | `N, SR, SI, PR, PI, QR, QI, PVR, PVI` | [29500](source_parts/nswc_part_03.f90#L8384) | Not indexed |
| `PPADD` | `SUBROUTINE` | `N, IERROR, A, C, CBP, BP, BH` | [108800](source_parts/nswc_part_11.f90#L2764) | Not indexed |
| `PPSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [109034](source_parts/nswc_part_11.f90#L2998) | Not indexed |
| `PPSPF` | `FUNCTION` | `X, IZ, C, A, BH` | [109050](source_parts/nswc_part_11.f90#L3014) | Not indexed |
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [86158](source_parts/nswc_part_09.f90#L1225) | [Documented](docs/18-curve-fitting.md#topic-372-01) |
| `PROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, W, U` | [108114](source_parts/nswc_part_11.f90#L2078) | Not indexed |
| `PRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, U, W` | [108216](source_parts/nswc_part_11.f90#L2180) | Not indexed |
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [83797](source_parts/nswc_part_08.f90#L9404) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [83871](source_parts/nswc_part_08.f90#L9478) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [108979](source_parts/nswc_part_11.f90#L2943) | Not indexed |
| `PSI` | `REAL FUNCTION` | `XX` | [10825](source_parts/nswc_part_02.f90#L210) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [11356](source_parts/nswc_part_02.f90#L741) | [Documented](docs/04-special-functions.md#topic-071-01) |
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25574](source_parts/nswc_part_03.f90#L4458) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [94864](source_parts/nswc_part_09.f90#L9931) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `QAGI1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [76855](source_parts/nswc_part_08.f90#L2462) | Not indexed |
| `QAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [95029](source_parts/nswc_part_09.f90#L10096) | Not indexed |
| `QAGIE1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [77036](source_parts/nswc_part_08.f90#L2643) | Not indexed |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [94165](source_parts/nswc_part_09.f90#L9232) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [94322](source_parts/nswc_part_09.f90#L9389) | Not indexed |
| `QDCRT` | `SUBROUTINE` | `A, Z` | [27169](source_parts/nswc_part_03.f90#L6053) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [95705](source_parts/nswc_part_10.f90#L262) | Not indexed |
| `QFORM` | `SUBROUTINE` | `M, N, Q, LDQ, WA` | [72047](source_parts/nswc_part_07.f90#L8686) | Not indexed |
| `QK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [95444](source_parts/nswc_part_10.f90#L1) | Not indexed |
| `QK15I1` | `SUBROUTINE` | `F, PHI, Y, C, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [77465](source_parts/nswc_part_08.f90#L3072) | Not indexed |
| `QK21F` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [94726](source_parts/nswc_part_09.f90#L9793) | Not indexed |
| `QPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [95591](source_parts/nswc_part_10.f90#L148) | Not indexed |
| `QRFAC` | `SUBROUTINE` | `M, N, A, LDA, PIVOT, IPVT, LIPVT, RDIAG, ACNORM, WA` | [72123](source_parts/nswc_part_07.f90#L8762) | Not indexed |
| `QRSOLV` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, X, SDIAG, WA` | [72267](source_parts/nswc_part_07.f90#L8906) | Not indexed |
| `QRUPDT` | `SUBROUTINE` | `NR, N, A, U, V` | [70774](source_parts/nswc_part_07.f90#L7413) | Not indexed |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [2102](source_parts/nswc_part_01.f90#L2102) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [1795](source_parts/nswc_part_01.f90#L1795) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [1948](source_parts/nswc_part_01.f90#L1948) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [93847](source_parts/nswc_part_09.f90#L8914) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [27676](source_parts/nswc_part_03.f90#L6560) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QUAD` | `SUBROUTINE` | `A, B, RESULT, K, EPSIL, NPTS, ICHECK, F` | [93973](source_parts/nswc_part_09.f90#L9040) | Not indexed |
| `QUADIT` | `SUBROUTINE` | `UU, VV, NZ, NN, P, QP, K, QK` | [28394](source_parts/nswc_part_03.f90#L7278) | Not indexed |
| `QUADPL` | `SUBROUTINE` | `A, B1, C, SR, SI, LR, LI` | [28742](source_parts/nswc_part_03.f90#L7626) | Not indexed |
| `QUADSD` | `SUBROUTINE` | `NN, U, V, P, Q, A, B` | [28718](source_parts/nswc_part_03.f90#L7602) | Not indexed |
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [85292](source_parts/nswc_part_09.f90#L359) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [85496](source_parts/nswc_part_09.f90#L563) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QXCPY` | `SUBROUTINE` | `A, B, L` | [96394](source_parts/nswc_part_10.f90#L951) | Not indexed |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [95861](source_parts/nswc_part_10.f90#L418) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [96017](source_parts/nswc_part_10.f90#L574) | Not indexed |
| `QXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [96408](source_parts/nswc_part_10.f90#L965) | Not indexed |
| `QXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [96662](source_parts/nswc_part_10.f90#L1219) | Not indexed |
| `QXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [96504](source_parts/nswc_part_10.f90#L1061) | Not indexed |
| `R1MPYQ` | `SUBROUTINE` | `M, N, A, LDA, V, W` | [72419](source_parts/nswc_part_07.f90#L9058) | Not indexed |
| `R1UPDT` | `SUBROUTINE` | `M, N, S, LS, U, V, W, SING` | [72491](source_parts/nswc_part_07.f90#L9130) | Not indexed |
| `RADB2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [78827](source_parts/nswc_part_08.f90#L4434) | Not indexed |
| `RADB3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [78877](source_parts/nswc_part_08.f90#L4484) | Not indexed |
| `RADB4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [78944](source_parts/nswc_part_08.f90#L4551) | Not indexed |
| `RADB5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [79039](source_parts/nswc_part_08.f90#L4646) | Not indexed |
| `RADBG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [79151](source_parts/nswc_part_08.f90#L4758) | Not indexed |
| `RADF2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [79430](source_parts/nswc_part_08.f90#L5037) | Not indexed |
| `RADF3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [79480](source_parts/nswc_part_08.f90#L5087) | Not indexed |
| `RADF4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [79545](source_parts/nswc_part_08.f90#L5152) | Not indexed |
| `RADF5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [79636](source_parts/nswc_part_08.f90#L5243) | Not indexed |
| `RADFG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [79744](source_parts/nswc_part_08.f90#L5351) | Not indexed |
| `RADIX` | `SUBROUTINE` | `IBETA` | [563](source_parts/nswc_part_01.f90#L563) | Not indexed |
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [110459](source_parts/nswc_part_11.f90#L4423) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `RARC` | `SUBROUTINE` | `IA, IB, AR, AC, PR, PC, VR, VC, K1, JJ, LL, N, M, NP1` | [5183](source_parts/nswc_part_01.f90#L5183) | Not indexed |
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [110734](source_parts/nswc_part_11.f90#L4698) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [29553](source_parts/nswc_part_03.f90#L8437) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [109629](source_parts/nswc_part_11.f90#L3593) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `RCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [109654](source_parts/nswc_part_11.f90#L3618) | Not indexed |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [12535](source_parts/nswc_part_02.f90#L1920) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `RCVAL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [23596](source_parts/nswc_part_03.f90#L2480) | Not indexed |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [23112](source_parts/nswc_part_03.f90#L1996) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `REALIT` | `SUBROUTINE` | `SSS, NZ, IFLAG, NN, P, QP, K, QK` | [28492](source_parts/nswc_part_03.f90#L7376) | Not indexed |
| `REXP` | `REAL FUNCTION` | `X` | [3431](source_parts/nswc_part_01.f90#L3431) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `REXP1` | `SUBROUTINE` | `X, E, W` | [3511](source_parts/nswc_part_01.f90#L3511) | Not indexed |
| `RFFTB` | `SUBROUTINE` | `N, R, WSAVE` | [78754](source_parts/nswc_part_08.f90#L4361) | Not indexed |
| `RFFTB1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [78762](source_parts/nswc_part_08.f90#L4369) | Not indexed |
| `RFFTF` | `SUBROUTINE` | `N, R, WSAVE` | [79356](source_parts/nswc_part_08.f90#L4963) | Not indexed |
| `RFFTF1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [79364](source_parts/nswc_part_08.f90#L4971) | Not indexed |
| `RFFTI` | `SUBROUTINE` | `N, WSAVE` | [78645](source_parts/nswc_part_08.f90#L4252) | Not indexed |
| `RFFTI1` | `SUBROUTINE` | `N, WA, IFAC` | [78653](source_parts/nswc_part_08.f90#L4260) | Not indexed |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [22917](source_parts/nswc_part_03.f90#L1801) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [110601](source_parts/nswc_part_11.f90#L4565) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [1474](source_parts/nswc_part_01.f90#L1474) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [23330](source_parts/nswc_part_03.f90#L2214) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [106073](source_parts/nswc_part_11.f90#L37) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-431-01) |
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [106130](source_parts/nswc_part_11.f90#L94) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-433-01) |
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [102484](source_parts/nswc_part_10.f90#L7041) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-421-01) |
| `RKFC` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, W, WP, X, HINT, H, Y1, Y2, F1, F2, F3, F4, F7, SAVRE, SAVAE, TOLD, NFE, JFLAG, KFLAG, ENDPNT, BLKOUT` | [101921](source_parts/nswc_part_10.f90#L6478) | Not indexed |
| `RKFS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YP, H, F1, F2, F3, F4, F5, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [102655](source_parts/nswc_part_10.f90#L7212) | Not indexed |
| `RLOC` | `LOGICAL FUNCTION` | `X, Y` | [32730](source_parts/nswc_part_04.f90#L1106) | Not indexed |
| `RLOG` | `REAL FUNCTION` | `X` | [3675](source_parts/nswc_part_01.f90#L3675) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RLOG1` | `REAL FUNCTION` | `X` | [3721](source_parts/nswc_part_01.f90#L3721) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RMIN` | `FUNCTION` | `N, M, COND, UNITRD, AVERR` | [100243](source_parts/nswc_part_10.f90#L4800) | Not indexed |
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [111325](source_parts/nswc_part_11.f90#L5289) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `RNDERR` | `FUNCTION` | `X, A, Y, B` | [99551](source_parts/nswc_part_10.f90#L4108) | Not indexed |
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [33126](source_parts/nswc_part_04.f90#L1502) | [Documented](docs/08-matrices.md#topic-161-01) |
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [109827](source_parts/nswc_part_11.f90#L3791) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `RNRM` | `REAL FUNCTION` | `X, Y, N, IFLAG` | [100262](source_parts/nswc_part_10.f90#L4819) | Not indexed |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [2310](source_parts/nswc_part_01.f90#L2310) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ROT3` | `SUBROUTINE` | `A, THETA` | [2861](source_parts/nswc_part_01.f90#L2861) | [Documented](docs/02-elementary-operations.md#topic-030-01) |
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [2743](source_parts/nswc_part_01.f90#L2743) | [Documented](docs/02-elementary-operations.md#topic-028-03) |
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [50069](source_parts/nswc_part_05.f90#L7888) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [50126](source_parts/nswc_part_05.f90#L7945) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RRSORT` | `SUBROUTINE` | `A, B, N` | [1522](source_parts/nswc_part_01.f90#L1522) | Not indexed |
| `RSCO` | `SUBROUTINE` | `RSAV, ISAV` | [104199](source_parts/nswc_part_10.f90#L8756) | Not indexed |
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49950](source_parts/nswc_part_05.f90#L7769) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [52090](source_parts/nswc_part_05.f90#L9909) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `RSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [52168](source_parts/nswc_part_05.f90#L9987) | Not indexed |
| `RSORT` | `SUBROUTINE` | `A, N` | [1431](source_parts/nswc_part_01.f90#L1431) | Not indexed |
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [53263](source_parts/nswc_part_06.f90#L432) | [Documented](docs/11-sparse-matrices.md#topic-250-01) |
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [51301](source_parts/nswc_part_05.f90#L9120) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50420](source_parts/nswc_part_05.f90#L8239) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [31179](source_parts/nswc_part_03.f90#L10063) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [31059](source_parts/nswc_part_03.f90#L9943) | [Documented](docs/07-vectors.md#topic-138-01) |
| `SCALCP` | `DOUBLE PRECISION FUNCTION` | `NN, PT, ETA, INFIN, SMALNO, BASE` | [28982](source_parts/nswc_part_03.f90#L7866) | Not indexed |
| `SCALDN` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [92896](source_parts/nswc_part_09.f90#L7963) | Not indexed |
| `SCALEX` | `SUBROUTINE` | `MO, X, TYPSIZ, N, IERR` | [70361](source_parts/nswc_part_07.f90#L7000) | Not indexed |
| `SCALPM` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [92864](source_parts/nswc_part_09.f90#L7931) | Not indexed |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [31254](source_parts/nswc_part_03.f90#L10138) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SCD` | `SUBROUTINE` | `U, K, L, F, S, C, D` | [23874](source_parts/nswc_part_03.f90#L2758) | Not indexed |
| `SCDF` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [23987](source_parts/nswc_part_03.f90#L2871) | Not indexed |
| `SCDJ` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [24050](source_parts/nswc_part_03.f90#L2934) | Not indexed |
| `SCDM` | `SUBROUTINE` | `U, K, S, C, D` | [23963](source_parts/nswc_part_03.f90#L2847) | Not indexed |
| `SCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [41804](source_parts/nswc_part_04.f90#L10180) | Not indexed |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [31498](source_parts/nswc_part_03.f90#L10382) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [82785](source_parts/nswc_part_08.f90#L8392) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [82872](source_parts/nswc_part_08.f90#L8479) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [82961](source_parts/nswc_part_08.f90#L8568) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [50041](source_parts/nswc_part_05.f90#L7860) | [Documented](docs/11-sparse-matrices.md#topic-232-01) |
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [29858](source_parts/nswc_part_03.f90#L8742) | [Documented](docs/07-vectors.md#topic-130-01) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49795](source_parts/nswc_part_05.f90#L7614) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [49886](source_parts/nswc_part_05.f90#L7705) | [Documented](docs/11-sparse-matrices.md#topic-230-01) |
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49768](source_parts/nswc_part_05.f90#L7587) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [30782](source_parts/nswc_part_03.f90#L9666) | [Documented](docs/07-vectors.md#topic-136-01) |
| `SECFAC` | `SUBROUTINE` | `NR, N, X, G, A, XPLS, GPLS, ITNCNT, TOL, NOUPDT, S, Y, W` | [70639](source_parts/nswc_part_07.f90#L7278) | Not indexed |
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [57431](source_parts/nswc_part_06.f90#L4600) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [57452](source_parts/nswc_part_06.f90#L4621) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [57499](source_parts/nswc_part_06.f90#L4668) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [57532](source_parts/nswc_part_06.f90#L4701) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [106204](source_parts/nswc_part_11.f90#L168) | [Documented](docs/25-partial-differential-equations.md#topic-434-01) |
| `SEPEL1` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, AN, BN, CN, DN, UN, ZN, AM, BM, CM, DM, UM, ZM, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [106868](source_parts/nswc_part_11.f90#L832) | Not indexed |
| `SEPELL` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [106437](source_parts/nswc_part_11.f90#L401) | Not indexed |
| `SETRM` | `SUBROUTINE` | `XK, YK, ZK, XI, YI, ZI, S1, S2, R, ROW` | [91311](source_parts/nswc_part_09.f90#L6378) | Not indexed |
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [83053](source_parts/nswc_part_08.f90#L8660) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [83147](source_parts/nswc_part_08.f90#L8754) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [83242](source_parts/nswc_part_08.f90#L8849) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SFFT` | `SUBROUTINE` | `A, B, NTOT, N, NSPAN, ISN, IERR` | [77718](source_parts/nswc_part_08.f90#L3325) | Not indexed |
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [103467](source_parts/nswc_part_10.f90#L8024) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [103503](source_parts/nswc_part_10.f90#L8060) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [91495](source_parts/nswc_part_09.f90#L6562) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [91526](source_parts/nswc_part_09.f90#L6593) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SGBFA` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, INFO` | [105745](source_parts/nswc_part_10.f90#L10302) | Not indexed |
| `SGBSL` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, B, JOB` | [105909](source_parts/nswc_part_10.f90#L10466) | Not indexed |
| `SGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [34206](source_parts/nswc_part_04.f90#L2582) | Not indexed |
| `SGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [34628](source_parts/nswc_part_04.f90#L3004) | Not indexed |
| `SGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [34411](source_parts/nswc_part_04.f90#L2787) | Not indexed |
| `SGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [34515](source_parts/nswc_part_04.f90#L2891) | Not indexed |
| `SHELL` | `SUBROUTINE` | `A, N` | [1341](source_parts/nswc_part_01.f90#L1341) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [1384](source_parts/nswc_part_01.f90#L1384) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHIFTD` | `SUBROUTINE` | `NFRST, NLAST, KK, IARR` | [90135](source_parts/nswc_part_09.f90#L5202) | Not indexed |
| `SHRSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [42060](source_parts/nswc_part_04.f90#L10436) | Not indexed |
| `SI` | `FUNCTION` | `X` | [8871](source_parts/nswc_part_01.f90#L8871) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `SIGMA1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, KUB, UB, NP1, N5, LX, LR, BS, PS, WS, XS, IWK` | [75392](source_parts/nswc_part_08.f90#L999) | Not indexed |
| `SIN0` | `REAL FUNCTION` | `X` | [2974](source_parts/nswc_part_01.f90#L2974) | Not indexed |
| `SIN1` | `REAL FUNCTION` | `X` | [3014](source_parts/nswc_part_01.f90#L3014) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [78607](source_parts/nswc_part_08.f90#L4214) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [78553](source_parts/nswc_part_08.f90#L4160) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SKNP` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, N5, PS, WS, XS, IWK` | [75618](source_parts/nswc_part_08.f90#L1225) | Not indexed |
| `SKNP1` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, PS, WS, XS, D, MIN, PBAR, WBAR, ZBAR` | [75661](source_parts/nswc_part_08.f90#L1268) | Not indexed |
| `SLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [33844](source_parts/nswc_part_04.f90#L2220) | Not indexed |
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [34085](source_parts/nswc_part_04.f90#L2461) | [Documented](docs/08-matrices.md#topic-168-01) |
| `SLVS` | `SUBROUTINE` | `WM, IWM, X, TEM` | [105665](source_parts/nswc_part_10.f90#L10222) | Not indexed |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [32528](source_parts/nswc_part_04.f90#L904) | [Documented](docs/08-matrices.md#topic-151-01) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [31913](source_parts/nswc_part_04.f90#L289) | [Documented](docs/08-matrices.md#topic-146-01) |
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [72657](source_parts/nswc_part_07.f90#L9296) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SMPLX1` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [72707](source_parts/nswc_part_07.f90#L9346) | Not indexed |
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [33027](source_parts/nswc_part_04.f90#L1403) | [Documented](docs/08-matrices.md#topic-159-01) |
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [36399](source_parts/nswc_part_04.f90#L4775) | [Documented](docs/08-matrices.md#topic-173-01) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [32592](source_parts/nswc_part_04.f90#L968) | [Documented](docs/08-matrices.md#topic-153-01) |
| `SNBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [48241](source_parts/nswc_part_05.f90#L6060) | Not indexed |
| `SNBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [48410](source_parts/nswc_part_05.f90#L6229) | Not indexed |
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [3300](source_parts/nswc_part_01.f90#L3300) | [Documented](docs/02-elementary-operations.md#topic-035-01) |
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [51275](source_parts/nswc_part_05.f90#L9094) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [31282](source_parts/nswc_part_03.f90#L10166) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SOL` | `SUBROUTINE` | `N, NDIM, A, B, IP` | [33747](source_parts/nswc_part_04.f90#L2123) | Not indexed |
| `SOLBT` | `SUBROUTINE` | `M, N, A, B, C, Y, IP` | [36325](source_parts/nswc_part_04.f90#L4701) | Not indexed |
| `SOLVE2` | `SUBROUTINE` | `M, N, M1, A, B, W, N1, IPIVOT, QR, D, ETA, FAIL, NUMIT, DIGITX, X, RES, WRES, Y1, Y2, Y, F, G, MM, MMPNN` | [68433](source_parts/nswc_part_07.f90#L5072) | Not indexed |
| `SOLVE3` | `SUBROUTINE` | `F, M1, M, N1, QR, D, Y, MMPNN` | [68605](source_parts/nswc_part_07.f90#L5244) | Not indexed |
| `SONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [53381](source_parts/nswc_part_06.f90#L550) | Not indexed |
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [82627](source_parts/nswc_part_08.f90#L8234) | [Documented](docs/18-curve-fitting.md#topic-344-01) |
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [87818](source_parts/nswc_part_09.f90#L2885) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-379-01) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [82494](source_parts/nswc_part_08.f90#L8101) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [68754](source_parts/nswc_part_07.f90#L5393) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `SPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [52339](source_parts/nswc_part_05.f90#L10158) | Not indexed |
| `SPMPAR` | `REAL FUNCTION` | `I` | [1049](source_parts/nswc_part_01.f90#L1049) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [51386](source_parts/nswc_part_05.f90#L9205) | [Documented](docs/11-sparse-matrices.md#topic-244-01) |
| `SPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [38439](source_parts/nswc_part_04.f90#L6815) | Not indexed |
| `SPPFA` | `SUBROUTINE` | `AP, N, INFO` | [38283](source_parts/nswc_part_04.f90#L6659) | Not indexed |
| `SPPSL` | `SUBROUTINE` | `AP, N, B` | [38366](source_parts/nswc_part_04.f90#L6742) | Not indexed |
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [50798](source_parts/nswc_part_05.f90#L8617) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [51779](source_parts/nswc_part_05.f90#L9598) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `SQUIN2` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD, EYE, TEMP, NW, TOL, MAXITS, IERR` | [43401](source_parts/nswc_part_05.f90#L1220) | Not indexed |
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [43327](source_parts/nswc_part_05.f90#L1146) | [Documented](docs/08-matrices.md#topic-189-01) |
| `SRCH` | `SUBROUTINE` | `FUN, COND, XL, ETA, X, NUM, IERR` | [76045](source_parts/nswc_part_08.f90#L1652) | Not indexed |
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [30188](source_parts/nswc_part_03.f90#L9072) | [Documented](docs/07-vectors.md#topic-132-01) |
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [2757](source_parts/nswc_part_01.f90#L2757) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [30427](source_parts/nswc_part_03.f90#L9311) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [30294](source_parts/nswc_part_03.f90#L9178) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [30939](source_parts/nswc_part_03.f90#L9823) | [Documented](docs/07-vectors.md#topic-137-01) |
| `SSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [36433](source_parts/nswc_part_04.f90#L4809) | Not indexed |
| `SSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [37124](source_parts/nswc_part_04.f90#L5500) | Not indexed |
| `SSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [36726](source_parts/nswc_part_04.f90#L5102) | Not indexed |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [73511](source_parts/nswc_part_07.f90#L10150) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SSPLX1` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [73563](source_parts/nswc_part_07.f90#L10202) | Not indexed |
| `SSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [36969](source_parts/nswc_part_04.f90#L5345) | Not indexed |
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50609](source_parts/nswc_part_05.f90#L8428) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [39988](source_parts/nswc_part_04.f90#L8364) | [Documented](docs/08-matrices.md#topic-183-01) |
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [30052](source_parts/nswc_part_03.f90#L8936) | [Documented](docs/07-vectors.md#topic-131-01) |
| `STEP1` | `SUBROUTINE` | `F, NEQN, Y, X, H, EPS, WT, START, HOLD, K, KOLD, CRASH, PHI, P, YP, PSI, ALPHA, BETA, SIG, V, W, G, PHASE1, NS, NORND` | [101135](source_parts/nswc_part_10.f90#L5692) | Not indexed |
| `STFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR, JAC` | [103547](source_parts/nswc_part_10.f90#L8104) | Not indexed |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [69105](source_parts/nswc_part_07.f90#L5744) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `STOD` | `SUBROUTINE` | `NEQ, Y, YH, NYH, YH1, EWT, SAVF, ACOR, WM, IWM, F, JAC, RPAR, IPAR` | [104869](source_parts/nswc_part_10.f90#L9426) | Not indexed |
| `STORE2` | `SUBROUTINE` | `A, B` | [804](source_parts/nswc_part_01.f90#L804) | Not indexed |
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [88446](source_parts/nswc_part_09.f90#L3513) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-384-01) |
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [88826](source_parts/nswc_part_09.f90#L3893) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `SVCO` | `SUBROUTINE` | `RSAV, ISAV` | [104222](source_parts/nswc_part_10.f90#L8779) | Not indexed |
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [32958](source_parts/nswc_part_04.f90#L1334) | [Documented](docs/08-matrices.md#topic-157-01) |
| `SWAPD` | `SUBROUTINE` | `NIN1, NIN2, NOUT1, NOUT2, IADJ, IEND` | [90227](source_parts/nswc_part_09.f90#L5294) | Not indexed |
| `SWPTST` | `LOGICAL FUNCTION` | `IN1, IN2, IO1, IO2, X, Y` | [90403](source_parts/nswc_part_09.f90#L5470) | Not indexed |
| `SYMSLV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [42889](source_parts/nswc_part_05.f90#L708) | Not indexed |
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [42738](source_parts/nswc_part_05.f90#L557) | [Documented](docs/08-matrices.md#topic-188-01) |
| `TASLV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [42795](source_parts/nswc_part_05.f90#L614) | Not indexed |
| `TERMS` | `SUBROUTINE` | `DIAG, SDIAG, SIGMA, DEL` | [85669](source_parts/nswc_part_09.f90#L736) | Not indexed |
| `TINDX` | `INTEGER FUNCTION` | `NVERTX, NABOR, IADJ, IEND` | [90482](source_parts/nswc_part_09.f90#L5549) | Not indexed |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [32010](source_parts/nswc_part_04.f90#L386) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [33008](source_parts/nswc_part_04.f90#L1384) | [Documented](docs/08-matrices.md#topic-158-01) |
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [38831](source_parts/nswc_part_04.f90#L7207) | [Documented](docs/08-matrices.md#topic-177-01) |
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31968](source_parts/nswc_part_04.f90#L344) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [58117](source_parts/nswc_part_06.f90#L5286) | Not indexed |
| `TQLRAT` | `SUBROUTINE` | `N, D, E2, IERR` | [57759](source_parts/nswc_part_06.f90#L4928) | Not indexed |
| `TQLRT0` | `SUBROUTINE` | `N, D, E2, IERR` | [108679](source_parts/nswc_part_11.f90#L2643) | Not indexed |
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [111123](source_parts/nswc_part_11.f90#L5087) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `TRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [57565](source_parts/nswc_part_06.f90#L4734) | Not indexed |
| `TRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [57999](source_parts/nswc_part_06.f90#L5168) | Not indexed |
| `TRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [57664](source_parts/nswc_part_06.f90#L4833) | Not indexed |
| `TRFIND` | `SUBROUTINE` | `NST, PX, PY, X, Y, IADJ, IEND, I1, I2, I3` | [90517](source_parts/nswc_part_09.f90#L5584) | Not indexed |
| `TRISLV` | `SUBROUTINE` | `NM, N, U, V, L, F, TEMP, IERR` | [44058](source_parts/nswc_part_05.f90#L1877) | Not indexed |
| `TRISP` | `SUBROUTINE` | `N, A, B, C, D, U, Z` | [107351](source_parts/nswc_part_11.f90#L1315) | Not indexed |
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [89560](source_parts/nswc_part_09.f90#L4627) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `TRP` | `FUNCTION` | `A, N, X, Y` | [81819](source_parts/nswc_part_08.f90#L7426) | [Documented](docs/18-curve-fitting.md#topic-336-01) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [52212](source_parts/nswc_part_05.f90#L10031) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `TSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [52290](source_parts/nswc_part_05.f90#L10109) | Not indexed |
| `TVAL` | `SUBROUTINE` | `X, Y, X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3, ZX1, ZX2, ZX3, ZY1, ZY2, ZY3, IFLAG, W, WX, WY, IER` | [91819](source_parts/nswc_part_09.f90#L6886) | Not indexed |
| `U11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [62561](source_parts/nswc_part_06.f90#L9730) | Not indexed |
| `U11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [62962](source_parts/nswc_part_06.f90#L10131) | Not indexed |
| `U12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [62841](source_parts/nswc_part_06.f90#L10010) | Not indexed |
| `U12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [63242](source_parts/nswc_part_06.f90#L10411) | Not indexed |
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [109066](source_parts/nswc_part_11.f90#L3030) | [Documented](docs/26-discrete-random-number-generation.md#topic-438-01) |
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [109154](source_parts/nswc_part_11.f90#L3118) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `URNG0` | `SUBROUTINE` | `IX, U, V` | [109279](source_parts/nswc_part_11.f90#L3243) | Not indexed |
| `URNG1` | `SUBROUTINE` | `IX, U, V, D` | [109389](source_parts/nswc_part_11.f90#L3353) | Not indexed |
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [109507](source_parts/nswc_part_11.f90#L3471) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [24384](source_parts/nswc_part_03.f90#L3268) | [Documented](docs/04-special-functions.md#topic-105-01) |
| `VNORM` | `FUNCTION` | `V, NCOMP` | [106037](source_parts/nswc_part_11.f90#L1) | Not indexed |
| `VNWRMS` | `REAL FUNCTION` | `N, V, W` | [106052](source_parts/nswc_part_11.f90#L16) | Not indexed |
| `VRSHFT` | `SUBROUTINE` | `L3, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [29281](source_parts/nswc_part_03.f90#L8165) | Not indexed |
| `WANDT` | `SUBROUTINE` | `WV, TV, N, A, B` | [100305](source_parts/nswc_part_10.f90#L4862) | Not indexed |
| `WNLIT` | `SUBROUTINE` | `W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM, IDOPE, DOPE, DONE` | [67419](source_parts/nswc_part_07.f90#L4058) | Not indexed |
| `WNLSM` | `SUBROUTINE` | `W, MDW, MME, MA, N, L, PRGOPT, X, RNORM, MODE, IPIVOT, ITYPE, WD, H, SCALE, Z, TEMP, D` | [66847](source_parts/nswc_part_07.f90#L3486) | Not indexed |
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [66636](source_parts/nswc_part_07.f90#L3275) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-296-01) |
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [82229](source_parts/nswc_part_08.f90#L7836) | [Documented](docs/18-curve-fitting.md#topic-341-01) |
| `XCOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [76354](source_parts/nswc_part_08.f90#L1961) | Not indexed |
| `XCONDX` | `FUNCTION` | `X, Y, C, FUN` | [76415](source_parts/nswc_part_08.f90#L2022) | Not indexed |
| `XCONDY` | `FUNCTION` | `X, Y, C, FUN` | [76440](source_parts/nswc_part_08.f90#L2047) | Not indexed |
| `XL1` | `SUBROUTINE` | `K, L, M, N, KLMD, KLM2D, NKLMD, N2D, Q, KODE, TOLER, ITER, X, RES, ERROR, CU, IU, S` | [61253](source_parts/nswc_part_06.f90#L8422) | Not indexed |
| `YCHG` | `SUBROUTINE` | `X, Y, YOLD` | [32757](source_parts/nswc_part_04.f90#L1133) | Not indexed |
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [26507](source_parts/nswc_part_03.f90#L5391) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `ZZZJAC` | `SUBROUTINE` | `T, Y, PD, N, RPAR, IPAR` | [103533](source_parts/nswc_part_10.f90#L8090) | Not indexed |
