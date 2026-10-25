# Explicit typing

All 1,062 library procedures now have `IMPLICIT NONE` and explicit types in the
maintained `nswc.f`, recommended `nswc.f90`, and generated source partitions.
Sixteen batches covered 17, 40, 29, 34, 32, 32, 31, 22, 22, 37, 28, 25, 21,
20, 20, and 652 procedures. No procedures remain to convert. The archived
`nswc_orig.f` retains its original implicit typing.

Each batch preserves the original data and function types and is checked with
compiler symbol comparisons and the numerical regression suite. Eleven
forwarded subroutine classifications are reviewed separately below.

## Batch 1: pilot

The first batch adds `IMPLICIT NONE` to 17 of the library's 1,062 procedures:

`IPMPAR`, `DERF`, `DGAMMA`, `BRATIO`, `DCSEVL`, `DRPLY1`, `DDOT`, `DAXPY`,
`DNRM2`, `DSVDC`, `CSVDC`, `DGEFA`, `DGESL`, `RFFTI1`, `CSLOOP`, `QAGS`,
and `RKF45`.

These procedures exercise integer, real, double precision, and complex data,
array workspaces, common storage, and callbacks. They are exercised by the
numerical test suite. Some already had all necessary type declarations; those
only needed the new statement. The maintained input is `nswc.f`, and the
corresponding free-form source and documentation links are regenerated together.
`nswc_orig.f` remains unchanged.

## Batch 2: vectors, special functions, and interpolation

The second batch adds 40 procedures, all exercised by the existing numerical
tests. The affected groups are:

- Vector operations: `SASUM`, `SAXPY`, `SCOPY`, `SDOT`, `SNRM2`, `SROT`, `SROTG`,
  `SROTM`, `SROTMG`, `SSCAL`, `SSWAP`, `ISAMAX`, `DASUM`, `DCOPY`, `DROT`,
  `DROTG`, `DSCAL`, `DSWAP`, and `IDAMAX`.
- Double precision functions: `DERFC`, `DERFC1`, `DGAMLN`, `DGAM1`, `DGMLN1`,
  `DPSI`, `DLNREL`, `DREXP`, and `DRLOG1`.
- Single precision functions: `ALNREL`, `REXP`, `RLOG1`, `GAMLN`, `GAMLN1`,
  `GAM1`, `ALGDIV`, `ERFC1`, `PSI`, and `ESUM`.
- Interpolation: `LTRP` and `PPVAL`.

The missing return types in `ERFC1`, `GAMLN`, `PSI`, `DPSI`, and `ALGDIV` were
supplemented after comparison with the original calls, function definitions,
and the full declaration report. They retain `INTEGER` for `IPMPAR`, and `REAL`
for `EXPARG`, `GAMLN1`, `SPMPAR`, and `ALNREL`. The compiler comparison preserved
all 582 non-intrinsic symbol records in this batch. No argument intents,
precision choices, dimensions, storage statements, or executable code were changed.

## Batch 3: splines, quadrature, and Fourier transforms

The third batch adds 29 procedures covered by the spline, quadrature, smoke,
and FFT worker tests:

- Splines: `CBSPL`, `SPLIFT`, `CSINT`, `CSINT1`, `CSINT2`, `CURV1`, `CURV2`,
  `CURVD`, `CURVI`, `KURV1`, `KURV2`, `KURVP1`, `KURVP2`, `QURV1`, and `QURV2`.
- Quadrature: `QSUBA`, `QUAD`, `QAGSE`, `QK21F`, `QPSRT`, `QELG`, and `WANDT`.
- Fourier transforms: `COSQF1`, `COSQB1`, `RFFTI`, `RFFTB`, `RFFTB1`, `RFFTF`,
  and `RFFTF1`.

The generator omitted several return types. Review preserved `INTEGER INTRVL`
in nine spline procedures, the `REAL` results of `CURV2`, `CURVD`, and `CURVI`,
and the `REAL TERM` statement function in `CURVI`. The quadrature callbacks
retain `REAL F`, and `QSUBA` also needs `REAL SPMPAR`. These supplements were
checked against original source and compiler records; the full declaration
report also identifies the external and statement function types.

