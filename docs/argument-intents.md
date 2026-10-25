# Argument intents

The maintained sources have 4,176 `INTENT(IN)`, 262 `INTENT(OUT)`, and 2,821
`INTENT(INOUT)` data arguments across 1,007 of the 1,062 library procedures.
Of 8,101 data arguments, 842 remain without intents pending further review.
Procedure callbacks are excluded from these data-argument counts.
The maintained `nswc.f`, generated `nswc.f90`, and source partitions contain the
same annotations. The archived `nswc_orig.f` is unchanged.

The [warning review](compiler-warnings.md) identified `ITERT`'s unused `RHFCN`
as a procedure callback. Its earlier data-argument `IN` annotation was removed,
reducing both the input count and the data-argument count by one.

Output annotations require checks of incoming values, partial array writes,
early returns, and storage associations. Passing the representative numerical
tests alone cannot establish that an output annotation is safe.

## Analysis and review

The initial input pass uses the existing Fortran-Tools `xintent.py`, through
the repository adapter `tools/argument_intents.py`. The local tool was repaired to ignore
procedure headers while analyzing executable statements. Previously,
`SUBROUTINE S(X)` was treated as a call to `S`, which prevented even a simple
read-only argument from being identified under `--interproc`.
The portable repair is recorded in `tools/fortran-tools-intent-header.patch`.
The external tool is needed only to generate suggestions, not to build, test,
or apply the reviewed annotations.

The adapter converts the fixed-form source to a temporary free-form file for
analysis and checks that both scanners identify the same procedures. It obtains
candidate inputs from the tool, then proves call dependencies separately:

- Direct writes exclude an argument from input candidates. A compiler check
  additionally rejects writes incompatible with the added annotations.
- Every candidate referenced in a call actual is checked, including nested
  expressions and array elements. A known callee's corresponding argument must
  itself be proved input. This applies to function calls as well as subroutine
  calls, including calls without explicit interfaces.
- The compiler symbol inventory distinguishes array references, intrinsic
  functions, and external procedures.
- Proof propagates from arguments with no unresolved dependencies. Unresolved
  calls and recursive dependency cycles remain unannotated.
- Procedures containing `COMMON`, `EQUIVALENCE`, alternate entries, pointer
  declarations, or unsupported input/output statements are excluded from this
  pass. Additional checks cover assigned labels and output status variables.

The draft contained 5,098 candidates; 4,177 passed the proof. Fifty-five
procedures were excluded for storage, entry, or input/output constructs. The
reviewed manifest, `tools/argument-intents.json`, records the source and procedure
hashes, argument names, dependencies for 974 annotated arguments, and normalized
hashes of the external analyzer files. Whole-source hashes protect dependencies
between procedures when applying a manifest.

The adapter emits separate fixed-form intent statements. It preserves
type declarations, dimensions, executable statements, and argument lists.
It does not use the external tool's declaration reordering or source rewriter.

## Writable arguments

The next pass adds 262 scalar `OUT` arguments and 2,821 `INOUT` arguments using
`tools/writable_intents.py`. This analyzer uses GNU Fortran's symbol inventory
and the repository's fixed-form scanner; it needs no external Python package or
Fortran-Tools installation.

- Direct assignments, loop variables, assigned labels, and output status
  variables identify writes. Writes propagate through known library calls,
  including function calls inside conditions. This independent analysis also
  checks that no existing `IN` argument is found writable.
- Arrays remain `INOUT`. Partial writes, operations with a stride, and zero-length
  or error returns can leave incoming elements untouched. The analyzer does not
  claim to prove complete array initialization.
- `OUT` is limited to intrinsic scalars assigned in the initial straight-line
  executable prefix, before any possible branch or earlier read. Arguments used
  in array bounds or character lengths cannot become `OUT`.
- Every known internal call is checked for definable actual arguments. Constants,
  expressions, array sections, and possible vector subscripts prevent a new
  writable annotation. Observed shared actual storage prevents `OUT`, preserving
  `INOUT` instead.
- The same 55 procedures with storage association, alternate entries, pointers,
  or unsupported input/output constructs remain excluded. Unknown and callback
  effects are not inferred; arguments without established write evidence remain
  unannotated.

The cumulative manifest records each new argument's direct writes or call
dependency, and the initial assignment supporting each `OUT` annotation. Source
line numbers in this evidence refer to the declaration-only baseline. These
rules are deliberately conservative and do not constitute a general Fortran
control-flow or alias analysis. Further refinements require additional review.

## Reproduction

Preview or write a reviewed transformation:

```sh
python tools/argument_intents.py apply typed-baseline.f --manifest reviewed-intents.json
python tools/argument_intents.py apply typed-baseline.f --manifest reviewed-intents.json --output annotated.f
```

Output files must be new. Applying the same manifest twice makes no further
changes. To recover the declaration-only baseline from the current source:

```sh
python tools/argument_intents.py baseline nswc.f --output typed-baseline.f
```

Generate a fresh draft with a compatible Fortran-Tools installation:

```sh
python tools/argument_intents.py analyze typed-baseline.f --tool-dir PATH_TO_FORTRAN_TOOLS --output draft-intents.json
```

Extend an existing reviewed manifest with writable suggestions:

```sh
python tools/writable_intents.py nswc.f --manifest reviewed-intents.json --output draft-writable-intents.json
```

The writable analyzer first removes the existing annotations using that
manifest. To reproduce the original writable batch, use the input-only manifest
from commit `837e804` with its matching source. The current cumulative manifest
already contains that batch, so analyzing it again adds no further annotations.

The draft is a review artifact. It does not change the library. After applying
reviewed changes to `nswc.f`, run `python tools/regenerate_sources.py`.

## Validation

`python tools/validate_explicit_typing.py` reconstructs the original readability
and declaration changes, applies the intent manifest, and compares the result
with `nswc.f`. GNU Fortran's compiler dump must confirm every reviewed `IN`,
`OUT`, and `INOUT` attribute. Only those attributes are removed for the comparison
of 25,873 symbol records; types, shapes, storage attributes, and argument lists
must still match, subject to the reviewed forwarded procedure cases and the
separately confirmed warning corrections.

The local compilation now has 12 reviewed warnings, compared with the original
28. All 44 numerical main programs run against each source version, giving 132 runs with
matching diagnostics. Regression tests cover dependency propagation, unresolved
calls and cycles, array elements passed to procedures, keyword arguments, stale
manifests, compiler attribute confirmation, scalar initialization, specification
dependencies, and writable call restrictions. The BLAS checks verify that
copies with a stride and zero-length calls preserve untouched elements. Another
88 local runs test the original and recommended sources with `-O2` optimization.
The standard checks also run in GitHub Actions.
