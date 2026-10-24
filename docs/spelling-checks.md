# Checking the documentation for spelling and OCR errors

The Markdown transcription still contains OCR errors. Automated checks narrow
the review to suspect words; they do not verify equations or recover missing text.
Compare uncertain passages with the linked page scans.

The [file-by-file review record](proofreading-review.csv) lists the manual prose
pass completed on 2026-10-24, its direct edit counts, and the remaining tool flags.
Chapter corrections are also mirrored in the complete manual. Selected damaged
passages were checked against scans 183 and 438. The remaining flags include
unresolved OCR, notation, identifiers, and names; this is not a full verification
of the mathematics or code examples.

## Setup and use

Install Node.js 22.18 or newer and Python 3.11 or newer, then run from the repository
root (a Python virtual environment is recommended):

```sh
npm ci
python -m pip install -r requirements-spelling.txt
npm run spellcheck
```

To generate reports without failing on new findings:

```sh
npm run spellcheck:report
```

The check writes two local, Git-ignored CSV files:

- `reports/spelling.csv`: each finding, its original file and line, the suspect
  word, a Codespell suggestion when available, and the surrounding source line.
- `reports/spelling-grouped.csv`: findings grouped by checker and word, with
  counts and all locations. Review repeated errors together. The complete manual
  and chapter versions intentionally produce separate occurrences.

## What is checked

`tools/check_spelling.py` checks tracked and untracked, non-ignored Markdown
files. It creates temporary copies and masks fenced code, inline code, marked
math, HTML tags, link destinations, and Markdown tables. It preserves line and
column positions. Table contents are excluded because the existing tables
primarily describe Fortran interfaces and routine indexes.

CSpell flags unknown words. Codespell's `clear` dictionary proposes known typo
corrections. Both recognize procedure names and dummy arguments extracted from declarations in
`nswc.f`. Reviewed technical vocabulary belongs in `cspell.json`; do not add OCR
errors there merely to silence warnings. A small contextual OCR rule also flags
`It ig assumed` and `Tt is assumed` (including lowercase variants), which word
checks can miss.

Unmarked mathematical expressions, proper names, and damaged text can still
produce false positives. Code samples and formulas excluded from this check can
still contain OCR errors. No correction is applied automatically.

## Reviewing findings and maintaining the baseline

Correct clear prose errors in both the complete manual and matching chapter.
Check the original scan for ambiguous words, identifiers, or mathematical text.
Re-run the checks after editing.

`tools/spelling-baseline.json` records counts of existing unresolved findings,
including possible false positives. It is a record of remaining review work,
not a declaration that those words are correct. The check fails when a group's
count exceeds its baseline; a passing result does not mean the manual is clean.
A new occurrence can go undetected if another occurrence of that same word was
removed in the same change.

After reviewing a change to the outstanding findings, refresh the baseline:

```sh
python tools/check_spelling.py --update-baseline
```

Review that diff before committing. GitHub Actions runs the same check on pushes
and pull requests and attaches the CSV reports, even when the check fails.

Tools: [CSpell](https://cspell.org/docs/getting-started) and
[Codespell](https://github.com/codespell-project/codespell).
