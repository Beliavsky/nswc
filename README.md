# NSWC Library of Mathematics Subroutines

**Alfred H. Morris, Jr.** — Naval Surface Warfare Center, Dahlgren Division  
Report **NSWCDD/TR-92/425** (January 1993)  
Approved for public release; distribution unlimited.

This is a GitHub-browseable edition of the 1993 manual, checked against the
original fixed-form Fortran source (`nswc_orig.f`). The routine index covers **576**
documented procedures; the source contains **1,062** declarations including
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
- [Optional procedure interfaces](docs/interfaces.md)
- [Original report cover](scans/page_0001.png)
- [Recommended free-form Fortran source](nswc.f90)
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

Use `nswc.f90`, the recommended free-form version. It has named procedure
endings and blank lines between procedures. `nswc.f` provides the same library
in readable fixed form; `nswc_orig.f` preserves the supplied source unchanged.
Compile only one version of the library to avoid duplicate procedure definitions.
Documentation source links point into free-form files in `source_parts/`;
displayed line numbers refer to the complete `nswc.f90`.

The library retains legacy Fortran features. For GNU Fortran, for example:

```sh
gfortran -c -std=legacy -fallow-argument-mismatch nswc.f90
```

These options accommodate existing legacy constructs and argument mismatches;
they do not establish correctness for every routine. Machine constants retain
the original configuration; see the installation appendix before numerical use.
Named procedure endings require Fortran 90 or newer, including in `nswc.f`.

## Optional interfaces

[`nswc_interfaces.f90`](nswc_interfaces.f90) provides explicit interfaces for all
1,062 external procedures in the maintained sources. Its interfaces were
generated with Intel `ifx` and checked independently with GNU Fortran. Existing
callers can continue without it. To enable argument checking, compile the module
with the same compiler as the library, then import selected procedures:

```fortran
use nswc_interfaces, only: sgefa, sgesl
```

For GNU Fortran, after compiling the library as above:

```sh
gfortran -c nswc_interfaces.f90
gfortran myprogram.f90 nswc.o -o myprogram
```

The module contains interfaces only; link the library object as usual. The
[interface guide](docs/interfaces.md) describes generation, verification, Intel
commands, and callback limitations. Run `python tools/validate_interfaces.py`
to compare all signatures and test callers using the module.

## Regenerating the source

Maintain `nswc.f` and generate `nswc.f90`, its browsable partitions, and the
Markdown source links together:

```sh
python tools/regenerate_sources.py
python tools/regenerate_sources.py --check
```

The generator overwrites generated source files and updates source-link line
numbers. Do not edit `nswc.f90` or `source_parts/` independently. It uses the
repository copy of `tools/fixed_to_free.py`, so regeneration needs only Python's
standard library. The converter handles compact DATA array declarations and wraps
long FORMAT statements without splitting their Hollerith text.

Generation also applies `tools/lowercase_fortran.py` to make free-form code
lowercase while preserving quoted strings, comments, spacing, and line numbers.
Comment capitalization can be reviewed separately in the maintained `nswc.f`.
For another free-form file, use
`python tools/lowercase_fortran.py input.f90 --output lowercase.f90`.
The output must be a new file. The filter rejects preprocessor directives and
unquoted Hollerith constants, which require separate review. Existing quoted
FORMAT strings in the maintained library are preserved exactly.

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

Run `python tools/validate_sources.py` to build and run 48 numerical test programs
against all three versions with GNU Fortran (144 test runs). Use `--compiler PATH`
when the compiler is not on your command search path. The suite includes 47 main
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

## Argument intents

The maintained sources have 4,176 `INTENT(IN)`, 262 `INTENT(OUT)`, and 2,821
`INTENT(INOUT)` arguments across 1,007 procedures. Of the 8,101 data arguments,
842 remain without intents pending further review. Arrays that may retain
incoming values use `INOUT`; `OUT` is restricted to scalars initialized before
any possible branch or read. The [intent guide](docs/argument-intents.md)
describes the analysis, exclusions, and reproduction commands. The compiler
comparison checks every added intent as well as the original types and shapes.

## Compiler warnings

The warning review reduces the local GNU Fortran build from 28 warnings to 12.
It corrects the unused `ITERT` callback declaration and quadratic output extents,
and replaces old FORMAT text with quoted strings. The external procedure names
and argument order are unchanged. The remaining warnings involve shared storage
and a real/complex workspace overlap; the legacy compiler options are still
required. The [warning review](docs/compiler-warnings.md) records the changes,
remaining issues, and the checks that reject new compiler warnings.
