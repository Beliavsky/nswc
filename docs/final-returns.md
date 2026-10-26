# Removing redundant final RETURN statements

The maintained fixed-form source and both free-form versions omit 959 plain
terminal RETURN statements. Reaching END FUNCTION or END SUBROUTINE returns to
the caller. The archived `nswc_orig.f` remains unchanged.

The shared tool, `tools/remove_final_returns.py`, removes only an unlabelled,
unconditional plain RETURN immediately before the procedure end. Blank lines
and full-line comments may intervene. Consecutive redundant final returns are
removed together, making the pass idempotent.

The tool preserves all 63 labelled terminal returns, which may be branch
targets. It also retains early, conditional and alternate returns such as
`RETURN 1`, and returns with inline comments, continuation lines or fixed-form
sequence fields. It does not scan past FORMAT or other intervening statements.
Comments and strings are preserved.

To clean a separate source file and verify the compiler records:

```sh
python tools/remove_final_returns.py input.f --output cleaned.f --compiler gfortran
python tools/remove_final_returns.py input.f90 --output cleaned.f90 --compiler gfortran
```

The source form follows the extension or can be selected with `--form fixed`
or `--form free`. `--report report.json` records the changes. The checked-in
fixed-form report is [final-return-cleanup.json](../tools/final-return-cleanup.json).

## Regeneration and review hashes

Fixed-form reconstruction applies cleanup after the existing declaration-ordering
stage. Free-form generation applies the same cleanup at the end, including the
module output. The declaration-formatting and ordering reports describe their
earlier stages; the final-return report connects that output to maintained
`nswc.f` with input and output hashes.

Removing statements changes procedure hashes used by the modernization reviews.
The narrow migration tool can refresh those hashes using a saved old fixed-form
source and its cleaned counterpart:

```sh
python tools/refresh_return_review_hashes.py before.f cleaned.f
python tools/refresh_return_review_hashes.py before.f cleaned.f --apply
```

It requires an exact cleanup-only difference at the fixed-form input and every
affected free-form stage. It also verifies that the old source reproduces the
existing free-form file. Only the DATA, purity and generic-intrinsic review
hashes change; constants, contracts, interfaces, call graphs and selection
records remain unchanged. Other source changes require their normal reviews.

## Validation

```sh
python tools/validate_final_returns.py
python tools/validate_explicit_typing.py
```

Validation reproduces the maintained fixed-form source from the archive and
existing reviews, then checks the cleanup report. GNU compiler dumps must agree
after omitting only plain terminal RETURN nodes. All other compiler symbol
records, executable statements and warning messages remain checked. Both
free-form files must have no remaining removable final returns. The checks run
in GitHub Actions; numerical tests also exercise the maintained variants with
GNU and Intel Fortran.
