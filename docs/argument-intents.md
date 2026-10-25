# Argument intents

The first reviewed pass adds `INTENT(IN)` to 4,177 data arguments in 976 of the
1,062 library procedures. The maintained `nswc.f`, generated `nswc.f90`, and
source partitions contain the same annotations. The archived `nswc_orig.f`
is unchanged. Other arguments retain their existing declarations.

This pass adds no `INTENT(OUT)` or `INTENT(INOUT)`. Output annotations require
separate review of incoming values, partial array writes, early returns, and
storage associations. Passing the representative numerical tests alone cannot
establish that an output annotation is safe.

## Analysis and review

The analysis uses the existing Fortran-Tools `xintent.py`, through the repository
adapter `tools/argument_intents.py`. The local tool was repaired to ignore
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

The adapter emits separate fixed-form `INTENT(IN)` statements. It preserves
type declarations, dimensions, executable statements, and argument lists.
It does not use the external tool's declaration reordering or source rewriter.

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

The draft is a review artifact. It does not change the library. After applying
reviewed changes to `nswc.f`, run `python tools/regenerate_sources.py`.

## Validation

`python tools/validate_explicit_typing.py` reconstructs the original readability
and declaration changes, applies the intent manifest, and compares the result
with `nswc.f`. GNU Fortran's compiler dump must confirm every reviewed input
attribute. Only those attributes are removed for the existing comparison of
25,873 symbol records; types, shapes, storage attributes, and argument lists
must still match, subject to the existing reviewed forwarded procedure cases.

The local compilation retains the original 28 warnings. All 42 numerical main
programs are run against each source version, giving 126 numerical runs with
matching diagnostics. Regression tests cover dependency propagation, unresolved
calls and cycles, array elements passed to procedures, keyword arguments, stale
manifests, and compiler attribute confirmation. These checks also run in GitHub
Actions.
