# NSWC Library of Mathematics Subroutines

**Alfred H. Morris, Jr.** — Naval Surface Warfare Center, Dahlgren Division  
Report **NSWCDD/TR-92/425** (January 1993)  
Approved for public release; distribution unlimited.

This is a GitHub-browseable edition of the 1993 manual, checked against the
original fixed-form Fortran source (`nswc_orig.f`). The routine index covers **576**
documented procedures; the source contains **1,062** external definitions including
implementation helpers.

**Scope of verification.** Public procedure names, declared argument order,
and function/subroutine classification were checked against the source. The
scanned report's mathematics and narrative text remain partially OCR-derived;
they should **not** be treated as completely verified. Each chapter links to
scans of its original report pages, and source references point to small
viewable code partitions.

- [Complete Markdown transcription](NSWC_Library_of_Mathematics_Subroutines_complete.md)
- [Alphabetical documented routine index](docs/routine-index.md)
- [Complete source interface inventory](NSWC_Source_Interfaces.md)
- [Review and limitations](NSWC_Source_Audit.md)
- [Spelling and OCR checks](docs/spelling-checks.md)
- [Numerical test programs](docs/numerical-tests.md)
- [Explicit typing progress](docs/explicit-typing.md)
- [Compiler warning review](docs/compiler-warnings.md)
- [Unused-label cleanup](docs/unused-labels.md)
- [Structured loop exits](docs/structured-exits.md)
- [Optional procedure interfaces](docs/interfaces.md)
- [Original report cover](scans/page_0001.png)
- [Recommended module source for new programs](nswc_mod.f90)
- [Free-form source for external callers](nswc.f90)
- [Readable fixed-form alternative](nswc.f)
- [Unchanged original Fortran source](nswc_orig.f)

## Contents

- [Introduction](docs/01-introduction.md)
- [Elementary Operations](docs/02-elementary-operations.md)
- [Geometry](docs/03-geometry.md)
- [Special Functions](docs/04-special-functions.md)
- [Polynomials](docs/05-polynomials.md)
- [Solutions of Nonlinear Equations](docs/06-solutions-of-nonlinear-equations.md)
- [Vectors](docs/07-vectors.md)
- [Matrices](docs/08-matrices.md)
- [Large Dense Systems of Linear Equations](docs/09-large-dense-systems-of-linear-equations.md)
- [Banded Matrices](docs/10-banded-matrices.md)
- [Sparse Matrices](docs/11-sparse-matrices.md)
- [Eigenvalues and Eigenvectors](docs/12-eigenvalues-and-eigenvectors.md)
- [L1 Solution of Linear Equations](docs/13-l1-solution-of-linear-equations.md)
- [Least Squares Solution of Linear Equations](docs/14-least-squares-solution-of-linear-equations.md)
- [Optimization](docs/15-optimization.md)
- [Transforms](docs/16-transforms.md)
- [Approximation of Functions](docs/17-approximation-of-functions.md)
- [Curve Fitting](docs/18-curve-fitting.md)
- [Surface Fitting over Rectangular Grids](docs/19-surface-fitting-over-rectangular-grids.md)
- [Surface Fitting over Arbitrarily Positioned Data Points](docs/20-surface-fitting-over-arbitrarily-positioned-data-points.md)
- [Manifold Fitting](docs/21-manifold-fitting.md)
- [Numerical Integration](docs/22-numerical-integration.md)
- [Integral Equations](docs/23-integral-equations.md)
- [Ordinary Differential Equations / Initial Value Problems](docs/24-ordinary-differential-equations-initial-value-problems.md)
- [Partial Differential Equations](docs/25-partial-differential-equations.md)
- [Discrete Random Number Generation](docs/26-discrete-random-number-generation.md)
- [Continuous Random Number Generation](docs/27-continuous-random-number-generation.md)
- [Appendix: Installation and Precision Conversion](docs/28-appendix-installation-and-precision-conversion.md)

*The chapter files are kept below GitHub's large-file limits to make in-browser navigation and rendering easier.*

