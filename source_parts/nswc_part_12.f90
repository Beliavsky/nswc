subroutine sepel1 (intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c, &
&d,n,nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,an,bn, &
&cn,dn,un,zn,am,bm,cm,dm,um,zm,grhs,mn,usol, &
&idmn,w,pertrb,ierror)
implicit none
integer :: idmn, ierror, intl, iorder, m, mbdcnd, mn, n, nbdcnd
real :: a, alpha, am(*), an(*), b, bda(*), bdb(*), bdc(*), bdd(*), &
&beta, bm(*), bn(*), c, cm(*), cn(*), d, dm(*), dn(*), gama, &
&grhs(mn,*), pertrb, um(*), un(*), usol(idmn,*), w(*), xnu, zm(*), &
&zn(*)
integer :: i, i1, iord, j, mp, np
real :: ai, ax1, axi, bi, bxi, ci, cxi, cxm, dj, dy1, dyj, ej, &
&eyj, fj, fyj, fyn, prtrb, xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     SEPEL1 SETS UP VECTORS AND ARRAYS FOR INPUT TO BLKTRI
!     AND COMPUTES A SECOND ORDER SOLUTION IN USOL.  A RETURN JUMP TO
!     SEPELL OCCURRS IF IORDER=2.  IF IORDER=4 A FOURTH ORDER
!     SOLUTION IS GENERATED IN USOL.
!
logical :: singlr
external        cofx, cofy
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
!     SET PARAMETERS INTERNALLY
!
kswx = mbdcnd+1
kswy = nbdcnd+1
k = m+1
l = n+1
ait = a
bit = b
cit = c
dit = d
!
!     SET RIGHT HAND SIDE VALUES FROM GRHS IN USOL ON THE INTERIOR
!     AND NON-SPECIFIED BOUNDARIES.
!
do i=2,m
   do j=2,n
      usol(i,j) = grhs(i,j)
   end do
end do
if (kswx.eq.2 .or. kswx.eq.3) go to  40
do j=2,n
   usol(1,j) = grhs(1,j)
end do
40 continue
if (kswx.eq.2 .or. kswx.eq.5) go to  60
do j=2,n
   usol(k,j) = grhs(k,j)
end do
60 continue
if (kswy.eq.2 .or. kswy.eq.3) go to  80
do i=2,m
   usol(i,1) = grhs(i,1)
end do
80 continue
if (kswy.eq.2 .or. kswy.eq.5) go to 100
do i=2,m
   usol(i,l) = grhs(i,l)
end do
100 continue
if (kswx.ne.2 .and. kswx.ne.3 .and. kswy.ne.2 .and. kswy.ne.3) &
&usol(1,1) = grhs(1,1)
if (kswx.ne.2 .and. kswx.ne.5 .and. kswy.ne.2 .and. kswy.ne.3) &
&usol(k,1) = grhs(k,1)
if (kswx.ne.2 .and. kswx.ne.3 .and. kswy.ne.2 .and. kswy.ne.5) &
&usol(1,l) = grhs(1,l)
if (kswx.ne.2 .and. kswx.ne.5 .and. kswy.ne.2 .and. kswy.ne.5) &
&usol(k,l) = grhs(k,l)
i1 = 1
!
!     SET SWITCHES FOR PERIODIC OR NON-PERIODIC BOUNDARIES
!
mp = 1
np = 1
if (kswx .eq. 1) mp = 0
if (kswy .eq. 1) np = 0
!
!     SET DLX,DLY AND SIZE OF BLOCK TRI-DIAGONAL SYSTEM GENERATED
!     IN NINT,MINT
!
dlx = (bit-ait)/float(m)
mit = k-1
if (kswx .eq. 2) mit = k-2
if (kswx .eq. 4) mit = k
dly = (dit-cit)/float(n)
nit = l-1
if (kswy .eq. 2) nit = l-2
if (kswy .eq. 4) nit = l
tdlx3 = 2.0*dlx**3
dlx4 = dlx**4
tdly3 = 2.0*dly**3
dly4 = dly**4
!
!     SET SUBSCRIPT LIMITS FOR PORTION OF ARRAY TO INPUT TO BLKTRI
!
is = 1
js = 1
if (kswx.eq.2 .or. kswx.eq.3) is = 2
if (kswy.eq.2 .or. kswy.eq.3) js = 2
ns = nit+js-1
ms = mit+is-1
!
!     SET X - DIRECTION
!
do i=1,mit
   xi = ait+float(is+i-2)*dlx
   call cofx (xi,ai,bi,ci)
   axi = (ai/dlx-0.5*bi)/dlx
   bxi = -2.*ai/dlx**2+ci
   cxi = (ai/dlx+0.5*bi)/dlx
   am(i) = axi
   bm(i) = bxi
   cm(i) = cxi
end do
!
!     SET Y DIRECTION
!
do j=1,nit
   yj = cit+float(js+j-2)*dly
   call cofy (yj,dj,ej,fj)
   dyj = (dj/dly-0.5*ej)/dly
   eyj = (-2.*dj/dly**2+fj)
   fyj = (dj/dly+0.5*ej)/dly
   an(j) = dyj
   bn(j) = eyj
   cn(j) = fyj
end do
!
!     ADJUST EDGES IN X DIRECTION UNLESS PERIODIC
!
ax1 = am(1)
cxm = cm(mit)
go to (170,130,150,160,140),kswx
!
!     DIRICHLET-DIRICHLET IN X DIRECTION
!
130 am(1) = 0.0
cm(mit) = 0.0
go to 170
!
!     MIXED-DIRICHLET IN X DIRECTION
!
140 am(1) = 0.0
bm(1) = bm(1)+2.*alpha*dlx*ax1
cm(1) = cm(1)+ax1
cm(mit) = 0.0
go to 170
!
!     DIRICHLET-MIXED IN X DIRECTION
!
150 am(1) = 0.0
am(mit) = am(mit)+cxm
bm(mit) = bm(mit)-2.*beta*dlx*cxm
cm(mit) = 0.0
go to 170
!
!     MIXED - MIXED IN X DIRECTION
!
160 continue
am(1) = 0.0
bm(1) = bm(1)+2.*dlx*alpha*ax1
cm(1) = cm(1)+ax1
am(mit) = am(mit)+cxm
bm(mit) = bm(mit)-2.*dlx*beta*cxm
cm(mit) = 0.0
170 continue
!
!     ADJUST IN Y DIRECTION UNLESS PERIODIC
!
dy1 = an(1)
fyn = cn(nit)
go to (220,180,200,210,190),kswy
!
!     DIRICHLET-DIRICHLET IN Y DIRECTION
!
180 continue
an(1) = 0.0
cn(nit) = 0.0
go to 220
!
!     MIXED-DIRICHLET IN Y DIRECTION
!
190 continue
an(1) = 0.0
bn(1) = bn(1)+2.*dly*gama*dy1
cn(1) = cn(1)+dy1
cn(nit) = 0.0
go to 220
!
!     DIRICHLET-MIXED IN Y DIRECTION
!
200 an(1) = 0.0
an(nit) = an(nit)+fyn
bn(nit) = bn(nit)-2.*dly*xnu*fyn
cn(nit) = 0.0
go to 220
!
!     MIXED - MIXED DIRECTION IN Y DIRECTION
!
210 continue
an(1) = 0.0
bn(1) = bn(1)+2.*dly*gama*dy1
cn(1) = cn(1)+dy1
an(nit) = an(nit)+fyn
bn(nit) = bn(nit)-2.0*dly*xnu*fyn
cn(nit) = 0.0
220 if (kswx .eq. 1) go to 270
!
!     ADJUST USOL ALONG X EDGE
!
do 260 j = js,ns
   if (kswx.ne.2 .and. kswx.ne.3) go to 230
   usol(is,j) = usol(is,j)-ax1*usol(1,j)
   go to 240
230 usol(is,j) = usol(is,j)+2.0*dlx*ax1*bda(j)
240 if (kswx.ne.2 .and. kswx.ne.5) go to 250
   usol(ms,j) = usol(ms,j)-cxm*usol(k,j)
   go to 260
250 usol(ms,j) = usol(ms,j)-2.0*dlx*cxm*bdb(j)
260 continue
270 if (kswy .eq. 1) go to 320
!
!     ADJUST USOL ALONG Y EDGE
!
do 310 i = is,ms
   if (kswy.ne.2 .and. kswy.ne.3) go to 280
   usol(i,js) = usol(i,js)-dy1*usol(i,1)
   go to 290
280 usol(i,js) = usol(i,js)+2.0*dly*dy1*bdc(i)
290 if (kswy.ne.2 .and. kswy.ne.5) go to 300
   usol(i,ns) = usol(i,ns)-fyn*usol(i,l)
   go to 310
300 usol(i,ns) = usol(i,ns)-2.0*dly*fyn*bdd(i)
310 continue
320 continue
!
!     SAVE ADJUSTED EDGES IN GRHS IF IORDER=4
!
if (iorder .ne. 4) go to 350
do j=js,ns
   grhs(is,j) = usol(is,j)
   grhs(ms,j) = usol(ms,j)
end do
do i=is,ms
   grhs(i,js) = usol(i,js)
   grhs(i,ns) = usol(i,ns)
end do
350 continue
iord = iorder
pertrb = 0.0
!
!     CHECK IF OPERATOR IS SINGULAR
!
call chksng (mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy,singlr)
!
!     COMPUTE NON-ZERO EIGENVECTOR IN NULL SPACE OF TRANSPOSE
!     IF SINGULAR
!
if (singlr) call trisp (mit,am,bm,cm,dm,um,zm)
if (singlr) call trisp (nit,an,bn,cn,dn,un,zn)
!
!     MAKE INITIALIZATION CALL TO BLKTRI
!
if (intl .eq. 0) &
&call blktri (intl,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn, &
&usol(is,js),ierror,w)
if (ierror .ne. 0) return
!
!     ADJUST RIGHT HAND SIDE IF NECESSARY
!
360 continue
if (singlr) call orthg (usol,idmn,zn,zm,pertrb)
!
!     COMPUTE SOLUTION
!
call blktri (i1,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn,usol(is,js), &
&ierror,w)
if (ierror .ne. 0) return
!
!     SET PERIODIC BOUNDARIES IF NECESSARY
!
if (kswx .ne. 1) go to 380
do j=1,l
   usol(k,j) = usol(1,j)
end do
380 if (kswy .ne. 1) go to 400
do i=1,k
   usol(i,l) = usol(i,1)
end do
400 continue
!
!     MINIMIZE SOLUTION WITH RESPECT TO WEIGHTED LEAST SQUARES
!     NORM IF OPERATOR IS SINGULAR
!
if (singlr) call minsol (usol,idmn,zn,zm,prtrb)
!
!     RETURN IF DEFERRED CORRECTIONS AND A FOURTH ORDER SOLUTION ARE
!     NOT FLAGGED
!
if (iord .eq. 2) return
iord = 2
!
!     COMPUTE NEW RIGHT HAND SIDE FOR FOURTH ORDER SOLUTION
!
call defer (cofx,cofy,usol,idmn,grhs,mn)
go to 360
end subroutine sepel1

subroutine chkprm (intl,iorder,a,b,m,mbdcnd,c,d,n,nbdcnd,cofx, &
&cofy,idmn,mn,ierror)
implicit none
integer, intent(in) :: idmn
integer, intent(out) :: ierror
integer, intent(in) :: intl, iorder, m, mbdcnd, mn, n, nbdcnd
real, intent(in) :: a, b, c, d
integer :: i, j
real :: ai, bi, ci, dj, dlx, dly, ej, fj, xi, yj
!
!     THIS PROGRAM CHECKS THE INPUT PARAMETERS FOR ERRORS
!
!
!     CHECK DEFINITION OF SOLUTION REGION
!
ierror = 1
if (a.ge.b .or. c.ge.d) return
!
!     CHECK BOUNDARY SWITCHES
!
ierror = 2
if (mbdcnd.lt.0 .or. mbdcnd.gt.4) return
ierror = 3
if (nbdcnd.lt.0 .or. nbdcnd.gt.4) return
!
!     CHECK FIRST DIMENSION IN CALLING ROUTINE
!
ierror = 5
if (mn .lt. 7 .or. idmn .lt. 7) return
!
!     CHECK M
!
ierror = 6
if (m .gt. (idmn-1) .or. m.lt.6) return
if (m .gt. mn - 1) return
!
!     CHECK N
!
ierror = 7
if (n .lt. 5) return
!
!     CHECK IORDER
!
ierror = 8
if (iorder.ne.2 .and. iorder.ne.4) return
!
!     CHECK INTL
!
ierror = 9
if (intl.ne.0 .and. intl.ne.1) return
!
!     CHECK THAT EQUATION IS ELLIPTIC
!
dlx = (b-a)/float(m)
dly = (d-c)/float(n)
do i=2,m
   xi = a+float(i-1)*dlx
   call cofx (xi,ai,bi,ci)
   do j=2,n
      yj = c+float(j-1)*dly
      call cofy (yj,dj,ej,fj)
      if (ai*dj .gt. 0.0) go to  10
      ierror = 10
      return
10 continue
   end do
end do
!
!     NO ERROR FOUND
!
ierror = 0
return
end subroutine chkprm

subroutine chksng (mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy, &
&singlr)
implicit none
integer :: mbdcnd, nbdcnd
real :: alpha, beta, gama, xnu
integer :: i, j
real :: ai, bi, ci, dj, ej, fj, xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS SUBROUTINE CHECKS IF THE PDE   SEPELL
!     MUST SOLVE IS A SINGULAR OPERATOR
!
logical :: singlr
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
singlr = .false.
!
!     CHECK IF THE BOUNDARY CONDITIONS ARE
!     ENTIRELY PERIODIC AND/OR MIXED
!
if ((mbdcnd.ne.0 .and. mbdcnd.ne.3) .or. &
&(nbdcnd.ne.0 .and. nbdcnd.ne.3)) return
!
!     CHECK THAT MIXED CONDITIONS ARE PURE NEUMAN
!
if (mbdcnd .ne. 3) go to  10
if (alpha.ne.0.0 .or. beta.ne.0.0) return
10 if (nbdcnd .ne. 3) go to  20
if (gama.ne.0.0 .or. xnu.ne.0.0) return
20 continue
!
!     CHECK THAT NON-DERIVATIVE COEFFICIENT FUNCTIONS
!     ARE ZERO
!
do i=is,ms
   xi = ait+float(i-1)*dlx
   call cofx (xi,ai,bi,ci)
   if (ci .ne. 0.0) return
end do
do j=js,ns
   yj = cit+float(j-1)*dly
   call cofy (yj,dj,ej,fj)
   if (fj .ne. 0.0) return
end do
!
!     THE OPERATOR MUST BE SINGULAR IF THIS POINT IS REACHED
!
singlr = .true.
return
end subroutine chksng

subroutine orthg (usol,idmn,zn,zm,pertrb)
implicit none
integer :: idmn
real :: pertrb, usol(idmn,*), zm(*), zn(*)
integer :: i, ifnl, ii, istr, j, jfnl, jj, jstr
real :: ete, ute
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS SUBROUTINE ORTHOGONALIZES THE ARRAY USOL WITH RESPECT TO
!     THE CONSTANT ARRAY IN A WEIGHTED LEAST SQUARES NORM
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
istr = is
ifnl = ms
jstr = js
jfnl = ns
!
!     COMPUTE WEIGHTED INNER PRODUCTS
!
ute = 0.0
ete = 0.0
do i=is,ms
   ii = i-is+1
   do j=js,ns
      jj = j-js+1
      ete = ete+zm(ii)*zn(jj)
      ute = ute+usol(i,j)*zm(ii)*zn(jj)
   end do
end do
!
!     SET PERTURBATION PARAMETER
!
pertrb = ute/ete
!
!     SUBTRACT OFF CONSTANT PERTRB
!
do i=istr,ifnl
   do j=jstr,jfnl
      usol(i,j) = usol(i,j)-pertrb
   end do
end do
return
end subroutine orthg

subroutine minsol (usol,idmn,zn,zm,pertb)
implicit none
integer :: idmn
real :: pertb, usol(idmn,*), zm(*), zn(*)
integer :: i, ifnl, ii, istr, j, jfnl, jj, jstr
real :: ete, pertrb, ute
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS SUBROUTINE ORTHOGONALIZES THE ARRAY USOL WITH RESPECT TO
!     THE CONSTANT ARRAY IN A WEIGHTED LEAST SQUARES NORM
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
!     ENTRY AT MINSOL OCCURRS WHEN THE FINAL SOLUTION IS
!     TO BE MINIMIZED WITH RESPECT TO THE WEIGHTED
!     LEAST SQUARES NORM
!
istr = 1
ifnl = k
jstr = 1
jfnl = l
!
!     COMPUTE WEIGHTED INNER PRODUCTS
!
ute = 0.0
ete = 0.0
do i=is,ms
   ii = i-is+1
   do j=js,ns
      jj = j-js+1
      ete = ete+zm(ii)*zn(jj)
      ute = ute+usol(i,j)*zm(ii)*zn(jj)
   end do
end do
!
!     SET PERTURBATION PARAMETER
!
pertrb = ute/ete
!
!     SUBTRACT OFF CONSTANT PERTRB
!
do i=istr,ifnl
   do j=jstr,jfnl
      usol(i,j) = usol(i,j)-pertrb
   end do
end do
return
end subroutine minsol

subroutine trisp (n,a,b,c,d,u,z)
implicit none
integer, intent(in) :: n
real :: a(n), b(n), c(n)
real, intent(inout) :: d(n), u(n), z(n)
integer :: j, k, nm1, nm2
real :: an, bn, den, v
!
!     THIS SUBROUTINE SOLVES FOR A NON-ZERO EIGENVECTOR CORRESPONDING
!     TO THE ZERO EIGENVALUE OF THE TRANSPOSE OF THE RANK
!     DEFICIENT ONE MATRIX WITH SUBDIAGONAL A, DIAGONAL B, AND
!     SUPERDIAGONAL C , WITH A(1) IN THE (1,N) POSITION, WITH
!     C(N) IN THE (N,1) POSITION, AND ALL OTHER ELEMENTS ZERO.
!
!
bn = b(n)
d(1) = a(2)/b(1)
v = a(1)
u(1) = c(n)/b(1)
nm2 = n-2
do j=2,nm2
   den = b(j)-c(j-1)*d(j-1)
   d(j) = a(j+1)/den
   u(j) = -c(j-1)*u(j-1)/den
   bn = bn-v*u(j-1)
   v = -v*d(j-1)
end do
den = b(n-1)-c(n-2)*d(n-2)
d(n-1) = (a(n)-c(n-2)*u(n-2))/den
an = c(n-1)-v*d(n-2)
bn = bn-v*u(n-2)
den = bn-an*d(n-1)
!
!     SET LAST COMPONENT EQUAL TO ONE
!
z(n) = 1.0
z(n-1) = -d(n-1)
nm1 = n-1
do j=2,nm1
   k = n-j
   z(k) = -d(k)*z(k+1)-u(k)*z(n)
