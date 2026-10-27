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
| `ABCON` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [75233](source_parts/nswc_part_08.f90#L862) | Not indexed |
| `ABCON1` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [75387](source_parts/nswc_part_08.f90#L1016) | Not indexed |
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [41163](source_parts/nswc_part_04.f90#L9388) | [Documented](docs/08-matrices.md#topic-186-01) |
| `ABSLV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [41235](source_parts/nswc_part_04.f90#L9460) | Not indexed |
| `ACOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [75490](source_parts/nswc_part_08.f90#L1119) | Not indexed |
| `ACONDF` | `FUNCTION` | `X, Y, C, FUN` | [75546](source_parts/nswc_part_08.f90#L1175) | Not indexed |
| `ACONDG` | `FUNCTION` | `X, Y, C, FUN` | [75563](source_parts/nswc_part_08.f90#L1192) | Not indexed |
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [79465](source_parts/nswc_part_08.f90#L5094) | [Documented](docs/17-approximation-of-functions.md#topic-329-01) |
| `ADAPT1` | `SUBROUTINE` | `F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [79544](source_parts/nswc_part_08.f90#L5173) | Not indexed |
| `ADCHK` | `SUBROUTINE` | `` | [80263](source_parts/nswc_part_08.f90#L5892) | Not indexed |
| `ADCOMP` | `SUBROUTINE` | `F` | [79933](source_parts/nswc_part_08.f90#L5562) | Not indexed |
| `ADNODE` | `SUBROUTINE` | `KK, X, Y, IADJ, IEND, IER` | [88876](source_parts/nswc_part_09.f90#L3967) | Not indexed |
| `ADPUT` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [80314](source_parts/nswc_part_08.f90#L5943) | Not indexed |
| `ADSET` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [79738](source_parts/nswc_part_08.f90#L5367) | Not indexed |
| `ADTAKE` | `SUBROUTINE` | `IERR` | [79859](source_parts/nswc_part_08.f90#L5488) | Not indexed |
| `ADTRAN` | `SUBROUTINE` | `D, POWERS` | [80388](source_parts/nswc_part_08.f90#L6017) | Not indexed |
| `AERF` | `REAL FUNCTION` | `X, H` | [6853](source_parts/nswc_part_01.f90#L6853) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `AI` | `REAL FUNCTION` | `X` | [20781](source_parts/nswc_part_02.f90#L10240) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AIA` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [19843](source_parts/nswc_part_02.f90#L9302) | Not indexed |
| `AIE` | `REAL FUNCTION` | `X` | [20914](source_parts/nswc_part_02.f90#L10373) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AII` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [19782](source_parts/nswc_part_02.f90#L9241) | Not indexed |
| `AIMP` | `SUBROUTINE` | `X, R, PHI` | [21397](source_parts/nswc_part_03.f90#L175) | Not indexed |
| `AIRM` | `SUBROUTINE` | `IND, Z, AI, AIP, BI, BIP` | [19708](source_parts/nswc_part_02.f90#L9167) | Not indexed |
| `ALGDIV` | `REAL FUNCTION` | `A, B` | [11689](source_parts/nswc_part_02.f90#L1148) | Not indexed |
| `ALI` | `REAL FUNCTION` | `X` | [9259](source_parts/nswc_part_01.f90#L9259) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `ALLOT` | `SUBROUTINE` | `DEGREE, NPOLYS, NPTS, DIMEN, IWORK, IWKLEN, IREQD, DREQD, ERROR` | [91299](source_parts/nswc_part_09.f90#L6390) | Not indexed |
| `ALNREL` | `REAL FUNCTION` | `A` | [3538](source_parts/nswc_part_01.f90#L3538) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [2883](source_parts/nswc_part_01.f90#L2883) | [Documented](docs/02-elementary-operations.md#topic-032-01) |
| `AORD` | `SUBROUTINE` | `A, N` | [1681](source_parts/nswc_part_01.f90#L1681) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `APSER` | `REAL FUNCTION` | `A, B, X, EPS` | [14007](source_parts/nswc_part_02.f90#L3466) | Not indexed |
| `ARCEBE` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, PIVOT, X` | [35737](source_parts/nswc_part_04.f90#L3962) | Not indexed |
| `ARCEBM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [35716](source_parts/nswc_part_04.f90#L3941) | Not indexed |
| `ARCEBS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [35693](source_parts/nswc_part_04.f90#L3918) | Not indexed |
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [34911](source_parts/nswc_part_04.f90#L3136) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARCEDC` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, IFLAG` | [35021](source_parts/nswc_part_04.f90#L3246) | Not indexed |
| `ARCEFE` | `SUBROUTINE` | `BLOCK, NRWBLK, NRWPIV, PIVOT, B` | [35665](source_parts/nswc_part_04.f90#L3890) | Not indexed |
| `ARCEFM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, B, X` | [35644](source_parts/nswc_part_04.f90#L3869) | Not indexed |
| `ARCEFS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, B, X` | [35619](source_parts/nswc_part_04.f90#L3844) | Not indexed |
| `ARCEPC` | `SUBROUTINE` | `TOPBLK, NRWTOP, NOVRLP, BOTBLK, NRWBOT, NCLPIV, PIVOT, PIVMAX, IFLAG` | [35345](source_parts/nswc_part_04.f90#L3570) | Not indexed |
| `ARCEPR` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, PIVOT, PIVMAX, IFLAG` | [35253](source_parts/nswc_part_04.f90#L3478) | Not indexed |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [35444](source_parts/nswc_part_04.f90#L3669) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARTNQ` | `FUNCTION` | `Y, X` | [2422](source_parts/nswc_part_01.f90#L2422) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `ASIK` | `SUBROUTINE` | `X, FNU, KODE, FLGIK, RA, ARG, IN, TOL, Y` | [18298](source_parts/nswc_part_02.f90#L7757) | Not indexed |
| `ASJY` | `SUBROUTINE` | `FUNJY, X, FNU, FLGJY, IN, TOL, ELIM, Y, WK, IFLW` | [16526](source_parts/nswc_part_02.f90#L5985) | Not indexed |
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [73865](source_parts/nswc_part_07.f90#L10194) | [Documented](docs/15-optimization.md#topic-314-01) |
| `ASSGN1` | `SUBROUTINE` | `N, A, C, T, CH, LC, LR, LZ, NZ, RH, SLC, SLR, U, IERR` | [73903](source_parts/nswc_part_07.f90#L10232) | Not indexed |
| `ATN` | `COMPLEX FUNCTION` | `Z` | [22104](source_parts/nswc_part_03.f90#L882) | Not indexed |
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [48463](source_parts/nswc_part_05.f90#L6142) | [Documented](docs/10-banded-matrices.md#topic-217-01) |
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [47411](source_parts/nswc_part_05.f90#L5090) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [45652](source_parts/nswc_part_05.f90#L3331) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `BALANC` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [54110](source_parts/nswc_part_06.f90#L1180) | Not indexed |
| `BALBAK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [54800](source_parts/nswc_part_06.f90#L1870) | Not indexed |
| `BALINV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [54268](source_parts/nswc_part_06.f90#L1338) | Not indexed |
| `BANFAC` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, IFLAG` | [85706](source_parts/nswc_part_09.f90#L797) | Not indexed |
| `BANSLV` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, B` | [85826](source_parts/nswc_part_09.f90#L917) | Not indexed |
| `BASIZ` | `SUBROUTINE` | `DEGREE, NPTS, DIMEN, NPOLYS, ERROR` | [91490](source_parts/nswc_part_09.f90#L6581) | Not indexed |
| `BASYM` | `REAL FUNCTION` | `A, B, LAMBDA, EPS` | [14755](source_parts/nswc_part_02.f90#L4214) | Not indexed |
| `BCHFAC` | `SUBROUTINE` | `W, NB, N, DIAG, IFLAG` | [85985](source_parts/nswc_part_09.f90#L1076) | Not indexed |
| `BCHSLV` | `SUBROUTINE` | `W, NB, N, B` | [86086](source_parts/nswc_part_09.f90#L1177) | Not indexed |
| `BCHSV1` | `SUBROUTINE` | `W, NB, N, B, KB, M` | [88535](source_parts/nswc_part_09.f90#L3626) | Not indexed |
| `BCORR` | `REAL FUNCTION` | `A0, B0` | [11652](source_parts/nswc_part_02.f90#L1111) | Not indexed |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45312](source_parts/nswc_part_05.f90#L2991) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [45428](source_parts/nswc_part_05.f90#L3107) | [Documented](docs/10-banded-matrices.md#topic-202-01) |
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45294](source_parts/nswc_part_05.f90#L2973) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BDYADD` | `SUBROUTINE` | `KK, I1, I2, IADJ, IEND` | [88990](source_parts/nswc_part_09.f90#L4081) | Not indexed |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [17819](source_parts/nswc_part_02.f90#L7278) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [16056](source_parts/nswc_part_02.f90#L5515) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [11512](source_parts/nswc_part_02.f90#L971) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [86135](source_parts/nswc_part_09.f90#L1226) | [Documented](docs/18-curve-fitting.md#topic-376-01) |
| `BFIT0` | `SUBROUTINE` | `NDATA, XDATA, YDATA, NORD, NBKPT, BKPT, NCONST, XCONST, YCONST, NDERIV, MODE, COEFF, RNORM, BF, G, MDG, W, MDW, WORK, IWORK` | [86326](source_parts/nswc_part_09.f90#L1417) | Not indexed |
| `BFRAC` | `REAL FUNCTION` | `A, B, X, Y, LAMBDA, EPS` | [14214](source_parts/nswc_part_02.f90#L3673) | Not indexed |
| `BGRAT` | `SUBROUTINE` | `A, B, X, Y, W, EPS, IERR` | [14563](source_parts/nswc_part_02.f90#L4022) | Not indexed |
| `BI` | `REAL FUNCTION` | `X` | [21040](source_parts/nswc_part_02.f90#L10499) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BIA` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [20132](source_parts/nswc_part_02.f90#L9591) | Not indexed |
| `BIE` | `REAL FUNCTION` | `X` | [21223](source_parts/nswc_part_03.f90#L1) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BII` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [20061](source_parts/nswc_part_02.f90#L9520) | Not indexed |
| `BIM` | `SUBROUTINE` | `Z, CN, W` | [20465](source_parts/nswc_part_02.f90#L9924) | Not indexed |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [45379](source_parts/nswc_part_05.f90#L3058) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BJM` | `SUBROUTINE` | `Z, CN, W` | [20614](source_parts/nswc_part_02.f90#L10073) | Not indexed |
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [50833](source_parts/nswc_part_05.f90#L8512) | [Documented](docs/11-sparse-matrices.md#topic-245-01) |
| `BLKTR1` | `SUBROUTINE` | `N, AN, BN, CN, M, AM, BM, CM, IDIMY, Y, B, W1, W2, W3, WD, WW, WU, PRDCT, CPRDCT` | [106641](source_parts/nswc_part_11.f90#L578) | Not indexed |
| `BLKTRI` | `SUBROUTINE` | `IFLG, NP, N, AN, BN, CN, MP, M, AM, BM, CM, IDIMY, Y, IERROR, W` | [106472](source_parts/nswc_part_11.f90#L409) | Not indexed |
| `BLND` | `REAL FUNCTION` | `A, B` | [15095](source_parts/nswc_part_02.f90#L4554) | Not indexed |
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [68710](source_parts/nswc_part_07.f90#L5039) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-302-01) |
| `BNDACC` | `SUBROUTINE` | `G, MDG, NB, IP, IR, MT, JT` | [86592](source_parts/nswc_part_09.f90#L1683) | Not indexed |
| `BNDSL` | `SUBROUTINE` | `MODE, G, MDG, NB, IP, IR, X, N, RNORM, IERR` | [86782](source_parts/nswc_part_09.f90#L1873) | Not indexed |
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [47390](source_parts/nswc_part_05.f90#L5069) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45502](source_parts/nswc_part_05.f90#L3181) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [46458](source_parts/nswc_part_05.f90#L4137) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `BPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [14043](source_parts/nswc_part_02.f90#L3502) | Not indexed |
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [13724](source_parts/nswc_part_02.f90#L3183) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BRCMP1` | `REAL FUNCTION` | `MU, A, B, X, Y` | [14418](source_parts/nswc_part_02.f90#L3877) | Not indexed |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [14278](source_parts/nswc_part_02.f90#L3737) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [45330](source_parts/nswc_part_05.f90#L3009) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [100646](source_parts/nswc_part_10.f90#L5192) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-418-01) |
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [85886](source_parts/nswc_part_09.f90#L977) | [Documented](docs/18-curve-fitting.md#topic-375-01) |
| `BSLSQ1` | `SUBROUTINE` | `TAU, WGT, NTAU, Z, KZ, M, T, N, K, A, KA, WK, Q, IERR` | [88417](source_parts/nswc_part_09.f90#L3508) | Not indexed |
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [88350](source_parts/nswc_part_09.f90#L3441) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-389-01) |
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [47543](source_parts/nswc_part_05.f90#L5222) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [47624](source_parts/nswc_part_05.f90#L5303) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [85206](source_parts/nswc_part_09.f90#L297) | [Documented](docs/18-curve-fitting.md#topic-371-01) |
| `BSPVB` | `SUBROUTINE` | `T, K, JHIGH, J, X, LEFT, BLIST` | [85374](source_parts/nswc_part_09.f90#L465) | Not indexed |
| `BSPVD` | `SUBROUTINE` | `T, K, X, LEFT, DBIATX, IDIM, NDERIV, A` | [85427](source_parts/nswc_part_09.f90#L518) | Not indexed |
| `BSRH` | `FUNCTION` | `XLL, XRR, IZ, C, A, BH, F, SGN` | [107859](source_parts/nswc_part_11.f90#L1796) | Not indexed |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [17507](source_parts/nswc_part_02.f90#L6966) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [15765](source_parts/nswc_part_02.f90#L5224) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [19406](source_parts/nswc_part_02.f90#L8865) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [17135](source_parts/nswc_part_02.f90#L6594) | [Documented](docs/04-special-functions.md#topic-081-01) |
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [85560](source_parts/nswc_part_09.f90#L651) | [Documented](docs/18-curve-fitting.md#topic-373-01) |
| `BSTRP1` | `SUBROUTINE` | `X, Z, KZ, M, N, T, K, A, KA, WORK, IFLAG` | [88304](source_parts/nswc_part_09.f90#L3395) | Not indexed |
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [88248](source_parts/nswc_part_09.f90#L3339) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-388-01) |
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46055](source_parts/nswc_part_05.f90#L3734) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47134](source_parts/nswc_part_05.f90#L4813) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47179](source_parts/nswc_part_05.f90#L4858) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [35769](source_parts/nswc_part_04.f90#L3994) | [Documented](docs/08-matrices.md#topic-171-01) |
| `BUP` | `REAL FUNCTION` | `A, B, X, Y, N, EPS` | [14141](source_parts/nswc_part_02.f90#L3600) | Not indexed |
| `BUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, II, K1, K2, N, M, NP1` | [5043](source_parts/nswc_part_01.f90#L5043) | Not indexed |
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [84910](source_parts/nswc_part_09.f90#L1) | [Documented](docs/18-curve-fitting.md#topic-369-01) |
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [88605](source_parts/nswc_part_09.f90#L3696) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-391-01) |
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [85062](source_parts/nswc_part_09.f90#L153) | [Documented](docs/18-curve-fitting.md#topic-370-01) |
| `BVALI0` | `SUBROUTINE` | `T, TNEW, BCOEF, N, K, X, W, WK` | [85113](source_parts/nswc_part_09.f90#L204) | Not indexed |
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [46872](source_parts/nswc_part_05.f90#L4551) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [46918](source_parts/nswc_part_05.f90#L4597) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [19654](source_parts/nswc_part_02.f90#L9113) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CALCSC` | `SUBROUTINE` | `TYPE, N, K, QK` | [28296](source_parts/nswc_part_03.f90#L7074) | Not indexed |
| `CALCT` | `SUBROUTINE` | `BOOL, N, SR, SI, TR, TI, PVR, PVI, ARE, HR, HI, QHR, QHI` | [29115](source_parts/nswc_part_03.f90#L7893) | Not indexed |
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [2678](source_parts/nswc_part_01.f90#L2678) | [Documented](docs/02-elementary-operations.md#topic-028-02) |
| `CAUCHY` | `SUBROUTINE` | `NN, BND, PT, Q` | [28720](source_parts/nswc_part_03.f90#L7498) | Not indexed |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [30815](source_parts/nswc_part_03.f90#L9593) | [Documented](docs/07-vectors.md#topic-138-01) |
| `CBABK2` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [59032](source_parts/nswc_part_06.f90#L6102) | Not indexed |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [45920](source_parts/nswc_part_05.f90#L3599) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `CBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [58539](source_parts/nswc_part_06.f90#L5609) | Not indexed |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [27011](source_parts/nswc_part_03.f90#L5789) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `CBDB` | `SUBROUTINE` | `CZ, CNU, FN, W` | [15478](source_parts/nswc_part_02.f90#L4937) | Not indexed |
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [18394](source_parts/nswc_part_02.f90#L7853) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [48792](source_parts/nswc_part_05.f90#L6471) | Not indexed |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [20007](source_parts/nswc_part_02.f90#L9466) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CBJA` | `SUBROUTINE` | `CZ, CNU, W` | [15650](source_parts/nswc_part_02.f90#L5109) | Not indexed |
| `CBJM` | `SUBROUTINE` | `Z, CNU, W` | [15374](source_parts/nswc_part_02.f90#L4833) | Not indexed |
| `CBKA` | `SUBROUTINE` | `Z, CNU, W` | [18541](source_parts/nswc_part_02.f90#L8000) | Not indexed |
| `CBKI` | `SUBROUTINE` | `Z, CNU, W` | [18501](source_parts/nswc_part_02.f90#L7960) | Not indexed |
| `CBKM` | `SUBROUTINE` | `Z, RZ, CNU, W` | [18604](source_parts/nswc_part_02.f90#L8063) | Not indexed |
| `CBKML` | `SUBROUTINE` | `Z, R, ZR, NU, N, W, W0` | [18858](source_parts/nswc_part_02.f90#L8317) | Not indexed |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [29399](source_parts/nswc_part_03.f90#L8177) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45602](source_parts/nswc_part_05.f90#L3281) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [46734](source_parts/nswc_part_05.f90#L4413) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `CBRT` | `REAL FUNCTION` | `X` | [2386](source_parts/nswc_part_01.f90#L2386) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `CBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [48928](source_parts/nswc_part_05.f90#L6607) | Not indexed |
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48674](source_parts/nswc_part_05.f90#L6353) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48733](source_parts/nswc_part_05.f90#L6412) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [81558](source_parts/nswc_part_08.f90#L7187) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [17460](source_parts/nswc_part_02.f90#L6919) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [15173](source_parts/nswc_part_02.f90#L4632) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [18964](source_parts/nswc_part_02.f90#L8423) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46323](source_parts/nswc_part_05.f90#L4002) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47305](source_parts/nswc_part_05.f90#L4984) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47350](source_parts/nswc_part_05.f90#L5029) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47047](source_parts/nswc_part_05.f90#L4726) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47093](source_parts/nswc_part_05.f90#L4772) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [29638](source_parts/nswc_part_03.f90#L8416) | [Documented](docs/07-vectors.md#topic-130-01) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [41100](source_parts/nswc_part_04.f90#L9325) | [Documented](docs/08-matrices.md#topic-185-01) |
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [2557](source_parts/nswc_part_01.f90#L2557) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [2582](source_parts/nswc_part_01.f90#L2582) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [30546](source_parts/nswc_part_03.f90#L9324) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [30580](source_parts/nswc_part_03.f90#L9358) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CEEZ` | `SUBROUTINE` | `DEL1, DEL2, SIGMA, C1, C2, C3, N` | [84742](source_parts/nswc_part_08.f90#L10371) | Not indexed |
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [58408](source_parts/nswc_part_06.f90#L5478) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-273-01) |
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [58460](source_parts/nswc_part_06.f90#L5530) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-274-01) |
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [5150](source_parts/nswc_part_01.f90#L5150) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [5278](source_parts/nswc_part_01.f90#L5278) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERR` | `SUBROUTINE` | `T, FT, GT, PHIT, DEL, IERR, L, LP1, M, NP1, D` | [79422](source_parts/nswc_part_08.f90#L5051) | Not indexed |
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [8960](source_parts/nswc_part_01.f90#L8960) | [Documented](docs/04-special-functions.md#topic-062-01) |
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [7951](source_parts/nswc_part_01.f90#L7951) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `CFLECT` | `COMPLEX FUNCTION` | `Z` | [21722](source_parts/nswc_part_03.f90#L500) | Not indexed |
| `CFOD` | `SUBROUTINE` | `METH, ELCO, TESCO` | [104296](source_parts/nswc_part_10.f90#L8842) | Not indexed |
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [7604](source_parts/nswc_part_01.f90#L7604) | [Documented](docs/04-special-functions.md#topic-056-01) |
| `CGAM0` | `COMPLEX FUNCTION` | `Z` | [9594](source_parts/nswc_part_01.f90#L9594) | Not indexed |
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [9380](source_parts/nswc_part_01.f90#L9380) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `CGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [38740](source_parts/nswc_part_04.f90#L6965) | Not indexed |
| `CGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [39119](source_parts/nswc_part_04.f90#L7344) | Not indexed |
| `CGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [38919](source_parts/nswc_part_04.f90#L7144) | Not indexed |
| `CGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [39006](source_parts/nswc_part_04.f90#L7231) | Not indexed |
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [79119](source_parts/nswc_part_08.f90#L4748) | [Documented](docs/17-approximation-of-functions.md#topic-327-01) |
| `CHEBY1` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, LP1, MP1, LPM, N, NP1, X, XVAL, C, D, ERR, H` | [79157](source_parts/nswc_part_08.f90#L4786) | Not indexed |
| `CHKPRM` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, C, D, N, NBDCND, COFX, COFY, IDMN, MN, IERROR` | [106064](source_parts/nswc_part_11.f90#L1) | Not indexed |
| `CHKSNG` | `SUBROUTINE` | `MBDCND, NBDCND, ALPHA, BETA, GAMA, XNU, COFX, COFY, SINGLR` | [106117](source_parts/nswc_part_11.f90#L54) | Not indexed |
| `CIN` | `FUNCTION` | `X` | [8861](source_parts/nswc_part_01.f90#L8861) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [24405](source_parts/nswc_part_03.f90#L3183) | [Documented](docs/04-special-functions.md#topic-107-01) |
| `CK` | `COMPLEX FUNCTION` | `K, L` | [21522](source_parts/nswc_part_03.f90#L300) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKA` | `SUBROUTINE` | `Z, NU, W` | [19106](source_parts/nswc_part_02.f90#L8565) | Not indexed |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [21847](source_parts/nswc_part_03.f90#L625) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKM` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [19169](source_parts/nswc_part_02.f90#L8628) | Not indexed |
| `CKML` | `SUBROUTINE` | `Z, R, ZR, NU, K1, K2` | [19278](source_parts/nswc_part_02.f90#L8737) | Not indexed |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [32711](source_parts/nswc_part_04.f90#L936) | [Documented](docs/08-matrices.md#topic-160-01) |
| `CKPS` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [18730](source_parts/nswc_part_02.f90#L8189) | Not indexed |
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [60537](source_parts/nswc_part_06.f90#L7607) | [Documented](docs/13-l1-solution-of-linear-equations.md#topic-279-01) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [44222](source_parts/nswc_part_05.f90#L1901) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `CLI` | `COMPLEX FUNCTION` | `Z` | [9151](source_parts/nswc_part_01.f90#L9151) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `CLOC` | `LOGICAL FUNCTION` | `X, Y` | [32538](source_parts/nswc_part_04.f90#L763) | Not indexed |
| `CLUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [38645](source_parts/nswc_part_04.f90#L6870) | Not indexed |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32144](source_parts/nswc_part_04.f90#L369) | [Documented](docs/08-matrices.md#topic-151-01) |
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [32076](source_parts/nswc_part_04.f90#L301) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31599](source_parts/nswc_part_03.f90#L10377) | [Documented](docs/08-matrices.md#topic-147-01) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31586](source_parts/nswc_part_03.f90#L10364) | [Documented](docs/08-matrices.md#topic-146-01) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [45060](source_parts/nswc_part_05.f90#L2739) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [45235](source_parts/nswc_part_05.f90#L2914) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31535](source_parts/nswc_part_03.f90#L10313) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [32481](source_parts/nswc_part_04.f90#L706) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31522](source_parts/nswc_part_03.f90#L10300) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [38546](source_parts/nswc_part_04.f90#L6771) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [38581](source_parts/nswc_part_04.f90#L6806) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32204](source_parts/nswc_part_04.f90#L429) | [Documented](docs/08-matrices.md#topic-153-01) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32274](source_parts/nswc_part_04.f90#L499) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [53179](source_parts/nswc_part_06.f90#L249) | Not indexed |
| `COMPB` | `SUBROUTINE` | `N, IERROR, AN, BN, CN, B, AH, BH` | [107422](source_parts/nswc_part_11.f90#L1359) | Not indexed |
| `COMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [58822](source_parts/nswc_part_06.f90#L5892) | Not indexed |
| `COMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [59099](source_parts/nswc_part_06.f90#L6169) | Not indexed |
| `CONEW` | `FUNCTION` | `COND, ELINSY, RELRSD, AVERR, PASTC, PASTRE` | [99290](source_parts/nswc_part_10.f90#L3836) | Not indexed |
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [2848](source_parts/nswc_part_01.f90#L2848) | [Documented](docs/02-elementary-operations.md#topic-031-01) |
| `CORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [58709](source_parts/nswc_part_06.f90#L5779) | Not indexed |
| `COS0` | `REAL FUNCTION` | `X` | [2943](source_parts/nswc_part_01.f90#L2943) | Not indexed |
| `COS1` | `REAL FUNCTION` | `X` | [3018](source_parts/nswc_part_01.f90#L3018) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [77687](source_parts/nswc_part_08.f90#L3316) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQB1` | `SUBROUTINE` | `N, X, W, XH` | [77707](source_parts/nswc_part_08.f90#L3336) | Not indexed |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [77606](source_parts/nswc_part_08.f90#L3235) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQF1` | `SUBROUTINE` | `N, X, W, XH` | [77624](source_parts/nswc_part_08.f90#L3253) | Not indexed |
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [77557](source_parts/nswc_part_08.f90#L3186) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COVAR` | `SUBROUTINE` | `N, M1, N1, IPIVOT, C, D, Z, NN` | [67966](source_parts/nswc_part_07.f90#L4295) | Not indexed |
| `CPABS` | `REAL FUNCTION` | `X, Y` | [2481](source_parts/nswc_part_01.f90#L2481) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [49740](source_parts/nswc_part_05.f90#L7419) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [49796](source_parts/nswc_part_05.f90#L7475) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, W, Y` | [107198](source_parts/nswc_part_11.f90#L1135) | Not indexed |
| `CPRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, U, Y` | [107299](source_parts/nswc_part_11.f90#L1236) | Not indexed |
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [80507](source_parts/nswc_part_08.f90#L6136) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `CPSI` | `SUBROUTINE` | `Z, W` | [10566](source_parts/nswc_part_02.f90#L25) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `CQEXT` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES` | [75879](source_parts/nswc_part_08.f90#L1508) | Not indexed |
| `CQZHES` | `SUBROUTINE` | `NM, N, A, B, MATS, Z, F, G, H` | [43146](source_parts/nswc_part_05.f90#L825) | Not indexed |
| `CQZIT` | `SUBROUTINE` | `NM, N, A, B, EPS1, MATS, Z, F, IERR` | [43341](source_parts/nswc_part_05.f90#L1020) | Not indexed |
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [2517](source_parts/nswc_part_01.f90#L2517) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [32910](source_parts/nswc_part_04.f90#L1135) | [Documented](docs/08-matrices.md#topic-163-01) |
| `CROUT1` | `SUBROUTINE` | `A, KA, N, IEND, INDEX, TEMP, JP, IERR` | [73647](source_parts/nswc_part_07.f90#L9976) | Not indexed |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [49979](source_parts/nswc_part_05.f90#L7658) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [30685](source_parts/nswc_part_03.f90#L9463) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49453](source_parts/nswc_part_05.f90#L7132) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [25818](source_parts/nswc_part_03.f90#L4596) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49301](source_parts/nswc_part_05.f90#L6980) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [82502](source_parts/nswc_part_08.f90#L8131) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [82590](source_parts/nswc_part_08.f90#L8219) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [82690](source_parts/nswc_part_08.f90#L8319) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [83108](source_parts/nswc_part_08.f90#L8737) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `CSLOP1` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, A, B, C, E, IERR` | [83158](source_parts/nswc_part_08.f90#L8787) | Not indexed |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [53405](source_parts/nswc_part_06.f90#L475) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [53483](source_parts/nswc_part_06.f90#L553) | Not indexed |
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [38614](source_parts/nswc_part_04.f90#L6839) | [Documented](docs/08-matrices.md#topic-182-01) |
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [81882](source_parts/nswc_part_08.f90#L7511) | [Documented](docs/18-curve-fitting.md#topic-345-01) |
| `CSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [53652](source_parts/nswc_part_06.f90#L722) | Not indexed |
| `CSPP` | `SUBROUTINE` | `T, A, KA, M, N, Z, KZ, DZ, KDZ` | [87090](source_parts/nswc_part_09.f90#L2181) | Not indexed |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [50337](source_parts/nswc_part_05.f90#L8016) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [53093](source_parts/nswc_part_06.f90#L163) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49270](source_parts/nswc_part_05.f90#L6949) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [87375](source_parts/nswc_part_09.f90#L2466) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [87523](source_parts/nswc_part_09.f90#L2614) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [29941](source_parts/nswc_part_03.f90#L8719) | [Documented](docs/07-vectors.md#topic-132-01) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [30707](source_parts/nswc_part_03.f90#L9485) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50165](source_parts/nswc_part_05.f90#L7844) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [87182](source_parts/nswc_part_09.f90#L2273) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [87335](source_parts/nswc_part_09.f90#L2426) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [40470](source_parts/nswc_part_04.f90#L8695) | [Documented](docs/08-matrices.md#topic-183-01) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [29840](source_parts/nswc_part_03.f90#L8618) | [Documented](docs/07-vectors.md#topic-131-01) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [31901](source_parts/nswc_part_04.f90#L126) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31638](source_parts/nswc_part_03.f90#L10416) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50638](source_parts/nswc_part_05.f90#L8317) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50665](source_parts/nswc_part_05.f90#L8344) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [32089](source_parts/nswc_part_04.f90#L314) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [53526](source_parts/nswc_part_06.f90#L596) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [53604](source_parts/nswc_part_06.f90#L674) | Not indexed |
| `CUBRUL` | `SUBROUTINE` | `F, VEC, P, IDATA, RDATA` | [98602](source_parts/nswc_part_10.f90#L3148) | Not indexed |
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [98398](source_parts/nswc_part_10.f90#L2944) | [Documented](docs/22-numerical-integration.md#topic-408-01) |
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [83442](source_parts/nswc_part_08.f90#L9071) | [Documented](docs/18-curve-fitting.md#topic-357-01) |
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [83587](source_parts/nswc_part_08.f90#L9216) | [Documented](docs/18-curve-fitting.md#topic-359-01) |
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [83668](source_parts/nswc_part_08.f90#L9297) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [83742](source_parts/nswc_part_08.f90#L9371) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [44755](source_parts/nswc_part_05.f90#L2434) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [44564](source_parts/nswc_part_05.f90#L2243) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [44373](source_parts/nswc_part_05.f90#L2052) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [44819](source_parts/nswc_part_05.f90#L2498) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [44883](source_parts/nswc_part_05.f90#L2562) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [49116](source_parts/nswc_part_05.f90#L6795) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [44628](source_parts/nswc_part_05.f90#L2307) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [44692](source_parts/nswc_part_05.f90#L2371) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [49087](source_parts/nswc_part_05.f90#L6766) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50590](source_parts/nswc_part_05.f90#L8269) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50614](source_parts/nswc_part_05.f90#L8293) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [44437](source_parts/nswc_part_05.f90#L2116) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [44501](source_parts/nswc_part_05.f90#L2180) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [49058](source_parts/nswc_part_05.f90#L6737) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [49194](source_parts/nswc_part_05.f90#L6873) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [49170](source_parts/nswc_part_05.f90#L6849) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [49146](source_parts/nswc_part_05.f90#L6825) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CXP` | `COMPLEX FUNCTION` | `N, NU` | [19368](source_parts/nswc_part_02.f90#L8827) | Not indexed |
| `CYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [32564](source_parts/nswc_part_04.f90#L789) | Not indexed |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [41714](source_parts/nswc_part_04.f90#L9939) | [Documented](docs/08-matrices.md#topic-186-01) |
| `DABSV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [41787](source_parts/nswc_part_04.f90#L10012) | Not indexed |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [6983](source_parts/nswc_part_01.f90#L6983) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `DAORD` | `SUBROUTINE` | `A, N` | [1724](source_parts/nswc_part_01.f90#L1724) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [2452](source_parts/nswc_part_01.f90#L2452) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [30883](source_parts/nswc_part_03.f90#L9661) | [Documented](docs/07-vectors.md#topic-139-01) |
| `DAW` | `REAL FUNCTION` | `X` | [7260](source_parts/nswc_part_01.f90#L7260) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [30772](source_parts/nswc_part_03.f90#L9550) | [Documented](docs/07-vectors.md#topic-138-01) |
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [48568](source_parts/nswc_part_05.f90#L6247) | [Documented](docs/10-banded-matrices.md#topic-221-01) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [47487](source_parts/nswc_part_05.f90#L5166) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `DBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [56187](source_parts/nswc_part_06.f90#L3257) | Not indexed |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [45786](source_parts/nswc_part_05.f90#L3465) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `DBAL` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [55660](source_parts/nswc_part_06.f90#L2730) | Not indexed |
| `DBALNV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [55818](source_parts/nswc_part_06.f90#L2888) | Not indexed |
| `DBCORR` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [11885](source_parts/nswc_part_02.f90#L1344) | Not indexed |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [11743](source_parts/nswc_part_02.f90#L1202) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `DBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [48165](source_parts/nswc_part_05.f90#L5844) | Not indexed |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [47466](source_parts/nswc_part_05.f90#L5145) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [45552](source_parts/nswc_part_05.f90#L3231) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [46596](source_parts/nswc_part_05.f90#L4275) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `DBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [48333](source_parts/nswc_part_05.f90#L6012) | Not indexed |
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48003](source_parts/nswc_part_05.f90#L5682) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [48084](source_parts/nswc_part_05.f90#L5763) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [46189](source_parts/nswc_part_05.f90#L3868) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47219](source_parts/nswc_part_05.f90#L4898) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47265](source_parts/nswc_part_05.f90#L4944) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [46959](source_parts/nswc_part_05.f90#L4638) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [47006](source_parts/nswc_part_05.f90#L4685) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DCBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [60101](source_parts/nswc_part_06.f90#L7171) | Not indexed |
| `DCBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [59594](source_parts/nswc_part_06.f90#L6664) | Not indexed |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [27196](source_parts/nswc_part_03.f90#L5974) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [2404](source_parts/nswc_part_01.f90#L2404) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [59460](source_parts/nswc_part_06.f90#L6530) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-276-01) |
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [59513](source_parts/nswc_part_06.f90#L6583) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-277-01) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [5637](source_parts/nswc_part_01.f90#L5637) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [5915](source_parts/nswc_part_01.f90#L5915) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCFACT` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, IERR` | [39257](source_parts/nswc_part_04.f90#L7482) | Not indexed |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [9958](source_parts/nswc_part_01.f90#L9958) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DCMINV` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, TEMP` | [39441](source_parts/nswc_part_04.f90#L7666) | Not indexed |
| `DCMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [60168](source_parts/nswc_part_06.f90#L7238) | Not indexed |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [39229](source_parts/nswc_part_04.f90#L7454) | [Documented](docs/08-matrices.md#topic-178-01) |
| `DCOMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [59883](source_parts/nswc_part_06.f90#L6953) | Not indexed |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [29594](source_parts/nswc_part_03.f90#L8372) | [Documented](docs/07-vectors.md#topic-130-01) |
| `DCORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [59763](source_parts/nswc_part_06.f90#L6833) | Not indexed |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [3159](source_parts/nswc_part_01.f90#L3159) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [2499](source_parts/nswc_part_01.f90#L2499) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `DCPLY1` | `SUBROUTINE` | `OPR, OPI, IDEG, IDP1, ZEROR, ZEROI, PR, PI, QPR, QPI, HR, HI, QHR, QHI, SHR, SHI, NUM` | [28544](source_parts/nswc_part_03.f90#L7322) | Not indexed |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [28494](source_parts/nswc_part_03.f90#L7272) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [80736](source_parts/nswc_part_08.f90#L6365) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [10858](source_parts/nswc_part_02.f90#L317) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [2537](source_parts/nswc_part_01.f90#L2537) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [25844](source_parts/nswc_part_03.f90#L4622) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `DCSOL` | `SUBROUTINE` | `N, M, AR, AI, KA, BR, BI, KB, IPVT` | [39354](source_parts/nswc_part_04.f90#L7579) | Not indexed |
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [2618](source_parts/nswc_part_01.f90#L2618) | [Documented](docs/02-elementary-operations.md#topic-026-03) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [30503](source_parts/nswc_part_03.f90#L9281) | [Documented](docs/07-vectors.md#topic-136-01) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [1635](source_parts/nswc_part_01.f90#L1635) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DE1` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YY, WT, P, YP, YPOUT, PHI, ALPHA, BETA, SIG, V, W, G, PHASE1, PSI, X, H, HOLD, START, TOLD, DELSGN, NS, NORND, K, KOLD, ISNOLD` | [99972](source_parts/nswc_part_10.f90#L4518) | Not indexed |
| `DE1E` | `DOUBLE PRECISION FUNCTION` | `X` | [8442](source_parts/nswc_part_01.f90#L8442) | Not indexed |
| `DEC` | `SUBROUTINE` | `N, NDIM, A, IP, IER` | [33279](source_parts/nswc_part_04.f90#L1504) | Not indexed |
| `DECBT` | `SUBROUTINE` | `M, N, A, B, C, IP, IER` | [35784](source_parts/nswc_part_04.f90#L4009) | Not indexed |
| `DECOM2` | `SUBROUTINE` | `M, N, M1, ETA, TOL, QR, D, N1, IPIVOT, SING, MMPNN` | [67527](source_parts/nswc_part_07.f90#L3856) | Not indexed |
| `DEFER` | `SUBROUTINE` | `COFX, COFY, USOL, IDMN, GRHS, MN` | [106283](source_parts/nswc_part_11.f90#L220) | Not indexed |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [8407](source_parts/nswc_part_01.f90#L8407) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEI0` | `DOUBLE PRECISION FUNCTION` | `X, EPS` | [8696](source_parts/nswc_part_01.f90#L8696) | Not indexed |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [8424](source_parts/nswc_part_01.f90#L8424) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [55521](source_parts/nswc_part_06.f90#L2591) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-266-01) |
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [55569](source_parts/nswc_part_06.f90#L2639) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-267-01) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [22406](source_parts/nswc_part_03.f90#L1184) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [22620](source_parts/nswc_part_03.f90#L1398) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [1173](source_parts/nswc_part_01.f90#L1173) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [6310](source_parts/nswc_part_01.f90#L6310) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [6355](source_parts/nswc_part_01.f90#L6355) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC0` | `DOUBLE PRECISION FUNCTION` | `X` | [6479](source_parts/nswc_part_01.f90#L6479) | Not indexed |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [6411](source_parts/nswc_part_01.f90#L6411) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [6717](source_parts/nswc_part_01.f90#L6717) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `DESUM` | `DOUBLE PRECISION FUNCTION` | `MU, X` | [3348](source_parts/nswc_part_01.f90#L3348) | Not indexed |
| `DET` | `FUNCTION` | `A, KA, N, X` | [40977](source_parts/nswc_part_04.f90#L9202) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [109843](source_parts/nswc_part_11.f90#L3780) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `DGAM1` | `DOUBLE PRECISION FUNCTION` | `X` | [10341](source_parts/nswc_part_01.f90#L10341) | Not indexed |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [10491](source_parts/nswc_part_01.f90#L10491) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [10198](source_parts/nswc_part_01.f90#L10198) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [34390](source_parts/nswc_part_04.f90#L2615) | Not indexed |
| `DGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [34809](source_parts/nswc_part_04.f90#L3034) | Not indexed |
| `DGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [34594](source_parts/nswc_part_04.f90#L2819) | Not indexed |
| `DGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [34697](source_parts/nswc_part_04.f90#L2922) | Not indexed |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [13392](source_parts/nswc_part_02.f90#L2851) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `DGMLN1` | `DOUBLE PRECISION FUNCTION` | `X` | [10542](source_parts/nswc_part_02.f90#L1) | Not indexed |
| `DGNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [92381](source_parts/nswc_part_09.f90#L7472) | Not indexed |
| `DGR17` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [13291](source_parts/nswc_part_02.f90#L2750) | Not indexed |
| `DGR29` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [13091](source_parts/nswc_part_02.f90#L2550) | Not indexed |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [12820](source_parts/nswc_part_02.f90#L2279) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DGSMLN` | `DOUBLE PRECISION FUNCTION` | `A, B` | [11855](source_parts/nswc_part_02.f90#L1314) | Not indexed |
| `DH12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [64892](source_parts/nswc_part_07.f90#L1221) | Not indexed |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [64397](source_parts/nswc_part_07.f90#L726) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [64633](source_parts/nswc_part_07.f90#L962) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [55972](source_parts/nswc_part_06.f90#L3042) | Not indexed |
| `DHQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [56386](source_parts/nswc_part_06.f90#L3456) | Not indexed |
| `DINCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [92455](source_parts/nswc_part_09.f90#L7546) | Not indexed |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [1588](source_parts/nswc_part_01.f90#L1588) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [32686](source_parts/nswc_part_04.f90#L911) | [Documented](docs/08-matrices.md#topic-160-01) |
| `DLGDIV` | `DOUBLE PRECISION FUNCTION` | `A, B` | [11937](source_parts/nswc_part_02.f90#L1396) | Not indexed |
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [61408](source_parts/nswc_part_06.f90#L8478) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [3564](source_parts/nswc_part_01.f90#L3564) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DLOC` | `LOGICAL FUNCTION` | `X, Y` | [32446](source_parts/nswc_part_04.f90#L671) | Not indexed |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [62672](source_parts/nswc_part_06.f90#L9742) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32128](source_parts/nswc_part_04.f90#L353) | [Documented](docs/08-matrices.md#topic-151-01) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31573](source_parts/nswc_part_03.f90#L10351) | [Documented](docs/08-matrices.md#topic-146-01) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [45003](source_parts/nswc_part_05.f90#L2682) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [31414](source_parts/nswc_part_03.f90#L10192) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [45176](source_parts/nswc_part_05.f90#L2855) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [31456](source_parts/nswc_part_03.f90#L10234) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [92689](source_parts/nswc_part_09.f90#L7780) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMEVL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [92846](source_parts/nswc_part_09.f90#L7937) | Not indexed |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [43801](source_parts/nswc_part_05.f90#L1480) | [Documented](docs/08-matrices.md#topic-191-01) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [92231](source_parts/nswc_part_09.f90#L7322) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [32388](source_parts/nswc_part_04.f90#L613) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [34323](source_parts/nswc_part_04.f90#L2548) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [34358](source_parts/nswc_part_04.f90#L2583) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32188](source_parts/nswc_part_04.f90#L413) | [Documented](docs/08-matrices.md#topic-153-01) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32253](source_parts/nswc_part_04.f90#L478) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [31053](source_parts/nswc_part_03.f90#L9831) | [Documented](docs/07-vectors.md#topic-140-01) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [108813](source_parts/nswc_part_11.f90#L2750) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [109071](source_parts/nswc_part_11.f90#L3008) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [109196](source_parts/nswc_part_11.f90#L3133) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [52006](source_parts/nswc_part_05.f90#L9685) | Not indexed |
| `DOGLEG` | `SUBROUTINE` | `N, R, LR, DIAG, QTB, DELTA, X, WA1, WA2` | [70707](source_parts/nswc_part_07.f90#L7036) | Not indexed |
| `DONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [52931](source_parts/nswc_part_06.f90#L1) | Not indexed |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [2332](source_parts/nswc_part_01.f90#L2332) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [61570](source_parts/nswc_part_06.f90#L8640) | Not indexed |
| `DORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [55882](source_parts/nswc_part_06.f90#L2952) | Not indexed |
| `DORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [61461](source_parts/nswc_part_06.f90#L8531) | Not indexed |
| `DORTRN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [56246](source_parts/nswc_part_06.f90#L3316) | Not indexed |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25306](source_parts/nswc_part_03.f90#L4084) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [38104](source_parts/nswc_part_04.f90#L6329) | [Documented](docs/08-matrices.md#topic-176-01) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [25259](source_parts/nswc_part_03.f90#L4037) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [7358](source_parts/nswc_part_01.f90#L7358) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DPDAW0` | `DOUBLE PRECISION FUNCTION` | `X` | [7430](source_parts/nswc_part_01.f90#L7430) | Not indexed |
| `DPDEL` | `DOUBLE PRECISION FUNCTION` | `X` | [10311](source_parts/nswc_part_01.f90#L10311) | Not indexed |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [41039](source_parts/nswc_part_04.f90#L9264) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [25501](source_parts/nswc_part_03.f90#L4279) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [25706](source_parts/nswc_part_03.f90#L4484) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [44082](source_parts/nswc_part_05.f90#L1761) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [25601](source_parts/nswc_part_03.f90#L4379) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [1090](source_parts/nswc_part_01.f90#L1090) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25411](source_parts/nswc_part_03.f90#L4189) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [7204](source_parts/nswc_part_01.f90#L7204) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [49625](source_parts/nswc_part_05.f90#L7304) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [49681](source_parts/nswc_part_05.f90#L7360) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [38281](source_parts/nswc_part_04.f90#L6506) | Not indexed |
| `DPPFA` | `SUBROUTINE` | `AP, N, INFO` | [38127](source_parts/nswc_part_04.f90#L6352) | Not indexed |
| `DPPSL` | `SUBROUTINE` | `AP, N, B` | [38209](source_parts/nswc_part_04.f90#L6434) | Not indexed |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [11017](source_parts/nswc_part_02.f90#L476) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DPSI0` | `DOUBLE PRECISION FUNCTION` | `X` | [11174](source_parts/nswc_part_02.f90#L633) | Not indexed |
| `DPSLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [33532](source_parts/nswc_part_04.f90#L1757) | Not indexed |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25350](source_parts/nswc_part_03.f90#L4128) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [96513](source_parts/nswc_part_10.f90#L1059) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `DQAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [96678](source_parts/nswc_part_10.f90#L1224) | Not indexed |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [95805](source_parts/nswc_part_10.f90#L351) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [95963](source_parts/nswc_part_10.f90#L509) | Not indexed |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [26953](source_parts/nswc_part_03.f90#L5731) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [97360](source_parts/nswc_part_10.f90#L1906) | Not indexed |
| `DQK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [97093](source_parts/nswc_part_10.f90#L1639) | Not indexed |
| `DQK21` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [96367](source_parts/nswc_part_10.f90#L913) | Not indexed |
| `DQPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [97247](source_parts/nswc_part_10.f90#L1793) | Not indexed |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [27548](source_parts/nswc_part_03.f90#L6326) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQXCPY` | `SUBROUTINE` | `A, B, L` | [98048](source_parts/nswc_part_10.f90#L2594) | Not indexed |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [97517](source_parts/nswc_part_10.f90#L2063) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [97672](source_parts/nswc_part_10.f90#L2218) | Not indexed |
| `DQXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [98061](source_parts/nswc_part_10.f90#L2607) | Not indexed |
| `DQXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [98313](source_parts/nswc_part_10.f90#L2859) | Not indexed |
| `DQXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [98156](source_parts/nswc_part_10.f90#L2702) | Not indexed |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [109651](source_parts/nswc_part_11.f90#L3588) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [108570](source_parts/nswc_part_11.f90#L2507) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `DRCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [108595](source_parts/nswc_part_11.f90#L2532) | Not indexed |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [12439](source_parts/nswc_part_02.f90#L1898) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DRCVL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [23460](source_parts/nswc_part_03.f90#L2238) | Not indexed |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [22999](source_parts/nswc_part_03.f90#L1777) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [3399](source_parts/nswc_part_01.f90#L3399) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `DREXP1` | `SUBROUTINE` | `X, E, W` | [3481](source_parts/nswc_part_01.f90#L3481) | Not indexed |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [22794](source_parts/nswc_part_03.f90#L1572) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [109498](source_parts/nswc_part_11.f90#L3435) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [23239](source_parts/nswc_part_03.f90#L2017) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [3699](source_parts/nswc_part_01.f90#L3699) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [3763](source_parts/nswc_part_01.f90#L3763) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [110246](source_parts/nswc_part_11.f90#L4183) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [109362](source_parts/nswc_part_11.f90#L3299) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [32822](source_parts/nswc_part_04.f90#L1047) | [Documented](docs/08-matrices.md#topic-161-01) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [108722](source_parts/nswc_part_11.f90#L2659) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [29907](source_parts/nswc_part_03.f90#L8685) | [Documented](docs/07-vectors.md#topic-132-01) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [2761](source_parts/nswc_part_01.f90#L2761) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [30351](source_parts/nswc_part_03.f90#L9129) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [30216](source_parts/nswc_part_03.f90#L8994) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DRPLY1` | `SUBROUTINE` | `OP, IDEG, IDP1, ZEROR, ZEROI, P, QP, K, QK, SVK, TEMP, PT, NUM` | [27756](source_parts/nswc_part_03.f90#L6534) | Not indexed |
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [27709](source_parts/nswc_part_03.f90#L6487) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DRTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [56314](source_parts/nswc_part_06.f90#L3384) | Not indexed |
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [52713](source_parts/nswc_part_05.f90#L10392) | [Documented](docs/11-sparse-matrices.md#topic-256-01) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [50767](source_parts/nswc_part_05.f90#L8446) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [49917](source_parts/nswc_part_05.f90#L7596) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [30649](source_parts/nswc_part_03.f90#L9427) | [Documented](docs/07-vectors.md#topic-137-01) |
| `DSCALD` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [92667](source_parts/nswc_part_09.f90#L7758) | Not indexed |
| `DSCALP` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [92636](source_parts/nswc_part_09.f90#L7727) | Not indexed |
| `DSCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [41890](source_parts/nswc_part_04.f90#L10115) | Not indexed |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49424](source_parts/nswc_part_05.f90#L7103) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [57768](source_parts/nswc_part_06.f90#L4838) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-271-01) |
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [57789](source_parts/nswc_part_06.f90#L4859) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-272-01) |
| `DSHSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [42145](source_parts/nswc_part_04.f90#L10370) | Not indexed |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [3075](source_parts/nswc_part_01.f90#L3075) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [52229](source_parts/nswc_part_05.f90#L9908) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [52307](source_parts/nswc_part_05.f90#L9986) | Not indexed |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [36897](source_parts/nswc_part_04.f90#L5122) | [Documented](docs/08-matrices.md#topic-173-01) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [50742](source_parts/nswc_part_05.f90#L8421) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `DSORT` | `SUBROUTINE` | `A, N` | [1546](source_parts/nswc_part_01.f90#L1546) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [36930](source_parts/nswc_part_04.f90#L5155) | Not indexed |
| `DSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [37618](source_parts/nswc_part_04.f90#L5843) | Not indexed |
| `DSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [37222](source_parts/nswc_part_04.f90#L5447) | Not indexed |
| `DSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [52476](source_parts/nswc_part_05.f90#L10155) | Not indexed |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [50282](source_parts/nswc_part_05.f90#L7961) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `DSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [37464](source_parts/nswc_part_04.f90#L5689) | Not indexed |
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [51917](source_parts/nswc_part_05.f90#L9596) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50103](source_parts/nswc_part_05.f90#L7782) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `DSTOR2` | `SUBROUTINE` | `A, B` | [1026](source_parts/nswc_part_01.f90#L1026) | Not indexed |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [40000](source_parts/nswc_part_04.f90#L8225) | [Documented](docs/08-matrices.md#topic-183-01) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [32599](source_parts/nswc_part_04.f90#L824) | [Documented](docs/08-matrices.md#topic-157-01) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [29790](source_parts/nswc_part_03.f90#L8568) | [Documented](docs/07-vectors.md#topic-131-01) |
| `DSYMSV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [42707](source_parts/nswc_part_05.f90#L386) | Not indexed |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [42557](source_parts/nswc_part_05.f90#L236) | [Documented](docs/08-matrices.md#topic-188-01) |
| `DTASV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [42613](source_parts/nswc_part_05.f90#L292) | Not indexed |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [31776](source_parts/nswc_part_04.f90#L1) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [38466](source_parts/nswc_part_04.f90#L6691) | [Documented](docs/08-matrices.md#topic-177-01) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31625](source_parts/nswc_part_03.f90#L10403) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50539](source_parts/nswc_part_05.f90#L8218) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50566](source_parts/nswc_part_05.f90#L8245) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTQL` | `SUBROUTINE` | `N, D, E2, IERR` | [58016](source_parts/nswc_part_06.f90#L5086) | Not indexed |
| `DTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [58254](source_parts/nswc_part_06.f90#L5324) | Not indexed |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [110048](source_parts/nswc_part_11.f90#L3985) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `DTRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [57824](source_parts/nswc_part_06.f90#L4894) | Not indexed |
| `DTRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [58137](source_parts/nswc_part_06.f90#L5207) | Not indexed |
| `DTRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [57922](source_parts/nswc_part_06.f90#L4992) | Not indexed |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [52350](source_parts/nswc_part_05.f90#L10029) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [52428](source_parts/nswc_part_05.f90#L10107) | Not indexed |
| `DU11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [62961](source_parts/nswc_part_06.f90#L10031) | Not indexed |
| `DU11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [63392](source_parts/nswc_part_06.f90#L10462) | Not indexed |
| `DU12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [63241](source_parts/nswc_part_06.f90#L10311) | Not indexed |
| `DU12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [63672](source_parts/nswc_part_07.f90#L1) | Not indexed |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [108067](source_parts/nswc_part_11.f90#L2004) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `DURNG0` | `SUBROUTINE` | `IX, U, V` | [108182](source_parts/nswc_part_11.f90#L2119) | Not indexed |
| `DURNG1` | `SUBROUTINE` | `IX, U, V, D` | [108294](source_parts/nswc_part_11.f90#L2231) | Not indexed |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [108412](source_parts/nswc_part_11.f90#L2349) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50491](source_parts/nswc_part_05.f90#L8170) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50515](source_parts/nswc_part_05.f90#L8194) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DXFN` | `SUBROUTINE` | `U, IDMN, I, J, UXXX, UXXXX` | [106339](source_parts/nswc_part_11.f90#L276) | Not indexed |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [1243](source_parts/nswc_part_01.f90#L1243) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [32472](source_parts/nswc_part_04.f90#L697) | Not indexed |
| `DYFN` | `SUBROUTINE` | `U, IDMN, I, J, UYYY, UYYYY` | [106405](source_parts/nswc_part_11.f90#L342) | Not indexed |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [26340](source_parts/nswc_part_03.f90#L5118) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [53834](source_parts/nswc_part_06.f90#L904) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [53882](source_parts/nswc_part_06.f90#L952) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [53930](source_parts/nswc_part_06.f90#L1000) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [54020](source_parts/nswc_part_06.f90#L1090) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EKL` | `SUBROUTINE` | `L, FK, FL, EK, EL, GK, GL` | [22174](source_parts/nswc_part_03.f90#L952) | Not indexed |
| `EKM` | `SUBROUTINE` | `K2, FK, EK` | [22133](source_parts/nswc_part_03.f90#L911) | Not indexed |
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [23542](source_parts/nswc_part_03.f90#L2320) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [22268](source_parts/nswc_part_03.f90#L1046) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `ELMHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [54332](source_parts/nswc_part_06.f90#L1402) | Not indexed |
| `ELMHS0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [54414](source_parts/nswc_part_06.f90#L1484) | Not indexed |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [23902](source_parts/nswc_part_03.f90#L2680) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [54859](source_parts/nswc_part_06.f90#L1929) | Not indexed |
| `ELTRN0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [54920](source_parts/nswc_part_06.f90#L1990) | Not indexed |
| `ENORM` | `REAL FUNCTION` | `N, X` | [70621](source_parts/nswc_part_07.f90#L6950) | Not indexed |
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [22543](source_parts/nswc_part_03.f90#L1321) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `EPSLN` | `REAL FUNCTION` | `L` | [1142](source_parts/nswc_part_01.f90#L1142) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `ERF` | `REAL FUNCTION` | `X` | [5438](source_parts/nswc_part_01.f90#L5438) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC` | `REAL FUNCTION` | `X` | [5488](source_parts/nswc_part_01.f90#L5488) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC0` | `SUBROUTINE` | `IND, X, E, Y` | [24674](source_parts/nswc_part_03.f90#L3452) | Not indexed |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [5558](source_parts/nswc_part_01.f90#L5558) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFCM2` | `SUBROUTINE` | `MO, Z, W` | [6201](source_parts/nswc_part_01.f90#L6201) | Not indexed |
| `ERFCR` | `REAL FUNCTION` | `X` | [24753](source_parts/nswc_part_03.f90#L3531) | Not indexed |
| `ERFI` | `REAL FUNCTION` | `P, Q` | [6619](source_parts/nswc_part_01.f90#L6619) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `ERREV` | `DOUBLE PRECISION FUNCTION` | `NN, QR, QI, MS, MP, ARE, MRE` | [29220](source_parts/nswc_part_03.f90#L7998) | Not indexed |
| `ERRINT` | `DOUBLE PRECISION FUNCTION` | `F, FIT, AAA, BBB, POINTS, WEIGHT` | [80032](source_parts/nswc_part_08.f90#L5661) | Not indexed |
| `ESUM` | `REAL FUNCTION` | `MU, X` | [3325](source_parts/nswc_part_01.f90#L3325) | Not indexed |
| `EXPARG` | `REAL FUNCTION` | `L` | [1205](source_parts/nswc_part_01.f90#L1205) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [8123](source_parts/nswc_part_01.f90#L8123) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `EXTRA` | `SUBROUTINE` | `NEQN, YINC2, F2, T, H, YINC1, Y, F1, F, TEX, YEX, YPEX` | [101420](source_parts/nswc_part_10.f90#L5966) | Not indexed |
| `FDJAC1` | `SUBROUTINE` | `FCN, N, X, FVEC, FJAC, LDFJAC, IFLAG, ML, MU, EPSFCN, WA1, WA2` | [70856](source_parts/nswc_part_07.f90#L7185) | Not indexed |
| `FDJAC2` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FJAC, LDFJAC, IFLAG, EPSFCN, WA` | [70987](source_parts/nswc_part_07.f90#L7316) | Not indexed |
| `FEHL` | `SUBROUTINE` | `F, NEQN, Y, T, H, YP, F1, F2, F3, F4, F5, S` | [101895](source_parts/nswc_part_10.f90#L6441) | Not indexed |
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [76849](source_parts/nswc_part_08.f90#L2478) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [76866](source_parts/nswc_part_08.f90#L2495) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [69030](source_parts/nswc_part_07.f90#L5359) | [Documented](docs/15-optimization.md#topic-306-01) |
| `FPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [13970](source_parts/nswc_part_02.f90#L3429) | Not indexed |
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [109739](source_parts/nswc_part_11.f90#L3676) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `FRNL` | `SUBROUTINE` | `T, C, S` | [7759](source_parts/nswc_part_01.f90#L7759) | [Documented](docs/04-special-functions.md#topic-057-01) |
| `FSTOCD` | `SUBROUTINE` | `N, X, FCN, TYPSIZ, R, G` | [69761](source_parts/nswc_part_07.f90#L6090) | Not indexed |
| `FSTOFD` | `SUBROUTINE` | `N, X, FCN, FX, G, TYPSIZ, R` | [69726](source_parts/nswc_part_07.f90#L6055) | Not indexed |
| `FUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, I1, K1, N, M, NP1` | [5017](source_parts/nswc_part_01.f90#L5017) | Not indexed |
| `FXDEC` | `SUBROUTINE` | `FCN, N, X, FX, R` | [69607](source_parts/nswc_part_07.f90#L5936) | Not indexed |
| `FXSHFR` | `SUBROUTINE` | `L2, NZ, NN, P, QP, K, QK, SVK` | [27997](source_parts/nswc_part_03.f90#L6775) | Not indexed |
| `FXSHFT` | `SUBROUTINE` | `L2, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SHR, SHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [28825](source_parts/nswc_part_03.f90#L7603) | Not indexed |
| `GAM1` | `REAL FUNCTION` | `A` | [9814](source_parts/nswc_part_01.f90#L9814) | Not indexed |
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [12490](source_parts/nswc_part_02.f90#L1949) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `GAMLN` | `REAL FUNCTION` | `A` | [9862](source_parts/nswc_part_01.f90#L9862) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GAMLN1` | `REAL FUNCTION` | `A` | [9914](source_parts/nswc_part_01.f90#L9914) | Not indexed |
| `GAMMA` | `REAL FUNCTION` | `A` | [9624](source_parts/nswc_part_01.f90#L9624) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [101958](source_parts/nswc_part_10.f90#L6504) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-424-01) |
| `GERKS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, YP, H, F1, F2, F3, F4, F5, YG, YGP, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [102145](source_parts/nswc_part_10.f90#L6691) | Not indexed |
| `GETNP` | `SUBROUTINE` | `X, Y, IADJ, IEND, L, NPTS, DS, IER` | [90473](source_parts/nswc_part_09.f90#L5564) | Not indexed |
| `GLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [9754](source_parts/nswc_part_01.f90#L9754) | Not indexed |
| `GNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [91696](source_parts/nswc_part_09.f90#L6787) | Not indexed |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [89850](source_parts/nswc_part_09.f90#L4941) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADG1` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, EPS, NIT, ZXZY, IER` | [89891](source_parts/nswc_part_09.f90#L4982) | Not indexed |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [90068](source_parts/nswc_part_09.f90#L5159) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADL1` | `SUBROUTINE` | `N, K, X, Y, Z, IADJ, IEND, DX, DY, IER` | [90109](source_parts/nswc_part_09.f90#L5200) | Not indexed |
| `GRAT1` | `SUBROUTINE` | `A, X, R, P, Q, EPS` | [14657](source_parts/nswc_part_02.f90#L4116) | Not indexed |
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [12000](source_parts/nswc_part_02.f90#L1459) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `GSUMLN` | `REAL FUNCTION` | `A, B` | [11622](source_parts/nswc_part_02.f90#L1081) | Not indexed |
| `H12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [64313](source_parts/nswc_part_07.f90#L642) | Not indexed |
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [26438](source_parts/nswc_part_03.f90#L5216) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-124-01) |
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [4430](source_parts/nswc_part_01.f90#L4430) | [Documented](docs/03-geometry.md#topic-043-01) |
| `HC1` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, NP1, PC, AC, VR, VC, P, SUBR, RBUS, TOR, JR, K, IND0` | [4548](source_parts/nswc_part_01.f90#L4548) | Not indexed |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [63822](source_parts/nswc_part_07.f90#L151) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [64055](source_parts/nswc_part_07.f90#L384) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [54586](source_parts/nswc_part_06.f90#L1656) | Not indexed |
| `HQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [55121](source_parts/nswc_part_06.f90#L2191) | Not indexed |
| `HSTART` | `SUBROUTINE` | `F, NEQ, A, B, Y, YPRIME, ETOL, MORDER, SMALL, BIG, SPY, PV, YP, SF, RPAR, IPAR, H` | [103471](source_parts/nswc_part_10.f90#L8017) | Not indexed |
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [81183](source_parts/nswc_part_08.f90#L6812) | [Documented](docs/18-curve-fitting.md#topic-338-01) |
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [4043](source_parts/nswc_part_01.f90#L4043) | [Documented](docs/03-geometry.md#topic-041-01) |
| `HYBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, XTOL, MAXFEV, ML, MU, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, R, LR, QTF, WA1, WA2, WA3, WA4` | [26541](source_parts/nswc_part_03.f90#L5319) | Not indexed |
| `IA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20364](source_parts/nswc_part_02.f90#L9823) | Not indexed |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [31356](source_parts/nswc_part_03.f90#L10134) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [31321](source_parts/nswc_part_03.f90#L10099) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IEGS` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, X, T, NT, NUP, MUP, IER, CUTOFF, ROOTRT, UNITRD, NHALF, LUFACT, KMM, KMN, KNM, RHS, R, RH, DELN, TM, TN, XM, XMZ, WM, WN, OLDX, SAVE, XN, SAVE2, ASIDE, ASIDE3, IMKNN` | [98889](source_parts/nswc_part_10.f90#L3435) | Not indexed |
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [98721](source_parts/nswc_part_10.f90#L3267) | [Documented](docs/23-integral-equations.md#topic-410-01) |
| `IMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20404](source_parts/nswc_part_02.f90#L9863) | Not indexed |
| `IMTQL1` | `SUBROUTINE` | `N, D, E, IERR` | [57232](source_parts/nswc_part_06.f90#L4302) | Not indexed |
| `IMTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [57620](source_parts/nswc_part_06.f90#L4690) | Not indexed |
| `INCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [91767](source_parts/nswc_part_09.f90#L6858) | Not indexed |
| `INDXA` | `SUBROUTINE` | `I, IR, IDXA, NA` | [106914](source_parts/nswc_part_11.f90#L851) | Not indexed |
| `INDXB` | `SUBROUTINE` | `I, IR, IDX, IDP` | [106944](source_parts/nswc_part_11.f90#L881) | Not indexed |
| `INDXC` | `SUBROUTINE` | `I, IR, IDXC, NC` | [106929](source_parts/nswc_part_11.f90#L866) | Not indexed |
| `INFCTR` | `SUBROUTINE` | `N, IFACT, IPOWER, NEXP, NPOWER` | [32026](source_parts/nswc_part_04.f90#L251) | Not indexed |
| `INTADD` | `SUBROUTINE` | `KK, I1, I2, I3, IADJ, IEND` | [89104](source_parts/nswc_part_09.f90#L4195) | Not indexed |
| `INTRC1` | `SUBROUTINE` | `N, PX, PY, X, Y, Z, IADJ, IEND, IFLAG, ZXZY, IST, PZ, IER` | [90652](source_parts/nswc_part_09.f90#L5743) | Not indexed |
| `INTRP` | `SUBROUTINE` | `X, Y, XOUT, YOUT, YPOUT, NEQN, KOLD, PHI, PSI` | [100571](source_parts/nswc_part_10.f90#L5117) | Not indexed |
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [84857](source_parts/nswc_part_08.f90#L10486) | [Documented](docs/18-curve-fitting.md#topic-368-01) |
| `INTYD` | `SUBROUTINE` | `T, K, YH, NYH, DKY, IFLAG` | [103734](source_parts/nswc_part_10.f90#L8280) | Not indexed |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [2226](source_parts/nswc_part_01.f90#L2226) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `IPATH` | `SUBROUTINE` | `I, J, SUBR, RBUS, AR, PR, S, N, NP, I1, I2, K, JR, M, NP1` | [4950](source_parts/nswc_part_01.f90#L4950) | Not indexed |
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [1](source_parts/nswc_part_01.f90#L1) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [31286](source_parts/nswc_part_03.f90#L10064) | [Documented](docs/07-vectors.md#topic-141-01) |
| `ISHELL` | `SUBROUTINE` | `A, N` | [1282](source_parts/nswc_part_01.f90#L1282) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [14869](source_parts/nswc_part_02.f90#L4328) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `ISWAP` | `SUBROUTINE` | `N, IX, INCX, IY, INCY` | [29667](source_parts/nswc_part_03.f90#L8445) | Not indexed |
| `ITERT` | `SUBROUTINE` | `KERNEL, RHFCN, N, TN, WN, M, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, IFLG` | [99539](source_parts/nswc_part_10.f90#L4085) | Not indexed |
| `IUPD` | `SUBROUTINE` | `IA, IB, L, A1, A2, P1, P2, V1, V2, K1, N, M, NP1` | [5070](source_parts/nswc_part_01.f90#L5070) | Not indexed |
| `JA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20513](source_parts/nswc_part_02.f90#L9972) | Not indexed |
| `JAIRY` | `SUBROUTINE` | `X, RX, C, AI, DAI` | [16879](source_parts/nswc_part_02.f90#L6338) | Not indexed |
| `JMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [20553](source_parts/nswc_part_02.f90#L10012) | Not indexed |
| `JROT` | `SUBROUTINE` | `NR, N, H, I, A, B, R` | [70104](source_parts/nswc_part_07.f90#L6433) | Not indexed |
| `KA` | `SUBROUTINE` | `IND, Z, K1, K2` | [20662](source_parts/nswc_part_02.f90#L10121) | Not indexed |
| `KL` | `SUBROUTINE` | `L, FK, FL` | [21777](source_parts/nswc_part_03.f90#L555) | Not indexed |
| `KM` | `COMPLEX FUNCTION` | `K2` | [21741](source_parts/nswc_part_03.f90#L519) | Not indexed |
| `KML` | `SUBROUTINE` | `IND, Z, K1, K2` | [20715](source_parts/nswc_part_02.f90#L10174) | Not indexed |
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [32661](source_parts/nswc_part_04.f90#L886) | [Documented](docs/08-matrices.md#topic-160-01) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [33089](source_parts/nswc_part_04.f90#L1314) | [Documented](docs/08-matrices.md#topic-163-01) |
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [83903](source_parts/nswc_part_08.f90#L9532) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [84081](source_parts/nswc_part_08.f90#L9710) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [84180](source_parts/nswc_part_08.f90#L9809) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [84331](source_parts/nswc_part_08.f90#L9960) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [67078](source_parts/nswc_part_07.f90#L3407) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-299-01) |
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [75115](source_parts/nswc_part_08.f90#L744) | [Documented](docs/16-transforms.md#topic-317-01) |
| `LAINV1` | `SUBROUTINE` | `FUN, T, C, EPSRE, EPSAB, RESULT, ESTERR, NUM, IER` | [75698](source_parts/nswc_part_08.f90#L1327) | Not indexed |
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [43942](source_parts/nswc_part_05.f90#L1621) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `LEAVE` | `SUBROUTINE` | `IERSET, NF, MF, XV, TV, WV, ERROR, KERNEL, RHFCN, EP, IFLAG, X, T, NT, IER, EPS, ELINSY, TN, WN, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, XNORM` | [99434](source_parts/nswc_part_10.f90#L3980) | Not indexed |
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [25869](source_parts/nswc_part_03.f90#L4647) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [25894](source_parts/nswc_part_03.f90#L4672) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [26011](source_parts/nswc_part_03.f90#L4789) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [61009](source_parts/nswc_part_06.f90#L8079) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [61041](source_parts/nswc_part_06.f90#L8111) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-286-01) |
| `LLTSLV` | `SUBROUTINE` | `NR, N, A, X, B` | [69677](source_parts/nswc_part_07.f90#L6006) | Not indexed |
| `LMDIF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FTOL, XTOL, GTOL, MAXFEV, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, IPVT, QTF, WA1, WA2, WA3, WA4` | [70265](source_parts/nswc_part_07.f90#L6594) | Not indexed |
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [70158](source_parts/nswc_part_07.f90#L6487) | [Documented](docs/15-optimization.md#topic-309-01) |
| `LMPAR` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, DELTA, PAR, X, SDIAG, WA1, WA2` | [71078](source_parts/nswc_part_07.f90#L7407) | Not indexed |
| `LNSRCH` | `SUBROUTINE` | `N, X, F, G, P, XPLS, FPLS, FCN, MXTAKE, IRETCD, STEPMX, STEPTL, TYPSIZ` | [69798](source_parts/nswc_part_07.f90#L6127) | Not indexed |
| `LNSYS` | `SUBROUTINE` | `A, D, M, N, B, X, OPTION, IERR` | [99645](source_parts/nswc_part_10.f90#L4191) | Not indexed |
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [3827](source_parts/nswc_part_01.f90#L3827) | [Documented](docs/03-geometry.md#topic-039-01) |
| `LOGAM` | `REAL FUNCTION` | `X` | [15117](source_parts/nswc_part_02.f90#L4576) | Not indexed |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [83304](source_parts/nswc_part_08.f90#L8933) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [83379](source_parts/nswc_part_08.f90#L9008) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LPDP` | `SUBROUTINE` | `A, MDA, M, N1, N2, PRGOPT, X, WNORM, MODE, WS, IS` | [65782](source_parts/nswc_part_07.f90#L2111) | Not indexed |
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [64974](source_parts/nswc_part_07.f90#L1303) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-292-01) |
| `LSI` | `SUBROUTINE` | `W, MDW, MA, MG, N, PRGOPT, X, RNORM, MODE, WS, IP` | [65474](source_parts/nswc_part_07.f90#L1803) | Not indexed |
| `LSOD1` | `SUBROUTINE` | `F, NEQ, T, Y, TOUT, RTOL, ATOL, IDID, YPOUT, YH, YH1, EWT, SAVF, ACOR, WM, IWM, JAC, INTOUT, TSTOP, TOLFAC, DELSGN, RPAR, IPAR` | [103207](source_parts/nswc_part_10.f90#L7753) | Not indexed |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [61661](source_parts/nswc_part_06.f90#L8731) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [81031](source_parts/nswc_part_08.f90#L6660) | [Documented](docs/18-curve-fitting.md#topic-337-01) |
| `LUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [33714](source_parts/nswc_part_04.f90#L1939) | Not indexed |
| `MACH` | `SUBROUTINE` | `MO, N, IBETA, IMAX, IDMAX, IMACH, RMACH, DMACH` | [346](source_parts/nswc_part_01.f90#L346) | Not indexed |
| `MACH1` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [583](source_parts/nswc_part_01.f90#L583) | Not indexed |
| `MACH2` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [810](source_parts/nswc_part_01.f90#L810) | Not indexed |
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32112](source_parts/nswc_part_04.f90#L337) | [Documented](docs/08-matrices.md#topic-151-01) |
| `MC13D` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW` | [51028](source_parts/nswc_part_05.f90#L8707) | Not indexed |
| `MC13E` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, ARP, IB, NUM, LOWL, NUMB, PREV` | [51074](source_parts/nswc_part_05.f90#L8753) | Not indexed |
| `MC21A` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, IW` | [50870](source_parts/nswc_part_05.f90#L8549) | Not indexed |
| `MC21B` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, PR, ARP, CV, OUT` | [50919](source_parts/nswc_part_05.f90#L8598) | Not indexed |
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31548](source_parts/nswc_part_03.f90#L10326) | [Documented](docs/08-matrices.md#topic-146-01) |
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [44946](source_parts/nswc_part_05.f90#L2625) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31496](source_parts/nswc_part_03.f90#L10274) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [31399](source_parts/nswc_part_03.f90#L10177) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31509](source_parts/nswc_part_03.f90#L10287) | [Documented](docs/08-matrices.md#topic-144-01) |
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31483](source_parts/nswc_part_03.f90#L10261) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [45117](source_parts/nswc_part_05.f90#L2796) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [31429](source_parts/nswc_part_03.f90#L10207) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [92001](source_parts/nswc_part_09.f90#L7092) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MEVAL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [92157](source_parts/nswc_part_09.f90#L7248) | Not indexed |
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [43663](source_parts/nswc_part_05.f90#L1342) | [Documented](docs/08-matrices.md#topic-191-01) |
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [76878](source_parts/nswc_part_08.f90#L2507) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [76914](source_parts/nswc_part_08.f90#L2543) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [91151](source_parts/nswc_part_09.f90#L6242) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MINSOL` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTB` | [106201](source_parts/nswc_part_11.f90#L138) | Not indexed |
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [74169](source_parts/nswc_part_07.f90#L10498) | [Documented](docs/15-optimization.md#topic-315-01) |
| `MKP1` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5, BB, BL, X, XL, B, UBB, LX, LXI, F, PBL, Q, V, BS, PS, WS, XS, IWK` | [74372](source_parts/nswc_part_08.f90#L1) | Not indexed |
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [25762](source_parts/nswc_part_03.f90#L4540) | [Documented](docs/05-polynomials.md#topic-117-01) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [32295](source_parts/nswc_part_04.f90#L520) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [33617](source_parts/nswc_part_04.f90#L1842) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [33652](source_parts/nswc_part_04.f90#L1877) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [32172](source_parts/nswc_part_04.f90#L397) | [Documented](docs/08-matrices.md#topic-153-01) |
| `MTABLE` | `SUBROUTINE` | `DEGREE, DIMEN, NPOLYS, INDEXS, NEWKJ, ALFLP1` | [91570](source_parts/nswc_part_09.f90#L6661) | Not indexed |
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32232](source_parts/nswc_part_04.f90#L457) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50440](source_parts/nswc_part_05.f90#L8119) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50467](source_parts/nswc_part_05.f90#L8146) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50392](source_parts/nswc_part_05.f90#L8071) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [50416](source_parts/nswc_part_05.f90#L8095) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `NEWEST` | `SUBROUTINE` | `TYPE, UU, VV, NN, P, K` | [28385](source_parts/nswc_part_03.f90#L7163) | Not indexed |
| `NEWTON` | `SUBROUTINE` | `NL, NR, NI` | [80100](source_parts/nswc_part_08.f90#L5729) | Not indexed |
| `NEXTH` | `SUBROUTINE` | `BOOL, N, TR, TI, HR, HI, QPR, QPI, QHR, QHI` | [29166](source_parts/nswc_part_03.f90#L7944) | Not indexed |
| `NEXTK` | `SUBROUTINE` | `TYPE, N, QP, K, QK` | [28342](source_parts/nswc_part_03.f90#L7120) | Not indexed |
| `NORMLZ` | `SUBROUTINE` | `N, X, BETA` | [68359](source_parts/nswc_part_07.f90#L4688) | Not indexed |
| `NOSHFT` | `SUBROUTINE` | `L1, NN, TR, TI, ETA, PR, PI, HR, HI` | [28764](source_parts/nswc_part_03.f90#L7542) | Not indexed |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [33399](source_parts/nswc_part_04.f90#L1624) | [Documented](docs/08-matrices.md#topic-163-01) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [108776](source_parts/nswc_part_11.f90#L2713) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [108850](source_parts/nswc_part_11.f90#L2787) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [108975](source_parts/nswc_part_11.f90#L2912) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NSPIV1` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [51271](source_parts/nswc_part_05.f90#L8950) | Not indexed |
| `NSTERP` | `SUBROUTINE` | `TM, WM, XM, M, TN, WN, XN, N, KERNEL, RHFCN, RHS, KMN, NHALF, NUP` | [99206](source_parts/nswc_part_10.f90#L3752) | Not indexed |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [88080](source_parts/nswc_part_09.f90#L3171) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [99809](source_parts/nswc_part_10.f90#L4355) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-415-01) |
| `OPCHK1` | `SUBROUTINE` | `N, X, TYPSIZ, FSCALE, GRADTL, ITNLIM, RERR, STEPMX, IERR` | [69435](source_parts/nswc_part_07.f90#L5764) | Not indexed |
| `OPSTP` | `SUBROUTINE` | `N, XPLS, FPLS, GPLS, X, ITNCNT, ICSCMX, IERR, GRADTL, STEPTL, TYPSIZ, FSCALE, ITNLIM, IRETCD, MXTAKE, FSTACK, NS, SPTR` | [69507](source_parts/nswc_part_07.f90#L5836) | Not indexed |
| `OPTDRV` | `SUBROUTINE` | `MO, NR, N, X, FCN, TYPSIZ, FSCALE, RERR, ITNLIM, ITNCNT, GRADTL, STEPMX, STEPTL, XPLS, FPLS, GPLS, IERR, A, G, P, WRK0, WRK1, WRK2` | [69259](source_parts/nswc_part_07.f90#L5588) | Not indexed |
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [69187](source_parts/nswc_part_07.f90#L5516) | [Documented](docs/15-optimization.md#topic-307-01) |
| `ORIMP` | `SUBROUTINE` | `M, N, A, KA, QR, MS, S, IP, B, X, R, EXIT` | [61291](source_parts/nswc_part_06.f90#L8361) | Not indexed |
| `ORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [61199](source_parts/nswc_part_06.f90#L8269) | Not indexed |
| `ORTHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [54496](source_parts/nswc_part_06.f90#L1566) | Not indexed |
| `ORTHG` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTRB` | [106161](source_parts/nswc_part_11.f90#L98) | Not indexed |
| `ORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [61089](source_parts/nswc_part_06.f90#L8159) | Not indexed |
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [26063](source_parts/nswc_part_03.f90#L4841) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [26144](source_parts/nswc_part_03.f90#L4922) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [26200](source_parts/nswc_part_03.f90#L4978) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [54981](source_parts/nswc_part_06.f90#L2051) | Not indexed |
| `ORTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [55049](source_parts/nswc_part_06.f90#L2119) | Not indexed |
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25284](source_parts/nswc_part_03.f90#L4062) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `PARC` | `SUBROUTINE` | `I, II, UB, IFLAG, VB, LUB, LJ, LI, F, BB, Q, B, N, M, NP1, LX, LXI, LR, LRI, LUBI` | [74813](source_parts/nswc_part_08.f90#L442) | Not indexed |
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [4397](source_parts/nswc_part_01.f90#L4397) | [Documented](docs/03-geometry.md#topic-042-01) |
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [37822](source_parts/nswc_part_04.f90#L6047) | [Documented](docs/08-matrices.md#topic-176-01) |
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [81234](source_parts/nswc_part_08.f90#L6863) | [Documented](docs/18-curve-fitting.md#topic-339-01) |
| `PDEDGE` | `SUBROUTINE` | `EDGE, INDX, INDY, IERR` | [105311](source_parts/nswc_part_10.f90#L9857) | Not indexed |
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [82875](source_parts/nswc_part_08.f90#L8504) | [Documented](docs/18-curve-fitting.md#topic-353-01) |
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [25450](source_parts/nswc_part_03.f90#L4228) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [82771](source_parts/nswc_part_08.f90#L8400) | [Documented](docs/18-curve-fitting.md#topic-352-01) |
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [23990](source_parts/nswc_part_03.f90#L2768) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [24027](source_parts/nswc_part_03.f90#L2805) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [3901](source_parts/nswc_part_01.f90#L3901) | [Documented](docs/03-geometry.md#topic-040-01) |
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [81263](source_parts/nswc_part_08.f90#L6892) | [Documented](docs/18-curve-fitting.md#topic-340-01) |
| `PI1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, BB, KUB, BL, LB, PBL, V, XL, NP1, N5, BS, PS, WS, XS, IWK` | [74702](source_parts/nswc_part_08.f90#L331) | Not indexed |
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [25650](source_parts/nswc_part_03.f90#L4428) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `PJAC` | `SUBROUTINE` | `NEQ, Y, YH, NYH, EWT, FTEM, SAVF, WM, IWM, F, JAC, RPAR, IPAR` | [104412](source_parts/nswc_part_10.f90#L8958) | Not indexed |
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [24771](source_parts/nswc_part_03.f90#L3549) | [Documented](docs/04-special-functions.md#topic-109-01) |
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [25234](source_parts/nswc_part_03.f90#L4012) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [24066](source_parts/nswc_part_03.f90#L2844) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [24105](source_parts/nswc_part_03.f90#L2883) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [25551](source_parts/nswc_part_03.f90#L4329) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25372](source_parts/nswc_part_03.f90#L4150) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `PNDF` | `FUNCTION` | `X, IND` | [7115](source_parts/nswc_part_01.f90#L7115) | [Documented](docs/04-special-functions.md#topic-053-01) |
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [7149](source_parts/nswc_part_01.f90#L7149) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [2670](source_parts/nswc_part_01.f90#L2670) | [Documented](docs/02-elementary-operations.md#topic-028-01) |
| `POLYDD` | `DOUBLE PRECISION FUNCTION` | `X` | [80229](source_parts/nswc_part_08.f90#L5858) | Not indexed |
| `POLYEV` | `SUBROUTINE` | `N, SR, SI, PR, PI, QR, QI, PVR, PVI` | [29196](source_parts/nswc_part_03.f90#L7974) | Not indexed |
| `PPADD` | `SUBROUTINE` | `N, IERROR, A, C, CBP, BP, BH` | [107659](source_parts/nswc_part_11.f90#L1596) | Not indexed |
| `PPSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [107888](source_parts/nswc_part_11.f90#L1825) | Not indexed |
| `PPSPF` | `FUNCTION` | `X, IZ, C, A, BH` | [107903](source_parts/nswc_part_11.f90#L1840) | Not indexed |
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [85293](source_parts/nswc_part_09.f90#L384) | [Documented](docs/18-curve-fitting.md#topic-372-01) |
| `PROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, W, U` | [106979](source_parts/nswc_part_11.f90#L916) | Not indexed |
| `PRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, U, W` | [107080](source_parts/nswc_part_11.f90#L1017) | Not indexed |
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [82955](source_parts/nswc_part_08.f90#L8584) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [83028](source_parts/nswc_part_08.f90#L8657) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [107837](source_parts/nswc_part_11.f90#L1774) | Not indexed |
| `PSI` | `REAL FUNCTION` | `XX` | [10697](source_parts/nswc_part_02.f90#L156) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [11224](source_parts/nswc_part_02.f90#L683) | [Documented](docs/04-special-functions.md#topic-071-01) |
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [25328](source_parts/nswc_part_03.f90#L4106) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [93932](source_parts/nswc_part_09.f90#L9023) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `QAGI1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [76086](source_parts/nswc_part_08.f90#L1715) | Not indexed |
| `QAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [94096](source_parts/nswc_part_09.f90#L9187) | Not indexed |
| `QAGIE1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [76266](source_parts/nswc_part_08.f90#L1895) | Not indexed |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [93236](source_parts/nswc_part_09.f90#L8327) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [93392](source_parts/nswc_part_09.f90#L8483) | Not indexed |
| `QDCRT` | `SUBROUTINE` | `A, Z` | [26900](source_parts/nswc_part_03.f90#L5678) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [94769](source_parts/nswc_part_09.f90#L9860) | Not indexed |
| `QFORM` | `SUBROUTINE` | `M, N, Q, LDQ, WA` | [71310](source_parts/nswc_part_07.f90#L7639) | Not indexed |
| `QK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [94510](source_parts/nswc_part_09.f90#L9601) | Not indexed |
| `QK15I1` | `SUBROUTINE` | `F, PHI, Y, C, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [76694](source_parts/nswc_part_08.f90#L2323) | Not indexed |
| `QK21F` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [93795](source_parts/nswc_part_09.f90#L8886) | Not indexed |
| `QPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [94656](source_parts/nswc_part_09.f90#L9747) | Not indexed |
| `QRFAC` | `SUBROUTINE` | `M, N, A, LDA, PIVOT, IPVT, LIPVT, RDIAG, ACNORM, WA` | [71385](source_parts/nswc_part_07.f90#L7714) | Not indexed |
| `QRSOLV` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, X, SDIAG, WA` | [71528](source_parts/nswc_part_07.f90#L7857) | Not indexed |
| `QRUPDT` | `SUBROUTINE` | `NR, N, A, U, V` | [70046](source_parts/nswc_part_07.f90#L6375) | Not indexed |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [2072](source_parts/nswc_part_01.f90#L2072) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [1767](source_parts/nswc_part_01.f90#L1767) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [1919](source_parts/nswc_part_01.f90#L1919) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [92920](source_parts/nswc_part_09.f90#L8011) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [27403](source_parts/nswc_part_03.f90#L6181) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QUAD` | `SUBROUTINE` | `A, B, RESULT, K, EPSIL, NPTS, ICHECK, F` | [93045](source_parts/nswc_part_09.f90#L8136) | Not indexed |
| `QUADIT` | `SUBROUTINE` | `UU, VV, NZ, NN, P, QP, K, QK` | [28111](source_parts/nswc_part_03.f90#L6889) | Not indexed |
| `QUADPL` | `SUBROUTINE` | `A, B1, C, SR, SI, LR, LI` | [28448](source_parts/nswc_part_03.f90#L7226) | Not indexed |
| `QUADSD` | `SUBROUTINE` | `NN, U, V, P, Q, A, B` | [28425](source_parts/nswc_part_03.f90#L7203) | Not indexed |
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [84436](source_parts/nswc_part_08.f90#L10065) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [84639](source_parts/nswc_part_08.f90#L10268) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QXCPY` | `SUBROUTINE` | `A, B, L` | [95455](source_parts/nswc_part_10.f90#L1) | Not indexed |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [94924](source_parts/nswc_part_09.f90#L10015) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [95079](source_parts/nswc_part_09.f90#L10170) | Not indexed |
| `QXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [95468](source_parts/nswc_part_10.f90#L14) | Not indexed |
| `QXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [95720](source_parts/nswc_part_10.f90#L266) | Not indexed |
| `QXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [95563](source_parts/nswc_part_10.f90#L109) | Not indexed |
| `R1MPYQ` | `SUBROUTINE` | `M, N, A, LDA, V, W` | [71679](source_parts/nswc_part_07.f90#L8008) | Not indexed |
| `R1UPDT` | `SUBROUTINE` | `M, N, S, LS, U, V, W, SING` | [71750](source_parts/nswc_part_07.f90#L8079) | Not indexed |
| `RADB2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [78043](source_parts/nswc_part_08.f90#L3672) | Not indexed |
| `RADB3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [78092](source_parts/nswc_part_08.f90#L3721) | Not indexed |
| `RADB4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [78158](source_parts/nswc_part_08.f90#L3787) | Not indexed |
| `RADB5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [78252](source_parts/nswc_part_08.f90#L3881) | Not indexed |
| `RADBG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [78363](source_parts/nswc_part_08.f90#L3992) | Not indexed |
| `RADF2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [78640](source_parts/nswc_part_08.f90#L4269) | Not indexed |
| `RADF3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [78689](source_parts/nswc_part_08.f90#L4318) | Not indexed |
| `RADF4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [78753](source_parts/nswc_part_08.f90#L4382) | Not indexed |
| `RADF5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [78843](source_parts/nswc_part_08.f90#L4472) | Not indexed |
| `RADFG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [78950](source_parts/nswc_part_08.f90#L4579) | Not indexed |
| `RADIX` | `SUBROUTINE` | `IBETA` | [561](source_parts/nswc_part_01.f90#L561) | Not indexed |
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [109292](source_parts/nswc_part_11.f90#L3229) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `RARC` | `SUBROUTINE` | `IA, IB, AR, AC, PR, PC, VR, VC, K1, JJ, LL, N, M, NP1` | [5103](source_parts/nswc_part_01.f90#L5103) | Not indexed |
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [109563](source_parts/nswc_part_11.f90#L3500) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [29247](source_parts/nswc_part_03.f90#L8025) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [108472](source_parts/nswc_part_11.f90#L2409) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `RCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [108497](source_parts/nswc_part_11.f90#L2434) | Not indexed |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [12393](source_parts/nswc_part_02.f90#L1852) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `RCVAL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [23371](source_parts/nswc_part_03.f90#L2149) | Not indexed |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [22891](source_parts/nswc_part_03.f90#L1669) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `REALIT` | `SUBROUTINE` | `SSS, NZ, IFLAG, NN, P, QP, K, QK` | [28207](source_parts/nswc_part_03.f90#L6985) | Not indexed |
| `REXP` | `REAL FUNCTION` | `X` | [3371](source_parts/nswc_part_01.f90#L3371) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `REXP1` | `SUBROUTINE` | `X, E, W` | [3449](source_parts/nswc_part_01.f90#L3449) | Not indexed |
| `RFFTB` | `SUBROUTINE` | `N, R, WSAVE` | [77971](source_parts/nswc_part_08.f90#L3600) | Not indexed |
| `RFFTB1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [77979](source_parts/nswc_part_08.f90#L3608) | Not indexed |
| `RFFTF` | `SUBROUTINE` | `N, R, WSAVE` | [78567](source_parts/nswc_part_08.f90#L4196) | Not indexed |
| `RFFTF1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [78575](source_parts/nswc_part_08.f90#L4204) | Not indexed |
| `RFFTI` | `SUBROUTINE` | `N, WSAVE` | [77863](source_parts/nswc_part_08.f90#L3492) | Not indexed |
| `RFFTI1` | `SUBROUTINE` | `N, WA, IFAC` | [77871](source_parts/nswc_part_08.f90#L3500) | Not indexed |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [22698](source_parts/nswc_part_03.f90#L1476) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [109432](source_parts/nswc_part_11.f90#L3369) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [1453](source_parts/nswc_part_01.f90#L1453) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [23107](source_parts/nswc_part_03.f90#L1885) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [104997](source_parts/nswc_part_10.f90#L9543) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-431-01) |
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [105053](source_parts/nswc_part_10.f90#L9599) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-433-01) |
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [101464](source_parts/nswc_part_10.f90#L6010) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-421-01) |
| `RKFC` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, W, WP, X, HINT, H, Y1, Y2, F1, F2, F3, F4, F7, SAVRE, SAVAE, TOLD, NFE, JFLAG, KFLAG, ENDPNT, BLKOUT` | [100903](source_parts/nswc_part_10.f90#L5449) | Not indexed |
| `RKFS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YP, H, F1, F2, F3, F4, F5, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [101634](source_parts/nswc_part_10.f90#L6180) | Not indexed |
| `RLOC` | `LOGICAL FUNCTION` | `X, Y` | [32353](source_parts/nswc_part_04.f90#L578) | Not indexed |
| `RLOG` | `REAL FUNCTION` | `X` | [3609](source_parts/nswc_part_01.f90#L3609) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RLOG1` | `REAL FUNCTION` | `X` | [3654](source_parts/nswc_part_01.f90#L3654) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RMIN` | `FUNCTION` | `N, M, COND, UNITRD, AVERR` | [99251](source_parts/nswc_part_10.f90#L3797) | Not indexed |
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [110148](source_parts/nswc_part_11.f90#L4085) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `RNDERR` | `FUNCTION` | `X, A, Y, B` | [98584](source_parts/nswc_part_10.f90#L3130) | Not indexed |
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [32736](source_parts/nswc_part_04.f90#L961) | [Documented](docs/08-matrices.md#topic-161-01) |
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [108668](source_parts/nswc_part_11.f90#L2605) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `RNRM` | `REAL FUNCTION` | `X, Y, N, IFLAG` | [99269](source_parts/nswc_part_10.f90#L3815) | Not indexed |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [2278](source_parts/nswc_part_01.f90#L2278) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ROT3` | `SUBROUTINE` | `A, THETA` | [2812](source_parts/nswc_part_01.f90#L2812) | [Documented](docs/02-elementary-operations.md#topic-030-01) |
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [2697](source_parts/nswc_part_01.f90#L2697) | [Documented](docs/02-elementary-operations.md#topic-028-03) |
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [49510](source_parts/nswc_part_05.f90#L7189) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [49566](source_parts/nswc_part_05.f90#L7245) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RRSORT` | `SUBROUTINE` | `A, B, N` | [1500](source_parts/nswc_part_01.f90#L1500) | Not indexed |
| `RSCO` | `SUBROUTINE` | `RSAV, ISAV` | [103161](source_parts/nswc_part_10.f90#L7707) | Not indexed |
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49395](source_parts/nswc_part_05.f90#L7074) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [51494](source_parts/nswc_part_05.f90#L9173) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `RSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [51571](source_parts/nswc_part_05.f90#L9250) | Not indexed |
| `RSORT` | `SUBROUTINE` | `A, N` | [1411](source_parts/nswc_part_01.f90#L1411) | Not indexed |
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [52655](source_parts/nswc_part_05.f90#L10334) | [Documented](docs/11-sparse-matrices.md#topic-250-01) |
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [50714](source_parts/nswc_part_05.f90#L8393) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [49855](source_parts/nswc_part_05.f90#L7534) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [30846](source_parts/nswc_part_03.f90#L9624) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [30729](source_parts/nswc_part_03.f90#L9507) | [Documented](docs/07-vectors.md#topic-138-01) |
| `SCALCP` | `DOUBLE PRECISION FUNCTION` | `NN, PT, ETA, INFIN, SMALNO, BASE` | [28685](source_parts/nswc_part_03.f90#L7463) | Not indexed |
| `SCALDN` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [91979](source_parts/nswc_part_09.f90#L7070) | Not indexed |
| `SCALEX` | `SUBROUTINE` | `MO, X, TYPSIZ, N, IERR` | [69639](source_parts/nswc_part_07.f90#L5968) | Not indexed |
| `SCALPM` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [91948](source_parts/nswc_part_09.f90#L7039) | Not indexed |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [30919](source_parts/nswc_part_03.f90#L9697) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SCD` | `SUBROUTINE` | `U, K, L, F, S, C, D` | [23646](source_parts/nswc_part_03.f90#L2424) | Not indexed |
| `SCDF` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [23757](source_parts/nswc_part_03.f90#L2535) | Not indexed |
| `SCDJ` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [23819](source_parts/nswc_part_03.f90#L2597) | Not indexed |
| `SCDM` | `SUBROUTINE` | `U, K, S, C, D` | [23734](source_parts/nswc_part_03.f90#L2512) | Not indexed |
| `SCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [41338](source_parts/nswc_part_04.f90#L9563) | Not indexed |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [31160](source_parts/nswc_part_03.f90#L9938) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [81954](source_parts/nswc_part_08.f90#L7583) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [82040](source_parts/nswc_part_08.f90#L7669) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [82128](source_parts/nswc_part_08.f90#L7757) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49483](source_parts/nswc_part_05.f90#L7162) | [Documented](docs/11-sparse-matrices.md#topic-232-01) |
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [29550](source_parts/nswc_part_03.f90#L8328) | [Documented](docs/07-vectors.md#topic-130-01) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49244](source_parts/nswc_part_05.f90#L6923) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [49332](source_parts/nswc_part_05.f90#L7011) | [Documented](docs/11-sparse-matrices.md#topic-230-01) |
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [49218](source_parts/nswc_part_05.f90#L6897) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [30460](source_parts/nswc_part_03.f90#L9238) | [Documented](docs/07-vectors.md#topic-136-01) |
| `SECFAC` | `SUBROUTINE` | `NR, N, X, G, A, XPLS, GPLS, ITNCNT, TOL, NOUPDT, S, Y, W` | [69912](source_parts/nswc_part_07.f90#L6241) | Not indexed |
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [56786](source_parts/nswc_part_06.f90#L3856) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [56806](source_parts/nswc_part_06.f90#L3876) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [56852](source_parts/nswc_part_06.f90#L3922) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [56885](source_parts/nswc_part_06.f90#L3955) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [105126](source_parts/nswc_part_10.f90#L9672) | [Documented](docs/25-partial-differential-equations.md#topic-434-01) |
| `SEPEL1` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, AN, BN, CN, DN, UN, ZN, AM, BM, CM, DM, UM, ZM, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [105784](source_parts/nswc_part_10.f90#L10330) | Not indexed |
| `SEPELL` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [105356](source_parts/nswc_part_10.f90#L9902) | Not indexed |
| `SETRM` | `SUBROUTINE` | `XK, YK, ZK, XI, YI, ZI, S1, S2, R, ROW` | [90407](source_parts/nswc_part_09.f90#L5498) | Not indexed |
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [82219](source_parts/nswc_part_08.f90#L7848) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [82312](source_parts/nswc_part_08.f90#L7941) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [82406](source_parts/nswc_part_08.f90#L8035) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SFFT` | `SUBROUTINE` | `A, B, NTOT, N, NSPAN, ISN, IERR` | [76944](source_parts/nswc_part_08.f90#L2573) | Not indexed |
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [102442](source_parts/nswc_part_10.f90#L6988) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [102476](source_parts/nswc_part_10.f90#L7022) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [90589](source_parts/nswc_part_09.f90#L5680) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [90619](source_parts/nswc_part_09.f90#L5710) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SGBFA` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, INFO` | [104673](source_parts/nswc_part_10.f90#L9219) | Not indexed |
| `SGBSL` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, B, JOB` | [104836](source_parts/nswc_part_10.f90#L9382) | Not indexed |
| `SGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [33802](source_parts/nswc_part_04.f90#L2027) | Not indexed |
| `SGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [34221](source_parts/nswc_part_04.f90#L2446) | Not indexed |
| `SGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [34006](source_parts/nswc_part_04.f90#L2231) | Not indexed |
| `SGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [34109](source_parts/nswc_part_04.f90#L2334) | Not indexed |
| `SHELL` | `SUBROUTINE` | `A, N` | [1323](source_parts/nswc_part_01.f90#L1323) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [1365](source_parts/nswc_part_01.f90#L1365) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHIFTD` | `SUBROUTINE` | `NFRST, NLAST, KK, IARR` | [89240](source_parts/nswc_part_09.f90#L4331) | Not indexed |
| `SHRSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [41593](source_parts/nswc_part_04.f90#L9818) | Not indexed |
| `SI` | `FUNCTION` | `X` | [8762](source_parts/nswc_part_01.f90#L8762) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `SIGMA1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, KUB, UB, NP1, N5, LX, LR, BS, PS, WS, XS, IWK` | [74640](source_parts/nswc_part_08.f90#L269) | Not indexed |
| `SIN0` | `REAL FUNCTION` | `X` | [2923](source_parts/nswc_part_01.f90#L2923) | Not indexed |
| `SIN1` | `REAL FUNCTION` | `X` | [2961](source_parts/nswc_part_01.f90#L2961) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [77826](source_parts/nswc_part_08.f90#L3455) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [77773](source_parts/nswc_part_08.f90#L3402) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SKNP` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, N5, PS, WS, XS, IWK` | [74863](source_parts/nswc_part_08.f90#L492) | Not indexed |
| `SKNP1` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, PS, WS, XS, D, MIN, PBAR, WBAR, ZBAR` | [74905](source_parts/nswc_part_08.f90#L534) | Not indexed |
| `SLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [33447](source_parts/nswc_part_04.f90#L1672) | Not indexed |
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [33684](source_parts/nswc_part_04.f90#L1909) | [Documented](docs/08-matrices.md#topic-168-01) |
| `SLVS` | `SUBROUTINE` | `WM, IWM, X, TEM` | [104596](source_parts/nswc_part_10.f90#L9142) | Not indexed |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [32160](source_parts/nswc_part_04.f90#L385) | [Documented](docs/08-matrices.md#topic-151-01) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [31561](source_parts/nswc_part_03.f90#L10339) | [Documented](docs/08-matrices.md#topic-146-01) |
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [71915](source_parts/nswc_part_07.f90#L8244) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SMPLX1` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [71964](source_parts/nswc_part_07.f90#L8293) | Not indexed |
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [32641](source_parts/nswc_part_04.f90#L866) | [Documented](docs/08-matrices.md#topic-159-01) |
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [35972](source_parts/nswc_part_04.f90#L4197) | [Documented](docs/08-matrices.md#topic-173-01) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [32220](source_parts/nswc_part_04.f90#L445) | [Documented](docs/08-matrices.md#topic-153-01) |
| `SNBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [47705](source_parts/nswc_part_05.f90#L5384) | Not indexed |
| `SNBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [47873](source_parts/nswc_part_05.f90#L5552) | Not indexed |
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [3243](source_parts/nswc_part_01.f90#L3243) | [Documented](docs/02-elementary-operations.md#topic-035-01) |
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [50689](source_parts/nswc_part_05.f90#L8368) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [30946](source_parts/nswc_part_03.f90#L9724) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SOL` | `SUBROUTINE` | `N, NDIM, A, B, IP` | [33352](source_parts/nswc_part_04.f90#L1577) | Not indexed |
| `SOLBT` | `SUBROUTINE` | `M, N, A, B, C, Y, IP` | [35900](source_parts/nswc_part_04.f90#L4125) | Not indexed |
| `SOLVE2` | `SUBROUTINE` | `M, N, M1, A, B, W, N1, IPIVOT, QR, D, ETA, FAIL, NUMIT, DIGITX, X, RES, WRES, Y1, Y2, Y, F, G, MM, MMPNN` | [67724](source_parts/nswc_part_07.f90#L4053) | Not indexed |
| `SOLVE3` | `SUBROUTINE` | `F, M1, M, N1, QR, D, Y, MMPNN` | [67895](source_parts/nswc_part_07.f90#L4224) | Not indexed |
| `SONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [52771](source_parts/nswc_part_05.f90#L10450) | Not indexed |
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [81798](source_parts/nswc_part_08.f90#L7427) | [Documented](docs/18-curve-fitting.md#topic-344-01) |
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [86940](source_parts/nswc_part_09.f90#L2031) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-379-01) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [81666](source_parts/nswc_part_08.f90#L7295) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [68042](source_parts/nswc_part_07.f90#L4371) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `SPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [51739](source_parts/nswc_part_05.f90#L9418) | Not indexed |
| `SPMPAR` | `REAL FUNCTION` | `I` | [1038](source_parts/nswc_part_01.f90#L1038) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [50796](source_parts/nswc_part_05.f90#L8475) | [Documented](docs/11-sparse-matrices.md#topic-244-01) |
| `SPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [37999](source_parts/nswc_part_04.f90#L6224) | Not indexed |
| `SPPFA` | `SUBROUTINE` | `AP, N, INFO` | [37845](source_parts/nswc_part_04.f90#L6070) | Not indexed |
| `SPPSL` | `SUBROUTINE` | `AP, N, B` | [37927](source_parts/nswc_part_04.f90#L6152) | Not indexed |
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [50227](source_parts/nswc_part_05.f90#L7906) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [51185](source_parts/nswc_part_05.f90#L8864) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `SQUIN2` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD, EYE, TEMP, NW, TOL, MAXITS, IERR` | [42922](source_parts/nswc_part_05.f90#L601) | Not indexed |
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [42849](source_parts/nswc_part_05.f90#L528) | [Documented](docs/08-matrices.md#topic-189-01) |
| `SRCH` | `SUBROUTINE` | `FUN, COND, XL, ETA, X, NUM, IERR` | [75286](source_parts/nswc_part_08.f90#L915) | Not indexed |
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [29873](source_parts/nswc_part_03.f90#L8651) | [Documented](docs/07-vectors.md#topic-132-01) |
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [2710](source_parts/nswc_part_01.f90#L2710) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [30108](source_parts/nswc_part_03.f90#L8886) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [29976](source_parts/nswc_part_03.f90#L8754) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [30613](source_parts/nswc_part_03.f90#L9391) | [Documented](docs/07-vectors.md#topic-137-01) |
| `SSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [36005](source_parts/nswc_part_04.f90#L4230) | Not indexed |
| `SSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [36693](source_parts/nswc_part_04.f90#L4918) | Not indexed |
| `SSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [36297](source_parts/nswc_part_04.f90#L4522) | Not indexed |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [72767](source_parts/nswc_part_07.f90#L9096) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SSPLX1` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [72817](source_parts/nswc_part_07.f90#L9146) | Not indexed |
| `SSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [36539](source_parts/nswc_part_04.f90#L4764) | Not indexed |
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [50041](source_parts/nswc_part_05.f90#L7720) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [39530](source_parts/nswc_part_04.f90#L7755) | [Documented](docs/08-matrices.md#topic-183-01) |
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [29740](source_parts/nswc_part_03.f90#L8518) | [Documented](docs/07-vectors.md#topic-131-01) |
| `STEP1` | `SUBROUTINE` | `F, NEQN, Y, X, H, EPS, WT, START, HOLD, K, KOLD, CRASH, PHI, P, YP, PSI, ALPHA, BETA, SIG, V, W, G, PHASE1, NS, NORND` | [100120](source_parts/nswc_part_10.f90#L4666) | Not indexed |
| `STFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR, JAC` | [102518](source_parts/nswc_part_10.f90#L7064) | Not indexed |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [68391](source_parts/nswc_part_07.f90#L4720) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `STOD` | `SUBROUTINE` | `NEQ, Y, YH, NYH, YH1, EWT, SAVF, ACOR, WM, IWM, F, JAC, RPAR, IPAR` | [103812](source_parts/nswc_part_10.f90#L8358) | Not indexed |
| `STORE2` | `SUBROUTINE` | `A, B` | [798](source_parts/nswc_part_01.f90#L798) | Not indexed |
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [87564](source_parts/nswc_part_09.f90#L2655) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-384-01) |
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [87943](source_parts/nswc_part_09.f90#L3034) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `SVCO` | `SUBROUTINE` | `RSAV, ISAV` | [103183](source_parts/nswc_part_10.f90#L7729) | Not indexed |
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [32575](source_parts/nswc_part_04.f90#L800) | [Documented](docs/08-matrices.md#topic-157-01) |
| `SWAPD` | `SUBROUTINE` | `NIN1, NIN2, NOUT1, NOUT2, IADJ, IEND` | [89331](source_parts/nswc_part_09.f90#L4422) | Not indexed |
| `SWPTST` | `LOGICAL FUNCTION` | `IN1, IN2, IO1, IO2, X, Y` | [89506](source_parts/nswc_part_09.f90#L4597) | Not indexed |
| `SYMSLV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [42415](source_parts/nswc_part_05.f90#L94) | Not indexed |
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [42266](source_parts/nswc_part_04.f90#L10491) | [Documented](docs/08-matrices.md#topic-188-01) |
| `TASLV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [42322](source_parts/nswc_part_05.f90#L1) | Not indexed |
| `TERMS` | `SUBROUTINE` | `DIAG, SDIAG, SIGMA, DEL` | [84810](source_parts/nswc_part_08.f90#L10439) | Not indexed |
| `TINDX` | `INTEGER FUNCTION` | `NVERTX, NABOR, IADJ, IEND` | [89584](source_parts/nswc_part_09.f90#L4675) | Not indexed |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [31651](source_parts/nswc_part_03.f90#L10429) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [32623](source_parts/nswc_part_04.f90#L848) | [Documented](docs/08-matrices.md#topic-158-01) |
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [38386](source_parts/nswc_part_04.f90#L6611) | [Documented](docs/08-matrices.md#topic-177-01) |
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [31612](source_parts/nswc_part_03.f90#L10390) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [57465](source_parts/nswc_part_06.f90#L4535) | Not indexed |
| `TQLRAT` | `SUBROUTINE` | `N, D, E2, IERR` | [57110](source_parts/nswc_part_06.f90#L4180) | Not indexed |
| `TQLRT0` | `SUBROUTINE` | `N, D, E2, IERR` | [107539](source_parts/nswc_part_11.f90#L1476) | Not indexed |
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [109948](source_parts/nswc_part_11.f90#L3885) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `TRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [56918](source_parts/nswc_part_06.f90#L3988) | Not indexed |
| `TRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [57348](source_parts/nswc_part_06.f90#L4418) | Not indexed |
| `TRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [57016](source_parts/nswc_part_06.f90#L4086) | Not indexed |
| `TRFIND` | `SUBROUTINE` | `NST, PX, PY, X, Y, IADJ, IEND, I1, I2, I3` | [89618](source_parts/nswc_part_09.f90#L4709) | Not indexed |
| `TRISLV` | `SUBROUTINE` | `NM, N, U, V, L, F, TEMP, IERR` | [43576](source_parts/nswc_part_05.f90#L1255) | Not indexed |
| `TRISP` | `SUBROUTINE` | `N, A, B, C, D, U, Z` | [106244](source_parts/nswc_part_11.f90#L181) | Not indexed |
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [88669](source_parts/nswc_part_09.f90#L3760) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `TRP` | `FUNCTION` | `A, N, X, Y` | [80997](source_parts/nswc_part_08.f90#L6626) | [Documented](docs/18-curve-fitting.md#topic-336-01) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [51614](source_parts/nswc_part_05.f90#L9293) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `TSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [51691](source_parts/nswc_part_05.f90#L9370) | Not indexed |
| `TVAL` | `SUBROUTINE` | `X, Y, X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3, ZX1, ZX2, ZX3, ZY1, ZY2, ZY3, IFLAG, W, WX, WY, IER` | [90910](source_parts/nswc_part_09.f90#L6001) | Not indexed |
| `U11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [61875](source_parts/nswc_part_06.f90#L8945) | Not indexed |
| `U11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [62274](source_parts/nswc_part_06.f90#L9344) | Not indexed |
| `U12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [62154](source_parts/nswc_part_06.f90#L9224) | Not indexed |
| `U12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [62553](source_parts/nswc_part_06.f90#L9623) | Not indexed |
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [107918](source_parts/nswc_part_11.f90#L1855) | [Documented](docs/26-discrete-random-number-generation.md#topic-438-01) |
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [108005](source_parts/nswc_part_11.f90#L1942) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `URNG0` | `SUBROUTINE` | `IX, U, V` | [108128](source_parts/nswc_part_11.f90#L2065) | Not indexed |
| `URNG1` | `SUBROUTINE` | `IX, U, V, D` | [108236](source_parts/nswc_part_11.f90#L2173) | Not indexed |
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [108352](source_parts/nswc_part_11.f90#L2289) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [24147](source_parts/nswc_part_03.f90#L2925) | [Documented](docs/04-special-functions.md#topic-105-01) |
| `VNORM` | `FUNCTION` | `V, NCOMP` | [104963](source_parts/nswc_part_10.f90#L9509) | Not indexed |
| `VNWRMS` | `REAL FUNCTION` | `N, V, W` | [104977](source_parts/nswc_part_10.f90#L9523) | Not indexed |
| `VRSHFT` | `SUBROUTINE` | `L3, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [28980](source_parts/nswc_part_03.f90#L7758) | Not indexed |
| `WANDT` | `SUBROUTINE` | `WV, TV, N, A, B` | [99310](source_parts/nswc_part_10.f90#L3856) | Not indexed |
| `WNLIT` | `SUBROUTINE` | `W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM, IDOPE, DOPE, DONE` | [66713](source_parts/nswc_part_07.f90#L3042) | Not indexed |
| `WNLSM` | `SUBROUTINE` | `W, MDW, MME, MA, N, L, PRGOPT, X, RNORM, MODE, IPIVOT, ITYPE, WD, H, SCALE, Z, TEMP, D` | [66142](source_parts/nswc_part_07.f90#L2471) | Not indexed |
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [65932](source_parts/nswc_part_07.f90#L2261) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-296-01) |
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [81403](source_parts/nswc_part_08.f90#L7032) | [Documented](docs/18-curve-fitting.md#topic-341-01) |
| `XCOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [75590](source_parts/nswc_part_08.f90#L1219) | Not indexed |
| `XCONDX` | `FUNCTION` | `X, Y, C, FUN` | [75650](source_parts/nswc_part_08.f90#L1279) | Not indexed |
| `XCONDY` | `FUNCTION` | `X, Y, C, FUN` | [75674](source_parts/nswc_part_08.f90#L1303) | Not indexed |
| `XL1` | `SUBROUTINE` | `K, L, M, N, KLMD, KLM2D, NKLMD, N2D, Q, KODE, TOLER, ITER, X, RES, ERROR, CU, IU, S` | [60578](source_parts/nswc_part_06.f90#L7648) | Not indexed |
| `YCHG` | `SUBROUTINE` | `X, Y, YOLD` | [32379](source_parts/nswc_part_04.f90#L604) | Not indexed |
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [26242](source_parts/nswc_part_03.f90#L5020) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `ZZZJAC` | `SUBROUTINE` | `T, Y, PD, N, RPAR, IPAR` | [102504](source_parts/nswc_part_10.f90#L7050) | Not indexed |
