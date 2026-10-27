[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-378"></a>
## Surface Fitting over Rectangular Grids

<small>Original source: [View scanned PDF page 378](../scans/page_0378.png)</small>

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


<small>Original source: [View scanned PDF page 379](../scans/page_0379.png)</small>

<a id="topic-379-01"></a>
### Weighted Least Squares Bicubic Spline Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SPFIT2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX, YBREAK, NY, F, S, T, WK, NUM, IERR` | [`L86940`](../source_parts/nswc_part_09.f90#L2031) |


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


<small>Original source: [View scanned PDF page 380](../scans/page_0380.png)</small>

**Programming.** SPFIT2 employs the routines CSSP, BSLSQ2, BSLSQ1, BSPVB, BCHFAC, and BCHS¥V1. SPFIT2 was written by A. li. Morris.


<small>Original source: [View scanned PDF page 381](../scans/page_0381.png)</small>

<a id="topic-381-01"></a>
### Evaluation and Differentiation of Bicubic Splines

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CSURF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [`L87182`](../source_parts/nswc_part_09.f90#L2273) |
| `CSURF1` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F` | [`L87335`](../source_parts/nswc_part_09.f90#L2426) |
| `CSRF` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, F1, KF1, F2, KF2, F12, KF12` | [`L87375`](../source_parts/nswc_part_09.f90#L2466) |
| `CSRF2` | `SUBROUTINE` | `IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF, DDF` | [`L87523`](../source_parts/nswc_part_09.f90#L2614) |


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


<small>Original source: [View scanned PDF page 382](../scans/page_0382.png)</small>

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


<small>Original source: [View scanned PDF page 383](../scans/page_0383.png)</small>

**Programming.** CSRF2 is a driver for the subroutine CSRF. The function INTRVL is used. CSRF2 was written by A. H. Morris.

ott


<small>Original source: [View scanned PDF page 384](../scans/page_0384.png)</small>

<a id="topic-384-01"></a>
### Bispline Under Tension Surface Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SURF` | `SUBROUTINE` | `M, N, X, Y, Z, IZ, OPT, ZP, TEMP, SIGMA, IERR` | [`L87564`](../source_parts/nswc_part_09.f90#L2655) |


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


<small>Original source: [View scanned PDF page 385](../scans/page_0385.png)</small>

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


<small>Original source: [View scanned PDF page 386](../scans/page_0386.png)</small>

<a id="topic-386-01"></a>
### Bispline Under Tension Evaluation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SURF2` | `FUNCTION` | `XX, YY, M, N, X, Y, Z, IZ, ZP, SIGMA` | [`L87943`](../source_parts/nswc_part_09.f90#L3034) |
| `NSURF2` | `SUBROUTINE` | `DXMIN, DXMAX, MD, DYMIN, DYMAX, ND, DZ, IDZ, M, N, X, Y, Z, IZ, ZP, WORK, SIGMA` | [`L88080`](../source_parts/nswc_part_09.f90#L3171) |


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


<small>Original source: [View scanned PDF page 387](../scans/page_0387.png)</small>

The arguments m,n, X,Y, 4, kz, DDZ,o are the same as in SURF2. WORK is an array of dimension 4m, or larger that is used for a work space.

**Programming.** NSURF2 employs the subroutine SNHCSH. NSURF2 was written by A. K. Cline (University of Texas at Austin).

S16


<small>Original source: [View scanned PDF page 388](../scans/page_0388.png)</small>

<a id="topic-388-01"></a>
### Bivariate B-Spline Piecewise Polynomial Interpolation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSTRP2` | `SUBROUTINE` | `X, Y, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [`L88248`](../source_parts/nswc_part_09.f90#L3339) |


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


<small>Original source: [View scanned PDF page 389](../scans/page_0389.png)</small>

<a id="topic-389-01"></a>
### Bivariate B-Spline Piecewise Polynomial Least Squares Fitting

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BSLSQ2` | `SUBROUTINE` | `X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX, TY, NY, KY, A, KA, WK, L, IFLAG` | [`L88350`](../source_parts/nswc_part_09.f90#L3441) |


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


<small>Original source: [View scanned PDF page 390](../scans/page_0390.png)</small>

for NUM, namely rv + max{(k-+ 1)m,(@+ Ln}, has been stored in WK(i). Reset NUM > WK(1).

**Remark.** After the coefficients a,; are obtained, then the subroutine BVAL2 can be used to evaluate or differentiate the piecewise polynomial f(z, y).

**Programming.** BSLSQ2 employs the routines BSLSQ1, BSPVB, BCHFAC, and BCHSV1, BSLSQ2 was written by A. H. Morris.


<small>Original source: [View scanned PDF page 391](../scans/page_0391.png)</small>

<a id="topic-391-01"></a>
### Evaluation And Differentiation Of Bivariate Piecewise Polynomials From Their B-Spline Representations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BVAL2` | `SUBROUTINE` | `A, KA, TX, NX, KX, TY, NY, KY, X0, Y0, IDX, IDY, F, WK` | [`L88605`](../source_parts/nswc_part_09.f90#L3696) |


Form>k>landn>é> 1 let 3, <--- < mye and ty < +++ < tyy, be sequences where s; < sy44 (¢ = 1,...,m) and t; < tye (7 = 1,...,n). Let Biz, ..., Bmg be the B-splines for the knots sy < +++ < smsy and By, ..., Bye the B-splines for the knots

ty Sees Stage. If ™ n

f(z,y) = D7 >) a5 Bex (x) Bye(y)

t=) 7-1 then the following subroutine is available for computing f(z,y) and its partial derivatives. CALL BVAL2(A,ka,S,m,k,T,n,é,2,y, u,v, ,WK)

A is the m x n matrix (a,;), S an array containing s1, -«+y)Sm+4k, and T an array containing ty, ...,tn4¢. It is assumed that ka > m, where ka is the number of rows in the dimension statement for A in the calling program.

The arguments y and v are nonnegative integers, (z,y) is the point at which f or its partial derivative 04+” f/d4rd"”y is to be evaluated, and w is a variable. When BVAL2 is called, then w is assigned the value a, BY (2) BY (y). Here Bi) denotes B,, if p= 0 and the yu‘? derivative of By, if u > 1. Ife # smax then by BY) (x) we mean the right limit BY (x4 ), and if z = 6,4,% then by BY (x) we mean the left limit BY (z-), Similar

comments hold for BY (y).

WK is an array of dimension @+ max{3k,3é} or larger that is a work space for the routine.

**Programming.** BVAL2 employs the function INTRVL and subroutine BVAL. BVAL2 was written by A. H. Morris.

