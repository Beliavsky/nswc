# Explicit typing

The reviewed conversions cover 86 of the library's 1,062 procedures: the initial
17 procedure pilot and subsequent batches of 40 and 29. The remaining 976 procedures
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
1,807 variable and external procedure records across the 86 procedures, including
types, array shapes, storage attributes, and argument lists. Internal intrinsic
placeholders and compiler-generated symbols are excluded from this comparison;
the implicit type marker is expected to disappear.

The maintained source compiles with the original 28 warnings in the local compiler check.
All 15 numerical test programs must still pass against each source version,
using `python tools/validate_sources.py`. Both checks run in GitHub Actions.
The numerical tests remain representative, so subsequent batches need the same
declaration review and compiler comparison rather than relying on tests alone.