end do
return
end subroutine trisp

subroutine defer (cofx,cofy,usol,idmn,grhs,mn)
implicit none
integer :: idmn, mn
real :: grhs(mn,*), usol(idmn,*)
integer :: i, j
real :: ai, bi, ci, dj, ej, fj, tx, ty, uxxx, uxxxx, uyyy, uyyyy, &
&xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS SUBROUTINE FIRST APPROXIMATES THE TRUNCATION ERROR GIVEN
!     BY  TRUN1(X,Y)=DLX**2*TX+DLY**2*TY WHERE
!     TX=AFUN(X)*UXXXX/12.0+BFUN(X)*UXXX/6.0 ON THE INTERIOR AND
!     AT THE BOUNDARIES IF PERIODIC (HERE UXXX,UXXXX ARE THE THIRD
!     AND FOURTH PARTIAL DERIVATIVES OF U WITH RESPECT TO X).
!     TX IS OF THE FORM AFUN(X)/3.0*(UXXXX/4.0+UXXX/DLX)
!     AT X=A OR X=B IF THE BOUNDARY CONDITION THERE IS MIXED.
!     TX=0.0 ALONG SPECIFIED BOUNDARIES.  TY HAS SYMMETRIC FORM
!     IN Y WITH X,AFUN(X),BFUN(X) REPLACED BY Y,DFUN(Y),EFUN(Y).
!     THE SECOND ORDER SOLUTION IN USOL IS USED TO APPROXIMATE
!     (VIA SECOND ORDER FINITE DIFFERENCING) THE TRUN1ATION ERROR
!     AND THE RESULT IS ADDED TO THE RIGHT HAND SIDE IN GRHS
!     AND THEN TRANSFERRED TO USOL TO BE USED AS A NEW RIGHT
!     HAND SIDE WHEN CALLING BLKTRI FOR A FOURTH ORDER SOLUTION.
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
!     COMPUTE TRUNCATION ERROR APPROXIMATION OVER THE ENTIRE MESH
!
do j=js,ns
   yj = cit+float(j-1)*dly
   call cofy (yj,dj,ej,fj)
   do i=is,ms
      xi = ait+float(i-1)*dlx
      call cofx (xi,ai,bi,ci)
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT (XI,YJ)
!
      call dxfn (usol,idmn,i,j,uxxx,uxxxx)
      call dyfn (usol,idmn,i,j,uyyy,uyyyy)
      tx = ai*uxxxx/12.0+bi*uxxx/6.0
      ty = dj*uyyyy/12.0+ej*uyyy/6.0
!
!     RESET FORM OF TRUNCATION IF AT BOUNDARY WHICH IS NON-PERIODIC
!
      if (kswx.eq.1 .or. (i.gt.1 .and. i.lt.k)) go to  10
      tx = ai/3.0*(uxxxx/4.0+uxxx/dlx)
10 if (kswy.eq.1 .or. (j.gt.1 .and. j.lt.l)) go to  20
      ty = dj/3.0*(uyyyy/4.0+uyyy/dly)
20 grhs(i,j) = grhs(i,j)+dlx**2*tx+dly**2*ty
   end do
end do
!
!     RESET THE RIGHT HAND SIDE IN USOL
!
do i=is,ms
   do j=js,ns
      usol(i,j) = grhs(i,j)
   end do
end do
return
end subroutine defer

subroutine dxfn (u,idmn,i,j,uxxx,uxxxx)
implicit none
integer :: i, idmn, j
real :: u(idmn,*), uxxx, uxxxx
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS PROGRAM COMPUTES SECOND ORDER FINITE DIFFERENCE
!     APPROXIMATIONS TO THE THIRD AND FOURTH X
!     PARTIAL DERIVATIVES OF U AT THE (I,J) MESH POINT
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
if (i.gt.2 .and. i.lt.(k-1)) go to  50
if (i .eq. 1) go to  10
if (i .eq. 2) go to  30
if (i .eq. k-1) go to  60
if (i .eq. k) go to  80
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT X=A
!
10 if (kswx .eq. 1) go to  20
uxxx = (-5.0*u(1,j)+18.0*u(2,j)-24.0*u(3,j)+14.0*u(4,j)- &
&3.0*u(5,j))/(tdlx3)
uxxxx = (3.0*u(1,j)-14.0*u(2,j)+26.0*u(3,j)-24.0*u(4,j)+ &
&11.0*u(5,j)-2.0*u(6,j))/dlx4
return
!
!     PERIODIC AT X=A
!
20 uxxx = (-u(k-2,j)+2.0*u(k-1,j)-2.0*u(2,j)+u(3,j))/(tdlx3)
uxxxx = (u(k-2,j)-4.0*u(k-1,j)+6.0*u(1,j)-4.0*u(2,j)+u(3,j))/dlx4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT X=A+DLX
!
30 if (kswx .eq. 1) go to  40
uxxx = (-3.0*u(1,j)+10.0*u(2,j)-12.0*u(3,j)+6.0*u(4,j)-u(5,j))/ &
&tdlx3
uxxxx = (2.0*u(1,j)-9.0*u(2,j)+16.0*u(3,j)-14.0*u(4,j)+6.0*u(5,j)- &
&u(6,j))/dlx4
return
!
!     PERIODIC AT X=A+DLX
!
40 uxxx = (-u(k-1,j)+2.0*u(1,j)-2.0*u(3,j)+u(4,j))/(tdlx3)
uxxxx = (u(k-1,j)-4.0*u(1,j)+6.0*u(2,j)-4.0*u(3,j)+u(4,j))/dlx4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS ON THE INTERIOR
!
50 continue
uxxx = (-u(i-2,j)+2.0*u(i-1,j)-2.0*u(i+1,j)+u(i+2,j))/tdlx3
uxxxx = (u(i-2,j)-4.0*u(i-1,j)+6.0*u(i,j)-4.0*u(i+1,j)+u(i+2,j))/ &
&dlx4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT X=B-DLX
!
60 if (kswx .eq. 1) go to  70
uxxx = (u(k-4,j)-6.0*u(k-3,j)+12.0*u(k-2,j)-10.0*u(k-1,j)+ &
&3.0*u(k,j))/tdlx3
uxxxx = (-u(k-5,j)+6.0*u(k-4,j)-14.0*u(k-3,j)+16.0*u(k-2,j)- &
&9.0*u(k-1,j)+2.0*u(k,j))/dlx4
return
!
!     PERIODIC AT X=B-DLX
!
70 uxxx = (-u(k-3,j)+2.0*u(k-2,j)-2.0*u(1,j)+u(2,j))/tdlx3
uxxxx = (u(k-3,j)-4.0*u(k-2,j)+6.0*u(k-1,j)-4.0*u(1,j)+u(2,j))/ &
&dlx4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT X=B
!
80 uxxx = -(3.0*u(k-4,j)-14.0*u(k-3,j)+24.0*u(k-2,j)-18.0*u(k-1,j)+ &
&5.0*u(k,j))/tdlx3
uxxxx = (-2.0*u(k-5,j)+11.0*u(k-4,j)-24.0*u(k-3,j)+26.0*u(k-2,j)- &
&14.0*u(k-1,j)+3.0*u(k,j))/dlx4
return
end subroutine dxfn

subroutine dyfn (u,idmn,i,j,uyyy,uyyyy)
implicit none
integer :: i, idmn, j
real :: u(idmn,*), uyyy, uyyyy
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS PROGRAM COMPUTES SECOND ORDER FINITE DIFFERENCE
!     APPROXIMATIONS TO THE THIRD AND FOURTH Y
!     PARTIAL DERIVATIVES OF U AT THE (I,J) MESH POINT
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
if (j.gt.2 .and. j.lt.(l-1)) go to  50
if (j .eq. 1) go to  10
if (j .eq. 2) go to  30
if (j .eq. l-1) go to  60
if (j .eq. l) go to  80
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT Y=C
!
10 if (kswy .eq. 1) go to  20
uyyy = (-5.0*u(i,1)+18.0*u(i,2)-24.0*u(i,3)+14.0*u(i,4)- &
&3.0*u(i,5))/tdly3
uyyyy = (3.0*u(i,1)-14.0*u(i,2)+26.0*u(i,3)-24.0*u(i,4)+ &
&11.0*u(i,5)-2.0*u(i,6))/dly4
return
!
!     PERIODIC AT X=A
!
20 uyyy = (-u(i,l-2)+2.0*u(i,l-1)-2.0*u(i,2)+u(i,3))/tdly3
uyyyy = (u(i,l-2)-4.0*u(i,l-1)+6.0*u(i,1)-4.0*u(i,2)+u(i,3))/dly4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT Y=C+DLY
!
30 if (kswy .eq. 1) go to  40
uyyy = (-3.0*u(i,1)+10.0*u(i,2)-12.0*u(i,3)+6.0*u(i,4)-u(i,5))/ &
&tdly3
uyyyy = (2.0*u(i,1)-9.0*u(i,2)+16.0*u(i,3)-14.0*u(i,4)+6.0*u(i,5)- &
&u(i,6))/dly4
return
!
!     PERIODIC AT Y=C+DLY
!
40 uyyy = (-u(i,l-1)+2.0*u(i,1)-2.0*u(i,3)+u(i,4))/tdly3
uyyyy = (u(i,l-1)-4.0*u(i,1)+6.0*u(i,2)-4.0*u(i,3)+u(i,4))/dly4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS ON THE INTERIOR
!
50 continue
uyyy = (-u(i,j-2)+2.0*u(i,j-1)-2.0*u(i,j+1)+u(i,j+2))/tdly3
uyyyy = (u(i,j-2)-4.0*u(i,j-1)+6.0*u(i,j)-4.0*u(i,j+1)+u(i,j+2))/ &
&dly4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT Y=D-DLY
!
60 if (kswy .eq. 1) go to  70
uyyy = (u(i,l-4)-6.0*u(i,l-3)+12.0*u(i,l-2)-10.0*u(i,l-1)+ &
&3.0*u(i,l))/tdly3
uyyyy = (-u(i,l-5)+6.0*u(i,l-4)-14.0*u(i,l-3)+16.0*u(i,l-2)- &
&9.0*u(i,l-1)+2.0*u(i,l))/dly4
return
!
!     PERIODIC AT Y=D-DLY
!
70 continue
uyyy = (-u(i,l-3)+2.0*u(i,l-2)-2.0*u(i,1)+u(i,2))/tdly3
uyyyy = (u(i,l-3)-4.0*u(i,l-2)+6.0*u(i,l-1)-4.0*u(i,1)+u(i,2))/ &
&dly4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT Y=D
!
80 uyyy = -(3.0*u(i,l-4)-14.0*u(i,l-3)+24.0*u(i,l-2)-18.0*u(i,l-1)+ &
&5.0*u(i,l))/tdly3
uyyyy = (-2.0*u(i,l-5)+11.0*u(i,l-4)-24.0*u(i,l-3)+26.0*u(i,l-2)- &
&14.0*u(i,l-1)+3.0*u(i,l))/dly4
return
end subroutine dyfn

subroutine blktri (iflg,np,n,an,bn,cn,mp,m,am,bm,cm,idimy,y, &
&ierror,w)
implicit none
integer :: idimy, ierror, iflg, m, mp, n, np
real :: am(*), an(*), bm(*), bn(*), cm(*), cn(*), w(*), y(idimy,*)
integer :: iw1, iw2, iw3, iwah, iwbh, iwd, iwu, iww, nh, nl
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
!
!
!***********************************************************************
!
!          VERSION  2  OCTOBER 1976  INCLUDING ERRATA  OCTOBER 1976
!
!         DOCUMENTATION FOR THIS PROGRAM IS GIVEN IN
!
!        EFFICIENT FORTRAN SUBPROGRAMS FOR THE SOLUTION OF
!            ELLIPTIC PARTIAL DIFFERENTIAL EQUATIONS
!
!                              BY
!
!          PAUL SWARZTRAUBER   AND  ROLAND SWEET
!
!             TECHNICAL NOTE TN/IA-109   JULY 1975
!
!       NATIONAL CENTER FOR ATMOSPHERIC RESEARCH  BOULDER,COLORADO 80307
!
!        WHICH IS SPONSORED BY THE NATIONAL SCIENCE FOUNDATION
!
!***********************************************************************
!
!
!
!     SUBROUTINE BLKTRI SOLVES A SYSTEM OF LINEAR EQUATIONS OF THE FORM
!
!          AN(J)*X(I,J-1) + AM(I)*X(I-1,J) + (BN(J)+BM(I))*X(I,J)
!
!          + CN(J)*X(I,J+1) + CM(I)*X(I+1,J) = Y(I,J)
!
!               FOR I = 1,2,...,M  AND  J = 1,2,...,N.
!
!     I+1 AND I-1 ARE EVALUATED MODULO M AND J+1 AND J-1 MODULO N, I.E.,
!
!          X(I,0) = X(I,N),  X(I,N+1) = X(I,1),
!          X(0,J) = X(M,J),  X(M+1,J) = X(1,J).
!
!     THESE EQUATIONS USUALLY RESULT FROM THE DISCRETIZATION OF
!     SEPARABLE ELLIPTIC EQUATIONS.  BOUNDARY CONDITIONS MAY BE
!     DIRICHLET, NEUMANN, OR PERIODIC.
!
!
!     * * * * * * * * * *     ON INPUT     * * * * * * * * * *
!
!     IFLG
!       = 0  INITIALIZATION ONLY.  CERTAIN QUANTITIES THAT DEPEND ON NP,
!                                  N, AN, BN, AND CN ARE COMPUTED AND
!                                  STOR1D IN THE WORK ARRAY  W.
!       = 1  THE QUANTITIES THAT WERE COMPUTED IN THE INITIALIZATION ARE
!            USED TO OBTAIN THE SOLUTION X(I,J).
!
!       NOTE   A CALL WITH IFLG=0 TAKES APPROXIMATELY ONE HALF THE TIME
!              TIME AS A CALL WITH IFLG = 1  .  HOWEVER, THE
!              INITIALIZATION DOES NOT HAVE TO BE REPEATED UNLESS NP, N,
!              AN, BN, OR CN CHANGE.
!
!     NP
!       = 0  IF AN(1) AND CN(N) ARE NOT ZERO, WHICH CORRESPONDS TO
!            PERIODIC BOUNARY CONDITIONS.
!       = 1  IF AN(1) AND CN(N) ARE ZERO.
!
!     N
!       THE NUMBER OF UNKNOWNS IN THE J-DIRECTION. N MUST BE GREATER
!       THAN 2. THE OPERATION COUNT IS PROPORTIONAL TO MNLOG2(N), HENCE
!       N SHOULD BE SELECTED LESS THAN OR EQUAL TO M.
!
!     AN,BN,CN
!       ONE-DIMENSIONAL ARRAYS OF LENGTH N THAT SPECIFY THE COEFFICIENTS
!       IN THE LINEAR EQUATIONS GIVEN ABOVE.
!
!     MP
!       = 0  IF AM(1) AND CM(M) ARE NOT ZERO, WHICH CORRESPONDS TO
!            PERIODIC BOUNDARY CONDITIONS.
!       = 1  IF AM(1) = CM(M) = 0  .
!
!     M
!       THE NUMBER OF UNKNOWNS IN THE I-DIRECTION. M MUST BE GREATER
!       THAN 2.
!
!     AM,BM,CM
!       ONE-DIMENSIONAL ARRAYS OF LENGTH M THAT SPECIFY THE COEFFICIENTS
!       IN THE LINEAR EQUATIONS GIVEN ABOVE.
!
!     IDIMY
!       THE ROW (OR FIRST) DIMENSION OF THE TWO-DIMENSIONAL ARRAY Y AS
!       IT APPEARS IN THE PROGRAM CALLING BLKTRI.  THIS PARAMETER IS
!       USED TO SPECIFY THE VARIABLE DIMENSION OF Y.  IDIMY MUST BE AT
!       LEAST M.
!
!     Y
!       A TWO-DIMENSIONAL ARRAY THAT SPECIFIES THE VALUES OF THE RIGHT
!       SIDE OF THE LINEAR SYSTEM OF EQUATIONS GIVEN ABOVE.  Y MUST BE
!       DIMENSIONED AT LEAST M*N.
!
!     W
!       A ONE-DIMENSIONAL ARRAY THAT MUST BE PROVIDED BY THE USER FOR
!       WORK SPACE.
!             IF NP=1 DEFINE K=INT(LOG2(N))+1 AND SET L=2**(K+1) THEN
!                     W MUST HAVE DIMENSION (K-2)*L+K+4+MAX(2N,6M)
!
!             IF NP=0 DEFINE K=INT(LOG2(N-1))+1 AND SET L=2**(K+1) THEN
!                     W MUST HAVE DIMENSION (K-2)*L+K+4+2N+MAX(2N,6M)
!
!       **IMPORTANT** FOR PURPOSES OF CHECKING, THE REQUIRED DIMENSION
!                     OF W IS COMPUTED BY BLKTRI AND STOR1D IN W(1)
!                     IN FLOATING POINT FORMAT.
!
!     * * * * * * * * * *     ON OUTPUT     * * * * * * * * * *
!
!     Y
!       CONTAINS THE SOLUTION X.
!
!     IERROR
!       AN ERROR FLAG THAT INDICATES INVALID INPUT PARAMETERS.  EXCEPT
!       FOR NUMBER ZERO, A SOLUTION IS NOT ATTEMPTED.
!
!       = 0  NO ERROR.
!       = 1  M IS LESS THAN 5
!       = 2  N IS LESS THAN 3.
!       = 3  IDIMY IS LESS THAN M.
!       = 4  BLKTRI FAILED WHILE COMPUTING RESULTS THAT DEPEND ON THE
!            COEFFICIENT ARRAYS AN, BN, CN.  CHECK THESE ARRAYS.
!       = 5  AN(J)*CN(J-1) IS LESS THAN 0 FOR SOME J. POSSIBLE REASONS
!            FOR THIS CONDITION ARE
!            1. THE ARRAYS AN AND CN ARE NOT CORRECT
!            2. TOO LARGE A GRID SPACING WAS USED IN THE DISCRETIZATION
!               OF THE ELLIPTIC EQUATION
!            3. THE LINEAR EQUATIONS RESULTED FROM A PARTIAL
!               DIFFERENTIAL EQUATION WHICH WAS NOT ELLIPTIC
!
!     W
!       CONTAINS INTERMEDIATE VALUES THAT MUST NOT BE DESTROYED IF
!       BLKTRI WILL BE CALLED AGAIN WITH IFLG = 1  .
!
!
!
external        prod0      ,prodp      ,cprod0     ,cprodp
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
! TEST M AND N FOR THE PROPER FORM
!
nm = n
ierror = 0
if (m-5)  10, 20, 20
10 ierror = 1
go to 190
20 if (nm-3)  30, 40, 40
30 ierror = 2
go to 190
40 if (idimy-m)  50, 60, 60
50 ierror = 3
go to 190
60 nh = n
npp = np
if (npp)  70, 80, 70
70 nh = nh+1
80 ik = 2
k = 1
90 ik = ik+ik
k = k+1
if (nh-ik) 100,100, 90
100 nl = ik
ik = ik+ik
nl = nl-1
iwah = (k-2)*ik+k+6
if (npp) 110,120,110
!
!     DIVIDE W INTO WORKING SUB ARRAYS
!
110 iw1 = iwah
iwbh = iw1+nm
w(1) = float(iw1-1+max0(2*nm,6*m))
go to 130
120 iwbh = iwah+nm+nm
iw1 = iwbh
w(1) = float(iw1-1+max0(2*nm,6*m))
nm = nm-1
!
! SUBROUTINE COMPB COMPUTES THE ROOTS OF THE B POLYNOMIALS
!
130 if (ierror) 190,140,190
140 iw2 = iw1+m
iw3 = iw2+m
iwd = iw3+m
iww = iwd+m
iwu = iww+m
if (iflg) 160,150,160
150 call compb (nl,ierror,an,bn,cn,w(2),w(iwah),w(iwbh))
go to 190
160 if (mp) 170,180,170
!
! SUBROUTINE BLKTR1 SOLVES THE LINEAR SYSTEM
!
170 call blktr1 (nl,an,bn,cn,m,am,bm,cm,idimy,y,w(2),w(iw1),w(iw2), &
&w(iw3),w(iwd),w(iww),w(iwu),prod0,cprod0)
go to 190
180 call blktr1 (nl,an,bn,cn,m,am,bm,cm,idimy,y,w(2),w(iw1),w(iw2), &
&w(iw3),w(iwd),w(iww),w(iwu),prodp,cprodp)
190 continue
return
end subroutine blktri

