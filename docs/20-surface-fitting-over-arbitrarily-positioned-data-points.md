[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-392"></a>
## Surface Fitting over Arbitrarily Positioned Data Points

<small>Original source: [View scanned PDF page 392](../scans/page_0392.png)</small>

<a id="topic-392-01"></a>
### Surface Interpolation For Arbitrarily Positioned Data Points

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `TRMESH` | `SUBROUTINE` | `N, X, Y, IADJ, IEND, IER` | [`L96228`](../source_parts/nswc_part_10.f90#L734) |
| `GRADG` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [`L97685`](../source_parts/nswc_part_10.f90#L2191) |
| `GRADL` | `SUBROUTINE` | `N, X, Y, Z, IADJ, IEND, ZXZY, IERR` | [`L97936`](../source_parts/nswc_part_10.f90#L2442) |
| `SFVAL` | `SUBROUTINE` | `N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [`L98493`](../source_parts/nswc_part_10.f90#L2999) |
| `SFVAL2` | `SUBROUTINE` | `N, X, Y, Z, L, M, NROWS, XI, YI, ZI, IADJ, IEND, ZXZY, IERR` | [`L98524`](../source_parts/nswc_part_10.f90#L3030) |


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


<small>Original source: [View scanned PDF page 393](../scans/page_0393.png)</small>

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


<small>Original source: [View scanned PDF page 394](../scans/page_0394.png)</small>

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