## Using the source

Run the commands below from the root of your downloaded or cloned repository.

For new programs, use `nswc_mod.f90`, which supplies module `nswc_mod` with all
1,062 library procedures and explicit interfaces. For existing programs that
call external procedures, retain `nswc.f90`. Both free-form versions provide the
same routines, data declarations, and pure/elemental attributes. `nswc.f`
provides readable fixed form; `nswc_orig.f` preserves the supplied source.
Correctness fixes apply to all three maintained versions. Only `nswc_orig.f`
is preserved unchanged as the archive.
Choose one implementation for each executable.
Documentation source links point into free-form files in `source_parts/`;
displayed line numbers refer to the complete `nswc.f90`.

The maintained versions compile in strict modern Fortran modes. For GNU Fortran:

```sh
gfortran -c -std=f2018 nswc_mod.f90
gfortran myprogram.f90 nswc_mod.o -o myprogram
```

In `myprogram.f90`, import the procedures you use:

```fortran
use nswc_mod, only: sgefa, sgesl
```

The module object links independently. It needs neither `nswc.o` nor
`nswc_interfaces.f90`. Compile it before compiling callers, with the same
compiler. See the [module guide](docs/module.md) for generation and verification.
For external callers, compile `nswc.f90` instead and link `nswc.o`.

Use `-std=f2023` with compilers supporting that option; `-std=f2018` also accepts
all maintained versions. The standalone module compiles without warnings in
strict mode. The external `nswc.f90` retains COMMON for legacy shared-storage
compatibility; both free-form versions remove EQUIVALENCE. The fixed-form
reference also retains statement functions and computed GO TO. Only the archival `nswc_orig.f`
requires `-std=legacy -fallow-argument-mismatch`. Both maintained source forms use
separate real and complex root work arrays in `COMPB`, with explicit packing
back into the solver workspace. See the [warning review](docs/compiler-warnings.md).
Machine constants retain
the original configuration; see the installation appendix before numerical use.
Named procedure endings require Fortran 90 or newer, including in `nswc.f`.

## Optional interfaces for external callers

[`nswc_interfaces.f90`](nswc_interfaces.f90) provides explicit interfaces for all
1,062 external procedures in `nswc.f90`. Its interfaces were
generated with Intel `ifx` and checked independently with GNU Fortran. Elemental
procedures require explicit interfaces, supplied by this module or equivalent
local interface blocks. To enable argument checking, compile the module
with the same compiler as the library, then import selected procedures:

```fortran
use nswc_interfaces, only: sgefa, sgesl
```

For GNU Fortran with the external implementation:

```sh
gfortran -c -std=f2018 nswc.f90
gfortran -c nswc_interfaces.f90
gfortran myprogram.f90 nswc.o -o myprogram
```

The module contains interfaces only; link the library object as usual. The
[interface guide](docs/interfaces.md) describes generation, verification, Intel
commands, and callback limitations. Run `python tools/validate_interfaces.py`
to compare all signatures and test callers using the module.

## Pure and elemental procedures

Both free-form versions declare **175 public procedures `pure elemental`** and another
**505 `pure`**, plus 24 pure internal helpers. In `nswc.f90`, the original entry
points remain external. Internal calls have
local interfaces wherever pure or elemental calls require them, so compiling
`nswc.f90` still needs no additional source file or module dependency.

Import elemental routines before calling them, including scalar calls:

```fortran
use nswc_mod, only: cbrt
! cbrt([-8.0, 0.0, 27.0]) returns approximately [-2.0, 0.0, 3.0].
```

The [purity guide](docs/purity.md) describes analysis, compiler verification,
remaining blockers, and a legacy interface view for unchanged `nswc.f`.
The [review manifest](tools/procedure-purity.json) records each contract
and code hash. `python tools/validate_procedure_purity.py` checks unchanged data
and executable compiler trees, pure callers, and elemental array calls.

## Named constants

