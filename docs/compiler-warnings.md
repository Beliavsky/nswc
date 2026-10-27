# Compiler warning review

The maintained fixed-form and external free-form sources compile with 11 warnings
under the documented GNU Fortran legacy options, compared with 28 for
`nswc_orig.f`. Procedure names,
argument order, and external linking remain unchanged. No module is required.
The archived source is unchanged.
The standalone module replaces COMMON with private saved state and compiles
without warnings in strict modern Fortran mode; see the [storage review](shared-storage.md).

## Corrected warnings

| Warnings removed | Cause | Correction |
|---|---|---|
| 8 | Old FORMAT text in `MACH1` and `MACH2` | Replace counted text with quoted strings, preserving characters, spacing, and record controls. |
| 6 | `ITERT` declares unused `RHFCN` as data although all six internal calls pass a real function | Add `RHFCN` to `EXTERNAL` and remove its data-argument `INTENT(IN)` annotation. Retain its argument position and real return type. |
| 2 | `DQDCRT` declares three output elements for a quadratic's two roots | Change `ZR(3), ZI(3)` to `ZR(2), ZI(2)`. Its body accesses only elements 1 and 2. |

The corrected quadratic declaration permits the existing cubic reduction to
pass `ZR(2)` and `ZI(2)` from three-element arrays. An explicit-shape dummy must
fit within the actual argument's available element sequence; the original
three-element declaration overstated that requirement.
[Intel array argument rules](https://www.intel.com/content/www/us/en/docs/fortran-compiler/developer-guide-reference/2025-3/array-arguments.html)

After the callback correction and subsequent intent analysis, there are 8,101
data arguments, including 4,359 `IN`, 262 `OUT`, and 2,924 `INOUT` annotations.
The unused callback is excluded from the data count. The 556 unannotated data
arguments remain pending further review.

## Remaining warnings

- In the external/reference implementations, eleven `COMMON /KONTRL/` declarations require alignment padding before
  `BUFFER`: `ADAPT`, `ADAPT1`, `ADSET`, `ADTAKE`, `ADCOMP`, `ERRINT`, `NEWTON`,
  `POLYDD`, `ADCHK`, `ADPUT`, and `ADTRAN`. This pass preserves all shared storage
  declarations and their layout. Reordering them could affect other code using
  the same block; suppressing the warning would not establish compatibility.
The archival `nswc_orig.f` retains the real/complex workspace overlap in the
`COMPB` call to `PPADD` and requires `-fallow-argument-mismatch`. Both maintained
source forms now use separate work arrays and compile without that option.
The declaration-stage validator retains its historical 12-warning inventory;
its source reconstruction then applies the workspace correction described below.
The maintained fixed-form build has 11 remaining COMMON-alignment warnings.

No warning suppression or global alignment change was added.

## Periodic-root workspace correction

In `nswc.f`, `nswc.f90`, and `nswc_mod.f90`, `COMPB` allocates separate complex
and real work arrays before calling `PPADD`. The real array receives the input
polynomial roots. After a successful call, `TRANSFER` copies the complex roots into the existing packed
real solver workspace. When all roots are real, the compact real result replaces
the first half of that workspace, including the first root that formerly relied
on overlapping storage. An error return does not copy incomplete roots back.
The allocatable arrays are released automatically when `COMPB` returns.

External procedure signatures and the packed layout consumed by `BLKTR1` are
unchanged. `PPADD` itself is unchanged. The fixed-form correction is applied
reproducibly by `tools/periodic_root_workspace.py` after declaration ordering and
terminal RETURN cleanup. `tools/free_source_fixes.py` recognizes that corrected block during
free-form generation and preserves the existing generated implementation.
The archive is unchanged. Both maintained source forms compile without
`-fallow-argument-mismatch`, including with `gfortran -c -w nswc.f`.

`test_blktri_periodic` checks manufactured solutions for both real and complex
roots, sizes 3 through 8, both boundary conditions in the other dimension, and
two solves per initialization. It checks the root-storage branch explicitly and
runs against all three library versions. Modern-source validation disables
argument-mismatch tolerance so this error cannot silently return.

Local optimized tests also pass for the maintained fixed-form and free-form
solvers with bounds checking in `COMPB` and floating-point traps enabled.
All maintained implementations also correct empty-factor indices as described
below. Only the archive retains the original index handling.

## Empty polynomial factors

`INDXB` can return a zero factor length without defining `IDX` on
some paths. `BLKTR1` would then form the actual argument `B(IDX)` even though
the product routine never reads that zero-length factor. With an index of zero,
forming the argument fails bounds checking before the product routine starts.

In `nswc.f`, `nswc.f90` and `nswc_mod.f90`, `BLKTR1` substitutes index 1 after 26 of
its 27 `INDXB` calls when the returned factor length is zero. The zero length
is preserved, and all nonempty indices and lengths are unchanged. `INDXB`
itself is unchanged: `COMPB` also uses its computed indices as workspace anchors
when the factor length is zero. The remaining `BLKTR1` lookup also locates the
periodic root workspace; its product uses `NM+1` roots, so that anchor is preserved.
The interface, workspace layout and numerical operations are unchanged.
The fixed-form fix is reproduced by `tools/blktri_empty_factors.py` after the
historical control-flow passes. The free-source pipeline recognizes the same
guards. Only the `BLKTR1` input hash in the purity review changes; its attributes,
calls and purity selections are unchanged. The existing free-form outputs remain unchanged.

```sh
python tools/validate_blktri_bounds.py
```

This regression verifies the exact guarded calls and unchanged `INDXB` code
against the reviewed fixed-form correction. Restoring the original `BLKTR1` with local
integers initialized to zero reproduces the `B(0)` bounds failure deterministically.
It also builds production solver bodies and their dependencies with bounds
checking at `-O0` and `-O2`,
initializing local integers to zero under GNU. Manufactured-solution tests cover
both available boundary conditions in each dimension, real and complex periodic
roots, sizes 3 through 8, and repeated solves, for all three maintained implementations.
Use `--ifx PATH --intel-env ENVIRONMENT_BATCH` to repeat the checks with Intel.
The GNU checks run in GitHub Actions. `nswc_orig.f` remains unchanged.

## Reproduction and verification

`tools/reviewed-source-fixes.json` records literal replacements and procedure
hashes. `tools/reviewed_source_fixes.py` applies them after named endings and loop
modernization, before the explicit typing and argument-intent manifests.
Every fix preserves physical line counts. Applying the fixes again makes no
changes; stale procedures or unexpected replacement results are rejected.

For an existing named-ending, loop-modernized baseline:

```sh
python tools/reviewed_source_fixes.py readable-baseline.f --output corrected-baseline.f
```

The output must be a new file. The complete reconstruction and compiler checks
run with:

```sh
python tools/validate_explicit_typing.py
python -m unittest discover -s tests -v
python tools/validate_sources.py
python tools/regenerate_sources.py --check
```

The symbol comparison checks 25,873 records and separately confirms the three
reviewed corrections before comparing the remaining fields. It also checks
each remaining warning's procedure and message against the recorded inventory,
rejecting new, missing, or duplicated warnings, and warnings in unexpected
procedures.

The FORMAT regression compiles the original and revised formats separately and
compares the exact emitted bytes for all eight changed statements. Two numerical
main programs check quadratic roots and zero-constant cubic reductions, and
integral iteration in both storage paths with both iteration flags. The callback
test fails if the unused function is called. All 44 numerical mains run against
all three source versions, giving 132 runs; the original and recommended sources
also receive 88 local runs with `-O2` optimization.
