subroutine pdfit(x, y, m, break, l, z, a, b, c, wk, iwk, ierr)
!! <!-- nswc-ford:begin PDFIT -->
!! Reference for `pdfit`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Least squares periodic cubic spline fitting
!!
!!      real z(l-1), a(l-1), b(l-1), c(l-1)
!!      real wk((l + 6)*(l + 15) + 10)
!!      integer iwk(2*l + 6)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m
real, intent(in) :: x(m), y(m)
real, intent(inout) :: break(l)
real, intent(inout) :: z(*), a(*), b(*), c(*), wk(*)
integer, intent(inout) :: iwk(*)
!     beginning of local variable declarations
integer :: j, k, la, lm1, lw, n
real :: r, temp(20), con(3), xcon(3)
integer, parameter :: nder(3) = [3, 7, 11]
!-----------------------------------------------------------------------
!            Least squares periodic cubic spline fitting
!-----------------------------------------------------------------------
!--------------------
!     real z(l-1), a(l-1), b(l-1), c(l-1)
!     real wk((l + 6)*(l + 15) + 10)
!     integer iwk(2*l + 6)
!--------------------
!--------------------
!--------------------
if (m <= 0 .or. l < 2) go to 100
n = l + 2
!                Define the nodes for the b-splines
wk(1) = break(1)
wk(2) = break(1)
wk(3) = break(1)
wk(4) = break(1)
do j = 2,l
   if (break(j - 1) >= break(j)) go to 110
   wk(j + 3) = break(j)
end do
wk(l + 4) = break(l)
wk(l + 5) = break(l)
wk(l + 6) = break(l)
!                Define the periodicity constraints
con(1) = break(1)
con(2) = break(1)
con(3) = break(1)
xcon(1) = break(l)
xcon(2) = break(l)
xcon(3) = break(l)
!     Obtain the b-spline coefficients of the periodic spline
ierr = 0
la = n + 5
lw = la + n
iwk(1) = iwk(1) - (l + l + 8)
call bfit(wk(1), n, 4, x, y, m, xcon, con, nder, 3, ierr, &
   & wk(la), r, wk(lw), iwk)
iwk(1) = iwk(1) + (l + l + 8)
if (ierr /= 0) go to 30
!     Obtain the coefficients of the spline in Taylor series form
call bspp(wk(1), wk(la), n, 4, break, wk(lw), lm1, temp)
k = lw
do j = 1,lm1
   z(j) = wk(k)
   a(j) = wk(k + 1)
   b(j) = wk(k + 2)
   c(j) = wk(k + 3)
   k = k + 4
end do
return
!                The coefficients were not obtained
30 if (ierr == -4) go to 120
if (ierr == -6) go to 130
if (ierr == -7) go to 140
ierr = 1
return
!                           Error return
100 ierr = 2
return
110 ierr = 3
return
120 ierr = 4
return
130 ierr = 5
return
140 ierr = 6
end subroutine pdfit

pure subroutine pscmp(x, y, a, b, c, n, xi, yi, m, ierr)
!! <!-- nswc-ford:begin PSCMP -->
!! Reference for `pscmp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Evaluation of a periodic cubic spline
!!
!!      real x(n), y(n-1), a(n-1), b(n-1), c(n-1), xi(m), yi(m)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
real, intent(in) :: x(n), y(*), a(*), b(*), c(*), xi(m)
real, intent(inout) :: yi(m)
!     beginning of local variable declarations
integer :: i, il, ir, j, k
real :: dx, h, t, t0, x1, xold, xx, nswc_ai_r4
!-----------------------------------------------------------------------
!              Evaluation of a periodic cubic spline
!-----------------------------------------------------------------------
!----------------------
!     real x(n), y(n-1), a(n-1), b(n-1), c(n-1), xi(m), yi(m)
!----------------------
if (n >= 3 .and. m >= 1) go to 1
ierr = 1
return
1 ierr = 0
x1 = x(1)
h = x(n) - x1
!     Reduction of xi(k) to xx where x(1) .LE. xx .LT. x(n)
k = 1
t = (xi(1) - x1)/h
j = t
t0 = t - j
if (t0 < 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx >= x(n)) go to 120
il = 1
ir = n
!     Bisection search
10 i = (il + ir)/2
if (i == il) go to 90
nswc_ai_r4 = xx - x(i)
if (nswc_ai_r4 < 0) go to 20
if (nswc_ai_r4 == 0) go to 90
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!     Linear forward search
40 if (xx < x(i + 1)) go to 90
i = i + 1
go to 40
!     Computation when x(i) .LE. xx .LT. x(i+1)
90 dx = xx - x(i)
yi(k) = ((c(i)*dx + b(i))*dx + a(i))*dx + y(i)
!     Next point
100 if (k >= m) return
xold = xx
k = k + 1
t = (xi(k) - x1)/h
j = t
t0 = t - j
if (t0 < 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx >= x(n)) go to 120
nswc_ai_r4 = xx - xold
if (nswc_ai_r4 < 0) go to 110
if (nswc_ai_r4 == 0) go to 90
go to 40
110 il = 1
ir = min(i + 1,n)
go to 10
!     Case when roundoff produces a value for xx where
!     xx .GE. x(n). This case may never occur.
120 i = 1
xx = x1
yi(k) = y(1)
go to 100
end subroutine pscmp

pure subroutine psevl(x, y, a, b, c, n, xi, yi, ypi, yppi, m, ierr)
!! <!-- nswc-ford:begin PSEVL -->
!! Reference for `psevl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Evaluation and differentiation of a periodic cubic spline
!!
!!      real x(n), y(n-1), a(n-1), b(n-1), c(n-1), xi(m), yi(m), ypi(m),
!!     *     yppi(m)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
real, intent(in) :: x(n), y(*), a(*), b(*), c(*), xi(m)
real, intent(inout) :: yi(m), ypi(m), yppi(m)
!     beginning of local variable declarations
integer :: i, il, ir, j, k
real :: bi2, ci3, dx, h, t, t0, x1, xold, xx, nswc_ai_r4
!-----------------------------------------------------------------------
!     Evaluation and differentiation of a periodic cubic spline
!-----------------------------------------------------------------------
!----------------------
!     real x(n), y(n-1), a(n-1), b(n-1), c(n-1), xi(m), yi(m), ypi(m),
!    *     yppi(m)
!----------------------
if (n >= 3 .and. m >= 1) go to 1
ierr = 1
return
1 ierr = 0
x1 = x(1)
h = x(n) - x1
!     Reduction of xi(k) to xx where x(1) .LE. xx .LT. x(n)
k = 1
t = (xi(1) - x1)/h
j = t
t0 = t - j
if (t0 < 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx >= x(n)) go to 120
il = 1
ir = n
!     Bisection search
10 i = (il + ir)/2
if (i == il) go to 90
nswc_ai_r4 = xx - x(i)
if (nswc_ai_r4 < 0) go to 20
if (nswc_ai_r4 == 0) go to 90
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!     Linear forward search
40 if (xx < x(i + 1)) go to 90
i = i + 1
go to 40
!     Computation when x(i) .LE. xx .LT. x(i+1)
90 dx = xx - x(i)
yi(k) = ((c(i)*dx + b(i))*dx + a(i))*dx + y(i)
bi2 = b(i) + b(i)
ci3 = 3.0*c(i)
ypi(k) = (ci3*dx + bi2)*dx + a(i)
yppi(k) = bi2 + (ci3 + ci3)*dx
!     Next point
100 if (k >= m) return
xold = xx
k = k + 1
t = (xi(k) - x1)/h
j = t
t0 = t - j
if (t0 < 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx >= x(n)) go to 120
nswc_ai_r4 = xx - xold
if (nswc_ai_r4 < 0) go to 110
if (nswc_ai_r4 == 0) go to 90
go to 40
110 il = 1
ir = min(i + 1,n)
go to 10
!     Case when roundoff produces a value for xx where
!     xx .GE. x(n). This case may never occur.
120 i = 1
xx = x1
yi(k) = y(1)
ypi(k) = a(1)
yppi(k) = b(1) + b(1)
go to 100
end subroutine psevl

pure subroutine csloop(m, n, x, kx, t, dx, kdx, wk, ierr)
!! <!-- nswc-ford:begin CSLOOP -->
!! Reference for `csloop`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                Closed curve cubic spline fitting
!!                     in n-dimensional space
!!
!!      Written by
!!         Alfred H. Morris
!!         Naval Surface Warfare Center
!!         Dahlgren, Virginia
!!
!!      m = The number of n-dimensional points given in x
!!      wk is an array of dimension 4*(m-1)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kdx, kx, m, n
real, intent(in) :: x(kx,n)
real, intent(inout) :: t(m), dx(kdx,n), wk(*)
!     beginning of local variable declarations
integer :: ia, ib, ic, ie, mm1
interface
   pure subroutine cslop1(m,n,x,kx,t,dx,kdx,a,b,c,e,ierr)
      implicit none
      integer, intent(in) :: kdx
      integer, intent(in) :: kx
      integer, intent(in) :: n
      integer, intent(in) :: m
      real, intent(in) :: x(kx,n)
      real, intent(inout) :: t(m)
      real, intent(inout) :: dx(kdx,n)
      real, intent(inout) :: a(*)
      real, intent(inout) :: b(m)
      real, intent(inout) :: c(*)
      real, intent(inout) :: e(*)
      integer, intent(inout) :: ierr
   end subroutine cslop1
end interface
!-----------------------------------------------------------------------
!               Closed curve cubic spline fitting
!                    in n-dimensional space
!-----------------------------------------------------------------------
!     Written by
!        Alfred H. Morris
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!----------------------
!----------------------
!     m = The number of n-dimensional points given in x
!     wk is an array of dimension 4*(m-1)
!----------------------
if (min(m, n) < 2) go to 10
mm1 = m - 1
ie = 1
ia = mm1
ib = ia + mm1
ic = ib + m
call cslop1(m, n, x, kx, t, dx, kdx, wk(ia), wk(ib), &
   & wk(ic), wk(ie), ierr)
return
!     Error return
10 ierr = 1
end subroutine csloop

pure subroutine cslop1(m, n, x, kx, t, dx, kdx, a, b, c, e, ierr)
!! <!-- nswc-ford:begin CSLOP1 -->
!! Reference for `cslop1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                Closed curve cubic spline fitting
!!                     in n-dimensional space
!!
!!      real a(m-1), c(m-1), e(k)  (k = max0(1,m-2))
!!      the e array is not used when m = 2.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kdx, kx, m, n
real, intent(in) :: x(kx,n)
real, intent(inout) :: t(m), dx(kdx,n), a(*), b(m), c(*), e(*)
!     beginning of local variable declarations
integer :: i, im1, j, l, mm1, mm2
real :: alpha, del, del0, del1, deli, delm, eta, h, hm, p, r, si, &
   & sm, sum, tau
interface
   pure function snrm2(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: snrm2
   end function snrm2
end interface
!-----------------------------------------------------------------------
!               Closed curve cubic spline fitting
!                    in n-dimensional space
!-----------------------------------------------------------------------
!----------------------
!     real a(m-1), c(m-1), e(k)  (k = max0(1,m-2))
!     the e array is not used when m = 2.
!----------------------
mm1 = m - 1
mm2 = m - 2
!     Definition of the knots t(i) (i = 1,...,m). Also t(m+1) = 1.
!     This last knot is not stored.
t(1) = 0.0
do i = 2,m
   im1 = i - 1
   do j = 1,n
      dx(i,j) = x(i,j) - x(im1,j)
   end do
   t(i) = t(im1) + snrm2(n,dx(i,1),kdx)
   r = t(i) - t(im1)
   if (r == 0.0) go to 200
end do
do j = 1,n
   dx(1,j) = x(1,j) - x(m,j)
end do
sum = t(m) + snrm2(n,dx(1,1),kdx)
r = sum - t(m)
if (r == 0.0) go to 210
do i = 2,m
   t(i) = t(i)/sum
end do
ierr = 0
!     For j = 1,...,n, a diagonally dominant set of equations
!     for the slopes S(i,j) of the j-TH periodic spline at t(i)
!     (i = 1,...,m) is generated and solved by Gauss elimination.
!     The first equation is obtained from the requirement that
!     the spline be periodic. This equation has the form ...
!        a(1)*S(1,j) + b(1)*S(2,j) + c(1)*S(m,j) = dx(1,j)
h = t(2)
hm = 1.0 - t(m)
c(1) = h
b(1) = hm
a(1) = 2.0*(h + hm)
b(2) = h
do j = 1,n
   delm = dx(1,j)/hm
   del1 = dx(2,j)/h
   dx(1,j) = 3.0*(h*delm + hm*del1)
   dx(2,j) = del1
end do
if (m == 2) go to 70
!     For the knots t(i) (i = 2,...m-1), generate the correspond-
!     ing equations and carry out the pivot reduction of Gauss
!     elimination. Then the i-TH equation has the form ...
!        a(i)*S(i,j) + b(i)*S(i+1,j) + c(i)*S(m,j) = dx(i,j)
do i = 2,mm1
   im1 = i - 1
   b(i) = h
   h = t(i + 1) - t(i)
   e(im1) = h/a(im1)
   c(i) = - e(im1)*c(im1)
   a(i) = 2.0*(b(i) + h) - e(im1)*b(im1)
end do
b(m) = h
do j = 1,n
   deli = dx(2,j)
   do i = 2,mm1
      h = b(i + 1)
      del0 = deli
      deli = dx(i + 1,j)/h
      dx(i,j) = 3.0*(h*del0 + b(i)*deli) - e(i - 1)*dx(i - 1,j)
   end do
   dx(m,j) = deli
end do
!     Since it is required that the spline be periodic, the
!     equation for the knot t(m) has the form ...
!        alpha*S(1,j) + hm*S(m-1,j) + eta*S(m,j) = dx(m,j)
!     applying the pivots to this equation, one obtains after
!     each pivot operation the modified equation ...
!        alpha*S(i+1,j) + hm*S(m-1,j) + eta*S(m,j) = dx(m,j)
!     thus, when this pivot reduction is complete, the m-TH
!     equation to be solved has the form ...
!        (alpha + hm)*S(m-1,j) + eta*S(m,j) = dx(m,j)
70 alpha = h
eta = 2.0*(h + hm)
do j = 1,n
   del = dx(m,j)
   delm = (x(1,j) - x(m,j))/hm
   dx(m,j) = 3.0*(hm*del + h*delm)
end do
if (m == 2) go to 90
do i = 1,mm2
   p = alpha/a(i)
   alpha = - p*b(i)
   eta = eta - p*c(i)
   do j = 1,n
      dx(m,j) = dx(m,j) - p*dx(i,j)
   end do
end do
!     Solve the last two equations for S(m,j) and S(m-1,j),
!     and store these slopes in dx.
90 p = (alpha + hm)/a(mm1)
tau = b(mm1) + c(mm1)
do j = 1,n
   sm = (dx(m,j) - p*dx(mm1,j))/(eta - p*tau)
   dx(m,j) = sm
   dx(mm1,j) = (dx(mm1,j) - tau*sm)/a(mm1)
end do
if (m == 2) return
!     Back substitution to obtain the remaining slopes S(i,j).
!     These slopes are stored in dx.
do j = 1,n
   sm = dx(m,j)
   si = dx(mm1,j)
   i = mm1
   do l = 3,m
      i = i - 1
      si = (dx(i,j) - b(i)*si - c(i)*sm)/a(i)
      dx(i,j) = si
   end do
end do
return
!     Error return
200 ierr = 2
return
210 ierr = 3
end subroutine cslop1

pure subroutine lopcmp(m, n, t, x, kx, dx, kdx, l, ti, z, kz)
!! <!-- nswc-ford:begin LOPCMP -->
!! Reference for `lopcmp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Evaluation of a cubic spline closed curve
!!                      in n-dimensional space
!!
!!      Reduction of ti(k) to t0 where 0 .LE. t0 .LT. 1
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: kdx, kx, kz, l, m, n
real, intent(in) :: t(m), x(kx,n), dx(kdx,n), ti(l)
real, intent(inout) :: z(kz, n)
!     beginning of local variable declarations
integer :: i, il, ir, j, k
real :: a, b, c, d, dt, h, t0, told, w, nswc_ai_r4
!-----------------------------------------------------------------------
!            Evaluation of a cubic spline closed curve
!                     in n-dimensional space
!-----------------------------------------------------------------------
!     Reduction of ti(k) to t0 where 0 .LE. t0 .LT. 1
k = 1
j = ti(1)
t0 = ti(1) - j
if (t0 < 0.0) t0 = 1.0 + t0
if (t0 >= t(m)) go to 60
il = 1
ir = m
!     Bisection search
10 i = (il + ir)/2
if (i == il) go to 50
nswc_ai_r4 = t0 - t(i)
if (nswc_ai_r4 < 0) go to 20
if (nswc_ai_r4 == 0) go to 50
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!     Linear forward search
40 if (t0 < t(i + 1)) go to 50
i = i + 1
go to 40
!     Computation when t(i) .LE. t0 .LT. t(i+1)
50 h = t(i + 1) - t(i)
dt = t0 - t(i)
do j = 1,n
   a = dx(i,j)
   d = (x(i + 1,j) - x(i,j))/h
   w = a + dx(i + 1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(k,j) = x(i,j) + dt*(a + dt*(b + dt*c))
end do
go to 100
!     Computation when t0 .GE. t(m)
60 i = m
h = 1.0 - t(m)
dt = t0 - t(m)
do j = 1,n
   a = dx(m,j)
   d = (x(1,j) - x(m,j))/h
   w = a + dx(1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(k,j) = x(m,j) + dt*(a + dt*(b + dt*c))
end do
!     Next point
100 if (k >= l) return
told = t0
k = k + 1
j = ti(k)
t0 = ti(k) - j
if (t0 < 0.0) t0 = 1.0 + t0
if (t0 >= t(m)) go to 60
nswc_ai_r4 = t0 - told
if (nswc_ai_r4 < 0) go to 110
if (nswc_ai_r4 == 0) go to 50
go to 40
110 il = 1
ir = min(i + 1,m)
go to 10
end subroutine lopcmp

pure subroutine lopdf(m, n, t, x, kx, dx, kdx, ti, z, dz, ddz)
!! <!-- nswc-ford:begin LOPDF -->
!! Reference for `lopdf`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Evaluation and differentiation of a cubic spline
!!                 closed curve in n-dimensional space
!!
!!      Reduction of ti to t0 where 0 .LE. t0 .LT. 1
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: kdx, kx, m, n
real, intent(in) :: ti
real, intent(in) :: t(m), x(kx,n), dx(kdx,n)
real, intent(inout) :: z(n), dz(n), ddz(n)
!     beginning of local variable declarations
integer :: i, il, ir, j
real :: a, b, c, d, dt, h, t0, w, nswc_ai_r4
!-----------------------------------------------------------------------
!          Evaluation and differentiation of a cubic spline
!                closed curve in n-dimensional space
!-----------------------------------------------------------------------
!     Reduction of ti to t0 where 0 .LE. t0 .LT. 1
j = ti
t0 = ti - j
if (t0 < 0.0) t0 = 1.0 + t0
if (t0 >= t(m)) go to 50
il = 1
ir = m
!     Bisection search
10 i = (il + ir)/2
if (i == il) go to 40
nswc_ai_r4 = t0 - t(i)
if (nswc_ai_r4 < 0) go to 20
if (nswc_ai_r4 == 0) go to 40
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!     Computation when t(i) .LE. t0 .LT. t(i+1)
40 h = t(i + 1) - t(i)
dt = t0 - t(i)
do j = 1,n
   a = dx(i,j)
   d = (x(i + 1,j) - x(i,j))/h
   w = a + dx(i + 1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(j) = x(i,j) + dt*(a + dt*(b + dt*c))
   b = b + b
   c = 3.0*c
   dz(j) = a + dt*(b + c*dt)
   ddz(j) = b + (c + c)*dt
end do
return
!     Computation when t0 .GE. t(m)
50 h = 1.0 - t(m)
dt = t0 - t(m)
do j = 1,n
   a = dx(m,j)
   d = (x(1,j) - x(m,j))/h
   w = a + dx(1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(j) = x(m,j) + dt*(a + dt*(b + dt*c))
   b = b + b
   c = 3.0*c
   dz(j) = a + dt*(b + c*dt)
   ddz(j) = b + (c + c)*dt
end do
end subroutine lopdf

pure subroutine curv1(n,x,y,slp1,slpn,islpsw,yp,temp, &
   & sigma,ierr)
!! <!-- nswc-ford:begin CURV1 -->
!! Reference for `curv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine determines the parameters necessary to
!!  compute an interpolatory spline under tension through
!!  a sequence of functional values. The slopes at the two
!!  ends of the curve may be specified or omitted.  For actual
!!  computation of points on the curve it is necessary to call
!!  the function curv2.
!!  On input--
!!    n is the number of values to be interpolated (n.GE.2).
!!    x is an array of the n increasing abscissae of the
!!    functional values.
!!    y is an array of the n ordinates of the values, (I. E.
!!    y(K) is the functional value corresponding to x(K) ).
!!    slp1 and slpn contain the desired values for the first
!!    derivative of the curve at x(1) and x(n), respectively.
!!    The user may omit values for either or both of these
!!    parameters and signal this with islpsw.
!!    islpsw contains a switch indicating which slope data
!!    should be used and which should be estimated by this
!!    subroutine,
!!           = 0 If slp1 and slpn are to be used,
!!           = 1 If slp1 is to be used but not slpn,
!!           = 2 If slpn is to be used but not slp1,
!!           = 3 If both slp1 and slpn are to be estimated
!!               internally.
!!    yp is an array of length at least n.
!!    Temp is an array of length at least n which is used for
!!    scratch storage.
!!  And
!!    sigma contains the tension factor. This value indicates
!!    the curviness desired. If abs(sigma) is nearly zero
!!    (E.G. .001) the resulting curve is approximately A
!!    cubic spline. If abs(sigma) is large (E.G. 50.) The
!!    resulting curve is nearly a polygonal line. If sigma
!!    equals zero a cubic spline results.  A standard value
!!    for sigma is approximately 1. In absolute value.
!!  On output--
!!    yp contains the values of the second derivative of the
!!    curve at the given nodes.
!!    ierr contains an error flag,
!!         = 0 For normal return,
!!         = 1 If n is less than 2,
!!         = 2 If x-values are not strictly increasing.
!!  And
!!    n, x, y, slp1, slpn, islpsw and sigma are unaltered.
!!  This subroutine references package modules ceez, terms,
!!  and snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, islpsw
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n), slp1, slpn
real, intent(inout) :: yp(n), temp(n)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, ibak, nm1, np1
real :: c1, c2, c3, delx1, delx2, delxn, delxnm, diag, diag1, &
   & diag2, dx1, dx2, sdiag1, sdiag2, sigmap, slpp1, slppn
interface
   pure elemental subroutine ceez(del1,del2,sigma,c1,c2,c3,n)
      implicit none
      real, intent(in) :: del1
      real, intent(in) :: del2
      real, intent(in) :: sigma
      real, intent(inout) :: c1
      real, intent(inout) :: c2
      real, intent(inout) :: c3
      integer, intent(in) :: n
   end subroutine ceez
   pure elemental subroutine terms(diag,sdiag,sigma,del)
      implicit none
      real, intent(inout) :: diag
      real, intent(inout) :: sdiag
      real, intent(in) :: sigma
      real, intent(in) :: del
   end subroutine terms
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine determines the parameters necessary to
! compute an interpolatory spline under tension through
! a sequence of functional values. The slopes at the two
! ends of the curve may be specified or omitted.  For actual
! computation of points on the curve it is necessary to call
! the function curv2.
! On input--
!   n is the number of values to be interpolated (n.GE.2).
!   x is an array of the n increasing abscissae of the
!   functional values.
!   y is an array of the n ordinates of the values, (I. E.
!   y(K) is the functional value corresponding to x(K) ).
!   slp1 and slpn contain the desired values for the first
!   derivative of the curve at x(1) and x(n), respectively.
!   The user may omit values for either or both of these
!   parameters and signal this with islpsw.
!   islpsw contains a switch indicating which slope data
!   should be used and which should be estimated by this
!   subroutine,
!          = 0 If slp1 and slpn are to be used,
!          = 1 If slp1 is to be used but not slpn,
!          = 2 If slpn is to be used but not slp1,
!          = 3 If both slp1 and slpn are to be estimated
!              internally.
!   yp is an array of length at least n.
!   Temp is an array of length at least n which is used for
!   scratch storage.
! And
!   sigma contains the tension factor. This value indicates
!   the curviness desired. If abs(sigma) is nearly zero
!   (E.G. .001) the resulting curve is approximately A
!   cubic spline. If abs(sigma) is large (E.G. 50.) The
!   resulting curve is nearly a polygonal line. If sigma
!   equals zero a cubic spline results.  A standard value
!   for sigma is approximately 1. In absolute value.
! On output--
!   yp contains the values of the second derivative of the
!   curve at the given nodes.
!   ierr contains an error flag,
!        = 0 For normal return,
!        = 1 If n is less than 2,
!        = 2 If x-values are not strictly increasing.
! And
!   n, x, y, slp1, slpn, islpsw and sigma are unaltered.
! This subroutine references package modules ceez, terms,
! and snhcsh.
!-----------------------------------------------------------
nm1 = n - 1
np1 = n + 1
ierr = 0
if (n <= 1) go to 8
if (x(n) <= x(1)) go to 9
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/(x(n) - x(1))
! Approximate end slopes
if (islpsw >= 2) go to 1
slpp1 = slp1
go to 2
1 delx1 = x(2) - x(1)
delx2 = delx1 + delx1
if (n > 2) delx2 = x(3) - x(1)
if (delx1 <= 0. .or. delx2 <= delx1) go to 9
call ceez(delx1,delx2,sigmap,c1,c2,c3,n)
slpp1 = c1*y(1) + c2*y(2)
if (n > 2) slpp1 = slpp1 + c3*y(3)
2 if (islpsw == 1 .or. islpsw == 3) go to 3
slppn = slpn
go to 4
3 delxn = x(n) - x(nm1)
delxnm = delxn + delxn
if (n > 2) delxnm = x(n) - x(n - 2)
if (delxn <= 0. .or. delxnm <= delxn) go to 9
call ceez(-delxn,-delxnm,sigmap,c1,c2,c3,n)
slppn = c1*y(n) + c2*y(nm1)
if (n > 2) slppn = slppn + c3*y(n - 2)
! Set up right hand side and tridiagonal system for yp and
! perform forward elimination
4 delx1 = x(2) - x(1)
if (delx1 <= 0.) go to 9
dx1 = (y(2) - y(1))/delx1
call terms(diag1,sdiag1,sigmap,delx1)
yp(1) = (dx1 - slpp1)/diag1
temp(1) = sdiag1/diag1
if (n == 2) go to 6
do i = 2,nm1
   delx2 = x(i + 1) - x(i)
   if (delx2 <= 0.) go to 9
   dx2 = (y(i + 1) - y(i))/delx2
   call terms(diag2,sdiag2,sigmap,delx2)
   diag = diag1 + diag2 - sdiag1*temp(i - 1)
   yp(i) = (dx2 - dx1 - sdiag1*yp(i - 1))/diag
   temp(i) = sdiag2/diag
   dx1 = dx2
   diag1 = diag2
   sdiag1 = sdiag2
end do
6 diag = diag1 - sdiag1*temp(nm1)
yp(n) = (slppn - dx1 - sdiag1*yp(nm1))/diag
! Perform back substitution
do i = 2,n
   ibak = np1 - i
   yp(ibak) = yp(ibak) - temp(ibak)*yp(ibak + 1)
end do
return
! Too few points
8 ierr = 1
return
! x-values not strictly increasing
9 ierr = 2
end subroutine curv1

pure function curv2(t,n,x,y,yp,sigma)
!! <!-- nswc-ford:begin CURV2 -->
!! Reference for `curv2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this function interpolates a curve at a given point
!!  using a spline under tension. The subroutine curv1 should
!!  be called earlier to determine certain necessary
!!  parameters.
!!  On input--
!!    t contains a real value to be mapped onto the interpo-
!!    LATING curve.
!!    n contains the number of points which were specified to
!!    determine the curve.
!!    x and y are arrays containing the abscissae and
!!    ordinates, respectively, of the specified points.
!!    yp is an array of second derivative values of the curve
!!    at the nodes.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters n, x, y, yp, and sigma should be input
!!  unaltered from the output of curv1.
!!  On output--
!!    curv2 contains the interpolated value.
!!  None of the input parameters are altered.
!!  This function references package modules intrvl and
!!  snhcsh.
!!
!!  Determine interval
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: t, x(n), y(n), yp(n), sigma
real :: curv2
!     beginning of local variable declarations
integer :: i, im1
real :: coshp1, coshp2, del1, del2, delp1, delp2, dels, dummy, &
   & sigmap, sinhm1, sinhm2, sinhms, sinhp1, sinhp2, sum
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this function interpolates a curve at a given point
! using a spline under tension. The subroutine curv1 should
! be called earlier to determine certain necessary
! parameters.
! On input--
!   t contains a real value to be mapped onto the interpo-
!   LATING curve.
!   n contains the number of points which were specified to
!   determine the curve.
!   x and y are arrays containing the abscissae and
!   ordinates, respectively, of the specified points.
!   yp is an array of second derivative values of the curve
!   at the nodes.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters n, x, y, yp, and sigma should be input
! unaltered from the output of curv1.
! On output--
!   curv2 contains the interpolated value.
! None of the input parameters are altered.
! This function references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Determine interval
im1 = intrvl(t,x,n)
i = im1 + 1
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/(x(n) - x(1))
! Set up and perform interpolation
del1 = t - x(im1)
del2 = x(i) - t
dels = x(i) - x(im1)
sum = (y(i)*del1 + y(im1)*del2)/dels
if (sigmap /= 0.) go to 1
curv2 = sum - del1*del2*(yp(i)*(del1 + dels) + yp(im1)* &
   & (del2 + dels))/(6.*dels)
return
1 delp1 = sigmap*(del1 + dels)/2.
delp2 = sigmap*(del2 + dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh(sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh(sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh(dummy,coshp1,delp1,1)
call snhcsh(dummy,coshp2,delp2,1)
curv2 = sum + (yp(i)*(sinhm1*del2 - del1*(2.*(coshp1 + 1.)* &
   & sinhp2 + sigmap*coshp1*del2)) + yp(im1)*(sinhm2* &
   & del1 - del2*(2.*(coshp2 + 1.)*sinhp1 + sigmap* &
   & coshp2*del1)))/(sigmap*sigmap*dels*(sinhms + &
   & sigmap*dels))
end function curv2

pure function curvd(t,n,x,y,yp,sigma)
!! <!-- nswc-ford:begin CURVD -->
!! Reference for `curvd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this function differentiates a curve at a given point
!!  using a spline under tension. The subroutine curv1 should
!!  be called earlier to determine certain necessary
!!  parameters.
!!  On input--
!!    t contains a real value at which the derivative is to be
!!    determined.
!!    n contains the number of points which were specified to
!!    determine the curve.
!!    x and y are arrays containing the abscissae and
!!    ordinates, respectively, of the specified points.
!!    yp is an array of second derivative values of the curve
!!    at the nodes.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters n, x, y, yp, and sigma should be input
!!  unaltered from the output of curv1.
!!  On output--
!!    curvd contains the derivative value.
!!  None of the input parameters are altered.
!!  This function references package modules intrvl and
!!  snhcsh.
!!
!!  Determine interval
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: t, x(n), y(n), yp(n), sigma
real :: curvd
!     beginning of local variable declarations
integer :: i, im1
real :: coshm1, coshm2, del1, del2, dels, dummy, sigmap, sinhms, &
   & sum
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this function differentiates a curve at a given point
! using a spline under tension. The subroutine curv1 should
! be called earlier to determine certain necessary
! parameters.
! On input--
!   t contains a real value at which the derivative is to be
!   determined.
!   n contains the number of points which were specified to
!   determine the curve.
!   x and y are arrays containing the abscissae and
!   ordinates, respectively, of the specified points.
!   yp is an array of second derivative values of the curve
!   at the nodes.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters n, x, y, yp, and sigma should be input
! unaltered from the output of curv1.
! On output--
!   curvd contains the derivative value.
! None of the input parameters are altered.
! This function references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Determine interval
im1 = intrvl(t,x,n)
i = im1 + 1
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/(x(n) - x(1))
! Set up and perform differentiation
del1 = t - x(im1)
del2 = x(i) - t
dels = x(i) - x(im1)
sum = (y(i) - y(im1))/dels
if (sigmap /= 0.) go to 1
curvd = sum + (yp(i)*(2.*del1*del1 - del2*(del1 + dels)) - &
   & yp(im1)*(2.*del2*del2 - del1*(del2 + dels))) &
   & /(6.*dels)
return
1 call snhcsh(dummy,coshm1,sigmap*del1,1)
call snhcsh(dummy,coshm2,sigmap*del2,1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
curvd = sum + (yp(i)*(dels*sigmap*coshm1 - sinhms) - &
   & yp(im1)*(dels*sigmap*coshm2 - sinhms))/ &
   & (sigmap*sigmap*dels*(sinhms + sigmap*dels))
end function curvd

pure function curvi(xl,xu,n,x,y,yp,sigma)
!! <!-- nswc-ford:begin CURVI -->
!! Reference for `curvi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this function integrates a curve specified by a spline
!!  under tension between two given limits. The subroutine
!!  curv1 should be called earlier to determine necessary
!!  parameters.
!!  On input--
!!    xl and xu contain the lower and upper limits of inte-
!!    gration, respectively. (xl need not be less than or
!!    equal to xu, curvi (xl,xu,...) .EQ. -curvi (xu,xl,...) ).
!!    n contains the number of points which were specified to
!!    determine the curve.
!!    x and y are arrays containing the abscissae and
!!    ordinates, respectively, of the specified points.
!!    yp is an array of second derivative values of the curve
!!    at the nodes.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters n, x, y, yp, and sigma should be input
!!  unaltered from the output of curv1.
!!  On output--
!!    curvi contains the integral value.
!!  None of the input parameters are altered.
!!  This function references package modules intrvl and
!!  snhcsh.
!!
!!  Statement function for coefficient associated with
!!  derivative terms
!!  Denormalize tension factor
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: xl, xu, x(n), y(n), yp(n), sigma
real :: curvi
!     beginning of local variable declarations
integer :: i, il, ilm1, ilp1, iu, ium1
real :: c1, c2, cl1, cl2, cmm1, cmm2, cs, cu1, cu2, del1, del2, &
   & deli, dell1, dell2, dels, delu1, delu2, dummy, sigmap, ss, ssign, &
   & sum, t, t1, t2, xxl, xxu
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this function integrates a curve specified by a spline
! under tension between two given limits. The subroutine
! curv1 should be called earlier to determine necessary
! parameters.
! On input--
!   xl and xu contain the lower and upper limits of inte-
!   gration, respectively. (xl need not be less than or
!   equal to xu, curvi (xl,xu,...) .EQ. -curvi (xu,xl,...) ).
!   n contains the number of points which were specified to
!   determine the curve.
!   x and y are arrays containing the abscissae and
!   ordinates, respectively, of the specified points.
!   yp is an array of second derivative values of the curve
!   at the nodes.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters n, x, y, yp, and sigma should be input
! unaltered from the output of curv1.
! On output--
!   curvi contains the integral value.
! None of the input parameters are altered.
! This function references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Statement function for coefficient associated with
! derivative terms
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/(x(n) - x(1))
! Determine actual upper and lower bounds
xxl = xl
xxu = xu
ssign = 1.
if (xl < xu) go to 1
xxl = xu
xxu = xl
ssign = -1.
if (xl > xu) go to 1
! RETURN ZERO IF xl .EQ. xu
curvi = 0.
return
! Search for proper intervals
1 ilm1 = intrvl(xxl,x,n)
il = ilm1 + 1
ium1 = intrvl(xxu,x,n)
iu = ium1 + 1
if (il == iu) go to 8
! Integrate from xxl to x(il)
sum = 0.
if (xxl == x(il)) go to 3
del1 = xxl - x(ilm1)
del2 = x(il) - xxl
dels = x(il) - x(ilm1)
t1 = (del1 + dels)*del2/(2.*dels)
t2 = del2*del2/(2.*dels)
sum = t1*y(il) + t2*y(ilm1)
if (sigma == 0.) go to 2
call snhcsh(dummy,c1,sigmap*del1,2)
call snhcsh(dummy,c2,sigmap*del2,2)
call snhcsh(ss,cs,sigmap*dels,3)
sum = sum + term(cs,c1,t1)*yp(il) &
   & + term(c2,0.,t2)*yp(ilm1)
go to 3
2 sum = sum - t1*t1*dels*yp(il)/6. &
   & - t2*(del1*(del2 + dels) + dels*dels)*yp(ilm1)/12.
! Integrate over interior intervals
3 if (iu - il == 1) go to 6
ilp1 = il + 1
do i = ilp1,ium1
   dels = x(i) - x(i - 1)
   sum = sum + (y(i) + y(i - 1))*dels/2.
   if (sigma == 0.) go to 4
   call snhcsh(ss,cs,sigmap*dels,3)
   sum = sum + (yp(i) + yp(i - 1))*(cs - ss*sigmap*dels/2.)/ &
      & (sigmap*sigmap*sigmap*(ss + sigmap*dels))
   go to 5
4  sum = sum - (yp(i) + yp(i - 1))*dels*dels*dels/24.
5  continue
end do
! Integrate from x(iu-1) to XXU
6 if (xxu == x(ium1)) go to 10
del1 = xxu - x(ium1)
del2 = x(iu) - xxu
dels = x(iu) - x(ium1)
t1 = del1*del1/(2.*dels)
t2 = (del2 + dels)*del1/(2.*dels)
sum = sum + t1*y(iu) + t2*y(ium1)
if (sigma == 0.) go to 7
call snhcsh(dummy,c1,sigmap*del1,2)
call snhcsh(dummy,c2,sigmap*del2,2)
call snhcsh(ss,cs,sigmap*dels,3)
sum = sum + term(c1,0.,t1)*yp(iu) &
   & + term(cs,c2,t2)*yp(ium1)
go to 10
7 sum = sum - t1*(del2*(del1 + dels) + dels*dels)*yp(iu)/12. &
   & - t2*t2*dels*yp(ium1)/6.
go to 10
! Integrate from xxl to XXU
8 delu1 = xxu - x(ium1)
delu2 = x(iu) - xxu
dell1 = xxl - x(ium1)
dell2 = x(iu) - xxl
dels = x(iu) - x(ium1)
deli = xxu - xxl
t1 = (delu1 + dell1)*deli/(2.*dels)
t2 = (delu2 + dell2)*deli/(2.*dels)
sum = t1*y(iu) + t2*y(ium1)
if (sigma == 0.) go to 9
call snhcsh(dummy,cu1,sigmap*delu1,2)
call snhcsh(dummy,cu2,sigmap*delu2,2)
call snhcsh(dummy,cl1,sigmap*dell1,2)
call snhcsh(dummy,cl2,sigmap*dell2,2)
call snhcsh(ss,dummy,sigmap*dels,-1)
sum = sum + term(cu1,cl1,t1)*yp(iu) &
   & + term(cl2,cu2,t2)*yp(ium1)
go to 10
9 sum = sum - t1*(delu2*(dels + delu1) + dell2*(dels + dell1))* &
   & yp(iu)/12. &
   & - t2*(dell1*(dels + dell2) + delu1*(dels + delu2))* &
   & yp(ium1)/12.
! Correct sign and return
10 curvi = ssign*sum
contains
   pure function term(cmm1, cmm2, t) result(nswc_sf_result)
      implicit none
      real, intent(in) :: cmm1
      real, intent(in) :: cmm2
      real, intent(in) :: t
      real :: nswc_sf_result
      nswc_sf_result = (cmm1 - cmm2 - sigmap*t*ss)/(sigmap*   sigmap*sigmap*(ss + sigmap*dels))
   end function term
end function curvi

pure subroutine kurv1(n,x,y,slp1,slpn,islpsw,xp,yp,temp,s, &
   & sigma,ierr)
!! <!-- nswc-ford:begin KURV1 -->
!! Reference for `kurv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine determines the parameters necessary to
!!  compute a spline under tension forming a curve in the
!!  plane and passing through a sequence of pairs (x(1),y(1)),
!!  ...,(x(n),y(n)). For actual computation of points on the
!!  curve it is necessary to call the subroutine kurv2.
!!  On input--
!!    n is the number of points to be interpolated (n.GE.2).
!!    x is an array containing the n x-coordinates of the
!!    points.
!!    y is an array containing the n y-coordinates of the
!!    points. (Adjacent x-y pairs must be distinct, I. E.
!!    Either x(i) .NE. x(i+1) or y(i) .NE. y(i+1), for
!!    i = 1,...,n-1.)
!!    slp1 and slpn contain the desired values for the angles
!!    (in radians) of the slope at (x(1),y(1)) and (x(n),y(n))
!!    respectively. The angles are measured counter-clock-
!!    wise from the x-axis and the positive sense of the curve
!!    is assumed to be that moving from point 1 to point n.
!!    The user may omit values for either or both of these
!!    parameters and signal this with islpsw.
!!    islpsw contains a switch indicating which slope data
!!    should be used and which should be estimated by this
!!    subroutine,
!!           = 0 If slp1 and slpn are to be used,
!!           = 1 If slp1 is to be used but not slpn,
!!           = 2 If slpn is to be used but not slp1,
!!           = 3 If both slp1 and slpn are to be estimated
!!               internally.
!!    xp and yp are arrays of length at least n.
!!    Temp is an array of length at least n which is used
!!    for scratch storage.
!!    s is an array of length at least n.
!!  And
!!    sigma contains the tension factor. This value indicates
!!    the curviness desired. If abs(sigma) is nearly zero
!!    (E.G. .001) the resulting curve is approximately a cubic
!!    spline. If abs(sigma) is large (E. G. 50.) The resulting
!!    curve is nearly a polygonal line. If sigma equals zero A
!!    cubic spline results. A standard value for sigma is
!!    approximately 1. In absolute value.
!!  On output--
!!    xp and yp contain information about the curvature of the
!!    curve at the given nodes.
!!    s contains the polygonal arclengths of the curve.
!!    ierr contains an error flag,
!!         = 0 For normal return,
!!         = 1 If n is less than 2,
!!         = 2 If adjacent coordinate pairs coincide.
!!  And
!!    n, x, y, slp1, slpn, islpsw, and sigma are unaltered.
!!  This subroutine references package modules ceez, terms,
!!  and snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, islpsw
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n), slp1, slpn
real, intent(inout) :: xp(n), yp(n), temp(n), s(n)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, ibak, im1, nm1, np1
real :: c1, c2, c3, dels1, dels2, delsn, delsnm, delt, diag, &
   & diag1, diag2, diagin, dx1, dx2, dy1, dy2, sdiag1, sdiag2, sigmap, &
   & slpp1x, slpp1y, slppnx, slppny, sx, sy
interface
   pure elemental subroutine ceez(del1,del2,sigma,c1,c2,c3,n)
      implicit none
      real, intent(in) :: del1
      real, intent(in) :: del2
      real, intent(in) :: sigma
      real, intent(inout) :: c1
      real, intent(inout) :: c2
      real, intent(inout) :: c3
      integer, intent(in) :: n
   end subroutine ceez
   pure elemental subroutine terms(diag,sdiag,sigma,del)
      implicit none
      real, intent(inout) :: diag
      real, intent(inout) :: sdiag
      real, intent(in) :: sigma
      real, intent(in) :: del
   end subroutine terms
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine determines the parameters necessary to
! compute a spline under tension forming a curve in the
! plane and passing through a sequence of pairs (x(1),y(1)),
! ...,(x(n),y(n)). For actual computation of points on the
! curve it is necessary to call the subroutine kurv2.
! On input--
!   n is the number of points to be interpolated (n.GE.2).
!   x is an array containing the n x-coordinates of the
!   points.
!   y is an array containing the n y-coordinates of the
!   points. (Adjacent x-y pairs must be distinct, I. E.
!   Either x(i) .NE. x(i+1) or y(i) .NE. y(i+1), for
!   i = 1,...,n-1.)
!   slp1 and slpn contain the desired values for the angles
!   (in radians) of the slope at (x(1),y(1)) and (x(n),y(n))
!   respectively. The angles are measured counter-clock-
!   wise from the x-axis and the positive sense of the curve
!   is assumed to be that moving from point 1 to point n.
!   The user may omit values for either or both of these
!   parameters and signal this with islpsw.
!   islpsw contains a switch indicating which slope data
!   should be used and which should be estimated by this
!   subroutine,
!          = 0 If slp1 and slpn are to be used,
!          = 1 If slp1 is to be used but not slpn,
!          = 2 If slpn is to be used but not slp1,
!          = 3 If both slp1 and slpn are to be estimated
!              internally.
!   xp and yp are arrays of length at least n.
!   Temp is an array of length at least n which is used
!   for scratch storage.
!   s is an array of length at least n.
! And
!   sigma contains the tension factor. This value indicates
!   the curviness desired. If abs(sigma) is nearly zero
!   (E.G. .001) the resulting curve is approximately a cubic
!   spline. If abs(sigma) is large (E. G. 50.) The resulting
!   curve is nearly a polygonal line. If sigma equals zero A
!   cubic spline results. A standard value for sigma is
!   approximately 1. In absolute value.
! On output--
!   xp and yp contain information about the curvature of the
!   curve at the given nodes.
!   s contains the polygonal arclengths of the curve.
!   ierr contains an error flag,
!        = 0 For normal return,
!        = 1 If n is less than 2,
!        = 2 If adjacent coordinate pairs coincide.
! And
!   n, x, y, slp1, slpn, islpsw, and sigma are unaltered.
! This subroutine references package modules ceez, terms,
! and snhcsh.
!-----------------------------------------------------------
nm1 = n - 1
np1 = n + 1
ierr = 0
if (n <= 1) go to 11
! Determine polygonal arclengths
s(1) = 0.
do i = 2,n
   im1 = i - 1
   s(i) = s(im1) + sqrt((x(i) - x(im1))**2 + &
      & (y(i) - y(im1))**2)
end do
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/s(n)
! Approximate end slopes
if (islpsw >= 2) go to 2
slpp1x = cos(slp1)
slpp1y = sin(slp1)
go to 4
2 dels1 = s(2) - s(1)
dels2 = dels1 + dels1
if (n > 2) dels2 = s(3) - s(1)
if (dels1 == 0. .or. dels2 == 0.) go to 12
call ceez(dels1,dels2,sigmap,c1,c2,c3,n)
sx = c1*x(1) + c2*x(2)
sy = c1*y(1) + c2*y(2)
if (n == 2) go to 3
sx = sx + c3*x(3)
sy = sy + c3*y(3)
3 delt = sqrt(sx*sx + sy*sy)
slpp1x = sx/delt
slpp1y = sy/delt
4 if (islpsw == 1 .or. islpsw == 3) go to 5
slppnx = cos(slpn)
slppny = sin(slpn)
go to 7
5 delsn = s(n) - s(nm1)
delsnm = delsn + delsn
if (n > 2) delsnm = s(n) - s(n - 2)
if (delsn == 0. .or. delsnm == 0.) go to 12
call ceez(-delsn,-delsnm,sigmap,c1,c2,c3,n)
sx = c1*x(n) + c2*x(nm1)
sy = c1*y(n) + c2*y(nm1)
if (n == 2) go to 6
sx = sx + c3*x(n - 2)
sy = sy + c3*y(n - 2)
6 delt = sqrt(sx*sx + sy*sy)
slppnx = sx/delt
slppny = sy/delt
! Set up right hand sides and tridiagonal system for xp and
! yp and perform forward elimination
7 dx1 = (x(2) - x(1))/s(2)
dy1 = (y(2) - y(1))/s(2)
call terms(diag1,sdiag1,sigmap,s(2))
xp(1) = (dx1 - slpp1x)/diag1
yp(1) = (dy1 - slpp1y)/diag1
temp(1) = sdiag1/diag1
if (n == 2) go to 9
do i = 2,nm1
   dels2 = s(i + 1) - s(i)
   if (dels2 == 0.) go to 12
   dx2 = (x(i + 1) - x(i))/dels2
   dy2 = (y(i + 1) - y(i))/dels2
   call terms(diag2,sdiag2,sigmap,dels2)
   diag = diag1 + diag2 - sdiag1*temp(i - 1)
   diagin = 1./diag
   xp(i) = (dx2 - dx1 - sdiag1*xp(i - 1))*diagin
   yp(i) = (dy2 - dy1 - sdiag1*yp(i - 1))*diagin
   temp(i) = sdiag2*diagin
   dx1 = dx2
   dy1 = dy2
   diag1 = diag2
   sdiag1 = sdiag2
end do
9 diag = diag1 - sdiag1*temp(nm1)
xp(n) = (slppnx - dx1 - sdiag1*xp(nm1))/diag
yp(n) = (slppny - dy1 - sdiag1*yp(nm1))/diag
! Perform back substitution
do i = 2,n
   ibak = np1 - i
   xp(ibak) = xp(ibak) - temp(ibak)*xp(ibak + 1)
   yp(ibak) = yp(ibak) - temp(ibak)*yp(ibak + 1)
end do
return
! Too few points
11 ierr = 1
return
! Coincident adjacent points
12 ierr = 2
end subroutine kurv1

pure subroutine kurv2(t,xs,ys,n,x,y,xp,yp,s,sigma)
!! <!-- nswc-ford:begin KURV2 -->
!! Reference for `kurv2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine performs the mapping of points in the
!!  interval (0.,1.) Onto a curve in the plane. The subroutine
!!  kurv1 should be called earlier to determine certain
!!  necessary parameters. The resulting curve has a parametric
!!  representation both of whose components are splines under
!!  tension and functions of the polygonal arclength
!!  parameter.
!!  On input--
!!    t contains a real value to be mapped to a point on the
!!    curve. The interval (0.,1.) Is mapped onto the entire
!!    curve, with 0. Mapping to (x(1),y(1)) and 1. Mapping
!!    to (x(n),y(n)). Values outside this interval result in
!!    extrapolation.
!!    n contains the number of points which were specified
!!    to determine the curve.
!!    x and y are arrays containing the x- and y-coordinates
!!    of the specified points.
!!    xp and yp are the arrays output from kurv1 containing
!!    curvature information.
!!    s is an array containing the polygonal arclengths of
!!    the curve.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters n, x, y, xp, yp, s, and sigma should be
!!  input unaltered from the output of kurv1.
!!  On output--
!!    xs and ys contain the x- and y-coordinates of the image
!!    point on the curve.
!!  None of the input parameters are altered.
!!  This subroutine references package modules intrvl and
!!  snhcsh.
!!
!!  Determine interval
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: t
real, intent(inout) :: xs, ys
real, intent(in) :: x(n), y(n), xp(n), yp(n), s(n), sigma
!     beginning of local variable declarations
integer :: i, im1
real :: c1, c2, coshp1, coshp2, d, del1, del2, delp1, delp2, dels, &
   & dummy, sigmap, sinhm1, sinhm2, sinhms, sinhp1, sinhp2, sumx, sumy, &
   & tn
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine performs the mapping of points in the
! interval (0.,1.) Onto a curve in the plane. The subroutine
! kurv1 should be called earlier to determine certain
! necessary parameters. The resulting curve has a parametric
! representation both of whose components are splines under
! tension and functions of the polygonal arclength
! parameter.
! On input--
!   t contains a real value to be mapped to a point on the
!   curve. The interval (0.,1.) Is mapped onto the entire
!   curve, with 0. Mapping to (x(1),y(1)) and 1. Mapping
!   to (x(n),y(n)). Values outside this interval result in
!   extrapolation.
!   n contains the number of points which were specified
!   to determine the curve.
!   x and y are arrays containing the x- and y-coordinates
!   of the specified points.
!   xp and yp are the arrays output from kurv1 containing
!   curvature information.
!   s is an array containing the polygonal arclengths of
!   the curve.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters n, x, y, xp, yp, s, and sigma should be
! input unaltered from the output of kurv1.
! On output--
!   xs and ys contain the x- and y-coordinates of the image
!   point on the curve.
! None of the input parameters are altered.
! This subroutine references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Determine interval
tn = s(n)*t
im1 = intrvl(tn,s,n)
i = im1 + 1
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/s(n)
! Set up and perform interpolation
del1 = tn - s(im1)
del2 = s(i) - tn
dels = s(i) - s(im1)
sumx = (x(i)*del1 + x(im1)*del2)/dels
sumy = (y(i)*del1 + y(im1)*del2)/dels
if (sigmap /= 0.) go to 1
d = del1*del2/(6.*dels)
c1 = (del1 + dels)*d
c2 = (del2 + dels)*d
xs = sumx - xp(i)*c1 - xp(im1)*c2
ys = sumy - yp(i)*c1 - yp(im1)*c2
return
1 delp1 = sigmap*(del1 + dels)/2.
delp2 = sigmap*(del2 + dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh(sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh(sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh(dummy,coshp1,delp1,1)
call snhcsh(dummy,coshp2,delp2,1)
d = sigmap*sigmap*dels*(sinhms + sigmap*dels)
c1 = (sinhm1*del2 - del1*(2.*(coshp1 + 1.)*sinhp2 + sigmap* &
   & coshp1*del2))/d
c2 = (sinhm2*del1 - del2*(2.*(coshp2 + 1.)*sinhp1 + sigmap* &
   & coshp2*del1))/d
xs = sumx + xp(i)*c1 + xp(im1)*c2
ys = sumy + yp(i)*c1 + yp(im1)*c2
end subroutine kurv2

pure subroutine kurvp1(n,x,y,xp,yp,temp,s,sigma,ierr)
!! <!-- nswc-ford:begin KURVP1 -->
!! Reference for `kurvp1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine determines the parameters necessary to
!!  compute a spline under tension forming a closed curve in
!!  the plane and passing through a sequence of pairs
!!  (x(1),y(1)),...,(x(n),y(n)). For actual computation of
!!  points on the curve it is necessary to call the subroutine
!!  kurvp2.
!!  On input--
!!    n is the number of points to be interpolated (n.GE.2).
!!    x is an array containing the n x-coordinates of the
!!    points.
!!    y is an array containing the n y-coordinates of the
!!    points. (Adjacent x-y pairs must be distinct, I. E.
!!    Either x(i) .NE. x(i+1) or y(i) .NE. y(i+1), for
!!    i = 1,...,n-1.)
!!    xp and yp are arrays of length at least n.
!!    Temp is an array of length at least 2*n which is used
!!    for scratch storage.
!!    s is an array of length at least n.
!!  And
!!    sigma contains the tension factor. This value indicates
!!    the curviness desired. If abs(sigma) is nearly zero
!!    (E.G. .001) the resulting curve is approximately a cubic
!!    spline. If abs(sigma) is large (E. G. 50.) The resulting
!!    curve is nearly a polygonal line. If sigma equals zero A
!!    cubic spline results. A standard value for sigma is
!!    approximately 1. In absolute value.
!!  On output--
!!    xp and yp contain information about the curvature of the
!!    curve at the given nodes.
!!    s contains the polygonal arclengths of the curve.
!!    ierr contains an error flag,
!!         = 0 For normal return,
!!         = 1 If n is less than 2,
!!         = 2 If adjacent coordinate pairs coincide.
!!  And
!!    n, x, y, and sigma are unaltered,
!!  this subroutine references package modules terms and
!!  snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n)
real, intent(inout) :: xp(n), yp(n), temp(*), s(n)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, ibak, im1, nm1, np1, npi, npibak
real :: dels1, dels2, diag, diag1, diag2, diagin, dx1, dx2, dy1, &
   & dy2, sdiag1, sdiag2, sigmap, xpn, ypn
interface
   pure elemental subroutine terms(diag,sdiag,sigma,del)
      implicit none
      real, intent(inout) :: diag
      real, intent(inout) :: sdiag
      real, intent(in) :: sigma
      real, intent(in) :: del
   end subroutine terms
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine determines the parameters necessary to
! compute a spline under tension forming a closed curve in
! the plane and passing through a sequence of pairs
! (x(1),y(1)),...,(x(n),y(n)). For actual computation of
! points on the curve it is necessary to call the subroutine
! kurvp2.
! On input--
!   n is the number of points to be interpolated (n.GE.2).
!   x is an array containing the n x-coordinates of the
!   points.
!   y is an array containing the n y-coordinates of the
!   points. (Adjacent x-y pairs must be distinct, I. E.
!   Either x(i) .NE. x(i+1) or y(i) .NE. y(i+1), for
!   i = 1,...,n-1.)
!   xp and yp are arrays of length at least n.
!   Temp is an array of length at least 2*n which is used
!   for scratch storage.
!   s is an array of length at least n.
! And
!   sigma contains the tension factor. This value indicates
!   the curviness desired. If abs(sigma) is nearly zero
!   (E.G. .001) the resulting curve is approximately a cubic
!   spline. If abs(sigma) is large (E. G. 50.) The resulting
!   curve is nearly a polygonal line. If sigma equals zero A
!   cubic spline results. A standard value for sigma is
!   approximately 1. In absolute value.
! On output--
!   xp and yp contain information about the curvature of the
!   curve at the given nodes.
!   s contains the polygonal arclengths of the curve.
!   ierr contains an error flag,
!        = 0 For normal return,
!        = 1 If n is less than 2,
!        = 2 If adjacent coordinate pairs coincide.
! And
!   n, x, y, and sigma are unaltered,
! this subroutine references package modules terms and
! snhcsh.
!-----------------------------------------------------------
nm1 = n - 1
np1 = n + 1
ierr = 0
if (n <= 1) go to 7
! Determine polygonal arclengths
s(1) = sqrt((x(n) - x(1))**2 + (y(n) - y(1))**2)
do i = 2,n
   im1 = i - 1
   s(i) = s(im1) + sqrt((x(i) - x(im1))**2 + &
      & (y(i) - y(im1))**2)
end do
! Denormalize tension factor
sigmap = abs(sigma)*float(n)/s(n)
! Set up right hand sides of tridiagonal (with corner
! elements) linear system for xp and yp
dels1 = s(1)
if (dels1 == 0.) go to 8
dx1 = (x(1) - x(n))/dels1
dy1 = (y(1) - y(n))/dels1
call terms(diag1,sdiag1,sigmap,dels1)
dels2 = s(2) - s(1)
if (dels2 == 0.) go to 8
dx2 = (x(2) - x(1))/dels2
dy2 = (y(2) - y(1))/dels2
call terms(diag2,sdiag2,sigmap,dels2)
diag = diag1 + diag2
diagin = 1./diag
xp(1) = (dx2 - dx1)*diagin
yp(1) = (dy2 - dy1)*diagin
temp(np1) = -sdiag1*diagin
temp(1) = sdiag2*diagin
dx1 = dx2
dy1 = dy2
diag1 = diag2
sdiag1 = sdiag2
if (n == 2) go to 3
do i = 2,nm1
   npi = n + i
   dels2 = s(i + 1) - s(i)
   if (dels2 == 0.) go to 8
   dx2 = (x(i + 1) - x(i))/dels2
   dy2 = (y(i + 1) - y(i))/dels2
   call terms(diag2,sdiag2,sigmap,dels2)
   diag = diag1 + diag2 - sdiag1*temp(i - 1)
   diagin = 1./diag
   xp(i) = (dx2 - dx1 - sdiag1*xp(i - 1))*diagin
   yp(i) = (dy2 - dy1 - sdiag1*yp(i - 1))*diagin
   temp(npi) = -temp(npi - 1)*sdiag1*diagin
   temp(i) = sdiag2*diagin
   dx1 = dx2
   dy1 = dy2
   diag1 = diag2
   sdiag1 = sdiag2
end do
3 dels2 = s(1)
dx2 = (x(1) - x(n))/dels2
dy2 = (y(1) - y(n))/dels2
call terms(diag2,sdiag2,sigmap,dels2)
xp(n) = dx2 - dx1
yp(n) = dy2 - dy1
temp(nm1) = temp(2*n - 1) - temp(nm1)
if (n == 2) go to 5
! Perform first step of back substitution
do i = 3,n
   ibak = np1 - i
   npibak = n + ibak
   xp(ibak) = xp(ibak) - temp(ibak)*xp(ibak + 1)
   yp(ibak) = yp(ibak) - temp(ibak)*yp(ibak + 1)
   temp(ibak) = temp(npibak) - temp(ibak)*temp(ibak + 1)
end do
5 xp(n) = (xp(n) - sdiag2*xp(1) - sdiag1*xp(nm1))/ &
   & (diag1 + diag2 + sdiag2*temp(1) + sdiag1*temp(nm1))
yp(n) = (yp(n) - sdiag2*yp(1) - sdiag1*yp(nm1))/ &
   & (diag1 + diag2 + sdiag2*temp(1) + sdiag1*temp(nm1))
! Perform second step of back substitution
xpn = xp(n)
ypn = yp(n)
do i = 1,nm1
   xp(i) = xp(i) + temp(i)*xpn
   yp(i) = yp(i) + temp(i)*ypn
end do
return
! Too few points
7 ierr = 1
return
! Coincident adjacent points
8 ierr = 2
end subroutine kurvp1

pure subroutine kurvp2(t,xs,ys,n,x,y,xp,yp,s,sigma)
!! <!-- nswc-ford:begin KURVP2 -->
!! Reference for `kurvp2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine performs the mapping of points in the
!!  interval (0.,1.) Onto a closed curve in the plane. The
!!  subroutine kurvp1 should be called earlier to determine
!!  certain necessary parameters. The resulting curve has A
!!  parametric representation both of whose components are
!!  periodic splines under tension and functions of the poly-
!!  gonal arclength parameter.
!!  On input--
!!    t contains a value to be mapped onto the curve. The
!!    interval (0.,1.) Is mapped onto the entire closed curve
!!    with both 0. And 1. Mapping to (x(1),y(1)). The mapping
!!    is periodic with period one thus any interval of the
!!    form (TT,TT+1.) Maps onto the entire curve.
!!    n contains the number of points which were specified
!!    to determine the curve.
!!    x and y are arrays containing the x- and y-coordinates
!!    of the specified points.
!!    xp and yp are the arrays output from kurvp1 containing
!!    curvature information.
!!    s is an array containing the polygonal arclengths of
!!    the curve.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters n, x, y, xp, yp, s and sigma should
!!  be input unaltered from the output of kurvp1.
!!  On output--
!!    xs and ys contain the x- and y-coordinates of the image
!!    point on the curve.
!!  None of the input parameters are altered.
!!  This subroutine references package modules intrvl and
!!  snhcsh.
!!
!!  Determine interval
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: t
real, intent(inout) :: xs, ys
real, intent(in) :: x(n), y(n), xp(n), yp(n), s(n), sigma
!     beginning of local variable declarations
integer :: i, im1
real :: c1, c2, ci, cim1, coshp1, coshp2, d, del1, del2, delp1, &
   & delp2, dels, dummy, si, sigmap, sinhm1, sinhm2, sinhms, sinhp1, &
   & sinhp2, sumx, sumy, tn
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine performs the mapping of points in the
! interval (0.,1.) Onto a closed curve in the plane. The
! subroutine kurvp1 should be called earlier to determine
! certain necessary parameters. The resulting curve has A
! parametric representation both of whose components are
! periodic splines under tension and functions of the poly-
! gonal arclength parameter.
! On input--
!   t contains a value to be mapped onto the curve. The
!   interval (0.,1.) Is mapped onto the entire closed curve
!   with both 0. And 1. Mapping to (x(1),y(1)). The mapping
!   is periodic with period one thus any interval of the
!   form (TT,TT+1.) Maps onto the entire curve.
!   n contains the number of points which were specified
!   to determine the curve.
!   x and y are arrays containing the x- and y-coordinates
!   of the specified points.
!   xp and yp are the arrays output from kurvp1 containing
!   curvature information.
!   s is an array containing the polygonal arclengths of
!   the curve.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters n, x, y, xp, yp, s and sigma should
! be input unaltered from the output of kurvp1.
! On output--
!   xs and ys contain the x- and y-coordinates of the image
!   point on the curve.
! None of the input parameters are altered.
! This subroutine references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Determine interval
tn = t - float(ifix(t))
if (tn < 0.) tn = tn + 1.
tn = s(n)*tn + s(1)
im1 = n
if (tn < s(n)) im1 = intrvl(tn,s,n)
i = im1 + 1
if (i > n) i = 1
! Denormalize tension factor
sigmap = abs(sigma)*float(n)/s(n)
! Set up and perform interpolation
si = s(i)
if (im1 == n) si = s(n) + s(1)
del1 = tn - s(im1)
del2 = si - tn
dels = si - s(im1)
sumx = (x(i)*del1 + x(im1)*del2)/dels
sumy = (y(i)*del1 + y(im1)*del2)/dels
if (sigmap /= 0.) go to 1
d = del1*del2/(6.*dels)
c1 = (del1 + dels)*d
c2 = (del2 + dels)*d
xs = sumx - xp(i)*c1 - xp(im1)*c2
ys = sumy - yp(i)*c1 - yp(im1)*c2
return
1 delp1 = sigmap*(del1 + dels)/2.
delp2 = sigmap*(del2 + dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh(sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh(sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh(dummy,coshp1,delp1,1)
call snhcsh(dummy,coshp2,delp2,1)
d = sigmap*sigmap*dels*(sinhms + sigmap*dels)
ci = (sinhm1*del2 - del1*(2.*(coshp1 + 1.)*sinhp2 + sigmap* &
   & coshp1*del2))/d
cim1 = (sinhm2*del1 - del2*(2.*(coshp2 + 1.)*sinhp1 + &
   & sigmap*coshp2*del1))/d
xs = sumx + ci*xp(i) + cim1*xp(im1)
ys = sumy + ci*yp(i) + cim1*yp(im1)
end subroutine kurvp2

pure subroutine qurv1(n,x,y,z,slp1x,slp1y,slp1z,slpnx, &
   & slpny,slpnz,islpsw,xp,yp,zp,temp, &
   & s,sigma,ierr)
!! <!-- nswc-ford:begin QURV1 -->
!! Reference for `qurv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine determines the parameters necessary to
!!  compute a spline under tension passing through a sequence
!!  of triples (x(1),y(1),z(1)),...,(x(n),y(n),z(n)). The
!!  slopes at the two ends of the curve may be specified or
!!  omitted. For actual computation of points on the curve
!!  it is necessary to call the subroutine qurv2.
!!  On input--
!!    n is the number of points to be interpolated (n.GE.2).
!!    x is an array containing the n x-coordinates of the
!!    points.
!!    y is an array containing the n y-coordinates of the
!!    points.
!!    z is an array containing the n z-coordinates of the
!!    points. (Adjacent x-y-z triples must be distinct, I. E.
!!    Either x(i) .NE. x(i+1) or y(i) .NE. y(i+1) or z(i) .NE.
!!    z(i+1), FOR i = 1,...,n-1 ).
!!    slp1x, slp1y, slp1z and slpnx, SLPNY, SLPNZ contain the
!!    desired values of the components of tangent vectors to
!!    the curve at (x(1),y(1),z(1)) and(x(n),y(n),z(n)),
!!    respectively. The positive sense of the curve is assumed
!!    to be that moving from point 1 to point n. the user may
!!    omit values for either or both of these triples and
!!    signal this with islpsw.
!!    islpsw contains a switch indicating which slope data
!!    should be used and which should be estimated by this
!!    subroutine,
!!           = 0 IF slp1x, slp1y, slp1z AND slpnx, SLPNY,
!!               SLPNZ are to be used,
!!           = 1 If slp1x, slp1y, slp1z are to be used but
!!               not slpnx, SLPNY, SLPNZ,
!!           = 2 If slpnx, SLPNY, SLPNZ are to be used but
!!               not slp1x, slp1y, slp1z,
!!           = 3 If both end-tangents are to be estimated
!!               internally.
!!    xp, yp, and zp are arrays of length at least n.
!!    Temp is an array of length at least n which is used
!!    for scratch storage.
!!    s is an array of length at least n.
!!  And
!!    sigma contains the tension factor. This value indicates
!!    the curviness desired. If abs(sigma) is nearly zero
!!    (E.G. .001) the resulting curve is approximately a cubic
!!    spline. If abs(sigma) is large (E. G. 50.) The resulting
!!    curve is nearly a polygonal line. If sigma equals zero A
!!    cubic spline results. A standard value for sigma is
!!    approximately 1. In absolute value.
!!  On output--
!!    xp, yp, and zp contain information about the curvature
!!    of the curve at the given nodes.
!!    s contains the polygonal arclengths of the curve.
!!    ierr contains an error flag,
!!         = 0 For normal return,
!!         = 1 If n is less than 2,
!!         = 2 If adjacent triples coincide.
!!  And
!!    n, x, y, z, slp1x, slp1y, slp1z, slpnx, SLPNY, SLPNZ,
!!    islpsw, and sigma are unaltered,
!!  this subroutine references package modules ceez, terms,
!!  and snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, islpsw
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n), z(n), slp1x, slp1y, slp1z, slpnx, &
   & slpny, slpnz
real, intent(inout) :: xp(n), yp(n), zp(n), temp(n), s(n)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, ibak, im1, nm1, np1
real :: c1, c2, c3, dels1, dels2, delsn, delsnm, delt, diag, &
   & diag1, diag2, diagin, dx1, dx2, dy1, dy2, dz1, dz2, sdiag1, &
   & sdiag2, sigmap, slpp1x, slpp1y, slpp1z, slppnx, slppny, slppnz, t
interface
   pure elemental subroutine ceez(del1,del2,sigma,c1,c2,c3,n)
      implicit none
      real, intent(in) :: del1
      real, intent(in) :: del2
      real, intent(in) :: sigma
      real, intent(inout) :: c1
      real, intent(inout) :: c2
      real, intent(inout) :: c3
      integer, intent(in) :: n
   end subroutine ceez
   pure elemental subroutine terms(diag,sdiag,sigma,del)
      implicit none
      real, intent(inout) :: diag
      real, intent(inout) :: sdiag
      real, intent(in) :: sigma
      real, intent(in) :: del
   end subroutine terms
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine determines the parameters necessary to
! compute a spline under tension passing through a sequence
! of triples (x(1),y(1),z(1)),...,(x(n),y(n),z(n)). The
! slopes at the two ends of the curve may be specified or
! omitted. For actual computation of points on the curve
! it is necessary to call the subroutine qurv2.
! On input--
!   n is the number of points to be interpolated (n.GE.2).
!   x is an array containing the n x-coordinates of the
!   points.
!   y is an array containing the n y-coordinates of the
!   points.
!   z is an array containing the n z-coordinates of the
!   points. (Adjacent x-y-z triples must be distinct, I. E.
!   Either x(i) .NE. x(i+1) or y(i) .NE. y(i+1) or z(i) .NE.
!   z(i+1), FOR i = 1,...,n-1 ).
!   slp1x, slp1y, slp1z and slpnx, SLPNY, SLPNZ contain the
!   desired values of the components of tangent vectors to
!   the curve at (x(1),y(1),z(1)) and(x(n),y(n),z(n)),
!   respectively. The positive sense of the curve is assumed
!   to be that moving from point 1 to point n. the user may
!   omit values for either or both of these triples and
!   signal this with islpsw.
!   islpsw contains a switch indicating which slope data
!   should be used and which should be estimated by this
!   subroutine,
!          = 0 IF slp1x, slp1y, slp1z AND slpnx, SLPNY,
!              SLPNZ are to be used,
!          = 1 If slp1x, slp1y, slp1z are to be used but
!              not slpnx, SLPNY, SLPNZ,
!          = 2 If slpnx, SLPNY, SLPNZ are to be used but
!              not slp1x, slp1y, slp1z,
!          = 3 If both end-tangents are to be estimated
!              internally.
!   xp, yp, and zp are arrays of length at least n.
!   Temp is an array of length at least n which is used
!   for scratch storage.
!   s is an array of length at least n.
! And
!   sigma contains the tension factor. This value indicates
!   the curviness desired. If abs(sigma) is nearly zero
!   (E.G. .001) the resulting curve is approximately a cubic
!   spline. If abs(sigma) is large (E. G. 50.) The resulting
!   curve is nearly a polygonal line. If sigma equals zero A
!   cubic spline results. A standard value for sigma is
!   approximately 1. In absolute value.
! On output--
!   xp, yp, and zp contain information about the curvature
!   of the curve at the given nodes.
!   s contains the polygonal arclengths of the curve.
!   ierr contains an error flag,
!        = 0 For normal return,
!        = 1 If n is less than 2,
!        = 2 If adjacent triples coincide.
! And
!   n, x, y, z, slp1x, slp1y, slp1z, slpnx, SLPNY, SLPNZ,
!   islpsw, and sigma are unaltered,
! this subroutine references package modules ceez, terms,
! and snhcsh.
!-----------------------------------------------------------
nm1 = n - 1
np1 = n + 1
ierr = 0
if (n <= 1) go to 9
! Determine polygonal arclengths
s(1) = 0.
do i = 2,n
   im1 = i - 1
   s(i) = s(im1) + sqrt((x(i) - x(im1))**2 + (y(i) - y(im1))**2 &
      & + (z(i) - z(im1))**2)
end do
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/s(n)
! Approximate end slopes
if (islpsw >= 2) go to 2
slpp1x = slp1x
slpp1y = slp1y
slpp1z = slp1z
go to 3
2 dels1 = s(2) - s(1)
dels2 = dels1 + dels1
if (n > 2) dels2 = s(3) - s(1)
if (dels1 == 0. .or. dels2 == 0.) go to 9
call ceez(dels1,dels2,sigmap,c1,c2,c3,n)
slpp1x = c1*x(1) + c2*x(2)
slpp1y = c1*y(1) + c2*y(2)
slpp1z = c1*z(1) + c2*z(2)
if (n == 2) go to 3
slpp1x = slpp1x + c3*x(3)
slpp1y = slpp1y + c3*y(3)
slpp1z = slpp1z + c3*z(3)
3 delt = sqrt(slpp1x*slpp1x + slpp1y*slpp1y + slpp1z*slpp1z)
slpp1x = slpp1x/delt
slpp1y = slpp1y/delt
slpp1z = slpp1z/delt
if (islpsw == 1 .or. islpsw == 3) go to 4
slppnx = slpnx
slppny = slpny
slppnz = slpnz
go to 5
4 delsn = s(n) - s(nm1)
delsnm = delsn + delsn
if (n > 2) delsnm = s(n) - s(n - 2)
if (delsn == 0. .or. delsnm == 0.) go to 10
call ceez(-delsn,-delsnm,sigmap,c1,c2,c3,n)
slppnx = c1*x(n) + c2*x(nm1)
slppny = c1*y(n) + c2*y(nm1)
slppnz = c1*z(n) + c2*z(nm1)
if (n == 2) go to 5
slppnx = slppnx + c3*x(n - 2)
slppny = slppny + c3*y(n - 2)
slppnz = slppnz + c3*z(n - 2)
5 delt = sqrt(slppnx*slppnx + slppny*slppny + slppnz*slppnz)
slppnx = slppnx/delt
slppny = slppny/delt
slppnz = slppnz/delt
! Set up right hand sides and tridiagonal system for xp, yp
! and zp and perform forward elimination
dx1 = (x(2) - x(1))/s(2)
dy1 = (y(2) - y(1))/s(2)
dz1 = (z(2) - z(1))/s(2)
call terms(diag1,sdiag1,sigmap,s(2))
xp(1) = (dx1 - slpp1x)/diag1
yp(1) = (dy1 - slpp1y)/diag1
zp(1) = (dz1 - slpp1z)/diag1
temp(1) = sdiag1/diag1
if (n == 2) go to 7
do i = 2,nm1
   dels2 = s(i + 1) - s(i)
   if (dels2 == 0.) go to 10
   dx2 = (x(i + 1) - x(i))/dels2
   dy2 = (y(i + 1) - y(i))/dels2
   dz2 = (z(i + 1) - z(i))/dels2
   call terms(diag2,sdiag2,sigmap,dels2)
   diag = diag1 + diag2 - sdiag1*temp(i - 1)
   diagin = 1./diag
   xp(i) = (dx2 - dx1 - sdiag1*xp(i - 1))*diagin
   yp(i) = (dy2 - dy1 - sdiag1*yp(i - 1))*diagin
   zp(i) = (dz2 - dz1 - sdiag1*zp(i - 1))*diagin
   temp(i) = sdiag2*diagin
   dx1 = dx2
   dy1 = dy2
   dz1 = dz2
   diag1 = diag2
   sdiag1 = sdiag2
end do
7 diag = diag1 - sdiag1*temp(nm1)
xp(n) = (slppnx - dx1 - sdiag1*xp(nm1))/diag
yp(n) = (slppny - dy1 - sdiag1*yp(nm1))/diag
zp(n) = (slppnz - dz1 - sdiag1*zp(nm1))/diag
! Perform back substitution
do i = 2,n
   ibak = np1 - i
   t = temp(ibak)
   xp(ibak) = xp(ibak) - t*xp(ibak + 1)
   yp(ibak) = yp(ibak) - t*yp(ibak + 1)
   zp(ibak) = zp(ibak) - t*zp(ibak + 1)
end do
return
! Too few points
9 ierr = 1
return
! Coincident adjacent points
10 ierr = 2
end subroutine qurv1

pure subroutine qurv2(t,xs,ys,zs,n,x,y,z,xp,yp,zp,s,sigma)
!! <!-- nswc-ford:begin QURV2 -->
!! Reference for `qurv2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine performs the mapping of points in the
!!  interval (0.,1.) Onto a curve in space.  The subroutine
!!  qurv1 should be called earlier to determine certain
!!  necessary parameters. The resulting curve has a parametric
!!  representation all of whose components are splines under
!!  tension and functions of the polygonal arclength
!!  parameter.
!!  On input--
!!    t contains a real value to be mapped to a point on the
!!    curve. The interval (0.,1.) Is mapped onto the entire
!!    curve, with 0. Mapping to (x(1),y(1,z(1)) and 1. Mapping
!!    to (x(n),y(n),z(n)). Values outside this interval result
!!    in extrapolation.
!!    n contains the number of points which were specified
!!    to determine the curve.
!!    x, y, and z are arrays containing the x-, y- and z-
!!    coordinates of the specified points.
!!    xp, yp, and zp are the arrays output from qurv1
!!    containing curvature information.
!!    s is an array containing the polygonal arclengths of
!!    the curve.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters n, x, y, z, xp, yp, zp, s, and sigma
!!  should be input unaltered from the output of qurv1.
!!  On output--
!!    xs, ys and zs contain the x-, y- and z-coordinates of
!!    the image point on the curve.
!!  None of the input parameters are altered.
!!  This subroutine references package modules intrvl and
!!  snhcsh.
!!
!!  Determine interval
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: t
real, intent(inout) :: xs, ys, zs
real, intent(in) :: x(n), y(n), z(n), xp(n), yp(n), zp(n), s(n)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, im1
real :: c1, c2, coshp1, coshp2, d, del1, del2, delp1, delp2, dels, &
   & dummy, sigmap, sinhm1, sinhm2, sinhms, sinhp1, sinhp2, sumx, sumy, &
   & sumz, tn
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine performs the mapping of points in the
! interval (0.,1.) Onto a curve in space.  The subroutine
! qurv1 should be called earlier to determine certain
! necessary parameters. The resulting curve has a parametric
! representation all of whose components are splines under
! tension and functions of the polygonal arclength
! parameter.
! On input--
!   t contains a real value to be mapped to a point on the
!   curve. The interval (0.,1.) Is mapped onto the entire
!   curve, with 0. Mapping to (x(1),y(1,z(1)) and 1. Mapping
!   to (x(n),y(n),z(n)). Values outside this interval result
!   in extrapolation.
!   n contains the number of points which were specified
!   to determine the curve.
!   x, y, and z are arrays containing the x-, y- and z-
!   coordinates of the specified points.
!   xp, yp, and zp are the arrays output from qurv1
!   containing curvature information.
!   s is an array containing the polygonal arclengths of
!   the curve.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters n, x, y, z, xp, yp, zp, s, and sigma
! should be input unaltered from the output of qurv1.
! On output--
!   xs, ys and zs contain the x-, y- and z-coordinates of
!   the image point on the curve.
! None of the input parameters are altered.
! This subroutine references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Determine interval
tn = s(n)*t
im1 = intrvl(tn,s,n)
i = im1 + 1
! Denormalize tension factor
sigmap = abs(sigma)*float(n - 1)/s(n)
! Set up and perform interpolation
del1 = tn - s(im1)
del2 = s(i) - tn
dels = s(i) - s(im1)
sumx = (x(i)*del1 + x(im1)*del2)/dels
sumy = (y(i)*del1 + y(im1)*del2)/dels
sumz = (z(i)*del1 + z(im1)*del2)/dels
if (sigmap /= 0.) go to 1
d = del1*del2/(6.*dels)
c1 = (del1 + dels)*d
c2 = (del2 + dels)*d
xs = sumx - xp(i)*c1 - xp(im1)*c2
ys = sumy - yp(i)*c1 - yp(im1)*c2
zs = sumz - zp(i)*c1 - zp(im1)*c2
return
1 delp1 = sigmap*(del1 + dels)/2.
delp2 = sigmap*(del2 + dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh(sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh(sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh(dummy,coshp1,delp1,1)
call snhcsh(dummy,coshp2,delp2,1)
d = sigmap*sigmap*dels*(sinhms + sigmap*dels)
c1 = (sinhm1*del2 - del1*(2.*(coshp1 + 1.)*sinhp2 + sigmap* &
   & coshp1*del2))/d
c2 = (sinhm2*del1 - del2*(2.*(coshp2 + 1.)*sinhp1 + sigmap* &
   & coshp2*del1))/d
xs = sumx + xp(i)*c1 + xp(im1)*c2
ys = sumy + yp(i)*c1 + yp(im1)*c2
zs = sumz + zp(i)*c1 + zp(im1)*c2
end subroutine qurv2

pure elemental subroutine ceez(del1,del2,sigma,c1,c2,c3,n)
!! <!-- nswc-ford:begin CEEZ -->
!! Reference for `ceez`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine determines the coefficients c1, c2, and c3
!!  used to determine endpoint slopes. Specifically, if
!!  function values Y1, Y2, and Y3 are given at points X1, X2,
!!  and X3, respectively, the quantity c1*Y1 + c2*Y2 + c3*Y3
!!  is the value of the derivative at X1 of a spline under
!!  tension (with tension factor sigma) passing through the
!!  three points and having third derivative equal to zero at
!!  X1. Optionally, only two values, c1 and c2 are determined.
!!  On input--
!!    del1 IS X2-X1 (.GT. 0.).
!!    del2 is X3-X1 (.GT. 0.). If n .EQ. 2, this parameter is
!!    ignored.
!!    sigma is the tension factor.
!!  And
!!    n is a switch indicating the number of coefficients to
!!    be returned. If n .EQ. 2 only two coefficients are
!!    returned. Otherwise all three are returned.
!!  On output--
!!    c1, c2, and c3 contain the coefficients.
!!  None of the input parameters are altered.
!!  This subroutine references package module snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: del1, del2, sigma
real, intent(inout) :: c1, c2, c3
!     beginning of local variable declarations
real :: coshm1, coshm2, del, delm, delp, denom, dummy, sinhmm, &
   & sinhmp
interface
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine determines the coefficients c1, c2, and c3
! used to determine endpoint slopes. Specifically, if
! function values Y1, Y2, and Y3 are given at points X1, X2,
! and X3, respectively, the quantity c1*Y1 + c2*Y2 + c3*Y3
! is the value of the derivative at X1 of a spline under
! tension (with tension factor sigma) passing through the
! three points and having third derivative equal to zero at
! X1. Optionally, only two values, c1 and c2 are determined.
! On input--
!   del1 IS X2-X1 (.GT. 0.).
!   del2 is X3-X1 (.GT. 0.). If n .EQ. 2, this parameter is
!   ignored.
!   sigma is the tension factor.
! And
!   n is a switch indicating the number of coefficients to
!   be returned. If n .EQ. 2 only two coefficients are
!   returned. Otherwise all three are returned.
! On output--
!   c1, c2, and c3 contain the coefficients.
! None of the input parameters are altered.
! This subroutine references package module snhcsh.
!-----------------------------------------------------------
if (n == 2) go to 2
if (sigma /= 0.) go to 1
del = del2 - del1
! TENSION .EQ. 0.
c1 = -(del1 + del2)/(del1*del2)
c2 = del2/(del1*del)
c3 = -del1/(del2*del)
return
! TENSION .NE. 0.
1 call snhcsh(dummy,coshm1,sigma*del1,1)
call snhcsh(dummy,coshm2,sigma*del2,1)
delp = sigma*(del2 + del1)/2.
delm = sigma*(del2 - del1)/2.
call snhcsh(sinhmp,dummy,delp,-1)
call snhcsh(sinhmm,dummy,delm,-1)
denom = coshm1*(del2 - del1) - 2.*del1*(sinhmp + delp)* &
   & (sinhmm + delm)
c1 = 2.*(sinhmp + delp)*(sinhmm + delm)/denom
c2 = -coshm2/denom
c3 = coshm1/denom
return
! Two coefficients
2 c1 = -1./del1
c2 = -c1
end subroutine ceez

pure elemental subroutine terms(diag,sdiag,sigma,del)
!! <!-- nswc-ford:begin TERMS -->
!! Reference for `terms`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine computes the diagonal and superdiagonal
!!  terms of the tridiagonal linear system associated with
!!  spline under tension interpolation.
!!  On input--
!!    sigma contains the tension factor.
!!  And
!!    del contains the step size.
!!  On output--
!!                (sigma*del*cosh(sigma*del) - Sinh(sigma*del)
!!    diag = del*--------------------------------------------.
!!                      (sigma*del)**2 * SINH(sigma*del)
!!                    sinh(sigma*del) - sigma*del
!!    sdiag = del*----------------------------------.
!!                 (sigma*del)**2 * SINH(sigma*del)
!!  and
!!    sigma and del are unaltered.
!!  This subroutine references package module snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(inout) :: diag, sdiag
real, intent(in) :: sigma, del
!     beginning of local variable declarations
real :: coshm, denom, sigdel, sinhm
interface
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine computes the diagonal and superdiagonal
! terms of the tridiagonal linear system associated with
! spline under tension interpolation.
! On input--
!   sigma contains the tension factor.
! And
!   del contains the step size.
! On output--
!               (sigma*del*cosh(sigma*del) - Sinh(sigma*del)
!   diag = del*--------------------------------------------.
!                     (sigma*del)**2 * SINH(sigma*del)
!                   sinh(sigma*del) - sigma*del
!   sdiag = del*----------------------------------.
!                (sigma*del)**2 * SINH(sigma*del)
! and
!   sigma and del are unaltered.
! This subroutine references package module snhcsh.
!-----------------------------------------------------------
if (sigma /= 0.) then
   sigdel = sigma*del
   call snhcsh(sinhm,coshm,sigdel,0)
   denom = del/((sinhm + sigdel)*sigdel*sigdel)
   diag = denom*(sigdel*coshm - sinhm)
   sdiag = denom*sinhm
else
   diag = del/3.
   sdiag = del/6.
end if
end subroutine terms

pure integer function intrvl(x, t, m)
!! <!-- nswc-ford:begin INTRVL -->
!! Reference for `intrvl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Location of a value x in a sequence t
!!
!!      Input--
!!         x is a real number.
!!         t is an array of nondecreasing values. It is
!!           assumed that t(1) .LT. t(m).
!!         m is the length of t (m .GE. 2).
!!      Output--
!!         intrvl has the value i when  t(i) .LE. x .LT. t(i+1).
!!         Otherwise, if L is the integer where t(L) .LT. t(L+1)
!!         and t(L+1) = ... = t(m), then intrvl has the value i
!!         where
!!                   i = 1   IF x .LT. t(1)
!!                   i = L   IF x .GE. t(L)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m
real, intent(in) :: x, t(m)
!     beginning of local variable declarations
integer :: i, il, ir
real :: tm, nswc_ai_r4
!-----------------------------------------------------------------------
!             Location of a value x in a sequence t
!                       ----------------
!     Input--
!        x is a real number.
!        t is an array of nondecreasing values. It is
!          assumed that t(1) .LT. t(m).
!        m is the length of t (m .GE. 2).
!     Output--
!        intrvl has the value i when  t(i) .LE. x .LT. t(i+1).
!        Otherwise, if L is the integer where t(L) .LT. t(L+1)
!        and t(L+1) = ... = t(m), then intrvl has the value i
!        where
!                  i = 1   IF x .LT. t(1)
!                  i = L   IF x .GE. t(L)
!-----------------------------------------------------------------------
if (x < t(2)) go to 100
tm = t(m)
i = m - 1
10 if (t(i) < tm) go to 20
i = i - 1
go to 10
20 if (x >= t(i)) go to 110
il = 2
ir = i
!     Bisection search
30 i = (il + ir)/2
if (i == il) go to 110
nswc_ai_r4 = x - t(i)
if (nswc_ai_r4 < 0) go to 40
if (nswc_ai_r4 == 0) go to 60
go to 50
40 ir = i
go to 30
50 il = i
go to 30
!     Case when x = t(i) for some i
60 if (x < t(i + 1)) go to 110
i = i + 1
go to 60
!     Left end
100 intrvl = 1
return
!     Normal exit
110 intrvl = i
end function intrvl

pure subroutine bval(t, bcoef, n, k, x, jderiv, w, wk)
!! <!-- nswc-ford:begin BVAL -->
!! Reference for `bval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bval calculates the value at x of the jderiv-TH derivative
!!      of a spline F from its B-representation.
!! ******  i n P U t ******
!!   t     AN ARRAY OF DIMENSION n + k CONTAING THE KNOTS OF THE
!!         spline. It is assumed that t(i) .LE. t(i+1) for each i.
!!   bcoef an array of dimension n containing the B-coefficients
!!         of the spline F.
!!   n     LENGTH OF bcoef (n .GE. 1).
!!   k     ORDER OF THE SPLINE.
!!   x     THE POINT AT WHICH TO EVALUATE.
!!   jderiv  integer giving the order of the derivative to be
!!         evaluated. It is assumed that jderiv .GE. 0.
!! ******  O U t P U t  ******
!!   w     THE VALUE OF THE (jderiv)-TH DERIVATIVE OF F AT x.
!! ******  w O R k  S P A C E ******
!!   wk    AN ARRAY OF DIMENSION 3*k OR LARGER.
!! ******  M E t H O D  ******
!!      the nontrivial knot interval (t(i),t(i+1)) containing x is first
!!   obtained. Then the  k  B-coefficients of F relevant for this interval
!!   are obtained from bcoef (or taken to be zero if not explicitly avail-
!!   able), and DIFFERENCED jderiv times to obtain the B-coefficients of
!!   (D**jderiv)F  relevant for the interval. Specifically, if j = jderiv
!!   then from x.(12) Of the reference we have
!!      (D**j)F  =  sum ( bcoef(.,j)*B(.,k-j,t) )
!!   where
!!                    / bcoef(.),                     ,  j .EQ. 0
!!
!!     bcoef(.,j)  =  / bcoef(.,j-1) - bcoef(.-1,j-1)
!!                    / ----------------------------- ,  j .GT. 0
!!                    /    (t(.+k-j) - t(.))/(k-j)
!!      then, we use repeatedly the fact that
!!     sum ( A(.)*B(.,M,t)(x) )  =  sum ( A(.,x)*B(.,M-1,t)(x) )
!!   with
!!                  (x - t(.))*A(.) + (t(.+M-1) - x)*A(.-1)
!!     a(.,x)  =    ---------------------------------------
!!                  (x - t(.))      + (t(.+M-1) - x)
!!   to write (D**j)F(x) eventually as a linear combination of B-splines
!!   of order 1. The coefficient for B(i,1,t)(x) must then be the desired
!!   number  (D**j)F(x). (See x.(17)-(19) Of the reference).
!!
!!   Reference. DE boor, carl, A PRATICAL guide to splines, springer-
!!   verlag, new york, 1978.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: jderiv, k, n
real, intent(inout) :: w
real, intent(in) :: x
real, intent(in) :: t(*), bcoef(n)
real, intent(inout) :: wk(k,3)
!     beginning of local variable declarations
integer :: i, imk, ipj, j, jc, jcmax, jcmin, jdrvp1, jj, km1, kmj, &
   & l, nmi, npk
real :: dl, dr, fkmj
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!     bval calculates the value at x of the jderiv-TH derivative
!     of a spline F from its B-representation.
!******  i n P U t ******
!  t     AN ARRAY OF DIMENSION n + k CONTAING THE KNOTS OF THE
!        spline. It is assumed that t(i) .LE. t(i+1) for each i.
!  bcoef an array of dimension n containing the B-coefficients
!        of the spline F.
!  n     LENGTH OF bcoef (n .GE. 1).
!  k     ORDER OF THE SPLINE.
!  x     THE POINT AT WHICH TO EVALUATE.
!  jderiv  integer giving the order of the derivative to be
!        evaluated. It is assumed that jderiv .GE. 0.
!******  O U t P U t  ******
!  w     THE VALUE OF THE (jderiv)-TH DERIVATIVE OF F AT x.
!******  w O R k  S P A C E ******
!  wk    AN ARRAY OF DIMENSION 3*k OR LARGER.
!******  M E t H O D  ******
!     the nontrivial knot interval (t(i),t(i+1)) containing x is first
!  obtained. Then the  k  B-coefficients of F relevant for this interval
!  are obtained from bcoef (or taken to be zero if not explicitly avail-
!  able), and DIFFERENCED jderiv times to obtain the B-coefficients of
!  (D**jderiv)F  relevant for the interval. Specifically, if j = jderiv
!  then from x.(12) Of the reference we have
!     (D**j)F  =  sum ( bcoef(.,j)*B(.,k-j,t) )
!  where
!                   / bcoef(.),                     ,  j .EQ. 0
!                   /
!    bcoef(.,j)  =  / bcoef(.,j-1) - bcoef(.-1,j-1)
!                   / ----------------------------- ,  j .GT. 0
!                   /    (t(.+k-j) - t(.))/(k-j)
!     then, we use repeatedly the fact that
!    sum ( A(.)*B(.,M,t)(x) )  =  sum ( A(.,x)*B(.,M-1,t)(x) )
!  with
!                 (x - t(.))*A(.) + (t(.+M-1) - x)*A(.-1)
!    a(.,x)  =    ---------------------------------------
!                 (x - t(.))      + (t(.+M-1) - x)
!  to write (D**j)F(x) eventually as a linear combination of B-splines
!  of order 1. The coefficient for B(i,1,t)(x) must then be the desired
!  number  (D**j)F(x). (See x.(17)-(19) Of the reference).
!-----------------------------------------------------------------------
!  Reference. DE boor, carl, A PRATICAL guide to splines, springer-
!  verlag, new york, 1978.
!-----------------------------------------------------------------------
w = 0.0
if (jderiv >= k) return
! *** FIND i WHERE 1 .LE. i .LT. n+k  AND  t(i) .LE. x .LT. t(i+1).
!     If no such i exists, then x lies outside the support of the
!     SPLINE F AND w = 0.
npk = n + k
if (x < t(1) .or. x > t(npk)) return
i = intrvl(x, t, npk)
!  *** IF k = 1 (AND jderiv = 0), w = bcoef(i).
km1 = k - 1
if (km1 > 0) go to 10
w = bcoef(i)
return
!  *** Store the k B-spline coefficients relevant for the knot interval
!     (t(i),t(i+1)) in the first column of wk and compute wk(j,2) =
!     x - t(i+1-j), wk(j,3) = t(i+j) - x, j=1,...,k-1 . Set any of the
!     wk(j,1) not obtainable from input to zero. Set any t.S not obtain-
!     able equal to t(1) or to t(n+k) appropriately.
10 jcmin = 1
imk = i - k
if (imk >= 0) go to 40
jcmin = 1 - imk
l = i
do j = 1,i
   wk(j,2) = x - t(l)
   l = l - 1
end do
do j = i,km1
   l = k - j
   wk(l,1) = 0.0
   wk(j,2) = wk(i,2)
end do
go to 60
40 l = i
do j = 1,km1
   wk(j,2) = x - t(l)
   l = l - 1
end do
60 jcmax = k
nmi = n - i
if (nmi >= 0) go to 100
jcmax = k + nmi
do j = 1,jcmax
   ipj = i + j
   wk(j,3) = t(ipj) - x
end do
do j = jcmax,km1
   wk(j + 1,1) = 0.0
   wk(j,3) = wk(jcmax,3)
end do
go to 120
100 do j = 1,km1
   ipj = i + j
   wk(j,3) = t(ipj) - x
end do
120 do jc = jcmin,jcmax
   l = imk + jc
   wk(jc,1) = bcoef(l)
end do
!               *** Difference the coefficients  jderiv  times.
if (jderiv == 0) go to 170
do j = 1,jderiv
   kmj = k - j
   fkmj = kmj
   l = kmj
   do jj = 1,kmj
      dl = wk(l,2)
      dr = wk(jj,3)
      wk(jj,1) = ((wk(jj + 1,1) - wk(jj,1))/(dl + dr))*fkmj
      l = l - 1
   end do
end do
!  *** Compute value at x in (t(i),t(i+1)) of jderiv-TH derivative,
!     given its relevant B-spline coeffs in wk(1,1),...,wk(k-jderiv,1).
170 if (jderiv == km1) go to 200
jdrvp1 = jderiv + 1
do j = jdrvp1,km1
   kmj = k - j
   l = kmj
   do jj = 1,kmj
      dl = wk(l,2)
      dr = wk(jj,3)
      wk(jj,1) = (wk(jj + 1,1)*dl + wk(jj,1)*dr)/(dl + dr)
      l = l - 1
   end do
end do
200 w = wk(1,1)
end subroutine bval

pure subroutine bvali(t, bcoeff, n, k, x, w, wk)
!! <!-- nswc-ford:begin BVALI -->
!! Reference for `bvali`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!            Integral of a piecewise polynomial from t(1) to x
!!                    using its B-spline representation
!!
!!      real t(n + k), wk(n + 3*(k + 1))
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: k, n
real, intent(out) :: w
real, intent(in) :: x
real, intent(in) :: t(*), bcoeff(n)
real, intent(inout) :: wk(*)
!     beginning of local variable declarations
integer :: i, ipk, kp1, np1, npk
real :: sum, tlast, tnew, xval
interface
   pure subroutine bvali0(t,tnew,bcoef,n,k,x,w,wk)
      implicit none
      integer, intent(in) :: k
      integer, intent(in) :: n
      real, intent(in) :: t(*)
      real, intent(in) :: tnew
      real, intent(in) :: bcoef(n)
      real, intent(in) :: x
      real, intent(out) :: w
      real, intent(inout) :: wk(k,3)
   end subroutine bvali0
end interface
!-----------------------------------------------------------------------
!           Integral of a piecewise polynomial from t(1) to x
!                   using its B-spline representation
!-----------------------------------------------------------------------
!     real t(n + k), wk(n + 3*(k + 1))
!---------------------------
w = 0.0
if (x <= t(1)) return
npk = n + k
tlast = t(npk)
xval = min(x, tlast)
!     Define the first new knot. The remaining new knots
!         are assumed to be the same as this knot.
tnew = 0.1
if (tlast < -0.1) tnew = 0.9*tlast
if (tlast > 0.0) tnew = 1.1*tlast
!     Compute the first n coefficients of the antiderivative
sum = 0.0
do i = 1,n
   ipk = i + k
   sum = sum + bcoeff(i)*(t(ipk) - t(i))
   wk(i) = sum/k
end do
!     Compute the antiderivative
kp1 = k + 1
np1 = n + 1
call bvali0(t, tnew, wk(1), n, kp1, xval, w, wk(np1))
end subroutine bvali

pure subroutine bvali0(t, tnew, bcoef, n, k, x, w, wk)
!! <!-- nswc-ford:begin BVALI0 -->
!! Reference for `bvali0`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bvali0 calculates the value at x of an antiderivative
!!      OF A B-SPLINE F FOR t(1) .LE. x .LE. t(n + k - 1).
!! ******  i n P U t ******
!!   t     AN ARRAY CONTAINING THE FIRST n + k - 1 KNOTS OF THE
!!         antiderivative.
!!   tnew  the remaing knots are all located at this point.
!!   bcoef an array containing the first n coefficients of the
!!         antiderivative.
!!   n     LENGTH OF bcoef (n .GE. 1).
!!   k     ORDER OF THE ANTIDERIVATIVE.
!!   x     THE POINT AT WHICH TO EVALUATE.
!! ******  O U t P U t  ******
!!   w     THE VALUE OF THE ANTIDERIVATIVE AT x.
!! ******  w O R k  S P A C E ******
!!   wk    AN ARRAY OF DIMENSION 3*k OR LARGER.
!!
!!      Remark. bvali0 is an adaptation by A.H. Morris (NSWC) of the
!!      SUBROUTINE bval.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: k, n
real, intent(in) :: tnew
real, intent(out) :: w
real, intent(in) :: x
real, intent(in) :: t(*), bcoef(n)
real, intent(inout) :: wk(k,3)
!     beginning of local variable declarations
integer :: i, imk, ipj, j, jc, jcmin, jj, km1, kmj, l, m
real :: dl, dr, tipj
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!     bvali0 calculates the value at x of an antiderivative
!     OF A B-SPLINE F FOR t(1) .LE. x .LE. t(n + k - 1).
!******  i n P U t ******
!  t     AN ARRAY CONTAINING THE FIRST n + k - 1 KNOTS OF THE
!        antiderivative.
!  tnew  the remaing knots are all located at this point.
!  bcoef an array containing the first n coefficients of the
!        antiderivative.
!  n     LENGTH OF bcoef (n .GE. 1).
!  k     ORDER OF THE ANTIDERIVATIVE.
!  x     THE POINT AT WHICH TO EVALUATE.
!******  O U t P U t  ******
!  w     THE VALUE OF THE ANTIDERIVATIVE AT x.
!******  w O R k  S P A C E ******
!  wk    AN ARRAY OF DIMENSION 3*k OR LARGER.
!-----------------------------------------------------------------------
!     Remark. bvali0 is an adaptation by A.H. Morris (NSWC) of the
!     SUBROUTINE bval.
!-----------------------------------------------------------------------
w = 0.0
km1 = k - 1
m = n + km1
i = intrvl(x, t, m)
!  *** Store the k B-spline coefficients relevant for the knot interval
!     (t(i),t(i+1)) in the first column of wk and compute wk(j,2) =
!     x - t(i+1-j), wk(j,3) = t(i+j) - x, j=1,...,k-1 . Set any of the
!     wk(j,1) not obtainable from input to zero. Set any t.S not obtain-
!     able equal to t(1) or tnew appropriately.
jcmin = 1
imk = i - k
if (imk >= 0) go to 30
jcmin = 1 - imk
l = i
do j = 1,i
   wk(j,2) = x - t(l)
   l = l - 1
end do
do j = i,km1
   l = k - j
   wk(l,1) = 0.0
   wk(j,2) = wk(i,2)
end do
go to 50
30 l = i
do j = 1,km1
   wk(j,2) = x - t(l)
   l = l - 1
end do
50 do j = 1,km1
   tipj = tnew
   ipj = i + j
   if (ipj <= m) tipj = t(ipj)
   wk(j,3) = tipj - x
end do
do jc = jcmin,k
   l = min(imk + jc, n)
   wk(jc,1) = bcoef(l)
end do
!  *** Compute value at x in (t(i),t(i+1)), given its relevant
!     B-spline coeffs in wk(1,1),...,wk(k,1).
do j = 1,km1
   kmj = k - j
   l = kmj
   do jj = 1,kmj
      dl = wk(l,2)
      dr = wk(jj,3)
      wk(jj,1) = (wk(jj + 1,1)*dl + wk(jj,1)*dr)/(dl + dr)
      l = l - 1
   end do
end do
w = wk(1,1)
end subroutine bvali0

pure subroutine bspp(t, a, n, k, break, c, l, wk)
!! <!-- nswc-ford:begin BSPP -->
!! Reference for `bspp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Conversion from B-spline representation
!!               to piecewise polynomial representation
!!      input ...
!!        t     KNOT SEQUENCE OF LENGTH n+k
!!        A     B-SPLINE COEFFICIENT SEQUENCE OF LENGTH n
!!        n     LENGTH OF A
!!        k     ORDER OF THE B-SPLINES
!!      output ...
!!        break breakpoint sequence, of length l+1, containing
!!              (in increasing order) the distinct points of the
!!              sequence t(k),...,t(n+1).
!!        c     KXL matrix where c(i,j) = (i-1)ST right derivative
!!              of the PP at break(j) divided by factorial(i-1).
!!        l     NUMBER OF POLYNOMIALS WHICH FORM THE PP
!!      work area ...
!!        wk    2-DIMENSIONAL ARRAY OF DIMENSION (k,k+1)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: k
integer, intent(out) :: l
integer, intent(in) :: n
real, intent(in) :: t(*), a(n)
real, intent(inout) :: break(*), c(k,*), wk(k,*)
!     beginning of local variable declarations
integer :: i, il, ilj, ilkj, j, jj, jp1, km1, kmj, kp1, left
real :: diff, r, s, term, x
!-----------------------------------------------------------------------
!              Conversion from B-spline representation
!              to piecewise polynomial representation
!     input ...
!       t     KNOT SEQUENCE OF LENGTH n+k
!       A     B-SPLINE COEFFICIENT SEQUENCE OF LENGTH n
!       n     LENGTH OF A
!       k     ORDER OF THE B-SPLINES
!     output ...
!       break breakpoint sequence, of length l+1, containing
!             (in increasing order) the distinct points of the
!             sequence t(k),...,t(n+1).
!       c     KXL matrix where c(i,j) = (i-1)ST right derivative
!             of the PP at break(j) divided by factorial(i-1).
!       l     NUMBER OF POLYNOMIALS WHICH FORM THE PP
!     work area ...
!       wk    2-DIMENSIONAL ARRAY OF DIMENSION (k,k+1)
!-----------------------------------------------------------------------
l = 0
break(1) = t(k)
if (k == 1) go to 100
km1 = k - 1
kp1 = k + 1
!          General k-TH order case
do left = k,n
   if (t(left) == t(left + 1)) go to 60
   l = l + 1
   break(l + 1) = t(left + 1)
   do j = 1,k
      jj = left - k + j
      wk(j,1) = a(jj)
   end do
   do j = 1,km1
      jp1 = j + 1
      kmj = k - j
      do i = 1,kmj
         il = i + left
         ilkj = il - kmj
         diff = t(il) - t(ilkj)
         wk(i,jp1) = (wk(i + 1,j) - wk(i,j))/diff
      end do
   end do
   wk(1,kp1) = 1.0
   x = t(left)
   c(k,l) = wk(1,k)
   r = 1.0
   do j = 1,km1
      jp1 = j + 1
      s = 0.0
      do i = 1,j
         il = i + left
         ilj = il - j
         term = wk(i,kp1)/(t(il) - t(ilj))
         wk(i,kp1) = s + (t(il) - x)*term
         s = (x - t(ilj))*term
      end do
      wk(jp1,kp1) = s
      s = 0.0
      kmj = k - j
      do i = 1,jp1
         s = s + wk(i,kmj)*wk(i,kp1)
      end do
      r = (r*float(kmj))/float(j)
      c(kmj,l) = r*s
   end do
60 continue
end do
return
!          Piecewise constant case
100 do left = k,n
   if (t(left) == t(left + 1)) go to 110
   l = l + 1
   break(l + 1) = t(left + 1)
   c(1,l) = a(left)
110 continue
end do
end subroutine bspp

subroutine ppval(x, a, l, n, xi, yi, ni)
!! <!-- nswc-ford:begin PPVAL -->
!! Reference for `ppval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          This routine evaluates a piecewise polynomial at the
!!          abscissas in xi. It is assumed that the coefficients
!!          of the polynomials which form the PP are given.
!!        --Input--
!!          x   - Array of the first n abscissas (in increasing order)
!!                that define the PP.
!!          a   - Matrix that contains the coefficients of the poly-
!!                NOMIALS  which form the PP. if i = 1,...,n then the
!!                PP has the value
!!                     a(1,i) + a(2,i)*dx + ... + a(l,i)*dx**(l-1)
!!                FOR x(i) .LE. xx .LT. x(i+1).  HERE dx = xx - x(i).
!!          l   - Order of the piecewise polynomial.
!!          n   - The number of polynomials that define the PP.
!!                n must be greater than or equal to 1.
!!          xi  - The array of abscissas (in arbitrary order) at which
!!                at which the PP is to be evaluated.
!!          ni  - The dimension of the arrays xi and yi. It is assumed
!!                that ni is greater than or equal to 1.
!!        --Output--
!!          yi  - Array of values of the PP at the points in xi.
!!
!!      k is index on value of xi being worked on.  xx is that value.
!!      i is the current index in the x array.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l, n, ni
real, intent(in) :: a(l,n), x(n), xi(ni)
real, intent(inout) :: yi(ni)
!     beginning of local variable declarations
integer :: i, il, ir, j, k, lm1, lmj
real :: dx, s, xx, nswc_ai_r4
!-----------------------------------------------------------------------
!         This routine evaluates a piecewise polynomial at the
!         abscissas in xi. It is assumed that the coefficients
!         of the polynomials which form the PP are given.
!       --Input--
!         x   - Array of the first n abscissas (in increasing order)
!               that define the PP.
!         a   - Matrix that contains the coefficients of the poly-
!               NOMIALS  which form the PP. if i = 1,...,n then the
!               PP has the value
!                    a(1,i) + a(2,i)*dx + ... + a(l,i)*dx**(l-1)
!               FOR x(i) .LE. xx .LT. x(i+1).  HERE dx = xx - x(i).
!         l   - Order of the piecewise polynomial.
!         n   - The number of polynomials that define the PP.
!               n must be greater than or equal to 1.
!         xi  - The array of abscissas (in arbitrary order) at which
!               at which the PP is to be evaluated.
!         ni  - The dimension of the arrays xi and yi. It is assumed
!               that ni is greater than or equal to 1.
!       --Output--
!         yi  - Array of values of the PP at the points in xi.
!-----------------------------------------------------------------------
!     k is index on value of xi being worked on.  xx is that value.
!     i is the current index in the x array.
k = 1
xx = xi(1)
lm1 = l - 1
if (xx < x(1)) go to 90
if (xx >= x(n)) go to 80
il = 1
ir = n
!     Bisection search
10 i = (il + ir)/2
if (i == il) go to 100
nswc_ai_r4 = xx - x(i)
if (nswc_ai_r4 < 0) go to 20
if (nswc_ai_r4 == 0) go to 100
go to 30
20 ir = i
go to 10
30 il = i
go to 10
!     Linear forward search
40 if (xx < x(i + 1)) go to 100
i = i + 1
go to 40
!     xx is greater than x(n) or less than x(1)
80 i = n
go to 100
90 i = 1
!     Evaluation
100 dx = xx - x(i)
s = a(l,i)
if (l == 1) go to 120
do j = 1,lm1
   lmj = l - j
   s = a(lmj,i) + dx*s
end do
120 yi(k) = s
!     Next point
if (k >= ni) return
k = k + 1
xx = xi(k)
if (xx < x(1)) go to 90
if (xx >= x(n)) go to 80
nswc_ai_r4 = xx - xi(k - 1)
if (nswc_ai_r4 < 0) go to 130
if (nswc_ai_r4 == 0) go to 120
go to 40
130 il = 1
ir = min(i + 1, n)
go to 10
end subroutine ppval

pure subroutine bspvb(t, k, jhigh, j, x, left, blist)
!! <!-- nswc-ford:begin BSPVB -->
!! Reference for `bspvb`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bspvb calculates the value of all possibly nonzero B-splines
!!      at x of order max(jhigh,j + 1) where t(k) .LE. x .LT. t(N+1).
!!      Description of arguments
!!          input
!!           t       - Knot vector of length N + k.
!!           k       - Highest possible order of the B-splines.
!!           jhigh   - Order of B-splines (1 .le. jhigh .le. k).
!!           j       - j .LE. 0  gives B-splines of order jhigh.
!!                     j .GE. 1  on a previous call to bspvb the
!!                               B-splines of order j were com-
!!                               puted and stored in blist. It is
!!                               assumed that work has not been
!!                               modified and that j .LT. k.
!!           x       - Argument of the B-splines.
!!           left    - Largest integer such that
!!                     t(left) .LE. x .LT. t(left+1)
!!          output
!!           blist   - Vector of length k for spline values.
!!           j       - B-splines of order j have been computed
!!                     and stored in blist.
!!
!!      Written by carl DE boor (University of Wisconsin) and modified
!!          by A.H. Morris (NSWC).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: j
integer, intent(in) :: jhigh, k, left
real, intent(in) :: x
real, intent(in) :: t(*)
real, intent(inout) :: blist(k)
!     beginning of local variable declarations
integer :: i, imj, l
real :: s, term, ti, timj
!-----------------------------------------------------------------------
!     bspvb calculates the value of all possibly nonzero B-splines
!     at x of order max(jhigh,j + 1) where t(k) .LE. x .LT. t(N+1).
!     Description of arguments
!         input
!          t       - Knot vector of length N + k.
!          k       - Highest possible order of the B-splines.
!          jhigh   - Order of B-splines (1 .le. jhigh .le. k).
!          j       - j .LE. 0  gives B-splines of order jhigh.
!                    j .GE. 1  on a previous call to bspvb the
!                              B-splines of order j were com-
!                              puted and stored in blist. It is
!                              assumed that work has not been
!                              modified and that j .LT. k.
!          x       - Argument of the B-splines.
!          left    - Largest integer such that
!                    t(left) .LE. x .LT. t(left+1)
!         output
!          blist   - Vector of length k for spline values.
!          j       - B-splines of order j have been computed
!                    and stored in blist.
!-----------------------------------------------------------------------
!     Written by carl DE boor (University of Wisconsin) and modified
!         by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
if (j > 0) go to 10
j = 1
blist(1) = 1.0
if (j >= jhigh) return
10 s = 0.0
do l = 1,j
   i = left + l
   imj = i - j
   timj = t(imj)
   ti = t(i)
   term = blist(l)/(ti - timj)
   blist(l) = s + (ti - x)*term
   s = (x - timj)*term
end do
j = j + 1
blist(j) = s
if (j < jhigh) go to 10
end subroutine bspvb

pure subroutine bspvd(t, k, x, left, dbiatx, idim, nderiv, a)
!! <!-- nswc-ford:begin BSPVD -->
!! Reference for `bspvd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  Calculates value and deriv.S of all B-splines which do not vanish at x
!! ******  i N P U t  ******
!!   t     THE KNOT ARRAY, OF LENGTH left+k (AT LEAST)
!!   k     THE ORDER OF THE B-SPLINES TO BE EVALUATED
!!   x     THE POINT AT WHICH THESE VALUES ARE SOUGHT
!!   left  an integer indicating the left endpoint of the interval of
!!         interest. The  k  B-splines whose support contains the interval
!!                (t(left), t(left+1))
!!         are to be considered.
!!   A S S U M P t i O N  - - -  It is assumed that
!!                t(left) .LT. t(left+1)
!!         division by zero will result otherwise (in  B S P V B ).
!!         Also, the output is as advertised only if
!!                t(left) .LE. x .LE. t(left+1) .
!!   idim  the row dimension of the matrix dbiatx. If is assumed that
!!         idim .GE. k .
!!   nderiv  an integer indicating that values of B-splines and their
!!         derivatives up to but not including the  nderiv-TH  are asked
!!         for. (nderiv is replaced internally by the integer  M H i G H
!!         in (1,k) closest to it.)
!! ******  O U t P U t  ******
!!   dbiatx  an array of order (idim,nderiv). Its entry (i,M) contains
!!         value of  (M-1)ST  derivative of  (left-k+i)-TH  B-spline of
!!         order  k  for knot sequence  t , i=M,...,k, M=1,...,nderiv.
!! ******  W O R k   A R E a  ******
!!   A     AN ARRAY OF ORDER (k,k), TO CONTAIN B-COEFF.S OF THE DERIVA-
!!         tives of a certain order of the  k  B-splines of interest.
!! ******  M E t H O D  ******
!!   values at  x  of all the relevant B-splines of order k,k-1,...,
!!   k+1-nderiv  are generated via bspvb and stored temporarily in
!!   dbiatx. Then the B-coeffs of the required derivatives of the B-
!!   splines of interest are generated by differencing, each from the pre-
!!   ceding one of lower order, and combined with the values of B-splines
!!   of corresponding order in  dbiatx  to produce the desired values .
!!
!!   Written by carl DE boor (University of Wisconsin) and modified
!!      by A.H. Morris (NSWC).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: idim, k, left, nderiv
real, intent(in) :: x
real, intent(in) :: t(*)
real, intent(inout) :: dbiatx(idim,nderiv), a(k,k)
!     beginning of local variable declarations
integer :: i, ideriv, il, j, jj, jlow, jp1mid, kp1, kp1mm, l, &
   & ldummy, m, mhigh
real :: factor, fkp1mm, sum
interface
   pure subroutine bspvb(t,k,jhigh,j,x,left,blist)
      implicit none
      integer, intent(in) :: k
      real, intent(in) :: t(*)
      integer, intent(in) :: jhigh
      integer, intent(inout) :: j
      real, intent(in) :: x
      integer, intent(in) :: left
      real, intent(inout) :: blist(k)
   end subroutine bspvb
end interface
!-----------------------------------------------------------------------
! Calculates value and deriv.S of all B-splines which do not vanish at x
!******  i N P U t  ******
!  t     THE KNOT ARRAY, OF LENGTH left+k (AT LEAST)
!  k     THE ORDER OF THE B-SPLINES TO BE EVALUATED
!  x     THE POINT AT WHICH THESE VALUES ARE SOUGHT
!  left  an integer indicating the left endpoint of the interval of
!        interest. The  k  B-splines whose support contains the interval
!               (t(left), t(left+1))
!        are to be considered.
!  A S S U M P t i O N  - - -  It is assumed that
!               t(left) .LT. t(left+1)
!        division by zero will result otherwise (in  B S P V B ).
!        Also, the output is as advertised only if
!               t(left) .LE. x .LE. t(left+1) .
!  idim  the row dimension of the matrix dbiatx. If is assumed that
!        idim .GE. k .
!  nderiv  an integer indicating that values of B-splines and their
!        derivatives up to but not including the  nderiv-TH  are asked
!        for. (nderiv is replaced internally by the integer  M H i G H
!        in (1,k) closest to it.)
!******  O U t P U t  ******
!  dbiatx  an array of order (idim,nderiv). Its entry (i,M) contains
!        value of  (M-1)ST  derivative of  (left-k+i)-TH  B-spline of
!        order  k  for knot sequence  t , i=M,...,k, M=1,...,nderiv.
!******  W O R k   A R E a  ******
!  A     AN ARRAY OF ORDER (k,k), TO CONTAIN B-COEFF.S OF THE DERIVA-
!        tives of a certain order of the  k  B-splines of interest.
!******  M E t H O D  ******
!  values at  x  of all the relevant B-splines of order k,k-1,...,
!  k+1-nderiv  are generated via bspvb and stored temporarily in
!  dbiatx. Then the B-coeffs of the required derivatives of the B-
!  splines of interest are generated by differencing, each from the pre-
!  ceding one of lower order, and combined with the values of B-splines
!  of corresponding order in  dbiatx  to produce the desired values .
!-----------------------------------------------------------------------
!  Written by carl DE boor (University of Wisconsin) and modified
!     by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
mhigh = max(min(nderiv,k),1)
!     MHIGH is usually equal to nderiv.
kp1 = k + 1
jj = 0
call bspvb(t, k, kp1 - mhigh, jj, x, left, dbiatx)
if (mhigh == 1) return
!     The first column of dbiatx always contains the B-spline values
!     for the current order. These are stored in column k+1-current
!     order  before  bspvb  is called to put values for the next
!     higher order on top of it.
ideriv = mhigh
do m = 2,mhigh
   jp1mid = 1
   do j = ideriv,k
      dbiatx(j,ideriv) = dbiatx(jp1mid,1)
      jp1mid = jp1mid + 1
   end do
   ideriv = ideriv - 1
   call bspvb(t, k, kp1 - ideriv, jj, x, left, dbiatx)
end do
!     At this point, B(left-k+i, k+1-j)(x) is in dbiatx(i,j) for
!     i = j,...,k and j = 1,...,MHIGH. In particular, the first
!     column of dbiatx is already in final form. To obtain cor-
!     responding derivatives of B-splines in subsequent columns,
!     generate their B-repr. By differencing. Then evaluate at x.
jlow = 1
do i = 1,k
   do j = jlow,k
      a(j,i) = 0.0
   end do
   jlow = i
   a(i,i) = 1.0
end do
!     At this point, a(.,j) contains the B-coeffs for the j-TH of the
!     k  B-splines of interest here.
do m = 2,mhigh
   kp1mm = kp1 - m
   fkp1mm = float(kp1mm)
   il = left
   i = k
!        For j = 1,...,k, construct B-coeffs of (M-1)ST  derivative of
!        B-splines from those for preceding derivative by differencing
!        and store again in  a(.,j) . The fact that  a(i,j) = 0  For
!        i .LT. j  is used.
   do ldummy = 1,kp1mm
      l = il + kp1mm
      factor = fkp1mm/(t(l) - t(il))
!           The assumption that t(left).LT.t(left+1) makes denominator
!           in the factor nonzero.
      do j = 1,i
         a(i,j) = (a(i,j) - a(i - 1,j))*factor
      end do
      il = il - 1
      i = i - 1
   end do
!        For i = 1,...,k, combine B-coeffs a(.,i) with B-spline values
!        stored in dbiatx(.,M) to get value of  (M-1)ST  derivative of
!        i-TH B-spline (of interest here) at x, and store in
!        dbiatx(i,M). Storage of this value over the value of A B-spline
!        of order M there is safe since the remaining B-spline derivat-
!        ives of the same order do not use this value due to the fact
!        THAT  a(j,i) = 0  FOR j .LT. i .
   do i = 1,k
      sum = 0.0
      jlow = max(i,m)
      do j = jlow,k
         sum = a(j,i)*dbiatx(j,m) + sum
      end do
      dbiatx(i,m) = sum
   end do
end do
end subroutine bspvd

pure subroutine bstrp(tau, gtau, t, n, k, bcoef, q, iflag)
!! <!-- nswc-ford:begin BSTRP -->
!! Reference for `bstrp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!    This routine produces the B-spline COEFF.S bcoef of the piecewise
!!    polynomial of order k with knots t(i) (i=1,...,n+k) which has the
!!    value gtau(i) at tau(i) for i=1,...,n.
!! ******  i n P U t  ******
!!   tau.....array of length  n , containing data point abscissae.
!!     A S S U M P t i O n . . .  tau  is strictly increasing
!!   gtau.....corresponding array of length  n , containing data point
!!         ordinates.
!!   t.....knot sequence, of length  n+k
!!   n.....number of data points and dimension of spline space  S(k,t)
!!   k.....order of the piecewise polynomial
!!   iflag.....on an initial call to the routine, iflag may be assigned
!!         any value except 0. The routine may be recalled when only gtau
!!         is modified. iflag=0 When this is done.
!! ******  O U t P U t  ******
!!   bcoef.....the B-coefficients of the interpolant, of length  n
!!   q.....array of size  (2*k-1)*n , containing the triangular factoriz-
!!         ation of the coefficient matrix of the linear system for the B-
!!         coefficients of the spline interpolant.
!!   iflag.....an integer indicating success (= 0)  or failure (= 1)
!!         the linear system to be solved is (theoretically) invertible if
!!         and only if
!!               B(i)(tau(i)) .NE. 0   for all i.
!!         Violation of this condition is certain to lead to iflag = 1.
!! ******  M E t H O D  ******
!!      the i-TH equation of the linear system  A*bcoef = B  for the B-CO-
!!   effs of the interpolant enforces interpolation at  tau(i), i=1,...,n.
!!   Hence,  B(i) = gtau(i), all i, and  A  is a band matrix with  2k-1
!!   bands (if it is invertible).
!!      The matrix  A  is generated row by row and stored, diagonal by DI-
!!   agonal, in the  R O W S  of the array  q , with the main diagonal go-
!!   ing into row  k .  See comments in the program below.
!!      The banded system is then solved by a call to banfac (which con-
!!   structs the triangular factorization for  A  and stores it in  q),
!!   followed by a call to banslv (which then obtains the solution bcoef
!!   by substitution).
!!      banfac performs no pivoting since the total positivity of the
!!   matrix A makes this unnecessary.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: k, n
real, intent(inout) :: bcoef(n)
real, intent(in) :: gtau(n)
real, intent(inout) :: q(*)
real, intent(in) :: t(*), tau(n)
!     beginning of local variable declarations
integer :: i, ilp1mx, j, jj, km1, kpkm2, left, lenq, np1
real :: taui
interface
   pure subroutine banfac(w,nroww,nrow,nbandl,nbandu,iflag)
      implicit none
      integer, intent(in) :: nrow
      integer, intent(in) :: nroww
      real, intent(inout) :: w(nroww,nrow)
      integer, intent(in) :: nbandl
      integer, intent(in) :: nbandu
      integer, intent(out) :: iflag
   end subroutine banfac
   pure subroutine banslv(w,nroww,nrow,nbandl,nbandu,b)
      implicit none
      integer, intent(in) :: nrow
      integer, intent(in) :: nroww
      real, intent(in) :: w(nroww,nrow)
      integer, intent(in) :: nbandl
      integer, intent(in) :: nbandu
      real, intent(inout) :: b(nrow)
   end subroutine banslv
   pure subroutine bspvb(t,k,jhigh,j,x,left,blist)
      implicit none
      integer, intent(in) :: k
      real, intent(in) :: t(*)
      integer, intent(in) :: jhigh
      integer, intent(inout) :: j
      real, intent(in) :: x
      integer, intent(in) :: left
      real, intent(inout) :: blist(k)
   end subroutine bspvb
end interface
!-----------------------------------------------------------------------
!   This routine produces the B-spline COEFF.S bcoef of the piecewise
!   polynomial of order k with knots t(i) (i=1,...,n+k) which has the
!   value gtau(i) at tau(i) for i=1,...,n.
!******  i n P U t  ******
!  tau.....array of length  n , containing data point abscissae.
!    A S S U M P t i O n . . .  tau  is strictly increasing
!  gtau.....corresponding array of length  n , containing data point
!        ordinates.
!  t.....knot sequence, of length  n+k
!  n.....number of data points and dimension of spline space  S(k,t)
!  k.....order of the piecewise polynomial
!  iflag.....on an initial call to the routine, iflag may be assigned
!        any value except 0. The routine may be recalled when only gtau
!        is modified. iflag=0 When this is done.
!******  O U t P U t  ******
!  bcoef.....the B-coefficients of the interpolant, of length  n
!  q.....array of size  (2*k-1)*n , containing the triangular factoriz-
!        ation of the coefficient matrix of the linear system for the B-
!        coefficients of the spline interpolant.
!  iflag.....an integer indicating success (= 0)  or failure (= 1)
!        the linear system to be solved is (theoretically) invertible if
!        and only if
!              B(i)(tau(i)) .NE. 0   for all i.
!        Violation of this condition is certain to lead to iflag = 1.
!******  M E t H O D  ******
!     the i-TH equation of the linear system  A*bcoef = B  for the B-CO-
!  effs of the interpolant enforces interpolation at  tau(i), i=1,...,n.
!  Hence,  B(i) = gtau(i), all i, and  A  is a band matrix with  2k-1
!  bands (if it is invertible).
!     The matrix  A  is generated row by row and stored, diagonal by DI-
!  agonal, in the  R O W S  of the array  q , with the main diagonal go-
!  ing into row  k .  See comments in the program below.
!     The banded system is then solved by a call to banfac (which con-
!  structs the triangular factorization for  A  and stores it in  q),
!  followed by a call to banslv (which then obtains the solution bcoef
!  by substitution).
!     banfac performs no pivoting since the total positivity of the
!  matrix A makes this unnecessary.
!-----------------------------------------------------------------------
km1 = k - 1
if (iflag == 0) go to 60
np1 = n + 1
kpkm2 = 2*km1
if (n == 1) go to 20
!        Check if tau(i) is an increasing sequence
do i = 2,n
   if (tau(i) <= tau(i - 1)) go to 100
end do
!                Zero out all entries of q
20 if (tau(n) > t(np1)) go to 100
lenq = n*(k + km1)
do i = 1,lenq
   q(i) = 0.0
end do
!  ***   Loop over i to construct the n interpolation equations
left = k
do i = 1,n
   taui = tau(i)
   ilp1mx = min(i + k,np1)
!        *** Find  left  in the closed interval (i,i+k-1) such that
!                t(left) .LE. tau(i) .LT. t(left+1)
!        matrix is singular if this is not possible
   left = max(left,i)
   if (taui < t(left)) go to 100
30 if (taui < t(left + 1)) go to 40
   left = left + 1
   if (left < ilp1mx) go to 30
   if (left == i + k) go to 100
   left = n
!        *** The i-TH equation enforces interpolation at taui, hence
!        A(i,j) = B(j,k,t)(taui), all j. only the  k  entries with  j =
!        left-k+1,...,left actually might be nonzero. These  k  numbers
!        are returned, in  bcoef (used for temp.Storage here), by the
!        following
40 jj = 0
   call bspvb(t, k, k, jj, taui, left, bcoef)
!        Let q denote a two-dimensional array of dimension (2*k-1,n).
!        We therefore want  bcoef(j) = B(left-k+j)(taui) to go into
!        A(i,left-k+j), I.E., into  q(i-(left+j)+2*k,(left+j)-k) since
!        A(i+j,j)  is to go into  q(i+k,j), all i,j.  in the current
!        routine we treat q as an equivalent one-dimensional array.
!        Thus we want bcoef(j) to be inserted into entry
!            i - (left+j) + 2*k + ((left+j) - k-1)*(2*k-1)
!                   =  i-left+1 + (left - k)*(2*k-1) + (2*k-2)*j
!        OF  q .
   jj = i - left + 1 + (left - k)*(k + km1)
   do j = 1,k
      jj = jj + kpkm2
      q(jj) = bcoef(j)
   end do
end do
!     ***Obtain factorization of  A  , stored again in  q.
call banfac(q, k + km1, n, km1, km1, iflag)
iflag = iflag - 1
if (iflag /= 0) return
!     *** SOLVE  A*bcoef = gtau  BY BACKSUBSTITUTION
60 do i = 1,n
   bcoef(i) = gtau(i)
end do
call banslv(q, k + km1, n, km1, km1, bcoef)
return
!     *** Error return
100 iflag = 1
end subroutine bstrp

pure subroutine banfac(w, nroww, nrow, nbandl, nbandu, iflag)
!! <!-- nswc-ford:begin BANFAC -->
!! Reference for `banfac`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   From  * a practical guide to splines *  by C. DE boor
!!   returns in  w  the LU-factorization (without pivoting) of the banded
!!   matrix  A  of order  nrow  with  (nbandl + 1 + nbandu) bands or diag-
!!   onals in the work array  w .
!! ******  i N P U T  ******
!!   w.....work array of size  (nroww,nrow)  containing the interesting
!!         part of A banded matrix  A , with the diagonals or bands of  A
!!         stored in the rows of  w , while columns of  a  correspond to
!!         columns of  w . This is the storage mode used in  LINPACK  and
!!         results in efficient innermost loops.
!!            Explicitly,  A  has  nbandl  bands below the diagonal
!!                             +     1     (MAIN) DIAGONAL
!!                             +   nbandu  BANDS ABOVE THE DIAGONAL
!!         and thus, with    middle = nbandu + 1,
!!           A(i+j,j)  is in  w(i+middle,j)  for i=-nbandu,...,nbandl
!!                                               j=1,...,nrow .
!!         For example, the interesting entries of A (1,2)-banded matrix
!!         of order  9  would appear in the first  1+1+2 = 4  Rows of  w
!!         as follows.
!!                           13 24 35 46 57 68 79
!!                        12 23 34 45 56 67 78 89
!!                     11 22 33 44 55 66 77 88 99
!!                     21 32 43 54 65 76 87 98
!!         All other entries of  w  not identified in this way with an EN-
!!         try of  A  are never referenced .
!!   nroww.....row dimension of the work array  w .
!!         Must be  .GE.  nbandl + 1 + nbandu  .
!!   nbandl.....number of bands of  a  below the main diagonal
!!   nbandu.....number of bands of  a  above the main diagonal .
!! ******  O U T P U T  ******
!!   iflag.....integer indicating success( = 1) or failure ( = 2) .
!!      IF  iflag = 1, THEN
!!   w.....contains the LU-factorization of  a  into a unit lower triangu-
!!         lar matrix  L  and an upper triangular matrix  U (both banded)
!!         and stored in customary fashion over the corresponding entries
!!         of  A . This makes it possible to solve any particular linear
!!         SYSTEM  A*X = B  FOR  X  BY A
!!               call banslv ( w, nroww, nrow, nbandl, nbandu, b )
!!         with the solution X  contained in  B  on return .
!!      IF  iflag = 2, THEN
!!         one of  nrow-1, nbandl,nbandu failed to be nonnegative, or else
!!         one of the potential pivots was found to be zero indicating
!!         that  a  does not have an LU-factorization. This implies that
!!         A  is singular in case it is totally positive .
!! ******  M E T H O D  ******
!!      Gauss elimination  w i T H O U T  pivoting is used. The routine is
!!   intended for use with matrices  A  which do not require row inter-
!!   changes during factorization, especially for the  T O T A L L Y
!!   P O S i T i V E  matrices which occur in spline calculations.
!!      The routine should not be used for an arbitrary banded matrix.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: nbandl, nbandu, nrow, nroww
real, intent(inout) :: w(nroww,nrow)
!     beginning of local variable declarations
integer :: i, ipk, j, jbeg, jend, jmax, k, kmax, mdj, middle, midmk, mj, nrowm1, nswc_ai_i4
real :: factor, pivot
!  From  * a practical guide to splines *  by C. DE boor
!  returns in  w  the LU-factorization (without pivoting) of the banded
!  matrix  A  of order  nrow  with  (nbandl + 1 + nbandu) bands or diag-
!  onals in the work array  w .
!******  i N P U T  ******
!  w.....work array of size  (nroww,nrow)  containing the interesting
!        part of A banded matrix  A , with the diagonals or bands of  A
!        stored in the rows of  w , while columns of  a  correspond to
!        columns of  w . This is the storage mode used in  LINPACK  and
!        results in efficient innermost loops.
!           Explicitly,  A  has  nbandl  bands below the diagonal
!                            +     1     (MAIN) DIAGONAL
!                            +   nbandu  BANDS ABOVE THE DIAGONAL
!        and thus, with    middle = nbandu + 1,
!          A(i+j,j)  is in  w(i+middle,j)  for i=-nbandu,...,nbandl
!                                              j=1,...,nrow .
!        For example, the interesting entries of A (1,2)-banded matrix
!        of order  9  would appear in the first  1+1+2 = 4  Rows of  w
!        as follows.
!                          13 24 35 46 57 68 79
!                       12 23 34 45 56 67 78 89
!                    11 22 33 44 55 66 77 88 99
!                    21 32 43 54 65 76 87 98
!        All other entries of  w  not identified in this way with an EN-
!        try of  A  are never referenced .
!  nroww.....row dimension of the work array  w .
!        Must be  .GE.  nbandl + 1 + nbandu  .
!  nbandl.....number of bands of  a  below the main diagonal
!  nbandu.....number of bands of  a  above the main diagonal .
!******  O U T P U T  ******
!  iflag.....integer indicating success( = 1) or failure ( = 2) .
!     IF  iflag = 1, THEN
!  w.....contains the LU-factorization of  a  into a unit lower triangu-
!        lar matrix  L  and an upper triangular matrix  U (both banded)
!        and stored in customary fashion over the corresponding entries
!        of  A . This makes it possible to solve any particular linear
!        SYSTEM  A*X = B  FOR  X  BY A
!              call banslv ( w, nroww, nrow, nbandl, nbandu, b )
!        with the solution X  contained in  B  on return .
!     IF  iflag = 2, THEN
!        one of  nrow-1, nbandl,nbandu failed to be nonnegative, or else
!        one of the potential pivots was found to be zero indicating
!        that  a  does not have an LU-factorization. This implies that
!        A  is singular in case it is totally positive .
!******  M E T H O D  ******
!     Gauss elimination  w i T H O U T  pivoting is used. The routine is
!  intended for use with matrices  A  which do not require row inter-
!  changes during factorization, especially for the  T O T A L L Y
!  P O S i T i V E  matrices which occur in spline calculations.
!     The routine should not be used for an arbitrary banded matrix.
iflag = 1
middle = nbandu + 1
!                         w(middle,.) Contains the main diagonal of  A .
nrowm1 = nrow - 1
nswc_ai_i4 = nrowm1
if (nswc_ai_i4 < 0) go to 999
if (nswc_ai_i4 == 0) go to 900
go to 1
1 if (nbandl > 0) go to 10
!                A is upper triangular. Check that diagonal is nonzero .
do i = 1,nrowm1
   if (w(middle,i) == 0.) go to 999
end do
go to 900
10 if (nbandu > 0) go to 20
!              A is lower triangular. Check that diagonal is nonzero and
!                 divide each column by its diagonal .
do i = 1,nrowm1
   pivot = w(middle,i)
   if (pivot == 0.) go to 999
   jmax = min(nbandl, nrow - i)
   jbeg = middle + 1
   jend = middle + jmax
   do j = jbeg,jend
      w(j,i) = w(j,i)/pivot
   end do
end do
go to 900
!        A  is not just a triangular matrix. Construct LU factorization
20 do i = 1,nrowm1
!                                  w(middle,i)  is pivot for i-TH step .
   pivot = w(middle,i)
   if (pivot == 0.) go to 999
!                 jmax  is the number of (nonzero) entries in column  i
!                     below the diagonal .
   jmax = min(nbandl,nrow - i)
!              Divide each entry in column  i  below diagonal by pivot .
   jbeg = middle + 1
   jend = middle + jmax
   do j = jbeg,jend
      w(j,i) = w(j,i)/pivot
   end do
!                 kmax  is the number of (nonzero) entries in row  i  to
!                     the right of the diagonal .
   kmax = min(nbandu,nrow - i)
!                  Subtract  A(i,i+k)*(i-TH column) from (i+k)-TH column
!                  (below row  i ) .
   do k = 1,kmax
      ipk = i + k
      midmk = middle - k
      factor = w(midmk,ipk)
      do j = 1,jmax
         mj = middle + j
         mdj = midmk + j
         w(mdj,ipk) = w(mdj,ipk) - w(mj,i)*factor
      end do
   end do
end do
!                                       Check the last diagonal entry .
900 if (w(middle,nrow) /= 0.) return
999 iflag = 2
end subroutine banfac

pure subroutine banslv(w, nroww, nrow, nbandl, nbandu, b)
!! <!-- nswc-ford:begin BANSLV -->
!! Reference for `banslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   From  * a practical guide to splines *  by C. DE boor
!!   companion routine to  banfac . It returns the solution  X  of the
!!   linear system  A*X = b  in place of  b , given the LU-factorization
!!   for  A  in the workarray  w .
!! ******  i N P U T  ******
!!   w, nroww,nrow,nbandl,nbandu.....describe the LU-factorization of A
!!         banded matrix  A  of roder  nrow  as constructed in  banfac .
!!         For details, see  banfac .
!!   b.....right side of the system to be solved .
!! ******  O U T P U T  ******
!!   b.....contains the solution  X , of order  nrow .
!! ******  M E T H O D  ******
!!      (with  A = L*U, as stored in  w,) the unit lower triangular system
!!   L(U*X) = b  is solved for  Y = U*X, and  Y  stored in  b . Then the
!!   upper triangular system  U*X = Y  is solved for  X  . The CALCUL-
!!   ations are so arranged that the innermost loops stay within columns.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nbandl, nbandu, nrow, nroww
real, intent(in) :: w(nroww,nrow)
real, intent(inout) :: b(nrow)
!     beginning of local variable declarations
integer :: i, imj, ipj, j, jmax, middle, mmj, mpj, nrowm1
!  From  * a practical guide to splines *  by C. DE boor
!  companion routine to  banfac . It returns the solution  X  of the
!  linear system  A*X = b  in place of  b , given the LU-factorization
!  for  A  in the workarray  w .
!******  i N P U T  ******
!  w, nroww,nrow,nbandl,nbandu.....describe the LU-factorization of A
!        banded matrix  A  of roder  nrow  as constructed in  banfac .
!        For details, see  banfac .
!  b.....right side of the system to be solved .
!******  O U T P U T  ******
!  b.....contains the solution  X , of order  nrow .
!******  M E T H O D  ******
!     (with  A = L*U, as stored in  w,) the unit lower triangular system
!  L(U*X) = b  is solved for  Y = U*X, and  Y  stored in  b . Then the
!  upper triangular system  U*X = Y  is solved for  X  . The CALCUL-
!  ations are so arranged that the innermost loops stay within columns.
middle = nbandu + 1
if (nrow == 1) go to 49
nrowm1 = nrow - 1
if (nbandl == 0) go to 30
!                                 Forward pass
!            for i=1,2,...,nrow-1, subtract  right side(i)*(i-TH column
!            of  L )  from right side  (below i-TH row) .
do i = 1,nrowm1
   jmax = min(nbandl, nrow - i)
   do j = 1,jmax
      ipj = i + j
      mpj = middle + j
      b(ipj) = b(ipj) - b(i)*w(mpj,i)
   end do
end do
!                                 Backward pass
!            for i=nrow,nrow-1,...,1, divide right side(i) by i-TH diag-
!            onal entry of  U, then subtract  right side(i)*(i-TH column
!            of  U)  from right side  (above i-TH row).
30 if (nbandu > 0) go to 40
!                                A  is lower triangular .
do i = 1,nrow
   b(i) = b(i)/w(1,i)
end do
return
40 i = nrow
41 b(i) = b(i)/w(middle,i)
jmax = min(nbandu,i - 1)
do j = 1,jmax
   imj = i - j
   mmj = middle - j
   b(imj) = b(imj) - b(i)*w(mmj,i)
end do
i = i - 1
if (i > 1) go to 41
49 b(1) = b(1)/w(middle,1)
end subroutine banslv

pure subroutine bslsq(tau, gtau, wgt, ntau, t, n, k, a, wk, q, ierr)
!! <!-- nswc-ford:begin BSLSQ -->
!! Reference for `bslsq`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         bslsq produces the B-spline coefficients of a piecewise
!!               polynomial P(X) of order k which minimizes
!!                 sum (wgt(j)*(P(tau(j)) - gtau(j))**2).
!!      Input ...
!!        tau   ARRAY OF LENGTH ntau CONTAINING DATA POINT ABSCISSAE.
!!        gtau  array of length ntau containing data point ordinates.
!!        wgt   ARRAY OF LENGTH ntau CONTAINING THE WEIGHTS.
!!        ntau  number of data points to be fitted.
!!        t     KNOT SEQUENCE OF LENGTH n + k.
!!        n     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!!        k     ORDER OF THE B-SPLINES.
!!      Output ...
!!        A     ARRAY OF LENGTH n CONTAINING THE B-SPLINE COEFFICIENTS
!!              of the L2 approximation.
!!        ierr  integer reporting the status of the results ...
!!              0  the coefficient matrix is nonsigular. The
!!                 unique least squares solution was obtained.
!!              1  The coefficient matrix is singular. A
!!                 least squares solution was obtained.
!!             -1  Input errors were detected.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: k, n, ntau
real, intent(in) :: tau(ntau), gtau(ntau), wgt(ntau)
real, intent(in) :: t(*)
real, intent(inout) :: a(n), wk(n), q(k,n)
!     beginning of local variable declarations
integer :: i, j, jj, l, left, leftmk, mm
real :: dw
interface
   pure subroutine bchfac(w,nb,n,diag,iflag)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nb
      real, intent(inout) :: w(nb,n)
      real, intent(inout) :: diag(n)
      integer, intent(inout) :: iflag
   end subroutine bchfac
   pure subroutine bchslv(w,nb,n,b)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nb
      real, intent(in) :: w(nb,n)
      real, intent(inout) :: b(n)
   end subroutine bchslv
   pure subroutine bspvb(t,k,jhigh,j,x,left,blist)
      implicit none
      integer, intent(in) :: k
      real, intent(in) :: t(*)
      integer, intent(in) :: jhigh
      integer, intent(inout) :: j
      real, intent(in) :: x
      integer, intent(in) :: left
      real, intent(inout) :: blist(k)
   end subroutine bspvb
end interface
!-----------------------------------------------------------------------
!        bslsq produces the B-spline coefficients of a piecewise
!              polynomial P(X) of order k which minimizes
!                sum (wgt(j)*(P(tau(j)) - gtau(j))**2).
!     Input ...
!       tau   ARRAY OF LENGTH ntau CONTAINING DATA POINT ABSCISSAE.
!       gtau  array of length ntau containing data point ordinates.
!       wgt   ARRAY OF LENGTH ntau CONTAINING THE WEIGHTS.
!       ntau  number of data points to be fitted.
!       t     KNOT SEQUENCE OF LENGTH n + k.
!       n     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!       k     ORDER OF THE B-SPLINES.
!     Output ...
!       A     ARRAY OF LENGTH n CONTAINING THE B-SPLINE COEFFICIENTS
!             of the L2 approximation.
!       ierr  integer reporting the status of the results ...
!             0  the coefficient matrix is nonsigular. The
!                unique least squares solution was obtained.
!             1  The coefficient matrix is singular. A
!                least squares solution was obtained.
!            -1  Input errors were detected.
!-----------------------------------------------------------------------
if (ntau < max(2,k)) go to 100
if (tau(1) < t(k) .or. tau(ntau) > t(n + 1)) go to 100
do i = 2,ntau
   if (tau(i - 1) > tau(i)) go to 100
end do
do j = 1,n
   a(j) = 0.0
   do i = 1,k
      q(i,j) = 0.0
   end do
end do
left = k
do l = 1,ntau
!        *** Find the index left such that
!            t(left) .LE. tau(l) .LT. t(left+1)
30 if (left == n) go to 40
   if (tau(l) < t(left + 1)) go to 40
   left = left + 1
   go to 30
40 jj = 0
   call bspvb(t, k, k, jj, tau(l), left, wk)
   leftmk = left - k
   do mm = 1,k
      dw = wk(mm)*wgt(l)
      j = leftmk + mm
      a(j) = dw*gtau(l) + a(j)
      i = 1
      do jj = mm,k
         q(i,j) = wk(jj)*dw + q(i,j)
         i = i + 1
      end do
   end do
end do
!        Solve the normal equations
call bchfac(q, k, n, wk, ierr)
call bchslv(q, k, n, a)
return
!             Error return
100 ierr = -1
end subroutine bslsq

pure subroutine bchfac(w, nb, n, diag, iflag)
!! <!-- nswc-ford:begin BCHFAC -->
!! Reference for `bchfac`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   From  * a practical guide to splines *  by C. DE boor
!!   constructs Cholesky factorization
!!                      c  =  l * d * l-transpose
!!   with L unit lower triangular and D diagonal, for given matrix C of
!!   order  n , in case  C  is (symmetric) positive semidefinite
!!   and banded, having nb diagonals at and below the main diagonal.
!! ******  INPUT  ******
!!      n      THE ORDER OF THE MATRIX C.
!!      nb     THE BANDWIDTH OF C, I.E.,
!!                C(i,j) = 0 FOR abs(i-j) .GT. nb .
!!      w      WORK ARRAY OF SIZE nb BY n CONTAINING THE nb DIAGONALS
!!             in its rows, with the main diagonal in row 1. Precisely,
!!             w(i,j)  CONTAINS  C(i+j-1,j), i=1,...,nb, j=1,...,n.
!!             For example, the interesting entries of a seven diagonal
!!             symmetric matrix C of order 9 would be stored in w as
!!                        11 22 33 44 55 66 77 88 99
!!                        21 32 43 54 65 76 87 98
!!                        31 42 53 64 75 86 97
!!                        41 52 63 74 85 96
!!             All other entries of w not identified with an entry of C
!!             are never referenced.
!!      DIAG   WORK ARRAY OF LENGTH n.
!! ******  O U t P U t  ******
!!                                                          t
!!      w      contains the Cholesky factorization C = L*D*L   where
!!             w(1,i) = 1/D(i,i) AND w(i,j) = L(i-1+j,j) (i=2,...,nb).
!!      iflag  0 if C is nonsingular and 1 if C is singular.
!! ******  M E t H O D  ******
!!    Gauss elimination, adapted to the symmetry and bandedness of  C , is
!!    used .
!!      Near zero pivots are handled in a special way. The diagonal ele-
!!   MENT C(k,k) = w(1,k) is saved initially in  diag(k), all k. at the k-
!!   TH elimination step, the current pivot element, viz.  w(1,k), is com-
!!   pared with its original value, diag(k). If, as the result of prior
!!   elimination steps, this element has been reduced by about a word
!!   length, (I.E., if w(1,k)+diag(k) .LE. diag(k)), then the pivot is DE-
!!   clared to be zero, and the entire k-TH row is declared to be linearly
!!   dependent on the preceding rows. This has the effect of producing
!!    X(k) = 0  When solving  C*X = B  for  X, regardless of  B. JUSTIFIC-
!!   ation for this is as follows. In contemplated applications of this
!!   program, the given equations are the normal equations for some least-
!!   squares approximation problem, diag(k) = C(k,k) gives the norm-square
!!   of the k-TH basis function, and, at this point,  w(1,k)  contains the
!!   norm-square of the error in the least-squares approximation to the k-
!!   TH basis function BY linear combinations of the first k-1 . Having
!!   w(1,k)+diag(k) .LE. diag(k) signifies that the k-TH function is lin-
!!   early dependent to machine accuracy on the first k-1 functions, there
!!   fore can safely be left out from the basis of approximating functions
!!      the solution of a linear system
!!                        C*X = B
!!    is effected by the succession of the following  t w O  calls ...
!!      call bchfac (w, nb, n, diag, iflag)   , to get factorization
!!      call bchslv (w, nb, n, b, x )            , to solve for x.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: n, nb
real, intent(inout) :: w(nb,n), diag(n)
!     beginning of local variable declarations
integer :: i, imax, ipj, j, jmax, k, kpi
real :: ratio, t
!-----------------------------------------------------------------------
!  From  * a practical guide to splines *  by C. DE boor
!  constructs Cholesky factorization
!                     c  =  l * d * l-transpose
!  with L unit lower triangular and D diagonal, for given matrix C of
!  order  n , in case  C  is (symmetric) positive semidefinite
!  and banded, having nb diagonals at and below the main diagonal.
!******  INPUT  ******
!     n      THE ORDER OF THE MATRIX C.
!     nb     THE BANDWIDTH OF C, I.E.,
!               C(i,j) = 0 FOR abs(i-j) .GT. nb .
!     w      WORK ARRAY OF SIZE nb BY n CONTAINING THE nb DIAGONALS
!            in its rows, with the main diagonal in row 1. Precisely,
!            w(i,j)  CONTAINS  C(i+j-1,j), i=1,...,nb, j=1,...,n.
!            For example, the interesting entries of a seven diagonal
!            symmetric matrix C of order 9 would be stored in w as
!                       11 22 33 44 55 66 77 88 99
!                       21 32 43 54 65 76 87 98
!                       31 42 53 64 75 86 97
!                       41 52 63 74 85 96
!            All other entries of w not identified with an entry of C
!            are never referenced.
!     DIAG   WORK ARRAY OF LENGTH n.
!******  O U t P U t  ******
!                                                         t
!     w      contains the Cholesky factorization C = L*D*L   where
!            w(1,i) = 1/D(i,i) AND w(i,j) = L(i-1+j,j) (i=2,...,nb).
!     iflag  0 if C is nonsingular and 1 if C is singular.
!******  M E t H O D  ******
!   Gauss elimination, adapted to the symmetry and bandedness of  C , is
!   used .
!     Near zero pivots are handled in a special way. The diagonal ele-
!  MENT C(k,k) = w(1,k) is saved initially in  diag(k), all k. at the k-
!  TH elimination step, the current pivot element, viz.  w(1,k), is com-
!  pared with its original value, diag(k). If, as the result of prior
!  elimination steps, this element has been reduced by about a word
!  length, (I.E., if w(1,k)+diag(k) .LE. diag(k)), then the pivot is DE-
!  clared to be zero, and the entire k-TH row is declared to be linearly
!  dependent on the preceding rows. This has the effect of producing
!   X(k) = 0  When solving  C*X = B  for  X, regardless of  B. JUSTIFIC-
!  ation for this is as follows. In contemplated applications of this
!  program, the given equations are the normal equations for some least-
!  squares approximation problem, diag(k) = C(k,k) gives the norm-square
!  of the k-TH basis function, and, at this point,  w(1,k)  contains the
!  norm-square of the error in the least-squares approximation to the k-
!  TH basis function BY linear combinations of the first k-1 . Having
!  w(1,k)+diag(k) .LE. diag(k) signifies that the k-TH function is lin-
!  early dependent to machine accuracy on the first k-1 functions, there
!  fore can safely be left out from the basis of approximating functions
!     the solution of a linear system
!                       C*X = B
!   is effected by the succession of the following  t w O  calls ...
!     call bchfac (w, nb, n, diag, iflag)   , to get factorization
!     call bchslv (w, nb, n, b, x )            , to solve for x.
!-----------------------------------------------------------------------
if (n > 1) go to 10
iflag = 1
if (w(1,1) == 0.0) return
iflag = 0
w(1,1) = 1.0/w(1,1)
return
!     Store the diagonal of C in diag
10 do k = 1,n
   diag(k) = w(1,k)
end do
!     Factorization
iflag = 0
do k = 1,n
   t = w(1,k) + diag(k)
   if (t /= diag(k)) go to 30
   iflag = 1
   do j = 1,nb
      w(j,k) = 0.0
   end do
   go to 60
30 t = 1.0/w(1,k)
   w(1,k) = t
   imax = min(nb - 1,n - k)
   if (imax < 1) go to 60
   jmax = imax
   do i = 1,imax
      ratio = t*w(i + 1,k)
      kpi = k + i
      do j = 1,jmax
         ipj = i + j
         w(j,kpi) = w(j,kpi) - w(ipj,k)*ratio
      end do
      jmax = jmax - 1
      w(i + 1,k) = ratio
   end do
60 continue
end do
end subroutine bchfac

pure subroutine bchslv(w, nb, n, b)
!! <!-- nswc-ford:begin BCHSLV -->
!! Reference for `bchslv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bchslv solves the linear system C*X = b for X when w contains
!!      the Cholesky factorization obtained by the subroutine bchfac
!!      for the banded symmetric positive definite matrix C.
!!      Input ...
!!         n   THE ORDER OF THE MATRIX C
!!         nb  the bandwidth of C
!!         w   THE CHOLESKY FACTORIZATION OF C
!!         b   VECTOR OF LENGTH n CONTAINING THE RIGHT SIDE
!!      output ...
!!         b   solution X of the linear system C*X = b
!!                                        T
!!      note.  The factorization C = L*D*L  is used, where L is A
!!      unit lower triangular matrix and D a diagonal matrix.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, nb
real, intent(in) :: w(nb,n)
real, intent(inout) :: b(n)
!     beginning of local variable declarations
integer :: j, jmax, jpk, k, nbm1
!-----------------------------------------------------------------------
!     bchslv solves the linear system C*X = b for X when w contains
!     the Cholesky factorization obtained by the subroutine bchfac
!     for the banded symmetric positive definite matrix C.
!     Input ...
!        n   THE ORDER OF THE MATRIX C
!        nb  the bandwidth of C
!        w   THE CHOLESKY FACTORIZATION OF C
!        b   VECTOR OF LENGTH n CONTAINING THE RIGHT SIDE
!     output ...
!        b   solution X of the linear system C*X = b
!                                       T
!     note.  The factorization C = L*D*L  is used, where L is A
!     unit lower triangular matrix and D a diagonal matrix.
!-----------------------------------------------------------------------
if (n > 1) go to 10
b(1) = b(1)*w(1,1)
return
!     Forward substitution. Solve L*Y = b for Y and store Y in b.
10 nbm1 = nb - 1
do k = 1,n
   jmax = min(nbm1,n - k)
   if (jmax < 1) go to 30
   do j = 1,jmax
      jpk = j + k
      b(jpk) = b(jpk) - w(j + 1,k)*b(k)
   end do
30 continue
end do
!                              T     -1
!     backsubstitution. Solve L X = D  Y  for X and store X in b.
k = n
40 b(k) = b(k)*w(1,k)
jmax = min(nbm1,n - k)
if (jmax < 1) go to 60
do j = 1,jmax
   jpk = j + k
   b(k) = b(k) - w(j + 1,k)*b(jpk)
end do
60 k = k - 1
if (k > 0) go to 40
end subroutine bchslv

subroutine bfit(bkpt, n, nord, xdata, ydata, ndata, &
   & xconst, yconst, nderiv, nconst, &
   & mode, coeff, rnorm, w, iw)
!! <!-- nswc-ford:begin BFIT -->
!! Reference for `bfit`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!       This subprogram fits a piece-wise polynomial curve
!!       to discrete data.  The piece-wise polynomials are
!!       represented as B-splines.
!!       The fitting is done in a least squares sense.
!!       Equality and inequality constraints can be imposed
!!       on the fitted curve.
!!   Input..
!!       n,nord,bkpt(*)     n IS THE NUMBER OF COEFFICIENTS TO BE COM-
!!                          puted and nord is the order of the B-spline.
!!                          It is assumed that n .GE. nord. The n + nord
!!                          knots of the spline are in the array bkpt(*).
!!                          It is assumed that the knots form a nonde-
!!                          creasing sequence. The problem data interval
!!                          lies between the points bkpt(nord) and
!!                          bkpt(n+1). The additional end knots bkpt(I),
!!                          I = 1,...,nord-1 AND I = n+2,...,n+nord, ARE
!!                          required to compute the functions used to
!!                          fit the data.
!!                          (The order of the B-spline is one more than
!!                          the degree of the piecewise polynomial. For
!!                          example, nord=4 When we are using piecewise
!!                          cubics.)
!!       ndata,xdata(*),
!!       ydata(*)           THE ndata DISCRETE (X,Y) PAIRS ARE IN
!!                          the arrays xdata(*) and ydata(*). It is
!!                          assumed that xdata(*) is an increasing
!!                          SEQUENCE, xdata(1) .GE. bkpt(nord), AND
!!                          xdata(ndata) .LE. bkpt(n+1).
!!       nconst,xconst(*),
!!       yconst(*),nderiv(*)
!!                          the number of conditions that constrain
!!                          the B-spline is nconst. A constraint is
!!                          specified by an (X,Y) pair in the arrays
!!                          xconst(*) and yconst(*), and by the type
!!                          of constraint and derivative value encoded
!!                          in the array nderiv(*). It is assumed that
!!                          the values in xconst(*) are in the closed
!!                          interval (bkpt(nord),bkpt(n+1)). The con-
!!                          straints may be given in any order. The
!!                          value of nderiv(*) is determined as follows.
!!                          Suppose the I-TH constraint applies to the
!!                          J-TH derivative of the B-spline.  (Any
!!                          nonnegative value of J .LT. nord is permitted.
!!                          In particular, the value J = 0 Refers to the
!!                          B-spline itself.)
!!                          for this I-TH constraint, set
!!                           xconst(i) = x,
!!                           yconst(i) = y, and
!!                           nderiv(I) = ITYPE + 4*J  WHERE
!!                           ITYPE = 0,      IF (J-TH DERIV. AT X) .LE. Y.
!!                                 = 1,      IF (J-TH DERIV. AT X) .GE. Y.
!!                                 = 2,      IF (J-TH DERIV. AT X) .EQ. Y.
!!                                 = 3,      IF (J-TH DERIV. AT X) .EQ.
!!                                              (J-TH deriv. At Y).
!!                           (A negative value for nderiv(I) will cause
!!                           this constraint to be ignored.  This
!!                           feature is often useful when temporarily
!!                           suppressing a constraint while still
!!                           retaining the source code of the calling
!!                           program.)
!!       MODE               AN INPUT FLAG THAT DIRECTS THE LEAST
!!                          squares solution method used by bfit( ).
!!                          mode = 0      A NEW PROBLEM.
!!                          mode .NE. 0   an old problem.
!!                          By an old problem it is meant that bfit( )
!!                          was last called with the same set of knots
!!                          and data points. (The constraints may be
!!                          different than before.)
!!       iw(1),iw(2)        THE AMOUNTS OF WORKING STORAGE ACTUALLY
!!                          allocated for the working arrays w(*) and
!!                          iw(*).  These quantities are compared with the
!!                          actual amounts of storage needed in bfit( ).
!!                          Insufficient storage allocated for
!!                          either w(*) or iw(*) is an error.
!!                          Length of w(*) must be at least
!!                            nb = (n + 3)*(nord + 1) + nord**2
!!                          and the length of iw(*) must be at least 2.
!!                          Whenever possible the code uses banded matrix
!!                          processors bndacc( ) and bndsl( ).  These
!!                          are utilized if there are no constraints and
!!                          there is sufficient data to uniquely determine
!!                          the B-spline coefficents.
!!                          If the band processors cannot be used to
!!                          determine the solution, then the constrained
!!                          least squares code lsei( ) is used.
!!                          In this case the subprogram requires an
!!                          additional block of storage in w(*).  For the
!!                          discussion here define the integers
!!                          NEQCON and NINCON respectively as the
!!                          number of equality (ITYPE=2,3) and
!!                          INEQUALITY (ITYPE=0,1) CONSTRAINTS
!!                          imposed on the fitted curve.  Define
!!                            l = n + 1
!!                          and note that
!!                            nconst = neqcon + nincon.
!!                          When the subprogram bfit( ) uses lsei( ) the
!!                          length of the working array w(*) must be at
!!                          least
!!                            lw = nb + (l+nconst)*l + 2*(neqcon+l)
!!                                    + (NINCON + L) + (NINCON+2)*(L+6)
!!                          and the length of the array iw(*) must be at
!!                          least
!!                            iw1 = nincon + 2*l .
!!   Output..
!!       MODE               AN OUTPUT FLAG THAT INDICATES THE STATUS
!!                          of the constrained curve fit.
!!                          =-1  EITHER nord .LT. 1 OR nord .GT. n.
!!                          =-2  EITHER ndata .LT. 1 OR nconst .LT. 0.
!!                          =-3  bkpt(I) .GT. bkpt(I+1) for some I.
!!                          =-4  xdata(*) is not an increasing
!!                               sequence in the closed interval
!!                               (bkpt(nord), bkpt(n+1)).
!!                          =-5  The I-TH constraint is incorrect
!!                               for the value of I stored in iw(2).
!!                          =-6  Insuff. Storage for w(*). iw(1) has
!!                               been reset to the amount of storage
!!                               needed by w(*).
!!                          =-7  Insuff. Storage for iw(*). iw(2) has
!!                               been reset to the amount of storage
!!                               needed by iw(*).
!!                          = 0  Successful constrained curve fit.
!!                          = 1  The requested equality constraints
!!                               are contradictory.
!!                          = 2  The problem cannot be solved. The
!!                               constraints are contradictory.
!!       coeff(*)
!!                          if the output value of mode=0 Or 1, coeff(*)
!!                          contains the n unknowns obtained from the
!!                          least squares fitting process.  These n
!!                          parameters are the B-spline coefficients.
!!                          For mode=1, the equality constraints are
!!                          contradictory.  To make the fitting process
!!                          more robust, the equality constraints are
!!                          satisfied in a least squares sense.  In
!!                          this case the array coeff(*) contains
!!                          B-spline coefficients for this extended
!!                          concept of a solution.
!!                          If mode .LT. 0 or mode = 2 On output, the
!!                          array coeff(*) is undefined.
!!       rnorm              if the output value of mode = 0 Or 1 then
!!                          rnorm is the L2 norm of the vector
!!                          (ydata(I) - F(xdata(I)), I = 1,ndata).
!!   Working arrays..
!!       w(*),iw(*)         THESE ARRAYS ARE RESPECTIVELY TYPED
!!                          real and integer.  Their required
!!                          lengths are specified as input parameters
!!                          in iw(1), iw(2) noted above. It is assumed
!!                          that w(1),...,w(NB) have not been modified
!!                          if bfit( ) is being recalled for the same
!!                          knots and data as before (I.E., if we have
!!                          an old problem).
!!    Reference.  Hanson R.J., constrained least squares curve fitting
!!                to discrete data using B-splines, a users guide.
!!                Sandia labs. Tech. Rept. Sand-78-1291, DEC, 1978.
!!
!!    Written by
!!      richard J. Hanson
!!      Sandia Laboratories
!!    modified by A.H. Morris (NSWC)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: mode
integer, intent(in) :: n, nconst, ndata, nord
real, intent(inout) :: rnorm
real, intent(in) :: bkpt(*), xdata(ndata), ydata(ndata)
real, intent(in) :: xconst(*), yconst(*)
real, intent(inout) :: coeff(n), w(*)
integer, intent(in) :: nderiv(*)
integer, intent(inout) :: iw(*)
!     beginning of local variable declarations
integer :: i1, i2, i3, i7, mdg, mdw, nbkpt
!-----------------------------------------------------------------------
!      This subprogram fits a piece-wise polynomial curve
!      to discrete data.  The piece-wise polynomials are
!      represented as B-splines.
!      The fitting is done in a least squares sense.
!      Equality and inequality constraints can be imposed
!      on the fitted curve.
!  Input..
!      n,nord,bkpt(*)     n IS THE NUMBER OF COEFFICIENTS TO BE COM-
!                         puted and nord is the order of the B-spline.
!                         It is assumed that n .GE. nord. The n + nord
!                         knots of the spline are in the array bkpt(*).
!                         It is assumed that the knots form a nonde-
!                         creasing sequence. The problem data interval
!                         lies between the points bkpt(nord) and
!                         bkpt(n+1). The additional end knots bkpt(I),
!                         I = 1,...,nord-1 AND I = n+2,...,n+nord, ARE
!                         required to compute the functions used to
!                         fit the data.
!                         (The order of the B-spline is one more than
!                         the degree of the piecewise polynomial. For
!                         example, nord=4 When we are using piecewise
!                         cubics.)
!      ndata,xdata(*),
!      ydata(*)           THE ndata DISCRETE (X,Y) PAIRS ARE IN
!                         the arrays xdata(*) and ydata(*). It is
!                         assumed that xdata(*) is an increasing
!                         SEQUENCE, xdata(1) .GE. bkpt(nord), AND
!                         xdata(ndata) .LE. bkpt(n+1).
!      nconst,xconst(*),
!      yconst(*),nderiv(*)
!                         the number of conditions that constrain
!                         the B-spline is nconst. A constraint is
!                         specified by an (X,Y) pair in the arrays
!                         xconst(*) and yconst(*), and by the type
!                         of constraint and derivative value encoded
!                         in the array nderiv(*). It is assumed that
!                         the values in xconst(*) are in the closed
!                         interval (bkpt(nord),bkpt(n+1)). The con-
!                         straints may be given in any order. The
!                         value of nderiv(*) is determined as follows.
!                         Suppose the I-TH constraint applies to the
!                         J-TH derivative of the B-spline.  (Any
!                         nonnegative value of J .LT. nord is permitted.
!                         In particular, the value J = 0 Refers to the
!                         B-spline itself.)
!                         for this I-TH constraint, set
!                          xconst(i) = x,
!                          yconst(i) = y, and
!                          nderiv(I) = ITYPE + 4*J  WHERE
!                          ITYPE = 0,      IF (J-TH DERIV. AT X) .LE. Y.
!                                = 1,      IF (J-TH DERIV. AT X) .GE. Y.
!                                = 2,      IF (J-TH DERIV. AT X) .EQ. Y.
!                                = 3,      IF (J-TH DERIV. AT X) .EQ.
!                                             (J-TH deriv. At Y).
!                          (A negative value for nderiv(I) will cause
!                          this constraint to be ignored.  This
!                          feature is often useful when temporarily
!                          suppressing a constraint while still
!                          retaining the source code of the calling
!                          program.)
!      MODE               AN INPUT FLAG THAT DIRECTS THE LEAST
!                         squares solution method used by bfit( ).
!                         mode = 0      A NEW PROBLEM.
!                         mode .NE. 0   an old problem.
!                         By an old problem it is meant that bfit( )
!                         was last called with the same set of knots
!                         and data points. (The constraints may be
!                         different than before.)
!      iw(1),iw(2)        THE AMOUNTS OF WORKING STORAGE ACTUALLY
!                         allocated for the working arrays w(*) and
!                         iw(*).  These quantities are compared with the
!                         actual amounts of storage needed in bfit( ).
!                         Insufficient storage allocated for
!                         either w(*) or iw(*) is an error.
!                         Length of w(*) must be at least
!                           nb = (n + 3)*(nord + 1) + nord**2
!                         and the length of iw(*) must be at least 2.
!                         Whenever possible the code uses banded matrix
!                         processors bndacc( ) and bndsl( ).  These
!                         are utilized if there are no constraints and
!                         there is sufficient data to uniquely determine
!                         the B-spline coefficents.
!                         If the band processors cannot be used to
!                         determine the solution, then the constrained
!                         least squares code lsei( ) is used.
!                         In this case the subprogram requires an
!                         additional block of storage in w(*).  For the
!                         discussion here define the integers
!                         NEQCON and NINCON respectively as the
!                         number of equality (ITYPE=2,3) and
!                         INEQUALITY (ITYPE=0,1) CONSTRAINTS
!                         imposed on the fitted curve.  Define
!                           l = n + 1
!                         and note that
!                           nconst = neqcon + nincon.
!                         When the subprogram bfit( ) uses lsei( ) the
!                         length of the working array w(*) must be at
!                         least
!                           lw = nb + (l+nconst)*l + 2*(neqcon+l)
!                                   + (NINCON + L) + (NINCON+2)*(L+6)
!                         and the length of the array iw(*) must be at
!                         least
!                           iw1 = nincon + 2*l .
!  Output..
!      MODE               AN OUTPUT FLAG THAT INDICATES THE STATUS
!                         of the constrained curve fit.
!                         =-1  EITHER nord .LT. 1 OR nord .GT. n.
!                         =-2  EITHER ndata .LT. 1 OR nconst .LT. 0.
!                         =-3  bkpt(I) .GT. bkpt(I+1) for some I.
!                         =-4  xdata(*) is not an increasing
!                              sequence in the closed interval
!                              (bkpt(nord), bkpt(n+1)).
!                         =-5  The I-TH constraint is incorrect
!                              for the value of I stored in iw(2).
!                         =-6  Insuff. Storage for w(*). iw(1) has
!                              been reset to the amount of storage
!                              needed by w(*).
!                         =-7  Insuff. Storage for iw(*). iw(2) has
!                              been reset to the amount of storage
!                              needed by iw(*).
!                         = 0  Successful constrained curve fit.
!                         = 1  The requested equality constraints
!                              are contradictory.
!                         = 2  The problem cannot be solved. The
!                              constraints are contradictory.
!      coeff(*)
!                         if the output value of mode=0 Or 1, coeff(*)
!                         contains the n unknowns obtained from the
!                         least squares fitting process.  These n
!                         parameters are the B-spline coefficients.
!                         For mode=1, the equality constraints are
!                         contradictory.  To make the fitting process
!                         more robust, the equality constraints are
!                         satisfied in a least squares sense.  In
!                         this case the array coeff(*) contains
!                         B-spline coefficients for this extended
!                         concept of a solution.
!                         If mode .LT. 0 or mode = 2 On output, the
!                         array coeff(*) is undefined.
!      rnorm              if the output value of mode = 0 Or 1 then
!                         rnorm is the L2 norm of the vector
!                         (ydata(I) - F(xdata(I)), I = 1,ndata).
!  Working arrays..
!      w(*),iw(*)         THESE ARRAYS ARE RESPECTIVELY TYPED
!                         real and integer.  Their required
!                         lengths are specified as input parameters
!                         in iw(1), iw(2) noted above. It is assumed
!                         that w(1),...,w(NB) have not been modified
!                         if bfit( ) is being recalled for the same
!                         knots and data as before (I.E., if we have
!                         an old problem).
!   Reference.  Hanson R.J., constrained least squares curve fitting
!               to discrete data using B-splines, a users guide.
!               Sandia labs. Tech. Rept. Sand-78-1291, DEC, 1978.
!-----------------------------------------------------------------------
!   Written by
!     richard J. Hanson
!     Sandia Laboratories
!   modified by A.H. Morris (NSWC)
!-----------------------------------------------------------------------
nbkpt = n + nord
mdg = n + 3
mdw = n + 1 + nconst
!                         Usage in bfit0( ) of w(*)..
!      i1,...,i2-1      G(*,*)
!      i2,...,i3-1      BF(*,*)
!      i3,...,i7-1      w(*,*)
!      i7,...           WORK(*) FOR bspvd( ) AND lsei( )
i1 = 1
i2 = i1 + mdg*(nord + 1)
i3 = i2 + nord*nord
i7 = i3 + mdw*(n + 1)
call bfit0(ndata, xdata, ydata, nord, nbkpt, bkpt, nconst, &
   & xconst, yconst, nderiv, mode, coeff, rnorm, w(i2), &
   & w(i1), mdg, w(i3), mdw, w(i7), iw)
end subroutine bfit

subroutine bfit0(ndata, xdata, ydata, nord, nbkpt, bkpt, &
   & nconst, xconst, yconst, nderiv, mode, coeff, rnorm, &
   & bf, g, mdg, w, mdw, work, iwork)
!! <!-- nswc-ford:begin BFIT0 -->
!! Reference for `bfit0`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: mdg, mdw
integer, intent(inout) :: mode
integer, intent(in) :: nbkpt, nconst, ndata, nord
real, intent(inout) :: rnorm
real, intent(in) :: bkpt(nbkpt), xdata(ndata), ydata(ndata)
real, intent(in) :: xconst(*), yconst(*)
real, intent(inout) :: coeff(*)
real, intent(inout) :: bf(nord,nord), g(mdg,*), w(mdw,*), work(*)
integer, intent(in) :: nderiv(*)
integer, intent(inout) :: iwork(*)
!     beginning of local variable declarations
integer :: i, idata, ideriv, ierr, ileft, intrvl, intw1, ip, ip1, &
   & ir, irow, itype, iw1, iw2, j, l, lw, m, mt, n, nb, neqcon, nincon, &
   & nordm1, nordp1, np1
real :: rnorme, xmax, xmin, xval, yval, prgopt(7)
logical :: band, new
!---------------------
go to 100
10 if (.not. band) go to 20
call bndsl(1, g, mdg, nord, ip, ir, coeff, n, rnorm, ierr)
if (ierr == 0) return
!     Check further for sufficient storage in working arrays.
20 if (iw1 < lw) go to 850
if (iw2 < intw1) go to 860
go to 300
!     Solve the equations
30 call lsei(w, mdw, neqcon, np1, nincon, n, prgopt, coeff, rnorme, &
   & rnorm, mode, work, iwork)
iwork(1) = iw1
iwork(2) = iw2
return
!-----------------------------------------------------------------------
!               Initialize-variables-and-analyze-input
!-----------------------------------------------------------------------
100 n = nbkpt - nord
if (nord < 1 .or. nord > n) go to 800
if (ndata < 1 .or. nconst < 0) go to 810
!     Check the break points
if (mode /= 0) go to 120
m = nbkpt - 1
do i = 1,m
   if (bkpt(i) > bkpt(i + 1)) go to 820
end do
!     Amount of storage allocated for w(*),IW(*)
120 iw1 = iwork(1)
iw2 = iwork(2)
nb = (n + 3)*(nord + 1) + nord*nord
lw = nb
if (iw1 < nb) go to 850
!     Compute the amount of storage needed for lsei
neqcon = 0
nincon = 0
if (nconst == 0) go to 150
do i = 1,nconst
   l = nderiv(i)
   if (l < 0) go to 140
   itype = l - 4*(l/4)
   if (itype > 1) go to 130
   nincon = nincon + 1
   go to 140
130 neqcon = neqcon + 1
140 continue
end do
150 np1 = n + 1
l = np1
lw = nb + (l + nconst)*l + 2*(neqcon + l) + (nincon + l) + &
   & (nincon + 2)*(l + 6)
intw1 = nincon + 2*l
!     Check the xconst(*) array
xmin = bkpt(nord)
xmax = bkpt(np1)
if (nconst == 0) go to 170
do i = 1,nconst
   if (xconst(i) < xmin .or. xconst(i) > xmax) &
      & go to 840
end do
!     Initialize parameters
170 new = mode == 0
band = nconst == 0
mode = 0
nordm1 = nord - 1
nordp1 = nord + 1
!     Define the option vector for use in lsei( )
!     increase the rank determination tolerances
!     for both equality constraint equations and
!     least squares equations.
prgopt(1) = 4
prgopt(2) = 4
prgopt(3) = 1.e-3
prgopt(4) = 7
prgopt(5) = 5
prgopt(6) = 1.e-3
prgopt(7) = 1
if (.not. new) go to 260
!     Check the xdata(*) array
if (xdata(1) < xmin .or. xdata(ndata) > xmax) &
   & go to 830
if (ndata == 1) go to 200
m = ndata - 1
do i = 1,m
   if (xdata(i) >= xdata(i + 1)) go to 830
end do
!     Initialize parameters of banded matrix processor, bndacc( )
200 mt = 0
ip = 1
ir = 1
idata = 1
ileft = nord
210 if (idata > ndata) go to 250
xval = xdata(idata)
if (ileft == n) go to 230
!     When interval changes, process equations in the last block.
ip1 = ileft + 1
if (xval < bkpt(ip1)) go to 230
intrvl = ileft - nordm1
call bndacc(g, mdg, nord, ip, ir, mt, intrvl)
mt = 0
!     Move pointer up so that xval .GE. bkpt(ileft).
do i = ip1,n
   if (xval < bkpt(i)) exit
   ileft = i
end do
!     Obtain B-spline function VALUE
230 j = 0
call bspvb(bkpt, nord, nord, j, xval, ileft, bf)
!     Move row into place
irow = ir + mt
mt = mt + 1
call scopy(nord, bf, 1, g(irow,1), mdg)
g(irow,nordp1) = ydata(idata)
!     When staging work area is exhausted, process rows
if (irow /= mdg - 1) go to 240
intrvl = ileft - nordm1
call bndacc(g, mdg, nord, ip, ir, mt, intrvl)
mt = 0
240 idata = idata + 1
go to 210
!     Process  block of equations
250 intrvl = ileft - nordm1
call bndacc(g, mdg, nord, ip, ir, mt, intrvl)
!     Last call to adjust block positioning
g(ir,1) = 0.0
call scopy(nordp1, g(ir,1), 0, g(ir,1), mdg)
call bndacc(g, mdg, nord, ip, ir, 1, np1)
260 do i = 1,n
   band = band .and. g(i,1) /= 0.0
end do
go to 10
!-----------------------------------------------------------------------
!       Analyze constraint indicators for equality constraints
!-----------------------------------------------------------------------
300 idata = 0
neqcon = 0
310 idata = idata + 1
if (idata > nconst) go to 400
l = nderiv(idata)
if (l < 0) go to 310
ideriv = l/4
itype = l - 4*ideriv
if (itype < 2) go to 310
neqcon = neqcon + 1
xval = xconst(idata)
ileft = nord
if (nord == n) go to 330
do i = nordp1,n
   if (xval < bkpt(i)) exit
   ileft = i
end do
330 call bspvd(bkpt, nord, xval, ileft, bf, nord, ideriv + 1, work)
w(neqcon,1) = 0.0
call scopy(n, w(neqcon,1), 0, w(neqcon,1), mdw)
intrvl = ileft - nordm1
call scopy(nord, bf(1,ideriv + 1), 1, w(neqcon,intrvl), mdw)
if (itype /= 2) go to 340
w(neqcon,np1) = yconst(idata)
go to 310
340 w(neqcon,np1) = 0.0
yval = yconst(idata)
i = idata
if (yval < xmin .or. yval > xmax) go to 840
ileft = nord
if (nord == n) go to 360
do i = nordp1,n
   if (yval < bkpt(i)) exit
   ileft = i
end do
360 call bspvd(bkpt, nord, yval, ileft, bf, nord, ideriv + 1, work)
intrvl = ileft - nordm1
call saxpy(nord, -1.0, bf(1,ideriv + 1), 1, w(neqcon,intrvl), mdw)
go to 310
!-----------------------------------------------------------------------
!                    Transfer-least-squares data
!-----------------------------------------------------------------------
400 do i = 1,np1
   irow = i + neqcon
   w(irow,1) = 0.0
   call scopy(n, w(irow,1), 0, w(irow,1), mdw)
   call scopy(min(np1 - i,nord), g(i,1), mdg, w(irow,i), mdw)
   w(irow,np1) = g(i,nordp1)
end do
!-----------------------------------------------------------------------
!      Analyze constraint indicators for inequality constraints
!-----------------------------------------------------------------------
idata = 0
nincon = 0
500 idata = idata + 1
if (idata > nconst) go to 30
l = nderiv(idata)
if (l < 0) go to 500
ideriv = l/4
itype = l - 4*ideriv
if (itype > 1) go to 500
nincon = nincon + 1
xval = xconst(idata)
ileft = nord
if (nord == n) go to 520
do i = nordp1,n
   if (xval < bkpt(i)) exit
   ileft = i
end do
520 call bspvd(bkpt, nord, xval, ileft, bf, nord, ideriv + 1, work)
irow = neqcon + np1 + nincon
w(irow,1) = 0.0
call scopy(n, w(irow,1), 0, w(irow,1), mdw)
intrvl = ileft - nordm1
call scopy(nord, bf(1,ideriv + 1), 1, w(irow,intrvl), mdw)
w(irow,np1) = yconst(idata)
if (itype /= 0) go to 500
w(irow,np1) = -w(irow,np1)
call sscal(nord, -1.0, w(irow,intrvl), mdw)
go to 500
!-----------------------------------------------------------------------
!                         Error return
!-----------------------------------------------------------------------
!                       EITHER nord .LT. 1 OR nord .GT. N.
800 mode = -1
return
!                       EITHER ndata .LT. 1 OR nconst .LT. 0.
810 mode = -2
return
!                       The sequence of knots is not nondecreasing.
820 mode = -3
return
!                       xdata(*) is not an increasing sequence in the
!                       closed interval (bkpt(1),bkpt(N+1)).
830 mode = -4
return
!                       The i-TH constraint is incorrect for the
!                       value of i stored in iwork(2).
840 iwork(2) = i
mode = -5
return
!                       Insuff. Storage for w(*). iwork(1) has been set
!                       to the amount of storage needed by w(*).
850 iwork(1) = lw
mode = -6
return
!                       Insuff. Storage for IW(*). iwork(2) has been set
!                       to the amount of storage needed by IW(*).
860 iwork(2) = intw1
mode = -7
end subroutine bfit0

pure subroutine bndacc(g,mdg,nb,ip,ir,mt,jt)
!! <!-- nswc-ford:begin BNDACC -->
!! Reference for `bndacc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!! ***Author  Lawson, C. L., (JPL)
!!            Hanson, R. J., (SNLA)
!! ***purpose  solve the least squares problem AX = B for banded
!!             matrices a using sequential accumulation of rows of
!!             the data matrix.  Exactly one right-handed side vector
!!             is permitted.
!! ***DESCRIPTION
!!      these subroutines solve the least squares problem AX = B for
!!      banded matrices a using sequential accumulation of rows of the
!!      data matrix.  Exactly one right-hand side vector is permitted.
!!      These subroutines are intended for the type of least squares
!!      systems that arise in applications such as curve or surface
!!      fitting of data.  The least squares equations are accumulated and
!!      processed using only part of the data.  This requires a certain
!!      user interaction during the solution of AX = B.
!!      Specifically, suppose the data matrix (A B) is row partitioned
!!      into Q submatrices.  Let (E F) be the T-TH one of these
!!      submatrices where E = (0 C 0).  Here the dimension of E is mt by N
!!      and the dimension of C is mt by nb.  The value of nb is the
!!      bandwidth of A.  the dimensions of the leading block of zeros in E
!!      are mt by jt-1.
!!      The user of the subroutine bndacc provides mt,jt,C and F for
!!      T=1,...,Q.  not all of this data must be supplied at once.
!!      Following the processing of the various blocks (E F), the matrix
!!      (A B) has been transformed to the form (R D) where R is upper
!!      triangular and banded with bandwidth nb.  The least squares
!!      system RX = D is then easily solved using back substitution by
!!      executing the statement call bndsl(1,...). The sequence of
!!      values for jt must be nondecreasing.  This may require some
!!      preliminary interchanges of rows and columns of the matrix A.
!!      The primary reason for these subroutines is that the total
!!      processing can take place in a working array of dimension mu by
!!      nb+1.  An acceptable value for mu is
!!                        mu = max(mt + n + 1),
!!      where N is the number of unknowns.
!!      Here the maximum is taken over all values of mt for T=1,...,Q.
!!      Notice that mt can be taken to be a small as one, showing that
!!      mu can be as small as N+2.  The subprogram bndacc processes the
!!      rows more efficiently if mu is large enough so that each new
!!      block (C F) has a distinct value of jt.
!!      The four principle parts of these algorithms are obtained by the
!!      following call statements
!!      call bndacc(...)  introduce new blocks of data.
!!      call bndsl(1,...)compute solution vector and length of
!!                        residual vector.
!!      call bndsl(2,...)given any row vector h solve yr = h for the
!!                        row vector Y.
!!      call bndsl(3,...)given any column vector w solve rz = w for
!!                        the column vector Z.
!!      The dots in the above call statements indicate additional
!!      arguments that will be specified in the following paragraphs.
!!      The user must dimension the array appearing in the call list..
!!      g(mdg,nb+1)
!!      description of calling sequence for bndacc..
!!      The entire set of parameters for bndacc are
!!      input..
!!      g(*,*)            THE WORKING ARRAY INTO WHICH THE USER WILL
!!                        place the mt by nb+1 block (C F) in rows ir
!!                        through ir+mt-1, columns 1 through nb+1.
!!                        See descriptions of ir and mt below.
!!      mdg               THE NUMBER OF ROWS IN THE WORKING ARRAY
!!                        g(*,*).  The value of mdg should be .GE. mu.
!!                        The value of mu is defined in the abstract
!!                        of these subprograms.
!!      nb                THE BANDWIDTH OF THE DATA MATRIX A.
!!      ip                SET BY THE USER TO THE VALUE 1 BEFORE THE
!!                        first call to bndacc.  Its subsequent value
!!                        is controlled by bndacc to set up for the
!!                        next call to bndacc.
!!      ir                INDEX OF THE ROW OF g(*,*) WHERE THE USER IS
!!                        to place the new block of data (C F).  Set by
!!                        the user to the value 1 before the first call
!!                        to bndacc.  Its subsequent value is controlled
!!                        BY bndacc. A VALUE OF ir .GT. mdg IS CONSIDERED
!!                        an error.
!!      mt,jt             SET BY THE USER TO INDICATE RESPECTIVELY THE
!!                        number of new rows of data in the block and
!!                        the index of the first nonzero column in that
!!                        set of rows (E F) = (0 C 0 F) being processed.
!!      Output..
!!      g(*,*)            THE WORKING ARRAY WHICH WILL CONTAIN THE
!!                        processed rows of that part of the data
!!                        matrix which has been passed to bndacc.
!!      ip,ir             THE VALUES OF THESE ARGUMENTS ARE ADVANCED BY
!!                        bndacc to be ready for storing and processing
!!                        a new block of data in g(*,*).
!!      Remarks..
!!      To obtain the upper triangular matrix and transformed right-hand
!!      side vector D so that the super diagonals of R form the columns
!!      of g(*,*), execute the following Fortran statements.
!!      nbp1=nb+1
!!      do 10 j=1, nbp1
!!   10 g(ir,j) = 0.e0
!!      mt=1
!!      jt=n+1
!!      call bndacc(g,mdg,nb,ip,ir,mt,jt)
!! ***references  C. L. Lawson and R. J. Hanson,
!!                  solving least square problems,PRENCTICE-Hall, inc
!!                  (1974), chapter 27
!!               alg. Steps 1-4 are performed external to this subroutine.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ip, ir
integer, intent(in) :: jt, mdg, mt, nb
real, intent(inout) :: g(mdg,*)
!     beginning of local variable declarations
integer :: i, ie, ig, ig1, ig2, j, jg, k, kh, l, lp1, mh, mu, nbp1
real :: rho
interface
   pure subroutine h12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
      implicit none
      integer, intent(in) :: iue
      integer, intent(in) :: m
      integer, intent(in) :: mode
      integer, intent(in) :: lpivot
      integer, intent(in) :: l1
      real, intent(inout) :: u(iue,m)
      real, intent(inout) :: up
      real, intent(inout) :: c(*)
      integer, intent(in) :: ice
      integer, intent(in) :: icv
      integer, intent(in) :: ncv
   end subroutine h12
end interface
!***Author  Lawson, C. L., (JPL)
!           Hanson, R. J., (SNLA)
!***purpose  solve the least squares problem AX = B for banded
!            matrices a using sequential accumulation of rows of
!            the data matrix.  Exactly one right-handed side vector
!            is permitted.
!***DESCRIPTION
!     these subroutines solve the least squares problem AX = B for
!     banded matrices a using sequential accumulation of rows of the
!     data matrix.  Exactly one right-hand side vector is permitted.
!     These subroutines are intended for the type of least squares
!     systems that arise in applications such as curve or surface
!     fitting of data.  The least squares equations are accumulated and
!     processed using only part of the data.  This requires a certain
!     user interaction during the solution of AX = B.
!     Specifically, suppose the data matrix (A B) is row partitioned
!     into Q submatrices.  Let (E F) be the T-TH one of these
!     submatrices where E = (0 C 0).  Here the dimension of E is mt by N
!     and the dimension of C is mt by nb.  The value of nb is the
!     bandwidth of A.  the dimensions of the leading block of zeros in E
!     are mt by jt-1.
!     The user of the subroutine bndacc provides mt,jt,C and F for
!     T=1,...,Q.  not all of this data must be supplied at once.
!     Following the processing of the various blocks (E F), the matrix
!     (A B) has been transformed to the form (R D) where R is upper
!     triangular and banded with bandwidth nb.  The least squares
!     system RX = D is then easily solved using back substitution by
!     executing the statement call bndsl(1,...). The sequence of
!     values for jt must be nondecreasing.  This may require some
!     preliminary interchanges of rows and columns of the matrix A.
!     The primary reason for these subroutines is that the total
!     processing can take place in a working array of dimension mu by
!     nb+1.  An acceptable value for mu is
!                       mu = max(mt + n + 1),
!     where N is the number of unknowns.
!     Here the maximum is taken over all values of mt for T=1,...,Q.
!     Notice that mt can be taken to be a small as one, showing that
!     mu can be as small as N+2.  The subprogram bndacc processes the
!     rows more efficiently if mu is large enough so that each new
!     block (C F) has a distinct value of jt.
!     The four principle parts of these algorithms are obtained by the
!     following call statements
!     call bndacc(...)  introduce new blocks of data.
!     call bndsl(1,...)compute solution vector and length of
!                       residual vector.
!     call bndsl(2,...)given any row vector h solve yr = h for the
!                       row vector Y.
!     call bndsl(3,...)given any column vector w solve rz = w for
!                       the column vector Z.
!     The dots in the above call statements indicate additional
!     arguments that will be specified in the following paragraphs.
!     The user must dimension the array appearing in the call list..
!     g(mdg,nb+1)
!     description of calling sequence for bndacc..
!     The entire set of parameters for bndacc are
!     input..
!     g(*,*)            THE WORKING ARRAY INTO WHICH THE USER WILL
!                       place the mt by nb+1 block (C F) in rows ir
!                       through ir+mt-1, columns 1 through nb+1.
!                       See descriptions of ir and mt below.
!     mdg               THE NUMBER OF ROWS IN THE WORKING ARRAY
!                       g(*,*).  The value of mdg should be .GE. mu.
!                       The value of mu is defined in the abstract
!                       of these subprograms.
!     nb                THE BANDWIDTH OF THE DATA MATRIX A.
!     ip                SET BY THE USER TO THE VALUE 1 BEFORE THE
!                       first call to bndacc.  Its subsequent value
!                       is controlled by bndacc to set up for the
!                       next call to bndacc.
!     ir                INDEX OF THE ROW OF g(*,*) WHERE THE USER IS
!                       to place the new block of data (C F).  Set by
!                       the user to the value 1 before the first call
!                       to bndacc.  Its subsequent value is controlled
!                       BY bndacc. A VALUE OF ir .GT. mdg IS CONSIDERED
!                       an error.
!     mt,jt             SET BY THE USER TO INDICATE RESPECTIVELY THE
!                       number of new rows of data in the block and
!                       the index of the first nonzero column in that
!                       set of rows (E F) = (0 C 0 F) being processed.
!     Output..
!     g(*,*)            THE WORKING ARRAY WHICH WILL CONTAIN THE
!                       processed rows of that part of the data
!                       matrix which has been passed to bndacc.
!     ip,ir             THE VALUES OF THESE ARGUMENTS ARE ADVANCED BY
!                       bndacc to be ready for storing and processing
!                       a new block of data in g(*,*).
!     Remarks..
!     To obtain the upper triangular matrix and transformed right-hand
!     side vector D so that the super diagonals of R form the columns
!     of g(*,*), execute the following Fortran statements.
!     nbp1=nb+1
!     do 10 j=1, nbp1
!  10 g(ir,j) = 0.e0
!     mt=1
!     jt=n+1
!     call bndacc(g,mdg,nb,ip,ir,mt,jt)
!***references  C. L. Lawson and R. J. Hanson,
!                 solving least square problems,PRENCTICE-Hall, inc
!                 (1974), chapter 27
!              alg. Steps 1-4 are performed external to this subroutine.
nbp1 = nb + 1
if (mt <= 0 .or. nb <= 0) return
!                                             Alg. Step 5
if (jt == ip) go to 70
!                                             Alg. Steps 6-7
if (jt <= ir) go to 30
!                                             Alg. Steps 8-9
do i = 1,mt
   ig1 = jt + mt - i
   ig2 = ir + mt - i
   do j = 1,nbp1
      g(ig1,j) = g(ig2,j)
   end do
end do
!                                             Alg. Step 10
ie = jt - ir
do i = 1,ie
   ig = ir + i - 1
   do j = 1,nbp1
      g(ig,j) = 0.0
   end do
end do
!                                             Alg. Step 11
ir = jt
!                                             Alg. Step 12
30 mu = min(nb - 1, ir - ip - 1)
if (mu == 0) go to 60
!                                             Alg. Step 13
do l = 1,mu
!                                             Alg. Step 14
   k = min(l, jt - ip)
!                                             Alg. Step 15
   lp1 = l + 1
   ig = ip + l
   do i = lp1,nb
      jg = i - k
      g(ig,jg) = g(ig,i)
   end do
!                                             Alg. Step 16
   do i = 1,k
      jg = nbp1 - i
      g(ig,jg) = 0.0
   end do
end do
!                                             Alg. Step 17
60 ip = jt
!                                             Alg. Steps 18-19
70 mh = ir + mt - ip
kh = min(nbp1, mh)
!                                             Alg. Step 20
do i = 1,kh
   call h12(1,i,max(i + 1,ir - ip + 1),mh,g(ip,i),1,rho, &
      & g(ip,i + 1),1,mdg,nbp1 - i)
end do
!                                             Alg. Step 21
ir = ip + kh
!                                             Alg. Step 22
if (kh < nbp1) go to 100
!                                             Alg. Step 23
do i = 1,nb
   g(ir - 1,i) = 0.0
end do
!                                             Alg. Step 24
100 continue
!                                             Alg. Step 25
end subroutine bndacc

subroutine bndsl(mode,g,mdg,nb,ip,ir,x,n,rnorm,ierr)
!! <!-- nswc-ford:begin BNDSL -->
!! Reference for `bndsl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!! ***Author  Lawson, C. L., (JPL)
!!            Hanson, R. J., (SNLA)
!! ***purpose  solve the least squares problem AX = B for banded
!!             matrices a using sequential accumulation of rows of
!!             the data matrix.  Exactly one right-handed side vector
!!             is permitted.
!!      These subroutines solve the least squares problem AX = B for
!!      banded matrices a using sequential accumulation of rows of the
!!      data matrix.  Exactly one right-hand side vector is permitted.
!!      These subroutines are intended for the type of least squares
!!      systems that arise in applications such as curve or surface
!!      fitting of data.  The least squares equations are accumulated and
!!      processed using only part of the data.  This requires a certain
!!      user interaction during the solution of AX = B.
!!      Specifically, suppose the data matrix (A B) is row partitioned
!!      into Q submatrices.  Let (E F) be the T-TH one of these
!!      submatrices where E = (0 C 0).  Here the dimension of E is MT by n
!!      and the dimension of C is MT by nb.  The value of nb is the
!!      bandwidth of A.  the dimensions of the leading block of zeros in E
!!      are MT by JT-1.
!!      The user of the subroutine bndacc provides MT,JT,C and F for
!!      T=1,...,Q.  not all of this data must be supplied at once.
!!      Following the processing of the various blocks (E F), the matrix
!!      (A B) has been transformed to the form (R D) where R is upper
!!      triangular and banded with bandwidth nb.  The least squares
!!      system RX = D is then easily solved using back substitution by
!!      executing the statement call bndsl(1,...). The sequence of
!!      values for JT must be nondecreasing.  This may require some
!!      preliminary interchanges of rows and columns of the matrix A.
!!      The primary reason for these subroutines is that the total
!!      processing can take place in a working array of dimension mu by
!!      nb+1.  An acceptable value for mu is
!!                        mu = max(mt + n + 1),
!!      where n is the number of unknowns.
!!      Here the maximum is taken over all values of MT for T=1,...,Q.
!!      Notice that MT can be taken to be a small as one, showing that
!!      mu can be as small as n+2.  The subprogram bndacc processes the
!!      rows more efficiently if mu is large enough so that each new
!!      block (C F) has a distinct value of JT.
!!      The four principle parts of these algorithms are obtained by the
!!      following call statements
!!      call bndacc(...)  introduce new blocks of data.
!!      call bndsl(1,...)compute solution vector and length of
!!                        residual vector.
!!      call bndsl(2,...)given any row vector h solve yr = h for the
!!                        row vector Y.
!!      call bndsl(3,...)given any column vector w solve rz = w for
!!                        the column vector Z.
!!      The dots in the above call statements indicate additional
!!      arguments that will be specified in the following paragraphs.
!!      The user must dimension the array appearing in the call list..
!!      g(mdg,nb+1)
!!      description of calling sequence for bndsl..
!!      The user must dimension the arrays appearing in the call list..
!!      g(mdg,nb+1), x(n)
!!      the entire set of parameters for bndsl are
!!      input..
!!      MODE              SET BY THE USER TO ONE OF THE VALUES 1, 2, OR
!!                        3.  These values respectively indicate that
!!                        the solution of AX = B, YR = H or RZ = W is
!!                        required.
!!      g(*,*),mdg,       THESE ARGUMENTS ALL HAVE THE SAME MEANING AND
!!       nb,ip,ir         CONTENTS AS FOLLOWING THE LAST CALL TO bndacc.
!!      x(*)              with mode=2 Or 3 this array contains,
!!                        respectively, the right-side vectors H or W of
!!                        the systems YR = H or RZ = W.
!!      n                 THE NUMBER OF VARIABLES IN THE SOLUTION
!!                        vector.  If any of the n diagonal terms are
!!                        zero the subroutine bndsl prints an
!!                        appropriate message.  This condition is
!!                        considered an error.
!!      Output..
!!      x(*)              THIS ARRAY CONTAINS THE SOLUTION VECTORS x,
!!                        Y or Z of the systems AX = B, YR = H or
!!                        RZ = W depending on the value of mode=1,
!!                        2 or 3.
!!      rnorm             if mode=1 rnorm is the Euclidean length of the
!!                        residual vector ax-B.  when mode=2 Or 3 rnorm
!!                        is set to zero.
!!      ierr              ierr = 0 If the solution was obtained.
!!                        ierr = 1 If the problem cannot be solved.
!! ***References  C. L. Lawson and R. J. Hanson,
!!                  solving least square problems,PRENCTICE-Hall, inc
!!                  (1974), chapter 27
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ip, ir, mdg, mode, n, nb
real :: g(mdg,*)
real, intent(out) :: rnorm
real, intent(inout) :: x(n)
!     beginning of local variable declarations
integer :: i, i1, i2, ie, ii, irm1, ix, j, jg, l, np1
real :: rsq, s
!***Author  Lawson, C. L., (JPL)
!           Hanson, R. J., (SNLA)
!***purpose  solve the least squares problem AX = B for banded
!            matrices a using sequential accumulation of rows of
!            the data matrix.  Exactly one right-handed side vector
!            is permitted.
!     These subroutines solve the least squares problem AX = B for
!     banded matrices a using sequential accumulation of rows of the
!     data matrix.  Exactly one right-hand side vector is permitted.
!     These subroutines are intended for the type of least squares
!     systems that arise in applications such as curve or surface
!     fitting of data.  The least squares equations are accumulated and
!     processed using only part of the data.  This requires a certain
!     user interaction during the solution of AX = B.
!     Specifically, suppose the data matrix (A B) is row partitioned
!     into Q submatrices.  Let (E F) be the T-TH one of these
!     submatrices where E = (0 C 0).  Here the dimension of E is MT by n
!     and the dimension of C is MT by nb.  The value of nb is the
!     bandwidth of A.  the dimensions of the leading block of zeros in E
!     are MT by JT-1.
!     The user of the subroutine bndacc provides MT,JT,C and F for
!     T=1,...,Q.  not all of this data must be supplied at once.
!     Following the processing of the various blocks (E F), the matrix
!     (A B) has been transformed to the form (R D) where R is upper
!     triangular and banded with bandwidth nb.  The least squares
!     system RX = D is then easily solved using back substitution by
!     executing the statement call bndsl(1,...). The sequence of
!     values for JT must be nondecreasing.  This may require some
!     preliminary interchanges of rows and columns of the matrix A.
!     The primary reason for these subroutines is that the total
!     processing can take place in a working array of dimension mu by
!     nb+1.  An acceptable value for mu is
!                       mu = max(mt + n + 1),
!     where n is the number of unknowns.
!     Here the maximum is taken over all values of MT for T=1,...,Q.
!     Notice that MT can be taken to be a small as one, showing that
!     mu can be as small as n+2.  The subprogram bndacc processes the
!     rows more efficiently if mu is large enough so that each new
!     block (C F) has a distinct value of JT.
!     The four principle parts of these algorithms are obtained by the
!     following call statements
!     call bndacc(...)  introduce new blocks of data.
!     call bndsl(1,...)compute solution vector and length of
!                       residual vector.
!     call bndsl(2,...)given any row vector h solve yr = h for the
!                       row vector Y.
!     call bndsl(3,...)given any column vector w solve rz = w for
!                       the column vector Z.
!     The dots in the above call statements indicate additional
!     arguments that will be specified in the following paragraphs.
!     The user must dimension the array appearing in the call list..
!     g(mdg,nb+1)
!     description of calling sequence for bndsl..
!     The user must dimension the arrays appearing in the call list..
!     g(mdg,nb+1), x(n)
!     the entire set of parameters for bndsl are
!     input..
!     MODE              SET BY THE USER TO ONE OF THE VALUES 1, 2, OR
!                       3.  These values respectively indicate that
!                       the solution of AX = B, YR = H or RZ = W is
!                       required.
!     g(*,*),mdg,       THESE ARGUMENTS ALL HAVE THE SAME MEANING AND
!      nb,ip,ir         CONTENTS AS FOLLOWING THE LAST CALL TO bndacc.
!     x(*)              with mode=2 Or 3 this array contains,
!                       respectively, the right-side vectors H or W of
!                       the systems YR = H or RZ = W.
!     n                 THE NUMBER OF VARIABLES IN THE SOLUTION
!                       vector.  If any of the n diagonal terms are
!                       zero the subroutine bndsl prints an
!                       appropriate message.  This condition is
!                       considered an error.
!     Output..
!     x(*)              THIS ARRAY CONTAINS THE SOLUTION VECTORS x,
!                       Y or Z of the systems AX = B, YR = H or
!                       RZ = W depending on the value of mode=1,
!                       2 or 3.
!     rnorm             if mode=1 rnorm is the Euclidean length of the
!                       residual vector ax-B.  when mode=2 Or 3 rnorm
!                       is set to zero.
!     ierr              ierr = 0 If the solution was obtained.
!                       ierr = 1 If the problem cannot be solved.
!***References  C. L. Lawson and R. J. Hanson,
!                 solving least square problems,PRENCTICE-Hall, inc
!                 (1974), chapter 27
ierr = 0
rnorm = 0.0
select case (mode)
case (1)
   go to 10
case (2)
   go to 90
case (3)
   go to 50
end select
!                                   ********************* mode = 1
!                                   alg. Step 26
10 do j = 1,n
   x(j) = g(j, nb + 1)
end do
rsq = 0.0
np1 = n + 1
irm1 = ir - 1
if (np1 > irm1) go to 40
do j = np1,irm1
   rsq = rsq + g(j, nb + 1)**2
end do
rnorm = sqrt(rsq)
40 continue
!                                   ********************* mode = 3
!                                   alg. Step 27
50 do ii = 1,n
   i = n + 1 - ii
!                                   Alg. Step 28
   s = 0.0
   l = max(0, i - ip)
!                                   Alg. Step 29
   if (i == n) go to 70
!                                   Alg. Step 30
   ie = min(n + 1 - i, nb)
   do j = 2,ie
      jg = j + l
      ix = i - 1 + j
      s = s + g(i,jg)*x(ix)
   end do
!                                   Alg. Step 31
70 if (g(i,l + 1) == 0.0) go to 130
   x(i) = (x(i) - s)/g(i,l + 1)
end do
!                                   Alg. Step 32
return
!                                   ********************* mode = 2
90 do j = 1,n
   s = 0.0
   if (j == 1) go to 110
   i1 = max(1, j - nb + 1)
   i2 = j - 1
   do i = i1,i2
      l = j - i + 1 + max(0, i - ip)
      s = s + x(i)*g(i,l)
   end do
110 l = max(0, j - ip)
   if (g(j,l + 1) == 0.0) go to 130
   x(j) = (x(j) - s)/g(j,l + 1)
end do
return
!            A zero diagonal term occurs
130 ierr = 1
end subroutine bndsl

pure subroutine spfit2(x, wx, mx, y, wy, my, z, kz, xbreak, nx, &
   & ybreak, ny, f, s, t, wk, num, ierr)
!! <!-- nswc-ford:begin SPFIT2 -->
!! Reference for `spfit2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Weighted least squares bicubic spline fitting
!!
!!      The piecewise polynomials considered are tensor products of
!!      B-splines, having the form
!!                           m    n
!!               f(x,y)  =  Sum  sum  A   U (x) V (y)
!!                          i=1  j=1   IJ  i     j
!!      WHERE m = nx + 2 AND n = ny + 2, AND U  AND V  ARE B-SPLINE
!!      BASIS FUNCTIONS OF DEGREE 3. LET      i      j
!!                        m
!!               G (x) = SUM A   U (x)
!!                j      i=1  IJ  i
!!      for j = 1,...,n. then G (x),...,G (x) are cubic splines and
!!                             1         n
!!                         n
!!               f(x,y) = SUM G (x) V (y) .
!!                        j=1  j     j
!!      the arrays s and t defined in the code are the knot sequences
!!      for the B-splines U (x) and V (y).
!!                         i         j
!!
!!      Written by
!!         Alfred H. Morris, Jr.
!!         Naval Surface Warfare Center
!!         Dahlgren, Virginia
!!
!!      real f(4*nx*ny), s(nx + 6), t(ny + 6)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kz, mx, my, num, nx, ny
real, intent(in) :: x(mx), wx(mx), y(my), wy(my), z(kz, my)
real, intent(in) :: xbreak(nx), ybreak(ny)
real, intent(inout) :: f(*)
real, intent(inout) :: s(*), t(*), wk(num)
!     beginning of local variable declarations
integer :: i, imax, j, l, ld, m, n, nu
interface
   pure subroutine bslsq2(x,wx,mx,y,wy,my,z,kz,tx,nx,kx,ty,ny, &
      & ky,a,ka,wk,l,iflag)
      implicit none
      integer, intent(in) :: l
      integer, intent(in) :: ka
      integer, intent(in) :: ny
      integer, intent(in) :: kz
      integer, intent(in) :: my
      integer, intent(in) :: mx
      real, intent(in) :: x(mx)
      real, intent(in) :: wx(mx)
      real, intent(in) :: y(my)
      real, intent(in) :: wy(my)
      real, intent(in) :: z(kz,my)
      real, intent(in) :: tx(*)
      integer, intent(in) :: nx
      integer, intent(in) :: kx
      real, intent(in) :: ty(*)
      integer, intent(in) :: ky
      real, intent(inout) :: a(ka,ny)
      real, intent(inout) :: wk(l)
      integer, intent(inout) :: iflag
   end subroutine bslsq2
   pure subroutine cspp(t,a,ka,m,n,z,kz,dz,kdz)
      implicit none
      integer, intent(in) :: kdz
      integer, intent(in) :: kz
      integer, intent(in) :: n
      integer, intent(in) :: ka
      real, intent(in) :: t(*)
      real, intent(in) :: a(ka,n)
      integer, intent(in) :: m
      real, intent(inout) :: z(kz,*)
      real, intent(inout) :: dz(kdz,*)
   end subroutine cspp
end interface
!-----------------------------------------------------------------------
!            Weighted least squares bicubic spline fitting
!                          -----------------
!     The piecewise polynomials considered are tensor products of
!     B-splines, having the form
!                          m    n
!              f(x,y)  =  Sum  sum  A   U (x) V (y)
!                         i=1  j=1   IJ  i     j
!     WHERE m = nx + 2 AND n = ny + 2, AND U  AND V  ARE B-SPLINE
!     BASIS FUNCTIONS OF DEGREE 3. LET      i      j
!                       m
!              G (x) = SUM A   U (x)
!               j      i=1  IJ  i
!     for j = 1,...,n. then G (x),...,G (x) are cubic splines and
!                            1         n
!                        n
!              f(x,y) = SUM G (x) V (y) .
!                       j=1  j     j
!     the arrays s and t defined in the code are the knot sequences
!     for the B-splines U (x) and V (y).
!                        i         j
!-----------------------------------------------------------------------
!     Written by
!        Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!---------------------
!     real f(4*nx*ny), s(nx + 6), t(ny + 6)
!---------------------
if (nx < 2) go to 100
if (ny < 2) go to 120
m = nx + 2
n = ny + 2
l = max(m*n, m*my + 5*max(m,n))
if (num < l) go to 130
!     Define the knot squences
s(1) = xbreak(1)
s(2) = xbreak(1)
s(3) = xbreak(1)
s(4) = xbreak(1)
do i = 2,nx
   if (xbreak(i - 1) >= xbreak(i)) go to 100
   s(i + 3) = xbreak(i)
end do
s(nx + 4) = xbreak(nx)
s(nx + 5) = xbreak(nx)
s(nx + 6) = xbreak(nx)
t(1) = ybreak(1)
t(2) = ybreak(1)
t(3) = ybreak(1)
t(4) = ybreak(1)
do j = 2,ny
   if (ybreak(j - 1) >= ybreak(j)) go to 120
   t(j + 3) = ybreak(j)
end do
t(ny + 4) = ybreak(ny)
t(ny + 5) = ybreak(ny)
t(ny + 6) = ybreak(ny)
!     Obtain the B-spline coefficients of the bivariate
!     least squares fit and store them in wk.
call bslsq2(x, wx, mx, y, wy, my, z, kz, s, m, 4, &
   & t, n, 4, f, m, wk, num, ierr)
if (ierr < 0) go to 110
ierr = 0
l = m*n
do i = 1,l
   wk(i) = f(i)
end do
!     Compute the n cubic splines G (x) and their first
!                                  j
!     derivatives at the points in xbreak. Then store the
!     derivatives in wk. (The values of the splines will
!     be in the latter half of f.)
nu = nx*ny
l = 2*nu + 1
call cspp(s, wk, m, m, n, f(l), n, f(1), n)
imax = n*nx
do i = 1,imax
   wk(i) = f(i)
end do
!     Compute the values of the bispline and their partial
!     derivatives with respect to y. the results are stored
!     in the first half of f.
ld = nu + 1
call cspp(t, f(l), n, n, nx, f(1), nx, f(ld), nx)
!     Compute the remaining partial derivatives and store
!     the results in the latter half of f.
ld = l + nu
call cspp(t, wk, n, n, nx, f(l), nx, f(ld), nx)
return
!     Error return
100 ierr = 1
return
110 ierr = 2
if (ierr == -2) ierr = 4
return
120 ierr = 3
return
130 ierr = 5
wk(1) = l
end subroutine spfit2

pure subroutine cspp(t, a, ka, m, n, z, kz, dz, kdz)
!! <!-- nswc-ford:begin CSPP -->
!! Reference for `cspp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Computation of n cubic splines and their first
!!             derivatives at the knots t(4),...,t(m+1). The
!!             cubic splines are represented in B-spline form.
!!
!!      Input ...
!!        t     KNOT SEQUENCE OF LENGTH m+4.
!!        A     m x n MATRIX. EACH COLUMN OF A IS A SEQUENCE
!!              of m B-spline coefficients for a cubic spline.
!!        ka    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!!              program for A. it is assumed that ka .GE. m.
!!        m     DIMENSION OF THE B-SPLINE SPACE.
!!        n     NUMBER OF CUBIC SPLINES CONSIDERED.
!!        kz    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!!              program for z. it is assumed that kz .GE. n.
!!        kdz   THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!!              program for dz. It is assumed that kz .GE. n.
!!      Output ...
!!        z     n x (m-2) matrix where z(j,i) = Value of j-TH cubic
!!              spline at the point t(i+3) for i = 1,...,m-2.
!!        dz    n x (m-2) matrix where dz(j,i) = First derivative of
!!              the j-TH cubic spline evaluated at the point t(i+3).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kdz, kz, m, n
real, intent(in) :: t(*), a(ka,n)
real, intent(inout) :: z(kz,*), dz(kdz,*)
!     beginning of local variable declarations
integer :: i, il, ilj, ilkj, j, jj, jp1, k, kmj, l, left, mp1, mu
real :: del, diff, r, s, term, x, c(4), wk(4,5)
!-----------------------------------------------------------------------
!            Computation of n cubic splines and their first
!            derivatives at the knots t(4),...,t(m+1). The
!            cubic splines are represented in B-spline form.
!                          ---------------
!     Input ...
!       t     KNOT SEQUENCE OF LENGTH m+4.
!       A     m x n MATRIX. EACH COLUMN OF A IS A SEQUENCE
!             of m B-spline coefficients for a cubic spline.
!       ka    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             program for A. it is assumed that ka .GE. m.
!       m     DIMENSION OF THE B-SPLINE SPACE.
!       n     NUMBER OF CUBIC SPLINES CONSIDERED.
!       kz    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             program for z. it is assumed that kz .GE. n.
!       kdz   THE NUMBER OF ROWS SPECIFIED IN THE CALLING
!             program for dz. It is assumed that kz .GE. n.
!     Output ...
!       z     n x (m-2) matrix where z(j,i) = Value of j-TH cubic
!             spline at the point t(i+3) for i = 1,...,m-2.
!       dz    n x (m-2) matrix where dz(j,i) = First derivative of
!             the j-TH cubic spline evaluated at the point t(i+3).
!-----------------------------------------------------------------------
k = 4
mp1 = m + 1
do mu = 1,n
!        Obtaing the values for the mu-TH cubic spline
   l = 0
   do left = k,m
      l = l + 1
!           Compute the coefficients for the l-TH
!           polynomial forming the cubic spline. The
!           coefficients are stored in c. this code
!           is from the subroutine bspp.
      do j = 1,k
         jj = left - k + j
         wk(j,1) = a(jj,mu)
      end do
      do j = 1,3
         jp1 = j + 1
         kmj = k - j
         do i = 1,kmj
            il = i + left
            ilkj = il - kmj
            diff = t(il) - t(ilkj)
            wk(i,jp1) = (wk(i + 1,j) - wk(i,j))/diff
         end do
      end do
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
         s = 0.0
         kmj = k - j
         do i = 1,jp1
            s = s + wk(i,kmj)*wk(i,5)
         end do
         r = (r*float(kmj))/float(j)
         c(kmj) = r*s
      end do
!           Store the value of the spline and its
!           first derivative at the knot t(left)
      z(mu,l) = c(1)
      dz(mu,l) = c(2)
   end do
!        Compute the spline and its first derivative
!                    at the knot t(m+1)
   l = l + 1
   del = t(mp1) - t(m)
   z(mu,l) = ((c(4)*del + c(3))*del + c(2))*del + c(1)
   dz(mu,l) = (3.0*c(4)*del + 2.0*c(3))*del + c(2)
end do
end subroutine cspp

pure subroutine csurf(ider, jder, x, mx, y, my, z, kz, s, m, t, n, &
   & f, kf, f1, kf1, f2, kf2, f12, kf12)
!! <!-- nswc-ford:begin CSURF -->
!! Reference for `csurf`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Evaluation or differentiation of a bicubic
!!                         spline over a grid
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ider, jder, kf, kf1, kf12, kf2, kz, m, mx, &
   & my, n
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), f1(kf1,n), f2(kf2,n), &
   & f12(kf12,n)
!     beginning of local variable declarations
integer :: i, iold, ip1, j, jold, jp1, k, l, mm1, nm1, nswc_ai_i4
real :: a, b, b1, b2, b3, bx, c, c1, c2, c3, cx, d, dfi, dfip1, ds, dt, dx, dy, fi, fip1, xx, yy, nswc_ai_r4
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!-----------------------------------------------------------------------
if (ider > 3 .or. jder > 3) go to 400
mm1 = m - 1
nm1 = n - 1
iold = 0
jold = 0
do l = 1,my
   yy = y(l)
   if (yy < t(2)) go to 10
   if (yy >= t(nm1)) go to 20
   if (l == 1) go to 30
   nswc_ai_r4 = yy - y(l - 1)
   if (nswc_ai_r4 < 0) go to 30
   if (nswc_ai_r4 == 0) go to 50
   go to 40
10 j = 1
   go to 50
20 j = nm1
   go to 50
30 j = intrvl(yy, t, n)
   go to 50
!        Linear forward search
40 if (yy < t(j + 1)) go to 50
   j = j + 1
   go to 40
50 jp1 = j + 1
   dt = t(jp1) - t(j)
   do k = 1,mx
      xx = x(k)
      if (xx < s(2)) go to 100
      if (xx >= s(mm1)) go to 110
      if (k == 1) go to 120
      nswc_ai_r4 = xx - x(k - 1)
      if (nswc_ai_r4 < 0) go to 120
      if (nswc_ai_r4 == 0) go to 130
      go to 140
100   i = 1
      if (i == iold .and. j == jold) go to 210
      go to 200
110   i = mm1
      if (i == iold .and. j == jold) go to 210
      go to 200
120   i = intrvl(xx, s, m)
      if (i == iold .and. j == jold) go to 210
      go to 200
130   z(k,l) = z(k - 1,l)
      go to 350
!           Linear forward search
140   if (xx < s(i + 1)) go to 210
150   i = i + 1
      if (xx >= s(i + 1)) go to 150
!           Computation of the jder-TH derivative of
!           f(s(i),y), D1F(s(i),y), f(s(i+1),y), AND
!           D1F(s(i+1),y) at the point YY.
200   iold = i
      ip1 = i + 1
      ds = s(ip1) - s(i)
      d = (f(i,jp1) - f(i,j))/dt
      a = f2(i,j) + f2(i,jp1)
      b = (-a - f2(i,j) + 3.0*d)/dt
      c = (a - d - d)/(dt*dt)
      d = (f(ip1,jp1) - f(ip1,j))/dt
      a = f2(ip1,j) + f2(ip1,jp1)
      b1 = (-a - f2(ip1,j) + 3.0*d)/dt
      c1 = (a - d - d)/(dt*dt)
      d = (f1(i,jp1) - f1(i,j))/dt
      a = f12(i,j) + f12(i,jp1)
      b2 = (-a - f12(i,j) + 3.0*d)/dt
      c2 = (a - d - d)/(dt*dt)
      d = (f1(ip1,jp1) - f1(ip1,j))/dt
      a = f12(ip1,j) + f12(ip1,jp1)
      b3 = (-a - f12(ip1,j) + 3.0*d)/dt
      c3 = (a - d - d)/(dt*dt)
210   dy = yy - t(j)
      if (jder == 0) go to 220
      nswc_ai_i4 = jder - 2
      if (nswc_ai_i4 < 0) go to 230
      if (nswc_ai_i4 == 0) go to 240
      go to 250
220   fi = ((c*dy + b)*dy + f2(i,j))*dy + f(i,j)
      fip1 = ((c1*dy + b1)*dy + f2(ip1,j))*dy + f(ip1,j)
      dfi = ((c2*dy + b2)*dy + f12(i,j))*dy + f1(i,j)
      dfip1 = ((c3*dy + b3)*dy + f12(ip1,j))*dy + f1(ip1,j)
      go to 300
230   fi = (3.0*c*dy + 2.0*b)*dy + f2(i,j)
      fip1 = (3.0*c1*dy + 2.0*b1)*dy + f2(ip1,j)
      dfi = (3.0*c2*dy + 2.0*b2)*dy + f12(i,j)
      dfip1 = (3.0*c3*dy + 2.0*b3)*dy + f12(ip1,j)
      go to 300
240   fi = 6.0*c*dy + 2.0*b
      fip1 = 6.0*c1*dy + 2.0*b1
      dfi = 6.0*c2*dy + 2.0*b2
      dfip1 = 6.0*c3*dy + 2.0*b3
      go to 300
250   fi = 6.0*c
      fip1 = 6.0*c1
      dfi = 6.0*c2
      dfip1 = 6.0*c3
!           Computation of the ider-TH derivative
!           at the point XX.
300   d = (fip1 - fi)/ds
      a = dfi + dfip1
      bx = (-a - dfi + 3.0*d)/ds
      cx = (a - d - d)/(ds*ds)
      dx = xx - s(i)
      if (ider == 0) go to 310
      nswc_ai_i4 = ider - 2
      if (nswc_ai_i4 < 0) go to 320
      if (nswc_ai_i4 == 0) go to 330
      go to 340
310   z(k,l) = ((cx*dx + bx)*dx + dfi)*dx + fi
      go to 350
320   z(k,l) = (3.0*cx*dx + 2.0*bx)*dx + dfi
      go to 350
330   z(k,l) = 6.0*cx*dx + 2.0*bx
      go to 350
340   z(k,l) = 6.0*cx
350   continue
   end do
   jold = j
end do
return
!     Case when the results are zero.
400 do l = 1,my
   do k = 1,mx
      z(k,l) = 0.0
   end do
end do
end subroutine csurf

pure subroutine csurf1(ider, jder, x, mx, y, my, z, kz, s, m, t, n, f)
!! <!-- nswc-ford:begin CSURF1 -->
!! Reference for `csurf1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Evaluation or differentiation of a bicubic
!!                         spline over a grid
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ider, jder, kz, m, mx, my, n
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(m,n,4)
interface
   pure subroutine csurf(ider,jder,x,mx,y,my,z,kz,s,m,t,n,f,kf, &
      & f1,kf1,f2,kf2,f12,kf12)
      implicit none
      integer, intent(in) :: kf12
      integer, intent(in) :: kf2
      integer, intent(in) :: kf1
      integer, intent(in) :: kf
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: kz
      integer, intent(in) :: my
      integer, intent(in) :: mx
      integer, intent(in) :: ider
      integer, intent(in) :: jder
      real, intent(in) :: x(mx)
      real, intent(in) :: y(my)
      real, intent(inout) :: z(kz,my)
      real, intent(in) :: s(m)
      real, intent(in) :: t(n)
      real, intent(in) :: f(kf,n)
      real, intent(in) :: f1(kf1,n)
      real, intent(in) :: f2(kf2,n)
      real, intent(in) :: f12(kf12,n)
   end subroutine csurf
end interface
!-----------------------------------------------------------------------
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!-----------------------------------------------------------------------
call csurf(ider, jder, x, mx, y, my, z, kz, s, m, t, n, f, m, &
   & f(1,1,3), m, f(1,1,2), m, f(1,1,4), m)
end subroutine csurf1

pure subroutine csrf(ider, jder, x, mx, y, my, z, kz, s, m, t, n, &
   & f, kf, f1, kf1, f2, kf2, f12, kf12)
!! <!-- nswc-ford:begin CSRF -->
!! Reference for `csrf`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Evaluation or differentiation of a bicubic
!!                         spline over a grid
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ider, jder, kf, kf1, kf12, kf2, kz, m, mx, &
   & my, n
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), f1(kf1,n), f2(kf2,n), &
   & f12(kf12,n)
!     beginning of local variable declarations
integer :: i, iold, ip1, j, jold, jp1, k, l, mm1, nm1, nswc_ai_i4
real :: a, a1, a2, a3, ax, c, c1, c2, c3, cx, d, dfi, dfip1, ds, dt, dx, dy, fi, fip1, xx, yy, nswc_ai_r4
interface
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!-----------------------------------------------------------------------
if (ider > 3 .or. jder > 3) go to 400
mm1 = m - 1
nm1 = n - 1
iold = 0
jold = 0
do l = 1,my
   yy = y(l)
   if (yy < t(2)) go to 10
   if (yy >= t(nm1)) go to 20
   if (l == 1) go to 30
   nswc_ai_r4 = yy - y(l - 1)
   if (nswc_ai_r4 < 0) go to 30
   if (nswc_ai_r4 == 0) go to 50
   go to 40
10 j = 1
   go to 50
20 j = nm1
   go to 50
30 j = intrvl(yy, t, n)
   go to 50
!        Linear forward search
40 if (yy < t(j + 1)) go to 50
   j = j + 1
   go to 40
50 jp1 = j + 1
   dt = t(jp1) - t(j)
   do k = 1,mx
      xx = x(k)
      if (xx < s(2)) go to 100
      if (xx >= s(mm1)) go to 110
      if (k == 1) go to 120
      nswc_ai_r4 = xx - x(k - 1)
      if (nswc_ai_r4 < 0) go to 120
      if (nswc_ai_r4 == 0) go to 130
      go to 140
100   i = 1
      if (i == iold .and. j == jold) go to 210
      go to 200
110   i = mm1
      if (i == iold .and. j == jold) go to 210
      go to 200
120   i = intrvl(xx, s, m)
      if (i == iold .and. j == jold) go to 210
      go to 200
130   z(k,l) = z(k - 1,l)
      go to 350
!           Linear forward search
140   if (xx < s(i + 1)) go to 210
150   i = i + 1
      if (xx >= s(i + 1)) go to 150
!           Computation of the jder-TH derivative of
!           f(s(i),y), D1F(s(i),y), f(s(i+1),y), AND
!           D1F(s(i+1),y) at the point YY.
200   iold = i
      ip1 = i + 1
      ds = s(ip1) - s(i)
      d = (f(i,jp1) - f(i,j))/dt
      a = d - dt*(2.0*f2(i,j) + f2(i,jp1))/6.0
      c = (f2(i,jp1) - f2(i,j))/(6.0*dt)
      d = (f(ip1,jp1) - f(ip1,j))/dt
      a1 = d - dt*(2.0*f2(ip1,j) + f2(ip1,jp1))/6.0
      c1 = (f2(ip1,jp1) - f2(ip1,j))/(6.0*dt)
      d = (f1(i,jp1) - f1(i,j))/dt
      a2 = d - dt*(2.0*f12(i,j) + f12(i,jp1))/6.0
      c2 = (f12(i,jp1) - f12(i,j))/(6.0*dt)
      d = (f1(ip1,jp1) - f1(ip1,j))/dt
      a3 = d - dt*(2.0*f12(ip1,j) + f12(ip1,jp1))/6.0
      c3 = (f12(ip1,jp1) - f12(ip1,j))/(6.0*dt)
210   dy = yy - t(j)
      if (jder == 0) go to 220
      nswc_ai_i4 = jder - 2
      if (nswc_ai_i4 < 0) go to 230
      if (nswc_ai_i4 == 0) go to 240
      go to 250
220   fi = ((c*dy + 0.5*f2(i,j))*dy + a)*dy + f(i,j)
      fip1 = ((c1*dy + 0.5*f2(ip1,j))*dy + a1)*dy + f(ip1,j)
      dfi = ((c2*dy + 0.5*f12(i,j))*dy + a2)*dy + f1(i,j)
      dfip1 = ((c3*dy + 0.5*f12(ip1,j))*dy + a3)*dy + f1(ip1,j)
      go to 300
230   fi = (3.0*c*dy + f2(i,j))*dy + a
      fip1 = (3.0*c1*dy + f2(ip1,j))*dy + a1
      dfi = (3.0*c2*dy + f12(i,j))*dy + a2
      dfip1 = (3.0*c3*dy + f12(ip1,j))*dy + a3
      go to 300
240   fi = 6.0*c*dy + f2(i,j)
      fip1 = 6.0*c1*dy + f2(ip1,j)
      dfi = 6.0*c2*dy + f12(i,j)
      dfip1 = 6.0*c3*dy + f12(ip1,j)
      go to 300
250   fi = 6.0*c
      fip1 = 6.0*c1
      dfi = 6.0*c2
      dfip1 = 6.0*c3
!           Computation of the ider-TH derivative
!           at the point XX.
300   d = (fip1 - fi)/ds
      ax = d - ds*(2.0*dfi + dfip1)/6.0
      cx = (dfip1 - dfi)/(6.0*ds)
      dx = xx - s(i)
      if (ider == 0) go to 310
      nswc_ai_i4 = ider - 2
      if (nswc_ai_i4 < 0) go to 320
      if (nswc_ai_i4 == 0) go to 330
      go to 340
310   z(k,l) = ((cx*dx + 0.5*dfi)*dx + ax)*dx + fi
      go to 350
320   z(k,l) = (3.0*cx*dx + dfi)*dx + ax
      go to 350
330   z(k,l) = 6.0*cx*dx + dfi
      go to 350
340   z(k,l) = 6.0*cx
350   continue
   end do
   jold = j
end do
return
!     Case when the results are zero.
400 do l = 1,my
   do k = 1,mx
      z(k,l) = 0.0
   end do
end do
end subroutine csrf

pure subroutine csrf2(ider, jder, x, mx, y, my, z, kz, s, m, t, n, &
   & f, kf, ddf)
!! <!-- nswc-ford:begin CSRF2 -->
!! Reference for `csrf2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Evaluation or differentiation of a bicubic
!!                         spline over a grid
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ider, jder, kf, kz, m, mx, my, n
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), ddf(m,n,3)
interface
   pure subroutine csrf(ider,jder,x,mx,y,my,z,kz,s,m,t,n,f,kf, &
      & f1,kf1,f2,kf2,f12,kf12)
      implicit none
      integer, intent(in) :: kf12
      integer, intent(in) :: kf2
      integer, intent(in) :: kf1
      integer, intent(in) :: kf
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: kz
      integer, intent(in) :: my
      integer, intent(in) :: mx
      integer, intent(in) :: ider
      integer, intent(in) :: jder
      real, intent(in) :: x(mx)
      real, intent(in) :: y(my)
      real, intent(inout) :: z(kz,my)
      real, intent(in) :: s(m)
      real, intent(in) :: t(n)
      real, intent(in) :: f(kf,n)
      real, intent(in) :: f1(kf1,n)
      real, intent(in) :: f2(kf2,n)
      real, intent(in) :: f12(kf12,n)
   end subroutine csrf
end interface
!-----------------------------------------------------------------------
!             Evaluation or differentiation of a bicubic
!                        spline over a grid
!-----------------------------------------------------------------------
call csrf(ider, jder, x, mx, y, my, z, kz, s, m, t, n, f, kf, &
   & ddf(1,1,2), m, ddf, m, ddf(1,1,3), m)
end subroutine csrf2

subroutine surf(m,n,x,y,z,iz,opt,zp,temp,sigma,ierr)
!! <!-- nswc-ford:begin SURF -->
!! Reference for `surf`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!                                modified by Alfred H. Morris
!!                                naval surface weapons center
!!                                           Dahlgren Virginia
!!  this subroutine determines the parameters necessary to
!!  compute an interpolatory surface passing through a rect-
!!  angular grid of functional values. The surface determined
!!  can be represented as the tensor product of splines under
!!  tension. The x- and y-partial derivatives around the
!!  boundary and the x-y-partial derivatives at the four
!!  corners may be specified or omitted. For actual mapping
!!  of points onto the surface it is necessary to call the
!!  function surf2.
!!  On input--
!!    m is the number of grid lines in the x-direction, I. E.
!!    Lines parallel to the y-axis (m .GE. 2).
!!    n is the number of grid lines in the y-direction, I. E.
!!    Lines parallel to the x-axis (n .GE. 2).
!!    x is an array of the m x-coordinates of the grid lines
!!    in the x-direction. These should be strictly increasing.
!!    y is an array of the n y-coordinates of the grid lines
!!    in the y-direction. These should be strictly increasing.
!!    z is an array of the m * n functional values at the grid
!!    points, I. E. z(i,j) contains the functional value at
!!    (x(i),y(j)) FOR i = 1,...,m AND j = 1,...,n.
!!    iz is the row dimension of the matrix z used in the
!!    CALLING PROGRAM (iz .GE. m).
!!    Opt is an option vector. If no boundary conditions are
!!    to be imposed on the surface then let opt be of length 1
!!    and set opt(1)=0. Otherwise, see the description of surf
!!    in the NSWC library manual.
!!    zp is an array of at least 3*m*n locations.
!!    Temp is an array of at least n+n+m locations which is
!!    used for scratch storage.
!!    sigma contains the tension factor. This value indicates
!!    the curviness desired. If abs(sigma) is nearly zero
!!    (E. G. .001) The resulting surface is approximately the
!!    tensor product of cubic splines. If abs(sigma) is large
!!    (E. G. 50.) The resulting surface is approximately
!!    bi-linear. If sigma equals zero tensor products of
!!    cubic splines result. A standard value for sigma is
!!    approximately 1. In absolute value.
!!  On output--
!!    zp contains the values of the XX-, YY-, and XXYY-partial
!!    derivatives of the surface at the given nodes.
!!    ierr contains an error flag,
!!         = 0 For normal return,
!!         = 1 If n is less than 2 or m is less than 2,
!!         = 2 If the x-values or y-values are not strictly
!!             increasing,
!!         = 3 The option vector HAS an error.
!!  This subroutine references package modules ceez, terms,
!!  and snhcsh.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n, iz
integer, intent(out) :: ierr
real, intent(in) :: x(m), y(n), z(iz,n), opt(*)
real, intent(inout) :: zp(m,n,*), temp(*)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, ibak, ibakp1, im1, ip1, j, jbak, jbakp1, jm1, jp1, key, l, mm1, mp1, nm1, np1, npi, npibak, npm, npmpj, ind(8), &
   & loc(8), num(8), nswc_ai_i4
real :: c1, c2, c3, del1, del2, deli, delx1, delx2, delxm, delxmm, &
   & dely1, dely2, delyn, delynm, diag1, diag2, diagi, diagin, sdiag1, &
   & sdiag2, sigmax, sigmay, t, zxy1ns, zxymns
interface
   pure elemental subroutine ceez(del1,del2,sigma,c1,c2,c3,n)
      implicit none
      real, intent(in) :: del1
      real, intent(in) :: del2
      real, intent(in) :: sigma
      real, intent(inout) :: c1
      real, intent(inout) :: c2
      real, intent(inout) :: c3
      integer, intent(in) :: n
   end subroutine ceez
   pure elemental subroutine terms(diag,sdiag,sigma,del)
      implicit none
      real, intent(inout) :: diag
      real, intent(inout) :: sdiag
      real, intent(in) :: sigma
      real, intent(in) :: del
   end subroutine terms
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
!                               modified by Alfred H. Morris
!                               naval surface weapons center
!                                          Dahlgren Virginia
! this subroutine determines the parameters necessary to
! compute an interpolatory surface passing through a rect-
! angular grid of functional values. The surface determined
! can be represented as the tensor product of splines under
! tension. The x- and y-partial derivatives around the
! boundary and the x-y-partial derivatives at the four
! corners may be specified or omitted. For actual mapping
! of points onto the surface it is necessary to call the
! function surf2.
! On input--
!   m is the number of grid lines in the x-direction, I. E.
!   Lines parallel to the y-axis (m .GE. 2).
!   n is the number of grid lines in the y-direction, I. E.
!   Lines parallel to the x-axis (n .GE. 2).
!   x is an array of the m x-coordinates of the grid lines
!   in the x-direction. These should be strictly increasing.
!   y is an array of the n y-coordinates of the grid lines
!   in the y-direction. These should be strictly increasing.
!   z is an array of the m * n functional values at the grid
!   points, I. E. z(i,j) contains the functional value at
!   (x(i),y(j)) FOR i = 1,...,m AND j = 1,...,n.
!   iz is the row dimension of the matrix z used in the
!   CALLING PROGRAM (iz .GE. m).
!   Opt is an option vector. If no boundary conditions are
!   to be imposed on the surface then let opt be of length 1
!   and set opt(1)=0. Otherwise, see the description of surf
!   in the NSWC library manual.
!   zp is an array of at least 3*m*n locations.
!   Temp is an array of at least n+n+m locations which is
!   used for scratch storage.
!   sigma contains the tension factor. This value indicates
!   the curviness desired. If abs(sigma) is nearly zero
!   (E. G. .001) The resulting surface is approximately the
!   tensor product of cubic splines. If abs(sigma) is large
!   (E. G. 50.) The resulting surface is approximately
!   bi-linear. If sigma equals zero tensor products of
!   cubic splines result. A standard value for sigma is
!   approximately 1. In absolute value.
! On output--
!   zp contains the values of the XX-, YY-, and XXYY-partial
!   derivatives of the surface at the given nodes.
!   ierr contains an error flag,
!        = 0 For normal return,
!        = 1 If n is less than 2 or m is less than 2,
!        = 2 If the x-values or y-values are not strictly
!            increasing,
!        = 3 The option vector HAS an error.
! This subroutine references package modules ceez, terms,
! and snhcsh.
!-----------------------------------------------------------
data num(5)/1/, num(6)/1/, num(7)/1/, num(8)/1/
mm1 = m - 1
mp1 = m + 1
nm1 = n - 1
np1 = n + 1
npm = n + m
ierr = 0
if (n <= 1 .or. m <= 1) go to 46
if (y(n) <= y(1)) go to 47
! Process the option vector
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
l = 1
100 key = opt(l)
nswc_ai_i4 = key
if (nswc_ai_i4 < 0) go to 48
if (nswc_ai_i4 == 0) go to 110
go to 101
101 if (key > 8) go to 48
ind(key) = 1
l = l + 1
loc(key) = l
l = l + num(key)
go to 100
! Denormalize tension factor in y-direction
110 sigmay = abs(sigma)*float(n - 1)/(y(n) - y(1))
! Obtain y-partial derivatives along y = y(1)
if (ind(3) == 0) go to 2
l = loc(3)
do i = 1,m
   zp(i,1,1) = opt(l)
   l = l + 1
end do
go to 5
2 dely1 = y(2) - y(1)
dely2 = dely1 + dely1
if (n > 2) dely2 = y(3) - y(1)
if (dely1 <= 0. .or. dely2 <= dely1) go to 47
call ceez(dely1,dely2,sigmay,c1,c2,c3,n)
do i = 1,m
   zp(i,1,1) = c1*z(i,1) + c2*z(i,2)
end do
if (n == 2) go to 5
do i = 1,m
   zp(i,1,1) = zp(i,1,1) + c3*z(i,3)
end do
! Obtain y-partial derivatives along y = y(n)
5 if (ind(4) == 0) go to 7
l = loc(4)
do i = 1,m
   npi = n + i
   temp(npi) = opt(l)
   l = l + 1
end do
go to 10
7 delyn = y(n) - y(nm1)
delynm = delyn + delyn
if (n > 2) delynm = y(n) - y(n - 2)
if (delyn <= 0. .or. delynm <= delyn) go to 47
call ceez(-delyn,-delynm,sigmay,c1,c2,c3,n)
do i = 1,m
   npi = n + i
   temp(npi) = c1*z(i,n) + c2*z(i,nm1)
end do
if (n == 2) go to 10
do i = 1,m
   npi = n + i
   temp(npi) = temp(npi) + c3*z(i,n - 2)
end do
10 if (x(m) <= x(1)) go to 47
! Denormalize tension factor in x-direction
sigmax = abs(sigma)*float(m - 1)/(x(m) - x(1))
! Obtain x-partial derivatives along x = x(1)
if (ind(1) == 0) go to 12
l = loc(1)
do j = 1,n
   zp(1,j,2) = opt(l)
   l = l + 1
end do
if (ind(5) + ind(7) == 2) go to 15
12 delx1 = x(2) - x(1)
delx2 = delx1 + delx1
if (m > 2) delx2 = x(3) - x(1)
if (delx1 <= 0. .or. delx2 <= delx1) go to 47
call ceez(delx1,delx2,sigmax,c1,c2,c3,m)
if (ind(1) == 1) go to 15
do j = 1,n
   zp(1,j,2) = c1*z(1,j) + c2*z(2,j)
end do
if (m == 2) go to 15
do j = 1,n
   zp(1,j,2) = zp(1,j,2) + c3*z(3,j)
end do
! Obtain x-y-partial derivative at (x(1),y(1))
15 if (ind(5) == 0) go to 16
l = loc(5)
zp(1,1,3) = opt(l)
go to 17
16 zp(1,1,3) = c1*zp(1,1,1) + c2*zp(2,1,1)
if (m > 2) zp(1,1,3) = zp(1,1,3) + c3*zp(3,1,1)
! Obtain x-y-partial derivative at (x(1),y(n))
17 if (ind(7) == 0) go to 18
l = loc(7)
zxy1ns = opt(l)
go to 19
18 zxy1ns = c1*temp(n + 1) + c2*temp(n + 2)
if (m > 2) zxy1ns = zxy1ns + c3*temp(n + 3)
! Obtain x-partial derivative along x = x(m)
19 if (ind(2) == 0) go to 21
l = loc(2)
do j = 1,n
   npmpj = npm + j
   temp(npmpj) = opt(l)
   l = l + 1
end do
21 if (ind(6) + ind(8) == 2) go to 24
delxm = x(m) - x(mm1)
delxmm = delxm + delxm
if (m > 2) delxmm = x(m) - x(m - 2)
if (delxm <= 0. .or. delxmm <= delxm) go to 47
call ceez(-delxm,-delxmm,sigmax,c1,c2,c3,m)
if (ind(2) == 1) go to 24
do j = 1,n
   npmpj = npm + j
   temp(npmpj) = c1*z(m,j) + c2*z(mm1,j)
end do
if (m == 2) go to 24
do j = 1,n
   npmpj = npm + j
   temp(npmpj) = temp(npmpj) + c3*z(m - 2,j)
end do
! Obtain x-y-partial derivative at (x(m),y(1))
24 if (ind(6) == 0) go to 25
l = loc(6)
zp(m,1,3) = opt(l)
go to 26
25 zp(m,1,3) = c1*zp(m,1,1) + c2*zp(mm1,1,1)
if (m > 2) zp(m,1,3) = zp(m,1,3) + c3*zp(m - 2,1,1)
! Obtain x-y-partial derivative at (x(m),y(n))
26 if (ind(8) == 0) go to 27
l = loc(8)
zxymns = opt(l)
go to 28
27 zxymns = c1*temp(npm) + c2*temp(npm - 1)
if (m > 2) zxymns = zxymns + c3*temp(npm - 2)
! Set up right hand sides and tridiagonal system for y-grid
! perform forward elimination
28 del1 = y(2) - y(1)
if (del1 <= 0.) go to 47
deli = 1./del1
do i = 1,m
   zp(i,2,1) = deli*(z(i,2) - z(i,1))
end do
zp(1,2,3) = deli*(zp(1,2,2) - zp(1,1,2))
zp(m,2,3) = deli*(temp(npm + 2) - temp(npm + 1))
call terms(diag1,sdiag1,sigmay,del1)
diagi = 1./diag1
do i = 1,m
   zp(i,1,1) = diagi*(zp(i,2,1) - zp(i,1,1))
end do
zp(1,1,3) = diagi*(zp(1,2,3) - zp(1,1,3))
zp(m,1,3) = diagi*(zp(m,2,3) - zp(m,1,3))
temp(1) = diagi*sdiag1
if (n == 2) go to 34
do j = 2,nm1
   jm1 = j - 1
   jp1 = j + 1
   npmpj = npm + j
   del2 = y(jp1) - y(j)
   if (del2 <= 0.) go to 47
   deli = 1./del2
   do i = 1,m
      zp(i,jp1,1) = deli*(z(i,jp1) - z(i,j))
   end do
   zp(1,jp1,3) = deli*(zp(1,jp1,2) - zp(1,j,2))
   zp(m,jp1,3) = deli*(temp(npmpj + 1) - temp(npmpj))
   call terms(diag2,sdiag2,sigmay,del2)
   diagin = 1./(diag1 + diag2 - sdiag1*temp(jm1))
   do i = 1,m
      zp(i,j,1) = diagin*(zp(i,jp1,1) - zp(i,j,1) - &
         & sdiag1*zp(i,jm1,1))
   end do
   zp(1,j,3) = diagin*(zp(1,jp1,3) - zp(1,j,3) - &
      & sdiag1*zp(1,jm1,3))
   zp(m,j,3) = diagin*(zp(m,jp1,3) - zp(m,j,3) - &
      & sdiag1*zp(m,jm1,3))
   temp(j) = diagin*sdiag2
   diag1 = diag2
   sdiag1 = sdiag2
end do
34 diagin = 1./(diag1 - sdiag1*temp(nm1))
do i = 1,m
   npi = n + i
   zp(i,n,1) = diagin*(temp(npi) - zp(i,n,1) - &
      & sdiag1*zp(i,nm1,1))
end do
zp(1,n,3) = diagin*(zxy1ns - zp(1,n,3) - &
   & sdiag1*zp(1,nm1,3))
temp(n) = diagin*(zxymns - zp(m,n,3) - &
   & sdiag1*zp(m,nm1,3))
! Perform back substitution
do j = 2,n
   jbak = np1 - j
   jbakp1 = jbak + 1
   t = temp(jbak)
   do i = 1,m
      zp(i,jbak,1) = zp(i,jbak,1) - t*zp(i,jbakp1,1)
   end do
   zp(1,jbak,3) = zp(1,jbak,3) - t*zp(1,jbakp1,3)
   temp(jbak) = zp(m,jbak,3) - t*temp(jbakp1)
end do
! Set up right hand sides and tridiagonal system for x-grid
! perform forward elimination
del1 = x(2) - x(1)
if (del1 <= 0.) go to 47
deli = 1./del1
do j = 1,n
   zp(2,j,2) = deli*(z(2,j) - z(1,j))
   zp(2,j,3) = deli*(zp(2,j,1) - zp(1,j,1))
end do
call terms(diag1,sdiag1,sigmax,del1)
diagi = 1./diag1
do j = 1,n
   zp(1,j,2) = diagi*(zp(2,j,2) - zp(1,j,2))
   zp(1,j,3) = diagi*(zp(2,j,3) - zp(1,j,3))
end do
temp(n + 1) = diagi*sdiag1
if (m == 2) go to 43
do i = 2,mm1
   im1 = i - 1
   ip1 = i + 1
   npi = n + i
   del2 = x(ip1) - x(i)
   if (del2 <= 0.) go to 47
   deli = 1./del2
   do j = 1,n
      zp(ip1,j,2) = deli*(z(ip1,j) - z(i,j))
      zp(ip1,j,3) = deli*(zp(ip1,j,1) - zp(i,j,1))
   end do
   call terms(diag2,sdiag2,sigmax,del2)
   diagin = 1./(diag1 + diag2 - sdiag1*temp(npi - 1))
   do j = 1,n
      zp(i,j,2) = diagin*(zp(ip1,j,2) - zp(i,j,2) - &
         & sdiag1*zp(im1,j,2))
      zp(i,j,3) = diagin*(zp(ip1,j,3) - zp(i,j,3) - &
         & sdiag1*zp(im1,j,3))
   end do
   temp(npi) = diagin*sdiag2
   diag1 = diag2
   sdiag1 = sdiag2
end do
43 diagin = 1./(diag1 - sdiag1*temp(npm - 1))
do j = 1,n
   npmpj = npm + j
   zp(m,j,2) = diagin*(temp(npmpj) - zp(m,j,2) - &
      & sdiag1*zp(mm1,j,2))
   zp(m,j,3) = diagin*(temp(j) - zp(m,j,3) - &
      & sdiag1*zp(mm1,j,3))
end do
! Perform back substitution
do i = 2,m
   ibak = mp1 - i
   ibakp1 = ibak + 1
   npibak = n + ibak
   t = temp(npibak)
   do j = 1,n
      zp(ibak,j,2) = zp(ibak,j,2) - t*zp(ibakp1,j,2)
      zp(ibak,j,3) = zp(ibak,j,3) - t*zp(ibakp1,j,3)
   end do
end do
return
! Too few points
46 ierr = 1
return
! Points not strictly increasing
47 ierr = 2
return
! The option vector HAS an error
48 ierr = 3
end subroutine surf

function surf2(xx,yy,m,n,x,y,z,iz,zp,sigma)
!! <!-- nswc-ford:begin SURF2 -->
!! Reference for `surf2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                        coded by A. K. Cline and R. J. Renka
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this function interpolates a surface at a given coordinate
!!  pair using A bi-spline under tension. The subroutine surf1
!!  should be called earlier to determine certain necessary
!!  parameters.
!!  On input--
!!    xx and yy contain the x- and y-coordinates of the point
!!    to be mapped onto the interpolating surface.
!!    m and n contain the number of grid lines in the x- and
!!    y-directions, respectively, of the rectangular grid
!!    which specified the surface.
!!    x and y are arrays containing the x- and y-grid values,
!!    respectively, each in increasing order.
!!    z is a matrix containing the m * n functional values
!!    corresponding to the grid values (I. E. z(i,j) is the
!!    surface value at the point (x(i),y(j)) for i = 1,...,m
!!    AND j = 1,...,n).
!!    iz contains the row dimension of the array z as declared
!!    in the calling program.
!!    zp is an array of 3*m*n locations stored with the
!!    various surface derivative information determined by
!!    SURF1.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters m, n, x, y, z, iz, zp, and sigma should be
!!  input unaltered from the output of SURF1.
!!  On output--
!!    surf2 contains the interpolated surface value.
!!  None of the input parameters are altered.
!!  This function references package modules intrvl and
!!  snhcsh.
!!
!!  Inline one dimensional cubic spline interpolation
!!  Inline one dimensional spline under tension interpolation
!!  Denormalize tension factor in x and y direction
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n, iz
real, intent(in) :: xx, yy, x(m), y(n)
real :: z(iz,n), zp(m,n,*)
real, intent(in) :: sigma
real :: surf2
!     beginning of local variable declarations
integer :: i, im1, j, jm1
real :: coshp1, coshp2, del1, del2, delp1, delp2, dels, dummy, f1, &
   & f2, fp1, fp2, sigmap, sigmax, sigmay, sinhm1, sinhm2, sinhms, &
   & sinhp1, sinhp2, zi, zim1, zxxi, zxxim1
integer :: intrvl
interface
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
! this function interpolates a surface at a given coordinate
! pair using A bi-spline under tension. The subroutine surf1
! should be called earlier to determine certain necessary
! parameters.
! On input--
!   xx and yy contain the x- and y-coordinates of the point
!   to be mapped onto the interpolating surface.
!   m and n contain the number of grid lines in the x- and
!   y-directions, respectively, of the rectangular grid
!   which specified the surface.
!   x and y are arrays containing the x- and y-grid values,
!   respectively, each in increasing order.
!   z is a matrix containing the m * n functional values
!   corresponding to the grid values (I. E. z(i,j) is the
!   surface value at the point (x(i),y(j)) for i = 1,...,m
!   AND j = 1,...,n).
!   iz contains the row dimension of the array z as declared
!   in the calling program.
!   zp is an array of 3*m*n locations stored with the
!   various surface derivative information determined by
!   SURF1.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters m, n, x, y, z, iz, zp, and sigma should be
! input unaltered from the output of SURF1.
! On output--
!   surf2 contains the interpolated surface value.
! None of the input parameters are altered.
! This function references package modules intrvl and
! snhcsh.
!-----------------------------------------------------------
! Inline one dimensional cubic spline interpolation
! Inline one dimensional spline under tension interpolation
! Denormalize tension factor in x and y direction
sigmax = abs(sigma)*float(m - 1)/(x(m) - x(1))
sigmay = abs(sigma)*float(n - 1)/(y(n) - y(1))
! Determine y interval
jm1 = intrvl(yy,y,n)
j = jm1 + 1
! Determine x interval
im1 = intrvl(xx,x,m)
i = im1 + 1
del1 = yy - y(jm1)
del2 = y(j) - yy
dels = y(j) - y(jm1)
if (sigmay /= 0.) go to 1
! Perform four interpolations in y-direction
zim1 = hermz(z(i - 1,j - 1),z(i - 1,j),zp(i - 1,j - 1,1), &
   & zp(i - 1,j,1))
zi = hermz(z(i,j - 1),z(i,j),zp(i,j - 1,1),zp(i,j,1))
zxxim1 = hermz(zp(i - 1,j - 1,2),zp(i - 1,j,2), &
   & zp(i - 1,j - 1,3),zp(i - 1,j,3))
zxxi = hermz(zp(i,j - 1,2),zp(i,j,2), &
   & zp(i,j - 1,3),zp(i,j,3))
go to 2
1 delp1 = (del1 + dels)/2.
delp2 = (del2 + dels)/2.
call snhcsh(sinhm1,dummy,sigmay*del1,-1)
call snhcsh(sinhm2,dummy,sigmay*del2,-1)
call snhcsh(sinhms,dummy,sigmay*dels,-1)
call snhcsh(sinhp1,dummy,sigmay*del1/2.,-1)
call snhcsh(sinhp2,dummy,sigmay*del2/2.,-1)
call snhcsh(dummy,coshp1,sigmay*delp1,1)
call snhcsh(dummy,coshp2,sigmay*delp2,1)
zim1 = hermnz(z(i - 1,j - 1),z(i - 1,j),zp(i - 1,j - 1,1), &
   & zp(i - 1,j,1),sigmay)
zi = hermnz(z(i,j - 1),z(i,j),zp(i,j - 1,1),zp(i,j,1), &
   & sigmay)
zxxim1 = hermnz(zp(i - 1,j - 1,2),zp(i - 1,j,2), &
   & zp(i - 1,j - 1,3),zp(i - 1,j,3),sigmay)
zxxi = hermnz(zp(i,j - 1,2),zp(i,j,2), &
   & zp(i,j - 1,3),zp(i,j,3),sigmay)
! Perform final interpolation in x-direction
2 del1 = xx - x(im1)
del2 = x(i) - xx
dels = x(i) - x(im1)
if (sigmax /= 0.) go to 3
surf2 = hermz(zim1,zi,zxxim1,zxxi)
return
3 delp1 = (del1 + dels)/2.
delp2 = (del2 + dels)/2.
call snhcsh(sinhm1,dummy,sigmax*del1,-1)
call snhcsh(sinhm2,dummy,sigmax*del2,-1)
call snhcsh(sinhms,dummy,sigmax*dels,-1)
call snhcsh(sinhp1,dummy,sigmax*del1/2.,-1)
call snhcsh(sinhp2,dummy,sigmax*del2/2.,-1)
call snhcsh(dummy,coshp1,sigmax*delp1,1)
call snhcsh(dummy,coshp2,sigmax*delp2,1)
surf2 = hermnz(zim1,zi,zxxim1,zxxi,sigmax)
contains
   pure function hermnz(f1, f2, fp1, fp2, sigmap) result(nswc_sf_result)
      implicit none
      real, intent(in) :: f1
      real, intent(in) :: f2
      real, intent(in) :: fp1
      real, intent(in) :: fp2
      real, intent(in) :: sigmap
      real :: nswc_sf_result
      nswc_sf_result = (f2*del1 + f1*del2)/dels   + (fp2*(sinhm1*del2 - del1*(2.*(coshp1 + 1.)*   sinhp2 + sigmap*coshp1*del2)) &
   & + fp1*(sinhm2*del1 - del2*(2.*(coshp2 + 1.)*   sinhp1 + sigmap*coshp2*del1))   )/(sigmap*sigmap*dels*(sinhms + sigmap*dels))
   end function hermnz
   pure function hermz(f1, f2, fp1, fp2) result(nswc_sf_result)
      implicit none
      real, intent(in) :: f1
      real, intent(in) :: f2
      real, intent(in) :: fp1
      real, intent(in) :: fp2
      real :: nswc_sf_result
      nswc_sf_result = (f2*del1 + f1*del2)/dels - del1*   del2*(fp2*(del1 + dels) +   fp1*(del2 + dels))/   (6.*dels)
   end function hermz
end function surf2

pure subroutine nsurf2(dxmin,dxmax,md,dymin,dymax,nd,dz, &
   & idz,m,n,x,y,z,iz,zp,work,sigma)
!! <!-- nswc-ford:begin NSURF2 -->
!! Reference for `nsurf2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       From the spline under tension package
!!                                  coded by alan Kaylor Cline
!!                             department of computer sciences
!!                               University of Texas at Austin
!!  this subroutine maps values onto a surface at every point
!!  of a grid equally spaced in both x and y coordinates. The
!!  surface interpolation is performed using A bi-spline
!!  under tension. The subroutine surf1 or NSURF1 should be
!!  called earlier to determine certain necessary parameters.
!!  On input--
!!    dxmin and dxmax contain the lower and upper limits,
!!    respectively, of the x-coordinates of the second grid.
!!    md contains the number of grid lines in the x direction
!!    of the second grid (md .GE. 1).
!!    dymin and dymax contain the lower and upper limits,
!!    respectively, of the y-coordinates of the second grid.
!!    nd contains the number of grid lines in the y direction
!!    of the second grid (nd .GE. 1).
!!    idz contains the row dimension of the array dz as
!!    declared in the calling program.
!!    m and n contain the number of grid lines in the x- and
!!    y-directions, respectively, of the rectangular grid
!!    which specified the surface.
!!    x and y are arrays containing the x- and y-grid values,
!!    respectively, each in increasing order.
!!    z is a matrix containing the m * n functional values
!!    corresponding to the grid values (I. E. z(i,j) is the
!!    surface value at the point (x(i),y(j)) for i = 1,...,m
!!    AND j = 1,...,n).
!!    iz contains the row dimension of the array z as declared
!!    in the calling program.
!!    zp is an array of 3*m*n locations stored with the
!!    various surface derivative information determined by
!!    SURF1.
!!    Work is an array of 4*md locations to be used internally
!!    for workspace.
!!  And
!!    sigma contains the tension factor (its sign is ignored).
!!  The parameters m, n, x, y, z, iz, zp, and sigma should be
!!  input unaltered from the output of SURF1 or NSURF1.
!!  On output--
!!    dz contains the md by nd array of surface values
!!    interpolated at the points of the second grid.
!!  None of the input parameters are altered.
!!  This function references package module snhcsh.
!!
!!  Denormalize tension factor in x and y direction
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: md, nd, idz, m, n, iz
real, intent(in) :: dxmin, dxmax, dymin, dymax
real, intent(inout) :: dz(idz,nd)
real, intent(in) :: x(m), y(n), z(iz,n), zp(m,n,*)
real, intent(inout) :: work(4,md)
real, intent(in) :: sigma
!     beginning of local variable declarations
integer :: i, ii, im1, j, jj, jm1, lasti, lastj
real :: c1, c2, c3, c4, coshp1, coshp2, del1, del2, delp1, delp2, &
   & dels, deltdx, deltdy, dummy, sigmax, sigmay, sinhm1, sinhm2, &
   & sinhms, sinhp1, sinhp2, temp, xii, yjj, zi, zim1, zxxi, zxxim1
interface
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
end interface
!                      From the spline under tension package
!                                 coded by alan Kaylor Cline
!                            department of computer sciences
!                              University of Texas at Austin
! this subroutine maps values onto a surface at every point
! of a grid equally spaced in both x and y coordinates. The
! surface interpolation is performed using A bi-spline
! under tension. The subroutine surf1 or NSURF1 should be
! called earlier to determine certain necessary parameters.
! On input--
!   dxmin and dxmax contain the lower and upper limits,
!   respectively, of the x-coordinates of the second grid.
!   md contains the number of grid lines in the x direction
!   of the second grid (md .GE. 1).
!   dymin and dymax contain the lower and upper limits,
!   respectively, of the y-coordinates of the second grid.
!   nd contains the number of grid lines in the y direction
!   of the second grid (nd .GE. 1).
!   idz contains the row dimension of the array dz as
!   declared in the calling program.
!   m and n contain the number of grid lines in the x- and
!   y-directions, respectively, of the rectangular grid
!   which specified the surface.
!   x and y are arrays containing the x- and y-grid values,
!   respectively, each in increasing order.
!   z is a matrix containing the m * n functional values
!   corresponding to the grid values (I. E. z(i,j) is the
!   surface value at the point (x(i),y(j)) for i = 1,...,m
!   AND j = 1,...,n).
!   iz contains the row dimension of the array z as declared
!   in the calling program.
!   zp is an array of 3*m*n locations stored with the
!   various surface derivative information determined by
!   SURF1.
!   Work is an array of 4*md locations to be used internally
!   for workspace.
! And
!   sigma contains the tension factor (its sign is ignored).
! The parameters m, n, x, y, z, iz, zp, and sigma should be
! input unaltered from the output of SURF1 or NSURF1.
! On output--
!   dz contains the md by nd array of surface values
!   interpolated at the points of the second grid.
! None of the input parameters are altered.
! This function references package module snhcsh.
!-----------------------------------------------------------
! Denormalize tension factor in x and y direction
sigmax = abs(sigma)*float(m - 1)/(x(m) - x(1))
sigmay = abs(sigma)*float(n - 1)/(y(n) - y(1))
! Find intervals of second x grid with respect to original x
! grid
deltdx = 0.
if (md >= 2) deltdx = (dxmax - dxmin)/float(md - 1)
lasti = 1
do ii = 1,md
   xii = dxmin + float(ii - 1)*deltdx
   i = lasti
1  i = i + 1
   if (xii > x(i) .and. i < m) go to 1
   im1 = i - 1
   lasti = im1
   del1 = xii - x(im1)
   del2 = x(i) - xii
   dels = x(i) - x(im1)
   work(1,ii) = del2/dels
   work(2,ii) = del1/dels
   if (sigmax /= 0.) go to 2
   temp = -del1*del2/(6.*dels)
   work(3,ii) = temp*(del2 + dels)
   work(4,ii) = temp*(del1 + dels)
   go to 3
2  delp1 = (del1 + dels)/2.
   delp2 = (del2 + dels)/2.
   call snhcsh(sinhm1,dummy,sigmax*del1,-1)
   call snhcsh(sinhm2,dummy,sigmax*del2,-1)
   call snhcsh(sinhms,dummy,sigmax*dels,-1)
   call snhcsh(sinhp1,dummy,sigmax*del1/2.,-1)
   call snhcsh(sinhp2,dummy,sigmax*del2/2.,-1)
   call snhcsh(dummy,coshp1,sigmax*delp1,1)
   call snhcsh(dummy,coshp2,sigmax*delp2,1)
   temp = sigmax*sigmax*dels*(sinhms + sigmax*dels)
   work(3,ii) = (sinhm2*del1 - del2*(2.*(coshp2 + 1.)* &
      & sinhp1 + sigmax*coshp2*del1))/temp
   work(4,ii) = (sinhm1*del2 - del1*(2.*(coshp1 + 1.)* &
      & sinhp2 + sigmax*coshp1*del2))/temp
3  continue
end do
! Find intervals of second y grid with respect to original y
! grid and perform intrpolation
deltdy = 0.
if (nd >= 2) deltdy = (dymax - dymin)/float(nd - 1)
lastj = 1
do jj = 1,nd
   yjj = dymin + float(jj - 1)*deltdy
   j = lastj
4  j = j + 1
   if (yjj > y(j) .and. j < n) go to 4
   jm1 = j - 1
   lastj = jm1
   del1 = yjj - y(jm1)
   del2 = y(j) - yjj
   dels = y(j) - y(jm1)
   c1 = del2/dels
   c2 = del1/dels
   if (sigmay /= 0.) go to 5
   temp = -del1*del2/(6.*dels)
   c3 = temp*(del2 + dels)
   c4 = temp*(del1 + dels)
   go to 6
5  delp1 = (del1 + dels)/2.
   delp2 = (del2 + dels)/2.
   call snhcsh(sinhm1,dummy,sigmay*del1,-1)
   call snhcsh(sinhm2,dummy,sigmay*del2,-1)
   call snhcsh(sinhms,dummy,sigmay*dels,-1)
   call snhcsh(sinhp1,dummy,sigmay*del1/2.,-1)
   call snhcsh(sinhp2,dummy,sigmay*del2/2.,-1)
   call snhcsh(dummy,coshp1,sigmay*delp1,1)
   call snhcsh(dummy,coshp2,sigmay*delp2,1)
   temp = sigmay*sigmay*dels*(sinhms + sigmay*dels)
   c3 = (sinhm2*del1 - del2*(2.*(coshp2 + 1.)* &
      & sinhp1 + sigmay*coshp2*del1))/temp
   c4 = (sinhm1*del2 - del1*(2.*(coshp1 + 1.)* &
      & sinhp2 + sigmay*coshp1*del2))/temp
6  lasti = 0
   do ii = 1,md
      xii = dxmin + float(ii - 1)*deltdx
      i = max(1, lasti)
7     i = i + 1
      if (xii > x(i) .and. i < m) go to 7
      im1 = i - 1
      if (im1 == lasti) go to 8
      lasti = im1
      zim1 = c1*z(im1,jm1) + c2*z(im1,j) &
         & + c3*zp(im1,jm1,1) + c4*zp(im1,j,1)
      zi = c1*z(i,jm1) + c2*z(i,j) &
         & + c3*zp(i,jm1,1) + c4*zp(i,j,1)
      zxxim1 = c1*zp(im1,jm1,2) + c2*zp(im1,j,2) &
         & + c3*zp(im1,jm1,3) + c4*zp(im1,j,3)
      zxxi = c1*zp(i,jm1,2) + c2*zp(i,j,2) &
         & + c3*zp(i,jm1,3) + c4*zp(i,j,3)
8     dz(ii,jj) = work(1,ii)*zim1 + work(2,ii)*zi &
         & + work(3,ii)*zxxim1 + work(4,ii)*zxxi
   end do
end do
end subroutine nsurf2

pure subroutine bstrp2(x, y, z, kz, tx, nx, kx, ty, ny, ky, &
   & a, ka, wk, l, iflag)
!! <!-- nswc-ford:begin BSTRP2 -->
!! Reference for `bstrp2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          Piecewise polynomial interpolation in two variables
!!
!!      The piecewise polynomials considered are tensor products of
!!      B-splines, having the form
!!                           nx   ny
!!               F(x,y)  =  Sum  sum  A   U (x) V (y)
!!                          I=1  J=1   IJ  I     J
!!      where U  and V  are one-dimensional B-spline basis functions.
!!             I      J
!!
!!      real tx(nx + kx), ty(ny + ky)
!!      real wk(l)  where l = nx*ny + max(2*kx*nx, 2*ky*ny)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: ka, kx, ky, kz, l, nx, ny
real, intent(in) :: x(nx), y(ny), z(kz,ny)
real, intent(in) :: tx(*), ty(*)
real, intent(inout) :: a(ka,ny), wk(l)
!     beginning of local variable declarations
integer :: iw, m
interface
   pure subroutine bstrp1(x,z,kz,m,n,t,k,a,ka,work,iflag)
      implicit none
      integer, intent(in) :: ka
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: kz
      real, intent(in) :: x(m)
      real, intent(in) :: z(kz,n)
      real, intent(in) :: t(*)
      integer, intent(in) :: k
      real, intent(inout) :: a(ka,m)
      real, intent(inout) :: work(*)
      integer, intent(out) :: iflag
   end subroutine bstrp1
end interface
!-----------------------------------------------------------------------
!         Piecewise polynomial interpolation in two variables
!                          -----------------
!     The piecewise polynomials considered are tensor products of
!     B-splines, having the form
!                          nx   ny
!              F(x,y)  =  Sum  sum  A   U (x) V (y)
!                         I=1  J=1   IJ  I     J
!     where U  and V  are one-dimensional B-spline basis functions.
!            I      J
!-----------------------------------------------------------------------
!     real tx(nx + kx), ty(ny + ky)
!     real wk(l)  where l = nx*ny + max(2*kx*nx, 2*ky*ny)
!-------------------------
m = nx*ny + 2*max(kx*nx, ky*ny)
if (l < m) go to 120
!     Compute the coefficients
iw = nx*ny + 1
call bstrp1(x, z, kz, nx, ny, tx, kx, wk, ny, wk(iw), iflag)
if (iflag /= 0) go to 100
call bstrp1(y, wk, ny, ny, nx, ty, ky, a, ka, wk(iw), iflag)
if (iflag /= 0) go to 110
return
!     Error return
100 iflag = 1
return
110 iflag = 2
return
120 iflag = 3
end subroutine bstrp2

pure subroutine bstrp1(x, z, kz, m, n, t, k, a, ka, work, iflag)
!! <!-- nswc-ford:begin BSTRP1 -->
!! Reference for `bstrp1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bstrp1 computes B-spline interpolation coefficients for
!!      n sets of data stored in the columns of the array z. the
!!      coefficients are stored in the rows of A.
!!      It is assumed that kz .GE. m and ka .GE. n.
!!
!!      real t(m + k), work(2*k*m)
!!
!!      First data set
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: k, ka, kz, m, n
real, intent(in) :: x(m), z(kz,n), t(*)
real, intent(inout) :: a(ka,m), work(*)
!     beginning of local variable declarations
integer :: i, j, mp1
interface
   pure subroutine bstrp(tau,gtau,t,n,k,bcoef,q,iflag)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: tau(n)
      real, intent(in) :: gtau(n)
      real, intent(in) :: t(*)
      integer, intent(in) :: k
      real, intent(inout) :: bcoef(n)
      real, intent(inout) :: q(*)
      integer, intent(inout) :: iflag
   end subroutine bstrp
end interface
!-------------------------------------------------------------------
!     bstrp1 computes B-spline interpolation coefficients for
!     n sets of data stored in the columns of the array z. the
!     coefficients are stored in the rows of A.
!     It is assumed that kz .GE. m and ka .GE. n.
!-------------------------------------------------------------------
!     real t(m + k), work(2*k*m)
!-----------------------
!     First data set
iflag = 1
mp1 = m + 1
call bstrp(x, z, t, m, k, work(1), work(mp1), iflag)
if (iflag /= 0) return
do i = 1,m
   a(1,i) = work(i)
end do
if (n == 1) return
!     Remaining data sets
do j = 2,n
   call bstrp(x, z(1,j), t, m, k, work(1), work(mp1), iflag)
   do i = 1,m
      a(j,i) = work(i)
   end do
end do
end subroutine bstrp1

pure subroutine bslsq2(x, wx, mx, y, wy, my, z, kz, tx, nx, kx, &
   & ty, ny, ky, a, ka, wk, l, iflag)
!! <!-- nswc-ford:begin BSLSQ2 -->
!! Reference for `bslsq2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Weighted least squares fitting of piecewise
!!                     polynomials in two variables
!!
!!      The piecewise polynomials considered are tensor products of
!!      B-splines, having the form
!!                           nx   ny
!!               F(x,y)  =  Sum  sum  A   U (x) V (y)
!!                          I=1  J=1   IJ  I     J
!!      where U  and V  are one-dimensional B-spline basis functions.
!!             I      J
!!
!!      real tx(nx + kx), ty(ny + ky)
!!      real wk(l)  where l = nx*my + max((kx+1)*nx,(ky+1)*ny)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: ka, kx, ky, kz, l, mx, my, nx, ny
real, intent(in) :: x(mx), wx(mx), y(my), wy(my), z(kz,my)
real, intent(in) :: tx(*), ty(*)
real, intent(inout) :: a(ka,ny), wk(l)
!     beginning of local variable declarations
integer :: ierr, iq, iw, m
interface
   pure subroutine bslsq1(tau,wgt,ntau,z,kz,m,t,n,k,a,ka,wk,q, &
      & ierr)
      implicit none
      integer, intent(in) :: ka
      integer, intent(in) :: k
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: kz
      integer, intent(in) :: ntau
      real, intent(in) :: tau(ntau)
      real, intent(in) :: wgt(ntau)
      real, intent(in) :: z(kz,m)
      real, intent(in) :: t(*)
      real, intent(inout) :: a(ka,n)
      real, intent(inout) :: wk(n)
      real, intent(inout) :: q(k,n)
      integer, intent(inout) :: ierr
   end subroutine bslsq1
end interface
!-----------------------------------------------------------------------
!             Weighted least squares fitting of piecewise
!                    polynomials in two variables
!                          ----------------
!     The piecewise polynomials considered are tensor products of
!     B-splines, having the form
!                          nx   ny
!              F(x,y)  =  Sum  sum  A   U (x) V (y)
!                         I=1  J=1   IJ  I     J
!     where U  and V  are one-dimensional B-spline basis functions.
!            I      J
!-----------------------------------------------------------------------
!     real tx(nx + kx), ty(ny + ky)
!     real wk(l)  where l = nx*my + max((kx+1)*nx,(ky+1)*ny)
!-------------------------
m = nx*my + max((kx + 1)*nx,(ky + 1)*ny)
if (l < m) go to 120
!     Compute the coefficients
iw = nx*my + 1
iq = iw + nx
call bslsq1(x, wx, mx, z, kz, my, tx, nx, kx, &
   & wk, my, wk(iw), wk(iq), ierr)
if (ierr < 0) go to 100
iq = iw + ny
call bslsq1(y, wy, my, wk, my, nx, ty, ny, ky, &
   & a, ka, wk(iw), wk(iq), iflag)
if (iflag < 0) go to 110
iflag = max(ierr,iflag)
return
!     Error return
100 iflag = -1
return
110 iflag = -2
return
120 iflag = -3
wk(1) = m
end subroutine bslsq2

pure subroutine bslsq1(tau, wgt, ntau, z, kz, m, t, n, k, &
   & a, ka, wk, q, ierr)
!! <!-- nswc-ford:begin BSLSQ1 -->
!! Reference for `bslsq1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bslsq1 produces the B-spline coefficients a(j,1),...,a(j,n)
!!      of the piecewise polynomial P(X) of order k with knots t(i)
!!      (i = 1,...,n+k) which minimizes
!!               sum (wgt(l)*(P(tau(l)) - z(l,j))**2)
!!                  l
!!      FOR j = 1,...,m.
!!      Input ...
!!        tau   ARRAY OF LENGTH ntau CONTAINING DATA POINT ABSCISSAE.
!!        wgt   ARRAY OF LENGTH ntau CONTAINING THE WEIGHTS.
!!        ntau  number of data points to be fitted (ntau .GE. n).
!!        z     MATRIX CONTAINING m SETS OF ORDINATES TO BE FITTED.
!!              Each set of ntau ordinates is a column of z.
!!        kz    NUMBER OF ROWS OF z IN THE CALLING PROGRAM.
!!              It is assumed that kz .GE. ntau.
!!        m     NUMBER OF SETS OF ORDINATES TO BE FITTED.
!!        t     KNOT SEQUENCE OF LENGTH n+k.
!!        n     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!!        k     ORDER OF THE B-SPLINES.
!!        ka    NUMBER OF ROWS OF A IN THE CALLING PROGRAM.
!!              It is assumed that ka .GE. m.
!!      Output ...
!!        A     MATRIX CONTAINING THE m SETS OF B-SPLINE COEFFICIENTS
!!              of the L2 approximations. Each set of n coefficients
!!              is a row of A.
!!        ierr  integer reporting the status of the results ...
!!              0  the coefficient matrix is nonsigular. The
!!                 unique least squares solution was obtained.
!!              1  The coefficient matrix is singular. A
!!                 least squares solution was obtained.
!!             -1  Input errors were detected.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: k, ka, kz, m, n, ntau
real, intent(in) :: tau(ntau), wgt(ntau), z(kz,m)
real, intent(in) :: t(*)
real, intent(inout) :: a(ka,n), wk(n), q(k,n)
!     beginning of local variable declarations
integer :: i, j, jj, l, left, leftmk, mm
real :: dw
interface
   pure subroutine bchfac(w,nb,n,diag,iflag)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nb
      real, intent(inout) :: w(nb,n)
      real, intent(inout) :: diag(n)
      integer, intent(inout) :: iflag
   end subroutine bchfac
   pure subroutine bchsv1(w,nb,n,b,kb,m)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: n
      integer, intent(in) :: nb
      real, intent(in) :: w(nb,n)
      real, intent(inout) :: b(kb,n)
      integer, intent(in) :: m
   end subroutine bchsv1
   pure subroutine bspvb(t,k,jhigh,j,x,left,blist)
      implicit none
      integer, intent(in) :: k
      real, intent(in) :: t(*)
      integer, intent(in) :: jhigh
      integer, intent(inout) :: j
      real, intent(in) :: x
      integer, intent(in) :: left
      real, intent(inout) :: blist(k)
   end subroutine bspvb
end interface
!-----------------------------------------------------------------------
!     bslsq1 produces the B-spline coefficients a(j,1),...,a(j,n)
!     of the piecewise polynomial P(X) of order k with knots t(i)
!     (i = 1,...,n+k) which minimizes
!              sum (wgt(l)*(P(tau(l)) - z(l,j))**2)
!                 l
!     FOR j = 1,...,m.
!     Input ...
!       tau   ARRAY OF LENGTH ntau CONTAINING DATA POINT ABSCISSAE.
!       wgt   ARRAY OF LENGTH ntau CONTAINING THE WEIGHTS.
!       ntau  number of data points to be fitted (ntau .GE. n).
!       z     MATRIX CONTAINING m SETS OF ORDINATES TO BE FITTED.
!             Each set of ntau ordinates is a column of z.
!       kz    NUMBER OF ROWS OF z IN THE CALLING PROGRAM.
!             It is assumed that kz .GE. ntau.
!       m     NUMBER OF SETS OF ORDINATES TO BE FITTED.
!       t     KNOT SEQUENCE OF LENGTH n+k.
!       n     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!       k     ORDER OF THE B-SPLINES.
!       ka    NUMBER OF ROWS OF A IN THE CALLING PROGRAM.
!             It is assumed that ka .GE. m.
!     Output ...
!       A     MATRIX CONTAINING THE m SETS OF B-SPLINE COEFFICIENTS
!             of the L2 approximations. Each set of n coefficients
!             is a row of A.
!       ierr  integer reporting the status of the results ...
!             0  the coefficient matrix is nonsigular. The
!                unique least squares solution was obtained.
!             1  The coefficient matrix is singular. A
!                least squares solution was obtained.
!            -1  Input errors were detected.
!-----------------------------------------------------------------------
if (ntau < max(2,k)) go to 100
if (tau(1) < t(k) .or. tau(ntau) > t(n + 1)) go to 100
do i = 2,ntau
   if (tau(i - 1) > tau(i)) go to 100
end do
do j = 1,n
   do i = 1,m
      a(i,j) = 0.0
   end do
end do
do j = 1,n
   do i = 1,k
      q(i,j) = 0.0
   end do
end do
left = k
do l = 1,ntau
!        *** Find the index left such that
!            t(left) .LE. tau(l) .LT. t(left+1)
40 if (left == n) go to 50
   if (tau(l) < t(left + 1)) go to 50
   left = left + 1
   go to 40
50 jj = 0
   call bspvb(t, k, k, jj, tau(l), left, wk)
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
!        Solve the normal equations
call bchfac(q, k, n, wk, ierr)
call bchsv1(q, k, n, a, ka, m)
return
!             Error return
100 ierr = -1
end subroutine bslsq1

pure subroutine bchsv1(w, nb, n, b, kb, m)
!! <!-- nswc-ford:begin BCHSV1 -->
!! Reference for `bchsv1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      bchsv1 solves m linear systems C*X = b  (i = 1,...,m), where
!!                                        i   i
!!      each b  is a vector stored in the i-TH row of a matrix b.
!!            i
!!
!!      Input ...
!!         n   THE ORDER OF THE MATRIX C
!!         nb  the bandwidth of C
!!         w   THE CHOLESKY FACTORIZATION OF THE BANDED SYMMETRIC
!!             positive definite matrix C obtained by the routine
!!             bchfac.
!!         b   MATRIX WHOSE ROWS ARE THE VECTORS TO BE SOLVED FOR
!!             in the m linear systems of equations.
!!         kb  the number of rows of b specified in the calling
!!             program. It is assumed that kb .GE. m.
!!         m   NUMBER OF LINEAR SYSTEMS TO BE SOLVED.
!!      Output ...
!!         b   MATRIX WHOSE ROWS ARE THE SOLUTIONS X  OF THE m
!!             LINEAR SYSTEMS OF EQUATIONS.         i
!!                                        t
!!      note.  The factorization C = L*D*L  is used, where L is A
!!      unit lower triangular matrix and D a diagonal matrix.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: kb, m, n, nb
real, intent(in) :: w(nb,n)
real, intent(inout) :: b(kb,n)
!     beginning of local variable declarations
integer :: i, j, jmax, jpk, k, nbm1
real :: t
!-----------------------------------------------------------------------
!     bchsv1 solves m linear systems C*X = b  (i = 1,...,m), where
!                                       i   i
!     each b  is a vector stored in the i-TH row of a matrix b.
!           i
!                       ------------------
!     Input ...
!        n   THE ORDER OF THE MATRIX C
!        nb  the bandwidth of C
!        w   THE CHOLESKY FACTORIZATION OF THE BANDED SYMMETRIC
!            positive definite matrix C obtained by the routine
!            bchfac.
!        b   MATRIX WHOSE ROWS ARE THE VECTORS TO BE SOLVED FOR
!            in the m linear systems of equations.
!        kb  the number of rows of b specified in the calling
!            program. It is assumed that kb .GE. m.
!        m   NUMBER OF LINEAR SYSTEMS TO BE SOLVED.
!     Output ...
!        b   MATRIX WHOSE ROWS ARE THE SOLUTIONS X  OF THE m
!            LINEAR SYSTEMS OF EQUATIONS.         i
!                                       t
!     note.  The factorization C = L*D*L  is used, where L is A
!     unit lower triangular matrix and D a diagonal matrix.
!-----------------------------------------------------------------------
if (n > 1) go to 20
do i = 1,m
   b(i,1) = b(i,1)*w(1,1)
end do
return
!     Forward substitution. Solve L*Y = b for Y and store Y in b.
20 nbm1 = nb - 1
do k = 1,n
   jmax = min(nbm1,n - k)
   if (jmax < 1) go to 40
   do j = 1,jmax
      jpk = j + k
      t = w(j + 1,k)
      do i = 1,m
         b(i,jpk) = b(i,jpk) - t*b(i,k)
      end do
   end do
40 continue
end do
!                              t     -1
!     backsubstitution. Solve L X = D  Y  for X and store X in b.
k = n
50 t = w(1,k)
do i = 1,m
   b(i,k) = t*b(i,k)
end do
jmax = min(nbm1,n - k)
if (jmax < 1) go to 80
do j = 1,jmax
   jpk = j + k
   t = w(j + 1,k)
   do i = 1,m
      b(i,k) = b(i,k) - t*b(i,jpk)
   end do
end do
80 k = k - 1
if (k > 0) go to 50
end subroutine bchsv1

pure subroutine bval2(a, ka, tx, nx, kx, ty, ny, ky, x0, y0, &
   & idx, idy, f, wk)
!! <!-- nswc-ford:begin BVAL2 -->
!! Reference for `bval2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Evaluation and partial differentiation
!!                       of a piecewise polynomial
!!                             nx   ny
!!                 f(X,Y)  =  Sum  sum  A   U (X) V (Y)
!!                            i=1  j=1   IJ  i     j
!!      where U  and V  are one-dimensional B-spline basis functions.
!!             i      j
!!
!!      real tx(nx + kx), ty(ny + ky), wk(ky + 3*max(kx,ky))
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: idx, idy, ka, kx, ky, nx, ny
real, intent(out) :: f
real, intent(in) :: x0, y0
real, intent(in) :: a(ka,ny), tx(*), ty(*)
real, intent(inout) :: wk(*)
!     beginning of local variable declarations
integer :: i, iw, j, l, m
interface
   pure subroutine bval(t,bcoef,n,k,x,jderiv,w,wk)
      implicit none
      integer, intent(in) :: k
      integer, intent(in) :: n
      real, intent(in) :: t(*)
      real, intent(in) :: bcoef(n)
      real, intent(in) :: x
      integer, intent(in) :: jderiv
      real, intent(inout) :: w
      real, intent(inout) :: wk(k,3)
   end subroutine bval
   pure function intrvl(x,t,m)
      implicit none
      integer, intent(in) :: m
      real, intent(in) :: x
      real, intent(in) :: t(m)
      integer :: intrvl
   end function intrvl
end interface
!-----------------------------------------------------------------------
!                Evaluation and partial differentiation
!                      of a piecewise polynomial
!                            nx   ny
!                f(X,Y)  =  Sum  sum  A   U (X) V (Y)
!                           i=1  j=1   IJ  i     j
!     where U  and V  are one-dimensional B-spline basis functions.
!            i      j
!-----------------------------------------------------------------------
!     real tx(nx + kx), ty(ny + ky), wk(ky + 3*max(kx,ky))
!-----------------------------
f = 0.0
m = nx + kx
if (x0 < tx(1) .or. x0 > tx(m)) return
m = ny + ky
if (y0 < ty(1) .or. y0 > ty(m)) return
iw = ky + 1
j = intrvl(y0, ty, m)
if (j > ky) go to 20
!     Case when  j .LE. ky
do l = 1,j
   call bval(tx, a(1,l), nx, kx, x0, idx, wk(l), wk(iw))
end do
call bval(ty, wk(1), j, ky, y0, idy, f, wk(iw))
return
!     Case when  j .GT. ky
20 l = j - ky
do i = 1,ky
   l = l + 1
   call bval(tx, a(1,l), nx, kx, x0, idx, wk(i), wk(iw))
end do
l = j - ky + 1
call bval(ty(l), wk(1), ky, ky, y0, idy, f, wk(iw))
end subroutine bval2

subroutine trmesh(n,x,y, iadj,iend,ier)
!! <!-- nswc-ford:begin TRMESH -->
!! Reference for `trmesh`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine creates a thiessen triangulation of n
!!  arbitrarily spaced points in the plane referred to as
!!  nodes.  The triangulation is optimal in the sense that it
!!  is as nearly equiangular as possible.  trmesh is part of
!!  an interpolation package which also provides subroutines
!!  to reorder the nodes, add a new node, delete an arc, plot
!!  the mesh, and print the data structure.
!!    Unless the nodes are already ordered in some reasonable
!!  fashion, they should be reordered by subroutine reordr for
!!  increased efficiency before calling trmesh.
!!  INPUT PARAMETERS -     n - NUMBER OF NODES IN THE MESH.
!!                             n .GE. 3.
!!                       x,y - n-vectors of coordinates.
!!                             (x(I),y(I)) defines node I.
!!                      iadj - Vector of length .GE. 6*n-9.
!!                      iend - Vector of length .GE. n.
!!  n, x, and y are not altered by this routine.
!!  Output parameters - iadj - Adjacency lists of neighbors in
!!                             counterclockwise order.  The
!!                             list for node I+1 follows that
!!                             for node I where x and y define
!!                             the order.  The value 0 denotes
!!                             the boundary (or a pseudo-node
!!                             at infinity) and is always the
!!                             last neighbor of a boundary
!!                             node.  iadj is unchanged if ier
!!                             .NE. 0.
!!                      iend - Pointers to the ends of
!!                             adjacency lists (sets of
!!                             neighbors) in iadj.  The
!!                             neighbors of node 1 begin in
!!                             iadj(1).  FOR k .GT. 1, THE
!!                             neighbors of node k begin in
!!                             iadj(iend(k-1)+1) and k has
!!                             iend(k) - iend(k-1) NEIGHBORS
!!                             including (possibly) the
!!                             BOUNDARY.  iadj(iend(k)) .EQ. 0
!!                             IFF node k is on the boundary.
!!                             iend is unchanged if ier = 1.
!!                             If ier = 2 iend contains the
!!                             indices of a sequence of n
!!                             nodes ordered from left to
!!                             right where left and right are
!!                             defined by assuming node 1 is
!!                             to the left of node 2.
!!                       ier - Error indicator
!!                             ier = 0 If no errors were
!!                                     encountered.
!!                             ier = 1 IF n .LT. 3.
!!                             ier = 2 If n .GE. 3 and all
!!                                     nodes are collinear.
!!  Modules referenced by trmesh - shiftd, adnode, trfind,
!!                                 intadd, bdyadd, swptst,
!!                                 swapd, tindx
!!
!!  Local parameters -
!!  nn =          Local copy of n
!!  k =           Node (INDEX) to be inserted into iend
!!  km1 =         k-1 - (variable) length of iend
!!  nl,nr =       iend(1), iend(km1) -- leftmost and rightmost
!!                  nodes in iend as viewed from the right of
!!                  1-2 when iend contains the initial ordered
!!                  set of nodal indices
!!  xl,yl,xr,yr = x AND y COORDINATES OF nl AND nr
!!  dxr,dyr =     xr-xl, yr-yl
!!  xk,yk =       x and y coordinates of node k
!!  dxk,dyk =     xk-xl, yk-yl
!!  cprod =       Vector cross product of nl-nr and nl-k --
!!                  used to determine the position of node k
!!                  with respect to the line defined by the
!!                  nodes in iend
!!  sprod =       Scalar product used to determine the
!!                  interval containing node k when k is on
!!                  the line defined by the nodes in iend
!!  ind,indx =    Indices for iend and iadj, respectively
!!  n0,itemp =    TEMPORARY NODES (INDICES)
!!  ierr =        Dummy parameter for call to adnode
!!  km1d2,KMI,I = km1/2, k-I, do-loop index -- used in iend
!!                  reordering loop
!!  KMIN =        First node index sent to adnode
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(inout) :: iadj(*), iend(n)
integer, intent(out) :: ier
real :: x(n), y(n)
!     beginning of local variable declarations
integer :: nn, k, km1, nl, nr, ind, indx, n0, itemp, ierr, km1d2, &
   & kmi, i, kmin
real :: xl, yl, xr, yr, dxr, dyr, xk, yk, dxk, dyk, cprod, sprod
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine creates a thiessen triangulation of n
! arbitrarily spaced points in the plane referred to as
! nodes.  The triangulation is optimal in the sense that it
! is as nearly equiangular as possible.  trmesh is part of
! an interpolation package which also provides subroutines
! to reorder the nodes, add a new node, delete an arc, plot
! the mesh, and print the data structure.
!   Unless the nodes are already ordered in some reasonable
! fashion, they should be reordered by subroutine reordr for
! increased efficiency before calling trmesh.
! INPUT PARAMETERS -     n - NUMBER OF NODES IN THE MESH.
!                            n .GE. 3.
!                      x,y - n-vectors of coordinates.
!                            (x(I),y(I)) defines node I.
!                     iadj - Vector of length .GE. 6*n-9.
!                     iend - Vector of length .GE. n.
! n, x, and y are not altered by this routine.
! Output parameters - iadj - Adjacency lists of neighbors in
!                            counterclockwise order.  The
!                            list for node I+1 follows that
!                            for node I where x and y define
!                            the order.  The value 0 denotes
!                            the boundary (or a pseudo-node
!                            at infinity) and is always the
!                            last neighbor of a boundary
!                            node.  iadj is unchanged if ier
!                            .NE. 0.
!                     iend - Pointers to the ends of
!                            adjacency lists (sets of
!                            neighbors) in iadj.  The
!                            neighbors of node 1 begin in
!                            iadj(1).  FOR k .GT. 1, THE
!                            neighbors of node k begin in
!                            iadj(iend(k-1)+1) and k has
!                            iend(k) - iend(k-1) NEIGHBORS
!                            including (possibly) the
!                            BOUNDARY.  iadj(iend(k)) .EQ. 0
!                            IFF node k is on the boundary.
!                            iend is unchanged if ier = 1.
!                            If ier = 2 iend contains the
!                            indices of a sequence of n
!                            nodes ordered from left to
!                            right where left and right are
!                            defined by assuming node 1 is
!                            to the left of node 2.
!                      ier - Error indicator
!                            ier = 0 If no errors were
!                                    encountered.
!                            ier = 1 IF n .LT. 3.
!                            ier = 2 If n .GE. 3 and all
!                                    nodes are collinear.
! Modules referenced by trmesh - shiftd, adnode, trfind,
!                                intadd, bdyadd, swptst,
!                                swapd, tindx
!***********************************************************
! Local parameters -
! nn =          Local copy of n
! k =           Node (INDEX) to be inserted into iend
! km1 =         k-1 - (variable) length of iend
! nl,nr =       iend(1), iend(km1) -- leftmost and rightmost
!                 nodes in iend as viewed from the right of
!                 1-2 when iend contains the initial ordered
!                 set of nodal indices
! xl,yl,xr,yr = x AND y COORDINATES OF nl AND nr
! dxr,dyr =     xr-xl, yr-yl
! xk,yk =       x and y coordinates of node k
! dxk,dyk =     xk-xl, yk-yl
! cprod =       Vector cross product of nl-nr and nl-k --
!                 used to determine the position of node k
!                 with respect to the line defined by the
!                 nodes in iend
! sprod =       Scalar product used to determine the
!                 interval containing node k when k is on
!                 the line defined by the nodes in iend
! ind,indx =    Indices for iend and iadj, respectively
! n0,itemp =    TEMPORARY NODES (INDICES)
! ierr =        Dummy parameter for call to adnode
! km1d2,KMI,I = km1/2, k-I, do-loop index -- used in iend
!                 reordering loop
! KMIN =        First node index sent to adnode
nn = n
ier = 1
if (nn < 3) return
ier = 0
! Initialize iend, nl, nr, and k
iend(1) = 1
iend(2) = 2
xl = x(1)
yl = y(1)
xr = x(2)
yr = y(2)
k = 2
! Begin loop on nodes 3,4,...
1 dxr = xr - xl
dyr = yr - yl
! Next loop begins here if nl and nr are unchanged
2 if (k == nn) go to 13
km1 = k
k = km1 + 1
xk = x(k)
yk = y(k)
dxk = xk - xl
dyk = yk - yl
cprod = dxr*dyk - dxk*dyr
if (cprod > 0.) go to 6
if (cprod < 0.) go to 8
! Node k lies on the line containing nodes 1,2,...,k-1.
!   Set sprod to (nl-nr,nl-k).
sprod = dxr*dxk + dyr*dyk
if (sprod > 0.) go to 3
! Node k is to the left of nl.  Insert k as the first
!   (leftmost) node in iend and set nl to k.
call shiftd(1,km1,1, iend)
iend(1) = k
xl = xk
yl = yk
go to 1
! Node k is to the right of nl.  Find the leftmost node
!   n0 which lies to the right of k.
!   Set sprod to (n0-nl,n0-k).
3 do ind = 2,km1
   n0 = iend(ind)
   sprod = (xl - x(n0))*(xk - x(n0)) + &
      & (yl - y(n0))*(yk - y(n0))
   if (sprod >= 0.) go to 5
end do
! Node k is to the right of nr.  Insert k as the last
!   (rightmost) node in iend and set nr to k.
iend(k) = k
xr = xk
yr = yk
go to 1
! Node k lies between iend(ind-1) and iend(ind).  Insert k
!   IN iend.
5 call shiftd(ind,km1,1, iend)
iend(ind) = k
go to 2
! Node k is to the left of nl-nr.  Reorder iend so that nl
!   is the leftmost node as viewed from k.
6 km1d2 = km1/2
do i = 1,km1d2
   kmi = k - i
   itemp = iend(i)
   iend(i) = iend(kmi)
   iend(kmi) = itemp
end do
! Node k is to the right of nl-nr.  Create a triangulation
!   consisting of nodes 1,2,...,k.
8 nl = iend(1)
nr = iend(km1)
! Create the adjacency lists for the first k-1 nodes.
!   Insert neighbors in reverse order.  Each node has four
!   neighbors except nl and nr which have three.
do ind = 1,km1
   n0 = iend(ind)
   indx = 4*n0
   if (n0 >= nl) indx = indx - 1
   if (n0 >= nr) indx = indx - 1
   iadj(indx) = 0
   indx = indx - 1
   if (ind < km1) iadj(indx) = iend(ind + 1)
   if (ind < km1) indx = indx - 1
   iadj(indx) = k
   if (ind == 1) go to 9
   iadj(indx - 1) = iend(ind - 1)
9  continue
end do
! Create the adjacency list for node k
indx = 5*km1 - 1
iadj(indx) = 0
do ind = 1,km1
   indx = indx - 1
   iadj(indx) = iend(ind)
end do
! Replace iend elements with pointers to iadj
indx = 0
do ind = 1,km1
   indx = indx + 4
   if (ind == nl  .or.  ind == nr) indx = indx - 1
   iend(ind) = indx
end do
indx = indx + k
iend(k) = indx
! Add the remaining nodes to the triangulation
if (k == nn) return
kmin = k + 1
do k = kmin,nn
   call adnode(k,x,y, iadj,iend, ierr)
end do
return
! All nodes are collinear
13 ier = 2
end subroutine trmesh

subroutine adnode(kk,x,y, iadj,iend, ier)
!! <!-- nswc-ford:begin ADNODE -->
!! Reference for `adnode`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine adds node kk to a triangulation of a set
!!  of points in the plane producing a new triangulation.  A
!!  sequence of edge swaps is then applied to the mesh,
!!  resulting in an optimal triangulation.  adnode is part
!!  of an interpolation package which also provides routines
!!  to initialize the data structure, plot the mesh, and
!!  delete arcs.
!!  INPUT PARAMETERS -   kk - INDEX OF THE NODE TO BE ADDED
!!                            to the mesh.  kk .GE. 4.
!!                      x,y - Vectors of coordinates of the
!!                            nodes in the mesh.  (x(I),y(I))
!!                            defines node I for I = 1,..,kk.
!!                     iadj - Set of adjacency lists of nodes
!!                            1,..,kk-1.
!!                     iend - Pointers to the ends of
!!                            adjacency lists in iadj for
!!                            each node in the mesh.
!!  iadj and iend may be created by trmesh.
!!  kk, x, and y are not altered by this routine.
!!  Output parameters - iadj,iend - Updated with the addition
!!                                  of node kk as the last
!!                                  entry.
!!                            ier - Error indicator
!!                                  ier = 0 If no errors
!!                                          were encountered.
!!                                  ier = 1 If all nodes
!!                                          (including kk) are
!!                                          collinear.
!!  Modules referenced by adnode - trfind, intadd, bdyadd,
!!                                 shiftd, tindx, swptst,
!!                                 swapd
!!
!!  Local parameters -
!!  k =        Local copy of kk
!!  km1 =      k - 1
!!  i1,i2,i3 = Vertices of a triangle containing k
!!  indkf =    iadj index of the first neighbor of k
!!  indkl =    iadj index of the last neighbor of k
!!  nabor1 =   First neighbor of k before any swaps occur
!!  io1,io2 =  Adjacent neighbors of k defining an arc to
!!               be tested for a swap
!!  IN1 =      Vertex opposite k -- first neighbor of io2
!!               which precedes io1.  IN1,io1,io2 are in
!!               counterclockwise order.
!!  INDK1 =    Index of io1 in the adjacency list for k
!!  IND2F =    Index of the first neighbor of io2
!!  IND21 =    Index of io1 in the adjacency list for io2
!!  xk,yk =    x(k), y(k)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: kk
integer, intent(inout) :: iadj(*), iend(kk)
integer, intent(out) :: ier
real :: x(kk), y(kk)
!     beginning of local variable declarations
logical :: swptst
integer :: tindx
integer :: k, km1, i1, i2, i3, indkf, indkl, nabor1, io1, io2, &
   & in1, indk1, ind2f, ind21
real :: xk, yk
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine adds node kk to a triangulation of a set
! of points in the plane producing a new triangulation.  A
! sequence of edge swaps is then applied to the mesh,
! resulting in an optimal triangulation.  adnode is part
! of an interpolation package which also provides routines
! to initialize the data structure, plot the mesh, and
! delete arcs.
! INPUT PARAMETERS -   kk - INDEX OF THE NODE TO BE ADDED
!                           to the mesh.  kk .GE. 4.
!                     x,y - Vectors of coordinates of the
!                           nodes in the mesh.  (x(I),y(I))
!                           defines node I for I = 1,..,kk.
!                    iadj - Set of adjacency lists of nodes
!                           1,..,kk-1.
!                    iend - Pointers to the ends of
!                           adjacency lists in iadj for
!                           each node in the mesh.
! iadj and iend may be created by trmesh.
! kk, x, and y are not altered by this routine.
! Output parameters - iadj,iend - Updated with the addition
!                                 of node kk as the last
!                                 entry.
!                           ier - Error indicator
!                                 ier = 0 If no errors
!                                         were encountered.
!                                 ier = 1 If all nodes
!                                         (including kk) are
!                                         collinear.
! Modules referenced by adnode - trfind, intadd, bdyadd,
!                                shiftd, tindx, swptst,
!                                swapd
!***********************************************************
! Local parameters -
! k =        Local copy of kk
! km1 =      k - 1
! i1,i2,i3 = Vertices of a triangle containing k
! indkf =    iadj index of the first neighbor of k
! indkl =    iadj index of the last neighbor of k
! nabor1 =   First neighbor of k before any swaps occur
! io1,io2 =  Adjacent neighbors of k defining an arc to
!              be tested for a swap
! IN1 =      Vertex opposite k -- first neighbor of io2
!              which precedes io1.  IN1,io1,io2 are in
!              counterclockwise order.
! INDK1 =    Index of io1 in the adjacency list for k
! IND2F =    Index of the first neighbor of io2
! IND21 =    Index of io1 in the adjacency list for io2
! xk,yk =    x(k), y(k)
ier = 0
k = kk
! Initialization
km1 = k - 1
xk = x(k)
yk = y(k)
! Add node k to the mesh
call trfind(km1,xk,yk,x,y,iadj,iend, i1,i2,i3)
if (i1 == 0) go to 5
if (i3 == 0) call bdyadd(k,i1,i2, iadj,iend)
if (i3 /= 0) call intadd(k,i1,i2,i3, iadj,iend)
! Initialize variables for optimization of the mesh
indkf = iend(km1) + 1
indkl = iend(k)
nabor1 = iadj(indkf)
io2 = nabor1
indk1 = indkf + 1
io1 = iadj(indk1)
! Begin loop -- find the vertex opposite k
1 ind2f = 1
if (io2 /= 1) ind2f = iend(io2 - 1) + 1
ind21 = tindx(io2,io1,iadj,iend)
if (ind2f == ind21) go to 2
in1 = iadj(ind21 - 1)
go to 3
! IN1 is the last neighbor of io2
2 ind21 = iend(io2)
in1 = iadj(ind21)
if (in1 == 0) go to 4
! Swap test -- if a swap occurs, two new arcs are opposite k
!              and must be tested.  INDK1 and indkf must be
!              decremented.
3 if (.not. swptst(in1,k,io1,io2,x,y)) go to 4
call swapd(in1,k,io1,io2, iadj,iend)
io1 = in1
indk1 = indk1 - 1
indkf = indkf - 1
go to 1
! No swap occurred.  Reset io2 and io1, and test for
!   termination.
4 if (io1 == nabor1) return
io2 = io1
indk1 = indk1 + 1
if (indk1 > indkl) indk1 = indkf
io1 = iadj(indk1)
if (io1 /= 0) go to 1
return
! All nodes are collinear
5 ier = 1
end subroutine adnode

pure subroutine bdyadd(kk,i1,i2, iadj,iend)
!! <!-- nswc-ford:begin BDYADD -->
!! Reference for `bdyadd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine adds a boundary node to a triangulation
!!  of a set of kk-1 points in the plane.  iadj and iend are
!!  updated with the insertion of node kk.
!!  INPUT PARAMETERS -   kk - INDEX OF AN EXTERIOR NODE TO BE
!!                            ADDED.  kk .GE. 4.
!!                       i1 - First (rightmost as viewed from
!!                            kk) boundary node in the mesh
!!                            which is visible from kk - The
!!                            line segment kk-i1 intersects
!!                            no arcs.
!!                       i2 - Last (leftmost) boundary node
!!                            which is visible from kk.
!!                     iadj - Set of adjacency lists of nodes
!!                            in the mesh.
!!                     iend - Pointers to the ends of
!!                            adjacency lists in iadj for
!!                            each node in the mesh.
!!    iadj and iend may be created by trmesh and must contain
!!  the vertices i1 and i2.  i1 and i2 may be determined by
!!  trfind.
!!  kk, i1, and i2 are not altered by this routine.
!!  Output parameters - iadj,iend - Updated with the addition
!!                                  of node kk as the last
!!                                  entry.  Node kk will be
!!                                  connected to i1, i2, and
!!                                  all boundary nodes between
!!                                  them.  No optimization of
!!                                  the mesh is performed.
!!  Module referenced by bdyadd - shiftd
!!  intrinsic functions called by bdyadd - MIN0, MAX0
!!
!!  Local parameters -
!!  k =            Local copy of kk
!!  km1 =          k - 1
!!  nright,nleft = Local copies of i1, i2
!!  nf,nl =        Indices of iadj bounding the portion of the
!!                   array to be shifted
!!  n1 =           iadj index of the first neighbor of nleft
!!  n2 =           iadj index of the last neighbor of nright
!!  i =            Do-loop index
!!  imin,imax =    Bounds on do-loop index -- first and last
!!                   elements of iend to be incremented
!!  KEND =         Pointer to the last neighbor of k in iadj
!!  next =         Next boundary node to be connected to kk
!!  INDX =         Index for iadj
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: kk, i1, i2
integer, intent(inout) :: iadj(*), iend(kk)
!     beginning of local variable declarations
integer :: k, km1, nright, nleft, nf, nl, n1, n2, i, imin, imax, &
   & kend, next, indx
interface
   pure subroutine shiftd(nfrst,nlast,kk,iarr)
      implicit none
      integer, intent(in) :: nfrst
      integer, intent(in) :: nlast
      integer, intent(in) :: kk
      integer, intent(inout) :: iarr(*)
   end subroutine shiftd
end interface
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine adds a boundary node to a triangulation
! of a set of kk-1 points in the plane.  iadj and iend are
! updated with the insertion of node kk.
! INPUT PARAMETERS -   kk - INDEX OF AN EXTERIOR NODE TO BE
!                           ADDED.  kk .GE. 4.
!                      i1 - First (rightmost as viewed from
!                           kk) boundary node in the mesh
!                           which is visible from kk - The
!                           line segment kk-i1 intersects
!                           no arcs.
!                      i2 - Last (leftmost) boundary node
!                           which is visible from kk.
!                    iadj - Set of adjacency lists of nodes
!                           in the mesh.
!                    iend - Pointers to the ends of
!                           adjacency lists in iadj for
!                           each node in the mesh.
!   iadj and iend may be created by trmesh and must contain
! the vertices i1 and i2.  i1 and i2 may be determined by
! trfind.
! kk, i1, and i2 are not altered by this routine.
! Output parameters - iadj,iend - Updated with the addition
!                                 of node kk as the last
!                                 entry.  Node kk will be
!                                 connected to i1, i2, and
!                                 all boundary nodes between
!                                 them.  No optimization of
!                                 the mesh is performed.
! Module referenced by bdyadd - shiftd
! intrinsic functions called by bdyadd - MIN0, MAX0
!***********************************************************
! Local parameters -
! k =            Local copy of kk
! km1 =          k - 1
! nright,nleft = Local copies of i1, i2
! nf,nl =        Indices of iadj bounding the portion of the
!                  array to be shifted
! n1 =           iadj index of the first neighbor of nleft
! n2 =           iadj index of the last neighbor of nright
! i =            Do-loop index
! imin,imax =    Bounds on do-loop index -- first and last
!                  elements of iend to be incremented
! KEND =         Pointer to the last neighbor of k in iadj
! next =         Next boundary node to be connected to kk
! INDX =         Index for iadj
k = kk
km1 = k - 1
nright = i1
nleft = i2
! Initialize variables
nl = iend(km1)
n1 = 1
if (nleft /= 1) n1 = iend(nleft - 1) + 1
n2 = iend(nright)
nf = max(n1,n2)
! Insert k as a neighbor of max(nright,nleft)
call shiftd(nf,nl,2, iadj)
iadj(nf + 1) = k
imin = max(nright,nleft)
do i = imin,km1
   iend(i) = iend(i) + 2
end do
! Initialize KEND and insert k as a neighbor of
!   min(nright,nleft)
kend = nl + 3
nl = nf - 1
nf = min(n1,n2)
call shiftd(nf,nl,1, iadj)
iadj(nf) = k
imax = imin - 1
imin = min(nright,nleft)
do i = imin,imax
   iend(i) = iend(i) + 1
end do
! Insert nright as the first neighbor of k
iadj(kend) = nright
! Initialize INDX for loop on boundary nodes between nright
!   AND nleft
indx = iend(nright) - 2
3 next = iadj(indx)
if (next == nleft) go to 4
! Connect next and k
kend = kend + 1
iadj(kend) = next
indx = iend(next)
iadj(indx) = k
indx = indx - 1
go to 3
! Insert nleft and 0 as the last neighbors of k
4 iadj(kend + 1) = nleft
kend = kend + 2
iadj(kend) = 0
iend(k) = kend
end subroutine bdyadd

pure subroutine intadd(kk,i1,i2,i3, iadj,iend)
!! <!-- nswc-ford:begin INTADD -->
!! Reference for `intadd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine adds an interior node to a triangulation
!!  of a set of kk-1 points in the plane.  iadj and iend are
!!  updated with the insertion of node kk in the triangle
!!  whose vertices are i1, i2, and i3.
!!  INPUT PARAMETERS -        kk - INDEX OF NODE TO BE
!!                                 INSERTED.  kk .GE. 4.
!!                      i1,i2,i3 - Indices of the vertices of
!!                                 a triangle containing node
!!                                 kk -- in counterclockwise
!!                                 order.
!!                          iadj - Set of adjacency lists
!!                                 of nodes in the mesh.
!!                          iend - Pointers to the ends of
!!                                 adjacency lists in iadj for
!!                                 each node in the mesh.
!!    iadj and iend may be created by trmesh and must contain
!!  the vertices i1, i2, and i3.  i1,i2,i3 may be determined
!!  BY trfind.
!!  kk, i1, i2, and i3 are not altered by this routine.
!!  Output parameters - iadj,iend - Updated with the addition
!!                                  of node kk as the last
!!                                  entry.  Node kk will be
!!                                  connected to nodes i1, i2,
!!                                  and i3.  No optimization
!!                                  of the mesh is performed.
!!  Module referenced by intadd - shiftd
!!  intrinsic function called by intadd - Mod
!!
!!  Local parameters -
!!  k =           Local copy of kk
!!  km1 =         k - 1
!!  n =           Vector containing i1, i2, i3
!!  nft =         Pointers to the tops of the 3 sets of iadj
!!                  elements to be shifted downward
!!  ip1,ip2,ip3 = Permutation indices for n and nft
!!  indx =        Index for iadj and n
!!  nf,nl =       Indices of first and last entries in iadj
!!                  to be shifted down
!!  n1,N2 =       First 2 vertices of a new triangle --
!!                  (n1,N2,kk)
!!  IMIN,imax =   Bounds on do-loop index -- first and last
!!                  elements of iend to be incremented
!!  I =           Do-loop index
!!  ITEMP =       Temporary storage location
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: kk, i1, i2, i3
integer, intent(inout) :: iadj(*), iend(kk)
!     beginning of local variable declarations
integer :: k, km1, n(3), nft(3), ip1, ip2, ip3, indx, nf, nl, n1, &
   & n2, imin, imax, i, itemp
interface
   pure subroutine shiftd(nfrst,nlast,kk,iarr)
      implicit none
      integer, intent(in) :: nfrst
      integer, intent(in) :: nlast
      integer, intent(in) :: kk
      integer, intent(inout) :: iarr(*)
   end subroutine shiftd
end interface
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine adds an interior node to a triangulation
! of a set of kk-1 points in the plane.  iadj and iend are
! updated with the insertion of node kk in the triangle
! whose vertices are i1, i2, and i3.
! INPUT PARAMETERS -        kk - INDEX OF NODE TO BE
!                                INSERTED.  kk .GE. 4.
!                     i1,i2,i3 - Indices of the vertices of
!                                a triangle containing node
!                                kk -- in counterclockwise
!                                order.
!                         iadj - Set of adjacency lists
!                                of nodes in the mesh.
!                         iend - Pointers to the ends of
!                                adjacency lists in iadj for
!                                each node in the mesh.
!   iadj and iend may be created by trmesh and must contain
! the vertices i1, i2, and i3.  i1,i2,i3 may be determined
! BY trfind.
! kk, i1, i2, and i3 are not altered by this routine.
! Output parameters - iadj,iend - Updated with the addition
!                                 of node kk as the last
!                                 entry.  Node kk will be
!                                 connected to nodes i1, i2,
!                                 and i3.  No optimization
!                                 of the mesh is performed.
! Module referenced by intadd - shiftd
! intrinsic function called by intadd - Mod
!***********************************************************
! Local parameters -
! k =           Local copy of kk
! km1 =         k - 1
! n =           Vector containing i1, i2, i3
! nft =         Pointers to the tops of the 3 sets of iadj
!                 elements to be shifted downward
! ip1,ip2,ip3 = Permutation indices for n and nft
! indx =        Index for iadj and n
! nf,nl =       Indices of first and last entries in iadj
!                 to be shifted down
! n1,N2 =       First 2 vertices of a new triangle --
!                 (n1,N2,kk)
! IMIN,imax =   Bounds on do-loop index -- first and last
!                 elements of iend to be incremented
! I =           Do-loop index
! ITEMP =       Temporary storage location
k = kk
! Initialization
n(1) = i1
n(2) = i2
n(3) = i3
! Set up nft
do i = 1,3
   n1 = n(i)
   indx = mod(i,3) + 1
   n2 = n(indx)
   indx = iend(n1) + 1
! Find the index of N2 as a neighbor of n1
1  indx = indx - 1
   if (iadj(indx) /= n2) go to 1
   nft(i) = indx + 1
end do
! Order the vertices by decreasing magnitude.
!   n(IP(I+1)) precedes n(IP(I)) in iend for
!   i = 1,2.
ip1 = 1
ip2 = 2
ip3 = 3
if (n(2) <= n(1)) go to 3
ip1 = 2
ip2 = 1
3 if (n(3) <= n(ip1)) go to 4
ip3 = ip1
ip1 = 3
4 if (n(ip3) <= n(ip2)) go to 5
itemp = ip2
ip2 = ip3
ip3 = itemp
! Add node k to the adjacency lists of each vertex and
!   update iend.  For each vertex, a set of iadj elements
!   is shifted downward and k is inserted.  Shifting starts
!   at the end of the array.
5 km1 = k - 1
nl = iend(km1)
nf = nft(ip1)
if (nf <= nl) call shiftd(nf,nl,3, iadj)
iadj(nf + 2) = k
imin = n(ip1)
imax = km1
do i = imin,imax
   iend(i) = iend(i) + 3
end do
nl = nf - 1
nf = nft(ip2)
call shiftd(nf,nl,2, iadj)
iadj(nf + 1) = k
imax = imin - 1
imin = n(ip2)
do i = imin,imax
   iend(i) = iend(i) + 2
end do
nl = nf - 1
nf = nft(ip3)
call shiftd(nf,nl,1, iadj)
iadj(nf) = k
imax = imin - 1
imin = n(ip3)
do i = imin,imax
   iend(i) = iend(i) + 1
end do
! Add node k to iend and its neighbors to iadj
indx = iend(km1)
iend(k) = indx + 3
do i = 1,3
   indx = indx + 1
   iadj(indx) = n(i)
end do
end subroutine intadd

pure subroutine shiftd(nfrst,nlast,kk, iarr)
!! <!-- nswc-ford:begin SHIFTD -->
!! Reference for `shiftd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine shifts a set of contiguous elements of an
!!  INTEGER ARRAY kk POSITIONS DOWNWARD (UPWARD IF kk .LT. 0).
!!  The loops are unrolled in order to increase efficiency.
!!  Input parameters - nfrst,nlast - Bounds on the portion of
!!                                   iarr to be shifted.  All
!!                                   elements between and
!!                                   including the bounds are
!!                                   shifted unless nfrst .GT.
!!                                   nlast, in which case no
!!                                   shift occurs.
!!                              kk - Number of positions each
!!                                   element is to be shifted.
!!                                   If kk .LT. 0 shift up.
!!                                   If kk .GT. 0 shift down.
!!                            iarr - Integer array of length
!!                                   .GE. nlast + max(kk,0).
!!  nfrst, nlast, and kk are not altered by this routine.
!!  OUTPUT PARAMETER -        iarr - SHIFTED ARRAY.
!!  Modules referenced by shiftd - None
!!
!!  Local parameters -
!!  inc =  Do-loop increment (unrolling factor) -- if inc is
!!           changed, statements must be added to or deleted
!!           from the do-loops
!!  k =    Local copy of kk
!!  nf =   Local copy of nfrst
!!  nl =   Local copy of nlast
!!  nlp1 = nl + 1
!!  ns =   Number of shifts
!!  nsl =  Number of shifts done in unrolled do-loop (multiple
!!           of inc)
!!  i =    Do-loop index and index for iarr
!!  ibak = Index for downward shift of iarr
!!  indx = Index for iarr
!!  imax = Bound on do-loop index
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nfrst, nlast, kk
integer, intent(inout) :: iarr(*)
!     beginning of local variable declarations
integer :: k, nf, nl, nlp1, ns, nsl, i, ibak, indx, imax
integer, parameter :: inc = 5
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine shifts a set of contiguous elements of an
! INTEGER ARRAY kk POSITIONS DOWNWARD (UPWARD IF kk .LT. 0).
! The loops are unrolled in order to increase efficiency.
! Input parameters - nfrst,nlast - Bounds on the portion of
!                                  iarr to be shifted.  All
!                                  elements between and
!                                  including the bounds are
!                                  shifted unless nfrst .GT.
!                                  nlast, in which case no
!                                  shift occurs.
!                             kk - Number of positions each
!                                  element is to be shifted.
!                                  If kk .LT. 0 shift up.
!                                  If kk .GT. 0 shift down.
!                           iarr - Integer array of length
!                                  .GE. nlast + max(kk,0).
! nfrst, nlast, and kk are not altered by this routine.
! OUTPUT PARAMETER -        iarr - SHIFTED ARRAY.
! Modules referenced by shiftd - None
!***********************************************************
! Local parameters -
! inc =  Do-loop increment (unrolling factor) -- if inc is
!          changed, statements must be added to or deleted
!          from the do-loops
! k =    Local copy of kk
! nf =   Local copy of nfrst
! nl =   Local copy of nlast
! nlp1 = nl + 1
! ns =   Number of shifts
! nsl =  Number of shifts done in unrolled do-loop (multiple
!          of inc)
! i =    Do-loop index and index for iarr
! ibak = Index for downward shift of iarr
! indx = Index for iarr
! imax = Bound on do-loop index
k = kk
nf = nfrst
nl = nlast
if (nf > nl  .or.  k == 0) return
nlp1 = nl + 1
ns = nlp1 - nf
nsl = inc*(ns/inc)
if (k < 0) go to 4
! Shift downward starting from the bottom
if (nsl <= 0) go to 2
do i = 1,nsl,inc
   ibak = nlp1 - i
   indx = ibak + k
   iarr(indx) = iarr(ibak)
   iarr(indx - 1) = iarr(ibak - 1)
   iarr(indx - 2) = iarr(ibak - 2)
   iarr(indx - 3) = iarr(ibak - 3)
   iarr(indx - 4) = iarr(ibak - 4)
end do
! Perform the remaining ns-nsl shifts one at a time
2 ibak = nlp1 - nsl
3 if (ibak <= nf) return
ibak = ibak - 1
indx = ibak + k
iarr(indx) = iarr(ibak)
go to 3
! Shift upward starting from the top
4 if (nsl <= 0) go to 6
imax = nlp1 - inc
do i = nf,imax,inc
   indx = i + k
   iarr(indx) = iarr(i)
   iarr(indx + 1) = iarr(i + 1)
   iarr(indx + 2) = iarr(i + 2)
   iarr(indx + 3) = iarr(i + 3)
   iarr(indx + 4) = iarr(i + 4)
end do
! Perform the remaining ns-nsl shifts one at a time
6 i = nsl + nf
7 if (i > nl) return
indx = i + k
iarr(indx) = iarr(i)
i = i + 1
go to 7
end subroutine shiftd

pure subroutine swapd(nin1,nin2,nout1,nout2, iadj,iend)
!! <!-- nswc-ford:begin SWAPD -->
!! Reference for `swapd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This subroutine swaps the diagonals in a convex quadri-
!!  lateral.
!!  Input parameters -  nin1,nin2,nout1,nout2 - Nodal indices
!!                             of a pair of adjacent triangles
!!                             which form a convex quadrilat-
!!                             eral.  nout1 and nout2 are con-
!!                             nected by an arc which is to be
!!                             replaced by the arc nin1-nin2.
!!                             (nin1,nout1,nout2) must be TRI-
!!                             angle vertices in counterclock-
!!                             wise order.
!!  The above parameters are not altered by this routine.
!!                 iadj,iend - Triangulation data structure
!!                             (see subroutine trmesh).
!!  Output parameters - iadj,iend - Updated with the arc
!!                                  replacement.
!!  Modules referenced by swapd - tindx, shiftd
!!
!!  Local parameters -
!!  in =        nin1 and nin2 ordered by increasing magnitude
!!                (the neighbors of in(1) precede those of
!!                in(2) in iadj)
!!  io =        nout1 and nout2 in increasing order
!!  ip1,ip2 =   Permutation of (1,2) such that io(ip1)
!!                precedes io(ip2) as a neighbor of in(1)
!!  j,k =       Permutation of (1,2) used as indices of in
!!                AND io
!!  nf,nl =     iadj indices boundary a portion of the array
!!                to be shifted
!!  i =         iend INDEX
!!  imin,imax = Bounds on the portion of iend to be INCRE-
!!                mented or decremented
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nin1, nin2, nout1, nout2
integer, intent(inout) :: iadj(*), iend(*)
!     beginning of local variable declarations
integer :: in(2), io(2), ip1, ip2, j, k, nf, nl, i, imin, imax
interface
   pure subroutine shiftd(nfrst,nlast,kk,iarr)
      implicit none
      integer, intent(in) :: nfrst
      integer, intent(in) :: nlast
      integer, intent(in) :: kk
      integer, intent(inout) :: iarr(*)
   end subroutine shiftd
   pure function tindx(nvertx,nabor,iadj,iend)
      implicit none
      integer, intent(in) :: nvertx
      integer, intent(in) :: nabor
      integer, intent(in) :: iadj(*)
      integer, intent(in) :: iend(*)
      integer :: tindx
   end function tindx
end interface
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This subroutine swaps the diagonals in a convex quadri-
! lateral.
! Input parameters -  nin1,nin2,nout1,nout2 - Nodal indices
!                            of a pair of adjacent triangles
!                            which form a convex quadrilat-
!                            eral.  nout1 and nout2 are con-
!                            nected by an arc which is to be
!                            replaced by the arc nin1-nin2.
!                            (nin1,nout1,nout2) must be TRI-
!                            angle vertices in counterclock-
!                            wise order.
! The above parameters are not altered by this routine.
!                iadj,iend - Triangulation data structure
!                            (see subroutine trmesh).
! Output parameters - iadj,iend - Updated with the arc
!                                 replacement.
! Modules referenced by swapd - tindx, shiftd
!***********************************************************
! Local parameters -
! in =        nin1 and nin2 ordered by increasing magnitude
!               (the neighbors of in(1) precede those of
!               in(2) in iadj)
! io =        nout1 and nout2 in increasing order
! ip1,ip2 =   Permutation of (1,2) such that io(ip1)
!               precedes io(ip2) as a neighbor of in(1)
! j,k =       Permutation of (1,2) used as indices of in
!               AND io
! nf,nl =     iadj indices boundary a portion of the array
!               to be shifted
! i =         iend INDEX
! imin,imax = Bounds on the portion of iend to be INCRE-
!               mented or decremented
in(1) = nin1
in(2) = nin2
io(1) = nout1
io(2) = nout2
ip1 = 1
! Order the indices so that in(1) .LT. in(2) and io(1) .LT.
!   io(2), and choose ip1 and ip2 such that (in(1),io(ip1),
!   io(ip2)) forms a triangle.
if (in(1) < in(2)) go to 1
in(1) = in(2)
in(2) = nin1
ip1 = 2
1 if (io(1) < io(2)) go to 2
io(1) = io(2)
io(2) = nout1
ip1 = 3 - ip1
2 ip2 = 3 - ip1
if (io(2) < in(1)) go to 8
if (in(2) < io(1)) go to 12
! in(1) and io(1) precede in(2) and io(2).  For (j,k) =
!   (1,2) and (2,1), delete io(k) as a neighbor of io(j)
!   by shifting a portion of iadj either up or down and
!   and insert in(k) as a neighbor of in(j).
do j = 1,2
   k = 3 - j
   if (in(j) > io(j)) go to 4
!   The neighbors of in(j) precede those of io(j) -- shift
!     down by 1
   nf = 1 + tindx(in(j),io(ip1),iadj,iend)
   nl = -1 + tindx(io(j),io(k),iadj,iend)
   if (nf <= nl) call shiftd(nf,nl,1, iadj)
   iadj(nf) = in(k)
   imin = in(j)
   imax = io(j) - 1
   do i = imin,imax
      iend(i) = iend(i) + 1
   end do
   go to 6
!   The neighbors of io(j) precede those of in(j) -- shift
!     up by 1
4  nf = 1 + tindx(io(j),io(k),iadj,iend)
   nl = -1 + tindx(in(j),io(ip2),iadj,iend)
   if (nf <= nl) call shiftd(nf,nl,-1, iadj)
   iadj(nl) = in(k)
   imin = io(j)
   imax = in(j) - 1
   do i = imin,imax
      iend(i) = iend(i) - 1
   end do
!   REVERSE (ip1,ip2) FOR (j,k) = (2,1)
6  ip1 = ip2
   ip2 = 3 - ip1
end do
return
! The vertices are ordered (io(1),io(2),in(1),in(2)).
!   Delete io(2) by shifting up by 1
8 nf = 1 + tindx(io(1),io(2),iadj,iend)
nl = -1 + tindx(io(2),io(1),iadj,iend)
if (nf <= nl) call shiftd(nf,nl,-1, iadj)
imin = io(1)
imax = io(2) - 1
do i = imin,imax
   iend(i) = iend(i) - 1
end do
!   Delete io(1) by shifting up by 2 and insert in(2)
nf = nl + 2
nl = -1 + tindx(in(1),io(ip2),iadj,iend)
if (nf <= nl) call shiftd(nf,nl,-2, iadj)
iadj(nl - 1) = in(2)
imin = io(2)
imax = in(1) - 1
do i = imin,imax
   iend(i) = iend(i) - 2
end do
!   Shift up by 1 and insert in(1)
nf = nl + 1
nl = -1 + tindx(in(2),io(ip1),iadj,iend)
call shiftd(nf,nl,-1, iadj)
iadj(nl) = in(1)
imin = in(1)
imax = in(2) - 1
do i = imin,imax
   iend(i) = iend(i) - 1
end do
return
! The vertices are ordered (in(1),in(2),io(1),io(2)).
!   Delete io(1) by shifting down by 1
12 nf = 1 + tindx(io(1),io(2),iadj,iend)
nl = -1 + tindx(io(2),io(1),iadj,iend)
if (nf <= nl) call shiftd(nf,nl,1, iadj)
imin = io(1)
imax = io(2) - 1
do i = imin,imax
   iend(i) = iend(i) + 1
end do
!   Delete io(2) by shifting down by 2 and insert in(1)
nl = nf - 2
nf = 1 + tindx(in(2),io(ip2),iadj,iend)
if (nf <= nl) call shiftd(nf,nl,2, iadj)
iadj(nf + 1) = in(1)
imin = in(2)
imax = io(1) - 1
do i = imin,imax
   iend(i) = iend(i) + 2
end do
!   Shift down by 1 and insert in(2)
nl = nf - 1
nf = 1 + tindx(in(1),io(ip1),iadj,iend)
call shiftd(nf,nl,1, iadj)
iadj(nf) = in(2)
imin = in(1)
imax = in(2) - 1
do i = imin,imax
   iend(i) = iend(i) + 1
end do
end subroutine swapd

pure logical function swptst(in1,in2,io1,io2,x,y)
!! <!-- nswc-ford:begin SWPTST -->
!! Reference for `swptst`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This function decides whether or not to replace A
!!  diagonal arc in a quadrilateral with the other diagonal.
!!  The determination is based on the sizes of the angles
!!  contained in the 2 triangles defined by the diagonal.
!!  The diagonal is chosen to maximize the smallest of the
!!  six angles over the two pairs of triangles.
!!  Input parameters -  in1,in2,io1,io2 - Node indices of the
!!                               four points defining the
!!                               quadrilateral.  io1 and io2
!!                               are currently connected by A
!!                               diagonal arc.  This arc
!!                               should be replaced by an arc
!!                               connecting in1, in2 if the
!!                               decision is made to swap.
!!                               in1,io1,io2 must be in
!!                               counterclockwise order.
!!                         x,y - Vectors of nodal coordinates.
!!                               (x(I),y(I)) are the coord-
!!                               INATES OF NODE I FOR I = in1,
!!                               in2, io1, OR io2.
!!  None of the input parameters are altered by this routine.
!!  Output parameter -  swptst - .TRUE. IFF the arc connecting
!!                               io1 and io2 is to be replaced
!!  modules referenced by swptst - None
!!
!!  Local parameters -
!!  dx11,dy11 = x,y coordinates of the vector in1-io1
!!  dx12,dy12 = x,y coordinates of the vector in1-io2
!!  dx22,dy22 = x,y coordinates of the vector in2-io2
!!  dx21,dy21 = x,y coordinates of the vector in2-io1
!!  sin1 =      Cross product of the vectors in1-io1 and
!!                in1-io2 -- proportional to sin(T1) where T1
!!                is the angle at in1 formed by the vectors
!!  cos1 =      Inner product of the vectors in1-io1 and
!!                in1-io2 -- proportional to cos(T1)
!!  SIN2 =      Cross product of the vectors in2-io2 and
!!                in2-io1 -- proportional to sin(T2) where T2
!!                is the angle at in2 formed by the vectors
!!  COS2 =      Inner product of the vectors in2-io2 and
!!                in2-io1 -- proportional to cos(T2)
!!  SIN12 =     sin1*COS2 + cos1*SIN2 -- proportional to
!!                sin(T1+T2)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: in1, in2, io1, io2
real, intent(in) :: x(*), y(*)
!     beginning of local variable declarations
real :: dx11, dx12, dx22, dx21, dy11, dy12, dy22, dy21, sin1, &
   & sin2, cos1, cos2, sin12
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This function decides whether or not to replace A
! diagonal arc in a quadrilateral with the other diagonal.
! The determination is based on the sizes of the angles
! contained in the 2 triangles defined by the diagonal.
! The diagonal is chosen to maximize the smallest of the
! six angles over the two pairs of triangles.
! Input parameters -  in1,in2,io1,io2 - Node indices of the
!                              four points defining the
!                              quadrilateral.  io1 and io2
!                              are currently connected by A
!                              diagonal arc.  This arc
!                              should be replaced by an arc
!                              connecting in1, in2 if the
!                              decision is made to swap.
!                              in1,io1,io2 must be in
!                              counterclockwise order.
!                        x,y - Vectors of nodal coordinates.
!                              (x(I),y(I)) are the coord-
!                              INATES OF NODE I FOR I = in1,
!                              in2, io1, OR io2.
! None of the input parameters are altered by this routine.
! Output parameter -  swptst - .TRUE. IFF the arc connecting
!                              io1 and io2 is to be replaced
! modules referenced by swptst - None
!***********************************************************
! Local parameters -
! dx11,dy11 = x,y coordinates of the vector in1-io1
! dx12,dy12 = x,y coordinates of the vector in1-io2
! dx22,dy22 = x,y coordinates of the vector in2-io2
! dx21,dy21 = x,y coordinates of the vector in2-io1
! sin1 =      Cross product of the vectors in1-io1 and
!               in1-io2 -- proportional to sin(T1) where T1
!               is the angle at in1 formed by the vectors
! cos1 =      Inner product of the vectors in1-io1 and
!               in1-io2 -- proportional to cos(T1)
! SIN2 =      Cross product of the vectors in2-io2 and
!               in2-io1 -- proportional to sin(T2) where T2
!               is the angle at in2 formed by the vectors
! COS2 =      Inner product of the vectors in2-io2 and
!               in2-io1 -- proportional to cos(T2)
! SIN12 =     sin1*COS2 + cos1*SIN2 -- proportional to
!               sin(T1+T2)
swptst = .false.
! Compute the vectors containing the angles T1, T2
dx11 = x(io1) - x(in1)
dx12 = x(io2) - x(in1)
dx22 = x(io2) - x(in2)
dx21 = x(io1) - x(in2)
dy11 = y(io1) - y(in1)
dy12 = y(io2) - y(in1)
dy22 = y(io2) - y(in2)
dy21 = y(io1) - y(in2)
! Compute inner products
cos1 = dx11*dx12 + dy11*dy12
cos2 = dx22*dx21 + dy22*dy21
! The diagonals should be swapped IFF (T1+T2) .GT. 180
!   degrees.  The following two tests insure numerical
!   stability.
if (cos1 >= 0.  .and.  cos2 >= 0.) return
if (cos1 < 0.  .and.  cos2 < 0.) go to 1
! Compute vector cross products
sin1 = dx11*dy12 - dx12*dy11
sin2 = dx22*dy21 - dx21*dy22
sin12 = sin1*cos2 + cos1*sin2
if (sin12 >= 0.) return
1 swptst = .true.
end function swptst

pure integer function tindx(nvertx,nabor,iadj,iend)
!! <!-- nswc-ford:begin TINDX -->
!! Reference for `tindx`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This function returns the index of nabor in the
!!  adjacency list for nvertx.
!!  Input parameters - nvertx - Node whose adjacency list is
!!                              to be searched.
!!                      nabor - Node whose index is to be
!!                              returned.  nabor must be
!!                              connected to nvertx.
!!                       iadj - Set of adjacency lists.
!!                       iend - Pointers to the ends of
!!                              adjacency lists in iadj.
!!  Input parameters are not altered by this function.
!!  Output parameter -  tindx - iadj(tindx) = nabor.
!!  Modules referenced by tindx - None
!!
!!  Local parameters -
!!  nb =   Local copy of nabor
!!  indx = Index for iadj
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nvertx, nabor, iadj(*), iend(*)
!     beginning of local variable declarations
integer :: nb, indx
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This function returns the index of nabor in the
! adjacency list for nvertx.
! Input parameters - nvertx - Node whose adjacency list is
!                             to be searched.
!                     nabor - Node whose index is to be
!                             returned.  nabor must be
!                             connected to nvertx.
!                      iadj - Set of adjacency lists.
!                      iend - Pointers to the ends of
!                             adjacency lists in iadj.
! Input parameters are not altered by this function.
! Output parameter -  tindx - iadj(tindx) = nabor.
! Modules referenced by tindx - None
!***********************************************************
! Local parameters -
! nb =   Local copy of nabor
! indx = Index for iadj
nb = nabor
! Initialization
indx = iend(nvertx) + 1
! Search the list of nvertx neighbors for nb
1 indx = indx - 1
if (iadj(indx) /= nb) go to 1
tindx = indx
end function tindx

subroutine trfind(nst,px,py,x,y,iadj,iend, i1,i2,i3)
!! <!-- nswc-ford:begin TRFIND -->
!! Reference for `trfind`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine locates a point P in a thiessen triangu-
!!  lation, returning the vertex indices of a triangle which
!!  contains P.  trfind is part of an interpolation package
!!  which provides subroutines for creating the mesh.
!!  INPUT PARAMETERS -    nst - INDEX OF NODE AT WHICH trfind
!!                              begins search.  Search time
!!                              depends on the proximity of
!!                              nst TO P.
!!                      px,py - x and y-coordinates of the
!!                              point to be located.
!!                        x,y - Vectors of coordinates of
!!                              nodes in the mesh.  (x(I),y(I))
!!                              defines node I for I = 1,...,N
!!                              WHERE N .GE. 3.
!!                       iadj - Set of adjacency lists of
!!                              nodes in the mesh.
!!                       iend - Pointers to the ends of
!!                              adjacency lists in iadj for
!!                              each node in the mesh.
!!  iadj and iend may be created by trmesh.
!!  Input parameters are not altered by this routine.
!!  Output parameters - i1,i2,i3 - Vertex indices in counter-
!!                                 clockwise order - Vertices
!!                                 of a triangle containing P
!!                                 if P is an interior node.
!!                                 If P is outside of the
!!                                 boundary of the mesh, i1
!!                                 and i2 are the first (right
!!                                 -Most) and last (leftmost)
!!                                 nodes which are visible
!!                                 FROM P, AND i3 = 0.  IF P
!!                                 and all of the nodes lie on
!!                                 a single line then i1 = i2
!!                                 = i3 = 0.
!!  Modules referenced by trfind - None
!!  intrinsic function called by trfind - MAX0
!!
!!  Local parameters -
!!  xp,yp =     Local variables containing px and py
!!  n0,n1,n2 =  Nodes in counterclockwise order defining A
!!                cone (with vertex n0) containing P
!!  n3,n4 =     Nodes opposite n1-n2 and n2-n1, respectively
!!  indx,ind =  Indices for iadj
!!  nf,nl =     First and last neighbors of n0 in iadj, or
!!                first (rightmost) and last (leftmost) nodes
!!                visible from P when P is outside the
!!                boundary
!!  next =      Candidate for i1 or i2 when P is outside of
!!                the boundary
!!  left =      Statement function which computes the sign of
!!                a cross product (Z-COMPONENT).  Left(x1,...,
!!                y0) = .TRUE. IFF (x0,y0) is on or to the
!!                left of the vector from (x1,y1) to (x2,y2).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nst, iadj(*), iend(*)
integer, intent(inout) :: i1, i2, i3
real, intent(in) :: px, py
real :: x(*), y(*)
!     beginning of local variable declarations
real :: x0, x1, x2, y0, y1, y2, xp, yp
integer :: n0, n1, n2, n3, n4, indx, ind, nf, nl, next
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine locates a point P in a thiessen triangu-
! lation, returning the vertex indices of a triangle which
! contains P.  trfind is part of an interpolation package
! which provides subroutines for creating the mesh.
! INPUT PARAMETERS -    nst - INDEX OF NODE AT WHICH trfind
!                             begins search.  Search time
!                             depends on the proximity of
!                             nst TO P.
!                     px,py - x and y-coordinates of the
!                             point to be located.
!                       x,y - Vectors of coordinates of
!                             nodes in the mesh.  (x(I),y(I))
!                             defines node I for I = 1,...,N
!                             WHERE N .GE. 3.
!                      iadj - Set of adjacency lists of
!                             nodes in the mesh.
!                      iend - Pointers to the ends of
!                             adjacency lists in iadj for
!                             each node in the mesh.
! iadj and iend may be created by trmesh.
! Input parameters are not altered by this routine.
! Output parameters - i1,i2,i3 - Vertex indices in counter-
!                                clockwise order - Vertices
!                                of a triangle containing P
!                                if P is an interior node.
!                                If P is outside of the
!                                boundary of the mesh, i1
!                                and i2 are the first (right
!                                -Most) and last (leftmost)
!                                nodes which are visible
!                                FROM P, AND i3 = 0.  IF P
!                                and all of the nodes lie on
!                                a single line then i1 = i2
!                                = i3 = 0.
! Modules referenced by trfind - None
! intrinsic function called by trfind - MAX0
!***********************************************************
! Local parameters -
! xp,yp =     Local variables containing px and py
! n0,n1,n2 =  Nodes in counterclockwise order defining A
!               cone (with vertex n0) containing P
! n3,n4 =     Nodes opposite n1-n2 and n2-n1, respectively
! indx,ind =  Indices for iadj
! nf,nl =     First and last neighbors of n0 in iadj, or
!               first (rightmost) and last (leftmost) nodes
!               visible from P when P is outside the
!               boundary
! next =      Candidate for i1 or i2 when P is outside of
!               the boundary
! left =      Statement function which computes the sign of
!               a cross product (Z-COMPONENT).  Left(x1,...,
!               y0) = .TRUE. IFF (x0,y0) is on or to the
!               left of the vector from (x1,y1) to (x2,y2).
xp = px
yp = py
! Initialize variables and find a cone containing P
n0 = max(nst,1)
1 indx = iend(n0)
nl = iadj(indx)
indx = 1
if (n0 /= 1) indx = iend(n0 - 1) + 1
nf = iadj(indx)
n1 = nf
if (nl /= 0) go to 3
! n0 is a boundary node.  Set nl to the last nonzero
!   neighbor of n0.
ind = iend(n0) - 1
nl = iadj(ind)
if (left(x(n0),y(n0),x(nf),y(nf),xp,yp)) go to 2
! P is outside the boundary
nl = n0
go to 16
2 if (left(x(nl),y(nl),x(n0),y(n0),xp,yp)) go to 4
! P is outside the boundary and n0 is the rightmost
!   visible boundary node
i1 = n0
go to 18
! n0 is an interior node.  Find n1.
3 if (left(x(n0),y(n0),x(n1),y(n1),xp,yp)) go to 4
indx = indx + 1
n1 = iadj(indx)
if (n1 == nl) go to 7
go to 3
! P is to the left of arc n0-n1.  Initialize n2 to the next
!   neighbor of n0.
4 indx = indx + 1
n2 = iadj(indx)
if (.not. left(x(n0),y(n0),x(n2),y(n2),xp,yp)) &
   & go to 8
n1 = n2
if (n1 /= nl) go to 4
if (.not. left(x(n0),y(n0),x(nf),y(nf),xp,yp)) &
   & go to 7
if (xp == x(n0) .and. yp == y(n0)) go to 6
! P is left of or on arcs n0-NB for all neighbors NB
!   OF n0.
! All points are collinear IFF P is left of NB-n0 for
!   all neighbors NB of n0.  Search the neighbors of n0
!   in reverse order.  Note -- n1 = nl and indx points to
!   nl.
5 if (.not. left(x(n1),y(n1),x(n0),y(n0),xp,yp)) &
   & go to 6
if (n1 == nf) go to 20
indx = indx - 1
n1 = iadj(indx)
go to 5
! P is to the right of n1-n0, or P=n0.  Set n0 to n1 and
!   start over.
6 n0 = n1
go to 1
! P is between arcs n0-n1 and n0-nf
7 n2 = nf
! P is contained in a cone defined by line segments n0-n1
!   and n0-n2 where n1 is adjacent to n2
8 n3 = n0
9 if (left(x(n1),y(n1),x(n2),y(n2),xp,yp)) go to 13
! Set n4 to the first neighbor of n2 following n1
indx = iend(n2)
if (iadj(indx) /= n1) go to 10
! n1 is the last neighbor of n2.
! Set n4 to the first neighbor.
indx = 1
if (n2 /= 1) indx = iend(n2 - 1) + 1
n4 = iadj(indx)
go to 11
! n1 is not the last neighbor of n2
10 indx = indx - 1
if (iadj(indx) /= n1) go to 10
n4 = iadj(indx + 1)
if (n4 /= 0) go to 11
! P is outside the boundary
nf = n2
nl = n1
go to 16
! Define a new arc n1-n2 which intersects the line
!   SEGMENT n0-P
11 if (left(x(n0),y(n0),x(n4),y(n4),xp,yp)) go to 12
n3 = n2
n2 = n4
go to 9
12 n3 = n1
n1 = n4
go to 9
! P is in the triangle (n1,n2,n3) and not on n2-n3.  If
!   n3-n1 or n1-n2 is a boundary arc containing P, treat P
!   as exterior.
13 indx = iend(n1)
if (iadj(indx) /= 0) go to 15
! n1 is a boundary node.  n3-n1 is a boundary arc IFF n3
!   is the last nonzero neighbor of n1.
if (n3 /= iadj(indx - 1)) go to 14
! n3-n1 is a boundary arc
if (.not. left(x(n1),y(n1),x(n3),y(n3),xp,yp)) &
   & go to 14
! P lies on n1-n3
i1 = n1
i2 = n3
i3 = 0
return
! n3-n1 is not a boundary arc containing P.  n1-n2 is A
!   boundary arc IFF n2 is the first neighbor of n1.
14 indx = 1
if (n1 /= 1) indx = iend(n1 - 1) + 1
if (n2 /= iadj(indx)) go to 15
! n1-n2 is a boundary arc
if (.not. left(x(n2),y(n2),x(n1),y(n1),xp,yp)) &
   & go to 15
! P lies on n1-n2
i1 = n2
i2 = n1
i3 = 0
return
! P does not lie on a boundary arc.
15 i1 = n1
i2 = n2
i3 = n3
return
! nf and nl are adjacent boundary nodes which are visible
!   from P.  find the first visible boundary node.
! Set next to the first neighbor of nf.
16 indx = 1
if (nf /= 1) indx = iend(nf - 1) + 1
next = iadj(indx)
if (left(x(nf),y(nf),x(next),y(next),xp,yp)) &
   & go to 17
nf = next
go to 16
! nf is the first (rightmost) visible boundary node
17 i1 = nf
! Find the last visible boundary node.  nl is the first
!   candidate for i2.
! Set next to the last neighbor of nl.
18 indx = iend(nl) - 1
next = iadj(indx)
if (left(x(next),y(next),x(nl),y(nl),xp,yp)) &
   & go to 19
nl = next
go to 18
! nl is the last (leftmost) visible boundary node
19 i2 = nl
i3 = 0
return
! All points are collinear
20 i1 = 0
i2 = 0
i3 = 0
contains
   pure function left(x1, y1, x2, y2, x0, y0) result(nswc_sf_result)
      implicit none
      real, intent(in) :: x1
      real, intent(in) :: y1
      real, intent(in) :: x2
      real, intent(in) :: y2
      real, intent(in) :: x0
      real, intent(in) :: y0
      logical :: nswc_sf_result
      nswc_sf_result = (x2 - x1)*(y0 - y1) >=   (x0 - x1)*(y2 - y1)
   end function left
end subroutine trfind

pure subroutine gradg(n, x, y, z, iadj, iend, zxzy, ierr)
!! <!-- nswc-ford:begin GRADG -->
!! Reference for `gradg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       Derivative estimation
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: zxzy(2,n)
integer, intent(in) :: iadj(*), iend(n)
!     beginning of local variable declarations
integer :: j, miter
real :: eps
interface
   pure subroutine gradg1(n,x,y,z,iadj,iend,eps,nit,zxzy,ier)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: x(n)
      real, intent(in) :: y(n)
      real, intent(in) :: z(n)
      integer, intent(in) :: iadj(*)
      integer, intent(in) :: iend(n)
      real, intent(in) :: eps
      integer, intent(inout) :: nit
      real, intent(inout) :: zxzy(2,n)
      integer, intent(inout) :: ier
   end subroutine gradg1
end interface
!-----------------------------------------------------------------------
!                      Derivative estimation
!-----------------------------------------------------------------------
if (n < 3) go to 20
eps = 0.0
miter = 5
do j = 1,n
   zxzy(1,j) = 0.0
   zxzy(2,j) = 0.0
end do
call gradg1(n, x, y, z, iadj, iend, eps, miter, zxzy, ierr)
ierr = 0
return
!     Error return
20 ierr = 1
end subroutine gradg

pure subroutine gradg1(n,x,y,z,iadj,iend,eps, nit, &
   & zxzy, ier)
!! <!-- nswc-ford:begin GRADG1 -->
!! Reference for `gradg1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    Given a triangulation of n nodes in the plane with
!!  associated data values, this routine uses a global method
!!  to compute estimated gradients at the nodes.  The method
!!  consists of minimizing a quadratic functional Q(G) over
!!  the n-vector G of gradients where Q approximates the lin-
!!  earized curvature of an interpolant F over the triangula-
!!  tion.  The restriction of F to an arc of the triangulation
!!  is taken to be the Hermite cubic interpolant of the data
!!  values and tangential gradient components at the end-
!!  points of the arc, and Q is the sum of the linearized
!!  curvatures of F along the arcs -- the integrals over the
!!  arcs of D2F(T)**2 where D2F(T) is the second derivative
!!  of F with respect to distance T along the arc.  This min-
!!  imization problem corresponds to an order 2n symmetric
!!  positive-definite sparse linear system which is solved for
!!  the x and y partial derivatives by the block Gauss-Seidel
!!  method with 2 by 2 blocks.
!!    An alternative method, subroutine gradl, computes A
!!  local approximation to the partials at a single node and
!!  may be more accurate, depending on the data values and
!!  distribution of nodes (neither method emerged as superior
!!  in tests for accuracy).  However, in tests run on an IBM
!!  370, gradg1 was found to be about 3.6 times as fast for
!!  nit = 4.
!!  Input parameters - n - Number of nodes.  n .GE. 3.
!!                   x,y - Cartesian coordinates of the nodes.
!!                     z - Data values at the nodes.  z(I) is
!!                         associated with (x(I),y(I)).
!!             iadj,iend - Data structure defining the trian-
!!                         gulation.  See subroutine trmesh.
!!                   eps - Nonnegative convergence criterion.
!!                         The method is terminated when the
!!                         maximum change in a gradient compo-
!!                         nent between iterations is at most
!!                         eps.  eps = 1.E-2 is sufficient for
!!                         effective convergence.
!!  The above parameters are not altered by this routine.
!!                   nit - Maximum number of Gauss-Seidel
!!                         iterations to be applied.  This
!!                         maximum will likely be achieved if
!!                         eps is smaller than the machine
!!                         precision.  Optimal efficiency was
!!                         achieved in testing with eps = 0
!!                         and nit = 3 Or 4.
!!                  zxzy - 2 By n array whose columns contain
!!                         initial estimates of the partial
!!                         derivatives (zero vectors are
!!                         sufficient).
!!  Output parameters - nit - Number of Gauss-Seidel itera-
!!                            TIONS EMPLOYED.
!!                     zxzy - Estimated x and y partial deriv-
!!                            atives at the nodes with x par-
!!                            tials in the first row.  zxzy is
!!                            not changed if ier = 2.
!!                      ier - Error indicator
!!                            ier = 0 If the convergence CRI-
!!                                    terion was achieved.
!!                            ier = 1 If convergence was not
!!                                    achieved within nit
!!                                    iterations.
!!                            ier = 2 If n or eps is out of
!!                                    range or nit .LT. 0 on
!!                                    input.
!!  Modules referenced by gradg1 - None
!!  intrinsic functions called by gradg1 - Sqrt, AMAX1, abs
!!
!!  Local parameters -
!!  nn =          Local copy of n
!!  maxit =       Input value of nit
!!  iter =        Number of iterations used
!!  k =           Do-loop and node index
!!  indf,indl =   iadj indices of the first and last neighbors
!!                  OF k
!!  indx =        iadj index in the range indf,...,indl
!!  nb =          Neighbor of k
!!  tol =         Local copy of eps
!!  dgmax =       Maximum change in a gradient component be-
!!                  tween iterations
!!  xk,yk,zk =    x(k), y(k), z(k)
!!  zxk,zyk =     Initial values of zxzy(1,k) and zxzy(2,k)
!!  a11,a12,a22 = Matrix components of the 2 by 2 block A*DG
!!                  = R WHERE A IS SYMMETRIC, DG = (DZX,DZY)
!!                  is the change in the gradient at k, and R
!!                  is the residual
!!  r1,r2 =       Components of the residual -- derivatives of
!!                  Q with respect to the components of the
!!                  gradient at node k
!!  DELX,DELY =   Components of the arc nb-k
!!  DELXS,DELYS = DELX**2, DELY**2
!!  DSQ =         Square of the distance D between k and nb
!!  dcub =        d**3
!!  T =           Factor of r1 and r2
!!  DZX,DZY =     Solution of the 2 by 2 system -- change in
!!                  derivatives at k from the previous iterate
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, iadj(*), iend(n)
integer, intent(inout) :: nit, ier
real, intent(in) :: x(n), y(n), z(n), eps
real, intent(inout) :: zxzy(2,n)
!     beginning of local variable declarations
integer :: nn, maxit, iter, k, indf, indl, indx, nb
real :: tol, dgmax, xk, yk, zk, zxk, zyk, a11, a12, a22, r1, r2, &
   & delx, dely, delxs, delys, dsq, dcub, t, dzx, dzy
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given a triangulation of n nodes in the plane with
! associated data values, this routine uses a global method
! to compute estimated gradients at the nodes.  The method
! consists of minimizing a quadratic functional Q(G) over
! the n-vector G of gradients where Q approximates the lin-
! earized curvature of an interpolant F over the triangula-
! tion.  The restriction of F to an arc of the triangulation
! is taken to be the Hermite cubic interpolant of the data
! values and tangential gradient components at the end-
! points of the arc, and Q is the sum of the linearized
! curvatures of F along the arcs -- the integrals over the
! arcs of D2F(T)**2 where D2F(T) is the second derivative
! of F with respect to distance T along the arc.  This min-
! imization problem corresponds to an order 2n symmetric
! positive-definite sparse linear system which is solved for
! the x and y partial derivatives by the block Gauss-Seidel
! method with 2 by 2 blocks.
!   An alternative method, subroutine gradl, computes A
! local approximation to the partials at a single node and
! may be more accurate, depending on the data values and
! distribution of nodes (neither method emerged as superior
! in tests for accuracy).  However, in tests run on an IBM
! 370, gradg1 was found to be about 3.6 times as fast for
! nit = 4.
! Input parameters - n - Number of nodes.  n .GE. 3.
!                  x,y - Cartesian coordinates of the nodes.
!                    z - Data values at the nodes.  z(I) is
!                        associated with (x(I),y(I)).
!            iadj,iend - Data structure defining the trian-
!                        gulation.  See subroutine trmesh.
!                  eps - Nonnegative convergence criterion.
!                        The method is terminated when the
!                        maximum change in a gradient compo-
!                        nent between iterations is at most
!                        eps.  eps = 1.E-2 is sufficient for
!                        effective convergence.
! The above parameters are not altered by this routine.
!                  nit - Maximum number of Gauss-Seidel
!                        iterations to be applied.  This
!                        maximum will likely be achieved if
!                        eps is smaller than the machine
!                        precision.  Optimal efficiency was
!                        achieved in testing with eps = 0
!                        and nit = 3 Or 4.
!                 zxzy - 2 By n array whose columns contain
!                        initial estimates of the partial
!                        derivatives (zero vectors are
!                        sufficient).
! Output parameters - nit - Number of Gauss-Seidel itera-
!                           TIONS EMPLOYED.
!                    zxzy - Estimated x and y partial deriv-
!                           atives at the nodes with x par-
!                           tials in the first row.  zxzy is
!                           not changed if ier = 2.
!                     ier - Error indicator
!                           ier = 0 If the convergence CRI-
!                                   terion was achieved.
!                           ier = 1 If convergence was not
!                                   achieved within nit
!                                   iterations.
!                           ier = 2 If n or eps is out of
!                                   range or nit .LT. 0 on
!                                   input.
! Modules referenced by gradg1 - None
! intrinsic functions called by gradg1 - Sqrt, AMAX1, abs
!***********************************************************
! Local parameters -
! nn =          Local copy of n
! maxit =       Input value of nit
! iter =        Number of iterations used
! k =           Do-loop and node index
! indf,indl =   iadj indices of the first and last neighbors
!                 OF k
! indx =        iadj index in the range indf,...,indl
! nb =          Neighbor of k
! tol =         Local copy of eps
! dgmax =       Maximum change in a gradient component be-
!                 tween iterations
! xk,yk,zk =    x(k), y(k), z(k)
! zxk,zyk =     Initial values of zxzy(1,k) and zxzy(2,k)
! a11,a12,a22 = Matrix components of the 2 by 2 block A*DG
!                 = R WHERE A IS SYMMETRIC, DG = (DZX,DZY)
!                 is the change in the gradient at k, and R
!                 is the residual
! r1,r2 =       Components of the residual -- derivatives of
!                 Q with respect to the components of the
!                 gradient at node k
! DELX,DELY =   Components of the arc nb-k
! DELXS,DELYS = DELX**2, DELY**2
! DSQ =         Square of the distance D between k and nb
! dcub =        d**3
! T =           Factor of r1 and r2
! DZX,DZY =     Solution of the 2 by 2 system -- change in
!                 derivatives at k from the previous iterate
nn = n
tol = eps
maxit = nit
! Error checks and initialization
if (nn < 3  .or.  tol < 0.  .or.  maxit < 0) &
   & go to 5
iter = 0
! Top of iteration loop
1 if (iter == maxit) go to 4
dgmax = 0.
indl = 0
do k = 1,nn
   xk = x(k)
   yk = y(k)
   zk = z(k)
   zxk = zxzy(1,k)
   zyk = zxzy(2,k)
!   Initialize components of the 2 by 2 system
   a11 = 0.
   a12 = 0.
   a22 = 0.
   r1 = 0.
   r2 = 0.
!   Loop on neighbors nb of k
   indf = indl + 1
   indl = iend(k)
   do indx = indf,indl
      nb = iadj(indx)
      if (nb == 0) go to 2
!   Compute the components of arc nb-k
      delx = x(nb) - xk
      dely = y(nb) - yk
      delxs = delx*delx
      delys = dely*dely
      dsq = delxs + delys
      dcub = dsq*sqrt(dsq)
!   Update the system components for node nb
      a11 = a11 + delxs/dcub
      a12 = a12 + delx*dely/dcub
      a22 = a22 + delys/dcub
      t = (1.5*(z(nb) - zk) - ((zxzy(1,nb)/2. + zxk)*delx + &
         & (zxzy(2,nb)/2. + zyk)*dely))/dcub
      r1 = r1 + t*delx
      r2 = r2 + t*dely
2     continue
   end do
!   Solve the 2 by 2 system and update dgmax
   dzy = (a11*r2 - a12*r1)/(a11*a22 - a12*a12)
   dzx = (r1 - a12*dzy)/a11
   dgmax = max(dgmax,abs(dzx),abs(dzy))
!   Update the partials at node k
   zxzy(1,k) = zxk + dzx
   zxzy(2,k) = zyk + dzy
end do
!   Increment iter and test for convergence
iter = iter + 1
if (dgmax > tol) go to 1
! Method converged
nit = iter
ier = 0
return
! Method failed to converge within nit iterations
4 ier = 1
return
! Parameter OUT of range
5 nit = 0
ier = 2
end subroutine gradg1

pure subroutine gradl(n, x, y, z, iadj, iend, zxzy, ierr)
!! <!-- nswc-ford:begin GRADL -->
!! Reference for `gradl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                       Derivative estimation
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: zxzy(2,n)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
!     beginning of local variable declarations
integer :: j
interface
   pure subroutine gradl1(n,k,x,y,z,iadj,iend,dx,dy,ier)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: k
      real, intent(in) :: x(n)
      real, intent(in) :: y(n)
      real, intent(in) :: z(n)
      integer, intent(in) :: iadj(*)
      integer, intent(inout) :: iend(n)
      real, intent(inout) :: dx
      real, intent(inout) :: dy
      integer, intent(inout) :: ier
   end subroutine gradl1
end interface
!-----------------------------------------------------------------------
!                      Derivative estimation
!-----------------------------------------------------------------------
if (n < 3) go to 20
do j = 1,n
   call gradl1(n, j, x, y, z, iadj, iend, zxzy(1,j), &
      & zxzy(2,j), ierr)
   if (ierr < 0) go to 30
end do
ierr = 0
return
!     Error return
20 ierr = 1
return
30 ierr = 2
end subroutine gradl

pure subroutine gradl1(n,k,x,y,z,iadj,iend, dx,dy,ier)
!! <!-- nswc-ford:begin GRADL1 -->
!! Reference for `gradl1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    Given a thiessen triangulation of n points in the plane
!!  with associated data values z, this subroutine estimates
!!  x and y partial derivatives at node k.  the derivatives
!!  are taken to be the partials at k of a quadratic function
!!  which interpolates z(k) and fits the data values at a set
!!  of nearby nodes in a weighted least squares sense. A mar-
!!  quardt stabilization factor is used if necessary to ensure
!!  a well-conditioned system and a linear fitting function is
!!  used if n .LT. 6.  Thus, a unique solution exists unless
!!  the nodes are collinear.
!!    An alternative routine, gradg, employs a global method
!!  to compute the partial derivatives at all of the nodes at
!!  once.  That method is more efficient (when all partials
!!  are needed) and may be more accurate, depending on the
!!  data.
!!  Input parameters - n - Number of nodes in the triangula-
!!                         TION.  n .GE. 3.
!!                     k - Node at which derivatives are
!!                         SOUGHT.  1 .LE. k .LE. n.
!!                   x,y - n-vectors containing the cartesian
!!                         coordinates of the nodes.
!!                     z - n-vector containing the data values
!!                         associated with the nodes.
!!                  iadj - Set of adjacency lists.
!!                  iend - Pointers to the ends of adjacency
!!                         lists for each node.
!!  iadj and iend may be created by subroutine trmesh.
!!  Input parameters are not altered by this routine.
!!  Output parameters - dx,dy - Estimated partial derivatives
!!                              at node k unless ier .LT. 0.
!!                        ier - Error indicator
!!                              ier .GT. 0 if no errors were
!!                                       encountered.  Ier
!!                                       contains the number
!!                                       of nodes (including
!!                                       k) used in the fit.
!!                                       ier = 3, 4, or 5 im-
!!                                       plies a linear fit.
!!                              ier = -1 If n or k is out of
!!                                       range.
!!                              ier = -2 If all nodes are
!!                                       collinear.
!!  Modules referenced by gradl1 - getnp, setrm, srotg, srot
!!  intrinsic functions called by gradl1 - MIN0, float, sqrt,
!!                                        AMIN1, ABS
!!
!!  Local parameters -
!!  nn,kk =     Local copies of n and k
!!  lmn,lmx =   Minimum and maximum values of lnp for n
!!                sufficiently large.  In most cases lmn-1
!!                nodes are used in the fit.  4 .LE. lmn .LE.
!!                lmx.
!!  lmin,lmax = min(lmn,n), min(lmx,n)
!!  lm1 =       lmin-1 OR lnp-1
!!  lnp =       Length of npts
!!  npts =      Array containing the indices of a sequence of
!!                nodes ordered by distance from k.  npts(1)=k
!!                and the first lnp-1 elements of npts are
!!                used in the least squares fit.  Unless lnp
!!                exceeds lmax, npts(lnp) determines r.
!!  ierr =      Error flag for calls to getnp (not checked)
!!  NP =        Element of npts to be added to the system
!!  I,J =       Do-loop indices
!!  IM1,JP1 =   I-1, J+1
!!  ip1 =       i+1
!!  L =         Number of columns of a**T to which a rotation
!!                is applied
!!  sum =       sum of squared Euclidean distances between
!!                node k and the nodes used in the least
!!                squares fit
!!  ds =        Squared distance between node k and an ele-
!!                MENT OF npts
!!  r =         Distance between node k and npts(lnp) or some
!!                point further from k than npts(lmax) if
!!                npts(lmax) is used in the fit.  r is A
!!                radius of influence which enters into the
!!                weights (see subroutine setrm).
!!  rs =        r*r
!!  rtol =      Tolerance for determining r.  if the relative
!!                change in ds between two elements of npts is
!!                not greater than rtol they are treated as
!!                being the same distance from node k
!!  avsq =      av*av
!!  av =        Root-mean-square distance between k and the
!!                nodes (other than k) in the least squares
!!                fit.  The first 3 columns of the system are
!!                scaled by 1/avsq, the next 2 by 1/av.
!!  xk,yk,zk =  Coordinates and data value associated with k
!!  a =         Transpose of the augmented regression matrix
!!  c,s =       Components of the plane rotation determined
!!                by subroutine srotg
!!  DMIN =      Minimum of the magnitudes of the diagonal
!!                elements of the regression matrix after
!!                zeros are introduced below the diagonal
!!  DTOL =      Tolerance for detecting an ill-conditioned
!!                system.  The system is accepted when DMIN
!!                .GE. DTOL
!!  SF =        Marquardt stabilization factor used to damp
!!                out the first 3 solution components (second
!!                partials of the quadratic) when the system
!!                is ill-conditioned.  As SF increases, the
!!                fitting function approaches a linear
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, k, iadj(*)
integer, intent(inout) :: iend(n), ier
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: dx, dy
!     beginning of local variable declarations
integer :: nn, kk, lmin, lmax, lm1, lnp, npts(30), ierr, np, i, j, im1, jp1, ip1, l
real :: sum, ds, r, rs, avsq, av, xk, yk, zk, a(6,6), c, s, dmin
integer, parameter :: lmn = 10
integer, parameter :: lmx = 30
real, parameter :: rtol = 1.e-5
real, parameter :: dtol = .01
real, parameter :: sf = 1.
interface
   pure subroutine getnp(x,y,iadj,iend,l,npts,ds,ier)
      implicit none
      integer, intent(in) :: l
      real, intent(in) :: x(*)
      real, intent(in) :: y(*)
      integer, intent(in) :: iadj(*)
      integer, intent(inout) :: iend(*)
      integer, intent(inout) :: npts(l)
      real, intent(inout) :: ds
      integer, intent(inout) :: ier
   end subroutine getnp
   pure subroutine setrm(xk,yk,zk,xi,yi,zi,s1,s2,r,row)
      implicit none
      real, intent(in) :: xk
      real, intent(in) :: yk
      real, intent(in) :: zk
      real, intent(in) :: xi
      real, intent(in) :: yi
      real, intent(in) :: zi
      real, intent(in) :: s1
      real, intent(in) :: s2
      real, intent(in) :: r
      real, intent(inout) :: row(6)
   end subroutine setrm
   pure subroutine srot(n,sx,incx,sy,incy,c,s)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
      real, intent(in) :: c
      real, intent(in) :: s
   end subroutine srot
   pure elemental subroutine srotg(sa,sb,sc,ss)
      implicit none
      real, intent(inout) :: sa
      real, intent(inout) :: sb
      real, intent(inout) :: sc
      real, intent(inout) :: ss
   end subroutine srotg
end interface
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given a thiessen triangulation of n points in the plane
! with associated data values z, this subroutine estimates
! x and y partial derivatives at node k.  the derivatives
! are taken to be the partials at k of a quadratic function
! which interpolates z(k) and fits the data values at a set
! of nearby nodes in a weighted least squares sense. A mar-
! quardt stabilization factor is used if necessary to ensure
! a well-conditioned system and a linear fitting function is
! used if n .LT. 6.  Thus, a unique solution exists unless
! the nodes are collinear.
!   An alternative routine, gradg, employs a global method
! to compute the partial derivatives at all of the nodes at
! once.  That method is more efficient (when all partials
! are needed) and may be more accurate, depending on the
! data.
! Input parameters - n - Number of nodes in the triangula-
!                        TION.  n .GE. 3.
!                    k - Node at which derivatives are
!                        SOUGHT.  1 .LE. k .LE. n.
!                  x,y - n-vectors containing the cartesian
!                        coordinates of the nodes.
!                    z - n-vector containing the data values
!                        associated with the nodes.
!                 iadj - Set of adjacency lists.
!                 iend - Pointers to the ends of adjacency
!                        lists for each node.
! iadj and iend may be created by subroutine trmesh.
! Input parameters are not altered by this routine.
! Output parameters - dx,dy - Estimated partial derivatives
!                             at node k unless ier .LT. 0.
!                       ier - Error indicator
!                             ier .GT. 0 if no errors were
!                                      encountered.  Ier
!                                      contains the number
!                                      of nodes (including
!                                      k) used in the fit.
!                                      ier = 3, 4, or 5 im-
!                                      plies a linear fit.
!                             ier = -1 If n or k is out of
!                                      range.
!                             ier = -2 If all nodes are
!                                      collinear.
! Modules referenced by gradl1 - getnp, setrm, srotg, srot
! intrinsic functions called by gradl1 - MIN0, float, sqrt,
!                                       AMIN1, ABS
!***********************************************************
! Local parameters -
! nn,kk =     Local copies of n and k
! lmn,lmx =   Minimum and maximum values of lnp for n
!               sufficiently large.  In most cases lmn-1
!               nodes are used in the fit.  4 .LE. lmn .LE.
!               lmx.
! lmin,lmax = min(lmn,n), min(lmx,n)
! lm1 =       lmin-1 OR lnp-1
! lnp =       Length of npts
! npts =      Array containing the indices of a sequence of
!               nodes ordered by distance from k.  npts(1)=k
!               and the first lnp-1 elements of npts are
!               used in the least squares fit.  Unless lnp
!               exceeds lmax, npts(lnp) determines r.
! ierr =      Error flag for calls to getnp (not checked)
! NP =        Element of npts to be added to the system
! I,J =       Do-loop indices
! IM1,JP1 =   I-1, J+1
! ip1 =       i+1
! L =         Number of columns of a**T to which a rotation
!               is applied
! sum =       sum of squared Euclidean distances between
!               node k and the nodes used in the least
!               squares fit
! ds =        Squared distance between node k and an ele-
!               MENT OF npts
! r =         Distance between node k and npts(lnp) or some
!               point further from k than npts(lmax) if
!               npts(lmax) is used in the fit.  r is A
!               radius of influence which enters into the
!               weights (see subroutine setrm).
! rs =        r*r
! rtol =      Tolerance for determining r.  if the relative
!               change in ds between two elements of npts is
!               not greater than rtol they are treated as
!               being the same distance from node k
! avsq =      av*av
! av =        Root-mean-square distance between k and the
!               nodes (other than k) in the least squares
!               fit.  The first 3 columns of the system are
!               scaled by 1/avsq, the next 2 by 1/av.
! xk,yk,zk =  Coordinates and data value associated with k
! a =         Transpose of the augmented regression matrix
! c,s =       Components of the plane rotation determined
!               by subroutine srotg
! DMIN =      Minimum of the magnitudes of the diagonal
!               elements of the regression matrix after
!               zeros are introduced below the diagonal
! DTOL =      Tolerance for detecting an ill-conditioned
!               system.  The system is accepted when DMIN
!               .GE. DTOL
! SF =        Marquardt stabilization factor used to damp
!               out the first 3 solution components (second
!               partials of the quadratic) when the system
!               is ill-conditioned.  As SF increases, the
!               fitting function approaches a linear
nn = n
kk = k
! Check for errors and initialize lmin, lmax
if (nn < 3  .or.  kk < 1  .or.  kk > nn) &
   & go to 16
lmin = min(lmn,nn)
lmax = min(lmx,nn)
! Compute npts, lnp, avsq, av, and r.
!   Set npts to the closest lmin-1 nodes to k.
sum = 0.
npts(1) = kk
lm1 = lmin - 1
do lnp = 2,lm1
   call getnp(x,y,iadj,iend,lnp, npts, ds,ierr)
   sum = sum + ds
end do
! Add additional nodes to npts until the relative increase
!   in ds is at least rtol.
do lnp = lmin,lmax
   call getnp(x,y,iadj,iend,lnp, npts, rs,ierr)
   if ((rs - ds)/ds <= rtol) go to 2
   if (lnp > 6) go to 3
2  sum = sum + rs
end do
! Use all lmax nodes in the least squares fit.  rs is
!   arbitrarily increased by 10 per cent.
rs = 1.1*rs
lnp = lmax + 1
! There are lnp-2 equations corresponding to nodes npts(2),
!   ...,npts(lnp-1).
3 avsq = sum/float(lnp - 2)
av = sqrt(avsq)
r = sqrt(rs)
xk = x(kk)
yk = y(kk)
zk = z(kk)
if (lnp < 7) go to 12
! Set up the first 5 equations of the augmented regression
!   matrix (transposed) as the columns of A, and zero out
!   the lower triangle (upper triangle of A) with Givens
!   rotations
do i = 1,5
   np = npts(i + 1)
   call setrm(xk,yk,zk,x(np),y(np),z(np),av,avsq, &
      & r, a(1,i))
   if (i == 1) go to 5
   im1 = i - 1
   do j = 1,im1
      jp1 = j + 1
      l = 6 - j
      call srotg(a(j,j),a(j,i),c,s)
      call srot(l,a(jp1,j),1,a(jp1,i),1,c,s)
   end do
5  continue
end do
! Add the additional equations to the system using
!   the last column of a -- I .LE. lnp.
i = 7
6 if (i == lnp) go to 8
np = npts(i)
call setrm(xk,yk,zk,x(np),y(np),z(np),av,avsq, &
   & r, a(1,6))
do j = 1,5
   jp1 = j + 1
   l = 6 - j
   call srotg(a(j,j),a(j,6),c,s)
   call srot(l,a(jp1,j),1,a(jp1,6),1,c,s)
end do
i = i + 1
go to 6
! Test the system for ill-conditioning
8 dmin = min(abs(a(1,1)),abs(a(2,2)),abs(a(3,3)), &
   & abs(a(4,4)),abs(a(5,5)))
if (dmin >= dtol) go to 15
if (lnp > lmax) go to 9
! Add another node to the system and increase r --
!   I .EQ. lnp
lnp = lnp + 1
if (lnp <= lmax) call getnp(x,y,iadj,iend,lnp, &
   & npts, rs,ierr)
r = sqrt(1.1*rs)
go to 6
! Stabilize the system by damping second partials --add
!   multiples of the first three unit vectors to the first
!   three equations.
9 do i = 1,3
   a(i,6) = sf
   ip1 = i + 1
   do j = ip1,6
      a(j,6) = 0.
   end do
   do j = i,5
      jp1 = j + 1
      l = 6 - j
      call srotg(a(j,j),a(j,6),c,s)
      call srot(l,a(jp1,j),1,a(jp1,6),1,c,s)
   end do
end do
go to 14
! 4 .LE. lnp .LE. 6 (2, 3, OR 4 EQUATIONS) -- fit a plane to
!   the data using the last 3 columns of A.
12 np = npts(2)
call setrm(xk,yk,zk,x(np),y(np),z(np),av,avsq, &
   & r, a(1,4))
np = npts(3)
call setrm(xk,yk,zk,x(np),y(np),z(np),av,avsq, &
   & r, a(1,5))
call srotg(a(4,4),a(4,5),c,s)
call srot(2,a(5,4),1,a(5,5),1,c,s)
if (lnp == 4) go to 14
lm1 = lnp - 1
do i = 4,lm1
   np = npts(i)
   call setrm(xk,yk,zk,x(np),y(np),z(np),av,avsq, &
      & r, a(1,6))
   call srotg(a(4,4),a(4,6),c,s)
   call srot(2,a(5,4),1,a(5,6),1,c,s)
   call srotg(a(5,5),a(5,6),c,s)
   call srot(1,a(6,5),1,a(6,6),1,c,s)
end do
! Test the linear fit for ill-conditioning
14 dmin = min(abs(a(4,4)),abs(a(5,5)))
if (dmin < dtol) go to 17
! Solve the 2 by 2 triangular system for the derivatives
15 dy = a(6,5)/a(5,5)
dx = (a(6,4) - a(5,4)*dy)/a(4,4)/av
dy = dy/av
ier = lnp - 1
return
! n or k is out of range
16 ier = -1
return
! No unique solution due to collinear nodes
17 ier = -2
end subroutine gradl1

pure subroutine setrm(xk,yk,zk,xi,yi,zi,s1,s2,r, row)
!! <!-- nswc-ford:begin SETRM -->
!! Reference for `setrm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    This routine sets up the i-TH row of an augmented RE-
!!  gression matrix for a weighted least-squares fit of A
!!  quadratic function Q(X,Y) to a set of data values Z where
!!  Q(xk,yk) = zk.  The first 3 columns (quadratic terms) are
!!  scaled by 1/s2 and the fourth and fifth columns (linear
!!  terms) are scaled by 1/s1.  The weight is (r-d)/(r*d) if
!!  r .GT. d and 0 if r .LE. d, where d is the distance
!!  between nodes i and K.
!!  Input parameters - xk,yk,zk - Coordinates and data value
!!                                at node K -- interpolated
!!                                BY Q.
!!                     xi,yi,zi - Coordinates and data value
!!                                at node i.
!!                        s1,s2 - Inverse scale factors.
!!                            r - Radius of influence about
!!                                node K defining the weight.
!!                          row - Vector of length 6.
!!  Input parameters are not altered by this routine.
!!  Output parameter - row - Vector containing a row of the
!!                           augmented regression matrix.
!!  Modules referenced by setrm - None
!!  intrinsic function called by setrm - Sqrt
!!
!!  Local parameters -
!!  i =    Do-loop index
!!  dx =   xi - xk
!!  dy =   yi - yk
!!  dxsq = dx*dx
!!  dysq = dy*dy
!!  d =    Distance between nodes K and i
!!  w =    Weight associated with the row
!!  w1 =   w/s1
!!  w2 =   w/s2
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: xk, yk, zk, xi, yi, zi, s1, s2, r
real, intent(inout) :: row(6)
!     beginning of local variable declarations
integer :: i
real :: dx, dy, dxsq, dysq, d, w, w1, w2
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   This routine sets up the i-TH row of an augmented RE-
! gression matrix for a weighted least-squares fit of A
! quadratic function Q(X,Y) to a set of data values Z where
! Q(xk,yk) = zk.  The first 3 columns (quadratic terms) are
! scaled by 1/s2 and the fourth and fifth columns (linear
! terms) are scaled by 1/s1.  The weight is (r-d)/(r*d) if
! r .GT. d and 0 if r .LE. d, where d is the distance
! between nodes i and K.
! Input parameters - xk,yk,zk - Coordinates and data value
!                               at node K -- interpolated
!                               BY Q.
!                    xi,yi,zi - Coordinates and data value
!                               at node i.
!                       s1,s2 - Inverse scale factors.
!                           r - Radius of influence about
!                               node K defining the weight.
!                         row - Vector of length 6.
! Input parameters are not altered by this routine.
! Output parameter - row - Vector containing a row of the
!                          augmented regression matrix.
! Modules referenced by setrm - None
! intrinsic function called by setrm - Sqrt
!***********************************************************
! Local parameters -
! i =    Do-loop index
! dx =   xi - xk
! dy =   yi - yk
! dxsq = dx*dx
! dysq = dy*dy
! d =    Distance between nodes K and i
! w =    Weight associated with the row
! w1 =   w/s1
! w2 =   w/s2
dx = xi - xk
dy = yi - yk
dxsq = dx*dx
dysq = dy*dy
d = sqrt(dxsq + dysq)
if (d <= 0.  .or.  d >= r) go to 1
w = (r - d)/r/d
w1 = w/s1
w2 = w/s2
row(1) = dxsq*w2
row(2) = dx*dy*w2
row(3) = dysq*w2
row(4) = dx*w1
row(5) = dy*w1
row(6) = (zi - zk)*w
return
! Nodes K and i coincide or node i is outside of the radius
!   of influence.  Set row to the zero vector.
1 do i = 1,6
   row(i) = 0.
end do
end subroutine setrm

