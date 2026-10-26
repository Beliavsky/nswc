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
reconstruction. `nswc.f90` and `nswc_mod.f90` are regenerated from the maintained
`nswc.f` through the existing reviewed modernization passes. The archived
`nswc_orig.f` is unchanged.

`refresh_label_review_hashes.py --conversion exits` refreshes downstream review
hashes after verifying that the source change is exactly this transformation.
It rejects changes to constant values, intents, purity classifications, intrinsic
bindings, helper expressions, or shared-storage layouts.