subroutine blktr1 (n,an,bn,cn,m,am,bm,cm,idimy,y,b,w1,w2,w3,wd, &
&ww,wu,prdct,cprdct)
implicit none
integer :: idimy, m, n
real :: am(*), an(*), b(*), bm(*), bn(*), cm(*), cn(*), w1(*), &
&w2(*), w3(*), wd(*), wu(*), ww(*), y(idimy,*)
integer :: i, i1, i2, i3, i4, idxa, idxc, if, ifd, im1, im2, im3, &
&imi1, imi2, ip, ip1, ip2, ip3, ipi1, ipi2, ipi3, ir, irm1, iz, &
&izr, j, kdo, l, ll, na, nc, nm1, nm2, nm3, np, np1, np2, np3, nz
real :: dum
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
!
! BLKTR1 SOLVES THE LINEAR SYSTEM
!
! B  CONTAINS THE ROOTS OF ALL THE B POLYNOMIALS
! W1,W2,W3,WD,WW,WU  ARE ALL WORKING ARRAYS
! PRDCT IS EITHER PRODP OR PROD0 DEPENDING ON WHETHER THE BOUNDARY
! CONDITIONS IN THE M DIRECTION ARE PERIODIC OR NOT
! CPRDCT IS EITHER CPRODP OR CPROD0 WHICH ARE THE COMPLEX VERSIONS
! OF PRODP AND PROD0. THESE ARE CALLED IN THE EVENT THAT SOME
! OF THE ROOTS OF THE B SUB P POLYNOMIAL ARE COMPLEX
!
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
! BEGIN REDUCTION PHASE
!
kdo = k-1
do l=1,kdo
   ir = l-1
   i2 = 2**ir
   i1 = i2/2
   i3 = i2+i1
   i4 = i2+i2
   irm1 = ir-1
   call indxb (i2,ir,im2,nm2)
   call indxb (i1,irm1,im3,nm3)
   call indxb (i3,irm1,im1,nm1)
   call prdct (nm2,b(im2),nm3,b(im3),nm1,b(im1),0,dum,y(1,i2),w3, &
&m,am,bm,cm,wd,ww,wu)
   if = 2**k
   do 80 i = i4,if,i4
      if (i-nm)  10, 10, 80
10 ipi1 = i+i1
      ipi2 = i+i2
      ipi3 = i+i3
      call indxc (i,ir,idxc,nc)
      if (i-if)  20, 80, 80
20 call indxa (i,ir,idxa,na)
      call indxb (i-i1,irm1,im1,nm1)
      call indxb (ipi2,ir,ip2,np2)
      call indxb (ipi1,irm1,ip1,np1)
      call indxb (ipi3,irm1,ip3,np3)
      call prdct (nm1,b(im1),0,dum,0,dum,na,an(idxa),w3,w1,m,am, &
&bm,cm,wd,ww,wu)
      if (ipi2-nm)  50, 50, 30
30 do j=1,m
         w3(j) = 0.
         w2(j) = 0.
      end do
      go to  60
50 call prdct (np2,b(ip2),np1,b(ip1),np3,b(ip3),0,dum, &
&y(1,ipi2),w3,m,am,bm,cm,wd,ww,wu)
      call prdct (np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w3,w2,m,am, &
&bm,cm,wd,ww,wu)
60 do j=1,m
         y(j,i) = w1(j)+w2(j)+y(j,i)
      end do
80 continue
end do
if (npp) 320,100,320
!
!     THE PERIODIC CASE IS TREATED USING THE CAPACITANCE MATRIX METHOD
!
100 if = 2**k
i = if/2
i1 = i/2
call indxb (i-i1,k-2,im1,nm1)
call indxb (i+i1,k-2,ip1,np1)
call indxb (i,k-1,iz,nz)
call prdct (nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,y(1,i),w1,m,am, &
&bm,cm,wd,ww,wu)
izr = i
do j=1,m
   w2(j) = w1(j)
end do
do ll=2,k
   l = k-ll+1
   ir = l-1
   i2 = 2**ir
   i1 = i2/2
   i = i2
   call indxc (i,ir,idxc,nc)
   call indxb (i,ir,iz,nz)
   call indxb (i-i1,ir-1,im1,nm1)
   call indxb (i+i1,ir-1,ip1,np1)
   call prdct (np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w1,w1,m,am,bm, &
&cm,wd,ww,wu)
   do j=1,m
      w1(j) = y(j,i)+w1(j)
   end do
   call prdct (nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w1,w1,m,am, &
&bm,cm,wd,ww,wu)
end do
do 180 ll = 2,k
   l = k-ll+1
   ir = l-1
   i2 = 2**ir
   i1 = i2/2
   i4 = i2+i2
   ifd = if-i2
   do 170 i = i2,ifd,i4
      if (i-i2-izr) 170,140,170
140 if (i-nm) 150,150,180
150 call indxa (i,ir,idxa,na)
      call indxb (i,ir,iz,nz)
      call indxb (i-i1,ir-1,im1,nm1)
      call indxb (i+i1,ir-1,ip1,np1)
      call prdct (nm1,b(im1),0,dum,0,dum,na,an(idxa),w2,w2,m,am, &
&bm,cm,wd,ww,wu)
      do j=1,m
         w2(j) = y(j,i)+w2(j)
      end do
      call prdct (nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w2,w2,m, &
&am,bm,cm,wd,ww,wu)
      izr = i
      if (i-nm) 170,190,170
170 continue
180 continue
190 do j=1,m
   y(j,nm+1) = y(j,nm+1)-cn(nm+1)*w1(j)-an(nm+1)*w2(j)
end do
call indxb (if/2,k-1,im1,nm1)
call indxb (if,k-1,ip,np)
if (ncmplx) 210,220,210
210 call cprdct (nm+1,b(ip),nm1,b(im1),0,dum,0,dum,y(1,nm+1), &
&y(1,nm+1),m,am,bm,cm,w1,w3,ww)
go to 230
220 call prdct (nm+1,b(ip),nm1,b(im1),0,dum,0,dum,y(1,nm+1), &
&y(1,nm+1),m,am,bm,cm,wd,ww,wu)
230 do j=1,m
   w1(j) = an(1)*y(j,nm+1)
   w2(j) = cn(nm)*y(j,nm+1)
   y(j,1) = y(j,1)-w1(j)
   y(j,nm) = y(j,nm)-w2(j)
end do
do l=1,kdo
   ir = l-1
   i2 = 2**ir
   i4 = i2+i2
   i1 = i2/2
   i = i4
   call indxa (i,ir,idxa,na)
   call indxb (i-i2,ir,im2,nm2)
   call indxb (i-i2-i1,ir-1,im3,nm3)
   call indxb (i-i1,ir-1,im1,nm1)
   call prdct (nm2,b(im2),nm3,b(im3),nm1,b(im1),0,dum,w1,w1,m,am, &
&bm,cm,wd,ww,wu)
   call prdct (nm1,b(im1),0,dum,0,dum,na,an(idxa),w1,w1,m,am,bm, &
&cm,wd,ww,wu)
   do j=1,m
      y(j,i) = y(j,i)-w1(j)
   end do
end do
!
izr = nm
do 310 l = 1,kdo
   ir = l-1
   i2 = 2**ir
   i1 = i2/2
   i3 = i2+i1
   i4 = i2+i2
   irm1 = ir-1
   do 300 i = i4,if,i4
      ipi1 = i+i1
      ipi2 = i+i2
      ipi3 = i+i3
      if (ipi2-izr) 270,280,270
270 if (i-izr) 300,310,300
280 call indxc (i,ir,idxc,nc)
      call indxb (ipi2,ir,ip2,np2)
      call indxb (ipi1,irm1,ip1,np1)
      call indxb (ipi3,irm1,ip3,np3)
      call prdct (np2,b(ip2),np1,b(ip1),np3,b(ip3),0,dum,w2,w2,m, &
&am,bm,cm,wd,ww,wu)
      call prdct (np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w2,w2,m,am, &
&bm,cm,wd,ww,wu)
      do j=1,m
         y(j,i) = y(j,i)-w2(j)
      end do
      izr = i
      go to 310
300 continue
310 continue
!
! BEGIN BACK SUBSTITUTION PHASE
!
320 do ll=1,k
   l = k-ll+1
   ir = l-1
   irm1 = ir-1
   i2 = 2**ir
   i1 = i2/2
   i4 = i2+i2
   ifd = if-i2
   do 430 i = i2,ifd,i4
      if (i-nm) 330,330,430
330 imi1 = i-i1
      imi2 = i-i2
      ipi1 = i+i1
      ipi2 = i+i2
      call indxa (i,ir,idxa,na)
      call indxc (i,ir,idxc,nc)
      call indxb (i,ir,iz,nz)
      call indxb (imi1,irm1,im1,nm1)
      call indxb (ipi1,irm1,ip1,np1)
      if (i-i2) 340,340,360
340 do j=1,m
         w1(j) = 0.
      end do
      go to 370
360 call prdct (nm1,b(im1),0,dum,0,dum,na,an(idxa),y(1,imi2), &
&w1,m,am,bm,cm,wd,ww,wu)
370 if (ipi2-nm) 400,400,380
380 do j=1,m
         w2(j) = 0.
      end do
      go to 410
400 call prdct (np1,b(ip1),0,dum,0,dum,nc,cn(idxc),y(1,ipi2), &
&w2,m,am,bm,cm,wd,ww,wu)
410 do j=1,m
         w1(j) = y(j,i)+w1(j)+w2(j)
      end do
      call prdct (nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w1,y(1,i), &
&m,am,bm,cm,wd,ww,wu)
430 continue
end do
return
end subroutine blktr1

subroutine indxa (i,ir,idxa,na)
implicit none
integer :: i, idxa, ir, na
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
na = 2**ir
idxa = i-na+1
if (i-nm)  20, 20, 10
10 na = 0
20 return
end subroutine indxa

subroutine indxc (i,ir,idxc,nc)
implicit none
integer :: i, idxc, ir, nc
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
nc = 2**ir
idxc = i
if (idxc+nc-1-nm)  20, 20, 10
10 nc = 0
20 return
end subroutine indxc

subroutine indxb (i,ir,idx,idp)
implicit none
integer :: i, idp, idx, ir
integer :: id, ipl, izh
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
!
! B(IDX) IS THE LOCATION OF THE FIRST ROOT OF THE B(I,IR) POLYNOMIAL
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
idp = 0
if (ir)  70, 10, 30
10 if (i-nm)  20, 20, 70
20 idx = i
idp = 1
return
30 izh = 2**ir
id = i-izh-izh
idx = id+id+(ir-1)*ik+ir+(ik-i)/izh+4
ipl = izh-1
idp = izh+izh-1
if (i-ipl-nm)  50, 50, 40
40 idp = 0
return
50 if (i+ipl-nm)  70, 70, 60
60 idp = nm+ipl-i+1
70 return
end subroutine indxb

subroutine prod0 (nd,bd,nm1,bm1,nm2,bm2,na,aa,x,y,m,a,b,c,d,w,u)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bd(*), bm1(*), bm2(*), c(*)
real, intent(inout) :: d(*)
real :: u(*)
real, intent(inout) :: w(*)
real :: x(*)
real, intent(inout) :: y(*)
integer :: ia, ibr, id, j, k, m1, m2, mm
real :: den, rt
!
! PROD0 APPLIES A SEQUENCE OF MATRIX OPERATIONS TO THE VECTOR X AND
! STORES THE RESULT IN Y.
!
! BD,BM1,BM2 ARRAYS CONTAINING ROOTS OF CERTIAN B POLYNOMIALS.
! ND,NM1,NM2 THE LENGTHS OF THE ARRAYS BD,BM1,BM2 RESPECTIVELY.
! AA         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR X.
! NA         THE LENGTH OF THE ARRAY AA.
! X,Y        MATRIX OPERATIONS ARE APPLIED TO X AND THE RESULT IS Y.
! A,B,C      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! M          THE ORDER OF THE MATRIX.
! D,W,U      WORKING ARRAYS.
! IS         DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
!
do j=1,m
   w(j) = x(j)
   y(j) = w(j)
end do
mm = m-1
id = nd
ibr = 0
m1 = nm1
m2 = nm2
ia = na
20 if (ia)  50, 50, 30
30 rt = aa(ia)
if (nd .eq. 0) rt = -rt
ia = ia-1
!
! SCALAR MULTIPLICATION
!
do j=1,m
   y(j) = rt*w(j)
end do
50 if (id) 250,250, 60
60 rt = bd(id)
id = id-1
if (id .eq. 0) ibr = 1
!
! BEGIN SOLUTION TO SYSTEM
!
d(m) = a(m)/(b(m)-rt)
w(m) = y(m)/(b(m)-rt)
do j=2,mm
   k = m-j
   den = b(k+1)-rt-c(k+1)*d(k+2)
   d(k+1) = a(k+1)/den
   w(k+1) = (y(k+1)-c(k+1)*w(k+2))/den
end do
den = b(1)-rt-c(1)*d(2)
w(1) = 1.
if (den)  80, 90, 80
80 w(1) = (y(1)-c(1)*w(2))/den
90 do j=2,m
   w(j) = w(j)-d(j)*w(j-1)
end do
if (na) 130,130, 20
110 do j=1,m
   y(j) = w(j)
end do
ibr = 1
go to  20
130 if (m1) 140,140,150
140 if (m2) 110,110,200
150 if (m2) 170,170,160
160 if (abs(bm1(m1))-abs(bm2(m2))) 200,200,170
170 if (ibr) 180,180,190
180 if (abs(bm1(m1)-bd(id))-abs(bm1(m1)-rt)) 110,190,190
190 rt = rt-bm1(m1)
m1 = m1-1
go to 230
200 if (ibr) 210,210,220
210 if (abs(bm2(m2)-bd(id))-abs(bm2(m2)-rt)) 110,220,220
220 rt = rt-bm2(m2)
m2 = m2-1
230 do j=1,m
   y(j) = y(j)+rt*w(j)
end do
go to  20
250 return
end subroutine prod0

subroutine prodp (nd,bd,nm1,bm1,nm2,bm2,na,aa,x,y,m,a,b,c,d,u,w)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bd(*), bm1(*), bm2(*), c(*)
real, intent(inout) :: d(*), u(*), w(*)
real :: x(*)
real, intent(inout) :: y(*)
integer :: ia, ibr, id, j, k, m1, m2, mm, mm2
real :: am, bh, den, rt, v, ym
!
! PRODP APPLIES A SEQUENCE OF MATRIX OPERATIONS TO THE VECTOR X AND
! STORES THE RESULT IN Y.   (PERIODIC BOUNDARY CONDITIONS)
!
! BD,BM1,BM2 ARRAYS CONTAINING ROOTS OF CERTIAN B POLYNOMIALS.
! ND,NM1,NM2 THE LENGTHS OF THE ARRAYS BD,BM1,BM2 RESPECTIVELY.
! AA         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR X.
! NA         LENGTH OF THE ARRAY AA.
! X,Y        MATRIX OPERATIONS ARE APPLIED TO X AND THE RESULT IS Y.
! A,B,C      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! M          THE ORDER OF THE MATRIX.
! D,U,W      WORKING ARRAYS.
! IS         DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
!
do j=1,m
   y(j) = x(j)
   w(j) = y(j)
end do
mm = m-1
mm2 = m-2
id = nd
ibr = 0
m1 = nm1
m2 = nm2
ia = na
20 if (ia)  50, 50, 30
30 rt = aa(ia)
if (nd .eq. 0) rt = -rt
ia = ia-1
do j=1,m
   y(j) = rt*w(j)
end do
50 if (id) 280,280, 60
60 rt = bd(id)
id = id-1
if (id .eq. 0) ibr = 1
!
! BEGIN SOLUTION TO SYSTEM
!
bh = b(m)-rt
ym = y(m)
den = b(1)-rt
d(1) = c(1)/den
u(1) = a(1)/den
w(1) = y(1)/den
v = c(m)
if (mm2-2)  90, 70, 70
70 do j=2,mm2
   den = b(j)-rt-a(j)*d(j-1)
   d(j) = c(j)/den
   u(j) = -a(j)*u(j-1)/den
   w(j) = (y(j)-a(j)*w(j-1))/den
   bh = bh-v*u(j-1)
   ym = ym-v*w(j-1)
   v = -v*d(j-1)
end do
90 den = b(m-1)-rt-a(m-1)*d(m-2)
d(m-1) = (c(m-1)-a(m-1)*u(m-2))/den
w(m-1) = (y(m-1)-a(m-1)*w(m-2))/den
am = a(m)-v*d(m-2)
bh = bh-v*u(m-2)
ym = ym-v*w(m-2)
den = bh-am*d(m-1)
if (den) 100,110,100
100 w(m) = (ym-am*w(m-1))/den
go to 120
110 w(m) = 1.
120 w(m-1) = w(m-1)-d(m-1)*w(m)
do j=2,mm
   k = m-j
   w(k) = w(k)-d(k)*w(k+1)-u(k)*w(m)
