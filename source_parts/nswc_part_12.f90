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
!     sepel1 sets up vectors and arrays for input to blktri
!     and computes a second order solution in USOL.  A return jump to
!     sepell OCCURRS IF iorder=2.  IF iorder=4 A FOURTH ORDER
!     solution is generated in USOL.
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
!     Set parameters internally
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
!     Set right hand side values from GRHS in USOL on the interior
!     and non-specified boundaries.
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
!     Set switches for periodic or non-periodic boundaries
!
mp = 1
np = 1
if (kswx .eq. 1) mp = 0
if (kswy .eq. 1) np = 0
!
!     Set dlx,dly and size of block TRI-diagonal system generated
!     in NINT,mint
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
!     Set subscript limits for portion of array to input to blktri
!
is = 1
js = 1
if (kswx.eq.2 .or. kswx.eq.3) is = 2
if (kswy.eq.2 .or. kswy.eq.3) js = 2
ns = nit+js-1
ms = mit+is-1
!
!     Set X - direction
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
!     Set Y direction
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
!     Adjust edges in X direction unless periodic
!
ax1 = am(1)
cxm = cm(mit)
go to (170,130,150,160,140),kswx
!
!     Dirichlet-Dirichlet in X direction
!
130 am(1) = 0.0
cm(mit) = 0.0
go to 170
!
!     Mixed-Dirichlet in X direction
!
140 am(1) = 0.0
bm(1) = bm(1)+2.*alpha*dlx*ax1
cm(1) = cm(1)+ax1
cm(mit) = 0.0
go to 170
!
!     Dirichlet-mixed in X direction
!
150 am(1) = 0.0
am(mit) = am(mit)+cxm
bm(mit) = bm(mit)-2.*beta*dlx*cxm
cm(mit) = 0.0
go to 170
!
!     Mixed - mixed in X direction
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
!     Adjust in Y direction unless periodic
!
dy1 = an(1)
fyn = cn(nit)
go to (220,180,200,210,190),kswy
!
!     Dirichlet-Dirichlet in Y direction
!
180 continue
an(1) = 0.0
cn(nit) = 0.0
go to 220
!
!     Mixed-Dirichlet in Y direction
!
190 continue
an(1) = 0.0
bn(1) = bn(1)+2.*dly*gama*dy1
cn(1) = cn(1)+dy1
cn(nit) = 0.0
go to 220
!
!     Dirichlet-mixed in Y direction
!
200 an(1) = 0.0
an(nit) = an(nit)+fyn
bn(nit) = bn(nit)-2.*dly*xnu*fyn
cn(nit) = 0.0
go to 220
!
!     Mixed - mixed direction in Y direction
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
!     Adjust USOL along X edge
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
!     Adjust USOL along Y edge
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
!     SAVE ADJUSTED EDGES IN GRHS IF iorder=4
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
!     Check if operator is singular
!
call chksng (mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy,singlr)
!
!     Compute non-zero eigenvector in null space of transpose
!     if singular
!
if (singlr) call trisp (mit,am,bm,cm,dm,um,zm)
if (singlr) call trisp (nit,an,bn,cn,dn,un,zn)
!
!     Make initialization call to blktri
!
if (intl .eq. 0) &
&call blktri (intl,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn, &
&usol(is,js),ierror,w)
if (ierror .ne. 0) return
!
!     Adjust right hand side if necessary
!
360 continue
if (singlr) call orthg (usol,idmn,zn,zm,pertrb)
!
!     Compute solution
!
call blktri (i1,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn,usol(is,js), &
&ierror,w)
if (ierror .ne. 0) return
!
!     Set periodic boundaries if necessary
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
!     Minimize solution with respect to weighted least squares
!     norm if operator is singular
!
if (singlr) call minsol (usol,idmn,zn,zm,prtrb)
!
!     RETURN IF DEFERRED CORRECTIONS AND A FOURTH ORDER SOLUTION ARE
!     not flagged
!
if (iord .eq. 2) return
iord = 2
!
!     Compute new right hand side for fourth order solution
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
!     This program checks the input parameters for errors
!
!
!     Check definition of solution region
!
ierror = 1
if (a.ge.b .or. c.ge.d) return
!
!     Check boundary switches
!
ierror = 2
if (mbdcnd.lt.0 .or. mbdcnd.gt.4) return
ierror = 3
if (nbdcnd.lt.0 .or. nbdcnd.gt.4) return
!
!     Check first dimension in calling routine
!
ierror = 5
if (mn .lt. 7 .or. idmn .lt. 7) return
!
!     Check m
!
ierror = 6
if (m .gt. (idmn-1) .or. m.lt.6) return
if (m .gt. mn - 1) return
!
!     Check n
!
ierror = 7
if (n .lt. 5) return
!
!     Check iorder
!
ierror = 8
if (iorder.ne.2 .and. iorder.ne.4) return
!
!     Check intl
!
ierror = 9
if (intl.ne.0 .and. intl.ne.1) return
!
!     Check that equation is elliptic
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
!     No error found
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
!     THIS SUBROUTINE CHECKS IF THE PDE   sepell
!     must solve is a singular operator
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
!     Check if the boundary conditions are
!     entirely periodic and/or mixed
!
if ((mbdcnd.ne.0 .and. mbdcnd.ne.3) .or. &
&(nbdcnd.ne.0 .and. nbdcnd.ne.3)) return
!
!     Check that mixed conditions are pure neuman
!
if (mbdcnd .ne. 3) go to  10
if (alpha.ne.0.0 .or. beta.ne.0.0) return
10 if (nbdcnd .ne. 3) go to  20
if (gama.ne.0.0 .or. xnu.ne.0.0) return
20 continue
!
!     Check that non-derivative coefficient functions
!     are zero
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
!     The operator must be singular if this point is reached
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
!     This subroutine orthogonalizes the array usol with respect to
!     the constant array in a weighted least squares norm
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
!     Compute weighted inner products
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
!     Set perturbation parameter
!
pertrb = ute/ete
!
!     Subtract off constant pertrb
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
!     This subroutine orthogonalizes the array usol with respect to
!     the constant array in a weighted least squares norm
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
!     Entry at minsol occurrs when the final solution is
!     to be minimized with respect to the weighted
!     least squares norm
!
istr = 1
ifnl = k
jstr = 1
jfnl = l
!
!     Compute weighted inner products
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
!     Set perturbation parameter
!
pertrb = ute/ete
!
!     Subtract off constant pertrb
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
!     This subroutine solves for a non-zero eigenvector corresponding
!     to the zero eigenvalue of the transpose of the rank
!     deficient one matrix with subdiagonal A, diagonal b, and
!     superdiagonal c , with a(1) in the (1,n) position, with
!     c(n) in the (n,1) position, and all other elements zero.
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
!     Set last component equal to one
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
!     This subroutine first approximates the truncation error given
!     BY  TRUN1(X,Y)=dlx**2*tx+dly**2*ty WHERE
!     tx=AFUN(X)*uxxxx/12.0+BFUN(X)*uxxx/6.0 ON THE INTERIOR AND
!     at the boundaries if periodic (here uxxx,uxxxx are the third
!     and fourth partial derivatives of U with respect to X).
!     tx is of the form AFUN(X)/3.0*(uxxxx/4.0+uxxx/dlx)
!     AT X=A OR X=B IF THE BOUNDARY CONDITION THERE IS MIXED.
!     tx=0.0 ALONG SPECIFIED BOUNDARIES.  ty HAS SYMMETRIC FORM
!     in Y with X,AFUN(X),BFUN(X) replaced by Y,DFUN(Y),EFUN(Y).
!     The second order solution in usol is used to approximate
!     (via second order finite differencing) the TRUN1ATION error
!     and the result is added to the right hand side in grhs
!     and then transferred to usol to be used as a new right
!     hand side when calling blktri for a fourth order solution.
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
&ait        ,bit        ,cit        ,dit        , &
&mit        ,nit        ,is         ,ms         , &
&js         ,ns         ,dlx        ,dly        , &
&tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
!     Compute truncation error approximation over the entire mesh
!
do j=js,ns
   yj = cit+float(j-1)*dly
   call cofy (yj,dj,ej,fj)
   do i=is,ms
      xi = ait+float(i-1)*dlx
      call cofx (xi,ai,bi,ci)
