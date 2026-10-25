[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-039"></a>
## Geometry

<small>Original source: [View scanned PDF page 39](../scans/page_0039.png)</small>

<a id="topic-039-01"></a>
### Determining if a Point Is Inside or Outside a Polygon

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `LOCPT` | `SUBROUTINE` | `X0, Y0, X, Y, N, L, M` | [`L4333`](../source_parts/nswc_part_01.f90#L4333) |


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


<small>Original source: [View scanned PDF page 40](../scans/page_0040.png)</small>

<a id="topic-040-01"></a>
### Intersection of a Straight Line and Polygonal Path

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PFIND` | `SUBROUTINE` | `A, B, X, Y, N, U, V, M, NUM, IERR` | [`L4410`](../source_parts/nswc_part_01.f90#L4410) |


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


<small>Original source: [View scanned PDF page 41](../scans/page_0041.png)</small>

<a id="topic-041-01"></a>
### The Convex Hull for a Finite Planar Set

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HULL` | `SUBROUTINE` | `X, Y, M, BX, BY, K, VX, VY, N` | [`L4569`](../source_parts/nswc_part_01.f90#L4569) |


If (z1, 41), ..., (2m, ym) are m distinct points in the plane, then the following subroutine is available for finding the smallest convex polygon which with its interior contains the

points. CALL HULL(X,Y,m, BX,BY,k, VX,VY,n)

It is assumed that m > 2. X and ¥ are arrays containing the abscissas 11, ...,2m and ordinates y1,...,Ym, respectively. When HULL is called the points are reordered so that Yi S++ Sym. Thus A and Y may be modified when the routine terminates.

RX and BY are arrays of dimension m+ 1 or larger, and k is @ variable. When HULL terminates, BX and BY contain the abscissas and ordinates of the points (2,,y,) which lie on the boundary of the desired convex polygon, and k = the number of points stored in BX and BY. If BX and BY contain the abscissas x}, ..., 2), and ordinates yj,. , y,, then the points (2, y;' are indexed in the order they occur when traversing the boundary in a counterclockwise manner. Also (x1, y,) = (24, y4)-

VX% and VY are arrays of dimension m~-'- 1 or larger, and n is a variable. When HULL terminates, VX and VY contain the abscissas and ordinates of the vertices of the desired convex polygon, and n = the number of points stored in VX and VY. If VX and VY contain the abscissas x, ...,¢/1 and ordinates y/, ...,y/’, then the vertices (2/’, yi’) are indexed in the order they occur when traversing the boundary of the convex polygon in a

counterclockwise manner. Also (2!, yl!) == (ci, yy’).

**Example.** Assume that we are given the points (-—1,-3), (1,1) (0,3), (2,2), (-2,4), (-1,~1). When HULi 13 called X and Y are reordered and we obtain: X contains —1,--1,1,2,0, --2 Y contains —3,-1,1,2,2 BX contains —1,2,0,—2,-1 BY contains —3,2,3,4,--3 V¥ contains -1,2,-2,~-1 VY contains --3,2,4,--3

**Programming.** HULL calls the subroutine RRSORT and function SPMPAR. HULL was written by A. H. Morris.


<small>Original source: [View scanned PDF page 42](../scans/page_0042.png)</small>

<a id="topic-042-01"></a>
### Areas Of Planar Polygons

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `PAREA` | `REAL FUNCTION` | `X, Y, NB` | [`L4951`](../source_parts/nswc_part_01.f90#L4951) |


Given a sequence of points v; = (2, y;) (§ = 1,...,2+ 1) where n > 1 and ung) = 01. Let + denote the polygon whose boundary Or is a polygonal line which begins at point v1, traverses the points vy, in the order that they are indexed, and is the straight line segment connecting v; to u,41 fort = 1, ...,n. Then the function PAREA is available for computing A(r) = ff, dxdy. If the boundary @r is a positively (negatively) oriented simple closed curve, then A(r) is positive (negative) and |A(r)| = the ares. of r. However, Or need not be simple. It may be self-intersecting or have overlapping line segments.

```fortran
PAREA(X, Y, NB)
```

X and Y are arrays containing the abscissas r,,. ry and ordinates y1,...,yN, respectively. The argument N may have the value n or n+ 1. Since ta4, = v1, %,41 and Yn+14 are not required to appear in X and Y. PAREA(X,Y, N) is assigned the value A(r).

**Programmer.** A. H. Morris Reference. DiDonato, A. R. and Hageman, R. K., Computation of the Integral of the Bi-

variate Normal Distribution over Arbitrary Polygons, report TR 80-166, Naval Surface Weapons Center, Dahlgren, Virginia, 1980.


<small>Original source: [View scanned PDF page 43](../scans/page_0043.png)</small>

<a id="topic-043-01"></a>
### Hamiltonian Circuits

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `HC` | `SUBROUTINE` | `IND, M, N, PR, AR, NB, S, IWK, NUM` | [`L4985`](../source_parts/nswc_part_01.f90#L4985) |


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


<small>Original source: [View scanned PDF page 44](../scans/page_0044.png)</small>

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


<small>Original source: [View scanned PDF page 45](../scans/page_0045.png)</small>

**Programming.** HC employs the subroutines HC1, IPATH, FUPD, BUPD, IUPD, and RARC. The search procedure in these routines was written by Silvano Martello (University of Bologna, Italy). The user interface involving the variable IND was written by A. H.

Morris.

**Reference.** Martello, 8., “Algorithm 595. An Enumerative Algorithm for Finding Hamiltonian Circuits in a Directed Graph,” ACM Trans.. Math Software 9 (1983), pp. 131-138.

