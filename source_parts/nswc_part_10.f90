subroutine cspp (t, a, ka, m, n, z, kz, dz, kdz)
implicit none
integer, intent(in) :: ka, kdz, kz, m, n
integer :: i, il, ilj, ilkj, j, jj, jp1, k, kmj, l, left, mp1, mu
real :: del, diff, r, s, term, x
!-----------------------------------------------------------------------
!
!            COMPUTATION OF N CUBIC SPLINES AND THEIR FIRST
!            DERIVATIVES AT THE KNOTS T(4),...,T(M+1). THE
!            CUBIC SPLINES ARE REPRESENTED IN B-SPLINE FORM.
!
!                          ---------------
!
!     INPUT ...
!
!       T     KNOT SEQUENCE OF LENGTH M+4.
!       A     M X N MATRIX. EACH COLUMN OF A IS A SEQUENCE
!             OF M B-SPLINE COEFFICIENTS FOR A CUBIC SPLINE.
!       KA    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             PROGRAM FOR A. IT IS ASSUMED THAT KA .GE. M.
!       M     DIMENSION OF THE B-SPLINE SPACE.
!       N     NUMBER OF CUBIC SPLINES CONSIDERED.
!       KZ    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             PROGRAM FOR Z. IT IS ASSUMED THAT KZ .GE. N.
!       KDZ   THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             PROGRAM FOR DZ. IT IS ASSUMED THAT KZ .GE. N.
!
!     OUTPUT ...
!
!       Z     N X (M-2) MATRIX WHERE Z(J,I) = VALUE OF J-TH CUBIC
!             SPLINE AT THE POINT T(I+3) FOR I = 1,...,M-2.
!
!       DZ    N X (M-2) MATRIX WHERE DZ(J,I) = FIRST DERIVATIVE OF
!             THE J-TH CUBIC SPLINE EVALUATED AT THE POINT T(I+3).
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
!        OBTAING THE VALUES FOR THE MU-TH CUBIC SPLINE
!
   l = 0
   do left = k,m
      l = l + 1
!
!           COMPUTE THE COEFFICIENTS FOR THE L-TH
!           POLYNOMIAL FORMING THE CUBIC SPLINE. THE
!           COEFFICIENTS ARE STORED IN C. THIS CODE
!           IS FROM THE SUBROUTINE BSPP.
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
!           STORE THE VALUE OF THE SPLINE AND ITS
!           FIRST DERIVATIVE AT THE KNOT T(LEFT)
!
      z(mu,l) = c(1)
      dz(mu,l) = c(2)
   end do
!
!        COMPUTE THE SPLINE AND ITS FIRST DERIVATIVE
!                    AT THE KNOT T(M+1)
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
!             EVALUATION OR DIFFERENTIATION OF A BICUBIC
!                        SPLINE OVER A GRID
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
!        LINEAR FORWARD SEARCH
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
!           LINEAR FORWARD SEARCH
!
140 if (xx .lt. s(i + 1)) go to 210
150 i = i + 1
         if (xx .ge. s(i + 1)) go to 150
!
!           COMPUTATION OF THE JDER-TH DERIVATIVE OF
!           F(S(I),Y), D1F(S(I),Y), F(S(I+1),Y), AND
!           D1F(S(I+1),Y) AT THE POINT YY.
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
!           COMPUTATION OF THE IDER-TH DERIVATIVE
!           AT THE POINT XX.
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
!     CASE WHEN THE RESULTS ARE ZERO.
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
!             EVALUATION OR DIFFERENTIATION OF A BICUBIC
!                        SPLINE OVER A GRID
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
!             EVALUATION OR DIFFERENTIATION OF A BICUBIC
!                        SPLINE OVER A GRID
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
!        LINEAR FORWARD SEARCH
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
!           LINEAR FORWARD SEARCH
!
140 if (xx .lt. s(i + 1)) go to 210
150 i = i + 1
         if (xx .ge. s(i + 1)) go to 150
!
!           COMPUTATION OF THE JDER-TH DERIVATIVE OF
!           F(S(I),Y), D1F(S(I),Y), F(S(I+1),Y), AND
!           D1F(S(I+1),Y) AT THE POINT YY.
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
!           COMPUTATION OF THE IDER-TH DERIVATIVE
!           AT THE POINT XX.
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
!     CASE WHEN THE RESULTS ARE ZERO.
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
!             EVALUATION OR DIFFERENTIATION OF A BICUBIC
!                        SPLINE OVER A GRID
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
! THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
! COMPUTE AN INTERPOLATORY SURFACE PASSING THROUGH A RECT-
! ANGULAR GRID OF FUNCTIONAL VALUES. THE SURFACE DETERMINED
! CAN BE REPRESENTED AS THE TENSOR PRODUCT OF SPLINES UNDER
! TENSION. THE X- AND Y-PARTIAL DERIVATIVES AROUND THE
! BOUNDARY AND THE X-Y-PARTIAL DERIVATIVES AT THE FOUR
! CORNERS MAY BE SPECIFIED OR OMITTED. FOR ACTUAL MAPPING
! OF POINTS ONTO THE SURFACE IT IS NECESSARY TO CALL THE
! FUNCTION SURF2.
!
! ON INPUT--
!
!   M IS THE NUMBER OF GRID LINES IN THE X-DIRECTION, I. E.
!   LINES PARALLEL TO THE Y-AXIS (M .GE. 2).
!
!   N IS THE NUMBER OF GRID LINES IN THE Y-DIRECTION, I. E.
!   LINES PARALLEL TO THE X-AXIS (N .GE. 2).
!
!   X IS AN ARRAY OF THE M X-COORDINATES OF THE GRID LINES
!   IN THE X-DIRECTION. THESE SHOULD BE STRICTLY INCREASING.
!
!   Y IS AN ARRAY OF THE N Y-COORDINATES OF THE GRID LINES
!   IN THE Y-DIRECTION. THESE SHOULD BE STRICTLY INCREASING.
!
!   Z IS AN ARRAY OF THE M * N FUNCTIONAL VALUES AT THE GRID
!   POINTS, I. E. Z(I,J) CONTAINS THE FUNCTIONAL VALUE AT
!   (X(I),Y(J)) FOR I = 1,...,M AND J = 1,...,N.
!
!   IZ IS THE ROW DIMENSION OF THE MATRIX Z USED IN THE
!   CALLING PROGRAM (IZ .GE. M).
!
!   OPT IS AN OPTION VECTOR. IF NO BOUNDARY CONDITIONS ARE
!   TO BE IMPOSED ON THE SURFACE THEN LET OPT BE OF LENGTH 1
!   AND SET OPT(1)=0. OTHERWISE, SEE THE DESCRIPTION OF SURF
!   IN THE NSWC LIBRARY MANUAL.
!
!   ZP IS AN ARRAY OF AT LEAST 3*M*N LOCATIONS.
!
!   TEMP IS AN ARRAY OF AT LEAST N+N+M LOCATIONS WHICH IS
!   USED FOR SCRATCH STORAGE.
!
!   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
!   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
!   (E. G. .001) THE RESULTING SURFACE IS APPROXIMATELY THE
!   TENSOR PRODUCT OF CUBIC SPLINES. IF ABS(SIGMA) IS LARGE
!   (E. G. 50.) THE RESULTING SURFACE IS APPROXIMATELY
!   BI-LINEAR. IF SIGMA EQUALS ZERO TENSOR PRODUCTS OF
!   CUBIC SPLINES RESULT. A STANDARD VALUE FOR SIGMA IS
!   APPROXIMATELY 1. IN ABSOLUTE VALUE.
!
! ON OUTPUT--
!
!   ZP CONTAINS THE VALUES OF THE XX-, YY-, AND XXYY-PARTIAL
!   DERIVATIVES OF THE SURFACE AT THE GIVEN NODES.
!
!   IERR CONTAINS AN ERROR FLAG,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2 OR M IS LESS THAN 2,
!        = 2 IF THE X-VALUES OR Y-VALUES ARE NOT STRICTLY
!            INCREASING,
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
! PROCESS THE OPTION VECTOR
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
! DENORMALIZE TENSION FACTOR IN Y-DIRECTION
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
! DENORMALIZE TENSION FACTOR IN X-DIRECTION
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
! OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(1),Y(1))
!
15 if (ind(5) .eq. 0) go to 16
l = loc(5)
zp(1,1,3) = opt(l)
go to 17
16 zp(1,1,3) = c1*zp(1,1,1)+c2*zp(2,1,1)
if (m .gt. 2) zp(1,1,3) = zp(1,1,3)+c3*zp(3,1,1)
!
! OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(1),Y(N))
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
! OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(M),Y(1))
!
24 if (ind(6) .eq. 0) go to 25
l = loc(6)
zp(m,1,3) = opt(l)
go to 26
25 zp(m,1,3) = c1*zp(m,1,1)+c2*zp(mm1,1,1)
if (m .gt. 2) zp(m,1,3) = zp(m,1,3)+c3*zp(m-2,1,1)
!
! OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(M),Y(N))
!
26 if (ind(8) .eq. 0) go to 27
l = loc(8)
zxymns = opt(l)
go to 28
27 zxymns = c1*temp(npm)+c2*temp(npm-1)
if (m .gt. 2) zxymns = zxymns+c3*temp(npm-2)
!
! SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR Y-GRID
! PERFORM FORWARD ELIMINATION
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
! PERFORM BACK SUBSTITUTION
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
! SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR X-GRID
! PERFORM FORWARD ELIMINATION
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
! PERFORM BACK SUBSTITUTION
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
! TOO FEW POINTS
!
46 ierr = 1
return
!
! POINTS NOT STRICTLY INCREASING
!
47 ierr = 2
return
!
! THE OPTION VECTOR HAS AN ERROR
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
! THIS FUNCTION INTERPOLATES A SURFACE AT A GIVEN COORDINATE
! PAIR USING A BI-SPLINE UNDER TENSION. THE SUBROUTINE SURF1
! SHOULD BE CALLED EARLIER TO DETERMINE CERTAIN NECESSARY
! PARAMETERS.
!
! ON INPUT--
!
!   XX AND YY CONTAIN THE X- AND Y-COORDINATES OF THE POINT
!   TO BE MAPPED ONTO THE INTERPOLATING SURFACE.
!
!   M AND N CONTAIN THE NUMBER OF GRID LINES IN THE X- AND
!   Y-DIRECTIONS, RESPECTIVELY, OF THE RECTANGULAR GRID
!   WHICH SPECIFIED THE SURFACE.
!
!   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-GRID VALUES,
!   RESPECTIVELY, EACH IN INCREASING ORDER.
!
!   Z IS A MATRIX CONTAINING THE M * N FUNCTIONAL VALUES
!   CORRESPONDING TO THE GRID VALUES (I. E. Z(I,J) IS THE
!   SURFACE VALUE AT THE POINT (X(I),Y(J)) FOR I = 1,...,M
!   AND J = 1,...,N).
!
!   IZ CONTAINS THE ROW DIMENSION OF THE ARRAY Z AS DECLARED
!   IN THE CALLING PROGRAM.
!
!   ZP IS AN ARRAY OF 3*M*N LOCATIONS STORED WITH THE
!   VARIOUS SURFACE DERIVATIVE INFORMATION DETERMINED BY
!   SURF1.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS M, N, X, Y, Z, IZ, ZP, AND SIGMA SHOULD BE
! INPUT UNALTERED FROM THE OUTPUT OF SURF1.
!
! ON OUTPUT--
!
!   SURF2 CONTAINS THE INTERPOLATED SURFACE VALUE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! INLINE ONE DIMENSIONAL CUBIC SPLINE INTERPOLATION
!
hermz (f1,f2,fp1,fp2) = (f2*del1+f1*del2)/dels-del1* &
&del2*(fp2*(del1+dels)+ &
&fp1*(del2+dels))/ &
&(6.*dels)
!
! INLINE ONE DIMENSIONAL SPLINE UNDER TENSION INTERPOLATION
!
hermnz (f1,f2,fp1,fp2,sigmap) = (f2*del1+f1*del2)/dels &
&+(fp2*(sinhm1*del2-del1*(2.*(coshp1+1.)* &
&sinhp2+sigmap*coshp1*del2)) &
&+fp1*(sinhm2*del1-del2*(2.*(coshp2+1.)* &
&sinhp1+sigmap*coshp2*del1)) &
&)/(sigmap*sigmap*dels*(sinhms+sigmap*dels))
!
! DENORMALIZE TENSION FACTOR IN X AND Y DIRECTION
!
sigmax = abs(sigma)*float(m-1)/(x(m)-x(1))
sigmay = abs(sigma)*float(n-1)/(y(n)-y(1))
!
! DETERMINE Y INTERVAL
!
jm1 = intrvl (yy,y,n)
j = jm1+1
!
! DETERMINE X INTERVAL
!
im1 = intrvl (xx,x,m)
i = im1+1
del1 = yy-y(jm1)
del2 = y(j)-yy
dels = y(j)-y(jm1)
if (sigmay .ne. 0.) go to 1
!
! PERFORM FOUR INTERPOLATIONS IN Y-DIRECTION
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
! PERFORM FINAL INTERPOLATION IN X-DIRECTION
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
! THIS SUBROUTINE MAPS VALUES ONTO A SURFACE AT EVERY POINT
! OF A GRID EQUALLY SPACED IN BOTH X AND Y COORDINATES. THE
! SURFACE INTERPOLATION IS PERFORMED USING A BI-SPLINE
! UNDER TENSION. THE SUBROUTINE SURF1 OR NSURF1 SHOULD BE
! CALLED EARLIER TO DETERMINE CERTAIN NECESSARY PARAMETERS.
!
! ON INPUT--
!
!   DXMIN AND DXMAX CONTAIN THE LOWER AND UPPER LIMITS,
!   RESPECTIVELY, OF THE X-COORDINATES OF THE SECOND GRID.
!
!   MD CONTAINS THE NUMBER OF GRID LINES IN THE X DIRECTION
!   OF THE SECOND GRID (MD .GE. 1).
!
!   DYMIN AND DYMAX CONTAIN THE LOWER AND UPPER LIMITS,
!   RESPECTIVELY, OF THE Y-COORDINATES OF THE SECOND GRID.
!
!   ND CONTAINS THE NUMBER OF GRID LINES IN THE Y DIRECTION
!   OF THE SECOND GRID (ND .GE. 1).
!
!   IDZ CONTAINS THE ROW DIMENSION OF THE ARRAY DZ AS
!   DECLARED IN THE CALLING PROGRAM.
!
!   M AND N CONTAIN THE NUMBER OF GRID LINES IN THE X- AND
!   Y-DIRECTIONS, RESPECTIVELY, OF THE RECTANGULAR GRID
!   WHICH SPECIFIED THE SURFACE.
!
!   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-GRID VALUES,
!   RESPECTIVELY, EACH IN INCREASING ORDER.
!
!   Z IS A MATRIX CONTAINING THE M * N FUNCTIONAL VALUES
!   CORRESPONDING TO THE GRID VALUES (I. E. Z(I,J) IS THE
!   SURFACE VALUE AT THE POINT (X(I),Y(J)) FOR I = 1,...,M
!   AND J = 1,...,N).
!
!   IZ CONTAINS THE ROW DIMENSION OF THE ARRAY Z AS DECLARED
!   IN THE CALLING PROGRAM.
!
!   ZP IS AN ARRAY OF 3*M*N LOCATIONS STORED WITH THE
!   VARIOUS SURFACE DERIVATIVE INFORMATION DETERMINED BY
!   SURF1.
!
!   WORK IS AN ARRAY OF 4*MD LOCATIONS TO BE USED INTERNALLY
!   FOR WORKSPACE.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS M, N, X, Y, Z, IZ, ZP, AND SIGMA SHOULD BE
! INPUT UNALTERED FROM THE OUTPUT OF SURF1 OR NSURF1.
!
! ON OUTPUT--
!
!   DZ CONTAINS THE MD BY ND ARRAY OF SURFACE VALUES
!   INTERPOLATED AT THE POINTS OF THE SECOND GRID.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS FUNCTION REFERENCES PACKAGE MODULE SNHCSH.
!
!-----------------------------------------------------------
!
! DENORMALIZE TENSION FACTOR IN X AND Y DIRECTION
!
sigmax = abs(sigma)*float(m-1)/(x(m)-x(1))
sigmay = abs(sigma)*float(n-1)/(y(n)-y(1))
!
! FIND INTERVALS OF SECOND X GRID WITH RESPECT TO ORIGINAL X
! GRID
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
! FIND INTERVALS OF SECOND Y GRID WITH RESPECT TO ORIGINAL Y
! GRID AND PERFORM INTRPOLATION
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
!         PIECEWISE POLYNOMIAL INTERPOLATION IN TWO VARIABLES
!
!                          -----------------
!
!     THE PIECEWISE POLYNOMIALS CONSIDERED ARE TENSOR PRODUCTS OF
!     B-SPLINES, HAVING THE FORM
!
!                          NX   NY
!              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                         I=1  J=1   IJ  I     J
!
!     WHERE U  AND V  ARE ONE-DIMENSIONAL B-SPLINE BASIS FUNCTIONS.
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
!     COMPUTE THE COEFFICIENTS
!
iw = nx*ny + 1
call bstrp1 (x, z, kz, nx, ny, tx, kx, wk, ny, wk(iw), iflag)
if (iflag .ne. 0) go to 100
call bstrp1 (y, wk, ny, ny, nx, ty, ky, a, ka, wk(iw), iflag)
if (iflag .ne. 0) go to 110
return
!
!     ERROR RETURN
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
!     BSTRP1 COMPUTES B-SPLINE INTERPOLATION COEFFICIENTS FOR
!     N SETS OF DATA STORED IN THE COLUMNS OF THE ARRAY Z. THE
!     COEFFICIENTS ARE STORED IN THE ROWS OF A.
!
!     IT IS ASSUMED THAT KZ .GE. M AND KA .GE. N.
!-------------------------------------------------------------------
!     REAL T(M + K), WORK(2*K*M)
!-----------------------
real, intent(in) :: x(m), z(kz,n), t(*)
real, intent(inout) :: a(ka,m), work(*)
!
!     FIRST DATA SET
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
!     REMAINING DATA SETS
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
!             WEIGHTED LEAST SQUARES FITTING OF PIECEWISE
!                    POLYNOMIALS IN TWO VARIABLES
!
!                          ----------------
!
!     THE PIECEWISE POLYNOMIALS CONSIDERED ARE TENSOR PRODUCTS OF
!     B-SPLINES, HAVING THE FORM
!
!                          NX   NY
!              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                         I=1  J=1   IJ  I     J
!
!     WHERE U  AND V  ARE ONE-DIMENSIONAL B-SPLINE BASIS FUNCTIONS.
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
!     COMPUTE THE COEFFICIENTS
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
!     ERROR RETURN
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
!     BSLSQ1 PRODUCES THE B-SPLINE COEFFICIENTS A(J,1),...,A(J,N)
!     OF THE PIECEWISE POLYNOMIAL P(X) OF ORDER K WITH KNOTS T(I)
!     (I = 1,...,N+K) WHICH MINIMIZES
!
!              SUM (WGT(L)*(P(TAU(L)) - Z(L,J))**2)
!                 L
!
!     FOR J = 1,...,M.
!
!     INPUT ...
!
!       TAU   ARRAY OF LENGTH NTAU CONTAINING DATA POINT ABSCISSAE.
!       WGT   ARRAY OF LENGTH NTAU CONTAINING THE WEIGHTS.
!       NTAU  NUMBER OF DATA POINTS TO BE FITTED (NTAU .GE. N).
!       Z     MATRIX CONTAINING M SETS OF ORDINATES TO BE FITTED.
!             EACH SET OF NTAU ORDINATES IS A COLUMN OF Z.
!       KZ    NUMBER OF ROWS OF Z IN THE CALLING PROGRAM.
!             IT IS ASSUMED THAT KZ .GE. NTAU.
!       M     NUMBER OF SETS OF ORDINATES TO BE FITTED.
!       T     KNOT SEQUENCE OF LENGTH N+K.
!       N     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!       K     ORDER OF THE B-SPLINES.
!       KA    NUMBER OF ROWS OF A IN THE CALLING PROGRAM.
!             IT IS ASSUMED THAT KA .GE. M.
!
!     OUTPUT ...
!
!       A     MATRIX CONTAINING THE M SETS OF B-SPLINE COEFFICIENTS
!             OF THE L2 APPROXIMATIONS. EACH SET OF N COEFFICIENTS
!             IS A ROW OF A.
!
!       IERR  INTEGER REPORTING THE STATUS OF THE RESULTS ...
!
!             0  THE COEFFICIENT MATRIX IS NONSIGULAR. THE
!                UNIQUE LEAST SQUARES SOLUTION WAS OBTAINED.
!             1  THE COEFFICIENT MATRIX IS SINGULAR. A
!                LEAST SQUARES SOLUTION WAS OBTAINED.
!            -1  INPUT ERRORS WERE DETECTED.
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
!        SOLVE THE NORMAL EQUATIONS
!
call bchfac (q, k, n, wk, ierr)
call bchsv1 (q, k, n, a, ka, m)
return
!
!             ERROR RETURN
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
!     EACH B  IS A VECTOR STORED IN THE I-TH ROW OF A MATRIX B.
!           I
!                       ------------------
!
!     INPUT ...
!
!        N   THE ORDER OF THE MATRIX C
!        NB  THE BANDWIDTH OF C
!        W   THE CHOLESKY FACTORIZATION OF THE BANDED SYMMETRIC
!            POSITIVE DEFINITE MATRIX C OBTAINED BY THE ROUTINE
!            BCHFAC.
!        B   MATRIX WHOSE ROWS ARE THE VECTORS TO BE SOLVED FOR
!            IN THE M LINEAR SYSTEMS OF EQUATIONS.
!        KB  THE NUMBER OF ROWS OF B SPECIFIED IN THE CALLING
!            PROGRAM. IT IS ASSUMED THAT KB .GE. M.
!        M   NUMBER OF LINEAR SYSTEMS TO BE SOLVED.
!
!     OUTPUT ...
!
!        B   MATRIX WHOSE ROWS ARE THE SOLUTIONS X  OF THE M
!            LINEAR SYSTEMS OF EQUATIONS.         I
!
!                                       T
!     NOTE.  THE FACTORIZATION C = L*D*L  IS USED, WHERE L IS A
!     UNIT LOWER TRIANGULAR MATRIX AND D A DIAGONAL MATRIX.
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
!                EVALUATION AND PARTIAL DIFFERENTIATION
!                      OF A PIECEWISE POLYNOMIAL
!
!                            NX   NY
!                F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                           I=1  J=1   IJ  I     J
!
!     WHERE U  AND V  ARE ONE-DIMENSIONAL B-SPLINE BASIS FUNCTIONS.
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE CREATES A THIESSEN TRIANGULATION OF N
! ARBITRARILY SPACED POINTS IN THE PLANE REFERRED TO AS
! NODES.  THE TRIANGULATION IS OPTIMAL IN THE SENSE THAT IT
! IS AS NEARLY EQUIANGULAR AS POSSIBLE.  TRMESH IS PART OF
! AN INTERPOLATION PACKAGE WHICH ALSO PROVIDES SUBROUTINES
! TO REORDER THE NODES, ADD A NEW NODE, DELETE AN ARC, PLOT
! THE MESH, AND PRINT THE DATA STRUCTURE.
!   UNLESS THE NODES ARE ALREADY ORDERED IN SOME REASONABLE
! FASHION, THEY SHOULD BE REORDERED BY SUBROUTINE REORDR FOR
! INCREASED EFFICIENCY BEFORE CALLING TRMESH.
!
! INPUT PARAMETERS -     N - NUMBER OF NODES IN THE MESH.
!                            N .GE. 3.
!
!                      X,Y - N-VECTORS OF COORDINATES.
!                            (X(I),Y(I)) DEFINES NODE I.
!
!                     IADJ - VECTOR OF LENGTH .GE. 6*N-9.
!
!                     IEND - VECTOR OF LENGTH .GE. N.
!
! N, X, AND Y ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS - IADJ - ADJACENCY LISTS OF NEIGHBORS IN
!                            COUNTERCLOCKWISE ORDER.  THE
!                            LIST FOR NODE I+1 FOLLOWS THAT
!                            FOR NODE I WHERE X AND Y DEFINE
!                            THE ORDER.  THE VALUE 0 DENOTES
!                            THE BOUNDARY (OR A PSEUDO-NODE
!                            AT INFINITY) AND IS ALWAYS THE
!                            LAST NEIGHBOR OF A BOUNDARY
!                            NODE.  IADJ IS UNCHANGED IF IER
!                            .NE. 0.
!
!                     IEND - POINTERS TO THE ENDS OF
!                            ADJACENCY LISTS (SETS OF
!                            NEIGHBORS) IN IADJ.  THE
!                            NEIGHBORS OF NODE 1 BEGIN IN
!                            IADJ(1).  FOR K .GT. 1, THE
!                            NEIGHBORS OF NODE K BEGIN IN
!                            IADJ(IEND(K-1)+1) AND K HAS
!                            IEND(K) - IEND(K-1) NEIGHBORS
!                            INCLUDING (POSSIBLY) THE
!                            BOUNDARY.  IADJ(IEND(K)) .EQ. 0
!                            IFF NODE K IS ON THE BOUNDARY.
!                            IEND IS UNCHANGED IF IER = 1.
!                            IF IER = 2 IEND CONTAINS THE
!                            INDICES OF A SEQUENCE OF N
!                            NODES ORDERED FROM LEFT TO
!                            RIGHT WHERE LEFT AND RIGHT ARE
!                            DEFINED BY ASSUMING NODE 1 IS
!                            TO THE LEFT OF NODE 2.
!
!                      IER - ERROR INDICATOR
!                            IER = 0 IF NO ERRORS WERE
!                                    ENCOUNTERED.
!                            IER = 1 IF N .LT. 3.
!                            IER = 2 IF N .GE. 3 AND ALL
!                                    NODES ARE COLLINEAR.
!
! MODULES REFERENCED BY TRMESH - SHIFTD, ADNODE, TRFIND,
!                                INTADD, BDYADD, SWPTST,
!                                SWAPD, TINDX
!
!***********************************************************
!
integer :: nn, k, km1, nl, nr, ind, indx, n0, itemp, ierr, km1d2, &
&kmi, i, kmin
real :: xl, yl, xr, yr, dxr, dyr, xk, yk, dxk, dyk, cprod, sprod
!
! LOCAL PARAMETERS -
!
! NN =          LOCAL COPY OF N
! K =           NODE (INDEX) TO BE INSERTED INTO IEND
! KM1 =         K-1 - (VARIABLE) LENGTH OF IEND
! NL,NR =       IEND(1), IEND(KM1) -- LEFTMOST AND RIGHTMOST
!                 NODES IN IEND AS VIEWED FROM THE RIGHT OF
!                 1-2 WHEN IEND CONTAINS THE INITIAL ORDERED
!                 SET OF NODAL INDICES
! XL,YL,XR,YR = X AND Y COORDINATES OF NL AND NR
! DXR,DYR =     XR-XL, YR-YL
! XK,YK =       X AND Y COORDINATES OF NODE K
! DXK,DYK =     XK-XL, YK-YL
! CPROD =       VECTOR CROSS PRODUCT OF NL-NR AND NL-K --
!                 USED TO DETERMINE THE POSITION OF NODE K
!                 WITH RESPECT TO THE LINE DEFINED BY THE
!                 NODES IN IEND
! SPROD =       SCALAR PRODUCT USED TO DETERMINE THE
!                 INTERVAL CONTAINING NODE K WHEN K IS ON
!                 THE LINE DEFINED BY THE NODES IN IEND
! IND,INDX =    INDICES FOR IEND AND IADJ, RESPECTIVELY
! N0,ITEMP =    TEMPORARY NODES (INDICES)
! IERR =        DUMMY PARAMETER FOR CALL TO ADNODE
! KM1D2,KMI,I = KM1/2, K-I, DO-LOOP INDEX -- USED IN IEND
!                 REORDERING LOOP
! KMIN =        FIRST NODE INDEX SENT TO ADNODE
!
nn = n
ier = 1
if (nn .lt. 3) return
ier = 0
!
! INITIALIZE IEND, NL, NR, AND K
!
iend(1) = 1
iend(2) = 2
xl = x(1)
yl = y(1)
xr = x(2)
yr = y(2)
k = 2
!
! BEGIN LOOP ON NODES 3,4,...
!
1 dxr = xr-xl
dyr = yr-yl
!
! NEXT LOOP BEGINS HERE IF NL AND NR ARE UNCHANGED
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
! NODE K LIES ON THE LINE CONTAINING NODES 1,2,...,K-1.
!   SET SPROD TO (NL-NR,NL-K).
!
sprod = dxr*dxk + dyr*dyk
if (sprod .gt. 0.) go to 3
!
! NODE K IS TO THE LEFT OF NL.  INSERT K AS THE FIRST
!   (LEFTMOST) NODE IN IEND AND SET NL TO K.
!
call shiftd(1,km1,1, iend )
iend(1) = k
xl = xk
yl = yk
go to 1
!
! NODE K IS TO THE RIGHT OF NL.  FIND THE LEFTMOST NODE
!   N0 WHICH LIES TO THE RIGHT OF K.
!   SET SPROD TO (N0-NL,N0-K).
!
3 do 4 ind = 2,km1
  n0 = iend(ind)
  sprod = (xl-x(n0))*(xk-x(n0)) + &