end do
if (na) 160,160, 20
140 do j=1,m
   y(j) = w(j)
end do
ibr = 1
go to  20
160 if (m1) 170,170,180
170 if (m2) 140,140,230
180 if (m2) 200,200,190
190 if (abs(bm1(m1))-abs(bm2(m2))) 230,230,200
200 if (ibr) 210,210,220
210 if (abs(bm1(m1)-bd(id))-abs(bm1(m1)-rt)) 140,220,220
220 rt = rt-bm1(m1)
m1 = m1-1
go to 260
230 if (ibr) 240,240,250
240 if (abs(bm2(m2)-bd(id))-abs(bm2(m2)-rt)) 140,250,250
250 rt = rt-bm2(m2)
m2 = m2-1
260 do j=1,m
   y(j) = y(j)+rt*w(j)
end do
go to  20
280 return
end subroutine prodp

subroutine cprod0(nd,bd,nm1,bm1,nm2,bm2,na,aa,x,yy,m,a,b,c,d,w,y)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bm1(*), bm2(*), c(*), x(*)
real, intent(inout) :: yy(*)
integer :: ia, id, iflg, j, k, m1, m2, mm
real :: rt
!
! CPROD0 APPLIES A SEQUENCE OF MATRIX OPERATIONS TO THE VECTOR X AND
! STORES THE RESULT IN YY.   (COMPLEX CASE)
!
! AA         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR X.
! ND,NM1,NM2 THE LENGTHS OF THE ARRAYS BD,BM1,BM2 RESPECTIVELY.
! BD,BM1,BM2 ARRAYS CONTAINING ROOTS OF CERTIAN B POLYNOMIALS.
! NA         THE LENGTH OF THE ARRAY AA.
! X,YY       MATRIX OPERATIONS ARE APPLIED TO X AND THE RESULT IS YY.
! A,B,C      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! M          THE ORDER OF THE MATRIX.
! D,W,Y      WORKING ARRAYS.
! ISGN       DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
complex, intent(inout) :: y(*), d(*), w(*)
complex :: bd(*), crt, den, y1, y2
!
do j=1,m
   y(j) = cmplx(x(j),0.)
end do
mm = m-1
id = nd
m1 = nm1
m2 = nm2
ia = na
20 iflg = 0
if (id)  90, 90, 30
30 crt = bd(id)
id = id-1
!
! BEGIN SOLUTION TO SYSTEM
!
d(m) = a(m)/(b(m)-crt)
w(m) = y(m)/(b(m)-crt)
do j=2,mm
   k = m-j
   den = b(k+1)-crt-c(k+1)*d(k+2)
   d(k+1) = a(k+1)/den
   w(k+1) = (y(k+1)-c(k+1)*w(k+2))/den
end do
den = b(1)-crt-c(1)*d(2)
if (cabs(den))  50, 60, 50
50 y(1) = (y(1)-c(1)*w(2))/den
go to  70
60 y(1) = (1.,0.)
70 do j=2,m
   y(j) = w(j)-d(j)*y(j-1)
end do
90 if (m1) 100,100,120
100 if (m2) 210,210,110
110 rt = bm2(m2)
m2 = m2-1
go to 170
120 if (m2) 130,130,140
130 rt = bm1(m1)
m1 = m1-1
go to 170
140 if (abs(bm1(m1))-abs(bm2(m2))) 160,160,150
150 rt = bm1(m1)
m1 = m1-1
go to 170
160 rt = bm2(m2)
m2 = m2-1
170 y1 = (b(1)-rt)*y(1)+c(1)*y(2)
if (mm-2) 200,180,180
!
! MATRIX MULTIPLICATION
!
180 do j=2,mm
   y2 = a(j)*y(j-1)+(b(j)-rt)*y(j)+c(j)*y(j+1)
   y(j-1) = y1
   y1 = y2
end do
200 y(m) = a(m)*y(m-1)+(b(m)-rt)*y(m)
y(m-1) = y1
iflg = 1
go to  20
210 if (ia) 240,240,220
220 rt = aa(ia)
ia = ia-1
iflg = 1
!
! SCALAR MULTIPLICATION
!
do j=1,m
   y(j) = rt*y(j)
end do
240 if (iflg) 250,250, 20
250 do j=1,m
   yy(j) = real(y(j))
end do
return
end subroutine cprod0

subroutine cprodp (nd,bd,nm1,bm1,nm2,bm2,na,aa,x,yy,m,a,b,c,d,u,y)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bm1(*), bm2(*), c(*), x(*)
real, intent(inout) :: yy(*)
integer :: ia, id, iflg, j, k, m1, m2, mm, mm2
real :: rt
!
! PRODP APPLIES A SEQUENCE OF MATRIX OPERATIONS TO THE VECTOR X AND
! STORES THE RESULT IN YY.  (PERIODIC BOUNDARY CONDITIONS AND
! COMPLEX CASE)
!
! BD,BM1,BM2 ARRAYS CONTAINING ROOTS OF CERTIAN B POLYNOMIALS.
! ND,NM1,NM2 THE LENGTHS OF THE ARRAYS BD,BM1,BM2 RESPECTIVELY.
! AA         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR X.
! NA         THE LENGTH OF THE ARRAY AA.
! X,YY       MATRIX OPERATIONS ARE APPLIED TO X AND THE RESULT IS YY.
! A,B,C      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! M          THE ORDER OF THE MATRIX.
! D,U,Y      WORKING ARRAYS.
! ISGN       DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
complex, intent(inout) :: y(*), d(*), u(*)
complex :: v, den, bh, ym, am, y1, y2, yh, bd(*), crt
!
do j=1,m
   y(j) = cmplx(x(j),0.)
end do
mm = m-1
mm2 = m-2
id = nd
m1 = nm1
m2 = nm2
ia = na
20 iflg = 0
if (id) 110,110, 30
30 crt = bd(id)
id = id-1
iflg = 1
!
! BEGIN SOLUTION TO SYSTEM
!
bh = b(m)-crt
ym = y(m)
den = b(1)-crt
d(1) = c(1)/den
u(1) = a(1)/den
y(1) = y(1)/den
v = cmplx(c(m),0.)
if (mm2-2)  60, 40, 40
40 do j=2,mm2
   den = b(j)-crt-a(j)*d(j-1)
   d(j) = c(j)/den
   u(j) = -a(j)*u(j-1)/den
   y(j) = (y(j)-a(j)*y(j-1))/den
   bh = bh-v*u(j-1)
   ym = ym-v*y(j-1)
   v = -v*d(j-1)
end do
60 den = b(m-1)-crt-a(m-1)*d(m-2)
d(m-1) = (c(m-1)-a(m-1)*u(m-2))/den
y(m-1) = (y(m-1)-a(m-1)*y(m-2))/den
am = a(m)-v*d(m-2)
bh = bh-v*u(m-2)
ym = ym-v*y(m-2)
den = bh-am*d(m-1)
if (cabs(den))  70, 80, 70
70 y(m) = (ym-am*y(m-1))/den
go to  90
80 y(m) = (1.,0.)
90 y(m-1) = y(m-1)-d(m-1)*y(m)
do j=2,mm
   k = m-j
   y(k) = y(k)-d(k)*y(k+1)-u(k)*y(m)
end do
110 if (m1) 120,120,140
120 if (m2) 230,230,130
130 rt = bm2(m2)
m2 = m2-1
go to 190
140 if (m2) 150,150,160
150 rt = bm1(m1)
m1 = m1-1
go to 190
160 if (abs(bm1(m1))-abs(bm2(m2))) 180,180,170
170 rt = bm1(m1)
m1 = m1-1
go to 190
180 rt = bm2(m2)
m2 = m2-1
!
! MATRIX MULTIPLICATION
!
190 yh = y(1)
y1 = (b(1)-rt)*y(1)+c(1)*y(2)+a(1)*y(m)
if (mm-2) 220,200,200
200 do j=2,mm
   y2 = a(j)*y(j-1)+(b(j)-rt)*y(j)+c(j)*y(j+1)
   y(j-1) = y1
   y1 = y2
end do
220 y(m) = a(m)*y(m-1)+(b(m)-rt)*y(m)+c(m)*yh
y(m-1) = y1
iflg = 1
go to  20
230 if (ia) 260,260,240
240 rt = aa(ia)
ia = ia-1
iflg = 1
!
! SCALAR MULTIPLICATION
!
do j=1,m
   y(j) = rt*y(j)
end do
260 if (iflg) 270,270, 20
270 do j=1,m
   yy(j) = real(y(j))
end do
return
end subroutine cprodp

subroutine compb (n,ierror,an,bn,cn,b,ah,bh)
implicit none
integer :: ierror, n
real :: ah(*), an(*), b(*), bh(*), bn(*), cn(*)
integer :: i, i2, i4, ib, if, ifd, ipl, ir, j, j1, j2, jf, js, &
&kdo, l, l1, l2, lh, ls, n2m2, nb, nmp
real :: arg, bnorm, d1, d2, d3
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
real :: spmpar
!
!     COMPB COMPUTES THE ROOTS OF THE B POLYNOMIALS USING TQLRT0,
!     WHICH IS A MODIFICATION OF THE EISPACK SUBROUTINE TQLRAT.
!     IERROR IS SET TO 4 IF EITHER TQLRT0 FAILS OR A(J+1)*C(J) IS
!     LESS THAN 0 FOR SOME J. AH AND BH ARE TEMPORARY WORK ARRAYS.
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
eps = spmpar(1)
bnorm = abs(bn(1))
do j=2,nm
   bnorm = amax1(bnorm,abs(bn(j)))
   arg = an(j)*cn(j-1)
   if (arg) 220, 30, 30
30 b(j) = sign(sqrt(arg),an(j))
end do
cnv = eps*bnorm
if = 2**k
kdo = k-1
do 100 l = 1,kdo
   ir = l-1
   i2 = 2**ir
   i4 = i2+i2
   ipl = i4-1
   ifd = if-i4
   do i=i4,ifd,i4
      call indxb (i,l,ib,nb)
      if (nb) 100,100, 50
50 js = i-ipl
      jf = js+nb-1
      ls = 0
      do j=js,jf
         ls = ls+1
         bh(ls) = bn(j)
         ah(ls) = b(j)
      end do
      call tqlrt0 (nb,bh,ah,ierror)
      if (ierror) 210, 70,210
70 lh = ib-1
      do j=1,nb
         lh = lh+1
         b(lh) = -bh(j)
      end do
   end do
100 continue
do j=1,nm
   b(j) = -bn(j)
end do
if (npp .ne. 0) return
!
nmp = nm+1
nb = nm+nmp
do j=1,nb
   l1 = mod(j-1,nmp)+1
   l2 = mod(j+nm-1,nmp)+1
   arg = an(l1)*cn(l2)
   if (arg .lt. 0.0) go to 220
   bh(j) = sign(sqrt(arg),-an(l1))
   ah(j) = -bn(l1)
end do
call tqlrt0 (nb,ah,bh,ierror)
if (ierror .ne. 0) go to 210
!
call indxb (if,k-1,j2,lh)
call indxb (if/2,k-1,j1,lh)
j2 = j2+1
lh = j2
n2m2 = j2+nm+nm-2
170 d1 = abs(b(j1)-b(j2-1))
d2 = abs(b(j1)-b(j2))
d3 = abs(b(j1)-b(j2+1))
if ((d2 .lt.d1) .and. (d2 .lt.d3)) go to 180
b(lh) = b(j2)
j2 = j2+1
lh = lh+1
if (j2-n2m2) 170,170,190
180 j2 = j2+1
j1 = j1+1
if (j2-n2m2) 170,170,190
190 b(lh) = b(n2m2+1)
call indxb (if,k-1,j1,j2)
j2 = j1+nmp+nmp
call ppadd (nm+1,ierror,an,cn,b(j1),b(j1),b(j2))
return
!
!     ERROR RETURN
!
210 ierror = 4
return
220 ierror = 5
return
end subroutine compb

subroutine tqlrt0 (n,d,e2,ierr)
implicit none
integer :: nhalf, ntop
real :: dhold
integer :: ik, k, ncmplx, nm, npp
real :: cnv
!
integer :: i, j, l, m, n, ii, l1, mml, ierr
real :: d(n), e2(n)
real :: b, c, f, g, h, p, r, s, machep
!
common /cblkt/  npp        ,k          ,machep     ,cnv        , &
&nm         ,ncmplx     ,ik
!
!
!     THIS SUBROUTINE IS A MODIFICATION OF THE EISPACK SUBROUTINE
!     TQLRAT. THE SUBROUTINE FINDS THE EIGENVALUES OF A SYMMETRIC
!     TRIDIAGONAL MATRIX BY THE RATIONAL QL METHOD.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E2 CONTAINS THE                SUBDIAGONAL ELEMENTS OF THE
!          INPUT MATRIX IN ITS LAST N-1 POSITIONS.  E2(1) IS ARBITRARY.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT AND
!          ORDERED FOR INDICES 1,2,...IERR-1, BUT MAY NOT BE
!          THE SMALLEST EIGENVALUES,
!
!        E2 HAS BEEN DESTROYED,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE RELATIVE PRECISION OF FLOATING POINT ARITHMETIC.
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 150
!
do i=2,n
   e2(i-1) = e2(i)*e2(i)
end do
!
f = 0.0
b = 0.0
e2(n) = 0.0
!
do l=1,n
   j = 0
   h = machep*(abs(d(l))+sqrt(e2(l)))
   if (b .gt. h) go to  20
   b = h
   c = b*b
!
!     ********** LOOK FOR SMALL SQUARED SUB-DIAGONAL ELEMENT **********
!
20 do 30 m = l,n
      if (e2(m) .le. c) go to  40
!
!     ********** E2(N) IS ALWAYS ZERO, SO THERE IS NO EXIT
!                THROUGH THE BOTTOM OF THE LOOP **********
!
30 continue
!
40 if (m .eq. l) go to  80
50 if (j .eq. 30) go to 140
   j = j+1
!
!     ********** FORM SHIFT **********
!
   l1 = l+1
   s = sqrt(e2(l))
   g = d(l)
   p = (d(l1)-g)/(2.0*s)
   r = sqrt(p*p+1.0)
   d(l) = s/(p+sign(r,p))
   h = g-d(l)
!
   do i=l1,n
      d(i) = d(i)-h
   end do
!
   f = f+h
!
!     ********** RATIONAL QL TRANSFORMATION **********
!
   g = d(m)
   if (g .eq. 0.0) g = b
   h = g
   s = 0.0
   mml = m-l
!
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
!
   do ii=1,mml
      i = m-ii
      p = g*h
      r = p+e2(i)
      e2(i+1) = s*r
      s = e2(i)/r
      d(i+1) = h+s*(h+d(i))
      g = d(i)-e2(i)/g
      if (g .eq. 0.0) g = b
      h = g*p/r
   end do
!
   e2(l) = s*g
   d(l) = h
!
!     ********** GUARD AGAINST UNDERFLOWED H **********
!
   if (h .eq. 0.0) go to  80
   if (abs(e2(l)) .le. abs(c/h)) go to  80
   e2(l) = h*e2(l)
   if (e2(l) .ne. 0.0) go to  50
80 p = d(l)+f
!
!     ********** ORDER EIGENVALUES **********
!
   if (l .eq. 1) go to 100
!
!     ********** FOR I=L STEP -1 UNTIL 2 DO -- **********
!
   do ii=2,l
      i = l+2-ii
      if (p .ge. d(i-1)) go to 110
      d(i) = d(i-1)
   end do
!
100 i = 1
110 d(i) = p
end do
!
if (abs(d(n)) .ge. abs(d(1))) go to 150
nhalf = n/2
do i=1,nhalf
   ntop = n-i
   dhold = d(i)
   d(i) = d(ntop+1)
   d(ntop+1) = dhold
end do
go to 150
!
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
!
140 ierr = l
150 return
end subroutine tqlrt0

subroutine ppadd (n,ierror,a,c,cbp,bp,bh)
implicit none
integer :: ierror, n
real :: a(*), bh(*), bp(*), c(*)
integer :: i2, i3, icv, if, ig, is, it, iz, izm, izm2, j, modiz, &
&nhalf, nt
real :: db, psg, scnv, sgn, xl, xm, xr
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
real :: ppsgf
real :: ppspf
real :: bsrh
real :: psgf
!
!     PPADD COMPUTES THE EIGENVALUES OF THE PERIODIC TRIDIAGONAL MATRIX
!     WITH COEFFICIENTS AN,BN,CN
!
! N   IS THE ORDER OF THE BH AND BP POLYNOMIALS.
!     ON OUTPUT BP CONTAINS THE EIGENVALUES.
! CBP IS THE SAME AS BP EXCEPT TYPE COMPLEX.
! BH  IS USED TO TEMPORARILY STORE THE ROOTS OF THE B HAT POLYNOMIAL
!     WHICH ENTERS THROUGH BP.
!
complex :: cf, cx, fsg, hsg, dd, f, fp, fpp, cdis, r1, r2, r3, &
&cbp(*)
external        psgf       ,ppspf      ,ppsgf
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
scnv = sqrt(cnv)
iz = n
izm = iz-1
izm2 = iz-2
if (bp(n)-bp(1))  10,420, 30
10 do j=1,n
   nt = n-j
   bh(j) = bp(nt+1)
end do
go to  50
30 do j=1,n
   bh(j) = bp(j)
end do
50 ncmplx = 0
modiz = mod(iz,2)
is = 1
if (modiz)  60, 70, 60
60 if (a(1)) 100,420, 70
70 xl = bh(1)
db = bh(3)-bh(1)
80 xl = xl-db
if (psgf(xl,iz,c,a,bh))  80, 80, 90
90 sgn = -1.
cbp(1) = cmplx(bsrh(xl,bh(1),iz,c,a,bh,psgf,sgn),0.)
is = 2
100 if = iz-1
if (modiz) 110,120,110
110 if (a(1)) 120,420,150
120 xr = bh(iz)
db = bh(iz)-bh(iz-2)
130 xr = xr+db
if (psgf(xr,iz,c,a,bh)) 130,140,140
140 sgn = 1.
cbp(iz) = cmplx(bsrh(bh(iz),xr,iz,c,a,bh,psgf,sgn),0.)
if = iz-2
150 do 360 ig = is,if,2
   xl = bh(ig)
   xr = bh(ig+1)
   sgn = -1.
   xm = bsrh(xl,xr,iz,c,a,bh,ppspf,sgn)
   psg = psgf(xm,iz,c,a,bh)
   if (abs(psg)-eps) 180,180,160