Both free-form versions use `parameter` declarations for **1,828 read-only DATA
objects in 279 procedures**. Original literal spellings, types, array bounds,
and element order are preserved. Mutable state, storage aliases, partial
initializers, and objects passed without confirmed read-only contracts remain
unchanged. GNU and Intel checks compare the initializer storage bits.
See the [constant-conversion guide](docs/data-constants.md).

## Regenerating the source

Maintain `nswc.f` and its reviewed reconstruction stages, then generate
`nswc.f90`, `nswc_mod.f90`, the browsable partitions, and the Markdown source links
together:

```sh
python tools/regenerate_sources.py
python tools/regenerate_sources.py --check
```

The generator overwrites generated source files and updates source-link line
numbers. Do not edit `nswc.f90`, `nswc_mod.f90`, or `source_parts/` independently. It uses the
repository copy of `tools/fixed_to_free.py`, so regeneration needs only Python's
standard library. The converter handles compact DATA array declarations and wraps
long FORMAT statements without splitting their Hollerith text.

Generation also applies `tools/lowercase_fortran.py` to make free-form code
lowercase while preserving quoted strings, comments, spacing, and line numbers.
For another free-form file, use
`python tools/lowercase_fortran.py input.f90 --output lowercase.f90`.
The output must be a new file. The filter rejects preprocessor directives and
unquoted Hollerith constants, which require separate review. Existing quoted
FORMAT strings in the maintained library are preserved exactly.

`tools/format_free_form.py` then applies three-space block indentation, IF
condition spacing, spaces around assignment `=` and binary `+`/`-`, and removal
of redundant leading unary `+` in assignment expressions. It handles labelled
DO loops, including shared terminal labels, and wraps code at token boundaries
when needed to stay within 132 columns. Quoted text, comments, and FORMAT records
are preserved. This step applies only to the generated free-form sources;
`nswc.f` is unchanged. To format another file, write a new output file:

```sh
python tools/format_free_form.py input.f90 --output formatted.f90
python tools/validate_free_formatting.py
```

The validator compares complete GNU compiler dumps before and after formatting,
allowing only removal of redundant unary-plus expression wrappers. Regeneration
also checks tokens and literal values, and updates source-link line numbers.

The `tools/simplify_free_style.py` pass removes spaces before argument
lists in procedure declarations and calls to known procedures. It also removes
redundant array constructor types for matching default-kind literals, preserving
types needed for mixed values or precision conversion. Comparisons use `==`,
`/=`, `<`, `<=`, `>`, and `>=` with spaces on both sides; logical operators,
comments, and quoted text retain their spelling. To apply it separately
and verify unchanged GNU compiler dumps and diagnostics:

```sh
python tools/simplify_free_style.py input.f90 --output simplified.f90 --compiler gfortran
```

The subsequent `tools/generic_intrinsics.py` pass replaces 2,049 confirmed
specific intrinsic calls with generic names, such as `dabs` to `abs` and
`dsqrt` to `sqrt`. Conflicting names and conversion intrinsics are retained.
The [generic-intrinsic guide](docs/generic-intrinsics.md) describes the binding
review and checks for identical compiled code.

The final [obsolescent-feature pass](docs/obsolescent-features.md) replaces 21
computed GO TO statements with SELECT CASE and 24 statement functions with pure
internal functions. It preserves out-of-range fall-through, helper argument/result
types and captured host variables. Both fixed-form implementations remain
comparison targets; existing external interfaces remain unchanged.

The [shared-storage pass](docs/shared-storage.md) removes seven EQUIVALENCE
statements and replaces all 14 COMMON blocks in the standalone module with
private saved variables. Packed ODE save/restore layouts and forced rounding
storage are preserved. External callers that access COMMON can use `nswc.f90`.

The final `tools/coalesce_local_declarations.py` pass combines matching local
declarations within contiguous blocks. Argument declarations, comments,
initializers, and type/bound dependencies retain their boundaries. See the
[local-declaration guide](docs/local-declarations.md) for usage and validation.