!
!     Compute partial derivative approximations at (XI,YJ)
!
      call dxfn (usol,idmn,i,j,uxxx,uxxxx)
      call dyfn (usol,idmn,i,j,uyyy,uyyyy)
      tx = ai*uxxxx/12.0+bi*uxxx/6.0
      ty = dj*uyyyy/12.0+ej*uyyy/6.0
!
!     Reset form of truncation if at boundary which is non-periodic
!
      if (kswx.eq.1 .or. (i.gt.1 .and. i.lt.k)) go to  10
      tx = ai/3.0*(uxxxx/4.0+uxxx/dlx)
10 if (kswy.eq.1 .or. (j.gt.1 .and. j.lt.l)) go to  20
      ty = dj/3.0*(uyyyy/4.0+uyyy/dly)
20 grhs(i,j) = grhs(i,j)+dlx**2*tx+dly**2*ty
   end do
end do
!
!     Reset the right hand side in usol
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
!     This program computes second order finite difference
!     approximations to the third and fourth X
!     partial derivatives of u at the (i,j) mesh point
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
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT X=A+dlx
!
30 if (kswx .eq. 1) go to  40
uxxx = (-3.0*u(1,j)+10.0*u(2,j)-12.0*u(3,j)+6.0*u(4,j)-u(5,j))/ &
&tdlx3
uxxxx = (2.0*u(1,j)-9.0*u(2,j)+16.0*u(3,j)-14.0*u(4,j)+6.0*u(5,j)- &
&u(6,j))/dlx4
return
!
!     PERIODIC AT X=A+dlx
!
40 uxxx = (-u(k-1,j)+2.0*u(1,j)-2.0*u(3,j)+u(4,j))/(tdlx3)
uxxxx = (u(k-1,j)-4.0*u(1,j)+6.0*u(2,j)-4.0*u(3,j)+u(4,j))/dlx4
return
!
!     Compute partial derivative approximations on the interior
!
50 continue
uxxx = (-u(i-2,j)+2.0*u(i-1,j)-2.0*u(i+1,j)+u(i+2,j))/tdlx3
uxxxx = (u(i-2,j)-4.0*u(i-1,j)+6.0*u(i,j)-4.0*u(i+1,j)+u(i+2,j))/ &
&dlx4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT X=B-dlx
!
60 if (kswx .eq. 1) go to  70
uxxx = (u(k-4,j)-6.0*u(k-3,j)+12.0*u(k-2,j)-10.0*u(k-1,j)+ &
&3.0*u(k,j))/tdlx3
uxxxx = (-u(k-5,j)+6.0*u(k-4,j)-14.0*u(k-3,j)+16.0*u(k-2,j)- &
&9.0*u(k-1,j)+2.0*u(k,j))/dlx4
return
!
!     PERIODIC AT X=B-dlx
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
!     This program computes second order finite difference
!     approximations to the third and fourth Y
!     partial derivatives of u at the (i,j) mesh point
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
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT Y=C+dly
!
30 if (kswy .eq. 1) go to  40
uyyy = (-3.0*u(i,1)+10.0*u(i,2)-12.0*u(i,3)+6.0*u(i,4)-u(i,5))/ &
&tdly3
uyyyy = (2.0*u(i,1)-9.0*u(i,2)+16.0*u(i,3)-14.0*u(i,4)+6.0*u(i,5)- &
&u(i,6))/dly4
return
!
!     PERIODIC AT Y=C+dly
!
40 uyyy = (-u(i,l-1)+2.0*u(i,1)-2.0*u(i,3)+u(i,4))/tdly3
uyyyy = (u(i,l-1)-4.0*u(i,1)+6.0*u(i,2)-4.0*u(i,3)+u(i,4))/dly4
return
!
!     Compute partial derivative approximations on the interior
!
50 continue
uyyy = (-u(i,j-2)+2.0*u(i,j-1)-2.0*u(i,j+1)+u(i,j+2))/tdly3
uyyyy = (u(i,j-2)-4.0*u(i,j-1)+6.0*u(i,j)-4.0*u(i,j+1)+u(i,j+2))/ &
&dly4
return
!
!     COMPUTE PARTIAL DERIVATIVE APPROXIMATIONS AT Y=D-dly
!
60 if (kswy .eq. 1) go to  70
uyyy = (u(i,l-4)-6.0*u(i,l-3)+12.0*u(i,l-2)-10.0*u(i,l-1)+ &
&3.0*u(i,l))/tdly3
uyyyy = (-u(i,l-5)+6.0*u(i,l-4)-14.0*u(i,l-3)+16.0*u(i,l-2)- &
&9.0*u(i,l-1)+2.0*u(i,l))/dly4
return
!
!     PERIODIC AT Y=D-dly
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
!         Documentation for this program is given in
!
!        Efficient Fortran subprograms for the solution of
!            elliptic partial differential equations
!
!                              By
!
!          PAUL SWARZTRAUBER   AND  ROLAND SWEET
!
!             TECHNICAL NOTE TN/IA-109   JULY 1975
!
!       National center for atmospheric research  boulder,colorado 80307
!
!        Which is sponsored by the national science foundation
!
!***********************************************************************
!
!
!
!     Subroutine blktri solves a system of linear equations of the form
!
!          an(J)*X(I,J-1) + am(I)*X(I-1,J) + (bn(J)+bm(I))*X(I,J)
!
!          + cn(J)*X(I,J+1) + cm(I)*X(I+1,J) = y(I,J)
!
!               FOR I = 1,2,...,m  AND  J = 1,2,...,n.
!
!     I+1 and I-1 are evaluated modulo m and J+1 and J-1 modulo n, I.E.,
!
!          x(i,0) = x(i,n),  x(i,n+1) = x(i,1),
!          x(0,j) = x(m,j),  x(m+1,j) = x(1,j).
!
!     These equations usually result from the discretization of
!     separable elliptic equations.  Boundary conditions may be
!     Dirichlet, Neumann, or periodic.
!
!
!     * * * * * * * * * *     ON INPUT     * * * * * * * * * *
!
!     iflg
!       = 0  INITIALIZATION ONLY.  CERTAIN QUANTITIES THAT DEPEND ON np,
!                                  n, an, bn, and cn are computed and
!                                  STOR1D in the work array  w.
!       = 1  THE QUANTITIES THAT WERE COMPUTED IN THE INITIALIZATION ARE
!            used to obtain the solution X(I,J).
!
!       NOTE   A CALL WITH iflg=0 TAKES APPROXIMATELY ONE HALF THE TIME
!              TIME AS A CALL WITH iflg = 1  .  HOWEVER, THE
!              initialization does not have to be repeated unless np, n,
!              an, bn, or cn change.
!
!     np
!       = 0  IF an(1) AND cn(n) ARE NOT ZERO, WHICH CORRESPONDS TO
!            periodic bounary conditions.
!       = 1  IF an(1) AND cn(n) ARE ZERO.
!
!     n
!       the number of unknowns in the J-direction. n must be greater
!       than 2. The operation count is proportional to MNLOG2(n), hence
!       n should be selected less than or equal to m.
!
!     AN,bn,cn
!       one-dimensional arrays of length n that specify the coefficients
!       in the linear equations given above.
!
!     MP
!       = 0  IF am(1) AND cm(m) ARE NOT ZERO, WHICH CORRESPONDS TO
!            periodic boundary conditions.
!       = 1  IF am(1) = cm(m) = 0  .
!
!     m
!       the number of unknowns in the I-direction. m must be greater
!       than 2.
!
!     AM,bm,cm
!       one-dimensional arrays of length m that specify the coefficients
!       in the linear equations given above.
!
!     idimy
!       the row (or first) dimension of the two-dimensional array y as
!       it appears in the program calling blktri.  This parameter is
!       used to specify the variable DIMENSION of y.  idimy must be at
!       LEAST m.
!
!     y
!       a two-dimensional array that specifies the values of the right
!       side of the linear system of equations given above.  y must be
!       dimensioned at least m*n.
!
!     w
!       a one-dimensional array that must be provided by the user for
!       work space.
!             IF np=1 DEFINE k=int(LOG2(n))+1 AND SET L=2**(k+1) THEN
!                     w must have dimension (k-2)*L+k+4+max(2n,6m)
!
!             IF np=0 DEFINE k=int(LOG2(n-1))+1 AND SET L=2**(k+1) THEN
!                     w must have dimension (k-2)*L+k+4+2n+max(2n,6m)
!
!       **IMPORTANT** FOR PURPOSES OF CHECKING, THE REQUIRED DIMENSION
!                     of w is computed by blktri and STOR1D in w(1)
!                     in floating point format.
!
!     * * * * * * * * * *     ON OUTPUT     * * * * * * * * * *
!
!     y
!       contains the solution X.
!
!     Ierror
!       an error flag that indicates invalid input parameters.  Except
!       for number zero, a solution is not attempted.
!
!       = 0  NO ERROR.
!       = 1  m IS LESS THAN 5
!       = 2  n IS LESS THAN 3.
!       = 3  idimy IS LESS THAN m.
!       = 4  blktri FAILED WHILE COMPUTING RESULTS THAT DEPEND ON THE
!            coefficient arrays an, bn, cn.  Check these arrays.
!       = 5  an(J)*cn(J-1) IS LESS THAN 0 FOR SOME J. POSSIBLE REASONS
!            for this condition are
!            1. The arrays an and cn are not correct
!            2. Too large a grid spacing was used in the discretization
!               of the elliptic equation
!            3. The linear equations resulted from a partial
!               differential equation which was not elliptic
!
!     w
!       contains intermediate values that must not be destroyed if
!       blktri WILL BE CALLED AGAIN WITH iflg = 1  .
!
!
!
external        prod0      ,prodp      ,cprod0     ,cprodp
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
! Test m and n for the proper form
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
!     Divide w into working sub arrays
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
! Subroutine compb computes the roots of the B polynomials
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
! Subroutine blktr1 solves the linear system
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
! blktr1 solves the linear system
!
! b  CONTAINS THE ROOTS OF ALL THE b POLYNOMIALS
! w1,W2,W3,WD,WW,WU  ARE ALL WORKING ARRAYS
! PRDCT IS EITHER prodp OR prod0 DEPENDING ON WHETHER THE BOUNDARY
! CONDITIONS IN THE m DIRECTION ARE PERIODIC OR NOT
! CPRDCT IS EITHER cprodp OR cprod0 WHICH ARE THE COMPLEX VERSIONS
! OF prodp AND prod0. THESE ARE CALLED IN THE EVENT THAT SOME
! OF THE ROOTS OF THE b SUB P POLYNOMIAL ARE COMPLEX
!
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
&nm         ,ncmplx     ,ik
!
! Begin reduction phase
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
!     The periodic case is treated using the capacitance matrix method
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
! Begin back substitution phase
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
! B(idx) is the location of the first root of the B(i,ir) polynomial
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
! prod0 applies a sequence of matrix operations to the vector x and
! stores the result in y.
!
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         THE LENGTH OF THE ARRAY aa.
! x,y        MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS y.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,w,u      WORKING ARRAYS.
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
! Scalar multiplication
!
do j=1,m
   y(j) = rt*w(j)