160 if (psg*ppsgf(xm,iz,c,a,bh)) 170,180,190
!
!     CASE OF A REAL ZERO
!
170 sgn = 1.
   cbp(ig) = cmplx(bsrh(bh(ig),xm,iz,c,a,bh,psgf,sgn),0.)
   sgn = -1.
   cbp(ig+1) = cmplx(bsrh(xm,bh(ig+1),iz,c,a,bh,psgf,sgn),0.)
   go to 360
!
!     CASE OF A MULTIPLE ZERO
!
180 cbp(ig) = cmplx(xm,0.)
   cbp(ig+1) = cmplx(xm,0.)
   go to 360
!
!     CASE OF A COMPLEX ZERO
!
190 it = 0
   icv = 0
   cx = cmplx(xm,0.)
200 fsg = (1.,0.)
   hsg = (1.,0.)
   fp = (0.,0.)
   fpp = (0.,0.)
   do j=1,iz
      dd = 1./(cx-bh(j))
      fsg = fsg*a(j)*dd
      hsg = hsg*c(j)*dd
      fp = fp+dd
      fpp = fpp-dd*dd
   end do
   if (modiz) 230,220,230
220 f = (1.,0.)-fsg-hsg
   go to 240
230 f = (1.,0.)+fsg+hsg
240 i3 = 0
   if (cabs(fp)) 260,260,250
250 i3 = 1
   r3 = -f/fp
260 i2 = 0
   if (cabs(fpp)) 320,320,270
270 i2 = 1
   cdis = csqrt(fp**2-2.*f*fpp)
   r1 = cdis-fp
   r2 = -fp-cdis
   if (cabs(r1)-cabs(r2)) 290,290,280
280 r1 = r1/fpp
   go to 300
290 r1 = r2/fpp
300 r2 = 2.*f/fpp/r1
   if (cabs(r2) .lt. cabs(r1)) r1 = r2
   if (i3) 330,330,310
310 if (cabs(r3) .lt. cabs(r1)) r1 = r3
   go to 330
320 r1 = r3
330 cx = cx+r1
   it = it+1
   if (it .gt. 50) go to 420
   if (cabs(r1) .gt. scnv) go to 200
   if (icv) 340,340,350
340 icv = 1
   go to 200
350 cbp(ig) = cx
   cbp(ig+1) = conjg(cx)
360 continue
if (cabs(cbp(n))-cabs(cbp(1))) 370,420,390
370 nhalf = n/2
do j=1,nhalf
   nt = n-j
   cx = cbp(j)
   cbp(j) = cbp(nt+1)
   cbp(nt+1) = cx
end do
390 ncmplx = 1
do 400 j = 2,iz
   if (aimag(cbp(j))) 430,400,430
400 continue
ncmplx = 0
do j=2,iz
   bp(j) = real(cbp(j))
end do
go to 430
420 ierror = 4
430 continue
return
end subroutine ppadd

