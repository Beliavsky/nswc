# NSWC Library of Mathematics Subroutines

**Alfred H. Morris, Jr.** — Naval Surface Warfare Center, Dahlgren Division  
Report **NSWCDD/TR-92/425** (January 1993)  
Approved for public release; distribution unlimited.

This is a GitHub-browseable edition of the 1993 manual, checked against the
supplied fixed-form Fortran source (`nswc.f`). The routine index covers **576**
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
- [Original report cover](scans/page_0001.png)
- [Original Fortran source](nswc.f)

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

## Source readability script

`tools/name_procedure_ends.py` adds the matching name to procedure endings and
ensures a blank line after each procedure except the last. It handles fixed-form
typed function headers, continuations, labels, comments, and sequence fields.
It uses only the Python standard library and defaults to a preview:

```sh
python tools/name_procedure_ends.py nswc.f
python tools/name_procedure_ends.py nswc.f --output nswc_readable.f
```

The output must be a new file. `--diff` shows proposed changes; `--in-place`
updates the source after creating a non-overwriting `.bak` backup. Unsupported
source forms or mismatched procedure boundaries cause an error before writing.
The script targets external functions and subroutines, not modules or programs.
Named endings require a Fortran 90 or newer compiler, even with fixed-form source.

Applying the script changes source line numbers. Regenerate `source_parts` and
the Markdown source links together before publishing a converted `nswc.f`.
Run the script's tests with `python -m unittest discover -s tests -v`.