&(yl-y(n0))*(yk-y(n0))
  if (sprod .ge. 0.) go to 5
4 continue
!
! NODE K IS TO THE RIGHT OF NR.  INSERT K AS THE LAST
!   (RIGHTMOST) NODE IN IEND AND SET NR TO K.
!
iend(k) = k
xr = xk
yr = yk
go to 1
!
! NODE K LIES BETWEEN IEND(IND-1) AND IEND(IND).  INSERT K
!   IN IEND.
!
5 call shiftd(ind,km1,1, iend )
iend(ind) = k
go to 2
!
! NODE K IS TO THE LEFT OF NL-NR.  REORDER IEND SO THAT NL
!   IS THE LEFTMOST NODE AS VIEWED FROM K.
!
6 km1d2 = km1/2
do i = 1,km1d2
  kmi = k-i
  itemp = iend(i)
  iend(i) = iend(kmi)
  iend(kmi) = itemp
  end do
!
! NODE K IS TO THE RIGHT OF NL-NR.  CREATE A TRIANGULATION
!   CONSISTING OF NODES 1,2,...,K.
!
8 nl = iend(1)
nr = iend(km1)
!
! CREATE THE ADJACENCY LISTS FOR THE FIRST K-1 NODES.
!   INSERT NEIGHBORS IN REVERSE ORDER.  EACH NODE HAS FOUR
!   NEIGHBORS EXCEPT NL AND NR WHICH HAVE THREE.
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
! CREATE THE ADJACENCY LIST FOR NODE K
!
indx = 5*km1 - 1
iadj(indx) = 0
do ind = 1,km1
  indx = indx-1
  iadj(indx) = iend(ind)
  end do
!
! REPLACE IEND ELEMENTS WITH POINTERS TO IADJ
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
! ADD THE REMAINING NODES TO THE TRIANGULATION
!
if (k .eq. nn) return
kmin = k+1
do k = kmin,nn
  call adnode(k,x,y, iadj,iend, ierr)
  end do
return
!
! ALL NODES ARE COLLINEAR
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE ADDS NODE KK TO A TRIANGULATION OF A SET
! OF POINTS IN THE PLANE PRODUCING A NEW TRIANGULATION.  A
! SEQUENCE OF EDGE SWAPS IS THEN APPLIED TO THE MESH,
! RESULTING IN AN OPTIMAL TRIANGULATION.  ADNODE IS PART
! OF AN INTERPOLATION PACKAGE WHICH ALSO PROVIDES ROUTINES
! TO INITIALIZE THE DATA STRUCTURE, PLOT THE MESH, AND
! DELETE ARCS.
!
! INPUT PARAMETERS -   KK - INDEX OF THE NODE TO BE ADDED
!                           TO THE MESH.  KK .GE. 4.
!
!                     X,Y - VECTORS OF COORDINATES OF THE
!                           NODES IN THE MESH.  (X(I),Y(I))
!                           DEFINES NODE I FOR I = 1,..,KK.
!
!                    IADJ - SET OF ADJACENCY LISTS OF NODES
!                           1,..,KK-1.
!
!                    IEND - POINTERS TO THE ENDS OF
!                           ADJACENCY LISTS IN IADJ FOR
!                           EACH NODE IN THE MESH.
!
! IADJ AND IEND MAY BE CREATED BY TRMESH.
!
! KK, X, AND Y ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ADDITION
!                                 OF NODE KK AS THE LAST
!                                 ENTRY.
!
!                           IER - ERROR INDICATOR
!                                 IER = 0 IF NO ERRORS
!                                         WERE ENCOUNTERED.
!                                 IER = 1 IF ALL NODES
!                                         (INCLUDING KK) ARE
!                                         COLLINEAR.
!
! MODULES REFERENCED BY ADNODE - TRFIND, INTADD, BDYADD,
!                                SHIFTD, TINDX, SWPTST,
!                                SWAPD
!
!***********************************************************
!
integer :: k, km1, i1, i2, i3, indkf, indkl, nabor1, io1, io2, &
&in1, indk1, ind2f, ind21
real :: xk, yk
!
! LOCAL PARAMETERS -
!
! K =        LOCAL COPY OF KK
! KM1 =      K - 1
! I1,I2,I3 = VERTICES OF A TRIANGLE CONTAINING K
! INDKF =    IADJ INDEX OF THE FIRST NEIGHBOR OF K
! INDKL =    IADJ INDEX OF THE LAST NEIGHBOR OF K
! NABOR1 =   FIRST NEIGHBOR OF K BEFORE ANY SWAPS OCCUR
! IO1,IO2 =  ADJACENT NEIGHBORS OF K DEFINING AN ARC TO
!              BE TESTED FOR A SWAP
! IN1 =      VERTEX OPPOSITE K -- FIRST NEIGHBOR OF IO2
!              WHICH PRECEDES IO1.  IN1,IO1,IO2 ARE IN
!              COUNTERCLOCKWISE ORDER.
! INDK1 =    INDEX OF IO1 IN THE ADJACENCY LIST FOR K
! IND2F =    INDEX OF THE FIRST NEIGHBOR OF IO2
! IND21 =    INDEX OF IO1 IN THE ADJACENCY LIST FOR IO2
! XK,YK =    X(K), Y(K)
!
ier = 0
k = kk
!
! INITIALIZATION
!
km1 = k - 1
xk = x(k)
yk = y(k)
!
! ADD NODE K TO THE MESH
!
call trfind(km1,xk,yk,x,y,iadj,iend, i1,i2,i3)
if (i1 .eq. 0) go to 5
if (i3 .eq. 0) call bdyadd(k,i1,i2, iadj,iend )
if (i3 .ne. 0) call intadd(k,i1,i2,i3, iadj,iend )
!
! INITIALIZE VARIABLES FOR OPTIMIZATION OF THE MESH
!
indkf = iend(km1) + 1
indkl = iend(k)
nabor1 = iadj(indkf)
io2 = nabor1
indk1 = indkf + 1
io1 = iadj(indk1)
!
! BEGIN LOOP -- FIND THE VERTEX OPPOSITE K
!
1 ind2f = 1
if (io2 .ne. 1) ind2f = iend(io2-1) + 1
ind21 = tindx(io2,io1,iadj,iend)
if (ind2f .eq. ind21) go to 2
in1 = iadj(ind21-1)
go to 3
!
! IN1 IS THE LAST NEIGHBOR OF IO2
!
2 ind21 = iend(io2)
in1 = iadj(ind21)
if (in1 .eq. 0) go to 4
!
! SWAP TEST -- IF A SWAP OCCURS, TWO NEW ARCS ARE OPPOSITE K
!              AND MUST BE TESTED.  INDK1 AND INDKF MUST BE
!              DECREMENTED.
!
3 if ( .not. swptst(in1,k,io1,io2,x,y) ) go to 4
call swapd (in1,k,io1,io2, iadj,iend)
io1 = in1
indk1 = indk1 - 1
indkf = indkf - 1
go to 1
!
! NO SWAP OCCURRED.  RESET IO2 AND IO1, AND TEST FOR
!   TERMINATION.
!
4 if (io1 .eq. nabor1) return
io2 = io1
indk1 = indk1 + 1
if (indk1 .gt. indkl) indk1 = indkf
io1 = iadj(indk1)
if (io1 .ne. 0) go to 1
return
!
! ALL NODES ARE COLLINEAR
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE ADDS A BOUNDARY NODE TO A TRIANGULATION
! OF A SET OF KK-1 POINTS IN THE PLANE.  IADJ AND IEND ARE
! UPDATED WITH THE INSERTION OF NODE KK.
!
! INPUT PARAMETERS -   KK - INDEX OF AN EXTERIOR NODE TO BE
!                           ADDED.  KK .GE. 4.
!
!                      I1 - FIRST (RIGHTMOST AS VIEWED FROM
!                           KK) BOUNDARY NODE IN THE MESH
!                           WHICH IS VISIBLE FROM KK - THE
!                           LINE SEGMENT KK-I1 INTERSECTS
!                           NO ARCS.
!
!                      I2 - LAST (LEFTMOST) BOUNDARY NODE
!                           WHICH IS VISIBLE FROM KK.
!
!                    IADJ - SET OF ADJACENCY LISTS OF NODES
!                           IN THE MESH.
!
!                    IEND - POINTERS TO THE ENDS OF
!                           ADJACENCY LISTS IN IADJ FOR
!                           EACH NODE IN THE MESH.
!
!   IADJ AND IEND MAY BE CREATED BY TRMESH AND MUST CONTAIN
! THE VERTICES I1 AND I2.  I1 AND I2 MAY BE DETERMINED BY
! TRFIND.
!
! KK, I1, AND I2 ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ADDITION
!                                 OF NODE KK AS THE LAST
!                                 ENTRY.  NODE KK WILL BE
!                                 CONNECTED TO I1, I2, AND
!                                 ALL BOUNDARY NODES BETWEEN
!                                 THEM.  NO OPTIMIZATION OF
!                                 THE MESH IS PERFORMED.
!
! MODULE REFERENCED BY BDYADD - SHIFTD
!
! INTRINSIC FUNCTIONS CALLED BY BDYADD - MIN0, MAX0
!
!***********************************************************
!
integer :: k, km1, nright, nleft, nf, nl, n1, n2, i, imin, imax, &
&kend, next, indx
!
! LOCAL PARAMETERS -
!
! K =            LOCAL COPY OF KK
! KM1 =          K - 1
! NRIGHT,NLEFT = LOCAL COPIES OF I1, I2
! NF,NL =        INDICES OF IADJ BOUNDING THE PORTION OF THE
!                  ARRAY TO BE SHIFTED
! N1 =           IADJ INDEX OF THE FIRST NEIGHBOR OF NLEFT
! N2 =           IADJ INDEX OF THE LAST NEIGHBOR OF NRIGHT
! I =            DO-LOOP INDEX
! IMIN,IMAX =    BOUNDS ON DO-LOOP INDEX -- FIRST AND LAST
!                  ELEMENTS OF IEND TO BE INCREMENTED
! KEND =         POINTER TO THE LAST NEIGHBOR OF K IN IADJ
! NEXT =         NEXT BOUNDARY NODE TO BE CONNECTED TO KK
! INDX =         INDEX FOR IADJ
!
k = kk
km1 = k - 1
nright = i1
nleft = i2
!
! INITIALIZE VARIABLES
!
nl = iend(km1)
n1 = 1
if (nleft .ne. 1) n1 = iend(nleft-1) + 1
n2 = iend(nright)
nf = max0(n1,n2)
!
! INSERT K AS A NEIGHBOR OF MAX(NRIGHT,NLEFT)
!
call shiftd(nf,nl,2, iadj )
iadj(nf+1) = k
imin = max0(nright,nleft)
do 1 i = imin,km1
  iend(i) = iend(i) + 2
1 continue
!
! INITIALIZE KEND AND INSERT K AS A NEIGHBOR OF
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
! INSERT NRIGHT AS THE FIRST NEIGHBOR OF K
!
iadj(kend) = nright
!
! INITIALIZE INDX FOR LOOP ON BOUNDARY NODES BETWEEN NRIGHT
!   AND NLEFT
!
indx = iend(nright) - 2
3 next = iadj(indx)
if (next .eq. nleft) go to 4
!
! CONNECT NEXT AND K
!
kend = kend + 1
iadj(kend) = next
indx = iend(next)
iadj(indx) = k
indx = indx - 1
go to 3
!
! INSERT NLEFT AND 0 AS THE LAST NEIGHBORS OF K
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE ADDS AN INTERIOR NODE TO A TRIANGULATION
! OF A SET OF KK-1 POINTS IN THE PLANE.  IADJ AND IEND ARE
! UPDATED WITH THE INSERTION OF NODE KK IN THE TRIANGLE
! WHOSE VERTICES ARE I1, I2, AND I3.
!
! INPUT PARAMETERS -        KK - INDEX OF NODE TO BE
!                                INSERTED.  KK .GE. 4.
!
!                     I1,I2,I3 - INDICES OF THE VERTICES OF
!                                A TRIANGLE CONTAINING NODE
!                                KK -- IN COUNTERCLOCKWISE
!                                ORDER.
!
!                         IADJ - SET OF ADJACENCY LISTS
!                                OF NODES IN THE MESH.
!
!                         IEND - POINTERS TO THE ENDS OF
!                                ADJACENCY LISTS IN IADJ FOR
!                                EACH NODE IN THE MESH.
!
!   IADJ AND IEND MAY BE CREATED BY TRMESH AND MUST CONTAIN
! THE VERTICES I1, I2, AND I3.  I1,I2,I3 MAY BE DETERMINED
! BY TRFIND.
!
! KK, I1, I2, AND I3 ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ADDITION
!                                 OF NODE KK AS THE LAST
!                                 ENTRY.  NODE KK WILL BE
!                                 CONNECTED TO NODES I1, I2,
!                                 AND I3.  NO OPTIMIZATION
!                                 OF THE MESH IS PERFORMED.
!
! MODULE REFERENCED BY INTADD - SHIFTD
!
! INTRINSIC FUNCTION CALLED BY INTADD - MOD
!
!***********************************************************
!
integer :: k, km1, n(3), nft(3), ip1, ip2, ip3, indx, nf, nl, n1, &
&n2, imin, imax, i, itemp
!
! LOCAL PARAMETERS -
!
! K =           LOCAL COPY OF KK
! KM1 =         K - 1
! N =           VECTOR CONTAINING I1, I2, I3
! NFT =         POINTERS TO THE TOPS OF THE 3 SETS OF IADJ
!                 ELEMENTS TO BE SHIFTED DOWNWARD
! IP1,IP2,IP3 = PERMUTATION INDICES FOR N AND NFT
! INDX =        INDEX FOR IADJ AND N
! NF,NL =       INDICES OF FIRST AND LAST ENTRIES IN IADJ
!                 TO BE SHIFTED DOWN
! N1,N2 =       FIRST 2 VERTICES OF A NEW TRIANGLE --
!                 (N1,N2,KK)
! IMIN,IMAX =   BOUNDS ON DO-LOOP INDEX -- FIRST AND LAST
!                 ELEMENTS OF IEND TO BE INCREMENTED
! I =           DO-LOOP INDEX
! ITEMP =       TEMPORARY STORAGE LOCATION
!
k = kk
!
! INITIALIZATION
!
n(1) = i1
n(2) = i2
n(3) = i3
!
! SET UP NFT
!
do 2 i = 1,3
  n1 = n(i)
  indx = mod(i,3) + 1
  n2 = n(indx)
  indx = iend(n1) + 1
!
! FIND THE INDEX OF N2 AS A NEIGHBOR OF N1
!
1 indx = indx - 1
  if (iadj(indx) .ne. n2) go to 1
  nft(i) = indx + 1
2 continue
!
! ORDER THE VERTICES BY DECREASING MAGNITUDE.
!   N(IP(I+1)) PRECEDES N(IP(I)) IN IEND FOR
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
! ADD NODE K TO THE ADJACENCY LISTS OF EACH VERTEX AND
!   UPDATE IEND.  FOR EACH VERTEX, A SET OF IADJ ELEMENTS
!   IS SHIFTED DOWNWARD AND K IS INSERTED.  SHIFTING STARTS
!   AT THE END OF THE ARRAY.
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
! ADD NODE K TO IEND AND ITS NEIGHBORS TO IADJ
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE SHIFTS A SET OF CONTIGUOUS ELEMENTS OF AN
! INTEGER ARRAY KK POSITIONS DOWNWARD (UPWARD IF KK .LT. 0).
! THE LOOPS ARE UNROLLED IN ORDER TO INCREASE EFFICIENCY.
!
! INPUT PARAMETERS - NFRST,NLAST - BOUNDS ON THE PORTION OF
!                                  IARR TO BE SHIFTED.  ALL
!                                  ELEMENTS BETWEEN AND
!                                  INCLUDING THE BOUNDS ARE
!                                  SHIFTED UNLESS NFRST .GT.
!                                  NLAST, IN WHICH CASE NO
!                                  SHIFT OCCURS.
!
!                             KK - NUMBER OF POSITIONS EACH
!                                  ELEMENT IS TO BE SHIFTED.
!                                  IF KK .LT. 0 SHIFT UP.
!                                  IF KK .GT. 0 SHIFT DOWN.
!
!                           IARR - INTEGER ARRAY OF LENGTH
!                                  .GE. NLAST + MAX(KK,0).
!
! NFRST, NLAST, AND KK ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETER -        IARR - SHIFTED ARRAY.
!
! MODULES REFERENCED BY SHIFTD - NONE
!
!***********************************************************
!
integer :: inc, k, nf, nl, nlp1, ns, nsl, i, ibak, indx, imax
data    inc/5/
!
! LOCAL PARAMETERS -
!
! INC =  DO-LOOP INCREMENT (UNROLLING FACTOR) -- IF INC IS
!          CHANGED, STATEMENTS MUST BE ADDED TO OR DELETED
!          FROM THE DO-LOOPS
! K =    LOCAL COPY OF KK
! NF =   LOCAL COPY OF NFRST
! NL =   LOCAL COPY OF NLAST
! NLP1 = NL + 1
! NS =   NUMBER OF SHIFTS
! NSL =  NUMBER OF SHIFTS DONE IN UNROLLED DO-LOOP (MULTIPLE
!          OF INC)
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
! SHIFT DOWNWARD STARTING FROM THE BOTTOM
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
! PERFORM THE REMAINING NS-NSL SHIFTS ONE AT A TIME
!
2 ibak = nlp1 - nsl
3 if (ibak .le. nf) return
ibak = ibak - 1
indx = ibak + k
iarr(indx) = iarr(ibak)
go to 3
!
! SHIFT UPWARD STARTING FROM THE TOP
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
! PERFORM THE REMAINING NS-NSL SHIFTS ONE AT A TIME
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS SUBROUTINE SWAPS THE DIAGONALS IN A CONVEX QUADRI-
! LATERAL.
!
! INPUT PARAMETERS -  NIN1,NIN2,NOUT1,NOUT2 - NODAL INDICES
!                            OF A PAIR OF ADJACENT TRIANGLES
!                            WHICH FORM A CONVEX QUADRILAT-
!                            ERAL.  NOUT1 AND NOUT2 ARE CON-
!                            NECTED BY AN ARC WHICH IS TO BE
!                            REPLACED BY THE ARC NIN1-NIN2.
!                            (NIN1,NOUT1,NOUT2) MUST BE TRI-
!                            ANGLE VERTICES IN COUNTERCLOCK-
!                            WISE ORDER.
!
! THE ABOVE PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
!
!                IADJ,IEND - TRIANGULATION DATA STRUCTURE
!                            (SEE SUBROUTINE TRMESH).
!
! OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ARC
!                                 REPLACEMENT.
!
! MODULES REFERENCED BY SWAPD - TINDX, SHIFTD
!
!***********************************************************
!
integer :: in(2), io(2), ip1, ip2, j, k, nf, nl, i, imin, imax
!
! LOCAL PARAMETERS -
!
! IN =        NIN1 AND NIN2 ORDERED BY INCREASING MAGNITUDE
!               (THE NEIGHBORS OF IN(1) PRECEDE THOSE OF
!               IN(2) IN IADJ)
! IO =        NOUT1 AND NOUT2 IN INCREASING ORDER
! IP1,IP2 =   PERMUTATION OF (1,2) SUCH THAT IO(IP1)
!               PRECEDES IO(IP2) AS A NEIGHBOR OF IN(1)
! J,K =       PERMUTATION OF (1,2) USED AS INDICES OF IN
!               AND IO
! NF,NL =     IADJ INDICES BOUNDARY A PORTION OF THE ARRAY
!               TO BE SHIFTED
! I =         IEND INDEX
! IMIN,IMAX = BOUNDS ON THE PORTION OF IEND TO BE INCRE-
!               MENTED OR DECREMENTED
!
in(1) = nin1
in(2) = nin2
io(1) = nout1
io(2) = nout2
ip1 = 1
!
! ORDER THE INDICES SO THAT IN(1) .LT. IN(2) AND IO(1) .LT.
!   IO(2), AND CHOOSE IP1 AND IP2 SUCH THAT (IN(1),IO(IP1),
!   IO(IP2)) FORMS A TRIANGLE.
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
!   (1,2) AND (2,1), DELETE IO(K) AS A NEIGHBOR OF IO(J)
!   BY SHIFTING A PORTION OF IADJ EITHER UP OR DOWN AND
!   AND INSERT IN(K) AS A NEIGHBOR OF IN(J).
!
do 7 j = 1,2
  k = 3 - j
  if (in(j) .gt. io(j)) go to 4
