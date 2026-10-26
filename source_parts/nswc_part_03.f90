subroutine ckps(z, r, zr, nu, w1, w2)
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex :: nu
complex, intent(inout) :: w1, w2
integer :: k
real :: ak, eps, eps0, phi, s, u, x, y
real :: anorm
complex :: a, c, ch, cl, f, g1, g2, gm1, gm2, mu, p, q, sh, t, t1, &
   & t2
real, parameter :: tol = 1.e-10
real, parameter :: pi = 3.14159265358979
real, parameter :: d(7) = [.577215664901533e+00, -.420026350340952e-01, -.421977345555443e-01, .721894324666310e-02, - &
   & .215241674114951e-03, -.201348547807882e-04, .113302723198170e-05]
interface
   pure elemental function cdiv(a,b)
      implicit none
      complex, intent(in) :: a
      complex, intent(in) :: b
      complex :: cdiv
   end function cdiv
   pure elemental function cgam0(z)
      implicit none
      complex, intent(in) :: z
      complex :: cgam0
   end function cgam0
   pure elemental subroutine cgamma(mo,z,w)
      implicit none
      integer, intent(in) :: mo
      complex, intent(in) :: z
      complex, intent(inout) :: w
   end subroutine cgamma
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!        Calculation of the modified Bessel functions
!
!                  w1 = k  (z)  AND  w2 = k    (z)
!                        nu                nu+1
!
!     For a complex argument z where abs(z) .LE. 2 and a complex
!     order nu where abs(real(nu)) .LE. 0.5.  It is assumed that
!     -pi .LT. arg z .LE. pi, r = abs(z/2), and zr = 2/z.  power
!     series expansions are used.
!
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
!-----------------------
anorm(t) = max(abs(real(t)), abs(aimag(t)))
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
!
!                     cl = - ln(z/2)
!
phi = atan2(aimag(z),real(z))
cl = cmplx(-log(r), -phi)
mu = nu*cl
c = exp(mu)
!
!                   g1 = gamma(1 + nu)
!                   g2 = gamma(1 - nu)
!
t = pi*nu
if (anorm(nu) > tol) go to 10
a = 1.0 + (t*t)/6.0
go to 20
10 a = t/sin(t)
!
20 s = real(nu)**2 + aimag(nu)**2
if (s >= 1.0) go to 21
t = cgam0(nu)
g1 = 1.0/t
g2 = a*t
go to 30
21 t = 0.5 + (0.5 + nu)
call cgamma(0, t, g1)
g2 = cdiv(a,g1)
!
30 gm2 = 0.5*(g1 + g2)
if (s > 0.04) go to 31
!
!         The following is the Taylor series for
!     w1 = (1/g2 - 1/g1)/(2*nu). Note that g1*g2 = a.
!
t = nu*nu
w1 = -((((((d(7)*t + d(6))*t + d(5))*t + d(4))*t + &
   & d(3))*t + d(2))*t + d(1))
gm1 = a*w1
go to 40
31 gm1 = 0.5*(g1 - g2)/nu
!
!            Initialization of the summation
!
40 p = 0.5*c*g1
q = 0.5*cdiv(g2,c)
x = real(mu)
y = aimag(mu)
if (anorm(mu) > tol) go to 50
u = x*y
sh = cmplx(1.0, u/3.0)
ch = cmplx(1.0, u)
go to 60
50 t = cmplx (-y, x)
sh = sin(t)/t
ch = cos(t)
!
60 f = gm1*ch + gm2*cl*sh
c = (1.0, 0.0)
w1 = f
w2 = p
!
!                 Summation of series
!
t = 0.25*(z*z)
do k = 1, 50
   ak = k
   f = (ak*f + p + q)/((ak - nu)*(ak + nu))
   p = p/(ak - nu)
   q = q/(ak + nu)
   c = c*t/ak
   t1 = c*f
   w1 = w1 + t1
   t2 = c*(p - ak*f)
   w2 = w2 + t2
   if (anorm(t1) <= eps0*anorm(w1)) go to 80
end do
!
80 w2 = w2 * zr
return
end subroutine ckps

pure elemental subroutine cbkml(z, r, zr, nu, n, w, w0)
implicit none
integer, intent(in) :: n
real, intent(in) :: r
complex, intent(in) :: z, zr, nu
complex, intent(inout) :: w, w0
integer :: i, m, num
real :: a, b, c, e, eps, eps0, f, rnu, t, th, x, y, inu, l
complex :: al, bl, s, u1, u2, u3
real, parameter :: c1 = 1.25331413731559e+00
real, parameter :: c2 = 1.77245385090552e+00
interface
   pure elemental function cos1(x)
      implicit none
      real, intent(in) :: x
      real :: cos1
   end function cos1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!             Computation of the scaled Bessel function
