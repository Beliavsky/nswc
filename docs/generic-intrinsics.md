# Generic intrinsic calls

The maintained fixed-form source and both free-form versions use generic names
for 2,049 formerly specific intrinsic calls across 443 procedures. Examples include `dabs` to `abs`, `dsqrt` to
`sqrt`, `cabs` to `abs`, and `amax1` to `max`. Argument types and kinds determine
the generic result; the conversion does not change arguments or literals.
The archived `nswc_orig.f` retains its original spellings.

The [fixed-form mapping and binding review](../tools/fixed-generic-intrinsics.json) covers 27
specific names. GNU identifies each selected name as an intrinsic in its actual
procedure scope. A generic name must have no conflicting local data object,
dummy argument or external procedure. Library-name collisions are normally
retained, except for the explicitly bound error-function generics below. Seventeen procedure
scopes retain calls whose generic name would conflict, typically with a local
variable named `max`.

The pass excludes conversion intrinsics such as `dble`, `sngl`, `float`, and
`ifix`; replacing these by a generic without an explicit kind can change the
result precision. Specific intrinsics used as procedure arguments are also
retained. The public library routines `DERF`, `DERFC`, and `DGAMMA` retain their
names. Eight compiler-confirmed GNU intrinsic calls to `derf` and `derfc` in
`DGRAT`, `DERFI` and `DAERF` become standard `erf` and `erfc` calls. Explicit
INTRINSIC declarations preserve their binding despite the same-named library
procedures. Double-precision arguments select double-precision results. This
also permits strict modern-standard compilation of these pure procedures.

The tool changes only reviewed direct calls and any affected type or INTRINSIC
declarations. Comments and quoted text are preserved. Procedure code hashes and
per-name call counts guard against stale reviews. Normal regeneration uses the
checked-in review without requiring a compiler:

```sh
python tools/regenerate_sources.py
```

To review an external free-form source file before applying replacements:

```sh
python tools/generic_intrinsics.py input.f90 --review new-generic-review.json
python tools/generic_intrinsics.py input.f90 --manifest new-generic-review.json --output generic.f90
```

Review generation compiles both versions and requires identical GNU assembly,
allowing only embedded diagnostic source line numbers to differ when declarations
move. It also compares all other compiler symbol records and
executable expression trees. The comparison omits only reviewed intrinsic symbol
blocks, empty separator lines, and known GNU lowering-name differences for the
specific `max` and `min` families. Their argument trees and type/kind suffixes
remain checked. Compiler warning messages must agree.

For the maintained fixed source, this validation reconstructs the input before
the generic pass, reproduces the binding review, and repeats those compiler checks:

```sh
python tools/validate_fixed_generic_intrinsics.py
python tools/validate_generic_intrinsics.py
```

This check also runs in GitHub Actions. Compiler-backed regression tests cover
all 27 mappings, complex and double-precision arguments, name collisions,
intrinsic declarations, external functions, procedure arguments, and stale hashes.
Intel compilation and the numerical regression programs provide additional
checks for the generated external and module versions.

## Fixed-form tool

```sh
python tools/fixed_generic_intrinsics.py input.f --review fixed-review.json --output generic.f
```

The tool reuses the free-form binding analysis, but compiles and verifies the
actual fixed-form input and output. It edits tokens in columns 7--72, preserving
labels, continuation columns, sequence fields, inline comment columns, full-line
comments, and quoted strings in executable records. Removed intrinsic type
declarations leave blank records where possible, so unrelated diagnostic source
line numbers do not move. Required explicit INTRINSIC declarations use vacant
declaration records or are inserted after IMPLICIT NONE. All output and review
paths must name new files.

A split identifier, ambiguous character continuation, annotated declaration,
or mismatched call count stops the conversion. Whole-file hashes prevent reuse
of a review on different input. Applying the review to its completed output is
idempotent.

The fixed-form pass runs after terminal-branch restructuring in the historical
source reconstruction. To migrate downstream reviews after a verified fixed
conversion, first install its verified review at
`tools/fixed-generic-intrinsics.json`. While the maintained files still contain
the previous source, run:

```sh
python tools/refresh_label_review_hashes.py input.f generic.f --conversion generics --apply
```

Then replace the maintained fixed source with the reviewed output and run
`tools/regenerate_sources.py`. The migration preserves constant values, intents,
purity selections, external calls, transfer bindings, and storage layouts. It
repeats the free-form intrinsic binding analysis because those calls are now
converted earlier. The downstream free-form pass currently has no additional
replacements; its review still records conflicting names.