!
!   THE NEIGHBORS OF IN(J) PRECEDE THOSE OF IO(J) -- SHIFT
!     DOWN BY 1
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
!   THE NEIGHBORS OF IO(J) PRECEDE THOSE OF IN(J) -- SHIFT
!     UP BY 1
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
! THE VERTICES ARE ORDERED (IO(1),IO(2),IN(1),IN(2)).
!   DELETE IO(2) BY SHIFTING UP BY 1
!
8 nf = 1 + tindx(io(1),io(2),iadj,iend)
nl = -1 + tindx(io(2),io(1),iadj,iend)
if (nf .le. nl) call shiftd(nf,nl,-1, iadj )
imin = io(1)
imax = io(2)-1
do 9 i = imin,imax
9 iend(i) = iend(i) - 1
!
!   DELETE IO(1) BY SHIFTING UP BY 2 AND INSERT IN(2)
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
!   SHIFT UP BY 1 AND INSERT IN(1)
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
! THE VERTICES ARE ORDERED (IN(1),IN(2),IO(1),IO(2)).
!   DELETE IO(1) BY SHIFTING DOWN BY 1
!
12 nf = 1 + tindx(io(1),io(2),iadj,iend)
nl = -1 + tindx(io(2),io(1),iadj,iend)
if (nf .le. nl) call shiftd(nf,nl,1, iadj )
imin = io(1)
imax = io(2) - 1
do 13 i = imin,imax
13 iend(i) = iend(i) + 1
!
!   DELETE IO(2) BY SHIFTING DOWN BY 2 AND INSERT IN(1)
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
!   SHIFT DOWN BY 1 AND INSERT IN(2)
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS FUNCTION DECIDES WHETHER OR NOT TO REPLACE A
! DIAGONAL ARC IN A QUADRILATERAL WITH THE OTHER DIAGONAL.
! THE DETERMINATION IS BASED ON THE SIZES OF THE ANGLES
! CONTAINED IN THE 2 TRIANGLES DEFINED BY THE DIAGONAL.
! THE DIAGONAL IS CHOSEN TO MAXIMIZE THE SMALLEST OF THE
! SIX ANGLES OVER THE TWO PAIRS OF TRIANGLES.
!
! INPUT PARAMETERS -  IN1,IN2,IO1,IO2 - NODE INDICES OF THE
!                              FOUR POINTS DEFINING THE
!                              QUADRILATERAL.  IO1 AND IO2
!                              ARE CURRENTLY CONNECTED BY A
!                              DIAGONAL ARC.  THIS ARC
!                              SHOULD BE REPLACED BY AN ARC
!                              CONNECTING IN1, IN2 IF THE
!                              DECISION IS MADE TO SWAP.
!                              IN1,IO1,IO2 MUST BE IN
!                              COUNTERCLOCKWISE ORDER.
!
!                        X,Y - VECTORS OF NODAL COORDINATES.
!                              (X(I),Y(I)) ARE THE COORD-
!                              INATES OF NODE I FOR I = IN1,
!                              IN2, IO1, OR IO2.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETER -  SWPTST - .TRUE. IFF THE ARC CONNECTING
!                              IO1 AND IO2 IS TO BE REPLACED
!
! MODULES REFERENCED BY SWPTST - NONE
!
!***********************************************************
!
real :: dx11, dx12, dx22, dx21, dy11, dy12, dy22, dy21, sin1, &
&sin2, cos1, cos2, sin12
!
! LOCAL PARAMETERS -
!
! DX11,DY11 = X,Y COORDINATES OF THE VECTOR IN1-IO1
! DX12,DY12 = X,Y COORDINATES OF THE VECTOR IN1-IO2
! DX22,DY22 = X,Y COORDINATES OF THE VECTOR IN2-IO2
! DX21,DY21 = X,Y COORDINATES OF THE VECTOR IN2-IO1
! SIN1 =      CROSS PRODUCT OF THE VECTORS IN1-IO1 AND
!               IN1-IO2 -- PROPORTIONAL TO SIN(T1) WHERE T1
!               IS THE ANGLE AT IN1 FORMED BY THE VECTORS
! COS1 =      INNER PRODUCT OF THE VECTORS IN1-IO1 AND
!               IN1-IO2 -- PROPORTIONAL TO COS(T1)
! SIN2 =      CROSS PRODUCT OF THE VECTORS IN2-IO2 AND
!               IN2-IO1 -- PROPORTIONAL TO SIN(T2) WHERE T2
!               IS THE ANGLE AT IN2 FORMED BY THE VECTORS
! COS2 =      INNER PRODUCT OF THE VECTORS IN2-IO2 AND
!               IN2-IO1 -- PROPORTIONAL TO COS(T2)
! SIN12 =     SIN1*COS2 + COS1*SIN2 -- PROPORTIONAL TO
!               SIN(T1+T2)
!
swptst = .false.
!
! COMPUTE THE VECTORS CONTAINING THE ANGLES T1, T2
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
! COMPUTE INNER PRODUCTS
!
cos1 = dx11*dx12 + dy11*dy12
cos2 = dx22*dx21 + dy22*dy21
!
! THE DIAGONALS SHOULD BE SWAPPED IFF (T1+T2) .GT. 180
!   DEGREES.  THE FOLLOWING TWO TESTS INSURE NUMERICAL
!   STABILITY.
!
if (cos1 .ge. 0.  .and.  cos2 .ge. 0.) return
if (cos1 .lt. 0.  .and.  cos2 .lt. 0.) go to 1
!
! COMPUTE VECTOR CROSS PRODUCTS
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS FUNCTION RETURNS THE INDEX OF NABOR IN THE
! ADJACENCY LIST FOR NVERTX.
!
! INPUT PARAMETERS - NVERTX - NODE WHOSE ADJACENCY LIST IS
!                             TO BE SEARCHED.
!
!                     NABOR - NODE WHOSE INDEX IS TO BE
!                             RETURNED.  NABOR MUST BE
!                             CONNECTED TO NVERTX.
!
!                      IADJ - SET OF ADJACENCY LISTS.
!
!                      IEND - POINTERS TO THE ENDS OF
!                             ADJACENCY LISTS IN IADJ.
!
! INPUT PARAMETERS ARE NOT ALTERED BY THIS FUNCTION.
!
! OUTPUT PARAMETER -  TINDX - IADJ(TINDX) = NABOR.
!
! MODULES REFERENCED BY TINDX - NONE
!
!***********************************************************
!
integer :: nb, indx
!
! LOCAL PARAMETERS -
!
! NB =   LOCAL COPY OF NABOR
! INDX = INDEX FOR IADJ
!
nb = nabor
!
! INITIALIZATION
!
indx = iend(nvertx) + 1
!
! SEARCH THE LIST OF NVERTX NEIGHBORS FOR NB
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE LOCATES A POINT P IN A THIESSEN TRIANGU-
! LATION, RETURNING THE VERTEX INDICES OF A TRIANGLE WHICH
! CONTAINS P.  TRFIND IS PART OF AN INTERPOLATION PACKAGE
! WHICH PROVIDES SUBROUTINES FOR CREATING THE MESH.
!
! INPUT PARAMETERS -    NST - INDEX OF NODE AT WHICH TRFIND
!                             BEGINS SEARCH.  SEARCH TIME
!                             DEPENDS ON THE PROXIMITY OF
!                             NST TO P.
!
!                     PX,PY - X AND Y-COORDINATES OF THE
!                             POINT TO BE LOCATED.
!
!                       X,Y - VECTORS OF COORDINATES OF
!                             NODES IN THE MESH.  (X(I),Y(I))
!                             DEFINES NODE I FOR I = 1,...,N
!                             WHERE N .GE. 3.
!
!                      IADJ - SET OF ADJACENCY LISTS OF
!                             NODES IN THE MESH.
!
!                      IEND - POINTERS TO THE ENDS OF
!                             ADJACENCY LISTS IN IADJ FOR
!                             EACH NODE IN THE MESH.
!
! IADJ AND IEND MAY BE CREATED BY TRMESH.
!
! INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS - I1,I2,I3 - VERTEX INDICES IN COUNTER-
!                                CLOCKWISE ORDER - VERTICES
!                                OF A TRIANGLE CONTAINING P
!                                IF P IS AN INTERIOR NODE.
!                                IF P IS OUTSIDE OF THE
!                                BOUNDARY OF THE MESH, I1
!                                AND I2 ARE THE FIRST (RIGHT
!                                -MOST) AND LAST (LEFTMOST)
!                                NODES WHICH ARE VISIBLE
!                                FROM P, AND I3 = 0.  IF P
!                                AND ALL OF THE NODES LIE ON
!                                A SINGLE LINE THEN I1 = I2
!                                = I3 = 0.
!
! MODULES REFERENCED BY TRFIND - NONE
!
! INTRINSIC FUNCTION CALLED BY TRFIND - MAX0
!
!***********************************************************
!
integer :: n0, n1, n2, n3, n4, indx, ind, nf, nl, next
real :: xp, yp
logical :: left
!
! LOCAL PARAMETERS -
!
! XP,YP =     LOCAL VARIABLES CONTAINING PX AND PY
! N0,N1,N2 =  NODES IN COUNTERCLOCKWISE ORDER DEFINING A
!               CONE (WITH VERTEX N0) CONTAINING P
! N3,N4 =     NODES OPPOSITE N1-N2 AND N2-N1, RESPECTIVELY
! INDX,IND =  INDICES FOR IADJ
! NF,NL =     FIRST AND LAST NEIGHBORS OF N0 IN IADJ, OR
!               FIRST (RIGHTMOST) AND LAST (LEFTMOST) NODES
!               VISIBLE FROM P WHEN P IS OUTSIDE THE
!               BOUNDARY
! NEXT =      CANDIDATE FOR I1 OR I2 WHEN P IS OUTSIDE OF
!               THE BOUNDARY
! LEFT =      STATEMENT FUNCTION WHICH COMPUTES THE SIGN OF
!               A CROSS PRODUCT (Z-COMPONENT).  LEFT(X1,...,
!               Y0) = .TRUE. IFF (X0,Y0) IS ON OR TO THE
!               LEFT OF THE VECTOR FROM (X1,Y1) TO (X2,Y2).
!
left(x1,y1,x2,y2,x0,y0) = (x2-x1)*(y0-y1) .ge. &
&(x0-x1)*(y2-y1)
xp = px
yp = py
!
! INITIALIZE VARIABLES AND FIND A CONE CONTAINING P
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
! N0 IS A BOUNDARY NODE.  SET NL TO THE LAST NONZERO
!   NEIGHBOR OF N0.
!
ind = iend(n0) - 1
nl = iadj(ind)
if ( left(x(n0),y(n0),x(nf),y(nf),xp,yp) ) go to 2
!
! P IS OUTSIDE THE BOUNDARY
!
nl = n0
go to 16
2 if ( left(x(nl),y(nl),x(n0),y(n0),xp,yp) ) go to 4
!
! P IS OUTSIDE THE BOUNDARY AND N0 IS THE RIGHTMOST
!   VISIBLE BOUNDARY NODE
!
i1 = n0
go to 18
!
! N0 IS AN INTERIOR NODE.  FIND N1.
!
3 if ( left(x(n0),y(n0),x(n1),y(n1),xp,yp) ) go to 4
indx = indx + 1
n1 = iadj(indx)
if (n1 .eq. nl) go to 7
go to 3
!
! P IS TO THE LEFT OF ARC N0-N1.  INITIALIZE N2 TO THE NEXT
!   NEIGHBOR OF N0.
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
! P IS LEFT OF OR ON ARCS N0-NB FOR ALL NEIGHBORS NB
!   OF N0.
! ALL POINTS ARE COLLINEAR IFF P IS LEFT OF NB-N0 FOR
!   ALL NEIGHBORS NB OF N0.  SEARCH THE NEIGHBORS OF N0
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
!   START OVER.
!
6 n0 = n1
go to 1
!
! P IS BETWEEN ARCS N0-N1 AND N0-NF
!
7 n2 = nf
!
! P IS CONTAINED IN A CONE DEFINED BY LINE SEGMENTS N0-N1
!   AND N0-N2 WHERE N1 IS ADJACENT TO N2
!
8 n3 = n0
9 if ( left(x(n1),y(n1),x(n2),y(n2),xp,yp) ) go to 13
!
! SET N4 TO THE FIRST NEIGHBOR OF N2 FOLLOWING N1
!
indx = iend(n2)
if (iadj(indx) .ne. n1) go to 10
!
! N1 IS THE LAST NEIGHBOR OF N2.
! SET N4 TO THE FIRST NEIGHBOR.
!
indx = 1
if (n2 .ne. 1) indx = iend(n2-1) + 1
n4 = iadj(indx)
go to 11
!
! N1 IS NOT THE LAST NEIGHBOR OF N2
!
10 indx = indx-1
if (iadj(indx) .ne. n1) go to 10
n4 = iadj(indx+1)
if (n4 .ne. 0) go to 11
!
! P IS OUTSIDE THE BOUNDARY
!
nf = n2
nl = n1
go to 16
!
! DEFINE A NEW ARC N1-N2 WHICH INTERSECTS THE LINE
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
! P IS IN THE TRIANGLE (N1,N2,N3) AND NOT ON N2-N3.  IF
!   N3-N1 OR N1-N2 IS A BOUNDARY ARC CONTAINING P, TREAT P
!   AS EXTERIOR.
!
13 indx = iend(n1)
if (iadj(indx) .ne. 0) go to 15
!
! N1 IS A BOUNDARY NODE.  N3-N1 IS A BOUNDARY ARC IFF N3
!   IS THE LAST NONZERO NEIGHBOR OF N1.
!
if (n3 .ne. iadj(indx-1)) go to 14
!
! N3-N1 IS A BOUNDARY ARC
!
if ( .not. left(x(n1),y(n1),x(n3),y(n3),xp,yp) ) &
&go to 14
!
! P LIES ON N1-N3
!
i1 = n1
i2 = n3
i3 = 0
return
!
! N3-N1 IS NOT A BOUNDARY ARC CONTAINING P.  N1-N2 IS A
!   BOUNDARY ARC IFF N2 IS THE FIRST NEIGHBOR OF N1.
!
14 indx = 1
if (n1 .ne. 1) indx = iend(n1-1) + 1
if (n2 .ne. iadj(indx)) go to 15
!
! N1-N2 IS A BOUNDARY ARC
!
if ( .not. left(x(n2),y(n2),x(n1),y(n1),xp,yp) ) &
&go to 15
!
! P LIES ON N1-N2
!
i1 = n2
i2 = n1
i3 = 0
return
!
! P DOES NOT LIE ON A BOUNDARY ARC.
!
15 i1 = n1
i2 = n2
i3 = n3
return
!
! NF AND NL ARE ADJACENT BOUNDARY NODES WHICH ARE VISIBLE
!   FROM P.  FIND THE FIRST VISIBLE BOUNDARY NODE.
! SET NEXT TO THE FIRST NEIGHBOR OF NF.
!
16 indx = 1
if (nf .ne. 1) indx = iend(nf-1) + 1
next = iadj(indx)
if ( left(x(nf),y(nf),x(next),y(next),xp,yp) ) &
&go to 17
nf = next
go to 16
!
! NF IS THE FIRST (RIGHTMOST) VISIBLE BOUNDARY NODE
!
17 i1 = nf
!
! FIND THE LAST VISIBLE BOUNDARY NODE.  NL IS THE FIRST
!   CANDIDATE FOR I2.
! SET NEXT TO THE LAST NEIGHBOR OF NL.
!
18 indx = iend(nl) - 1
next = iadj(indx)
if ( left(x(next),y(next),x(nl),y(nl),xp,yp) ) &
&go to 19
nl = next
go to 18
!
! NL IS THE LAST (LEFTMOST) VISIBLE BOUNDARY NODE
!
19 i2 = nl
i3 = 0
return
!
! ALL POINTS ARE COLLINEAR
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
!                      DERIVATIVE ESTIMATION
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
!     ERROR RETURN
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   GIVEN A TRIANGULATION OF N NODES IN THE PLANE WITH
! ASSOCIATED DATA VALUES, THIS ROUTINE USES A GLOBAL METHOD
! TO COMPUTE ESTIMATED GRADIENTS AT THE NODES.  THE METHOD
! CONSISTS OF MINIMIZING A QUADRATIC FUNCTIONAL Q(G) OVER
! THE N-VECTOR G OF GRADIENTS WHERE Q APPROXIMATES THE LIN-
! EARIZED CURVATURE OF AN INTERPOLANT F OVER THE TRIANGULA-
! TION.  THE RESTRICTION OF F TO AN ARC OF THE TRIANGULATION
! IS TAKEN TO BE THE HERMITE CUBIC INTERPOLANT OF THE DATA
! VALUES AND TANGENTIAL GRADIENT COMPONENTS AT THE END-
! POINTS OF THE ARC, AND Q IS THE SUM OF THE LINEARIZED
! CURVATURES OF F ALONG THE ARCS -- THE INTEGRALS OVER THE
! ARCS OF D2F(T)**2 WHERE D2F(T) IS THE SECOND DERIVATIVE
! OF F WITH RESPECT TO DISTANCE T ALONG THE ARC.  THIS MIN-
! IMIZATION PROBLEM CORRESPONDS TO AN ORDER 2N SYMMETRIC
! POSITIVE-DEFINITE SPARSE LINEAR SYSTEM WHICH IS SOLVED FOR
! THE X AND Y PARTIAL DERIVATIVES BY THE BLOCK GAUSS-SEIDEL
! METHOD WITH 2 BY 2 BLOCKS.
!   AN ALTERNATIVE METHOD, SUBROUTINE GRADL, COMPUTES A
! LOCAL APPROXIMATION TO THE PARTIALS AT A SINGLE NODE AND
! MAY BE MORE ACCURATE, DEPENDING ON THE DATA VALUES AND
! DISTRIBUTION OF NODES (NEITHER METHOD EMERGED AS SUPERIOR
! IN TESTS FOR ACCURACY).  HOWEVER, IN TESTS RUN ON AN IBM
! 370, GRADG1 WAS FOUND TO BE ABOUT 3.6 TIMES AS FAST FOR
! NIT = 4.
!
! INPUT PARAMETERS - N - NUMBER OF NODES.  N .GE. 3.
!
!                  X,Y - CARTESIAN COORDINATES OF THE NODES.
!
!                    Z - DATA VALUES AT THE NODES.  Z(I) IS
!                        ASSOCIATED WITH (X(I),Y(I)).
!
!            IADJ,IEND - DATA STRUCTURE DEFINING THE TRIAN-
!                        GULATION.  SEE SUBROUTINE TRMESH.
!
!                  EPS - NONNEGATIVE CONVERGENCE CRITERION.
!                        THE METHOD IS TERMINATED WHEN THE
!                        MAXIMUM CHANGE IN A GRADIENT COMPO-
!                        NENT BETWEEN ITERATIONS IS AT MOST
!                        EPS.  EPS = 1.E-2 IS SUFFICIENT FOR
!                        EFFECTIVE CONVERGENCE.
!
! THE ABOVE PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
!
!                  NIT - MAXIMUM NUMBER OF GAUSS-SEIDEL
!                        ITERATIONS TO BE APPLIED.  THIS
!                        MAXIMUM WILL LIKELY BE ACHIEVED IF
!                        EPS IS SMALLER THAN THE MACHINE
!                        PRECISION.  OPTIMAL EFFICIENCY WAS
!                        ACHIEVED IN TESTING WITH EPS = 0
!                        AND NIT = 3 OR 4.
!
!                 ZXZY - 2 BY N ARRAY WHOSE COLUMNS CONTAIN
!                        INITIAL ESTIMATES OF THE PARTIAL
!                        DERIVATIVES (ZERO VECTORS ARE
!                        SUFFICIENT).
!
! OUTPUT PARAMETERS - NIT - NUMBER OF GAUSS-SEIDEL ITERA-
!                           TIONS EMPLOYED.
!
!                    ZXZY - ESTIMATED X AND Y PARTIAL DERIV-
!                           ATIVES AT THE NODES WITH X PAR-
!                           TIALS IN THE FIRST ROW.  ZXZY IS
!                           NOT CHANGED IF IER = 2.
!
!                     IER - ERROR INDICATOR
!                           IER = 0 IF THE CONVERGENCE CRI-
!                                   TERION WAS ACHIEVED.
!                           IER = 1 IF CONVERGENCE WAS NOT
!                                   ACHIEVED WITHIN NIT
!                                   ITERATIONS.
!                           IER = 2 IF N OR EPS IS OUT OF
!                                   RANGE OR NIT .LT. 0 ON
!                                   INPUT.
!
! MODULES REFERENCED BY GRADG1 - NONE
!
! INTRINSIC FUNCTIONS CALLED BY GRADG1 - SQRT, AMAX1, ABS
!
!***********************************************************
!
integer :: nn, maxit, iter, k, indf, indl, indx, nb
real :: tol, dgmax, xk, yk, zk, zxk, zyk, a11, a12, a22, r1, r2, &
&delx, dely, delxs, delys, dsq, dcub, t, dzx, dzy
!
! LOCAL PARAMETERS -
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
!                 TWEEN ITERATIONS
! XK,YK,ZK =    X(K), Y(K), Z(K)
! ZXK,ZYK =     INITIAL VALUES OF ZXZY(1,K) AND ZXZY(2,K)
! A11,A12,A22 = MATRIX COMPONENTS OF THE 2 BY 2 BLOCK A*DG
!                 = R WHERE A IS SYMMETRIC, DG = (DZX,DZY)
!                 IS THE CHANGE IN THE GRADIENT AT K, AND R
!                 IS THE RESIDUAL
! R1,R2 =       COMPONENTS OF THE RESIDUAL -- DERIVATIVES OF
!                 Q WITH RESPECT TO THE COMPONENTS OF THE
!                 GRADIENT AT NODE K
! DELX,DELY =   COMPONENTS OF THE ARC NB-K
! DELXS,DELYS = DELX**2, DELY**2
! DSQ =         SQUARE OF THE DISTANCE D BETWEEN K AND NB
! DCUB =        D**3
! T =           FACTOR OF R1 AND R2
! DZX,DZY =     SOLUTION OF THE 2 BY 2 SYSTEM -- CHANGE IN
!                 DERIVATIVES AT K FROM THE PREVIOUS ITERATE
!
nn = n
tol = eps
maxit = nit
!
! ERROR CHECKS AND INITIALIZATION
!
if (nn .lt. 3  .or.  tol .lt. 0.  .or.  maxit .lt. 0) &
&go to 5
iter = 0
!
! TOP OF ITERATION LOOP
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
!   INITIALIZE COMPONENTS OF THE 2 BY 2 SYSTEM
!
  a11 = 0.
  a12 = 0.
  a22 = 0.
  r1 = 0.
  r2 = 0.
!
!   LOOP ON NEIGHBORS NB OF K
!
  indf = indl + 1
  indl = iend(k)
  do 2 indx = indf,indl
    nb = iadj(indx)
    if (nb .eq. 0) go to 2
!
!   COMPUTE THE COMPONENTS OF ARC NB-K
!
    delx = x(nb) - xk
    dely = y(nb) - yk
    delxs = delx*delx
    delys = dely*dely
    dsq = delxs + delys
    dcub = dsq*sqrt(dsq)
!
!   UPDATE THE SYSTEM COMPONENTS FOR NODE NB
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
!   SOLVE THE 2 BY 2 SYSTEM AND UPDATE DGMAX
!
  dzy = (a11*r2 - a12*r1)/(a11*a22 - a12*a12)
  dzx = (r1 - a12*dzy)/a11
  dgmax = amax1(dgmax,abs(dzx),abs(dzy))
!
!   UPDATE THE PARTIALS AT NODE K
!
  zxzy(1,k) = zxk + dzx
3 zxzy(2,k) = zyk + dzy
!
!   INCREMENT ITER AND TEST FOR CONVERGENCE
!
iter = iter + 1
if (dgmax .gt. tol) go to 1
!
! METHOD CONVERGED
!
nit = iter
ier = 0
return
!
! METHOD FAILED TO CONVERGE WITHIN NIT ITERATIONS
!
4 ier = 1
return
!
! PARAMETER OUT OF RANGE
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
!                      DERIVATIVE ESTIMATION
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
!     ERROR RETURN
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   GIVEN A THIESSEN TRIANGULATION OF N POINTS IN THE PLANE
! WITH ASSOCIATED DATA VALUES Z, THIS SUBROUTINE ESTIMATES
! X AND Y PARTIAL DERIVATIVES AT NODE K.  THE DERIVATIVES
! ARE TAKEN TO BE THE PARTIALS AT K OF A QUADRATIC FUNCTION
! WHICH INTERPOLATES Z(K) AND FITS THE DATA VALUES AT A SET
! OF NEARBY NODES IN A WEIGHTED LEAST SQUARES SENSE. A MAR-
! QUARDT STABILIZATION FACTOR IS USED IF NECESSARY TO ENSURE
! A WELL-CONDITIONED SYSTEM AND A LINEAR FITTING FUNCTION IS
! USED IF N .LT. 6.  THUS, A UNIQUE SOLUTION EXISTS UNLESS
! THE NODES ARE COLLINEAR.
!   AN ALTERNATIVE ROUTINE, GRADG, EMPLOYS A GLOBAL METHOD
! TO COMPUTE THE PARTIAL DERIVATIVES AT ALL OF THE NODES AT
! ONCE.  THAT METHOD IS MORE EFFICIENT (WHEN ALL PARTIALS
! ARE NEEDED) AND MAY BE MORE ACCURATE, DEPENDING ON THE
! DATA.
!
! INPUT PARAMETERS - N - NUMBER OF NODES IN THE TRIANGULA-
!                        TION.  N .GE. 3.
!
!                    K - NODE AT WHICH DERIVATIVES ARE
!                        SOUGHT.  1 .LE. K .LE. N.
!
!                  X,Y - N-VECTORS CONTAINING THE CARTESIAN
!                        COORDINATES OF THE NODES.
!
!                    Z - N-VECTOR CONTAINING THE DATA VALUES
!                        ASSOCIATED WITH THE NODES.
!
!                 IADJ - SET OF ADJACENCY LISTS.
!
!                 IEND - POINTERS TO THE ENDS OF ADJACENCY
!                        LISTS FOR EACH NODE.
!
! IADJ AND IEND MAY BE CREATED BY SUBROUTINE TRMESH.
!
! INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS - DX,DY - ESTIMATED PARTIAL DERIVATIVES
!                             AT NODE K UNLESS IER .LT. 0.
!
!                       IER - ERROR INDICATOR
!                             IER .GT. 0 IF NO ERRORS WERE
!                                      ENCOUNTERED.  IER
!                                      CONTAINS THE NUMBER
!                                      OF NODES (INCLUDING
!                                      K) USED IN THE FIT.
!                                      IER = 3, 4, OR 5 IM-
!                                      PLIES A LINEAR FIT.
!                             IER = -1 IF N OR K IS OUT OF
!                                      RANGE.
!                             IER = -2 IF ALL NODES ARE
!                                      COLLINEAR.
!
! MODULES REFERENCED BY GRADL1 - GETNP, SETRM, SROTG, SROT
!
! INTRINSIC FUNCTIONS CALLED BY GRADL1 - MIN0, FLOAT, SQRT,
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
! LOCAL PARAMETERS -
!
! NN,KK =     LOCAL COPIES OF N AND K
! LMN,LMX =   MINIMUM AND MAXIMUM VALUES OF LNP FOR N
!               SUFFICIENTLY LARGE.  IN MOST CASES LMN-1
!               NODES ARE USED IN THE FIT.  4 .LE. LMN .LE.
!               LMX.
! LMIN,LMAX = MIN(LMN,N), MIN(LMX,N)
! LM1 =       LMIN-1 OR LNP-1
! LNP =       LENGTH OF NPTS
! NPTS =      ARRAY CONTAINING THE INDICES OF A SEQUENCE OF
!               NODES ORDERED BY DISTANCE FROM K.  NPTS(1)=K
!               AND THE FIRST LNP-1 ELEMENTS OF NPTS ARE
!               USED IN THE LEAST SQUARES FIT.  UNLESS LNP
!               EXCEEDS LMAX, NPTS(LNP) DETERMINES R.
! IERR =      ERROR FLAG FOR CALLS TO GETNP (NOT CHECKED)
! NP =        ELEMENT OF NPTS TO BE ADDED TO THE SYSTEM
! I,J =       DO-LOOP INDICES
! IM1,JP1 =   I-1, J+1
! IP1 =       I+1
! L =         NUMBER OF COLUMNS OF A**T TO WHICH A ROTATION
!               IS APPLIED
! SUM =       SUM OF SQUARED EUCLIDEAN DISTANCES BETWEEN
!               NODE K AND THE NODES USED IN THE LEAST
!               SQUARES FIT
! DS =        SQUARED DISTANCE BETWEEN NODE K AND AN ELE-
!               MENT OF NPTS
! R =         DISTANCE BETWEEN NODE K AND NPTS(LNP) OR SOME
!               POINT FURTHER FROM K THAN NPTS(LMAX) IF
!               NPTS(LMAX) IS USED IN THE FIT.  R IS A
!               RADIUS OF INFLUENCE WHICH ENTERS INTO THE
!               WEIGHTS (SEE SUBROUTINE SETRM).
! RS =        R*R
! RTOL =      TOLERANCE FOR DETERMINING R.  IF THE RELATIVE
!               CHANGE IN DS BETWEEN TWO ELEMENTS OF NPTS IS
!               NOT GREATER THAN RTOL THEY ARE TREATED AS
!               BEING THE SAME DISTANCE FROM NODE K
! AVSQ =      AV*AV
! AV =        ROOT-MEAN-SQUARE DISTANCE BETWEEN K AND THE
!               NODES (OTHER THAN K) IN THE LEAST SQUARES
!               FIT.  THE FIRST 3 COLUMNS OF THE SYSTEM ARE
!               SCALED BY 1/AVSQ, THE NEXT 2 BY 1/AV.
! XK,YK,ZK =  COORDINATES AND DATA VALUE ASSOCIATED WITH K
! A =         TRANSPOSE OF THE AUGMENTED REGRESSION MATRIX
! C,S =       COMPONENTS OF THE PLANE ROTATION DETERMINED
!               BY SUBROUTINE SROTG
! DMIN =      MINIMUM OF THE MAGNITUDES OF THE DIAGONAL
!               ELEMENTS OF THE REGRESSION MATRIX AFTER
!               ZEROS ARE INTRODUCED BELOW THE DIAGONAL
! DTOL =      TOLERANCE FOR DETECTING AN ILL-CONDITIONED
!               SYSTEM.  THE SYSTEM IS ACCEPTED WHEN DMIN
!               .GE. DTOL
! SF =        MARQUARDT STABILIZATION FACTOR USED TO DAMP
!               OUT THE FIRST 3 SOLUTION COMPONENTS (SECOND
!               PARTIALS OF THE QUADRATIC) WHEN THE SYSTEM
!               IS ILL-CONDITIONED.  AS SF INCREASES, THE
!               FITTING FUNCTION APPROACHES A LINEAR
!
nn = n
kk = k
!
! CHECK FOR ERRORS AND INITIALIZE LMIN, LMAX
!
if (nn .lt. 3  .or.  kk .lt. 1  .or.  kk .gt. nn) &
&go to 16
lmin = min0(lmn,nn)
lmax = min0(lmx,nn)
!
! COMPUTE NPTS, LNP, AVSQ, AV, AND R.
!   SET NPTS TO THE CLOSEST LMIN-1 NODES TO K.
!
sum = 0.
npts(1) = kk
lm1 = lmin - 1
do 1 lnp = 2,lm1
  call getnp (x,y,iadj,iend,lnp, npts, ds,ierr)
1 sum = sum + ds
!
! ADD ADDITIONAL NODES TO NPTS UNTIL THE RELATIVE INCREASE
!   IN DS IS AT LEAST RTOL.
!
do 2 lnp = lmin,lmax
  call getnp (x,y,iadj,iend,lnp, npts, rs,ierr)
  if ((rs-ds)/ds .le. rtol) go to 2
  if (lnp .gt. 6) go to 3
