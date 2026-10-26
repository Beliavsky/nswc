# Numerical test programs

The suite contains the original `tests/source_smoke.f90`, 41 standalone main
programs adapted from `C:/fortran/amiller-nswc/test/*_legacy.f90`, and three new
programs checking quadratic/cubic roots, integral iteration and norm scaling, plus four callback
test programs and a periodic block-system test listed below. Each adapted
file records its source filename in its opening comment. The tests call the
historical external interfaces directly; they need no Miller modules, input
files, or interactive responses.

Run all 50 programs against each of the three source versions:

```sh
python tools/validate_sources.py
```

If GNU Fortran is not on your command search path, supply its executable:

```sh
python tools/validate_sources.py --compiler C:/equation/bin/gfortran.exe
```

The runner compiles each library version once, then links and runs every main
program against that object file separately. All build products and program
working directories are temporary. The default therefore performs 150 numerical
test runs. The same command runs in GitHub Actions.

To compare all 50 mains using external procedures with callers importing the
standalone module, run `python tools/validate_module.py`. This performs 102 numerical
runs, including a focused double-precision gamma test, and checks module signatures,
elemental arrays and invalid data arguments.
See the [module guide](module.md).

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
| `test_blktri_periodic.f90` | Periodic block systems with real and complex roots, odd/even dimensions, both boundary conditions in the other dimension, and reused initialization |
| `test_callback_roots.f90` | Single and double precision scalar roots, an endpoint root, and a known scalar minimum |
| `test_callback_minpack.f90` | Nonlinear roots, least squares with a nonzero residual, callback cancellation, and vector minimization |
| `test_callback_rows.f90` | Real, double precision, and complex row callbacks, pivoting, and a singular-system status |
| `test_callback_pde.f90` | A separable Poisson problem with an analytic solution and nonzero boundary data, using second and fourth order schemes |
| `test_real_blas1.f90` | Single and double precision vector operations, strides, rotations, and reductions |
| `test_norm_scaling.f90` | Real and complex norm scaling states, tiny/large values, zero vectors, mixed scales and strides |
| `test_dense_solvers.f90` | Known real and complex solutions using `MSLV`, `CMSLV`, and `SLVMP` |
| `test_dense_matrix_utils.f90` | Real, double precision, and complex matrix products, conversions, transposes, and adjoints |
| `test_matrix_utility_continuation.f90` | In-place rectangular transposes, transpose products, Gram matrices, and packed symmetric products |
| `test_matrix_arithmetic.f90` | Matrix copies, conjugation, arithmetic, full/packed symmetric conversions, and Kronecker products |
| `test_packed_linpack.f90` | Packed positive definite and indefinite solves, determinants, condition estimates, and inertia |
| `test_pivoted_banded.f90` | Real and complex banded solves with pivoting, including transpose systems |
| `test_symmetric_banded.f90` | Packed symmetric systems, triangular-factor solves, and banded LU and Cholesky factors |
| `test_banded_double.f90` | Double precision dense/band/sparse conversions, band arithmetic, transposes, and matrix/vector products |
| `test_banded_arithmetic.f90` | Real and complex band arithmetic, transposes, matrix/vector products, and automatic bandwidth detection |
| `test_sparse_operations.f90` | Sparse arithmetic, transposes, vector accumulation, norms, empty rows, cancellation, and insufficient storage |
| `test_sparse_conversions.f90` | Dense/sparse round trips, real and imaginary parts, conjugation, and precision conversions |
| `test_band_sparse_conversions.f90` | Real and complex band/sparse round trips and packed symmetric conversion |
| `test_sparse_structure_workers.f90` | Structural matching, connected blocks, row-length ordering, and block permutations |
| `test_sparse_solvers.f90` | Double precision sparse solves, transpose systems, ordering, and factorization reuse |
| `test_sparse_solvers_single_complex.f90` | Real and complex sparse solves, transpose systems, and factorization reuse |
| `test_sparse_direct_solvers.f90` | Real, double precision, and complex direct sparse solutions with pivoting |
| `test_least_squares.f90` | Known solutions using orthogonal and banded least squares |
| `test_svd.f90` | Matrix reconstruction from single, double, and complex singular value decompositions |
| `test_symmetric_eigensystem.f90` | Known eigenvalues and eigenvector residuals |
| `test_real_eigensystem.f90` | Real and double precision eigenvalues, nonzero eigenvectors, and residuals with and without balancing |
| `test_real_eigensystem_compat.f90` | Orthogonal Hessenberg reconstruction and alternate real eigenvalue interfaces |
| `test_real_hessenberg_qr.f90` | Single and double precision QR spectra and eigenvector residuals |
| `test_elementary_hessenberg.f90` | Elementary Hessenberg transformations with integer and real permutation workspaces |
| `test_complex_eigensystem.f90` | Single and double precision complex eigenvalues and nonzero eigenvector residuals, with and without balancing |
| `test_complex_hessenberg.f90` | Complex Hessenberg/QR eigenvector residuals and known triangular spectra in both precisions |
| `test_eigen_balance.f90` | Real and complex balancing round trips and eigenvector scaling in both precisions |
| `test_symmetric_eispack_workers.f90` | Symmetric reductions, packed storage, known spectra, and eigenvector residuals |
| `test_double_special.f90` | Gamma and error functions against compiler intrinsics, known values, and small argument references |
| `test_incomplete_beta_compat.f90` | Probability values and complements, supporting functions, and invalid input status codes |
| `test_general_polynomial_roots.f90` | Real and complex polynomial root counts and independently evaluated residuals |
| `test_quadratic_cubic.f90` | Quadratic roots, cubic reductions with a zero constant term, and untouched output elements |
| `test_integral_iteration.f90` | Zero-kernel integral iteration in both storage paths, including reuse and an unused callback |
| `test_interpolation_compat.f90` | Cubic polynomial reproduction, piecewise evaluation, and polygon area |
| `test_spline.f90` | Spline derivatives, exact polynomial integrals, and plane and space curve interpolation |
| `test_quadrature.f90` | Known integrals and the sum of integration weights |
| `test_ode.f90` | Exponential solutions with fixed and adaptive integration interfaces |
| `test_fftpack_workers.f90` | Direct Fourier and cosine sums and transform round trips at lengths 3, 5, 8, and 15, including public cosine-transform calls |
| `test_inverse_laplace.f90` | Known exponential inverse transforms and convergence checks on both sides of a pole, including forwarded subroutine callbacks |
| `test_sfode.f90` | Scalar and vector tolerances for a stiff ODE with a known cosine solution |
| `test_surface.f90` | Bilinear surface reproduction with splines under tension, including the original statement functions and their internal-function replacements |
| `test_cubature.f90` | Exact triangle integrals using direct and adaptive cubature with function callbacks |
| `test_random.f90` | Seed progression and a known normal sequence |

The smoke program additionally exercises zero iteration counts, negative and
non-unit vector strides, a dense solve with pivoting, special functions, and
adaptive quadrature.

Each program checks mathematical results with its stated tolerances and prints
numerical diagnostics before its final PASS marker. The runner requires a zero
exit status, that completion marker, and identical output across source versions
when several versions are selected. A result shared by all versions still has
to satisfy the mathematical checks inside the driver.

The GNU Fortran runner uses legacy mode to compare against the archive. Only
`nswc_orig.f` permits argument-mismatch tolerance; maintained sources reject it.
`tools/validate_remaining_features.py` separately compiles all maintained
versions in strict modern Fortran modes. `test_norm_scaling.f90` exercises the
real and complex norm dispatch states with tiny, ordinary and large magnitudes,
mixed scales, zero vectors and strides greater than one.
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
The Fourier worker factor array retains the original routines' `REAL` type.
The cosine worker workspace is explicitly initialized with
`RFFTI`; the Miller backend could initialize it on demand. Direct forward
transform checks were added in addition to the adapted round trip checks.

These are representative regression tests. They do not cover every procedure,
error path, or numerical regime, and agreement among source versions does not
establish correctness of the full library. No library algorithms or machine
constants were changed to make these tests pass.
