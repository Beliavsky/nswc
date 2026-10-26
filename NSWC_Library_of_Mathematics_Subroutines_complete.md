# NSWC Library of Mathematics Subroutines

**Alfred H. Morris, Jr.**  
**Naval Surface Warfare Center, Dahlgren Division**  
**Report NSWCDD/TR-92/425 — January 1993**  
**Approved for public release; distribution unlimited.**

> **Editorial status (source-checked):** The routine names and interfaces marked **Source-verified** were cross-checked against the supplied fixed-form Fortran source (preserved as `nswc_orig.f`). This remains an OCR-assisted transcription of the 1993 report; mathematical expressions, numerical constants, and parts of the narrative are **not fully verified**. When in doubt, consult both the scanned page and the original source. See [the audit report](NSWC_Source_Audit.md) for scope and limitations.

The original page scans are available through the **View scanned page** links throughout this document. They preserve equations, diagrams, figures, and typography that cannot reliably be reconstructed from OCR.

[Original report cover](scans/page_0001.png) | [Original title page](scans/page_0002.png)


> **Calling conventions:** The source-verified interfaces reproduce the procedure names and dummy-argument order as declared in the source, available in recommended free form as `nswc.f90`. Dummy-argument identifiers may differ from the original manual (Fortran arguments are positional). The original fixed-form source is preserved as `nswc_orig.f`; `nswc.f` is a readable fixed-form alternative. Source links point into small GitHub-browsable free-form partitions; labels show the `nswc.f90` line numbers.

## Contents

- [Foreword](#foreword)
- [Abstract](#abstract)
- [Original printed contents (page scans)](#original-contents)
- [Introduction](#category-015)
- [Elementary Operations](#category-017)
  - [Machine Constants](#topic-017-01)
  - [Argument Bounds for the Exponential Function](#topic-019-01)
  - [Sorting Lists](#topic-021-01)
  - [Cube Root](#topic-024-01)
  - [Four-Quadrant Arctangent](#topic-024-02)
  - [Length Of A Two Dimensional Vector](#topic-024-03)
  - [Reciprocal Of A Complex Number](#topic-026-01)
  - [Division Of Complex Numbers](#topic-026-02)
  - [Square Root Of A Double Precision Complex Number](#topic-026-03)
  - [Conversion Of Polar To Cartesian Coordinates](#topic-028-01)
  - [Conversion Of Cartesian To Polar Coordinates](#topic-028-02)
  - [Rotation Of Axes](#topic-028-03)
  - [Planar Givens Rotations](#topic-029-01)
  - [Three-Dimensional Rotations](#topic-030-01)
  - [Rotation of a Point on the Unit Sphere to the North Pole](#topic-031-01)
  - [Computation Of The Angle Between Two Vectors](#topic-032-01)
  - [Trigonometric Functions](#topic-033-01)
  - [Hyperbolic Sine And Cosine Functions](#topic-035-01)
  - [Exponentials](#topic-036-01)
  - [Logarithms](#topic-037-01)
- [Geometry](#category-039)
  - [Determining if a Point Is Inside or Outside a Polygon](#topic-039-01)
  - [Intersection of a Straight Line and Polygonal Path](#topic-040-01)
  - [The Convex Hull for a Finite Planar Set](#topic-041-01)
  - [Areas Of Planar Polygons](#topic-042-01)
  - [Hamiltonian Circuits](#topic-043-01)
- [Special Functions](#category-046)
  - [Error Function](#topic-046-01)
  - [Inverse Error Function](#topic-051-01)
  - [Difference Of Error Functions](#topic-052-01)
  - [Normal Probability Distribution Function](#topic-053-01)
  - [Inverse Normal Probability Distribution Function](#topic-054-01)
  - [Dawson's Integral](#topic-055-01)
  - [Complex Fresnel Integral](#topic-056-01)
  - [Real Fresnel Integrals](#topic-057-01)
  - [Exponential Integral Function](#topic-058-01)
  - [Sine and Cosine Integral Functions](#topic-061-01)
  - [Exponential Exponential Integral Function](#topic-062-01)
  - [Dilogarithm Function](#topic-063-01)
  - [Gamma Function](#topic-065-01)
  - [Digamma Function](#topic-069-01)
  - [Derivatives Of The Digamma Function](#topic-071-01)
  - [Incomplete Gamma Ratio Functions](#topic-072-01)
  - [Inverse Incomplete Gamma Ratio Function](#topic-074-01)
  - [Logarithm Of The Beta Function](#topic-076-01)
  - [Incomplete Beta Function](#topic-077-01)
  - [Bessel Function J_v(z)](#topic-079-01)
  - [Bessel Function Y_v(z)](#topic-081-01)
  - [Modified Bessel Function I_v(z)](#topic-082-01)
  - [Modified Bessel Function K_v(z)](#topic-084-01)
  - [Airy Functions](#topic-086-01)
  - [Complete Complex Elliptic Integrals Of The First And Second Kinds](#topic-089-01)
  - [Real Elliptic Integrals Of The First And Second Kinds](#topic-092-01)
  - [Real Elliptic Integrals Of The Third Kind](#topic-096-01)
  - [Jacobian Elliptic Functions](#topic-099-01)
  - [Weierstrass Elliptic Function for the Equianharmonic and Lemniscatic Cases](#topic-102-01)
  - [Integral of the Bivariate Density Function over Arbitrary Polygons and Semi-Infinite Angular Regions](#topic-105-01)
  - [Circular Coverage Function](#topic-107-01)
  - [Elliptical Coverage Function](#topic-109-01)
- [Polynomials](#category-110)
  - [Copying Polynomials](#topic-110-01)
  - [Addition Of Polynomials](#topic-111-01)
  - [Subtraction Of Polynomials](#topic-112-01)
  - [Multiplication Of Polynomials](#topic-113-01)
  - [Division Of Polynomials](#topic-114-01)
  - [Real Powers Of Polynomials](#topic-115-01)
  - [Inverses Of Power Series](#topic-116-01)
  - [Derivatives And Integrals Of Polynomials](#topic-117-01)
  - [Evaluation Of Chebyshev Expansions](#topic-118-01)
  - [Lagrange Polynomials](#topic-119-01)
  - [Orthogonal Polynomials On Finite Sets](#topic-121-01)
- [Solutions of Nonlinear Equations](#category-122)
  - [Zeros Of Continuous Functions](#topic-122-01)
  - [Solution Of Systems Of Nonlinear Equations](#topic-124-01)
  - [Solutions Of Quadratic, Cubic, And Quartic Equations](#topic-126-01)
  - [Double Precision Roots of Polynomials](#topic-127-01)
  - [Accuracy Of The Roots Of Polynomials](#topic-129-01)
- [Vectors](#category-130)
  - [Copying Vectors](#topic-130-01)
  - [Interchanging Vectors](#topic-131-01)
  - [Planar Rotation Of Vectors](#topic-132-01)
  - [Modified Givens Rotations](#topic-133-01)
  - [Dot Products Of Vectors](#topic-136-01)
  - [Scaling Vectors](#topic-137-01)
  - [Vector Addition](#topic-138-01)
  - [L1 Norm of a Vector](#topic-139-01)
  - [L2 Norm of a Vector](#topic-140-01)
  - [L-infinity Norm of a Vector](#topic-141-01)
- [Matrices](#category-142)
  - [Packing And Unpacking Symmetric Matrices](#topic-142-01)
  - [Conversion Of Real Matrices To And From Double Precision Form](#topic-143-01)
  - [Storage Of Real Matrices In The Complex Matrix Format](#topic-144-01)
  - [The Real And Imaginary Parts Of A Complex Matrix](#topic-145-01)
  - [Copying Matrices](#topic-146-01)
  - [Computation Of The Conjugate Of A Complex Matrix](#topic-147-01)
  - [Transposing Matrices](#topic-148-01)
  - [Computing Adjoints Of Complex Matrices](#topic-150-01)
  - [Matrix Addition](#topic-151-01)
  - [Matrix Subtraction](#topic-153-01)
  - [Matrix Multiplication](#topic-155-01)
  - [Product Of A Packed Symmetric Matrix And A Vector](#topic-157-01)
  - [Transpose Matrix Products](#topic-158-01)
  - [Symmetric Matrix Products](#topic-159-01)
  - [Kronecker Product Of Matrices](#topic-160-01)
  - [Rank Of A Real Matrix](#topic-161-01)
  - [Inverting General Real Matrices And Solving General Systems Of Real Linear Equations](#topic-163-01)
  - [Solution of Real Equations with Iterative Improvement](#topic-168-01)
  - [Solution Of Almost Block Diagonal Systems Of Linear Equations](#topic-169-01)
  - [Solution Of Almost Block Tridiagonal Systems Of Linear Equations](#topic-171-01)
  - [Inverting Symmetric Real Matrices And Solving Symmetric Systems Of Real Linear Equations](#topic-173-01)
  - [Inverting Positive Definite Symmetric Matrices And Solving Positive Definite Symmetric Systems Of Linear Equations](#topic-176-01)
  - [Solution Of Toeplitz Systems Of Linear Equations](#topic-177-01)
  - [Inverting General Complex Matrices And Solving General Systems Of Complex Linear Equations](#topic-178-01)
  - [Solution Of Complex Equations With Iterative Improvement](#topic-182-01)
  - [Singular Value Decomposition Of A Matrix](#topic-183-01)
  - [Evaluation Of The Characteristic Polynomial Of A Matrix](#topic-185-01)
  - [Solution Of The Matrix Equation Ax + Xb = C](#topic-186-01)
  - [Solution of the Matrix Equation A^T X + XA = C When C Is Symmetric](#topic-188-01)
  - [Solution of the Matrix Equation AX^2 + BX + C = 0](#topic-189-01)
  - [Exponential Of A Real Matrix](#topic-191-01)
- [Large Dense Systems of Linear Equations](#category-193)
  - [Solving Systems Of 200-400 Linear Equations](#topic-193-01)
- [Banded Matrices](#category-195)
  - [Band Matrix Storage](#topic-195-01)
  - [Conversion Of Banded Matrices To And From The Standard Format](#topic-196-01)
  - [Conversion Of Banded Matrices To And From Sparse Form](#topic-198-01)
  - [Conversion Of Banded Real Matrices To And From Double Precision Form](#topic-200-01)
  - [The Real And Imaginary Parts Of A Banded Complex Matrix](#topic-201-01)
  - [Computing A + Bi For Banded Real Matrices A And B](#topic-202-01)
  - [Transposing Banded Matrices](#topic-203-01)
  - [Addition Of Banded Matrices](#topic-204-01)
  - [Subtraction Of Banded Matrices](#topic-205-01)
  - [Multiplication Of Banded Matrices](#topic-206-01)
  - [Product Of A Real Banded Matrix And Vector](#topic-207-01)
  - [Product Of A Double Precision Banded Matrix And Vector](#topic-209-01)
  - [Product Of A Complex Banded Matrix And Vector](#topic-211-01)
  - [L1 Norm of a Real Banded Matrix](#topic-213-01)
  - [L-infinity Norm of a Real Banded Matrix](#topic-214-01)
  - [Solution Of Banded Systems Of Real Linear Equations](#topic-215-01)
  - [Computation Of The Condition Number Of A Real Banded Matrix](#topic-217-01)
  - [Double Precision Solution Of Banded Systems Of Real Linear Equations](#topic-219-01)
  - [Computation Of The Condition Number Of A Double Precision Banded Matrix](#topic-221-01)
  - [Solution Of Banded Systems Of Complex Linear Equations](#topic-223-01)
- [Sparse Matrices](#category-225)
  - [Storage Of Sparse Matrices](#topic-225-01)
  - [Conversion Of Sparse Matrices To And From The Standard Format](#topic-226-01)
  - [Conversion Of Sparse Real Matrices To And From Double Precision Form](#topic-228-01)
  - [The Real And Imaginary Parts Of A Sparse Complex Matrix](#topic-229-01)
  - [Computing A + Bi For Sparse Real Matrices A And B](#topic-230-01)
  - [Copying Sparse Matrices](#topic-231-01)
  - [Computing Conjugates Of Sparse Complex Matrices](#topic-232-01)
  - [Transposing Sparse Real Matrices](#topic-233-01)
  - [Transposing Sparse Double Precision Matrices](#topic-234-01)
  - [Transposing Sparse Complex Matrices](#topic-235-01)
  - [Addition of Sparse Matrices](#topic-236-01)
  - [Subtraction of Sparse Matrices](#topic-237-01)
  - [Multiplication Of Sparse Matrices](#topic-238-01)
  - [Product Of A Real Sparse Matrix And Vector](#topic-239-01)
  - [Product Of A Double Precision Sparse Matrix And Vector](#topic-240-01)
  - [Product Of A Complex Sparse Matrix And Vector](#topic-241-01)
  - [L1 Norm of a Sparse Real Matrix](#topic-242-01)
  - [L-infinity Norm of a Sparse Real Matrix](#topic-243-01)
  - [Ordering The Rows Of A Sparse Matrix By Increasing Length](#topic-244-01)
  - [Reordering Sparse Matrices Into Block Triangular Form](#topic-245-01)
  - [Solution Of Sparse Systems Of Real Linear Equations](#topic-246-01)
  - [Computation Of The Condition Number Of A Real Sparse Matrix](#topic-250-01)
  - [Double Precision Solution Of Sparse Systems Of Real Linear Equations](#topic-252-01)
  - [Computation Of The Condition Number Of A Double Precision Sparse Matrix](#topic-256-01)
  - [Solution Of Sparse Systems Of Complex Linear Equations](#topic-258-01)
- [Eigenvalues and Eigenvectors](#category-262)
  - [Computation Of Eigenvalues Of General Real Matrices](#topic-262-01)
  - [Computation of Eigenvalues and Eigenvectors of General Real Matrices](#topic-264-01)
  - [Double Precision Computation Of Eigenvalues Of Real Matrices](#topic-266-01)
  - [Double Precision Computation Of Eigenvalues And Eigenvectors Of Real Matrices](#topic-267-01)
  - [Computation Of Eigenvalues Of Symmetric Real Matrices](#topic-269-01)
  - [Computation Of Eigenvalues And Eigenvectors Of Symmetric Real Matrices](#topic-270-01)
  - [Double Precision Computation Of Eigenvalues Of Symmetric Real Matrices](#topic-271-01)
  - [Double Precision Computation Of Eigenvalues And Eigenvectors Of Symmetric Real Matrices](#topic-272-01)
  - [Computation Of Eigenvalues Of Complex Matrices](#topic-273-01)
  - [Computation Of Eigenvalues And Eigenvectors Of Complex Matrices](#topic-274-01)
  - [Double Precision Computation Of Eigenvalues Of Complex Matrices](#topic-276-01)
  - [Double Precision Computation Of Eigenvalues And Eigenvectors Of Complex Matrices](#topic-277-01)
- [L1 Solution of Linear Equations](#category-279)
  - [L1 Solution Of Systems Of Linear Equations With Equality And Inequality Constraints](#topic-279-01)
- [Least Squares Solution of Linear Equations](#category-281)
  - [Least Squares Solution Of Systems Of Linear Equations](#topic-281-01)
  - [Least Squares Solution of Overdetermined Systems of Linear Equations with Iterative Improvement](#topic-286-01)
  - [Double Precision Least Squares Solution Of Systems Of Linear Equations](#topic-287-01)
  - [Least Squares Solution Of Systems Of Linear Equations With Equality And Inequality Constraints](#topic-292-01)
  - [Least Squares Solution Of Systems Of Linear Equations With Equality And Nonnegativity Constraints](#topic-296-01)
  - [Least Squares Iterative Improvement Solution Of Systems Of Linear Equations With Equality Constraints](#topic-299-01)
  - [Iterative Least Squares Solution Of Banded Linear](#topic-302-01)
  - [Iterative Least Squares Solution Of Sparse Linear](#topic-304-01)
- [Optimization](#category-306)
  - [Minimization Of Functions Of A Single Variable](#topic-306-01)
  - [Minimization Of Functions Of N Variables](#topic-307-01)
  - [Unconstrained Minimum Of The Sum Of Squares Of Nonlinear Functions](#topic-309-01)
  - [Linear Programming](#topic-311-01)
  - [The Assignment Problem](#topic-314-01)
  - [0-1 Knapsack Problem](#topic-315-01)
- [Transforms](#category-317)
  - [Inversion Of The Laplace Transform](#topic-317-01)
  - [Fast Fourier Transform](#topic-320-01)
  - [Multivariate Fast Fourier Transform](#topic-322-01)
  - [Discrete Cosine And Sine Transforms](#topic-324-01)
- [Approximation of Functions](#category-327)
  - [Rational Minimax Approximation Of Functions](#topic-327-01)
  - [Lp Approximation of Functions](#topic-329-01)
  - [Calculation Of The Taylor Series Of A Complex Analytic Function](#topic-333-01)
- [Curve Fitting](#category-336)
  - [Linear Interpolation](#topic-336-01)
  - [Lagrange Interpolation](#topic-337-01)
  - [Hermite Interpolation](#topic-338-01)
  - [Conversion Of Real Polynomials From Newton To Taylor Series Form](#topic-339-01)
  - [Least Squares Polynomial Fit](#topic-340-01)
  - [Weighted Least Squares Polynomial Fit](#topic-341-01)
  - [Cubic Spline Interpolation](#topic-342-01)
  - [Weighted Least Squares Cubic Spline Fitting](#topic-344-01)
  - [Least Squares Cubic Spline Fitting With Equality And Inequality Constraints](#topic-345-01)
  - [Cubic Spline Evaluation](#topic-347-01)
  - [Cubic Spline Evaluation And Differentiation](#topic-349-01)
  - [Integrals Of Cubic Splines](#topic-351-01)
  - [Periodic Cubic Spline Interpolation](#topic-352-01)
  - [Least Squares Periodic Cubic Spline Fitting](#topic-353-01)
  - [Periodic Cubic Spline Evaluation And Differentiation](#topic-354-01)
  - [N-Dimensional Cubic Spline Closed Curve Fitting](#topic-355-01)
  - [Spline Under Tension Interpolation](#topic-357-01)
  - [Spline Under Tension Evaluation](#topic-359-01)
  - [Differentiation And Integration Of Splines Under Tension](#topic-360-01)
  - [Two Dimensional Spline Under Tension Curve Fitting](#topic-361-01)
  - [Two Dimensional Spline Under Tension Closed Curve Fitting](#topic-363-01)
  - [Three Dimensional Spline Under Tension Curve Fitting](#topic-365-01)
  - [Finding The Interval That Contains A Point](#topic-368-01)
  - [Evaluation And Differentiation Of Piecewise Polynomials From Their B-Spline Representations](#topic-369-01)
  - [Evaluation Of The Indefinite Integral Of A Piecewise Polynomial From Its B-Spline Representation](#topic-370-01)
  - [Conversion Of Piecewise Polynomials From B-Spline To Taylor Series Form](#topic-371-01)
  - [Evaluation Of Piecewise Polynomials From The!Ir Taylor Ser'Es Representations](#topic-372-01)
  - [Piecewise Polynomial Interpolation](#topic-373-01)
  - [Weighted Least Squares Piecewise Polynomial Fitting](#topic-375-01)
  - [Least Squares Piecewise Polynomial Fitting With Equality And Inequality Constraints](#topic-376-01)
- [Surface Fitting over Rectangular Grids](#category-378)
  - [Bicubic Splines and Bisplines under Tension](#topic-378-01)
  - [Weighted Least Squares Bicubic Spline Fitting](#topic-379-01)
  - [Evaluation and Differentiation of Bicubic Splines](#topic-381-01)
  - [Bispline Under Tension Surface Interpolation](#topic-384-01)
  - [Bispline Under Tension Evaluation](#topic-386-01)
  - [Bivariate B-Spline Piecewise Polynomial Interpolation](#topic-388-01)
  - [Bivariate B-Spline Piecewise Polynomial Least Squares Fitting](#topic-389-01)
  - [Evaluation And Differentiation Of Bivariate Piecewise Polynomials From Their B-Spline Representations](#topic-391-01)
- [Surface Fitting over Arbitrarily Positioned Data Points](#category-392)
  - [Surface Interpolation For Arbitrarily Positioned Data Points](#topic-392-01)
- [Manifold Fitting](#category-395)
  - [Weighted Least Squares Fitting With Polynomials Of N Variables](#topic-395-01)
- [Numerical Integration](#category-398)
  - [Evaluation Of Integrals Over Finite Intervals](#topic-398-01)
  - [Evaluation of Integrals over Infinite Intervals](#topic-405-01)
  - [Evaluation Of Double Integrals Over Triangles](#topic-408-01)
- [Integral Equations](#category-410)
  - [Solution of Fredholm Integral Equations of the Second Kind](#topic-410-01)
- [Ordinary Differential Equations / Initial Value Problems](#category-413)
  - [The Initial Value Solvers - Introductory Comments](#topic-413-01)
  - [Adaptive Adams Solution Of Nonstiff Differential Equations](#topic-415-01)
  - [Adaptive Block RKF Solution Of Nonstiff Differential Equations](#topic-418-01)
  - [Adaptive RKF Solution Of Nonstiff Differential Equations](#topic-421-01)
  - [Adaptive RKF Solution Of Nonstiff Differential Equations With Global Error Estimation](#topic-424-01)
  - [Adaptive Solution Of Stiff Differential Equations](#topic-427-01)
  - [Fourth-Order Runge-Kutta](#topic-431-01)
  - [Eighth-Order Runge-Kutta](#topic-433-01)
- [Partial Differential Equations](#category-434)
  - [Separable Second-Order Elliptic Equations On Rectangular Domains](#topic-434-01)
- [Discrete Random Number Generation](#category-438)
  - [Uniform Random Selection of Values from a Finite Set of Integers](#topic-438-01)
- [Continuous Random Number Generation](#category-439)
  - [Uniform Random Number Generator](#topic-439-01)
  - [Generating Points Uniformly in a Square](#topic-440-01)
  - [Generating Points Uniformly In A Circle](#topic-441-01)
  - [Normal Random Number Generator](#topic-442-01)
  - [Multivariate Normal Random Vector Generator](#topic-444-01)
  - [Exponential Random Number Generator](#topic-447-01)
  - [Gamma Random Number Generator And The Chi-Square Distribution](#topic-449-01)
  - [Beta Random Number Generator](#topic-451-01)
  - [F-Distribution Random Number Generator](#topic-452-01)
  - [Student T-Distribution Random Number Generator](#topic-454-01)
  - [First Order Markov Random Number Generator](#topic-456-01)
- [Appendix: Installation and Precision Conversion](#category-458)
- [Routine index](#routine-index)

<a id="original-contents"></a>
## Original Printed Table of Contents

The original contents occupy PDF pages 5–14. The linked contents above are generated from the chapter and topic headings.

[Page 5](scans/page_0005.png) [Page 6](scans/page_0006.png) [Page 7](scans/page_0007.png) [Page 8](scans/page_0008.png) [Page 9](scans/page_0009.png) [Page 10](scans/page_0010.png) [Page 11](scans/page_0011.png) [Page 12](scans/page_0012.png) [Page 13](scans/page_0013.png) [Page 14](scans/page_0014.png)

<a id="foreword"></a>
## Foreword

In 1976 development of the NSWC library of general purpose numerical mathematics subroutines began. Since that time six editions of the library have been released for general use. This report describes the subroutines in the 1993 edition of the library, the seventh edition. The report supersedes NSWC TR 90-21 (1990). The development of the library is funded by the Computing Systems and Networks Division, Strategic and Space Systems Department, NSWCDD.

Approved by R. L. Schmidt, Head, Strategic and Space Systems Department.

*[View scanned foreword (PDF page 3)](scans/page_0003.png)*

<a id="abstract"></a>
## Abstract

The NSWC library is a library of general purpose Fortran subroutines that provide a basic computational capability for a variety of mathematical activities. Emphasis has been placed on the transportability of the codes. Subroutines are available in the following areas: elementary operations, geometry, special functions, polynomials, vectors, matrices, large dense systems of linear equations, banded matrices, sparse matrices, eigenvalues and eigenvectors, L1 solution of linear equations, least-squares solution of linear equations, optimization, transforms, approximation of functions, curve fitting, surface fitting, manifold fitting, numerical integration, integral equations, ordinary differential equations, partial differential equations, and random number generation.

*[View scanned abstract (PDF page 4)](scans/page_0004.png)*

<a id="category-015"></a>
## Introduction

<small>Original source: [View scanned PDF page 15](scans/page_0015.png) and
[page 16](scans/page_0016.png)</small>

Development of the NSWC library began in 1976 with the objective of providing
general-purpose Fortran subroutines for numerical mathematics. Although the
original target was the CDC 6000-7000 family, transportability was a major design
goal. The report describes the library's seventh edition (1993).

The 1993 library contains **more than 1,060 subroutines**, of which **576** are
covered in this report for general use; the others are primarily support routines.
Approximately 40 percent were developed at NSWCDD, with the remainder contributed
by governmental, academic, and other research institutions. The library contains
single- and double-precision implementations. The design target was 6-14
significant digits in single precision and 12-30 in double precision, depending
on the arithmetic available.

The library's stated criteria for accepting software were reliability,
transportability, efficiency, and ease of use. Algorithms and implementations
were reviewed and tested for numerical accuracy, robustness, and computational
efficiency. Routines could be modified or dropped as algorithms improved.

Portability required compliance with **ANSI Fortran 77**. Machine-dependent
constants and precision-dependent algorithms were unavoidable, but other
machine-dependent constructs were not permitted. `ENTRY` statements and global
variables were excluded. `EQUIVALENCE` and `COMMON` were permitted only with
strong reservations; values defined by `DATA` were not to be reassigned.

To give calling programs control over errors, the library avoided input/output
statements. A function reported errors by returning a special value, while a
subroutine was expected to report status through explicit arguments. Functions
were not supposed to modify their arguments. The published precision estimates
refer to the CDC 6000-7000 series' historical arithmetic and do not include
inherent errors of the mathematical functions being evaluated.

The report states that proprietary or otherwise restricted implementations were
not accepted, and that source code was made available to the scientific community.
This is a statement about the library's **historical distribution policy**, not
a determination of the modern copyright or software-license status of each routine.

<a id="category-017"></a>
## Elementary Operations

<small>Original source: [View scanned PDF page 17](scans/page_0017.png)</small>

<a id="topic-017-01"></a>
### Machine Constants

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `IPMPAR` | `INTEGER FUNCTION` | `I` | [`L1`](source_parts/nswc_part_01.f90#L1) |
| `SPMPAR` | `REAL FUNCTION` | `I` | [`L1237`](source_parts/nswc_part_01.f90#L1237) |
| `DPMPAR` | `DOUBLE PRECISION FUNCTION` | `I` | [`L1299`](source_parts/nswc_part_01.f90#L1299) |


For the integer arithmetic, let $a$ be the radix and $n$ the number of base-$a$
digits. The largest representable positive integer is $a^n-1$.

For floating-point arithmetic, let $b$ be the radix, $m$ the number of base-$b$
significand digits, and $e_{\min}$ and $e_{\max}$ the limiting normalized exponents.
The library represents nonzero floating-point values conceptually as

$$
\pm b^e \sum_{j=1}^{m} k_j b^{-j}, \qquad
1\leq k_1<b,\quad 0\leq k_j<b.
$$

The machine precision, smallest normalized positive magnitude, and largest finite
magnitude are, respectively,

$$
\epsilon=b^{1-m}, \qquad
x_{\min}=b^{e_{\min}-1}, \qquad
x_{\max}=b^{e_{\max}}(1-b^{-m}).
$$

`SPMPAR(I)` returns the corresponding constants for single precision and
`DPMPAR(I)` for double precision:

| `I` | Returned quantity |
|---:|---|
| 1 | Relative machine precision, $\epsilon$ |
| 2 | Smallest normalized positive magnitude, $x_{\min}$ |
| 3 | Largest finite positive magnitude, $x_{\max}$ |

The integer-valued function `IPMPAR(I)` exposes the arithmetic parameters:

| `I` | Quantity |
|---:|---|
| 1 | Integer radix $a$ |
| 2 | Integer digit count $n$ |
| 3 | Largest positive integer $a^n-1$ |
| 4 | Floating-point radix $b$ |
| 5 | Single-precision significand digits $m$ |
| 6 | Single-precision minimum exponent $e_{\min}$ |
| 7 | Single-precision maximum exponent $e_{\max}$ |
| 8 | Double-precision significand digits $m$ |
| 9 | Double-precision minimum exponent $e_{\min}$ |
| 10 | Double-precision maximum exponent $e_{\max}$ |

**Source configuration.** The recommended `nswc.f90` retains the IBM PC machine-constant
`DATA` statements activated. These are fixed numerical constants, **not** automatically
detected modern Fortran processor properties. Check `IPMPAR` when compiling for a
different arithmetic environment.

**Attribution.** `IPMPAR` is A. H. Morris's adaptation of `I1MACH` by
P. A. Fox, A. D. Hall, and N. L. Schryer. `SPMPAR` and `DPMPAR` are by A. H. Morris.

Original documentation: [page 17](scans/page_0017.png),
[page 18](scans/page_0018.png).


<a id="topic-019-01"></a>
### Argument Bounds for the Exponential Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EPSLN` | `REAL FUNCTION` | `L` | [`L1361`](source_parts/nswc_part_01.f90#L1361) |
| `DEPSLN` | `DOUBLE PRECISION FUNCTION` | `L` | [`L1394`](source_parts/nswc_part_01.f90#L1394) |
| `EXPARG` | `REAL FUNCTION` | `L` | [`L1428`](source_parts/nswc_part_01.f90#L1428) |
| `DXPARG` | `DOUBLE PRECISION FUNCTION` | `L` | [`L1470`](source_parts/nswc_part_01.f90#L1470) |


`EPSLN(L)` returns $\ln(\epsilon)$ for the single-precision arithmetic,
where $\epsilon=\texttt{SPMPAR(1)}$. `DEPSLN(L)` performs the corresponding
double-precision calculation using `DPMPAR(1)`. The argument `L` is ignored.

For the exponential functions, `EXPARG(L)` (single precision) and `DXPARG(L)`
(double precision) estimate argument bounds:

| Value of `L` | Result |
|---|---|
| `L == 0` | Largest positive argument for which `EXP` or `DEXP` can be evaluated without overflow |
| `L != 0` | Negative argument near the underflow limit for which the exponential remains nonzero |

These are **approximate safe bounds**, not values intended to represent an exact
IEEE-754 threshold. Both functions rely on the machine constants returned by
`IPMPAR`.

**Programming.** These four functions were written by A. H. Morris.

Original documentation: [page 19](scans/page_0019.png),
[page 20](scans/page_0020.png).


<a id="topic-021-01"></a>
### Sorting Lists

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ISHELL` | `SUBROUTINE` | `A, N` | [`L1513`](source_parts/nswc_part_01.f90#L1513) |
| `SHELL` | `SUBROUTINE` | `A, N` | [`L1562`](source_parts/nswc_part_01.f90#L1562) |
| `SHELL2` | `SUBROUTINE` | `A, B, N` | [`L1612`](source_parts/nswc_part_01.f90#L1612) |
| `RISORT` | `SUBROUTINE` | `A, M, N` | [`L1716`](source_parts/nswc_part_01.f90#L1716) |
| `DSORT` | `SUBROUTINE` | `A, N` | [`L1825`](source_parts/nswc_part_01.f90#L1825) |
| `DISORT` | `SUBROUTINE` | `A, M, N` | [`L1875`](source_parts/nswc_part_01.f90#L1875) |
| `DDSORT` | `SUBROUTINE` | `A, B, N` | [`L1930`](source_parts/nswc_part_01.f90#L1930) |
| `AORD` | `SUBROUTINE` | `A, N` | [`L1984`](source_parts/nswc_part_01.f90#L1984) |
| `DAORD` | `SUBROUTINE` | `A, N` | [`L2035`](source_parts/nswc_part_01.f90#L2035) |
| `QSORTI` | `SUBROUTINE` | `X, IND, N` | [`L2086`](source_parts/nswc_part_01.f90#L2086) |
| `QSORTR` | `SUBROUTINE` | `X, IND, N` | [`L2287`](source_parts/nswc_part_01.f90#L2287) |
| `QSORTD` | `SUBROUTINE` | `X, IND, N` | [`L2489`](source_parts/nswc_part_01.f90#L2489) |
| `IORDER` | `SUBROUTINE` | `A, IP, N` | [`L2692`](source_parts/nswc_part_01.f90#L2692) |
| `RORDER` | `SUBROUTINE` | `A, IP, N` | [`L2765`](source_parts/nswc_part_01.f90#L2765) |
| `DORDER` | `SUBROUTINE` | `A, IP, N` | [`L2840`](source_parts/nswc_part_01.f90#L2840) |


Let A be an array containing n > 1 elements aj, ...,a¢,. Then the following subroutines are available for reordering the elements of A.

```fortran
CALL ISHELL(A, N)
```

It is assumed that A is an integer array. When ISHELL is called, the elements of A are reordered so that a, < aj41 fort =1,...,n—1.

**Algorithm.** The Shell sorting algorithm with increments (3* — 1)/2 is employed. Programmer. A. H. Morris

**Reference.** Knuth, D. E., The Art of Computer Programming. Vol.3, Sorting and Searching. Addison-Wesley, Reading, Mass., 1973, pp. 84-95.

```fortran
CALL SHELL(A, N)
CALL AORD(A, N)
```

It is assumed that A is a real array. If SHELL is called, then the elements of A are reordered so that a; < a;4, for! = 1,...,n —1. Otherwise, if AORD is called, then the

elements of A are reordered so that |a,j < Jaj41| for f=1, ...,n-- 1.

**Programmer.** A. H. Morris CALL RISORT(A, L,n)

It is assumed that A is a real array and [ an integer array containing n elements. When RISORT is called, the elements of A are reordered so that a, < ay4; fort = 1,...,n — 1. The same permutations are performed on I as on A, thereby reordering the elements of L so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris CALL SHELL2(A, B,n)

It is assumed that A and B are real arrays containing n elements. When SHELL? is called, the elements of A are reordered so that a; < a,;,4, for # = 1,...,n ~— 1. The same permutations are performed on B as on A, thereby reordering the elements of B so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris

```fortran
CALL DSORT(A, N)
CALL DAORD(A, N)
```


<small>Original source: [View scanned PDF page 22](scans/page_0022.png)</small>

It is assumed that A is a double precision array. If DSORT is called, then the elements of A are reordered so that a; < aj4, fort = 1, ..,n — 1. Otherwise, if DAORD is called, then the elements of A are reordered so that |a,{ < jas41| for? =1,...,n~ 1.

**Programmer.** A. H. Morris CALL DISORT(A, L, )

It is assumed that A is a double precision array and ZL an integer array containing n elements. When DISORT is called, the elements of A are reordered go that a; < a4, for t= 1,...,2—1. The same permutations are performed on L as on A, thereby reordering the elements of LE so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris CALL DDSORT(A, B,n)

It is assumed that A and B are double precision arrays containing n elements. When DDSORT is called, the elements of A are reordered so that a; < a,4, for f =1,...,n—1. The same permutations are performed on B as on A, thereby reordering the elements of B so as to correspond with the new ordering of A.

**Programmer.** A. H. Morris

```fortran
CALL QSORTI(X, IND, N)
CALL QSORTR(X, IND, N)
CALL QSORTD(X, IND, N)
```

QSORTI is used if A is an integer array, QSORTR is used if A is a real array, and QSORTD is used if A is a double precision array. It is assumed that n < 2097152 and that Lis an integer array of dimension n or larger. When the subroutine is called, the indices t1,...,% are stored in L where a, < ++: < a;,. A is not modified by the routine.

**Remarks.**

(1) After L has been obtained, A may be reordered so that a; < a;4, ford =i, ..,n-1 by IORDER, RORDER, or DORDER (see below).

(2) QSORTI, QSORTR, and QSORTD employ a quick sort procedure. These routines frequently take less than half the time required by the corresponding subroutines ISHELL, SHELL, and DSORT, which use a SHELL sort procedure.

**Programmer.** Robert Renka (Oak Ridge National Laboratory).

```fortran
CALL IORDER(A, IP, N)
```

```fortran
CALL RORDER(A, IP, N)
CALL DORDER(A, IP, N)
```

tORDER is used if A is an integer array, RORDER is used if A is a real array, and DORDER is used if A is a double precision array. © is an integer array containing a


<small>Original source: [View scanned PDF page 23](scans/page_0023.png)</small>

permutation #1,...,%, of 1,...,n. If A initially contains a),...,a, then A contains the reordered sequence a;,,... ,a;, when the subroutine terminates.

Programmers. Robert Renka (Oak Ridge National Laboratory).


<small>Original source: [View scanned PDF page 24](scans/page_0024.png)</small>

<a id="topic-024-01"></a>
### Cube Root

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBRT` | `REAL FUNCTION` | `X` | [`L2915`](source_parts/nswc_part_01.f90#L2915) |
| `DCBRT` | `DOUBLE PRECISION FUNCTION` | `X` | [`L2935`](source_parts/nswc_part_01.f90#L2935) |


The following functions are available for computing the real cube root of a real number.

CBRT(z) DCBRT(z)

CBRT is used if x is a single precision number, and DCBRT is used if x is a double precision number. CBRT is a single precision function and DCBRT a double precision function. The value of the function is ~/z.

**Remark.** DCBRT must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** A. H. Morris

<a id="topic-024-02"></a>
### Four-Quadrant Arctangent

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ARTNQ` | `FUNCTION` | `Y, X` | [`L2956`](source_parts/nswc_part_01.f90#L2956) |
| `DARTNQ` | `DOUBLE PRECISION FUNCTION` | `Y, X` | [`L2986`](source_parts/nswc_part_01.f90#L2986) |


The function ARTNQ is similar to the ATAN2 function, the differences being that its value lies in the interval (0,27) and its value at the origin is 0. DARTNQ is the double precision counterpart of ARTNQ.

ARTNQ(y, z) DARTNQ(y, z)

ARTNQ is used if x and y are single precision values, and DARTNQ is used if x and y are double precision values. ARTNQ is a single precision function and DARTNQ is a double precision function.

if (z,y) is a point in the plane other than the origin (0,0), let L denote the straight line connecting the points (0,0) and (z,y). Then the function is assigned the value @ where 9 is the angle between L and the positive x-axis measured in a counterclockwise direction. Here 0 < 6 < 2. Otherwise, if (x,y) is the origin (0,0), then the function is assigned the value 0.

**Remark.** DARTNQ must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** Richard Pasto

<a id="topic-024-03"></a>
### Length Of A Two Dimensional Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPABS` | `REAL FUNCTION` | `X, Y` | [`L3015`](source_parts/nswc_part_01.f90#L3015) |
| `DCPABS` | `DOUBLE PRECISION FUNCTION` | `X, Y` | [`L3033`](source_parts/nswc_part_01.f90#L3033) |


The following functions are available for computing the length of a real vector (2, y).

CPABS(r, y) DCPABS (zs, y)


<small>Original source: [View scanned PDF page 25](scans/page_0025.png)</small>

CPABS is used if x and y are single precision values, and DCPABS is used if a and y are double precision values. CPABS is a single precision function and DCPABS is a double precision function. The value of the function is fx? + y?.

**Remark.** DCPABS must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** A. H. Morris


<small>Original source: [View scanned PDF page 26](scans/page_0026.png)</small>

<a id="topic-026-01"></a>
### Reciprocal Of A Complex Number

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CREC` | `SUBROUTINE` | `X, Y, U, V` | [`L3052`](source_parts/nswc_part_01.f90#L3052) |
| `DCREC` | `SUBROUTINE` | `X, Y, U, V` | [`L3072`](source_parts/nswc_part_01.f90#L3072) |


The following subroutines are available for computing the reciprocal of a complex number.

```fortran
CALL CREC(X, Y, U, V)
CALL DCREC(X, Y, U, V)
```

CREC is used if x and + are single precision real numbers and u and v real variables, and DCREC is used if x and y are double precision numbers and u and v double precision variables. It is assumed that x and y are the real and imaginary parts of a nonzero complex number z. When CR&C or DCREC is called, u and v are set to the real and imaginary parts of 1/z, respectively.

**Programmer.** A. H. Morris

<a id="topic-026-02"></a>
### Division Of Complex Numbers

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CDIV` | `COMPLEX FUNCTION` | `A, B` | [`L3093`](source_parts/nswc_part_01.f90#L3093) |
| `CDIVID` | `SUBROUTINE` | `AR, AI, BR, BI, CR, CI` | [`L3120`](source_parts/nswc_part_01.f90#L3120) |


The function CDIV and subroutine CDIVID ave available for dividing complex numbers.

CDIV(a, b) CDIV(a, 6) =: a/b for any complex numbers a and b where 6 7 6.

**Remark.** CDIV must. be declared in the calling program: to be of type COMPLEX.

**Programmer.** A. H. Morris. CALL CDIVID(a,, az, 6), 52, u,v)

The arguments 2,,@2,6,,0) are double precision numbers, and u and v are double precision variables, It is assumed that a, and ag are the real and imaginary parts of a complex number a, and that 6; and 6) are the real and imaginary parts of a nonzero complex number 6 When CDIVID is called, u and v are set to the real and imaginary parts of a/b respectively.

**Programmer.** A. HI. Morris.

<a id="topic-026-03"></a>
### Square Root Of A Double Precision Complex Number

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DCSQRT` | `SUBROUTINE` | `Z, W` | [`L3160`](source_parts/nswc_part_01.f90#L3160) |


The following subroutine ts available for computing the square root of a double precision

complex number.

```fortran
CALL DCSQRT(Z, W)
```


<small>Original source: [View scanned PDF page 27](scans/page_0027.png)</small>

Z and W are double precision arrays of dimension 2. It is assumed that Z(1) and Z(2) are the real and imaginary parts of a complex number z. When DCSQRT is called, if z = 0 then W(1) and W(2) are set to 0. Otherwise, if z 4 O then the square root w = \/z where -~x/2< arg(w) < 1/2 is computed and stored in W. W(1) and W(2) contain the real and imaginary parts of w, respectively.

**Note.** Z and W may reference the same storage area.

**Programming.** DCSQRT calls the function DCPABS. DCSQRT was written by A. H. Morris.


<small>Original source: [View scanned PDF page 28](scans/page_0028.png)</small>

<a id="topic-028-01"></a>
### Conversion Of Polar To Cartesian Coordinates

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `POCA` | `SUBROUTINE` | `R, A, X, Y` | [`L3218`](source_parts/nswc_part_01.f90#L3218) |


The following subroutine is available for converting polar coordinates {r, @) to cartesian coordinates (2, y).

```fortran
CALL POCA(R, A, X, Y)
```

Let (r,@) be the polar coordinates of a point in the plane and let +,y be variables. When the routine is called, x and y are assigned the values x = r cos @ and y = rsin @.

<a id="topic-028-02"></a>
### Conversion Of Cartesian To Polar Coordinates

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CAPO` | `SUBROUTINE` | `X, Y, R, THETA` | [`L3226`](source_parts/nswc_part_01.f90#L3226) |


The following subroutine is available for converting cartesian coordinates (zx, y) to polar coordinates (r, 8).

```fortran
CALL CAPO(X, Y, R, THETA)
```

Let (z,y) be the cartesian coordinates of a point in the plane and lei r,@ be variables. If (z, y) is the origin then CAPO sets r = 0 = G. Otherwise, if (z,y) is a point other than the origin, let L denote the straight line connecting the points (0,C) and (x,y). Then when

CAPO is called, r is assigned the value \/2? + y? and @ is defined to be the angle between L and the positive x axis. Here -w <0 < 7m.

<a id="topic-028-03"></a>
### Rotation Of Axes

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ROTA` | `SUBROUTINE` | `X1, Y1, A, X2, Y2` | [`L3245`](source_parts/nswc_part_01.f90#L3245) |


Let (r1,y1) be the (cartesian) coordinates for a point in the plane. The following subroutine computes the new coordinates (z2,y2) for the point after the z,y axes have been rotated py an angle @.

```fortran
CALL ROTA(X1, Y1, A, X2, Y2)
```

The arguments z2 and y are variables. When ROTA is called, x2 and yo are assigned the values:

Lo = Ly cos 6 + yy sin 9

yo <= ~2, sin 8+ y; cos 9

**Programmer.** A. I. Morris.

we in


<small>Original source: [View scanned PDF page 29](scans/page_0029.png)</small>

<a id="topic-029-01"></a>
### Planar Givens Rotations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SROTG` | `SUBROUTINE` | `SA, SB, SC, SS` | [`L3258`](source_parts/nswc_part_01.f90#L3258) |
| `DROTG` | `SUBROUTINE` | `DA, DB, DC, DS` | [`L3333`](source_parts/nswc_part_01.f90#L3333) |


If a and 6 are real numbers where a? + b? # 0, then there is an orthogonal matrix

(_§ 8) such that ($$) (2) = (J). tm this case #? = a2 + 08,¢ = a/r, and 9 = b/r

The matrix ( ° °) represents what is called a Givens rotation. Given a and b, the matrix is uniquely defined up to the sign of r, For any real a, let sgn(a) = 1 if a > 0 and sgn(a) = ~1 if a< 0. If we define r = oVa? + b? where

_ { sgn(a) if {a| > |6|

~ [sgnfd) if jal < (|

then for r # O we note that |c| > |s| implies ¢ > 0, and that |c| < |s| implies s > 0. For convenience, when r — 0 we set c= 1 ands =0.

The value o is not needed for the construction of a Givens rotation matrix, but its use permits the representation of c and s by a single value z. For each c and ge, z is defined as

follows: ={3 if |s] <core=0

Ife O<|el<s

The mapping (c,s) + z is 1-1. If the user wishes to reconstruct c and s from z, then this can be done as follows:

```text
If z = 1 then set c = O and s = 1.
If |z| < 1 then set c= V1 — 2? and s = z.
If |z| > 1 then set, ¢ = 1/z and s = V1 — c?.
```

The subroutines SROTG and DROTG are available for computing c,s,r, and z. SROTG is used when a and 0 are single precision real numbers, and DROTG is used when a and b are double precision numbers.

```fortran
CALL SROTG(SA, SB, SC, SS)
CALL DROTG(DA, DB, DC, DS)
```

When SROTG is used then AR, BZ, C, and S are real variables. Otherwise, when DROTG is used then AR, BZ, C, and S are double precision variables. On input, AR = a and BZ = 6. When the routine terminates AR -: r, BZ = z,C = c,and S = s.

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F.'T. Krogh. SROTG and DROTG were written by Charles Lawson (Jet Propulsion Laboratory).


<small>Original source: [View scanned PDF page 30](scans/page_0030.png)</small>

<a id="topic-030-01"></a>
### Three-Dimensional Rotations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ROT3` | `SUBROUTINE` | `A, THETA` | [`L3408`](source_parts/nswc_part_01.f90#L3408) |


if A = (a,;) is a 3 x 3 orthogonal matrix, then A can be represented in the form

1 0 0 cos 82 O --sin 82\ Ry = (0 cos 6; sin a) Ra = ( 0 1 0

0 sin A, cos 8, sin 02 QO cos 6

cos 9, --sin @3 0 1 0 90 R3= (s= 63 cos O3 0) R= (0 1 oO ), 0 6) 1 0 0 +1/

R, represents a rotation around the z-axis, R2 a rotation around the y-axis, and R3 a rotation around the z-axis. Since A is orthogonal the determinant det(A) == +1. If det(A} = 1 then EF is the identity matrix and A is the combined rotation Rs R,R, . If dei(A) = -1 then A is composed of the rotation R3R,R, and the reflection E = diag(1,1,-1). The following subroutine is available for finding the angles 61,82,43 where —+ < 6; < m,|82| < n/2,and —w < 03 <n.

```fortran
CALL ROT3(A, THETA)
```

THETA is an array of dimension 3 or larger. When ROTS3 is called, the angles 6, 92,43 are computed and stored in THETA.

**Algorithm.** If ai; = a2, = 0 then let 03 = 0. Otherwise, let 0, = ATAN2(d21,@11). Then Tr Gi, 43 R3A= {| 0 a), agg | = A’ 431 432 433 where ry = Va? + a3,. Also, if 02 = ATAN2(ag1.1r1) then ro ay, ai!s R} A’ = 0 Abo A435 =: Al O ay_ a5.

```text
where rz = \/r?-+ a2,. Since rz > 0, by orthogonality it follows that rz = 1 and aff, >
ay, = O. Finally, if 6; = ATAN2(ag,, a4.) then
```

10 0 RYAY = (0 r3 Ay 0 0 ag,

where rg - \/(a5,)? 1 (a4,)?. Since rz > 0, by orthogonality we obtain rg 1, af, — 0,

and ay, tl.

**Programmer.** A. H. Morris


<small>Original source: [View scanned PDF page 31](scans/page_0031.png)</small>

<a id="topic-031-01"></a>
### Rotation of a Point on the Unit Sphere to the North Pole

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CONSTR` | `SUBROUTINE` | `XK, YK, ZK, CX, SX, CY, SY` | [`L3450`](source_parts/nswc_part_01.f90#L3450) |


Given the point (x,y,z) where z? -+y? 42? = 1. Then there exist orthogonal matrices 1 0 0 cy 0 ~8, a= (6 Cy -s.] man = (4 i oO QO 8s, ey sy 0 fe

x 0)

such that Ry Rz ( | = (0) . R, represents a rotation about the z-axis and R, a rotation 1?

about the y-axis. The following subroutine is available for obtaining the values c,., 82,

Cy, Sy. CALL CONSTR(z, y, z,CX,SX,CY,SY) CX,SX,CY,SY are variables. When CONSTR is called, these variables are assigned

the values cz, 81,Cy, Sy.

**Programmer.** Robert J. Renka (Oak Ridge National Laboratory)


<small>Original source: [View scanned PDF page 32](scans/page_0032.png)</small>

<a id="topic-032-01"></a>
### Computation Of The Angle Between Two Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ANG` | `REAL FUNCTION` | `N, X, Y` | [`L3497`](source_parts/nswc_part_01.f90#L3497) |


Given the points z = (r1, ...,2,) and y= (yi, ..., yn) where n > 2,40, andy 40. Let L, denote the straight line connecting 0 and x, and L, the straight line connecting 0 and y. Then the function ANG is available for computing the angle ¢ between the two lines Lz, and Ly.

```fortran
ANG(N, X, Y)
```

X and ¥ are arrays of dimension n containing 21, ...,%, and yi, ..., yn. ANG(n, X,Y) = @whereOQ< <a,

**Error Return.** ANG(n, X,Y) = —-lifn < 2,2=0, ory =0.

**Programming.** ANG employs the function SNRM2. ANG was written by A. H. Morris.


<small>Original source: [View scanned PDF page 33](scans/page_0033.png)</small>

<a id="topic-033-01"></a>
### Trigonometric Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SIN1` | `REAL FUNCTION` | `X` | [`L3580`](source_parts/nswc_part_01.f90#L3580) |
| `COS1` | `REAL FUNCTION` | `X` | [`L3647`](source_parts/nswc_part_01.f90#L3647) |
| `DSIN1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L3714`](source_parts/nswc_part_01.f90#L3714) |
| `DCOS1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L3812`](source_parts/nswc_part_01.f90#L3812) |


The following functions are available for computing sin xz and cos wz for real ‘x. SIN1(z) SIN1{z) = sin wa for all real z. Algorithm. Minimax approximations are used for sinaz and cos mz when |a2| < 1/4. Precision. SIN1(z) is accurate to within 1 unit of the 14" significant digit when 0 < z < 1. Programming. SIN1 was written by A.H. Morris. The function IPMPAR is used. COS1(z) COS1(z) = cos wz for all real z. Algorithm. Minimax approximations are used for sinaz and cosmz when |x| < 1/4.

**Precision.** COS1(x) is accurate to within L unit of the 14° significant digit when 0 < x < 1 and x # 1/2.

**Programming.** COS1 was written by A. H. Morris. The function IPMPAR is used.

```fortran
DSIN1(X)
```

The argument z is a double precision number. DSIN1(z) is the double precision value for sin az.

**Remark.** DSIN1 must be declared to be of type DOUBLE PRECISION in the calling program.

**Algorithm.** For |z| < «/4, sin wx and cos wz are computed by the power series corresponding ta the Chebyshev expansions developed by J. L. Schonfelder (University of Birmingham, England). The power series were obtained by A. H. Morris.

**Precision.** DSIN1(z) is accurate to within | unit of the 28" significant digit when 0 < x < 1.

**Reference.** Schonfelder, J.L.,“Very High Accuracy Chebyshev Expansions for the Basic Trigonometric Functions,” Math Comp. 3-4 (1980), pp. 237-244.

**Programming.** DSIN1i was written by A.H. Morris. The function IPMPAR is used. DCOS1(z)

The argument x is a double precision number. DCOS1(z) is the double precision value

for cos mx.

the 1


<small>Original source: [View scanned PDF page 34](scans/page_0034.png)</small>

**Remark.** DCOS1 must be declared to be of type DOUBLE PRECISION in the calling program.

Algorithm. For |z| < 7/4, sin wz and cos wz are computed by the power series corresponding to the Chebyshev expansions developed by J. L. Schonfelder (University of Birmingham, England). The power series were obtained by A. H. Morris.

**Precision.** DCOS1(z) is accurate to within 1 unit of the 28°” significant digit when 0 < z<landz#1/2.

**References.** Schonfelder, J.L.,.“Very High Accuracy Chebyshev Expansions for the Basic Trigonometric Functions,” Math Comp. 34 (1980), pp. 237-244.

**Programming.** DCOS1 was written by A. H. Morris. The function IPMPAR is used.


<small>Original source: [View scanned PDF page 35](scans/page_0035.png)</small>

<a id="topic-035-01"></a>
### Hyperbolic Sine And Cosine Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SNHCSH` | `SUBROUTINE` | `SINHM, COSHM, X, ISW` | [`L3910`](source_parts/nswc_part_01.f90#L3910) |


The following subroutine is available for computing sinh(z) — z, cosh(z) — 1, and cosh(z) — 1 — x? /2 for real z.

```fortran
CALL SNHCSH(SINHM, COSHM, X, ISW)
```

```text
S and C are variables, and IND is an input argument which specifies the functions to
be computed. IND takes the values:
IND = ~1 if only sinh(z) — z is desired.
IND = 0 if sinh(x) -- x and cosh(z) — 1 are desired.
IND = 1 if only cosh(z) — 1 is desired.
IND = 2 if only cosh(z) — 1 — z?/2 is desired.
IND = 3 if sinh(x) - z and cosh(z) ~ 1 — 2?/2 are desired.
S is assigned the value sinh(z) — x if this function is requested. When cosh(x) — 1 or
cosh(z) — 1 - x?/2 is computed then the value is stored in C.
```

**Precision.** For all z, sinh(x) — x has a relative error less than 2.3E-14, cosh(z) — 1 has a relative error less than 2.2E-14, and cosh(z) — 1— 27/2 has a relative error less than 3.8E-14.

**Programming.** Written by A. K. Cline and R. J. Renka (University of Texas at Austin). Modified by A. H. Morris.


<small>Original source: [View scanned PDF page 36](scans/page_0036.png)</small>

<a id="topic-036-01"></a>
### Exponentials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `REXP` | `REAL FUNCTION` | `X` | [`L4065`](source_parts/nswc_part_01.f90#L4065) |
| `DREXP` | `DOUBLE PRECISION FUNCTION` | `X` | [`L4094`](source_parts/nswc_part_01.f90#L4094) |


The following functions compute $e^x-1$, including for arguments near zero,
where directly subtracting one from the exponential can lose significant digits.

```fortran
REXP(X)
DREXP(X)
```

`REXP` returns a single-precision value for real `X`.
`DREXP` returns the double-precision counterpart and must be declared
`DOUBLE PRECISION` in traditional Fortran calling code.

**Reference.** A. R. DiDonato and A. H. Morris, "Computation of the Incomplete
Gamma Function Ratios and Their Inverse," *ACM Transactions on Mathematical
Software* **12** (1986), 377-393.

**Programming.** A. H. Morris. Original documentation:
[page 36](scans/page_0036.png).


<a id="topic-037-01"></a>
### Logarithms

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ALNREL` | `REAL FUNCTION` | `A` | [`L4250`](source_parts/nswc_part_01.f90#L4250) |
| `DLNREL` | `DOUBLE PRECISION FUNCTION` | `A` | [`L4277`](source_parts/nswc_part_01.f90#L4277) |
| `RLOG` | `REAL FUNCTION` | `X` | [`L4327`](source_parts/nswc_part_01.f90#L4327) |
| `RLOG1` | `REAL FUNCTION` | `X` | [`L4380`](source_parts/nswc_part_01.f90#L4380) |
| `DRLOG` | `DOUBLE PRECISION FUNCTION` | `X` | [`L4433`](source_parts/nswc_part_01.f90#L4433) |
| `DRLOG1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L4510`](source_parts/nswc_part_01.f90#L4510) |


The functions ALNREL, RLOG, RLOG1, DLNREL, DRLOG, and DRLOG1 are available for computing In(1 + a), z — 1 — In(z), and a — In(1+ a). DLNREL, DRLOG, and DRLOG1 are double precision functions.

ALNREL(a) ALNREL(a) = In(1 + a) for a > -1. Algorithm. See page 378 and appendix A of the reference.

**Precision.** ALNREL(a) is accurate to within 2 units of the 14" significant digit when ALNREL(a) 4 0.

**Reference.** DiDonato, A. R., and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

**Programmer.** A. H. Morris. CLOG (zx) RLOG(x) == 2 -- 1 -- In(z) for x > 0. Algorithm. See page 379 and appendix E of the reference.

**Precision.** RLOG(s) is accurate to within 2 units of the 14'* significant digit when RLOG(z) 54 0.

**Reference.** DiDonato, A. R., and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 877-383.

**Programmer.** A. H. Morris. RLOG1(a) RLOG1(a) = a In(t ¢ a) fora> © 1. Algorithm. See page 379 and appendix B of the reference.

Precision, RLOG1(a) is accurate to within 2 units of the 14" significant digit: when RLOG1{a) #4 0

**Reference.** DiDonato, A. BR, and Morris, A. H., “Computation of the incomplete Gamma Function Ratios and Their Inverse,” ACM Trans, Math Software 12 (1986), pp. 377 U3.

Programmer. A. H. Morris.


<small>Original source: [View scanned PDF page 38](scans/page_0038.png)</small>

```fortran
DLNREL(A)
```

The argument a is a double precision number where a > —1. DLNREL(a) is the double precision value for In(1 + a).

**Remark.** DLNREL must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DLNREL(a) is accurate to within 1 unit of the 28" significant digit when DLNREL(e) # 0.

**Programmer.** A. H. Morris.

```fortran
DRLOG(X)
```

The argument z is a positive double precision number. DRLOG(z) is the double precision value for z -- 1 — In(z).

**Remark.** DRLOG must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DRLOG(z) is accurate to within 1 unit of the 28" significant digit when DRLOG(z) #0.

**Programmer.** A. H. Morris. DRLOG1(a)

The argument a is a double precision number a > —i. DRLOG1(a) is the double precision value for a ~ In(1-+ a).

**Remark.** DRLOG1 must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DRLOG1(a) is accurate to within i unit of the 28 significant digit when DRLOG1(a) 7 0.

**Programmer.** A. H. Morris.


<a id="category-039"></a>
## Geometry

<small>Original source: [View scanned PDF page 39](scans/page_0039.png)</small>

<a id="topic-039-01"></a>
### Determining if a Point Is Inside or Outside a Polygon

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [`L4587`](source_parts/nswc_part_01.f90#L4587) |


Given a sequence cf points »; = (v4, ys) (§ = 1,...,n). Let 7 denote the polygonal line which begins at point 1, traverses the points »; in the order that they are indexed, and is the straight line segment connecting 4, to u%41 for each ¢ = 1,...,n ~ 1. It is assumed that v, = v,, or that there is also a straight line segment from v, to vy when vy, F V4. Consequently, the polygonal path 7 is a loop beginning and ending at 11.

For any point vo = (x0, yo) not on the path 1, let n(7r, vo) denote the winding number of the path 7 around the point vp. Then n(7,v0) = 0 if vo is outside the polygon whose boundary is r. If vo is inside the path then n(r, v9) = m where m is an integer. If m > 0 then the path r loops m times in a counterclockwise direction around the point vp. Otherwise, if m < 0 then ¢ loops |m| times in a clockwise direction around vp.

Given an arbitrary point vo = (Zo, yo), the following subroutine is available for determining whether vo is on the path, outside the path, or inside the path. If the point vo is inside r then the winding number n(7,v0) = m is also computed.

```fortran
CALL LOCPT(X0, Y0, X, Y, N, L, M)
```

It is assumed that n > 1. X and Y are arrays containing z, ...,2n and y1,...,Yn- The arguments @ and m are variables. When LOCPT terminates @ has one of the following values:

€== ~1 if (zo, yo) is outside the path

£= 0 if (ro, yo) lies on the path

€= 1 if (ro, yo) is inside the path The variable m is assigned the value 0 if (zo, yo) is on or outside the path. If (ao, yo) is inside the path then m = the winding number of the path 7 around the point (zo, yo).

**Remark.** There are no restrictions on the points (z,,y,). Consequently, the path may intersect itself.

**Programming.** ‘The function SPMPAR is used. LOCPT was written by A Ht. Morris.


<small>Original source: [View scanned PDF page 40](scans/page_0040.png)</small>

<a id="topic-040-01"></a>
### Intersection of a Straight Line and Polygonal Path

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [`L4676`](source_parts/nswc_part_01.f90#L4676) |


Given a sequence of points vy; = (2,,y;) (¢ = 1, ...,n). Let r denote the polygonal path which begins at point v,, traverses the points v,; in the order that they are indexed, and is the straight line segment from 4% to ¥;41 for each t = 1,...,2—1. Also consider a straight line 2 connecting two points (a1, a2) and (b;,62). If @ and r intersect at a finite number of points, then the following subroutine is available for obtaining the intersecting points.

```fortran
CALL PFIND(A, B, X, Y, N, U, V, M, NUM, IERR)
```

The arguments a and 6 are arrays of dimension 2 containing the points (a,,a2) and (61,62). It is assumed that a 4 b and n > 2. X and Y are arrays containing 2), ...,2, and Yl, +++) Yn respectively.

The argument m is the estimated maximum number of points at which the line @ and path + may intersect (m <n). U and V are arrays of dimension m or larger, and k and IERR are variables. When PFIND is called, if no input errors are detected then IERR 1< set to 0, k = the number of points (u,,v,;) where the line @ and path r intersect, and U and V contain the abscissas u;, ..., ug and ordinates vt), ...,v,% of these points. The points (u,,v;) are listed in the order that the path intersects € when proceeding from (21,41) to

(ln Yn):

**Error Return.** If an input error is detected than IERR has one of the following values:

TieRR =: 1 Either a:- 6 or the path contains a single point. 8 HWeRR > 2 U and V require more storage. The argument m must be increased. IERR of The ¢! line segment of the path contains a segment of the line @. & When an error is detected, & the number of points (u,,v,} found where the line @ and ] I Jj? a)

path 7 intersect, and U and V contain the abscissas and ordinates of these points.

**Remark.** The intersecting points (u,,v,) need not be distinct. The path may intersect @ at the same point a number of times when proceeding from (11, yi) to (7, yn).

**Programming.** PFIND was written by A. H. Morris, The function SPMPAR ts used,


<small>Original source: [View scanned PDF page 41](scans/page_0041.png)</small>

<a id="topic-041-01"></a>
### The Convex Hull for a Finite Planar Set

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [`L4848`](source_parts/nswc_part_01.f90#L4848) |


If (z1, 41), ..., (2m, ym) are m distinct points in the plane, then the following subroutine is available for finding the smallest convex polygon which with its interior contains the

points. CALL HULL(X,Y,m, BX,BY,k, VX,VY,n)

It is assumed that m > 2. X and ¥ are arrays containing the abscissas 11, ...,2m and ordinates y1,...,Ym, respectively. When HULL is called the points are reordered so that Yi S++ Sym. Thus A and Y may be modified when the routine terminates.

RX and BY are arrays of dimension m+ 1 or larger, and k is @ variable. When HULL terminates, BX and BY contain the abscissas and ordinates of the points (2,,y,) which lie on the boundary of the desired convex polygon, and k = the number of points stored in BX and BY. If BX and BY contain the abscissas x}, ..., 2), and ordinates yj,. , y,, then the points (2, y;' are indexed in the order they occur when traversing the boundary in a counterclockwise manner. Also (x1, y,) = (24, y4)-

VX% and VY are arrays of dimension m~-'- 1 or larger, and n is a variable. When HULL terminates, VX and VY contain the abscissas and ordinates of the vertices of the desired convex polygon, and n = the number of points stored in VX and VY. If VX and VY contain the abscissas x, ...,¢/1 and ordinates y/, ...,y/’, then the vertices (2/’, yi’) are indexed in the order they occur when traversing the boundary of the convex polygon in a

counterclockwise manner. Also (2!, yl!) == (ci, yy’).

**Example.** Assume that we are given the points (-—1,-3), (1,1) (0,3), (2,2), (-2,4), (-1,~1). When HULi 13 called X and Y are reordered and we obtain: X contains —1,--1,1,2,0, --2 Y contains —3,-1,1,2,2 BX contains —1,2,0,—2,-1 BY contains —3,2,3,4,--3 V¥ contains -1,2,-2,~-1 VY contains --3,2,4,--3

**Programming.** HULL calls the subroutine RRSORT and function SPMPAR. HULL was written by A. H. Morris.


<small>Original source: [View scanned PDF page 42](scans/page_0042.png)</small>

<a id="topic-042-01"></a>
### Areas Of Planar Polygons

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [`L5251`](source_parts/nswc_part_01.f90#L5251) |


Given a sequence of points v; = (2, y;) (§ = 1,...,2+ 1) where n > 1 and ung) = 01. Let + denote the polygon whose boundary Or is a polygonal line which begins at point v1, traverses the points vy, in the order that they are indexed, and is the straight line segment connecting v; to u,41 fort = 1, ...,n. Then the function PAREA is available for computing A(r) = ff, dxdy. If the boundary @r is a positively (negatively) oriented simple closed curve, then A(r) is positive (negative) and |A(r)| = the ares. of r. However, Or need not be simple. It may be self-intersecting or have overlapping line segments.

```fortran
PAREA(X, Y, NB)
```

X and Y are arrays containing the abscissas r,,. ry and ordinates y1,...,yN, respectively. The argument N may have the value n or n+ 1. Since ta4, = v1, %,41 and Yn+14 are not required to appear in X and Y. PAREA(X,Y, N) is assigned the value A(r).

**Programmer.** A. H. Morris Reference. DiDonato, A. R. and Hageman, R. K., Computation of the Integral of the Bi-

variate Normal Distribution over Arbitrary Polygons, report TR 80-166, Naval Surface Weapons Center, Dahlgren, Virginia, 1980.


<small>Original source: [View scanned PDF page 43](scans/page_0043.png)</small>

<a id="topic-043-01"></a>
### Hamiltonian Circuits

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [`L5291`](source_parts/nswc_part_01.f90#L5291) |


Given a directed graph G containing n vertices, denoted by the integers 1, ...,n. Then any circuit of n arcs which traverses the n vertices, say in the order 1), ...,%,, is called a Hamiltonian circuit. For convenience, it is assumed that for any two vertices ¢ and 7, no more than one arc exists which begins ai ¢ and ends at 7. Then the following subroutine is available for finding the Hamiltonian circuits of G, if any exist.

```fortran
CALL H&(IND, m,n, P, A, NB, S, IWK,NUM)
```

The argument m is the number of arcs in the graph G. P is an integer array of dimension n +1 and A an integer array of dimension m. The graph is stored in P and A as follows: For 1 = i, ...,n let

R,; = {j: there exists an arc which begins at ¢ and ends at 7}.

Then the vertices in R,,...,&, are stored in 4, where the data in R,; precedes the data in Ryy. fort = 1,...,2- 1. For each ¢, the vertices in R; may be given in any order in A. The array P contains the data

```text
P(1) =0
P(t +1) = the total number of vertices in Ri, ..., Rj (f= 1,...,n).
```

Hence, if P(s) < P(t¢+1) then the vertices in R,; are found in locations P(t)+1,..., P{t+1) of A. Otherwise, if P(t) = P(i+ 1) then R; = ¢ (the empty set); ie., there are no arcs in G which begin at ¢ (and no Hamiltonian circuits exist). Also, ?(n-+ 1) = m since there are m arcs in G.

Example. Consider the graph where m=5,n=4 Ry = {2,4} hg = ¢ Ro. = 1,3} Ay = {3}. Then A contains 4,2,1,3,3 P contains 0,2,4,4,5.

When HC is called, a depth-first tree search employing backtracking is used. NB is a variable for controlling the backtracking. If NB > 0 on input, then it is assumed that NB is the maximum number of backtracks that may be performed to find a Hamiltonian circuit. Otherwise, if NB < 0 then it is assumed that no restriction 1s placed on the backtracking. When HC terminates, NB =: the number of backtracks that were actually performed.

Sis an integer array of dimension n. When HC is called, if a Hamiltonian circuit is found which traverses the vertices, say in the order t,,...,4,,, then the ordered vertices ty,..-,%, are stored in S,

IWE is an array of dimension NUM that is w work space for the routine. Lbs assured that NUM > m+ 8n 4 20.


<small>Original source: [View scanned PDF page 44](scans/page_0044.png)</small>

Only one Hamiltonian circuit will be obtained on a call to HC. However, this routine can be repeatedly called to obtain all the Hamiltonian circuits. IND is a variable which controls the operation of the routine on input, and reports the status of the results on output. It is assumed that IND = 0 on the first cal! to HC. When the routine terminates, if no input errors are detected then IND has one of the following values:

IND = t A Hamiltonian circuit was found and the ordered vertices traversed by the circuit stored in S. To find another circuit, reset NB and recall the routine.

IND = 2 The maximum number of backtracks were performed. To continue, reset NB and recall the routine.

IND = 4 No more circuits exist. The array A has been restored (see the remark on the storage of A below) and the procedure is finished.

We note in passing that on an initial call to the routine, the setting IND = 4 on output indicates that the graph contains no Hamiltonian circuits.

After a call to HC, if IND = 1 or 2 on output then the search procedure can be continued by resetting NB and recalling the routine. Do not modify IND when the tree search ts to be continued. In this case, the storage of A has been temporarily modified and [WK contains information needed for the search. If a new Hamiltonian circuit is found when HC is recalled, then the vertices traversed by the new circuit will now be stored in S.

```text
After a cail to HC, if IND = 1 or 2 on output and it is desired that the search procedure
be terminated, then reset IND = 3 and recall the routine. In this case, the array A will be
restored and IND = 4 when HC terminates.
```

Storage of A. When A is restored, the order of the vertices of R, in .i may be modified for each ¢.

**Error Return.** If an input error is detected then IND is set to one of the following values:

IND = -1 IND <0 or IND > 3 on input.

IND = -—2 IND was modified, being assigned a value 4 3 when HC was recalled. Reset IND to its previous output value, reset NB, and recall HC if another circuit is wanted.

IND = —3 The input setting IND = 3 is not needed when the previous output. value for IND was 4. In this case, nothing was done.

IND = -4 NUM < m+ 8n + 20.

IND = -5 P(1) #0 or P(n+1) Am.

IND = --6 P(t) > P(t + 1) for some ¢.

Remarks.

{

on

(1) It ic assumed that € contains no loops.

(2) Normally, few backtracks are needed when the number of vertices in each R; is small, say LM or less. Consequently, the setting NB =: —1 is generally appropriate in such canes,


<small>Original source: [View scanned PDF page 45](scans/page_0045.png)</small>

**Programming.** HC employs the subroutines HC1, IPATH, FUPD, BUPD, IUPD, and RARC. The search procedure in these routines was written by Silvano Martello (University of Bologna, Italy). The user interface involving the variable IND was written by A. H.

Morris.

**Reference.** Martello, 8., “Algorithm 595. An Enumerative Algorithm for Finding Hamiltonian Circuits in a Directed Graph,” ACM Trans.. Math Software 9 (1983), pp. 131-138.


<a id="category-046"></a>
## Special Functions

<small>Original source: [View scanned PDF page 46](scans/page_0046.png)</small>

<a id="topic-046-01"></a>
### Error Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CERF` | `SUBROUTINE` | `MO, Z, W` | [`L6073`](source_parts/nswc_part_01.f90#L6073) |
| `CERFC` | `SUBROUTINE` | `MO, Z, W` | [`L6218`](source_parts/nswc_part_01.f90#L6218) |
| `ERF` | `REAL FUNCTION` | `X` | [`L6399`](source_parts/nswc_part_01.f90#L6399) |
| `ERFC` | `REAL FUNCTION` | `X` | [`L6452`](source_parts/nswc_part_01.f90#L6452) |
| `ERFC1` | `REAL FUNCTION` | `IND, X` | [`L6535`](source_parts/nswc_part_01.f90#L6535) |
| `DCERF` | `SUBROUTINE` | `MO, Z, W` | [`L6628`](source_parts/nswc_part_01.f90#L6628) |
| `DCERFC` | `SUBROUTINE` | `MO, Z, W` | [`L6940`](source_parts/nswc_part_01.f90#L6940) |
| `DERF` | `DOUBLE PRECISION FUNCTION` | `X` | [`L7380`](source_parts/nswc_part_01.f90#L7380) |
| `DERFC` | `DOUBLE PRECISION FUNCTION` | `X` | [`L7432`](source_parts/nswc_part_01.f90#L7432) |
| `DERFC1` | `DOUBLE PRECISION FUNCTION` | `IND, X` | [`L7495`](source_parts/nswc_part_01.f90#L7495) |


For any complex z the error function is defined by

ents) = a foe

and its complement by erfc(z) = 1 — erf(z). The subroutines CERF, CERFC, DCERF, and DCERFC are available for computing erf(z) and erfc(z) when z is complex, and the functions ERF, ERFC, ERFC1, DERF, DERFC, and DERFC1 are available for computing erf(z) and erfc(z) when z is real. DCERF, DCERFC, DERF, DERFC, and DERFC1 are double precision routines.

```fortran
CALL CERF(MO, Z, W)
```

MO is an integer, z a complex number, and w a complex variable. When CERF is called, w is assigned the value erf(z) if MO = O and the value erfc(z) if MO # 0.

**Algorithm.** For z= 2+ ty where x > 0, if z satisfies |z| < 1 or both of the inequalities 1 < |z| < V38 and 2: x? — y? + 06427y* < 0, then the series

)" gittl

(1) erf(z => es ath yi)

is used. If 1 < |z| < 38 and 2? — y? + .064z7y? > 0 then

~ 3?

(2) erf(2) = 1 - “T- vats

is employed. A, and ry, are the poles and residues of the rational function approximation for the complex Fresnel integral Et) given in the reference. The error function is related to E(z) by erf(z) = 1 ~¢/2E(—z?) for jarg(z)| < /2. If |z| > 38 and x > .O1 then erf(z) is computed by the asymptotic expansion erf(z) = 1 — W(z) where

ye _ 1+3++-(2n~ 1) (3) YO) = Fels t LCD ae |

```text
Otherwise, if |z| > V/38 and 0 < x < .01 then erf(z) = —1(z) is employed. When x < 0
then the relation erf(--z) == —erf(z) is applied.
```

**Programming.** Written by Allen V. Hershey and A. H. Morris.

**Reference.** Hershey, A. ., Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.


<small>Original source: [View scanned PDF page 47](scans/page_0047.png)</small>

```fortran
CALL CERFC(MO, Z, W)
```

MO is an integer, z a complex number, and w a complex variable. When CERFC is called, w is assigned the value erfc(z) if MO = 0 or Re(z) < 0. Otherwise, if MO # 0 and Re(z) > 0 then w is assigned the value e*erfc(z).

**Precision.** For MO # 0, Re(w) and Im(w) are accurate to within 1 unit of the 12°” significant digit when |Re(w)| > 10~28° and Im(w) # 0.

**Programming.** CERFC employs the subroutine CREC and functions EXPARG and IPM- PAR. CERFC was written by Allen V. Hershey and A. H. Morris.

**Reference.** Hershey, A. V, Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.

ERF(z) ERF(2) = erf(x) for any real z. Precision. ERF(z) is accurate to within 2 units of the 14" significant digit for x # 0. Programmer. A. H. Morris

**Reference.** Cody, W. J., “Rational Chebyshev Approximations tor the Error Function,” Math Comp. 23 (1969), pp. 631-637.

ERFC(z) ERFC(z) = erfc(z) for any real z.

**Precision.** If « < 3 then ERFC(z) is accurate to within 2 units of the 14*” significant digit. Otherwise, if z > 3 then ERFC(z) is accurate to within 4 units of the 14'” significant digit when ERFC(2) # 0.

**Programming.** ERFC employs the functions EXPARG and IPMPAR. ERFC was written by A. H. Morris.

**Reference.** Cody, W. J., “Rational Chebyshev Approximations for the Error Function,” Math Comp. 23 (1969), pp. 631-637.

```fortran
ERFC1(IND, X)
```

IND is an integer and z a real number. ERFC1{IND,z) = erfc(z) when [ND = 0, and ERFC1(IND,z) = e”erfc(z) when IND # 0. Precision. If z < 3 then ERFC1(0,z) is accurate to within 2 units of the 14" significant digit. Otherwise, if x > 3 then ERFC1(0,z) is accurate to within 4 units of the 14¢*

significant digit when ERFC1(G,z) 4 0. If IND # O then ERFC1(IND,z) is accurate to


<small>Original source: [View scanned PDF page 48](scans/page_0048.png)</small>

within 2 units of the 14** significant digit for z > —1.

**Programming.** ERFC1 employs the functions EXPARG and IPMPAR. ERFC1 was written by A. H. Morris.

**Reference.** Cody, W. J., “Rational Chebyshev Approximations for the Error Function,” Math Comp. 23 (1969), pp. 631-637.

```fortran
CALL DCERF(MO, Z, W)
```

MO is an integer, and Z and W are double precision arrays of dimension 2. It is assumed that Z(1) and Z(2) are the real and imaginary parts of a complex number z. If MO = 0 then the double precision value for w = erf(z) is computed, and if MO # 0 then the double precision value for w = erfc(z) is computed. W(1) and W(2) contain the real and imaginary parts of w, respectively.

**Algorithm.** For z = z+ ty where zx > 0, if |z| < 1 then (1) is used, and if |z — 2| < 1 and x < 2 then the Taylor series

(4) exfe(z) = erfola) + Jaen SS (1) Hnalaj(e—a)"/nt (a= 2)

Fe

is employed. Here H,(a) are the Hermite polynomials. If 1 < |z| < 2.5 then (4) and the Pade approximation A,(z?)/Bp,(z?) for /7(2z)~4e* erf(z) are used where

```text
Ap(z)=1  Ai(z)=1+ 42
3o(z)=1 By(z)=1~ 2z
```

(5)

and A, and B,, satisfy

22 4n{4n + 2)2?

(4n + 1)(4n +5) Br(z) + (4n — 1)(4n + 1)#(4n + 3)

(6) Bn+ilz) = Bn.-1(2)

(see pp. 191,192, and 422 of the reference). Also, if 2.5 < |z| < 12 then A,(z*)/B,(z?) and the Pade approximation G,,(z?)/H,»(z?) for \/ze* erfc(z) are employed where

Golz)=1 Gy(z)=24+ 22

(7) Ho(z)=1 Hy(z)=3+2z

and G,, and H,, satisfy

(8) Hygi(z) = (22 + 4n + 3) i, (z) ~ 2n(2n + 1) Hy-1(z)

(see pp. 201 and 422 of the reference). Otherwise, if |z| > 12 and x > .OL then the asymptotic expansion erfc(z) = w(z) is used where u(z) is given by (3). Also, if [z| > 12 and 0 < ¢ < .0} then erf(z) - ~(z) is employed. When x < 0 the relation erf(- z) -erf(z) is applied.


<small>Original source: [View scanned PDF page 49](scans/page_0049.png)</small>

**Programming.** DCER#F calls the subroutines ERFCM2, CDIVID, and DCREC. DCERF and ERFCM2 were written by A. H. Morris. The function DPMPAR is also used.

**Reference.** Luke, Yudell L., The Special Functions and Their Approximations, Vol 2, Academic Press, New York, 1969.

```fortran
CALL DCERFC(MO, Z, W)
```

MO is an integer, and Z and W are double precision arrays of dimension 2. It is assumed that Z(1) and 27(2) are the real and imaginary parts of a complex number z. ff MO = 0 or Re(z) < 0 then the double precision value for w = erfc(z) is computed. Otherwise, if MO # 0 and Re(z) > 0 then the double precision value for w = e* erfe(z) is computed. W(1) and W’(2) contain the real and imaginary parts of w, respectively.

**Precision.** For MO # 0 and Re(z) > 0, W(1) and W(2) are accurate to within 3 units of the 26'” significant digit when W(2) 4 0.

**Programming.** DCERFC employs the subroutines ERFCM2, CDIVID, and DCREC, and functions DXPARG, DPMPAR,and IPMPAR. DCERFC and ERFCM2 were written by A. H. Morris.

```fortran
DERF(X)
```

The argument z is a double precision number. DERF(z) is the double precision value for erf(z).

**Remark.**DERF must be declared in the calling program to be of type DOUBLE PRECISION.

**Algorithm.** If jz| < 1 then the power series corresponding to the Chebyshev expansion given in the SLATEC library by Wayne Fullerton (Los Alamos) is used, and if |z| > 1 then minimax approximations are employed. The power series and minimax approximations were obtained by A. H. Morris.

**Precision.** DERF(z) is accurate to within 2 units of the 28"" significant digit for x 4 0.

**Programming.** DERF employs the function DERFC0. DERF was written by A. H. Morris. DERFC(z}

The argument x is a double precision number. DERFC(z) is the double precision value

for erfc(z).

**Remark.** DERFC must be declared in the calling program to be of type DOUBLE PRECISION.

Algorithm, If |z| < 1 then the power series corresponding to the Chebyshev expansion given in the SLATEC library by Wayne Fullerton (Los Alamos) is used. Otherwise, if 1 < jx] < 50


<small>Original source: [View scanned PDF page 50](scans/page_0050.png)</small>

then minimax approximations are used, and if |z| > 50 then the asymptotic expansion (3) is employed. ‘Che power series and minimax approximations were obtained by A. H. Morris.

Precision. DERFC(z) is accurate to within 2 units of the 28" significant digit for 2 < 2.

**Programming.** DERFC employs the functions DERF'CO, DXPARG, and IPMPAR. DERFC was written by A. H. Morris,

```fortran
DERFC1(IND, X)
```

IND is an integer and z a double precision number. DERFC1{IND,z) is the double precision value for erfc(z) when IND = 0, and DERFC1(IND,z) is the double precision value for e7 erfe(z) when IND £0.

**Remark.** DERFC1 must be declared in the calling program to be of type DOUBLE PRECISION.

**Precision.** DERFCi(IND,z) is accurate to within 2 units of the 28°" significant digit when IND = O and 2 < 2, and when IND #4 O and 2z> -1

**Programming.** DERFC1 employs the functions DERFC0, DXPARG, and IPMPAR. DERFCi was written by A. H. Morris.


<small>Original source: [View scanned PDF page 51](scans/page_0051.png)</small>

<a id="topic-051-01"></a>
### Inverse Error Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ERFI` | `REAL FUNCTION` | `P, Q` | [`L7728`](source_parts/nswc_part_01.f90#L7728) |
| `DERFI` | `DOUBLE PRECISION FUNCTION` | `P, Q` | [`L7840`](source_parts/nswc_part_01.f90#L7840) |


For any 0 < x < 1, the following functions are available for obtaining the value w > 0 for which erf(w) = 2.

ERFi(z, y)

```text
It is assumed that z > 0, y > 0, and r+y= 1. Then ERFI(z,y) = w where w > 0
and erf(w) = x.
```

**Error Return.** ERFI(z, y) = —1 if z <0 or y < 0, and ERFI(z,y) = -2ifx+y# 1. Precision. ERFI(z, y) is accurate to within 3 units of the 14" significant digit.

**Programming.** ERFI was written by Armido R. DiDonato and modified by A. H. Morris. The function SPMPAR is used.

**Reference.** Blair, J. M., Edwards, C. A., and Johnson, J. H.,“Rational Chebyshev Approximations for the Inverse of the Error Function,” Math. Comp. 36 (1976), pp. 827-830.

```fortran
DERFI(P, Q)
```

```text
The arguments z and y are doukle precision numbers where z > 6, y > O, and x+y = 1.
DERFI(z, y) is the double precision value for w where w > 0 and erf(w) = z.
```

**Remark.** DERFI must be declared to be of type DOUBLE PRECISION in the calling program.

**Error Return.** DERFI(z,y) = —-1lif x < Oory <0, and DERFI(z,y) = -2ifz+y 1.

**Algorithm.** If « < 15/16 then an initial value for w is given Ly minimax approximations due to A. H. Morris. Otherwise, if z > 15/16 then an initial value for w is given by minimax approximations from the reference. These approximations are accurate to 17-18 digits. If more accuracy is needed, then a single iterate of the Newton procedure for solving F(w) =: 0 is taken to obtain w to machine precision. Here

erflw) 2 if2< 3/4

F(w)} es 4 erfe(w) - y if 3/4 <2 < 15/16 Inferfe(w)} --In(y) if 2 > 15/16.

**Precision.** DERFI (2,7) is accurate to within | unit of the 27" significant digit.

**Programming.** DERFI employs the functions DERF, DERFC1, DERFC0, DXPARG, DPMPAR, and IPMPAR. DERFI was written by A. H. Morris.

**Reference.** Blair, J. M., Edwards, C. A., and Johnson, J. H.,“Rational Chebyshev Approximations for the Inverse of the Error Function,” Meth. Comp. 30 (1976), pp. 827 830.


<small>Original source: [View scanned PDF page 52](scans/page_0052.png)</small>

<a id="topic-052-01"></a>
### Difference Of Error Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `AERF` | `REAL FUNCTION` | `X, H` | [`L7996`](source_parts/nswc_part_01.f90#L7996) |
| `DAERF` | `DOUBLE PRECISION FUNCTION` | `X, H` | [`L8139`](source_parts/nswc_part_01.f90#L8139) |


For any real x and h, let aerf(2,h) = erf(x+h) —erf(x~--h). Then the functions AERF and DAERF are available for computing aerf(z, A).

AERF(z, h) AERF(z,h) = aerf(z,h) for any z and A.

**Precision.** AERF(z,h) is accurate to within 6 units of the 12'" significant digit when AERF (sz, h) # 0.

**Programming.** AERF employs the functions ERF, ERFC, EPSLN, EXPARG, SPMPAR, and IPMPAR. AERF was written by Armido R. DiDonato and modified by A.H. Morris.

**Reference.** DiDonato, A.R., Significant Digit Computation of the Elliptical Coverage Function, Report NSWC TR 90-513, Naval Surface Warfare Center, Dahlgren, Virginia, 1990.

```fortran
DAERF(X, H)
```

The arguments xz and h are double precision numbers. DAERF(z,h) is the double precision value for aerf(z, h).

**Remark.** DAERF must be declared to be of type DOUBLE PRECISION in the calling program.

**Programming.** DAERF employs the functions DERF, DERFC, DERFC0, DEPSLN, DX- PARG, DPMPAR, and IPMPAR. DAERF was written by Armido R. DiDonato and modified by A. H. Morris.

**Reference.** DiDonato, A.R., Significant Digit Computation of the Elliptical Coverage Function, Report NSWC TR 90-513, Naval Surface Warfare Center, Dahlgren, Virginia, 1990.


<small>Original source: [View scanned PDF page 53](scans/page_0053.png)</small>

<a id="topic-053-01"></a>
### Normal Probability Distribution Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PNDF` | `FUNCTION` | `X, IND` | [`L8284`](source_parts/nswc_part_01.f90#L8284) |


Let $\Phi(x)$ be the standard normal cumulative distribution function,
$\overline\Phi(x)=1-\Phi(x)$ its upper-tail probability, and
$\phi(x)=(2\pi)^{-1/2}e^{-x^2/2}$ its density. The function `PNDF(X, IND)`
returns:

| Condition | `PNDF` result |
|---|---|
| `IND == 0`, `X >= -8` | $\Phi(x)$ |
| `IND == 0`, `X < -8` | $\phi(x)/\Phi(x)$ |
| `IND != 0`, `X <= 8` | $\overline\Phi(x)$ |
| `IND != 0`, `X > 8` | $\phi(x)/\overline\Phi(x)$ |

The ratios in the extreme tails are deliberate and avoid underflow of the
corresponding very small probabilities; **they are not ordinary CDF values**.
The source implements these calculations with `ERFC1`.

**Programming.** A. H. Morris. Original documentation:
[page 53](scans/page_0053.png).


<a id="topic-054-01"></a>
### Inverse Normal Probability Distribution Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [`L8318`](source_parts/nswc_part_01.f90#L8318) |
| `DPNI` | `SUBROUTINE` | `P, Q, D, W, IERR` | [`L8385`](source_parts/nswc_part_01.f90#L8385) |


For any real w, the normal probability distribution function P(w) (of mean 0 and variance 1) is defined by

P(w) = 0772 ge

1 w [ € V2 f and its complement by Q(w) = 1— P(w). For any 0 < p < 1 and q = 1 — p, the following subroutines are available for obtaining the value w for which P(w) = p and Q(w) = gq.

```fortran
CALL PNI(P, Q, D, W, IERR)
CALL DPNI(P, Q, D, W, IERR)
```

PNI is used when p, g, and d are real numbers and w is a real variable, and DPNI is used when p, g, and d are double precision numbers and w is a double precision variable.

It is assumed that p > 0, ¢ > 0, p+q = 1, and d= p— 1/2. TERR and w are variables. When PNI cr DPNI is called, if no input errors are detected then IERR is set to 0. Also, w is assigned the value for which P(w) = p and Q(w) = q.

```text
Error Return. IERR = 1 if p < 0,q < 0, or p+q #1, and IERR = 2 if d # p — 1/2.
Algorithm. For y > 0, let y =: erf~'(xr) when x == erf(y). If P(w) = p then the identities
```

-J/2erf(1-2p) ifO0<p<1/2 V2erf'(2p i) ifl>p>t/2

are applied.

**Precision.** {f PNI is called then w is accurate to within 3 units of the 14" significant digit. Otherwise, if DPN] is called then w is accurate to within L unit of the 27" significant digit.

**Programming.** PNI employs the functions FREI, SPMPAR, and IPMPAR, and DPNE employs the functions DERFI, DER, DERECI, DERECO, DXPARG, DPMPAR, and IPM- PAR. PNI was written by Armido R. DiDonato and modified by A. H. Morris. DPNI was adapted from PNE by A. EL. Morris,


<small>Original source: [View scanned PDF page 55](scans/page_0055.png)</small>

<a id="topic-055-01"></a>
### Dawson's Integral

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DAW` | `REAL FUNCTION` | `X` | [`L8453`](source_parts/nswc_part_01.f90#L8453) |
| `DPDAW` | `DOUBLE PRECISION FUNCTION` | `X` | [`L8584`](source_parts/nswc_part_01.f90#L8584) |


Dawson's integral is

$$
F(x)=e^{-x^2}\int_0^x e^{t^2}\,dt.
$$

`DAW(X)` evaluates $F(x)$ in single precision, while `DPDAW(X)` provides
the double-precision counterpart.

**Programming.** `DAW` is derived from the FUNPACK special-function collection
at Argonne National Laboratory, with modifications by A. H. Morris.
`DPDAW` uses approximations derived from SLATEC Chebyshev expansions and
additional approximations by A. H. Morris.

**Reference.** W. J. Cody, K. A. Paciorek, and H. C. Thacher,
"Chebyshev Approximations for Dawson's Integral," *Mathematics of Computation*
**24** (1970), 171-178.

Original documentation: [page 55](scans/page_0055.png).


<a id="topic-056-01"></a>
### Complex Fresnel Integral

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CFRNLI` | `SUBROUTINE` | `MO, Z, W` | [`L8852`](source_parts/nswc_part_01.f90#L8852) |


For any complex z not on the positive real axis the complex Fresnel integral E(z) can be defined by 1 f? et E @) ocr ---a_s —= tt. (*) Vor J ~ 00 Jt Here it is assumed that 0 < arg{z) < 2m and arg(,/z) == 1/2 arg{z). E(z) can be extended to the positive real :.xis by letting 0 < arg(z) < 2". Then erf(z) = 1 — i/2 E(—2z?) for —«/2< arg(z) < «/2 where erf{z) ia the error function and arg(—z?) = 4 + 2 arg(z). The following subroutine 3 is available for computing E(z).

```fortran
CALL CFRNLI(MO, Z, W)
```

MO is an integer, z a complex number, and w a comp!ex variable. When CFRNLI is called, w is assigned the value H(z) if MO == 0 and the value e~* H(z) if MO £0.

**Algorithm.** If z = z + ty satisfies !z| < 1 or both of the inequalities t < |z| < 38 and —z + .016y? < 0, then the series

F(z) ) = ~Jg+ Viale en

aint +1)

is used. If 1 < |z| < 38 and --z + .016y? > 0 then

E{2) = aed yo tte

> 38 and Im \/2z/m > .008 then E(z) is computed by the asymptotic expansion E(z) = (z) where

e 1-3---(2n —1) z) = pee fit S° v( ) /2nz at x (2z)"

**Precision.** For MO # 0, Refw)} aud im(w) are accurate to within 1 unit of the 12°" significant digit when Re(w) and Im(w) are nonzero.

**Programming.** CF RNLI employs the functions CPABS, EXPARG, and IPMPAR. CFRNLI was written by Allen V. Hershey and A. H. Morris.

Reference. Hershey, A. V., Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.


<small>Original source: [View scanned PDF page 57](scans/page_0057.png)</small>

<a id="topic-057-01"></a>
### Real Fresnel Integrals

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FRNL` | `SUBROUTINE` | `T, C, S` | [`L9030`](source_parts/nswc_part_01.f90#L9030) |


For any complex z the Fresnel integrals C(z) and S(z) can be defined by Oz) =[ ccs (507) dt 0 2 / * x S(z) = [ sin (-t? | dt (z) I sin (F )

The following subroutine is available fer computing Cye} and 3 (z) when .: is real. CALL FRNL(z,C, S)

The argument x may be any real number. C and S are variables. When FRNL is called C’ is assigned the value C(z) and S is assigned the value S{z).

**Algorithm.** If 0 < xz < 1.65 then 27'C(z) and x“3S(z) are computed by minimax polynomial apprcximations. Otherwise, if « > 1.65 then the relations

lt S{a) =z - F(z) coss-2? — g(x) sins x?

are invoked. For 1.65 < 2 < 6,2f(z) and x°g(z) are computed by rational minimax approximaticns. Otherwise, for z >: 6 the auxiliary functions f(z) and g(z) are computed by the asymptotic expansions:

f(z) — 14 2| 1) (x2)? LOR, yh 8 (48 +1 g(t) =~ dal 4) Saar

x

Here m= 5. If x < 0 then the relations C(--r) = —C(2) and S(—<) = --S(z) are applied.

**Precision.** if |zj < 2 then FRNI is accurate to within 3 units of the 14 significant digit. Otherwise, if |z| > 2 then FRNL is accurate to within U unit of the 14" significant digit.

**Programming.** FRNL calls the functions SIN], COS1, and IPMPAR. FRNL was written by A. H. Morris.


<small>Original source: [View scanned PDF page 58](scans/page_0058.png)</small>

<a id="topic-058-01"></a>
### Exponential Integral Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEXPLI` | `SUBROUTINE` | `MO, Z, W` | [`L9233`](source_parts/nswc_part_01.f90#L9233) |
| `EXPLI` | `SUBROUTINE` | `INT, ARG, RESULT, IERR` | [`L9426`](source_parts/nswc_part_01.f90#L9426) |
| `DEI` | `DOUBLE PRECISION FUNCTION` | `X` | [`L9757`](source_parts/nswc_part_01.f90#L9757) |
| `DEI1` | `DOUBLE PRECISION FUNCTION` | `X` | [`L9775`](source_parts/nswc_part_01.f90#L9775) |


For any complex z # 0 not on the positive real axis the exponential integral function

Ei(z) is defined by

Bifz) = | ~~ dt, deco t Ki(z) is an analytic function. I€ z is replaced by -z and t by ~t we obtain the related

function PO ot

Ey(z) ~ ~Ei(~z) = | Sat

a

which is defined for all z # 0 not on the negative real axis. It, can be verified that Ei(z) = v 4+-In(—z) + ——~ Aa everywhere in the plans cut along the positive real axis where vy is the Euler constant. Thus, the values of Ei{z) on the upper and lower edges of the cut are Bi(x £10) = eifx) Fmt where ei(z) is the real function defined by

ar Ad ei(z) = vy + Ina + > --

n-n! n=i

for 2 > 0. The function ei(z), also known as the exponential integral function, has a zero i he point 29 = .37250 74107 81367 Ei(z) may be computed by the subroutine CEXPL when z is complex, and Ei(z) and ei(z) may be computed by the subroutine EXPL£ and functions DET and DET] when z is real. DET and DEI! are double precision functions.

```fortran
CALL CEXPLI(MO, Z, W)
```

MO is an integer, z 4 0 a complex number, and w a complex variable. When CEXPL1 is called, w is assigned the value Ei(z) if MO = © and the value e~? Ei(z) if MO #0.

**Remark.** If z is a positive real number and MO = 0 then w =» ei(z) +-9¢.

**Precision.** If MO = 0 then Re(w) and Im(w) are accurate to within 2 units of the 12t significant digit when z is nov near a zero of Re(Ki{z)) or Im(Fi(z)).

**Programming.** CEXPLI employs the functions CPABS and SPMPAR. CEXPLI was initially written by Allen V. Hershey, and later rewritten by A. HL. Morris.

**Reference.** Hershey, A. V., Approximations of Functions by Sets of Poles, veo. o TR 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.


<small>Original source: [View scanned PDF page 59](scans/page_0059.png)</small>

```fortran
CALL EXPLI(INT, ARG, RESULT, IERR)
```

MO may have the values 1,2, or 3. The argument x is a nonzero real number and w areal variable. When EXPi is called, if MO = 1 then w is assigned the value Ei(x) for a < O and the value eifx) tor > 0. If MU = 2 then it is assured that z > 0. In this case w is assigned the value £,(z}. Otherwise, if MO = 3 then w is assigned the value e~*Ei(z) for a < GO and the value e~” vi{z) for x > 0.

**Error return.** TERR is a variable that reports the status of the results. If the requested value w is obtained then [ERR is set to 0. Otherwise, TERR is assigned one of the following values:

JERR = 1 Underflow occurs. In this case w = 0.

TERR = 2 Overflow occurs.

IERR = 3 (Input error) 2 = 0.

IGRR = 4 (Input error) MO = 2 and x < 0. The variable w is not defined when IERR > 2.

**Algorithm.** If MO 4 2 and 4 < 2x < 8, then the Chebyshev expansion in the SLATEC library obtained by Wayne Fullerton (Los Alamos) is used. The remaining approximations employed are from the references.

**Precision.** If MO # 2 and x > 0, then w is accurate to within 4 units of the 14° significant digit when w 7 0. Otherwise, w is accurate to within 3 units of the 14" significant digit when wv #0.

**Programming.** EXPLI employs the functions ALNREL, CSEVL, EXPARG, and IPMPAR. EXPLI was written at Argonne National Laboratory for the FUNPACK package of special function subroutines. XPLI was modified by A. H. Morris.

**References.**

(1) Cody, W. J. and Thacher, H. C., “Rational Chebyshev Approximations for the Exponential Integral E,(«),” Math Comp. 22 (1968), pp. 641-649.

(2), “Chebyshev Approximations for the Exponential Integral Ei(z},” Math Comp. 23 (1969), pp. 289-303.

DEI(Cr) The argument x -f 0 is a double precision number. DEI(+) is the double precision value for Ei(z) when z < 0, and the double precizion value for ei(z) when x > 0.

**Remark.** DET must be declared in the calling program to be of type DOUBLE PRECISION.

Algorithm. If 35 < 2 < 4 then the Taylor series expansion of elif; around zy is used. This expansion was obtained by A. Hf. Morris. Hf jx expansion for fi and ei is applied. Otherwise, the Chebyshev expansions in the SLATEC:

» 9O then the standard asymptotic

library obtained by Wayne Fullerton (Los Alamos) are used,


<small>Original source: [View scanned PDF page 60](scans/page_0060.png)</small>

**Programming.** DEI employs the functions DE1E and DEI0. These functions were written by A. H. Morris. The functions DCSEVL and DPMPAR are also used.

DE!1(z) The argument 2 # 0 is a double precision number. DEIi(z) is the double precision value for e~* Ei(z) when z < 0, and the double precision value for e~* ei{z) when z > 0.

**Remark.** DEi1 must be declared in the calling program to be of type DOUBLE PRECISION.

**Algorithm.** If .35 < x < .4 then the Taylor series expansion of ei(z) around zo is used. This expansion was obtained by A. H. Morris. If |x| > 90 then the standard asymptotic expansion for Ei and ei is applied. Otherwise, the Chebyshev expansions in the SLATEC library obtained by Wayne Fullerton (Los Alamos) are used.

**Precision.** DEIi(z) ia accurate to within 4 units of the 28° significant digit when DEI1(z) £0.

**Programming.** DEI1 employs the functions DE1E and DEI0. These functions were written by A. H. Morris. The functions DCSEVL and DPMPAR are also used.


<small>Original source: [View scanned PDF page 61](scans/page_0061.png)</small>

<a id="topic-061-01"></a>
### Sine and Cosine Integral Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SI` | `FUNCTION` | `X` | [`L10158`](source_parts/nswc_part_01.f90#L10158) |
| `CIN` | `FUNCTION` | `X` | [`L10272`](source_parts/nswc_part_01.f90#L10272) |


For any complex z the sine integral and cosine integral functions Si(z) and Cin(z) are

defined by

\* gin t Si = —_—— i(z) [ ; dt *1—cost

Cin(s) = f= E* at 0 t

These are entire functions. The following functions are available for computing Si(z) and Cin(z) when z is real.

SI(z) SI(z) = Si(z) for all real z. Precision. SI is accurate to within 2 units of the 14'” significant digit.

**Programming.** SI calls the function SPMPAR. SI was written by Donald E. Amos and Sharon L. Daniel (Sandia Laboratories), and modified by A. H. Morris.

CIN(z) CIN(z) = Cin(z) for all real z.

**Precision.** CIN is accurate to within 2 units of the 14" significant digit.

**Programming.** CIN calls the function SPMPAR. CIN was written by Donald E. Amos and Sharon L. Daniel (Sandia Laboratories), and modified by A. H. Morris.


<small>Original source: [View scanned PDF page 62](scans/page_0062.png)</small>

<a id="topic-062-01"></a>
### Exponential Exponential Integral Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEXEXI` | `SUBROUTINE` | `Z, W` | [`L10386`](source_parts/nswc_part_01.f90#L10386) |


For any complex z # O not on the positive real axis, the exponential exponential integral function #Et{z) can be defined by

EEi(z) = / ; — Ei(u) du

where E(u) is the exponential integral function. The following subroutine is available for computing #E£1(z), where EEi(z) is extended to the positive real axis by letting 0 < arg(z) < 2m.

```fortran
CALL CEXEXI(Z, W)
```

The argument z is a nonzero complex number and w is a complex variable. *When CEXEXI is called, w is assigned the value EE1(z).

**Precision.** Re(w) and Im(w) are accurate to within 1 unit of the 12" significant digit when Re(EEi(w)) and Im(ZE1(w)) are not near 0.

**Programming.** CEXEXI was written by Allen V. Hershey and modified by A. H. Morris.

**Reference.** Hershey, A. V., Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.


<small>Original source: [View scanned PDF page 63](scans/page_0063.png)</small>

<a id="topic-063-01"></a>
### Dilogarithm Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CLI` | `COMPLEX FUNCTION` | `Z` | [`L10586`](source_parts/nswc_part_02.f90#L1) |
| `ALI` | `REAL FUNCTION` | `X` | [`L10702`](source_parts/nswc_part_02.f90#L117) |


For any complex z where larg(1-+ z)}/ < #, the dilogarithm function L(z) may be defined by to t L{z) is real-valued fer any real z > —1, and -1 is a branch point. L(z) can be extended to

the negative rea! axis from --oo to ~1 by letting -a < arg(1 +z) < . Then for any real

E{z) = —1 6 +f mt) dt-+inin(—z) (f= V~1).

The function CLI is available for computing L(z) when z is complex, and the function ALI is available tor computing the real part of L(z) when z is real.

```fortran
CLK(z)
```

CLI is a complex-valued function where CLI(z) == L(z) for all complex z. CLI must be declared in the calling program to be of type COMPLEX.

**Algorithm.** For jz| < 1/2 the Maclaurin series

n>1 is used. If |z| > 3 then (2) L(z) = 7/6 — LA/z) + 1/210? z is applied, and if O < jz + 1| < 1/2 then (3) L({z) = —n?/6 -- L(-1 ~ z) +1n(--z) In(1 + z)

is applied. Otherwise,

L(z) = -| a4 d\ (Debye Function) F : (4)

~ Hy,w?” nit = ww 2/4- 2 ; (Gn pyr Jw] < Qa

is used where w = —Inj{l + z) and 32, are the Bernoulli numbers By, = 1/6, Bg ~- 1/30, .... In (3) we note that In(~z)in{1 +z). + 0 when z 9 ~1.

**Programming.** CLI is a modification by A. H. Morris of the subroutine CLGMCI, written by Allen V. Hershey.


<small>Original source: [View scanned PDF page 64](scans/page_0064.png)</small>

**Reference.** Hershey, A. V., Approximation of Functions by Sets of Poles, Report TR- 2564, Naval Weapons Laboratory, Dahlgren, Virginia, 1971.

ALI(z) ALI{z) = Re[L(x)j} for all real x.

**Algorithm.** Rational minimax approximations are used when —1/2 <x <1. if2 > 1 then (2) is applied, and if -2 < 2 < -l or ~1 < x < ~1/2 then (3) is applied. Otherwise, if x< —2 then

Re! L(t)] = --2?/3 — L(1/x) + 1/21n?(-2)

(which follows from (2)) is used except when -26.63 < x < —6.97. Since Ke[L(zo)] = 6 for to = ~-12.59517 ..., the Taylor series of Re[Z(z)] around zo is used when --14 < 2 < -11.1. Otherwise, if —11.1 < 2 < --6.97 or -26.63 < x < —14 then rational minimax approximations are employed.

**Precision.** ALI(z) is accurate to within 2 units of the 14" significant digit when z > 0. Otherwise, if 2 < 6 then ALI(z) is accurate to within 4 units of the 14" significant digit when ALI(z) # 0.

**Programmer.** A. E. Morris

**Reference.** Morris, Robert, “The Dilogarithm Function of a Real Argument,” Math. Comp. 33 (1979), pp. 778-787.


<small>Original source: [View scanned PDF page 65](scans/page_0065.png)</small>

<a id="topic-065-01"></a>
### Gamma Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CGAMMA` | `SUBROUTINE` | `MO, Z, W` | [`L10844`](source_parts/nswc_part_02.f90#L259) |
| `GAMMA` | `REAL FUNCTION` | `A` | [`L11124`](source_parts/nswc_part_02.f90#L539) |
| `GAMLN` | `REAL FUNCTION` | `A` | [`L11388`](source_parts/nswc_part_02.f90#L803) |
| `DCGAMA` | `SUBROUTINE` | `MO, Z, W` | [`L11487`](source_parts/nswc_part_02.f90#L902) |
| `DGAMMA` | `DOUBLE PRECISION FUNCTION` | `A` | [`L11761`](source_parts/nswc_part_02.f90#L1176) |
| `DGAMLN` | `DOUBLE PRECISION FUNCTION` | `A` | [`L12094`](source_parts/nswc_part_02.f90#L1509) |


For any complex z # 0,-—1,-2,... the gamma function can be defined by

[(z) = > (-1)" i 4 [ ti g~t ge

n=0

Then F(z) is a meromorphic function having simple poles at 0,—-1, ~2,... ,and

r(z)= | t7~e* dt 0

for Re(z) > 0. Also ['(z) # 0 for all z. The subroutines CGAMMA and DCGAMA are available for computing ['(z) and InI'(z) when z is complex, and the functions GAMMA, GAMLN, DGAMMA, and DGAMLN are available for computing T(z) and InI'(z) when z is real. DCGAMA, DGAMMA, and DGAMLN are double precision procedures.

```fortran
CALL CGAMMA(MO, Z, W)
```

MO is an integer, z a complex number satisfying z 4 0,-1,-2, .. ., and w a complex variable. When CGAMMA is called, w is assigned the value P'(z) if MO = 0 and the value InI'{z) if MO 40.

**Error return.** If z = 0,—1, --2,..., or if Re(z) < 0 and Re(z) is too large for In I'(z) to be computed, then w is assigned the value 0.

**Programming.** CGAMMA calls the functions REXP. SPMPAn, and IPMPAR. CGAMMA was written by A. H. Morris.

**References.**

(1) Kuki, Hirondo, “Complex Gamma Function with Error Control,” Comm. ACM 15 (1972), pp. 262-267.

(2) Spira, Robert, “Calculation of the Gamma Function by Stirling’s Formula,” Math Comp. 25 (1971), pp 317-322.

```fortran
GAMMA(A)
```

The argument z's a real number, If (x) can be computed then G .MMA (z) is assigned the value U(z). Otherwise, if M(2) cannot be computed, then GAMMA(z) is set te 0.

**Algorithm.** If jz! < 15 then x is reduced to the interval (1,2) by Pia + 1) @P(a), and a rational minimax approximation is employed. If 2 <- -15 then n


<small>Original source: [View scanned PDF page 66](scans/page_0066.png)</small>

is applied. For x > 15 (2) ln T(z) = (x — $) nz - x + § In(2x) + A(z)

is computed where A(x) is a minimax approximation. The function A(x) is evaluated in single precision, and a double precision value is obtained for Inz. This yields a double precision value for In ['(z). If Int'\(z) = a4-6 where a is the leading portion of InI'(z), then P{z) is set to e%(1 + 6). This is permissible since 1 + 6 is the portion of the Taylor series expansion for e® that is significant.

The logarithm In is evaluated as follows: Let n be the largest integer less than or equal to z, and let ¢ = (x —n)/(x +n). Then x = n(1+t)/(1 — t) so that nz = Inn + In{(1 + t)/(1 — ¢)]. Also 0 < t < 1/(2n). The function In {(1+1¢)/(l— t)] is computed by a polynomial minimax approximation in single precision, and the value In n is stored in double precision.

**Precision.** If 0 < z < 2 then GAMMA(z) is accurate to within 2 units of the 14 significant digit. If s > 2 then GAMMA(z) is accurate to within 3 units of the 14" significant digit. Otherwise, GAMMA(z) is accurate to within 5 units of the 14"? significant digit.

**Programming.** GAMMA calls the functions GLOG and EXPARG. These functions were written by A. H. Morris. The functions SPMPAR and IPMPAR are also used.

GAMLN(z) GAMLN(z) = InI(z) for all positive real z. Algorithm. See p. 379 and appendix D of the reference.

**Precision.** GAMLN(z) is accurate to within 2 units of the 14°? significant digit when GAMLN(z) 4 0.

**Reference.** DiDonato, A. R. and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

**Programming.** GAMLN calls the function GAMLN1. These functions were written by A. H. Morris.

```fortran
CALL DCGAMA(MO, Z, W)
```

MO is an integer, and 4 and W are double precision arrays of dimension 2. It is assumed that Z(1) and 4(2) are the real and imaginary parts of a complex number z. If MO... 0 then the double precision value for w — P(z) is computed. Otherwise, if MO 7 0 then the double precision value for w In P(z) is computed. W(1) and W(2) ‘contain the real and imaginary parts of w, respectively,

**Error Return.** [fz 0, ty) 2, or if Re(z) > O and Re(z} is too large for In P(2) to be computed, then W(1) and W (2) are assigned the value 0


<small>Original source: [View scanned PDF page 67](scans/page_0067.png)</small>

**Programming.** DCGAMA calls the functions DREXP,DPMPAR, and IPMPAR. DCGAMA was written by A. H. Morris.

**References.**

(1) Kuki, Hirondo, “Complex Gamma Function with Error Control,” Comm. ACM 15 (1972), pp. 262-267.

(2) Spira, Robert, “Calculation of the Gamma Function by Stirling’s Formula,” Math Comp. 25 (1971), pp. 317-322.

```fortran
DGAMMA(A)
```

The argument z is a double precision number. DGAMMA(z) is the double precision value for I'(z) when ['(z) can be computed. Otherwise, DGAMMA(z) is set to 0 when ['() cannot be computed.

**Remark.** DGAMMA must be declared in calling program to be of type DOUBLE PRECI- SION.

**Algorithm.** Li |x| < 20 then z is reduced to the inte:val (1,2) by [(a+ 1) = aT (a), and minimax approximations are used. If z < —20 then (1) is applied, and if z > 20 then (2) is used. A(z) is computed by the power series corresponding to the Chebyshev expansion ii the SLATEC library given by Wayne Fullerton ‘Los Alamos). The power series and minimax approximations were obtained ly A. H. Morris.

**Precision.** If 0 < x < 2 then DGAMMA(r) is accu; ate to within 1 unit of the 28'" signifiant digit. Otherwise, if z > 2 then DGA'MM 1(z* is accurate to within 1 unit of the 25°" significant digit.

**Programming.** DGAMMA calls the functions DGAM1, DPDEL, DSIN1, and DX PARG. These functions were written by A. H. Morris. The functions DPMPAR and IPMPAR are also used.

```fortran
DGAMLN(A)
```

The argument 2 is a double precision positive number. DGAMLN(z) is the double precision value for In F(z).

**Remark.** DGAMLN must be declared in the calling program to be of type DOUBLE PRECISION,

**Algorithm.** If 5 <2 © 2.5 then minimax approximations are used, and ifr + LO then (2) is applied. A(x) 1s computed by the power series corresponding to the Chebyshev expansion in the SLATEC library given by Wayne Fullerton (Los Alamos), The power series and minimax approximations were obtained by A. HE. Morris.


<small>Original source: [View scanned PDF page 68](scans/page_0068.png)</small>

**Precision.** DGAMLN(z) is accurate to within 2 units of the 28° significant digit when DGAMLN(s) # 0.

**Programming.** DGAMLN calls the functions DPDEL, DGMLN1, DGAM1, and DLNREL. These functions were written by A. H. Morris.


<small>Original source: [View scanned PDF page 69](scans/page_0069.png)</small>

<a id="topic-069-01"></a>
### Digamma Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPSI` | `SUBROUTINE` | `Z, W` | [`L12173`](source_parts/nswc_part_02.f90#L1588) |
| `PSI` | `REAL FUNCTION` | `XX` | [`L12320`](source_parts/nswc_part_02.f90#L1735) |
| `DCPSI` | `SUBROUTINE` | `Z, W` | [`L12500`](source_parts/nswc_part_02.f90#L1915) |
| `DPSI` | `DOUBLE PRECISION FUNCTION` | `A` | [`L12675`](source_parts/nswc_part_02.f90#L2090) |


For any complex z # 0,—1,—2,... the digamma (or psi) function y(z) is defined by b(z) = I’(z)/T(z)

where ['(z) is the gamma function. For real z > 0,y(z) is an increasing function having a zero at the point 29 = 1.4616 32144 96836. The subroutines CPSI and DCPSI are available for computing (z) when z is complex, and the functions PSI and DPSI are available for computing ¥({z) when z is real. DCPSI and DPSI are double precision procedures.

```fortran
CALL CPSI{z, w)
```

The argument z is a complex number satisfying z # 0,—-1,—-2,..., and w is a complex variable. When CPSI is called, w is assigned the value #(z).

**Error Return.** If z = 0,—1,—-2,..., or if Re(z) < 0 and Re(z) is too large for (z) to be computed, then w is assigned the value 0.

**Algorithm.** If z == z4- ty satisfies « > O and |z| > 6, then the asymptotic expansion

1 SN Bam (1) w(z) = In a 2: _ »D Qmz2™

is employed. Otherwise, if z > 0 then the smallest nonnegative integer n is found for which iz 4+-n| > 6, and the relation

n--1 . dt y=0 is applied. When x < © then

is also used.

**Programming.** CPSI calls the functions REXP, SPMPAR, and IPMPAR. CPSI was written by ASH. Morris.

PSi(z)

The argument ris areal number. Hf y¥(z) can be computed then PS! (x) is assigned the value (2). Otherwise, if (a) cannot be computed then PSI(z) is set to 0.

**Precision.** If r+ O thea PSHry iy accurate to within 2 units of the 14% significant digit when PSitr) 4 0.


<small>Original source: [View scanned PDF page 70](scans/page_0070.png)</small>

**Programming.** PSI calls the functions SPMPAR and IPMPAR. PSI was written at Argonne National Laboratory for the FUNPACK package of special function subroutines. PSI was modified by A. H. Morris.

**Reference.** Cody, W. J., Strecok, A. J., and Thacher, H. C., “Chebyshev Approximations for the Psi Function,” Math Comp. 27 (1973), pp. 123-127.

```fortran
CALL DCPSI(Z, W)
```

Z and W are double precision arrays of dimension 2. It 1s assumed that 7(1) and 2(2) are the 1al and imaginary parts of a complex number z. When DCPSI is called the double precision value for w = (z) is computed. W(1) and W(2) contain the zeal and imaginary parts of w, respectively.

**Error Return.** If z = 0,-1,-2,..., or if Re(z) < 0 and Re(z) is too large for ¥(z) to be computed, then W(1) and W(2) are assigned the value 0.

**Programming.** DCPSI calls the functions UDREXP, DPMPAR, and IPMPAR. DCPSI was written by A. H. Morris.

```fortran
DPSI(A)
```

The argument z is a double precision number. If (x) can be computed then DPSI(z) is the double precision value for ¥(z). Otherwise, if v/~. cannot be computed, then DPSI{z) is set to 0.

Remark DPSI must be declared in the calling program to be of type DOUBLE PRECISION.

**Algorithm.** If |z| < 10 then z is reduced to tke interval {1,2) by ¥(a+ 1) = 4+ ¥(a), and the Chebyshev expansion in the SLATEC library given by Wayne Fullerton (Los Alamios) is used when |x ~ zo| > 2-107. Otherwise, if |x — xo| < 2-107? then the Taylor serics around the zero ro 1s used. The coefficients for the Taylor series were obtained by A. H. Morris. If z < --10 then (2) is applied, and if 2 > 10 then (<) -- Inz is computed by the power series corresponding to the Chebyshev expansion in the SLATEC library given by Wayne Fullerton. The power series was obtained by A. H. Morris.

**Precision.** If 0 < x < lor z > 2 then DPSI{z) is accurate to within 2 units of the 28¢* significant digit. Otherwise, if 1 < 2 < 2 then DPSI(z) is accurate to within 5 units of the 28°" significant digit when DPSI(z) ¢ 0.

**Programming.** DPSI calls the functions DCSEVL, DPSIO, DPMPAR, and IPMPAR. DPSI was written by A. H. Morris.


<small>Original source: [View scanned PDF page 71](scans/page_0071.png)</small>

<a id="topic-071-01"></a>
### Derivatives Of The Digamma Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PSIDF` | `SUBROUTINE` | `X, N, M, ANS, IFLAG` | [`L12920`](source_parts/nswc_part_02.f90#L2335) |


The following subroutine is available for computing the digamma function (zx) and its derivatives for real « > 0.

```fortran
CALL PSIDF(X, N, M, ANS, IFLAG)
```

```text
Let wa = —p(x) and w, = (-1)" ym anroye ) where p'")(z) is the n*® derivative of (z)
(mn =1,2,...).
```

The argument x is a positive real number, n and rm are integers where n > O and m > 1, and W is an array of dimension m or larger. When PSIDF is called, wyy;_1 18 computed and stored in W(t) for t= 1, ...,m.

IERR is an integer variable that reports the status of the results. When PSIDF terminates, IERR. has one of the following values:

TERR = 0 The values w,, ...,Wptm— were obtained and stored in W.

TERR = 1 (Input error) x <0,n <0,orm< 1.

IERR = 2 (Overflow) Either x is too small or n + m— 1 too large.

{ERR = 3 (Underflow) Either z is too large or n+ m— 1 too large.

TERR = 4 This setting can occur only if n +m —1 > 100. When it occurs, Wn+m-1 cannot be computed since mn + m— 1 is too large for x. (However, wnim—1 may be computable for larger values of 2.)

**Remark.** Even though PSIDF may be used for computing wo = --¥(z), its primary purpose is for computing the sealed derivatives w,(n > 1) of w(x). For x > 3, wy is accurate to within 2 units of the 14° significant digit. However, far less accuracy is frequently obtained when x < 3. In the worst case, all relative accuracy is lost for w. when z is sufficiently near the zero Zo = 1.4616... of y(z). For x < 3, the function PSI should be used for computing

Wz).

**Precision.** For 1 <n < 30 and x < 1000, w, is accurate to within 1.5 units of the 12** significant digit.

**Programming.** PSID® employs the functions IPMPAR, SPMPAR, EPSLN, and EXPARG. PSIDF 1s a modification by A. H. Morris of the subroutine PSIFN, written by Donald E.

Amos (Sandia Laboratories).

Reference Amos, D. E ,“Algorithm 610. A Portable Fortran Subroutine for Derivatives of the Psi Function,” ACAY Trans. Mati Software 9 (1983), pp. 494-502.


<small>Original source: [View scanned PDF page 72](scans/page_0072.png)</small>

<a id="topic-072-01"></a>
### Incomplete Gamma Ratio Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `GRATIO` | `SUBROUTINE` | `A, X, ANS, QANS, IND` | [`L13785`](source_parts/nswc_part_02.f90#L3200) |
| `RCOMP` | `REAL FUNCTION` | `A, X` | [`L14240`](source_parts/nswc_part_02.f90#L3655) |
| `DRCOMP` | `DOUBLE PRECISION FUNCTION` | `A, X` | [`L14288`](source_parts/nswc_part_02.f90#L3703) |
| `DGRAT` | `SUBROUTINE` | `A, X, ANS, QANS, IERR` | [`L14715`](source_parts/nswc_part_02.f90#L4130) |


For a > 0 and x > 0 let P(a,z) and Q(a,z) denote the functions defined by

1 * . P(a,z =a / e 43>! at (2) =a) J, _ 1 et pak On2) =575 | 2" ge~* dt.

Then 0 < P(a,z) < 1 and P(a,r) + Q(a,z) = 1. Also, P(a,z) > Land QO(a,z) — Ofer xz > 0 when a -+ 0. Hence, we may define P(0,xz) = 1 and Q(0,2) = C for zr > 0. The subroutines GRATIO and DGRAT are available for computing P(a,2) and Q(a,z2), and the auxiliary functions RCOMP and DRCOMP are provided for computing e~7z*/T(a).

```fortran
CALL GRATIO(A, X, ANS, QANS, IND)
```

It is assumed that @ > 0 and x > O, where a and z are not both 0. P and Q are variables. GRATIO assigns P the value P(a,z) and Q the value Qfa,x). The argument ¢ may be any integer. This argument specifies the desired accuracy of the results. If1 = 0 then the user is requesting as much accuracy as possible (up to 14 significant digits). Otherwise, if i = 1 then accuracy is requested to within 1 unit of the 6" significant digit, «1d if: # 0,1 then the accuracy is requested to within 1 unit of the 3" significant digit.

**Error Return.** P is assigned the value 2 when a or x is negative, when a = xz = 0, or when P(a,z) and Q(a,2) are indeterminant. P(a,2) and Q(a,z) are indeterminant when xz aan a is exceedingly large. On the CDC 6000-7000 series computers this occurs when |z/a ~ 1| < 107" and a > 6.6E25.

**Programming.** GRATIO calls the junctions ERP, ERFC1, REXP, RLOG, RCOMP, GAM1, GAMMA, and SPMPAR. GAMMA employs the functions GLOG, iSXPARG, and IPMPAR, GRATIO was written by A. H. Morris,

**Reference.** DiDonato, A. R. and Morris, A. H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Mats Software 12 (1986), pp. 377-398.

RCOMP (a, z) RCOMP(a,z) = e7*27/I'(a) for a > O and x > 0. Algorithm. See page 378 of the reference.

**Programming.** RCOMP employs the functions EXPARG, GAMMA, GAM]J, GLOG, and RLOG. These functions were written by A. H. Morris. The functions SPMPAR and iPM- PAR. are also used.


<small>Original source: [View scanned PDF page 73](scans/page_0073.png)</small>

Reference, DiDonato, A. R. and Morris, A. W., “Computation of the Incomplete Gamma Function Ratios and their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

```fortran
CALL DGRAT(A, X, ANS, QANS, IERR)
```

The arguments a and x are nonnegative double precision numbers, where a and « are not both G. P and Q ave double precision variables, and JERR an integer variable. When DGRAT is called, if P(a, x) and Q(a,x) can be computed then IERR is set tc 0 and P and Q are assigned the double precision values for P(a,«) and Q{a,z).

**Error Return.** If P(a,x) and Q(e¢,z} cannot be computed then /° is set to 2 aad IERR is assigned one of the following values: IERR = ¢ @ or # is negative. IERR=2ua=2=0. IERR = 3 Pla,z) and Q(a,x) are indeterminant. This setting occurs only when z a aad a is exceedingly large.

**Algorithm.** A modification cf the algorithm given in the reference is used. The functions e,(z) appearing in the Tenure Expansion on page 381 are computed by minimax approximations designed by A. H. Morris.

**Programming.** DGRAT employs the subroutines DGR26 and DGR17, and the functions IPMPAR, DPMPAR, DXPARG, DREXP, DRLOG, DSIN1, DERF, DERFC1, DERFC0, DGAMMA, DGAM1, DRCOMP, and DPDEL. DGRAT was written by A. H. Morris.

**Reference.** DiDonato, A.R. and Morris, A.H.,“Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math. Software 12 (1986), pp. 577-393.

```fortran
ORCOMP(a.z)
```

The arguments a and x are double precision numbers where a > O and xz > 0. DRCOMP(a,z) is the double precision value for e~7z°/T(a).

**Remark.** DKCOIMP must be declared to be of type DOUBLE PRECISIC. in the calling program.

**Programming.** DRCOK/' employs the functions IPMPAR, DPMPAR, DAPARG, DRLOG, DSINIL, DGAMMA, DGAMLE, and DPDEL. DRCOMP was written by A. H. Morris.


<small>Original source: [View scanned PDF page 74](scans/page_0074.png)</small>

<a id="topic-074-01"></a>
### Inverse Incomplete Gamma Ratio Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `GAMINV` | `SUBROUTINE` | `A, X, X0, P, Q, IERR` | [`L14341`](source_parts/nswc_part_02.f90#L3756) |
| `DGINV` | `SUBROUTINE` | `A, X, P, Q, IERR` | [`L15339`](source_parts/nswc_part_02.f90#L4754) |


For a > 0 and z > 0 let P(a,z) and Q(a,z) denote the incomplete gamma ratio functions defined by

P) _ 1 * —tya-— F (2) =i | et?" dt Q(a, x) = poet ae

```text
Then 0 < P(a,z) < 1 and P(a,z) + Q(a,r) = 1. If we are given a, p, and g where
a>0,0<p<1, and p+q=1, then the subroutines GAMINV and DGINV are available
for obtaining the value 2 > 0 for which P(a,z) = p and Q(a,z) =q.
```

```fortran
CALL GAMINV(A, X, X0, P, Q, IERR)
```

X is a variable. If p = 0 then X is assigned the value O, and if g = 0 then X is set to the largest floating point number available. Otherwise, if p 4 0 and g # 0 then GAMINV attempts to obtain a solution « for P(a,z) = p and G(a,z) = q that is correct to at least 10 significant digits.! If a solution is obtained then it is stored in X. The solution is normally computed by Schroder iteration. The argument zg is an optional initial approximation for x. If the user does not wish to supply an initial approximation then set ro < 0.

```text
IND is a variable that reports the status of the results. When GAMINV terminates,
IND has one of the following values:
```

IND = 0 The solution was obtained. Iteration was not used.

IND > 1 The solution was obtained. IND iterations were performed.

IND = -2 (Input error) a < 0.

IND = -3 No solution was obtained. The ratio Q/a is too large.

IND =: —4 (Input error) p<6,q<0,orp+q#1l.

IND = ~6 20 iterations were performed. The most recent value obtained for z is stored in X. This cannot occur if zg < 0.

IND = -7 Iteration failed. No value is given for 2. This may occur when zw 0.

IND = --8 A value for x is stored in X, but the routine is not certain of its

accuracy. iteration cannot be performed in this case. If zo < 0 then this can occur only when p + 0 or g # 0. If zo > 9 then this can occur when as x and a is exceedingly large (say a > 107°),

**Remark.** If ro < 0 then 3 or fewer iterations are required.

**Programming.** GAMINV employs the subroutines GRATIO and PNI, and functions ERF, ERFC1, ERFI, REXP, RLOG, ALNREL ,GAN MA, GLOG, GAMI, GAMLN, GAMELNI,

if a k digit floating point arithmetic is being used where & < 10, then the routine attempts to obtain a

solution that is correct to machine accuracy.


<small>Original source: [View scanned PDF page 75](scans/page_0075.png)</small>

RCOMP, EXPARG, IPMPAR, and SPMPAR. GAMINV was written by A. H. Morris.

**Reference.** DiDonato, A.R. and Morris, A.H., “Computation of the Incomplete Gamma Function Ratios and Their Inverse,” ACM Trans. Math Software 12 (1986), pp. 377-393.

```fortran
CALL DGINV(A, X, P, Q, IERR)
```

The arguments a, p, g are double precision numbers and X a double precision variable. If p = 0 then X is assigned the value ©, and if g = 0 then X is set to the largest double precision number available. Otherwise, i 9 AO and ¢ #40 then DGINV attempts to obtain a double precision solution z for P(a,z) = p and Q{a,z) = q that is correct to machine accuracy. If a solution is obtained then it is stored in X.

IND is a variable that reports the status of the results. When DGINV terminates, IND has one of the following values:

IND = 0 The solution was obtained. Iteration was not used.

IND > 1 The solution was obtained. IND iterations wei: performed.

IND = —2 (Input error) a < 0.

IND = —3 No solution was obtained. The ratio Q/a is too large.

IND = —4 (Input error) p< 0,¢ <O,orp+q#l.

IND = —6 10 iterations were performed. The most recent value obtained for x is stored in X. (This setting should never occur.)

IND = —7 Iteration failed. No value is given for 2. This may occur when zw.

IND = —8 A value for z is stored in X, but the routine is not certain of its

accuracy. Iteration cannot be performed in this case. This can occur only when p Oorg 30

**Remarks.** Schroder iteration is normally used. On the CDC 6000-7000 series computers 4 or fewer iterations are required.

**Programming.** DGINV employs the subroutines GAMINV, GRATIO, PNI, DGR17, DPNI, DGR29, and DGRAT, and functions RCOMP, DRCOMP, SPMPAR, DPMPAR, EXPARG, DXPARG, REXP, DREXP, ALNREL, DLNREL, RLOG, DRLOG, DSINi, ERF, EFRC1, DERF, DERFC1, DEFRCO, ERFI, DERFI, GAMMA, GLOG, GAM!, GAMLN, DGAM1, GAMLN1, DGAMMA, DPDEL, DGAMLN, DGMLN1, and IPMPAR. DGINV was written by A. H. Morris.


<small>Original source: [View scanned PDF page 76](scans/page_0076.png)</small>

<a id="topic-076-01"></a>
### Logarithm Of The Beta Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BETALN` | `REAL FUNCTION` | `A0, B0` | [`L13241`](source_parts/nswc_part_02.f90#L2656) |
| `DBETLN` | `DOUBLE PRECISION FUNCTION` | `A0, B0` | [`L13497`](source_parts/nswc_part_02.f90#L2912) |


For a,b > 0 the beta function B(a,b) can be defined by

1 B(a,b) = / e711 — t)?) de. 0 From this it follows that B(a,b) = ['(a)I'(b)/T(a + 6) where ['(a) is the gamma function. The functions BETALN and DBETLN are available for computing In B(a,b). DBETLN is a double precision function.

BETALN(a, 5) BETALN(a, 6) = In B(a, d) for a,b > 0.

**Algorithm.** See pages 19-21 of the reference.

**Precision.** BETALN(a,}) is accurate to within 4 units of the 14!" significant digit when a,b > 1 and BETALN(a, b) ¥ 0. In particular, when a,b > 15, BETALN(a, 6) is accurate to within 2 units of the 14‘ significant digit.

**Programming.** BETALN employs the functions ALNREL, ALGDIV, BCORR, GAMLN, GAMLNI1, and GSUMLN. These functions were written by A. H. Morris.

**Reference.** DiDonato, A. R. and Morris, A. H., “Algorithm 708 Significant Digit Computation of the Incomplete Beta Function Ratios,” ACM Trans. Math Software 18 (1992), pp. 360-373.

```fortran
DBETLN(A0, B0)
```

The arguments a and b are positive double precision numbers. DBETLN(a, 8) is the double precision value for In B(a,}).

**Remark.** DBETLN must be declared in the calling program to be of type DOUBLE PRECISION,

**Algorithm.** The algorithm for In B(a, 6) on pages 19-21 of the reference is used. A(z} is computed by the power series corresponding to the Chebyshev expansion in the SLATEC library given by Wayne Fullerton (Los Alamos). The power series was obtained by A. H. Morris

**Programming.** DBETLN employs the functions DLNREL, DLGDIV, DBCORR, DPDEL, DGAMLN, DGMLN1, DGAM1 and DGSMLN. These functions were written by A. Tl. Morris. The function DPMPAR is also used.

**Reference.** DiDonato, A. KR. and Morris, A. f., “Algorithm 708 Significant: Digit Compo:

tation of the Incomplete Het. Function Ratios,” ACM Trans. Math Software 18 P£OQ2), pp. 860-378.


<small>Original source: [View scanned PDF page 77](scans/page_0077.png)</small>

<a id="topic-077-01"></a>
### Incomplete Beta Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BRATIO` | `SUBROUTINE` | `A, B, X, Y, W, W1, IERR` | [`L15717`](source_parts/nswc_part_02.f90#L5132) |
| `BRCOMP` | `REAL FUNCTION` | `A, B, X, Y` | [`L16351`](source_parts/nswc_part_02.f90#L5766) |
| `ISUBX` | `SUBROUTINE` | `A0, B0, X0, P, IERR, EPS` | [`L17001`](source_parts/nswc_part_02.f90#L6416) |


For a,b > 0 and O < x < 1 the incomplete beta function is defined by

1

-—_- ° a—lfy _ 4\b-1 I, (a,b) = aan | t (1-4)? dt

where B{a,5) is the beta function. Then we note that 0 < J,(a,b} < 1 and

```text
lim, I,(a,b) = 1 for zr #0
lim f,(a, 6) =: 0 for x # 1.
```

These limits permit [,(a,b) to be defined to be i when a = C and b ¥ 0,z ¥ O, and for I, (a,b) to be defined to be 0 when b = O and a # 0,z # 1. The subroutine BRATIO is available for computing I,(a,b) for arbitrary a,b > 0, and the subroutine ISUBX is available for computing I,(a, 6) for the highly specialized case +i on a and 6 are integers or half-integers. Also, the auxiliary function P*:\COMP is provided for computing x?y°/B(a,b) when O<2<landy=1-z.

```fortran
CALL BRATIO(A, B, X, Y, W, W1, IERR)
```

It is assumed that a > 0,6 > 0,0 < x < 1, and y=1- 2. W, W1, and IERR are variables. If no input errors are detected then IERR is set to 0, W is assigned the value I,(a,6), and W1 is assigned the value 1 -- [,(a, 6).

**Error Return.** When an input error is detected, then W and W1 are assigned the value 0 and IERR is set to one of the following values:

IERR = bifa<O0orb<0

TERR = 2 if a=b=0

IERR = 8 ifs<Oorx> 1

IERR = 4 ify <Oory> 1

IERRs« 5 frty fl

TERR = 6 fe sae 0

IERR - 7 if yes 6 O Programming. BRATIO employs the subroutines BURAT and GRATI, and the functions ALGDIV, ALNREL, APSER, BASYM, BCORR, BETAUN, BFRAC, BPSER, BR.- COMP, BROMPI, BUP, ERF, ERFC1, FPSER, GAMLN, GAM™UNI, GAMI, GSUMLIN. PST, bSUM, PXPARG, ReXP, and RLOGI. These subroutines an functions were written by A. HL. Morris. The functions SPMPAR and IPMPAR are also ust

**Reference.** DiDonato, A. Ro ai Morris, A. HL, “Algorithm 708 Signi: ant Digit Compa tatiog of the Incomplete Beta Function Ratios,” ACM Trans, Mth S ‘tware t8 PEGgy, pp. 360.373


<small>Original source: [View scanned PDF page 78](scans/page_0078.png)</small>

```fortran
CALL ISUBX(A0, B0, X0, P, IERR, EPS)
```

```text
It is assumed that a,b, and x satisfy the following restrictions:
(1) a>0,6>0,andz2>0
(2) a > 1/2,1/2<b6<70,andz<1
(3) @ and 6 are integers or half-integers
```

EPS specifies the (absolute) accuracy that is desired. W is a real variable and IERR an integer variable. When ISUBX is called, if there are no input errors then W is assigned the value I,(a,6} and IERR is assigned the value 1.

**Error Return.** If an error is detected then IERR is assigned one of the following values:

```text
TERR = 2 if restrictions (1) are violated.
IERR = 3 if restrictions (2) are violated or a is too large.
IERR = 4 if re:irictions (3) are violated.
```

Also W is assigned the value 0. Remarks. ISUBX was designed for a maximum precision EPS = 10~!°

**Programming.** ISUBX employs the functions ALGDIV, ALNREL, BLND, IPMPAR, and LOGAM. ISUBX was written by A. H. Morris.

**Reference.** DiDonato, A. R. and Jarnagin, M. P., “The Efficient Calculation of the Incomplete Beta-function Ratio for Half-Integer Values of the Parameter a,b,” Math Comp. ‘1 (1967), pp. 652-662.

BRCOMP (a, b, x, y) BRCOMP(a, 6, z, y) =: z7y’ ‘B(a,8) for a,b > O and z,y 2» O where r+y = 1. Algorithm. See pages 19-21 of the reference. Programming. BRCOMP employs the functions ALGDIV, ALNREL, BCORR, BETALN, GAM1, GAMLN, GAMLN1, GSUMLN, and RLOG1. ‘These functions were written by A. ti, Morris. Reference. DiDonato, A. Rt. and Morris, A. tt, “Algorithm 708 Significant Digit Compu-

tation of the Incomplete Beta Function Ratios.” ACM Trans. Math Software 18 (1992), pp. 360 373,


<small>Original source: [View scanned PDF page 79](scans/page_0079.png)</small>

<a id="topic-079-01"></a>
### Bessel Function J_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSSLJ` | `SUBROUTINE` | `Z, CNU, W` | [`L17347`](source_parts/nswc_part_02.f90#L6762) |
| `BSSLJ` | `SUBROUTINE` | `A, IN, W` | [`L18033`](source_parts/nswc_part_02.f90#L7448) |
| `BESJ` | `SUBROUTINE` | `X, ALPHA, N, Y, NZ` | [`L18326`](source_parts/nswc_part_02.f90#L7741) |


If vy is complex then J,(z)} is defined by

wt kIT (v +k + 1)

for any z # 0 in the complex plane cut along the negative real axis. J,(z) is analytic in the region. jarg(z)| < 2, and J,(z) is an entire function of v for any fixed z. J,(z) can be extended to the negative real axis by letting ~m < arg(z) < x. If v is an integer then J,,(z) is also defined at O and is an entire function of 2. The following subroutines are available for computing J,{z).

```fortran
CALL CBSSLJ(Z, CNU, W)
```

The arguments z and v are complex numbers and w is a complex variable. It is assumed that z #0. When CBSSL, is called, w is assigned the value J,(z).

**Precision.** The real and imaginary parts of w are normally accurate to 11-12 significant digits when Re[J,(z)} and Im)J,(z)] are not near 0. The only exception tc this is when Re(z) x 0, Im(v) = 0, and 14 < jz! < 17.5+}4)v|?. Then Re(w) is accurate to 11-12 significant digits, but all accuracy for the small nonzero value Im(w) may be lost.

**Algorithm.** A modification of the Hershey procedure for applying the Maclaurin, Debye, and asymptotic expansions is used.

Programming. CBSSLJ employs the subroutines CREC, CGAMMA, CBJM, CBDB, CBJA aid functions (PPMPAR, SPMPAR, CPABS, CDIV, EXPARG, REXP, SIN1, COS], CGAMO, GAMMA, GLOG, CBSSLJ was written. by Andrew H. Van Tuyl and A. H. Morris.

**Reference.** Hershey, A. V., Computation of Special Functions, Report TR-3788, Naval Surface Weapons Center, Dahlgren, Virginia, 1973, pp. 33-42.

```fortran
CALL BSSLJ(A, IN, W)
```

The argument 7 is a complex number, n is an integer, and w is a complex variable. When BSSL,i is called, w is assigned the value J,,(z).

**Precision.** BSSLJ is accurate to within 5-10 !4 for realO <2 < 35 and n 0,1.

**Programmer.** A.V. Hershey

**Reference.** Hershey, A. V., Computation of Special Functions, Report TR-3788, Naval Surface Weapons Center, Dahlgren, Virginia, 1978.


<small>Original source: [View scanned PDF page 80](scans/page_0080.png)</small>

```fortran
CALL BESJ(X, ALPHA, N, Y, NZ)
```

The arguments z and @ are nonnegative real numbers, n is a positive integer, and W is an array of dimension n or larger. When BESJ is called J.4,;-1(z) is computed and stored in W(t) for f=1,...,n.

The argument k is an integer variable that is set by the routine. If all Ja4;—1(z) are computed then k is set to 0. Otherwise, k is assigned one of the following values:

k = ~—1 The argument z is negative.

k == ~2 The argument a is negative.

k = -—3 The requirement n > 1 is violated.

k> 0 The last k components of W have been set to 0 because of underflow,

**Precision.** For 0 < z < 35 and 0 < a < 1, BESJ is accurate to within 8- 107?%.

**Programming.** BESJ calls the subroutines ASJY and JAIRY, and the functions GAMLN, SPMPAR, and IPMPAR. The subroutines were written by Donald E. Amos, Sharon L. Daniel, and M. Katherine Weston (Sandia Laboratories).

**References.**

(1) Amos, D.E., Daniel, S. L., and Weston, M. K., CDC 6600 Subroutines for Bessel Functions J,(z),z > 0,v > Oand Airy Functions A,(z),Ai(x),—0o < < oo. Report SAND 75-0147, Sandia Laboratories, Albuquerque, New Mexico, 1975.

(2) ee , “CDC 6600 Subroutines IBESS and JBESS for Bessel Functions I, (x) and J,(z),z2 > 0,v > 0,” ACM Trans. Math Software 3 (1977), pp. 76-92.


<small>Original source: [View scanned PDF page 81](scans/page_0081.png)</small>

<a id="topic-081-01"></a>
### Bessel Function Y_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSSLY` | `SUBROUTINE` | `A, IN, W` | [`L19511`](source_parts/nswc_part_02.f90#L8926) |


If » is any complex number not an integer, then Y,(z) can be defined by

_ JL(z) cosux — J_,(z)

YL(z) =

sin vr

for any z # O in the complex plane cut along the negative real axis. For any integer n we can also define Y,,(z) = lim Y,(z). Then for any complex v, Y,(z) is analytic in the region von

jarg(z)| < x. Also, Y,(z) is an entire function of v for any fixed z. The following subroutine is available for computing Y,(z) when rv is an integer.

```fortran
CALL BSSLY(A, IN, W)
```

The argument z is a complex number, n is an integer, and w is a complex variable. It is assumed that larg(z)| < *. When BSSLY is called, w is assigned the value Y,,(z).

**Precision.** If .005 < z < .785 then Yo(z) and Yi (x) are accurate to within 3 units of the 14' significant digit. Otherwise, if z > .785 then Yo(z) and Y;(z) are accurate to within 4-107%4,

**Programmer.** A. V. Hershey

**Reference.** Hershey, A. V., Computation of Special Functions, Report TR-3788, Naval Surface Weapons Center, Dahlgren, Virginia, 1978.


<small>Original source: [View scanned PDF page 82](scans/page_0082.png)</small>

<a id="topic-082-01"></a>
### Modified Bessel Function I_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSSLI` | `SUBROUTINE` | `Z, CNU, W` | [`L19837`](source_parts/nswc_part_02.f90#L9252) |
| `BSSLI` | `SUBROUTINE` | `MO, A, IN, W` | [`L19888`](source_parts/nswc_part_02.f90#L9303) |
| `BESI` | `SUBROUTINE` | `X, ALPHA, KODE, N, Y, NZ` | [`L20202`](source_parts/nswc_part_02.f90#L9617) |


If v is complex then [,,(z) is defined by (z/2) yytek H(z) = 3 <kID(y +k +1)

for any z # 0 in the complex plane cut along the negative real axis. J,(z) is analytic in the region |arg(z)| < 7, and I,(z} is an entire function of v for any fixed z. [,(z) can be extended to the negative real axis by letting —x < arg(z) < m. If v is an integer then J,,(z) is also defined at (C and is an entire function of z. The following subroutines are available for computing J,,(z).

```fortran
CALL CBSSilI(z,, w)
```

The arguments z and v are complex numbers and w is a complex variable. It is assumed that z #0. When CBSSLI is called, w is assigned the value /,(z).

**Algorithm.** The evaluation of J,,(z) is reduced to J,(z) using

I,(z) = evri/2 J, (ze™ **/?) ~B< arg(z) <m T(z) eo ¥™? JT (ze™/?) - aw < arg(z) < §.

**Programming.** CBSSLI calls the subroutine CBSSLJ and functions EXPARG, COS1], and SINT. Also, the functions and subroutines needed for CBSSLJ are used. CBSSLI was written by Andrew H. Van ‘Puyl and A. H. Morris

CALL BSSLI(MO, z,n, w) MO ts an integer, z a complex number, n an integer, and w a complex variable. If MO f O then it is assured that jarg(z)}) «oo. When BSSLI is called, w is assigned the value

Liz} afMO | O and the value e 7/,(z2) 1f MO 7/9

Precision, BSSL!is accurate to within 5 unite of the 18" significant digit for realO <2 - and nm O,1,... AU.

**Programmer.** Allen V. Hershey

**Reference.** Hershey, A. V., Computation of Special Functions, Report TR-38788, Naval Surface Weapons Center, Dahlgren, Virginia, (978,

```fortran
CALL BESI(X, ALPHA, KODE, N, Y, NZ)
```

MO or may be bor 2.) The arguments rand @ are nonnegative real numbers, ris a

positive integer, and ous an array of dimension mn or larger. When BiSt is called, if MEO


<small>Original source: [View scanned PDF page 83](scans/page_0083.png)</small>

= 1 then [,4,-1(7) is computed and stored in W(t) for? = 1, ...,n. Otherwise, if MO = 2 then e~*/y4.4-1(z) is computed and stored in W(t}

The argument k is an integer variable that is set by the routine. If all Ja4,-1(z) or ¢-*I.44-1(z) are computed then k is set to 0. Otherwise, k is assigned one of the following values:

if]

= —l The argument z is negative. =: —2 The argument a is negative. - ~8 The requirement n > i is violated. —4 MO is not 1 or 2. = -5 The argument z is too large for MO = 1. > 0 The last k components of W have been set to 0 because of underflow.

i

i

k k k k k k

**Precision.** For 0 < 2 < 35 andO <a <l,or0 <2 < 35 and a= 1,2...,40, i,(z) is accurate to within 2 units of the 12‘ significant digit.

**Programming.** BESI calls the subroutine ASIK and the functions GAMLN, SPMPAR, and IPMPAR. BESI and ASIK were written by D. E. Amos and S. L. Daniel (Sandia Laboratories).

**References.**

(1) Amos, D. E. and Daniel, S. I., A CDC 6600 Subroutine for Bessel Functions I,(z),v > 0,2 > 0. Report SAND 75-0152, Sandia Laboratories, Albuquerque, New Mexico, 1975.

(2) Amos, D. E., Daniel, S. L., and Weston, M. K., “CDC 6600 Subroutines [BESS and JBESS for Bessel Functions I, (rx) and J,(x), r > 0, v > 0,” ACM Trans. Math Software 3 (1977), pp. 76-92.


<small>Original source: [View scanned PDF page 84](scans/page_0084.png)</small>

<a id="topic-084-01"></a>
### Modified Bessel Function K_v(z)

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBESK` | `SUBROUTINE` | `Z, CNU, W` | [`L20832`](source_parts/nswc_part_02.f90#L10247) |
| `CBSSLK` | `SUBROUTINE` | `Z, R, W` | [`L21481`](source_parts/nswc_part_03.f90#L276) |
| `BSSLK` | `SUBROUTINE` | `MO, A, IN, W` | [`L21989`](source_parts/nswc_part_03.f90#L784) |


If v is any complex number not an integer, then K,{z) is defined by

(*) K,(z) = 7 ee) -L@)

2 sin vr

for any z # 0 in the complex plane cut along the negative real axis. For any integer n we can also define K,,(z) = lim K,(z). Then for any complex v, K,(z) is analytic in the von

region |arg(z)| < a. Also, AK,(z) is an entire function of v for any fixed 2. K,(z) can be extended to the negative real axis by letting —*x < arg(z) < . The following subroutines are available for computing K,(z).

```fortran
CALL CBESK(Z, CNU, W)
```

The arguments z and v are complex numbers and w is a complex variable. It is assumed that z #0. When CBESK is called, w is assigned the value K,{z).

**Algorithm.** A,(z) is computed using (+), the asymptotic expansion

/ Ke) = (Fo) eth + Seay) 4

”) (4v? — 1) --- (4v? — (2k - 1)?) (0) eg

the relation

(2) Keyile) = 2 KV(2) + Reale)

along with the Miller algorithm and the power series Ki(z) - 32 cafe and K,41(z) k>O

€ “a

>> ce(pe ~ Kfe) given in the references, and the analytic continuation formulae a k>O

Ky{z) -e °K fe 2) -ami(e ™2z) (0 < arg(z) < 7)

Ky{z) oe’ KK (e"'z) + andy (e™*z) ( a + argfz) < 0). Precision. Frequently, 11 18 digit accuracy is obtained. Fer 10 ? © Jz) < 50, CBESK maintains accuracy to within 3 units of the 8"? significant digit except when RelA, (2)! or Im|{K L(2)] is near O, or occasionally when 2 is on the negative real axis. Leta atarae For 50 < lz) < 100, Refw) and Jm(w) are normally accurate to within 3 units of the 8" significant digit when, ™ Land ro 1/2. However, for £/2. 7) Land v not real, accuracy gradually decreases as jz] increases.

‘

Programming, CBESK employs the subroutines CBHKA, CBKI, CBRM, CBA ATE, CAPS,


<small>Original source: [View scanned PDF page 85](scans/page_0085.png)</small>

CGAMMA, CBSSLI, CBSSLJ, CREC and functions CDIV, CG AMO, COS0, COS1, SIN0, SIN1, CPABS, CXP, EXPARG, SPMPAR, IPMPAR. Also, the functions and subroutines needed for CBSSLJ are used. CBESK was written by Andrew H. Van Tuyl and A. H. Morris.

**References.**

(1) Amos, D.E., Computation of Bessel Functions of Complex Argument, Report SAND 83-0086, Sandia Laboratories, Albuquerque, New Mexico, i983.

(2) Temme, N.M., “On the Numerical Evaluation of the Modified Bessel Function of the Third Kind,” J. Comp. Physics 19 (1975), pp. 324--337.

```fortran
CALL CBSSLK(Z, R, W)
```

The argument z ig a nonzero complex number, ¢ 2 real number, and w a complex variable. When CBSSLK is called, w is assigned the value K,(z).

**Algorithm.** The algorithm employed by CBESi. is used. For real r, (+) is not needed.

**Programming.** CBSSLK employs the subroutines CBSSLJ, CKA, CKM, CKML, CREC and functions CPABS, COS0, CXP, GAM1, SIN0, SPMPAR, IPMPAR. Also, the functions and subroutines needed for CBSSLJ are used. CBSSLK was written by Andrew H. Van Tuyl and modified by A. H. Morris.

```fortran
CALL BSSLK(MO, A, IN, W)
```

MO is an integer, z a complex number, n an integer, and w a complex variable. It is assumed that |arg(z)| < *. When BSSLK is called, w is assigned the value K,,(z) if MO = 0 and the value e*A{,(z) if MO # 0.

**Precision.** BSSLK is accurate to within 6 units of the 14'* significant digit for real z and n-=-0,1.

**Programmer.** Allen V. Hershey.

**Reference.** Hershey, A. V., Computation of Special Functions, Report TR-37868, Naval Surface Weapons Center, Dahlgren, Virginia, 1978.


<small>Original source: [View scanned PDF page 86](scans/page_0086.png)</small>

<a id="topic-086-01"></a>
### Airy Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CAI` | `SUBROUTINE` | `IND, Z, AI, AIP, IERR` | [`L22238`](source_parts/nswc_part_03.f90#L1033) |
| `CBI` | `SUBROUTINE` | `IND, Z, BI, BIP, IERR` | [`L22627`](source_parts/nswc_part_03.f90#L1422) |
| `AI` | `REAL FUNCTION` | `X` | [`L23485`](source_parts/nswc_part_03.f90#L2280) |
| `AIE` | `REAL FUNCTION` | `X` | [`L23624`](source_parts/nswc_part_03.f90#L2419) |
| `BI` | `REAL FUNCTION` | `X` | [`L23761`](source_parts/nswc_part_03.f90#L2556) |
| `BIE` | `REAL FUNCTION` | `X` | [`L23955`](source_parts/nswc_part_03.f90#L2750) |


3

For any series w = ‘°° a,z" satisfying the differential equation w” = zw, it follows y La a

```text
n=0
that w = aof(z) + aig(z) where
```

1-4-+:(8n~2) ¢ z) = 1+ 35 -——. 7 He) n>1 (3n)!

g(z) = 1+ ESET

In particular, the Airy functions As(z) and Bi(z) are independent solutions of w” = zw where

Ai(z) = e1f(2) ~ ca9(2)

Bi(z) = v3 lei f(z) + c2g(z)]

for cy = 377/3/[(2/3) and cg = 371/3/P(1/3). Ai(z) and Bi(z) are entire functions.

The subroutines CAI and CBI are available for computing At(z) and Bi(z) when z is complex, aid the functions AI, ATE, BI, and BIE are available for computing A1(z) and Bi(z) when z is real. CAI and CBI also provide the derivatives Ai’(z) and Bi'(z) of Ar(z) and Bi(z).

```fortran
CALL CAI(IND, Z, AI, AIP, IERR)
```

IND is an integer, z a complex number, and w and w’ complex variables. When CAI is called, w is assigned the value As(z) and w’ the value At’(z) when IND = 0. Otherwise, if IND #0 then w = eS Ai(z) and w! = ef Ai'(z) where ¢ = 2239/2,

LERR is a variable that is set by the routine. When CAI terminates, IERR has one of the following values: tERR =: O The desired values were obtained. IERR = 1 z ts too large for the desired values to be computed. In this case w and wu’ are assigned the value 0. Precision. Fur IND 4 0 the real and imaginary parts of w and w’ are accurate to within 2 units of the '2'* significant digit except near points where they vanish.

**Programming.** CAI employs the subroutines AIRM, AIl, ATA, JA, oMC, BIM, KA, KML, IMC, and BIM. These routines were written by Andrew HE Van Tuy) and modified hy A. Uy Morris. The subroutines CAPO and CREC, and functions CPABS, EXPARG, IPMPAR, and SPMPAR are also used.

```fortran
CALL CBHIND 2,w, wu’ IRAN)
```


<small>Original source: [View scanned PDF page 87](scans/page_0087.png)</small>

IND is an integer, z a complex number, and w and w’ complex variables. When CBI is called, w is assigned the value Bi(z) and w’ the value Bs’(z) when IND = 0. Otherwise,

if IND #0 then _ { eS Bi(z) — if jarg(<)| < 1/3 ~ | eS Bi(z) otherwise _ { e~SBi'(z) if jarg(z)| < 1/3 ~ | ef Bi'(z) otherwise

where ¢ = 2 8/2

IERR is a variable that is set by the routine. When CBI terminates, IERR has one of the following values:

TERR = 0 The desired values were obtained. IERR = 1 z is too large for the desired values to be computed. In this case w and w’ are assigned the value 0.

**Precision.** For IND # 0 the real and imaginary parts of w and w’ are accurate to within 2 units of the 12" significant digit except near points where they vanish.

**Programming.** CBI employs the subroutines AIRM, BII, BIA, IA, IMC, BIM, JA, JMC, and BJM. These routines were written by Andrew H. Van Tuy! and modified by A. H. Morris. The subroutine CREC and functions CPABS, EXPARG, IPMPAR, and SPMPAR are also used.

Al(z)

Al(z) = At(z) for real 2.

**Algorithm.** Rational minimax approximations are used. If x < —1 then R and @ are computed where At(x) = 2 sin(a/4-+ 8).

**Precision.** For xc > - J, Al{z) is accurate to within 2 units of the 12¢" significant digit when » All g &

Al(z) #0.

**Programming.** Al calls the subroutine AIMP and function EXPARG. These subprograms were written by A. H. Morris. The function IPMPAR is also used.

```fortran
AIE(X)
```

If x > Othen AlM(2} > e At(z) where ¢ = 39/7. Otherwise, if 2 < 0 then AIF (2)

Algorithm.. rational minimax approximations are used. If a « Lthen Wand @ are computed where Artix) HR sinfoe /4 i @).

**Precision.** Fora > t, Allez) is accurate to within 2 units of the ¢4°? significant digit

i0O


<small>Original source: [View scanned PDF page 88](scans/page_0088.png)</small>

**Programming.** AIE calls the subroutine AIMP. AIE and AIMP were written by A. H. Morris.

Bi(z)

BI(z) = Bi(x) for real z. If z is a positive value for which Bi(z) is too large to be computed, then BI(z) is assigned the value 0.

**Algorithm.** Rational minimax approximations are used. If 2 < —1 then R and @ are computed where B1(r) = R cos(x/4 + 8).

**Precision.** For z > —1, BI(z) is accurate to within 2 units of the 12** significant digit when Bi(z) # 0.

**Programming.** BI calls the subroutine AIMP and function EXPARG. These subprograms were written by A. H. Morris. The function IPMPAR is also used.

```fortran
BIE(X)
```

If zc > 0 then BIE(z) = e~$ Bi(z) where ¢ = 223/?. Otherwise, if x < 0 then BIE(z) = Bi(z).

**Algorithm.** Rational minimax approximations are used. If 2 < --1 then R and @ are computed where Bi(x) = R cos(x/4 + 9).

**Precision.** For z > ~—1, BIK(z) is accurate to within 2 units of the 14‘ significant digit.

**Programming.** BIE calls the subroutine AIMP. BIE and AIMP were written by A. H. Morris.

10i


<small>Original source: [View scanned PDF page 89](scans/page_0089.png)</small>

<a id="topic-089-01"></a>
### Complete Complex Elliptic Integrals Of The First And Second Kinds

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CK` | `COMPLEX FUNCTION` | `K, L` | [`L24270`](source_parts/nswc_part_03.f90#L3065) |
| `CKE` | `SUBROUTINE` | `K, L, CK, CE, IERR` | [`L24646`](source_parts/nswc_part_03.f90#L3441) |


If k is complex then the complete elliptic integrals of the first and second kinds can be defined by

x/2 K(k) = i (1 — k? sin?t)~1/? de ) x/2 E(k) = / (i — k® sin?t)!/? de o for jarg(1 — k?)| < m. K(k) and E(k) can be extended to - < arg(1—k?) < x. For |k| <1

K(k) = So enk™

(1 - 1 n kin Bb) = — 9 Do ong 7 n>0 2n)! , where cy = ry . Also, if €? = 1 ~- k? where |€} < 1 and —x < arg(é”) < a, then ni

(2) B(k) = =[K (0) ~ B(0)] loge

m: noo

K(k) = K(O Ing - Seen re m(om 1) n en - 2

n>! ~ a sy cn D ay 2a ey =f -1 rif (2m - 1) t

_

The function CK js available for computing A (k), and the subroutine CK for computing K(k} and E(k).

CK (k, €)

CK(k, @) = K(k) for any complex k aud @where k? | #?) Land £4 0. CK is a complex valued function which must be declared in the calling program to be of type COMPLEX,

**Error Return.** CK(k. 0) Of For kh? OAD.

```text
Remarks.
(1) CK(A, &) may underflow, yielding the value O, when [Al is sufficiently large
(2) CI and the subroutine CAE employ the same algorithm for A (4)
```

1038


<small>Original source: [View scanned PDF page 90](scans/page_0090.png)</small>

**Precision.** If k is real and |k| < 1 then the relative error of CK is less than 10715. Also, if k is purely imaginary then the relative error is less than 10738. K(k) is real-valued for only these values of k. Otherwise, let ex = 1071? if |k| < 0.8,¢, = 2- 10713 if 0.8 < |k| < 2, and €, = 107}8 if |k| > 2. Then the relative errors of the real and imaginary parts of CK are less than €, except when underflow occurs, |k| < 1 and |arg(+:k)| < 107787, or |k{ < 1035 and |x/2—~— arg(tk)| < 10~*8°. In the latter two cases the relative error of the real part of CK is less than €,, but all relative accuracy for the imaginary part may be loss.

**Programming.** CK calls the subroutine KL and functions ALNREL, CFLECT, KM, and SPMPAR. Ck, KL, and KM were written by Andrew H. Van Tuy! and modified by A. H. Morris.

```fortran
CALL CKE(K, L, CK, CE, IERR)
```

The arguments k and @ are complex number: where k? + €? = 1 and £7 0,K and E are complex variables, and [ERR an integer variable. When CKE is called, if no errors are detected then TERR is set to 0, K is assigned the value K(k), and E is assigned the value

**Error Return.** IERR = 1 if €= 0 and IERR = 2 if k? + @? #1. In these cases, K and EF are not defined.

**Algorithm.** For & = 0 or ~1/2 < arg(k) < «/2, formulae (2) are used if |é| < .55, (1) are used if |@| > .55 and |kj < .55, and approximations of the form N

Na, K(k) = £7 5 Para

N . bak b,k ae | .

are t ed af [@) > 65 and .55 > [k] ~ Lo (3) are obtained from integral representations for K(k) and i(k) by numerical quadrature. If }é| > .55,|k] > 1, and [k] « |@ thes (4) (kK) B(k Y/e, fy. ii? are applied where the sign in Ay is selected so that) ow/2 © arg(k1) + mf2. Otherwise, if

OL HS, TR) 1, and [AL + [A det xy I/k and @y pr€/k where the sign is selected su that 2/2 < arg(#,) > 2/2. Then A(A) fyov(ky) ps A(e,)| (5) Athy) FP AAS) as (h(E) ADI (ELD)


<small>Original source: [View scanned PDF page 91](scans/page_0091.png)</small>

```text
are applied where ¢ = 1 if Im(k) > O and 9 = ~1 if Im(k) < 0. If arg(k) > 2/2 or
arg(k) < —7/2, then K(k) = K(~k) and #(k) = E(--k) are applied.
```

**Precision.** If & is real and {k| < 1, or & is purely imaginary, the he relative error of /y is less than 107'8. #k) is real-valued for only these values of k. Otherwise, let ¢, = 10°}? if of E are less than e, except when underflow occurs, [k| < 1 and jarg(+:&)| < 10°78, or [kj < 104® and | /2— arg(t+k)| ~ 107?®°. In the latter two cases the relative error of the real part of @ is teas than 2,, but all relative accuracy for the imaginary part may be lost.

**Programming.** CKE calls the subroutines EKI, and EKM, and the functions ALNREL, ATN, CF’ ECT, and SF MPAR. CKE wa: written by Andrew H. Van Tuyl,


<small>Original source: [View scanned PDF page 92](scans/page_0092.png)</small>

<a id="topic-092-01"></a>
### Real Elliptic Integrals Of The First And Second Kinds

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [`L25117`](source_parts/nswc_part_03.f90#L3912) |
| `DELLPI` | `SUBROUTINE` | `PHI, CPHI, K, L, F, E, IERR` | [`L25270`](source_parts/nswc_part_03.f90#L4065) |
| `RFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [`L25593`](source_parts/nswc_part_03.f90#L4388) |
| `DRFVAL` | `SUBROUTINE` | `X, Y, Z, RF, IERR` | [`L25712`](source_parts/nswc_part_03.f90#L4507) |
| `RDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [`L25832`](source_parts/nswc_part_03.f90#L4627) |
| `DRDVAL` | `SUBROUTINE` | `X, Y, Z, RD, IERR` | [`L25963`](source_parts/nswc_part_03.f90#L4758) |


1°0 < $< w/2, then the elliptic integrals of the first and second kinds are defined by

$ F(¢,*) =| (1 — k? sin?t)~'/? at 0

¢ E($¢,k) = | (1 ~ k* sin?t)!/? dé 0 for any real k wh ce k? < 1 and 1— k? sin?g #0. Alternatively, we may consider l oO Rp a,b,c) 5 / [( + @)(t-+ 8)(E + c)}~1/? de 0 where a,b,c are nonnegative and at mos. one of them is 0, and 3 “ i « Rp(a, b,c) == 5 / (t+ a)~ 2 (t + by 2 (t 4 ec) 9/? at JO

where a and 6 are nonnegative such that a+ > 0, and ¢ 1s positive. [fa <b <canda<c then

ect? Bc 8/4 [ apaoy

where cos & = afe and k? = (¢ ~ b)/(e ~ a). If @ = 2/2 then the integrals F(¢,&) and E(¢,k} are said to be complete. Otherwise, if ¢ < w/2 then the integrals are said to be incomplete. The subroutines ELLPI, REVAL, RDVAL, DELLPI, DRFVAL, and DRDVAL are available for computing £'(¢,&), E(¢,k), Re(a,6,c) and Rp(a,d,c). DELLPI, DRFVAL, and DRDVAL are double precision routines.

```fortran
CALL ELLP.(¢, ok. ¢ F, 2, IERR)
```

The arguments ¢, y,4, @ are rear numbers which satisfy ¢ - O.y * O,@ 1 bo #/2, and k? | @? 1. Also. if yp 9 06 then it is assumed that @ f O. FF) and TERR are variables When ELLPHis called. if ue input errors are detected then TREAT as set to 0, Fis assigned

the value #(¢, kj, aud /7 is assigned the value H(¢, k)

**Error Return.** Fo an input error is detected then PRR is set os lows: IERR - i @< 0 wy. 0 JERR . 2 jAl co) Toor if) > 1 IERR - S Ww Oand @> 0


<small>Original source: [View scanned PDF page 93](scans/page_0093.png)</small>

**Precision.** ELUPI is accurate to within 4 units of the 14" significant digit.

**Programming.** ELLPI calls the functions ALNREL and CPABS. ELLPI was written by Allen V. Hershey and modified by A. H. Morris.

**Reference.** DiDonato, A. R. and Hershey, A. V., “New Formulas for Computing Incomplete Elliptic Integrals of the First and Second Kind,” JACM 6 (1959), pp. 515-526.

```fortran
CALL RFVAL(X, Y, Z, RF, IERR)
```

The arguments 2, b,c are nonnegative real numbers, only one of which can be 0. IERR and w are variables. When RFVAL is called, if no input errors are detected then IERR is set to 0 and w is assigned the value Rp(a, b,c).

**Error Return.** If an input error is detected then IERR has one of the following values: IERR = 1 Either a,b, or c is negative.

```text
IERR = 2 Either a+ 6,a+c, or b+ ¢ is too small.
IERR = 3 Either a,b, or c is too large.
```

**Precision.** RFVAL is accurate to within 4 units of the 14" significant digit.

**Programming.** REVAL was written by B. C. Carlson and Elaine M. Notis (Iowa State Universit: \, and modified by A. H. Morris. The function SPMPAR is used.

**References.** (1) Carlson, B. C., “Computing Elliptic Integrals by Duplication,” Numerische Mathematik 33 (1979), pp. 1-16. and Notis, E. M., “Algorithm 577. Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398-403.

(2)

```fortran
CALL RDVAL(X, Y, Z, RD, IERR)
```

The arguments a and 6 are nonnegative real numbers where a + 6 > 0, anJ «is a positive real number. JERR and w are variables. When RDVAL is called, if no input errors are detected then JERR is set to O and w is assigned the value Rp(a, b,c).

**Error Return.** If an input error is detected then HERR has one of the following values:

IERR = | Either a,6, or ¢ is negative. JERR 2 Either a-+ 6 or ¢ is too small. [ERR - 3 Either a,b, or ¢ is too large.

Precision. RDVAL is accurate to within 4 units of the 14" significant digit

**Programming.** RDVAL was written by B.C. Carlson and Elaine M. Notis (Iowa State University), and modified by A. H. Morris. The function SPMPAR is used.


<small>Original source: [View scanned PDF page 94](scans/page_0094.png)</small>

**References.**

(1) Carlson, B. C., “Computing Elliptic Integrals by Duplication,” Numerische Mathematik 33 (1979), pp. 1-16.

(2) and Notis, E. M., “Algorithm 577, Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398-403.

```fortran
CALL DELLPI(PHI, CPHI, K, L, F, E, IERR)
```

The arguments ¢, ), k, £ are double precision numbers where ¢ > 0, > 0,¢+-p = 7/2, and k? + é? = 1, Also, if » =O then it is assumed that @4 0. F and E are double precision variables, and IERR is an integer variable. When DELLPI is called, if no input errors are detected then IERR is set to 0, F is assigned the double precision value for F({¢,k), and # is assigned the double precision value for E(¢, k).

```text
Error Return. If an input error is detected then IERR is set as follows:
IERR = 1¢<O0ory<0O
IERR = 2 |k| > 1 or [i > 1
IERR = 3 py =Oand @=0
```

**Precision.** DEI LPI is accurate to within 5 units of the 28'" significant digit.

**Programming.** DELLPI employs the functions DCPABS, DLNREL, and DPMPAR. DELLPi was written by Allen V. Hershey and modified by A. H. Morris.

**Reference.** DiDonato, A. R. and Hershey, A. V.,“New Formulas for Computing Incomplete Elliptic Integrals of the First and Second Kind,” JACM 6 (1959), pp. 515-526.

```fortran
CALL DRFVAL(X, Y, Z, RF, IERR)
```

The arguments a,6,c are nonnegative double precision numbers, only one of which can be 0. TERR is an integer variable and w a double precision variable. When DRFVAL is called, if no input errors are detected then IERR is set to 0 and w is assigned the double precision value for Rr(a, 6,c).

**Error Return.** if an input error is detected then JERR has one of the following values:

```text
IERR = 1 Either a,6, or c is negative.
TERR =: 2 Either a + 6,a-+ c, or 6 ¢ cis too small.
IERR =: 3 Either a, 6, or ¢ is too large.
```

**Programming.** DRFVAL was written by B.C. Carlson and Elaine M. Notis (Iowa State University), and modified by A. H. Morris. The function DPMPAR is used.

**References.** ‘Carlson, B. C., “Computing Elliptic Integrals by Duplication,” Nurmerssche Mathei) Carl B.C., “Com; g belly Integrals by Dupl N he Math matik 33 (1979), pp. 1 16.


<small>Original source: [View scanned PDF page 95](scans/page_0095.png)</small>

(2) and Notis, E. M., “Algorithm 577, Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398-403.

```fortran
CALL DRDVAL(X, Y, Z, RD, IERR)
```

The arguments a and b are nonnegative double precision numbers where a-+ b > 0, and ¢ is a positive double precision number. IERR is an integer variable and w a double precision variable. When DRDVAL is called, if no input errors are detected then IERR is set to 0 and w is assigned the double precision value for Rp(a, },c).

```text
Error Return. If an input error is detected then IERR has one of the following values:
[ERR = 1 Either a, 8, or c is negative.
IERR = 2 Either e+ 6 or ¢ is too small.
IERR = 3 Either a, 6, or c is too large.
```

**Programming.** DRDVAL was written by B. C. Carlson and Elaine M. Notis (Iowa State University), and modified by A. H. Morris. The function DPMPAR is used.

**References.**

(i) Carlson, B. C., “Computing Elliptic Integrals by Duplication,” Numerische Mathematik 33 (1979), pp. 1-16.

(2) _____ and Notis, E. M., “Algorithm 577, Algorithms for Incomplete Elliptic Integrals,” ACM Trans. Math Software 7 (1981), pp. 398--403.


<small>Original source: [View scanned PDF page 96](scans/page_0096.png)</small>

<a id="topic-096-01"></a>
### Real Elliptic Integrals Of The Third Kind

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [`L25422`](source_parts/nswc_part_03.f90#L4217) |
| `DEPI` | `SUBROUTINE` | `PHI, CPHI, K2, L2, N, M, P, IERR` | [`L25507`](source_parts/nswc_part_03.f90#L4302) |
| `RJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [`L26094`](source_parts/nswc_part_03.f90#L4889) |
| `DRJVAL` | `SUBROUTINE` | `X, Y, Z, P, RJ, IERR` | [`L26249`](source_parts/nswc_part_03.f90#L5044) |


For any 0 < ¢ < 1/2 the elliptic integral I{¢,n, x) is defined by ¢ II(¢,n,k) = / (1 — nsin? 6)~1(1 — k? sin? 6)~ 3d0 0

where n is any real number such that 1 — nsin? ¢ 4 0, and & any real number such that k? <1 and 1—k?sin?¢40. Alternatively, for any r 7 0 we may consider

3 f° ; R,(a,b,c,r) = > (tr) ie + a)(t + b)(t-+6)]~ tae 0

where a,b,c are nonnegative and at most one of them is 0. If a <6< c anda <_ec then

_3 Ry(a,b,c,r) = ey lili m) ~ F($,k)]

nsin where F(¢, k) is the elliptic integral of the first kind, cos? ¢ = a/c,k? = (c — b)/(¢ -- a), and n== (c~r)/(c — a). lf 6 = /2 then the elliptic integral II(¢,n, k) is said to be complete. Otherwise, if ¢ < w/2 then the integral is said to be incomplete. The subroutines EPI, RJVAL, DEPI, and DRJVAL are available for computing II(¢,n,k) and Ry(a,b,c,r). DEPI and DRJVAL are double precision routines.

```fortran
CALL EPI(PHI, CPHI, K2, L2, N, M, P, IERR)
```

The arguments ¢,y, k?,@?,n,m are real numbers where ¢ > 0, > Od + n/2, hk? p €7 2 9, |nf < 1, and n tom. 1. Also, if w -- 0 then it is assumed that €? 4 0 and m 7 (. TERR and w are variables.) When EPI is called, if no input errors are detected then IERR is set to O and w is assigned the value II(d,n, &).

**Error Return.** if an input error is detected then TERR has one of the following values: IERR ot Either @ or yo is negative, or @ bof #2. HERR © 2 Hither inf > borm fom 4 4. IFRR | 3 Either &? or €? is negative, or k? 4 6? / 1. IFRR 4 Either Y and mi are too close to O, or y and €? are too close to 0 peth

**Precision.** EF Piis accurate to within 4 units of the surmibesnt dipat

Programming Eb PLemploys the subroutines, REVAL, RIVAL, ROVALE and function SPM PAI. LPT was written by AH. Morris

```fortran
CALL RJVAL(X, Y, Z, P, RJ, IERR)
```

The arguments a,6,¢ are nonnegative real numbers, only one of which can be O, and r

isa positive real number. TR RR and w are variables. When RIVAL os called. ufino raprt


<small>Original source: [View scanned PDF page 97](scans/page_0097.png)</small>

errors are detected then IERR is set to 0 and w is assigned the value Rj(a,},c,r).

```text
Error Return. If an input error is detected then TERR has one of the following values:
TERR = 1 Either a,},c, or r is negative.
[ERR = 2 Either a+ b,a+-,6-+-c, o'r is too small.
JERR == 3 Either a,b,c, or r is too large.
```

**Precision.** RJVAL is accurate to within 4 units of the 14‘ significant digit.

**Programming.** RJVAL calls the subroutine RCVAL1. These subroutines were written by B.C, Carlson and Elaine M. Notis (Iowa State University), and modified by A.B. Morris. The function SPMPAR is also used.

**References.**

(1) Carlson, B. C., “Computing Elliptic Integrals by Duplication.” Numerische Mathematik 33 ('979), pp. 1--16.

(2) = and Notis, E. M., “Algorithm 577,Algorithms for Incomplete Elliptic Integrals.” ACM Trans. Math Software 7 (1981), pp. 398-403.

```fortran
CALL DEPI(PHI, CPHI, K2, L2, N, M, P, IERR)
```

The arguments ¢, w, k?, £?,n,m are double precision numbers where ¢ > 0, > 0,¢ + y= 0/2, k? + €? = 1, |n| < 1, and n+m= 1. Also, if y = 0 then it is assumed that @? 4 0 and m # 0. IERR is an integer variable and w a double precision variable. When DEPI is called, if no input errors are detected then IERR is set to 0 and w is assigned the double precision value for TI(@, n, k).

```text
Error Return. If an input error is detected then 1ERR has one of the following values:
IERR = 1 Either ¢ or » is negative, or 6+ ¢ 4 1/2.
IERK = 2 Hither |n| > torn+m#1.
IERR = 3 Either k? or €? is negative, or k? -+ €? 4 1,
TERR = 4 Either p and m are too close to 0, or w and €? are too close to 0.
```

**Programming.** DEPI employs the subroutines DRE VAL, DRJVAL, DRCVL1 and function DPMPAR. DEPI was written by A.H. Morris. CALL DRJVAL(o, b,c,r, w, JERR) The arguments a,b,c are nonnegative double precision numbers, only one of which can be 0, and r is a positive double precision number. HERR is an integer variable and w a double precision variable. When DRJVAL is called, if no input errors are detected then TERE is set to O and wis assigned the double precision vie for Ry{a,4,e,r).

**Error Returns.** If an input error is detected then TERR has one of the following values:

JERR = 1 Either a,6,c, or r is negative.

pay

IeRR = 2 Either a@ } b,a 4 oe,60 + ¢, or r is toe small,


<small>Original source: [View scanned PDF page 98](scans/page_0098.png)</small>

TERR == 3 hither a,6,c, or r is too large.

**Programming.** DRJVAL calls the subroutine DRCVL1. These subroutines were written by

B.C. Carlson and Elaine M. Notis (Iowa State University), and modified by A.H. Morris. The function DPMPAR is also used.

**References.**

(1) Carlson, B. C., “Computing Elliptic Integrals by Duplication.” Numerische Mathematik 33 (1979), pp. 1-16. (2)

_ and Notis, E. M., “Algorithm 577,Algorithms for Incomplete Elliptic Integrals.” ACM Trans. Math Software 7 (1981), pp. 398-403.


<small>Original source: [View scanned PDF page 99](scans/page_0099.png)</small>

<a id="topic-099-01"></a>
### Jacobian Elliptic Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ELLPF` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [`L26616`](source_parts/nswc_part_03.f90#L5411) |
| `ELPFC1` | `SUBROUTINE` | `U, K, L, S, C, D, IERR` | [`L27022`](source_parts/nswc_part_03.f90#L5817) |


For any complex number k # 0,+1 the elliptic function sn(z,#) may be defined as the meromorphic function w(z) that satisfies

(42) = wy He

¢

(4)

w(0) = 0, w'(0) = 1.

) If k = 0 then sn(z,0) = sin z satisfies (1), and if k = -:1 then an(z,k) = tanhz satisfies (1). Alternatively, sn(z,k) = sind where ¢(z) satisfies

dp\* 2. (2) (<2) = 1-k*sin' ¢ #0) =9, (0) =1.

The elliptic functions en(z,k) and dn(z,k) may be defined by

dn(z,k) = \/1 — k?sn(z, ky?

where the roots take the value 1 for z = 0. In particular, if & =: 0 then en(z,0) == cosz and dn(z,0) = 1, and if k = +1 then en(z,k) = dn(z,k) = 1/cosh~. The subroutines ELLPF and ELPFC1 are available for computing sn(z, k&),cn(z,b), and da(z,k) when & is a real value such that [ki < 1. ELLPF may be used when z is real and ELPFC1 when z is complex.

```fortran
CALL ELLPF(U, K, L, S, C, D, IERR)
```

It is assumed that u,k, and @ are real numbers where k*? } €? -- 1. S,C, and D are real variables. When ELLPF is called, S,C, and D are assigned the values S ~ sn(u,k), C = en(u,k), and D.. dn(n,k).

JERR ts a variable that reports the status of the results. When the routine terminates, TERK has one of the following values:

IERR = 0 ‘The elliptic functions were computed.

IERR 4 (Input error) k* +) @? 1.

TERR. 2 «is too large for k

When JERR & 1, no computation is performed.

**Precision.** Let A(k) be the complete elliptic integral of the first kind. For [Ay < .99995 the relative errors of sn(u,k) and dn(u,k) are less than 10 1? when O © u < Ak), and the 12 when O~ us 9TH (kK).

relative error of cn(u,k) is less than 10


<small>Original source: [View scanned PDF page 100](scans/page_0100.png)</small>

**Algorithm.** Let K = A(k) be the complete elliptic integral of the first kind. For O < u < K/2 (when € # 0), the Maclaurin expansion

(1+ k7)u> (14 14k? + kt)u an(u, k) =u a a

```text
is employed when u < .01. Otherwise, if u > .01 let K’ = K(é), q = exp(—7K'/K), and
r= exp(--7K/&'). Then
```

Qn Ss gute | (2n41)ru

en(u, k) == kK a ]—qintl sin OK n>0 is used when k < @ and 7 Tu w(-1)?r?? | Oru sn(u,k) = ER? tanh anit 2» iyi sinh Ki

is used when k > @. The functions cn{u,k) and dn(u, &) are obtained from

```text
sn(u,k)? + en(u,k)? = 1
dn(u,k)? + k?sn(u,k)? = 1.
```

For K/2<u< K the identities

```text
sn(u, k) = en(v,k)/dn(v, k)
cn(u,k) = [éisn(v, k)/dn(v, k)
dn(u,k) = |é|/dn(v, k)
```

are applied. Here v = HW -- u.

**Programming.** ELLPF employs the subroutines SCD, SCDF, SCDJ, SCDM, ELLPI, SNHCSH and functions ALNREL, CPABS, SPMPAR, IPMPAR. ELLPF was written by Andrew H. Van Tuyl and modified by A. H. Morris.

```fortran
CALL ELPFC1(U, K, L, S, C, D, IERR)
```

The argument z is complex, and k and @ are real numbers where k? + €? = 1. S,C, and D are complex variables. When ELPFC1 is called S,C, and D are assigned the values Ss» gn(z,k), C = enfz,k), and D> dn(z,k).

JERR is a variable that reports the status of the results) When the routine terminates, IER has one of the following values:

IERR — O The elliptic functions were computed,

[ERR OT (Input error) A? 4 © of 4.

PRR © 2 zis too large for &.

JERR -- 3 zis a pole for the elliptic functions.


<small>Original source: [View scanned PDF page 101](scans/page_0101.png)</small>

When JERR > 1, no computation is performed.

**Precision.** Let x = Re(z), y = Im(z}, K = K(k) be the elliptic integral of the first kind for k, and K’ = K(é). For |k| < .99995 the relative errors of the real and imaginary parts of sn(z,k) are less than 1071? when 0 < z < K and 0 < y < .992K’, and the relative errors of the real and imaginary parts of cn(z,k) and dn(z,k) are less than 107?? when O<2< 97K andO<y< 97K’.

**Algorithm.** For z = 2 + ty let s = en(z,k) 8, = sn(y, 2) ec = en(z,k) cy, = en(y, 2) d = dn(z,k) d, = dn(y, £) and D = c3 + k*s?s?. Then an(z,k) = (sd, + teds,c,)/D en(z,k) = (cc, — #sds,4,)/D dn(z,k) — (deyd, — tk? scs;)/D are applied when D # 0. Programming. ELPFC1 calls ELLPF, which employs the subroutines SCD, SCDF, SCDJ,

SCDM, ELLPI, SNHCSH and functions ALNREL, CPABS, SPMPAR, IPMPAR. ELPFC1 was written by Andrew H. Van Tuyl.


<small>Original source: [View scanned PDF page 102](scans/page_0102.png)</small>

<a id="topic-102-01"></a>
### Weierstrass Elliptic Function for the Equianharmonic and Lemniscatic Cases

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PEQ` | `SUBROUTINE` | `Z, W, IERR` | [`L27121`](source_parts/nswc_part_03.f90#L5916) |
| `PEQ1` | `SUBROUTINE` | `Z, W, IERR` | [`L27166`](source_parts/nswc_part_03.f90#L5961) |
| `PLEM` | `SUBROUTINE` | `Z, W, IERR` | [`L27213`](source_parts/nswc_part_03.f90#L6008) |
| `PLEM1` | `SUBROUTINE` | `Z, W, IERR` | [`L27260`](source_parts/nswc_part_03.f90#L6055) |


Lei w and w’ be complex numbers where Im(w’/w) > 0, and Wm, = 2mw + 2nw’ for all integers m,n. Then for any complex z, the Weierstrass elliptic function P(z;w,w') can be

defined by t 1 P(z;w,w’) gt yo i oet

(z- - Wmn) Whan

where &’ denotes the sum for all m,n = 0,+1,+2,... except m=n = 0. If w= re’? and w! = r'e® where ¢! = $46 for 0 < @ < 2, then the restriction Im(w’/w) > 0 is equivalent to assuming that 0 < 0 < m. P(z;w,w’) is analytic everywhere except at the points Wmn, which are poles, and

P(z+2w;w,w') = P(z; wu, w'

P(z+ 2w';w,w’) = P(z,w,w’) for all z. The relations

P(-2;w,w') = P(z;w,w’)

P(dAz; Aw, Aw’) = AW? Pz; w,w') AAO also hold. A somewhat surprising fact is that only the values gg = 602'wy4 and gz = 1400/w76 are needed for computing P(z; w,w’) at a point z. Hence, P(z; w, w’) is frequently denoted I by P(z392,93). For A A0

g2(Aw, Aw’) = Av*go(w, w’)

g3(Aw, Aw’) = 48 g3(w, w’) also hold. We now consider the following cases:

(1) Equianharmonic (gz = 0 and gg is a positive real number)

```text
(2)  Lemniscatic (gz is a positive real number and g3 = 0)
(1) occurs when 2w = § ~ YB and 2w! = $+ By, and (2) occurs when 2w = 1 and
2w! = 4. The following subroutines are available for computing P(z; w, w’) and its derivative
P'(z;w,w') for these two choices of (w, w’).
```

```fortran
CALL PEQ(Z, W, IERR)
```

The argument z is a complex number, e is a complex variable, and IER is an integer variable. It is assumed that the periods are 2w =: 5 ~ v3 4 and 2w! = ‘ 4. ran . When PEQ is called, if z is not a pole then TERE is assigned the value 0 and e is assigned the value

P(z;w,w’). Error Return. !f z 0 wy, for some m,n then INR is assigned the value I and e = 0.

**Precision.** If |P(z;w,w’)| ~ i then the absolute error is less than 7-10 18. Otherwise, the

relative error ig less than 7. FO FS

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.


<small>Original source: [View scanned PDF page 103](scans/page_0103.png)</small>

**References.**

(1) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Mati: Software 4 (1980), pp. 112-i20.

\- ee ,“A Rational Approximation to Weierstrass’ P-Function,” Math Comp. 30 (1976), pp. 818-826.

```fortran
CALL PEQ1(Z, W, IERR)
```

The argument z is a complex number, e is a complex variable, and IERR is an integer

variable. It is assumed that the periods are 2w = ; - v3; and 2w’ = 5+ vB, When PEQ1

is called, if z is not a pole then JERR is assigned the value 0 and e is assigned the value P'(z; w,w’).

**Error Return.** If z = wmy for some m,n then IERR is assigned the value 1 and e = O.

**Precision.** If |P’(z; w,w’)| < 1 then the absolute error is less than 7-10-15. Otherwise, the relative error is less than 7- 10719.

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.

**References.**

(i) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Math Software 4 (1980), pp. 112-120.

(2) sss “A Rational Approximation to Weierstrass’ P-Function,” Math Comp. 30 (1976), pp. 818-826.

CALL PLEM(z, e, IERR) The argument z is a complex number, ¢ is a complex variable, and LERR is an integer variable. It is assumed that the periods are 2w = 1 and 2w! = 1. When PLEM is called, if z is not a pole then TERR is assigned the value 0 and e is assigned the value P(z;w,w').

**Error Return.** If z == wm, for some m,n then IERR is assigned the value ! and e =: 0.

**Precision.** If |P(z;w,w’)| < 1 then the absolute error is less than 6- 10713. Otherwise, the relative error is less than 6-107 !9.

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.

**References.**

(1) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Math Software 4 (1980), pp. 1f2 120.


<small>Original source: [View scanned PDF page 104](scans/page_0104.png)</small>

(2) ____, “A Rational Approximation to Weierstrass’ P-Function. II: The Lemniscatic Case,” Computing (Arch. Elektron. Rechnen) 18 (1977), pp. 341-348.

```fortran
CALL PLEM1(Z, W, IERR)
```

The argument z is a complex number, ¢ is a complex variable, and [ERR is an integer variable. It is assumed that the periods are 2w =: 1 and 2w’ = +. When PLEM1 is called, if z is not a pole then IERR is assigned the value O and e is assigned the value P’(z; w, w’).

**Error Return.** If z = Wamp, for same m,n then IERR is assigned the value 1 and e = 0.

**Precision.** If |P’(z;w,w’)| < 1 then the absolute error is less than 6 10713. Otherwise, the relative error is less than 6 - 10715.

**Programming.** Written by Ulrich Eckhardt (University of Hamburg, West Germany). Modified by A. H. Morris.

**References.**

(1) Eckhardt, Ulrich,“Algorithm 549, Weierstrass’ Elliptic Functions,” ACM Trans. Math Software 4 (1980), pp. 112-120.

(2) ,»“A Rational Approximation to Weierstrass’ P-Function. II: The Lem-

niscatic Case,” Computing (Arch. Elektron. Rechnen) 18 (1977), pp. 341-349.


<small>Original source: [View scanned PDF page 105](scans/page_0105.png)</small>

<a id="topic-105-01"></a>
### Integral of the Bivariate Density Function over Arbitrary Polygons and Semi-Infinite Angular Regions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `VALR2` | `SUBROUTINE` | `X, Y, N0, P, IOP, A, IND, KO` | [`L27310`](source_parts/nswc_part_03.f90#L6105) |


Given a sequence of points », = (z,,y)(f = 1,...,n +1) where n > 3 and Vy41 = Vy. Let r denote the polygon whose boundary @r is a polygonal line which begins at point v1, traverses the points v, in the order that they are indexed, and is the straight line segment connecting v; to ¥;4, for each t = 1,...,n where y, 4 %41. Then the subroutine VALR2 is available for computing the integral

1 2 2 P(r) -: — — (2° +y")/2 g. (7) == 5 IE xdy

r

and the associated function A(r) = ff dzxdy. If the boundary @7 is a simple positively

_ (negatively) oriented closed curve, then P(r) and A(r) are positive (negative) and |A(r)| = the area of r. However, Or need not be simple. It may be self-intersecting or have overlapping line segments. If AQ, is the angle between the vectors vy ~ Ww_; and 441, — 4% (where Vo = v,), then it may occur that A@, -: m fur some t, in which case a portion of the polygon may be degenerate. In general, —x < A6; < m for each 1 where the sign of the angle is positive (negative) if the angle is measured in a counterclockwise (clockwise) direction from

a) vy Wy to 441 ~ 4. VALR2 also computes the value k(r) ~ a y Aé,, which is an

t=1 integer. If the boundary is a simple closed curve, then k(r) is the winding number of the curve around any interior point of the polygon r.

Alternatively, assume that we are given three points v, — (z.,y¥,)(¢ = 1,2,3) and let 4é denote the angle between the vectors vz - vy and v3 v;. In this case, assume that the angle A@ is measured in a counterclockwise direction from V2 - by to vg: vy, so that O< O¢ < 2m. Let € denote the straight line beginning at point 71 and passing through point, v2, and let @ denote the straight line beginning at v; and passing through v3. Then the subroutine VALR2 is also available for computing P(r) when 7 is the semi-infinite angular region bounded by @ and é, and having the angle A@, 0 P(r) ~ 1 for any angular region t, and P(r) > 1 when A@ >» 2m.

is . !

. -— Angular region 1 . oN Ae

a

```fortran
CALL VALR2(X, Y, N0, P, IOP, A, IND, KO)
```

The argument. m is either Lor the number of points involved in defining a polygon If n f then it is assumed that 7 is a semi-infinite angular region defined by the points vy (ay) (f 1,23), and that NY and VY are arrays containing. 2), fy,ta and yay ye, ye Otherwise, if n / To then it is assumed that a is a polygon defined by the poms +

13 ae


<small>Original source: [View scanned PDF page 106](scans/page_0106.png)</small>

(ti, 4) (¢ = 1,...,n+ 1) where n > 3 and v4, = 44. In this case, X and Y are arrays containing the abscissae z1,...,%,4 1 and ordinates y1,...,Yn¢i. Since Yai, = vy, the values 2,41 and yny1 need not be supplied by the user. The routine automatically stores x, and y; in X(n + 1) and Y(n +1).

P, A, and k are variables. If n = 1 then P is assigned the value P(r) for the angular region 7 and A is assigned the value 0. In this case, k is not defined. Otherwise, if n > 3 then P is assigned the value P(r), A is assigned the value A(r), and k is assigned the value k(x) for the polygon r.

IOP is an input argument which specifies the (relative) precision to which P{r) is to be computed. IOP is set to 1, 2, or 3 for 3, 6, or 9 decimal digit accuracy.

```text
IND is the variable that reports the status of the results. The routine assigns IND one
of the following values:
IND = ’ The desired values were obtained.
IND = 1 {Input error) 1; is either equal to vz or v3, or is too close to v2 or
v3 to compute P(r) for >e angular region r. In this case, P is set
```

to 5.

IND = 2 The desired values were obtained. If n = 1 then A@ x x. Otherwise, if n > 3 then |AQ,| ~ m for some ¢.

IND = 3 (Input error) E Either n < Lorn = 2.

**Remarks.** VALR2 can be used for computing the integral of the general bivariate density function over an arbitrary polygon or semi-infinite angular region 7. Consider

where B = (1 - p?)>1/?/(2n0V02), (44,Hs) is the mean, o, and o, are the (nonzero) variances, and p is the correlation coefficient satisfying |p| <1. Consider also

oy tlw pe z fz Zz pz x 7) 2 p and oy . Oz | oO, Since this transformation maps straight lines into straight lines, 7 is mapped ont a polygon

or angular region 7 and we obtain P(7) P(r). Moreover, if 7 is a polygon ten A(7)

Jf dds g tal p* A(z).

**Programming.** VALR2 employs the functions ERE, ERFC1, and SPMPAR. VALR2 was designed by Armido R. DiDonato and Richard K. Hageman, and modified by A. H. Morris.

**Reference.** Gilonate, A. Ro, and Hageman, Ro K , Computation of the Integral of the Dia variate Normal Distribution over Arbitrary Polygons, Report TR 80.166, Naval Surface Weapons Center, Dahlgren, Virginia, £980.


<small>Original source: [View scanned PDF page 107](scans/page_0107.png)</small>

<a id="topic-107-01"></a>
### Circular Coverage Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CIRCV` | `SUBROUTINE` | `R, D, J, P, IERR` | [`L27598`](source_parts/nswc_part_03.f90#L6393) |


The subroutine CIRCV is available for computing the circular coverage function P(R, d) and the generalized circular error function V(K,c). V is the integral of an uncorrelated elliptical Gaussian distribution with standard deviations o, and oy, over a circle of radius Ko, centered at the mean of the distribution. If o, > o, then

1 K 6 gg? v(K)= 2 fi [exp{ Ze [4 et + (1 ~ 2%) cove] | r doar

where c = o,/oz. P is the integral of a circular Gaussian distribution with common standard deviation o over a circle of radius Ro whose center is offset a distance de from the mean of the distribution.

1 of” f?* P(R,d) = an / [ exp {-3 [(d + rcos@)? + r? sin? 6] \ rd0dr )

40 Alternatively,

K V(K,c) = ! / e Br" 1(Ar?)rdr (ce # 0) 0

c.

R P(R,d) > Qn] e !?Iy(ed)r dr i) where A (1 ¢?)/(4e?), B= (1 + ¢?)/(4e7), and Ig is the modified Bessel function of the first kind and order 0. Since V(K,c) + erf(K/\/2) when ¢ + 0, we may define V(K,0) — erf(K/y/2).

```fortran
CALL CIRCV(R, D, J, P, IERR)
```

The argument ¢ may be any integer. If O then the arguments a and a are assumed to have the values ¢ © A anda oocwhere A > O and 0%. ¢* 1. Otherwise, if / 0 then r Randa dwhere BR > Oand d > 0.

IER and tw are variables. When CERCY as called, fino input errors are detected then IP RR is assigned the value 0. Also, w = W{A,ye) if) Oandw PCR, d)ifia 7 0.

Error Return. Hoan input error is detected then TERR is set as follows: TERR For Ois not satisfied, IE RK 20-0 e. bord + Ois not satisfied

When either of these errors is detected, was assigned the value I

Precision [ft Qthen owas accurate te within Lounit of the PS'P significant digit when VON eo) os not near OQ) Otherwise, fa ¢ O them tis accurate to within fourm of the ppb

significant digit when (Ald) is not near 4


<small>Original source: [View scanned PDF page 108](scans/page_0108.png)</small>

**Algorithm.** If AK? < t4 then V(K,c) = SO. 7T, is employed where

oyn>0

2a 2 go — _l pv BK 1 | -BK “O ~ Tepe To = g.pil- 2 f - _ { AK? _. 2n-1 A? AK? A\ Ak? Sa = (4°) Syo1 Ty = “tn BT Tao. - \ ine + 4) “on Snot (n ? 1).

Otherwise, if AK? > 14 then the asymptotic expansion V(K,c) = 1~ e7K’/? ono Mn is used where 7

-2; - My =: Fe eric( & a: wd. 2. 2 - 1 é (5) zy ee Ke &6=-Vl-e _. On-1 _¢? - Un l 2n-} Masi = ees 1 Soy (rn ~ M,) Inti = In 4AK? Tn (n > 1).

~

If 2 < 1.7 or Rd < 16 then P(R,d) > S054 7, is employed where Th Oe i ety, 2 | 6 d?/2 0 y RP/2.

Otherwise, if Rd > 16 and R >» 1.7 then the asymptotic expansion

re ik d t 1 3 1} te 7 (8; ¢ s2)] if Rod

eT ee ee fy. Hyd y> oN wo is used where z [A di/V2, 1 aed Seo May 82 Siied yoy Tn, and ; 1 Pa 7 wei Af, e erfe(z) - zn loan ot iT oe » . Fav an aka 7 Mavi on aralta 7 My) (n° I).

**Programming.** CIRCV employs the functions ERE, ERECE, ERROR, EXPARG, GAMMA, GAMI, GLOG, RCOMP, REXP, RLOG and subroutines HRECO, GRATIO. The functions SPMPAR and IPMPAR are also used) CIROV was written by Armido Ro DiDonato aid modified by A. H. Morris

**References.**

(1) DiDonato, ALR | Bee Statistical Programs in BASIC for Desktop Computers, Report NSW UP r 83.03) Naval Surface Weapons Center, Dahlgren, Virginia, Pose

(2) and Jarnagin, MP, A Method for Computing the Generalized Circular Error Function and the ¢ areular Coverage Function, Report P78, Naval

Weapons Laboratory, Dahlgren, Virginia, 62


<small>Original source: [View scanned PDF page 109](scans/page_0109.png)</small>

<a id="topic-109-01"></a>
### Elliptical Coverage Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PKILL` | `SUBROUTINE` | `R0, SX, SY, H, K, P` | [`L28000`](source_parts/nswc_part_03.f90#L6795) |


The subroutine PKILL is available for evaluating the integral of an uncorrelated elliptical Gaussian distribution over the area A of a circle (x — h)* + (y—k)? = R?. The probability to be computed is given by

1 L/z? y? P(R,oz,0y,h,k) = Inasa0 II. exe|-3( 5 + “)I dz dy

v

where ¢z is the standard deviation in the z direction and oy is the standard deviation in the y direction. Then

P(R, a2, 0,,h,k) = P(R,oy,o2,k,h),

P(R,oz,0,,h,k) = P(R, oz, oy, |Al,|k]), and

P(R,02,0,,h,k) = P(aR, aoz, aoy, ah, ak)

for any a> 0. Also P=Q when R= 0. CALL PKILL(R,oz,0,,h,k, P)

R,o;,,0,,h,k are real numbers and P is a variable. Jt is assumed that R > 0, oz > 0, and a, > 0. When PKILL is called, P is assigned the value P(R,oz,0,,h,k).

**error Return.** P = --107° ifo, <Ooro, <0.

**Precision.** P is accurate to within 1 unit of the 6" significant digit when P > 107?° and |i, |k|, VA? + k? are not near R.

**Programming.** PKILL employs the subroutine GRATIO and functions SPMPAR, ERF, IPMPAR, EPSUN, EXPARG, REXP, RLOG, ERFC, ERFC1, AERF, GAMMA, GAMI, GLOG. PKILL was written by Armido R. DiDonato.

**Reference.** DiDonato, A. R., Significant Digit Computation of the Elliptical Coverage Function, Report NSWC TR 90 513, Naval Surface Warfare Center, Dahlgren, Virginia, 1990.


<a id="category-110"></a>
## Polynomials

<small>Original source: [View scanned PDF page 110](scans/page_0110.png)</small>

<a id="topic-110-01"></a>
### Copying Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PLCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [`L28473`](source_parts/nswc_part_03.f90#L7268) |
| `DPCOPY` | `SUBROUTINE` | `A, KA, M, B, KB, N` | [`L28500`](source_parts/nswc_part_03.f90#L7295) |


m--1 . If p(x) = > a;2? and the coefficients a; are stored in an array A, then the following j=0 subroutines are available fer copying the first n coefficients a, into an array B.

```fortran
CALL PLCOPY(A, KA, M, B, KB, N)
CALL DPCOPY(A, KA, M, B, KB, N)
```

A and & are arrays. PLCOPY is used if A and B are real arrays, and DPCOPY is used if A and B are double precision arrays.

The arguments m,n, ka, kb are positive integers. The coefficients a; are ¢ sumed to be stored in A where A(1+7-ku) = a; for 7 = 0,1,...,m-- 1. The routine stores the first n coefficients a; in B where B(1 + 7-kb) = a, for 7 =0,1,...,n—-1.

Note If n>m then B(1+7-kb) = 0 for 7 > m.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 111](scans/page_0111.png)</small>

<a id="topic-111-01"></a>
### Addition Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28527`](source_parts/nswc_part_03.f90#L7322) |
| `DPADD` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28550`](source_parts/nswc_part_03.f90#L7345) |


```text
ted ; mot . . ; .
If p(x) = 24 a;z? and q(x) = ds b;27 then the following subroutines are available for
=C y=
computing the first n coefficients of the polynomial p(z) 4- q(x) = ar cx),
```

```fortran
CALL PADD(A, KA, L, B, KB, M, C, KC, N)
CALL DPADD(A, KA, L, B, KB, M, C, KC, N)
```

A, B and C are arrays. PADD is used if A, B and C are real arrays and DPADD is used if A, B and C are double precision arrays.

The arguments ¢,m,n,ka,kb,ke are positive integers. The coefficients a; and 5; are assumed to be stored in A and B where A(l+j-ka} =a; (7 =0,1,...,@~1) B(L+j-kb) = 6; (7 =0,1,...,m~1). The routine stores the first n coefficients c; of p(x) + q(x) in C where C(1 +-j-ke) = cy for jJ=O0,1,...,n-1.

**Remarks.** The array C' nay begin in the same location as A or B. If C begins in the same location as A then it is assumed that ke =: ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that ke = kb. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 112](scans/page_0112.png)</small>

<a id="topic-112-01"></a>
### Subtraction Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28573`](source_parts/nswc_part_03.f90#L7368) |
| `DPSUBT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28596`](source_parts/nswc_part_03.f90#L7391) |


£-1 m-- 1 : If p(z) = 33 a;: q{z) == 33 6,2? then the following subroutines are available for j=0 pd computing the first, ; ients of the polynomial p(x) ~ q(x) = 30, ¢;27. CALL PSU'S) ka, ¢, B, kb, m,C, ke, n) CALL DPSWUE I A, ka, é, Bj kb,m,C, ke, n) A, B and C are ari: PSUBT is used if A, B and C are real arrays and DPSUBT is used if A, B and C are! ble precision arrays. The arguments f, ka,kb,ke are positive integers. The coefficients a; and 6; are assumed to be stored nd B where A(l + 7+ka} (7 =0,1,...,8- 1) B(1 + 7-kb) (7 =0,1,...,m—1).

```text
The routine stores the si 1 coefficients c, of p(x) — q(z) in C where C(1 + y-ke) == ¢; for
j=0,1,...,n-1.
```

**Remarks.** The array C may begin in the same location as A cr B. If C begins in the same location as A then it is assumed that kc = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that kc = kb. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. More's.


<small>Original source: [View scanned PDF page 113](scans/page_0113.png)</small>

<a id="topic-113-01"></a>
### Multiplication Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28619`](source_parts/nswc_part_03.f90#L7414) |
| `DPMULT` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N` | [`L28661`](source_parts/nswc_part_03.f90#L7456) |


t—1 : m—1 , If p(z) = 30 ayx? and g(x) = > 6,27 then the following subroutines are available for gr g=0

computing the first n coefficients of the polynomial p(x)q(z) = Dy c,x).

```fortran
CALL PMULT(A, KA, L, B, KB, M, C, KC, N)
CALL DPMULT(A, KA, L, B, KB, M, C, KC, N)
```

A, B and C are arrays. PMULT is used if A, B and C are real arrays and DPMULT is used if A, B and C are double precision arrays.

The arguments £,m,n,ka,kb,ke are positive integers. The coefficients a; and b, are assumed to be stored in A and B where A(l+j-ka} =a; (f= 0,1,...,€-1) BIL + j+kb) = 6; (7 =0,1,...,m— 1). The routine stores the first n coefficients cy of p(z)q(x) in C where C(1 + j-ke) = cy for g=0,1,...,2-1.

**Remarks.** It is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 114](scans/page_0114.png)</small>

<a id="topic-114-01"></a>
### Division Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [`L28703`](source_parts/nswc_part_03.f90#L7498) |
| `DPDIV` | `SUBROUTINE` | `A, KA, L, B, KB, M, C, KC, N, IERR` | [`L28761`](source_parts/nswc_part_03.f90#L7556) |


```text
t-) ; m—J .
If p(z) = 3) a;z? and qg(z) = 35 6,27 where bo # 0, then the following subroutines
g=0 p20
are available for computing the first. n coefficients of the series p(z)/q(z) = 2, C52).
```

```fortran
CALL PDIV(A, KA, L, B, KB, M, C, KC, N, IERR)
CALL DPDIV(A, KA, L, B, KB, M, C, KC, N, IERR)
```

A, B and C are arrays. PDIV is used if A, B and C are real arrays and DPDIV is used if A, 8 and C are double precision arrays.

The arguments £,m,n,ka,kb,ke are positive integers. The coefficients a; and 5; are assumed to be: stored in A and B where A(l+jka)=a; (7 =0,1,...,0-1) B(1 + 7-kb) = b, (7 =0,1,...,m— 1). TERR is a variable. When the routine is called, if b) 4 0 then IERR is assigned the value O and the first n coefficients c; of p(x)/q(x) are stored in C where C(1 + j-ke) = c,; for 7 =O0,l,...,n-1.

**Error Return.** JERR = 1 if bp = 0. In this case, ac computation is performed. Remarks. It is assumed that the array C does not overlap with the arrays A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 115](scans/page_0115.png)</small>

<a id="topic-115-01"></a>
### Real Powers Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [`L28818`](source_parts/nswc_part_03.f90#L7613) |
| `DPLPWR` | `SUBROUTINE` | `R, A, KA, M, B, KB, N, IERR` | [`L28875`](source_parts/nswc_part_03.f90#L7670) |


```text
m-1 :
If r is real and p(x) = $5 a;z’ where ag > Q, then the following subroutines are
g=0
available for computing the first n coefficients of the series p(x)" = ; b,x).
```

CALL PLPWR(r, A, ka, m, B, kb,n, JERR) CALL DPLPWR(r, A, ka, m, B, kb, n, JERR) A and 8 are arrays. PLPWR is used if A and B are real arrays and r a real number,

and DPLPWR is used if A and B are double precision arrays and r a double precision number,

The arguments m,n, ka, kb are positive integers. The coefficients a; are assumed to be stored in A where A(1+ j-ka) = a; for 7 = 0,1,...,m— 1. TERR is a variable. When the routine is called, if ag > 0 then IERR is assigned the value 0 and the first n coefficients b; of p(x)" are stored in B where B(1 + j-kb) = b; for j =0,1,...,n—1.

**Error Return.** IERR = 1 if ap < 0. In this case, no computation is performed.

**Remark.** It is assumed that the arrays A and B do not overlap.

**Algorithm.** If ¢ = p" then pg’ = rqp' where p’ and q’ are the derivatives of p and q. ;

Consequently, 6; = = So (ri+a—- j)a,;b;_, is used for j > 1. Also bo = a}.

340

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 116](scans/page_0116.png)</small>

<a id="topic-116-01"></a>
### Inverses Of Power Series

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PINV` | `SUBROUTINE` | `A, D, N, Q` | [`L28931`](source_parts/nswc_part_03.f90#L7726) |
| `DPINV` | `SUBROUTINE` | `A, D, N, Q` | [`L28992`](source_parts/nswc_part_03.f90#L7787) |


Given an analytic function w = f(z) = >> ayz* where f(0) =: 0. Then the inverse i>1 function z = f~!(w) exists when a; 4 0, and f~'(w) = 3 djw*. The subroutines PINV i>

and DPINV are available for obtaining the coefficients d, when the coefficients a; are real. DPINV is a double precision routine.

```fortran
CALL PINV(A, D, N, Q)
CALL DPINV(A, D, N, Q)
```

If PINV is called then A, D, and WK are real arrays. Otherwise, if DPINV is called then A, D, and WK are double precision arrays.

It is assumed that n > 2. Ais an array containing the coefficients a;,...,a, and D is an array of dimension n. When PINV or DPINV is called, the coefficients dy, ...,d, are computed and stored in D.

WK is an array of dimension n(n + 1)/2 or larger. WK is a work space for the routine. Programmer. A. H. Morris.

**Reference.** Chang, Feng-cheng,“Power Series Unification and Reversion,” Applied Math and Computation 23 (1987), pp. 7-23.


<small>Original source: [View scanned PDF page 117](scans/page_0117.png)</small>

<a id="topic-117-01"></a>
### Derivatives And Integrals Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MPLNMV` | `SUBROUTINE` | `MO, AU, NC, AC, FV` | [`L29053`](source_parts/nswc_part_03.f90#L7848) |


n--} . Let f(z) = 5) ayz* be a polynomial with real coefficients a,. The polynomial can be

a0 differentiated and integrated by the following subroutine:

```fortran
CALL MPLNMV(MO, AU, NC, AC, FV)
```

A is an array containing the coefficients a, where A(t) = ay_1 fort = 1,...,n. The argument Zo is an arbitrary real number and w is a variable. MO may have the values ~1,0,1,2. When MPLNMV is called w is assigned the value:

```text
( f2f(a)dx if MO=-1
f (zo) ifMO= 0
f'(co) ifMO= 1
feo) ifMO= 2
```

if

Programmer, Allen V. Hershey.


<small>Original source: [View scanned PDF page 118](scans/page_0118.png)</small>

<a id="topic-118-01"></a>
### Evaluation Of Chebyshev Expansions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSEVL` | `REAL FUNCTION` | `X, A, N` | [`L29112`](source_parts/nswc_part_03.f90#L7907) |
| `DCSEVL` | `DOUBLE PRECISION FUNCTION` | `X, A, N` | [`L29140`](source_parts/nswc_part_03.f90#L7935) |


```text
for any complex number z and integer n = 0,1, ... let
To(z) =3 1, Ti(z) =z
```

Ta42(2) = 22zTa4i(z) — Tr(z).

Then 7,(z) is a polynomial of degree n having the leading coefficient 2"~'! when n > 1.

Also Tn(t) =: cos(n@) when t = cos0(G < 0 < m), so that |7),{t)| < 1 for real t where

|t} < 1. The polynomials 7,,{z) are called the Chebyshev polynomials (of the first kind). If -1

f(z) = ao/2+ >> a;T,(x) where a, is real, then the following functions are available for computing f(z) when z is real. CSEVL(z, A,n)

It is assumed that n > } and that A is an array containing ao, 1, ...,@,—1 where A(t) == ay-1(¢ = 1,...,n). Then CSEVL(2, A,n) == f(z) for any real z.

**Programmer.** A. H. Morris. DCSEVL(z, A,n) It is assumed that n > 1 and A is a double precision array containing @9,41, ...,@n—1 where A(i) = a;3(f = 1, ...,n). Then for any double precision value x, DCSEVL(z, A,n)

is the double precision value of f(z).

**Remark.** DCSEVL must be declared in the calling program to be of type DOUBLE PRECISION.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 119](scans/page_0119.png)</small>

<a id="topic-119-01"></a>
### Lagrange Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LGRNGN` | `SUBROUTINE` | `AU, NA, AN` | [`L29167`](source_parts/nswc_part_03.f90#L7962) |
| `LGRNGV` | `SUBROUTINE` | `MO, NA, QU, AU, AN, FF, DF, SF` | [`L29193`](source_parts/nswc_part_03.f90#L7988) |
| `LGRNGX` | `SUBROUTINE` | `AU, NA, AC` | [`L29312`](source_parts/nswc_part_03.f90#L8107) |


Let ay, ...,@n be n distinct real numbers. Then the t** Lagrange polynomial is defined by

(a; — a4) (a; ~ a2) +++ (ay ~ as—1) (ay — as4i) +++ (as — Qn)

```text
for? = 1,2, ...,n. The Lagrange polynomials have the property that ¢;(a,) = 1,¢,;(a;) = 0
n
for 7 #1, and p(x) = >> p(a,)¢,(zr) for any polynomial of degree n ~— 1. For convenience,
t=1
```

dy = (a; — a1) (a; ~ a2) +++ (ay — ag-—1) (ay — spi) +++ (ay — an) is called the normalization divisor of ¢,(r). The following subroutines are available for

computing the Lagrange polynomials and their normalization divisors.

```fortran
CALL LGRNGN(AU, NA, AN)
```

A and D are arrays of dimension n. The arguments a), ...,@, are given in the array A. The normalization divisors d,, ...,d, are computed by the routine and stored in D.

**Programmer.** Allen V. Hershey.

```fortran
CALL LGRNGV(MO, NA, QU, AU, AN, FF, DF, SF)
```

A and D are arrays of dimension n. The arguments a;,...,@, are given in A and the normalization divisors d,,...,d¢, are given in D. The argument zo is an arbitrary real number and F,DF,ODF are arrays of dimension n.

The argument MO may take the values 0,1,2. If MO = 0 then the polynomials ¢,(z) are evaluated at rq and the values ¢,({zo) stored in F. If MO = 1 then the function ¢,(z) and its derivative $/(z) are computed at zo. In this case, ¢,{r0) is stored in F(1) and ¢{ (zo) is stored in DF(t) for s = 1,...,n. Similarly, if MO = 2 then the function ¢,(2) and its first and second derivatives are computed at x9. The values ¢,(zo) are stored in F, the first derivatives are stored in DF, and the second derivatives are stored in DDF.

**Note.** If MO = O then DF and DDF are ignored by the routine. Similarly, if MO. 1 then DDF is ignored.

**Programmer.** Allen V. Hershey.

```fortran
CALL LGRNGX(AU, NA, AC)
```

Ais an array of dimension n and © an array of dimension n»® (n } 1}. The arguments

y | & @y,...,@, are given in A. The purpose of the routine is to compute the coefficients ¢,, of the Lagrange polynomials

mood ™ : i & Bt) do eerie”. k oO


<small>Original source: [View scanned PDF page 120](scans/page_0120.png)</small>

When LGRNGX is called, the coefficients of $;(z) are stored in the j** column of C for j <n. Also, the first n coefficients of the polynomial

g(x) = (2 — a1) +++ (2 - ay) are stored in the (n + 1)** column of C.

**Programmer.** Allen V. Hershey.


<small>Original source: [View scanned PDF page 121](scans/page_0121.png)</small>

<a id="topic-121-01"></a>
### Orthogonal Polynomials On Finite Sets

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ORTHOS` | `SUBROUTINE` | `AU, MA, AA, NA, AR` | [`L29367`](source_parts/nswc_part_03.f90#L8162) |
| `ORTHOV` | `SUBROUTINE` | `MO, NA, AU, AR, NF, FF, DF, SF` | [`L29451`](source_parts/nswc_part_03.f90#L8246) |
| `ORTHOX` | `SUBROUTINE` | `NA, AR, NC, AC` | [`L29510`](source_parts/nswc_part_03.f90#L8305) |


Let uz, ...,U, be n distinct real numbers. For any real-valued functions ‘,g defined

a

```text
on the points u, let (f,g) = 35 f(us)g(us). Then (f,g) is an inner product when f and
t=1
```

g are regarded as functions defined only on u;. Thus, an orthonormal set of polynomials

{¢0, 1, --.,¢n—1} exists where the degree of ¢; 18 7 for 7 < n. The polynomials ¢, are defined recursively by

```text
1
oy4i1(u) = a. [(u ~ b;)6;(u) — a;-.16;-1(u)]
where a; = ($541, u¢;) and 6; = (¢;,u¢,). Here it is assumed that ¢.; = a_, = 0 and
do(u) = 1/\/n. The following subroutines are available for computing these polynomials.
```

```fortran
CALL ORTHOS(AU, MA, AA, NA, AR)
```

U is an array containing the values u,,...,u, and m is an integer such that 1 < m <n. P is an array of dimension n x m and R an array of dimension 2m — 2. When OQRTHOS is called, ¢;~1(u,;) is computed and stored in P(t,7) fort <n and j < m. Also the coefficients ao, bg, 41,6), ...,dm—2,6m-—2 are stored in R.

**Programmer.** Allen V. Hershey. CALL ORTHOV(MO,n, u, Ry m, F,DF,DDF) The argument u is a real number and m an integer such that 1 <m <n. BR is an

array containing the coefficients ag,6y, 4), 6), ...,@m-2,bm. 2 and PDE DDF are arrays of

dimension ma.

MO may take the values 0,1,2. If MO O then @o,¢@1,-.-.¢m . are evaluated at u and the values ¢, 1(u) stored in F. If MO I then ¢, 1 and its derivative @, are computed at u. In this case, 6, y(t) is stored in P(g) and ob (4) Is stored in DE() for y 1, ...,m. Similarly, if MO 2 then d, , and its first and second derivatives are evaluated at u. The values @, (1) are stored in F', the first derivatives are stored an DF,

and the second derivatives are stored in DDE.

**Note.** [fMO | O then DF and DDE are ignored by the routine. Similarly, if MO 1 then DDF is ignored.

**Programmer.** Allen Vo Hershey

```fortran
CALL ORTHOX(NA, AR, NC, AC)
```

The argument sais an integer such that bosom: on Alois an array containing, Clie

coefficients du,bo,ay, by, yn 2.4), pg and Coan array of dimension vs ra The purpose


<a id="category-122"></a>
## Solutions of Nonlinear Equations

<small>Original source: [View scanned PDF page 122](scans/page_0122.png)</small>

<a id="topic-122-01"></a>
### Zeros Of Continuous Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ZEROIN` | `REAL FUNCTION` | `F, AX, BX, AERR, RERR` | [`L29554`](source_parts/nswc_part_03.f90#L8349) |
| `DZERO` | `DOUBLE PRECISION FUNCTION` | `F, AX, BX, AERR, RERR` | [`L29685`](source_parts/nswc_part_03.f90#L8480) |


Let F(z) be a continuous real-valued function defined for a < x < 6, and assume that F(a) and F(b) have opposite signs. Then the following functions are available for finding a point z in the interval {a, 6] for which F(z) = 0.

```fortran
ZEROIN(F, AX, BX, AERR, RERR)
```

F(x) is a user defined function whose arguments and values are assumed to be real numbers. ZEROIN returns a value z in the interval [a, 6] for which F(x) = 0.

AERR and RERR are the absolute and relative tolerances to be satisfied (AERR. > 0 and RERR > 0). One may set RERR = 10~* if it is desired that x be accurate to k significant decimal digits. If RERR = 0 then it is assumed that machine accuracy is desired.

**Remark.** F must be declared in the calling program to he of type EXTERNAL.

**References.**

(1) Brent, Richard, Algorithms for Minimization without Derivatives, Prentice-Hall, 1973.

(2) Forsythe, G.E., Malcolm, M.A., and Moler, C.B., Computer Methods for Mathematical Computations, Prentice-Hall, 1977.

**Programming.** ZfROIN is a slightly modified translation of the ALGOL 60 procedure ZERO given in reference (1). The code was distributed by G. FE. Forsythe, M. A. Malcolm, and C. B. Moler (University of New Mexico), and modified by A. HE. Morris. The function SPMPAR is used.

```fortran
DZERO(F, AX, BX, AERR, RERR)
```

The arguments og, 6, AE RK, and RERR are double precision numbers, and P(x)is a user defined function whose arguments and values are assumed to be double precision numbers. DZERO returns a double precision value x in the interval ja,6! for which F(z) 0.

} [4,0 }

AERR and RERE are the absolute and relative tolerances to be satisfied (AERK > Qand RERR » 0). One may set RERK 10 * if it is desired that 2 be accurate to & significant decimal digits. [IP RERR 0 then it is assumed that machine accuracy is desired

**Remarks.** Pomust be declared in the calling program to be of type DOUBLE PRECISION and EXTERNAL, and DAR RO must be declared to be of type DOUBLE PRECISION

**References.**

```text
(1) Brent, Richard, Algorsthmae for Minimization utthout Dertvatirues, Prontice- Hall,
Lo7s
(2) Porsythe, G bo, Mialeolm, MOA | and Moler CoB) Computer Methods for Afatherat
```

seal Computations, Prentice tall, 1977


<small>Original source: [View scanned PDF page 123](scans/page_0123.png)</small>

**Programming.** DZERO is a slightly modified translation of the ALGOL 60 procedure ZERO given in reference (1). The code was distributed by G. E. Forsythe, M. A. Malcolm, and C. B. Moler (University of New Mexico), and modified by A. H. Morris. The function DPMPAR is used.

p52


<small>Original source: [View scanned PDF page 124](scans/page_0124.png)</small>

<a id="topic-124-01"></a>
### Solution Of Systems Of Nonlinear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HBRD` | `SUBROUTINE` | `FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA` | [`L29816`](source_parts/nswc_part_03.f90#L8611) |


Let f,(z) = O (¢ = 1,...,n) denote a system of n equations in n unknowns where z = (z1,...,%,). Assume that each f,(z) is differentiable and that an initial guess a = (a1, ...,@,) to a solution of the equations is given. Then the following subroutine is available for solving the equations to within a specified tolerance.

```fortran
CALL HBRD(FCN, N, X, FVEC, EPSFCN, TOL, INFO, WA, LWA)
```

X and FVEC are arrays of dimension n or larger. On input X contains the starting -oint a = (a),...,@,). When HBRD terminates, X contains the final estimate x = (x1, ...,2n) of the solution vector and FVEC contains the values of the functions fy, ..., fn at the output point in X.

The argument F is the name of a user defined subroutine that has the format: CALL F(n, X,FVEC,IFLAG)

Here X and FVEC are arrays of dimension n and IFLAG is an integer variable. The array X contains a point z = (z1,...,2,). Normally F will evaluate the functions f1,..., fn at this point and store the results in FVEC. However, if x does not lie in the domain of fi,---,fn then this cannot be done. In this case, the argument IFLAG (which will have been assigned a nonnegative value by HBRD) should be reset by F to a negative value. This will signal HBRD to terminate. F must be declared in the calling program to be of type EXTERNAL.

EPS is an input argument which specifies the relative accuracy of F. If it is estimated that the subroutine F produces results accurate to k significant decimal] digits then one may set EPS := 107*. It is required that EPS > 0. If EPS = 0 then it is assumed that F produces results accurate to machine precision.

TOL is an input argument which specifies the desired accuracy of the solution. The Euclidean norm ||z|| == \/2,22 is employed. If ¢ denotes an actual solution of the equations, then HBRD terminates when an iterate 2 is generated for which it is estimated that |[z - x|| < TOL: |[z]] is satisfied. It is required that ‘TOL > 0. In order for the convergence test to work properly, it is recommended that TOL always be smaller than 107°,

WK is an array of dimension @ that is used for a work space. It is assumed that the argument @ is greater than or equal to n(3n | 13)/2.

INFO is an integer variable that reports the status of the results. When HBRD terminates, INFO has one of the following values: INFO <0) This occurs when the user terminates the execution of HEBRID hy resetting the argument IFLAG in the subroutine F to a negative value. “Then INFO tho negative value of IPLAC. INPO 0G (Input Error) no 1, EPS © 0, POL « O, or @« m(Sn ob £8)/2. INFO ob A solution having the desired accuracy was obtained.


<small>Original source: [View scanned PDF page 125](scans/page_0125.png)</small>

INFO = 2 The number of calls to the subroutine F has reached or exceeded 200(n + 1). INFO = 3 TOL is too small. No further improvement in the accuracy of x is possible. INFO = 4 The routine is making very poor progress. When HBRD terminates, if INFO # 0 then X contains the final iterate that was generated. Also, if INFO > 1 then FVEC contains the values of the functions f,,...,f, at this iterate. If INFO = 2 then it may be helpful to continue the procedure by recalling HBRD with the current point in X as the new starting point. However, this is not advisable when INFO = 4. This setting can arise when x = 0 is a solution or when entrapment occurs. HBRD searches for a solution to the equations by minimizing }°, f.(z)?. In doing this, it can become trapped in a region where the minimum does not correspond to a solution of the equations. This is what occurs when the equations have no solution. When entrapment occurs and the equations are known to have a solution, then it is recommended that the user try a different starting point.

Scaling. If the convergence criterion ||z — z|| < TOL- ||z|| is satisfied and TOL = 10~*, then the larger components of the final iterate z may be accurate to k significant digits but not the smaller components. For example, if TOL = 107° and x = (1.2,.34E-4), then 1.2 may be accurate to 5 significant digits while .34E-4 is accurate to only 1 significant digit. If it is suspected that the smaller components do not have acceptable accuracy, then it is recommended that the variables in the original problem be rescaled and the problem rerun.

**Algorithm.** A modified form of the hybrid Powell procedure is employed.

**Programming.** HBRD is a slightly modified version of the MINPACK-—1i subroutine HY- BRD1. The MINPACK-~-1 subroutines HYBRD, ENORM, DOGLEG, FDJAC1, QFORM, QRFAC, RIMPYQ, and RIUPDT are employed. The subroutines were written by Jorge J. More, Burton S. Garbow, and Kenneth E. Hillstrom (Argonne National Laboratory). The function SPMPAR is also used.

**References.**

(1) More, J. J., Garbow, B.S., and Hillstrom, K. E., User Guide for MINPACK-1, Argonne Nation Laboratory Report ANL 80-74, Argonne, Illinois, (980.

(2) Powell, M.J.D., A Hybrid Method for Nonlinear Equations,” Numerical Methods for Nonlinear Algebraic Equations, P. Rabinowitz (ed.), Gordon and Breach, London, 1970.


<small>Original source: [View scanned PDF page 126](scans/page_0126.png)</small>

<a id="topic-126-01"></a>
### Solutions Of Quadratic, Cubic, And Quartic Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QDCRT` | `SUBROUTINE` | `A, Z` | [`L30424`](source_parts/nswc_part_03.f90#L9219) |
| `DQDCRT` | `SUBROUTINE` | `A, ZR, ZI` | [`L30490`](source_parts/nswc_part_03.f90#L9285) |
| `CBCRT` | `SUBROUTINE` | `A, Z` | [`L30561`](source_parts/nswc_part_03.f90#L9356) |
| `DCBCRT` | `SUBROUTINE` | `A, ZR, ZI` | [`L30775`](source_parts/nswc_part_03.f90#L9570) |
| `QTCRT` | `SUBROUTINE` | `A, Z` | [`L31011`](source_parts/nswc_part_03.f90#L9806) |
| `DQTCRT` | `SUBROUTINE` | `A, ZR, ZI` | [`L31176`](source_parts/nswc_part_03.f90#L9971) |


Given a polynomial ag + a)z +--+ 4,2" with real coefficients where a, # O and n = 2,3 or 4. The following subroutines are available for computing the roots 2, ...,2y of the polynomial.

```fortran
CALL QDCRT(A, Z)
CALL CBCRT(A, Z)
CALL QTCRT(A, Z)
```

It is assumed that A is a real array and Z a complex array. QDCRT is used if n = 2, CBCRT is used if n = 3, and QTCRT is used if n = 4. A is the array of coefficients where A{k) = a,_, for k = 1,2,...,n+ 1, and Z is an array of dimension n. When the appropriate subroutine is called, the roots z;,...,z,, are stored in Z. The real roots precede the complex roots. The real roots are ordered so that |z,| < |z,4:|. The complex roots are unordered except that complex conjugate pairs of roots appear consecutively with the root having the positive imaginary part being first.

**Programming.** Q’i'CRT calls the subroutines CBCRT and AORD, and CBCRT calls the subroutine QDCRT and function CBRT. The routines were written by A. H. Morris and CBCRT was modified by Wm. Davis (NSWC). The function SPMPAR is also used.

```fortran
CALL DQDCRT(A, ZR, ZI)
CALL DCBCRT(A, ZR, ZI)
CALL DQTCRT(A, ZR, ZI)
```

it is assumed that A,ZR, and ZI are double precision arrays. DQDCRT is used if n = 2, DCB: RT is used if n = 3, and DQOTCRT is used if n = 4. A is the array of coefficients where 4(k) = ax—1 fork = 1,2,...,n+1, and ZR and Zi} are arrays of dimension n. When the appropriate subroutine is called, the real parts of the roots Z1,-..,2, are stored in ZR and the imaginary parts are stored in ZI. The real roots precede the complex roots. The real roots are ordered so that [z,| < |z;41). The complex roots are unordered except that complex conjugate pairs of roots appear consecutively with the root having the positive imaginary part being first.

**Programming.** DQTCRI calls the routines DAORD, DCSQRT, and DCBCRT. DCBCRT calls the subroutine DQNDCRT and function DCBRT. The routines were written by A. H. Morris. The function DUMPAR is also used.


<small>Original source: [View scanned PDF page 127](scans/page_0127.png)</small>

<a id="topic-127-01"></a>
### Double Precision Roots of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DRPOLY` | `SUBROUTINE` | `OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK` | [`L31357`](source_parts/nswc_part_03.f90#L10152) |
| `DCPOLY` | `SUBROUTINE` | `OPR, OPI, IDEG, ZEROR, ZEROI, NUM, WK` | [`L32336`](source_parts/nswc_part_04.f90#L623) |


Given a polynomial ag + ayz-++-+- + a,2" of degree n > 1. The subroutines DRPOLY and DCPOLY are available for obtaining the roots z,, ...,2, of the polynomial. DRPOLY may be used if the coefficients a; are real, and DCPOLY is applicable if the coefficients are complex. These subroutines perform the calculations in double precision.

```fortran
CALL DRPOLY(OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK)
```

A is a double precision array containing the coefficients where A(7) = an—741 for g=l,...,n+1. ZR and ZI are double precision arrays of dimension n or larger, and NUM ig an integer variable. When IDRPOLY is called, if no errors are detected then NUM = the number of roots that are obtained. If NUM > 1 then the real parts of the roots are stored in ZR(j) and the imaginary parts in ZI{y) for 7 = 1, ..., NUM. The roots are unordered except that complex conjugate pairs of roots appear consecutively with the positive imaginary part being first.

WK is a real array of dimension n + 1 or larger, and DWK is a double precision array of dimension 6(n -+ L) or larger. WK and DWK are work spaces for the routine.

**Error Return.** NUM = —Lifn < lor a, = 0.

**Programming.** DRPOLY employs the subroutines DRPLY1,FXSHFR.QUADIT,REALIT, CALCSC, NEXTK, NEWEST, QUADSD, and QUADPL. These routines exchange information in a labeled common block named GLOBAL. The routines were written by M. A. Jenkins (Queen’s University, Kingston, Ontario), and modified by A. H. Morris. The functions SPMPAR, DPMPAR, and IPMFAR are also used.

**References.**

(i) Jenkins, M. A.,“Zeros of a Real Polynomial,” ACM Trans. Math Software 1 (1975), pp. 178-189.

(2) Jenkins, M. A. and Traub, J. F.,.“A Three-Stage Algorithm for Real Polynomials using Quadratic Iterations,” SIAM J. Numerical Analysis 7 (1970), pp. 545-566.

```fortran
CALL DCPOL?(AR,ALn,Z2,Z1I.NUM,DWK)
```

AR and Al are double precision arrays containing the real and imaginary parts of the

and ZI are double precision arrays of dimension n or larger, and NUM is an integer variable. When DCPOLY 1s called, if no errors are detected then NUM = the number of roots that are obtained. [If NUM > 1 then the real parts of the roots are stored in ZR(j} and the imaginary parts in ZUG} for g =: 1, ...,NUM.

DWK is a double precision array of dimension 10(n + £) or larger that is a work space for the routine.


<small>Original source: [View scanned PDF page 128](scans/page_0128.png)</small>

**Error Return.** NUM = -1 if n <1 or a, = 0.

**Programming.** DCPOLY employs the routines DCPLY1, CAUCHY, NOSHFT, FXSHFT, VRSHFT, CALCT, NEXTH, POLYEV, CDIVID, and the functions SCALCP, ERREV. These routines and functions were written by M.A. Jenkins (Queen’s University, Kingston, Ontario) and J. F. Traub (Bell Laboratories), and modified by A. H. Morris. The functions DPMPAR, IPMPAR, and DCPABS are also used.

**References.**

(1) Jenkins, M. A. and Traub, J. F., “Algorithm 419, Zeros of a Complex Polynomial,” Comm. AC'M 15 (1972), pp. 97-99.

(2) __—s—s—si, “A Three-Stage Variable-Shift Iteration for Polynomial Zeros and its Relation to Generalized Rayleigh Iteration,” Numer. Math 14 (1970), pp. 252-263.


<small>Original source: [View scanned PDF page 129](scans/page_0129.png)</small>

<a id="topic-129-01"></a>
### Accuracy Of The Roots Of Polynomials

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [`L33224`](source_parts/nswc_part_04.f90#L1511) |
| `CBND` | `SUBROUTINE` | `N, C, W, ABSERR, RELERR, KLUST, KER` | [`L33395`](source_parts/nswc_part_04.f90#L1682) |


Let z1,...,2, be approximations for the roots of a real or complex polynomial p(z) = Ap +a,z4+---+a,2" of degree n > 1. Then for each z,, the subroutines RBND and CBND obtain the radius 7; of a disk D; = {z : |z — %| < ri} centered at z; which contains a true zero of the polynomial. The radius r, is an upper bound on the absolute error of the approximation 2,.

For each z;, the subroutines also compute the number k, of disks D,; (including the disk D,} which overlap with D,;, The value k, is the number of roots of p(z) that are clustered near z,. If kj = 1 then z,; approximates a simple root.

**Example.** In the figure ky => 1, ke = 3, kg = 2, and k,g = 2.

```fortran
CALL RBND(N, C, W, ABSERR, RELERR, KLUST, KER)
CALL CBND(N, C, W, ABSERR, RELERR, KLUST, KER)
```

A is a real array if RBND is used, and A is a complex array if CBND is used. A contains the coefficients a9,a1,...,@, where A(t) = a.) (¢ = 1,...,n +1), and Z is a complex array containing the approximate roots z),... ,%n.

IERR is an integer variable, 2 a real array of dimension n or larger, and K an integer array of dimension n or larger. When RBND or CBND is called, if no input errors are detected then IERR is assigned the value 0, the radii ry), ...,r, are computed and stored in FR, and the values k,, ...,k, are computed and stored in K.

RERR is a real array of dimension n or larger. If z; = O then RERR{t) is set to — 1 by the routine, and if z, 4 O then RERR(x) © the estimated maximum relative error of z,.

**Error Return.** HORR -— 1 when n < ft and IERR ~ 2 when a, 0. In these cases no computation is performed.

**Programming.** RBND and CBND employ the functions CPABS and SPMPAR. RBND and CBND were written by Carl B. Bailey and modified by Wilham R. Gavin (Sandia Laboratories). The formats of the subroutines were modified by A. Hi. Morris.


<a id="category-130"></a>
## Vectors

<small>Original source: [View scanned PDF page 130](scans/page_0130.png)</small>

<a id="topic-130-01"></a>
### Copying Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCOPY` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [`L33565`](source_parts/nswc_part_04.f90#L1852) |
| `DCOPY` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [`L33618`](source_parts/nswc_part_04.f90#L1905) |
| `CCOPY` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [`L33671`](source_parts/nswc_part_04.f90#L1958) |


A copy of a vector X = (a1, ...,2,) can be made and stored in the array Y by the following subroutines:

```fortran
CALL SCOPY(N, SX, INCX, SY, INCY)
CALL DCOPY(N, DX, INCX, DY, INCY)
CALL CCOPY(N, CX, INCX, CY, INCY)
```

The argument kz is an integer which specifies the interval between successive components z,; of the vector X. If kx > O then it is assumed that 2, is stored in X(1+(#-1)kz) for t= 1,...,n. Otherwise, if kx < 0 then it is assumed that z, is stored in X(1+(n —1)|kz]). Similarly, the argument ky specifies the spacing of the components of Y.

SCOPY is used if X and Y are real arrays, DCOPY is used if X and Y are double precision arrays, and CCOPY is used if X and Y are complex arrays. When any of these routines is called, if n < O then the routine immediately terminates. Otherwise, ifn > 1 then the components 2, of X are stored in Y according to the spacing specified by the ky parameter.

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 808-323.


<small>Original source: [View scanned PDF page 131](scans/page_0131.png)</small>

<a id="topic-131-01"></a>
### Interchanging Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSWAP` | `SUBROUTINE` | `N, SX, INCX, SY, INCY` | [`L33797`](source_parts/nswc_part_04.f90#L2084) |
| `DSWAP` | `SUBROUTINE` | `N, DX, INCX, DY, INCY` | [`L33856`](source_parts/nswc_part_04.f90#L2143) |
| `CSWAP` | `SUBROUTINE` | `N, CX, INCX, CY, INCY` | [`L33915`](source_parts/nswc_part_04.f90#L2202) |


The components of two vectors X = (x1, ...,2n) and Y = (yi, ..., yn) can be interchanged by the following subroutines:

```fortran
CALL SSWAP(N, SX, INCX, SY, INCY)
CALL DSWAP(N, DX, INCX, DY, INCY)
CALL CSWAP(N, CX, INCX, CY, INCY)
```

The argument kz is an integer which specifies the interval between successive components x, of the vector X. If kx > 0 then it is assumed that z, is stored in X(1+ (1—1)kz) for t=1,...,n. Otherwise, if kz < C then it is assumed that 2, is stored in X(1+(n--1)|kz|). Similarly, the argument ky specifies the spacing of the components of Y.

SSWAP is used if X and Y are real arrays, DSWAP is used if X and Y are double precision arrays, and CSWAP is used if X and Y are complex arrays. When any of these routines is called, if n < O then the routine immediately terminates. Otherwise, if n > 1 then the components z, and y, are interchanged for 1 = 1, ...,n. Thus, when the routine terminates X = (y1,..., Yn) and Y = (zy, ...,2y).

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.


<small>Original source: [View scanned PDF page 132](scans/page_0132.png)</small>

<a id="topic-132-01"></a>
### Planar Rotation Of Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SROT` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, C, S` | [`L33954`](source_parts/nswc_part_04.f90#L2241) |
| `DROT` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, C, S` | [`L33995`](source_parts/nswc_part_04.f90#L2282) |
| `CSROT` | `SUBROUTINE` | `N, CX, INCX, CY, INCY, C, S` | [`L34036`](source_parts/nswc_part_04.f90#L2323) |


Let X = (21,...,2n) and Y = (y1, ...,yn) be vectors and ec and ¢ be real numbers such that c? +e? = 1. X and Y can be replaced with cX + sY and —sX + cY by the following subroutines:

```fortran
CALL SROT(N, SX, INCX, SY, INCY, C, S)
CALL DROT(N, DX, INCX, DY, INCY, C, S)
CALL CSROT(N, CX, INCX, CY, INCY, C, S)
```

The argument kz is an integer which specifies the interval between successive components z, of the vector X. If kx > 0 then it is assumed that 2, is stored in X(1+(#—1)kz) for t= 1,...,n. Otherwise, if kz < 0 then it is assumed that z, is stored in X(1+ (n — s)|kz|). Similarly, the argument ky specifies the spacing of the components of Y.

SROT is used if X and Y are real arrays, DROT is used if X and Y are double precision arrays, and CSROT is used if X and Y are complex arrays. The arguments c and s are real numbers when SROT and CSROT are used, and are double precision numbers when DROT is used. When any of these routines is called, if n < 0 then the routine immediately terminates. Otherwise, if n > 1 then the components x; and y; are replaced with cx, + sy, and —sz,;+cy,; for f=1,...,n.

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. fT. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory)

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

1OS


<small>Original source: [View scanned PDF page 133](scans/page_0133.png)</small>

<a id="topic-133-01"></a>
### Modified Givens Rotations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SROTMG` | `SUBROUTINE` | `SD1, SD2, SX1, SY1, SPARAM` | [`L34078`](source_parts/nswc_part_04.f90#L2365) |
| `SROTM` | `SUBROUTINE` | `N, SX, INCX, SY, INCY, SPARAM` | [`L34234`](source_parts/nswc_part_04.f90#L2521) |
| `DROTMG` | `SUBROUTINE` | `DD1, DD2, DX1, DY1, DPARAM` | [`L34353`](source_parts/nswc_part_04.f90#L2640) |
| `DROTM` | `SUBROUTINE` | `N, DX, INCX, DY, INCY, DPARAM` | [`L34512`](source_parts/nswc_part_04.f90#L2799) |


If a; and ag are real numbers where r* = a? + a? #% 0, then there is an orthogonal

; matrix G = ( c *) such that G (2) = (5). In this case c = a)/r and s = ag/r. —s c¢ a2 0 The matrix G represents what is called a Givens rotation. Given A = a , the matrix 2)

G is uniquely defined up to the sign of r.

Alternatively, assume that instead of having A we are given D = (4 i ) and B= 2

(3) where d, > 0 ({ = 1,2) and A= D¥/?B. Then there exist matrices D = (2 o ) 2

0 dy, hi hyp

and H = (is hos

) where d, and d2 are positive values and

~

by HB= (1) (0) GD? =6DV*H (o = +1).

In this case, GA = GDV/?8 = oD/?(HB).

If dyby > d2b? then H and D can be defined by

dob hod his = 222 i 1 by (2) : u- Lt Ayghey dy dy /u dy = dy/u, in which case by ub; and a sgu(c). Otherwise, if dpb? << d2b? then # and D can be defined by dy by A Ay. - 1 uM dy by ' by ( 3) h dt I h M2 bh. uo 1 ai Ayyhee dy do fu dy dy fu,

in which case hy 0 uby anda syu(s)

in7


<small>Original source: [View scanned PDF page 134](scans/page_0134.png)</small>

Any H which satisfies (1) is called a modified Givens rotation matrix. H is frequently preferred to G since its use may require fewer multiplications, and square roots are avoided. For convenience, if b2 = G or d; = 0 then H is defined to be the identity matrix and D=D. Otherwise, if b; = 0 or dy = O then formulas (3) are applied.

It is normally assumed that dy > 0. However, there are applications where it is

convenient to let dp < 0. If dy > 0 and dy <0 then D and H can be defined by (2) or (3) depending on whether |d,b?| > |d,63| or {d.b?| < |d2b2|. If (8) are used and u # 0, then dy < 0, which is not compatible with the requirement d; > 0. Consequently, dz < 0 is permitted only when |d,b}| > |d2b3|, and we note that 0 < u < 1. Since u can be near 0, D and H may have to be rescaled to avoid overflow and underflow. Rescaling may also be needed when dz > 0 (in this case 1 <u < 2).

The subroutines SROTMG and DROTMG are available for obtaining D and A, and [ the subroutines SROTM and DROTM are available for computing H (=) for any (<).

```fortran
CALL SROTMG(SD1, SD2, SX1, SY1, SPARAM)
CALL DROTMG(DD1, DD2, DX1, DY1, DPARAM)
```

D,, De, By, Be are real variables and @ areal array if SROTMG 3s used, and Dy, De, Ry, Bz are double precision variables and Q a double precision array if DROTMG is used. Q is an array of dimension 5.

It is assumed that D, = dy and By = 6; (¢ = 1,2) on input and that d; > 0. The argument dz may be negative or nonnegative. If hh 7 0 then it is assumed that [d,b?| > |d263 |. When SROTMG or DROTMG is called, Dy and Dz are reset. to dy aud do, and 23, is reset to by. Be is not modified, and H is stored in Q as follows.

Q(1) is an indicator which specifies the elements of H that are stored in Q. IfQ(1) 1 then all the elements are stored and

QZ) -- hay Q(4) - Aas QB) ha QO(5) hay. Otherwise, Q(1) has one of the following values: Q(1) Q Hf as defined by (2). Q(3) 0 hay and Q(4) Aye. Q(2) and Q(5) are not defined. Q(t) 1 oH ‘ts defined by (3). O(2) 0 Aqy and Q(5) hay. Q(3) and Q(4) ae not de fhae d.

Q(1) 2 ?fis the identity matrix, Q(2),...,Q(5) are not defined.

**Error Return.** Hfdy © Oe fdp Oy} jdgb2] when dy © 0, then Doand Hoare set to the zero matrix and 6, Q. In this case, Q(t} Tand Q(t) O fora: 2.

Programming ‘These subroutines are part of the BLAS package of basic linear algebra subroutines designed by Co UL. Lawson, Ro Jo Hanson, DO Ro Kincaid, and Bo TO Krogh SROTUEM OG: and DROUOPNICO were modified oo Al EE Morris,


<small>Original source: [View scanned PDF page 135](scans/page_0135.png)</small>

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

```fortran
CALL SROTM/n, X, kz, Y,ky,Q)
CALL DROTM(N, DX, INCX, DY, INCY, DPARAM)
```

Let X = (21, ...,2,) and Y = (y1, ..., yn) be vectors, and Q be the array obtained by SROTMG or DROTMG. If A is the modified Givens rotation matrix stored in Q, then SROTM and DROTM are available for computing (3) = H (=) (@=1,...,n).

The argument kz is an integer which specifies the interval between successive components z, of the vector X. If kx > O then it is assumed that z, is stored in X(1+(#~1)kz) for t= 1,...,n. Otherwise, if kx < 0 then it is assumed that z, is stored in X(4 + (n— 1)[kz}). Similarly, the argument ky specifies the spacing of the components of Y.

SROTM is used if X,Y, and @ are real arrays, and DROTM is used if X,Y, and Q are double precision arrays. When SROTM or DROTM is called, if n < 0 then the routine immediately terminates. Otherwise, ifn > 1 then the components zx, and y, are replaced with Z, and g, for i =1,...,n.

**Programming.** These subroutines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh.

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear

Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 808 323.

tee)


<small>Original source: [View scanned PDF page 136](scans/page_0136.png)</small>

<a id="topic-136-01"></a>
### Dot Products Of Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SDOT` | `REAL FUNCTION` | `N, SX, INCX, SY, INCY` | [`L34632`](source_parts/nswc_part_04.f90#L2919) |
| `DDOT` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX, DY, INCY` | [`L34684`](source_parts/nswc_part_04.f90#L2971) |
| `CDOTC` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [`L34736`](source_parts/nswc_part_04.f90#L3023) |
| `CDOTU` | `COMPLEX FUNCTION` | `N, CX, INCX, CY, INCY` | [`L34777`](source_parts/nswc_part_04.f90#L3064) |


The following functions are available for computing the sums >>, 2,y; and 30. Z.iys where X = (21,...,%n) and Y = {y), ..., Yn) are real or complex vectors.

SDOT(n, X, kz, Y,ky) DDOT(n, X, kz, Y, ky) CDOTC(n, X, kz, Y, ky) CDOTU(n, X, kz, Y, ky)

The argument kz is an integer which specifies the interval between successive components x, of the vector X. If kz > 0 then it is assumed that z, is stored in X(1+(#—1)kz) for i=1,...,n. Otherwise, if kx < 0 then it is assumed that z, is stored in X(1+(n—1)|kzj). Similarly, the argument ky specifies the spacing of the components of Y’.

SDOT is used if X and Y are real arrays, and DDOT is used if X and Y are double precision arrays. SDOT is 2 real function and DDOT is a double precision function. When either of these two functions is called, if n < 0 then the function is assigned the value 0. Otherwise, ifn > 1 then the function is assigned the value >> 7,4.

scl

CDOTC and CDOTU are used if X and Y are complex arrays. CDOTC and CDOTU are complex functions. When either of these two functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if n > t then CDOTC(n, X,kz,Y, ky) is assigned

nm

nm the value 5” z,y, and CDOTU (n, X,kz,Y, ky) is assigned the value >7 2,y.. Remark. DDOT must be declared in the calling program to be of type DOUBLE PRECISION, and CDOTC and CDOTU must be declared to be of type COMPLEX.

**Programming.** These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. ‘The functions were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, ©. L., Hanson, R. J., Kincaid, 9. R., and Krogh, F.T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308 323


<small>Original source: [View scanned PDF page 137](scans/page_0137.png)</small>

<a id="topic-137-01"></a>
### Scaling Vectors

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSCAL` | `SUBROUTINE` | `N, SA, SX, INCX` | [`L34817`](source_parts/nswc_part_04.f90#L3104) |
| `DSCAL` | `SUBROUTINE` | `N, DA, DX, INCX` | [`L34862`](source_parts/nswc_part_04.f90#L3149) |
| `CSCAL` | `SUBROUTINE` | `N, CA, CX, INCX` | [`L34907`](source_parts/nswc_part_04.f90#L3194) |
| `CSSCAL` | `SUBROUTINE` | `N, SA, CX, INCX` | [`L34936`](source_parts/nswc_part_04.f90#L3223) |


If a is a real or complex number and X = (x1, ...,2,) a vector, then the vector X can be replaced with the vector aX by the following subroutines:

```fortran
CALL SSCAL(N, SA, SX, INCX)
CALL DSCAL(N, DA, DX, INCX)
CALL CSCAL(N, CA, CX, INCX)
CALL CSSCAL(N, SA, CX, INCX)
```

The argument kz is a positive integer. It is assumed that the component sz, is stored in X(1 + (¢ — 1)kx) for i = 1,...,n.

SSCAL is used if @ is a real number and X a real array, DSCAL is used if « is a double precision number and X a double precision array, CSCAL is used if a is a complex number and X a complex array, and CSSCAL is used if a is a real number and X a complex array. When any of these routines is called, if n < 0 then the routine immediately terminates. Otherwise, ifn > 1 then each z, is replaced with az,;. Thus when the routine terminates X = (az,,...,a2,).

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National ¥.aboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” A(TM 1'vans. Mata Software § (1979), pp. 308-323.


<small>Original source: [View scanned PDF page 138](scans/page_0138.png)</small>

<a id="topic-138-01"></a>
### Vector Addition

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SAXPY` | `SUBROUTINE` | `N, SA, SX, INCX, SY, INCY` | [`L34965`](source_parts/nswc_part_04.f90#L3252) |
| `DAXPY` | `SUBROUTINE` | `N, DA, DX, INCX, DY, INCY` | [`L35017`](source_parts/nswc_part_04.f90#L3304) |
| `CAXPY` | `SUBROUTINE` | `N, CA, CX, INCX, CY, INCY` | [`L35069`](source_parts/nswc_part_04.f90#L3356) |


```text
If a is a real or complex number and X == (71,...,%,) a vector, then any vector
Y = (y1, ..-,Yn) can be replaced with the vector aX + Y by the following subroutines:
```

```fortran
CALL SAXPY(N, SA, SX, INCX, SY, INCY)
CALL DAXPY(N, DA, DX, INCX, DY, INCY)
CALL CAXPY(N, CA, CX, INCX, CY, INCY)
```

The argument kz is an integer which specifies the interval between successive components 2, of the vector X. If kx > 0 then it is assumed that 2, is stored in X(1+(#—1)kz) for #=1,...,n. Otherwise, if kx < 0 then it i: assumed that 2, is stored in X(1+ (n —1)|kz]). Similarly, the argument ky specifies the spacing of the components of the vector Y.

SAXPY ‘s used if 418 a real number aid X, Y are real arrays, DAXPY is used if a ig a double precision number and X, Y are double precision arrays, and CAXPY is used if a is a complex number and X, Y are complex arrays. When any of these routines is called, if n < 0 or a = O then the routine immediately terminates. Otherwise, if n > 1 then y,; is replaced with az, + y; for + = 1,...,n. Thus when the routine terminates Y = (azy + yi, -..,@%n + Un).

**Programming.** These routines are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The routines were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. 1., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math. Software 5 (1979), pp. 308-323.


<small>Original source: [View scanned PDF page 139](scans/page_0139.png)</small>

<a id="topic-139-01"></a>
### L1 Norm of a Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SASUM` | `REAL FUNCTION` | `N, SX, INCX` | [`L35107`](source_parts/nswc_part_04.f90#L3394) |
| `DASUM` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [`L35153`](source_parts/nswc_part_04.f90#L3440) |
| `SCASUM` | `REAL FUNCTION` | `N, CX, INCX` | [`L35198`](source_parts/nswc_part_04.f90#L3485) |


The following functions are available for computing the 2; norm of a real vector or a modified LZ, norm of a complex vector.

SASUM(n, X, kz) DASUM(n, X, kz; SCASUM(n, X, kz)

```text
X := (x1, ....2,) is a vector and kz a positive integer. It is assumed that 2, is stored
in X(1-+ (¢ ~ Ikz) ford =1,...,n,
```

SASUM is used if X is a real array and DASUM 1s used if X is a double precision array. SASUM is a real function and DASUM a double precision function. When either of these functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if

nm % > 1 then the function is assigned the value >> |x|. sol

SCASUM is used if X is a complex array. SCASUM is a real function. When SCASUM is called, if n < 0 then the function is assigned the value 0. Otherwise, if m > 1 then SCASUM(n, X, ka) is assigned the value > {|Re(z,)| + |Im(z,)|].

t=1 Remarks. (1) DASUM must be declared in the calling program to be of type DOUBLE PRECISION. (2} SCASUM(n, X, kx) is the norm of the complex vector X == (21,.. ,2n) when X is regarded as a real vector of dimension 2n. This norm is frequently preferred over the n standard Ly norm )> |z,| since it takes less time to compute. t=1 Programming. These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The functions were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Linear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math. Software 5 (1979),


<small>Original source: [View scanned PDF page 140](scans/page_0140.png)</small>

<a id="topic-140-01"></a>
### L2 Norm of a Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SNRM2` | `REAL FUNCTION` | `N, SX, INCX` | [`L35232`](source_parts/nswc_part_04.f90#L3519) |
| `DNRM2` | `DOUBLE PRECISION FUNCTION` | `N, DX, INCX` | [`L35369`](source_parts/nswc_part_04.f90#L3656) |
| `SCNRM2` | `REAL FUNCTION` | `N, CX, INCX` | [`L35506`](source_parts/nswc_part_04.f90#L3793) |


The following functions are available for computing the Zz norm of a real or complex vector.

SNRM2(n, X, kz) DNRM2(n, X, kz) SCNRM2(n, X, kz)

```text
X = (21, ...,2n) is a vector and kz a positive integer. It is assumed that 2, is store.
in X(14 (¢~- i)kr) ford = 1, ...,n.
```

SNRM2 is used if X is a real array, DNRM2 is used if X is a double precision array, and SCNRM2 is used if X is a complex array. SNRM2 and SCNRM2 are real functions and DNRM? a double precision function. When any of these functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if n > 1 then the function is assigned

n 2 the value p |z,| t=]

**Remark.** The function DNRM2 must be declared in the calling program to be of type DOUBLE PRECISION.

**Programming.** These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The functions were written by Charles Lawson (Jet Propulsion Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T. “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.

L79


<small>Original source: [View scanned PDF page 141](scans/page_0141.png)</small>

<a id="topic-141-01"></a>
### L-infinity Norm of a Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ISAMAX` | `INTEGER FUNCTION` | `N, SX, INCX` | [`L35662`](source_parts/nswc_part_04.f90#L3949) |
| `IDAMAX` | `INTEGER FUNCTION` | `N, DX, INCX` | [`L35704`](source_parts/nswc_part_04.f90#L3991) |
| `ICAMAX` | `INTEGER FUNCTION` | `N, CX, INCX` | [`L35746`](source_parts/nswc_part_04.f90#L4033) |


The following functions are available for finding the largest component z, of a vector X = (r1,...,2n).

ISAMAX(n, X, kz) IDAMAX(n, X, kz) ICAMAX(n, X, kz)

The argument kz is a positive integer. It is assumed that the component 2, is stored in X(1+ ( — 1)kx) ford =1,...,n.

ISAMAX is used if X is a real array and IDAMAX is used if X is a double precision array. ISAMAX and IDAMAX are integer functions. When either of these functions is called, if n < 0 then the function is assigned the value 0. Otherwise, if n > 1 then the function is assigned the value t where ¢ is the smallest index such that |z,| = max{!z,]:7 = 1,.. ,n}.

ICAMAX is also an integer function. It is used when X is a complex array. If n < 0 then ICAMAX(n, X, kz) is assigned the value G. Otherwise, if n > 1 then the function is assigned tue value ¢ where ¢ is the smallest index such that |Re(z,)| + |Im(z,)| -= max{|Re(z,)| + |Im(z,)|: 7 =1, ...,n}.

**Note.** he mapping X —+ max{|Re(z,)| + | m(z,;)|: 7 = 1,...,n} is the L,. norm of the complex vector X = (1, ...,2,) when X is regarded as a real n x 2 matrix. This norm is frequently preferred over the standard Lo. norm max{{z,;|: 7 = 1, ...,n} since it takes less

time to compute.

**Programming.** These functions are part of the BLAS package of basic linear algebra subroutines designed by C. L. Lawson, R. J. Hanson, D. R. Kincaid, and F. T. Krogh. The functions were written by Jack Dongarra (Argonne National Laboratory).

**Reference.** Lawson, C. L., Hanson, R. J., Kincaid, D. R., and Krogh, F. T., “Basic Lin-

ear Algebra Subprograms for FORTRAN Usage,” ACM Trans. Math Software 5 (1979), pp. 308-323.


<a id="category-142"></a>
## Matrices

<small>Original source: [View scanned PDF page 142](scans/page_0142.png)</small>

<a id="topic-142-01"></a>
### Packing And Unpacking Symmetric Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVFS` | `SUBROUTINE` | `A, KA, N, B` | [`L35796`](source_parts/nswc_part_04.f90#L4083) |
| `DMCVFS` | `SUBROUTINE` | `A, KA, N, B` | [`L35812`](source_parts/nswc_part_04.f90#L4099) |
| `MCVSF` | `SUBROUTINE` | `A, KA, N, B` | [`L35828`](source_parts/nswc_part_04.f90#L4115) |
| `DMCVSF` | `SUBROUTINE` | `A, KA, N, B` | [`L35858`](source_parts/nswc_part_04.f90#L4145) |


Ann Xn symmetric matrix A = (a,;) can be represented by either its lower triangular elements 411 412 G13 G21 @22 423 S3i_432_ 233

or its upper triangular elements. If the lower triangular elements are used, then the packed form for the matrix is an array of dimension n(n + 1)/2 containing the elements 011021092431439433-°+* Similarly, if the upper triangular elements are used then the packed form for the matrix is an array containing @11412-**@1n@22223°°*Goan-*- Currently the lower triangular elements are used for packing symmetric matrices. The following subroutines are available for packing and unpacking real symmetric matrices.

```fortran
CALL MCVFS(A, KA, N, B)
CALL DMCVFS(A, KA, N, B)
```

Ais ann Xn symmetric matrix and B an array whose dimension is equal to or greater than n(n + 1)/2. The routines store the packed form of A in B. MCVFS is used if A and B are real arrays and DMCVFS is used if A and B are double precision arrays. The input argument ka has the following value:

ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > n.

**Note.** A and B may begin in the same location. Programmer. A. H. Morris.

```fortran
CALL MCVSF(A, KA, N, B)
CALL DMCVSF(A, KA, N, B)
```

B is an array containing the elements of a packed n x n symmetric matrix and A is an array of dimension ka x n where ka > n. The routines unpack 3 and store the results in A. MCVSF is used if A and #3 are real arrays and DMCVSF is used if A and BD are double precision arrays.

**Note.** A and # may begin in the same location.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 143](scans/page_0143.png)</small>

<a id="topic-143-01"></a>
### Conversion Of Real Matrices To And From Double Precision Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVRD` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35888`](source_parts/nswc_part_04.f90#L4175) |
| `MCVDR` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35902`](source_parts/nswc_part_04.f90#L4189) |


The subroutines MCVRD and MCVDR are available for converting real matrices to and from double precision form.

```fortran
CALL MCVRD(M, N, A, KA, B, KB)
```

Ais areal mxn matrix and B a double precision 2-dimensional array. MCVRD stores the matrix in double precision form in the array B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL MCVDR(M, N, A, KA, B, KB)
```

A is a double precision m x n matrix and B a real 2-dimensional array. MCVDR stores the matrix in single precision form in the array B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 144](scans/page_0144.png)</small>

<a id="topic-144-01"></a>
### Storage Of Real Matrices In The Complex Matrix Format

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVRC` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35916`](source_parts/nswc_part_04.f90#L4203) |


The following subroutine is available for storing a real matrix A in the complex matrix format.

```fortran
CALL MCVRC(M, N, A, KA, B, KB)
```

A is a real m x n matrix and B a complex 2-dimensional array. MCVRC stores the matrix in complex form in the array B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb == the number of rows in the dimension statement for B in the calling program it is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 145](scans/page_0145.png)</small>

<a id="topic-145-01"></a>
### The Real And Imaginary Parts Of A Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMREAL` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35930`](source_parts/nswc_part_04.f90#L4217) |
| `CMIMAG` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35944`](source_parts/nswc_part_04.f90#L4231) |


if A = (a,j) is a complex matrix then let Re(A) = (Re(a,,)) and Im(A) = (In(a,,)) denote the real and imaginary parts of A. The following subroutines are available for obtaining Re(A) and Im(A).

```fortran
CALL CMREAL(M, N, A, KA, B, KB)
```

A is a complex m X n matrix and B a real 2-dimensional array. CMREAL obtains Re(A) and stores it in B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL CMIMAG(M, N, A, KA, B, KB)
```

A is a complex m X n matrix and B a real 2-dimensional array. CMIMAG obtains Im(A) and stores it in B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 146](scans/page_0146.png)</small>

<a id="topic-146-01"></a>
### Copying Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35958`](source_parts/nswc_part_04.f90#L4245) |
| `SMCOPY` | `SUBROUTINE` | `N, A, B` | [`L35972`](source_parts/nswc_part_04.f90#L4259) |
| `DMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35985`](source_parts/nswc_part_04.f90#L4272) |
| `CMCOPY` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L35999`](source_parts/nswc_part_04.f90#L4286) |


‘The following subroutines are available for copying matrices.

```fortran
CALL MCOPY(M, N, A, KA, B, KB)
```

A is a real m x n matrix and B a real 2-dimensional array. MCOPY makes a copy of the matrix A and stores it in B, The input arguments ka and kb have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program

It is assumed that ka > m and kt > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL SMCOPY(N, A, B)
```

A is areal packed n x n symmetric matrix and B a real array whose dimension is equal to or greater than n(n 4- 1)/2. SMCOPY makes a copy of the packed symmetric matrix A and stores it in B.

**Programmer.** A. H. Morris.

```fortran
CALL DMCOPY(M, N, A, KA, B, KB)
```

A is a double precision m x n matrix and B a double precision 2-dimensional array. DMCOPY makes a copy of the matrix A and stores it in B. The input arguments ka and kb nave the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kd > m, and that 8 contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL CMCOPY(M, N, A, KA, B, KB)
```

Ais a complex mxn matrix and B a complex 2-dimensional array, CMCOPY makes a copy of the matrix A and stores it in 8. The input arguments ke and kb have the following values:

ka <= the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 147](scans/page_0147.png)</small>

<a id="topic-147-01"></a>
### Computation Of The Conjugate Of A Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMCONJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36013`](source_parts/nswc_part_04.f90#L4300) |


If A = (a,;) ig a complex matrix then let A = (a,;) denote the conjugate of A. The following subroutine is available for computing the conjugate matrix A: CALL CMCONJ(m,n, A, ka, B, kb}

Ais a complex mxn matrix and B a complex 2-dimensional array. CMCONJ computes A and stores the results in B. The input arguments ka and kb have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb > m, and that B contains at least n columns.

**Remark.** A and B may reference the same storage area when ka = kb.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 148](scans/page_0148.png)</small>

<a id="topic-148-01"></a>
### Transposing Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36027`](source_parts/nswc_part_04.f90#L4314) |
| `DTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36041`](source_parts/nswc_part_04.f90#L4328) |
| `CTPOSE` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36055`](source_parts/nswc_part_04.f90#L4342) |
| `TIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [`L36069`](source_parts/nswc_part_04.f90#L4356) |
| `DTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [`L36194`](source_parts/nswc_part_04.f90#L4481) |
| `CTIP` | `SUBROUTINE` | `A, N1, N2, MOVED, NWORK, NDIM` | [`L36319`](source_parts/nswc_part_04.f90#L4606) |


The subroutines TPOSE, DTPOSE, C £POSE and TIP, DTIP, CTIP are available for transposing a matrix A. TPOSE, DTPOSE, and CTPOSE are used if the results are to be stored in a separate storage area B. TIP, DTIP, and CTIP are used if the results are to be stored in A (i.e., if the transposition is to be done in place).

```fortran
CALL TPOSE(M, N, A, KA, B, KB)
CALL DTPOSE(M, N, A, KA, B, KB)
CALL CTPOSE(M, N, A, KA, B, KB)
```

TPOSE is called if A is a real matrix and 8 a real array, DTPOSE is called if A is a double precision matrix and B a double precision array, and CTPOSE is called if 4 is a complex matrix and B a complex array.

A is a matrix having m rows and n columns, and B a 2-dimensional array. The routine transposes A and stores the results in B. The input arguments ka and kb have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows ir the dimension statement for B in the calling program It is assumed that ka > m and kb > n, and that 2 contains at least n columns.

**Programmer.** A. H. Morris.

```fortran
CALL TIP(A, N1, N2, MOVED, NWORK, NDIM)
CALL DTIP(A, N1, N2, MOVED, NWORK, NDIM)
CALL CTIP(A, N1, N2, MOVED, NWORK, NDIM)
```

TIP is called if A is a real array, DTIP is called if A is a double precision array, and CTIP is called if A is a complex array.

A is an array of dimension mn which contains an m X n matrix to be transposed. The routine transposes the matrix and stores the results in A. Hf mi =: n then the arguments

MOVE, k, MDIM are ignored.

If m ¥# n then & may be any integer. If k < 0 then MOVE is ignored. Otherwise, if k > 1 then MOVE is assumed to be an array of dimension k. MOVE is a storage area for saving information that may help speed up the transposition process. If no information is saved then TIP, DTIP, and CTIP may run 2 10 times slower than TPOSE, DTPOSE, and CTPOSE, However, the use of a storage area may or may not actually speed up the transposition process. This depends entirely on the values of mi and mn. MDIM ts a variable that is set by the routine. After the routine terminates, MDIM will be the estimated optimum setting for & for the current values of me and n.

**Programming.** The routines TIP, DPTEP, and CVEP employ the subroutine INECTR, ‘The routines were written by Norman Brenner (Dept. of Marth and Planetary Sciences,

Massachusetts Institute of Technology), and modified by A. H. Morris.


<small>Original source: [View scanned PDF page 149](scans/page_0149.png)</small>

**Reference.** Brenner, Norman, “Algorithm 467. Matrix Transposition in Place,” Comm. ACM 16 (1973), pp. 692-694.

LOG


<small>Original source: [View scanned PDF page 150](scans/page_0150.png)</small>

<a id="topic-150-01"></a>
### Computing Adjoints Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMADJ` | `SUBROUTINE` | `M, N, A, KA, B, KB` | [`L36494`](source_parts/nswc_part_04.f90#L4781) |
| `CTRANS` | `SUBROUTINE` | `NM, N, A` | [`L36508`](source_parts/nswc_part_04.f90#L4795) |


If A = (a,;) then let A* = (a,;) denote the adjoint of A. The following subroutines are available for computing A”*.

```fortran
CALL CMADJ(M, N, A, KA, B, KB)
```

A is a complex m xn matrix and B a complex 2-dimensional array. CMADJ computes A* and stores the results in B. The input arguments ka and kb have the following values: ka = the number of rows in the dimension statement for A in the calling program ko = the number of rows in the dimension statement for B in the calling program It is assumed that ka > m and kb » n, and that B contains at least n columns.

**Remark.** CMADJ combines the following operations: CALL CTPOSE(m,n, A, ka, B, kh) CALL CMCONJ(n, m, B, &b, B, kb)

It is assumed that A and B are different storage areas.

**Programmer.** A. H. Morris. CALL CTRANS(ka, n, A)

A is a complex array of dimension ka xn which contains an n xX n matrix. CTRANS computes the adjoint of the matrix and stores the results in A. It is assumed that ka > n.

**Programmer.** George J. Davis (Georgia State University)


<small>Original source: [View scanned PDF page 151](scans/page_0151.png)</small>

<a id="topic-151-01"></a>
### Matrix Addition

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36544`](source_parts/nswc_part_04.f90#L4831) |
| `DMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36561`](source_parts/nswc_part_04.f90#L4848) |
| `CMADD` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36578`](source_parts/nswc_part_04.f90#L4865) |
| `SMADD` | `SUBROUTINE` | `N, A, B, C` | [`L36595`](source_parts/nswc_part_04.f90#L4882) |


The matrix sum C = A+ B can be computed by the following subroutines: CALL MADD(ta,n, A, ka, B, kb, C, kc)

A and B are real m x n matrices and C a real 2-dimensional array. MADD computes A+ B and stores the results in C. The input arguments ka, kb, kc have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program ke = the numb2r of rows in the dimension statement for C in the calling program It is assumed that ka > m, kb > m, ke > m, and that C contains at least n columns.

The array C' may begin in the same location as A or B. li C begins in the same location as A them it is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that ke == kb. Otherwise, if C dees not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage areas for A and 8B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

**Programmer.** A. H. Morris. CALL SMADD(n, A, B,C)

A and B are real packed nx" symmetric matrices and C is a real array whose dimension is equal to or greater than n(n +-1)/2. SMADD computes A+- B, which is also a symmetric matrix, and stores the results in packed form in C.

The array C may begin in the same location as A or B. If C begins in the same location as A then the result C’ will overwrite the input data A. Similarly, B will be overwritten if C begins in the same location as B. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage

areas for Aa! B.

**Programmer.** A. H. Morris. CALL DMADD(rm,n, A, ka, B, kb, Cy ke)

A and B are double precision m x n matrices and C a double precision 2-dimensional array. DMADD computes -t + B and stores the results in C. The arguments &a, kb, ke have the following values:

ka > the number of rows in the dimension statement for Ain the calling program

kb the number of rows in the dimension statement for ff in the calling program

Ac the number of rows tn the dimension statement for C ip the calling program [tis assumed that ka oom, Abo om, ke oor, and that © contains at least mn columns


<small>Original source: [View scanned PDF page 152](scans/page_0152.png)</small>

The array C may begin in the same location as A or B. If C begins in the same location as A then it is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed that ke = kt. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage «rea for C does not overlap with the storage areas fur A and B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

**Programmer.** A. H. Morris. CALL CMADD (m,n, A, ka, B, kb, C, ke)

A aid B are complex m xn matrices and C a complex 2-dimensional array. CMADD computes A+ B and stores the results in C. The arguments ka, kb, ke have the following ees:

“a = the number of rows in the dimension statement for A in the calling program

ke -= the number of rows in the dimension statement for B in the calling program

ke = the number of rows in the dimension statement for C in the calling program it is assumed that ka > m, kb > m, ke > m, and that C contains at least n columns.

The array C may begin in the same location as A or B. If C begins in the same location as A chen it is assumed that kc = ka. In this case, the result C’ will overwrite the input data 4. Similarly, if C begins in the same location as B then it is assumed that ke = kb. Otherwise, if C’ does not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage areas for A and @. In this case there is no restriction on ke (other than the customary restriction that ke > rm).

Programmer. A. H. Morris.


<small>Original source: [View scanned PDF page 153](scans/page_0153.png)</small>

<a id="topic-153-01"></a>
### Matrix Subtraction

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36607`](source_parts/nswc_part_04.f90#L4894) |
| `DMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36624`](source_parts/nswc_part_04.f90#L4911) |
| `CMSUBT` | `SUBROUTINE` | `M, N, A, KA, B, KB, C, KC` | [`L36641`](source_parts/nswc_part_04.f90#L4928) |
| `SMSUBT` | `SUBROUTINE` | `N, A, B, C` | [`L36658`](source_parts/nswc_part_04.f90#L4945) |


The matrix difference C = A - B can be computed by the following subroutines: CALL MSUBT (m,n, A, ke, B, ke, C, ke)

A and B are real m.:n matrices and U a real 2-dimensional array. MSUBT computes A-- B and stores the results in C. ‘Che avout arguments Ke, kb, ke have the following values: ka = the number :f rows in the dimension statement :or A in the calling program kb == the number of rows in the dimension statement tur B in the calling program ke = the number o7 rows in the dimension statement for C in the calling program It is assumed that ka > mm, kb > m, ke > m, and that C’ contains at least n columns.

The array C may begin ii the same location as A or 3B. [fC begins in the same location as A then it is assumed that kc = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as B then it is assumed what ke == kb. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage area for C' does not overlap with the storage areas for A and B. In this case there is no restriction on ke (other than the customary restriction that ke > mi}.

**Programmer.** A. H. Morris. CALL SMSUBT(n, A, B,C)

A and # are real packed nx n symmetric matrices and C is a real array whose dimension is equal to or greater than n(n+1)/2. SMSUBT computes A— &, which is also a symmetric matrix, and stores the results in packed form in C.

The array C may begin in the same location as A or B. Uf begins in che same location as A then the result C’ will overwrite the input data A. Similarly, B will be overwritten if C begins in the same location as B. Otherwise, if C does nos begin in the same location as A or B, then it is assumed that the storage area for © does not overlap with the storage areas for A and B.

**Programmer.** A. 1. Morris. CALL OMSUBT(m,n, A, ka, B, kb, C, kc)

A and B are double precision m xX n matrices and C' a double precision 2-dimensional array. DMSUBT computes A -- B and stores the results is C. The arguments ka, &b, kc have the following values:

ka = the number af news in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for Gin the calling program

ke = the number of rows tu the dimension statement for Cin the calling program It is assumed that ca So, ke Soa, Ac hom, and that C contains af least m columns,

vaus|


<small>Original source: [View scanned PDF page 154](scans/page_0154.png)</small>

‘The array C may begin in the same location as A or B. fC begins in the game location ag A then it is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C begins in the same location as 8 then it is assumed that ke =: kb. Otherwise, if C does not, begin in the same location as A or #, then it is assumed that the storage area for C devs not overlap with the storage areas for A and B. In this case there

~.

is no restriction on kc (other than the customary restriction that ke > m).

**Programmer.** A. H. Morris. CALL CMSUBT(m,n, A, ka, B, kb, C, ke)

A and & are complex rm x mn matrices and C a complex 2-dimensional array. CMSUBT computes A -- 8B and stores the results in C. The input arguments ka, kb, ke have the following values:

ka = the number of rows in the dimension statement for A in the calling program

ké = the number of rows in the dimension statement for B in the calling program

ke == the number of rows in the dimension statement for C' in the calling program It is assumed that ka > m, kb > m, ke > m, and that C has at least n columns.

The array C may begin in the same location as A or 8. If C begins in the same location as A thea 1 is assumed that ke = ka. In this case, the result C will overwrite the input data A. Similarly, if C’ begins in the same location as B then it is assumed that ke = kb. Otherwise, if C’ does net begin in the same location as A or B, then it is assumed that the storage area for C’ does not overlap with the storage areas for A and B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

Programmer. A. H. Morris.


<small>Original source: [View scanned PDF page 155](scans/page_0155.png)</small>

<a id="topic-155-01"></a>
### Matrix Multiplication

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L36670`](source_parts/nswc_part_04.f90#L4957) |
| `DMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L36692`](source_parts/nswc_part_04.f90#L4979) |
| `CMTMS` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L36714`](source_parts/nswc_part_04.f90#L5001) |
| `MPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [`L36736`](source_parts/nswc_part_04.f90#L5023) |
| `DMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [`L36843`](source_parts/nswc_part_04.f90#L5130) |
| `CMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC, ROW` | [`L36950`](source_parts/nswc_part_04.f90#L5237) |


The matrix product C -= AB may be computed by the subroutines MTMS, DMTMS, CMTMS cor MPROD, DMPROD, CMPROD. MTMS, DMTMS, and CMTMS can be used if the storage area for C does not overlap with the storage areas for A and 8. Otherwise, if the components of C are to be stored in the storage area for A or B, then MPROD, DMPROD, or CMPROD must be used.

```fortran
CALL MTMS(M, N, L, A, KA, B, KB, C, KC)
CALL DMTMS(M, N, L, A, KA, B, KB, C, KC)
CALL CMTMS(M, N, L, A, KA, B, KB, C, KC)
```

MTMS is used if A and B are real matrices and C a real array, DMTMS is used if A and B are double precision matrices and C’ a double precision array, and CMTMS is used if 4 and B are complex matrices and C’ a complex array.

A is a matrix having m rows and n columns, £ a matrix having n rows and £ columns, and C a 2-dimensional array. The routine computes the product AB and stores the results in C. The input arguments ka, kb, ke have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program

ke = the number of rows in the dimension statement for C in the calling program It is assumed that ka > m, kb > n, ke > m, and that C contains at least @ columns.

**Remark.** It is assumed that the storage area for C is separate from the storage areas for A

and B. Programmer. A. H. Morris.

```fortran
CALL MPROD(M, N, L, A, KA, B, KB, C, KC, ROW)
CALL DMPROD(M, N, L, A, KA, B, KB, C, KC, ROW)
CALL CMPROD(M, N, L, A, KA, B, KB, C, KC, ROW)
```

MPROD is used if A and B are real matrices and C and WK are real arrays, DMPROD is used if A and #% are double precision matrices and C and WK are double precision arrays, and CMPROD is used if A and B are complex matrices and C and WK are complex arrays.

A is a matrix having m rows and n columns, B a matrix having n rows and @ columns, and C a 2-dimensional array. The routine computes the product AB and stores the results in C. The input arguments ka, kb, kc have the following values:

ka == the number of rows in the dimension statement for A in the calling program

kb => the number of rows in the dimension statement for 8 in the calling program

ke :. the number of rows in the dimension statement for C in the calling program Ib is assumed that ka > m, kb > n, ke 2 m, and that C contains at least & columns.


<small>Original source: [View scanned PDF page 156](scans/page_0156.png)</small>

WK is an array that serves as a temporary storage area. The matrix C may begin in the same location as A or B. If C begins in the same location as A, then it is assumed that ke = ka and that the dimension of WK. is equal to or greater than @. In this case, the result C’ will overwrite the input data A. Similarly, if C begins in the same location as B then if is assumed that ke =: kb and that the dimension of WK is equal to or greater than m. Otherwise, if C does not begin in the same location as A cr B, then it is assumed that the storage area for C does not overlap with the storage areas for A and B. In this case, the array WK is not referenced.

**Remark.** If C begins in the same location as A or B, then it is assumed that the storage areas for A and B are distinct storage areas.

**Programming.** MPROD employs the subroutines RLOC and YCHG, DMPROD employs

the subroutines DLOC and DYCHG, and CMPROD employs the subroutines CLOC and CYCHG. The routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 157](scans/page_0157.png)</small>

<a id="topic-157-01"></a>
### Product Of A Packed Symmetric Matrix And A Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SVPRD` | `SUBROUTINE` | `A, N, X, Y` | [`L37058`](source_parts/nswc_part_04.f90#L5345) |
| `DSVPRD` | `SUBROUTINE` | `A, N, X, Y` | [`L37085`](source_parts/nswc_part_04.f90#L5372) |


Let A denote a packed symmetric matrix of order n and x a column vector of dimension vn where n > 1. Then the following subroutines are available for computing the product Az.

```fortran
CALL SVPRD(A, N, X, Y)
CALL DSVPRD(A, N, X, Y)
```

The argument y is an array of dimension n. SVPRD is called when A,z,y are real arrays and DSVPRD is called when A,z,y are double precision arrays. When either of these routines is called, Az is computed and stored in y.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 158](scans/page_0158.png)</small>

<a id="topic-158-01"></a>
### Transpose Matrix Products

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TMPROD` | `SUBROUTINE` | `M, N, L, A, KA, B, KB, C, KC` | [`L37112`](source_parts/nswc_part_04.f90#L5399) |


If At denotes the transpose of A, then the matrix product C =: AtB can be computed by the following subroutine:

```fortran
CALL TMPROD(M, N, L, A, KA, B, KB, C, KC)
```

A is a real matrix having m rows and n columns, B a real matrix having m rows and @ columns, and C a real 2-dimensional array. TMPROD computes A‘B and stores the results in C’. The input arguments ka, kb, kc have the following values:

ka = the number cf rows in the dimension statement for A in the calling program

k5 =: the number of rows in the dimension statement for B in the calling program

kc = the number of rows in the dimension statement for C in the calling program Here it is assumed that ka > m, kb > m, ke > n, and that C contains at least & columns. Also it is assumed that the storage area for C does not overlap with the storage areas for A and B.

**Note.** All inner products >) a,,6,; are computed in double precision and the results stored k

in single precision.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 159](scans/page_0159.png)</small>

<a id="topic-159-01"></a>
### Symmetric Matrix Products

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SMPROD` | `SUBROUTINE` | `M, N, A, KA, B` | [`L37130`](source_parts/nswc_part_04.f90#L5417) |


If A’ denotes the transpose of A, then the matrix product A&A can be computed and its packed form stored in the array B by the following subroutine:

```fortran
CALL SMPROD(M, N, A, KA, B)
```

A is a real m x n matrix and B a real array whose dimension is equal to or greater than n(n + 1)/2. SMPROD computes A‘A and stores its packed form in B. The input argument a has the following value:

ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > m.

**Note.** All inner products 5 4,:4,; are computed in double precision and the results stored k

in single precision.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 160](scans/page_0160.png)</small>

<a id="topic-160-01"></a>
### Kronecker Product Of Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `KPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [`L37150`](source_parts/nswc_part_04.f90#L5437) |
| `DKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [`L37179`](source_parts/nswc_part_04.f90#L5466) |
| `CKPROD` | `SUBROUTINE` | `A, KA, M, N, B, KB, K, L, C, KC` | [`L37208`](source_parts/nswc_part_04.f90#L5495) |


If Ais anm xn matrix and Bak « @ matrix, then the Kronecker product A ® 8 is

defined by

A@B= Dod, aQm1B +: a)

From this definition we obtain:

(1) (Transpose Equality) (A @ B)' = At @ Bt.

(2) (A® B)@F= A@(B@ E) for any matrix EF.

(3) (A@ BY(C@ DL) = (AC) @(BD) iC is a matrix having n rows and D a matrix having £ rows.

If A and B are complex square matrices of orders m and k respectively, then from the Jordan

canonical forms of A and B the determinant equality det (A@ B) = (det A)* (det B)™ can

be verified. Moreover, if A and B are nonsingular then (A 2 B)~' =. A~* @ B™! from. (2).

The following subroutines are available for computing C = A B.

CALi KPRC D(A, ka, m,n, B, kb, k, ?,C, ke) CALL DKPROD(A, ka, m,n, B, kb, k, £,C, ke) CALL CKPROD(A, ka, m,n, B, kb, k:, €,C, ke)

It is assumed that A is an m X n matrix, B a k x @ matrix, and C' a 2-dimensional array. KPROD is used if A, B,C are real arrays, DKPROD its used if A, B,C are double precision arrays, and CKPROD is used if A, B,C’ are comp!ex arrays. When the routine is called, A ® B is computed and stored in C.

The arguments ka, kb, and ke have the following values: ka = the number of rows in the dimension statement for A in the calling program kb = the number of rows in the dimension statement for B in the calling program ke = the number of rows in the dimension statement for C in the calling program It is assumed that ka > m, kb > k, ke > mk, and that C contains at least né columns.

**Remark.** It is assumed that the array C does not overlap with «4 or B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 161](scans/page_0161.png)</small>

<a id="topic-161-01"></a>
### Rank Of A Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [`L37237`](source_parts/nswc_part_04.f90#L5524) |
| `DRNK` | `SUBROUTINE` | `A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK` | [`L37334`](source_parts/nswc_part_04.f90#L5621) |


The following subroutines are available for obtaining lower and upper bounds for the rank of real matrix.

```fortran
CALL RNK(A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK)
CALL DRNK(A, MDA, M, N, RE, AE, KRANK, KSURE, WORK, IWORK)
```

A and WK are real arrays and RERR and AERR real values if RNK is used. A and WK are double precision arrays and RERR and AERR double precision values if DRNK is used.

Ais anm Xn matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ke > m. A is destroyed by the routine.

RERR is an argument which specifies that relative accuracy of the data in A. If it is estimated that the elements in A are accurate to u significant digits then one may set RERR == 1074. It is required that RERR > 0. If RERR = 0 then it is assumed that, the elements in A are accurate to machine precision.

AERR is an argument which specifies the maximum absolute uncertainty of the data in A. For example, if it is estimated that the elements a,,; of A have the relative accuracy RERR except when |a,;;| < 107%°, then one may set AERR = 107°°. It is required that AERR > 0.

The arguments k and ko are variables. When RNK or DRNK is called, the rank of A is bounded from above and below using the tolerances RERR and AERR. The variable k is set to the upper bound and k, to the lower pound.

WK is an array of dimension 5- min{m,n} or larger, and 1WK an array of dimension m-+n or larger. WK and IWK are work spaces for the routines.

Remarks. Normally kp =: «, ia which case k is the rank of A. However, if ko 5“ « then it is recommended that the least squares routine HF TI2 or DHF T2 be used for obtaining the most appropriate value for che rank. When HFTI2 or DHF 12 is used, B may be selected to b. the m x m identity matrix, aud the size of the elements of the solution matrix X should be considered (in addition tu the values of the residual norms). Frequently, the lower bound ko will be found to be the most appropriate value for the rank.

**Programming.** RNK employs the subroutines ULILS, ULIUS, ISWAP, SSWAP, SAXPY, SSCAL and functions SDOT, SNRM®, [SMMAZX, SPMPAR, IPMPAR. DRNK employs the subroutines DULILS, DULIIUS, ISWAF, DSEWAP, DAXPY, DSCAL and functions DOOT, DNRM2, IDAMAX, DPMPAR, IPMPAR. KNK and DRNK were written by A. H. Morris, and O'ELS, UILUS, DULILS, PULINS, were written by T. Manteuffel (Los Alamos).

**Reference.** Manteuffel, U., An Interval Analysts Approach to Rank Determination


<small>Original source: [View scanned PDF page 162](scans/page_0162.png)</small>

in Linear Least Squares Problems, Report SAND 80-0655, Sandia Laboratories, Albuquerque, New Mexico, 1980.


<small>Original source: [View scanned PDF page 163](scans/page_0163.png)</small>

<a id="topic-163-01"></a>
### Inverting General Real Matrices And Solving General Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, D, INDEX, TEMP` | [`L37433`](source_parts/nswc_part_04.f90#L5720) |
| `KROUT` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP` | [`L37646`](source_parts/nswc_part_04.f90#L5933) |
| `NPIVOT` | `SUBROUTINE` | `N, M, A, KA, B, KB, D, IERR` | [`L37998`](source_parts/nswc_part_04.f90#L6285) |
| `MSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [`L38253`](source_parts/nswc_part_04.f90#L6540) |
| `MSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [`L38297`](source_parts/nswc_part_04.f90#L6584) |
| `DMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [`L39111`](source_parts/nswc_part_04.f90#L7398) |
| `DMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [`L39155`](source_parts/nswc_part_04.f90#L7442) |


The subroutines CROUT, KROUT, MSLV, MSLV1, NPIVOT, DMSLV, and DMSLV1 are available for inverting real matrices A and solving systems of real linear equations AX = B. CROUT, KROUT, MSLV, MSLV1, and NPIVOT solve single precision problems, and DMSLV and DMSLV1 solve double precision problems.

All the routines except NPIVOT are general-purpose, employing partial pivot Gauss elimination. NP{VOT can only occasionally be used since it uses Gauss-Jordan elimination with no pivot search. Normally CRO'/T and KROUT produce the same results, and M5LV and MSLV1 produce the same results. Since many of the calculations are performed in double precision in CROUT and KR DUT, these subroutines will be slower than MSLV and MSLV1, but they may be more accurate.

```fortran
CALL CROUT(MO, N, M, A, KA, B, KB, D, INDEX, TEMP)
```

A is areal matrix of order n where n > 1. If MO = 0 then the inverse of A is computed and stored in A. If MO #0 then the ‘verse is not computed.

The argument rm is a: integer. If m > 1 then B is a real matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in B. If m < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A un the calling program, and kb the number of rows in the dimension statement for B in the calling program. lf m<. 0 then the argument k6 is ignored.

D is a real variable. When CROUT is called, D is assigned the value det(A) where det(A) is the determinant of A. If D is found to have the value 0 then the routine immediately terminates.

INDICX is an array of dimension n ~ | or larger that is used by the routine for keeping track of the row interchanges that are made. If MO 4 0 then INDEX is ignored.

TEMP is a real array of dimension n or larger that is a work space for the routine. If MO / 0 then TEMP 13 ignored.

**Remarks.**

(1} KROUT should be used instead of CROU'P when the determinant 22 is not needed. Underflow or overflow in the calculation of 2) may cause CROU'T to terminate prematurely.

(2) ‘The matrix Ais destroyed.

21S


<small>Original source: [View scanned PDF page 164](scans/page_0164.png)</small>

**Algorithm.** The Crout procedure is used. All inner products are computed in double precision and the results returned in single precision. Partial pivoting is performed.

**Programming.** CROUT calls the subroutine CROUTO. These routines were written by A. H. Morris.

```fortran
CALL KROUT(MO, N, M, A, KA, B, KB, IERR, INDEX, TEMP)
```

A is a real matrix of order n where n > 1. If MO = 0 then the inverse of A is computed and stored in A. If MO # 0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a real matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in B. If m < O then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored.

[INDEX is an array of dimension n -- 1 or larger that is used by the routine for keeping track of the row interchanges that are made. If MO # 0 then INDEX is ignored.

TEMP is a real array of dimension n or larger that is a work space for the routine. If MO #0 then TEMP is ignored.

**Error Return.** [ERR is a variable that reports the status of the results. When the routine terminates JERR has one of the following values:

IERR = O The requested results were obtained.

IERR =: ~1 Either n, ka, or kb is incorrect. In this case, A and B have not been modified.

IERR = k& The kt column of A has been reduced to a column containing

only zeros.

When an error is detected, the routine immediately terminates. Remark. The matrix A is destroyed.

**Algorithm.** The CROUT procedure is used. All inner products are computed in double precision and the results returned in single precision, Partial pivoting is performed.

**Programming.** KROU'T calls the subroutine KROUTO. These routines were written by A. HL. Morris.

```fortran
CALL NPIVOT(N, M, A, KA, B, KB, D, IERR)
```

A is a real matrix of order n where n+ b When NPEVO’V is called the inverse of Ats

computed and stored my A,


<small>Original source: [View scanned PDF page 165](scans/page_0165.png)</small>

The argument m is an integer. If m > 1 then B is a real matrix having n rows and m columns. In this case the matrix equation AX = 77 ia solved and the solution X is stored in 3. lfm <0 then there are no equations to be solved. In this case the argument B is ignored,

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program. If m <0 then kb is ignored.

D is a real variable. On input D must be assigned a value by the user. If the input value is 7, then when NPIVOT terminates D = rd where d is the determinant of A.

Error Return JERR is an integer variable. If inversion is successful then IERR is assigned the value 0. Otherwise, JERR = 1 if NPIVOT cannot invert the matrix.

**Algorithm.** The Gauss-Jordan procedure is used. However, no pivot searching is done. NPIVOT terminates (with IERR set to 1) whenever a zero pivot element is encountered.

**Remarks.** Since pivot search is frequently needed to invert a matrix, and since pivot search is normally required to obtain accurate results, NPIVOT should not be used except on those occasions when pivot search is known to be superfluous.

**Programmer.** A. H. Morris.

```fortran
CALL MSLV(MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK)
CALL DMSLV(MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK)
```

A is a matrix of order n where n > 1. If MO == 0 then the inverse of A is computed and stored in A. If MO # 0 then the inverse is not computed.

The argument rm is an integer. If m > 1 then B is a matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in 8. If m < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for 8 in the calling program. If m < 0 then the argument ké is ignored.

D is an array of dimension 2. When either routine 1s called the determinant det(A) of the matrix A is computed. If det{A) ~ d- 10* where 1 < |d| < 10 and k an integer, then d ig stored in (1) and the exponent & is stored in floating point form in D(2).

RCOND os a variable. When either routine is called, the routine makes an estimate c of the condition number of the matrix A (relative to the Ly norm), RCOOND ts assigned

the value L/e. IWK is an array of dimension nor larger that is used by the routines for ke. ping track


<small>Original source: [View scanned PDF page 166](scans/page_0166.png)</small>

af the row interchanges that are made. WK is an array of dimension n or larger that. ig used as a work space.

**Remarks.**

(1) If MSLV is called then it is assumed that A and B are real matrices, D and WK real arrays, and RCOND a real variable. Otherwise, if DMSLV is called then it is assumed that A and B are double precision matrices, D and WK double precision arrays, and RCOND a double precision variable.

(2} RCOND satisfies 0 < RCOND < 1. If RCOND w 10~* then one can expect the results to have approximately k& fewer significant digits of accuracy than the elements of A. For example, if MSLV is used to invert a matrix in the 14 digit CDC sing!e precision arithmetic and RCOND = .4E~-3, then the computed coefficients of the inverse matrix should normally be accurate to about 11 digits. In general, RCOND characterizes how well or poorly conditioned the problem is. If RCOND #& 1 then one should expect the results to be almost as accurate as the original data A. However, if RCOND s 0 then one should expect the results to be nonsense.

(3) The matrix A is destroyed.

**Error Return.** JERR is an integer variable. If RCOND is sufficiently large so that 1+ RCOND > 1, then IERR is set to 0 and the problem is solved. Otherwise, if 14+-RCOND = 1 then {ERR is set to 1 and the routine terminates. In this case, A will have been destroyed but B will not have been modified. Also the determinant will not have been computed.

**Algorithm.** The partial pivot Gauss elimination procedure is used.

**Programming.** MSLV and DMSLV are driver routines for the LINPACK subroutines SGECO, SGEFA, SGESL, SGEDI and DGECO, DGEFA, DGESL, DGEDI. The subroutines were coded by Cleve Moler (University of New Mexico). The subroutines employ the vector routines SSWAP, SDOT, SSCAL, SAXPY, SASUM, iSAMAX and DSWAP, DDOT, DSCAL, DAXPY, DASUM, IDAMAX.

**References.**

(1) Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart. G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.

(2) Cline, A. K., Moler, C. B., Stewart, G. W., and Wilkinson, J. H., “An Estimate for the Condition Number of « Matrix,” SIAM Journal of Numerical Analysis 16 (1979), pp. 858-375.

```fortran
CALL MSLV1(MO, N, M, A, KA, B, KB, IERR, IPVT, WK)
CALL DMSLV1(MO, N, M, A, KA, B, KB, IERR, IPVT, WK)
```

Ais a matrix of order n where n > 1. If MO = 0 then the inverse of A 1s computed and stored in A. If MO 7 O then the inverse is not computed,

The argument m is an integer. [fw > i then 8 is a matrix having n rows and m columns. In this case the matrix equation AN Bois solved and the solution is stored in B. If m < U then there are no equations to be solved. In this case the


<small>Original source: [View scanned PDF page 167](scans/page_0167.png)</small>

argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored,

IWK is an array of dimension m or larger that is used by the routines for keeping track of the row interchanges that are made. WK is an array of dimension n o¢ larger that is used for a work space. If MO 3 0 then WK is ignored.

Remarks.

(1) If MSLV1 is called then it is assumed that A and B are real matrices and WK i. real array. Otherwise, if DMSLV1 is called then it is assumed that A and B are double precision matrices and WK a double precision array.

(2) The matrix A is destroyed.

**Error Return.** TERR is a variable that reports the status of the results. When the routine terminates JERR has one of the following values:

TERR = 0 The requested results were obtained.

IERR = --1 Either n, ka, or kb is incorrect. In this case, A and B have not been modified.

IERR = &k The k*® column of A has been reduced to a column containing only zeros,

**Algorithm.** The partial pivot Gauss elimination procedure is used.

**Programming.** MSLV1 and DMSLV | are driver routines for the LINPACK subroutines SGEFA, SGESL, SGEDI and DGEFA, DGESL, DGEDI. The subroutines ‘vere coded by Cleve Moler (University of New Mexico). The subroutines employ the vector routines SSWAP, SDOT, SS- CAL, SAXPY, SASUM, ISAMAX and DSWAP, DDOT, DSCAL, DAXPY, DASUM, IDAMAX.

**References.**

(1) Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.

(2) Cline, A. K., Moler, C. B., Stewart, G W., and Wilkinson, J. H., “An Estimate for the Condition Number of a Matrix,” SIAM Journal of Numerical A: alysts 16 (1979), pp. 368-375.


<small>Original source: [View scanned PDF page 168](scans/page_0168.png)</small>

<a id="topic-168-01"></a>
### Solution of Real Equations with Iterative Improvement

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [`L38338`](source_parts/nswc_part_04.f90#L6625) |


Given a real n <1 matrix A and column vector 6. The following, subroutine is available for solving the equation Ax = 4. Iterative improvement 's performed to compute the solution x to machine accuracy,

```fortran
CALL SLVMP(MO, N, A, KA, B, X, WK, IWK, IERR)
```

MO is an input argument. which specifies if SLVMP is being called for ihe first time. On an initial call, MO = 0 and we have the following setup:

A is a 2-dimensional real array of dimension «a X n containing the matrix A, 6 « real vector of dimension », and X a real array of dimension n. When SLVMF is called, Ar = & is solved and the solution stored in X. A and $ are not modified by the routine.

WK is a real array of dimension n*+n or larger, and [WK an integer array of dimension n or larger. These arrays are for internal use by the routine. On un initial call to SLV MP, «1 LU decomposition is obtained for A and stored in WK and IWK. Then the equation Ax = 6 1s solved.

IND is an integer variable that reports the status of the results. On an initial call to SLVMP, when the routine terminates IND has one of the following values:

IND = 0 The solution X was obtained to machine accuracy.

IND = 1 X was obtained, but not to machine accuracy.

IND = —k The k** column of A was reduced to a column containing only zeros.

When IND = —k&, no solution is obtained.

After an initial call to SLVMP, if IND == 0 or 1 on output, then the routine may be called to solve a new set of equations Az == 6 without having to redecompose the matrix A. In this case, the input argument MO may be set to any nonzero value. When MO #0 it is assumed that only 6 has been modified. The routine employs the LU decomposition obtained on the initial call to SLYMP to solve the new set of equations Ar = 6. On output X will contain the solution to the new set uf equations. As before, A and b are not modified by the routine.

{f SLVMP is recalled with MO 4 0, then when the routine terminates IND has one of the following values:

IND = 0 The solution X was obtained to machine accuracy,

IND = 1 X was obtained, but not to machine accuracy. Programming. SLY MP calls the subroutine LUIMP. These routines were written by A. H Morris. The subroutines MCOPY, SGEPA, SGESL, SSCAL, SAXPY and functions SUM. PAR, SDOT, ISAMAX are also employed.


<small>Original source: [View scanned PDF page 169](scans/page_0169.png)</small>

<a id="topic-169-01"></a>
### Solution Of Almost Block Diagonal Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ARCECO` | `SUBROUTINE` | `N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG` | [`L39831`](source_parts/nswc_part_04.f90#L8118) |
| `ARCESL` | `SUBROUTINE` | `ARRAY, MTRSTR, NMBLKS, PIVOT, B, X` | [`L40474`](source_parts/nswc_part_04.f90#L8761) |


Consider a system Az == 6 of linear equations where A is ann x n matrix having the block structure

Here it is assumed that A, is an r; x c¢; matrix ford = 1,...,m, and that A; and Ajai may m

have 6; >> 9 columns in common for ¢ < m, Thus SO rp n and block A, begins in column al

pany

», (cx ~ Oe) -+ L fer ¢ > 2. It is also assumed that three successive blacks Ay-1, Aj, Assi

k=

do not have columns in common, Thus 65.1 + & < ec; ford = 2, ...53 ~ 1. Ifm > 2 then

the following subroutines are available for solving Az = 6.

```fortran
CALL ARCECO(N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG)
```

mn Sis an array of dimension )% r,¢; or larger. On input S contains the blocks Ay, ..-;Am dak of the matrix A. The blocks are stored in sequence. A, is stored in the first rc, locations of S, Ag is stored in the next recy locations, etc. For each Ax, the columns of A; are stored

in sequence in S.

**Example.**

Pasy 12 43 0 G

2 0 0 [aso gs a4 7 G | ‘

aa Qz2 423 |

249 Gas esa |

0 0 Oo fa then noc 5

ya, 822, 0)3,423, 232,442, 433, %43, 134,444, Ass.

» mm 9 8, by = 2, and 62 = QO. Also, S is an array containing the data 11,421,

M'TR is an integer matrix of dimension 3 x m containing the block information of the matrix A:

MPRA1, 8) ss ry (f— 1, ...,m) MTR(Z,1) (t= 7, ...,m) MTR, £} & (g=-1,...,- 2)

For convenience, the routine sets MTR(3, m) . 0.

y

On

Perens


<small>Original source: [View scanned PDF page 170](scans/page_0170.png)</small>

X is an array of dimension n or larger. When ARCECO is called, A is decomposed and then the equations Az = 6 are solved. The decomposition of A is stored in S, overwriting the initial input data A, and the solution 2 is stored in X. The vector 6 is destroyed by the routine.

IWK is an array of dimension n or larger for internal use by the routine. ‘The pivot indices involved in the decomposition of A are stored in IWK.

```text
IND is a variable that reports the status of the results. When ARCECO terminates,
IND has one of the following values:
```

IND = 0 The system of equations was solved.

IND = 1 (Input Error) Either n,m, or MTR is incorrect, or three successive blocks A,_1, Ay, Ay41 of A have columns in common.

IND =~—1 A is a singular matrix. The equations cannot be solved.

Usage. After a call to ARCECO, if IND = 0 on output then the subroutine ARCESI. (see below) may be called to solve a new set of equations Az = 6 without having to redecompose the matrix A. ARCESL employs the decomposition of A obtained by ARCECO.

**Algorithm.** A modification of the alternate row and column elimination procedure by Varah is used.

**Programming.** ARCECO employs the routines ARCEDC, ARCEPR, ARCEPC, ARCESL, ARCEFS, ARCEFM, ARCEFE, ARCEBS, ARCEBM, and ARCEBE. These routines were developed by J. C. Diaz (Mobil Research and Development Corp., Farmers Branch, Texas), G. Fairweather (University of Kentucky), and P. Keast (University of Toronto).

**Reference.** Diaz, J. C., Fairweather, G., and Keast, P., “FORTRAN Packages for Solving Certain Almost Block Diagonal Linear Systems by Modified Alternate Row and Column Elimination,” ACM Trane. Math Software 9 (1983), pp. 358-375.

```fortran
CALL ARCESL(ARRAY, MTRSTR, NMBLKS, PIVOT, B, X)
```

The argument m is the number of blocks A,,...,Am in the matrix A. ARCESL may be used only when IND = 0 on output from ARCECO. In this case, S contains the decomposition of A obtained by ARCECO and I5VK contains the pivot indices of the decomposition. The argument 6 is a vector of dimension n, and X an array of dimension nor larger. When ARCESL is called, the equations Az = 6 are solved and the solution stored in X. The vector 6 is destroyed by the routine.

**Programming.** ARCESL calls the subroutines ARCEFS, ARCEFM, ARCEFE, ARCEBS, ARCEBM, and ARCEBE. These routines were developed by J. ©. Diaz (Mobil Research and Development Corp.,Farmers Branch, Texas), G. Fairweather (University of Kentucky), and P. Keast (University of Tc onto).


<small>Original source: [View scanned PDF page 171](scans/page_0171.png)</small>

<a id="topic-171-01"></a>
### Solution Of Almost Block Tridiagonal Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BTSLV` | `SUBROUTINE` | `MO, M, N, A, B, C, X, IP, IERR` | [`L40873`](source_parts/nswc_part_04.f90#L9160) |


Consider a system J7'r =: 6 of linear equations where 7’ is a square matrix having the block structure

Ay By Ci Cy Ag By @) C's Ag Bz

Cn-1 Aner Bros B,, Cn Ay,

Here it is assumed that Ay, Be,Ce (k = 1,...,n) are mxm matrices, and that 6 is a column vector of dimension mn. If 2 > 4 the: he following subroutine is available for solving Tz = d.

```fortran
CALL BTSLV(MO, M, N, A, B, C, X, IP, IERR)
```

MO is an input argument which specifies if BT'SLV is being called for the first time. On an initial call, MO = 0 and we have the following setup:

A, B, C are 3- dimensional arrays of dimension m x mx n where the (t,7)-th elements of the matrices Aj, 3x,Cx are stored in A(t,j,k), B(t, j,k), C(i,9,k) for k = 1,...,n. A, B,C are modified by the routine.

X is an array of dimension mn or larger. On input, the vector 6 is stored in X. When BTSLV is called, 1! a solution x is obtained for T’z = 6 then the solution is stored in X.

IP is an array of dimension mn or larger that is used by the routine fv listing the row interchanges that are made.

On an initial call to the routine, a block IU decomposition is performed on T, the results of which are stored in A,B,C. This decomposition involves row interchanges only within the diagonal blocks Ax; i.e., no row interchanges are performed between rows of different blocks Ay and Ag. Thus it may occur that the decomposition of a nonsingular matrix T cannot be completed. IND is a variable that reports the status of the results. When BTSLV terminates, IND has one of the following values:

IND = 0 T was decomposed and the equations Tx = 6 solved.

IND =~1 (Input Error) Either m < Lorn < 4.

IND = k The decomposition process failed in the &'* diagonal block. The

routine cannot solve the equations in their present form.

After an initial call to BTSLV, if IND -: 0 then the routine may be recalled with MO # 0 and a new 6. When MO ¥ 0, then it is assumed that A,B,C, and IP have not. beer modified and that X contains the new 6. The routine retrieves from A,B,C, and IP the block decomposition that was obtained on the initial cali io BTSLV, and solves the nev


<small>Original source: [View scanned PDF page 172](scans/page_0172.png)</small>

system of equations Tx =: 6. The solution is stored in X. In this case, IND 1s not referenced by the routine.

Programming. BTSLV employs the subroutines DECBT, SOLBT, DEC, and SOL. These subroutines were written by Alan C. Hindmarsh (Lawrence Livermore Laboratory).

**Reference.** Hindmarsh, A. C., Solution of Block-Tridiagonal Systems of Linear Algebraic Equations, Report UCID-30150, Lawrence Livermore Laboratory, 1977.


<small>Original source: [View scanned PDF page 173](scans/page_0173.png)</small>

<a id="topic-173-01"></a>
### Inverting Symmetric Real Matrices And Solving Symmetric Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [`L41082`](source_parts/nswc_part_04.f90#L9369) |
| `DSMSLV` | `SUBROUTINE` | `MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK` | [`L42183`](source_parts/nswc_part_04.f90#L10470) |


‘The subroutines SMSLV and DSMSLV are available for inverting symmetric real matrices A and solving systems of real linear equations AX = B. SMSLV handles single precision problems and DSMSLV handles double precision problems. it is assumed that the matrix A is in packed form. [f the inverse of A is computed, then the verse is a symmetric matrix which will be stored in packed form.

**Note.** All eigenvalues of a real symmetric matrix A are real. The inertia of A is the ordered triple (x,v,¢) where w ia the number of positive eigenvalues of A, v the number of negative eigenvalues of A, and ¢ the number of zero eigenvalues of A. Thus, if n is the order of A then w-+u+¢ =n. Also A is positive definite (positive semi-definite, negative definite, negative semi-definite) if m =n (v=0,v=n,x =O).

```fortran
CALL SMSLV(MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK)
CALL DSMSLV(MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK)
```

A is an array of dimension n(n + 1)/2 containing the elements of a packed n x n symmetric matrix where n > 1. If MO = 0 then the inverse of A is computed and stored in A in packed form. If MO # 0 then the inverse of A is not computed.

The argument m is an integer. If m > 1 then B is a matrix having n rows and m columns. In this case AX = B is solved and the solution X is stored in HB. If rn < © then there are no equations to be solved. In this case B is ignored.

The argument kb is the number cf rows in the dimension statement, for B in the calling program. If m < 0 i ‘en ké is ignored.

1 is an array of dimension 2. When either routine is called the determinant det(A) of the matrix A is computed. If det(A) = d- 10* where 1 < |d| < 10 and & an integer, then d is stored in D(1) and the exponent & is stored in floating point form in (2),

RCOND is a variable. When either routine is called, the routine makes an estimate ¢ of the condition number ef the matrix A (relative to the Ly norm). RCOND is assigned the value I/c.

INER'E is an integer array of dimension $. When either routine is called she inertia of the matrix Ais computed. INERT(L) is set to ti number of positive eigenvalues of A, INERT (2) is set to the number of negative eigenvalues and INFET(3) is set to the number

af vere: etgenvalse

IPV Po os as integer array of dimension reoor urge: tats used by the routines fir

keeping track of she row and column interchanges t) at are vde WK te array of dimension

root baw: that is used as a work space.


<small>Original source: [View scanned PDF page 174](scans/page_0174.png)</small>

**Remarks.**

(1) If SMSLV is called then it is assumed that A and B are real matrices, D and WK are real arrays, and RCOND i» a real variable. Otherwise, if DSMSLV is called then it is assumed that A and 8 are double precision matrices, D and WK are double precision arrays, and RCOND is a double precision variable.

(2) RCOND satisfies 0 < RCOND < 1. If RCOND ® 10~* then one can expect the results to have approximately k fewer significant digits of accuracy than the elements of A. For example, if SMSLV is used to invert a matrix in the 14 digit CDC single precision arithmetic and RCOND -- .4E—3, then the computed coefficients of the inverse matrix should normally be accurate to about 11 digits. In general, RCOND characterizes how well or poorly conditioned the problem is. If RCOND #& 1 then one should expect the results to be almost as accurate as the original data A. However, if RCOND ~ 0 then ne should expect the results to be nonsense.

(3) ‘The data in A is destroyed.

Error Return, [IERR is an integer variable. If RCOND is sufficiently large so that 1 + RCOND > 1, then [ERR is set to 0 and the problem is solved. Otherwise, if 1 +- RCOND == 1 then JERR is set, to 1 and the routine terminates. In this case, A will have been destroyed but B will not have been modified. Also the determinant and inertia will not have been computed.

**Algorithm.** Toe diagonal pivoting factorization procedure is used. Partial pivoting is employed.

**Precision.** SMSLV and the more general routine MSLV have approximately the same accuracy, and DSMSLV and DMSLV have approximately the same accuracy.

Efficiency. iive: though SMSLV performs approximately half the number of multiplications and divisions as MSLV, normally one can expect SMSLV to take about 70-80% of the time required by MSLV. However, for sparse matrices SMSLV may be 20-30% slower than MSLYV. Similar comments hold for DSMSLV and DMSLV.

**Programming.** OMSLV and DSMSLV are driver routines for the LINPACK subroutines SSPCO,SSPFA,SSPSL, SsPDL and DSPCO, DSPFA, DSPSL, DSPDI. SSPCO and DS2CO were written by Cleve Moler (University of New Mexico). The remaining LINPACK subroutines were written by James Kuanch (University of California, San Diego}. The subroutines employ the vector routines SCOPY, SSWAP, SDOT, SSCAL, SAXPY, SASUM, ISAMAX and DSWAP, DDO'T, DSC AL, DAXPY, DASUM, IDAMAX.

**References.**

(1) Bureh, Jo Ro and Parlett, BON “Direct Methods for Solving Symmetric Indefinite Systems of Liner Equations,” SIAM J. Numerical Analysis 8 (1971), pp. @80 655,

f2) Bunch, JO Ro, CAnatysis of the Diagonal Pivefttie Method,” STAAT J. Numerical Analysis B CIS UE) pp. 656 GkO.


<small>Original source: [View scanned PDF page 175](scans/page_0175.png)</small>

(3) Bunch, J. R., Kaufman, L., and Parlett, B.N., “Decomposition of a Symmetric Matrix,” Numerische Mathematik 27 (1975), pp. 95-109.

(4) Bunch, J., and Kaufman, L., “Some Stable Methods for Calculating Inertia and Solving Symmetric Linear Systems,” Math. Comp. 31 (1977), pp. 163-179.

(5) Cline, A. K., Moler, C. B., Stewart, G. W , and Wilkinson, J. H., “An Estimate for the Condition Number of a Matrix,” SIAM Numerical Analysis 16 (1979), pp. 368-375.

(6) Dongarra, J. J., Bunch, J. R., Moler, ©. B., and Stewart, G. W., LINPACK Vaers’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.


<small>Original source: [View scanned PDF page 176](scans/page_0176.png)</small>

<a id="topic-176-01"></a>
### Inverting Positive Definite Symmetric Matrices And Solving Positive Definite Symmetric Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [`L43284`](source_parts/nswc_part_05.f90#L1061) |
| `DPCHOL` | `SUBROUTINE` | `MO, N, M, A, B, KB, IERR` | [`L43630`](source_parts/nswc_part_05.f90#L1407) |


The subroutines PCHOL and DPCHOL are available for inverting positive definite symmetric real matrices A and solving systems of real linear equations AX = B. PCHOL handles single precision problems and DPCHOL handles double precision problems. It is assumed that the matrix A is in packed form. If the inverse of A is computed then the inverse is a symmetric matrix which will be stored in packed form.

```fortran
CALL PCHOL(MO, N, M, A, B, KB, IERR)
CALL DPCHOL(MO, N, M, A, B, KB, IERR)
```

A is an array of dimension n(n + 1)/2 or larger containing the elements of a packed n Xn positive definite symmetric matrix where n > 1. If MO = 0 then the inverse of A is computed and stored in A in packed form. If MO # 0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a matrix having n rows and m columns. In this case AX = B is solved and the solution X is stored in B. If m < 0 then there are no equations to be solved. In this case B is ignored.

The argument kb is the number of rows in the dimension statement for B in the calling program. If m < 0 then kb is ignored.

**Remarks.**

(1) If PCHOL is called then it is assumed that A and 8 are real arrays, and if DPCHOL is called then it is assumed that A and B are double precision arrays.

(2) Te data in A is destroyed.

**Error Return.** [ERR is an integer variable. If A is positive definite then IERR is set to 0 and the problem is solved. Otherwise, IERE = & if the leading k x k submatrix of A is not positive definite.

**Algorithm.** The Cholesky procedure is used.

**Precision.** The results obtained by PCUOL and DPCHOL are occasionally less accurate (up to a significant digit) than the results obtained by SMSLV and DSMSLV.

Programming, PCHOL and DPCHOL are driver routines for the LINPACK subroutines SPPFA,SPPSE, SPPD} and DPPPA, DPPSL, DPPDI. These subroutines were written by Cleve Moler (University of New Mexico). ‘The functions SDO'T, DDOT and subroutines SAXPY, SSCAL, DAXPY

DSCAL are also used.

Y

Reference. Dongarra, J. J. Bunch, 3. Ro, Moler, (Bo, and Stewart, G. Wo, LIN PACK

Y

Us re’ Gourde, Society for Industrial and Applied Mathematics, Philadelphia, 1979


<small>Original source: [View scanned PDF page 177](scans/page_0177.png)</small>

<a id="topic-177-01"></a>
### Solution Of Toeplitz Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [`L43976`](source_parts/nswc_part_05.f90#L1753) |
| `DTOPLX` | `SUBROUTINE` | `A, B, X, N, G, H, IERR` | [`L44069`](source_parts/nswc_part_05.f90#L1846) |


Ann xn Toeplitz matrix is a matrix of the form

ao a_+s a4 eee) Gong

ay ag a_y see Ain42

ag ay ao cee Gents Qn-1 Gn-2 An-g ... agp /

For convenience, we denote this matrix by A, forn > 1. If A, is a real matrix where ap 4 0 and 6 is a real column vector, then the subroutines TOPLX and DTOPLX are available for solving the system of equations A,z = 6. TOPLX is a single precision routine and DTOPLX a double precision routine.

```fortran
CALL TOPLX(A, B, X, N, G, H, IERR)
CALL DTOPLX(A, B, X, N, G, H, IERR)
```

TOPLX is used if A,b,z,G, H are real arrays, and DTOPLX is used if 4,b,2,G, H are double precision arrays.

A is an array of dimension 2n-1 or larger containing the coefficients A(j) =a,;_p (j= 1, ...,2n — 1) of the matrix A,. The argument 2 is an array of dimension n or larger, and TERR is an integer variable. When the routine is called, if A,z = 6 is solved then IERR is set to 0 and the solution is stored in x. A and 6b are not modified by the routine.

G and H are arrays of dimension n or larger that are work spaces for the routine. Error Return. TERR = i if the equations cannot be solved by the routine.

**Remarks.** The Levinson bordering procedure is used. This procedure is inductive, beginning with the solution 2, = 6;/ay of the equation agz, = by. Given a solution for a ee = b (# = 1,...,N) where N <n, then a solution for NM Ata, jtp = bh (r-

1, ...,N 41) is obtained where £1, ...,2y 4. is computed from z,,...,2y. This procedure fails when some submatrix Ay is singular (e.g, when eo -: 0). Also, the procedure may yield poor results when some Aw is exceedingly ill-conditioned. In such situations one must use a more general equation solver. In TOPELX and D'TOPLX 4(n 1)? floating additions and 4n(n 1) integer/floating multiplications an! divisions are used when n> 2. Consequently, these routines are considerably more efficient than general equation solvers such as

KROUT and ISMSLYV, but more restrictive and frequently less accurate.

**Programming.** TOPLX and DTOPLX are modifications by A. H. Morris of the subroutine TOEPLZ, written by George kybticki.

**Reference.** Press, Wo H., Piannecy, bP, Teukolsky, S. A.) and Vetterling, Wo Do, Nt

omericul Reetpes: The Art of Sctentaf>> Computing, Cambridge University Press, LOa6

po. 47 2.


<small>Original source: [View scanned PDF page 178](scans/page_0178.png)</small>

<a id="topic-178-01"></a>
### Inverting General Complex Matrices And Solving General Systems Of Complex Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CMSLV` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK` | [`L44162`](source_parts/nswc_part_05.f90#L1939) |
| `CMSLV1` | `SUBROUTINE` | `MO, N, M, A, KA, B, KB, IERR, IPVT, WK` | [`L44206`](source_parts/nswc_part_05.f90#L1983) |
| `DCMSLV` | `SUBROUTINE` | `MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK` | [`L44996`](source_parts/nswc_part_05.f90#L2773) |


The subroutines CMSLV, CMSLV1, and DCMSLV are available for inverting complex matrices and solving systems of complex linear equations. CMSLV and CMSLV1 solve single precision problems and DCMSLV solves double precision problems.

```fortran
CALL CMSLV(MO, N, M, A, KA, B, KB, DET, RCOND, IERR, IPVT, WK)
```

A is a complex matrix of order n where n > 1. If MO = 0 then the inverse of A is computed and stored in A. If MO #0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a complex matrix having n rows and m columns. In this case the matrix equation AX = B is solved and the solution X is stored in EB. If m < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and the argument kb is the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored.

D is a complex array of dimension 2. When CMSLV is called the determinant det(A) of the matrix A is computed. If det(A) = d-10* where 1 < |Re(d)| + |!m(d)] < 10 and k an integer, then d is stored in D(1) and the exponent k is stored ax a complex number in D2).

RCOND is a real variable’ When CMSLV is called, the routine makes an estimate eof the condition number of the matrix A (relative to the modified L, norm where each absolute value |z| is replaced with |Re(z)] } [Im(z)]). RCOND is assigned the value L/c.

IPV'T is an integer array of dimension n or larger that is used by the routine for keeping track of the row interchanges that are made. WK is a complex array of dimension mn or

larger that is used as a work space.

**Remarks.**

(1) RCOND satisfies 0+ ROOND = 1 IF RCOND s& LO * then one can expect the results to have approximately & fewer significant digits of accuracy than the elements of 4 Por example, if CMSLV is used to invert a matrix in the bf digit CDC single precision arithmetic and ROCONDD 48 3) then the computed coefficients of the inverse matrix should normally be accurate to about EL digits. In general, ROOND characterizes tow well or poorly conditioned the problem is, I RCONDP ss b then one shouted expect the results to be almost as accurate as the original data cA However, af ROONE) oO then one should expect Che results to be nonsense

(2) ‘The matrix Ais always destroyed

**Error Return.** UEKR is an integer variable If RCOND) is sufficiently Large se that |


<small>Original source: [View scanned PDF page 179](scans/page_0179.png)</small>

RCOND > 1, then IERR is set to 0 and the problem is solved. Otherwise, if 1-+RCOND = 1 then IERR is set to 1 and the routine terminates. In this case, A will have been destroyed but B will not have been modified. Also the determinant will not have been computed.

Algorithm. The partial pivot Gauss elimination procedure is used. The pivots ax; are selected so that |Re(a,,)! + |{m(a,,)| = max {jRe(a,,)| + |Im(a,,)| if = 9, ...,n}.

**Programming.** CMSLV calls the LINPACK subroutines CGECO, CGEFA, CGESL, and CGEDI. These subroutines were written by Cleve Moler (University of New Mexico). The subroutines CSWAP, CSCAL, CSSCAL, CAXPY and functions CDOTC, SCASUM, ICA- MAX are also used.

**References.**

(1) Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematics, Philadelphia, 1979.

(2) Cline, A. K., Moler, C. B., Stewart, G. W., and Wilkinson, J. H., “An Estimate for the Condition Number of a Matrix,” SIAM Journal of Numerical Analysis 16 (1979), pp. 368-375.

```fortran
CALL CMSLV1(MO, N, M, A, KA, B, KB, IERR, IPVT, WK)
```

A is a complex matrix of order n where n > 1. If MO = 0 then the inverse of A 1s computed and stored in A. If MO + 0 then the inverse is not computed.

The argument m is an integer. If m > 1 then B is a complex matrix having n rows aud m columns. In this case the matrix equation AX = B is solved and the solution X is stored in B. If n < 0 then there are no equations to be solved. In this case the argument B is ignored.

The argument ka is the number of rows in the dimension statement for A in the calling program, and the argument kb is the number of rows in the dimension statement for B in the calling program. If m < 0 then the argument kb is ignored.

IPVT is an integer array of dimension n or larger that is used by the routines for keeping track of the row interchanges that are made.

WK is a complex array of dimension n or larger that ts a work space for the routine.

If MO 4 O then WK is ignored.

**Error Return.** JERR ts @ variable that reports the status of the results. When CMSLV1 terminates HERR has one of the following values: TERR O The requested results were obtained. Tok lo Mither n,ka, or Ab is incorrect. tn this case, A and #3 have not been modified, IERR ok The AM column of A has been reduced to a column containing

zeros. ‘The requested results cannot be obtained,


<small>Original source: [View scanned PDF page 180](scans/page_0180.png)</small>

**Remarks.**

```text
(1) The matrix A is destroyed.
(2) CMSLY and CMSLVI produce the same resulis for X and the inverse of A.
```

**Algorithm.** The partial pivot Gauss elimination procedure is used. The pivots a,, are selected so that |Re(a,,)| + |Im(a,;)/ = max {|Re(a,,)| + |Im(a,,;)[:# = 3, ...,n}.

**Programming.** CMSLV1 calls the LINPACK subroutines CGEFA, CGESL, and CGEDI. These subroutines were written by Cleve Moler (University of New Mexico). The subroutines CSWAP, CSCAL, CAXPY and functions CDOTC, ICAMAX are also used.

**Reference.** Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, SIAM, 1979.

```fortran
CALL DCMSLV(MO, N, M, AR, AI, KA, BR, BI, KB, IERR, IPVT, WK)
```

AR and AI are double precision matrices of order n > 1. AR and Al are the real and imaginary parts of the complex matrix A whose inverse is to be computed or for which AX = B is to be solved. If MO = 0 then the inverse of the complex matrix is computed and the results stored in AR and AI. If MO #0 then the inverse is not computed.

The argument m is an integer. If m > 1 then BR and BI are double precision matrices having m rows and m columns. In this case, BR and BI are the real and imaginary parts of the complex matrix B for which AX = B is to be solved. When DCMSLV is called, the real and imaginary parts of the solution X are computed and stored in BR and BI. If m < 0 then there are no equations to be solved. In this case BR and BI are ignored.

The argument ka is the number of rows in the dimension statements for AR and AI in the calling program, and the argument kb is the number of rows in the dimension statements for BR and BI in the calling program. If m <0 then the argument kb is ignored.

IPVT is an integer array of dimension n or larger that is used by the routine for keeping track of the row interchanges that are made.

WK is a double precision array of dimension 2n or larger that is a work space for the routine. If MO / 0 then WE is ignored,

**Error Return.** TERR is a variable that reports the status of the results. Wien, DCMSLV terminates TERR has one of the following values: IERR O The requested results were obtained. IERR { Either n, ka, or kb is incorrect. In this case, AR, Al, BR, BE have not been modified [ERR k The kf columns of AR and Al have been reduced to columns

containing zeros, The requested results were not obtained

**Remark.** The matrices AR and Al are destroyed.


<small>Original source: [View scanned PDF page 181](scans/page_0181.png)</small>

**Algorithm.** The partial pivot, Gauss elimination procedure is used. The pivots A,, are selected so that |Re(a,,)| + {Im(a,;)| — max {/Re(a,;)| -+ [Im(asy)| if = 9, ...,7)-

**Programming.** DCMSLV calls the subroutines DCFACT, DCSOL, and DCMINV. These routines were written by A. H. Morris. The functions CDIVity and DPMPAR are also used.


<small>Original source: [View scanned PDF page 182](scans/page_0182.png)</small>

<a id="topic-182-01"></a>
### Solution Of Complex Equations With Iterative Improvement

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSLVMP` | `SUBROUTINE` | `MO, N, A, KA, B, X, WK, IWK, IERR` | [`L44248`](source_parts/nswc_part_05.f90#L2025) |


Given a complex n x n matrix A and a complex column vector 5. The following routine is available for solving the equation Aa == b. Iterative improvement is performed to compute the solution x to machine accuracy.

```fortran
CALL CSLVMP/MO,,, A, ka, 6, X,WK,IWK,IND)
```

MO is an input argument which specifies if CSLVMP is being called for the first time. On an initial call, MO = O and we have the following setup:

A is a 2-dimensional complex array of dimension ka x n containing the matrix A, ba complex vector of dimension n, and X a complex array of dimension n. When CSLVMP is called, Ax = 6 is solved and the solution stored in X. A and 6 are not modified by the routine.

WK is a complex array of dimension n? + n or larger, and [WK an integer array of dimension n or larger. These arrays are for internal use by the routine. On an initial call to CSLVMP, an LU decomposition is obtained for A and stored in WK and IWK. Then the equation Az = b is solved.

IND is an integer variable that reports the status of the results. On an initial call to CSLVMP, when the routine terminates ND has one of the following values:

```text
IND = 0 The solution X was obtained to machine accuracy.
IND = 1 X was obtained, but not to machine accuracy.
IND =~k The k‘* columi of A was reduced to a column containing only
```

zeros. In this case no solution can be obtained.

After an initial call to CSLVMP, if IND = O or | on output, then the routine may be called to solve a new set of equations Az 6 without having to redecompose the matrix A. In this case, the input argument MO may be set to any nonzero value. When MO / 0 tis assumed that only 6 has been modified. The routine employs the LU decomposition obtained on the initial call to CSLVMP to solve the new set of equations At = 6 On output X will contain the solution to the new set ef equations. As before, A and 6 are iot modified by the routine.

If CSLVMP is recalled with MO / 0, then when the routine terminates IND has one of the following values:

IND O ‘The solution No was obtained to machine accuracy,

IND 1 Xo was obtained, bat not to machine accuracy,

Programming CSLV MIP calls the subroutine CLUIME. ('These routines were written hy AOH. Morna The subroutines CMCOPY, CGOEPA CORSE, CsCAL, CAXPY aad fur trong SUMPAR, COOVYPO) TOAMAN are also employed


<small>Original source: [View scanned PDF page 183](scans/page_0183.png)</small>

<a id="topic-183-01"></a>
### Singular Value Decomposition Of A Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [`L45360`](source_parts/nswc_part_05.f90#L3137) |
| `DSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [`L45912`](source_parts/nswc_part_05.f90#L3689) |
| `CSVDC` | `SUBROUTINE` | `X, LDX, N, P, S, E, U, LDU, V, LDV, WORK, JOB, INFO` | [`L46464`](source_parts/nswc_part_05.f90#L4241) |


If 4 is a complex m x n matrix then there exists an m x m unitary matrix U and an n Xn unitary matrix V such that D = U* AV is a diagonal matrix?. Let di,...,d, be the diagonal elements of D where & = min{m,n}. Then U and V can be selected so that the diagonal elements are real numbers and d,; > dz > ++: > dy > 0. The nonnegative diagonal elements d@,; are unique, and if A is a real matrix then U and V can be chosen to be real orthogonal matrices. The decomposition D = U* AV is called the singular value decomposition of A. The elements dy, ...,d, are the singular values of A, the columns of U are left singular vectors, and the columns of V are right stnguédar vectors.

**Remark.** For m > n, D = (2) where Dy = diag(di,...,dn). Consequently, if U is

partitioned into U = (U,,U2) where U; has n columns, then it follows that A = UDV* = U,;D,V"*. The decomposition A = U;D,V" is frequently also called the singular value decomposition, and in many applications it suffices.

The following subroutines are available for finding the singular value decomposition D = U* AV of a matrix A.

CALI. SSVDC(A, ka, m,n, D, EU, ku, V, kv, WORK ,JOB,INFO) CALL DSVDC(A, ka, m,n, D, E,U, ku, V, ku, WORK,JOB,INFO) CALL CSVDC(A,ka,m,n, D, E,U, ku, V, kv, WORK,JOB,INFO)

A is a 2-dimensional array of dimension ka « n containing the m x n matrix whose singular value decomposition is to be computed. D is an array of dimension min{m + 1, n}. When any of the routines is called, the singular values of A are computed and stored in descending order of magnitude in (1), ..., D(k) where k ~= min{m, n}.

JOB is an integer that controls the computation of the singular vectors. It is assumed that JOB — 1-10-+ J when J,J = 0,1, ...,9. J and J have the following meaning.

I =.0 Do not compute the left singular vectors.

i=: 1 Compute all m left singular vectors

1 > 3 Compute the first min{mi,n} left singular vectors. (Here we compute the decomposition A = Uy D,V*.)

J. 0 Do not compute the right singular vectors,

J > Q Compute the right singular vectors.

U is a 2-dimensional array which contains the left singular vectors that are requested, and $k_u$ is the number of rows in the dimension statement for U in the calling program. It is assumed that $k_u \geq m$. If no left singular vectors are requested (i.e., if JOB < 10) then U is ignored by the routines. Otherwise, U must be of dimension $k_u \times m$ if all m left singular vectors are requested, and U must be of dimension $k_u \times \min\{m,n\}$ if the first min{m,n} left singular vectors are requested.



$U^*$ denotes the adjoint matrix of $U$.


<small>Original source: [View scanned PDF page 184](scans/page_0184.png)</small>

V is a 2-dimensional array which contains the right singular vectors that are requested, and kv is the number of rows in the dimension statement for V in the calling program. It is assumed that kv > n. If no right singular vectors are requested then V is ignored by the routines. Otherwise, V must be of dimension kv x n if the right singular vectors are requested.

F is an array of dimension n or larger, and WORK is an array of dimension m or larger. FE and WORK are storage areas for the routines.

**Remarks.**

(1) If SSVDC is called then it is assumed that the arrays A, D,E,U,V,WORK are real arrays, if DSVDC is called then it is assumed that the arrays are double precision arrays, and if CSVDC is called then it is assumed that the arrays are complex arrays.

(2) The contents of A are destroyed by the routines. If left singular vectors are requested and there is sufficient storage in A to hold the vectors (there will be sufficient storage if m <n or JOB > 20), then one may set U = A. Similarly, if right singular vectors are requested and m > n then one may set V = A. However, only one of the two arrays U and V may be identified with A.

**Error Return.** INFO is an integer variable. If all the singular values are found then INFO will be set to O and the array E will contain zeros. However, if the 7'” singular value cannot be found then INFO is set to 7. In this case, if 7 < k where k = min{m,n} then the singular values d;41, ...,d, will have been computed and stored in D. A will have been reduced to an upper bidiagonal matrix B with D as its diagonal and EF its super diagonal. If U and V have been requested then B = U* AV will be satisfied.

**Programming.** SSVDC, DSVDC, and CSVDC are part of the LINPACK package of matrix subroutines released by Argonne National Laboratory. The routines were coded by G. W. Stewart. (University of Maryland). The routines employ the vector subroutines SSWAP, SROT, SDOT, SSCAL, SAXPY, SNRM2, DSWAP, DROT, DDOT, DSCAL, DAXPY, DNRM2, and CSWAP, CSROT, CDOTC, CSCAL, CAXPY, SCNRM2, Also the subroutines SROTG and DRO'G are called.

**Reference.** Dongarra, J. J., Bunch, J. R., Moler, C. B., and Stewart, G. W., LINPACK Users’ Guide, Society for Industrial and Applied Mathematic., Philadelphia, 1979.

LAR


<small>Original source: [View scanned PDF page 185](scans/page_0185.png)</small>

<a id="topic-185-01"></a>
### Evaluation Of The Characteristic Polynomial Of A Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DET` | `FUNCTION` | `A, KA, N, X` | [`L47056`](source_parts/nswc_part_05.f90#L4833) |
| `DPDET` | `DOUBLE PRECISION FUNCTION` | `A, KA, N, X` | [`L47132`](source_parts/nswc_part_05.f90#L4909) |
| `CDET` | `COMPLEX FUNCTION` | `A, KA, N, X` | [`L47207`](source_parts/nswc_part_05.f90#L4984) |


The following functions are available for computing the determinant of A -- x] where Ais an n X n matrix, « a number, and J the n x n identity matrix.

DET(A,ka,n, x) DPDET(A, ka, n,z) CDET(A, ka, n, z)

DET is a real function that is used when A is a real matrix and 2 a real number, DPDET is a double precision function that is used when A is a double precision matrix and z a double precision number, and CDET is a complex function that is used when A is a complex matrix and x a complex number.

The value of the appropriate function is the determinant of the matrix A — 2/. The

argument ka has the value: ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > n > 1.

**Note.** A is destroyed during computation. Algorithm. Gauss partial pivoting is performed to reduce A -— zJ to upper triangular form. In CDET the pivots a,; are selected so that |Re(a,,)| + |Im(a,;)| = Max{|Re(a,,)| +

\Im(a,;;)| :# = 7, ...,n} rather than |a,,;| = max{|a,;|:1 = 7, ...,n}.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 186](scans/page_0186.png)</small>

<a id="topic-186-01"></a>
### Solution Of The Matrix Equation Ax + Xb = C

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [`L47285`](source_parts/nswc_part_05.f90#L5062) |
| `DABSLV` | `SUBROUTINE` | `MO, M, N, A, NA, B, NB, C, NC, WK, IERR` | [`L47902`](source_parts/nswc_part_05.f90#L5679) |


Given ap m xX m matrix A, n X n matrix B, and mx n matrix C. The subroutines ABSLV and DABSLV are available for obtaining the m x n matrix X which solves the equation AX + XB =C. ABSLV yields single precision results and DABSLV yields double precision results.

```fortran
CALL ABSLV(MO, M, N, A, NA, B, NB, C, NC, WK, IERR)
CALL DABSLV(MO, M, N, A, NA, B, NB, C, NC, WK, IERR)
```

If ABSLV is called then it is assumed that A, B,C, and W % are real arrays. Otherwise, if DABSLV is called then it is assumed that A, B,C, and Wh are double precision arrays.

It is assumed that m > iandn 1. The input arguments ka, kb, ke have the following values:

ka =: the number of rows in the dimension statement for A in the calling program

kb - the number of rows in the dimension statement for B in the calling program

ke == the number of rows in the dimension statement for C in the calling program It is required that ka > m, kb > n, ke > m.

WK is an array of dimension rm? 4-n? + 2k or larger where k = max{m,n}. WE is a general storage area for the routine.

MO is an input argument which specifies if the routine is being called for the first time. On an initial call MO <= 0. In this case, A is reduced to lower real Schur form, B is reduced oO upper real Schur form, and then the transformed system of equations is solved.

ND is # variable that reports the status of the results. When the routine terminates, INF) cat cue of the following values: a?

```text
Qk 9 The solution was obtained and stored in ©.
IND 1 The equations are inconsistent for A and 73.
IND ‘i could mot be reduced tu lower Schur form.
IND - 2 8 could met be reduced to upper Schur form.
```

I IND 4 O then no solution © is obtained.

When INE QO, A ce itains the lower Schur forma of the matrix A, B contains the upper Schur form of the matrix fo and WK contains the orthogonal matrices involved an the decompositions of A and Bo This information can be reused to solve a new set ool

equations. The following options are available: i BO}

MO i New matrices A and C' are given. The data foc ff ts reused in solving the new set of equations

MO) s Sew matrices &@ and ¢*" are given. “The data fer ber otpaedd ant solving the new set of equations

Mabe 09,2 Aonew matrix (os given. ‘The data for A and fo tensed an Se yti Che tra w set oof equations,


<small>Original source: [View scanned PDF page 187](scans/page_0187.png)</small>

When the routine ix recalled, it is assumed that m,n, and Wik have not been modified.

**Programming.** ABSLV employs the subrouti- 3 ABSLVI, ORTHES, ORTRN1, SCHUR, SHRSLV, SLV, and DABSLV employs che rout. s DABSV1, DORTH, DRTRN1, DSCHUR, DSHSLV, DPSI-VY. ABSLV and DABSLY are adaptations by A. H. Morris of the subroutine AXPXB written by R. H. Bartels and G. W. Stewart (University of Texas at Austin).

**Reference.** Bartels. R. H. and Stewart, G. W., “Algorithm 432, Solution of the Matrix Equation AX | X Bo 0.” Comm. ACM 15 (1972), pp. 820-826.


<small>Original source: [View scanned PDF page 188](scans/page_0188.png)</small>

<a id="topic-188-01"></a>
### Solution of the Matrix Equation A^T X + XA = C When C Is Symmetric

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [`L48521`](source_parts/nswc_part_05.f90#L6298) |
| `DTASLV` | `SUBROUTINE` | `MO, N, A, NA, C, NC, WK, IERR` | [`L48847`](source_parts/nswc_part_05.f90#L6624) |


Given matrices A and C of order 2 where C is symmetric. Then she subroutines TASLV and DTASLV are available for obtaining the symmetric matrix X which solves the equation A‘X + X 4=:C. TASLV yields single precision results and DTASLV yields double precision results.

```fortran
CALL TASLV(MO, N, A, NA, C, NC, WK, IERR)
CALL DTASLV(MO, N, A, NA, C, NC, WK, IERR)
```

If TASLV is called then it is assumed that A, C and WK are real arrays. Otherwise, if TASLV is called then it is assumed that A, C, and WK are double precision arrays.

It is a sumed .1at n >... The input arguments ka and ke have the following values: ka = the numbe: of rows in the dimension statement for A in the calling program ke = the number >f rows in the dimension statement for C in the calling program

{t is required that ka > n and ke > n.

WK is an array of dimension n* + 2: or larger that is a general storage area for the routine.

MO is an input argument, which specifies if the routine is being called for the first time. On an initial call MO = 0. In this case, A is reduced to upper real Schur form and then the transformed system of equations is solved.

```text
IND is a variable that reporis the status of the results. When the routme terminates,
IND has one of the following values:
```

```text
IND = 0 ‘The solution was obtained and stcred in C.
IND = 1 The equations are inconsistent.
IND. -1 A could not be reduced to upper Schur form,
```

WIND ¥ 0 then no solution is obtained.

When IND . 0, A contains the upper Schur form of the matrix 4 and WH contains the orthogonal matrix involved in the decomposition of A. ‘This data can be reused to solve a rew set of equations A'X + XA C. In this case, MO can be vet to any nonzero Value. When MO # Oit is assumed that only C has been modified. When the o-t) + terminates, toe solution for the new set of equations is stored in © Programming. TASLV employs the subroutines VASEVE, OR THES, ORPRNE, SCHUR, SYR SEV, SUV and DTASLV employs the routine DPASVI,ORTHDRERE EL DSCTEER, DSY VSV, LIPSEY. VASLV and DTASIV are adaptations by AJ HE Morus of toe subroutine ATAPSA written by Rofl Bartels and ce Woot wart (University of Texas at Austin).

**Reference.** Bartels, Ro No and Stewart, G. W Algorithm ¢32 Hear of the Matrix equation AX) NE CS Comm. ACM ES (6), pp, X20


<small>Original source: [View scanned PDF page 189](scans/page_0189.png)</small>

<a id="topic-189-01"></a>
### Solution of the Matrix Equation AX^2 + BX + C = 0

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SQUINT` | `SUBROUTINE` | `NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR` | [`L49174`](source_parts/nswc_part_05.f90#L6951) |


Given complex n x n matrices A,B, and C. The following subroutine is available for obtaining a complex n X n matrix X which solves the equation AX* + BX +C = 0.

```fortran
CALL SQUINT(NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, MAXITS, IERR)
```

It is assumed that A, B,C, and X are 2-dimensional complex arrays of dimension mx n where sm > n. When SQUINT is called, the n x n complex matrix solution obtained for AX? + BX +C =:0 is stored in X. A,B, and C are modified by the routine.

IND is an integer variable. On input, if IND + 0 then it is assumed that an initial approximation for the desired solution is provided in X by the user. Otherwise, if IND = 0 then the routine provides its own initial approximation. Then Newton iteration is performed. On output, IND = the number of iterations that were performed to compute X.

WK is a complex array of dimension @ that is a work space for tue routine. It is assumed that > Tn? +n. When SQUINT terminates, WK(1) is a complex number whose real part is the norm ||AX? + BX +Clloo.

The argument 7 is a real number. If r < 0 then X is computed to machine precision. Otherwise, if 7 > 0 then iteration terminates when || AX? + BX +C|| <r.

MAX is a variable. If MAX > 0 then MAX is the maximum number of iterations that may be performed. If MAX < 0 then it is reset by the routine to 30, the default) maximum number of iterations.

**Error Return.** [ERR is a variable that is set by the routine. If a solution X is obtained, then IF RR is assigned the value 0. Otherwise, JERR has one of the following values:

IERR = J MAX iterations were performed. More iterations are needed. [ERR ~> 2,3 Factorization of the equations could not be completed.

X cannot be computed. IERR 10 4 nm Newton iteration failed on iteration mn. Possibly fo sancti accuracy was requested. X cannot be computed. IERR — 999 (Input Error) Either n= Les nor &< TnF don. When IERR |. 1 occurs, X contains the most recent value obtained for the solution and

WK(1) is a complex number whose real part is the latest value obtained for the nor

|AN?7 | BN 4 Clee.

Programming, SQUEN’T employs the subroutines SQUIN?, CQZHES, CQZIP TRISLY, and CPRANS. These routines were designed by (reorge Jo Davis (Georgia State University, Atlanta, Georgia), CQOZHES and CQSET are modifications of the EISPACK subroutine QAHES and QZ17T, developed at Argonne National Laboratory. “The function SPMEPAR &

also used,

O40


<small>Original source: [View scanned PDF page 190](scans/page_0190.png)</small>

**References.**

(i) Davis, G. J., “Algorithm 598. Ai: Algorithm to Compute Solvents of the Matrix Equation AX? + BX + =U,” ACM Trans. Math Software 9 (1983), pp. 246-254.

(2) Garbow, B.S., et al., Matrix Eigensystems Routines - EISPACK Guide Extension, Springer-Verlag, 1977.


<small>Original source: [View scanned PDF page 191](scans/page_0191.png)</small>

<a id="topic-191-01"></a>
### Exponential Of A Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [`L50113`](source_parts/nswc_part_05.f90#L7890) |
| `DMEXP` | `SUBROUTINE` | `A, KA, N, Z, KZ, WK, IERR` | [`L50276`](source_parts/nswc_part_05.f90#L8053) |


Let A be a real matrix of order n > 1. Then the subroutines MEXP and DMEXP oo . are available for computing the exponential matrix e4 = )7> A'/t!, MEXP yields single t= 0 precision results and DMEXP yields double precision results.

```fortran
CALL MEXP(A, KA, N, Z, KZ, WK, IERR)
```

A is a real matrix of order n > 1 and Z a real 2-dimensional array. MEXP computes e4 and stores the results in Z. The arguments ka and kz have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kz = the number of rows in the dimension statement for Z in the calling program It is assumed that ka > n, kz > n, and that A and Z are different storage areas. If n > 1 then A is destroyed.

WK is a real array of dimension n(n +8) or larger that is a work space for the routine.

IERR is a variable that reports the status of the results. When MEXP terminates, JERR is assigned one of the following values: IERR = 0 The exponential was computed. HERR -— 1 The norm {[All, = max, >°; ja] is too large. e puted. IFRR | 2 The Pade denominator matrix is singular. (This should never

4 cannot be com-

occur.)

**Algorithm.** Ais balanced, yielding a matrix BD ' P!' APD where D is a diagonal matrix, Pa permutation matrix, and || B][y < {|All;. Next m is set to the smallest nonnegative integer such that min {/]2)[q, [i Billo} < 2™, and the 8 diagonal Pade approximation for eis used to compute exp($/2™). Then ¢? > fexp(2/2™)?" is obtained by ra squarings, and e4 PDe® DPD EPlas applied.

**Programming.** MXP calls the subroutines BALANC, BALINV, and SLV ‘The function IPMPAR as also used. MEXP was written by A. HL. Morris

**Reference.** Ward, Robert, Co, “Numerical Computation of the Matrix Exponential with Accuracy Estimate,” SEAM J. Numerical Analysis 14 (1977), pp 600 GEO

```fortran
CALL DMEXP(A, KA, N, Z, KZ, WK, IERR)
```

Aas a double precision matrix of order noo band 4 a double precision 2 dimensional array. DMEXP computes e* and stores the results am 2 The arguments ka and be lave the following values:

Aa the number of rows in the dimension statement fo cl in the callin prostate

ke the number of rows ie the dimension statement fe. 4 i the calling prorat


<small>Original source: [View scanned PDF page 192](scans/page_0192.png)</small>

It is assumed that ka > n, kz > n, and that A and Z ave different storage areas. If n > 1 then A is destroyed.

WK is a double precision array of dimension n(n + 12) or larger that is a work space for the routine.

IERR is a variable that reports the status of the results. When DMEXP terminates, TERR is assigned one of the following values:

TERR = 0 The exponential was computed.

TERR = 1 The norm ||.4||; is too large. e4 cannot be computed.

IERR = 2 The Pade denominator matrix is singular. (This should never occur.)

**Programming.** DMEXP calls the subroutines DBAL, DBALNV, and DPSLV. The function IPMPAR is also used. DMEXP was written by A. H. Morris.

**Reference.** Ward, Robert C., “Numerical Computation of the Matrix Exponential with Accuracy Estimate,” SIAM J. Numerical Analysis 14 (1977), pp. 600-610.


<a id="category-193"></a>
## Large Dense Systems of Linear Equations

<small>Original source: [View scanned PDF page 193](scans/page_0193.png)</small>

<a id="topic-193-01"></a>
### Solving Systems Of 200-400 Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [`L50442`](source_parts/nswc_part_05.f90#L8219) |
| `DPLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [`L50620`](source_parts/nswc_part_05.f90#L8397) |
| `CLE` | `SUBROUTINE` | `ROWK, N, B, C, D, IP, IERR` | [`L50798`](source_parts/nswc_part_05.f90#L8575) |


For n > 1, let A denote ann x n matrix and 6 a column vector of dimension n. Then the subroutines LE, DPLE, and CLE are available for solving the equations Az = 6 where A is not stored in-core. For large n, these routines require a work space of dimension x n?7/4. This permits the solution of systems of equations of double the order permitted by the standard solution procedures.

```fortran
CALL LE(ROWK, N, B, C, D, IP, IERR)
CALL DPLE(ROWK, N, B, C, D, IP, IERR)
CALL CLE(ROWK, N, B, C, D, IP, IERR)
```

X is an array of dimension n and [ERR an integer variable. When the equations are solved, then IERR is set to 0 and the solution is stored in X.

ROWK ie the na-ie of a user defined subroutine that has the format: CALL ROWK(n,k, R) R is an array of dimension n and k = t,...,n. When ROWK is called, the k** row of the matrix A is stored in R. ROWK must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension [n?/4] +n +3 or larger,’ and iWK is an integer array of dimension max{1,n -- 1} or larger. WK and IWK are work spaces for the routines.

**Error Return.** IERR = k when the first k rows of A are found to be linearly dependent.

**Remarks.**

(i) When LE is called then it is assumed that 6, X, WK and the array R in ROWK are real arrays. When DPLE is called then it is assumed that these arrays are double precision arrays, and when CLE is called then it is assumed that the arrays are complex.

(2) When the equations are solved, ROWK is called to attach the first row of A, then the second row, etc. Each row of A is attached only once.

(3) The array 6 is not modified by the routines.

**Algorithm.** The partial pivot Henderson-Wassyng procedure is used.

**Programming.** LE, DPLE, and CLE are modified versions by A. Hl. Morris of the subroutine TE, written by A. Wassyng (University of the Witwatersrand, Johannesburg, South: Africa).

**Example.** Consider a system of n = 300 real linear equations b where the rows of A are stored, one row per logical record, in sequence in an unformatted file (say file 4). Then the following code can be used to solve the equations:

Mere [n?/4] denotes the largest integer < 7.7/4,

ee Press)


<small>Original source: [View scanned PDF page 194](scans/page_0194.png)</small>

REAL B(300),X(300), WK (22803) INTEGER IWK(300) EXTERNAL GETROW

DATA N/300/

REWIND 4 CALL LE(GETROW,N,B,X,WK,IWK,IERR)

Here GETROW may be defined by:

SUBROUTINE GETROW(N,1R) REAL R(N)

READ(4) (R(J),J=i,N) RETURN

END

**Reference.** Wassyng, A., “Solving Az = 6: A Method with Reduced Storage Requirements,” SIAM J. Numerical Analysts 19 (1982), pp. 197-204.


<a id="category-195"></a>
## Banded Matrices

<small>Original source: [View scanned PDF page 195](scans/page_0195.png)</small>

<a id="topic-195-01"></a>
### Band Matrix Storage


For an m X n matrix A -= (aij), let me be the number of diagonals below the main diagonal containing nonzero elements, and rm, the number of diagonals above the main diagonal containing nonzero elements. Then mg and my are called the lower and upper band widths of A, and my+my-+ 1 the total band width of A. It is clear that 0 < me<m and 0 < m, <n, and that aj; 4 0 only when d ~ me < J < ¢-+m,. If the band width my-+ my, + 1 is sufficiently small, then it is also clear that a considerable savings in storage can occur by storing only the nonzero diagonals of A. In the adopted band storage scheme, the nonzero diagonals are the columns of an m x (mg+m, +1) matrix B == (b;,). For each nonzero a,;, 6, = ayy where k = 7 -4-+ mz+1. The remaining 6,,’s are zeros.

Example. Consider the matrix

41; 12 413 0 0 0) 0

G21 G22 @23 G24 O 0 0

O agg 433 @34 @35 O 0

A= 0 0 443 G44 G45 Gag 0 9 0 QO adsq Gsg sq G57 0) 0) C QO adgs Gee ae7z 0 Q G 0 O a7 azz

. O 0 0 0 0 0 Gaz

where m, = 1 and my == 2. Then A will be stored in band form as follows:

O air Gi2 443 G21 Gag 423 do4 G32 G33 A340 G35 B G43 Gag G45 C46 sa 455 G56 G57 a65 @eg 57 0 ar7e TT 0 0 . 1R7 Q 0 0 /

**Remark.** The first m, columns of B contain the nonzero diagonals of A below the main diagonal, the (rm, + 1)** column of B contains the main diagonal, and the last. m,, columns of B contain the nonzero diagonals of A above the main diagonal.

el ion 7


<small>Original source: [View scanned PDF page 196](scans/page_0196.png)</small>

<a id="topic-196-01"></a>
### Conversion Of Banded Matrices To And From The Standard Format

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CVBR` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [`L50987`](source_parts/nswc_part_05.f90#L8764) |
| `CVRB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51061`](source_parts/nswc_part_05.f90#L8838) |
| `CVRB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [`L51135`](source_parts/nswc_part_05.f90#L8912) |
| `CVBD` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [`L51206`](source_parts/nswc_part_05.f90#L8983) |
| `CVDB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51280`](source_parts/nswc_part_05.f90#L9057) |
| `CVDB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [`L51354`](source_parts/nswc_part_05.f90#L9131) |
| `CVBC` | `SUBROUTINE` | `B, KB, M, N, ML, MU, A, KA` | [`L51425`](source_parts/nswc_part_05.f90#L9202) |
| `CVCB` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L51499`](source_parts/nswc_part_05.f90#L9276) |
| `CVCB1` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, NB, IERR` | [`L51573`](source_parts/nswc_part_05.f90#L9350) |


The following subroutines permit one to convert matrices to and from the standard format.

```fortran
CALL CVBR(B, KB, M, N, ML, MU, A, KA)
CALL CVBD(B, KB, M, N, ML, MU, A, KA)
CALL CVBC(B, KB, M, N, ML, MU, A, KA)
```

A is an m xX n matrix stored in band form, mg the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < ms < _m,0 < my <n,and ka > m.

B is a 2-dimensional array of dimension kb x n where kb > m. CVBR is used if A and B are real arrays, CVBD is used if A and B are double precision arrays, and CVBC is used if A and B are complex arrays. When the routine is called, the matrix A is stored in the array B in the standard format.

**Remark.** B may begin in the same location as A. If B begins in the same location then it is assumed that kb = ka. In this case, the result. B will overwrite the input data A. Otherwise, if B does not begin in the same location as A, then it is assumed that the storage areas A and 8 do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL CVRB(A, KA, M, N, ML, MU, B, KB)
CALL CVDB(A, KA, M, N, ML, MU, B, KB)
CALL CVCB(A, KA, M, N, ML, MU, B, KB)
```

Ais an m xX n matrix stored in the standard format, and re and m, are integers such that O < mz < mand 0< my <n. The arguiment ka is the number of rows in the dimension statement for A in the calling program. It is assumed that ka > m.

Bois a 2-dimension array of dimension kb x € where k6 > m and € > mg -+ my 4 I. CVRB is used if A and 2 are real arrays, CVDB is used if A and 8 are double precision arrays, and CVCB is used if A and 2 are complex arrays. When the routine is called, the m, diagonals of A immediately below the main diagonal, the main diagonal, and the mm, diagonals immediately above the main diagonal are stored in band form in B.

**Remarks.** (1) Given a matrix A> (a,,), then these routines may be used to convert A to band form

when the lower and upper bandwidths mu, and my of A are known. Efrng and mi are


<small>Original source: [View scanned PDF page 197](scans/page_0197.png)</small>

not known, then the subroutines CVRB1, CVDB1, and CVCB1 described below can be used to convert A to band form.

B may begin in the same location as A. If B begins in the same location then it is assumed that kb = ka. In this case, the result B will overwrite the input data A. Otherwise, if 8 does not begin in the same location as A, then it is assumed that the storage areas A and B do not overlap.

Programmer. A. H. Morris.

```fortran
CALL CVRB1(A, KA, M, N, ML, MU, B, KB, NB, IERR)
CALL CVDB1(A, KA, M, N, ML, MU, B, KB, NB, IERR)
CALL CVCB1(A, KA, M, N, ML, MU, B, KB, NB, IERR)
```

A is an m X n matrix stored in the standard format. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that A is to be stored in band form in B. B is a 2-dimensional array of dimension kb x @ where kb > m. The argument 2 is an estimate of the maximum number of diagonals of A that will have to be stored.

CVRB1 is used if A and B are real arrays, CVDB1 is used if A and B are double precision arrays, and CVCBI is used if A and B are complex arrays. JERR, mz, and my, are integer variables. When the routine is called, if @ specifies sufficient storage for B then A is stored in band form in 8. Also IERR is assigned the value 0, m, = the number of diagonals of A below the main diagonal containing nonzero elements, and m, = the number of diagonals above the main diagonal containing nonzero elements.

**Error Return.** If £ does not specify sufficient storage for B, then IERR is assigned the value mz+m,, -+ 1. Reset @> IERR.

**Remark.** B may begin in the same location as A. If B begins in the same location then it is assumed that kb = ka. In this case, the result B will overwrite the input data A. Otherwise, if B does not begin in the same location as A, then it is assumed that the storage areas A and B do not overlap.

**Programming.** CVRB1 calls the subroutine CVRB, CVDBI calls the subroutine CVDB, and CVCBI calls the subroutine CVCB. These routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 198](scans/page_0198.png)</small>

<a id="topic-198-01"></a>
### Conversion Of Banded Matrices To And From Sparse Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [`L51644`](source_parts/nswc_part_05.f90#L9421) |
| `DMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [`L51710`](source_parts/nswc_part_05.f90#L9487) |
| `CMCVBS` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR` | [`L51776`](source_parts/nswc_part_05.f90#L9553) |
| `MCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [`L51842`](source_parts/nswc_part_05.f90#L9619) |
| `DMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [`L51910`](source_parts/nswc_part_05.f90#L9687) |
| `CMCVSB` | `SUBROUTINE` | `A, IA, JA, M, N, B, KB, NB, ML, MU, IERR` | [`L51978`](source_parts/nswc_part_05.f90#L9755) |


The following subroutines permit one to convert matrices to and from sparse form.

```fortran
CALL MCVBS(A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR)
CALL DMCVBS(A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR)
CALL CMCVBS(A, KA, M, N, ML, MU, B, IB, JB, NUM, IERR)
```

A is an m X n matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz, < m,0O < mu <n, and ka > m.

It is assumed that A is to be stored in sparse form in the arrays B,JB,/B. NUM is the estimated maximum number of elements that will appear in B and J&B. It is assumed that B and JB are of dimension max{1, NUM} and that /B is of dimension m + 1.

MCVE3 is used if A and B are real arrays, DMCVBS is used if A and B are double precision arrays, and CMCVBS is used if A and B are complex arrays. IERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for B and JB, then IERR is assigned the value 0 and A is stored in sparse form in B, 1B, JB.

**Error Return.** If there is not sufficient storage in B and JB for the 1** row of A, then IERR is set to 1 and the routine terminates. In this case, if: > 1 then the first : — 1 rows of A will have been stored in B and JB. Also [B(1), ...,1.B(s) will contain the appropriate row locations.

**Programmer.** A. H. Morris.

```fortran
CALL MCVSB(A, IA, JA, M, N, B, KB, NB, ML, MU, IERR)
CALL DMCVSB(A, IA, JA, M, N, B, KB, NB, ML, MU, IERR)
CALL CMCVSB(A, IA, JA, M, N, B, KB, NB, ML, MU, IERR)
```

A is an m Xn sparse matrix stored in the arrays A, A, JA. It is assumed that A is to be stored in band form in 8B. # is a 2-dimensional array of dimension kd x @ where kb > m. The argument @ is an estimate of the maximum number of diagonals of A that will have to be stored.

MCVSB is used if A and B are real arrays, DMCVSB is used if A and & are double precision arrays, and CMC VSB is used if A and B are complex arrays. TERR, my, and ig are integer variables. When the routine is called, if @ specifies sufficient storage for 8 then A is stored in band form in #. Also HERR is assigned the value 0, mg — the number of diagonals of A below the main diagonal containing nonzero elements, and my, > the number of diagonals above the main diagonal containing nonzero elements,


<small>Original source: [View scanned PDF page 199](scans/page_0199.png)</small>

**Error Return.** If 2 does not specify sufficient storage for B, then IERR is assigned the value me+my +1. Reset 2> IERR.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 200](scans/page_0200.png)</small>

<a id="topic-200-01"></a>
### Conversion Of Banded Real Matrices To And From Double Precision Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BCVRD` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52046`](source_parts/nswc_part_05.f90#L9823) |
| `BCVDR` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52065`](source_parts/nswc_part_05.f90#L9842) |


The following subroutines are available for converting banded real matrices to and from double precision form.

```fortran
CALL BCVRD(A, KA, M, N, ML, MU, B, KB)
```

A is an m xn real matrix stored in band form, mz the number of diagonals below the main diagonal! containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m, 0O<m,<n,and ka>m.,

B is a 2-dimensional double precision array of dimension kb x @ where kb > m and £>mze+m,+1. When BCVRD is called, A is stored in band form in B.

**Programmer.** A. H. Morris. CALL BCVDR(A, ka,m,n, mg,m,, B, kb)

Ais an mxn double precision matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and rn, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < m, < m,O0<m, <n, and ka >m.

B is a 2-dimensional real array of dimension kb x @ where kb > m and € > mz-+rny +1. When BCVDR is called, A is stored in band form in B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 201](scans/page_0201.png)</small>

<a id="topic-201-01"></a>
### The Real And Imaginary Parts Of A Banded Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BREAL` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [`L52084`](source_parts/nswc_part_05.f90#L9861) |
| `BIMAG` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR` | [`L52140`](source_parts/nswc_part_05.f90#L9917) |


If A = (a,;) is a complex matrix then let Re(A) = (Re(a,;)) and Im(A) = {Im(c,;)}) denote the real and imaginary parts of A. If the matrix A is stored in band form, then the following subroutines are available for obtaining Re(A} and Im(A) in band form.

```fortran
CALL BREAL(A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR)
```

Ais an m xn complex matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A is the calling program. It is assumed that 0 < m,z < m, O< my <n,and ka>m.

B is a 2-dimensional real array of dimension kb x € where kb > m. The input argument é is an estimate of the maximum number of diagonals of Re(A) which will have to be stored (2 < me+ mu +1). TERR, ng, and ny are integer variables. When BREAL is called, if £ specifies sufficient storage for B then Re(A) is stored in band form in B. Also, IERR is assigned the value 0, ng = the number of diagonals of Re(A) below the main diagonal containing nonzero elements, and ny, = the number of diagonals of Re(A) above the main diagonal containing nonzero elements.

**Error Return.** If @ does not specify sufficient storage for B, then IERR is assigned the value v where v is the number of columns needed for B. Reset £> v.

**Programmer.** A. H. Morris. CALL BIMAG(A, ka, m,n, mz, mu, B, kb, €, ne, ny TERR)

Ais an m Xn complex matrix stored in band form, mg the number of diagonals below the main diagonal containing nonzero elements, and m,, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m, O0< my <n, and ka > m.

B is a 2-dimensional real array of dimension kb x € where kb > m. The input argument éis an estimate of the maximum number of diagonals of Im(A) which will have to be stored (2< me+mu +1). TERR, ne, and ny are integer variables. When BIMAG is called, if é specifies sufficient storage for J3 then Im(A) is stored in band form in B. Also, TERR is assigned the value 0, ng == the number of diagonals of Im(A) below the main diagonal containing nonzero elements, and ny = the number of diagonals of fm(A) above the main diagonal containing nonzero elements.

**Error Return.** If @ does not specify sufficient storage for 8B, then IERE is assigned the value v where v is the number of columns needed for B. Reset @ > v.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 202](scans/page_0202.png)</small>

<a id="topic-202-01"></a>
### Computing A + Bi For Banded Real Matrices A And B

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BCVRC` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52196`](source_parts/nswc_part_05.f90#L9973) |


Given the real m x n matrices A and B stored in band form. Then the subroutine BCVRC is available for obtaining the complex matrix A+ Bt where ¢ = /—1.

```fortran
CALL BCVRC(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
```

A and B are real m x n matrices stored in band form, m, the number of diagonals of A below the main diagonal containing nonzero elements, m, the number of diagonals of A above the main diagonal containing nonzero elements, nz the number of diagonals of B below the main diagonal containing nonzero elements, and n, the number of diagonals of B above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program.

It is assumed that A+ At is to be stored in band form in C. C is a 2~—dimensional complex array of dimension kcx @ where kc > The input argument @ is an estimate of the maximum number of diagonals of A-++ Bt which, will have to be stored (@ > max{mz,ne} + max{my,ny} +1). TERR, vz, and vw, are integer variables. When BCVRC is called, if @ specifies sufficient storage for C then A+ Br is stored in band form in C. Also IERR is assigned the value 0, v, == the number of diagonals of A+ Br below the main diagonal containing nonzero elements, and », = the number of diagonals of A + Bt above the main diagonal containing nonzero elements.

**Error Return.** If 2 does not specify sufficient storage for C, then IERR is assigned the value v where v is the number of columns needed for C. Reset @> v.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 203](scans/page_0203.png)</small>

<a id="topic-203-01"></a>
### Transposing Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52282`](source_parts/nswc_part_05.f90#L10059) |
| `DBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52340`](source_parts/nswc_part_05.f90#L10117) |
| `CBPOSE` | `SUBROUTINE` | `A, KA, M, N, ML, MU, B, KB` | [`L52398`](source_parts/nswc_part_05.f90#L10175) |


The following subroutines are available for transposing banded matrices.

```fortran
CALL BPOSE(A, KA, M, N, ML, MU, B, KB)
CALL DBPOSE(A, KA, M, N, ML, MU, B, KB)
CALL CBPOSE(A, KA, M, N, ML, MU, B, KB)
```

A is an m X n matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < m, < m,O < my <n,and ka>m.

B is a 2-dimensional array of dimension kb x @ where kb > n and £ > m+ my, + 1. BPOSE is used if A and 8 are real arrays, DPOSE is used if A and 8 are double precision arrays, and CBPOSE is used if A and B are complex arrays. When the routine is called, the transpose A‘ of A is stored in band form in B.

**Note.** It is assumed that the storage areas A and B do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 204](scans/page_0204.png)</small>

<a id="topic-204-01"></a>
### Addition Of Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52456`](source_parts/nswc_part_05.f90#L10233) |
| `DBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52612`](source_parts/nswc_part_05.f90#L10389) |
| `CBADD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52768`](source_parts/nswc_part_06.f90#L1) |


Let A and B be m x n matrices stored in band form. The following subroutines are available for computing the sum C = A+ B.

```fortran
CALL BADD(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL DBADD(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL CBADD(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
```

A and B are mm xX m matrices stored in band form, my, the number of diagonals of A below the main diagonal containing nonzero elements, m, the number of diagonals of A above the main diagonal containing nonzero elements, ng the number of diagonals of B below the main diagonal containing nonzero elements, and n, the number of diagonals of 2 above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program.

It is assumed that A-+ B is to be stored in band form in C. C ts a 2-dimensional array of dimension ke x € where kc > m. The input argument @ is an estimate of the maximum number of diagonals of A + B which will have to be stored (@€ < max{rny, ne} | max{my,nu} $1). BADD is used if A and B are real arrays, DBADD is used if A and [2 are double precision arrays, and CBADD is used if A and B are complex arrays. TERR, vy, and ™, are integer variables. When the routine is called, if @ specifies sufficient storage for C then A { Bois computed and stored in band form in C. Also TERR is assigned the value O, vg the number of diagonals of A} B below the main diagonal containing nonzero elements, and vy, the number of diagonals of A + B above the main diagonal containing

nonzero elements,

**Error Return.** If @ does not specify sufficient storage for C, then HOR R is assigned the value

v where v is the number of columns needed for ©. Reset @ ov,

Remarks foie omg then Co may bey iu Che same location as Al Tf Co begins in the sane location as A, then dois assumed that ke &a and that the arrays A and # do not overlap In this case, the result C@ will overwrite the input data Al Similarly, frag © one then ©) may bevin in the same bocamoaas 8 when ke Ab and A and 8 do not overlap. Otherwise, i ¢

does not begin in the same location as A or #8, then it is assumed that the storage ares to

C) does not overlap with the storage areas for A and # dn this case there is mo restric tic:

on ke (other than the customary restriction that Ae > ae) Example. If / Athen @ tay be assigned any value ood da this case, will oon! only the maim draroduabot the zero matrix Ae Hoanday ay 0

Programmer A EE Nforeis


<small>Original source: [View scanned PDF page 205](scans/page_0205.png)</small>

<a id="topic-205-01"></a>
### Subtraction Of Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L52924`](source_parts/nswc_part_06.f90#L157) |
| `DBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L53080`](source_parts/nswc_part_06.f90#L313) |
| `CBSUBT` | `SUBROUTINE` | `M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR` | [`L53236`](source_parts/nswc_part_06.f90#L469) |


Let A and B be m xn matrices stored in band form. The following subroutines are available for computing the difference C = A —- B,

```fortran
CALL BSUBT(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL DBSUBT(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
CALL CBSUBT(M, N, A, KA, ML, MU, B, KB, NL, NU, C, KC, L, MCL, MCU, IERR)
```

A and B are m x n matrices stored 1) band form, m, the number of diagonals of A below the main diagonal containing nonzero elements, m, the number of diagonals of A above the main diagonal containing nonzero elements, ng the number of diagonals of B below the main diagonal containing nonzero elements, and n, the number of diagonals of B above the main diagonal containing nonzero elements. The argument xa is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for B in the calling program.

It is assumed that A — B is to be stored in band form in C. C is a 2-dimensional array of dimension kc x @€ where ke > m. The input argument @ is an estimate of the maximum number of diagonals of A -- B which will have to be stored (€ < max{mz, ne} + max{mu,nu} + 1). BSUBT is used if A and B are real arrays, DBSUBT is used if A and B are double precision arrays, and CBSUBT is used if A and B are complex arrays. IERR, vy, and vy are integer variables. When the routine is called, if ? specifies sufficient storage for C then A — B is computed and stored ir band form in C. Also IEFRR is assigned the value 0, vg = the number of diagonals of A- B below the main diagonal containing nonzero elements, and v,, = the number of diagonals of A — B above the main diagonal containing nonzero elements.

**Error Return.** Hf @ does not specify sufficient storage for C, then IERR is assigned the value v where v is the number of columns needed for C. Reset 2 > v.

**Remarks.** If m; > n, then C' may begin in the same location as A. If C’ begins in the same location as A, then it is assumed that Ac = ka and that the arrays A and Z do not overlap. In this case, the result C will overwrite the input data A. Similarly, ifm, < nz then C may begin in the same location as B when ke -. kb and A and B do not overlap. Otherwise, if C does not begin in the same location as A or B, then it is assumed that the storage area for C does not overlap with the storage areas for A and B. In this case there is no restriction on ke (other than the customary restriction that ke > m).

Example If 3 A then @ may be assigned any value » f. In this case, C will contain only the main diagonal of the zero matrix Ao By and ve oy, 0.

**Programmer.** A. H. Morris

te cant _


<small>Original source: [View scanned PDF page 206](scans/page_0206.png)</small>

<a id="topic-206-01"></a>
### Multiplication Of Banded Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [`L53392`](source_parts/nswc_part_06.f90#L625) |
| `DBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [`L53547`](source_parts/nswc_part_06.f90#L780) |
| `CBPROD` | `SUBROUTINE` | `M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR` | [`L53702`](source_parts/nswc_part_06.f90#L935) |


Let A and B be matrices stored in band form. The following subroutines are available for computing the product C = AB.

```fortran
CALL BPROD(M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR)
CALL DBPROD(M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR)
CALL CBPROD(M, N, L, A, KA, ML, MU, B, KB, NL, NU, C, KC, NC, MCL, MCU, IERR)
```

A is an mX n matrix stored in band form, m, the number of diagonals of A below the main diagonal containing nonzero elements, and m,, the number of diagonals of A above the main diagonal containing nonzero elements. B is an n x € matrix stored in band form, nz the number of diagonals of B below the main diagonal containing nonzero elements, and ny, the number of diagonals of B above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, and kb the number of rows in the dimension statement for 8 in the calling program. I. is assumed that ka > m and kb > n.

It is assumed that, AB is to be stored in band form in C. C ia a 2-dimensional array of dimension ke X nc where kc > m. The input argument nc is an estimate of the maximum number of diagonals of AB which will have to be stored (ne < min{n - i,me-+ ne} + min{f- 1,my + nu} +1). BPROD is used if A,B, and C are real arrays, DBPROD is used if A,B, and C are double precision arrays, and CBPROD is used if A,B, and © are complex arrays. IERR, vs, and ™, are integer variables. When the routine is called, if nc specifies sufficient storage for C then AB is computed and stored in band form in C. Also, TERR is assigned the value 0, vz, = the number of diagonals of AB below the main diagonal containing nonzero elements, and v,, =: the number of diagonals of AB above the main diagonal] containing nonzero elements.

**Error Return.** If nc does not specify sufficient storage for C, then IERR is assigned the value v where v is the number of columns needed for C. Reset ne > v.

**Note.** It is assumed that the storage area for C does not overlap with the storage areas for A and B.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 207](scans/page_0207.png)</small>

<a id="topic-207-01"></a>
### Product Of A Real Banded Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53857`](source_parts/nswc_part_06.f90#L1090) |
| `BVPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53909`](source_parts/nswc_part_06.f90#L1142) |
| `BTPRD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54149`](source_parts/nswc_part_06.f90#L1382) |
| `BTPRD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54200`](source_parts/nswc_part_06.f90#L1433) |


Let A be a real mi & m matrix stored in band form. Then the following subroutines are available for multiplying A with a real vector.

```fortran
CALL BVPRD(M, N, A, KA, ML, MU, X, Y)
```

A is an m X n matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal] containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < mz < m,0 < my <n, and ka > m.

The argument z is a column vector of dimension n and y an array of dimension m. When BVPRD is called, the product Az is computed and stored in y.

**Remark.** [t is assumed that the arrays A, z, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL BVPRD1(M, N, A, KA, ML, MU, X, Y)
```

A is an m x n matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and mm, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m,0 < my, <n, and ka > m.

The arguments z and y are column vectors of dimension n and m respectively. When BVPRDL is called, Az + y is computed and stored in y.

**Remark.** It is assumed that the arrays A, 2, y do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL BTPRD(M, N, A, KA, ML, MU, X, Y)
```

A is an m xn matrix stored in band form, mg the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the

dimension statement for A in the calling program It is assumed that 0 < my < my <n, and ka > m.

m0 <

The argument x is a row vector of dimension m and y an array of dimension n. When BPPRD is called, the product 1A ts computed and stored in y.

**Remark.** It is assumed that the arrays A, 7, y do not overlap.


<small>Original source: [View scanned PDF page 208](scans/page_0208.png)</small>

**Programmer.** A. H. Morris.

```fortran
CALL BTPRDi(m,n, A, ka, me, my, 2, y)
```

Aisanmxny stored in band form, yng the number of diagonals below the main diagonal conta. mzero elements, and ms, then number of diagonals above the main diagonal conta |. azero elements. The argument ka is the number of rows in the dimension statement iv: a the calling program. It is assumed that 0 < mg < m,0 <

my <mn,and ka >m.

The arguments 7 2: y are row vectors of dimension m and n respectively. When BTPRD1 is called, zA | —s computed and stored in y. Remark, It is assumed ‘1. the arrays A, 2, y do not overlap.

**Programmer.** A. H. ):


<small>Original source: [View scanned PDF page 209](scans/page_0209.png)</small>

<a id="topic-209-01"></a>
### Product Of A Double Precision Banded Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L53954`](source_parts/nswc_part_06.f90#L1187) |
| `DBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54007`](source_parts/nswc_part_06.f90#L1240) |
| `DBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54244`](source_parts/nswc_part_06.f90#L1477) |
| `DBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54296`](source_parts/nswc_part_06.f90#L1529) |


Let A +e a double precision m x nm matrix stored in band form. Then the following subroutines are available for multiplying A with a double precision vector.

```fortran
CALL DBVPD(M, N, A, KA, ML, MU, X, Y)
```

A is an m xX n matrix stored in band form, my, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < mz < m,0 < My <n, and ka > rm.

The argument z is a column vector of dimension m end y an array of dimension m. A,#,y are double precision arrays. When DBVPD is called, Az is computed and stored in y.

**Remark.** st is assumed that the arrays A, x, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DBVPDiI(m,n, A, ka, ong, mu,2,y)
```

A is an m xX n matrix stored in band form, m; the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < m, < m,0 < m, <n, and ka > m.

The arguments 2 and y are column vectors of dimension n and m respectively. A,2,y are double precision arrays. When DBVPD1 is called, Az + y is computed and stored in y.

**Remark.** it is assumed that the arrays A, zr, y do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL DBTPD(M, N, A, KA, ML, MU, X, Y)
```

Ais an m xX no matrix stored in band form, rg the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program, J4 is assumed that O +. my < m,O -

ry <n, ard ka > oi,

The argument 218 a row vector of dimension mn and y an array of dimension nm. A,z,y are double precision arrays. When DBTPD is called, 74 is computed and stored in y


<small>Original source: [View scanned PDF page 210](scans/page_0210.png)</small>

**Remark.** It is assume! that the arrays A, x, y do not overlap.

**Programmer.** A. H. Morris.

```fortran
CALL DBTPDi(m,n, A, ka, me, mu, 2, y)
```

A is an m X n matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the ‘dimension statement for A in the calling program. It is assumed that 0 < m, < m,0 < my <n, and ka > mi.

The arguments x and y are row vectors of dimension rn and n respectively. A,2z,y are double precision arrays. When DBTPD1 is called, xA + y is computed and stored in y.

**Remark.** It is assumed that the arrays A, x, y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 211](scans/page_0211.png)</small>

<a id="topic-211-01"></a>
### Product Of A Complex Banded Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBVPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54052`](source_parts/nswc_part_06.f90#L1285) |
| `CBVPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54104`](source_parts/nswc_part_06.f90#L1337) |
| `CBTPD` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54340`](source_parts/nswc_part_06.f90#L1573) |
| `CBTPD1` | `SUBROUTINE` | `M, N, A, KA, ML, MU, X, Y` | [`L54391`](source_parts/nswc_part_06.f90#L1624) |


Let A be a complex m x n matrix stored in band form. Then the following subroutines are available for multiplying A with a complex vector.

```fortran
CALL CBVPD(M, N, A, KA, ML, MU, X, Y)
```

A is an m Xn matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mp < _m,0 < my <n, and ka > m.

The argument z is a column vector of dimension n and y an array of dimension m. A,2z,y are complex arrays. When CBVPD is called, Az is computed and stored in y.

**Remark.** It is assumed that the arrays A, x, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CBVPD1(M, N, A, KA, ML, MU, X, Y)
```

A is an m X n matrix stored in band form, m;, the number of diagonals below the main diagonal containing nonzero elements, and m,, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz < m,0 < my <n, and ka > m.

The arguments z and y are column vectors of dimension n and m respectively. A, x,y are complex arrays. When CBVPDI1 is called, Ax + y is computed and stored in y.

**Remark.** It is assumed that the arrays A, z, y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CBTPE’ ‘m,n, A, ka, me, ru, 72, y)
```

A is an m Xn matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < mg < m,0O « my, <n, and ka > m.

The argument x is a row vector of dimension m and y an array of dimension n. A,x,y are complex arrays. When CBTPD is called, 2A is computed ind stored in y.

**Remark.** It is assumed that the arrays A, 2, y do not overlap.


<small>Original source: [View scanned PDF page 212](scans/page_0212.png)</small>

Programmer, A. H. Morris.

```fortran
CALL CBTPD1(M, N, A, KA, ML, MU, X, Y)
```

A is an m Xn matrix stored in band form, mz the number of diagonals below the main diagonal containing nonzero elements, and rm, the number of diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the

dimension statement for A in the calling program. It is assumed that O < mz < m,0 < my, <n, and ka > m.

The arguments x and y are row vectors of dimension m and n respectively. A,z,y are complex arrays. When CBTPD1 is called, rA + y is computed and stored in y.

**Remark.** it is assumed that the arrays A, 2, y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 213](scans/page_0213.png)</small>

<a id="topic-213-01"></a>
### L1 Norm of a Real Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `B1NRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [`L54457`](source_parts/nswc_part_06.f90#L1690) |
| `DB1NRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [`L54541`](source_parts/nswc_part_06.f90#L1774) |


```text
If A = (a,;) is a real banded matrix then the following functions are available for
computing the £, norm ||Al|1 == max, Zy|a,;| of A.
```

BANRM(A, ka, m,n, m,,m,) DBINRM(A, ka, m,n, me, mu)

BiINRM is used if A is a real array and DBINRM is used if A is a double precision array. BINRM is a real function and DBINRM a double precision function.

The function has the value ||A||; for any m x n matrix A stored in band form. The argument mg, is the number of diagonals below the main diagonal containing nonzero elements, mm, the number of diagonals above the main diagonal containing nonzero elements, and ka the number of rows in the dimension statement for A in the calling program. It is assumed that 0 < mz, < m, 0 < my, <n, and ka > m,

**Remark.** DB1INRM must be declared to be of type DOUBLE. PRECISION in the calling program.

**Programming.** BINRM calls the function SASUM and DBiNRM calls the function DASUM. BINRM and DBINRM were written by A. H. Morris.


<small>Original source: [View scanned PDF page 214](scans/page_0214.png)</small>

<a id="topic-214-01"></a>
### L-infinity Norm of a Real Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BNRM` | `REAL FUNCTION` | `A, KA, M, N, ML, MU` | [`L54435`](source_parts/nswc_part_06.f90#L1668) |
| `DBNRM` | `DOUBLE PRECISION FUNCTION` | `A, KA, M, N, ML, MU` | [`L54519`](source_parts/nswc_part_06.f90#L1752) |


```text
If A = (a,;) is a real banded matrix then the following functions are available for
computing the €,, norm ||A||,.o = max, ,|a,,| of A.
```

BNRM(A, ka, m,n, mz, my) DBNRM(A, ke, m,n, me, mu)

BNRM is used if A is a real array and DBNRM is used if A is a double precision array. BNRM is a real function and DBNRM a double precision function.

The function has the value ||Aj|.. for any m x n matrix A stored in band form. The argument mz is the number of diagonals below the main diagonal containing nonzero elements, m,, the number of diagonals above the main diagonal containing nonzero elements, and ka the number of rows in the dimension statement for A in the calling program. It is assumed that O< my, <m,0< m, <n, and ka >m.

**Remark.** DBNRM must be declared to be of type DOUBLE PRECISION in the calling program.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 215](scans/page_0215.png)</small>

<a id="topic-215-01"></a>
### Solution Of Banded Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L54604`](source_parts/nswc_part_06.f90#L1837) |
| `BSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L54708`](source_parts/nswc_part_06.f90#L1941) |


Let A be a nonsingular nx n real matrix stored in band form and 6a real column vector of dimension n. The subroutine BSLV is available for solving the system of equations Ax = 6, and the subroutine BSLV1 is available for solving the transposed system of equations Atz = b. On an initial call to either routine, partial pivot Gauss elimination is first employed to obtain an LU decomposition of A, and then the equations are solved. BSLV and BSLV1 always generate the same LU decomposition of A. After the decomposition is obtained on an initial call to BSLV or BSLV, either routine may be called to solve a new system of equations Az = r or A’r = r without having to redecompose the matrix A.

```fortran
CALL BSLV(M0, A, KA, N, ML, MU, B, IWK, IERR)
CALL BSLV1(M0, A, KA, N, ML, MU, B, IWK, IERR)
```

BSLV is called for solving Az = 6 and BSLV1 is called for solving Atz == b. The argument m, is the number of diagonals below the main diagonal of A containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. It is assumed that n > 1,0 < mz <n, and 0 < m, < n. MO is an input argument which specifies if BSLV or BSLV1 is being called for the first time. On an initial call, MO = 0 and we have the following setup:

A is a 2-dimensional array of dimension ka x m where ka > n and m > 2mz,-+ my, + 1. On input, the first m, + m, + 1 columns of the array contain the matrix A in band form. When the routine terminates, the array A will contain the upper triangular matrix U of the LU decomposition and the multipliers which were used to obtain it.

X is an array of dimension n or larger. On input, X contains the vector b. On output, X will contain the solution of the system of equations.

IWK is an array of dimension n or larger for internal use by the routine. The pivot indices involved in the LU decomposition are stored in IWK.

On an initial call to BSLV or BSLV1I, IND ts an integer variable that reports the status of the results. When the routine terminates, IND has one of the following values:

IND = 0 The system of equations was solved.

IND = -1 Either n < Oor ka <n.

IND =: -2 Either mz, < O or my > n.

IND 3 Either m, < 0 or my > n.

IND - & Column & of A has been reduced to a column containing only

Zeros.

After an initial call to BSLV or BSLVI, if IND | Ooon output then either routine iuy be called with MO 400 When MO / Q it is assumed that only @ may have been modified BSLV is called for solving the new set of equations Ag 9b, and MWSEV 1 is called for solving the new vet of equations Abr — 6. The routine employs the Lt! decomposition obtained on the initial call te BSLY or BSLVE to solve the new set of equations. Onoimput, Xo contain:

L285


<small>Original source: [View scanned PDF page 216](scans/page_0216.png)</small>

the new vector 6. On output, X will contain the solution to the new set of equations. In this case, IND is not referenced by the routine.

**Programming.** BSLV and BSLV1 employ the subroutines SNBFA,SNBSL,SAXPY,SSCAL, SS WAP and the functions ISAMAX and SDOT. SNBFA and SNBSL were written by E. A. Voorhees (Los Alamos Scientific Laboratory) and modified by A. H. Morris. The original versions of SNBFA and SNBSL are distributed by the SLATEC library.


<small>Original source: [View scanned PDF page 217](scans/page_0217.png)</small>

<a id="topic-217-01"></a>
### Computation Of The Condition Number Of A Real Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `B1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [`L55750`](source_parts/nswc_part_06.f90#L2983) |


If A is a real mn x n banded matrix then the following subroutine is available for estimating the £, condition number cond,(A) of A.

```fortran
CALL B1CND(A, KA, N, ML, MU, COND, IWK, WK, IERR)
```

A is a real n X n matrix stored in band form. A,ka,m,,m,, and IWK are the same arguments used for the subroutines BSLV and BSLV1, the only exception being that [WK now is an array of dimension 2n or larger.

COND is a real variable. When B1CND is called, then the subroutine BSLV is first invoked to obtain an LU decomposition of A which is stored in A and IWK. Then COND is assigned the value Oif A is singular and an approximation of the condition number cond, (A) if A is nonsingular.

WK is an array of dimension 2n or larger that is a work space for the routine.

IND is an integer variable that reports the status of the results. When B1CND terminates, IND has one of the following values:

IND = 1 A is singular and COND =. 0.

IND .- O Ais nonsingular and COND is an approximation of the condition number of A.

IND © - 1 Either n < Qor ka <n.

IND 2 Either my < O or mney > n.

IND 3 Either my, < Oor my, > n.

When an error is detected, the routine immediately terminates.

Usage. After BECND terminates, if IND Q then BSLV or BSLV may be called with MO / U to solve a system of equations. In this cause A, &a,nomiy,m, and EW are used by BSLV and BSLV, and must not be modified by the user.

**Algorithm.** A modification of the Hager procedure by Nicholas J. Higham (University of £ i J y B \ ;

Manchester, England) is used.

**Programming.** BECND employs the subroutines SONEST, BSLV, BSLV Ei, SNBEFALSNBSE, SCOPY, SAXPY, SSCAL, and SSWAP. and the functions BINRM, SDO'PR, SASUM), and ISAMAX. BEOND was written by Ao TL Morris, SONEST was written by No Jo Tiga

and modified by A. TE Morris.

**References.**

(t) Higham, NS FORTRAN codes for Estimating the One Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans, Math Software Ld (HOSS) pp SSP 396


<small>Original source: [View scanned PDF page 218](scans/page_0218.png)</small>

(2) , “Algorithm 674: “FORTRAN codes for Estimating the One-Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 15 (1989), p. 168.

2SS


<small>Original source: [View scanned PDF page 219](scans/page_0219.png)</small>

<a id="topic-219-01"></a>
### Double Precision Solution Of Banded Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55177`](source_parts/nswc_part_06.f90#L2410) |
| `DBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55281`](source_parts/nswc_part_06.f90#L2514) |


Let A be a nonsingular n x n double precision matrix stored in band form and 6 a double precision column vector of dimension n. The subroutine DBSLV is available for solving the system of equations Ax == b, and the subroutine DBSLV1 is available for solving the transposed system of equations A‘z == 6. On an initial call to either routine, partial pivot Gauss elimination is first employed to obtain an LU decomposition of A, and then the equations are solved. DBSLV and DBSLV1 always generate the same LU decomposition of A. After the decomposition is obtained on an initial call to DBSLV or DBSLV1, either routine may be called to solve a new system of equations Az = r or A'z = r without having to redecompose the matrix A.

```fortran
CALL DBSLV(M0, A, KA, N, ML, MU, B, IWK, IERR)
CALL DBSLVi(MO,A, ka, n, mz, mu, X IWK,IND)
```

DBSLV is called for solving Az = 6 and DBSLV1 is called for solving Atr = 6. The argument m, is the number of diagonals below the main diagonal of A containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. It is assumed that n > 1, 0 < mz, <n, and 0 < m, < n. MO is an input argument which specifies if DBSLV or DBSLV1 is being called for the first time. Cn an initial call, MO = 0 and we have the following setup:

A is a double precision 2-dimensional array of dimension ka x m where ka > n and m > 2mg4-my+1. On input, the first me+m,-+1 columns of the array contain the matrix Ain band form. When the routine terminates, the array A will contain the upper triangular matrix U of the LU decomposition and the multipliers which were used to obtain it.

X is a double precision array of dimension n or larger. Cn input, X contains the vector 6. On output, X will contain the solution of the system of equations.

IWK is an array of dimension n or larger for internal use by the routine. The pivot indices involved in the LU decomposition are stored in [WK.

On an initial call to DBSLV or DBSLV1, IND is an integer variable that reports the status of the results. When the routine terminates, IND has one of the following values:

```text
IND =; 0 The system of equations was solved.
IND — - 1 Hither n < Oor ka <n.
IND «= -2 Either my < O or my > n.
```

```text
IND = -3 Either my, <0 or my > n.
IND --  &
```

© Column k of A has been reduced to a column containing only

zeros,

After an initial call to DBSLV or DBSLVE, GP IND © 0 on output then either routine may be called with MO 7 0. When MO / Oot is assumed that only 6 may have been modified. DBSLY is called for solving the new set of equations Ac 6, and DBSLVE is called


<small>Original source: [View scanned PDF page 220](scans/page_0220.png)</small>

for solving the new set of equations A'z = 4. The routine employs the LU decomposition obtained on the initial call to DBSLV or DBSLV1 to solve the new set of equations. On input, X contains the new vector b. On output, X will contain the solution to the new set of equations. In this case, IND is not referenced by the routine.

Programming DBSLV and DBSLV1 employ the subroutines DBFA, DBSL, DAXPY, DSCAL, DSWAP and the functions IDAMAX and DDOT. DBFA and DBSL are adaptations by A. H. Morris of the subroutines SNBFA and SNBSL, written by E. A. Voorhees (Los Alamos Scientific Laboratory). SNBFA and SNBSL are distributed by the SLATEC library.

200)


<small>Original source: [View scanned PDF page 221](scans/page_0221.png)</small>

<a id="topic-221-01"></a>
### Computation Of The Condition Number Of A Double Precision Banded Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DB1CND` | `SUBROUTINE` | `A, KA, N, ML, MU, COND, IWK, WK, IERR` | [`L55868`](source_parts/nswc_part_06.f90#L3101) |


If A is a double precision n x n banded matrix then the following subroutine is available for estimating the @; condition number cond,(A) of A.

```fortran
CALL DB1CND(A, KA, N, ML, MU, COND, IWK, WK, IERR)
```

A is a double precision n x n matrix stored in band form. A,ka,mz,m,, and IWK are the same arguments used for the subroutines DBSLV and DBSLVI1, the only exception being that IWK now is an array of dimension 2n or larger.

COND is a double precision variable. When DB1CND is called, then the subroutine DBSLV is first invoked to obtain an LU decomposition of A which is stored in A and IWK. Then COND is assigned the value 0 if A is singular and an approximation of the condition number cond,(A) if A is nonsingular.

WK is a double precision array of dimension 2n or larger that is a work space for the routine.

IND is ar integer variable that reports the status of the results, When DB1CND terminates, IND has one of the following values:

IND = 1 Ais singular and COND = 0.

IND = 0 Ais nonsingular and COND is an approximation of the condition

number of A.

IND = —-1 Either n < Oor ka <n.

IND = —2 Either me < 0 or my > n.

IND = ~—3 Either m, <Oormy > n.

When an error is detected, the routine immediately terminates.

Usage. After DBLCND terminates, if IND = 0 then DBSLV or DBSLVI may be called with MO z: 9 to solve a system of equations. In this case A,ra,n,m¢,my and [WK are used by DBSLV and DBSLV1, and must not be modified by the user.

**Algorithm.** A modification of the Hager procedure by Nicholas J. Higham (University of

Manchester, England) ig u-d.

**Programming.** DB1CND employs the subroutines DONEST, DBSLV, DBSLVI, DBFA, DBSL, DCOPY, DAXPY, DSCAL, and DSWAP, and the functions DBINRM, DDOT, DASUM, and IDAMAX. DISECND was written by A. TH. Morris§ DONES'T is the double precision form of the subroutine SONEST, written by No J. Higham and modified by A. HD. Morris.

**References.**

(1) Higham, NAP, FORTRAN codes for Estimating the One Norm of a Real or Complex Matrix. with Applications to Condition Estimation,’ ACM Trans. Math Software 14 (1988), pp. Seb 396.


<small>Original source: [View scanned PDF page 222](scans/page_0222.png)</small>

(2) __, “Algorithm 674: “FORTRAN codes for Estimating the One-Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math

Software 15 (1989), p. 168.


<small>Original source: [View scanned PDF page 223](scans/page_0223.png)</small>

<a id="topic-223-01"></a>
### Solution Of Banded Systems Of Complex Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSLV` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L55987`](source_parts/nswc_part_06.f90#L3220) |
| `CBSLV1` | `SUBROUTINE` | `M0, A, KA, N, ML, MU, B, IWK, IERR` | [`L56069`](source_parts/nswc_part_06.f90#L3302) |


Let A be a nonsingular n x n complex matrix stored in band form and 6a complex column vector of dimension n. The subroutine CBSLV is available for solving the system of equations Az = 6, and the subroutine CBSLV1 is available for solving the transposed system of equations A’z = b. On an initial call to either routine, partial pivot Gauss elimination is first employed to obtain an LU decomposition of A, and then the equations are solved. CBSLV and CBSLV1 always generate the same LU decomposition of A. After the decomposition is obtained oa an initial call to CBSLV or CBSLVI, either routine may be called to solve a new system of equations Az = r or A‘z = r without having to redecompose the matrix A.

```fortran
CALL CBSLV(M0, A, KA, N, ML, MU, B, IWK, IERR)
CALL CBSLV1(M0, A, KA, N, ML, MU, B, IWK, IERR)
```

CBSLV is called for solving Az = 6 and CBSLV1 is called for solving A’z =: b. The argument mg is the number of diagonals below the main diagonal of A containing nonzero elements, and m, the number of diagonals above the main diagonal containing nonzero elements. It is assumed that n > 1,0 < mg <n, and O < m, <n. MO is an input argument which specifies if CBSLV or CBSLV1 is being called for the first time. On an initial call, MO = 0 and we have the following setup:

A is a complex array of dimension ka x m where ka > n and m > 2m,+ my+i1. On input, the first mg+m, +1 columns of the array contain the matrix Ain band form. When the routine terminates, the array A will contain the upper triangular matrix U of the LU decomposition and the multipliers which were used to obtain it.

X ig a complex array of dimension r or larger. On input, X contains the vector 6. On output, X will contain the solution of the system of equations.

JWK is an array of dimension n or larger for internal use by the routine. The pivot indices involved in the LU decomposition are stored in [WK.

On an initial call to CBSLV or CBSLV1, IND is an integer variable that reports the status of the results. When the routine terminates, {ND has one of the following values:

IND = 0 The system of equations was solved.

IND =: --i Either n <Oor ka <n,

IND = --2 Either m, <0 or mz > n.

IND = --3 Either my < 0 or my > n.

IND == k Column & of A has been reduced to a column containing only Zeros,

After an initial cali to CBSLV or CRSLV1, if IND ~ 0 on output then either routine may be called with MO / 0. When MO ¥# 0 it is assumed that only 6 may have been modified. CBSLV is called for solving the new set of equations Az = 6, and CBSELV4 is called for solving the new set of equations Afz = 6. The routine employs the LU decomposition


<small>Original source: [View scanned PDF page 224](scans/page_0224.png)</small>

obtained on the initial call to CBSLV or CBSLV1 to solve the new set of equations. On input, X contains the new vector 6. On output, X will contain the solution to the new set of equations. In this case, IND is not referenced by the routine.

**Programming.** CBSLV and CBSLVI employ the subroutines CBFA, CBSL, CAXPY, CSCAL, CSWAP and the functions ICAMAX and CDOTU. CBFA and CBSL are adaptations by A. H. Morris of the subroutines SNBFA and SNBSL, written by E. A. Voorhees (Los Alamos Scientific Laboratory). SNBFA and SNBSL are distributed by the SLATEC library.


<a id="category-225"></a>
## Sparse Matrices

<small>Original source: [View scanned PDF page 225](scans/page_0225.png)</small>

<a id="topic-225-01"></a>
### Storage Of Sparse Matrices


A matrix is said to be sparse if it contains sufficiently many zero elements for it to be worthwhile to use special techniques that avoid storing and operating with the zeros. The scheme adopted for storing a sparse m X n matrix (a;;) requires three 1-dimensional arrays A, IA, JA. The array A contains the nonzero elements of the matrix, stored row by row. The array JA contains the column numbers of the corresponding elements of the A array; ie., if A(k) contains (a,;) then JA(k) = 7. The elements of a row of the matrix may be given in any order in A.

7A is an array containing m+ 1 integers which specify where the rows of the matrix are stored in A. For! < m, I A(t) is the index of the location in A where the 1** row information begins. It is assumed that the rows are stored sequentially; ie., that TA(1) <-+-< [A(m). IA(m+1) is set so that [A(m+1)—JA(1) = the number of elements stored in A. For 1 < m, if [A(t) < TA(t+ 1) then A(é) is the first entry of the :** row of the matrix in A where £ == [A(t). Otherwise, if JA(t) == JA(¢+ 1) then no entries for the :** row of the matrix are stored in A. This can occur only if the 1*" row of the matrix consists entirely of zeros. If this occurs then the t¢* row is called a nuél row of A. For any ¢ < m, JA(i +1) — IA(t) is the number of entries for the :** row of the matrix that are stored in A. For convenience, TA(s + 1) — IA(t) is called the length of the 1** row.

**Example.** The matrix

ay Gye 0 0 0 0 0 aia 0 0 0 0O OQ O O 0 0 0 0 0 0 0 Qa37 a38

can be stored as follows:

A: [aii [aie [aia [ 437 | ase | 243 |

The storage of the elements aj, @,2 ayg in the order a); a1g @)2 is permissible. The elements of a row of the matrix may be given in any order desired.

**Remark.** it is not required that each a,, in A be nonzero.


<small>Original source: [View scanned PDF page 226](scans/page_0226.png)</small>

<a id="topic-226-01"></a>
### Conversion Of Sparse Matrices To And From The Standard Format

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CVRS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [`L56484`](source_parts/nswc_part_06.f90#L3717) |
| `CVDS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [`L56519`](source_parts/nswc_part_06.f90#L3752) |
| `CVCS` | `SUBROUTINE` | `A, KA, M, N, B, IB, JB, NUM, IERR` | [`L56554`](source_parts/nswc_part_06.f90#L3787) |
| `CVSR` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [`L56590`](source_parts/nswc_part_06.f90#L3823) |
| `CVSD` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [`L56620`](source_parts/nswc_part_06.f90#L3853) |
| `CVSC` | `SUBROUTINE` | `A, IA, JA, B, KB, M, N` | [`L56650`](source_parts/nswc_part_06.f90#L3883) |


The following subroutines permit one to convert sparse matrices to and from the standard format.

```fortran
CALL CVRS(A, KA, M, N, B, IB, JB, NUM, IERR)
CALL CVDS(A, KA, M, N, B, IB, JB, NUM, IERR)
CALL CVCS(A, KA, M, N, B, IB, JB, NUM, IERR)
```

Ais an m X n matrix stored in the standard format. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that A is to be stored in sparse form in the arrays 3, 1B, JB. CVRS is used if A is a real matrix and B a real array, CVDS is used if 4 is a double precision matrix and B a double precision array, and CVCS is used if A is a complex matrix and B a complex array.

The input argument NUM is the estimated maximum number of elements that will appear in B and JB. It is assumed that B and JB are of dimension max{i, NUM} and that JB is of dimension m+ 1. IERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for B and JB, then A is stored in B, JB, JB and IERR is assigned the value 0.

**Error Return.** If it is found that there is not sufficient storage in B and JB for the i** row of A, then IERR is set tos and the routine terminates. In this case, ifs > 1 then the first t — 1 rows of A will have been stored in B and JB, and J B(1),...,7.B(i) will contain the appropriate row locations.

**Remark.** No zero elements of A are stored in B, and the elements of each row of B are ordered so that the column indices of the elements of the row are in ascending order.

**Example.** If A is the m x n zero matrix then NUM can be set to 0. In this case the result

**Note.** It is assumed that the storage areas A and HB do not overlap. Programmer. A. H. Morris.

```fortran
CALL CVSR(A, IA, JA, B, KB, M, N)
CALL CVSD(A, IA, JA, B, KB, M, N)
CALL CVSC(A, IA, JA, B, KB, M, N)
```

Ais an m Xm sparse matrix stored in the arrays A, (A, JA, and Bis a 2-dimensional array of dimension kb x m where kb > m. CVSR is used if A and J3 are real arrays, CVS) is used Wf A and JU are double precision arrays, and CVSC is used if A and # are complex arrays. When the routine is called, the matrix A is stored in the array # in the standard

format.


<small>Original source: [View scanned PDF page 227](scans/page_0227.png)</small>

**Note.** It is assumed that the storage areas A and B do not overlap.

Programmer, A. H. Morris.


<small>Original source: [View scanned PDF page 228](scans/page_0228.png)</small>

<a id="topic-228-01"></a>
### Conversion Of Sparse Real Matrices To And From Double Precision Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCVRD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56680`](source_parts/nswc_part_06.f90#L3913) |
| `SCVDR` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56707`](source_parts/nswc_part_06.f90#L3940) |


The following subroutines are available for converting sparse real matrices to and from double precision form.

```fortran
CALL SCVRD(A, IA, JA, B, IB, JB, M)
```

A is a sparse real matrix stored in the arrays A, JA, JA. A is a real array and Ba double precision array. If A and JA contain k elements then it is assumed that B and JB are arrays of dimension k. It is also assumed that the matrix A has m > 1 rows and that IB is an array of dimension m+ 1. SCVRD stores the matrix A in double precision form in B, IB, JB.

**Remarks.**

```text
(1) No zero elements of A are stored in B.
(2) It is assumed that the arrays JA, JA and IB, JB reference different storage areas.
```

**Programmer.** A. H. Morris.

```fortran
CALL SCVDR(A, IA, JA, B, IB, JB, M)
```

A is a sparse double precision matrix stored in the arrays A, TA, iA. A is a double precision array and B a real array. If A and JA contain k elements then it is assumed that Band JB are arrays of dimension k. it is also assumed that the matrix A has m > | rows and that /8 is an array of dimension m+1. SCVDR stores the matrix A in single precision

form in 8, IB, JB.

```text
Remarks.
(1) No zero elements of A are stored in B.
(2) It is assumed that the arrays 7A, JA and IB, JB reference different storage areas.
```

**Programmer.** A. H. Morris,


<small>Original source: [View scanned PDF page 229](scans/page_0229.png)</small>

<a id="topic-229-01"></a>
### The Real And Imaginary Parts Of A Sparse Complex Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSREAL` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56734`](source_parts/nswc_part_06.f90#L3967) |
| `CSIMAG` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56766`](source_parts/nswc_part_06.f90#L3999) |


If A = (a,;) is a complex matrix then let Re(A) = (Re({a,,;)) and Im(A) = (Im(a;;)) denote the real and imaginary parts of A. If the matrix A is stored in sparse form, then the following subroutines are available for obtaining Re(A) and Im(A) in sparse form.

```fortran
CALL CSREAL(A, IA, JA, B, IB, JB, M)
```

A is a sparse complex matrix stored in the arrays A, JA, JA. A is a complex array and B a real array. If A and JA contain k elements then it is assumed that Band JB are arrays of dimension k. It is also assumed that the matrix A has m > 1 rows and that 1B is an array of dimension m+ 1. CSREAL stores Re(A) in sparse form in B, IB, JB.

**Remarks.**

```text
(1) No zero eiements of Re(A) are stored in B.
(2) It is assumed that the arrays JA, JA and IB, JB reference different storage areas.
```

**Programmer.** A. H. Morris.

```fortran
CALL CSIMAG(A, IA, JA, B, IB, JB, M)
```

A is a sparse complex matrix stored in the arrays A, IA, JA. A is a complex array and B areal array. If A and JA contain k elements then it is assumed that B and JB are arrays of dimension k. It is also assumed that the matrix A has m > | rows and that 1B is an array of dimension m + 1. CSIMAG stores Im(A) in sparse form in B, 1B, JB.

```text
Remarks.
(1) No zere elements of Im(A) are stored in 3.
(2) It is assumed that the arrays (A, JA and 1/8, JB reference different storage areas.
```

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 230](scans/page_0230.png)</small>

<a id="topic-230-01"></a>
### Computing A + Bi For Sparse Real Matrices A And B

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCVRC` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L56798`](source_parts/nswc_part_06.f90#L4031) |


Given the real m x n matrices A and B stored in sparse form. Then the subroutine SCVRC is available for obtaining the complex matrix A+ Bit where t = /—1.

```fortran
CALL SCVRC(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
```

A and B are real m X n matrices stored in the arrays A,JA,JA and B,IB,JB. it is assumed that A+ Bs is to be stored in sparse form in the arrays C,JC,JC. A and B are real arrays and C a complex array. NUM is the estimated maximum number of elements that will appear in C and JC. It is assumed that C and JC are arrays of dimension max{1, NUM} and that JC is an array of dimension m + 1.

WK is a real array of dimension n or larger that is a work space for the routine.

TERR is an integer variable. When SCVRC is called, if NUM specifies sufficient storage for C and JC then A+ Bt is stored in C, IC, JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C and JC for the kt* sow of A+ Bi, then IERR is set to k and the routine terminates. In this case, if k > 1 then the first k — 1 rows of A + Bt will have been stored in C' and JC. Also IC(1),...,IC(k) will contain the appropriate row locations.

**Remark.** No zeros are stored in C.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 231](scans/page_0231.png)</small>

<a id="topic-231-01"></a>
### Copying Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56867`](source_parts/nswc_part_06.f90#L4100) |
| `DSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56897`](source_parts/nswc_part_06.f90#L4130) |
| `CSCOPY` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56927`](source_parts/nswc_part_06.f90#L4160) |


The following su routines are available for copying sparse matrices.

```fortran
CALL RSCOPY(A, IA, JA, B, IB, JB, M)
CALL DSCOPY(A, IA, JA, B, IB, JB, M)
CALL CSCOPY(A, IA, JA, B, IB, JB, M)
```

RSCOPY is used if A and B are real arrays, DSCOPY is used if A and B are double precision arrays, and CSCOPY is used if A and B are complex arrays.

A is a sparse matrix stored in the arrays A, [A,J A. If A and JA contain k elements then it is assumed that B and JB are arrays of dimension k. It is also assumed that the matrix A has m > 1 rows and that /B is an array of dimension m+ 1. The routine copies the matrix A and stores the copy in B,JB,JB.

**Remarks.**

```text
(1) No zero elements of A are stored in B.
(2) It is assumed that the arrays A, iA, JA and B, /B,JB reference different storage
areas.
```

**Programmer.** A. H. Morris.

OOS


<small>Original source: [View scanned PDF page 232](scans/page_0232.png)</small>

<a id="topic-232-01"></a>
### Computing Conjugates Of Sparse Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCONJ` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M` | [`L56958`](source_parts/nswc_part_06.f90#L4191) |


```text
If A = (a,;) is a complex matrix stored in sparse form, ther the following subroutine
is available for computing the conjugate matrix A = (4,;).
```

```fortran
CALL SCONJ(A, IA, JA, B, IB, JB, M)
```

It is assumed that the sparse complex matrix A is stored in the arrays A, JA, JA. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k. A and B are complex arrays. It is assumed that the matrix A has m > 1 rows and that TB is an array of dimension m+ 1. When the routine is called, the conjugate matrix A is stored in B, 1B, JB.

**Remark.** The user may let B = A, /B = JA, and JB = JA when 1] A(1) = 1.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 233](scans/page_0233.png)</small>

<a id="topic-233-01"></a>
### Transposing Sparse Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [`L56987`](source_parts/nswc_part_06.f90#L4220) |
| `RPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [`L57051`](source_parts/nswc_part_06.f90#L4284) |


The subroutines RPOSE and RPOSE! are available for transposing a sparse m x n real matrix A. RPOSE1 is more general than RPOSE. For any permutation 7 = {11, ...,1m} of {1,...,m} let P denote the corresponding ™ x m permutation matrix. Then RPOSE1 computes the matrix (P.A)’.

```fortran
CALL RPOSE(A, IA, JA, B, IB, JB, M, N)
```

It is assumed that the sparse matrix A is stored in the arrays A, JA, JA. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that 7B is an array of dimension n+ 1. When RPOSE is called, the transpose A’ is stored in B, IB, JB.

Remarks. RPOSE orders the elements of each row of .4° so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. if zero elements appear in the array A, then the zero elements will also appear in F.

Restriction. '¢ is assumed that the storage areas B, 1B, JB do not overlap with the storage areas A, ITA, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, F. G., “i'wo Fast Algorithms for Sparse Matrices: Mi. ‘tiplicatior. and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 250-269.

```fortran
CALL RPOSE1(P, A, IA, JA, B, IB, JB, M, N)
```

It is assumed that x is an integer array of dimension m containing the data (41, .-.,1m}; and that the sparse matrix A is stored in the arrays A, 1A, JA. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that 7B is an array of d‘mension n+ 1. When RPOSE1 is called, (PA)* is computed and the results are stored in B, 7B, JB.

**Remarks.** RPOSE! orders the elements of each row of (PA)! so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. Tf zero elements appear in the array A, then the zero elements will also

appear in 2.

Restriction. It is assumed that the storage areas 2, 1B, JB do not overlap with the storage areas A, JA, JA.

**Programmer.** A. if. Morris.

**Reference.** Gustavson, Fo G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 20) 269,

3OG


<small>Original source: [View scanned PDF page 234](scans/page_0234.png)</small>

<a id="topic-234-01"></a>
### Transposing Sparse Double Precision Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [`L57118`](source_parts/nswc_part_06.f90#L4351) |
| `DPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [`L57182`](source_parts/nswc_part_06.f90#L4415) |


The subroutines DPOSE and DPOSE1 are available for transposing a sparse m x n double precision matrix A. DPOSE1 is more general than DPOSE. For any permutation mw = {81,...,tm} of {1, ...,m} let P denote the corresponding m x m permutation matrix. Then DPOSE1 computes the matrix (PA)‘.

```fortran
CALL DPOSE(A, IA, JA, B, IB, JB, M, N)
```

It is assumed that the sparse matrix A is stored in the arrays A, JA, JA. A and B are double precision arrays. If A and 7A contain k elements, then it is also assumed that B and JB are arrays of dimension /: and that 48 is an array of dimension n +1. When DPOSE is called, the transpose A® is stored |. B, IB, JB.

Remarks UPOST orders the elements of each row of A‘ so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. If zero elements appear in the array A, then the zero elements will also appear in B.

Restriction. Ji is assumed that the storage areas B, 1B, JB do not overlap with the storage areas A, JA, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, F. G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 250-269.

```fortran
CALL DFOSE1{x, A, fA, JA, B,1B,J3,m,n)
```

It is assumed that m ig an integer array of dimension m containing the data {11, ...,4m}, and that the sparse matrix A is stored in the arrays A, /A, JA. A and B are double precision arrays. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that /B is an array of dimension n +-1. When DPOSE1 is called, (PA)* is computed and the results are stored in B, 7B, JB.

Remarks, DPOSE1 orders the elements of each row of (7?A)! so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. if zero elements appear in the array A, then the zero elements will also

appear in J.

Restriction. It is assumed that the storage areas B, 7B, JB ao not overlap with the storage areas A, JA, JA.

**Programmer.** A. Hl. Morris.

**Reference.** Gustavson, Ff. G., “Two Fast) Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 261) 269


<small>Original source: [View scanned PDF page 235](scans/page_0235.png)</small>

<a id="topic-235-01"></a>
### Transposing Sparse Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPOSE` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, M, N` | [`L57249`](source_parts/nswc_part_06.f90#L4482) |
| `CPOSE1` | `SUBROUTINE` | `P, A, IA, JA, B, IB, JB, M, N` | [`L57313`](source_parts/nswc_part_06.f90#L4546) |


The subroutines CPOSE and CPOSE] are available for transposing a sparse m x n complex matrix A. CPOSE1 is more general than CPOSE. For any permutation m = {$1,...,tm} of {1,...,m} let P denote the corresponding m x m permutation matrix. Then CPOSE1 computes the matrix (P.A)'.

```fortran
CALL CPOSE(A, IA, JA, B, IB, JB, M, N)
```

it is assumed that the sparse matrix A is stored in the arrays A, [A, JA. A and B are complex arrays. If A and JA contain k elements, then it is also assumed thai B and JB are arrays of dimension k and that 7B is an array of dimension n+ l. When CPOSE is called, the transpose A‘ is stored in B, /B, JB.

**Remarks.** CPOSE orders the elements of each row of A‘ so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. If zero elements appear in the array A, then the zero elements will also appear in B.

Restriction. It is assumed that the storage areas B, 1B, JB do not overlap with the storage areas A, IA, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, F. G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” ACM Trans. Math Software 4 (1978), pp. 250-269.

```fortran
CALL CPOSE1(P, A, IA, JA, B, IB, JB, M, N)
```

It is assumed that 7 is an integer array of dimension m containing the data {#;, ...,1m}, and that the sparse matrix A is stored in the arrays A, [A, JA. A and B are complex arrays. If A and JA contain k elements, then it is also assumed that B and JB are arrays of dimension k and that JB is an array of dimension n+ 1. When CPOSE1 is called, (PA)* 13 computed and the results are stored in #8, 1B, JB.

Remarks, CPOSE1 orders the elements of each row of (PA)! so that the column indices of the elements of the row are in ascending order. However, it does no checking for zero elements in A. [f zero elements appear in the array A, then the zero elements will also

appear in 7.

Restriction. It is assumed that the storage areas B, 1, J 28 do not overlap: with the storage areas A, 1A, JA.

**Programmer.** A. H. Morris.

**Reference.** Gustavson, Po G., “Two Fast Algorithms for Sparse Matrices: Multiplication and Permuted Transposition,” 4CM Trans. Math. Software d (1978), pp. 250. 269.


<small>Original source: [View scanned PDF page 236](scans/page_0236.png)</small>

<a id="topic-236-01"></a>
### Addition of Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L57380`](source_parts/nswc_part_06.f90#L4613) |
| `DSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L57448`](source_parts/nswc_part_06.f90#L4681) |
| `CSADD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L57516`](source_parts/nswc_part_06.f90#L4749) |


The following subroutines are available for adding sparse matrices.

```fortran
CALL SADD(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL DSADD(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL CSADD(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
```

A and 8 are sparse m x n matrices stored in the arrays A,JA,JA and B,J B,JB. ‘4 is assumed that A -- B is to be stored in sparse form in the arrays C,IC,JC. NUM ‘s tie estimated maximum number of elements that will appear in C and JC. It is assumed that. C and JC are arrays of dimension max{i, NUM} and that JC is an array of dimension mot 1,

SADD is used if A,B,C, and WK are real arrays, DSADD is used if A,B,C, and WK are double precision arrays, and CSADD is used if A,B,C, and WK are complex arrays.

WK is an array of dimension n or larger that is a work space for the routine.

IERR is an integer variable. When the routine is called, if NUM specifies sufficient, storage for C and JC then A+ B is computed and stored in C,\JC,JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C and JC for the s** row of A+ B, then IERR is set to 1 and the routine terminates. In this case, if? > 1 then the first 1 — 1 rows of A+ B will have been computed and stored in C and JC. Also [C(1),...,/C(¢) will contain the appropriate row locations.

**Remarks.**

```text
(1) No zeros are stored in C.
(2) It is assumed that C,/C,JC reference different storage areas than A,/JA,JA and
B,IB,JB.
```

**Programmer.** A. H. Morris.

31h


<small>Original source: [View scanned PDF page 237](scans/page_0237.png)</small>

<a id="topic-237-01"></a>
### Subtraction of Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L57584`](source_parts/nswc_part_06.f90#L4817) |
| `DSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L57652`](source_parts/nswc_part_06.f90#L4885) |
| `CSSUBT` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR` | [`L57720`](source_parts/nswc_part_06.f90#L4953) |


The following subroutines are available for subtracting sparse matrices,

```fortran
CALL SSUBT(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL DSSUBT(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
CALL CSSUBT(A, IA, JA, B, IB, JB, C, IC, JC, M, N, NUM, WK, IERR)
```

A and B are sparse m x n matrices stored in the arrays A,JA,JA and B,IB,JB. It is assumed that A -- B is to be stored in sparse form in the arrays C',JC,JC. NUM is the estimated maximum number of elements that will appear in C and JC. lt is assumed that C and JC’ are arrays of dimension max{1, NUM} and that IC is an array of dimension m+,

SSUBT is used if A,B,C, and WK are real arrays, DSSUBT is used if A,B,C, and WK are double precision arrays, and CSSUBT is used if A,B,C, and WK are complex arrays.

WK is an array of dimension n or larger that is a work space for the routine.

TERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for C and JC then A -— 8 is computed and stored in CJC JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C ard JC for the t** row of A — B, then IERR is set tot and the routine terminates. In this case, iff > 1 then the first ¢— 1 rows of A— B will have been computed and stored in C and JC. Also IC(1), ...,C(¢) will contain the appropriate crow locations.

**Remarks.**

```text
(1) No zeros are stored in C’.
(2) lt is assumed that C,/C’,JC reference different storage areas than A,JA,JA and
BIB, JE.
```

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 238](scans/page_0238.png)</small>

<a id="topic-238-01"></a>
### Multiplication Of Sparse Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [`L57788`](source_parts/nswc_part_06.f90#L5021) |
| `DSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [`L57849`](source_parts/nswc_part_06.f90#L5082) |
| `CSPROD` | `SUBROUTINE` | `A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR` | [`L57910`](source_parts/nswc_part_06.f90#L5143) |


The following subroutines are available for multiplying sparse matrices.

```fortran
CALL SPROD(A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR)
CALL DSPROD(A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR)
CALL CSPROD(A, IA, JA, B, IB, JB, C, IC, JC, L, M, N, NUM, WK, IERR)
```

A is a sparse £ x m matrix stored in the arrays A,JA,JA, and B a sparse m xX n matrix stored in the arrays B,/B,JB. It is assumed that AB is to be stored in sparse form in the arrays C,/C,JC. NUM is the estimated maximum number of elements that will appear in C and JC. It is assumed that C and JC are arrays of dimension max{1, NUM} and that IC is an array of dimension @+ 1.

SPROD is used if A,B,C, and WK are real arrays, DSPROD is used if A,B,C, and WK are double precision arrays, and CSPROD is used if A,B,C, and WK are complex arrays.

WK is an array of dimension n or larger that is a work space for the routine.

IERR is an integer variable. When the routine is called, if NUM specifies sufficient storage for C and JC then AB is computed and stored in C,IC,JC. Also IERR is assigned the value 0.

**Error Return.** If there is not sufficient storage in C and JC for the 1** row of AB, then IERR is set tos and the routine terminates. In this case, if 1 > 1 then the first - 1 rows of AB will have been computed and stored in C and JC. Also 1C(1), ..., JC(#) will contain the appropriate row locations.

**Remarks.**

```text
(1) No zeros are stored in C’.
(2) It is assumed that C,/JC,JC reference different storage areas than A,/JA,JA and
B,1B,JB.
```

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 239](scans/page_0239.png)</small>

<a id="topic-239-01"></a>
### Product Of A Real Sparse Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L57971`](source_parts/nswc_part_06.f90#L5204) |
| `MVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L57996`](source_parts/nswc_part_06.f90#L5229) |
| `MTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58021`](source_parts/nswc_part_06.f90#L5254) |
| `MTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58050`](source_parts/nswc_part_06.f90#L5283) |


Let A be a real mx n sparse matrix stored in the arrays A,/A,JA. Then the following subroutines are available for multiplying A with a real vector.

```fortran
CALL MVPRD(M, N, A, IA, JA, X, Y)
```

The argument z is a column vector of dimension n and y an array of dimension m. When MVPRD is called, Az is computed and stored in y.

**Remark.** It is assumed that the arrays A,2,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL MVPRD1(M, N, A, IA, JA, X, Y)
```

The arguments x and y are column vectors of dimension n and m respectively. When MVPRDt1 is called, Az + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,x,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL MTPRD(M, N, A, IA, JA, X, Y)
```

The argument x is a row vector of dimension m and y an array of dimension n. When MTPRD is called, A is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL MTPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are row vectors of dimension m and n respectively. When MTPRD1 is called, 2A + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 240](scans/page_0240.png)</small>

<a id="topic-240-01"></a>
### Product Of A Double Precision Sparse Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58075`](source_parts/nswc_part_06.f90#L5308) |
| `DVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58100`](source_parts/nswc_part_06.f90#L5333) |
| `DTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58125`](source_parts/nswc_part_06.f90#L5358) |
| `DTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58154`](source_parts/nswc_part_06.f90#L5387) |


Let A be a double precision m x n sparse matrix stored in the arrays A, /A,JA. Then the following subroutines are available for multiplying A with a double precision vector.

~ CALL DVPRD(m,n, A, IA, JA, 2, y)

The argument z is a column vector of dimension n and y an array of dimension m. A, x, y are double precision arrays. When DVPRD is called, Az is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DVPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are column vectors of dimension n and m respectively. A, x, y are double precision arrays. When DVPRD1 is called, Ax + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DTPRD(M, N, A, IA, JA, X, Y)
```

The argument z is a row vector of dimension m and y an array of dimension n. A, z, y are double precision arrays. When DTPRD is called, 2A is computed and stored in y.

**Remark.** It is assumed that the arrays A,2,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL DTPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are row vectors of dimension m and n respectively. A, x, y are double precision arrays. When DTPRDI is called, 2A + y is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 241](scans/page_0241.png)</small>

<a id="topic-241-01"></a>
### Product Of A Complex Sparse Matrix And Vector

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CVPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58179`](source_parts/nswc_part_06.f90#L5412) |
| `CVPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58204`](source_parts/nswc_part_06.f90#L5437) |
| `CTPRD` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58229`](source_parts/nswc_part_06.f90#L5462) |
| `CTPRD1` | `SUBROUTINE` | `M, N, A, IA, JA, X, Y` | [`L58258`](source_parts/nswc_part_06.f90#L5491) |


Let A be a complex m x n sparse matrix stored in the arrays A,IA,JA. Then the following subroutines are available for multiplying A with a complex vector.

```fortran
CALL CVPRD(M, N, A, IA, JA, X, Y)
```

The argument x is a column vector of dimension n and y an array of dimension m. A,z,y ate complex arrays. When CVPRD is called, Ax is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CVPRD1(M, N, A, IA, JA, X, Y)
```

The arguments z and y are column vectors of dimension n and m respectively. A,a,y are complex arrays. When CVPRD1 is called, Az + y is computed ard stored in y.

**Remark.** It is assumed that the arrays A,z,y do not overlap. Programmer. A. H. Morris.

```fortran
CALL CTPRD(M, N, A, IA, JA, X, Y)
```

The argument 2 is a row vector of dimension m and y an array of dimension n. A,z,y are complex arrays. When CTPRD is called, 2A is computed and stored in y.

**Remark.** It is assumed that the arrays A,z,y do net overlap. Programmer. A. H. Morris.

```fortran
CALL CTPRD1i(m,n, A, 1A,/ 4,2, y)
```

The arguments x and y are row vectors of dimension m and n respectively. A,z,y are complex arrays. When CTPRDL is called, 2A + y is computed and stored in y.

**Remark.** Ii is assumed that the arrays A,z,y do not overlap.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 242](scans/page_0242.png)</small>

<a id="topic-242-01"></a>
### L1 Norm of a Sparse Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `S1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [`L58309`](source_parts/nswc_part_06.f90#L5542) |
| `DS1NRM` | `SUBROUTINE` | `A, IA, JA, M, N, ANORM, WK` | [`L58368`](source_parts/nswc_part_06.f90#L5601) |


```text
If A = (a,;) is a sparse real matrix then the following subroutines are available for
computing the 2; norm ||Al|,; = max, U,{o,,;| of A.
```

```fortran
CALL SiNRM(A,/A,J.A,m,n,ANGRM,WK)
CALL DS1NRM(A, IA, JA, M, N, ANORM, WK)
```

S1NRM is used if A and WK are real arrays and ANORM areal variable, and DSINKM is used if A and WK are double precision arrays and ANORM a double precision variable.

A is a sparse m X n matrix stored in the arrays A, 1A, JA. When the routine is called, the variable ANORM is assigned the value || Alj1.

WK is an array of dimension n or larger that is a work space for the routine.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 243](scans/page_0243.png)</small>

<a id="topic-243-01"></a>
### L-infinity Norm of a Sparse Real Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SNRM` | `REAL FUNCTION` | `A, IA, JA, M, N` | [`L58283`](source_parts/nswc_part_06.f90#L5516) |
| `DSNRM` | `DOUBLE PRECISION FUNCTION` | `A, IA, JA, M, N` | [`L58342`](source_parts/nswc_part_06.f90#L5575) |


```text
If A = (a,;) is a sparse real m x n matrix then the following functions are available for
computing the é,, norm ||Aj|.o = max, Z,|a,;| of A.
```

SNRM(4A,/A,JA,m,n) DSNRM(A.IA,JA,m,n)

SNRM is used if A is a real array and DSNRM is used if A is a double Precision array. SNRM is a real function and DSNRM a double precision function.

A is a sparse m X n matrix stored in the arrays A, IA, JA. When either of these functions is called then the function is assigned the value ||Al|oo-

**Remark.** DSNRM must be declared to be of type DOUBLE PRECISION in the calling program.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 244](scans/page_0244.png)</small>

<a id="topic-244-01"></a>
### Ordering The Rows Of A Sparse Matrix By Increasing Length

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPORD` | `SUBROUTINE` | `M, N, IA, R, IWK` | [`L58402`](source_parts/nswc_part_06.f90#L5635) |


Let A be a sparse mxn matrix stored in the arrays A, JA, JA. The following subroutine is available for ordering the rows of the matrix by increasing length.

```fortran
CALL SPORD(M, N, IA, R, IWK)
```

R is an integer array of dimension m. When SPORD 1s called, the rows of the matrix are ordered by increasing length. The row ordering is given in R.

IWK is an integer array of dimension m+n-+1 or larger that is used for a work space.

**Remark.** If rows t;,...,%,% are the rows of length @, then the indices 1), ...,%% are listed in F in increasing sequence.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 245](scans/page_0245.png)</small>

<a id="topic-245-01"></a>
### Reordering Sparse Matrices Into Block Triangular Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BLKORD` | `SUBROUTINE` | `N, IA, JA, R, C, IB, NUM, IWK, IERR` | [`L58442`](source_parts/nswc_part_06.f90#L5675) |


Let A be a sparse n x n matrix stored in the arrays A,/A,JA. Then the subroutine SLKORD is available for reordering the rows and columns of A so that one has a lower block triangular matrix

‘Ay 0 Az: Azz

(+) . . « Agr Ago... Akk

where the blocks A,,; are square and cannot themselves be reordered into lower block triangular form.

```fortran
CALL BLKORD(N, IA, JA, R, C, IB, NUM, IWK, IERR)
```

Rand C are integer arrays of dimension n, and IERR is an integer variable. When BLKORD is called, the rows of the matrix are first ordered so that the main diagonal contains @ maximum number of nonzeros. After this is done then IERR = the number of zeros that appear on the diagonal. If [ERR = 0 then the rows and columns of the matrix are ordered into block triangular form (*). The row ordering is given in R and the column ordering is given in C.

TB is an integer array of dimension n and k is an integer variable. When the matrix has been ordered into block triangular form (*) then k = the number of blocks A,;. Also 7B(t) — the row number in the block triangular matrix of the beginning of block A,,; (¢ = 1, ...,k).

IWK is an integer array of dimension 5n or larger that is used for a work space by the routine.

**Error Return.** If [FRR # 0 then the routine terminates. In this case, R contains the row ordering that gives the main diagonal with the maximum number of nonzeros.

**Remark.** JA,JA, and m are not modified by the routine.

**Programming.** BLKORD employs the subroutines MC2Z1A, MC21B, MCI3D, MCI3E designed by I. S. Duff and J. K. Reid (AE RE Harwell,England).

**References.**

(1) Duff, f.S., “On Algorithms for Obtaining a Maximum ‘Transversal,’ ACM Trans. Math Software 7 (1981), pp.315 330.

(2) Duff, £ S. and Reid, J. Ko, “An Implementation of Tarjan’s Algorithm for the Block Triangularization of a Matrix,” ACM Trans. Math Software 4 (i978), pp. 187 147,


<small>Original source: [View scanned PDF page 246](scans/page_0246.png)</small>

<a id="topic-246-01"></a>
### Solution Of Sparse Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [`L58854`](source_parts/nswc_part_06.f90#L6087) |
| `RSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L59260`](source_parts/nswc_part_06.f90#L6493) |
| `TSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L59411`](source_parts/nswc_part_06.f90#L6644) |


Let A be a nonsingular ». x n sparse real matrix stored in the arrays A,JA,JA and let 6 be areal column vector c dimension n. The subroutines SPSLV and RSLV are available for solving the system cf equations Ar = b, and the subroutine TSLV is available for solving the transposed system cf equations A’z = $. These routines employ partial pivot gauss elimination with column interchanges to first obtain an LU decomposition of A. If SPSLV is called then only the off-diagonal nonzero elements of U are stored, and then the equations are solved. However, if RSLV or TSLV is called then the off-diagonal nonzero elements of both L and U are stored. Thus RSLV and TSLV will frequently require at least double the amount of storage needed by SPSLV, but they can be recalled to solve other systems of equations Az = r and A'z = r without having to redecompose the matrix A. Moreover, since RSLV and TSLV will always generate the same LU decomposition of A, RSLV can be called to decompose A and solve a system of equations Ax = 5, and then TSLV can be called so solve a transposed system of equations Atz = r using the decomposition obtained by RSLV.

```fortran
CALL SPSLV(N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR)
```

It is assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations Az = 6 is computed and stored in X. A,JA, JA and 6 are not modified by the routine.

Rois ao integer array of n entries specifying the order in which the n rows of A are I y

to be examined and processed. For example, if R contains the entries 4), ...,t, then the algorithm first performs operations on row 7;, next on row tg, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of a subroutine such as SPSLV. ‘Thus 2 must be chosen judiciously.

R is not modified by the routine.

Cos an integer array of n entries which plays a role similar to 7. On input, © specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries jy, ..-, J, then it is suggested that the first pivot element may be from column jy, the second pivot element from column go, ete. However, since partial pivoting with column interchange is performed, on output Co may have been modified. On output, Co will contain the actual order of the m columns from

which the pivot elements were selected. his order will depend on A and R, and not on b.

IWK and WK are arrays for internal use by the routine, and MAX is an input argument When SPSLV is called, an LU decomposition of Ads first obtained where ois a limit upper triangular matrix. The offdiagonal portion of (ois stored in sparse form in PWR and Wis MAX is an estimate of the maximum number of off-diagonal elements of ( that might be nonzero and have to be stored (MAX so on(a 2) o2). IWR is cu integer array of dimension Bn ft MAN ¢ 2oor larger, and Whois areal array of dimension mob MPAX or dare


<small>Original source: [View scanned PDF page 247](scans/page_0247.png)</small>

IERR is an integer variable that reports the status of the results. When the routine terminates, TERR has one of the following values:

IEk 2 > 0 Az = 6 was solved. IERR = max{1,m} where m is the number of off-diagonal nonzero elements of U.

IERR =0 ‘The argument n is nonpositive.

IERR = ~k Row R(k) of A is null.

IERR = — n— & Row R(k) of A has a duplicate entry.

IERR = —2n — k Row R(k) of A has been reduced to a row containing only zeros.

IERR = --3n — k Row & of the upper triangular matrix exceeds storage.

MAX must be increased.

When an error is detected, the routine immediately terminates.

**Remarks.** The amount of storage MAX depends critically on the row ordering given in R. If it is suspected that the rows and columns of .A can be reordered so that one has a lower block triangular matrix

Au {)

Az Azz

Ax Ak eae Akk

then the subroutine BLKORD should first be tried. This subroutine will specify an ordering for lower block triangular form if one exists. However, if such an ordering does not exist and one is uncertain how to order the rows, then the row ordering given by the subroutine SPORD frequently yields good results. In any case, the selection of an initial column ordering C is never bothersome since partial pivoting with column interchanges is performed. The initial ordering C(t) =: 1 (f = 1, ...,n) always suffices.

**Programming.** SPSLV is a modification by A. H. Morris of the subroutine NSPIV. SPSLV employs the subroutine NSPIV1. NSPIV and NSPIV1 were written by Andrew H. Sherman (University of Texas at Austin).

**Reference.** Sherman, Andrew H.,“Algorithms for Sparse Gaussian Elimination with Partial Pivoting,” “M Trans. Math Software 4 (1978), pp.330-~338.

```fortran
CALL RSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
CALL TSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
```

RSLV is called for solving Ar ~ 5, and TSLV is called for solving Abr <= 6. MO is an input argument which specifies if RSLV or TSLV is being called for the first time. On an initial call, MO ©. 0 and we have the following setup:

It is assumed that n° P and that X is an array of dimension re. Che solution of the system of equations is stored in X. A, JA, JA are not modified by the routines. X and b may share the same storage area. If A is a separate storage area then 6 is not modified by

the routines.


<small>Original source: [View scanned PDF page 248](scans/page_0248.png)</small>

\# ig an integer array of entries specifying the order in which the n rows of A are to be examined and processed. For example, if R contains the entries ¢), ...,1, then che algorithm first performs operations on row tj, next on row fq, etc. It is well known that the or“er in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of subroutines such as RSLV and TSLV. Thus & must be chosen judiciously. & is net modified by the routine.

C is an integer array of « entries which plays a role similar to #. On input, C specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries 71, ...,j7, then it is suggested that the first pivot element may be from column j,, the second pivot element from column 33, etc. However, since partial pivoting with column interchange is performed, on output C’ may have been modified. On output, C will contain the actual order of the » columns from which tus pivot elements were selected. This order will depend on A and R, and not on 8.

iV¥K and WK are arrays for internal use by the routines, and MAX is an input argument. On an initial call to RSLV or TSLV, an LU decomposition of A is first obtained where J. is 4 lower triangular matrix and U a unit upper triangular matrix. The off-diagonal portions of 1 and 'J are stored in sparse form in IWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of £ and U that might be nonzero and have to be stored (MAX < n(n — 1)}. [WK is an integer array of dimension 4n + MAX + 2 or larger, and ‘VK is a real array of dimension 2n + MAX or larger.

On an initial call to RSLV or TSLV, JERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values: IERR > 0 The system of equations was solved. IERR=miax{1,m} where m is the total number of off-diagonal nonzero elements of L and U.

[ERR =0 The argument n is nonpositive.

IERit = -k Row R(k) of A is null.

JERR =~ n~- k Row R(k) of A has a duplicate entry.

TERR = --2n ~ k Row R(x} of A has been reduced to a row containing

only zeros. TERR =: ~3n -- k Row & of L or U exceeds storage. MAX must be increased,

When an error is detect 2d, the routine immediately terminates.

After an initial call to RSLV or TSLV, if IERR > 0 on output then either routine may be called with MO #0. When MO + 0 it is assumed that only 8 may have been modified. RSLV is called for solving the new set of equations Ax -~ 6, and TSLV is called for solving the new set of equations A'a = 6. The routine employs the LU decomposition obtained on the initial call to RSLV or TSLV to solve the new system of equations. The solution is stored in X. As before, Y and 6 may share the same storage area. H MO -4 0 then only n, A, CO, IWK, and WH are used. A, PA, JA, RTAX, and PERR are not referenced by the rOUtInG,

**Note.** The remarks concerning the ordering Gf the rows and columns of A when SPSLV is

LOT


<small>Original source: [View scanned PDF page 249](scans/page_0249.png)</small>

used hold also fur RSLV and TSLV.

**Programming.** RSLV calls the subroutines RSLV1 and SPLU, and TSLV calls the subroutines TSLV1 and SPLU. These routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 250](scans/page_0250.png)</small>

<a id="topic-250-01"></a>
### Computation Of The Condition Number Of A Real Sparse Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `S1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [`L60752`](source_parts/nswc_part_06.f90#L7985) |


If A is a real nXm sparse matrix then the following subroutine is available for estimating the €; condition number cond,(A) of A.

```fortran
CALL SiCND(n, A, A, JA, R, C,MAX,COND,IWK,WK,IERR)
```

A ig 4 sparse matrix stored in the arrays A,JA,Jsi. The arguments R, C, MAX, IWK, and WK are the same arguments used for the subroutines RSLV and TSLV, the only exceptions being that [WK now is an array of dimension 5n -+ MAX + 2 or larger, and WK is an array of dimension 4n + MAX or larger.

COND is a real variable. When S1CND is called, then the subroutine RSLV is first invoked to obtain an LU decomposition of A, which is stored in the arrays IWK and WK. Then COND is assigned the value 0 if A is singular and an approximation of the condition number cond,{A) if A is nonsingular.

IERR is an integer variable that reports the status of the results. When SiCND terminates, TERR has one of the following values:

JERR > 0 A is nonsingular. COND = an approximation of the condition number of A, and IERR = max{i,m} where m is the number of off-diagonal nonzero elements of Z and U.

iKRR = 0 A is singular and COND = 0,

TERR := ~k Row R{k) of A has a duplicate entry.

iIERR < -n Row R(k) of L or U exceeds storage where IERR = —(n + k). MAX must be increased.

When an error is detected, the routine immediately terminates.

Usage. After S1CND terminates, if IERR > 0 then RSLV or TSLV may be called with MO # O to solve a system of equations. In this case n,R,C,WK, and IWK are used by RSLV and TSLV, and must not be modified by the user.

**Algorithm.** A modification cf the Hager procedure by Nicholas J. Higham (University of Manchester, England) is used.

**Programming.** S1CND employs the subroutines SENRM, SONEST, SCOPY, RSLV, TSLV, RSLV1, PSLVI, and SPLU, and the functions SASUM and ISAMAX. S1CND was written by A. H. Morris. SONEST was written by Nod. Higham and modified by A. H. Morris.

**References.**

(1) higham, NJ. “FORTRAN Codes for Estimating the One Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACA Tran, Math Software 14 (1988), pep. USL 396,


<small>Original source: [View scanned PDF page 251](scans/page_0251.png)</small>

ee “Algorithm 674: FORTRAN Codes for Estimating the One-Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 15 (1989), p. 168.


<small>Original source: [View scanned PDF page 252](scans/page_0252.png)</small>

<a id="topic-252-01"></a>
### Double Precision Solution Of Sparse Systems Of Real Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [`L59800`](source_parts/nswc_part_06.f90#L7033) |
| `DSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L60209`](source_parts/nswc_part_06.f90#L7442) |
| `DTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L60361`](source_parts/nswc_part_06.f90#L7594) |


Let A be a nonsingular n x n sparse double precision matrix stored in the arrays A, IA,JA and let 6 be a double precision column vector of dimension n. The subroutines DSPSLV and DSLV are available for solving the system of equations Az = 6, and the subroutine DTSLV is available for solving the transposed system of equations A’z = b. These routines employ partial pivot Gauss elimination with column interchanges to first obtain an LU decomposition of A. If DSPSLV is called then only the off-diagonal nonzero elements of U are stored, and then the equations are solved. However, if DSLV or DTSLV is called then the off-diagonal nonzero elements of both L and U are stored. Thus DSLV and DTSLV will frequently require at least double the amount of storage needed by DSPSLV, but they can be recalled to solve other systems of equations Ar = r and A‘z = r without having to redecompose the matrix A. Moreover, since DSLV and DTSLV will always generate the same LU decomposition of A, DSLV can be called to decompose A and solve a system of equations Az = 6, and then DTSLV can be called to solve a transposed system of equations Atz =r using the decomposition obtained by DSLV.

```fortran
CALL DSPSLV(N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR)
```

A, 6, and X are double precision arrays. It is assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations Ar = 6 is computed and stored in X. A,JA, JA and 5 are not modified by the routine.

Ris an integer array of n entries specifying the order in which the n rows of A are tr, be examined and processed. For example, if R contains the entries 11, ...,%, then the algorithm first performs operations on row t1, next on row f9, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of a subroutine such as DSPSLV. Thus R must be chosen judiciously. FR is not modified by the routine.

C is an integer array of n entries which plays a role similar to R. On input, C specifies a suggested order in which the n columns of A should be ordered fer selection of the pivot elements. For example, if C contains the entries 71, ...,jn then it is suggested that the first pivot element may be from column j;, the second pivot element from column jo, etc. However, since partial pivoting with column interchange is performed, on output C may have been modified. On output, C’ will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and R, and not on b.

{WK and WK are arrays for internal use by the routine, and MAX is an input argument. When DSPSLV is called, an LU decomposition of ¢. is first obtained where U is a unit upper triangular matrix. The off-diagonal portion of U is stored in sparse form in IWK and WK. MAX 1s an estimate of the maximum number of off-diagonal elements of U that might be nonzero and have to be stored (MAX < n(n -- 1)/2). {WK is an integer array of dimension an 4+ MAX -+ 2 or larger, and WK is a double precision array of dimension n + MAX or larger.


<small>Original source: [View scanned PDF page 253](scans/page_0253.png)</small>

IERR is an integer variable that reports the status of the results. When the routine terminates, ERR has one of the following values:

IERR > 0 Ag = 6 was solved. IERR = max{1,m} where m is the number of off-diagonal nonzero elements of U.

IERR =0 The argument n is nonpositive.

IERR = --k Row R(k) of A is null.

IERR = — n—k Row R(k) of A has a duplicate entry.

IERR = --2n — k Row R(k) of A has been reduced to a row containing only zeros.

IERR = —3n—k Row k of the upper triangular matrix exceeds storage.

MAX must be increased.

When an error is detected, the routine immediately terminates.

**Remarks.** The amount of storage MAX depends critically on the row ordering given in R. If it is suspected that the rows and columns of A can be reordered so that one has a lower block triangular matrix

Ay 0 )

Az A2ze2

Agi Axa ...) Akk /

then the subroutine BLKORD should first be tried. This subroutine will specify an ordering for lower block triangular form if one exists. However, if such an ordering does not exist and one is uncertain how to order the rows, then the row ordering given by the subroutine SPORD frequently yields good results. In any case, the selection of an initial column ordering C is never bothersome since partial pivoting with column interchanges is performed. The initial ordering C(t) = 1 (t= 1, ...,n) always suffices.

**Programming.** DSPSLV an adaptation by A. H. Morris of the subroutine NSPIV written by Andrew H. Sherman (University of Texas at Austin). DSPSLV employs the subroutine DNSPIV.

**Reference.** Sherman, Andrew H.,“Algorithms for Sparse Gaussian Elimination with Partial Pivoting,” ACM Trans. Math Software 4 (1978), pp.330-338.

```fortran
CALL DSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
CALL DTSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
```

DSLV is called for solving Ax = 6, and DTSLV is called for solving Az = b. MO is an input argument which specifies if NSLV or DTSLV is being called for the first time. On an initial call, MO == 0 and we have the following setup:

A, b, and X are double precision arrays. {t ia assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations is stored in X. A, 1A, JA are not modified by the routines. X and 6 may share the same storage area. [f X is a separate storage area then 6 is not modified by the routines.


<small>Original source: [View scanned PDF page 254](scans/page_0254.png)</small>

R is an integer array of n entries specifying the order in which the » rows of A are to be examined and processed. For example, if R contains the entries 11, ...,%, then the algorithm first performs operations on row s1, next on row ¢g, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of subroutines such as DSLV and DTSLV. Thus & must be chosen judiciously. # is not modified by the routine.

C is an integer array of n entries which plays a role similar to #. On input, C specifies a suggested order in which the m columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries j1,...,7, then it is suggested that the first pivot element may be from column j;, the second pivot element from column je, etc. However, since partial pivoting with column interchange is performed, on output C may have been modified. On output, C will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and R, and not on 6.

IWK and WK are arrays for internal use by the routines, and MAX is an input argument. On an initial call to DSLV or DTSLV, an LU decomposition of A is first obtained where L is a lower triangular matrix and U a unit upper triangular matrix. The off-diagonal portions of Z and U are stored in sparse form in IWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of L and U that might be nonzero and have to be stored (MAX < n(n — 1)). [WK is an integer array of dimension 4n + MAX + 2 or larger, and WK is a double precision array of dimension 2n + MAX or larger.

On an initial call to DSLV or DTSLV, IERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values:

IERR > 0 The system of equations was solved. IERR=max (1, m} where m is the total number of off-diagonal nonzero elements of L and U.

IERR =0 The argument n is nonpositive.

IERR = --k Row R(k) of A is null.

IERR = — »— k Row R(k) of A has a duplicate entry.

IERR = -2n. k Row Plk) of A has been reduced to a row containing only zeros.

IERR = ~—3n — k Row k of L or U exceeds storage. MAX must be increased.

When an error is detected, the routine immediately terminates.

After an initial call to DSLV or DTSLV, if FERR > 0 on output then either routine may ve called with MO #0. When MO ¥ 0 it is assumed that only 6 may have been modified. DSLV is called for solving the new set of equations Az = b, and DTSLV is called for solving the new set of equations A'r = 6. The routine employs the LU decomposition obtained on the initial call to DSLV or DTSLV to solve the new system of equations. The solution is stored in X. As before, X and 6 may share the same storage area. If MO # 0 then only n, A, C, (WK, and WK are used. A, JA, JA, MAX, and IERR are not referenced by the routine.

Note. The remarks concerning the ordering of the rows and columns of A when DSPSLV


<small>Original source: [View scanned PDF page 255](scans/page_0255.png)</small>

is used hold also for DSLV and DTSLV.

**Programming.** DSLV calls the subroutines DSLV1 and DSPLU, and DTSLV calls the subroutines DTSLV1 and DSPLU. These routines were written by A. H. Morris.


<small>Original source: [View scanned PDF page 256](scans/page_0256.png)</small>

<a id="topic-256-01"></a>
### Computation Of The Condition Number Of A Double Precision Sparse Matrix

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DS1CND` | `SUBROUTINE` | `N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR` | [`L60820`](source_parts/nswc_part_06.f90#L8053) |


If A is a double precision n x n sparse matrix then the following subroutine is available for estimating the £; condition number cond,(A) of A.

```fortran
CALL DS1CND(N, A, IA, JA, R, C, MAX, COND, IWK, WK, IERR)
```

A ig 4 sparse matrix stored in the arrays A,/A,JA where A is a double precision array. The arguments R, C, MAX, IWK, and WK are the same arguments used for the subroutines DSLV and DTSLV, the only exceptions being that [WK now is an array of dimension 5n + MAX + 2 or larger, and WK is an array of dimension 4m -+ MAX or larger.

COND is a double precision variable. When DS1CND is called, then the subroutine DSLV is first invoked to obtain an LU decomposition of A, which is stored in the arrays IWK and WK. Then COND is assigned the value 0 if A is singular and an approximation of the condition number cond,(A) if A is nonsingular.

TERK is an integer variable that reports the status of the results. When DS1CND terminates, JERR has one of the following values:

TERR > O A is nonsingular. COND = an approximation of the condition number of A, and [ERR = max{1,m} where m is the number of oi-diagonal nonzero elements of L and U.

TERR = O© Ais singular and COND = 0.

IERR = -k Row R(k) of A has a duplicate entry.

IERR < -n Row R(k) of L or U exceeds storage where [ERR = —(n + k). MAX must be increased.

When an error is detected, the routine immediately terminates.

Usage. After DS1CND terminates, if IW@Rix > 0 then DSLV or DTSLV may be called with MO +¥ 0 to solve a system of equations. In this case n, R,C,WK, and IWK are used by DSLV and DTSLV, and must not be modified by the user.

**Algorithm.** A modification of the Hager procedure by Nicholas J. Higham (University of Manchester, England) is used.

**Programming.** DS1CND employs the subroutines DSINRM, DONEST, DCOPY, DSLV, DSLV1, DTSLV, DTSLV1, and DSPLU, and the functions DASUM and IDAMAX. DS1CND was written by A. H. Morris. DONEST is the double precision form of the subroutine SON- EST, written by N. J. Higham and modified by A. H. Morris.

**References.**

(1) Higham, N.J.,“FORTRAN Codes for Estimating the One~Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 14 (1988), pp. 381-396.


<small>Original source: [View scanned PDF page 257](scans/page_0257.png)</small>

ee »“Algorithm 674: FORTRAN Codes for Estimating the One--Norm of a Real or Complex Matrix, with Applications to Condition Estimation,” ACM Trans. Math Software 15 (1989), p. 168.


<small>Original source: [View scanned PDF page 258](scans/page_0258.png)</small>

<a id="topic-258-01"></a>
### Solution Of Sparse Systems Of Complex Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSPSLV` | `SUBROUTINE` | `N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR` | [`L61284`](source_parts/nswc_part_06.f90#L8517) |
| `CSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L61694`](source_parts/nswc_part_06.f90#L8927) |
| `CTSLV` | `SUBROUTINE` | `M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR` | [`L61846`](source_parts/nswc_part_06.f90#L9079) |


Let A be a nonsingular n x n sparse complex matrix stored in the arrays A, J A,JA and let b be a complex column vector of dimension n. The subroutines CSPSLV and CSLV are available for solving the system of equations Az = 8, and the subroutine CTSLV is available for solving the transposed system of equations A‘tz = b. These routines employ partial pivot Gauss elimination with column interchanges to first obtain an LU decomposition of A. If CSPSLV is called then only the off-diagonal nonzero elements of U are stored, and then the equations are solved. However, if CSLV or CTSLV is called then the off-diagonal nonzero elements of both L and U are stored. Thus CSLV and CTSLV will frequently require at least double the amount of storage needed by CSPSLV, but they can be recalled to solve other systems of equations Az = r and A‘z = r without having to redecompose the matrix A. Moreover, since CSLV and CTSLV will always generate the same LU decomposition of A, CSLV can be called to decompose A and solve a system cf equations Ar = b, and then CTSLV can be called to solve a transposed system of equations A’z = r using the decomposition obtained by CSLV.

```fortran
CALL CSPSLV(N, A, IA, JA, B, R, C, MAX, X, ITEMP, RTEMP, IERR)
```

A, b, and X are complex arrays. It is assumed that n > 1 and that X is an array of dimension n. The solution of the system of equations Az = 6 is computed and stored in_X. A,IA, JA and 6 are not modified by the routine.

R is an integer array of n entries specifying the order in which the n rows of A are to be examined and processed. For example, if R contains the entries 11, ...,%, then the algorithm first performs operations on row 11, next on row t2, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of a subroutine such as CSPSLV. Thus A must be chosen judiciously. R is not modified by the routine.

C is an integer array of n entries which plays a role similar to R. On input, C specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C’ contains the entries Jiy+-+;dn then it is suggested that the first pivot element may be from column j,, the second pivot element from column 72, etc. However, since partial pivoting with column interchange is performed, on output Co may have been modified. On output, C will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and R, and not on 6.

IWK and WK are arrays for internal use by the routine, and MAX is an input argument, When CSPSLV is called, an LU decomposition of A is first obtained where U is a unit upper triangular matrix. The off-diagonal portion of U is stored in sparse form in TWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of U that might be nonzero and have to be stored (MAX < n(n ~ 1)/2). IWK is an integer array of dimension dn + MAX + 2 or larger, and WK is a complex array of dimension n | MAX or larger.

SAY


<small>Original source: [View scanned PDF page 259](scans/page_0259.png)</small>

IERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values:

IERR > 0 Az = 6b was solved. IERR = max{1,m} where m is the number of off-diagonal nonzero elements of U.

IERR =0 The argument n is nonpositive.

IERR = —k Row R(k) of A is null.

JERR = — n-k Row R(k) of A has a duplicate entry.

IERR = —2n—k Row R(k) of A has been reduced to a row containing only zeros.

IERR = ~3n—k Row k of the upper triangular matrix exceeds storage.

MAX must be increased.

When an error is detected, the routine immediately terminates.

**Remarks.** The amount of storage “AX depends critically on the row ordering given in &. If it is suspected that the rows and columns of A can be reordered so that one has a lower block triangular matrix

{Au 0

Avi Ag

er Arka... Akg

then the subroutine BL} ORD should first be tried. This subroutine will specify an ordering for lower block triangular form if -ne exists. However, if such an ordering does not exist aad one is uncertain how ‘o order :he rows, then the row ordering given by the subroutine SPORD frequently yields good results. In any case, the selection of an initial column ordering C is never bothersome. since partial pivoting with column interchanges is performed. The initial ordering C(t) =: + (¢--1,...,n) always suffices.

**Programming.** CSP3LV is an adaptation by A. H. Morris of the subroutine NSP! V written by Andrew H. Sherman (University of Texas at Austin). CSPSLV employs the subroutine CNSPIV.

**Reference.** Sherman, Andrew H.,“Algorith us for Sparse Gaussian Elimination with Partial Pivoting,” ACM Trans. Math Software 4 (1978), pp.350. 338.

```fortran
CALL CSLV(M0, N, A, IA, JA, B, R, C, MAX, X, IWK, WK, IERR)
CALL C. SEV(MO,n, 4, 1A, JA, b, Rt, CMAX,XIWK WK ,IERR)
```

CSLV is called for solving Ag. 6, and C'VSLV is called for solving Abx 6. MO is an Input argument which specifies wf CSLV or CTSLYV is being called for the first time. On an initial call, MO: U and we have the following setup:

A, 6, and X are complex arrays. [tas assumed that nm 7 E and that XY is an array of dimension n. The solution of the system of equations is stored in NA, PA, JA are not modified by the routines. Xo and 6 may share the same storage area. HN is a separate

storage area then bis nei modified by the routines. 5 ’


<small>Original source: [View scanned PDF page 260](scans/page_0260.png)</small>

R is an integer array of n entries specifying the order in which the n rows of A are to be examined and processed. For example, if R contains the entries 11, ...,1, then the algorithm first performs operations on row 11, next on row f2, etc. It is well known that the order in which the rows of a sparse matrix are processed can have a significant impact on the overall performance of subroutines such as CSLV and CTSLV. Thus R must be chosen judiciously, A is not modified by the routine.

C is an integer array of n entries which plays a role similar to R. On input, C' specifies a suggested order in which the n columns of A should be ordered for selection of the pivot elements. For example, if C contains the entries 71, ...,j, then it is suggested that the first pivot element may be from column J), the second pivot element from column jo, etc. However, since partial pivoting with column interchange is performed, on output C’ may have been modified. On output, C will contain the actual order of the n columns from which the pivot elements were selected. This order will depend on A and &, and not on 6.

IWK and WK are arrays for internal use by the routines, and MAX is an input argument. On an initial call to CSLV or CTSLV, an LU decomposition of A is first obtained where LF is a lower triangular matrix and U a unit upper triangular matrix. The off-diagonal portions of L and U are stored in sparse form in IWK and WK. MAX is an estimate of the maximum number of off-diagonal elements of L and U that might be nonzero and have to be stored (MAX < n(n -- 1)). TWK is an integer array of dimension 4n + MAX + 2 or larger, and WK is a complex array of dimension 2n -+- MAX or larger.

On an initial call to CSLV or CTSLV, IERR is an integer variable that reports the status of the results. When the routine terminates, IERR has one of the following values: IERR > 0 The system of equations was solved. INRR=max{1,m} where m is the total number of off-diagonal nonzero

elements of L and U.

IERR » 0 The argument nis nonpositive.

IERR = -k Row I(k) of A is null.

IE RR -n- k Row R(k) of A has a duplicate entry.

TERR én k Row R(k) of A has been reduced to a row containing only zeros

TERR 3n k Row kof Lo or U exceeds storage. Mi AX must be in-

creased.

When an error is detected, the routine immediately terminates,

After aa initial call to CSLY of CPSELV, of HeR RO} Coon output thee either routine ray be called with MO / 0. When MO / 0 it is assumed that only 6 may have been modified, CSLV is called for solving che new set of equations Arb, and CTSLV is called for solving the new set of equations Ale 6. The routine employs the LU decomposition obtained on the initial call te CSLY or CVSLYV to solve the pew system: of equations. The solution is stored in XY. As before, X and 6 may share the same storage area. IMO / 0 then only ny AOC, TWH, and WK are used A, PA, A, MAX, and PRR are not referenced by the routine,


<small>Original source: [View scanned PDF page 261](scans/page_0261.png)</small>

**Note.** The remarks concerning the ordering of the rows and columns of A when CSPSLV is used hold also for CSLV and CTSLV.

**Programming.** CSLV calls the subroutines CSLV1 and CSPLU, and CTSLV calls the subroutines CTSLV1 and CSPLU. These routines were written by A. H. Morris.


<a id="category-262"></a>
## Eigenvalues and Eigenvectors

<small>Original source: [View scanned PDF page 262](scans/page_0262.png)</small>

<a id="topic-262-01"></a>
### Computation Of Eigenvalues Of General Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [`L62239`](source_parts/nswc_part_06.f90#L9472) |
| `EIG1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [`L62288`](source_parts/nswc_part_06.f90#L9521) |


The subroutines EIG and EIG1 are available for computing the eigenvalues of real matrices. These routines frequently yield results accurate to 13~—14 significant digits. Indeed, for symmetric matrices they may give 2 or more digits better accuracy than the routines designed specifically for symmetric matrices. However, if the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur when the matrix is not symmetric. In this case one should not expect more than 7-8 digit accuracy.

```fortran
CALL EIG(IBAL, A, KA, N, WR, WI, IERR)
CALL EIG1(IBAL, A, KA, N, WR, WI, IERR)
```

A is a matrix of order n > 1 and WP,WI are real arrays of 2! ~ension n or larger. When £IG or EIG1 is called then the eigenvalues Ay, ...,A, of A are computed. The real parts of the eigenvalues are stored in WR(1), ...,.WR(n) and the imaginary parts are stored in WI(1), ...,WJ(n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue having the positive imaginary part being first.

IBAL and ka are input arguments. The argument ke is the number of rows in the dimension statement for A in the calling program. JBAL may be any integer. If IBAL #0 then the routines balance A before they compute the eigenvalues. Otherwise, if IBAL = 0 then A is not balanced.

**Error Return.** JERR is an integer variable. If all the eigenvalues are found then IERR is set to 0. Otherwise, if more than 30 iterations are required to compute the j** eigenvalue A,, then IERR is set to 7 and the routine terminates. In this case, if 7 < n then the eigenvalues Aj+1,-+-)An will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

(1) Even though the balancing operation does not increase the theoretical bounds on the errors, nevertheless at times it may result in a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy by as much as 5-6 significant digits. Thus it is recommended that balancing be done.

(2) a is destroyed during computation. EIG and EIG1 reduce A to upper Hessenberg form and then apply the QR algorithm to obtain the eigenvalues. They differ only in the choice of transformations used to reduce A to upper Hessenberg form. EIG employs elementary similarity transformations and EIG1i employs orthogonal similarity transformations. in theory the use of orthogonal transformations assures one of a tighter bound on che errors. However, since in practice matrices infrequently arise for which the orthogonal transformations actually generate more accurate results, and since the orthogonal transformations normally require more time than the elementary transformations, therefore EIG is the recommended routine.


<small>Original source: [View scanned PDF page 263](scans/page_0263.png)</small>

**Programming.** EIG and EIG1 are driver routines for the EISPACK. subroutines BALANCG, ELMHSO, ORTHES, and HQR. These subroutines were developed at Argonne National Laboratory. The functions SPMFPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., ct al., Matrix Eigensystem Routines - EISPACK Guide (Second Edition), Springer-Verlag, 1976.

ay we


<small>Original source: [View scanned PDF page 264](scans/page_0264.png)</small>

<a id="topic-264-01"></a>
### Computation of Eigenvalues and Eigenvectors of General Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `EIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [`L62337`](source_parts/nswc_part_06.f90#L9570) |
| `EIGV1` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [`L62429`](source_parts/nswc_part_06.f90#L9662) |


The subroutines EIGV and EIGV1 are available for computing the eigenvalues and eigenvectors of real matrices. These routines are extensions of the respective eigenvalue routines EIG and EIG1. Thus all comments made concerning the accuracy of the eigenvalues produced by EIG and EIGi apply also to EIGV and EIGV1. In particular, EIGV and EIGV1 can frequently yield high precision results for the eigenvalues if they are distinct. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue ia correct to within 2-3 units of the 14'* significant digit, but the components of the corresponding eigenvector are only accurate to 9-10 significant digits. In the case of repeated eigenvalues the situation regarding the eigenvectors is totally unpredictable. The components of such an eigenvector n-:y be correct to 6-7 significant digits, or the eigenvector may not even be an eigenvector! In this case the results should be checked.

```fortran
CALL EIGV(IBAL, A, KA, N, WR, WI, ZR, ZI, IERR)
CALL EIGV1(IBAL, A, KA, N, WR, WI, ZR, ZI, IERR)
```

A is a matrix of order n > 1 and WR, WI are real arrays of dimension n or larger. When EIGV or EIGV1 is called the eigenvalues Aj, ...,4,, and corresponding eigenvectors Z1,..-,2n are computed. The real parts of the eigenvalues are stored in WR(1), ...,WRin) and the imaginary parts are stored in WI(1),...,WI{n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue

having the positive imaginary part being first.

The input argument ka is the number of rows in the dimension statement for A in the calling program. ZR and ZI are real arrays of dimension ka Xn. For 7 = 1,...,n the real parts of the components of the eigenvector z; are stored in the jt" column of ZR (in locations YRUL7), ...,2R(n,7)) and the (imaginary parts are stored in the j*® column of ZL.

The eigenvectors z,;, ...,2, are na. normalized. l> ] Lay

IBAL is an input argument that can b2 assigned an- integer value. IY IBAL 3 9 chen the routines balance A before they compute the eigenvalues and eigenvectors. Otherwise, if IBAL - 0 then A is not balanced.

Error Return. HERR is an integer variable. If all the eigenvalues and eigenvectors are found then IEFRR is set te 0. Otherwise, if more than 36 iterations are required to compute the j' eigenvalue A;, then POKER is ect to g and the routine terminates. [iy this case, if ¢ <n then the eigenvalues A,41, ....A, will have been computed and the results stored in the WR and WI arrays. However, none of the eigenvectors will have been computed. The eigenvectors are computed only after all the eigenvalues have been obtained,

, aaa)


<small>Original source: [View scanned PDF page 265](scans/page_0265.png)</small>

Remarks,

(1) ven though the balancing operation does not increase the theoretical bounds on the

errors, nevertheless at times it may result in a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy of ‘he eigenvalues by as much as 5-6 significant digits. When this occurs balancing will normally be needed to obtain the eigenvectors. In general, 1 ig recommended that balancing be done.

A is destroyed during computation, EIGV and EIGVi both reduce A to upper Hessenberg form, apply the QR algorithm to the Hessenberg matrix to obtain the eigenvalues, and then backsubstitute to generate the eigenvectors. They differ only in the choice of transformations used to reduce A to upper Hessenberg form. EIGV employs elementary similarity transformations and E1G VY! employs orthogonal similarity transformations. In theory the use of orthogonal transformations assures one of a tighter bound on the errors. However, since in practice matrices infrequently arise fer which the orthogonal transformations actually generate more accurate results, and since the orthogonal transformations normally require more time than the elementary transformations, therefore HiGV is the recommended routine.

**Programming.** EIGV and EIGV1 are driver routines for the EISPACK subroutines BAL- ANC, HLMHSO, ORTHES, ELF RNO, ORTRAN, HQR2, and BALBAK. These subroutines were developed at Argonne National Laboratory. The functions SPiMPAR and TPMPAR are also weed,

Reference. Smith, BLT, Goyle, é. “., et al. Matrix Eigensystem Routines -- EISPACK

ad Edition}, Springer- Verlag, 1975.


<small>Original source: [View scanned PDF page 266](scans/page_0266.png)</small>

<a id="topic-266-01"></a>
### Double Precision Computation Of Eigenvalues Of Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DEIG` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, IERR` | [`L64232`](source_parts/nswc_part_07.f90#L874) |


The subroutine DEIG is available for the double precision computation of the eigenvalues of real matrices. This routine frequently yields results accurate to 26-28 significant digits. However, if the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect more than 13-14 digit accuracy.

```fortran
CALL DEIG(IBAL, A, KA, N, WR, WI, IERR)
```

A is a double precision matrix of order n > 1 and WR, WI are double precision arrays of dimension n or larger. When DEIG is called then the eigenvalues A,, ...,A, of A are computed. The real parts of the eigenvalues are stored in WR(1),...,WR(n) and the imaginary parts are stored in WI(1), ...,WI(n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue having the positive imaginary part being first.

IBAL and ka are input arguments. The argument ka is the number of rows in the dimension statement for A in the calling program. IBAL may be any integer. If IBAL # 0 then the routine balances A before it computes the eigenvalues. Otherwise, if IBAL = 0 then A is not balanced.

**Error Return.** TERR is an integer variable. if all the eigenvalues are found then IERR is set to 0. Otherwise, if more than 50 iterations are required to compute the 7‘ eigenvalue A,, then TERK is set to 7 and the routine terminates. In this case, if 7 < n then the eigenvalues Aj+is+-+yAn Will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

```text
(1) A is destroyed during computation.
(2) DEIG is a double precision version of the eigenvalue routine EIG1.
```

**Programming.** DEIG is a driver routine for the subroutines DBAL, DORTH, and DHQR. These subroutines are double precision versions of the EISPACK subroutines BALANC, ORTHES, and HOR, developed at Argonne National Laboratory. The double precision versions were prepared by A. H. Morris. The functions DPMPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matrix Eigensystem Routines — EISPACK Guide (Second Edition), Springer-Verlag, 1976.

Se qn on


<small>Original source: [View scanned PDF page 267](scans/page_0267.png)</small>

<a id="topic-267-01"></a>
### Double Precision Computation Of Eigenvalues And Eigenvectors Of Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DEIGV` | `SUBROUTINE` | `IBAL, A, KA, N, WR, WI, ZR, ZI, IERR` | [`L64281`](source_parts/nswc_part_07.f90#L923) |


The subroutine DEIGV +> available for the double precision computation of the eigenvalues and eigenvectors of real matrices. This routine frequently yields values for the eigenvalues that are accurate to 26-28 significant digits. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. i: the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect the eigenvalues to have more than 13-14 digit accuracy.

```fortran
CALL DEIGV(IBAL, A, KA, N, WR, WI, ZR, ZI, IERR)
```

A is a double precision matrix of order n > 1 and WR, WI are double precision arrays of dimension n or larger. When DEIGV is called then the eigenvalues \1,...,A, and corresponding eigenvectors 21, ...,Z, are computed. The real parts of the eigenvalues are stored in WR(t),...,WR(n) and the imaginary parts are stored in Wi(1), ...,WI(n). The eigenvalues are unordered except that complex conjugate pairs of eigenvalues appear consecutively with the eigenvalue having the positive imaginary part, being first.

The input argument. ka is the number of rows in the dimension statement for A in the calling program. ZR ond ZI are double precision arrays of dimension ka x n. For J = 1,...,n the real vars: of the components of the eigenvector z,; are stored in the 7*h column of ZR (in locations ZR(i,7), ...,% R(n,7)) and the imaginary parts are stored in the

j** column of ZI. The eigenvectors 21, ...,Z, are not normalized.

IBAL is an input argument that can be assigned any integer value. If If AL # O then the routine balances A before it computes the eigenvalues and eigenvectors. Otherwise, if IBAL = 0 then A is not balanced.

**Error Return.** JERR is an integer variable. If all the eigenvalues and eigenvectors are found then IERR is set to 0. Otherwise, if more than 50 iterations are required to compute the 7*? eigenvalue 4;, then IERR is set to 7 and the routine terminates. In this case, if 7 <n then the eigenvalues A,41, ...,A, will have been computed and the results stored in the WR and WI arrays. However, none of the eigenvectors will have been computed. The eigenvectors are computed only after all the eigenvalues have been obtained.

**Remarks.**

```text
(1) A is destroyed during computation.
(2) DEIGY is a double precision version of the elgenvalue/-igenvector routine BIG VIL.
```


<small>Original source: [View scanned PDF page 268](scans/page_0268.png)</small>

**Programming.** DEIGV is a driver routine for the subroutines DBAL, DORTH, DORTRN, DHQR2, and DBABK. These subroutines are double precision versions of the EISPACK routines BALANC, ORTHES, ORTRAN, HQR2, and BALBAK, developed at Argonne National Laboratory. The double precision versions were prepared by A. H. Morris. The functions DPMPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matréz Eigensystem Routines - EISPACK Guide (Second Edition), Springer-Verlag, 1976.


<small>Original source: [View scanned PDF page 269](scans/page_0269.png)</small>

<a id="topic-269-01"></a>
### Computation Of Eigenvalues Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [`L65711`](source_parts/nswc_part_07.f90#L2353) |
| `SEIG1` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [`L65732`](source_parts/nswc_part_07.f90#L2374) |


The subroutines SEIG and SEIGt are available for computing the eigenvalues of symmetric real matrices. These routines frequently yield high precision results, SIG is faster than SEIG1, but at times SEIG1 will produce better results when the symmetric matrix is tridiagonal. For arbitrary symmetric matrices it is not clear if there is any difference ia the reliability of the routines.

```fortran
CALL SEIG(A, KA, N, W, T, IERR)
CALL SEIG1(A, KA, N, W, T, IERR)
```

A is a symmetric matrix of order n > | and W an array of dimension n or larger. When SEIG or SEIG1 is called the eigenvalues A,,...,A, are computed and stored in W(1),...,W(n). The eigenvalues are ordered so that Ay < +--+ < X,.

A may be packed or in standard form.) The input argument ka is a nonnegative

integer. If ka =O then A is assumed to be packed. Otherwise, if ka 4 0 then A is assumed to be in the standard format. In this case ka has the value:

ka = the number of rows in the dimension statement for A in the calling program It is assumed that ka > n. However, it is not r ju ved that A(#,7) be defined for i < J. Only the lower triangular ele: ts of A are used.

T is an array used for temporary storage. If SEIG is called then T must be of dimension 2n. However, if SEIG1 is called then 7 need only be of dimension n.

Error Return. [ERR is an integer variable. Ii all the eigenvalues are found then IERR is set to 0, Otherwise, if more than 30 iterations of the QL algorithm are required to compute the 7" eigenvalue A;, then TERR is set to 7. In this case, if 7 > 1 then the eigenvalues At, ..-,Ayz--1 will have been computed and stored ia W. The eigenvalues are ordered so that Ay < ++: < A;_1. However, they need not be the smallest eigenvalues of A.

**Remark.** A is destroyed during computation.

**Programming.** SEIG and SEIG1 are driver routines for the EISPACK subroutines TRED1, TRED3, TQLRAT, aid IMTQL1. ‘These subroutines were developed at Argonne National Laboratory. The function SPMPAR is also used.

**Reference.** Smith, B. T., Boyle, J. M., et ., Matrix Kigensystem Routines - EISPACK Guide (Second Edition), Springer-Verlag, 1976.

TRor details othe parked format see the section on packing acl umpe oo symmetric ¢oatrices

3OG


<small>Original source: [View scanned PDF page 270](scans/page_0270.png)</small>

<a id="topic-270-01"></a>
### Computation Of Eigenvalues And Eigenvectors Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [`L65779`](source_parts/nswc_part_07.f90#L2421) |
| `SEIGV1` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [`L65813`](source_parts/nswc_part_07.f90#L2455) |


The subroutines SEIGV and SEIC: Vi are available for computing the eigenvalues and eigenvectors of symmetric real matrices. These routines frequently yield high precision results for the eigenvalues. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue is correct to within 2-3 units of the 14'* significant digit, but the components of the corresponding eigenvector are only accurate tc 9--10 significant digits. SEIGV is faster than SEICVI1, but at times SEIGV1 will produce better results when the symmetric matrix is tridiagonal. For arbitrary symmetric matrices it is not clear if there is any difference in the reliability of the routines.

```fortran
CALL SEIGV(A, KA, N, W, Z, T, IERR)
CALL SEIGV1(A, KA, N, W, Z, T, IERR)
```

Ais asymmetric matrix of order n > 1 and W an array of dimension n or larger. When SEIGV or SEIGV1 is called the eigenvalues Ay, ...,A, and corresponding orthonormal eigenvectors z,,...,2, are computed. The eigenvalues are stored in W(1)},...,W(n) and are ordered so that Ay <--- < Ay.

A must ve in the standard format, having the dimension ka x n. It is assumed that ka > n. However, it ‘s not required that A{i,,s) be defined for: < 7. Only the lower triangular elements of A are used.

4 is an array of dimension ka X n or larger. For 7 = 1, ...,n the components of the eigenvector z; are stored in the jt* column of Z (in locations Z(1,9), ...,Z(n,7)). To conserve memory one may let A and Z denote the same array.

T is an array of dimension 1 used for temporary storage.

**Error Return.** [TERR is an integer variable. If all the eigenvalues and eigenvectors are found then IEFRR is set to 0. Otherwise, if more than 3U iterations of the QL algorithm are required to compute the j‘ eigenvalue A,, then TERR is set to 7. In this case, if 7 > 1 then the eigenvalues 4,,...,A,~1 and eigenvectors z,,...,2;.1 Will have been computed and stored in the W and Z arrays. However, the eigenvalues will be unordered.

**Remark.** A is not modified except when A and 4 denote the same array. Programming. SEIGV and SEICVi are driver routines for the EISPACK subroutines TRED2, TQL2, and IMTQL2. These subroutines were developed at Argonne National

Laboratory. The function SPMPAR is also used.

**Reference.** Smith, BoOP., Boyle, J. M., et al., Matrix Eigensystem Routines EISPACK Guide Second Edition), Springer-Verlag, 1976.


<small>Original source: [View scanned PDF page 271](scans/page_0271.png)</small>

<a id="topic-271-01"></a>
### Double Precision Computation Of Eigenvalues Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DSEIG` | `SUBROUTINE` | `A, KA, N, W, T, IERR` | [`L66892`](source_parts/nswc_part_07.f90#L3534) |


The subroutine DSEIG is available for the double precision computation of the eigenvalues of symmetric real matrices. The subroutine frequently yields results accurate to 27-28 significant digits.

```fortran
CALL DSEIG(A, KA, N, W, T, IERR)
```

A is a double precision symmetric matrix of order n > 1 and W a double precision array of dimension n or larger. When DSEIG is called the eigenvalues \1, ...,A,, are computed and stored in W(i),...,W(n). The eigenvalues are ordered so that \y < +++ < An.

A may be packed or in standard form.! The input argument ka is a nonnegative

integer. If ka =O then A is assumed to be packed. Otherwise, if ka 4 0 then A is assumed tu be in the standard format. Ia this case ka has the value: ka = the number of rows in the dimension statement for A in the calling program

It is assumed that ko > n. However, it is not required that A(t, 7) be defined for 1 < 7. Only the lower triangular elements of A are used.

T is a double precision array of dimension 2n or larger that is a work space for the routine,

**Error Return.** IERR is an integer variable. If all the eigenvalues are found then IERR is set to 0. Otherwise, if more than 50 iterations of the QL algorithm are required to compute the j*® eigenvalue 4,;, then IERR is set to 7. In this case, if 7 > 1 then the eigenvalues Ay,..-,A;—1 Will have been computed and stored in W. The eigenvalues are ordered so that Ay < +++ < Ay_1. However, they need not be the smallest eigenvalues of A.

**Remarks.** (1) A is destroyed during computation.

(2) DSEIG is a double precision version of the eigenvalue routine SEIG.

**Programming.** DSEIG is a driver routine fur the subroutines DT REDI, DIT REDS, and DTQC. These subroutines are double precision versions of the EISPACK routines TRED I, TRED3, and TQLRAT, developed at Argonne National Laboratory. The double precision versions were prepared by A. H. Morris. The function DPMPAR is also used.

**Reference.** Smith, 8. 'P., Boyle, J. M., et at, Matrix Eigensystem Routines EISPACK Guide (Second Edition), Springer-Verlag, 1976. Mor tals um che packed crmat vee the section ou packing and unpacking symmetric matrices.


<small>Original source: [View scanned PDF page 272](scans/page_0272.png)</small>

<a id="topic-272-01"></a>
### Double Precision Computation Of Eigenvalues And Eigenvectors Of Symmetric Real Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DSEIGV` | `SUBROUTINE` | `A, KA, N, W, Z, T, IERR` | [`L66914`](source_parts/nswc_part_07.f90#L3556) |


The subroutine DSEIGV is available for the double precision computation of the eigenvalues and eigenvectors of symmetric real matrices. This subroutine frequently yields values for the eigenvalues that are accurate to 26-28 significant digits. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue is correct to within 2-3 units of the 28" significant digit, but the components of the eigenvector are only accurate to 22-24 significant digits.

```fortran
CALL DSEIGV(A, KA, N, W, Z, T, IERR)
```

A is a double precision symmetric matrix of order n > i, and W a double precision array of dimension n or larger. When DSEIGV is called the eigenvalues \1,...,An and corresponding eigenvectors z1,...,Z, are computed. The eigenvalues are stored in W(1),...,W(n) and are ordered so that Ay < +++ < Ag.

A must be in the standard format, having the dimension ka x n. It is assumed that ka > n. However, it is not required that Aft,j) be defined for 1 < 7. Only the lower triangular elements of A are used.

2 is a double precision array of dimension ke xn or larger. For j = 1, ...,n the components of the eigenvector z, are stored in the j'" column of Z (in locations Z(1,7), ...,Z(n,J)).

‘To conserve memory one may let A and Z denote the same array.

T is a double precision array of dimension mn or larger that is a work space for the routine.

Error Return. TERR is an integer variable. If a!l the eigenvalues and eigenvectors are found then IERR is set to 0. Otherwise, if more than 50 iterations of the QL algorithm are required to compute the 7'" eigenvalue A;, then IERR is set to 7. In this case, if 7 > 1 then the eigenvalues A,,...,A,., and eigenvectors z,,...,2;..1 will have been computed and stored in the W and Z arrays. However, the eigenvalues will be unordered.

```text
Remarks.
(1) Ais not modified except when A and Z denote the same arcay.
(2) DSEIG V is a double precision version of the eigenvalue /eigenvector subroutine SHEIGV,
```

Programming. DSEIGV as a driver routine for the subroutines D'PRED2 and DTQLY.

T: ese subroutines are double precision versions of the KISPACN subroutines PRED? and

TPQL2 developed at Argonne National Laboratory. The double precision versions were prepared by A. HL. Morris. The function DPMPAR is also used.

**Reference.** Sruth, 8. T., Boyle, Jo Mo, et al, Matrix Eigensystem Routines EISPACK Gute (Second Edition), Springer-Verlag, Love


<small>Original source: [View scanned PDF page 273](scans/page_0273.png)</small>

<a id="topic-273-01"></a>
### Computation Of Eigenvalues Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [`L67676`](source_parts/nswc_part_07.f90#L4318) |


The subroutine CEIG is available for computing the eigenvalues of complex matrices. This routine frequently yields results accurate to 13-14 significant digits. However, if the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect more than 7-8 digit accuracy.

```fortran
CALL CEIG(IBAL, AR, AI, KA, N, WR, WI, IERR)
```

AR and AI are real matrices of order n > 1, and WR and WI are real arrays of dimension n or larger. AR and Al are the real and imaginary portions of the complex matrix whose eigenvalues are to be computed. When CEIG is called the eigenvalues 41, ...,An are computed. The real parts of the eigenvalues are stored in WR(i),...,WR(n) and the imaginary parts ace stored in WI{1), ...,WI(n). The eigenvalues are unordered.

IBAL and ka are input arguments. It is assumed that ka is the number of rows in the dimension statements for AR and AI in the calling program. IBALL may be any integer. If IBAL 4 0 then the complex matrix (represented by AR and AJ) is balanced before the eigenvalues are computed. Otherwise, if IBAL = 0 then the complex matrix is not balanced.

**Error Return.** JERR is an integer variable. if all the eigenvalues are found then IERR is set tc 0. Otherwise, if more than 30 iterations are required to compute the j*" eigenvalue 4,, then IERR is set to 7 and the routine terminates. In this case, if 7 < n then the eigenvalues

Aj41)+++)An will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

(1) Even though the balancing operation does not increase the theoretical bounds on the errors, nevertheless at. times it may result in a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy by as touch as 5-6 significant digits. Thus it is recommended that balancing be done.

(2) AR and Al are destroyed during computation. CEIG reduces the complex matrix (represented by AR and Al) to upper Hessenberg form with unitary similarity transformations. Then the QR algorithm is used to obtain the eigenvalues.

Usage. If one has a complex matrix A, then AR sad lean be obtained using the matrix subroutines CMREAL and CMIMAG,

**Programming.** ClEIG is a driver routine for the EISPACK subroutines CBAL, CORTE and COMQR. These subroutines were developed at Argonne National Laboratory. ‘The functions SPMPAR and IPMPAR are also used,

**Reference.** Suuth, BoP, Boyle, do Moyet al. Matrix Eigensystem Routines EISPACK

trurde (Second Edition), Springer Verlag, £6


<small>Original source: [View scanned PDF page 274](scans/page_0274.png)</small>

<a id="topic-274-01"></a>
### Computation Of Eigenvalues And Eigenvectors Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [`L67729`](source_parts/nswc_part_07.f90#L4371) |


The subroutine CEIGV is available for computing the eigenvalues and eigenvectors of complex matrices. This routine frequently yields values for the eigenvalues that are accurate to 13-14 significant digits. However, be aware that errors in the eigenvalues, no matter how seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. It is not at all unusual to obtain an eigenvalue and eigenvector where the eigenvalue is correct to within 2-3 units of the 14** significant digit, but the components of the corresponding eigenvector are only a-curate to 9-10 significant digits. If the eigenvalues of a matrix are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect the eigenvalues to have more than 7-8 digit accuracy, and the situation regarding the eigenvectors is totally unpredictable. The components of such an eigenvector may be correct to 6-7 significant digits, or the eigenvector may not even be an eigenvector! In this case the results should be checked.

```fortran
CALL CEIGV(IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP)
```

AR and AI are real matrices of order n > i and WR and WI are real arrays of dimension n or larger. AK and Al are the real and imaginary portions of the complex matrix whose eigenvalues and eigenvectors are to be computed. When CEIGV is called the eigenvalues Aj, ...,A, and corresponding eigenvectors z,,...,2, are computed. The real parts of the eigenvalues are stored in WR(1), ... W&(m) and che imaginary parts are stored in WI(1),...,WI(n). The eigenvalues are unordered.

(tis assumed that the input argument ka is the number of rows in the dimension statements for AR and Al in the calling program. ZR and Al are real arrays of dimension

ka xn, For j= 1,...,n the real parts of the components of the eigenvector z, are stored in the jt? column of ZR (in locations ZR(1,7), ...,ZR(n,7)) and the imaginary parts arc stored in the gj" column of ZI. ‘The eigenvectors 2, ...,¢, are not normalized.

IBAL is an input argument that can be assigned any integer value. If ISAL / 0 then the complex matrix (represented by AR and Al) is balanced before the eigenvalues and eigenvectors are computed. Otherwise, ff EBAL 0 then the complex matrix is not

balanced.

EMP is a real array used for temporary storage by the routine. Pf no balancing is tc be done (Le, if IBALL 0) then TEMP must be of dimension 2n or larger. Otherwise, if

balancing is to be performed then TREMP must be of dimension On or larger.

Error Return. He Rois an integer variable. Uf ail the eigenvalues and eigenvectors are found then HERR is set to 0. Otherwise, if mice than 30 iterations are required Co compute they! eigenvalue A), then TERR is set tog and the routine terminates. In this case, uy > on then the eigenvalues Ay, 4,000.4, will have been computed and the results stored up the WER aid Wi arrays However, none of the eigenvectors will have been computed. The eigenvectors

are computed only after all (he eigenvalues have been obtained

Sana


<small>Original source: [View scanned PDF page 275](scans/page_0275.png)</small>

**Remarks.**

(1) Even though the balancing operation does not increase the theoretical bounds on the errors, nevertheless at times it may result i: a slight loss of accuracy. On the other hand, balancing requires little additional time and in certain cases can improve the accuracy of the eigenvalues by as much as 5-6 significant digits. When this occurs balancing will normally be needed to obtain the eigenvectors. In general, it is recommended that balancing be done.

(2) AR and AI are destroyed during computation. CEIGV reduces the complex matrix (represented by AR and AI) to upper Hessenberg form with unitary similarity transformations. Then the QR algorithm is employed to obtain the eigenvalues, and backsubstitution is performed to generate the eigenvectors.

Usage. lf one has a complex matrix A, then AR and AI can be obtained using the matrix subroutines CMREAL and CMIMAG.

**Programming.** CEIGV is a driver routine for the EISPACK subroutines CBAL, CORTH, COMQR2, and CBABK2. These subroutines were developed at Argonne National Laboratory. The functions SPMPAR and IPMPAR are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matrix Eigensystem Routines — EISPACK Guide (Second Edition), Springer-Verlag, 1976.


<small>Original source: [View scanned PDF page 276](scans/page_0276.png)</small>

<a id="topic-276-01"></a>
### Double Precision Computation Of Eigenvalues Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DCEIG` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, IERR` | [`L68903`](source_parts/nswc_part_07.f90#L5545) |


The subroutine DCEIG is available for the double precision computation of the eigenvalues of complex matrices. This routine frequently yields results accurate to 26-28 significant digits. However, if the eigenvalues are not distinct ur if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect more than 13-14 digit accuracy.

```fortran
CALL DCEIG(IBAL, AR, AI, KA, N, WR, WI, IERR)
```

AR and AI are double precision matrices of order n > 1, and WR and WI are double precision arrays of dimension n or larger. AR and AI are the real and imaginary parts of the matrix whose eigenvalues are to be computed. When DCEIG is called the eigenvalues Ay, ---,)An, are computed. The real parts of the eigenvalues are stored in WR(!), ..., WR(n) and the imaginary parts are stored in WI(1),..., WI(n). The eigenvalues are unordered.

IBAL and ka are input arguments. It is assumed that ka is the number of rows in the dimension statements for AR and AI in the calling program. IBAL may be any integer. If IBAL ¥ 0 then the complex matrix {represented by AR and Al) is balanced before the eigenvalues are computed. Otherwise, if IBAL == 0 then the complex matrix is not balanced.

**Error Return.** IERR is an integer variable. If all the eigenvalues are found then IERR is set to 0. Othe wise, if more than 50 iterations are required to compute the jt eigenvalue A}; then IERR is set to 7 and the routine terminates. In this case, if 7 <n then the eigenvalues Ajy41)---,An will have been computed and the results stored in the WR and WI arrays.

**Remarks.**

```text
(1) AR and AT are destroyed during computation.
(2) DCEIG is a double precision version of the eigenvalue routine CEIG.
```

**Programming.** DCEIG is a driver routine for the subroutines DCBAL, DCORTH, and DCOMAQR. These subroutines are double precision versions of the EISPACK subroutines CBAL, CORTH, and COMQR, developed at Argonne National Laboratory. The double precision versions were prepared by A Ho Morris. The functions DCPABS, DPMPAR, IPMPAR and subroutine DCSQRT are also used.

**Reference.** Sruth, Bo T., Boyle, Jo Mo. et al, Matrix Eigensystem Routines EISPACK Guide (Second Edition), Springer Verlag, EQ76


<small>Original source: [View scanned PDF page 277](scans/page_0277.png)</small>

<a id="topic-277-01"></a>
### Double Precision Computation Of Eigenvalues And Eigenvectors Of Complex Matrices

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DCEIGV` | `SUBROUTINE` | `IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP` | [`L68957`](source_parts/nswc_part_07.f90#L5599) |


The subroutine DCEIGV is available for the double precision computation of the eigenvalues and eigenvectors of comp!ex matrices. The routine frequently yields values for the eigenvalues that are accurate to 26-26 significant digits However, be aware that the errors in the eigenvalues, no matter bow seemingly insignificant, can be considerably magnified in the computation of the eigenvectors. If the eigenvalues are not distinct or if they are exceedingly tightly clustered, then a severe drop in accuracy can occur. In this case one should not expect the eigenvalues to have more than 13-14 digit accuracy.

```fortran
CALL DCEIGV(IBAL, AR, AI, KA, N, WR, WI, ZR, ZI, IERR, TEMP)
```

AR and AI are double precision matrices of order n > 1 and WR and WI are double precision arrays of dimension n or larger. AR and AI are the real and imaginary portions of the complex matrix whose eigenvalues and eigenvectors are to be computed. When DCEIG V is called the eigenvalues A,, ....A, and corresponding eigenvectors z), ...,Z,, are computed. The real parts of the eigenvalues are stored in WR(1),..., WR(n) and the imaginary parts are stored in WI(!),...,WI(n). The eigenvalues are unordered.

It is assumed that the input argument ka is the number of rows in the dimension statements for AR and AI in the calling program. ZR and ZI are double precision arrays of dimension ka x n. For 7 ~ 1, ...,n the real parts of the components of the eigenvector z, are stored in the 7*" column of ZR (in locations ZR(1, 7), ...,2R(n,j)) and the imaginary ports are stored in the jt? column of ZI. The eigenvectors z;,...,2, are not normalized.

IBAL is an input argument that can be assigned any integer value. If IBAL 7 0 then the complex matrix (represented by AR and Al) is balanced before the eigenvalues and eigenvectors are computed. Otherwise, if IBAL -= 0 then the complex matrix is not balanced.

TEMP is a double precision array used for temporary storage by the routine. If no balancing is to be done (ie., if IBAL 0) then TEMP must be of dimension 2n or larger. Otherwise, if balancing is to be performed then TEMP must be of dimension 3n or larger

**Error Return.** [EPR is an integer variable. If all the eigenvalues and eigenvectors are found then TERR 1s set to O. Otherwise, if more than 50 iterations are required to compute the j'? eigenvalue A,, then TERR is set to 7 and the routine terminates. In this case, if 7 <n then the eigenvalues A,41, -..,An will have been computed and the results stored in the WR and WI arrays. However, none of the eigenvectors will have been computed. The eigenvectors

are computed only after all the eigenvalues have been obtained

Remarks (1) AK and Al are destroyed during computation.

(2, DRCRIO Vos a double precision version of the eigenvalue/eigenvector routine ORIG V


<small>Original source: [View scanned PDF page 278](scans/page_0278.png)</small>

gramming. DCEIGV is a driver for the subroutines DCBAL, DCORTH, DCMQR2,

. DCBABK. These subroutines are double precision versions of the EISPACK routines CUAL, CORTH, COMQR2, and CBABK2, developed at Argonne National Laboratory. ‘ne double precision versions were prepared by A. H. Morris. The functions DCPABS, DPMPAR, IPMFAR anc subroutine DCSQRT are also used.

**Reference.** Smith, B. T., Boyle, J. M., et al., Matrix Eigensystem Routines — EISPACK Guide (Second Edition), Springer-Verlag, 1976.


<a id="category-279"></a>
## L1 Solution of Linear Equations

<small>Original source: [View scanned PDF page 279](scans/page_0279.png)</small>

<a id="topic-279-01"></a>
### L1 Solution Of Systems Of Linear Equations With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CL1` | `SUBROUTINE` | `K, L, M, N, Q, KQ, KODE, TOLER, ITER, X, RES, ERROR, WK, IWK` | [`L70154`](source_parts/nswc_part_07.f90#L6796) |


Let Abeakxn matrix, C an éxn matrix, and “an mxn matrix. Also let b,d, and f be column vectors of dimensions hk, @, and mm respectively. The following subroutine is available for obtaining a column vector of dimension n which minimizes || Ax -- b||) = > |A,x — 6! ead subject to the constraints

Here A; denotes the i*" row of A, and Hx < f means that every component of Ez is less than or equal to the corresponding component of f. CALL CL1(k, 6, m,n, Q,kq, KODE,TOL,ITER, X, RES,RNORM,WK,IWK)

It is assumed that k > 1,8 > 0,m ~~ 0, and n> 1. Q is a 2-dimensional array with kg rows and at least n -+- 2 columns where kg > k+ &+m4+2. The matrices A,C, © and vectors 6,d, f are stored in the first k + @+ m rows and n+ 1 columns of Q as follows:

Ab" Q=;1C a hf

Q is modified by the routine.

KODE is a variable used for input/output purposes, X an array of dimension n+ 2 or larger, and RES an array of dimension k + @+ m or larger. On input KODE is normally set by the user to 0. This indicates that ||Azx -~ 8]; is to be minimized subject only to the constraints Cz = d and Er < f. However, if it is also desired that one ar move variables x, satisfy x; < 0 or x; > O, or that one or more residuals 6; ~ A,z satisfy b; ~ Ayz < 0 or

b, - Aya > G, then the user may set KODE to a nonzero value. if KODE 4 O on input, then the user must also set X(j}) and RES(t) to the values

{-10 2, <0 X(j) > 0.0 2; is unrestricted 1.0 2;>0 { 10 b> Aya <0 RESG) 0.0 6 Aya is unrestricted

iO b&b Ayr > 0 for gy ook, ym anda co J,...,k to indicate the additional constraints which are desired,

INCOM is a variable When Ch} os called. if a vector gis found that minimizes HAs bl subject to the desired constraints, then ROOR © Quon output and the solution 4


<small>Original source: [View scanned PDF page 280](scans/page_0280.png)</small>

is stored in X. Also RNORM is assigned the value ||Az — 4||},6 — Az is stored in the first k locations of RES, ¢ - Cx is stored in the next @ locations, and f — Ex is stored in the last m locations.

When CLI is called, a modified form of the simplex algorithm is used to minimize ||Az ~ b||,. The arguments TOL and ITER control the use of this algorithm. The input argument TOL is a positive tolerance. CLi will not pivot on any quantity whose magnitude is less than TOL. Normally the setting TOL = 10~?”/* suffices where v is the number of decimal digits of accuracy available.

Frequently the routine requires less than 5(k+é+m) iterations of the simplex algorithm to solve the problem. ITER is a variable used for input/output purposes. On input the user must set ITER to the maximum number of iterations that will be permitted. When the routine terminates, ITER has for its value the number of iterations that were performed.

On output KODE reports the status of the results. The routine assigns KODE one of the following values:

KODE = 0 The problem was solved.

KODE = 1 The problem has no solution.

KODE = 2 Sufficient accuracy cannot be maintained to solve the problem using the current value of TOL.

KODE = 3 The maximum number of iterations were performed. More iterations are needed.

When KODE > 1 on output, X contains the last vector = which was obtained, RNORM = ||Az — b||,, and RES contains the vectors b — A#,d— Cz, and f ~ Fi.

WK is an array of dimension 2(k + £+ m-+n) or larger, and IWK 1s an array of dimension 3(k + @+ m) + 2n or larger. WK and IWK are work spaces for the routine.

**Programming.** ClL1 calls the subroutine KL1. CL was written by I. Barrodale and F. D. K. Roberts (University of Victoria, British Columbia, Canada).

**References.**

(1) Barrodale, I. and Roberts, #. D. K., “An Improved Algorithm for Discrete @; Linear Approximation,” SIAM J. Numer. Analysis 10 (1973), pp. 839 848.

```text
(2) “An Efficient Algorithm for Discrete £; Linear Approximation with Linear
Constraints, » SIAM J. Numer. Analysts 15 (1978), pp. 603 611,
(3)  , “Algorithm 552, Solution of the Constrained @,; Linear Approximation
```

Problem,” ACM Trans. Math Software 6 (1980), pp. 231-235.


<a id="category-281"></a>
## Least Squares Solution of Linear Equations

<small>Original source: [View scanned PDF page 281](scans/page_0281.png)</small>

<a id="topic-281-01"></a>
### Least Squares Solution Of Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [`L70630`](source_parts/nswc_part_07.f90#L7272) |
| `LSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [`L71322`](source_parts/nswc_part_07.f90#L7964) |
| `HFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [`L73899`](source_parts/nswc_part_08.f90#L1) |
| `HFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [`L74175`](source_parts/nswc_part_08.f90#L277) |


Given an m X n matrix A and an mx @ matrix B. The column vectors b;,..., 6, of B specify @ distinct linear least squares problems

This set of problems can be written in the form AX = B where X is the n x @ matrix having the column vectors z1, ...,2¢. There always exists 4 unique minimum length least squares solution 2, for each Ar; = b;. If B is the m x m identity matrix, then the matrix whose columns are the minimum length solution vectors z; is called the pseudoinverse of A.

For any B, the subroutines LLSQ, LSQR, HFTI, and HFTI2 are available for obtaining the matrix X whose columns are the minimum length solution vectors. LSQR, HFTi, and HFTI2 are more general than LLSQ, begin able to solve arbitrary systems AX = B. LLSQ assumes that m > n > 1 and that the rank of A is n. LSQR employs a more involved procedure than HFTI and HFTI2. LSQR computes the rank of A, whereas HFTI and HFTI2 leave the determination of the rank to the user.

```fortran
CALL LLSQ(M, N, A, KA, B, KB, NB, WK, IWK, IERR)
```

It is assumed that m > n > 1 and that the rank of Ais n. The input arguments ka and k6 have the following values:

ka = the number ai rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement for B in the calling program It is required that ka > m and kb > m.

```text
IERR is an integer variable. When LLSQ is called, if no input errors are detected then
IERR is set to 0 and the solution matrix X stored in B. Also, if m #n then the residual
norm || Az, -- 6;{|| is computed and stored in B(n-+ 1,7) for gj = 1,..., 83
```

WK and IWK are arrays of dimension n or larger that are work spaces for the routine.

**Error Return.** (ERR 4 O when m > n> 1 is not satisfied (IERR > 1) or the rank of A ts less than n (IERR © 2).

**Note.** A is destroyed during computation.

**Programming.** LLSQ ts a driver for the subroutines ORTHO and ORSOL, written by Nai- Kuan Tsao and Paul J. Nikolai (Aerospace Research Laboratories, Wright-Patterson Air Force Base).

**Reference.** ‘Tsao, N. Ko and Nikola, P. J., Procedures using Orthogonal Transformations for Linear Least Squares Problems, Report ARL PR 74-0124, Aerospace Research Laboratories, Wright-Patterson Air Force Base, [97-4

{Throughout this section fief; Sie far any vector Che ce Say de g eh \ : y Leds uv

vid ode


<small>Original source: [View scanned PDF page 282](scans/page_0282.png)</small>

CALL LSQR(MO,A, ka, m,n, B, kb, 6RERR,AERR,k,ko, RNORM, WK ,éw, [WK fiw TERR)

MO is an argument which specifies if LSQR is being used for the first time. On an

Ais an m xn matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ka > m. A is destroyed by the routine.

The argument @ is an integer. I’ 2> 1 then B is an m x € matrix and kb is the number of rows in the dimension statement jor B in the calling program. Also, RNORM is an array of dimension @ or larger (for output). It is required that kb > max{m,n}. If @ < 0 then there are no equations to be solved, and B, kb, and RNORNA are not used.

RERR is an argument which specifies the relative accuracy of the data in A. If it is estimated that the elements in A ar: accurate to p significant decimal digits then one may set RERR = 1074. It is required that RERR > 0. If RERR = 0 then it is assumed that the elements in A are accurate to m ‘chine precision.

AERR is an argument which specifies the maximum absolute uncertainty of the data in A. For example, jf it is estimated that the elements a,; of A have the relative accuracy RERR except when |a,;| < 107°°, then one may set AERR = 107~*°. It is required that AERR > 0.

The arguments k, kj, and IERR are variables. When LSQR is called, if no input errors are detected then IERR is set to O and the rank of .4 is bounded from above and below using the tolerances RERR and AERR. The variable k is set. to the upper bound and ky to the lowe: bo. nd. If @ > 1 then the n x @ matrix X whose columns are the minimum length solution vectors is computed (using k as the rank) and stored in B. Also, the residual norm A: 6 || is computed and stored in RNORM()) for j = 1, ...,2.

WK is cn array of dimension fw where @w > S- min{m,n}. and EWK is an array of dimension rw where fiw > em fon. WK and IWh are work spaces for the routine,

**Error Return.** (ERR is as signed one of the following values where au error is detected:

TERR os fom < bor) <0. IFRR = 3 ka < mi.

Lo 2R 0 S kbs maxicu,n} TERR «4 fru orm fom.

TERR © 5

HeRE 6 RERR or AdeacR os negative. FIERRO 7 MO / Oand #- 0.

fwoas too small.

No computation is performed when an error is detected

After an initial o all to LSQER. if TERR Oo then the routine aisy be cable fw N,

POO. In this onse af gs assumed that only GO has been modified and fiat the aes


<small>Original source: [View scanned PDF page 283](scans/page_0283.png)</small>

equations AX = 2 are to be solved. The routine employs the Householder factorization of A stored in A, WK, and [WK 9n the initial call to LSQR.

When MO # 0, it is assumed that A,ka,m,jn,/. VK, and éw have not been modified by the user. If k ==: 0 or & == min{rm,n} then only th. first min{m,n} elements of WK are needed and one may sot fw > min} m,n}. Otherwise, it is required that éw > 2-min{m, n}.

RERR, AERR, and kp are not used when MO + 0. The only assumptions concerning the new 8, kb, and ? are that &b > max{m,n}, @ > 1, and the dimension cf RNORM is now the nev value of € When LSQR is called, if no input errors are detected then IERR is set. to O and the new solution matrix X obtained. As before, X is stored in B and the residual norms are computed and stored in RNORM.

**Remarks.**Normally ko = £ in which case & is the rank of 4. However, if ko # & then it is recommended that Ho Vi be used for obtaining the most appropriate value for the rank and solving (4 = B. WOITETES 3 used, the sizes of the elements of the solution matrix X should be considered (in addition to the values of the residual norms). Frequently, the lower bound &y will be found te be the most appropriate value for the rank.

Programming. GSQR employs the subroutines JIILS, ULZLS, ULLUS, U1208, [SWAP, SSWAP, SAXPY, SSCAL and functions SNOT, SNRM2, ISAMAX, SPMPAR, IPMPAR. LSOR was written by A. H. Morris and Utils, U1208, O1LUS5, UL2US were written by T. Manteuffel (1.08 Alamos).

References. *& anteuffel, T., An Interval Analysts Approach to Rank Determination in Linear Least Squares Problems, Report SAND 80-0655, Sandia Laboratories, Albuquerque, New Mexico, 1980.

CA HETICA, ka, sin, 8, kb, 27, kJ RNORD! GIP) CR.) HETI2(A, ka, m,n, 8, kb, 2, D7, kRNORM, 1G IPLERR)

yas ae. ont matrix where ion * 1) and Aa ois the number of rows in the dimension

staboameatiar ¢ a the calling program, It is required that &uco> rn The argument @ ais an integer. Wo @ > fd then 8 is an om x @ matrix and &f is the

dioathers cows in the dimension statement for Bin the calling program. Htas required that ko ong) aomd. iff « O then t cre are no equations te be solved, and ff and kd are not

bP then RNORN an array of dimension &@ or larger Otherwise, if & O then

RN EM oncsed. When GE Tbor HET is called, af 0 then the na @rmatria whose heat cok ff minimum length solution vectors is computed acd stored am J Aisa, the bof eG) is eotopaated dd stored ip RING Ay) Bop po dF

ceecarrays of dimension on os bargee hot are work spaces For the routine:

three aoe tee and 2)

ae mow a tolerance That rs cet by the user os sortable and f)oan siray f


<small>Original source: [View scanned PDF page 284](scans/page_0284.png)</small>

dimension win{m,n} or larger. It is assumed that r > 0. Normally 7 = 0 is the setting that is used. D and & are set by the routings.

In order to understand the use of r,k, and D one must be briefly acquainted with the processing of .4. The routines first reduce A to a triangular matrix C where A = QCP. Q is an orthogonal matrix and FP a permutation matrix. P is defined so that the diagonal elements c,; of C satisfy lew] > |ei+i,41| for each 1. The variable k is set to the largest integer such that |c,,| > 7, and if HF TI2 is used then the diagonal elements c,; are stored

in D. C is now regarded as the partitioned matrix C, C C= 1 2 0 C3 whe : Cy isa kx k matrix. Minimum length least squares solutions 2, are then computed

for the problems As; = 6; using only the first k rows of C. This is equivalent to replacing A with

x C Co A=al 1 \P ,o 0

and solving Az; = 6b, forjg=1,...,8.

Since fey] > ++: > |cee| > > clearly k& is the rank of A. It is also true that the ratio 1¢1,| /|cgs| is 4 lower bound on the condition number of Cy (relative to the spectral norm). Thus, if the ratio is extremely large (say > 108) then a severe loss of accuracy can be expected. A large ratio may be due all or in part to rank deficiency (or near rank deficiency) of the matrix A. Fortunately, rank deficiency is frequently not too difficult to detect and cure. When A is rank deficient then machine roundoff may assign cg, a small value, say 19714, when it should be (. The cure is to examine the diagonal elements c,, which are stored in D, to reset 7 so as to eliminate the unwanted ¢,,’s, and then to rerun the problem, This will reduce the order of Cy, thereby lowering the rank of the replacement matrix A. Cy will now be better conditioned, but the value of the residual norms [jAr, 6]! may be larger. If the norms do increase, then the solution obtained will be satisfactory only if the size of the increased norms fall within acceptable bounds

**Remarks.**

(1) The variable & is set to Oaf all le] oor. Hk G thea the zero matrix fs the solution for AX 2 B.

(2) if @< 0 then the decomposition A QCP is performed, the clawed elements of are stored in D, and & is computed.

```text
(2) Phe contents of 4 are destroyed by the rou ines,
(4) EIR TP and HETI2 yield the same results.
```

Error Return TER Ros a variable that a cet by the routine. Teno put errors ce detected

then PR RE as set to O) Otherwise, TERR as assipoes one of the following valine. Lhoig ht boifen o> kea LPR woah @ - band Ads max crn}

When an error ais detected, the routine immediately terminates


<small>Original source: [View scanned PDF page 285](scans/page_0285.png)</small>

**Programming.** HF TI and HFTI2 call the subroutine H12. These routines were written by Charles L. Lawson and Richard J. Hanson (Jet Propulsion Laboratory}, and modified by A. H. Morris.

**Reference.** Lawson, C. L., and Hanson, R. J., Solving Least Squares Problems, Prentice- Hall, Inc., Englewood Cliffs, New Jersey, 1974.


<small>Original source: [View scanned PDF page 286](scans/page_0286.png)</small>

<a id="topic-286-01"></a>
### Least Squares Solution of Overdetermined Systems of Linear Equations with Iterative Improvement

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LLSQMP` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [`L70664`](source_parts/nswc_part_07.f90#L7306) |


Given an m Xn matrix A and an mx £ matrix B. The column vectors b;,...,6, of B specify @ distinct linear least. squares problems

This set of problems can be written in the form AX = B where X is the n x @ matrix having the column vectors 2}, ...,z2. Assume that m > n > 1 and that the rank of Ais n. Then there exists a unique least squares solution z; for each Az, = b;. The subroutine LLSQMP is available for obtaining the solution matrix X. Iterative improvement is performed to compute X to machine accuracy.

```fortran
CALL LLSQMP(M, N, A, KA, B, KB, NB, WK, IWK, IERR)
```

It is assumed that m > n > 1 and that the rank of A is n. The input arguments ka and «6 have the following values:

ka = the number of rows in the dimension statement for A in the calling program

kb == the number of rows in the dimension statement for B in the calling program It is required that ka > mand kb > m.

When LLSQMP is called, the solution X is computed and stored in B. Also, ifm 7#on then the residual norm ||Ax, ~ 5,{| is computed and stored in B(n + 1,7) for jg = 1,...,6.1 Ais not modified by the routine.

WK is an array of dimension min ¢ 2: { on or larger, and EW an array of dimension nor larger. WK and [WK are work spaces for the routine.

JERR is a variable that is set by the routine. When LLSQMP terminates, [eRR has one of the following values:

JERR OO ‘The solution XY was computed to machine accuracy.

HERR oft X was obtained, but not to machine accuracy.

IERR | 2 ‘The restriction mi > a> Lis not satisfied

IERR 3 ‘The rank of Aas less than n.

**Programming.** LLSQMP is a driver for the subroutines ORTHO, ORSOL, and ORIMP. These subroutines were written by NaieKuan Tsao and Paul J. Nikolat (Aerospace Research Laboratories, Wright-Patterson Air Force Base). ORIMPE was modified by A. TH. Morris. The function SUMPAR and subroutine MCOPY are also used

**Reference.** Tsao, NO Ko and Nikola, Pod, Procedures using Orthogonal Transformations

for Linear Least Squares Problems, Report ARD TR 74-0124, Aerospace Research Laboratories, Wright-Patterson Air Force Base, 1974

Mere hey Vlaet for any vector: tea, ean)


<small>Original source: [View scanned PDF page 287](scans/page_0287.png)</small>

<a id="topic-287-01"></a>
### Double Precision Least Squares Solution Of Systems Of Linear Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `DLLSQ` | `SUBROUTINE` | `M, N, A, KA, B, KB, NB, WK, IWK, IERR` | [`L71060`](source_parts/nswc_part_07.f90#L7702) |
| `DLSQR` | `SUBROUTINE` | `IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK, KSURE, RNORM, WORK, LW, IWORK, LIW, IERR` | [`L72541`](source_parts/nswc_part_07.f90#L9183) |
| `DHFTI` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP` | [`L74576`](source_parts/nswc_part_08.f90#L678) |
| `DHFTI2` | `SUBROUTINE` | `A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR` | [`L74855`](source_parts/nswc_part_08.f90#L957) |


Given an mx n matrix A and an mx 2 matrix B. The column vectors b;, ...,6, of B specify @ distinct linear least squares problems

Ar; =b; (g=1,..., 8).

This set of problems can be written in the form AX = B where X is the nx £ matrix having the column vectors 11, ...,Z¢. There always exists a unique minimum length least squares solution z, for each Az; = b,. If B is the m > m identity matrix, then the matrix whose columns are the minimum length solution vectors x; is called the pseudoinverse of A.

For any £2, the subroutines DLLSQ, DLSQR, DHFTI, and DHFTI2 are available for obtaining the matrix X whose columns are the minimum length solution vectors. DLSQR, DHFTI, and DHFTI2 are more general than DLLSQ, begin able to solve arbitrary systems AX = B. DLISQ assumes that m > nm > 1 and that the rank of A is n. DLSQR employs a more involved procedure than DHF TI and DHFTI2. DLSQR computes the rank of A, whereas DHET1L and DHFTI2 leave the determination of the rank to the user. he subroutines perform all calculations in double precision.

```fortran
CALL DLLSQ(M, N, A, KA, B, KB, NB, WK, IWK, IERR)
```

A and B are double precision arrays. It is assumed that m > n > I and that the rank of Ais mn. The input arguments ka and kb have the following values:

ka ~ the number of rows in the dimension statement for A in the calling program

kb the number of rows in the dimension statement for Bin the calling program It is required that ka ©: rn and kb > m,

IK EGR is an integer variable. When DLLSQ is called, af no input errors are detected then TORR is set to O and the solution matrix X stored in’ Bo Also, ifern fon then the a

residual norm [}4a. bf as computed and stored in Btn i Ly) for 7 1 i é via i y

a Wik and PWR are arrays of dimension a or larger that are work spaces for the routine

Wks a double precision array.

Error Return TRKR ¢ O when wi con - bas not satisfied (EER Ej) er the rank of Ac less Chan on (HERE 2)

Note Adis destroyed during computation Programming ULDSQ is a driver for the subroutines DORVHO and DORSOE These sub

routines are double precision versions of ORTHO and QRSOEL, written by Nat huan Psa

apd Paul Jo Nikolas (Aerospace Research Laboratories, Wright) Patterson Ai Pore Rae}

te

Throughout this section 3 \ : foroany weber (yy coy an

O85


<small>Original source: [View scanned PDF page 288](scans/page_0288.png)</small>

**Reference.** Tsao, N. K. and Nikolai, P. J., Procedures using Orthogonal Transformations for Linear Least Squares Problems. Report ARL TR 74-0124, Aerospace Research Laboratories, Wright-Patterson Air Force Base, 1974.

CALL DLSQR(MO,A, ka, m,n, B, kb, ,RERR,AERR,k,ko. RNORM, WK, éw,IWK,@iw,IERR)

MO is an argument which specifies if DLSQR is being used for the first time. On an initial call, MO = 0 and we have the following setup:

A is a double precision m x n matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ka > m. Ais destroyed by the routine.

The argument @ is an integer. If £> 1 then B is a double precision m x @ matrix and xb is the number of rows in the dimension statement for B in the calling program. Also, RNORM is a double precision array of dimension @ or larger (for output). It is required that kb > max{m,n}. If @ < 0 then there are no equations to be solved, and 6, kb, and RNORM are not used.

RERR is a double precision value which specifies the relative accuracy of the data in A. If it is estimated that the elements in A are accurate to p significant decimal digits then one may set RERR = 1074. It is required that RERR > 0. If RERR — 0 then it is assumed that the elements in A are accurate to machine precision.

AERR is a double precision value which specifies the maximum absolute uncertainty of the data in A. For example, if it is estimated that the elements a,; of A have the relative

~ 10 3° then one may set AFRR 10 “8. It is required

accuracy RERR except when fa,, thet AERR > 0.

The arguments &, ky, and HERR are variables. When DLSQR is called, if no input errors are detected then HERR is set to O and the rank of A ois bounded from above and below using the tolerances RERR and AFRR. The variable Ais set to the upper bound and ky to the lower bound. (ff © dl then the nos f@rmatrixc No whose caiatnus are the minimum length solution vectors is computed (using & as the rank) and stored in A. Also, the residual norm [fAr, 8,{) is computed and stored i RNORM()) for 7 bo 0&

WK is a double precision array of dimension @w where éw o> 5-muingmyn}, and IWA

is an integer array of dimension fru where @ie som toa WR and PWR are work spaces tor

the routine

**Error Return.** TERR is assigned one of the following values where an erie is detected TR boas bern: 1 IER 2 kus orn [RRR 3 kb - miasdral nd TERR Hofstra ron TERR DQ fies toa small

Osb


<small>Original source: [View scanned PDF page 289](scans/page_0289.png)</small>

```text
TERR = 6 RERR or AERR is negative.
IERR =: 7 MO 40 and @< 0.
```

No computation is performed when an error is detected.

After an initial call to DLSQR, J IERR = 0 then the routine may be called with MO 7% 0. In this case, it is assumed that only B has been modified and that the new set of equations AX = B are to be solved. The routine employs the Householder factorization of A stored in A, WK, and IWK on the initial call to DLSQR.

When MO +# 0, it is assumed that A,ka,m,n,k,IWK, and érw have not been modified by the user. If k == 0 or k = min{m,n} then only the first min{m, n} elements of WK are needed and one may set éw > min{m,n}. Otherwise, it is required that €w > 2-min{m,n}.

RERL, AERR, and ko are not used when MO # 0. The only assumptions concerning the new B, kb, and € are that kb > max{m,n}, @ > 1, and the dimension of RNORM is now the new value of @. When DLSQR is called, if no input errors are detected then IERR is set to 0 and the new solution matrix X obtained. As before, X is stored in B and the residual norms are computed and stored in RNORM.

**Remarks.**Normally ko =k, in which case k is the rank of A. However, if ko # k then it is recommended that DHFTI2 be used for obtaining the most appropriate value for the rank and solving AX = B. If DHFTI2 is used, the sizes of the elements of the solution matrix X should be considered (in addition to the values of the residual norms). Frequently, the lower bound kp will be found to be the most appropriate value for the rank.

**Programming.** DLSQR employs the subroutines DUIILS, DU12L8S, DU11US, DU12US, ISWAP, DSWAP, DAXPY, DSCAL and functions DDOT, DNRM2, IDAMAX, DPMPAR, IPMPAR. DLSQR was written by A. H. Morris and DUIILS, DU12LS, DU11US, DU12US were written by T. Manteuffel (Los Alamos).

**References.** Manteuel, T., An Interval Analysts Approach to Rank Determination tn Linear Least Squares Problems, Report SAND 80-0655, Sandia Laboratories, Albuquerque, New Mexico, 1980.

```fortran
CALL DHFTI(A, MDA, M, N, B, MDB, NB, TAU, K, RNORM, H, G, IP)
CALL DHFTI2(A, MDA, M, N, B, MDB, NB, D, TAU, K, RNORM, H, G, IP, IERR)
```

A is a double precision m x n matrix where m,n > 1, and ka is the number of rows in the dimension statement for A in the calling program. It is required that ka > m.

The argument @ is an integer. If €> 1 then B is a double precision m x @ matrix and kb is the number of rows in the dimension statement for B in the calling program. [t is required that kb > maxfm,n}. If é@ < 0 then there re po equations to be solved, and 2 and kb are not used.

If @> | then RNORM is a double precision array of dimension € or larger. Otherwise, ih @< O then RNORM ts ignored, When DHETE or DHE PE is called, if @ > 1 then the

n>» @ matrix X whose columns are the minimum length solution vectors is computed and


<small>Original source: [View scanned PDF page 290](scans/page_0290.png)</small>

stored in J. Also, the residual norm || Az, — 6,|| is computed and stored in RNORM(j) for 7=l,...,8

H,G, and IP are arrays of dimension n or larger that are work spaces for the routines. HW and G are double precision arrays.

The parameters r,k, and D.

vy is a double precision tolerance that is set by the user, * an integer variable, and D a double precision array of dimension min{m,n} ox larger. It is assumed that r > 0. Normally 7 = 0 is the setting that is used. D and & are set by the routines.

In order to understand the use of r,k, and D one must be briefly acquainted with the processing of A. The routines first reduce A to a triangular matrix C where A = QCP. Q is an orthogonal matrix and P a permutation matrix. P is defined so that the diagonal elements c,; of C satisfy |c.| > |ev41,:41| for each 1. The variable k is set to the largest integer such that |c,,| > 7, and if DHFTI2 is used then the diagonal elements ¢,;; are stored in D. C is now regarded as the partitioned matrix

\+ C1 C4 c= (5 é]

where Cy is ak x k matrix. Minimum length least squares solutions 2, are then computed for the problems Az, = b, using only the first k rows of C. This is equivalent to replacing

A with ~ Cy C2

and solving Az; = 6, forj=1,...,@.

Since ley] > -«- > |ex,| > 7 clearly k is the rank of A. It is also true that the ratio |c11| / |exx| is a lower bound on the condition number of C, (relative to the spectral norm). Thus, if the ratio is extremely large (say > 10%) then a severe loss of accuracy can be expected. A large ratio may be due all or in part to rank deficiency (or near rank deficiency) of the matrix A. Fortunately, rank deficiency is frequently rot too difficult to detect and cure. When A is rank deficient then machine roundoff may assign cy, a small value, say 10-78, when it should be 0. The cure is to examine the diagonal elements c,, which are stored in D, to reset r so as to eliminate the unwanted c¢,,’s, and then to rerun the problem. This will reduce the order of C;, thereby lowering the rank of the replacement matrix A. C will now be better conditioned, but the value of the residual norms {| Az, ~ 6,|| may be larger. If the norms do increase, then the solution obtained will be satisfactory only if the size of the increased norms fall within acceptable bounds.

**Remarks.**

(1) The variable k is set to O if all les, for AX BB.

(2) If € < 0 then the decomposition A =. QCP is performed, the diagonal elements of C are stored in D, and & is computed.

<a. Uf Ao O then the zero matrix is the solution

(3) The contents of A are destroyed by the routines,

OQ ard


<small>Original source: [View scanned PDF page 291](scans/page_0291.png)</small>

(4) DHFTI and DHFTI2 yield the same results. These routines are double precision versions of the subroutines HFTI and HFTI2.

**Error Return.** IERR is a variable that is set by the routine. If no input errors are detected then IERR is set to 0. Otherwise, JERR is assigned one of the following values:

```text
IERR = 1 if m> ka
IERR = 2 if 2> 1 and kb < max {m,n}
```

When an error is detected, the routine immediately terminates.

**Programming.** DH®TI and DHFTI2 call the subroutine DH12. These routines are modifications by A. H. Morris of the subroutines HFTI and H12, written by Charles L. Lawson and Richard J. Hanson (Jet Propulsion Laboratory).

**Reference.** Lawson, C. L., and Hanson, R. J., Solving Least Squares Problems, Prentice- Hall, Inc., Englewood Cliffs, New Jersey, 1974.


<small>Original source: [View scanned PDF page 292](scans/page_0292.png)</small>

<a id="topic-292-01"></a>
### Least Squares Solution Of Systems Of Linear Equations With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LSEI` | `SUBROUTINE` | `W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML, MODE, WS, IP` | [`L75255`](source_parts/nswc_part_08.f90#L1357) |


Let A be an m, Xn matrix, H anim, Xn matrix, G an m, xn matrix, 6 a column vector of dimension m,, f a column vector of dimension m,, and A a column vector of dimension m,. The subroutine LSEi is available for finding a column vector z of dimension n that minimizes || Ax -- 6|| subject to the constraints?

Er =~ f Gx >h.

Ka ~ f states that 2 is a least squares solution of the equation Ex = f, and Gz > h means that every component of the vector Gz must be equal to or greater than the corresponding component of hk. It is assured that m, > 0, m, > 0, and m, > 0.

CALL LSEI(W. kw, m.,ma,m,,n, OPT, z, RNORME,RNORMA, IERR,WK,IWK)

Ifm =m, +m, +m, then W is the m x (n + 1) matrix:

‘Ef W (4 | Goh The input argument kw is assumed to have the value:

kw = the number of rows in the dimension statement for W in the calling program Thus it is required that kw > m.

RNORME and RNORMA are real variables. When LSE is called, if the constraints Eig ~ f and Gx > A are consistent then 2 is computed, RNORMF is assigned the value |x ~ f||,? and RNORMA is assigned the value {|Az - 6]].

OP'T is an array, called the option vector, which permits the user to take advantage of certain options that are supplied by the routine. If no options are desired then OPT may be declared to have dimension 1 and OPT(1L) must be assigned the value 1. The details concerning the available options and how to specify them in OPT are given below.

IWK is an array of dimension my, | 2n-+ 2 or larger, and WK is an array of dimension 2(m, +n) 4 max {my +my,n} ot (m, + 2)(n + 7) or larger. EWK and WK are work spaces. When LST is called, using a solution for Wa -~ f, a reduced least squares problem with inequality constraints is obtained and solved. When the routine terminates IWK(1), IWK(2), IWK(3) contain the following information:

‘SY Throughout this section [leq] denotes the worn Via for any vector er (eyseu, oj.

“Ifon. . Othen RNOKME OG.


<small>Original source: [View scanned PDF page 293](scans/page_0293.png)</small>

```text
{WK(i) = the estimated rank of the matrix EF
IWK(2) = the estimated rank of the reduced problem
IWK(3} = the amount of storage in the array WK that was actually needed
```

```text
IERR is a variable that is set by the routine. When LSEI terminates, IERR has one
of the following values:
IERR = O The solution xz was obtained. The equality Ex = f is satisfied
when m, #0.
IERR = 1 The solution z was obtained. In this case || Zz — f|| > 0.
IERR = 2 The problem cannot be solved. The constraints are inconsistent.
IERR = 4 (Input error) Either kw < m, the covariance matrix is requested
and kw <n, or the option vector OPT is not defined properly,
```

If IERR > 2 then z, RNORME, and RNORMA are not defined.

**Remarks.**

(1) W is modified by the routine.

(2) If m, +m, <0 orn <0 then IERR is set to O and the routine terminates.

The option vector OPT. If no options are desired then OPT may be declared to be of dimension | and OPT(1) must have the value 1. Otherwise, OPT is a linked list consisting of groups of data link,, key,;, data; (¢ = 1,...,8). Each link; and key, is an integer. The amount of storage required by data; depends on the value of key;. The general layout of OPT is as follows:

```text
OPT(1) = link, (index of the first entry of the next group)
OPT(2) = key; {key to the option)
OPT(3) = the first word of the data (data,) for this option
```

```text
OPT(link;) = linky (index of the first entry of the next group)
OPT (link; + 1) == key2 (key to the option)
OPT(link; + 2) = the first word of the data (data2) for this option
```

OPT(link,) = 1.0 (There are no more options to be considered.) The following options are available:

key © 1 It is assured that &w > n. Compute the n xn covariance matrix and store it in the first n rows and columns of W. The data for this option is a single value. It must be nonzero for the covariance

matrix to be computed. BE key | 2 Scale the nonzero columns of the matrix (+) so that they have GG


<small>Original source: [View scanned PDF page 294](scans/page_0294.png)</small>

key = 3

key = 4

key =

Also the key 8 and 9 options for the least squares subroutine WNNLS are permitted. (WNNLS is employed by LSEI.) The order of the options in the array OPT is arbitrary. If an option has an unrecognized key then the option is ignored. It is assumed that the dimension of OPT is no greater than 100000 and that the number of options is < 1000. If either of these assumptions is violated then IERR is set to 4 and the routine terminates. {t is also required that link, 4 link, for ¢ # 7. If this restriction is not satisfied then the

length 1. The data for this option is a single value. It must be nonzero for the scaling to be performed.

E Scale the columns of the matrix (4). The data for this option

consists of n scaling factors, one for each matrix column.

Change the internal tolerance r which is used for determining the rank of #. The data for this option is the new tolerance. + may be set to any value > € where ¢ is the smallest floating point number for which 1+ ¢€ > 1{e = 2~*? for the CDC 6700). If the new value is less than ¢ then it is ignored and r is set to «. The default value employed for r is \/e.

Change the internal tolerance + which is used for rank determination in the reduced least squares problem. The data for this option is the new tolerance. r may be set to any value > ¢ where € is the smallest floating point number for which 1+ € > 1. If the new value is less than € then it is ignored and r is set to €«. The default value employed for r is \/e.

linked list OPT is circular and we again have an [ERR = 4 error.

**Example.** Assume that we have an array D containing n scaling factors for the columns of

; E the matrix (4

, and that the tolerance TOL is always to be used for rank determination.

G/ Then OPT will have to be of dimension > n+ 9 and OPT can be defined as follows:

```fortran
OPT(1)
```

=N+3 (Scaling option)

```text
OPT(2) = 3.0
DG 101 =1,N
```

```text
10 = OPT(I +2) = D(D
OPT(N +3)=N+6 (Matrix E tolerance option)
OPT(N +4) = 4.0
OPT(N +5) = TOL
OPT(N 4-6) = N49 (Reduced problem tolerance option)
OPT(N +7) = 5.0
OPT(N +8) = TOL
OPT(N + 9) = 1.0 (There are ne more options.)
Remarks.
```

(1) LSEL may perform poorly if the norms of the rows of A and #7 differ by many orders

of magnitude, or if the norms of the rows of F are exceedingly small.

(2) ‘The covariance matrix obtained by the key = | option may not be meaningful when


<small>Original source: [View scanned PDF page 295](scans/page_0295.png)</small>

there are inequality constraints Ga > h. This matrix assumes that any inequalities which are selected by the algorithm to be equalities remain equalities when the solution is perturbed. This, of course, may not be the case.

**Programming.** LSEI employs the subroutine LSI, LPDP, WNNLS, WNLSM, and WNLIT. These routines were written by Karen H. Haskell and Richard J. Hanson (Sandia Laboratories) and modified by A. H. Morris. The subroutines HF TI, H12, SROTM, SROTMG, SCOPY, SSWAP, SSCAL, SAXPY and functions SPMPAR, SDOT, SASUM, SNRM2, ISAMAX are also used.

**References.**

(1) Hanson, R. J. and Haskell, K. H., “Algorithm 587: Two Algorithms for the Linearly Constrained Least Squares Problem,” ACM Trans. Math Software 8 (1982), pp. 323-333.

(2) Haskell, K. H. and Hanson, R. J., “An Algorithm for Linear Least Squares Problems with Equality and Nonnegativity Constraints,” Math. Programming 21 (1981), pp. 98-118.


<small>Original source: [View scanned PDF page 296](scans/page_0296.png)</small>

<a id="topic-296-01"></a>
### Least Squares Solution Of Systems Of Linear Equations With Equality And Nonnegativity Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `WNNLS` | `SUBROUTINE` | `W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK` | [`L76418`](source_parts/nswc_part_08.f90#L2520) |


Let A be an m, Xn matrix, FE an m, x n matrix, b a column vector of dimension m,, and f a column vector of dimension m, The subroutine WNNLS is available for finding a column vector z = (zy, ...,2,)* that minimizes || Az — || subject to the constraints!

Be~ za; > Ofor?t> &.

Ex = f states that z is a least squares solution of the equation Ex = f. It is assumed that m, 2 0,m, > 0, andO< @<n. If m, = 0 then WNNLS solves Ex ~ f subject to the constraints z; > 0 (> ¢),

```fortran
CALL WNNLS(W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK, WORK)
```

ifm =m, +m, then W is the m x (n + 1) matrix:

_(#f w= (J \)

The input argument kw is assumed to have the value: kw = the number of rows in the dimension statement for W in the calling program Thus it is required that kw > m.

RNOKM is a variable. When WNNLS is called, 2 is computed and RNORM is assigned

the value \/ Az — b||? +]

OPT is an array, called the option vector, which permits the user to take advantage of certain options that are supplied by the routine. If no options are desired then OPT may be declared to have dimension | and OPT(1) must be assigned the value 1. The details concerning the available options and how to specify them in OPT are given below.

IWK is an array of dimension mm {nor larger, and WK is an array of dimension mi} 5n or larger. IWK and WK are work spaces for the routine.

**Error Return.** MODE is an integer variable that is set by the routine. If the problem is solved then MODE is assigned the value 0. Otherwise, MODI is assigned one of the following values: MODE — 1 The maximum umber of iterations (3(n — @) iterations) was exceeded. An approximate solution and its residual norm are stored in 2 and RNORM. MODE — 2 (input error) Hither kw > mor 0 < & < n is violated, or the option vector OPT is not properly defined.

'Throughout this section |jcj! denotes the norm Jue for any vector ¢ > (cy,¢a,...)- *ifrag O then RNORM — He fil, and ifm, © 0 then RNGRM Ax if.


<small>Original source: [View scanned PDF page 297](scans/page_0297.png)</small>

When an input error is detected, the routine immediately terminates. In this case x and

RNORM are not defined.

**Remarks.**

```text
1) W is modified by the routine.
7 y
(2) If m <0 orn <0 then MODE is set to 0 and the routine terminates.
```

The option vector OPT. If no options are desired then OPT may be declared to be of dimension 1 and OPT(1) must have the value 1. Otherwise, OPT is a linked list consisting of groups of data link,, key;, data; (¢ = i, ...,8). Each link, and key, is an integer. The amount of storage required by data; depends on the value of key,. The general layout of OPT is as follows:

```text
OPT(1) = link; (index of the first entry of the next group)
OPT(2) = key; (key to the option)
OPT(3) = the first word of the data (data,) for this opficn
```

```text
OPT(link,) = link2 (index of the first entry of the next group
OPT(link; + 1) = keyz, (key to the option)
OPT(link; + 2) = the first word of the data (dataz) for this option
```

```fortran
OPT(link ) = 1.0 (There are no more options to be considered.)
```

The following options are permitted:

key = 6 Scale the nonzero columns of the matrix (4) so that they have length 1. The data for this option is a single value. It must be nonzero for the scaling to be performed.

key = 7 Scale the columns of the matrix (4). The data for this option consists of n scaling factors, one for each matrix column.

key ~ 8 Change the internal tolerance 7 which is used for rank determination. The data for this option is the new tolerance. 7 may be set

~,

to any value > ¢ where ¢ is the smallest floating point number for which 1+e > 1. (¢> 2 47 for the CDC 6700.) If the new value is less than ¢ then it is ignored and 7 is set to ¢. The default value employed for r is \/e.

key = 9 Change the parameter BLOWUP. The reciprocal of this parameter ig used in determining when solution components are too large. The data for this option is the new value for BLOWUP. It is assumed that BLOWUP < 1. BLOWUP may be set to any value > ¢ where ¢ is the smallest number for which Lt «> E If the new value is less than ¢ then it is ignored and BLOWUP is set to e. The default value used for BLOWUP us \/e.


<small>Original source: [View scanned PDF page 298](scans/page_0298.png)</small>

The order of the options in the array OPT is arbitrary. If an option has an unrecognized key then the option is ignored. It is assumed that the dimension of OPT is no greater than 100000 and that the number of options < L000. If either of these assumptions is violated then MODE is set to 2 and the routine terminates. [t is also required that link, 4 link, for 1: 7. if this restriction is not satisfied then the linked list OPT is circular and we again have a MODE = 2 error.

**Example.** Assume that we have an array D containing n scaling factors for the columns of the matrix (”), and that TOL is the tolerance to be used for rank determination. Then OPT will have to be of dimension > n+ 6 and OPT can be defined as follows:

```text
OPT) = N +3 (Scaling option)
OPT(2) = 7.0
DO 10 T= 1,N
10 OPT(I+2) = D(n
OPT(N + 3)=N+6 (Tolerance option)
OPT(N + 4) = 8.0
OPT(N + 5) = TOL
OPT(N + 6) = 1.0 ( here are no more options.)
```

**Remark.** WNNLS may perform poorly if the norms of the rows of A and F differ by many orders of magnitude, or if the norms of the rows of E are exceedingly small.

**Programming.** WNNLS employs the subroutines WNLSM and WNLIT. These routines were written by Karen H. Haskell and Richard J. Hanson (Sandia Laboratories), and modified by A. H. Morris and Virgis Dadurkevicius (Astronomical Observatory, Vilnius University, Lithuania). The subroutines H12, SROTM, SROTMG, SCOP Y, SSWAP, SSCAL, SAXPY and functions SPMPAR, SASUM, SNRMzZ, ISAMAX are also used.

**References.**

(1) Dadurkevicius,V.,“Remark on Algorithm 587,"ACM Trans. Math Software 15 (1989),

pp. 257-261

Hanson, R. J. and Haskell, K. H., “Algorithm 587: ‘Two Algorithms for the Linearly

Constrained Least Squares Problem,” ACM Trans. Math Software 8 (1982), pp. 323-

333.

(3) Haskell, K. Ho and Hanson, Ro Jo, “An Algorithm for Linear Least Squares Problems with Equality and Nonnegativity Constraints,” Math. Programming 2 (1981), pp. 98 118.

(2

—


<small>Original source: [View scanned PDF page 299](scans/page_0299.png)</small>

<a id="topic-299-01"></a>
### Least Squares Iterative Improvement Solution Of Systems Of Linear Equations With Equality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `L2SLV` | `SUBROUTINE` | `M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT, X, NN, RES, MR, QR, MMPNN, C, IFAULT` | [`L77789`](source_parts/nswc_part_08.f90#L3891) |


Let A be an m, x n matrix, E an m, Xn matrix, 3 an m, x & matrix, and F an m, x &€ matrix. It is assumed that 0 < m, < n and that the rank of Eis m,. Let by, ...,5¢ denote the column vectors of B and fi, ...,f¢ the column vectors of F. The subroutine L2SLV is available for finding the unique minimum length column vector z, of dimension n that minimizes ||/Az, — 6,;|| subject to the equality constraints Ez, = f, (if there are any) for 7 = 1,...,@ Iterative improvement is performed to compute the vectors Z1,.-.4,2¢ to machine accuracy. It is assumed that ma > 0. If mg = 0 then L2SLV finds the unique minimum length solution z,; to fz; = f; forj=1,...,€.

CALL L2SLV(m,n,m,, ¢, A, ka, B, kb, WGTS,TOL,NLIPIVOT, X,kz, R, kr,T, kt, WK,IERR)

if m= m,+ mg then A is the mx n matrix (7) and B is the m x & matrix (3): The Input arguments ka and kb have the values:

ka = the number of rows in the dimension statement for A in the calling program

kb = the number of rows in the dimension statement, for B in the calling program It is assumed that m > 1,n > 1,0> 1,ka > m, and kb >m. A and B are not modified by the routine.

WGTS is an array containing m nonnegative weights. The first m, weights are set to 1.0 by the routine. Let w;, ...,Wm, denote the remaining weights (i.e., let w, = WGTS(m, +1) for t =: J ma). The remaining weights are supplied by the user. In effect, w, is the weighting that is given to the t'* equation in the least squares problem Ar, ~ 6,. If W denotes the mg x m, diagonal matrix diag(w1, ...,wm,) then L2SLV finds the unique minimum length vector that minimizes ||WAz, W,|| subject to Ez, = f, forj = 1,...,€@

yor gy

For convenience, W will denote the m x m diagonal matrix diag (1,...,1,w., ...,Wm,)-

X is ann x @ matrix that contains the solution vectors 2), ...,2¢ when the routine terminates. The input argument kx is the number of rows in the dimension statement for X in the calling program. It is assumed that kar o> on.

Ris anim * @ matrix. Let 6, denote the jy"

Py of Bfor yg 1,048

column vector Then L25LV stores the residual vector r, Wb, WaAz, in the 7" column of Ro The input argument kris tee number of rows in the dimension statement for Hin the calling program.

It is assumed that kr o> yn.

WK is an array of dimension G(r 4 om) + 2@ or larger that is used for a work space When L2SLV terminates, for 7° 1, ...,8

fon, if iterative improvement of the solution #, converged

nm, if iterative improvement of 1, farted to converge 'Throughout this section fj denotes the norm yiae? for any vector ec feq, ang?


<small>Original source: [View scanned PDF page 300](scans/page_0300.png)</small>

where n, is the number of iterations in the iterative improvement process that were performed in computing z,. Also

WK(é+ 7) = the estimated number of correct digits in z, before iterative improvement was performed for g-:1,...,8

TOL and N1 correspond to the parameters r and k in the least squares subroutines HFTI and HFTI2. TOL is a nonnegative number that is specified by the user, and NI is a variable that is set by the routine. When L2SLV is called, modified Gram-Schmidt orthogonalization with column pivoting is used to reduce WA to the form (A; Az) where A; is an mx N, matrix having rank N,. A, is of the form QU where Q'Q ~ diag(d1, ...,dn,) and U is an upper unit triangular matrix. The values d,,d2, ... correspond to the diagonal elements cy1,C22, ... generated by HFTI and HFTI2 (d, > c?. fort = 1,2,...). The values are ordered so that d, > d,,1, and d;,d2,... are stored in WK(2@ + 1), WK(2@ + 2),.... If m -m, then N11 is assigned the value m,. Otherwise, ifm > m, then N1 is the largest integer k for which dy, > 7. Herer TOLif TOL > 0, and rt ~ (ne)?dya. yp. where ¢ is the smallest value for which 1+ ¢ > E(e 2 47 on the CDC 6700) if TOL = 0. Thus, if TOL

0 then a tolerance based on the computer precision is used to determine the rank of Ny of WA, Otherwise, if TOL ©- 0 then TOL is the tolerance that is used to specify the rank of the problem to be solved. If the user inadvertently sets TOL to be negative then L2SLV resets TOL to be 0.

IPIVO'T is an array of dimension nor larger that is used by L2SLV to record the order in Which the columns of WA are selected by the pivoting procedure when WA is reduced to (A, Aa). If NI. om then the first Ni elements of IPIVOT are the indices of the columns of

~

WA from which the matrix A, is generated,

Tosa 2-dimensional array of dimension kt x n that is used for temporary storage. it is assumed that kl cm +n When L2SLV terminates, if NE nothen the unscaled m+ on covariance matrix is stored in the first a rows and columns of 7.) Iterative improvement is

not performed on the covariance matrix

Error Return PRR is an integer variable Ghat as set by the routine. If no input errors are detected and the results appear to be satisfactory, then EER is set to 0) Otherwise, TERR

is assigned one of the following values

ERR To Either min, or @as not positive

TERR 2° The restriction O + on, tanger p is not satisfied

IRE Sobither ka com kb con Aa ton Rr som or kt ory reas violated TERR A WOPPS()) is negative for some a + ora,

[ERR Oo Either WA Gor Boo IE RR @ The rank of boas less than oa,

IRR fo Iterative improvement of all the solutions ary, oy farted ta con Wwergres

ie oanen & Iterative improvement of cue or more solutions fared to converge

HEAR Oo More than go iterations of the iterative improvement procedure Were performed ta connpatitg: seme a, (Here it is assumed that oa

tional


<small>Original source: [View scanned PDF page 301](scans/page_0301.png)</small>

p decimal digit floating-point arithmetic is being used. yw = 14 for the CDC 6700.) TERR = 10 The accuracy of some x; before iterative improvement was estimated to be less than half a decimal digit. TERR = IL One ox more of the computed diagonal elements of the covariance matrix is negative. This is due to roundoff error. Theoretically, all the diagonal elements should be nonnegative. No evidence of severe ill-conditioning was detected. IERR = 12 One or more of the computed diagonal elements of the covariance matrix is negative This is due to roundoff error. Theoretically, all the diagonal elements should be nonnegative. The problem appears to be extremely ill-conditioned. When an input error is detected (IERR = 1,2, ...,6} thea L2SLV immediately terminates. If evidence of severe ill-conditioning is detected, then FRR is sct to 8,5, or 10 aad computation of the solutions continues. If iterative improvement appears to converge for one or more of the solutions, then the covariance matrix is also computed (when N1 = n). However, if iterative improvement fails for all the solutions r,,...,2, then IERP is set to 7 and the covariance matrix is not computed.

**Note.** WK(1), ...,WK(22) should be examined when severe ill-conditioning is detected.

**Programming.** L2SLV employs the subroutines DECOM2, SOLVE2, SOLVE3, and CO- VAR. These routines were written by Roy Wampler (National Bureau of Standards). L2SLV is a slightly modified version by A. H. Morris of the subroutine L2B discussed in reference (4). The algorithm employed for finding and iteratively improving the least squares solutions is described in references (1)-(3). The function SPMPAR is also used.

**References.** (1) Bjorck, Ake, “Solving Linear Least Squares Problems by Gram-Schmidt Orthogonalization,” BIT'7 (1967), pp. 1-21.

```text
(2) si (“ws “Iterative Refinement of Linear Least Squares Solutions I,” BIT 7
(1967), pp. 257-278.
(3) | _.  , “Iterative Refinement of Linear Least Squares Solutions II,” BIT 8
```

(1988), pp. 8-30.

(4) Wampler, Roy, “Solutions to Weighted Least Squares Problems by Modified Gram- Schmidt with Iterative Refinement,” ACM Trans. Math Software 5 (1979), pp. 457- 465.


<small>Original source: [View scanned PDF page 302](scans/page_0302.png)</small>

<a id="topic-302-01"></a>
### Iterative Least Squares Solution Of Banded Linear

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BLSQ` | `SUBROUTINE` | `M, N, A, KA, ML, MU, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [`L79664`](source_parts/nswc_part_08.f90#L5766) |


EQUATIONS

Given an m x nm matrix A, a column vector 6 of dimension m, and a real number A

Let A = (“) where I is the n x n identity matrix, and let b = (8). The problem is to find

a column vector z of dimension n which is a least squares solution of Ax = 6. If A is stored in band form then the following subroutine is available for solving this problem.

CALL BLSQ(m,n, A, ka, mz, my, d, 6, z, ATOL,BTOL,CONLIM,MXITER, IND,ITER,COND,RNORM,XNORM, WK)

A is an m xX n matrix stored in band form, m, the number of diagonals below the main diagonal containing nonzero elements, and m, the number diagonals above the main diagonal containing nonzero elements. The argument ka is the number of rows in the dimension statement for A in the calling program. It is assumed that O < me < m,0 < m, <n, and ka > m. When BLSQ is called, an iterative procedure is used to obtain a least squares solution x of Ax = b. The vector 6 is modified by the routine.

ATOL and BTOL are input arguments which specify the relative accuracy of A and 6 respectively. For example, if it ig estimated that b is accurate to & decimal digits then one may set BTOL = 107*. It is required that ATOL > 0 and BTOL > 0. If ATOL = 0 or BTOL = 0, then it is assumed that A or 6 is accurate to machine precision.

Let cond(A) denote the condition number of A relative to the Frobenius norm.! In

each iteration of the algorithm being used, an estimate is made of the condition number cond(A). The estimates form a monotonically nondecreasing sequence. The input argument CONLIM is an upper limit on cond(A). If CONLIM > 0 then BLSQ terminates when an estimate of cond(A) exceeds CONLIM. This termination may be needed to prevent small or zero singular values of A from coming into effect and causing damage to the solution z. CONLIM may be ignored by being set to 0. It is assumed that CONLIM > 0.

The input argument MXITER is the maximum number of iterations that are permitted. Normally BLSQ requires less than 4n iterations. The related argument ITER is a variable. When the routine terminates ITER =: the number of iterations that were performed.

COND,RNORM, and XNORM are variables. When BLSQ terminates COND -. the last estimate made for cond(A), RNORM = ||Az -- 6||, and XNORM = j/z|].?

WK is an array of dimension 2n or larger that is a work space for the routine.

The equations Arb are considered to be compatible if for any least squares solution z,||Ax -- 6|| = OQ. IND is a variable that reports the status of the results. When BLSQ terminates, IND bas one of the following values:

Teond (A) |[Al]ei/ Abie where Al is the pseudoinverse of AL Here []C|| ¢ Jack for any matrix Co (eyy). *|ell Vie? for any vector co (ey,eu,..-).


<small>Original source: [View scanned PDF page 303](scans/page_0303.png)</small>

```text
IND = 0
IND = 1
```

IND = 2

IND = 3

```text
IND = 4
IND = 5
IND = 6
IND = 7
Remarks.
```

(1) A large estimate of the condition number cond(A) may be due to rank deficiency or near rank deficiency of the matrix A. If it is suspected that a large estimate of cond(A) has occurred for this reason, then it is recommended tha, CONLIM be set to a moderate value such as \/e where ¢ is the smallest value such that 14 © 6000-7000 series computers). Setting CONLIM to 0 is equivalent to setting CONLIM

toe—!.

The solut’on is x =: 0. No iterations were performed.

The equations Ar -- b are probably compatible. A solution x has been obtained which is sufficiently accurate, given the values ATOL and BTOL.

The equations Ar = b are probably not compatible. A least squares solution z has been obtained which is sufficiently accurate, given the value ATOL.

An estimate COND of cond(A) exceeds CONLIM. The vector z is the most recent approximation of a solution for Az = 6b.

The equations Az = 6 are probably compatible. A solution zt has been obtained which is as accurate as seems reasonable on this machine.

The equations Ax = 6 are probably not compatible. A least, squares solution z has been obtained which is as accurate as seems reasonable on this machine.

cond(A) appears to be so large that there is not much point in doing further iterations. The vector x is the most recent approximation of a solution for Az = 3.

MXITER iterations were performed. More iterations are needed. The vector z is the most recent approximation of a solution for Ax = b.

(2) The vector } is the only input argument modified by the routine.

**Algorithm.** BLSQ employs an iterative algorithm developed by Golub and Kahan.

**Programming.**

subroutine LSQR, written by Christopher C and Michael A.

**References.**

(1) Paige, C. C. and Saunders, M. A

BLSQ calls the subroutines NORMLZ, BVPRD1, BTPRD1, SCOPY, and . The function SNRM2 is also used. BSLQ is an adaptation by A. H. Morris of the . Paige (McGill University, Montreal, Cana’a)

Saunders (Stanford University).

and Sparse Least Squares,” ACM Trans. Math Software & (1982), pp. 43-71.

(2)

Problems, ”

__. “Algorithm 583. LSQR: Sparse Linear Equations and Least Squares ACM Trans. Math Software 8 (1982), pp. 195-209.

404

> 1(€ = 27*7 for the CDC

, “LSQR: An Algorithm for Sparse Linear Equations


<small>Original source: [View scanned PDF page 304](scans/page_0304.png)</small>

<a id="topic-304-01"></a>
### Iterative Least Squares Solution Of Sparse Linear

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPLSQ` | `SUBROUTINE` | `M, N, A, IA, JA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [`L78791`](source_parts/nswc_part_08.f90#L4893) |
| `STLSQ` | `SUBROUTINE` | `M, N, TA, ITA, JTA, DAMP, U, X, ATOL, BTOL, CONLIM, ITNLIM, ISTOP, ITN, ACOND, RNORM, XNORM, W` | [`L79246`](source_parts/nswc_part_08.f90#L5348) |


EQUATIONS Given ai n matrix A, a column vector 6 of dimension m, and a real number 4. Let A= 4 vi: +0 is the n x n identity matrix, and let 6 = (3). The problem is to find a column vec tor: of dimension n which is a least squares solution of Az =: b. If A is sparse

then the following subroutines are available for solving this problem.

Cait :PLSQ(m,n, A,IA,JA, A, b, 2, ATOL,BTOL,CONLIM,MXITER, IND,ITER,COND,RNORM,XNORM,WK)

Cf" ITLSQ(m,n, TA,ITA,JTA, A, 6, 2, ATOL,BTOL,CONLIM,MXITER, IND,ITER,COND,RNORM,XNORM, WK)

if SPLS¢ ‘led then A,IA, JA are arrays containing the matrix A in sparse form. Otherwise, ifS 4: Q is called then TA, ITA, JTA are arrays containing the transpose matrix A‘ in sparse fo.m. An iterative procedure is used to obtain a least squares solution 2 of

Az =: 6. The vector b is modified by the routines.

ATOL and BTOL are input arguments which specify the relative accuracy of A and b respectively. For example, if it is estimated that b is accurate to k decimal digits then one may set BTOL = 107*. It is required that ATOL > 0 and BTOL > 0. If ATOL = 0 or BTOL = 0, then it is assumed that A or } is accurate to machine precision.

Let cond(A} denote the condition number of A relative to the Frobenius norm.! In each iteration of che algorithm being used, an estimate is made of the condition number cond(A). The estimates form a monotonically nondecreasing sequence. The input argument CONLIM is an upper limit on cond (A). If CONLIM > 0 then the routines terminate when an estimate of cond(A) exceeds CONLIM. This termination may be needed to prevent small! or zero singular values of A from coming into effect and causing damage to the solution x.

CONLIM may be ignored by being set to 0. It is assumed that-CONLIM > 0.

The input argument MXITER is the maximum number of iterations that are permitted. Normally the routines require less than 4n iterations. The related argument ITER is a variable. When the routines terminate ITER = the number of iterations that were performed.

```text
COND, RNORM, and XNORM are variables. When the routines terminate COND =
the last estimate made for cond(A), RNORM = ||/Az ~ b||, and XNORM = ||z||.?
```

WK is an array of dimension 2n or larger that is a work space for the routines.

```text
feond (A) = ||Allp[|At lle where At is the pseudoinverse of A. Here (Cllp Sree, for any matrix
Ie] fried for any vector ¢ =. (cy,e9,...).
```

A0S


<small>Original source: [View scanned PDF page 305](scans/page_0305.png)</small>

The equations Az -. 6 are considered to be compatible if for any least. squares solution x, || Aa ~ bl] = 0. IND is a variable that reports the status of the results. When the routines

terminate, IND has one of the following values:

IND = 1 The equations Az - 6 are probably compatible. A solution z has been obtained which is sufficiently accurate, given the values ATOL and BTOL.

IND = 2 The equations Az ~—b are probably not compatible. A least squares solution x has been obtained which is sufficiently accurate, given the value ATOD.

IND = 3 An estimate COND of cond(A) exceeds CONLIM. The vector x is the most recent approximation of a solution for Az — 6.

IND = 4 The equations Az — b are probably compatible. A solution z has been obtained which ig as accurate as seems reasonable on this machine.

IND = 5 The equations Az- 6 are probably not compatible. A least squares solution z has been obtained which is accurate as seems reasonable on this machine.

IND = 6 cond(A) appears to be so large that there is not much point in doing further iterations. The vector x is the most recent approximation of a solution for Az — 6.

IND = 7 MXITER iterations were performed. More iterations are needed. The vector x is the most recent approximation of a solution for Ax = b.

**Remarks.**

(1) A large estimate of the condition number cond(A) may be due to rank deficiency or near rank deficiency of the matrix A. If it is suspected that a large estimate of cond(A) has occurred for this reason, then it is recommended that CONLIM be set to a moderate value such as \/e where € is the smallest value such that 1+e¢ > 1 (¢ = 27‘? for the CDC 6000--7000 series computers). Setting CONLIM to 0 is equivalent to setting CONLIM toeTt,

(2) The vector 6 is the only input argument modified by the routine.

**Algorithm.** SPLSQ and STLSQ employ an iterative algorithm developed by Golub and Kahan.

**Programming.** SPLSQ and STLSQ call the subroutines NORMLZ, MVPRDI, MTPRD1, SCOPY, and SSCAL. The function SNRM2 is also used. SPLSQ and STLSQ are: adaptations by A. H. Morris of the subroutine LSQR, written by Christopher C. Paige (McGill University, Montreal, Canada) and Michael A. Saunders (Stanford University).

**References.**

(1) Paige, C. C. and Saunders, M. A , “LSQR: An Algorithm for Sparse Linear Equations and Sparse Least Squares,” ACM Trans. Math Software 8 (1982), pp. 43-71.

(2) 2 0 , ‘Algorithm 583. LSQR: Sparse Linear Equations and Least Squares Problems,” ACM Trans. Math Software 8 (1982), pp. 195-209


<a id="category-306"></a>
## Optimization

<small>Original source: [View scanned PDF page 306](scans/page_0306.png)</small>

<a id="topic-306-01"></a>
### Minimization Of Functions Of A Single Variable

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FMIN` | `SUBROUTINE` | `F, A0, B0, X, W, AERR, RERR, ERROR, IND` | [`L80086`](source_parts/nswc_part_08.f90#L6188) |


Let F(z) be a continuous real-valued function defined for a < z < b. Then the following subroutine is available for finding a local minimum of F(z}.

```fortran
CALL FMIN(F, A0, B0, X, W, AERR, RERR, ERROR, IND)
```

It is assumed that a < 6. FMIN finds a value z in the interval [a,b] which is a local minimum of F. ERROR and w are variables. When FMIN terminates, w = F(x) and ERROR is the estimated maximum absolute error of z.

The input arguments AERR and RERR are the absolute and relative error tolerances to be satisfied. For example, if k significant digit accuracy is desired then one may set RERR -= 107*. It is assumed that AERR > 0 and RERR > 0. The setting AERR = 0 is equivalent to the setting AERR = 10779, and the setting RERK = 0 is a request for machine precision.

IND is a variable that reports the status of the results. IND = 0 if z is found to the desired accuracy. Otherwise, IND = 1 when z cannot be obtained to the desired accuracy. In this case, w satisfies the tolerances AERR and RERR.

**Note.** F must be declared in the calling program to be of type EXTERNAL.

**Algorithm.** The golden section search procedure is used.

**Programming.** The function SPMPAR is called. FMIN was written by A. H. Morris.

AQT


<small>Original source: [View scanned PDF page 307](scans/page_0307.png)</small>

<a id="topic-307-01"></a>
### Minimization Of Functions Of N Variables

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `OPTF` | `SUBROUTINE` | `FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK` | [`L80269`](source_parts/nswc_part_08.f90#L6371) |


Let f(x) be a real-valued function of n variables x =: (z1,..,2,) where n > 2. If f(z) is twice continuously differentiable then the following subroutine is available for finding a local minimum of f(z).

```fortran
CALL OPTF(FCN, N, RERR, ITER, XPLS, FPLS, IERR, WRK)
```

X is an array of dimension n and FVAL a variable. On input, X contains an initial guess a = (a,...,a,) to a minimum of f. When OPTF terminates, X contains the final estimate z = (21,...,2,) of a local minimum of f and FVAL = f(z).

The argument F is the name of a user defined subroutine that has the format: CALL F(n, X,F VAL) Here X is an array of dimension n containing a point x = (z1,...,%,), and FVAL is a variable. F sets FVAL to the value of the function f at the point z. F must be declared in the calling program to be of type EXTERNAL.

RERR is an input argument that specifies the relative accuracy of F. If it is estimated that the subroutine F produces results accurate to k significant digits then one may set RERR = 10-*. It is required that RERR > O. If RERR = 0 then it is assumed that F produces results accurate to machine precision.

When OPTF is called, line search iteration is performed to find the local minimum of f. ITER is a variable. On input, ITER is the maximum number of iterations that are permitted. When the routine terminates, ITER = the number of iterations that were actually performed.

WK is an array of dimension n(n + 8) or larger that is a work space for the routine.

```text
IND is a variable that reports the status of the results. When the routine terminates,
IND has one of the following values:
```

IND = —1 (Input error) n < 0.

IND = ~2 (Input error) n = f.

IND — —4 (Input error) ITER < 0.

IND = -5 (Input error) Either RERR < 0 or RERR > 1074.

IND = 1 A local minimum x was found. The gradient of f at x was considered to be sufficiently small.

IND = 2 The steps taken became so small that OP'TF had to terminate. X is probably a local minimum, but it need not be a local minimum. The algorithm frequently requires exceedingly small steps to be taken, no matter whether X is close to or far from a local

minimum.

IND = 3 A local minimum has possibly been found. OPT could not find a point for which f would take a smaller value.

IND. 4 ITER iterations were performed.

IND - 5 The algorithm appears to be diverging This generally occurs

when f is unbounded from below.


<small>Original source: [View scanned PDF page 308](scans/page_0308.png)</small>

When an input error is detected, the routine immediately terminates.

Accuracy and Efficiency. OPTF is frequently extremely efficient in finding a value FVAL which roughly approximates a local minimum value f(z), but at times it can be quite slow in obtaining FVAL to greater precision. A rough approximation is often obtained in 20--30 iterations. If f(z) # 0 then FVAL may be accurate to 4-6 significant digits after 20-30 additional iterations, or FVAL may not be accurate to 1 significant digit after several hundred iterations. 4-6 digit accuracy is the greatest precision that can be expected. In general, it is recommended that ITER < 200. Each iteration can take considerable time, even if the subroutine F is cheap to evaluate.

**Remark.** OPTF can be quite sensitive to the scaling of the variables (z,,...,2,). The routine tends to operate more efficiently when the components of a local minimum z = (z1,...,%n) are all roughly of the same magnitude. If the components are of considerably different magnitudes (say |x| * 107° and |x2| » 105) then convergence may be extremely slow. In such a case, OP TF attempts to rescale the variables, but the rescaling is not always helpful.

**Algorithm.** The line search algorithm given in pp. 325-327 of the reference is employed. Also, BFGS secant updates for the hessian are used.

**Programming.** OPTF employs the subroutines OPTDRV, OPCHK1, OPSTe’, FXDEC, SCALEX, LLTSLV, FSTOFD, FSTOCD, LNSRCH, SECFAC, QRUPDT, and JROT. OPTF, FXDEC, and SCALEX were written by A.H. Morris. The remaining subroutines were written by Robert B. Schnabel (University of Colorado at Boulder) and modified by A.H. Morris. The functions SDOT, SNRM2, and SPMPAR are also used.

**Reference.** Dennis, J.E. and Schnabel, R.B., Numerical Methods for Unconstrained Optimization and Nonlinear Equations, Prentice-Hall, Englewood Cliffs, NJ, 1983.


<small>Original source: [View scanned PDF page 309](scans/page_0309.png)</small>

<a id="topic-309-01"></a>
### Unconstrained Minimum Of The Sum Of Squares Of Nonlinear Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LMDIFF` | `SUBROUTINE` | `FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA` | [`L81464`](source_parts/nswc_part_08.f90#L7566) |


Let fi(z), ...,fm(z) be m real-valued functions of n real variables x = (zy, ...,2,) where m > n. The problem under consideration is to find a point x which minimizes the bid

```text
function ¢(z) = 5° fi(z)*. Assume that each f,(z) is differentiable and that an initial
i=1
```

guess a = (a), 1.5 Qn) to a minimum of ¢(z) is given. Then the following subroutine is available for finding a point which minimizes ¢(z).

```fortran
CALL LMDIFF(FCN, M, N, X, FVEC, EPSFCN, TOL, INFO, IWA, WA, LWA)
```

X is an array of dimension n and FVEC an array of dimension m. On input X contains the starting point a = (a;,...,a,). When LMDIFF terminates, X contains the final estimate 7 = (21, ...,%n) of a minimum of ¢ and FVEC contains the values of the functions fy, ...,f/m at the output point in X,

The argument F is the name of a user defined subroutine that has the format: CALL F(m,n, X, VEC, IFLAG)

Here X is an array of dimension n, FVEC an array of dimension m, and IFLAG an integer variable. The array X contains a point x = (z1,...,%n). Normally F evaluates the functions f,,..., fm at this point and stores the results in FVEC. However, if < does not lie in the domain of f1,..., fm then this cannot be done. In this case, the argument IFLAG (which will have been assigned a nonnegative value by LMDIFF) should be reset by F to a negative value. This will signal LMDIFF to terminate. F must be declared in the calling program to be of type EXTERNAL.

EPS is an input argument which specifies the relative accuracy of F. If it is estimated that the subroutine F produces results accurate to k significant decimal digits then one may set, EPS = 10-*. It is required that EPS > 0. If EPS = 0 then it is assumed that F produces results accurate to machine precision.

TOL is an input argument which specifies the desired accuracy to be attained. The Euclidean norm ||z|| = \/2,2? is employed. If ¢ denotes an actual minimum of ¢, then LMDIiFF terminates when an iterate x is generated for which it is estimated that

(1) O(z) < (1 + TOL)?$(z) or

(2) || D(z ~ #)|| < TOL - || Dz|| is satisfied. In (2) z and & are regarded as column vectors, and D is a diagonal matrix generated by LMDIFF whose entries are scaling factors. For convenience, criterion (1) is called the F-convergence (or ¢-convergence) test and criterion (2) is called the z-convergence test. It is required that TOL > 0. In order for the convergence tests to work properly, it is recommended that TOL always be smaller than 10° ®,

IWK is an array of dimension n and WK is an array of dimension @. IWK and WK y

are work spaces. It is assumed that @ > mn + 52 tom.


<small>Original source: [View scanned PDF page 310](scans/page_0310.png)</small>

INFO is an integer variable that reports the status of the results. When LMDIFF terminates, INFO has one of the following values:

INFO <0 This occurs when the user terminates the execution of LMDIFF by resetting the argument IFLAG in the subroutine F to a negative value. Then INFO = the negative value of IFLAG.

{NFO =: 0 (Input error)! <n < m,EPS > 0,TOL > O,or 2> mn +5n+-n ig violated.

INFO =1 The F-convergence test has been satisfied.

INFO = 2 The z-convergence test has been satisfied.

INFO =: 3 The F-convergence and z-convergence tests have been satisfied.

INFO = 4 The gradient of ¢ is O at point X.

INFO =5 The number of calls to the subroutine F has reached or exceeded 200(n + 1).

INFO =6 TOL is too small. No further reduction in the value of ¢(z) is possible.

INFO = 7 TOL is too small. No further improvement in the accuracy of X is possible.

When LMDIFF terminates, if INFO + 0 then X contains the final iterate that was generated. Also, if INFO > 1 then FVEC contains the values of the functions f;,..., fm at this iterate. If INFO = 4 then X should be examined very closely. The gradient of ¢ can be 0 when X is a local minimum or maximum, or when X is a saddle point. If INFO = 5 then it may (or may not) be helpful to continue the procedure by recalling LMDIFF with the current point in X as the new starting point. Since TOL is a relative tolerance, this setting can occur when $(0) = 0.

**Algorithm.** A modified form of the Levenberg-Marquardt algorithm is employed.

**Programming.** LMDIFF is a slightly modified version of the MINPACK-1 subroutine LMDIF1. The MINPACK-1 subroutines LMDIF, SPMPAR, ENORM, FDJAC2, LMPAR, QRFAC, and QRSOLV are employed. The subroutines were written by Jorge J. More, Burton S. Garbow, and Kenneth E. Hillstrom (Argonne National Laboratory).

References,

(1) More, J. J., Garbow, 8. S., and Hillstrom, K. §., User Guide for MINPACK-1, Argonne National Laboratory Report ANL- 80-74, Argonne, Illinois, 1980.

(2) More, J. J., “The Levenberg-Marquardt Algorithm: Implementation and Theory,” Numerical Analysis, G. A. Watson {ed.), Springer-Verlag, 1977.


<small>Original source: [View scanned PDF page 311](scans/page_0311.png)</small>

<a id="topic-311-01"></a>
### Linear Programming

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SMPLX` | `SUBROUTINE` | `A, B0, C, KA, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [`L83727`](source_parts/nswc_part_08.f90#L9829) |
| `SSPLX` | `SUBROUTINE` | `TA, ITA, JTA, B0, C, M, N0, IND, IBASIS, X, Z, ITER, MXITER, NUMLE, NUMGE, BI, WK, IWK` | [`L84676`](source_parts/nswc_part_09.f90#L1) |


Let A = (¢,;;) be an mx n matrix, B an array containing 61, ...,6m, and C an array containing cy, ...,¢€, where a,;,6,,c; are real. Consider the problem of finding nonnegative values 21, ...,2, which maximize or minimize the function cy7y +-++° + en2, subject to the constraints:

4112) +++ + Qintn{S,=, >} by

Amity tet @mntn{S, =, > Son

In each constraint O12, +++? + Ain tn{<, =, 2}5,

only one of the relations <,=,> is used, but the relation may vary from constraint to constraint. The following subroutines are available for solving this problem.

CALL SMPLX(A, B,C, ka, m,n, IND,IBASIS, X, z, ITER,MXITER, NUMLE,NUMGE,BI,WK,IWK)

CALL SSPLX(TA,ITA,JTA, B,C, m,n, IND,IBASIS, X, z, ITER,MXITER, NUMLE,NUMGE,BI,WK,IWK)

Jt is assumed that m > 2,n > 2, and that each b; > 0. If SMPLX is called then ka is the number of rows in the dimension statement for A in the calling program. Otherwise, if SSPLX is called then TA, ITA, JTA are arrays containing the transpose matrix A‘ in sparse form.

The constraints a,;z7, +--+: - + GinIn{<, =, ~}b; are assumed to be ordered so that the < constraints are followed by the > constraints, and the = constraints come last. NUMLE and NUMGE have the values:

NUMLE =: the number of < constraints.

NUMGE =: the number of > constraints.

It is assumed that NUMLE > 0, NUMGE > 0, and NUMLE + NUMGE «< mu.

When SMPLX or SSPLX is called, the routine attempts to maximize S,¢,1, subject to the constraints. A modified form of the primal simplex algorithm is employed. Frequently the procedure requires less than 5 iterations to perform the task. The argument MXITER has the value:

MXITER + the maximum number of iterations that may be performed. This argument is provided by the user. The related argument VPER is a variable that is set. by the routine. When the routine terminates, PPER has for its value the number of iterations that were performed. IND is a variable and fRASIS an array of dimension ma. ERASIS contains Che indices of the current basic variables zy, and END) is used for input/output purposes. On it put IND is normally set by the user to 0. if END Q then the routine selects its own


<small>Original source: [View scanned PDF page 312](scans/page_0312.png)</small>

beginning basis and stores the appropriate indices in IBASIS. [The remainder of this paragraph may be skipped by anyone not acquainted with the simplex algorithm.| If the user wishes to use his own beginning basis, then IND must be set to 1 and the indices of the initial basic variables stored in IBASIS. It ts not required that the initial basts be selected so that the baste variables are nonnegative. The initial basic variables may be original, slack, surplus, or artificial variables. Slack and surplus variables are automatically provided for the < and > constraints, and artificial variables for the = constraints. The routine defines z,,,,; to be the slack, surplus, or artificial variable for the ¢** constraint 4512, +++: + Qintn{<,=, >}b;. lf IND = 0 then the slack, surplus, and artificial variables are the initial basic variables that are employed.

On output [ND reports the status of the results. The routine assigns IND one of the following values:

IND =0 The problem was solved.

IND = 1 The problem has no solution.

```text
IND = 2 MXITER iterations were performed. More iterations are needed.
IND = 3 Sufficient accuracy cannot be maintained to solve the problem.
IND = 4 The problem has an unbounded solution.
```

IND = 5 An input error was detected. (See below)

IND =: 6 A possible solution was obtained. The routine is not certain if the solution is correct.

X is an array of dimension n + NUMLE -++ NUMGE and z is a variable. If IND = 0 or IND = 6, then z has for its value the maximum value obtained for D,c;z,; and X contains the values obtained for the original, slack, and surplus variables. If IND #4 5 then IBASIS contains the indices of the basic variables currently in effect when the routine terminates.

BI is an array of dimension m? that is used for storing the inverse of the basis matrix. The order of the column vectors of the basis matrix corresponds to the order of the basic variables given in IBASIS. If IND #4 3,5 on output then BI contains the inverse of the basis matrix currently in effect when the routine terminates.

WK is an array of dimension 2m: or larger, and [WK is an array of dimension 2m +n or larger. WK and IWK are work spaces,

**Input Errors.** IND 5 occurs on output when one of the following conditions is violated:

(1) n > 2 and ka om > 2.

2) NUMLE + NUMOIB ©) pre.

3) Bach 6, > 0.

4) ‘The basis matrix specified by the user in EBASIS (when IND 1 on input) is nonsingular and sufficiently well conditioned so that its inverse can be computed.

( ( (

**Remarks.** (EH) ASA CPA WPA PPA are not modified by the routines (2) ‘The routines maximize Soeja,0 Phos function can be minimized by maximizing (0 e,)0,

and then change the sign of the result

alt


<small>Original source: [View scanned PDF page 313](scans/page_0313.png)</small>

(3) SMPLX and SSPLX generate the same results. For efficiency, SSPLX should be used

when A is sparse.

Algorithm. A three step procedure is used. The first step eliminates the negative variables. Then phases (1) and (2) of the primal simplex algorithm are invoked. Negative variables are eliminated as follows: Let 751, ...,2Bm be the basic variables and y,,; the components of the simplex tableau.

(1)

(2)

Compute d; = U{y,; for each nonbasic variable x; where the sum Zi is for ali ts wh ve rp, < 0. If ail d; > 0 then the problem has no feasible solution. Otherwise, select k so that d, = min,d;. Then x, is the variable to be made basic.

If tg; > 0 and y,, > O for some 7 then go to (3). Otherwise, select a negative variable <p, to become nonbasic where zp,/yrx = max{zp;/yj~ 2B; < Oand y;_ < O}. Then update the basis and go to (5).

Compute € = minizg,/¥j% : TB; > O and y,,4 > O} and check if a negative variable rp; exists that satisfies the conditions:

(«) yye <O and « > rp;/y;n

If such a variable exists then go to (4). Otherwise, select a nonnegative variable zg, to become nonbasic where y,, > 0 and rp,/y,-~% = €. Then update the basis and go to (1). Select a negative variable 23, to become nonbasic where tp,/yrx = max{zp;/Yjk : Zp; < Cand zp; satisfies(*)}. Then update the basis and go to (5).

Check if there are any remaining negative variables. If not, then we are finished. Otherwise go to {1).

**Programming.** SMPLX and SSPLX employ the subroutines SMPLX1, SSPLX1, and CROUTI. These routines were written by A. H. Morris. The function SPMPAR is also used,


<small>Original source: [View scanned PDF page 314](scans/page_0314.png)</small>

<a id="topic-314-01"></a>
### The Assignment Problem

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ASSGN` | `SUBROUTINE` | `N, A, C, T, IWK, IERR` | [`L85906`](source_parts/nswc_part_09.f90#L1231) |


Let C = (¢,;) be ann x n matrix (the cost matrix). The problem under consideration

n Lay is to find an n x n matrix x = (z,,) which minimizes T = 3> Y° c,,z,, and satisfies: s=1 y--1

(1) So xy, 5 bP for j-1,...,n tro]

(2) Soa, - fort -1,...,n

g=l 3) Each x,,~ Our 1 3

Bach x which satisfies (1)-(3) is called an assignment. For each such z, from (1) and (3) we note that for each 7 there exists a unique integer x(j)} such that Ix(3},7 = 1. Also, (2) and (3) assert that ~ is a permutation of {1,...,n}. Conversely, for any permutation 7

there corresponds an assignment. z defined by Tx ( 1 and z,, = O fors # w(y). Thus,

9).2 n the problem is to find a permutation » of {1,...,n} which minimizes T —~ 3° Cx(y),7- The gol following subroutine is available for solving this problem when all Cy, are integers.

```fortran
CALL ASSGN(N, A, C, T, IWK, IERR)
```

C is a 2-dimensional integer array of dimension n x (n + 1), JC an integer array of dimension n, and 7 an integer variable. It is assumed that n > 2 and that the first. n columns of © contain the cost matrix (c,,). [The (nm + 1)" column of C is a work space for

When ASSGN ts called, the desired permutation 7 is obtained and the values

the routine. a(1),..., a(n) stored in JC Also Tis assigned the minimized value LCs),

IWK is an array of dimension 7n + 2 or larger that is a work space for the routine.

IRR ows a variable that is set by the routine. If JC and 7 are obtained then IERR is assigned the value OQ) Otherwise, if the problem cannot be solved because of integer overflow,

then IERR I.

```text
Remarks.
(1) Cois destroyed by the coutine
(2) ASSGN tmuintimizes 7 Pag) Phis function can be maximized by minimizing
```

MC eye, ,) and then changing the sign of the result Programming ASSGN calls the subroutine ASSGNE ASSGNI was written by Giorgia Carpaneto and Paolo Toth (University of Bologna, Italy), and modified by AH. Morris The function EPMPAR is also used Reference ( Carpanero. (0 and Toth. be, “Algorithm S48.) Solution of the Assignment

Probie.” ACA Trans Aath Software ti (U8) pp lod TLE

tle


<small>Original source: [View scanned PDF page 315](scans/page_0315.png)</small>

<a id="topic-315-01"></a>
### 0-1 Knapsack Problem

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MKP` | `SUBROUTINE` | `N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM` | [`L86214`](source_parts/nswc_part_09.f90#L1539) |


Given n > 2 items, each having a profit p; > 0 and weight w; > 0, and m > 1 containers (knapsacks), each having a capacity k, > 0. Let z,; = 1 if item 7 is assigned to knapsack 1. Otherwise, let z;; == 0. Then the problem is to find an assignment z,; of the

m on items to the knapsacks which maximizes 0 = )> 5) p,2,; subject to s=ls=1

(1) SO wyay; < ke for f= 1,...,m, and

m (2) 33 a5 <1 for g=1,...,n.

Condition (2} states that each item may be assigned to a (single) knapsack or be rejected. It can be assumed, without loss of generality, that

(a) the knapsacks are ordered so that ky <+++ < km,

(b) min{ wy,..., wy } < ki,

(c) max{wy,...,Wn} < km, and

(d) do yh. wy > kn.

Then the following subroutine is available for solving this problem when all p,;, w,, and k, are positive integers.

```fortran
CALL MKP(N, M, P, W, K, BCK, XSTAR, VSTAR, WK, IWK, NUM)
```

P and W are integer arrays containing pi,...,Pn and w,,...,w,, and K an integer array containing ky,...,k,. £ is an integer array of dimension n or larger, and o an integer variable. When MKP is called, if no input errors are detected then the maximum value for o is obtained. Also, L(j) = 1 if item 7 has been assigned to knapsack ¢ (7 = 1,...,n)}, and L(j) = 0 if item 7 does not appear in the solution (i.e., if 2; = +++ = an; = 9).

A depth-first tree search employing backtracking is used. if no bound is placed on the number of back tracks that may be performed, then the exact maximum a 3s assured. However, if the number of back tracks must be restricted, then only an approximation to the maximum may be obtained. The argument NBCK is available for limiting the backtracking. NBCK is a variable. On input, if NBCK = -1 then no restrictions are placed on the backtracking. Otherwise, if NBCK # ~—1, then it is assumed that NBCK is the maximum number of back tracks that are permitted. When the routine terminates, NBCK <= the number of back tracks that were actually performed.

TEMP 1s a real array of dimension n or larger, and I'TEMP an integer array of dimension NUM. It is assumed that NUM > 5m 4 14n-+4mn-+ 3. TEMP and ITEMP are work spaces for the routine. It should be noted that TEMP is the only argument of MKP that is not of integer type.

**Error return.** If an input error is detected then @ 148 set to one of the following values:

od -Lifrn es Lorn < 2.


<small>Original source: [View scanned PDF page 316](scans/page_0316.png)</small>

o = ~—2 if some p;,w,, or k; is not, positive.

o = —8 if min{wy,...,wa} > ki; ie. if a knapsack cannot contain any item.

go —4 if max{wi, ..., Wp} > km; Le., if an item cannot fit in any knapsack.

o=—5 if Djw,; < kn; ie., if knapsack m can contain all the items.

o = ~7 if the knapsacks are not ordered so that ky <--- < ky.

o0 = -8 if NUM < 5m+ l4n+ 4mn4 3.

Backtracking. For NBCK = —1, the time required for finding the exact maximum depends primarily on the value of m, and can increase quite dramatically for very small increases in the value of m. It is recommended that this setting never be used when m > 10. Instead, if m > 10 then a setting of NBCK < 50 frequently suffices.

**Programming.** MKP employs the subroutines MKP1, S(GMA1, PI1, PARC, SKNP, and SKNP1. The interface subroutine MKP was written by A.H. Morris. The remaining subroutines were written by Silvano Martello (University of Bologna) and Paolo Toth (University of Florence) and modified by A.H. Morris. The subroutine RISORT is also used.

**Reference.** Martello, S. and Toth, P.,“Algorithm 632. A Program for the 0-1 Multiple Knapsack Problem,” ACM Trans. Math Software 11 (1985), pp. 135-140.


<a id="category-317"></a>
## Transforms

<small>Original source: [View scanned PDF page 317](scans/page_0317.png)</small>

<a id="topic-317-01"></a>
### Inversion Of The Laplace Transform

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LAINV` | `SUBROUTINE` | `MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR` | [`L87231`](source_parts/nswc_part_09.f90#L2556) |


Let f(t) be a complex-valued function that is continuous for t > 0 except possibly at a countable set of values t, having no finite limit points. Then for complex z the Laplace transform F(z) of f(t) is defined by

F(z) = i e** f(t) dt

when the integral converges. If the integral converges for Re(z) > c but does not exist for Re(z) < c, then c is called the abscissa of convergence of F(z). If [5° |f(t}le~* dt < co for some real constant a, then F(z) is analytic for all z where Re(z) > a. Also, for any point t for which f(i) is continuous and sufficiently well-behaved, the value f(t) can be obtained from F by the inversion formula

1 a+tT

{i =— li eR(Ad\ (f= V-1)

\- li Qn T-+00 awT

for any a > a. If f(t) is real for t > 0, then F(z) = F(Z). Given a transform F(z) where F(z) = F(z), then the following subroutine is available for computing f(t) for t > 0.

```fortran
CALL LAINV(MO, FUN, T, AERR, RERR, Y, C, ERROR, NUM, IERR)
```

Ty is assumed that F(z) = F(z). The argument FUN is the name of a user defined subroutine for computing F(z). FUN has the format: CALL FUN(z, y, A, B) A and B are variables. For real arguments z and y, A and B are assigned the values A = Re[F(x + iy)] and B = Im[F (zc + ty)]. FUN must be declared in the calling program to be of type EXTERNAL.

IERR is a variable that is used both for input and output purposes. If TERR > 0 on input then it is assumed that the abscissa of convergence is known and that ¢ = the abscissa of convergence. Otherwise, if IERR< © then the abscissa of convergence must be computed. In this case, c is a variable. LAINV sets c to the value that is obtained for the abscissa of convergence.

MO is an integer which specifies the search procedure to be used for finding the abscissa of convergence c when TERR < 0 on input. A one-pass procedure is employed when MO # 0, and a two-pass procedure when MO =: 0. Normally, the one-pass procedure should be used. However, if all the singularities of F(z) are known to be real, then the two-pass procedure (MQ == 0) will be more efficient.

It is assumed that t > O and that Y is a variable. When LAINV is called ¥ is set to the value obtained for f(£).

AERR and RERR are the absolute and relative error tolerances to be used in computing

M(t) (AERR > 0 and RERR > 0). If one wants accuracy to k significant digits then set RERR -- i0°*. WRERR | 0 then it is assumed that f(t) is to be computed to machine


<small>Original source: [View scanned PDF page 318](scans/page_0318.png)</small>

accuracy. LAINV attempts to find a value Y which satisfies |Y — f]| < max{ AEFRR,RERR-

f(t) }.

ERROR and NUM are variables that are set by the routine. When LAINV terminates, ERROR is a rough estimate of the absolute error |¥ — f(t}| and NUM is the number of calls that were made to the subroutine FUN.

When LAINV terminates, IERR reports the status of the results. IERR is assigned one of the following values:

IERR = 0 Y was obtained to the desired accuracy.

JERR = 1 Y was obtained, but it may not be accurate because of inaccuracy in the computation of c. This setting occurs only when IERR < 0 on input.

TERR = 2 Y could not be obtained, possibly because too much accuracy was requested. Increase AERR and RERR, and rerun the problem.

IERR = 3 Y could not be obtained, possibly because of inaccuracy in the computation of c or too much accuracy was requested. Increase AERR and KERR, and rerun the problem. This setting occurs only when IERR < 0 on input.

IERR = 4 (Input error) The argument ¢ is not positive. Y and ERROR are assigned the values 0 and 1.

```text
IERR = 5 The abscissa of convergence c could not be found in the interval
[-10*, 104]. Y, c, and ERROR are assigned the values 0, 0, and
1. This setting occurs only when IERR < 0 on input.
```

JERR = 6 The argument ¢ 1s too large for f(t) to be computed. Y and ERROR are assigned the values O and t.

**Remarks.**

```text
(1) Accuracy decreases when ¢ is near a discontinuity of f(t).
(2) The calculation may lose accuracy or fail when F(t) is oscillatory.
```

**Algorithm.** Given c, f(#) is computed by a modification of the subroutine DLAINV developed by R. Piessens and R. Huysmans, where the real Wynn ¢-algorithm has been replaced with the complex Wynn ¢-algorithm.

When JERR < 0, ¢ is calculated by the subroutine ABCGN or the subroutine AB- CONT. In ABCON, which is a two-pass search procedure, the abscissa z, of the rightmost.

singularity in the strip ~104 < x < 10%, |y| < .O1 is first determined. Then the abscissa of the rightmost singularity in the half-plane Re(z) > 21 18 found. In ABCONL these calculations are cornb‘ned into a single-pass procedure.

In ABCON and ABCONI], the function F(z)/(z~ 21-4 1)? is integrated along paths Cy and Cy defined as follows: C) is the straight line segment from (2,,0) te (zy, 01), followed by the straight line segment from (xy, 01) to (co,.01), and C’y is the straight line segment from (21,00) to (x;,0), followed by the straight line segment from (71,6) to (00,0). ‘The integral along Cy vanishes if no singularity lies to the right of ry in the strip fy} OF, and the integral along (2 vanishes if no singularity tes im Re(e) = ay. Otherwise, these

integrals are nonzero in most applications. Siipson’s rule suffices for integrating along the


<small>Original source: [View scanned PDF page 319](scans/page_0319.png)</small>

finite line segment from (21,0) to (zy, 01).

**Example.** Let F(z) = 1/(1+ 27), in which case f(t) = sint. The following code may be used for computing f(t) at ¢ = 1,1.1,1.2,...,1.9 and storing the results in the array W.

REAL W(10) EXTERNAL FT

AERR. = 1.E-30

RERR = 1.E-12

IERR = --1

T=10

DO 101 = 1,10 CALL LAINV (1, FT, T, AERR, RERR, W(i), C, ERR, N, IERR) IF (IERR .GT. 1) STOP T=T+01

10 CONTINUE

Here FT may be defined by:

SUBROUTINE FT(X, Y, A, B) COMPLEX Z,W

‘?)

Z = CMPLX(X,Y)

```text
W = 1.0/(1.0 + Z++2)
A = RWAL{W)
```

B:= AIMAG(W) RETURN

DND

**Programming.** LAINV employs the subroutines ABCON, ABCONI, SRCH, ACOND, XCOND, LAINV1, CQEXT, QAG/1, QAGIEI, QELG, QK15/1, @PSRYT, CDIVID, CREC and functions ACONDF, ACONDG, XCONDX, XCONDY, SPMPAR, EXPARG. LAINV and ARCON were written by Andrew H. van Tuy! (NSWC) and modified by A.H. Morris. ABCONI was written by A.H. Morris. LAINV1I was written by Robert Piessens and Rudi Huysmans (University of Leuven, Herverlee, Belgium) and modified by Andrew van Tuyl. QAGIL is a modification of QAGI by Andrew van Tuyl and A.H. Morris.

Preference. Piessens, R. and Huysmans, R., “Algorithm 619. Automatic Numerical Inversion of the Laplace Transform,” ACM Trans. Math Software 10 (1084), pp. 348-353.


<small>Original source: [View scanned PDF page 320](scans/page_0320.png)</small>

<a id="topic-320-01"></a>
### Fast Fourier Transform

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FFT` | `SUBROUTINE` | `C, N, ISN, IERR` | [`L89305`](source_parts/nswc_part_09.f90#L4630) |
| `FFT1` | `SUBROUTINE` | `A, B, N, ISN, IERR` | [`L89322`](source_parts/nswc_part_09.f90#L4647) |


Let n be a positive integer and 6; = 2xj/n for 7 = 0,1,...,n — 1. For any complex valued functions f and g defined on the points 6; let (f,g) = >I f(8;) 9(0;). Then (f,g) is an inner product when f and g are regarded as functions defined only on 6,;. Also e29(7 = 0, i, ...,2—1) form an orthogonal set of functions where each e*?* has norm \/n.' Thus, if f is 2 function that is approximated by f(#) = DI c,e'7® then each cy = 4{f (6), e7%). The

j=0 mapping f(8;) + ¢,; given by

ale

n-l - > f(O,)e7 27IR/" k=0

cj; >=

is called the discrete Fourier transform and its inverse

n—-I . f(8;) _- > cpet™ takin k=0 the inverse discrete Fourier transform. The following subroutines are available for computing these transforms.

```fortran
CALL FFT(C, N, ISN, IERR)
CALL FFT1(A, B, N, ISN, IERR)
```

Let c; = a, +1b,(7 = 0,1, ...,n - 1) be the data to be transformed. If FFT is called then C is a complex array containing ¢o,¢1,..-,¢n—1 (where C(j + 1) = c,; for 7 < n). Otherwise, if FFT1 is called then A and B are real arrays containing ao,4,, .-.,;@,—4 and bo, b1, ...,b,_1 respectively.

The argument @ may have the values 1 or —1, and IERR is a variable. When FFT or FFT I is called, if there are no input errors then IERR is set. to 0 and

n-l tik a... 5 Qn Cy, = Dp, cperry in k=0

is computed. The results é; -- @, | 6, replace the original data c, = a, +46; in C (or A

and B).

Restrictions on the argument n. When FFT and FFT! are called, n is factored by the routine into its prime factors. It is assumed that the largest prime factor of nis < 28. If n~ p?’n where n is the square free portion of n, then it is further assumed that n < 210 whenever nis a product of two or more primes.

Throughout this section a / E.


<small>Original source: [View scanned PDF page 321](scans/page_0321.png)</small>

**Error Return.** If an input error is detected then IERR is set as follows:

IERR =1 ifn <1,

IERR = 2 if n has too many factors.

IERR = 3 if n has a prime factor greater than 23 or the square free portion of n is greater than 210,

IERR = 4 if @4 41.

The setting IERR = 2 can occur only when n > 4251528.

**Remark.** The complex array C is interpreted by FFT as a real array of dimension 2n. If this association is not permitted by the FORTRAN being employed then use FFT'1.

**Programming.** FFT and FFT! are interface routines for the subroutine SFFT, which was written by Richard C. Singleton (Stanford Research Institute).

**Reference.** Singleton, R. C., “An Algorithm for Computing the Mixed Radix Fast Fourier Transform,” IEEE Trans. Audio and Electroacoustics, vol. AU-17T (1969), pp. 93-103.


<small>Original source: [View scanned PDF page 322](scans/page_0322.png)</small>

<a id="topic-322-01"></a>
### Multivariate Fast Fourier Transform

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MFFT` | `SUBROUTINE` | `C, N, NDIM, ISN, IERR` | [`L89334`](source_parts/nswc_part_09.f90#L4659) |
| `MFFT1` | `SUBROUTINE` | `A, B, N, NDIM, ISN, IERR` | [`L89372`](source_parts/nswc_part_09.f90#L4697) |


```text
Let nj, ...,%m be positive integers. For any J = (j1, ---:Jm) Where j, =0,...,n,—1
(v = 1,...,m) let 6; denote the point (2*j,/ny, ..+,2%jm/nm). Also, for any complex
valued functions f and g defined on the points 6, let (f,g) = Dy f(8s) 9(07). Then (f,9)
is an inner product when f and g are regarded as functions defined only on 97. Also the
functions $;(0) = exp(ij,6')---exp(iz,9”) form an orthogonal set where each gy has the
norm \/nj-"-fim.’ Thus, if f is a function that is approximated by f = Dycy¢y then each
cy = al (f,¢7). The mapping f(¢7) ++ cy given by
```

ey =-+— oy S(O) exp(—2atj, ki /ny) +--+ exp(—2atjnkm/Mm)

nyo Nm

is called the discrete multivariate Fourier transform and its inverse f(87) = ox ew exp(2at71ky/ny,)+-- exp(27tjmkm /Nm)

the inverse discrete multivariate Fourier transform. The sums Dx are for all K = (ky, ...,4m) where ky = 0,1,...,n, -1(v = 1, ...,m). The following subroutines are available for computing these transforms.

```fortran
CALL MFFT(C, N, NDIM, ISN, IERR)
CALL MFFT1(A, B, N, NDIM, ISN, IERR)
```

Let cy = ay + 1b, be the data to be transformed where J = (g:, ---)Jm) for gp = 0,1,...,.2, -1 (v = 1,...,m). If MFFT is called then C is a 1-dimensional complex array containing the values cy where cy = C(1+ 9, +jony t+ jgnyng +--+ + ImM1°°* m1). Otherwise, if MFFT1 is called then A and B are 1-dimensional real arrays containing the data ay and by respectively.

**Note.** If MFFT is used and m = 2 or 3, then instead of having to store the m-dimensional data cy into a 1-dimensional array C, the data may be stored in C where C is defined to be an m-dimensional array. If m= 2 then C may be declared to be of dimension ny X na, in which case C(j: + 1,972 + 1) = cy for all J ~ (51,32). Similarly, if m = 3 then C may be declared to be of dimension n, x ng x ns, in which case Cait byge + 1,93 + 1) = cy for all J > (91, 92,3). Similar comments hold for A and B if MFETL is employed.

N is an array containing the integers nj, ...,n,,. The argument @ may have the values 1 and -1, and IERR is a variable. When MFFT or MFFT' is called, if there are no input errors then TERR is set to 0 and the transform

6, > Don crexp(2a lrg ky/ny) -- exp(27bt jn ky /tm )

is computed. The results éy ~ a) | tb) replace the original data cy ay} tb, in Co (or A and #3).

‘Throughout this section + Land @ (6), 22,0) denotes an arbitrary point.


<small>Original source: [View scanned PDF page 323](scans/page_0323.png)</small>

Restrictions on the arguments nj, ...,%m. When MFFT and MFFT1 are called, each n, is factored by the routine into its prime factors. It is assumed that the largest prime factor of n, is < 23. Ifn, = pwn, where fi, is the square free portion of n,, then it is further assumed that fi, < 210 whenever ni, is a product of two or more primes.

**Error Return.** If an input error is detected then IERR is set as follows:

IERR = 1 if some n, < 1.

IERR = 2 if some n, has too many factors.

[ERR = 3 if some n, has a prime factor greater than 23 or the square free portion of some n, is greater than 210.

IERR = 4 if 24 +1.

IERR = 5 if nm < 0.

The setting JERR == 2 can occur only when some n, > 4251528.

**Remark.** The complex array C of dimension ny--+n,, is interpreted by MFFT as a real array of dimension 2n,--+n,,. If this association is not permitted by the FORTRAN being employed then use MFFTi.

**Programming.** MFFT and MFFT1 are interface routines for the subroutine SFFT, which was written by Richard C. Singleton (Stanford Research Institute).

**Reference.** Singleton, R. C., “An Algorithm for Computing the Mixed Radix Fast Fourier Transform,” IEEE Trans. Audio and Electroacoustics, vol. AU-17 (1969), pp 93-103.


<small>Original source: [View scanned PDF page 324](scans/page_0324.png)</small>

<a id="topic-324-01"></a>
### Discrete Cosine And Sine Transforms

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `COSQI` | `SUBROUTINE` | `N, WSAVE` | [`L90026`](source_parts/nswc_part_09.f90#L5351) |
| `COSQF` | `SUBROUTINE` | `N, X, WSAVE` | [`L90092`](source_parts/nswc_part_09.f90#L5417) |
| `COSQB` | `SUBROUTINE` | `N, X, WSAVE` | [`L90190`](source_parts/nswc_part_09.f90#L5515) |
| `SINQF` | `SUBROUTINE` | `N, X, WSAVE` | [`L90294`](source_parts/nswc_part_09.f90#L5619) |
| `SINQB` | `SUBROUTINE` | `N, X, WSAVE` | [`L90364`](source_parts/nswc_part_09.f90#L5689) |


Let n be a positive integer and 0, = (v +1/2)x/n for vy = 0,i,...,2-—1. For any “a real valued functions f and g defined on the points 6, let (f,g) = p> f(8.) 9(6.). Then (f,g) is an inner product when f{ and g are regarded as functions defined only on 6,.

```text
Also cos j@ (7 = 0,1,...,n — 1) form an orthogonal set of functions where cos j@ has
norm 2 when j = 0 and norm \/n/2 when j > 1. Thus, if f is a function that is
```

n-1 approximated by f(9) = ao + 25> a;cos 7@ then each a; = +(f(6),cos 70). The mapmal

3 ping f(0,) ++ a; is called the discrete cosine transform and its inverse a; ‘+ f{(6,} the inverse discrete cosine transform.

Alternatively, the functions sin 7@ for 7 = 1, ...,n also form an orthogonal set where sin 7? has norm /n/2 when Z < rand norm Ja when jzn. Thus, if f is » function that

is approximated by f(0) = 2 by by sin 3@ + 5, sin n@ then each 6; = +(f(),sin j9). The

mapping {(@,) by i is called ‘the discrete sine transform and its inverse b; +> f(0,) the inverse discrete sine transform.

The subroutines COSQB and COSQF are available for computing the discrete cosine transform and its inverse, and the subroutines SINQB and SINQF are available for computing the discrete sine transform and its inverse. The subroutine COSQI provides information that is needed for the cosine and sine transform routines.

```fortran
CALL COSQI(N, WSAVE)
```

WK is an array of dimension 3n 4+ 15 or larger that is a work space for the routines COSQB, COSQF, SINQB, and SINQF. COSQI stores in WK information needed for the fast Fourier computation of the discrete cosine and sine transforms and their inverses. A preliminary call must be made to COSQI before COSQB, COSQF, SINQB, and SINQF can be used. After this preliminary call, COSQ!] need only be recalled when n is modified.

**Programming.** COSQ! employs the subroutines REF TL and REETHL. These routines were written by Pau) N. Swarztrauber (National Center for Atmospheric Research, Boulder,

Colorado). CALL COSQB(n, X, WK)

Nos an array of dimension sm oor larger. On input it is assumed that X contains the data f(9o), f(@1), .. f{(8n aj}. When COSQB is called, 4na, is computed and stored in X(7) f)fory¢ O,b,.. oye oF.

Wits an array of dimension $n ¢ 15 or larger that is a work space for the routine. WR must be set up by Gis routine COSQI before COSQB can be used.

ALO


<small>Original source: [View scanned PDF page 325](scans/page_0325.png)</small>

**Programming.** COSQB employs the subroutines COSB1, RFFTB, RFFTB1, RADB2, RADB3, RADB4, RADBS, and RADBG. These routines were written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

```fortran
CALL COSQF(N, X, WSAVE)
```

X is an array of dimension n or larger. On input it is assumed that X contains the data a9, 41, ...,@,-1. When COSQF is called, f(9,) is computed and stored in X({v + 1) for vy =0,1,...,n -1.

WK is an array of dimension 3n + 15 or larger that is a work space for the routine. WK must be set up by the routine COSQI before COSQF can be used.

**Example.** Assume that X contains the data f(90), ...,f(@,-1). When the statements CALL COSQI(n,WK) CALL COSQB(n, X,WK) CALL COSQF(n, X,WK) are called, COSQB stores 4nao, ...,4na,_1 in X and COSQF then sets X{v+1) = 4nf(@_) for vy = 0,1,...,n — 1. Thus, the terms of the original sequence X are multiplied by 4n.

**Programming.** COSQF employs the subroutines COSQF1, RFFTF, RFFTF1, RADF2, RADF3, RADF4, RADF5, and RADFG. These routines were written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

```fortran
CALL SINQB(N, X, WSAVE)
```

X is an array of dimension n or larger. On input it is assumed that X contains the data f(90), ...,f(@n—1). When SINQB is called, 4nb, is computed and stored in X(j) for geel,...,n.

WK is an array of dimension 3n-| 15 or larger that is a work space for the routine. WK must be set up by the routine COSQI before SINQB can be used.

**Programming.** SiNQB calls the subroutine COSQB. SINQB was written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

```fortran
CALL SINQF(N, X, WSAVE)
```

X is an array of dimension mn or larger. On input it is assumed that XY contains the data 6;,...,6,. When SINQF is called, f(0.) is computed and stored in X(v + 1) for

yo O,f, ee. ym oT.

WK is an array of dimension Gn + 15 or larger that is a work space for the routine, WK must be set up by the routine COSQI before SINQF can be used.

**Example.** Assume that X contains the data 6,,... 26,0 When the statements CALL COSQI(n, WK) CALL SINQF(n, 8 WK) CALL SINQB(n, Y¥ WH)


<small>Original source: [View scanned PDF page 326](scans/page_0326.png)</small>

```text
are called, SINQF stores f(@),...,f(@,-1) in X and SINQB then sets X(j) = 4nb, for
j=1,...,n. Thus, the terms of the original sequence X are multiplied by 4n.
```

**Programming.** SINQF calls the subroutine COSQF. The routine SINQF was written by Paul N. Swarztrauber (National Center for Atmospheric Research, Boulder, Colorado).

AST


<a id="category-327"></a>
## Approximation of Functions

<small>Original source: [View scanned PDF page 327](scans/page_0327.png)</small>

<a id="topic-327-01"></a>
### Rational Minimax Approximation Of Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CHEBY` | `SUBROUTINE` | `A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q, ERROR, IERR, W` | [`L91712`](source_parts/nswc_part_09.f90#L7037) |


Let a < 6 and g(x) be a continuous nonvanishing function on the interval [a,b]. For any continuous function f(z), let |{f|| denote the weighted norm maz{|f(z)|/|g(z)| : a <x < b}. Also let ¢(2) be a continuous strictly monotonic mapping on [a, 6]. Then for any nonnegative integers € and m, the subroutine CHEBY is available for finding a rational function

R(x) = £2 + prd(z) +++ + ped(z)* qo + q19(z) + +++ + 4mG(z)™

which minimizes || — f||. The subroutine performs the calculations in double precision. It is assumed that the error curve (2) = (R(z) — f(z))/g(x) satisfies |6(z,}| = ||R — f|| at precisely £+ m-+ 2 critical points ro < 41 < --- < 2,(n = 2+ m-+1), and that 6(2,41) = —6(z,) for each t <n.

CALL CHEBY(a, 6, F,G, PHI, ¢, ITER,MXITER, £, m, P,Q, ERROR,IERR,WK)

The arguments a and 6 are double precision real numbers. F, G, and PHI are functions whose arguments and values are double precision real numbers. The functions must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL. The functions evaluate f(r), g(x), and ¢(z) respectively.

The argument ¢ is a double precision tolerance that is supplied by the user. If \ denotes the estimated value of || ~ f{], then the routine converges when the error curve 6(z) satisfies A(i - ©) < [6(z,5)| < ACL 4 ©) for each z,. Thus ¢ specifies the relative agreement that must be attained between ||f -- Ri] and the |5(z,)|. Normally the setting «© © 10°74 will give satisfactory results. It is required that 0 < ¢ < 10 ?.

The Remes-type algorithm designed by Cody, Fraser, and Hart is employed. This algorithm normally requires less than 20 iterations. The argument MXITER — the maximum number of iterations that may be performed. This argument is set by the user. The related argument ITER is an integer variable that is set by the routine. When CHEBY terminates, ITER will have for its value the number of iterations that were actually performed.

P is a double precision array of dimension @{ 1, Q a double precision array of dimension m-+1, ERROR a double precision variable, and JERR an integer variable. When CHEBY terminates, if the rational function approximation A(z) has been obtained then He RR is assigned the value 0 and ERROR is the estimated error (f/f ][. The coefficient p, of the numerator of R(s) is stored in P(r } 1) for s O,1,... 2, and the coefficient gq, of the denominator is stored in Q(7 fot) for py Ob... pa “Phe coefficient qa will always have

the value 1.

Leth @ fang 2. Then Whois a double precision array of dimension ACR ¢ S) or larger

that is used for a work space.


<small>Original source: [View scanned PDF page 328](scans/page_0328.png)</small>

**Error Return.** IERR is assigned one of the following values when the desired minimizing rational function A(z) is not obtained.

```text
iERR = 1 An input error was detected. Either £< 0,m < 0,€ < 0,€ > 107?,
or g(z) = 0 for some point z.
```

IERR = 2 MXITER iterations were performed. More iterations are needed to obtain R(z). The system of linear equations that define the coefficients p,; and q,; was found to be singular. This indicates that for the current values of £ and m, the numerator and denominator of A(z) may have common factors. A nonmonotonic sequence of critical points z; was obtained. Modify 2 and/or m. The value of the error curve 6(x) at some critical point z; appears to be too large. This indicates that A(z) may have poles, and that m (or possibly a or 6) may have to be modified.

IERR =: 6 CHEBY completely failed to find (or roughly approximate) R(z).

All information in P,Q, and ERROR should be ignored.

If IERR = 2,3,4, or 5 then P and Q contain the coefficients of the most recent rational] function approximation R(z) obtained, and ERROR is an estimate of the error ||R — f|| of the approximation.

IERR

il es

IERR

ll an

IERR :

li uo

**Remark.** The two most common weighting functions employed are g(x) = 1 and g(z) = f(x). If g(x) = 1 then the absolute error is minimized in constructing A(z). If g(z) = f(z) then the relative error is minimized.

**Programming.** CHEBY employs the subroutines CHEBY1, CERR, and DPSLV. These routines were written by A. H. Morris. CHEBY, CHEBY1, and CERR are slightly modified translations of the ALGOL 60 procedures Chebychev, lineq, del, and surmis given in the

**reference.**

Reference, Cody, W. J., Fraser, W., and Hart, J. F. “Rational Chebychev Approximation using Linear Equations,” Numerische Mathematik 12 (1968), pp. 242 251,


<small>Original source: [View scanned PDF page 329](scans/page_0329.png)</small>

<a id="topic-329-01"></a>
### Lp Approximation of Functions

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ADAPT` | `SUBROUTINE` | `F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS, COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT, KDIFF, VALLFT, VALRGT` | [`L92102`](source_parts/nswc_part_09.f90#L7427) |


For any continuous real-valued function f(z) defined on the interval [a,b], let ||f|I, denote the Z, norm defined by

file = (2 Le (ei? day ff I<p<oo

([fllp= max{|f(z)|:@<a2<b} if p=oo. If p = oo then the norm is also known as the Chebyshev norm. For any continuous function f, 0 < p < oo, and € > O, the subroutine ADAPT 1s available for finding a continuous piecewise polynomial function ¢ that satisfies |j/f — @||, < €.

CALL ADAPT(F, a, 6, ¢, k, ERROR,XKNOTS, C, IND, y, n, £, ANORM, DX,MO,m,XBREAK,KDIFF ,DLEFT,DRIGHT)

It is assumed that the polynomials which form the approximation ¢ are of degree < n. The argument n must satisfy 1 <n < 19, and IND is a variable. When ADAPT is called, if there are no input errors and ¢ is successfully constructed, then IND is set to 0, a sequence of points a = zy < +++ < 2e_y < ry = 5 is selected, and ¢ takes the form

```text
P(r) = cso + ea (e— 2y)+-++en(2— 2)" 4 SoS a4
fors=1,...,k—1. The points 2,,. .,2, are called the knots (or nodes) of ¢.
```

The argument yz is the maximum number of polynomials that may be used :n forming @. ERROR and & are variables, XKNOTS an array of dimension p+ 1 or larger, and C a 2-dimensional array of dimension pz x (n +1). ADAPT sets & to the number of knots that are generated. The knots 21, ...,2, are stored in the XKNOTS array, and the coefficients Cic, ---yCin are stored 3: C(t,1),...,C(i,n +1) fort = 1,...,k — 1. FRROR is a rough estimate of the error ||f — ¢]|p.

The argument @ specifies the degree of smoothness that the approximation ¢ must satisfy. it is assumed that 0 < @< 10 and n > 2é. If @ == O then it is only required that @ Ye continuous on the interval [a,6]. Otherwise, if @ > 1 then it is assumed that f is of class C'f on [a,}] except at possibly a finite number of points (called break points), and it is required that ¢ be of class C* on [a,b] except possibly at the break points.

The argument mi specifies the number of break points of f. It 1s assumed that m < 20. If mn = O then the arguments XBREAK,KDIFF,DLEFT, and DRIGH'S can be ignored. Otherwise, ifm > 1 then it is assumed that XBREAK,KOIFF DLEFT, and DRIGHT are arrays of dimension m or larger, and that

XBREAK(s) © the i break point, call it uy,

K DIFF (+) the smallest integer v, for which the vu" derivative of f does not exist or is not continuous at u,, DLEFT(s) the value from the left f the vf" derivative at v,, and DRIGHT(:) the value from the right of the v.* derivative atu, for: ot, ...,ma tas also assumed that as uy eo -++ So uy ct Gand no Qe, for each oy.


<small>Original source: [View scanned PDF page 330](scans/page_0330.png)</small>

F is the name of a user defined function that has the value F(z, D) = f(z) fora < x < 6. If 2 = 0 then 1 can be ignored. (However, D must still be given as an argument of /’.) Otherwise, if 2 > 1 then D is an array of dimension greater than or equal to @. For any x not a break point in XBREAK, the user must set D(j) = the j** derivative of f at x for j < €. However, if x = XBREAK(s) then the user need only set. D(7) = the j** derivative of f at z for J < KDIFF(#). The function F must be declared in the calling program to be of type EXTERNAL.

The argument DX specifies the maximum distance to be permitted between the knots a;, and the argument ASIORM specifies the norm to be used. Set ANORM = +£1.0 for Ly approximation. ANORM = +2. for Lz (least. squares) approximation. ANORM = 3.0 for £.. (minimax) approximation. ANORM = ~-pfor L, 0 < p< oc) approximation.

ll

Before considering the argument MO, one should be briefly acquainted with how ADAPT operates. ADAFT employs the following procedure to construct ¢.

(1) Set I = [a,b] and & = 1. Let a be the first knot of ¢.

(2) If the interior of i contains no break points then go to (3). Otherwise, if J = [c,d] then partition J into the subintervals [c,u] and [u,d] where u is the smallest. break point greater than c. Stack the right subinterval {u,d] and reset I to [{c, ul.

(3) Construct a polynomial ¢; on J using Hermite interpolation. If the length of the interval Tis < DX and ¢, satisfactorily approximates f on J, then go to (4). Otherwise go to

(4) Set k to be K+ 1. Let dy; be the (kK — 1)* polynomial forming ¢ and let the right end point of J be the k** knot of d. If the interval stack is empty then the procedure is finished. Otherwise, obtain from the stack the next interval I to be considered and return to (2).

(5) The polynomial ¢; cannot be used. Partition 4 into halves, stack the right subinterval and reset J to be the left subinterval. Then go to (3).

The argument MO specifies the accuracy criterion that che approximation ¢ ig to satisfy on a subinterval I == [c,d] of (a, 6]. It is assumed that MO = 0,1,2. If the L., norm is used

then MC is ignored! and ¢ is required to satisfy | f(z) — d(z)| <« fer e < 2 < d. Otherwise,

if the Lp, (0 < p < o) norm is used then ¢ is required to satisfy:

d doe / Lf (2) - p(x) [P da = hogs for MO =. O ad | \f(z) - b(a)/P deo for MO: 2

The setting MO © 0, which is the most commonly used setting, requires the total error

oy Hf ty < «. The alternate setting MO. 2 employs ¢ to control local accuracy. If ¢ consists of kT polynomials then the total error If bil, (& HP Phis setting can

THowever, it ds still required that MQ - 0,1,2


<small>Original source: [View scanned PDF page 331](scans/page_0331.png)</small>

be useful when f is rough. A (heuristic) compromise strategy is provided when MO = 1. At each step in the formation of ¢, the MO = 1 strategy estimates the total number of subintervals that will finally be needed and adjusts the error requirement for the subinterval I accordingly. This strategy attempts to keep the total error to a minimum while relaxing the local accuracy criterion demanded by the MO = 0 setting.

**Remarks.** IND, &, »,n, €, MO, m, and KDIFF are integer arguments. All other arguments (including F) are double precision arguments.

**Error Return.** ADAPT assigns IND cone of the following values:

IND = 0 The approximation was successfully constructed.

IND = —1 Hither a > 6 or one of the arguments €, n, 2, ANORM, MO, m is assigned an incorrect value.

IND = —2 [a,}] is too small an interval.

IND = ~3 DX is less than (b — a)/y. Since only y subintervals can be used and each subinterval must be of length < DX, the interval |u, 6] cannot be covered. Make DX or yp larger.

IND = —4 The restriction a < uy < +--+ < ty < 5 on the break point» is violated.

IND = --5 Either KDIFF(:) <0 or KDIFF() > (n ~ 1)/2 for some ¢.

IND = J ADAPT selected 4: +1 knots. More knots are needed to complete the problem.

IND = 2 A subinterval J = [c,d] must be partitioned into subintervals [c, u] and |u,d] where u is a break point. However, this cannot be done either because the interval stack is full, or partitioning will produce too small an interval. (The stack can hold only 50 subintervals).

IND = 3 A subinterval must be partitioned because its length is greater than DX. However, this cannot be done since the interval stack is full.

IND = 4 A subinterval must be partitioned so that the accuracy criterion

can be satisfied. However, this cannot be done either because the stack is full, or partitioning will produce too small! an interval.

If an input error is detected (i.e., if IND < 0) then no cornputation is performed. Otherwise, if IND > O then when ADAPT terminates k := the number of knots generated, XKNO'US contains the knots, C contains the coefficients of the polynomials generated, and EathOR contains the error estimate for f ~- ¢ over the interval covered.

**Remarks.**

(1) if the Z,, norm is used then ¢ controls absolute accuracy, not relative accuracy. This should be kept in mind when ¢€ is to be set for any Lp norm.

(2) ADAPT requires more time when £ > 2 than when € ~~ O or 1. However, the choice of the norm normally has little effect on the efficiency of the routine.

(8) ADAPT can yield excellent results even when the derivatives of f have singularities. The one major exception is when the first derivative of fis not bounded. Then the routine can be expected to fail.


<small>Original source: [View scanned PDF page 332](scans/page_0332.png)</small>

**Example.** The following code can be used for approximating f(r) = e” on the interval (0, 1).

DOUBLE PRECISION Ff, A, B, EPS, ERROR, ANORM, DX DOUBLE PRECISION XKNOTS (11), C(16,20) INTEGER KDIFF(1) DOUBLF PRECISICN XBREAK(1),DLEFT(1),DRIGHT(1) EXTERNAL F DATA MAX, A, B, DX/19, 0.D0, 1.D0, 1.D0/ N=8 L=1 EPS = 1.D-12 ANORM == 3.D0 CALL ADAPT(F,A,B,EPS,K ,ERROR,XKNOTS,C,IND, * MAX,N,L,ANORM,DX,0,0,XBREAK,KDIFF,DLEFT,DRIGHT)

Here F° may be defined by:

DOUBLE PRECISION FUNCTION F(X,D) DOUBLE PRECISION X,P(1)

F == DEXP(X)

D(1) =

RETURN

END

In the ADAPT statement XBREAK, KDIFF, DLEFT, and DRIGHT are ignored since m= 0,

**Programming.** ADAPT employs the subroutines ADAPT1, ADSET, ADTAKE, ADCOMP, NEWTON, ADCHK, ADPUT, ADTRAN and functions ERRINT, POLYDD. These routines exchange information in labeled common blocks. The block names are 1NPUTZ, RESULZ, KON'TRL, and COMDIF. The routines were written by John R. Rice (Purdue University) and modified by A. H. Morris. The function DPMPAR is also used.

**References.**

(1) Rice, J. R.,“Algorithm 525. ADAPT, Adaptive Smooth Curve Fitting,” ACM Trans. Math Software 4 (1$78), pp. 82-94.

(2) _, “Adaptive Approximation,” J. Approx. Theory 16 (1976), pp. 329-337.


<small>Original source: [View scanned PDF page 333](scans/page_0333.png)</small>

<a id="topic-333-01"></a>
### Calculation Of The Taylor Series Of A Complex Analytic Function

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CPSC` | `SUBROUTINE` | `F, Z, N, IC, TOL, R, RS, ERR` | [`L93320`](source_parts/nswc_part_09.f90#L8645) |
| `DCPSC` | `SUBROUTINE` | `FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR` | [`L93592`](source_parts/nswc_part_09.f90#L8917) |


Let f(z) = 37 an(z — zo)” denote the Taylor series of an analytic function f around

n>0 a point 2). Then the subroutines CPSC and DCPSC are available for obtaining the coefficients a, of the series. CPSC obtains single precision results and DCPSC obtains double precision results.

```fortran
CALL CPSC(F, Z, N, IC, TOL, R, RS, ERR)
```

it is assumed that f(z) is a user defined function whose arguments and values are complex numbers. The argument f must be declared in the calling program to be of types COMPLEX and EXTERNAL.

The argument zo is complex, n is an integer where 1 < n < 51, and Ais a complex array of dimension n or larger. IND may be any integer. If IND == 0 then a, is computed and stored in A(j +1) for j = Q,1,...,n — 1. Otherwise, if IND # 0 then {(zo) and the derivatives f'(zo), ...,f'"-1)(z9) are computed and stored in A.

The argument € specifies the relative accuracy of f. If it is estimated that f produces results accurate to k significant decimal digits then one may set ¢ = 10-*. It is assumed that ¢ > O. If « = 0 then the results of f are assumed to be correct to machine precision,

When CPSC is called, {(z) is «valuated on circles of various radii around the point zo. R is a real variable. On input, # is the radius of the first circle on which f(z) is to be evaluated. After using this radius, the radius is repeatedly modified {first by factors of 2 or 1/2) until a suitable final radius r, is obtained for deriving the values cf the coefficients a;. This radius, whose value depends on e, is called the computational radius of the series Ya;(z -- zo)". When the routine terminates, F is assigned the value r,.

ERR is a real array of dimension n or larger. On output, ERR(j) is the estimated absolute error of A(j) for j = 1,...,n.

Usage. Given a radius R, f(z) is evaluated on k equidistant points on the circle of radius R around zg where k= & when bin <6, k= 16 when 7 <n < 12, kw 82 when $3 <n < 25, k = 64 when 26 <n < 51. it is assumed that f(<) has at least one nonzero coefficient a, among the first k/2 coefficients, and at least one nonzero coefficient among the next k/2 coefficients. Thus, the routine should not be used to obtain coefficients of a low degree polynomial such as f(z)eo 1 ~ 2%, In such cases, the results will normally be incorrect, In general, the selection of the radius Roof tie first circle on which f (2) is evaluated is not bothersome. A randomly selected value of moderate size, such as A 6.2738, almost

AB9


<small>Original source: [View scanned PDF page 334](scans/page_0334.png)</small>

always suffices. No difficulties normally arise when the initial radius R is greater than the radius of convergence of the series Na;(z ~ zo)?. However, difficulties do arise when

(1) the routine attempts to evaluate f too close to (or exactly at) a singularity,

(2) f has a Taylor series expansion which contains one or more extremely large isolated terms (e.g., f(z) = 10° + sinz),

(3) f has a branch point near zo, or

(4) The initial radius R is too far from the computational radius r, (see the error return section below).

The risk of (1) occurring is minimized by the random selection of an initial radius R. For (2) and (3), a severe loss of accuracy can occur when a large number of coefficients are requested. In these cases, any loss of accuracy is reported by the ERR array.

Error return. A(j) is assigned the value 0 and ERR(j) is set to 10!° for 7 = 1,...,n when the initial radius R differs from r, by a factor of 30000 or greater.

**Programming.** CPSC was written by Bengt Fornberg (California Institute of Technology) and modified by A.H. Morris. CPSC employs the function SPMPAR.

**References.**

(1) Fornberg, B.,“Numerical Differentiation of Analytic Functions,” ACM Trans. Math Software 7, 1981, pp. 512-526.

(2) sis “Algorithm 579. CPSC: Complex Power Series Coefficients,” ACM Trans. Math Software 7, 1981, pp. 542-547.

```fortran
CALL DCPSC(FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR)
```

F is the name of a user defined subroutine that has the format: CALL F(z, y, u,v) This subroutine is used for evaluating f(z) at point z. The arguments x and y are the real and imaginary parts of z, and u and v are the real and imaginary parts of f(z). The arguments x and y have double precision values, and u and v are double precision variables. F must be declared in the calling program to be of type EXTERNAL.

The arguments x9 and yo, which have double precision values, are the real and imaginary parts of z9. The argument n is an integer where 1 < n < 51, and AR and AI are double

real and imaginary parts of a, are stored in AR(j +1) and AI(j+ 1) for 7 =0,1, ...,n—- 1. Otherwise, if IND # 0 then the real and imaginary parts of f(zo) and the derivatives f'(zo), - wy f(z) are stored in AR and AI respectively.

The argument ¢, which has double precision values, specifies the relative accuracy of the subroutine F. If it is estimated that # produces results accurate to k decimal digits then one may set ¢ ~ JO°*. It is assumed that « > O. Ife © O then the results of F are assumed to be correct to machine precision.

When DCPSC is called, f(z) is evaluated on circles of various radii around the point zo. fis a double precision variable. On input, A is the radius of the first circle on which


<small>Original source: [View scanned PDF page 335](scans/page_0335.png)</small>

f(z) is to be evaluated. After using this radius, the radius is repeatedly modified (first by factors of 2 or 1/2) until a suitable final radius r, is obtained for deriving the values of the coefficients a;. This radius, whose value depends on ¢, is called the computational radius of the series Da,(z — zo)?. When the routine terminates R is assigned the value rg.

ERR is a double precision array of dimension n or larger. On output, ERR(j) is the estimated absolute error of the complex value stored in AR(j) and Al{j) for j= 1, ...,n.

Usage. DCPSC is used in the same manner as CPSC. See the usage section for CPSC.

**Error return.** AR(j) and AI{j) are assigned the value 0 and ERR(j) is set to 161° for j=1,...,n when the initial radius R differs from r, by a factor of 30000 or greater.

**Programming.** DCPSC is an adaptation by A.H. Morris of the subroutine CPSC, written by Bengt Fornberg (California Institute of Technology). (31CPSC employs the function DPMPAR.

**References.**

(i) Fornberg, B.,“Numerical Differentiation of Analytic Functions,” ACM Trans. Math Software 7, i981, pp. 512-526.

(2) __, “Algorithm 579. CPSC: Complex Power Series Coefficients,” ACM Trans. Math Software 7, 1981, pp. 542-547.


<a id="category-336"></a>
## Curve Fitting

<small>Original source: [View scanned PDF page 336](scans/page_0336.png)</small>

<a id="topic-336-01"></a>
### Linear Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TRP` | `FUNCTION` | `A, N, X, Y` | [`L93896`](source_parts/nswc_part_09.f90#L9221) |


Let a be a real number and (21,41), ...,(%n, Yn) @ sequence of points. The following function performs a linear interpolation at point a.

```fortran
TRP(A, N, X, Y)
```

It ia assumed that n > 2 and 2] < +++ < a. X and ¥ are arrays containing the abscissas 21, ..., 2, and ordinates y;, ...,Yn respectively. TRP(a,n, X,Y) = 6 where b is the value of the interpolation at a.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 337](scans/page_0337.png)</small>

<a id="topic-337-01"></a>
### Lagrange Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LTRP` | `SUBROUTINE` | `M, X, Y, N, XI, YI, NI, T, IERR` | [`L93937`](source_parts/nswc_part_09.f90#L9262) |


Let {(z:,yi:): $ = 1,...,n} be a set of n > 2 points where 21 < +++ < 2,,m be an integer where 2 < m < n, and £1,...,%,% be k > 1 points at which m point Lagrange interpolation is to be performed. The subroutine LTRP is available for performing this interpolation.

```fortran
CALL LTRP(M, X, Y, N, XI, YI, NI, T, IERR)
```

X is an array containing :t),...,2,, Y an array containing y;,...,y,, XI an array containing %;,...,Z,, and YI an array of dimension k or larger. When LTRP is called, if no input errors are detected then interpolation is performed at each Z; and the result stored in YI(j) for 7 = 1,...,k.

T is an array of dimension m or larger. The array is used as a temporary storage area by the routine.

**Error Return.** JERR is a variable that is set by the routine. If no input errors are detected then IERR is assigned the value 0. Otherwise, IERR is assigned one of the following values:

```text
IERR = 1 ifm < 2.
IERR =2 ifm>n.
IERR =3 ifk <1.
```

When an error is detected LE RP immediately terminates.

**Algorithm.** If z; = (x; -+2;4m)/2 for some #, then (z,, ys), ..-,(Zs4m—1) Yit¢m—1) are the m data points used in the Lagrange interpolation at Z;. Otherwise, the data points selected for the interpolation are those m points (2,, yi) whose abscissas are closest to Z,.

Linear Interpolation. For m = 2, if the abscissae x; are not equally spaced then LTRP can produce different results than the linear interpolating function TRP. If z; lies in the interval [7,;,2;,1) then TRP always uses the data points (2,,y;) and (241, Y%41) to find the interpolated value at z;. However, the operation of LTRP is somewhat different. For example, if the point Z; in (2, . 7;1.1) is closer to 2,;_1 than to 2,44, then (z;_1, y—1) ane (z;,y:) will be the data points employed in the interpolation. Thus, TRP will normally be the procedure that will be desired for linear interpolation.

**Programming.** Developed by A. H. Morris. The portion of the code for finding the subinterval containing £; was written by Rendall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 338](scans/page_0338.png)</small>

<a id="topic-338-01"></a>
### Hermite Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HTRP` | `SUBROUTINE` | `N, X, Y, A, T, IERR` | [`L94114`](source_parts/nswc_part_09.f90#L9439) |


Let r1,...,%% be k > 1 distinct points. For each x; assume that we are given nj > 1 values y;, yi, we yl ) ifn = nm, +--+: + n,, then there exists a unique polynomial of degree n -— 1 which satisfies

```text
Pas) = ys
p(23) = y
```

for each t = 1, ...,4. The subroutine HTRP is available for obtaining this polynomial.

```fortran
CALL HTRP(N, X, Y, A, T, IERR)
```

```text
X and Y are arrays of dimension n containing the following information: X(7) =
zy for j = 1,...,ny and Y(1),...,¥ (m1) contain the values y, ,y}, ey ye, For
t= 2,...,k let my = ny +--+ + ny. Then X(m +7) = x for j = 1,...,n; and
```

Y(m, +1), ...,¥(m,-+ n,)} contain the values y;, y/, ..., yr,

A is an array of dimension n and JERR an integer variable. When HTRP is called, if no errors are detected then IERR is assigned the value O and the coefficients a, of the

n-1

```text
polynomial p(x) = ao + 55 a;(z—- X(1)}--- (2 — X(z)) are computed and stored in A(j +1)
jg=1
```

for 7 =0,1,...,n-—1

WK is an array of dimension n or larger that is a work space for the routine.

**Error Return.** If an error is detected then IERR is assigned one of the following values:

TERR = 1 The argument n is not positive.

TERR = 2 There exists integers 1 and @ for which X/s) = X(@) but X(t) # X(j) for some j where t < 7 < @. In this case, the values t and & are stored (in floating point form) in WK(i) and WK(2).

When an error is detected, the routine immediately terminates

```text
Example. If ;(G) = 2, p(--1) = 1, and p'(~1) = 2 where x, = 0 and 22 = ~-1, then HTRP
stores 2,1,-1lin A. Hence, p(z) = 2+ 7% — 2(z + 1) is the desired polynomial.
```

n-1 Remark. ‘The Newton representation ag >> a;(z - X(1))---(z@~ X(y)) of the polynomial gal n— p(z) can be converted to the Taylor series representation > c,(z ~ a}? by the subroutine gra

PCOEFF

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 339](scans/page_0339.png)</small>

<a id="topic-339-01"></a>
### Conversion Of Real Polynomials From Newton To Taylor Series Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PCOEFF` | `SUBROUTINE` | `ALPHA, N, X, A, C, T` | [`L94169`](source_parts/nswc_part_09.f90#L9494) |


n—-1 For n > 1 let p(z) = ag + SD a;(x - 21)--- (a — z;). Then for any real number a, y=l the subroutine PCOEFF is available for converting the polynomial p(z) to the Taylor series

n-1 . form >> ¢,(z — @)?. jg=0

```fortran
CALL PCOEFF(ALPHA, N, X, A, C, T)
```

X is a single precision real array containing 21, ...,%,— 1, A a single precision real array containing @9,4@), ...,@,—1 where a, is stored in A(j +1) for 7 = 0,1,...,n-—1, and C a single precision real array of dimension n or larger. When PCOEFF is called then the coefficients c; of the Taylor series representation are computed and stored in C(j + 1) for 7=0,1,...,2-1.

T is a double precision array of dimension n or larger. The array is a work space for the routine. (The conversion of the coefficients is done in double precision.)

**Note.** A and C may reference the same storage area, in which case the results c; will overwrite the input data a;.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 340](scans/page_0340.png)</small>

<a id="topic-340-01"></a>
### Least Squares Polynomial Fit

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PFIT` | `SUBROUTINE` | `ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR` | [`L94201`](source_parts/nswc_part_09.f90#L9526) |


Let {(2;,4;):# = 1,...,m} be a set of m > 2 points where 2; 4 xz; for i #7. Then for any positive integer n where n<m, the subroutine PFIT is available for obtaining the

```text
(unique) nt} degree polynomial p(z) = > a;z? which minimizes x (p(zs) ~ ys)?.
g==0
```

```fortran
CALL PFIT(ND, NP, X, Y, A, RNORM, PHI, PHIX, IERR)
```

X is an array containing 21,...,2%m, Y an array containing y1,...,¥m, and A an array of dimension n+ 1 or larger. RNORM and JERR are variables. When PFIT is called, if no input errors are detected then IERR is set to 0, the coefficients a, of p(x) are stored in A(j +1) for 7 =0,1,...,n, and RNORM is assigned the value Jds(p(z;) — ys)?.

PHI is an array of dimension 2(n + 1) or larger, and WK is an array of dimension 4m or larger. PHI and WK are work spaces for the routine.

**Error Return.** JERR =1 ifn <lorn>m.

**Algorithm.** The abscissas x; are first mapped into values in the interval [-1,1]. Then the Forsythe procedure is used.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 341](scans/page_0341.png)</small>

<a id="topic-341-01"></a>
### Weighted Least Squares Polynomial Fit

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `WPFIT` | `SUBROUTINE` | `ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR` | [`L94362`](source_parts/nswc_part_09.f90#L9687) |


Let {(2,,y:) : # = 1,...,m} be a set of m > 2 points where 2, 4 x; fort #7, and let w, > O(1 = 1, ...,m) be weights. It is assumed that m,, > 2 where m, is the number of nonzero weights. For any positive integer n where n < m,, the subroutine WPFIT is

bi . available for finding the (unique) n‘® degree polynomial p(z) = )>ajz7 which minimizes

mm 3=0

Ls ws(p(zs) — yi)?.

=

```fortran
CALL WPFIT(ND, NP, X, Y, W, A, RNORM, PHI, PHIX, IERR)
```

X is an array containing 41, ...,2m, Y an array containing yi,...,ym, W an array containing w;,...,wWm,, and A an array of dimension n + 1 or larger. RNORM and IERR are variables. When WPFIT is called, if no input errors are detected then IERR is set to 0, the coefficients a; of p(x) are computed and stored in A(j +1) for 7 = 0,J,...,n, and RNORM is assigned the value \/D,;w,(p(z;) — yx)?.

PHI is an array of dimension 2(n + 1) or larger, and WK is an array of dimension 4m or larger. PHI and WK are work spaces for the routine.

**Error Return.** IERR = 1 ifn <lorn> my, and IERR = 3 if some w, is negative.

**Algorithm.** The abscissas zx; corresponding to the positive weights are first mapped into values in the interval [—1,1]. Then the Forsythe procedure is used.

**Programmer.** A. H. Morris.


<small>Original source: [View scanned PDF page 342](scans/page_0342.png)</small>

<a id="topic-342-01"></a>
### Cubic Spline Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CBSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR` | [`L94542`](source_parts/nswc_part_09.f90#L9867) |
| `SPLIFT` | `SUBROUTINE` | `X, Y, YP, YPP, N, W, IERR, ISX, A1, B1, AN, BN` | [`L94682`](source_parts/nswc_part_09.f90#L10007) |


Given z; < +--+ < ay. A function f(z) is a cubic spline having the nodes(knots) Z1,...,;%y if f is a polynomial of degree < 3 on the interval [z,,2;41] fori =1,...,n—-1, and the first and second derivatives f’(2) and f(x) exist and are continuous for all z. If f{; denotes the polynomial for the interval [z;, 2,41] then f; has the form:

fi(z) = yt ac(x — 2;) + by(z ~— 2)? + oy (2 — 2,)%.

Consequently, the function f is obtained by fitting the polynomials f,, ..., fx—1 together at the points 72,...,¢%,-1. For 2 < 2, f(z) = fi(z), and for x > 2, f{z) = fa_i(z). Also f(z.) = ys for? =1,...,n—1. Hence, if f(z.) = y, then f interpolates the points (z,, y;) fort 1,...,n.

Assume now that the ordinates y;,...,Y, are given. Then there exist an infinitude of splines with nodes 21, ..., 2, that interpolate the points (2,,y,). In general, two independent conditions must be imposed to uniquely specify the interpolating spline f which is of interest. Frequently, f is restricted on the first interval [x1,22] by requiring that f(x) or f(z) has a given value, or that f is continuous at zz. Also, f is restricted on the last interval [z,_1,2,] by requiring that f’(z,) or f’(z,) has a given value, or that f is continuous at 2,1. The subroutine CBSPL is available for obtaining the spline when these restrictions are employed. Alternatively, f may be required to satisfy the conditions

{"(a1) = af"(z2) 1 B lal < 1

when n > 4. Then the subroutine SPLIFT is available for obtaining the spline. CALL CBSPL(X,Y, A, B,C, n,t1,%2, wi, wz, TERR)

X and Y are arrays containing the abscissas 21, ...,2,, and ordinates yy, -.., Yn. It is assumed that rp. 77) so 2, andr 3. A,B and C are arrays of dimension mn or larger, and TERR an integer variable. When CBSPL is called , if no input errors are detected then IERR is set to OQ. Also, the coefficients ay,d,e. (8 1,0... 1) of the interpolating spline {(2) are stored in A,B,C, and A(n) is set to f'(r,,).

The arguments 1,,%2, tw), wy specify the conditions that the spline f(z) must satisfy. tt

is assumed that t) and rg have the values O,1,2 where:

tO fis continuous at ry. t, O fos continuous at or, 7. 1) ! f'(r1) has the value wy), Ly ! f'(4,) has the value us). ty 2 of" (ry) has the value wy. ty 2 f(r) has the value w,,

Ifa, Othen the argument wy as ignored, and ifa, O then wy is ignored

**Error Return.** TERR bafas SambleRR 2afar, cory. for somes


<small>Original source: [View scanned PDF page 343](scans/page_0343.png)</small>

**Remarks.**

( ) B(n) and C(n) are used for temporary storage.

(2) Ift; =%2 =O and n = 3, then it is also assumed that f'(ze} + f'(zg) = 2( He =¥2).

(3} After A,B and C have been obtained, then SCOMP or SCOMP1 may be used to evaluate the spline at any point z. SEVAL or SEVAL1 may be used if derivatives are

also desired.

**Programming.** CBSPL is an adaptation by A. H. Morris of the subroutine CUBSPL, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978. CALL SPLIFT(X, Y, DY,DDY,n,W, IERR,MO, «, 8, &, 8)

X and Y are arrays containing the abscissas 71, ...,z,, and ordinates y1,..., Yn. It is assumed that 7; < +--+ <2, andn> 4. DY and DDY are arrays of dimension n or larger, and IERR an integer variable. When SPLIFT is called, if there are no input errors then IERR is assigned the value 0, the first derivatives f’(7,),.... f'(a,) are computed and stored in DY(1),...,DY(n), and the second derivatives f"{11),...,f"(zn) are computed and stored in DDY(1), ..., DDY(n).

W is an array of dimension 3n or larger that is used for a storage area. On the first call to SPLIFT the argument MO must be set to 0. When SPLIFT is initially called, certain calculations which depend only on the values of a, @, and 21, ...,2%, are performed and the results stored in W. On subsequent calls to SPLIFT, if only values of @,8 or y1,...,Yn are modified, then the information in W need not be recomputed. Set MO = 1 and the information in W will be reused.

Error Return if there is an input error then {ERR is set as follows: IERR = 1 if {aj > Lor jal > 1. IERR = 2 ifn < 4. TERR = 3 if the restriction 2; < +++ < x, 1s not satisfied. Remarks.

1) After DY and DDY have been obtained, then SCOMPL or SCOMP2 may be used to evaluate the spline at any point 2. SEVALT or SEVAL2 may be used if derivatives are also desired.

(2) Given the values y) and y!. Then there exists a unique interpolating cubic spline f that satisfies f’(z,) - y) and f'(rn) > yf. This spline can be obtained by setting ass ao = 1/2 and

ty +1 | 72 ry ry | .

**Programmer.** Rondall 2. Jones (Sandia Laboratories),

fe


<small>Original source: [View scanned PDF page 344](scans/page_0344.png)</small>

<a id="topic-344-01"></a>
### Weighted Least Squares Cubic Spline Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPFIT` | `SUBROUTINE` | `X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR` | [`L94851`](source_parts/nswc_part_09.f90#L10176) |


Let ty < +++ < tg be a sequence where @ > 2, {(aj,y:):¢ =1,...,m} be a set of m > 4 points where ty <2) <-+- < 2, < te, and wy, ..., Wm be positive weights. Then the subroutine SPFIT is available for obtaining a cubic spline f(z) with the nodes ty, ...,te

mm which minimizes ) w; (f(z:) — y:)*. This spline is represented by tet

j{z) = 25 +a; (x ~ ty) 4 b5(2-- t;)? + cs (2 _ t;)°

fori, Sor < tya1 (7 = 1,...,€-1). if the nodes are selected so that £ < m — 2 and each interval (t;,;41) contains a data point z,,, then this least squares approximation is unique.

```fortran
CALL SPFIT(X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR)
```

X is an array containing 21,...,2%m, Y an array containing y1,...;Ym, W an array containing wy,,...,Wm, and T an array containing tj,...,t2. Z,A,B,C are arrays of dimension &— 1 or larger, and IERR is an integer variable. When SPFIT is called, if no input errors are detected then IERR is set to 0. Also, the coefficients z;,a;,6,,c; of the least squares approximating spline f(x) are computed and stored in Z, A, B,C.

WK is an array of dimension 7@+ 18 or larger that is a work space for the routine.

```text
Erroi Return. TERR is set to one of the following values when an input error is detected.
IERR = 1 iff < 2.
IERR = 2 if ty < +--+ < tis not satisfied.
IERR = 8 ifm > 4 and t; <2, <--- <2, < t, are not satisfied.
```

If an error is detected, the routine immediately terminates.

**Remarks.**

(1) Occasionally, accuracy can be lost when t, = rm. Therefore, it is recommended that te > Im.

(2) After A,B,C, and Z have been obtained, then SCOMP may be used to evaluate the spline at. any point z. SEVAL may be used if derivatives are also desired.

**Programming.** SPFIT employs the subroutines BSPP, BSLSQ, BSPVB, BCHFAC, and BCHSLV. SPFIT was written by A. H. Morris.


<small>Original source: [View scanned PDF page 345](scans/page_0345.png)</small>

<a id="topic-345-01"></a>
### Least Squares Cubic Spline Fitting With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSPFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR` | [`L94944`](source_parts/nswc_part_09.f90#L10269) |


Let ty <++* < tg be a sequence where @ > 2, and {(t4,y:) : i = 1,...,m} be a set of pointe where t) < 2) < +++ < 2m, < tg. Then the subroutine CSPFIT is available for obtaining a cubic spline f(x) with the nodes t; ...,t, which minimizes DS (2s) — ys)? subject to a set of constraints. This spline is represented by

fort; S@<toyy Gad... f- 1.

```text
Notation. For any real x, f) (x) will denote the value f(z) if j = 0, the 7*® derivative of
f at vif 7 = ft or 2, and the right third derivative j/“(x+) if j = &.
```

```fortran
CALL CSPFIT(X, Y, M, BREAK, L, XCON, CON, NDER, NC, Z, A, B, C, WK, IWK, IERR)
```

X is an array containing 2), ...,2m, Y an array containing y,, ...,y¥m, and 7’ an array containing ¢,,...,i¢. The argument k is the number of constraints to be satisfied (k > 0) and XCON, it, NDER are arrays of dimension max{1, k} or larger.

if& > 1 then XCON contains the points #,, ...,&, at which the constraints are placed.

The points may be given in any order and need not be distinct. It is assumed that ti< Eo <tyfert=,...,6. At & any of the following types of constraints

itupe = 0 f)(%,) <r,

itype= Lf (2.) > 4,

‘uppe 2 fH) = ry

```text
itype = 3 fO(H) = FON(r,)
can be impused where 7 = 9,1,2, or 3. For the selected constraint, it is assume:} that
R(t} = rj and NDER(t) = itype + 47. Wf an itype 3 constraint is imposed then it is turther
ausumed that ty <r, < ty.
```

WK and IWK are arrays that are work spaces for the routine. On input, IWK(4) is the dimension of WK and IWK(2) the dimension of WK. If £ = 0 then one may set IWK(L) =- Nts and }WK(2} = @ where NB «= 7(@+ 7}. Otherwise, let v = £ + 3, m, be the number o¢ equality (i.e., “type 2 and 3) constraints, and m, the number of inequality (atype QO and 1) constraints. Then one must set

\

IWK(L) 2 NB + (eo 4 k)u td 2(m, tv) + (me tv) + (my + Q)lv + 8) IWKE2) > my + de.

**Remarks.**

(1) Wk > tthen one can let the routine determine the amount of storage that is needed for Wh and 1 Wh. Set WAHL) > Not anc IWK{2) - 2, in which case errors will occur

(sce the IND. 6,--7 error values below). (2) NDER(s} taay t+ assigned a negative value (¢ ~ 1, ..,k). 1 NDERQG) «hoa the i’ constraint (4 ignored


<small>Original source: [View scanned PDF page 346](scans/page_0346.png)</small>

2, A, 2,C are arrays of dimension #-- 1 or larger, When CSPEIJT is cal’ad, if the cubic spline f(x) is obtained then the coefficients z;,a;,6,;, ¢; of the spline are store] in Z, A, B,C,

```text
iND is a variable that reports the status of the results. When CSPFIT terminates,
IND is assigned one of the following values:
```

IND = G The spline was obtained.

IND = 1 The equality (ie., itype 2 and 3) constraints are contradictory. The spline was obtained where the equality constraints were satisfied in a least squares sense.

IND = 2 The spline could not be obtained. The constraints are contradictory.

IND = -1 €< 2.

IND = -2 m<Qork <0.

IND == -3 t, > t;41 for some t.

IND = —4 The assumption ty < 21 <<-++< 2, < tz is not satisfied.

IND = -5 The t* constraint is incorrect for the value of ¢ stored in IWK(2).

IND = —6 Insufficient storage was specified for the WK array. IWK(1) has been reset, to the amount, of storage needed by WK.

IND = --7 Insufficient storage was specified for the IWK array. IWK{2) has been reset, to the amount of storage needed by IWK.

IWK{1) and IWK(2) are not modified when IND # —5, —6, --7.

**Example.** if one wants f to be convex on an interval [t;,¢;41], then this is equivalent to requiring that "(z) > Q on the interval. Thus, since f is a cubic polynomial on the interval, it suffices to require that f’(t;) > 0 and f'(ti41) > 0. For these two constraints, 9 is the

appropriate value for the NDER array.

**Programming.** CSPFIT employs the subroutines BFIT and BSPP, and the functions and subroutines used by BFIT. CSPFIT was written by A. H. Morris.


<small>Original source: [View scanned PDF page 347](scans/page_0347.png)</small>

<a id="topic-347-01"></a>
### Cubic Spline Evaluation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SCOMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, NI, IERR` | [`L95029`](source_parts/nswc_part_09.f90#L10354) |
| `SCOMP1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, NI, IERR` | [`L95137`](source_parts/nswc_part_09.f90#L10462) |
| `SCOMP2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, NI, IERR` | [`L95247`](source_parts/nswc_part_10.f90#L1) |


Given a1 <i: <t,. A function f(r) is a cubic spline having the nodes (knots) €1,...,% If f is a polynomial of degree < 3 on the interval [2,,2,44.;] forts 1, ...,n— 1, and the first and second derivatives f’(«) and f‘(a) exist and are continuous for all x. If f; denotes the polynomial for the interval [z,, 244.1] then f; has the form:

Silz) = ye + ae(e — xy) + O;(x — 23)? 4+ (2 ~ 2,)*

Consequently, the function f is obtained by fitting the polynomials f,,..., fy—1 together at the points ro, ...,¢,-14. For 2 < 2, f(x) == fi(r), and for x > a, f(x) = fys(c). Also f(z,;) = y Tor f= 1,...,n-—1. Hence, if f(an} = y, then f interpolates the points (ty, 4) ford 4, 0. yn,

A cubic spline f given by the polynomials f,,...,f/,~1 is uniquely defined by any of the following three sets of data:

(1) the points (2,, ys) aad coefficients a,, b,c, for f= 4, ...,n-~1

(2) the points (z,, y:) and first derivatives f’(2,) for f= 1,...,n

(8) the points (#,;,y,) and second derivatives f"(z,) for 7= 1, ...,n The subroutines SCOMP, SCOMP!, SCOMP2 are available for computing the spline at any point z. SCOMP is used if data set (1) is given, SCOMP! is used if data set (2) is given, and SCOMP2 is used if data set (3) is given.

```fortran
CALL SCOMP(X, Y, A, B, C, N, XI, YI, NI, IERR)
```

Let N =n-—1. Then N is the number of polynomials * that form the spline, X and Y are arrays containing the abscissas 7,,...,24 and ordinates y,,...,yn, and A,B,C are arrays containing the coefficients a,,b;,c; (6 = 1,..., NM). It is assumed that N > i and that ay << oy,

Let £1,...,2m be the points at which the spline J 1s to be evaluated. XI is an array containing %,,...,2,,, YJ an array of dimension m or larger, and IERR a variable. When SCOMP is called, ifm < I then [ERE is set to 1 and the routine terminates. Otherwise, if m > | then IERR is set to 0 and f(#,) is computed and stored in YI(y) for 7 = 1, ...,m.

**Note.** SCOMP does not require f to be a spline. It is only required that f;(x) be a cubic polynomial y: 4 ay(a -- xz) + B(x — xy)" + ey(a ~ 2)? and that

f(a) = fylz) fora > ay.

In this case, SCOMEP computes the value ffa,+) for j <1, ..,m.

fol


<small>Original source: [View scanned PDF page 348](scans/page_0348.png)</small>

**Programming.** Adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SCOMP1(X, Y, YP, N, XI, YI, NI, IERR)
```

X, Y, DY are arrays containing the abscissas 21,...,2,, ordinates y1,..., Yn, and first derivatives f'(x1),..., f’(an) respectively. It is assumed that n > 2 and 21 <+++ < gy.

Let 71, ...,Zm be the points at which the spline f is to be evaluated. X! is an array containing #1, ...,2%,,, YI an array of dimension mi or larger, and [ERR a variable. When SCOMPL is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, ifm > 1 then IERR is set to 0 and f(Z;) is computed and stored in YI(7) for 7 = 1, ...,m.

**Programming.** Adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SCOMP2(X, Y, YPP, N, XI, YI, NI, IERR)
```

X, ¥Y, DDY are arrays containing the abscissas <;,...,2,, ordinates y1,...,y, and second derivatives f"(z;),...,f"(zn) respectively. It is assumed that zy < +++ < 2, for n> 2,

Let %1,...,Z,, be the points at which the spline f is to be evaluated. XI is an array containing £1,...,%m, Yl an array of dimension m or larger, and JERR a variable. When SCOMP2 is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, ifm > 1 then IERR is set to O and f(Z,;) is computed and stored in YI(j) for j = 1, ...,m.

**Programmer.** Rondall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 349](scans/page_0349.png)</small>

<a id="topic-349-01"></a>
### Cubic Spline Evaluation And Differentiation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEVAL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR` | [`L95360`](source_parts/nswc_part_10.f90#L114) |
| `SEVAL1` | `SUBROUTINE` | `X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR` | [`L95475`](source_parts/nswc_part_10.f90#L229) |
| `SEVAL2` | `SUBROUTINE` | `X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR` | [`L95591`](source_parts/nswc_part_10.f90#L345) |


Given 21 < +++ < rq. A function f(x) is a cubic spline having the nodes (knots) 1,...,2, if f is a polynomial of degree < 3 on the interval [2.,%s41] forf == 1,...,n—1, and the first and second derivatives f’(r) and f(x) exist and are continuous for all z. If f; denotes the polynomial for the interval {2,;,2,;41] then f; has the form:

f(z) = Y, + a,(x _ z;) Sa by (x _ x;)? “t+ (x - x,)°

```text
Consequently, the function f is obtained by fitting the polynomials f;, ..., fa—1 together
at the points %2,...,2%,-1. For z <2, f(z) = fy(x), and for z > x, f(x) = f,_4(zx). Also
f(z;) = y fori =1,...,n- 1. Hence, if f(z.) = yn then f interpolates the points (zx, yx)
for?=1,...,n.
```

A cubic spline f given by the polynomials f,,...,f,—1 is uniquely defined by any of the following three sets of data:

(1) the points (z;, y,;) and coefficients a;,b;,c; fort =1,...,n—1

(2) the points (z,,y,) and first derivatives f'(z,) for? =1,...,n

(3) the points (z,, y;) and second derivatives f"(a,) fori =1,...,n The subroutines SEVAL, SEVAL1, SEVAL2 are available for computing the spline and its first and second derivatives at any point 2. SEVAL is used if data set (1) is given, SEVAL1 is used if data set (2) is given, and SEVAL?2 is used if data set (3) is given.

```fortran
CALL SEVAL(X, Y, A, B, C, N, XI, YI, YPI, YPPI, NI, IERR)
```

Let N =n-—1. Then N is the number of polynomials f; that form the spline, X and Y are arrays containing the abscissas 21, ...,zNn and ordinates y1, ..., yn, and A, B,C are arrays containing the coefficients a,,b,,c;(i = 1, ..., N). It is assumed that N > 1 and that Ty <eee S EN.

Let £1,...,2m be the points at which the spline f and its first two derivatives are to be evaluated. XT is an array containing £1, ...,%m, YI, DY!, DDYI are arrays of dimension m or larger, and IERR is a variable. When SEVAL is called, if m < 1 then IERR is set to i and the routine terminates. Otherwise, ifm > 1 then IERR is set to 0 and the values f(%;), £'(&;), f"(2;) are computed and stored in YI(j), DYI(7), DDYI(j) for 7 = 1, ...,m.

**Note.** SEVAL does not require f to be a spline. It is only required that fi{=) be a cubic polynomial y. 4 a,(xz — 2,;) + 6, (x — 2)? + ¢,(z — z,)® and that

```text
f(z) =fi(z) forz< 2
f(z) =fi(z) for 2, <2 < tiqy (L<t< N)
f(z) =fn(x) for2 > tn.
```

In this case, SEVAL computes the values f(2;+), f'(Z;+), {"(z,+) for j = 1,...,m.


<small>Original source: [View scanned PDF page 350](scans/page_0350.png)</small>

**Programming.** Adaptation by A. II. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SEVAL1(X, Y, YP, N, XI, YI, YPI, YPPI, NI, IERR)
```

X, Y, DY are arrays containing the abscissas 21, ...,2,, ordinates y,, ..., Yn, and first derivatives f'(xi), ..., f’(xn) respectively. It is assumed that m > 2 and 21 <+++ < 2p.

Let %1,...,%m be the points at which the spline f and its first two derivatives are to be evaluated. XI is an array containing Z1, ...,2m, YI, DYI, DDYI are arrays of dimension m or larger,and IERR is a variable. When SEVAL1 is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, if m > 1 then [ERR is set to O and the values f(#;), f'(@;), f'"(,) ave computed and stored in YI(j), DYI(7), DDYI(y) for 7 = 1, ...,m.

**Programming.** Adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).

```fortran
CALL SEVAL2(X, Y, YPP, N, XI, YI, YPI, YPPI, NI, IERR)
```

X, Y, DDY are arrays containing the abscissas 2,...,2%,, ordinates yj,...,y¥,, and second derivatives f"(x1),..., f"(2n) respectively. It is assumed that n > 2 and 21)<:++<ay.

Let %1,...,Zm be the points at which the spline f and its first two derivatives are to be evaluated. Xi is an array containing %;, ...,%m,Y{, DYI, DDYI are arrays of dimension m or larger,and IERR is a variable. When SEVAL2 is called, if m < 1 then IERR is set to 1 and the routine terminates. Otherwise, if m > 1 then IERR is set to 0 and the values {(2;), f'(Z;), f"(%;) are computed and stored in YI(7), DYI(j), DDYI(j) for j = 1, ...,m.

**Programmer.** Rondall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 351](scans/page_0351.png)</small>

<a id="topic-351-01"></a>
### Integrals Of Cubic Splines

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSINT` | `REAL FUNCTION` | `X, Y, A, B, C, N, ALPHA, BETA` | [`L95709`](source_parts/nswc_part_10.f90#L463) |
| `CSINT1` | `REAL FUNCTION` | `X, Y, YP, N, A, B` | [`L95817`](source_parts/nswc_part_10.f90#L571) |
| `CSINT2` | `REAL FUNCTION` | `X, Y, YPP, N, A, B` | [`L95939`](source_parts/nswc_part_10.f90#L693) |


Given x, <--> < 2,. A function f(x) is a cubic epline having the nodes (knots) Ty,...,%, 1f f is a polynomial of degree < 3 on the interval [z;, 241] fort =1,...,n — 1, and the first and second derivatives f’(2) and f(r) exist and are continuous for all x. If f; denotes the polynomial for the interval [z,, 2,41] then f; has the form:

```text
fiz) = ys + asf — 24) + b;(2 — 2)? + ¢;(2 — 2,)8
Consequently, the function f is obtained by fitting the polynomials f;, ..., f,—1 together
at the points x2, ...,%,—1. For z < 2, f(x) = f;(z), and for z > x, f(z) = fn—i(z). Also
f(2;) == yy for ¢ = 1, ...,n— 1. Hence, if f(z.) = yn then f interpolates the points {z,, y;)
fort =1,...,n.
```

A cubic spline f given by the polynomials f,, ..., fy.-1 is uniquely defined by any of the following three sets of data:

(1) the points (z,, y;) and coefficients a,,b;,c; fort? =1,...,n--1

(2) the points (z,,y;) and first derivatives f'(z,;) for i=1,...,n

(3) the paints (z,, y;) and second derivatives f"(z;) fori =1,...,% For any real a and f the functions CSINT, CSINT1, CSINT2 are available for computing the integral je f(t) dt. CSINT is used if data set (1) is given, CSINT1 is used if data set (2) is given, and CSINT2 is used if data set (3) is given,

```fortran
CSINT(X, Y, A, B, C, N, ALPHA, BETA)
```

Let N =n -~ 1. Then N is the number of polynomials f; that form the spline, X and Y are arrays containing the abscissas 41, ...,zy and ordinates y;,...,yn, and A, B,C are arrays containing the coefficients a,,b,,c,(1 = 1, ..., N)}. It is assumed that N > 1 and that

ry <+++< ay. Then CSINT has the value f? f(t) dé. Programming. CSINT calls the function INTRVL. CSINT was written by A. H. Morris.

```fortran
CSINT1(X, Y, YP, N, A, B)
```

X, Y, DY are arrays containing the abscissas 21, ...,Z,, ordinates y1, ...,,, and first derivatives f'(r1),..., f'(zn) respectively. It is assumed that n > 2 and ay < ++) < ay. Then CSINT1(X,Y,DY,n,a, 6) = J? f(t) de.

**Programming.** CSINT1 calls the function INTRVL. CSINT1 was written by A. H. Morris. CSINT2(X, Y,DDY, n, «, #)

X, Y, DDY are arrays containing the abscissas r,,...,2,, ordinates yj,...,yn, and

second derivatives f"(21),...,f"(zn) respectively. It is assumed that n> 2 and 2y)<:++<z,.

Then CSINT2(X,¥,DDY,n,a, A) f" f(t) dt.

**Programming.** CSINT2 calls the function INTRVL. CSINT2 was written by A. H. Morris.


<small>Original source: [View scanned PDF page 352](scans/page_0352.png)</small>

<a id="topic-352-01"></a>
### Periodic Cubic Spline Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PDSPL` | `SUBROUTINE` | `X, Y, A, B, C, N, T, IERR` | [`L96041`](source_parts/nswc_part_10.f90#L795) |


Given w; < +++ < a,. A function f(x) is a cubic spline having the nodes (knots) %1,...,2, if f is a polynomial of degree < 3 on the interval [z,, 2,41] for ¢ = 1,...,n - 1, and the first and second derivatives /'(z) and f(x) exist and are continuous for all z. If f, denotes the polynomial for the interval [z,;,2;:,] then f; has the form:

filz) = ys + aj(x ~ x4) + b:(x — ay)? + cy(x - 2,)°. Consequently, the function f ir obtained by fitting tue polynomials f,, ..., fy—1 together at the points 22, ...,2%y--4.

```text
Normally, a cubic spline f is defined for x ¢ [z1,x,,) by letting f(x) = f(x) for 2 < 21
and f(r) = fy-.1(z) for z > ay. However, if
```

f'(zit) = f'(an-) f"(21+) _ f"(tn~) are satisfied then f may be defined for x ¢ (x1, z,] by requiring that f(z +p) = f(z) for

all c where p = 2,, — 21. The function f is called a periodic spline when this is done.

Now if the values yi, ...,4n—1 ate given, then there exists a unique periodic cubic spline f having the nodes z;,...,2, and satisfying f(2s) = uy; for? = 1,..,n-1. The following subroutine is available for obtaining the coefficients a;,b,,¢; of this spline,

```fortran
CALL PDSPL(X, Y, A, B, C, N, T, IERR)
```

X is an array containing 21, ...,%, and Y an array containing y1,...,Yn—1. It is

assumed that 4; < +++ < 2, and m > 3. A,B,C are arrays of dimension n — 1 or larger, and IERR a variable. When PSP? is called, if ro input errors are detected then [ERR is set to 0 and the coefficients a,;,6,,c, of the interpolating periodic cubic spline are stored in A,B,C.

WK is an array of dimension n ~ 2 or larger that is 1 work space for the routine.

**Error Return.** [ERR = 1 if n < 3 and IPRR = 2 if 2; > £441 for some ¢.

**Remark.** After A, B, and C' have been obtained, then PSCMP may be used to evaluate the periodic spline at any point zr. PSEVL may be used if derivatives are also desired.

**Programmer.** A. HH. Morris.

AGT


<small>Original source: [View scanned PDF page 353](scans/page_0353.png)</small>

<a id="topic-353-01"></a>
### Least Squares Periodic Cubic Spline Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PDFIT` | `SUBROUTINE` | `X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR` | [`L96171`](source_parts/nswc_part_10.f90#L925) |


Let t) <+-+ < t, be a sequence where é > 2 and { (2;,4;) :¢ =1, ...,m} a set of points where t) < 21 < +++ < am < te. Then the following subroutine is available for obtaining a periodic cubic spline f(x) with the nodes ¢;, ...,t¢ which minimizes >°>,(f(z;) — y:)?. This spline is represented by

fx) = 25 +a;(x—t;) +6; (2 - t;)? + ¢;(2 — t,)* fort; <2 <tj;4: G=1,...,@—1). CALL PDFIT(X,Y,m,T,@, Z, A, B,C,WKIWK,IERR)

X is an array containing 21, ...,2m, Y an array containing y,, ...,Y%m, and T an array containing t1,...,te. Z,A, B,C are arrays of dimension £— 1 or larger. When PDFIT is called, if the desired periodic cubic spline is obtained then the coefficients z;,a;,b;,¢; of the spline are stored in Z, A, B,C.

WK and [WK are arrays that are work spaces for the routine. On input TWK(1) is the dimension of WK and IWK(2) the dimension of IWK. It is required that IWK(1) > (é+-6)(€-+ 15) + 10 and IWK(2) > 2¢+- 6.

TERR is a variable that reports the status cf the results. When PDFIT terminates, IERR has one cf the following values:

IERR = 0 The desired spline was obtained.

IERK = 1 The spline could not be obtained.

IERR = 2 Either m <0 or @ < 2.

TERR. = 3 t; > t;41 for some 7.

TERR = 4 The assumption t, < 21 <-:+< 2, < t¢ is not satisfied.

IERR =: 5 Insufficient storage was specified for the WK array. IWK(1) has been reset to the amount of storage needed by WK.

TERR = 6 Insufficient storage was specified for the IWK array. TWK(2) has been reset to the amount of storage needed by TWK.

If an error is detected, then JERR > 2 and the routine terminates.

**Remark.** After A, 8,C, and Z have been obtained, then PSCMP may be used to evaluate the periodic spline at any point x. PSEVL may be used if derivatives are also desired.

**Programming.** PDFIT employs the subroutines BSPP, BFIT, BFITO, ENDACC, BNDSL,

BSPVB, BSPVD, LSEI, and the subroutines and functions used by LSEL PDEIP was written by A. H. Morris.


<small>Original source: [View scanned PDF page 354](scans/page_0354.png)</small>

<a id="topic-354-01"></a>
### Periodic Cubic Spline Evaluation And Differentiation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PSCMP` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, M, IERR` | [`L96264`](source_parts/nswc_part_10.f90#L1018) |
| `PSEVL` | `SUBROUTINE` | `X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR` | [`L96350`](source_parts/nswc_part_10.f90#L1104) |


Let z1 <+++ < zy be a sequence where n > 2, and f a periodic cubic spline where f(z) = yy + a(x — 2) + (2 — x;)? + (x _ z;)°

fora, <2 < 24) ($= 1,...,n- 1). Then the subroutine PSCMP is available for evaluating the spline for all points x, and the subroutine PSEVL is available for computing its derivatives.

```fortran
CALL PSCMP(X, Y, A, B, C, N, XI, YI, M, IERR)
```

X is an array containing 71, ...,2%,, Y an array containing y,,...,Yn—1, and A,B,C arrays containing the coefficients a,,6;,¢; (( = 1, ...,n—1). It is assumed that 21 <-++ <2, and n> 3.

Let Z), ...,%,, be the points at which the periodic spline is to be evaluated. XI is an array containing Z;, ...,2%m, YI an array of dimension m or larger, and JERR a variable. When PSCMP is called, if no input errors are detected then IERR is set to 0 and f(z,) is computed and stored in YI(7) for 7 = 1, ...,m.

**Error Return.** IERR = 1 ifn <3 or m< 0.

**Programmer.** A. H. Morris. CALL PSEVL(X,Y, A, B,C,n,XLYI,DYI,DDYI,m, IERR)

X is an array containing 21,...,2,, Y an array containing yi, ...,Yn—1, and A,B,C

arrays containing the coefficients a,b,c; (= 1, ...,n~1). It is assumed that 1; <-++ < 2, and n > 3.

Let £1, ...,2m be the points at which the periodic spline and its first two derivatives are to be evaluated. XJ is an array containing %1,...,%m, YI, DYI, DDYI are arrays of

dimension m or larger, and IERR a variable. When PSEVL is called, if no input errors are detected then IERR is set to 0 and f(#,), f‘(2;), f(#,) are computed and stored in YI(j), DYI{j), DDYI(j) for 7 = 1, ...,m.

**Error Return.** ERR = 1ifn <3 orm <0.

**Programmer.** A. Hl Morris.

A71}


<small>Original source: [View scanned PDF page 355](scans/page_0355.png)</small>

<a id="topic-355-01"></a>
### N-Dimensional Cubic Spline Closed Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSLOOP` | `SUBROUTINE` | `M, N, X, KX, T, DX, KDX, WK, IERR` | [`L96443`](source_parts/nswc_part_10.f90#L1197) |
| `LOPCMP` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, L, TI, Z, KZ` | [`L96668`](source_parts/nswc_part_10.f90#L1422) |
| `LOPDF` | `SUBROUTINE` | `M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ` | [`L96756`](source_parts/nswc_part_10.f90#L1510) |


Given m > 2 points x = (x41, ..+)%in) Where n > 2. One procedure for fitting a closed curve to the points is to first let s; = 0,8; = 9;-,+ [25 —2y~1|| for ¢ = 2, ...,m, and 8m+1 = 9m + ||t1 — Zm||,1 next let t; = 8:/8m+1 fori =1,.. ,m-+1, and then to find for each j <n the periodic cubic spline +,(t) having the knots ty, ... rtmii where 7;(t,) = 2, for i < m. The mapping 7(t} = (y1(t), ...,7(t)) then defines on the interval (0, 1] a closed curve which traverses the points (¢1,21), ...,(tm,2m), (1,21) and satisfies ¥'(0) = ¥'(1) and ¥"(0) = 7"(1). For t < 0 and t > 1, ¥(t) is defined by periodicity (having period 1). The subroutine CSLOOP is available for obtaining the derivatives ¥;(ts) which characterize this curve, the subroutine LOPCMP is available for computing the curve, and the subroutine LOPDF is available for differentiating the curve.

```fortran
CALL CSLOOP(M, N, X, KX, T, DX, KDX, WK, IERR)
```

X is an mxXn matrix whose i'" row contains the point 2; = (211, -.-;2sn), Where mm > 2

and n > 2. It is assumed shat the points 21, ..., 2, are indexed in the order that they are to be traversed by the curve -/(t). It is also assumed that 2; 4 241 forts 1,...,m—-! and that 2, 4 2;.

DX is a 2-dimensional a) ray containing at least m rows and n columns. The arguments kx and kdz have the following values:

kx = the number of rows in the dimension statement for X in the calling program

kdz = the number of rows in the dimension statement for DX in the calling program It is required that kx © m and kdr > m.

JERR 1s a variable) and 7 an array of dimension m or larger. When CSLJOP is called, if no input errors are detected then IERR is assigned the value 0 and ¢;, ... ,'m are computed and stored in 7. Also, the derivatives 1; (ts) are computed ind stored in DX, where the 1!" row of DX contains y'(t,) == (y{ (ti), -.., 74 (ts).

WK is ar array of dimension 4(m 1) or larger that is a work space for the routine. Error Return. ERR reports the following input errors: IERR lo ifm<2orn< 2

JERR =. 2 fa, 2,4, for some t.

IERR- 3 ifay, ry.

**Remark.** After 17 and DX are obtained, LOPCMP may be used to compute the curve aud LOPDF may be used to differentiate the curve.

**Programming.** CSLOOP calls the subroutine CSLOPL and function SNRM2. CSLOOP and CSLOPI were written by A. HL Morris

miEsn Veve2 for any cs (43, 2... 2).


<small>Original source: [View scanned PDF page 356](scans/page_0356.png)</small>

```fortran
CALL LOPCMP(M, N, T, X, KX, DX, KDX, L, TI, Z, KZ)
```

T is an array containing the knots t;, ...,tm, X an mxn matrix whose 1*%

row contains the point z;, and DX an m x n matrix whose #*” row contains the derivative '(t;). The arguments kz and kdz have the following values: kz = the number of rows in the dimension statement for X in the calling program kdz = the number of rows in the dimension statement for DX in the calling program

It is assumed that m > 2,n > 2, kx > m, and kdzr > m.

Let t,,...,¢, be the points at which the curve y is to be evaluated. TI is an array containing ¢;, ...,¢, and Z a 2-dimensional array containing at least & rows and n columns. The argument kz is the row dimension for Z in the calling program. It is assumed that

```text
€> 1 and kz > @. When LOPCMP is called, y(t;) = (41(t,), -.., m(t;)) is computed and
stored in the #'" row of Z for1=1,...,2.
```

**Programmer.** A. H. Morris.

```fortran
CALL LOPDF(M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ)
```

T is an array containing the knots ¢;,...,t,,, X an ms X n matrix whose 1*4 row contains the point z;, DX an m x n matrix whose 1°” row contains the derivative 7'(t,). The arguments kz and kdr have the following values:

kz = the number of rows in the dimension statement for X in the calling program

kdz = the number of rows in the dimension statement for DX in the calling program

It is assumed that m > 2,n > 2, kr > m, and kdz > m.

4, DZ, and DDZ are arrays of dimension n. For any real to, y(to) == (a1(ts), ---, In{to)), ¥'(to) == (yi (to), ---, 7, (to)), and 4/(to) = (ai/(ta), -.., 7% (to)) are computed and stored in Z, DZ, and DDZ respectively.

**Programmer.** A. H. Morris.

Aid


<small>Original source: [View scanned PDF page 357](scans/page_0357.png)</small>

<a id="topic-357-01"></a>
### Spline Under Tension Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR` | [`L96827`](source_parts/nswc_part_10.f90#L1581) |


Given real og anda, <---<z,. A function f(z) isa spline having the tension factor o and the nodes (knots) x1, ...,2, if f(x) and its first two derivatives are continuous on [t1,2n], and f(x) — 6? f(z) = ayz + 6, on the interval [z,, 2541] for # = 1,...,n- 1, Here @ = jo|(n -- 1)/{a_ ~ v1) and a,, 6; are constants. For zy < 2 < 2,41 f(z) can be represented by

```text
J (x) = Aysinha(z — z;) + Bysinh @(2,41 - x) - (ajz + 6,)/e?
when o #0, and by a cubic polynomial when o = 0.
```

Assume now that n ordinates y;, ...,y, are given. Then there exist an infinitude of splines f(z) having tension o for which f(z,) = y (f = 1,...,). However, if values y{ and y/, are given then oily one of these splines will satisfy f/{z,) = yj and f’({r,) = y/,. For convenience, denote this spline by f,. If o = 0 then it is clear that f, ia the standard cubic spline. Also it can be verified that when a — oo, f, converges uniformly on [z1, zy] to the piecewise linear function é(z) where €(x) = y; + m,(z — 2;) for xy < z < ay41 (¢=1,...,n-—1). Here mn, = (ysa1 ~ ys)/(2i41 — 24). The following subroutine is available for obtaining the spline f,.

```fortran
CALL CURV1(N, X, Y, SLP1, SLPN, ISLPSW, YP, TEMP, SIGMA, IERR)
```

X and Y are arrays containing the abscissas x1, ...,2,, aud ordinates y1,...,Yn- [tis assumed that n > 2 and rz; <+-- < ay.

```text
SLP1 and SLPN are assigned the values y} and y). The user may omit values for
either or both of these arguments. IND specifies the information that is provided.
IND = 0 Values are supplied for SLP] and SLPN.
IND =1 A value is sunphed for SLPi but not for SLPN.
IND = 2 A value is supplied for SLPN but not for SLP1.
IND = 3 Values are not supplied for SLPI and SUPN.
```

If a value is not supplied by the user, then the routing provides a value. DDY is an array of dimension rv or larger, and [ERK is an integer variable. When

CURV 1 is called, if no input errors are detected then HERR is assigned the value 0 and the second derivatives f7/(21), ..., f0/(2,) are computed and stored in DDY.

TEMP ts an array of dimension mn or larger that 1s used fur a work space.

**Error Return.** fle RK reports the following input errors: HERR - bafae 2.

IPRR 2 of ey coe) \ ay is not satisfied

When either of (oese errors as detected, the routine immediately terminates,


<small>Original source: [View scanned PDF page 358](scans/page_0358.png)</small>

```text
Remarks.
(1) After DDY is obtained then CURV2 may be used to evaluate the spline at any point z.
(2) X, ¥Y, na, SLP1, SLPN, IND, o are not modified by CURV3.
```

**Programming.** CURV1 employs the subroutines CEEZ, TERMS, and SNHCSH. CURVI, CEEZ, and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

**Reference.** Cline, A. K.,“Scalar and Planar Valued Curve Fitting using Splines under Tension,” Comm. ACM 17 (1974), pp. 218-220.


<small>Original source: [View scanned PDF page 359](scans/page_0359.png)</small>

<a id="topic-359-01"></a>
### Spline Under Tension Evaluation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CURV2` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [`L97005`](source_parts/nswc_part_10.f90#L1759) |


Given o and 2 < +++ < ty. A function f(x) is 4 spline having the tension factor o and the nodes (knots) «,, ...,2, if /(x) and its first two derivatives are continuous on [1,2], and f(r) — #? f(z) = age + b, on the interval la;,2ia1] ford = 1,...,n—- 1%. Here @ = |o|(n—1)/(2, ~ #1) and aj, d, are constants. If f(z) = f(x) for aysarcoyy, then f(x) can be represented by

fi(z) = Ay sinh (2 - z,) + Bysinh F(ay41 - 2) — (ax + b)/a?

```text
when ¢#0, and by a cubic polynomial when g = 0. For v < zy we let {(z) = fi(z), and for
x > ty we let f(z) = fa—1{z).
```

Assume now that f(z;) = y; for ¢ = 1,...,n. Then for a fixed o, f(z) is uniquely defined by the points {2,,y,;) and the second derivatives {"(x,)(¢ = 1,...,n). When this data is available, the following function may be used to compute the spline at any point ¢,

CURV2(t,n, X,Y, DDY,o}

\* and Y are arrays containing the abscissas 11, ...,2, and ordinates ys, .o +3 Yn, and DDY is an array containing the second derivatives f"(z1),...,f(z,). It is assumed that n>2 and a <+++ < a,. CURV2(t,n, X,Y DDY, a) = f(t) for any real t.

**Remark.** After DDY has been obtained, CURV2 may be repeatedly called to evaluate the curve at different points so long as the tension factor o remains fixed. However, if ¢ is modified then the derivative information in DDY will have to be recomputed before CURV2 can be used with the new tension factor.

**Programming.** CURV2 employs the function INTRVL and subroutine SNHCSH. CURV2 was written by A. K. Cline and R. J. Renka (University of Texas at Austin). INTRVL was written by A. H. Morris.

**Reference.** Cline, A. K., “Scalar and Planar Valued Curve Fitting using Splines under Tension,” Comm. ACM 17 (1974), pp. 218-220.


<small>Original source: [View scanned PDF page 360](scans/page_0360.png)</small>

<a id="topic-360-01"></a>
### Differentiation And Integration Of Splines Under Tension

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CURVD` | `FUNCTION` | `T, N, X, Y, YP, SIGMA` | [`L97108`](source_parts/nswc_part_10.f90#L1862) |
| `CURVI` | `FUNCTION` | `XL, XU, N, X, Y, YP, SIGMA` | [`L97204`](source_parts/nswc_part_10.f90#L1958) |


Let f(x) be a spline having the tension factor o and the nodes 21, ...,%n. Assume that f(ts) = ye ford = 1,..., 2. If the second derivatives f'(r;), ..., f" (zp) are known then the following functions may be used for differentiating and integrating the spline.

```fortran
CURVD(T, N, X, Y, YP, SIGMA)
```

X and Y are arrays containing the abscissas 7), ...,2%, and ordinates y1,...,yn, and DDY is an array containing the second derivatives f"(i71),..., (ay). It is assumed thai n> 2and gj <++: < 2,. For any real ¢, the derivative f’(é} is computed and assigned to be the value of CURVD(t,n, X,Y, DDY,¢).

Programming. CURVD employs the function INTRVL and subroutine SNHCSH. CURVD was written hy A. K. Cline and R. J. Renka (University of Texas at Austin). INTRYL was written by A. H. Morris.

```fortran
CURVI(XL, XU, N, X, Y, YP, SIGMA)
```

X and Y are arrays containing the abscissas z,, ...,%,_ and ordinates yi,.. ,y,, and DDY is an array containing the second derivatives f"(r,),...,f"(2,). It is assumed thai n> 2and rz <+++ <a,. CURVI(a,b,n,X,Y,DDY,o) = f° f(t)dt for any real 2 and 6.

**Note.** It is not required that a < A. Programming. CURVI employs the function INTRVL and subroutine SNHCSH. CURVI

was written by A. K. Cline and R. J. Renka (University of Texas at Austin). INTRVL was written by A. H. Morris.

AT9


<small>Original source: [View scanned PDF page 361](scans/page_0361.png)</small>

<a id="topic-361-01"></a>
### Two Dimensional Spline Under Tension Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `KURV1` | `SUBROUTINE` | `N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR` | [`L97401`](source_parts/nswc_part_10.f90#L2155) |
| `KURV2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [`L97616`](source_parts/nswc_part_10.f90#L2370) |


Given a sequence of points (21,41), ...,(@n, Yn). One procedure for fitting a curve to she points is to let a, = 0 and 8; = 4,.1 + \ (xg ~ ays )® + yy ~ 1)? for ¥ = 2,...,n, and than to find two splines #(s) and y(s) with tension o that satisfy a{s;) == a, and yl) ss y fort =: ],...,n. Tf 8, and 6, ere the desired angles for the curve 6 ++ (x(s), y(s)) at. the points (1,41) ‘and (zn, Yn}, then the splines z(s) and y(s) can be selected so that a'(s;) = cos; and y'(s;) = sin@, for f = 1,n. The curve « +> (x(s),y(s)) then passes through the points (z,,y,) and has the required slopes at the end points. The subroutine KURVL is available for obtaining the second derivatives 2(s,;),y"(a,)(¢ = 1, ...,n) which characterize this curve, and the subroutine KURV2 is available for computing the curve.

```fortran
CALL KURV1(N, X, Y, SLP1, SLPN, ISLPSW, XP, YP, TEMP, S, SIGMA, IERR)
```

\* and Y are arrays containing the abscissas 21, ...,2%, and ordinates y1, ...,Yn. It is assumed that n > 2 and that tne points (~;, y;) are indexed in the order that they are to be traversed by the curve. It is also assumed that (24, Ys) # (S41, 441) for P= 1,...,n-- 1.

SLPi and SLPN are assigned the values 0; and @,,. These angles are measured counterclockwise (in radians} from the positive x-axis. The user may oi‘ values for SLP! and/or SUPN. IND specifies the information that is provided.

IND == 0 Values are supplied for SLP1 and SLPN.

```text
IND = 1 A value is supplied for SLP1 but not for SLPN.
UNT} = 2 A value is supplied for SLPN but not for SLP1,
IND = 2 Values are not supplied for SLP1 and SLPN.
```

If a value is not supplied by the user, then the routine provides a value.

a is the tension factor to be employed. If |¢i is small, say jo! < 107%, then z(s) and u(e)} approximate cubic splines. Otherwise, if |o| is large, say |o| > 100, then the resulting curve approximates the polygonal line from (2;, 41) to (21, Yn).

HERR is an integer variable and S, WDX, DDY are arrays cf dimension n or larger. Whoa KOURV1 is called, if no input errors are detected then TERR is assigned the value O aud the values 51, ...,@, are computed and stored in S. Also, the second derivatives wis... 2(s,) and y(s1),...,y"(8_) are computed and stored in DDX and DDY.

EMP is an array of dimension n or larger that is used for a work space. Error Return. IERR reports the following input errors: [ERR = Liffn < 2. TERR = 2 if (ty, ys) © (tsa, ue4i) for some ft. When either of these errors is detected, the routine immediately terminates. Remark. After S, DDX, DDY are obtained, KURV2 may be used to compute the curve.

**Programming.** KURVI employs the subroutines CEEZ, TERMS, and SNHCSH. KURVI,


<small>Original source: [View scanned PDF page 362](scans/page_0362.png)</small>

CEEZ, and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

```fortran
CALL KURV2(T, XS, YS, N, X, Y, XP, YP, S, SIGMA)
```

X and Y are arrays containing the abscissas 1, ...,<, and ordinates yj,...,Yn, 5 is an array containing 81,...,8,, and DDX and DDY are arrays containing the second derivatives 2(91),...,2"(8,) and y"(s1), ...,y"(s,).

Now consider the change of variables ¢ = ¢/s,, and let t ++ (Z(t), 9(t)) denote the curve in terms of the new parameter t. XT and YT are real variables. For any O < ¢ < 1, KURV2 computes the point (z(t), g(t)) on the curve and assigns XT the value Z(t) and YT the value

g(t).

**Remark.** After DDX and DDY have been obtained, KURV2 may be repeatedly called to evaluate the curve at different points so long as the tension factor ao remains fixed. However, if o is modified then the derivative information in DDX and DDY will have to be recomputed before KURV2 can be used with the new tension factor.

Programming. KURV2 employs the function INTRVL and subroutine SNHCSH. KURV2

was written by A. K. Cline and R. J. Renka (University of Texas at Austin). INTRVL was written by A. H. Morris.


<small>Original source: [View scanned PDF page 363](scans/page_0363.png)</small>

<a id="topic-363-01"></a>
### Two Dimensional Spline Under Tension Closed Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `KURVP1` | `SUBROUTINE` | `N, X, Y, XP, YP, TEMP, S, SIGMA, IERR` | [`L97738`](source_parts/nswc_part_10.f90#L2492) |
| `KURVP2` | `SUBROUTINE` | `T, XS, YS, N, X, Y, XP, YP, S, SIGMA` | [`L97924`](source_parts/nswc_part_10.f90#L2678) |


Given n > 2 points (21,41), ..., (2a, Yn)- One procedure for fitting a closed curve to the points is to let ¢; = JV (21 ~ tn)? + (yi — yn)? and 3, = sg.4 + V(x ~ 2-1)? + (yi — yyy)? for t= 2,...,n,and then to find periodic splines x(¢) and y(s) with tension o that pass through the points (91,7.), ...,(91,2n),(81 + 8,21) and (81,y)), . -+5(8n; Yn), (81 + 8n, 41). The mapping 8 +-+ (2:(s), y(s)) then defines a closed curve that passes through the points (25, ys). The subroutine KURVP1 is available for obtaining the second derivatives x"(s,), y"(8,)(t = 1,...,n) which characterize this curve, and the subroutine KURVP2 is available for com-

puting the curve.

```fortran
CALL KURVP1(N, X, Y, XP, YP, TEMP, S, SIGMA, IERR)
```

X and ¥Y are arrays containing the abscissa 21, ...,2, and ordinates y,, te) Yn Lb is assumed that n > 2 and that the points (z,, y;) are indexed in the order that they are to be traversed by the curve. It is also assumed that (2,, yi) # (2s41, yep1) for? =1,...,n - 1.

g is the tension factor to be employed. If |o| is small, say |o| < 107, then 2(s) aud y(s) approximate periodic cubic splines. Otherwise, if |o| is large, say |a| > 100, then the curve approximates the closed polygonal path that traverses the points (2, ys).

TERK is an integer variable and S, DDX, DDY are arrays of dimension n or larger. When KURVPL is called, if no input errors are detected then IERR ie assigned the value O and the values 81, ...,8, are computed and stored in S. Also, the second derivatives z"(s1),. ,# (sn) and y"(s1), ...,y”(s,) are computed and stored in DDX and DDY.

TEMP is an array of dimension 2n or larger that is used for . work space.

**Error Return.** [FRR reports the following input errors:

```text
IERR = 1 ifn < 2.
TERR = 2 if (2, ys) = (441, 41) for some 4.
```

When either of these errors is detected, the routine immediately terminates. Remark. After S, DDX, DDY are obtained, KURVP2 may be used to compute the curve.

**Programming.** KURVP1 employs the subroutines TERMS and SNHCSH. KURVP1 and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

```fortran
CALL KURVP2(T, XS, YS, N, X, Y, XP, YP, S, SIGMA)
```

X and Y are arrays containing the abscissas x1, ...,2, and ordinates y, . Ya, 5 is an array containing 8,,...,%,, and DX and DDY are arrays containing the second derivatives x"(s1),...,0(Sn) and y(s1),... y"(s,).


<small>Original source: [View scanned PDF page 364](scans/page_0364.png)</small>

Now consider the change of variables t = (@ - 31)/8,, and let ¢ ++ (Z(¢), y(t)) denote

the curve in terms of the new parameter ¢. Then ¢ +> (#(t),y(¢)} maps 0 and 1 onto the point (r1,y1), and t-» (z(t), y(t)) is a periodic function (with period 1).

XT and YT are real variables. For any real t, KURVP2 computes the point (Z(t), #(¢)) on the curve and assigns XT the value #(t) and YT the value y(t).

**Remark.** After DDX and DDY have been obtained, KURVP2 may be repeatedly called to evaluate the curve at different points so long as the tension factor o remains fixed. However, if v is modified then the derivative information in DDX and DDY will have to be recomputed before KURVP2 can be used with the new tension factor,

**Programming.** KURVP2 employs the function INT RVL and subroutine SNHCSH. KURVP2

was written by A. K. Cline and R. J. Renka (University of Texas at. Austin). INTRVL was written by A. H. Morris.

ABA


<small>Original source: [View scanned PDF page 365](scans/page_0365.png)</small>

<a id="topic-365-01"></a>
### Three Dimensional Spline Under Tension Curve Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QURV1` | `SUBROUTINE` | `N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ, ISLPSW, XP, YP, ZP, TEMP, S, SIGMA, IERR` | [`L98052`](source_parts/nswc_part_10.f90#L2806) |
| `QURV2` | `SUBROUTINE` | `T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA` | [`L98293`](source_parts/nswc_part_10.f90#L3047) |


Given n > 2 points (x1, y1, 21), -++) (Zn; Yn, 2n). One procedure for fitting a curve to

the points is to let s; = O and s; = 8,1 + J (ai - xy—1)? + (yi - ys—1)? + (25 — z%-1)? for t=: 2,...,m, and then to find splines a(s),y(s),2(s) with tension o that satisfy r(3,) = t;,4(9;) = w, and 2(s,;) = 2; fort =1,...,n. If (zi, yi, 24) aud (x), y!,2/), are the desired slopes for the curve s ++ (x(s), y(s), z(s)) at the points (z1, yz, z1) and (tn, Yn, 2n), then the

splines z(s), y{s), z(s) can be selected so that 2'(s,;) == 2!, y'(s;) = yf, and 2z'(s,;) = 2! for

% t= I,n. The curve s+ (x(s), y(s),z(s)) then passes ‘ ough the points (x5, ys, 2) and has the required slopes at the end points. The subroutine QURV1 is available for obtaining the second derivatives x"(s;), y’(s;),2"(s;) (¢ = 1,...,n) which characterize this curve, and the subroutine QURV?2 is available for computing the curve.

CALi QURV1(n, x, Y, 4, SLP1X,SUPLY SLP1Z,SLPNX,SLPNY, SLPNZ,IND,DDX,DDY,DDZ,TEMP, S, 7, IERR)

X is an array containing 2,,...,. VY an array containing yy, ...,Y,, and Z an array containing z;,. ,z, It is assumed tat n > 2 and that the points (2;,y,,2;) are indexed in the order that they are to be traversed by the curve. It is also assumed that (x3, Yes Wa )F(Ti4 1, Yir1,2041) for 4 = 1, a Sie

SLP1X, SLP1Y, SLP1Z and SLPNX, SLPNY, SLPNZ are assigned the values L,Y, 24 and z},,y),z). The user may omit values for SLP1X, SLPLY, SLPIZ and/or SLPNX, SLPNY, SLPNZ. The argument IND specifies the information that is provided.

IND = © Values are supplied for SLP1X,SLP1Y,SLPIZ and SUPNX,SLPNY, SLPNZ.

INE) = 1 Values are supplied for SLP1X,SLP1Y,SLP1Z but not for SLPNX, SLPNY, SLPNZ.

IND = 2 Values are supplied for SLPNX,SLPNY,SLPNZ but not for SLPLX, SLPLY, SLPiZ.

IND = 3 No values are supplied for SLUPIX, SUPLY, SLP1Z and SLPNX, SLPNY, SLPNZ.

If a value is not supplied by the user, then the routine provides a value.

7 is the tension factor to be « mployed. If |a| is small, say jo] < 1073, then x(s),y(s), z(s) approximate cubic splines. Otherwise, if |o| is large, say |o| > 100, then the resulting curve approximates the polygonal line from (r:, 41, 2;) to (Zn, Yn; 2n)-

TERR is an integer variable and S$, i) OX, DDY, DDZ are arrays of dimension n or larger When QURVI is called, if no input errors are detected then HEK? ig assigned the value O an the values 8), ..., 3, are computed aud stored in S. Also, the second derivatives "(sj yl") 2s) (Ft, jn) are compute and stored in Di &, DDY, DD4Z.

ThM? os an array of dimension mor la ger i! vt is used for a work space,


<small>Original source: [View scanned PDF page 366](scans/page_0366.png)</small>

```text
Error Return. IERR reports the following input errors:
IERR = 1 ifn <2.
IERR = 2 if (zy, y3, 26) = (2541, vit1, 241) for gome ft.
```

When either of these errors is detected, the routine immediately terminates.

**Remark.** After S, DDX, DDY, DDZ are obtained, QURV2 may be used to compute the curve.

**Programming.** QURV1 employs the subroutines CEEZ, TERMS, and SNHCSH. QURV1, CEEZ, and TERMS were written by A. K. Cline and R. J. Renka (University of Texas at Austin).

```fortran
CALL QURV2(T, XS, YS, ZS, N, X, Y, Z, XP, YP, ZP, S, SIGMA)
```

X is an array containing 7), ...,Z,, Y an array containing yi, ...,Yn, and 4 an array containing 21, ...,2,. © is an array containing s;,...,8,, and DDX, DDY, DD2d are arrays containing the second derivatives z"(s,), y(s;),2"(s.} (¢ = 1, ...,n}.

Now consider the change of variables t = s/s, and let t + ((t),y(t),z(t)) denote the curve in terms of the new parameter t. XT, YT, ZT are real variables. For any 0 < ¢ < 1, QURV2 computes the point (Z(¢),y(t),Z(t)) on the curve and assigns XT, YT, ZT the values x(t), y(t) Z(t).

**Remark.** After DDX, DDY, DDZ have been obtained, QURV2 may be repeatedly called to evaluate the curve at different points so long as the tension factor o remains fixed. However, if o is modified then the derivative information in DDX, DDY, DDZ will have to be recomputed before QURV2 can be used with the new tension factor.

**Programming.** QURV2 employs the function INTRVL and subroutine SNHCSH. QURV2 was written by A. K. Cline and R. J. Renka (University of Texas at Austin).


<small>Original source: [View scanned PDF page 367](scans/page_0367.png)</small>

B-SPLINES

```text
For k > 1 let f(t) = (t-- 2)*~! when t > x and f(t) = 0 when t < x. Then for
any sequence f; < -++ < ti4% where t; < tye, let Bys(z) = (ti4n — ta) f (ts, -.., teen] where
f(y, .--,ti4e] is the **” order divided difference of f(t). The function By, is called a
B-apline of order k. For k =: 1 it fol!ows that
```

Pal)={ 4 oe 0 otherwise.

More generally, for k > 2 By,(x) =O when 2 ¢ [t,,t:44). Fort; < 2 < tise

k~1

Li4k 2

By (x) = (24-2) when a tigk—2 and 1 t

k-1 [ rt, Bya(z) = \hoak — ) when t,41 = +++ == tyi.

Otherwise, if no point appears more than k -- 1 times in the sequence {t;, ...,t;4,} then tik - 2

~t, ‘ Bix (z) = —— By g(a) + Bi 1 ka (2). toge-a7 hy tote — tga

From these relations it follows that By,(z) > CG when t; <2 < tyy,.

Now let €: < +++ < €¢41 be a sequence of points where @ > 1. If m, is an integer where l<m,;< k-1 for 7 = 2,...,8@, let Pelé, ...,€e41; m2, ..., me] denote the collection of piecewise polynomials p(z) where p(x) is a polynomial of order < k (degree < k —- 1) on each interval [€5,€)41) (9 = 1,...,8, and p(r) is of class Ck-!~™ at each point €; (g = 2,...,@). Then €,...,£e1 are called the knots or break points for these piecewise polynomials, €2, ...,€/ the interior knots, and m2, ...,m¢g the multiplicities of the

interior knots.

Ifn=k+mg, + +++ + mgs, consider any sequence ty <--+ < ty4, where (1) th SS te < &, (2) tey1,---,, are the interior knots, where each interior knot €; appears exactly m, times, and

‘Then the B-splines Bix, ..., Bag ave piecewise polynomials in Py[E1,...,€e41;m2, -.., me], forming a basis for this vector space. Consequently, any piecewise polynomial p(x) in the space can be represented uniquely in the form p= 90°. , a,8,,. This representation is called a B-spline representation for p(x). Wp $3? , a, By, then we note that p(z) = Oif 2 < t

or ze > tyyk.

**Remark.** [If t, <2 << t,,, where ko gon, then Bya(r) / Oonly when td . 74 1 kyo. 7. Also », Bix (x) !

AS7


<small>Original source: [View scanned PDF page 368](scans/page_0368.png)</small>

<a id="topic-368-01"></a>
### Finding The Interval That Contains A Point

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `INTRVL` | `INTEGER FUNCTION` | `X, T, M` | [`L98570`](source_parts/nswc_part_10.f90#L3324) |


Let ty < +++ < ty, be a sequence where ty <t,,. Then for any ¢; < 2 < tm, the function INTRVL finds the interval [1,,t;41) that contains 2.

```fortran
INTRVL(X, T, M)
```

T is an array containing t,, ...,f,, and z areal number. Ift, < zx <t,, then INTRVL has the value ¢ where t; < z < t;,,. Otherwise,

1 ifz< ty

INTRVL(2,T,m) = |) taét fe>ty

where @ is the integer such that t, < tei, and tay, = ++ =ty.

**Programmer.** A. H. Morris.

48Q


<small>Original source: [View scanned PDF page 369](scans/page_0369.png)</small>

<a id="topic-369-01"></a>
### Evaluation And Differentiation Of Piecewise Polynomials From Their B-Spline Representations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVAL` | `SUBROUTINE` | `T, BCOEF, N, K, X, JDERIV, W, WK` | [`L98640`](source_parts/nswc_part_10.f90#L3394) |


For n > k > 1 let ty < +++ < tay, be a sequence where t, < tyy, and ty < ti4, fort =1,...,n. If f(z) = S02, a: Bix(z) then the following subroutine is available for evaluating f(z) and computing its derivatives.

```fortran
CALL BVAL(T, BCOEF, N, K, X, JDERIV, W, WK)
```

TY is an array containing ?¢1,...,t,4, and A an array containing a,,...,@,. The argument 7 is a nonnegative integer, x is a real number at which f(z) or its j* derivative f(x) is to be computed, and w is a variable. If z # t,4, then w is assigned the value f(z+) if j =0 and the value f)(x+) if 7 > 1. Otherwise, if z = t,,4, then w = f(tnix—) if 7 =U and w= {O(tnae-) if 7 > 1.

WK is an array of dimension 3k or larger that is a work space for the routine.

**Remark.** The left limits f(tn4,—) and f?)(t,44—) are the only limits of interest when x =tny,, since f(z) =0 for all r > tyyg.

**Programming.** BVAIL employs the function INTRVL. BVAL is a modified version by A. H. Morris of the function BVALUE, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 370](scans/page_0370.png)</small>

<a id="topic-370-01"></a>
### Evaluation Of The Indefinite Integral Of A Piecewise Polynomial From Its B-Spline Representation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVALI` | `SUBROUTINE` | `T, BCOEFF, N, K, X, W, WK` | [`L98825`](source_parts/nswc_part_10.f90#L3579) |


Forn > k> 1 let ty < «+: < tay, be a sequence where t, < ty4; and t; < tj; for t=1,...,n. If f = 0%, a:Bs, then the following subroutine is available for computing

P(x) = fz f(t) de. CALL BVALI(T, A,n,k,z,w,WK)

T is an array containing t,,...,t,4% and A an array containing a;,...,@,. The argument z is a real number and w is a variable. When BVALI is called, w is assigned the value F(z).

WK is an array of dimension n+ 3(k +1) or larger that is a work space for the routine.

```text
Algorithm. For m= n+ &, let tii, ...,tm4e be any sequence where tm <tmyi1 Sc S
tmik If a < tm then F(z) = ny! 6; By e41(z) is used where b; = } yet a,(ty 4“ — ty)
fori =1,...,n and 6; = 6, forts =n+1,...,m-—1.
```

**Programming.** BVALI employs the subroutine BVALIO and the function INTRVL. BVALI was written by A. H. Morris.


<small>Original source: [View scanned PDF page 371](scans/page_0371.png)</small>

<a id="topic-371-01"></a>
### Conversion Of Piecewise Polynomials From B-Spline To Taylor Series Form

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSPP` | `SUBROUTINE` | `T, A, N, K, BREAK, C, L, WK` | [`L98994`](source_parts/nswc_part_10.f90#L3748) |


For n > k > 1 let ty < --- < tay, be a sequence where t; < ty4,% for: = 1,...,n. Further assume that t, <t,4; and let f(z) = > a; By. (xz) forth <2 < thar. If: <--- < €¢41 are the distinct points in the sequence {te .»tn41} then the piecewise polynomial f can be represented in the form f(r) = > cij(z — €;)'"} for €&; S 2 < 641 (7 = 1,...,2). The following subroutine is available for obtaining the coefficients c,,; of this representation.

```fortran
CALL BSPP(T, A, N, K, BREAK, C, L, WK)
```

T is an array containing t,, ...,t,4, and A an array containing aj,...,@,. BREAK is an array of dimension @ + 1 or larger, C a 2-dimensional array of dimension k x @, and i a variable. When BSPP is called then L is assigned the value & (which is computed by the routine), the break points €; < +--+ < € 41 are found and stored in BREAK, and the coefficients c,; are computed and stored inC. The j** column of the matrix C' then contains the coefficients of the j** polynomial forming f (j = 1, ...,@).

WK is an array of dimension k(k + 1) or larger that is a work space for the routine.

**Remarks.**

(1) Since 2<n~k+1, BREAK may be declared to be of dimension n — k + 2 and C to be of dimension k x (n — k +1).

(2) After C is obtained, then PPVAL may be used to evaluate f(x) for any z € [€1, €e41]. However, PP VAL cannot be used for evaluating f(x) if a < €; or x > €¢41. BVAL must be used in this case.

**Programming.** BSPP is a modified version by A. H. Morris of the subroutine BSPLPP, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 372](scans/page_0372.png)</small>

<a id="topic-372-01"></a>
### Evaluation Of Piecewise Polynomials From The!Ir Taylor Ser'Es Representations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PPVAL` | `SUBROUTINE` | `X, A, L, N, XI, YI, NI` | [`L99098`](source_parts/nswc_part_10.f90#L3852) |


```text
k .
Given z1 <-++ < 2¢41. If f is a piecewise polynomial where f(x) == 3> ej;{x — x;)*~'
tw=l
for zy <x <a2y41 (7 = 1,...,@), then the following subroutine is available for computing
```

f at any point z.

```fortran
CALL PPVAL(X, A, L, N, XI, YI, NI)
```

X ig an array containing the knots z,,...,r¢ and C ak « € matrix containing the coefficients c,;. It is assumed that k > l and @> 1. Let Z1,...,Z, be the points at which f is to be evaluated. XI is an array containing Z,,...,Z,, and YI an array of dimension m

or larger. When PPVAL is called, f(Z,) is computed and stored in YI(j) for 7 = 1,...,m.

**Remarks.**

(1) X need not contain the knot r¢41.

(2) It is not required that f be continuous at an interior knot 2,. If z; appears in XI then f(xz.+) is computed.

(3) It is not required that the output points Z, in XI be in the interval (71,2241). If Zy< 4 then )’, ey1(z ~ 2,)'~? is evaluated at Z,. Otherwise, if Z; > ze41 then d, te(z - re)*~? is evaluated at Z,.

**Programming.** PPVAL is an adaptation by A. H. Morris of code written by Rondall E. Jones (Sandia Laboratories).


<small>Original source: [View scanned PDF page 373](scans/page_0373.png)</small>

<a id="topic-373-01"></a>
### Piecewise Polynomial Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSTRP` | `SUBROUTINE` | `TAU, GTAU, T, N, K, BCOEF, Q, IFLAG` | [`L99416`](source_parts/nswc_part_10.f90#L4170) |


Forn > k > 1 fet ty < +--+ < thy, be a sequence wnere t; < tyy, fort = 1,...,n. Consider a set of points {(z,,y;) :f = 1,...,n} where t, < zy < +++ < gy < tnya. Then we wish to find a piecewise polynomial f = )°>?., a;B,~ which satisfies f(z,) = y for t= 1,...,n.! This problem has a unique :..lution when t; < z,; < ti44% for 1 <1 <n. The following subroutine is available for obtaining the coefficients a;, ...,a, of the interpolating piecewise polynomial,

```fortran
CALL BSTRP(TAU, GTAU, T, N, K, BCOEF, Q, IFLAG)
```

X ig an array containing z,,...,7,, Y an array containing yi, ...,¥,, and T an array containing t1,..-,tn4%- A is an array of dimension # or larger, and IFLAG an integer variable. On an initial call to the routine the user may assign IFLAG any nonzero value. In this case, if no errors are detected then IFLAG is reset by the routine to O and the B-spline coefficients aj, ...,a@, are computed and stored in A. The routine may be recalled with IFLAG = 0 on input when only Y is modified. In this case, no error checking is performed and IFLAG= 0 on output. Also the B-spline coefficients a, ...,a, of the new interpolating piecewise polynomial are computed and stored in A.

WK is an array of dimension (2k — 1)n or larger that is used for temporary storage by the routine. When BSTRP terminates, WK contains information needed for subsequent calls to the routine.

**Error Return.** IFLAG is assigned the value 1 if any of the conditions

Tp<c< zy

< ty S21 < tag tioayn<ty, fori<it<cn

ty < In < fad igs violated. When an error is detected, the routine immediately terminates.

**Remarks.**

(1) It is recommen ‘ed that t) = +--+ = ty and tyy, = ++ = tak.

(2) After the B-spline representation », a, By, is obtained, then the subroutine BVAL can be used to evaluate or differentiate the piecewise polynomial.

Example Given n> 4 data points (7,,y,), then for & done may set dy, +.) te ory, thas Z,,2 fore l,...,n ky and x, bingy cot tnin. Then ry,....2, 9 are the interior knots for the interpolating piecewise polynomial fo Here we have cubic spine

interpolation Where the data points ag and 7, 1. are not knots for f.

Moa tay then by fra} we died ‘fra )

Dae)


<small>Original source: [View scanned PDF page 374](scans/page_0374.png)</small>

**Programming.** BSTRF calls the subroutines BSPVB, RANFAC, and BANSLV. BSTRP is a modified version by A. H. Morris of the subroutine SPLINT, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 375](scans/page_0375.png)</small>

<a id="topic-375-01"></a>
### Weighted Least Squares Piecewise Polynomial Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSLSQ` | `SUBROUTINE` | `TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR` | [`L99778`](source_parts/nswc_part_10.f90#L4532) |


Forn > k > 1 let ty < +++ < tyy«% be a sequence where t; < t,,, for s = 1,...,n. Consider a set of points { (2,;,y;):1 = 1,...,m} where ty < ay <+-+- < am < tay, and m > max{2,k}. Let wy > 0(¢ = 1,...,m) be weights. Then the following subroutine is available

for finding a piecewise polynomial f = S77, a; Bie which minimizes 7, w,y(f(2i) -— ys)? 2 CALL BSLSQ(X,Y,W,m,T, n,k, A,WK,Q, TERR)

X is an array containing 71,...,%m, Y an array containing y1,...,y¥m, W an array containing wy,...,Wm, and T an array containing t), ...,t,4,. Ais an array of dimension nor larger. When BSLSQ is called, if no input errors are detected then the coefficients 1, ---,@, of a least squares approximation f are computed and stored in A.

WK is an array of dimension n or larger, and Q an array of dimension kn or larger. WK and Q are work spaces for the routine.

```text
IERR is a variable that reports the status of the results. When BSLSQ terminates,
IERR has one of the following values:
```

TERR = O The coefficients were obtained. The least squares approximation is unique. IERR = 1 The coefficients for a least squares approximation were obtained.

The approximation is not unique. IERR = —1 (Input error) Either ¢, < 21 <-+++ < am < tn41 or m > max{2,k} is violated.

Selection cf t, < +--+ < tay, given the data (z,;,y;). It is recommended that the knots t, be selected so that there are data points 2,;, < +++ < a,, satisfying ¢) < t) < tye for v = 1,...,n. If these conditions are satisfied then the least squares approximation is unique.

**Remark.** After the B-spline representation is obtained, then the subroutine BYVAL can be used to evaluate or differentiate the piecewise polynomial.

**Programming.** BSLSQ calls the subroutines BSPVB, BCHFAC, and BCHSLV. BSLSQ is a modified version by A. H. Morris of the subroutine LEAPPR, written by Carl de Boor (University of Wisconsin).

**Reference.** de Boor, Carl, A Practical Guide to Splines, Springer-Verlag, 1978.


<small>Original source: [View scanned PDF page 376](scans/page_0376.png)</small>

<a id="topic-376-01"></a>
### Least Squares Piecewise Polynomial Fitting With Equality And Inequality Constraints

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BFIT` | `SUBROUTINE` | `BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW` | [`L100077`](source_parts/nswc_part_10.f90#L4831) |


```text
For n > k > 1 let t) < +++ < thax be a sequence where t, < ty4,% (§ = 1,...,n).
Consider a set of points { (z;,y;): 1 = 1,...,m} where &, < zy <+++ < am < tyyy. Then
the subroutine BFIT is available for obtaining a piecewise polynomial f = 30°, a: Bye
which minimizes )>,(f(z:) — yi)? subject to a set of constraints.
```

```text
Notation. If t, < z <tn41 then f%)(z) will denote the value f(x+) if 7 = 0, and the right
jth derivative fO (c+) if 7 > 1. Otherwise, if x = t,4, then f(z) = f(tagi—) if 7 =0
and f) (2) = fO)(tayi-) if 7 > 1.
```

```fortran
CALL BFIT(BKPT, N, NORD, XDATA, YDATA, NDATA, XCONST, YCONST, NDERIV, NCONST, MODE, COEFF, RNORM, W, IW)
```

T is an array containing t,...,tn44%, X an array containing 7), ...,2%m, and Y an array containing y,,...,Ym- The argument @ is the number of constraints to be satisfied (£ > 0) and XCON, C, NDER are arrays of dimension max{1, £} or larger.

If 2 > 1 then XCON contains the points 2), ...,£¢ at which the constraints are placed. The points Z; may be given in any order and need not be distinct. It is assumed that th <2; <thy1 fort =1,...,@ At @; any of the foilowing types of constraints itype = 0 f(z) < itype= 1 f)(B) > ey itype = 2 fO)(z,) = itype = 3 f)(%,) = fO (c,) can be imposed where 7 is a nonnegative integer. For the selected constraint, it is assumed that C(#) = c, and NDER(‘) = itype + 47. If an itype 3 constraint is imposed then it is further assumed that ty < cy < ty41.

WK and IWK are arrays that are work spaces for the routine. On input, IWK(1) is the dimension of WK and IWK(?2) the dimension of IWK. If @ = O then one ray set JWK(1) ~ NB and [WK(2) = 2 where NB = (n+ 3)(k #1) | k®. Otherwise, let ves n + 1, m, be the number of equality (i.e., itype 2 and 3) constraints, and m, the number of inequality (itype O and [} constraints. Then one must set

IWK(1) > NB + (v4 ey t 2fm,. tv) t+ (rm, tv) tf (ry | 2)fe + 6) IWK(2} > m, 4 2v.

**Remarks.**

(t) If € > t then one can let the routine determine the amount of storage that is needed for WK and IWK. Set WHI) NB and IWK(2)) . 2, 1m which case errors will occur (see the IND «6, > 7 error values below),

(2) NDER(1) may be assigned a negative value (1 hoo. jf) EE NDER(G) © 0 chen she

constraint is ignored


<small>Original source: [View scanned PDF page 377](scans/page_0377.png)</small>

IND is a variable used for input/output purposes, A an array of dimension n or larger, and ra variable. IND must be set to 0 on an initial call to BEIT. When the routine is called, if f is found then IND is assigned the value 0 or 1, the coefficients. a), ...,ti, are

/ 5 stored in A, and r is assigned the value V du (f (zs) ~ yi).

After an initial call to BFIT, if only the constraints are modified, then the information in WK concerning X and Y can be reused. In this case, one may set IND to a nonzero value and recall BFIT to solve the new problem. The input setting IND # 0 can be used only when T,n,k,X,Y,m, and WK have not been modified since the last call to BFIT

When BFIT terminates, IND reports the status of the results. IND is assigned one of the following values: IND = 0 The piecewise polynomial f was obtained. IND = 1 The equality (i.e., itype 2 and 3) constraints are contradictory. The solution f was obtained where the equality constraints were satisfied in a least squares sense.

IND = 2 The problem could not be solved. The constraints are contradictory.

IND = -lLk<lork>n.

IND = --2 m<Ooré< 0.

IND = ~-3 t, > t,4.1 for some t.

IND = —4 The assumption t, < 21 < +++ < 2m < lnyy is not satisfied.

IN]} = —5 The ¢'® constraint is incorrect for the value of 1 stored in IWK(2).

IND = --6 Insufficient storage was specified for the WK array. }WK(1) has been reset to the amount of storage needed by WK.

IND = --7 Insufficient storage was specified fer the IWK array. IWK(2) has

been reset to the amount of storage needed by TWK. IWK(1) and IWK(2) are not modified when IND ¥ -—-5, ~6, --7.

**Example.** If one wants f to be convex on an interval {t;,¢:41), then this is equivalent to requiring that f"(2) > 0 on the interval. Thus, if k - 4 then it suffices to require that f"(t.+) > O and f"(tyya-) > 0. For these two constraints, 9 is the appropriate value for the NDER array.

**Programming.** BEIT employs the routines BFITO, BNDACC,BNDSL, BSPVB, BSP\ D, LSE], and the subroutines and functions used by LSEL BEET is a modification by AH. Morris of the subroutine PC, written by Richard Jo Hanson (Sandia Laboratories). ‘The subroutines BNDACC and BNDSL were written by Richard Jo Hanson aud Charles 1, Lawson (Jet Propulsion Laboratory), and are described in reference (2).

References

(1) Hanson, HJ), Constrained Least Squares Curve Fitting to Discrete Data using Le Splines A User’a Guide, Report SAND 78 129), Sandia Laboratories, Albuquerque, New Mexico, 1979.

(2) Lawson, Coto, and Wansen. HO, Solving Least Squares Problems, VPreutice t all,

Englewood Cliffs, New Jersey. BUT:


<a id="category-378"></a>
## Surface Fitting over Rectangular Grids

<small>Original source: [View scanned PDF page 378](scans/page_0378.png)</small>

<a id="topic-378-01"></a>
### Bicubic Splines and Bisplines under Tension


Given a real value o and a set X = {21,...,2m} where zy < +++ < tm. Let S,(X) denote the collection of splines having the tension factor o and knots 2), ...,¢%m. Ifo = 0 then S,(X) is the collection of cubic splines with the knots zy, ..., 2m.

Now S,(X) is a vector space, where each of its splines f(x) is uniquely characterized by the values f(z1), ...,f(zm) and derivatives f'(x1) and f'(rm). Let y,(2) (§ = 1, ...,m) be the spline in S,(X) where

```text
Ws (2) =1
wi(z,) =0 fork #4:
Wy (21) = ¥i(em) = 9,
and let tm41,Wm+2 be th splines where
```

m+1(%m) =0 m+2(lm) = 1.

Then {q1, ...,%ma2} is @ basis for S,(X) and f = f(cadvdst f (21) bm4it fom) vm4e2 t= 1 for each spline f(z) in S,(X).

Let ¥Y = {yi,..-,yn} where yy <-+- < yp and let {yy, ...,%,,,2} be the corresponding basis for S,(Y). Then a function of the form

mi-2n4+2

P(2,y) = >> ST aa dsl2)¥,(y)

rl 7-1

is called a bispline with the tension factor o (also, bicubic spline when o = 0). A bispline

FCr,y) has the following properties:

(1) (x,y) sa C? mapping on [21,25.] * [yt, val-

(2) For each fixed y the mapping x +> F(x,y) is a spline in S,(X), and for each fixed x the mapping y+ > F(z, y) is a spline in S,(Y).

(3) F is uniquely characterized by the values F(2,,9,), Dil (te. y;,), Dal (ay, ye), and D,D2F (re, Je) wheret ot, ...,m, 70 1, ym, ko By, and @ = tn!

Ifo Gthen a bicubic spline Pyro y) hes he value

3.08 “No k t \ Rey) DoD Lele My) KR Of 4) for sy we agp andi, ys tyyy where cg are consbe os be or oon Eo on)

Pye, Boat bak dhetiabe the partial derivatives of F


<small>Original source: [View scanned PDF page 379](scans/page_0379.png)</small>

<a id="topic-379-01"></a>
### Weighted Least Squares Bicubic Spline Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [`L101064`](source_parts/nswc_part_10.f90#L5818) |


GHVER ty <osee << ty and vy < +++ < vq, where mn > 2. Let { (tr, Ye,2re) 1 = 1,...,¢;9 2 1,...,} be a set of points where p,v > 4,u, < ay << Ly < Um, and SM st Sw S U_. Also let wy,...,w, and ti,,...,W, be positive weights. Then the following subroutine is available for finding a bicubic spline f(z,y) having the knots ui0; (= 1,...,.m,7 = 1, ...,n) which minimizes » s wrt [f (Zr, Ye) — Wal’. =ITe=1

```fortran
CALL SPFIT2(X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR)
```

X is an stray containing ay, ...,2,, WX an array containing wy, .++yWy, % an array containing ui, ..,¥., WY an array containing W,,...,@,, Z the p x v matrix (Zr), U an array containing “1, ...,Um, and V an array containing v1, ...,v,. It is assumed that kz ~ pw, where kz is the number of rows in the dimension statement for 2 in the calling program.

& js a 3-dimensional array of dimension mxnx 4, and IERR a variable. When SPFI'L2 is called, if no Input errors are detected then IERR is set to Q and the values /(u,,v,),

Dy f(t, v5), De f(t, vs), Di De f (uj, v;) of a weighted least squares bispline approximation yr}

f(x,y) are computed and stared in.) Specifically,

(1, 9,3) = 14 f (ue, vy) Fj 4) © 1 Daf (u,,v,)

opsach tos dy ...jmeand gy 0 1, ...yn.

Sis an array o dimension née f 6, 7 oan array of dimension n ¢ 6. and WK an array ef dimension NUM where NUM > max {(r | ")G0 ' 2) (m4 2) 7 Smaxfan | Bn 2y}. Sy and WE are work spaces for the routine

Error Return. HERE has one of the following values if an Input error is detected:

IERR Loither wy see) ou, orm 2 as violated.

1 n URE “ lies ty Bp 8 et dy or ge > ds violated. HR ther vy oe copy orm oe Bie violated.,

PURE 4 Either pp yy ee ye oe ote 4 is violated Her S NUM is tee small (“The minimum permissible value for NUM has Pera stored WEE} Reso NOM © WIL).

Wourwk After the array # ois obtained, thea the subroutine ColUEERE can be used ra

afer differentiate che bispline flr y)

PP yf dene te the partial derivatives cf f


<small>Original source: [View scanned PDF page 380](scans/page_0380.png)</small>

**Programming.** SPFIT2 employs the routines CSSP, BSLSQ2, BSLSQ1, BSPVB, BCHFAC, and BCHS¥V1. SPFIT2 was written by A. li. Morris.


<small>Original source: [View scanned PDF page 381](scans/page_0381.png)</small>

<a id="topic-381-01"></a>
### Evaluation and Differentiation of Bicubic Splines

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [`L101349`](source_parts/nswc_part_10.f90#L6103) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [`L101532`](source_parts/nswc_part_10.f90#L6286) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [`L101575`](source_parts/nswc_part_10.f90#L6329) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [`L101753`](source_parts/nswc_part_10.f90#L6507) |


Given uy <++: < tm and v) <-+:+: <», where m,n > 2. Then a bicubic spline f(z,y) having the knots (u,,v,;) is uniquely defined by either of the following sets of data:! (1) the values f(us, v5) and derivatives Di f(u,,v;), Dof(us,vj), Dy Da f(us, v;) for

t=1,...,mand7=1,...,n (2) the values f(us, 05) and derivatives D? f(uy,v;), D2 f (uy, v;), DE DZ f(u;, v;) for t=1,...,mandj=1,...,n

The subroutines CSURF and CSURF1 are available for computing f(z, y) or its derivative Dk D£f(z,y) if data set (1) is given, and the subroutines CSRF and CSRF2 are available for computing f(z, y) or its derivative if data set (2) is given.

CALL CSURF(k, é, X,p,Y,v, Z, kz, U,m,V,n,W, kw, Wy, kw1,W2, kw, W:2, kwy2)

U ig an array containing t),...,tm, V an array containing vy, ...,v,, and W, Wy, W., Wi2 the m x n matrices (f(us,%;)), (Dif (us,2;)), (Def (us,v;)), (D1 D2 f(u,-;)) The arguments kw, kw ,, kw2, and kw 2 have the following values:

kw = the number of rows in the dimension statement for W in the calling program

kw, = the number of rows in the dimension statement for W, in the calling program

kwz = the number of rows in the dimension statement for W., in the calling program kwyq = the number of rows in the dimension statement for Wy; in the calling program it is assumed that kw > m, kw, > m, kw2 > m, and kwy2 > m.

The arguments k and @ are nonnegative integers. Let (r,,y.) (r = 1,.-.,H, $ 1, ...,v) be the points where D'S f is vo be computed. X is an array containing 71, ..., z,, Y an array containing y,...,y., and 4 a 2-dimensional array of dimension kz x v

where kz > wp. When CSURF is called, the values DEDS f(r, Yo) are computed and stored in Zforr--1,...,fands— l,...,v.

**Programming.** CSURF calls the function INTRVL. CSURF «as written by A. TE Morris.

```fortran
CALL CSURF1(IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F)
```

U is an array containing u;, ...,uU,,, oan array containing vy, ..,0,, and Woa 3- dimensional array of dimension mx n x 4. tis assumed that

Wr g,t) . flue) a 1) Ds flu.) Wr, 7,3) Di f(u,e,) Wn 4) DD flac) fors: 9,...,mand7> 1, 0...n. Ty fand Daf denote the partial derivatives of f, and Pek py eee me Ra Gly fk bad, HH

oré . 3then DRDO F(r,y) denotes the right limit DD f(s tive).


<small>Original source: [View scanned PDF page 382](scans/page_0382.png)</small>

The arguments k and f are nonnegative integers. Let (z,,y,) (r = 1,...,4, ¢ = 1,...,v) be the points where DF D{f is to be computed. X is an array containing zy, ..+) Zp, Y an array containing yz, ...,yv, and Z a 2-dimensional array of dimension kz x v where kz > wp. When CSURF'1 is called, the values D? Df} f(x,, ys) are computed and stored in Z forr=1,...,pands=1,...,v.

**Programming.** CSURF1 is a driver for the subroutine CSURF,. The function INTRVL is used. CSURF 1 was written by A. H. Morris.

CALL CSRF(k, £,X,u,Y,v,Z,k2,U,m,V,n,W, kw, Wi, kw,,Wo, kwe,Wiz,kwi2)

U is an array containing w),...,t%m, V an array containing v1,...,t,, and W, Wy, Wa, Wi2 the myn matrices (f(us,v,)), (D?f(use;)), (DES (us, v;)), (PDF f (us, v;)). The arguments kw, kw,, kwe, and kwy. have the following values:

kw = the number of rows in the dimension statement for W in the calling program

kw, = the number of rows in the dimension statement for W, in the calling program

kwz = the number of rows in the dimension statement for W2 in the calling program kw y2 = the number of rows in the dimension statement for Wy2 in the calling program It is assumed that kw > m, kw, > m, kw. > m, and kwy2 > m.

The arguments k and @ are nonnegative integers. Let (z,,y.) (r = 1,...,H, 8 . 4 * we . . i, ...,v) be the points where DED‘ f is to be computed. X is an array containing 2), ..., xy, Y an array containing yi, ..-, vv, and Z a 2-dimensional array of dimension kz xX v

where kz > p. When CSRF is called, the values DED{f(2,, ys) are computed and stored in Z forr=1,...,u and a= t,...,v.

**Programming.** CSRF calls the function INTRVL. CSRE was written by A. H. Morris.

```fortran
CALL CSRF2(IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF)
```

U is an array containing uy, ...,tm, oan array containing vy, ...,u,, Wo othe mov n matrix (f(u,,v,)), and DDW a 3-dimensional array of dimension mx rns 3 where W1.9,38)) DID S(u,e,)

ids forse 1,...,meand zy o4,.. nm. The argument Aw has the following value:

Aw | the number of rows in the dimension statement for Worn the calling program

It is assumed that Aue + ora,

The arguments A and @ are nonnegative integers Let fa, uy) (rv lL. opis x ¥ t \ Ua) } . t . 1, .,v) be the points where Of a fois to be computed Yo ois an array Containing £4, (Ty, ) at array containing yy, (Y, and 4a 2 dimensional array of dimension Aa ee where kz 0 ou. When CSR? as called, the values 2* 290, yl) are computed and stored in forr o1,. .,yeands |, ae

oli


<small>Original source: [View scanned PDF page 383](scans/page_0383.png)</small>

**Programming.** CSRF2 is a driver for the subroutine CSRF. The function INTRVL is used. CSRF2 was written by A. H. Morris.

ott


<small>Original source: [View scanned PDF page 384](scans/page_0384.png)</small>

<a id="topic-384-01"></a>
### Bispline Under Tension Surface Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [`L101797`](source_parts/nswc_part_10.f90#L6551) |


Given zy < +++ < 2m and yy < ++: < y,. Also assume that we are given the values aij (¢ = 1,...,m;7 = 1,...,n) and a tension factor o. Then the subroutine SURF is available for finding a bispline F(z,y) with tension o that satisfies F(z,,y,;) = 2;; for each 1,7. Boundary conditions can be imposed on the surface F(z, y} if desired.

```fortran
CALL SURF(M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR)
```

X is an array containing 21,...,2m, Y an array containing y1,...,y,,and Zthemxn matrix (z,;). The argument kz is the number of rows in the dimension statement for Z in the calling program. It is assumed that m > 2,n > 2, and kz > m.

OPT is an array, called the option vector, which permits the user to specify any boundary conditions that are to be imposed on the surface. If no boundary conditions are to be specified then OPT may be declared to be of dimension 1 and OPT(1) must be assigned the value 0. The details concerning the specification of boundary conditions in OPT are given below.

DDZ is a 3-dimensional array of dimension m x n x 3 and JERR is a variable. When SURF is called, if no input errors are detected then IERR is assigned the value % and the partial derivatives D?F(z,,y;), DZ F(z.,y,),D? D2 F(z,,y,) (f= 1,...,mj7 = 1,...,n) are computed and stored in DDZ. DDZ(1, 7,1) DZ F(a,,y,), DDZ(, 7,2) — D?F(2,,y5), and DDZ(¥,7,3) — D? D2 F(2,,y,) for each 4, 9.

WK ts an array of dimension rm + 2n or larger that is used for a work space.

```text
Error Return, TERR reports the following input errors:
IERR Laff. Qor ne 2.
IERR 2 af Eye ores Ty, OF Yr ort Un i onet satistied
IERR 3 Gf OPP contams an error
```

When an errors detected, the routine immediately terminates -«

Remark After Diifos obtained. then Che function SURF! may be used to evaluate the bispline F(r,y). Also, ofa O then the subroutine CSRE2 may be used to evaluate or differentiate Flr y) The option vector OPT Tf no boundary conditions are ta be imposed then OPT mas be declared to be of dimension i and Cai) cust have the value O Otherwise, GHP as an array containing the information keyg. dats, keve. Gatag, hey ubstag th Vha bast eriryan in the value Go Baa h group of data key,, data, (1 \ oa) oas called an option. bach key, is an integer and data, ius a dst of partial derivative values thar oh

surface A Gr, y) is required to satisfy The following options are available

key PE The values 2b Cry.y.) G2 1, mpolust be satisfied key 2 OVhe values 2), Fle,.. vi) a ore} trrtist lie satusties! hey 4 The values JF bry ys) tt ! sit trtist bee satisfied


<small>Original source: [View scanned PDF page 385](scans/page_0385.png)</small>

```text
key = 4 The values D2 F(2,,y,) (¢ = 1,...,m) must be satisfied.
key = 5 The value D; D2 F (1, y,) must be satisfied.
key = 6 The value D, D2 F(zm,y1) must be satisfied.
key = 7 The value D, Dy F (21, y,) must be satisfied.
key = 8 The value D, Dz F (zm, yn) must be satisfied.
```

The order of the options in OPT is arbitrary. If an unrecognized key is used then the error indicator [ERR is assigned the value 3 and the routine terminates.

**Example.** Assume that we have an array DY1 containing values D2 F(a,,y1) (§ = 1, ...,m) which are to be satisfied, and that we also want D;DoF(2m,yn) = --1.3 to be satisfied. Then OPT must. be of dimension > m+ 4 and OFT can be defined as follows:

```text
OPT(1) = 3.0 (First option)
DO 10 = 1,M
10 OPT (i+ 1) = DYL(D
OPT (M + 2) = 8.0 (Second option)
OPT (M+3)= ~-1.3
OPT (M + 4) = 0.0 (Terminates the option vector)
```

Background. The evaluation of D? F(z,,y;), D3 F(2:,y;), and D? Di F(z,, y,) reduce to the evaluation of second derivatives of splines. Specifically, for each ¢ < m D2F(2,, 91), ..., D2 F(z, yn) are the second derivatives that characterize the spline y > F(a:,y), and for each y <n D?F(21,y;),..., D?F (tm, y,) are the second derivatives that characterize the spline z++ F(z,y;). Also D, D3 F(2,,y;) and D, D2F(2m,y;) (7 = 1, ...,n) are the second derivatives that characterize the splines y > D,F(21,y) and y++ D,F(zm,y). For each j < m, after one obtains the values D3 F(z,,y,;) through which the spline ++ DEi*(x,y;) will pass and the end slopes D, D3 F(x1,y;) and D, D3? F(zm, y,;) which this spline must have, then the second derivatives that characterize this spline can be computed. D? D2 F (2, y;), ...; Di DZ F(2m,y;) are the second derivatives that characterize x ++ D2 F(z, y,).

**Programming.** SURF employs the subroutines CEEZ, TERMS, and SNHCSH. SURF was written by A. K. Cline and R. u. Renka (University of Texas at Austin), and modified by A. H. Morris.

ala


<small>Original source: [View scanned PDF page 386](scans/page_0386.png)</small>

<a id="topic-386-01"></a>
### Bispline Under Tension Evaluation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [`L102235`](source_parts/nswc_part_10.f90#L6989) |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [`L102404`](source_parts/nswc_part_10.f90#L7158) |


Given 21 <+++ < dm and yy < +++ < yn, and let F/z,y) be a bispline with tension o. If the partial derivatives D? F(2,,y,;), D3 F(2,;,y,;), D? D2 F(z,;,y;) are known for? = 1,...,m and 7 := 1,...,", then the function SURF2 may be used for evaluating F(z, y) at a single point, and the subroutine NSURF2 may be used for evaluating F(z, y} on a grid of points.

```fortran
SURF2(XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA)
```

X is an array containing 21,...,%m, Y an array containing yj], -..,Y%n, and Z an m xX n matrix containing the values F'(z,,y,;). The argument kz is the number of rows in the dimension statement for Z in the calling program. It is assumed that m > 2, n > 2, and kz > m.

DDZ is a 3-dimensional array of dimension m x n. x 3 containing the partial derivatives where

```text
DDZ(t, 7,1) = D3 F(z, y;)
DDZ(i,7,2) = D? F(2., y;)
DDZ(i, 3,3) = D? D2 F(z;, 95)
```

for each 1,7. SURF2(9,t,m,n, X,Y, Z,kz,DDZ,o) = F(s,t) for any point (,t).

**Remark.** After DDZ has been obtained, SURF2 may be repeatedly called to evaluate the bispline at different points so long ag the tension factor ¢ remains fixed. However, if o is modified then the derivative information in DDZ will have to be recomputed before SURF2 can be used with the new tension factor.

**Programming.** SURF2 employs the function INTRVE and subroutine SNHCSH. SURF? was written by A. K. Cline and R. J. Renka (University of Texas at Austin).

CALL NSURF2(sinin, Snax) ha, fminy tmax: Me, W, kw, m,n, X,Y, Z,kz, DDZ,WORK, 0)

The arguments 8i,in and Smax are the lower ard upper limits of the x-coordinates of che grid on which F(z, y) is to be evaluated, and the arguments ty), and tmax are the lower and upper limits of the y-coordinates. The purpose of the routine 1s to evaluate the bispline at the points (s,,t,;) where

tee oo . a \ Inax min 8y == Smin + bo Ly) ee

mayo ik

: : linax ~ bin fora i,...,m, and geo 1,...,n¢. It is assumed that m, > land n, > 1.

```text
W is a 2-dimensional array of dimension kw x nz, where kw =: m,. When NSURFZ ts
called W (s,7) is assigned the value F(s,,¢,) fort = 1,...,m, and j= I, -.., ng.
```

O15


<small>Original source: [View scanned PDF page 387](scans/page_0387.png)</small>

The arguments m,n, X,Y, 4, kz, DDZ,o are the same as in SURF2. WORK is an array of dimension 4m, or larger that is used for a work space.

**Programming.** NSURF2 employs the subroutine SNHCSH. NSURF2 was written by A. K. Cline (University of Texas at Austin).

S16


<small>Original source: [View scanned PDF page 388](scans/page_0388.png)</small>

<a id="topic-388-01"></a>
### Bivariate B-Spline Piecewise Polynomial Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [`L102601`](source_parts/nswc_part_10.f90#L7355) |


Form>k>landn> &> 1 let 5) < +++ < 9n4, and ty < ... < tnyy be sequences where 5; < sj44 (= 1, .,m) andt, < tye (J = 1,...,n). Let Bix, ..., Bmx be the B-splines for the knots 91 < +++ < Sm4, and By,...,Bne the B-splines for the knots ty Se) S tage. Given op < 21 < ++ < tm < Sm4i, te < yr < +++ < Yn < tny1, and the values z,; (f= 1,...,m,j7 =1,...,n). Then we wish to find a piecewise polynomial of the form

m nm f{(z,y) = > S44; Bie(2) Byely) s=17=1 which satisfies f(z;,y;) = %j for? = 1,...,m and j = 1,...,n.1\ This problem has a unique solution when s; < 2; < 8;44% and t,; <y; <tj4¢fort=1,...,mandj=1,...,n. The following subroutine is available for obtaining the coefficients a,; of this piecewise polynomial.

```fortran
CALL BSTRP2(X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG)
```

X is an array containing 21, ...,%m, Y an array containing y;,...,Yn, Z the mxn matrix (z;), S an array containing $1, ...,Sm4s, and T an array containing ti, ...,tn+e. It is assumed that kz > m, where kz is the number of rows in the dimension statement for Z in the calling program.

A is a 2-dimensional array of dimension ka *« n where ka > m, and iERR is a variable. When BSTRP2 is called, if no errors are detected then IERR is set to 0 and the desired coefficients a,; are computed and stored in A.

WK is an array of dimension NUM where NUM > mn-+ max{2km, 2én}. WK is a work space for the routine.

**Error Return.** IERR has one of the following values if an input error is detected.

TERR = 1 sp < ty < +++ < Om S Smay Or 8y < ty < Spyu (¢ = 1,...,m) is violated.

IFRR = 2 te S yp << yy < teyn or ty < yy < tyye (9 = 1,...,n) is violated.

IERR = 3 NUM < mn + max{2km, 2né}.

**Remarks.**

(1) One may set A = Z, thereby replacing the data 2; with a,,.

(2) After the coefficients a,,; are obtained, then the subroutine BVAL2 can be used to evaluate or differentiate the piecewise polynomial f(z, y).

**Programming.** BSTRP2 employs the subroutines BSTRP, BSTRP1, BSPVB, BANPFAC, and BANSLYV. BSTRP2 was written by A. H. Morris.

Nam = Om4g1 then by fltan,y) we mean f(tm,,y) and ifyn — ing: then by f(z, y,) we mean f(z, yn~).

a

O17


<small>Original source: [View scanned PDF page 389](scans/page_0389.png)</small>

<a id="topic-389-01"></a>
### Bivariate B-Spline Piecewise Polynomial Least Squares Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [`L102720`](source_parts/nswc_part_10.f90#L7474) |


Form>k>tandn > €>1 let sy < +++ < smyy and ty <+-- < in+e be sequences where s; < 844% (#1 = 1,...,m) and t; < tj4¢ (7 = 1,...,n). Let Big, ..., Bmg be the B-splines for the knots 3; < +++ < 84, and Bye,...,Bye the B-splines for the knots ty S++ S tnye. Given 9, S zy S++ S oy < Smii, te S yr S++ < yy < tngi, and the values zp, (r = 1,...,4, 9 =1,...,v) where yp > max{2,k} and v > max{2,é}. Also let wi,...,W, and Wy, ...,W, be positive weights. Then the following subroutine is available for finding a piecewise polynomial of the form!

™m n

f(z,y) = 3° >> a:; Bie(x) Bye(y)

t=17=1

is

wn!

“ which minimizes 5> wrt .[f (rr, Ye) — zre)?. rlae=1

it

CALL BSLSQ2(X,WX,u,Y,WY,y, Z,kz,S,m,k,T,n, 2, A, ka, WK,NUM,IERR)

X is an array containing z,,...,2,, WX an array containing wy, ..+,Wy, Y an array containing y1,...,ye, WY an array containing W1,...,@,, Z the uw x v matrix (2re), S an array containing 81, ..., m4, and T an array containing ¢,,...,t,4¢. It is assumed that kz > p, where kz is the number of rows in the dimension statement for Z in the calling program.

A is a 2-dimensional array of dimension ka x n where ka > m. When BSLSQ? is called, if no input errors are detected then the coefficients a,; cf a weighted least squares piecewise polynomial approximation f(z, y) are computed and stored in A.

WK is an array of dimension NUM where NUM > mv +max{(k + Im, (€+ 1)n}. WK is a work space for the routine.

IERR is a variable that reports the status of the results. When BSLSQ2 terminates, HERR has one of the following values:

IERR = 0 The coefficients were obtained. The least squares approximation is unique.

IERR =: 1 The coefficients for a least squares approximation were obtained. The approximation is not, unique.

IERR = - 1 (Input error) Either s, <2, < ++) < p< Sm41 Or p> max{2,k} is violated.

TERR s- 2 Input error) Wither tg < yp < +++ < yy < tag ore > max {2, @} is violated

[ERR =~ 3 Input error) NUM is too small. ‘The minimum permissible value

Wry Saya then by f(ry,y) we mean flty yy) and ifvy - taaa then by f(z,y,) we mean f(aue).


<small>Original source: [View scanned PDF page 390](scans/page_0390.png)</small>

for NUM, namely rv + max{(k-+ 1)m,(@+ Ln}, has been stored in WK(i). Reset NUM > WK(1).

**Remark.** After the coefficients a,; are obtained, then the subroutine BVAL2 can be used to evaluate or differentiate the piecewise polynomial f(z, y).

**Programming.** BSLSQ2 employs the routines BSLSQ1, BSPVB, BCHFAC, and BCHSV1, BSLSQ2 was written by A. H. Morris.


<small>Original source: [View scanned PDF page 391](scans/page_0391.png)</small>

<a id="topic-391-01"></a>
### Evaluation And Differentiation Of Bivariate Piecewise Polynomials From Their B-Spline Representations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [`L103021`](source_parts/nswc_part_10.f90#L7775) |


Form>k>landn>é> 1 let 3, <--- < mye and ty < +++ < tyy, be sequences where s; < sy44 (¢ = 1,...,m) and t; < tye (7 = 1,...,n). Let Biz, ..., Bmg be the B-splines for the knots sy < +++ < smsy and By, ..., Bye the B-splines for the knots

ty Sees Stage. If ™ n

f(z,y) = D7 >) a5 Bex (x) Bye(y)

t=) 7-1 then the following subroutine is available for computing f(z,y) and its partial derivatives. CALL BVAL2(A,ka,S,m,k,T,n,é,2,y, u,v, ,WK)

A is the m x n matrix (a,;), S an array containing s1, -«+y)Sm+4k, and T an array containing ty, ...,tn4¢. It is assumed that ka > m, where ka is the number of rows in the dimension statement for A in the calling program.

The arguments y and v are nonnegative integers, (z,y) is the point at which f or its partial derivative 04+” f/d4rd"”y is to be evaluated, and w is a variable. When BVAL2 is called, then w is assigned the value a, BY (2) BY (y). Here Bi) denotes B,, if p= 0 and the yu‘? derivative of By, if u > 1. Ife # smax then by BY) (x) we mean the right limit BY (x4 ), and if z = 6,4,% then by BY (x) we mean the left limit BY (z-), Similar

comments hold for BY (y).

WK is an array of dimension @+ max{3k,3é} or larger that is a work space for the routine.

**Programming.** BVAL2 employs the function INTRVL and subroutine BVAL. BVAL2 was written by A. H. Morris.


<a id="category-392"></a>
## Surface Fitting over Arbitrarily Positioned Data Points

<small>Original source: [View scanned PDF page 392](scans/page_0392.png)</small>

<a id="topic-392-01"></a>
### Surface Interpolation For Arbitrarily Positioned Data Points

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [`L103094`](source_parts/nswc_part_10.f90#L7848) |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [`L104598`](source_parts/nswc_part_10.f90#L9352) |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [`L104865`](source_parts/nswc_part_10.f90#L9619) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [`L105496`](source_parts/nswc_part_10.f90#L10250) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [`L105530`](source_parts/nswc_part_10.f90#L10284) |


```text
Let { (a1, 4): = 1,...,n} be aset of n > 3 distinct pe‘nts which are not collinear and
21, ...,2, a sequence of values. Then the problem is to find a smooth mapping z = F(z, y)
for which 2; = F(x, ys) fort =1,...,n.
```

A triangle based procedure for constructing a smooth interpolating mapping z = F(z,y) contains the following components:

(1) An algorithm for forming a triangular grid for the convex hull of the data points (z;, y;) and a procedure for locating any point in the grid. If extrapolation is to be permitted, then the region outside the grid must also be partitioned and a procedure provided for locating any point in the region.

(2) A procedure for estimating the first (and possibly higher order) partial derivatives of

F (x,y) at the data points (2,, yx).

A smooth interpolating routine for computing F(z,y) on each triangular cell of the

grid. If extrapolation is to be permitted, then a routine must also be provided for

computing F(z, y) on each cell of the partitioned region outside of the grid.

(3

~~

With regard to (2), it should be noted that no derivative estimation procedure is known that is appropriate for all applications. This is unfortunate, since the derivative values can significantly affect the results obtained from any interpolating procedure.

The subroutine TRMESH 1s available for obtaining a triangular grid, and the subroutines GRADG and GRADL are available for derivative estimation (performed in two different manners). After the grid has been obtained and the derivatives estimated, then the subroutines SFVAL, and SFVAL2 are available for computing a continuously differentiable mapping z = F(z,y) for which z, = F(2;,y:) for? = 1,...,n. Extrapolation is permitted.

```fortran
CALL TRMESH(N, X, Y, IADJ, IEND, IER)
```

X is an array containing 71, ...,2, and Y an array containing y,,...,yu. IADJ is ar array of dimension 6n or larger, END an array of dimension n, and IE RR a variable. When TRMESH is called, if no input errors are detected then HeRER is set to 0 and a Thiessen triangulation of the convex hull is obtained. The triangulation is stored in [ADJ and HOND.

**Error Return.** JERR Lif < Sand TERR © 2 if the data points (2,, yy} are collinear.

**Remark.** For efficiency, it is recommended that the data points (2,,y,) be ordered so that Programming. TRMESH employs the routines ADNODE, BDYADD, INTADD, SHIETD, SWAPD, PREFIND and functions SWPTS'T and ‘FINDA. These routines were written by

Robert J. Renka (University of North ‘Texas, Denton, Texas).


<small>Original source: [View scanned PDF page 393](scans/page_0393.png)</small>

**References.**

(1) Cline, A. K. and Renka, R. J., “A Storage-Efficient Method for Construction of a Thiessen Triangulation,” Rocky Mountain J. Math 14 (1984), pp. 119-139.

(2) Renka, R. J., “Algorithm 624. ‘Triangulation and Interpolation of Arbitrarily Distributed Points in the Plane,” ACM Trans. Math Software 10 (1984), pp. 440-442.

```fortran
CALL GRADG(N, X, Y, Z, IADJ, IEND, ZXZY, IERR)
CALL GRADL(N, X, Y, Z, IADJ, IEND, ZXZY, IERR)
```

X is an array containing 21, ...,2,,Y an array containing y,,...,¥,, and Z an array containing zy, ...,2,. TADJ is an array of dimension 6n or larger, and TEND an array of dimension n. [ADJ and JEND contain the grid information given by the routine TRMESH.

DZ is a 2-dimensional array of dimension 2 x n. When GRADG or GRADL. is called, if the partial derivatives of F'(z,y) are computed at the data points then the derivatives Di F(21,y1),.--, Di F (an, %n) are stored in the first row of DZ and the derivatives DeF(x:,y1), .-., DoF (2n, Yn) in the second row of DZ.

**Error Return.** [ERR is a variable that reports the status of the results. When the subroutine terminates IN RR has one of the following values: IERR «= O The partial derivatives of * were evaluated and stored in DZ. IFRR = 1 (Input Error) n < 3. IER = 2 The partial derivatives could not be estimated by GRADL. Either the data points are almost collinear, or the abscissas and ordinates of the data points are too poorly scaled for the derivatives to be computed (see remark (2) below). Algorithm. GRADG employs the global derivative estimation procedure aud GRADL the local derivative estimation procedure given in reference (1).

**Remarks.**

(1) GRADG is faster than GRADL, but it frequently is less accurate.

(2) The local derivative estimation procedure can be quite sensitive to the scaling of the abscissas 7, and ordinates 4, of the data points. Frequently, rescaling the abscissas and ordinates will have no effect on the accuracy ef the results obtained by GRADG, but It may increase or decrease the accuracy of the results obtained by GRADL by several decimal digits (or make i impossible to estimate the derivatives locally).

**Programming.** GRADG and GRADL are interface routines for the subroutines GRADGI

and GRADGL, written by Robert J. Renka (University of North Texas, Denton, Texas).

GRADE calls the subroutines GETNP, SHTRM, SRO, and SROVG.

**References.**

(t) Renka, RJ, and Cline, AJK., SA Triangle Based OC! Interpolation Method,” Rocky Mountain J. Math 14 (i984), pp. 225 237.

(2) Renka, Ro J., “Algorithm 624. ‘Triangulation and Interpolation of Arbitrarily Distributed Points in the Plane,” ACM Trans. Math Software 10 (1984), pp. 440 442.


<small>Original source: [View scanned PDF page 394](scans/page_0394.png)</small>

```fortran
CALL SFVAL(N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR)
```

X is an array containing 7,,...,2,,Y an array containing y,,...,yYn,, and Z an array containing z1,...,2,. TADJ is an array of dimension 6n or larger, IEND an array of dimension n, and DY an array of dimension 2 x n. It is assumed that IADJ and IEND contain the triangulation given by the subroutine TRMESH, and that DZ contains the partial derivatives computed by GRADG or GRADL.

It is assumed that F(z, y) is to be evaluated at (21,91), ..-,(2m,%m). XJ is an array containing 2), ...,Zm, YJ an array containing 91, ...,§m, and Z/ an array of dimension m or larger. IERR is a variable. When SF VAL is called, if no errors are detected then IERR is set to 0. Also F(Z,, %) is computed and stored in Z/(t) fori = 1,...,m.

```text
Error Return. IERR = 1 ifn < 3 or m < 1, and JERR = 2 if the data points (z,, y;)
(¢ = 1, ...,n) are collinear.
```

**Programming.** SFVAL is a driver for the subroutine INTRC1. INTRC1 employs the subroutines GRADLI, GETNP, SETRM, SROT, ROTG, TRFIND, and TVAL. INTRC1 was written by Robert J. Renka (University of North Texas, Denton, Texas).

**References.**

(1) Renka, R. J., and Cline, A. K., “A Triangle Based C? Interpolation Method,” Rocky Mountain J. Math 14 (1984), pp. 223-237.

(2) Renka, R. J., “Algorithm 624. Triangulation and Interpolation of Arbitrarily Distributed Points in the Plane,” ACM Trans, Math Software 10 (1984), pp. 440-442.

```fortran
CALL SFVAL2(N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR)
```

X ig an array containing 71, ...,7,,Y an array containing yi, .--,Y,, and 4 an array containing z,,...,2,- TADJ is an array of dimension @n or larger, TEND an array of dimension n, and DZ an array of dimension 2 « n. It is assumed that [ADJ and TEND contain the triangulation given by the subroutine TRMESH, and that DZ contains the partial derivatives computed by GRADG or GRADL.

It is assumed that F(x, y) is to be evaluated at (z,,y,) fort 1, ...,fand jg 1, vt XJ] is an array containing 71,...,%¢, Y/ an array containing yi,.--,ym, and af a. dimensional array of dimension Az x m where kz > @ HERR os a variable. When SFVA: 2 is called, if no errors are detected then TERR is set to 0. Also F(a,,y)) is computed and stored in Z/(i,7) ford 1, ...,@ andy 4, ...,m.

Error Return. TERR obifme 8,8. Lome torkz + @and PERK | 2afthe data points (ri,us) (§ £2...) are collinear.

**Programming.** SFVAL2 is a driver for the subroutine INTRC1. INPRCI employs the subroutines GRADLI, GHENP, SETRM, SROT, SROTG, PREIND, and TWAL. INTRC1 was written by Robert J. Renka (University of North Texas, Denton, Texas)

aye O2D


<a id="category-395"></a>
## Manifold Fitting

<small>Original source: [View scanned PDF page 395](scans/page_0395.png)</small>

<a id="topic-395-01"></a>
### Weighted Least Squares Fitting With Polynomials Of N Variables

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `MFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [`L106168`](source_parts/nswc_part_11.f90#L292) |
| `MEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [`L107174`](source_parts/nswc_part_11.f90#L1298) |
| `DMFIT` | `SUBROUTINE` | `DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD` | [`L107444`](source_parts/nswc_part_11.f90#L1568) |
| `DMEVAL` | `SUBROUTINE` | `DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP` | [`L107992`](source_parts/nswc_part_11.f90#L2116) |


Let {(2.°, at) faced, ... 46} be a set of f distinct points, z1,...,z¢ be the corresponding function values to be approximated, and w ,...,w, be positive weights. Then for any nonnegative integer IDEG where ("*!P®G) < @! the subroutines MFIT and DMFIT are available for obtaining the coefficients of the unique polynomial F(z, ...,2n)

of degree IDEG which minimizes }> w,{F(z),...,2,°) - z,|*. Also, the subroutines

teal MEVAL and DMEVAL are available for computing this polynomial. MFIT and MEVAL yield single precision results, and DMFIT and DMEVAL yield double precision results.

```fortran
CALL MFIT(DIMEN, FITDEG, NFPOLS, NFPTS, FITCDS, NCROWS, FITVLS, WTS, RESIDS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, IREQD, DREQD)
```

MIWK MWK) CALL DMFIT(n, IDG, 1m, @, X,keo, ZW, R, TER TWK,WhH,LIWK,LWK, MIWK MWK)

It is assumed that n > land €> 1. X is an @ xn matrix whose ¢4* row contains the point (2, ae vr")). i.e., X(4,7) ') forts o,...,@and 7 -1,...,m. 'The argument kx is the number of rows in the dimension statement for X in the calling program. Z is an array containing zy, ...,2, and W an array containing w;,...,tw,¢. X and 4 are modified

by the routine.

**Remark.** For IDEG © 0, ("'YPES) polynomials Lay, ...,7n,22,4122, ..- are needed for a basis of the space of polynomials of degree ~ TDG. The basis polynomials are ordered. For ko 1, the degree kL basis polynomials precede the degree A polynomials. ‘The degree k basis polynomials are xy, -+- 4, where Bs ay see) 6 ay som. Kor any two such polynomials 7,,--04,, andor, 7-4), let r be the smallest integer such that a, 4 7,. Then Hy, cca, precedes 2, -++2,, whens, © 9.

IDEG and om are variables. Tf EDC) + OG then the routine attempts to obtain the polynomial P(2zy, ....2,,) of degree (DEG which is the best least squares fit. Otherwise, if IDRG . O then it is assumed that - band that the first mi basis polynomials are to be used to obtain the least squares fit. When the routine terminates, EDNG the degree of the polynomial MQ, 002,27.) obtained andi the number of basis polynomials that are

actually used.

. : ; , \ (s) (ly o¢ , As an array of dimension for larger. Ava) fy Rory ry) fora l, é

when the routine terminates

IWR ois an array of dimension BEY aod WA ai array of dimension LWA) When the routine terminates, PWR and Whocoutar the information needed for computing the polynomial M(2,, 0-4, ) Sufficient store for DW and Who can be assured by setting LIWK and LWRoas follows HP db Gothen tet titel f ("" ua “yt and é Hoke:


<small>Original source: [View scanned PDF page 396](scans/page_0396.png)</small>

Otherwise, if IDEG < 0 then let N = m and 6 be the smallest nonnegative integer such that ("*°) > m. Then set

LIWK > 4N + 6n LWK > 2N+¢n+14+@N + S(N ~ 1)(N - 2).

N is the maximum number of basis polynomials that will be used, and 6 is the degree of the polynomial F(z), ...,2,) if N basis polynomials are used.

MIWK and MWK are variables. MIWK is set by the routine to the dimension needed for IWK, and MWK is set to the dimension needed for WK. MIWK and MWK depend only on n, €,IDEG, and m.

If MFIT is called then X,Z,W, R, and WK are single precision real arrays. Otherwise, if DMFIT is called then X,Z,W,R, and WK are double precision arrays.

IER is a variable that reports the status of the results. When the routine terminates, JER has one of the following values: IER = 0 The desired polynomial was obtained. IER = ~1 Not all the basis polynomials could be used. IDEG is the degree of the polynomial obtained. This setting occurs when the problem ig not solvable or is too ill-conditioned for the requested degree.

IER = 1 Only @ basis polynomials were used. A polynomial (21, ...,2n) was obtained which solves the equations F(z" ; at )= x fors --1,...,8.

IER == 2 (Input error) IDEG < 0 and m < 0.

IER 3 (input error) n < Lor @< 1.

IWR = 4 (Input error) LIWK or LWK is too small. Set LIWK > MIWK and LWK > MWK.

When an input error is detected, the routine immediately terminates.

**Remark.** When IER © 1 then MEVAL or DMEVAL may be used to compute the polynomial obtained.

**Algorithm.** ‘The revised Gram-Schmidt orthogonalization procedure is used,

**Programming.** MEFUP employs the routines ALLOT, BASIZ, MPABLE, GNRTP, INGCIDG | SCALPM,SCALDN,and OME? employs the routines ALLOT,BASIZ MTA BLE,DGONR'EP, DINCDG, DSCALP, DSCALD. MEVP and DMETP are modifications by Al HE. Morris of CONSTR, written by Richard HW. Bartels (University of Waterloo) and John J. Jezioranski (Ontario Cancer Institute)

**References.** (1) Bartels, Rodb aud Jeviorauski, JoJo) “Least Squares Fitting using Orthogonal Multinomials,” ACA Trans Math Software EL (LO85), pp BOL LET, (2) ,Algorithm 034, CONS'PR and EVAL Routines for Fitting Multitorabs

Moa Least Squares Sense,” ACM Trans. Math Software LE CLSSs), pp. 2ES 22S


<small>Original source: [View scanned PDF page 397](scans/page_0397.png)</small>

```fortran
CALL MEVAL(DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP)
CALL DMEVAL(DIMEN, EVLDEG, NEPOLS, NEPTS, EVLCDS, NEROWS, EVLVLS, ERROR, FITIWK, FITDWK, FIWKLN, FDWKLN, TEMP)
```

MEVAL (DMEVAL) computes the polynomial obtained by MFIT (DMFIT), or a portion thereof. Let IDEG and m be the output values given by MFIT (DMFIT).

The argument 77 is a variable. If KDEG < 0 then it is assumed that 1 < m < m and that the polynomial using the first #7i basis polynomials is to be computed. In this case, the polynomial computed is the best least squares fit for the basis polynomials involved.

If KDEG > 0 then it is assumed that KDEG < IDEG. In this case, when the routine terminates, 7m = the number of basis polynomials used. If m < m (which will be the case when KDEG < IDEG), then the polynomial computed is the polynomial of degree KDEG which 13 the best least squares fit.

Usage. If IER = +1 when MFIT(DMFIT) terminates, then the setting KDEG = IDEG normally causes an error to occur since 7m > m. Hence, if it is desired that the full polynomial obtained by MFIT(DMFIT) be computed, no matter whether the value for IER is O or +1, then KDEG should be assigned a negative value and fi = m.

It is assumed that the polynomial is to be computed at the points (#{, Et?) fort = 1,...,@ Xlig an @x n matrix whose t** row contains the point (z,, .. Ee), The argument zt is the number of rows in the dimension statement for XI in the calling program. ZI is an array of dimension @ or larger. When the routine terminates, ZI(s) contains the value of the polynomial at the point (z,, _ ,z,() fori =1,...,6.

IWK and WK are the arrays obtained from MFIT or DMFIT. LIWK is the dimension of IWK and LWK the dimension of WK. T is an array of dimension n or larger that is a work space for the routine.

If MEVAL is called then XI, ZI, WK and T are single precision arrays. Otherwise, if DMEVAL is called then XI, ZI, WK and 7 are double precision arrays.

```text
IND is a variable that reports the status of the results. When the routine terminates,
IND has one of the following values:
```

IND -- © The desired computation was performed.

IND = ~1 (Input error) 7i < lor wi > m.

IND — ~2 (Input error) n < bor @< 1.

**Programming.** MEVAL calls the subroutine MEVALI and DMEVAL calls the subroutine DMEVLI. MEVAL and DMEVAL are modifications by A. H. Morris of EVAL, written by Richard H. Bartels (University of Waterloo) and John J. Jezioranski (Ontario Cancer Institute).

H29


<a id="category-398"></a>
## Numerical Integration

<small>Original source: [View scanned PDF page 398](scans/page_0398.png)</small>

<a id="topic-398-01"></a>
### Evaluation Of Integrals Over Finite Intervals

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [`L108263`](source_parts/nswc_part_11.f90#L2387) |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L108613`](source_parts/nswc_part_11.f90#L2737) |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [`L110602`](source_parts/nswc_part_11.f90#L4726) |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L111637`](source_parts/nswc_part_11.f90#L5761) |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [`L113654`](source_parts/nswc_part_11.f90#L7778) |


QAGS, QXGS, QSUBA, DQAGS, and DQXGS are available for computing integrals L F(x) dz over finite intervals. The subroutines QAGS and QXGS and the function QOQUBA yield single precision results. These procedures are adaptive. In such procedures, the selection of the points at which the integrand is evaluated depends on the nature of the integrand. DQAGS and DQXGS are double precision versions of the subroutines QAGS and QXGS.

QSUBA is applicable only when F and its derivatives have no singularities in the closed interval [a,b]. Otherwise, QAGS or QXGS should be used. These subroutines are appropriate when F(z) is continuous except possibly for a finite number of singularities. QAGS and QXGS generally yield accurate results when any singularities which exist are ‘ocated at the endpoints of the interval [a, b|. However, if F has an exceedingly narrow spike which contributes significantly to the value of the integral, then the subroutines may overlook the spike and produce incorrect results. QAGS and QXGS normally have approximately the same accuracy. QAGS uses less storage than QXGS, but it frequently requires considerably more function evaluations than QXGS. Consequently, QXGS is recommended when the integrand F(z) is expensive to compute.

```fortran
CALL QAGS(F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK)
```

F(a) is a user defined function whose arguments and values are assumed to be real numbers. The purpose of QAGS is to compute the integral i F(x) dz. F need not be defined at a and 6, and it is not required that a < 6b. F must be declared in the calling program to be of type EXTERNAL.

AERR and RERR. are the absolute and relative error tolerances to be used, and z is a variable. When QAGS is called, z is assigned the value obtained for J = fp F(z)dz. The subroutine attempts to obtain a value z which satisfies [J — z| < max{AERR, RERR.- [/]}. it is assumed that AERR > 0 and RERR > 0. If one wants accuracy to k significant digits then set NERR = 107%. If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR and NUM are variables. When QAGS terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an array of dimension #@ and WK an array of dimension m. IWK and WK are work spaces for the routine. The input argument # is the maximum number of subintervals in which the interval of integration may be partition:d. It is assumed that @ > land m > 4€. The argument nis a variable. When QACS terminated, n =: the number of subintervals that appeared in the partition. Normally n < 100.

HERR is a variable that reports the status of the results. When the routine terminates, HERR has one of the following values:

IERR = O The routine s satisfied that the integral has been computed to the desired accuracy.


<small>Original source: [View scanned PDF page 399](scans/page_0399.png)</small>

[ERR =: f The interval of integration was partitioned into & subintervals. 5 I More subintervals are needed to compute the integral to the desired accuracy.

a

HERR = 2 The integral has been computed, but because of roundoff error

QAGS is not certain of the accuracy of the result. The error may

be greater than that reported by BRROR.,

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

TERR = 4 The algorithm does not converge. If, is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

TERR = 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR == 6 (Input Error) Hither 2 < 1, m < 4@, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to 0.

**Remark.** NUM < 42(€-- 1) + 21 Algorithm. The 21 point Kronrod rule and ¢-algorithm of P. Wynn are used.

**Programming.** QAGS employs the subroutines QAGSE, QK21F, QPSRT, and QELG. These routines were developed by Robert Piessens and Elise de Doncker-Kapenga (Katholiek Universiteit Leuven, Belgium), and modified by A. H. Morris and Los Alamos National Laboratory. The function SPMPAR is also used.

**Reference.** Piessens, R., de Doncker-Kapenga, E., Uberhuber, C. W., and Kahaner, D. K., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.

```fortran
CALL QXGS(F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK)
```

F is a user defined function whose arguments and values are assumed to be real numbers, The purpose of QXGS is to compute the integral fp F(x) dz. F must be defined at a and 6, but it is not required that a < 6. F must be declared in the calling program to be of type EXTERNAL.

AFRR and RERR are the absolute and relative error tolerances to be used, and z is a variable. When QXGS is called, z is assigned the value obtained for J = fr F(z2)dz. The subroutine attempts to obtain a value z which satisfies [J ~ z| < max{AERR, RERR- |/|}. It is assumed that AIERR > 0 and RERR > 0. If one wants accuracy to k significant digits then set RERR = 10° *. If RERR = 0 then if, is ass. ned that machine accuracy is desired.

ERROR is a variable. When QXGS terminates, ERROR is the estimated absolute error of z.

IWK is an array of dimension j and WK an array of dimension m. [WK and WK are work spaces for the routine. The input argument @ is the maximum number of subintervals


<small>Original source: [View scanned PDF page 400](scans/page_0400.png)</small>

in which the interval of integration may be partitioned. It is assumed that £ > 1, ys > 32, and m > 462. The argument n is a variable. When QXGS terminates, n = the number of subintervals that appeared in the partition. Normally n < 100.

TERR is a variable that reports the status of the results. When the routine terminates, TERR he: one of the following es;

TERR = 0 The routine; ied that the integral has been computed to the desired accu: «.

IERR. = 1 The interval 1 2gration was partitioned into & subintervals. More subinte ¥i.: ‘re needed to compute the integral to the de-

sired accurac ;.

TERR = 2 The integral hus en computed, but because of roundoff error QXGS is not cer i of the accuracy of the result. The error may be greater thar : 4 reported by ERROR.

IERR = 3 Extremely bad in grand behavior occurs in the interval of inte-

gration. The + 2 is not certain of the accuracy obtained. TERR = 4 The algorithm: aot converge. It is assumed that the requested accuracy can! achieved and that the result is the best which

can be obtain

{ERR = 5 The integral ma,’ be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR = 6 (Input Error). Either 2 < 1, p < 38, m < 462, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, and n are set to 0.

**Remarks.**

```text
(1) If F is unbounded at a or b, then set F(a) or F(5) to a dummy value, say 9.
(2) The first 4@ locations of WK serve the same purpose for QXGS as for QAGS. Fiinctiona!
values are stored in the remaining 422 locations of WK.
```

**Algorithm.** The recursive monotone quadrature formulas of P. Favati, G. Lotti, and F. Romani, and the e-algorithm of P. Wynn are used.

**Programming.** QXGS employs the subroutines QXGSE, QXCPY, QKLQM, QXRUL, QXRRD, QPSRT, and QELG. QXGS js an adaptation of QAGS where the Gauss~Kronrod formulae have been replaced with the recursive monotone formulae. QXGS wag designed by Paola Favati (Instituio di Elaborazione dell’ Informazione, CNR, Pisa), Grazia Lotti, and Francesco Romani (Universita di Pisa, Italy), and modified by A. U. Morris. The function SPMPAR is also used.

**Reference.** Favati, P., Lotti, G., and Romani, F., “Algorithm 691. Improving QUADPACK Automatic Integration Routines,” ACM Trans. Math Software 17 (1991), pp. 218-282 QSUBA(F, a,b, RERR,MCOUNT, ERROR, IERR) F(z) is a user defined function whose arguments and values are assumed to be real


<small>Original source: [View scanned PDF page 401](scans/page_0401.png)</small>

numbers. The purpose of QSUBA is to compute the integral i F(x) dz. F need not be defined at the points a and 6. However, it is assumed that a < 6. F must be declared in the calling program to be of type EXTERNAL.

RER is the relative error tolerance to be satisfied. lt is assumed that RERR > O. If ~e wants accuracy to k significant digits then set RLRR = 107*.

The input argument MCOUNT is the maximum: number of points at which # may be evaluated. It is recommended that MCOUNT > 1000.

ERROR is a variable that is set by QSUBA. If the value of QSUBA is not 0 then ERROR is an estimate of the relative error of the computed result. Otherwise, if the value of OSUBA is 0 then ERROR is an estimate of the absolute error.

IERR is a variable that reports the status of the results. When QSUBA terminates, TERR has one of the following values: IERR = 0 The function QSUBA is satisfied that the integral has been computed to the desired accuracy. JERR = 1 The integral has been computed, but QSUBA is not certain of the accuracy of the result. {ERR = 2 F(x) was evaluated at MCOUNT points. More evaluations are needed to complete the computation of the integral. IERR = 3 The function QSUBA cannot compute the integral te the desired accuracy. If IER =: 0 or 1 then the function QSUBA is assigned the value obtained for the integral. If TERR = 2 then QSUBA has for its value the most recent acceptable partial estimate made

the value of the integral that it can make.

**Remark.** QSUBA assumes that F and its derivatives have no singularities in the closed interval la, 6}. If this is not the case then QAGS or QXGS should be used.

**Algorithm.** Gaussian quadrature is employed.

**Programming.** QSUBA calls the subroutine QUAD. QSUBA and QUAD were written by T. N. L. Patterson (Queen’s University, Belfast, Northern Ireland}, and QSUBA was modified by A. dl. Morris. The function SPMPAR is used.

**Reference.** Patterson, T. N. L.,“Algorithm: for Automatic Numerical Integration Over a Finite Interval,” Comm. ACM 16 (1973), pp. 694-€99, CALL DQAGS(?, a,b, APRR,RERR,z, ERROR,NUM,IERR, 8, 1, nIWK,WK)

F(z) is a user defined function whose arguments and values are assumed to be double precision numbers. The purpose of DQAGS is to compute the integral f, F(r)dr. The arguments @ and 6 are double precision numbers. # need not be defined at a and 6, and


<small>Original source: [View scanned PDF page 402](scans/page_0402.png)</small>

it is not required that a < t. F must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL.

AERR and RERR are double precision numbers and z a double precision variable. AERR and RERR are the absolute and relative error tolerances to be used. When DQAGS is called, z is assigned the value obtained for J = sf F(x) dz. The subroutine attempts to obtain a value z which satisfies |J — z| < max{AERR, RERR- |/|}. It is assumed that AERR > 0 and RERR > O. If one wants accuracy to k significant digits then set RERR = i0-*, If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR is a double precision variable and NUM an integer variable. When DQAGS terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an integer array of dimension @ and WK a double precision array of dimension m. IWK and WK are work spaces for the routine. The argument @ is the maximum number of subintervals in which the interval of integration may be partitioned. It is assumed that €> land m > 4é@. the argument n is a variable. When DQAGS terminates, n = the number of subintervals that appeared in the partition. Normally n < 100.

```text
IERR is a variable that reports the status of the results. When the routine terminates,
IERR has one of the following values:
```

IERR = 0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

IERR = 2 The integral has been computed, but because of roundoff error DQAGS is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

TERR = 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

IERR := 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR = 6 (Input Error) Either 2< 1, m < 4@, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to 0.

**Remark.** NUM < 42(@-- 1) 4 21.

**Algorithm.** The 2! point Kronrod rule and e-algorithm of P. Wynn are used. Programming. DQAGS employs the routines DQAGSE, DQK21, DQPSR, and DQELG. These subroutines are double precision versions by A. H. Morris of the routines QAGSE,

QKR2UF, QPSRT, and QHLG. The function DPMPAR is also used.


<small>Original source: [View scanned PDF page 403](scans/page_0403.png)</small>

**Reference.** Piessens, R., de Doncker-Kapenga, &., Uberhuber, C. W., and Kahaner, D. K., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.

```fortran
CALL DQXGS(F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK)
```

F is a user defined function whose arguments and values are assumed to be double precision numbers. The purpose of DQXGS is to compute the integral fp F(x)dz. The arguments a and 6 are double precision numbers. F must be defined at a and 6, but it is not required that a < b. F must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL.

AERR and RERR are double precision numbers and z a double precision variable. AERR and RERR are the absolute and relative error tolerances to be used. When DQXGS is called, z is assigned the value obtained for J = fp F(z)dz. The subroutine attempts to obtain a value z which satisfies {J — z| < max{AERR, RERR- |/|}. It is assumed that AERR > 0 and RERR > 0. If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR is a double precision variable. When DXQGS terminates, ERROR is the estimated absolute error cf z.

IWK is an integer array of dimension » and WK a double precision array of dimension m. IWK and WK are work spaces for the routine. The argument @ is the maximum number of subintervals in which the interval of integration may ke partitioned. It is assumed that €> 1, > 3é, and m > 46é. The argument n is a variable. When DQXGS terminates, n = the number of subintervals that appeared in the partition. Normally n < 100.

```text
IERR is a variable that reports the status of the results. When the routine terminates,
IERR has one of the following values:
```

IERR = 0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

IRR = 2 The integral has been computed, but because of roundoff error DQXGS is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad int2grand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

IERR <= 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

IERR -. 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR~ 6 (Input Error). Hither @ < 1, < 30, m < 46£ AERR < OQ, or RERR < 6. In this case, the variables z, ERROR, and n are set to 0.


<small>Original source: [View scanned PDF page 404](scans/page_0404.png)</small>

**Remarks.**

(1) If F is unbounded at a or 6, then set F(a) or #(b) to a dummy value, say 0.

(2) The first 4@ locations of WK serve the same purpose for DQXGS as for DQAGS. Functional values are stored in the remaining 422 locations of WK.

**Algorithm.** The recursive monotone quadrature formulas of P. Favati, G. Lotti, and F. Romani, and the e-algorithm of P. Wynn are used.

**Programming.** DQXGS employs the routines DQXGSE, DQXCPY, DQXLQM, DQXRUL, DQXRRD, DQPSRT, and DQELG. DQXGS is an adaptation of DQAGS where the Gauss— Kronrod formulae have been replaced with the recursive monotone formulae. DQXGS was designed by Paola Favati (Instituto di Elaborazione dell’Informazione, CNR, Pisa), Grazia Lotti, and Francesco Romani (Universita di Pisa, Italy) and modified by A. H. Morris. The function DPMPAR is also used.

**Reference.** Favati, P., Lotti, G., and Romani, F., “Algorithm 691. Improving QUADPACK Automatic Integration Routines,” ACM Trans. Math Software 17 (1991), pp. 218-232.


<small>Original source: [View scanned PDF page 405](scans/page_0405.png)</small>

<a id="topic-405-01"></a>
### Evaluation of Integrals over Infinite Intervals

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L109433`](source_parts/nswc_part_11.f90#L3557) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L112471`](source_parts/nswc_part_11.f90#L6595) |


The subroutines QAGI and DQAGI are available for computing integrals over infinite intervals. QAGI yields single precision results and DQAGI yields double precision results. QAGI and DQAGI are adaptive routines.

```fortran
CALL QAGI(F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK)
```

F(x) is a user defined function whose arguments and values are assumed to be real numbers. The argument a is a real number, z is a variable, and MO may be 1, —1, or 2. When QAGI is called, z is assigned the value f° F(x) dz if MO = 1 and the value f°. F(z) dz if MO = -1. Otherwise, if MO = 2 then z is assigned the value [| F(x) dz. If MO = +1 then F need not be defined at a. Otherwise, if MO = 2 then a is not used. F must be declared in the calling program to be of type EXTERNAL.

AERR and RERR are the absolute and relative error tolerances to be used. The subroutine attempts to obtain a value z which satisfies | [ F(z) dz—z| < max{AERR,RERR: | f F(z)dz|}. It is assumed that AERR > 0 and RERR > 0. If one wants accuracy to k significant digits then set RERR = 10~*. If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR and NUM are variables. When QAGI terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an array of dimension £ and WK is an array of dimension m. IWK and WK are work spaces for the routine. The input argument @ is the maximum number of subintervals in which the interval of integration may be partitioned. It is assumed that @> 1 and m > 4@. The argument n is a variable. When QAGI terminates, n == the number of subintervals that appeared in the partition. Normally n < 100.

IERK is a variable that reports the status of the results. When the routine terminates, TERR has one of the following values:

IERR =0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

IERR = 2 The integral has been computed, but because of roundoff error QAGI is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

IERR == 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which

|

can be obtained. IERR = 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.


<small>Original source: [View scanned PDF page 406](scans/page_0406.png)</small>

TERR = 6 (Input Error, Either €< 1, m < 42, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to 0.

**Note.** F may have a singularity at a when MO = +1. However, it is recommended that no singularities appear in the interior of the interval of integration.

**Algorithm.** The integrals are transformed 4s follows:

ek

re dt J Fe) de = | F(a-14+1/t)5 a 9

[ F(2) dz = [ Fla+1— 1)

f P(2)dz = fire +1/t) +P -1/))S

The transformed integrals are computed by the 15 point Kronrod rule and the e-algorithm of P. Wynn.

**Programming.** QAGI employs the subroutines QAGIE, QK15I, QPSRT, and QELG. These routines were developed by Robert Piessens and Elise de Doncker-Kapenga (Katholieke Universiteit Leuven, lieverlee, Belgium), and modified by A. H. Morris and Los Alamos National Laboratory. The function SPMPAR is also used.

**Reference.** Piessens, R., de Doncker-Kapenga, E., Uberhuber, C. W., and Kahaner, D. K.., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.

```fortran
CALL DQAGI(F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK)
```

F(x) is a user defined function whose arguments and values are assumed to be double precision numbers. The argument @ is a double precision number, z is a double precision variable, and MO may be 1, --1, or 2. When DQAGI is called, z is assigned the value f<° F(z) dz if MO = 1 and the value f°. #(z)dz if MO = —1. Otherwise, if MO = 2 then z is assigned the value ine F(x) dx. If MO = +1 then F need not be defined at a. Otherwise, if MO = 2 then a is not used. F must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL.

AERR and RERR are the absolute and relative error tolerances to be used. The subroutine attempts to obtain a value z which satisfies | [ F(z) dz - z| < mar{AERR,RERR- | f F(z) dz|}. %t is assumed that AFRR and RERR are nonnegative double precision numbers. If one wants accuracy to k significant digits then set RERR = 10°*. If RERR - 0 then it is assumed that machine accuracy is desired.

ERROR is a double precision variable and NUM an integer variable. When DQAGI] terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an integer array of dimension @ and WK a double precision array of dimension m. IWK and WK are work spaces for the routine. The argument @ 1s the maximum number


<small>Original source: [View scanned PDF page 407](scans/page_0407.png)</small>

of subintervals ix which the interval of integration may be partitioned. It is assumed that £'> Land m > 4é. The argument n is a variable. When DQAGI terminates, n= the number of subintervals that appeared in the partition. Normally n < 100.

TERR is a variable that reports the status of the results. When the routine terminates, IERR has of the following values:

JERR = 0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

{ERR = 2 The integral has been computed, but because of roundoff error DQAGI is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

TERR = 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

IERR = 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

TERR = 6 (Input Error) Either <1, m < 42, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to O.

**Remarks.** F may have a singularity at a when MO = +1. However, it is recommended that no singularities appear in the interior of the interval of integration. DQAGI is a double precision version of the routine QAGI.

**Programming.** DQAGI employs the routines DQAGIE, DQKI5I, DQPSRT, and DQELG. ‘These subroutines are double precision versions by A. H. Morris of the subroutines QAGIK, QK15I, QPSRT, and QELG. The function DPMPAR is also used.

**Reference.** Piessens, R., de Doncker-Kapenga, ., Uberhuber, C. W., and Kahaner, D. K., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.


<small>Original source: [View scanned PDF page 408](scans/page_0408.png)</small>

<a id="topic-408-01"></a>
### Evaluation Of Double Integrals Over Triangles

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [`L114689`](source_parts/nswc_part_11.f90#L8813) |


Let f(z,y) be a real-valued function defined on a triangle T. Then the subroutine CUBTRI is available for computing the integral Sy f(z, y) dz dy. CUBTRI is an adaptive routine.

```fortran
CALL CUBTRI(F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER)
```

T ig a 2-dimensional real array of dimension 2 x 3 where T(1,7) and T(2,7) are the x and y coordinates of the j** vertex of the given triangle (7 = 1,2, 3).

IDATA and RDATA are arrays provided by the user containing any integer or real data needed for computing the integrand f(z,y). The arrays may be of any size. F is a user defined real-valued function having the arguments z,y,IDATA,RDATA. It is assumed that F(z,y,IDATA,RDATA) = f(z,y) for any point (z,y) in the triangle of integration T. F must be declared in the calling program to be of type EXTERNAL.

The input argument € is the error tolerance to be satisfied, and A is a variable. When CUBTRI is called, A is assigned the value obtained for ff, f(z,y)dzdy. The routine attempts to obtain a value A which satisfies | ff f(z,y)dzdy — A] < mar{e,e|Al}. Thus if |A| < 1 then ¢ is an absolute tolerance, whereas if |A| > | then ¢ is a relative tolerance. If one wants k digit accuracy then set « = (0-*. ERR is a variable. When CUPTRI terminates, ERR is the estimated error | ff f(x,y) dx dy ~- A| of the result.

The input argument MAX is the maximum number of points (2, y) at which F may be evaluated, and n is a variable. On an initial call to CUBTRI, the user must set n> 0. When the routine terminates, n will have for its value the number of points at which F was evaluated. (For subsequent calls concerning the same integral, see below.)

W is an array of dimension @ for internal use by the routine. The input argument é specifies the maximum number of subtriangles in which the triangle of integration 7 may be partitioned. The subtriangles are stored in W, each subtriangle requiring © storage locations. “Thus @/6 is an estimate of the maximum number of subtriangles that might have to be stored (@ 0 mar{1,3m 4 1} where m= (MAX/19 — I)/4).

TERR is an integer variable that reports the status of the results. When the routine terminates, HERR has one of the following values:

TERR 0 "The integral was computed to the desired accuracy.

IFRR ot MAN Gs too small A must be evaluated at more points.

IERR 2 The storage space Woois full) [ts dimension #imust be increased,

IERR 3 Further subdivision of the subtriangles impossible. This normally occurs when f(r, y) has a singularity in (he region. “The situation can frequently be eliminated by placing the singularity at a vertex of the triangle of integration 7.

TERR 4 No further improvement in accuracy as possible because of roundoff

error in the computation of F or the irregular behavior of Fe

HAS


<small>Original source: [View scanned PDF page 409](scans/page_0409.png)</small>

IERR = 5 No further improvement in accuracy is possible because subdivision does not change the estimated integral value A. Machine accuracy has probably been reached.

After an initial call to CUBTRI, the routine may be recalled to continue the computation of [fp f(x,y) dxdy. When the routine is recalled, the value of n obtained on the previous call to CUBTRI is used for the next call. This value for n tells the routine where computation should be resumed (using the information previously stored in W). At, least one of the values «, MAX, or € must be modified before CUBTRI is recalled. F, T, n, W, IDATA, and RDATA may not be changed when the routine is recalled.

**Remark.** F may have a singularity at one of the vertices of T (such as in the case when we are computing fo Jo (2? +3y?)~1/? dy dz). However, it is recommended that no singularities appear in the interior of the triangle of integration.

**Algorithm.** The 7-point degree 5 rule of Radon and a new 19-point degree 8 rule are used.

**Programming.** CUBTRI calls the function RNDERR and subroutine CUBRUL. Information is saved in labeled common blocks. The block names are CUBSTA and CUBATB. The routines were written by D. P. Laurie (National Research Institute for the Mathematical Sciences, Pretoria, South Africa),

**Reference.** Laurie, D. P., “Algorithm 584, CUBTRE: Automatic Cubature over a Triangle,” ACM Trans. Math Software 8 (1982), pp. 210-218.


<a id="category-410"></a>
## Integral Equations

<small>Original source: [View scanned PDF page 410](scans/page_0410.png)</small>

<a id="topic-410-01"></a>
### Solution of Fredholm Integral Equations of the Second Kind

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `IESLV` | `SUBROUTINE` | `KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER` | [`L115040`](source_parts/nswc_part_11.f90#L9164) |


If k(s,t) and f(s) are continuous real-valued functions for a < s < 6 and a <t< 6, then the equation to be solved is

z(s) — / k(s,t)a(t} dt = f(s)

fora < s <b. Let K be the operator defined by (Kz)(s) = f k(s,t)z(t) dt for any real-valued function z continuous on [a,b]. Then (Az)(s) is continuous for « < s < b, and k is called the kernel of K. Also the above integral equation can be written in the form (I ~ K)z = f where I is the identity operator. This equation has a unique solution if and only if J — K is 1 — 1, in which case z = (I~ K)~!f. The subroutine IESLV is available for computing this solution.

**Remark.** If Ca, }| is the normed space of real-valued functions z continuous on [a, b| and having the norm |/z|| = maxr{ |z(t)| : @ < t < 6}, then K is a compact mapping

C{a, 6] —+ Cla, 6] having the norm ||K|j - maz, f |k(s,t)| dt.

```fortran
CALL IESLV(KERNEL, RHFCN, A, B, EP, IFLAG, T, X, NT, NUPPER, MUPPER, NF, MF, NORM, W, IER)
```

It is assumed that a < 6, and that k(s,¢) and f(s) are user defined real-valued functions fora < 3,t <6. It is recommended that k and f be several times continuously differentiable. The functions k and f must be declared in the calling program to be of type EXTERNAL.

EPS is a variable and JFLAG an input argument whose values are 0 and 1. Ou Input EPS as the error tolerance that the solution must satisfy. If IFLAG QO then MPS is an absolute tolerance. Otherwise, if IFLAG ~ 1 then BPS is a relative tolerance. If HESLV solves the equation, then on output EPS is the estimated error of the result,

Before the remaining arguments s,v,f, 00. can be described, it is necessary to pave a brief outline of the algorithm used) When HeSLV is called, the integral equation ts

approximated by (+) rls) Sou kl ta draltad) fs) }

foras a+ 6 Here w,, and ¢,,, are the weights and nodes of Gauss-Legendre quadrature This equation ix treated as an interpolation for r(s) in terms of the values Paltaa). These

Values are obtained by solving: the equations

‘

wid (aa lindt (ta) flty,) i

(+6) ria(ty,)


<small>Original source: [View scanned PDF page 411](scans/page_0411.png)</small>

fort = 1,...,n. This system of equations can be solved directly or iteratively. The following

algorithm is used:

(1) Set n = 2 and go to (2).

(2) The n equations are solved directly. Then set m == 2n and solve the m equations (+**} iteratively. Jf the rate of convergence is sufficiently rapid or n cannot be increased, then go to (3). Otherwise, set n = m, and go to (2).

(3) Here n remains fixed. Repeatedly double the value of m and solve the m equations (+**) iteratively until convergence occurs, m cannot be increased, or the iterations diverge.

When the algorithm terminates, values 2,(tim) will have been computed for the nodes tim(# = 1, ...,m). Then from (*}, 2(8) & 2m(s) can be interpolated for a < a < 6.

N and M are input arguments, and WK is an array that is a work space for the routine. N and M are upper limits for n and m in the algorithm, and WK is of dimension 5N? + 9(N + M) or larger. It is assumed that M > N > 2. Since n and m are always powers of 2, N and M need only be set to powers of 2. However, this is not required.

S and X are arrays, and £is a variable. On input it is assumed that @ > 0. If 2 > 0 then S is assumed to contain @ points 9), ...,8¢ at which the solution z(s) is to be evaluated. Also X is assumed to be an array of dimension @ or larger. When IESLV terminates, X contains the values obtained for r(s;), ...,2(s¢). (This is true irregardless of whether or not the desired accuracy has been achieved.) Otherwise, if @ = 0 then S and X are assumed to be arrays of dimension M or larger. When 1ESLV terminates @ = the final value obtained for m, S contains the Gaussian nodes t,,(t = 1, ...,@), and X contains the values obtained for x(t,).

NF and MF are variables. When the routine terminates, NF is the final value for n and MF the final value for mi.

NORMK 3s a real variable. If 2 > 0 on input, then when IESLV terminates, NORMK is an approximation for ||Aj|. Otherwise, if 2= 0 then NORMK = 0.

IERR is a variable that reports the status of the results. When the routine terminates, IERE. has one of the following values:

IERR = 0 The solution was obtained to the desired accuracy. EPS is the estimated error of the result.

IERR <1 The solution was not obtained to the desired accuracy. EPS is the estimated error of the result.

JERR =< 2 The solution was not obtained to the desired accuracy. It is not clear what accuracy (if any) has been achieved. EPS has been set to 0.

IERR =: 3 The input value for EPS was too small. This may be due to illcondit‘oning of the integral equation. The value of EPS was reset to a more realistic tolerance, which the solution satisfied.

JERR. 4 The solution 2(s) was obtained at the Gaussian nodes to the desired precision, However, the interpolation process may not preserve this accuracy for the evaluation of x(a) for other points s.

EPS is the estimated error of the solution at the Gaussian nodes.

PAG


<small>Original source: [View scanned PDF page 412](scans/page_0412.png)</small>

JERR = 5 The solution z{s) was not obtained to the desired accuracy at the Gaussian nodes. EPS is the estimated error at these nodes. The interpolation process may not preserve this accuracy for the evaluation of 2(8) for other points s.

[ERR = 6 The input value for EPS was too small. This may be due to ill-conditioning of the integral equation. 'The value of EPS was reset to a more realistic tolerance, which the solution x(a) satisfied at the Gaussian nodes. The interpolation process may not preserve this accuracy for the evaluation of x(a) for other points s.

Difficulties can arise, causing IERR > 1, when the integral equation is ill-conditioned or the kernel &(¢,t) is not appropriate for standard Gaussian quadrature. Ill-conditioning can occur when the operator J - K is near singular or the norm ||K'|| is exceedingly large. Inappropriate kernels k(s,t) include those which are highly oscillatory or not continuously differentiable for s and t in the open interval (a, b).

**Programming.** IESLV employs the subroutines LEGS, NSTERP, WANDT,LEAVE, ITERT, LNSYS and functions RMIN,RNRM,CONEW. The routines save and exchange information in labeled common blocks. The block names are XXINFO and XXLIN. The routines were written by Kendall E. Atkinson (University of Iowa), and modified by A. H. Morris. The function SPMPAR is also used.

**Reference.** Atkinson, K. E.,“Ar Automatic Program for Linear Fredholm Integral Equations of the Second Kind,” ACM Trans. Math Software 2 (1976), pp. 154-171.

HAT


<a id="category-413"></a>
## Ordinary Differential Equations / Initial Value Problems

<small>Original source: [View scanned PDF page 413](scans/page_0413.png)</small>

<a id="topic-413-01"></a>
### The Initial Value Solvers - Introductory Comments


where f(t,y) = (filt,y), Salt, y)). Assume that y(a) is known. Then for 6 3 a the subroutines ODE, BRK F45, RKF45, GERK, SFODE, and SFODE1 are available for computing y{o). These routines are adaptive variable step, multistep differential equations solvers. ‘The remaining subroutines (RK and RK8} are one step procedures. Given the values y(t) and h, the one step solvers compute a value for y(t -+ h). The problem of selecting a suitable value for h is left to the user. Given y{a) and b, the one step solvers must be repeatedly called to step along the interval from a to b. In contrast, given y(a), 6, and error tolerances that are to be satisfied, the adaptive solvers continually adjust their step size (and possibly order) as they automatically step along the interval from a to b.

The adaptive subroutines differ in their capabilities. ODE, BRKF45, RKF45, and GERK are recommended for nonstiff equations, and SFODE and SFODE! for stiff equations. If one does not know whether the equations are stiff, then ODE should be tried. ODE maintains greater accuracy than the other subroutines, and it notifies the user if the equations appear to be stiff. ODE, BRKF45, RKF45, and GERK are able to handle mildly stiff problems satisfactorily, but SFODE and SFODEI are the only subroutines that can be used for solving extremely stiff problems.

If the equations are nonstiff, then ODE and BRKF45 should first be considered for solving the equations. If accuracy to 10 or more digits is needed then CDE should be used. Otherwise, if accuracy to 8 or fewer digits is desired and the derivative evaluations are inexpensive, thea BRKF45 may be the most efficient subroutine for solving the problem. BRKF45 normally requires more derivative evaluations than ODE, but its overhead is less than that for ODE. The nonstiff solvers RKF45 and GERK may also be used if accuracy to & or fewer digits is desired. However, these routines are not recommended since interpolation is not employed (see the output comments below).

When the user specifies error tolerances to be satisfied, normally he is interested only in the global error (the error of y(b)). However, the adaptive subroutines employ the tolerances for controlling local error (the error generated at each step in the interval from a to 6). No attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. GERK is the only su. routine that estimates the global error. his subroutine employs the same Runge-Kutta-Fehlberg formulae used by RKF45. GERKE js 2-3 times slower than RKF45, but it is more accurate. RK E45 and BRKF45 take roughly the same amount of time, and have approximately the same accuracy.

Output Considerations. Generally, when the equations y’(t) - f(t,u(t)) are to be solved and y(ay) is known, then solutions will be needed at a sequence of points dy, -..,@ya. Tf ODE, BRKF45, SFODE, or SFODEL is used, then the closeness of the output points a, should be of no concern. ‘The subroutines partially ignore a, 4, in the selection of the step size when going from a, to a,j. Instead, they step along the interval using the largest steps that are appropriate (accuracy aud efficiency are the prime concerns). Normally ayy 4

will be passed in the process Hf a,,j is passed then a quick interpolation yields the desired


<small>Original source: [View scanned PDF page 414](scans/page_0414.png)</small>

result for y(a;41). Thus, the process of solving the equations at a,4, when y(a,) is known may require that no steps be taken (a, may have been passed on a previous call to the routine), or it may require that one or more steps be taken.

The situation is considerably different when RKF45 or GERK is used. Since these subroutines do not have an interpolation procedure, they must select a step size so as not to bypass a;41 when going from a, to aj41. Thus, the output points a, may be so close to one another that inordinately small step sizes are required. If this occurs then the performance of RKF45 and GERK may deteriorate dramatically. The subroutines notify the user when this occurs.

pot)


<small>Original source: [View scanned PDF page 415](scans/page_0415.png)</small>

<a id="topic-415-01"></a>
### Adaptive Adams Solution Of Nonstiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [`L116212`](source_parts/nswc_part_11.f90#L10336) |


Let y'(t) = f(t, y(t)) denote a system of n ordinary first order differential equations where f(t,y) = (filt,y), .--.fa(t,y)) and y(t) = (yi(t), ...,yn(t}). Assume that y(a) is known. Then for 6 + @ the subroutine ODE is available for computing y(b). ODE is recommended for nonstiff equations. The algorithm used is a variable order, variable step Adams predictor-correcter procedure.

```fortran
CALL ODE(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
```

The argument F is the name of a user defined subroutine that has the format: CALL F(t, ¥,DY) Y and DY are arrays of dimension n. On input Y contains the values y;(t),...,y,(t) for the argument t. F computes the derivatives yj(t), ...,y/,(¢) using y'(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 100 -++ 21n or larger, and [WK is an array of dimension 5 or larger. WK and IWK contain information needed for subsequent calls to ODE.

it is assumed that a 3 6. The argument Y of ODE is an array of dimension n, and the arguments T,R@RR,AERR,IND are variables. (TOUT need not be a variable.) When ODE is initially called, it is assumed that:

T=a

TOUT = 6

Y(1),...,¥(n) contain the values y;(a), ..., yn(a)

RERR = the relative error tolerance to be satisfied

AERR = the absolute error tolerance to be satisfied

IND = +1 It is preferable, both for efficiency and accuracy, that ODE be permitted to step along the axis from a to 6 using the largest steps that are appropriate. This is what is done when IND is set to 1. If IND = 1 then ODE will step along the axis, possibly passing 6 and going as far as the point a + 10{6 ~ aj. Uf 6 is passed, then the solution for the equations

not defined at all points between 6 and a+ i0(b ~ a). In a situation such 2s this, when integration cannot be permitted to step internally past TOUT, IND must pe set to ~L. If IND =<: -1 then it is required that the subroutine # be defined at TOUT. However, F need not be defined at points t past TOUT. If the equations y’(t) = f(t, y(t)) are not defined at t = TOUT, then it should suffice to let F set each DY(1) 0 when ¢ = TOUT. A solution (if one exists) will be obtained by extrapolation.

If IND is positive (negative), then when ODE terminates IND will have been reset by ODE to one of the values 2,3,4,5,6,7(2, ~3, -4, = 5,--6,7). These values have the following meanings:

IND = 2 The equations have been solved at TOUT. 7 now has the value

TOUT and FY contains the solution al POUT,

IND oo £3 ‘The error tolerances RERK and ARRR are too small. ‘fis set to

the point closest to TOUT for which the equations were solved


<small>Original source: [View scanned PDF page 416](scans/page_0416.png)</small>

and Y contains the solution at the point. RERR and AERR have been reset to larger acceptable values.

IND = +4 MAXNUM steps were performed.! More steps are needed to reach TOOT. T is set to the point closest to TOUT for which the equations were solved and Y contains the solution at the point.

IND = +5 MAXNUM steps were performed. More steps are needed to reach TOUT. T is set to the point closest to TOUT for which the equations were solved and Y contains the solution at the point. The equations appear to be stiff,

IND = +6 ODE did not reach TOUT because AERR = 0. T is set to the point closest to TOUT for which the equations were solved and Y contains the solution at the point.

IND = 7 No computation was performed. An input error was detected. The user must correct the error and call ODE again.

WIND = +3,+4,+5 then to continue the integration just call ODE again. Similarly, if IND = +6 then reset AERR to be positive and call ODE again. In these cases do not modify T,Y,IND. The output values for these parameters are the appropriate input values for the next call to ODE. However, AERR and RERR may always be modified when continuing an integration.

If the equations appear to be stiff (i.e., if IND = +5) then ODE may not be suitable for solving the equations. In this case it is recommended that a routine designed specifically for stiff equations be used.

Whenever IND = 2 occurs, then the equations have been solved at TOUT = 8. WK and tWK contain information that can often be reused in continuing along the axis and solving the equations at a new point c. To continue the integration, normally one need only reset TOUT to the new value c and call ODE again. Do not modify T, Y,IND. The output values for these parameters are normally the appropriate input values for the next call to ODE. The one exception is when the equations are not defined at points past c. If this occurs, then one should also reset the output value IND = 2 (from the last call to ODE) to the input value IND = —2 for the next call to ODE. If IND is reset to —-2, then integration will not proceed internally past the new TOUT when ODE is recalled. In this case, the subroutine F need not be defined for points past TOUT. However, it is required that F be defined at TOUT.

If after going from a to 6, ODE is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +2 for the next call to ODE. Setting IND to +1! causes the integration procedure to be restarted, thereby eliminating the information being saved in WK and IWK. Restarting not only can take more time, but also can lead to less accurate results. H IND is set to 12, then the integration procedure restarts itself only if the direction of integration is being reversed or IND was negative when ODE was last recalled. The direction of integration is reversed when & does not lie between a@ and c.

‘Mach step normally requires two calls to the subroutine F. Currently the internal parameter MAXNUM

is set at 500,

oad te


<small>Original source: [View scanned PDF page 417](scans/page_0417.png)</small>

ff one has a choice between setting IND to be positive or negative, then always set IND to be positive. Extrapolation is normally involved when IND is negative. The extrapolation can require more time and be less accurate than the procedures employed when IND is positive.

**Input Errors.** IND =: 7 when one of the following conditions is violated:

(I)n>1

(2) T# TOUT

(3) RERR > 0 and AERR > 0

(4) RERR and AERR are not both 0

(5) 1 < [IND] < 5, or IND = +6 and AERR > 0

(6) When continuing an integration, the input value for T is the output value of TOUT from the previous call to ODE.

The last condition is automatically satisfied if the user has not inadvertently modified T.

Error Control. Assuming that ODE has obtained the correct value for y(t), let e; denote the error generated in the computation Y(t) of y,(t+h) for# = 1, ...,n when ODE steps from t tot+h. The routine attempts at each step to maintain the accuracy D,(e;/w,;)? < 1 where w; =RERR|Y (#)|+AERR. When this criterion is satisfied, then |e,| < w,; for ¢ = 1, ...,n. This criterion includes as special cases relative error (AERR = GC) and absolute error (RERR = 0). However, if AERR = 0 and Y(t) = 0 for some #, then w; = 0 and IND = +46.

When going from T to TOUT, ODE continually adjusts its order and step size so as to maintain accuracy at each step. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion of accuracy can be significant, at times one may wish to double-check the results by rerunning the problem. If this is done, then in the second run ask for greater accuracy.

**Programming.** ODE employs the subroutines DE1, STEP1, and INTRP. These routines were written by L. F. Shampine and M. K. Gordon (Sandia Laboratories). The function SPMPAR is also used.

**Reference.** Shampine, L. F., and Gordon, M. K., Computer Solution of Ordinary Differential Equations, W. H. Freeman and Company, San Francisco, 1975.

eal qt biel


<small>Original source: [View scanned PDF page 418](scans/page_0418.png)</small>

<a id="topic-418-01"></a>
### Adaptive Block RKF Solution Of Nonstiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [`L117201`](source_parts/nswc_part_12.f90#L812) |


Let y/(t) = f(t,y(2)) denote a system of n ordinary first order differential equations where f(t,y) = (fi(t,y),--.,fn(t,y)) and y(t) = (v(t), ...,y,(¢)). Assume that y(a) is known, and that f is defined and continuous on the interval from a to TIEND. Then for any 6 in this interval the subroutine BRKF45 1s available for computing y(6) and its derivative y'(6). BRKE45 was designed for solving nonstiff differential equations when derivative evaluations are inexpensive and the accuracy requirements are low (8 or fewer significant digits). The subroutine employs the Cash block Runge-Kutta-Fehlberg procedure.

```fortran
CALL BRKF45(FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK)
```

The argument F' is the name of a user defined subroutine that has the format: CALL F(t, Y,DY) Y and DY are arrays of dimension n. On input Y contains the values y;(t), ..., yn(t) for the argument t. F computes the derivatives y’,(t), ...,y’,(t) using y’(t) = f(t, y(é)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 6 + 9n or larger, and [WK an array of dimension 5 or larger. WK and IWK contain information needed by subsequent calls to BRKF45.

The arguments Y and DY of BRKF45 are arrays of dimension n, and the arguments T, RERR, and IND are variables. (TOUT, TEND, and AERR need not be variables.) When BRKF45 is initially called, it is assumed that:

T=a

TOUT = 6b

TEND = end of the interval of integration (TEND # a)

Y (1), ...,¥(n) contain the values yi(a),...,yn(a}

RERR = the relative error tolerance to be satisfied (RERR > 0)

AERR = the absolute error tolerance to be satisfied (AERR > 0)

IND = +1 For efficiency, BRK F45 will step along the interval (in 2-step blocks) from a to b, using the largest steps that are appropriate. If IND = --1 then only a single 2-step block will be taken. Otherwise, if IND = 1 then BRKF45 will step along the interval, possibly passing 6 (but never passing TEND). If 6 is passed then the solution for the equations at 6 will be obtained by interpolation.

On output T is set to the point closest to TOUT for which the equations were solved, Y contains the solution y{7') at T, and DY contains the derivative y/(7') at T. Also, IND reports the status of the results. BRKF45 sets IND to one cf the following values: IND >. 2 Hither the equations were solved at TOUT (in which case, T u0w has the value TOUT), or TOUT was beyond TEND and the equations were solved at TREND (in which case, 7 now has the value TEND). IND 2 A single 2 -step block in the direction of TOUT was taken.


<small>Original source: [View scanned PDF page 419](scans/page_0419.png)</small>

IND =: 3 The error tolerance RERR was too small. RERR has been reset to a larger acceptable value.

IND == 4 18000 derivative evaluations (involving approximately 2000 2- step blocks) were performed. More derivative evaluations are needed to reach TOUT.

IND = & BRKF45 did not reach TOUT because AERR =: 0. AERR must be made positive.

IND = 6 Too much accuracy was requested. RERR or AERR must be increased in value.

IND = 7 An input error was detected (see below).

If IND = 2 and T now has the value TOUT, then the equations have been solved at TOUT = 8. The arrays WK and [WK contain information that can be reused in continuing along the interval from 6 to TEND and solving the equation at a new point c. 'To continue the integration the user need only reset TOUT to the new point c and call BRKF45 again.

If IND = —2 then to continue the integration another 2-step block just call BRKF45 again. In the single 2-step block mode (IND = —-1, —2) the user must keep in mind that each step taken is in the direction of the current TOUT. Upon reaching TOUT (which is indicated by IND = 2 and T = TOUT), the user may define a new TOUT and set IND = +2 for further integration.

If IND = 3 or 4 then to continue the integration just call BRKF45 again. However if IND = 5 then the user must first reset AERR to be positive before BRKF45 can be recalled. If this is not done then the run will be terminated by a STOP instruction! If IND = 6 then it is required that IND be reset to +2 and that AERR or RERR be increased in value. If this is not done then the run will be terminated by a STOP instruction.

If after going from a to b, BRKF45 is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +2 instead of +1. Setting IND = :£1 causes the integration process to be restarted, thereby eliminating the information being saved in WK and IWK. Restarting wastes time and is normally not needed. The only exceptions are when the direction of integration is reversed or TEND is modified. Then the integration must be restarted. (TEND must be modified when the direction of integration is reversed.)

The purpose for the argument TEND is to ensure that no integration is performed past, this point. This is important since F may not be continuous at TEND, or F may not be defined beyond TEND, When the equations are solved at TEND (which is indicated by IND = 2 and T = TEND), then no further integration can be performed. It is always assumed that T ¢ TEND on input.

**Notes.**

(1) 7, n, WK, IWK must never be modified on a continuation call to BRKF45. However, AERR and RERR may be modified at any time.

(2) When continuing an integration, one may switch from the standard multistep mode (IND -. 2) to the single 2 step block mode (IND ~~ 2) when it is convenient to do so.


<small>Original source: [View scanned PDF page 420](scans/page_0420.png)</small>

**Input Errors.** IND = 7 when one of the following errors is detected:

(I) n<0

(2) T = TEND

(3) Either AERR or RERR is negative.

(4) TOUT and TEND are in opposite directions from T.

(5) IND = 0 or [IND] > 7.

If (2) occurs then integration cannot be continued. Otherwise, the error must be corrected and IND reset to +1 (or +2 when the previous call was a continuation call). If this is not done then the run will be terminated by a STOP instruction when BRKF45 is recalled.

Error Control. When going from T to TOUT, BRKF45 continually adjusts its step size go aS to maintain accuracy at each 2-step block. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion of accuracy can be significant, at times one may wish to double-check the results by rerunning the problem with BRKF45 or ODE. If this is done then in the second run ask for greater accuracy.

**Programming.** BRKF45 employs the subroutines RKFC and EXTRA. These routines were written by J. R. Cash (Imperial College, London), and modified by Desmond J. Higham and A. H. Morris. The function SPMPAR is also used.

**References.** (1) Cash, J.R.,“A Block 6(4) Runge-Kutta Formula for Nonstiff Initial Value Problems,”

ACM Trans. Math Software 15 (1989), pp. 15-28. (2) Higham, D.J., “Remark on Algorithm 669,” ACM Trans. Math Software 17 (1991),

pp. 424-426.


<small>Original source: [View scanned PDF page 421](scans/page_0421.png)</small>

<a id="topic-421-01"></a>
### Adaptive RKF Solution Of Nonstiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [`L118174`](source_parts/nswc_part_12.f90#L1785) |


Let y/(t) = f(t, y(t)) denote a system of n ordinary first order differential equations where f{t,y) = (fi (t,y), ..-, fa (t, y)) and y(t) = (y1 (¢), ..-, yn (t)). Assume that y(a) is known. Then for 6 # a the subroutine RKF46 is available for computing y(b). RKF45 was designed for solving nonstiff differential equations when derivative evaluations are inexpensive and the accuracy requirements are low (less than 8 significant digits). The routine employs the fourth-fifth order Runge-Kutta-Fehlberg formulae.

```fortran
CALL RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
```

The argument F is the name of a user defined subroutine that has the format: CALL F(t, Y,DY) Y and DY are arrays of dimension n. On input Y contains the values y,(t), ..., y(t) for the argument t. F computes the derivatives y}(t), ...,y/(t) using y’(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 3+ 6n or larger, and IWK is an array of dimension 5 or larger. WK and IWK contain information needed for subsequent calls to RKF45.

The argument Y of RKF45 is an array of dimension n, and the arguments 7, KERR, IND are variables. (TOUT and AERR need not be variables.) When RKF45 is initially called, it is assumed that:

T=a

TOUT = 6

Y(1), ...,¥(n) contain the values y;(a), ...,¥,.(a)

RERR = the relative error tolerance to be satisfied (RERR > 0)

AERR =: the absolute error tolerance to be satisfied (AF RR > 0)

```text
IND = x1
Normally IND -= 1. However, if only a single step in the direction of TOUT is to be taken,
then set IND == ~ 1.
```

On output T is set to the point closest to TOUT for which the equations were solved, and Y contains the solution at 7. Also IND reports the status of the results RKB AS sets IND to one of the following values:

IND. 2 The equations were successfully solved at TOUT. Tonow has the

value TOUT. IND- .2 A single step in the direction of TOU'T was taken.

IND 3 The error tolerance RE RR was too small. RERR has been reset to a larger acceptable value.

IND 4 3000 derivative evaluations were performed. More derivative evaluations are needed to reach TOUTE.

IND 5 RRE4AS did not reach TOUT because AIERR oO.) ARERR mast be made positive

IND 6 Poo much accuracy has been requested. ALR o> REER must be

Increased tn value

ner O09


<small>Original source: [View scanned PDF page 422](scans/page_0422.png)</small>

```text
IND = 7 The closeness of the output points is restricting the natural step
size choice.
IND = 8 An input error was detected (see below).
```

If IND = 2 then the equations have been solved at TOUT == 5. The arrays WK and IWK contain information that can often be reused in continuing along the axis and solving the equations at a new point c. To continue the integration the user need only reset TOUT to the new point c and call RKF45 again.

If IND = —2 then to continue the integration another single step just call RKF45 again. In the single step mode (IND = --1, —2) the user must keep in mind that each step taken is in the direction of the current TOUT. Upon reaching TOUT (which is indicated by IND being set to 2), the user may then define a new TOUT and set IND to +2 for further integration.

If IND = 3 or 4 then to continue the integration just call RKF45 again. However, if IND = 5 then the user must first reset AERR to be positive before RKF45 can be recalled. If this is not done then the run will be terminated by a STOP instruction! If IND == 6 then it is required that IND be reset to +2 and that AERR or RERR be increased in value. If this is not done then the run will be terminated by a STOP instruction.

If IND = 7 then the user should switch to a routine (such as ODE or BRKF45) which performs interpolation. If the user insists on continuing the integration with RKF45 then it is required that IND be reset to +2 before RKF45 is recalled. If this is not done then the run will be terminated by a STOP instruction.

If after going from a@ to 6, RKF45 is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +:2 instead of 4:1. Setting IND => £1 causes the integration process to be restarted, thereby eliminating the information being saved in WK and IWK,. Restarting wastes time and is normally not needed, The one exception is when the direction of integration is to be reversed. Then the integration must be restarted.

**Notes.**

(1) AERR and RERR can be modified each time that RK #45 is called.

(2) When continuing an integration, one may switch from the standard multistep mode (IND © 2) to the one step mode (IND 2) whenever it is convenient to do so.

**Input Errors.** IND) © 8 occurs when one of the following conditions is violated:

(1) nool

(2) FP 4 POUT when IND / 11

(3) RERR + O and ABRR + 0

(END 44, 42,3)4,.. 8

IPIND oS then the error must be corrected and END) reset te tt (or i 2 when the previous call was a continuation call). this ts not done then the ron wil be terminated by a S’POR

instruction when RA PAS os recalled


<small>Original source: [View scanned PDF page 423](scans/page_0423.png)</small>

Error Control. When going from T to TOUT, RKF45 continually adjusts its step size so as to maintain accuracy at each step. Assuming that RKF45 has obtained the correct value for y(t), let e; denote the error generated in the computation of y(t +A) fort =1,...,n when RKF‘45 steps from ¢ to t+ A. Then at each step the error is controlled so that

les| < RERR + AERR

[ys(t)| + [ys (t + 4)] 2 fort = 1,...,n. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion of accuracy can be significant, at times one may wish to double-check the results. This can best be done by comparing the results obtained by RKF45 with those obtained by ODE or GERK. If ODE is used then ask for greater accuracy. However, if GERK is used then the current error tolerances can be used. GERK is more accurate than RKF45, and it estimates the global error generated.

**Programming.** RKF45 employs the subroutines RKFS and FEHL. These routines were written by H. A. Watts and L. F. Shampine (Sandia Laboratories). The function SPMPAR

is also used.

**References.** Shampine, L. F.,and Allen, R. C., Numerical Computing: An Introduction, W.B. Sanders, Philadelphia, 1973.


<small>Original source: [View scanned PDF page 424](scans/page_0424.png)</small>

<a id="topic-424-01"></a>
### Adaptive RKF Solution Of Nonstiff Differential Equations With Global Error Estimation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [`L118806`](source_parts/nswc_part_12.f90#L2417) |


Lei y'(t) == f(t,y(t)) denote a system of n ordinary first order differential equations where f(t,y) = (fi (t,y), ---, fn (t,y)) and y(t) = (yi (t), ..., yn (t)}. Assume that y(a) is known. Then for b 4 a the subroutine GERK is available for computing y(b). GERK was designed for solving nonstiff differential equations when derivative evaluations are inexpensive and the accuracy requirements are low (less than 8 significant digits). The routine employs the fourth-fifth order Runge-Kutta-Fehlberg formulae. GERK estimates the accuracy of the solution y(b).

```fortran
CALL GERK(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK)
```

The argument F is the name of a user defined subroutine that has the format: CALL F(t, Y, DY) Y and DY are arrays of dimension n. On input Y contains the values y; (tj, -.-, yn (t) for the argument t. F computes the derivatives yj(t),...,y/,(t) using y/(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 3 +4- 8n or larger, and 1WK is an array of dimension 5 or larger. WK and JWK contain information needed for subsequent calls to GERK.

The argument Y of GERK ts an array of dimension n or larger, and the arguments 7° and IND are variables. (TOUT, RERR, AERR need not be variables.) When GERK is initially called, it is assumed that:

Teoa

TOUT ~ b

Y(1),.-..¥(n) contain the values y; (a), ..., yn (@)

RERR | the relative error tolerance to be satisfied (RERR > 0)

AERR -. the absolute error tolerance to be satisfied (ARBRE > 0)

IND t | Normally IND LL. However, if only a single step in the direction of TOUT is to be taken then set IND I.

GERROR is an array of dimension nor larger. Qn output Vis set to Che point closest to TOUT for which the equations were solved, Y contains the solution at 7) and GEEK ROR(s)

is an estimate of the error of V(r) fora I, oooym. Also IND reports the status of the results. GERK sets IND to one of the following values: IND 2 ‘The equations were successfully solved at POUT 7 now has the

value POUT

IND 2 A single step in the direction of “POUT was taken,

IND 3 9000 derivative evaluations were performed More derivative evaluations are needed to reach POUT

INI) A GERB did not reach POUR because AR RR O00 ARERR nous be

Ihade positive

Aig


<small>Original source: [View scanned PDF page 425](scans/page_0425.png)</small>

IND == 5 Too much accuracy has been requested. AERR or RERR must be increased in value.

```text
IND = 6 The closeness of th2 ouput points is restricting the natural step
size choice.
IND = 7 An input error was detected (see below)
```

If IND) == 2 then the equations have been solved at TOUT = 5. The arrays WK and TWK contain information that can often be reused in continuing along the axis and solving the equations at a new point c. To continue the integration the user need only reset TOUT to the new point c and call GEEK again.

If IND = —2 then to continue the integra‘icn another single step just call GERK again. In the sing! step mode (IND = ~1,—2) the user must keep in mind that each step taken

is in the direction of the current TOUT. Upon reaching TOUT (which is indicated by IND being set to 2), the user may then define a new TOUT and set IND to +2 for further integration.

if IND = 3 then to continue the integration just call GERK again. However, if IND = 4 then the user must first reset AERR to be positive before GERh can be recalled. If this is not done then the run will be terminated by a STOP instruction! If IND = 5 then it is required that IND he reset to 4:2 and that AERR or RERR be increased in value. If this is not done then the run will be terminated by a STOP instr. ction.

If IND := 6 then the user should switch to a routine (such as ODE or BRKF45) which performs interpolation. If the user insists sn continuing the integration with GERK then it is required that IND be reset to +2 before GERK is recalled. I* this is not dene then the run will be terminated by a STOP instruction.

If after going from a to 6, GERK is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +2 instead of LL. Setting IND = +1 causes the integration process to be restarted, thereby eliminating the information being saved in WK and IWK. Restarting wastes time and is normally not needed. The one exception is when the direction of integration is to be reversed. Then the integration must be restarted.

**Notes.**

(1) AERR and RERR can be modified each time that GERK is called.

(2) When continuing an integration, one may switch from the standard multistep mode (INL. 2) to the one step mode (IND © -2) whenever it is convenient to do so.

**Input Errors.** IND ©: 7 occurs when one of the following conditions is violated: thno>

2) 7 4 TOUT when IND 4 1)

3) RERR > 0 and AERR > 9

4) IND . £4,°62,38,4,....7

IND 7 then the error must be corrected and IND) reset to ti for $2 when the prev sors

{ ( cell was a continuation call). Pf this is not done then the run will be terminated by a SEO"


<small>Original source: [View scanned PDF page 426](scans/page_0426.png)</small>

instruction when GERK is recalled.

Accuracy Considerations. Error control in GERK is almost identical to that in RKF45. One minor difference is that GERK never employs relative error tolerances less than 3-107 1, whereas RKF45 never employs relative error tolerances less than 107 !?.

The only significant difference between GERK and RKI45 is that GERK generates two solutions for the differential equations, whereas RKF45 generates only one. Let y(t) and g(t) denote the solutions generated by GERK at point t. One of these solutions, say y(t), will frequently be identical to the solution computed by RKF45. When going from t to t+ h, the step size A is selected so thai ¥(t + 4) satisfies the local error criterion. After a suitable A is found then GERK takes two steps, each of length h/2, to generate g(t + h) from ¥(t). When GERK terminates, say at point 7’, then the §(T) solution is stored in the Y array and GERK estimates the error of 9,(7) to be (y,{T) — §:(T))/31 for # =1, ...,n.

**Programming.** GERK employs the subroutines «ERKS and FEHL. These routines were written by H. A. Watts and L. F. Shampine (Sandia Laboratories). The function SPMPAR

is also used.

**Reference.** Shampine, L. F., and Allen, R. C., Numerical Computing: An Introduction, W. B. Saunders, Philadelphia, 1973.

Ny a3)


<small>Original source: [View scanned PDF page 427](scans/page_0427.png)</small>

<a id="topic-427-01"></a>
### Adaptive Solution Of Stiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [`L119429`](source_parts/nswc_part_12.f90#L3040) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [`L119464`](source_parts/nswc_part_12.f90#L3075) |


Let y’(t) = f(t, y(t)) denote a system of n ordinary first order differential equations where flt,y) = Cit, y). ..-, fn (t, y)) and y(t) = (yi (t), --.,yn(t)). Assume that y(a) is known. Then for 6 # a the following subroutines are available for computing y(b). These routines are designed for stiff differential equations. The algorithm used is a variable order, variable step backward differentiation procedure.

CALL SFODE(£,n, Y,7,/TOUT,INFO,RERR,AERR,IER, WK,é,1WK,m,RD, ID)

RD and ID are arrays defined by the user containing any real and integer data that is needed for computing {. These arrays may contain any information that the user desires. The argument F is the name of a user defined subroutine that has the format:

CALL Fit, Y ,DY,RD,ID) Y and DY are arrays of dimension n. On input Y contains the values yi(t), ..., ya(t) for the argument t. F computes the derivatives y(t), ...,y/(¢) using y/(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

INFO is an array of dimension 4, WK an array of dimension @, and [WK an array of dimension m. WK and IWK are work spaces for the routine, and INFO is an array defined by the user containing information on how the equations are to be treated.

```text
INFO(1): Set INFO(i) = 0 on an initial call to the routine. On a continua-
tion call INFO(i) = 1.
```

INFO/2): Normally INFO(2) = 0. However, INFO(2) = 1 when the intermediate output mode is desired (see below).

INFO(3): When INFO(3) = 0, SFODE proceeds from a to b using the largest stops that are appropriate. If b is passed then y(6) is obtained by interpolation. However, for some problems the routine cannot be permitted to step past a point TSTOP because y(t) = f(t, y(t) is discontinuous or not defined beyond TSTOP. When this is the case set INFO(3) = 1 and WK(1) = TSTOP.

INFO(4): When proceeding from a to 6, the n x n Jacobian matrix J f(t) = (Of; /0y,) is computed and stored in WK. Normally it is assumed that

INFO(4) = 0

2 > 250° 10n+n?

m™> 55-n. However, if J f(¢) is banded for all t, having the lower and upper band widths my, and m, where 2rny +m, <n, then the following setup can be used:

IWK(L) ome

IWK(2) < ony,

€ © 2504 ln b (2re bang! tn

mo Gh obon


<small>Original source: [View scanned PDF page 428](scans/page_0428.png)</small>

T, TOUT, RERR, and AERR are variables, and the argument Y of SFODE is an

array of dimension n. On an initial call to the routine it is assumed that

INFO(1) = 0

Tae

TOUT =6

Y(1),...,¥(n) contain the values y1(a), ..., yn(a)

RERR =: the relative error tolerance to be satisfied (RERR > 0)

AERR = the absolute error tolerance to be satisfied (AERR > 9).

IER is a variable. When SFODE terminates T is the final point where the equations were solved, Y contains the solution at T, and IER reports the status of the results. IE is assigned one of the following values:

IER = 1 A step was taken in the intermediate output mode. TOUT was not reached. To continue, call the routine again.

IER = 2 The solution at TOUT was obtained by stepping exactly to TOUT.

```text
IER = 3 The solution at TOUT was obtained by stepping past TOUT and
then interpolating. On output T = TOUT.
```

IER = —1 500 steps have been taken. TOUT has not been reached. To continue, call the routine again.

IER = —2 The tolerances RERR and AERR were too stringent. RERR and AERR have been modified by the routine. The tolerances may be further modified by the user if he desires. To continue, call the routine again.

IER = —3 In this case AERR = 0. SFODE stopped when y; became 0. INFO(1) was set to -?. To continue set AERR to be positive, INFO(1) = 1, and call the routine again.

TER == —6 Convergence failed on the last attempted step. An inaccurate Jacobian matrix may be the problem. To continue, restart the routine by setting INFO(1) = 0 and call the routine again.

IER = —7 Repeated error test failures occurred on the last attempted step. The problem should be reexamined. A singularity may be present in the solution. To continue, restart by setting INFO(1) = 0 and call the routine again.

IER < --33 An input error was detected (see below),

When IER > —2, then INFO(J) = 1 on output.

When the equations are solved at TOUT (IER = 2 or 3), integration can be continued along the axis to solve the equations ai a new point c beyond TOUT. To continue, one need only set TOUT to the new value c and call the routine again. When continuing an integration where INFO(1) = 1, never modify 7, Y, WK, IWK, INFO(3), and INFO/4). However, INFO(2), RERR, AERR, RD, and 1D may be modified at any time.

Intermediate Output Mode. Uf one wishes to study the behavior of the solution y(t) as the routine steps from 7 to VOU'T, then sei INFO(2) 2 1. Then SFODE will stop after each successful step (yielding He © 1y ung) TOUT is reached. One may switch from the standard mode of operation (INFO(2) 0) to the intermediate output mode (INFO(2)

1} or vice versa ab any tire


<small>Original source: [View scanned PDF page 429](scans/page_0429.png)</small>

**Remark.** The diagnostic IER =: --1 does not state that 500 steps have been taken on the current call to SFODE. On an initial call to the routine the step counter is set to 0, On continuation calls, the counter continues to increase until 500 steps have accumulated. When IER = --1 is reported, the counter is reset to 0, and only then does the step counting begin again.

```text
Input Errors. IER is set to one of the following values when an input error is detected.
IER = -33 n< 1
IER = —34 RERR < 0
IER = —35 AERR < 0
TER = -36 The routine has been called with TOUT, but it has also been told
not to step past the point TSTOP.
IiR =: ~87 T = TOUT. This is not permitted on continuation calls.
iER == --38 The user has modified 7.
TER = ~39 TOUT is not beyond 7. An attempt is being made to change the
direction cf integration without restarting.
[ER = ~—40 The Jacobian mztrix is banded. However, mz, and m,, do not
satisfy 0 < my < aandO< m, <n.
IER = --41 £< 250+ 10n +n?
TER = —42 €< 250+ 10n + (2mye+ my, + 1)n
IER = —43 m<'5+a
IER = —44 INFO(1) is incorrect.
After the error is corrected, set INFO(1) = 0 and call the routine again.
```

```text
Error Contrel. Assuming that SFODE has the correct value for y(t}, let e, denote the
error generated in computing y(t +A) for’ = 1, ...,n when SFODE steps from t tot +h.
The routine attempts at each step to maintain the accuracy 13 (e:/wi)? < 1 where w; =
RERR |y,(t)| 4+- AERR. When this criterion is satisfied, le,| < /nw, fort =1,...,n. This
criterion includes as special cases relative error (AERR = 0) and absolute error (RERR =:
0). However, if AERR = 0 and y(t) = 0 for some :, then this criterion cannot be applied
and JER = -3 occurs.
```

When proceeding from T to TOUT, the routin» continually readjusts its order and step size so as to maintain accuracy at each step. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion cf accuracy can be significant, at times one may wish to double-check the results. If the problem is nonstiff or mildly stiff fur an interval, then the best procedure 1s to compare the results obtained by SFODE with those obtained by ODE for the interval. ODE normally maintains greater accuracy than SFODE. However, if the problem is extremely s iff then rerun the problem with SFODE. On the second run, request greater accuracy.

**Programming.** SFODE calls the subroutines STFODE and ZZZJAC. STFODE employs the subroutines LSODt, HSTART, IN'TYD, STOD, CFOD, PIAC, SLVS, SGBFA, SGBSL, SGEPA. SGESL, SAXPY, and SSCAL, and the functions VNORM, VNWRMS, ISAMAX, SPOT, and SPMPAR. The routines save and exchange information in a labeled common block having the block name DEBDF!. STEODE is a modification by A. HE Morris of the

HOG


<small>Original source: [View scanned PDF page 430](scans/page_0430.png)</small>

subroutine DEBDF, designed by L. F. Shampine and H. A. Watts (Sandia Laboratories). DEBDF appears in the SLATEC library. STFODE is a driver for a modification of the code LSODE, written by A. C. Hindmarsh (Lawrence Livermore Laboratory).

CALL SFODE1(F, n, Y,7,TOUT,INFO,RERR,AERR,IEK, WK, é,1WK,m,RD,ID)

SFODE1 differs from SFODE only in the treatment of RERR and AERR. In SFODE1, RERR and AERR are arrays of dimension n. RERR(t) and AERR(t) are relative and absolute error tolerances to control the accuracy of the #** solution component y,(t) for t= 1,...,n. Let e; denote the error generated in the computation of y,(t +h) from y,({t) when SPODE] steps from t tot-+ h. Then SFODEI attempts at each step to maintain the accuracy +5,(e;/w,)? < 1 where w; = RERR(s)|y,(£)]| + AERR(1), When this criterion is satisfied les! < J/nw, fori = =1,...,n. However, if AERR(t) = 0 and y,(t) = 0 for some ¢, then the criterion cannot be applied and [ER = --3 occurs.

When IER references RERR and AERR, the settings for IER provide the following

information:

IER = -2 The accuracy required by RERR and AERR is too stringent. RERR and AERR have been modified by the routine. RERR and AERR may be further modified by the user if he desires.

To continue, call SFODEI again.

IER = -3 SFODEI stopped when y; became 0 and AERR(i) = 0. INFO(1) was set to —1. To continue set AERR(t) to be positive, INFO(1) = 1, and call the routine again.

IER = --34 (Input error) RERR(t) < 0 for some 1.

IER = —35 (Input error) AERR(t) < 0 for some #.

RERR and AERR may Le modified on any continuation call to SFODEL1.

**Programming.** SFODE1 calls the subroutines STFODE and ZZZJAC.


<small>Original source: [View scanned PDF page 431](scans/page_0431.png)</small>

<a id="topic-431-01"></a>
### Fourth-Order Runge-Kutta

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [`L122357`](source_parts/nswc_part_12.f90#L5968) |


Let y’(¢) = f(t,y(t)) denote a system of n ordinary first order nonstiff differential equations where f(t,y) = (fi(t,y),...,fn(t,y)) and y(t) = (yi(t), ...,yn(t)). Assume that y(to) is known. Then for a small real number A, the subroutine RK is available for computing y(to +h). RK employs the standard fourth-order Runge-Kutta procedure.

```fortran
CALL RK(N, T, H, A, F)
```

The argument F is the name of a user defined subroutine that bas the format: CALL F(t, Z) Z is an array of dimension n containing the values y(t), .. .Yn(t) for the :rgument t. F computes the derivatives y}(¢),...,y),(t) using y’(t) = f(t, y(¢)) and stores the results in Z, thereby destroying the original data in Z. F must be declared in the calling program to be of type EXTERNAL.

T is a variable having the value tg and A an array of dimension 3n or larger. It is assumed that A(i),...,A(n) contain the values yi(to), ...,yn(to). If A = 0 then RK computes the derivatives yi(to), -..,y),(to) and stores them in A(n + i), ...,A(2n). If h # 0 then it is assumed that the derivatives yj (to), ..., y/, (ty) have already been computed and stored in A(n + 1),...,A(2n). In this case, when RK is called, the values yi(to + h), ..-,yn(to + h) and derivatives yi(to +A), ... , yi (to +h) are computed and stored in A(1), ...,A(2n). Also T is reset to the value tg +A.

**Note.** The area 4(2n + 1}, ...,A(3n) serves as work space for the routine.

**Example.** Consider the equations

x'(t) = y(t)

y'(t) = —2(t) where z(0) = 0 and y(0) = 1. The following code may be used for solving these equations at the points .01,.02, ...,1.00, and storing the results in the arrays X and Y.

DIMENSION A(6), X(100), Y(100) EXTERNAL FUN

H = Ol

A(1) = 0.0 A(2) - 1.0 A(3) — 1.0 A(4) = 0.0

bO 101 1, 100 CALL RK(2,7T,H,A,FUN) tO YC) A(2)


<small>Original source: [View scanned PDF page 432](scans/page_0432.png)</small>

Here FUN may be defined by:

SUBROUTINE FUN(T,Z) DIMENSION 2(2)

X = Z(t)

Y = Z(2)

Z(1) = Y

z(2) = -X

RETURN

END

Note that the statements A(3) = 1.0 and A(4) = 0.0, which store the derivatives z/(0) and y'(0) in A(3) and A(4), can be replaced with CALL RK(2,T,0.0,A,FUN).

**Programmer.** A.H. Morris.


<small>Original source: [View scanned PDF page 433](scans/page_0433.png)</small>

<a id="topic-433-01"></a>
### Eighth-Order Runge-Kutta

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [`L122419`](source_parts/nswc_part_12.f90#L6030) |


Let y(t) = f(t,y(t)) denote a system of n ordinary first. order nonstiff differential

equations where f(t,y) = (fi(t,y),..-,fn(t,y)) and y(t) = (y(t), ...,yn(t)). Assume that y(to) is known. Then for a small real number A, the subroutine RK8 is available for

computing y(to + A). CALL RK8(n,T, h, Y, DY,WK, F)

The argument F is the name of a user defined subroutine that has the format: CALL F(t, Z) Z is an array of dimension n containing the values y;(t),...,yn(t) for the argument t. F computes the derivatives yi (t),...,y;,(t) using y’(t) = f(t, y(¢)) and stores the results in Z, thereby destroying the original data in Z. F must be declared in the calling program to be of type EXTERNAL.

T is a variable having the value tg, and Y and DY are arrays of dimension n. It is assumed that Y contains the values yi(to), ...,tn(to). If h = 0 then RK8 computes the derivatives yi(to), ...,y),(to) and stores them in DY. If kh 0 then it is assumed that the derivatives yi (to), ...,y!,(to) have already been computed and stored in DY. In this case, when RK& is called, the values yi(to + A), ...,yn(to + A) and derivatives yi(to+h),..., Yn (to +h) are computed and stored in ¥Y and DY, thereby destroying the original data in Y and DY. Also T is reset to the value to + A.

WK is an array of dimension 8n or larger that is used for a work space by the routine. Algorithm. The routine employs formulae (8-12) given on p. 34 of the reference.

**Remarks.** RK&8 is used in the same manner as the routine RK. RK8 takes more time and storage than RK, but may be mure accurate.

**Reference.** Shanks, E. B., “Solutions of Differential Equations by Evaluations of Functions,” Math. Comp. 26 (1966), pp. 21-38.

**Programmer.** A. IH. Morris.


<a id="category-434"></a>
## Partial Differential Equations

<small>Original source: [View scanned PDF page 434](scans/page_0434.png)</small>

<a id="topic-434-01"></a>
### Separable Second-Order Elliptic Equations On Rectangular Domains

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [`L122495`](source_parts/nswc_part_12.f90#L6106) |


Given a separable elliptic equation

a(r)Use + b(z)us + o(z)u + d(y)uyy + e(y)uy + f(y)u = gf, y)

on the rectangle a; < 2 < az,b1 < y < bg, where u is periodic in z or y, or u or its normal derivative du/On is given on each of the edges. For m,n > 1 let 2; = a, + (¢ — 1)A and Yj) = by + (9 — I)k where h = (a2 — a;)/(m — 1), k = (b2 — 61)/(n — 1), 4 = 1, os, M,and j=1,...,n. Then the subroutine SEPDE is available for computing u at the points (2,, y;).

CALL SEPDE(COFX,COFY,g,ITYPE,BVAL,IORD, ay, a2, m,b1,b2,n, U,ku,W, &,IND)

It is assumed that m > 7 and n > 6. U is an mxn matrix. The argument ku is the number of rows in the dimension statement for U in the calling program. When SEPDE is called, if the elliptic equation is solved then U(i,7) = u(ai,y;) for? = 1,...,m and J=l1,...,n

The input argument IOKD is the order of the approximation procedure to be used. IORD may have the values 2 or 4.

The argument COFX is the name of a user defined subroutine that has the format: CALL COFX(z, A, B,C) A, B, and C are variables. COFX sets A = a(x), B = b(z), and C = c(x) for the argument z. COFX must be declared in the calling program to be of type EXTERNAL.

The argument COFY is the name of a user defined subroutine that has the format: CALL COFY{y, D, FE, F) D, &, and F are variables. COFY sets D = d(y), E = e(y), and F = f(y) for the argument y. COFY must be declared in the calling program to be of type EXTERNAL.

The argument g is the name of a user defined function, where g(z,y) gives the right hand side of the elliptic equation for all ay < x < az,b; <y < by. The argument g must be declared in the calling program to be of type EXTERNAL.

Boundary Conditions. The edges of the rectangular domain are labeled in a clockwise manner as follows:

a edge I = { (x, 61) |ay <a <ayg } f ; edge 3~ { (z,b2)|a; <2 < az} te-] edge t= { (a2, y) |b) < y < by }

IPYPE is an array of dimension 4. For edge i (¢ = 1, ...,4), MVYPE(s) specifies the type cf boundary condition on the edge. FPYPE(s) must be set by the user to one of the following values:

ITYPE(s) O It is assumed that u is given on the edge

BTD


<small>Original source: [View scanned PDF page 435](scans/page_0435.png)</small>

```text
ITYPE(1) = 1 If t= 1 or ¢ = 3 then uy is given on the edge. Otherwise, if ¢ == 2
or t = 4 then u, is given on the edge.
ITYPE(s}=-1 If ¢ = i or i = 3 then it is assumed that u is periodic in y; ie.,
u(z, y+ b2 — by) = u(z,y) for all z,y. In this case ITYPE(*) must,
be —1 for both s = land« = 3. Ifi = 2 ort = 4 then it is assurned
that u is periodic in 2; ie., u(z+ a2 — a1,y) = u(z, y) for all z,y.
In this case ITYPE(1*) must be —1 for both ¢ = 2 andi = 4.
The argument BVAL is the name of a user defined function. BVAL(i, 2, y) is defined for
any point (z, y) on edge when ITYPE(t) = 0 or 1, where
```

u{z,y) if ITYPE(

```text
1) =0
uz(z,y) if ITYPE(*) = 1
```

```text
(¢ = Lort = 3)
(§ = 2ort = 4)
```

|

The function BVAL(t, x, y) is ignored when ITYPE(#) = —1. BVAL must be declared in the calling program to be of type EXTERNAL.

W is an array of dimension @ that is a work space. The argument £@ is a variable whose value depends on IORD, m,n, and the types of boundary conditions used. Let v be the largest integer < logy n and @; = (v ~— 1)2”t? + + 14m+12n+6. Then

@> bt, if IORD = 2.

é>é;+mn if IORD = 4.

When the routine terminates, @ will have been reset to the actual amount of storage needed.

IND is a variable that reports the status of the results. When SEPDE terminates, IND has one of the following values:

IND = 0 The solution U was obtained.

IND = —1 A constant (which is stored in W(1)) was subtracted from the right hand side of the equation in order to obtain a solution U. The solution is a weighted minimal least squares solution of the original problem.

```text
IND = 1 (Input error) a, > ag or 6; > b9.
IND = 2 (Input error) ITYPE(#) 4 0,-+1 for some edge 1.
IND = 4 The approximating linear system of equations is not diagonally
```

dominant, This cannot occur when m and n are sufficiently large. Increase m and n, and reset @.

IND = 5 (Input error) ku < m.

INI = 6 (Input error) m < 7.

IND = 7 (Input error) n < 6.

IND = 8 (Input error) IORD ¥ 2,4.

IND = 10 (Input error) a(x)d(y) < O for some interior point (z, y) of the rectangle. This violates the assumption that the equation in elliptic.

IND = 11 (Input error) @ was too small. @ has been reset to the minimum

amount of storage needed for W.


<small>Original source: [View scanned PDF page 436](scans/page_0436.png)</small>

IND = 12 (Input error) ITYPE(%) = —1 for edge 1 or 3, but not for both edges.

IND = 13 (Input error) ITYPE(1) = —i for edge 2 or 4, but not for both edges.

```text
Precision. If IORD = 2 then the elliptic equation is approximated by a set of linear equa-
tions using finite differences. Otherwise, if IORD = 4 then the approximating equations
are obtained by deferred corrections. The most accuracy is achieved when ITYPE(#) = 1
boundary conditions are not involved. For m,n > 100, 3-4 digit accuracy may be attained
when IORD = 2 and 7-8 digit accuracy when IORD = 4. When ITYPE(s) = | boundary
conditions are used, then for m,s > 100, 2-3 digits may he attained when IORD = 2 and
5-6 digits when IORD = 4.
```

**Programming.** SEPDE is an interface by A. H. Morris for SEPELL, a modification of the routine SEPELI described in the reference. SEPELI was developed by John C. Adams, being supported (in part) by codes written by Paul Swarztrauber and Roland Sweet {National Center for Atmospheric Research, Boulder, Colorado). SEPDE employs the subroutines PDEDGE, SEPELL, SEPEL1, CHKPRM, CHKSNG, ORTHG, MINSOL, TRISP, DEFER, DXFN, DYFN, BLKTRI, BLKTR1, COMPB, PRODO, PRODP, CPRODO, CPRODP, IN- DXA, INDXB, INDKC, PPADD, TQLRTO and functions PSGF, BSRH, PPSGF, PPSPF, SPMPFAR. The routines exchange information in the labeled common blocks having block names CBLKT and SPLP.

**Example.** Consider (1+2)?u,.~2(t+z)u,+uyy = 3(1+2)‘siny forO < 2 < Land |y| <7

```text
where u,(O,y)=4siny ly| <a
u(1,y) = 16siny
```

and u is periodic in y. This problem has the solution u =: (1+ z)*siny. Let

```text
ITYPE(1) = 1
ITYPE(2)= 1
ITYPE(3) = ~1
ITYPE(4) = 0
```

Then the following routines and functions may be used for describing the problem. (Here g ~ GVAL.)

SUBROUTINE COFX (X,A,B,C)

T-10+X As Tek Boe. --2.0«T C = 0.0 RETURN END

SUBROUTINE COFY (Y,D,E,E)


<small>Original source: [View scanned PDF page 437](scans/page_0437.png)</small>

D=1.0 E=00 F =0.0 RETURN END

REAL FUNCTION GVAL (X,Y) GVAL = 3.0#(1.0 + X)« * 4*SIN(Y) RETURN

END

REAL FUNCTION BVAL ({I,X,Y) BVAL = 4.0«SIN(Y)

IF (I .EQ. 4)BVAL = 4.0#BVAL RETURN

END

COFX, COFY, GVAL, and BVAL must be declared in the calling program to be of type EXTERNAL.

**Reference.** Adams, J., Swarztrauber, P., and Sweet, R., FISHPAK: Efficient FORTRAN Subprograms for the Solution of Separable Elliptic Partial Differential Equations, Version 3. National Center for Atmospheric Research, Boulder, Colorado, 1978.


<a id="category-438"></a>
## Discrete Random Number Generation

<small>Original source: [View scanned PDF page 438](scans/page_0438.png)</small>

<a id="topic-438-01"></a>
### Uniform Random Selection of Values from a Finite Set of Integers

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [`L125737`](source_parts/nswc_part_12.f90#L9348) |


Given the integers $i_a$ and $i_b$ where $i_a < i_b$. Then the following subroutine is available for selecting integers $i$ where $i_a \leq i \leq i_b$. The selection is performed so that any integer $i$ is equally likely to occur with probability $1/m$ where $m = i_b - i_a + 1$. Any integer $i$ may be selected more than once. When the number of selected values becomes large, the mean and variance of the values approximate the mean and variance of the discrete uniform distribution where

mean = $i_a + (i_b - i_a)/2$

variance = $(m^2 - 1)/12$.

```fortran
CALL URGET(N, IBEG, IEND, IX, L, IERR)
```

The argument n is the number of values to be selected, L is an array of dimension n or larger, and ix and IERR are variables. On input, ix is an integer (called a seed) for initializing the sequence of values. It is assumed that $1 \leq ix < 2^{31} - 1$. When URGET is called, if no input errors are detected then IERR is set to 0 and n values are stored in L. On output, ix is a new seed for selecting more values.

**Error Return.** IERR = 1 if $n \leq 0$, IERR = 2 if $i_a \geq i_b$ or $m \geq 2^{31} - 1$, and IERR = 3 if ix is not a proper seed.

Usage. A given seed always initiates the same sequence of values. Thus, the following two sets of instructions

(1) `IX = 7` followed by `CALL URGET(30,0,1,IX,L,IERR)`.

(2) `IX = 7` followed by `CALL URGET(20,0,1,IX,L,IERR)` and `CALL URGET(10,0,1,IX,L(21),IERR)`.



generate the same 30 values (0 and 1).

**Remarks.**

(1) The n values selected need be distinct only when $m = 2^{31} - 2$ and $n = m$.

(2) It is assumed that the integer arithmetic being used handles all integers i in the interval $|i| \leq 2^{31} - 1$.

**Programming.** Originally formulated by John R. Crigler. Written by A. H. Morris.




<a id="category-439"></a>
## Continuous Random Number Generation

<small>Original source: [View scanned PDF page 439](scans/page_0439.png)</small>

<a id="topic-439-01"></a>
### Uniform Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URNG` | `SUBROUTINE` | `IX, X, N, IERR` | [`L125842`](source_parts/nswc_part_12.f90#L9453) |
| `DURNG` | `SUBROUTINE` | `IX, X, N, IERR` | [`L125924`](source_parts/nswc_part_12.f90#L9535) |


The following subroutines are ‘available for generating a sequence of uniform variates in the open interval (0, 1).

```fortran
CALL URNG(IX, X, N, IERR)
CALL DURNG(IX, X, N, IERR)
```

A is an array of dimension n or larger where n > 1. URNG is used if A is a real array and DURNG is used if A is a double precision array.

The argument n is the number of variates to be generated, and tz and IERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < ix < 234-1. When URNG or DURNG is called, if no input errors are detected then JERR is set to 0 and n uniform variates are stored in A. On output, tz is a new seed for generating mere variates.

**Error Return.** IERR = 1 if n < 0 and IERR = 2 if tz is not a proper seed.

Usage. A given seed always initiates the same set. of variates. Thus, the following two sets of instructions

(1) IX = 103 CALL URNG(IX,A,30,JERR)

(2) IX =: 103 CALL URNG(IX,A,20,JERR) CALL URNG(IX,A(21),10,IERR)

generate the same 30 variates.

**Remark.** {t is assumed that the integer arithmetic being used handles ali integers ¢ in the interval |s| < 2°) — 4,

**Programming.** Written by Linus Schrage (University of Chicago). Adapted by A.H. Morris.

**Reference.** Schrage, Linus,“A More Portable Fortran Random Number Generator,” ACM Trans. Math Software 5 (1979), pp. 132-138.


<small>Original source: [View scanned PDF page 440](scans/page_0440.png)</small>

<a id="topic-440-01"></a>
### Generating Points Uniformly in a Square

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [`L126301`](source_parts/nswc_part_12.f90#L9912) |
| `DURNG2` | `SUBROUTINE` | `IX, X, Y, N, IERR` | [`L126369`](source_parts/nswc_part_12.f90#L9980) |


The following subroutines are available for generating points (71,91), ..-,{2n, Yn) uniformly where 0 -< 2, < l and 0 < y, < 1 for each ¢.

```fortran
CALL URNG2(IX, X, Y, N, IERR)
CALL DURNG2(IX, X, Y, N, IERR)
```

and Y are arrays of dimension n or larger where n > 1. URNG2 is used if X and Y are real arrays, and DURNG2 is used if X and Y are double precision arrays.

The argument n is the number of points to be generated, and tz and JERR are variables. On input, tt is an integer (called a seed) for initializing the sequence of points. It is assumed shat 1 < te < 49! —1. When URNGZ or DURNG2 is called, if no input errors are detected then [ERR is set to 0 and n points are generated. The abscissas 2,,...,2,, of the points are stored in X and tie ordinates y,,...,y, are stored in Y. On output, tz is a new seed for generating more points,

**Error Return.** JERR = 1 ifn < G and IERR = 2 if ¢2 is not a proper seed.

Usage. A given seed always initiates the same set of points. Thus, the following two sets of instructions

(1) X= 4 CALL URNC 2 ‘IX,X,Y,30,IERR)

(2) IX = 4

```fortran
CALL URNG2(IX, X, Y, N, IERR)
CALL URNG2(IX, X, Y, N, IERR)
```

generate the same 30 points.

**Remark.** It is assumed that the integer arithmetic being used handles all integers t in the interval is| < 23) ~ 1,

**Programming.** Written by Linus Schrage (University of Chicago). Adapted by A.H. Morris.

**Reference.** Schrage, Linus,“A More Portable Fortran Random Number Generator,” ACM Trans. Math Software 5 (1979), pp. 132-138.


<small>Original source: [View scanned PDF page 441](scans/page_0441.png)</small>

<a id="topic-441-01"></a>
### Generating Points Uniformly In A Circle

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [`L126437`](source_parts/nswc_part_12.f90#L10048) |
| `DRCIR` | `SUBROUTINE` | `N, IX, X, Y, IERR` | [`L126553`](source_parts/nswc_part_12.f90#L10164) |


The following subroutines are available for generating points (21,91), ...,(2n, Yn) uniformly where z? + y? <1 for each ¢.

```fortran
CALL RCIR(N, IX, X, Y, IERR)
CALL DRCIR(N, IX, X, Y, IERR)
```

X and ¥ are arrays of dimension n oy larger Where i > i. RCOUR (3 used if X and Y are real arrays, and DRCIR is used \f X and Y are double precision arrays.

The argument n is the number of points to be generated, ad tz and IERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of points. It is assumed that 1 < tz < 2%! -- 1. When RCIR or DRCIR is called, if no input errors are detected then IERR is set to 0 and n points are generated. The abscissas 21, ...,2, of the points are stored in X and the ordinates y,, ...,¥, are stored in Y. On output, ix is a new seed for generating more points.

Error Return. [ERR = 1 ifm < 0 and IERR = 2 if fz is not a proper seed.

Usage. A given seed always initiates the same set of points. Thus, the following two sets of instructions

(1) IX=7 CALL RCIR(30,IX,X,Y,IERR)

(Q 1X7 CALL RCIR(20,1X,X,¥ ERR) CALL RCIR(10,IX,X(21),Y (21) JERR)

generate the same 30 points.

```text
Remarks.
(1) RCIR and DRCIR never generate the point (3,0)
(2) It is assumed that the uteger arithmetic being used handles all ictegers ¢ in the interval
```

li] < 2381,

Algorithm Points are generated uniformly in the square {(r,y) : Ja! < Land yf <b}. The procedure terminates when n points have been obtained which he in the unit circle

**Programming.** RCL? calls the subroutine RCIRG, and DRCIR cells the subroutine DI CIR. These routines were written by A. TE Morris,


<small>Original source: [View scanned PDF page 442](scans/page_0442.png)</small>

<a id="topic-442-01"></a>
### Normal Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [`L126669`](source_parts/nswc_part_12.f90#L10280) |
| `DRNOR` | `SUBROUTINE` | `IX, A, N, IERR` | [`L126730`](source_parts/nswc_part_12.f90#L10341) |
| `NRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [`L126791`](source_parts/nswc_part_12.f90#L10402) |
| `DNRNG` | `SUBROUTINE` | `IX, A, N, IERR` | [`L126831`](source_parts/nswc_part_12.f90#L10442) |


Consider the normal distribution having the distribution function

Fc) = Ss [ ent 2 at ( } J2n J ~00

for all real x. This distribution has mean 0 and standard deviation 1. The following subroutines are available for generating normal variates from this distribution.

```fortran
CALL RNOR(IX, A, N, IERR)
CALL DRNOR(IX, A, N, IERR)
```

A is an array of dimension n or la:ger where n > 1. A is a real array if RNOR is used, and A is a double precision array if DRNOR is used.

The argument n is the number of variates to be generated, and tz and JERR are variables. On input, ¢z is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 <ta2 < 23! --1. When RNOR or DRNOR is called, if no input errors are detected then IERR is set to 0 and n variates are stored in A. On output, tz is a new seed for generating more variates.

**Error Return.** TERR = 1 ifm <0 and IERR = 2 if tz is not a proper seed. Algorithm, The polar algorithm is used.

Usage. Normal variates are generated in pairs. If n is odd then the last variate cy+,; generated is net stored. Also, a given seed always initiates the same sequence of variates. Thus, if we consider the following three sets of instructions

(1) IX =5 CALL RNOR(!X,A,30,]ERR)

```fortran
CALL RNOR(IX, A, N, IERR)
CALL RNOR(IX, A, N, IERR)
```

(3) [Xx ox 5 CALL RNOR(IX,A,9, JERR) CALL RNOR(IX,A(10),29 JERR)

thea we note that (1) and (2) generate the same 30 normal variates. Also (3) generates 29 of these $0 variates, skipping the £0"? variate, The reason for this is that. .¢ request in (2) for 9 variates requires LO variates to be generated, only J of winel: are used.


<small>Original source: [View scanned PDF page 443](scans/page_0443.png)</small>

**Remarks.**

(1) If ay,...,@, ere variates from RNOR and v,; = ro + oa; fort = 1,...,n ando > 0, then vj, ...,0, are variates from a normal distribution with mean x9 and standard deviation «.

(2) It is assumed that the integer arithmetic being used handles all integers in the interval ye oy3t

**Programming.** RNOR calls the subroutine RCIR1, and DRNOR calls the subroutine DRCIR1. These routines are written by A. H. Morris.

**Reference.** Marsaglia, G. and Bray, T.A.,“A Convenient Method for Generating Normal Variables,” SIAM Review 6 (1964), pp. 260-264.

```fortran
CALL NRNG(IX, A, N, IERR)
CALL DNRNG(IX, A, N, IERR)
```

A is an array of dimension n or larger where n > 1. A is a real array if NRNG is used and .4 is a double precision array if DNRKNG is used.

The argument n is the number of variates to be generated, and tz and TERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < tz < 23! —1. When NPNG or DNRNG is called, if no input errors are detected then IERR is set to 0 and n variates are stared in A. On output, tz is a new seed for generating more variates.

Error Return, TERR = 1 ifn < C and IERR = 2 if tz is nct a proper seed. Algorithm. The Box-Muller algorithm is used.

Usage. Normal variates are generated in pairs. The usage of NRNG and DNRNG is identical to the usage of RNOR and DRNOR.

**Remarks.**

({) NRNG and DNRNG require 15-25% more time than RNOR and DRNOR.

(2) [tis assumed that the integer arithmetic being used handles all integers ¢ in the interval Ni cn

**Programming.** NRNG calls the subroutine URNG, and DNRNG calls the subroutine DURNG. NRNG aad DMIRNG were written by A. H. Morris,

**Reference.** Box, G.ELP. and Muller, M-E.,“A Note on the Generation of Random Normal Deviates,” Annale of Math Statistics 29 (1950), pp. 610-611.


<small>Original source: [View scanned PDF page 444](scans/page_0444.png)</small>

<a id="topic-444-01"></a>
### Multivariate Normal Random Vector Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `NRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L126872`](source_parts/nswc_part_12.f90#L10483) |
| `NRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L127026`](source_parts/nswc_part_13.f90#L1) |
| `DNRVG` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L127144`](source_parts/nswc_part_13.f90#L119) |
| `DNRVG1` | `SUBROUTINE` | `MO, IX, N, M, A, FMU, X, KX, IERR` | [`L127298`](source_parts/nswc_part_13.f90#L273) |


Let A be a real symmetric positive definite matrix of order m, det(A) be the determinant of A (which must be positive), and pp = (#41,.-.,fm). Consider the multivariate normal distribution having the density function

1 -1L/2{a—p)A~*(z~p)* f(2) = —— eee /2(n—p) AW *(z~p)

J (2x) ™det(A)

for z = (21,...,2m) where all z; are real. This distribution has the covariance matrix A and mean vector yp. The subroutines NRVG and DNRVG are available for generating variates z from this distribution when A is an arbitrary positive definite matrix. If A is a diagonal matrix then the subroutines NRVG1 and DNRVGiI are also available for generating variates from the distribution.

```fortran
CALL NRVG(MO, IX, N, M, A, FMU, X, KX, IERR)
CALL DNRVG(MO, IX, N, M, A, FMU, X, KX, IERR)
```

It is assumed that m > 2. A is an array of dimension m(m +- 1)/2 or larger containing the positive definite matrix A in packed form,’ and p is an array of length m containing the mean vector of the distribution.

The argument. n is the number of vectors to be generated, and X is a 2-dimensional array of dimension kr x n. It is assumed that kr > m.

N&VG is used if A, 4, and X are real arrays, and DNRVG is used if A, zp, and X are double precision arrays.

MO is an argument which specifies if NRVG or DNRVG is being called for the first time, On an initial call, MO = 0 and we have the following setup:

The arguments tz and IERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of vectors. It is assumed that 1 < tz < 294 - 1. When NRVG or DNRVG is called, if no input errors are detected then TERR is set to 0 and n vectors x are stored in X. The j'” vector is stored in the 7** column of X. On output, tz is a new seed for generating more vectors.

```text
Error Return. IERR = Lifn <0, IERR = 2ifm < lorm> kz, LERR = 3 if Ais not a
positive definite matrix, and IFRR = 4 if tz is not a proper seed.
```

On an initial call to NRVG or DNRVG, the lower triangular matrix in the Cholesky decomposition of A replaces the original data in A. If IMRR -= 0 then the routine may be recalled with MO + 0 to generate more vectors. If MO / O then it is assumed that A and on have not been modified by the user. However, n, uw, X, and ka may be different.

‘See the section on packed symmetric matrices and the subroutines MICVES, MOVSF, DMCVEBS, and DMCOVSF.


<small>Original source: [View scanned PDF page 445](scans/page_0445.png)</small>

The routine employs the lower triangular matrix obtained on the initial call to NRVG or DNRVG to generate n new vectors. As before, if no input errors are detected then IERR is set to 0 and the new vectors are stored in X.

Usage. A given seed always initiates the same set of vectors. Thus, the following two sets of instructions

(1) IX =3 CALL NRVG (0,IX,30,M,A,X0,X,KX,IERR) IF (IERR .NE. 0) STOP

(2) IX =3 CALL NRVG (0,IX,20,M,A,X0,X,KX,IERR) IF (IERR .NE. 0) STOP CALL NRVG (1,IX,10,M,A,X0,X(1,21),KX,IERR)

generate the same 30 vectors.

**Remark.** It is assumed that the integer arithmetic being used handles all integers 1 in the interval |#] < 25! — 1.

**Algorithm.** The lower triangular matrix D in the Cholesky decomposition of A is computed, and n vectors z = (21, ...,2m) are generated where the values z; are independent variates from the normal distribution with mean O and variance 1. The n variates x = Lz+ yp of the multivariate normal distribution are then computed.

Programming. NRVG employs the subroutines RNOR, RCIR1, SPPFA, and function SDOT, aad DNRVG employs the subroutines DRNOR, DRCIR1, DPPEFA, and function DDOT. NRVG and DNRVG were written by A. H. Morris.

**Reference.** Anderson, T.W., An Introduction to Multivariate Statistical Analysts, John Wiley and Sons, New York, 1958, pp. 5-27.

```fortran
CALL NRVG1(MO, IX, N, M, A, FMU, X, KX, IERR)
CALL DNRVG1(MO, IX, N, M, A, FMU, X, KX, IERR)
```

It is assumed that m > 2, and that A is a diagonal matrix whose diagonal elements are positive numbers. A is an array of dimension m or larger containing the diagonal elements. and y is an array of dimension m containing the mean vector of the distribution.

The argument n is the number of vectors to be generated, and X is a 2-dimensional array of dimension kz X n. It is assumed that kx > m.

NRVGI 1s used if A, wy and X are real arrays, and DNRVG1 is used if A, yz, and X are double precision arrays.

MO is an argument which specifies if NRVGI or DNRVGLI is being called for the first


<small>Original source: [View scanned PDF page 446](scans/page_0446.png)</small>

time. On an initial call, MO = 0 and we have the following setup:

The argument tz and IERR are variables. On input, ta is an integer (called a seed) for initializing the sequence of vectors. It is assumed that 1 < tz < 284 — 1. When NRVG1 or DNRVG1 is called, if no input errors are detected then IERR is set to 0 and n vectors z are stored in X. The j*® vector is stored in the j** column of X. On output, iz is a new seed for generating more vectors.

```text
Error Return. IERR = 1 ifn < 0, JERR = 2 ifm < Lorm> kz, IERR = 3 if A(t) < 0 for
some 1, and IERR = 4 if fz is not a proper seed.
```

On an initial call to NRVGI or DNRVGI1, the square roots of the diagonal elements of the matrix are stored in A. If IERR = 0 then the routine may be recalled with MO # 0 to generate more vectors. If MO # 0 then it is assumed that A and m have not been modified by the user. However, n, », X, and kx may be different. The routine employs the roots obtained on the initial call to NRVG1 or DNRVGI to generate n new vectors. As before, if no input errors are detected then IERR is set to 0 and the new vectors are stored in X.

Usage. The usage of NRVGi and DNRVG1 is identical to the usage of NRVG and DNRVG.

**Remarks.**

```text
(1) NRVG and NRVG1 generate the same vectors when A is a diagonal matrix.
(2) It is assumed that the integer arithmetic being used handles all integers ¢ in the interval
js] < 272-1.
```

**Programming.** NRVG1 employs the subroutines RNOR and RCIR1, and DNRVG: employs the subroutines DRNOR and DRCIR1. NRVG1 and DNRVGI were written by A. H. Morris.


<small>Original source: [View scanned PDF page 447](scans/page_0447.png)</small>

<a id="topic-447-01"></a>
### Exponential Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RANEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [`L127416`](source_parts/nswc_part_13.f90#L391) |
| `DRNEXP` | `SUBROUTINE` | `N, A, ISEED, X, IERROR` | [`L127511`](source_parts/nswc_part_13.f90#L486) |


For a > O consider the exponential distribution having the distribution function

; 1 f* F(z) = al e/4 dt =1—e7*/* (x >0). 0

a,

This distribution has the mean a and variance a?. The following subroutines are available for generating variates from this distribution.

```fortran
CALL RANEXP(N, A, ISEED, X, IERROR)
CALL DRNEXP(N, A, ISEED, X, IERROR)
```

X is an array of dimension n or larger where n > 1. The argument a is a real number and X a real array if RANEXP is used. Otherwise, a is a double precision number and X a double precision array if DRNEXP is used.

The argument n is the number of variates to be generated, and tz and IERR are variables. On input, iz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < tz < 23} —1. When RANEXP or DRNEXP is called, if no input errors are detected then IERR is set to 0 and n exponential variates are stored in X. On output, iz is a new seed for generating more variates.

Error Return, [ERR = 1 ifn < 0, IERR = 2 if a < 0, and IERR = 3 if rr is not a proper seed.

Usage. A given seed always initiates the same set of variates. Thus, the following two sets of instructions

(1) IX =3 CALL RANEXP(30,A,IX,X,IERR)

(2) IX =3 CALL RANEXP(20,A,IX,X,IERR) CALL RANEXP(10,A,[X,X(21),IERR)

generate the same 30 variates.

**Remark.** If is assumed that the integer arithmetic being used handles all integers + in the

interval |¢| < 2°) - 1.

**Programming.** RANEXP calls the subroutine URNu, and DRNEXP calls the subroutine DURNG. RANEXP and DRNEXP were written by John R. Crigler. RANEXP has been obtained from the STATLIB library.


<small>Original source: [View scanned PDF page 448](scans/page_0448.png)</small>

**Reference.** Thomas, M.A., Gemmill,G.W., and Crigler,J.R., STATLIB: NSWC Library of Statistical Programs and Subroutines, Report NSWC TR. 89-97, Naval Surface Warfare Center, Dahlgren, Va., 1985.


<small>Original source: [View scanned PDF page 449](scans/page_0449.png)</small>

<a id="topic-449-01"></a>
### Gamma Random Number Generator And The Chi-Square Distribution

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [`L127606`](source_parts/nswc_part_13.f90#L581) |
| `DRGAM` | `SUBROUTINE` | `IX, A, N, X, IERR` | [`L127685`](source_parts/nswc_part_13.f90#L660) |


For a > 0 consider the gamma distribution having the distribution function

/ gn tyort dt (2 > 0),

P(a,c) = =~ ra) Jo

and for v > O consider the chi-square distribution having the distribution function

cee en re = ~ vpe ‘ 6 > O). BG) = Tay [e wg (x >9) Then F,(r) = P(v/2,2/2), so that only the gamma distribution need be computed. The following subroutines are available for generating variates from the gamma distribution when a > 107}.

```fortran
CALL RGAM(IX, A, N, X, IERR)
CALL DRGAM(IX, A, N, X, IERR)
```

X is an array of dimension nv or larger where n > 1. The argument a is a real number and .X a real array if RGAM is used. Otherwise, a is a double precision number and X a double precision array if DRGAM is used.

It is assumed that a > 0.1 and that n is the number of variates to be generated. IERR and tz are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. it is assumed that 1 <i tz < 23! —~ 1. When RGAM or DRGAM is called, if no input errors are detected then JERR is set. to 0 and n gamma variates are stored in X. On output, iz 1s a new seed for generating more variates.

**Error Return.** ORR = Lifn <0, TERR == 2ifa < 0.1, and IERR = 3 if tz is not a proper seed.

Usage. A given seed always initiates the same set. of variates. Thus, the following two sets

of instructions

(1) IX =3 CALL RGAM(IX,A,30, X,IERR)

(2) IX 3

```fortran
CALL RGAM(IX, A, N, X, IERR)
CALL RGAM(IX, A, N, X, IERR)
```

OOS


<small>Original source: [View scanned PDF page 450](scans/page_0450.png)</small>

generate the same 30 variates.

**Warning.** The double precision subroutine DRGAM can be quite slow. It is recommended that its speed be checked if thousands of variates are to be generated.

**Remarks.**

(1) Ifa = v/2 and x,,...,2, are variates for the gamma distribution given by P(a, x) then 221, ...,2%, are variates for the chi-square distribution given by F,(z).

(2) It is assumed that the integer arithmetic being used handles all integers ¢ in the interval jij < 234-1.

**Programming.** RGAM calls the subroutines URNGO and GAMINV, and DRGAM calls the subroutines DURNGO and DGINV. RGAM and DRGAM were written by A. H. Morris.

SOG


<small>Original source: [View scanned PDF page 451](scans/page_0451.png)</small>

<a id="topic-451-01"></a>
### Beta Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L127763`](source_parts/nswc_part_13.f90#L738) |
| `DRBETA` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L127874`](source_parts/nswc_part_13.f90#L849) |


For a,6 > 0 consider the beta distribution having the distribution function

_ 1 * a-l _ pyo-l 1.(0,8) = aay ft (—t)d (0<2<)),

where B(a,b) is the beta function. The following subroutines are available for generating variates from this distribution when a, 6 > 1/4

```fortran
CALL RBETA(N, A, B, IX, X, IERR)
CALL DRBETA(N, A, B, IX, X, IERR)
```

X is an array of dimension n or larger where n > 1. The arguments a and 8 are real numbers and X a real array if RBETA is «sed. Otherwise, a and 6 are double precision numbers and X a double precision array if ORBETA is used.

It is assumed that a,b > 1/4 and that n is the number of variates to be generated. TERR and tz are variables. On input, 1z is an integer (called a seed) for initializing the sequence of variates. It is assumed that } < ix < 23! — 1. When RBETA or DRBETA is called, if no input, errors are detected then IEF.R is set to O and n beta variates are stored in X. On output, tz is a new seed for generating more variates.

**Error Return.** IERR = 1 ifn < 0, IERK = 2 if a < 1/4 or 6 < 1/4, and IERR = 3 if tz is not a4 proper seed.

Usage. A given seed always initia‘es the same set of variates. Thus, the following two sets of instructions

(1) IX=7 CALL RBETA (30, A, B, EX, X, IERR)

(2) IX =7 CALL RBETA (20, A, B, EX, X, IERR) CALL RBETA (10, A, B, 1X, X(21), IERR)

generate the same 30 variates.

Warning, ‘The double precision subroutine ORBITA can be quite slow. It is recommended that its speed be checked if thousands of variates are to be generated,

**Remark.** [It is assumed that the integer arithmetic being used handles all integers ¢ in the

interval |e} = 294g. Programming. RBE’PA calls the subroutines OR NGO and GAMINY, and DRBR’PA calls

the subroutines DURNGO and DGINV. RBEPA and DRBE'PTA were written by Ao H. Morris.

O47


<small>Original source: [View scanned PDF page 452](scans/page_0452.png)</small>

<a id="topic-452-01"></a>
### F-Distribution Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `FRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L127985`](source_parts/nswc_part_13.f90#L960) |
| `DFRAN` | `SUBROUTINE` | `N, A, B, IX, X, IERR` | [`L128110`](source_parts/nswc_part_13.f90#L1085) |


For a,5 > 0 consider the F-distribution having the distribution function

a2/25b/2

Pol) = Ba], ]3)

F | t{2/2)-1(b 4. gt)—(9+8)/2 gt = (F > 0) Jo where B(a/2,6/2) is the beta function. The values a and 6 are called the numerator and denominator degrees of freedom of this distribution. The value F == (bs)/(at) is a variate from this distribution when s and t are independent variates from the gamma distributions with parameters a/2 and 6/2 respectively. The following subroutines are available for generating variates from the F-distribution when a,b > 1/2.

```fortran
CALL FRAN(N, A, B, IX, X, IERR)
CALL DFRAN(N, A, B, IX, X, IERR)
```

X is an array of dimension n or larger where n > 1. The arguments a and 6 are real numbers and X a real array if FRAN is used. Otherwise, a and 6 are double precision numbers and X a double precision array if DFRAN is used.

It is assumed that a,b - 1/2 and that n is the number of variates to be generated. TERR and tz are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < #2 < 23! ~ 1. When FRAN or DFRAN is called, if no input errors ace detected then IEKR is set to 0 and n variates are stored in X.

On output, tz is a new seed for generating more variates,

**Error Return.** TERR ~ 1 ifn < 0, IERR = 2 ifa < 1/2 or 6 < 1/2, IERR = 3 if 6 is too small for the floating arithmetic being used, and IERR = 4 if tx is not a proper seed. IFRR -- 3 can occur only if the floating arithmetic has a exceedingly limited range (say, its largest value is less than (07),

Usage. A given seed always initiates the same set of variates. Thus, the following two sets y , 8g

of instructions

(1) IX 3 CALL FRAN (30, A, B, IN, X, FERRER)

(2) 1X 3

```fortran
CALL FRAN(N, A, B, IX, X, IERR)
CALL FRAN(N, A, B, IX, X, IERR)
```

generate the same SO variates

Warning The double precision subroutine OPRAN can be quite stow. PO ds recommended

that its speed he cheeSed df thousands of variates are to be generated


<small>Original source: [View scanned PDF page 453](scans/page_0453.png)</small>

**Remark.** It is assumed that the integer arithmetic being used handles all integers 7 in the interval |#| < 2°! -- 1.

**Programming.** FRAN calls the subroutines URNGO and GAMINV, and DF RAN calls the subroutines DURNGO and GINYV. FRAN ang DFRAN were w- iter by A. H. Morris.


<small>Original source: [View scanned PDF page 454](scans/page_0454.png)</small>

<a id="topic-454-01"></a>
### Student T-Distribution Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [`L128236`](source_parts/nswc_part_13.f90#L1211) |
| `DTRAN` | `SUBROUTINE` | `N, A, IX, X, IERR` | [`L128355`](source_parts/nswc_part_13.f90#L1330) |


For a > 0 consider the student t-distribution having the distribution function t

where B(1/2,a/2) is the beta function. he value t = z/\/w/a is a variate from this distribution when z is a variate from the normal distribution with mean O and variance 1, and w is an independent variate from the chi-square distribution with a degrees of freedom. The following subroutines are available for generating variates from the student t-distribution when a > 1/2.

```fortran
CALL TRAN(N, A, IX, X, IERR)
CALL DTRAN(N, A, IX, X, IERR)
```

X is an array of dimension n or larger where n > 1. The argument a is a real number and X a real array if TRAN is used. Otherwise, a is a double precision number and X a double precision array if DTRAN is used.

It is assumed that a > 1/2 and that n is the number of variates to be generated. IERR and ¢z are variables. On input, tz is an integer (called a seed) for initializing the sequence of variates. It is assumed that 1 < ¢z < 29! -- 1. \/hen TRAN or DTRAN is called, if no input errors are detected then IERR is set to 0 and n variates are stored in X. On output, tz is a new seed for generating more variates.

**Error Return.** IERR = 1 if n < 0, IERR = 2 ifa < 1/2, IERR = 3 if u is too small for the floating arithmetic being used, and IERR = 4 if tz is not a proper seed. IERR = 3 can occur only if the floating arithmetic has a exceedingly limited range (say, its smallest positive value is greater than 107°”),

Usage A given seed always initiates the same set of variates. Thus, the following two sets of instructions

(1) IX =3 CALL TRAN (30, A, EX, X, HERR)

(2) IX = 3

```fortran
CALL TRAN(N, A, IX, X, IERR)
CALL TRAN(N, A, IX, X, IERR)
```

generate the same 30 variates,

**Warning.** The double precision subroutine DT RAN can be quite slow. It is recommended that its speed be checked if thousands of variates are to be generated


<small>Original source: [View scanned PDF page 455](scans/page_0455.png)</small>

**Remark.** It is assumed that the integer arithmetic being used handles all integers ¢ in the

interval |s! «¢ 23) — 1.

**Programming.** TRAN calls the subroutines URNGO, URNG1, PNI, and GAMINV, and DTRAN calls the routines DURNGO, DURNGI, DPNI, and DGINV. TRAN and DTRAN

were written by A. H. Morris.


<small>Original source: [View scanned PDF page 456](scans/page_0456.png)</small>

<a id="topic-456-01"></a>
### First Order Markov Random Number Generator

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [`L128474`](source_parts/nswc_part_13.f90#L1449) |
| `DRMK1` | `SUBROUTINE` | `N, FMU, SIG, ALPHA, ISEED, X, IERROR` | [`L128602`](source_parts/nswc_part_13.f90#L1577) |


Given a sequence of independent variates z1,...,2n (mn > 2) from a norma! distribution with mean O and standard deviation o > 0. For any real to and fee] < 1 ict

(+)

ay == Ko -f @(ay-.1 — 20) + 2; (j = 2, ...,n).

Then aj,...,@, are variates from a normal distribution with mean rg and variances 9? /{ 1 — as. Since zi, ...,2, are independent variates, a; (j > 2) is considered to depend only on a;—1 for information from the past. Hence, a), ...,¢, forms a first order Markov ‘Le, first order autoregressive) process. Since the process is covariance stationary, the correlation

between terms a; and a, of the sequence becomes progressively weaker when |k— | increases.

For any %9,0,a, and n the following subroutines are available tor obtaining sequences 41, . ,@, of variates from (*).

```fortran
CALL RMKi(n, 20,0, a,12,.4, TERR)
CALL DRMK1(N, FMU, SIG, ALPHA, ISEED, X, IERROR)
```

The arguments 29,0, and @ are real numbers and A a real arr » if RMK1 ic used. Otherwise, 29,0, and @ are double precision numbers and A a double precision array when DRMK1 is used.

A is an array of dimension n or larger when n > 2, and t7 and TERR are variables. It is assumed that o > 0 and |a| < 1. On input, ¢¢ is an integer (called a seed) for initializing the sequence of variates z1,...,Z,. It is assumed that fk < fz < 23) — 4. When RMK1 or DRMK1 is called, if no input errors are detected then IERR is set to 0 and a sequence ay, ..-,@, is obtained and stored in A. On output, tz is a new seed for generating other sequences dy, ...,4n.-

```text
Error Return. TERR is set tc one of the following values if an input error is detected.
IERR =: 1 ifn < 2
[ERR = 2 ife <0
IERR = 2 if ja] > 1
JERR = 4 if ¢z is not a proper see.
```

**Remark.** It is assumed that the integer arithmetic being used handles all integers yin the interval |i] < 23t — y.

**Programming.** RMK1 employs the subroutines RNOR and ROERT, and DRME: employs the subroutines DRNOR and DRCIRL. RMK1 was written by John R. Crigler and modified by A. H. Morns. RMK1 is a modification of the subroutine RANMET, which resides in the STATLIB library. DRMK) was adapted from KMK1 by A. HH. Morris


<small>Original source: [View scanned PDF page 457](scans/page_0457.png)</small>

**Reference.** Thomas, M.A., Gemmill, G.W., and Crigler, J.R., STATLIB: NSWC Library of Statistical Programs and Subroutines, Report NSWC TR 89-37, Naval Surface Warfare Center, Dahlgren, Virginia, °989.


<a id="category-458"></a>
## Appendix: Installation and Precision Conversion

<small>Original source: [View scanned PDF page 458](scans/page_0458.png)</small>

Installation Of The NSWC Library And Conversion Of Codes From Single To Double Precision Form

Code for the library can be obtained on 9-track tape and on Bd inch disks that can be read by the IBM PC. Two copies of the code are given on a tape.

The first function in the library, namely IPMPAR, must be modified for the particular Fortran being used. IPMPAR provides the integer constants which characterize the integer, single precision, and double precision arithmetics being used (see pp. 3-4).

Instructions are given in the in-line documentation of IPMPAR for defining the constants that are needed. If constants are not provided for the compiler being used, then the Fortran manual for the compiler normally gives the constants for che integer arithmetic. However, help may be needed in obtaining the constants for the single and double precision arithmetics. The subroutines MACH and RADIX are provided for this purpose.

MACH and RADIX, and their subroutines MACH1, STORE2, MACH2, DSTOR2 are the next subprograms after IPMPAR. Instructions for the use of MACH and RADIX are given in MACH. These subroutines are experimental. They are provided only as an aid for obtaining the constants for the single and double precision arithmetics. They are not used by any of the functions and subroutines in the NSWC library, and they are not considered to be part of the library. MACH1 and MACH2 perform some writing. None of the functions and subroutines in the NSWC library perform I/O.

After IPMPAR has been defined, the remainder of the library can be installed. None of the remaining code needs any modification. Codes for the functions and subroutines appear approximately in the order that they appear in the manual.

Single /Double Precision Conversion. The following modifications must be made when a subroutine is converted from single to double precision form.

(2) Replace the functions SPMPAR, EPSLN, and EXPARG with DPMPAR, DEPSLN, and DXPARG. Do not modify the arguments of these functions. DPMPAR, DEPSLN, and DXPARG must be declared to be of type DOUBLE PRECISION when they are employed.

(2) If the function IPMPAR appears in the subroutine then replace [IPMPAR(5) with IPMPAR(8), IPMPAR(6) with IPMPAR(9), and IPMPAR(7) with IPMPAR(10).


<a id="routine-index"></a>
## Routine index (source-verified)

This index contains routine declarations documented in this Markdown edition and
verified to be present in the supplied source, preserved as `nswc_orig.f` and available in free form as `nswc.f90`. It excludes implementation-only
support routines; see [the source inventory](NSWC_Source_Interfaces.md) for all source
declarations.

**A**

- [`ABSLV`](#topic-186-01)
- [`ADAPT`](#topic-329-01)
- [`AERF`](#topic-052-01)
- [`AI`](#topic-086-01)
- [`AIE`](#topic-086-01)
- [`ALI`](#topic-063-01)
- [`ALNREL`](#topic-037-01)
- [`ANG`](#topic-032-01)
- [`AORD`](#topic-021-01)
- [`ARCECO`](#topic-169-01)
- [`ARCESL`](#topic-169-01)
- [`ARTNQ`](#topic-024-02)
- [`ASSGN`](#topic-314-01)

**B**

- [`B1CND`](#topic-217-01)
- [`B1NRM`](#topic-213-01)
- [`BADD`](#topic-204-01)
- [`BCVDR`](#topic-200-01)
- [`BCVRC`](#topic-202-01)
- [`BCVRD`](#topic-200-01)
- [`BESI`](#topic-082-01)
- [`BESJ`](#topic-079-01)
- [`BETALN`](#topic-076-01)
- [`BFIT`](#topic-376-01)
- [`BI`](#topic-086-01)
- [`BIE`](#topic-086-01)
- [`BIMAG`](#topic-201-01)
- [`BLKORD`](#topic-245-01)
- [`BLSQ`](#topic-302-01)
- [`BNRM`](#topic-214-01)
- [`BPOSE`](#topic-203-01)
- [`BPROD`](#topic-206-01)
- [`BRATIO`](#topic-077-01)
- [`BRCOMP`](#topic-077-01)
- [`BREAL`](#topic-201-01)
- [`BRKF45`](#topic-418-01)
- [`BSLSQ`](#topic-375-01)
- [`BSLSQ2`](#topic-389-01)
- [`BSLV`](#topic-215-01)
- [`BSLV1`](#topic-215-01)
- [`BSPP`](#topic-371-01)
- [`BSSLI`](#topic-082-01)
- [`BSSLJ`](#topic-079-01)
- [`BSSLK`](#topic-084-01)
- [`BSSLY`](#topic-081-01)
- [`BSTRP`](#topic-373-01)
- [`BSTRP2`](#topic-388-01)
- [`BSUBT`](#topic-205-01)
- [`BTPRD`](#topic-207-01)
- [`BTPRD1`](#topic-207-01)
- [`BTSLV`](#topic-171-01)
- [`BVAL`](#topic-369-01)
- [`BVAL2`](#topic-391-01)
- [`BVALI`](#topic-370-01)
- [`BVPRD`](#topic-207-01)
- [`BVPRD1`](#topic-207-01)

**C**

- [`CAI`](#topic-086-01)
- [`CAPO`](#topic-028-02)
- [`CAXPY`](#topic-138-01)
- [`CBADD`](#topic-204-01)
- [`CBCRT`](#topic-126-01)
- [`CBESK`](#topic-084-01)
- [`CBI`](#topic-086-01)
- [`CBND`](#topic-129-01)
- [`CBPOSE`](#topic-203-01)
- [`CBPROD`](#topic-206-01)
- [`CBRT`](#topic-024-01)
- [`CBSLV`](#topic-223-01)
- [`CBSLV1`](#topic-223-01)
- [`CBSPL`](#topic-342-01)
- [`CBSSLI`](#topic-082-01)
- [`CBSSLJ`](#topic-079-01)
- [`CBSSLK`](#topic-084-01)
- [`CBSUBT`](#topic-205-01)
- [`CBTPD`](#topic-211-01)
- [`CBTPD1`](#topic-211-01)
- [`CBVPD`](#topic-211-01)
- [`CBVPD1`](#topic-211-01)
- [`CCOPY`](#topic-130-01)
- [`CDET`](#topic-185-01)
- [`CDIV`](#topic-026-02)
- [`CDIVID`](#topic-026-02)
- [`CDOTC`](#topic-136-01)
- [`CDOTU`](#topic-136-01)
- [`CEIG`](#topic-273-01)
- [`CEIGV`](#topic-274-01)
- [`CERF`](#topic-046-01)
- [`CERFC`](#topic-046-01)
- [`CEXEXI`](#topic-062-01)
- [`CEXPLI`](#topic-058-01)
- [`CFRNLI`](#topic-056-01)
- [`CGAMMA`](#topic-065-01)
- [`CHEBY`](#topic-327-01)
- [`CIN`](#topic-061-01)
- [`CIRCV`](#topic-107-01)
- [`CK`](#topic-089-01)
- [`CKE`](#topic-089-01)
- [`CKPROD`](#topic-160-01)
- [`CL1`](#topic-279-01)
- [`CLE`](#topic-193-01)
- [`CLI`](#topic-063-01)
- [`CMADD`](#topic-151-01)
- [`CMADJ`](#topic-150-01)
- [`CMCONJ`](#topic-147-01)
- [`CMCOPY`](#topic-146-01)
- [`CMCVBS`](#topic-198-01)
- [`CMCVSB`](#topic-198-01)
- [`CMIMAG`](#topic-145-01)
- [`CMPROD`](#topic-155-01)
- [`CMREAL`](#topic-145-01)
- [`CMSLV`](#topic-178-01)
- [`CMSLV1`](#topic-178-01)
- [`CMSUBT`](#topic-153-01)
- [`CMTMS`](#topic-155-01)
- [`CONSTR`](#topic-031-01)
- [`COS1`](#topic-033-01)
- [`COSQB`](#topic-324-01)
- [`COSQF`](#topic-324-01)
- [`COSQI`](#topic-324-01)
- [`CPABS`](#topic-024-03)
- [`CPOSE`](#topic-235-01)
- [`CPOSE1`](#topic-235-01)
- [`CPSC`](#topic-333-01)
- [`CPSI`](#topic-069-01)
- [`CREC`](#topic-026-01)
- [`CROUT`](#topic-163-01)
- [`CSADD`](#topic-236-01)
- [`CSCAL`](#topic-137-01)
- [`CSCOPY`](#topic-231-01)
- [`CSEVL`](#topic-118-01)
- [`CSIMAG`](#topic-229-01)
- [`CSINT`](#topic-351-01)
- [`CSINT1`](#topic-351-01)
- [`CSINT2`](#topic-351-01)
- [`CSLOOP`](#topic-355-01)
- [`CSLV`](#topic-258-01)
- [`CSLVMP`](#topic-182-01)
- [`CSPFIT`](#topic-345-01)
- [`CSPROD`](#topic-238-01)
- [`CSPSLV`](#topic-258-01)
- [`CSREAL`](#topic-229-01)
- [`CSRF`](#topic-381-01)
- [`CSRF2`](#topic-381-01)
- [`CSROT`](#topic-132-01)
- [`CSSCAL`](#topic-137-01)
- [`CSSUBT`](#topic-237-01)
- [`CSURF`](#topic-381-01)
- [`CSURF1`](#topic-381-01)
- [`CSVDC`](#topic-183-01)
- [`CSWAP`](#topic-131-01)
- [`CTIP`](#topic-148-01)
- [`CTPOSE`](#topic-148-01)
- [`CTPRD`](#topic-241-01)
- [`CTPRD1`](#topic-241-01)
- [`CTRANS`](#topic-150-01)
- [`CTSLV`](#topic-258-01)
- [`CUBTRI`](#topic-408-01)
- [`CURV1`](#topic-357-01)
- [`CURV2`](#topic-359-01)
- [`CURVD`](#topic-360-01)
- [`CURVI`](#topic-360-01)
- [`CVBC`](#topic-196-01)
- [`CVBD`](#topic-196-01)
- [`CVBR`](#topic-196-01)
- [`CVCB`](#topic-196-01)
- [`CVCB1`](#topic-196-01)
- [`CVCS`](#topic-226-01)
- [`CVDB`](#topic-196-01)
- [`CVDB1`](#topic-196-01)
- [`CVDS`](#topic-226-01)
- [`CVPRD`](#topic-241-01)
- [`CVPRD1`](#topic-241-01)
- [`CVRB`](#topic-196-01)
- [`CVRB1`](#topic-196-01)
- [`CVRS`](#topic-226-01)
- [`CVSC`](#topic-226-01)
- [`CVSD`](#topic-226-01)
- [`CVSR`](#topic-226-01)

**D**

- [`DABSLV`](#topic-186-01)
- [`DAERF`](#topic-052-01)
- [`DAORD`](#topic-021-01)
- [`DARTNQ`](#topic-024-02)
- [`DASUM`](#topic-139-01)
- [`DAW`](#topic-055-01)
- [`DAXPY`](#topic-138-01)
- [`DB1CND`](#topic-221-01)
- [`DB1NRM`](#topic-213-01)
- [`DBADD`](#topic-204-01)
- [`DBETLN`](#topic-076-01)
- [`DBNRM`](#topic-214-01)
- [`DBPOSE`](#topic-203-01)
- [`DBPROD`](#topic-206-01)
- [`DBSLV`](#topic-219-01)
- [`DBSLV1`](#topic-219-01)
- [`DBSUBT`](#topic-205-01)
- [`DBTPD`](#topic-209-01)
- [`DBTPD1`](#topic-209-01)
- [`DBVPD`](#topic-209-01)
- [`DBVPD1`](#topic-209-01)
- [`DCBCRT`](#topic-126-01)
- [`DCBRT`](#topic-024-01)
- [`DCEIG`](#topic-276-01)
- [`DCEIGV`](#topic-277-01)
- [`DCERF`](#topic-046-01)
- [`DCERFC`](#topic-046-01)
- [`DCGAMA`](#topic-065-01)
- [`DCMSLV`](#topic-178-01)
- [`DCOPY`](#topic-130-01)
- [`DCOS1`](#topic-033-01)
- [`DCPABS`](#topic-024-03)
- [`DCPOLY`](#topic-127-01)
- [`DCPSC`](#topic-333-01)
- [`DCPSI`](#topic-069-01)
- [`DCREC`](#topic-026-01)
- [`DCSEVL`](#topic-118-01)
- [`DCSQRT`](#topic-026-03)
- [`DDOT`](#topic-136-01)
- [`DDSORT`](#topic-021-01)
- [`DEI`](#topic-058-01)
- [`DEI1`](#topic-058-01)
- [`DEIG`](#topic-266-01)
- [`DEIGV`](#topic-267-01)
- [`DELLPI`](#topic-092-01)
- [`DEPI`](#topic-096-01)
- [`DEPSLN`](#topic-019-01)
- [`DERF`](#topic-046-01)
- [`DERFC`](#topic-046-01)
- [`DERFC1`](#topic-046-01)
- [`DERFI`](#topic-051-01)
- [`DET`](#topic-185-01)
- [`DFRAN`](#topic-452-01)
- [`DGAMLN`](#topic-065-01)
- [`DGAMMA`](#topic-065-01)
- [`DGINV`](#topic-074-01)
- [`DGRAT`](#topic-072-01)
- [`DHFTI`](#topic-287-01)
- [`DHFTI2`](#topic-287-01)
- [`DISORT`](#topic-021-01)
- [`DKPROD`](#topic-160-01)
- [`DLLSQ`](#topic-287-01)
- [`DLNREL`](#topic-037-01)
- [`DLSQR`](#topic-287-01)
- [`DMADD`](#topic-151-01)
- [`DMCOPY`](#topic-146-01)
- [`DMCVBS`](#topic-198-01)
- [`DMCVFS`](#topic-142-01)
- [`DMCVSB`](#topic-198-01)
- [`DMCVSF`](#topic-142-01)
- [`DMEVAL`](#topic-395-01)
- [`DMEXP`](#topic-191-01)
- [`DMFIT`](#topic-395-01)
- [`DMPROD`](#topic-155-01)
- [`DMSLV`](#topic-163-01)
- [`DMSLV1`](#topic-163-01)
- [`DMSUBT`](#topic-153-01)
- [`DMTMS`](#topic-155-01)
- [`DNRM2`](#topic-140-01)
- [`DNRNG`](#topic-442-01)
- [`DNRVG`](#topic-444-01)
- [`DNRVG1`](#topic-444-01)
- [`DORDER`](#topic-021-01)
- [`DPADD`](#topic-111-01)
- [`DPCHOL`](#topic-176-01)
- [`DPCOPY`](#topic-110-01)
- [`DPDAW`](#topic-055-01)
- [`DPDET`](#topic-185-01)
- [`DPDIV`](#topic-114-01)
- [`DPINV`](#topic-116-01)
- [`DPLE`](#topic-193-01)
- [`DPLPWR`](#topic-115-01)
- [`DPMPAR`](#topic-017-01)
- [`DPMULT`](#topic-113-01)
- [`DPNI`](#topic-054-01)
- [`DPOSE`](#topic-234-01)
- [`DPOSE1`](#topic-234-01)
- [`DPSI`](#topic-069-01)
- [`DPSUBT`](#topic-112-01)
- [`DQAGI`](#topic-405-01)
- [`DQAGS`](#topic-398-01)
- [`DQDCRT`](#topic-126-01)
- [`DQTCRT`](#topic-126-01)
- [`DQXGS`](#topic-398-01)
- [`DRBETA`](#topic-451-01)
- [`DRCIR`](#topic-441-01)
- [`DRCOMP`](#topic-072-01)
- [`DRDVAL`](#topic-092-01)
- [`DREXP`](#topic-036-01)
- [`DRFVAL`](#topic-092-01)
- [`DRGAM`](#topic-449-01)
- [`DRJVAL`](#topic-096-01)
- [`DRLOG`](#topic-037-01)
- [`DRLOG1`](#topic-037-01)
- [`DRMK1`](#topic-456-01)
- [`DRNEXP`](#topic-447-01)
- [`DRNK`](#topic-161-01)
- [`DRNOR`](#topic-442-01)
- [`DROT`](#topic-132-01)
- [`DROTG`](#topic-029-01)
- [`DROTM`](#topic-133-01)
- [`DROTMG`](#topic-133-01)
- [`DRPOLY`](#topic-127-01)
- [`DS1CND`](#topic-256-01)
- [`DS1NRM`](#topic-242-01)
- [`DSADD`](#topic-236-01)
- [`DSCAL`](#topic-137-01)
- [`DSCOPY`](#topic-231-01)
- [`DSEIG`](#topic-271-01)
- [`DSEIGV`](#topic-272-01)
- [`DSIN1`](#topic-033-01)
- [`DSLV`](#topic-252-01)
- [`DSMSLV`](#topic-173-01)
- [`DSNRM`](#topic-243-01)
- [`DSORT`](#topic-021-01)
- [`DSPROD`](#topic-238-01)
- [`DSPSLV`](#topic-252-01)
- [`DSSUBT`](#topic-237-01)
- [`DSVDC`](#topic-183-01)
- [`DSVPRD`](#topic-157-01)
- [`DSWAP`](#topic-131-01)
- [`DTASLV`](#topic-188-01)
- [`DTIP`](#topic-148-01)
- [`DTOPLX`](#topic-177-01)
- [`DTPOSE`](#topic-148-01)
- [`DTPRD`](#topic-240-01)
- [`DTPRD1`](#topic-240-01)
- [`DTRAN`](#topic-454-01)
- [`DTSLV`](#topic-252-01)
- [`DURNG`](#topic-439-01)
- [`DURNG2`](#topic-440-01)
- [`DVPRD`](#topic-240-01)
- [`DVPRD1`](#topic-240-01)
- [`DXPARG`](#topic-019-01)
- [`DZERO`](#topic-122-01)

**E**

- [`EIG`](#topic-262-01)
- [`EIG1`](#topic-262-01)
- [`EIGV`](#topic-264-01)
- [`EIGV1`](#topic-264-01)
- [`ELLPF`](#topic-099-01)
- [`ELLPI`](#topic-092-01)
- [`ELPFC1`](#topic-099-01)
- [`EPI`](#topic-096-01)
- [`EPSLN`](#topic-019-01)
- [`ERF`](#topic-046-01)
- [`ERFC`](#topic-046-01)
- [`ERFC1`](#topic-046-01)
- [`ERFI`](#topic-051-01)
- [`EXPARG`](#topic-019-01)
- [`EXPLI`](#topic-058-01)

**F**

- [`FFT`](#topic-320-01)
- [`FFT1`](#topic-320-01)
- [`FMIN`](#topic-306-01)
- [`FRAN`](#topic-452-01)
- [`FRNL`](#topic-057-01)

**G**

- [`GAMINV`](#topic-074-01)
- [`GAMLN`](#topic-065-01)
- [`GAMMA`](#topic-065-01)
- [`GERK`](#topic-424-01)
- [`GRADG`](#topic-392-01)
- [`GRADL`](#topic-392-01)
- [`GRATIO`](#topic-072-01)

**H**

- [`HBRD`](#topic-124-01)
- [`HC`](#topic-043-01)
- [`HFTI`](#topic-281-01)
- [`HFTI2`](#topic-281-01)
- [`HTRP`](#topic-338-01)
- [`HULL`](#topic-041-01)

**I**

- [`ICAMAX`](#topic-141-01)
- [`IDAMAX`](#topic-141-01)
- [`IESLV`](#topic-410-01)
- [`INTRVL`](#topic-368-01)
- [`IORDER`](#topic-021-01)
- [`IPMPAR`](#topic-017-01)
- [`ISAMAX`](#topic-141-01)
- [`ISHELL`](#topic-021-01)
- [`ISUBX`](#topic-077-01)

**K**

- [`KPROD`](#topic-160-01)
- [`KROUT`](#topic-163-01)
- [`KURV1`](#topic-361-01)
- [`KURV2`](#topic-361-01)
- [`KURVP1`](#topic-363-01)
- [`KURVP2`](#topic-363-01)

**L**

- [`L2SLV`](#topic-299-01)
- [`LAINV`](#topic-317-01)
- [`LE`](#topic-193-01)
- [`LGRNGN`](#topic-119-01)
- [`LGRNGV`](#topic-119-01)
- [`LGRNGX`](#topic-119-01)
- [`LLSQ`](#topic-281-01)
- [`LLSQMP`](#topic-286-01)
- [`LMDIFF`](#topic-309-01)
- [`LOCPT`](#topic-039-01)
- [`LOPCMP`](#topic-355-01)
- [`LOPDF`](#topic-355-01)
- [`LSEI`](#topic-292-01)
- [`LSQR`](#topic-281-01)
- [`LTRP`](#topic-337-01)

**M**

- [`MADD`](#topic-151-01)
- [`MCOPY`](#topic-146-01)
- [`MCVBS`](#topic-198-01)
- [`MCVDR`](#topic-143-01)
- [`MCVFS`](#topic-142-01)
- [`MCVRC`](#topic-144-01)
- [`MCVRD`](#topic-143-01)
- [`MCVSB`](#topic-198-01)
- [`MCVSF`](#topic-142-01)
- [`MEVAL`](#topic-395-01)
- [`MEXP`](#topic-191-01)
- [`MFFT`](#topic-322-01)
- [`MFFT1`](#topic-322-01)
- [`MFIT`](#topic-395-01)
- [`MKP`](#topic-315-01)
- [`MPLNMV`](#topic-117-01)
- [`MPROD`](#topic-155-01)
- [`MSLV`](#topic-163-01)
- [`MSLV1`](#topic-163-01)
- [`MSUBT`](#topic-153-01)
- [`MTMS`](#topic-155-01)
- [`MTPRD`](#topic-239-01)
- [`MTPRD1`](#topic-239-01)
- [`MVPRD`](#topic-239-01)
- [`MVPRD1`](#topic-239-01)

**N**

- [`NPIVOT`](#topic-163-01)
- [`NRNG`](#topic-442-01)
- [`NRVG`](#topic-444-01)
- [`NRVG1`](#topic-444-01)
- [`NSURF2`](#topic-386-01)

**O**

- [`ODE`](#topic-415-01)
- [`OPTF`](#topic-307-01)
- [`ORTHOS`](#topic-121-01)
- [`ORTHOV`](#topic-121-01)
- [`ORTHOX`](#topic-121-01)

**P**

- [`PADD`](#topic-111-01)
- [`PAREA`](#topic-042-01)
- [`PCHOL`](#topic-176-01)
- [`PCOEFF`](#topic-339-01)
- [`PDFIT`](#topic-353-01)
- [`PDIV`](#topic-114-01)
- [`PDSPL`](#topic-352-01)
- [`PEQ`](#topic-102-01)
- [`PEQ1`](#topic-102-01)
- [`PFIND`](#topic-040-01)
- [`PFIT`](#topic-340-01)
- [`PINV`](#topic-116-01)
- [`PKILL`](#topic-109-01)
- [`PLCOPY`](#topic-110-01)
- [`PLEM`](#topic-102-01)
- [`PLEM1`](#topic-102-01)
- [`PLPWR`](#topic-115-01)
- [`PMULT`](#topic-113-01)
- [`PNDF`](#topic-053-01)
- [`PNI`](#topic-054-01)
- [`POCA`](#topic-028-01)
- [`PPVAL`](#topic-372-01)
- [`PSCMP`](#topic-354-01)
- [`PSEVL`](#topic-354-01)
- [`PSI`](#topic-069-01)
- [`PSIDF`](#topic-071-01)
- [`PSUBT`](#topic-112-01)

**Q**

- [`QAGI`](#topic-405-01)
- [`QAGS`](#topic-398-01)
- [`QDCRT`](#topic-126-01)
- [`QSORTD`](#topic-021-01)
- [`QSORTI`](#topic-021-01)
- [`QSORTR`](#topic-021-01)
- [`QSUBA`](#topic-398-01)
- [`QTCRT`](#topic-126-01)
- [`QURV1`](#topic-365-01)
- [`QURV2`](#topic-365-01)
- [`QXGS`](#topic-398-01)

**R**

- [`RANEXP`](#topic-447-01)
- [`RBETA`](#topic-451-01)
- [`RBND`](#topic-129-01)
- [`RCIR`](#topic-441-01)
- [`RCOMP`](#topic-072-01)
- [`RDVAL`](#topic-092-01)
- [`REXP`](#topic-036-01)
- [`RFVAL`](#topic-092-01)
- [`RGAM`](#topic-449-01)
- [`RISORT`](#topic-021-01)
- [`RJVAL`](#topic-096-01)
- [`RK`](#topic-431-01)
- [`RK8`](#topic-433-01)
- [`RKF45`](#topic-421-01)
- [`RLOG`](#topic-037-01)
- [`RLOG1`](#topic-037-01)
- [`RMK1`](#topic-456-01)
- [`RNK`](#topic-161-01)
- [`RNOR`](#topic-442-01)
- [`RORDER`](#topic-021-01)
- [`ROT3`](#topic-030-01)
- [`ROTA`](#topic-028-03)
- [`RPOSE`](#topic-233-01)
- [`RPOSE1`](#topic-233-01)
- [`RSCOPY`](#topic-231-01)
- [`RSLV`](#topic-246-01)

**S**

- [`S1CND`](#topic-250-01)
- [`S1NRM`](#topic-242-01)
- [`SADD`](#topic-236-01)
- [`SASUM`](#topic-139-01)
- [`SAXPY`](#topic-138-01)
- [`SCASUM`](#topic-139-01)
- [`SCNRM2`](#topic-140-01)
- [`SCOMP`](#topic-347-01)
- [`SCOMP1`](#topic-347-01)
- [`SCOMP2`](#topic-347-01)
- [`SCONJ`](#topic-232-01)
- [`SCOPY`](#topic-130-01)
- [`SCVDR`](#topic-228-01)
- [`SCVRC`](#topic-230-01)
- [`SCVRD`](#topic-228-01)
- [`SDOT`](#topic-136-01)
- [`SEIG`](#topic-269-01)
- [`SEIG1`](#topic-269-01)
- [`SEIGV`](#topic-270-01)
- [`SEIGV1`](#topic-270-01)
- [`SEPDE`](#topic-434-01)
- [`SEVAL`](#topic-349-01)
- [`SEVAL1`](#topic-349-01)
- [`SEVAL2`](#topic-349-01)
- [`SFODE`](#topic-427-01)
- [`SFODE1`](#topic-427-01)
- [`SFVAL`](#topic-392-01)
- [`SFVAL2`](#topic-392-01)
- [`SHELL`](#topic-021-01)
- [`SHELL2`](#topic-021-01)
- [`SI`](#topic-061-01)
- [`SIN1`](#topic-033-01)
- [`SINQB`](#topic-324-01)
- [`SINQF`](#topic-324-01)
- [`SLVMP`](#topic-168-01)
- [`SMADD`](#topic-151-01)
- [`SMCOPY`](#topic-146-01)
- [`SMPLX`](#topic-311-01)
- [`SMPROD`](#topic-159-01)
- [`SMSLV`](#topic-173-01)
- [`SMSUBT`](#topic-153-01)
- [`SNHCSH`](#topic-035-01)
- [`SNRM`](#topic-243-01)
- [`SNRM2`](#topic-140-01)
- [`SPFIT`](#topic-344-01)
- [`SPFIT2`](#topic-379-01)
- [`SPLIFT`](#topic-342-01)
- [`SPLSQ`](#topic-304-01)
- [`SPMPAR`](#topic-017-01)
- [`SPORD`](#topic-244-01)
- [`SPROD`](#topic-238-01)
- [`SPSLV`](#topic-246-01)
- [`SQUINT`](#topic-189-01)
- [`SROT`](#topic-132-01)
- [`SROTG`](#topic-029-01)
- [`SROTM`](#topic-133-01)
- [`SROTMG`](#topic-133-01)
- [`SSCAL`](#topic-137-01)
- [`SSPLX`](#topic-311-01)
- [`SSUBT`](#topic-237-01)
- [`SSVDC`](#topic-183-01)
- [`SSWAP`](#topic-131-01)
- [`STLSQ`](#topic-304-01)
- [`SURF`](#topic-384-01)
- [`SURF2`](#topic-386-01)
- [`SVPRD`](#topic-157-01)

**T**

- [`TASLV`](#topic-188-01)
- [`TIP`](#topic-148-01)
- [`TMPROD`](#topic-158-01)
- [`TOPLX`](#topic-177-01)
- [`TPOSE`](#topic-148-01)
- [`TRAN`](#topic-454-01)
- [`TRMESH`](#topic-392-01)
- [`TRP`](#topic-336-01)
- [`TSLV`](#topic-246-01)

**U**

- [`URGET`](#topic-438-01)
- [`URNG`](#topic-439-01)
- [`URNG2`](#topic-440-01)

**V**

- [`VALR2`](#topic-105-01)

**W**

- [`WNNLS`](#topic-296-01)
- [`WPFIT`](#topic-341-01)

**Z**

- [`ZEROIN`](#topic-122-01)