2 sum = sum + rs
!
! USE ALL LMAX NODES IN THE LEAST SQUARES FIT.  RS IS
!   ARBITRARILY INCREASED BY 10 PER CENT.
!
rs = 1.1*rs
lnp = lmax + 1
!
! THERE ARE LNP-2 EQUATIONS CORRESPONDING TO NODES NPTS(2),
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
! SET UP THE FIRST 5 EQUATIONS OF THE AUGMENTED REGRESSION
!   MATRIX (TRANSPOSED) AS THE COLUMNS OF A, AND ZERO OUT
!   THE LOWER TRIANGLE (UPPER TRIANGLE OF A) WITH GIVENS
!   ROTATIONS
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
! ADD THE ADDITIONAL EQUATIONS TO THE SYSTEM USING
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
! TEST THE SYSTEM FOR ILL-CONDITIONING
!
8 dmin = amin1( abs(a(1,1)),abs(a(2,2)),abs(a(3,3)), &
&abs(a(4,4)),abs(a(5,5)) )
if (dmin .ge. dtol) go to 15
if (lnp .gt. lmax) go to 9
!
! ADD ANOTHER NODE TO THE SYSTEM AND INCREASE R --
!   I .EQ. LNP
!
lnp = lnp + 1
if (lnp .le. lmax) call getnp (x,y,iadj,iend,lnp, &
&npts, rs,ierr)
r = sqrt(1.1*rs)
go to 6
!
! STABILIZE THE SYSTEM BY DAMPING SECOND PARTIALS --ADD
!   MULTIPLES OF THE FIRST THREE UNIT VECTORS TO THE FIRST
!   THREE EQUATIONS.
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
!   THE DATA USING THE LAST 3 COLUMNS OF A.
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
! TEST THE LINEAR FIT FOR ILL-CONDITIONING
!
14 dmin = amin1( abs(a(4,4)),abs(a(5,5)) )
if (dmin .lt. dtol) go to 17
!
! SOLVE THE 2 BY 2 TRIANGULAR SYSTEM FOR THE DERIVATIVES
!
15 dy = a(6,5)/a(5,5)
dx = (a(6,4) - a(5,4)*dy)/a(4,4)/av
dy = dy/av
ier = lnp - 1
return
!
! N OR K IS OUT OF RANGE
!
16 ier = -1
return
!
! NO UNIQUE SOLUTION DUE TO COLLINEAR NODES
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   THIS ROUTINE SETS UP THE I-TH ROW OF AN AUGMENTED RE-
! GRESSION MATRIX FOR A WEIGHTED LEAST-SQUARES FIT OF A
! QUADRATIC FUNCTION Q(X,Y) TO A SET OF DATA VALUES Z WHERE
! Q(XK,YK) = ZK.  THE FIRST 3 COLUMNS (QUADRATIC TERMS) ARE
! SCALED BY 1/S2 AND THE FOURTH AND FIFTH COLUMNS (LINEAR
! TERMS) ARE SCALED BY 1/S1.  THE WEIGHT IS (R-D)/(R*D) IF
! R .GT. D AND 0 IF R .LE. D, WHERE D IS THE DISTANCE
! BETWEEN NODES I AND K.
!
! INPUT PARAMETERS - XK,YK,ZK - COORDINATES AND DATA VALUE
!                               AT NODE K -- INTERPOLATED
!                               BY Q.
!
!                    XI,YI,ZI - COORDINATES AND DATA VALUE
!                               AT NODE I.
!
!                       S1,S2 - INVERSE SCALE FACTORS.
!
!                           R - RADIUS OF INFLUENCE ABOUT
!                               NODE K DEFINING THE WEIGHT.
!
!                         ROW - VECTOR OF LENGTH 6.
!
! INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETER - ROW - VECTOR CONTAINING A ROW OF THE
!                          AUGMENTED REGRESSION MATRIX.
!
! MODULES REFERENCED BY SETRM - NONE
!
! INTRINSIC FUNCTION CALLED BY SETRM - SQRT
!
!***********************************************************
!
integer :: i
real :: dx, dy, dxsq, dysq, d, w, w1, w2
!
! LOCAL PARAMETERS -
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
! NODES K AND I COINCIDE OR NODE I IS OUTSIDE OF THE RADIUS
!   OF INFLUENCE.  SET ROW TO THE ZERO VECTOR.
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   GIVEN A THIESSEN TRIANGULATION OF N NODES AND AN ARRAY
! NPTS CONTAINING THE INDICES OF L-1 NODES ORDERED BY
! EUCLIDEAN DISTANCE FROM NPTS(1), THIS SUBROUTINE SETS
! NPTS(L) TO THE INDEX OF THE NEXT NODE IN THE SEQUENCE --
! THE NODE, OTHER THAN NPTS(1),...,NPTS(L-1), WHICH IS
! CLOSEST TO NPTS(1).  THUS, THE ORDERED SEQUENCE OF K
! CLOSEST NODES TO N1 (INCLUDING N1) MAY BE DETERMINED BY
! K-1 CALLS TO GETNP WITH NPTS(1) = N1 AND L = 2,3,...,K
! FOR K .GE. 2.
!   THE ALGORITHM USES THE FACT THAT, IN A THIESSEN TRIAN-
! GULATION, THE K-TH CLOSEST NODE TO A GIVEN NODE N1 IS A
! NEIGHBOR OF ONE OF THE K-1 CLOSEST NODES TO N1.
!
! INPUT PARAMETERS - X,Y - VECTORS OF LENGTH N CONTAINING
!                          THE CARTESIAN COORDINATES OF THE
!                          NODES.
!
!                   IADJ - SET OF ADJACENCY LISTS OF NODES
!                          IN THE TRIANGULATION.
!
!                   IEND - POINTERS TO THE ENDS OF ADJACENCY
!                          LISTS FOR EACH NODE IN THE TRI-
!                          ANGULATION.
!
!                      L - NUMBER OF NODES IN THE SEQUENCE
!                          ON OUTPUT.  2 .LE. L .LE. N.
!
!                   NPTS - ARRAY OF LENGTH .GE. L CONTAIN-
!                          ING THE INDICES OF THE L-1 CLOS-
!                          EST NODES TO NPTS(1) IN THE FIRST
!                          L-1 LOCATIONS.
!
! IADJ AND IEND MAY BE CREATED BY SUBROUTINE TRMESH.
!
! INPUT PARAMETERS OTHER THAN NPTS ARE NOT ALTERED BY THIS
!   ROUTINE.
!
! OUTPUT PARAMETERS - NPTS - UPDATED WITH THE INDEX OF THE
!                            L-TH CLOSEST NODE TO NPTS(1) IN
!                            POSITION L UNLESS IER = 1.
!
!                       DS - SQUARED EUCLIDEAN DISTANCE BE-
!                            TWEEN NPTS(1) AND NPTS(L)
!                            UNLESS IER = 1.
!
!                      IER - ERROR INDICATOR
!                            IER = 0 IF NO ERRORS WERE EN-
!                                    COUNTERED.
!                            IER = 1 IF L IS OUT OF RANGE.
!
! MODULES REFERENCED BY GETNP - NONE
!
! INTRINSIC FUNCTION CALLED BY GETNP - IABS
!
!***********************************************************
!
integer :: lm1, n1, i, ni, np, indf, indl, indx, nb
real :: x1, y1, dnp, dnb
!
! LOCAL PARAMETERS -
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
!             RESPECTIVELY
!
lm1 = l - 1
if (lm1 .lt. 1) go to 4
ier = 0
n1 = npts(1)
x1 = x(n1)
y1 = y(n1)
!
! MARK THE ELEMENTS OF NPTS
!
do 1 i = 1,lm1
  ni = npts(i)
  iend(ni) = -iend(ni)
1 continue
!
! CANDIDATES FOR NP = NPTS(L) ARE THE UNMARKED NEIGHBORS
!   OF NODES IN NPTS.  NP=0 IS A FLAG TO SET NP TO THE
!   FIRST CANDIDATE ENCOUNTERED.
!
np = 0
dnp = 0.
!
! LOOP ON NODES NI IN NPTS
!
do 2 i = 1,lm1
  ni = npts(i)
  indf = 1
  if (ni .gt. 1) indf = iabs(iend(ni-1)) + 1
  indl = -iend(ni)
!
! LOOP ON NEIGHBORS NB OF NI
!
  do 2 indx = indf,indl
    nb = iadj(indx)
    if (nb .eq. 0  .or.  iend(nb) .lt. 0) go to 2
!
! NB IS AN UNMARKED NEIGHBOR OF NI.  REPLACE NP IF NB IS
!   CLOSER TO N1 OR IS THE FIRST CANDIDATE ENCOUNTERED.
!
    dnb = (x(nb)-x1)**2 + (y(nb)-y1)**2
    if (np .ne. 0  .and.  dnb .ge. dnp) go to 2
    np = nb
    dnp = dnb
2 continue
npts(l) = np
ds = dnp
!
! UNMARK THE ELEMENTS OF NPTS
!
do i = 1,lm1
  ni = npts(i)
  iend(ni) = -iend(ni)
  end do
return
!
! L IS OUT OF RANGE
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
!                    EVALUATION OF THE SURFACE
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
!     ERROR RETURN
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
!                EVALUATION OF THE SURFACE OVER A GRID
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
!     ERROR RETURN
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   GIVEN A TRIANGULATION OF A SET OF POINTS IN THE PLANE,
! THIS ROUTINE DETERMINES A PIECEWISE CUBIC FUNCTION F(X,Y)
! WHICH INTERPOLATES A SET OF DATA VALUES AND PARTIAL
! DERIVATIVES AT THE VERTICES.  F HAS CONTINUOUS FIRST
! DERIVATIVES OVER THE MESH AND EXTENDS BEYOND THE MESH
! BOUNDARY ALLOWING EXTRAPOLATION.  INTERPOLATION IS EXACT
! FOR QUADRATIC DATA.  THE VALUE OF F AT (PX,PY) IS
! RETURNED.  INTRC1 IS PART OF AN INTERPOLATION PACKAGE
! WHICH PROVIDES ROUTINES TO GENERATE, UPDATE AND PLOT THE
! MESH.
!
! INPUT PARAMETERS -     N - NUMBER OF NODES IN THE MESH.
!                            N .GE. 3.
!
!                    PX,PY - COORDINATES OF A POINT AT WHICH
!                            F IS TO BE EVALUATED.
!
!                      X,Y - VECTORS OF COORDINATES OF THE
!                            NODES IN THE MESH.
!
!                        Z - VECTOR OF DATA VALUES AT THE
!                            NODES.
!
!                     IADJ - SET OF ADJACENCY LISTS OF NODES
!                            IN THE MESH.
!
!                     IEND - POINTERS TO THE ENDS OF
!                            ADJACENCY LISTS IN IADJ FOR
!                            EACH NODE IN THE MESH.
!
!                    IFLAG - OPTION INDICATOR
!                            IFLAG = 0 IF INTRC1 IS TO
!                                      PROVIDE DERIVATIVE
!                                      ESTIMATES (FROM
!                                      GRADL1).
!                            IFLAG = 1 IF DERIVATIVES ARE
!                                      USER PROVIDED.
!
!                     ZXZY - 2 BY N ARRAY WHOSE COLUMNS
!                            CONTAIN ESTIMATED PARTIAL DER-
!                            IVATIVES AT THE NODES (X PAR-
!                            TIALS IN THE FIRST ROW) IF
!                            IFLAG = 1, NOT USED IF IFLAG
!                            = 0.
!
!                      IST - INDEX OF THE STARTING NODE IN
!                            THE SEARCH FOR A TRIANGLE CON-
!                            TAINING (PX,PY).  1 .LE. IST
!                            .LE. N.  THE OUTPUT VALUE OF
!                            IST FROM A PREVIOUS CALL MAY
!                            BE A GOOD CHOICE.
!
! IADJ AND IEND MAY BE CREATED BY TRMESH AND DERIVATIVE
!   ESTIMATES MAY BE COMPUTED BY GRADL1 OR GRADG.
!
! INPUT PARAMETERS OTHER THAN IST ARE NOT ALTERED BY THIS
!   ROUTINE.
!
! OUTPUT PARAMETERS - IST - INDEX OF ONE OF THE VERTICES OF
!                           THE TRIANGLE CONTAINING (PX,PY)
!                           UNLESS IER .LT. 0.
!
!                      PZ - VALUE OF F AT (PX,PY), OR 0 IF
!                           IER .LT. 0.
!
!                     IER - ERROR INDICATOR
!                           IER = 0 IF NO ERRORS WERE
!                                   ENCOUNTERED.
!                           IER = 1 IF NO ERRORS WERE EN-
!                                   COUNTERED AND EXTRAPOLA-
!                                   TION WAS PERFORMED.
!                           IER = -1 IF N, IFLAG, OR IST IS
!                                    OUT OF RANGE.
!                           IER = -2 IF THE NODES ARE COL-
!                                    LINEAR.
!
! MODULES REFERENCED BY INTRC1 - TRFIND, TVAL,
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
! LOCAL PARAMETERS -
!
! NN =                      LOCAL COPY OF N
! I1,I2,I3 =                VERTICES DETERMINED BY TRFIND
! IERR =                    ERROR FLAG FOR CALLS TO GRADL1
!                             AND TVAL
! N1,N2 =                   ENDPOINTS OF THE CLOSEST BOUND-
!                             ARY EDGE TO P WHEN P IS OUT-
!                             SIDE OF THE MESH BOUNDARY
! INDX =                    IADJ INDEX OF N1 AS A NEIGHBOR
!                             OF N2
! XP,YP =                   LOCAL COPIES OF THE COORDINATES
!                             OF P=(PX,PY)
! ZX1,ZY1,ZX2,ZY2,ZX3,ZY3 = X AND Y DERIVATIVES AT THE
!                             VERTICES OF A TRIANGLE T WHICH
!                             CONTAINS P OR AT N1 AND N2
! X1,Y1,X2,Y2,X3,Y3 =       X,Y COORDINATES OF THE VERTICES
!                             OF T OR OF N1 AND N2
! Z1,Z2,Z3 =                DATA VALUES AT THE VERTICES OF T
! DUM =                     DUMMY VARIABLE FOR CALL TO TVAL
! DP =                      INNER PRODUCT OF N1-N2 AND P-N2
! U,V =                     X,Y COORDINATES OF THE VECTOR
!                             N2-N1
! XQ,YQ =                   X,Y COORDINATES OF THE CLOSEST
!                             BOUNDARY POINT TO P WHEN P IS
!                             OUTSIDE OF THE MESH BOUNDARY
! R1,R2 =                   BARYCENTRIC COORDINATES OF Q
!                             WITH RESPECT TO THE LINE SEG-
!                             MENT N2-N1 CONTAINING Q
! A1,A2,B1,B2,C1,C2 =       CARDINAL FUNCTIONS FOR EVALUAT-
!                             ING THE INTERPOLATORY SURFACE
!                             AT Q
! F1,F2 =                   CUBIC FACTORS USED TO COMPUTE
!                             THE CARDINAL FUNCTIONS
!
nn = n
pz = 0.
if (nn .lt. 3  .or.  iflag .lt. 0  .or.  iflag .gt. 1 &
&.or.  ist .lt. 1  .or.  ist .gt. nn) go to 11
xp = px
yp = py
!
! FIND A TRIANGLE CONTAINING P IF P IS WITHIN THE MESH
!   BOUNDARY
!
call trfind(ist,xp,yp,x,y,iadj,iend, i1,i2,i3)
if (i1 .eq. 0) go to 12
ist = i1
if (i3 .eq. 0) go to 3
if (iflag .ne. 1) go to 1
!
! DERIVATIVES ARE USER PROVIDED
!
zx1 = zxzy(1,i1)
zx2 = zxzy(1,i2)
zx3 = zxzy(1,i3)
zy1 = zxzy(2,i1)
zy2 = zxzy(2,i2)
zy3 = zxzy(2,i3)
go to 2
!
! COMPUTE DERIVATIVE ESTIMATES AT THE VERTICES
!
1 call gradl1(nn,i1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,i2,x,y,z,iadj,iend, zx2,zy2,ierr)
call gradl1(nn,i3,x,y,z,iadj,iend, zx3,zy3,ierr)
!
! SET LOCAL PARAMETERS FOR CALL TO TVAL
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
! P IS OUTSIDE OF THE MESH BOUNDARY.  EXTRAPOLATE TO P BY
!   PASSING A LINEAR FUNCTION OF ONE VARIABLE THROUGH THE
!   VALUE AND DIRECTIONAL DERIVATIVE (IN THE DIRECTION
!   P-Q) OF THE INTERPOLATORY SURFACE (TVAL) AT Q WHERE
!   Q IS THE CLOSEST BOUNDARY POINT TO P.
!
! DETERMINE Q BY TRAVERSING THE BOUNDARY STARTING FROM
!   THE RIGHTMOST VISIBLE NODE I1.
!
3 n2 = i1
!
! SET N1 TO THE LAST NONZERO NEIGHBOR OF N2 AND COMPUTE DP
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
! N2 IS THE CLOSEST BOUNDARY POINT TO P.  COMPUTE PARTIAL
!   DERIVATIVES AT N2.
!
5 if (iflag .ne. 1) go to 6
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 7
6 call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
!
! COMPUTE EXTRAPOLATED VALUE AT P
!
7 pz = z(n2) + zx2*(xp-x2) + zy2*(yp-y2)
ier = 1
return
!
! THE CLOSEST BOUNDARY POINT Q LIES ON N2-N1.  COMPUTE
!   PARTIALS AT N1 AND N2.
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
! COMPUTE Q, ITS BARYCENTRIC COORDINATES, AND THE CARDINAL
!   FUNCTIONS FOR EXTRAPOLATION
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
! COMPUTE THE VALUE OF THE INTERPOLATORY SURFACE (TVAL)
!   AT Q
!
pz = a1*z(n1) + a2*z(n2) + b1*zx1 + b2*zx2 + &
&c1*zy1 + c2*zy2
!
! COMPUTE THE EXTRAPOLATED VALUE AT P
!
pz = pz + (r1*zx1 + r2*zx2)*(xp-xq) + &
&(r1*zy1 + r2*zy2)*(yp-yq)
ier = 1
return
!
! N, IFLAG, OR IST OUT OF RANGE
!
11 ier = -1
return
!
! NODES ARE COLLINEAR
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
!                                               ROBERT RENKA
!                                       OAK RIDGE NATL. LAB.
!                                             (615) 576-5139
!
!   GIVEN FUNCTION VALUES AND FIRST PARTIAL DERIVATIVES AT
! THE THREE VERTICES OF A TRIANGLE, THIS ROUTINE DETERMINES
! A FUNCTION W WHICH AGREES WITH THE GIVEN DATA, RETURNING
! THE VALUE AND (OPTIONALLY) FIRST PARTIAL DERIVATIVES OF W
! AT A POINT (X,Y) IN THE TRIANGLE.  THE INTERPOLATION
! METHOD IS EXACT FOR QUADRATIC POLYNOMIAL DATA.  THE
! TRIANGLE IS PARTITIONED INTO THREE SUBTRIANGLES WITH
! EQUAL AREAS.  W IS CUBIC IN EACH SUBTRIANGLE AND ALONG
! THE EDGES, BUT HAS ONLY ONE CONTINUOUS DERIVATIVE ACROSS
! EDGES.  THE NORMAL DERIVATIVE OF W VARIES LINEARLY ALONG
! EACH OUTER EDGE.  THE VALUES AND PARTIAL DERIVATIVES OF W
! ALONG A TRIANGLE EDGE DEPEND ONLY ON THE DATA VALUES AT
! THE ENDPOINTS OF THE EDGE.  THUS THE METHOD YIELDS C-1
! CONTINUITY WHEN USED TO INTERPOLATE OVER A TRIANGULAR
! GRID.  THIS ALGORITHM IS DUE TO C. L. LAWSON.
!
! INPUT PARAMETERS -   X,Y - COORDINATES OF A POINT AT WHICH
!                            W IS TO BE EVALUATED.
!
!        X1,X2,X3,Y1,Y2,Y3 - COORDINATES OF THE VERTICES OF
!                            A TRIANGLE CONTAINING (X,Y).
!
!                 Z1,Z2,Z3 - FUNCTION VALUES AT THE VERTICES
!                            TO BE INTERPOLATED.
!
!              ZX1,ZX2,ZX3 - X-DERIVATIVE VALUES AT THE
!                            VERTICES.
!
!              ZY1,ZY2,ZY3 - Y-DERIVATIVE VALUES AT THE
!                            VERTICES.
!
!                    IFLAG - OPTION INDICATOR
!                            IFLAG = 0 IF ONLY W IS TO BE
!                                      COMPUTED.
!                            IFLAG = 1 IF W, WX, AND WY ARE
!                                      TO BE RETURNED.
!
! INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
!
! OUTPUT PARAMETERS -   W - ESTIMATED VALUE OF THE INTERP-
!                           OLATORY FUNCTION AT (X,Y) IF
!                           IER = 0.  OTHERWISE W = 0.
!
!                   WX,WY - PARTIAL DERIVATIVES OF W AT
!                           (X,Y) IF IER = 0 AND IFLAG = 1,
!                           UNCHANGED IF IFLAG .NE. 1, ZERO
!                           IF IER .NE. 0 AND IFLAG = 1.
!
!                     IER - ERROR INDICATOR
!                           IER = 0 IF NO ERRORS WERE
!                                   ENCOUNTERED.
!                           IER = 1 IF THE VERTICES OF THE
!                                   TRIANGLE ARE COLLINEAR.
!
! MODULES REFERENCED BY TVAL - NONE
!
! INTRINSIC FUNCTION CALLED BY TVAL - AMIN1
!
!***********************************************************
!
integer :: i, ip1, ip2, ip3
real :: u(3), v(3), sl(3), area, xp, yp, r(3), rx(3), ry(3), &
&phi(3), phix(3), phiy(3), rmin, c1, c2, ro(3), rox(3), roy(3), &
&f(3), g(3), gx(3), gy(3), p(3), px(3), py(3), q(3), qx(3), qy(3), &
&a(3), ax(3), ay(3), b(3), bx(3), by(3), c(3), cx(3), cy(3)
!
! LOCAL PARAMETERS -
!
! I =               DO-LOOP INDEX
! IP1,IP2,IP3 =     PERMUTED INDICES FOR COMPUTING RO, ROX,
!                     AND ROY
! U(K) =            X-COMPONENT OF THE VECTOR REPRESENTING
!                     THE SIDE OPPOSITE VERTEX K
! V(K) =            Y-COMPONENT OF THE VECTOR REPRESENTING
!                     THE SIDE OPPOSITE VERTEX K
! SL(K) =           SQUARE OF THE LENGTH OF THE SIDE
!                     OPPOSITE VERTEX K
! AREA =            TWICE THE AREA OF THE TRIANGLE
! XP,YP =           X-X1, Y-Y1
! R(K) =            K-TH BARYCENTRIC COORDINATE
! RX(K),RY(K) =     X,Y PARTIAL DERIVATIVES OF R(K)
! PHI(K)            R(K-1)*R(K+1) -- QUADRATIC
! PHIX(K),PHIY(K) = X,Y PARTIALS OF PHI(K)
! RMIN =            MIN(R1,R2,R3)
! C1,C2 =           FACTORS FOR COMPUTING RO
! RO(K) =           FACTORS FOR COMPUTING G -- CUBIC
!                     CORRECTION TERMS
! ROX(K),ROY(K) =   X,Y PARTIALS OF RO(K)
! F(K) =            FACTORS FOR COMPUTING G, GX, AND GY --
!                     CONSTANT
! G(K) =            FACTORS FOR COMPUTING THE CARDINAL
!                     FUNCTIONS -- CUBIC
! GX(K),GY(K) =     X,Y PARTIALS OF G(K)
! P(K) =            G(K) + PHI(K)
! PX(K),PY(K) =     X,Y PARTIALS OF P(K)
! Q(K) =            G(K) - PHI(K)
! QX(K),QY(K) =     X,Y PARTIALS OF Q(K)
! A(K) =            CARDINAL FUNCTION WHOSE COEFFICIENT IS
!                     Z(K)
! AX(K),AY(K) =     X,Y PARTIALS OF A(K) -- CARDINAL
!                     FUNCTIONS FOR WX AND WY
! B(K) =            TWICE THE CARDINAL FUNCTION WHOSE
!                     COEFFICIENT IS ZX(K)
! BX(K),BY(K) =     X,Y PARTIALS OF B(K)
! C(K) =            TWICE THE CARDINAL FUNCTION WHOSE
!                     COEFFICIENT IS ZY(K)
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
! W IS A LINEAR COMBINATION OF THE CARDINAL FUNCTIONS
!
w = a(1)*z1 + a(2)*z2 + a(3)*z3 + (b(1)*zx1 + b(2)*zx2 &
&+ b(3)*zx3 + c(1)*zy1 + c(2)*zy2 + c(3)*zy3)/2.
if (iflag .ne. 1) return
!
! COMPUTE WX AND WY
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
! WX AND WY ARE LINEAR COMBINATIONS OF THE CARDINAL
!   FUNCTIONS
!
wx = ax(1)*z1 + ax(2)*z2 + ax(3)*z3 + (bx(1)*zx1 + &
&bx(2)*zx2 + bx(3)*zx3 + cx(1)*zy1 + cx(2)*zy2 + &
&cx(3)*zy3)/2.
wy = ay(1)*z1 + ay(2)*z2 + ay(3)*z3 + (by(1)*zx1 + &
&by(2)*zx2 + by(3)*zx3 + cy(1)*zy1 + cy(2)*zy2 + &
&cy(3)*zy3)/2.
return
!
! VERTICES ARE COLLINEAR
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
!     PURPOSE
!     -------
!
!     THIS SUBROUTINE CONSTRUCTS A LEAST-SQUARES  MULTINOMIAL  FIT  TO
!     GIVEN DATA USING A BASIS OF ORTHOGONAL MULTINOMIALS.
!
!     THE DATA FOR THE FIT IS GIVEN IN THE ARRAYS FITCDS, FITVLS, AND
!     WTS. FITCDS IS A MATRIX, EACH ROW OF WHICH CONTAINS AN OBSERVA-
!     TION POINT. FITVLS IS A SINGLY-INDEXED ARRAY, EACH ELEMENT OF
!     WHICH CONTAINS A FUNCTION VALUE CORRESPONDING TO AN OBSERVATION
!     POINT. WTS IS A SINGLY-INDEXED ARRAY, EACH ELEMENT OF WHICH IS
!     A NONNEGATIVE WEIGHT FOR THE CORRESPONDING OBSERVATION.
!
!     THE FIT WHICH IS PRODUCED IS A MULTINOMIAL EXPRESSED IN THE FORM
!
!      C  PSI  (X ,...,X     ) +...+ C       PSI       (X ,...,X     )
!       1    1   1      DIMEN         NFPOLS    NFPOLS   1      DIMEN
!
!     WHERE THE VALUE OF  NFPOLS  WILL BE AS GIVEN (IF  FITDEG .LT. 0)
!     OR  AS  COMPUTED  BY  MFIT  TO GIVE A FULL-DEGREE FIT (IN CASE
!     FITDEG  IS SPECIFIED .GE. 0).  THE ELEMENTS
!
!         PSI  (X ,...,X     )
!            K   1      DIMEN
!
!     FORM A BASIS FOR THE MULTINOMIALS WHICH IS ORTHOGONAL WITH
!     RESPECT TO THE WEIGHTS AND OBSERVATION POINTS.
!
!     THE EXTENT OF THE FIT CAN BE SPECIFIED IN ONE OF TWO WAYS.
!         IF THE PARAMETER FITDEG IS SET .GE. 0, THEN A COMPLETE BASIS
!         FOR THE MULTINOMIALS OF DEGREE =  FITDEG  WILL BE USED.  (AN
!         ERROR WILL BE  FLAGGED  IF  THIS  WILL  REQUIRE  MORE  BASIS
!         MULTINOMIALS  THAN  THE  NUMBER  OF  DATA  POINTS WHICH WERE
!         GIVEN.)
!         IF THE PARAMETER  FITDEG  IS .LT.  0, THEN  NFPOLS  WILL  BE
!         TAKEN AS THE COUNT OF THE NUMBER OF BASIS MULTINOMIALS TO BE
!         USED FOR A PARTIAL-DEGREE FIT.  (AN ERROR WILL BE FLAGGED IF
!         NFPOLS  .LT. 0.)
!
!     VARIABLES
!     ---------
!
!      DIMEN  -- (INTEGER) -- (PASSED)
!         THE NUMBER OF VARIABLES.
!      FITDEG  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF .LT. 0.
!         IF FITDEG .GE. 0 THEN  FITDEG  IS  CHECKED  AGAINST  NFPTS .
!         THE VALUE OF  FITDEG  WILL BE REDUCED IF THERE IS A BASIS OF
!         MULTINOMIALS, ALL OF  DEGREE  .LE. FITDEG ,  OF  CARDINALITY
!         NFPTS .  SEE  ERROR  BELOW.
!      NFPOLS  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF  FITDEG  .GE. 0.
!         IF  FITDEG .LT. 0 THEN THE VALUE OF NFPOLS WILL BE TAKEN  AS
!         THE SIZE OF THE BASIS OF MULTINOMIALS TO BE USED IN THE FIT.
!         NFPOLS  MUST SATISFY  NFPOLS  .LT. NFPTS  AND NFPOLS .GE. 1
!         SEE  ERROR  BELOW.
!      NFPTS  --- (INTEGER) -- (PASSED)
!         THE NUMBER OF DATA POINTS TO BE USED IN THE FIT.
!         NFPTS  MUST BE .GE. 1.  SEE  ERROR  BELOW.
!      FITCDS  -- (REAL 2-SUBSCRIPT ARRAY) -- (PASSED)
!         FITCDS (P,K) IS THE VALUE OF THE K-TH VARIABLE AT THE  P-TH
!         DATA POINT.
!      NCROWS  -- (INTEGER) -- (PASSED)
!         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!         PROGRAM.
!      FITVLS  -- (REAL 1-SUBSCRIPT ARRAY) -- (PASSED)
!         FITVLS (P) IS THE OBSERVED FUNCTION VALUE OF THE P-TH  DATA
!         POINT.
!      WTS  ----- (REAL 1-SUBSCRIPT ARRAY) -- (PASSED)
!         WTS (P) IS THE WEIGHT ATTACHED TO THE P-TH DATA POINT.
!      RESIDS  -- (REAL 1-SUBSCRIPT ARRAY) -- (RETURNED)
!         RESIDS (P) IS THE DIFFERENCE BETWEEN THE FITTED FUNCTION AT
!         POINT P AND  FITVLS (P).
!      ERROR  -- (INTEGER) -- (RETURNED)
!       0 THE DESIRED LEAST SQUARE MULTINOMIAL FIT WAS OBTAINED.
!      -1 ONLY THE FIRST NFPOLS BASIS POLYNOMIALS WERE OBTAINED.
!         FITDEG IS THE DEGREE OF THE FIT.
!       1 IF  FITDEG  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
!         OF SMALLER DEGREE OR IF FITDEG .LT. 0 AND NFPOLS .GT. NFPTS.
!       2 IF  FITDEG  .LT. 0 AND  NFPOLS  .LE. 0.
!       3 IF  NFPTS  .LT. 1 AND/OR  DIMEN  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         THE VALUE RETURNED IN  IREQD , AND SET  DWKLEN  TO THE VALUE
!         RETURNED IN  DREQD  TO RESOLVE THIS PROBLEM.)
!      FITIWK  -- (INTEGER, 1-SUBSCRIPT ARRAY) -- (RETURNED)
!         AN INTEGER WORK ARRAY OF LENGTH  FIWKLN .  UPON RETURN  FROM
!         MFIT, FITIWK CONTAINS DIMENSION AND ARRAY LENGTH INFORMATION.
!      FITDWK  -- (REAL 1-SUBSCRIPT ARRAY) -- (RETURNED)
!         A REAL ARRAY OF LENGTH  FDWKLN  CONTAINING THE COEFFICIENTS
!         NEEDED FOR COMPUTING THE MULTINOMIAL FIT AT A POINT.
!      FIWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF THE ARRAY  FITIWK .
!      FDWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF THE ARRAY  FITDWK .
!      IREQD  -- (INTEGER) -- (RETURNED)
!         THE LENGTH WHICH THE ARRAY  FITIWK  REALLY NEEDS TO BE.
!      DREQD  -- (INTEGER) -- (RETURNED)
!         THE LENGTH WHICH THE ARRAY  FITDWK  REALLY NEEDS TO BE.
!
!
!     NOTE. THE 20 LOOP DEPENDS ON THE SCALING SCHEME BEING USED. THE
!     RESIDUAL SCALING MUST BE CONSISTENT WITH THAT DEFINED BY SCALPM
!     AND SCALDN.
!
!     MFIT  CALLS  ALLOT  AND  GNRTP.
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
!     STORE THE NUMBER OF BASIS POLYNOMIALS ACTUALLY COMPUTED
!     BY THE MODIFIED ROUTINE INCDG CALLED BY GNRTP.
!     ***************
!
fitiwk(1) = nfpols
!
!     ***************
!     UNSCALE THE RESIDUALS FOR THE BENEFIT OF THE USER.
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
!     PURPOSE
!     -------
!
!      ALLOT  CHECKS FOR SUFFICIENCY THE DECLARED  DIMENSIONS  OF  THE
!     WORK  ARRAYS  USED BY THE SUBROUTINE  MFIT .  VARIOUS SIZES OF
!     SUB-ARRAYS ARE COMPUTED AND REPORTED.
!
!     THIS ROUTINE IS CALLED BY  MFIT .  IT IS NOT  CALLED  DIRECTLY
!     BY THE USER.
!
!     THIS ROUTINE CALLS   BASIZ   AND   MTABLE   FOR  THE  SUBSTANTIVE
!     COMPUTATIONS.
!
!     VARIABLES
!     ---------
!
!      DEGREE  - (PASSED/RETURNED)
!         IGNORED IF .LT. 0.
!         IF  DEGREE  .GE. 0 THEN  DEGREE IS CHECKED  AGAINST   NPTS .
!         THE VALUE OF  DEGREE  WILL BE REDUCED IF THERE IS A BASIS OF
!         MULTINOMIALS, ALL OF  DEGREE .LE.  DEGREE ,  OF  CARDINALITY
!          NPTS
!      NPOLYS  - (PASSED/RETURNED)
!         IGNORED IF  DEGREE  .GE. 0.
!         IF DEGREE .LT. 0 THEN THE VALUE OF NPOLYS WILL BE TAKEN  AS
!         THE SIZE OF THE BASIS OF MULTINOMIALS TO BE USED IN THE FIT.
!         NPOLYS  MUST SATISFY NPOLYS .LT.  NPTS  AND  NPOLYS  .GE. 1
!      NPTS  --- (PASSED)
!         THE NUMBER OF DATA POINTS TO BE USED IN THE FIT.
!          NPTS  MUST BE .GE. 1.
!      DIMEN  -- (PASSED)
!         THE NUMBER OF VARIABLES.
!      IWORK  -- (RETURNED)
!         AN INTEGER WORK ARRAY OF LENGTH AT LEAST
!            IF  DEGREE  .GE. 0 THEN
!               4*BINOMIAL( DIMEN + DEGREE , DIMEN )
!                  +( DIMEN )*( DEGREE )
!            ELSE
!               4*BINOMIAL( DIMEN +D,D)+( DIMEN )*D
!         WHERE D IS THE MINIMUM CARDINALITY  OF  A  BASIS  OF  DEGREE
!          DEGREE  SUCH THAT
!            BINOMIAL( DIMEN +ABS( DEGREE ), DIMEN ) .GE.  NPOLYS
!      IWKLEN  - (PASSED)
!         THE LENGTH OF  IWORK
!      IREQD  -- (RETURNED)
!         THE SIZE OF THE INTEGER WORK ARRAY REQUIRED BY  MFIT   FOR
!         THE FIT SPECIFIED BY THE 4 INPUT PARAMETERS.
!      DREQD  -- (RETURNED)
!         THE SIZE OF THE DOUBLE  PRECISION  WORK  ARRAY  REQUIRED  BY
!          MFIT  FOR THE FIT SPECIFIED BY THE 4 INPUT PARAMETERS.
!      ERROR  -- (RETURNED)
!       0 IF  NPOLYS ,  DIMEN ,   DEGREE ,   NPTS   AND   IWKLEN   ARE
!         VALID AND CONSISTENT WITH EACH OTHER.
!       1 IF  DEGREE  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
!         OF SMALLER DEGREE OR IF  DEGREE .LT. 0 AND  NPOLYS .GT. NPTS
!       2 IF  DEGREE  .LT. 0 AND  NPOLYS  .LE. 0
!       3 IF  NPTS  .LT. 1 AND/OR  DIMEN  .LT. 1
!       4 IF  IWKLEN  IS TOO SMALL (SET  IWKLEN  TO THE VALUE RETURNED
!         IN  IREQD  TO RESOLVE THIS PROBLEM)
!
!     NOTE THAT  DEGREE ,  NPOLYS ,  PSIWID  AND  ALFL   ARE  RETURNED
!     IN  IWORK (1-4), RESPECTIVELY.
!
!     DATE LAST MODIFIED
!     ---- ---- --------
!     DECEMBER 10, 1984
!     ****************
!
!     ***************
!     BASIZ  COMPUTES THE SIZE OF THE BASIS (AND AUXILIARY SIZES)
!     BASED PRIMARILY UPON THE DEGREE, NUMBER OF  FITTING POINTS,
!     AND THE DIMENSION.
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
!     SET UP USEFUL INDEXING ARRAYS
!          IWORK(1) ,..., IWORK(NEWSTT-1)
!     AND
!          IWORK(NEWSTT ,..., IWORK(NEWSTT+DIMEN*DEGREE)
!     ***************
!
call mtable(degree,dimen,npolys,iwork,iwork(newstt),alfl)
iwork(1) = degree
iwork(2) = npolys
!
!     ***************
!     FORCE  ALFL  TO BE AT LEAST 1 SO THAT DIMENSION STATEMENTS
!     USING  ALFL  DO NOT BOMB.
!     ***************
!
if ( alfl .gt. 1 ) alfl = alfl - 1
iwork(4) = alfl
!
!     ***************
!     THE FOLLOWING IS A SECTION OF CODE FOR SETTING UP THE
!     STORAGE  MANAGEMENT OF THE  PSI  ARRAY.  THERE  IS  A
!     COMPLICATED DOVETAILING FORMULA USED TO PACK INFORMATION
!     INTO  PSI  WITHOUT LEAVING GAPS.
!
!     ARRAY          LENGTH
!     -----          ------
!      MAXABS         DIMEN  + 1
!      ALPHA          ALFL
!      C              NPOLYS
!      SUMSQS         NPOLYS
!
!     THE NUMBER OF COLUMNS IN  PSI ,  PSIWID , IS DETERMINED BY
!     PSIWID  =  NPOLYS  + 1 - (THE SMALLEST M SUCH THAT ALPHA(J,M)
!                                   IS NONZERO AND J .GE. NPOLYS)
!     THIS INSURES THAT IF THE USER EXTENDS THE BASIS, ALL THE  PSI
!     REQUIRED WILL CERTAINLY BE STORED
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
!                         THE SMALLER OF
!                           NEWKJ(K+1,DEGREE(NPOLYS)-2)    (CASE 3)
!                         AND
!                           INDEXS(3,NPOLYS)               (CASE 4)
!                        )
!
if ( degree .gt. 2 ) go to 10
!
!     ***************
!     CASE 1
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
!     CASE 2
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
!     CASE 4
!     ***************
!
         psiwid = npolys - startj + 1
      go to 40
