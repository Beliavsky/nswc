subroutine cspp (t, a, ka, m, n, z, kz, dz, kdz)
implicit none
integer, intent(in) :: ka, kdz, kz, m, n
integer :: i, il, ilj, ilkj, j, jj, jp1, k, kmj, l, left, mp1, mu
real :: del, diff, r, s, term, x
!-----------------------------------------------------------------------
!
!            Computation of N cubic splines and their first
!            derivatives at the knots T(4),...,T(M+1). The
!            cubic splines are represented in B-spline form.
!
!                          ---------------
!
!     Input ...
!
!       T     KNOT SEQUENCE OF LENGTH M+4.
!       A     M X N MATRIX. EACH COLUMN OF A IS A SEQUENCE
!             of M B-spline coefficients for a cubic spline.
!       KA    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             PROGRAM FOR A. IT IS ASSUMED THAT KA .GE. M.
!       M     DIMENSION OF THE B-SPLINE SPACE.
!       N     NUMBER OF CUBIC SPLINES CONSIDERED.
!       KZ    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             PROGRAM FOR Z. IT IS ASSUMED THAT KZ .GE. N.
!       KDZ   THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             PROGRAM FOR DZ. IT IS ASSUMED THAT KZ .GE. N.
!
!     Output ...
!
!       Z     N X (M-2) MATRIX WHERE Z(J,I) = VALUE OF J-TH CUBIC
!             SPLINE AT THE POINT T(I+3) FOR I = 1,...,M-2.
!
!       DZ    N X (M-2) MATRIX WHERE DZ(J,I) = FIRST DERIVATIVE OF
!             the J-TH cubic spline evaluated at the point T(I+3).
!
!-----------------------------------------------------------------------
real, intent(in) :: t(*), a(ka,n)
real, intent(inout) :: z(kz,*), dz(kdz,*)
real :: c(4), wk(4,5)
!
k = 4
mp1 = m + 1
do mu = 1,n
!
!        Obtaing the values for the mu-TH cubic spline
!
   l = 0
   do left = k,m
      l = l + 1
!
!           Compute the coefficients for the L-TH
!           polynomial forming the cubic spline. The
!           coefficients are stored in C. This code
!           is from the subroutine BSPP.
!
      do j = 1,k
         jj = left - k + j
         wk(j,1) = a(jj,mu)
      end do
!
      do j = 1,3
         jp1 = j + 1
         kmj = k - j
         do i = 1,kmj
            il = i + left
            ilkj = il - kmj
            diff = t(il) - t(ilkj)
            wk(i,jp1) = (wk(i+1,j) - wk(i,j))/diff
         end do
      end do
!
      wk(1,5) = 1.0
      x = t(left)
      c(4) = wk(1,4)
      r = 1.0
      do j = 1,3
         jp1 = j + 1
         s = 0.0
         do i = 1,j
            il = i + left
            ilj = il - j
            term = wk(i,5)/(t(il) - t(ilj))
            wk(i,5) = s + (t(il) - x)*term
            s = (x - t(ilj))*term
         end do
         wk(jp1,5) = s
!
         s = 0.0
         kmj = k - j
         do i = 1,jp1
            s = s + wk(i,kmj)*wk(i,5)
         end do
         r = (r*float(kmj))/float(j)
         c(kmj) = r*s
      end do
!
!           Store the value of the spline and its
!           first derivative at the knot T(LEFT)
!
      z(mu,l) = c(1)
      dz(mu,l) = c(2)
   end do
!
!        Compute the spline and its first derivative
!                    at the knot T(M+1)
!
   l = l + 1
   del = t(mp1) - t(m)
   z(mu,l) = ((c(4)*del + c(3))*del + c(2))*del + c(1)
   dz(mu,l) = (3.0*c(4)*del + 2.0*c(3))*del + c(2)
end do
return
end subroutine cspp

subroutine csurf (ider, jder, x, mx, y, my, z, kz, s, m, t, n, &
&f, kf, f1, kf1, f2, kf2, f12, kf12)
implicit none
integer, intent(in) :: ider, jder, kf, kf1, kf12, kf2, kz, m, mx, &
&my, n
integer :: i, iold, ip1, j, jold, jp1, k, l, mm1, nm1
real :: a, b, b1, b2, b3, bx, c, c1, c2, c3, cx, d, dfi, dfip1, &
&ds, dt, dx, dy, fi, fip1, xx, yy
integer :: intrvl
!-----------------------------------------------------------------------
!
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!
!-----------------------------------------------------------------------
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), f1(kf1,n), f2(kf2,n), &
&f12(kf12,n)
!
if (ider .gt. 3 .or. jder .gt. 3) go to 400
mm1 = m - 1
nm1 = n - 1
!
iold = 0
jold = 0
do l = 1,my
   yy = y(l)
   if (yy .lt. t(2)) go to 10
   if (yy .ge. t(nm1)) go to 20
   if (l .eq. 1) go to 30
   if (yy - y(l-1)) 30,50,40
!
10 j = 1
   go to 50
20 j = nm1
   go to 50
30 j = intrvl (yy, t, n)
   go to 50
!
!        Linear forward search
!
40 if (yy .lt. t(j + 1)) go to 50
   j = j + 1
   go to 40
!
50 jp1 = j + 1
   dt = t(jp1) - t(j)
!
   do 350 k = 1,mx
      xx = x(k)
      if (xx .lt. s(2)) go to 100
      if (xx .ge. s(mm1)) go to 110
      if (k .eq. 1) go to 120
      if (xx - x(k-1)) 120,130,140
!
100 i = 1
      if (i .eq. iold .and. j .eq. jold) go to 210
      go to 200
110 i = mm1
      if (i .eq. iold .and. j .eq. jold) go to 210
      go to 200
120 i = intrvl (xx, s, m)
      if (i .eq. iold .and. j .eq. jold) go to 210
      go to 200
130 z(k,l) = z(k-1,l)
      go to 350
!
!           Linear forward search
!
140 if (xx .lt. s(i + 1)) go to 210
150 i = i + 1
         if (xx .ge. s(i + 1)) go to 150
!
!           Computation of the JDER-TH derivative of
!           F(S(I),Y), D1F(S(I),Y), F(S(I+1),Y), AND
!           D1F(S(I+1),Y) at the point YY.
!
200 iold = i
         ip1 = i + 1
         ds = s(ip1) - s(i)
!
         d = (f(i,jp1) - f(i,j))/dt
         a = f2(i,j) + f2(i,jp1)
         b = (-a - f2(i,j) + 3.0*d)/dt
         c = (a - d - d)/(dt*dt)
!
         d = (f(ip1,jp1) - f(ip1,j))/dt
         a = f2(ip1,j) + f2(ip1,jp1)
         b1 = (-a - f2(ip1,j) + 3.0*d)/dt
         c1 = (a - d - d)/(dt*dt)
!
         d = (f1(i,jp1) - f1(i,j))/dt
         a = f12(i,j) + f12(i,jp1)
         b2 = (-a - f12(i,j) + 3.0*d)/dt
         c2 = (a - d - d)/(dt*dt)
!
         d = (f1(ip1,jp1) - f1(ip1,j))/dt
         a = f12(ip1,j) + f12(ip1,jp1)
         b3 = (-a - f12(ip1,j) + 3.0*d)/dt
         c3 = (a - d - d)/(dt*dt)
!
210 dy = yy - t(j)
      if (jder .eq. 0) go to 220
      if (jder - 2) 230,240,250
!
220 fi = ((c*dy + b)*dy + f2(i,j))*dy + f(i,j)
      fip1 = ((c1*dy + b1)*dy + f2(ip1,j))*dy + f(ip1,j)
      dfi = ((c2*dy + b2)*dy + f12(i,j))*dy + f1(i,j)
      dfip1 = ((c3*dy + b3)*dy + f12(ip1,j))*dy + f1(ip1,j)
      go to 300
!
230 fi = (3.0*c*dy + 2.0*b)*dy + f2(i,j)
      fip1 = (3.0*c1*dy + 2.0*b1)*dy + f2(ip1,j)
      dfi = (3.0*c2*dy + 2.0*b2)*dy + f12(i,j)
      dfip1 = (3.0*c3*dy + 2.0*b3)*dy + f12(ip1,j)
      go to 300
!
240 fi = 6.0*c*dy + 2.0*b
      fip1 = 6.0*c1*dy + 2.0*b1
      dfi = 6.0*c2*dy + 2.0*b2
      dfip1 = 6.0*c3*dy + 2.0*b3
      go to 300
!
250 fi = 6.0*c
      fip1 = 6.0*c1
      dfi = 6.0*c2
      dfip1 = 6.0*c3
!
!           Computation of the IDER-TH derivative
!           at the point XX.
!
300 d = (fip1 - fi)/ds
      a = dfi + dfip1
      bx = (-a - dfi + 3.0*d)/ds
      cx = (a - d - d)/(ds*ds)
!
      dx = xx - s(i)
      if (ider .eq. 0) go to 310
      if (ider - 2) 320,330,340
!
310 z(k,l) = ((cx*dx + bx)*dx + dfi)*dx + fi
      go to 350
320 z(k,l) = (3.0*cx*dx + 2.0*bx)*dx + dfi
      go to 350
330 z(k,l) = 6.0*cx*dx + 2.0*bx
      go to 350
340 z(k,l) = 6.0*cx
!
350 continue
   jold = j
end do
return
!
!     Case when the results are zero.
!
400 do l = 1,my
   do k = 1,mx
      z(k,l) = 0.0
   end do
end do
return
end subroutine csurf

subroutine csurf1 (ider, jder, x, mx, y, my, z, kz, s, m, t, n, f)
implicit none
integer, intent(in) :: ider, jder, kz, m, mx, my, n
!-----------------------------------------------------------------------
!
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!
!-----------------------------------------------------------------------
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(m,n,4)
!
call csurf (ider, jder, x, mx, y, my, z, kz, s, m, t, n, f, m, &
&f(1,1,3), m, f(1,1,2), m, f(1,1,4), m)
return
end subroutine csurf1

subroutine csrf (ider, jder, x, mx, y, my, z, kz, s, m, t, n, &
&f, kf, f1, kf1, f2, kf2, f12, kf12)
implicit none
integer, intent(in) :: ider, jder, kf, kf1, kf12, kf2, kz, m, mx, &
&my, n
integer :: i, iold, ip1, j, jold, jp1, k, l, mm1, nm1
real :: a, a1, a2, a3, ax, c, c1, c2, c3, cx, d, dfi, dfip1, ds, &
&dt, dx, dy, fi, fip1, xx, yy
integer :: intrvl
!-----------------------------------------------------------------------
!
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!
!-----------------------------------------------------------------------
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), f1(kf1,n), f2(kf2,n), &
&f12(kf12,n)
!
if (ider .gt. 3 .or. jder .gt. 3) go to 400
mm1 = m - 1
nm1 = n - 1
!
iold = 0
jold = 0
do l = 1,my
   yy = y(l)
   if (yy .lt. t(2)) go to 10
   if (yy .ge. t(nm1)) go to 20
   if (l .eq. 1) go to 30
   if (yy - y(l-1)) 30,50,40
!
10 j = 1
   go to 50
20 j = nm1
   go to 50
30 j = intrvl (yy, t, n)
   go to 50
!
!        Linear forward search
!
40 if (yy .lt. t(j + 1)) go to 50
   j = j + 1
   go to 40
!
50 jp1 = j + 1
   dt = t(jp1) - t(j)
!
   do 350 k = 1,mx
      xx = x(k)
      if (xx .lt. s(2)) go to 100
      if (xx .ge. s(mm1)) go to 110
      if (k .eq. 1) go to 120
      if (xx - x(k-1)) 120,130,140
!
100 i = 1
      if (i .eq. iold .and. j .eq. jold) go to 210
      go to 200
110 i = mm1
      if (i .eq. iold .and. j .eq. jold) go to 210
      go to 200
120 i = intrvl (xx, s, m)
      if (i .eq. iold .and. j .eq. jold) go to 210
      go to 200
130 z(k,l) = z(k-1,l)
      go to 350
!
!           Linear forward search
!
140 if (xx .lt. s(i + 1)) go to 210
150 i = i + 1
         if (xx .ge. s(i + 1)) go to 150
!
!           Computation of the JDER-TH derivative of
!           F(S(I),Y), D1F(S(I),Y), F(S(I+1),Y), AND
!           D1F(S(I+1),Y) at the point YY.
!
200 iold = i
         ip1 = i + 1
         ds = s(ip1) - s(i)
!
         d = (f(i,jp1) - f(i,j))/dt
         a = d - dt*(2.0*f2(i,j) + f2(i,jp1))/6.0
         c = (f2(i,jp1) - f2(i,j))/(6.0*dt)
!
         d = (f(ip1,jp1) - f(ip1,j))/dt
         a1 = d - dt*(2.0*f2(ip1,j) + f2(ip1,jp1))/6.0
         c1 = (f2(ip1,jp1) - f2(ip1,j))/(6.0*dt)
!
         d = (f1(i,jp1) - f1(i,j))/dt
         a2 = d - dt*(2.0*f12(i,j) + f12(i,jp1))/6.0
         c2 = (f12(i,jp1) - f12(i,j))/(6.0*dt)
!
         d = (f1(ip1,jp1) - f1(ip1,j))/dt
         a3 = d - dt*(2.0*f12(ip1,j) + f12(ip1,jp1))/6.0
         c3 = (f12(ip1,jp1) - f12(ip1,j))/(6.0*dt)
!
210 dy = yy - t(j)
      if (jder .eq. 0) go to 220
      if (jder - 2) 230,240,250
!
220 fi = ((c*dy + 0.5*f2(i,j))*dy + a)*dy + f(i,j)
      fip1 = ((c1*dy + 0.5*f2(ip1,j))*dy + a1)*dy + f(ip1,j)
      dfi = ((c2*dy + 0.5*f12(i,j))*dy + a2)*dy + f1(i,j)
      dfip1 = ((c3*dy + 0.5*f12(ip1,j))*dy + a3)*dy + f1(ip1,j)
      go to 300
!
230 fi = (3.0*c*dy + f2(i,j))*dy + a
      fip1 = (3.0*c1*dy + f2(ip1,j))*dy + a1
      dfi = (3.0*c2*dy + f12(i,j))*dy + a2
      dfip1 = (3.0*c3*dy + f12(ip1,j))*dy + a3
      go to 300
!
240 fi = 6.0*c*dy + f2(i,j)
      fip1 = 6.0*c1*dy + f2(ip1,j)
      dfi = 6.0*c2*dy + f12(i,j)
      dfip1 = 6.0*c3*dy + f12(ip1,j)
      go to 300
!
250 fi = 6.0*c
      fip1 = 6.0*c1
      dfi = 6.0*c2
      dfip1 = 6.0*c3
!
!           Computation of the IDER-TH derivative
!           at the point XX.
!
300 d = (fip1 - fi)/ds
      ax = d - ds*(2.0*dfi + dfip1)/6.0
      cx = (dfip1 - dfi)/(6.0*ds)
!
      dx = xx - s(i)
      if (ider .eq. 0) go to 310
      if (ider - 2) 320,330,340
!
310 z(k,l) = ((cx*dx + 0.5*dfi)*dx + ax)*dx + fi
      go to 350
320 z(k,l) = (3.0*cx*dx + dfi)*dx + ax
      go to 350
330 z(k,l) = 6.0*cx*dx + dfi
      go to 350
340 z(k,l) = 6.0*cx
!
350 continue
   jold = j
end do
return
!
!     Case when the results are zero.
!
400 do l = 1,my
   do k = 1,mx
      z(k,l) = 0.0
   end do
end do
return
end subroutine csrf

subroutine csrf2 (ider, jder, x, mx, y, my, z, kz, s, m, t, n, &
&f, kf, ddf)
implicit none
integer, intent(in) :: ider, jder, kf, kz, m, mx, my, n
!-----------------------------------------------------------------------
!
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!
!-----------------------------------------------------------------------
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), ddf(m,n,3)
!
call csrf (ider, jder, x, mx, y, my, z, kz, s, m, t, n, f, kf, &
&ddf(1,1,2), m, ddf, m, ddf(1,1,3), m)
return
end subroutine csrf2

subroutine surf (m,n,x,y,z,iz,opt,zp,temp,sigma,ierr)
implicit none
integer :: i, ibak, ibakp1, im1, ip1, j, jbak, jbakp1, jm1, jp1, &
&key, l, mm1, mp1, nm1, np1, npi, npibak, npm, npmpj
real :: c1, c2, c3, del1, del2, deli, delx1, delx2, delxm, delxmm, &
&dely1, dely2, delyn, delynm, diag1, diag2, diagi, diagin, sdiag1, &
&sdiag2, sigmax, sigmay, t, zxy1ns, zxymns
!
integer, intent(in) :: m, n, iz
integer, intent(out) :: ierr
real, intent(in) :: x(m), y(n), z(iz,n), opt(*)
real, intent(inout) :: zp(m,n,*), temp(*)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
!                               MODIFIED BY ALFRED H. MORRIS
!                               NAVAL SURFACE WEAPONS CENTER
!                                          DAHLGREN VIRGINIA
!
! This subroutine determines the parameters necessary to
! compute an interpolatory surface passing through a rect-
! angular grid of functional values. The surface determined
! can be represented as the tensor product of splines under
! tension. The X- and Y-partial derivatives around the
! boundary and the X-Y-partial derivatives at the four
! corners may be specified or omitted. For actual mapping
! of points onto the surface it is necessary to call the
! FUNCTION SURF2.
!
! On input--
!
!   M is the number of grid lines in the X-direction, I. E.
!   LINES PARALLEL TO THE Y-AXIS (M .GE. 2).
!
!   N is the number of grid lines in the Y-direction, I. E.
!   LINES PARALLEL TO THE X-AXIS (N .GE. 2).
!
!   X is an array of the M X-coordinates of the grid lines
!   in the X-direction. These should be strictly increasing.
!
!   Y is an array of the N Y-coordinates of the grid lines
!   in the Y-direction. These should be strictly increasing.
!
!   Z is an array of the M * N functional values at the grid
!   points, I. E. Z(I,J) contains the functional value at
!   (X(I),Y(J)) FOR I = 1,...,M AND J = 1,...,N.
!
!   IZ is the row dimension of the matrix Z used in the
!   CALLING PROGRAM (IZ .GE. M).
!
!   Opt is an option vector. If no boundary conditions are
!   to be imposed on the surface then let opt be of length 1
!   AND SET OPT(1)=0. OTHERWISE, SEE THE DESCRIPTION OF SURF
!   in the NSWC library manual.
!
!   ZP is an array of at least 3*M*N locations.
!
!   Temp is an array of at least N+N+M locations which is
!   used for scratch storage.
!
!   Sigma contains the tension factor. This value indicates
!   the curviness desired. If ABS(SIGMA) is nearly zero
!   (E. G. .001) The resulting surface is approximately the
!   tensor product of cubic splines. If ABS(SIGMA) is large
!   (E. G. 50.) The resulting surface is approximately
!   BI-linear. If sigma equals zero tensor products of
!   cubic splines result. A standard value for sigma is
!   approximately 1. In absolute value.
!
! On output--
!
!   ZP contains the values of the XX-, YY-, and XXYY-partial
!   derivatives of the surface at the given nodes.
!
!   IERR contains an error flag,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2 OR M IS LESS THAN 2,
!        = 2 IF THE X-VALUES OR Y-VALUES ARE NOT STRICTLY
!            increasing,
!        = 3 THE OPTION VECTOR HAS AN ERROR.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
! AND SNHCSH.
!
!-----------------------------------------------------------
!
integer :: ind(8), loc(8), num(8)
data num(5)/1/, num(6)/1/, num(7)/1/, num(8)/1/
!
mm1 = m-1
mp1 = m+1
nm1 = n-1
np1 = n+1
npm = n+m
ierr = 0
if (n .le. 1 .or. m .le. 1) go to 46
if (y(n) .le. y(1)) go to 47
!
! Process the option vector
!
num(1) = n
num(2) = n
num(3) = m
num(4) = m
ind(1) = 0
ind(2) = 0
ind(3) = 0
ind(4) = 0
ind(5) = 0
ind(6) = 0
ind(7) = 0
ind(8) = 0
!
l = 1
100 key = opt(l)
if (key) 48,110,101
101 if (key .gt. 8) go to 48
ind(key) = 1
l = l+1
loc(key) = l
l = l + num(key)
go to 100
!
! Denormalize tension factor in Y-direction
!
110 sigmay = abs(sigma)*float(n-1)/(y(n)-y(1))
!
! OBTAIN Y-PARTIAL DERIVATIVES ALONG Y = Y(1)
!
if (ind(3) .eq. 0) go to 2
l = loc(3)
do 1 i = 1,m
  zp(i,1,1) = opt(l)
1 l = l+1
go to 5
2 dely1 = y(2)-y(1)
dely2 = dely1+dely1
if (n .gt. 2) dely2 = y(3)-y(1)
if (dely1 .le. 0. .or. dely2 .le. dely1) go to 47
call ceez (dely1,dely2,sigmay,c1,c2,c3,n)
do 3 i = 1,m
3 zp(i,1,1) = c1*z(i,1)+c2*z(i,2)
if (n .eq. 2) go to 5
do 4 i = 1,m
4 zp(i,1,1) = zp(i,1,1)+c3*z(i,3)
!
! OBTAIN Y-PARTIAL DERIVATIVES ALONG Y = Y(N)
!
5 if (ind(4) .eq. 0) go to 7
l = loc(4)
do 6 i = 1,m
  npi = n+i
  temp(npi) = opt(l)
6 l = l+1
go to 10
7 delyn = y(n)-y(nm1)
delynm = delyn+delyn
if (n .gt. 2) delynm = y(n)-y(n-2)
if (delyn .le. 0. .or. delynm .le. delyn) go to 47
call ceez (-delyn,-delynm,sigmay,c1,c2,c3,n)
do 8 i = 1,m
  npi = n+i
8 temp(npi) = c1*z(i,n)+c2*z(i,nm1)
if (n .eq. 2) go to 10
do 9 i = 1,m
  npi = n+i
9 temp(npi) = temp(npi)+c3*z(i,n-2)
10 if (x(m) .le. x(1)) go to 47
!
! Denormalize tension factor in X-direction
!
sigmax = abs(sigma)*float(m-1)/(x(m)-x(1))
!
! OBTAIN X-PARTIAL DERIVATIVES ALONG X = X(1)
!
if (ind(1) .eq. 0) go to 12
l = loc(1)
do 11 j = 1,n
  zp(1,j,2) = opt(l)
11 l = l+1
if (ind(5)+ind(7) .eq. 2) go to 15
12 delx1 = x(2)-x(1)
delx2 = delx1+delx1
if (m .gt. 2) delx2 = x(3)-x(1)
if (delx1 .le. 0. .or. delx2 .le. delx1) go to 47
call ceez (delx1,delx2,sigmax,c1,c2,c3,m)
if (ind(1) .eq. 1) go to 15
do 13 j = 1,n
13 zp(1,j,2) = c1*z(1,j)+c2*z(2,j)
if (m .eq. 2) go to 15
do 14 j = 1,n
14 zp(1,j,2) = zp(1,j,2)+c3*z(3,j)
!
! Obtain X-Y-partial derivative at (X(1),Y(1))
!
15 if (ind(5) .eq. 0) go to 16
l = loc(5)
zp(1,1,3) = opt(l)
go to 17
16 zp(1,1,3) = c1*zp(1,1,1)+c2*zp(2,1,1)
if (m .gt. 2) zp(1,1,3) = zp(1,1,3)+c3*zp(3,1,1)
!
! Obtain X-Y-partial derivative at (X(1),Y(N))
!
17 if (ind(7) .eq. 0) go to 18
l = loc(7)
zxy1ns = opt(l)
go to 19
18 zxy1ns = c1*temp(n+1)+c2*temp(n+2)
if (m .gt. 2) zxy1ns = zxy1ns+c3*temp(n+3)
!
! OBTAIN X-PARTIAL DERIVATIVE ALONG X = X(M)
!
19 if (ind(2) .eq. 0) go to 21
l = loc(2)
do 20 j = 1,n
  npmpj = npm+j
  temp(npmpj) = opt(l)
20 l = l+1
21 if (ind(6)+ind(8) .eq. 2) go to 24
delxm = x(m)-x(mm1)
delxmm = delxm+delxm
if (m .gt. 2) delxmm = x(m)-x(m-2)
if (delxm .le. 0. .or. delxmm .le. delxm) go to 47
call ceez (-delxm,-delxmm,sigmax,c1,c2,c3,m)
if (ind(2) .eq. 1) go to 24
do 22 j = 1,n
  npmpj = npm+j
22 temp(npmpj) = c1*z(m,j)+c2*z(mm1,j)
if (m .eq. 2) go to 24
do 23 j = 1,n
  npmpj = npm+j
23 temp(npmpj) = temp(npmpj)+c3*z(m-2,j)
!
! Obtain X-Y-partial derivative at (X(M),Y(1))
!
24 if (ind(6) .eq. 0) go to 25
l = loc(6)
zp(m,1,3) = opt(l)
go to 26
25 zp(m,1,3) = c1*zp(m,1,1)+c2*zp(mm1,1,1)
if (m .gt. 2) zp(m,1,3) = zp(m,1,3)+c3*zp(m-2,1,1)
!
! Obtain X-Y-partial derivative at (X(M),Y(N))
!
26 if (ind(8) .eq. 0) go to 27
l = loc(8)
zxymns = opt(l)
go to 28
27 zxymns = c1*temp(npm)+c2*temp(npm-1)
if (m .gt. 2) zxymns = zxymns+c3*temp(npm-2)
!
! Set up right hand sides and tridiagonal system for Y-grid
! perform forward elimination
!
28 del1 = y(2)-y(1)
if (del1 .le. 0.) go to 47
deli = 1./del1
do 29 i = 1,m
29 zp(i,2,1) = deli*(z(i,2)-z(i,1))
zp(1,2,3) = deli*(zp(1,2,2)-zp(1,1,2))
zp(m,2,3) = deli*(temp(npm+2)-temp(npm+1))
call terms (diag1,sdiag1,sigmay,del1)
diagi = 1./diag1
do 30 i = 1,m
30 zp(i,1,1) = diagi*(zp(i,2,1)-zp(i,1,1))
zp(1,1,3) = diagi*(zp(1,2,3)-zp(1,1,3))
zp(m,1,3) = diagi*(zp(m,2,3)-zp(m,1,3))
temp(1) = diagi*sdiag1
if (n .eq. 2) go to 34
do 33 j = 2,nm1
  jm1 = j-1
  jp1 = j+1
  npmpj = npm+j
  del2 = y(jp1)-y(j)
  if (del2 .le. 0.) go to 47
  deli = 1./del2
  do 31 i = 1,m
31 zp(i,jp1,1) = deli*(z(i,jp1)-z(i,j))
  zp(1,jp1,3) = deli*(zp(1,jp1,2)-zp(1,j,2))
  zp(m,jp1,3) = deli*(temp(npmpj+1)-temp(npmpj))
  call terms (diag2,sdiag2,sigmay,del2)
  diagin = 1./(diag1+diag2-sdiag1*temp(jm1))
  do 32 i = 1,m
32 zp(i,j,1) = diagin*(zp(i,jp1,1)-zp(i,j,1)- &
&sdiag1*zp(i,jm1,1))
  zp(1,j,3) = diagin*(zp(1,jp1,3)-zp(1,j,3)- &
&sdiag1*zp(1,jm1,3))
  zp(m,j,3) = diagin*(zp(m,jp1,3)-zp(m,j,3)- &
&sdiag1*zp(m,jm1,3))
  temp(j) = diagin*sdiag2
  diag1 = diag2
33 sdiag1 = sdiag2
34 diagin = 1./(diag1-sdiag1*temp(nm1))
do 35 i = 1,m
  npi = n+i
35 zp(i,n,1) = diagin*(temp(npi)-zp(i,n,1)- &
&sdiag1*zp(i,nm1,1))
zp(1,n,3) = diagin*(zxy1ns-zp(1,n,3)- &
&sdiag1*zp(1,nm1,3))
temp(n) = diagin*(zxymns-zp(m,n,3)- &
&sdiag1*zp(m,nm1,3))
!
! Perform back substitution
!
do 37 j = 2,n
  jbak = np1-j
  jbakp1 = jbak+1
  t = temp(jbak)
  do 36 i = 1,m
36 zp(i,jbak,1) = zp(i,jbak,1)-t*zp(i,jbakp1,1)
  zp(1,jbak,3) = zp(1,jbak,3)-t*zp(1,jbakp1,3)
37 temp(jbak) = zp(m,jbak,3)-t*temp(jbakp1)
!
! Set up right hand sides and tridiagonal system for X-grid
! perform forward elimination
!
del1 = x(2)-x(1)
if (del1 .le. 0.) go to 47
deli = 1./del1
do 38 j = 1,n
  zp(2,j,2) = deli*(z(2,j)-z(1,j))
38 zp(2,j,3) = deli*(zp(2,j,1)-zp(1,j,1))
call terms (diag1,sdiag1,sigmax,del1)
diagi = 1./diag1
do 39 j = 1,n
  zp(1,j,2) = diagi*(zp(2,j,2)-zp(1,j,2))
39 zp(1,j,3) = diagi*(zp(2,j,3)-zp(1,j,3))
temp(n+1) = diagi*sdiag1
if (m  .eq. 2) go to 43
do 42 i = 2,mm1
  im1 = i-1
  ip1 = i+1
  npi = n+i
  del2 = x(ip1)-x(i)
  if (del2 .le. 0.) go to 47
  deli = 1./del2
  do 40 j = 1,n
    zp(ip1,j,2) = deli*(z(ip1,j)-z(i,j))
40 zp(ip1,j,3) = deli*(zp(ip1,j,1)-zp(i,j,1))
  call terms (diag2,sdiag2,sigmax,del2)
  diagin = 1./(diag1+diag2-sdiag1*temp(npi-1))
  do 41 j = 1,n
    zp(i,j,2) = diagin*(zp(ip1,j,2)-zp(i,j,2)- &
&sdiag1*zp(im1,j,2))
41 zp(i,j,3) = diagin*(zp(ip1,j,3)-zp(i,j,3)- &
&sdiag1*zp(im1,j,3))
  temp(npi) = diagin*sdiag2
  diag1 = diag2
42 sdiag1 = sdiag2
43 diagin = 1./(diag1-sdiag1*temp(npm-1))
do 44 j = 1,n
  npmpj = npm+j
  zp(m,j,2) = diagin*(temp(npmpj)-zp(m,j,2)- &
&sdiag1*zp(mm1,j,2))
44 zp(m,j,3) = diagin*(temp(j)-zp(m,j,3)- &
&sdiag1*zp(mm1,j,3))
!
! Perform back substitution
!
do 45 i = 2,m
  ibak = mp1-i
  ibakp1 = ibak+1
  npibak = n+ibak
  t = temp(npibak)
  do 45 j = 1,n
    zp(ibak,j,2) = zp(ibak,j,2)-t*zp(ibakp1,j,2)
45 zp(ibak,j,3) = zp(ibak,j,3)-t*zp(ibakp1,j,3)
return
!
! Too few points
!
46 ierr = 1
return
!
! Points not strictly increasing
!
47 ierr = 2
return
!
! The option vector HAS an error
!
48 ierr = 3
return
end subroutine surf

function surf2 (xx,yy,m,n,x,y,z,iz,zp,sigma)
implicit none
integer :: i, im1, j, jm1
real :: coshp1, coshp2, del1, del2, delp1, delp2, dels, dummy, f1, &
&f2, fp1, fp2, sigmap, sigmax, sigmay, sinhm1, sinhm2, sinhms, &
&sinhp1, sinhp2, zi, zim1, zxxi, zxxim1
real :: hermnz
real :: surf2
real :: hermz
integer :: intrvl
!
integer, intent(in) :: m, n, iz
real, intent(in) :: xx, yy, x(m), y(n)
real :: z(iz,n), zp(m,n,*)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This function interpolates a surface at a given coordinate
! pair using A BI-spline under tension. The subroutine SURF1
! should be called earlier to determine certain necessary
! parameters.
!
! On input--
!
!   XX and YY contain the X- and Y-coordinates of the point
!   to be mapped onto the interpolating surface.
!
!   M and N contain the number of grid lines in the X- and
!   Y-directions, respectively, of the rectangular grid
!   which specified the surface.
!
!   X and Y are arrays containing the X- and Y-grid values,
!   respectively, each in increasing order.
!
!   Z is a matrix containing the M * N functional values
!   corresponding to the grid values (I. E. Z(I,J) is the
!   SURFACE VALUE AT THE POINT (X(I),Y(J)) FOR I = 1,...,M
!   AND J = 1,...,N).
!
!   IZ contains the row dimension of the array Z as declared
!   in the calling program.
!
!   ZP is an array of 3*M*N locations stored with the
!   various surface derivative information determined by
!   SURF1.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters M, N, X, Y, Z, IZ, ZP, and sigma should be
! input unaltered from the output of SURF1.
!
! On output--
!
!   SURF2 contains the interpolated surface value.
!
! None of the input parameters are altered.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Inline one dimensional cubic spline interpolation
!
hermz (f1,f2,fp1,fp2) = (f2*del1+f1*del2)/dels-del1* &
&del2*(fp2*(del1+dels)+ &
&fp1*(del2+dels))/ &
&(6.*dels)
!
! Inline one dimensional spline under tension interpolation
!
hermnz (f1,f2,fp1,fp2,sigmap) = (f2*del1+f1*del2)/dels &
&+(fp2*(sinhm1*del2-del1*(2.*(coshp1+1.)* &
&sinhp2+sigmap*coshp1*del2)) &
&+fp1*(sinhm2*del1-del2*(2.*(coshp2+1.)* &
&sinhp1+sigmap*coshp2*del1)) &
&)/(sigmap*sigmap*dels*(sinhms+sigmap*dels))
!
! Denormalize tension factor in X and Y direction
!
sigmax = abs(sigma)*float(m-1)/(x(m)-x(1))
sigmay = abs(sigma)*float(n-1)/(y(n)-y(1))
!
! Determine Y interval
!
jm1 = intrvl (yy,y,n)
j = jm1+1
!
! Determine X interval
!
im1 = intrvl (xx,x,m)
i = im1+1
del1 = yy-y(jm1)
del2 = y(j)-yy
dels = y(j)-y(jm1)
if (sigmay .ne. 0.) go to 1
!
! Perform four interpolations in Y-direction
!
zim1 = hermz(z(i-1,j-1),z(i-1,j),zp(i-1,j-1,1), &
&zp(i-1,j,1))
zi = hermz(z(i,j-1),z(i,j),zp(i,j-1,1),zp(i,j,1))
zxxim1 = hermz(zp(i-1,j-1,2),zp(i-1,j,2), &
&zp(i-1,j-1,3),zp(i-1,j,3))
zxxi = hermz(zp(i,j-1,2),zp(i,j,2), &
&zp(i,j-1,3),zp(i,j,3))
go to 2
1 delp1 = (del1+dels)/2.
delp2 = (del2+dels)/2.
call snhcsh (sinhm1,dummy,sigmay*del1,-1)
call snhcsh (sinhm2,dummy,sigmay*del2,-1)
call snhcsh (sinhms,dummy,sigmay*dels,-1)
call snhcsh (sinhp1,dummy,sigmay*del1/2.,-1)
call snhcsh (sinhp2,dummy,sigmay*del2/2.,-1)
call snhcsh (dummy,coshp1,sigmay*delp1,1)
call snhcsh (dummy,coshp2,sigmay*delp2,1)
zim1 = hermnz(z(i-1,j-1),z(i-1,j),zp(i-1,j-1,1), &
&zp(i-1,j,1),sigmay)
zi = hermnz(z(i,j-1),z(i,j),zp(i,j-1,1),zp(i,j,1), &
&sigmay)
zxxim1 = hermnz(zp(i-1,j-1,2),zp(i-1,j,2), &
&zp(i-1,j-1,3),zp(i-1,j,3),sigmay)
zxxi = hermnz(zp(i,j-1,2),zp(i,j,2), &
&zp(i,j-1,3),zp(i,j,3),sigmay)
!
! Perform final interpolation in X-direction
!
2 del1 = xx-x(im1)
del2 = x(i)-xx
dels = x(i)-x(im1)
if (sigmax .ne. 0.) go to 3
surf2 = hermz(zim1,zi,zxxim1,zxxi)
return
3 delp1 = (del1+dels)/2.
delp2 = (del2+dels)/2.
call snhcsh (sinhm1,dummy,sigmax*del1,-1)
call snhcsh (sinhm2,dummy,sigmax*del2,-1)
call snhcsh (sinhms,dummy,sigmax*dels,-1)
call snhcsh (sinhp1,dummy,sigmax*del1/2.,-1)
call snhcsh (sinhp2,dummy,sigmax*del2/2.,-1)
call snhcsh (dummy,coshp1,sigmax*delp1,1)
call snhcsh (dummy,coshp2,sigmax*delp2,1)
surf2 = hermnz(zim1,zi,zxxim1,zxxi,sigmax)
return
end function surf2

subroutine nsurf2 (dxmin,dxmax,md,dymin,dymax,nd,dz, &
&idz,m,n,x,y,z,iz,zp,work,sigma)
implicit none
integer :: i, ii, im1, j, jj, jm1, lasti, lastj
real :: c1, c2, c3, c4, coshp1, coshp2, del1, del2, delp1, delp2, &
&dels, deltdx, deltdy, dummy, sigmax, sigmay, sinhm1, sinhm2, &
&sinhms, sinhp1, sinhp2, temp, xii, yjj, zi, zim1, zxxi, zxxim1
!
integer, intent(in) :: md, nd, idz, m, n, iz
real, intent(in) :: dxmin, dxmax, dymin, dymax
real, intent(inout) :: dz(idz,nd)
real, intent(in) :: x(m), y(n), z(iz,n), zp(m,n,*)
real, intent(inout) :: work(4,md)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                                 CODED BY ALAN KAYLOR CLINE
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine maps values onto a surface at every point
! of a grid equally spaced in both X and Y coordinates. The
! surface interpolation is performed using A BI-spline
! under tension. The subroutine SURF1 or NSURF1 should be
! called earlier to determine certain necessary parameters.
!
! On input--
!
!   DXMIN and DXMAX contain the lower and upper limits,
!   respectively, of the X-coordinates of the second grid.
!
!   MD contains the number of grid lines in the X direction
!   OF THE SECOND GRID (MD .GE. 1).
!
!   DYMIN and DYMAX contain the lower and upper limits,
!   respectively, of the Y-coordinates of the second grid.
!
!   ND contains the number of grid lines in the Y direction
!   OF THE SECOND GRID (ND .GE. 1).
!
!   IDZ contains the row dimension of the array DZ as
!   declared in the calling program.
!
!   M and N contain the number of grid lines in the X- and
!   Y-directions, respectively, of the rectangular grid
!   which specified the surface.
!
!   X and Y are arrays containing the X- and Y-grid values,
!   respectively, each in increasing order.
!
!   Z is a matrix containing the M * N functional values
!   corresponding to the grid values (I. E. Z(I,J) is the
!   SURFACE VALUE AT THE POINT (X(I),Y(J)) FOR I = 1,...,M
!   AND J = 1,...,N).
!
!   IZ contains the row dimension of the array Z as declared
!   in the calling program.
!
!   ZP is an array of 3*M*N locations stored with the
!   various surface derivative information determined by
!   SURF1.
!
!   Work is an array of 4*MD locations to be used internally
!   for workspace.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters M, N, X, Y, Z, IZ, ZP, and sigma should be
! input unaltered from the output of SURF1 or NSURF1.
!
! On output--
!
!   DZ contains the MD by ND array of surface values
!   interpolated at the points of the second grid.
!
! None of the input parameters are altered.
!
! THIS FUNCTION REFERENCES PACKAGE MODULE SNHCSH.
!
!-----------------------------------------------------------
!
! Denormalize tension factor in X and Y direction
!
sigmax = abs(sigma)*float(m-1)/(x(m)-x(1))
sigmay = abs(sigma)*float(n-1)/(y(n)-y(1))
!
! Find intervals of second X grid with respect to original X
! grid
!
deltdx = 0.
if (md .ge. 2) deltdx = (dxmax-dxmin)/float(md-1)
lasti = 1
do 3 ii = 1,md
  xii = dxmin+float(ii-1)*deltdx
  i = lasti
1 i = i+1
  if (xii .gt. x(i) .and. i .lt. m) go to 1
  im1 = i-1
  lasti = im1
  del1 = xii-x(im1)
  del2 = x(i)-xii
  dels = x(i)-x(im1)
  work(1,ii) = del2/dels
  work(2,ii) = del1/dels
  if (sigmax .ne. 0.) go to 2
  temp = -del1*del2/(6.*dels)
  work(3,ii) = temp*(del2+dels)
  work(4,ii) = temp*(del1+dels)
  go to 3
2 delp1 = (del1+dels)/2.
  delp2 = (del2+dels)/2.
  call snhcsh (sinhm1,dummy,sigmax*del1,-1)
  call snhcsh (sinhm2,dummy,sigmax*del2,-1)
  call snhcsh (sinhms,dummy,sigmax*dels,-1)
  call snhcsh (sinhp1,dummy,sigmax*del1/2.,-1)
  call snhcsh (sinhp2,dummy,sigmax*del2/2.,-1)
  call snhcsh (dummy,coshp1,sigmax*delp1,1)
  call snhcsh (dummy,coshp2,sigmax*delp2,1)
  temp = sigmax*sigmax*dels*(sinhms+sigmax*dels)
  work(3,ii) = (sinhm2*del1-del2*(2.*(coshp2+1.)* &
&sinhp1+sigmax*coshp2*del1))/temp
  work(4,ii) = (sinhm1*del2-del1*(2.*(coshp1+1.)* &
&sinhp2+sigmax*coshp1*del2))/temp
3 continue
!
! Find intervals of second Y grid with respect to original Y
! grid and perform intrpolation
!
deltdy = 0.
if (nd .ge. 2) deltdy = (dymax-dymin)/float(nd-1)
lastj = 1
do 8 jj = 1,nd
  yjj = dymin+float(jj-1)*deltdy
  j = lastj
4 j = j+1
  if (yjj .gt. y(j) .and. j .lt. n) go to 4
  jm1 = j-1
  lastj = jm1
  del1 = yjj-y(jm1)
  del2 = y(j)-yjj
  dels = y(j)-y(jm1)
  c1 = del2/dels
  c2 = del1/dels
  if (sigmay .ne. 0.) go to 5
  temp = -del1*del2/(6.*dels)
  c3 = temp*(del2+dels)
  c4 = temp*(del1+dels)
  go to 6
5 delp1 = (del1+dels)/2.
  delp2 = (del2+dels)/2.
  call snhcsh (sinhm1,dummy,sigmay*del1,-1)
  call snhcsh (sinhm2,dummy,sigmay*del2,-1)
  call snhcsh (sinhms,dummy,sigmay*dels,-1)
  call snhcsh (sinhp1,dummy,sigmay*del1/2.,-1)
  call snhcsh (sinhp2,dummy,sigmay*del2/2.,-1)
  call snhcsh (dummy,coshp1,sigmay*delp1,1)
  call snhcsh (dummy,coshp2,sigmay*delp2,1)
  temp = sigmay*sigmay*dels*(sinhms+sigmay*dels)
  c3 = (sinhm2*del1-del2*(2.*(coshp2+1.)* &
&sinhp1+sigmay*coshp2*del1))/temp
  c4 = (sinhm1*del2-del1*(2.*(coshp1+1.)* &
&sinhp2+sigmay*coshp1*del2))/temp
6 lasti = 0
  do 8 ii = 1,md
    xii = dxmin+float(ii-1)*deltdx
    i = max0 (1, lasti)
7 i = i+1
    if (xii .gt. x(i) .and. i .lt. m) go to 7
    im1 = i-1
    if (im1 .eq. lasti) go to 8
    lasti = im1
    zim1 = c1*z(im1,jm1)+c2*z(im1,j) &
&+c3*zp(im1,jm1,1)+c4*zp(im1,j,1)
    zi = c1*z(i,jm1)+c2*z(i,j) &
&+c3*zp(i,jm1,1)+c4*zp(i,j,1)
    zxxim1 = c1*zp(im1,jm1,2)+c2*zp(im1,j,2) &
&+c3*zp(im1,jm1,3)+c4*zp(im1,j,3)
    zxxi = c1*zp(i,jm1,2)+c2*zp(i,j,2) &
&+c3*zp(i,jm1,3)+c4*zp(i,j,3)
8 dz(ii,jj) = work(1,ii)*zim1+work(2,ii)*zi &
&+work(3,ii)*zxxim1+work(4,ii)*zxxi
return
end subroutine nsurf2

subroutine bstrp2 (x, y, z, kz, tx, nx, kx, ty, ny, ky, &
&a, ka, wk, l, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: ka, kx, ky, kz, l, nx, ny
integer :: iw, m
!-----------------------------------------------------------------------
!
!         Piecewise polynomial interpolation in two variables
!
!                          -----------------
!
!     The piecewise polynomials considered are tensor products of
!     B-splines, having the form
!
!                          NX   NY
!              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                         I=1  J=1   IJ  I     J
!
!     Where U  and V  are one-dimensional B-spline basis functions.
!            I      J
!
!-----------------------------------------------------------------------
!     REAL TX(NX + KX), TY(NY + KY)
!     REAL WK(L)  WHERE L = NX*NY + MAX(2*KX*NX, 2*KY*NY)
!-------------------------
real, intent(in) :: x(nx), y(ny), z(kz,ny)
real, intent(in) :: tx(*), ty(*)
real, intent(inout) :: a(ka,ny), wk(l)
!
m = nx*ny + 2*max0(kx*nx, ky*ny)
if (l .lt. m) go to 120
!
!     Compute the coefficients
!
iw = nx*ny + 1
call bstrp1 (x, z, kz, nx, ny, tx, kx, wk, ny, wk(iw), iflag)
if (iflag .ne. 0) go to 100
call bstrp1 (y, wk, ny, ny, nx, ty, ky, a, ka, wk(iw), iflag)
if (iflag .ne. 0) go to 110
return
!
!     Error return
!
100 iflag = 1
return
110 iflag = 2
return
120 iflag = 3
return
end subroutine bstrp2

subroutine bstrp1 (x, z, kz, m, n, t, k, a, ka, work, iflag)
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: k, ka, kz, m, n
integer :: i, j, mp1
!-------------------------------------------------------------------
!     BSTRP1 computes B-spline interpolation coefficients for
!     N sets of data stored in the columns of the array Z. The
!     coefficients are stored in the rows of A.
!
!     IT IS ASSUMED THAT KZ .GE. M AND KA .GE. N.
!-------------------------------------------------------------------
!     REAL T(M + K), WORK(2*K*M)
!-----------------------
real, intent(in) :: x(m), z(kz,n), t(*)
real, intent(inout) :: a(ka,m), work(*)
!
!     First data set
!
iflag = 1
mp1 = m + 1
call bstrp (x, z, t, m, k, work(1), work(mp1), iflag)
if (iflag .ne. 0) return
!
do i = 1,m
   a(1,i) = work(i)
end do
if (n .eq. 1) return
!
!     Remaining data sets
!
do j = 2,n
   call bstrp (x, z(1,j), t, m, k, work(1), work(mp1), iflag)
   do i = 1,m
      a(j,i) = work(i)
   end do
end do
return
end subroutine bstrp1

subroutine bslsq2 (x, wx, mx, y, wy, my, z, kz, tx, nx, kx, &
&ty, ny, ky, a, ka, wk, l, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: ka, kx, ky, kz, l, mx, my, nx, ny
integer :: ierr, iq, iw, m
!-----------------------------------------------------------------------
!
!             Weighted least squares fitting of piecewise
!                    polynomials in two variables
!
!                          ----------------
!
!     The piecewise polynomials considered are tensor products of
!     B-splines, having the form
!
!                          NX   NY
!              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                         I=1  J=1   IJ  I     J
!
!     Where U  and V  are one-dimensional B-spline basis functions.
!            I      J
!
!-----------------------------------------------------------------------
!     REAL TX(NX + KX), TY(NY + KY)
!     REAL WK(L)  WHERE L = NX*MY + MAX((KX+1)*NX,(KY+1)*NY)
!-------------------------
real, intent(in) :: x(mx), wx(mx), y(my), wy(my), z(kz,my)
real, intent(in) :: tx(*), ty(*)
real, intent(inout) :: a(ka,ny), wk(l)
!
m = nx*my + max0((kx + 1)*nx,(ky + 1)*ny)
if (l .lt. m) go to 120
!
!     Compute the coefficients
!
iw = nx*my + 1
iq = iw + nx
call bslsq1 (x, wx, mx, z, kz, my, tx, nx, kx, &
&wk, my, wk(iw), wk(iq), ierr)
if (ierr .lt. 0) go to 100
!
iq = iw + ny
call bslsq1 (y, wy, my, wk, my, nx, ty, ny, ky, &
&a, ka, wk(iw), wk(iq), iflag)
if (iflag .lt. 0) go to 110
iflag = max0(ierr,iflag)
return
!
!     Error return
!
100 iflag = -1
return
110 iflag = -2
return
120 iflag = -3
wk(1) = m
return
end subroutine bslsq2

subroutine bslsq1 (tau, wgt, ntau, z, kz, m, t, n, k, &
&a, ka, wk, q, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: k, ka, kz, m, n, ntau
integer :: i, j, jj, l, left, leftmk, mm
real :: dw
!-----------------------------------------------------------------------
!
!     BSLSQ1 produces the B-spline coefficients A(J,1),...,A(J,N)
!     of the piecewise polynomial P(X) of order K with knots T(I)
!     (I = 1,...,N+K) WHICH MINIMIZES
!
!              SUM (WGT(L)*(P(TAU(L)) - Z(L,J))**2)
!                 L
!
!     FOR J = 1,...,M.
!
!     Input ...
!
!       TAU   ARRAY OF LENGTH NTAU CONTAINING DATA POINT ABSCISSAE.
!       WGT   ARRAY OF LENGTH NTAU CONTAINING THE WEIGHTS.
!       NTAU  NUMBER OF DATA POINTS TO BE FITTED (NTAU .GE. N).
!       Z     MATRIX CONTAINING M SETS OF ORDINATES TO BE FITTED.
!             Each set of NTAU ordinates is a column of Z.
!       KZ    NUMBER OF ROWS OF Z IN THE CALLING PROGRAM.
!             IT IS ASSUMED THAT KZ .GE. NTAU.
!       M     NUMBER OF SETS OF ORDINATES TO BE FITTED.
!       T     KNOT SEQUENCE OF LENGTH N+K.
!       N     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!       K     ORDER OF THE B-SPLINES.
!       KA    NUMBER OF ROWS OF A IN THE CALLING PROGRAM.
!             IT IS ASSUMED THAT KA .GE. M.
!
!     Output ...
!
!       A     MATRIX CONTAINING THE M SETS OF B-SPLINE COEFFICIENTS
!             of the L2 approximations. Each set of N coefficients
!             is a row of A.
!
!       IERR  integer reporting the status of the results ...
!
!             0  The coefficient matrix is nonsigular. The
!                unique least squares solution was obtained.
!             1  The coefficient matrix is singular. A
!                least squares solution was obtained.
!            -1  Input errors were detected.
!
!-----------------------------------------------------------------------
real, intent(in) :: tau(ntau), wgt(ntau), z(kz,m)
real, intent(in) :: t(*)
real, intent(inout) :: a(ka,n), wk(n), q(k,n)
!
if (ntau .lt. max0(2,k)) go to 100
if (tau(1) .lt. t(k) .or. tau(ntau) .gt. t(n + 1)) go to 100
!
do i = 2,ntau
   if (tau(i - 1) .gt. tau(i)) go to 100
end do
!
do j = 1,n
   do i = 1,m
      a(i,j) = 0.0
   end do
end do
!
do j = 1,n
   do i = 1,k
      q(i,j) = 0.0
   end do
end do
!
left = k
do l = 1,ntau
!
!        *** FIND THE INDEX LEFT SUCH THAT
!            T(LEFT) .LE. TAU(L) .LT. T(LEFT+1)
!
40 if (left .eq. n) go to 50
      if (tau(l) .lt. t(left+1)) go to 50
      left = left + 1
      go to 40
!
50 jj = 0
   call bspvb (t, k, k, jj, tau(l), left, wk)
!
   leftmk = left - k
   do mm = 1,k
      dw = wk(mm)*wgt(l)
      j = leftmk + mm
      do i = 1,m
         a(i,j) = dw*z(l,i) + a(i,j)
      end do
      i = 1
      do jj = mm,k
         q(i,j) = wk(jj)*dw + q(i,j)
         i = i + 1
      end do
   end do
end do
!
!        Solve the normal equations
!
call bchfac (q, k, n, wk, ierr)
call bchsv1 (q, k, n, a, ka, m)
return
!
!             Error return
!
100 ierr = -1
return
end subroutine bslsq1

subroutine bchsv1 (w, nb, n, b, kb, m)
implicit none
integer, intent(in) :: kb, m, n, nb
integer :: i, j, jmax, jpk, k, nbm1
real :: t
!-----------------------------------------------------------------------
!
!     BCHSV1 SOLVES M LINEAR SYSTEMS C*X = B  (I = 1,...,M), WHERE
!                                       I   I
!     each B  is a vector stored in the I-TH row of a matrix B.
!           I
!                       ------------------
!
!     Input ...
!
!        N   THE ORDER OF THE MATRIX C
!        NB  the bandwidth of C
!        W   THE CHOLESKY FACTORIZATION OF THE BANDED SYMMETRIC
!            positive definite matrix C obtained by the routine
!            BCHFAC.
!        B   MATRIX WHOSE ROWS ARE THE VECTORS TO BE SOLVED FOR
!            in the M linear systems of equations.
!        KB  the number of rows of B specified in the calling
!            PROGRAM. IT IS ASSUMED THAT KB .GE. M.
!        M   NUMBER OF LINEAR SYSTEMS TO BE SOLVED.
!
!     Output ...
!
!        B   MATRIX WHOSE ROWS ARE THE SOLUTIONS X  OF THE M
!            LINEAR SYSTEMS OF EQUATIONS.         I
!
!                                       T
!     NOTE.  THE FACTORIZATION C = L*D*L  IS USED, WHERE L IS A
!     unit lower triangular matrix and D a diagonal matrix.
!
!-----------------------------------------------------------------------
real, intent(in) :: w(nb,n)
real, intent(inout) :: b(kb,n)
!
if (n .gt. 1) go to 20
do i = 1,m
   b(i,1) = b(i,1)*w(1,1)
end do
return
!
!     FORWARD SUBSTITUTION. SOLVE L*Y = B FOR Y AND STORE Y IN B.
!
20 nbm1 = nb - 1
do 40 k = 1,n
   jmax = min0(nbm1,n - k)
   if (jmax .lt. 1) go to 40
   do j = 1,jmax
      jpk = j + k
      t = w(j + 1,k)
      do i = 1,m
         b(i,jpk) = b(i,jpk) - t*b(i,k)
      end do
   end do
40 continue
!                              T     -1
!     BACKSUBSTITUTION. SOLVE L X = D  Y  FOR X AND STORE X IN B.
!
k = n
50 t = w(1,k)
   do i = 1,m
      b(i,k) = t*b(i,k)
   end do
   jmax = min0(nbm1,n - k)
   if (jmax .lt. 1) go to 80
   do j = 1,jmax
      jpk = j + k
      t = w(j + 1,k)
      do i = 1,m
         b(i,k) = b(i,k) - t*b(i,jpk)
      end do
   end do
80 k = k - 1
   if (k .gt. 0) go to 50
return
end subroutine bchsv1

subroutine bval2 (a, ka, tx, nx, kx, ty, ny, ky, x0, y0, &
&idx, idy, f, wk)
implicit none
integer, intent(in) :: idx, idy, ka, kx, ky, nx, ny
real, intent(out) :: f
real, intent(in) :: x0, y0
integer :: i, iw, j, l, m
integer :: intrvl
!-----------------------------------------------------------------------
!
!                Evaluation and partial differentiation
!                      of a piecewise polynomial
!
!                            NX   NY
!                F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                           I=1  J=1   IJ  I     J
!
!     Where U  and V  are one-dimensional B-spline basis functions.
!            I      J
!-----------------------------------------------------------------------
!     REAL TX(NX + KX), TY(NY + KY), WK(KY + 3*MAX(KX,KY))
!-----------------------------
real, intent(in) :: a(ka,ny), tx(*), ty(*)
real, intent(inout) :: wk(*)
!
f = 0.0
m = nx + kx
if (x0 .lt. tx(1) .or. x0 .gt. tx(m)) return
m = ny + ky
if (y0 .lt. ty(1) .or. y0 .gt. ty(m)) return
!
iw = ky + 1
j = intrvl(y0, ty, m)
if (j .gt. ky) go to 20
!
!     CASE WHEN  J .LE. KY
!
do l = 1,j
   call bval (tx, a(1,l), nx, kx, x0, idx, wk(l), wk(iw))
end do
call bval (ty, wk(1), j, ky, y0, idy, f, wk(iw))
return
!
!     CASE WHEN  J .GT. KY
!
20 l = j - ky
do i = 1,ky
   l = l + 1
   call bval (tx, a(1,l), nx, kx, x0, idx, wk(i), wk(iw))
end do
l = j - ky + 1
call bval (ty(l), wk(1), ky, ky, y0, idy, f, wk(iw))
return
end subroutine bval2

subroutine trmesh (n,x,y, iadj,iend,ier)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: iadj(*), iend(n)
integer, intent(out) :: ier
real :: x(n), y(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine creates a thiessen triangulation of N
! arbitrarily spaced points in the plane referred to as
! nodes.  The triangulation is optimal in the sense that it
! is as nearly equiangular as possible.  TRMESH is part of
! an interpolation package which also provides subroutines
! to reorder the nodes, add a new node, delete an arc, plot
! the mesh, and print the data structure.
!   Unless the nodes are already ordered in some reasonable
! fashion, they should be reordered by subroutine reordr for
! increased efficiency before calling TRMESH.
!
! INPUT PARAMETERS -     N - NUMBER OF NODES IN THE MESH.
!                            N .GE. 3.
!
!                      X,Y - N-vectors of coordinates.
!                            (X(I),Y(I)) defines node I.
!
!                     IADJ - VECTOR OF LENGTH .GE. 6*N-9.
!
!                     IEND - VECTOR OF LENGTH .GE. N.
!
! N, X, and Y are not altered by this routine.
!
! Output parameters - IADJ - adjacency lists of neighbors in
!                            counterclockwise order.  The
!                            list for node I+1 follows that
!                            for node I where X and Y define
!                            the order.  The value 0 denotes
!                            the boundary (or a pseudo-node
!                            at infinity) and is always the
!                            last neighbor of a boundary
!                            node.  IADJ is unchanged if ier
!                            .NE. 0.
!
!                     IEND - pointers to the ends of
!                            adjacency lists (sets of
!                            neighbors) in IADJ.  The
!                            neighbors of node 1 begin in
!                            IADJ(1).  FOR K .GT. 1, THE
!                            neighbors of node K begin in
!                            IADJ(IEND(K-1)+1) and K has
!                            IEND(K) - IEND(K-1) NEIGHBORS
!                            including (possibly) the
!                            BOUNDARY.  IADJ(IEND(K)) .EQ. 0
!                            IFF node K is on the boundary.
!                            IEND IS UNCHANGED IF IER = 1.
!                            IF IER = 2 IEND CONTAINS THE
!                            indices of a sequence of N
!                            nodes ordered from left to
!                            right where left and right are
!                            defined by assuming node 1 is
!                            to the left of node 2.
!
!                      Ier - error indicator
!                            IER = 0 IF NO ERRORS WERE
!                                    encountered.
!                            IER = 1 IF N .LT. 3.
!                            IER = 2 IF N .GE. 3 AND ALL
!                                    nodes are collinear.
!
! Modules referenced by TRMESH - SHIFTD, ADNODE, TRFIND,
!                                INTADD, BDYADD, SWPTST,
!                                SWAPD, TINDX
!
!***********************************************************
!
integer :: nn, k, km1, nl, nr, ind, indx, n0, itemp, ierr, km1d2, &
&kmi, i, kmin
real :: xl, yl, xr, yr, dxr, dyr, xk, yk, dxk, dyk, cprod, sprod
!
! Local parameters -
!
! NN =          LOCAL COPY OF N
! K =           NODE (INDEX) TO BE INSERTED INTO IEND
! KM1 =         K-1 - (VARIABLE) LENGTH OF IEND
! NL,NR =       IEND(1), IEND(KM1) -- LEFTMOST AND RIGHTMOST
!                 nodes in IEND as viewed from the right of
!                 1-2 when IEND contains the initial ordered
!                 set of nodal indices
! XL,YL,XR,YR = X AND Y COORDINATES OF NL AND NR
! DXR,DYR =     XR-XL, YR-YL
! XK,YK =       X AND Y COORDINATES OF NODE K
! DXK,DYK =     XK-XL, YK-YL
! CPROD =       VECTOR CROSS PRODUCT OF NL-NR AND NL-K --
!                 used to determine the position of node K
!                 with respect to the line defined by the
!                 nodes in IEND
! SPROD =       SCALAR PRODUCT USED TO DETERMINE THE
!                 interval containing node K when K is on
!                 the line defined by the nodes in IEND
! IND,INDX =    INDICES FOR IEND AND IADJ, RESPECTIVELY
! N0,ITEMP =    TEMPORARY NODES (INDICES)
! IERR =        DUMMY PARAMETER FOR CALL TO ADNODE
! KM1D2,KMI,I = KM1/2, K-I, DO-LOOP INDEX -- USED IN IEND
!                 reordering loop
! KMIN =        FIRST NODE INDEX SENT TO ADNODE
!
nn = n
ier = 1
if (nn .lt. 3) return
ier = 0
!
! Initialize IEND, NL, NR, and K
!
iend(1) = 1
iend(2) = 2
xl = x(1)
yl = y(1)
xr = x(2)
yr = y(2)
k = 2
!
! Begin loop on nodes 3,4,...
!
1 dxr = xr-xl
dyr = yr-yl
!
! Next loop begins here if NL and NR are unchanged
!
2 if (k .eq. nn) go to 13
km1 = k
k = km1 + 1
xk = x(k)
yk = y(k)
dxk = xk-xl
dyk = yk-yl
cprod = dxr*dyk - dxk*dyr
if (cprod .gt. 0.) go to 6
if (cprod .lt. 0.) go to 8
!
! Node K lies on the line containing nodes 1,2,...,K-1.
!   Set SPROD to (NL-NR,NL-K).
!
sprod = dxr*dxk + dyr*dyk
if (sprod .gt. 0.) go to 3
!
! Node K is to the left of NL.  Insert K as the first
!   (leftmost) node in IEND and set NL to K.
!
call shiftd(1,km1,1, iend )
iend(1) = k
xl = xk
yl = yk
go to 1
!
! Node K is to the right of NL.  Find the leftmost node
!   N0 which lies to the right of K.
!   Set SPROD to (N0-NL,N0-K).
!
3 do 4 ind = 2,km1
  n0 = iend(ind)
  sprod = (xl-x(n0))*(xk-x(n0)) + &
&(yl-y(n0))*(yk-y(n0))
  if (sprod .ge. 0.) go to 5
4 continue
!
! Node K is to the right of NR.  Insert K as the last
!   (rightmost) node in IEND and set NR to K.
!
iend(k) = k
xr = xk
yr = yk
go to 1
!
! Node K lies between IEND(IND-1) and IEND(IND).  Insert K
!   IN IEND.
!
5 call shiftd(ind,km1,1, iend )
iend(ind) = k
go to 2
!
! Node K is to the left of NL-NR.  Reorder IEND so that NL
!   is the leftmost node as viewed from K.
!
6 km1d2 = km1/2
do i = 1,km1d2
  kmi = k-i
  itemp = iend(i)
  iend(i) = iend(kmi)
  iend(kmi) = itemp
  end do
!
! Node K is to the right of NL-NR.  Create a triangulation
!   consisting of nodes 1,2,...,K.
!
8 nl = iend(1)
nr = iend(km1)
!
! Create the adjacency lists for the first K-1 nodes.
!   Insert neighbors in reverse order.  Each node has four
!   neighbors except NL and NR which have three.
!
do 9 ind = 1,km1
  n0 = iend(ind)
  indx = 4*n0
  if (n0 .ge. nl) indx = indx-1
  if (n0 .ge. nr) indx = indx-1
  iadj(indx) = 0
  indx = indx-1
  if (ind .lt. km1) iadj(indx) = iend(ind+1)
  if (ind .lt. km1) indx = indx-1
  iadj(indx) = k
  if (ind .eq. 1) go to 9
  iadj(indx-1) = iend(ind-1)
9 continue
!
! Create the adjacency list for node K
!
indx = 5*km1 - 1
iadj(indx) = 0
do ind = 1,km1
  indx = indx-1
  iadj(indx) = iend(ind)
  end do
!
! Replace IEND elements with pointers to IADJ
!
indx = 0
do ind = 1,km1
  indx = indx + 4
  if (ind .eq. nl  .or.  ind .eq. nr) indx = indx-1
  iend(ind) = indx
  end do
indx = indx + k
iend(k) = indx
!
! Add the remaining nodes to the triangulation
!
if (k .eq. nn) return
kmin = k+1
do k = kmin,nn
  call adnode(k,x,y, iadj,iend, ierr)
  end do
return
!
! All nodes are collinear
!
13 ier = 2
return
end subroutine trmesh

subroutine adnode (kk,x,y, iadj,iend, ier)
implicit none
integer, intent(in) :: kk
integer, intent(inout) :: iadj(*), iend(kk)
integer, intent(out) :: ier
real :: x(kk), y(kk)
logical :: swptst
integer :: tindx
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine adds node KK to a triangulation of a set
! of points in the plane producing a new triangulation.  A
! sequence of edge swaps is then applied to the mesh,
! resulting in an optimal triangulation.  ADNODE is part
! of an interpolation package which also provides routines
! to initialize the data structure, plot the mesh, and
! delete arcs.
!
! INPUT PARAMETERS -   KK - INDEX OF THE NODE TO BE ADDED
!                           TO THE MESH.  KK .GE. 4.
!
!                     X,Y - vectors of coordinates of the
!                           nodes in the mesh.  (X(I),Y(I))
!                           DEFINES NODE I FOR I = 1,..,KK.
!
!                    IADJ - set of adjacency lists of nodes
!                           1,..,KK-1.
!
!                    IEND - pointers to the ends of
!                           adjacency lists in IADJ for
!                           each node in the mesh.
!
! IADJ and IEND may be created by TRMESH.
!
! KK, X, and Y are not altered by this routine.
!
! Output parameters - IADJ,IEND - updated with the addition
!                                 of node KK as the last
!                                 entry.
!
!                           Ier - error indicator
!                                 IER = 0 IF NO ERRORS
!                                         were encountered.
!                                 IER = 1 IF ALL NODES
!                                         (including KK) are
!                                         collinear.
!
! Modules referenced by ADNODE - TRFIND, INTADD, BDYADD,
!                                SHIFTD, TINDX, SWPTST,
!                                SWAPD
!
!***********************************************************
!
integer :: k, km1, i1, i2, i3, indkf, indkl, nabor1, io1, io2, &
&in1, indk1, ind2f, ind21
real :: xk, yk
!
! Local parameters -
!
! K =        LOCAL COPY OF KK
! KM1 =      K - 1
! I1,I2,I3 = VERTICES OF A TRIANGLE CONTAINING K
! INDKF =    IADJ INDEX OF THE FIRST NEIGHBOR OF K
! INDKL =    IADJ INDEX OF THE LAST NEIGHBOR OF K
! NABOR1 =   FIRST NEIGHBOR OF K BEFORE ANY SWAPS OCCUR
! IO1,IO2 =  ADJACENT NEIGHBORS OF K DEFINING AN ARC TO
!              be tested for a swap
! IN1 =      VERTEX OPPOSITE K -- FIRST NEIGHBOR OF IO2
!              which precedes IO1.  IN1,IO1,IO2 are in
!              counterclockwise order.
! INDK1 =    INDEX OF IO1 IN THE ADJACENCY LIST FOR K
! IND2F =    INDEX OF THE FIRST NEIGHBOR OF IO2
! IND21 =    INDEX OF IO1 IN THE ADJACENCY LIST FOR IO2
! XK,YK =    X(K), Y(K)
!
ier = 0
k = kk
!
! Initialization
!
km1 = k - 1
xk = x(k)
yk = y(k)
!
! Add node K to the mesh
!
call trfind(km1,xk,yk,x,y,iadj,iend, i1,i2,i3)
if (i1 .eq. 0) go to 5
if (i3 .eq. 0) call bdyadd(k,i1,i2, iadj,iend )
if (i3 .ne. 0) call intadd(k,i1,i2,i3, iadj,iend )
!
! Initialize variables for optimization of the mesh
!
indkf = iend(km1) + 1
indkl = iend(k)
nabor1 = iadj(indkf)
io2 = nabor1
indk1 = indkf + 1
io1 = iadj(indk1)
!
! Begin loop -- find the vertex opposite K
!
1 ind2f = 1
if (io2 .ne. 1) ind2f = iend(io2-1) + 1
ind21 = tindx(io2,io1,iadj,iend)
if (ind2f .eq. ind21) go to 2
in1 = iadj(ind21-1)
go to 3
!
! IN1 is the last neighbor of IO2
!
2 ind21 = iend(io2)
in1 = iadj(ind21)
if (in1 .eq. 0) go to 4
!
! Swap test -- if a swap occurs, two new arcs are opposite K
!              and must be tested.  INDK1 and INDKF must be
!              decremented.
!
3 if ( .not. swptst(in1,k,io1,io2,x,y) ) go to 4
call swapd (in1,k,io1,io2, iadj,iend)
io1 = in1
indk1 = indk1 - 1
indkf = indkf - 1
go to 1
!
! No swap occurred.  Reset IO2 and IO1, and test for
!   termination.
!
4 if (io1 .eq. nabor1) return
io2 = io1
indk1 = indk1 + 1
if (indk1 .gt. indkl) indk1 = indkf
io1 = iadj(indk1)
if (io1 .ne. 0) go to 1
return
!
! All nodes are collinear
!
5 ier = 1
return
end subroutine adnode

subroutine bdyadd (kk,i1,i2, iadj,iend )
implicit none
integer, intent(in) :: kk, i1, i2
integer, intent(inout) :: iadj(*), iend(kk)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine adds a boundary node to a triangulation
! of a set of KK-1 points in the plane.  IADJ and IEND are
! updated with the insertion of node KK.
!
! INPUT PARAMETERS -   KK - INDEX OF AN EXTERIOR NODE TO BE
!                           ADDED.  KK .GE. 4.
!
!                      I1 - first (rightmost as viewed from
!                           KK) boundary node in the mesh
!                           which is visible from KK - the
!                           line segment KK-I1 intersects
!                           no arcs.
!
!                      I2 - last (leftmost) boundary node
!                           which is visible from KK.
!
!                    IADJ - set of adjacency lists of nodes
!                           in the mesh.
!
!                    IEND - pointers to the ends of
!                           adjacency lists in IADJ for
!                           each node in the mesh.
!
!   IADJ and IEND may be created by TRMESH and must contain
! the vertices I1 and I2.  I1 and I2 may be determined by
! TRFIND.
!
! KK, I1, and I2 are not altered by this routine.
!
! Output parameters - IADJ,IEND - updated with the addition
!                                 of node KK as the last
!                                 entry.  Node KK will be
!                                 connected to I1, I2, and
!                                 all boundary nodes between
!                                 them.  No optimization of
!                                 the mesh is performed.
!
! Module referenced by BDYADD - SHIFTD
!
! Intrinsic functions called by BDYADD - MIN0, MAX0
!
!***********************************************************
!
integer :: k, km1, nright, nleft, nf, nl, n1, n2, i, imin, imax, &
&kend, next, indx
!
! Local parameters -
!
! K =            LOCAL COPY OF KK
! KM1 =          K - 1
! NRIGHT,NLEFT = LOCAL COPIES OF I1, I2
! NF,NL =        INDICES OF IADJ BOUNDING THE PORTION OF THE
!                  array to be shifted
! N1 =           IADJ INDEX OF THE FIRST NEIGHBOR OF NLEFT
! N2 =           IADJ INDEX OF THE LAST NEIGHBOR OF NRIGHT
! I =            DO-LOOP INDEX
! IMIN,IMAX =    BOUNDS ON DO-LOOP INDEX -- FIRST AND LAST
!                  elements of IEND to be incremented
! KEND =         POINTER TO THE LAST NEIGHBOR OF K IN IADJ
! NEXT =         NEXT BOUNDARY NODE TO BE CONNECTED TO KK
! INDX =         INDEX FOR IADJ
!
k = kk
km1 = k - 1
nright = i1
nleft = i2
!
! Initialize variables
!
nl = iend(km1)
n1 = 1
if (nleft .ne. 1) n1 = iend(nleft-1) + 1
n2 = iend(nright)
nf = max0(n1,n2)
!
! Insert K as a neighbor of MAX(NRIGHT,NLEFT)
!
call shiftd(nf,nl,2, iadj )
iadj(nf+1) = k
imin = max0(nright,nleft)
do 1 i = imin,km1
  iend(i) = iend(i) + 2
1 continue
!
! Initialize KEND and insert K as a neighbor of
!   MIN(NRIGHT,NLEFT)
!
kend = nl + 3
nl = nf - 1
nf = min0(n1,n2)
call shiftd(nf,nl,1, iadj )
iadj(nf) = k
imax = imin - 1
imin = min0(nright,nleft)
do 2 i = imin,imax
  iend(i) = iend(i) + 1
2 continue
!
! Insert NRIGHT as the first neighbor of K
!
iadj(kend) = nright
!
! Initialize INDX for loop on boundary nodes between NRIGHT
!   AND NLEFT
!
indx = iend(nright) - 2
3 next = iadj(indx)
if (next .eq. nleft) go to 4
!
! Connect next and K
!
kend = kend + 1
iadj(kend) = next
indx = iend(next)
iadj(indx) = k
indx = indx - 1
go to 3
!
! Insert NLEFT and 0 as the last neighbors of K
!
4 iadj(kend+1) = nleft
kend = kend + 2
iadj(kend) = 0
iend(k) = kend
return
end subroutine bdyadd

subroutine intadd (kk,i1,i2,i3, iadj,iend )
implicit none
integer, intent(in) :: kk, i1, i2, i3
integer, intent(inout) :: iadj(*), iend(kk)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine adds an interior node to a triangulation
! of a set of KK-1 points in the plane.  IADJ and IEND are
! updated with the insertion of node KK in the triangle
! whose vertices are I1, I2, and I3.
!
! INPUT PARAMETERS -        KK - INDEX OF NODE TO BE
!                                INSERTED.  KK .GE. 4.
!
!                     I1,I2,I3 - indices of the vertices of
!                                a triangle containing node
!                                KK -- in counterclockwise
!                                order.
!
!                         IADJ - set of adjacency lists
!                                of nodes in the mesh.
!
!                         IEND - pointers to the ends of
!                                adjacency lists in IADJ for
!                                each node in the mesh.
!
!   IADJ and IEND may be created by TRMESH and must contain
! the vertices I1, I2, and I3.  I1,I2,I3 may be determined
! BY TRFIND.
!
! KK, I1, I2, and I3 are not altered by this routine.
!
! Output parameters - IADJ,IEND - updated with the addition
!                                 of node KK as the last
!                                 entry.  Node KK will be
!                                 connected to nodes I1, I2,
!                                 and I3.  No optimization
!                                 of the mesh is performed.
!
! Module referenced by INTADD - SHIFTD
!
! Intrinsic function called by INTADD - mod
!
!***********************************************************
!
integer :: k, km1, n(3), nft(3), ip1, ip2, ip3, indx, nf, nl, n1, &
&n2, imin, imax, i, itemp
!
! Local parameters -
!
! K =           LOCAL COPY OF KK
! KM1 =         K - 1
! N =           VECTOR CONTAINING I1, I2, I3
! NFT =         POINTERS TO THE TOPS OF THE 3 SETS OF IADJ
!                 elements to be shifted downward
! IP1,IP2,IP3 = PERMUTATION INDICES FOR N AND NFT
! INDX =        INDEX FOR IADJ AND N
! NF,NL =       INDICES OF FIRST AND LAST ENTRIES IN IADJ
!                 to be shifted down
! N1,N2 =       FIRST 2 VERTICES OF A NEW TRIANGLE --
!                 (N1,N2,KK)
! IMIN,IMAX =   BOUNDS ON DO-LOOP INDEX -- FIRST AND LAST
!                 elements of IEND to be incremented
! I =           DO-LOOP INDEX
! ITEMP =       TEMPORARY STORAGE LOCATION
!
k = kk
!
! Initialization
!
n(1) = i1
n(2) = i2
n(3) = i3
!
! Set up nft
!
do 2 i = 1,3
  n1 = n(i)
  indx = mod(i,3) + 1
  n2 = n(indx)
  indx = iend(n1) + 1
!
! Find the index of N2 as a neighbor of N1
!
1 indx = indx - 1
  if (iadj(indx) .ne. n2) go to 1
  nft(i) = indx + 1
2 continue
!
! Order the vertices by decreasing magnitude.
!   N(IP(I+1)) precedes N(IP(I)) in IEND for
!   I = 1,2.
!
ip1 = 1
ip2 = 2
ip3 = 3
if ( n(2) .le. n(1) ) go to 3
ip1 = 2
ip2 = 1
3 if ( n(3) .le. n(ip1) ) go to 4
ip3 = ip1
ip1 = 3
4 if ( n(ip3) .le. n(ip2) )  go to 5
itemp = ip2
ip2 = ip3
ip3 = itemp
!
! Add node K to the adjacency lists of each vertex and
!   update IEND.  For each vertex, a set of IADJ elements
!   is shifted downward and K is inserted.  Shifting starts
!   at the end of the array.
!
5 km1 = k - 1
nl = iend(km1)
nf = nft(ip1)
if (nf .le. nl) call shiftd(nf,nl,3, iadj )
iadj(nf+2) = k
imin = n(ip1)
imax = km1
do i = imin,imax
  iend(i) = iend(i) + 3
  end do
!
nl = nf - 1
nf = nft(ip2)
call shiftd(nf,nl,2, iadj )
iadj(nf+1) = k
imax = imin - 1
imin = n(ip2)
do i = imin,imax
  iend(i) = iend(i) + 2
  end do
!
nl = nf - 1
nf = nft(ip3)
call shiftd(nf,nl,1, iadj )
iadj(nf) = k
imax = imin - 1
imin = n(ip3)
do i = imin,imax
  iend(i) = iend(i) + 1
  end do
!
! Add node K to IEND and its neighbors to IADJ
!
indx = iend(km1)
iend(k) = indx + 3
do i = 1,3
  indx = indx + 1
  iadj(indx) = n(i)
  end do
return
end subroutine intadd

subroutine shiftd (nfrst,nlast,kk, iarr )
implicit none
integer, intent(in) :: nfrst, nlast, kk
integer, intent(inout) :: iarr(*)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine shifts a set of contiguous elements of an
! INTEGER ARRAY KK POSITIONS DOWNWARD (UPWARD IF KK .LT. 0).
! The loops are unrolled in order to increase efficiency.
!
! Input parameters - NFRST,NLAST - bounds on the portion of
!                                  IARR to be shifted.  All
!                                  elements between and
!                                  including the bounds are
!                                  SHIFTED UNLESS NFRST .GT.
!                                  NLAST, in which case no
!                                  shift occurs.
!
!                             KK - number of positions each
!                                  element is to be shifted.
!                                  IF KK .LT. 0 SHIFT UP.
!                                  IF KK .GT. 0 SHIFT DOWN.
!
!                           IARR - integer array of length
!                                  .GE. NLAST + MAX(KK,0).
!
! NFRST, NLAST, and KK are not altered by this routine.
!
! OUTPUT PARAMETER -        IARR - SHIFTED ARRAY.
!
! Modules referenced by SHIFTD - none
!
!***********************************************************
!
integer :: inc, k, nf, nl, nlp1, ns, nsl, i, ibak, indx, imax
data    inc/5/
!
! Local parameters -
!
! INC =  DO-LOOP INCREMENT (UNROLLING FACTOR) -- IF INC IS
!          changed, statements must be added to or deleted
!          from the do-loops
! K =    LOCAL COPY OF KK
! NF =   LOCAL COPY OF NFRST
! NL =   LOCAL COPY OF NLAST
! NLP1 = NL + 1
! NS =   NUMBER OF SHIFTS
! NSL =  NUMBER OF SHIFTS DONE IN UNROLLED DO-LOOP (MULTIPLE
!          of inc)
! I =    DO-LOOP INDEX AND INDEX FOR IARR
! IBAK = INDEX FOR DOWNWARD SHIFT OF IARR
! INDX = INDEX FOR IARR
! IMAX = BOUND ON DO-LOOP INDEX
!
k = kk
nf = nfrst
nl = nlast
if (nf .gt. nl  .or.  k .eq. 0) return
nlp1 = nl + 1
ns = nlp1 - nf
nsl = inc*(ns/inc)
if ( k .lt. 0) go to 4
!
! Shift downward starting from the bottom
!
if (nsl .le. 0) go to 2
do 1 i = 1,nsl,inc
  ibak = nlp1 - i
  indx = ibak + k
  iarr(indx) = iarr(ibak)
  iarr(indx-1) = iarr(ibak-1)
  iarr(indx-2) = iarr(ibak-2)
  iarr(indx-3) = iarr(ibak-3)
  iarr(indx-4) = iarr(ibak-4)
1 continue
!
! Perform the remaining NS-NSL shifts one at a time
!
2 ibak = nlp1 - nsl
3 if (ibak .le. nf) return
ibak = ibak - 1
indx = ibak + k
iarr(indx) = iarr(ibak)
go to 3
!
! Shift upward starting from the top
!
4 if (nsl .le. 0) go to 6
imax = nlp1 - inc
do 5 i = nf,imax,inc
  indx = i + k
  iarr(indx) = iarr(i)
  iarr(indx+1) = iarr(i+1)
  iarr(indx+2) = iarr(i+2)
  iarr(indx+3) = iarr(i+3)
  iarr(indx+4) = iarr(i+4)
5 continue
!
! Perform the remaining NS-NSL shifts one at a time
!
6 i = nsl + nf
7 if (i .gt. nl) return
indx = i + k
iarr(indx) = iarr(i)
i = i + 1
go to 7
end subroutine shiftd

subroutine swapd (nin1,nin2,nout1,nout2, iadj,iend)
implicit none
integer, intent(in) :: nin1, nin2, nout1, nout2
integer, intent(inout) :: iadj(*), iend(*)
integer :: tindx
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This subroutine swaps the diagonals in a convex quadri-
! lateral.
!
! Input parameters -  NIN1,NIN2,NOUT1,NOUT2 - nodal indices
!                            of a pair of adjacent triangles
!                            which form a convex quadrilat-
!                            eral.  NOUT1 and NOUT2 are con-
!                            nected by an arc which is to be
!                            replaced by the arc NIN1-NIN2.
!                            (NIN1,NOUT1,NOUT2) must be TRI-
!                            angle vertices in counterclock-
!                            wise order.
!
! The above parameters are not altered by this routine.
!
!                IADJ,IEND - triangulation data structure
!                            (see subroutine TRMESH).
!
! Output parameters - IADJ,IEND - updated with the arc
!                                 replacement.
!
! Modules referenced by SWAPD - TINDX, SHIFTD
!
!***********************************************************
!
integer :: in(2), io(2), ip1, ip2, j, k, nf, nl, i, imin, imax
!
! Local parameters -
!
! IN =        NIN1 AND NIN2 ORDERED BY INCREASING MAGNITUDE
!               (the neighbors of IN(1) precede those of
!               IN(2) in IADJ)
! IO =        NOUT1 AND NOUT2 IN INCREASING ORDER
! IP1,IP2 =   PERMUTATION OF (1,2) SUCH THAT IO(IP1)
!               precedes IO(IP2) as a neighbor of IN(1)
! J,K =       PERMUTATION OF (1,2) USED AS INDICES OF IN
!               AND IO
! NF,NL =     IADJ INDICES BOUNDARY A PORTION OF THE ARRAY
!               to be shifted
! I =         IEND INDEX
! IMIN,IMAX = BOUNDS ON THE PORTION OF IEND TO BE INCRE-
!               mented or decremented
!
in(1) = nin1
in(2) = nin2
io(1) = nout1
io(2) = nout2
ip1 = 1
!
! ORDER THE INDICES SO THAT IN(1) .LT. IN(2) AND IO(1) .LT.
!   IO(2), and choose IP1 and IP2 such that (IN(1),IO(IP1),
!   IO(IP2)) forms a triangle.
!
if (in(1) .lt. in(2)) go to 1
in(1) = in(2)
in(2) = nin1
ip1 = 2
1 if (io(1) .lt. io(2)) go to 2
io(1) = io(2)
io(2) = nout1
ip1 = 3 - ip1
2 ip2 = 3 - ip1
if (io(2) .lt. in(1)) go to 8
if (in(2) .lt. io(1)) go to 12
!
! IN(1) AND IO(1) PRECEDE IN(2) AND IO(2).  FOR (J,K) =
!   (1,2) and (2,1), delete IO(K) as a neighbor of IO(J)
!   by shifting a portion of IADJ either up or down and
!   and insert IN(K) as a neighbor of IN(J).
!
do 7 j = 1,2
  k = 3 - j
  if (in(j) .gt. io(j)) go to 4
!
!   The neighbors of IN(J) precede those of IO(J) -- shift
!     down by 1
!
  nf = 1 + tindx(in(j),io(ip1),iadj,iend)
  nl = -1 + tindx(io(j),io(k),iadj,iend)
  if (nf .le. nl) call shiftd(nf,nl,1, iadj )
  iadj(nf) = in(k)
  imin = in(j)
  imax = io(j)-1
  do 3 i = imin,imax
3 iend(i) = iend(i) + 1
  go to 6
!
!   The neighbors of IO(J) precede those of IN(J) -- shift
!     up by 1
!
4 nf = 1 + tindx(io(j),io(k),iadj,iend)
  nl = -1 + tindx(in(j),io(ip2),iadj,iend)
  if (nf .le. nl) call shiftd(nf,nl,-1, iadj )
  iadj(nl) = in(k)
  imin = io(j)
  imax = in(j) - 1
  do 5 i = imin,imax
5 iend(i) = iend(i) - 1
!
!   REVERSE (IP1,IP2) FOR (J,K) = (2,1)
!
6 ip1 = ip2
  ip2 = 3 - ip1
7 continue
return
!
! The vertices are ordered (IO(1),IO(2),IN(1),IN(2)).
!   Delete IO(2) by shifting up by 1
!
8 nf = 1 + tindx(io(1),io(2),iadj,iend)
nl = -1 + tindx(io(2),io(1),iadj,iend)
if (nf .le. nl) call shiftd(nf,nl,-1, iadj )
imin = io(1)
imax = io(2)-1
do 9 i = imin,imax
9 iend(i) = iend(i) - 1
!
!   Delete IO(1) by shifting up by 2 and insert IN(2)
!
nf = nl + 2
nl = -1 + tindx(in(1),io(ip2),iadj,iend)
if (nf .le. nl) call shiftd(nf,nl,-2, iadj )
iadj(nl-1) = in(2)
imin = io(2)
imax = in(1)-1
do 10 i = imin,imax
10 iend(i) = iend(i) - 2
!
!   Shift up by 1 and insert IN(1)
!
nf = nl + 1
nl = -1 + tindx(in(2),io(ip1),iadj,iend)
call shiftd(nf,nl,-1, iadj )
iadj(nl) = in(1)
imin = in(1)
imax = in(2)-1
do 11 i = imin,imax
11 iend(i) = iend(i) - 1
return
!
! The vertices are ordered (IN(1),IN(2),IO(1),IO(2)).
!   Delete IO(1) by shifting down by 1
!
12 nf = 1 + tindx(io(1),io(2),iadj,iend)
nl = -1 + tindx(io(2),io(1),iadj,iend)
if (nf .le. nl) call shiftd(nf,nl,1, iadj )
imin = io(1)
imax = io(2) - 1
do 13 i = imin,imax
13 iend(i) = iend(i) + 1
!
!   Delete IO(2) by shifting down by 2 and insert IN(1)
!
nl = nf - 2
nf = 1 + tindx(in(2),io(ip2),iadj,iend)
if (nf .le. nl) call shiftd(nf,nl,2, iadj )
iadj(nf+1) = in(1)
imin = in(2)
imax = io(1) - 1
do 14 i = imin,imax
14 iend(i) = iend(i) + 2
!
!   Shift down by 1 and insert IN(2)
!
nl = nf - 1
nf = 1 + tindx(in(1),io(ip1),iadj,iend)
call shiftd(nf,nl,1, iadj )
iadj(nf) = in(2)
imin = in(1)
imax = in(2) - 1
do 15 i = imin,imax
15 iend(i) = iend(i) + 1
return
end subroutine swapd

logical function swptst (in1,in2,io1,io2,x,y)
implicit none
integer, intent(in) :: in1, in2, io1, io2
real, intent(in) :: x(*), y(*)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This function decides whether or not to replace A
! diagonal arc in a quadrilateral with the other diagonal.
! The determination is based on the sizes of the angles
! contained in the 2 triangles defined by the diagonal.
! The diagonal is chosen to maximize the smallest of the
! six angles over the two pairs of triangles.
!
! Input parameters -  IN1,IN2,IO1,IO2 - node indices of the
!                              four points defining the
!                              quadrilateral.  IO1 and IO2
!                              are currently connected by A
!                              diagonal arc.  This arc
!                              should be replaced by an arc
!                              connecting IN1, IN2 if the
!                              decision is made to swap.
!                              IN1,IO1,IO2 must be in
!                              counterclockwise order.
!
!                        X,Y - vectors of nodal coordinates.
!                              (X(I),Y(I)) are the coord-
!                              INATES OF NODE I FOR I = IN1,
!                              IN2, IO1, OR IO2.
!
! None of the input parameters are altered by this routine.
!
! Output parameter -  SWPTST - .True. IFF the arc connecting
!                              IO1 and IO2 is to be replaced
!
! Modules referenced by SWPTST - none
!
!***********************************************************
!
real :: dx11, dx12, dx22, dx21, dy11, dy12, dy22, dy21, sin1, &
&sin2, cos1, cos2, sin12
!
! Local parameters -
!
! DX11,DY11 = X,Y COORDINATES OF THE VECTOR IN1-IO1
! DX12,DY12 = X,Y COORDINATES OF THE VECTOR IN1-IO2
! DX22,DY22 = X,Y COORDINATES OF THE VECTOR IN2-IO2
! DX21,DY21 = X,Y COORDINATES OF THE VECTOR IN2-IO1
! SIN1 =      CROSS PRODUCT OF THE VECTORS IN1-IO1 AND
!               IN1-IO2 -- proportional to SIN(T1) where T1
!               is the angle at IN1 formed by the vectors
! COS1 =      INNER PRODUCT OF THE VECTORS IN1-IO1 AND
!               IN1-IO2 -- proportional to COS(T1)
! SIN2 =      CROSS PRODUCT OF THE VECTORS IN2-IO2 AND
!               IN2-IO1 -- proportional to SIN(T2) where T2
!               is the angle at IN2 formed by the vectors
! COS2 =      INNER PRODUCT OF THE VECTORS IN2-IO2 AND
!               IN2-IO1 -- proportional to COS(T2)
! SIN12 =     SIN1*COS2 + COS1*SIN2 -- PROPORTIONAL TO
!               SIN(T1+T2)
!
swptst = .false.
!
! Compute the vectors containing the angles T1, T2
!
dx11 = x(io1) - x(in1)
dx12 = x(io2) - x(in1)
dx22 = x(io2) - x(in2)
dx21 = x(io1) - x(in2)
!
dy11 = y(io1) - y(in1)
dy12 = y(io2) - y(in1)
dy22 = y(io2) - y(in2)
dy21 = y(io1) - y(in2)
!
! Compute inner products
!
cos1 = dx11*dx12 + dy11*dy12
cos2 = dx22*dx21 + dy22*dy21
!
! THE DIAGONALS SHOULD BE SWAPPED IFF (T1+T2) .GT. 180
!   degrees.  The following two tests insure numerical
!   stability.
!
if (cos1 .ge. 0.  .and.  cos2 .ge. 0.) return
if (cos1 .lt. 0.  .and.  cos2 .lt. 0.) go to 1
!
! Compute vector cross products
!
sin1 = dx11*dy12 - dx12*dy11
sin2 = dx22*dy21 - dx21*dy22
sin12 = sin1*cos2 + cos1*sin2
if (sin12 .ge. 0.) return
1 swptst = .true.
return
end function swptst

integer function tindx (nvertx,nabor,iadj,iend)
implicit none
integer, intent(in) :: nvertx, nabor, iadj(*), iend(*)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This function returns the index of NABOR in the
! adjacency list for NVERTX.
!
! Input parameters - NVERTX - node whose adjacency list is
!                             to be searched.
!
!                     NABOR - node whose index is to be
!                             returned.  NABOR must be
!                             connected to NVERTX.
!
!                      IADJ - set of adjacency lists.
!
!                      IEND - pointers to the ends of
!                             adjacency lists in IADJ.
!
! Input parameters are not altered by this function.
!
! OUTPUT PARAMETER -  TINDX - IADJ(TINDX) = NABOR.
!
! Modules referenced by TINDX - none
!
!***********************************************************
!
integer :: nb, indx
!
! Local parameters -
!
! NB =   LOCAL COPY OF NABOR
! INDX = INDEX FOR IADJ
!
nb = nabor
!
! Initialization
!
indx = iend(nvertx) + 1
!
! Search the list of NVERTX neighbors for NB
!
1 indx = indx - 1
if (iadj(indx) .ne. nb) go to 1
!
tindx = indx
return
end function tindx

subroutine trfind (nst,px,py,x,y,iadj,iend, i1,i2,i3)
implicit none
real :: x0, x1, x2, y0, y1, y2
integer, intent(in) :: nst, iadj(*), iend(*)
integer, intent(inout) :: i1, i2, i3
real, intent(in) :: px, py
real :: x(*), y(*)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine locates a point P in a thiessen triangu-
! lation, returning the vertex indices of a triangle which
! contains P.  TRFIND is part of an interpolation package
! which provides subroutines for creating the mesh.
!
! INPUT PARAMETERS -    NST - INDEX OF NODE AT WHICH TRFIND
!                             begins search.  Search time
!                             depends on the proximity of
!                             NST TO P.
!
!                     PX,PY - X and Y-coordinates of the
!                             point to be located.
!
!                       X,Y - vectors of coordinates of
!                             nodes in the mesh.  (X(I),Y(I))
!                             DEFINES NODE I FOR I = 1,...,N
!                             WHERE N .GE. 3.
!
!                      IADJ - set of adjacency lists of
!                             nodes in the mesh.
!
!                      IEND - pointers to the ends of
!                             adjacency lists in IADJ for
!                             each node in the mesh.
!
! IADJ and IEND may be created by TRMESH.
!
! Input parameters are not altered by this routine.
!
! Output parameters - I1,I2,I3 - vertex indices in counter-
!                                clockwise order - vertices
!                                of a triangle containing P
!                                if P is an interior node.
!                                If P is outside of the
!                                boundary of the mesh, I1
!                                and I2 are the first (right
!                                -most) and last (leftmost)
!                                nodes which are visible
!                                FROM P, AND I3 = 0.  IF P
!                                and all of the nodes lie on
!                                A SINGLE LINE THEN I1 = I2
!                                = I3 = 0.
!
! Modules referenced by TRFIND - none
!
! Intrinsic function called by TRFIND - MAX0
!
!***********************************************************
!
integer :: n0, n1, n2, n3, n4, indx, ind, nf, nl, next
real :: xp, yp
logical :: left
!
! Local parameters -
!
! XP,YP =     LOCAL VARIABLES CONTAINING PX AND PY
! N0,N1,N2 =  NODES IN COUNTERCLOCKWISE ORDER DEFINING A
!               cone (with vertex N0) containing P
! N3,N4 =     NODES OPPOSITE N1-N2 AND N2-N1, RESPECTIVELY
! INDX,IND =  INDICES FOR IADJ
! NF,NL =     FIRST AND LAST NEIGHBORS OF N0 IN IADJ, OR
!               first (rightmost) and last (leftmost) nodes
!               visible from P when P is outside the
!               boundary
! NEXT =      CANDIDATE FOR I1 OR I2 WHEN P IS OUTSIDE OF
!               the boundary
! LEFT =      STATEMENT FUNCTION WHICH COMPUTES THE SIGN OF
!               a cross product (Z-COMPONENT).  Left(X1,...,
!               Y0) = .TRUE. IFF (X0,Y0) IS ON OR TO THE
!               left of the vector from (X1,Y1) to (X2,Y2).
!
left(x1,y1,x2,y2,x0,y0) = (x2-x1)*(y0-y1) .ge. &
&(x0-x1)*(y2-y1)
xp = px
yp = py
!
! Initialize variables and find a cone containing P
!
n0 = max0(nst,1)
1 indx = iend(n0)
nl = iadj(indx)
indx = 1
if (n0 .ne. 1) indx = iend(n0-1) + 1
nf = iadj(indx)
n1 = nf
if (nl .ne. 0) go to 3
!
! N0 is a boundary node.  Set NL to the last nonzero
!   neighbor of N0.
!
ind = iend(n0) - 1
nl = iadj(ind)
if ( left(x(n0),y(n0),x(nf),y(nf),xp,yp) ) go to 2
!
! P is outside the boundary
!
nl = n0
go to 16
2 if ( left(x(nl),y(nl),x(n0),y(n0),xp,yp) ) go to 4
!
! P is outside the boundary and N0 is the rightmost
!   visible boundary node
!
i1 = n0
go to 18
!
! N0 is an interior node.  Find N1.
!
3 if ( left(x(n0),y(n0),x(n1),y(n1),xp,yp) ) go to 4
indx = indx + 1
n1 = iadj(indx)
if (n1 .eq. nl) go to 7
go to 3
!
! P is to the left of arc N0-N1.  Initialize N2 to the next
!   neighbor of N0.
!
4 indx = indx + 1
n2 = iadj(indx)
if ( .not. left(x(n0),y(n0),x(n2),y(n2),xp,yp) ) &
&go to 8
n1 = n2
if (n1 .ne. nl) go to 4
if ( .not. left(x(n0),y(n0),x(nf),y(nf),xp,yp) ) &
&go to 7
if (xp .eq. x(n0) .and. yp .eq. y(n0)) go to 6
!
! P is left of or on arcs N0-NB for all neighbors NB
!   OF N0.
! All points are collinear IFF P is left of NB-N0 for
!   all neighbors NB of N0.  Search the neighbors of N0
!   IN REVERSE ORDER.  NOTE -- N1 = NL AND INDX POINTS TO
!   NL.
!
5 if ( .not. left(x(n1),y(n1),x(n0),y(n0),xp,yp) ) &
&go to 6
if (n1 .eq. nf) go to 20
indx = indx - 1
n1 = iadj(indx)
go to 5
!
! P IS TO THE RIGHT OF N1-N0, OR P=N0.  SET N0 TO N1 AND
!   start over.
!
6 n0 = n1
go to 1
!
! P is between arcs N0-N1 and N0-NF
!
7 n2 = nf
!
! P is contained in a cone defined by line segments N0-N1
!   and N0-N2 where N1 is adjacent to N2
!
8 n3 = n0
9 if ( left(x(n1),y(n1),x(n2),y(n2),xp,yp) ) go to 13
!
! Set N4 to the first neighbor of N2 following N1
!
indx = iend(n2)
if (iadj(indx) .ne. n1) go to 10
!
! N1 is the last neighbor of N2.
! Set N4 to the first neighbor.
!
indx = 1
if (n2 .ne. 1) indx = iend(n2-1) + 1
n4 = iadj(indx)
go to 11
!
! N1 is not the last neighbor of N2
!
10 indx = indx-1
if (iadj(indx) .ne. n1) go to 10
n4 = iadj(indx+1)
if (n4 .ne. 0) go to 11
!
! P is outside the boundary
!
nf = n2
nl = n1
go to 16
!
! Define a new arc N1-N2 which intersects the line
!   SEGMENT N0-P
!
11 if ( left(x(n0),y(n0),x(n4),y(n4),xp,yp) ) go to 12
n3 = n2
n2 = n4
go to 9
12 n3 = n1
n1 = n4
go to 9
!
! P is in the triangle (N1,N2,N3) and not on N2-N3.  If
!   N3-N1 or N1-N2 is a boundary arc containing P, treat P
!   as exterior.
!
13 indx = iend(n1)
if (iadj(indx) .ne. 0) go to 15
!
! N1 is a boundary node.  N3-N1 is a boundary arc IFF N3
!   is the last nonzero neighbor of N1.
!
if (n3 .ne. iadj(indx-1)) go to 14
!
! N3-N1 is a boundary arc
!
if ( .not. left(x(n1),y(n1),x(n3),y(n3),xp,yp) ) &
&go to 14
!
! P lies on N1-N3
!
i1 = n1
i2 = n3
i3 = 0
return
!
! N3-N1 is not a boundary arc containing P.  N1-N2 is A
!   boundary arc IFF N2 is the first neighbor of N1.
!
14 indx = 1
if (n1 .ne. 1) indx = iend(n1-1) + 1
if (n2 .ne. iadj(indx)) go to 15
!
! N1-N2 is a boundary arc
!
if ( .not. left(x(n2),y(n2),x(n1),y(n1),xp,yp) ) &
&go to 15
!
! P lies on N1-N2
!
i1 = n2
i2 = n1
i3 = 0
return
!
! P does not lie on a boundary arc.
!
15 i1 = n1
i2 = n2
i3 = n3
return
!
! NF and NL are adjacent boundary nodes which are visible
!   from P.  Find the first visible boundary node.
! Set next to the first neighbor of NF.
!
16 indx = 1
if (nf .ne. 1) indx = iend(nf-1) + 1
next = iadj(indx)
if ( left(x(nf),y(nf),x(next),y(next),xp,yp) ) &
&go to 17
nf = next
go to 16
!
! NF is the first (rightmost) visible boundary node
!
17 i1 = nf
!
! Find the last visible boundary node.  NL is the first
!   candidate for I2.
! Set next to the last neighbor of NL.
!
18 indx = iend(nl) - 1
next = iadj(indx)
if ( left(x(next),y(next),x(nl),y(nl),xp,yp) ) &
&go to 19
nl = next
go to 18
!
! NL is the last (leftmost) visible boundary node
!
19 i2 = nl
i3 = 0
return
!
! All points are collinear
!
20 i1 = 0
i2 = 0
i3 = 0
return
end subroutine trfind

subroutine gradg (n, x, y, z, iadj, iend, zxzy, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer :: j, miter
real :: eps
!-----------------------------------------------------------------------
!                      Derivative estimation
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: zxzy(2,n)
integer, intent(in) :: iadj(*), iend(n)
!
if (n .lt. 3) go to 20
!
eps = 0.0
miter = 5
do j = 1,n
   zxzy(1,j) = 0.0
   zxzy(2,j) = 0.0
end do
call gradg1 (n, x, y, z, iadj, iend, eps, miter, zxzy, ierr)
ierr = 0
return
!
!     Error return
!
20 ierr = 1
return
end subroutine gradg

subroutine gradg1 (n,x,y,z,iadj,iend,eps, nit, &
&zxzy, ier)
implicit none
integer, intent(in) :: n, iadj(*), iend(n)
integer, intent(inout) :: nit, ier
real, intent(in) :: x(n), y(n), z(n), eps
real, intent(inout) :: zxzy(2,n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   Given a triangulation of N nodes in the plane with
! associated data values, this routine uses a global method
! to compute estimated gradients at the nodes.  The method
! consists of minimizing a quadratic functional Q(G) over
! the N-vector G of gradients where Q approximates the lin-
! earized curvature of an interpolant F over the triangula-
! tion.  The restriction of F to an arc of the triangulation
! is taken to be the Hermite cubic interpolant of the data
! values and tangential gradient components at the end-
! points of the arc, and Q is the sum of the linearized
! curvatures of F along the arcs -- the integrals over the
! ARCS OF D2F(T)**2 WHERE D2F(T) IS THE SECOND DERIVATIVE
! of F with respect to distance T along the arc.  This min-
! imization problem corresponds to an order 2N symmetric
! positive-definite sparse linear system which is solved for
! the X and Y partial derivatives by the block Gauss-Seidel
! method with 2 by 2 blocks.
!   An alternative method, subroutine GRADL, computes A
! local approximation to the partials at a single node and
! may be more accurate, depending on the data values and
! distribution of nodes (neither method emerged as superior
! in tests for accuracy).  However, in tests run on an IBM
! 370, GRADG1 was found to be about 3.6 times as fast for
! NIT = 4.
!
! INPUT PARAMETERS - N - NUMBER OF NODES.  N .GE. 3.
!
!                  X,Y - cartesian coordinates of the nodes.
!
!                    Z - data values at the nodes.  Z(I) is
!                        associated with (X(I),Y(I)).
!
!            IADJ,IEND - data structure defining the trian-
!                        gulation.  See subroutine TRMESH.
!
!                  Eps - nonnegative convergence criterion.
!                        The method is terminated when the
!                        maximum change in a gradient compo-
!                        nent between iterations is at most
!                        EPS.  EPS = 1.E-2 IS SUFFICIENT FOR
!                        effective convergence.
!
! The above parameters are not altered by this routine.
!
!                  Nit - maximum number of Gauss-Seidel
!                        iterations to be applied.  This
!                        maximum will likely be achieved if
!                        eps is smaller than the machine
!                        precision.  Optimal efficiency was
!                        ACHIEVED IN TESTING WITH EPS = 0
!                        AND NIT = 3 OR 4.
!
!                 ZXZY - 2 by N array whose columns contain
!                        initial estimates of the partial
!                        derivatives (zero vectors are
!                        sufficient).
!
! Output parameters - nit - number of Gauss-Seidel itera-
!                           TIONS EMPLOYED.
!
!                    ZXZY - estimated X and Y partial deriv-
!                           atives at the nodes with X par-
!                           tials in the first row.  ZXZY is
!                           NOT CHANGED IF IER = 2.
!
!                     Ier - error indicator
!                           IER = 0 IF THE CONVERGENCE CRI-
!                                   terion was achieved.
!                           IER = 1 IF CONVERGENCE WAS NOT
!                                   achieved within nit
!                                   iterations.
!                           IER = 2 IF N OR EPS IS OUT OF
!                                   RANGE OR NIT .LT. 0 ON
!                                   input.
!
! Modules referenced by GRADG1 - none
!
! Intrinsic functions called by GRADG1 - sqrt, AMAX1, abs
!
!***********************************************************
!
integer :: nn, maxit, iter, k, indf, indl, indx, nb
real :: tol, dgmax, xk, yk, zk, zxk, zyk, a11, a12, a22, r1, r2, &
&delx, dely, delxs, delys, dsq, dcub, t, dzx, dzy
!
! Local parameters -
!
! NN =          LOCAL COPY OF N
! MAXIT =       INPUT VALUE OF NIT
! ITER =        NUMBER OF ITERATIONS USED
! K =           DO-LOOP AND NODE INDEX
! INDF,INDL =   IADJ INDICES OF THE FIRST AND LAST NEIGHBORS
!                 OF K
! INDX =        IADJ INDEX IN THE RANGE INDF,...,INDL
! NB =          NEIGHBOR OF K
! TOL =         LOCAL COPY OF EPS
! DGMAX =       MAXIMUM CHANGE IN A GRADIENT COMPONENT BE-
!                 tween iterations
! XK,YK,ZK =    X(K), Y(K), Z(K)
! ZXK,ZYK =     INITIAL VALUES OF ZXZY(1,K) AND ZXZY(2,K)
! A11,A12,A22 = MATRIX COMPONENTS OF THE 2 BY 2 BLOCK A*DG
!                 = R WHERE A IS SYMMETRIC, DG = (DZX,DZY)
!                 is the change in the gradient at K, and R
!                 is the residual
! R1,R2 =       COMPONENTS OF THE RESIDUAL -- DERIVATIVES OF
!                 Q with respect to the components of the
!                 gradient at node K
! DELX,DELY =   COMPONENTS OF THE ARC NB-K
! DELXS,DELYS = DELX**2, DELY**2
! DSQ =         SQUARE OF THE DISTANCE D BETWEEN K AND NB
! DCUB =        D**3
! T =           FACTOR OF R1 AND R2
! DZX,DZY =     SOLUTION OF THE 2 BY 2 SYSTEM -- CHANGE IN
!                 derivatives at K from the previous iterate
!
nn = n
tol = eps
maxit = nit
!
! Error checks and initialization
!
if (nn .lt. 3  .or.  tol .lt. 0.  .or.  maxit .lt. 0) &
&go to 5
iter = 0
!
! Top of iteration loop
!
1 if (iter .eq. maxit) go to 4
dgmax = 0.
indl = 0
do 3 k = 1,nn
  xk = x(k)
  yk = y(k)
  zk = z(k)
  zxk = zxzy(1,k)
  zyk = zxzy(2,k)
!
!   Initialize components of the 2 by 2 system
!
  a11 = 0.
  a12 = 0.
  a22 = 0.
  r1 = 0.
  r2 = 0.
!
!   Loop on neighbors NB of K
!
  indf = indl + 1
  indl = iend(k)
  do 2 indx = indf,indl
    nb = iadj(indx)
    if (nb .eq. 0) go to 2
!
!   Compute the components of arc NB-K
!
    delx = x(nb) - xk
    dely = y(nb) - yk
    delxs = delx*delx
    delys = dely*dely
    dsq = delxs + delys
    dcub = dsq*sqrt(dsq)
!
!   Update the system components for node NB
!
    a11 = a11 + delxs/dcub
    a12 = a12 + delx*dely/dcub
    a22 = a22 + delys/dcub
    t = ( 1.5*(z(nb)-zk) - ((zxzy(1,nb)/2.+zxk)*delx + &
&(zxzy(2,nb)/2.+zyk)*dely) )/dcub
    r1 = r1 + t*delx
    r2 = r2 + t*dely
2 continue
!
!   Solve the 2 by 2 system and update DGMAX
!
  dzy = (a11*r2 - a12*r1)/(a11*a22 - a12*a12)
  dzx = (r1 - a12*dzy)/a11
  dgmax = amax1(dgmax,abs(dzx),abs(dzy))
!
!   Update the partials at node K
!
  zxzy(1,k) = zxk + dzx
3 zxzy(2,k) = zyk + dzy
!
!   Increment iter and test for convergence
!
iter = iter + 1
if (dgmax .gt. tol) go to 1
!
! Method converged
!
nit = iter
ier = 0
return
!
! Method failed to converge within nit iterations
!
4 ier = 1
return
!
! Parameter OUT of range
!
5 nit = 0
ier = 2
return
end subroutine gradg1

subroutine gradl (n, x, y, z, iadj, iend, zxzy, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer :: j
!-----------------------------------------------------------------------
!                      Derivative estimation
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: zxzy(2,n)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
!
if (n .lt. 3) go to 20
!
do j = 1,n
   call gradl1 (n, j, x, y, z, iadj, iend, zxzy(1,j), &
&zxzy(2,j), ierr)
   if (ierr .lt. 0) go to 30
end do
ierr = 0
return
!
!     Error return
!
20 ierr = 1
return
!
30 ierr = 2
return
end subroutine gradl

subroutine gradl1 (n,k,x,y,z,iadj,iend, dx,dy,ier)
implicit none
integer, intent(in) :: n, k, iadj(*)
integer, intent(inout) :: iend(n), ier
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: dx, dy
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   Given a thiessen triangulation of N points in the plane
! with associated data values Z, this subroutine estimates
! X and Y partial derivatives at node K.  The derivatives
! are taken to be the partials at K of a quadratic function
! which interpolates Z(K) and fits the data values at a set
! of nearby nodes in a weighted least squares sense. A mar-
! quardt stabilization factor is used if necessary to ensure
! a well-conditioned system and a linear fitting function is
! USED IF N .LT. 6.  THUS, A UNIQUE SOLUTION EXISTS UNLESS
! the nodes are collinear.
!   An alternative routine, GRADG, employs a global method
! to compute the partial derivatives at all of the nodes at
! once.  That method is more efficient (when all partials
! are needed) and may be more accurate, depending on the
! data.
!
! Input parameters - N - number of nodes in the triangula-
!                        TION.  N .GE. 3.
!
!                    K - node at which derivatives are
!                        SOUGHT.  1 .LE. K .LE. N.
!
!                  X,Y - N-vectors containing the cartesian
!                        coordinates of the nodes.
!
!                    Z - N-vector containing the data values
!                        associated with the nodes.
!
!                 IADJ - set of adjacency lists.
!
!                 IEND - pointers to the ends of adjacency
!                        lists for each node.
!
! IADJ and IEND may be created by subroutine TRMESH.
!
! Input parameters are not altered by this routine.
!
! Output parameters - DX,DY - estimated partial derivatives
!                             AT NODE K UNLESS IER .LT. 0.
!
!                       Ier - error indicator
!                             IER .GT. 0 IF NO ERRORS WERE
!                                      encountered.  Ier
!                                      contains the number
!                                      of nodes (including
!                                      K) used in the fit.
!                                      IER = 3, 4, OR 5 IM-
!                                      plies a linear fit.
!                             IER = -1 IF N OR K IS OUT OF
!                                      range.
!                             IER = -2 IF ALL NODES ARE
!                                      collinear.
!
! Modules referenced by GRADL1 - GETNP, SETRM, SROTG, SROT
!
! Intrinsic functions called by GRADL1 - MIN0, float, sqrt,
!                                       AMIN1, ABS
!
!***********************************************************
!
integer :: nn, kk, lmn, lmx, lmin, lmax, lm1, lnp, npts(30), ierr, &
&np, i, j, im1, jp1, ip1, l
real :: sum, ds, r, rs, rtol, avsq, av, xk, yk, zk, a(6,6), c, s, &
&dmin, dtol, sf
data    lmn/10/
data    lmx/30/, rtol/1.e-5/, dtol/.01/, sf/1./
!
! Local parameters -
!
! NN,KK =     LOCAL COPIES OF N AND K
! LMN,LMX =   MINIMUM AND MAXIMUM VALUES OF LNP FOR N
!               sufficiently large.  In most cases LMN-1
!               NODES ARE USED IN THE FIT.  4 .LE. LMN .LE.
!               LMX.
! LMIN,LMAX = MIN(LMN,N), MIN(LMX,N)
! LM1 =       LMIN-1 OR LNP-1
! LNP =       LENGTH OF NPTS
! NPTS =      ARRAY CONTAINING THE INDICES OF A SEQUENCE OF
!               NODES ORDERED BY DISTANCE FROM K.  NPTS(1)=K
!               and the first LNP-1 elements of NPTS are
!               used in the least squares fit.  Unless LNP
!               exceeds LMAX, NPTS(LNP) determines R.
! IERR =      ERROR FLAG FOR CALLS TO GETNP (NOT CHECKED)
! NP =        ELEMENT OF NPTS TO BE ADDED TO THE SYSTEM
! I,J =       DO-LOOP INDICES
! IM1,JP1 =   I-1, J+1
! IP1 =       I+1
! L =         NUMBER OF COLUMNS OF A**T TO WHICH A ROTATION
!               is applied
! SUM =       SUM OF SQUARED EUCLIDEAN DISTANCES BETWEEN
!               node K and the nodes used in the least
!               squares fit
! DS =        SQUARED DISTANCE BETWEEN NODE K AND AN ELE-
!               MENT OF NPTS
! R =         DISTANCE BETWEEN NODE K AND NPTS(LNP) OR SOME
!               point further from K than NPTS(LMAX) if
!               NPTS(LMAX) is used in the fit.  R is A
!               radius of influence which enters into the
!               weights (see subroutine SETRM).
! RS =        R*R
! RTOL =      TOLERANCE FOR DETERMINING R.  IF THE RELATIVE
!               change in DS between two elements of NPTS is
!               not greater than RTOL they are treated as
!               being the same distance from node K
! AVSQ =      AV*AV
! AV =        ROOT-MEAN-SQUARE DISTANCE BETWEEN K AND THE
!               nodes (other than K) in the least squares
!               fit.  The first 3 columns of the system are
!               scaled by 1/AVSQ, the next 2 by 1/AV.
! XK,YK,ZK =  COORDINATES AND DATA VALUE ASSOCIATED WITH K
! A =         TRANSPOSE OF THE AUGMENTED REGRESSION MATRIX
! C,S =       COMPONENTS OF THE PLANE ROTATION DETERMINED
!               by subroutine SROTG
! DMIN =      MINIMUM OF THE MAGNITUDES OF THE DIAGONAL
!               elements of the regression matrix after
!               zeros are introduced below the diagonal
! DTOL =      TOLERANCE FOR DETECTING AN ILL-CONDITIONED
!               system.  The system is accepted when DMIN
!               .GE. DTOL
! SF =        MARQUARDT STABILIZATION FACTOR USED TO DAMP
!               out the first 3 solution components (second
!               partials of the quadratic) when the system
!               is ill-conditioned.  As SF increases, the
!               fitting function approaches a linear
!
nn = n
kk = k
!
! Check for errors and initialize LMIN, LMAX
!
if (nn .lt. 3  .or.  kk .lt. 1  .or.  kk .gt. nn) &
&go to 16
lmin = min0(lmn,nn)
lmax = min0(lmx,nn)
!
! Compute NPTS, LNP, AVSQ, AV, and R.
!   Set NPTS to the closest LMIN-1 nodes to K.
!
sum = 0.
npts(1) = kk
lm1 = lmin - 1
do 1 lnp = 2,lm1
  call getnp (x,y,iadj,iend,lnp, npts, ds,ierr)
1 sum = sum + ds
!
! Add additional nodes to NPTS until the relative increase
!   in DS is at least RTOL.
!
do 2 lnp = lmin,lmax
  call getnp (x,y,iadj,iend,lnp, npts, rs,ierr)
  if ((rs-ds)/ds .le. rtol) go to 2
  if (lnp .gt. 6) go to 3
2 sum = sum + rs
!
! Use all LMAX nodes in the least squares fit.  RS is
!   arbitrarily increased by 10 per cent.
!
rs = 1.1*rs
lnp = lmax + 1
!
! There are LNP-2 equations corresponding to nodes NPTS(2),
!   ...,NPTS(LNP-1).
!
3 avsq = sum/float(lnp-2)
av = sqrt(avsq)
r = sqrt(rs)
xk = x(kk)
yk = y(kk)
zk = z(kk)
if (lnp .lt. 7) go to 12
!
! Set up the first 5 equations of the augmented regression
!   matrix (transposed) as the columns of A, and zero out
!   the lower triangle (upper triangle of A) with Givens
!   rotations
!
do 5 i = 1,5
  np = npts(i+1)
  call setrm (xk,yk,zk,x(np),y(np),z(np),av,avsq, &
&r, a(1,i))
  if (i .eq. 1) go to 5
  im1 = i - 1
  do 4 j = 1,im1
    jp1 = j + 1
    l = 6 - j
    call srotg (a(j,j),a(j,i),c,s)
4 call srot (l,a(jp1,j),1,a(jp1,i),1,c,s)
5 continue
!
! Add the additional equations to the system using
!   THE LAST COLUMN OF A -- I .LE. LNP.
!
i = 7
6 if (i .eq. lnp) go to 8
  np = npts(i)
  call setrm (xk,yk,zk,x(np),y(np),z(np),av,avsq, &
&r, a(1,6))
  do 7 j = 1,5
    jp1 = j + 1
    l = 6 - j
    call srotg (a(j,j),a(j,6),c,s)
7 call srot (l,a(jp1,j),1,a(jp1,6),1,c,s)
  i = i + 1
  go to 6
!
! Test the system for ill-conditioning
!
8 dmin = amin1( abs(a(1,1)),abs(a(2,2)),abs(a(3,3)), &
&abs(a(4,4)),abs(a(5,5)) )
if (dmin .ge. dtol) go to 15
if (lnp .gt. lmax) go to 9
!
! Add another node to the system and increase R --
!   I .EQ. LNP
!
lnp = lnp + 1
if (lnp .le. lmax) call getnp (x,y,iadj,iend,lnp, &
&npts, rs,ierr)
r = sqrt(1.1*rs)
go to 6
!
! Stabilize the system by damping second partials --add
!   multiples of the first three unit vectors to the first
!   three equations.
!
9 do 11 i = 1,3
  a(i,6) = sf
  ip1 = i + 1
  do 10 j = ip1,6
10 a(j,6) = 0.
  do 11 j = i,5
    jp1 = j + 1
    l = 6 - j
    call srotg (a(j,j),a(j,6),c,s)
11 call srot (l,a(jp1,j),1,a(jp1,6),1,c,s)
go to 14
!
! 4 .LE. LNP .LE. 6 (2, 3, OR 4 EQUATIONS) -- FIT A PLANE TO
!   the data using the last 3 columns of A.
!
12 np = npts(2)
call setrm (xk,yk,zk,x(np),y(np),z(np),av,avsq, &
&r, a(1,4))
np = npts(3)
call setrm (xk,yk,zk,x(np),y(np),z(np),av,avsq, &
&r, a(1,5))
call srotg (a(4,4),a(4,5),c,s)
call srot (2,a(5,4),1,a(5,5),1,c,s)
if (lnp .eq. 4) go to 14
!
lm1 = lnp - 1
do 13 i = 4,lm1
  np = npts(i)
  call setrm (xk,yk,zk,x(np),y(np),z(np),av,avsq, &
&r, a(1,6))
  call srotg (a(4,4),a(4,6),c,s)
  call srot (2,a(5,4),1,a(5,6),1,c,s)
  call srotg (a(5,5),a(5,6),c,s)
13 call srot (1,a(6,5),1,a(6,6),1,c,s)
!
! Test the linear fit for ill-conditioning
!
14 dmin = amin1( abs(a(4,4)),abs(a(5,5)) )
if (dmin .lt. dtol) go to 17
!
! Solve the 2 by 2 triangular system for the derivatives
!
15 dy = a(6,5)/a(5,5)
dx = (a(6,4) - a(5,4)*dy)/a(4,4)/av
dy = dy/av
ier = lnp - 1
return
!
! N or K is out of range
!
16 ier = -1
return
!
! No unique solution due to collinear nodes
!
17 ier = -2
return
end subroutine gradl1

subroutine setrm (xk,yk,zk,xi,yi,zi,s1,s2,r, row)
implicit none
real, intent(in) :: xk, yk, zk, xi, yi, zi, s1, s2, r
real, intent(inout) :: row(6)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   This routine sets up the I-TH row of an augmented RE-
! gression matrix for a weighted least-squares fit of A
! quadratic function Q(X,Y) to a set of data values Z where
! Q(XK,YK) = ZK.  THE FIRST 3 COLUMNS (QUADRATIC TERMS) ARE
! scaled by 1/S2 and the fourth and fifth columns (linear
! terms) are scaled by 1/S1.  The weight is (R-D)/(R*D) if
! R .GT. D AND 0 IF R .LE. D, WHERE D IS THE DISTANCE
! between nodes I and K.
!
! Input parameters - XK,YK,ZK - coordinates and data value
!                               at node K -- interpolated
!                               BY Q.
!
!                    Xi,YI,ZI - coordinates and data value
!                               at node I.
!
!                       S1,S2 - inverse scale factors.
!
!                           R - radius of influence about
!                               node K defining the weight.
!
!                         Row - vector of length 6.
!
! Input parameters are not altered by this routine.
!
! Output parameter - row - vector containing a row of the
!                          augmented regression matrix.
!
! Modules referenced by SETRM - none
!
! Intrinsic function called by SETRM - sqrt
!
!***********************************************************
!
integer :: i
real :: dx, dy, dxsq, dysq, d, w, w1, w2
!
! Local parameters -
!
! I =    DO-LOOP INDEX
! DX =   XI - XK
! DY =   YI - YK
! DXSQ = DX*DX
! DYSQ = DY*DY
! D =    DISTANCE BETWEEN NODES K AND I
! W =    WEIGHT ASSOCIATED WITH THE ROW
! W1 =   W/S1
! W2 =   W/S2
!
dx = xi - xk
dy = yi - yk
dxsq = dx*dx
dysq = dy*dy
d = sqrt(dxsq + dysq)
if (d .le. 0.  .or.  d .ge. r) go to 1
w = (r-d)/r/d
w1 = w/s1
w2 = w/s2
row(1) = dxsq*w2
row(2) = dx*dy*w2
row(3) = dysq*w2
row(4) = dx*w1
row(5) = dy*w1
row(6) = (zi - zk)*w
return
!
! Nodes K and I coincide or node I is outside of the radius
!   of influence.  Set row to the zero vector.
!
1 do 2 i = 1,6
2 row(i) = 0.
return
end subroutine setrm

subroutine getnp (x,y,iadj,iend,l, npts, ds,ier)
implicit none
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(*)
integer, intent(in) :: l
integer, intent(inout) :: npts(l), ier
real, intent(in) :: x(*), y(*)
real, intent(inout) :: ds
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   Given a thiessen triangulation of N nodes and an array
! NPTS containing the indices of L-1 nodes ordered by
! Euclidean distance from NPTS(1), this subroutine sets
! NPTS(L) to the index of the next node in the sequence --
! the node, other than NPTS(1),...,NPTS(L-1), which is
! closest to NPTS(1).  Thus, the ordered sequence of K
! closest nodes to N1 (including N1) may be determined by
! K-1 CALLS TO GETNP WITH NPTS(1) = N1 AND L = 2,3,...,K
! FOR K .GE. 2.
!   The algorithm uses the fact that, in a thiessen trian-
! gulation, the K-TH closest node to a given node N1 is A
! neighbor of one of the K-1 closest nodes to N1.
!
! Input parameters - X,Y - vectors of length N containing
!                          the cartesian coordinates of the
!                          nodes.
!
!                   IADJ - set of adjacency lists of nodes
!                          in the triangulation.
!
!                   IEND - pointers to the ends of adjacency
!                          lists for each node in the TRI-
!                          angulation.
!
!                      L - number of nodes in the sequence
!                          ON OUTPUT.  2 .LE. L .LE. N.
!
!                   NPTS - ARRAY OF LENGTH .GE. L CONTAIN-
!                          ing the indices of the L-1 clos-
!                          est nodes to NPTS(1) in the first
!                          L-1 LOCATIONS.
!
! IADJ and IEND may be created by subroutine TRMESH.
!
! Input parameters other than NPTS are not altered by this
!   routine.
!
! Output parameters - NPTS - updated with the index of the
!                            L-TH closest node to NPTS(1) in
!                            POSITION L UNLESS IER = 1.
!
!                       DS - squared Euclidean distance be-
!                            tween NPTS(1) and NPTS(L)
!                            UNLESS IER = 1.
!
!                      Ier - error indicator
!                            IER = 0 IF NO ERRORS WERE EN-
!                                    countered.
!                            IER = 1 IF L IS OUT OF RANGE.
!
! Modules referenced by GETNP - none
!
! Intrinsic function called by GETNP - IABS
!
!***********************************************************
!
integer :: lm1, n1, i, ni, np, indf, indl, indx, nb
real :: x1, y1, dnp, dnb
!
! Local parameters -
!
! LM1 =     L - 1
! N1 =      NPTS(1)
! I =       NPTS INDEX AND DO-LOOP INDEX
! NI =      NPTS(I)
! NP =      CANDIDATE FOR NPTS(L)
! INDF =    IADJ INDEX OF THE FIRST NEIGHBOR OF NI
! INDL =    IADJ INDEX OF THE LAST NEIGHBOR OF NI
! INDX =    IADJ INDEX IN THE RANGE INDF,...,INDL
! NB =      NEIGHBOR OF NI AND CANDIDATE FOR NP
! X1,Y1 =   COORDINATES OF N1
! DNP,DNB = SQUARED DISTANCES FROM N1 TO NP AND NB,
!             respectively
!
lm1 = l - 1
if (lm1 .lt. 1) go to 4
ier = 0
n1 = npts(1)
x1 = x(n1)
y1 = y(n1)
!
! Mark the elements of NPTS
!
do 1 i = 1,lm1
  ni = npts(i)
  iend(ni) = -iend(ni)
1 continue
!
! CANDIDATES FOR NP = NPTS(L) ARE THE UNMARKED NEIGHBORS
!   OF NODES IN NPTS.  NP=0 IS A FLAG TO SET NP TO THE
!   first candidate encountered.
!
np = 0
dnp = 0.
!
! Loop on nodes NI in NPTS
!
do 2 i = 1,lm1
  ni = npts(i)
  indf = 1
  if (ni .gt. 1) indf = iabs(iend(ni-1)) + 1
  indl = -iend(ni)
!
! Loop on neighbors NB of NI
!
  do 2 indx = indf,indl
    nb = iadj(indx)
    if (nb .eq. 0  .or.  iend(nb) .lt. 0) go to 2
!
! NB is an unmarked neighbor of NI.  Replace NP if NB is
!   closer to N1 or is the first candidate encountered.
!
    dnb = (x(nb)-x1)**2 + (y(nb)-y1)**2
    if (np .ne. 0  .and.  dnb .ge. dnp) go to 2
    np = nb
    dnp = dnb
2 continue
npts(l) = np
ds = dnp
!
! Unmark the elements of NPTS
!
do i = 1,lm1
  ni = npts(i)
  iend(ni) = -iend(ni)
  end do
return
!
! L is out of range
!
4 ier = 1
return
end subroutine getnp

subroutine sfval (n, x, y, z, m, xi, yi, zi, iadj, iend, &
&zxzy, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
integer :: ist, j
!-----------------------------------------------------------------------
!                    Evaluation of the surface
!-----------------------------------------------------------------------
real :: x(n), y(n)
real, intent(in) :: z(n), xi(m), yi(m)
real, intent(inout) :: zi(m)
real, intent(in) :: zxzy(2,n)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
!
if (n .lt. 3 .or. m .lt. 1) go to 20
!
ist = 1
do j = 1,m
   call intrc1 (n, xi(j), yi(j), x, y, z, iadj, iend, &
&1, zxzy, ist, zi(j), ierr)
   if (ierr .lt. 0) go to 30
end do
ierr = 0
return
!
!     Error return
!
20 ierr = 1
return
30 ierr = 2
return
end subroutine sfval

subroutine sfval2 (n, x, y, z, l, m, nrows, xi, yi, zi, &
&iadj, iend, zxzy, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, nrows
integer :: i, ist, j
!-----------------------------------------------------------------------
!                Evaluation of the surface over a grid
!-----------------------------------------------------------------------
real :: x(n), y(n)
real, intent(in) :: z(n), zxzy(2,n)
real, intent(in) :: xi(l), yi(m)
real, intent(inout) :: zi(nrows,m)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
!
if (n .lt. 3 .or. l .lt. 1 .or. m .lt. 1 .or. nrows .lt. l) &
&go to 30
!
ist = 1
do j = 1,m
   do i = 1,l
      call intrc1 (n, xi(i), yi(j), x, y, z, iadj, iend, &
&1, zxzy, ist, zi(i,j), ierr)
      if (ierr .lt. 0) go to 40
   end do
end do
ierr = 0
return
!
!     Error return
!
30 ierr = 1
return
40 ierr = 2
return
end subroutine sfval2

subroutine intrc1 (n,px,py,x,y,z,iadj,iend,iflag, &
&zxzy, ist, pz,ier)
implicit none
integer, intent(in) :: n, iadj(*)
integer, intent(inout) :: iend(n)
integer, intent(in) :: iflag
integer, intent(inout) :: ist, ier
real, intent(in) :: px, py
real :: x(n), y(n)
real, intent(in) :: z(n), zxzy(2,n)
real, intent(out) :: pz
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   Given a triangulation of a set of points in the plane,
! this routine determines a piecewise cubic function F(X,Y)
! which interpolates a set of data values and partial
! derivatives at the vertices.  F has continuous first
! derivatives over the mesh and extends beyond the mesh
! boundary allowing extrapolation.  Interpolation is exact
! for quadratic data.  The value of F at (PX,PY) is
! returned.  INTRC1 is part of an interpolation package
! which provides routines to generate, update and plot the
! mesh.
!
! INPUT PARAMETERS -     N - NUMBER OF NODES IN THE MESH.
!                            N .GE. 3.
!
!                    PX,PY - coordinates of a point at which
!                            F is to be evaluated.
!
!                      X,Y - vectors of coordinates of the
!                            nodes in the mesh.
!
!                        Z - vector of data values at the
!                            nodes.
!
!                     IADJ - set of adjacency lists of nodes
!                            in the mesh.
!
!                     IEND - pointers to the ends of
!                            adjacency lists in IADJ for
!                            each node in the mesh.
!
!                    IFLAG - option indicator
!                            IFLAG = 0 IF INTRC1 IS TO
!                                      provide derivative
!                                      estimates (from
!                                      GRADL1).
!                            IFLAG = 1 IF DERIVATIVES ARE
!                                      user provided.
!
!                     ZXZY - 2 by N array whose columns
!                            contain estimated partial der-
!                            ivatives at the nodes (X par-
!                            tials in the first row) if
!                            IFLAG = 1, NOT USED IF IFLAG
!                            = 0.
!
!                      IST - index of the starting node in
!                            the search for a triangle con-
!                            TAINING (PX,PY).  1 .LE. IST
!                            .LE. N.  THE OUTPUT VALUE OF
!                            IST from a previous call may
!                            be a good choice.
!
! IADJ and IEND may be created by TRMESH and derivative
!   estimates may be computed by GRADL1 or GRADG.
!
! Input parameters other than IST are not altered by this
!   routine.
!
! Output parameters - IST - index of one of the vertices of
!                           the triangle containing (PX,PY)
!                           UNLESS IER .LT. 0.
!
!                      PZ - value of F at (PX,PY), or 0 if
!                           IER .LT. 0.
!
!                     Ier - error indicator
!                           IER = 0 IF NO ERRORS WERE
!                                   encountered.
!                           IER = 1 IF NO ERRORS WERE EN-
!                                   countered and extrapola-
!                                   tion was performed.
!                           IER = -1 IF N, IFLAG, OR IST IS
!                                    out of range.
!                           IER = -2 IF THE NODES ARE COL-
!                                    linear.
!
! Modules referenced by INTRC1 - TRFIND, TVAL,
!             (AND OPTIONALLY)   GRADL1, GETNP, SETRM,
!                                SROTG, SROT
!
!***********************************************************
!
integer :: nn, i1, i2, i3, ierr, n1, n2, indx
real :: xp, yp, zx1, zy1, zx2, zy2, zx3, zy3, x1, y1, x2, y2, x3, &
&y3, z1, z2, z3, dum, dp, u, v, xq, yq, r1, r2, a1, a2, b1, b2, c1, &
&c2, f1, f2
!
! Local parameters -
!
! NN =                      LOCAL COPY OF N
! I1,I2,I3 =                VERTICES DETERMINED BY TRFIND
! IERR =                    ERROR FLAG FOR CALLS TO GRADL1
!                             AND TVAL
! N1,N2 =                   ENDPOINTS OF THE CLOSEST BOUND-
!                             ary edge to P when P is out-
!                             side of the mesh boundary
! INDX =                    IADJ INDEX OF N1 AS A NEIGHBOR
!                             OF N2
! XP,YP =                   LOCAL COPIES OF THE COORDINATES
!                             OF P=(PX,PY)
! ZX1,ZY1,ZX2,ZY2,ZX3,ZY3 = X AND Y DERIVATIVES AT THE
!                             vertices of a triangle T which
!                             contains P or at N1 and N2
! X1,Y1,X2,Y2,X3,Y3 =       X,Y COORDINATES OF THE VERTICES
!                             of T or of N1 and N2
! Z1,Z2,Z3 =                DATA VALUES AT THE VERTICES OF T
! DUM =                     DUMMY VARIABLE FOR CALL TO TVAL
! DP =                      INNER PRODUCT OF N1-N2 AND P-N2
! U,V =                     X,Y COORDINATES OF THE VECTOR
!                             N2-N1
! XQ,YQ =                   X,Y COORDINATES OF THE CLOSEST
!                             boundary point to P when P is
!                             outside of the mesh boundary
! R1,R2 =                   BARYCENTRIC COORDINATES OF Q
!                             with respect to the line SEG-
!                             MENT N2-N1 CONTAINING Q
! A1,A2,B1,B2,C1,C2 =       CARDINAL FUNCTIONS FOR EVALUAT-
!                             ing the interpolatory surface
!                             AT Q
! F1,F2 =                   CUBIC FACTORS USED TO COMPUTE
!                             the cardinal functions
!
nn = n
pz = 0.
if (nn .lt. 3  .or.  iflag .lt. 0  .or.  iflag .gt. 1 &
&.or.  ist .lt. 1  .or.  ist .gt. nn) go to 11
xp = px
yp = py
!
! Find a triangle containing P if P is within the mesh
!   boundary
!
call trfind(ist,xp,yp,x,y,iadj,iend, i1,i2,i3)
if (i1 .eq. 0) go to 12
ist = i1
if (i3 .eq. 0) go to 3
if (iflag .ne. 1) go to 1
!
! Derivatives are user provided
!
zx1 = zxzy(1,i1)
zx2 = zxzy(1,i2)
zx3 = zxzy(1,i3)
zy1 = zxzy(2,i1)
zy2 = zxzy(2,i2)
zy3 = zxzy(2,i3)
go to 2
!
! Compute derivative estimates at the vertices
!
1 call gradl1(nn,i1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,i2,x,y,z,iadj,iend, zx2,zy2,ierr)
call gradl1(nn,i3,x,y,z,iadj,iend, zx3,zy3,ierr)
!
! Set local parameters for call to TVAL
!
2 x1 = x(i1)
y1 = y(i1)
x2 = x(i2)
y2 = y(i2)
x3 = x(i3)
y3 = y(i3)
z1 = z(i1)
z2 = z(i2)
z3 = z(i3)
call tval(xp,yp,x1,x2,x3,y1,y2,y3,z1,z2,z3,zx1,zx2, &
&zx3,zy1,zy2,zy3,0, pz,dum,dum,ierr)
if (ierr .ne. 0) go to 12
ier = 0
return
!
! P is outside of the mesh boundary.  Extrapolate to P by
!   passing a linear function of one variable THROUGH the
!   value and directional derivative (in the direction
!   P-Q) of the interpolatory surface (TVAL) at Q where
!   Q is the closest boundary point to P.
!
! Determine Q by traversing the boundary starting from
!   the rightmost visible node I1.
!
3 n2 = i1
!
! Set N1 to the last nonzero neighbor of N2 and compute DP
!
4 indx = iend(n2) - 1
n1 = iadj(indx)
x1 = x(n1)
y1 = y(n1)
x2 = x(n2)
y2 = y(n2)
dp = (x1-x2)*(xp-x2) + (y1-y2)*(yp-y2)
if (dp .le. 0.) go to 5
if ((xp-x1)*(x2-x1) + (yp-y1)*(y2-y1) .gt. 0.) go to 8
n2 = n1
go to 4
!
! N2 is the closest boundary point to P.  Compute partial
!   derivatives at N2.
!
5 if (iflag .ne. 1) go to 6
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 7
6 call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
!
! Compute extrapolated value at P
!
7 pz = z(n2) + zx2*(xp-x2) + zy2*(yp-y2)
ier = 1
return
!
! The closest boundary point Q lies on N2-N1.  Compute
!   partials at N1 and N2.
!
8 if (iflag .ne. 1) go to 9
zx1 = zxzy(1,n1)
zy1 = zxzy(2,n1)
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 10
9 call gradl1(nn,n1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
!
! Compute Q, its barycentric coordinates, and the cardinal
!   functions for extrapolation
!
10 u = x2-x1
v = y2-y1
r1 = dp/(u**2 + v**2)
r2 = 1. - r1
xq = r1*x1 + r2*x2
yq = r1*y1 + r2*y2
f1 = r1*r1*r2
f2 = r1*r2*r2
a1 = r1 + (f1-f2)
a2 = r2 - (f1-f2)
b1 = u*f1
b2 = -u*f2
c1 = v*f1
c2 = -v*f2
!
! Compute the value of the interpolatory surface (TVAL)
!   AT Q
!
pz = a1*z(n1) + a2*z(n2) + b1*zx1 + b2*zx2 + &
&c1*zy1 + c2*zy2
!
! Compute the extrapolated value at P
!
pz = pz + (r1*zx1 + r2*zx2)*(xp-xq) + &
&(r1*zy1 + r2*zy2)*(yp-yq)
ier = 1
return
!
! N, IFLAG, or IST out of range
!
11 ier = -1
return
!
! Nodes are collinear
!
12 ier = -2
return
end subroutine intrc1

subroutine tval (x,y,x1,x2,x3,y1,y2,y3,z1,z2,z3,zx1, &
&zx2,zx3,zy1,zy2,zy3,iflag, w,wx,wy, &
&ier)
implicit none
integer, intent(in) :: iflag
integer, intent(inout) :: ier
real, intent(in) :: x, y, x1, x2, x3, y1, y2, y3, z1, z2, z3, zx1, &
&zx2, zx3, zy1, zy2, zy3
real, intent(inout) :: w, wx, wy
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!                                             (615) 576-5139
!
!   Given function values and first partial derivatives at
! the three vertices of a triangle, this routine determines
! a function W which agrees with the given data, returning
! the value and (optionally) first partial derivatives of W
! at a point (X,Y) in the triangle.  The interpolation
! method is exact for quadratic polynomial data.  The
! triangle is partitioned into three subtriangles with
! equal areas.  W is cubic in each subtriangle and along
! the edges, but has only one continuous derivative across
! edges.  The normal derivative of W varies linearly along
! each outer edge.  The values and partial derivatives of W
! along a triangle edge depend only on the data values at
! the endpoints of the edge.  Thus the method yields C-1
! continuity when used to interpolate over a triangular
! grid.  This algorithm is due to C. L. Lawson.
!
! INPUT PARAMETERS -   X,Y - COORDINATES OF A POINT AT WHICH
!                            W is to be evaluated.
!
!        X1,X2,X3,Y1,Y2,Y3 - coordinates of the vertices of
!                            a triangle containing (X,Y).
!
!                 Z1,Z2,Z3 - function values at the vertices
!                            to be interpolated.
!
!              ZX1,ZX2,ZX3 - X-derivative values at the
!                            vertices.
!
!              ZY1,ZY2,ZY3 - Y-derivative values at the
!                            vertices.
!
!                    IFLAG - option indicator
!                            IFLAG = 0 IF ONLY W IS TO BE
!                                      computed.
!                            IFLAG = 1 IF W, WX, AND WY ARE
!                                      to be returned.
!
! Input parameters are not altered by this routine.
!
! OUTPUT PARAMETERS -   W - ESTIMATED VALUE OF THE INTERP-
!                           olatory function at (X,Y) if
!                           IER = 0.  OTHERWISE W = 0.
!
!                   WX,WY - partial derivatives of W at
!                           (X,Y) IF IER = 0 AND IFLAG = 1,
!                           UNCHANGED IF IFLAG .NE. 1, ZERO
!                           IF IER .NE. 0 AND IFLAG = 1.
!
!                     Ier - error indicator
!                           IER = 0 IF NO ERRORS WERE
!                                   encountered.
!                           IER = 1 IF THE VERTICES OF THE
!                                   triangle are collinear.
!
! Modules referenced by TVAL - none
!
! Intrinsic function called by TVAL - AMIN1
!
!***********************************************************
!
integer :: i, ip1, ip2, ip3
real :: u(3), v(3), sl(3), area, xp, yp, r(3), rx(3), ry(3), &
&phi(3), phix(3), phiy(3), rmin, c1, c2, ro(3), rox(3), roy(3), &
&f(3), g(3), gx(3), gy(3), p(3), px(3), py(3), q(3), qx(3), qy(3), &
&a(3), ax(3), ay(3), b(3), bx(3), by(3), c(3), cx(3), cy(3)
!
! Local parameters -
!
! I =               DO-LOOP INDEX
! IP1,IP2,IP3 =     PERMUTED INDICES FOR COMPUTING RO, ROX,
!                     and roy
! U(K) =            X-COMPONENT OF THE VECTOR REPRESENTING
!                     the side opposite vertex K
! V(K) =            Y-COMPONENT OF THE VECTOR REPRESENTING
!                     the side opposite vertex K
! SL(K) =           SQUARE OF THE LENGTH OF THE SIDE
!                     opposite vertex K
! AREA =            TWICE THE AREA OF THE TRIANGLE
! XP,YP =           X-X1, Y-Y1
! R(K) =            K-TH BARYCENTRIC COORDINATE
! RX(K),RY(K) =     X,Y PARTIAL DERIVATIVES OF R(K)
! PHI(K)            R(K-1)*R(K+1) -- QUADRATIC
! PHIX(K),PHIY(K) = X,Y PARTIALS OF PHI(K)
! RMIN =            MIN(R1,R2,R3)
! C1,C2 =           FACTORS FOR COMPUTING RO
! RO(K) =           FACTORS FOR COMPUTING G -- CUBIC
!                     correction terms
! ROX(K),ROY(K) =   X,Y PARTIALS OF RO(K)
! F(K) =            FACTORS FOR COMPUTING G, GX, AND GY --
!                     constant
! G(K) =            FACTORS FOR COMPUTING THE CARDINAL
!                     functions -- cubic
! GX(K),GY(K) =     X,Y PARTIALS OF G(K)
! P(K) =            G(K) + PHI(K)
! PX(K),PY(K) =     X,Y PARTIALS OF P(K)
! Q(K) =            G(K) - PHI(K)
! QX(K),QY(K) =     X,Y PARTIALS OF Q(K)
! A(K) =            CARDINAL FUNCTION WHOSE COEFFICIENT IS
!                     Z(K)
! AX(K),AY(K) =     X,Y PARTIALS OF A(K) -- CARDINAL
!                     functions for WX and WY
! B(K) =            TWICE THE CARDINAL FUNCTION WHOSE
!                     coefficient is ZX(K)
! BX(K),BY(K) =     X,Y PARTIALS OF B(K)
! C(K) =            TWICE THE CARDINAL FUNCTION WHOSE
!                     coefficient is ZY(K)
! CX(K),CY(K) =     X,Y PARTIALS OF C(K)
!
u(1) = x3 - x2
u(2) = x1 - x3
u(3) = x2 - x1
!
v(1) = y3 - y2
v(2) = y1 - y3
v(3) = y2 - y1
!
do 1 i = 1,3
  sl(i) = u(i)*u(i) + v(i)*v(i)
1 continue
!
! AREA = 3-1 X 3-2
!
area = u(1)*v(2) - u(2)*v(1)
if (area .eq. 0.) go to 9
!
! R(1) = (2-3 X 2-(X,Y))/AREA, R(2) = (1-(X,Y) X 1-3)/AREA,
!   R(3) = (1-2 X 1-(X,Y))/AREA
!
r(1) = (u(1)*(y-y2) - v(1)*(x-x2))/area
xp = x - x1
yp = y - y1
r(2) = (u(2)*yp - v(2)*xp)/area
r(3) = (u(3)*yp - v(3)*xp)/area
ier = 0
!
phi(1) = r(2)*r(3)
phi(2) = r(3)*r(1)
phi(3) = r(1)*r(2)
!
rmin = amin1(r(1),r(2),r(3))
if (rmin .ne. r(1)) go to 3
ip1 = 1
ip2 = 2
ip3 = 3
go to 5
3 if (rmin .ne. r(2)) go to 4
ip1 = 2
ip2 = 3
ip3 = 1
go to 5
4 ip1 = 3
ip2 = 1
ip3 = 2
!
5 c1 = rmin*rmin/2.
c2 = rmin/3.
ro(ip1) = (phi(ip1) + 5.*c1/3.)*r(ip1) - c1
ro(ip2) = c1*(r(ip3) - c2)
ro(ip3) = c1*(r(ip2) - c2)
!
f(1) = 3.*(sl(2)-sl(3))/sl(1)
f(2) = 3.*(sl(3)-sl(1))/sl(2)
f(3) = 3.*(sl(1)-sl(2))/sl(3)
!
g(1) = (r(2)-r(3))*phi(1) + f(1)*ro(1) - ro(2) + ro(3)
g(2) = (r(3)-r(1))*phi(2) + f(2)*ro(2) - ro(3) + ro(1)
g(3) = (r(1)-r(2))*phi(3) + f(3)*ro(3) - ro(1) + ro(2)
!
do i = 1,3
  p(i) = g(i) + phi(i)
  q(i) = g(i) - phi(i)
  end do
!
a(1) = r(1) + g(3) - g(2)
a(2) = r(2) + g(1) - g(3)
a(3) = r(3) + g(2) - g(1)
!
b(1) = u(3)*p(3) + u(2)*q(2)
b(2) = u(1)*p(1) + u(3)*q(3)
b(3) = u(2)*p(2) + u(1)*q(1)
!
c(1) = v(3)*p(3) + v(2)*q(2)
c(2) = v(1)*p(1) + v(3)*q(3)
c(3) = v(2)*p(2) + v(1)*q(1)
!
! W is a linear combination of the cardinal functions
!
w = a(1)*z1 + a(2)*z2 + a(3)*z3 + (b(1)*zx1 + b(2)*zx2 &
&+ b(3)*zx3 + c(1)*zy1 + c(2)*zy2 + c(3)*zy3)/2.
if (iflag .ne. 1) return
!
! Compute WX and WY
!
do i = 1,3
  rx(i) = -v(i)/area
  ry(i) = u(i)/area
  end do
phix(1) = r(2)*rx(3) + rx(2)*r(3)
phiy(1) = r(2)*ry(3) + ry(2)*r(3)
phix(2) = r(3)*rx(1) + rx(3)*r(1)
phiy(2) = r(3)*ry(1) + ry(3)*r(1)
phix(3) = r(1)*rx(2) + rx(1)*r(2)
phiy(3) = r(1)*ry(2) + ry(1)*r(2)
!
rox(ip1) = rx(ip1)*(phi(ip1) + 5.*c1) + &
&r(ip1)*(phix(ip1) - rx(ip1))
roy(ip1) = ry(ip1)*(phi(ip1) + 5.*c1) + &
&r(ip1)*(phiy(ip1) - ry(ip1))
rox(ip2) = rx(ip1)*(phi(ip2) - c1) + c1*rx(ip3)
roy(ip2) = ry(ip1)*(phi(ip2) - c1) + c1*ry(ip3)
rox(ip3) = rx(ip1)*(phi(ip3) - c1) + c1*rx(ip2)
roy(ip3) = ry(ip1)*(phi(ip3) - c1) + c1*ry(ip2)
!
gx(1) = (rx(2) - rx(3))*phi(1) + (r(2) - r(3))*phix(1) &
&+ f(1)*rox(1) - rox(2) + rox(3)
gy(1) = (ry(2) - ry(3))*phi(1) + (r(2) - r(3))*phiy(1) &
&+ f(1)*roy(1) - roy(2) + roy(3)
gx(2) = (rx(3) - rx(1))*phi(2) + (r(3) - r(1))*phix(2) &
&+ f(2)*rox(2) - rox(3) + rox(1)
gy(2) = (ry(3) - ry(1))*phi(2) + (r(3) - r(1))*phiy(2) &
&+ f(2)*roy(2) - roy(3) + roy(1)
gx(3) = (rx(1) - rx(2))*phi(3) + (r(1) - r(2))*phix(3) &
&+ f(3)*rox(3) - rox(1) + rox(2)
gy(3) = (ry(1) - ry(2))*phi(3) + (r(1) - r(2))*phiy(3) &
&+ f(3)*roy(3) - roy(1) + roy(2)
!
do i = 1,3
  px(i) = gx(i) + phix(i)
  py(i) = gy(i) + phiy(i)
  qx(i) = gx(i) - phix(i)
  qy(i) = gy(i) - phiy(i)
  end do
!
ax(1) = rx(1) + gx(3) - gx(2)
ay(1) = ry(1) + gy(3) - gy(2)
ax(2) = rx(2) + gx(1) - gx(3)
ay(2) = ry(2) + gy(1) - gy(3)
ax(3) = rx(3) + gx(2) - gx(1)
ay(3) = ry(3) + gy(2) - gy(1)
!
bx(1) = u(3)*px(3) + u(2)*qx(2)
by(1) = u(3)*py(3) + u(2)*qy(2)
bx(2) = u(1)*px(1) + u(3)*qx(3)
by(2) = u(1)*py(1) + u(3)*qy(3)
bx(3) = u(2)*px(2) + u(1)*qx(1)
by(3) = u(2)*py(2) + u(1)*qy(1)
!
cx(1) = v(3)*px(3) + v(2)*qx(2)
cy(1) = v(3)*py(3) + v(2)*qy(2)
cx(2) = v(1)*px(1) + v(3)*qx(3)
cy(2) = v(1)*py(1) + v(3)*qy(3)
cx(3) = v(2)*px(2) + v(1)*qx(1)
cy(3) = v(2)*py(2) + v(1)*qy(1)
!
! WX and WY are linear combinations of the cardinal
!   functions
!
wx = ax(1)*z1 + ax(2)*z2 + ax(3)*z3 + (bx(1)*zx1 + &
&bx(2)*zx2 + bx(3)*zx3 + cx(1)*zy1 + cx(2)*zy2 + &
&cx(3)*zy3)/2.
wy = ay(1)*z1 + ay(2)*z2 + ay(3)*z3 + (by(1)*zx1 + &
&by(2)*zx2 + by(3)*zx3 + cy(1)*zy1 + cy(2)*zy2 + &
&cy(3)*zy3)/2.
return
!
! Vertices are collinear
!
9 ier = 1
w = 0.
if (iflag .ne. 1) return
wx = 0.
wy = 0.
return
end subroutine tval

subroutine mfit(dimen,fitdeg,nfpols,nfpts, &
&fitcds,ncrows,fitvls,wts, &
&resids,error,fitiwk,fitdwk, &
&fiwkln,fdwkln,ireqd,dreqd)
implicit none
!
integer, intent(inout) :: nfpols, fitdeg
integer, intent(in) :: nfpts, dimen, fiwkln, fdwkln
integer, intent(inout) :: error, ireqd, dreqd
integer :: indstt, p, dimp1
integer, intent(in) :: ncrows
integer :: newstt, maxstt, alfstt, psistt, cstt, ssqstt, psiwid, &
&alfl
integer, intent(inout) :: fitiwk(fiwkln)
real, intent(inout) :: fitdwk(fdwkln), fitcds(ncrows,dimen)
real, intent(inout) :: fitvls(nfpts), resids(nfpts)
real, intent(in) :: wts(nfpts)
real :: scale
!
!     ***************
!     Purpose
!     -------
!
!     This subroutine constructs a least-squares  multinomial  fit  to
!     given data using a basis of orthogonal multinomials.
!
!     The data for the fit is given in the arrays FITCDS, FITVLS, and
!     WTS. FITCDS is a matrix, each row of which contains an observa-
!     tion point. FITVLS is a singly-indexed array, each element of
!     which contains a function VALUE corresponding to an observation
!     point. WTS is a singly-indexed array, each element of which is
!     a nonnegative weight for the corresponding observation.
!
!     The fit which is produced is a multinomial expressed in the form
!
!      C  PSI  (X ,...,X     ) +...+ C       PSI       (X ,...,X     )
!       1    1   1      DIMEN         NFPOLS    NFPOLS   1      DIMEN
!
!     WHERE THE VALUE OF  NFPOLS  WILL BE AS GIVEN (IF  FITDEG .LT. 0)
!     or  as  computed  by  MFIT  to give a full-degree fit (in case
!     FITDEG  IS SPECIFIED .GE. 0).  THE ELEMENTS
!
!         PSI  (X ,...,X     )
!            K   1      DIMEN
!
!     Form a basis for the multinomials which is orthogonal with
!     respect to the weights and observation points.
!
!     The extent of the fit can be specified in one of two ways.
!         IF THE PARAMETER FITDEG IS SET .GE. 0, THEN A COMPLETE BASIS
!         FOR THE MULTINOMIALS OF DEGREE =  FITDEG  WILL BE USED.  (AN
!         error will be  flagged  if  this  will  require  more  basis
!         multinomials  than  the  number  of  data  points which were
!         given.)
!         IF THE PARAMETER  FITDEG  IS .LT.  0, THEN  NFPOLS  WILL  BE
!         taken as the count of the number of basis multinomials to be
!         used for a partial-degree fit.  (An error will be flagged if
!         NFPOLS  .LT. 0.)
!
!     Variables
!     ---------
!
!      DIMEN  -- (INTEGER) -- (passed)
!         the number of variables.
!      FITDEG  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF .LT. 0.
!         IF FITDEG .GE. 0 THEN  FITDEG  IS  CHECKED  AGAINST  NFPTS .
!         The value of  FITDEG  will be reduced if there is a basis of
!         MULTINOMIALS, ALL OF  DEGREE  .LE. FITDEG ,  OF  CARDINALITY
!         NFPTS .  See  error  below.
!      NFPOLS  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF  FITDEG  .GE. 0.
!         IF  FITDEG .LT. 0 THEN THE VALUE OF NFPOLS WILL BE TAKEN  AS
!         the size of the basis of multinomials to be used in the fit.
!         NFPOLS  MUST SATISFY  NFPOLS  .LT. NFPTS  AND NFPOLS .GE. 1
!         see  error  below.
!      NFPTS  --- (INTEGER) -- (passed)
!         the number of data points to be used in the fit.
!         NFPTS  MUST BE .GE. 1.  SEE  ERROR  BELOW.
!      FITCDS  -- (real 2-subscript array) -- (passed)
!         FITCDS (P,K) is the value of the K-TH variable at the  P-TH
!         data point.
!      NCROWS  -- (INTEGER) -- (passed)
!         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!         program.
!      FITVLS  -- (real 1-subscript array) -- (passed)
!         FITVLS (P) is the observed function VALUE of the P-TH  data
!         point.
!      WTS  ----- (real 1-subscript array) -- (passed)
!         WTS (P) is the weight attached to the P-TH data point.
!      RESIDS  -- (real 1-subscript array) -- (returned)
!         RESIDS (P) is the difference between the fitted function at
!         point P and  FITVLS (P).
!      Error  -- (INTEGER) -- (returned)
!       0 the desired least square multinomial fit was obtained.
!      -1 Only the first NFPOLS basis polynomials were obtained.
!         FITDEG is the degree of the fit.
!       1 IF  FITDEG  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
!         OF SMALLER DEGREE OR IF FITDEG .LT. 0 AND NFPOLS .GT. NFPTS.
!       2 IF  FITDEG  .LT. 0 AND  NFPOLS  .LE. 0.
!       3 IF  NFPTS  .LT. 1 AND/OR  DIMEN  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         the value returned in  IREQD , and set  DWKLEN  to the value
!         returned in  DREQD  to resolve this problem.)
!      FITIWK  -- (integer, 1-subscript array) -- (returned)
!         an integer work array of length  FIWKLN .  Upon return  from
!         MFIT, FITIWK contains dimension and array LENGTH information.
!      FITDWK  -- (real 1-subscript array) -- (returned)
!         a real array of length  FDWKLN  containing the coefficients
!         needed for computing the multinomial fit at a point.
!      FIWKLN  -- (INTEGER) -- (passed)
!         the length of the array  FITIWK .
!      FDWKLN  -- (INTEGER) -- (passed)
!         the length of the array  FITDWK .
!      IREQD  -- (INTEGER) -- (returned)
!         the length which the array  FITIWK  really needs to be.
!      DREQD  -- (INTEGER) -- (returned)
!         the length which the array  FITDWK  really needs to be.
!
!
!     Note. The 20 loop depends on the scaling scheme being used. The
!     residual scaling must be consistent with that defined by SCALPM
!     AND SCALDN.
!
!     MFIT  calls  allot  and  GNRTP.
!     ****************
!
dimp1 = dimen + 1
!
!     ***************
!
call allot(fitdeg,nfpols,nfpts,dimen,fitiwk,fiwkln,ireqd,dreqd, &
&error)
if ( error .ge. 2 ) return
!
if ( fdwkln .ge. dreqd ) go to 10
   error = 4
   return
10 continue
!
psiwid = fitiwk(3)
alfl = fitiwk(4)
indstt = 1
newstt = 4 * nfpols + indstt
maxstt = 1
alfstt = maxstt + dimp1
cstt = alfstt + alfl
ssqstt = cstt + nfpols
psistt = ssqstt + nfpols
!
!     ***************
!
   call gnrtp(fitdeg,fitdwk(alfstt), &
&fitdwk(psistt),fitiwk(indstt), &
&fitiwk(newstt),fitdwk(ssqstt),fitcds, &
&ncrows,nfpols,dimen,nfpts,fitvls,resids, &
&fitdwk(cstt),psiwid,wts,alfl,dimp1, &
&fitdwk(maxstt),error)
!
!     ***************
!     Store the number of basis polynomials actually computed
!     by the modified routine INCDG called by GNRTP.
!     ***************
!
fitiwk(1) = nfpols
!
!     ***************
!     Unscale the residuals for the benefit of the user.
!     ***************
!
scale = fitdwk(dimen + 1)
do p = 1,nfpts
  resids(p) = resids(p) * scale
end do
return
end subroutine mfit

subroutine allot(degree,npolys,npts,dimen,iwork,iwklen, &
&ireqd,dreqd,error)
implicit none
!
integer, intent(inout) :: ireqd, dreqd
integer :: alfl
integer, intent(inout) :: error, npolys, degree
integer, intent(in) :: dimen, npts
integer :: newstt, psiwid, kmxbas, startj, kjp1d2, index
integer, intent(in) :: iwklen
integer :: nplyt4
integer, intent(inout) :: iwork(iwklen)
!
!     ***************
!     Purpose
!     -------
!
!      Allot  checks for sufficiency the declared  dimensions  of  the
!     work  arrays  used by the subroutine  MFIT .  Various sizes of
!     sub-arrays are computed and reported.
!
!     This routine is called by  MFIT .  It is not  called  directly
!     by the user.
!
!     THIS ROUTINE CALLS   BASIZ   AND   MTABLE   FOR  THE  SUBSTANTIVE
!     computations.
!
!     Variables
!     ---------
!
!      Degree  - (PASSED/RETURNED)
!         IGNORED IF .LT. 0.
!         IF  DEGREE  .GE. 0 THEN  DEGREE IS CHECKED  AGAINST   NPTS .
!         The value of  degree  will be reduced if there is a basis of
!         MULTINOMIALS, ALL OF  DEGREE .LE.  DEGREE ,  OF  CARDINALITY
!          NPTS
!      NPOLYS  - (PASSED/RETURNED)
!         IGNORED IF  DEGREE  .GE. 0.
!         IF DEGREE .LT. 0 THEN THE VALUE OF NPOLYS WILL BE TAKEN  AS
!         the size of the basis of multinomials to be used in the fit.
!         NPOLYS  MUST SATISFY NPOLYS .LT.  NPTS  AND  NPOLYS  .GE. 1
!      NPTS  --- (PASSED)
!         the number of data points to be used in the fit.
!          NPTS  MUST BE .GE. 1.
!      DIMEN  -- (PASSED)
!         the number of variables.
!      IWORK  -- (RETURNED)
!         an integer work array of length at least
!            IF  DEGREE  .GE. 0 THEN
!               4*BINOMIAL( DIMEN + DEGREE , DIMEN )
!                  +( DIMEN )*( DEGREE )
!            ELSE
!               4*BINOMIAL( DIMEN +D,D)+( DIMEN )*D
!         where D is the minimum cardinality  of  a  basis  of  degree
!          degree  such that
!            BINOMIAL( DIMEN +ABS( DEGREE ), DIMEN ) .GE.  NPOLYS
!      IWKLEN  - (PASSED)
!         the length of  IWORK
!      IREQD  -- (RETURNED)
!         THE SIZE OF THE INTEGER WORK ARRAY REQUIRED BY  MFIT   FOR
!         the fit specified by the 4 input parameters.
!      DREQD  -- (RETURNED)
!         the size of the double  precision  work  array  required  by
!          MFIT  for the fit specified by the 4 input parameters.
!      Error  -- (returned)
!       0 IF  NPOLYS ,  DIMEN ,   DEGREE ,   NPTS   AND   IWKLEN   ARE
!         valid and consistent with each other.
!       1 IF  DEGREE  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
!         OF SMALLER DEGREE OR IF  DEGREE .LT. 0 AND  NPOLYS .GT. NPTS
!       2 IF  DEGREE  .LT. 0 AND  NPOLYS  .LE. 0
!       3 IF  NPTS  .LT. 1 AND/OR  DIMEN  .LT. 1
!       4 if  IWKLEN  is too small (set  IWKLEN  to the value returned
!         in  IREQD  to resolve this problem)
!
!     NOTE THAT  DEGREE ,  NPOLYS ,  PSIWID  AND  ALFL   ARE  RETURNED
!     in  IWORK (1-4), respectively.
!
!     DATE LAST MODIFIED
!     ---- ---- --------
!     December 10, 1984
!     ****************
!
!     ***************
!     BASIZ  computes the size of the basis (and auxiliary sizes)
!     based primarily upon the degree, number of  fitting points,
!     and the dimension.
!     ***************
!
call basiz(degree,npts,dimen,npolys,error)
if ( error .ge. 2 ) return
ireqd = 4 * npolys + degree * dimen
if ( iwklen .ge. ireqd ) go to 5
   error = 4
   return
5 newstt = 4 * npolys + 1
!
!     ***************
!     Set up useful indexing arrays
!          IWORK(1) ,..., IWORK(NEWSTT-1)
!     and
!          IWORK(NEWSTT ,..., IWORK(NEWSTT+DIMEN*DEGREE)
!     ***************
!
call mtable(degree,dimen,npolys,iwork,iwork(newstt),alfl)
iwork(1) = degree
iwork(2) = npolys
!
!     ***************
!     Force  ALFL  to be at least 1 so that dimension statements
!     using  ALFL  do not bomb.
!     ***************
!
if ( alfl .gt. 1 ) alfl = alfl - 1
iwork(4) = alfl
!
!     ***************
!     The following is a section of code for setting up the
!     storage  management of the  psi  array.  There  is  A
!     complicated dovetailing formula used to pack information
!     into  psi  without leaving gaps.
!
!     ARRAY          LENGTH
!     -----          ------
!      MAXABS         DIMEN  + 1
!      ALPHA          ALFL
!      C              NPOLYS
!      SUMSQS         NPOLYS
!
!     The number of columns in  psi ,  PSIWID , is determined by
!     PSIWID  =  NPOLYS  + 1 - (THE SMALLEST M SUCH THAT ALPHA(J,M)
!                                   IS NONZERO AND J .GE. NPOLYS)
!     this insures that if the user extends the basis, all the  psi
!     required will certainly be stored
!
!     IF DEGREE( NPOLYS ) .LE. 2 THEN                      (CASE 1)
!       PSIWID  =  NPOLYS
!     ELSE
!       IF K =  DIMEN  THEN                                (CASE 2)
!         PSIWID  =  NPOLYS
!                    -  NEWKJ( 1 , DEGREE(NPOLYS)-1 )  + 1
!       ELSE
!            PSIWID  =  NPOLYS
!                      + 1
!                      - (
!                         The smaller of
!                           NEWKJ(K+1,DEGREE(NPOLYS)-2)    (CASE 3)
!                         and
!                           INDEXS(3,NPOLYS)               (CASE 4)
!                        )
!
if ( degree .gt. 2 ) go to 10
!
!     ***************
!     Case 1
!     ***************
!
   psiwid = npolys
go to 40
10 nplyt4 = 4 * npolys
!
!     ***************
!     KMXBAS  IS K
!                 NPOLYS
!     ***************
!
   kmxbas = iwork(nplyt4 - 2)
!
   if ( kmxbas .ne. dimen ) go to 20
!
!     ***************
!     Case 2
!     ***************
!
      psiwid = npolys - iwork(4 * npolys - 1)
   go to 40
!
!     ***************
!     INDEX =  NEWKJ( K      + 1 , DEGREE(NPOLYS-2) )
!                      NPOLYS
!     ***************
!
20 index = nplyt4 + (degree - 3) * dimen + kmxbas + 1
      kjp1d2 = iwork(index)
!
!     ***************
!     STARTJ  =  INDEXS(3,NPOLYS)
!     ***************
!
      startj = iwork(nplyt4 - 1)
      if ( startj .gt. kjp1d2 ) go to 30
!
!     ***************
!     Case 4
!     ***************
!
         psiwid = npolys - startj + 1
      go to 40
!
!     ***************
!     Case 3
!     ***************
!
30 psiwid = npolys - kjp1d2 + 1
40 iwork(3) = psiwid
dreqd = 2 * npolys + dimen + 1 + npts * psiwid + alfl
return
end subroutine allot

subroutine basiz(degree,npts,dimen,npolys,error)
implicit none
!
integer :: top, bot
integer, intent(inout) :: degree
integer, intent(in) :: npts, dimen
integer, intent(inout) :: npolys
integer, intent(out) :: error
integer :: i, rowlen
!
!     ***************
!     Purpose
!     -------
!
!     IF  DEGREE  .GE. 0 THEN
!       find the size of a basis required either to
!       1) approximate the data with a polynomial of degree
!          given by the parameter  DEGREE
!       or to
!       2) SPAN THE SPACE OF POLYNOMIALS OF DEGREE .LE. THE
!          smallest degree of polynomial which interpolates the
!          data.
!       IN CASE 1  ERROR  = 0.
!       IN CASE 2  ERROR  = 1.
!     ELSE
!       IF  NPOLYS  .GE. 1 THEN
!          IF NPOLYS .GT. NPTS THEN
!             SET  NPOLYS  =  NPTS , FIND THE SMALLEST DEGREE OF A
!             polynomial  which  interpolates  the  data,  and set
!              ERROR  = 1.
!          ELSE
!             find the largest degree  degree  of a polynomial  in
!             a  basis of  NPOLYS  polynomials generated according
!             TO OUR ORDERING AND SET  ERROR  = 0.
!       ELSE
!           ERROR  = 2
!
!     This subroutine is called by  allot .  It is not  called  by
!     the user directly.
!
!     DATE LAST MODIFIED
!     ---- ---- --------
!     October 16, 1984
!     ****************
!
error = 0
if ( npts .ge. 1 .and. dimen .ge. 1 ) go to 10
   error = 3
   return
!
10 continue
if ( degree .lt. 0 ) go to 30
!
  rowlen = 1
  npolys = 1
  top = dimen - 1
  bot = 0
  if ( degree .lt. 1 )  go to 30
    do i=1,degree
      top = top + 1
      bot = bot + 1
      rowlen = (rowlen*top)/bot
      npolys = npolys + rowlen
    end do
!
30 continue
if ( npolys .ge. 1 ) go to 40
      error = 2
      return
40 continue
if ( npolys .lt. npts ) go to 50
      npolys = npts
      error = 1
50 continue
rowlen = 1
i = 1
degree = 0
top = dimen - 1
bot = 0
60 continue
if ( i .ge. npolys )  go to 70
    top = top + 1
    bot = bot + 1
    rowlen = (rowlen*top)/bot
    i = i + rowlen
    degree = degree + 1
    if ( i .lt. npolys )  go to 60
70 continue
return
end subroutine basiz

subroutine mtable(degree,dimen,npolys,indexs,newkj,alflp1)
implicit none
!
integer :: j, kj, curdeg, jprime, nwithk, i, curm1, ralen, dimm1, &
&dimm2
integer, intent(in) :: npolys, dimen, degree
integer, intent(out) :: alflp1
integer :: dimp1
integer, intent(inout) :: indexs(4,npolys), newkj(dimen,degree)
!
!     ***************
!     Purpose
!     -------
!
!     Tabulate  JP  and  KJ  for each  J
!
!     Variables
!     ---------
!
!      ALFLP1  -- (INTEGER) -- (passed)
!         the length required for array  ALPHA , plus one
!      degree  -- (INTEGER) -- (passed)
!         the degree of the polynomial to be fitted
!      DIMEN  -- (INTEGER) -- (passed)
!         number of independent variables
!      INDEXS  -- (integer, 2-subscript array) -- (returned)
!          INDEXS (1, J )   IS    JP ,    INDEXS (2, J )   IS     KJ ,
!          INDEXS (3, J )  is the first nonzero recurrence coefficient
!         in  alpha  and  INDEXS (4, J ) is its location in  alpha .
!      NEWKJ  -- (integer, 2-subscript array) -- (returned)
!          NEWKJ ( K , D ) IS THE FIRST MONOMIAL OF DEGREE  D   HAVING
!          KJ = K .
!      NPOLYS  -- (INTEGER) -- (passed)
!         NUMBER  OF  MONOMIALS  OF  DEGREE  .LE.  ORDER  IN   DIMEN
!         independent variables.
!
!     This subprogram can be coded (excluding the part for calculating
!      INDEXS (3, J )  AND   INDEXS (4, J )) MENTALLY MORE EFFICIENTLY
!     but computationally less efficiently as
!
!         J = 2
!         DO 5 KJ = 1,DIMEN
!           NEWKJ(KJ,1) = KJ + 1
!           INDEXS(1,J) = 1
!           INDEXS(2,J) = KJ
!           J = J + 1
!      5  continue
!         DO 10 CURDEG = 2,DEGREE
!           DO 10 KJ = 1,DIMEN
!             JPRIME = NEWKJ(KJ,CURDEG - 1)
!             NEWKJ(KJ,CURDEG) = J
!             NWITHK = COMB(DIMEN + CURDEG - KJ - 1,CURDEG - 1)
!             DO 10 I = 1,NWITHK
!               INDEXS(1,J) = JPRIME
!               INDEXS(2,J) = KJ
!               JPRIME = JPRIME + 1
!               J = J + 1
!     10  continue
!
!     Where COMB(N,KJ) is N-factorial / ((N-KJ)-factorial * KJ-factorial
!     here we make use of the recurrence relations
!
!       COMB(DIMEN+CURDEG-2,CURDEG-1)
!
!            (DIMEN+CURDEG-2)*COMB(DIMEN+CURDEG-3,CURDEG-2)
!          = ----------------------------------------------
!                              (CURDEG-1)
!
!     And
!
!       COMB(DIMEN+CURDEG-KJ-1,CURDEG-1)
!
!            (DIMEN-KJ+1)*COMB(DIMEN+CURDEG-KJ,CURDEG-1)
!          = -------------------------------------------
!                         (DIMEN+CURDEG-KJ)
!
!
!     DATE LAST MODIFIED
!     ---- ---- --------
!     October 16, 1984
!     ****************
!
alflp1 = 1
!
!     ***************
!     Set  INDEXS (4,1) to 1 so that  ALFL - INDEXS (4,1)+1 is the
!     NUMBER OF COLUMNS REQUIRED FOR  PSI  FOR  NPOLYS =1  ( ALFL
!     IS DEFINED IN THE MAINLINE TO BE  ALFLP1 -1 IF ALFLP1 .GT. 1
!     and  ALFLP1  otherwise.
!     ***************
!
indexs(4,1) = 1
!
if ( npolys .eq. 1 ) return
j = 2
do 10 kj = 1,dimen
   newkj(kj,1) = kj + 1
   indexs(1,j) = 1
   indexs(2,j) = kj
   indexs(3,j) = 1
   indexs(4,j) = alflp1
   alflp1 = alflp1 + j - 1
   if ( j .eq. npolys ) return
10 j = j + 1
if ( degree .eq. 1 ) return
ralen = 1
dimm1 = dimen - 1
dimm2 = dimen - 2
dimp1 = dimen + 1
do 70 curdeg = 2,degree
   curm1 = curdeg - 1
   ralen = (ralen * (dimm2 + curdeg)) / curm1
   nwithk = ralen
   kj = 1
20 jprime = newkj(kj,curm1)
   newkj(kj,curdeg) = j
   if ( kj .eq. dimen ) go to 60
      do 50 i = 1,nwithk
         indexs(1,j) = jprime
         indexs(2,j) = kj
!
!     ***************
!     CALCULATE  INDEXS (3, J ),  INDEXS (4, J )
!     ***************
!
         if ( kj .lt. indexs(2,jprime) ) go to 30
            indexs(3,j) = indexs(1,jprime)
            go to 40
30 indexs(3,j) = newkj(1,curdeg - 1)
40 indexs(4,j) = alflp1
         alflp1 = alflp1 + j - indexs(3,j)
         if ( j .eq. npolys ) return
!
         jprime = jprime + 1
50 j = j + 1
      kj = kj + 1
      nwithk = (nwithk * (dimp1 - kj)) / (dimen + curdeg - kj)
      go to 20
60 indexs(1,j) = jprime
   indexs(2,j) = dimen
   indexs(3,j) = indexs(1,jprime)
   indexs(4,j) = alflp1
   alflp1 = alflp1 + j - indexs(3,j)
   if ( j .eq. npolys ) return
70 j = j + 1
return
end subroutine mtable

subroutine gnrtp(degree,alpha,psi,indexs, &
&newkj,sumsqs,coord,ncrows,npolys, &
&dimen,npts,f,z,c,psiwid,weight, &
&alfl,dimp1,maxabs,error)
implicit none
integer, intent(in) :: ncrows
!
integer, intent(inout) :: degree
integer, intent(in) :: dimen
integer, intent(inout) :: npolys
integer, intent(in) :: npts
integer :: k
integer, intent(in) :: psiwid, alfl
integer :: p, sttdeg, onplys
integer, intent(inout) :: error
integer :: dimp1
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
real, intent(inout) :: psi(npts,psiwid), alpha(alfl), f(npts)
real, intent(inout) :: coord(ncrows,dimen), maxabs(dimp1)
real, intent(in) :: weight(npts)
real, intent(inout) :: z(npts), sumsqs(npolys), c(npolys)
real :: runtot, rntot1
!
!     ***************
!     Purpose
!     -------
!
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine starts the process off by setting up
!     the first basis element, scaling the  data,  finding  the  first
!     coefficient,  and  initializing  the  work array Z.  GNRTP  then
!     calls  INCDG  if more than one basis element is required.
!
!     This subroutine is called by  MFIT .  It is not called by  the
!     user.
!
!     This subroutine calls  SCALPM ,  SCALDN , and  INCDG .
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!     ****************
!
!     ***************
!     Set up the scaling.
!     ***************
!
do 10 k = 1,dimen
   call scalpm(coord(1,k),npts,maxabs(k))
10 call scaldn(coord(1,k),npts,maxabs(k))
call scalpm(f,npts,maxabs(dimp1))
call scaldn(f,npts,maxabs(dimp1))
!
!     ***************
!      SUMSQS (1) = (1,1)
!     C  = (F,1) / (1,1)
!      1
!     ***************
!
runtot = 0.0
rntot1 = 0.0
do 20 p = 1,npts
   psi(p,1) = 1.0
   rntot1 = rntot1 + weight(p)
20 runtot = runtot + f(p) * weight(p)
sumsqs(1) = rntot1
c(1) = runtot / rntot1
!
!     ***************
!     Z = F - C
!              1
!     ***************
!
do 30 p = 1,npts
30 z(p) = f(p) - c(1)
!
if ( npolys .eq. 1 ) return
sttdeg = 1
onplys = 1
!
call incdg(degree,alpha,psi,indexs,newkj,sumsqs, &
&coord,ncrows,npolys,dimen,npts,f,z,c,psiwid, &
&weight,alfl,onplys,sttdeg,error)
return
end subroutine gnrtp

subroutine incdg(degree,alpha,psi,indexs,newkj, &
&sumsqs,coord,ncrows,npolys, &
&dimen,npts,f,z,c,psiwid,weight, &
&alfl,onplys,sttdeg,error)
implicit none
integer, intent(in) :: ncrows
!
integer :: jprime, p, j, curdeg, kj, kjp, l, jpm1, jm1
integer :: m, start, jindex, jpindx, q, j3, j1, j1mj2
integer, intent(inout) :: error
integer :: j0mj1, j1m1, starta
integer, intent(in) :: onplys
integer :: onpp1
integer, intent(inout) :: sttdeg
integer :: index1, index2
integer, intent(inout) :: degree, npolys
integer, intent(in) :: npts, dimen, psiwid, alfl
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
real, intent(inout) :: alpha(alfl)
real, intent(in) :: coord(ncrows,dimen)
real, intent(inout) :: psi(npts,psiwid)
real, intent(inout) :: sumsqs(npolys), c(npolys)
real, intent(in) :: f(npts), weight(npts)
real, intent(inout) :: z(npts)
real :: arc, runtot, rntot1, rntot2
!
!     ***************
!     Purpose
!     -------
!
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine continues the process started off by
!      GNRTP .
!
!     This subroutine is called by  GNRTP  and not by the user.
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
if ( onplys .ge. 1 .and. sttdeg .ge. 1 ) go to 10
   error = 6
return
10 if ( indexs(2,onplys) .eq. dimen ) go to 20
      curdeg = sttdeg
   go to 30
20 curdeg = sttdeg + 1
30 onpp1 = onplys + 1
do 170 j = onpp1,npolys
   jprime = indexs(1,j)
   jindex = j - ((j - 1) / psiwid) * psiwid
   jpindx = jprime - ((jprime - 1) / psiwid) * psiwid
   kj = indexs(2,j)
   start = indexs(3,j)
   m = start
   starta = indexs(4,j) - start
   if ( curdeg .eq. 1 ) go to 100
   kjp = indexs(2,jprime)
   j1 = newkj(kj,curdeg - 1)
!
!     ***************
!     Calculate those  alpha ( J , M ) that can be calculated from
!     previously calculated alphas.
!     ***************
!
   if ( kj .lt. kjp ) go to 50
!
!     ***************
!     First calculate those between  JPP  and the end of 2 rows back.
!     Calculate  alpha ( J , JPP )
!     ***************
!
   index1 = indexs(4,j)
   alpha(index1) = sumsqs(jprime) / sumsqs(start)
!
   m = start + 1
   j3 = newkj(1,curdeg - 1) - 1
   if ( m .gt. j3 ) go to 50
!
!     ***************
!     CURDEG .GT. 2 IF CONTROL HAS PASSED THE BRANCHES IN THE 3-RD
!     previous and 8-TH previous statements.
!     ***************
!
      j1mj2 = j1 - newkj(kj,curdeg - 2)
!
      do 40 l = m,j3
         q = j1mj2 + l
         index1 = starta + l
         index2 = indexs(4,q) - indexs(3,q) + jprime
40 alpha(index1) = alpha(index2) * sumsqs(jprime) / &
&sumsqs(l)
!
!     ***************
!     Calculate  alpha ( J , M ) for  M  between the 2
!     ranges calculated before using
!
!        ALPHA ( J , L ) = (X  *  PSI  ,PSI )  / (PSI ,PSI )
!                             K      JP    L         L    L
!                              J
!     ***************
!
   m = j3 + 1
50 if ( jprime .eq. j1 ) go to 100
      if ( kj .eq. 1 ) go to 80
      j1m1 = j1 - 1
      do 70 l = m,j1m1
         runtot = 0.0
         do 60 p = 1,npts
            index1 = l - ((l - 1) / psiwid) * psiwid
60 runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
&psi(p,index1) * weight(p)
         index1 = starta + l
70 alpha(index1) = runtot / sumsqs(l)
!
!     ***************
!     Calculate  alpha ( J , M ) for  M  between
!      NEWKJ ( KJ , CURDEG  - 1)  AND
!      JP  - 1.
!     ***************
!
80 j0mj1 = newkj(kj,curdeg) - j1
      jpm1 = jprime - 1
      do 90 l = j1,jpm1
         q = j0mj1 + l
         index1 = starta + l
         index2 = indexs(4,q) - indexs(3,q) + jprime
90 alpha(index1) = alpha(index2) * sumsqs(jprime) / &
&sumsqs(l)
      m = jprime
!
!     ***************
!     Calculate the remaining  alpha ( J , M ) from
!
!      ALPHA ( J , L ) = (X   * PSI  ,PSI ) / (PSI ,PSI )
!                          K       JP    L        L    L
!                           J
!     ***************
!
100 jm1 = j - 1
   do 120 l = m,jm1
      runtot = 0.0
      do 110 p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
110 runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
&psi(p,index1) * weight(p)
      index1 = starta + l
120 alpha(index1) = runtot / sumsqs(l)
!
!     ***************
!     Now calculate the  psi (P,J),  SUMSQS (J) and  C (J) using
!
!                          J-1
!     PSI  = X  * PSI   -  SUM   ALPHA(J,L) * PSI
!        J    K      JP    L=JPP                 L
!
!     SUMSQS  = (PSI ,PSI )
!           J       J    J
!
!     C  = (Z,PSI )
!      J         J
!     ***************
!
130 jm1 = j - 1
    arc = 0.0
    rntot1 = 0.0
    rntot2 = 0.0
    do 150 p = 1,npts
        runtot = coord(p,kj) * psi(p,jpindx)
        do 140 l = start,jm1
           index1 = starta + l
           index2 = l - ((l - 1) / psiwid) * psiwid
140 runtot = runtot - alpha(index1) * psi(p,index2)
        psi(p,jindex) = runtot
        arc = arc + psi(p,index2) * psi(p,jindex) * &
&weight(p)
        rntot1 = rntot1 + psi(p,jindex) * psi(p,jindex) * &
&weight(p)
150 rntot2 = rntot2 + z(p) * psi(p,jindex) * weight(p)
    if (arc * arc .ge. sumsqs(jm1) * rntot1 * 1.e-03) &
&go to 200
    sumsqs(j) = rntot1
    c(j) = rntot2 / rntot1
!
!     ***************
!     Calculate the new  Z ( P ) and the new  SSRES  using
!
!     Z = Z - C  * PSI
!              J      J
!     ***************
!
    do 160 p = 1,npts
160 z(p) = z(p) - c(j) * psi(p,jindex)
    sttdeg = curdeg
170 if ( kj .eq. dimen ) curdeg = curdeg + 1
return
!
!     ***************
!     The J-TH basis multinomial cannot be computed accurately.
!     Only J - 1 basis multinomials are generated.
!     ***************
!
200 error = -1
degree = sttdeg
npolys = jm1
return
end subroutine incdg

subroutine scalpm(coord,npts,maxabs)
implicit none
!
integer, intent(in) :: npts
integer :: p
real, intent(out) :: maxabs
real :: a
real, intent(in) :: coord(npts)
!
!     ***************
!     Purpose
!     -------
!
!     Find scaling PARAMETER(S) for the problem. If the scaling scheme
!     is changed, all four of the following would have to be changed
!
!     1)  SCALPM  - find the scaling parameters
!     2)  SCALDN  - scale the problem data
!     3)  the scaling of the residuals in  MFIT
!     4)  the scaling performed in  MEVAL1
!
!     This subroutine is called by  GNRTP .  It is not called  by  the
!     user.
!
!     The scaling which  it  defines  must  be  coordinated  with  the
!     scaling  of residuals which is carried out toward the end of the
!     subroutine  MFIT.  The scaling must also be coordinated with the
!     scaling performed in the 10 loop  and  at statements 40 and 50
!     (with the scale factor MAXABS(DIMP1)) in  MEVAL1.
!
!     ****************
!
maxabs = 0.0
do 10 p = 1,npts
   a = abs(coord(p))
10 if ( a .gt. maxabs ) maxabs = a
return
end subroutine scalpm

subroutine scaldn(coord,npts,maxabs)
implicit none
!
integer, intent(in) :: npts
integer :: p
real, intent(in) :: maxabs
real, intent(inout) :: coord(npts)
!
!     ***************
!     Purpose
!     -------
!
!     Carry out the data-scaling which is defined  by  the  subroutine
!     SCALPM .
!
!     This subroutine is called by  GNRTP .  It is not called  by  the
!     user.
!
!     The scaling which this routine carries out  must  be  consistent
!     with the scaling in the subroutines MFIT and MEVAL1.
!
!     ****************
!
if ( maxabs .eq. 0.0e+00 ) return
   do 10 p = 1,npts
10 coord(p) = coord(p) / maxabs
   return
end subroutine scaldn

subroutine meval(dimen,evldeg,nepols,nepts,evlcds,nerows,evlvls, &
&error,fitiwk,fitdwk,fiwkln,fdwkln,temp)
implicit none
integer, intent(in) :: nerows
!
integer, intent(in) :: fiwkln, fdwkln
integer, intent(inout) :: nepols
integer, intent(in) :: nepts, dimen
integer, intent(inout) :: error
integer :: maxstt, alfstt, cstt
integer :: gbasiz, alfl, dimp1
integer, intent(in) :: evldeg
integer :: top, bot, curdeg, psistt
integer, intent(in) :: fitiwk(fiwkln)
real, intent(inout) :: fitdwk(fdwkln)
real, intent(in) :: evlcds(nerows,dimen)
real, intent(inout) :: evlvls(nepts), temp(dimen)
!
!     ***************
!     Purpose
!     -------
!
!     This subroutine  evaluates  the  least-squares  multinomial  fit
!     which has been previously produced by  MFIT .  Either the full
!     multinomial as produced may be evaluated,  or  only  an  initial
!     segment thereof.  As in the case with  MFIT , it is possible
!     (1) to specify multinomials of a full given degree, or
!     (2) to specify  the  number  of  orthogonal  basis  elements  to
!         achieve a partial-degree fit.
!
!     In case (1), the  desired  degree  is  given  as  the  value  of
!     EVLDEG   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     value used for  FITDEG  in  MFIT ), and the parameter  NEPOLS
!     will  be  set  by  MEVAL  to specify the number of basis elements
!     REQUIRED. IF  EVLDEG  .LT.  FITDEG   IS  GIVEN,  THEN  ONLY  THE
!     initial  portion of the fitting multinomial (of degree  EVLDEG )
!     will be evaluated.
!
!     In case (2),  EVLDEG  is to be set negative, in which  case  the
!     VALUE  OF   NEPOLS  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   MFIT )  WILL  BE  TAKEN  AS
!     defining  the  initial  portion of the fitting multinomial to be
!     evaluated.
!
!     IF  NEPOLS  =  NFPOLS  (WITH  EVLDEG  .LT.  0),  OR   EVLDEG   =
!     FITDEG  (WITH   EVLDEG   .GT.  0),  THEN  THE  FULL  MULTINOMIAL
!     generated by  MFIT  will be evaluated.
!
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (collection  of  variable  values)  given as a row of the matrix
!      EVLCDS .  The  values  produced  from  the  full,  or  partial,
!     multinomial will be placed in the array  EVLVLS .
!
!     Variables
!     ---------
!
!      DIMEN  -- (INTEGER) -- (passed)
!         the number of variables.
!      EVLDEG  -- (INTEGER) -- (passed)
!         IF  EVLDEG  .LT. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF  EVLDEG  .GE. 0, THEN THE VALUE OF  EVLDEG  MUST  SATISFY
!         EVLDEG  .LE. (THE  DEGREE  OF THE APPROXIMATING MULTINOMIAL
!         generated in  MFIT ).  In this case  EVLDEG  will  specify
!         the degree of the initial portion of the fitting multinomial
!         to be evaluated.
!      NEPOLS  -- (INTEGER) -- (PASSED/RETURNED)
!         IF  EVLDEG  .GE. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF EVLDEG .LT. 0, THEN THE PARTIAL MULTINOMIAL INVOLVING THE
!         FIRST   NEPOLS  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         at the points given by  EVLCDS .  The resulting values  will
!         be stored in  EVLVLS .
!         THE VALUE OF NEPOLS MUST BE .GE. 1 AND .LE. (THE SIZE OF THE
!         BASIS  GENERATED  IN   MFIT ),  WHICH  WAS RETURNED AS THE
!         value of  NFPOLS .
!         NEPOLS  WILL BE CHANGED IF EVLDEG .GT. 0 TO GIVE THE SIZE OF
!         basis required for the multinomial of degree  EVLDEG .
!      NEPTS  -- (INTEGER) -- (passed)
!         the number of evaluation points.
!      EVLCDS  -- (real 2-subscript array) -- (passed)
!         EVLCDS (P,K) is the value of the K-TH variable at the  P-TH
!         evaluation point.
!      NEROWS  -- (INTEGER) -- (passed)
!         the row dimension declared for EVLCDS in the calling program.
!      EVLVLS  -- (INTEGER) -- (returned)
!         EVLVLS (P) is the value of the evaluated multinomial at the
!         P-TH evaluation point.
!      Error  -- (INTEGER) -- (returned)
!          0 .........  if no errors
!         -1 .........  IF  NEPOLS  .GT.  NFPOLS  OR  NEPOLS  .LT. 1
!         -2 .........  IF  NEPTS  .LT. 1 OR  DIMEN  .LT. 1
!      FITIWK  -- (integer, 1-subscript array) -- (passed)
!         the integer work array of length  FIWKLN  that was  used  in
!          MFIT .
!      FITDWK  -- (real 2-subscript array) -- (passed)
!         the real work array of length  FDWKLN  that was
!         used in  MFIT .
!      FIWKLN  -- (INTEGER) -- (passed)
!         the length of  FITIWK .
!      FDWKLN  -- (INTEGER) -- (passed)
!         the length of  FITDWK .
!      TEMP    -- (REAL 1-SUBSCRIPT ARRAY)
!         a work array of length  DIMEN  (or longer).
!
!     The subroutine  MEVAL1  is called to do the actual evaluation.
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
!
!     ***************
!     Set up index pointers to the beginning of each row of
!     the MTABLE -- this sets the beginning point for each
!     full multinomial degree.
!     ***************
!
if (nepts .lt. 1 .or. dimen .lt. 1) go to 110
if (evldeg) 40,10,20
!
10 nepols = 1
go to 50
!
20 top = 1
bot = 1
do 30 curdeg = 1,evldeg
   top = top * (dimen + curdeg)
30 bot = bot * curdeg
nepols = top / bot
!
40 gbasiz = fitiwk(1)
if (nepols .gt. gbasiz .or. nepols .lt. 1) go to 100
!
50 error = 0
dimp1 = dimen + 1
alfl = fitiwk(4)
maxstt = 1
alfstt = dimp1 + maxstt
cstt = alfstt + alfl
psistt = cstt + fitiwk(2)
!
!     ***************
!     The actual evaluation is done inside  MEVAL1.
!     ***************
!
call meval1 (evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
&fitdwk(alfstt),fitiwk,fitdwk(psistt), &
&evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!
!     ***************
!     Error return
!     ***************
!
100 error = -1
return
110 error = -2
return
end subroutine meval

subroutine meval1 (coord,ncrows,c,nepts,dimen,npolys,alpha, &
&indexs,psi,f,alfl,maxabs,x,dimp1)
implicit none
integer, intent(in) :: ncrows
!
integer, intent(in) :: dimen, nepts, npolys, alfl, dimp1
integer :: jm1, jprime, m, p, k, i, j, index
integer, intent(in) :: indexs(4,npolys)
real, intent(in) :: alpha(alfl), coord(ncrows,dimen)
real, intent(inout) :: psi(npolys)
real, intent(in) :: c(npolys)
real, intent(inout) :: f(nepts)
real, intent(in) :: maxabs(dimp1)
real, intent(inout) :: x(dimen)
real :: runtot, rntot1
!
!     ***************
!     Purpose
!     -------
!
!     This subroutine performs the main work of evaluating the
!     fitting multinomial (or the initial portion of it  which
!     is requested by the setting of  NEPOLS ,  EVLDEG  in the
!     CALL TO SUBROUTINE  MEVAL .
!
!     This subroutine is called by  MEVAL .  It is  not  called
!     directly by the user.
!
!     The body of this subroutine FOLLOWS the explanation
!     given in
!          least squares fitting using
!          orthogonal multinomials
!     by
!          Bartels and Jezioranski
!     in
!          ACM transactions on mathematical software
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
if (npolys .eq. 1) go to 50
!
psi(1) = 1.0
do 40 p = 1,nepts
!
!     ***************
!     Scale the coordinates of the P-TH point
!     ***************
!
   do k = 1,dimen
        x(k) = coord(p,k)
        if (maxabs(k) .ne. 0.0) x(k) = x(k) / maxabs(k)
   end do
!
!     ***************
!     Use the  basis function coefficients  C  and recurrence
!     coefficients  alpha  to evaluate the fitted multinomial
!     at the P-TH point.
!     ***************
!
   rntot1 = c(1)
   do 30 j = 2,npolys
        k = indexs(2,j)
        jprime = indexs(1,j)
        runtot = x(k) * psi(jprime)
        i = indexs(3,j)
        jm1 = j - 1
        do 20 m = i,jm1
           index = indexs(4,j) + m - i
20 runtot = runtot - psi(m) * alpha(index)
        psi(j) = runtot
30 rntot1 = rntot1 + c(j) * psi(j)
40 f(p) = rntot1 * maxabs(dimp1)
return
!
!     ***************
!     Compute the degree 0 polynomial
!     ***************
!
50 runtot = c(1) * maxabs(dimp1)
do 60 p = 1,nepts
60 f(p) = runtot
return
end subroutine meval1

subroutine dmfit(dimen,fitdeg,nfpols,nfpts, &
&fitcds,ncrows,fitvls,wts, &
&resids,error,fitiwk,fitdwk, &
&fiwkln,fdwkln,ireqd,dreqd)
implicit none
!
integer, intent(inout) :: nfpols, fitdeg
integer, intent(in) :: nfpts, dimen, fiwkln, fdwkln
integer, intent(inout) :: error, ireqd, dreqd
integer :: indstt, p, dimp1
integer, intent(in) :: ncrows
integer :: newstt, maxstt, alfstt, psistt, cstt, ssqstt, psiwid, &
&alfl
integer, intent(inout) :: fitiwk(fiwkln)
double precision, intent(inout) :: fitdwk(fdwkln), &
&fitcds(ncrows,dimen)
double precision, intent(inout) :: fitvls(nfpts), resids(nfpts)
double precision, intent(in) :: wts(nfpts)
double precision :: scale
!
!     ***************
!     Purpose
!     -------
!
!     This subroutine constructs a least-squares  multinomial  fit  to
!     given data using a basis of orthogonal multinomials. The computa-
!     tion is performed in double precision.
!
!     The data for the fit is given in the arrays FITCDS, FITVLS, and
!     WTS. FITCDS is a matrix, each row of which contains an observa-
!     tion point. FITVLS is a singly-indexed array, each element of
!     which contains a function VALUE corresponding to an observation
!     point. WTS is a singly-indexed array, each element of which is
!     a nonnegative weight for the corresponding observation.
!
!     The fit which is produced is a multinomial expressed in the form
!
!      C  PSI  (X ,...,X     ) +...+ C       PSI       (X ,...,X     )
!       1    1   1      DIMEN         NFPOLS    NFPOLS   1      DIMEN
!
!     WHERE THE VALUE OF  NFPOLS  WILL BE AS GIVEN (IF  FITDEG .LT. 0)
!     or  as  computed  by  DMFIT  to give a full-degree fit (in case
!     FITDEG  IS SPECIFIED .GE. 0).  THE ELEMENTS
!
!         PSI  (X ,...,X     )
!            K   1      DIMEN
!
!     Form a basis for the multinomials which is orthogonal with
!     respect to the weights and observation points.
!
!     The extent of the fit can be specified in one of two ways.
!         IF THE PARAMETER FITDEG IS SET .GE. 0, THEN A COMPLETE BASIS
!         FOR THE MULTINOMIALS OF DEGREE =  FITDEG  WILL BE USED.  (AN
!         error will be  flagged  if  this  will  require  more  basis
!         multinomials  than  the  number  of  data  points which were
!         given.)
!         IF THE PARAMETER  FITDEG  IS .LT.  0, THEN  NFPOLS  WILL  BE
!         taken as the count of the number of basis multinomials to be
!         used for a partial-degree fit.  (An error will be flagged if
!         NFPOLS  .LT. 0.)
!
!     Variables
!     ---------
!
!      DIMEN  -- (INTEGER) -- (passed)
!         the number of variables.
!      FITDEG  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF .LT. 0.
!         IF FITDEG .GE. 0 THEN  FITDEG  IS  CHECKED  AGAINST  NFPTS .
!         The value of  FITDEG  will be reduced if there is a basis of
!         MULTINOMIALS, ALL OF  DEGREE  .LE. FITDEG ,  OF  CARDINALITY
!         NFPTS .  See  error  below.
!      NFPOLS  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF  FITDEG  .GE. 0.
!         IF  FITDEG .LT. 0 THEN THE VALUE OF NFPOLS WILL BE TAKEN  AS
!         the size of the basis of multinomials to be used in the fit.
!         NFPOLS  MUST SATISFY  NFPOLS  .LT. NFPTS  AND NFPOLS .GE. 1
!         see  error  below.
!      NFPTS  --- (INTEGER) -- (passed)
!         the number of data points to be used in the fit.
!         NFPTS  MUST BE .GE. 1.  SEE  ERROR  BELOW.
!      FITCDS  -- (double precision 2-subscript array) -- (passed)
!         FITCDS (P,K) is the value of the K-TH variable at the  P-TH
!         data point.
!      NCROWS  -- (INTEGER) -- (passed)
!         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!         program.
!      FITVLS  -- (double precision 1-subscript array) -- (passed)
!         FITVLS (P) is the observed function VALUE of the P-TH  data
!         point.
!      WTS  ----- (double precision 1-subscript array) -- (passed)
!         WTS (P) is the weight attached to the P-TH data point.
!      RESIDS  -- (double precision 1-subscript array) -- (returned)
!         RESIDS (P) is the difference between the fitted function at
!         point P and  FITVLS (P).
!      Error  -- (INTEGER) -- (returned)
!       0 the desired least square multinomial fit was obtained.
!      -1 Only the first NFPOLS basis polynomials were obtained.
!         FITDEG is the degree of the fit.
!       1 IF  FITDEG  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
!         OF SMALLER DEGREE OR IF FITDEG .LT. 0 AND NFPOLS .GT. NFPTS.
!       2 IF  FITDEG  .LT. 0 AND  NFPOLS  .LE. 0.
!       3 IF  NFPTS  .LT. 1 AND/OR  DIMEN  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         the value returned in  IREQD , and set  DWKLEN  to the value
!         returned in  DREQD  to resolve this problem.)
!      FITIWK  -- (integer, 1-subscript array) -- (returned)
!         an integer work array of length  FIWKLN .  Upon return  from
!         DMFIT, FITIWK contains dimension and array LENGTH information.
!      FITDWK  -- (double precision 1-subscript array) -- (returned)
!         an array of length  FDWKLN  containing the coefficients
!         needed for computing the multinomial fit at a point.
!      FIWKLN  -- (INTEGER) -- (passed)
!         the length of the array  FITIWK .
!      FDWKLN  -- (INTEGER) -- (passed)
!         the length of the array  FITDWK .
!      IREQD  -- (INTEGER) -- (returned)
!         the length which the array  FITIWK  really needs to be.
!      DREQD  -- (INTEGER) -- (returned)
!         the length which the array  FITDWK  really needs to be.
!
!
!     Note. The 20 loop depends on the scaling scheme being used. The
!     residual scaling must be consistent with that defined by DSCALP
!     AND DSCALD.
!
!     DMFIT  calls  allot  and  DGNRTP.
!     ****************
!
dimp1 = dimen + 1
!
!     ***************
!
call allot(fitdeg,nfpols,nfpts,dimen,fitiwk,fiwkln,ireqd,dreqd, &
&error)
if ( error .ge. 2 ) return
!
if ( fdwkln .ge. dreqd ) go to 10
   error = 4
   return
10 continue
!
psiwid = fitiwk(3)
alfl = fitiwk(4)
indstt = 1
newstt = 4 * nfpols + indstt
maxstt = 1
alfstt = maxstt + dimp1
cstt = alfstt + alfl
ssqstt = cstt + nfpols
psistt = ssqstt + nfpols
!
!     ***************
!
   call dgnrtp(fitdeg,fitdwk(alfstt), &
&fitdwk(psistt),fitiwk(indstt), &
&fitiwk(newstt),fitdwk(ssqstt),fitcds, &
&ncrows,nfpols,dimen,nfpts,fitvls,resids, &
&fitdwk(cstt),psiwid,wts,alfl,dimp1, &
&fitdwk(maxstt),error)
!
!     ***************
!     Store the number of basis polynomials actually computed
!     by the modified routine DINCDG called by DGNRTP.
!     ***************
!
fitiwk(1) = nfpols
!
!     ***************
!     Unscale the residuals for the benefit of the user.
!     ***************
!
scale = fitdwk(dimen + 1)
do p = 1,nfpts
  resids(p) = resids(p) * scale
end do
return
end subroutine dmfit

subroutine dgnrtp(degree,alpha,psi,indexs, &
&newkj,sumsqs,coord,ncrows,npolys, &
&dimen,npts,f,z,c,psiwid,weight, &
&alfl,dimp1,maxabs,error)
implicit none
integer, intent(in) :: ncrows
!
integer, intent(inout) :: degree
integer, intent(in) :: dimen
integer, intent(inout) :: npolys
integer, intent(in) :: npts
integer :: k
integer, intent(in) :: psiwid, alfl
integer :: p, sttdeg, onplys
integer, intent(inout) :: error
integer :: dimp1
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
double precision, intent(inout) :: psi(npts,psiwid), alpha(alfl), &
&f(npts)
double precision, intent(inout) :: coord(ncrows,dimen), &
&maxabs(dimp1)
double precision, intent(in) :: weight(npts)
double precision, intent(inout) :: z(npts), sumsqs(npolys), &
&c(npolys)
double precision :: runtot, rntot1
!
!     ***************
!     Purpose
!     -------
!
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine starts the process off by setting up
!     the first basis element, scaling the  data,  finding  the  first
!     coefficient,  and  initializing  the  work array Z.  DGNRTP then
!     calls  DINCDG  if more than one basis element is required.
!
!     This subroutine is called by  DMFIT .  It is not called by  the
!     user.
!
!     This subroutine calls  DSCALP ,  DSCALD , and  DINCDG .
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!     ****************
!
!     ***************
!     Set up the scaling.
!     ***************
!
do 10 k = 1,dimen
   call dscalp(coord(1,k),npts,maxabs(k))
10 call dscald(coord(1,k),npts,maxabs(k))
call dscalp(f,npts,maxabs(dimp1))
call dscald(f,npts,maxabs(dimp1))
!
!     ***************
!      SUMSQS (1) = (1,1)
!     C  = (F,1) / (1,1)
!      1
!     ***************
!
runtot = 0.d0
rntot1 = 0.d0
do 20 p = 1,npts
   psi(p,1) = 1.d0
   rntot1 = rntot1 + weight(p)
20 runtot = runtot + f(p) * weight(p)
sumsqs(1) = rntot1
c(1) = runtot / rntot1
!
!     ***************
!     Z = F - C
!              1
!     ***************
!
do 30 p = 1,npts
30 z(p) = f(p) - c(1)
!
if ( npolys .eq. 1 ) return
sttdeg = 1
onplys = 1
!
call dincdg(degree,alpha,psi,indexs,newkj,sumsqs, &
&coord,ncrows,npolys,dimen,npts,f,z,c,psiwid, &
&weight,alfl,onplys,sttdeg,error)
return
end subroutine dgnrtp

subroutine dincdg(degree,alpha,psi,indexs,newkj, &
&sumsqs,coord,ncrows,npolys, &
&dimen,npts,f,z,c,psiwid,weight, &
&alfl,onplys,sttdeg,error)
implicit none
integer, intent(in) :: ncrows
!
integer :: jprime, p, j, curdeg, kj, kjp, l, jpm1, jm1
integer :: m, start, jindex, jpindx, q, j3, j1, j1mj2
integer, intent(inout) :: error
integer :: j0mj1, j1m1, starta
integer, intent(in) :: onplys
integer :: onpp1
integer, intent(inout) :: sttdeg
integer :: index1, index2
integer, intent(inout) :: degree, npolys
integer, intent(in) :: npts, dimen, psiwid, alfl
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
double precision, intent(inout) :: alpha(alfl)
double precision, intent(in) :: coord(ncrows,dimen)
double precision, intent(inout) :: psi(npts,psiwid)
double precision, intent(inout) :: sumsqs(npolys), c(npolys)
double precision, intent(in) :: f(npts), weight(npts)
double precision, intent(inout) :: z(npts)
double precision :: arc, runtot, rntot1, rntot2
!
!     ***************
!     Purpose
!     -------
!
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine continues the process started off by
!      DGNRTP .
!
!     This subroutine is called by  DGNRTP  and not by the user.
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
if ( onplys .ge. 1 .and. sttdeg .ge. 1 ) go to 10
   error = 6
return
10 if ( indexs(2,onplys) .eq. dimen ) go to 20
      curdeg = sttdeg
   go to 30
20 curdeg = sttdeg + 1
30 onpp1 = onplys + 1
do 170 j = onpp1,npolys
   jprime = indexs(1,j)
   jindex = j - ((j - 1) / psiwid) * psiwid
   jpindx = jprime - ((jprime - 1) / psiwid) * psiwid
   kj = indexs(2,j)
   start = indexs(3,j)
   m = start
   starta = indexs(4,j) - start
   if ( curdeg .eq. 1 ) go to 100
   kjp = indexs(2,jprime)
   j1 = newkj(kj,curdeg - 1)
!
!     ***************
!     Calculate those  alpha ( J , M ) that can be calculated from
!     previously calculated alphas.
!     ***************
!
   if ( kj .lt. kjp ) go to 50
!
!     ***************
!     First calculate those between  JPP  and the end of 2 rows back.
!     Calculate  alpha ( J , JPP )
!     ***************
!
   index1 = indexs(4,j)
   alpha(index1) = sumsqs(jprime) / sumsqs(start)
!
   m = start + 1
   j3 = newkj(1,curdeg - 1) - 1
   if ( m .gt. j3 ) go to 50
!
!     ***************
!     CURDEG .GT. 2 IF CONTROL HAS PASSED THE BRANCHES IN THE 3-RD
!     previous and 8-TH previous statements.
!     ***************
!
      j1mj2 = j1 - newkj(kj,curdeg - 2)
!
      do 40 l = m,j3
         q = j1mj2 + l
         index1 = starta + l
         index2 = indexs(4,q) - indexs(3,q) + jprime
40 alpha(index1) = alpha(index2) * sumsqs(jprime) / &
&sumsqs(l)
!
!     ***************
!     Calculate  alpha ( J , M ) for  M  between the 2
!     ranges calculated before using
!
!        ALPHA ( J , L ) = (X  *  PSI  ,PSI )  / (PSI ,PSI )
!                             K      JP    L         L    L
!                              J
!     ***************
!
   m = j3 + 1
50 if ( jprime .eq. j1 ) go to 100
      if ( kj .eq. 1 ) go to 80
      j1m1 = j1 - 1
      do 70 l = m,j1m1
         runtot = 0.d0
         do 60 p = 1,npts
            index1 = l - ((l - 1) / psiwid) * psiwid
60 runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
&psi(p,index1) * weight(p)
         index1 = starta + l
70 alpha(index1) = runtot / sumsqs(l)
!
!     ***************
!     Calculate  alpha ( J , M ) for  M  between
!      NEWKJ ( KJ , CURDEG  - 1)  AND
!      JP  - 1.
!     ***************
!
80 j0mj1 = newkj(kj,curdeg) - j1
      jpm1 = jprime - 1
      do 90 l = j1,jpm1
         q = j0mj1 + l
         index1 = starta + l
         index2 = indexs(4,q) - indexs(3,q) + jprime
90 alpha(index1) = alpha(index2) * sumsqs(jprime) / &
&sumsqs(l)
      m = jprime
!
!     ***************
!     Calculate the remaining  alpha ( J , M ) from
!
!      ALPHA ( J , L ) = (X   * PSI  ,PSI ) / (PSI ,PSI )
!                          K       JP    L        L    L
!                           J
!     ***************
!
100 jm1 = j - 1
   do 120 l = m,jm1
      runtot = 0.d0
      do 110 p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
110 runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
&psi(p,index1) * weight(p)
      index1 = starta + l
120 alpha(index1) = runtot / sumsqs(l)
!
!     ***************
!     Now calculate the  psi (P,J),  SUMSQS (J) and  C (J) using
!
!                          J-1
!     PSI  = X  * PSI   -  SUM   ALPHA(J,L) * PSI
!        J    K      JP    L=JPP                 L
!
!     SUMSQS  = (PSI ,PSI )
!           J       J    J
!
!     C  = (Z,PSI )
!      J         J
!     ***************
!
130 jm1 = j - 1
    arc = 0.d0
    rntot1 = 0.d0
    rntot2 = 0.d0
    do 150 p = 1,npts
        runtot = coord(p,kj) * psi(p,jpindx)
        do 140 l = start,jm1
           index1 = starta + l
           index2 = l - ((l - 1) / psiwid) * psiwid
140 runtot = runtot - alpha(index1) * psi(p,index2)
        psi(p,jindex) = runtot
        arc = arc + psi(p,index2) * psi(p,jindex) * &
&weight(p)
        rntot1 = rntot1 + psi(p,jindex) * psi(p,jindex) * &
&weight(p)
150 rntot2 = rntot2 + z(p) * psi(p,jindex) * weight(p)
    if (arc * arc .ge. sumsqs(jm1) * rntot1 * 1.d-06) &
&go to 200
    sumsqs(j) = rntot1
    c(j) = rntot2 / rntot1
!
!     ***************
!     Calculate the new  Z ( P ) and the new  SSRES  using
!
!     Z = Z - C  * PSI
!              J      J
!     ***************
!
    do 160 p = 1,npts
160 z(p) = z(p) - c(j) * psi(p,jindex)
    sttdeg = curdeg
170 if ( kj .eq. dimen ) curdeg = curdeg + 1
return
!
!     ***************
!     The J-TH basis multinomial cannot be computed accurately.
!     Only J - 1 basis multinomials are generated.
!     ***************
!
200 error = -1
degree = sttdeg
npolys = jm1
return
end subroutine dincdg

subroutine dscalp(coord,npts,maxabs)
implicit none
!
integer, intent(in) :: npts
integer :: p
double precision, intent(out) :: maxabs
double precision :: a
double precision, intent(in) :: coord(npts)
!
!     ***************
!     Purpose
!     -------
!
!     Find scaling PARAMETER(S) for the problem. If the scaling scheme
!     is changed, all four of the following would have to be changed
!
!     1)  DSCALP  - find the scaling parameters
!     2)  DSCALD  - scale the problem data
!     3)  the scaling of the residuals in  DMFIT
!     4)  the scaling performed in  DMEVL1
!
!     This subroutine is called by  DGNRTP .  It is not called  by  the
!     user.
!
!     The scaling which  it  defines  must  be  coordinated  with  the
!     scaling  of residuals which is carried out toward the end of the
!     subroutine  DMFIT.  The scaling must also be coordinated with the
!     scaling performed in the 10 loop  and  at statements 40 and 50
!     (with the scale factor MAXABS(DIMP1)) in  DMEVL1.
!
!     ****************
!
maxabs = 0.d0
do 10 p = 1,npts
   a = dabs(coord(p))
10 if ( a .gt. maxabs ) maxabs = a
return
end subroutine dscalp

subroutine dscald(coord,npts,maxabs)
implicit none
!
integer, intent(in) :: npts
integer :: p
double precision, intent(in) :: maxabs
double precision, intent(inout) :: coord(npts)
!
!     ***************
!     Purpose
!     -------
!
!     Carry out the data-scaling which is defined  by  the subroutine
!     DSCALP .
!
!     This subroutine is called by  DGNRTP .  It is not called by the
!     user.
!
!     The scaling which this routine carries out must  be  consistent
!     with the scaling in the subroutines DMFIT and DMEVL1.
!
!     ****************
!
if ( maxabs .eq. 0.0d+00 ) return
   do 10 p = 1,npts
10 coord(p) = coord(p) / maxabs
   return
end subroutine dscald

subroutine dmeval(dimen,evldeg,nepols,nepts,evlcds,nerows,evlvls, &
&error,fitiwk,fitdwk,fiwkln,fdwkln,temp)
implicit none
integer, intent(in) :: nerows
!
integer, intent(in) :: fiwkln, fdwkln
integer, intent(inout) :: nepols
integer, intent(in) :: nepts, dimen
integer, intent(inout) :: error
integer :: maxstt, alfstt, cstt
integer :: gbasiz, alfl, dimp1
integer, intent(in) :: evldeg
integer :: top, bot, curdeg, psistt
integer, intent(in) :: fitiwk(fiwkln)
double precision, intent(inout) :: fitdwk(fdwkln)
double precision, intent(in) :: evlcds(nerows,dimen)
double precision, intent(inout) :: evlvls(nepts), temp(dimen)
!
!     ***************
!     Purpose
!     -------
!
!     This subroutine  evaluates  the  least-squares  multinomial  fit
!     which has been previously produced by  DMFIT .  The computation
!     is performed in double precision. Either the full
!     multinomial as produced may be evaluated,  or  only  an  initial
!     segment thereof.  As in the case with  DMFIT , it is possible
!     (1) to specify multinomials of a full given degree, or
!     (2) to specify  the  number  of  orthogonal  basis  elements  to
!         achieve a partial-degree fit.
!
!     In case (1), the  desired  degree  is  given  as  the  value  of
!     EVLDEG   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     value used for  FITDEG  in  DMFIT ), and the parameter  NEPOLS
!     will be set  by  DMEVAL  to specify the number of basis elements
!     REQUIRED. IF  EVLDEG  .LT.  FITDEG   IS  GIVEN,  THEN  ONLY  THE
!     initial  portion of the fitting multinomial (of degree  EVLDEG )
!     will be evaluated.
!
!     In case (2),  EVLDEG  is to be set negative, in which  case  the
!     VALUE  OF   NEPOLS  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   DMFIT )  WILL  BE  TAKEN  AS
!     defining  the  initial  portion of the fitting multinomial to be
!     evaluated.
!
!     IF  NEPOLS  =  NFPOLS  (WITH  EVLDEG  .LT.  0),  OR   EVLDEG   =
!     FITDEG  (WITH   EVLDEG   .GT.  0),  THEN  THE  FULL  MULTINOMIAL
!     generated by  DMFIT  will be evaluated.
!
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (collection  of  variable  values)  given as a row of the matrix
!      EVLCDS .  The  values  produced  from  the  full,  or  partial,
!     multinomial will be placed in the array  EVLVLS .
!
!     Variables
!     ---------
!
!      DIMEN  -- (INTEGER) -- (passed)
!         the number of variables.
!      EVLDEG  -- (INTEGER) -- (passed)
!         IF  EVLDEG  .LT. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF  EVLDEG  .GE. 0, THEN THE VALUE OF  EVLDEG  MUST  SATISFY
!         EVLDEG  .LE. (THE  DEGREE  OF THE APPROXIMATING MULTINOMIAL
!         generated in  DMFIT ).  In this case  EVLDEG  will  specify
!         the degree of the initial portion of the fitting multinomial
!         to be evaluated.
!      NEPOLS  -- (INTEGER) -- (PASSED/RETURNED)
!         IF  EVLDEG  .GE. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF EVLDEG .LT. 0, THEN THE PARTIAL MULTINOMIAL INVOLVING THE
!         FIRST   NEPOLS  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         at the points given by  EVLCDS .  The resulting values  will
!         be stored in  EVLVLS .
!         THE VALUE OF NEPOLS MUST BE .GE. 1 AND .LE. (THE SIZE OF THE
!         BASIS  GENERATED  IN   DMFIT ),  WHICH  WAS RETURNED AS THE
!         value of  NFPOLS .
!         NEPOLS  WILL BE CHANGED IF EVLDEG .GT. 0 TO GIVE THE SIZE OF
!         basis required for the multinomial of degree  EVLDEG .
!      NEPTS  -- (INTEGER) -- (passed)
!         the number of evaluation points.
!      EVLCDS  -- (double precision 2-subscript array) -- (passed)
!         EVLCDS (P,K) is the value of the K-TH variable at the  P-TH
!         evaluation point.
!      NEROWS  -- (INTEGER) -- (passed)
!         the row dimension declared for EVLCDS in the calling program.
!      EVLVLS  -- (INTEGER) -- (returned)
!         EVLVLS (P) is the value of the evaluated multinomial at the
!         P-TH evaluation point.
!      Error  -- (INTEGER) -- (returned)
!          0 .........  if no errors
!         -1 .........  IF  NEPOLS  .GT.  NFPOLS  OR  NEPOLS  .LT. 1
!         -2 .........  IF  NEPTS  .LT. 1 OR  DIMEN  .LT. 1
!      FITIWK  -- (integer, 1-subscript array) -- (passed)
!         the integer work array of length  FIWKLN  that was  used  in
!          DMFIT .
!      FITDWK  -- (double precision 2-subscript array) -- (passed)
!         the real work array of length  FDWKLN  that was
!         used in  DMFIT .
!      FIWKLN  -- (INTEGER) -- (passed)
!         the length of  FITIWK .
!      FDWKLN  -- (INTEGER) -- (passed)
!         the length of  FITDWK .
!      TEMP    -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY)
!         a work array of length  DIMEN  (or longer).
!
!     The subroutine  DMEVL1  is called to do the actual evaluation.
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
!
!     ***************
!     Set up index pointers to the beginning of each row of
!     the MTABLE -- this sets the beginning point for each
!     full multinomial degree.
!     ***************
!
if (nepts .lt. 1 .or. dimen .lt. 1) go to 110
if (evldeg) 40,10,20
!
10 nepols = 1
go to 50
!
20 top = 1
bot = 1
do 30 curdeg = 1,evldeg
   top = top * (dimen + curdeg)
30 bot = bot * curdeg
nepols = top / bot
!
40 gbasiz = fitiwk(1)
if (nepols .gt. gbasiz .or. nepols .lt. 1) go to 100
!
50 error = 0
dimp1 = dimen + 1
alfl = fitiwk(4)
maxstt = 1
alfstt = dimp1 + maxstt
cstt = alfstt + alfl
psistt = cstt + fitiwk(2)
!
!     ***************
!     The actual evaluation is done inside  DMEVL1.
!     ***************
!
call dmevl1 (evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
&fitdwk(alfstt),fitiwk,fitdwk(psistt), &
&evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!
!     ***************
!     Error return
!     ***************
!
100 error = -1
return
110 error = -2
return
end subroutine dmeval

subroutine dmevl1 (coord,ncrows,c,nepts,dimen,npolys,alpha, &
&indexs,psi,f,alfl,maxabs,x,dimp1)
implicit none
integer, intent(in) :: ncrows
!
integer, intent(in) :: dimen, nepts, npolys, alfl, dimp1
integer :: jm1, jprime, m, p, k, i, j, index
integer, intent(in) :: indexs(4,npolys)
double precision, intent(in) :: alpha(alfl), coord(ncrows,dimen)
double precision, intent(inout) :: psi(npolys)
double precision, intent(in) :: c(npolys)
double precision, intent(inout) :: f(nepts)
double precision, intent(in) :: maxabs(dimp1)
double precision, intent(inout) :: x(dimen)
double precision :: runtot, rntot1
!
!     ***************
!     Purpose
!     -------
!
!     This subroutine performs the main work of evaluating the
!     fitting multinomial (or the initial portion of it  which
!     is requested by the setting of  NEPOLS ,  EVLDEG  in the
!     CALL TO SUBROUTINE  DMEVAL .
!
!     This subroutine is called by  DMEVAL .  It is  not  called
!     directly by the user.
!
!     The body of this subroutine FOLLOWS the explanation
!     given in
!          least squares fitting using
!          orthogonal multinomials
!     by
!          Bartels and Jezioranski
!     in
!          ACM transactions on mathematical software
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
if (npolys .eq. 1) go to 50
!
psi(1) = 1.d0
do 40 p = 1,nepts
!
!     ***************
!     Scale the coordinates of the P-TH point
!     ***************
!
   do k = 1,dimen
        x(k) = coord(p,k)
        if (maxabs(k) .ne. 0.d0) x(k) = x(k) / maxabs(k)
   end do
!
!     ***************
!     Use the  basis function coefficients  C  and recurrence
!     coefficients  alpha  to evaluate the fitted multinomial
!     at the P-TH point.
!     ***************
!
   rntot1 = c(1)
   do 30 j = 2,npolys
        k = indexs(2,j)
        jprime = indexs(1,j)
        runtot = x(k) * psi(jprime)
        i = indexs(3,j)
        jm1 = j - 1
        do 20 m = i,jm1
           index = indexs(4,j) + m - i
20 runtot = runtot - psi(m) * alpha(index)
        psi(j) = runtot
30 rntot1 = rntot1 + c(j) * psi(j)
40 f(p) = rntot1 * maxabs(dimp1)
return
!
!     ***************
!     Compute the degree 0 polynomial
!     ***************
!
50 runtot = c(1) * maxabs(dimp1)
do 60 p = 1,nepts
60 f(p) = runtot
return
end subroutine dmevl1

real function qsuba (f, a, b, epsil, mcount, relerr, ind)
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: mcount
real, intent(in) :: a, b, epsil
real, intent(inout) :: relerr
integer :: icheck, is, ismax, k, nf, npts
real :: eps, err, result(8), stack(100), sub1, sub2, sub3, sum, &
&tol, x
real :: f, spmpar
!-----------------------------------------------------------------------
!
!                Integration over a finite interval
!
!                          ----------
!
!     QSUBA computes the integral of F(X) from A to B where the
!     relative error does not exceed EPSIL.
!
!     MCOUNT is the maximum number of points at which F(X) may be
!     evaluated.
!
!     RELERR is a variable. When QSUBA terminates, if the value
!     of the integral is nonzero then RELERR is a crude estimate
!     OF THE RELATIVE ERROR OF THE VALUE. OTHERWISE, IF QSUBA = 0
!     then RELERR is an estimate of the absolute error.
!
!     Ind is a variable. When QSUBA terminates, ind has one of the
!     following values ...
!
!     IND=0   QSUBA IS SATISFIED THAT THE INTEGRAL HAS BEEN
!             computed to the desired accuracy.
!     IND=1   THE INTEGRAL HAS BEEN COMPUTED, BUT QSUBA IS
!             not certain of the accuracy of the result.
!     IND=2   THE INTEGRAND HAS BEEN EVALUATED AT MCOUNT
!             points. If more evaluations are needed then
!             QSUBA TERMINATES.
!     IND=3   QSUBA CANNOT COMPUTE THE INTEGRAL TO THE DESIRED
!             accuracy. Ind is set to 3 whenever the stack of
!             intervals becomes full (it currently can hold 50
!             intervals). A result is obtained by continuing
!             the integration ignoring convergence failures
!             which cannot be accommodated on the stack.
!
!     The reliability of the algorithm decreases for large values
!     of EPSIL. It is recommended that EPSIL be less than 0.001.
!
!-----------------------------------------------------------------------
external f
data ismax/100/
!-----------------------------------------------------------------------
!
!     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.0 + EPS .GT. 1.0.
!
                eps = spmpar(1)
!
!-----------------------------------------------------------------------
qsuba = 0.0
relerr = 0.0
ind = 0
if (a .eq. b) return
!
!     Apply quad to the entire interval
!
sub1 = amin1(a,b)
sub3 = amax1(a,b)
tol = amax1(epsil, 10.0*eps)
call quad (sub1, sub3, result, k, tol, npts, icheck, f)
if (icheck .eq. 0) go to 100
is = 1
!
!     Subdivide the interval (SUB1,SUB3) into the subintervals
!     (SUB1,SUB2) and (SUB2,SUB3). Call quad for (SUB1,SUB2).
!
10 if (npts .ge. mcount) go to 110
sub2 = 0.5*(sub1 + sub3)
call quad (sub1, sub2, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k-1))
sum = qsuba + result(k)
if (icheck .eq. 0 .or. err .le. abs(tol*sum)) go to 30
!
!        Stack the subinterval (SUB1,SUB2) for further
!        examination if there is sufficient storage.
!
   if (is .ge. ismax) go to 20
      stack(is) = sub1
      is = is + 1
      stack(is) = sub2
      is = is + 1
      go to 40
20 ind = 3
!
!     Update QSUBA and check if any significant digits are lost
!
30 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind .ne. 0 .or. x*result(k) .ge. 0.0) go to 40
x = 0.1*amin1(abs(x),abs(result(k)))
if (abs(qsuba) .le. x) ind = 1
!
!     CALL QUAD FOR THE INTERVAL (SUB2,SUB3)
!
40 if (npts .ge. mcount) go to 110
call quad (sub2, sub3, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k-1))
sum = qsuba + result(k)
if (icheck .eq. 0 .or. err .le. abs(tol*sum)) go to 50
!
!        Subdivide the interval (SUB2,SUB3)
!
   sub1 = sub2
   go to 10
!
!     Update QSUBA and check if any significant digits are lost
!
50 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind .ne. 0 .or. x*result(k) .ge. 0.0) go to 60
x = 0.1*amin1(abs(x),abs(result(k)))
if (abs(qsuba) .le. x) ind = 1
!
!     Subdivide the interval last stacked
!
60 if (is .eq. 1) go to 120
is = is - 1
sub3 = stack(is)
is = is - 1
sub1 = stack(is)
go to 10
!
!     Termination when subdivision is not needed
!
100 qsuba = result(k)
if (a .gt. b) qsuba = -qsuba
relerr = abs(result(k) - result(k-1))
if (qsuba .ne. 0.0) relerr = relerr/abs(qsuba)
return
!
!     Subdivision result
!
110 ind = 2
120 if (a .gt. b) qsuba = -qsuba
if (qsuba .ne. 0.0) relerr = relerr/abs(qsuba)
return
end function qsuba

subroutine quad(a, b, result, k, epsil, npts, icheck, f)
implicit none
integer, intent(out) :: icheck
integer, intent(inout) :: k, npts
real, intent(in) :: a, b, epsil
real, intent(inout) :: result(*)
integer :: i, inew, iold, j
real :: acum, diff, funct(127), fzero, p(381), sum, x
real :: f
!     --------------------
! This subroutine attempts to calculate the integral of F(X)
! over the interval *A* to *B* with relative error not
! EXCEEDING *EPSIL*.
! The result is obtained using a sequence of 1,3,7,15,31,63,
! 127, and 255 point interlacing formulae(no integrand
! evaluations are wasted) of respective degree 1,5,11,23,
! 47,95,191 and 383. The formulae are based on the optimal
! extension of the 3-point Gauss formula.  Details of
! the formulae are given in *the optimum addition of points
! to quadrature formulae* by T.N.L. Patterson,maths.Comp.
! Vol 22,847-856,1968.
!                     *** INPUT ***
! A       LOWER LIMIT OF INTEGRATION.
! B       UPPER LIMIT OF INTEGRATION.
! EPSIL   RELATIVE ACCURACY REQUIRED. WHEN THE RELATIVE
!         difference of two successive formulae does not
!         exceed *EPSIL* the last formula computed is taken
!         as the result.
! F       F(X) IS THE INTEGRAND.
!                     *** OUTPUT ***
! result  this array,which should be declared to have at
!         least 8 elements, holds the results obtained by
!         the 1,3,7, etc., point formulae. The number of
!         formulae computed depents on *EPSIL*.
! K       RESULT(K) HOLDS THE VALUE OF THE INTEGRAL TO THE
!         specified relative accuracy.
! NPTS    NUMBER INTEGRAND EVALUATIONS.
! ICHECK  ON EXIT NORMALLY ICHECK=0. HOWEVER IF CONVERGENCE
!         TO THE ACCURACY REQUESTED IS NOT ACHIEVED ICHECK=1
!         on exit.
! Abscissae and weights of quadrature rules are stacked in
! array *P* in the order in which they are needed.
!     --------------------
external f
data p( 1),p( 2),p( 3),p( 4),p( 5),p( 6),p( 7), &
&p( 8),p( 9),p(10),p(11),p(12),p(13),p(14), &
&p(15),p(16),p(17),p(18),p(19),p(20),p(21), &
&p(22),p(23),p(24),p(25),p(26),p(27),p(28)/ &
&0.77459666924148337704e00,0.55555555555555555556e00, &
&0.88888888888888888889e00,0.26848808986833344073e00, &
&0.96049126870802028342e00,0.10465622602646726519e00, &
&0.43424374934680255800e00,0.40139741477596222291e00, &
&0.45091653865847414235e00,0.13441525524378422036e00, &
&0.51603282997079739697e-01,0.20062852937698902103e00, &
&0.99383196321275502221e00,0.17001719629940260339e-01, &
&0.88845923287225699889e00,0.92927195315124537686e-01, &
&0.62110294673722640294e00,0.17151190913639138079e00, &
&0.22338668642896688163e00,0.21915685840158749640e00, &
&0.22551049979820668739e00,0.67207754295990703540e-01, &
&0.25807598096176653565e-01,0.10031427861179557877e00, &
&0.84345657393211062463e-02,0.46462893261757986541e-01, &
&0.85755920049990351154e-01,0.10957842105592463824e00/
data p(29),p(30),p(31),p(32),p(33),p(34),p(35), &
&p(36),p(37),p(38),p(39),p(40),p(41),p(42), &
&p(43),p(44),p(45),p(46),p(47),p(48),p(49), &
&p(50),p(51),p(52),p(53),p(54),p(55),p(56)/ &
&0.99909812496766759766e00,0.25447807915618744154e-02, &
&0.98153114955374010687e00,0.16446049854387810934e-01, &
&0.92965485742974005667e00,0.35957103307129322097e-01, &
&0.83672593816886873550e00,0.56979509494123357412e-01, &
&0.70249620649152707861e00,0.76879620499003531043e-01, &
&0.53131974364437562397e00,0.93627109981264473617e-01, &
&0.33113539325797683309e00,0.10566989358023480974e00, &
&0.11248894313318662575e00,0.11195687302095345688e00, &
&0.11275525672076869161e00,0.33603877148207730542e-01, &
&0.12903800100351265626e-01,0.50157139305899537414e-01, &
&0.42176304415588548391e-02,0.23231446639910269443e-01, &
&0.42877960025007734493e-01,0.54789210527962865032e-01, &
&0.12651565562300680114e-02,0.82230079572359296693e-02, &
&0.17978551568128270333e-01,0.28489754745833548613e-01/
data p(57),p(58),p(59),p(60),p(61),p(62),p(63), &
&p(64),p(65),p(66),p(67),p(68),p(69),p(70), &
&p(71),p(72),p(73),p(74),p(75),p(76),p(77), &
&p(78),p(79),p(80),p(81),p(82),p(83),p(84)/ &
&0.38439810249455532039e-01,0.46813554990628012403e-01, &
&0.52834946790116519862e-01,0.55978436510476319408e-01, &
&0.99987288812035761194e00,0.36322148184553065969e-03, &
&0.99720625937222195908e00,0.25790497946856882724e-02, &
&0.98868475754742947994e00,0.61155068221172463397e-02, &
&0.97218287474858179658e00,0.10498246909621321898e-01, &
&0.94634285837340290515e00,0.15406750466559497802e-01, &
&0.91037115695700429250e00,0.20594233915912711149e-01, &
&0.86390793819369047715e00,0.25869679327214746911e-01, &
&0.80694053195021761186e00,0.31073551111687964880e-01, &
&0.73975604435269475868e00,0.36064432780782572640e-01, &
&0.66290966002478059546e00,0.40715510116944318934e-01, &
&0.57719571005204581484e00,0.44914531653632197414e-01, &
&0.48361802694584102756e00,0.48564330406673198716e-01/
data p( 85),p( 86),p( 87),p( 88),p( 89),p( 90),p( 91), &
&p( 92),p( 93),p( 94),p( 95),p( 96),p( 97),p( 98), &
&p( 99),p(100),p(101),p(102),p(103),p(104),p(105), &
&p(106),p(107),p(108),p(109),p(110),p(111),p(112)/ &
&0.38335932419873034692e00,0.51583253952048458777e-01, &
&0.27774982202182431507e00,0.53905499335266063927e-01, &
&0.16823525155220746498e00,0.55481404356559363988e-01, &
&0.56344313046592789972e-01,0.56277699831254301273e-01, &
&0.56377628360384717388e-01,0.16801938574103865271e-01, &
&0.64519000501757369228e-02,0.25078569652949768707e-01, &
&0.21088152457266328793e-02,0.11615723319955134727e-01, &
&0.21438980012503867246e-01,0.27394605263981432516e-01, &
&0.63260731936263354422e-03,0.41115039786546930472e-02, &
&0.89892757840641357233e-02,0.14244877372916774306e-01, &
&0.19219905124727766019e-01,0.23406777495314006201e-01, &
&0.26417473395058259931e-01,0.27989218255238159704e-01, &
&0.18073956444538835782e-03,0.12895240826104173921e-02, &
&0.30577534101755311361e-02,0.52491234548088591251e-02/
data p(113),p(114),p(115),p(116),p(117),p(118),p(119), &
&p(120),p(121),p(122),p(123),p(124),p(125),p(126), &
&p(127),p(128),p(129),p(130),p(131),p(132),p(133), &
&p(134),p(135),p(136),p(137),p(138),p(139),p(140)/ &
&0.77033752332797418482e-02,0.10297116957956355524e-01, &
&0.12934839663607373455e-01,0.15536775555843982440e-01, &
&0.18032216390391286320e-01,0.20357755058472159467e-01, &
&0.22457265826816098707e-01,0.24282165203336599358e-01, &
&0.25791626976024229388e-01,0.26952749667633031963e-01, &
&0.27740702178279681994e-01,0.28138849915627150636e-01, &
&0.99998243035489159858e00,0.50536095207862517625e-04, &
&0.99959879967191068325e00,0.37774664632698466027e-03, &
&0.99831663531840739253e00,0.93836984854238150079e-03, &
&0.99572410469840718851e00,0.16811428654214699063e-02, &
&0.99149572117810613240e00,0.25687649437940203731e-02, &
&0.98537149959852037111e00,0.35728927835172996494e-02, &
&0.97714151463970571416e00,0.46710503721143217474e-02, &
&0.96663785155841656709e00,0.58434498758356395076e-02/
data p(141),p(142),p(143),p(144),p(145),p(146),p(147), &
&p(148),p(149),p(150),p(151),p(152),p(153),p(154), &
&p(155),p(156),p(157),p(158),p(159),p(160),p(161), &
&p(162),p(163),p(164),p(165),p(166),p(167),p(168)/ &
&0.95373000642576113641e00,0.70724899954335554680e-02, &
&0.93832039777959288365e00,0.83428387539681577056e-02, &
&0.92034002547001242073e00,0.96411777297025366953e-02, &
&0.89974489977694003664e00,0.10955733387837901648e-01, &
&0.87651341448470526974e00,0.12275830560082770087e-01, &
&0.85064449476835027976e00,0.13591571009765546790e-01, &
&0.82215625436498040737e00,0.14893641664815182035e-01, &
&0.79108493379984836143e00,0.16173218729577719942e-01, &
&0.75748396638051363793e00,0.17421930159464173747e-01, &
&0.72142308537009891548e00,0.18631848256138790186e-01, &
&0.68298743109107922809e00,0.19795495048097499488e-01, &
&0.64227664250975951377e00,0.20905851445812023852e-01, &
&0.59940393024224289297e00,0.21956366305317824939e-01, &
&0.55449513263193254887e00,0.22940964229387748761e-01/
data p(169),p(170),p(171),p(172),p(173),p(174),p(175), &
&p(176),p(177),p(178),p(179),p(180),p(181),p(182), &
&p(183),p(184),p(185),p(186),p(187),p(188),p(189), &
&p(190),p(191),p(192),p(193),p(194),p(195),p(196)/ &
&0.50768775753371660215e00,0.23854052106038540080e-01, &
&0.45913001198983233287e00,0.24690524744487676909e-01, &
&0.40897982122988867241e00,0.25445769965464765813e-01, &
&0.35740383783153215238e00,0.26115673376706097680e-01, &
&0.30457644155671404334e00,0.26696622927450359906e-01, &
&0.25067873030348317661e00,0.27185513229624791819e-01, &
&0.19589750271110015392e00,0.27579749566481873035e-01, &
&0.14042423315256017459e00,0.27877251476613701609e-01, &
&0.84454040083710883710e-01,0.28076455793817246607e-01, &
&0.28184648949745694339e-01,0.28176319033016602131e-01, &
&0.28188814180192358694e-01,0.84009692870519326354e-02, &
&0.32259500250878684614e-02,0.12539284826474884353e-01, &
&0.10544076228633167722e-02,0.58078616599775673635e-02, &
&0.10719490006251933623e-01,0.13697302631990716258e-01/
data p(197),p(198),p(199),p(200),p(201),p(202),p(203), &
&p(204),p(205),p(206),p(207),p(208),p(209),p(210), &
&p(211),p(212),p(213),p(214),p(215),p(216),p(217), &
&p(218),p(219),p(220),p(221),p(222),p(223),p(224)/ &
&0.31630366082226447689e-03,0.20557519893273465236e-02, &
&0.44946378920320678616e-02,0.71224386864583871532e-02, &
&0.96099525623638830097e-02,0.11703388747657003101e-01, &
&0.13208736697529129966e-01,0.13994609127619079852e-01, &
&0.90372734658751149261e-04,0.64476204130572477933e-03, &
&0.15288767050877655684e-02,0.26245617274044295626e-02, &
&0.38516876166398709241e-02,0.51485584789781777618e-02, &
&0.64674198318036867274e-02,0.77683877779219912200e-02, &
&0.90161081951956431600e-02,0.10178877529236079733e-01, &
&0.11228632913408049354e-01,0.12141082601668299679e-01, &
&0.12895813488012114694e-01,0.13476374833816515982e-01, &
&0.13870351089139840997e-01,0.14069424957813575318e-01, &
&0.25157870384280661489e-04,0.18887326450650491366e-03, &
&0.46918492424785040975e-03,0.84057143271072246365e-03/
data p(225),p(226),p(227),p(228),p(229),p(230),p(231), &
&p(232),p(233),p(234),p(235),p(236),p(237),p(238), &
&p(239),p(240),p(241),p(242),p(243),p(244),p(245), &
&p(246),p(247),p(248),p(249),p(250),p(251),p(252)/ &
&0.12843824718970101768e-02,0.17864463917586498247e-02, &
&0.23355251860571608737e-02,0.29217249379178197538e-02, &
&0.35362449977167777340e-02,0.41714193769840788528e-02, &
&0.48205888648512683476e-02,0.54778666939189508240e-02, &
&0.61379152800413850435e-02,0.67957855048827733948e-02, &
&0.74468208324075910174e-02,0.80866093647888599710e-02, &
&0.87109650797320868736e-02,0.93159241280693950932e-02, &
&0.98977475240487497440e-02,0.10452925722906011926e-01, &
&0.10978183152658912470e-01,0.11470482114693874380e-01, &
&0.11927026053019270040e-01,0.12345262372243838455e-01, &
&0.12722884982732382906e-01,0.13057836688353048840e-01, &
&0.13348311463725179953e-01,0.13592756614812395910e-01, &
&0.13789874783240936517e-01,0.13938625738306850804e-01, &
&0.14038227896908623303e-01,0.14088159516508301065e-01/
data p(253),p(254),p(255),p(256),p(257),p(258),p(259), &
&p(260),p(261),p(262),p(263),p(264),p(265),p(266), &
&p(267),p(268),p(269),p(270),p(271),p(272),p(273), &
&p(274),p(275),p(276),p(277),p(278),p(279),p(280)/ &
&0.99999759637974846462e00,0.69379364324108267170e-05, &
&0.99994399620705437576e00,0.53275293669780613125e-04, &
&0.99976049092443204733e00,0.13575491094922871973e-03, &
&0.99938033802502358193e00,0.24921240048299729402e-03, &
&0.99874561446809511470e00,0.38974528447328229322e-03, &
&0.99780535449595727456e00,0.55429531493037471492e-03, &
&0.99651414591489027385e00,0.74028280424450333046e-03, &
&0.99483150280062100052e00,0.94536151685852538246e-03, &
&0.99272134428278861533e00,0.11674841174299594077e-02, &
&0.99015137040077015918e00,0.14049079956551446427e-02, &
&0.98709252795403406719e00,0.16561127281544526052e-02, &
&0.98351865757863272876e00,0.19197129710138724125e-02, &
&0.97940628167086268381e00,0.21944069253638388388e-02, &
&0.97473445975240266776e00,0.24789582266575679307e-02/
data p(281),p(282),p(283),p(284),p(285),p(286),p(287), &
&p(288),p(289),p(290),p(291),p(292),p(293),p(294), &
&p(295),p(296),p(297),p(298),p(299),p(300),p(301), &
&p(302),p(303),p(304),p(305),p(306),p(307),p(308)/ &
&0.96948465950245923177e00,0.27721957645934509940e-02, &
&0.96364062156981213252e00,0.30730184347025783234e-02, &
&0.95718821610986096274e00,0.33803979910869203823e-02, &
&0.95011529752129487656e00,0.36933779170256508183e-02, &
&0.94241156519108305981e00,0.40110687240750233989e-02, &
&0.93406843615772578800e00,0.43326409680929828545e-02, &
&0.92507893290707565236e00,0.46573172997568547773e-02, &
&0.91543758715576504064e00,0.49843645647655386012e-02, &
&0.90514035881326159519e00,0.53130866051870565663e-02, &
&0.89418456833555902286e00,0.56428181013844441585e-02, &
&0.88256884024734190684e00,0.59729195655081658049e-02, &
&0.87029305554811390585e00,0.63027734490857587172e-02, &
&0.85735831088623215653e00,0.66317812429018878941e-02, &
&0.84376688267270860104e00,0.69593614093904229394e-02/
data p(309),p(310),p(311),p(312),p(313),p(314),p(315), &
&p(316),p(317),p(318),p(319),p(320),p(321),p(322), &
&p(323),p(324),p(325),p(326),p(327),p(328),p(329), &
&p(330),p(331),p(332),p(333),p(334),p(335),p(336)/ &
&0.82952219463740140018e00,0.72849479805538070639e-02, &
&0.81462878765513741344e00,0.76079896657190565832e-02, &
&0.79909229096084140180e00,0.79279493342948491103e-02, &
&0.78291939411828301639e00,0.82443037630328680306e-02, &
&0.76611781930376009072e00,0.85565435613076896192e-02, &
&0.74869629361693660282e00,0.88641732094824942641e-02, &
&0.73066452124218126133e00,0.91667111635607884067e-02, &
&0.71203315536225203459e00,0.94636899938300652943e-02, &
&0.69281376977911470289e00,0.97546565363174114611e-02, &
&0.67301883023041847920e00,0.10039172044056840798e-01, &
&0.65266166541001749610e00,0.10316812330947621682e-01, &
&0.63175643771119423041e00,0.10587167904885197931e-01, &
&0.61031811371518640016e00,0.10849844089337314099e-01, &
&0.58836243444766254143e00,0.11104461134006926537e-01/
data p(337),p(338),p(339),p(340),p(341),p(342),p(343), &
&p(344),p(345),p(346),p(347),p(348),p(349),p(350), &
&p(351),p(352),p(353),p(354),p(355),p(356),p(357), &
&p(358),p(359),p(360),p(361),p(362),p(363),p(364)/ &
&0.56590588542365442262e00,0.11350654315980596602e-01, &
&0.54296566649831149049e00,0.11588074033043952568e-01, &
&0.51955966153745702199e00,0.11816385890830235763e-01, &
&0.49570640791876146017e00,0.12035270785279562630e-01, &
&0.47142506587165887693e00,0.12244424981611985899e-01, &
&0.44673538766202847374e00,0.12443560190714035263e-01, &
&0.42165768662616330006e00,0.12632403643542078765e-01, &
&0.39621280605761593918e00,0.12810698163877361967e-01, &
&0.37042208795007823014e00,0.12978202239537399286e-01, &
&0.34430734159943802278e00,0.13134690091960152836e-01, &
&0.31789081206847668318e00,0.13279951743930530650e-01, &
&0.29119514851824668196e00,0.13413793085110098513e-01, &
&0.26424337241092676194e00,0.13536035934956213614e-01, &
&0.23705884558982972721e00,0.13646518102571291428e-01/
data p(365),p(366),p(367),p(368),p(369),p(370),p(371), &
&p(372),p(373),p(374),p(375),p(376),p(377),p(378), &
&p(379),p(380),p(381)/ &
&0.20966523824318119477e00,0.13745093443001896632e-01, &
&0.18208649675925219825e00,0.13831631909506428676e-01, &
&0.15434681148137810869e00,0.13906019601325461264e-01, &
&0.12647058437230196685e00,0.13968158806516938516e-01, &
&0.98482396598119202090e-01,0.14017968039456608810e-01, &
&0.70406976042855179063e-01,0.14055382072649964277e-01, &
&0.42269164765363603212e-01,0.14080351962553661325e-01, &
&0.14093886410782462614e-01,0.14092845069160408355e-01, &
&0.14094407090096179347e-01/
icheck = 0
! Check for trivial case.
if (a.eq.b) go to 70
! Scale factors.
sum = (b+a)/2.0
diff = (b-a)/2.0
! 1-Point Gauss
fzero = f(sum)
result(1) = 2.0*fzero*diff
i = 0
iold = 0
inew = 1
k = 2
acum = 0.0
go to 30
10 if (k.eq.8) go to 50
k = k + 1
acum = 0.0
! Contribution from function values already computed.
do 20 j = 1,iold
  i = i + 1
  acum = acum + p(i)*funct(j)
20 continue
! Contribution from new function values.
30 iold = iold + inew
do 40 j = inew,iold
  i = i + 1
  x = p(i)*diff
  funct(j) = f(sum+x) + f(sum-x)
  i = i + 1
  acum = acum + p(i)*funct(j)
40 continue
inew = iold + 1
i = i + 1
result(k) = (acum+p(i)*fzero)*diff
! Check for convergence.
if (abs(result(k)-result(k-1))-epsil*abs(result(k))) 60, &
&60, 10
! Convergence not achieved.
50 icheck = 1
! Normal termination.
60 npts = inew + iold
return
! Trivial case
70 k = 2
result(1) = 0.0
result(2) = 0.0
npts = 0
return
end subroutine quad

subroutine qags (f, a, b, epsabs, epsrel, result, abserr, &
&neval, ier, limit, lenw, last, iwork, work)
implicit none
real :: f
integer, intent(out) :: ier, last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(in) :: a
real, intent(out) :: abserr
real, intent(in) :: b, epsabs, epsrel
real, intent(out) :: result
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!
!                 Computation of a definite integral
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - REAL
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - REAL
!                     lower limit of integration
!
!            B      - REAL
!                     upper limit of integration
!
!            EPSABS - REAL
!                     absolute accuracy requested
!
!            EPSREL - REAL
!                     relative accuracy requested
!
!         On return
!            result - real
!                     approximation to the integral
!
!            ABSERR - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             Result, ABSERR, NEVAL, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - integer
!                    dimensioning parameter for IWORK
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    dimensioning parameter for work
!                    LENW must be at least limit*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            Last  - integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of
!                    significant elements actually in the work
!                    arrays.
!
!         Work arrays
!            IWORK - INTEGER
!                    vector of dimension at least limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) form a decreasing
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            Work  - real
!                    vector of dimension at least LENW
!                    on return
!                    WORK(1), ..., WORK(LAST) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) contain
!                     the right end points,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     contain the integral approximations over
!                     the subintervals,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     contain the error estimates.
!
!         Subroutines or functions needed
!              - QAGSE
!              - QK21F
!              - QPSRT
!              - QELG
!              - F (user-provided function)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
!
!         Check validity of limit and LENW.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for QAGSE.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call qagse (f,a,b,epsabs,epsrel,limit,result,abserr,neval, &
&ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine qags

subroutine qagse (f,a,b,epsabs,epsrel,limit,result,abserr, &
&neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!                 Computation of a definite integral
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - REAL
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - REAL
!                     lower limit of integration
!
!            B      - REAL
!                     upper limit of integration
!
!            EPSABS - REAL
!                     absolute accuracy requested
!
!            EPSREL - REAL
!                     relative accuracy requested
!
!            Limit  - integer
!                     gives an upperbound on the number of
!                     subintervals in the partition of (A,B)
!
!         On return
!            result - real
!                     approximation to the integral
!
!            ABSERR - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             or EPSREL is negative.
!                             Result, ABSERR, NEVAL, last, RLIST(1),
!                             IORD(1) and ELIST(1) are set to zero.
!                             ALIST(1) and BLIST(1) are set to A and B
!                             respectively.
!
!            ALIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (A,B)
!
!            BLIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (A,B)
!
!            RLIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            ELIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     SUBINERVALS
!
!            IORD   - INTEGER
!                     vector of dimension at least limit, the first K
!                     elements of which are pointers to the error
!                     estimates over the subintervals, such
!                     THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     otherwise
!
!            LAST   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!         Subroutines or functions needed
!              - QK21F
!              - QPSRT
!              - QELG
!              - F (user-provided function)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real, intent(in) :: a
real :: abseps
real, intent(out) :: abserr
real, intent(inout) :: alist
real :: area, area1, area12, area2, a1, a2
real, intent(in) :: b
real, intent(inout) :: blist
real :: b1, b2, correc, defabs, defab1, defab2, dres
real, intent(inout) :: elist
real :: epmach
real, intent(in) :: epsabs, epsrel
real :: erlarg, erlast, errbnd, errmax, error1, error2, erro12, &
&errsum, ertest, f, oflow, rerr, resabs, reseps
real, intent(out) :: result
real :: res3la(3)
real, intent(inout) :: rlist
real :: rlist2(52), small, spmpar, t, uflow
integer :: id
integer, intent(out) :: ier
integer :: ierro
integer, intent(inout) :: iord
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer, intent(out) :: last
integer, intent(in) :: limit
integer :: maxerr
integer, intent(out) :: neval
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
&rlist(limit)
!
external f
!
!            The dimension of RLIST2 is determined by the value of
!            LIMEXP in subroutine QELG (RLIST2 should be of dimension
!            (LIMEXP+2) at least).
!
!            List of major variables
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           RLIST(I)  - approximation to the integral over
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST LIMEXP+2
!                       containing the part of the epsilon table
!                       which is still needed for further computations
!           ELIST(I)  - error estimate applying to RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       estimate
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (before that subdivision has taken place)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT INTERVAL
!           *****2    - VARIABLE FOR THE RIGHT INTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       appropriate approximation to the compounded
!                       integral has been obtained it is put in
!                       RLIST2(NUMRL2) after NUMRL2 has been increased
!                       by one.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED
!                       up to now, multiplied by 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       than the smallest interval considered up to now
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       is attempting to perform extrapolation
!                       I.E. Before subdividing the smallest interval
!                       we try to decrease the value of ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       is no longer allowed (true value)
!
!            Machine dependent constants
!            ---------------------------
!
!           EPMACH is the largest relative spacing.
!           UFLOW is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!            Check EPSABS and EPSREL
!            -----------------------
!
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = a
blist(1) = b
rlist(1) = 0.0
elist(1) = 0.0
ier = 6
if (epsabs .lt. 0.0 .or. epsrel .lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach, 0.5e-14)
!
!           First approximation to the integral
!           -----------------------------------
!
ierro = 0
call qk21f (f, a, b, result, abserr, defabs, resabs, &
&epmach, uflow, id)
if (id .ne. 0) go to 999
neval = 21
!
!           Test on accuracy.
!
dres = abs(result)
errbnd = amax1(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr .le. 100.0*epmach*defabs .and. abserr .gt. &
&errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0) go to 999
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.0
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with the NRMAX-TH largest
!           error estimate.
!
  a1 = alist(maxerr)
  b1 = 0.5*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call qk21f (f, a1, b1, area1, error1, resabs, defab1, &
&epmach, uflow, ier)
  if (ier .ne. 0) go to 100
  call qk21f (f, a2, b2, area2, error2, resabs, defab2, &
&epmach, uflow, ier)
  neval = neval + 42
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (abs(rlist(maxerr) - area12) .gt. 0.1e-04*abs(area12) &
&.or. erro12 .lt. 0.99*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last .gt. 10 .and. erro12 .gt. errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = amax1(epsabs,rerr*abs(area))
!
!           Test for roundoff error and eventually
!           set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of
!           subintervals equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
!
  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
  if (error2 .gt. error1) go to 20
  alist(last) = a2
  blist(maxerr) = b1
  blist(last) = b2
  elist(maxerr) = error1
  elist(last) = error2
  go to 30
20 alist(maxerr) = a2
  alist(last) = a1
  blist(last) = b1
  rlist(maxerr) = area2
  rlist(last) = area1
  elist(maxerr) = error2
  elist(last) = error1
!
!           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with NRMAX-TH largest error estimate (to be
!           bisected next).
!
30 call qpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
! ***JUMP OUT OF DO-LOOP
  if (errsum .le. errbnd) go to 115
! ***JUMP OUT OF DO-LOOP
  if (ier .ne. 0) go to 100
  if (last .eq. 2) go to 80
  if (noext) go to 90
  erlarg = erlarg - erlast
  if (abs(b1 - a1) .gt. small) erlarg = erlarg + erro12
  if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (ERLARG) and perform
!           extrapolation.
!
  id = nrmax
  jupbnd = last
  if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
! ***JUMP OUT OF DO-LOOP
    if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
    nrmax = nrmax + 1
50 continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
  rlist2(numrl2) = area
  call qelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
&epmach, oflow)
  ktmin = ktmin + 1
  if (ktmin .gt. 5 .and. abserr .lt. 0.1e-02*errsum) ier = 5
  if (abseps .ge. abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = amax1(epsabs,rerr*abs(reseps))
! ***JUMP OUT OF DO-LOOP
  if (abserr .le. ertest) go to 100
!
!           Prepare bisection of the smallest interval.
!
70 if (numrl2 .eq. 1) noext = .true.
  if (ier .eq. 5) go to 100
  maxerr = iord(1)
  errmax = elist(maxerr)
  nrmax = 1
  extrap = .false.
  small = small*0.5
  erlarg = errsum
  go to 90
80 small = abs(b - a)*0.375
  erlarg = errsum
  ertest = errbnd
  rlist2(2) = area
90 continue
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.0 .and. area .ne. 0.0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.0) go to 130
go to 110
105 if (abserr/abs(result) .gt. errsum/abs(area)) go to 115
!
!           Test on divergence.
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
&defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
&.or. errsum .gt. abs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine qagse

subroutine qk21f (f, a, b, result, abserr, resabs, resasc, &
&epmach, uflow, isig)
implicit none
integer, intent(out) :: isig
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
integer :: j, jtw, jtwm1
real :: absc, centr, dhlgth, fc, fsum, fval1, fval2, hlgth, resg, &
&resk, reskh, tol
real :: f
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
!                             estimate
!                         J = INTEGRAL OF ABS(F) OVER (A,B)
!
! 2.        PARAMETERS
!            on entry
!              F      - REAL
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              A      - REAL
!                       lower limit of integration
!
!              B      - REAL
!                       upper limit of integration
!
!              EPMACH - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              UFLOW  - REAL
!                       the smallest positive magnitude.
!
!            On return
!              result - real
!                       approximation to the integral I
!                       result is computed by applying the 21-point
!                       Kronrod rule (RESK) obtained by optimal
!                       addition of abscissae to the 10-point Gauss
!                       RULE (RESG).
!
!              ABSERR - REAL
!                       estimate of the modulus of the absolute error,
!                       which should not exceed ABS(I-RESULT)
!
!              RESABS - REAL
!                       approximation to the integral J
!
!              RESASC - REAL
!                       approximation to the integral of ABS(F-I/(B-A))
!                       OVER (A,B)
!
!              ISIG   - INTEGER
!                       ISIG=0  THE INTEGRAL WAS APPROXIMATED.
!                       ISIG=5  THE INTERVAL (A,B) IS TOO SHORT.
!                               The integral cannot be computed.
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (user-provided function)
!
!-----------------------------------------------------------------------
real :: fv1(10), fv2(10), wg(5), wgk(11), xgk(11)
external f
!
!           The abscissae and weights are given for the interval (-1,1).
!           Because of symmetry only the positive abscissae and their
!           corresponding weights are given.
!
!           XGK    - ABSCISSAE OF THE 21-POINT KRONROD RULE
!                    XGK(2), XGK(4), ...  abscissae of the 10-point
!                    Gauss rule
!                    XGK(1), XGK(3), ...  abscissae which are optimally
!                    added to the 10-point Gauss rule
!
!           WGK    - WEIGHTS OF THE 21-POINT KRONROD RULE
!
!           WG     - WEIGHTS OF THE 10-POINT GAUSS RULE
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
&xgk(8),xgk(9),xgk(10),xgk(11)/ &
&0.9956571630258081e+00,     0.9739065285171717e+00, &
&0.9301574913557082e+00,     0.8650633666889845e+00, &
&0.7808177265864169e+00,     0.6794095682990244e+00, &
&0.5627571346686047e+00,     0.4333953941292472e+00, &
&0.2943928627014602e+00,     0.1488743389816312e+00, &
&0.0000000000000000e+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
&wgk(8),wgk(9),wgk(10),wgk(11)/ &
&0.1169463886737187e-01,     0.3255816230796473e-01, &
&0.5475589657435200e-01,     0.7503967481091995e-01, &
&0.9312545458369761e-01,     0.1093871588022976e+00, &
&0.1234919762620659e+00,     0.1347092173114733e+00, &
&0.1427759385770601e+00,     0.1477391049013385e+00, &
&0.1494455540029169e+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5)/ &
&0.6667134430868814e-01,     0.1494513491505806e+00, &
&0.2190863625159820e+00,     0.2692667193099964e+00, &
&0.2955242247147529e+00/
!
!
!           List of major variables
!           -----------------------
!
!           CENTR  - mid point of the interval
!           HLGTH  - half-length of the interval
!           ABSC   - ABSCISSA
!           FVAL*  - function VALUE
!           RESG   - RESULT OF THE 10-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 21-POINT KRONROD FORMULA
!           RESKH  - approximation to the mean value of F over (A,B),
!                    I.E. TO I/(B-A)
!
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
dhlgth = abs(hlgth)
!
!             Check if the interval (A,B) is too short
!
isig = 5
absc = abs(centr) + dhlgth*0.14
if (absc .eq. abs(centr)) return
!
!           Compute the 21-point Kronrod approximation to
!           the integral, and estimate the absolute error.
!
isig = 0
resg = 0.0
fc = f(centr)
resk = wgk(11)*fc
resabs = abs(resk)
do 10 j = 1,5
  jtw = 2*j
  absc = hlgth*xgk(jtw)
  fval1 = f(centr - absc)
  fval2 = f(centr + absc)
  fv1(jtw) = fval1
  fv2(jtw) = fval2
  fsum = fval1 + fval2
  resg = resg + wg(j)*fsum
  resk = resk + wgk(jtw)*fsum
  resabs = resabs + wgk(jtw)*(abs(fval1) + abs(fval2))
10 continue
do j = 1,5
  jtwm1 = 2*j - 1
  absc = hlgth*xgk(jtwm1)
  fval1 = f(centr - absc)
  fval2 = f(centr + absc)
  fv1(jtwm1) = fval1
  fv2(jtwm1) = fval2
  fsum = fval1 + fval2
  resk = resk + wgk(jtwm1)*fsum
  resabs = resabs + wgk(jtwm1)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5
resasc = wgk(11)*abs(fc - reskh)
do j = 1,10
  resasc = resasc + wgk(j)*(abs(fv1(j)-reskh) + abs(fv2(j)-reskh))
end do
result = resk*hlgth
resabs = resabs*dhlgth
resasc = resasc*dhlgth
abserr = abs((resk - resg)*hlgth)
if (resasc .ne. 0.0 .and. abserr .ne. 0.0) &
&abserr = resasc*amin1(1.0, &
&(0.2e+03*abserr/resasc)**1.5)
tol = epmach*0.5e+02
if (resabs .gt. uflow/tol) abserr = amax1(abserr,tol*resabs)
return
end subroutine qk21f

subroutine qagi (f, bound, inf, epsabs, epsrel, result, abserr, &
&neval, ier, limit, lenw, last, iwork, work)
implicit none
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(out) :: last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(out) :: abserr
real, intent(in) :: bound, epsabs, epsrel
real, intent(out) :: result
integer :: l1, l2, l3
real :: f
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - REAL
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            Bound  - real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            INF    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - REAL
!                     absolute accuracy requested
!
!            EPSREL - REAL
!                     relative accuracy requested
!
!         On return
!            result - real
!                     approximation to the integral
!
!            ABSERR - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             Result, ABSERR, NEVAL, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - integer
!                    dimensioning parameter for IWORK
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    dimensioning parameter for work
!                    LENW must be at least limit*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            Last  - integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!
!         Work arrays
!            IWORK - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) form a decreasing
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            Work  - real
!                    vector of dimension at least LENW
!                    on return
!                    WORK(1), ..., WORK(LAST) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) contain
!                     the right end points,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     contain the integral approximations over
!                     the subintervals,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     contain the error estimates.
!
!        Subroutines or functions needed
!              - QAGIE
!              - QK15I
!              - QPSRT
!              - QELG
!              - F (user provided function)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
!
!         Check validity of limit and LENW.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for QAGIE.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call qagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
&neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine qagi

subroutine qagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
&neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - REAL
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            Bound  - real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            INF    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - REAL
!                     absolute accuracy requested
!
!            EPSREL - REAL
!                     relative accuracy requested
!
!            Limit  - integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     LIMIT.GE.1
!
!         On return
!            result - real
!                     approximation to the integral
!
!            ABSERR - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             or EPSREL is negative.
!                             Result, ABSERR, NEVAL, last, RLIST(1),
!                             ELIST(1) and IORD(1) are set to zero.
!                             ALIST(1) and BLIST(1) are set to 0
!                             and 1 respectively.
!
!            ALIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            BLIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            RLIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            ELIST  - REAL
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!
!            IORD   - INTEGER
!                     vector of dimension limit, the first K
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     otherwise
!
!            LAST   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!
!        Subroutines or functions needed
!              - QK15I
!              - QPSRT
!              - QELG
!              - F (user-provided function)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real :: abseps
real, intent(out) :: abserr
real, intent(inout) :: alist
real :: area, area1, area12, area2, a1, a2
real, intent(inout) :: blist
real :: boun
real, intent(in) :: bound
real :: b1, b2, correc, defabs, defab1, defab2, dres
real, intent(inout) :: elist
real :: epmach
real, intent(in) :: epsabs, epsrel
real :: erlarg, erlast, errbnd, errmax, error1, error2, erro12, &
&errsum, ertest, f, oflow, rerr, resabs, reseps
real, intent(out) :: result
real :: res3la(3)
real, intent(inout) :: rlist
real :: rlist2(52), small, spmpar, t, uflow
integer :: id
integer, intent(out) :: ier
integer :: ierro
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer, intent(out) :: last
integer, intent(in) :: limit
integer :: maxerr
integer, intent(out) :: neval
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
&rlist(limit)
!
external f
!
!            The dimension of RLIST2 is determined by the value of
!            LIMEXP in subroutine QELG.
!
!
!            List of major variables
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           RLIST(I)  - approximation to the integral over
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           ELIST(I)  - error estimate applying to RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       estimate
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (before that subdivision has taken place)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
!           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       RLIST2(NUMRL2) after NUMRL2 has been increased
!                       by one.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED UP
!                       to now, multiplied by 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       than the smallest interval considered up to now
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       is no longer allowed (TRUE-VALUE)
!
!            Machine dependent constants
!            ---------------------------
!
!           EPMACH is the largest relative spacing.
!           UFLOW is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!           Check EPSABS and EPSREL
!           -----------------------
!
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = 0.0
blist(1) = 1.0
rlist(1) = 0.0
elist(1) = 0.0
iord(1) = 0
ier = 6
if (epsabs .lt. 0.0 .or. epsrel .lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach, 0.5e-14)
!
!           First approximation to the integral
!           -----------------------------------
!
!           Determine the interval to be mapped onto (0,1).
!           IF INF = 2 THE INTEGRAL IS COMPUTED AS I = I1+I2, WHERE
!           I1 = INTEGRAL OF F OVER (-INFINITY,0),
!           I2 = INTEGRAL OF F OVER (0,+INFINITY).
!
boun = bound
if (inf .eq. 2) boun = 0.0
call qk15i (f, boun, inf, 0.0, 1.0, result, abserr, &
&defabs, resabs, epmach, uflow)
!
!           Test on accuracy
!
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = amax1(epsabs,rerr*dres)
if (abserr .le. 100.0*epmach*defabs .and. abserr .gt. errbnd) &
&ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr .le. errbnd .and. abserr .ne. resabs) &
&.or. abserr .eq. 0.0) go to 130
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.0
nrmax = 1
nres = 0
ktmin = 0
numrl2 = 2
extrap = .false.
noext = .false.
ierro = 0
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with NRMAX-TH largest
!           error estimate.
!
  a1 = alist(maxerr)
  b1 = 0.5*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call qk15i (f, boun, inf, a1, b1, area1, error1, &
&resabs, defab1, epmach, uflow)
  call qk15i (f, boun, inf, a2, b2, area2, error2, &
&resabs, defab2, epmach, uflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (abs(rlist(maxerr) - area12) .gt. 0.1e-04*abs(area12) &
&.or. erro12 .lt. 0.99*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last .gt. 10 .and. erro12 .gt. errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = amax1(epsabs,rerr*abs(area))
!
!           Test for roundoff error and eventually
!           set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of
!           subintervals equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.
!

  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
  if (error2 .gt. error1) go to 20
  alist(last) = a2
  blist(maxerr) = b1
  blist(last) = b2
  elist(maxerr) = error1
  elist(last) = error2
  go to 30
20 alist(maxerr) = a2
  alist(last) = a1
  blist(last) = b1
  rlist(maxerr) = area2
  rlist(last) = area1
  elist(maxerr) = error2
  elist(last) = error1
!
!           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with NRMAX-TH largest error estimate (to be
!           bisected next).
!
30 call qpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
  if (errsum .le. errbnd) go to 115
  if (ier .ne. 0) go to 100
  if (last .eq. 2) go to 80
  if (noext) go to 90
  erlarg = erlarg - erlast
  if (abs(b1 - a1) .gt. small) erlarg = erlarg + erro12
  if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (ERLARG) and perform
!           extrapolation.
!
  id = nrmax
  jupbnd = last
  if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
    if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
    nrmax = nrmax + 1
50 continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
  rlist2(numrl2) = area
  call qelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
&epmach, oflow)
  ktmin = ktmin + 1
  if (ktmin .gt. 5 .and. abserr .lt. 0.1e-02*errsum) ier = 5
  if (abseps .ge. abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = amax1(epsabs,rerr*abs(reseps))
  if (abserr .le. ertest) go to 100
!
!            Prepare bisection of the smallest interval.
!
70 if (numrl2 .eq. 1) noext = .true.
  if (ier .eq. 5) go to 100
  maxerr = iord(1)
  errmax = elist(maxerr)
  nrmax = 1
  extrap = .false.
  small = small*0.5
  erlarg = errsum
  go to 90
80 small = 0.375
  erlarg = errsum
  ertest = errbnd
  rlist2(2) = area
90 continue
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.0 .and. area .ne. 0.0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.0) go to 130
go to 110
105 if (abserr/abs(result) .gt. errsum/abs(area)) go to 115
!
!           Test on divergence
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
&defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
&.or. errsum .gt. abs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
  result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf .eq. 2) neval = 2*neval
if (ier .gt. 2) ier = ier - 1
999 return
end subroutine qagie

subroutine qk15i (f, boun, inf, a, b, result, abserr, resabs, &
&resasc, epmach, uflow)
implicit none
integer, intent(in) :: inf
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, boun, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
integer :: j
real :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, &
&hlgth, resg, resk, reskh, tabsc1, tabsc2, tol
real :: f
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (A,B) is a part of (0,1).
!              It is the purpose to compute
!              I = INTEGRAL OF TRANSFORMED INTEGRAND OVER (A,B),
!              J = INTEGRAL OF ABS(TRANSFORMED INTEGRAND) OVER (A,B).
!
! 2.        PARAMETERS
!            on entry
!              F      - REAL
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              BOUN   - REAL
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF INF = +2)
!
!              INF    - INTEGER
!                       IF INF = -1, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,BOUND),
!                       IF INF = +1, THE ORIGINAL INTERVAL IS
!                                   (BOUND,+INFINITY),
!                       IF INF = +2, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!
!              A      - REAL
!                       lower limit for integration over subrange
!                       of (0,1)
!
!              B      - REAL
!                       upper limit for integration over subrange
!                       of (0,1)
!
!              EPMACH - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              UFLOW  - REAL
!                       the smallest positive magnitude.
!
!            On return
!              result - real
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod RULE(RESK) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(RESG).
!
!              ABSERR - REAL
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed ABS(I-RESULT)
!
!              RESABS - REAL
!                       approximation to the integral J
!
!              RESASC - REAL
!                       approximation to the integral of
!                       ABS((TRANSFORMED INTEGRAND)-I/(B-A))
!                       OVER (A,B)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (user-provided function)
!
!-----------------------------------------------------------------------
real :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
external f
!
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!
!           XGK    - ABSCISSAE OF THE 15-POINT KRONROD RULE
!                    XGK(2), XGK(4), ... abscissae of the 7-point
!                    Gauss rule
!                    XGK(1), XGK(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!
!           WGK    - WEIGHTS OF THE 15-POINT KRONROD RULE
!
!           WG     - WEIGHTS OF THE 7-POINT GAUSS RULE, CORRESPONDING
!                    to the abscissae XGK(2), XGK(4), ...
!                    WG(1), WG(3), ... are set to zero.
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
&xgk(8)/ &
&0.9914553711208126e+00,     0.9491079123427585e+00, &
&0.8648644233597691e+00,     0.7415311855993944e+00, &
&0.5860872354676911e+00,     0.4058451513773972e+00, &
&0.2077849550078985e+00,     0.0000000000000000e+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
&wgk(8)/ &
&0.2293532201052922e-01,     0.6309209262997855e-01, &
&0.1047900103222502e+00,     0.1406532597155259e+00, &
&0.1690047266392679e+00,     0.1903505780647854e+00, &
&0.2044329400752989e+00,     0.2094821410847278e+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5),wg(6),wg(7),wg(8)/ &
&0.0000000000000000e+00,     0.1294849661688697e+00, &
&0.0000000000000000e+00,     0.2797053914892767e+00, &
&0.0000000000000000e+00,     0.3818300505051189e+00, &
&0.0000000000000000e+00,     0.4179591836734694e+00/
!
!
!           List of major variables
!           -----------------------
!
!           CENTR  - mid point of the interval
!           HLGTH  - half-length of the interval
!           ABSC*  - ABSCISSA
!           TABSC* - transformed abscissa
!           FVAL*  - function VALUE
!           RESG   - RESULT OF THE 7-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 15-POINT KRONROD FORMULA
!           RESKH  - approximation to the mean value of the transformed
!                    integrand over (A,B), I.E. To I/(B-A)
!
!
dinf = min0(1,inf)
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1)
if (inf .eq. 2) fval1 = fval1 + f(-tabsc1)
fc = (fval1/centr)/centr
!
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
!
resg = wg(8)*fc
resk = wgk(8)*fc
resabs = abs(resk)
do j = 1,7
  absc = hlgth*xgk(j)
  absc1 = centr - absc
  absc2 = centr + absc
  tabsc1 = boun + dinf*(1.0 - absc1)/absc1
  tabsc2 = boun + dinf*(1.0 - absc2)/absc2
  fval1 = f(tabsc1)
  fval2 = f(tabsc2)
  if (inf .eq. 2) fval1 = fval1 + f(-tabsc1)
  if (inf .eq. 2) fval2 = fval2 + f(-tabsc2)
  fval1 = (fval1/absc1)/absc1
  fval2 = (fval2/absc2)/absc2
  fv1(j) = fval1
  fv2(j) = fval2
  fsum = fval1 + fval2
  resg = resg + wg(j)*fsum
  resk = resk + wgk(j)*fsum
  resabs = resabs + wgk(j)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5
resasc = wgk(8)*abs(fc - reskh)
do j = 1,7
  resasc = resasc + wgk(j)*(abs(fv1(j)-reskh) + &
&abs(fv2(j)-reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc .ne. 0.0 .and. abserr .ne. 0.0) abserr = resasc* &
&amin1(1.0, (0.2e+03*abserr/resasc)**1.5)
tol = 50.0*epmach
if (resabs .gt. uflow/tol) abserr = amax1(abserr, tol*resabs)
return
end subroutine qk15i

subroutine qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
implicit none
!     ..................................................................
!
! 1.        QPSRT
!           ORDERING ROUTINE
!              STANDARD FORTRAN SUBROUTINE
!              REAL VERSION
!
! 2.        PURPOSE
!              this routine maintains the descending ordering
!              in the list of the local error estimates resulting from
!              the interval subdivision process. At each call two error
!              estimates are inserted using the sequential search
!              method, top-down for the largest error estimate
!              and bottom-up for the smallest error estimate.
!
! 3.        CALLING SEQUENCE
!              CALL QPSRT(LIMIT,LAST,MAXERR,ERMAX,ELIST,IORD,NRMAX)
!
!           Parameters (meaning at output)
!              limit  - integer
!                       maximum number of error estimates the list
!                       can contain
!
!              LAST   - INTEGER
!                       number of error estimates currently
!                       in the list
!
!              MAXERR - INTEGER
!                       MAXERR points to the NRMAX-TH largest error
!                       estimate currently in the list
!
!              ERMAX  - REAL
!                       NRMAX-TH largest error estimate
!                       ERMAX = ELIST(MAXERR)
!
!              ELIST  - REAL
!                       vector of dimension last containing
!                       the error estimates
!
!              IORD   - INTEGER
!                       vector of dimension last, the first K
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       ELIST(IORD(1)),... , ELIST(IORD(K))
!                       form a decreasing sequence, with
!                       K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                       K = LIMIT+1-LAST OTHERWISE
!
!              NRMAX  - INTEGER
!                       MAXERR = IORD(NRMAX)
!
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!
!     ..................................................................
!
real :: elist
real, intent(inout) :: ermax
real :: errmax, errmin
integer :: i, ibeg, ido
integer, intent(inout) :: iord
integer :: isucc, j, jbnd, jupbn, k
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
dimension elist(last),iord(last)
!
!           Check whether the list contains more than
!           two error estimates.
!
!***FIRST EXECUTABLE STATEMENT  QPSRT
if(last.gt.2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           NRMAX-TH largest error estimate.
!
10 errmax = elist(maxerr)
if(nrmax.eq.1) go to 30
ido = nrmax-1
do i = 1,ido
  isucc = iord(nrmax-1)
! ***JUMP OUT OF DO-LOOP
  if(errmax.le.elist(isucc)) go to 30
  iord(nrmax) = isucc
  nrmax = nrmax-1
   end do
!
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
!
30 jupbn = last
if(last.gt.(limit/2+2)) jupbn = limit+3-last
errmin = elist(last)
!
!           Insert ERRMAX by traversing the list top-down,
!           starting comparison from the element ELIST(IORD(NRMAX+1)).
!
jbnd = jupbn-1
ibeg = nrmax+1
if(ibeg.gt.jbnd) go to 50
do i=ibeg,jbnd
  isucc = iord(i)
! ***JUMP OUT OF DO-LOOP
  if(errmax.ge.elist(isucc)) go to 60
  iord(i-1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!
!           Insert ERRMIN by traversing the list bottom-up.
!
60 iord(i-1) = maxerr
k = jbnd
do j=i,jbnd
  isucc = iord(k)
! ***JUMP OUT OF DO-LOOP
  if(errmin.lt.elist(isucc)) go to 80
  iord(k+1) = isucc
  k = k-1
end do
iord(i) = last
go to 90
80 iord(k+1) = last
!
!           Set MAXERR and ERMAX.
!
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
return
end subroutine qpsrt

subroutine qelg (n, epstab, result, abserr, res3la, nres, &
&epmach, oflow)
implicit none
integer, intent(inout) :: n, nres
real, intent(out) :: abserr
real, intent(in) :: epmach, oflow
real, intent(out) :: result
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp, newelm, num
real :: delta1, delta2, delta3, e0, e1, e1abs, e2, e3, epsinf, &
&err1, err2, err3, error, res, ss, tol1, tol2, tol3
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. Wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
!
! 2.        PARAMETERS
!              N      - INTEGER
!                       EPSTAB(N) contains the new element in the
!                       first column of the epsilon table.
!
!              EPSTAB - REAL
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!
!              Result - real
!                       resulting approximation to the integral
!
!              ABSERR - REAL
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!
!              RES3LA - REAL
!                       vector of dimension 3 containing the last 3
!                       results
!
!              NRES   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!
!              EPMACH - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              OFLOW  - REAL
!                       the largest positive magnitude.
!
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!
!-----------------------------------------------------------------------
real, intent(inout) :: epstab(52), res3la(3)
!---------------------
!
!           List of major variables
!           -----------------------
!
!           E0     - THE 4 ELEMENTS ON WHICH THE
!           E1       COMPUTATION OF A NEW ELEMENT IN
!           E2       THE EPSILON TABLE IS BASED
!           E3                 E0
!                        E3    E1    NEW
!                              E2
!           NEWELM - number of elements to be computed in the new
!                    diagonal
!           ERROR  - ERROR = ABS(E1-E0)+ABS(E2-E1)+ABS(NEW-E2)
!           result - the element in the new diagonal with least value
!                    of error
!
!           LIMEXP is the maximum number of elements the epsilon
!           table can contain. If this number is reached, the upper
!           diagonal of the epsilon table is deleted.
!
nres = nres + 1
abserr = oflow
result = epstab(n)
if (n .lt. 3) go to 100
limexp = 50
epstab(n + 2) = epstab(n)
newelm = (n - 1)/2
epstab(n) = oflow
num = n
k1 = n
do 40 i = 1,newelm
  k2 = k1 - 1
  k3 = k1 - 2
  res = epstab(k1 + 2)
  e0 = epstab(k3)
  e1 = epstab(k2)
  e2 = res
  e1abs = abs(e1)
  delta2 = e2 - e1
  err2 = abs(delta2)
  tol2 = amax1(abs(e2),e1abs)*epmach
  delta3 = e1 - e0
  err3 = abs(delta3)
  tol3 = amax1(e1abs,abs(e0))*epmach
  if (err2 .gt. tol2 .or. err3 .gt. tol3) go to 10
!
!           If E0, E1 and E2 are equal to within machine
!           accuracy, convergence is assumed.
!           RESULT = E2
!           ABSERR = ABS(E1-E0) + ABS(E2-E1)
!
  result = res
  abserr = err2 + err3
! ***JUMP OUT OF DO-LOOP
  go to 100
10 e3 = epstab(k1)
  epstab(k1) = e1
  delta1 = e1 - e3
  err1 = abs(delta1)
  tol1 = amax1(e1abs,abs(e3))*epmach
!
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of N
!
  if (err1.le.tol1 .or. err2.le.tol2 .or. err3.le.tol3) go to 20
  ss = 1.0/delta1 + 1.0/delta2 - 1.0/delta3
  epsinf = abs(ss*e1)
!
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF N.
!
  if (epsinf .gt. 0.1e-03) go to 30
20 n = i + i - 1
! ***JUMP OUT OF DO-LOOP
  go to 50
!
!           Compute a new element and eventually adjust
!           the value of result.
!
30 res = e1 + 1.0/ss
  epstab(k1) = res
  k1 = k1 - 2
  error = err2 + abs(res - e2) + err3
  if (error .gt. abserr) go to 40
  abserr = error
  result = res
40 continue
!
!           Shift the table.
!
50 if (n .eq. limexp) n = 2*(limexp/2) - 1
ib = 1
if ((num/2)*2 .eq. num) ib = 2
ie = newelm + 1
do i = 1,ie
  ib2 = ib + 2
  epstab(ib) = epstab(ib2)
  ib = ib2
end do
if (num .eq. n) go to 80
indx = num - n + 1
do i = 1,n
  epstab(i) = epstab(indx)
  indx = indx + 1
end do
80 if (nres .ge. 4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!
!           Compute error estimate
!
90 abserr = abs(result - res3la(3)) + abs(result - res3la(2)) + &
&abs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = amax1(abserr,5.0*epmach*abs(result))
return
end subroutine qelg

subroutine qxgs (f,a,b,epsabs,epsrel,result,abserr,ier, &
&limit,leniw,lenw,last,iwork,work)
implicit none
!
!            The routine calculates an approximation result to a given
!            DEFINITE INTEGRAL  I = INTEGRAL OF F OVER (A,B),
!            hopefully satisfying following claim for accuracy
!            ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - REAL
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - REAL
!                     lower limit of integration
!
!            B      - REAL
!                     upper limit of integration
!
!            EPSABS - REAL
!                     absolute accuracy requested
!
!            EPSREL - REAL
!                     relative accuracy requested
!
!         On return
!            result - real
!                     approximation to the integral
!
!            ABSERR - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account. However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. Singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table. It is presumed that
!                             the requested tolerance cannot be
!                             achieved, and that the returned result is
!                             the best which can be obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS OR
!                             EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             LENW .LT. 46*LIMIT, OR
!                             LENIW .LT. 3*LIMIT.
!                             Result, ABSERR, last are set to
!                             zero. Except when limit or LENW or LENIW
!                             is invalid, IWORK(1), WORK(LIMIT*2+1) and
!                             WORK(LIMIT*3+1) are set to zero, WORK(1)
!                             is set to A, and WORK(LIMIT+1) to B.
!
!         Dimensioning parameters
!            limit - integer
!                    limit determines the maximum number of subintervals
!                    in the partition of the given integration interval
!                    (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH IER = 6.
!
!            LENW  - INTEGER
!                    dimensioning parameter for work
!                    LENW must be at least limit*46.
!                    IF LENW.LT.LIMIT*46, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LENIW - INTEGER
!                    dimensioning parameter for IWORK
!                    LENIW must be at least limit*3.
!                    IF LENW.LT.LIMIT*3, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            Last  - integer
!                    on return, last equals the number of subintervals
!                    produced in the subdivision process, which deter-
!                    mines the number of significant elements actually
!                    in the work arrays.
!
!         Work arrays
!            IWORK - INTEGER
!                    vector of dimension at least 3*limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) form a decreasing
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2),
!                    AND K = LIMIT+1-LAST OTHERWISE.
!
!            Work  - real
!                    vector of dimension at least LENW
!                    on return
!                    WORK(1), ..., WORK(LAST) contain the left
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) contain
!                     the right end-points,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST) contain
!                     the integral approximations over the subintervals,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     contain the error estimates.
!                    WORK(LIMIT*4+1), ... is the area reserved to store
!                     functional values.
!
real :: a
real, intent(out) :: abserr
real :: b
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(out) :: last
integer, intent(in) :: leniw, lenw, limit
integer :: l1, l2, l3, l4, l5
!
dimension iwork(leniw),work(lenw)
!
external f
!
!         Check validity of limit,LENIW and LENW.
!
ier = 6
last = 0
result = 0.0
abserr = 0.0
if (limit.lt.1 .or. leniw.lt.limit*3 .or. lenw.lt.limit*46) &
&return
!
!         Prepare call for QXGSE.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
l4 = limit + l3
l5 = 21*limit + l4
!
call qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
&ier,work(1),work(l1),work(l2),work(l3),iwork,last, &
&work(l4),work(l5),iwork(l1),iwork(l2))
!
return
end subroutine qxgs

subroutine qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
&ier,alist,blist,rlist,elist,iord,last,valp,valn,lp,ln)
implicit none
!
!            The routine calculates an approximation result to A
!            DEFINITE INTEGRAL I = INTEGRAL OF F OVER (A,B),
!            hopefully satisfying following claim for accuracy
!            ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - REAL
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - REAL
!                     lower limit of integration
!
!            B      - REAL
!                     upper limit of integration
!
!            EPSABS - REAL
!                     absolute accuracy requested
!
!            EPSREL - REAL
!                     relative accuracy requested
!
!            Limit  - integer
!                     gives an upperbound on the number of subintervals
!                     in the partition of (A,B)
!
!         On return
!            result - real
!                     approximation to the integral
!
!            ABSERR - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account). However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. Singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS OR
!                             EPSREL is negative. Result, ABSERR,
!                             last, RLIST(1), IORD(1), and ELIST(1)
!                             are set to zero. ALIST(1) and BLIST(1)
!                             are set to A and B respectively.
!
!            ALIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left end points
!                     of the subintervals in the partition of the
!                     given integration range (A,B)
!
!            BLIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right end points
!                     of the subintervals in the partition of the given
!                     integration range (A,B)
!
!            RLIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            ELIST  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli of the
!                     absolute error estimates on the subintervals
!
!            IORD   - INTEGER
!                     vector of dimension at least limit, the first K
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     otherwise
!
!            LAST   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!            VALP   - REAL
!            VALN     ARRAYS OF DIMENSION AT LEAST (21,LIMIT) USED TO
!                     save the functional values
!
!            LP     - INTEGER
!            LN       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     store the actual number of functional values
!                     saved in the corresponding column
!                     OF VALP,VALN
!
!***ROUTINES CALLED  F,SPMPAR,QELG,QXLQM,QPSRT,QXRRD,QXCPY
!
real :: a, abseps
real, intent(out) :: abserr
real, intent(inout) :: alist
real :: area, area1, area12, area2, a1, a2, b
real, intent(inout) :: blist
real :: b1, b2, correc, defabs, defab1, defab2, dres
real, intent(inout) :: elist
real :: epmach
real, intent(in) :: epsabs, epsrel
real :: erlarg, erlast, errbnd, errmax, error1, error2, erro12, &
&errsum, ertest, f, oflow, rerr, resabs, reseps
real, intent(out) :: result
real :: res3la(3)
real, intent(inout) :: rlist
real :: rlist2(52), small, t, uflow
real, intent(inout) :: valp, valn
real :: vp1(21), vp2(21), vn1(21), vn2(21), spmpar
integer :: id
integer, intent(out) :: ier
integer :: ierro
integer, intent(inout) :: iord
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer, intent(out) :: last
integer, intent(in) :: limit
integer :: maxerr, nres, nrmax, numrl2
integer, intent(inout) :: lp(limit), ln(limit)
integer :: lp1, lp2, ln1, ln2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
&rlist(limit), valp(21,limit), valn(21,limit)
!
external f
!
!            Machine dependent constants
!            ---------------------------
!
!          EPMACH is the largest relative spacing.
!          UFLOW is the smallest positive magnitude.
!          OFLOW is the largest positive magnitude.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!            Test on validity of parameters
!            ------------------------------
last = 0
result = 0.0
abserr = 0.0
alist(1) = a
blist(1) = b
rlist(1) = 0.0
elist(1) = 0.0
ier = 6
if (epsabs .lt. 0.0 .or. epsrel.lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach)
!
!           First approximation to the integral
!           -----------------------------------
!
ierro = 0
lp(1) = 1
ln(1) = 1
valp(1,1) = f((a + b)*0.5)
valn(1,1) = valp(1,1)
call qxlqm (f,a,b,result,abserr,defabs,resabs, &
&valp(1,1),valn(1,1),lp(1),ln(1),2, &
&epmach,uflow,oflow)
!
!           Test on accuracy.
!
dres = abs(result)
errbnd = amax1(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr .le. 100.0*epmach*defabs .and. abserr .gt. &
&errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr.le.errbnd.and.abserr.ne.resabs) .or. &
&abserr .eq. 0.0) go to 999
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with the NRMAX-TH largest error
!           estimate.
!
  a1 = alist(maxerr)
  b1 = 0.5*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call qxrrd(f,valn(1,maxerr),ln(maxerr),b1,a1,vn1,vp1,ln1,lp1)
  call qxlqm(f,a1,b1,area1,error1,resabs,defab1,vp1,vn1,lp1,ln1, &
&2,epmach,uflow,oflow)
  call qxrrd(f,valp(1,maxerr),lp(maxerr),a2,b2,vp2,vn2,lp2,ln2)
  call qxlqm(f,a2,b2,area2,error2,resabs,defab2,vp2,vn2,lp2,ln2, &
&2,epmach,uflow,oflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (abs(rlist(maxerr) - area12) .gt. 0.1e-04*abs(area12) &
&.or. erro12 .lt. 0.99*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last.gt.10 .and. erro12.gt.errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = amax1(epsabs,rerr*abs(area))
!
!           Test for roundoff error and eventually set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of subintervals
!           equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
!
  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 1.e+03*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
  if (error2 .gt. error1) go to 20
  alist(last) = a2
  blist(maxerr) = b1
  blist(last) = b2
  elist(maxerr) = error1
  elist(last) = error2
  call qxcpy(valp(1,maxerr),vp1,lp1)
  lp(maxerr) = lp1
  call qxcpy(valn(1,maxerr),vn1,ln1)
  ln(maxerr) = ln1
  call qxcpy(valp(1,last),vp2,lp2)
  lp(last) = lp2
  call qxcpy(valn(1,last),vn2,ln2)
  ln(last) = ln2
  go to 30
!
20 alist(maxerr) = a2
  alist(last) = a1
  blist(last) = b1
  rlist(maxerr) = area2
  rlist(last) = area1
  elist(maxerr) = error2
  elist(last) = error1
  call qxcpy(valp(1,maxerr),vp2,lp2)
  lp(maxerr) = lp2
  call qxcpy(valn(1,maxerr),vn2,ln2)
  ln(maxerr) = ln2
  call qxcpy(valp(1,last),vp1,lp1)
  lp(last) = lp1
  call qxcpy(valn(1,last),vn1,ln1)
  ln(last) = ln1
!
!           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the subinterval
!           with NRMAX-TH largest error estimate (to be bisected next).
!
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***JUMP OUT OF DO-LOOP
  if(errsum .le. errbnd) go to 115
! ***JUMP OUT OF DO-LOOP
  if (ier .ne. 0) go to 100
  if (last .eq. 2) go to 80
  if (noext) go to 90
  erlarg = erlarg - erlast
  if (abs(b1 - a1) .gt. small) erlarg = erlarg + erro12
  if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
!
!           The bound 0.3*ERTEST has been introduced to perform A
!           more cautious extrapolation than in the original DQAGSE
!           routine
!
40 if (ierro .eq. 3 .or. erlarg .le. 0.3*ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors over the
!           larger intervals (ERLARG) and perform extrapolation.
!
  id = nrmax
  jupbnd = last
  if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
! ***JUMP OUT OF DO-LOOP
    if(abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
    nrmax = nrmax + 1
50 continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
  rlist2(numrl2) = area
  call qelg (numrl2,rlist2,reseps,abseps,res3la,nres, &
&epmach,oflow)
  ktmin = ktmin + 1
  if (ktmin .gt. 5 .and. abserr .lt. 0.1e-02*errsum) ier = 5
  if (abseps .ge. abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = amax1(epsabs,rerr*abs(reseps))
! ***JUMP OUT OF DO-LOOP
  if (abserr .le. ertest) go to 100
!
!           Prepare bisection of the smallest interval.
!
70 if (numrl2 .eq. 1) noext = .true.
  if (ier .eq. 5) go to 100
  maxerr = iord(1)
  errmax = elist(maxerr)
  nrmax = 1
  extrap = .false.
  small = small*0.5
  erlarg = errsum
  go to 90
80 small = abs(b - a)*0.375
  erlarg = errsum
  ertest = errbnd
  rlist2(2) = area
90 continue
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.0 .and. area .ne. 0.0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.0) go to 130
go to 110
105 if (abserr/abs(result) .gt. errsum/abs(area)) go to 115
!
!           Test on divergence.
!
110 if(ksgn.eq.(-1).and.amax1(abs(result),abs(area)).le. &
&defabs*0.1e-01) go to 130
if(0.1e-01.gt.(result/area).or.(result/area).gt.0.1e+03 &
&.or.errsum.gt.abs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine qxgse

subroutine qxcpy (a, b, l)
implicit none
integer :: i
!
!  TO COPY THE REAL VECTOR B OF LENGTH L   I N T O
!          the real vector A of length L
!
integer, intent(in) :: l
real, intent(inout) :: a(l)
real, intent(in) :: b(l)
!
do 10 i = 1,l
10 a(i) = b(i)
return
end subroutine qxcpy

subroutine qxlqm (f,a,b,result,abserr,resabs,resasc,vr,vs,lr,ls, &
&key,epmach,uflow,oflow)
implicit none
!
!            TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
!                           estimate
!                       J = INTEGRAL OF ABS(F) OVER (A,B)
!
!           Parameters
!            on entry
!              F      - REAL
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       declared E X T E R N A L in the driver program.
!
!              A      - REAL
!                       lower limit of integration
!
!              B      - REAL
!                       upper limit of integration
!
!              VR     - REAL
!                       vector of length LR containing the
!                       saved  functional values of positive abscissas
!
!              VS     - REAL
!                       vector of length LS containing the
!                       saved  functional values of negative abscissas
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTS IN
!                       VR,vs respectively
!
!            KEY    - INTEGER
!                     key for choice of local integration rule
!                     rms formulas are used with
!                      13 - 19               POINTS IF KEY.LT.1,
!                      13 - 19 - (27)        POINTS IF KEY = 1,
!                      13 - 19 - (27) - (41) POINTS IF KEY = 2,
!                           19 -  27  - (41) POINTS IF KEY = 3,
!                                 27  -  41  POINTS IF KEY.GT.3.
!
!                         (Rules) used if the function APPEARS
!                         enough regular
!
!              EPMACH - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              UFLOW  - REAL
!                       the smallest positive magnitude.
!
!              OFLOW  - REAL
!                       the largest positive magnitude.
!
!            On return
!              result - real
!                       approximation to the integral I
!
!              ABSERR - REAL
!                       estimate of the modulus of the absolute error,
!                       which should not exceed ABS(I-RESULT)
!
!              RESABS - REAL
!                       approximation to the integral J
!
!              RESASC - REAL
!                       approximation to the integral of ABS(F-I/(B-A))
!                       OVER (A,B)
!
!              VR     - REAL
!                       vector of length LR containing the
!                       saved  functional values of positive abscissas
!
!              VS     - REAL
!                       vector of length LS containing the
!                       saved  functional values of negative abscissas
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTS IN
!                       VR,vs respectively
!
!***ROUTINES CALLED  QXRUL
!
real :: f
real, intent(in) :: a, b
real, intent(inout) :: result, abserr, resabs, resasc
real :: t
real, intent(in) :: epmach, oflow, uflow
real :: resg, resk, errold
real, intent(inout) :: vr(21), vs(21)
integer :: k, k0, k1, k2
integer, intent(in) :: key
integer :: key1
integer, intent(inout) :: lr, ls
external f
!
key1 = max0(key ,  0)
key1 = min0(key1,  4)
k0   = max0(key1-2,0)
k1   = k0 + 1
k2   = min0(key1+1,3)
!
call qxrul (f,a,b,resg,resabs,resasc,k0,k1,vr,vs,lr,ls)
errold = oflow
t = 10.0*epmach
do 10 k = k1,k2
  call qxrul (f,a,b,resk,resabs,resasc,k,k1,vr,vs,lr,ls)
  result = resk
  abserr = abs(resk - resg)
  if (resasc .ne. 0.0 .and. abserr .ne. 0.0) &
&abserr = resasc*amin1(1.0,(200.0*abserr/resasc)**1.5)
  if (resabs .gt. uflow/t) abserr = amax1(t*resabs,abserr)
  resg = resk
  if (abserr .gt. errold*0.16) go to 3000
  if (abserr .lt. 1000.0*epmach*resabs) go to 3000
  errold = abserr
10 continue
3000 continue
return
end subroutine qxlqm

subroutine qxrul (f,xl,xu,y,ya,ym,ke,k1,fv1,fv2,l1,l2)
implicit none
integer :: i, is, k, ks
!
!            TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
!                           estimate
!            and conditionally compute
!                       J = INTEGRAL OF ABS(F) OVER (A,B)
!                       by using an  rms rule
!           parameters
!            on entry
!              F      - REAL
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       declared E X T E R N A L in the driver program.
!
!              XL     - REAL
!                       lower limit of integration
!
!              XU     - REAL
!                       upper limit of integration
!
!              KE     - INTEGER
!                     key for choice of local integration rule
!                     an rms rule is used with
!                         13      POINTS IF KE  = 2,
!                         19      POINTS IF KE  = 3,
!                         27      POINTS IF KE  = 4,
!                         42      POINTS IF KE  = 5
!
!              K1     INTEGER
!                     value of key for which the additional estimates
!                     YA, YM are to be computed
!
!              FV1    - REAL
!                       vector containing L1
!                       saved  functional values of positive abscissas
!
!              FV2    - REAL
!                       vector containing L2
!                       saved  functional values of negative abscissas
!
!              L1     - INTEGER
!              L2       NUMBER OF ELEMENTS IN FV1,FV2  RESPECTIVELY
!
!            On return
!              Y      - REAL
!                       approximation to the integral I
!                       result is computed by applying the
!                       requested rms rule
!
!              YA     - REAL
!                       IF KEY = K1  APPROXIMATION TO THE INTEGRAL J
!                       ELSE UNCHANGED
!
!              YM     - REAL
!                       IF KEY = K1  APPROXIMATION TO THE INTEGRAL OF
!                                      ABS(F-I/(XU-XL)   OVER (XL,XU)
!                       ELSE UNCHANGED
!
!              FV1    - REAL
!                       vector containing L1
!                       saved  functional values of positive abscissas
!
!              FV2    - REAL
!                       vector containing L2
!                       saved  functional values of negative abscissas
!
!              L1     - INTEGER
!              L2       NUMBER OF ELEMENTS IN FV1,FV2  RESPECTIVELY
!
!------------------------
real :: f
real, intent(in) :: xl, xu
real :: ldl
real, intent(out) :: y
real, intent(inout) :: ya, ym
real :: y2, xx(41), ww(52)
real, intent(inout) :: fv1(21), fv2(21)
real :: aa, bb, c
integer :: istart(4), len(4), j
integer, intent(in) :: ke, k1
integer, intent(inout) :: l1, l2
external f
!------------------------
data istart(1)/0/, istart(2)/7/, istart(3)/17/, istart(4)/31/
data len(1)/7/, len(2)/10/, len(3)/14/, len(4)/21/
!------------------------
data xx( 1)/.0                       /
data xx( 2)/.25000000000000000000e+00/
data xx( 3)/.50000000000000000000e+00/
data xx( 4)/.75000000000000000000e+00/
data xx( 5)/.87500000000000000000e+00/
data xx( 6)/.93750000000000000000e+00/
data xx( 7)/.10000000000000000000e+01/
data xx( 8)/.37500000000000000000e+00/
data xx( 9)/.62500000000000000000e+00/
data xx(10)/.96875000000000000000e+00/
data xx(11)/.12500000000000000000e+00/
data xx(12)/.68750000000000000000e+00/
data xx(13)/.81250000000000000000e+00/
data xx(14)/.98437500000000000000e+00/
data xx(15)/.18750000000000000000e+00/
data xx(16)/.31250000000000000000e+00/
data xx(17)/.43750000000000000000e+00/
data xx(18)/.56250000000000000000e+00/
data xx(19)/.84375000000000000000e+00/
data xx(20)/.90625000000000000000e+00/
data xx(21)/.99218750000000000000e+00/
!   Number of nodes 13
data ww(1)/1.303262173284849021810473057638590518409112513421e-1/
data ww(2)/2.390632866847646220320329836544615917290026806242e-1/
data ww(3)/2.630626354774670227333506083741355715758124943143e-1/
data ww(4)/2.186819313830574175167853094864355208948886875898e-1/
data ww(5)/2.757897646642836865859601197607471574336674206700e-2/
data ww(6)/1.055750100538458443365034879086669791305550493830e-1/
data ww(7)/1.571194260595182254168429283636656908546309467968e-2/
!   Number of nodes 19
data ww(8)/1.298751627936015783241173611320651866834051160074e-1/
data ww(9)/2.249996826462523640447834514709508786970828213187e-1/
data ww(15)/5.542699233295875168406783695143646338274805359780e-2/
data ww(10)/1.680415725925575286319046726692683040162290325505e-1/
data ww(16)/9.986735247403367525720377847755415293097913496236e-2/
data ww(11)/1.415567675701225879892811622832845252125600939627e-1/
data ww(12)/1.006482260551160175038684459742336605269707889822e-1/
data ww(13)/2.510604860724282479058338820428989444699235030871e-2/
data ww(17)/4.507523056810492466415880450799432587809828791196e-2/
data ww(14)/9.402964360009747110031098328922608224934320397592e-3/
!   Number of nodes 27
data ww(18)/6.300942249647773931746170540321811473310938661469e-2/
data ww(28)/1.239572396231834242194189674243818619042280816640e-1/
data ww(19)/1.261383225537664703012999637242003647020326905948e-1/
data ww(25)/1.235837891364555000245004813294817451524633100256e-1/
data ww(20)/1.273864433581028272878709981850307363453523117880e-1/
data ww(26)/1.148933497158144016800199601785309838604146040215e-1/
data ww(29)/2.501306413750310579525950767549691151739047969345e-2/
data ww(21)/8.576500414311820514214087864326799153427368592787e-2/
data ww(30)/4.915957918146130094258849161350510503556792927578e-2/
data ww(22)/7.102884842310253397447305465997026228407227220665e-2/
data ww(23)/5.026383572857942403759829860675892897279675661654e-2/
data ww(27)/1.252575774226122633391477702593585307254527198070e-2/
data ww(31)/2.259167374956474713302030584548274729936249753832e-2/
data ww(24)/4.683670010609093810432609684738393586390722052124e-3/
!   Number of nodes 41
data ww(32)/6.362762978782724559269342300509058175967124446839e-2/
data ww(42)/1.187141856692283347609436153545356484256869129472e-1/
data ww(46)/1.533126874056586959338368742803997744815413565014e-2/
data ww(33)/9.950065827346794643193261975720606296171462239514e-2/
data ww(47)/3.527159369750123100455704702965541866345781113903e-2/
data ww(39)/8.140326425945938045967829319725797511040878579808e-2/
data ww(48)/5.000556431653955124212795201196389006184693561679e-2/
data ww(34)/7.048220002718565366098742295389607994441704889441e-2/
data ww(49)/5.744164831179720106340717579281831675999717767532e-2/
data ww(40)/6.583213447600552906273539578430361199084485578379e-2/
data ww(43)/5.999947605385971985589674757013565610751028128731e-2/
data ww(35)/6.512297339398335645872697307762912795346716454337e-2/
data ww(44)/5.500937980198041736910257988346101839062581489820e-2/
data ww(50)/1.598823797283813438301248206397233634639162043386e-2/
data ww(36)/3.998229150313659724790527138690215186863915308702e-2/
data ww(51)/2.635660410220884993472478832884065450876913559421e-2/
data ww(37)/3.456512257080287509832054272964315588028252136044e-2/
data ww(41)/2.592913726450792546064232192976262988065252032902e-2/
data ww(45)/5.264422421764655969760271538981443718440340270116e-3/
data ww(52)/1.196003937945541091670106760660561117114584656319e-2/
data ww(38)/2.212167975884114432760321569298651047876071264944e-3/
!------------------------
k = ke + 1
is = istart(k)
ks = len(k)
ldl = xu - xl
bb = ldl*0.5
aa = xl + bb
!
y = 0.0
do 10 i = 1,ks
   c = bb*xx(i)
   if (i .gt. l1) fv1(i) = f(aa + c)
   if (i .gt. l2) fv2(i) = f(aa - c)
   j = is + i
   y = y + (fv1(i) + fv2(i))*ww(j)
10 continue
!
y2 = y
y = y*bb
if (l1 .lt. ks) l1 = ks
if (l2 .lt. ks) l2 = ks
if (ke .ne. k1) return
!
ya = 0.0
do 20 i = 1,ks
   j = is + i
   ya = ya + (abs(fv1(i)) + abs(fv2(i)))*ww(j)
20 continue
ya = ya*abs(bb)
!
y2 = y2*0.5
ym = 0.0
do 30 i = 1,ks
   j = is + i
   ym = ym + (abs(fv1(i) - y2) + abs(fv2(i) - y2))*ww(j)
30 continue
ym = ym*abs(bb)
return
end subroutine qxrul

subroutine qxrrd (f,z,lz,xl,xu,r,s,lr,ls)
implicit none
!
!            To reorder the computed functional values before
!            the bisection of an interval
!
!           Parameters
!            on entry
!              F      - REAL
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       declared E X T E R N A L in the driver program.
!
!              XL     - REAL
!                       lower limit of interval
!
!              XU     - REAL
!                       upper limit of interval
!
!              Z      - REAL
!                       vector containing LZ
!                       saved  functional values
!
!              LZ     - INTEGER
!                       number of elements in LZ
!
!            On return
!              R      - REAL
!              S        VECTORS CONTAINING LR, LS
!                       saved  functional values for the new intervals
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTES IN R,S RESPECTIVELY
!
!***ROUTINES CALLED  F
!
real :: f
real, intent(inout) :: r(21), s(21)
real :: z(21)
real, intent(in) :: xu, xl
real :: dlen, centr
integer, intent(inout) :: lr, ls
integer, intent(in) :: lz
!
dlen = (xu - xl)*0.5
centr = xl + dlen
r(1) =  z(3)
r(2) =  z(9)
r(3) =  z(4)
r(4) =  z(5)
r(5) =  z(6)
r(6) =  z(10)
r(7) =  z(7)
s(1) =  z(3)
s(2) =  z(8)
s(3) =  z(2)
s(7) =  z(1)
if (lz .gt. 11) go to 10
!
r(8) =  f(centr + dlen*0.375)
r(9) =  f(centr + dlen*0.625)
r(10) = f(centr + dlen*0.96875)
lr = 10
if (lz .ne. 11) s(4) = f(centr - dlen*0.75)
if (lz .eq. 11) s(4) = z(11)
s(5) =  f(centr - dlen*0.875)
s(6) =  f(centr - dlen*0.9375)
s(8) =  f(centr - dlen*0.375)
s(9) =  f(centr - dlen*0.625)
s(10) = f(centr - dlen*0.96875)
ls = 10
return
!
10 r(8) = z(12)
r(9) = z(13)
r(10) = z(14)
lr = 10
s(4) = z(11)
s(5) = f(centr - dlen*0.875)
s(6) = f(centr - dlen*0.9375)
if (lz .gt. 14) go to 20
s(8)  = f(centr - dlen*0.375)
s(9)  = f(centr - dlen*0.625)
s(10) = f(centr - dlen*0.96875)
ls = 10
return
!
20 r(11) = z(18)
r(12) = z(19)
r(13) = z(20)
r(14) = z(21)
lr = 14
s(8) = z(16)
s(9) = z(15)
s(10) = f(centr - dlen*0.96875)
s(11) = z(17)
ls = 11
return
end subroutine qxrrd

subroutine dqags (f, a, b, epsabs, epsrel, result, abserr, &
&neval, ier, limit, lenw, last, iwork, work)
implicit none
integer, intent(out) :: last
!-----------------------------------------------------------------------
!
!           Double precision computation of a definite integral
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - DOUBLE PRECISION
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - DOUBLE PRECISION
!                     lower limit of integration
!
!            B      - DOUBLE PRECISION
!                     upper limit of integration
!
!            EPSABS - double precision
!                     absolute accuracy requested
!
!            EPSREL - double precision
!                     relative accuracy requested
!
!         On return
!            result - double precision
!                     approximation to the integral
!
!            ABSERR - double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             Result, ABSERR, NEVAL, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - integer
!                    dimensioning parameter for IWORK
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    dimensioning parameter for work
!                    LENW must be at least limit*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            Last  - integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of
!                    significant elements actually in the work
!                    arrays.
!
!         Work arrays
!            IWORK - INTEGER
!                    vector of dimension at least limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) form a decreasing
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            Work  - double precision
!                    vector of dimension at least LENW
!                    on return
!                    WORK(1), ..., WORK(LAST) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) contain
!                     the right end points,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     contain the integral approximations over
!                     the subintervals,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     contain the error estimates.
!
!         Subroutines or functions needed
!              - DQAGSE
!              - DQK21
!              - DQPSRT
!              - DQELG
!              - F (user-provided function)
!              - DPMPAR
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(out) :: abserr
double precision, intent(in) :: b, epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(in) :: lenw, limit
integer :: l1, l2, l3
integer, intent(out) :: neval
!
dimension iwork(limit), work(lenw)
external f
!
!         Check validity of limit and LENW.
!
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for DQAGSE.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call dqagse (f,a,b,epsabs,epsrel,limit,result,abserr,neval, &
&ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine dqags

subroutine dqagse (f,a,b,epsabs,epsrel,limit,result,abserr, &
&neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!           Double precision computation of a definite integral
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - DOUBLE PRECISION
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - DOUBLE PRECISION
!                     lower limit of integration
!
!            B      - DOUBLE PRECISION
!                     upper limit of integration
!
!            EPSABS - double precision
!                     absolute accuracy requested
!
!            EPSREL - double precision
!                     relative accuracy requested
!
!            Limit  - integer
!                     gives an upperbound on the number of
!                     subintervals in the partition of (A,B)
!
!         On return
!            result - double precision
!                     approximation to the integral
!
!            ABSERR - double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             or EPSREL is negative.
!                             Result, ABSERR, NEVAL, last, RLIST(1),
!                             IORD(1) and ELIST(1) are set to zero.
!                             ALIST(1) and BLIST(1) are set to A and B
!                             respectively.
!
!            ALIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (A,B)
!
!            BLIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (A,B)
!
!            RLIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            ELIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     SUBINERVALS
!
!            IORD   - INTEGER
!                     vector of dimension at least limit, the first K
!                     elements of which are pointers to the error
!                     estimates over the subintervals, such
!                     THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     otherwise
!
!            LAST   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!         Subroutines or functions needed
!              - DQK21
!              - DQPSRT
!              - DQELG
!              - F (user-provided function)
!              - DPMPAR
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision :: abseps
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision :: area, area1, area12, area2, a1, a2
double precision, intent(in) :: b
double precision, intent(inout) :: blist
double precision :: b1, b2, correc, defabs, defab1, defab2, &
&dpmpar, dres
double precision, intent(inout) :: elist
double precision :: epmach
double precision, intent(in) :: epsabs, epsrel
double precision :: erlarg, erlast, errbnd, errmax, error1, &
&error2, erro12, errsum, ertest, f, oflow, rerr, resabs, reseps
double precision, intent(out) :: result
double precision :: res3la(3)
double precision, intent(inout) :: rlist
double precision :: rlist2(52), small, t, uflow
integer :: id
integer, intent(out) :: ier
integer :: ierro
integer, intent(inout) :: iord
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer, intent(out) :: last
integer, intent(in) :: limit
integer :: maxerr
integer, intent(out) :: neval
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
&rlist(limit)
!
external f
!
!            The dimension of RLIST2 is determined by the value of
!            LIMEXP in subroutine DQELG (RLIST2 should be of dimension
!            (LIMEXP+2) at least).
!
!            List of major variables
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           RLIST(I)  - approximation to the integral over
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST LIMEXP+2
!                       containing the part of the epsilon table
!                       which is still needed for further computations
!           ELIST(I)  - error estimate applying to RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       estimate
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (before that subdivision has taken place)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT INTERVAL
!           *****2    - VARIABLE FOR THE RIGHT INTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       appropriate approximation to the compounded
!                       integral has been obtained it is put in
!                       RLIST2(NUMRL2) after NUMRL2 has been increased
!                       by one.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED
!                       up to now, multiplied by 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       than the smallest interval considered up to now
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       is attempting to perform extrapolation
!                       I.E. Before subdividing the smallest interval
!                       we try to decrease the value of ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       is no longer allowed (true value)
!
!            Machine dependent constants
!            ---------------------------
!
!           EPMACH is the largest relative spacing.
!           UFLOW is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!
!            Check EPSABS and EPSREL
!            -----------------------
!
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
alist(1) = a
blist(1) = b
rlist(1) = 0.d0
elist(1) = 0.d0
ier = 6
if (epsabs .lt. 0.d0 .or. epsrel .lt. 0.d0) go to 999
ier = 0
rerr = dmax1(epsrel, 50.d0*epmach, 0.5d-28)
!
!           First approximation to the integral
!           -----------------------------------
!
ierro = 0
call dqk21 (f, a, b, result, abserr, defabs, resabs, &
&epmach, uflow, id)
if (id .ne. 0) go to 999
neval = 21
!
!           Test on accuracy.
!
dres = dabs(result)
errbnd = dmax1(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr .le. 100.d0*epmach*defabs .and. abserr .gt. &
&errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0) go to 999
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.d0
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres .ge. (1.d0 - 50.d0*epmach)*defabs) ksgn = 1
t = 1.d0 + 100.d0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with the NRMAX-TH largest
!           error estimate.
!
  a1 = alist(maxerr)
  b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call dqk21 (f, a1, b1, area1, error1, resabs, defab1, &
&epmach, uflow, ier)
  if (ier .ne. 0) go to 100
  call dqk21 (f, a2, b2, area2, error2, resabs, defab2, &
&epmach, uflow, ier)
  neval = neval + 42
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (dabs(rlist(maxerr) - area12) .gt. 0.1d-04*dabs(area12) &
&.or. erro12 .lt. 0.99d0*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last .gt. 10 .and. erro12 .gt. errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = dmax1(epsabs,rerr*dabs(area))
!
!           Test for roundoff error and eventually
!           set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of
!           subintervals equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
!
  if (dmax1(dabs(a1),dabs(b2)) .le. &
&t*(dabs(a2) + 0.1d+04*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
  if (error2 .gt. error1) go to 20
  alist(last) = a2
  blist(maxerr) = b1
  blist(last) = b2
  elist(maxerr) = error1
  elist(last) = error2
  go to 30
20 alist(maxerr) = a2
  alist(last) = a1
  blist(last) = b1
  rlist(maxerr) = area2
  rlist(last) = area1
  elist(maxerr) = error2
  elist(last) = error1
!
!           CALL SUBROUTINE DQPSRT TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with NRMAX-TH largest error estimate (to be
!           bisected next).
!
30 call dqpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
! ***JUMP OUT OF DO-LOOP
  if (errsum .le. errbnd) go to 115
! ***JUMP OUT OF DO-LOOP
  if (ier .ne. 0) go to 100
  if (last .eq. 2) go to 80
  if (noext) go to 90
  erlarg = erlarg - erlast
  if (dabs(b1 - a1) .gt. small) erlarg = erlarg + erro12
  if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (ERLARG) and perform
!           extrapolation.
!
  id = nrmax
  jupbnd = last
  if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
! ***JUMP OUT OF DO-LOOP
    if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
    nrmax = nrmax + 1
50 continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
  rlist2(numrl2) = area
  call dqelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
&epmach, oflow)
  ktmin = ktmin + 1
  if (ktmin .gt. 5 .and. abserr .lt. 0.1d-02*errsum) ier = 5
  if (abseps .ge. abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = dmax1(epsabs,rerr*dabs(reseps))
! ***JUMP OUT OF DO-LOOP
  if (abserr .le. ertest) go to 100
!
!           Prepare bisection of the smallest interval.
!
70 if (numrl2 .eq. 1) noext = .true.
  if (ier .eq. 5) go to 100
  maxerr = iord(1)
  errmax = elist(maxerr)
  nrmax = 1
  extrap = .false.
  small = small*0.5d0
  erlarg = errsum
  go to 90
80 small = dabs(b - a)*0.375d0
  erlarg = errsum
  ertest = errbnd
  rlist2(2) = area
90 continue
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.d0 .and. area .ne. 0.d0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.d0) go to 130
go to 110
105 if (abserr/dabs(result) .gt. errsum/dabs(area)) go to 115
!
!           Test on divergence.
!
110 if (ksgn .eq. -1 .and. dmax1(dabs(result),dabs(area)) .le. &
&defabs*0.1d-01) go to 130
if (0.1d-01 .gt. (result/area) .or. (result/area) .gt. 0.1d+03 &
&.or. errsum .gt. dabs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine dqagse