end do
50 if (id) 250,250, 60
60 rt = bd(id)
id = id-1
if (id .eq. 0) ibr = 1
!
! Begin solution to system
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
! prodp applies a sequence of matrix operations to the vector x and
! STORES THE RESULT IN y.   (PERIODIC BOUNDARY CONDITIONS)
!
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         LENGTH OF THE ARRAY aa.
! x,y        MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS y.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,u,w      WORKING ARRAYS.
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
! Begin solution to system
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
! cprod0 applies a sequence of matrix operations to the vector x and
! STORES THE RESULT IN yy.   (COMPLEX CASE)
!
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! na         THE LENGTH OF THE ARRAY aa.
! x,yy       MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS yy.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,w,y      WORKING ARRAYS.
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
! Begin solution to system
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
! Matrix multiplication
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
! Scalar multiplication
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
! prodp applies a sequence of matrix operations to the vector x and
! stores the result in yy.  (Periodic boundary conditions and
! complex case)
!
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         THE LENGTH OF THE ARRAY aa.
! x,yy       MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS yy.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,u,y      WORKING ARRAYS.
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
! Begin solution to system
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
! Matrix multiplication
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
! Scalar multiplication
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
!     compb computes the roots of the b polynomials using tqlrt0,
!     which is a modification of the EISPACK subroutine tqlrat.
!     Ierror is set to 4 if either tqlrt0 fails or A(j+1)*C(j) is
!     less than 0 for some j. ah and bh are temporary work arrays.
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
!     Error return
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
!     This subroutine is a modification of the EISPACK subroutine
!     tqlrat. The subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!
!     On input-
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e2 CONTAINS THE                SUBDIAGONAL ELEMENTS OF THE
!          input matrix in its last n-1 positions.  e2(1) is arbitrary.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!
!        e2 has been destroyed,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the relative precision of floating point arithmetic.
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
!     ********** e2(n) IS ALWAYS ZERO, SO THERE IS NO EXIT
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
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
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
!     ********** GUARD AGAINST UNDERFLOWED h **********
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
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
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
!     ppadd computes the eigenvalues of the periodic tridiagonal matrix
!     with coefficients an,BN,CN
!
! n   IS THE ORDER OF THE bh AND bp POLYNOMIALS.
!     On output bp contains the eigenvalues.
! CBP is the same as bp except type complex.
! bh  is used to temporarily store the roots of the B hat polynomial
!     which enters through bp.
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
!     Case of a real zero
!
170 sgn = 1.
   cbp(ig) = cmplx(bsrh(bh(ig),xm,iz,c,a,bh,psgf,sgn),0.)
   sgn = -1.
   cbp(ig+1) = cmplx(bsrh(xm,bh(ig+1),iz,c,a,bh,psgf,sgn),0.)
   go to 360