!
!     ***************
!     CASE 3
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
!     PURPOSE
!     -------
!
!     IF  DEGREE  .GE. 0 THEN
!       FIND THE SIZE OF A BASIS REQUIRED EITHER TO
!       1) APPROXIMATE THE DATA WITH A POLYNOMIAL OF DEGREE
!          GIVEN BY THE PARAMETER  DEGREE
!       OR TO
!       2) SPAN THE SPACE OF POLYNOMIALS OF DEGREE .LE. THE
!          SMALLEST DEGREE OF POLYNOMIAL WHICH INTERPOLATES THE
!          DATA.
!       IN CASE 1  ERROR  = 0.
!       IN CASE 2  ERROR  = 1.
!     ELSE
!       IF  NPOLYS  .GE. 1 THEN
!          IF NPOLYS .GT. NPTS THEN
!             SET  NPOLYS  =  NPTS , FIND THE SMALLEST DEGREE OF A
!             POLYNOMIAL  WHICH  INTERPOLATES  THE  DATA,  AND SET
!              ERROR  = 1.
!          ELSE
!             FIND THE LARGEST DEGREE  DEGREE  OF A POLYNOMIAL  IN
!             A  BASIS OF  NPOLYS  POLYNOMIALS GENERATED ACCORDING
!             TO OUR ORDERING AND SET  ERROR  = 0.
!       ELSE
!           ERROR  = 2
!
!     THIS SUBROUTINE IS CALLED BY  ALLOT .  IT IS NOT  CALLED  BY
!     THE USER DIRECTLY.
!
!     DATE LAST MODIFIED
!     ---- ---- --------
!     OCTOBER 16, 1984
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
!     PURPOSE
!     -------
!
!     TABULATE  JP  AND  KJ  FOR EACH  J
!
!     VARIABLES
!     ---------
!
!      ALFLP1  -- (INTEGER) -- (PASSED)
!         THE LENGTH REQUIRED FOR ARRAY  ALPHA , PLUS ONE
!      DEGREE  -- (INTEGER) -- (PASSED)
!         THE DEGREE OF THE POLYNOMIAL TO BE FITTED
!      DIMEN  -- (INTEGER) -- (PASSED)
!         NUMBER OF INDEPENDENT VARIABLES
!      INDEXS  -- (INTEGER, 2-SUBSCRIPT ARRAY) -- (RETURNED)
!          INDEXS (1, J )   IS    JP ,    INDEXS (2, J )   IS     KJ ,
!          INDEXS (3, J )  IS THE FIRST NONZERO RECURRENCE COEFFICIENT
!         IN  ALPHA  AND  INDEXS (4, J ) IS ITS LOCATION IN  ALPHA .
!      NEWKJ  -- (INTEGER, 2-SUBSCRIPT ARRAY) -- (RETURNED)
!          NEWKJ ( K , D ) IS THE FIRST MONOMIAL OF DEGREE  D   HAVING
!          KJ = K .
!      NPOLYS  -- (INTEGER) -- (PASSED)
!         NUMBER  OF  MONOMIALS  OF  DEGREE  .LE.  ORDER  IN   DIMEN
!         INDEPENDENT VARIABLES.
!
!     THIS SUBPROGRAM CAN BE CODED (EXCLUDING THE PART FOR CALCULATING
!      INDEXS (3, J )  AND   INDEXS (4, J )) MENTALLY MORE EFFICIENTLY
!     BUT COMPUTATIONALLY LESS EFFICIENTLY AS
!
!         J = 2
!         DO 5 KJ = 1,DIMEN
!           NEWKJ(KJ,1) = KJ + 1
!           INDEXS(1,J) = 1
!           INDEXS(2,J) = KJ
!           J = J + 1
!      5  CONTINUE
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
!     10  CONTINUE
!
!     WHERE COMB(N,KJ) IS N-FACTORIAL / ((N-KJ)-FACTORIAL * KJ-FACTORIAL
!     HERE WE MAKE USE OF THE RECURRENCE RELATIONS
!
!       COMB(DIMEN+CURDEG-2,CURDEG-1)
!
!            (DIMEN+CURDEG-2)*COMB(DIMEN+CURDEG-3,CURDEG-2)
!          = ----------------------------------------------
!                              (CURDEG-1)
!
!     AND
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
!     OCTOBER 16, 1984
!     ****************
!
alflp1 = 1
!
!     ***************
!     SET  INDEXS (4,1) TO 1 SO THAT  ALFL - INDEXS (4,1)+1 IS THE
!     NUMBER OF COLUMNS REQUIRED FOR  PSI  FOR  NPOLYS =1  ( ALFL
!     IS DEFINED IN THE MAINLINE TO BE  ALFLP1 -1 IF ALFLP1 .GT. 1
!     AND  ALFLP1  OTHERWISE.
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
!     PURPOSE
!     -------
!
!     THE MULTINOMIAL FIT IS GENERATED INCREMENTALLY, A BASIS  ELEMENT
!     AT A TIME.  THIS SUBROUTINE STARTS THE PROCESS OFF BY SETTING UP
!     THE FIRST BASIS ELEMENT, SCALING THE  DATA,  FINDING  THE  FIRST
!     COEFFICIENT,  AND  INITIALIZING  THE  WORK ARRAY Z.  GNRTP  THEN
!     CALLS  INCDG  IF MORE THAN ONE BASIS ELEMENT IS REQUIRED.
!
!     THIS SUBROUTINE IS CALLED BY  MFIT .  IT IS NOT CALLED BY  THE
!     USER.
!
!     THIS SUBROUTINE CALLS  SCALPM ,  SCALDN , AND  INCDG .
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!     ****************
!
!     ***************
!     SET UP THE SCALING.
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
!     PURPOSE
!     -------
!
!     THE MULTINOMIAL FIT IS GENERATED INCREMENTALLY, A BASIS  ELEMENT
!     AT A TIME.  THIS SUBROUTINE CONTINUES THE PROCESS STARTED OFF BY
!      GNRTP .
!
!     THIS SUBROUTINE IS CALLED BY  GNRTP  AND NOT BY THE USER.
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
!     CALCULATE THOSE  ALPHA ( J , M ) THAT CAN BE CALCULATED FROM
!     PREVIOUSLY CALCULATED ALPHAS.
!     ***************
!
   if ( kj .lt. kjp ) go to 50
!
!     ***************
!     FIRST CALCULATE THOSE BETWEEN  JPP  AND THE END OF 2 ROWS BACK.
!     CALCULATE  ALPHA ( J , JPP )
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
!     PREVIOUS AND 8-TH PREVIOUS STATEMENTS.
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
!     CALCULATE  ALPHA ( J , M ) FOR  M  BETWEEN THE 2
!     RANGES CALCULATED BEFORE USING
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
!     CALCULATE  ALPHA ( J , M ) FOR  M  BETWEEN
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
!     CALCULATE THE REMAINING  ALPHA ( J , M ) FROM
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
!     NOW CALCULATE THE  PSI (P,J),  SUMSQS (J) AND  C (J) USING
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
!     CALCULATE THE NEW  Z ( P ) AND THE NEW  SSRES  USING
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
!     THE J-TH BASIS MULTINOMIAL CANNOT BE COMPUTED ACCURATELY.
!     ONLY J - 1 BASIS MULTINOMIALS ARE GENERATED.
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
!     PURPOSE
!     -------
!
!     FIND SCALING PARAMETER(S) FOR THE PROBLEM. IF THE SCALING SCHEME
!     IS CHANGED, ALL FOUR OF THE FOLLOWING WOULD HAVE TO BE CHANGED
!
!     1)  SCALPM  - FIND THE SCALING PARAMETERS
!     2)  SCALDN  - SCALE THE PROBLEM DATA
!     3)  THE SCALING OF THE RESIDUALS IN  MFIT
!     4)  THE SCALING PERFORMED IN  MEVAL1
!
!     THIS SUBROUTINE IS CALLED BY  GNRTP .  IT IS NOT CALLED  BY  THE
!     USER.
!
!     THE SCALING WHICH  IT  DEFINES  MUST  BE  COORDINATED  WITH  THE
!     SCALING  OF RESIDUALS WHICH IS CARRIED OUT TOWARD THE END OF THE
!     SUBROUTINE  MFIT.  THE SCALING MUST ALSO BE COORDINATED WITH THE
!     SCALING PERFORMED IN THE 10 LOOP  AND  AT STATEMENTS 40 AND 50
!     (WITH THE SCALE FACTOR MAXABS(DIMP1)) IN  MEVAL1.
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
!     PURPOSE
!     -------
!
!     CARRY OUT THE DATA-SCALING WHICH IS DEFINED  BY  THE  SUBROUTINE
!     SCALPM .
!
!     THIS SUBROUTINE IS CALLED BY  GNRTP .  IT IS NOT CALLED  BY  THE
!     USER.
!
!     THE SCALING WHICH THIS ROUTINE CARRIES OUT  MUST  BE  CONSISTENT
!     WITH THE SCALING IN THE SUBROUTINES MFIT AND MEVAL1.
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
!     PURPOSE
!     -------
!
!     THIS SUBROUTINE  EVALUATES  THE  LEAST-SQUARES  MULTINOMIAL  FIT
!     WHICH HAS BEEN PREVIOUSLY PRODUCED BY  MFIT .  EITHER THE FULL
!     MULTINOMIAL AS PRODUCED MAY BE EVALUATED,  OR  ONLY  AN  INITIAL
!     SEGMENT THEREOF.  AS IN THE CASE WITH  MFIT , IT IS POSSIBLE
!     (1) TO SPECIFY MULTINOMIALS OF A FULL GIVEN DEGREE, OR
!     (2) TO SPECIFY  THE  NUMBER  OF  ORTHOGONAL  BASIS  ELEMENTS  TO
!         ACHIEVE A PARTIAL-DEGREE FIT.
!
!     IN CASE (1), THE  DESIRED  DEGREE  IS  GIVEN  AS  THE  VALUE  OF
!     EVLDEG   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     VALUE USED FOR  FITDEG  IN  MFIT ), AND THE PARAMETER  NEPOLS
!     WILL  BE  SET  BY  MEVAL  TO SPECIFY THE NUMBER OF BASIS ELEMENTS
!     REQUIRED. IF  EVLDEG  .LT.  FITDEG   IS  GIVEN,  THEN  ONLY  THE
!     INITIAL  PORTION OF THE FITTING MULTINOMIAL (OF DEGREE  EVLDEG )
!     WILL BE EVALUATED.
!
!     IN CASE (2),  EVLDEG  IS TO BE SET NEGATIVE, IN WHICH  CASE  THE
!     VALUE  OF   NEPOLS  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   MFIT )  WILL  BE  TAKEN  AS
!     DEFINING  THE  INITIAL  PORTION OF THE FITTING MULTINOMIAL TO BE
!     EVALUATED.
!
!     IF  NEPOLS  =  NFPOLS  (WITH  EVLDEG  .LT.  0),  OR   EVLDEG   =
!     FITDEG  (WITH   EVLDEG   .GT.  0),  THEN  THE  FULL  MULTINOMIAL
!     GENERATED BY  MFIT  WILL BE EVALUATED.
!
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (COLLECTION  OF  VARIABLE  VALUES)  GIVEN AS A ROW OF THE MATRIX
!      EVLCDS .  THE  VALUES  PRODUCED  FROM  THE  FULL,  OR  PARTIAL,
!     MULTINOMIAL WILL BE PLACED IN THE ARRAY  EVLVLS .
!
!     VARIABLES
!     ---------
!
!      DIMEN  -- (INTEGER) -- (PASSED)
!         THE NUMBER OF VARIABLES.
!      EVLDEG  -- (INTEGER) -- (PASSED)
!         IF  EVLDEG  .LT. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF  EVLDEG  .GE. 0, THEN THE VALUE OF  EVLDEG  MUST  SATISFY
!         EVLDEG  .LE. (THE  DEGREE  OF THE APPROXIMATING MULTINOMIAL
!         GENERATED IN  MFIT ).  IN THIS CASE  EVLDEG  WILL  SPECIFY
!         THE DEGREE OF THE INITIAL PORTION OF THE FITTING MULTINOMIAL
!         TO BE EVALUATED.
!      NEPOLS  -- (INTEGER) -- (PASSED/RETURNED)
!         IF  EVLDEG  .GE. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF EVLDEG .LT. 0, THEN THE PARTIAL MULTINOMIAL INVOLVING THE
!         FIRST   NEPOLS  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         AT THE POINTS GIVEN BY  EVLCDS .  THE RESULTING VALUES  WILL
!         BE STORED IN  EVLVLS .
!         THE VALUE OF NEPOLS MUST BE .GE. 1 AND .LE. (THE SIZE OF THE
!         BASIS  GENERATED  IN   MFIT ),  WHICH  WAS RETURNED AS THE
!         VALUE OF  NFPOLS .
!         NEPOLS  WILL BE CHANGED IF EVLDEG .GT. 0 TO GIVE THE SIZE OF
!         BASIS REQUIRED FOR THE MULTINOMIAL OF DEGREE  EVLDEG .
!      NEPTS  -- (INTEGER) -- (PASSED)
!         THE NUMBER OF EVALUATION POINTS.
!      EVLCDS  -- (REAL 2-SUBSCRIPT ARRAY) -- (PASSED)
!         EVLCDS (P,K) IS THE VALUE OF THE K-TH VARIABLE AT THE  P-TH
!         EVALUATION POINT.
!      NEROWS  -- (INTEGER) -- (PASSED)
!         THE ROW DIMENSION DECLARED FOR EVLCDS IN THE CALLING PROGRAM.
!      EVLVLS  -- (INTEGER) -- (RETURNED)
!         EVLVLS (P) IS THE VALUE OF THE EVALUATED MULTINOMIAL AT THE
!         P-TH EVALUATION POINT.
!      ERROR  -- (INTEGER) -- (RETURNED)
!          0 .........  IF NO ERRORS
!         -1 .........  IF  NEPOLS  .GT.  NFPOLS  OR  NEPOLS  .LT. 1
!         -2 .........  IF  NEPTS  .LT. 1 OR  DIMEN  .LT. 1
!      FITIWK  -- (INTEGER, 1-SUBSCRIPT ARRAY) -- (PASSED)
!         THE INTEGER WORK ARRAY OF LENGTH  FIWKLN  THAT WAS  USED  IN
!          MFIT .
!      FITDWK  -- (REAL 2-SUBSCRIPT ARRAY) -- (PASSED)
!         THE REAL WORK ARRAY OF LENGTH  FDWKLN  THAT WAS
!         USED IN  MFIT .
!      FIWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF  FITIWK .
!      FDWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF  FITDWK .
!      TEMP    -- (REAL 1-SUBSCRIPT ARRAY)
!         A WORK ARRAY OF LENGTH  DIMEN  (OR LONGER).
!
!     THE SUBROUTINE  MEVAL1  IS CALLED TO DO THE ACTUAL EVALUATION.
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
!
!     ***************
!     SET UP INDEX POINTERS TO THE BEGINNING OF EACH ROW OF
!     THE MTABLE -- THIS SETS THE BEGINNING POINT FOR EACH
!     FULL MULTINOMIAL DEGREE.
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
!     THE ACTUAL EVALUATION IS DONE INSIDE  MEVAL1.
!     ***************
!
call meval1 (evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
&fitdwk(alfstt),fitiwk,fitdwk(psistt), &
&evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!
!     ***************
!     ERROR RETURN
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
!     PURPOSE
!     -------
!
!     THIS SUBROUTINE PERFORMS THE MAIN WORK OF EVALUATING THE
!     FITTING MULTINOMIAL (OR THE INITIAL PORTION OF IT  WHICH
!     IS REQUESTED BY THE SETTING OF  NEPOLS ,  EVLDEG  IN THE
!     CALL TO SUBROUTINE  MEVAL .
!
!     THIS SUBROUTINE IS CALLED BY  MEVAL .  IT IS  NOT  CALLED
!     DIRECTLY BY THE USER.
!
!     THE BODY OF THIS SUBROUTINE FOLLOWS THE EXPLANATION
!     GIVEN IN
!          LEAST SQUARES FITTING USING
!          ORTHOGONAL MULTINOMIALS
!     BY
!          BARTELS AND JEZIORANSKI
!     IN
!          ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE
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
!     SCALE THE COORDINATES OF THE P-TH POINT
!     ***************
!
   do k = 1,dimen
        x(k) = coord(p,k)
        if (maxabs(k) .ne. 0.0) x(k) = x(k) / maxabs(k)
   end do
!
!     ***************
!     USE THE  BASIS FUNCTION COEFFICIENTS  C  AND RECURRENCE
!     COEFFICIENTS  ALPHA  TO EVALUATE THE FITTED MULTINOMIAL
!     AT THE P-TH POINT.
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
!     COMPUTE THE DEGREE 0 POLYNOMIAL
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
!     PURPOSE
!     -------
!
!     THIS SUBROUTINE CONSTRUCTS A LEAST-SQUARES  MULTINOMIAL  FIT  TO
!     GIVEN DATA USING A BASIS OF ORTHOGONAL MULTINOMIALS. THE COMPUTA-
!     TION IS PERFORMED IN DOUBLE PRECISION.
!
!     THE DATA FOR THE FIT IS GIVEN IN THE ARRAYS FITCDS, FITVLS, AND
!     WTS. FITCDS IS A MATRIX, EACH ROW OF WHICH CONTAINS AN OBSERVA-
!     TION POINT. FITVLS IS A SINGLY-INDEXED ARRAY, EACH ELEMENT OF
!     WHICH CONTAINS A FUNCTION VALUE CORRESPONDING TO AN OBSERVATION
!     POINT. WTS IS A SINGLY-INDEXED ARRAY, EACH ELEMENT OF WHICH IS
!     A NONNEGATIVE WEIGHT FOR THE CORRESPONDING OBSERVATION.
!
!     THE FIT WHICH IS PRODUCED IS A MULTINOMIAL EXPRESSED IN THE FORM
!
!      C  PSI  (X ,...,X     ) +...+ C       PSI       (X ,...,X     )
!       1    1   1      DIMEN         NFPOLS    NFPOLS   1      DIMEN
!
!     WHERE THE VALUE OF  NFPOLS  WILL BE AS GIVEN (IF  FITDEG .LT. 0)
!     OR  AS  COMPUTED  BY  DMFIT  TO GIVE A FULL-DEGREE FIT (IN CASE
!     FITDEG  IS SPECIFIED .GE. 0).  THE ELEMENTS
!
!         PSI  (X ,...,X     )
!            K   1      DIMEN
!
!     FORM A BASIS FOR THE MULTINOMIALS WHICH IS ORTHOGONAL WITH
!     RESPECT TO THE WEIGHTS AND OBSERVATION POINTS.
!
!     THE EXTENT OF THE FIT CAN BE SPECIFIED IN ONE OF TWO WAYS.
!         IF THE PARAMETER FITDEG IS SET .GE. 0, THEN A COMPLETE BASIS
!         FOR THE MULTINOMIALS OF DEGREE =  FITDEG  WILL BE USED.  (AN
!         ERROR WILL BE  FLAGGED  IF  THIS  WILL  REQUIRE  MORE  BASIS
!         MULTINOMIALS  THAN  THE  NUMBER  OF  DATA  POINTS WHICH WERE
!         GIVEN.)
!         IF THE PARAMETER  FITDEG  IS .LT.  0, THEN  NFPOLS  WILL  BE
!         TAKEN AS THE COUNT OF THE NUMBER OF BASIS MULTINOMIALS TO BE
!         USED FOR A PARTIAL-DEGREE FIT.  (AN ERROR WILL BE FLAGGED IF
!         NFPOLS  .LT. 0.)
!
!     VARIABLES
!     ---------
!
!      DIMEN  -- (INTEGER) -- (PASSED)
!         THE NUMBER OF VARIABLES.
!      FITDEG  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF .LT. 0.
!         IF FITDEG .GE. 0 THEN  FITDEG  IS  CHECKED  AGAINST  NFPTS .
!         THE VALUE OF  FITDEG  WILL BE REDUCED IF THERE IS A BASIS OF
!         MULTINOMIALS, ALL OF  DEGREE  .LE. FITDEG ,  OF  CARDINALITY
!         NFPTS .  SEE  ERROR  BELOW.
!      NFPOLS  - (INTEGER) -- (PASSED/RETURNED)
!         IGNORED IF  FITDEG  .GE. 0.
!         IF  FITDEG .LT. 0 THEN THE VALUE OF NFPOLS WILL BE TAKEN  AS
!         THE SIZE OF THE BASIS OF MULTINOMIALS TO BE USED IN THE FIT.
!         NFPOLS  MUST SATISFY  NFPOLS  .LT. NFPTS  AND NFPOLS .GE. 1
!         SEE  ERROR  BELOW.
!      NFPTS  --- (INTEGER) -- (PASSED)
!         THE NUMBER OF DATA POINTS TO BE USED IN THE FIT.
!         NFPTS  MUST BE .GE. 1.  SEE  ERROR  BELOW.
!      FITCDS  -- (DOUBLE PRECISION 2-SUBSCRIPT ARRAY) -- (PASSED)
!         FITCDS (P,K) IS THE VALUE OF THE K-TH VARIABLE AT THE  P-TH
!         DATA POINT.
!      NCROWS  -- (INTEGER) -- (PASSED)
!         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!         PROGRAM.
!      FITVLS  -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY) -- (PASSED)
!         FITVLS (P) IS THE OBSERVED FUNCTION VALUE OF THE P-TH  DATA
!         POINT.
!      WTS  ----- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY) -- (PASSED)
!         WTS (P) IS THE WEIGHT ATTACHED TO THE P-TH DATA POINT.
!      RESIDS  -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY) -- (RETURNED)
!         RESIDS (P) IS THE DIFFERENCE BETWEEN THE FITTED FUNCTION AT
!         POINT P AND  FITVLS (P).
!      ERROR  -- (INTEGER) -- (RETURNED)
!       0 THE DESIRED LEAST SQUARE MULTINOMIAL FIT WAS OBTAINED.
!      -1 ONLY THE FIRST NFPOLS BASIS POLYNOMIALS WERE OBTAINED.
!         FITDEG IS THE DEGREE OF THE FIT.
!       1 IF  FITDEG  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
!         OF SMALLER DEGREE OR IF FITDEG .LT. 0 AND NFPOLS .GT. NFPTS.
!       2 IF  FITDEG  .LT. 0 AND  NFPOLS  .LE. 0.
!       3 IF  NFPTS  .LT. 1 AND/OR  DIMEN  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         THE VALUE RETURNED IN  IREQD , AND SET  DWKLEN  TO THE VALUE
!         RETURNED IN  DREQD  TO RESOLVE THIS PROBLEM.)
!      FITIWK  -- (INTEGER, 1-SUBSCRIPT ARRAY) -- (RETURNED)
!         AN INTEGER WORK ARRAY OF LENGTH  FIWKLN .  UPON RETURN  FROM
!         DMFIT, FITIWK CONTAINS DIMENSION AND ARRAY LENGTH INFORMATION.
!      FITDWK  -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY) -- (RETURNED)
!         AN ARRAY OF LENGTH  FDWKLN  CONTAINING THE COEFFICIENTS
!         NEEDED FOR COMPUTING THE MULTINOMIAL FIT AT A POINT.
!      FIWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF THE ARRAY  FITIWK .
!      FDWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF THE ARRAY  FITDWK .
!      IREQD  -- (INTEGER) -- (RETURNED)
!         THE LENGTH WHICH THE ARRAY  FITIWK  REALLY NEEDS TO BE.
!      DREQD  -- (INTEGER) -- (RETURNED)
!         THE LENGTH WHICH THE ARRAY  FITDWK  REALLY NEEDS TO BE.
!
!
!     NOTE. THE 20 LOOP DEPENDS ON THE SCALING SCHEME BEING USED. THE
!     RESIDUAL SCALING MUST BE CONSISTENT WITH THAT DEFINED BY DSCALP
!     AND DSCALD.
!
!     DMFIT  CALLS  ALLOT  AND  DGNRTP.
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
!     STORE THE NUMBER OF BASIS POLYNOMIALS ACTUALLY COMPUTED
!     BY THE MODIFIED ROUTINE DINCDG CALLED BY DGNRTP.
!     ***************
!
fitiwk(1) = nfpols
!
!     ***************
!     UNSCALE THE RESIDUALS FOR THE BENEFIT OF THE USER.
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
!     PURPOSE
!     -------
!
!     THE MULTINOMIAL FIT IS GENERATED INCREMENTALLY, A BASIS  ELEMENT
!     AT A TIME.  THIS SUBROUTINE STARTS THE PROCESS OFF BY SETTING UP
!     THE FIRST BASIS ELEMENT, SCALING THE  DATA,  FINDING  THE  FIRST
!     COEFFICIENT,  AND  INITIALIZING  THE  WORK ARRAY Z.  DGNRTP THEN
!     CALLS  DINCDG  IF MORE THAN ONE BASIS ELEMENT IS REQUIRED.
!
!     THIS SUBROUTINE IS CALLED BY  DMFIT .  IT IS NOT CALLED BY  THE
!     USER.
!
!     THIS SUBROUTINE CALLS  DSCALP ,  DSCALD , AND  DINCDG .
!
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!     ****************
!
!     ***************
!     SET UP THE SCALING.
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
!     PURPOSE
!     -------
!
!     THE MULTINOMIAL FIT IS GENERATED INCREMENTALLY, A BASIS  ELEMENT
!     AT A TIME.  THIS SUBROUTINE CONTINUES THE PROCESS STARTED OFF BY
!      DGNRTP .
!
!     THIS SUBROUTINE IS CALLED BY  DGNRTP  AND NOT BY THE USER.
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
!     CALCULATE THOSE  ALPHA ( J , M ) THAT CAN BE CALCULATED FROM
!     PREVIOUSLY CALCULATED ALPHAS.
!     ***************
!
   if ( kj .lt. kjp ) go to 50
