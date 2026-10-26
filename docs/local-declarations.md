# Combining local declarations

The final free-form pass combines matching local type declarations within
contiguous declaration blocks. For example:

```fortran
integer :: ibeta, m
real :: b, binv, bm1, one, w, z
integer :: emin, emax
```

becomes:

```fortran
integer :: ibeta, m, emin, emax
real :: b, binv, bm1, one, w, z
```

The external version removes 546 separate declaration statements by merging
locals across 299 procedures. The module
also applies the pass after removing redundant library procedure declarations,
which creates additional opportunities to combine locals. The fixed-form files
are unchanged.

The existing `xcombine_decl.py` tool and `coalesce_simple_declarations()` function
handle adjacent single-entity declarations. The repository tool
`tools/coalesce_local_declarations.py` extends that approach to multiple entities
and intervening type declarations while retaining the first occurrence order
within each resulting list. Matching declarations must have identical types,
attributes, and indentation. Lines wrap at entity boundaries within 132 columns.

Argument declarations, function results, procedure declarations, COMMON and
EQUIVALENCE objects remain separate. Blank lines, comments, other specification
statements, initialized declarations, and declarations with local type/bound
dependencies form barriers. Nested interfaces and executable statements are
preserved. Character declarations and unsupported type declarations are retained.

The pass runs automatically during source regeneration. To use it separately:

```sh
python tools/coalesce_local_declarations.py input.f90 --output combined.f90 --compiler gfortran
```

The optional compiler check compares complete GNU symbol records, executable
trees, and warning messages. When object files differ, it additionally compares
assembly, normalizing only source line numbers embedded in runtime diagnostic
strings. Removing declaration lines changes those diagnostic locations.

The complete external and module implementations are checked with:

```sh
python tools/validate_local_declarations.py
```

This check runs in GitHub Actions. Regression tests cover argument and result
boundaries, arrays, attributes, initialization, type/bound dependencies, procedure
and storage declarations, nested interfaces, comments, line wrapping, and line
endings. Numerical tests provide additional GNU and Intel verification.
