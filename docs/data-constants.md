# Read-only DATA objects as named constants

The free-form versions replace 1,828 DATA-initialized objects in 279 procedures
with typed PARAMETER declarations. They contain 6,689 initialized elements.
The fixed-form sources are unchanged. The conversion expands purity from 346
annotated procedures to 680: 175 PURE ELEMENTAL and 505 PURE procedures.

Scalars retain their literal spelling. Complete arrays use typed array
constructors, preserving their bounds and Fortran element order. A typed
constructor converts each original literal to the declared type; it does not
append kind suffixes or change decimal precision. Multidimensional arrays use
RESHAPE with the original shape and lower bounds in their declarations.

The converter removes obsolete type and named SAVE declarations for converted
objects. All executable statements and full-line comments remain unchanged.
The separate [purity pass](purity.md) then adds compiler-verified attributes and
interfaces. Both external and module implementations are generated together.
For portable pure callers, a separate lexical pass replaces two GNU-specific
DGAMMA intrinsic calls with standard generic GAMMA on double-precision arguments.
The exported library DGAMMA routine remains unchanged. GNU and Intel numerical
tests include focused checks for these two callers, DRCOMP and DGINV.

## Retained objects

The review retains 29 DATA objects across 10 procedures. These include mutable
work arrays, partially initialized arrays, storage-associated tables, and objects
passed to procedures or callbacks without confirmed INTENT(IN) contracts.
Some retained objects may be read-only in practice; the conversion requires
evidence rather than assuming that an implicit callback preserves its arguments.

The scanner rejects assignment targets, DO indices, storage aliases, COMMON
objects, I/O targets, and potentially writable actual arguments. It follows
declared argument intents for library calls and recognizes read-only mathematical
intrinsics. It requires complete array initialization and records each retention
reason in [the review](../tools/data-constants.json).
An object used in an arithmetic expression or as a subscript is distinguished
from a variable passed directly to a potentially writable argument.

## Regeneration and review

The checked-in review records source-code hashes, original literal values, and
retention reasons. Ordinary regeneration uses only Python's standard library:

```sh
python tools/regenerate_sources.py
python tools/regenerate_sources.py --check
```

After changing the maintained source, produce and inspect a new DATA review:

```sh
python tools/review_data_constants.py --output new-data-review.json
```

The review tool compiles both forms and checks every converted object's type,
bounds, and initialized value before writing the new review. Source changes
invalidate affected entries. Comment-only edits do not invalidate code hashes.
After accepting a new review, repeat purity analysis and refresh generated
sources, module intrinsic bindings, and Intel interfaces as described in their
respective guides.

## Verification

```sh
python tools/validate_data_constants.py
```

Validation reproduces the read/write review, compares initialized values, types
and bounds, checks unchanged compiler records for every unconverted object,
and compares executable statement tokens and compiler warnings. GNU's diagnostic
dump omits DATA repetition counts, so the checker expands repetition syntax
before comparing its initializer representations.

A generated independent Fortran program compares the storage bits of every
converted DATA initializer with its PARAMETER equivalent. This includes all
scalar and array elements and detects precision changes from implicit literal
conversion. The probe passes with both GNU and Intel Fortran:

```sh
python tools/validate_data_constants.py --ifx PATH_TO_IFX --intel-env PATH_TO_ENVIRONMENT_BATCH
```

Compiler-backed regression tests cover mixed DATA groups, mutable state, named
SAVE lists, repeated values, nondefault lower bounds, multidimensional ordering,
default-real literals initializing double precision, unknown callbacks, partial
initialization, and EQUIVALENCE. Numerical and pure/elemental tests run separately
against the regenerated library and module.