!
!     ***************
!     FIRST CALCULATE THOSE BETWEEN  JPP  AND THE END OF 2 ROWS BACK.
!     CALCULATE  ALPHA ( J , JPP )
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
!     PREVIOUS AND 8-TH PREVIOUS STATEMENTS.
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
!     CALCULATE  ALPHA ( J , M ) FOR  M  BETWEEN THE 2
!     RANGES CALCULATED BEFORE USING
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
!     CALCULATE  ALPHA ( J , M ) FOR  M  BETWEEN
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
!     CALCULATE THE REMAINING  ALPHA ( J , M ) FROM
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
!     NOW CALCULATE THE  PSI (P,J),  SUMSQS (J) AND  C (J) USING
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
!     CALCULATE THE NEW  Z ( P ) AND THE NEW  SSRES  USING
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
!     THE J-TH BASIS MULTINOMIAL CANNOT BE COMPUTED ACCURATELY.
!     ONLY J - 1 BASIS MULTINOMIALS ARE GENERATED.
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
!     PURPOSE
!     -------
!
!     FIND SCALING PARAMETER(S) FOR THE PROBLEM. IF THE SCALING SCHEME
!     IS CHANGED, ALL FOUR OF THE FOLLOWING WOULD HAVE TO BE CHANGED
!
!     1)  DSCALP  - FIND THE SCALING PARAMETERS
!     2)  DSCALD  - SCALE THE PROBLEM DATA
!     3)  THE SCALING OF THE RESIDUALS IN  DMFIT
!     4)  THE SCALING PERFORMED IN  DMEVL1
!
!     THIS SUBROUTINE IS CALLED BY  DGNRTP .  IT IS NOT CALLED  BY  THE
!     USER.
!
!     THE SCALING WHICH  IT  DEFINES  MUST  BE  COORDINATED  WITH  THE
!     SCALING  OF RESIDUALS WHICH IS CARRIED OUT TOWARD THE END OF THE
!     SUBROUTINE  DMFIT.  THE SCALING MUST ALSO BE COORDINATED WITH THE
!     SCALING PERFORMED IN THE 10 LOOP  AND  AT STATEMENTS 40 AND 50
!     (WITH THE SCALE FACTOR MAXABS(DIMP1)) IN  DMEVL1.
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
!     PURPOSE
!     -------
!
!     CARRY OUT THE DATA-SCALING WHICH IS DEFINED  BY  THE SUBROUTINE
!     DSCALP .
!
!     THIS SUBROUTINE IS CALLED BY  DGNRTP .  IT IS NOT CALLED BY THE
!     USER.
!
!     THE SCALING WHICH THIS ROUTINE CARRIES OUT MUST  BE  CONSISTENT
!     WITH THE SCALING IN THE SUBROUTINES DMFIT AND DMEVL1.
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
!     PURPOSE
!     -------
!
!     THIS SUBROUTINE  EVALUATES  THE  LEAST-SQUARES  MULTINOMIAL  FIT
!     WHICH HAS BEEN PREVIOUSLY PRODUCED BY  DMFIT .  THE COMPUTATION
!     IS PERFORMED IN DOUBLE PRECISION. EITHER THE FULL
!     MULTINOMIAL AS PRODUCED MAY BE EVALUATED,  OR  ONLY  AN  INITIAL
!     SEGMENT THEREOF.  AS IN THE CASE WITH  DMFIT , IT IS POSSIBLE
!     (1) TO SPECIFY MULTINOMIALS OF A FULL GIVEN DEGREE, OR
!     (2) TO SPECIFY  THE  NUMBER  OF  ORTHOGONAL  BASIS  ELEMENTS  TO
!         ACHIEVE A PARTIAL-DEGREE FIT.
!
!     IN CASE (1), THE  DESIRED  DEGREE  IS  GIVEN  AS  THE  VALUE  OF
!     EVLDEG   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     VALUE USED FOR  FITDEG  IN  DMFIT ), AND THE PARAMETER  NEPOLS
!     WILL BE SET  BY  DMEVAL  TO SPECIFY THE NUMBER OF BASIS ELEMENTS
!     REQUIRED. IF  EVLDEG  .LT.  FITDEG   IS  GIVEN,  THEN  ONLY  THE
!     INITIAL  PORTION OF THE FITTING MULTINOMIAL (OF DEGREE  EVLDEG )
!     WILL BE EVALUATED.
!
!     IN CASE (2),  EVLDEG  IS TO BE SET NEGATIVE, IN WHICH  CASE  THE
!     VALUE  OF   NEPOLS  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   DMFIT )  WILL  BE  TAKEN  AS
!     DEFINING  THE  INITIAL  PORTION OF THE FITTING MULTINOMIAL TO BE
!     EVALUATED.
!
!     IF  NEPOLS  =  NFPOLS  (WITH  EVLDEG  .LT.  0),  OR   EVLDEG   =
!     FITDEG  (WITH   EVLDEG   .GT.  0),  THEN  THE  FULL  MULTINOMIAL
!     GENERATED BY  DMFIT  WILL BE EVALUATED.
!
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (COLLECTION  OF  VARIABLE  VALUES)  GIVEN AS A ROW OF THE MATRIX
!      EVLCDS .  THE  VALUES  PRODUCED  FROM  THE  FULL,  OR  PARTIAL,
!     MULTINOMIAL WILL BE PLACED IN THE ARRAY  EVLVLS .
!
!     VARIABLES
!     ---------
!
!      DIMEN  -- (INTEGER) -- (PASSED)
!         THE NUMBER OF VARIABLES.
!      EVLDEG  -- (INTEGER) -- (PASSED)
!         IF  EVLDEG  .LT. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF  EVLDEG  .GE. 0, THEN THE VALUE OF  EVLDEG  MUST  SATISFY
!         EVLDEG  .LE. (THE  DEGREE  OF THE APPROXIMATING MULTINOMIAL
!         GENERATED IN  DMFIT ).  IN THIS CASE  EVLDEG  WILL  SPECIFY
!         THE DEGREE OF THE INITIAL PORTION OF THE FITTING MULTINOMIAL
!         TO BE EVALUATED.
!      NEPOLS  -- (INTEGER) -- (PASSED/RETURNED)
!         IF  EVLDEG  .GE. 0, THEN THIS PARAMETER WILL BE IGNORED.
!         IF EVLDEG .LT. 0, THEN THE PARTIAL MULTINOMIAL INVOLVING THE
!         FIRST   NEPOLS  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         AT THE POINTS GIVEN BY  EVLCDS .  THE RESULTING VALUES  WILL
!         BE STORED IN  EVLVLS .
!         THE VALUE OF NEPOLS MUST BE .GE. 1 AND .LE. (THE SIZE OF THE
!         BASIS  GENERATED  IN   DMFIT ),  WHICH  WAS RETURNED AS THE
!         VALUE OF  NFPOLS .
!         NEPOLS  WILL BE CHANGED IF EVLDEG .GT. 0 TO GIVE THE SIZE OF
!         BASIS REQUIRED FOR THE MULTINOMIAL OF DEGREE  EVLDEG .
!      NEPTS  -- (INTEGER) -- (PASSED)
!         THE NUMBER OF EVALUATION POINTS.
!      EVLCDS  -- (DOUBLE PRECISION 2-SUBSCRIPT ARRAY) -- (PASSED)
!         EVLCDS (P,K) IS THE VALUE OF THE K-TH VARIABLE AT THE  P-TH
!         EVALUATION POINT.
!      NEROWS  -- (INTEGER) -- (PASSED)
!         THE ROW DIMENSION DECLARED FOR EVLCDS IN THE CALLING PROGRAM.
!      EVLVLS  -- (INTEGER) -- (RETURNED)
!         EVLVLS (P) IS THE VALUE OF THE EVALUATED MULTINOMIAL AT THE
!         P-TH EVALUATION POINT.
!      ERROR  -- (INTEGER) -- (RETURNED)
!          0 .........  IF NO ERRORS
!         -1 .........  IF  NEPOLS  .GT.  NFPOLS  OR  NEPOLS  .LT. 1
!         -2 .........  IF  NEPTS  .LT. 1 OR  DIMEN  .LT. 1
!      FITIWK  -- (INTEGER, 1-SUBSCRIPT ARRAY) -- (PASSED)
!         THE INTEGER WORK ARRAY OF LENGTH  FIWKLN  THAT WAS  USED  IN
!          DMFIT .
!      FITDWK  -- (DOUBLE PRECISION 2-SUBSCRIPT ARRAY) -- (PASSED)
!         THE REAL WORK ARRAY OF LENGTH  FDWKLN  THAT WAS
!         USED IN  DMFIT .
!      FIWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF  FITIWK .
!      FDWKLN  -- (INTEGER) -- (PASSED)
!         THE LENGTH OF  FITDWK .
!      TEMP    -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY)
!         A WORK ARRAY OF LENGTH  DIMEN  (OR LONGER).
!
!     THE SUBROUTINE  DMEVL1  IS CALLED TO DO THE ACTUAL EVALUATION.
!
!     MODIFIED BY A.H. MORRIS (NSWC)
!
!     ****************
!
!
!     ***************
!     SET UP INDEX POINTERS TO THE BEGINNING OF EACH ROW OF
!     THE MTABLE -- THIS SETS THE BEGINNING POINT FOR EACH
!     FULL MULTINOMIAL DEGREE.
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
!     THE ACTUAL EVALUATION IS DONE INSIDE  DMEVL1.
!     ***************
!
call dmevl1 (evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
&fitdwk(alfstt),fitiwk,fitdwk(psistt), &
&evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!
!     ***************
!     ERROR RETURN
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
!     PURPOSE
!     -------
!
!     THIS SUBROUTINE PERFORMS THE MAIN WORK OF EVALUATING THE
!     FITTING MULTINOMIAL (OR THE INITIAL PORTION OF IT  WHICH
!     IS REQUESTED BY THE SETTING OF  NEPOLS ,  EVLDEG  IN THE
!     CALL TO SUBROUTINE  DMEVAL .
!
!     THIS SUBROUTINE IS CALLED BY  DMEVAL .  IT IS  NOT  CALLED
!     DIRECTLY BY THE USER.
!
!     THE BODY OF THIS SUBROUTINE FOLLOWS THE EXPLANATION
!     GIVEN IN
!          LEAST SQUARES FITTING USING
!          ORTHOGONAL MULTINOMIALS
!     BY
!          BARTELS AND JEZIORANSKI
!     IN
!          ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE
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
!     SCALE THE COORDINATES OF THE P-TH POINT
!     ***************
!
   do k = 1,dimen
        x(k) = coord(p,k)
        if (maxabs(k) .ne. 0.d0) x(k) = x(k) / maxabs(k)
   end do
!
!     ***************
!     USE THE  BASIS FUNCTION COEFFICIENTS  C  AND RECURRENCE
!     COEFFICIENTS  ALPHA  TO EVALUATE THE FITTED MULTINOMIAL
!     AT THE P-TH POINT.
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
!     COMPUTE THE DEGREE 0 POLYNOMIAL
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
!                INTEGRATION OVER A FINITE INTERVAL
!
!                          ----------
!
!     QSUBA COMPUTES THE INTEGRAL OF F(X) FROM A TO B WHERE THE
!     RELATIVE ERROR DOES NOT EXCEED EPSIL.
!
!     MCOUNT IS THE MAXIMUM NUMBER OF POINTS AT WHICH F(X) MAY BE
!     EVALUATED.
!
!     RELERR IS A VARIABLE. WHEN QSUBA TERMINATES, IF THE VALUE
!     OF THE INTEGRAL IS NONZERO THEN RELERR IS A CRUDE ESTIMATE
!     OF THE RELATIVE ERROR OF THE VALUE. OTHERWISE, IF QSUBA = 0
!     THEN RELERR IS AN ESTIMATE OF THE ABSOLUTE ERROR.
!
!     IND IS A VARIABLE. WHEN QSUBA TERMINATES, IND HAS ONE OF THE
!     FOLLOWING VALUES ...
!
!     IND=0   QSUBA IS SATISFIED THAT THE INTEGRAL HAS BEEN
!             COMPUTED TO THE DESIRED ACCURACY.
!     IND=1   THE INTEGRAL HAS BEEN COMPUTED, BUT QSUBA IS
!             NOT CERTAIN OF THE ACCURACY OF THE RESULT.
!     IND=2   THE INTEGRAND HAS BEEN EVALUATED AT MCOUNT
!             POINTS. IF MORE EVALUATIONS ARE NEEDED THEN
!             QSUBA TERMINATES.
!     IND=3   QSUBA CANNOT COMPUTE THE INTEGRAL TO THE DESIRED
!             ACCURACY. IND IS SET TO 3 WHENEVER THE STACK OF
!             INTERVALS BECOMES FULL (IT CURRENTLY CAN HOLD 50
!             INTERVALS). A RESULT IS OBTAINED BY CONTINUING
!             THE INTEGRATION IGNORING CONVERGENCE FAILURES
!             WHICH CANNOT BE ACCOMMODATED ON THE STACK.
!
!     THE RELIABILITY OF THE ALGORITHM DECREASES FOR LARGE VALUES
!     OF EPSIL. IT IS RECOMMENDED THAT EPSIL BE LESS THAN 0.001.
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
!     APPLY QUAD TO THE ENTIRE INTERVAL
!
sub1 = amin1(a,b)
sub3 = amax1(a,b)
tol = amax1(epsil, 10.0*eps)
call quad (sub1, sub3, result, k, tol, npts, icheck, f)
if (icheck .eq. 0) go to 100
is = 1
!
!     SUBDIVIDE THE INTERVAL (SUB1,SUB3) INTO THE SUBINTERVALS
!     (SUB1,SUB2) AND (SUB2,SUB3). CALL QUAD FOR (SUB1,SUB2).
!
10 if (npts .ge. mcount) go to 110
sub2 = 0.5*(sub1 + sub3)
call quad (sub1, sub2, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k-1))
sum = qsuba + result(k)
if (icheck .eq. 0 .or. err .le. abs(tol*sum)) go to 30
!
!        STACK THE SUBINTERVAL (SUB1,SUB2) FOR FURTHER
!        EXAMINATION IF THERE IS SUFFICIENT STORAGE.
!
   if (is .ge. ismax) go to 20
      stack(is) = sub1
      is = is + 1
      stack(is) = sub2
      is = is + 1
      go to 40
20 ind = 3
!
!     UPDATE QSUBA AND CHECK IF ANY SIGNIFICANT DIGITS ARE LOST
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
!        SUBDIVIDE THE INTERVAL (SUB2,SUB3)
!
   sub1 = sub2
   go to 10
!
!     UPDATE QSUBA AND CHECK IF ANY SIGNIFICANT DIGITS ARE LOST
!
50 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind .ne. 0 .or. x*result(k) .ge. 0.0) go to 60
x = 0.1*amin1(abs(x),abs(result(k)))
if (abs(qsuba) .le. x) ind = 1
!
!     SUBDIVIDE THE INTERVAL LAST STACKED
!
60 if (is .eq. 1) go to 120
is = is - 1
sub3 = stack(is)
is = is - 1
sub1 = stack(is)
go to 10
!
!     TERMINATION WHEN SUBDIVISION IS NOT NEEDED
!
100 qsuba = result(k)
if (a .gt. b) qsuba = -qsuba
relerr = abs(result(k) - result(k-1))
if (qsuba .ne. 0.0) relerr = relerr/abs(qsuba)
return
!
!     SUBDIVISION RESULT
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
! THIS SUBROUTINE ATTEMPTS TO CALCULATE THE INTEGRAL OF F(X)
! OVER THE INTERVAL *A* TO *B* WITH RELATIVE ERROR NOT
! EXCEEDING *EPSIL*.
! THE RESULT IS OBTAINED USING A SEQUENCE OF 1,3,7,15,31,63,
! 127, AND 255 POINT INTERLACING FORMULAE(NO INTEGRAND
! EVALUATIONS ARE WASTED) OF RESPECTIVE DEGREE 1,5,11,23,
! 47,95,191 AND 383. THE FORMULAE ARE BASED ON THE OPTIMAL
! EXTENSION OF THE 3-POINT GAUSS FORMULA.  DETAILS OF
! THE FORMULAE ARE GIVEN IN *THE OPTIMUM ADDITION OF POINTS
! TO QUADRATURE FORMULAE* BY T.N.L. PATTERSON,MATHS.COMP.
! VOL 22,847-856,1968.
!                     *** INPUT ***
! A       LOWER LIMIT OF INTEGRATION.
! B       UPPER LIMIT OF INTEGRATION.
! EPSIL   RELATIVE ACCURACY REQUIRED. WHEN THE RELATIVE
!         DIFFERENCE OF TWO SUCCESSIVE FORMULAE DOES NOT
!         EXCEED *EPSIL* THE LAST FORMULA COMPUTED IS TAKEN
!         AS THE RESULT.
! F       F(X) IS THE INTEGRAND.
!                     *** OUTPUT ***
! RESULT  THIS ARRAY,WHICH SHOULD BE DECLARED TO HAVE AT
!         LEAST 8 ELEMENTS, HOLDS THE RESULTS OBTAINED BY
!         THE 1,3,7, ETC., POINT FORMULAE. THE NUMBER OF
!         FORMULAE COMPUTED DEPENTS ON *EPSIL*.
! K       RESULT(K) HOLDS THE VALUE OF THE INTEGRAL TO THE
!         SPECIFIED RELATIVE ACCURACY.
! NPTS    NUMBER INTEGRAND EVALUATIONS.
! ICHECK  ON EXIT NORMALLY ICHECK=0. HOWEVER IF CONVERGENCE
!         TO THE ACCURACY REQUESTED IS NOT ACHIEVED ICHECK=1
!         ON EXIT.
! ABSCISSAE AND WEIGHTS OF QUADRATURE RULES ARE STACKED IN
! ARRAY *P* IN THE ORDER IN WHICH THEY ARE NEEDED.
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
! CHECK FOR TRIVIAL CASE.
if (a.eq.b) go to 70
! SCALE FACTORS.
sum = (b+a)/2.0
diff = (b-a)/2.0
! 1-POINT GAUSS
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
! CONTRIBUTION FROM FUNCTION VALUES ALREADY COMPUTED.
do 20 j = 1,iold
  i = i + 1
  acum = acum + p(i)*funct(j)
20 continue
! CONTRIBUTION FROM NEW FUNCTION VALUES.
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
! CHECK FOR CONVERGENCE.
if (abs(result(k)-result(k-1))-epsil*abs(result(k))) 60, &
&60, 10
! CONVERGENCE NOT ACHIEVED.
50 icheck = 1
! NORMAL TERMINATION.
60 npts = inew + iold
return
! TRIVIAL CASE
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
!                 COMPUTATION OF A DEFINITE INTEGRAL
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            A      - REAL
!                     LOWER LIMIT OF INTEGRATION
!
!            B      - REAL
!                     UPPER LIMIT OF INTEGRATION
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             THE ESTIMATES FOR INTEGRAL AND ERROR ARE
!                             LESS RELIABLE. IT IS ASSUMED THAT THE
!                             REQUESTED ACCURACY HAS NOT BEEN ACHIEVED.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE SUB-
!                             DIVISIONS BY INCREASING THE VALUE OF
!                             LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A
!                             LOCAL DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE SUB-
!                             RANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             TED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             OCCURS AT SOME  POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             IT IS PRESUMED THAT THE REQUESTED
!                             TOLERANCE CANNOT BE ACHIEVED, AND THAT THE
!                             RETURNED RESULT IS THE BEST WHICH CAN BE
!                             OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED
!                             THAT DIVERGENCE CAN OCCUR WITH ANY OTHER
!                             VALUE OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             RESULT, ABSERR, NEVAL, LAST ARE
!                             SET TO ZERO.
!
!         DIMENSIONING PARAMETERS
!            LIMIT - INTEGER
!                    DIMENSIONING PARAMETER FOR IWORK
!                    LIMIT DETERMINES THE MAXIMUM NUMBER
!                    OF SUBINTERVALS IN THE PARTITION OF THE GIVEN
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    DIMENSIONING PARAMETER FOR WORK
!                    LENW MUST BE AT LEAST LIMIT*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LAST  - INTEGER
!                    ON RETURN, LAST EQUALS THE NUMBER OF
!                    SUBINTERVALS PRODUCED IN THE SUBDIVISION
!                    PROCESS, WHICH DETERMINES THE NUMBER OF
!                    SIGNIFICANT ELEMENTS ACTUALLY IN THE WORK
!                    ARRAYS.
!
!         WORK ARRAYS
!            IWORK - INTEGER
!                    VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST K
!                    ELEMENTS OF WHICH CONTAIN POINTERS
!                    TO THE ERROR ESTIMATES OVER THE SUBINTERVALS
!                    SUCH THAT WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) FORM A DECREASING
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            WORK  - REAL
!                    VECTOR OF DIMENSION AT LEAST LENW
!                    ON RETURN
!                    WORK(1), ..., WORK(LAST) CONTAIN THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     PARTITION OF (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) CONTAIN
!                     THE RIGHT END POINTS,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     CONTAIN THE INTEGRAL APPROXIMATIONS OVER
!                     THE SUBINTERVALS,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     CONTAIN THE ERROR ESTIMATES.
!
!         SUBROUTINES OR FUNCTIONS NEEDED
!              - QAGSE
!              - QK21F
!              - QPSRT
!              - QELG
!              - F (USER-PROVIDED FUNCTION)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
!
!         CHECK VALIDITY OF LIMIT AND LENW.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         PREPARE CALL FOR QAGSE.
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
!                 COMPUTATION OF A DEFINITE INTEGRAL
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            A      - REAL
!                     LOWER LIMIT OF INTEGRATION
!
!            B      - REAL
!                     UPPER LIMIT OF INTEGRATION
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!            LIMIT  - INTEGER
!                     GIVES AN UPPERBOUND ON THE NUMBER OF
!                     SUBINTERVALS IN THE PARTITION OF (A,B)
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             THE ESTIMATES FOR INTEGRAL AND ERROR ARE
!                             LESS RELIABLE. IT IS ASSUMED THAT THE
!                             REQUESTED ACCURACY HAS NOT BEEN ACHIEVED.
!
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE SUB-
!                             DIVISIONS BY INCREASING THE VALUE OF
!                             LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A
!                             LOCAL DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE SUB-
!                             RANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             TED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             OCCURS AT SOME  POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             IT IS PRESUMED THAT THE REQUESTED
!                             TOLERANCE CANNOT BE ACHIEVED, AND THAT THE
!                             RETURNED RESULT IS THE BEST WHICH CAN BE
!                             OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED
!                             THAT DIVERGENCE CAN OCCUR WITH ANY OTHER
!                             VALUE OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE.
!                             RESULT, ABSERR, NEVAL, LAST, RLIST(1),
!                             IORD(1) AND ELIST(1) ARE SET TO ZERO.
!                             ALIST(1) AND BLIST(1) ARE SET TO A AND B
!                             RESPECTIVELY.
!
!            ALIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE GIVEN INTEGRATION RANGE (A,B)
!
!            BLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE RIGHT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE GIVEN INTEGRATION RANGE (A,B)
!
!            RLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE INTEGRAL
!                     APPROXIMATIONS ON THE SUBINTERVALS
!
!            ELIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE MODULI
!                     OF THE ABSOLUTE ERROR ESTIMATES ON THE
!                     SUBINERVALS
!
!            IORD   - INTEGER
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST K
!                     ELEMENTS OF WHICH ARE POINTERS TO THE ERROR
!                     ESTIMATES OVER THE SUBINTERVALS, SUCH
!                     THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     OTHERWISE
!
!            LAST   - INTEGER
!                     NUMBER OF SUBINTERVALS ACTUALLY PRODUCED IN THE
!                     SUBDIVISION PROCESS
!
!         SUBROUTINES OR FUNCTIONS NEEDED
!              - QK21F
!              - QPSRT
!              - QELG
!              - F (USER-PROVIDED FUNCTION)
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
!            THE DIMENSION OF RLIST2 IS DETERMINED BY THE VALUE OF
!            LIMEXP IN SUBROUTINE QELG (RLIST2 SHOULD BE OF DIMENSION
!            (LIMEXP+2) AT LEAST).
!
!            LIST OF MAJOR VARIABLES
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           RLIST(I)  - APPROXIMATION TO THE INTEGRAL OVER
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST LIMEXP+2
!                       CONTAINING THE PART OF THE EPSILON TABLE
!                       WHICH IS STILL NEEDED FOR FURTHER COMPUTATIONS
!           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       ESTIMATE
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (BEFORE THAT SUBDIVISION HAS TAKEN PLACE)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT INTERVAL
!           *****2    - VARIABLE FOR THE RIGHT INTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       APPROPRIATE APPROXIMATION TO THE COMPOUNDED
!                       INTEGRAL HAS BEEN OBTAINED IT IS PUT IN
!                       RLIST2(NUMRL2) AFTER NUMRL2 HAS BEEN INCREASED
!                       BY ONE.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED
!                       UP TO NOW, MULTIPLIED BY 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       THAN THE SMALLEST INTERVAL CONSIDERED UP TO NOW
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       IS ATTEMPTING TO PERFORM EXTRAPOLATION
!                       I.E. BEFORE SUBDIVIDING THE SMALLEST INTERVAL
!                       WE TRY TO DECREASE THE VALUE OF ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       IS NO LONGER ALLOWED (TRUE VALUE)
!
!            MACHINE DEPENDENT CONSTANTS
!            ---------------------------
!
!           EPMACH IS THE LARGEST RELATIVE SPACING.
!           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
!           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!            CHECK EPSABS AND EPSREL
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
!           FIRST APPROXIMATION TO THE INTEGRAL
!           -----------------------------------
!
ierro = 0
call qk21f (f, a, b, result, abserr, defabs, resabs, &
&epmach, uflow, id)
if (id .ne. 0) go to 999
neval = 21
!
!           TEST ON ACCURACY.
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
!           INITIALIZATION
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
!           MAIN DO-LOOP
!           ------------
!
do 90 last = 2,limit
!
!           BISECT THE SUBINTERVAL WITH THE NRMAX-TH LARGEST
!           ERROR ESTIMATE.
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
!           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
!           AND ERROR AND TEST FOR ACCURACY.
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
!           TEST FOR ROUNDOFF ERROR AND EVENTUALLY
!           SET ERROR FLAG.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF
!           SUBINTERVALS EQUALS LIMIT.
!
  if (last .eq. limit) ier = 1
