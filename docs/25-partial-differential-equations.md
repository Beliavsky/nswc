[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-434"></a>
## Partial Differential Equations

<small>Original source: [View scanned PDF page 434](../scans/page_0434.png)</small>

<a id="topic-434-01"></a>
### Separable Second-Order Elliptic Equations On Rectangular Domains

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SEPDE` | `SUBROUTINE` | `COFX, COFY, G, EDGE, BVAL, IORD, A, B, MP1, C, D, NP1, U, KU, W, NW, IERR` | [`L111900`](../source_parts/nswc_part_11.f90#L5683) |


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


<small>Original source: [View scanned PDF page 435](../scans/page_0435.png)</small>

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


<small>Original source: [View scanned PDF page 436](../scans/page_0436.png)</small>

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


<small>Original source: [View scanned PDF page 437](../scans/page_0437.png)</small>

D=1.0 E=00 F =0.0 RETURN END

REAL FUNCTION GVAL (X,Y) GVAL = 3.0#(1.0 + X)« * 4*SIN(Y) RETURN

END

REAL FUNCTION BVAL ({I,X,Y) BVAL = 4.0«SIN(Y)

IF (I .EQ. 4)BVAL = 4.0#BVAL RETURN

END

COFX, COFY, GVAL, and BVAL must be declared in the calling program to be of type EXTERNAL.

**Reference.** Adams, J., Swarztrauber, P., and Sweet, R., FISHPAK: Efficient FORTRAN Subprograms for the Solution of Separable Elliptic Partial Differential Equations, Version 3. National Center for Atmospheric Research, Boulder, Colorado, 1978.

