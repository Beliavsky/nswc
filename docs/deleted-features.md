# Removing deleted Fortran features

The maintained sources are being modernized in reviewed passes. The original
`nswc_orig.f` stays unchanged. Fixed source form itself is permitted by modern
Fortran; the rejected control-flow constructs are the issue.

## Second DO modernization pass

`tools/modernize_deleted_do.py` converts 1,425 of the 1,699 labelled loops left
after the original conservative pass. It supports executable terminal statements
and nested loops sharing a terminal label. Existing terminal operations and
statement labels remain in place; separate `END DO` statements follow the
terminal operation, closing inner loops first. Loops with a possible branch into
the body from outside, indirect control flow, or uncertain boundaries are retained.
Numeric mentions deliberately overestimate branch references.

The [review report](deleted-do-review.csv) records all 1,699 candidates and the
reason for retaining each of the remaining 274. Line numbers refer to the input
of this pass, after declaration ordering, terminal RETURN cleanup and the
periodic-root workspace correction.

The fixed-form reconstruction applies this pass last. The normal reviewed
pipeline then generates both free-form variants and the source partitions.
Constant values, argument declarations, intents, purity selections and intrinsic
selection records are unchanged. Their procedure hashes were refreshed only
after verifying that the edit is exactly the recorded DO transformation.

GNU compiler symbol records and assembly before/after the fixed-form pass agree.
The assembly comparison permits only changed source line numbers in runtime
diagnostic strings. Regression tests also compare execution for empty and
nonempty nested loops, shared terminal assignments and internal branches to the
terminal statement.

```sh
python tools/validate_deleted_do.py
python tools/validate_explicit_typing.py
python tools/regenerate_sources.py --check
python tools/validate_sources.py
```

For another source, the tool previews by default; output and report files must
be new files. Compiler verification happens before writing:

```sh
python tools/modernize_deleted_do.py source.f --output updated.f --report review.csv --compiler gfortran
```

## Strict-standard diagnostic progress

Local GNU Fortran diagnostics from `-fsyntax-only -std=f2023` on `nswc.f`:

| Diagnostic | Before this pass | After |
|---|---:|---:|
| Deleted executable DO termination | 1,018 | 76 |
| Deleted shared DO termination | 41 | 4 |
| Obsolescent labelled DO | 1,658 | 270 |
| Deleted arithmetic IF | 303 | 303 |
| Deleted ASSIGN | 48 | 48 |
| Deleted assigned GO TO | 16 | 16 |

Counts are compiler messages, not necessarily distinct statements. Rejected
arithmetic IF statements can also cause secondary undefined-label and callback
diagnostics. Successful legacy compilation and numerical comparisons do not
yet imply strict Fortran 2023 conformance.

## Arithmetic IF conversion

`tools/modernize_arithmetic_if.py` replaces all 303 arithmetic IF statements.
The strict-standard arithmetic IF diagnostic count is now zero; deleted DO and
assigned-label features remain for subsequent passes.
The 126 cases with two distinct destinations become one logical IF followed by
an unconditional GO TO. The 177 three-way cases first assign the expression to
a local temporary, then test its sign and zero value. Each expression is
evaluated once. Every original destination label and labelled entry point is
preserved, including labels attached to the arithmetic IF itself.

GNU type inference confirms the expression types before conversion: 83 integer,
82 default real, and 12 double precision expressions require temporaries.
There are 93 new local variables in 87 procedures, shared between expressions
of the same type within each procedure. They have no initialization or SAVE
attribute and do not change procedure signatures. Generated free-form sources
coalesce their declarations with other locals where appropriate.

The review uses ASSOCIATE in a temporary compiler probe to infer expression
types; maintained sources use ordinary Fortran 90 declarations and statements.
Normal regeneration needs only the recorded manifest and Python's standard
library. The [review manifest](../tools/arithmetic-if.json) records expressions,
destinations, inferred types, temporary declarations and input/output hashes.
Its physical source-record indices are zero-based and refer to the input of
this pass, after the second DO conversion.

The converter verifies unchanged existing compiler symbol records and comment
order. Regression probes compare all destination patterns, both signs of zero,
tiny and large values, infinities, and function calls with observable effects.
They verify single evaluation at both unoptimized and optimized settings.
No portable NaN branch behavior is claimed for the old arithmetic IF construct.
The [Fortran standards committee's deletion rationale](https://wg5-fortran.org/N2101-N2150/N2127.pdf)
describes why it was removed.

```sh
python tools/validate_arithmetic_if.py
python tools/validate_sources.py
python tools/validate_module.py
```

For another fixed-form source, review its expression types and verify the
result before creating new output and manifest files:

```sh
python tools/modernize_arithmetic_if.py source.f --review --manifest review.json --output updated.f
```

The fixed-form reconstruction applies arithmetic IF conversion after the
second DO pass. Existing DATA values, purity selections, call graphs, intents
and intrinsic selections are unchanged; only their source review hashes are
refreshed. Source partitions, source links, module bindings and Intel-generated
interfaces are regenerated together.

## Final assigned-label and DO pass

`tools/modernize_remaining_features.py` replaces all remaining deleted features:
48 ASSIGN statements, 16 assigned GO TO statements, and 274 labelled loops.
The assigned transfers occur in `BSSLY`, `BSSLK`, `SNRM2`, `DNRM2`, `SCNRM2`,
`WNLSM` and `WNLIT`. The 15 local integer selectors are used only in declarations,
ASSIGN and assigned GO TO. A selector assignment now stores the numeric label;
SELECT CASE branches to exactly the original dispatch list. The converter rejects
selectors used for arithmetic, argument passing, storage aliases or I/O formats.
The mapping preserves every valid old assigned-label state.

The final loop pass examines actual direct/computed GO TO targets, I/O error/end
branches and alternate-return labels. It no longer counts ordinary constants as
possible transfers. It also distinguishes DO statements from assignments to
variables such as `DONE` and `DOLD`. These refinements leave the historical passes
unchanged and allow all 274 remaining loops to be converted. Every original
terminal operation and statement label is retained.

The [final review report](../tools/remaining-features.json) records each transfer
replacement and loop conversion. Compiler records agree except for removal of
GNU's ASSIGN marker on the reviewed local selectors. Loop-generated assembly
agrees before/after conversion, allowing only source line numbers in runtime
diagnostic strings to differ. Existing numerical tests compare all maintained
versions with the archive and exercise the external and module interfaces.

```sh
python tools/validate_remaining_features.py
gfortran -c -std=f2023 nswc.f
gfortran -c -std=f2023 nswc.f90
gfortran -c -std=f2023 nswc_mod.f90
```

All three maintained sources compile without deleted-feature errors. The
free-form versions also replace GNU-only intrinsic `derf`/`derfc` calls with
explicitly bound standard generics, preserving double precision and leaving
the public library procedures unchanged. See the [intrinsic guide](generic-intrinsics.md).
The validator also uses `-pedantic-errors` and rejects reintroduced deleted-feature
diagnostics. It uses Fortran 2023 when supported and Fortran 2018 on older GNU
compilers. The archive deliberately retains its original code and legacy build
options.

The remaining standards warnings concern permitted obsolescent features.
A subsequent [free-form pass](obsolescent-features.md) removes all statement
functions and computed GO TO statements from `nswc.f90` and `nswc_mod.f90`.
The fixed-form reference retains them. COMMON and EQUIVALENCE still require
individual review of shared storage and state.