!
!           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
!           AT A POINT OF THE INTEGRATION RANGE.
!
  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
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
!           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
!           SUBINTERVAL WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE
!           BISECTED NEXT).
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
!           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
!           SMALLEST INTERVAL.
!
  if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
!           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS
!           OVER THE LARGER INTERVALS (ERLARG) AND PERFORM
!           EXTRAPOLATION.
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
!           PERFORM EXTRAPOLATION.
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
!           PREPARE BISECTION OF THE SMALLEST INTERVAL.
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
!           SET FINAL RESULT AND ERROR ESTIMATE.
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
!           TEST ON DIVERGENCE.
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
&defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
&.or. errsum .gt. abs(area)) ier = 6
go to 130
!
!           COMPUTE GLOBAL INTEGRAL SUM.
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
!                             ESTIMATE
!                         J = INTEGRAL OF ABS(F) OVER (A,B)
!
! 2.        PARAMETERS
!            ON ENTRY
!              F      - REAL
!                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       TO BE DECLARED E X T E R N A L IN THE
!                       CALLING PROGRAM.
!
!              A      - REAL
!                       LOWER LIMIT OF INTEGRATION
!
!              B      - REAL
!                       UPPER LIMIT OF INTEGRATION
!
!              EPMACH - REAL
!                       THE RELATIVE PRECISION OF THE FLOATING
!                       ARITHMETIC BEING USED.
!
!              UFLOW  - REAL
!                       THE SMALLEST POSITIVE MAGNITUDE.
!
!            ON RETURN
!              RESULT - REAL
!                       APPROXIMATION TO THE INTEGRAL I
!                       RESULT IS COMPUTED BY APPLYING THE 21-POINT
!                       KRONROD RULE (RESK) OBTAINED BY OPTIMAL
!                       ADDITION OF ABSCISSAE TO THE 10-POINT GAUSS
!                       RULE (RESG).
!
!              ABSERR - REAL
!                       ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                       WHICH SHOULD NOT EXCEED ABS(I-RESULT)
!
!              RESABS - REAL
!                       APPROXIMATION TO THE INTEGRAL J
!
!              RESASC - REAL
!                       APPROXIMATION TO THE INTEGRAL OF ABS(F-I/(B-A))
!                       OVER (A,B)
!
!              ISIG   - INTEGER
!                       ISIG=0  THE INTEGRAL WAS APPROXIMATED.
!                       ISIG=5  THE INTERVAL (A,B) IS TOO SHORT.
!                               THE INTEGRAL CANNOT BE COMPUTED.
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (USER-PROVIDED FUNCTION)
!
!-----------------------------------------------------------------------
real :: fv1(10), fv2(10), wg(5), wgk(11), xgk(11)
external f
!
!           THE ABSCISSAE AND WEIGHTS ARE GIVEN FOR THE INTERVAL (-1,1).
!           BECAUSE OF SYMMETRY ONLY THE POSITIVE ABSCISSAE AND THEIR
!           CORRESPONDING WEIGHTS ARE GIVEN.
!
!           XGK    - ABSCISSAE OF THE 21-POINT KRONROD RULE
!                    XGK(2), XGK(4), ...  ABSCISSAE OF THE 10-POINT
!                    GAUSS RULE
!                    XGK(1), XGK(3), ...  ABSCISSAE WHICH ARE OPTIMALLY
!                    ADDED TO THE 10-POINT GAUSS RULE
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
!           LIST OF MAJOR VARIABLES
!           -----------------------
!
!           CENTR  - MID POINT OF THE INTERVAL
!           HLGTH  - HALF-LENGTH OF THE INTERVAL
!           ABSC   - ABSCISSA
!           FVAL*  - FUNCTION VALUE
!           RESG   - RESULT OF THE 10-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 21-POINT KRONROD FORMULA
!           RESKH  - APPROXIMATION TO THE MEAN VALUE OF F OVER (A,B),
!                    I.E. TO I/(B-A)
!
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
dhlgth = abs(hlgth)
!
!             CHECK IF THE INTERVAL (A,B) IS TOO SHORT
!
isig = 5
absc = abs(centr) + dhlgth*0.14
if (absc .eq. abs(centr)) return
!
!           COMPUTE THE 21-POINT KRONROD APPROXIMATION TO
!           THE INTEGRAL, AND ESTIMATE THE ABSOLUTE ERROR.
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
!                   INTEGRATION OVER INFINITE INTERVALS
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            BOUND  - REAL
!                     FINITE BOUND OF INTEGRATION RANGE
!                     (HAS NO MEANING IF INTERVAL IS DOUBLY-INFINITE)
!
!            INF    - INTEGER
!                     INDICATING THE KIND OF INTEGRATION RANGE
!                     INVOLVED
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             ESTIMATES FOR RESULT AND ERROR ARE LESS
!                             RELIABLE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS NOT BEEN ACHIEVED.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE
!                             SUBDIVISIONS BY INCREASING THE VALUE
!                             OF LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A LOCAL
!                             DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE
!                             SUBRANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             DETECTED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             AT SOME POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             ROUNDOFF ERROR IS DETECTED IN THE
!                             EXTRAPOLATION TABLE.
!                             IT IS ASSUMED THAT THE REQUESTED TOLERANCE
!                             CANNOT BE ACHIEVED, AND THAT THE RETURNED
!                             RESULT IS THE BEST WHICH CAN BE OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
!                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
!                             OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             RESULT, ABSERR, NEVAL, LAST ARE
!                             SET TO ZERO.
!
!         DIMENSIONING PARAMETERS
!            LIMIT - INTEGER
!                    DIMENSIONING PARAMETER FOR IWORK
!                    LIMIT DETERMINES THE MAXIMUM NUMBER
!                    OF SUBINTERVALS IN THE PARTITION OF THE GIVEN
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    DIMENSIONING PARAMETER FOR WORK
!                    LENW MUST BE AT LEAST LIMIT*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LAST  - INTEGER
!                    ON RETURN, LAST EQUALS THE NUMBER OF
!                    SUBINTERVALS PRODUCED IN THE SUBDIVISION
!                    PROCESS, WHICH DETERMINES THE NUMBER OF SIGNIFICANT
!                    ELEMENTS ACTUALLY IN THE WORK ARRAYS.
!
!         WORK ARRAYS
!            IWORK - INTEGER
!                    VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                    K ELEMENTS OF WHICH CONTAIN POINTERS
!                    TO THE ERROR ESTIMATES OVER THE SUBINTERVALS,
!                    SUCH THAT WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) FORM A DECREASING
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            WORK  - REAL
!                    VECTOR OF DIMENSION AT LEAST LENW
!                    ON RETURN
!                    WORK(1), ..., WORK(LAST) CONTAIN THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     PARTITION OF (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) CONTAIN
!                     THE RIGHT END POINTS,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     CONTAIN THE INTEGRAL APPROXIMATIONS OVER
!                     THE SUBINTERVALS,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     CONTAIN THE ERROR ESTIMATES.
!
!        SUBROUTINES OR FUNCTIONS NEEDED
!              - QAGIE
!              - QK15I
!              - QPSRT
!              - QELG
!              - F (USER PROVIDED FUNCTION)
!              - SPMPAR
!
!-----------------------------------------------------------------------
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
!
!         CHECK VALIDITY OF LIMIT AND LENW.
!
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         PREPARE CALL FOR QAGIE.
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
!                   INTEGRATION OVER INFINITE INTERVALS
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            BOUND  - REAL
!                     FINITE BOUND OF INTEGRATION RANGE
!                     (HAS NO MEANING IF INTERVAL IS DOUBLY-INFINITE)
!
!            INF    - INTEGER
!                     INDICATING THE KIND OF INTEGRATION RANGE
!                     INVOLVED
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!            LIMIT  - INTEGER
!                     GIVES AN UPPER BOUND ON THE NUMBER OF
!                     SUBINTERVALS IN THE PARTITION OF (A,B),
!                     LIMIT.GE.1
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             ESTIMATES FOR RESULT AND ERROR ARE LESS
!                             RELIABLE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS NOT BEEN ACHIEVED.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE
!                             SUBDIVISIONS BY INCREASING THE VALUE
!                             OF LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A LOCAL
!                             DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE
!                             SUBRANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             DETECTED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             AT SOME POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             ROUNDOFF ERROR IS DETECTED IN THE
!                             EXTRAPOLATION TABLE.
!                             IT IS ASSUMED THAT THE REQUESTED TOLERANCE
!                             CANNOT BE ACHIEVED, AND THAT THE RETURNED
!                             RESULT IS THE BEST WHICH CAN BE OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
!                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
!                             OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE.
!                             RESULT, ABSERR, NEVAL, LAST, RLIST(1),
!                             ELIST(1) AND IORD(1) ARE SET TO ZERO.
!                             ALIST(1) AND BLIST(1) ARE SET TO 0
!                             AND 1 RESPECTIVELY.
!
!            ALIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE TRANSFORMED INTEGRATION RANGE (0,1).
!
!            BLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE RIGHT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE TRANSFORMED INTEGRATION RANGE (0,1).
!
!            RLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE INTEGRAL
!                     APPROXIMATIONS ON THE SUBINTERVALS
!
!            ELIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT,  THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE MODULI
!                     OF THE ABSOLUTE ERROR ESTIMATES ON THE
!                     SUBINTERVALS
!
!            IORD   - INTEGER
!                     VECTOR OF DIMENSION LIMIT, THE FIRST K
!                     ELEMENTS OF WHICH ARE POINTERS TO THE
!                     ERROR ESTIMATES OVER THE SUBINTERVALS,
!                     SUCH THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     OTHERWISE
!
!            LAST   - INTEGER
!                     NUMBER OF SUBINTERVALS ACTUALLY PRODUCED
!                     IN THE SUBDIVISION PROCESS
!
!        SUBROUTINES OR FUNCTIONS NEEDED
!              - QK15I
!              - QPSRT
!              - QELG
!              - F (USER-PROVIDED FUNCTION)
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
!            THE DIMENSION OF RLIST2 IS DETERMINED BY THE VALUE OF
!            LIMEXP IN SUBROUTINE QELG.
!
!
!            LIST OF MAJOR VARIABLES
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           RLIST(I)  - APPROXIMATION TO THE INTEGRAL OVER
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST (LIMEXP+2),
!                       CONTAINING THE PART OF THE EPSILON TABLE
!                       WICH IS STILL NEEDED FOR FURTHER COMPUTATIONS
!           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       ESTIMATE
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (BEFORE THAT SUBDIVISION HAS TAKEN PLACE)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
!           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       APPROPRIATE APPROXIMATION TO THE COMPOUNDED
!                       INTEGRAL HAS BEEN OBTAINED, IT IS PUT IN
!                       RLIST2(NUMRL2) AFTER NUMRL2 HAS BEEN INCREASED
!                       BY ONE.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED UP
!                       TO NOW, MULTIPLIED BY 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       THAN THE SMALLEST INTERVAL CONSIDERED UP TO NOW
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       IS ATTEMPTING TO PERFORM EXTRAPOLATION. I.E.
!                       BEFORE SUBDIVIDING THE SMALLEST INTERVAL WE
!                       TRY TO DECREASE THE VALUE OF ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       IS NO LONGER ALLOWED (TRUE-VALUE)
!
!            MACHINE DEPENDENT CONSTANTS
!            ---------------------------
!
!           EPMACH IS THE LARGEST RELATIVE SPACING.
!           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
!           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!           CHECK EPSABS AND EPSREL
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
!           FIRST APPROXIMATION TO THE INTEGRAL
!           -----------------------------------
!
!           DETERMINE THE INTERVAL TO BE MAPPED ONTO (0,1).
!           IF INF = 2 THE INTEGRAL IS COMPUTED AS I = I1+I2, WHERE
!           I1 = INTEGRAL OF F OVER (-INFINITY,0),
!           I2 = INTEGRAL OF F OVER (0,+INFINITY).
!
boun = bound
if (inf .eq. 2) boun = 0.0
call qk15i (f, boun, inf, 0.0, 1.0, result, abserr, &
&defabs, resabs, epmach, uflow)
!
!           TEST ON ACCURACY
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
!           INITIALIZATION
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
!           MAIN DO-LOOP
!           ------------
!
do 90 last = 2,limit
!
!           BISECT THE SUBINTERVAL WITH NRMAX-TH LARGEST
!           ERROR ESTIMATE.
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
!           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
!           AND ERROR AND TEST FOR ACCURACY.
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
!           TEST FOR ROUNDOFF ERROR AND EVENTUALLY
!           SET ERROR FLAG.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF
!           SUBINTERVALS EQUALS LIMIT.
!
  if (last .eq. limit) ier = 1
!
!           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
!           AT SOME POINTS OF THE INTEGRATION RANGE.
!

  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!
!           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
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
!           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
!           SUBINTERVAL WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE
!           BISECTED NEXT).
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
!           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
!           SMALLEST INTERVAL.
!
  if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
!           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS
!           OVER THE LARGER INTERVALS (ERLARG) AND PERFORM
!           EXTRAPOLATION.
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
!           PERFORM EXTRAPOLATION.
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
!            PREPARE BISECTION OF THE SMALLEST INTERVAL.
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
!           SET FINAL RESULT AND ERROR ESTIMATE.
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
!           TEST ON DIVERGENCE
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
&defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
&.or. errsum .gt. abs(area)) ier = 6
go to 130
!
!           COMPUTE GLOBAL INTEGRAL SUM.
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
!              THE ORIGINAL (INFINITE) INTEGRATION RANGE IS MAPPED
!              ONTO THE INTERVAL (0,1) AND (A,B) IS A PART OF (0,1).
!              IT IS THE PURPOSE TO COMPUTE
!              I = INTEGRAL OF TRANSFORMED INTEGRAND OVER (A,B),
!              J = INTEGRAL OF ABS(TRANSFORMED INTEGRAND) OVER (A,B).
!
! 2.        PARAMETERS
!            ON ENTRY
!              F      - REAL
!                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       TO BE DECLARED E X T E R N A L IN THE
!                       CALLING PROGRAM.
!
!              BOUN   - REAL
!                       FINITE BOUND OF ORIGINAL INTEGRATION
!                       RANGE (SET TO ZERO IF INF = +2)
!
!              INF    - INTEGER
!                       IF INF = -1, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,BOUND),
!                       IF INF = +1, THE ORIGINAL INTERVAL IS
!                                   (BOUND,+INFINITY),
!                       IF INF = +2, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,+INFINITY) AND
!                       THE INTEGRAL IS COMPUTED AS THE SUM OF TWO
!                       INTEGRALS, ONE OVER (-INFINITY,0)
!                       AND ONE OVER (0,+INFINITY).
!
!              A      - REAL
!                       LOWER LIMIT FOR INTEGRATION OVER SUBRANGE
!                       OF (0,1)
!
!              B      - REAL
!                       UPPER LIMIT FOR INTEGRATION OVER SUBRANGE
!                       OF (0,1)
!
!              EPMACH - REAL
!                       THE RELATIVE PRECISION OF THE FLOATING
!                       ARITHMETIC BEING USED.
!
!              UFLOW  - REAL
!                       THE SMALLEST POSITIVE MAGNITUDE.
!
!            ON RETURN
!              RESULT - REAL
!                       APPROXIMATION TO THE INTEGRAL I
!                       RESULT IS COMPUTED BY APPLYING THE 15-POINT
!                       KRONROD RULE(RESK) OBTAINED BY OPTIMAL
!                       ADDITION OF ABSCISSAE TO THE 7-POINT GAUSS
!                       RULE(RESG).
!
!              ABSERR - REAL
!                       ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                       WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!              RESABS - REAL
!                       APPROXIMATION TO THE INTEGRAL J
!
!              RESASC - REAL
!                       APPROXIMATION TO THE INTEGRAL OF
!                       ABS((TRANSFORMED INTEGRAND)-I/(B-A))
!                       OVER (A,B)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (USER-PROVIDED FUNCTION)
!
!-----------------------------------------------------------------------
real :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
external f
!
!           THE ABSCISSAE AND WEIGHTS ARE SUPPLIED FOR THE INTERVAL
!           (-1,1).  BECAUSE OF SYMMETRY ONLY THE POSITIVE ABSCISSAE AND
!           THEIR CORRESPONDING WEIGHTS ARE GIVEN.
!
!           XGK    - ABSCISSAE OF THE 15-POINT KRONROD RULE
!                    XGK(2), XGK(4), ... ABSCISSAE OF THE 7-POINT
!                    GAUSS RULE
!                    XGK(1), XGK(3), ...  ABSCISSAE WHICH ARE OPTIMALLY
!                    ADDED TO THE 7-POINT GAUSS RULE
!
!           WGK    - WEIGHTS OF THE 15-POINT KRONROD RULE
!
!           WG     - WEIGHTS OF THE 7-POINT GAUSS RULE, CORRESPONDING
!                    TO THE ABSCISSAE XGK(2), XGK(4), ...
!                    WG(1), WG(3), ... ARE SET TO ZERO.
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
!           LIST OF MAJOR VARIABLES
!           -----------------------
!
!           CENTR  - MID POINT OF THE INTERVAL
!           HLGTH  - HALF-LENGTH OF THE INTERVAL
!           ABSC*  - ABSCISSA
!           TABSC* - TRANSFORMED ABSCISSA
!           FVAL*  - FUNCTION VALUE
!           RESG   - RESULT OF THE 7-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 15-POINT KRONROD FORMULA
!           RESKH  - APPROXIMATION TO THE MEAN VALUE OF THE TRANSFORMED
!                    INTEGRAND OVER (A,B), I.E. TO I/(B-A)
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
!           COMPUTE THE 15-POINT KRONROD APPROXIMATION TO
!           THE INTEGRAL, AND ESTIMATE THE ERROR.
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
!              THIS ROUTINE MAINTAINS THE DESCENDING ORDERING
!              IN THE LIST OF THE LOCAL ERROR ESTIMATES RESULTING FROM
!              THE INTERVAL SUBDIVISION PROCESS. AT EACH CALL TWO ERROR
!              ESTIMATES ARE INSERTED USING THE SEQUENTIAL SEARCH
!              METHOD, TOP-DOWN FOR THE LARGEST ERROR ESTIMATE
!              AND BOTTOM-UP FOR THE SMALLEST ERROR ESTIMATE.
!
! 3.        CALLING SEQUENCE
!              CALL QPSRT(LIMIT,LAST,MAXERR,ERMAX,ELIST,IORD,NRMAX)
!
!           PARAMETERS (MEANING AT OUTPUT)
!              LIMIT  - INTEGER
!                       MAXIMUM NUMBER OF ERROR ESTIMATES THE LIST
!                       CAN CONTAIN
!
!              LAST   - INTEGER
!                       NUMBER OF ERROR ESTIMATES CURRENTLY
!                       IN THE LIST
!
!              MAXERR - INTEGER
!                       MAXERR POINTS TO THE NRMAX-TH LARGEST ERROR
!                       ESTIMATE CURRENTLY IN THE LIST
!
!              ERMAX  - REAL
!                       NRMAX-TH LARGEST ERROR ESTIMATE
!                       ERMAX = ELIST(MAXERR)
!
!              ELIST  - REAL
!                       VECTOR OF DIMENSION LAST CONTAINING
!                       THE ERROR ESTIMATES
!
!              IORD   - INTEGER
!                       VECTOR OF DIMENSION LAST, THE FIRST K
!                       ELEMENTS OF WHICH CONTAIN POINTERS
!                       TO THE ERROR ESTIMATES, SUCH THAT
!                       ELIST(IORD(1)),... , ELIST(IORD(K))
!                       FORM A DECREASING SEQUENCE, WITH
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
!           CHECK WHETHER THE LIST CONTAINS MORE THAN
!           TWO ERROR ESTIMATES.
!
!***FIRST EXECUTABLE STATEMENT  QPSRT
if(last.gt.2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!
!           THIS PART OF THE ROUTINE IS ONLY EXECUTED
!           IF, DUE TO A DIFFICULT INTEGRAND, SUBDIVISION
!           INCREASED THE ERROR ESTIMATE. IN THE NORMAL CASE
!           THE INSERT PROCEDURE SHOULD START AFTER THE
!           NRMAX-TH LARGEST ERROR ESTIMATE.
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
!           COMPUTE THE NUMBER OF ELEMENTS IN THE LIST TO
!           BE MAINTAINED IN DESCENDING ORDER. THIS NUMBER
!           DEPENDS ON THE NUMBER OF SUBDIVISIONS STILL
!           ALLOWED.
!
30 jupbn = last
if(last.gt.(limit/2+2)) jupbn = limit+3-last
errmin = elist(last)
!
!           INSERT ERRMAX BY TRAVERSING THE LIST TOP-DOWN,
!           STARTING COMPARISON FROM THE ELEMENT ELIST(IORD(NRMAX+1)).
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
!           INSERT ERRMIN BY TRAVERSING THE LIST BOTTOM-UP.
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
!           SET MAXERR AND ERMAX.
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
!              THE ROUTINE DETERMINES THE LIMIT OF A GIVEN SEQUENCE OF
!              APPROXIMATIONS, BY MEANS OF THE EPSILON ALGORITHM
!              OF P. WYNN.
!              AN ESTIMATE OF THE ABSOLUTE ERROR IS ALSO GIVEN.
!              THE CONDENSED EPSILON TABLE IS COMPUTED. ONLY THOSE
!              ELEMENTS NEEDED FOR THE COMPUTATION OF THE NEXT DIAGONAL
!              ARE PRESERVED.
!
! 2.        PARAMETERS
!              N      - INTEGER
!                       EPSTAB(N) CONTAINS THE NEW ELEMENT IN THE
!                       FIRST COLUMN OF THE EPSILON TABLE.
!
!              EPSTAB - REAL
!                       VECTOR OF DIMENSION 52 CONTAINING THE
!                       ELEMENTS OF THE TWO LOWER DIAGONALS OF
!                       THE TRIANGULAR EPSILON TABLE
!                       THE ELEMENTS ARE NUMBERED STARTING AT THE
!                       RIGHT-HAND CORNER OF THE TRIANGLE.
!
!              RESULT - REAL
!                       RESULTING APPROXIMATION TO THE INTEGRAL
!
!              ABSERR - REAL
!                       ESTIMATE OF THE ABSOLUTE ERROR COMPUTED FROM
!                       RESULT AND THE 3 PREVIOUS RESULTS
!
!              RES3LA - REAL
!                       VECTOR OF DIMENSION 3 CONTAINING THE LAST 3
!                       RESULTS
!
!              NRES   - INTEGER
!                       NUMBER OF CALLS TO THE ROUTINE
!                       (SHOULD BE ZERO AT FIRST CALL)
!
!              EPMACH - REAL
!                       THE RELATIVE PRECISION OF THE FLOATING
!                       ARITHMETIC BEING USED.
!
!              OFLOW  - REAL
!                       THE LARGEST POSITIVE MAGNITUDE.
!
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!
!-----------------------------------------------------------------------
real, intent(inout) :: epstab(52), res3la(3)
!---------------------
!
!           LIST OF MAJOR VARIABLES
!           -----------------------
!
!           E0     - THE 4 ELEMENTS ON WHICH THE
!           E1       COMPUTATION OF A NEW ELEMENT IN
!           E2       THE EPSILON TABLE IS BASED
!           E3                 E0
!                        E3    E1    NEW
!                              E2
!           NEWELM - NUMBER OF ELEMENTS TO BE COMPUTED IN THE NEW
!                    DIAGONAL
!           ERROR  - ERROR = ABS(E1-E0)+ABS(E2-E1)+ABS(NEW-E2)
!           RESULT - THE ELEMENT IN THE NEW DIAGONAL WITH LEAST VALUE
!                    OF ERROR
!
!           LIMEXP IS THE MAXIMUM NUMBER OF ELEMENTS THE EPSILON
!           TABLE CAN CONTAIN. IF THIS NUMBER IS REACHED, THE UPPER
!           DIAGONAL OF THE EPSILON TABLE IS DELETED.
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
!           IF E0, E1 AND E2 ARE EQUAL TO WITHIN MACHINE
!           ACCURACY, CONVERGENCE IS ASSUMED.
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
!           IF TWO ELEMENTS ARE VERY CLOSE TO EACH OTHER, OMIT
!           A PART OF THE TABLE BY ADJUSTING THE VALUE OF N
!
  if (err1.le.tol1 .or. err2.le.tol2 .or. err3.le.tol3) go to 20
  ss = 1.0/delta1 + 1.0/delta2 - 1.0/delta3
  epsinf = abs(ss*e1)
!
!           TEST TO DETECT IRREGULAR BEHAVIOUR IN THE TABLE, AND
!           EVENTUALLY OMIT A PART OF THE TABLE ADJUSTING THE VALUE
!           OF N.
!
  if (epsinf .gt. 0.1e-03) go to 30
20 n = i + i - 1
! ***JUMP OUT OF DO-LOOP
  go to 50
!
!           COMPUTE A NEW ELEMENT AND EVENTUALLY ADJUST
!           THE VALUE OF RESULT.
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
!           SHIFT THE TABLE.
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
!           COMPUTE ERROR ESTIMATE
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
!            THE ROUTINE CALCULATES AN APPROXIMATION RESULT TO A GIVEN
!            DEFINITE INTEGRAL  I = INTEGRAL OF F OVER (A,B),
!            HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!            ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            A      - REAL
!                     LOWER LIMIT OF INTEGRATION
!
!            B      - REAL
!                     UPPER LIMIT OF INTEGRATION
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             THE ESTIMATES FOR INTEGRAL AND ERROR ARE
!                             LESS RELIABLE. IT IS ASSUMED THAT THE
!                             REQUESTED ACCURACY HAS NOT BEEN ACHIEVED.
!            ERROR MESSAGES
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE SUB-
!                             DIVISIONS BY INCREASING THE VALUE OF LIMIT
!                             (AND TAKING THE ACCORDING DIMENSION
!                             ADJUSTMENTS INTO ACCOUNT. HOWEVER, IF
!                             THIS YIELDS NO IMPROVEMENT IT IS ADVISED
!                             TO ANALYZE THE INTEGRAND IN ORDER TO
!                             DETERMINE THE INTEGRATION DIFFICULTIES. IF
!                             THE POSITION OF A LOCAL DIFFICULTY CAN BE
!                             DETERMINED (E.G. SINGULARITY,
!                             DISCONTINUITY WITHIN THE INTERVAL) ONE
!                             WILL PROBABLY GAIN FROM SPLITTING UP THE
!                             INTERVAL AT THIS POINT AND CALLING THE
!                             INTEGRATOR ON THE SUBRANGES. IF POSSIBLE,
!                             AN APPROPRIATE SPECIAL-PURPOSE INTEGRATOR
!                             SHOULD BE USED, WHICH IS DESIGNED FOR
!                             HANDLING THE TYPE OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             TED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             OCCURS AT SOME POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             ROUNDOFF ERROR IS DETECTED IN THE
!                             EXTRAPOLATION TABLE. IT IS PRESUMED THAT
!                             THE REQUESTED TOLERANCE CANNOT BE
!                             ACHIEVED, AND THAT THE RETURNED RESULT IS
!                             THE BEST WHICH CAN BE OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
!                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
!                             OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS OR
!                             EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             LENW .LT. 46*LIMIT, OR
!                             LENIW .LT. 3*LIMIT.
!                             RESULT, ABSERR, LAST ARE SET TO
!                             ZERO. EXCEPT WHEN LIMIT OR LENW OR LENIW
!                             IS INVALID, IWORK(1), WORK(LIMIT*2+1) AND
!                             WORK(LIMIT*3+1) ARE SET TO ZERO, WORK(1)
!                             IS SET TO A, AND WORK(LIMIT+1) TO B.
!
!         DIMENSIONING PARAMETERS
!            LIMIT - INTEGER
!                    LIMIT DETERMINES THE MAXIMUM NUMBER OF SUBINTERVALS
!                    IN THE PARTITION OF THE GIVEN INTEGRATION INTERVAL
!                    (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH IER = 6.
!
!            LENW  - INTEGER
!                    DIMENSIONING PARAMETER FOR WORK
!                    LENW MUST BE AT LEAST LIMIT*46.
!                    IF LENW.LT.LIMIT*46, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LENIW - INTEGER
!                    DIMENSIONING PARAMETER FOR IWORK
!                    LENIW MUST BE AT LEAST LIMIT*3.
!                    IF LENW.LT.LIMIT*3, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LAST  - INTEGER
!                    ON RETURN, LAST EQUALS THE NUMBER OF SUBINTERVALS
!                    PRODUCED IN THE SUBDIVISION PROCESS, WHICH DETER-
!                    MINES THE NUMBER OF SIGNIFICANT ELEMENTS ACTUALLY
!                    IN THE WORK ARRAYS.
!
!         WORK ARRAYS
!            IWORK - INTEGER
!                    VECTOR OF DIMENSION AT LEAST 3*LIMIT, THE FIRST K
!                    ELEMENTS OF WHICH CONTAIN POINTERS
!                    TO THE ERROR ESTIMATES OVER THE SUBINTERVALS
!                    SUCH THAT WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) FORM A DECREASING
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2),
!                    AND K = LIMIT+1-LAST OTHERWISE.
!
!            WORK  - REAL
!                    VECTOR OF DIMENSION AT LEAST LENW
!                    ON RETURN
!                    WORK(1), ..., WORK(LAST) CONTAIN THE LEFT
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     PARTITION OF (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) CONTAIN
!                     THE RIGHT END-POINTS,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST) CONTAIN
!                     THE INTEGRAL APPROXIMATIONS OVER THE SUBINTERVALS,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     CONTAIN THE ERROR ESTIMATES.
!                    WORK(LIMIT*4+1), ... IS THE AREA RESERVED TO STORE
!                     FUNCTIONAL VALUES.
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
!         CHECK VALIDITY OF LIMIT,LENIW AND LENW.
!
ier = 6
last = 0
result = 0.0
abserr = 0.0
if (limit.lt.1 .or. leniw.lt.limit*3 .or. lenw.lt.limit*46) &
&return
!
!         PREPARE CALL FOR QXGSE.
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
!            THE ROUTINE CALCULATES AN APPROXIMATION RESULT TO A
!            DEFINITE INTEGRAL I = INTEGRAL OF F OVER (A,B),
!            HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!            ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - REAL
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            A      - REAL
!                     LOWER LIMIT OF INTEGRATION
!
!            B      - REAL
!                     UPPER LIMIT OF INTEGRATION
!
!            EPSABS - REAL
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - REAL
!                     RELATIVE ACCURACY REQUESTED
!
!            LIMIT  - INTEGER
!                     GIVES AN UPPERBOUND ON THE NUMBER OF SUBINTERVALS
!                     IN THE PARTITION OF (A,B)
!
!         ON RETURN
!            RESULT - REAL
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - REAL
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             THE ESTIMATES FOR INTEGRAL AND ERROR ARE
!                             LESS RELIABLE. IT IS ASSUMED THAT THE
!                             REQUESTED ACCURACY HAS NOT BEEN ACHIEVED.
!            ERROR MESSAGES
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE SUB-
!                             DIVISIONS BY INCREASING THE VALUE OF LIMIT
!                             (AND TAKING THE ACCORDING DIMENSION
!                             ADJUSTMENTS INTO ACCOUNT). HOWEVER, IF
!                             THIS YIELDS NO IMPROVEMENT IT IS ADVISED
!                             TO ANALYZE THE INTEGRAND IN ORDER TO
!                             DETERMINE THE INTEGRATION DIFFICULTIES. IF
!                             THE POSITION OF A LOCAL DIFFICULTY CAN BE
!                             DETERMINED (E.G. SINGULARITY,
!                             DISCONTINUITY WITHIN THE INTERVAL) ONE
!                             WILL PROBABLY GAIN FROM SPLITTING UP THE
!                             INTERVAL AT THIS POINT AND CALLING THE
!                             INTEGRATOR ON THE SUBRANGES. IF POSSIBLE,
!                             AN APPROPRIATE SPECIAL-PURPOSE INTEGRATOR
!                             SHOULD BE USED, WHICH IS DESIGNED FOR
!                             HANDLING THE TYPE OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             TED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             OCCURS AT SOME POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             ROUNDOFF ERROR IS DETECTED IN THE
!                             EXTRAPOLATION TABLE.
!                             IT IS PRESUMED THAT THE REQUESTED
!                             TOLERANCE CANNOT BE ACHIEVED, AND THAT THE
!                             RETURNED RESULT IS THE BEST WHICH CAN BE
!                             OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
!                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
!                             OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS OR
!                             EPSREL IS NEGATIVE. RESULT, ABSERR,
!                             LAST, RLIST(1), IORD(1), AND ELIST(1)
!                             ARE SET TO ZERO. ALIST(1) AND BLIST(1)
!                             ARE SET TO A AND B RESPECTIVELY.
!
!            ALIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE LEFT END POINTS
!                     OF THE SUBINTERVALS IN THE PARTITION OF THE
!                     GIVEN INTEGRATION RANGE (A,B)
!
!            BLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE RIGHT END POINTS
!                     OF THE SUBINTERVALS IN THE PARTITION OF THE GIVEN
!                     INTEGRATION RANGE (A,B)
!
!            RLIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE INTEGRAL
!                     APPROXIMATIONS ON THE SUBINTERVALS
!
!            ELIST  - REAL
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE MODULI OF THE
!                     ABSOLUTE ERROR ESTIMATES ON THE SUBINTERVALS
!
!            IORD   - INTEGER
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST K
!                     ELEMENTS OF WHICH ARE POINTERS TO THE
!                     ERROR ESTIMATES OVER THE SUBINTERVALS,
!                     SUCH THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     OTHERWISE
!
!            LAST   - INTEGER
!                     NUMBER OF SUBINTERVALS ACTUALLY PRODUCED IN THE
!                     SUBDIVISION PROCESS
!
!            VALP   - REAL
!            VALN     ARRAYS OF DIMENSION AT LEAST (21,LIMIT) USED TO
!                     SAVE THE FUNCTIONAL VALUES
!
!            LP     - INTEGER
!            LN       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     STORE THE ACTUAL NUMBER OF FUNCTIONAL VALUES
!                     SAVED IN THE CORRESPONDING COLUMN
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
!            MACHINE DEPENDENT CONSTANTS
!            ---------------------------
!
!          EPMACH IS THE LARGEST RELATIVE SPACING.
!          UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
!          OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!            TEST ON VALIDITY OF PARAMETERS
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
!           FIRST APPROXIMATION TO THE INTEGRAL
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
!           TEST ON ACCURACY.
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
!           INITIALIZATION
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
!           MAIN DO-LOOP
!           ------------
!
do 90 last = 2,limit
!
!           BISECT THE SUBINTERVAL WITH THE NRMAX-TH LARGEST ERROR
!           ESTIMATE.
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
!           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
!           AND ERROR AND TEST FOR ACCURACY.
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
!           TEST FOR ROUNDOFF ERROR AND EVENTUALLY SET ERROR FLAG.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF SUBINTERVALS
!           EQUALS LIMIT.
!
  if (last .eq. limit) ier = 1
