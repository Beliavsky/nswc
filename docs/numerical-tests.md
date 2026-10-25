# Numerical test programs

The suite contains the original `tests/source_smoke.f90` and 14 standalone main
programs adapted from `C:/fortran/amiller-nswc/test/*_legacy.f90`. Each adapted
file records its source filename in its opening comment. The tests call the
historical external interfaces directly; they need no Miller modules, input
files, or interactive responses.

Run all 15 programs against each of the three source versions:

```sh
python tools/validate_sources.py
```

If GNU Fortran is not on your command search path, supply its executable:

```sh
python tools/validate_sources.py --compiler C:/equation/bin/gfortran.exe
```

The runner compiles each library version once, then links and runs every main
program against that object file separately. All build products and program
working directories are temporary. The default therefore performs 45 numerical
test runs. The same command runs in GitHub Actions.

For a selected program or library version:

```sh
python tools/validate_sources.py --test test_dense_solvers --source nswc.f90
```

Both selectors may be repeated. The source choices are `nswc.f90`, `nswc.f`, and
`nswc_orig.f`. Never link several library versions into the same executable.
Each Fortran file is also an independent main program that can be compiled
directly with any one of those library files.

## Checks performed

| Main program in `tests/fortran/` | Principal checks |
|---|---|
| `test_real_blas1.f90` | Single and double precision vector operations, strides, rotations, and reductions |
| `test_dense_solvers.f90` | Known real and complex solutions using `MSLV`, `CMSLV`, and `SLVMP` |
| `test_least_squares.f90` | Known solutions using orthogonal and banded least squares |
| `test_svd.f90` | Matrix reconstruction from single, double, and complex singular value decompositions |
| `test_symmetric_eigensystem.f90` | Known eigenvalues and eigenvector residuals |
| `test_double_special.f90` | Gamma and error functions against compiler intrinsics, known values, and small argument references |
| `test_incomplete_beta_compat.f90` | Probability values and complements, supporting functions, and invalid input status codes |
| `test_general_polynomial_roots.f90` | Real and complex polynomial root counts and independently evaluated residuals |
| `test_interpolation_compat.f90` | Cubic polynomial reproduction, piecewise evaluation, and polygon area |
| `test_spline.f90` | Spline derivatives, exact polynomial integrals, and plane and space curve interpolation |
| `test_quadrature.f90` | Known integrals and the sum of integration weights |
| `test_ode.f90` | Exponential solutions with fixed and adaptive integration interfaces |
| `test_fftpack_workers.f90` | Direct Fourier and cosine sums as well as transform round trips |
| `test_random.f90` | Seed progression and a known normal sequence |

The smoke program additionally exercises zero iteration counts, negative and
non-unit vector strides, a dense solve with pivoting, special functions, and
adaptive quadrature.

Each program checks mathematical results with its stated tolerances and prints
numerical diagnostics before its final PASS marker. The runner requires a zero
exit status, that completion marker, and identical output across source versions
when several versions are selected. A result shared by all versions still has
to satisfy the mathematical checks inside the driver.

The GNU Fortran build uses `-std=legacy -fallow-argument-mismatch` for the library.
Test main programs enable `-ffpe-trap=invalid,zero,overflow`, so invalid arithmetic
cannot silently pass a comparison involving a NaN. Each execution has a default
30 second timeout, adjustable with `--timeout`. The runner continues after a
failure to report other failing programs, and returns a nonzero status if any
build, execution, completion, or output comparison fails.

## Adaptations and limits

The constants module dependency was replaced with the standard
`iso_fortran_env` module where needed. The test interfaces retain the original
precision and calling conventions, including the in-place callbacks of `RK`
and `RK8`.

`SAMAX` and `BSPEV` from the Miller package are absent from this NSWC source.
Their checks were omitted; `ISAMAX` still checks the maximum element index.
The Fourier worker factor array is declared as an integer array to match the
original routines. The cosine worker workspace is explicitly initialized with
`RFFTI`; the Miller backend could initialize it on demand. Direct forward
transform checks were added in addition to the adapted round trip checks.

These are representative regression tests. They do not cover every procedure,
error path, or numerical regime, and agreement among source versions does not
establish correctness of the full library. No library algorithms or machine
constants were changed to make these tests pass.
