# Explicit typing

The reviewed conversions cover 184 of the library's 1,062 procedures in six
batches of 17, 40, 29, 34, 32, and 32. The remaining 878 procedures
retain their existing typing. Each batch preserves the original types and is
checked with compiler symbol comparisons and the numerical regression suite.

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
3,851 variable and external procedure records across the 184 procedures, including
types, array shapes, storage attributes, and argument lists. Internal intrinsic
placeholders and compiler-generated symbols are excluded from this comparison;
the implicit type marker is expected to disappear.

The maintained source compiles with the original 28 warnings in the local compiler check.
All 15 numerical test programs must still pass against each source version,
using `python tools/validate_sources.py`. Both checks run in GitHub Actions.
The numerical tests remain representative, so subsequent batches need the same
declaration review and compiler comparison rather than relying on tests alone.