function psgf (x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
integer :: j
real :: dd, fsg, hsg
real :: psgf
fsg = 1.
hsg = 1.
do j=1,iz
   dd = 1./(x-bh(j))
   fsg = fsg*a(j)*dd
   hsg = hsg*c(j)*dd
end do
if (mod(iz,2))  30, 20, 30
20 psgf = 1.-fsg-hsg
return
30 psgf = 1.+fsg+hsg
return
end function psgf

function bsrh (xll,xrr,iz,c,a,bh,f,sgn)
implicit none
integer :: iz
real :: a(*), bh(*), c(*), sgn, xll, xrr
real :: dx, x, xl, xr
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
real :: bsrh
real :: f
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
xl = xll
xr = xrr
dx = .5*abs(xr-xl)
10 x = .5*(xl+xr)
if (sgn*f(x,iz,c,a,bh))  30, 50, 20
20 xr = x
go to  40
30 xl = x
40 dx = .5*dx
if (dx-cnv)  50, 50, 10
50 bsrh = .5*(xl+xr)
return
end function bsrh

function ppsgf (x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
integer :: j
real :: sum
real :: ppsgf
sum = 0.
do j=1,iz
   sum = sum-1./(x-bh(j))**2
end do
ppsgf = sum
return
end function ppsgf

function ppspf (x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
integer :: j
real :: sum
real :: ppspf
sum = 0.
do j=1,iz
   sum = sum+1./(x-bh(j))
end do
ppspf = sum
return
end function ppspf

subroutine urget (n, ibeg, iend, ix, l, ierr)
implicit none
integer, intent(in) :: ibeg, iend
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, k, leftlo
!-----------------------------------------------------------------------
!
!               UNIFORM RANDOM SELECTION OF VALUES FROM
!                       A FINITE SET OF INTEGERS
!
!                           ----------------
!
!     URGET SELECTS N VALUES FROM THE SET OF INTEGERS FROM IBEG TO
!     IEND WHERE IBEG .LT. IEND. THE SELECTION IS PERFORMED SO THAT
!     ANY INTEGER IS EQUALLY LIKELY TO OCCUR WITH PROABILITY 1/M
!     WHERE M = IEND - IBEG + 1. AS N BECOMES LARGE THE MEAN AND
!     VARIANCE OF THE VALUES WILL CLOSELY APPROXIMATE THE MEAN AND
!     VARIANCE OF THE DISCRETE UNIFORM DISTRIBUTION WHERE
!
!               MEAN = IBEG + (IEND - IBEG)/2
!
!               VARIANCE = (M**2 - 1)/12 .
!
!     INPUT...
!
!       N     - NUMBER OF VARIATES TO BE GENERATED
!       IBEG  - LOWER LIMIT OF GENERATION INTERVAL
!       IEND  - UPPER LIMIT OF GENERATION INTERVAL
!       IX    - INTEGER SEED USED TO INITIALIZE THE
!               SEQUENCE OF VARIATES GENERATED
!
!     OUTPUT...
!
!       IX    - SEED FOR OBTAINING MORE VARIATES
!       L     - OUTPUT ARRAY OF DIMENSION N CONTAINING
!               THE GENERATED INTEGERS
!       IERR  - INPUT ERROR FLAG
!               ( 0 - NO INPUT ERRORS
!                 1 - N .LE. 0
!                 2 - IBEG .GE. IEND  OR  M .GE. P.
!                 3 - SEED OUT OF RANGE )
!
!-----------------------------------------------------------------------
integer, intent(inout) :: l(n)
integer :: a, b15, b16, fhi, p, xalo, xhi
double precision :: c, m, s, t
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     S = 1/(P-1)   (IT IS ASSUMED THAT THE ARITHMETIC BEING
!                    USED IS ACCURATE TO AT LEAST 14 DIGITS.
!                    S HAS BEEN SET TO A VALUE SLIGHTLY LESS
!                    THAN 1/(P-1) TO ENSURE THAT ROUNDING
!                    ERROR DOES NOT PRODUCE VARIATES THAT
!                    EXCEED IEND.)
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s /.4656612877413d-09/
!-------------------
if (n .le. 0) go to 100
if (ibeg .ge. iend) go to 110
if (ix .le. 0 .or. ix .ge. p) go to 120
m = iend - ibeg + 1
t = p
if (m .ge. t) go to 110
!
ierr = 0
c = m*s
do i = 1,n
!
!        USE THE LINUS SCHRAGE CODE TO OBTAIN THE NEXT SEED IX.
!
!        REFERENCE. SCHRAGE, LINUS, A MORE PORTABLE FORTRAN
!        RANDOM NUMBER GENERATOR, ACM TRANS. MATH SOFTWARE 5
!        (1979), PP. 132-138.
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
!
!        MAP IX TO AN INTEGER IN THE CLOSED INTERVAL (IBEG,IEND).
!        THIS MAPPING IS 1-1 ONLY WHEN M = P - 1, IN WHICH CASE
!        IX IS MAPPED TO THE VALUE (IBEG - 1) + IX.
!
   t = ix
   k = c*t
   l(i) = ibeg + k
end do
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine urget

subroutine urng (ix, x, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: k, l, leftlo
real :: s, t
real, intent(inout) :: x(n)
!-----------------------------------------------------------------------
!         UNIFORM RANDOM NUMBER GENERATOR USING THE RECURSION
!
!                       IX = IX*A MOD P
!
!     IT IS ASSUMED THAT 0 .LT. IX .LT. P
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661e-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
do l = 1,n
!
!                 GET 15 HIGH ORDER BITS OF IX
!
   xhi = ix/b16
!
!           GET 16 LOWER BITS OF IX AND MULTIPLY WITH A
!
   xalo = (ix - xhi*b16)*a
!
!             GET 15 HIGH ORDER BITS OF THE PRODUCT
!
   leftlo = xalo/b16
!
!               FORM THE 31 HIGHEST BITS OF A*IX
!
   fhi = xhi*a + leftlo
!
!           OBTAIN THE OVERFLOW PAST THE 31ST BIT OF A*IX
!
   k = fhi/b15
!
!             ASSEMBLE ALL THE PARTS AND PRESUBTRACT P
!                  THE PARENTHESES ARE ESSENTIAL
!
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      ADD P IF NECESSARY
!
   if (ix .lt. 0) ix = ix + p
!
!     RESCALE IX, TO INTERPRET IT AS A VALUE BETWEEN 0 AND 1.
!     THE SCALE FACTOR S IS SELECTED TO BE AS NEAR 1/P AS IS
!     APPROPRIATE IN ORDER THAT THE FLOATING VALUE FOR IX = 1,
!     NAMELY S, BE ROUGHLY THE SAME DISTANCE FROM 0 AS (P-1)*S
!     IS FROM 1. THE CURRENT VALUE FOR S ASSURES US THAT X(L)
!     IS LESS THAN 1 FOR ANY FLOATING POINT ARITHMETIC OF 6
!     OR MORE DIGITS.
!
   t = ix
   x(l) = s*t
end do
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine urng

subroutine durng (ix, x, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: k, l, leftlo
double precision, intent(inout) :: x(n)
!-----------------------------------------------------------------------
!         UNIFORM RANDOM NUMBER GENERATOR USING THE RECURSION
!
!                       IX = IX*A MOD P
!
!     IT IS ASSUMED THAT 0 .LT. IX .LT. P
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, xalo, xhi
double precision :: s, t
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661d-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
do l = 1,n
!
!                 GET 15 HIGH ORDER BITS OF IX
!
   xhi = ix/b16
!
!           GET 16 LOWER BITS OF IX AND MULTIPLY WITH A
!
   xalo = (ix - xhi*b16)*a
!
!             GET 15 HIGH ORDER BITS OF THE PRODUCT
!
   leftlo = xalo/b16
!
!               FORM THE 31 HIGHEST BITS OF A*IX
!
   fhi = xhi*a + leftlo
!
!           OBTAIN THE OVERFLOW PAST THE 31ST BIT OF A*IX
!
   k = fhi/b15
!
!             ASSEMBLE ALL THE PARTS AND PRESUBTRACT P
!                  THE PARENTHESES ARE ESSENTIAL
!
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      ADD P IF NECESSARY
!
   if (ix .lt. 0) ix = ix + p
!
!     RESCALE IX, TO INTERPRET IT AS A VALUE BETWEEN 0 AND 1.
!     THE SCALE FACTOR S IS SELECTED TO BE AS NEAR 1/P AS IS
!     APPROPRIATE IN ORDER THAT THE FLOATING VALUE FOR IX = 1,
!     NAMELY S, BE ROUGHLY THE SAME DISTANCE FROM 0 AS (P-1)*S
!     IS FROM 1. THE CURRENT VALUE FOR S ASSURES US THAT X(L)
!     IS LESS THAN 1 FOR ANY DOUBLE PRECISION ARITHMETIC.
!
   t = ix
   x(l) = s*t
end do
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine durng

subroutine urng0 (ix, u, v)
implicit none
integer, intent(inout) :: ix
real, intent(inout) :: u, v
integer :: k, leftlo
real :: t
!-----------------------------------------------------------------------
!       UNIFORM RANDOM NUMBER GENERATOR USING THE RECURSION
!
!                       IX = IX*A MOD P
!
!     U IS THE UNIFORM VARIATE THAT IS GENERATED AND V = 1 - U.
!     U AND V ARE POSITIVE. IT IS ASSUMED THAT 1 .LE. IX .LT. P.
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     DATA P0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 GET 15 HIGH ORDER BITS OF IX
!
xhi = ix/b16
!
!           GET 16 LOWER BITS OF IX AND MULTIPLY WITH A
!
xalo = (ix - xhi*b16)*a
!
!             GET 15 HIGH ORDER BITS OF THE PRODUCT
!
leftlo = xalo/b16
!
!               FORM THE 31 HIGHEST BITS OF A*IX
!
fhi = xhi*a + leftlo
!
!           OBTAIN THE OVERFLOW PAST THE 31ST BIT OF A*IX
!
k = fhi/b15
!
!             ASSEMBLE ALL THE PARTS AND PRESUBTRACT P
!                  THE PARENTHESES ARE ESSENTIAL
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      ADD P IF NECESSARY
!
if (ix .lt. 0) ix = ix + p
!
!         RESCALE IX, TO INTERPRET IT AS A VALUE BETWEEN 0 AND 1
!
t = p
if (ix .gt. p0) go to 10
   u = ix
   u = u/t
   v = 0.5 + (0.5 - u)
   return
10 v = p - ix
v = v/t
u = 0.5 + (0.5 - v)
return
end subroutine urng0

subroutine durng0 (ix, u, v)
implicit none
integer, intent(inout) :: ix
integer :: k, leftlo
!-----------------------------------------------------------------------
!       UNIFORM RANDOM NUMBER GENERATOR USING THE RECURSION
!
!                       IX = IX*A MOD P
!
!     U IS THE UNIFORM VARIATE THAT IS GENERATED AND V = 1 - U.
!     U AND V ARE POSITIVE. IT IS ASSUMED THAT 1 .LE. IX .LT. P.
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
double precision, intent(inout) :: u, v
double precision :: t
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     DATA P0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 GET 15 HIGH ORDER BITS OF IX
!
xhi = ix/b16
!
!           GET 16 LOWER BITS OF IX AND MULTIPLY WITH A
!
xalo = (ix - xhi*b16)*a
!
!             GET 15 HIGH ORDER BITS OF THE PRODUCT
!
leftlo = xalo/b16
!
!               FORM THE 31 HIGHEST BITS OF A*IX
!
fhi = xhi*a + leftlo
!
!           OBTAIN THE OVERFLOW PAST THE 31ST BIT OF A*IX
!
k = fhi/b15
!
!             ASSEMBLE ALL THE PARTS AND PRESUBTRACT P
!                  THE PARENTHESES ARE ESSENTIAL
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      ADD P IF NECESSARY
!
if (ix .lt. 0) ix = ix + p
!
!         RESCALE IX, TO INTERPRET IT AS A VALUE BETWEEN 0 AND 1
!
t = p
if (ix .gt. p0) go to 10
   u = ix
   u = u/t
   v = 0.5d0 + (0.5d0 - u)
   return
10 v = p - ix
v = v/t
u = 0.5d0 + (0.5d0 - v)
return
end subroutine durng0

subroutine urng1 (ix, u, v, d)
implicit none
integer, intent(inout) :: ix
real, intent(inout) :: d, u, v
integer :: j, k, leftlo
real :: t
!-----------------------------------------------------------------------
!       UNIFORM RANDOM NUMBER GENERATOR USING THE RECURSION
!
!                       IX = IX*A MOD P
!
!     U IS THE UNIFORM VARIATE THAT IS GENERATED AND V = 1 - U.
!     U AND V ARE POSITIVE AND D = U - 0.5. IT IS ASSUMED THAT
!     1 .LE. IX .LT. P.
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     DATA P0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 GET 15 HIGH ORDER BITS OF IX
!
xhi = ix/b16
!
!           GET 16 LOWER BITS OF IX AND MULTIPLY WITH A
!
xalo = (ix - xhi*b16)*a
!
!             GET 15 HIGH ORDER BITS OF THE PRODUCT
!
leftlo = xalo/b16
!
!               FORM THE 31 HIGHEST BITS OF A*IX
!
fhi = xhi*a + leftlo
!
!           OBTAIN THE OVERFLOW PAST THE 31ST BIT OF A*IX
!
k = fhi/b15
!
!             ASSEMBLE ALL THE PARTS AND PRESUBTRACT P
!                  THE PARENTHESES ARE ESSENTIAL
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      ADD P IF NECESSARY
!
if (ix .lt. 0) ix = ix + p
!
!         RESCALE IX, TO INTERPRET IT AS A VALUE BETWEEN 0 AND 1
!
j = p - ix
t = p
d = ix - j
d = 0.5*(d/t)
if (ix .gt. p0) go to 10
   u = ix
   u = u/t
   v = 0.5 + (0.5 - u)
   return
10 v = j
v = v/t
u = 0.5 + (0.5 - v)
return
end subroutine urng1

subroutine durng1 (ix, u, v, d)
implicit none
integer, intent(inout) :: ix
integer :: j, k, leftlo
!-----------------------------------------------------------------------
!       UNIFORM RANDOM NUMBER GENERATOR USING THE RECURSION
!
!                       IX = IX*A MOD P
!
!     U IS THE UNIFORM VARIATE THAT IS GENERATED AND V = 1 - U.
!     U AND V ARE POSITIVE AND D = U - 0.5. IT IS ASSUMED THAT
!     1 .LE. IX .LT. P.
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
double precision, intent(inout) :: u, v, d
double precision :: t
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     DATA P0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 GET 15 HIGH ORDER BITS OF IX
!
xhi = ix/b16
!
!           GET 16 LOWER BITS OF IX AND MULTIPLY WITH A
!
xalo = (ix - xhi*b16)*a
!
!             GET 15 HIGH ORDER BITS OF THE PRODUCT
!
leftlo = xalo/b16
!
!               FORM THE 31 HIGHEST BITS OF A*IX
!
fhi = xhi*a + leftlo
!
!           OBTAIN THE OVERFLOW PAST THE 31ST BIT OF A*IX
!
k = fhi/b15
!
!             ASSEMBLE ALL THE PARTS AND PRESUBTRACT P
!                  THE PARENTHESES ARE ESSENTIAL
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      ADD P IF NECESSARY
!
if (ix .lt. 0) ix = ix + p
!
!         RESCALE IX, TO INTERPRET IT AS A VALUE BETWEEN 0 AND 1
!
j = p - ix
t = p
d = ix - j
d = 0.5d0*(d/t)
if (ix .gt. p0) go to 10
   u = ix
   u = u/t
   v = 0.5d0 + (0.5d0 - u)
   return
10 v = j
v = v/t
u = 0.5d0 + (0.5d0 - v)
return
end subroutine durng1

subroutine urng2 (ix, x, y, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: k, l, leftlo
real :: s, t
!-----------------------------------------------------------------------
!
!         GENERATION OF UNIFORM RANDOM POINTS (X(I),Y(I))
!                     FOR I = 1,...,N WHERE
!
!                      0 .LT. X(I) .LT. 1
!                      0 .LT. Y(I) .LT. 1
!
!     IT IS ASSUMED THAT 0 .LT. IX .LT. P
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
real, intent(inout) :: x(n), y(n)
integer :: a, b15, b16, fhi, p, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661e-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
!
!         SEE THE COMMENTS IN THE SUBROUTINE URNG FOR THE
!                STATEMENTS IN THE FOLLOWING LOOP
!
do l = 1,n
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
   t = ix
   x(l) = s*t
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
   t = ix
   y(l) = s*t
end do
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine urng2

subroutine durng2 (ix, x, y, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: k, l, leftlo
!-----------------------------------------------------------------------
!
!         GENERATION OF UNIFORM RANDOM POINTS (X(I),Y(I))
!                     FOR I = 1,...,N WHERE
!
!                      0 .LT. X(I) .LT. 1
!                      0 .LT. Y(I) .LT. 1
!
!     IT IS ASSUMED THAT 0 .LT. IX .LT. P
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
double precision, intent(inout) :: x(n), y(n)
double precision :: s, t
integer :: a, b15, b16, fhi, p, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661d-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
!
!         SEE THE COMMENTS IN THE SUBROUTINE DURNG FOR THE
!                 STATEMENTS IN THE FOLLOWING LOOP
!
do l = 1,n
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
   t = ix
   x(l) = s*t
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
   t = ix
   y(l) = s*t
end do
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine durng2

subroutine rcir (n, ix, x, y, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
!-----------------------------------------------------------------------
!
!          GENERATION OF N UNIFORM RANDOM POINTS (X(I),Y(I))
!              IN THE UNIT CIRCLE CENTERED AT THE ORIGIN
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n), y(n)
!------------------
call rcir1 (n, ix, x, 1, y, 1, ierr)
return
end subroutine rcir

subroutine rcir1 (n, ix, x, kx, y, ky, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, ky, n
integer :: i, i1, i2, j, k, leftlo
real :: r, s, u, v
!-----------------------------------------------------------------------
!
!      GENERATION OF N UNIFORM RANDOM POINTS IN THE UNIT CIRCLE
!      CENTERED AT THE ORIGIN. THE ABSCISSA AND ORDINATE OF THE
!      I-TH POINT ARE STORED IN X(I1) AND Y(I2) WHERE
!
!                      I1 = 1 + KX*(I - 1)
!                      I2 = 1 + KY*(I - 1) .
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(*), y(*)
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     P0 = 2**30 - 1
!     S  = 2/P
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
data s/.931322e-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
!
i1 = 1
i2 = 1
do i = 1,n
!
!        USE THE LINUS SCHRAGE CODE TO OBTAIN NEW SEEDS IX.
!
!        REFERENCE. SCHRAGE, LINUS, A MORE PORTABLE FORTRAN
!        RANDOM NUMBER GENERATOR, ACM TRANS. MATH SOFTWARE 5
!        (1979), PP. 132-138.
!
10 xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
   j = ix
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
!
!        SUBTRACT THE MIDPOINT P0 AND RESCALE SO THAT THE
!          UNIFORM VARIATES ARE IN THE INTERVAL (-1,1).
!
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!
!         CHECK IF THE POINT (U,V) IS IN THE UNIT CIRCLE
!
   r = (u*u + v*v) - 1.0
   if (r .ge. 0.0) go to 10
!
!            STORE THE POINT WHEN IT IS IN THE CIRCLE
!
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!
!                          ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine rcir1

subroutine drcir (n, ix, x, y, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
!-----------------------------------------------------------------------
!
!          GENERATION OF N UNIFORM RANDOM POINTS (X(I),Y(I))
!              IN THE UNIT CIRCLE CENTERED AT THE ORIGIN
!
!-----------------------------------------------------------------------
double precision, intent(inout) :: x(n), y(n)
!------------------
call drcir1 (n, ix, x, 1, y, 1, ierr)
return
end subroutine drcir

subroutine drcir1 (n, ix, x, kx, y, ky, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, ky, n
integer :: i, i1, i2, j, k, leftlo
!-----------------------------------------------------------------------
!
!      GENERATION OF N UNIFORM RANDOM POINTS IN THE UNIT CIRCLE
!      CENTERED AT THE ORIGIN. THE ABSCISSA AND ORDINATE OF THE
!      I-TH POINT ARE STORED IN X(I1) AND Y(I2) WHERE
!
!                      I1 = 1 + KX*(I - 1)
!                      I2 = 1 + KY*(I - 1) .
!
!-----------------------------------------------------------------------
double precision, intent(inout) :: x(*), y(*)
double precision :: r, s, u, v
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     DATA A/7**5/,  B15/2**15/, B16/2**16/, P/2**31 - 1/
!     P0 = 2**30 - 1
!     S  = 2/P
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
data s/.931322d-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
!
i1 = 1
i2 = 1
do i = 1,n
!
!        USE THE LINUS SCHRAGE CODE TO OBTAIN NEW SEEDS IX.
!
!        REFERENCE. SCHRAGE, LINUS, A MORE PORTABLE FORTRAN
!        RANDOM NUMBER GENERATOR, ACM TRANS. MATH SOFTWARE 5
!        (1979), PP. 132-138.
!
10 xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
   j = ix
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix .lt. 0) ix = ix + p
!
!        SUBTRACT THE MIDPOINT P0 AND RESCALE SO THAT THE
!          UNIFORM VARIATES ARE IN THE INTERVAL (-1,1).
!
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!
!         CHECK IF THE POINT (U,V) IS IN THE UNIT CIRCLE
!
   r = (u*u + v*v) - 1.d0
   if (r .ge. 0.d0) go to 10
!
!            STORE THE POINT WHEN IT IS IN THE CIRCLE
!
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!
!                          ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine drcir1

subroutine rnor (ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, m, max
real :: r, s, u, v
!-----------------------------------------------------------------------
!                 NORMAL RANDOM NUMBER GENERATOR
!-----------------------------------------------------------------------
real, intent(inout) :: a(n)
real :: t(2)
!---------------------
data max /2147483647/
!---------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. max) go to 110
ierr = 0
!
if (n .eq. 1) go to 20
m = n/2
call rcir1 (m, ix, a(1), 2, a(2), 2, ierr)
m = m + m
!
!                  OBTAIN THE FIRST M VARIATES
!
do i = 1,m,2
   u = a(i)
   v = a(i + 1)
   r = u*u + v*v
   s = sqrt(-2.0*alog(r)/r)
   a(i) = s*u
   a(i + 1) = s*v
end do
if (m .eq. n) return
!
!            OBTAIN THE LAST VARIATE (WHEN N IS ODD)
!
20 call rcir1 (1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = sqrt(-2.0*alog(r)/r)
a(n) = s*t(1)
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine rnor

subroutine drnor (ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, m, max
!-----------------------------------------------------------------------
!                 NORMAL RANDOM NUMBER GENERATOR
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(n)
double precision :: r, s, u, v, t(2)
!---------------------
data max /2147483647/
!---------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. max) go to 110
ierr = 0
!
if (n .eq. 1) go to 20
m = n/2
call drcir1 (m, ix, a(1), 2, a(2), 2, ierr)
m = m + m
!
!                  OBTAIN THE FIRST M VARIATES
!
do i = 1,m,2
   u = a(i)
   v = a(i + 1)
   r = u*u + v*v
   s = dsqrt(-2.d0*dlog(r)/r)
   a(i) = s*u
   a(i + 1) = s*v
end do
if (m .eq. n) return
!
!            OBTAIN THE LAST VARIATE (WHEN N IS ODD)
!
20 call drcir1 (1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = dsqrt(-2.d0*dlog(r)/r)
a(n) = s*t(1)
return
!
!                         ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine drnor

subroutine nrng (ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, m
real :: phi, pi2, r
!-----------------------------------------------------------------------
!                 GAUSSIAN RANDOM NUMBER GENERATOR
!-----------------------------------------------------------------------
real, intent(inout) :: a(n)
real :: temp(1)
data pi2 /6.2831853071796/
!
call urng (ix,a,n,ierr)
if (ierr .ne. 0) return
if (n .eq. 1) go to 20
!
m = n/2
m = m + m
do 10 i = 1,m,2
   r = sqrt(-2.0*alog(a(i)))
   phi = pi2*a(i+1)
   a(i) = r*cos(phi)
10 a(i+1) = r*sin(phi)
if (m .eq. n) return
!
20 call urng (ix,temp,1,ierr)
r = sqrt(-2.0*alog(a(n)))
a(n) = r*cos(pi2*temp(1))
return
end subroutine nrng

subroutine dnrng (ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, m
!-----------------------------------------------------------------------
!                 GAUSSIAN RANDOM NUMBER GENERATOR
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(n)
double precision :: phi, pi2, r, temp(1)
!
data pi2 /6.28318530717958647692528676656d0/
!
call durng (ix, a, n, ierr)
if (ierr .ne. 0) return
if (n .eq. 1) go to 20
!
m = n/2
m = m + m
do 10 i = 1,m,2
   r = dsqrt(-2.d0*dlog(a(i)))
   phi = pi2*a(i+1)
   a(i) = r*dcos(phi)
10 a(i+1) = r*dsin(phi)
if (m .eq. n) return
!
20 call durng (ix, temp, 1, ierr)
r = dsqrt(-2.d0*dlog(a(n)))
a(n) = r*dcos(pi2*temp(1))
return
end subroutine dnrng

subroutine nrvg (mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
integer :: i, ii, j, k, l, l0, ldim, max
real :: sum
!-----------------------------------------------------------------------
!
!           GENERATION OF N RANDOM NORMAL VECTORS OF LENGTH M
!           FROM A MULTIVARIATE NORMAL DISTRIBUTION WITH MEAN
!           VECTOR FMU AND VARIANCE-COVARIANCE MATRIX A.
!
!                          ---------------
!
!     INPUT...
!
!        MO      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  BEING CALLED FOR THE FIRST TIME TO
!                  GENERATE NORMAL VECTORS FROM A MATRIX
!                  A. SET MO = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND MO .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  THE SAME MATRIX A.
!
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES.
!
!        N       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        M       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT M .GE. 2. M SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN MO .NE. 0).
!
!        A       - VARIANCE-COVARIANCE MATRIX OF ORDER M.
!                  A IS A SYMMETRIC POSITIVE DEFINITE MATRIX
!                  STORED IN PACKED FORM. THE ARRAY A MUST
!                  BE OF LENGTH (M*(M + 1))/2 OR LARGER.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  LOWER TRIANGULAR MATRIX IN THE CHOLESKY
!                  DECOMPOSITION OF A REPLACES THE ORIGINAL
!                  DATA IN THE ARRAY A. A SHOULD NEVER BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN MO .NE. 0).
!
!        FMU     - MEAN VECTOR OF DIMENSION M OF THE
!                  MULTIVARIATE NORMAL DISTRIBUTION
!
!        KX      - ROW DIMENSION OF THE MATRIX X (SEE THE
!                  DESCRIPTION OF X BELOW). IT IS ASSUMED
!                  THAT KX .GE. M.
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        X       - OUTPUT ARRAY OF DIMENSION KX BY N CONTAINING
!                  THE N GENERATED RANDOM NORMAL VECTORS. THE
!                  J-TH VECTOR IS STORED IN THE J-TH COLUMN OF
!                  X FOR J = 1,...,N.
!
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - M .LE. 1  OR  M .GT. KX
!                   3 - A IS NOT POSITIVE DEFINITE
!                   4 - SEED OUT OF RANGE         )
!
!-----------------------------------------------------------------------
!
!        ***REFERENCES***
!
!     FISHMAN, GEORGE S., CONCEPTS AND METHODS IN DISCRETE EVENT
!     DIGITAL SIMULATION, JOHN WILEY AND SONS, NEW YORK, 1973,
!     PP. 215 - 217.
!
!     MORRISON, DONALD F., MULTIVARIATE STATISTICAL METHODS,
!     MCGRAW-HILL, NEW YORK, 1967, PP. 80 - 81.
!
!     SCHEUER, E. AND STOLLER, D. S., ON THE GENERATION OF
!     NORMAL RANDOM VECTORS, TECHNOMETRICS, VOLUME 4, MAY, 1962,
!     PP. 278 - 281.
!
!-----------------------------------------------------------------------
real, intent(inout) :: a(*)
real, intent(in) :: fmu(m)
real, intent(inout) :: x(kx,n)
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (m .le. 1 .or. m .gt. kx) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
!
!           COMPUTE THE LOWER TRIANGULAR MATRIX
!           L HAVING POSITIVE DIAGONAL ELEMENTS
!           AND SATISFYING A = L*TRANSPOSE(L).
!
if (mo .ne. 0) go to 10
call sppfa (a, m, ierr)
if (ierr .ne. 0) go to 120
!
!           GENERATE THE N RANDOM NORMAL VECTORS
!
10 ldim = (m*(m + 1))/2
do j = 1,n
   call rnor (ix, x(1,j), m, ierr)
!
!         OBTAIN THE COMPONENTS OF THE J-TH VECTOR
!                    IN REVERSE ORDER
!
   l0 = ldim
   i = m
   do ii = 1,m
      l0 = l0 - i
      l = l0
      sum = 0.0
      do 20 k = 1,i
         l = l + 1
20 sum = sum + a(l)*x(k,j)
      x(i,j) = sum + fmu(i)
      i = i - 1
   end do
end do
return
!
!                      ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine nrvg

subroutine nrvg1 (mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
integer :: i, j, max
!-----------------------------------------------------------------------
!
!           GENERATION OF N RANDOM NORMAL VECTORS OF LENGTH M
!           FROM A MULTIVARIATE NORMAL DISTRIBUTION WITH MEAN
!           VECTOR FMU AND VARIANCE-COVARIANCE MATRIX A. IT IS
!           ASSUMED THAT A IS A DIAGONAL MATRIX.
!
!                          ---------------
!
!     INPUT...
!
!        MO      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  BEING CALLED FOR THE FIRST TIME TO
!                  GENERATE NORMAL VECTORS FROM A MATRIX
!                  A. SET MO = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND MO .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  THE SAME MATRIX A.
!
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES.
!
!        N       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        M       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT M .GE. 2. M SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN MO .NE. 0).
!
!        A       - VARIANCE-COVARIANCE MATRIX OF ORDER M.
!                  A IS A DIAGONAL MATRIX WITH POSITIVE
!                  DIAGONAL ELEMENTS. THE DIAGONAL ELEMENTS
!                  ARE STORED IN THE ARRAY A. A IS AN ARRAY
!                  OF LENGTH M OR LARGER.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  SQUARE ROOTS OF THE ELEMENTS OF A REPLACE
!                  THE ORIGINAL DATA IN A. A SHOULD NOT BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN MO .NE. 0).
!
!        FMU     - MEAN VECTOR OF DIMENSION M OF THE
!                  MULTIVARIATE NORMAL DISTRIBUTION
!
!        KX      - ROW DIMENSION OF THE MATRIX X (SEE THE
!                  DESCRIPTION OF X BELOW). IT IS ASSUMED
!                  THAT KX .GE. M.
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        X       - OUTPUT ARRAY OF DIMENSION KX BY N CONTAINING
!                  THE N GENERATED RANDOM NORMAL VECTORS. THE
!                  J-TH VECTOR IS STORED IN THE J-TH COLUMN OF
!                  X FOR J = 1,...,N.
!
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - M .LE. 1  OR  M .GT. KX
!                   3 - A(I) .LE. 0 FOR SOME I
!                   4 - SEED OUT OF RANGE      )
!
!-----------------------------------------------------------------------
real, intent(inout) :: a(m)
real, intent(in) :: fmu(m)
real, intent(inout) :: x(kx,n)
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (m .le. 1 .or. m .gt. kx) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
!
!        COMPUTE THE ROOTS OF THE DIAGONAL ELEMENTS
!
if (mo .ne. 0) go to 20
do i = 1,m
   if (a(i) .le. 0.0) go to 120
   a(i) = sqrt(a(i))
end do
!
!           GENERATE THE N RANDOM NORMAL VECTORS
!
20 do j = 1,n
   call rnor (ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!
!                       ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine nrvg1

subroutine dnrvg (mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
integer :: i, ii, j, k, l, l0, ldim, max
!-----------------------------------------------------------------------
!
!           GENERATION OF N RANDOM NORMAL VECTORS OF LENGTH M
!           FROM A MULTIVARIATE NORMAL DISTRIBUTION WITH MEAN
!           VECTOR FMU AND VARIANCE-COVARIANCE MATRIX A.
!
!                          ---------------
!
!     INPUT...
!
!        MO      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  BEING CALLED FOR THE FIRST TIME TO
!                  GENERATE NORMAL VECTORS FROM A MATRIX
!                  A. SET MO = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND MO .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  THE SAME MATRIX A.
!
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES.
!
!        N       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        M       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT M .GE. 2. M SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN MO .NE. 0).
!
!        A       - VARIANCE-COVARIANCE MATRIX OF ORDER M.
!                  A IS A SYMMETRIC POSITIVE DEFINITE MATRIX
!                  STORED IN PACKED FORM. THE ARRAY A MUST
!                  BE OF LENGTH (M*(M + 1))/2 OR LARGER.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  LOWER TRIANGULAR MATRIX IN THE CHOLESKY
!                  DECOMPOSITION OF A REPLACES THE ORIGINAL
!                  DATA IN THE ARRAY A. A SHOULD NEVER BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN MO .NE. 0).
!
!        FMU     - MEAN VECTOR OF DIMENSION M OF THE
!                  MULTIVARIATE NORMAL DISTRIBUTION
!
!        KX      - ROW DIMENSION OF THE MATRIX X (SEE THE
!                  DESCRIPTION OF X BELOW). IT IS ASSUMED
!                  THAT KX .GE. M.
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        X       - OUTPUT ARRAY OF DIMENSION KX BY N CONTAINING
!                  THE N GENERATED RANDOM NORMAL VECTORS. THE
!                  J-TH VECTOR IS STORED IN THE J-TH COLUMN OF
!                  X FOR J = 1,...,N.
!
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - M .LE. 1  OR  M .GT. KX
!                   3 - A IS NOT POSITIVE DEFINITE
!                   4 - SEED OUT OF RANGE         )
!
!-----------------------------------------------------------------------
!
!        ***REFERENCES***
!
!     FISHMAN, GEORGE S., CONCEPTS AND METHODS IN DISCRETE EVENT
!     DIGITAL SIMULATION, JOHN WILEY AND SONS, NEW YORK, 1973,
!     PP. 215 - 217.
!
!     MORRISON, DONALD F., MULTIVARIATE STATISTICAL METHODS,
!     MCGRAW-HILL, NEW YORK, 1967, PP. 80 - 81.
!
!     SCHEUER, E. AND STOLLER, D. S., ON THE GENERATION OF
!     NORMAL RANDOM VECTORS, TECHNOMETRICS, VOLUME 4, MAY, 1962,
!     PP. 278 - 281.
!
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(*)
double precision, intent(in) :: fmu(m)
double precision, intent(inout) :: x(kx,n)
double precision :: sum
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (m .le. 1 .or. m .gt. kx) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
!
!           COMPUTE THE LOWER TRIANGULAR MATRIX
!           L HAVING POSITIVE DIAGONAL ELEMENTS
!           AND SATISFYING A = L*TRANSPOSE(L).
!
if (mo .ne. 0) go to 10
call dppfa (a, m, ierr)
if (ierr .ne. 0) go to 120
!
!           GENERATE THE N RANDOM NORMAL VECTORS
!
10 ldim = (m*(m + 1))/2
do j = 1,n
   call drnor (ix, x(1,j), m, ierr)
!
!         OBTAIN THE COMPONENTS OF THE J-TH VECTOR
!                    IN REVERSE ORDER
!
   l0 = ldim
   i = m
   do ii = 1,m
      l0 = l0 - i
      l = l0
      sum = 0.d0
      do 20 k = 1,i
         l = l + 1
20 sum = sum + a(l)*x(k,j)
      x(i,j) = sum + fmu(i)
      i = i - 1
   end do
end do
return
!
!                      ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine dnrvg

subroutine dnrvg1 (mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
integer :: i, j, max
!-----------------------------------------------------------------------
!
!           GENERATION OF N RANDOM NORMAL VECTORS OF LENGTH M
!           FROM A MULTIVARIATE NORMAL DISTRIBUTION WITH MEAN
!           VECTOR FMU AND VARIANCE-COVARIANCE MATRIX A. IT IS
!           ASSUMED THAT A IS A DIAGONAL MATRIX.
!
!                          ---------------
!
!     INPUT...
!
!        MO      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  BEING CALLED FOR THE FIRST TIME TO
!                  GENERATE NORMAL VECTORS FROM A MATRIX
!                  A. SET MO = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND MO .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  THE SAME MATRIX A.
!
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES.
!
!        N       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        M       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT M .GE. 2. M SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN MO .NE. 0).
!
!        A       - VARIANCE-COVARIANCE MATRIX OF ORDER M.
!                  A IS A DIAGONAL MATRIX WITH POSITIVE
!                  DIAGONAL ELEMENTS. THE DIAGONAL ELEMENTS
!                  ARE STORED IN THE ARRAY A. A IS AN ARRAY
!                  OF LENGTH M OR LARGER.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  SQUARE ROOTS OF THE ELEMENTS OF A REPLACE
!                  THE ORIGINAL DATA IN A. A SHOULD NOT BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN MO .NE. 0).
!
!        FMU     - MEAN VECTOR OF DIMENSION M OF THE
!                  MULTIVARIATE NORMAL DISTRIBUTION
!
!        KX      - ROW DIMENSION OF THE MATRIX X (SEE THE
!                  DESCRIPTION OF X BELOW). IT IS ASSUMED
!                  THAT KX .GE. M.
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        X       - OUTPUT ARRAY OF DIMENSION KX BY N CONTAINING
!                  THE N GENERATED RANDOM NORMAL VECTORS. THE
!                  J-TH VECTOR IS STORED IN THE J-TH COLUMN OF
!                  X FOR J = 1,...,N.
!
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - M .LE. 1  OR  M .GT. KX
!                   3 - A(I) .LE. 0 FOR SOME I
!                   4 - SEED OUT OF RANGE      )
!
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(m)
double precision, intent(in) :: fmu(m)
double precision, intent(inout) :: x(kx,n)
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (m .le. 1 .or. m .gt. kx) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
!
!        COMPUTE THE ROOTS OF THE DIAGONAL ELEMENTS
!
if (mo .ne. 0) go to 20
do i = 1,m
   if (a(i) .le. 0.d0) go to 120
   a(i) = dsqrt(a(i))
end do
!
!           GENERATE THE N RANDOM NORMAL VECTORS
!
20 do j = 1,n
   call drnor (ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!
!                       ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine dnrvg1

subroutine ranexp (n,a,iseed,x,ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
real, intent(in) :: a
integer :: i
!
!              ***SUBROUTINE PURPOSE AND DESCRIPTION***
!
!           RANEXP GENERATES N EXPONENTIAL RANDOM VARIATES FROM AN
!           EXPONENTIAL DISTRIBUTION WITH PARAMETER A (A .GT. 0).
!           A IS THE MEAN OF THE DISTRIBUTION.  HENCE, A IS INTERPRETED
!           AS THE AVERAGE RATE PER UNIT OF TIME OR THE AVERAGE TIME
!           TO FAILURE (AVERAGE LIFETIME).
!
!           FORM OF THE EXPONENTIAL PROBABILITY DENSITY FUNCTION...
!
!                   F(X) = (1/A) * EXP(-X/A)      , X .GE. 0
!                                                   A .GT. 0
!
!           MEAN AND VARIANCE OF THE EXPONENTIAL DISTRIBUTION...
!
!                    MEAN = A
!
!                    VARIANCE = A**2
!
!           ***PARAMETER LIST***
!
!           INPUT...
!
!           N       - NUMBER OF VARIATES TO BE GENERATED
!           A       - MEAN OF THE EXPONENTIAL DISTRIBUTION
!           ISEED   - INTEGER SEED USED TO INITIALIZE THE
!                     SEQUENCE OF VARIATES GENERATED
!
!           OUTPUT...
!
!           ISEED   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     ROUTINE
!           X       - OUTPUT ARRAY OF DIMENSION N CONTAINING
!                     THE GENERATED REAL VARIATES
!           IERROR  - INPUT ERROR FLAG
!                     ( 0 - NO INPUT ERRORS
!                       1 - N .LE. 0
!                       2 - A .LE. 0.0
!                       3 - SEED OUT OF RANGE )
!
!           ***REFERENCE***
!
!           FISHMAN, GEORGE S., CONCEPTS AND METHODS IN DISCRETE EVENT
!           DIGITAL SIMULATION, JOHN WILEY AND SONS, NEW YORK, 1973,
!           P. 203.
!
real, intent(inout) :: x(n)
!
!        CHECK TO ENSURE THAT THE DESIRED NUMBER OF VARIATES IS WITHIN
!        ACCEPTABLE RANGE
!
if (n .le. 0) go to 100
!
!        CHECK TO ENSURE THAT THE EXPONENTIAL PARAMETER HAS BEEN
!        PROPERLY SPECIFIED
!
if (a .le. 0.0) go to 110
!
!        GENERATION OF UNIFORM RANDOM VARIATES
!
call urng (iseed, x, n, ierror)
if (ierror .ne. 0) go to 120
!
!        LOOP WHICH GENERATES THE N DESIRED VARIATES
!
do i=1,n
   x(i) = - a*alog(x(i))
end do
return
!
!              ERROR RETURN
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
end subroutine ranexp

subroutine drnexp (n,a,iseed,x,ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
integer :: i
!
!              ***SUBROUTINE PURPOSE AND DESCRIPTION***
!
!           DRNEXP GENERATES N EXPONENTIAL RANDOM VARIATES FROM AN
!           EXPONENTIAL DISTRIBUTION WITH PARAMETER A (A .GT. 0).
!           A IS THE MEAN OF THE DISTRIBUTION.  HENCE, A IS INTERPRETED
!           AS THE AVERAGE RATE PER UNIT OF TIME OR THE AVERAGE TIME
!           TO FAILURE (AVERAGE LIFETIME).
!
!           FORM OF THE EXPONENTIAL PROBABILITY DENSITY FUNCTION...
!
!                   F(X) = (1/A) * EXP(-X/A)      , X .GE. 0
!                                                   A .GT. 0
!
!           MEAN AND VARIANCE OF THE EXPONENTIAL DISTRIBUTION...
!
!                    MEAN = A
!
!                    VARIANCE = A**2
!
!           ***PARAMETER LIST***
!
!           INPUT...
!
!           N       - NUMBER OF VARIATES TO BE GENERATED
!           A       - MEAN OF THE EXPONENTIAL DISTRIBUTION
!           ISEED   - INTEGER SEED USED TO INITIALIZE THE
!                     SEQUENCE OF VARIATES GENERATED
!
!           OUTPUT...
!
!           ISEED   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     ROUTINE
!           X       - OUTPUT ARRAY OF DIMENSION N CONTAINING
!                     THE GENERATED REAL VARIATES
!           IERROR  - INPUT ERROR FLAG
!                     ( 0 - NO INPUT ERRORS
!                       1 - N .LE. 0
!                       2 - A .LE. 0.0
!                       3 - SEED OUT OF RANGE )
!
!           ***REFERENCE***
!
!           FISHMAN, GEORGE S., CONCEPTS AND METHODS IN DISCRETE EVENT
!           DIGITAL SIMULATION, JOHN WILEY AND SONS, NEW YORK, 1973,
!           P. 203.
!
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
!
!        CHECK TO ENSURE THAT THE DESIRED NUMBER OF VARIATES IS WITHIN
!        ACCEPTABLE RANGE
!
if (n .le. 0) go to 100
!
!        CHECK TO ENSURE THAT THE EXPONENTIAL PARAMETER HAS BEEN
!        PROPERLY SPECIFIED
!
if (a .le. 0.d0) go to 110
!
!        GENERATION OF UNIFORM RANDOM VARIATES
!
call durng (iseed, x, n, ierror)
if (ierror .ne. 0) go to 120
!
!        LOOP WHICH GENERATES THE N DESIRED VARIATES
!
do i=1,n
   x(i) = - a*dlog(x(i))
end do
return
!
!              ERROR RETURN
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
end subroutine drnexp

subroutine rgam (ix, a, n, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a
integer :: i, ind, max
real :: u, v, w
!-----------------------------------------------------------------------
!
!               COMPUTATION OF N VARIATES X(1),...,X(N)
!               FROM THE GAMMA DISTRIBUTION HAVING THE
!                    PROBABILITY DENSITY FUNCTION
!
!                 F(T) = EXP(-T)*T**(A-1)/GAMMA(A)
!
!                        ------------------
!
!     IX IS A VARIABLE. ON INPUT IX IS A SEED FOR INITIALIZING THE
!     SEQUENCE OF VARIATES. ON OUTPUT IX IS A NEW SEED FOR OBTAINING
!     MORE VARIATES. IT IS ASSUMED THAT 1 .LE. IX .LT. 2**31 - 1.
!
!     IERR IS A VARIABLE WHICH REPORTS THE STATUS OF THE RESULTS.
!     WHEN THE SUBROUTINE TERMINATES IERR HAS ONE OF THE FOLLOWING
!     VALUES ...
!
!          IERR = 0   THE GAMMA VARIATES WERE OBTAINED.
!          IERR = 1   (INPUT ERROR) N .LE. 0
!          IERR = 2   (INPUT ERROR) A .LT. 0.1
!          IERR = 3   (INPUT ERROR) IX IS NOT A PROPER
!                      SEED.
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
!
data max /2147483647/
!
if (n .le. 0) go to 100
if (a .lt. 0.1) go to 110
if (ix .lt. 1 .or. ix .ge. max) go to 120
ierr = 0
!
!             THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!             VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!                   THE SETTING IND = -8 IS AVOIDED
!
do i = 1,n
   call urng0 (ix, u, v)
   call gaminv (a, w, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) w = 0.0
   x(i) = w
end do
return
!
!                            ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine rgam

subroutine drgam (ix, a, n, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, ind, max
!-----------------------------------------------------------------------
!
!             COMPUTATION OF N DOUBLE PRECISION VARIATES
!             X(1),...,X(N)  FROM THE GAMMA DISTRIBUTION
!              HAVING THE PROBABILITY DENSITY FUNCTION
!
!                 F(T) = EXP(-T)*T**(A-1)/GAMMA(A)
!
!                        ------------------
!
!     IX IS A VARIABLE. ON INPUT IX IS A SEED FOR INITIALIZING THE
!     SEQUENCE OF VARIATES. ON OUTPUT IX IS A NEW SEED FOR OBTAINING
!     MORE VARIATES. IT IS ASSUMED THAT 1 .LE. IX .LT. 2**31 - 1.
!
!     IERR IS A VARIABLE WHICH REPORTS THE STATUS OF THE RESULTS.
!     WHEN THE SUBROUTINE TERMINATES IERR HAS ONE OF THE FOLLOWING
!     VALUES ...
!
!          IERR = 0   THE GAMMA VARIATES WERE OBTAINED.
!          IERR = 1   (INPUT ERROR) N .LE. 0
!          IERR = 2   (INPUT ERROR) A .LT. 0.1
!          IERR = 3   (INPUT ERROR) IX IS NOT A PROPER
!                      SEED.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
double precision :: u, v, w
!
data max /2147483647/
!
if (n .le. 0) go to 100
if (a .lt. 0.1d0) go to 110
if (ix .lt. 1 .or. ix .ge. max) go to 120
ierr = 0
!
!             THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!             VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!                   THE SETTING IND = -8 IS AVOIDED
!
do i = 1,n
   call durng0 (ix, u, v)
   call dginv (a, w, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) w = 0.d0
   x(i) = w
end do
return
!
!                            ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine drgam

subroutine rbeta (n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a, b
integer :: i, ind, max
real :: u, v, x1, x2
!-----------------------------------------------------------------------
!
!                GENERATION OF BETA RANDOM VARIATES
!
!                           ------------
!
!     RBETA GENERATES N VARIATES FROM THE BETA DISTRIBUTION WITH
!     PARAMETERS A AND B WHERE A .GE. 0.25 AND B .GE. 0.25. THE
!     GENERATION SCHEME IS BASED ON THE FACT THAT X1 / (X1 + X2)
!     IS A VARIATE FROM THE BETA DISTRIBUTION WHEN X1 AND X2 ARE
!     INDEPENDENT VARIATES FROM THE STANDARD GAMMA DISTRIBUTIONS
!     WITH PARAMETERS A AND B RESPECTIVELY.
!
!     FORM OF THE BETA PROBABILITY DENSITY FUNCTION USED...
!
!       F(X) = X**(A - 1) * (1 - X)**(B - 1) / BETA(A,B)
!
!              WHERE  0 .LE. X .LE. 1  AND
!              BETA(A,B) IS THE BETA FUNCTION.
!
!     MEAN AND VARIANCE OF THE BETA DISTRIBUTION...
!
!              MEAN = A / (A + B)
!
!              VARIANCE = (A * B) / ((A + B)**2 * (A + B + 1))
!
!     INPUT...
!
!        N       - NUMBER OF VARIATES TO BE GENERATED
!        A       - PARAMETER OF THE BETA DISTRIBUTION
!        B       - PARAMETER OF THE BETA DISTRIBUTION
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE
!                  VARIATES
!        X       - ARRAY OF DIMENSION N CONTAINING THE
!                  BETA VARIATES
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - A OR B IS LESS THAN 0.25
!                   3 - SEED OUT OF RANGE        )
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (amin1(a,b) .lt. 0.25) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 120
ierr = 0
!
do i = 1,n
!
!        THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!        VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!        THE SETTING IND = -8 IN GAMINV IS AVOIDED.
!
   call urng0 (ix, u, v)
   call gaminv (a, x1, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.0
!
   call urng0 (ix, u, v)
   call gaminv (b, x2, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x2 = 0.0
!
!        IT IS REQUIRED THAT A AND B NOT BE LESS
!        THAN 0.25 SO THAT X1 + X2 IS NONZERO.
!
   x(i) = x1/(x1 + x2)
!
end do
return
!
!                      ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine rbeta

subroutine drbeta (n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, ind, max
!-----------------------------------------------------------------------
!
!                         DOUBLE PRECISION
!                GENERATION OF BETA RANDOM VARIATES
!
!                           ------------
!
!     DRBETA GENERATES N DOUBLE PRECISION VARIATES FROM THE BETA
!     DISTRIBUTION WITH PARAMETERS A AND B WHERE A .GE. 0.25 AND
!     B .GE. 0.25. THE GENERATION SCHEME IS BASED ON THE FACT
!     THAT X1 / (X1 + X2) IS A VARIATE FROM THE BETA DISTRIBUTION
!     WHEN X1 AND X2 ARE INDEPENDENT VARIATES FROM THE STANDARD
!     GAMMA DISTRIBUTIONS WITH PARAMETERS A AND B RESPECTIVELY.
!
!     FORM OF THE BETA PROBABILITY DENSITY FUNCTION USED...
!
!       F(X) = X**(A - 1) * (1 - X)**(B - 1) / BETA(A,B)
!
!              WHERE  0 .LE. X .LE. 1  AND
!              BETA(A,B) IS THE BETA FUNCTION.
!
!     MEAN AND VARIANCE OF THE BETA DISTRIBUTION...
!
!              MEAN = A / (A + B)
!
!              VARIANCE = (A * B) / ((A + B)**2 * (A + B + 1))
!
!     INPUT...
!
!        N       - NUMBER OF VARIATES TO BE GENERATED
!        A       - PARAMETER OF THE BETA DISTRIBUTION
!        B       - PARAMETER OF THE BETA DISTRIBUTION
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE
!                  VARIATES
!        X       - ARRAY OF DIMENSION N CONTAINING THE
!                  BETA VARIATES
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - A OR B IS LESS THAN 0.25
!                   3 - SEED OUT OF RANGE        )
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a, b
double precision, intent(inout) :: x(n)
double precision :: u, v, x1, x2
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (dmin1(a,b) .lt. 0.25d0) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 120
ierr = 0
!
do i = 1,n
!
!        THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!        VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!        THE SETTING IND = -8 IN GAMINV IS AVOIDED.
!
   call durng0 (ix, u, v)
   call dginv (a, x1, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.d0
!
   call durng0 (ix, u, v)
   call dginv (b, x2, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x2 = 0.d0
!
!        IT IS REQUIRED THAT A AND B NOT BE LESS
!        THAN 0.25 SO THAT X1 + X2 IS NONZERO.
!
   x(i) = x1/(x1 + x2)
!
end do
return
!
!                      ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine drbeta

subroutine fran (n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a, b
integer :: i, ind, max
real :: ahalf, bhalf, big, bound, c, t, u, v, x1, x2, xmax
real :: spmpar
!-----------------------------------------------------------------------
!
!          GENERATION OF VARIATES FROM THE F-DISTRIBUTION
!
!                          --------------
!
!     FRAN GENERATES N VARIATES FROM THE F-DISTRIBUTION WITH
!     PARAMETERS A AND B (CALLED THE NUMERATOR AND DENOMINATOR
!     DEGREES OF FREEDOM) WHERE A .GE. 0.5 AND B .GE. 0.5. THE
!     GENERATION SCHEME IS BASED ON THE FACT THAT (B/A)*(X1/X2)
!     IS A VARIATE FROM THE F-DISTRIBUTION WHEN X1 AND X2 ARE
!     INDEPENDENT VARIATES FROM THE STANDARD GAMMA DISTRIBUTIONS
!     WITH PARAMETERS A/2 AND B/2 RESPECTIVELY.
!
!
!     INPUT...
!
!        N       - NUMBER OF VARIATES TO BE GENERATED
!        A       - NUMERATOR DEGREES OF FREEDOM PARAMETER
!        B       - DENOMINATOR DEGREES OF FREEDOM PARAMETER
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE
!                  VARIATES
!        X       - ARRAY OF DIMENSION N CONTAINING THE
!                  F DISTRIBUTION VARIATES
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - A OR B IS LESS THAN 0.5
!                   3 - B IS TOO SMALL FOR THE
!                       FLOATING ARITHMETIC USED
!                   4 - SEED OUT OF RANGE       )
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
!--------------------
data max /2147483647/
!--------------------
!
!     ****** XMAX IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
!            LARGEST NUMBER IN THE FLOATING ARITHMETIC USED.
!
             xmax = spmpar(3)
!
!--------------------
if (n .le. 0) go to 100
if (amin1(a,b) .lt. 0.5) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
ierr = 0
!
ahalf = 0.5*a
bhalf = 0.5*b
c = b/a
big = 0.5*xmax
bound = amax1(c, 1.0)
!
do i = 1,n
!
!        THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!        VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!        THE SETTING IND = -8 IN GAMINV IS AVOIDED.
!
   call urng0 (ix, u, v)
   call gaminv (ahalf, x1, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.0
!
   call urng0 (ix, u, v)
   call gaminv (bhalf, x2, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) go to 120
!
!        PROTECT AGAINST OVERFLOW IN COMPUTING THE
!        VARIATE C*(X1/X2).
!
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big .le. bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!
!                      ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine fran

subroutine dfran (n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, ind, max
!-----------------------------------------------------------------------
!
!                  DOUBLE PRECISION GENERATION OF
!                 VARIATES FROM THE F-DISTRIBUTION
!
!                          --------------
!
!     DFRAN GENERATES N VARIATES FROM THE F-DISTRIBUTION WITH
!     PARAMETERS A AND B (CALLED THE NUMERATOR AND DENOMINATOR
!     DEGREES OF FREEDOM) WHERE A .GE. 0.5 AND B .GE. 0.5. THE
!     GENERATION SCHEME IS BASED ON THE FACT THAT (B/A)*(X1/X2)
!     IS A VARIATE FROM THE F-DISTRIBUTION WHEN X1 AND X2 ARE
!     INDEPENDENT VARIATES FROM THE STANDARD GAMMA DISTRIBUTIONS
!     WITH PARAMETERS A/2 AND B/2 RESPECTIVELY.
!
!
!     INPUT...
!
!        N       - NUMBER OF VARIATES TO BE GENERATED
!        A       - NUMERATOR DEGREES OF FREEDOM PARAMETER
!        B       - DENOMINATOR DEGREES OF FREEDOM PARAMETER
!        IX      - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES
!
!     OUTPUT...
!
!        IX      - SEED TO BE USED FOR OBTAINING MORE
!                  VARIATES
!        X       - ARRAY OF DIMENSION N CONTAINING THE
!                  F DISTRIBUTION VARIATES
!        IERR    - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - A OR B IS LESS THAN 0.5
!                   3 - B IS TOO SMALL FOR THE
!                       FLOATING ARITHMETIC USED
!                   4 - SEED OUT OF RANGE       )
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a, b
double precision, intent(inout) :: x(n)
double precision :: ahalf, bhalf, big, bound, c, t, u, v, xmax, &
&x1, x2
double precision :: dpmpar
!--------------------
data max /2147483647/
!--------------------
!
!     ****** XMAX IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
!            LARGEST NUMBER IN THE FLOATING ARITHMETIC USED.
!
             xmax = dpmpar(3)
!
!--------------------
if (n .le. 0) go to 100
if (dmin1(a,b) .lt. 0.5d0) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
ierr = 0
!
ahalf = 0.5d0*a
bhalf = 0.5d0*b
c = b/a
big = 0.5d0*xmax
bound = dmax1(c, 1.d0)
!
do i = 1,n
!
!        THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!        VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!        THE SETTING IND = -8 IN GAMINV IS AVOIDED.
!
   call durng0 (ix, u, v)
   call dginv (ahalf, x1, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.d0
!
   call durng0 (ix, u, v)
   call dginv (bhalf, x2, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) go to 120
!
!        PROTECT AGAINST OVERFLOW IN COMPUTING THE
!        VARIATE C*(X1/X2).
!
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big .le. bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!
!                      ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine dfran

subroutine tran (n, a, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a
integer :: i, ind, max
real :: ahalf, d, s, u, v, w, z
!-----------------------------------------------------------------------
!
!          GENERATION OF VARIATES FROM THE T-DISTRIBUTION
!
!                          --------------
!
!        TRAN GENERATES N RANDOM VARIATES FROM A T-DISTRIBUTION
!        WITH PARAMETER A (CALLED THE DEGREES OF FREEDOM) WHERE
!        A .GE. 0.5. THE GENERATION SCHEME IS BASED ON THE FACT
!        THAT X/SQRT(Y/A) IS A VARIATE FROM THE T-DISTRIBUTION
!        WHEN X IS A STANDARD NORMAL VARIATE AND Y A CHI-SQUARE
!        VARIATE WITH A DEGREES OF FREEDOM.
!
!
!        INPUT...
!
!           N    - NUMBER OF VARIATES TO BE GENERATED
!           A    - DEGREES OF FREEDOM PARAMETER
!           IX   - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES
!
!        OUTPUT...
!
!           IX   - SEED TO BE USED FOR OBTAINING MORE
!                  VARIATES
!           X    - ARRAY OF DIMENSION N CONTAINING THE
!                  T-DISTRIBUTION VARIATES
!           IERR - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - A .LT. 0.5
!                   3 - A IS TOO SMALL FOR THE
!                       FLOATING ARITHMETIC USED
!                   4 - SEED OUT OF RANGE       )
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (a .lt. 0.5) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
!
ierr = 0
ahalf = 0.5*a
!
do i = 1,n
!
!                    GET A NORMAL VARIATE
!
   call urng1 (ix, u, v, d)
   call pni (u, v, d, z, ind)
!
!                    GET A GAMMA VARIATE
!
!        THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!        VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!        THE SETTING IND = -8 IN GAMINV IS AVOIDED.
!
   call urng0 (ix, u, v)
   call gaminv (ahalf, w, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) go to 120
!
   s = sqrt(w/ahalf)
   x(i) = z/s
end do
return
!
!              ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine tran

subroutine dtran (n, a, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer :: i, ind, max
!-----------------------------------------------------------------------
!
!                  DOUBLE PRECISION GENERATION OF
!                 VARIATES FROM THE T-DISTRIBUTION
!
!                          --------------
!
!        DTRAN GENERATES N RANDOM VARIATES FROM A T-DISTRIBUTION
!        WITH PARAMETER A (CALLED THE DEGREES OF FREEDOM) WHERE
!        A .GE. 0.5. THE GENERATION SCHEME IS BASED ON THE FACT
!        THAT X/SQRT(Y/A) IS A VARIATE FROM THE T-DISTRIBUTION
!        WHEN X IS A STANDARD NORMAL VARIATE AND Y A CHI-SQUARE
!        VARIATE WITH A DEGREES OF FREEDOM.
!
!
!        INPUT...
!
!           N    - NUMBER OF VARIATES TO BE GENERATED
!           A    - DEGREES OF FREEDOM PARAMETER
!           IX   - INTEGER SEED USED TO INITIALIZE THE
!                  SEQUENCE OF VARIATES
!
!        OUTPUT...
!
!           IX   - SEED TO BE USED FOR OBTAINING MORE
!                  VARIATES
!           X    - ARRAY OF DIMENSION N CONTAINING THE
!                  T-DISTRIBUTION VARIATES
!           IERR - INPUT ERROR FLAG
!                  (0 - NO INPUT ERRORS
!                   1 - N .LE. 0
!                   2 - A .LT. 0.5
!                   3 - A IS TOO SMALL FOR THE
!                       FLOATING ARITHMETIC USED
!                   4 - SEED OUT OF RANGE       )
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
double precision :: ahalf, d, s, u, v, w, z
!--------------------
data max /2147483647/
!--------------------
if (n .le. 0) go to 100
if (a .lt. 0.5d0) go to 110
if (ix .le. 0 .or. ix .ge. max) go to 130
!
ierr = 0
ahalf = 0.5d0*a
!
do i = 1,n
!
!                    GET A NORMAL VARIATE
!
   call durng1 (ix, u, v, d)
   call dpni (u, v, d, z, ind)
!
!                    GET A GAMMA VARIATE
!
!        THE FOLLOWING CODE ASSUMES THAT THE UNIFORM
!        VARIATES ARE FAR ENOUGH FROM 0 AND 1 SO THAT
!        THE SETTING IND = -8 IN GAMINV IS AVOIDED.
!
   call durng0 (ix, u, v)
   call dginv (ahalf, w, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) go to 120
!
   s = dsqrt(w/ahalf)
   x(i) = z/s
end do
return
!
!              ERROR RETURN
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine dtran

subroutine rmk1 (n, fmu, sig, alpha, iseed, x, ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
real, intent(in) :: alpha, fmu, sig
integer :: i
real :: c, sigi, t
!
!              ***SUBROUTINE PURPOSE AND DESCRIPTION***
!
!           RMK1 GENERATES AN AUTOCORRELATED SEQUENCE X OF
!           LENGTH N WHERE X IS A FIRST-ORDER MARKOV PROCESS
!           WITH PARAMETER ALPHA (ABS(ALPHA) .LT. 1). THE SEQUENCE
!           X(J) (J = 2,...,N) IS GENERATED BY
!
!                  X(J) - FMU = ALPHA*(X(J-1) - FMU) + Z(J).
!
!           Z(J) IS THE RANDOM ERROR TERM, ASSUMED TO BE NORMALLY
!           DISTRIBUTED WITH MEAN 0 AND STANDARD DEVIATION SIG
!           (SIG .GE. 0). THE GENERATION SCHEME ASSUMES THAT X IS
!           A NORMAL PROCESS WITH MEAN FMU AND VARIANCE
!
!                      SIG*SIG / (1 - ALPHA*ALPHA) .
!
!           X IS A STATIONARY PROCESS PROVIDED THAT ABS(ALPHA) .LT.
!           1. THE AUTOCORRELATION STRUCTURE OF THE SEQUENCE IS
!           CHARACTERIZED BY THE FACT THAT THE CORRELATION BETWEEN
!           TERMS BECOMES PROGRESSIVELY WEAKER WITH INCREASING LAG.
!           WE NOTE THAT A FIRST-ORDER MARKOV PROCESS IS SYNONOMOUS
!           WITH A FIRST-ORDER AUTOREGRESSIVE (AR) PROCESS.
!
!           ***PARAMETER LIST***
!
!           INPUT...
!
!           N       - LENGTH OF THE SEQUENCE TO BE GENERATED.
!                     IT IS ASSUMED THAT N .GE. 2.
!           FMU     - MEAN OF THE NORMAL PROCESS
!           SIG     - STANDARD DEVIATION OF THE NORMALLY
!                     DISTRIBUTED ERROR TERM
!           ALPHA   - VALUE OF THE MARKOV MODEL PARAMETER
!           ISEED   - INTEGER SEED USED TO INITIALIZE THE
!                     SEQUENCE OF NORMAL VARIATES GENERATED
!                     BY SUBROUTINE RNOR
!
!           OUTPUT...
!
!           ISEED   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     ROUTINE
!           X       - OUTPUT ARRAY OF DIMENSION N CONTAINING
!                     THE GENERATED FIRST-ORDER MARKOV SEQUENCE
!           IERROR  - INPUT ERROR FLAG
!                     ( 0 - NO INPUT ERRORS
!                       1 - N .LE. 1
!                       2 - SIG .LT. 0
!                       3 - ABS(ALPHA) .GE. 1
!                       4 - SEED OUT OF RANGE )
!
!           ***REFERENCE***
!
!           FISHMAN, GEORGE S., CONCEPTS AND METHODS IN DISCRETE EVENT
!           DIGITAL SIMULATION, JOHN WILEY AND SONS, NEW YORK, 1973,
!           PP. 236 - 237.
!
real, intent(inout) :: x(n)
!
!        CHECK TO ENSURE THAT THE DESIRED SEQUENCE LENGTH IS WITHIN
!        ACCEPTABLE RANGE
!
if (n .le. 1) go to 100
!
!        CHECK TO ENSURE THAT THE STANDARD DEVIATION OF THE ERROR TERM
!        IS WITHIN ACCEPTABLE RANGE
!
if (sig .le. 0.0) go to 110
!
!        CHECK TO ENSURE THAT THE FIRST-ORDER MARKOV MODEL
!        PARAMETER IS WITHIN THE RANGE REQUIRED TO GUARANTEE
!        PROCESS STATIONARITY
!
if (abs(alpha) .ge. 1.0) go to 120
!
!        GENERATION OF STANDARD NORMAL RANDOM VARIATES
!
call rnor (iseed,x,n,ierror)
if (ierror .ne. 0) go to 130
!
!        COMPUTES THE STANDARD DEVIATION OF THE INITIAL TERM OF THE
!        AUTOCORRELATED SEQUENCE
!
c = 0.5 + (0.5 - alpha)
t = 0.5 + (0.5 + alpha)
sigi = sig/sqrt(c*t)
!
!        COMPUTES THE INITIAL TERM OF THE REQUIRED AUTOCORRELATED
!        SEQUENCE
!
x(1) = fmu + sigi*x(1)
!
!        GENERATES THE LAST N - 1 TERMS OF THE REQUIRED AUTOCORRELATED
!        SEQUENCE
!
c = fmu*c
do i=2,n
   x(i) = alpha*x(i-1) + c + sig*x(i)
end do
return
!
!        ERROR RETURN
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
130 ierror = 4
return
end subroutine rmk1

subroutine drmk1 (n, fmu, sig, alpha, iseed, x, ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
integer :: i
!
!              ***SUBROUTINE PURPOSE AND DESCRIPTION***
!
!           DRMK1 GENERATES AN AUTOCORRELATED SEQUENCE X OF
!           LENGTH N WHERE X IS A FIRST-ORDER MARKOV PROCESS
!           WITH PARAMETER ALPHA (ABS(ALPHA) .LT. 1). THE SEQUENCE
!           X(J) (J = 2,...,N) IS GENERATED BY
!
!                  X(J) - FMU = ALPHA*(X(J-1) - FMU) + Z(J).
!
!           Z(J) IS THE RANDOM ERROR TERM, ASSUMED TO BE NORMALLY
!           DISTRIBUTED WITH MEAN 0 AND STANDARD DEVIATION SIG
!           (SIG .GE. 0). THE GENERATION SCHEME ASSUMES THAT X IS
!           A NORMAL PROCESS WITH MEAN FMU AND VARIANCE
!
!                      SIG*SIG / (1 - ALPHA*ALPHA) .
!
!           X IS A STATIONARY PROCESS PROVIDED THAT ABS(ALPHA) .LT.
!           1. THE AUTOCORRELATION STRUCTURE OF THE SEQUENCE IS
!           CHARACTERIZED BY THE FACT THAT THE CORRELATION BETWEEN
!           TERMS BECOMES PROGRESSIVELY WEAKER WITH INCREASING LAG.
!           WE NOTE THAT A FIRST-ORDER MARKOV PROCESS IS SYNONOMOUS
!           WITH A FIRST-ORDER AUTOREGRESSIVE (AR) PROCESS.
!
!           ***PARAMETER LIST***
!
!           INPUT...
!
!           N       - LENGTH OF THE SEQUENCE TO BE GENERATED.
!                     IT IS ASSUMED THAT N .GE. 2.
!           FMU     - MEAN OF THE NORMAL PROCESS
!           SIG     - STANDARD DEVIATION OF THE NORMALLY
!                     DISTRIBUTED ERROR TERM
!           ALPHA   - VALUE OF THE MARKOV MODEL PARAMETER
!           ISEED   - INTEGER SEED USED TO INITIALIZE THE
!                     SEQUENCE OF NORMAL VARIATES GENERATED
!                     BY SUBROUTINE DRNOR
!
!           OUTPUT...
!
!           ISEED   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     ROUTINE
!           X       - OUTPUT ARRAY OF DIMENSION N CONTAINING
!                     THE GENERATED FIRST-ORDER MARKOV SEQUENCE
!           IERROR  - INPUT ERROR FLAG
!                     ( 0 - NO INPUT ERRORS
!                       1 - N .LE. 1
!                       2 - SIG .LT. 0
!                       3 - ABS(ALPHA) .GE. 1
!                       4 - SEED OUT OF RANGE )
!
!           ***REFERENCE***
!
!           FISHMAN, GEORGE S., CONCEPTS AND METHODS IN DISCRETE EVENT
!           DIGITAL SIMULATION, JOHN WILEY AND SONS, NEW YORK, 1973,
!           PP. 236 - 237.
!
double precision, intent(in) :: fmu, sig, alpha
double precision, intent(inout) :: x(n)
double precision :: c, sigi, t
!
!        CHECK TO ENSURE THAT THE DESIRED SEQUENCE LENGTH IS WITHIN
!        ACCEPTABLE RANGE
!
if (n .le. 1) go to 100
!
!        CHECK TO ENSURE THAT THE STANDARD DEVIATION OF THE ERROR TERM
!        IS WITHIN ACCEPTABLE RANGE
!
if (sig .le. 0.d0) go to 110
!
!        CHECK TO ENSURE THAT THE FIRST-ORDER MARKOV MODEL
!        PARAMETER IS WITHIN THE RANGE REQUIRED TO GUARANTEE
!        PROCESS STATIONARITY
!
if (dabs(alpha) .ge. 1.d0) go to 120
!
!        GENERATION OF STANDARD NORMAL RANDOM VARIATES
!
call drnor (iseed,x,n,ierror)
if (ierror .ne. 0) go to 130
!
!        COMPUTES THE STANDARD DEVIATION OF THE INITIAL TERM OF THE
!        AUTOCORRELATED SEQUENCE
!
c = 0.5d0 + (0.5d0 - alpha)
t = 0.5d0 + (0.5d0 + alpha)
sigi = sig/dsqrt(c*t)
!
!        COMPUTES THE INITIAL TERM OF THE REQUIRED AUTOCORRELATED
!        SEQUENCE
!
x(1) = fmu + sigi*x(1)
!
!        GENERATES THE LAST N - 1 TERMS OF THE REQUIRED AUTOCORRELATED
!        SEQUENCE
!
c = fmu*c
do i=2,n
   x(i) = alpha*x(i-1) + c + sig*x(i)
end do
return
!
!        ERROR RETURN
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
130 ierror = 4
return
end subroutine drmk1