The compiler comparison preserved all 801 non-intrinsic symbol records in this
batch. In particular, the FFT factor arrays retain their original `REAL` type.
No argument intents, precision choices, dimensions, storage statements, or
executable code were changed.

## Batch 4: ODEs, linear algebra, and random numbers

The fourth batch adds 34 procedures exercised directly or through their callers
by the existing numerical tests:

- ODEs: `RK`, `RK8`, `FEHL`, `RKFS`, `GERK`, and `GERKS`.
- Least squares and helpers: `ORTHO`, `ORSOL`, `BLSQ`, `NORMLZ`, `BTPRD1`,
  and `BVPRD1`.
- Symmetric eigenvalue routines: `SEIG`, `SEIG1`, `SEIGV`, `SEIGV1`, `TRED1`,
  `TRED2`, `TQLRAT`, `TQL2`, `IMTQL1`, and `IMTQL2`.
- Dense linear solvers and helpers: `MSLV`, `CMSLV`, `SLVMP`, `LUIMP`, `SGEFA`,
  `SGESL`, `CGEFA`, `CGESL`, `SGECO`, and `CGECO`.
- Random numbers: `URNG` and `NRNG`.

The missing-only report omitted `REAL SPMPAR` in `LUIMP`, `TQLRAT`, `IMTQL1`,
`TQL2`, `IMTQL2`, and `GERKS`. These types were confirmed against the original
calls, function definition, full declaration report, and compiler symbol records.
The ODE callbacks remain subroutines, declared with `EXTERNAL`; they do not need
a function return type.

The compiler comparison preserved all 714 non-intrinsic symbol records in this
batch. No argument intents, precision choices, dimensions, storage statements,
or executable code were changed.

## Batch 5: polynomial roots and complex vector operations

The fifth batch adds 32 procedures used by the polynomial-root, dense-solver,
and singular-value regression tests:

- Real polynomial roots: `DRPOLY`, `FXSHFR`, `QUADIT`, `REALIT`, `CALCSC`,
  `NEXTK`, `NEWEST`, `QUADSD`, and `QUADPL`. The worker `DRPLY1` was converted
  in the pilot.
- Complex polynomial roots: `DCPOLY`, `DCPLY1`, `SCALCP`, `CAUCHY`, `NOSHFT`,
  `FXSHFT`, `VRSHFT`, `CALCT`, `NEXTH`, `POLYEV`, and `ERREV`.
- Complex vector operations: `CCOPY`, `CSWAP`, `CSROT`, `CDOTC`, `CSCAL`,
  `CSSCAL`, `CAXPY`, `SCASUM`, `SCNRM2`, and `ICAMAX`.
- Determinant and inverse workers: `SGEDI` and `CGEDI`.

The missing-only report omitted `INTEGER IPMPAR` in `DCPLY1`. Its type was
confirmed against the original call, integer function definition, full declaration
report, and compiler symbol records. Procedures that already had all required
declarations only needed `IMPLICIT NONE`.

The compiler comparison preserved all 698 non-intrinsic symbol records in this
batch, including the root solvers' shared storage. No argument intents, precision
choices, dimensions, storage statements, or executable code were changed.

## Batch 6: beta functions, machine constants, and FFT radices

The sixth batch adds 32 procedures:

- Beta-function helpers: `BETALN`, `GSUMLN`, `BCORR`, `FPSER`, `APSER`, `BPSER`,
  `BUP`, `BFRAC`, `BRCOMP`, `BRCMP1`, `BGRAT`, `GRAT1`, and `BASYM`.
- Machine constants and exponent limits: `SPMPAR`, `DPMPAR`, `EXPARG`, and `DXPARG`.
- FFT radices and cosine transforms: `RADB2`, `RADB3`, `RADB4`, `RADB5`, `RADF2`,
  `RADF3`, `RADF4`, `RADF5`, `COSQI`, `COSQF`, and `COSQB`.