!
!     Case of a multiple zero
!
180 cbp(ig) = cmplx(xm,0.)
   cbp(ig+1) = cmplx(xm,0.)
   go to 360
!
!     Case of a complex zero
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
!               Uniform random selection of values from
!                       a finite set of integers
!
!                           ----------------
!
!     urget selects n values from the set of integers from ibeg to
!     iend WHERE ibeg .LT. iend. THE SELECTION IS PERFORMED SO THAT
!     any integer is equally likely to occur with proability 1/m
!     WHERE m = iend - ibeg + 1. AS n BECOMES LARGE THE MEAN AND
!     variance of the values will closely approximate the mean and
!     variance of the discrete uniform distribution where
!
!               mean = ibeg + (iend - ibeg)/2
!
!               variance = (m**2 - 1)/12 .
!
!     Input...
!
!       n     - NUMBER OF VARIATES TO BE GENERATED
!       ibeg  - lower limit of generation interval
!       iend  - upper limit of generation interval
!       ix    - INTEGER SEED USED TO INITIALIZE THE
!               sequence of variates generated
!
!     Output...
!
!       ix    - SEED FOR OBTAINING MORE VARIATES
!       l     - OUTPUT ARRAY OF DIMENSION n CONTAINING
!               the generated integers
!       ierr  - input error flag
!               ( 0 - no input errors
!                 1 - n .LE. 0
!                 2 - ibeg .GE. iend  OR  m .GE. p.
!                 3 - Seed out of range )
!
!-----------------------------------------------------------------------
integer, intent(inout) :: l(n)
integer :: a, b15, b16, fhi, p, xalo, xhi
double precision :: c, m, s, t
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     s = 1/(p-1)   (IT IS ASSUMED THAT THE ARITHMETIC BEING
!                    used is accurate to at least 14 digits.
!                    s has been set to a value slightly less
!                    than 1/(p-1) to ensure that rounding
!                    error does not produce variates that
!                    EXCEED iend.)
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
!        Use the linus schrage code to obtain the next seed ix.
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
!        Map ix to an integer in the closed interval (ibeg,iend).
!        THIS MAPPING IS 1-1 ONLY WHEN m = p - 1, IN WHICH CASE
!        ix is mapped to the value (ibeg - 1) + ix.
!
   t = ix
   k = c*t
   l(i) = ibeg + k
end do
return
!
!                         Error return
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
!         Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     IT IS ASSUMED THAT 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, xalo, xhi
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661e-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
do l = 1,n
!
!                 Get 15 high order bits of ix
!
   xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
   xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
   leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
   fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
   k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
   if (ix .lt. 0) ix = ix + p
!
!     Rescale ix, to interpret it as a value between 0 and 1.
!     The scale factor s is selected to be as near 1/p as is
!     APPROPRIATE IN ORDER THAT THE FLOATING VALUE FOR ix = 1,
!     namely s, be roughly the same distance from 0 as (p-1)*s
!     is from 1. The current value for s assures us that x(l)
!     is less than 1 for any floating point arithmetic of 6
!     or more digits.
!
   t = ix
   x(l) = s*t
end do
return
!
!                         Error return
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
!         Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     IT IS ASSUMED THAT 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, xalo, xhi
double precision :: s, t
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661d-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
do l = 1,n
!
!                 Get 15 high order bits of ix
!
   xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
   xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
   leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
   fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
   k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
   if (ix .lt. 0) ix = ix + p
!
!     Rescale ix, to interpret it as a value between 0 and 1.
!     The scale factor s is selected to be as near 1/p as is
!     APPROPRIATE IN ORDER THAT THE FLOATING VALUE FOR ix = 1,
!     namely s, be roughly the same distance from 0 as (p-1)*s
!     is from 1. The current value for s assures us that x(l)
!     is less than 1 for any double precision arithmetic.
!
   t = ix
   x(l) = s*t
end do
return
!
!                         Error return
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
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u IS THE UNIFORM VARIATE THAT IS GENERATED AND v = 1 - u.
!     u AND v ARE POSITIVE. IT IS ASSUMED THAT 1 .LE. ix .LT. p.
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix .lt. 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
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
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u IS THE UNIFORM VARIATE THAT IS GENERATED AND v = 1 - u.
!     u AND v ARE POSITIVE. IT IS ASSUMED THAT 1 .LE. ix .LT. p.
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
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix .lt. 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
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
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u IS THE UNIFORM VARIATE THAT IS GENERATED AND v = 1 - u.
!     u AND v ARE POSITIVE AND d = u - 0.5. IT IS ASSUMED THAT
!     1 .LE. ix .LT. p.
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix .lt. 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
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
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u IS THE UNIFORM VARIATE THAT IS GENERATED AND v = 1 - u.
!     u AND v ARE POSITIVE AND d = u - 0.5. IT IS ASSUMED THAT
!     1 .LE. ix .LT. p.
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
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data p0/1073741823/
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix .lt. 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
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
!         Generation of uniform random points (x(I),y(I))
!                     FOR I = 1,...,n WHERE
!
!                      0 .LT. x(I) .LT. 1
!                      0 .LT. y(I) .LT. 1
!
!     IT IS ASSUMED THAT 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     WRITTEN BY
!        LINUS SCHRAGE
!        UNIVERSITY OF CHICAGO
!     ADAPTED BY A.H. MORRIS (NSWC)
!-------------------
real, intent(inout) :: x(n), y(n)
integer :: a, b15, b16, fhi, p, xalo, xhi
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661e-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
!
!         See the comments in the subroutine urng for the
!                statements in the following loop
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
!                         Error return
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
!         Generation of uniform random points (x(I),y(I))
!                     FOR I = 1,...,n WHERE
!
!                      0 .LT. x(I) .LT. 1
!                      0 .LT. y(I) .LT. 1
!
!     IT IS ASSUMED THAT 0 .LT. ix .LT. p
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
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
data a/16807/, b15/32768/, b16/65536/, p/2147483647/
data s/.465661d-09/
!-------------------
if (n .le. 0) go to 100
if (ix .le. 0 .or. ix .ge. p) go to 110
ierr = 0
!
!         See the comments in the subroutine durng for the
!                 statements in the following loop
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
!                         Error return
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
!          Generation of n uniform random points (x(I),y(I))
!              in the unit circle centered at the origin
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
!      Generation of n uniform random points in the unit circle
!      centered at the origin. The abscissa and ordinate of the
!      i-TH point are stored in x(i1) and y(i2) where
!
!                      i1 = 1 + kx*(i - 1)
!                      i2 = 1 + ky*(i - 1) .
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(*), y(*)
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     p0 = 2**30 - 1
!     s  = 2/p
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
!        Use the linus schrage code to obtain new seeds ix.
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
!        Subtract the midpoint p0 and rescale so that the
!          uniform variates are in the interval (-1,1).
!
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!
!         Check if the point (u,v) is in the unit circle
!
   r = (u*u + v*v) - 1.0
   if (r .ge. 0.0) go to 10