The maintained fixed-form source and both free-form versions also omit redundant
unlabelled final `return` statements. Labelled, conditional, early, and alternate
returns remain. The shared cleanup runs after fixed-form declaration ordering
and at the end of free-form generation; `nswc_orig.f` remains unchanged.
See the [final-return guide](docs/final-returns.md) for the review and checks.

Comment capitalization uses `tools/sentence_case_comments.py` for selected
uppercase explanatory comments. Sentences continue across physical line breaks.
The prose vocabulary and proper-name rules are maintained in
`tools/comment-case-words.txt` and `tools/comment-case-rules.json`.
Only letter case changes; spelling, spacing, and line numbers are preserved.
Existing misspellings are retained. Commented Fortran and identifiable procedure
and variable references use lowercase, using declarations in the enclosing
procedure to recognize names. English words that also name variables require
explicit context, such as `argument N` or `X(N)`. Quoted text, Hollerith payloads,
executable code, inline comments, and directives are preserved. Prose sentence
capitalization, proper names, and acronyms retain their intended case. Ambiguous
passages retain their original case. Author and reference paragraphs use the same
prose rules, with reviewed capitalization for author and institution names.
Variable definitions and status lists also use sentence case for their prose,
including descriptions alongside expressions such as `l .LT. n`.

The generated [comment review report](tools/comment-case-review.json) records
changed-line counts, protected categories, unfamiliar words, and uncertain
passages with source line numbers. Those line numbers apply to `nswc.f90`.
The first pass changes more than 18,000 comment lines. Some comments deliberately
remain uppercase for further review. To preview another file without replacing it:

```sh
python tools/sentence_case_comments.py input.f90 --output reviewed.f90 --report review.json
```

Output and report paths must be distinct new files. The sentence-case step is
applied to generated free-form sources; historical comments in the fixed-form
sources remain available for comparison.

`tools/name_procedure_ends.py` created the readable fixed-form source from
`nswc_orig.f`. It supports a preview, a separate output, and an in-place update
with a non-overwriting backup:

```sh
python tools/name_procedure_ends.py nswc_orig.f --diff
python tools/name_procedure_ends.py nswc_orig.f --output nswc_readable.f
```

The output must be a new file. Unsupported source forms or mismatched procedure
boundaries cause an error before writing. The script targets external functions
and subroutines, not modules or programs. Run the Python checks with
`python -m unittest discover -s tests -v`.

Run `python tools/validate_sources.py` to build and run 52 numerical test programs
against all three versions with GNU Fortran (156 test runs). Use `--compiler PATH`
when the compiler is not on your command search path. The suite includes 51 main
programs in `tests/fortran/`, covering linear algebra, special
functions, polynomial roots, nonlinear solving and minimization, interpolation, splines, integration, differential
equations, Fourier transforms, and random sequences. See the
[test guide](docs/numerical-tests.md) for individual programs, selection options,
adaptations, and coverage limits.

## Labelled DO loops

`tools/modernize_do.py` replaces straightforward labelled DO/CONTINUE loops
with DO/END DO in fixed-form source, with labels scoped to each external procedure.
The applied pass converted 2,548 loops and left 1,699 unchanged. The
[conversion record](docs/loop-modernization.csv) lists every original labelled
loop, its line numbers in `nswc.f` at commit `696d50f`, and the reason for each skipped case.
The conversion preserves physical line counts.

```sh
python tools/modernize_do.py nswc.f
python tools/modernize_do.py nswc.f --output new_source.f --report loop_report.csv
```

The default previews changes. Output and report paths must be new files.
`--diff` shows changes; `--in-place` creates a non-overwriting `.loops.bak`
backup. After changing `nswc.f`, run the source generator and validation commands
above. `nswc_orig.f` remains unchanged.

The converter skips shared termination labels, executable terminators,
continued headers, indirect branches, and ambiguous control flow. It retains
labels mentioned elsewhere in the procedure, conservatively treating numeric
mentions as possible references. This can leave safe conversions for later
review. It also skips loops with possible branches into their bodies.