- Other helpers: `PAREA`, `INTRVL`, `SNHCSH`, and `DCPABS`.

The missing-only report omitted external function return types in 16 procedures.
The machine-constant routines retain `INTEGER IPMPAR`; the beta helpers retain
the `REAL` return types listed in the manifest's review notes. Each supplement
was checked against original calls, function definitions, the full declaration
report, and compiler symbol records. All 632 non-intrinsic symbol records in
this batch were preserved.

The FFT regression test now also checks lengths 3, 5, 8, and 15 against direct
Fourier sums, followed by inverse round trips. The public cosine-transform
routines are checked against direct cosine sums and round trips at the same
lengths. The existing beta-function, spline, interpolation, and polynomial-root
tests remain part of the full suite; they do not cover every helper branch.
No argument intents, precision choices, dimensions, storage statements, or
executable library code were changed.

## Batch 7: matrix utilities and remaining tested helpers

The seventh batch adds 31 procedures:

- Matrix conversions and transposes: `MCVRD`, `MCVDR`, `MCVRC`, `CMREAL`,
  `CMIMAG`, `TPOSE`, `DTPOSE`, `CTPOSE`, `TIP`, `DTIP`, `CTIP`, `INFCTR`,
  `CMADJ`, and `CTRANS`.
- Matrix and vector arithmetic: `MADD`, `MPROD`, `DMPROD`, `CMPROD`, `SVPRD`,
  `DSVPRD`, `TMPROD`, and `SMPROD`.
- Storage-location helpers: `RLOC`, `YCHG`, `DLOC`, `DYCHG`, `CLOC`, and `CYCHG`.
- Other tested workers: `SSVDC`, `CEEZ`, and `TERMS`.

The draft needed no supplemental function return types. Compiler comparisons
preserved all 435 non-intrinsic symbol records in this batch, including the
logical location functions and their storage-probing helpers.

Two more main programs were adapted from the Miller legacy tests:
`test_dense_matrix_utils` and `test_matrix_utility_continuation`. They check
real, double precision, and complex products, conversions, transposes, packed
symmetric products, and in-place rectangular transposes. Module imports were
replaced with `ISO_FORTRAN_ENV` precision definitions; product output arrays are
initialized because the original routines probe their existing storage values.
Both drivers emit numerical diagnostics for comparison across library versions.
The suite now runs 17 programs against each of the three versions, for 51 runs.
No argument intents, precision choices, dimensions, storage statements, or
executable library code were changed.

## Batch 8: basic matrix arithmetic and conversions

The eighth batch adds 22 procedures:

- Packed symmetric conversions: `MCVFS`, `DMCVFS`, `MCVSF`, and `DMCVSF`.
- Copies and conjugation: `MCOPY`, `SMCOPY`, `DMCOPY`, `CMCOPY`, and `CMCONJ`.
- Addition and subtraction: `DMADD`, `CMADD`, `SMADD`, `MSUBT`, `DMSUBT`,
  `CMSUBT`, and `SMSUBT`.
- Matrix products: `MTMS`, `DMTMS`, `CMTMS`, `KPROD`, `DKPROD`, and `CKPROD`.

No supplemental return types were needed. The compiler comparison preserved
all 242 non-intrinsic symbol records in this batch. No argument intents,
precision choices, dimensions, storage statements, or executable library code
were changed.

The new `test_matrix_arithmetic` driver extends the Miller packed symmetric
utility test to cover all 22 procedures. Its references use array arithmetic,
`MATMUL`, explicit packed data, and blocks of scaled matrices for Kronecker
products. Real, double precision, and complex results are checked with suitable
tolerances. The suite now runs 18 programs against each library version, for
54 numerical runs.

## Batch 9: packed and banded linear solvers

The ninth batch adds 22 procedures:

- Packed symmetric solvers: `DPPFA`, `DPPSL`, `DPPDI`, `DSPCO`, `DSPFA`,
  `DSPSL`, `DSPDI`, `DPCHOL`, and `DSMSLV`.
- Pivoted banded solvers: `SNBFA`, `SNBSL`, `BSLV`, `BSLV1`, `CBFA`, `CBSL`,
  `CBSLV`, and `CBSLV1`.
- Cholesky and banded workers: `LLTSLV`, `BANFAC`, `BANSLV`, `BCHFAC`, and `BCHSLV`.

The generator omitted `INTEGER ISAMAX` in `SNBFA` and `INTEGER ICAMAX` in
`CBFA`. Both types were confirmed against original calls, function definitions,
the full declaration report, and compiler records. All 448 non-intrinsic symbol
records in this batch were preserved. No argument intents, precision choices,
dimensions, storage statements, or executable library code were changed.

Three more Miller drivers were adapted: `test_packed_linpack`,
`test_pivoted_banded`, and `test_symmetric_banded`. They check known solutions,
determinants, inertia, condition estimates, pivoting, transpose solves, and
banded Cholesky factors. The original `BCHFAC` interface has a fifth `IFLAG`
argument absent from the Miller driver; the adapted test supplies and checks
it. The packed condition test accepts an estimate within a factor of two of
the exact reciprocal condition number and separately checks that an exactly
singular diagonal matrix produces zero. It does not require the estimate to
equal the exact value, as the Miller driver did. The suite now runs 21 programs
against each library version, for 63 runs.

## Batch 10: banded matrix conversions and arithmetic

The tenth batch adds 37 procedures:

- Dense/band conversions: `CVBR`, `CVRB`, `CVRB1`, `CVBD`, `CVDB`, `CVDB1`,
  `CVBC`, `CVCB`, and `CVCB1`.
- Sparse/band conversions: `DMCVBS` and `DMCVSB`.
- Precision and component conversions: `BCVRD`, `BCVDR`, `BREAL`, and `BIMAG`.
- Transposes: `BPOSE`, `DBPOSE`, and `CBPOSE`.
- Addition and subtraction: `BADD`, `DBADD`, `CBADD`, `BSUBT`, `DBSUBT`, and `CBSUBT`.
- Matrix products: `BPROD`, `DBPROD`, and `CBPROD`.
- Vector products and accumulation: `BVPRD`, `DBVPD`, `DBVPD1`, `CBVPD`,
  `CBVPD1`, `BTPRD`, `DBTPD`, `DBTPD1`, `CBTPD`, and `CBTPD1`.

The generated declarations needed no supplemental return types. Compiler
comparisons preserved all 796 non-intrinsic symbol records in this batch.
No argument intents, precision choices, dimensions, storage statements, or
executable library code were changed.

The adapted `test_banded_double` and `test_banded_arithmetic` drivers compare
real, double precision, and complex operations with dense reference results.
The double precision driver now checks arithmetic, transpose, and matrix-product
values as well as status codes. Its original-library interfaces supply the
extra column-count argument to `BCVRD` and `BCVDR`, and the bandwidth and status
arguments to `BREAL` and `BIMAG`. The absent `BCVR` helper was replaced by direct
construction of the complex test input. The suite now runs 23 programs against
each library version, for 69 numerical runs.

## Batch 11: sparse arithmetic, transposes, and norms

The eleventh batch adds 28 procedures:

- Addition and subtraction: `SADD`, `DSADD`, `CSADD`, `SSUBT`, `DSSUBT`, and `CSSUBT`.
- Matrix products: `SPROD`, `DSPROD`, and `CSPROD`.
- Transposes: `RPOSE`, `DPOSE`, and `CPOSE`.
- Vector products and accumulation: `MVPRD`, `MVPRD1`, `MTPRD`, `MTPRD1`,
  `DVPRD`, `DVPRD1`, `DTPRD`, `DTPRD1`, `CVPRD`, `CVPRD1`, `CTPRD`, and `CTPRD1`.
