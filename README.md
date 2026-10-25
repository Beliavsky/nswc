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

Run `python tools/validate_sources.py` to build and run 24 numerical test programs
against all three versions with GNU Fortran (72 test runs). Use `--compiler PATH`
when the compiler is not on your command search path. The suite includes 23 main
programs in `tests/fortran/`, covering linear algebra, special
functions, polynomial roots, interpolation, splines, integration, differential
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

Eleven reviewed batches add `IMPLICIT NONE` and any missing declarations to
324 procedures. The declarations were generated with `ftnchek` and supplemented
where function return types were omitted. `tools/explicit_typing.py` applies the
reviewed manifest; it does not guess types. The [typing guide](docs/explicit-typing.md)
records the affected procedures, tool limitations, and reproduction commands.
Run `python tools/validate_explicit_typing.py` to check that the compiler sees
the same variable and external procedure types, shapes, and argument lists.
