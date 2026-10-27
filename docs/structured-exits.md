# Structured loop exits

The maintained sources replace 191 eligible `GO TO` statements with `EXIT`.
Of these, 29 exit an outer loop and use a construct name. For example, the
increment-selection loop in `RRSORT` now reads:

```fortran
      IMAX = 1
      DO I = 3,10
         IF (N .LE. K(I)) EXIT
         IMAX = IMAX + 1
      END DO
      I = IMAX
```

`EXIT` leaves the loop, preserving its current index. `CYCLE` would start the
next iteration and would change this algorithm.

## Tool

```sh
python tools/goto_to_exit.py input.f
python tools/goto_to_exit.py input.f --output exits.f --report exits.json --compiler gfortran
```

The default reports proposed conversions without writing files. Output and report
paths must name distinct new files. The tool handles fixed-form external
procedures containing structured `DO` loops. It converts a direct branch only
when its target is the first logical statement after an enclosing `END DO`.
It can convert an unconditional branch or a logical `IF` branch. The condition
and its evaluation count are preserved.

An exit from an outer loop uses its existing name or a new, collision-free
`NSWC_EXIT_1`, `NSWC_EXIT_2`, etc. name. A target label is removed only after
checking all remaining references in the procedure. A resulting unused
`CONTINUE` is removed, retaining any attached comment. Labels needed by other
branches remain.

The tool leaves uncertain cases unchanged and records them in the report:
continued branches, sequence fields, indirect control flow, labelled or
concurrent loops, unsupported enclosing constructs, parallel directives,
Hollerith data, and branches entering a loop body. It never converts a branch
that skips executable statements between the loop and its target.

## Verification and regeneration

```sh
python -m unittest discover -s tests -p test_goto_to_exit.py -v
python tools/validate_goto_exits.py
python tools/regenerate_sources.py --check
```

The validator reconstructs the source immediately before this pass, checks the
[review report](../tools/goto-exits.json), and confirms idempotence. GNU compiler
inventories retain all existing symbol records; new loop names have only the
expected construct-label attributes. Warnings and comment text/order agree.
Optimized assembly agrees after normalizing local-label numbering and diagnostic
source line numbers. Tests also compare execution with bounds checking at
optimization levels zero and two, including nested exits, empty loops, loop-index
values, and conditions calling a function that modifies shared state.

The pass follows unused-label and empty-comment cleanup in fixed-form source
reconstruction. A subsequent parentheses-spacing pass removes unnecessary blanks
inside parentheses and between array/function names and their arguments:
`IF ( N .LE. K ( I ) ) EXIT` becomes `IF (N .LE. K(I)) EXIT`.
The EXIT emitter uses this formatting too. To preview or apply it separately:

```sh
python tools/normalize_fixed_spacing.py input.f
python tools/normalize_fixed_spacing.py input.f --output formatted.f --compiler gfortran
```

Labels, continuation columns, line counts, sequence fields, comments and quoted
text are preserved. FORMAT, Hollerith and continued character statements are
left unchanged. The compiler option checks tokens, symbols, warnings and assembly
before writing. The full validator also verifies this spacing pass.

`nswc.f90` and `nswc_mod.f90` are regenerated from the maintained
`nswc.f` through the existing reviewed modernization passes. The archived
`nswc_orig.f` is unchanged.

`refresh_label_review_hashes.py --conversion exits` refreshes downstream review
hashes after verifying that the source change is exactly this transformation.
It rejects changes to constant values, intents, purity classifications, intrinsic
bindings, helper expressions, or shared-storage layouts.

## Terminal three-way branches

`tools/structure_terminal_branches.py` converts a conservative subset of
three-way sign dispatches into `IF` / `ELSE IF` / `ELSE` blocks. It has been
applied to `CBRT`, `DCBRT`, and `CFLECT` in the maintained fixed source, with
the changes propagated through the free-form and module generators.

```sh
python tools/structure_terminal_branches.py input.f
python tools/structure_terminal_branches.py input.f --output structured.f --report structured.json
python -m unittest discover -s tests -p test_structure_terminal_branches.py
python tools/validate_terminal_branches.py
```

The tool requires three distinct destinations, contiguous assignment-only arms
at procedure end, and a return after each arm except the last. It rejects incoming
branches, nested control flow, additional entry points, internal labels,
continued statements, directives, and layouts that require moving comments.
The report lists conversions and reasons for skipped dispatches. Preview is
the default; output paths must name new files.

The negative comparison remains first, followed by the zero comparison. The
existing temporary and its assignment are retained so that expression evaluation
and type conversion occur once, including when the expression calls a function.
Removing redundant temporaries is a separate transformation.

This pass follows parentheses-spacing normalization. The validator reconstructs
its input from the archive and earlier reviewed passes, checks the complete
output and report, verifies idempotence and unchanged compiler symbol records,
and compares the three routines before and after at `-O0` and `-O2`. Inputs
include positive and negative values over a range of exponents, signed zeros,
infinities, quiet NaNs, and complex values in all quadrants. Cube-root outputs
are compared bitwise at `-O0` (apart from NaN payloads) and numerically at `-O2`.
GNU optimization can choose a different sign for a zero result between these
equivalent source forms; optimized assembly is not required to be identical.

## Redundant generated copies

`tools/remove_redundant_copies.py` removes a generated `NSWC_AI_*` scalar
when it is assigned once from an explicitly declared scalar `INTENT(IN)`
argument of the same type. Its only reads must be two sign comparisons.
The tool accepts adjacent tests or a restricted structured branch with only
assignments and known intrinsic calls that do not modify arguments between the tests.
It rejects labelled or continued test regions, storage association, alternate
entries, annotated declarations, expression copies, and reused temporaries.
Comments and strings remain unchanged. This is deliberately a narrow pass,
not a general copy-propagation optimizer.

Preview into new files:

```text
python tools/remove_redundant_copies.py nswc.f --output candidate.f --report copies.json
```

The checked-in review, `tools/redundant-copies.json`, records four removals
in CBRT, DCBRT, MEVAL, and DMEVAL, plus reasons for retaining other generated
temporaries. `tools/validate_redundant_copies.py` reconstructs the input from
the archive, reproduces the transformation, checks idempotence, and requires
identical GNU optimized assembly and all compiler symbols except the removed
locals. The pass follows fixed-form generic-intrinsic replacement.

For a newly reviewed change, migrate downstream review hashes with
`tools/refresh_label_review_hashes.py before.f candidate.f --conversion copies --apply`,
install the verified fixed source, and run `tools/regenerate_sources.py`.
Refresh module intrinsic bindings and Intel interface metadata using their
existing generation tools, then run the numerical validation suites.