- Norms: `SNRM`, `S1NRM`, `DSNRM`, and `DS1NRM`.

No supplemental function types were needed. Compiler comparisons preserved all
493 non-intrinsic symbol records in this batch. No argument intents, precision
choices, dimensions, storage statements, or executable library code were changed.

The new `test_sparse_operations` combines and extends the Miller sparse
arithmetic examples. It checks real, double precision, and complex results
against dense array arithmetic, `MATMUL`, `TRANSPOSE`, and direct norm formulas.
The fixtures include an empty row, cancellation, accumulated vector products,
and insufficient output storage. Output row pointers and column bounds are
validated before reconstructing dense reference comparisons. The suite now
runs 24 programs against each library version, for 72 numerical runs.

## Batch 12: sparse conversions and ordering

The twelfth batch adds 25 procedures:

- Dense/sparse conversions: `CVRS`, `CVDS`, `CVCS`, `CVSR`, `CVSD`, and `CVSC`.
- Band/sparse conversions: `MCVBS`, `MCVSB`, `CMCVBS`, and `CMCVSB`.
- Precision and component conversions: `SCVRD`, `SCVDR`, `CSREAL`, `CSIMAG`,
  `SCVRC`, and `SCONJ`.
- Row-permuted transposes: `RPOSE1`, `DPOSE1`, and `CPOSE1`.
- Structural ordering: `SPORD`, `BLKORD`, `MC21A`, `MC21B`, `MC13D`, and `MC13E`.

No supplemental function types were needed. Compiler comparisons preserved all
411 non-intrinsic symbol records in this batch. No argument intents, precision
choices, dimensions, storage statements, or executable library code were changed.

Three more Miller drivers were adapted: `test_sparse_conversions`,
`test_band_sparse_conversions`, and `test_sparse_structure_workers`. They check
numeric conversions, sparse pointers, structural matching, and strongly connected
blocks. The structure test also checks row-length ordering and block permutations
with a nonzero diagonal. The existing sparse arithmetic driver now compares all
three row-permuted transposes with dense reference results. The suite runs 27
programs against each library version, for 81 numerical runs.

## Batch 13: sparse linear solvers and factorization workers

The thirteenth batch adds 21 procedures:

- Direct solvers: `SPSLV`, `DSPSLV`, and `CSPSLV`.
- Pivoting workers: `NSPIV1`, `DNSPIV`, and `CNSPIV`.
- Factorization workers: `SPLU`, `DSPLU`, and `CSPLU`.
- Solvers with reusable factorizations: `RSLV`, `TSLV`, `DSLV`, `DTSLV`,
  `CSLV`, and `CTSLV`.
- Solution workers: `RSLV1`, `TSLV1`, `DSLV1`, `DTSLV1`, `CSLV1`, and `CTSLV1`.

No supplemental function types were needed. Compiler comparisons preserved all
564 non-intrinsic symbol records in this batch. No argument intents, precision
choices, dimensions, storage statements, or executable library code were changed.

Three more Miller drivers were adapted: `test_sparse_solvers`,
`test_sparse_solvers_single_complex`, and `test_sparse_direct_solvers`.
They check known real, double precision, and complex solutions, pivoting,
and transpose systems. The reusable-factorization tests also solve a second
right-hand side with `M0=1`; the direct solver test now includes `DSPSLV`.
The suite runs 30 programs against each library version, for 90 numerical runs.

## Batch 14: real eigenvalue and Hessenberg routines

The fourteenth batch adds 20 procedures:

- Public drivers: `EIG`, `EIG1`, `EIGV`, `EIGV1`, `DEIG`, and `DEIGV`.
- Balancing and back transformation: `BALANC` and `BALBAK`.
- Elementary Hessenberg routines: `ELMHES`, `ELMHS0`, `ELTRAN`, and `ELTRN0`.
- Orthogonal Hessenberg routines: `ORTHES`, `ORTRAN`, `DORTH`, and `DORTRN`.
- QR iteration: `HQR`, `HQR2`, `DHQR`, and `DHQR2`.

