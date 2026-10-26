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

Next passes should review the remaining legacy DO loops, convert arithmetic IF
while preserving single evaluation and numeric precision, and replace assigned
labels after checking their possible use as FORMAT identifiers. COMMON,
EQUIVALENCE, statement functions and computed GO TO are obsolescent features and
can be addressed separately after the deleted features.
