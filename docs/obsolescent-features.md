# Obsolescent-feature modernization

The recommended free-form implementations, `nswc.f90` and `nswc_mod.f90`, replace
all 21 computed GO TO statements and all 24 statement functions. The fixed-form
`nswc.f` and archive `nswc_orig.f` retain these constructs and provide independent
comparison implementations. External procedure names, argument order, kinds,
intents and purity attributes remain unchanged.

## Computed transfers

A computed transfer chooses its destination by position in a label list. The
replacement uses `SELECT CASE` with one case per position, retaining repeated
destinations and the original statement label. An out-of-range selector falls
through to the following statement. The selector expression is evaluated once.
The pass does not add a default error or change destination labels.

GNU produces identical compiler symbol records and complete executable trees
before and after this conversion. Tests also exercise negative, zero and large
selectors, repeated destinations, labelled and continued statements, and a
selector function with a side effect, at both optimization levels `-O0` and `-O2`.

## Statement functions

The [binding review](../tools/obsolescent-features.json) records each of the 24
compiler-confirmed statement functions in 21 host procedures. Each becomes a
pure internal function with explicit result types and scalar `INTENT(IN)`
arguments. Scalar precision and complex/logical types match the compiler's
original types. Array-element assignments are never mistaken for definitions.

The original expressions retain their spelling and evaluation scope. Dummy
arguments shadow matching host names, and references to other host variables
remain host associated. This matters in the interpolation helpers in `CURVI`
and `SURF2`, which read values updated by their host procedure. Helpers may also
call other converted helpers in the same host.

The helpers remain private to their host procedures. The external library and
standalone module still expose the original 1,062 procedures. The source reader
and compiler-record reader distinguish contained functions from external/module
procedures, including helpers with the same name in different hosts.

## Reproduction and validation

The pass runs last in free-form source generation, after the existing reviewed
constant, purity, intrinsic and declaration transformations. Their selections
and review hashes remain unchanged. Regeneration updates source partitions and
documentation links together:

```sh
python tools/regenerate_sources.py
python tools/regenerate_sources.py --check
python tools/validate_obsolescent.py
```

The validator reproduces the review, checks idempotence, compares external
signatures and all host data records, and verifies every helper's result kind
and argument kinds/intents. Only the reviewed procedure-category changes and
host-association markers on captured variables may differ. Both free-form
implementations must compile strictly without computed GO TO or statement-function
diagnostics. This validation also runs in GitHub Actions.

The numerical suite compares the free-form implementation with both fixed-form
implementations. Separate GNU and Intel checks compare the external and module
implementations, regenerate/check interfaces, exercise pure/elemental calls and
reject invalid calls. Focused Python regressions test helper shadowing, mutable
host captures, helper-to-helper calls, precision, and complex/logical results.

For another source file, first generate a compiler-backed review, then apply it:

```sh
python tools/modernize_obsolescent.py input.f90 --review new-review.json
python tools/modernize_obsolescent.py input.f90 --manifest new-review.json --output modern.f90
```

The converter deliberately rejects unsupported scalar kinds, arrays used as
statement-function dummies, labelled definitions and stale source hashes.
Existing internal procedures in an affected host require a separate review.
COMMON and EQUIVALENCE remain for individual storage/state analysis.