No supplemental function types were needed. Compiler comparisons preserved all
420 non-intrinsic symbol records in this batch. Most workers already had full
type declarations; they only needed `IMPLICIT NONE`. No argument intents,
precision choices, dimensions, storage statements, or executable library code
were changed.

Four more Miller drivers were adapted: `test_real_eigensystem`,
`test_real_eigensystem_compat`, `test_real_hessenberg_qr`, and
`test_elementary_hessenberg`. The main eigenvalue test now includes double
precision and checks balanced and unbalanced eigenvector calls. QR workers are
checked against known spectra and nonzero eigenvectors with small residuals,
in addition to status checks. Hessenberg transformations are checked by matrix
reconstruction. The suite runs 34 programs against each library version, for
102 numerical runs.

## Batch 15: complex eigenvalue and balancing routines

The fifteenth batch adds 20 procedures:

- Public complex drivers: `CEIG`, `CEIGV`, `DCEIG`, and `DCEIGV`.
- Balancing and back transformation: `BALINV`, `DBAL`, `DBALNV`, `DBABK`,
  `CBAL`, `CBABK2`, `DCBAL`, and `DCBABK`.
- Complex Hessenberg and QR routines: `CORTH`, `COMQR`, `COMQR2`, `DCORTH`,
  `DCOMQR`, and `DCMQR2`.
- Packed symmetric reductions: `TRED3` and `DTRED3`.

The missing-only report omitted the `INTEGER` return type of `IPMPAR` in
`CBAL` and `DCBAL`. These declarations were supplemented after checking the
original implicit types, function definition, full declaration report, and
compiler symbol records. All 449 non-intrinsic symbol records in this batch
were preserved. No argument intents, precision choices, dimensions, storage
statements, or executable library code were changed.

Four more Miller drivers were adapted: `test_complex_eigensystem`,
`test_complex_hessenberg`, `test_eigen_balance`, and
`test_symmetric_eispack_workers`. Checks include known spectra, nonzero complex
eigenvectors and residuals, balanced and unbalanced calls in both precisions,
balancing round trips, and symmetric packed reductions. Each driver also passes
against the archived original. The suite runs 38 programs against each library
version, for 114 numerical runs.

## Batch 16: all remaining procedures

The final batch adds `IMPLICIT NONE` and 1,840 type declaration lines to all 652
remaining procedures. These cover machine constants, sorting, elementary and
special functions, polynomial operations, dense and sparse linear algebra,
eigenvalues, least squares, optimization, transforms, interpolation, surface
fitting, quadrature, integral equations, ordinary and partial differential
equation solvers, and random numbers.
The complete procedure list and original hashes are in the `batch-16` record of
`tools/explicit-typing-pilot.json`.

The missing-only report needed 256 additional type declarations in 154
procedures, including external function return types, forwarded function
callbacks, function results, and statement functions. Original GNU compiler
types were checked for every addition. The full declaration report confirmed
228 of these types; the other 28 were checked against original function headers
or forwarded callback contracts and receiving worker calls. Per-procedure
evidence is recorded in the manifest's `review_notes`.

All 17,764 non-intrinsic symbol records in the batch were compared. The only
attribute refinements are eleven forwarded external procedures that GNU can
label `SUBROUTINE` after implicit typing is disabled:

- `FUN` in `ABCON`, `SRCH`, `ABCON1`, and `ACOND`, ultimately invoked by
  `CALL FUN` in the inverse Laplace transform workers.
- `PHI` in `QAGI1`, `QAGIE1`, and `QK15I1`, which forwards the same subroutine
  to those workers through the integrand callback.
- `ZZZJAC` in `SFODE` and `SFODE1`, whose original definition is a subroutine.
- `JAC` in `STFODE` and `LSOD1`, ultimately invoked by `CALL JAC` in `PJAC`.

