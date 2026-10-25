# Compiler warning review

The maintained sources compile with 12 warnings under the documented GNU
Fortran legacy options, compared with 28 for `nswc_orig.f`. Procedure names,
argument order, and external linking remain unchanged. No module is required.
The archived source is unchanged.

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

The callback correction also adjusts the intent inventory: there are now 8,101
data arguments, including 4,176 `IN`, 262 `OUT`, and 2,821 `INOUT` annotations.
The unused callback is excluded from the data count. The 842 unannotated data
arguments are unchanged.

## Remaining warnings

- Eleven `COMMON /KONTRL/` declarations require alignment padding before
  `BUFFER`: `ADAPT`, `ADAPT1`, `ADSET`, `ADTAKE`, `ADCOMP`, `ERRINT`, `NEWTON`,
  `POLYDD`, `ADCHK`, `ADPUT`, and `ADTRAN`. This pass preserves all shared storage
  declarations and their layout. Reordering them could affect other code using
  the same block; suppressing the warning would not establish compatibility.
- `COMPB` passes real workspace to complex `CBP` in `PPADD`. The same address is
  also passed as real `BP`; the routine uses overlapping real and complex views
  of that workspace. A numerical type conversion would not preserve that storage
  relationship. Removing it needs a separate review of workspace sizes, complex
  root storage, and every consuming routine.

Consequently, `-fallow-argument-mismatch` remains necessary. Its purpose is to
accept mismatches in legacy calls, not to prove those calls valid.
[GNU Fortran dialect options](https://gcc.gnu.org/onlinedocs/gfortran/Fortran-Dialect-Options.html)
No warning suppression or global alignment change was added.

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