!
!            Store the point when it is in the circle
!
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!
!                          Error return
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
!          Generation of n uniform random points (x(I),y(I))
!              in the unit circle centered at the origin
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
!      Generation of n uniform random points in the unit circle
!      centered at the origin. The abscissa and ordinate of the
!      i-TH point are stored in x(i1) and y(i2) where
!
!                      i1 = 1 + kx*(i - 1)
!                      i2 = 1 + ky*(i - 1) .
!
!-----------------------------------------------------------------------
double precision, intent(inout) :: x(*), y(*)
double precision :: r, s, u, v
integer :: a, b15, b16, fhi, p, p0, xalo, xhi
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     p0 = 2**30 - 1
!     s  = 2/p
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
!        Use the linus schrage code to obtain new seeds ix.
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
!        Subtract the midpoint p0 and rescale so that the
!          uniform variates are in the interval (-1,1).
!
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!
!         Check if the point (u,v) is in the unit circle
!
   r = (u*u + v*v) - 1.d0
   if (r .ge. 0.d0) go to 10
!
!            Store the point when it is in the circle
!
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!
!                          Error return
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
!                 Normal random number generator
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
!                  Obtain the first m variates
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
!            Obtain the last variate (when n is odd)
!
20 call rcir1 (1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = sqrt(-2.0*alog(r)/r)
a(n) = s*t(1)
return
!
!                         Error return
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
!                 Normal random number generator
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
!                  Obtain the first m variates
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
!            Obtain the last variate (when n is odd)
!
20 call drcir1 (1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = dsqrt(-2.d0*dlog(r)/r)
a(n) = s*t(1)
return
!
!                         Error return
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
!                 Gaussian random number generator
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
!                 Gaussian random number generator
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a.
!
!                          ---------------
!
!     Input...
!
!        mo      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. SET mo = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND mo .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates.
!
!        n       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        m       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT m .GE. 2. m SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - VARIANCE-COVARIANCE MATRIX OF ORDER m.
!                  A is a symmetric positive definite matrix
!                  stored in packed form. The array a must
!                  be of length (m*(m + 1))/2 or larger.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  LOWER TRIANGULAR MATRIX IN THE CHOLESKY
!                  DECOMPOSITION OF A REPLACES THE ORIGINAL
!                  DATA IN THE ARRAY a. a SHOULD NEVER BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - MEAN VECTOR OF DIMENSION m OF THE
!                  multivariate normal distribution
!
!        kx      - ROW DIMENSION OF THE MATRIX x (SEE THE
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        x       - OUTPUT ARRAY OF DIMENSION kx BY n CONTAINING
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a is not positive definite
!                   4 - SEED OUT OF RANGE         )
!
!-----------------------------------------------------------------------
!
!        ***REFERENCES***
!
!     Fishman, george S., Concepts and methods in discrete event
!     digital simulation, john wiley and sons, new york, 1973,
!     PP. 215 - 217.
!
!     Morrison, donald F., Multivariate statistical methods,
!     mcgraw-hill, new york, 1967, PP. 80 - 81.
!
!     Scheuer, E. And Stoller, D. S., On the generation of
!     normal random vectors, Technometrics, volume 4, may, 1962,
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
!           Compute the lower triangular matrix
!           l having positive diagonal elements
!           AND SATISFYING a = l*TRANSPOSE(l).
!
if (mo .ne. 0) go to 10
call sppfa (a, m, ierr)
if (ierr .ne. 0) go to 120
!
!           Generate the n random normal vectors
!
10 ldim = (m*(m + 1))/2
do j = 1,n
   call rnor (ix, x(1,j), m, ierr)
!
!         Obtain the components of the j-TH vector
!                    in reverse order
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
!                      Error return
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a. It is
!           assumed that A is a diagonal matrix.
!
!                          ---------------
!
!     Input...
!
!        mo      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. SET mo = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND mo .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates.
!
!        n       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        m       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT m .GE. 2. m SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - VARIANCE-COVARIANCE MATRIX OF ORDER m.
!                  A is a diagonal matrix with positive
!                  diagonal elements. The diagonal elements
!                  are stored in the array a. a is an array
!                  of length m or larger.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  SQUARE ROOTS OF THE ELEMENTS OF A REPLACE
!                  THE ORIGINAL DATA IN A. A SHOULD NOT BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - MEAN VECTOR OF DIMENSION m OF THE
!                  multivariate normal distribution
!
!        kx      - ROW DIMENSION OF THE MATRIX x (SEE THE
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        x       - OUTPUT ARRAY OF DIMENSION kx BY n CONTAINING
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a(i) .LE. 0 FOR SOME i
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
!        Compute the roots of the diagonal elements
!
if (mo .ne. 0) go to 20
do i = 1,m
   if (a(i) .le. 0.0) go to 120
   a(i) = sqrt(a(i))
end do
!
!           Generate the n random normal vectors
!
20 do j = 1,n
   call rnor (ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!
!                       Error return
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a.
!
!                          ---------------
!
!     Input...
!
!        mo      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. SET mo = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND mo .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates.
!
!        n       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        m       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT m .GE. 2. m SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - VARIANCE-COVARIANCE MATRIX OF ORDER m.
!                  A is a symmetric positive definite matrix
!                  stored in packed form. The array a must
!                  be of length (m*(m + 1))/2 or larger.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  LOWER TRIANGULAR MATRIX IN THE CHOLESKY
!                  DECOMPOSITION OF A REPLACES THE ORIGINAL
!                  DATA IN THE ARRAY a. a SHOULD NEVER BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - MEAN VECTOR OF DIMENSION m OF THE
!                  multivariate normal distribution
!
!        kx      - ROW DIMENSION OF THE MATRIX x (SEE THE
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        x       - OUTPUT ARRAY OF DIMENSION kx BY n CONTAINING
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a is not positive definite
!                   4 - SEED OUT OF RANGE         )
!
!-----------------------------------------------------------------------
!
!        ***REFERENCES***
!
!     Fishman, george S., Concepts and methods in discrete event
!     digital simulation, john wiley and sons, new york, 1973,
!     PP. 215 - 217.
!
!     Morrison, donald F., Multivariate statistical methods,
!     mcgraw-hill, new york, 1967, PP. 80 - 81.
!
!     Scheuer, E. And Stoller, D. S., On the generation of
!     normal random vectors, Technometrics, volume 4, may, 1962,
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
!           Compute the lower triangular matrix
!           l having positive diagonal elements
!           AND SATISFYING a = l*TRANSPOSE(l).
!
if (mo .ne. 0) go to 10
call dppfa (a, m, ierr)
if (ierr .ne. 0) go to 120
!
!           Generate the n random normal vectors
!
10 ldim = (m*(m + 1))/2
do j = 1,n
   call drnor (ix, x(1,j), m, ierr)
!
!         Obtain the components of the j-TH vector
!                    in reverse order
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
!                      Error return
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a. It is
!           assumed that A is a diagonal matrix.
!
!                          ---------------
!
!     Input...
!
!        mo      - INTEGER SPECIFYING IF THE ROUTINE IS
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. SET mo = 0 ON AN INITIAL CALL TO
!                  THE ROUTINE, AND mo .NE. 0 ON A LATER
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates.
!
!        n       - NUMBER OF RANDOM VECTORS TO BE GENERATED.
!
!        m       - LENGTH OF THE DESIRED RANDOM VECTORS.
!                  IT IS ASSUMED THAT m .GE. 2. m SHOULD
!                  NOT BE MODIFIED BY THE USER ON A LATER
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - VARIANCE-COVARIANCE MATRIX OF ORDER m.
!                  A is a diagonal matrix with positive
!                  diagonal elements. The diagonal elements
!                  are stored in the array a. a is an array
!                  of length m or larger.
!
!                  ON AN INITIAL CALL TO THE ROUTINE, THE
!                  SQUARE ROOTS OF THE ELEMENTS OF A REPLACE
!                  THE ORIGINAL DATA IN A. A SHOULD NOT BE
!                  MODIFIED BY THE USER ON A LATER CALL TO
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - MEAN VECTOR OF DIMENSION m OF THE
!                  multivariate normal distribution
!
!        kx      - ROW DIMENSION OF THE MATRIX x (SEE THE
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE VARIATES.
!
!        x       - OUTPUT ARRAY OF DIMENSION kx BY n CONTAINING
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a(i) .LE. 0 FOR SOME i
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
!        Compute the roots of the diagonal elements
!
if (mo .ne. 0) go to 20
do i = 1,m
   if (a(i) .le. 0.d0) go to 120
   a(i) = dsqrt(a(i))
end do
!
!           Generate the n random normal vectors
!
20 do j = 1,n
   call drnor (ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!
!                       Error return
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
!           ranexp generates n exponential random variates from an
!           EXPONENTIAL DISTRIBUTION WITH PARAMETER a (a .GT. 0).
!           A is the mean of the distribution.  Hence, A is interpreted
!           as the average rate per unit of time or the average time
!           to failure (average lifetime).
!
!           Form of the exponential probability density function...
!
!                   f(x) = (1/a) * exp(-x/a)      , x .ge. 0
!                                                   a .GT. 0
!
!           Mean and variance of the exponential distribution...
!
!                    mean = a
!
!                    variance = a**2
!
!           ***PARAMETER LIST***
!
!           Input...
!
!           n       - NUMBER OF VARIATES TO BE GENERATED
!           a       - MEAN OF THE EXPONENTIAL DISTRIBUTION
!           iseed   - INTEGER SEED USED TO INITIALIZE THE
!                     sequence of variates generated
!
!           Output...
!
!           iseed   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     routine
!           x       - OUTPUT ARRAY OF DIMENSION n CONTAINING
!                     the generated real variates
!           ierror  - input error flag
!                     ( 0 - no input errors
!                       1 - n .LE. 0
!                       2 - a .LE. 0.0
!                       3 - seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           P. 203.
!
real, intent(inout) :: x(n)
!
!        Check to ensure that the desired number of variates is within
!        acceptable range
!
if (n .le. 0) go to 100
!
!        Check to ensure that the exponential parameter HAS been
!        properly specified
!
if (a .le. 0.0) go to 110
!
!        Generation of uniform random variates
!
call urng (iseed, x, n, ierror)
if (ierror .ne. 0) go to 120
!
!        Loop which generates the n desired variates
!
do i=1,n
   x(i) = - a*alog(x(i))
end do
return
!
!              Error return
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
!           drnexp generates n exponential random variates from an
!           EXPONENTIAL DISTRIBUTION WITH PARAMETER a (a .GT. 0).
!           A is the mean of the distribution.  Hence, A is interpreted
!           as the average rate per unit of time or the average time
!           to failure (average lifetime).
!
!           Form of the exponential probability density function...
!
!                   f(x) = (1/a) * exp(-x/a)      , x .ge. 0
!                                                   a .GT. 0
!
!           Mean and variance of the exponential distribution...
!
!                    mean = a
!
!                    variance = a**2
!
!           ***PARAMETER LIST***
!
!           Input...
!
!           n       - NUMBER OF VARIATES TO BE GENERATED
!           a       - MEAN OF THE EXPONENTIAL DISTRIBUTION
!           iseed   - INTEGER SEED USED TO INITIALIZE THE
!                     sequence of variates generated
!
!           Output...
!
!           iseed   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     routine
!           x       - OUTPUT ARRAY OF DIMENSION n CONTAINING
!                     the generated real variates
!           ierror  - input error flag
!                     ( 0 - no input errors
!                       1 - n .LE. 0
!                       2 - a .LE. 0.0
!                       3 - seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           P. 203.
!
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
!
!        Check to ensure that the desired number of variates is within
!        acceptable range
!
if (n .le. 0) go to 100
!
!        Check to ensure that the exponential parameter HAS been
!        properly specified
!
if (a .le. 0.d0) go to 110
!
!        Generation of uniform random variates
!
call durng (iseed, x, n, ierror)
if (ierror .ne. 0) go to 120
!
!        Loop which generates the n desired variates
!
do i=1,n
   x(i) = - a*dlog(x(i))
end do
return
!
!              Error return
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
!               Computation of n variates x(1),...,x(n)
!               from the gamma distribution having the
!                    probability density function
!
!                 f(t) = exp(-t)*t**(a-1)/gamma(a)
!
!                        ------------------
!
!     ix is a variable. On input ix is a seed for initializing the
!     sequence of variates. On output ix is a new seed for obtaining
!     MORE VARIATES. IT IS ASSUMED THAT 1 .LE. ix .LT. 2**31 - 1.
!
!     ierr is a variable which reports the status of the results.
!     When the subroutine terminates ierr has one of the following
!     values ...
!
!          ierr = 0   THE GAMMA VARIATES WERE OBTAINED.
!          ierr = 1   (INPUT ERROR) n .LE. 0
!          ierr = 2   (INPUT ERROR) a .LT. 0.1
!          ierr = 3   (INPUT ERROR) ix IS NOT A PROPER
!                      seed.
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
!             The following code assumes that the uniform
!             variates are far enough from 0 and 1 so that
!                   THE SETTING ind = -8 IS AVOIDED
!
do i = 1,n
   call urng0 (ix, u, v)
   call gaminv (a, w, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) w = 0.0
   x(i) = w
end do
return
!
!                            Error return
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
!             Computation of n double precision variates
!             x(1),...,x(n)  from the gamma distribution
!              having the probability density function
!
!                 f(t) = exp(-t)*t**(a-1)/gamma(a)
!
!                        ------------------
!
!     ix is a variable. On input ix is a seed for initializing the
!     sequence of variates. On output ix is a new seed for obtaining
!     MORE VARIATES. IT IS ASSUMED THAT 1 .LE. ix .LT. 2**31 - 1.
!
!     ierr is a variable which reports the status of the results.
!     When the subroutine terminates ierr has one of the following
!     values ...
!
!          ierr = 0   THE GAMMA VARIATES WERE OBTAINED.
!          ierr = 1   (INPUT ERROR) n .LE. 0
!          ierr = 2   (INPUT ERROR) a .LT. 0.1
!          ierr = 3   (INPUT ERROR) ix IS NOT A PROPER
!                      seed.
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
!             The following code assumes that the uniform
!             variates are far enough from 0 and 1 so that
!                   THE SETTING ind = -8 IS AVOIDED
!
do i = 1,n
   call durng0 (ix, u, v)
   call dginv (a, w, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) w = 0.d0
   x(i) = w
end do
return
!
!                            Error return
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
!                Generation of beta random variates
!
!                           ------------
!
!     rbeta generates n variates from the beta distribution with
!     PARAMETERS A AND b WHERE a .GE. 0.25 AND b .GE. 0.25. THE
!     generation scheme is based on the fact that x1 / (x1 + x2)
!     is a variate from the beta distribution when x1 and x2 are
!     independent variates from the standard gamma distributions
!     with parameters A and b respectively.
!
!     Form of the beta probability density function used...
!
!       f(x) = x**(a - 1) * (1 - x)**(b - 1) / beta(a,b)
!
!              WHERE  0 .LE. x .LE. 1  AND
!              BETA(a,b) is the beta function.
!
!     Mean and variance of the beta distribution...
!
!              mean = a / (a + b)
!
!              variance = (a * b) / ((a + b)**2 * (a + b + 1))
!
!     Input...
!
!        n       - NUMBER OF VARIATES TO BE GENERATED
!        a       - PARAMETER OF THE BETA DISTRIBUTION
!        b       - PARAMETER OF THE BETA DISTRIBUTION
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE
!                  variates
!        x       - ARRAY OF DIMENSION n CONTAINING THE
!                  beta variates
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.25
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
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        THE SETTING ind = -8 IN gaminv IS AVOIDED.
!
   call urng0 (ix, u, v)
   call gaminv (a, x1, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.0
!
   call urng0 (ix, u, v)
   call gaminv (b, x2, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x2 = 0.0
!
!        It is required that A and b not be less
!        than 0.25 so that x1 + x2 is nonzero.
!
   x(i) = x1/(x1 + x2)
!
end do
return
!
!                      Error return
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
!                         Double precision
!                generation of beta random variates
!
!                           ------------
!
!     drbeta generates n double precision variates from the beta
!     DISTRIBUTION WITH PARAMETERS A AND b WHERE a .GE. 0.25 AND
!     b .GE. 0.25. THE GENERATION SCHEME IS BASED ON THE FACT
!     that x1 / (x1 + x2) is a variate from the beta distribution
!     when x1 and x2 are independent variates from the standard
!     gamma distributions with parameters A and b respectively.
!
!     Form of the beta probability density function used...
!
!       f(x) = x**(a - 1) * (1 - x)**(b - 1) / beta(a,b)
!
!              WHERE  0 .LE. x .LE. 1  AND
!              BETA(a,b) is the beta function.
!
!     Mean and variance of the beta distribution...
!
!              mean = a / (a + b)
!
!              variance = (a * b) / ((a + b)**2 * (a + b + 1))
!
!     Input...
!
!        n       - NUMBER OF VARIATES TO BE GENERATED
!        a       - PARAMETER OF THE BETA DISTRIBUTION
!        b       - PARAMETER OF THE BETA DISTRIBUTION
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE
!                  variates
!        x       - ARRAY OF DIMENSION n CONTAINING THE
!                  beta variates
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.25
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
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        THE SETTING ind = -8 IN gaminv IS AVOIDED.
!
   call durng0 (ix, u, v)
   call dginv (a, x1, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.d0
!
   call durng0 (ix, u, v)
   call dginv (b, x2, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x2 = 0.d0
!
!        It is required that A and b not be less
!        than 0.25 so that x1 + x2 is nonzero.
!
   x(i) = x1/(x1 + x2)
!
end do
return
!
!                      Error return
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
!          Generation of variates from the F-distribution
!
!                          --------------
!
!     Fran generates n variates from the F-distribution with
!     parameters A and b (called the numerator and denominator
!     DEGREES OF FREEDOM) WHERE a .GE. 0.5 AND b .GE. 0.5. THE
!     generation scheme is based on the fact that (b/a)*(x1/x2)
!     is a variate from the F-distribution when x1 and x2 are
!     independent variates from the standard gamma distributions
!     with parameters a/2 and b/2 respectively.
!
!
!     Input...
!
!        n       - NUMBER OF VARIATES TO BE GENERATED
!        a       - NUMERATOR DEGREES OF FREEDOM PARAMETER
!        b       - DENOMINATOR DEGREES OF FREEDOM PARAMETER
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE
!                  variates
!        x       - ARRAY OF DIMENSION n CONTAINING THE
!                  F distribution variates
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.5
!                   3 - b is too small for the
!                       floating arithmetic used
!                   4 - SEED OUT OF RANGE       )
!
!-----------------------------------------------------------------------
real, intent(inout) :: x(n)
!--------------------
data max /2147483647/
!--------------------
!
!     ****** xmax IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
!            largest number in the floating arithmetic used.
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
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        THE SETTING ind = -8 IN gaminv IS AVOIDED.
!
   call urng0 (ix, u, v)
   call gaminv (ahalf, x1, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.0
!
   call urng0 (ix, u, v)
   call gaminv (bhalf, x2, 0.0, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) go to 120
!
!        Protect against overflow in computing the
!        VARIATE c*(x1/x2).
!
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big .le. bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!
!                      Error return
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
!                  Double precision generation of
!                 variates from the F-distribution
!
!                          --------------
!
!     dfran generates n variates from the F-distribution with
!     parameters A and b (called the numerator and denominator
!     DEGREES OF FREEDOM) WHERE a .GE. 0.5 AND b .GE. 0.5. THE
!     generation scheme is based on the fact that (b/a)*(X1/X2)
!     is a variate from the F-distribution when X1 and X2 are
!     independent variates from the standard gamma distributions
!     with parameters a/2 and b/2 respectively.
!
!
!     Input...
!
!        n       - NUMBER OF VARIATES TO BE GENERATED
!        a       - NUMERATOR DEGREES OF FREEDOM PARAMETER
!        b       - DENOMINATOR DEGREES OF FREEDOM PARAMETER
!        ix      - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates
!
!     Output...
!
!        ix      - SEED TO BE USED FOR OBTAINING MORE
!                  variates
!        x       - ARRAY OF DIMENSION n CONTAINING THE
!                  F distribution variates
!        ierr    - INPUT ERROR FLAG
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.5
!                   3 - b is too small for the
!                       floating arithmetic used
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
!     ****** xmax IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
!            largest number in the floating arithmetic used.
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
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        THE SETTING ind = -8 IN gaminv IS AVOIDED.
!
   call durng0 (ix, u, v)
   call dginv (ahalf, x1, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) x1 = 0.d0
!
   call durng0 (ix, u, v)
   call dginv (bhalf, x2, u, v, ind)
   if (ind .eq. -3 .or. ind .eq. -7) go to 120
!
!        Protect against overflow in computing the
!        VARIATE c*(X1/X2).
!
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big .le. bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!
!                      Error return
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
!          Generation of variates from the T-distribution
!
!                          --------------
!
!        Tran generates n random variates from A T-distribution
!        with parameter a (called the degrees of freedom) where
!        a .GE. 0.5. THE GENERATION SCHEME IS BASED ON THE FACT
!        that x/sqrt(Y/a) is a variate from the T-distribution
!        when x is a standard normal variate and Y a chi-square
!        variate with a degrees of freedom.
!
!
!        Input...
!
!           n    - NUMBER OF VARIATES TO BE GENERATED
!           a    - DEGREES OF FREEDOM PARAMETER
!           ix   - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates
!
!        Output...
!
!           ix   - SEED TO BE USED FOR OBTAINING MORE
!                  variates
!           x    - ARRAY OF DIMENSION n CONTAINING THE
!                  T-distribution variates
!           ierr - input error flag
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - a .LT. 0.5
!                   3 - a is too small for the
!                       floating arithmetic used
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
!                    Get a normal variate
!
   call urng1 (ix, u, v, d)
   call pni (u, v, d, z, ind)
!
!                    Get a gamma variate
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        THE SETTING ind = -8 IN gaminv IS AVOIDED.
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
!              Error return
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
!                  Double precision generation of
!                 variates from the T-distribution
!
!                          --------------
!
!        dtran generates n random variates from A T-distribution
!        with parameter a (called the degrees of freedom) where
!        a .GE. 0.5. THE GENERATION SCHEME IS BASED ON THE FACT
!        that x/sqrt(Y/a) is a variate from the T-distribution
!        when x is a standard normal variate and Y a chi-square
!        variate with a degrees of freedom.
!
!
!        Input...
!
!           n    - NUMBER OF VARIATES TO BE GENERATED
!           a    - DEGREES OF FREEDOM PARAMETER
!           ix   - INTEGER SEED USED TO INITIALIZE THE
!                  sequence of variates
!
!        Output...
!
!           ix   - SEED TO BE USED FOR OBTAINING MORE
!                  variates
!           x    - ARRAY OF DIMENSION n CONTAINING THE
!                  T-distribution variates
!           ierr - input error flag
!                  (0 - no input errors
!                   1 - n .LE. 0
!                   2 - a .LT. 0.5
!                   3 - a is too small for the
!                       floating arithmetic used
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
!                    Get a normal variate
!
   call durng1 (ix, u, v, d)
   call dpni (u, v, d, z, ind)
!
!                    Get a gamma variate
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        THE SETTING ind = -8 IN gaminv IS AVOIDED.
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
!              Error return
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
!           rmk1 generates an autocorrelated sequence x of
!           length n where x is a first-order markov process
!           WITH PARAMETER alpha (abs(alpha) .LT. 1). THE SEQUENCE
!           x(J) (J = 2,...,n) IS GENERATED BY
!
!                  x(J) - fmu = alpha*(x(J-1) - fmu) + Z(J).
!
!           Z(J) is the random error term, assumed to be normally
!           distributed with mean 0 and standard deviation sig
!           (sig .GE. 0). THE GENERATION SCHEME ASSUMES THAT x IS
!           a normal process with mean fmu and variance
!
!                      sig*sig / (1 - alpha*alpha) .
!
!           x IS A STATIONARY PROCESS PROVIDED THAT abs(alpha) .LT.
!           1. The autocorrelation structure of the sequence is
!           characterized by the fact that the correlation between
!           terms becomes progressively weaker with increasing lag.
!           We note that a first-order markov process is synonomous
!           with a first-order autoregressive (AR) process.
!
!           ***PARAMETER LIST***
!
!           Input...
!
!           n       - LENGTH OF THE SEQUENCE TO BE GENERATED.
!                     IT IS ASSUMED THAT n .GE. 2.
!           fmu     - MEAN OF THE NORMAL PROCESS
!           sig     - STANDARD DEVIATION OF THE NORMALLY
!                     distributed error term
!           alpha   - VALUE OF THE MARKOV MODEL PARAMETER
!           iseed   - INTEGER SEED USED TO INITIALIZE THE
!                     sequence of normal variates generated
!                     by subroutine rnor
!
!           Output...
!
!           iseed   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     routine
!           x       - OUTPUT ARRAY OF DIMENSION n CONTAINING
!                     the generated first-order markov sequence
!           ierror  - input error flag
!                     ( 0 - no input errors
!                       1 - n .LE. 1
!                       2 - sig .LT. 0
!                       3 - abs(alpha) .GE. 1
!                       4 - seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           PP. 236 - 237.
!
real, intent(inout) :: x(n)
!
!        Check to ensure that the desired sequence length is within
!        acceptable range
!
if (n .le. 1) go to 100
!
!        Check to ensure that the standard deviation of the error term
!        is within acceptable range
!
if (sig .le. 0.0) go to 110
!
!        Check to ensure that the first-order markov model
!        parameter is within the range required to guarantee
!        PROCESS STATIONARITY
!
if (abs(alpha) .ge. 1.0) go to 120
!
!        Generation of standard normal random variates
!
call rnor (iseed,x,n,ierror)
if (ierror .ne. 0) go to 130
!
!        Computes the standard deviation of the initial term of the
!        autocorrelated sequence
!
c = 0.5 + (0.5 - alpha)
t = 0.5 + (0.5 + alpha)
sigi = sig/sqrt(c*t)
!
!        Computes the initial term of the required autocorrelated
!        sequence
!
x(1) = fmu + sigi*x(1)
!
!        Generates the last n - 1 terms of the required autocorrelated
!        sequence
!
c = fmu*c
do i=2,n
   x(i) = alpha*x(i-1) + c + sig*x(i)
end do
return
!
!        Error return
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
!           drmk1 generates an autocorrelated sequence x of
!           length n where x is a first-order markov process
!           WITH PARAMETER alpha (abs(alpha) .LT. 1). THE SEQUENCE
!           x(J) (J = 2,...,n) IS GENERATED BY
!
!                  x(J) - fmu = alpha*(x(J-1) - fmu) + Z(J).
!
!           Z(J) is the random error term, assumed to be normally
!           distributed with mean 0 and standard deviation sig
!           (sig .GE. 0). THE GENERATION SCHEME ASSUMES THAT x IS
!           a normal process with mean fmu and variance
!
!                      sig*sig / (1 - alpha*alpha) .
!
!           x IS A STATIONARY PROCESS PROVIDED THAT abs(alpha) .LT.
!           1. The autocorrelation structure of the sequence is
!           characterized by the fact that the correlation between
!           terms becomes progressively weaker with increasing lag.
!           We note that a first-order markov process is synonomous
!           with a first-order autoregressive (AR) process.
!
!           ***PARAMETER LIST***
!
!           Input...
!
!           n       - LENGTH OF THE SEQUENCE TO BE GENERATED.
!                     IT IS ASSUMED THAT n .GE. 2.
!           fmu     - MEAN OF THE NORMAL PROCESS
!           sig     - STANDARD DEVIATION OF THE NORMALLY
!                     distributed error term
!           alpha   - VALUE OF THE MARKOV MODEL PARAMETER
!           iseed   - INTEGER SEED USED TO INITIALIZE THE
!                     sequence of normal variates generated
!                     by subroutine drnor
!
!           Output...
!
!           iseed   - SEED TO BE USED ON THE NEXT CALL TO THE
!                     routine
!           x       - OUTPUT ARRAY OF DIMENSION n CONTAINING
!                     the generated first-order markov sequence
!           ierror  - input error flag
!                     ( 0 - no input errors
!                       1 - n .LE. 1
!                       2 - sig .LT. 0
!                       3 - abs(alpha) .GE. 1
!                       4 - seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           PP. 236 - 237.
!
double precision, intent(in) :: fmu, sig, alpha
double precision, intent(inout) :: x(n)
double precision :: c, sigi, t
!
!        Check to ensure that the desired sequence length is within
!        acceptable range
!
if (n .le. 1) go to 100
!
!        Check to ensure that the standard deviation of the error term
!        is within acceptable range
!
if (sig .le. 0.d0) go to 110
!
!        Check to ensure that the first-order markov model
!        parameter is within the range required to guarantee
!        PROCESS STATIONARITY
!
if (dabs(alpha) .ge. 1.d0) go to 120
!
!        Generation of standard normal random variates
!
call drnor (iseed,x,n,ierror)
if (ierror .ne. 0) go to 130
!
!        Computes the standard deviation of the initial term of the
!        autocorrelated sequence
!
c = 0.5d0 + (0.5d0 - alpha)
t = 0.5d0 + (0.5d0 + alpha)
sigi = sig/dsqrt(c*t)
!
!        Computes the initial term of the required autocorrelated
!        sequence
!
x(1) = fmu + sigi*x(1)
!
!        Generates the last n - 1 terms of the required autocorrelated
!        sequence
!
c = fmu*c
do i=2,n
   x(i) = alpha*x(i-1) + c + sig*x(i)
end do
return
!
!        Error return
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
