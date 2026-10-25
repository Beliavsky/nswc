# Explicit typing pilot

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
omissions that prevent using the output as an automatic whole-library rewrite:

- The missing-only report omitted the return types of seven functions already
  named in `BRATIO`'s `EXTERNAL` statements. Their `REAL` types were confirmed
  against the original source and the generator's full declaration report.
- The `REAL` function callback `F` in `QAGS` also needed a declaration. Without
  it, the new statement caused a compiler warning that the forwarded callback
  was not a function. `EXTERNAL` alone does not preserve that return type.

The reviewed declarations, original procedure hashes, generator options, and
supplement notes are stored in `tools/explicit-typing-pilot.json`. The generator
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

Use `--compiler PATH` if necessary. This reconstructs the source before the pilot
from the archived original and earlier readability transformations, applies the
reviewed manifest, and verifies that it reproduces `nswc.f`. GNU Fortran's symbol
dumps are then compared before and after the additions. The local check preserved
424 variable and external procedure records across the 17 procedures, including
types, array shapes, storage attributes, and argument lists. Internal intrinsic
placeholders and compiler-generated symbols are excluded from this comparison;
the implicit type marker is expected to disappear.

The pilot compiles with the original 28 warnings in the local compiler check.
All 15 numerical test programs must still pass against each source version,
using `python tools/validate_sources.py`. Both checks run in GitHub Actions.
The numerical tests remain representative, so subsequent batches need the same
declaration review and compiler comparison rather than relying on tests alone.
