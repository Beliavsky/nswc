# Generic intrinsic calls

Both free-form versions replace 2,041 specific intrinsic calls across 443
procedures with generic names. Examples include `dabs` to `abs`, `dsqrt` to
`sqrt`, `cabs` to `abs`, and `amax1` to `max`. Argument types and kinds determine
the generic result; the conversion does not change arguments or literals.
The fixed-form versions remain unchanged.

The [mapping and binding review](../tools/generic-intrinsics.json) covers 25
specific names. GNU identifies each selected name as an intrinsic in its actual
procedure scope. A generic name must have no conflicting local data object,
dummy argument, external procedure, or library procedure. Seventeen procedure
scopes retain calls whose generic name would conflict, typically with a local
variable named `max`.

The pass excludes conversion intrinsics such as `dble`, `sngl`, `float`, and
`ifix`; replacing these by a generic without an explicit kind can change the
result precision. Specific intrinsics used as procedure arguments are also
retained. Library routines such as `DERF`, `DERFC`, and `DGAMMA` are outside this
mapping, including GNU intrinsic references that share those names.

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

Review generation compiles both versions and requires byte-for-byte identical
GNU object files. It also compares all other compiler symbol records and
executable expression trees. The comparison omits only reviewed intrinsic symbol
blocks, empty separator lines, and known GNU lowering-name differences for the
specific `max` and `min` families. Their argument trees and type/kind suffixes
remain checked. Compiler warning messages must agree.

For the maintained source, this validation reconstructs the input before the
generic pass, reproduces the binding review, and repeats those compiler checks:

```sh
python tools/validate_generic_intrinsics.py
```

This check also runs in GitHub Actions. Compiler-backed regression tests cover
all 25 mappings, complex and double-precision arguments, name collisions,
intrinsic declarations, external functions, procedure arguments, and stale hashes.
Intel compilation and the numerical regression programs provide additional
checks for the generated external and module versions.