A second reviewed pass now converts **1,425 additional loops**, including
executable terminal statements and shared termination labels. Existing terminal
operations and branch-target labels are preserved. A final pass converts the
remaining 274 loops using explicit branch references and removes all 48 ASSIGN
and 16 assigned GO TO statements. See [deleted-feature modernization](docs/deleted-features.md)
for the tool, compiler checks and strict-standard diagnostic progress.

All **303 arithmetic IF statements** have also been replaced with logical IFs
and GO TO statements. Three-way cases evaluate their expression once into a
compiler-typed local temporary. Procedure interfaces are unchanged; see the
[conversion and verification details](docs/deleted-features.md#arithmetic-if-conversion).

## Explicit typing

All 1,062 procedures in `nswc.f` and the generated `nswc.f90` now have
`IMPLICIT NONE` and explicit types, completed in sixteen reviewed batches.
The declarations were generated with `ftnchek` and supplemented where function
return types were omitted. `tools/explicit_typing.py` applies the
reviewed manifest; it does not guess types. The [typing guide](docs/explicit-typing.md)
records the affected procedures, tool limitations, and reproduction commands.
Run `python tools/validate_explicit_typing.py` to check preservation of variable
and function types, shapes, and argument lists, with separately reviewed warning
corrections. The guide
also records reviewed classifications for forwarded procedures, checked against
their original calling conventions and return types. The archived `nswc_orig.f`
retains its original typing.

## Combined declarations

Type and intent now appear together, for example `INTEGER, INTENT(IN) :: I`.
The maintained source uses `::` in its type declarations. The formatting pass
also combines separate array dimensions when declaration dependencies allow it.

```sh
python tools/combine_declarations.py nswc.f
python tools/combine_declarations.py input.f --output formatted.f --report formatting.json
```

The default previews changes. `--in-place` creates a non-overwriting
`.declarations.bak` backup; `--diff` displays the proposed edits. The
[typing guide](docs/explicit-typing.md#combined-declarations) explains the retained
dimensions, review report, and compiler checks. After changing `nswc.f`,
regenerate the derived sources and verify the interfaces as described above.

`tools/order_declarations.py` then groups dummy-argument type and `EXTERNAL`
declarations before local declarations, splitting mixed declarations as needed.
Array bounds and type dependencies take precedence over grouping. Separate
`DIMENSION` statements retain their positions because their bounds can depend on
`PARAMETER` definitions. Comments retain their text and relative order.

```sh
python tools/order_declarations.py input.f --output ordered.f --report ordering.json
```

Without `--output`, the tool reports proposed changes without writing the source.
Output and report paths must name distinct new files. The maintained source
already includes this pass; `tools/validate_explicit_typing.py` reproduces it,
checks the [ordering report](tools/declaration-ordering.json), and compares the
complete compiler symbol inventories before and after formatting.

## Argument intents

The maintained sources have 4,176 `INTENT(IN)`, 262 `INTENT(OUT)`, and 2,821
`INTENT(INOUT)` arguments across 1,007 procedures. Of the 8,101 data arguments,
842 remain without intents pending further review. Arrays that may retain
incoming values use `INOUT`; `OUT` is restricted to scalars initialized before
any possible branch or read. The [intent guide](docs/argument-intents.md)
describes the analysis, exclusions, and reproduction commands. The compiler
comparison checks every added intent as well as the original types and shapes.

## Compiler warnings

The warning review and periodic-root correction reduce the maintained fixed-form
GNU Fortran build from 28 warnings to 11.
It corrects the unused `ITERT` callback declaration and quadratic output extents,
and replaces old FORMAT text with quoted strings. The external procedure names
and argument order are unchanged. External/reference builds retain shared-storage
warnings; the standalone module compiles without warnings.
The maintained sources compile without argument-mismatch tolerance; the archive
still needs it. The [warning review](docs/compiler-warnings.md) records the changes,
remaining issues, and the checks that reject new compiler warnings.