!
!           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
!           AT A POINT OF THE INTEGRATION RANGE.
!
  if (amax1(abs(a1),abs(b2)) .le. &
&t*(abs(a2) + 1.e+03*uflow)) ier = 4
!
!           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
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
!           IN THE LIST OF ERROR ESTIMATES AND SELECT THE SUBINTERVAL
!           WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE BISECTED NEXT).
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
!           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
!           SMALLEST INTERVAL.
!
  if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
!
!           THE BOUND 0.3*ERTEST HAS BEEN INTRODUCED TO PERFORM A
!           MORE CAUTIOUS EXTRAPOLATION THAN IN THE ORIGINAL DQAGSE
!           ROUTINE
!
40 if (ierro .eq. 3 .or. erlarg .le. 0.3*ertest) go to 60
!
!           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
!           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS OVER THE
!           LARGER INTERVALS (ERLARG) AND PERFORM EXTRAPOLATION.
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
!           PERFORM EXTRAPOLATION.
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
!           PREPARE BISECTION OF THE SMALLEST INTERVAL.
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
!           SET FINAL RESULT AND ERROR ESTIMATE.
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
!           TEST ON DIVERGENCE.
!
110 if(ksgn.eq.(-1).and.amax1(abs(result),abs(area)).le. &
&defabs*0.1e-01) go to 130
if(0.1e-01.gt.(result/area).or.(result/area).gt.0.1e+03 &
&.or.errsum.gt.abs(area)) ier = 6
go to 130
!
!           COMPUTE GLOBAL INTEGRAL SUM.
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
!          THE REAL VECTOR A OF LENGTH L
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
!                           ESTIMATE
!                       J = INTEGRAL OF ABS(F) OVER (A,B)
!
!           PARAMETERS
!            ON ENTRY
!              F      - REAL
!                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!              A      - REAL
!                       LOWER LIMIT OF INTEGRATION
!
!              B      - REAL
!                       UPPER LIMIT OF INTEGRATION
!
!              VR     - REAL
!                       VECTOR OF LENGTH LR CONTAINING THE
!                       SAVED  FUNCTIONAL VALUES OF POSITIVE ABSCISSAS
!
!              VS     - REAL
!                       VECTOR OF LENGTH LS CONTAINING THE
!                       SAVED  FUNCTIONAL VALUES OF NEGATIVE ABSCISSAS
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTS IN
!                       VR,VS RESPECTIVELY
!
!            KEY    - INTEGER
!                     KEY FOR CHOICE OF LOCAL INTEGRATION RULE
!                     RMS FORMULAS ARE USED WITH
!                      13 - 19               POINTS IF KEY.LT.1,
!                      13 - 19 - (27)        POINTS IF KEY = 1,
!                      13 - 19 - (27) - (41) POINTS IF KEY = 2,
!                           19 -  27  - (41) POINTS IF KEY = 3,
!                                 27  -  41  POINTS IF KEY.GT.3.
!
!                         (RULES) USED IF THE FUNCTION APPEARS
!                         ENOUGH REGULAR
!
!              EPMACH - REAL
!                       THE RELATIVE PRECISION OF THE FLOATING
!                       ARITHMETIC BEING USED.
!
!              UFLOW  - REAL
!                       THE SMALLEST POSITIVE MAGNITUDE.
!
!              OFLOW  - REAL
!                       THE LARGEST POSITIVE MAGNITUDE.
!
!            ON RETURN
!              RESULT - REAL
!                       APPROXIMATION TO THE INTEGRAL I
!
!              ABSERR - REAL
!                       ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                       WHICH SHOULD NOT EXCEED ABS(I-RESULT)
!
!              RESABS - REAL
!                       APPROXIMATION TO THE INTEGRAL J
!
!              RESASC - REAL
!                       APPROXIMATION TO THE INTEGRAL OF ABS(F-I/(B-A))
!                       OVER (A,B)
!
!              VR     - REAL
!                       VECTOR OF LENGTH LR CONTAINING THE
!                       SAVED  FUNCTIONAL VALUES OF POSITIVE ABSCISSAS
!
!              VS     - REAL
!                       VECTOR OF LENGTH LS CONTAINING THE
!                       SAVED  FUNCTIONAL VALUES OF NEGATIVE ABSCISSAS
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTS IN
!                       VR,VS RESPECTIVELY
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
!                           ESTIMATE
!            AND CONDITIONALLY COMPUTE
!                       J = INTEGRAL OF ABS(F) OVER (A,B)
!                       BY USING AN  RMS RULE
!           PARAMETERS
!            ON ENTRY
!              F      - REAL
!                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!              XL     - REAL
!                       LOWER LIMIT OF INTEGRATION
!
!              XU     - REAL
!                       UPPER LIMIT OF INTEGRATION
!
!              KE     - INTEGER
!                     KEY FOR CHOICE OF LOCAL INTEGRATION RULE
!                     AN RMS RULE IS USED WITH
!                         13      POINTS IF KE  = 2,
!                         19      POINTS IF KE  = 3,
!                         27      POINTS IF KE  = 4,
!                         42      POINTS IF KE  = 5
!
!              K1     INTEGER
!                     VALUE OF KEY FOR WHICH THE ADDITIONAL ESTIMATES
!                     YA, YM ARE TO BE COMPUTED
!
!              FV1    - REAL
!                       VECTOR CONTAINING L1
!                       SAVED  FUNCTIONAL VALUES OF POSITIVE ABSCISSAS
!
!              FV2    - REAL
!                       VECTOR CONTAINING L2
!                       SAVED  FUNCTIONAL VALUES OF NEGATIVE ABSCISSAS
!
!              L1     - INTEGER
!              L2       NUMBER OF ELEMENTS IN FV1,FV2  RESPECTIVELY
!
!            ON RETURN
!              Y      - REAL
!                       APPROXIMATION TO THE INTEGRAL I
!                       RESULT IS COMPUTED BY APPLYING THE
!                       REQUESTED RMS RULE
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
!                       VECTOR CONTAINING L1
!                       SAVED  FUNCTIONAL VALUES OF POSITIVE ABSCISSAS
!
!              FV2    - REAL
!                       VECTOR CONTAINING L2
!                       SAVED  FUNCTIONAL VALUES OF NEGATIVE ABSCISSAS
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
!   NUMBER OF NODES 13
data ww(1)/1.303262173284849021810473057638590518409112513421e-1/
data ww(2)/2.390632866847646220320329836544615917290026806242e-1/
data ww(3)/2.630626354774670227333506083741355715758124943143e-1/
data ww(4)/2.186819313830574175167853094864355208948886875898e-1/
data ww(5)/2.757897646642836865859601197607471574336674206700e-2/
data ww(6)/1.055750100538458443365034879086669791305550493830e-1/
data ww(7)/1.571194260595182254168429283636656908546309467968e-2/
!   NUMBER OF NODES 19
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
!   NUMBER OF NODES 27
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
!   NUMBER OF NODES 41
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
!            TO REORDER THE COMPUTED FUNCTIONAL VALUES BEFORE
!            THE BISECTION OF AN INTERVAL
!
!           PARAMETERS
!            ON ENTRY
!              F      - REAL
!                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!              XL     - REAL
!                       LOWER LIMIT OF INTERVAL
!
!              XU     - REAL
!                       UPPER LIMIT OF INTERVAL
!
!              Z      - REAL
!                       VECTOR CONTAINING LZ
!                       SAVED  FUNCTIONAL VALUES
!
!              LZ     - INTEGER
!                       NUMBER OF ELEMENTS IN LZ
!
!            ON RETURN
!              R      - REAL
!              S        VECTORS CONTAINING LR, LS
!                       SAVED  FUNCTIONAL VALUES FOR THE NEW INTERVALS
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
!           DOUBLE PRECISION COMPUTATION OF A DEFINITE INTEGRAL
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - DOUBLE PRECISION
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            A      - DOUBLE PRECISION
!                     LOWER LIMIT OF INTEGRATION
!
!            B      - DOUBLE PRECISION
!                     UPPER LIMIT OF INTEGRATION
!
!            EPSABS - DOUBLE PRECISION
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - DOUBLE PRECISION
!                     RELATIVE ACCURACY REQUESTED
!
!         ON RETURN
!            RESULT - DOUBLE PRECISION
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - DOUBLE PRECISION
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             THE ESTIMATES FOR INTEGRAL AND ERROR ARE
!                             LESS RELIABLE. IT IS ASSUMED THAT THE
!                             REQUESTED ACCURACY HAS NOT BEEN ACHIEVED.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE SUB-
!                             DIVISIONS BY INCREASING THE VALUE OF
!                             LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A
!                             LOCAL DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE SUB-
!                             RANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             TED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             OCCURS AT SOME  POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             IT IS PRESUMED THAT THE REQUESTED
!                             TOLERANCE CANNOT BE ACHIEVED, AND THAT THE
!                             RETURNED RESULT IS THE BEST WHICH CAN BE
!                             OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED
!                             THAT DIVERGENCE CAN OCCUR WITH ANY OTHER
!                             VALUE OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             RESULT, ABSERR, NEVAL, LAST ARE
!                             SET TO ZERO.
!
!         DIMENSIONING PARAMETERS
!            LIMIT - INTEGER
!                    DIMENSIONING PARAMETER FOR IWORK
!                    LIMIT DETERMINES THE MAXIMUM NUMBER
!                    OF SUBINTERVALS IN THE PARTITION OF THE GIVEN
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    DIMENSIONING PARAMETER FOR WORK
!                    LENW MUST BE AT LEAST LIMIT*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LAST  - INTEGER
!                    ON RETURN, LAST EQUALS THE NUMBER OF
!                    SUBINTERVALS PRODUCED IN THE SUBDIVISION
!                    PROCESS, WHICH DETERMINES THE NUMBER OF
!                    SIGNIFICANT ELEMENTS ACTUALLY IN THE WORK
!                    ARRAYS.
!
!         WORK ARRAYS
!            IWORK - INTEGER
!                    VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST K
!                    ELEMENTS OF WHICH CONTAIN POINTERS
!                    TO THE ERROR ESTIMATES OVER THE SUBINTERVALS
!                    SUCH THAT WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) FORM A DECREASING
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            WORK  - DOUBLE PRECISION
!                    VECTOR OF DIMENSION AT LEAST LENW
!                    ON RETURN
!                    WORK(1), ..., WORK(LAST) CONTAIN THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     PARTITION OF (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) CONTAIN
!                     THE RIGHT END POINTS,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     CONTAIN THE INTEGRAL APPROXIMATIONS OVER
!                     THE SUBINTERVALS,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     CONTAIN THE ERROR ESTIMATES.
!
!         SUBROUTINES OR FUNCTIONS NEEDED
!              - DQAGSE
!              - DQK21
!              - DQPSRT
!              - DQELG
!              - F (USER-PROVIDED FUNCTION)
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
!         CHECK VALIDITY OF LIMIT AND LENW.
!
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         PREPARE CALL FOR DQAGSE.
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
!           DOUBLE PRECISION COMPUTATION OF A DEFINITE INTEGRAL
!
!-----------------------------------------------------------------------
!
!        PURPOSE
!           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
!           DEFINITE INTEGRAL   I = INTEGRAL OF  F  OVER (A,B),
!           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        PARAMETERS
!         ON ENTRY
!            F      - DOUBLE PRECISION
!                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
!
!            A      - DOUBLE PRECISION
!                     LOWER LIMIT OF INTEGRATION
!
!            B      - DOUBLE PRECISION
!                     UPPER LIMIT OF INTEGRATION
!
!            EPSABS - DOUBLE PRECISION
!                     ABSOLUTE ACCURACY REQUESTED
!
!            EPSREL - DOUBLE PRECISION
!                     RELATIVE ACCURACY REQUESTED
!
!            LIMIT  - INTEGER
!                     GIVES AN UPPERBOUND ON THE NUMBER OF
!                     SUBINTERVALS IN THE PARTITION OF (A,B)
!
!         ON RETURN
!            RESULT - DOUBLE PRECISION
!                     APPROXIMATION TO THE INTEGRAL
!
!            ABSERR - DOUBLE PRECISION
!                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
!                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     NUMBER OF INTEGRAND EVALUATIONS
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
!                             ACCURACY HAS BEEN ACHIEVED.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             THE ESTIMATES FOR INTEGRAL AND ERROR ARE
!                             LESS RELIABLE. IT IS ASSUMED THAT THE
!                             REQUESTED ACCURACY HAS NOT BEEN ACHIEVED.
!
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE SUB-
!                             DIVISIONS BY INCREASING THE VALUE OF
!                             LIMIT (AND TAKING THE ACCORDING
!                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
!                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
!                             IT IS ADVISED TO ANALYZE THE INTEGRAND
!                             IN ORDER TO DETERMINE THE INTEGRATION
!                             DIFFICULTIES. IF THE POSITION OF A
!                             LOCAL DIFFICULTY CAN BE DETERMINED (E.G.
!                             SINGULARITY, DISCONTINUITY WITHIN THE
!                             INTERVAL) ONE WILL PROBABLY GAIN FROM
!                             SPLITTING UP THE INTERVAL AT THIS POINT
!                             AND CALLING THE INTEGRATOR ON THE SUB-
!                             RANGES. IF POSSIBLE, AN APPROPRIATE
!                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
!                             WHICH IS DESIGNED FOR HANDLING THE TYPE
!                             OF DIFFICULTY INVOLVED.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             TED, WHICH PREVENTS THE REQUESTED
!                             TOLERANCE FROM BEING ACHIEVED.
!                             THE ERROR MAY BE UNDER-ESTIMATED.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             OCCURS AT SOME  POINTS OF THE INTEGRATION
!                             INTERVAL.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             IT IS PRESUMED THAT THE REQUESTED
!                             TOLERANCE CANNOT BE ACHIEVED, AND THAT THE
!                             RETURNED RESULT IS THE BEST WHICH CAN BE
!                             OBTAINED.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             SLOWLY CONVERGENT. IT MUST BE NOTED
!                             THAT DIVERGENCE CAN OCCUR WITH ANY OTHER
!                             VALUE OF IER.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE.
!                             RESULT, ABSERR, NEVAL, LAST, RLIST(1),
!                             IORD(1) AND ELIST(1) ARE SET TO ZERO.
!                             ALIST(1) AND BLIST(1) ARE SET TO A AND B
!                             RESPECTIVELY.
!
!            ALIST  - DOUBLE PRECISION
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE LEFT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE GIVEN INTEGRATION RANGE (A,B)
!
!            BLIST  - DOUBLE PRECISION
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE RIGHT
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     OF THE GIVEN INTEGRATION RANGE (A,B)
!
!            RLIST  - DOUBLE PRECISION
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE INTEGRAL
!                     APPROXIMATIONS ON THE SUBINTERVALS
!
!            ELIST  - DOUBLE PRECISION
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
!                      LAST  ELEMENTS OF WHICH ARE THE MODULI
!                     OF THE ABSOLUTE ERROR ESTIMATES ON THE
!                     SUBINERVALS
!
!            IORD   - INTEGER
!                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST K
!                     ELEMENTS OF WHICH ARE POINTERS TO THE ERROR
!                     ESTIMATES OVER THE SUBINTERVALS, SUCH
!                     THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     OTHERWISE
!
!            LAST   - INTEGER
!                     NUMBER OF SUBINTERVALS ACTUALLY PRODUCED IN THE
!                     SUBDIVISION PROCESS
!
!         SUBROUTINES OR FUNCTIONS NEEDED
!              - DQK21
!              - DQPSRT
!              - DQELG
!              - F (USER-PROVIDED FUNCTION)
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
!            THE DIMENSION OF RLIST2 IS DETERMINED BY THE VALUE OF
!            LIMEXP IN SUBROUTINE DQELG (RLIST2 SHOULD BE OF DIMENSION
!            (LIMEXP+2) AT LEAST).
!
!            LIST OF MAJOR VARIABLES
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       CONSIDERED UP TO NOW
!           RLIST(I)  - APPROXIMATION TO THE INTEGRAL OVER
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST LIMEXP+2
!                       CONTAINING THE PART OF THE EPSILON TABLE
!                       WHICH IS STILL NEEDED FOR FURTHER COMPUTATIONS
!           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       ESTIMATE
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (BEFORE THAT SUBDIVISION HAS TAKEN PLACE)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT INTERVAL
!           *****2    - VARIABLE FOR THE RIGHT INTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       APPROPRIATE APPROXIMATION TO THE COMPOUNDED
!                       INTEGRAL HAS BEEN OBTAINED IT IS PUT IN
!                       RLIST2(NUMRL2) AFTER NUMRL2 HAS BEEN INCREASED
!                       BY ONE.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED
!                       UP TO NOW, MULTIPLIED BY 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       THAN THE SMALLEST INTERVAL CONSIDERED UP TO NOW
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       IS ATTEMPTING TO PERFORM EXTRAPOLATION
!                       I.E. BEFORE SUBDIVIDING THE SMALLEST INTERVAL
!                       WE TRY TO DECREASE THE VALUE OF ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       IS NO LONGER ALLOWED (TRUE VALUE)
!
!            MACHINE DEPENDENT CONSTANTS
!            ---------------------------
!
!           EPMACH IS THE LARGEST RELATIVE SPACING.
!           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
!           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
!
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!
!            CHECK EPSABS AND EPSREL
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
!           FIRST APPROXIMATION TO THE INTEGRAL
!           -----------------------------------
!
ierro = 0
call dqk21 (f, a, b, result, abserr, defabs, resabs, &
&epmach, uflow, id)
if (id .ne. 0) go to 999
neval = 21
!
!           TEST ON ACCURACY.
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
!           INITIALIZATION
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
!           MAIN DO-LOOP
!           ------------
!
do 90 last = 2,limit
!
!           BISECT THE SUBINTERVAL WITH THE NRMAX-TH LARGEST
!           ERROR ESTIMATE.
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
!           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
!           AND ERROR AND TEST FOR ACCURACY.
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
!           TEST FOR ROUNDOFF ERROR AND EVENTUALLY
!           SET ERROR FLAG.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF
!           SUBINTERVALS EQUALS LIMIT.
!
  if (last .eq. limit) ier = 1
!
!           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
!           AT A POINT OF THE INTEGRATION RANGE.
!
  if (dmax1(dabs(a1),dabs(b2)) .le. &
&t*(dabs(a2) + 0.1d+04*uflow)) ier = 4
!
!           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
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
!           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
!           SUBINTERVAL WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE
!           BISECTED NEXT).
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
!           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
!           SMALLEST INTERVAL.
!
  if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
!           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS
!           OVER THE LARGER INTERVALS (ERLARG) AND PERFORM
!           EXTRAPOLATION.
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
!           PERFORM EXTRAPOLATION.
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
!           PREPARE BISECTION OF THE SMALLEST INTERVAL.
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
!           SET FINAL RESULT AND ERROR ESTIMATE.
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
!           TEST ON DIVERGENCE.
!
110 if (ksgn .eq. -1 .and. dmax1(dabs(result),dabs(area)) .le. &
&defabs*0.1d-01) go to 130
if (0.1d-01 .gt. (result/area) .or. (result/area) .gt. 0.1d+03 &
&.or. errsum .gt. dabs(area)) ier = 6
go to 130
!
!           COMPUTE GLOBAL INTEGRAL SUM.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine dqagse