!
!                   w = (exp(z)*sqrt(z)) k  (z)
!                                         nu
!     and the value
!
!                   w0 = k    (z) /k  (z)
!                         nu+1      nu
!
!     For complex orders nu and nu + 1 and for complex argument z
!     by use of the Miller algorithm. For the greatest accuracy,
!     z should lie in a sector slightly larger than the right half
!     plane. It is assumed that abs(real(nu)) .LT. 0.5, and that
!     r = abs(z/2) AND zr = 2/z.
!
!-----------------------------------------------------------------------
!---------------------
!     c1 = sqrt(pi/2)
!     c2 = sqrt(pi)
!---------------------
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
!
x = real(z)
y = aimag(z)
rnu = real(nu)
inu = aimag(nu)
!
!     Calculation of m for use in Miller algorithm.
!
th = atan2(y,x)
a = 3.0/(1.0 + r)
b = 14.7/(28.0 + r)
f = (2.0*r)**(0.25)
if (rnu == 0.5 .and. inu /= 0.0) go to 10
c = 4.0*cos1(rnu)/(c1*eps0*f)
go to 20
10 c = 4.0*c2/f
20 m = (0.485/r)*(log(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
   & (2.0*cos(b*th))**2 + 1.5
t = 0.0
if (r > 22.5) t = 0.01*(r - 22.5)**2
num = 35.0 + 0.8*(r - 22.5) + t
if (inu /= 0.0) m = m + num
c = n
if (c + rnu < 0.327*abs(inu)) m = m + 10
!
!     Backward recurrence in Miller algorithm.
!
a = (0.5 - rnu)*(0.5 + rnu) + inu*inu
e = 2.0*rnu*inu
u2 = (0.0, 0.0)
u1 = (1.0, 0.0)
s = u1
l = m
do 30 i = 2, m
   u3 = u2
   u2 = u1
   c = a/l + (l - 1.0)
   al = cmplx(c, - e/l)
   bl = 2.0*(l + z)
   u1 = (bl*u2 - (l + 1.0)*u3)/al
   s = s + u1
   c = abs(real(u1)) + abs(aimag(u1))
   if (i == m .or. c < 1.e+8) go to 30
!
!           Rescale to avoid overflow
!
   u2 = u2/c
   u1 = u1/c
   s = s/c
!
30 l = l - 1.0
!
!     Last step in the Miller algorithm.
!
if (c < 2.0) go to 40
u2 = u2/c
u1 = u1/c
s = s/c
40 u3 = u2
u2 = u1
al = cmplx(0.5*a, - 0.5*e)
bl = 1.0 + z
u1 = (bl*u2 - u3)/al
s = s + u1
!
!     Final assembly
!
w = c1*(u1/s)
w0 = 1.0 + 0.5*(nu + 0.5 - u2/u1)*zr
return
end subroutine cbkml

subroutine cbsslk(z, r, w)
implicit none
real, intent(in) :: r
complex :: z
complex, intent(inout) :: w
integer :: i, ind, m, n, n1
real :: a, ai, rz, t, x, y, znorm, zr1, zr2, nu, nu1
complex :: cn, cz, ex, u1, u2, u3, w1, w2, zr
real, parameter :: pi = 3.14159265358979
real, parameter :: cpi = 1.25331413731550
interface
   pure elemental subroutine ckm(z,r,zr,nu,w1,w2)
      implicit none
      complex, intent(in) :: z
      real, intent(in) :: r
      complex, intent(in) :: zr
      real, intent(in) :: nu
      complex, intent(inout) :: w1
      complex, intent(inout) :: w2
   end subroutine ckm
   pure elemental subroutine ckml(z,r,zr,nu,k1,k2)
      implicit none
      complex, intent(in) :: z
      real, intent(in) :: r
      complex, intent(in) :: zr
      real, intent(in) :: nu
      complex, intent(inout) :: k1
      complex, intent(inout) :: k2
   end subroutine ckml
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
   pure elemental function cxp(n,nu)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: nu
      complex :: cxp
   end function cxp
end interface
!-----------------------------------------------------------------------
!
!         Calculation of the modified Bessel function of the
!         second kind for real order r and complex argument z.
!         It is assumed that -pi .LT. arg z .LE. pi.
!
!-----------------------------------------------------------------------
!     Written by
!         Andrew H. van Tuyl
!         Naval Surface Warfare Center
!     modified by A.H. Morris (NSWC)
!     revised ... oct 1992
!---------------------------
!---------------------------
!     cpi = sqrt(pi/2)
!---------------------------
!
rz = cpabs(real(z), aimag(z))
!
!     Asymptotic expansion
!
if (rz < 17.5 + 0.5*r*r) go to 5
call cka(z, r, w)
return
!
!          Reduction of r to the range -0.5 .LT. nu .LE. 0.5
!
5 a = abs(r)
n = a
nu = a - float(n)
t = nu - 0.5
if (t <= 0.0) go to 10
nu = t - 0.5
n = n + 1
10 m = n
nu1 = nu
!
ind = 1
cz = z
x = 0.5*real(z)
y = 0.5*aimag(z)
call crec(x, y, zr1, zr2)
zr = cmplx (zr1, zr2)
if (t /= 0.0) go to 20
!
!               Calculation for nu = 0.5
!
w = cmplx(cpi, 0.0)
if (n == 0) go to 90
if (x >= 0.0) go to 15
ind = -1
cz = - z
zr = - zr
15 u1 = w
u2 = w
n = n + 1
nu = - 0.5
go to 70
!
!           Calculation for abs(nu) .LT. 0.5
!
20 znorm = 0.5*rz
if (znorm > 1.0) go to 30
ind = 0
call ckm(z, znorm, zr, nu, u1, u2)
go to 50
30 if (x < 0.0) go to 40
call ckml(z, znorm, zr, nu, u1, u2)
go to 50
40 ind = -1
cz = - z
zr = - zr
call ckml(cz, znorm, zr, nu, u1, u2)
!
50 if (n > 1) go to 70
w = u1
if (n /= 0) w = u2
go to 90
!
!                 Recursion
!
70 n1 = n - 1
do i = 1, n1
   ai = i
   u3 = (nu + ai)*zr*u2 + u1
   u1 = u2
   u2 = u3
end do
w = u3
!
90 if (ind == 0) return
w = w*exp(-cz)/sqrt(cz)
if (ind > 0) return
!
!            Analytic continuation
!
ex = cxp(m, nu1)
cn = cmplx (a, 0.0)
if (y < 0.0) go to 100
w1 = cmplx (aimag(z), -real(z))
call cbsslj(w1, cn, w2)
w2 = cmplx (pi*aimag(w2), -pi*real(w2))
w = ex*(ex*w + w2)
return
100 ex = conjg(ex)
w1 = cmplx (-aimag(z), real(z))
call cbsslj(w1, cn, w2)
w2 = cmplx (-pi*aimag(w2), pi*real(w2))
w = ex*(ex*w + w2)
return
end subroutine cbsslk

subroutine cka(z, nu, w)
implicit none
complex :: z
complex, intent(inout) :: w
real, intent(in) :: nu
integer :: i
real :: a, eps, u, v
real :: anorm
real :: m
complex :: p, t, zr
real, parameter :: c = 1.77245385090552
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!        Computation of the Bessel function K for real order nu
!        and complex argument z by the asymptotic expansion
!-----------------------------------------------------------------------
!--------------------------
anorm(z) = max(abs(real(z)), abs(aimag(z)))
!--------------------------
!     c = pi**(1/2)
!--------------------------
!--------------------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0 .
!
eps = spmpar(1)
!
!--------------------------
call crec(real(z), aimag(z), u, v)
zr = cmplx(0.5*u, 0.5*v)
a = nu*nu - 0.25
m = 1.0
t = a*zr
p = t
!
do i = 1, 16
   a = a - 2.0*m
   m = m + 1.0
   t = (a/m)*t*zr
   p = p + t
   if (anorm(t) <= eps*anorm(p)) go to 20
end do
!
20 p = p + 1.0
t = sqrt(zr)
if (aimag(z) == 0.0) t = conjg(t)
w = c*t*p*exp(-z)
return
end subroutine cka

pure elemental subroutine ckm(z, r, zr, nu, w1, w2)
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex, intent(inout) :: w1, w2
real, intent(in) :: nu
integer :: k
real :: a, ak, eps, eps0, g1, g2, gm1, gm2, phi, t, x, y
real :: anorm
complex :: c, ch, cl, f, mu, p, q, sh, t1, t2, w
real, parameter :: tol = 1.e-10
real, parameter :: pi = 3.14159265358979
real, parameter :: d(7) = [.577215664901533e+00, -.420026350340952e-01, -.421977345555443e-01, .721894324666310e-02, - &
   & .215241674114951e-03, -.201348547807882e-04, .113302723198170e-05]
interface
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!        Calculation of the modified Bessel functions
!
!                  w1 = k  (z)  AND  w2 = k    (z)
!                        nu                nu+1
!
!     For a complex argument z where abs(z) .LE. 2  and a real
!     order nu where abs(nu) .LE. 0.5.  It is assumed that
!     -pi .LT. arg z .LE. pi, r = abs(z/2), and zr = 2/z. power
!     series expansions are used.
!
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
!-----------------------
anorm(w) = max(abs(real(w)), abs(aimag(w)))
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
!
!                     cl = - ln(z/2)
!
phi = atan2(aimag(z),real(z))
cl = cmplx(-log(r), -phi)
mu = nu*cl
c = exp(mu)
!
!                   g1 = gamma(1 + nu)
!                   g2 = gamma(1 - nu)
!
t = pi*nu
if (abs(nu) > tol) go to 10
a = 1.0 + (t*t)/6.0
go to 20
10 a = t/sin(t)
!
20 t = 0.5 + (0.5 + gam1(nu))
g1 = 1.0/t
g2 = a*t
gm2 = 0.5*(g1 + g2)
if (abs(nu) > 0.2) go to 30
!
!         The following is the Taylor series for
!     t = (1/g2 - 1/g1)/(2*nu). Note that g1*g2 = a.
!
t = nu*nu
t = -((((((d(7)*t + d(6))*t + d(5))*t + d(4))*t + &
   & d(3))*t + d(2))*t + d(1))
gm1 = a*t
go to 40
30 gm1 = 0.5*(g1 - g2)/nu
!
!            Initialization of the summation
!
40 p = (0.5*g1)*c
q = (0.5*g2)/c
x = real(mu)
y = aimag(mu)
if (anorm(mu) > tol) go to 50
t = x*y
sh = cmplx(1.0, t/3.0)
ch = cmplx(1.0, t)
go to 60
50 w = cmplx (-y, x)
sh = sin(w)/w
ch = cos(w)
!
60 f = gm1*ch + gm2*cl*sh
c = (1.0, 0.0)
w1 = f
w2 = p
!
!                 Summation of series
!
w = 0.25*(z*z)
do k = 1, 50
   ak = k
   f = (ak*f + p + q)/((ak - nu)*(ak + nu))
   p = p/(ak - nu)
   q = q/(ak + nu)
   c = c*w/ak
   t1 = c*f
   w1 = w1 + t1
   t2 = c*(p - ak*f)
   w2 = w2 + t2
   if (anorm(t1) <= eps0*anorm(w1)) go to 80
end do
!
80 w2 = w2 * zr
return
end subroutine ckm

pure elemental subroutine ckml(z, r, zr, nu, k1, k2)
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex, intent(inout) :: k1, k2
real, intent(in) :: nu
integer :: i, m
real :: a, al, b, c, e, eps, eps0, th, x, y, l, nu2
complex :: bl, s, u1, u2, u3
real, parameter :: c1 = 1.25331413731559
interface
   pure elemental function cos1(x)
      implicit none
      real, intent(in) :: x
      real :: cos1
   end function cos1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!             Computation of the scaled Bessel functions
!
!                   k1 = (exp(z)*sqrt(z)) k  (z)
!                                          nu
!                   k2 = (exp(z)*sqrt(z)) k    (z)
!                                          nu+1
!
!     For real orders nu and nu + 1 and for complex argument z
!     by use of the Miller algorithm. For the greatest accuracy,
!     z should lie in a sector slightly larger than the right
!     half plane. It is assumed that abs(nu) .LT. 0.5, and that
!     r = abs(z/2) AND zr = 2/z.
!
!-----------------------------------------------------------------------
!---------------------
!     c1 = sqrt(pi/2)
!---------------------
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
x = real(z)
y = aimag(z)
nu2 = nu*nu
!
!     Calculation of m for use in Miller algorithm.
!
th = atan2(y,x)
a = 3.0/(1.0 + r)
b = 14.7/(28.0 + r)
c = 4.0*cos1(nu)/(c1*eps0*(2.0*r)**(0.25))
m = (0.485/r)*(log(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
   & (2.0*cos(b*th))**2 + 1.5
!
!     Backward recurrence in Miller algorithm.
!
u2 = (0.0, 0.0)
u1 = (1.0, 0.0)
s = u1
l = m
do 10 i = 2, m
   u3 = u2
   u2 = u1
   e = l - 0.5
   al = (e*e - nu2)/(l*(l + 1.0))
   bl = (2.0/(l + 1.0))*(l + z)
   u1 = (bl*u2 - u3)/al
   s = s + u1
   c = abs(real(u1)) + abs(aimag(u1))
   if (i == m .or. c < 1.e+6) go to 10
!
!           Rescale to avoid overflow
!
   u2 = u2/c
   u1 = u1/c
   s = s/c
!
10 l = l - 1.0
!
!     Last step in the Miller algorithm.
!
if (c < 2.0) go to 20
u2 = u2/c
u1 = u1/c
s = s/c
20 u3 = u2
u2 = u1
al = 0.5*(0.5 - nu)*(0.5 + nu)
bl = 1.0 + z
u1 = (bl*u2 - u3)/al
s = s + u1
!
!     Final assembly
!
k1 = c1*(u1/s)
k2 = k1*(1.0 + 0.5*(nu + 0.5 - u2/u1)*zr)
return
end subroutine ckml

pure elemental complex function cxp(n, nu)
implicit none
integer, intent(in) :: n
real, intent(in) :: nu
integer :: k
real :: c, s
interface
   pure elemental function cos0(x)
      implicit none
      real, intent(in) :: x
      real :: cos0
   end function cos0
   pure elemental function sin0(x)
      implicit none
      real, intent(in) :: x
      real :: sin0
   end function sin0
end interface
!-----------------------------------------------------------------------
!                 Computation of exp(-R*(pi/2)*I)
!              where R = n + nu for abs(nu) .LE. 0.5
!-----------------------------------------------------------------------
!
c = cos0(nu)
s = sin0(nu)
k = mod(n,4)
if (k == 0) go to 10
if (k == 1) go to 20
if (k == 2) go to 30
go to 40
!
10 cxp = cmplx (c, -s)
return
!
20 cxp = cmplx (-s, -c)
return
!
30 cxp = cmplx (-c, s)
return
!
40 cxp = cmplx (s, c)
return
end function cxp

pure elemental subroutine bsslk(mo, a, in, w)
implicit none
integer, intent(in) :: in, mo
complex, intent(in) :: a
complex, intent(inout) :: w
integer :: i, la, lk, lr, m, n
real :: an, aq(2), az(2), pm, pn, qf(2), qm, qn, rm, rn, rz(2), sl(2), sm(2), sn, sq(2), sr(2), ss, sz(2), tm(2), ts(2), zl(2), zs
real, parameter :: cd(30) = [0.00000000000000e00, -1.64899505142212e-2, -7.18621880068536e-2, -1.67086878124866e-1, - &
   & 3.02582250219469e-1, -4.80613945245927e-1, -7.07075239357898e-1, -9.92995790539516e-1, -1.35583925612592e00, - &
   & 1.82105907899132e00, -2.42482175310879e00, -3.21956655708750e00, -4.28658077248384e00, -5.77022816798128e00, - &
   & 8.01371260952526e00, 0.00000000000000e00, -5.57742429879505e-3, -4.99112944172476e-2, -1.37440911652397e-1, - &
   & 2.67233784710566e-1, -4.40380166808682e-1, -6.61813614872541e-1, -9.41861077665017e-1, -1.29754130468326e00, - &
   & 1.75407696719816e00, -2.34755299882276e00, -3.13041332689196e00, -4.18397120563729e00, -5.65251799214994e00, - &
   & 7.87863959810677e00]
real, parameter :: ce(30) = [0.00000000000000e00, -4.80942336387447e-3, -1.31366200347759e-2, -1.94843834008458e-2, - &
   & 2.19948900032003e-2, -2.09396625676519e-2, -1.74600268458650e-2, -1.27937813362085e-2, -8.05234421796592e-3, - &
   & 4.15817375002760e-3, -1.64317738747922e-3, -4.49175585314709e-4, -7.28594765574007e-5, -5.38265230658285e-6, - &
   & 9.93779048036289e-8, 0.00000000000000e00, 7.53805779200591e-2, 7.12293537403464e-2, 6.33116224228200e-2, 5.28240264523301e-2, &
   & 4.13305359441492e-2, 3.01350573947510e-2, 2.01043439592720e-2, 1.18552223068074e-2, 5.86055510956010e-3, 2.25465148267325e-3, &
   & 6.08173041536336e-4, 9.84215550625747e-5, 7.32139093038089e-6, 1.37279667384666e-7]
!     ******************************************************************
!     Fortran subroutine for modified Bessel function of integral order
!     ******************************************************************
!     mo = Mode of operation
!     a  = ARGUMENT (COMPLEX NUMBER)
!     in = order (integer)
!     w  = Function of second kind (complex number)
!     -------------------
!     -------------------
az(1) = real(a)
az(2) = aimag(a)
zs = az(1)*az(1) + az(2)*az(2)
zl(1) = 0.5*log(zs)
zl(2) = atan2(az(2),az(1))
an = abs(in)
tm(1) = 0.0
tm(2) = 0.0
if (mo /= 0) go to 002
tm(1) = az(1)
tm(2) = az(2)
002 if (zs - 1.0) 020,020,003
003 if (zs - 289.0) 004,010,010
004 if (az(1) + 0.096*az(2)*az(2)) 020,020,015
010 qm = 1.25331413731550*exp(-0.5*zl(1) - tm(1))
qf(1) = qm*cos(-0.5*zl(2) - tm(2))
qf(2) = qm*sin(-0.5*zl(2) - tm(2))
if (an > 1.0) go to 012
pn = an
assign 011 to la
go to 100
011 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
012 pn = 1.0
assign 013 to la
go to 100
013 sq(1) = qf(1)*sm(1) - qf(2)*sm(2)
sq(2) = qf(1)*sm(2) + qf(2)*sm(1)
pn = 0.0
assign 014 to la
go to 100
014 sr(1) = qf(1)*sm(1) - qf(2)*sm(2)
sr(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 026
015 qm = 1.25331413731550*exp(-0.5*zl(1) - tm(1))
qf(1) = qm*cos(-0.5*zl(2) - tm(2))
qf(2) = qm*sin(-0.5*zl(2) - tm(2))
if (an > 1.0) go to 017
pn = an
assign 016 to lr
go to 104
016 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
017 pn = 1.0
assign 018 to lr
go to 104
018 sq(1) = qf(1)*sm(1) - qf(2)*sm(2)
sq(2) = qf(1)*sm(2) + qf(2)*sm(1)
pn = 0.0
assign 019 to lr
go to 104
019 sr(1) = qf(1)*sm(1) - qf(2)*sm(2)
sr(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 026
020 qf(1) = 1.0
qf(2) = 0.0
if (mo == 0) go to 021
qm = exp(az(1))
qf(1) = qm*cos(az(2))
qf(2) = qm*sin(az(2))
021 if (an > 1.0) go to 023
pn = an
assign 022 to lk
go to 106
022 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
023 pn = 1.0
assign 024 to lk
go to 106
024 sq(1) = qf(1)*sm(1) - qf(2)*sm(2)
sq(2) = qf(1)*sm(2) + qf(2)*sm(1)
pn = 0.0
assign 025 to lk
go to 106
025 sr(1) = qf(1)*sm(1) - qf(2)*sm(2)
sr(2) = qf(1)*sm(2) + qf(2)*sm(1)
026 rz(1) = az(1)/zs
rz(2) = -az(2)/zs
pn = 0.0
go to 028
027 sq(1) = sr(1)
sq(2) = sr(2)
sr(1) = sm(1)
sr(2) = sm(2)
028 sm(1) = 2.0*pn*(rz(1)*sr(1) - rz(2)*sr(2)) + sq(1)
sm(2) = 2.0*pn*(rz(1)*sr(2) + rz(2)*sr(1)) + sq(2)
pn = pn + 1.0
if (pn < an) go to 027
029 w = cmplx(sm(1),sm(2))
return
100 sm(1) = 0.0
sm(2) = 0.0
rz(1) = 0.5*az(1)/zs
rz(2) = -0.5*az(2)/zs
qn = (pn - 0.5)*(pn + 0.5)
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
go to 102
101 qn = qn - 2.0*pm
pm = pm + 1.0
ts(1) = rz(1)*tm(1) - rz(2)*tm(2)
ts(2) = rz(1)*tm(2) + rz(2)*tm(1)
tm(1) = qn*ts(1)/pm
tm(2) = qn*ts(2)/pm
if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 102
if (abs(sm(2)) + abs(tm(2)) == abs(sm(2))) go to 103
102 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (pm < 36.0) go to 101
103 go to la,(011,013,014)
104 sm(1) = 1.0
sm(2) = 0.0
m = 15.0*pn + 2.0
n = 15.0*pn + 15.0
do 105 i = m,n
   ts(1) = az(1) - cd(i)
   ts(2) = az(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
105 continue
go to lr,(016,018,019)
106 aq(1) = 1.0
aq(2) = 0.0
rn = 0.0
sn = -1.0
pm = 0.0
go to 108
107 pm = pm + 1.0
rn = rn + 0.5/pm
sn = -sn
ts(1) = 0.5*(az(1)*aq(1) - az(2)*aq(2))
ts(2) = 0.5*(az(1)*aq(2) + az(2)*aq(1))
aq(1) = ts(1)/pm
aq(2) = ts(2)/pm
108 if (pm < pn) go to 107
sz(1) = 0.25*(az(1) - az(2))*(az(1) + az(2))
sz(2) = 0.5*az(1)*az(2)
sr(1) = 0.0
sr(2) = 0.0
ss = aq(1)*aq(1) + aq(2)*aq(2)
tm(1) = aq(1)/ss
tm(2) = -aq(2)/ss
pm = 0.0
go to 110
109 tm(1) = tm(1)/(pn - pm)
tm(2) = tm(2)/(pn - pm)
sr(1) = sr(1) + 0.5*tm(1)
sr(2) = sr(2) + 0.5*tm(2)
pm = pm + 1.0
ts(1) = sz(1)*tm(1) - sz(2)*tm(2)
ts(2) = sz(1)*tm(2) + sz(2)*tm(1)
tm(1) = -ts(1)/pm
tm(2) = -ts(2)/pm
110 if (pm < pn) go to 109
sm(1) = 0.0
sm(2) = 0.0
rm = 1.0
qm = 0.0
aq(1) = sn*aq(1)
aq(2) = sn*aq(2)
sl(1) = -0.115931515658412 + zl(1) - rn
sl(2) = zl(2)
pm = 0.0
go to 112
111 qm = qm + rm
pm = pm + 1.0
rm = 0.25*zs*rm/(pm*(pn + pm))
ts(1) = sz(1)*aq(1) - sz(2)*aq(2)
ts(2) = sz(1)*aq(2) + sz(2)*aq(1)
aq(1) = ts(1)/(pm*(pn + pm))
aq(2) = ts(2)/(pm*(pn + pm))
sl(1) = sl(1) - 0.5/pm - 0.5/(pn + pm)
112 tm(1) = aq(1)*sl(1) - aq(2)*sl(2)
tm(2) = aq(1)*sl(2) + aq(2)*sl(1)
sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (qm + rm > qm) go to 111
sm(1) = sr(1) + sm(1)
sm(2) = sr(2) + sm(2)
go to lk,(022,024,025)
end subroutine bsslk

subroutine cai(ind,z,ai,aip,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: ai
complex, intent(inout) :: aip
real :: a, b, r
complex :: bi, bip
interface
   pure elemental subroutine aia(ind,z,ai,aip,ierr)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: ai
      complex, intent(inout) :: aip
      integer, intent(out) :: ierr
   end subroutine aia
   pure elemental subroutine airm(ind,z,ai,aip,bi,bip)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: ai
      complex, intent(inout) :: aip
      complex, intent(inout) :: bi
      complex, intent(inout) :: bip
   end subroutine airm
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!------------------------------------------------------------
!     Calculates the Airy function ai and its derivative aip
!     for complex argument z.
!------------------------------------------------------------
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a,b)
if (r > 1.0) go to 10
!
!     Maclaurin expansion
!
call airm(ind,z,ai,aip,bi,bip)
return
10 if (r > 10.0) go to 20
!
!     Intermediate range calculation
!
call aii(ind,z,ai,aip,ierr)
return
!
!     Asymptotic expansion
!
20 call aia(ind,z,ai,aip,ierr)
return
end subroutine cai

pure elemental subroutine airm(ind,z,ai,aip,bi,bip)
implicit none
integer, intent(in) :: ind
complex, intent(inout) :: ai, aip, bi, bip
complex, intent(in) :: z
integer :: i, n
real :: x, y
complex :: z1, z2, z3, zz, f, f1, g, g1, e, e1
real, parameter :: c1 = 3.55028053887817e-01
real, parameter :: c2 = 2.58819403792807e-01
real, parameter :: sqt3 = 1.73205080756888e+00
real, parameter :: a(8) = [.166666666666667e+00, .555555555555556e-02, .771604938271605e-04, .584549195660307e-06, &
   & .278356759838241e-08, .909662613850462e-11, .216586336631062e-13, .392366551867867e-16]
real, parameter :: b(8) = [.833333333333333e-01, .198412698412698e-02, .220458553791887e-04, .141319585764030e-06, &
   & .588831607350126e-09, .172172984605300e-11, .372668797846970e-14, .621114663078283e-17]
real, parameter :: c(8) = [.333333333333333e-01, .694444444444444e-03, .701459034792368e-05, .417535139757362e-07, &
   & .163739270493083e-09, .454831306925231e-12, .941679724482880e-15, .150910212256872e-17]
real, parameter :: d(8) = [.333333333333333e+00, .138888888888889e-01, .220458553791887e-03, .183715461493239e-05, &
   & .942130571760201e-08, .327128670750070e-10, .819871355263333e-13, .155278665769571e-15]
!--------------------------------------------------------------
!     Calculates the Airy functions ai and bi and their
!     derivatives aip and bip by use of their Maclaurin
!     expansions.
!--------------------------------------------------------------
!-----------------------
!     c1 = 3**(-2/3)/gamma(2/3)
!     c2 = 3**(-1/3)/gamma(1/3)
!-----------------------
!-----------------------
!-----------------------
z2 = z*z
z3 = z*z2
!
!     Summation of f and g
!
f = cmplx(a(8),0.0)
g = cmplx(b(8),0.0)
do 10 n = 1, 7
   i = 8 - n
   f = a(i) + z3*f
   g = b(i) + z3*g
10 continue
f = 1.0 + z3*f
g = z + z2*z2*g
!
!     Summation of f1 and g1
!
f1 = cmplx(c(8),0.0)
g1 = cmplx(d(8),0.0)
do n = 1,7
   i = 8 - n
   f1 = c(i) + z3*f1
   g1 = d(i) + z3*g1
end do
f1 = z2*(0.5 + z3*f1)
g1 = 1.0 + z3*g1
!
!     Final assembly
!
ai = c1*f - c2*g
bi = sqt3*(c1*f + c2*g)
aip = c1*f1 - c2*g1
bip = sqt3*(c1*f1 + c2*g1)
if (ind == 0) return
x = real(z)
y = aimag(z)
z1 = sqrt(z)
zz = z*z1/1.5
e = exp(zz)
e1 = 1.0/e
ai = ai*e
aip = aip*e
if (abs(y) > x*sqt3) go to 30
bi = bi*e1
bip = bip*e1
return
30 bi = bi*e
bip = bip*e
return
end subroutine airm

subroutine aii(ind, z, ai, aip, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: ai, aip
real :: a, b, r
complex :: z1, z2, z3, zm, w1, w2, w1m, w2m, e
real, parameter :: c1 = 1.83776298473931e-01
interface
   pure elemental subroutine aia(ind,z,ai,aip,ierr)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: ai
      complex, intent(inout) :: aip
      integer, intent(out) :: ierr
   end subroutine aia
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!------------------------------------------------------------
!     Calculates the Airy function ai and its derivative aip
!     for complex argument z in the intermediate range 1 .LE.
!     CABS(z) .LE. 10.0.
!------------------------------------------------------------
!
!     c1 = 1/(pi*sqrt(3))
!
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a, b)
z1 = sqrt(z)
z2 = z1*z/1.5
if (abs(b) < -5.0*a) go to 10
!
!           ----  abs(b) .GE. -5.0*a  ----
!
call ka(ind, z2, w1, w2)
ai = c1*z1*w1
aip = -c1*z*w2
return
!
!           ----  abs(b) .LT. -5.0*a  ----
!
10 if (abs(b) < -1.74*a) go to 30
if (r >= 8.2) go to 40
20 zm = -z
z1 = sqrt(zm)
z3 = z1*zm/1.5
call ja(z3, w1, w2, w1m, w2m)
ai = (z1/3.0)*(w1m + w1)
aip = (z/3.0)*(w2m - w2)
if (ind == 0) return
e = exp(z2)
ai = ai*e
aip = aip*e
return
30 if (r < 7.4) go to 20
40 call aia(ind,z,ai,aip,ierr)
return
end subroutine aii

pure elemental subroutine aia(ind, z, ai, aip, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(inout) :: ai, aip
complex, intent(in) :: z
integer :: i, k, m, m2
real :: eps, r, t, u, u1, v, v1, xm, xneg, xpos
complex :: z1, z2, z2r, zz, w, w2, s1, s2, s3, s4, e, zeta, si, cn, alpha, beta, j
real, parameter :: c(30) = [.100000000000000e+01, .694444444444444e-01, .371334876543210e-01, .379930591278006e-01, &
   & .576491904126697e-01, .116099064025515e+00, .291591399230751e+00, .877666969510017e+00, .307945303017317e+01, &
   & .123415733323452e+02, .556227853659171e+02, .278465080777603e+03, .153316943201280e+04, .920720659972641e+04, &
   & .598925135658791e+05, .419524875116551e+06, .314825741786683e+07, .251989198716024e+08, .214288036963680e+09, &
   & .192937554918249e+10, .183357669378906e+11, .183418303528833e+12, .192647115897045e+13, .211969993886476e+14, &
   & .243826826879716e+15, .292659921929793e+16, .365903070126431e+17, .475768102036307e+18, .642404935790194e+19, &
   & .899520742705838e+20]
real, parameter :: d(30) = [.100000000000000e+01, -.972222222222222e-01, -.438850308641975e-01, -.424628307898948e-01, - &
   & .626621634920323e-01, -.124105896027275e+00, -.308253764901079e+00, -.920479992412945e+00, -.321049358464862e+01, - &
   & .128072930807356e+02, -.575083035139143e+02, -.287033237109221e+03, -.157635730333710e+04, -.944635482309593e+04, - &
   & .613357066638521e+05, -.428952400400069e+06, -.321453652140086e+07, -.256979083839113e+08, -.218293420832160e+09, - &
   & .196352378899103e+10, -.186439310881072e+11, -.186352996385294e+12, -.195588293238984e+13, -.215064446351972e+14, - &
   & .247236992290621e+15, -.296588243029521e+16, -.370624400063547e+17, -.481678264794522e+18, -.650098408075106e+19, - &
   & .909919826436541e+20]
real, parameter :: c1 = .564189583547756
real, parameter :: c2 = .398942280401433
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Calculates the Airy function ai and its derivative aip for
!     complex argument z by means of asymptotic expansions.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!------------------------
!     c1 = pi**(-1/2)
!     c2 = (2*pi)**(-1/2)
!------------------------
!------------------------
!
!     Eps, xpos, and xneg are machine dependent constants. Eps is
!     the smallest number such that 1.0 + eps .GT. 1.0, xpos is the
!     the largest postive number for which exp(X) can be computed,
!     and xneg is the largest negative number for which exp(X) does
!     not underflow.
!
eps = spmpar(1)
xpos = exparg(0)
xneg = exparg(1)
!
!------------------------
ierr = 0
if (real(z) < 0.0) go to 30
!
!             -----   real(z) .GE. 0    -----
!
z1 = sqrt(z)
z2 = sqrt(z1)
z2r = 1.0/z2
call crec(real(z), aimag(z), u, v)
w = -1.5*cmplx(u,v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u,v)
if (ind /= 0) go to 10
!
if (t == 0.0) go to 90
u1 = u/t
v1 = v/t
r = u*u1 + v*v1
xm = xpos
if (real(w) < 0.0) xm = -xneg
if (u1 >= r*xm .or. v1 >= 0.1*r/eps) go to 90
zeta = z1*z/1.5
e = exp(-zeta)
!
10 m = 20
if (t > 30.0) m = 8
s1 = cmplx(c(m),0.0)
s2 = cmplx(d(m),0.0)
i = m
do 20 k = 2,m
   i = i - 1
   s1 = c(i) + w*s1
   s2 = d(i) + w*s2
20 continue
!
ai = 0.5*c1*z2r*s1
aip = - 0.5*c1*z2*s2
if (ind /= 0) return
ai = e*ai
aip = e*aip
return
!
!             -----   real(z) .LT. 0    -----
!
30 zz = -z
z1 = sqrt(zz)
z2 = sqrt(z1)
z2r = 1.0/z2
call crec(real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u,v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u,v)
!
if (t == 0.0) go to 90
u1 = u/t
v1 = v/t
r = u*u1 + v*v1
if (ind /= 0) go to 40
if (v1 >= r*xpos .or. u1 >= 0.1*r/eps) go to 90
zeta = z1*zz/1.5
go to 50
40 e = (0.0, 0.0)
j = (0.0, -1.0)
if (aimag(z) < 0.0) j = (0.0, 1.0)
if (v1 > 0.5*r*abs(xneg)) go to 50
if (u1 >= 0.05*r/eps) go to 90
zeta = z1*zz/1.5
e = exp(2.0*j*zeta)
!
50 w2 = w*w
m = 15
if (t > 30.0) m = 5
m2 = m + m
i = m2 - 1
s1 = cmplx(c(i),0.0)
s2 = cmplx(c(m2),0.0)
s3 = cmplx(d(i),0.0)
s4 = cmplx(d(m2),0.0)
do k = 2,m
   i = i - 1
   s2 = c(i) - s2*w2
   s4 = d(i) - s4*w2
   i = i - 1
   s1 = c(i) - s1*w2
   s3 = d(i) - s3*w2
end do
s2 = w*s2
s4 = w*s4
!
if (ind /= 0) go to 70
cn = cos(zeta)
si = sin(zeta)
go to 80
70 cn = 0.5*(1.0 + e)
si = 0.5*(1.0 - e)*j
!
80 alpha = s1 - s2
beta = s1 + s2
ai = c2*z2r*(alpha*cn + beta*si)
alpha = s3 - s4
beta = s3 + s4
aip = c2*z2*(alpha*si - beta*cn)
return
!
!         RETURN WITH ZERO VALUES IF SCALING IS NEEDED
!
90 ai = (0.0, 0.0)
aip = (0.0, 0.0)
ierr = 1
return
end subroutine aia

subroutine cbi(ind,z,bi,bip,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: bi
complex, intent(inout) :: bip
real :: a, b, r
complex :: ai, aip
interface
   pure elemental subroutine airm(ind,z,ai,aip,bi,bip)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: ai
      complex, intent(inout) :: aip
      complex, intent(inout) :: bi
      complex, intent(inout) :: bip
   end subroutine airm
   pure elemental subroutine bia(ind,z,bi,bip,ierr)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: bi
      complex, intent(inout) :: bip
      integer, intent(out) :: ierr
   end subroutine bia
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!------------------------------------------------------------
!     Calculates the Airy function bi and its derivative bip
!     for complex argument z.
!------------------------------------------------------------
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a,b)
if (r > 1.0) go to 10
!
!     Maclaurin expansion
!
call airm(ind,z,ai,aip,bi,bip)
return
10 if (r > 9.6) go to 20
!
!     Intermediate range calculation
!
call bii(ind,z,bi,bip,ierr)
return
!
!     Asymptotic expansion
!
20 call bia(ind,z,bi,bip,ierr)
return
end subroutine cbi

subroutine bii(ind, z, bi, bip, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: bi, bip
real :: a, r, x, y
complex :: z1, z2, zm, w1, w2, w1m, w2m, e, e1
real, parameter :: c1 = 5.77350269189626e-01
real, parameter :: sqt3 = 1.73205080756888e+00
interface
   pure elemental subroutine bia(ind,z,bi,bip,ierr)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: bi
      complex, intent(inout) :: bip
      integer, intent(out) :: ierr
   end subroutine bia
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!------------------------------------------------------------
!     Calculates the Airy function bi and its derivative bip
!     for complex argument z in the intermediate range 1 .LE.
!     CABS(z) .LE. 10.0.
!------------------------------------------------------------
!
!     c1 = 1/sqrt(3)
!     sqt3 = sqrt(3)
!
!
ierr = 0
x = real(z)
y = aimag(z)
r = cpabs(x, y)
z1 = sqrt(z)
z2 = z1*z/1.5
e = exp(-z2)
e1 = 1.0/e
if (real(z) < 0.0) go to 10
!
!               ----  real(z) .GE. 0  ----
!
if (r < 8.9) go to 5
a = 0.156*r - 0.913
if (abs(y) < a*x .or. abs(y) > 0.58*x) go to 40
5 call ia(z2, w1, w2, w1m, w2m)
bi = c1*z1*(w1 + w1m)
bip = c1*z*(w2 + w2m)
if (ind == 0) return
go to 20
!
!               ----  real(z) .LT. 0  ----
!
10 if (r < 8.1) go to 15
if (abs(y) < 3.89*abs(x)) go to 40
15 zm = -z
z1 = sqrt(zm)
z2 = z1*zm/1.5
call ja(z2, w1, w2, w1m, w2m)
bi = c1*z1*(w1m - w1)
bip = c1*zm*(w2m + w2)
if (ind == 0) return
20 if (x >= c1*abs(y)) go to 30
bi = bi*e1
bip = bip*e1
return
30 bi = bi*e
bip = bip*e
return
40 call bia(ind, z, bi, bip, ierr)
return
end subroutine bii

pure elemental subroutine bia(ind,z,bi,bip,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: bi, bip
integer :: i, k, m, m2
real :: ce, cf, eps, r, s, t, u, u1, v, v1, x, xneg, xpos, y
complex :: z1, z2, z2r, zz, w, w2, s1, s2, s3, s4, e, zeta, si, cn, cf1, cf2, alpha, beta, j, cz
real, parameter :: c(30) = [.100000000000000e+01, .694444444444444e-01, .371334876543210e-01, .379930591278006e-01, &
   & .576491904126697e-01, .116099064025515e+00, .291591399230751e+00, .877666969510017e+00, .307945303017317e+01, &
   & .123415733323452e+02, .556227853659171e+02, .278465080777603e+03, .153316943201280e+04, .920720659972641e+04, &
   & .598925135658791e+05, .419524875116551e+06, .314825741786683e+07, .251989198716024e+08, .214288036963680e+09, &
   & .192937554918249e+10, .183357669378906e+11, .183418303528833e+12, .192647115897045e+13, .211969993886476e+14, &
   & .243826826879716e+15, .292659921929793e+16, .365903070126431e+17, .475768102036307e+18, .642404935790194e+19, &
   & .899520742705838e+20]
real, parameter :: d(30) = [.100000000000000e+01, -.972222222222222e-01, -.438850308641975e-01, -.424628307898948e-01, - &
   & .626621634920323e-01, -.124105896027275e+00, -.308253764901079e+00, -.920479992412945e+00, -.321049358464862e+01, - &
   & .128072930807356e+02, -.575083035139143e+02, -.287033237109221e+03, -.157635730333710e+04, -.944635482309593e+04, - &
   & .613357066638521e+05, -.428952400400069e+06, -.321453652140086e+07, -.256979083839113e+08, -.218293420832160e+09, - &
   & .196352378899103e+10, -.186439310881072e+11, -.186352996385294e+12, -.195588293238984e+13, -.215064446351972e+14, - &
   & .247236992290621e+15, -.296588243029521e+16, -.370624400063547e+17, -.481678264794522e+18, -.650098408075106e+19, - &
   & .909919826436541e+20]
real, parameter :: sqt3 = 1.73205080756888
complex, parameter :: ex3c = (5.e-01, -8.66025403784439e-01)
complex, parameter :: ex6 = (8.66025403784439e-01, 5.e-01)
complex, parameter :: ex6c = (8.66025403784439e-01, -5.e-01)
complex, parameter :: cln2 = (0.0, 3.46573590279973e-01)
real, parameter :: c1 = 5.64189583547756e-01
real, parameter :: c2 = 3.98942280401433e-01
real, parameter :: c3 = 7.07106781186548e-01
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!---------------------------------------------------------------
!     Calculates the Airy function bi and its derivative bip for
!     complex argument z by means of asymptotic expansions.
!---------------------------------------------------------------
!------------------------
!------------------------
!-------------------------
!     sqt3 = sqrt(3)
!     ex3c = exp(-i*pi/3)
!     ex6 = exp(i*pi/6)
!     ex6c = exp(-i*pi/6)
!     cln2 = 0.5*i*ln(2)
!     c1 = pi**(-1/2)
!     c2 = (2*pi)**(-1/2)
!     c3 = 2**(-1/2)
!--------------------------
!--------------------------
!
!     Eps and XM are machine dependent constants. Eps is the
!     smallest number such that 1.0 + eps .GT. 1.0, xpos is the
!     largest positive number for which exp(XM) can be computed,
!     and XNEG is the negative number of largest magnitude for
!     which exp(X) does not underflow.
!
eps = spmpar(1)
xpos = exparg(0)
xneg = exparg(1)
!
!------------------------
ierr = 0
x = real(z)
y = aimag(z)
if (x < abs(y)*sqt3) go to 30
!
!          -----  abs(ARG(z)) .LE. PI/6  ----
!
z1 = sqrt(z)
z2 = sqrt(z1)
z2r = 1.0/z2
call crec(x, y, u, v)
w = 1.5*cmplx(u, v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u, v)
if (ind /= 0) go to 10
if (t == 0.0) go to 90
u1 = u/t
v1 = v/t
r = u*u1 + v*v1
if (u1 >= r*xpos .or. v1 >= 0.1*r/eps) go to 90
zeta = z1*z/1.5
e = exp(zeta)
!
10 m = 20
t = max(x, abs(y))
if (t > 30.0) m = 8
s1 = cmplx(c(m), 0.0)
s2 = cmplx(d(m), 0.0)
i = m
do 20 k = 2,m
   i = i - 1
   s1 = c(i) + w*s1
   s2 = d(i) + w*s2
20 continue
!
bi = c1*z2r*s1
bip = c1*z2*s2
if (ind /= 0) return
bi = e*bi
bip = e*bip
return
30 if (x < 0.0) go to 50
!
!          ----  PI/6 .LT. abs(ARG(z)) .LE. PI/2  ----
!
cz = z
if (y < 0.0) cz = conjg(cz)
zz = cz*ex3c
z1 = sqrt(zz)
z2 = sqrt(z1)
z2r = 1.0/z2
cf1 = c1*z2r*ex6
cf2 = c1*z2*ex6c
call crec(real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u, v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u, v)
!
if (t == 0.0) go to 90
u1 = u/t
v1 = v/t
r = u*u1 + v*v1
if (ind /= 0) go to 40
if (v1 >= r*xpos .or. u1 >= 0.1*r/eps) go to 90
zeta = z1*zz/1.5
cn = cos(zeta - cln2)
si = sin(zeta - cln2)
go to 70
!
!        e = exp(-2*i*(zeta - CLN2)) IF abs(ARG(zz)) .LE. PI/3
!        e = exp( 2*i*(zeta - CLN2)) IF abs(ARG(zz)) .GT. PI/3
!
40 e = (0.0, 0.0)
j = (0.0, -1.0)
s = 1.0
ce = 1.0
cf = 0.5
if (aimag(zz) <= 0.0) go to 44
s = -1.0
ce = 0.5
cf = 2.0
44 if (v1 >= 0.5*r*abs(xneg)) go to 45
if (u1 >= 0.05*r/eps) go to 90
zeta = z1*zz/1.5
e = cf*exp(2.0*s*j*zeta)
45 cn = ce*c3*(1 + e)
si = ce*s*c3*(1 - e)*j
go to 70
!
!                  ----  real(z) .LT. 0  ----
!
50 zz = -z
if (y < 0.0) zz = conjg(zz)
z1 = sqrt(zz)
z2 = sqrt(z1)
z2r = 1.0/z2
cf1 = c2*z2r
cf2 = c2*z2
call crec(real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u, v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u, v)
!
if (t == 0.0) go to 90
u1 = u/t
v1 = v/t
r = u*u1 + v*v1
if (ind /= 0) go to 60
if (v1 >= r*xpos .or. u1 >= 0.1*r/eps) go to 90
zeta = z1*zz/1.5
cn = cos(zeta)
si = sin(zeta)
go to 70
60 e = (0.0, 0.0)
j = (0.0, -1.0)
if (v1 >= 0.5*r*abs(xneg)) go to 65
if (u1 >= 0.05*r/eps) go to 90
zeta = z1*zz/1.5
e = exp(2.0*j*zeta)
65 cn = 0.5*(1.0 + e)
si = 0.5*(1.0 - e)*j
!
70 w2 = w*w
m = 15
t = max(abs(x), abs(y))
if (t > 30.0) m = 5
m2 = m + m
i = m2 - 1
s1 = cmplx(c(i), 0.0)
s2 = cmplx(c(m2), 0.0)
s3 = cmplx(d(i), 0.0)
s4 = cmplx(d(m2), 0.0)
do k = 2,m
   i = i - 1
   s2 = c(i) - s2*w2
   s4 = d(i) - s4*w2
   i = i - 1
   s1 = c(i) - s1*w2
   s3 = d(i) - s3*w2
end do
s2 = w*s2
s4 = w*s4
if (x >= 0.0) go to 81
alpha = s1 + s2
beta = s2 - s1
go to 82
81 alpha = s1 - s2
beta = s1 + s2
82 bi = cf1*(alpha*cn + beta*si)
if (x >= 0.0) go to 83
alpha = s3 - s4
beta = s3 + s4
go to 84
83 alpha = s3 + s4
beta = s4 - s3
84 bip = cf2*(alpha*cn + beta*si)
if (y >= 0.0) return
bi = conjg(bi)
bip = conjg(bip)
return
!
!            RETURN WITH ZERO VALUES IF SCALING IS NEEDED.
!
90 bi = (0.0, 0.0)
bip = (0.0, 0.0)
ierr = 1
return
end subroutine bia

subroutine ia(z, i1, i2, i1m, i2m)
implicit none
!-------------------------------------------------------------
!     Calculates the modified Bessel function of the first
!     kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!     argument z, where -Pi .LT. arg(z) .LE. pi.  i1 and i2
!     are replaced by the functions of orders 1/3 and 2/3,
!     respectively, and i1m and i2m by the functions of orders
!     -1/3 and -2/3, respectively.
!-------------------------------------------------------------
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
complex :: cz
complex, parameter :: ex13 = (5.0e-01, 8.66025403784439e-01)
complex, parameter :: ex13c = (5.0e-01, -8.66025403784439e-01)
complex, parameter :: ex23 = (-5.0e-01, 8.66025403784439e-01)
complex, parameter :: ex23c = (-5.0e-01, -8.66025403784439e-01)
!
!     ex13 = exp(i*pi/3)
!     ex13c = exp(-i*pi/3)
!     ex23 = exp(2*i*pi/3)
!     ex23c = exp(-2*i*pi/3)
!
if (real(z) >= 0.0) go to 20
cz = -z
!
!     Calculation of i1, i2, i1m, and i2m when real(cz) .GT. 0.
!
call imc(cz, i1, i2, i1m, i2m)
!
!     Final assembly
!
if (aimag(z) < 0.0) go to 10
i1 = ex13*i1
i2 = ex23*i2
i1m = ex13c*i1m
i2m = ex23c*i2m
return
10 i1 = ex13c*i1
i2 = ex23c*i2
i1m = ex13*i1m
i2m = ex23*i2m
return
20 call imc(z, i1, i2, i1m, i2m)
return
end subroutine ia

subroutine imc(z, i1, i2, i1m, i2m)
implicit none
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
integer :: i, n, n1
real :: a, an, b, cfa, cfb, cn1, cn2, m
complex :: ia1, ia2, ia3, ib1, ib2, ib3, sz, zh, e, cf1, cf2, cf3, cf4
real, parameter :: c1 = .333333333333333e+00
real, parameter :: c2 = .666666666666667e+00
real, parameter :: gm1 = .892979511569248e+00
real, parameter :: gm2 = .902745292950932e+00
!----------------------------------------------------------------
!     Calculates the modified Bessel function of the first
!     kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!     argument z. the Maclaurin expansion and backward recurrence
!     are used. i1 and i2 are replaced by the functions of orders
!     1/3 and 2/3, respectively, and i1m and i2m by the functions
!     of orders -1/3 and -2/3, respectively.  For greatest
!     accuracy, z should lie in the region real(z) .GE. 0.
!----------------------------------------------------------------
!
!     gm1 = gamma(4.0/3.0)
!     gm2 = gamma(5.0/3.0)
!
zh = 0.5*z
sz = zh*zh
a = real(zh)
b = aimag(zh)
an = aint(a*a + b*b)
cn1 = c1 + an
cn2 = c2 + an
!
!     Calculation of initial values for backward recurrence by
!     use of the Maclaurin expansion.
!
call bim(z, cn1, ia1)
call bim(z, cn1 + 1.0, ia2)
call bim(z, cn2, ib1)
call bim(z, cn2 + 1.0, ib2)
!
!     Backward recurrence
!
n = an
m = an
n1 = n + 1
do 10 i = 1, n1
   ia3 = ia2
   ia2 = ia1
   ib3 = ib2
   ib2 = ib1
   cfa = (m + c1)*(m + c1 + 1.0)
   cfb = (m + c2)*(m + c2 + 1.0)
   m = m - 1.0
   ia1 = ia2 + (sz/cfa)*ia3
10 ib1 = ib2 + (sz/cfb)*ib3
e = exp(c1*log(zh))
cf1 = e/gm1
cf2 = e*e/gm2
cf3 = c2*cf2/zh
cf4 = c1*cf1/zh
i1 = cf1*ia2
i2 = cf2*ib2
i1m = cf3*ib1
i2m = cf4*ia1
return
end subroutine imc

subroutine bim(z,cn,w)
implicit none
real, intent(in) :: cn
complex :: z
complex, intent(inout) :: w
real :: d, eps
real :: anorm
real :: m
complex :: sz, t
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-------------------------------------------------------------
!     Calculates the modified Bessel function of the first kind
!     for real order cn .GT. -1 And complex argument z by means
!     of the Maclaurin expansion.  w is replaced by the
!     calculated value.
!-------------------------------------------------------------
!------------------
anorm(z) = max(abs(real(z)),abs(aimag(z)))
!-------------------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the smallest
!     number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-------------------------------------------------------------
sz = 0.25*z*z
!
!     Initialization of Maclaurin expansion
!
m = 1.0
t = sz/(cn + 1.0)
w = t
!
!     Summation of Maclaurin expansion
!
10 m = m + 1.0
d = m*(cn + m)
t = t*(sz/d)
w = w + t
if (anorm(t) > eps*anorm(w)) go to 10
!
w = w + 1.0
return
end subroutine bim

subroutine ja(z, i1, i2, i1m, i2m)
implicit none
!------------------------------------------------------------
!     Calculates the Bessel function of the first kind for
!     orders 1/3, 2/3, -1/3, and -2/3 and for complex argument
!     z, where -Pi .LT. arg(z) .LE. pi.  i1 and i2 are replaced
!     by the functions of orders 1/3 and 2/3, respectively, and
!     i1m and i2m by functions of orders -1/3 and -2/3,
!     respectively.
!--------------------------------------------------------------
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
complex :: cz
complex, parameter :: ex13 = (5.0e-01, 8.66025403784439e-01)
complex, parameter :: ex13c = (5.0e-01, -8.66025403784439e-01)
complex, parameter :: ex23 = (-5.0e-01, 8.66025403784439e-01)
complex, parameter :: ex23c = (-5.0e-01, -8.66025403784439e-01)
!
!     ex13 = exp(i*pi/3)
!     ex13c = exp(-i*pi/3)
!     ex23 = exp(2*i*pi/3)
!     ex23c = exp(-2*i*pi/3)
!
if (real(z) >= 0.0) go to 20
cz = -z
!
!     Calculation of i1, i2, i1m, and i2m when real(cz) .GT. 0.0
!
call jmc(cz, i1, i2, i1m, i2m)
!
!     Final assembly
!
if (aimag(z) < 0.0) go to 10
i1 = ex13*i1
i2 = ex23*i2
i1m = ex13c*i1m
i2m = ex23c*i2m
return
10 i1 = ex13c*i1
i2 = ex23c*i2
i1m = ex13*i1m
i2m = ex23*i2m
return
20 call jmc(z, i1, i2, i1m, i2m)
return
end subroutine ja

subroutine jmc(z, i1, i2, i1m, i2m)
implicit none
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
integer :: i, n, n1
real :: a, an, b, cfa, cfb, cn1, cn2, m
complex :: ia1, ia2, ia3, ib1, ib2, ib3, sz, zh, e, cf1, cf2, cf3, cf4
real, parameter :: c1 = .333333333333333e+00
real, parameter :: c2 = .666666666666667e+00
real, parameter :: gm1 = .892979511569248e+00
real, parameter :: gm2 = .902745292950932e+00
!----------------------------------------------------------------
!     Calculates the Bessel function of the first
!     kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!     argument z. the Maclaurin expansion and backward recurrence
!     are used. i1 and i2 are replaced by the functions of orders
!     1/3 and 2/3, respectively, and i1m and i2m by the functions
!     of orders -1/3 and -2/3, respectively.  For greatest
!     accuracy, z should lie in the region real(z) .GE. 0.
!----------------------------------------------------------------
!
!     gm1 = gamma(4.0/3.0)
!     gm2 = gamma(5.0/3.0)
!
zh = 0.5*z
sz = zh*zh
a = real(zh)
b = aimag(zh)
an = aint(a*a + b*b)
cn1 = c1 + an
cn2 = c2 + an
!
!     Calculation of initial values for backward recurrence by
!     use of the Maclaurin expansion.
!
call bjm(z, cn1, ia1)
call bjm(z, cn1 + 1.0, ia2)
call bjm(z, cn2, ib1)
call bjm(z, cn2 + 1.0, ib2)
!
!     Backward recurrence
!
n = an
n1 = n + 1
m = an
do 10 i = 1, n1
   ia3 = ia2
   ia2 = ia1
   ib3 = ib2
   ib2 = ib1
   cfa = (m + c1)*(m + c1 + 1.0)
   cfb = (m + c2)*(m + c2 + 1.0)
   m = m - 1.0
   ia1 = ia2 - (sz/cfa)*ia3
10 ib1 = ib2 - (sz/cfb)*ib3
e = exp(c1*log(zh))
cf1 = e/gm1
cf2 = e*e/gm2
cf3 = c2*cf2/zh
cf4 = c1*cf1/zh
i1 = cf1*ia2
i2 = cf2*ib2
i1m = cf3*ib1
i2m = cf4*ia1
return
end subroutine jmc

subroutine bjm(z,cn,w)
implicit none
real, intent(in) :: cn
complex :: z
complex, intent(inout) :: w
real :: d, eps
real :: anorm
real :: m
complex :: sz, t
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-------------------------------------------------------------
!     Calculates the Bessel function of the first kind
!     for real order cn .GT. -1 And complex argument z by means
!     of the Maclaurin expansion.  w is replaced by the
!     calculated value.
!-------------------------------------------------------------
!------------------
anorm(z) = max(abs(real(z)),abs(aimag(z)))
!-------------------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the smallest
!     number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-------------------------------------------------------------
sz = -0.25*z*z
!
!     Initialization of Maclaurin expansion
!
m = 1.0
t = sz/(cn + 1.0)
w = t
!
!     Summation of Maclaurin expansion
!
10 m = m + 1.0
d = m*(cn + m)
t = t*(sz/d)
w = w + t
if (anorm(t) > eps*anorm(w)) go to 10
!
w = w + 1.0
return
end subroutine bjm

subroutine ka(ind, z, k1, k2)
implicit none
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: k1, k2
integer :: ind1
real :: a, b
complex :: i1, i2, i1m, i2m, cz, e
real, parameter :: pi = 3.14159265358979e+00
complex, parameter :: ex13c = (5.0e-01, -8.66025403784439e-01)
complex, parameter :: ex23c = (-5.0e-01, -8.66025403784439e-01)
complex, parameter :: j = (0.0, 1.0)
interface
   pure elemental subroutine kml(ind,z,k1,k2)
      implicit none
      integer, intent(in) :: ind
      complex, intent(in) :: z
      complex, intent(inout) :: k1
      complex, intent(inout) :: k2
   end subroutine kml
end interface
!------------------------------------------------------------
!     Calculates the modified Bessel function of the second
!     kind for orders 1/3 and 2/3 and for complex argument z,
!     where -pi .LT. arg(z) .le pi.  k1 is replaced by the
!     function of order 1/3, and k2 by the function of order
!     2/3.
!------------------------------------------------------------
!
!     ex13c = exp(-pi*i/3)
!     ex23c = exp(-2*pi*i/3)
!
a = real(z)
b = aimag(z)
if (abs(b) < -0.5*a) go to 10
!
!            ----  abs(b) .GE. -0.5*a  ----
!
call kml(ind, z, k1, k2)
return
!
!            ----  abs(b) .LT. -0.5*a  ----
!
10 cz = -z
if (aimag(z) < 0.0) cz = conjg(cz)
ind1 = 0
call kml(ind1, cz, k1, k2)
call imc(cz, i1, i2, i1m, i2m)
k1 = ex13c*k1 - j*pi*i1
k2 = ex23c*k2 - j*pi*i2
if (ind == 0) go to 20
e = exp(z)
k1 = k1*e
k2 = k2*e
20 if (aimag(z) >= 0.0) return
k1 = conjg(k1)
k2 = conjg(k2)
return
end subroutine ka

pure elemental subroutine kml(ind, z, k1, k2)
implicit none
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: k1, k2
integer :: i, l, m
real :: a, ai, al, b, c, eps, r, th, x1, x2
complex :: bi, u1, u2, u3, s, e
real, parameter :: c1 = 1.25331413731550e+00
interface
   pure elemental subroutine capo(x,y,r,theta)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: r
      real, intent(inout) :: theta
   end subroutine capo
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!------------------------------------------------------------
!     Calculates the modified Bessel function of the second
!     kind for orders 1/3 and 2/3 and for complex argument z
!     by use of the Miller algorithm.  k1 is replaced by the
!     function of order 1/3, and k2 by the function of order
!     2/3.  For greatest accuracy, z should lie in the region
!     real(z) .GE. 0.
!------------------------------------------------------------
!
!     c1 = sqrt(pi/2)
!
eps = spmpar(1)
x1 = real(z)
x2 = aimag(z)
!
!     Calculation of m for use in Miller algorithm.
!
call capo(x1, x2, r, th)
a = 3.0/(1.0 + r)
b = 14.7/(28.0 + r)
c = 2.0/(c1*eps*(2.0*r)**(0.25))
m = (0.485/r)*(log(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
   & (2.0*cos(b*th))**2 + 1.5
!
!     Backward recurrence in Miller algorithm.
!
s = 0.0
u2 = 0.0
u1 = eps
l = m
do 10 i = 1, m
   al = l
   u3 = u2
   u2 = u1
   ai = ((al - 0.5)**2 - 1.0/9.0)/(al*(al + 1.0))
   bi = 2.0*(al + z)/(al + 1.0)
   u1 = (bi*u2 - u3)/ai
   s = s + u1
10 l = l - 1
!
!     Final assembly
!
k1 = c1*u1/(s*sqrt(z))
k2 = k1*(z + 1.0/6.0 - u2/u1)/z
if (ind /= 0) return
e = exp(-z)
k1 = k1*e
k2 = k2*e
return
end subroutine kml

pure real function ai(x)
implicit none
real, intent(in) :: x
integer :: n, n2
real :: phi, r, rtx, t, w
real, parameter :: x0 = 1.58740105196820
real, parameter :: c = 1.94773404105468
real, parameter :: an0 = .355028053887818e+00
real, parameter :: an1 = -.187394912983414e+00
real, parameter :: an2 = -.383735973881972e-01
real, parameter :: an3 = .491952571236878e-01
real, parameter :: an4 = -.967017625191329e-02
real, parameter :: an5 = -.205648610308316e-02
real, parameter :: an6 = .114176040526844e-02
real, parameter :: an7 = -.117114823456866e-03
real, parameter :: an8 = -.270165470074755e-04
real, parameter :: an9 = .789002965889206e-05
real, parameter :: ad0 = .100000000000000e+01
real, parameter :: ad1 = .201179850513612e+00
real, parameter :: ad2 = .385762517106249e-01
real, parameter :: ad3 = .230887443780120e-04
real, parameter :: bn0 = .355028053887817e+00
real, parameter :: bn1 = -.997169317338190e-01
real, parameter :: bn2 = -.602216060213075e-01
real, parameter :: bn3 = .297705337630730e-01
real, parameter :: bn4 = -.152969932286570e-02
real, parameter :: bn5 = -.147868368189372e-02
real, parameter :: bn6 = .350518617006107e-03
real, parameter :: bn7 = -.257766924610873e-04
real, parameter :: bd0 = .100000000000000e+01
real, parameter :: bd1 = .448140563306831e+00
real, parameter :: bd2 = .157074537566686e+00
real, parameter :: bd3 = .316964519364865e-01
real, parameter :: bd4 = .485922740843953e-02
real, parameter :: bd5 = .423326964456309e-03
real, parameter :: pn0 = .282094378896566e+00
real, parameter :: pn1 = .807868561687271e-01
real, parameter :: pn2 = .630644564152247e-02
real, parameter :: pn3 = .147116711467936e-03
real, parameter :: pn4 = .750490748341483e-06
real, parameter :: pd0 = .100000000000000e+01
real, parameter :: pd1 = .292890323271551e+00
real, parameter :: pd2 = .239376862143358e-01
real, parameter :: pd3 = .612353984250624e-03
real, parameter :: pd4 = .384461189764830e-05
real, parameter :: pd5 = .123247804102182e-08
real, parameter :: qn0 = .282094791017188e+00
real, parameter :: qn1 = .149585822742689e+00
real, parameter :: qn2 = .241876418864958e-01
real, parameter :: qn3 = .138190913282142e-02
real, parameter :: qn4 = .241862862465003e-04
real, parameter :: qn5 = .709733720554615e-07
real, parameter :: qd0 = .100000000000000e+01
real, parameter :: qd1 = .536778341756648e+00
real, parameter :: qd2 = .889112579703465e-01
real, parameter :: qd3 = .533368703697049e-02
real, parameter :: qd4 = .103812739863315e-03
real, parameter :: qd5 = .408838544650398e-06
real, parameter :: rn0 = .282094791773878e+00
real, parameter :: rn1 = .203731967781874e+00
real, parameter :: rn2 = .436660479870037e-01
real, parameter :: rn3 = .306595563073142e-02
real, parameter :: rn4 = .517398800281618e-04
real, parameter :: rd0 = .100000000000000e+01
real, parameter :: rd1 = .728721438361672e+00
real, parameter :: rd2 = .159210021472267e+00
real, parameter :: rd3 = .116985268534248e-01
real, parameter :: rd4 = .225973894323078e-03
real, parameter :: rd5 = .232707159780478e-06
interface
   pure elemental subroutine aimp(x,r,phi)
      implicit none
      real, intent(in) :: x
      real, intent(inout) :: r
      real, intent(inout) :: phi
   end subroutine aimp
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!     Evaluation of the Airy function ai(x)
!-----------------------------------------------------------------------
!     x0 = 2**(2/3)
!     c = exp(2/3)
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
if (x >= -1.0) go to 10
call aimp(-x, r, phi)
ai = r*sin(phi)
return
!
10 if (x >= 0.0) go to 20
ai = (((((((((an9*x + an8)*x + an7)*x + an6)*x + an5)*x &
   & + an4)*x + an3)*x + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x >= 1.0) go to 30
ai = (((((((bn7*x + bn6)*x + bn5)*x + bn4)*x + bn3)*x + bn2)*x &
   & + bn1)*x + bn0) / &
   & (((((bd5*x + bd4)*x + bd3)*x + bd2)*x + bd1)*x + bd0)
return
!
30 rtx = sqrt(x)
if (x > x0) go to 40
t = 16.0/(x*rtx)
w = ((((pn4*t + pn3)*t + pn2)*t + pn1)*t + pn0) / &
   & (((((pd5*t + pd4)*t + pd3)*t + pd2)*t + pd1)*t + pd0)
ai = (w/sqrt(rtx)) * exp(-2.0*x*rtx/3.0)
return
!
40 if (x > 4.0d0) go to 50
t = 16.0/(x*rtx)
w = (((((qn5*t + qn4)*t + qn3)*t + qn2)*t + qn1)*t + qn0) / &
   & (((((qd5*t + qd4)*t + qd3)*t + qd2)*t + qd1)*t + qd0)
ai = (w/sqrt(rtx)) * exp(-2.0*x*rtx/3.0)
return
!
50 if (x*rtx > 1.5*exparg(0)) go to 60
t = 16.0/(x*rtx)
w = ((((rn4*t + rn3)*t + rn2)*t + rn1)*t + rn0) / &
   & (((((rd5*t + rd4)*t + rd3)*t + rd2)*t + rd1)*t + rd0)
n = rtx
n2 = n*n
t = (x - n2)/(rtx + n)
ai = ((w/sqrt(rtx)) / c**(n2*n)) * exp(-2.0*t*(n*rtx + t*t/3.0))
return
!
60 ai = 0.0
return
end function ai

pure elemental real function aie(x)
implicit none
real, intent(in) :: x
real :: phi, r, rtx, t, w
real, parameter :: x0 = .158740105196820e+01
real, parameter :: an0 = .355028053887818e+00
real, parameter :: an1 = -.187394912983414e+00
real, parameter :: an2 = -.383735973881972e-01
real, parameter :: an3 = .491952571236878e-01
real, parameter :: an4 = -.967017625191329e-02
real, parameter :: an5 = -.205648610308316e-02
real, parameter :: an6 = .114176040526844e-02
real, parameter :: an7 = -.117114823456866e-03
real, parameter :: an8 = -.270165470074755e-04
real, parameter :: an9 = .789002965889206e-05
real, parameter :: ad0 = .100000000000000e+01
real, parameter :: ad1 = .201179850513612e+00
real, parameter :: ad2 = .385762517106249e-01
real, parameter :: ad3 = .230887443780120e-04
real, parameter :: bn0 = .355028053887817e+00
real, parameter :: bn1 = -.997169317338190e-01
real, parameter :: bn2 = -.602216060213075e-01
real, parameter :: bn3 = .297705337630730e-01
real, parameter :: bn4 = -.152969932286570e-02
real, parameter :: bn5 = -.147868368189372e-02
real, parameter :: bn6 = .350518617006107e-03
real, parameter :: bn7 = -.257766924610873e-04
real, parameter :: bd0 = .100000000000000e+01
real, parameter :: bd1 = .448140563306831e+00
real, parameter :: bd2 = .157074537566686e+00
real, parameter :: bd3 = .316964519364865e-01
real, parameter :: bd4 = .485922740843953e-02
real, parameter :: bd5 = .423326964456309e-03
real, parameter :: pn0 = .282094378896566e+00
real, parameter :: pn1 = .807868561687271e-01
real, parameter :: pn2 = .630644564152247e-02
real, parameter :: pn3 = .147116711467936e-03
real, parameter :: pn4 = .750490748341483e-06
real, parameter :: pd0 = .100000000000000e+01
real, parameter :: pd1 = .292890323271551e+00
real, parameter :: pd2 = .239376862143358e-01
real, parameter :: pd3 = .612353984250624e-03
real, parameter :: pd4 = .384461189764830e-05
real, parameter :: pd5 = .123247804102182e-08
real, parameter :: qn0 = .282094791017188e+00
real, parameter :: qn1 = .149585822742689e+00
real, parameter :: qn2 = .241876418864958e-01
real, parameter :: qn3 = .138190913282142e-02
real, parameter :: qn4 = .241862862465003e-04
real, parameter :: qn5 = .709733720554615e-07
real, parameter :: qd0 = .100000000000000e+01
real, parameter :: qd1 = .536778341756648e+00
real, parameter :: qd2 = .889112579703465e-01
real, parameter :: qd3 = .533368703697049e-02
real, parameter :: qd4 = .103812739863315e-03
real, parameter :: qd5 = .408838544650398e-06
real, parameter :: rn0 = .282094791773878e+00
real, parameter :: rn1 = .203731967781874e+00
real, parameter :: rn2 = .436660479870037e-01
real, parameter :: rn3 = .306595563073142e-02
real, parameter :: rn4 = .517398800281618e-04
real, parameter :: rd0 = .100000000000000e+01
real, parameter :: rd1 = .728721438361672e+00
real, parameter :: rd2 = .159210021472267e+00
real, parameter :: rd3 = .116985268534248e-01
real, parameter :: rd4 = .225973894323078e-03
real, parameter :: rd5 = .232707159780478e-06
interface
   pure elemental subroutine aimp(x,r,phi)
      implicit none
      real, intent(in) :: x
      real, intent(inout) :: r
      real, intent(inout) :: phi
   end subroutine aimp
end interface
!-----------------------------------------------------------------------
!
!                   Scaled Airy function ai(x)
!
!
!             aie(x) = exp(ZETA)*ai(x)  WHEN x .GE. 0
!             aie(x) = ai(x)            WHEN x .LT. 0
!
!             zeta = (2/3) * x**(3/2)
!
!-----------------------------------------------------------------------
!     x0 = 2**(2/3)
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
if (x >= -1.0) go to 10
call aimp(-x, r, phi)
aie = r*sin(phi)
return
!
10 if (x >= 0.0) go to 20
aie = (((((((((an9*x + an8)*x + an7)*x + an6)*x + an5)*x &
   & + an4)*x + an3)*x + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x >= 1.0) go to 30
aie = (((((((bn7*x + bn6)*x + bn5)*x + bn4)*x + bn3)*x + bn2)*x &
   & + bn1)*x + bn0) / &
   & (((((bd5*x + bd4)*x + bd3)*x + bd2)*x + bd1)*x + bd0)
if (x > 1.e-20) aie = aie * exp(2.0*x*sqrt(x)/3.0)
return
!
30 rtx = sqrt(x)
if (x > x0) go to 40
t = 16.0/(x*rtx)
w = ((((pn4*t + pn3)*t + pn2)*t + pn1)*t + pn0) / &
   & (((((pd5*t + pd4)*t + pd3)*t + pd2)*t + pd1)*t + pd0)
aie = w/sqrt(rtx)
return
!
40 if (x > 4.0d0) go to 50
t = 16.0/(x*rtx)
w = (((((qn5*t + qn4)*t + qn3)*t + qn2)*t + qn1)*t + qn0) / &
   & (((((qd5*t + qd4)*t + qd3)*t + qd2)*t + qd1)*t + qd0)
aie = w/sqrt(rtx)
return
!
50 if (x > 1.e20) go to 60
t = 16.0/(x*rtx)
w = ((((rn4*t + rn3)*t + rn2)*t + rn1)*t + rn0) / &
   & (((((rd5*t + rd4)*t + rd3)*t + rd2)*t + rd1)*t + rd0)
aie = w/sqrt(rtx)
return
!
60 aie = rn0/sqrt(rtx)
return
end function aie

pure real function bi(x)
implicit none
real, intent(in) :: x
integer :: n, n2
real :: phi, r, rtx, t, w
real, parameter :: x0 = 6.3496042078728
real, parameter :: c = 1.94773404105468
real, parameter :: an0 = .614926627446001e+00
real, parameter :: an1 = .462726943978834e+00
real, parameter :: an2 = .867811386408974e-02
real, parameter :: an3 = .974670609357959e-01
real, parameter :: an4 = .370856545413908e-01
real, parameter :: an5 = .569193415071716e-03
real, parameter :: an6 = .269172131237236e-02
real, parameter :: an7 = .746473849872868e-03
real, parameter :: an8 = .105638036899269e-04
real, parameter :: an9 = .242726195973978e-04
real, parameter :: an10 = .557260250681542e-05
real, parameter :: ad0 = .100000000000000e+01
real, parameter :: ad1 = .234801779278695e-01
real, parameter :: ad2 = -.300487317759152e-02
real, parameter :: ad3 = -.597414466459612e-02
real, parameter :: bn0 = .614926627446001e+00
real, parameter :: bn1 = .548653374523520e+00
real, parameter :: bn2 = .582684047163842e-01
real, parameter :: bn3 = .871954925712688e-01
real, parameter :: bn4 = .508547058449004e-01
real, parameter :: bn5 = .361412623711710e-02
real, parameter :: bn6 = .177269722794511e-02
real, parameter :: bn7 = .117774184027185e-02
real, parameter :: bn8 = .627004834186143e-04
real, parameter :: bn9 = .774782269814080e-06
real, parameter :: bn10 = .118116474369315e-04
real, parameter :: bd0 = .100000000000000e+01
real, parameter :: bd1 = .163214622184402e+00
real, parameter :: bd2 = -.242285981710408e-01
real, parameter :: bd3 = -.720554280297616e-02
real, parameter :: pn0 = .619911943572678e+00
real, parameter :: pn1 = .100411558489626e+01
real, parameter :: pn2 = .563659963795768e+00
real, parameter :: pn3 = .274925508033015e+00
real, parameter :: pn4 = .115641822943246e+00
real, parameter :: pn5 = .120048517441127e-01
real, parameter :: pn6 = .501838091254330e-02
real, parameter :: pd0 = .100000000000000e+01
real, parameter :: pd1 = .159751878026937e+01
real, parameter :: pd2 = .104664867034140e+01
real, parameter :: pd3 = .512560333664022e+00
real, parameter :: pd4 = .159144727666995e+00
real, parameter :: pd5 = .394456748956258e-01
real, parameter :: pd6 = .529926873250079e-02
real, parameter :: pd7 = .288921845412576e-03
real, parameter :: qn0 = .595123543430856e+00
real, parameter :: qn1 = .652692120245803e+00
real, parameter :: qn2 = .436851872835894e+00
real, parameter :: qn3 = .201626141057807e+00
real, parameter :: qn4 = .649535170626944e-01
real, parameter :: qn5 = .171798867787816e-01
real, parameter :: qn6 = .287998748038892e-02
real, parameter :: qn7 = .359634362348937e-03
real, parameter :: qd0 = .100000000000000e+01
real, parameter :: qd1 = .114259871204893e+01
real, parameter :: qd2 = .766390439057101e+00
real, parameter :: qd3 = .348287281255683e+00
real, parameter :: qd4 = .117049276946157e+00
real, parameter :: qd5 = .294545450289541e-01
real, parameter :: qd6 = .523951773968125e-02
real, parameter :: qd7 = .622692248774973e-03
real, parameter :: qd8 = .674811395957744e-06
real, parameter :: rn0 = .568067636505865e+00
real, parameter :: rn1 = .462183136291541e-01
real, parameter :: rn2 = .268519638203645e+00
real, parameter :: rn3 = .199427104235673e-02
real, parameter :: rn4 = .135599161332010e-03
real, parameter :: rn5 = .229937707171804e-04
real, parameter :: rn6 = .697888081361175e-05
real, parameter :: rn7 = .153277172934286e-05
real, parameter :: rn8 = -.149322381877245e-05
real, parameter :: rn9 = -.113533571972859e-05
real, parameter :: rn10 = .740721412702102e-06
real, parameter :: rn11 = -.120160431596119e-06
real, parameter :: rd0 = .100000000000000e+01
real, parameter :: rd1 = .741293424676788e-01
real, parameter :: rd2 = .471695968238457e+00
real, parameter :: sn0 = .564189583547757e+00
real, parameter :: sn1 = .112605519585866e+00
real, parameter :: sn2 = .893329124921909e-03
real, parameter :: sn3 = .532139134120350e-04
real, parameter :: sn4 = .592725458717738e-05
real, parameter :: sn5 = .921448923850546e-06
real, parameter :: sn6 = .404558310611815e-06
real, parameter :: sn7 = -.660517686759109e-06
real, parameter :: sn8 = .174667472383815e-05
real, parameter :: sn9 = -.287037710548882e-05
real, parameter :: sn10 = .322304072982791e-05
real, parameter :: sn11 = -.231569499551950e-05
real, parameter :: sn12 = .963478964685941e-06
real, parameter :: sn13 = -.173784488565533e-06
real, parameter :: sd0 = .100000000000000e+01
real, parameter :: sd1 = .193077670156841e+00
interface
   pure elemental subroutine aimp(x,r,phi)
      implicit none
      real, intent(in) :: x
      real, intent(inout) :: r
      real, intent(inout) :: phi
   end subroutine aimp
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!
!             Evaluation of the Airy function bi(x)
!
!
!     Note... if x is a positive number where bi(x) is too large
!     to be computed, then bi(x) is set to 0.
!
!-----------------------------------------------------------------------
!     x0 = 16**(2/3)
!     c = exp(2/3)
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
if (x >= -1.0) go to 10
call aimp(-x, r, phi)
bi = r*cos(phi)
return
!
10 if (x >= 0.0) go to 20
bi = ((((((((((an10*x + an9)*x + an8)*x + an7)*x &
   & + an6)*x + an5)*x + an4)*x + an3)*x &
   & + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x > 1.0) go to 30
bi = ((((((((((bn10*x + bn9)*x + bn8)*x + bn7)*x &
   & + bn6)*x + bn5)*x + bn4)*x + bn3)*x &
   & + bn2)*x + bn1)*x + bn0) / &
   & (((bd3*x + bd2)*x + bd1)*x + bd0)
return
!
30 rtx = sqrt(x)
if (x > 2.0) go to 40
t = x - 1.0
w = ((((((pn6*t + pn5)*t + pn4)*t + pn3)*t + pn2)*t &
   & + pn1)*t + pn0) / &
   & (((((((pd7*t + pd6)*t + pd5)*t + pd4)*t + pd3)*t &
   & + pd2)*t + pd1)*t + pd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
!
40 if (x > 4.0) go to 50
t = x - 2.0
w = (((((((qn7*t + qn6)*t + qn5)*t + qn4)*t + qn3)*t &
   & + qn2)*t + qn1)*t + qn0) / &
   & ((((((((qd8*t + qd7)*t + qd6)*t + qd5)*t + qd4)*t &
   & + qd3)*t + qd2)*t + qd1)*t + qd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
!
50 if (x > x0) go to 60
t = 16.0/(x*rtx) - 1.0
w = (((((((((((rn11*t + rn10)*t + rn9)*t + rn8)*t &
   & + rn7)*t + rn6)*t + rn5)*t + rn4)*t + rn3)*t &
   & + rn2)*t + rn1)*t + rn0) / &
   & ((rd2*t + rd1)*t + rd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
!
60 if (x*rtx > 1.5*exparg(0)) go to 70
t = 16.0/(x*rtx)
w = (((((((((((((sn13*t + sn12)*t + sn11)*t + sn10)*t &
   & + sn9)*t + sn8)*t + sn7)*t + sn6)*t + sn5)*t &
   & + sn4)*t + sn3)*t + sn2)*t + sn1)*t + sn0) / &
   & (sd1*t + sd0)
n = rtx
n2 = n*n
t = (x - n2)/(rtx + n)
bi = (w/sqrt(rtx)) * c**(n2*n) * exp(2.0*t*(n*rtx + t*t/3.0))
return
!
70 bi = 0.0
return
end function bi

pure elemental real function bie(x)
implicit none
real, intent(in) :: x
real :: phi, r, rtx, t, w
real, parameter :: x0 = 6.3496042078728
real, parameter :: an0 = .614926627446001e+00
real, parameter :: an1 = .462726943978834e+00
real, parameter :: an2 = .867811386408974e-02
real, parameter :: an3 = .974670609357959e-01
real, parameter :: an4 = .370856545413908e-01
real, parameter :: an5 = .569193415071716e-03
real, parameter :: an6 = .269172131237236e-02
real, parameter :: an7 = .746473849872868e-03
real, parameter :: an8 = .105638036899269e-04
real, parameter :: an9 = .242726195973978e-04
real, parameter :: an10 = .557260250681542e-05
real, parameter :: ad0 = .100000000000000e+01
real, parameter :: ad1 = .234801779278695e-01
real, parameter :: ad2 = -.300487317759152e-02
real, parameter :: ad3 = -.597414466459612e-02
real, parameter :: bn0 = .614926627446001e+00
real, parameter :: bn1 = .548653374523520e+00
real, parameter :: bn2 = .582684047163842e-01
real, parameter :: bn3 = .871954925712688e-01
real, parameter :: bn4 = .508547058449004e-01
real, parameter :: bn5 = .361412623711710e-02
real, parameter :: bn6 = .177269722794511e-02
real, parameter :: bn7 = .117774184027185e-02
real, parameter :: bn8 = .627004834186143e-04
real, parameter :: bn9 = .774782269814080e-06
real, parameter :: bn10 = .118116474369315e-04
real, parameter :: bd0 = .100000000000000e+01
real, parameter :: bd1 = .163214622184402e+00
real, parameter :: bd2 = -.242285981710408e-01
real, parameter :: bd3 = -.720554280297616e-02
real, parameter :: pn0 = .619911943572678e+00
real, parameter :: pn1 = .100411558489626e+01
real, parameter :: pn2 = .563659963795768e+00
real, parameter :: pn3 = .274925508033015e+00
real, parameter :: pn4 = .115641822943246e+00
real, parameter :: pn5 = .120048517441127e-01
real, parameter :: pn6 = .501838091254330e-02
real, parameter :: pd0 = .100000000000000e+01
real, parameter :: pd1 = .159751878026937e+01
real, parameter :: pd2 = .104664867034140e+01
real, parameter :: pd3 = .512560333664022e+00
real, parameter :: pd4 = .159144727666995e+00
real, parameter :: pd5 = .394456748956258e-01
real, parameter :: pd6 = .529926873250079e-02
real, parameter :: pd7 = .288921845412576e-03
real, parameter :: qn0 = .595123543430856e+00
real, parameter :: qn1 = .652692120245803e+00
real, parameter :: qn2 = .436851872835894e+00
real, parameter :: qn3 = .201626141057807e+00
real, parameter :: qn4 = .649535170626944e-01
real, parameter :: qn5 = .171798867787816e-01
real, parameter :: qn6 = .287998748038892e-02
real, parameter :: qn7 = .359634362348937e-03
real, parameter :: qd0 = .100000000000000e+01
real, parameter :: qd1 = .114259871204893e+01
real, parameter :: qd2 = .766390439057101e+00
real, parameter :: qd3 = .348287281255683e+00
real, parameter :: qd4 = .117049276946157e+00
real, parameter :: qd5 = .294545450289541e-01
real, parameter :: qd6 = .523951773968125e-02
real, parameter :: qd7 = .622692248774973e-03
real, parameter :: qd8 = .674811395957744e-06
real, parameter :: rn0 = .568067636505865e+00
real, parameter :: rn1 = .462183136291541e-01
real, parameter :: rn2 = .268519638203645e+00
real, parameter :: rn3 = .199427104235673e-02
real, parameter :: rn4 = .135599161332010e-03
real, parameter :: rn5 = .229937707171804e-04
real, parameter :: rn6 = .697888081361175e-05
real, parameter :: rn7 = .153277172934286e-05
real, parameter :: rn8 = -.149322381877245e-05
real, parameter :: rn9 = -.113533571972859e-05
real, parameter :: rn10 = .740721412702102e-06
real, parameter :: rn11 = -.120160431596119e-06
real, parameter :: rd0 = .100000000000000e+01
real, parameter :: rd1 = .741293424676788e-01
real, parameter :: rd2 = .471695968238457e+00
real, parameter :: sn0 = .564189583547757e+00
real, parameter :: sn1 = .112605519585866e+00
real, parameter :: sn2 = .893329124921909e-03
real, parameter :: sn3 = .532139134120350e-04
real, parameter :: sn4 = .592725458717738e-05
real, parameter :: sn5 = .921448923850546e-06
real, parameter :: sn6 = .404558310611815e-06
real, parameter :: sn7 = -.660517686759109e-06
real, parameter :: sn8 = .174667472383815e-05
real, parameter :: sn9 = -.287037710548882e-05
real, parameter :: sn10 = .322304072982791e-05
real, parameter :: sn11 = -.231569499551950e-05
real, parameter :: sn12 = .963478964685941e-06
real, parameter :: sn13 = -.173784488565533e-06
real, parameter :: sd0 = .100000000000000e+01
real, parameter :: sd1 = .193077670156841e+00
interface
   pure elemental subroutine aimp(x,r,phi)
      implicit none
      real, intent(in) :: x
      real, intent(inout) :: r
      real, intent(inout) :: phi
   end subroutine aimp
end interface
!-----------------------------------------------------------------------
!
!                    Scaled Airy function bi(x)
!
!
!             bie(x) = exp(-ZETA)*bi(x)  WHEN x .GE. 0
!             bie(x) = bi(x)             WHEN x .LT. 0
!
!             zeta = (2/3) * x**(3/2)
!
!-----------------------------------------------------------------------
!     x0 = 16**(2/3)
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
if (x >= -1.0) go to 10
call aimp(-x, r, phi)
bie = r*cos(phi)
return
!
10 if (x >= 0.0) go to 20
bie = ((((((((((an10*x + an9)*x + an8)*x + an7)*x &
   & + an6)*x + an5)*x + an4)*x + an3)*x &
   & + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x > 1.0) go to 30
bie = ((((((((((bn10*x + bn9)*x + bn8)*x + bn7)*x &
   & + bn6)*x + bn5)*x + bn4)*x + bn3)*x &
   & + bn2)*x + bn1)*x + bn0) / &
   & (((bd3*x + bd2)*x + bd1)*x + bd0)
if (x > 1.e-20) bie = bie * exp(-2.0*x*sqrt(x)/3.0)
return
!
30 rtx = sqrt(x)
if (x > 2.0) go to 40
t = x - 1.0
w = ((((((pn6*t + pn5)*t + pn4)*t + pn3)*t + pn2)*t &
   & + pn1)*t + pn0) / &
   & (((((((pd7*t + pd6)*t + pd5)*t + pd4)*t + pd3)*t &
   & + pd2)*t + pd1)*t + pd0)
bie = w/sqrt(rtx)
return
!
40 if (x > 4.0) go to 50
t = x - 2.0
w = (((((((qn7*t + qn6)*t + qn5)*t + qn4)*t + qn3)*t &
   & + qn2)*t + qn1)*t + qn0) / &
   & ((((((((qd8*t + qd7)*t + qd6)*t + qd5)*t + qd4)*t &
   & + qd3)*t + qd2)*t + qd1)*t + qd0)
bie = w/sqrt(rtx)
return
!
50 if (x > x0) go to 60
t = 16.0/(x*rtx) - 1.0
w = (((((((((((rn11*t + rn10)*t + rn9)*t + rn8)*t &
   & + rn7)*t + rn6)*t + rn5)*t + rn4)*t + rn3)*t &
   & + rn2)*t + rn1)*t + rn0) / &
   & ((rd2*t + rd1)*t + rd0)
bie = w/sqrt(rtx)
return
!
60 if (x > 1.e20) go to 70
t = 16.0/(x*rtx)
w = (((((((((((((sn13*t + sn12)*t + sn11)*t + sn10)*t &
   & + sn9)*t + sn8)*t + sn7)*t + sn6)*t + sn5)*t &
   & + sn4)*t + sn3)*t + sn2)*t + sn1)*t + sn0) / &
   & (sd1*t + sd0)
bie = w/sqrt(rtx)
return
!
70 bie = sn0/sqrt(rtx)
return
end function bie

pure elemental subroutine aimp(x, r, phi)
implicit none
real, intent(inout) :: phi, r
real, intent(in) :: x
real :: rtx, z
real, parameter :: pi4 = .785398163397448
real, parameter :: an0 = .297640916735064e+00
real, parameter :: an1 = .772796814419809e+00
real, parameter :: an2 = .764990563560236e+00
real, parameter :: an3 = .375694096095838e+00
real, parameter :: an4 = .978661044870204e-01
real, parameter :: an5 = .110446639522696e-01
real, parameter :: an6 = .145271249611697e-05
real, parameter :: ad0 = .100000000000000e+01
real, parameter :: ad1 = .247380029946443e+01
real, parameter :: ad2 = .240125897828762e+01
real, parameter :: ad3 = .118267264172257e+01
real, parameter :: ad4 = .306942883081787e+00
real, parameter :: ad5 = .347670057203535e-01
real, parameter :: bn0 = .593601051670149e+00
real, parameter :: bn1 = .223281495955754e+01
real, parameter :: bn2 = .317718143418600e+01
real, parameter :: bn3 = .229890914530923e+01
real, parameter :: bn4 = .933580623665765e+00
real, parameter :: bn5 = .209164380960390e+00
real, parameter :: bn6 = .207910965366403e-01
real, parameter :: bd0 = .100000000000000e+01
real, parameter :: bd1 = .345985556561483e+01
real, parameter :: bd2 = .479629661187354e+01
real, parameter :: bd3 = .345429311552596e+01
real, parameter :: bd4 = .140017214942186e+01
real, parameter :: bd5 = .313770549939860e+00
real, parameter :: bd6 = .311852186700025e-01
real, parameter :: cn0 = .313541841678871e+00
real, parameter :: cn1 = .470104287134296e+00
real, parameter :: cn2 = .291795874641314e+00
real, parameter :: cn3 = .962250689852768e-01
real, parameter :: cn4 = .171024484244850e-01
real, parameter :: cn5 = .134933201907052e-02
real, parameter :: cd0 = .100000000000000e+01
real, parameter :: cd1 = .148070947673639e+01
real, parameter :: cd2 = .917484386216329e+00
real, parameter :: cd3 = .302281922152536e+00
real, parameter :: cd4 = .537309296828367e-01
real, parameter :: cd5 = .423890576557513e-02
real, parameter :: cd6 = .525954318463502e-08
real, parameter :: dn0 = .654836896032068e+00
real, parameter :: dn1 = .117099614856528e+01
real, parameter :: dn2 = .831899010444840e+00
real, parameter :: dn3 = .301060337976575e+00
real, parameter :: dn4 = .564712748150658e-01
real, parameter :: dn5 = .444134415666317e-02
real, parameter :: dd0 = .100000000000000e+01
real, parameter :: dd1 = .176306543768126e+01
real, parameter :: dd2 = .124897609613487e+01
real, parameter :: dd3 = .451576491257036e+00
real, parameter :: dd4 = .847085955634988e-01
real, parameter :: dd5 = .666188176245820e-02
real, parameter :: dd6 = .537600060708764e-08
real, parameter :: pn0 = .318309886183791e+00
real, parameter :: pn1 = .100996327221962e+01
real, parameter :: pn2 = .902315148591491e+00
real, parameter :: pn3 = .259820640977615e+00
real, parameter :: pn4 = .203717769716282e-01
real, parameter :: pn5 = .216893438784765e-03
real, parameter :: pd0 = .100000000000000e+01
real, parameter :: pd1 = .317533460265059e+01
real, parameter :: pd2 = .284232123705698e+01
real, parameter :: pd3 = .822777439238360e+00
real, parameter :: pd4 = .656865942543526e-01
real, parameter :: pd5 = .775376048996392e-03
real, parameter :: qn0 = .666666666666667e+00
real, parameter :: qn1 = .141905542385598e+01
real, parameter :: qn2 = .772778148352443e+00
real, parameter :: qn3 = .115170415082442e+00
real, parameter :: qn4 = .326457319318373e-02
real, parameter :: qd0 = .100000000000000e+01
real, parameter :: qd1 = .213102454203392e+01
real, parameter :: qd2 = .116432601041188e+01
real, parameter :: qd3 = .175509465791633e+00
real, parameter :: qd4 = .528319849831061e-02
real, parameter :: qd5 = .867802002275824e-05
!-----------------------------------------------------------------------
!     Computation of the Airy modulus and phase for x .GE. 1
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
if (x > 2.0) go to 10
z = x - 1.0
r = ((((((an6*z + an5)*z + an4)*z + an3)*z + an2)*z &
   & + an1)*z + an0) / &
   & (((((ad5*z + ad4)*z + ad3)*z + ad2)*z + ad1)*z + ad0)
phi = ((((((bn6*z + bn5)*z + bn4)*z + bn3)*z + bn2)*z &
   & + bn1)*z + bn0) / &
   & ((((((bd6*z + bd5)*z + bd4)*z + bd3)*z + bd2)*z &
   & + bd1)*z + bd0)
go to 40
!
10 if (x >= 4.0) go to 20
z = x - 2.0
r = (((((cn5*z + cn4)*z + cn3)*z + cn2)*z + cn1)*z + cn0) / &
   & ((((((cd6*z + cd5)*z + cd4)*z + cd3)*z + cd2)*z &
   & + cd1)*z + cd0)
phi = (((((dn5*z + dn4)*z + dn3)*z + dn2)*z + dn1)*z + dn0) / &
   & ((((((dd6*z + dd5)*z + dd4)*z + dd3)*z + dd2)*z &
   & + dd1)*z + dd0)
go to 40
!
20 if (x > 1.e10) go to 30
z = 64.0/x**3
r = (((((pn5*z + pn4)*z + pn3)*z + pn2)*z + pn1)*z + pn0) / &
   & (((((pd5*z + pd4)*z + pd3)*z + pd2)*z + pd1)*z + pd0)
phi = ((((qn4*z + qn3)*z + qn2)*z + qn1)*z + qn0) / &
   & (((((qd5*z + qd4)*z + qd3)*z + qd2)*z + qd1)*z + qd0)
go to 40
!
30 r = pn0
phi = qn0
!
40 rtx = sqrt(x)
r = sqrt(r/rtx)
phi = pi4 + x*rtx*phi
return
end subroutine aimp

pure complex function ck(k,l)
implicit none
complex, intent(in) :: k, l
integer :: i, ind
real :: eps, phi, r, t, tol, u, v, x, xx, y
complex :: ak, al, ak1, al1, al2, ckk, ckp, f1, f2, f3, fxk, aktemp, ck1, z
logical :: branch
real, parameter :: x1(12) = [6.5487222790801e-03, 3.8946809560450e-02, 9.8150263106007e-02, 1.8113858159063e-01, &
   & 2.8322006766737e-01, 3.9843443516344e-01, 5.1995262679235e-01, 6.4051091671611e-01, 7.5286501205183e-01, 8.5024002416230e-01, &
   & 9.2674968322391e-01, 9.7775612969000e-01]
real, parameter :: w1(12) = [9.3192691443932e-02, 1.4975182757632e-01, 1.6655745436459e-01, 1.5963355943699e-01, &
   & 1.3842483186484e-01, 1.1001657063572e-01, 7.9961821770829e-02, 5.2406954824642e-02, 3.0071088873761e-02, 1.4249245587998e-02, &
   & 4.8999245823217e-03, 8.3402903805690e-04]
real, parameter :: fl(12) = [1.5708005371203e+00, 1.5709452753591e+00, 1.5717433742881e+00, 1.5740325056162e+00, &
   & 1.5787613653341e+00, 1.5867393901613e+00, 1.5983969635617e+00, 1.6135762587884e+00, 1.6313677113831e+00, 1.6500349733510e+00, &
   & 1.6671202200919e+00, 1.6798403417359e+00]
real, parameter :: x2(12) = [-9.8156063424672e-01, -9.0411725637048e-01, -7.6990267419431e-01, -5.8731795428662e-01, - &
   & 3.6783149899818e-01, -1.2523340851147e-01, 1.2523340851147e-01, 3.6783149899818e-01, 5.8731795428662e-01, 7.6990267419431e-01 &
   & , 9.0411725637048e-01, 9.8156063424672e-01]
real, parameter :: w2(12) = [4.7175336386512e-02, 1.0693932599532e-01, 1.6007832854335e-01, 2.0316742672307e-01, &
   & 2.3349253653836e-01, 2.4914704581340e-01, 2.4914704581340e-01, 2.3349253653836e-01, 2.0316742672307e-01, 1.6007832854335e-01, &
   & 1.0693932599532e-01, 4.7175336386512e-02]
real, parameter :: fa(12) = [2.0794472764428e+00, 2.0795966441739e+00, 2.0803359313463e+00, 2.0823286205438e+00, &
   & 2.0862633195105e+00, 2.0926508621232e+00, 2.1016440761258e+00, 2.1128974786197e+00, 2.1254857173540e+00, 2.1379218133017e+00, &
   & 2.1483404506064e+00, 2.1548934173960e+00]
real, parameter :: fb(12) = [1.5744273529551e+00, 1.5899097325063e+00, 1.6176685384410e+00, 1.6574605448620e+00, &
   & 1.7087245795822e+00, 1.7703459462057e+00, 1.8403280188791e+00, 1.9154060277115e+00, 1.9907093877047e+00, 2.0596975322636e+00, &
   & 2.1146977530430e+00, 2.1482986855683e+00]
complex, parameter :: j = (0.0, 1.0)
real, parameter :: ln4 = 1.3862943611199
real, parameter :: c1 = .20264236728467
real, parameter :: c2 = .15915494309189
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function cflect(z)
      implicit none
      complex, intent(in) :: z
      complex :: cflect
   end function cflect
   pure subroutine kl(l,fk,fl)
      implicit none
      complex, intent(in) :: l
      complex, intent(inout) :: fk
      complex, intent(inout) :: fl
   end subroutine kl
   pure function km(k2)
      implicit none
      complex, intent(in) :: k2
      complex :: km
   end function km
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     ------------------------------------------------------------------
!     This function calculates the complete elliptic integral F(k)
!     for complex values of the modulus k. it is assumed that l.NE.0
!     and that k**2 + l**2 = 1.
!     ------------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     ---------------------------------------------------
!
!     Eps is a machine dependent constant.  Eps is the
!     smallest number such that 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     ---------------------------------------------------
if (l == (0.0, 0.0)) go to 200
ind = 0
branch = .true.
tol = 8.0*max(eps, 1.e-14)
!
ak1 = cflect(k)
al1 = cflect(l)
ak = ak1
al = al1
!
x = real(ak)
y = aimag(ak)
u = real(al)
v = aimag(al)
if (max(x,abs(y)) >= 1.0/eps) go to 90
if (max(u,abs(v)) >= 1.1/eps) go to 200
!
!     Check that k**2 + l**2 = 1
!
if (x < u) go to 1
t = u/x
if (abs(x*x/(v*v + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 200
if (abs(y + t*v) > tol*max(1.0, abs(v))) go to 200
go to 10
1 t = x/u
if (abs(u*u/(y*y + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 200
if (abs(v + t*y) > tol*max(1.0, abs(y))) go to 200
!
!     Uses  logarithmic series when cabs(al)
!     is less than or equal to 0.55
!
10 if (u > 1.42 .or. abs(v) > 1.42) go to 50
11 if (abs(al) > 0.55) go to 20
call kl(al,ckk,ckp)
if (branch) go to 22
ck1 = ckk
ck = ckp
al = ak
go to 80
!
!     Uses Maclaurin expansion when the absolute value of
!     the modulus ak is less than or equal to 0.55
!
20 r = abs(ak)
if (r > 0.55) go to 30
if (branch) go to 21
call kl(ak,ckp,ck1)
ck = ckp
al = ak
go to 80
21 ckk = km(ak*ak)
22 ck = ckk
go to 70
!
!     Numerical quadrature approximation
!
30 if (ind == 0 .and. r > 1.0) go to 50
31 al2 = al*al
!
f1 = (0.0, 0.0)
do 40 i = 1,12
   xx = x1(i)/2.
   fxk = ak*xx
40 f1 = f1 + w1(i)*fl(i)/(al2 + fxk*fxk)
f2 = (0.0, 0.0)
do 41 i = 1,12
   xx = .25*(1. + x2(i))
   fxk = ak*xx
41 f2 = f2 + w2(i)*fa(i)/(al2 + fxk*fxk)
f3 = (0.0, 0.0)
do 42 i = 1,12
   xx = .25*(3. - x2(i))
   fxk = ak*xx
42 f3 = f3 + w2(i)*fb(i)/(al2 + fxk*fxk)
!
ck = al*(c1*f1 + c2*(f2 + f3))
!
!     END OF NUMERICAL QUADRATURE APPROXIMATION
!
if (branch) go to 70
ck1 = ck
branch = .true.
!
!     Interchange ak and al
!
aktemp = ak
ak = al
al = aktemp
go to 31
!
!     Uses inverse modulus transformation when cabs(ak) is greater
!     than 1 and real(ak**2) is greater than 0.5.
!
50 if (x*x <= y*y + 0.5) go to 60
ind = 1
branch = .false.
ak = 1.0/ak1
al = cflect(j*al1/ak1)
go to 11
!
!     Uses complementary inverse modulus transformation when cabs(ak)
!     is greater than 1 and real(ak**2) is less than or equal to 0.5
!
60 ind = 2
ak = cflect(j*ak1/al1)
al = 1.0/al1
go to 11
!
!     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
!
70 if (ind == 0) return
if (ind == 1) go to 80
!
!     Complementary inverse modulus transformation
!
ck = al*ck
return
!
!     Inverse modulus transformation
!
80 if (aimag(ak1) >= 0.0) go to 81
ck = al*(ck1 - j*ck)
return
81 ck = al*(ck1 + j*ck)
return
!
!     Calculation of F(k) for large k and l
!
90 if (x <= abs(y)) go to 100
if (abs(abs(v/x) - 1.0) > tol) go to 200
if (abs(u/x + y/v) > tol) go to 200
t = y/x
phi = atan2(x,abs(y))
r = (ln4 + 0.5*alnrel(t*t)) + log(x)
if (y < 0.0) r = -r
ck = (cmplx(phi,r)/cmplx(1.0,t))/x
return
!
100 if (abs(abs(u/y) - 1.0) > tol) go to 200
if (abs(x/u + v/y) > tol) go to 200
t = v/u
z = cmplx((ln4 + 0.5*alnrel(t*t)) + log(u), atan2(v,u))
ck = (z/cmplx(1.0,t))/u
return
!
!     Error return
!
200 ck = (0.0, 0.0)
return
end function ck

pure elemental complex function cflect(z)
implicit none
!---------------------------------------------------------
!     Reflects z with respect to the origin if real(z)
!     .LT. 0.0 or if z is on the negative imaginary axis.
!---------------------------------------------------------
complex, intent(in) :: z
!     ----------
if (real(z)) 10,20,30
10 cflect = -z
return
20 cflect = cmplx(0.0, abs(aimag(z)))
return
30 cflect = z
return
end function cflect

pure complex function km(k2)
implicit none
complex, intent(in) :: k2
integer :: i
real :: c, eps, ri, tol
complex :: an, s1
real, parameter :: hpi = 1.5707963267949
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!---------------------------------------------------------------------
!     km computes the complete elliptic integral F(K) for a given
!     value of k2 = K**2 by use of the Maclaurin expansion.
!---------------------------------------------------------------------
! ---------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
! ---------------
!
tol = max(eps,1.e-14)
s1 = (1.0, 0.0)
an = (1.0, 0.0)
do i = 1,50
   ri = i
   c = ((ri - 0.5)/ri)**2
   an = c*(an*k2)
   s1 = s1 + an
   if (abs(real(an)) + abs(aimag(an)) < tol) go to 20
end do
!
20 km = hpi*s1
return
end function km

pure subroutine kl(l, fk, fl)
implicit none
complex, intent(in) :: l
complex, intent(inout) :: fk, fl
integer :: i
real :: bn, c, eps, ri, tol, u, x, y
complex :: an, l2, s1, s2, w
real, parameter :: hpi = 1.5707963267949
real, parameter :: ln4 = 1.3862943611199
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!     kl computes the complete elliptic integrals F(K) and F(l) for
!     a given value of l, where cabs(l) .LT. 1 and K**2 + l**2 = 1.
!     It is assumed that -Pi .LE. arg(l**2) .LT. pi for the resulting
!     value for F(K) to be meaningful.
! ----------------------------------------------------------------------
!     --------------
! ---------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
! ---------------
!
!            The logarithmic expansion is used for F(K)
!              and the Maclaurin expansion for F(l)
!
tol = max(eps,1.e-14)
l2 = l*l
s1 = (0.0, 0.0)
s2 = (0.0, 0.0)
an = (1.0, 0.0)
bn = 0.0
do i = 1,50
   ri = i
   c = ((ri - 0.5)/ri)**2
   an = c*(an*l2)
   bn = bn + 1.0/(ri*(2.0*ri - 1.0))
   s1 = s1 + an
   s2 = s2 + an*bn
   if (abs(real(an)) + abs(aimag(an)) < tol) go to 20
end do
20 s1 = s1 + (1.0, 0.0)
!
!                   SET w = 0.5*CLOG(16.0/l2)
!
x = real(l)
y = aimag(l)
if (x /= 0.0) go to 30
w = cmplx(ln4 - log(abs(y)), hpi)
go to 50
!
30 if (abs(x) > abs(y)) go to 31
u = (ln4 - 0.5*alnrel((x/y)**2)) - log(abs(y))
go to 40
31 u = (ln4 - 0.5*alnrel((y/x)**2)) - log(abs(x))
!
40 if (x > 0.0) go to 41
w = cmplx(u, -atan2(-y,-x))
go to 50
41 w = cmplx(u, -atan2(y,x))
!
!                        Final assembly
!
50 fk = w*s1 - s2
fl = hpi*s1
return
end subroutine kl

pure elemental subroutine cke(k,l,ck,ce,ierr)
implicit none
integer, intent(inout) :: ierr
complex, intent(in) :: k, l
complex, intent(inout) :: ce, ck
integer :: i, ind
real :: c, eps, phi, r, t, tol, u, v, x, xx, y
complex :: ak, al, ak1, al1, ckk, ckp, f1, f2, f3, aktemp, ck1, cee, cep, ce1, e1, e2, e3, at, fx, fxk, k1, l1, ak2, al2, z, g, &
   & g1, gg, gp
logical :: branch
real, parameter :: x1(12) = [6.5487222790801e-03, 3.8946809560450e-02, 9.8150263106007e-02, 1.8113858159063e-01, &
   & 2.8322006766737e-01, 3.9843443516344e-01, 5.1995262679235e-01, 6.4051091671611e-01, 7.5286501205183e-01, 8.5024002416230e-01, &
   & 9.2674968322391e-01, 9.7775612969000e-01]
real, parameter :: w1(12) = [9.3192691443932e-02, 1.4975182757632e-01, 1.6655745436459e-01, 1.5963355943699e-01, &
   & 1.3842483186484e-01, 1.1001657063572e-01, 7.9961821770829e-02, 5.2406954824642e-02, 3.0071088873761e-02, 1.4249245587998e-02, &
   & 4.8999245823217e-03, 8.3402903805690e-04]
real, parameter :: fl(12) = [1.5708005371203e+00, 1.5709452753591e+00, 1.5717433742881e+00, 1.5740325056162e+00, &
   & 1.5787613653341e+00, 1.5867393901613e+00, 1.5983969635617e+00, 1.6135762587884e+00, 1.6313677113831e+00, 1.6500349733510e+00, &
   & 1.6671202200919e+00, 1.6798403417359e+00]
real, parameter :: x2(12) = [-9.8156063424672e-01, -9.0411725637048e-01, -7.6990267419431e-01, -5.8731795428662e-01, - &
   & 3.6783149899818e-01, -1.2523340851147e-01, 1.2523340851147e-01, 3.6783149899818e-01, 5.8731795428662e-01, 7.6990267419431e-01 &
   & , 9.0411725637048e-01, 9.8156063424672e-01]
real, parameter :: w2(12) = [4.7175336386512e-02, 1.0693932599532e-01, 1.6007832854335e-01, 2.0316742672307e-01, &
   & 2.3349253653836e-01, 2.4914704581340e-01, 2.4914704581340e-01, 2.3349253653836e-01, 2.0316742672307e-01, 1.6007832854335e-01, &
   & 1.0693932599532e-01, 4.7175336386512e-02]
real, parameter :: fa(12) = [2.0794472764428e+00, 2.0795966441739e+00, 2.0803359313463e+00, 2.0823286205438e+00, &
   & 2.0862633195105e+00, 2.0926508621232e+00, 2.1016440761258e+00, 2.1128974786197e+00, 2.1254857173540e+00, 2.1379218133017e+00, &
   & 2.1483404506064e+00, 2.1548934173960e+00]
real, parameter :: fb(12) = [1.5744273529551e+00, 1.5899097325063e+00, 1.6176685384410e+00, 1.6574605448620e+00, &
   & 1.7087245795822e+00, 1.7703459462057e+00, 1.8403280188791e+00, 1.9154060277115e+00, 1.9907093877047e+00, 2.0596975322636e+00, &
   & 2.1146977530430e+00, 2.1482986855683e+00]
complex, parameter :: j = (0.0, 1.0)
real, parameter :: ln4 = 1.3862943611199
real, parameter :: c1 = .20264236728467
real, parameter :: c2 = .15915494309189
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function atn(z)
      implicit none
      complex, intent(in) :: z
      complex :: atn
   end function atn
   pure elemental function cflect(z)
      implicit none
      complex, intent(in) :: z
      complex :: cflect
   end function cflect
   pure elemental subroutine ekl(l,fk,fl,ek,el,gk,gl)
      implicit none
      complex, intent(in) :: l
      complex, intent(inout) :: fk
      complex, intent(inout) :: fl
      complex, intent(inout) :: ek
      complex, intent(inout) :: el
      complex, intent(inout) :: gk
      complex, intent(inout) :: gl
   end subroutine ekl
   pure elemental subroutine ekm(k2,fk,ek)
      implicit none
      complex, intent(in) :: k2
      complex, intent(inout) :: fk
      complex, intent(inout) :: ek
   end subroutine ekm
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     ------------------------------------------------------------------
!     This function calculates the complete elliptic integrals F(k)
!     and E(k) for complex values of the modulus k. it is assumed
!     that l.NE.0 and that k**2 + l**2 = 1.
!     ------------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     --------------------------------------------------------------
!     ---------------------------------------------------
!
!     Eps is a machine dependent constant.  Eps is the
!     smallest number such that 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     ---------------------------------------------------
if (l == (0.0, 0.0)) go to 200
ind = 0
branch = .true.
tol = 8.0*max(eps, 1.e-14)
!
ak1 = cflect(k)
al1 = cflect(l)
ak = ak1
al = al1
ierr = 0
!
x = real(ak)
y = aimag(ak)
u = real(al)
v = aimag(al)
if (max(x,abs(y)) >= 1.0/eps) go to 90
if (max(u,abs(v)) >= 1.1/eps) go to 210
!
!     Check that k**2 + l**2 = 1
!
if (x < u) go to 1
t = u/x
if (abs(x*x/(v*v + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 210
if (abs(y + t*v) > tol*max(1.0, abs(v))) go to 210
go to 10
1 t = x/u
if (abs(u*u/(y*y + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 210
if (abs(v + t*y) > tol*max(1.0, abs(y))) go to 210
!
!     Uses  logarithmic series when cabs(al)
!     is less than or equal to 0.55
!
10 if (u > 1.42 .or. abs(v) > 1.42) go to 50
11 if (abs(al) > 0.55) go to 20
call ekl(al,ckk,ckp,cee,cep,gg,gp)
if (branch) go to 22
ck1 = ckk
ck = ckp
ce1 = cee
ce = cep
g1 = gg
g = gp
ak2 = al*al
al = ak
al2 = al*al
go to 81
!
!     Uses Maclaurin expansion when the absolute value of
!     the modulus ak is less than or equal to 0.55
!
20 r = abs(ak)
if (r > 0.55) go to 30
if (branch) go to 21
call ekl(ak,ckp,ck1,cep,ce1,gp,g1)
ck = ckp
ce = cep
g = gp
ak2 = al*al
al = ak
al2 = al*al
go to 81
21 call ekm(ak*ak,ckk,cee)
22 ck = ckk
ce = cee
go to 70
!
!     Numerical quadrature approximation
!
30 if (ind == 0 .and. r > 1.0) go to 50
31 al2 = al*al
ak2 = ak*ak
!
f1 = (0.0, 0.0)
e1 = (0.0, 0.0)
do 40 i = 1,12
   xx = x1(i)/2.
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e1 = e1 + w1(i)*fl(i)*(1.0 + at)
40 f1 = f1 + w1(i)*fl(i)/(al2 + fxk*fxk)
f2 = (0.0, 0.0)
e2 = (0.0, 0.0)
do 41 i = 1,12
   xx = .25*(1. + x2(i))
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e2 = e2 + w2(i)*fa(i)*(1.0 + at)
41 f2 = f2 + w2(i)*fa(i)/(al2 + fxk*fxk)
f3 = (0.0, 0.0)
e3 = (0.0, 0.0)
do 42 i = 1,12
   xx = .25*(3. - x2(i))
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e3 = e3 + w2(i)*fb(i)*(1.0 + at)
42 f3 = f3 + w2(i)*fb(i)/(al2 + fxk*fxk)
!
ck = al*(c1*f1 + c2*(f2 + f3))
ce = al*(c1*e1 + c2*(e2 + e3))
!
!     END OF NUMERICAL QUADRATURE APPROXIMATION
!
if (branch) go to 70
ck1 = ck
ce1 = ce
branch = .true.
!
!     Interchange ak and al
!
aktemp = ak
ak = al
al = aktemp
go to 31
!
!     Uses inverse modulus transformation when cabs(ak) is greater
!     than 1 and real(ak**2) is greater than 0.5.
!
50 if (x*x <= y*y + 0.5) go to 60
ind = 1
branch = .false.
ak = 1.0/ak1
al = cflect(j*al1/ak1)
go to 11
!
!     Uses complementary inverse modulus transformation when cabs(ak)
!     is greater than 1 and real(ak**2) is less than or equal to 0.5
!
60 ind = 2
ak = cflect(j*ak1/al1)
al = 1.0/al1
go to 11
!
!     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
!
70 if (ind == 0) return
if (ind == 1) go to 80
!
!     Complementary inverse modulus transformation
!
ck = al*ck
ce = ce/al
return
!
!     Inverse modulus transformation
!
80 g = ce - al2*ck
g1 = ce1 - ak2*ck1
81 if (aimag(ak2) >= 0.0) go to 82
ce = (g1 + j*g)/al
ck = al*(ck1 - j*ck)
return
82 ce = (g1 - j*g)/al
ck = al*(ck1 + j*ck)
return
!
!     Calculation of F(k) and E(k) for large k and l
!
90 if (x <= abs(y)) go to 100
if (abs(abs(v/x) - 1.0) > tol) go to 210
if (abs(u/x + y/v) > tol) go to 210
t = y/x
k1 = cmplx(1.0,t)
phi = atan2(x,abs(y))
r = (ln4 + 0.5*alnrel(t*t)) + log(x)
c = 0.5*r + 0.25
z = cmplx(y,-x)
if (y >= 0.0) go to 91
r = -r
c = -c
z = -z
91 ck = (cmplx(phi,r)/k1)/x
ce = z + (cmplx(0.5*phi,c)/k1)/x
return
!
100 if (abs(abs(u/y) - 1.0) > tol) go to 210
if (abs(x/u + v/y) > tol) go to 210
t = v/u
l1 = cmplx(1.0,t)
r = (ln4 + 0.5*alnrel(t*t)) + log(u)
phi = atan2(v,u)
ck = (cmplx(r, phi)/l1)/u
ce = al + (cmplx(0.5*r - 0.25, 0.5*phi)/l1)/u
return
!
!     Error return
!
200 ierr = 1
return
210 ierr = 2
return
end subroutine cke

pure elemental complex function atn(z)
implicit none
complex, intent(in) :: z
real :: atn1, atn2, d, da, db, t, x, y
double precision :: dx, dy
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
end interface
!---------------------------------------------------
!     Calculates complex function atn(z) = z*atan(z)
!     using double precision.
!---------------------------------------------------
x = real(z)
y = aimag(z)
dx = x
dy = y
t = 1.d0 - dx*dx - dy*dy
da = -0.5*atan2(-2.0*x, t)
d = (1.0 - dy)**2 + dx*dx
db = 0.25*alnrel(4.0*y/d)
atn1 = da*x - db*y
atn2 = da*y + db*x
atn = cmplx(atn1, atn2)
return
end function atn

pure elemental subroutine ekm(k2, fk, ek)
implicit none
complex, intent(in) :: k2
complex, intent(inout) :: fk, ek
integer :: i
real :: c, eps, ri, tol
complex :: an, cn, s1, s2
real, parameter :: hpi = 1.5707963267949
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!     ekm computes the complete elliptic integrals F(K) and E(K) for
!     a given value of k2 = K**2 by use of the Maclaurin expansions.
! ----------------------------------------------------------------------
! ---------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
! ---------------
!
tol = max(eps,1.e-14)
s1 = (1.0, 0.0)
s2 = (1.0, 0.0)
an = (1.0, 0.0)
do i = 1,50
   ri = i
   c = ((ri - 0.5)/ri)**2
   an = c*(an*k2)
   cn = an/(2.0*ri - 1.0)
   s1 = s1 + an
   s2 = s2 - cn
   if (abs(real(an)) + abs(aimag(an)) < tol) go to 20
end do
!
20 fk = hpi*s1
ek = hpi*s2
return
end subroutine ekm

pure elemental subroutine ekl(l,fk,fl,ek,el,gk,gl)
implicit none
complex, intent(in) :: l
complex, intent(inout) :: fk, fl, ek, el, gk, gl
integer :: i
real :: bn, c, dn, eps, fn, gn, ri, tol, u, x, y
complex :: l2, an, cn, en, s1, s2, s3, s4, s5, s6, s7, w
real, parameter :: hpi = 1.5707963267949
real, parameter :: ln4 = 1.3862943611199
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!     ekl computes the complete elliptic integrals F(K), F(l), E(K),
!     E(l) for a given value of l2, where l2 = l**2 and K**2 + l**2 = 1.
!     It is assumed that -Pi .LT. arg(l2) .LE. pi for the resulting
!     value for F(K) to be meaningful.  The combinations of functions
!     G(K) = E(K) - l**2*F(K) and G(l) = E(l) - K**2*F(l) are also
!     calculated.
! ----------------------------------------------------------------------
!     ------------------
! ---------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
! ---------------
!
!            The logarithmic expansions are used for F(K) and E(K)
!            and the Maclaurin expansions for F(l) and E(l)
!
tol = max(eps,1.e-14)
l2 = l*l
s1 = (0.0, 0.0)
s2 = (0.0, 0.0)
s3 = (0.0, 0.0)
s4 = (0.0, 0.0)
s5 = (0.0, 0.0)
s6 = (0.0, 0.0)
s7 = (0.0, 0.0)
an = (1.0, 0.0)
bn = 0.0
do i = 1,300
   ri = i
   c = ((ri - 0.5)/ri)**2
   an = c*(an*l2)
   bn = bn + 1.0/(ri*(2.0*ri - 1.0))
   cn = an/(2.0*ri - 1.0)
   dn = bn*ri/(ri - 0.5)
   en = cn/(2.0*ri - 1.0)
   fn = ri/(ri - 0.5)
   gn = 0.5/(ri + 1.0)
   s1 = s1 + an
   s2 = s2 + an*bn
   s3 = s3 - cn
   s4 = s4 + an*dn
   s5 = s5 + en
   s6 = s6 + an*fn
   s7 = s7 + an*gn
   if (abs(real(an)) + abs(aimag(an)) < tol) go to 20
end do
20 s1 = s1 + (1.0, 0.0)
s3 = s3 + (1.0, 0.0)
s5 = s5 + (1.0, 0.0)
s7 = s7 + (0.5, 0.0)
!
!              SET w = 0.5*CLOG(16.0/l2)
!
x = real(l)
y = aimag(l)
if (x /= 0.0) go to 30
w = cmplx(ln4 - log(abs(y)), hpi)
go to 50
!
30 if (abs(x) > abs(y)) go to 31
u = (ln4 - 0.5*alnrel((x/y)**2)) - log(abs(y))
go to 40
31 u = (ln4 - 0.5*alnrel((y/x)**2)) - log(abs(x))
!
40 if (x > 0.0) go to 41
w = cmplx(u, -atan2(-y,-x))
go to 50
41 w = cmplx(u, -atan2(y,x))
!
!              Final assembly
!
50 fk = w*s1 - s2
fl = hpi*s1
ek = w*s6 - s4 + s5
el = hpi*s3
gk = -w*s7*l2 - s4 + s5 + s2*l2
gl = hpi*s7*l2
return
end subroutine ekl

pure elemental subroutine ellpi(phi, cphi, k, l, f, e, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: cphi
real, intent(inout) :: e, f
real, intent(in) :: phi
real, intent(in) :: k, l
real :: an, cn, d1, d2, d3, d4, dn, hn, p, pn, px, qn, qx, r, r0, r2, ri, rj, rk, rm, rn, s0, s1, s2, s3, s4, si, sj, sk, sn, ss, &
   & t1, t2, td, tr, ts, w, k2, l2
real, parameter :: ln4 = 1.3862943611199
real, parameter :: th1 = .76159415595576
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!-----------------------------------------------------------------------
!
!          Real elliptic integrals of the first and second kinds
!
!                        -----------------
!
!     phi = argument                    (0.0 .le. phi  .le. pi/2)
!     cphi = pi/2 - phi                 (0.0 .le. cphi .le. pi/2)
!     k = modulus                       (abs(k) .le. 1.0)
!     l = comodulus = sqrt (1 - k*k)    (abs(l) .le. 1.0)
!     f = Elliptic integral of first kind = f(phi, k)
!     e = Elliptic integral of second kind = e(phi, k)
!     ierr = ERROR INDICATOR (ierr = 0  IF NO ERRORS)
!-----------------------------------------------------------------------
!------------------------
!     ln4 = ln(4)
!     th1 = tanh(1)
!------------------------
!------------------------
if (phi < 0.0 .or. cphi < 0.0) go to 100
if (abs(k) > 1.0 .or. abs(l) > 1.0) go to 110
ierr = 0
if (phi /= 0.0) go to 10
f = 0.0
e = 0.0
return
!
10 if (phi < 0.79) go to 11
sn = cos(cphi)
cn = sin(cphi)
go to 20
11 sn = sin(phi)
cn = cos(phi)
!
20 k2 = k*k
l2 = l*l
ss = sn*sn
px = abs(k*sn)
qx = abs(k*cn)
if (px >= th1) go to 50
!
!     Series expansion for abs(k*sin(phi)) .LE. tanh(1)
!
pn = 1.0
qn = 2.0
an = phi
hn = 1.0
s1 = 0.0
s2 = 0.0
tr = phi*ss
ts = sn*cn
!
30 an = (pn*an - ts)/qn
r = k2*hn/qn
s2 = s2 + r*an
hn = pn*r
s0 = s1
s1 = s1 + hn*an
if (abs(tr) < abs(an)) go to 40
if (abs(s1) <= abs(s0)) go to 40
pn = qn + 1.0
qn = pn + 1.0
tr = ss*tr
ts = ss*ts
go to 30
!
40 f = phi + s1
e = phi - s2
return
!
!     Series expansion for abs(k*sin(phi)) .GT. tanh(1)
!
50 r = cpabs(l,qx)
if (r == 0.0) go to 120
r2 = r*r
si = 1.0
sj = 1.0
sk = 0.0
rm = 0.0
rn = 0.0
s1 = 0.0
s2 = 0.0
s3 = 0.0
s4 = 0.0
td = qx*r
dn = 2.0
go to 70
!
60 si = ri
sj = rj
sk = rk
dn = dn + 2.0
td = r2*td
70 pn = (dn - 1.0)/dn
qn = (dn + 1.0)/(dn + 2.0)
ri = pn*si
rj = pn*pn*l2*sj
rk = sk + 2.0/(dn*(dn - 1.0))
r0 = td/dn
rm = qn*qn*l2*(rm - r0*ri)
rn = pn*qn*l2*(rn - r0*si)
d1 = rj
d2 = qn*rj
d3 = rm - rj*rk
d4 = rn - pn*l2*sj*rk + l2*sj/(dn*dn)
r0 = s3
s1 = s1 + d1
s2 = s2 + d2
s3 = s3 + d3
s4 = s4 + d4
if (s3 < r0) go to 60
!
w = 1.0 + px
p = ln4 - log(r + qx)
t1 = (1.0 + s1)*p + qx/r*alnrel(-0.5*r2/w)
t2 = (0.5 + s2)*l2*p + (1.0 - qx*r/w)
f = t1 + s3
e = t2 + s4
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine ellpi

pure elemental subroutine dellpi(phi, cphi, k, l, f, e, ierr)
implicit none
integer, intent(inout) :: ierr
double precision, intent(in) :: phi, cphi, k, l
double precision, intent(inout) :: f, e
double precision :: an, cn, dn, d1, d2, d3, d4, hn, k2, l2, p, pn, px, qn, qx, r, ri, rj, rk, rm, rn, r0, r2, si, sj, sk, sn, ss, &
   & s0, s1, s2, s3, s4, td, tr, ts, t1, t2, w
double precision, parameter :: ln4 = .1386294361119890618834464242916353136151d+01
double precision, parameter :: th1 = .7615941559557648881194582826047935904128d+00
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure elemental function dlnrel(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dlnrel
   end function dlnrel
end interface
!-----------------------------------------------------------------------
!
!                  Double precision computation of the
!          real elliptic integrals of the first and second kinds
!
!                        -----------------
!
!     phi = argument                    (0.0 .le. phi  .le. pi/2)
!     cphi = pi/2 - phi                 (0.0 .le. cphi .le. pi/2)
!     k = modulus                       (dabs(k) .le. 1.0)
!     l = comodulus = sqrt (1 - k*k)    (dabs(l) .le. 1.0)
!     f = Elliptic integral of first kind = f(phi, k)
!     e = Elliptic integral of second kind = e(phi, k)
!     ierr = ERROR INDICATOR (ierr = 0  IF NO ERRORS)
!-----------------------------------------------------------------------
!------------------------
!     ln4 = ln(4)
!     th1 = tanh(1)
!------------------------
!------------------------
if (phi < 0.d0 .or. cphi < 0.d0) go to 100
if (abs(k) > 1.d0 .or. abs(l) > 1.d0) go to 110
ierr = 0
if (phi /= 0.d0) go to 10
f = 0.d0
e = 0.d0
return
!
10 if (phi < 0.79d0) go to 11
sn = cos(cphi)
cn = sin(cphi)
go to 20
11 sn = sin(phi)
cn = cos(phi)
!
20 k2 = k*k
l2 = l*l
ss = sn*sn
px = abs(k*sn)
qx = abs(k*cn)
if (px >= th1) go to 50
!
!     Series expansion for abs(k*sin(phi)) .LE. tanh(1)
!
pn = 1.d0
qn = 2.d0
an = phi
hn = 1.d0
s1 = 0.d0
s2 = 0.d0
tr = phi*ss
ts = sn*cn
!
30 an = (pn*an - ts)/qn
r = k2*hn/qn
s2 = s2 + r*an
hn = pn*r
s0 = s1
s1 = s1 + hn*an
if (abs(tr) < abs(an)) go to 40
if (abs(s1) <= abs(s0)) go to 40
pn = qn + 1.d0
qn = pn + 1.d0
tr = ss*tr
ts = ss*ts
go to 30
!
40 f = phi + s1
e = phi - s2
return
!
!     Series expansion for abs(k*sin(phi)) .GT. tanh(1)
!
50 r = dcpabs(l,qx)
if (r == 0.d0) go to 120
r2 = r*r
si = 1.d0
sj = 1.d0
sk = 0.d0
rm = 0.d0
rn = 0.d0
s1 = 0.d0
s2 = 0.d0
s3 = 0.d0
s4 = 0.d0
td = qx*r
dn = 2.d0
go to 70
!
60 si = ri
sj = rj
sk = rk
dn = dn + 2.d0
td = r2*td
70 pn = (dn - 1.d0)/dn
qn = (dn + 1.d0)/(dn + 2.d0)
ri = pn*si
rj = pn*pn*l2*sj
rk = sk + 2.d0/(dn*(dn - 1.d0))
r0 = td/dn
rm = qn*qn*l2*(rm - r0*ri)
rn = pn*qn*l2*(rn - r0*si)
d1 = rj
d2 = qn*rj
d3 = rm - rj*rk
d4 = rn - pn*l2*sj*rk + l2*sj/(dn*dn)
r0 = s3
s1 = s1 + d1
s2 = s2 + d2
s3 = s3 + d3
s4 = s4 + d4
if (s3 < r0) go to 60
!
w = 1.d0 + px
p = ln4 - log(r + qx)
t1 = (1.d0 + s1)*p + qx/r*dlnrel(-0.5d0*r2/w)
t2 = (0.5d0 + s2)*l2*p + (1.d0 - qx*r/w)
f = t1 + s3
e = t2 + s4
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine dellpi

pure elemental subroutine epi(phi, cphi, k2, l2, n, m, p, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: phi, cphi, k2, l2, n, m
real, intent(inout) :: p
real :: a, b, c, eps, r, rf, s, s2, tol
real, parameter :: pihalf = 1.5707963267948966192
interface
   pure elemental subroutine rfval(x,y,z,rf,ierr)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(in) :: z
      real, intent(inout) :: rf
      integer, intent(inout) :: ierr
   end subroutine rfval
   pure elemental subroutine rjval(x,y,z,p,rj,ierr)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(in) :: z
      real, intent(in) :: p
      real, intent(inout) :: rj
      integer, intent(inout) :: ierr
   end subroutine rjval
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!             Real elliptic integral of the third kind
!-----------------------------------------------------------------------
!---------------------
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
tol = 4.0 * eps
if (min(phi,cphi) < 0.0) go to 100
if (abs((phi + cphi) - pihalf) > tol * pihalf) go to 100
if (abs(n) > 1.0) go to 110
if (k2 < 0.0 .or. l2 < 0.0) go to 120
if (abs((k2 + l2) - 1.0) > tol) go to 120
!
if (phi < 0.79) go to 10
s = cos(cphi)
c = sin(cphi)
go to 11
10 s = sin(phi)
c = cos(phi)
11 a = c*c
b = l2 + k2*a
s2 = s*s
!
if (n > 0.0) go to 20
r = 1.0 - n*s2
go to 30
20 if (m < 0.0 .or. m > 1.0) go to 110
if (abs((m + n) - 1.0) > tol) go to 110
r = m + n*a
!
30 call rjval(a, b, 1.0, r, p, ierr)
if (ierr /= 0) go to 130
p = p * (s * s2) * n/3.0
call rfval(a, b, 1.0, rf, ierr)
p = p + s * rf
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine epi

pure elemental subroutine depi(phi, cphi, k2, l2, n, m, p, ierr)
implicit none
integer, intent(inout) :: ierr
double precision, intent(in) :: phi, cphi, k2, l2, n, m
double precision, intent(inout) :: p
double precision :: a, b, c, eps, r, rf, s, s2, tol
double precision, parameter :: pihalf = 1.570796326794896619231321691639751442099d0
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental subroutine drfval(x,y,z,rf,ierr)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision, intent(in) :: z
      double precision, intent(inout) :: rf
      integer, intent(inout) :: ierr
   end subroutine drfval
   pure elemental subroutine drjval(x,y,z,p,rj,ierr)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision, intent(in) :: z
      double precision, intent(in) :: p
      double precision, intent(inout) :: rj
      integer, intent(inout) :: ierr
   end subroutine drjval
end interface
!-----------------------------------------------------------------------
!               Double precision computation of the
!             real elliptic integral of the third kind
!-----------------------------------------------------------------------
!---------------------
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0.
!
eps = dpmpar(1)
!
!-----------------------------------------------------------------------
tol = 4.d0 * eps
if (min(phi,cphi) < 0.d0) go to 100
if (abs((phi + cphi) - pihalf) > tol * pihalf) go to 100
if (abs(n) > 1.d0) go to 110
if (k2 < 0.d0 .or. l2 < 0.d0) go to 120
if (abs((k2 + l2) - 1.d0) > tol) go to 120
!
if (phi < 0.79d0) go to 10
s = cos(cphi)
c = sin(cphi)
go to 11
10 s = sin(phi)
c = cos(phi)
11 a = c*c
b = l2 + k2*a
s2 = s*s
!
if (n > 0.d0) go to 20
r = 1.d0 - n*s2
go to 30
20 if (m < 0.d0 .or. m > 1.d0) go to 110
if (abs((m + n) - 1.d0) > tol) go to 110
r = m + n*a
!
30 call drjval(a, b, 1.d0, r, p, ierr)
if (ierr /= 0) go to 130
p = p * (s * s2) * n/3.d0
call drfval(a, b, 1.d0, rf, ierr)
p = p + s * rf
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
return
end subroutine depi

pure elemental subroutine rfval(x, y, z, rf, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the first kind
!
!          rf(x,y,z) = Integral from zero to infinity of
!
!                                -1/2     -1/2     -1/2
!                      (1/2)(T+x)    (T+y)    (T+z)    DT,
!
!          Where x, y, and z are nonnegative and at most one of them
!          is zero.  If one of them is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rf
real, intent(in) :: x
real, intent(in) :: y
real, intent(in) :: z
real :: c1, c2, c3, e2, e3, epslon, errtol, lamda, lolim, mu, s, uplim, xn, xndev, xnroot, yn, yndev, ynroot, zn, zndev, znroot
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!          Input ...
!
!          x, y, and z are the variables in the integral rf(x,y,z).
!
!          Output ...
!
!          rf is the value of the incomplete elliptic integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y, x+z, or y+z is too small.
!               ierr = 3  x, y, or z is too large.
!
!-----------------------------------------------------------------------
!
!          Machine dependent parameters ...
!
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
!
lolim = 5.0 * spmpar(2)
uplim = 0.2 * spmpar(3)
!
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          errtol ** 6 / (4 * (1 - errtol)).
!
errtol = (3.6 * spmpar(1))**(1.0/6.0)
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (min(x,y,z) < 0.0) go to 100
if (min(x + y,x + z,y + z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
zn = z
!
10 mu = (xn + yn + zn) / 3.0
xndev = 2.0 - (mu + xn) / mu
yndev = 2.0 - (mu + yn) / mu
zndev = 2.0 - (mu + zn) / mu
epslon = max(abs(xndev),abs(yndev),abs(zndev))
if (epslon < errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
xn = (xn + lamda) * 0.25
yn = (yn + lamda) * 0.25
zn = (zn + lamda) * 0.25
go to 10
!
20 c1 = 1.0 / 24.0
c2 = 3.0 / 44.0
c3 = 1.0 / 14.0
e2 = xndev * yndev - zndev * zndev
e3 = xndev * yndev * zndev
s = 1.0 + (c1 * e2 - 0.1 - c2 * e3) * e2 + c3 * e3
rf = s / sqrt(mu)
return
!
!                      Error return
!
100 rf = 0.0
ierr = 1
return
110 rf = 0.0
ierr = 2
return
120 rf = 0.0
ierr = 3
return
end subroutine rfval

pure elemental subroutine drfval(x, y, z, rf, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the first kind
!
!          rf(x,y,z) = Integral from zero to infinity of
!
!                                -1/2     -1/2     -1/2
!                      (1/2)(T+x)    (T+y)    (T+z)    DT,
!
!          Where x, y, and z are nonnegative and at most one of them
!          is zero.  If one of them is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rf
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision, intent(in) :: z
double precision :: c1, c2, c3, e2, e3, epslon, errtol, lamda, lolim, mu, s, uplim, xn, xndev, xnroot, yn, yndev, ynroot, zn, &
   & zndev, znroot
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!
!          Input ...
!
!          x, y, and z are the variables in the integral rf(x,y,z).
!
!          Output ...
!
!          rf is the value of the incomplete elliptic integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y, x+z, or y+z is too small.
!               ierr = 3  x, y, or z is too large.
!
!-----------------------------------------------------------------------
!
!          Machine dependent parameters ...
!
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
!
lolim = 5.0d0 * dpmpar(2)
uplim = 0.2d0 * dpmpar(3)
!
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          errtol ** 6 / (4 * (1 - errtol)).
!
errtol = (3.6 * sngl(dpmpar(1)))**(1.0/6.0)
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (min(x,y,z) < 0.d0) go to 100
if (min(x + y,x + z,y + z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
zn = z
!
10 mu = (xn + yn + zn) / 3.d0
xndev = 2.d0 - (mu + xn) / mu
yndev = 2.d0 - (mu + yn) / mu
zndev = 2.d0 - (mu + zn) / mu
epslon = max(abs(xndev),abs(yndev),abs(zndev))
if (epslon < errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
xn = (xn + lamda) * 0.25d0
yn = (yn + lamda) * 0.25d0
zn = (zn + lamda) * 0.25d0
go to 10
!
20 c1 = 1.d0 / 24.d0
c2 = 3.d0 / 44.d0
c3 = 1.d0 / 14.d0
e2 = xndev * yndev - zndev * zndev
e3 = xndev * yndev * zndev
s = 1.d0 + (c1 * e2 - 0.1d0 - c2 * e3) * e2 + c3 * e3
rf = s / sqrt(mu)
return
!
!                      Error return
!
100 rf = 0.d0
ierr = 1
return
110 rf = 0.d0
ierr = 2
return
120 rf = 0.d0
ierr = 3
return
end subroutine drfval

pure elemental subroutine rdval(x, y, z, rd, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the second kind
!
!          rd(x,y,z) = Integral from zero to infinity of
!
!                                -1/2     -1/2     -3/2
!                      (3/2)(T+x)    (T+y)    (T+z)    DT,
!
!          Where x and y are nonnegative, x + y is positive, and z is
!          positive.  If x or y is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rd
real, intent(in) :: x
real, intent(in) :: y
real, intent(in) :: z
real :: c1, c2, c3, c4, ea, eb, ec, ed, ef, epslon, errtol, lamda, lolim, mu, power4, sigma, s1, s2, uplim, xn, xndev, xnroot, yn, &
   & yndev, ynroot, zn, zndev, znroot
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!          Input ...
!
!          x, y, and z are the variables in the integral rd(x,y,z).
!
!          Output ...
!
!          rd is the value of the incomplete elliptic integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y or z is too small.
!               ierr = 3  x, y, or z is too large.
!
!-----------------------------------------------------------------------
!
!          Machine dependent parameters ...
!
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          3 * errtol ** 6 / (1 - errtol) ** 3/2.
!
errtol = (.28 * spmpar(1)) ** (1.0/6.0)
!
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than 2 / (machine maximum) ** (2/3).
!          uplim is not greater than (0.1 * errtol / machine
!          MINIMUM) ** (2/3).
!
mu = -2.0/3.0
lolim = 2.0001 * spmpar(3) ** mu
uplim = (10.0 * spmpar(2) / errtol) ** mu
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (min(x,y,z) < 0.0) go to 100
if (min(x + y,z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
zn = z
sigma = 0.0
power4 = 1.0
!
10 mu = (xn + yn + 3.0 * zn) * 0.2
xndev = (mu - xn) / mu
yndev = (mu - yn) / mu
zndev = (mu - zn) / mu
epslon = max(abs(xndev),abs(yndev),abs(zndev))
if (epslon < errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
sigma = sigma + power4 / (znroot * (zn + lamda))
power4 = power4 * 0.25
xn = (xn + lamda) * 0.25
yn = (yn + lamda) * 0.25
zn = (zn + lamda) * 0.25
go to 10
!
20 c1 = 3.0 / 14.0
c2 = 1.0 / 6.0
c3 = 9.0 / 22.0
c4 = 3.0 / 26.0
ea = xndev * yndev
eb = zndev * zndev
ec = ea - eb
ed = ea - 6.0 * eb
ef = ed + ec + ec
s1 = ed * (- c1 + 0.25 * c3 * ed - 1.5 * c4 * zndev * ef)
s2 = zndev * (c2 * ef + zndev * (- c3 * ec + zndev * c4 * ea))
rd = 3.0 * sigma + power4 * (1.0 + s1 + s2) / (mu * sqrt(mu))
return
!
!                        Error return
!
100 rd = 0.0
ierr = 1
return
110 rd = 0.0
ierr = 2
return
120 rd = 0.0
ierr = 3
return
end subroutine rdval

pure elemental subroutine drdval(x, y, z, rd, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the second kind
!
!          rd(x,y,z) = Integral from zero to infinity of
!
!                                -1/2     -1/2     -3/2
!                      (3/2)(T+x)    (T+y)    (T+z)    DT,
!
!          Where x and y are nonnegative, x + y is positive, and z is
!          positive.  If x or y is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rd
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision, intent(in) :: z
double precision :: c1, c2, c3, c4, ea, eb, ec, ed, ef, epslon, errtol, lamda, lolim, mu, power4, sigma, s1, s2, uplim, xn, xndev, &
   & xnroot, yn, yndev, ynroot, zn, zndev, znroot
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!
!          Input ...
!
!          x, y, and z are the variables in the integral rd(x,y,z).
!
!          Output ...
!
!          rd is the value of the incomplete elliptic integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y or z is too small.
!               ierr = 3  x, y, or z is too large.
!
!-----------------------------------------------------------------------
!
!          Machine dependent parameters ...
!
!          ERRTOL is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
!
errtol = (.28 * sngl(dpmpar(1)))**(1.0/6.0)
!
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than 2 / (machine maximum) ** (2/3).
!          uplim is not greater than (0.1 * ERRTOL / machine
!          MINIMUM) ** (2/3).
!
mu = -2.d0/3.d0
lolim = 2.00000000001d0 * dpmpar(3) ** mu
uplim = (10.d0 * dpmpar(2) / errtol) ** mu
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (min(x,y,z) < 0.d0) go to 100
if (min(x + y,z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
zn = z
sigma = 0.d0
power4 = 1.d0
!
10 mu = (xn + yn + 3.d0 * zn) * 0.2d0
xndev = (mu - xn) / mu
yndev = (mu - yn) / mu
zndev = (mu - zn) / mu
epslon = max(abs(xndev),abs(yndev),abs(zndev))
if (epslon < errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
sigma = sigma + power4 / (znroot * (zn + lamda))
power4 = power4 * 0.25d0
xn = (xn + lamda) * 0.25d0
yn = (yn + lamda) * 0.25d0
zn = (zn + lamda) * 0.25d0
go to 10
!
20 c1 = 3.d0 / 14.d0
c2 = 1.d0 / 6.d0
c3 = 9.d0 / 22.d0
c4 = 3.d0 / 26.d0
ea = xndev * yndev
eb = zndev * zndev
ec = ea - eb
ed = ea - 6.d0 * eb
ef = ed + ec + ec
s1 = ed * (- c1 + 0.25d0 * c3 * ed - 1.5d0 * c4 * zndev * ef)
s2 = zndev * (c2 * ef + zndev * (- c3 * ec + zndev * c4 * ea))
rd = 3.d0 * sigma + power4 * (1.d0 + s1 + s2) / (mu * sqrt(mu))
return
!
!                        Error return
!
100 rd = 0.d0
ierr = 1
return
110 rd = 0.d0
ierr = 2
return
120 rd = 0.d0
ierr = 3
return
end subroutine drdval

pure elemental subroutine rjval(x, y, z, p, rj, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the third kind
!
!          rj(x,y,z,p) = Integral from zero to infinity of
!
!                                  -1/2     -1/2     -1/2     -1
!                        (3/2)(T+x)    (T+y)    (T+z)    (T+p)  DT,
!
!          Where x, y, and z are nonnegative, at most one of them is
!          zero, and p is positive.  If x or y or z is zero, the
!          integral is complete.  The duplication theorem is iterated
!          until the variables are nearly equal, and the function is
!          then expanded in Taylor series to fifth order.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rj
real, intent(in) :: p
real, intent(in) :: x
real, intent(in) :: y
real, intent(in) :: z
real :: rc, alfa, beta, c1, c2, c3, c4, ea, eb, ec, e2, e3, epslon, errtol, etolrc, lamda, lolim, mu, pn, pndev, power4, sigma, &
   & s1, s2, s3, uplim, xn, xndev, xnroot, yn, yndev, ynroot, zn, zndev, znroot
interface
   pure elemental subroutine rcval1(x,y,errtol,rc,ierr)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(in) :: errtol
      real, intent(inout) :: rc
      integer, intent(inout) :: ierr
   end subroutine rcval1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!          Input ...
!
!          x, y, z, and p are the variables in the integral rj(x,y,z,p).
!
!          Output ...
!
!          rj is the value of the incomplete elliptic integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, z, or p is negative.
!               ierr = 2  x+y, x+z, y+z, or p is too small.
!               ierr = 3  x, y, z, or p is too large.
!
!-----------------------------------------------------------------------
!
!          Machine dependent parameters ...
!
!          rc is a function computed by the subroutine rcval1.
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the cube root of the value
!          of lolim used in the code for rc, and
!          uplim is not greater than 0.3 times the cube root of
!          the value of uplim used in the code for rc.
!
mu = 1.0/3.0
lolim = 1.0001 * (5.0 * spmpar(2))**mu
uplim = .29999 * (0.2 * spmpar(3))**mu
!
!          errtol is set to the desired error tolerance. The
!          relative error due to truncation of the series for rj
!          is less than 3 * errtol ** 6 / (1 - errtol) ** 3/2.
!          An error tolerance (etolrc) will be passed to the code for
!          rc to make the truncation error for rc less than for rj.
!
errtol = (.28 * spmpar(1))**(1.0/6.0)
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (min(x,y,z,p) < 0.0) go to 100
if (min(x + y,x + z,y + z,p) < lolim) go to 110
if (max(x,y,z,p) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
zn = z
pn = p
sigma = 0.0
power4 = 1.0
etolrc = 0.5 * errtol
!
10 mu = (xn + yn + zn + pn + pn) * 0.2
xndev = (mu - xn) / mu
yndev = (mu - yn) / mu
zndev = (mu - zn) / mu
pndev = (mu - pn) / mu
epslon = max(abs(xndev),abs(yndev),abs(zndev),abs(pndev))
if (epslon < errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
alfa = pn * (xnroot + ynroot + znroot) + xnroot * ynroot * znroot
alfa = alfa * alfa
beta = pn * (pn + lamda) * (pn + lamda)
call rcval1(alfa, beta, etolrc, rc, ierr)
if (ierr /= 0) return
sigma = sigma + power4 * rc
power4 = power4 * 0.25
xn = (xn + lamda) * 0.25
yn = (yn + lamda) * 0.25
zn = (zn + lamda) * 0.25
pn = (pn + lamda) * 0.25
go to 10
!
20 c1 = 3.0 / 14.0
c2 = 1.0 / 3.0
c3 = 3.0 / 22.0
c4 = 3.0 / 26.0
ea = xndev * (yndev + zndev) + yndev * zndev
eb = xndev * yndev * zndev
ec = pndev * pndev
e2 = ea - 3.0 * ec
e3 = eb + 2.0 * pndev * (ea - ec)
s1 = 1.0 + e2 * (-c1 + 0.75 * c3 * e2 - 1.5 * c4 * e3)
s2 = eb * (0.5 * c2 + pndev * (- c3 - c3 + pndev * c4))
s3 = pndev * ea * (c2 - pndev * c3) - c2 * pndev * ec
rj = 3.0 * sigma + power4 * (s1 + s2 + s3) / (mu * sqrt(mu))
return
!
!                        Error return
!
100 rj = 0.0
ierr = 1
return
110 rj = 0.0
ierr = 2
return
120 rj = 0.0
ierr = 3
return
end subroutine rjval

pure elemental subroutine drjval(x, y, z, p, rj, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the third kind
!
!          rj(x,y,z,p) = Integral from zero to infinity of
!
!                                  -1/2     -1/2     -1/2     -1
!                        (3/2)(T+x)    (T+y)    (T+z)    (T+p)  DT,
!
!          Where x, y, and z are nonnegative, at most one of them is
!          zero, and p is positive.  If x or y or z is zero, the
!          integral is complete.  The duplication theorem is iterated
!          until the variables are nearly equal, and the function is
!          then expanded in Taylor series to fifth order.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rj
double precision, intent(in) :: p
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision, intent(in) :: z
double precision :: rc, alfa, beta, c1, c2, c3, c4, ea, eb, ec, e2, e3, epslon, errtol, etolrc, lamda, lolim, mu, pn, pndev, &
   & power4, sigma, s1, s2, s3, uplim, xn, xndev, xnroot, yn, yndev, ynroot, zn, zndev, znroot
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental subroutine drcvl1(x,y,errtol,rc,ierr)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision, intent(in) :: errtol
      double precision, intent(inout) :: rc
      integer, intent(inout) :: ierr
   end subroutine drcvl1
end interface
!-----------------------------------------------------------------------
!
!          Input ...
!
!          x, y, z, and p are the variables in the integral rj(x,y,z,p).
!
!          Output ...
!
!          rj is the value of the incomplete elliptic integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, z, or p is negative.
!               ierr = 2  x+y, x+z, y+z, or p is too small.
!               ierr = 3  x, y, z, or p is too large.
!
!-----------------------------------------------------------------------
!
!          Machine dependent parameters ...
!
!          rc is a function computed by the subroutine drcvl1.
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the cube root of the value
!          of lolim used in the code for rc, and
!          uplim is not greater than 0.3 times the cube root of
!          the value of uplim used in the code for rc.
!
mu = 1.d0/3.d0
lolim = 1.00000000001d0 * (5.0d0 * dpmpar(2))**mu
uplim = .299999999999d0 * (0.2d0 * dpmpar(3))**mu
!
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation of the series for rj
!          is less than 3 * errtol ** 6 / (1 - errtol) ** 3/2.
!          An error tolerance (etolrc) will be passed to the code for
!          rc to make the truncation error for rc less than for rj.
!
errtol = (.28 * sngl(dpmpar(1)))**(1.0/6.0)
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (min(x,y,z,p) < 0.d0) go to 100
if (min(x + y,x + z,y + z,p) < lolim) go to 110
if (max(x,y,z,p) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
zn = z
pn = p
sigma = 0.d0
power4 = 1.d0
etolrc = 0.5d0 * errtol
!
10 mu = (xn + yn + zn + pn + pn) * 0.2d0
xndev = (mu - xn) / mu
yndev = (mu - yn) / mu
zndev = (mu - zn) / mu
pndev = (mu - pn) / mu
epslon = max(abs(xndev),abs(yndev),abs(zndev),abs(pndev))
if (epslon < errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
alfa = pn * (xnroot + ynroot + znroot) + xnroot * ynroot * znroot
alfa = alfa * alfa
beta = pn * (pn + lamda) * (pn + lamda)
call drcvl1(alfa, beta, etolrc, rc, ierr)
if (ierr /= 0) return
sigma = sigma + power4 * rc
power4 = power4 * 0.25d0
xn = (xn + lamda) * 0.25d0
yn = (yn + lamda) * 0.25d0
zn = (zn + lamda) * 0.25d0
pn = (pn + lamda) * 0.25d0
go to 10
!
20 c1 = 3.d0 / 14.d0
c2 = 1.d0 / 3.d0
c3 = 3.d0 / 22.d0
c4 = 3.d0 / 26.d0
ea = xndev * (yndev + zndev) + yndev * zndev
eb = xndev * yndev * zndev
ec = pndev * pndev
e2 = ea - 3.d0 * ec
e3 = eb + 2.d0 * pndev * (ea - ec)
s1 = 1.d0 + e2 * (- c1 + 0.75d0 * c3 * e2 - 1.5d0 * c4 * e3)
s2 = eb * (0.5d0 * c2 + pndev * (- c3 - c3 + pndev * c4))
s3 = pndev * ea * (c2 - pndev * c3) - c2 * pndev * ec
rj = 3.d0 * sigma + power4 * (s1 + s2 + s3) / (mu * sqrt(mu))
return
!
!                        Error return
!
100 rj = 0.d0
ierr = 1
return
110 rj = 0.d0
ierr = 2
return
120 rj = 0.d0
ierr = 3
return
end subroutine drjval

pure elemental subroutine rcval1(x, y, errtol, rc, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the integral
!
!          rc(x,y) = Integral from zero to infinity of
!
!                              -1/2     -1
!                    (1/2)(T+x)    (T+y)  DT,
!
!          Where x is nonnegative and y is positive.  The duplication
!          theorem is iterated until the variables are nearly equal,
!          and the function is then expanded in Taylor series to fifth
!          order.  Logarithmic, inverse circular, and inverse hyper-
!          BOLIC functions can be expressed in terms of rc.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rc
real, intent(in) :: errtol
real, intent(in) :: x
real, intent(in) :: y
real :: c1, c2, lamda, lolim, mu, s, sn, uplim, xn, yn
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
!
lolim = 5.0 * spmpar(2)
uplim = 0.2 * spmpar(3)
!
!          Input ...
!
!          x and y are the variables in the integral rc(x,y).
!
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          16 * errtol ** 6 / (1 - 2 * errtol).
!
!          SAMPLE CHOICES   errtol   RELATIVE TRUNCATION
!                                    error less than
!                           1.E-3    2.E-17
!                           3.E-3    2.E-14
!                           1.E-2    2.E-11
!                           3.E-2    2.E-8
!                           1.E-1    2.E-5
!
!          Output ...
!
!          rc is the value of the integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x OR y IS NEGATIVE, OR y = 0.
!               ierr = 2  x+y is too small.
!               ierr = 3  x or y is too large.
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (x < 0.0 .or. y <= 0.0) go to 100
if ((x + y) < lolim) go to 110
if (max(x,y) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
!
10 mu = (xn + yn + yn) / 3.0
sn = (yn + mu) / mu - 2.0
if (abs(sn) < errtol) go to 20
lamda = 2.0 * sqrt(xn) * sqrt(yn) + yn
xn = (xn + lamda) * 0.25
yn = (yn + lamda) * 0.25
go to 10
!
20 c1 = 1.0 / 7.0
c2 = 9.0 / 22.0
s = sn * sn * (0.3 + sn * (c1 + sn * (0.375 + sn * c2)))
rc = (1.0 + s) / sqrt(mu)
return
!
!                      Error return
!
100 rc = 0.0
ierr = 1
return
110 rc = 0.0
ierr = 2
return
120 rc = 0.0
ierr = 3
return
end subroutine rcval1

pure elemental subroutine drcvl1(x, y, errtol, rc, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the integral
!
!          rc(x,y) = Integral from zero to infinity of
!
!                              -1/2     -1
!                    (1/2)(T+x)    (T+y)  DT,
!
!          Where x is nonnegative and y is positive.  The duplication
!          theorem is iterated until the variables are nearly equal,
!          and the function is then expanded in Taylor series to fifth
!          order.  Logarithmic, inverse circular, and inverse hyper-
!          BOLIC functions can be expressed in terms of rc.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rc
double precision, intent(in) :: errtol
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision :: c1, c2, lamda, lolim, mu, s, sn, uplim, xn, yn
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
!
lolim = 5.0d0 * dpmpar(2)
uplim = 0.2d0 * dpmpar(3)
!
!          Input ...
!
!          x and y are the variables in the integral rc(x,y).
!
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          16 * errtol ** 6 / (1 - 2 * errtol).
!
!          Output ...
!
!          rc is the value of the integral.
!
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x OR y IS NEGATIVE, OR y = 0.
!               ierr = 2  x+y is too small.
!               ierr = 3  x or y is too large.
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (x < 0.d0  .or.  y <= 0.d0) go to 100
if ((x + y) < lolim) go to 110
if (max(x,y) > uplim) go to 120
!
ierr = 0
xn = x
yn = y
!
10 mu = (xn + yn + yn) / 3.d0
sn = (yn + mu) / mu - 2.d0
if (abs(sn) < errtol) go to 20
lamda = 2.d0 * sqrt(xn) * sqrt(yn) + yn
xn = (xn + lamda) * 0.25d0
yn = (yn + lamda) * 0.25d0
go to 10
!
20 c1 = 1.d0 / 7.d0
c2 = 9.d0 / 22.d0
s = sn * sn * (0.3d0 + sn * (c1 + sn * (0.375d0 + sn * c2)))
rc = (1.d0 + s) / sqrt(mu)
return
!
!                      Error return
!
100 rc = 0.d0
ierr = 1
return
110 rc = 0.d0
ierr = 2
return
120 rc = 0.d0
ierr = 3
return
end subroutine drcvl1

pure elemental subroutine ellpf(u,k,l,s,c,d,ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(inout) :: c, d, s
real, intent(in) :: u
real, intent(in) :: k, l
integer :: max, n
real :: e, eps, f, f2, r, sg, tol, u1, u2, z
real, parameter :: pihalf = 1.5707963267949
interface
   pure elemental subroutine ellpi(phi,cphi,k,l,f,e,ierr)
      implicit none
      real, intent(in) :: phi
      real, intent(in) :: cphi
      real, intent(in) :: k
      real, intent(in) :: l
      real, intent(inout) :: f
      real, intent(inout) :: e
      integer, intent(inout) :: ierr
   end subroutine ellpi
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental subroutine scd(u,k,l,f,s,c,d)
      implicit none
      real, intent(in) :: u
      real, intent(in) :: k
      real, intent(in) :: l
      real, intent(in) :: f
      real, intent(inout) :: s
      real, intent(inout) :: c
      real, intent(inout) :: d
   end subroutine scd
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     -------------------------------------------------------------
!     ellpf calculates the elliptic functions sn(u,k), CN(u,k), and
!     DN(u,k) for real u and real modulus k.  it is assumed that
!     abs(k) .LE. 1. AND k**2 + l**2 = 1.
!     -------------------------------------------------------------
!     ----------------
!     ****** max and eps are machine dependent constants.
!            Max is the largest positive integer that may
!            be used, and eps is the smallest real number
!            for which 1 + eps .GT. 1.
!
max = ipmpar(3)
eps = spmpar(1)
!
!     ----------------
!     Calculation for l = 0.0
!
if (l /= 0.0) go to 10
s = tanh(u)
e = exp(-abs(u))
c = 2.0*e/(1.0 + e*e)
d = c
ierr = 0
return
!
!     Check that k**2 + l**2 = 1
!
10 tol = 2.0*eps
z = dble(k*k) + (dble(l*l) - 1.d0)
if (abs(z) > tol) go to 100
!
f = pihalf
if (k /= 0.0) call ellpi(pihalf,0.0,k,l,f,e,ierr)
f2 = 2.0*f
!
!                   Argument reduction
!
u1 = abs(u)
r = u1/f2
if (r >= min(float(max),1.0/eps)) go to 110
n = int(r)
u1 = u1 - float(n)*f2
sg = 1.0
if (mod(n,2) /= 0) sg = -1.0
!
if (u1 <= 0.0) go to 30
if (u1 <= f) go to 20
u1 = u1 - f2
sg = -sg
if (u1 >= 0.0) go to 30
!
!     Calculation of elliptic functions for 0.0 .LE. u2 .LE. f(k)
!
20 u2 = abs(u1)
call scd(u2,abs(k),abs(l),f,s,c,d)
ierr = 0
if (u1 < 0.0) s = -s
!
!     Final assembly
!
s = sg*s
c = sg*c
if (u < 0.0) s = -s
return
!
!             u is an integer multiple of f2
!
30 s = 0.0
c = sg
d = 1.0
ierr = 0
return
!
!                      Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine ellpf

pure elemental subroutine scd(u,k,l,f,s,c,d)
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f
real, intent(inout) :: s
real, intent(in) :: u
real, intent(in) :: k, l
integer :: ierr
real :: c1, d1, e1, f1, s1, v
real, parameter :: pihalf = 1.5707963267949
interface
   pure elemental subroutine ellpi(phi,cphi,k,l,f,e,ierr)
      implicit none
      real, intent(in) :: phi
      real, intent(in) :: cphi
      real, intent(in) :: k
      real, intent(in) :: l
      real, intent(inout) :: f
      real, intent(inout) :: e
      integer, intent(inout) :: ierr
   end subroutine ellpi
   pure elemental subroutine scdf(u,k,l,f,f1,s,c,d)
      implicit none
      real, intent(in) :: u
      real, intent(in) :: k
      real, intent(in) :: l
      real, intent(in) :: f
      real, intent(in) :: f1
      real, intent(inout) :: s
      real, intent(inout) :: c
      real, intent(inout) :: d
   end subroutine scdf
   pure elemental subroutine scdj(u,k,l,f,f1,s,c,d)
      implicit none
      real, intent(in) :: u
      real, intent(in) :: k
      real, intent(in) :: l
      real, intent(in) :: f
      real, intent(in) :: f1
      real, intent(inout) :: s
      real, intent(inout) :: c
      real, intent(inout) :: d
   end subroutine scdj
   pure elemental subroutine scdm(u,k,s,c,d)
      implicit none
      real, intent(in) :: u
      real, intent(in) :: k
      real, intent(out) :: s
      real, intent(out) :: c
      real, intent(out) :: d
   end subroutine scdm
end interface
!     --------------------------------------------------------
!     scd computes the elliptic functions sn(u,k), CN(u,k),
!     and DN(u,k) for real u and real modulus k such that
!     0.0 .LE. u .LE. f AND 0.0 .LE. k .LT. 1.0, WHERE
!     f = f(k) is the complete elliptic integral of the
!     first kind, and f1 = f(l) is the complementary integral.
!     It is assumed that k**2 + l**2 = 1.
!     --------------------------------------------------------
!     ------------------------
if (k == 0.0) go to 40
v = f - u
!
!     Uses Maclaurin expansion when u or v .LE. 0.01
!
if (u > 0.01) go to 10
call scdm(u,k,s,c,d)
return
10 if (v > 0.01) go to 20
call scdm(v,k,s1,c1,d1)
s = c1/d1
c = l*s1/d1
d = l/d1
return
!
!     Uses Fourier expansion when k .LE. l
!
20 call ellpi(pihalf,0.0,l,k,f1,e1,ierr)
!
if (k > l) go to 30
call scdf(u,k,l,f,f1,s,c,d)
return
!
!     Uses imaginary transformation of Jacobi and Fourier
!     expansion when k .GT. l
!
30 call scdj(u,k,l,f,f1,s,c,d)
return
!
!     Computation for k = 0.0
!
40 s = sin(u)
c = cos(u)
d = 1.0
return
end subroutine scd

pure elemental subroutine scdm(u,k,s,c,d)
implicit none
real, intent(out) :: c, d, s
real, intent(in) :: u
real, intent(in) :: k
real :: c1, c2, c3, c4, u2, k2
!     -------------------------------------------------
!     Calculates SN(u,k), CN(u,k), and DN(u,k) for
!     0.0 .LE. u .LE. 0.01 and for 0.0 .LE. k .LE. 1.0
!     by use of the Maclaurin expansion for SN(u,k)
!     -------------------------------------------------
!
k2 = k*k
u2 = u*u
c1 = -(1.0 + k2)/6.0
c2 = (1.0 + k2*(14.0 + k2))/120.0
c3 = -(1.0 + k2*(135.0 + k2*(135.0 + k2)))/5040.0
c4 = (1.0 + k2*(1228.0 + k2*(5478.0 + k2*(1228.0 + k2))))/ &
   & 362880.0
s = u*(1.0 + u2*(c1 + u2*(c2 + u2*(c3 + c4*u2))))
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
return
end subroutine scdm

pure elemental subroutine scdf(u,k,l,f,f1,s,c,d)
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f, f1
real, intent(inout) :: s
real, intent(in) :: u
real, intent(in) :: k, l
real :: a, ai, coef, eps, q1, q2, qd, qh, qn, sum, temp, tol, v, w, x, i
real, parameter :: pihalf = 1.5707963267949
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     -------------------------------------------------------------
!     scdf computes SN(u,k), CN(u,k), and DN(u,k) for real u and
!     k by use of the Fourier expansion for SN(u,k).  It is
!     assumed that 0.0 .LE. k .LT. 1.0 and 0.0 .LE. u .LE. f,
!     where f = f(k) is the complete elliptic integral of the
!     first kind and f1 = f(l) is the complementary integral, with
!     l .NE. 0. AND k**2 + l**2 = 1.
!     -------------------------------------------------------------
!     -------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the
!     smallest number such that 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     -------------------------------------------------
tol = eps/10.0
v = f - u
qh = exp(-pihalf*f1/f)
q1 = qh*qh
q2 = q1*q1
coef = 4.*pihalf*qh/(k*f)
qn = 1.0
qd = q1
w = min(u,v)
x = pihalf*w/f
!
!     Calculation of series for W = AMIN1(u,V)
!
i = 1.0
sum = 0.0
10 ai = qn/(1.0 - qd)
a = ai*sin(i*x)
sum = sum + a
if (abs(ai) < tol*abs(sum)) go to 20
qn = qn*q1
qd = qd*q2
i = i + 2.0
go to 10
!
!     Assembly for u .LE. V
!
20 s = coef*sum
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
if (u == w) return
!
!     Assembly for u .GT. V
!
temp = s
s = c/d
c = l*temp/d
d = l/d
return
end subroutine scdf

pure elemental subroutine scdj(u,k,l,f,f1,s,c,d)
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f, f1
real, intent(inout) :: s
real, intent(in) :: u
real, intent(in) :: k, l
real :: a, ch, coef, e1, e1n, e2, e2n, eps, q1, q1n, q2, q2n, sh, sum, temp, tol, v, w, x, x2, xn, n
real, parameter :: pihalf = 1.5707963267949
real, parameter :: pi = 3.1415926535898
interface
   pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
      implicit none
      real, intent(inout) :: sinhm
      real, intent(inout) :: coshm
      real, intent(in) :: x
      integer, intent(in) :: isw
   end subroutine snhcsh
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     ----------------------------------------------------------------
!     scdj computes SN(u,k), CN(u,k), and DN(u,k) for real u and
!     k using the imaginary transformation of Jacobi and A
!     Fourier expansion.  It is assumed that 0.0 .LE. k .LT. 1.0
!     and 0.0 .LE. u .LE. f, where f = f(k) is the complete elliptic
!     integral of the first kind and f1 = f(l) is the complementary
!     integral, and that l .NE. 0. And k**2 + l**2 = 1.
!     ----------------------------------------------------------------
!     ------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the
!     smallest number such that 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     ------------------------------------------------
tol = eps/10.0
v = f - u
q1 = -exp(-pi*f/f1)
q2 = q1*q1
!
w = min(u,v)
e1 = pi*max(u,v)/f1
e2 = pi*(f + w)/f1
e1 = exp(-e1)
e2 = exp(-e2)
!
coef = pihalf/(k*f1)
x = pihalf*w/f1
x2 = 2.0*x
!
!     Calculation of series for W = AMIN1(u,V)
!
n = 1.0
q1n = q1
q2n = q2
e1n = e1
e2n = e2
sum = 0.0
!
20 xn = n*x2
if (xn > 1.0) go to 30
call snhcsh(sh,ch,xn,-1)
sh = sh + xn
a = 2.0*q1n*abs(q1n)*sh/(1.0 + q2n)
go to 40
30 a = q1n*(e1n - e2n)/(1.0 + q2n)
40 sum = sum + a
if (abs(a) < tol*abs(sum)) go to 50
q1n = q1n*q1
q2n = q2n*q2
e1n = e1n*e1
e2n = e2n*e2
n = n + 1.0
go to 20
!
!     Assembly for u .LE. V
!
50 s = coef*(tanh(x) + 2.0*sum)
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
if (u == w) return
!
!     Assembly for u .GT. V
!
temp = s
s = c/d
c = l*temp/d
d = l/d
return
end subroutine scdj

pure elemental subroutine elpfc1(u,k,l,s,c,d,ierr)
implicit none
integer, intent(inout) :: ierr
complex, intent(in) :: u
complex, intent(inout) :: s, c, d
real, intent(in) :: k, l
real :: c1, c2, ck, cl, coef, d1, d2, dk, dl, r, s1, s2, sk, sl, t, t1, t2, td1, td2, u1, u2, k2
interface
   pure elemental subroutine ellpf(u,k,l,s,c,d,ierr)
      implicit none
      real, intent(in) :: u
      real, intent(in) :: k
      real, intent(in) :: l
      real, intent(inout) :: s
      real, intent(inout) :: c
      real, intent(inout) :: d
      integer, intent(inout) :: ierr
   end subroutine ellpf
end interface
!     -------------------------------------------------------------
!     elpfc1 calculates the elliptic functions sn(u,k), CN(u,k),
!     DN(u,k) for complex u and real modulus k.  it is assumed that
!     abs(k) .LE. 1. AND k**2 + l**2 = 1.
!     -------------------------------------------------------------
!
u1 = real(u)
u2 = aimag(u)
k2 = k*k
if (u1 == 0.0) go to 10
if (u2 /= 0.0) go to 20
!
!     Calculation for U2 = 0.
!
call ellpf(u1,k,l,s1,c1,d1,ierr)
if (ierr /= 0) return
s2 = 0.0
c2 = 0.0
d2 = 0.0
go to 40
!
!     Calculation for U1 = 0.
!
10 call ellpf(u2,l,k,s2,c2,d2,ierr)
if (ierr /= 0) return
if (c2 == 0.0) go to 50
s1 = 0.0
s2 = s2/c2
d1 = d2/c2
d2 = 0.0
c1 = 1.0/c2
c2 = 0.0
go to 40
!
!     Calculation for U1 and U2 .NE. 0.
!
20 call ellpf(u1,k,l,sk,ck,dk,ierr)
if (ierr /= 0) return
call ellpf(u2,l,k,sl,cl,dl,ierr)
if (ierr /= 0) return
coef = abs(k)*sl
t1 = cl
t2 = coef*sk
td1 = coef*t1
td2 = coef*t2
if (abs(t2) <= abs(t1)) go to 30
if (t2 == 0.0) go to 50
if (td2 == 0.0) go to 50
t = t1/t2
r = 1.0/(1.0 + t*t)
s1 = dl*r/td2
s2 = ck*dk*sl*t*r/t2
c1 = ck*t*r/t2
c2 = -dk*sl*dl*r/td2
d1 = dk*dl*t*r/t2
d2 = -k2*ck*sl*r/td2
go to 40
30 if (t1 == 0.0) go to 50
if (td1 == 0.0) go to 50
t = t2/t1
r = 1.0/(1.0 + t*t)
s1 = dl*t*r/td1
s2 = ck*dk*sl*r/t1
c1 = ck*r/t1
c2 = -dk*sl*dl*t*r/td1
d1 = dk*dl*r/t1
d2 = -k2*ck*sl*t*r/td1
!
!     Final assembly
!
40 s = cmplx (s1, s2)
c = cmplx (c1, c2)
d = cmplx (d1, d2)
return
!
!     Error return
!
50 ierr = 3
return
end subroutine elpfc1

pure elemental subroutine peq(z, w, ierr)
implicit none
!
!     Weierstrass P-function in the equianharmonic case
!     for complex argument with unit period parallelogram
!
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
complex :: z1, z4, z6
real :: zr, zi
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zi = 1.1547005383792515e0*aimag(z) + 0.5e0
m = int(zi)
if (zi < 0e0) m = m - 1
zr = real(z) - 0.5e0*float(m) + 0.5e0
n = int(zr)
if (zr < 0e0) n = n - 1
z1 = z - float(n) - (0.5e0,0.86602540378443865e0)*float(m)
!
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for P.
!
w = z1*z1
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!
!     Evaluation of P(z1)
!
10 ierr = 0
z4 = w*w
z6 = z4*w
w = 1e0/w + 6e0*z4*(5e0 + z6)/(1e0 - z6)**2 + z4* &
   & (((((-2.6427662e-10*z6 + 1.610954818e-8)*z6 + 7.38610752879e-6)* &
   & z6 + 4.3991444671178e-4)*z6 + 7.477288220490697e-2)* &
   & z6 - 6.8484153287299201e-1)/(((((6.2252191e-10*z6 + 2.553314573e-7)* &
   & z6 - 2.619832920421e-5)*z6 - 5.6444801847646e-4)* &
   & z6 + 4.565553484820106e-2)*z6 + 1e0)
return
end subroutine peq

pure elemental subroutine peq1(z, w, ierr)
implicit none
!
!     First derivative of Weierstrass P-function in the
!     equianharmonic case for complex argument
!     with unit period parallelogram
!
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
complex :: z1, z3, z6
real :: zr, zi
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zi = 1.1547005383792515e0*aimag(z) + 0.5e0
m = int(zi)
if (zi < 0e0) m = m - 1
zr = real(z) - 0.5e0*float(m) + 0.5e0
n = int(zr)
if (zr < 0e0) n = n - 1
z1 = z - float(n) - (0.5e0,0.86602540378443865e0)*float(m)
!
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for DP.
!
z3 = z1*z1*z1
z6 = z3*z3
w = z3*(1e0 - z6)**3
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!
!     Evaluation of DP(z1)
!
10 ierr = 0
w = (((14e0*z6 + 294e0)*z6 + 126e0)*z6 - 2e0)/w + &
   & z3*((((((-2.95539175e-9*z6 - 2.6764693031e-7)*z6 + 2.402192743346e-5) &
   & *z6 + 1.9656661451391e-4)*z6 + 1.760135529461036e-2)* &
   & z6 + 8.1026243498822636e-1)*z6 - 2.73936613149196804e0)/ &
   & ((((((4.6397763e-10*z6 + 5.413482233e-8)*z6 - 1.56293298374e-6)* &
   & z6 - 1.0393701076352e-4)*z6 + 9.5553182532237e-4)* &
   & z6 + 9.131106969640212e-2)*z6 + 1e0)
return
end subroutine peq1

pure elemental subroutine plem(z, w, ierr)
implicit none
!
!     Weierstrass P-function in the lemniscatic case
!     for complex argument with unit period parallelogram
!
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
complex :: z1, z4, z6
real :: zr, zi
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zr = real(z) + 0.5e0
zi = aimag(z) + 0.5e0
m = int(zr)
n = int(zi)
if (zr < 0e0) m = m - 1
if (zi < 0e0) n = n - 1
z1 = z - float(m) - (0e0,1e0)*float(n)
!
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for P.
!
w = z1*z1
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!
!     Evaluation of P(z1)
!
10 ierr = 0
z4 = w*w
z6 = z4*w
w = 1e0/w + 4e0*w*(3e0 + z4)/(1e0 - z4)**2 + &
   & w*((((((((-7.233108e-11*z4 + 1.714197273e-8)*z4 - 2.5369036492e-7)* &
   & z4 - 7.98710206868e-6)*z4 + 6.4850606909737e-4)*z4 + 7.39624629362938e-3)*z4 + 2.012382768497244e-2)*z4 + &
   & 7.1177297543136598e-1)* &
   & z4 - 2.54636399353830738e0)/((((((((5.1161516e-10*z4 + 6.61289408e-9) &
   & *z4 + 4.4618987048e-7)*z4 - 8.42694918892e-6)*z4 + 4.42886829095e-6)* &
   & z4 - 4.22629935217101e-3)*z4 + 2.577496871700433e-2)* &
   & z4 + 4.2359940482277074e-1)*z4 + 1e0)
return
end subroutine plem

pure elemental subroutine plem1(z, w, ierr)
implicit none
!
!     First derivative of Weierstrass P-function in the
!     lemniscatic case for complex argument
!     with unit period parallelogram
!
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
complex :: z1, z3, z4
real :: zr, zi
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zr = real(z) + 0.5e0
zi = aimag(z) + 0.5e0
m = int(zr)
n = int(zi)
if (zr < 0e0) m = m - 1
if (zi < 0e0) n = n - 1
z1 = z - float(m) - (0e0,1e0)*float(n)
!
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for DP.
!
z3 = z1*z1*z1
z4 = z3*z1
w = (z1*(1e0 - z4))**3
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!
!     Evaluation of DP(z1)
!
10 ierr = 0
w = (((1e1*z4 + 9e1)*z4 + 3e1)*z4 - 2e0)/w + &
   & z1*((((((((((-3.9046302e-9*z4 - 1.001487137e-8)*z4 + 5.9573043092e-7) &
   & *z4 - 2.482518130524e-5)*z4 + 1.4557266595395e-4)* &
   & z4 + 4.56633655643206e-3)*z4 + 6.224782572111135e-2)* &
   & z4 + 1.038527937794269e-2)*z4 + 1.19804620802637942e0)* &
   & z4 + 6.42791439683811718e0)*z4 - 5.09272798707661477e0)/ &
   & ((((((((((4.726888e-11*z4 - 3.0667983e-9)*z4 + 1.0087596089e-7)* &
   & z4 - 8.060683451e-8)*z4 + 1.184299251664e-5)*z4 - 2.3096723361547e-4)* &
   & z4 - 2.90730903142055e-3)*z4 + 1.338392411135511e-2)* &
   & z4 + 2.3098639320021426e-1)*z4 + 8.4719880964554148e-1)*z4 + 1e0)
return
end subroutine plem1

pure subroutine valr2(x,y,n0,p,iop,a,ind,ko)
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: iop
integer, intent(inout) :: ko
integer, intent(in) :: n0
real, intent(inout) :: a, p, x(*), y(*)
integer :: k, m, n
real :: aj0, aj1, b, bgd1, bgd2, c, cape, caph, capv, cee, circm, d1sq, d2sq, f, g(2), h(2), p1, psi1, sum, t, t1, tau, tausq, u, &
   & v, w, xk, yk, ykm1, z, kom, l
real, parameter :: pi = 3.1415926535898
real, parameter :: twopi = 6.28318530717958
real, parameter :: alnpi = 1.14472988584940
real, parameter :: rtpi = 1.77245385090552
real, parameter :: rtpii = .56418958354776
real, parameter :: e(5) = [.885777518572895e+00, -.981151952778050e+00, .759305502082485e+00, -.353644980686977e+00, &
   & .695232092435207e-01]
real, parameter :: e2(10) = [.886226470016632e+00, -.999950714561036e+00, .885348820003892e+00, -.660611239043357e+00, &
   & .421821197160099e+00, -.222898055667208e+00, .905057384150449e-01, -.254906111884287e-01, .430895168984138e-02, - &
   & .323377239693247e-03]
real, parameter :: e3(15) = [.886226924931465e+00, -.999999899776252e+00, .886223733186722e+00, -.666626670510907e+00, &
   & .442851899328569e+00, -.265638206366025e+00, .145060043403014e+00, -.714909837799889e-01, .309199295521210e-01, - &
   & .112323532148441e-01, .324944543171185e-02, -.704260243309096e-03, .105787574480633e-03, -.971864864160461e-05, &
   & .408335517232165e-06]
real, parameter :: aph1(3) = [2.02e-7, 2.08e-13, 2.71e-19]
real, parameter :: aph2(3) = [1.22e-2, 1.23e-4, 1.34e-6]
real, parameter :: aph4(3) = [.6962e-1, .6990e-2, .7311e-3]
real, parameter :: rsq(3) = [6.0516, 12.60605, 19.201924]
real, parameter :: a3d8(3) = [0.28125e-4, 0.285e-7, 0.32625e-10]
real, parameter :: cst(3) = [.5625e-4, .57e-7, .6512e-10]
interface
   pure elemental function erfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      real, intent(in) :: x
      real :: erfc1
   end function erfc1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     -------------------
!     -------------------
!     -------------------
!     -------------------
!     Tau is a machine dependent tolerance. It is assumed that A
!     7 or more digit floating point arithmetic is being used.
!     -------------------
tau = 2.0*spmpar(1)
if (tau < 3.e-11) tau = max(5.0*tau,1.e-14)
!     -------------------
n = n0
if (n == 2.or.n < 1) go to 4021
tausq = tau*tau
!
p = 0.0
ind = 0
a = 0.0
kom = 0.0
k = 1
if (n /= 1) go to 10
!
w = x(2) - x(1)
z = y(2) - y(1)
u = x(3) - x(1)
v = y(3) - y(1)
xk = 0.0
psi1 = v*w - u*z
if (psi1 >= 0.0) go to 21
!
p = -1.0
t1 = w
w = u
u = t1
t1 = v
v = z
z = t1
go to 21
!
10 ko = 0
x(n + 1) = x(1)
y(n + 1) = y(1)
u = x(2) - x(1)
v = y(2) - y(1)
xk = x(1)
yk = y(1)
!
20 w = x(1) - x(n)
z = y(1) - y(n)
21 d1sq = w*w + z*z
if (d1sq > tausq) go to 30
if (n == 1) go to 4011
n = n - 1
if (n == 2) return
go to 20
!
30 d2sq = u*u + v*v
if (d2sq > tausq) go to 40
if (n == 1) go to 4011
31 k = k + 1
u = x(k + 1) - xk
v = y(k + 1) - yk
d2sq = u*u + v*v
if (d2sq <= tausq) go to 31
if (k == n - 1) return
!
40 a = xk*(y(k + 1) - y(n))
bgd1 = sqrt(d1sq + d1sq)
bgd2 = sqrt(d2sq + d2sq)
!
!             Processing vertex (XK,YK)
!
50 psi1 = v*w - u*z
cee = u*w + v*z
aj0 = atan2(psi1,cee)
kom = kom + aj0
l = 0.0
b = .5*(x(k)*x(k) + y(k)*y(k))
if (b > aph1(iop)) go to 60
p1 = aj0/twopi
go to 3621
!
60 g(1) = (w*x(k) + z*y(k))/bgd1
g(2) = (u*x(k) + v*y(k))/bgd2
h(1) = (-y(k)*w + x(k)*z)/bgd1
h(2) = (-y(k)*u + x(k)*v)/bgd2
if (abs(psi1) > bgd1*bgd2*a3d8(iop)) go to 80
if (cee < 0.0) go to 70
if (abs(aj0) > tau.and.g(1) < 0.0) go to 80
p1 = 0.0
go to 3621
!
70 if (abs(psi1) <= (.5*tau*bgd1*bgd2)) ind = 2
if (psi1 < 0.0) go to 71
p1 = .5*erfc1(0,h(2))
go to 3621
71 p1 = -.5*erfc1(0,h(1))
go to 3621
!
80 if (b > aph2(iop)) go to 90
c = rtpi*(h(2) - h(1)) - (g(2)*h(2) - g(1)*h(1))
p1 = (aj0 - c)/twopi
go to 3621
!
!                 Computation of l
!
90 if (g(1) < 0.0) go to 100
if (g(2) >= 0.0) go to 130
g(2) = -g(2)
h(2) = -h(2)
if (abs(h(2)) <= aph4(iop)) go to 91
l = .5*erfc1(0,-h(2))
go to 120
91 l = .5 + rtpii*h(2)
go to 120
!
100 g(1) = -g(1)
h(1) = -h(1)
if (g(2) < 0.0) go to 110
if (abs(h(1)) <= aph4(iop)) go to 101
l = .5*erfc1(0,h(1))
go to 120
101 l = .5 - rtpii*h(1)
go to 120
!
110 g(2) = -g(2)
h(2) = -h(2)
if (abs(h(1)) <= aph4(iop)) go to 112
if (abs(h(2)) <= aph4(iop)) go to 111
l = .5*(erfc1(0,h(1)) - erfc1(0,h(2)))
go to 130
111 l = rtpii*h(2) - .5*erf(h(1))
go to 130
112 if (abs(h(2)) <= aph4(iop)) go to 113
l = .5*erf(h(2)) - rtpii*h(1)
go to 130
113 l = rtpii*(h(2) - h(1))
go to 130
!
120 psi1 = -psi1
if (psi1 <= 0.0) go to 121
l = l - 1.0
aj0 = aj0 + pi
go to 130
121 aj0 = aj0 - pi
!
!                 Series evaluation
!
130 if (b >= rsq(iop)) go to 171
cape = aj0
caph = .5*aj0
m = 1
f = 0.0
aj1 = h(2) - h(1)
circm = aj1
if (iop - 2) 140,150,160
!
140 sum = e(m)*aj1
141 m = m + 1
h(1) = h(1)*g(1)
h(2) = h(2)*g(2)
t = h(2) - h(1)
f = f + b
capv = (f*cape + t)/m
sum = sum + e(m)*capv
if (m >= 5) go to 170
cape = circm
circm = capv
go to 141
!
150 sum = e2(m)*aj1
151 m = m + 1
h(1) = h(1)*g(1)
h(2) = h(2)*g(2)
t = h(2) - h(1)
f = f + b
capv = (f*cape + t)/m
sum = sum + e2(m)*capv
if (m >= 10) go to 170
cape = circm
circm = capv
go to 151
!
160 sum = e3(m)*aj1
161 m = m + 1
h(1) = h(1)*g(1)
h(2) = h(2)*g(2)
t = h(2) - h(1)
f = f + b
capv = (f*cape + t)/m
sum = sum + e3(m)*capv
if (m >= 15) go to 170
cape = circm
circm = capv
go to 161
!
170 p1 = l + exp(-(b + alnpi))*(caph - sum)
go to 3621
171 p1 = l
!
!               Standard termination
!
3621 if (k /= n) go to 3651
if (n /= 1) go to 3631
p = abs(p + abs(p1))
return
!
3631 p = p - p1
kom = kom/twopi
a = .5*a
if (kom < 0.0) go to 3641
ko = int(kom + .125)
go to 3645
3641 ko = int(kom - .125)
3645 p = p + float(ko)
return
!
!              Set up the next vertex
!
3651 w = u
z = v
bgd1 = bgd2
xk = x(k + 1)
yk = y(k + 1)
ykm1 = y(k)
3661 k = k + 1
u = x(k + 1) - xk
v = y(k + 1) - yk
d2sq = u*u + v*v
if (d2sq <= tausq) go to 3661
bgd2 = sqrt(d2sq + d2sq)
p = p - p1
a = a + xk*(y(k + 1) - ykm1)
go to 50
!
!                  Error return
!
4011 ind = 1
p = 5.0
return
4021 ind = 3
return
end subroutine valr2

pure elemental subroutine circv(r, d, j, p, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: j
real, intent(in) :: d
real, intent(out) :: p
real, intent(in) :: r
integer :: i, n
real :: a, a1, an, anm1, bk2, c0, const, d2, delta, eps, eps0, expt, f, s, s0, s1, s2, sum, t, t0, t2, td, tn, tr, w, x, x0, y1, &
   & z, zm, zp, zr, zrs, m, m0
real, parameter :: e = 2.71828182845905
real, parameter :: c1 = .707106781186548
real, parameter :: c2 = .564189583547756
real, parameter :: c3 = 6.28318530717959
interface
   pure elemental subroutine erfc0(ind,x,e,y)
      implicit none
      integer, intent(in) :: ind
      real, intent(in) :: x
      real, intent(inout) :: e
      real, intent(inout) :: y
   end subroutine erfc0
   pure elemental function erfcr(x)
      implicit none
      real, intent(in) :: x
      real :: erfcr
   end function erfcr
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental subroutine gratio(a,x,ans,qans,ind)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: x
      real, intent(inout) :: ans
      real, intent(inout) :: qans
      integer, intent(in) :: ind
   end subroutine gratio
   pure elemental function rcomp(a,x)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: x
      real :: rcomp
   end function rcomp
   pure elemental function rexp(x)
      implicit none
      real, intent(in) :: x
      real :: rexp
   end function rexp
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!       If j .NE. 0, output is p = Circular coverage function. p gives
!       the probability of a shot falling, under a normal distribution
!       with mean (0,0) and equal standard deviations, S, in a circle
!       of radius R0, offset a distance D0 from (0,0).
!       Input is r = R0/S, d = D0/S.
!
!       If j = 0, output is p = Generalized circular error function.
!       p gives the probability of a shot falling ,under a normal
!       bivariate distribution with mean (0,0) and standard deviations
!       SMIN and S, in a circle of radius R0 centered at (0,0).
!       Input for j = 0, r = R0/S, d = SMIN/S .LE. 1.
!       IF SMIN = 0, S .NE. 0, p = erf(r/(SQR(2)).
!
!       If ierr .NE. 0, some portion of the input is unacceptable.
!       IF r .LT. 0., THEN circv SETS ierr = 1.
!       IF d .LT. 0, OR j = 0 AND d .GT. 1., THEN circv SETS ierr = 2.
!
!       References
!       math of comp April 1961,PP169,173 and oct.1961, PP 375, 382.
!       NWL report N0.1768, jan. 1962. NSWC report N0.83-13, nov. 1982.
!       IEEE trans. Info. TH. April 1965, p. 312.
!-----------------------------------------------------------------------
!       Negative r and d are not permitted.
!--------------------------------------------
!-----------------------
!     c1 = 1/sqrt(2)
!     c2 = 1/sqrt(pi)
!     c3 = 2*pi
!-----------------------
!-----------------------
p = 0.0
if (r < 0.0) goto 115
if (d < 0.0) goto 120
ierr = 0
if (r == 0.0) return
!
eps0 = spmpar(1)
z = - log(eps0)
if (j /= 0) goto 40
!------------------------------------------------------------------
!   For j = 0, error in d if d .LT. 0 or d .GT. 1
!------------------------------------------------------------------
!                j = 0
!--------------------------------------------------
if (d > 1.0) goto 120
if (d == 1.0) goto 45
if (d /= 0.0) goto 5
!---------------------------------------
!          j = 0,     d = 0
!---------------------------------------
p = erf(r*c1)
return
!-------------------------------------------------
!   j = 0,  (r*r .gt. -2*log(eps0))  p = 1
!-------------------------------------------------
5 if (r*r < 2.0*z) goto 10
p = 1.0
return
!---------------------------------------------
10 x = r
d2 = d*d
y1 = r/d
t = 0.5*y1
zm = (0.5 - d2) + 0.5
t2 = t*t
t = t2*zm
!
eps = 10.0*eps0
if (t > 14.0) go to 25
!-------------------------------------------------
!    j = 0,   t .le. 14
!-------------------------------------------------
zp = 1.0 + d2
zr = zm/zp
zrs = zr*zr
bk2 = t2*zp
c0 = 2.0*d/zp
s0 = exp(-bk2)
t0 = 0.5 + (0.5 - s0)
if (bk2 <= 0.15) t0 = -rexp(-bk2)
t0 = c0*t0
s0 = c0*s0
!
p = t0
an = 0.0
20 an = an + 2.0
f = (an - 1.0)/an
w = t/an
x = s0*w
t0 = f*zrs*t0 - (w + zr)*x
s0 = w*x
p = p + t0
if (t0 > eps*p) go to 20
return
!------------------------------------------------
!   j = 0,    t .gt. 14
!------------------------------------------------
25 t = 0.25/t
const = d2/zm
delta = sqrt(zm)
x = 2.0*(c1*c2)/(r*delta)
expt = exp(-0.5*r*r)
call erfc0(1, c1*r, expt, m)
m = m/delta
!
p = 1.0
sum = m
an = 0.0
if (expt*m < 5.e-3) go to 30
!
!          SET  p = 1 - exp(-r*r/2)*m
!
p = (erf(c1*r) - d2/(1.0 + delta))/delta
sum = 0.0
!
!          Compute the asymptotic expansion
!
30 an = an + 2.0
anm1 = an - 1.0
f = anm1/an
m0 = m
m = const*f*(x - m)
if (m >= m0 .or. m < 0.0) go to 35
x = anm1*f*t*x
sum = sum + m
if (m > eps*sum) go to 30
35 p = p - expt*sum
go to 110
!------------------------------------
!              j .NE. 0
!------------------------------------
40 a1 = r - d
t = r*d
if (d /= 0.0) go to 50
!----------------------------------------------
!     j = 0 AND d = 1, OR j .NE. 0 AND d = 0
!----------------------------------------------
45 p = -rexp(-0.5*r*r)
return
!----------------------------------------
50 a = 0.5*(a1*a1)
if (a1 <= 5.0) go to 55
if (a <= z) go to 60
p = 1.0
return
55 if (a1 < -5.0 .and. a > -exparg(1)) return
!----------------------------------------
60 eps = 1.5e2*eps0
if (r >= 1.7 .and. t > 16.0) go to 75
!------------------------------------------------------------------
!      j .NE. 0,    r .LT. 1.7  OR  r*d .LE. 16
!------------------------------------------------------------------
tr = 0.5*(r*r)
td = 0.5*(d*d)
!
!       Find the number n of terms to be used in the series
!
z = 0.5*t
n = z*e + 1.0
tn = ((e*z/n)**(n + n))/(c3*n)
65 n = n + 1
w = z/n
tn = tn*(w*w)
if (tn > eps) go to 65
!
!       Compute the series
!
m = n
call gratio(m + 1.0, tr, s, w, 0)
w = rcomp(m,tr)/m
p = s
do 70 i = 1,n
   s = s + w
   w = (m/tr)*w
   p = s + (td/m)*p
70 m = m - 1.0
p = exp(-td)*p
go to 110
!------------------------------------------------------------------
!      j .NE. 0,    r .GE. 1.7  AND  r*d .GT. 16
!------------------------------------------------------------------
75 z = c1*abs(a1)
w = exp(-a)
call erfc0(1, z, w, s1)
!
a = 0.5*z/t
t = 0.25/t
m = c2 - z*s1
if (z >= 4.0) m = erfcr(z)
m = 0.5*a*m
x = 0.5*c2*t
s1 = s1 + m
s2 = c2 + x
!
an = 2.0
80 an = an + 2.0
anm1 = an - 1.0
f = anm1/an
m0 = m
m = f*a*(x - z*m)
x = f*(anm1*t)*x
s2 = s2 + x
if (m <= 0.0 .or. m >= m0) go to 90
s1 = s1 + m
if (m > eps*s1) go to 80
!
90 an = an + 2.0
anm1 = an - 1.0
x0 = x
x = (anm1/an)*(anm1*t)*x
if (x >= x0) go to 100
s2 = s2 + x
if (x > eps*s2) go to 90
!
100 s1 = 0.5*(r + d)*s1
s2 = c1*s2
w = w/sqrt(r*d)
p = 0.5*w*abs(s1 - s2)
if (a1 > 0.0) p = abs(1.0 - 0.5*w*(s1 + s2))
!
!       Termination
!
110 if (p > 1.0) p = 1.0
return
115 ierr = 1
p = -1.0
return
120 ierr = 2
p = -1.0
return
end subroutine circv

pure elemental subroutine erfc0(ind, x, e, y)
implicit none
integer, intent(in) :: ind
real, intent(inout) :: e
real, intent(in) :: x
real, intent(inout) :: y
real :: ax, bot, eps, t, top
double precision :: w
real, parameter :: c = .564189583547756
real, parameter :: a(4) = [-1.65581836870402e-4, 3.25324098357738e-2, 1.02201136918406e-1, 1.12837916709552e00]
real, parameter :: b(4) = [4.64988945913179e-3, 7.01333417158511e-2, 4.23906732683201e-1, 1.00000000000000e00]
real, parameter :: p(8) = [-1.36864857382717e-7, 5.64195517478974e-1, 7.21175825088309e00, 4.31622272220567e01, &
   & 1.52989285046940e02, 3.39320816734344e02, 4.51918953711873e02, 3.00459261020162e02]
real, parameter :: q(8) = [1.00000000000000e00, 1.27827273196294e01, 7.70001529352295e01, 2.77585444743988e02, &
   & 6.38980264465631e02, 9.31354094850610e02, 7.90950925327898e02, 3.00459260956983e02]
real, parameter :: r(5) = [2.10144126479064e00, 2.62370141675169e01, 2.13688200555087e01, 4.65807828718470e00, &
   & 2.82094791773523e-1]
real, parameter :: s(5) = [9.41537750555460e01, 1.87114811799590e02, 9.90191814623914e01, 1.80124575948747e01, &
   & 1.00000000000000e00]
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!
!               y = erfc(x)            if ind = 0
!               y = exp(x*x)*erfc(x)   otherwise
!
!     e is an input/output variable. If e .GE. 0 then it is assumed
!     that e = exp(-x*x). In this case e is not modified. If e is
!     negative then e is set to exp(-x*x) when this value is needed.
!
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!
!                     abs(x) .LT. 0.47
!
ax = abs(x)
if (ax >= 0.47) go to 10
t = x*x
top = ((a(1)*t + a(2))*t + a(3))*t + a(4)
bot = ((b(1)*t + b(2))*t + b(3))*t + b(4)
y = 0.5 + (0.5 - x*top/bot)
if (ind == 0) return
!
if (e < 0.0) e = exp(-t)
y = y/e
return
!
!                  0.47 .LE. abs(x) .LE. 4
!
10 if (ax > 4.0) go to 30
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
   & + p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
   & + q(6))*ax + q(7))*ax + q(8)
y = top/bot
!
20 if (ind == 0) go to 21
if (x >= 0.0) return
if (e < 0.0) e = exp(-x*x)
y = 2.0/e - y
return
21 w = dble(x)*dble(x)
t = w
eps = w - dble(t)
if (e < 0.0) e = exp(-t)
y = ((0.5 + (0.5 - eps)) * e) * y
if (x < 0.0) y = 2.0 - y
return
!
!                      abs(x) .GT. 4
!
30 if (x <= -5.5) go to 40
if (ind == 0 .and. x > 50.0) go to 50
t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + s(5)
y = (c - t*top/bot) / ax
go to 20
!
!             Limit value for large negative x
!
40 y = 2.0
if (ind == 0) return
if (e < 0.0) e = exp(-x*x)
y = 2.0/e
return
!
!             Limit value for large positive x
!                       when ind = 0
!
50 y = 0.0
return
end subroutine erfc0

pure elemental real function erfcr(x)
implicit none
real, intent(in) :: x
real :: bot, t, top
real, parameter :: r(5) = [2.10144126479064e+00, 2.62370141675169e+01, 2.13688200555087e+01, 4.65807828718470e+00, &
   & 2.82094791773523e-01]
real, parameter :: s(4) = [9.41537750555460e+01, 1.87114811799590e+02, 9.90191814623914e+01, 1.80124575948747e+01]
!-----------------------------------------------------------------------
!     Computation of  1/sqrt(PI) - x*exp(x*x)*erfc(x)  for x .GE. 4
!-----------------------------------------------------------------------
!------------------------
!------------------------
t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erfcr = t*top/bot
return
end function erfcr

pure elemental subroutine pkill(r0, sx, sy, h, k, p)
implicit none
real, intent(in) :: h
real, intent(out) :: p
real, intent(in) :: r0, sx, sy
real, intent(in) :: k
integer :: i, ii, iy, iz, iz3, j, j8, n1, nt
real :: a, a1, a2, a4, c8, d, d1, d2, dm, e3, e4, eps, f, g2, g3, h1, h2, h3, h5, h6, h8, q, q1, r, r8, s0, s1, s2, s9, sa, seps1, &
   & sqeps, t, t1, t2, t3, t4, t5, t9, u, x1, x5, yy, z, z1, z2, z3, z8, z9, k8
real, parameter :: v(16) = [.4830766568773832e-01, .1444719615827965e+00, .2392873622521371e+00, .3318686022821276e+00, &
   & .4213512761306353e+00, .5068999089322294e+00, .5877157572407623e+00, .6630442669302152e+00, .7321821187402897e+00, &
   & .7944837959679424e+00, .8493676137325700e+00, .8963211557660521e+00, .9349060759377397e+00, .9647622555875064e+00, &
   & .9856115115452683e+00, .9972638618494816e+00]
real, parameter :: w(16) = [.9654008851472780e-01, .9563872007927486e-01, .9384439908080457e-01, .9117387869576388e-01, &
   & .8765209300440381e-01, .8331192422694676e-01, .7819389578707031e-01, .7234579410884851e-01, .6582222277636185e-01, &
   & .5868409347853555e-01, .5099805926237618e-01, .4283589802222668e-01, .3427386291302143e-01, .2539206530926206e-01, &
   & .1627439473090567e-01, .7018610009470097e-02]
real, parameter :: a3 = 20.0
real, parameter :: c = .4638648042895004
real, parameter :: rpi = .5641895835477563
real, parameter :: rt2 = 1.414213562373095
interface
   pure elemental function aerf(x,h)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: h
      real :: aerf
   end function aerf
   pure function epsln(l)
      implicit none
      integer, intent(in) :: l
      real :: epsln
   end function epsln
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental subroutine gratio(a,x,ans,qans,ind)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: x
      real, intent(inout) :: ans
      real, intent(inout) :: qans
      integer, intent(in) :: ind
   end subroutine gratio
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!           Computation of the elliptical coverage function
!
!                         ---------------
!
!     The result p is accurate to at least 6 significant digits if
!     p .GE. 1.E-20 AND max(h/S,k/S,sx/S,sy/S) .LE. 10/sqrt(spmpar(1))
!     FOR S = min(sx,sy).
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!   v(*), w(*)-- Gaussian abscissas and weights of order 32, on (-1,1).
!-----------------------------------------------------------------------
!----------------------------------------
!     c = (2**.25)*gamma(3/4)/pi
!     rpi = 1/sqrt(pi)
!     rt2 = sqrt(2)
!----------------------------------------
!
p = 0.0
if (sx > 0.0 .and. sy > 0.0) go to 5
p = -1.e10
return
5 j = 0
eps = spmpar(1)
sqeps = sqrt(eps)
a = 6.5
!----------------------------------------
!     Test no.1 (REPORT 83-13).
!----------------------------------------
z3 = min(sqrt(sqrt(spmpar(2))),1.e-30)*sx*sy
if (r0*r0 <= z3) return
!
h2 = h*h + k*k
h8 = abs(h)
k8 = abs(k)
dm = max(sx,sy)
!-----------------------------------------
!     Test no.2 (REPORT 83-13).
!-----------------------------------------
if ((r0 - h8 + a3*sx) <= 0.0) return
if ((r0 - k8 + a3*sy) <= 0.0) return
!-----------------------------------------
!     Test no.3 (REPORT 83-13).
!-----------------------------------------
c8 = - epsln(0)
!-----------exp(-10.3026) = 3.35E(-5)---------
a4 = max(c8 - 1.74249e1, 10.3026)
a4 = sqrt(a4 + a4)
h3 = (r0 - h)*(r0 + h)
h5 = (r0 - k)*(r0 + k)
s0 = a4*dm
t = r0 - s0
if (t < 0.0) go to 25
if (t*t < h2) go to 25
if (r0 < 1/sqeps) go to 20
t = h3 - 2.0*r0*s0 + s0*s0 - k*k
if (abs(h3) <= abs(h5)) go to 10
t = h5 - 2.0*r0*s0 + s0*s0 - h*h
10 if (t < 0.0) go to 25
20 p = 1.0
return
!-----------------------------------------
!     Test no.4 (REPORT 83-13).
!-----------------------------------------
25 s0 = sqrt(h2)
g2 = 0.0
if (s0 <= r0) go to 30
d = ((s0 - r0)/dm)**2
if (r0*r0*exp(-0.5*d) <= z3) return
!-----------------------------------------
!     sx - sy .LT. EPS
!-----------------------------------------
30 if (abs(sx - sy) > 20.0*dm*eps) go to 33
h8 = s0
k8 = 0.0
if ((r0 - h8 + a3*dm) <= 0.0) return
if (r0 < dm/sqeps) go to 33
j = 1
g2 = (k*k - h3)/((r0 + h8)*dm)
if (abs(h3) <= abs(h5)) go to 33
g2 = (h*h - h5)/((r0 + h8)*dm)
!--------------------------
!     Small R
!--------------------------
33 t1 = r0/sx
t2 = r0/sy
t3 = t1*t2
t1 = t1*t1
t2 = t2*t2
z1 = (h/sx)**2
z2 = (k/sy)**2
t = t1*(z1 - 1.0) + t2*(z2 - 1.0)
if (abs(t) > 1.e-3) go to 35
t9 = (t*t - 4.0*(t1*t1*(z1 - 0.5) + t2*t2*(z2 - 0.5)))/192.0
if (abs(t9) > max(10.0*eps,1.e-10)) go to 35
p = 0.5*t3*(1.0 + 0.125*t)*exp(-0.5*(z1 + z2))
return
!-----------------------------------------------
!     NORMALIZE AMAX1(sx,sy) = 1.
!-----------------------------------------------
35 r = r0/dm
s1 = sx/dm
s2 = sy/dm
h8 = h8/dm
k8 = k8/dm
h2 = h2/(dm*dm)
!---------------------------------
!     s1 = 1 .ge. s2
!---------------------------------
if (s1 >= s2) go to 40
h1 = s1
s1 = s2
s2 = h1
h1 = h8
h8 = k8
k8 = h1
!-----------------------------------------------
!     Limiting results for AMIN1(S1,S2) = 0
!-----------------------------------------------
40 seps1 = min(6.71*sqeps,1.e-5)
!-----------------------------------------------
!            r = k,  s2 small
!-----------------------------------------------
if (k8 /= r) go to 45
yy = .166484*(r*(h8*h8 + 1.0) + 1.0/r)*s2
if (abs(yy) > seps1) go to 85
h1 = h8/rt2
p = c*exp(-h1*h1)*sqrt(k8*s2)
return
!-----------------------------------------------
!            R .GT. k,  S2 SMALL
!-----------------------------------------------
45 if (r < k8) go to 85
if (k8 /= 0.0) go to 75
h1 = s2*s2/(4.0*rt2*r)
g2 = g2/rt2
if (j == 0) g2 = abs(h8 - r)/rt2
if (abs(g2) < 4.0) go to 55
if (h1*abs(g2) > seps1) go to 85
p = 0.5*aerf(h8/rt2,r/rt2)
return
55 if (j /= 0) go to 60
p = 0.5*aerf(h8/rt2,r/rt2)
go to 70
60 if (h8 + r < rt2) go to 65
p = 0.5*(erfc(g2) - erfc((h8 + r)/rt2))
go to 70
65 p = 0.5*(erf((h8 + r)/rt2) - erf(g2))
70 if (h1*exp(-g2*g2) > p*seps1) go to 85
return
!
75 z = (r - k8)*(r + k8)
g2 = sqrt(z)
h1 = abs(h8 - g2)
j = 0
if (h1 > 5.0) go to 80
j = 1
z8 = aerf(h8/rt2,g2/rt2)
if (z8 == 0.0) go to 85
h1 = exp(-0.5*(h8 - g2)**2)/z8
80 h1 = 1.0/(8.0*rt2*z)*(k8*k8*abs(h8 - g2) + r*r/g2)*s2*s2*h1
if (abs(h1) > seps1) go to 85
u = 0.5
if (j == 0) z8 = aerf(h8/rt2,g2/rt2)
s2 = rt2*s2
if (k8 - r > -13.0*s2) u = 0.25*aerf(k8/s2,r/s2)
p = u*z8
return
!----------------------------
!     Find the value of A
!----------------------------
85 s0 = s1*s1
s9 = s2*s2
g3 = h8*h8
g2 = k8*k8
z8 = s0 + s9
z = s0*s0 + s9*s9
h3 = g3*s0 + g2*s9
t1 = 2.0*(z + 2*h3)
yy = r*r*(h2 + z8)/t1
t1 = (h2 + z8)*(h2 + z8)/t1
call gratio(t1,yy,z,z8,0)
z2 = r/(rt2*s2)
r8 = r/(rt2*s1)
h2 = h8/(rt2*s1)
h3 = k8/(rt2*s2)
s0 = 0.0
s9 = 0.0
if (z < 1.e-13 .and. s2 > 5.e-10) go to 90
if (h2 > 50.0 .or. h3 > 50.0) s0 = 1.5
90 u = aerf(h3,z2)
yy = 0.25*u*aerf(h2,r8)
if (yy > 0.1) s9 = 0.5
if (yy >= 5.e-15) go to 95
z = yy
go to 100
95 z = min(yy,z)
!
100 if (z >= 0.5) go to 105
a = a + .5
if (z >= 5.e-4) go to 105
a = a + .5 + s0
if (z >= 1.e-6) go to 105
a = a + .5 + s9
if (z >= 5.e-9) go to 105
a = a + .5
if (z >= 5.e-10) go to 105
a = a + .25
if (z >= 5.e-11) go to 105
a = a + .25
if (z >= 5.e-12) go to 105
a = a + .25
if (z >= 5.e-13) go to 105
a = a + .5 + .5*s9
if (z > 5.e-15) go to 105
a = a + .5
if (z > 1.e-18) go to 105
a = a + .25
if (z > 1.e-20) go to 105
a = a + .25
if (z > 1.e-25) go to 105
a = a + 1.
if (z > 1.e-30) go to 105
a = a + 2.
!
105 if (s2 >= 5.e-2 .or. h3 <= z2) go to 107
t9 = r8*u*exp(-h2*h2)
if (t9 < 5.e-2 * z) a = a + 0.5
!---------------------------------------
!     Start integration procedure
!---------------------------------------
107 s0 = s1
s9 = s2
z8 = s2
g2 = k8
g3 = h8
z9 = s1
j8 = 0
!-------------------------------------------------
!     Determine interval of integration, (A,RT2).
!           e3 = (rt2-a)/2, d1 = (rt2+a)/2.
!-------------------------------------------------
110 z = g2 + a*z8
h3 = g2 - a*z8
h5 = 0.0
t3 = -1.0
a1 = (g3 - a*z9)/r
if (abs(a1 - 0.5) >= 0.5) go to 115
a2 = max(((1.0 - g3/r) + a*z9/r)*(1.0 + a1), 0.0)
sa = sqrt(a2)
if (sa < h3/r) go to 115
t3 = a1/sqrt(1.0 + sa)
!----------------------------------------
!            t9 = 1.0 - d1
!----------------------------------------
115 if (h3 > 0.0) go to 135
!----------------------------------------
!            H3 .LE. 0.0
!----------------------------------------
if (t3 < 0.0) go to 120
d2 = 0.5*(1.0 + t3)
e4 = 0.25*sa/d2
t5 = e4
120 if (z < r) go to 125
e3 = 0.5
d1 = e3
t9 = d1
go to 130
125 d1 = 0.5*(1.0 + sqrt(1.0 - z/r))
e3 = 0.25*z/(r*d1)
t9 = e3
130 if (t3 <= d1 - e3) go to 165
go to 160
!----------------------------------------
!            H3 .GT. 0.0
!----------------------------------------
135 h5 = 1.0
q = h3/r
if (q <= 1.0) go to 140
e3 = 0.5
d1 = e3
t9 = d1
go to 165
140 if (t3 < 0.0) go to 145
e4 = max((1.0 - g2/r) + a*z8/r, 0.0)
e4 = sqrt(e4)
d2 = 0.5*(e4 + t3)
t5 = 0.5*(q/(1.0 + e4) + sa/(1.0 + t3))
e4 = 0.25*(sa - q)/d2
145 e3 = max((1.0 - g2/r) + a*z8/r, 0.0)
if (z < r) go to 150
e3 = 0.5*sqrt(e3)
d1 = e3
t9 = 0.25*(3.0 + h3/r)/(1.0 + e3)
go to 155
150 t9 = sqrt(e3)
t2 = sqrt(1.0 - z/r)
d1 = 0.5*(t9 + t2)
e3 = a*z8/(r*2.0*d1)
t9 = 0.5*((h3/r)/(1.0 + t9) + (z/r)/(1.0 + t2))
155 if (t3 <= d1 - e3) go to 165
160 e3 = e4
d1 = d2
t9 = t5
165 if (j8 /= 0) go to 170
j8 = 1
f = e3
t = d1
t1 = t9
h6 = h5
z8 = s1
g2 = h8
g3 = k8
z9 = s2
go to 110
!-----------------------------------------------------------------------
!     Determine in which order the X amd Y integrations are carried out.
!-----------------------------------------------------------------------
170 if (s2 > 2.e-2 .and. h8 + k8 < 2.e2) go to 172
if (abs(e3 - f) > 0.4*f) go to 172
if (d1 - t) 200,180,195
172 if (e3 < 2.e4*eps) go to 195
if (f < 2.e4*eps) go to 200
if (max(h8/s1,k8/s2) < 2.0) go to 175
if (s2 < 1.e-5) go to 175
if (s2 >= 5.e-4) go to 180
if (s1 /= s2) go to 195
175 if (min(e3,f) < 2.5e-2*sqeps) goto 185
180 if (e3 - f) 200,190,195
185 if (e3 - f) 195,190,200
190 if (s0 >= s9) go to 200
195 e3 = f
d1 = t
t9 = t1
s9 = s1
s0 = s2
z8 = h8
h8 = k8
k8 = z8
h5 = h6
200 z2 = r/(rt2*s9)
r8 = r/(rt2*s0)
h2 = h8/(rt2*s0)
h3 = k8/(rt2*s9)
n1 = 16
iz = 0
iz3 = 0
iy = 0
p = 0.0
t = h2 - r8 + r8*(d1 - e3*v(16))**2
if (t > 0.0 .and. t*t > -exparg(1)) return
!
q1 = rpi*e3*r8
g3 = 0.0
nt = 2*n1 + 1
z = (.5 + d1) + .5
do 260 ii = 1, nt
   i = ii - (n1 + 1)
   if (i == 0) go to 260
   j = abs(i)
   q = e3*sign(1,i)*v(j)
   t = q + d1
   h6 = z + q
   q = t9 - q
   f = h6*q
   t1 = r8*f
   t2 = (h2 - t1)*(h2 - t1)
   if (h2 - r8 >= 0. .or. t < eps) t2 = &
      & ((h2 - r8) + r8*t*t)**2
   t4 = exp(-t2)
   if (h2 /= 0.0) go to 210
   t4 = t4 + t4
   go to 215
210 if (h5 /= 0.0) go to 215
   t2 = 4.0*h2*t1
   if (t2 > c8) go to 215
   t4 = t4*(1.0 + exp(-t2))
215 if (iz /= 0) go to 255
   g2 = sqrt(1.0 + f)
   z1 = z2*t*g2
   x1 = h3 - z1
   if (x1 > -a) go to 225
   iz = 1
   x5 = 2.0
   go to 255
225 if (abs(x1) > 1.e-2*z1) go to 230
   iy = 1
   x1 = ((k8 - r) + r*f*f/(1.0 + t*g2))/(rt2*s9)
230 if (iz3 /= 0) go to 250
   sa = h3 + z1
   if (sa > a3) go to 245
   if (iy == 0) go to 240
   if (x1 > rt2) go to 235
   x5 = erf(sa) - erf(x1)
   go to 255
235 x5 = erfc(x1) - erfc(sa)
   go to 255
240 x5 = aerf(h3,z1)
   go to 255
245 iz3 = 1
250 x5 = erfc(x1)
255 g3 = g3 + x5*t4*t*w(j)
260 continue
p = q1*g3
if (p > yy) p = yy
if (p > (1.0 - min(1.e6*eps,1.e-5))) p = 1.0
if (p < 0.0) p = 0.0
return
end subroutine pkill

pure subroutine plcopy(a,ka,m,b,kb,n)
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer :: j, jmax, la, lb, mp1
!     ------------------------------------------------------------------
!     Copying real polynomials
!     ------------------------------------------------------------------
!
la = 1
lb = 1
jmax = min(m, n)
do j = 1,jmax
   b(lb) = a(la)
   la = la + ka
   lb = lb + kb
end do
if (jmax == n) return
!
mp1 = m + 1
do j = mp1,n
   b(lb) = 0.0
   lb = lb + kb
end do
return
end subroutine plcopy

pure subroutine dpcopy(a,ka,m,b,kb,n)
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer :: j, jmax, la, lb, mp1
!     ------------------------------------------------------------------
!     Copying double precision polynomials
!     ------------------------------------------------------------------
!
la = 1
lb = 1
jmax = min(m, n)
do j = 1,jmax
   b(lb) = a(la)
   la = la + ka
   lb = lb + kb
end do
if (jmax == n) return
!
mp1 = m + 1
do j = mp1,n
   b(lb) = 0.d0
   lb = lb + kb
end do
return
end subroutine dpcopy

pure subroutine padd(a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Addition of real polynomials
!     ------------------------------------------------------------------
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.0
   if (i <= l) c(lc) = a(la)
   if (i <= m) c(lc) = c(lc) + b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine padd

pure subroutine dpadd(a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Addition of double precision polynomials
!     ------------------------------------------------------------------
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.d0
   if (i <= l) c(lc) = a(la)
   if (i <= m) c(lc) = c(lc) + b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine dpadd

pure subroutine psubt(a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Subtraction of real polynomials
!     ------------------------------------------------------------------
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.0
   if (i <= l) c(lc) = a(la)
   if (i <= m) c(lc) = c(lc) - b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine psubt

pure subroutine dpsubt(a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Subtraction of double precision polynomials
!     ------------------------------------------------------------------
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.d0
   if (i <= l) c(lc) = a(la)
   if (i <= m) c(lc) = c(lc) - b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine dpsubt

pure subroutine pmult(a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: i, imax, imin, j, jmax, jmin, la, lb, lc
double precision :: dsum
!     ------------------------------------------------------------------
!     Multiplication of real polynomials
!     ------------------------------------------------------------------
!
lc = 1
jmax = min(l + m - 1, n)
do 40 j = 1,jmax
   if (j <= l) go to 10
   imin = 1 + (j - l)
   la = 1 + (l - 1)*ka
   lb = 1 + (imin - 1)*kb
   go to 20
10 imin = 1
   la = 1 + (j - 1)*ka
   lb = 1
!
20 imax = min(j, m)
   dsum = 0.d0
   do i = imin,imax
      dsum = dsum + dble(a(la))*dble(b(lb))
      la = la - ka
      lb = lb + kb
   end do
   c(lc) = dsum
40 lc = lc + kc
if (jmax == n) return
!
jmin = jmax + 1
do 60 j = jmin,n
   c(lc) = 0.0
60 lc = lc + kc
return
end subroutine pmult

pure subroutine dpmult(a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
integer :: i, imax, imin, j, jmax, jmin, la, lb, lc
double precision :: sum
!     ------------------------------------------------------------------
!     Multiplication of double precision polynomials
!     ------------------------------------------------------------------
!
lc = 1
jmax = min(l + m - 1, n)
do 40 j = 1,jmax
   if (j <= l) go to 10
   imin = 1 + (j - l)
   la = 1 + (l - 1)*ka
   lb = 1 + (imin - 1)*kb
   go to 20
10 imin = 1
   la = 1 + (j - 1)*ka
   lb = 1
!
20 imax = min(j, m)
   sum = 0.d0
   do i = imin,imax
      sum = sum + a(la)*b(lb)
      la = la - ka
      lb = lb + kb
   end do
   c(lc) = sum
40 lc = lc + kc
if (jmax == n) return
!
jmin = jmax + 1
do 60 j = jmin,n
   c(lc) = 0.d0
60 lc = lc + kc
return
end subroutine dpmult

pure subroutine pdiv(a,ka,l,b,kb,m,c,kc,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: i, ib, ic, imax, j, la, lc
real :: b0
double precision :: dsum
!     ------------------------------------------------------------------
!     Division of real polynomials
!     ------------------------------------------------------------------
!
b0 = b(1)
if (b0 == 0.0) go to 100
ierr = 0
c(1) = a(1)/b0
if (n == 1) return
!
!               Case when m = 1
!
if (m > 1) go to 20
la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   c(lc) = 0.0
   if (j <= l) c(lc) = a(la)/b0
end do
return
!
!              Case when m .GT. 1
!
20 la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   ib = 1
   ic = lc
   dsum = 0.d0
   if (j <= l) dsum = a(la)
   imax = min(j, m)
   do i = 2,imax
      ib = ib + kb
      ic = ic - kc
      dsum = dsum - dble(b(ib))*dble(c(ic))
   end do
   c(lc) = sngl(dsum)/b0
end do
return
!
!                Error return
!
100 ierr = 1
return
end subroutine pdiv

pure subroutine dpdiv(a,ka,l,b,kb,m,c,kc,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
integer :: i, ib, ic, imax, j, la, lc
double precision :: b0, sum
!     ------------------------------------------------------------------
!     Division of double precision polynomials
!     ------------------------------------------------------------------
!
b0 = b(1)
if (b0 == 0.d0) go to 100
ierr = 0
c(1) = a(1)/b0
if (n == 1) return
!
!               Case when m = 1
!
if (m > 1) go to 20
la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   c(lc) = 0.d0
   if (j <= l) c(lc) = a(la)/b0
end do
return
!
!              Case when m .GT. 1
!
20 la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   ib = 1
   ic = lc
   sum = 0.d0
   if (j <= l) sum = a(la)
   imax = min(j, m)
   do i = 2,imax
      ib = ib + kb
      ic = ic - kc
      sum = sum - b(ib)*c(ic)
   end do
   c(lc) = sum/b0
end do
return
!
!                Error return
!
100 ierr = 1
return
end subroutine dpdiv

pure subroutine plpwr(r,a,ka,m,b,kb,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: r
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer :: i, ia, ib, imax, j, lb
real :: a0, jm1
double precision :: coeff, dsum, rp1
!     ------------------------------------------------------------------
!     SET b = a**r WHERE A IS A REAL POLYNOMIAL
!     ------------------------------------------------------------------
!
a0 = a(1)
if (a0 <= 0.0) go to 100
ierr = 0
b(1) = a0**r
if (n == 1) return
!
!            Case when m = 1 Or r = 0
!
if (m > 1 .and. r /= 0.0) go to 20
lb = 1
do j = 2,n
   lb = lb + kb
   b(lb) = 0.0
end do
return
!
!                  General case
!
20 rp1 = dble(r) + 1.d0
lb = 1
do j = 2,n
   lb = lb + kb
   jm1 = j - 1
   ia = 1
   ib = lb
   coeff = -jm1
   dsum = 0.d0
   imax = min(j, m)
   do i = 2,imax
      ia = ia + ka
      ib = ib - kb
      coeff = coeff + rp1
      dsum = dsum + coeff*dble(a(ia))*dble(b(ib))
   end do
   b(lb) = sngl(dsum)/(jm1*a0)
end do
return
!
!                Error return
!
100 ierr = 1
return
end subroutine plpwr

pure subroutine dplpwr(r,a,ka,m,b,kb,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
double precision, intent(in) :: r
integer :: i, ia, ib, imax, j, lb
double precision :: a0, coeff, jm1, rp1, sum
!     ------------------------------------------------------------------
!     Set b = a**r where A is a double precision polynomial
!     ------------------------------------------------------------------
!
a0 = a(1)
if (a0 <= 0.d0) go to 100
ierr = 0
b(1) = a0**r
if (n == 1) return
!
!            Case when m = 1 Or r = 0
!
if (m > 1 .and. r /= 0.d0) go to 20
lb = 1
do j = 2,n
   lb = lb + kb
   b(lb) = 0.d0
end do
return
!
!                  General case
!
20 rp1 = r + 1.d0
lb = 1
do j = 2,n
   lb = lb + kb
   jm1 = j - 1
   ia = 1
   ib = lb
   coeff = -jm1
   sum = 0.d0
   imax = min(j, m)
   do i = 2,imax
      ia = ia + ka
      ib = ib - kb
      coeff = coeff + rp1
      sum = sum + coeff*a(ia)*b(ib)
   end do
   b(lb) = sum/(jm1*a0)
end do
return
!
!                Error return
!
100 ierr = 1
return
end subroutine dplpwr

pure subroutine pinv(a, d, n, q)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(n)
real, intent(inout) :: d(n), q(*)
integer :: i, j, jj, k, l, l0, ll, m
real :: s, sum, t, u
!-----------------------------------------------------------------------
!          Computation of the inverse of the power series
!                  sum (a(i)*X**i, i = 1,2,...)
!-----------------------------------------------------------------------
!----------------------------
!     num = (n*(n + 1))/2
!     real q(num)
!----------------------------
!
!                 Compute the coefficient matrix q
!
q(1) = 1.0
k = 2
do 10 i = 2,n
   q(k) = 0.0
10 k = k + i
!
jj = 1
do j = 2,n
   l0 = jj
   jj = (j*(j + 1))/2
   k = jj
   do i = j,n
      sum = 0.0
      m = i - j + 2
      ll = l0
      do l = j,i
         sum = sum + a(m)*q(ll)
         m = m - 1
         ll = ll + (l - 1)
      end do
      q(k) = sum
      k = k + i
   end do
end do
!
!              Compute the coefficients of the inverse
!
k = 1
do j = 1,n
   u = 1.0/(j*a(1)**j)
   sum = 0.0
   do l = 1,j
      sum = sum + u*q(k)
      s = l + j - 1
      t = l
      u = -(s*u)/(t*a(1))
      k = k + 1
   end do
   d(j) = sum
end do
return
end subroutine pinv

pure subroutine dpinv(a, d, n, q)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(n)
double precision, intent(inout) :: d(n), q(*)
integer :: i, j, jj, k, l, l0, ll, m
double precision :: s, sum, t, u
!-----------------------------------------------------------------------
!          Computation of the inverse of the power series
!                  sum (a(i)*X**i, i = 1,2,...)
!-----------------------------------------------------------------------
!----------------------------
!     num = (n*(n + 1))/2
!     real q(num)
!----------------------------
!
!                 Compute the coefficient matrix q
!
q(1) = 1.d0
k = 2
do 10 i = 2,n
   q(k) = 0.d0
10 k = k + i
!
jj = 1
do j = 2,n
   l0 = jj
   jj = (j*(j + 1))/2
   k = jj
   do i = j,n
      sum = 0.d0
      m = i - j + 2
      ll = l0
      do l = j,i
         sum = sum + a(m)*q(ll)
         m = m - 1
         ll = ll + (l - 1)
      end do
      q(k) = sum
      k = k + i
   end do
end do
!
!              Compute the coefficients of the inverse
!
k = 1
do j = 1,n
   u = 1.d0/(j*a(1)**j)
   sum = 0.d0
   do l = 1,j
      sum = sum + u*q(k)
      s = l + j - 1
      t = l
      u = -(s*u)/(t*a(1))
      k = k + 1
   end do
   d(j) = sum
end do
return
end subroutine dpinv

subroutine mplnmv(mo, au, nc, ac, fv)
implicit none
integer, intent(in) :: mo, nc
real :: ac(*)
real, intent(in) :: au
real, intent(out) :: fv
integer :: k, l
real :: ql
!     ******************************************************************
!     Fortran subroutine for multiplex polynomial evaluation
!     ******************************************************************
!     mo = Mode of operation
!     au = ARGUMENT U
!     nc = Number of coefficients
!     ac = Array of coefficients
!     fv = FUNCTION V
!
!     mo = -1 For integral
!     mo =  0 For function
!     mo = +1 For first derivative
!     mo = +2 For second derivative
!
001 fv = 0.0
l = nc
if (mo < 0) go to 002
if (mo == 0) go to 004
if (mo == 1) go to 006
if (mo >= 2) go to 008
002 ql = nc
do 003 k = 1,nc
   fv = ac(l)/ql + au*fv
   l = l - 1
   ql = ql - 1.0
003 continue
fv = au*fv
return
004 do k = 1,nc
   fv = ac(l) + au*fv
   l = l - 1
end do
return
006 if (nc <= 1) return
ql = nc
do k = 2,nc
   ql = ql - 1.0
   fv = ql*ac(l) + au*fv
   l = l - 1
end do
return
008 if (nc <= 2) return
ql = nc
do k = 3,nc
   ql = ql - 1.0
   fv = ql*(ql - 1.0)*ac(l) + au*fv
   l = l - 1
end do
return
end subroutine mplnmv

pure real function csevl(x, a, n)
implicit none
integer, intent(in) :: n
real, intent(in) :: x
real, intent(in) :: a(n)
integer :: i, k
real :: s0, s1, s2, x2
!-----------------------------------------------------------------------
!          Evaluate the n term Chebyshev series A at x.
!          Only half of the first coefficient is used.
!-----------------------------------------------------------------------
!
if (n > 1) go to 10
csevl = 0.5 * a(1)
return
!
10 x2 = x + x
s0 = a(n)
s1 = 0.0
do i = 2,n
   s2 = s1
   s1 = s0
   k = n - i + 1
   s0 = x2*s1 - s2 + a(k)
end do
csevl = 0.5 * (s0 - s2)
return
end function csevl

pure double precision function dcsevl(x, a, n)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(n), x
integer :: i, k
double precision :: x2, s0, s1, s2
!-----------------------------------------------------------------------
!          Evaluate the n term Chebyshev series A at x.
!          Only half of the first coefficient is used.
!-----------------------------------------------------------------------
!
if (n > 1) go to 10
dcsevl = 0.5d0 * a(1)
return
!
10 x2 = x + x
s0 = a(n)
s1 = 0.d0
do i = 2,n
   s2 = s1
   s1 = s0
   k = n - i + 1
   s0 = x2*s1 - s2 + a(k)
end do
dcsevl = 0.5d0 * (s0 - s2)
return
end function dcsevl

subroutine lgrngn(au, na, an)
implicit none
integer, intent(in) :: na
real, intent(inout) :: an(*)
real :: au(*)
integer :: k, m
real :: dm, tm
!     ******************************************************************
!     Fortran subroutine for Lagrangian normalization factors
!     ******************************************************************
!     au = COORDINATE ARGUMENTS  (N-ARRAY)
!     na = Number of arguments   (N)
!     an = NORMALIZATION FACTORS (N-ARRAY)
!
001 do k = 1,na
   tm = 1.0
   do 002 m = 1,na
      if (m == k) go to 002
      dm = au(k) - au(m)
      tm = dm*tm
002   continue
   an(k) = tm
end do
return
end subroutine lgrngn

subroutine lgrngv(mo, na, qu, au, an, ff, df, sf)
implicit none
integer, intent(in) :: mo, na
real :: an(*), au(*)
real, intent(inout) :: df(*), ff(*)
real, intent(in) :: qu
real, intent(inout) :: sf(*)
integer :: k, l
real :: dm, rm, sm, tm
logical :: ln
!     ******************************************************************
!     Fortran subroutine for Lagrangian function evaluation
!     ******************************************************************
!     mo = Mode of operation
!     na = Number of stations
!     qu = Argument of functions
!     au = STATION COORDINATES                    (N-ARRAY)
!     an = NORMALIZATION FACTORS                  (N-ARRAY)
!     ff = LAGRANGIAN FUNCTIONS                   (N-ARRAY)
!     df = FIRST DERIVATIVES                      (N-ARRAY)
!     sf = SECOND DERIVATIVES                     (N-ARRAY)
!
!     call lgrngv (0, na, qu, au, an, ff)         for functions
!     call lgrngv (1, na, qu, au, an, ff, df)     for first derivatives
!     call lgrngv (2, na, qu, au, an, ff, df, sf) for second derivatives
!
001 ln = .true.
tm = 1.0
do 003 k = 1,na
   if (qu /= au(k)) go to 002
   ln = .false.
   go to 003
002 dm = qu - au(k)
   tm = dm*tm
003 continue
do k = 1,na
   if (ln) go to 005
   if (qu /= au(k)) go to 005
   ff(k) = tm
   go to 006
005 dm = qu - au(k)
   ff(k) = tm/dm
006 ff(k) = ff(k)/an(k)
end do
if (mo <= 0) go to 050
sm = 0.0
do 013 k = 1,na
   df(k) = sm
   if (ln) go to 012
   if (qu == au(k)) go to 013
012 dm = qu - au(k)
   sm = sm + 1.0/dm
013 continue
rm = sm
if (mo == 1) go to 040
sm = 0.0
do 023 k = 1,na
   sf(k) = sm
   if (ln) go to 022
   if (qu == au(k)) go to 023
022 dm = qu - au(k)
   sm = sm + 2.0*df(k)/dm
023 continue
sm = 0.0
tm = 0.0
l = na
if (ln) go to 034
do k = 1,na
   sf(l) = tm + sf(l) + 2.0*sm*df(l)
   if (qu == au(l)) go to 032
   sf(l) = 2.0*(sm + df(l))
   dm = qu - au(l)
   tm = tm + 2.0*sm/dm
   sm = sm + 1.0/dm
032 l = l - 1
end do
go to 036
034 do k = 1,na
   sf(l) = tm + sf(l) + 2.0*sm*df(l)
   dm = qu - au(l)
   tm = tm + 2.0*sm/dm
   sm = sm + 1.0/dm
   l = l - 1
end do
036 do k = 1,na
   sf(k) = ff(k)*sf(k)
end do
040 if (ln) go to 043
do 042 k = 1,na
   if (qu /= au(k)) go to 041
   df(k) = rm
   ff(k) = 1.0
   go to 042
041 df(k) = ff(k)
   ff(k) = 0.0
042 continue
return
043 sm = 0.0
l = na
do k = 1,na
   df(l) = ff(l)*(sm + df(l))
   sm = sm + 1.0/(qu - au(l))
   l = l - 1
end do
return
050 if (ln) go to 053
do 052 k = 1,na
   ff(k) = 0.0
   if (qu /= au(k)) go to 052
   ff(k) = 1.0
052 continue
053 return
end subroutine lgrngv

subroutine lgrngx(au, na, ac)
implicit none
integer, intent(in) :: na
real, intent(inout) :: ac(*)
real :: au(*)
integer :: i, j, k, l
real :: sm, td, tm
!     ******************************************************************
!     Fortran subroutine for Lagrangian polynomial expansion
!     ******************************************************************
!     au = COORDINATE ARGUMENTS    (N-ARRAY)
!     na = Number of arguments     (N)
!     ac = Polynomial coefficients (NX(N+1) array)
!
001 do 003 i = 1,na
   k = (i - 1)*na
   l = k + i
   ac(l) = 1.0
   sm = 0.0
   do 002 j = 1,i
      k = k + 1
      l = k + na
      ac(l) = sm - au(i)*ac(k)
      sm = ac(k)
002   continue
003 continue
do i = 1,na
   k = na + na*na
   l = i*na
   ac(l) = 1.0
   do j = 2,na
      sm = au(i)*ac(l)
      l = l - 1
      ac(l) = sm + ac(k)
      k = k - 1
   end do
end do
do i = 1,na
   tm = 1.0
   do 006 j = 1,na
      if (j == i) go to 006
      td = au(i) - au(j)
      tm = tm*td
006   continue
   k = (i - 1)*na
   do j = 1,na
      k = k + 1
      ac(k) = ac(k)/tm
   end do
end do
return
end subroutine lgrngx

subroutine orthos(au, ma, aa, na, ar)
implicit none
integer, intent(in) :: ma, na
real, intent(inout) :: aa(*), ar(*)
real :: au(*)
integer :: i, j, k, l, m
real :: rm, rn, sm, sn
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial synthesis
!     ******************************************************************
!     au = COORDINATE ARGUMENTS    (N ARRAY)
!     ma = Number of columns       (m)
!     aa = Matrix of polynomials   (NXM array)
!     na = Number of rows          (N)
!     ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!
001 sn = na
rn = sqrt(sn)
do 002 i = 1,na
   aa(i) = 1.0/rn
002 continue
if (ma == 1) return
003 sm = 0.0
do i = 1,na
   sm = sm + au(i)
end do
ar(2) = sm/sn
sm = 0.0
l = na
do 005 i = 1,na
   l = l + 1
   aa(l) = au(i) - ar(2)
   sm = sm + aa(l)*aa(l)
005 continue
rm = sqrt(sm)
l = na
do i = 1,na
   l = l + 1
   aa(l) = aa(l)/rm
end do
sm = 0.0
l = na
do i = 1,na
   l = l + 1
   sm = sm + au(i)*aa(l)
end do
ar(1) = sm/rn
if (ma == 2) return
008 do m = 3,ma
   sm = 0.0
   k = (m - 2)*na
   do i = 1,na
      k = k + 1
      sm = sm + au(i)*aa(k)*aa(k)
   end do
   ar(2*m - 2) = sm
   sm = 0.0
   j = (m - 3)*na
   do i = 1,na
      j = j + 1
      k = j + na
      l = k + na
      aa(l) = au(i)*aa(k) - ar(2*m - 2)*aa(k) - ar(2*m - 5)*aa(j)
      sm = sm + aa(l)*aa(l)
   end do
   rm = sqrt(sm)
   l = (m - 1)*na
   do i = 1,na
      l = l + 1
      aa(l) = aa(l)/rm
   end do
   sm = 0.0
   k = (m - 2)*na
   do i = 1,na
      k = k + 1
      l = k + na
      sm = sm + au(i)*aa(k)*aa(l)
   end do
   ar(2*m - 3) = sm
end do
return
end subroutine orthos

subroutine orthov(mo, na, au, ar, nf, ff, df, sf)
implicit none
integer, intent(in) :: mo, na, nf
real :: ar(*)
real, intent(in) :: au
real, intent(inout) :: df(*), ff(*), sf(*)
integer :: k, l
real :: rn, sn
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial evaluation
!     ******************************************************************
!     mo = Mode of operation
!     na = Number of coordinates
!     au = Argument of functions
!     ar = RECURRENCE COEFFICIENTS                (2*M-2 ARRAY)
!     nf = Number of functions                    (M)
!     ff = ORTHONORMAL FUNCTIONS                  (M-ARRAY)
!     df = FIRST DERIVATIVES                      (M-ARRAY)
!     sf = SECOND DERIVATIVES                     (M-ARRAY)
!
!     call orthov (0, na, au, ar, nf, ff)         for functions
!     call orthov (1, na, au, ar, nf, ff, df)     for first derivatives
!     call orthov (2, na, au, ar, nf, ff, df, sf) for second derivatives
!
001 sn = na
rn = sqrt(sn)
ff(1) = 1.0/rn
if (nf <= 1) go to 003
ff(2) = (au - ar(2))*ff(1)/ar(1)
if (nf == 2) go to 003
l = 2
do 002 k = 3,nf
   l = l + 2
   ff(k) = ((au - ar(l))*ff(k - 1) - ar(l - 3)*ff(k - 2))/ar(l - 1)
002 continue
003 if (mo <= 0) return
df(1) = 0.0
if (nf <= 1) go to 005
df(2) = ff(1)/ar(1)
if (nf == 2) go to 005
l = 2
do k = 3,nf
   l = l + 2
   df(k) = (ff(k - 1) + (au - ar(l))*df(k - 1) - ar(l - 3)*df(k - 2))/ar(l - 1)
end do
005 if (mo == 1) return
sf(1) = 0.0
if (nf <= 1) go to 007
sf(2) = 0.0
if (nf == 2) go to 007
l = 2
do k = 3,nf
   l = l + 2
   sf(k) = (2.0*df(k - 1) + (au - ar(l))*sf(k - 1) - ar(l - 3)*sf(k - 2))/ar(l - 1)
end do
007 return
end subroutine orthov

subroutine orthox(na, ar, nc, ac)
implicit none
integer, intent(in) :: na, nc
real, intent(inout) :: ac(*)
real :: ar(*)
integer :: j, k, l, m, n
real :: rn, sn, tm
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial expansion
!     ******************************************************************
!     na = Number of arguments     (n)
!     ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!     nc = Number of coefficients  (m)
!     ac = POLYNOMIAL COEFFICIENTS (m*m ARRAY)
!
001 do 002 n = 1,nc
   ac(n) = 0.0
002 continue
sn = na
rn = sqrt(sn)
ac(1) = 1.0/rn
if (nc == 1) return
003 tm = 0.0
l = nc
do n = 1,nc
   l = l + 1
   ac(l) = (tm - ar(2)*ac(n))/ar(1)
   tm = ac(n)
end do
if (nc == 2) return
005 do m = 3,nc
   tm = 0.0
   j = (m - 3)*nc
   do n = 1,nc
      j = j + 1
      k = j + nc
      l = k + nc
      ac(l) = (tm - ar(2*m - 2)*ac(k) - ar(2*m - 5)*ac(j))/ar(2*m - 3)
      tm = ac(k)
   end do
end do
return
end subroutine orthox

real function zeroin(f, ax, bx, aerr, rerr)
implicit none
!-----------------------------------------------------------------------
!
!         Finding a zero of the function f(X) in the interval (ax,bx)
!
!                       ------------------------
!
!  Input...
!
!  f      FUNCTION SUBPROGRAM WHICH EVALUATES f(X) FOR ANY X IN THE
!         closed interval (ax,bx). It is assumed that f is continuous,
!         and that f(ax) and f(bx) have different signs.
!  ax     LEFT ENDPOINT OF THE INTERVAL
!  bx     RIGHT ENDPOINT OF THE INTERVAL
!  aerr   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
!  rerr   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
!
!  Output...
!
!         Abcissa approximating a zero of f in the interval (ax,bx)
!
!-----------------------------------------------------------------------
!  zeroin is a slightly modified translation of the Algol procedure
!  zero given by richard Brent in algorithms for minimization without
!  derivatives, Prentice-Hall, inc. (1973).
!-----------------------------------------------------------------------
real :: f
real, intent(in) :: ax, bx, aerr, rerr
external f
real :: a, b, c, d, e, eps, fa, fb, fc, tol, xm, p, q, r, s, atol, &
   & rtol
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
!  Compute eps, the relative machine precision
!
eps = spmpar(1)
!
! Initialization
!
a = ax
b = bx
fa = f(a)
fb = f(b)
atol = 0.5*aerr
rtol = max(0.5*rerr,2.0*eps)
!
! Begin step
!
10 c = a
fc = fa
d = b - a
e = d
20 if (abs(fc) >= abs(fb)) go to 40
a = b
b = c
c = a
fa = fb
fb = fc
fc = fa
!
! Convergence test
!
40 tol = rtol*max(abs(b),abs(c)) + atol
xm = 0.5*(c - b)
if (abs(xm) <= tol) go to 90
if (fb == 0.0) go to 90
!
! Is bisection necessary
!
if (abs(e) < tol) go to 70
if (abs(fa) <= abs(fb)) go to 70
!
! Is quadratic interpolation possible
!
if (a /= c) go to 50
!
! Linear interpolation
!
s = fb/fc
p = (c - b)*s
q = 1.0 - s
go to 60
!
! Inverse quadratic interpolation
!
50 q = fa/fc
r = fb/fc
s = fb/fa
p = s*((c - b)*q*(q - r) - (b - a)*(r - 1.0))
q = (q - 1.0)*(r - 1.0)*(s - 1.0)
!
! Adjust signs
!
60 if (p > 0.0) q = -q
p = abs(p)
!
! Is interpolation acceptable
!
if (2.0*p >= (3.0*xm*q - abs(tol*q))) go to 70
if (p >= abs(0.5*e*q)) go to 70
e = d
d = p/q
go to 80
!
! Bisection
!
70 d = xm
e = d
!
! Complete step
!
80 a = b
fa = fb
if (abs(d) > tol) b = b + d
if (abs(d) <= tol) b = b + sign(tol,xm)
fb = f(b)
if ((fb*(fc/abs(fc))) > 0.0) go to 10
go to 20
!
! Done
!
90 zeroin = b
return
end function zeroin

double precision function dzero(f, ax, bx, aerr, rerr)
implicit none
!-----------------------------------------------------------------------
!
!         Finding a zero of the function f(X) in the interval (ax,bx)
!
!                       ------------------------
!
!  Input...
!
!  f      FUNCTION SUBPROGRAM WHICH EVALUATES f(X) FOR ANY X IN THE
!         closed interval (ax,bx). It is assumed that f is continuous,
!         and that f(ax) and f(bx) have different signs.
!  ax     LEFT ENDPOINT OF THE INTERVAL
!  bx     RIGHT ENDPOINT OF THE INTERVAL
!  aerr   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
!  rerr   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
!
!  Output...
!
!         Abcissa approximating a zero of f in the interval (ax,bx)
!
!-----------------------------------------------------------------------
!  dzero is a slightly modified translation of the Algol procedure
!  zero given by richard Brent in algorithms for minimization without
!  derivatives, Prentice-Hall, inc. (1973).
!-----------------------------------------------------------------------
double precision :: f
double precision, intent(in) :: ax, bx, aerr, rerr
external f
double precision :: a, b, c, d, e, eps, fa, fb, fc, tol, xm, p, q, &
   & r, s, atol, rtol
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!
!  Compute eps, the relative machine precision
!
eps = dpmpar(1)
!
! Initialization
!
a = ax
b = bx
fa = f(a)
fb = f(b)
atol = 0.5d0*aerr
rtol = max(0.5d0*rerr,2.d0*eps)
!
! Begin step
!
10 c = a
fc = fa
d = b - a
e = d
20 if (abs(fc) >= abs(fb)) go to 40
a = b
b = c
c = a
fa = fb
fb = fc
fc = fa
!
! Convergence test
!
40 tol = rtol*max(abs(b),abs(c)) + atol
xm = 0.5d0*(c - b)
if (abs(xm) <= tol) go to 90
if (fb == 0.d0) go to 90
!
! Is bisection necessary
!
if (abs(e) < tol) go to 70
if (abs(fa) <= abs(fb)) go to 70
!
! Is quadratic interpolation possible
!
if (a /= c) go to 50
!
! Linear interpolation
!
s = fb/fc
p = (c - b)*s
q = 1.d0 - s
go to 60
!
! Inverse quadratic interpolation
!
50 q = fa/fc
r = fb/fc
s = fb/fa
p = s*((c - b)*q*(q - r) - (b - a)*(r - 1.d0))
q = (q - 1.d0)*(r - 1.d0)*(s - 1.d0)
!
! Adjust signs
!
60 if (p > 0.d0) q = -q
p = abs(p)
!
! Is interpolation acceptable
!
if (2.d0*p >= (3.d0*xm*q - abs(tol*q))) go to 70
if (p >= abs(0.5d0*e*q)) go to 70
e = d
d = p/q
go to 80
!
! Bisection
!
70 d = xm
e = d
!
! Complete step
!
80 a = b
fa = fb
if (abs(d) > tol) b = b + d
if (abs(d) <= tol) b = b + sign(tol,xm)
fb = f(b)
if ((fb*(fc/abs(fc))) > 0.d0) go to 10
go to 20
!
! Done
!
90 dzero = b
return
end function dzero

subroutine hbrd(fcn,n,x,fvec,epsfcn,tol,info,wa,lwa)
implicit none
integer :: n
integer, intent(out) :: info
integer, intent(in) :: lwa
real, intent(in) :: epsfcn, tol
real, intent(inout) :: x(n), fvec(n), wa(lwa)
external fcn
integer :: index, j, lr, maxfev, ml, mode, mu, nfev, nprint
real :: xtol
real, parameter :: factor = 1.0e2
real, parameter :: one = 1.0e0
real, parameter :: zero = 0.0e0
!     **********
!
!     SUBROUTINE hbrd
!
!       The purpose of hbrd is to find a zero of a system of
!     n nonlinear functions in n variables by a modification
!     of the Powell hybrid method. This is done by using the
!     more general nonlinear equation solver hybrd. The user
!     must provide a subroutine which calculates the functions.
!     The Jacobian is then calculated by a forward-difference
!     approximation.
!
!     The subroutine statement is
!
!       subroutine hbrd(fcn,n,x,fvec,epsfcn,tol,info,wa,lwa)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(n,x,fvec,iflag)
!         integer n,iflag
!         real x(n),fvec(n)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ---------
!         return
!         end
!
!         The value of IFLAG should not be changed by FCN unless
!         the user wants to terminate the execution of hbrd.
!         In this case set IFLAG to a negative integer.
!
!       n is a positive integer input variable SET to the number
!         of functions and variables.
!
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!
!       fvec is an output array of length n which contains
!         the functions evaluated at the output x.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       tol is a nonnegative input variable. Termination occurs
!         when the algorithm estimates that the relative error
!         between x and the solution is at most tol.
!
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of IFLAG. See description of FCN. Otherwise,
!         info is set as follows.
!
!         info = 0   Improper input parameters.
!
!         info = 1   Algorithm estimates that the relative error
!                    between x and the solution is at most tol.
!
!         info = 2   Number of calls to FCN has reached or exceeded
!                    200*(n+1).
!
!         info = 3   tol is too small. No further improvement in
!                    the approximate solution x is possible.
!
!         info = 4   Iteration is not making good progress.
!
!       wa is a work array of length lwa.
!
!       lwa is a positive integer input variable NOT less than
!         (n*(3*n+13))/2.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... hybrd
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
info = 0
!
!     Check the input parameters for errors.
!
if (n <= 0 .or. epsfcn < zero .or. tol < zero .or. &
   & lwa < (n*(3*n + 13))/2) go to 20
!
!     CALL hybrd.
!
maxfev = 200*(n + 1)
xtol = tol
ml = n - 1
mu = n - 1
mode = 2
do j = 1, n
   wa(j) = one
end do
nprint = 0
lr = (n*(n + 1))/2
index = 6*n + lr
call hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,wa(1),mode, &
   & factor,nprint,info,nfev,wa(index + 1),n,wa(6*n + 1),lr, &
   & wa(n + 1),wa(2*n + 1),wa(3*n + 1),wa(4*n + 1),wa(5*n + 1))
if (info == 5) info = 4
20 continue
return
!
!     Last card of subroutine hbrd.
!
end subroutine hbrd

subroutine hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,diag, &
   & mode,factor,nprint,info,nfev,fjac,ldfjac,r,lr, &
   & qtf,wa1,wa2,wa3,wa4)
implicit none
integer :: n
integer, intent(in) :: maxfev, ml, mu, mode, nprint
integer, intent(out) :: info, nfev
integer, intent(in) :: ldfjac, lr
real, intent(in) :: xtol, epsfcn, factor
real, intent(inout) :: x(n), fvec(n), diag(n), fjac(ldfjac,n), &
   & r(lr), qtf(n), wa1(n), wa2(n), wa3(n)
real :: wa4(n)
external fcn
integer :: i, iflag, iter, j, jm1, l, msum, ncfail, ncsuc, nslow1, nslow2, iwa(1)
logical :: jeval, sing
real :: actred, delta, epsmch, fnorm, fnorm1, pnorm, prered, ratio, sum, temp, xnorm
real :: enorm
real, parameter :: one = 1.0e0
real, parameter :: p1 = 1.0e-1
real, parameter :: p5 = 5.0e-1
real, parameter :: p001 = 1.0e-3
real, parameter :: p0001 = 1.0e-4
real, parameter :: zero = 0.0e0
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     **********
!
!     SUBROUTINE hybrd
!
!     The purpose of hybrd is to find a zero of a system of
!     n nonlinear functions in n variables by a modification
!     of the Powell hybrid method. The user must provide A
!     subroutine which calculates the functions. The Jacobian is
!     then calculated by a forward-difference approximation.
!
!     The subroutine statement is
!
!       subroutine hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,
!                        diag,mode,factor,nprint,info,nfev,fjac,
!                        ldfjac,R,lr,QTF,WA1,WA2,WA3,wa4)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(n,x,fvec,iflag)
!         integer n,iflag
!         real x(n),fvec(n)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ---------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of hybrd.
!         In this case set iflag to a negative integer.
!
!       n is a positive integer input variable SET to the number
!         of functions and variables.
!
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!
!       fvec is an output array of length n which contains
!         the functions evaluated at the output x.
!
!       xtol is a nonnegative input variable. Termination
!         occurs when the relative error between two consecutive
!         iterates is at most xtol.
!
!       maxfev is a positive integer input variable. Termination
!         occurs when the number of calls to FCN is at least maxfev
!         by the end of an iteration.
!
!       ml is a nonnegative integer input variable which specifies
!         the number of subdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         ml to at least n - 1.
!
!       mu is a nonnegative integer input variable which specifies
!         the number of superdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         mu to at least n - 1.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       Diag is an array of length n. if mode = 1 (see
!         below), diag is internally set. If mode = 2, diag
!         must contain positive entries that serve as
!         multiplicative scale factors for the variables.
!
!       Mode is an integer input variable. If mode = 1, the
!         variables will be scaled internally. If mode = 2,
!         the scaling is specified by the input diag. Other
!         values of mode are equivalent to mode = 1.
!
!       Factor is a positive input variable used in determining the
!         initial step bound. This bound is set to the product of
!         factor and the Euclidean norm of diag*x if nonzero, or else
!         to factor itself. In most cases factor should lie in the
!         interval (.1,100.). 100. Is a generally recommended value.
!
!       nprint is an integer input variable that enables controlled
!         printing of iterates if it is positive. In this case,
!         FCN is called with iflag = 0 At the beginning of the first
!         iteration and every nprint iterations thereafter and
!         immediately prior to return, with x and fvec available
!         for printing. If nprint is not positive, no special calls
!         of FCN with iflag = 0 Are made.
!
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of iflag. See description of FCN. Otherwise,
!         info is set as follows.
!
!         info = 0   Improper input parameters.
!
!         info = 1   Relative error between two consecutive iterates
!                    is at most xtol.
!
!         info = 2   Number of calls to FCN has reached or exceeded
!                    maxfev.
!
!         info = 3   xtol is too small. No further improvement in
!                    the approximate solution x is possible.
!
!         info = 4   Iteration is not making good progress, as
!                    measured by the improvement from the last
!                    five Jacobian evaluations.
!
!         info = 5   Iteration is not making good progress, as
!                    measured by the improvement from the last
!                    ten iterations.
!
!       nfev is an integer output variable SET to the number of
!         calls to FCN.
!
!       fjac is an output n by n array which contains the
!         orthogonal matrix Q produced by the QR factorization
!         of the final approximate Jacobian.
!
!       ldfjac is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array fjac.
!
!       R is an output array of length lr which contains the
!         upper triangular matrix produced by the QR factorization
!         of the final approximate Jacobian, stored rowwise.
!
!       lr is a positive integer input variable NOT less than
!         (n*(n+1))/2.
!
!       QTF is an output array of length n which contains
!         the vector (Q transpose)*fvec.
!
!       WA1, WA2, WA3, and wa4 are work arrays of length n.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... dogleg,spmpar,enorm,fdjac1,
!                            qform,qrfac,r1mpyq,r1updt
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,MIN0,mod
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
!
!     epsmch is the machine precision.
!
epsmch = spmpar(1)
!
info = 0
iflag = 0
nfev = 0
!
!     Check the input parameters for errors.
!
if (n <= 0 .or. xtol < zero .or. maxfev <= 0 &
   & .or. ml < 0 .or. mu < 0 .or. factor <= zero &
   & .or. ldfjac < n .or. lr < (n*(n + 1))/2) go to 300
if (mode /= 2) go to 20
do 10 j = 1, n
   if (diag(j) <= zero) go to 300
10 continue
20 continue
!
!     Evaluate the function at the starting point
!     and calculate its norm.
!
iflag = 1
call fcn(n,x,fvec,iflag)
nfev = 1
if (iflag < 0) go to 300
fnorm = enorm(n,fvec)
!
!     Determine the number of calls to FCN needed to compute
!     the Jacobian matrix.
!
msum = min(ml + mu + 1,n)
!
!     Initialize iteration counter and monitors.
!
iter = 1
ncsuc = 0
ncfail = 0
nslow1 = 0
nslow2 = 0
!
!     Beginning of the outer loop.
!
30 continue
jeval = .true.
!
!        Calculate the Jacobian matrix.
!
iflag = 2
call fdjac1(fcn,n,x,fvec,fjac,ldfjac,iflag,ml,mu,epsfcn,wa1, &
   & wa2)
nfev = nfev + msum
if (iflag < 0) go to 300
!
!        Compute the QR factorization of the Jacobian.
!
call qrfac(n,n,fjac,ldfjac,.false.,iwa,1,wa1,wa2,wa3)
!
!        On the first iteration and if mode is 1, scale according
!        to the norms of the columns of the initial Jacobian.
!
if (iter /= 1) go to 70
if (mode == 2) go to 50
do j = 1, n
   diag(j) = wa2(j)
   if (wa2(j) == zero) diag(j) = one
end do
50 continue
!
!        On the first iteration, calculate the norm of the scaled x
!        and initialize the step bound delta.
!
do j = 1, n
   wa3(j) = diag(j)*x(j)
end do
xnorm = enorm(n,wa3)
delta = factor*xnorm
if (delta == zero) delta = factor
70 continue
!
!        Form (Q transpose)*fvec and store in QTF.
!
do i = 1, n
   qtf(i) = fvec(i)
end do
do j = 1, n
   if (fjac(j,j) == zero) go to 110
   sum = zero
   do i = j, n
      sum = sum + fjac(i,j)*qtf(i)
   end do
   temp = -sum/fjac(j,j)
   do i = j, n
      qtf(i) = qtf(i) + fjac(i,j)*temp
   end do
110 continue
end do
!
!        Copy the triangular factor of the QR factorization into R.
!
sing = .false.
do j = 1, n
   l = j
   jm1 = j - 1
   if (jm1 < 1) go to 140
   do i = 1, jm1
      r(l) = fjac(i,j)
      l = l + n - i
   end do
140 continue
   r(l) = wa1(j)
   if (wa1(j) == zero) sing = .true.
end do
!
!        Accumulate the orthogonal factor in fjac.
!
call qform(n,n,fjac,ldfjac,wa1)
!
!        Rescale if necessary.
!
if (mode == 2) go to 170
do j = 1, n
   diag(j) = max(diag(j),wa2(j))
end do
170 continue
!
!        Beginning of the inner loop.
!
180 continue
!
!           If requested, call FCN to enable printing of iterates.
!
if (nprint <= 0) go to 190
iflag = 0
if (mod(iter - 1,nprint) == 0) call fcn(n,x,fvec,iflag)
if (iflag < 0) go to 300
190 continue
!
!           Determine the direction P.
!
call dogleg(n,r,lr,diag,qtf,delta,wa1,wa2,wa3)
!
!           Store the direction P and x + P. calculate the norm of P.
!
do j = 1, n
   wa1(j) = -wa1(j)
   wa2(j) = x(j) + wa1(j)
   wa3(j) = diag(j)*wa1(j)
end do
pnorm = enorm(n,wa3)
!
!           On the first iteration, adjust the initial step bound.
!
if (iter == 1) delta = min(delta,pnorm)
!
!           Evaluate the function at x + P and calculate its norm.
!
iflag = 1
call fcn(n,wa2,wa4,iflag)
nfev = nfev + 1
if (iflag < 0) go to 300
fnorm1 = enorm(n,wa4)
!
!           Compute the scaled actual reduction.
!
actred = -one
if (fnorm1 < fnorm) actred = one - (fnorm1/fnorm)**2
!
!           Compute the scaled predicted reduction.
!
l = 1
do i = 1, n
   sum = zero
   do j = i, n
      sum = sum + r(l)*wa1(j)
      l = l + 1
   end do
   wa3(i) = qtf(i) + sum
end do
temp = enorm(n,wa3)
prered = zero
if (temp < fnorm) prered = one - (temp/fnorm)**2
!
!           Compute the ratio of the actual to the predicted
!           reduction.
!
ratio = zero
if (prered > zero) ratio = actred/prered
!
!           Update the step bound.
!
if (ratio >= p1) go to 230
ncsuc = 0
ncfail = ncfail + 1
delta = p5*delta
go to 240
230 continue
ncfail = 0
ncsuc = ncsuc + 1
if (ratio >= p5 .or. ncsuc > 1) &
   & delta = max(delta,pnorm/p5)
if (abs(ratio - one) <= p1) delta = pnorm/p5
240 continue
!
!           Test for successful iteration.
!
if (ratio < p0001) go to 260
!
!           Successful iteration. Update x, fvec, and their norms.
!
do j = 1, n
   x(j) = wa2(j)
   wa2(j) = diag(j)*x(j)
   fvec(j) = wa4(j)
end do
xnorm = enorm(n,wa2)
fnorm = fnorm1
iter = iter + 1
260 continue
!
!           Determine the progress of the iteration.
!
nslow1 = nslow1 + 1
if (actred >= p001) nslow1 = 0
if (jeval) nslow2 = nslow2 + 1
if (actred >= p1) nslow2 = 0
!
!           Test for convergence.
!
if (delta <= xtol*xnorm .or. fnorm == zero) info = 1
if (info /= 0) go to 300
!
!           Tests for termination and stringent tolerances.
!
if (nfev >= maxfev) info = 2
if (p1*max(p1*delta,pnorm) <= epsmch*xnorm) info = 3
if (nslow2 == 5) info = 4
if (nslow1 == 10) info = 5
if (info /= 0) go to 300
!
!           Criterion for recalculating Jacobian approximation
!           by forward differences.
!
if (ncfail == 2) go to 290
!
!           Calculate the rank one modification to the Jacobian
!           and update QTF if necessary.
!
do j = 1, n
   sum = zero
   do i = 1, n
      sum = sum + fjac(i,j)*wa4(i)
   end do
   wa2(j) = (sum - wa3(j))/pnorm
   wa1(j) = diag(j)*((diag(j)*wa1(j))/pnorm)
   if (ratio >= p0001) qtf(j) = sum
end do
!
!           Compute the QR factorization of the updated Jacobian.
!
call r1updt(n,n,r,lr,wa1,wa2,wa3,sing)
call r1mpyq(n,n,fjac,ldfjac,wa2,wa3)
call r1mpyq(1,n,qtf,1,wa2,wa3)
!
!           END OF THE INNER LOOP.
!
jeval = .false.
go to 180
290 continue
!
!        END OF THE OUTER LOOP.
!
go to 30
300 continue
!
!     Termination, either normal or user imposed.
!
if (iflag < 0) info = iflag
iflag = 0
if (nprint > 0) call fcn(n,x,fvec,iflag)
return
!
!     Last card of subroutine hybrd.
!
end subroutine hybrd

pure subroutine qdcrt(a, z)
implicit none
real, intent(in) :: a(3)
complex, intent(inout) :: z(2)
real :: d, eps, r, w, x, y
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!        qdcrt computes the roots of the real polynomial
!              a(1) + a(2)*z + a(3)*z**2
!     and stores the results in z. it is assumed that a(3)
!     is nonzero.
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.0 + eps .GT. 1.0.
!
eps = spmpar(1)
!
!-------------------
if (a(1) == 0.0) go to 40
d = a(2)*a(2) - 4.0*a(1)*a(3)
if (abs(d) <= 2.0*eps*a(2)*a(2)) go to 20
r = sqrt(abs(d))
if (d < 0.0) go to 30
!
!                 Distinct real roots
!
if (a(2) /= 0.0) go to 10
x = abs(0.5*r/a(3))
z(1) = cmplx(x, 0.0)
z(2) = cmplx(-x, 0.0)
return
10 w = -(a(2) + sign(r,a(2)))
z(1) = cmplx(2.0*a(1)/w, 0.0)
z(2) = cmplx(0.5*w/a(3), 0.0)
return
!
!                  Equal real roots
!
20 z(1) = cmplx(-0.5*a(2)/a(3), 0.0)
z(2) = z(1)
return
!
!                   complex roots
!
30 x = -0.5*a(2)/a(3)
y = abs(0.5*r/a(3))
z(1) = cmplx(x, y)
z(2) = cmplx(x,-y)
return
!
!                 Case when a(1) = 0
!
40 z(1) = (0.0, 0.0)
z(2) = cmplx(-a(2)/a(3), 0.0)
return
end subroutine qdcrt

pure subroutine dqdcrt(a, zr, zi)
implicit none
!-----------------------------------------------------------------------
!
!        dqdcrt computes the roots of the real polynomial
!                a(1) + a(2)*Z + a(3)*Z**2
!     and stores the results in zr and zi. It is assumed that
!     a(3) is nonzero.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a(3)
double precision, intent(inout) :: zr(2), zi(2)
double precision :: d, eps, r, w
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.D0 + eps .GT. 1.D0.
!
eps = dpmpar(1)
!
!-------------------
if (a(1) == 0.d0) go to 40
d = a(2)*a(2) - 4.d0*a(1)*a(3)
if (abs(d) <= 2.d0*eps*a(2)*a(2)) go to 20
r = sqrt(abs(d))
if (d < 0.d0) go to 30
!
!                 Distinct real roots
!
zi(1) = 0.d0
zi(2) = 0.d0
if (a(2) /= 0.d0) go to 10
zr(1) = abs(0.5d0*r/a(3))
zr(2) = -zr(1)
return
10 w = -(a(2) + sign(r,a(2)))
zr(1) = 2.d0*a(1)/w
zr(2) = 0.5d0*w/a(3)
return
!
!                  Equal real roots
!
20 zr(1) = -0.5d0*a(2)/a(3)
zr(2) = zr(1)
zi(1) = 0.d0
zi(2) = 0.d0
return
!
!                   complex roots
!
30 zr(1) = -0.5d0*a(2)/a(3)
zr(2) = zr(1)
zi(1) = abs(0.5d0*r/a(3))
zi(2) = -zi(1)
return
!
!                 Case when a(1) = 0
!
40 zr(1) = 0.d0
zr(2) = -a(2)/a(3)
zi(1) = 0.d0
zi(2) = 0.d0
return
end subroutine dqdcrt

pure subroutine cbcrt(a, z)
implicit none
real, intent(in) :: a(4)
complex, intent(inout) :: z(3)
real :: arg, c, cf, d, eps, p, p1, q, q1, r, r1, ra, rb, rq, rt, s, sf, sq, sum, t, t1, tol, w, w1, w2, x, x1, x2, x3, y, y1, y2, &
   & y3, aq(3)
real, parameter :: rt3 = 1.7320508075689
interface
   pure elemental function cbrt(x)
      implicit none
      real, intent(in) :: x
      real :: cbrt
   end function cbrt
   pure subroutine qdcrt(a,z)
      implicit none
      real, intent(in) :: a(3)
      complex, intent(inout) :: z(2)
   end subroutine qdcrt
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!        cbcrt computes the roots of the real polynomial
!              a(1) + a(2)*z + a(3)*z**2 + a(4)*z**3
!     and stores the results in z. it is assumed that a(4)
!     is nonzero.
!
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!-------------------
!-----------------------------------------------------------------------
!
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.0 + eps .GT. 1.0.
!
eps = spmpar(1)
!
!-------------------
if (a(1) == 0.0) go to 100
p = a(3)/(3.0*a(4))
q = a(2)/a(4)
r = a(1)/a(4)
tol = 4.0*eps
!
c = 0.0
t = a(2) - p*a(3)
if (abs(t) > tol*abs(a(2))) c = t/a(4)
!
t = 2.0*p*p - q
if (abs(t) <= tol*abs(q)) t = 0.0
d = r + p*t
if (abs(d) <= tol*abs(r)) go to 110
!
!           SET  SQ = (a(4)/S)**2 * (c**3/27 + d**2/4)
!
s = max(abs(a(1)),abs(a(2)),abs(a(3)))
p1 = a(3)/(3.0*s)
q1 = a(2)/s
r1 = a(1)/s
!
t1 = q - 2.25*p*p
if (abs(t1) <= tol*abs(q)) t1 = 0.0
w = 0.25*r1*r1
w1 = 0.5*p1*r1*t
w2 = q1*q1*t1/27.0
if (w1 < 0.0) go to 10
w = w + w1
sq = w + w2
go to 12
10 if (w2 < 0.0) go to 11
w = w + w2
sq = w + w1
go to 12
11 sq = w + (w1 + w2)
12 if (abs(sq) <= tol*w) sq = 0.0
rq = abs(s/a(4))*sqrt(abs(sq))
if (sq >= 0.0) go to 40
!
!                   All roots are real
!
arg = atan2(rq, -0.5*d)
cf = cos(arg/3.0)
sf = sin(arg/3.0)
rt = sqrt(-c/3.0)
y1 = 2.0*rt*cf
y2 = -rt*(cf + rt3*sf)
y3 = -(d/y1)/y2
!
x1 = y1 - p
x2 = y2 - p
x3 = y3 - p
if (abs(x1) <= abs(x2)) go to 20
t = x1
x1 = x2
x2 = t
20 if (abs(x2) <= abs(x3)) go to 30
t = x2
x2 = x3
x3 = t
if (abs(x1) <= abs(x2)) go to 30
t = x1
x1 = x2
x2 = t
!
30 w = x3
if (abs(x2) < 0.1*abs(x3)) go to 70
if (abs(x1) < 0.1*abs(x2)) x1 = - (r/x3)/x2
z(1) = cmplx(x1, 0.0)
z(2) = cmplx(x2, 0.0)
z(3) = cmplx(x3, 0.0)
return
!
!                  Real and complex roots
!
40 ra = cbrt(-0.5*d - sign(rq,d))
rb = -c/(3.0*ra)
t = ra + rb
w = -p
x = -p
if (abs(t) <= tol*abs(ra)) go to 41
w = t - p
x = -0.5*t - p
if (abs(x) <= tol*abs(p)) x = 0.0
41 t = abs(ra - rb)
y = 0.5*rt3*t
!
if (t <= tol*abs(ra)) go to 60
if (abs(x) < abs(y)) go to 50
s = abs(x)
t = y/x
go to 51
50 s = abs(y)
t = x/y
51 if (s < 0.1*abs(w)) go to 70
w1 = w/s
sum = 1.0 + t*t
if (w1*w1 < 0.01*sum) w = - ((r/sum)/s)/s
z(1) = cmplx(w,0.0)
z(2) = cmplx(x, y)
z(3) = cmplx(x,-y)
return
!
!               At least two roots are equal
!
60 if (abs(x) < abs(w)) go to 61
if (abs(w) < 0.1*abs(x)) w = - (r/x)/x
z(1) = cmplx(w, 0.0)
z(2) = cmplx(x, 0.0)
z(3) = z(2)
return
61 if (abs(x) < 0.1*abs(w)) go to 70
z(1) = cmplx(x, 0.0)
z(2) = z(1)
z(3) = cmplx(w, 0.0)
return
!
!     Here W is much larger in magnitude than the other roots.
!     As a result, the other roots may be exceedingly inaccurate
!     because of roundoff error. To deal with this, a quadratic
!     is formed whose roots are the same as the smaller roots of
!     the cubic. This quadratic is then solved.
!
!     This code was written by william L. Davis (NSWC).
!
70 aq(1) = a(1)
aq(2) = a(2) + a(1)/w
aq(3) = -a(4)*w
call qdcrt(aq, z)
z(3) = cmplx(w, 0.0)
!
if (aimag(z(1)) == 0.0) return
z(3) = z(2)
z(2) = z(1)
z(1) = cmplx(w, 0.0)
return
!-----------------------------------------------------------------------
!
!                  Case when a(1) = 0
!
100 z(1) = (0.0, 0.0)
call qdcrt(a(2), z(2))
return
!
!                   Case when d = 0
!
110 z(1) = cmplx(-p, 0.0)
w = sqrt(abs(c))
if (c < 0.0) go to 120
z(2) = cmplx(-p, w)
z(3) = cmplx(-p,-w)
return
!
120 if (p /= 0.0) go to 130
z(2) = cmplx(w, 0.0)
z(3) = cmplx(-w, 0.0)
return
!
130 x = -(p + sign(w,p))
z(3) = cmplx(x, 0.0)
t = 3.0*a(1)/(a(3)*x)
if (abs(p) > abs(t)) go to 131
z(2) = cmplx(t, 0.0)
return
131 z(2) = z(1)
z(1) = cmplx(t, 0.0)
return
end subroutine cbcrt

pure subroutine dcbcrt(a, zr, zi)
implicit none
!-----------------------------------------------------------------------
!
!        dcbcrt computes the roots of the real polynomial
!              a(1) + a(2)*Z + a(3)*Z**2 + a(4)*Z**3
!     and stores the results in zr and zi. It is assumed that
!     a(4) is nonzero.
!
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
double precision, intent(in) :: a(4)
double precision, intent(inout) :: zr(3), zi(3)
double precision :: aq(3), arg, c, cf, d, eps, p, p1, q, q1, r, ra, rb, rq, rt, r1, s, sf, sq, sum, t, tol, t1, w, w1, w2, x, x1, &
   & x2, x3, y, y1, y2, y3
double precision, parameter :: rt3 = 1.732050807568877293527446341505872366943d0
interface
   pure elemental function dcbrt(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dcbrt
   end function dcbrt
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure subroutine dqdcrt(a,zr,zi)
      implicit none
      double precision, intent(in) :: a(3)
      double precision, intent(inout) :: zr(2)
      double precision, intent(inout) :: zi(2)
   end subroutine dqdcrt
end interface
!-------------------
!-----------------------------------------------------------------------
!
!     ***** eps is a machine dependent constant. Eps is the
!           smallest number such that 1.D0 + eps .GT. 1.D0.
!
eps = dpmpar(1)
!
!-------------------
if (a(1) == 0.d0) go to 100
p = a(3)/(3.d0*a(4))
q = a(2)/a(4)
r = a(1)/a(4)
tol = 4.d0*eps
!
c = 0.d0
t = a(2) - p*a(3)
if (abs(t) > tol*abs(a(2))) c = t/a(4)
!
t = 2.d0*p*p - q
if (abs(t) <= tol*abs(q)) t = 0.d0
d = r + p*t
if (abs(d) <= tol*abs(r)) go to 110
!
!           SET  SQ = (a(4)/S)**2 * (c**3/27 + d**2/4)
!
s = max(abs(a(1)),abs(a(2)),abs(a(3)))
p1 = a(3)/(3.d0*s)
q1 = a(2)/s
r1 = a(1)/s
!
t1 = q - 2.25d0*p*p
if (abs(t1) <= tol*abs(q)) t1 = 0.d0
w = 0.25d0*r1*r1
w1 = 0.5d0*p1*r1*t
w2 = q1*q1*t1/27.d0
if (w1 < 0.d0) go to 10
w = w + w1
sq = w + w2
go to 12
10 if (w2 < 0.d0) go to 11
w = w + w2
sq = w + w1
go to 12
11 sq = w + (w1 + w2)
12 if (abs(sq) <= tol*w) sq = 0.d0
rq = abs(s/a(4))*sqrt(abs(sq))
if (sq >= 0.d0) go to 40
!
!                   All roots are real
!
arg = atan2(rq, -0.5d0*d)
cf = cos(arg/3.d0)
sf = sin(arg/3.d0)
rt = sqrt(-c/3.d0)
y1 = 2.d0*rt*cf
y2 = -rt*(cf + rt3*sf)
y3 = -(d/y1)/y2
!
x1 = y1 - p
x2 = y2 - p
x3 = y3 - p
if (abs(x1) <= abs(x2)) go to 20
t = x1
x1 = x2
x2 = t
20 if (abs(x2) <= abs(x3)) go to 30
t = x2
x2 = x3
x3 = t
if (abs(x1) <= abs(x2)) go to 30
t = x1
x1 = x2
x2 = t
!
30 w = x3
if (abs(x2) < 0.1d0*abs(x3)) go to 70
if (abs(x1) < 0.1d0*abs(x2)) x1 = - (r/x3)/x2
zr(1) = x1
zr(2) = x2
zr(3) = x3
zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
return
!
!                  Real and complex roots
!
40 ra = dcbrt(-0.5d0*d - sign(rq,d))
rb = -c/(3.d0*ra)
t = ra + rb
w = -p
x = -p
if (abs(t) <= tol*abs(ra)) go to 41
w = t - p
x = -0.5d0*t - p
if (abs(x) <= tol*abs(p)) x = 0.d0
41 t = abs(ra - rb)
y = 0.5d0*rt3*t
!
if (t <= tol*abs(ra)) go to 60
if (abs(x) < abs(y)) go to 50
s = abs(x)
t = y/x
go to 51
50 s = abs(y)
t = x/y
51 if (s < 0.1d0*abs(w)) go to 70
w1 = w/s
sum = 1.d0 + t*t
if (w1*w1 < 1.d-2*sum) w = - ((r/sum)/s)/s
zr(1) = w
zr(2) = x
zr(3) = x
zi(1) = 0.d0
zi(2) = y
zi(3) = -y
return
!
!               At least two roots are equal
!
60 zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
if (abs(x) < abs(w)) go to 61
if (abs(w) < 0.1d0*abs(x)) w = - (r/x)/x
zr(1) = w
zr(2) = x
zr(3) = x
return
61 if (abs(x) < 0.1d0*abs(w)) go to 70
zr(1) = x
zr(2) = x
zr(3) = w
return
!
!     Here W is much larger in magnitude than the other roots.
!     As a result, the other roots may be exceedingly inaccurate
!     because of roundoff error. To deal with this, a quadratic
!     is formed whose roots are the same as the smaller roots of
!     the cubic. This quadratic is then solved.
!
!     This code was written by william L. Davis (NSWC).
!
70 aq(1) = a(1)
aq(2) = a(2) + a(1)/w
aq(3) = -a(4)*w
call dqdcrt(aq, zr, zi)
zr(3) = w
zi(3) = 0.d0
!
if (zi(1) == 0.d0) return
zr(3) = zr(2)
zi(3) = zi(2)
zr(2) = zr(1)
zi(2) = zi(1)
zr(1) = w
zi(1) = 0.d0
return
!-----------------------------------------------------------------------
!
!                  Case when a(1) = 0
!
100 zr(1) = 0.d0
zi(1) = 0.d0
call dqdcrt(a(2), zr(2), zi(2))
return
!
!                   Case when d = 0
!
110 zr(1) = -p
zi(1) = 0.d0
w = sqrt(abs(c))
if (c < 0.d0) go to 120
zr(2) = -p
zr(3) = zr(2)
zi(2) = w
zi(3) = -w
return
!
120 if (p /= 0.d0) go to 130
zr(2) = w
zr(3) = -w
zi(2) = 0.d0
zi(3) = 0.d0
return
!
130 x = -(p + sign(w,p))
zr(3) = x
zi(2) = 0.d0
zi(3) = 0.d0
t = 3.d0*a(1)/(a(3)*x)
if (abs(p) > abs(t)) go to 131
zr(2) = t
return
131 zr(2) = zr(1)
zr(1) = t
return
end subroutine dcbcrt

pure subroutine qtcrt(a, z)
implicit none
real, intent(in) :: a(5)
complex, intent(inout) :: z(4)
real :: b, b2, c, d, e, h, p, q, r, t, u, v, v1, v2, x, x1, x2, x3, y, temp(4)
complex :: w
interface
   pure subroutine aord(a,n)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: a(n)
   end subroutine aord
   pure subroutine cbcrt(a,z)
      implicit none
      real, intent(in) :: a(4)
      complex, intent(inout) :: z(3)
   end subroutine cbcrt
end interface
!-----------------------------------------------------------------------
!
!         qtcrt computes the roots of the real polynomial
!               a(1) + a(2)*z + ... + a(5)*z**4
!         and stores the results in z. it is assumed that a(5)
!         is nonzero.
!
!-----------------------------------------------------------------------
!     Written by Alfred h. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!
if (a(1) == 0.0) go to 100
b = a(4)/(4.0*a(5))
c = a(3)/a(5)
d = a(2)/a(5)
e = a(1)/a(5)
b2 = b*b
!
p = 0.5*(c - 6.0*b2)
q = d - 2.0*b*(c - 4.0*b2)
r = b2*(c - 3.0*b2) - b*d + e
!
!          Solve the resolvent cubic equation. The cubic has
!          at least one nonnegative real root. If W1, W2, W3
!          are the roots of the cubic then the roots of the
!          originial equation are
!
!             z = -b + csqrt(w1) + csqrt(w2) + csqrt(w3)
!
!          Where the signs of the square roots are chosen so
!          THAT CSQRT(W1) * CSQRT(W2) * CSQRT(W3) = -q/8.
!
temp(1) = -q*q/64.0
temp(2) = 0.25*(p*p - r)
temp(3) = p
temp(4) = 1.0
call cbcrt(temp,z)
if (aimag(z(2)) /= 0.0) go to 60
!
!               The resolvent cubic has only real roots
!                reorder the roots in increasing order
!
x1 = real(z(1))
x2 = real(z(2))
x3 = real(z(3))
if (x1 <= x2) go to 10
t = x1
x1 = x2
x2 = t
10 if (x2 <= x3) go to 20
t = x2
x2 = x3
x3 = t
if (x1 <= x2) go to 20
t = x1
x1 = x2
x2 = t
!
20 u = 0.0
if (x3 > 0.0) u = sqrt(x3)
if (x2 <= 0.0) go to 41
if (x1 >= 0.0) go to 30
if (abs(x1) > x2) go to 40
x1 = 0.0
!
30 x1 = sqrt(x1)
x2 = sqrt(x2)
if (q > 0.0) x1 = -x1
temp(1) = (( x1 + x2) + u) - b
temp(2) = ((-x1 - x2) + u) - b
temp(3) = (( x1 - x2) - u) - b
temp(4) = ((-x1 + x2) - u) - b
call aord(temp,4)
if (abs(temp(1)) >= 0.1*abs(temp(4))) go to 31
t = temp(2)*temp(3)*temp(4)
if (t /= 0.0) temp(1) = e/t
31 z(1) = cmplx(temp(1), 0.0)
z(2) = cmplx(temp(2), 0.0)
z(3) = cmplx(temp(3), 0.0)
z(4) = cmplx(temp(4), 0.0)
return
!
40 v1 = sqrt(abs(x1))
v2 = 0.0
go to 50
41 v1 = sqrt(abs(x1))
v2 = sqrt(abs(x2))
if (q < 0.0) u = -u
!
50 x = -u - b
y = v1 - v2
z(1) = cmplx(x, y)
z(2) = cmplx(x,-y)
x = u - b
y = v1 + v2
z(3) = cmplx(x, y)
z(4) = cmplx(x,-y)
return
!
!                The resolvent cubic has complex roots
!
60 t = real(z(1))
x = 0.0
if (t) 61,70,62
61 h = abs(real(z(2))) + abs(aimag(z(2)))
if (abs(t) <= h) go to 70
go to 80
62 x = sqrt(t)
if (q > 0.0) x = -x
!
70 w = sqrt(z(2))
u = 2.0*real(w)
v = 2.0*abs(aimag(w))
t = x - b
x1 = t + u
x2 = t - u
if (abs(x1) <= abs(x2)) go to 71
t = x1
x1 = x2
x2 = t
71 u = -x - b
h = u*u + v*v
if (x1*x1 < 0.01*min(x2*x2,h)) x1 = e/(x2*h)
z(1) = cmplx(x1, 0.0)
z(2) = cmplx(x2, 0.0)
z(3) = cmplx(u, v)
z(4) = cmplx(u,-v)
return
!
80 v = sqrt(abs(t))
z(1) = cmplx(-b, v)
z(2) = cmplx(-b,-v)
z(3) = z(1)
z(4) = z(2)
return
!
!                         Case when a(1) = 0
!
100 z(1) = (0.0, 0.0)
call cbcrt(a(2), z(2))
return
end subroutine qtcrt

pure subroutine dqtcrt(a, zr, zi)
implicit none
!-----------------------------------------------------------------------
!
!         dqtcrt computes the roots of the real polynomial
!               a(1) + a(2)*Z + ... + a(5)*Z**4
!         and stores the results in zr and zi. It is assumed
!         that a(5) is nonzero.
!
!-----------------------------------------------------------------------
!     Written by Alfred h. Morris
!        naval surface weapons center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
double precision, intent(in) :: a(5)
double precision, intent(inout) :: zr(4), zi(4)
double precision :: b, b2, c, d, e, h, p, q, r, t, temp(4), u, v, &
   & v1, v2, w(2), x, x1, x2, x3
interface
   pure subroutine daord(a,n)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: a(n)
   end subroutine daord
   pure subroutine dcbcrt(a,zr,zi)
      implicit none
      double precision, intent(in) :: a(4)
      double precision, intent(inout) :: zr(3)
      double precision, intent(inout) :: zi(3)
   end subroutine dcbcrt
   pure subroutine dcsqrt(z,w)
      implicit none
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine dcsqrt
end interface
!
if (a(1) == 0.d0) go to 100
b = a(4)/(4.d0*a(5))
c = a(3)/a(5)
d = a(2)/a(5)
e = a(1)/a(5)
b2 = b*b
!
p = 0.5d0*(c - 6.d0*b2)
q = d - 2.d0*b*(c - 4.d0*b2)
r = b2*(c - 3.d0*b2) - b*d + e
!
!          Solve the resolvent cubic equation. The cubic has
!          at least one nonnegative real root. If W1, W2, W3
!          are the roots of the cubic then the roots of the
!          originial equation are
!
!             z = -b + csqrt(w1) + csqrt(w2) + csqrt(w3)
!
!          Where the signs of the square roots are chosen so
!          THAT CSQRT(W1) * CSQRT(W2) * CSQRT(W3) = -q/8.
!
temp(1) = -q*q/64.d0
temp(2) = 0.25d0*(p*p - r)
temp(3) = p
temp(4) = 1.d0
call dcbcrt(temp, zr, zi)
if (zi(2) /= 0.d0) go to 60
!
!               The resolvent cubic has only real roots
!                reorder the roots in increasing order
!
x1 = zr(1)
x2 = zr(2)
x3 = zr(3)
if (x1 <= x2) go to 10
t = x1
x1 = x2
x2 = t
10 if (x2 <= x3) go to 20
t = x2
x2 = x3
x3 = t
if (x1 <= x2) go to 20
t = x1
x1 = x2
x2 = t
!
20 u = 0.d0
if (x3 > 0.d0) u = sqrt(x3)
if (x2 <= 0.d0) go to 41
if (x1 >= 0.d0) go to 30
if (abs(x1) > x2) go to 40
x1 = 0.d0
!
30 x1 = sqrt(x1)
x2 = sqrt(x2)
if (q > 0.d0) x1 = -x1
zr(1) = (( x1 + x2) + u) - b
zr(2) = ((-x1 - x2) + u) - b
zr(3) = (( x1 - x2) - u) - b
zr(4) = ((-x1 + x2) - u) - b
call daord(zr, 4)
if (abs(zr(1)) >= 0.1d0*abs(zr(4))) go to 31
t = zr(2)*zr(3)*zr(4)
if (t /= 0.d0) zr(1) = e/t
31 zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
zi(4) = 0.d0
return
!
40 v1 = sqrt(abs(x1))
v2 = 0.d0
go to 50
41 v1 = sqrt(abs(x1))
v2 = sqrt(abs(x2))
if (q < 0.d0) u = -u
!
50 zr(1) = -u - b
zi(1) = v1 - v2
zr(2) = zr(1)
zi(2) = -zi(1)
zr(3) = u - b
zi(3) = v1 + v2
zr(4) = zr(3)
zi(4) = -zi(3)
return
!
!                The resolvent cubic has complex roots
!
60 t = zr(1)
x = 0.d0
if (t) 61,70,62
61 h = abs(zr(2)) + abs(zi(2))
if (abs(t) <= h) go to 70
go to 80
62 x = sqrt(t)
if (q > 0.d0) x = -x
!
70 w(1) = zr(2)
w(2) = zi(2)
call dcsqrt(w, w)
u = 2.d0*w(1)
v = 2.d0*abs(w(2))
t = x - b
x1 = t + u
x2 = t - u
if (abs(x1) <= abs(x2)) go to 71
t = x1
x1 = x2
x2 = t
71 u = -x - b
h = u*u + v*v
if (x1*x1 < 1.d-2*min(x2*x2,h)) x1 = e/(x2*h)
zr(1) = x1
zr(2) = x2
zi(1) = 0.d0
zi(2) = 0.d0
zr(3) = u
zr(4) = u
zi(3) = v
zi(4) = -v
return
!
80 v = sqrt(abs(t))
zr(1) = -b
zr(2) = -b
zr(3) = -b
zr(4) = -b
zi(1) = v
zi(2) = -v
zi(3) = v
zi(4) = -v
return
!
!                         Case when a(1) = 0
!
100 zr(1) = 0.d0
zi(1) = 0.d0
call dcbcrt(a(2), zr(2), zi(2))
return
end subroutine dqtcrt

subroutine drpoly(op, ideg, zeror, zeroi, num, wk, dwk)
implicit none
integer :: ideg
integer, intent(inout) :: num
double precision :: op(*)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), &
   & dwk(*)
real, intent(inout) :: wk(*)
integer :: idp1, p, qp, k, qk, svk, tmp
!
!     This subroutine finds the zeros of a real polynomial.
!
!     op          - Double precision array of length ideg + 1.
!                   On input this array contains the coefficients
!                   in order of decreasing powers.
!
!     ideg        - Integer degree of the polynomial.
!
!     zeror,zeroi - Double precision arrays if length ideg.
!                   On output these arrays contain the real and
!                   imaginary parts of the zeros.
!
!     num         - Variable that reports the status of the results.
!                   If num = -1 Then the leading coefficient of the
!                   polynomial is 0 or ideg .LT. 1. Otherwise, num
!                   is the number of zeros that were obtained. If
!                   num .GE. 1 then the real and imaginary parts of
!                   the zeros are stored in zeror(J) and zeroi(J)
!                   FOR J = 1,...,num.
!
!     wk          - Real array of length ideg + 1. The array is
!                   a work space for the routine.
!
!     DWK         - Double precision array of length 6*(ideg + 1).
!                   The array is a work space for the routine.
!
!     The subroutine uses single precision calculations for scaling,
!     bounds, and error calculations. All other calculations are done
!     in double precision.
!
!
!
if (ideg < 1) go to 10
!
!     Partition the workspace DWK and obtain the zeros
!
idp1 = ideg + 1
!
p = 1
qp = p + idp1
k = qp + idp1
qk = k + idp1
svk = qk + idp1
tmp = svk + idp1
!
call drply1(op,ideg,idp1,zeror,zeroi,dwk(p),dwk(qp),dwk(k), &
   & dwk(qk),dwk(svk),dwk(tmp),wk,num)
return
!
!     Error return
!
10 num = -1
return
end subroutine drpoly

subroutine drply1(op,ideg,idp1,zeror,zeroi,p,qp,k,qk,svk, &
   & temp,pt,num)
implicit none
integer :: ideg, idp1, num
double precision :: op(idp1), zeror(ideg), zeroi(ideg), p(idp1), &
   & qp(idp1), k(idp1), qk(idp1), svk(idp1), temp(idp1)
real :: pt(idp1)
integer :: i, j, jj, l, n, nm1, nn, nz, cnt
double precision :: aa, bb, cc, factor, t
real :: lo, max, min, xx, yy, cosr, sinr, x, xxx, sc, bnd, xm, ff, &
   & df, dx, base, smalno, infin
logical :: zerok
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental subroutine quadpl(a,b1,c,sr,si,lr,li)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: b1
      double precision, intent(in) :: c
      double precision, intent(inout) :: sr
      double precision, intent(inout) :: si
      double precision, intent(inout) :: lr
      double precision, intent(inout) :: li
   end subroutine quadpl
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-------------------------
!
!
!-------------------------
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!-------------------------
!     The following statements set the machine constants used
!     in the code. The meaning of the constants are ...
!
!     eta     THE SMALLEST POSITIVE NUMBER SUCH THAT
!             1.D0 + eta is greater than 1.D0
!     SMALNO  the smallest positive floating point number.
!             If the exponent range differs in single and
!             double precision then SMALNO and infin
!             should indicate the smaller range.
!     INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
!     BASE    THE BASE OF THE FLOATING POINT ARITHMETICS
!             being used.
!
eta = dpmpar(1)
smalno = spmpar(2)
infin = spmpar(3)
base = ipmpar(4)
!-------------------------
!
!     Are and mre refer to the unit error in + and *
!     respectively. They are assumed to be the same as eta.
!
are = eta
mre = eta
lo = smalno/eta
!
!     Initialization of constants for shift rotation
!
xx = .70710678
yy = -xx
cosr = -.069756474
sinr = .99756405
n = ideg
nn = idp1
num = 0
!
!     Algorithm fails if the leading coefficient is zero.
!
if (op(1) /= 0.d0) go to 10
num = -1
return
!
!     Remove the zeros at the origin if any
!
10 if (op(nn) /= 0.0d0) go to 20
num = num + 1
zeror(num) = 0.d0
zeroi(num) = 0.d0
nn = nn - 1
n = n - 1
go to 10
!
!     Make a copy of the coefficients
!
20 do i = 1,nn
   p(i) = op(i)
end do
!
!     Start the algorithm for obtaining a zero
!
40 if (n > 2) go to 60
if (n < 1) return
!
!     Calculate the final zero or pair of zeros
!
num = ideg
if (n == 2) go to 50
zeror(ideg) = -p(2)/p(1)
zeroi(ideg) = 0.0d0
return
50 call quadpl(p(1), p(2), p(3), zeror(ideg - 1), zeroi(ideg - 1), &
   & zeror(ideg), zeroi(ideg))
return
!
!     Find largest and smallest moduli of coefficients.
!
60 max = 0.0
min = infin
do i = 1,nn
   x = abs(sngl(p(i)))
   if (x > max) max = x
   if (x /= 0.0 .and. x < min) min = x
end do
!
!     Scale if there are large or very small coefficients.
!     Computes a scale factor to multiply the
!     coefficients of the polynomial. The scaling is done
!     to avoid overflow and to avoid undetected underflow
!     interfering with the convergence criterion.
!     The factor is a power of the base.
!
sc = lo/min
if (sc > 1.0) go to 80
if (max < 10.0) go to 110
if (sc == 0.0) sc = smalno
go to 90
80 if (infin/sc < max) go to 110
90 l = log(sc)/log(base) + 0.5
factor = dble(base)**l
if (factor == 1.d0) go to 110
do i = 1,nn
   p(i) = factor*p(i)
end do
!
!     Compute lower bound on moduli of zeros.
!
110 do i = 1,nn
   pt(i) = abs(sngl(p(i)))
end do
pt(nn) = -pt(nn)
!
!     Compute upper estimate of bound
!
x = exp((log(-pt(nn)) - log(pt(1)))/float(n))
if (pt(n) == 0.0) go to 130
!
!     If the Newton step at the origin is better then use it.
!
xm = -pt(nn)/pt(n)
if (xm < x) x = xm
!
!     Chop the interval (0,x) until ff .LE. 0.
!
130 xm = x*.1
ff = pt(1)
do i = 2,nn
   ff = ff*xm + pt(i)
end do
if (ff <= 0.0) go to 150
x = xm
go to 130
150 dx = x
!
!     Do Newton iteration until x converges to two decimal places.
!
160 if (abs(dx/x) <= 0.005) go to 180
ff = pt(1)
df = ff
do i = 2,n
   ff = ff*x + pt(i)
   df = df*x + ff
end do
ff = ff*x + pt(nn)
dx = ff/df
x = x - dx
go to 160
180 bnd = x
!
!     Compute the derivative as the intial K polynomial
!     and do 5 steps with no shift.
!
nm1 = n - 1
do i = 2,n
   k(i) = float(nn - i)*p(i)/float(n)
end do
k(1) = p(1)
aa = p(nn)
bb = p(n)
zerok = k(n) == 0.d0
do 230 jj = 1,5
   cc = k(n)
   if (zerok) go to 210
!
!     Use scaled form of recurrence if value of K at 0 is nonzero.
!
   t = -aa/cc
   do i = 1,nm1
      j = nn - i
      k(j) = t*k(j - 1) + p(j)
   end do
   k(1) = p(1)
   zerok = abs(k(n)) <= abs(bb)*eta*10.
   go to 230
!
!     Use unscaled form of recurrence
!
210 do i = 1,nm1
      j = nn - i
      k(j) = k(j - 1)
   end do
   k(1) = 0.d0
   zerok = k(n) == 0.d0
230 continue
!
!     Save K for restarts with new shifts
!
do i = 1,n
   temp(i) = k(i)
end do
!
!     Loop to select the quadratic  corresponding to each
!     new shift
!
do cnt = 1,20
!
!     Quadratic corresponds to a double shift to A
!     non-real point and its complex conjugate. The point
!     has modulus bnd and amplitude rotated by 94 degrees
!     from the previous shift.
!
   xxx = cosr*xx - sinr*yy
   yy = sinr*xx + cosr*yy
   xx = xxx
   sr = bnd*xx
   si = bnd*yy
   u = -2.0d0*sr
   v = bnd
!
!     Second stage calculation, fixed quadratic. The second stage
!     jumps directly to one of the third stage iterations.
!
   call fxshfr(20*cnt, nz, nn, p, qp, k, qk, svk)
   if (nz /= 0) go to 300
!
!     If the iteration is unsuccessful another quadratic
!     is chosen after restoring K.
!
   do i = 1,n
      k(i) = temp(i)
   end do
end do
!
!     Convergence was not achieved after 20 shifts.
!
return
!
!     Store the zeros obtained and deflate the polynomial.
!
300 num = num + 1
zeror(num) = szr
zeroi(num) = szi
nn = nn - nz
n = nn - 1
do i = 1,nn
   p(i) = qp(i)
end do
if (nz == 1) go to 40
num = num + 1
zeror(num) = lzr
zeroi(num) = lzi
go to 40
end subroutine drply1

subroutine fxshfr(l2, nz, nn, p, qp, k, qk, svk)
implicit none
integer :: nn
double precision :: p(nn), qp(nn), k(nn), qk(nn), svk(nn)
integer :: l2, nz
integer :: n, type, i, j, iflag
double precision :: svu, svv, ui, vi, s
real :: betas, betav, oss, ovv, ss, vv, ts, tv, ots, otv, tvv, tss
logical :: vpass, spass, vtry, stry
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!
!     Computes up to  l2  fixed shift k-polynomials,
!     testing for convergence in the linear or quadratic
!     case. Initiates one of the variable SHIFT
!     iterations and returns with the number of zeros
!     found.
!
!     l2 - Limit of fixed shift steps
!     nz - Number of zeros found
!
!
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
n = nn - 1
nz = 0
betav = .25
betas = .25
oss = sr
ovv = v
!
!     Evaluate polynomial by synthetic division
!
call quadsd(nn, u, v, p, qp, a, b)
call calcsc(type, n, k, qk)
do j = 1,l2
!
!     Calculate next k polynomial and estimate v
!
   call nextk(type, n, qp, k, qk)
   call calcsc(type, n, k, qk)
   call newest(type, ui, vi, nn, p, k)
   vv = vi
!
!     Estimate s
!
   ss = 0.0
   if (k(n) /= 0.d0) ss = -p(nn)/k(n)
   tv = 1.0
   ts = 1.0
   if (j == 1 .or. type == 3) go to 70
!
!     Compute relative measures of convergence of s and v
!     sequences
!
   if (vv /= 0.0) tv = abs((vv - ovv)/vv)
   if (ss /= 0.0) ts = abs((ss - oss)/ss)
!
!     If decreasing, multiply two most recent
!     convergence measures
!
   tvv = 1.0
   if (tv < otv) tvv = tv*otv
   tss = 1.0
   if (ts < ots) tss = ts*ots
!
!     Compare with convergence criteria
!
   vpass = tvv < betav
   spass = tss < betas
   if (.not.(spass .or. vpass)) go to 70
!
!     At least one sequence has passed the convergence
!     test. Store variables before iterating
!
   svu = u
   svv = v
   do i = 1,n
      svk(i) = k(i)
   end do
   s = ss
!
!     Choose iteration according to the fastest
!     converging sequence
!
   vtry = .false.
   stry = .false.
   if (spass .and. ((.not.vpass) .or. &
      & tss < tvv)) go to 40
20 call quadit(ui, vi, nz, nn, p, qp, k, qk)
   if (nz > 0) return
!
!     Quadratic iteration has failed. Flag that it has
!     been tried and decrease the convergence criterion.
!
   vtry = .true.
   betav = betav*0.25
!
!     Try linear iteration if it has not been tried and
!     the s sequence is converging
!
   if (stry .or. (.not.spass)) go to 50
   do i = 1,n
      k(i) = svk(i)
   end do
40 call realit(s, nz, iflag, nn, p, qp, k, qk)
   if (nz > 0) return
!
!     Linear iteration has failed. Flag that it has been
!     tried and decrease the convergence criterion
!
   stry = .true.
   betas = betas*0.25
   if (iflag == 0) go to 50
!
!     If linear iteration signals an almost double real
!     zero attempt quadratic interation
!
   ui = -(s + s)
   vi = s*s
   go to 20
!
!     Restore variables
!
50 u = svu
   v = svv
   do i = 1,n
      k(i) = svk(i)
   end do
!
!     Try quadratic iteration if it has not been tried
!     and the v sequence is converging
!
   if (vpass .and. (.not.vtry)) go to 20
!
!     Recompute qp and scalar values to continue the
!     second stage
!
   call quadsd(nn, u, v, p, qp, a, b)
   call calcsc(type, n, k, qk)
70 ovv = vv
   oss = ss
   otv = tv
   ots = ts
end do
return
end subroutine fxshfr