These names retain `EXTERNAL` and no return type. The validator accepts only
this additional attribute for the named, reviewed symbols; changes to their
types, other attributes, shapes, or argument lists still fail. The manifest's
`subroutine_classification_reviews` records the original calling evidence.
No argument intents, precision choices, dimensions, storage statements, or
executable library code were changed.

Four more Miller drivers were adapted for inverse Laplace transforms, stiff
ODEs, surface interpolation, and cubature. They exercise forwarded function and
subroutine callbacks, unqualified function results, and statement functions.
The suite now runs 42 programs against each library version, for 126 numerical
runs. These remain representative checks rather than full numerical coverage.

## Declaration generator

The trial used [`ftnchek` 3.3.1](https://www.dsm.fordham.edu/~ftnchek/), built from
the upstream source distribution in an ignored local reports directory. The
declaration options were:

```text
-makedcls=undeclared-only,suppress-array-dimensions,compact,use-continuation-lines
```

The options request missing types without repeating existing array dimensions.
The Python bridge does not infer types itself. It extracts selected procedures,
calls the generator, reads its declaration sections, and produces a draft
manifest. For example, with an installed executable:

```sh
python tools/explicit_typing.py analyze input.f --ftnchek PATH_TO_FTNCHEK --procedures MYROUTINE --output draft.json
```

The generated declarations must be checked against the original typing and
compiler diagnostics before applying them. In particular, the trial showed two
omissions in the pilot that prevent using the output as an automatic whole-library rewrite:

- The missing-only report omitted the return types of seven functions already
  named in `BRATIO`'s `EXTERNAL` statements. Their `REAL` types were confirmed
  against the original source and the generator's full declaration report.
- The `REAL` function callback `F` in `QAGS` also needed a declaration. Without
  it, the new statement caused a compiler warning that the forwarded callback
  was not a function. `EXTERNAL` alone does not preserve that return type.

The reviewed declarations, original procedure hashes, generator options, batch
records, and supplement notes are stored in `tools/explicit-typing-pilot.json`.
Despite its historical filename, this is the cumulative manifest for all reviewed
batches. Return types can be omitted even when a function has no explicit
`EXTERNAL` statement; batch 2 checks these calls as well. The generator
and its source archive are not dependencies of ordinary builds or CI.

## Applying reviewed declarations

```sh
python tools/explicit_typing.py apply input.f --manifest reviewed.json
python tools/explicit_typing.py apply input.f --manifest reviewed.json --output explicit.f
```

The default previews whether changes are needed. Output paths must be new.
`--in-place` creates a non-overwriting `.implicit.bak` backup. The bridge inserts
the reviewed types immediately after the procedure header and its new statement;
it preserves the existing declarations, dimensions, storage statements, and
executable code. Procedure hashes prevent using a manifest after the procedure
has changed. A second application makes no changes. Existing implicit typing
rules are rejected for separate review rather than silently replaced.

After editing the maintained source, regenerate its other representations with
`python tools/regenerate_sources.py`.

## Validation

Run the compiler comparison with:

```sh
python tools/validate_explicit_typing.py
```

Use `--compiler PATH` if necessary. This reconstructs the source before explicit typing
from the archived original and earlier readability transformations, applies the
reviewed manifest, and verifies that it reproduces `nswc.f`. GNU Fortran's symbol
dumps are then compared before and after the additions. The local check preserved
25,873 variable and external procedure records across all 1,062 procedures, including
types, array shapes, storage attributes, and argument lists. Internal intrinsic
placeholders and compiler-generated symbols are excluded from this comparison;
the implicit type marker is expected to disappear. The eleven reviewed
subroutine classification refinements described above are checked separately;
all other attributes must match.

The maintained source compiles with the original 28 warnings in the local compiler check.
All 42 numerical test programs must still pass against each source version,
using `python tools/validate_sources.py`. Both checks run in GitHub Actions.
The numerical tests remain representative, so future source changes need
compiler comparison and appropriate numerical checks rather than relying on
test coverage alone.
