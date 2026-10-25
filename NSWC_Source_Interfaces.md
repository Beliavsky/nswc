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
| `ABCON` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [78671](source_parts/nswc_part_08.f90#L4217) | Not indexed |
| `ABCON1` | `SUBROUTINE` | `FUN, C, NUM, IERR` | [78853](source_parts/nswc_part_08.f90#L4399) | Not indexed |
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [43217](source_parts/nswc_part_05.f90#L714) | [Documented](docs/08-matrices.md#topic-186-01) |
| `ABSLV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [43295](source_parts/nswc_part_05.f90#L792) | Not indexed |
| `ACOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [78976](source_parts/nswc_part_08.f90#L4522) | Not indexed |
| `ACONDF` | `FUNCTION` | `X, Y, C, FUN` | [79040](source_parts/nswc_part_08.f90#L4586) | Not indexed |
| `ACONDG` | `FUNCTION` | `X, Y, C, FUN` | [79053](source_parts/nswc_part_08.f90#L4599) | Not indexed |
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [83156](source_parts/nswc_part_08.f90#L8702) | [Documented](docs/17-approximation-of-functions.md#topic-329-01) |
| `ADAPT1` | `SUBROUTINE` | `F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [83240](source_parts/nswc_part_08.f90#L8786) | Not indexed |
| `ADCHK` | `SUBROUTINE` | `` | [84033](source_parts/nswc_part_08.f90#L9579) | Not indexed |
| `ADCOMP` | `SUBROUTINE` | `F` | [83677](source_parts/nswc_part_08.f90#L9223) | Not indexed |
| `ADNODE` | `SUBROUTINE` | `KK, X, Y, IADJ, IEND, IER` | [93091](source_parts/nswc_part_09.f90#L8092) | Not indexed |
| `ADPUT` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [84086](source_parts/nswc_part_08.f90#L9632) | Not indexed |
| `ADSET` | `SUBROUTINE` | `XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR` | [83460](source_parts/nswc_part_08.f90#L9006) | Not indexed |
| `ADTAKE` | `SUBROUTINE` | `IERR` | [83598](source_parts/nswc_part_08.f90#L9144) | Not indexed |
| `ADTRAN` | `SUBROUTINE` | `D, POWERS` | [84166](source_parts/nswc_part_08.f90#L9712) | Not indexed |
| `AERF` | `REAL FUNCTION` | `X, H` | [7539](source_parts/nswc_part_01.f90#L7539) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `AI` | `REAL FUNCTION` | `X` | [22211](source_parts/nswc_part_03.f90#L1053) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AIA` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [21318](source_parts/nswc_part_03.f90#L160) | Not indexed |
| `AIE` | `REAL FUNCTION` | `X` | [22304](source_parts/nswc_part_03.f90#L1146) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `AII` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [21272](source_parts/nswc_part_03.f90#L114) | Not indexed |
| `AIMP` | `SUBROUTINE` | `X, R, PHI` | [22667](source_parts/nswc_part_03.f90#L1509) | Not indexed |
| `AIRM` | `SUBROUTINE` | `IND, Z, AI, AIP, BI, BIP` | [21188](source_parts/nswc_part_03.f90#L30) | Not indexed |
| `ALGDIV` | `REAL FUNCTION` | `A, B` | [13065](source_parts/nswc_part_02.f90#L2484) | Not indexed |
| `ALI` | `REAL FUNCTION` | `X` | [10427](source_parts/nswc_part_01.f90#L10427) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `ALLOT` | `SUBROUTINE` | `DEGREE, NPOLYS, NPTS, DIMEN, IWORK, IWKLEN, IREQD, DREQD, ERROR` | [95864](source_parts/nswc_part_10.f90#L173) | Not indexed |
| `ALNREL` | `REAL FUNCTION` | `A` | [4016](source_parts/nswc_part_01.f90#L4016) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [3330](source_parts/nswc_part_01.f90#L3330) | [Documented](docs/02-elementary-operations.md#topic-032-01) |
| `AORD` | `SUBROUTINE` | `A, N` | [1905](source_parts/nswc_part_01.f90#L1905) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `APSER` | `REAL FUNCTION` | `A, B, X, EPS` | [15430](source_parts/nswc_part_02.f90#L4849) | Not indexed |
| `ARCEBE` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, PIVOT, X` | [37447](source_parts/nswc_part_04.f90#L5700) | Not indexed |
| `ARCEBM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [37426](source_parts/nswc_part_04.f90#L5679) | Not indexed |
| `ARCEBS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, B, X` | [37402](source_parts/nswc_part_04.f90#L5655) | Not indexed |
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [36503](source_parts/nswc_part_04.f90#L4756) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARCEDC` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, IFLAG` | [36641](source_parts/nswc_part_04.f90#L4894) | Not indexed |
| `ARCEFE` | `SUBROUTINE` | `BLOCK, NRWBLK, NRWPIV, PIVOT, B` | [37373](source_parts/nswc_part_04.f90#L5626) | Not indexed |
| `ARCEFM` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, B, X` | [37352](source_parts/nswc_part_04.f90#L5605) | Not indexed |
| `ARCEFS` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLPIV, NOVRLP, B, X` | [37326](source_parts/nswc_part_04.f90#L5579) | Not indexed |
| `ARCEPC` | `SUBROUTINE` | `TOPBLK, NRWTOP, NOVRLP, BOTBLK, NRWBOT, NCLPIV, PIVOT, PIVMAX, IFLAG` | [36997](source_parts/nswc_part_04.f90#L5250) | Not indexed |
| `ARCEPR` | `SUBROUTINE` | `BLOCK, NRWBLK, NCLBLK, NRWPIV, PIVOT, PIVMAX, IFLAG` | [36891](source_parts/nswc_part_04.f90#L5144) | Not indexed |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [37107](source_parts/nswc_part_04.f90#L5360) | [Documented](docs/08-matrices.md#topic-169-01) |
| `ARTNQ` | `FUNCTION` | `Y, X` | [2848](source_parts/nswc_part_01.f90#L2848) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `ASIK` | `SUBROUTINE` | `X, FNU, KODE, FLGIK, RA, ARG, IN, TOL, Y` | [19881](source_parts/nswc_part_02.f90#L9300) | Not indexed |
| `ASJY` | `SUBROUTINE` | `FUNJY, X, FNU, FLGJY, IN, TOL, ELIM, Y, WK, IFLW` | [17962](source_parts/nswc_part_02.f90#L7381) | Not indexed |
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [77477](source_parts/nswc_part_08.f90#L3023) | [Documented](docs/15-optimization.md#topic-314-01) |
| `ASSGN1` | `SUBROUTINE` | `N, A, C, T, CH, LC, LR, LZ, NZ, RH, SLC, SLR, U, IERR` | [77494](source_parts/nswc_part_08.f90#L3040) | Not indexed |
| `ATN` | `COMPLEX FUNCTION` | `Z` | [23362](source_parts/nswc_part_03.f90#L2204) | Not indexed |
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [50838](source_parts/nswc_part_05.f90#L8335) | [Documented](docs/10-banded-matrices.md#topic-217-01) |
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [49790](source_parts/nswc_part_05.f90#L7287) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [47945](source_parts/nswc_part_05.f90#L5442) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `BALANC` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [56680](source_parts/nswc_part_06.f90#L3676) | Not indexed |
| `BALBAK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [57444](source_parts/nswc_part_06.f90#L4440) | Not indexed |
| `BALINV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [56850](source_parts/nswc_part_06.f90#L3846) | Not indexed |
| `BANFAC` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, IFLAG` | [89830](source_parts/nswc_part_09.f90#L4831) | Not indexed |
| `BANSLV` | `SUBROUTINE` | `W, NROWW, NROW, NBANDL, NBANDU, B` | [89945](source_parts/nswc_part_09.f90#L4946) | Not indexed |
| `BASIZ` | `SUBROUTINE` | `DEGREE, NPTS, DIMEN, NPOLYS, ERROR` | [96067](source_parts/nswc_part_10.f90#L376) | Not indexed |
| `BASYM` | `REAL FUNCTION` | `A, B, LAMBDA, EPS` | [16094](source_parts/nswc_part_02.f90#L5513) | Not indexed |
| `BCHFAC` | `SUBROUTINE` | `W, NB, N, DIAG, IFLAG` | [90091](source_parts/nswc_part_09.f90#L5092) | Not indexed |
| `BCHSLV` | `SUBROUTINE` | `W, NB, N, B` | [90204](source_parts/nswc_part_09.f90#L5205) | Not indexed |
| `BCHSV1` | `SUBROUTINE` | `W, NB, N, B, KB, M` | [92715](source_parts/nswc_part_09.f90#L7716) | Not indexed |
| `BCORR` | `REAL FUNCTION` | `A0, B0` | [13020](source_parts/nswc_part_02.f90#L2439) | Not indexed |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [47586](source_parts/nswc_part_05.f90#L5083) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [47705](source_parts/nswc_part_05.f90#L5202) | [Documented](docs/10-banded-matrices.md#topic-202-01) |
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [47569](source_parts/nswc_part_05.f90#L5066) | [Documented](docs/10-banded-matrices.md#topic-200-01) |
| `BDYADD` | `SUBROUTINE` | `KK, I1, I2, IADJ, IEND` | [93236](source_parts/nswc_part_09.f90#L8237) | Not indexed |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [19417](source_parts/nswc_part_02.f90#L8836) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [17493](source_parts/nswc_part_02.f90#L6912) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [12912](source_parts/nswc_part_02.f90#L2331) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [90260](source_parts/nswc_part_09.f90#L5261) | [Documented](docs/18-curve-fitting.md#topic-376-01) |
| `BFIT0` | `SUBROUTINE` | `NDATA, XDATA, YDATA, NORD, NBKPT, BKPT, NCONST, XCONST, YCONST, NDERIV, MODE, COEFF, RNORM, BF, G, MDG, W, MDW, WORK, IWORK` | [90496](source_parts/nswc_part_09.f90#L5497) | Not indexed |
| `BFRAC` | `REAL FUNCTION` | `A, B, X, Y, LAMBDA, EPS` | [15621](source_parts/nswc_part_02.f90#L5040) | Not indexed |
| `BGRAT` | `SUBROUTINE` | `A, B, X, Y, W, EPS, IERR` | [15924](source_parts/nswc_part_02.f90#L5343) | Not indexed |
| `BI` | `REAL FUNCTION` | `X` | [22401](source_parts/nswc_part_03.f90#L1243) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BIA` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [21577](source_parts/nswc_part_03.f90#L419) | Not indexed |
| `BIE` | `REAL FUNCTION` | `X` | [22535](source_parts/nswc_part_03.f90#L1377) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `BII` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [21520](source_parts/nswc_part_03.f90#L362) | Not indexed |
| `BIM` | `SUBROUTINE` | `Z, CN, W` | [21928](source_parts/nswc_part_03.f90#L770) | Not indexed |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [47654](source_parts/nswc_part_05.f90#L5151) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BJM` | `SUBROUTINE` | `Z, CN, W` | [22074](source_parts/nswc_part_03.f90#L916) | Not indexed |
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [53123](source_parts/nswc_part_06.f90#L119) | [Documented](docs/11-sparse-matrices.md#topic-245-01) |
| `BLKTR1` | `SUBROUTINE` | `N, AN, BN, CN, M, AM, BM, CM, IDIMY, Y, B, W1, W2, W3, WD, WW, WU, PRDCT, CPRDCT` | [113097](source_parts/nswc_part_11.f90#L6769) | Not indexed |
| `BLKTRI` | `SUBROUTINE` | `IFLG, NP, N, AN, BN, CN, MP, M, AM, BM, CM, IDIMY, Y, IERROR, W` | [112889](source_parts/nswc_part_11.f90#L6561) | Not indexed |
| `BLND` | `REAL FUNCTION` | `A, B` | [16438](source_parts/nswc_part_02.f90#L5857) | Not indexed |
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [71804](source_parts/nswc_part_07.f90#L8001) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-302-01) |
| `BNDACC` | `SUBROUTINE` | `G, MDG, NB, IP, IR, MT, JT` | [90798](source_parts/nswc_part_09.f90#L5799) | Not indexed |
| `BNDSL` | `SUBROUTINE` | `MODE, G, MDG, NB, IP, IR, X, N, RNORM, IERR` | [91012](source_parts/nswc_part_09.f90#L6013) | Not indexed |
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [49771](source_parts/nswc_part_05.f90#L7268) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [47786](source_parts/nswc_part_05.f90#L5283) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [48785](source_parts/nswc_part_05.f90#L6282) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `BPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [15464](source_parts/nswc_part_02.f90#L4883) | Not indexed |
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [15174](source_parts/nswc_part_02.f90#L4593) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BRCMP1` | `REAL FUNCTION` | `MU, A, B, X, Y` | [15807](source_parts/nswc_part_02.f90#L5226) | Not indexed |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [15689](source_parts/nswc_part_02.f90#L5108) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [47603](source_parts/nswc_part_05.f90#L5100) | [Documented](docs/10-banded-matrices.md#topic-201-01) |
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [106408](source_parts/nswc_part_11.f90#L80) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-418-01) |
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [90002](source_parts/nswc_part_09.f90#L5003) | [Documented](docs/18-curve-fitting.md#topic-375-01) |
| `BSLSQ1` | `SUBROUTINE` | `TAU, WGT, NTAU, Z, KZ, M, T, N, K, A, KA, WK, Q, IERR` | [92608](source_parts/nswc_part_09.f90#L7609) | Not indexed |
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [92553](source_parts/nswc_part_09.f90#L7554) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-389-01) |
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [49912](source_parts/nswc_part_05.f90#L7409) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [49991](source_parts/nswc_part_05.f90#L7488) | [Documented](docs/10-banded-matrices.md#topic-215-01) |
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [89317](source_parts/nswc_part_09.f90#L4318) | [Documented](docs/18-curve-fitting.md#topic-371-01) |
| `BSPVB` | `SUBROUTINE` | `T, K, JHIGH, J, X, LEFT, BLIST` | [89506](source_parts/nswc_part_09.f90#L4507) | Not indexed |
| `BSPVD` | `SUBROUTINE` | `T, K, X, LEFT, DBIATX, IDIM, NDERIV, A` | [89563](source_parts/nswc_part_09.f90#L4564) | Not indexed |
| `BSRH` | `FUNCTION` | `XLL, XRR, IZ, C, A, BH, F, SGN` | [114215](source_parts/nswc_part_11.f90#L7887) | Not indexed |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [19092](source_parts/nswc_part_02.f90#L8511) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [17188](source_parts/nswc_part_02.f90#L6607) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [20917](source_parts/nswc_part_02.f90#L10336) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [18750](source_parts/nswc_part_02.f90#L8169) | [Documented](docs/04-special-functions.md#topic-081-01) |
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [89696](source_parts/nswc_part_09.f90#L4697) | [Documented](docs/18-curve-fitting.md#topic-373-01) |
| `BSTRP1` | `SUBROUTINE` | `X, Z, KZ, M, N, T, K, A, KA, WORK, IFLAG` | [92518](source_parts/nswc_part_09.f90#L7519) | Not indexed |
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [92471](source_parts/nswc_part_09.f90#L7472) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-388-01) |
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [48365](source_parts/nswc_part_05.f90#L5862) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49501](source_parts/nswc_part_05.f90#L6998) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49548](source_parts/nswc_part_05.f90#L7045) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [37480](source_parts/nswc_part_04.f90#L5733) | [Documented](docs/08-matrices.md#topic-171-01) |
| `BUP` | `REAL FUNCTION` | `A, B, X, Y, N, EPS` | [15550](source_parts/nswc_part_02.f90#L4969) | Not indexed |
| `BUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, II, K1, K2, N, M, NP1` | [5527](source_parts/nswc_part_01.f90#L5527) | Not indexed |
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [89017](source_parts/nswc_part_09.f90#L4018) | [Documented](docs/18-curve-fitting.md#topic-369-01) |
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [92791](source_parts/nswc_part_09.f90#L7792) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-391-01) |
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [89184](source_parts/nswc_part_09.f90#L4185) | [Documented](docs/18-curve-fitting.md#topic-370-01) |
| `BVALI0` | `SUBROUTINE` | `T, TNEW, BCOEF, N, K, X, W, WK` | [89223](source_parts/nswc_part_09.f90#L4224) | Not indexed |
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49225](source_parts/nswc_part_05.f90#L6722) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49273](source_parts/nswc_part_05.f90#L6770) | [Documented](docs/10-banded-matrices.md#topic-207-01) |
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [21159](source_parts/nswc_part_03.f90#L1) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CALCSC` | `SUBROUTINE` | `TYPE, N, K, QK` | [29809](source_parts/nswc_part_03.f90#L8651) | Not indexed |
| `CALCT` | `SUBROUTINE` | `BOOL, N, SR, SI, TR, TI, PVR, PVI, ARE, HR, HI, QHR, QHI` | [30592](source_parts/nswc_part_03.f90#L9434) | Not indexed |
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [3070](source_parts/nswc_part_01.f90#L3070) | [Documented](docs/02-elementary-operations.md#topic-028-02) |
| `CAUCHY` | `SUBROUTINE` | `NN, BND, PT, Q` | [30306](source_parts/nswc_part_03.f90#L9148) | Not indexed |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [32425](source_parts/nswc_part_04.f90#L678) | [Documented](docs/07-vectors.md#topic-138-01) |
| `CBABK2` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [61849](source_parts/nswc_part_06.f90#L8845) | Not indexed |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [48225](source_parts/nswc_part_05.f90#L5722) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `CBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [61304](source_parts/nswc_part_06.f90#L8300) | Not indexed |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [28385](source_parts/nswc_part_03.f90#L7227) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `CBDB` | `SUBROUTINE` | `CZ, CNU, FN, W` | [16867](source_parts/nswc_part_02.f90#L6286) | Not indexed |
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [20008](source_parts/nswc_part_02.f90#L9427) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [51130](source_parts/nswc_part_05.f90#L8627) | Not indexed |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [21491](source_parts/nswc_part_03.f90#L333) | [Documented](docs/04-special-functions.md#topic-086-01) |
| `CBJA` | `SUBROUTINE` | `CZ, CNU, W` | [17096](source_parts/nswc_part_02.f90#L6515) | Not indexed |
| `CBJM` | `SUBROUTINE` | `Z, CNU, W` | [16767](source_parts/nswc_part_02.f90#L6186) | Not indexed |
| `CBKA` | `SUBROUTINE` | `Z, CNU, W` | [20143](source_parts/nswc_part_02.f90#L9562) | Not indexed |
| `CBKI` | `SUBROUTINE` | `Z, CNU, W` | [20121](source_parts/nswc_part_02.f90#L9540) | Not indexed |
| `CBKM` | `SUBROUTINE` | `Z, RZ, CNU, W` | [20187](source_parts/nswc_part_02.f90#L9606) | Not indexed |
| `CBKML` | `SUBROUTINE` | `Z, R, ZR, NU, N, W, W0` | [20418](source_parts/nswc_part_02.f90#L9837) | Not indexed |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [30848](source_parts/nswc_part_03.f90#L9690) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [47892](source_parts/nswc_part_05.f90#L5389) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [49078](source_parts/nswc_part_05.f90#L6575) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `CBRT` | `REAL FUNCTION` | `X` | [2816](source_parts/nswc_part_01.f90#L2816) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `CBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [51300](source_parts/nswc_part_05.f90#L8797) | Not indexed |
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [50970](source_parts/nswc_part_05.f90#L8467) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [51050](source_parts/nswc_part_05.f90#L8547) | [Documented](docs/10-banded-matrices.md#topic-223-01) |
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [85359](source_parts/nswc_part_09.f90#L360) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [19061](source_parts/nswc_part_02.f90#L8480) | [Documented](docs/04-special-functions.md#topic-082-01) |
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [16568](source_parts/nswc_part_02.f90#L5987) | [Documented](docs/04-special-functions.md#topic-079-01) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [20527](source_parts/nswc_part_02.f90#L9946) | [Documented](docs/04-special-functions.md#topic-084-01) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [48645](source_parts/nswc_part_05.f90#L6142) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49682](source_parts/nswc_part_05.f90#L7179) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49730](source_parts/nswc_part_05.f90#L7227) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49410](source_parts/nswc_part_05.f90#L6907) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49459](source_parts/nswc_part_05.f90#L6956) | [Documented](docs/10-banded-matrices.md#topic-211-01) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [31098](source_parts/nswc_part_03.f90#L9940) | [Documented](docs/07-vectors.md#topic-130-01) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [43147](source_parts/nswc_part_05.f90#L644) | [Documented](docs/08-matrices.md#topic-185-01) |
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [2958](source_parts/nswc_part_01.f90#L2958) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [2984](source_parts/nswc_part_01.f90#L2984) | [Documented](docs/02-elementary-operations.md#topic-026-02) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [32108](source_parts/nswc_part_04.f90#L361) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [32147](source_parts/nswc_part_04.f90#L400) | [Documented](docs/07-vectors.md#topic-136-01) |
| `CEEZ` | `SUBROUTINE` | `DEL1, DEL2, SIGMA, C1, C2, C3, N` | [88822](source_parts/nswc_part_09.f90#L3823) | Not indexed |
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [61267](source_parts/nswc_part_06.f90#L8263) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-273-01) |
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [61281](source_parts/nswc_part_06.f90#L8277) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-274-01) |
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [5625](source_parts/nswc_part_01.f90#L5625) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [5777](source_parts/nswc_part_01.f90#L5777) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `CERR` | `SUBROUTINE` | `T, FT, GT, PHIT, DEL, IERR, L, LP1, M, NP1, D` | [83116](source_parts/nswc_part_08.f90#L8662) | Not indexed |
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [10081](source_parts/nswc_part_01.f90#L10081) | [Documented](docs/04-special-functions.md#topic-062-01) |
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [8748](source_parts/nswc_part_01.f90#L8748) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `CFLECT` | `COMPLEX FUNCTION` | `Z` | [22980](source_parts/nswc_part_03.f90#L1822) | Not indexed |
| `CFOD` | `SUBROUTINE` | `METH, ELCO, TESCO` | [110543](source_parts/nswc_part_11.f90#L4215) | Not indexed |
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [8361](source_parts/nswc_part_01.f90#L8361) | [Documented](docs/04-special-functions.md#topic-056-01) |
| `CGAM0` | `COMPLEX FUNCTION` | `Z` | [10813](source_parts/nswc_part_02.f90#L232) | Not indexed |
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [10582](source_parts/nswc_part_02.f90#L1) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `CGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [40667](source_parts/nswc_part_04.f90#L8920) | Not indexed |
| `CGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [41095](source_parts/nswc_part_04.f90#L9348) | Not indexed |
| `CGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [40866](source_parts/nswc_part_04.f90#L9119) | Not indexed |
| `CGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [40975](source_parts/nswc_part_04.f90#L9228) | Not indexed |
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [82803](source_parts/nswc_part_08.f90#L8349) | [Documented](docs/17-approximation-of-functions.md#topic-327-01) |
| `CHEBY1` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, LP1, MP1, LPM, N, NP1, X, XVAL, C, D, ERR, H` | [82835](source_parts/nswc_part_08.f90#L8381) | Not indexed |
| `CHKPRM` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, C, D, N, NBDCND, COFX, COFY, IDMN, MN, IERROR` | [112413](source_parts/nswc_part_11.f90#L6085) | Not indexed |
| `CHKSNG` | `SUBROUTINE` | `MBDCND, NBDCND, ALPHA, BETA, GAMA, XNU, COFX, COFY, SINGLR` | [112480](source_parts/nswc_part_11.f90#L6152) | Not indexed |
| `CIN` | `FUNCTION` | `X` | [9966](source_parts/nswc_part_01.f90#L9966) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [25664](source_parts/nswc_part_03.f90#L4506) | [Documented](docs/04-special-functions.md#topic-107-01) |
| `CK` | `COMPLEX FUNCTION` | `K, L` | [22758](source_parts/nswc_part_03.f90#L1600) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKA` | `SUBROUTINE` | `Z, NU, W` | [20645](source_parts/nswc_part_02.f90#L10064) | Not indexed |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [23095](source_parts/nswc_part_03.f90#L1937) | [Documented](docs/04-special-functions.md#topic-089-01) |
| `CKM` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [20689](source_parts/nswc_part_02.f90#L10108) | Not indexed |
| `CKML` | `SUBROUTINE` | `Z, R, ZR, NU, K1, K2` | [20798](source_parts/nswc_part_02.f90#L10217) | Not indexed |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [34261](source_parts/nswc_part_04.f90#L2514) | [Documented](docs/08-matrices.md#topic-160-01) |
| `CKPS` | `SUBROUTINE` | `Z, R, ZR, NU, W1, W2` | [20300](source_parts/nswc_part_02.f90#L9719) | Not indexed |
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [63386](source_parts/nswc_part_06.f90#L10382) | [Documented](docs/13-l1-solution-of-linear-equations.md#topic-279-01) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [46500](source_parts/nswc_part_05.f90#L3997) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `CLI` | `COMPLEX FUNCTION` | `Z` | [10312](source_parts/nswc_part_01.f90#L10312) | [Documented](docs/04-special-functions.md#topic-063-01) |
| `CLOC` | `LOGICAL FUNCTION` | `X, Y` | [34097](source_parts/nswc_part_04.f90#L2350) | Not indexed |
| `CLUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [40585](source_parts/nswc_part_04.f90#L8838) | Not indexed |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [33735](source_parts/nswc_part_04.f90#L1988) | [Documented](docs/08-matrices.md#topic-151-01) |
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33663](source_parts/nswc_part_04.f90#L1916) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33255](source_parts/nswc_part_04.f90#L1508) | [Documented](docs/08-matrices.md#topic-147-01) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33245](source_parts/nswc_part_04.f90#L1498) | [Documented](docs/08-matrices.md#topic-146-01) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [47338](source_parts/nswc_part_05.f90#L4835) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [47512](source_parts/nswc_part_05.f90#L5009) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33205](source_parts/nswc_part_04.f90#L1458) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [34045](source_parts/nswc_part_04.f90#L2298) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33194](source_parts/nswc_part_04.f90#L1447) | [Documented](docs/08-matrices.md#topic-145-01) |
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [40475](source_parts/nswc_part_04.f90#L8728) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [40516](source_parts/nswc_part_04.f90#L8769) | [Documented](docs/08-matrices.md#topic-178-01) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [33785](source_parts/nswc_part_04.f90#L2038) | [Documented](docs/08-matrices.md#topic-153-01) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [33844](source_parts/nswc_part_04.f90#L2097) | [Documented](docs/08-matrices.md#topic-155-01) |
| `CNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [55813](source_parts/nswc_part_06.f90#L2809) | Not indexed |
| `COMPB` | `SUBROUTINE` | `N, IERROR, AN, BN, CN, B, AH, BH` | [113790](source_parts/nswc_part_11.f90#L7462) | Not indexed |
| `COMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [61618](source_parts/nswc_part_06.f90#L8614) | Not indexed |
| `COMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [61929](source_parts/nswc_part_06.f90#L8925) | Not indexed |
| `CONEW` | `FUNCTION` | `COND, ELINSY, RELRSD, AVERR, PASTC, PASTRE` | [104873](source_parts/nswc_part_10.f90#L9182) | Not indexed |
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [3285](source_parts/nswc_part_01.f90#L3285) | [Documented](docs/02-elementary-operations.md#topic-031-01) |
| `CORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [61487](source_parts/nswc_part_06.f90#L8483) | Not indexed |
| `COS0` | `REAL FUNCTION` | `X` | [3378](source_parts/nswc_part_01.f90#L3378) | Not indexed |
| `COS1` | `REAL FUNCTION` | `X` | [3442](source_parts/nswc_part_01.f90#L3442) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [81302](source_parts/nswc_part_08.f90#L6848) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQB1` | `SUBROUTINE` | `N, X, W, XH` | [81320](source_parts/nswc_part_08.f90#L6866) | Not indexed |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [81205](source_parts/nswc_part_08.f90#L6751) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COSQF1` | `SUBROUTINE` | `N, X, W, XH` | [81221](source_parts/nswc_part_08.f90#L6767) | Not indexed |
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [81137](source_parts/nswc_part_08.f90#L6683) | [Documented](docs/16-transforms.md#topic-324-01) |
| `COVAR` | `SUBROUTINE` | `N, M1, N1, IPIVOT, C, D, Z, NN` | [70887](source_parts/nswc_part_07.f90#L7084) | Not indexed |
| `CPABS` | `REAL FUNCTION` | `X, Y` | [2885](source_parts/nswc_part_01.f90#L2885) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [52100](source_parts/nswc_part_05.f90#L9597) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [52159](source_parts/nswc_part_05.f90#L9656) | [Documented](docs/11-sparse-matrices.md#topic-235-01) |
| `CPROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, W, Y` | [113571](source_parts/nswc_part_11.f90#L7243) | Not indexed |
| `CPRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, YY, M, A, B, C, D, U, Y` | [113669](source_parts/nswc_part_11.f90#L7341) | Not indexed |
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [84299](source_parts/nswc_part_08.f90#L9845) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `CPSI` | `SUBROUTINE` | `Z, W` | [11858](source_parts/nswc_part_02.f90#L1277) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `CQEXT` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES` | [79368](source_parts/nswc_part_08.f90#L4914) | Not indexed |
| `CQZHES` | `SUBROUTINE` | `NM, N, A, B, MATS, Z, F, G, H` | [45312](source_parts/nswc_part_05.f90#L2809) | Not indexed |
| `CQZIT` | `SUBROUTINE` | `NM, N, A, B, EPS1, MATS, Z, F, IERR` | [45521](source_parts/nswc_part_05.f90#L3018) | Not indexed |
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [2921](source_parts/nswc_part_01.f90#L2921) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [34384](source_parts/nswc_part_04.f90#L2637) | [Documented](docs/08-matrices.md#topic-163-01) |
| `CROUT1` | `SUBROUTINE` | `A, KA, N, IEND, INDEX, TEMP, JP, IERR` | [77255](source_parts/nswc_part_08.f90#L2801) | Not indexed |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [52339](source_parts/nswc_part_05.f90#L9836) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [32270](source_parts/nswc_part_04.f90#L523) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51808](source_parts/nswc_part_05.f90#L9305) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [27031](source_parts/nswc_part_03.f90#L5873) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51674](source_parts/nswc_part_05.f90#L9171) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [86400](source_parts/nswc_part_09.f90#L1401) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [86501](source_parts/nswc_part_09.f90#L1502) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [86616](source_parts/nswc_part_09.f90#L1617) | [Documented](docs/18-curve-fitting.md#topic-351-01) |
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [87081](source_parts/nswc_part_09.f90#L2082) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `CSLOP1` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, A, B, C, E, IERR` | [87116](source_parts/nswc_part_09.f90#L2117) | Not indexed |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [56086](source_parts/nswc_part_06.f90#L3082) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [56185](source_parts/nswc_part_06.f90#L3181) | Not indexed |
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [40555](source_parts/nswc_part_04.f90#L8808) | [Documented](docs/08-matrices.md#topic-182-01) |
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [85713](source_parts/nswc_part_09.f90#L714) | [Documented](docs/18-curve-fitting.md#topic-345-01) |
| `CSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [56377](source_parts/nswc_part_06.f90#L3373) | Not indexed |
| `CSPP` | `SUBROUTINE` | `T, A, KA, M, N, Z, KZ, DZ, KDZ` | [91326](source_parts/nswc_part_09.f90#L6327) | Not indexed |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [52679](source_parts/nswc_part_05.f90#L10176) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [55698](source_parts/nswc_part_06.f90#L2694) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51648](source_parts/nswc_part_05.f90#L9145) | [Documented](docs/11-sparse-matrices.md#topic-229-01) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [91605](source_parts/nswc_part_09.f90#L6606) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [91755](source_parts/nswc_part_09.f90#L6756) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [31444](source_parts/nswc_part_03.f90#L10286) | [Documented](docs/07-vectors.md#topic-132-01) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [32298](source_parts/nswc_part_04.f90#L551) | [Documented](docs/07-vectors.md#topic-137-01) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [52516](source_parts/nswc_part_05.f90#L10013) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [91435](source_parts/nswc_part_09.f90#L6436) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [91590](source_parts/nswc_part_09.f90#L6591) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-381-01) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [42504](source_parts/nswc_part_05.f90#L1) | [Documented](docs/08-matrices.md#topic-183-01) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [31331](source_parts/nswc_part_03.f90#L10173) | [Documented](docs/07-vectors.md#topic-131-01) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [33513](source_parts/nswc_part_04.f90#L1766) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33285](source_parts/nswc_part_04.f90#L1538) | [Documented](docs/08-matrices.md#topic-148-01) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52939](source_parts/nswc_part_05.f90#L10436) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52963](source_parts/nswc_part_05.f90#L10460) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [33673](source_parts/nswc_part_04.f90#L1926) | [Documented](docs/08-matrices.md#topic-150-01) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [56227](source_parts/nswc_part_06.f90#L3223) | [Documented](docs/11-sparse-matrices.md#topic-258-01) |
| `CTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [56326](source_parts/nswc_part_06.f90#L3322) | Not indexed |
| `CUBRUL` | `SUBROUTINE` | `F, VEC, P, IDATA, RDATA` | [104217](source_parts/nswc_part_10.f90#L8526) | Not indexed |
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [104010](source_parts/nswc_part_10.f90#L8319) | [Documented](docs/22-numerical-integration.md#topic-408-01) |
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [87413](source_parts/nswc_part_09.f90#L2414) | [Documented](docs/18-curve-fitting.md#topic-357-01) |
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [87568](source_parts/nswc_part_09.f90#L2569) | [Documented](docs/18-curve-fitting.md#topic-359-01) |
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [87657](source_parts/nswc_part_09.f90#L2658) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [87738](source_parts/nswc_part_09.f90#L2739) | [Documented](docs/18-curve-fitting.md#topic-360-01) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [47036](source_parts/nswc_part_05.f90#L4533) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [46854](source_parts/nswc_part_05.f90#L4351) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [46672](source_parts/nswc_part_05.f90#L4169) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [47102](source_parts/nswc_part_05.f90#L4599) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [47168](source_parts/nswc_part_05.f90#L4665) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [51495](source_parts/nswc_part_05.f90#L8992) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [46920](source_parts/nswc_part_05.f90#L4417) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [46986](source_parts/nswc_part_05.f90#L4483) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [51465](source_parts/nswc_part_05.f90#L8962) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52899](source_parts/nswc_part_05.f90#L10396) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52919](source_parts/nswc_part_05.f90#L10416) | [Documented](docs/11-sparse-matrices.md#topic-241-01) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [46738](source_parts/nswc_part_05.f90#L4235) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [46804](source_parts/nswc_part_05.f90#L4301) | [Documented](docs/10-banded-matrices.md#topic-196-01) |
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [51435](source_parts/nswc_part_05.f90#L8932) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [51578](source_parts/nswc_part_05.f90#L9075) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [51552](source_parts/nswc_part_05.f90#L9049) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [51526](source_parts/nswc_part_05.f90#L9023) | [Documented](docs/11-sparse-matrices.md#topic-226-01) |
| `CXP` | `COMPLEX FUNCTION` | `N, NU` | [20889](source_parts/nswc_part_02.f90#L10308) | Not indexed |
| `CYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [34128](source_parts/nswc_part_04.f90#L2381) | Not indexed |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [43794](source_parts/nswc_part_05.f90#L1291) | [Documented](docs/08-matrices.md#topic-186-01) |
| `DABSV1` | `SUBROUTINE` | `MO, M, N, A, NA, U, NU, B, NB, V, NV, C, NC, WK, IERR` | [43872](source_parts/nswc_part_05.f90#L1369) | Not indexed |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [7661](source_parts/nswc_part_01.f90#L7661) | [Documented](docs/04-special-functions.md#topic-052-01) |
| `DAORD` | `SUBROUTINE` | `A, N` | [1952](source_parts/nswc_part_01.f90#L1952) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [2866](source_parts/nswc_part_01.f90#L2866) | [Documented](docs/02-elementary-operations.md#topic-024-02) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [32504](source_parts/nswc_part_04.f90#L757) | [Documented](docs/07-vectors.md#topic-139-01) |
| `DAW` | `REAL FUNCTION` | `X` | [7915](source_parts/nswc_part_01.f90#L7915) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [32376](source_parts/nswc_part_04.f90#L629) | [Documented](docs/07-vectors.md#topic-138-01) |
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [50903](source_parts/nswc_part_05.f90#L8400) | [Documented](docs/10-banded-matrices.md#topic-221-01) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [49860](source_parts/nswc_part_05.f90#L7357) | [Documented](docs/10-banded-matrices.md#topic-213-01) |
| `DBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, Z` | [58865](source_parts/nswc_part_06.f90#L5861) | Not indexed |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [48085](source_parts/nswc_part_05.f90#L5582) | [Documented](docs/10-banded-matrices.md#topic-204-01) |
| `DBAL` | `SUBROUTINE` | `NM, N, A, LOW, IGH, SCALE` | [58292](source_parts/nswc_part_06.f90#L5288) | Not indexed |
| `DBALNV` | `SUBROUTINE` | `NZ, N, Z, LOW, IGH, SCALE` | [58462](source_parts/nswc_part_06.f90#L5458) | Not indexed |
| `DBCORR` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [13229](source_parts/nswc_part_02.f90#L2648) | Not indexed |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [13122](source_parts/nswc_part_02.f90#L2541) | [Documented](docs/04-special-functions.md#topic-076-01) |
| `DBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [50533](source_parts/nswc_part_05.f90#L8030) | Not indexed |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [49840](source_parts/nswc_part_05.f90#L7337) | [Documented](docs/10-banded-matrices.md#topic-214-01) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [47839](source_parts/nswc_part_05.f90#L5336) | [Documented](docs/10-banded-matrices.md#topic-203-01) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [48931](source_parts/nswc_part_05.f90#L6428) | [Documented](docs/10-banded-matrices.md#topic-206-01) |
| `DBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [50703](source_parts/nswc_part_05.f90#L8200) | Not indexed |
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [50375](source_parts/nswc_part_05.f90#L7872) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [50454](source_parts/nswc_part_05.f90#L7951) | [Documented](docs/10-banded-matrices.md#topic-219-01) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [48505](source_parts/nswc_part_05.f90#L6002) | [Documented](docs/10-banded-matrices.md#topic-205-01) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49592](source_parts/nswc_part_05.f90#L7089) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49641](source_parts/nswc_part_05.f90#L7138) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49318](source_parts/nswc_part_05.f90#L6815) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [49368](source_parts/nswc_part_05.f90#L6865) | [Documented](docs/10-banded-matrices.md#topic-209-01) |
| `DCBABK` | `SUBROUTINE` | `NM, N, LOW, IGH, SCALE, M, ZR, ZI` | [62908](source_parts/nswc_part_06.f90#L9904) | Not indexed |
| `DCBAL` | `SUBROUTINE` | `NM, N, AR, AI, LOW, IGH, SCALE` | [62369](source_parts/nswc_part_06.f90#L9365) | Not indexed |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [28580](source_parts/nswc_part_03.f90#L7422) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [2831](source_parts/nswc_part_01.f90#L2831) | [Documented](docs/02-elementary-operations.md#topic-024-01) |
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [62329](source_parts/nswc_part_06.f90#L9325) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-276-01) |
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [62343](source_parts/nswc_part_06.f90#L9339) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-277-01) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [6191](source_parts/nswc_part_01.f90#L6191) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [6469](source_parts/nswc_part_01.f90#L6469) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DCFACT` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, IERR` | [41261](source_parts/nswc_part_04.f90#L9514) | Not indexed |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [11224](source_parts/nswc_part_02.f90#L643) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DCMINV` | `SUBROUTINE` | `AR, AI, KA, N, IPVT, TEMP` | [41452](source_parts/nswc_part_04.f90#L9705) | Not indexed |
| `DCMQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, ORTR, ORTI, HR, HI, WR, WI, ZR, ZI, IERR` | [62989](source_parts/nswc_part_06.f90#L9985) | Not indexed |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [41228](source_parts/nswc_part_04.f90#L9481) | [Documented](docs/08-matrices.md#topic-178-01) |
| `DCOMQR` | `SUBROUTINE` | `NM, N, LOW, IGH, HR, HI, WR, WI, IERR` | [62681](source_parts/nswc_part_06.f90#L9677) | Not indexed |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [31047](source_parts/nswc_part_03.f90#L9889) | [Documented](docs/07-vectors.md#topic-130-01) |
| `DCORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, AR, AI, ORTR, ORTI` | [62551](source_parts/nswc_part_06.f90#L9547) | Not indexed |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [3587](source_parts/nswc_part_01.f90#L3587) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [2901](source_parts/nswc_part_01.f90#L2901) | [Documented](docs/02-elementary-operations.md#topic-024-03) |
| `DCPLY1` | `SUBROUTINE` | `OPR, OPI, IDEG, IDP1, ZEROR, ZEROI, PR, PI, QPR, QPI, HR, HI, QHR, QHI, SHR, SHI, NUM` | [30116](source_parts/nswc_part_03.f90#L8958) | Not indexed |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [30049](source_parts/nswc_part_03.f90#L8891) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [84537](source_parts/nswc_part_08.f90#L10083) | [Documented](docs/17-approximation-of-functions.md#topic-333-01) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [12167](source_parts/nswc_part_02.f90#L1586) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [2938](source_parts/nswc_part_01.f90#L2938) | [Documented](docs/02-elementary-operations.md#topic-026-01) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [27055](source_parts/nswc_part_03.f90#L5897) | [Documented](docs/05-polynomials.md#topic-118-01) |
| `DCSOL` | `SUBROUTINE` | `N, M, AR, AI, KA, BR, BI, KB, IPVT` | [41364](source_parts/nswc_part_04.f90#L9617) | Not indexed |
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [3017](source_parts/nswc_part_01.f90#L3017) | [Documented](docs/02-elementary-operations.md#topic-026-03) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [32058](source_parts/nswc_part_04.f90#L311) | [Documented](docs/07-vectors.md#topic-136-01) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [1854](source_parts/nswc_part_01.f90#L1854) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DE1` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YY, WT, P, YP, YPOUT, PHI, ALPHA, BETA, SIG, V, W, G, PHASE1, PSI, X, H, HOLD, START, TOLD, DELSGN, NS, NORND, K, KOLD, ISNOLD` | [105676](source_parts/nswc_part_10.f90#L9985) | Not indexed |
| `DE1E` | `DOUBLE PRECISION FUNCTION` | `X` | [9288](source_parts/nswc_part_01.f90#L9288) | Not indexed |
| `DEC` | `SUBROUTINE` | `N, NDIM, A, IP, IER` | [34788](source_parts/nswc_part_04.f90#L3041) | Not indexed |
| `DECBT` | `SUBROUTINE` | `M, N, A, B, C, IP, IER` | [37496](source_parts/nswc_part_04.f90#L5749) | Not indexed |
| `DECOM2` | `SUBROUTINE` | `M, N, M1, ETA, TOL, QR, D, N1, IPIVOT, SING, MMPNN` | [70483](source_parts/nswc_part_07.f90#L6680) | Not indexed |
| `DEFER` | `SUBROUTINE` | `COFX, COFY, USOL, IDMN, GRHS, MN` | [112663](source_parts/nswc_part_11.f90#L6335) | Not indexed |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [9263](source_parts/nswc_part_01.f90#L9263) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEI0` | `DOUBLE PRECISION FUNCTION` | `X, EPS` | [9759](source_parts/nswc_part_01.f90#L9759) | Not indexed |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [9275](source_parts/nswc_part_01.f90#L9275) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [58249](source_parts/nswc_part_06.f90#L5245) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-266-01) |
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [58263](source_parts/nswc_part_06.f90#L5259) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-267-01) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [23644](source_parts/nswc_part_03.f90#L2486) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [23844](source_parts/nswc_part_03.f90#L2686) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [1362](source_parts/nswc_part_01.f90#L1362) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [6889](source_parts/nswc_part_01.f90#L6889) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [6948](source_parts/nswc_part_01.f90#L6948) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFC0` | `DOUBLE PRECISION FUNCTION` | `X` | [7095](source_parts/nswc_part_01.f90#L7095) | Not indexed |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [7013](source_parts/nswc_part_01.f90#L7013) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [7376](source_parts/nswc_part_01.f90#L7376) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `DESUM` | `DOUBLE PRECISION FUNCTION` | `MU, X` | [3812](source_parts/nswc_part_01.f90#L3812) | Not indexed |
| `DET` | `FUNCTION` | `A, KA, N, X` | [43014](source_parts/nswc_part_05.f90#L511) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [116278](source_parts/nswc_part_11.f90#L9950) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `DGAM1` | `DOUBLE PRECISION FUNCTION` | `X` | [11636](source_parts/nswc_part_02.f90#L1055) | Not indexed |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [11803](source_parts/nswc_part_02.f90#L1222) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [11494](source_parts/nswc_part_02.f90#L913) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `DGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [35956](source_parts/nswc_part_04.f90#L4209) | Not indexed |
| `DGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [36374](source_parts/nswc_part_04.f90#L4627) | Not indexed |
| `DGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [36150](source_parts/nswc_part_04.f90#L4403) | Not indexed |
| `DGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [36255](source_parts/nswc_part_04.f90#L4508) | Not indexed |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [14852](source_parts/nswc_part_02.f90#L4271) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `DGMLN1` | `DOUBLE PRECISION FUNCTION` | `X` | [11845](source_parts/nswc_part_02.f90#L1264) | Not indexed |
| `DGNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [97035](source_parts/nswc_part_10.f90#L1344) | Not indexed |
| `DGR17` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [14745](source_parts/nswc_part_02.f90#L4164) | Not indexed |
| `DGR29` | `SUBROUTINE` | `A, Y, L, Z, RTA, ANS, QANS` | [14436](source_parts/nswc_part_02.f90#L3855) | Not indexed |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [14177](source_parts/nswc_part_02.f90#L3596) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DGSMLN` | `DOUBLE PRECISION FUNCTION` | `A, B` | [13210](source_parts/nswc_part_02.f90#L2629) | Not indexed |
| `DH12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [67634](source_parts/nswc_part_07.f90#L3831) | Not indexed |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [67119](source_parts/nswc_part_07.f90#L3316) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [67363](source_parts/nswc_part_07.f90#L3560) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DHQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [58640](source_parts/nswc_part_06.f90#L5636) | Not indexed |
| `DHQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [59107](source_parts/nswc_part_06.f90#L6103) | Not indexed |
| `DINCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [97110](source_parts/nswc_part_10.f90#L1419) | Not indexed |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [1802](source_parts/nswc_part_01.f90#L1802) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [34235](source_parts/nswc_part_04.f90#L2488) | [Documented](docs/08-matrices.md#topic-160-01) |
| `DLGDIV` | `DOUBLE PRECISION FUNCTION` | `A, B` | [13300](source_parts/nswc_part_02.f90#L2719) | Not indexed |
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [64180](source_parts/nswc_part_07.f90#L377) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [4042](source_parts/nswc_part_01.f90#L4042) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DLOC` | `LOGICAL FUNCTION` | `X, Y` | [34006](source_parts/nswc_part_04.f90#L2259) | Not indexed |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [65457](source_parts/nswc_part_07.f90#L1654) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-287-01) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [33721](source_parts/nswc_part_04.f90#L1974) | [Documented](docs/08-matrices.md#topic-151-01) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33235](source_parts/nswc_part_04.f90#L1488) | [Documented](docs/08-matrices.md#topic-146-01) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [47278](source_parts/nswc_part_05.f90#L4775) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [33101](source_parts/nswc_part_04.f90#L1354) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [47455](source_parts/nswc_part_05.f90#L4952) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [33137](source_parts/nswc_part_04.f90#L1390) | [Documented](docs/08-matrices.md#topic-142-01) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [97371](source_parts/nswc_part_10.f90#L1680) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMEVL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [97522](source_parts/nswc_part_10.f90#L1831) | Not indexed |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [46016](source_parts/nswc_part_05.f90#L3513) | [Documented](docs/08-matrices.md#topic-191-01) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [96863](source_parts/nswc_part_10.f90#L1172) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [33954](source_parts/nswc_part_04.f90#L2207) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [35879](source_parts/nswc_part_04.f90#L4132) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [35917](source_parts/nswc_part_04.f90#L4170) | [Documented](docs/08-matrices.md#topic-163-01) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [33771](source_parts/nswc_part_04.f90#L2024) | [Documented](docs/08-matrices.md#topic-153-01) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [33826](source_parts/nswc_part_04.f90#L2079) | [Documented](docs/08-matrices.md#topic-155-01) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [32707](source_parts/nswc_part_04.f90#L960) | [Documented](docs/07-vectors.md#topic-140-01) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [115221](source_parts/nswc_part_11.f90#L8893) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [115485](source_parts/nswc_part_11.f90#L9157) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [115617](source_parts/nswc_part_11.f90#L9289) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `DNSPIV` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [54482](source_parts/nswc_part_06.f90#L1478) | Not indexed |
| `DOGLEG` | `SUBROUTINE` | `N, R, LR, DIAG, QTB, DELTA, X, WA1, WA2` | [74130](source_parts/nswc_part_07.f90#L10327) | Not indexed |
| `DONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [55536](source_parts/nswc_part_06.f90#L2532) | Not indexed |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [2743](source_parts/nswc_part_01.f90#L2743) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [64313](source_parts/nswc_part_07.f90#L510) | Not indexed |
| `DORTH` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [58534](source_parts/nswc_part_06.f90#L5530) | Not indexed |
| `DORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [64208](source_parts/nswc_part_07.f90#L405) | Not indexed |
| `DORTRN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [58937](source_parts/nswc_part_06.f90#L5933) | Not indexed |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [26522](source_parts/nswc_part_03.f90#L5364) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [39996](source_parts/nswc_part_04.f90#L8249) | [Documented](docs/08-matrices.md#topic-176-01) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [26478](source_parts/nswc_part_03.f90#L5320) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [8057](source_parts/nswc_part_01.f90#L8057) | [Documented](docs/04-special-functions.md#topic-055-01) |
| `DPDAW0` | `DOUBLE PRECISION FUNCTION` | `X` | [8162](source_parts/nswc_part_01.f90#L8162) | Not indexed |
| `DPDEL` | `DOUBLE PRECISION FUNCTION` | `X` | [11595](source_parts/nswc_part_02.f90#L1014) | Not indexed |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [43080](source_parts/nswc_part_05.f90#L577) | [Documented](docs/08-matrices.md#topic-185-01) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [26709](source_parts/nswc_part_03.f90#L5551) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [26921](source_parts/nswc_part_03.f90#L5763) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [46336](source_parts/nswc_part_05.f90#L3833) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [26814](source_parts/nswc_part_03.f90#L5656) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [1279](source_parts/nswc_part_01.f90#L1279) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [26619](source_parts/nswc_part_03.f90#L5461) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [7861](source_parts/nswc_part_01.f90#L7861) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [51979](source_parts/nswc_part_05.f90#L9476) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [52038](source_parts/nswc_part_05.f90#L9535) | [Documented](docs/11-sparse-matrices.md#topic-234-01) |
| `DPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [40178](source_parts/nswc_part_04.f90#L8431) | Not indexed |
| `DPPFA` | `SUBROUTINE` | `AP, N, INFO` | [40021](source_parts/nswc_part_04.f90#L8274) | Not indexed |
| `DPPSL` | `SUBROUTINE` | `AP, N, B` | [40111](source_parts/nswc_part_04.f90#L8364) | Not indexed |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [12338](source_parts/nswc_part_02.f90#L1757) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `DPSI0` | `DOUBLE PRECISION FUNCTION` | `X` | [12531](source_parts/nswc_part_02.f90#L1950) | Not indexed |
| `DPSLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [35041](source_parts/nswc_part_04.f90#L3294) | Not indexed |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [26562](source_parts/nswc_part_03.f90#L5404) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [101855](source_parts/nswc_part_10.f90#L6164) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `DQAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [102037](source_parts/nswc_part_10.f90#L6346) | Not indexed |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [101042](source_parts/nswc_part_10.f90#L5351) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [101216](source_parts/nswc_part_10.f90#L5525) | Not indexed |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [28321](source_parts/nswc_part_03.f90#L7163) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [102824](source_parts/nswc_part_10.f90#L7133) | Not indexed |
| `DQK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [102501](source_parts/nswc_part_10.f90#L6810) | Not indexed |
| `DQK21` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [101667](source_parts/nswc_part_10.f90#L5976) | Not indexed |
| `DQPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [102690](source_parts/nswc_part_10.f90#L6999) | Not indexed |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [28948](source_parts/nswc_part_03.f90#L7790) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `DQXCPY` | `SUBROUTINE` | `A, B, L` | [103594](source_parts/nswc_part_10.f90#L7903) | Not indexed |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [103002](source_parts/nswc_part_10.f90#L7311) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `DQXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [103171](source_parts/nswc_part_10.f90#L7480) | Not indexed |
| `DQXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [103607](source_parts/nswc_part_10.f90#L7916) | Not indexed |
| `DQXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [103915](source_parts/nswc_part_10.f90#L8224) | Not indexed |
| `DQXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [103720](source_parts/nswc_part_10.f90#L8029) | Not indexed |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [116089](source_parts/nswc_part_11.f90#L9761) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [115003](source_parts/nswc_part_11.f90#L8675) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `DRCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [115016](source_parts/nswc_part_11.f90#L8688) | Not indexed |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [13823](source_parts/nswc_part_02.f90#L3242) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `DRCVL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [24748](source_parts/nswc_part_03.f90#L3590) | Not indexed |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [24249](source_parts/nswc_part_03.f90#L3091) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [3864](source_parts/nswc_part_01.f90#L3864) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `DREXP1` | `SUBROUTINE` | `X, E, W` | [3952](source_parts/nswc_part_01.f90#L3952) | Not indexed |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [24016](source_parts/nswc_part_03.f90#L2858) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [115942](source_parts/nswc_part_11.f90#L9614) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [24509](source_parts/nswc_part_03.f90#L3351) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [4195](source_parts/nswc_part_01.f90#L4195) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [4274](source_parts/nswc_part_01.f90#L4274) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [116660](source_parts/nswc_part_11.f90#L10332) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [115803](source_parts/nswc_part_11.f90#L9475) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [34334](source_parts/nswc_part_04.f90#L2587) | [Documented](docs/08-matrices.md#topic-161-01) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [115145](source_parts/nswc_part_11.f90#L8817) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [31406](source_parts/nswc_part_03.f90#L10248) | [Documented](docs/07-vectors.md#topic-132-01) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [3170](source_parts/nswc_part_01.f90#L3170) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [31898](source_parts/nswc_part_04.f90#L151) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [31748](source_parts/nswc_part_04.f90#L1) | [Documented](docs/07-vectors.md#topic-133-01) |
| `DRPLY1` | `SUBROUTINE` | `OP, IDEG, IDP1, ZEROR, ZEROI, P, QP, K, QK, SVK, TEMP, PT, NUM` | [29171](source_parts/nswc_part_03.f90#L8013) | Not indexed |
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [29108](source_parts/nswc_part_03.f90#L7950) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-127-01) |
| `DRTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [59020](source_parts/nswc_part_06.f90#L6016) | Not indexed |
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [55318](source_parts/nswc_part_06.f90#L2314) | [Documented](docs/11-sparse-matrices.md#topic-256-01) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [53056](source_parts/nswc_part_06.f90#L52) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [52280](source_parts/nswc_part_05.f90#L9777) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [32227](source_parts/nswc_part_04.f90#L480) | [Documented](docs/07-vectors.md#topic-137-01) |
| `DSCALD` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [97344](source_parts/nswc_part_10.f90#L1653) | Not indexed |
| `DSCALP` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [97308](source_parts/nswc_part_10.f90#L1617) | Not indexed |
| `DSCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [43984](source_parts/nswc_part_05.f90#L1481) | Not indexed |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51784](source_parts/nswc_part_05.f90#L9281) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [60562](source_parts/nswc_part_06.f90#L7558) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-271-01) |
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [60580](source_parts/nswc_part_06.f90#L7576) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-272-01) |
| `DSHSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [44257](source_parts/nswc_part_05.f90#L1754) | Not indexed |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [3493](source_parts/nswc_part_01.f90#L3493) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [54751](source_parts/nswc_part_06.f90#L1747) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [54850](source_parts/nswc_part_06.f90#L1846) | Not indexed |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [38679](source_parts/nswc_part_04.f90#L6932) | [Documented](docs/08-matrices.md#topic-173-01) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [53034](source_parts/nswc_part_06.f90#L30) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `DSORT` | `SUBROUTINE` | `A, N` | [1756](source_parts/nswc_part_01.f90#L1756) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `DSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [38714](source_parts/nswc_part_04.f90#L6967) | Not indexed |
| `DSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [39446](source_parts/nswc_part_04.f90#L7699) | Not indexed |
| `DSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [39000](source_parts/nswc_part_04.f90#L7253) | Not indexed |
| `DSPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [55042](source_parts/nswc_part_06.f90#L2038) | Not indexed |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [52627](source_parts/nswc_part_05.f90#L10124) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `DSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [39265](source_parts/nswc_part_04.f90#L7518) | Not indexed |
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [54364](source_parts/nswc_part_06.f90#L1360) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [52457](source_parts/nswc_part_05.f90#L9954) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `DSTOR2` | `SUBROUTINE` | `A, B` | [1210](source_parts/nswc_part_01.f90#L1210) | Not indexed |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [42022](source_parts/nswc_part_04.f90#L10275) | [Documented](docs/08-matrices.md#topic-183-01) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [34159](source_parts/nswc_part_04.f90#L2412) | [Documented](docs/08-matrices.md#topic-157-01) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [31274](source_parts/nswc_part_03.f90#L10116) | [Documented](docs/07-vectors.md#topic-131-01) |
| `DSYMSV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [44830](source_parts/nswc_part_05.f90#L2327) | Not indexed |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [44668](source_parts/nswc_part_05.f90#L2165) | [Documented](docs/08-matrices.md#topic-188-01) |
| `DTASV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [44726](source_parts/nswc_part_05.f90#L2223) | Not indexed |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [33404](source_parts/nswc_part_04.f90#L1657) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [40390](source_parts/nswc_part_04.f90#L8643) | [Documented](docs/08-matrices.md#topic-177-01) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33275](source_parts/nswc_part_04.f90#L1528) | [Documented](docs/08-matrices.md#topic-148-01) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52855](source_parts/nswc_part_05.f90#L10352) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52879](source_parts/nswc_part_05.f90#L10376) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DTQL` | `SUBROUTINE` | `N, D, E2, IERR` | [60821](source_parts/nswc_part_06.f90#L7817) | Not indexed |
| `DTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [61095](source_parts/nswc_part_06.f90#L8091) | Not indexed |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [116462](source_parts/nswc_part_11.f90#L10134) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `DTRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [60593](source_parts/nswc_part_06.f90#L7589) | Not indexed |
| `DTRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [60956](source_parts/nswc_part_06.f90#L7952) | Not indexed |
| `DTRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [60708](source_parts/nswc_part_06.f90#L7704) | Not indexed |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [54892](source_parts/nswc_part_06.f90#L1888) | [Documented](docs/11-sparse-matrices.md#topic-252-01) |
| `DTSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [54991](source_parts/nswc_part_06.f90#L1987) | Not indexed |
| `DU11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [65711](source_parts/nswc_part_07.f90#L1908) | Not indexed |
| `DU11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [66118](source_parts/nswc_part_07.f90#L2315) | Not indexed |
| `DU12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [65975](source_parts/nswc_part_07.f90#L2172) | Not indexed |
| `DU12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [66382](source_parts/nswc_part_07.f90#L2579) | Not indexed |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [114432](source_parts/nswc_part_11.f90#L8104) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `DURNG0` | `SUBROUTINE` | `IX, U, V` | [114574](source_parts/nswc_part_11.f90#L8246) | Not indexed |
| `DURNG1` | `SUBROUTINE` | `IX, U, V, D` | [114711](source_parts/nswc_part_11.f90#L8383) | Not indexed |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [114844](source_parts/nswc_part_11.f90#L8516) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52815](source_parts/nswc_part_05.f90#L10312) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52835](source_parts/nswc_part_05.f90#L10332) | [Documented](docs/11-sparse-matrices.md#topic-240-01) |
| `DXFN` | `SUBROUTINE` | `U, IDMN, I, J, UXXX, UXXXX` | [112724](source_parts/nswc_part_11.f90#L6396) | Not indexed |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [1426](source_parts/nswc_part_01.f90#L1426) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `DYCHG` | `SUBROUTINE` | `X, Y, YOLD` | [34037](source_parts/nswc_part_04.f90#L2290) | Not indexed |
| `DYFN` | `SUBROUTINE` | `U, IDMN, I, J, UYYY, UYYYY` | [112806](source_parts/nswc_part_11.f90#L6478) | Not indexed |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [27550](source_parts/nswc_part_03.f90#L6392) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [56594](source_parts/nswc_part_06.f90#L3590) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [56608](source_parts/nswc_part_06.f90#L3604) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-262-01) |
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [56622](source_parts/nswc_part_06.f90#L3618) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [56651](source_parts/nswc_part_06.f90#L3647) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-264-01) |
| `EKL` | `SUBROUTINE` | `L, FK, FL, EK, EL, GK, GL` | [23419](source_parts/nswc_part_03.f90#L2261) | Not indexed |
| `EKM` | `SUBROUTINE` | `K2, FK, EK` | [23383](source_parts/nswc_part_03.f90#L2225) | Not indexed |
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [24841](source_parts/nswc_part_03.f90#L3683) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [23510](source_parts/nswc_part_03.f90#L2352) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `ELMHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [56922](source_parts/nswc_part_06.f90#L3918) | Not indexed |
| `ELMHS0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT` | [57018](source_parts/nswc_part_06.f90#L4014) | Not indexed |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [25128](source_parts/nswc_part_03.f90#L3970) | [Documented](docs/04-special-functions.md#topic-099-01) |
| `ELTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [57516](source_parts/nswc_part_06.f90#L4512) | Not indexed |
| `ELTRN0` | `SUBROUTINE` | `NM, N, LOW, IGH, A, INT, Z` | [57591](source_parts/nswc_part_06.f90#L4587) | Not indexed |
| `ENORM` | `REAL FUNCTION` | `N, X` | [74024](source_parts/nswc_part_07.f90#L10221) | Not indexed |
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [23784](source_parts/nswc_part_03.f90#L2626) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `EPSLN` | `REAL FUNCTION` | `L` | [1337](source_parts/nswc_part_01.f90#L1337) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `ERF` | `REAL FUNCTION` | `X` | [5951](source_parts/nswc_part_01.f90#L5951) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC` | `REAL FUNCTION` | `X` | [6011](source_parts/nswc_part_01.f90#L6011) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFC0` | `SUBROUTINE` | `IND, X, E, Y` | [25903](source_parts/nswc_part_03.f90#L4745) | Not indexed |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [6094](source_parts/nswc_part_01.f90#L6094) | [Documented](docs/04-special-functions.md#topic-046-01) |
| `ERFCM2` | `SUBROUTINE` | `MO, Z, W` | [6752](source_parts/nswc_part_01.f90#L6752) | Not indexed |
| `ERFCR` | `REAL FUNCTION` | `X` | [26001](source_parts/nswc_part_03.f90#L4843) | Not indexed |
| `ERFI` | `REAL FUNCTION` | `P, Q` | [7258](source_parts/nswc_part_01.f90#L7258) | [Documented](docs/04-special-functions.md#topic-051-01) |
| `ERREV` | `DOUBLE PRECISION FUNCTION` | `NN, QR, QI, MS, MP, ARE, MRE` | [30677](source_parts/nswc_part_03.f90#L9519) | Not indexed |
| `ERRINT` | `DOUBLE PRECISION FUNCTION` | `F, FIT, AAA, BBB, POINTS, WEIGHT` | [83787](source_parts/nswc_part_08.f90#L9333) | Not indexed |
| `ESUM` | `REAL FUNCTION` | `MU, X` | [3785](source_parts/nswc_part_01.f90#L3785) | Not indexed |
| `EXPARG` | `REAL FUNCTION` | `L` | [1388](source_parts/nswc_part_01.f90#L1388) | [Documented](docs/02-elementary-operations.md#topic-019-01) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [8930](source_parts/nswc_part_01.f90#L8930) | [Documented](docs/04-special-functions.md#topic-058-01) |
| `EXTRA` | `SUBROUTINE` | `NEQN, YINC2, F2, T, H, YINC1, Y, F1, F, TEX, YEX, YPEX` | [107272](source_parts/nswc_part_11.f90#L944) | Not indexed |
| `FDJAC1` | `SUBROUTINE` | `FCN, N, X, FVEC, FJAC, LDFJAC, IFLAG, ML, MU, EPSFCN, WA1, WA2` | [74303](source_parts/nswc_part_07.f90#L10500) | Not indexed |
| `FDJAC2` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FJAC, LDFJAC, IFLAG, EPSFCN, WA` | [74455](source_parts/nswc_part_08.f90#L1) | Not indexed |
| `FEHL` | `SUBROUTINE` | `F, NEQN, Y, T, H, YP, F1, F2, F3, F4, F5, S` | [107850](source_parts/nswc_part_11.f90#L1522) | Not indexed |
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [80434](source_parts/nswc_part_08.f90#L5980) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [80449](source_parts/nswc_part_08.f90#L5995) | [Documented](docs/16-transforms.md#topic-320-01) |
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [72222](source_parts/nswc_part_07.f90#L8419) | [Documented](docs/15-optimization.md#topic-306-01) |
| `FPSER` | `REAL FUNCTION` | `A, B, X, EPS` | [15390](source_parts/nswc_part_02.f90#L4809) | Not indexed |
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [116180](source_parts/nswc_part_11.f90#L9852) | [Documented](docs/27-continuous-random-number-generation.md#topic-452-01) |
| `FRNL` | `SUBROUTINE` | `T, C, S` | [8533](source_parts/nswc_part_01.f90#L8533) | [Documented](docs/04-special-functions.md#topic-057-01) |
| `FSTOCD` | `SUBROUTINE` | `N, X, FCN, TYPSIZ, R, G` | [73011](source_parts/nswc_part_07.f90#L9208) | Not indexed |
| `FSTOFD` | `SUBROUTINE` | `N, X, FCN, FX, G, TYPSIZ, R` | [72977](source_parts/nswc_part_07.f90#L9174) | Not indexed |
| `FUPD` | `SUBROUTINE` | `A1, A2, P1, P2, V1, V2, I1, K1, N, M, NP1` | [5503](source_parts/nswc_part_01.f90#L5503) | Not indexed |
| `FXDEC` | `SUBROUTINE` | `FCN, N, X, FX, R` | [72868](source_parts/nswc_part_07.f90#L9065) | Not indexed |
| `FXSHFR` | `SUBROUTINE` | `L2, NZ, NN, P, QP, K, QK, SVK` | [29441](source_parts/nswc_part_03.f90#L8283) | Not indexed |
| `FXSHFT` | `SUBROUTINE` | `L2, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SHR, SHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [30409](source_parts/nswc_part_03.f90#L9251) | Not indexed |
| `GAM1` | `REAL FUNCTION` | `A` | [11089](source_parts/nswc_part_02.f90#L508) | Not indexed |
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [13853](source_parts/nswc_part_02.f90#L3272) | [Documented](docs/04-special-functions.md#topic-074-01) |
| `GAMLN` | `REAL FUNCTION` | `A` | [11144](source_parts/nswc_part_02.f90#L563) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GAMLN1` | `REAL FUNCTION` | `A` | [11188](source_parts/nswc_part_02.f90#L607) | Not indexed |
| `GAMMA` | `REAL FUNCTION` | `A` | [10849](source_parts/nswc_part_02.f90#L268) | [Documented](docs/04-special-functions.md#topic-065-01) |
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [107917](source_parts/nswc_part_11.f90#L1589) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-424-01) |
| `GERKS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, YP, H, F1, F2, F3, F4, F5, YG, YGP, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [108133](source_parts/nswc_part_11.f90#L1805) | Not indexed |
| `GETNP` | `SUBROUTINE` | `X, Y, IADJ, IEND, L, NPTS, DS, IER` | [94924](source_parts/nswc_part_09.f90#L9925) | Not indexed |
| `GLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [10977](source_parts/nswc_part_02.f90#L396) | Not indexed |
| `GNRTP` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, DIMP1, MAXABS, ERROR` | [96296](source_parts/nswc_part_10.f90#L605) | Not indexed |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [94277](source_parts/nswc_part_09.f90#L9278) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADG1` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, EPS, NIT, ZXZY, IER` | [94302](source_parts/nswc_part_09.f90#L9303) | Not indexed |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [94521](source_parts/nswc_part_09.f90#L9522) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `GRADL1` | `SUBROUTINE` | `N, K, X, Y, Z, IADJ, IEND, DX, DY, IER` | [94547](source_parts/nswc_part_09.f90#L9548) | Not indexed |
| `GRAT1` | `SUBROUTINE` | `A, X, R, P, Q, EPS` | [16000](source_parts/nswc_part_02.f90#L5419) | Not indexed |
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [13375](source_parts/nswc_part_02.f90#L2794) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `GSUMLN` | `REAL FUNCTION` | `A, B` | [13000](source_parts/nswc_part_02.f90#L2419) | Not indexed |
| `H12` | `SUBROUTINE` | `MODE, LPIVOT, L1, M, U, IUE, UP, C, ICE, ICV, NCV` | [67035](source_parts/nswc_part_07.f90#L3232) | Not indexed |
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [27673](source_parts/nswc_part_03.f90#L6515) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-124-01) |
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [5009](source_parts/nswc_part_01.f90#L5009) | [Documented](docs/03-geometry.md#topic-043-01) |
| `HC1` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, NP1, PC, AC, VR, VC, P, SUBR, RBUS, TOR, JR, K, IND0` | [5112](source_parts/nswc_part_01.f90#L5112) | Not indexed |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [66523](source_parts/nswc_part_07.f90#L2720) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [66765](source_parts/nswc_part_07.f90#L2962) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `HQR` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, IERR` | [57220](source_parts/nswc_part_06.f90#L4216) | Not indexed |
| `HQR2` | `SUBROUTINE` | `NM, N, LOW, IGH, H, WR, WI, Z, IERR` | [57836](source_parts/nswc_part_06.f90#L4832) | Not indexed |
| `HSTART` | `SUBROUTINE` | `F, NEQ, A, B, Y, YPRIME, ETOL, MORDER, SMALL, BIG, SPY, PV, YP, SF, RPAR, IPAR, H` | [109712](source_parts/nswc_part_11.f90#L3384) | Not indexed |
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [85000](source_parts/nswc_part_09.f90#L1) | [Documented](docs/18-curve-fitting.md#topic-338-01) |
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [4590](source_parts/nswc_part_01.f90#L4590) | [Documented](docs/03-geometry.md#topic-041-01) |
| `HYBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, XTOL, MAXFEV, ML, MU, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, R, LR, QTF, WA1, WA2, WA3, WA4` | [27804](source_parts/nswc_part_03.f90#L6646) | Not indexed |
| `IA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [21820](source_parts/nswc_part_03.f90#L662) | Not indexed |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [33046](source_parts/nswc_part_04.f90#L1299) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [33007](source_parts/nswc_part_04.f90#L1260) | [Documented](docs/07-vectors.md#topic-141-01) |
| `IEGS` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, X, T, NT, NUP, MUP, IER, CUTOFF, ROOTRT, UNITRD, NHALF, LUFACT, KMM, KMN, KNM, RHS, R, RH, DELN, TM, TN, XM, XMZ, WM, WN, OLDX, SAVE, XN, SAVE2, ASIDE, ASIDE3, IMKNN` | [104514](source_parts/nswc_part_10.f90#L8823) | Not indexed |
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [104350](source_parts/nswc_part_10.f90#L8659) | [Documented](docs/23-integral-equations.md#topic-410-01) |
| `IMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [21864](source_parts/nswc_part_03.f90#L706) | Not indexed |
| `IMTQL1` | `SUBROUTINE` | `N, D, E, IERR` | [59953](source_parts/nswc_part_06.f90#L6949) | Not indexed |
| `IMTQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [60397](source_parts/nswc_part_06.f90#L7393) | Not indexed |
| `INCDG` | `SUBROUTINE` | `DEGREE, ALPHA, PSI, INDEXS, NEWKJ, SUMSQS, COORD, NCROWS, NPOLYS, DIMEN, NPTS, F, Z, C, PSIWID, WEIGHT, ALFL, ONPLYS, STTDEG, ERROR` | [96371](source_parts/nswc_part_10.f90#L680) | Not indexed |
| `INDXA` | `SUBROUTINE` | `I, IR, IDXA, NA` | [113333](source_parts/nswc_part_11.f90#L7005) | Not indexed |
| `INDXB` | `SUBROUTINE` | `I, IR, IDX, IDP` | [113355](source_parts/nswc_part_11.f90#L7027) | Not indexed |
| `INDXC` | `SUBROUTINE` | `I, IR, IDXC, NC` | [113344](source_parts/nswc_part_11.f90#L7016) | Not indexed |
| `INFCTR` | `SUBROUTINE` | `N, IFACT, IPOWER, NEXP, NPOWER` | [33622](source_parts/nswc_part_04.f90#L1875) | Not indexed |
| `INTADD` | `SUBROUTINE` | `KK, I1, I2, I3, IADJ, IEND` | [93372](source_parts/nswc_part_09.f90#L8373) | Not indexed |
| `INTRC1` | `SUBROUTINE` | `N, PX, PY, X, Y, Z, IADJ, IEND, IFLAG, ZXZY, IST, PZ, IER` | [95126](source_parts/nswc_part_09.f90#L10127) | Not indexed |
| `INTRP` | `SUBROUTINE` | `X, Y, XOUT, YOUT, YPOUT, NEQN, KOLD, PHI, PSI` | [106329](source_parts/nswc_part_11.f90#L1) | Not indexed |
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [88949](source_parts/nswc_part_09.f90#L3950) | [Documented](docs/18-curve-fitting.md#topic-368-01) |
| `INTYD` | `SUBROUTINE` | `T, K, YH, NYH, DKY, IFLAG` | [110006](source_parts/nswc_part_11.f90#L3678) | Not indexed |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [2599](source_parts/nswc_part_01.f90#L2599) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `IPATH` | `SUBROUTINE` | `I, J, SUBR, RBUS, AR, PR, S, N, NP, I1, I2, K, JR, M, NP1` | [5442](source_parts/nswc_part_01.f90#L5442) | Not indexed |
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [1](source_parts/nswc_part_01.f90#L1) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [32968](source_parts/nswc_part_04.f90#L1221) | [Documented](docs/07-vectors.md#topic-141-01) |
| `ISHELL` | `SUBROUTINE` | `A, N` | [1465](source_parts/nswc_part_01.f90#L1465) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [16196](source_parts/nswc_part_02.f90#L5615) | [Documented](docs/04-special-functions.md#topic-077-01) |
| `ISWAP` | `SUBROUTINE` | `N, IX, INCX, IY, INCY` | [31132](source_parts/nswc_part_03.f90#L9974) | Not indexed |
| `ITERT` | `SUBROUTINE` | `KERNEL, RHFCN, N, TN, WN, M, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, IFLG` | [105267](source_parts/nswc_part_10.f90#L9576) | Not indexed |
| `IUPD` | `SUBROUTINE` | `IA, IB, L, A1, A2, P1, P2, V1, V2, K1, N, M, NP1` | [5552](source_parts/nswc_part_01.f90#L5552) | Not indexed |
| `JA` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [21966](source_parts/nswc_part_03.f90#L808) | Not indexed |
| `JAIRY` | `SUBROUTINE` | `X, RX, C, AI, DAI` | [18407](source_parts/nswc_part_02.f90#L7826) | Not indexed |
| `JMC` | `SUBROUTINE` | `Z, I1, I2, I1M, I2M` | [22010](source_parts/nswc_part_03.f90#L852) | Not indexed |
| `JROT` | `SUBROUTINE` | `NR, N, H, I, A, B, R` | [73372](source_parts/nswc_part_07.f90#L9569) | Not indexed |
| `KA` | `SUBROUTINE` | `IND, Z, K1, K2` | [22112](source_parts/nswc_part_03.f90#L954) | Not indexed |
| `KL` | `SUBROUTINE` | `L, FK, FL` | [23028](source_parts/nswc_part_03.f90#L1870) | Not indexed |
| `KM` | `COMPLEX FUNCTION` | `K2` | [22996](source_parts/nswc_part_03.f90#L1838) | Not indexed |
| `KML` | `SUBROUTINE` | `IND, Z, K1, K2` | [22157](source_parts/nswc_part_03.f90#L999) | Not indexed |
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [34209](source_parts/nswc_part_04.f90#L2462) | [Documented](docs/08-matrices.md#topic-160-01) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [34578](source_parts/nswc_part_04.f90#L2831) | [Documented](docs/08-matrices.md#topic-163-01) |
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [87914](source_parts/nswc_part_09.f90#L2915) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [88106](source_parts/nswc_part_09.f90#L3107) | [Documented](docs/18-curve-fitting.md#topic-361-01) |
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [88212](source_parts/nswc_part_09.f90#L3213) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [88383](source_parts/nswc_part_09.f90#L3384) | [Documented](docs/18-curve-fitting.md#topic-363-01) |
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [70073](source_parts/nswc_part_07.f90#L6270) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-299-01) |
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [78539](source_parts/nswc_part_08.f90#L4085) | [Documented](docs/16-transforms.md#topic-317-01) |
| `LAINV1` | `SUBROUTINE` | `FUN, T, C, EPSRE, EPSAB, RESULT, ESTERR, NUM, IER` | [79162](source_parts/nswc_part_08.f90#L4708) | Not indexed |
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [46173](source_parts/nswc_part_05.f90#L3670) | [Documented](docs/09-large-dense-systems-of-linear-equations.md#topic-193-01) |
| `LEAVE` | `SUBROUTINE` | `IERSET, NF, MF, XV, TV, WV, ERROR, KERNEL, RHFCN, EP, IFLAG, X, T, NT, IER, EPS, ELINSY, TN, WN, TM, WM, XM, XMZ, KMM, KMN, KNM, RHS, IMKNN, LUFACT, R, RH, DELN, NUP, NHALF, XNORM` | [105164](source_parts/nswc_part_10.f90#L9473) | Not indexed |
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [27082](source_parts/nswc_part_03.f90#L5924) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [27103](source_parts/nswc_part_03.f90#L5945) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [27210](source_parts/nswc_part_03.f90#L6052) | [Documented](docs/05-polynomials.md#topic-119-01) |
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [63804](source_parts/nswc_part_07.f90#L1) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [63830](source_parts/nswc_part_07.f90#L27) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-286-01) |
| `LLTSLV` | `SUBROUTINE` | `NR, N, A, X, B` | [72924](source_parts/nswc_part_07.f90#L9121) | Not indexed |
| `LMDIF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, FTOL, XTOL, GTOL, MAXFEV, EPSFCN, DIAG, MODE, FACTOR, NPRINT, INFO, NFEV, FJAC, LDFJAC, IPVT, QTF, WA1, WA2, WA3, WA4` | [73572](source_parts/nswc_part_07.f90#L9769) | Not indexed |
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [73432](source_parts/nswc_part_07.f90#L9629) | [Documented](docs/15-optimization.md#topic-309-01) |
| `LMPAR` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, DELTA, PAR, X, SDIAG, WA1, WA2` | [74564](source_parts/nswc_part_08.f90#L110) | Not indexed |
| `LNSRCH` | `SUBROUTINE` | `N, X, F, G, P, XPLS, FPLS, FCN, MXTAKE, IRETCD, STEPMX, STEPTL, TYPSIZ` | [73049](source_parts/nswc_part_07.f90#L9246) | Not indexed |
| `LNSYS` | `SUBROUTINE` | `A, D, M, N, B, X, OPTION, IERR` | [105352](source_parts/nswc_part_10.f90#L9661) | Not indexed |
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [4354](source_parts/nswc_part_01.f90#L4354) | [Documented](docs/03-geometry.md#topic-039-01) |
| `LOGAM` | `REAL FUNCTION` | `X` | [16448](source_parts/nswc_part_02.f90#L5867) | Not indexed |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [87273](source_parts/nswc_part_09.f90#L2274) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [87350](source_parts/nswc_part_09.f90#L2351) | [Documented](docs/18-curve-fitting.md#topic-355-01) |
| `LPDP` | `SUBROUTINE` | `A, MDA, M, N1, N2, PRGOPT, X, WNORM, MODE, WS, IS` | [68645](source_parts/nswc_part_07.f90#L4842) | Not indexed |
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [67717](source_parts/nswc_part_07.f90#L3914) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-292-01) |
| `LSI` | `SUBROUTINE` | `W, MDW, MA, MG, N, PRGOPT, X, RNORM, MODE, WS, IP` | [68294](source_parts/nswc_part_07.f90#L4491) | Not indexed |
| `LSOD1` | `SUBROUTINE` | `F, NEQ, T, Y, TOUT, RTOL, ATOL, IDID, YPOUT, YH, YH1, EWT, SAVF, ACOR, WM, IWM, JAC, INTOUT, TSTOP, TOLFAC, DELSGN, RPAR, IPAR` | [109406](source_parts/nswc_part_11.f90#L3078) | Not indexed |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [64401](source_parts/nswc_part_07.f90#L598) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-281-01) |
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [84849](source_parts/nswc_part_08.f90#L10395) | [Documented](docs/18-curve-fitting.md#topic-337-01) |
| `LUIMP` | `SUBROUTINE` | `A, KA, N, Q, KQ, IPVT, B, X, R, IND` | [35241](source_parts/nswc_part_04.f90#L3494) | Not indexed |
| `MACH` | `SUBROUTINE` | `MO, N, IBETA, IMAX, IDMAX, IMACH, RMACH, DMACH` | [437](source_parts/nswc_part_01.f90#L437) | Not indexed |
| `MACH1` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [728](source_parts/nswc_part_01.f90#L728) | Not indexed |
| `MACH2` | `SUBROUTINE` | `N, IBETA, M, MINEXP, MAXEXP, EPS, XINT, XMIN, XMAX` | [974](source_parts/nswc_part_01.f90#L974) | Not indexed |
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [33707](source_parts/nswc_part_04.f90#L1960) | [Documented](docs/08-matrices.md#topic-151-01) |
| `MC13D` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW` | [53315](source_parts/nswc_part_06.f90#L311) | Not indexed |
| `MC13E` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, ARP, IB, NUM, LOWL, NUMB, PREV` | [53345](source_parts/nswc_part_06.f90#L341) | Not indexed |
| `MC21A` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, IW` | [53158](source_parts/nswc_part_06.f90#L154) | Not indexed |
| `MC21B` | `SUBROUTINE` | `N, ICN, LICN, IP, LENR, IPERM, NUMNZ, PR, ARP, CV, OUT` | [53189](source_parts/nswc_part_06.f90#L185) | Not indexed |
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33216](source_parts/nswc_part_04.f90#L1469) | [Documented](docs/08-matrices.md#topic-146-01) |
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [47218](source_parts/nswc_part_05.f90#L4715) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33172](source_parts/nswc_part_04.f90#L1425) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [33089](source_parts/nswc_part_04.f90#L1342) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33183](source_parts/nswc_part_04.f90#L1436) | [Documented](docs/08-matrices.md#topic-144-01) |
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33161](source_parts/nswc_part_04.f90#L1414) | [Documented](docs/08-matrices.md#topic-143-01) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [47398](source_parts/nswc_part_05.f90#L4895) | [Documented](docs/10-banded-matrices.md#topic-198-01) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [33113](source_parts/nswc_part_04.f90#L1366) | [Documented](docs/08-matrices.md#topic-142-01) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [96632](source_parts/nswc_part_10.f90#L941) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MEVAL1` | `SUBROUTINE` | `COORD, NCROWS, C, NEPTS, DIMEN, NPOLYS, ALPHA, INDEXS, PSI, F, ALFL, MAXABS, X, DIMP1` | [96782](source_parts/nswc_part_10.f90#L1091) | Not indexed |
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [45868](source_parts/nswc_part_05.f90#L3365) | [Documented](docs/08-matrices.md#topic-191-01) |
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [80459](source_parts/nswc_part_08.f90#L6005) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [80494](source_parts/nswc_part_08.f90#L6040) | [Documented](docs/16-transforms.md#topic-322-01) |
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [95692](source_parts/nswc_part_10.f90#L1) | [Documented](docs/21-manifold-fitting.md#topic-395-01) |
| `MINSOL` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTB` | [112574](source_parts/nswc_part_11.f90#L6246) | Not indexed |
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [77742](source_parts/nswc_part_08.f90#L3288) | [Documented](docs/15-optimization.md#topic-315-01) |
| `MKP1` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5, BB, BL, X, XL, B, UBB, LX, LXI, F, PBL, Q, V, BS, PS, WS, XS, IWK` | [77937](source_parts/nswc_part_08.f90#L3483) | Not indexed |
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [26978](source_parts/nswc_part_03.f90#L5820) | [Documented](docs/05-polynomials.md#topic-117-01) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [33862](source_parts/nswc_part_04.f90#L2115) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [35128](source_parts/nswc_part_04.f90#L3381) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [35169](source_parts/nswc_part_04.f90#L3422) | [Documented](docs/08-matrices.md#topic-163-01) |
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [33757](source_parts/nswc_part_04.f90#L2010) | [Documented](docs/08-matrices.md#topic-153-01) |
| `MTABLE` | `SUBROUTINE` | `DEGREE, DIMEN, NPOLYS, INDEXS, NEWKJ, ALFLP1` | [96152](source_parts/nswc_part_10.f90#L461) | Not indexed |
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [33807](source_parts/nswc_part_04.f90#L2060) | [Documented](docs/08-matrices.md#topic-155-01) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52771](source_parts/nswc_part_05.f90#L10268) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52795](source_parts/nswc_part_05.f90#L10292) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52731](source_parts/nswc_part_05.f90#L10228) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [52751](source_parts/nswc_part_05.f90#L10248) | [Documented](docs/11-sparse-matrices.md#topic-239-01) |
| `NEWEST` | `SUBROUTINE` | `TYPE, UU, VV, NN, P, K` | [29921](source_parts/nswc_part_03.f90#L8763) | Not indexed |
| `NEWTON` | `SUBROUTINE` | `NL, NR, NI` | [83860](source_parts/nswc_part_08.f90#L9406) | Not indexed |
| `NEXTH` | `SUBROUTINE` | `BOOL, N, TR, TI, HR, HI, QPR, QPI, QHR, QHI` | [30618](source_parts/nswc_part_03.f90#L9460) | Not indexed |
| `NEXTK` | `SUBROUTINE` | `TYPE, N, QP, K, QK` | [29868](source_parts/nswc_part_03.f90#L8710) | Not indexed |
| `NORMLZ` | `SUBROUTINE` | `N, X, BETA` | [71369](source_parts/nswc_part_07.f90#L7566) | Not indexed |
| `NOSHFT` | `SUBROUTINE` | `L1, NN, TR, TI, ETA, PR, PI, HR, HI` | [30361](source_parts/nswc_part_03.f90#L9203) | Not indexed |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [34901](source_parts/nswc_part_04.f90#L3154) | [Documented](docs/08-matrices.md#topic-163-01) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [115191](source_parts/nswc_part_11.f90#L8863) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [115249](source_parts/nswc_part_11.f90#L8921) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [115381](source_parts/nswc_part_11.f90#L9053) | [Documented](docs/27-continuous-random-number-generation.md#topic-444-01) |
| `NSPIV1` | `SUBROUTINE` | `N, IA, JA, A, B, MAX, R, C, IC, X, Y, P, IU, JU, U, IERR` | [53592](source_parts/nswc_part_06.f90#L588) | Not indexed |
| `NSTERP` | `SUBROUTINE` | `TM, WM, XM, M, TN, WN, XN, N, KERNEL, RHFCN, RHS, KMN, NHALF, NUP` | [104803](source_parts/nswc_part_10.f90#L9112) | Not indexed |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [92293](source_parts/nswc_part_09.f90#L7294) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [105515](source_parts/nswc_part_10.f90#L9824) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-415-01) |
| `OPCHK1` | `SUBROUTINE` | `N, X, TYPSIZ, FSCALE, GRADTL, ITNLIM, RERR, STEPMX, IERR` | [72667](source_parts/nswc_part_07.f90#L8864) | Not indexed |
| `OPSTP` | `SUBROUTINE` | `N, XPLS, FPLS, GPLS, X, ITNCNT, ICSCMX, IERR, GRADTL, STEPTL, TYPSIZ, FSCALE, ITNLIM, IRETCD, MXTAKE, FSTACK, NS, SPTR` | [72755](source_parts/nswc_part_07.f90#L8952) | Not indexed |
| `OPTDRV` | `SUBROUTINE` | `MO, NR, N, X, FCN, TYPSIZ, FSCALE, RERR, ITNLIM, ITNCNT, GRADTL, STEPMX, STEPTL, XPLS, FPLS, GPLS, IERR, A, G, P, WRK0, WRK1, WRK2` | [72464](source_parts/nswc_part_07.f90#L8661) | Not indexed |
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [72389](source_parts/nswc_part_07.f90#L8586) | [Documented](docs/15-optimization.md#topic-307-01) |
| `ORIMP` | `SUBROUTINE` | `M, N, A, KA, QR, MS, S, IP, B, X, R, EXIT` | [64070](source_parts/nswc_part_07.f90#L267) | Not indexed |
| `ORSOL` | `SUBROUTINE` | `M, N, QR, MS, S, IP, X` | [63979](source_parts/nswc_part_07.f90#L176) | Not indexed |
| `ORTHES` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT` | [57114](source_parts/nswc_part_06.f90#L4110) | Not indexed |
| `ORTHG` | `SUBROUTINE` | `USOL, IDMN, ZN, ZM, PERTRB` | [112530](source_parts/nswc_part_11.f90#L6202) | Not indexed |
| `ORTHO` | `SUBROUTINE` | `M, N, QR, MS, S, IP, EXIT` | [63871](source_parts/nswc_part_07.f90#L68) | Not indexed |
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [27258](source_parts/nswc_part_03.f90#L6100) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [27336](source_parts/nswc_part_03.f90#L6178) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [27388](source_parts/nswc_part_03.f90#L6230) | [Documented](docs/05-polynomials.md#topic-121-01) |
| `ORTRAN` | `SUBROUTINE` | `NM, N, LOW, IGH, A, ORT, Z` | [57666](source_parts/nswc_part_06.f90#L4662) | Not indexed |
| `ORTRN1` | `SUBROUTINE` | `N, LOW, IGH, A, NA, Z, NZ, ORT` | [57749](source_parts/nswc_part_06.f90#L4745) | Not indexed |
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [26502](source_parts/nswc_part_03.f90#L5344) | [Documented](docs/05-polynomials.md#topic-111-01) |
| `PARC` | `SUBROUTINE` | `I, II, UB, IFLAG, VB, LUB, LJ, LI, F, BB, Q, B, N, M, NP1, LX, LXI, LR, LRI, LUBI` | [78264](source_parts/nswc_part_08.f90#L3810) | Not indexed |
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [4972](source_parts/nswc_part_01.f90#L4972) | [Documented](docs/03-geometry.md#topic-042-01) |
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [39686](source_parts/nswc_part_04.f90#L7939) | [Documented](docs/08-matrices.md#topic-176-01) |
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [85045](source_parts/nswc_part_09.f90#L46) | [Documented](docs/18-curve-fitting.md#topic-339-01) |
| `PDEDGE` | `SUBROUTINE` | `EDGE, INDX, INDY, IERR` | [111560](source_parts/nswc_part_11.f90#L5232) | Not indexed |
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [86836](source_parts/nswc_part_09.f90#L1837) | [Documented](docs/18-curve-fitting.md#topic-353-01) |
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [26656](source_parts/nswc_part_03.f90#L5498) | [Documented](docs/05-polynomials.md#topic-114-01) |
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [86711](source_parts/nswc_part_09.f90#L1712) | [Documented](docs/18-curve-fitting.md#topic-352-01) |
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [25212](source_parts/nswc_part_03.f90#L4054) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [25254](source_parts/nswc_part_03.f90#L4096) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [4431](source_parts/nswc_part_01.f90#L4431) | [Documented](docs/03-geometry.md#topic-040-01) |
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [85069](source_parts/nswc_part_09.f90#L70) | [Documented](docs/18-curve-fitting.md#topic-340-01) |
| `PI1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, BB, KUB, BL, LB, PBL, V, XL, NP1, N5, BS, PS, WS, XS, IWK` | [78171](source_parts/nswc_part_08.f90#L3717) | Not indexed |
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [26865](source_parts/nswc_part_03.f90#L5707) | [Documented](docs/05-polynomials.md#topic-116-01) |
| `PJAC` | `SUBROUTINE` | `NEQ, Y, YH, NYH, EWT, FTEM, SAVF, WM, IWM, F, JAC, RPAR, IPAR` | [110656](source_parts/nswc_part_11.f90#L4328) | Not indexed |
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [26020](source_parts/nswc_part_03.f90#L4862) | [Documented](docs/04-special-functions.md#topic-109-01) |
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [26454](source_parts/nswc_part_03.f90#L5296) | [Documented](docs/05-polynomials.md#topic-110-01) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [25298](source_parts/nswc_part_03.f90#L4140) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [25341](source_parts/nswc_part_03.f90#L4183) | [Documented](docs/04-special-functions.md#topic-102-01) |
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [26762](source_parts/nswc_part_03.f90#L5604) | [Documented](docs/05-polynomials.md#topic-115-01) |
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [26582](source_parts/nswc_part_03.f90#L5424) | [Documented](docs/05-polynomials.md#topic-113-01) |
| `PNDF` | `FUNCTION` | `X, IND` | [7789](source_parts/nswc_part_01.f90#L7789) | [Documented](docs/04-special-functions.md#topic-053-01) |
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [7811](source_parts/nswc_part_01.f90#L7811) | [Documented](docs/04-special-functions.md#topic-054-01) |
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [3064](source_parts/nswc_part_01.f90#L3064) | [Documented](docs/02-elementary-operations.md#topic-028-01) |
| `POLYDD` | `DOUBLE PRECISION FUNCTION` | `X` | [83998](source_parts/nswc_part_08.f90#L9544) | Not indexed |
| `POLYEV` | `SUBROUTINE` | `N, SR, SI, PR, PI, QR, QI, PVR, PVI` | [30653](source_parts/nswc_part_03.f90#L9495) | Not indexed |
| `PPADD` | `SUBROUTINE` | `N, IERROR, A, C, CBP, BP, BH` | [114048](source_parts/nswc_part_11.f90#L7720) | Not indexed |
| `PPSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [114233](source_parts/nswc_part_11.f90#L7905) | Not indexed |
| `PPSPF` | `FUNCTION` | `X, IZ, C, A, BH` | [114243](source_parts/nswc_part_11.f90#L7915) | Not indexed |
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [89413](source_parts/nswc_part_09.f90#L4414) | [Documented](docs/18-curve-fitting.md#topic-372-01) |
| `PROD0` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, W, U` | [113381](source_parts/nswc_part_11.f90#L7053) | Not indexed |
| `PRODP` | `SUBROUTINE` | `ND, BD, NM1, BM1, NM2, BM2, NA, AA, X, Y, M, A, B, C, D, U, W` | [113468](source_parts/nswc_part_11.f90#L7140) | Not indexed |
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [86926](source_parts/nswc_part_09.f90#L1927) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [87000](source_parts/nswc_part_09.f90#L2001) | [Documented](docs/18-curve-fitting.md#topic-354-01) |
| `PSGF` | `FUNCTION` | `X, IZ, C, A, BH` | [114199](source_parts/nswc_part_11.f90#L7871) | Not indexed |
| `PSI` | `REAL FUNCTION` | `XX` | [11989](source_parts/nswc_part_02.f90#L1408) | [Documented](docs/04-special-functions.md#topic-069-01) |
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [12601](source_parts/nswc_part_02.f90#L2020) | [Documented](docs/04-special-functions.md#topic-071-01) |
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [26542](source_parts/nswc_part_03.f90#L5384) | [Documented](docs/05-polynomials.md#topic-112-01) |
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [98898](source_parts/nswc_part_10.f90#L3207) | [Documented](docs/22-numerical-integration.md#topic-405-01) |
| `QAGI1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [79582](source_parts/nswc_part_08.f90#L5128) | Not indexed |
| `QAGIE` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [99077](source_parts/nswc_part_10.f90#L3386) | Not indexed |
| `QAGIE1` | `SUBROUTINE` | `F, PHI, Y, C, BOUND, INF, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [79777](source_parts/nswc_part_08.f90#L5323) | Not indexed |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [98092](source_parts/nswc_part_10.f90#L2401) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QAGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, NEVAL, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST` | [98269](source_parts/nswc_part_10.f90#L2578) | Not indexed |
| `QDCRT` | `SUBROUTINE` | `A, Z` | [28263](source_parts/nswc_part_03.f90#L7105) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QELG` | `SUBROUTINE` | `N, EPSTAB, RESULT, ABSERR, RES3LA, NRES, EPMACH, OFLOW` | [99854](source_parts/nswc_part_10.f90#L4163) | Not indexed |
| `QFORM` | `SUBROUTINE` | `M, N, Q, LDQ, WA` | [74827](source_parts/nswc_part_08.f90#L373) | Not indexed |
| `QK15I` | `SUBROUTINE` | `F, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [99541](source_parts/nswc_part_10.f90#L3850) | Not indexed |
| `QK15I1` | `SUBROUTINE` | `F, PHI, Y, C, BOUN, INF, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW` | [80248](source_parts/nswc_part_08.f90#L5794) | Not indexed |
| `QK21F` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, EPMACH, UFLOW, ISIG` | [98721](source_parts/nswc_part_10.f90#L3030) | Not indexed |
| `QPSRT` | `SUBROUTINE` | `LIMIT, LAST, MAXERR, ERMAX, ELIST, IORD, NRMAX` | [99719](source_parts/nswc_part_10.f90#L4028) | Not indexed |
| `QRFAC` | `SUBROUTINE` | `M, N, A, LDA, PIVOT, IPVT, LIPVT, RDIAG, ACNORM, WA` | [74923](source_parts/nswc_part_08.f90#L469) | Not indexed |
| `QRSOLV` | `SUBROUTINE` | `N, R, LDR, IPVT, DIAG, QTB, X, SDIAG, WA` | [75088](source_parts/nswc_part_08.f90#L634) | Not indexed |
| `QRUPDT` | `SUBROUTINE` | `NR, N, A, U, V` | [73319](source_parts/nswc_part_07.f90#L9516) | Not indexed |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [2398](source_parts/nswc_part_01.f90#L2398) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [1999](source_parts/nswc_part_01.f90#L1999) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [2198](source_parts/nswc_part_01.f90#L2198) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [97603](source_parts/nswc_part_10.f90#L1912) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [28800](source_parts/nswc_part_03.f90#L7642) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-126-01) |
| `QUAD` | `SUBROUTINE` | `A, B, RESULT, K, EPSIL, NPTS, ICHECK, F` | [97752](source_parts/nswc_part_10.f90#L2061) | Not indexed |
| `QUADIT` | `SUBROUTINE` | `UU, VV, NZ, NN, P, QP, K, QK` | [29592](source_parts/nswc_part_03.f90#L8434) | Not indexed |
| `QUADPL` | `SUBROUTINE` | `A, B1, C, SR, SI, LR, LI` | [29994](source_parts/nswc_part_03.f90#L8836) | Not indexed |
| `QUADSD` | `SUBROUTINE` | `NN, U, V, P, Q, A, B` | [29971](source_parts/nswc_part_03.f90#L8813) | Not indexed |
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [88495](source_parts/nswc_part_09.f90#L3496) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [88712](source_parts/nswc_part_09.f90#L3713) | [Documented](docs/18-curve-fitting.md#topic-365-01) |
| `QXCPY` | `SUBROUTINE` | `A, B, L` | [100626](source_parts/nswc_part_10.f90#L4935) | Not indexed |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [100034](source_parts/nswc_part_10.f90#L4343) | [Documented](docs/22-numerical-integration.md#topic-398-01) |
| `QXGSE` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, LIMIT, RESULT, ABSERR, IER, ALIST, BLIST, RLIST, ELIST, IORD, LAST, VALP, VALN, LP, LN` | [100203](source_parts/nswc_part_10.f90#L4512) | Not indexed |
| `QXLQM` | `SUBROUTINE` | `F, A, B, RESULT, ABSERR, RESABS, RESASC, VR, VS, LR, LS, KEY, EPMACH, UFLOW, OFLOW` | [100639](source_parts/nswc_part_10.f90#L4948) | Not indexed |
| `QXRRD` | `SUBROUTINE` | `F, Z, LZ, XL, XU, R, S, LR, LS` | [100947](source_parts/nswc_part_10.f90#L5256) | Not indexed |
| `QXRUL` | `SUBROUTINE` | `F, XL, XU, Y, YA, YM, KE, K1, FV1, FV2, L1, L2` | [100752](source_parts/nswc_part_10.f90#L5061) | Not indexed |
| `R1MPYQ` | `SUBROUTINE` | `M, N, A, LDA, V, W` | [75282](source_parts/nswc_part_08.f90#L828) | Not indexed |
| `R1UPDT` | `SUBROUTINE` | `M, N, S, LS, U, V, W, SING` | [75375](source_parts/nswc_part_08.f90#L921) | Not indexed |
| `RADB2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [81719](source_parts/nswc_part_08.f90#L7265) | Not indexed |
| `RADB3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [81765](source_parts/nswc_part_08.f90#L7311) | Not indexed |
| `RADB4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [81831](source_parts/nswc_part_08.f90#L7377) | Not indexed |
| `RADB5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [81923](source_parts/nswc_part_08.f90#L7469) | Not indexed |
| `RADBG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [82035](source_parts/nswc_part_08.f90#L7581) | Not indexed |
| `RADF2` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1` | [82330](source_parts/nswc_part_08.f90#L7876) | Not indexed |
| `RADF3` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2` | [82376](source_parts/nswc_part_08.f90#L7922) | Not indexed |
| `RADF4` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3` | [82440](source_parts/nswc_part_08.f90#L7986) | Not indexed |
| `RADF5` | `SUBROUTINE` | `IDO, L1, CC, CH, WA1, WA2, WA3, WA4` | [82528](source_parts/nswc_part_08.f90#L8074) | Not indexed |
| `RADFG` | `SUBROUTINE` | `IDO, IP, L1, IDL1, CC, C1, C2, CH, CH2, WA` | [82636](source_parts/nswc_part_08.f90#L8182) | Not indexed |
| `RADIX` | `SUBROUTINE` | `IBETA` | [705](source_parts/nswc_part_01.f90#L705) | Not indexed |
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [115721](source_parts/nswc_part_11.f90#L9393) | [Documented](docs/27-continuous-random-number-generation.md#topic-447-01) |
| `RARC` | `SUBROUTINE` | `IA, IB, AR, AC, PR, PC, VR, VC, K1, JJ, LL, N, M, NP1` | [5582](source_parts/nswc_part_01.f90#L5582) | Not indexed |
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [116000](source_parts/nswc_part_11.f90#L9672) | [Documented](docs/27-continuous-random-number-generation.md#topic-451-01) |
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [30700](source_parts/nswc_part_03.f90#L9542) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-129-01) |
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [114907](source_parts/nswc_part_11.f90#L8579) | [Documented](docs/27-continuous-random-number-generation.md#topic-441-01) |
| `RCIR1` | `SUBROUTINE` | `N, IX, X, KX, Y, KY, IERR` | [114920](source_parts/nswc_part_11.f90#L8592) | Not indexed |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [13794](source_parts/nswc_part_02.f90#L3213) | [Documented](docs/04-special-functions.md#topic-072-01) |
| `RCVAL1` | `SUBROUTINE` | `X, Y, ERRTOL, RC, IERR` | [24647](source_parts/nswc_part_03.f90#L3489) | Not indexed |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [24127](source_parts/nswc_part_03.f90#L2969) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `REALIT` | `SUBROUTINE` | `SSS, NZ, IFLAG, NN, P, QP, K, QK` | [29697](source_parts/nswc_part_03.f90#L8539) | Not indexed |
| `REXP` | `REAL FUNCTION` | `X` | [3837](source_parts/nswc_part_01.f90#L3837) | [Documented](docs/02-elementary-operations.md#topic-036-01) |
| `REXP1` | `SUBROUTINE` | `X, E, W` | [3921](source_parts/nswc_part_01.f90#L3921) | Not indexed |
| `RFFTB` | `SUBROUTINE` | `N, R, WSAVE` | [81646](source_parts/nswc_part_08.f90#L7192) | Not indexed |
| `RFFTB1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [81656](source_parts/nswc_part_08.f90#L7202) | Not indexed |
| `RFFTF` | `SUBROUTINE` | `N, R, WSAVE` | [82256](source_parts/nswc_part_08.f90#L7802) | Not indexed |
| `RFFTF1` | `SUBROUTINE` | `N, C, CH, WA, IFAC` | [82266](source_parts/nswc_part_08.f90#L7812) | Not indexed |
| `RFFTI` | `SUBROUTINE` | `N, WSAVE` | [81514](source_parts/nswc_part_08.f90#L7060) | Not indexed |
| `RFFTI1` | `SUBROUTINE` | `N, WA, IFAC` | [81524](source_parts/nswc_part_08.f90#L7070) | Not indexed |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [23905](source_parts/nswc_part_03.f90#L2747) | [Documented](docs/04-special-functions.md#topic-092-01) |
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [115885](source_parts/nswc_part_11.f90#L9557) | [Documented](docs/27-continuous-random-number-generation.md#topic-449-01) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [1653](source_parts/nswc_part_01.f90#L1653) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [24371](source_parts/nswc_part_03.f90#L3213) | [Documented](docs/04-special-functions.md#topic-096-01) |
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [111228](source_parts/nswc_part_11.f90#L4900) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-431-01) |
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [111285](source_parts/nswc_part_11.f90#L4957) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-433-01) |
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [107314](source_parts/nswc_part_11.f90#L986) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-421-01) |
| `RKFC` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, W, WP, X, HINT, H, Y1, Y2, F1, F2, F3, F4, F7, SAVRE, SAVAE, TOLD, NFE, JFLAG, KFLAG, ENDPNT, BLKOUT` | [106689](source_parts/nswc_part_11.f90#L361) | Not indexed |
| `RKFS` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, YP, H, F1, F2, F3, F4, F5, SAVRE, SAVAE, NFE, KOP, INIT, JFLAG, KFLAG` | [107508](source_parts/nswc_part_11.f90#L1180) | Not indexed |
| `RLOC` | `LOGICAL FUNCTION` | `X, Y` | [33915](source_parts/nswc_part_04.f90#L2168) | Not indexed |
| `RLOG` | `REAL FUNCTION` | `X` | [4094](source_parts/nswc_part_01.f90#L4094) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RLOG1` | `REAL FUNCTION` | `X` | [4143](source_parts/nswc_part_01.f90#L4143) | [Documented](docs/02-elementary-operations.md#topic-037-01) |
| `RMIN` | `FUNCTION` | `N, M, COND, UNITRD, AVERR` | [104838](source_parts/nswc_part_10.f90#L9147) | Not indexed |
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [116546](source_parts/nswc_part_11.f90#L10218) | [Documented](docs/27-continuous-random-number-generation.md#topic-456-01) |
| `RNDERR` | `FUNCTION` | `X, A, Y, B` | [104202](source_parts/nswc_part_10.f90#L8511) | Not indexed |
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [34287](source_parts/nswc_part_04.f90#L2540) | [Documented](docs/08-matrices.md#topic-161-01) |
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [115100](source_parts/nswc_part_11.f90#L8772) | [Documented](docs/27-continuous-random-number-generation.md#topic-442-01) |
| `RNRM` | `REAL FUNCTION` | `X, Y, N, IFLAG` | [104854](source_parts/nswc_part_10.f90#L9163) | Not indexed |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [2670](source_parts/nswc_part_01.f90#L2670) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `ROT3` | `SUBROUTINE` | `A, THETA` | [3245](source_parts/nswc_part_01.f90#L3245) | [Documented](docs/02-elementary-operations.md#topic-030-01) |
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [3086](source_parts/nswc_part_01.f90#L3086) | [Documented](docs/02-elementary-operations.md#topic-028-03) |
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [51858](source_parts/nswc_part_05.f90#L9355) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [51917](source_parts/nswc_part_05.f90#L9414) | [Documented](docs/11-sparse-matrices.md#topic-233-01) |
| `RRSORT` | `SUBROUTINE` | `A, B, N` | [1705](source_parts/nswc_part_01.f90#L1705) | Not indexed |
| `RSCO` | `SUBROUTINE` | `RSAV, ISAV` | [109365](source_parts/nswc_part_11.f90#L3037) | Not indexed |
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51760](source_parts/nswc_part_05.f90#L9257) | [Documented](docs/11-sparse-matrices.md#topic-231-01) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [53861](source_parts/nswc_part_06.f90#L857) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `RSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [53959](source_parts/nswc_part_06.f90#L955) | Not indexed |
| `RSORT` | `SUBROUTINE` | `A, N` | [1607](source_parts/nswc_part_01.f90#L1607) | Not indexed |
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [55257](source_parts/nswc_part_06.f90#L2253) | [Documented](docs/11-sparse-matrices.md#topic-250-01) |
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [53005](source_parts/nswc_part_06.f90#L1) | [Documented](docs/11-sparse-matrices.md#topic-242-01) |
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [52221](source_parts/nswc_part_05.f90#L9718) | [Documented](docs/11-sparse-matrices.md#topic-236-01) |
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [32460](source_parts/nswc_part_04.f90#L713) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [32327](source_parts/nswc_part_04.f90#L580) | [Documented](docs/07-vectors.md#topic-138-01) |
| `SCALCP` | `DOUBLE PRECISION FUNCTION` | `NN, PT, ETA, INFIN, SMALNO, BASE` | [30263](source_parts/nswc_part_03.f90#L9105) | Not indexed |
| `SCALDN` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [96605](source_parts/nswc_part_10.f90#L914) | Not indexed |
| `SCALEX` | `SUBROUTINE` | `MO, X, TYPSIZ, N, IERR` | [72896](source_parts/nswc_part_07.f90#L9093) | Not indexed |
| `SCALPM` | `SUBROUTINE` | `COORD, NPTS, MAXABS` | [96569](source_parts/nswc_part_10.f90#L878) | Not indexed |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [32547](source_parts/nswc_part_04.f90#L800) | [Documented](docs/07-vectors.md#topic-139-01) |
| `SCD` | `SUBROUTINE` | `U, K, L, F, S, C, D` | [24925](source_parts/nswc_part_03.f90#L3767) | Not indexed |
| `SCDF` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [24995](source_parts/nswc_part_03.f90#L3837) | Not indexed |
| `SCDJ` | `SUBROUTINE` | `U, K, L, F, F1, S, C, D` | [25053](source_parts/nswc_part_03.f90#L3895) | Not indexed |
| `SCDM` | `SUBROUTINE` | `U, K, S, C, D` | [24974](source_parts/nswc_part_03.f90#L3816) | Not indexed |
| `SCHUR` | `SUBROUTINE` | `N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR` | [43407](source_parts/nswc_part_05.f90#L904) | Not indexed |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [32833](source_parts/nswc_part_04.f90#L1086) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [85792](source_parts/nswc_part_09.f90#L793) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [85888](source_parts/nswc_part_09.f90#L889) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [85986](source_parts/nswc_part_09.f90#L987) | [Documented](docs/18-curve-fitting.md#topic-347-01) |
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51833](source_parts/nswc_part_05.f90#L9330) | [Documented](docs/11-sparse-matrices.md#topic-232-01) |
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [30996](source_parts/nswc_part_03.f90#L9838) | [Documented](docs/07-vectors.md#topic-130-01) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51626](source_parts/nswc_part_05.f90#L9123) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [51700](source_parts/nswc_part_05.f90#L9197) | [Documented](docs/11-sparse-matrices.md#topic-230-01) |
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [51604](source_parts/nswc_part_05.f90#L9101) | [Documented](docs/11-sparse-matrices.md#topic-228-01) |
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [32008](source_parts/nswc_part_04.f90#L261) | [Documented](docs/07-vectors.md#topic-136-01) |
| `SECFAC` | `SUBROUTINE` | `NR, N, X, G, A, XPLS, GPLS, ITNCNT, TOL, NOUPDT, S, Y, W` | [73188](source_parts/nswc_part_07.f90#L9385) | Not indexed |
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [59521](source_parts/nswc_part_06.f90#L6517) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [59541](source_parts/nswc_part_06.f90#L6537) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-269-01) |
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [59561](source_parts/nswc_part_06.f90#L6557) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [59574](source_parts/nswc_part_06.f90#L6570) | [Documented](docs/12-eigenvalues-and-eigenvectors.md#topic-270-01) |
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [111358](source_parts/nswc_part_11.f90#L5030) | [Documented](docs/25-partial-differential-equations.md#topic-434-01) |
| `SEPEL1` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, AN, BN, CN, DN, UN, ZN, AM, BM, CM, DM, UM, ZM, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [112100](source_parts/nswc_part_11.f90#L5772) | Not indexed |
| `SEPELL` | `SUBROUTINE` | `INTL, IORDER, A, B, M, MBDCND, BDA, ALPHA, BDB, BETA, C, D, N, NBDCND, BDC, GAMA, BDD, XNU, COFX, COFY, GRHS, MN, USOL, IDMN, W, PERTRB, IERROR` | [111610](source_parts/nswc_part_11.f90#L5282) | Not indexed |
| `SETRM` | `SUBROUTINE` | `XK, YK, ZK, XI, YI, ZI, S1, S2, R, ROW` | [94841](source_parts/nswc_part_09.f90#L9842) | Not indexed |
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [86087](source_parts/nswc_part_09.f90#L1088) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [86190](source_parts/nswc_part_09.f90#L1191) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [86294](source_parts/nswc_part_09.f90#L1295) | [Documented](docs/18-curve-fitting.md#topic-349-01) |
| `SFFT` | `SUBROUTINE` | `A, B, NTOT, N, NSPAN, ISN, IERR` | [80522](source_parts/nswc_part_08.f90#L6068) | Not indexed |
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [108519](source_parts/nswc_part_11.f90#L2191) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [108543](source_parts/nswc_part_11.f90#L2215) | [Documented](docs/24-ordinary-differential-equations-initial-value-problems.md#topic-427-01) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [95068](source_parts/nswc_part_09.f90#L10069) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [95095](source_parts/nswc_part_09.f90#L10096) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `SGBFA` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, INFO` | [110890](source_parts/nswc_part_11.f90#L4562) | Not indexed |
| `SGBSL` | `SUBROUTINE` | `ABD, LDA, N, ML, MU, IPVT, B, JOB` | [111062](source_parts/nswc_part_11.f90#L4734) | Not indexed |
| `SGECO` | `SUBROUTINE` | `A, LDA, N, IPVT, RCOND, Z` | [35330](source_parts/nswc_part_04.f90#L3583) | Not indexed |
| `SGEDI` | `SUBROUTINE` | `A, LDA, N, IPVT, DET, WORK, JOB` | [35749](source_parts/nswc_part_04.f90#L4002) | Not indexed |
| `SGEFA` | `SUBROUTINE` | `A, LDA, N, IPVT, INFO` | [35525](source_parts/nswc_part_04.f90#L3778) | Not indexed |
| `SGESL` | `SUBROUTINE` | `A, LDA, N, IPVT, B, JOB` | [35630](source_parts/nswc_part_04.f90#L3883) | Not indexed |
| `SHELL` | `SUBROUTINE` | `A, N` | [1510](source_parts/nswc_part_01.f90#L1510) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [1556](source_parts/nswc_part_01.f90#L1556) | [Documented](docs/02-elementary-operations.md#topic-021-01) |
| `SHIFTD` | `SUBROUTINE` | `NFRST, NLAST, KK, IARR` | [93529](source_parts/nswc_part_09.f90#L8530) | Not indexed |
| `SHRSLV` | `SUBROUTINE` | `A, B, C, M, N, NA, NB, NC, IERR` | [43680](source_parts/nswc_part_05.f90#L1177) | Not indexed |
| `SI` | `FUNCTION` | `X` | [9851](source_parts/nswc_part_01.f90#L9851) | [Documented](docs/04-special-functions.md#topic-061-01) |
| `SIGMA1` | `SUBROUTINE` | `N, M, P, W, Q, I, B, KUB, UB, NP1, N5, LX, LR, BS, PS, WS, XS, IWK` | [78127](source_parts/nswc_part_08.f90#L3673) | Not indexed |
| `SIN0` | `REAL FUNCTION` | `X` | [3363](source_parts/nswc_part_01.f90#L3363) | Not indexed |
| `SIN1` | `REAL FUNCTION` | `X` | [3391](source_parts/nswc_part_01.f90#L3391) | [Documented](docs/02-elementary-operations.md#topic-033-01) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [81472](source_parts/nswc_part_08.f90#L7018) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [81405](source_parts/nswc_part_08.f90#L6951) | [Documented](docs/16-transforms.md#topic-324-01) |
| `SKNP` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, N5, PS, WS, XS, IWK` | [78310](source_parts/nswc_part_08.f90#L3856) | Not indexed |
| `SKNP1` | `SUBROUTINE` | `NS, QS, KUB, VS, N, NP1, PS, WS, XS, D, MIN, PBAR, WBAR, ZBAR` | [78335](source_parts/nswc_part_08.f90#L3881) | Not indexed |
| `SLV` | `SUBROUTINE` | `N, M, A, KA, B, KB, IERR` | [34953](source_parts/nswc_part_04.f90#L3206) | Not indexed |
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [35208](source_parts/nswc_part_04.f90#L3461) | [Documented](docs/08-matrices.md#topic-168-01) |
| `SLVS` | `SUBROUTINE` | `WM, IWM, X, TEM` | [110821](source_parts/nswc_part_11.f90#L4493) | Not indexed |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [33749](source_parts/nswc_part_04.f90#L2002) | [Documented](docs/08-matrices.md#topic-151-01) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [33226](source_parts/nswc_part_04.f90#L1479) | [Documented](docs/08-matrices.md#topic-146-01) |
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [75582](source_parts/nswc_part_08.f90#L1128) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SMPLX1` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [75620](source_parts/nswc_part_08.f90#L1166) | Not indexed |
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [34194](source_parts/nswc_part_04.f90#L2447) | [Documented](docs/08-matrices.md#topic-159-01) |
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [37672](source_parts/nswc_part_04.f90#L5925) | [Documented](docs/08-matrices.md#topic-173-01) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [33799](source_parts/nswc_part_04.f90#L2052) | [Documented](docs/08-matrices.md#topic-153-01) |
| `SNBFA` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, INFO` | [50070](source_parts/nswc_part_05.f90#L7567) | Not indexed |
| `SNBSL` | `SUBROUTINE` | `A, LDA, N, ML, MU, IPVT, B, JOB` | [50240](source_parts/nswc_part_05.f90#L7737) | Not indexed |
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [3681](source_parts/nswc_part_01.f90#L3681) | [Documented](docs/02-elementary-operations.md#topic-035-01) |
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [52983](source_parts/nswc_part_05.f90#L10480) | [Documented](docs/11-sparse-matrices.md#topic-243-01) |
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [32581](source_parts/nswc_part_04.f90#L834) | [Documented](docs/07-vectors.md#topic-140-01) |
| `SOL` | `SUBROUTINE` | `N, NDIM, A, B, IP` | [34857](source_parts/nswc_part_04.f90#L3110) | Not indexed |
| `SOLBT` | `SUBROUTINE` | `M, N, A, B, C, Y, IP` | [37606](source_parts/nswc_part_04.f90#L5859) | Not indexed |
| `SOLVE2` | `SUBROUTINE` | `M, N, M1, A, B, W, N1, IPIVOT, QR, D, ETA, FAIL, NUMIT, DIGITX, X, RES, WRES, Y1, Y2, Y, F, G, MM, MMPNN` | [70671](source_parts/nswc_part_07.f90#L6868) | Not indexed |
| `SOLVE3` | `SUBROUTINE` | `F, M1, M, N1, QR, D, Y, MMPNN` | [70822](source_parts/nswc_part_07.f90#L7019) | Not indexed |
| `SONEST` | `SUBROUTINE` | `N, V, X, ISGN, ANORM, KASE, ITER, J, JUMP` | [55379](source_parts/nswc_part_06.f90#L2375) | Not indexed |
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [85652](source_parts/nswc_part_09.f90#L653) | [Documented](docs/18-curve-fitting.md#topic-344-01) |
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [91194](source_parts/nswc_part_09.f90#L6195) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-379-01) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [85491](source_parts/nswc_part_09.f90#L492) | [Documented](docs/18-curve-fitting.md#topic-342-01) |
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [70959](source_parts/nswc_part_07.f90#L7156) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `SPLU` | `SUBROUTINE` | `A, IA, JA, R, C, IC, N, MAX, D, T, IT, JT, IU, W, P, IERR` | [54150](source_parts/nswc_part_06.f90#L1146) | Not indexed |
| `SPMPAR` | `REAL FUNCTION` | `I` | [1221](source_parts/nswc_part_01.f90#L1221) | [Documented](docs/02-elementary-operations.md#topic-017-01) |
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [53086](source_parts/nswc_part_06.f90#L82) | [Documented](docs/11-sparse-matrices.md#topic-244-01) |
| `SPPDI` | `SUBROUTINE` | `AP, N, DET, JOB` | [39868](source_parts/nswc_part_04.f90#L8121) | Not indexed |
| `SPPFA` | `SUBROUTINE` | `AP, N, INFO` | [39711](source_parts/nswc_part_04.f90#L7964) | Not indexed |
| `SPPSL` | `SUBROUTINE` | `AP, N, B` | [39801](source_parts/nswc_part_04.f90#L8054) | Not indexed |
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [52575](source_parts/nswc_part_05.f90#L10072) | [Documented](docs/11-sparse-matrices.md#topic-238-01) |
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [53477](source_parts/nswc_part_06.f90#L473) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `SQUIN2` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD, EYE, TEMP, NW, TOL, MAXITS, IERR` | [45064](source_parts/nswc_part_05.f90#L2561) | Not indexed |
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [44965](source_parts/nswc_part_05.f90#L2462) | [Documented](docs/08-matrices.md#topic-189-01) |
| `SRCH` | `SUBROUTINE` | `FUN, COND, XL, ETA, X, NUM, IERR` | [78738](source_parts/nswc_part_08.f90#L4284) | Not indexed |
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [31368](source_parts/nswc_part_03.f90#L10210) | [Documented](docs/07-vectors.md#topic-132-01) |
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [3094](source_parts/nswc_part_01.f90#L3094) | [Documented](docs/02-elementary-operations.md#topic-029-01) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [31635](source_parts/nswc_part_03.f90#L10477) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [31484](source_parts/nswc_part_03.f90#L10326) | [Documented](docs/07-vectors.md#topic-133-01) |
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [32184](source_parts/nswc_part_04.f90#L437) | [Documented](docs/07-vectors.md#topic-137-01) |
| `SSPCO` | `SUBROUTINE` | `AP, N, KPVT, RCOND, Z` | [37707](source_parts/nswc_part_04.f90#L5960) | Not indexed |
| `SSPDI` | `SUBROUTINE` | `AP, N, KPVT, DET, INERT, WORK, JOB` | [38439](source_parts/nswc_part_04.f90#L6692) | Not indexed |
| `SSPFA` | `SUBROUTINE` | `AP, N, KPVT, INFO` | [37993](source_parts/nswc_part_04.f90#L6246) | Not indexed |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [76404](source_parts/nswc_part_08.f90#L1950) | [Documented](docs/15-optimization.md#topic-311-01) |
| `SSPLX1` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, R, Z, ITER, MXITER, EPS0, RERRMN, RERRMX, RERR, NUMLE, NUMGE, BI, XB, Y, BASIS, INDEX` | [76443](source_parts/nswc_part_08.f90#L1989) | Not indexed |
| `SSPSL` | `SUBROUTINE` | `AP, N, KPVT, B` | [38258](source_parts/nswc_part_04.f90#L6511) | Not indexed |
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [52398](source_parts/nswc_part_05.f90#L9895) | [Documented](docs/11-sparse-matrices.md#topic-237-01) |
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [41541](source_parts/nswc_part_04.f90#L9794) | [Documented](docs/08-matrices.md#topic-183-01) |
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [31217](source_parts/nswc_part_03.f90#L10059) | [Documented](docs/07-vectors.md#topic-131-01) |
| `STEP1` | `SUBROUTINE` | `F, NEQN, Y, X, H, EPS, WT, START, HOLD, K, KOLD, CRASH, PHI, P, YP, PSI, ALPHA, BETA, SIG, V, W, G, PHASE1, NS, NORND` | [105830](source_parts/nswc_part_10.f90#L10139) | Not indexed |
| `STFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR, JAC` | [108574](source_parts/nswc_part_11.f90#L2246) | Not indexed |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [71392](source_parts/nswc_part_07.f90#L7589) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-304-01) |
| `STOD` | `SUBROUTINE` | `NEQ, Y, YH, NYH, YH1, EWT, SAVF, ACOR, WM, IWM, F, JAC, RPAR, IPAR` | [110084](source_parts/nswc_part_11.f90#L3756) | Not indexed |
| `STORE2` | `SUBROUTINE` | `A, B` | [964](source_parts/nswc_part_01.f90#L964) | Not indexed |
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [91771](source_parts/nswc_part_09.f90#L6772) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-384-01) |
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [92152](source_parts/nswc_part_09.f90#L7153) | [Documented](docs/19-surface-fitting-over-rectangular-grids.md#topic-386-01) |
| `SVCO` | `SUBROUTINE` | `RSAV, ISAV` | [109384](source_parts/nswc_part_11.f90#L3056) | Not indexed |
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [34138](source_parts/nswc_part_04.f90#L2391) | [Documented](docs/08-matrices.md#topic-157-01) |
| `SWAPD` | `SUBROUTINE` | `NIN1, NIN2, NOUT1, NOUT2, IADJ, IEND` | [93641](source_parts/nswc_part_09.f90#L8642) | Not indexed |
| `SWPTST` | `LOGICAL FUNCTION` | `IN1, IN2, IO1, IO2, X, Y` | [93827](source_parts/nswc_part_09.f90#L8828) | Not indexed |
| `SYMSLV` | `SUBROUTINE` | `A, C, N, NA, NC, IERR` | [44533](source_parts/nswc_part_05.f90#L2030) | Not indexed |
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [44371](source_parts/nswc_part_05.f90#L1868) | [Documented](docs/08-matrices.md#topic-188-01) |
| `TASLV1` | `SUBROUTINE` | `MO, N, A, NA, U, NU, C, NC, WK, IERR` | [44429](source_parts/nswc_part_05.f90#L1926) | Not indexed |
| `TERMS` | `SUBROUTINE` | `DIAG, SDIAG, SIGMA, DEL` | [88898](source_parts/nswc_part_09.f90#L3899) | Not indexed |
| `TINDX` | `INTEGER FUNCTION` | `NVERTX, NABOR, IADJ, IEND` | [93927](source_parts/nswc_part_09.f90#L8928) | Not indexed |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [33295](source_parts/nswc_part_04.f90#L1548) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [34181](source_parts/nswc_part_04.f90#L2434) | [Documented](docs/08-matrices.md#topic-158-01) |
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [40306](source_parts/nswc_part_04.f90#L8559) | [Documented](docs/08-matrices.md#topic-177-01) |
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [33265](source_parts/nswc_part_04.f90#L1518) | [Documented](docs/08-matrices.md#topic-148-01) |
| `TQL2` | `SUBROUTINE` | `NM, N, D, E, Z, IERR` | [60223](source_parts/nswc_part_06.f90#L7219) | Not indexed |
| `TQLRAT` | `SUBROUTINE` | `N, D, E2, IERR` | [59816](source_parts/nswc_part_06.f90#L6812) | Not indexed |
| `TQLRT0` | `SUBROUTINE` | `N, D, E2, IERR` | [113887](source_parts/nswc_part_11.f90#L7559) | Not indexed |
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [116380](source_parts/nswc_part_11.f90#L10052) | [Documented](docs/27-continuous-random-number-generation.md#topic-454-01) |
| `TRED1` | `SUBROUTINE` | `NM, N, A, D, E, E2` | [59587](source_parts/nswc_part_06.f90#L6583) | Not indexed |
| `TRED2` | `SUBROUTINE` | `NM, N, A, D, E, Z` | [60083](source_parts/nswc_part_06.f90#L7079) | Not indexed |
| `TRED3` | `SUBROUTINE` | `N, NV, A, D, E, E2` | [59703](source_parts/nswc_part_06.f90#L6699) | Not indexed |
| `TRFIND` | `SUBROUTINE` | `NST, PX, PY, X, Y, IADJ, IEND, I1, I2, I3` | [93981](source_parts/nswc_part_09.f90#L8982) | Not indexed |
| `TRISLV` | `SUBROUTINE` | `NM, N, U, V, L, F, TEMP, IERR` | [45769](source_parts/nswc_part_05.f90#L3266) | Not indexed |
| `TRISP` | `SUBROUTINE` | `N, A, B, C, D, U, Z` | [112622](source_parts/nswc_part_11.f90#L6294) | Not indexed |
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [92839](source_parts/nswc_part_09.f90#L7840) | [Documented](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md#topic-392-01) |
| `TRP` | `FUNCTION` | `A, N, X, Y` | [84817](source_parts/nswc_part_08.f90#L10363) | [Documented](docs/18-curve-fitting.md#topic-336-01) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [54001](source_parts/nswc_part_06.f90#L997) | [Documented](docs/11-sparse-matrices.md#topic-246-01) |
| `TSLV1` | `SUBROUTINE` | `N, R, C, IC, D, T, IT, JT, IU, B, X, Y` | [54099](source_parts/nswc_part_06.f90#L1095) | Not indexed |
| `TVAL` | `SUBROUTINE` | `X, Y, X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3, ZX1, ZX2, ZX3, ZY1, ZY2, ZY3, IFLAG, W, WX, WY, IER` | [95402](source_parts/nswc_part_09.f90#L10403) | Not indexed |
| `U11LS` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IC, IR` | [64653](source_parts/nswc_part_07.f90#L850) | Not indexed |
| `U11US` | `SUBROUTINE` | `A, MDA, M, N, UB, DB, MODE, NP, KRANK, KSURE, H, W, EB, IR, IC` | [65056](source_parts/nswc_part_07.f90#L1253) | Not indexed |
| `U12LS` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IC, IR` | [64915](source_parts/nswc_part_07.f90#L1112) | Not indexed |
| `U12US` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, MODE, KRANK, RNORM, H, W, IR, IC` | [65318](source_parts/nswc_part_07.f90#L1515) | Not indexed |
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [114253](source_parts/nswc_part_11.f90#L7925) | [Documented](docs/26-discrete-random-number-generation.md#topic-438-01) |
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [114352](source_parts/nswc_part_11.f90#L8024) | [Documented](docs/27-continuous-random-number-generation.md#topic-439-01) |
| `URNG0` | `SUBROUTINE` | `IX, U, V` | [114508](source_parts/nswc_part_11.f90#L8180) | Not indexed |
| `URNG1` | `SUBROUTINE` | `IX, U, V, D` | [114641](source_parts/nswc_part_11.f90#L8313) | Not indexed |
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [114782](source_parts/nswc_part_11.f90#L8454) | [Documented](docs/27-continuous-random-number-generation.md#topic-440-01) |
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [25388](source_parts/nswc_part_03.f90#L4230) | [Documented](docs/04-special-functions.md#topic-105-01) |
| `VNORM` | `FUNCTION` | `V, NCOMP` | [111196](source_parts/nswc_part_11.f90#L4868) | Not indexed |
| `VNWRMS` | `REAL FUNCTION` | `N, V, W` | [111209](source_parts/nswc_part_11.f90#L4881) | Not indexed |
| `VRSHFT` | `SUBROUTINE` | `L3, ZR, ZI, CONV, NN, PR, PI, HR, HI, QPR, QPI, QHR, QHI, SR, SI, TR, TI, PVR, PVI, ARE, MRE, ETA, INFIN` | [30505](source_parts/nswc_part_03.f90#L9347) | Not indexed |
| `WANDT` | `SUBROUTINE` | `WV, TV, N, A, B` | [104889](source_parts/nswc_part_10.f90#L9198) | Not indexed |
| `WNLIT` | `SUBROUTINE` | `W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM, IDOPE, DOPE, DONE` | [69692](source_parts/nswc_part_07.f90#L5889) | Not indexed |
| `WNLSM` | `SUBROUTINE` | `W, MDW, MME, MA, N, L, PRGOPT, X, RNORM, MODE, IPIVOT, ITYPE, WD, H, SCALE, Z, TEMP, D` | [69074](source_parts/nswc_part_07.f90#L5271) | Not indexed |
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [68814](source_parts/nswc_part_07.f90#L5011) | [Documented](docs/14-least-squares-solution-of-linear-equations.md#topic-296-01) |
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [85206](source_parts/nswc_part_09.f90#L207) | [Documented](docs/18-curve-fitting.md#topic-341-01) |
| `XCOND` | `SUBROUTINE` | `FUN, X, COND, NUM, IERR` | [79068](source_parts/nswc_part_08.f90#L4614) | Not indexed |
| `XCONDX` | `FUNCTION` | `X, Y, C, FUN` | [79134](source_parts/nswc_part_08.f90#L4680) | Not indexed |
| `XCONDY` | `FUNCTION` | `X, Y, C, FUN` | [79148](source_parts/nswc_part_08.f90#L4694) | Not indexed |
| `XL1` | `SUBROUTINE` | `K, L, M, N, KLMD, KLM2D, NKLMD, N2D, Q, KODE, TOLER, ITER, X, RES, ERROR, CU, IU, S` | [63396](source_parts/nswc_part_06.f90#L10392) | Not indexed |
| `YCHG` | `SUBROUTINE` | `X, Y, YOLD` | [33946](source_parts/nswc_part_04.f90#L2199) | Not indexed |
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [27427](source_parts/nswc_part_03.f90#L6269) | [Documented](docs/06-solutions-of-nonlinear-equations.md#topic-122-01) |
| `ZZZJAC` | `SUBROUTINE` | `T, Y, PD, N, RPAR, IPAR` | [108563](source_parts/nswc_part_11.f90#L2235) | Not indexed |
