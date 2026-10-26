pure elemental double precision function dgmln1(x)
implicit none
!-----------------------------------------------------------------------
!     Evaluation of LN(gamma(1 + x)) for -0.5 .LE. x .LE. 1.5
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: w
interface
   pure elemental function dgam1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgam1
   end function dgam1
   pure elemental function dlnrel(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dlnrel
   end function dlnrel
end interface
!-----------------------
w = dgam1(x)
dgmln1 = - dlnrel(w)
end function dgmln1

pure elemental subroutine cpsi(z, w)
implicit none
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: j, k, l, m, max
real :: a, a1, a2, c1, c2, cn, eps, et, h1, h2, s, s1, s2, sn, t, u, w1, w2, x, y, y2
complex :: eta, eta2, sum
double precision :: ds1, ds2
real, parameter :: pi = 3.14159265358979324
real, parameter :: pi2 = 6.28318530717958648
real, parameter :: c0(12) = [.833333333333333e-01, -.833333333333333e-02, .396825396825397e-02, -.416666666666667e-02, &
   & .757575757575758e-02, -.210927960927961e-01, .833333333333333e-01, -.443259803921569e+00, .305395433027012e+01, - &
   & .264562121212121e+02, .281460144927536e+03, -.360751054639805e+04]
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
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
!           Evaluation of the complex digamma function
!-----------------------------------------------------------------------
!----------------------------
!     pi2 = 2*pi
!----------------------------
!----------------------------
!----------------------------
!     ****** max and eps are machine dependent constants.
!            Max is the largest positive integer that may
!            be used, and eps is the smallest real number
!            such that 1.0 + eps .GT. 1.0.
max = ipmpar(3)
eps = spmpar(1)
!----------------------------
x = real(z)
y = aimag(z)
if (x >= 0.0) go to 40
!-----------------------------------------------------------------------
!            Case when the real part of z is negative
!-----------------------------------------------------------------------
y = abs(y)
t = -pi2*y
et = exp(t)
!     SET  a1 = (1 + et)/2  AND  a2 = (1 - et)/2
a1 = 0.5*(1.0 + et)
if (t < -0.15) go to 10
a2 = -0.5*rexp(t)
go to 20
10 a2 = 0.5*(0.5 + (0.5 - et))
!     Compute sin(pi*X) and cos(pi*X), or -sin(pi*X) and -cos(pi*X)
20 if (abs(x) >= min(float(max), 1.0/eps)) go to 100
k = abs(x)
u = x + k
if (u <= -0.5) u = 0.5 + (0.5 + u)
u = pi*u
sn = sin(u)
cn = cos(u)
!     SET h1 + h2*I = pi*COT(pi*z)
s1 = a1*sn
s2 = a2*cn
c1 = a1*cn
c2 = -a2*sn
s = s1*s1 + s2*s2
h1 = pi*(s1*c1 + s2*c2)/s
h2 = pi*(s1*c2 - s2*c1)/s
if (aimag(z) < 0.0) go to 30
x = 1.0 - x
y = -y
go to 40
30 h2 = -h2
x = 1.0 - x
!-----------------------------------------------------------------------
!           Case when the real part of z is nonnegative
!-----------------------------------------------------------------------
40 t = x
y2 = y*y
a = x*x + y2
if (a == 0.0) go to 100
!     Let s1 + S2*I be the sum of the terms 1/(z+j) for j = 0,1,...,N-1
ds1 = 0.d0
ds2 = 0.d0
50 if (a >= 36.0) go to 51
ds1 = ds1 + dble(t/a)
ds2 = ds2 - dble(y/a)
t = t + 1.0
a = t*t + y2
go to 50
51 s1 = ds1
s2 = ds2
!     SET W1 + W2*I = log(z+N)
w1 = 0.5*log(a)
w2 = atan2(y,t)
!     Let a1 + a2*I be the asymptotic sum
eta = cmplx(t/a,-y/a)
eta2 = eta*eta
m = 12
l = m
sum = cmplx(c0(m),0.0)
do j = 2,m
   l = l - 1
   sum = cmplx(c0(l),0.0) + sum*eta2
end do
sum = cmplx(0.5,0.0)*eta + eta2*sum
a1 = real(sum)
a2 = aimag(sum)
!-----------------------------------------------------------------------
!                 Gathering together the results
!-----------------------------------------------------------------------
w1 = (w1 - s1) - a1
w2 = (w2 - a2) - s2
w = cmplx(w1,w2)
if (real(z) >= 0.0) return
w = cmplx(w1 - h1, w2 - h2)
return
!-----------------------------------------------------------------------
!             The requested value cannot be computed
!-----------------------------------------------------------------------
100 w = (0.0, 0.0)
end subroutine cpsi

pure real function psi(xx)
implicit none
real, intent(in) :: xx
integer :: i, m, n, nq
real :: aug, den, sgn, upper, w, x, xmax1, xmx0, xsmall, z
real, parameter :: piov4 = .785398163397448e0
double precision, parameter :: dx0 = 1.461632144968362341262659542325721325d0
real, parameter :: p1(7) = [.895385022981970e-02, .477762828042627e+01, .142441585084029e+03, .118645200713425e+04, &
   & .363351846806499e+04, .413810161269013e+04, .130560269827897e+04]
real, parameter :: q1(6) = [.448452573429826e+02, .520752771467162e+03, .221000799247830e+04, .364127349079381e+04, &
   & .190831076596300e+04, .691091682714533e-05]
real, parameter :: p2(4) = [-.212940445131011e+01, -.701677227766759e+01, -.448616543918019e+01, -.648157123766197e+00]
real, parameter :: q2(4) = [.322703493791143e+02, .892920700481861e+02, .546117738103215e+02, .777788548522962e+01]
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!---------------------------------------------------------------------
!                 Evaluation of the digamma function
!                           -----------
!     psi(xx) is assigned the value 0 when the digamma function CANNOT
!     be computed.
!     The main computation involves evaluation of rational Chebyshev
!     approximations published in math. Comp. 27, 123-127(1973) By
!     Cody, Strecok and Thacher.
!---------------------------------------------------------------------
!     Psi was written at Argonne National Laboratory for the funpack
!     package of special function subroutines. Psi was modified by
!     A.H. Morris (NSWC).
!---------------------------------------------------------------------
!---------------------------------------------------------------------
!     piov4 = pi/4
!     dx0 = Zero of psi to extended precision
!---------------------------------------------------------------------
!---------------------------------------------------------------------
!     Coefficients for rational approximation of
!     psi(x) / (x - X0),  0.5 .LE. x .LE. 3.0
!---------------------------------------------------------------------
!---------------------------------------------------------------------
!     Coefficients for rational approximation of
!     psi(x) - LN(x) + 1 / (2*x),  x .GT. 3.0
!---------------------------------------------------------------------
!---------------------------------------------------------------------
!     Machine dependent constants ...
!        xmax1  = The smallest positive floating point constant
!                 with entirely integer representation.  Also used
!                 as negative of lower bound on acceptable negative
!                 arguments and as the positive argument beyond which
!                 psi may be represented as ALOG(x).
!        xsmall = Absolute argument below which pi*cotan(PI*x)
!                 may be represented by 1/x.
!---------------------------------------------------------------------
xmax1 = ipmpar(3)
xmax1 = min(xmax1, 1.0/spmpar(1))
xsmall = 1.e-9
!---------------------------------------------------------------------
x = xx
aug = 0.0e0
if (x >= 0.5e0) go to 200
!---------------------------------------------------------------------
!     x .LT. 0.5,  use reflection formula
!     psi(1-x) = psi(x) + pi * cotan(pi*x)
!---------------------------------------------------------------------
if (abs(x) > xsmall) go to 100
if (x == 0.0e0) go to 400
!---------------------------------------------------------------------
!     0 .LT. abs(x) .LE. xsmall.  USE 1/x AS A SUBSTITUTE
!     for  pi*cotan(PI*x)
!---------------------------------------------------------------------
aug = -1.0e0 / x
go to 150
!---------------------------------------------------------------------
!     Reduction of argument for cotan
!---------------------------------------------------------------------
100 w = - x
sgn = piov4
if (w > 0.0e0) go to 120
w = - w
sgn = -sgn
!---------------------------------------------------------------------
!     Make an error exit if x .LE. -xmax1
!---------------------------------------------------------------------
120 if (w >= xmax1) go to 400
nq = int(w)
w = w - float(nq)
nq = int(w*4.0e0)
w = 4.0e0 * (w - float(nq) * .25e0)
!---------------------------------------------------------------------
!     w is now related to the fractional part of  4.0 * x.
!     Adjust argument to correspond to values in first
!     quadrant and determine sign
!---------------------------------------------------------------------
n = nq / 2
if ((n + n) /= nq) w = 1.0e0 - w
z = piov4 * w
m = n / 2
if ((m + m) /= n) sgn = - sgn
!---------------------------------------------------------------------
!     Determine final value for  -Pi*cotan(PI*x)
!---------------------------------------------------------------------
n = (nq + 1) / 2
m = n / 2
m = m + m
if (m /= n) go to 140
!---------------------------------------------------------------------
!     Check for singularity
!---------------------------------------------------------------------
if (z == 0.0e0) go to 400
!---------------------------------------------------------------------
!     Use cos/sin as a substitute for cotan, and
!     sin/cos as a substitute for tan
!---------------------------------------------------------------------
aug = sgn * ((cos(z) / sin(z)) * 4.0e0)
go to 150
140 aug = sgn * ((sin(z) / cos(z)) * 4.0e0)
150 x = 1.0e0 - x
200 if (x > 3.0e0) go to 300
!---------------------------------------------------------------------
!     0.5 .LE. x .LE. 3.0
!---------------------------------------------------------------------
den = x
upper = p1(1) * x
do i = 1, 5
   den = (den + q1(i)) * x
   upper = (upper + p1(i + 1)) * x
end do
den = (upper + p1(7)) / (den + q1(6))
xmx0 = dble(x) - dx0
psi = den * xmx0 + aug
return
!---------------------------------------------------------------------
!     IF x .GE. xmax1, PSI = LN(x)
!---------------------------------------------------------------------
300 if (x >= xmax1) go to 350
!---------------------------------------------------------------------
!     3.0 .LT. x .LT. xmax1
!---------------------------------------------------------------------
w = 1.0e0 / (x * x)
den = w
upper = p2(1) * w
do i = 1, 3
   den = (den + q2(i)) * w
   upper = (upper + p2(i + 1)) * w
end do
aug = upper / (den + q2(4)) - 0.5e0 / x + aug
350 psi = aug + log(x)
return
!---------------------------------------------------------------------
!     Error return
!---------------------------------------------------------------------
400 psi = 0.0e0
end function psi

pure subroutine dcpsi(z, w)
implicit none
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
integer :: j, k, m, max
double precision :: a, a1, a2, cn, cut, c1, c2, eps, et, h1, h2, &
   & q1, q2, s, sn, s1, s2, t, t1, t2, u, u1, u2, v1, v2, w1, w2, x, y, &
   & y2
double precision, parameter :: pi = 3.141592653589793238462643383279502884197d0
double precision, parameter :: pi2 = 6.283185307179586476925286766559005768394d0
double precision, parameter :: c0(30) = [.8333333333333333333333333333333333333333d-01, - &
   & .8333333333333333333333333333333333333333d-02, .3968253968253968253968253968253968253968d-02, - &
   & .4166666666666666666666666666666666666667d-02, .7575757575757575757575757575757575757576d-02, - &
   & .2109279609279609279609279609279609279609d-01, .8333333333333333333333333333333333333333d-01, - &
   & .4432598039215686274509803921568627450980d+00, .3053954330270119743803954330270119743804d+01, - &
   & .2645621212121212121212121212121212121212d+02, .2814601449275362318840579710144927536232d+03, - &
   & .3607510546398046398046398046398046398046d+04, .5482758333333333333333333333333333333333d+05, - &
   & .9749368238505747126436781609195402298851d+06, .2005269579668807894614346227249453055905d+08, - &
   & .4723848677216299019607843137254901960784d+09, .1263572479591666666666666666666666666667d+11, - &
   & .3808793112524536881155302207933786881155d+12, .1285085049930508333333333333333333333333d+14, - &
   & .4824144835485017037158167036215816703622d+15, .2004031065651625273810842166323893898645d+17, - &
   & .9167743603195330775699275362318840579710d+18, .4597988834365650349043794326241134751773d+20, - &
   & .2518047192145109569708902332022552610788d+22, .1500173349215392873371144015151515151515d+24, - &
   & .9689957887463594065649794289465408805031d+25, .6764588237929282099094524230179847767567d+27, - &
   & .5089065946866228968976633291591192528736d+29, .4114728879255797869766548606761933615819d+31, - &
   & .3566658209537555610968457460865182898779d+33]
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function drexp(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: drexp
   end function drexp
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!           Evaluation of the complex digamma function
!-----------------------------------------------------------------------
!----------------------------
!     pi2 = 2*pi
!----------------------------
!----------------------------
!----------------------------
!     ****** max and eps are machine dependent constants.
!            Max is the largest positive integer that may
!            be used, and eps is the smallest real number
!            such that 1.D0 + eps .GT. 1.D0.
max = ipmpar(3)
eps = dpmpar(1)
!----------------------------
x = z(1)
y = z(2)
if (x >= 0.d0) go to 40
!-----------------------------------------------------------------------
!            Case when the real part of z is negative
!-----------------------------------------------------------------------
y = abs(y)
t = -pi2*y
et = exp(t)
!     SET  a1 = (1 + et)/2  AND  a2 = (1 - et)/2
a1 = 0.5d0*(1.d0 + et)
if (t < -0.15d0) go to 10
a2 = -0.5d0*drexp(t)
go to 20
10 a2 = 0.5d0*(0.5d0 + (0.5d0 - et))
!     Compute sin(pi*X) and cos(pi*X), or -sin(pi*X) and -cos(pi*X)
20 u = max
if (abs(x) >= min(u, 1.d0/eps)) go to 100
k = abs(x)
u = x + k
if (u <= -0.5d0) u = 0.5d0 + (0.5d0 + u)
u = pi*u
sn = sin(u)
cn = cos(u)
!     SET h1 + h2*I = pi*COT(pi*z)
s1 = a1*sn
s2 = a2*cn
c1 = a1*cn
c2 = -a2*sn
s = s1*s1 + s2*s2
h1 = pi*(s1*c1 + s2*c2)/s
h2 = pi*(s1*c2 - s2*c1)/s
if (z(2) < 0.d0) go to 30
x = 1.d0 - x
y = -y
go to 40
30 h2 = -h2
x = 1.d0 - x
!-----------------------------------------------------------------------
!           Case when the real part of z is nonnegative
!-----------------------------------------------------------------------
40 t = x
y2 = y*y
a = x*x + y2
if (a == 0.d0) go to 100
cut = 225.d0
if (eps > 1.d-30) cut = 144.d0
!     Let S1 + S2*I be the sum of the terms 1/(z+j) for j = 0,1,...,N-1
s1 = 0.d0
s2 = 0.d0
50 if (a >= cut) go to 51
s1 = s1 + t/a
s2 = s2 - y/a
t = t + 1.d0
a = t*t + y2
go to 50
51 continue
!     SET W1 + W2*I = log(z+N)
w1 = 0.5d0*log(a)
w2 = atan2(y,t)
!     Let a1 + a2*I be the asymptotic sum
u1 = t/a
u2 = -y/a
q1 = u1*u1 - u2*u2
q2 = 2.d0*u1*u2
v1 = q1
v2 = q2
a1 = 0.d0
a2 = 0.d0
m = 30
if (eps > 1.d-30) m = 25
do j = 1,m
   t1 = a1
   t2 = a2
   a1 = a1 + c0(j)*v1
   a2 = a2 + c0(j)*v2
   if (a1 /= t1) go to 60
   if ( a2 == t2 ) exit
60 t1 = v1*q1 - v2*q2
   t2 = v1*q2 + v2*q1
   v1 = t1
   v2 = t2
end do
!-----------------------------------------------------------------------
!                 Gathering together the results
!-----------------------------------------------------------------------
a1 = a1 + 0.5d0*u1
a2 = a2 + 0.5d0*u2
w(1) = (w1 - a1) - s1
w(2) = (w2 - a2) - s2
if (z(1) >= 0.d0) return
w(1) = w(1) - h1
w(2) = w(2) - h2
return
!-----------------------------------------------------------------------
!             The requested value cannot be computed
!-----------------------------------------------------------------------
100 w(1) = 0.d0
w(2) = 0.d0
end subroutine dcpsi

pure elemental double precision function dpsi(a)
implicit none
double precision, intent(in) :: a
integer :: j, k, l, max, n, nswc_ai_i4
double precision :: eps, s, t, x, xmax, w
double precision, parameter :: pi = 3.1415926535897932384626433832795d0
double precision, parameter :: x0 = .46163214496836234126265954232572d0
double precision, parameter :: c(42) = [-.38057080835217921520437677667039d-01, &
   & .49141539302938712748204699654277d+00, -.56815747821244730242892064734081d-01, .83578212259143131362775650747862d-02, - &
   & .13332328579943425998079274172393d-02, .22031328706930824892872397979521d-03, -.37040238178456883592889086949229d-04, &
   & .62837936548549898933651418717690d-05, -.10712639085061849855283541747074d-05, .18312839465484165805731589810378d-06, - &
   & .31353509361808509869005779796885d-07, .53728087762007766260471919143615d-08, -.92116814159784275717880632624730d-09, &
   & .15798126521481822782252884032823d-09, -.27098646132380443065440589409707d-10, .46487228599096834872947319529549d-11, - &
   & .79752725638303689726504797772737d-12, .13682723857476992249251053892838d-12, -.23475156060658972717320677980719d-13, &
   & .40276307155603541107907925006281d-14, -.69102518531179037846547422974771d-15, .11856047138863349552929139525768d-15, - &
   & .20341689616261559308154210484223d-16, .34900749686463043850374232932351d-17, -.59880146934976711003011081393493d-18, &
   & .10273801628080588258398005712213d-18, -.17627049424561071368359260105386d-19, .30243228018156920457454035490133d-20, - &
   & .51889168302092313774286088874666d-21, .89027730345845713905005887487999d-22, -.15274742899426728392894971904000d-22, &
   & .26207314798962083136358318079999d-23, -.44964642738220696772598388053333d-24, .77147129596345107028919364266666d-25, - &
   & .13236354761887702968102638933333d-25, .22709994362408300091277311999999d-26, -.38964190215374115954491391999999d-27, &
   & .66851981388855302310679893333333d-28, -.11469986654920864872529919999999d-28, .19679385886541405920515413333333d-29, - &
   & .33764488189750979801907200000000d-30, .57930703193214159246677333333333d-31]
double precision, parameter :: p(15) = [.833333333333333333333333333147d-03, - &
   & .833333333333333333333317475057d-06, .396825396825396825343072884056d-08, -.416666666666666570859890514548d-10, &
   & .757575757575654146210665696401d-12, -.210927960920616064592099772274d-13, .833333329719356554828382131321d-15, - &
   & .443259676504784387819140445894d-16, .305392145578967948828783519552d-17, -.264499326810660590871410866039d-18, &
   & .280568932535744579536244004181d-19, -.351388195869099967789469969066d-20, .476233402067211507540059750399d-21, - &
   & .575024569953144855161645738666d-22, .416180125797657207803740160000d-23]
interface
   pure function dcsevl(x,a,n)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: x
      double precision, intent(in) :: a(n)
      double precision :: dcsevl
   end function dcsevl
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function dpsi0(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dpsi0
   end function dpsi0
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!               Evaluation of the digamma function for
!                     double precision arguments
!                           -----------
!     dpsi(a) is assigned the value 0 when the digamma function CANNOT
!     be computed.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!          Naval Surface Warfare Center
!          Dahlgren, Virginia
!-----------------------------------------------------------------------
!     The series for dpsi on the interval 0.0 to 1.0 was derived
!     by Wayne Fullerton (Los Alamos National Laboratory).
!                                  WITH WEIGHTED ERROR   5.79E-32
!                                   log weighted error  31.24
!                         significant figures required  30.93
!                              decimal places required  32.05
!     the series for  a .GE. 10  was derived by A.H. Morris from
!     the Chebyshev series in the SLATEC library obtained by Wayne
!     Fullerton (Los Alamos).
!-----------------------------------------------------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!     ****** xmax, max, and eps are machine dependent constants.
!            Xmax is the largest positive real number that may
!            be used, max is the largest positive integer that
!            may be used, and eps is the smallest real number
!            such that 1.D0 + eps .GT. 1.D0.
max = ipmpar(3)
eps = dpmpar(1)
xmax = dpmpar(3)
!----------------------------
dpsi = 0.d0
x = a
if (abs(a) >= 10.d0) go to 60
!-----------------------------------------------------------------------
!             Evaluation of dpsi(a) for dabs(a) .LT. 10
!-----------------------------------------------------------------------
t = 0.d0
n = x
n = n - 1
!     Let t be the sum of 1/(a-j) when a .GE. 2
nswc_ai_i4 = n
if ( nswc_ai_i4 < 0 ) go to 20
if ( nswc_ai_i4 == 0 ) go to 12
go to 10
10 do j = 1,n
   x = x - 1.d0
   t = 1.d0/x + t
end do
12 x = x - 1.d0
go to 40
!     Check if 1/a can overflow
20 if (abs(a) >= 1.d-35) go to 30
if (abs(a)*xmax <= 1.000000001d0) return
!     Let t be the sum of -1/(a+j) when a .LT. 1
30 t = -1.d0/a
if (a > 0.d0) go to 40
n = - n - 1
if (n == 0) go to 32
do j = 1,n
   x = x + 1.d0
   if (x == 0.d0) return
   t = t - 1.d0/x
end do
32 x = (x + 0.5d0) + 0.5d0
if (x == 0.d0) return
t = t - 1.d0/x
!     COMPUTE  t + dpsi(1 + x)  FOR 0 .LE. x .LT. 1
40 if (abs(x - x0) > 2.d-2) go to 50
dpsi = t + dpsi0(1.d0 + x)
return
50 k = 42
if (eps > 1.d-20) k = 28
dpsi = t + dcsevl(2.d0*x - 1.d0, c, k)
return
!-----------------------------------------------------------------------
!           Evaluation of dpsi(a) for dabs(a) .GE. 10
!-----------------------------------------------------------------------
60 if (a > 0.d0) go to 70
t = max
if (abs(a) >= min(t, 1.d0/eps)) return
!     Set w = pi*cot(pi*a) when A is negative
k = abs(a)
t = a + k
if (t == 0.d0) return
if (t <= -0.5d0) t = 1.d0 + t
t = pi*t
w = pi*(cos(t)/sin(t))
x = 1.d0 - x
!     Compute the modified asymptotic sum
70 t = (10.d0/x)**2
s = p(15)
do j = 1,14
   l = 15 - j
   s = p(l) + t*s
end do
s = 0.5d0/x + t*s
!     Final assembly
dpsi = log(x) - s
if (a < 0.d0) dpsi = dpsi - w
end function dpsi

pure elemental double precision function dpsi0(x)
implicit none
double precision, intent(in) :: x
integer :: i, l, n, nm1
double precision :: h, w, db2
double precision, parameter :: dk1 = 100442596182.d0
double precision, parameter :: dk2 = 51069247913.d0
double precision, parameter :: dk3 = 53827985572.d0
double precision, parameter :: db = 68719476736.d0
double precision, parameter :: dx = .28939299282041499433886199389507989269636d-32
double precision, parameter :: a(20) = [.967672245447621170427444761710d+00, - &
   & .442763168983592106092865281853d+00, .258499760955651010624401385701d+00, -.163942705442406527504251292747d+00, &
   & .107824050691262365757182948867d+00, -.721995612564547109261217836051d-01, .488042881641431072250925255079d-01, - &
   & .331611264748473592922583984045d-01, .225976482322181046596248251178d-01, -.154247659049489591388003168412d-01, &
   & .105387916166121753881240498824d-01, -.720453438635686824097047437040d-02, .492678139572985344635426640268d-02, - &
   & .336980165543932808279285672353d-02, .230512632673492783693838028298d-02, -.157693677143019725927093497173d-02, &
   & .107882520191629658069191777474d-02, -.738070938996005129566047389379d-03, .504953265834602035177398177463d-03, - &
   & .345468025106307699555567970882d-03]
!-----------------------------------------------------------------------
!            Taylor series expansion of psi(x) around X0,
!                  where X0 is the zero of psi(x).
!-------------------------
!     Written by A.H. Morris
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!     Set  h = x - X0  where X0 is the zero of psi(x). X0 has the
!     approximate 60 digit value ...
!      1.4616321449683623412 62659542325721328468 19620400644635129598
!     A more accurate value is given by ...
!            x0 = dk1/8**12 + dk2/8**24 + dk3/8**36 + dx
!     the following code should yield the correct value for h if A
!     binary, octal, or hexadecimal double precision arithmetic is
!     being used.
db2 = db*db
h = (((x - dk1/db) - dk2/db2) - dk3/(db*db2)) - dx
!-------------------------
n = 20
nm1 = n - 1
w = a(n)
do i = 1,nm1
   l = n - i
   w = a(l) + h*w
end do
dpsi0 = h*w
end function dpsi0

pure subroutine psidf(x, n, m, ans, iflag)
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: m, n
real, intent(in) :: x
real, intent(inout) :: ans(m)
integer :: i, j, k, mx, nn, np, nx
real :: alpha, arg, beta, den, elim, eps, fln, fn, fnp, fns, fx, nd, rxsq, s, t, ta, tk, tol, tols, tss, tst, tt, t1, t2, wdtol, &
   & xdmln, xdmy, xinc, xln, xm, xmin, trm(22), trmr(100)
real, parameter :: c = .43429
integer, parameter :: nmax = 100
real, parameter :: b(22) = [1.0, -5.00000000000000000e-01, 1.66666666666666667e-01, -3.33333333333333333e-02, &
   & 2.38095238095238095e-02, -3.33333333333333333e-02, 7.57575757575757576e-02, -2.53113553113553114e-01, 1.16666666666666667e+00 &
   & , -7.09215686274509804e+00, 5.49711779448621554e+01, -5.29124242424242424e+02, 6.19212318840579710e+03, - &
   & 8.65802531135531136e+04, 1.42551716666666667e+06, -2.72982310678160920e+07, 6.01580873900642368e+08, -1.51163157670921569e+10 &
   & , 4.29614643061166667e+11, -1.37116552050883328e+13, 4.88332318973593167e+14, -1.92965793419400681e+16]
interface
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
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!         psidf computes m member sequences of scaled derivatives of
!         the psi function
!                w(k,x)=(-1)**(k+1)*psi(k,x)/gamma(k+1)
!         k=n,...,n+m-1 where psi(k,x) is the k-TH derivative of the
!         psi function.
!         The BASIC method of evaluation is the asymptotic expansion
!         for large x.GE.xmin followed by backward recursion on a two
!         term recursion relation
!                  W(x+1) + x**(-n-1) = W(x).
!         This is supplemented by a series
!                  sum( (x+k)**(-n-1) , k=0,1,2,... )
!         which converges rapidly for large n. both xmin and the
!         number of terms of the series are calculated from the unit
!         round off of the machine environment.
!         The nominal computational accuracy is the maximum of unit
!         roundoff (=spmpar(1)) and 1.0E-18 since critical constants
!         are given to only 18 digits.
!     Description of arguments
!         input
!           x      - ARGUMENT, x .GT. 0.0
!           n      - First member of the sequence, n .GE. 0
!           m      - Number of members of the sequence, m .GE. 1
!         output
!           ans    - A vector of length at least m whose first m
!                    components are the scaled derivatives.
!           iflag  - A variable which reports the status of the
!                    results.
!                    iflag = 0 The desired values were obtained.
!                    iflag = 1 An input error was detected.
!                    iflag = 2 Overflow. x too small or n+m-1
!                              too large.
!                    iflag = 3 Underflow. x too large or n+m-1
!                              too large.
!                    iflag = 4 n+m-1 is too large for the current
!                              value of x. this setting will not
!                              occur when n+m-1 .LE. 100.
!-----------------------------------------------------------------------
!     Written by Donald E. Amos
!         Sandia Laboratories
!         June 1982
!     modified by A. H. Morris (NSWC), 1990.
!     References ...
!     (1) ACM Trans. Math Software, 1983.
!     (2) Handbook of mathematical functions, AMS 55, national bureau
!         of standards by m. Abramowitz and I.A. Stegun, 1964, PP.
!         258-260, equations 6.3.5, 6.3.18, 6.4.6, 6.4.9, 6.4.10.
!-----------------------------------------------------------------------
!------------------------
!     c = 1/ln(10)
!------------------------
!-----------------------------------------------------------------------
!                        Bernoulli numbers
!-----------------------------------------------------------------------
!------------------------
iflag = 0
if (x <= 0.0 .or. n < 0 .or. m < 1) go to 300
nn = n + m - 1
fn = float(nn)
fnp = fn + 1.0
eps = spmpar(1)
wdtol = max(0.5*eps, 0.5e-18)
!-----------------------------------------------------------------------
!     elim = Approximate exponential over and underflow limit
!-----------------------------------------------------------------------
elim = min(exparg(0), abs(exparg(1))) - 6.906
xln = log(x)
t = fnp*xln
!-----------------------------------------------------------------------
!     Overflow and underflow test for small and large x
!-----------------------------------------------------------------------
if (abs(t) > elim) go to 310
if (x < wdtol) go to 260
!-----------------------------------------------------------------------
!     Compute xmin and the number of terms of the series, fln+1
!-----------------------------------------------------------------------
nd = -c*epsln(0)
nd = min(nd,18.0)
fln = nd - 3.0
alpha = 3.5 + 0.4*fln
beta = 0.21 + fln*(0.0006038*fln + 0.008677)
xm = alpha + beta*fn
mx = int(xm) + 1
xmin = float(mx)
if (n == 0) go to 50
xm = -2.302*nd - min(0.0,xln)
fns = float(n)
arg = xm/fns
arg = min(0.0,arg)
eps = exp(arg)
xm = 1.0 - eps
if (abs(arg) < 1.0e-3) xm = -arg
fln = x*xm/eps
xm = xmin - x
if (xm > 7.0 .and. fln < 15.0) go to 200
50 xdmy = x
xdmln = xln
xinc = 0.0
if (x >= xmin) go to 60
nx = int(x)
xinc = xmin - float(nx)
xdmy = x + xinc
xdmln = log(xdmy)
60 continue
!-----------------------------------------------------------------------
!     Generate W(n+m-1,x) by the asymptotic expansion
!-----------------------------------------------------------------------
t = fn*xdmln
t1 = xdmln + xdmln
t2 = t + xdmln
tk = max(abs(t),abs(t1),abs(t2))
if (tk > elim) go to 320
tss = exp(-t)
tt = 0.5/xdmy
t1 = tt
tst = wdtol*tt
if (nn /= 0) t1 = tt + 1.0/fn
rxsq = 1.0/(xdmy*xdmy)
ta = 0.5*rxsq
t = fnp*ta
s = t*b(3)
if (abs(s) < tst) go to 80
tk = 2.0
do k = 4,22
   t = t*((tk + fn + 1.0)/(tk + 1.0))*((tk + fn)/(tk + 2.0))*rxsq
   trm(k) = t*b(k)
   if ( abs ( trm ( k ) ) < tst ) exit
   s = s + trm(k)
   tk = tk + 2.0
end do
80 s = (s + t1)*tss
if (xinc == 0.0) go to 100
!-----------------------------------------------------------------------
!     Backward recur from xdmy to x
!-----------------------------------------------------------------------
nx = int(xinc)
np = nn + 1
if (nx > nmax) go to 330
if (nn == 0) go to 160
xm = xinc - 1.0
fx = x + xm
!-----------------------------------------------------------------------
!     This loop should not be changed. FX is accurate when x is small
!-----------------------------------------------------------------------
do i = 1,nx
   trmr(i) = fx**(-np)
   s = s + trmr(i)
   xm = xm - 1.0
   fx = x + xm
end do
100 ans(m) = s
if (fn == 0.0) go to 180
!-----------------------------------------------------------------------
!     Generate lower derivatives, j.LT.n+m-1
!-----------------------------------------------------------------------
if (m == 1) return
do j = 2,m
   fnp = fn
   fn = fn - 1.0
   tss = tss*xdmy
   t1 = tt
   if (fn /= 0.0) t1 = tt + 1.0/fn
   t = fnp*ta
   s = t*b(3)
   if (abs(s) < tst) go to 120
   tk = 3.0e0 + fnp
   do k = 4,22
      trm(k) = trm(k)*fnp/tk
      if ( abs ( trm ( k ) ) < tst ) exit
      s = s + trm(k)
      tk = tk + 2.0
   end do
120 s = (s + t1)*tss
   if (xinc == 0.0) go to 140
   if (fn == 0.0) go to 160
   xm = xinc - 1.0
   fx = x + xm
   do i = 1,nx
      trmr(i) = trmr(i)*fx
      s = s + trmr(i)
      xm = xm - 1.0
      fx = x + xm
   end do
140 mx = m - j + 1
   ans(mx) = s
   if (fn == 0.0) go to 180
end do
return
!-----------------------------------------------------------------------
!     Recursion for n = 0
!-----------------------------------------------------------------------
160 do i = 1,nx
   s = s + 1.0/(x + float(nx - i))
end do
180 ans(1) = s - xdmln
return
!-----------------------------------------------------------------------
!     Compute by series (x+k)**(-(n+1)) , k=0,1,2,...
!-----------------------------------------------------------------------
200 nn = int(fln) + 1
np = n + 1
t1 = (fns + 1.0)*xln
t = exp(-t1)
s = t
den = x
do i = 1,nn
   den = den + 1.0
   trm(i) = den**(-np)
   s = s + trm(i)
end do
ans(1) = s
if (m == 1) return
!-----------------------------------------------------------------------
!     Generate higher derivatives, j .GT. n
!-----------------------------------------------------------------------
tol = wdtol/5.0
do j = 2,m
   t = t/x
   s = t
   tols = t*tol
   den = x
   do i = 1,nn
      den = den + 1.0
      trm(i) = trm(i)/den
      s = s + trm(i)
      if ( trm ( i ) < tols ) exit
   end do
   ans(j) = s
end do
return
!-----------------------------------------------------------------------
!     Small x .LT. unit round off
!-----------------------------------------------------------------------
260 ans(1) = x**(-n - 1)
if (m == 1) return
k = 1
do i = 2,m
   ans(k + 1) = ans(k)/x
   k = k + 1
end do
return
!-----------------------------------------------------------------------
!     Error return
!-----------------------------------------------------------------------
300 iflag = 1
return
310 if (t > 0.0) go to 320
iflag = 2
return
320 iflag = 3
return
!                            Increase the dimension of trmr(nmax)
330 iflag = 4
end subroutine psidf

pure elemental real function betaln(a0, b0)
implicit none
real, intent(in) :: a0, b0
integer :: i, n
real :: a, b, c, h, u, v, w, z
real, parameter :: e = .918938533204673
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function bcorr(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: bcorr
   end function bcorr
   pure elemental function gamln(a)
      implicit none
      real, intent(in) :: a
      real :: gamln
   end function gamln
   pure elemental function gsumln(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: gsumln
   end function gsumln
end interface
!-----------------------------------------------------------------------
!     Evaluation of the logarithm of the beta function
!-----------------------------------------------------------------------
!     e = 0.5*ln(2*pi)
!--------------------------
!--------------------------
a = min(a0,b0)
b = max(a0,b0)
if (a >= 8.0) go to 60
if (a >= 1.0) go to 20
!-----------------------------------------------------------------------
!                   Procedure when a .LT. 1
!-----------------------------------------------------------------------
if (b >= 8.0) go to 10
betaln = gamln(a) + (gamln(b) - gamln(a + b))
return
10 betaln = gamln(a) + algdiv(a,b)
return
!-----------------------------------------------------------------------
!                Procedure when 1 .LE. a .LT. 8
!-----------------------------------------------------------------------
20 if (a > 2.0) go to 30
if (b > 2.0) go to 21
betaln = gamln(a) + gamln(b) - gsumln(a,b)
return
21 w = 0.0
if (b < 8.0) go to 40
betaln = gamln(a) + algdiv(a,b)
return
!                Reduction of a when b .LE. 1000
30 if (b > 1000.0) go to 50
n = a - 1.0
w = 1.0
do i = 1,n
   a = a - 1.0
   h = a/b
   w = w * (h/(1.0 + h))
end do
w = log(w)
if (b < 8.0) go to 40
betaln = w + gamln(a) + algdiv(a,b)
return
!                 Reduction of b when b .LT. 8
40 n = b - 1.0
z = 1.0
do i = 1,n
   b = b - 1.0
   z = z * (b/(a + b))
end do
betaln = w + log(z) + (gamln(a) + (gamln(b) - gsumln(a,b)))
return
!                Reduction of a when b .GT. 1000
50 n = a - 1.0
w = 1.0
do i = 1,n
   a = a - 1.0
   w = w * (a/(1.0 + a/b))
end do
betaln = (log(w) - n*log(b)) + (gamln(a) + algdiv(a,b))
return
!-----------------------------------------------------------------------
!                   Procedure when a .GE. 8
!-----------------------------------------------------------------------
60 w = bcorr(a,b)
h = a/b
c = h/(1.0 + h)
u = -(a - 0.5)*log(c)
v = b*alnrel(h)
if (u <= v) go to 61
betaln = (((-0.5*log(b) + e) + w) - v) - u
return
61 betaln = (((-0.5*log(b) + e) + w) - u) - v
end function betaln

pure elemental real function gsumln(a, b)
implicit none
real, intent(in) :: a, b
real :: x
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function gamln1(a)
      implicit none
      real, intent(in) :: a
      real :: gamln1
   end function gamln1
end interface
!-----------------------------------------------------------------------
!          Evaluation of the function ln(gamma(a + b))
!          FOR 1 .LE. a .LE. 2  AND  1 .LE. b .LE. 2
!-----------------------------------------------------------------------
x = dble(a) + dble(b) - 2.d0
if (x > 0.25) go to 10
gsumln = gamln1(1.0 + x)
return
10 if (x > 1.25) go to 20
gsumln = gamln1(x) + alnrel(x)
return
20 gsumln = gamln1(x - 1.0) + log(x*(1.0 + x))
end function gsumln

pure elemental real function bcorr(a0, b0)
implicit none
real, intent(in) :: a0, b0
real :: a, b, c, h, s11, s3, s5, s7, s9, t, w, x, x2
real, parameter :: c0 = .833333333333333e-01
real, parameter :: c1 = -.277777777760991e-02
real, parameter :: c2 = .793650666825390e-03
real, parameter :: c3 = -.595202931351870e-03
real, parameter :: c4 = .837308034031215e-03
real, parameter :: c5 = -.165322962780713e-02
!-----------------------------------------------------------------------
!     Evaluation of  del(a0) + del(b0) - Del(a0 + b0)  where
!     LN(gamma(a)) = (a - 0.5)*LN(a) - a + 0.5*LN(2*PI) + DEL(a).
!     It is assumed that a0 .GE. 8 and b0 .GE. 8.
!-----------------------------------------------------------------------
!------------------------
a = min(a0, b0)
b = max(a0, b0)
h = a/b
c = h/(1.0 + h)
x = 1.0/(1.0 + h)
x2 = x*x
!                SET SN = (1 - X**N)/(1 - X)
s3 = 1.0 + (x + x2)
s5 = 1.0 + (x + x2*s3)
s7 = 1.0 + (x + x2*s5)
s9 = 1.0 + (x + x2*s7)
s11 = 1.0 + (x + x2*s9)
!                SET W = DEL(b) - DEL(a + b)
t = (1.0/b)**2
w = ((((c5*s11*t + c4*s9)*t + c3*s7)*t + c2*s5)*t + c1*s3)*t + c0
w = w*(c/b)
!                   Compute  del(a) + W
t = (1.0/a)**2
bcorr = (((((c5*t + c4)*t + c3)*t + c2)*t + c1)*t + c0)/a + w
end function bcorr

pure elemental real function algdiv(a, b)
implicit none
real, intent(in) :: a, b
real :: c, d, h, s11, s3, s5, s7, s9, t, u, v, w, x, x2
real, parameter :: c0 = .833333333333333e-01
real, parameter :: c1 = -.277777777760991e-02
real, parameter :: c2 = .793650666825390e-03
real, parameter :: c3 = -.595202931351870e-03
real, parameter :: c4 = .837308034031215e-03
real, parameter :: c5 = -.165322962780713e-02
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
end interface
!-----------------------------------------------------------------------
!     Computation of LN(gamma(b)/gamma(a+b)) when b .GE. 8
!                         --------
!     In this algorithm, del(X) is the function defined by
!     LN(gamma(X)) = (X - 0.5)*LN(X) - X + 0.5*LN(2*PI) + DEL(X).
!-----------------------------------------------------------------------
!------------------------
if (a <= b) go to 10
h = b/a
c = 1.0/(1.0 + h)
x = h/(1.0 + h)
d = a + (b - 0.5)
go to 20
10 h = a/b
c = h/(1.0 + h)
x = 1.0/(1.0 + h)
d = b + (a - 0.5)
!                SET SN = (1 - X**N)/(1 - X)
20 x2 = x*x
s3 = 1.0 + (x + x2)
s5 = 1.0 + (x + x2*s3)
s7 = 1.0 + (x + x2*s5)
s9 = 1.0 + (x + x2*s7)
s11 = 1.0 + (x + x2*s9)
!                SET W = DEL(b) - DEL(a + b)
t = (1.0/b)**2
w = ((((c5*s11*t + c4*s9)*t + c3*s7)*t + c2*s5)*t + c1*s3)*t + c0
w = w*(c/b)
!                    Combine the results
u = d*alnrel(a/b)
v = a*(log(b) - 1.0)
if (u <= v) go to 30
algdiv = (w - v) - u
return
30 algdiv = (w - u) - v
end function algdiv

pure elemental double precision function dbetln(a0, b0)
implicit none
double precision, intent(in) :: a0, b0
integer :: i, n
double precision :: a, b, c, h, sn, u, v, w, z
double precision, parameter :: e = .9189385332046727417803297364056d0
interface
   pure elemental function dbcorr(a0,b0)
      implicit none
      double precision, intent(in) :: a0
      double precision, intent(in) :: b0
      double precision :: dbcorr
   end function dbcorr
   pure elemental function dgamln(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dgamln
   end function dgamln
   pure elemental function dgsmln(a,b)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: b
      double precision :: dgsmln
   end function dgsmln
   pure elemental function dlgdiv(a,b)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: b
      double precision :: dlgdiv
   end function dlgdiv
   pure elemental function dlnrel(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dlnrel
   end function dlnrel
end interface
!-----------------------------------------------------------------------
!     Evaluation of the logarithm of the beta function
!-----------------------------------------------------------------------
!--------------------------
!     e = 0.5*ln(2*pi)
!--------------------------
!--------------------------
a = min(a0,b0)
b = max(a0,b0)
if (a >= 10.d0) go to 60
if (a >= 1.d0) go to 20
!-----------------------------------------------------------------------
!                   Procedure when a .LT. 1
!-----------------------------------------------------------------------
if (b >= 10.d0) go to 10
dbetln = dgamln(a) + (dgamln(b) - dgamln(a + b))
return
10 dbetln = dgamln(a) + dlgdiv(a,b)
return
!-----------------------------------------------------------------------
!               Procedure when 1 .LE. a .LT. 10
!-----------------------------------------------------------------------
20 if (a > 2.d0) go to 30
if (b > 2.d0) go to 21
dbetln = dgamln(a) + dgamln(b) - dgsmln(a,b)
return
21 w = 0.d0
if (b < 10.d0) go to 40
dbetln = dgamln(a) + dlgdiv(a,b)
return
!               Reduction of a when b .LE. 1000
30 if (b > 1.d3) go to 50
n = a - 1.d0
w = 1.d0
do i = 1,n
   a = a - 1.d0
   h = a/b
   w = w * (h/(1.d0 + h))
end do
w = log(w)
if (b < 10.d0) go to 40
dbetln = w + dgamln(a) + dlgdiv(a,b)
return
!                Reduction of b when b .LT. 10
40 n = b - 1.d0
z = 1.d0
do i = 1,n
   b = b - 1.d0
   z = z * (b/(a + b))
end do
dbetln = w + log(z) + (dgamln(a) + (dgamln(b) - dgsmln(a,b)))
return
!               Reduction of a when b .GT. 1000
50 n = a - 1.d0
w = 1.d0
do i = 1,n
   a = a - 1.d0
   w = w*(a/(1.d0 + a/b))
end do
sn = n
dbetln = (log(w) - sn*log(b)) + (dgamln(a) + dlgdiv(a,b))
return
!-----------------------------------------------------------------------
!                  Procedure when a .GE. 10
!-----------------------------------------------------------------------
60 w = dbcorr(a,b)
h = a/b
c = h/(1.d0 + h)
u = -(a - 0.5d0)*log(c)
v = b*dlnrel(h)
if (u <= v) go to 61
dbetln = (((-0.5d0*log(b) + e) + w) - v) - u
return
61 dbetln = (((-0.5d0*log(b) + e) + w) - u) - v
end function dbetln

pure elemental double precision function dgsmln(a, b)
implicit none
!-----------------------------------------------------------------------
!          Evaluation of the function ln(gamma(a + b))
!          FOR 1 .LE. a .LE. 2  AND  1 .LE. b .LE. 2
!-----------------------------------------------------------------------
double precision, intent(in) :: a, b
double precision :: x
interface
   pure elemental function dgmln1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgmln1
   end function dgmln1
   pure elemental function dlnrel(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dlnrel
   end function dlnrel
end interface
x = (a - 1.d0) + (b - 1.d0)
if (x > 0.5d0) go to 10
dgsmln = dgmln1(1.d0 + x)
return
10 if (x > 1.5d0) go to 20
dgsmln = dgmln1(x) + dlnrel(x)
return
20 dgsmln = dgmln1(x - 1.d0) + log(x*(1.d0 + x))
end function dgsmln

pure elemental double precision function dbcorr(a0, b0)
implicit none
double precision, intent(in) :: a0, b0
integer :: j, k
double precision :: a, b, c, h, s(15), t, w, x, x2, z
double precision, parameter :: e(15) = [.833333333333333333333333333333d-01, - &
   & .277777777777777777777777752282d-04, .793650793650793650791732130419d-07, -.595238095238095232389839236182d-09, &
   & .841750841750832853294451671990d-11, -.191752691751854612334149171243d-12, .641025640510325475730918472625d-14, - &
   & .295506514125338232839867823991d-15, .179643716359402238723287696452d-16, -.139228964661627791231203060395d-17, &
   & .133802855014020915603275339093d-18, -.154246009867966094273710216533d-19, .197701992980957427278370133333d-20, - &
   & .234065664793997056856992426667d-21, .171348014966398575409015466667d-22]
!-----------------------------------------------------------------------
!     Evaluation of del(a) + del(b0) - Del(a) + b0) where
!     LN(gamma(x)) = (x - 0.5)*LN(x) - x + 0.5*LN(2*PI) + DEL(x).
!     It is assumed that a0 .GE. 10 and b0 .GE. 10.
!                         --------
!     The series for del(x), which applies for x .GE. 10, was
!     derived by A.H. Morris from the Chebyshev series in the
!     SLATEC library obtained by Wayne Fullerton (Los Alamos).
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
a = min(a0, b0)
b = max(a0, b0)
h = a/b
c = h/(1.d0 + h)
x = 1.d0/(1.d0 + h)
x2 = x*x
!        COMPUTE (1 - x**N)/(1 - x) FOR N = 1,3,5,...
!            Store these values in s(1),s(2),...
s(1) = 1.d0
do j = 1,14
   s(j + 1) = 1.d0 + (x + x2*s(j))
end do
!                SET w = DEL(b) - DEL(a + b)
t = (10.d0/b)**2
w = e(15)*s(15)
do j = 1,14
   k = 15 - j
   w = t*w + e(k)*s(k)
end do
w = w*(c/b)
!                    Compute  del(a) + w
t = (10.d0/a)**2
z = e(15)
do j = 1,14
   k = 15 - j
   z = t*z + e(k)
end do
dbcorr = z/a + w
end function dbcorr

pure elemental double precision function dlgdiv(a, b)
implicit none
double precision, intent(in) :: a, b
integer :: j, k
double precision :: c, d, h, s(15), t, u, v, w, x, x2
double precision, parameter :: e(15) = [.833333333333333333333333333333d-01, - &
   & .277777777777777777777777752282d-04, .793650793650793650791732130419d-07, -.595238095238095232389839236182d-09, &
   & .841750841750832853294451671990d-11, -.191752691751854612334149171243d-12, .641025640510325475730918472625d-14, - &
   & .295506514125338232839867823991d-15, .179643716359402238723287696452d-16, -.139228964661627791231203060395d-17, &
   & .133802855014020915603275339093d-18, -.154246009867966094273710216533d-19, .197701992980957427278370133333d-20, - &
   & .234065664793997056856992426667d-21, .171348014966398575409015466667d-22]
interface
   pure elemental function dlnrel(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dlnrel
   end function dlnrel
end interface
!-----------------------------------------------------------------------
!     Computation of LN(gamma(b)/gamma(a+b)) for b .GE. 10
!                         --------
!     dlgdiv uses a series for the function DEL(x) where
!     LN(gamma(x)) = (x - 0.5)*LN(x) - x + 0.5*LN(2*PI) + DEL(x).
!     The series for del(x), which applies for x .GE. 10, was
!     derived by A.H. Morris from the Chebyshev series in the
!     SLATEC library obtained by Wayne Fullerton (Los Alamos).
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
if (a <= b) go to 10
h = b/a
c = 1.d0/(1.d0 + h)
x = h/(1.d0 + h)
d = a + (b - 0.5d0)
go to 20
10 h = a/b
c = h/(1.d0 + h)
x = 1.d0/(1.d0 + h)
d = b + (a - 0.5d0)
!        COMPUTE (1 - x**N)/(1 - x) FOR N = 1,3,5,...
!            Store these values in s(1),s(2),...
20 x2 = x*x
s(1) = 1.d0
do j = 1,14
   s(j + 1) = 1.d0 + (x + x2*s(j))
end do
!                SET w = DEL(b) - DEL(a + b)
t = (10.d0/b)**2
w = e(15)*s(15)
do j = 1,14
   k = 15 - j
   w = t*w + e(k)*s(k)
end do
w = w*(c/b)
!                    Combine the results
u = d*dlnrel(a/b)
v = a*(log(b) - 1.d0)
if (u <= v) go to 40
dlgdiv = (w - v) - u
return
40 dlgdiv = (w - u) - v
end function dlgdiv

pure elemental subroutine gratio(a, x, ans, qans, ind)
implicit none
integer, intent(in) :: ind
real, intent(in) :: a
real, intent(inout) :: ans, qans
real, intent(in) :: x
integer :: i, iop, m, max, n, nswc_ai_i4
real :: a2n, a2nm1, acc, amn, apn, b2n, b2nm1, c, c0, c1, c2, c3, c4, c5, c6, c7, c8, e, g, h, r, rta, rtx, s, sum, t, tol, twoa, &
   & u, w, y, z, j, l, wk(20)
real, parameter :: acc0(3) = [5.e-15, 5.e-7, 5.e-4]
real, parameter :: big(3) = [25.0, 14.0, 10.0]
real, parameter :: e0(3) = [.25e-3, .25e-1, .14]
real, parameter :: x0(3) = [31.0, 17.0, 9.7]
real, parameter :: alog10 = 2.30258509299405
real, parameter :: rt2pin = .398942280401433
real, parameter :: rtpi = 1.77245385090552
real, parameter :: a0(4) = [-.231272501940775e-02, -.335378520024220e-01, -.159840143443990e+00, -.333333333333333e+00]
real, parameter :: b0(6) = [.633763414209504e-06, -.939001940478355e-05, .239521354917408e-02, .376245718289389e-01, &
   & .238549219145773e+00, .729520430331981e+00]
real, parameter :: a1(4) = [-.398783924370770e-05, -.587926036018402e-03, -.491687131726920e-02, -.185185185184291e-02]
real, parameter :: b1(4) = [.386325038602125e-02, .506042559238939e-01, .283344278023803e+00, .780110511677243e+00]
real, parameter :: a2(2) = [.669564126155663e-03, .413359788442192e-02]
real, parameter :: b2(5) = [-.421924263980656e-03, .650837693041777e-02, .682034997401259e-01, .339173452092224e+00, &
   & .810647620703045e+00]
real, parameter :: a3(2) = [.810586158563431e-03, .649434157619770e-03]
real, parameter :: b3(5) = [-.632276587352120e-03, .905375887385478e-02, .906610359762969e-01, .406288930253881e+00, &
   & .894800593794972e+00]
real, parameter :: a4(2) = [-.105014537920131e-03, -.861888301199388e-03]
real, parameter :: b4(4) = [.322609381345173e-01, .178295773562970e+00, .591353097931237e+00, .103151890792185e+01]
real, parameter :: a5(2) = [-.435211415445014e-03, -.336806989710598e-03]
real, parameter :: b5(3) = [.178716720452422e+00, .600380376956324e+00, .108515217314415e+01]
real, parameter :: a6(2) = [-.182503596367782e-03, .531279816209452e-03]
real, parameter :: b6(2) = [.345608222411837e+00, .770341682526774e+00]
real, parameter :: a7(2) = [.443219646726422e-03, .344430064306926e-03]
real, parameter :: b7(2) = [.821824741357866e+00, .115029088777769e+01]
real, parameter :: a8(2) = [.878371203603888e-03, -.686013280418038e-03]
real, parameter :: d00 = -.333333333333333e+00
real, parameter :: d0(6) = [.833333333333333e-01, -.148148148148148e-01, .115740740740741e-02, .352733686067019e-03, - &
   & .178755144032922e-03, .391926317852244e-04]
real, parameter :: d10 = -.185185185185185e-02
real, parameter :: d1(4) = [-.347222222222222e-02, .264550264550265e-02, -.990226337448560e-03, .205761316872428e-03]
real, parameter :: d20 = .413359788359788e-02
real, parameter :: d2(2) = [-.268132716049383e-02, .771604938271605e-03]
real, parameter :: d30 = .649434156378601e-03
real, parameter :: d3(2) = [.229472093621399e-03, -.469189494395256e-03]
real, parameter :: d40 = -.861888290916712e-03
real, parameter :: d4(1) = [.784039221720067e-03]
real, parameter :: d50 = -.336798553366358e-03
real, parameter :: d5(1) = [-.697281375836586e-04]
real, parameter :: d60 = .531307936463992e-03
real, parameter :: d6(1) = [-.592166437353694e-03]
real, parameter :: d70 = .344367606892378e-03
real, parameter :: d80 = -.652623918595309e-03
interface
   pure elemental function erfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      real, intent(in) :: x
      real :: erfc1
   end function erfc1
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
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
   pure elemental function rlog(x)
      implicit none
      real, intent(in) :: x
      real :: rlog
   end function rlog
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!        Evaluation of the incomplete gamma ratio functions
!                      P(a,x) AND Q(a,x)
!                        ----------
!     It is assumed that A and x are nonnegative, where A and x
!     are not both 0.
!     Ans and qans are variables. gratio assigns ans the value
!     P(a,x) and qans the value Q(a,x). Ind may be any integer.
!     If ind = 0 Then the user is requesting as much accuracy as
!     possible (up to 14 significant digits). Otherwise, if
!     ind = 1 Then accuracy is requested to within 1 unit of the
!     6-TH significant digit, and if ind .NE. 0,1 then accuracy
!     is requested to within 1 unit of the 3RD significant digit.
!     Error return ...
!        ans is assigned the value 2 when A or x is negative,
!     when a*x = 0, or when P(a,x) and Q(a,x) are indeterminant.
!     P(a,x) and Q(a,x) are computationally indeterminant when
!     x is exceedingly close to A and A is extremely large.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!     revised ... DEC 1991
!-------------------------
!-------------------------
!-------------------------
!     alog10 = ln(10)
!     rt2pin = 1/sqrt(2*pi)
!     rtpi   = sqrt(pi)
!-------------------------
!-------------------------
!             Coefficients for minimax approximations
!                          FOR c0,...,C8
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!              Coefficients for the Temme expansion
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!     ****** E is a machine dependent constant. E is the smallest
!            floating point number for which 1.0 + E .GT. 1.0 .
e = spmpar(1)
!-------------------------
if (a < 0.0 .or. x < 0.0) go to 400
if (a == 0.0 .and. x == 0.0) go to 400
if (a*x == 0.0) go to 331
iop = ind + 1
if (iop /= 1 .and. iop /= 2) iop = 3
acc = amax1(acc0(iop),e)
!            Select the appropriate algorithm
if (a >= 1.0) go to 10
if (a == 0.5) go to 320
if (x < 1.1) go to 110
r = rcomp(a,x)
if (r == 0.0) go to 310
go to 170
10 if (a >= big(iop)) go to 20
if (a > x .or. x >= x0(iop)) go to 30
twoa = a + a
m = int(twoa)
if (twoa /= float(m)) go to 30
i = m/2
if (a == float(i)) go to 140
go to 150
20 l = x/a
if (l == 0.0) go to 300
s = 0.5 + (0.5 - l)
z = rlog(l)
if (z >= 700.0/a) go to 330
y = a*z
rta = sqrt(a)
if (abs(s) <= e0(iop)/rta) go to 250
if (abs(s) <= 0.4) go to 200
30 r = rcomp(a,x)
if (r == 0.0) go to 331
if (x <= amax1(a,alog10)) go to 50
if (x < x0(iop)) go to 170
go to 80
!                 Taylor series for P/R
50 apn = a + 1.0
t = x/apn
wk(1) = t
do n = 2,20
   apn = apn + 1.0
   t = t*(x/apn)
   if (t <= 1.e-3) go to 60
   wk(n) = t
end do
n = 20
60 sum = t
tol = 0.5*acc
61 apn = apn + 1.0
t = t*(x/apn)
sum = sum + t
if (t > tol) go to 61
max = n - 1
do m = 1,max
   n = n - 1
   sum = sum + wk(n)
end do
ans = (r/a)*(1.0 + sum)
qans = 0.5 + (0.5 - ans)
return
!                 Asymptotic expansion
80 amn = a - 1.0
t = amn/x
wk(1) = t
do n = 2,20
   amn = amn - 1.0
   t = t*(amn/x)
   if (abs(t) <= 1.e-3) go to 90
   wk(n) = t
end do
n = 20
90 sum = t
91 if (abs(t) < acc) go to 100
amn = amn - 1.0
t = t*(amn/x)
sum = sum + t
go to 91
100 max = n - 1
do m = 1,max
   n = n - 1
   sum = sum + wk(n)
end do
qans = (r/x)*(1.0 + sum)
ans = 0.5 + (0.5 - qans)
return
!             Taylor series for P(a,x)/x**a
110 l = 3.0
c = x
sum = x/(a + 3.0)
tol = 3.0*acc/(a + 1.0)
111 l = l + 1.0
c = -c*(x/l)
t = c/(a + l)
sum = sum + t
if (abs(t) > tol) go to 111
j = a*x*((sum/6.0 - 0.5/(a + 2.0))*x + 1.0/(a + 1.0))
z = a*log(x)
h = gam1(a)
g = 1.0 + h
if (x < 0.25) go to 120
if (a < x/2.59) go to 135
go to 130
120 if (z > -.13394) go to 135
130 w = exp(z)
ans = w*g*(0.5 + (0.5 - j))
qans = 0.5 + (0.5 - ans)
return
135 l = rexp(z)
w = 0.5 + (0.5 + l)
qans = (w*j - l)*g - h
if (qans < 0.0) go to 310
ans = 0.5 + (0.5 - qans)
return
!             Finite sums for Q when a .GE. 1
!                 and 2*a is an integer
140 sum = exp(-x)
t = sum
n = 1
c = 0.0
go to 160
150 rtx = sqrt(x)
sum = erfc1(0,rtx)
t = exp(-x)/(rtpi*rtx)
n = 0
c = -0.5
160 if (n == i) go to 161
n = n + 1
c = c + 1.0
t = (x*t)/c
sum = sum + t
go to 160
161 qans = sum
ans = 0.5 + (0.5 - qans)
return
!              Continued fraction expansion
170 tol = amax1(8.0*e,4.0*acc)
a2nm1 = 1.0
a2n = 1.0
b2nm1 = x
b2n = x + (1.0 - a)
c = 1.0
180 a2nm1 = x*a2n + c*a2nm1
b2nm1 = x*b2n + c*b2nm1
c = c + 1.0
t = c - a
a2n = a2nm1 + t*a2n
b2n = b2nm1 + t*b2n
a2nm1 = a2nm1/b2n
b2nm1 = b2nm1/b2n
a2n = a2n/b2n
b2n = 1.0
if (abs(a2n - a2nm1/b2nm1) >= tol*a2n) go to 180
qans = r*a2n
ans = 0.5 + (0.5 - qans)
return
200 if (abs(s) <= 2.0*e .and. a*e*e > 3.28e-3) go to 400
c = exp(-y)
w = 0.5*erfc1(1,sqrt(y))
u = 1.0/a
z = sqrt(z + z)
if (l < 1.0) z = -z
nswc_ai_i4 = iop - 2
if ( nswc_ai_i4 < 0 ) go to 210
if ( nswc_ai_i4 == 0 ) go to 220
go to 230
210 if (abs(s) <= 1.e-3) go to 260
!            Using the minimax approximations
c0 = (((a0(1)*z + a0(2))*z + a0(3))*z + a0(4)) / ((((((b0(1)*z + &
   & b0(2))*z + b0(3))*z + b0(4))*z + b0(5))*z + b0(6))*z + 1.0)
c1 = (((a1(1)*z + a1(2))*z + a1(3))*z + a1(4)) / &
   & ((((b1(1)*z + b1(2))*z + b1(3))*z + b1(4))*z + 1.0)
c2 = (a2(1)*z + a2(2))/(((((b2(1)*z + b2(2))*z + b2(3))*z + &
   & b2(4))*z + b2(5))*z + 1.0)
c3 = (a3(1)*z + a3(2))/(((((b3(1)*z + b3(2))*z + b3(3))*z + &
   & b3(4))*z + b3(5))*z + 1.0)
c4 = (a4(1)*z + a4(2))/((((b4(1)*z + b4(2))*z + b4(3))*z + &
   & b4(4))*z + 1.0)
c5 = (a5(1)*z + a5(2))/(((b5(1)*z + b5(2))*z + b5(3))*z + 1.0)
c6 = (a6(1)*z + a6(2))/((b6(1)*z + b6(2))*z + 1.0)
c7 = (a7(1)*z + a7(2))/((b7(1)*z + b7(2))*z + 1.0)
c8 = a8(1)*z + a8(2)
t = (((((((c8*u + c7)*u + c6)*u + c5)*u + c4)*u + c3)*u + &
   & c2)*u + c1)*u + c0
go to 240
!                    Temme expansion
220 c0 = (((((d0(6) * z + d0(5)) * z + d0(4)) * z + d0(3)) * z &
   & + d0(2)) * z + d0(1)) * z + d00
c1 = (((d1(4) * z + d1(3)) * z + d1(2)) * z + d1(1)) * z &
   & + d10
c2 = d2(1) * z + d20
t = (c2*u + c1)*u + c0
go to 240
230 t = ((d0(3) * z + d0(2)) * z + d0(1)) * z + d00
240 if (l < 1.0) go to 241
qans = c*(w + rt2pin*t/rta)
ans = 0.5 + (0.5 - qans)
return
241 ans = c*(w - rt2pin*t/rta)
qans = 0.5 + (0.5 - ans)
return
!               TEMME EXPANSION FOR l = 1
250 if (a*e*e > 3.28e-3) go to 400
c = 0.5 + (0.5 - y)
w = (0.5 - sqrt(y)*(0.5 + (0.5 - y/3.0))/rtpi)/c
u = 1.0/a
z = sqrt(z + z)
if (l < 1.0) z = -z
nswc_ai_i4 = iop - 2
if ( nswc_ai_i4 < 0 ) go to 260
if ( nswc_ai_i4 == 0 ) go to 270
go to 280
260 c0 = ((d0(3) * z + d0(2)) * z + d0(1)) * z + d00
c1 = ((d1(3) * z + d1(2)) * z + d1(1)) * z + d10
c2 = (d2(2) * z + d2(1)) * z + d20
c3 = (d3(2) * z + d3(1)) * z + d30
c4 = d4(1) * z + d40
c5 = d5(1) * z + d50
c6 = d6(1) * z + d60
t = (((((((d80*u + d70)*u + c6)*u + c5)*u + c4)*u + c3)*u &
   & + c2)*u + c1)*u + c0
go to 240
270 c0 = (d0(2) * z + d0(1)) * z + d00
c1 = d1(1) * z + d10
t = (d20*u + c1)*u + c0
go to 240
280 t = d0(1) * z + d00
go to 240
!                     Special cases
300 ans = 0.0
qans = 1.0
return
310 ans = 1.0
qans = 0.0
return
320 if (x >= 0.25) go to 321
ans = erf(sqrt(x))
qans = 0.5 + (0.5 - ans)
return
321 qans = erfc1(0,sqrt(x))
ans = 0.5 + (0.5 - qans)
return
330 if (abs(s) <= 2.0*e) go to 400
331 if (x <= a) go to 300
go to 310
!                     Error return
400 ans = 2.0
end subroutine gratio

pure elemental real function rcomp(a, x)
implicit none
real, intent(in) :: a, x
real :: t, t1, u
real, parameter :: rt2pin = .398942280401433
interface
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental function rlog(x)
      implicit none
      real, intent(in) :: x
      real :: rlog
   end function rlog
end interface
!-----------------------------------------------------------------------
!                Evaluation of exp(-x)*x**a/gamma(a)
!-----------------------------------------------------------------------
!     rt2pin = 1/sqrt(2*pi)
!------------------------
!------------------------
rcomp = 0.0
if (x == 0.0) return
if (a >= 20.0) go to 20
t = a*log(x) - x
if (t < exparg(1)) return
if (a >= 1.0) go to 10
rcomp = (a*exp(t))*(1.0 + gam1(a))
return
10 rcomp = exp(t)/gamma(a)
return
20 u = x/a
if (u == 0.0) return
t = (1.0/a)**2
t1 = (((0.75*t - 1.0)*t + 3.5)*t - 105.0)/(a*1260.0)
t1 = t1 - a*rlog(u)
if (t1 >= exparg(1)) rcomp = rt2pin*sqrt(a)*exp(t1)
end function rcomp

pure elemental double precision function drcomp(a, x)
implicit none
intrinsic :: gamma
!-----------------------------------------------------------------------
!              Evaluation of exp(-x)*x**a/gamma(a)
!-----------------------------------------------------------------------
double precision, intent(in) :: a, x
double precision :: t, w
double precision, parameter :: c = .398942280401432677939946059934d0
interface
   pure elemental function dgam1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgam1
   end function dgam1
   pure elemental function dpdel(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dpdel
   end function dpdel
   pure elemental function drlog(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: drlog
   end function drlog
   pure elemental function dxparg(l)
      implicit none
      integer, intent(in) :: l
      double precision :: dxparg
   end function dxparg
end interface
!--------------------------
!     c = 1/sqrt(2*pi)
!--------------------------
!--------------------------
drcomp = 0.d0
if (x == 0.d0) return
if (a > 20.d0) go to 20
t = a*log(x) - x
if (t < dxparg(1)) return
if (a >= 1.d0) go to 10
drcomp = (a*exp(t))*(1.d0 + dgam1(a))
return
10 drcomp = exp(t)/gamma(a)
return
20 t = x/a
if (t == 0.d0) return
w = -(dpdel(a) + a*drlog(t))
if (w >= dxparg(1)) drcomp = c * sqrt(a) * exp(w)
end function drcomp

pure elemental subroutine gaminv(a, x, x0, p, q, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: a, p, q
real, intent(out) :: x
real, intent(in) :: x0
integer :: ier, iop
real :: am1, amax, amin, ap1, ap2, ap3, apn, b, c1, c2, c3, c4, c5, d, e, e2, eps, g, h, pn, qg, qn, r, rta, s, s2, sum, t, u, w, &
   & xmin, xn, y, z
real, parameter :: ln10 = 2.302585
real, parameter :: c = .577215664901533
real, parameter :: bmin(2) = [1.e-28, 1.e-13]
real, parameter :: emin(2) = [2.e-03, 6.e-03]
real, parameter :: tol = 1.e-5
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function gamln(a)
      implicit none
      real, intent(in) :: a
      real :: gamln
   end function gamln
   pure elemental function gamln1(a)
      implicit none
      real, intent(in) :: a
      real :: gamln1
   end function gamln1
   pure elemental subroutine gratio(a,x,ans,qans,ind)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: x
      real, intent(inout) :: ans
      real, intent(inout) :: qans
      integer, intent(in) :: ind
   end subroutine gratio
   pure elemental subroutine pni(p,q,d,w,ierr)
      implicit none
      real, intent(in) :: p
      real, intent(in) :: q
      real, intent(in) :: d
      real, intent(inout) :: w
      integer, intent(inout) :: ierr
   end subroutine pni
   pure elemental function rcomp(a,x)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: x
      real :: rcomp
   end function rcomp
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!             Inverse incomplete gamma ratio function
!     given positive A, and NONEGATIVE p and q where p + q = 1.
!     Then x is computed where p(a,x) = p and q(a,x) = q. Schroder
!     iteration is employed. The routine attempts to compute x
!     to 10 significant digits if this is possible for the
!     particular computer arithmetic being used.
!                        ------------
!     x is a variable. If p = 0 Then x is assigned the value 0,
!     and if q = 0 Then x is set to the largest floating point
!     number available. Otherwise, gaminv attempts to obtain
!     a solution for p(a,x) = p and q(a,x) = q. if the routine
!     is successful then the solution is stored in x.
!     x0 is an optional initial approximation for x. if the user
!     does not wish to supply an initial approximation, then set
!     x0 .LE. 0.
!     ierr is a variable that reports the status of the results.
!     When the routine terminates, ierr has one of the following
!     values ...
!       ierr =  0    The solution was obtained. Iteration was
!                    not used.
!       ierr.GT.0    the solution was obtained. ierr iterations
!                    were performed.
!       ierr = -2    (INPUT ERROR) a .LE. 0
!       ierr = -3    No solution was obtained. The ratio q/a
!                    is too large.
!       ierr = -4    (INPUT ERROR) p OR q IS NEGATIVE, OR
!                    p + q .NE. 1.
!       ierr = -6    20 iterations were performed. The most
!                    recent value obtained for x is given.
!                    This cannot occur if x0 .LE. 0.
!       ierr = -7    Iteration failed. No value is given for x.
!                    This may occur when x is approximately 0.
!       ierr = -8    A value for x has been obtained, but the
!                    routine is not certain of its accuracy.
!                    Iteration cannot be performed in this
!                    case. If x0 .LE. 0, this can occur only
!                    when p or q is approximately 0. If x0 is
!                    positive then this can occur when A is
!                    exceedingly close to x and A is extremely
!                    LARGE (SAY a .GE. 1.E20).
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!     revised ... January 1992
!------------------------
!------------------------
!     ln10 = ln(10)
!     c = Euler constant
!------------------------
!------------------------
!------------------------
!------------------------
!     ****** E and xmin are machine dependent constants. E is the
!            smallest number for which 1.0 + E .GT. 1.0, and xmin
!            is the smallest positive number.
e = spmpar(1)
xmin = spmpar(2)
!------------------------
x = 0.0
if (a <= 0.0) go to 500
if (p < 0.0 .or. q < 0.0) go to 520
t = ((p + q) - 0.5) - 0.5
if (abs(t) > 5.0*max(e,1.e-15)) go to 520
ierr = 0
xmin = xmin/e
if ((p/e) <= xmin) go to 400
if ((q/e) <= xmin) go to 560
if (a == 1.0) go to 410
e2 = e + e
amax = 0.4e-10/(e*e)
eps = max(100.0*e,1.e-10)
iop = 1
if (e > 1.e-10) iop = 2
xn = x0
if (x0 > 0.0) go to 100
!        Selection of the initial approximation XN of x
!                       WHEN a .LT. 1
if (a > 1.0) go to 50
g = gamma(a + 1.0)
qg = q*g
if (qg == 0.0) go to 560
b = qg/a
if (qg > 0.6*a) go to 20
if (a >= 0.30 .or. b < 0.35) go to 10
t = exp(-(b + c))
u = t*exp(t)
xn = t*exp(u)
go to 100
10 if (b >= 0.45) go to 20
if (b == 0.0) go to 560
y = -log(b)
s = 0.5 + (0.5 - a)
z = log(y)
t = y - s*z
if (b < 0.15) go to 11
xn = y - s*log(t) - log(1.0 + s/(t + 1.0))
go to 200
11 if (b <= 1.e-2) go to 12
u = ((t + 2.0*(3.0 - a))*t + (2.0 - a)*(3.0 - a))/ &
   & ((t + (5.0 - a))*t + 2.0)
xn = y - s*log(t) - log(u)
go to 200
12 c1 = -s*z
c2 = -s*(1.0 + c1)
c3 = s*((0.5*c1 + (2.0 - a))*c1 + (2.5 - 1.5*a))
c4 = -s*(((c1/3.0 + (2.5 - 1.5*a))*c1 + ((a - 6.0)*a + 7.0))*c1 &
   & + ((11.0*a - 46.0)*a + 47.0)/6.0)
c5 = -s*((((-c1/4.0 + (11.0*a - 17.0)/6.0)*c1 &
   & + ((-3.0*a + 13.0)*a - 13.0))*c1 &
   & + 0.5*(((2.0*a - 25.0)*a + 72.0)*a - 61.0))*c1 &
   & + (((25.0*a - 195.0)*a + 477.0)*a - 379.0)/12.0)
xn = ((((c5/y + c4)/y + c3)/y + c2)/y + c1) + y
if (a > 1.0) go to 200
if (b > bmin(iop)) go to 200
x = xn
return
20 if (b*q > 1.e-8) go to 21
xn = exp(-(q/a + c))
go to 30
21 if (p <= 0.9) go to 22
xn = exp((alnrel(-q) + gamln1(a))/a)
go to 30
22 xn = exp(log(p*g)/a)
30 if (xn == 0.0) go to 510
t = 0.5 + (0.5 - xn/(a + 1.0))
xn = xn/t
go to 100
!        Selection of the initial approximation XN of x
!                       WHEN a .GT. 1
50 t = p - 0.5
if (q < 0.5) t = 0.5 - q
call pni(p, q, t, s, ier)
rta = sqrt(a)
s2 = s*s
xn = (((12.0*s2 - 243.0)*s2 - 923.0)*s2 + 1472.0)/204120.0
xn = (xn/a + s*((9.0*s2 + 256.0)*s2 - 433.0)/(38880.0*rta)) &
   & - ((3.0*s2 + 7.0)*s2 - 16.0)/810.0
xn = a + s*rta + (s2 - 1.0)/3.0 + s*(s2 - 7.0)/(36.0*rta) &
   & + xn/a
xn = max(xn, 0.0)
amin = 20.0
if (e < 1.e-8) amin = 250.0
if (a < amin) go to 60
x = xn
d = 0.5 + (0.5 - x/a)
if (abs(d) <= 1.e-1) return
60 if (p <= 0.5) go to 70
if (xn < 3.0*a) go to 200
w = log(q)
y = -(w + gamln(a))
d = max(2.0, a*(a - 1.0))
if (y < ln10*d) go to 61
s = 1.0 - a
z = log(y)
go to 12
61 t = a - 1.0
xn = y + t*log(xn) - alnrel(-t/(xn + 1.0))
xn = y + t*log(xn) - alnrel(-t/(xn + 1.0))
go to 200
70 ap1 = a + 1.0
if (xn > 0.70*ap1) go to 101
w = log(p) + gamln(ap1)
if (xn > 0.15*ap1) go to 80
ap2 = a + 2.0
ap3 = a + 3.0
x = exp((w + x)/a)
x = exp((w + x - log(1.0 + (x/ap1)*(1.0 + x/ap2)))/a)
x = exp((w + x - log(1.0 + (x/ap1)*(1.0 + x/ap2)))/a)
x = exp((w + x - log(1.0 + (x/ap1)*(1.0 + (x/ap2)*(1.0 &
   & + x/ap3))))/a)
xn = x
if (xn > 1.e-2*ap1) go to 80
if (xn <= emin(iop)*ap1) return
go to 101
80 apn = ap1
t = xn/apn
sum = 1.0 + t
81 apn = apn + 1.0
t = t*(xn/apn)
sum = sum + t
if (t > 1.e-4) go to 81
t = w - log(sum)
xn = exp((xn + t)/a)
xn = xn*(1.0 - (a*log(xn) - xn - t)/(a - xn))
go to 101
!                 Schroder iteration using p
100 if (p > 0.5) go to 200
101 if (p <= xmin) go to 550
am1 = (a - 0.5) - 0.5
102 if (a <= amax) go to 110
d = 0.5 + (0.5 - xn/a)
if (abs(d) <= e2) go to 550
110 if (ierr >= 20) go to 530
ierr = ierr + 1
call gratio(a, xn, pn, qn, 0)
if (pn == 0.0 .or. qn == 0.0) go to 550
r = rcomp(a,xn)
if (r < xmin) go to 550
t = (pn - p)/r
w = 0.5*(am1 - xn)
if (abs(t) <= 0.1 .and. abs(w*t) <= 0.1) go to 120
x = xn*(1.0 - t)
if (x <= 0.0) go to 540
d = abs(t)
go to 121
120 h = t*(1.0 + w*t)
x = xn*(1.0 - h)
if (x <= 0.0) go to 540
if (abs(w) >= 1.0 .and. abs(w)*t*t <= eps) return
d = abs(h)
121 xn = x
if (d > tol) go to 102
if (d <= eps) return
if (abs(p - pn) <= tol*p) return
go to 102
!                 Schroder iteration using q
200 if (q <= xmin) go to 550
am1 = (a - 0.5) - 0.5
201 if (a <= amax) go to 210
d = 0.5 + (0.5 - xn/a)
if (abs(d) <= e2) go to 550
210 if (ierr >= 20) go to 530
ierr = ierr + 1
call gratio(a, xn, pn, qn, 0)
if (pn == 0.0 .or. qn == 0.0) go to 550
r = rcomp(a,xn)
if (r < xmin) go to 550
t = (q - qn)/r
w = 0.5*(am1 - xn)
if (abs(t) <= 0.1 .and. abs(w*t) <= 0.1) go to 220
x = xn*(1.0 - t)
if (x <= 0.0) go to 540
d = abs(t)
go to 221
220 h = t*(1.0 + w*t)
x = xn*(1.0 - h)
if (x <= 0.0) go to 540
if (abs(w) >= 1.0 .and. abs(w)*t*t <= eps) return
d = abs(h)
221 xn = x
if (d > tol) go to 201
if (d <= eps) return
if (abs(q - qn) <= tol*q) return
go to 201
!                       Special cases
400 ierr = -8
return
410 if (q < 0.9) go to 411
x = -alnrel(-p)
return
411 x = -log(q)
return
!                       Error return
500 ierr = -2
return
510 ierr = -3
return
520 ierr = -4
return
530 ierr = -6
return
540 ierr = -7
return
550 x = xn
ierr = -8
return
560 x = spmpar(3)
ierr = -8
end subroutine gaminv

pure elemental subroutine dgrat(a, x, ans, qans, ierr)
implicit none
intrinsic :: erf
integer, intent(inout) :: ierr
double precision, intent(in) :: a, x
double precision, intent(inout) :: ans, qans
integer :: i, m, max, n
double precision :: amn, apn, a2n, a2nm1, big, b2n, b2nm1, c, e, g, h, j, l, r, rta, rtx, s, sum, t, tol, twoa, u, x0, y, z, wk(20)
double precision, parameter :: alog10 = 2.30258509299404568401799145468d0
double precision, parameter :: rtpi = 1.77245385090551602729816748334d0
interface
   pure elemental function derfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      double precision, intent(in) :: x
      double precision :: derfc1
   end function derfc1
   pure elemental function dgam1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgam1
   end function dgam1
   pure elemental subroutine dgr17(a,y,l,z,rta,ans,qans)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: y
      double precision, intent(in) :: l
      double precision, intent(inout) :: z
      double precision, intent(in) :: rta
      double precision, intent(inout) :: ans
      double precision, intent(inout) :: qans
   end subroutine dgr17
   pure elemental subroutine dgr29(a,y,l,z,rta,ans,qans)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: y
      double precision, intent(in) :: l
      double precision, intent(inout) :: z
      double precision, intent(in) :: rta
      double precision, intent(inout) :: ans
      double precision, intent(inout) :: qans
   end subroutine dgr29
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function drcomp(a,x)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: x
      double precision :: drcomp
   end function drcomp
   pure elemental function drexp(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: drexp
   end function drexp
   pure elemental function drlog(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: drlog
   end function drlog
end interface
!-----------------------------------------------------------------------
!        Evaluation of the incomplete gamma ratio functions
!                      P(a,x) AND Q(a,x)
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!     revised ... jan 1992
!-------------------------
!-------------------------
!     alog10 = ln(10)
!     rtpi   = dsqrt(pi)
!-------------------------
!-------------------------
!     ****** E is a machine dependent constant. E is the smallest
!            floating point number for which 1.0 + E .GT. 1.0 .
e = dpmpar(1)
!-------------------------
if (a < 0.d0 .or. x < 0.d0) go to 400
if (a == 0.d0 .and. x == 0.d0) go to 410
ierr = 0
if (a*x == 0.d0) go to 331
e = dmax1(e,1.d-30)
big = 30.d0
if (e < 1.d-17) big = 50.d0
x0 = 45.d0
if (e < 1.d-17) x0 = 68.d0
!            Select the appropriate algorithm
if (a >= 1.d0) go to 10
if (a == 0.5d0) go to 320
if (x <= 2.d0) go to 110
r = drcomp(a,x)
if (r == 0.d0) go to 310
go to 170
10 if (a >= big) go to 20
if (a > x .or. x >= x0) go to 30
twoa = a + a
m = twoa
l = m
if (twoa /= l) go to 30
i = m/2
l = i
if (a == l) go to 140
go to 150
20 l = x/a
if (l == 0.d0) go to 300
s = 0.5d0 + (0.5d0 - l)
z = drlog(l)
if (z >= 700.d0/a) go to 330
y = a*z
rta = sqrt(a)
if (abs(s) <= 0.4d0) go to 200
30 r = drcomp(a,x)
if (r == 0.d0) go to 331
if (x <= dmax1(a,alog10)) go to 50
if (x < x0) go to 170
go to 80
!                 Taylor series for P/R
50 apn = a + 1.d0
t = x/apn
wk(1) = t
do n = 2,20
   apn = apn + 1.d0
   t = t*(x/apn)
   if (t < 1.d-3) go to 60
   wk(n) = t
end do
n = 20
60 sum = t
tol = 0.5d0*e
61 apn = apn + 1.d0
t = t*(x/apn)
sum = sum + t
if (t > tol) go to 61
max = n - 1
do m = 1,max
   n = n - 1
   sum = sum + wk(n)
end do
ans = (r/a)*(1.d0 + sum)
qans = 0.5d0 + (0.5d0 - ans)
return
!                 Asymptotic expansion
80 amn = a - 1.d0
t = amn/x
wk(1) = t
do n = 2,20
   amn = amn - 1.d0
   t = t*(amn/x)
   if (abs(t) <= 1.d-3) go to 90
   wk(n) = t
end do
n = 20
90 sum = t
91 if (abs(t) < e) go to 100
amn = amn - 1.d0
t = t*(amn/x)
sum = sum + t
go to 91
100 max = n - 1
do m = 1,max
   n = n - 1
   sum = sum + wk(n)
end do
qans = (r/x)*(1.d0 + sum)
ans = 0.5d0 + (0.5d0 - qans)
return
!             Taylor series for P(a,x)/x**a
110 l = 3.d0
c = x
sum = x/(a + 3.d0)
tol = 3.d0*e/(a + 1.d0)
120 l = l + 1.d0
c = -c*(x/l)
t = c/(a + l)
sum = sum + t
if (abs(t) > tol) go to 120
j = a*x*((sum/6.d0 - 0.5d0/(a + 2.d0))*x + 1.d0/(a + 1.d0))
z = a*log(x)
u = exp(z)
h = dgam1(a)
g = 1.d0 + h
ans = u*g*(0.5d0 + (0.5d0 - j))
qans = 0.5d0 + (0.5d0 - ans)
if (ans <= 0.9d0) return
l = drexp(z)
qans = (u*j - l)*g - h
if (qans <= 0.d0) go to 310
ans = 0.5d0 + (0.5d0 - qans)
return
!             Finite sums for Q when a .GE. 1
!                 and 2*a is an integer
140 sum = exp(-x)
t = sum
n = 1
c = 0.d0
go to 160
150 rtx = sqrt(x)
sum = derfc1(0,rtx)
t = exp(-x)/(rtpi*rtx)
n = 0
c = -0.5d0
160 if (n == i) go to 161
n = n + 1
c = c + 1.d0
t = (x*t)/c
sum = sum + t
go to 160
161 qans = sum
ans = 0.5d0 + (0.5d0 - qans)
return
!              Continued fraction expansion
170 tol = 8.d0*e
a2nm1 = 1.d0
a2n = 1.d0
b2nm1 = x
b2n = x + (1.d0 - a)
c = 1.d0
180 a2nm1 = x*a2n + c*a2nm1
b2nm1 = x*b2n + c*b2nm1
c = c + 1.d0
t = c - a
a2n = a2nm1 + t*a2n
b2n = b2nm1 + t*b2n
a2nm1 = a2nm1/b2n
b2nm1 = b2nm1/b2n
a2n = a2n/b2n
b2n = 1.d0
if (abs(a2n - a2nm1/b2nm1) >= tol*a2n) go to 180
qans = r*a2n
ans = 0.5d0 + (0.5d0 - qans)
return
!                 Minimax approximations
200 if (abs(s) <= 2.d0*e .and. a*e*e > 3.28d-3) go to 420
if (e < 1.d-17) go to 210
call dgr17(a, y, l, z, rta, ans, qans)
return
210 call dgr29(a, y, l, z, rta, ans, qans)
return
!                     Special cases
300 ans = 0.d0
qans = 1.d0
return
310 ans = 1.d0
qans = 0.d0
return
320 if (x >= 0.25d0) go to 321
ans = erf(sqrt(x))
qans = 0.5d0 + (0.5d0 - ans)
return
321 qans = derfc1(0,sqrt(x))
ans = 0.5d0 + (0.5d0 - qans)
return
330 if (abs(s) <= 2.d0*e) go to 420
331 if (x <= a) go to 300
go to 310
!                     Error return
400 ierr = 1
ans = 2.d0
return
410 ierr = 2
ans = 2.d0
return
420 ierr = 3
ans = 2.d0
end subroutine dgrat

pure elemental subroutine dgr29(a, y, l, z, rta, ans, qans)
implicit none
!-----------------------------------------------------------------------
!            Algorithm using minimax approximations
!-----------------------------------------------------------------------
double precision, intent(in) :: a, y, l
double precision, intent(inout) :: z
double precision, intent(in) :: rta
double precision, intent(inout) :: ans, qans
double precision :: c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, e, t, u, w
double precision, parameter :: rt2pin = .398942280401432677939946059934d0
double precision, parameter :: d0(7) = [-.333333333333333333333333333333d+00, &
   & .833333333333333333333333333333d-01, -.148148148148148148148148148148d-01, .115740740740740740740740740741d-02, &
   & .352733686067019400352733686067d-03, -.178755144032921810699588477366d-03, .391926317852243778169704095630d-04]
double precision, parameter :: a0(7) = [-.234443848930188413698825870d-08, -.408902435641223939887180303d-07, &
   & -.327874000161065050049103731d-06, -.145717031728609218851588740d-05, -.372722892959910688597417881d-05, - &
   & .490033281596113358850307112d-05, -.218544851067999216147364227d-05]
double precision, parameter :: b0(9) = [-.129786815987713980865910767d-09, .319268409139858531586963150d-08, &
   & .597739416777031660496708557d-04, .131659965062389880196860991d-02, .138263099503103838517015533d-01, &
   & .866750030433403450681521877d-01, .349373447613102956696810725d+00, .902581259032419042347458484d+00, &
   & .139388806936391316154237713d+01]
double precision, parameter :: a1(7) = [-.162671127226300802902860047d-05, -.359791514993122440319624428d-04, &
   & -.334816794629374699945489443d-03, -.167787748352827199882047653d-02, -.462960105006279850867332060d-02, - &
   & .627269388216833251971110268d-02, -.185185185185185185185185200d-02]
double precision, parameter :: b1(9) = [.361538770500640888027927000d-09, .974094440943696092434381137d-05, &
   & .275463718595762102271929980d-03, .356903970692700621824901511d-02, .276755209895072417713430394d-01, &
   & .140741499324744724262767201d+00, .482173396010404307346794795d+00, .109307843990990308990473663d+01, &
   & .151225469637089956064399494d+01]
double precision, parameter :: a2(7) = [.100841467329617467204527243d-06, .261809837060522545971782889d-05, &
   & .351658023234640143803014403d-04, .287368655528567495658887760d-03, .138385867950361368914038461d-02, &
   & .365985331203490698463644329d-02, .413359788359788359788359644d-02]
double precision, parameter :: b2(8) = [.144996224602847932479320241d-04, .378705615967233119938297206d-03, &
   & .457258679387716305283282667d-02, .333036784835643463383606186d-01, .160392471625881407829191009d+00, &
   & .524238095721639512312120765d+00, .114320896084982707537755002d+01, .153405837991415136438992306d+01]
double precision, parameter :: a3(7) = [.352304123782956092061364635d-06, .695396758348887902366951353d-05, &
   & .620467118988901865955998784d-04, .331552280167649130371474456d-03, .987931909328964685388525477d-03, &
   & .141844584435355290321010006d-02, .649434156378600823045102236d-03]
double precision, parameter :: b3(8) = [.656342109234806261144233394d-04, .130398975231883219976260776d-02, &
   & .126418031281256648240652355d-01, .760733201461716525855765749d-01, .308149284260387354956024487d+00, &
   & .856743428738899911100227393d+00, .159678625605457556492814589d+01, .183078413578083710405050462d+01]
double precision, parameter :: a4(7) = [-.260879135093022176005540138d-07, -.470448694272734954500324169d-06, &
   & -.487392507564453824976295590d-05, -.337525643163070607393381432d-04, -.173138093150706317400323103d-03, - &
   & .619343030286408407629007048d-03, -.861888290916711698604710684d-03]
double precision, parameter :: b4(8) = [.561738585657138771286755470d-04, .104553622856827932853059322d-02, &
   & .990129468337836044520381371d-02, .590964360473404599955095091d-01, .241580582651643837306299024d+00, &
   & .686949677014349678482109368d+00, .133507902144433100426436242d+01, .162826466816694512158165085d+01]
double precision, parameter :: a5(7) = [-.116166342948098688243985652d-07, .506465072067030007394288471d-08, - &
   & .556701576804390213081214801d-05, -.332229941748769925615918550d-04, -.171902547619915856635305717d-03, - &
   & .548868487607991087508092013d-03, -.336798553366358151161633777d-03]
double precision, parameter :: b5(7) = [.106576106868815233442641444d-03, .280714123386276098548285440d-02, &
   & .254669201041872409738119341d-01, .136071713023783507468096673d+00, .462890328922621047510807887d+00, &
   & .103913867517817784825064299d+01, .142263185288429590449288300d+01]
double precision, parameter :: a6(4) = [.118384620224413424936260301d-04, .694345283181981060040314140d-05, &
   & .209213745619758030399432459d-03, .531307936463992224884286210d-03]
double precision, parameter :: b6(9) = [-.633002360430352916354621750d-05, -.248639208901374031411609873d-04, &
   & .151734058829700925162000373d-03, .477475914272399601740818883d-02, .384410125775084107229541456d-01, &
   & .184699876959596092801262547d+00, .571784440733980642101712125d+00, .118432122801495778365352945d+01, &
   & .150831585220968267709550582d+01]
double precision, parameter :: a7(5) = [.972342656522493967167788395d-05, .462793722775687016808279009d-04, &
   & .208913588225005764102252127d-03, .605983804794748515383615779d-03, .344367606892381545765962366d-03]
double precision, parameter :: b7(7) = [.215964480325937088444595990d-03, .621296161441756044580440529d-02, &
   & .497403555098433701440032746d-01, .230812334251394761909158355d+00, .682159830165959997577293001d+00, &
   & .133753662990343866552766613d+01, .160951809815647533045690195d+01]
double precision, parameter :: a8(5) = [-.231069438570167401077137510d-05, -.192877995065652524742879002d-04, &
   & -.282551884312564905942488077d-04, -.353272052089782073130912603d-03, -.652623918595320914510590273d-03]
double precision, parameter :: b8(7) = [.156052480203446255774109882d-02, .189231675289329563916597032d-01, &
   & .110127834209242088316741250d+00, .407929996207245634766606879d+00, .101702505946784412105505734d+01, &
   & .172269407630659768618234623d+01, .182765408802230546887514255d+01]
double precision, parameter :: a9(5) = [-.203007139532451428594124139d-04, -.120148495117517992204095691d-03, &
   & -.377126645910917006921076652d-03, -.109151697941931403194363814d-02, -.596761290192642722092337263d-03]
double precision, parameter :: b9(6) = [.108808775028021530146610124d-01, .803149717787956717154553908d-01, &
   & .335555306170768573903990019d+00, .881575022436158946373557744d+00, .156222230858412078350692234d+01, &
   & .170833470935668756293234818d+01]
double precision, parameter :: a10(4) = [.475862254251166503473724173d-04, -.352503880413640910997936559d-04, &
   & .580375987713106460207815603d-03, .133244544950730832649306319d-02]
double precision, parameter :: b10(6) = [.161103572271541189817119144d-01, .114651544043625219459951640d+00, &
   & .448280675300097555552484502d+00, .110810715319704031415255670d+01, .183146436130501918547134176d+01, &
   & .187235769169449339141968881d+01]
double precision, parameter :: a11(4) = [.121185049262809526794966703d-03, .717725173388339108430635016d-05, &
   & .246371734409638623215800502d-02, .157972766214718575927904484d-02]
double precision, parameter :: b11(5) = [.794610889405176143379963912d-02, .131627017265860324219513170d+00, &
   & .505939635317477779328000706d+00, .116082103318559904744144217d+01, .145670749780693850410866175d+01]
double precision, parameter :: a12(4) = [-.246294151509758620837749269d-03, .650624975008642297405944869d-03, &
   & -.214376520139497301154749750d-03, -.407251199495291398243480255d-02]
double precision, parameter :: b12(4) = [.168390445944818504703640731d+00, .653453590771198550320727688d+00, &
   & .140298208333879535577602171d+01, .162497775209192630951344224d+01]
double precision, parameter :: a13(3) = [-.159520095187034545391135461d-02, -.109727312966041723997078734d-01, &
   & -.594758070915055362667114240d-02]
double precision, parameter :: b13(4) = [.207815761771742289849225339d+00, .790935125477975506817064616d+00, &
   & .158706682625067673596619095d+01, .175409273929961597148916309d+01]
double precision, parameter :: a14(3) = [.245543970647383469794050102d-02, -.119636668153843644820445054d-01, &
   & .175722793448246103440764372d-01]
double precision, parameter :: b14(2) = [.676925518749829493412063599d+00, .100158659226079685399214158d+01]
double precision, parameter :: a15(2) = [.588261033368548917447688791d-01, .400765463491067514929787780d-01]
double precision, parameter :: b15(2) = [.124266359850901469771032599d+01, .149189509890654955611528542d+01]
double precision, parameter :: a16(2) = [.119522261141925960204472459d+00, -.100326700196947262548667584d+00]
double precision, parameter :: b16(1) = [.536462039767059451769400255d+00]
double precision, parameter :: a17(1) = [-.259949826752497731336860753d+00]
double precision, parameter :: a18(1) = [.724036968309299822373280436d+00]
interface
   pure elemental function derfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      double precision, intent(in) :: x
      double precision :: derfc1
   end function derfc1
end interface
!---------------------------
!     rt2pin = 1/dsqrt(2*pi)
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
!---------------------------
e = exp(-y)
w = 0.5d0*derfc1(1,sqrt(y))
u = 1.d0/a
z = sqrt(z + z)
if (l < 1.d0) z = -z
t = ((((((a0(1)*z + a0(2))*z + a0(3))*z + a0(4))*z + a0(5))*z + &
   & a0(6))*z + a0(7)) / (((((((((b0(1)*z + b0(2))*z + &
   & b0(3))*z + b0(4))*z + b0(5))*z + b0(6))*z + b0(7))*z + &
   & b0(8))*z + b0(9))*z + 1.d0)
c0 = ((((((t*z + d0(7))*z + d0(6))*z + d0(5))*z + d0(4))*z + &
   & d0(3))*z + d0(2))*z + d0(1)
c1 = ((((((a1(1)*z + a1(2))*z + a1(3))*z + a1(4))*z + a1(5))*z + &
   & a1(6))*z + a1(7)) / (((((((((b1(1)*z + b1(2))*z + &
   & b1(3))*z + b1(4))*z + b1(5))*z + b1(6))*z + b1(7))*z + &
   & b1(8))*z + b1(9))*z + 1.d0)
c2 = ((((((a2(1)*z + a2(2))*z + a2(3))*z + a2(4))*z + a2(5))*z + &
   & a2(6))*z + a2(7)) / ((((((((b2(1)*z + b2(2))*z + &
   & b2(3))*z + b2(4))*z + b2(5))*z + b2(6))*z + b2(7))*z + &
   & b2(8))*z + 1.d0)
c3 = ((((((a3(1)*z + a3(2))*z + a3(3))*z + a3(4))*z + a3(5))*z + &
   & a3(6))*z + a3(7)) / ((((((((b3(1)*z + b3(2))*z + &
   & b3(3))*z + b3(4))*z + b3(5))*z + b3(6))*z + b3(7))*z + &
   & b3(8))*z + 1.d0)
c4 = ((((((a4(1)*z + a4(2))*z + a4(3))*z + a4(4))*z + a4(5))*z + &
   & a4(6))*z + a4(7)) / ((((((((b4(1)*z + b4(2))*z + &
   & b4(3))*z + b4(4))*z + b4(5))*z + b4(6))*z + b4(7))*z + &
   & b4(8))*z + 1.d0)
c5 = ((((((a5(1)*z + a5(2))*z + a5(3))*z + a5(4))*z + a5(5))*z + &
   & a5(6))*z + a5(7)) / (((((((b5(1)*z + b5(2))*z + &
   & b5(3))*z + b5(4))*z + b5(5))*z + b5(6))*z + b5(7))*z + &
   & 1.d0)
c6 = (((a6(1)*z + a6(2))*z + a6(3))*z + a6(4)) /(((((((((b6(1)*z + &
   & b6(2))*z + b6(3))*z + b6(4))*z + b6(5))*z + b6(6))*z + &
   & b6(7))*z + b6(8))*z + b6(9))*z + 1.d0)
c7 = ((((a7(1)*z + a7(2))*z + a7(3))*z + a7(4))*z + a7(5)) / &
   & (((((((b7(1)*z + b7(2))*z + b7(3))*z + b7(4))*z + b7(5))*z + &
   & b7(6))*z + b7(7))*z + 1.d0)
c8 = ((((a8(1)*z + a8(2))*z + a8(3))*z + a8(4))*z + a8(5)) / &
   & (((((((b8(1)*z + b8(2))*z + b8(3))*z + b8(4))*z + b8(5))*z + &
   & b8(6))*z + b8(7))*z + 1.d0)
c9 = ((((a9(1)*z + a9(2))*z + a9(3))*z + a9(4))*z + a9(5)) / &
   & ((((((b9(1)*z + b9(2))*z + b9(3))*z + b9(4))*z + b9(5))*z + &
   & b9(6))*z + 1.d0)
c10 = (((a10(1)*z + a10(2))*z + a10(3))*z + a10(4)) / &
   & ((((((b10(1)*z + b10(2))*z + b10(3))*z + b10(4))*z + &
   & b10(5))*z + b10(6))*z + 1.d0)
c11 = (((a11(1)*z + a11(2))*z + a11(3))*z + a11(4)) / &
   & (((((b11(1)*z + b11(2))*z + b11(3))*z + b11(4))*z + &
   & b11(5))*z + 1.d0)
c12 = (((a12(1)*z + a12(2))*z + a12(3))*z + a12(4)) / &
   & ((((b12(1)*z + b12(2))*z + b12(3))*z + b12(4))*z + 1.d0)
c13 = ((a13(1)*z + a13(2))*z + a13(3)) / ((((b13(1)*z + &
   & b13(2))*z + b13(3))*z + b13(4))*z + 1.d0)
c14 = ((a14(1)*z + a14(2))*z + a14(3)) / ((b14(1)*z + &
   & b14(2))*z + 1.d0)
c15 = (a15(1)*z + a15(2)) / ((b15(1)*z + b15(2))*z + 1.d0)
c16 = (a16(1)*z + a16(2)) / (b16(1)*z + 1.d0)
t = (a18(1)*u + a17(1))*u + c16
t = (((((((((((((((t*u + c15)*u + c14)*u + c13)*u + c12)*u + &
   & c11)*u + c10)*u + c9)*u + c8)*u + c7)*u + c6)*u + &
   & c5)*u + c4)*u + c3)*u + c2)*u + c1)*u + c0
if (l < 1.d0) go to 10
qans = e*(w + rt2pin*t/rta)
ans = 0.5d0 + (0.5d0 - qans)
return
10 ans = e*(w - rt2pin*t/rta)
qans = 0.5d0 + (0.5d0 - ans)
end subroutine dgr29

pure elemental subroutine dgr17(a, y, l, z, rta, ans, qans)
implicit none
!-----------------------------------------------------------------------
!            Algorithm using minimax approximations
!                        FOR c0,...,c10
!-----------------------------------------------------------------------
double precision, intent(in) :: a, y, l
double precision, intent(inout) :: z
double precision, intent(in) :: rta
double precision, intent(inout) :: ans, qans
double precision :: e, t, u, w, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
double precision, parameter :: rt2pin = .398942280401432678d0
double precision, parameter :: a0(5) = [-.73324404807556026d-03, -.11758531313175796d-01, - &
   & .76816029947195974d-01, -.24232172943558393d+00, -.33333333333333333d+00]
double precision, parameter :: b0(6) = [.10555647473018528d-06, .73121701584237188d-03, .13250270182342259d-01 &
   & , .10288837674434487d+00, .43024494247383254d+00, .97696518830675185d+00]
double precision, parameter :: a1(4) = [-.16746784557475121d-03, -.16090334014223031d-02, - &
   & .52949366601406939d-02, -.18518518518518417d-02]
double precision, parameter :: b1(6) = [.12328086517283227d-05, .98671953445602142d-03, .15954049115266936d-01 &
   & , .11439610256504704d+00, .45195109694529839d+00, .98426579647613593d+00]
double precision, parameter :: a2(4) = [.12049855113125238d-04, .13743853858711134d-03, .15067356806896441d-02 &
   & , .41335978835983393d-02]
double precision, parameter :: b2(5) = [.15927093345670077d-02, .22316881460606523d-01, .14009848931638062d+00 &
   & , .50379606871703058d+00, .10131761625405203d+01]
double precision, parameter :: a3(4) = [.46318872971699924d-05, .13012396979747783d-04, .81804333975935872d-03 &
   & , .64943415637082551d-03]
double precision, parameter :: b3(4) = [.12414068921653593d-01, .10044290377295469d+00, .42226789458984594d+00 &
   & , .90628317147366376d+00]
double precision, parameter :: a4(3) = [-.37567394580525597d-05, -.82794205648271314d-04, - &
   & .86188829773520181d-03]
double precision, parameter :: b4(4) = [.31290397554562032d-01, .16988291247058802d+00, .57225859400072754d+00 &
   & , .10057375981227881d+01]
double precision, parameter :: a5(2) = [-.43263341886764011d-03, -.33679854644784478d-03]
double precision, parameter :: b5(4) = [.22714615451529335d-01, .17081504060220639d+00, .60019022026983067d+00 &
   & , .10775200414676195d+01]
double precision, parameter :: a6(2) = [-.12962670089753501d-03, .53130115408837152d-03]
double precision, parameter :: b6(3) = [.65929776650152292d-01, .45957439582639129d+00, .87058903334443855d+00]
double precision, parameter :: a7(2) = [.47861364421780889d-03, .34438428473168988d-03]
double precision, parameter :: b7(3) = [.27176241899664174d+00, .78991370162247144d+00, .12396875725833093d+01]
double precision, parameter :: a8(2) = [.27086391808339115d-03, -.65256615574219131d-03]
double precision, parameter :: b8(2) = [.44207055629598579d+00, .87002402612484571d+00]
double precision, parameter :: a9(3) = [.84725086921921823d-03, -.14838721516118744d-03, - &
   & .60335050249571475d-03]
double precision, parameter :: a10(2) = [-.19144384985654775d-02, .13324454494800656d-02]
interface
   pure elemental function derfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      double precision, intent(in) :: x
      double precision :: derfc1
   end function derfc1
end interface
!------------------------
!     rt2pin = 1/dsqrt(2*pi)
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
e = exp(-y)
w = 0.5d0*derfc1(1,sqrt(y))
u = 1.d0/a
z = sqrt(z + z)
if (l < 1.d0) z = -z
c0 = ((((a0(1)*z + a0(2))*z + a0(3))*z + a0(4))*z + a0(5)) / &
   & ((((((b0(1)*z + b0(2))*z + b0(3))*z + b0(4))*z + b0(5))*z + &
   & b0(6))*z + 1.d0)
c1 = (((a1(1)*z + a1(2))*z + a1(3))*z + a1(4)) / ((((((b1(1)*z + &
   & b1(2))*z + b1(3))*z + b1(4))*z + b1(5))*z + b1(6))*z + &
   & 1.d0)
c2 = (((a2(1)*z + a2(2))*z + a2(3))*z + a2(4)) / (((((b2(1)*z + &
   & b2(2))*z + b2(3))*z + b2(4))*z + b2(5))*z + 1.d0)
c3 = (((a3(1)*z + a3(2))*z + a3(3))*z + a3(4)) / ((((b3(1)*z + &
   & b3(2))*z + b3(3))*z + b3(4))*z + 1.d0)
c4 = ((a4(1)*z + a4(2))*z + a4(3)) / ((((b4(1)*z + b4(2))*z + &
   & b4(3))*z + b4(4))*z + 1.d0)
c5 = (a5(1)*z + a5(2)) / ((((b5(1)*z + b5(2))*z + b5(3))*z + &
   & b5(4))*z + 1.d0)
c6 = (a6(1)*z + a6(2))/(((b6(1)*z + b6(2))*z + b6(3))*z + 1.d0)
c7 = (a7(1)*z + a7(2))/(((b7(1)*z + b7(2))*z + b7(3))*z + 1.d0)
c8 = (a8(1)*z + a8(2))/((b8(1)*z + b8(2))*z + 1.d0)
c9 = (a9(1)*z + a9(2))*z + a9(3)
c10 = a10(1)*z + a10(2)
t = (((((((((c10*u + c9)*u + c8)*u + c7)*u + c6)*u + c5)*u + &
   & c4)*u + c3)*u + c2)*u + c1)*u + c0
if (l < 1.d0) go to 10
qans = e*(w + rt2pin*t/rta)
ans = 0.5d0 + (0.5d0 - qans)
return
10 ans = e*(w - rt2pin*t/rta)
qans = 0.5d0 + (0.5d0 - ans)
end subroutine dgr17

pure elemental subroutine dginv(a, x, p, q, ierr)
implicit none
intrinsic :: gamma
integer, intent(inout) :: ierr
double precision, intent(in) :: a
double precision, intent(out) :: x
double precision, intent(in) :: p, q
integer :: ier, ind
real :: p0, q0, x0
double precision :: am1, apn, ap1, ap2, ap3, b, c1, c2, c3, c4, c5, d, e, eps, g, h, pn, qg, qn, r, rta, s, sum, s2, t, u, w, xmin &
   & , xn, y, z, amin
double precision, parameter :: ln10 = 2.302585d0
double precision, parameter :: c = .577215664901533d0
double precision, parameter :: tol = 1.d-10
interface
   pure elemental function dgamln(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dgamln
   end function dgamln
   pure elemental function dgmln1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgmln1
   end function dgmln1
   pure elemental subroutine dgrat(a,x,ans,qans,ierr)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: x
      double precision, intent(inout) :: ans
      double precision, intent(inout) :: qans
      integer, intent(inout) :: ierr
   end subroutine dgrat
   pure elemental function dlnrel(a)
      implicit none
      double precision, intent(in) :: a
      double precision :: dlnrel
   end function dlnrel
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental subroutine dpni(p,q,d,w,ierr)
      implicit none
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      double precision, intent(in) :: d
      double precision, intent(inout) :: w
      integer, intent(inout) :: ierr
   end subroutine dpni
   pure elemental function drcomp(a,x)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(in) :: x
      double precision :: drcomp
   end function drcomp
   pure elemental subroutine gaminv(a,x,x0,p,q,ierr)
      implicit none
      real, intent(in) :: a
      real, intent(out) :: x
      real, intent(in) :: x0
      real, intent(in) :: p
      real, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine gaminv
end interface
!-----------------------------------------------------------------------
!                        Double precision
!             inverse incomplete gamma ratio function
!     given positive A, and NONEGATIVE p and q where p + q = 1.
!     Then x is computed where p(a,x) = p and q(a,x) = q. Schroder
!     iteration is employed.
!                        ------------
!     x is a variable. If p = 0 Then x is assigned the value 0,
!     and if q = 0 Then x is set to the largest floating point
!     number available. Otherwise, dginv attempts to obtain
!     a solution for p(a,x) = p and q(a,x) = q. if the routine
!     is successful then the solution is stored in x.
!     ierr is a variable that reports the status of the results.
!     When the routine terminates, ierr has one of the following
!     values ...
!       ierr =  0    The solution was obtained. Iteration was
!                    not used.
!       ierr.GT.0    the solution was obtained. ierr iterations
!                    were performed.
!       ierr = -2    (INPUT ERROR) a .LE. 0
!       ierr = -3    No solution was obtained. The ratio q/a
!                    is too large.
!       ierr = -4    (INPUT ERROR) p OR q IS NEGATIVE, OR
!                    p + q .NE. 1.
!       ierr = -6    10 iterations were performed. The most
!                    recent value obtained for x is given.
!                    (This setting should never occur.)
!       ierr = -7    Iteration failed. No value is given for x.
!                    This may occur when x is approximately 0.
!       ierr = -8    A value for x has been obtained, but the
!                    routine is not certain of its accuracy.
!                    Iteration cannot be performed in this
!                    case. This setting can occur only when
!                    p or q is approximately 0.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!     written ... January 1992
!------------------------
!------------------------
!     ln10 = ln(10)
!     c = Euler constant
!------------------------
!------------------------
!------------------------
!     ****** E and xmin are machine dependent constants. E is the
!            smallest number for which 1.0 + E .GT. 1.0, and xmin
!            is the smallest positive number.
e = dpmpar(1)
xmin = dpmpar(2)
!------------------------
x = 0.d0
if (a <= 0.d0) go to 500
if (p < 0.d0 .or. q < 0.d0) go to 520
t = ((p + q) - 0.5d0) - 0.5d0
if (abs(t) > 5.d0*max(e,1.d-30)) go to 520
ierr = 0
xmin = xmin/e
if ((p/e) <= xmin) go to 400
if ((q/e) <= xmin) go to 560
if (a == 1.d0) go to 410
e = max(e,1.d-30)
eps = 1.d3*e
amin = 5.d3
if (e < 1.d-17) amin = 2.d6
if (a >= amin) go to 50
!        Get an initial approximation using the single
!         precision arithmetic (if this is possible)
p0 = p
q0 = q
if (p0 == 0.0 .or.q0 == 0.0) go to 10
call gaminv(sngl(a), x0, 0.0, p0, q0, ier)
if (ier < 0.0 .and. ier /= -8) go to 10
ierr = max(ier,0)
if (x0 > 1.e34) go to 10
xn = x0
go to 100
10 if (a > 1.d0) go to 50
xn = 0.d0
!        Selection of the initial approximation XN of x
!                       WHEN a .LT. 1
g = gamma(a + 1.d0)
qg = q*g
if (qg == 0.d0) go to 560
b = qg/a
if (qg > 0.6d0*a) go to 30
if (a >= 0.30d0 .or. b < 0.35d0) go to 20
t = exp(-(b + c))
u = t*exp(t)
xn = t*exp(u)
go to 100
20 if (b >= 0.45d0) go to 30
if (b == 0.d0) go to 560
y = -log(b)
s = 0.5d0 + (0.5d0 - a)
z = log(y)
t = y - s*z
if (b < 0.15d0) go to 21
xn = y - s*log(t) - log(1.d0 + s/(t + 1.d0))
go to 200
21 if (b <= 1.d-2) go to 22
u = ((t + 2.d0*(3.d0 - a))*t + (2.d0 - a)*(3.d0 - a))/ &
   & ((t + (5.d0 - a))*t + 2.d0)
xn = y - s*log(t) - log(u)
go to 200
22 c1 = -s*z
c2 = -s*(1.d0 + c1)
c3 = s*((0.5d0*c1 + (2.d0 - a))*c1 + (2.5d0 - 1.5d0*a))
c4 = -s*(((c1/3.d0 + (2.5d0 - 1.5d0*a))*c1 + ((a - 6.d0)*a &
   & + 7.d0))*c1 + ((11.d0*a - 46.d0)*a + 47.d0)/6.d0)
c5 = -s*((((-c1/4.d0 + (11.d0*a - 17.d0)/6.d0)*c1 &
   & + ((-3.d0*a + 13.d0)*a - 13.d0))*c1 &
   & + 0.5d0*(((2.d0*a - 25.d0)*a + 72.d0)*a - 61.d0))*c1 &
   & + (((25.d0*a - 195.d0)*a + 477.d0)*a - 379.d0)/12.d0)
xn = ((((c5/y + c4)/y + c3)/y + c2)/y + c1) + y
go to 200
30 if (b*q > 1.d-8) go to 31
xn = exp(-(q/a + c))
go to 40
31 if (p <= 0.9d0) go to 32
xn = exp((dlnrel(-q) + dgmln1(a))/a)
go to 40
32 xn = exp(log(p*g)/a)
40 if (xn == 0.d0) go to 510
t = 0.5d0 + (0.5d0 - xn/(a + 1.d0))
xn = xn/t
go to 100
!        Selection of the initial approximation XN of x
!                       WHEN a .GT. 1
50 t = p - 0.5d0
if (q < 0.5d0) t = 0.5d0 - q
call dpni(p, q, t, s, ier)
rta = sqrt(a)
s2 = s*s
xn = (((12.d0*s2 - 243.d0)*s2 - 923.d0)*s2 + 1472.d0)/204120.d0 &
   & - s*(((3753.d0*s2 + 4353.d0)*s2 - 289517.d0)*s2 - 289717.d0) &
   & /(146966400.d0*rta)
xn = (xn/a + s*((9.d0*s2 + 256.d0)*s2 - 433.d0)/(38880.d0*rta)) &
   & - ((3.d0*s2 + 7.d0)*s2 - 16.d0)/810.d0
xn = a + s*rta + (s2 - 1.d0)/3.d0 + s*(s2 - 7.d0)/(36.d0*rta) &
   & + xn/a
xn = max(xn, 0.d0)
if (a < amin) go to 60
x = xn
d = 0.5d0 + (0.5d0 - x/a)
if (abs(d) > 1.d-1) go to 60
if (abs(d) > 1.d-3) go to 100
return
60 if (p <= 0.5d0) go to 70
if (xn < 3.d0*a) go to 200
w = log(q)
y = -(w + dgamln(a))
d = max(2.d0, a*(a - 1.d0))
if (y < ln10*d) go to 61
s = 1.d0 - a
z = log(y)
go to 22
61 t = a - 1.d0
xn = y + t*log(xn) - dlnrel(-t/(xn + 1.d0))
xn = y + t*log(xn) - dlnrel(-t/(xn + 1.d0))
go to 200
70 ap1 = a + 1.d0
if (xn > 0.7d0*ap1) go to 101
w = log(p) + dgamln(ap1)
if (xn > 0.15d0*ap1) go to 80
ap2 = a + 2.d0
ap3 = a + 3.d0
x = exp((w + x)/a)
x = exp((w + x - log(1.0 + (x/ap1)*(1.d0 + x/ap2)))/a)
x = exp((w + x - log(1.0 + (x/ap1)*(1.d0 + x/ap2)))/a)
x = exp((w + x - log(1.0 + (x/ap1)*(1.d0 + (x/ap2)*(1.d0 &
   & + x/ap3))))/a)
xn = x
if (xn <= 1.d-2*ap1) go to 101
80 apn = ap1
t = xn/apn
sum = 1.d0 + t
81 apn = apn + 1.d0
t = t*(xn/apn)
sum = sum + t
if (t > 1.d-4) go to 81
t = w - log(sum)
xn = exp((xn + t)/a)
xn = xn*(1.d0 - (a*log(xn) - xn - t)/(a - xn))
go to 101
!                 Schroder iteration using p
100 if (p > 0.5d0) go to 200
101 if (p <= xmin) go to 550
am1 = (a - 0.5d0) - 0.5d0
110 if (ierr >= 10) go to 530
ierr = ierr + 1
call dgrat(a, xn, pn, qn, ind)
if (pn == 0.d0 .or. qn == 0.d0) go to 550
r = drcomp(a,xn)
if (r < xmin) go to 550
t = (pn - p)/r
w = 0.5d0*(am1 - xn)
if (abs(t) <= 0.1d0 .and. abs(w*t) <= 0.1d0) go to 120
x = xn*(1.d0 - t)
if (x <= 0.d0) go to 540
d = abs(t)
go to 121
120 h = t*(1.d0 + w*t)
x = xn*(1.d0 - h)
if (x <= 0.d0) go to 540
if (abs(w) >= 1.d0 .and. abs(w)*t*t <= eps) return
d = abs(h)
121 xn = x
if (d > tol) go to 110
if (d <= eps) return
if (abs(p - pn) <= tol*p) return
go to 110
!                 Schroder iteration using q
200 if (q <= xmin) go to 550
am1 = (a - 0.5d0) - 0.5d0
210 if (ierr >= 10) go to 530
ierr = ierr + 1
call dgrat(a, xn, pn, qn, ind)
if (pn == 0.d0 .or. qn == 0.d0) go to 550
r = drcomp(a,xn)
if (r < xmin) go to 550
t = (q - qn)/r
w = 0.5d0*(am1 - xn)
if (abs(t) <= 0.1d0 .and. abs(w*t) <= 0.1d0) go to 220
x = xn*(1.d0 - t)
if (x <= 0.d0) go to 540
d = abs(t)
go to 221
220 h = t*(1.d0 + w*t)
x = xn*(1.d0 - h)
if (x <= 0.d0) go to 540
if (abs(w) >= 1.d0 .and. abs(w)*t*t <= eps) return
d = abs(h)
221 xn = x
if (d > tol) go to 210
if (d <= eps) return
if (abs(q - qn) <= tol*q) return
go to 210
!                       Special cases
400 ierr = -8
return
410 if (q < 0.9d0) go to 411
x = -dlnrel(-p)
return
411 x = -log(q)
return
!                       Error return
500 ierr = -2
return
510 ierr = -3
return
520 ierr = -4
return
530 ierr = -6
return
540 ierr = -7
return
550 x = xn
ierr = -8
return
560 x = dpmpar(3)
ierr = -8
end subroutine dginv

pure elemental subroutine bratio(a, b, x, y, w, w1, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: a, b
real, intent(out) :: w, w1
real, intent(in) :: x, y
integer :: ierr1, ind, n
real :: a0, b0, eps, t, x0, y0, z, lambda
interface
   pure elemental function apser(a,b,x,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: eps
      real :: apser
   end function apser
   pure elemental function basym(a,b,lambda,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: lambda
      real, intent(in) :: eps
      real :: basym
   end function basym
   pure elemental function bfrac(a,b,x,y,lambda,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(in) :: lambda
      real, intent(in) :: eps
      real :: bfrac
   end function bfrac
   pure elemental subroutine bgrat(a,b,x,y,w,eps,ierr)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: w
      real, intent(in) :: eps
      integer, intent(inout) :: ierr
   end subroutine bgrat
   pure elemental function bpser(a,b,x,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: eps
      real :: bpser
   end function bpser
   pure elemental function bup(a,b,x,y,n,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: y
      integer, intent(in) :: n
      real, intent(in) :: eps
      real :: bup
   end function bup
   pure elemental function fpser(a,b,x,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: eps
      real :: fpser
   end function fpser
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!            Evaluation of the incomplete beta function ix(a,b)
!                     --------------------
!     It is assumed that A and b are nonnegative, and that x .LE. 1
!     and y = 1 - x.  bratio assigns w and w1 the values
!                      w  = ix(a,b)
!                      w1 = 1 - ix(a,b)
!     ierr is a variable that reports the status of the results.
!     If no input errors are detected then ierr is set to 0 and
!     w and w1 are computed. Otherwise, if an error is detected,
!     then w and w1 are assigned the value 0 and ierr is set to
!     one of the following values ...
!        ierr = 1  If A or b is negative
!        ierr = 2  IF a = b = 0
!        ierr = 3  IF x .LT. 0 OR x .GT. 1
!        ierr = 4  IF y .LT. 0 OR y .GT. 1
!        ierr = 5  IF x + y .NE. 1
!        ierr = 6  IF x = a = 0
!        ierr = 7  IF y = b = 0
!--------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!     revised ... nov 1991
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant. Eps is the smallest
!            floating point number for which 1.0 + eps .GT. 1.0
eps = spmpar(1)
!-----------------------------------------------------------------------
w = 0.0
w1 = 0.0
if (a < 0.0 .or. b < 0.0) go to 300
if (a == 0.0 .and. b == 0.0) go to 310
if (x < 0.0 .or. x > 1.0) go to 320
if (y < 0.0 .or. y > 1.0) go to 330
z = ((x + y) - 0.5) - 0.5
if (abs(z) > 3.0*eps) go to 340
ierr = 0
if (x == 0.0) go to 200
if (y == 0.0) go to 210
if (a == 0.0) go to 211
if (b == 0.0) go to 201
eps = max(eps, 1.e-15)
if (max(a,b) < 1.e-3*eps) go to 230
ind = 0
a0 = a
b0 = b
x0 = x
y0 = y
if (min(a0, b0) > 1.0) go to 30
!             Procedure for a0 .LE. 1 or b0 .LE. 1
if (x <= 0.5) go to 10
ind = 1
a0 = b
b0 = a
x0 = y
y0 = x
10 if (b0 < min(eps,eps*a0)) go to 80
if (a0 < min(eps,eps*b0) .and. b0*x0 <= 1.0) go to 90
if (max(a0, b0) > 1.0) go to 20
if (a0 >= min(0.2, b0)) go to 100
if (x0**a0 <= 0.9) go to 100
if (x0 >= 0.3) go to 110
n = 20
go to 130
20 if (b0 <= 1.0) go to 100
if (x0 >= 0.3) go to 110
if (x0 >= 0.1) go to 21
if ((x0*b0)**a0 <= 0.7) go to 100
21 if (b0 > 15.0) go to 131
n = 20
go to 130
!             Procedure for a0 .GT. 1 and b0 .GT. 1
30 if (a > b) go to 31
lambda = a - (a + b)*x
go to 32
31 lambda = (a + b)*y - b
32 if (lambda >= 0.0) go to 40
ind = 1
a0 = b
b0 = a
x0 = y
y0 = x
lambda = abs(lambda)
40 if (b0 < 40.0 .and. b0*x0 <= 0.7) go to 100
if (b0 < 40.0) go to 140
if (a0 > b0) go to 50
if (a0 <= 100.0) go to 120
if (lambda > 0.03*a0) go to 120
go to 180
50 if (b0 <= 100.0) go to 120
if (lambda > 0.03*b0) go to 120
go to 180
!            Evaluation of the appropriate algorithm
80 w = fpser(a0, b0, x0, eps)
w1 = 0.5 + (0.5 - w)
go to 220
90 w1 = apser(a0, b0, x0, eps)
w = 0.5 + (0.5 - w1)
go to 220
100 w = bpser(a0, b0, x0, eps)
w1 = 0.5 + (0.5 - w)
go to 220
110 w1 = bpser(b0, a0, y0, eps)
w = 0.5 + (0.5 - w1)
go to 220
120 w = bfrac(a0, b0, x0, y0, lambda, 15.0*eps)
w1 = 0.5 + (0.5 - w)
go to 220
130 w1 = bup(b0, a0, y0, x0, n, eps)
b0 = b0 + n
131 call bgrat(b0, a0, y0, x0, w1, 15.0*eps, ierr1)
w = 0.5 + (0.5 - w1)
go to 220
140 n = b0
b0 = b0 - n
if (b0 /= 0.0) go to 141
n = n - 1
b0 = 1.0
141 w = bup(b0, a0, y0, x0, n, eps)
if (x0 > 0.7) go to 150
w = w + bpser(a0, b0, x0, eps)
w1 = 0.5 + (0.5 - w)
go to 220
150 if (a0 > 15.0) go to 151
n = 20
w = w + bup(a0, b0, x0, y0, n, eps)
a0 = a0 + n
151 call bgrat(a0, b0, x0, y0, w, 15.0*eps, ierr1)
w1 = 0.5 + (0.5 - w)
go to 220
180 w = basym(a0, b0, lambda, 100.0*eps)
w1 = 0.5 + (0.5 - w)
go to 220
!               Termination of the procedure
200 if (a == 0.0) go to 350
201 w = 0.0
w1 = 1.0
return
210 if (b == 0.0) go to 360
211 w = 1.0
w1 = 0.0
return
220 if (ind == 0) return
t = w
w = w1
w1 = t
return
!           Procedure for A and b .LT. 1.E-3*eps
230 w = b/(a + b)
w1 = a/(a + b)
return
!                       Error return
300 ierr = 1
return
310 ierr = 2
return
320 ierr = 3
return
330 ierr = 4
return
340 ierr = 5
return
350 ierr = 6
return
360 ierr = 7
end subroutine bratio

pure elemental real function fpser(a, b, x, eps)
implicit none
real, intent(in) :: a, b, eps, x
real :: an, c, s, t, tol
interface
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!                 Evaluation of I (a,b)
!                                x
!          FOR b .LT. min(eps,eps*a) AND x .LE. 0.5.
!-----------------------------------------------------------------------
!                  SET  fpser = x**a
fpser = 1.0
if (a <= 1.e-3*eps) go to 10
fpser = 0.0
t = a*log(x)
if (t < exparg(1)) return
fpser = exp(t)
!                Note that 1/b(a,b) = b
10 fpser = (b/a)*fpser
tol = eps/a
an = a + 1.0
t = x
s = t/an
20 an = an + 1.0
t = x*t
c = t/an
s = s + c
if (abs(c) > tol) go to 20
fpser = fpser*(1.0 + a*s)
end function fpser

pure elemental real function apser(a, b, x, eps)
implicit none
real, intent(in) :: a, b, eps, x
real :: aj, bx, c, s, t, tol, j
real, parameter :: g = .577215664901533
interface
   pure function psi(xx)
      implicit none
      real, intent(in) :: xx
      real :: psi
   end function psi
end interface
!-----------------------------------------------------------------------
!     apser yields the incomplete beta ratio I(sub(1-x))(b,A) for
!     a .LE. min(eps,eps*b), b*x .LE. 1, and x .LE. 0.5. Used when
!     A is very small. Use only if above inequalities are satisfied.
!-----------------------------------------------------------------------
!--------------------
!--------------------
bx = b*x
t = x - bx
if (b*eps > 2.e-2) go to 10
c = log(x) + psi(b) + g + t
go to 20
10 c = log(bx) + g + t
20 tol = 5.0*eps*abs(c)
j = 1.0
s = 0.0
30 j = j + 1.0
t = t*(x - bx/j)
aj = t/j
s = s + aj
if (abs(aj) > tol) go to 30
apser = -a*(c + s)
end function apser

pure elemental real function bpser(a, b, x, eps)
implicit none
real, intent(in) :: a, b, eps, x
integer :: i, m
real :: a0, apb, b0, c, sum, t, tol, u, w, z, n
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function betaln(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: betaln
   end function betaln
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental function gamln1(a)
      implicit none
      real, intent(in) :: a
      real :: gamln1
   end function gamln1
end interface
!-----------------------------------------------------------------------
!     Power series expansion for evaluating IX(a,b) when b .LE. 1
!     or b*x .LE. 0.7.  Eps is the tolerance used.
!-----------------------------------------------------------------------
bpser = 0.0
if (x == 0.0) return
!-----------------------------------------------------------------------
!            Compute the factor x**a/(a*beta(a,b))
!-----------------------------------------------------------------------
a0 = min(a,b)
if (a0 < 1.0) go to 10
z = a*log(x) - betaln(a,b)
bpser = exp(z)/a
go to 70
10 b0 = max(a,b)
if (b0 >= 8.0) go to 60
if (b0 > 1.0) go to 40
!            Procedure for a0 .LT. 1 and b0 .LE. 1
bpser = x**a
if (bpser == 0.0) return
apb = a + b
if (apb > 1.0) go to 20
z = 1.0 + gam1(apb)
go to 30
20 u = dble(a) + dble(b) - 1.d0
z = (1.0 + gam1(u))/apb
30 c = (1.0 + gam1(a))*(1.0 + gam1(b))/z
bpser = bpser*c*(b/apb)
go to 70
!         Procedure for a0 .LT. 1 and 1 .LT. b0 .LT. 8
40 u = gamln1(a0)
m = b0 - 1.0
if (m < 1) go to 50
c = 1.0
do i = 1,m
   b0 = b0 - 1.0
   c = c*(b0/(a0 + b0))
end do
u = log(c) + u
50 z = a*log(x) - u
b0 = b0 - 1.0
apb = a0 + b0
if (apb > 1.0) go to 51
t = 1.0 + gam1(apb)
go to 52
51 u = dble(a0) + dble(b0) - 1.d0
t = (1.0 + gam1(u))/apb
52 bpser = exp(z)*(a0/a)*(1.0 + gam1(b0))/t
go to 70
!            Procedure for a0 .LT. 1 and b0 .GE. 8
60 u = gamln1(a0) + algdiv(a0,b0)
z = a*log(x) - u
bpser = (a0/a)*exp(z)
70 if (bpser == 0.0 .or. a <= 0.1*eps) return
!-----------------------------------------------------------------------
!                     Compute the series
!-----------------------------------------------------------------------
sum = 0.0
n = 0.0
c = 1.0
tol = eps/a
100 n = n + 1.0
c = c*(0.5 + (0.5 - b/n))*x
w = c/(a + n)
sum = sum + w
if (abs(w) > tol) go to 100
bpser = bpser*(1.0 + a*sum)
end function bpser

pure elemental real function bup(a, b, x, y, n, eps)
implicit none
integer, intent(in) :: n
real, intent(in) :: a, b, eps, x, y
integer :: i, k, kp1, mu, nm1
real :: ap1, apb, d, r, t, w, l
interface
   pure elemental function brcmp1(mu,a,b,x,y)
      implicit none
      integer, intent(in) :: mu
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: y
      real :: brcmp1
   end function brcmp1
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!     Evaluation of IX(a,b) - IX(a+n,b) where n is a positive integer.
!     Eps is the tolerance used.
!-----------------------------------------------------------------------
!          Obtain the scaling factor exp(-mu) and
!             exp(mu)*(x**a*y**b/BETA(a,b))/a
apb = a + b
ap1 = a + 1.0
mu = 0
d = 1.0
if (n == 1 .or. a < 1.0) go to 10
if (apb < 1.1*ap1) go to 10
mu = abs(exparg(1))
k = exparg(0)
if (k < mu) mu = k
t = mu
d = exp(-t)
10 bup = brcmp1(mu,a,b,x,y)/a
if (n == 1 .or. bup == 0.0) return
nm1 = n - 1
w = d
!          Let k be the index of the maximum term
k = 0
if (b <= 1.0) go to 40
if (y > 1.e-4) go to 20
k = nm1
go to 30
20 r = (b - 1.0)*x/y - a
if (r < 1.0) go to 40
k = nm1
t = nm1
if (r < t) k = r
!          Add the increasing terms of the series
30 do i = 1,k
   l = i - 1
   d = ((apb + l)/(ap1 + l))*x*d
   w = w + d
end do
if (k == nm1) go to 50
!          Add the remaining terms of the series
40 kp1 = k + 1
do i = kp1,nm1
   l = i - 1
   d = ((apb + l)/(ap1 + l))*x*d
   w = w + d
   if ( d <= eps * w ) exit
end do
!               Terminate the procedure
50 bup = bup*w
end function bup

pure elemental real function bfrac(a, b, x, y, lambda, eps)
implicit none
real, intent(in) :: a, b, eps, x, y
real, intent(in) :: lambda
real :: alpha, an, anp1, beta, bn, bnp1, c, c0, c1, e, p, r, r0, s, t, w, yp1, n
interface
   pure elemental function brcomp(a,b,x,y)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(in) :: x
      real, intent(in) :: y
      real :: brcomp
   end function brcomp
end interface
!-----------------------------------------------------------------------
!     Continued fraction expansion for IX(a,b) when A,b .GT. 1.
!     It is assumed that  lambda = (a + b)*y - b.
!-----------------------------------------------------------------------
!--------------------
bfrac = brcomp(a,b,x,y)
if (bfrac == 0.0) return
c = 1.0 + lambda
c0 = b/a
c1 = 1.0 + 1.0/a
yp1 = y + 1.0
n = 0.0
p = 1.0
s = a + 1.0
an = 0.0
bn = 1.0
anp1 = 1.0
bnp1 = c/c1
r = c1/c
!        Continued fraction calculation
10 n = n + 1.0
t = n/a
w = n*(b - n)*x
e = a/s
alpha = (p*(p + c0)*e*e)*(w*x)
e = (1.0 + t)/(c1 + t + t)
beta = n + w/s + e*(c + n*yp1)
p = 1.0 + t
s = s + 2.0
!        Update an, bn, anp1, and bnp1
t = alpha*an + beta*anp1
an = anp1
anp1 = t
t = alpha*bn + beta*bnp1
bn = bnp1
bnp1 = t
r0 = r
r = anp1/bnp1
if (abs(r - r0) <= eps*r) go to 20
!        Rescale an, bn, anp1, and bnp1
an = an/bnp1
bn = bn/bnp1
anp1 = r
bnp1 = 1.0
go to 10
!                 Termination
20 bfrac = bfrac*r
end function bfrac

pure elemental real function brcomp(a, b, x, y)
implicit none
real, intent(in) :: a, b, x, y
integer :: i, n
real :: a0, apb, b0, c, e, h, t, u, v, x0, y0, z, lambda, lnx, lny
real, parameter :: const = .398942280401433
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function bcorr(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: bcorr
   end function bcorr
   pure elemental function betaln(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: betaln
   end function betaln
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental function gamln1(a)
      implicit none
      real, intent(in) :: a
      real :: gamln1
   end function gamln1
   pure elemental function rlog1(x)
      implicit none
      real, intent(in) :: x
      real :: rlog1
   end function rlog1
end interface
!-----------------------------------------------------------------------
!               Evaluation of x**a*y**b/beta(a,b)
!-----------------------------------------------------------------------
!-----------------
!     const = 1/sqrt(2*pi)
!-----------------
brcomp = 0.0
if (x == 0.0 .or. y == 0.0) return
a0 = min(a,b)
if (a0 >= 8.0) go to 100
if (x > 0.375) go to 10
lnx = log(x)
lny = alnrel(-x)
go to 20
10 if (y > 0.375) go to 11
lnx = alnrel(-y)
lny = log(y)
go to 20
11 lnx = log(x)
lny = log(y)
20 z = a*lnx + b*lny
if (a0 < 1.0) go to 30
z = z - betaln(a,b)
brcomp = exp(z)
return
!-----------------------------------------------------------------------
!              Procedure for a .LT. 1 or b .LT. 1
!-----------------------------------------------------------------------
30 b0 = max(a,b)
if (b0 >= 8.0) go to 80
if (b0 > 1.0) go to 60
!                   Algorithm for b0 .LE. 1
brcomp = exp(z)
if (brcomp == 0.0) return
apb = a + b
if (apb > 1.0) go to 40
z = 1.0 + gam1(apb)
go to 50
40 u = dble(a) + dble(b) - 1.d0
z = (1.0 + gam1(u))/apb
50 c = (1.0 + gam1(a))*(1.0 + gam1(b))/z
brcomp = brcomp*(a0*c)/(1.0 + a0/b0)
return
!                Algorithm for 1 .LT. b0 .LT. 8
60 u = gamln1(a0)
n = b0 - 1.0
if (n < 1) go to 70
c = 1.0
do i = 1,n
   b0 = b0 - 1.0
   c = c*(b0/(a0 + b0))
end do
u = log(c) + u
70 z = z - u
b0 = b0 - 1.0
apb = a0 + b0
if (apb > 1.0) go to 71
t = 1.0 + gam1(apb)
go to 72
71 u = dble(a0) + dble(b0) - 1.d0
t = (1.0 + gam1(u))/apb
72 brcomp = a0*exp(z)*(1.0 + gam1(b0))/t
return
!                   Algorithm for b0 .GE. 8
80 u = gamln1(a0) + algdiv(a0,b0)
brcomp = a0*exp(z - u)
return
!-----------------------------------------------------------------------
!              Procedure for a .GE. 8 and b .GE. 8
!-----------------------------------------------------------------------
100 if (a > b) go to 101
h = a/b
x0 = h/(1.0 + h)
y0 = 1.0/(1.0 + h)
lambda = a - (a + b)*x
go to 110
101 h = b/a
x0 = 1.0/(1.0 + h)
y0 = h/(1.0 + h)
lambda = (a + b)*y - b
110 e = -lambda/a
if (abs(e) > 0.6) go to 111
u = rlog1(e)
go to 120
111 u = e - log(x/x0)
120 e = lambda/b
if (abs(e) > 0.6) go to 121
v = rlog1(e)
go to 130
121 v = e - log(y/y0)
130 z = exp(-(a*u + b*v))
brcomp = const*sqrt(b*x0)*z*exp(-bcorr(a,b))
end function brcomp

pure elemental real function brcmp1(mu, a, b, x, y)
implicit none
integer, intent(in) :: mu
real, intent(in) :: a, b, x, y
integer :: i, n
real :: a0, apb, b0, c, e, h, t, u, v, x0, y0, z, lambda, lnx, lny
real, parameter :: const = .398942280401433
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function bcorr(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: bcorr
   end function bcorr
   pure elemental function betaln(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: betaln
   end function betaln
   pure elemental function esum(mu,x)
      implicit none
      integer, intent(in) :: mu
      real, intent(in) :: x
      real :: esum
   end function esum
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental function gamln1(a)
      implicit none
      real, intent(in) :: a
      real :: gamln1
   end function gamln1
   pure elemental function rlog1(x)
      implicit none
      real, intent(in) :: x
      real :: rlog1
   end function rlog1
end interface
!-----------------------------------------------------------------------
!          Evaluation of  exp(mu) * (x**a*y**b/beta(a,b))
!-----------------------------------------------------------------------
!-----------------
!     const = 1/sqrt(2*pi)
!-----------------
a0 = min(a,b)
if (a0 >= 8.0) go to 100
if (x > 0.375) go to 10
lnx = log(x)
lny = alnrel(-x)
go to 20
10 if (y > 0.375) go to 11
lnx = alnrel(-y)
lny = log(y)
go to 20
11 lnx = log(x)
lny = log(y)
20 z = a*lnx + b*lny
if (a0 < 1.0) go to 30
z = z - betaln(a,b)
brcmp1 = esum(mu,z)
return
!-----------------------------------------------------------------------
!              Procedure for a .LT. 1 or b .LT. 1
!-----------------------------------------------------------------------
30 b0 = max(a,b)
if (b0 >= 8.0) go to 80
if (b0 > 1.0) go to 60
!                   Algorithm for b0 .LE. 1
brcmp1 = esum(mu,z)
if (brcmp1 == 0.0) return
apb = a + b
if (apb > 1.0) go to 40
z = 1.0 + gam1(apb)
go to 50
40 u = dble(a) + dble(b) - 1.d0
z = (1.0 + gam1(u))/apb
50 c = (1.0 + gam1(a))*(1.0 + gam1(b))/z
brcmp1 = brcmp1*(a0*c)/(1.0 + a0/b0)
return
!                Algorithm for 1 .LT. b0 .LT. 8
60 u = gamln1(a0)
n = b0 - 1.0
if (n < 1) go to 70
c = 1.0
do i = 1,n
   b0 = b0 - 1.0
   c = c*(b0/(a0 + b0))
end do
u = log(c) + u
70 z = z - u
b0 = b0 - 1.0
apb = a0 + b0
if (apb > 1.0) go to 71
t = 1.0 + gam1(apb)
go to 72
71 u = dble(a0) + dble(b0) - 1.d0
t = (1.0 + gam1(u))/apb
72 brcmp1 = a0*esum(mu,z)*(1.0 + gam1(b0))/t
return
!                   Algorithm for b0 .GE. 8
80 u = gamln1(a0) + algdiv(a0,b0)
brcmp1 = a0*esum(mu,z - u)
return
!-----------------------------------------------------------------------
!              Procedure for a .GE. 8 and b .GE. 8
!-----------------------------------------------------------------------
100 if (a > b) go to 101
h = a/b
x0 = h/(1.0 + h)
y0 = 1.0/(1.0 + h)
lambda = a - (a + b)*x
go to 110
101 h = b/a
x0 = 1.0/(1.0 + h)
y0 = h/(1.0 + h)
lambda = (a + b)*y - b
110 e = -lambda/a
if (abs(e) > 0.6) go to 111
u = rlog1(e)
go to 120
111 u = e - log(x/x0)
120 e = lambda/b
if (abs(e) > 0.6) go to 121
v = rlog1(e)
go to 130
121 v = e - log(y/y0)
130 z = esum(mu,-(a*u + b*v))
brcmp1 = const*sqrt(b*x0)*z*exp(-bcorr(a,b))
end function brcmp1

pure elemental subroutine bgrat(a, b, x, y, w, eps, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: a, b, eps
real, intent(inout) :: w
real, intent(in) :: x, y
integer :: i, n, nm1
real :: bm1, bp2n, cn, coef, dj, p, q, r, s, sum, t, t2, u, v, z, j, l, lnx, nu, n2, c(30), d(30)
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental subroutine grat1(a,x,r,p,q,eps)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: x
      real, intent(in) :: r
      real, intent(inout) :: p
      real, intent(inout) :: q
      real, intent(in) :: eps
   end subroutine grat1
end interface
!-----------------------------------------------------------------------
!     Asymptotic expansion for IX(a,b) when A is larger than b.
!     The result of the expansion is added to w. it is assumed
!     that a .GE. 15 and b .LE. 1.  Eps is the tolerance used.
!     ierr is a variable that reports the status of the results.
!-----------------------------------------------------------------------
bm1 = (b - 0.5) - 0.5
nu = a + 0.5*bm1
if (y > 0.375) go to 10
lnx = alnrel(-y)
go to 11
10 lnx = log(x)
11 z = -nu*lnx
if (b*z == 0.0) go to 100
!                 Computation of the expansion
!                 SET r = exp(-z)*z**b/gamma(b)
r = b*(1.0 + gam1(b))*exp(b*log(z))
r = r*exp(a*lnx)*exp(0.5*bm1*lnx)
u = algdiv(b,a) + b*log(nu)
u = r*exp(-u)
if (u == 0.0) go to 100
call grat1(b,z,r,p,q,eps)
v = 0.25*(1.0/nu)**2
t2 = 0.25*lnx*lnx
l = w/u
j = q/r
sum = j
t = 1.0
cn = 1.0
n2 = 0.0
do n = 1,30
   bp2n = b + n2
   j = (bp2n*(bp2n + 1.0)*j + (z + bp2n + 1.0)*t)*v
   n2 = n2 + 2.0
   t = t*t2
   cn = cn/(n2*(n2 + 1.0))
   c(n) = cn
   s = 0.0
   if (n == 1) go to 21
   nm1 = n - 1
   coef = b - n
   do i = 1,nm1
      s = s + coef*c(i)*d(n - i)
      coef = coef + b
   end do
21 d(n) = bm1*cn + s/n
   dj = d(n)*j
   sum = sum + dj
   if (sum <= 0.0) go to 100
   if ( abs ( dj ) <= eps * ( sum + l ) ) exit
end do
!                    Add the results to w
ierr = 0
w = w + u*sum
return
!               The expansion cannot be computed
100 ierr = 1
end subroutine bgrat

pure elemental subroutine grat1(a,x,r,p,q,eps)
implicit none
real, intent(in) :: a, eps
real, intent(inout) :: p, q
real, intent(in) :: r, x
real :: a2n, a2nm1, am0, an, an0, b2n, b2nm1, c, cma, g, h, sum, t, tol, w, z, j, l
interface
   pure elemental function erfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      real, intent(in) :: x
      real :: erfc1
   end function erfc1
   pure elemental function gam1(a)
      implicit none
      real, intent(in) :: a
      real :: gam1
   end function gam1
   pure elemental function rexp(x)
      implicit none
      real, intent(in) :: x
      real :: rexp
   end function rexp
end interface
!-----------------------------------------------------------------------
!        Evaluation of the incomplete gamma ratio functions
!                      p(a,x) AND q(a,x)
!     it is assumed that a .LE. 1.  Eps is the tolerance to be used.
!     The input argument r has the value E**(-x)*x**a/gamma(a).
!-----------------------------------------------------------------------
if (a*x == 0.0) go to 130
if (a == 0.5) go to 120
if (x < 1.1) go to 10
go to 50
!             Taylor series for p(a,x)/x**a
10 an = 3.0
c = x
sum = x/(a + 3.0)
tol = 0.1*eps/(a + 1.0)
11 an = an + 1.0
c = -c*(x/an)
t = c/(a + an)
sum = sum + t
if (abs(t) > tol) go to 11
j = a*x*((sum/6.0 - 0.5/(a + 2.0))*x + 1.0/(a + 1.0))
z = a*log(x)
h = gam1(a)
g = 1.0 + h
if (x < 0.25) go to 20
if (a < x/2.59) go to 40
go to 30
20 if (z > -.13394) go to 40
30 w = exp(z)
p = w*g*(0.5 + (0.5 - j))
q = 0.5 + (0.5 - p)
return
40 l = rexp(z)
w = 0.5 + (0.5 + l)
q = (w*j - l)*g - h
if (q < 0.0) go to 110
p = 0.5 + (0.5 - q)
return
!              Continued fraction expansion
50 a2nm1 = 1.0
a2n = 1.0
b2nm1 = x
b2n = x + (1.0 - a)
c = 1.0
51 a2nm1 = x*a2n + c*a2nm1
b2nm1 = x*b2n + c*b2nm1
am0 = a2nm1/b2nm1
c = c + 1.0
cma = c - a
a2n = a2nm1 + cma*a2n
b2n = b2nm1 + cma*b2n
an0 = a2n/b2n
if (abs(an0 - am0) >= eps*an0) go to 51
q = r*an0
p = 0.5 + (0.5 - q)
return
!                Special cases
100 p = 0.0
q = 1.0
return
110 p = 1.0
q = 0.0
return
120 if (x >= 0.25) go to 121
p = erf(sqrt(x))
q = 0.5 + (0.5 - p)
return
121 q = erfc1(0,sqrt(x))
p = 0.5 + (0.5 - q)
return
130 if (x <= a) go to 100
go to 110
end subroutine grat1

pure elemental real function basym(a, b, lambda, eps)
implicit none
real, intent(in) :: a, b, eps
real, intent(in) :: lambda
integer :: i, im1, imj, j, m, mm1, mmj, n, np1
real :: bsum, dsum, f, h, h2, hn, r, r0, r1, s, sum, t, t0, t1, u, w, w0, z, z0, z2, zn, znm1, j0, j1, a0(21), b0(21), c(21), d(21)
integer, parameter :: num = 20
real, parameter :: e0 = 1.12837916709551
real, parameter :: e1 = .353553390593274
interface
   pure elemental function bcorr(a0,b0)
      implicit none
      real, intent(in) :: a0
      real, intent(in) :: b0
      real :: bcorr
   end function bcorr
   pure elemental function erfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      real, intent(in) :: x
      real :: erfc1
   end function erfc1
   pure elemental function rlog1(x)
      implicit none
      real, intent(in) :: x
      real :: rlog1
   end function rlog1
end interface
!-----------------------------------------------------------------------
!     Asymptotic expansion for IX(a,b) for large A and b.
!     lambda = (a + b)*Y - b  and eps is the tolerance used.
!     It is assumed that lambda is nonnegative and that
!     A and b are greater than or equal to 15.
!-----------------------------------------------------------------------
!------------------------
!     ****** num is the maximum value that n can take in the do loop
!            ending at statement 50. It is required that num be even.
!            The arrays a0, b0, c, d have dimension num + 1.
!------------------------
!     e0 = 2/sqrt(pi)
!     e1 = 2**(-3/2)
!------------------------
!------------------------
basym = 0.0
if (a >= b) go to 10
h = a/b
r0 = 1.0/(1.0 + h)
r1 = (b - a)/b
w0 = 1.0/sqrt(a*(1.0 + h))
go to 20
10 h = b/a
r0 = 1.0/(1.0 + h)
r1 = (b - a)/a
w0 = 1.0/sqrt(b*(1.0 + h))
20 f = a*rlog1(-lambda/a) + b*rlog1(lambda/b)
t = exp(-f)
if (t == 0.0) return
z0 = sqrt(f)
z = 0.5*(z0/e1)
z2 = f + f
a0(1) = (2.0/3.0)*r1
c(1) = - 0.5*a0(1)
d(1) = - c(1)
j0 = (0.5/e0)*erfc1(1,z0)
j1 = e1
sum = j0 + d(1)*w0*j1
s = 1.0
h2 = h*h
hn = 1.0
w = w0
znm1 = z
zn = z2
do n = 2, num, 2
   hn = h2*hn
   a0(n) = 2.0*r0*(1.0 + h*hn)/(n + 2.0)
   np1 = n + 1
   s = s + hn
   a0(np1) = 2.0*r1*s/(n + 3.0)
   do i = n, np1
      r = -0.5*(i + 1.0)
      b0(1) = r*a0(1)
      do m = 2, i
         bsum = 0.0
         mm1 = m - 1
         do j = 1, mm1
            mmj = m - j
            bsum = bsum + (j*r - mmj)*a0(j)*b0(mmj)
         end do
         b0(m) = r*a0(m) + bsum/m
      end do
      c(i) = b0(i)/(i + 1.0)
      dsum = 0.0
      im1 = i - 1
      do j = 1, im1
         imj = i - j
         dsum = dsum + d(imj)*c(j)
      end do
      d(i) = -(dsum + c(i))
   end do
   j0 = e1*znm1 + (n - 1.0)*j0
   j1 = e1*zn + n*j1
   znm1 = z2*znm1
   zn = z2*zn
   w = w0*w
   t0 = d(n)*w*j0
   w = w0*w
   t1 = d(np1)*w*j1
   sum = sum + (t0 + t1)
   if ( ( abs ( t0 ) + abs ( t1 ) ) <= eps * sum ) exit
end do
u = exp(-bcorr(a,b))
basym = e0*t*u*sum
end function basym

pure elemental subroutine isubx(a0, b0, x0, p, ierr, eps)
implicit none
integer, intent(out) :: ierr
real, intent(in) :: a0, b0, eps
real, intent(out) :: p
real, intent(in) :: x0
integer :: ind, l, max
real :: a, afrac, am1, an, b, bfrac, c, gamrat, p0, rty, sum, t, temp, tol, x, y, i, j, k, lambda, m, n
real, parameter :: w(10) = [6.6671344308688e-2, 1.4945134915058e-1, 2.1908636251598e-1, 2.6926671931000e-1, &
   & 2.9552422471475e-1, 2.9552422471475e-1, 2.6926671931000e-1, 2.1908636251598e-1, 1.4945134915058e-1, 6.6671344308688e-2]
real, parameter :: z(10) = [1.3046735791414e-2, 6.7468316655507e-2, 1.6029521585049e-1, 2.8330230293538e-1, &
   & 4.2556283050918e-1, 5.7443716949081e-1, 7.1669769706462e-1, 8.3970478414951e-1, 9.3253168334449e-1, 9.8695326420859e-1]
real, parameter :: pihalf = 1.5707963267949
real, parameter :: rpinv = .56418958354776
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure elemental function blnd(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: blnd
   end function blnd
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!     -------------------
!     -------------------
!     rpinv = 1/sqrt(pi)
!     -------------------
!     -------------------
!     ****** max is a machine dependent constant. Max is the
!            largest positive integer that may be used.
max = ipmpar(3)
!     -------------------
a = a0
b = b0
x = x0
y = 0.5 + (0.5 - x)
!                        Check the arguments
p = 0.0
ierr = 1
if (a < 0.5 .or. b < 0.5) go to 410
if (x == 0.0 .or. x == 1.0) go to 300
if (x < 0.0) go to 400
m = max
if (a >= m .or. b > 70.0 .or. y < 0.0) go to 411
k = int(a)
j = int(b)
afrac = a - k
bfrac = b - j
if ((afrac /= 0.0 .and. afrac /= 0.5) .or. &
   & (bfrac /= 0.0 .and. bfrac /= 0.5)) go to 420
if (a >= 5000.0 .and. x < 0.96) return
!                      Check if b is an integer
ind = 0
tol = 0.5*amax1(eps, 1.e-11)
if (bfrac /= 0.0) go to 100
if (afrac /= 0.0) go to 20
if (a >= b) go to 20
!                        Interchange A and b
10 ind = 1
t = b
b = a
a = t
t = y
y = x
x = t
t = j
j = k
k = t
!                        Compute expansion 14
20 am1 = a - 1.0
n = 1.0
if (am1 < 0.5) go to 30
n = j
if (y >= 2.0*j*x) go to 30
t = am1*y/x + 1.0
if (t < j) n = int(t)
30 i = n - 1.0
c = (a*log(x) + i*alnrel(-x)) - blnd(a,i)
if (c <= -30) go to 60
tol = tol/j
an = exp(c)
if (an <= tol) go to 60
if (an >= 1.0 - tol) go to 330
c = an
sum = 0.0
40 i = i + 1.0
if (i >= j) go to 50
c = ((am1 + i)/i)*y*c
sum = sum + c
if (c > tol) go to 40
50 i = n
c = an
51 i = i - 1.0
if (i == 0.0) go to 52
c = i*c/((i + am1)*y)
sum = sum + c
if (c > tol) go to 51
52 p = an + sum
60 if (p >= 1.0) p = 1.0
if (ind == 0) return
p = 0.5 + (0.5 - p)
if (p < 0.0) p = 0.0
return
!                Selection of the appropriate algorithm
100 am1 = a - 1.0
if (a > 70.0) go to 150
if (afrac == 0.0) go to 10
!                COMPUTE p0 = IX(a,1/2) OR p0 = IX(1/2,b)
!                           using formula 22
temp = sqrt(x)
rty = sqrt(y)
c = atan(temp/rty)/pihalf
if (k == 0.0) go to 130
ind = j
m = k + k
temp = -temp
110 i = 0.0
t = 1.0
sum = 0.0
111 i = i + 2.0
if (i == m) go to 120
t = x*(i/(i + 1.0))*t
sum = t + sum
go to 111
120 p0 = (sum + 1.0)*temp*rty/pihalf + c
if (ind /= 0) go to 200
p = p0
return
130 if (j == 0.0) go to 310
m = j + j
x = y
go to 110
!                  COMPUTE p0 = IX(a,1/2) FOR a .GT. 70
!                       using expansion 52 or 53
150 p0 = 0.0
if (x < 0.7) go to 200
t = tol**(1.0/am1)
if (x <= t) go to 200
t = 0.5 + (0.5 - t)
lambda = sqrt(t)
rty = sqrt(y)
gamrat = rpinv*exp(-algdiv(0.5,a))
if (t >= 4.0*y) go to 170
c = lambda - rty
temp = 2.0*rty
sum = 0.0
do l = 1,10
   t = c*z(l)
   sum = sum + w(l)*(x - t*(t + temp))**am1
end do
p0 = c*gamrat*sum + 0.5*tol
go to 200
170 sum = 0.0
do l = 1,10
   t = 1.0 - y*z(l)*z(l)
   sum = sum + w(l)*t**am1
end do
p0 = 1.0 - rty*gamrat*sum
!                     Compute p using expansion 21
200 if (j == 0.0) go to 251
n = j
if (y >= 2.0*j*x) go to 210
t = am1*y/x + 0.5
if (t >= 2.0) go to 201
n = 1.0
go to 210
201 if (t < j) n = int(t)
210 t = n - 0.5
c = (a*log(x) + t*alnrel(-x)) - blnd(a,t)
if (c <= -30.0) go to 251
c = exp(c)
if (c <= tol/j) go to 251
if (p0 + c >= 1.0 - tol) go to 320
tol = tol/j
lambda = c
sum = 0.0
220 t = t + 1.0
if (t > j) go to 240
lambda = (am1 + t)*y*lambda/t
sum = sum + lambda
if (lambda > tol) go to 220
240 lambda = c
t = a - 0.5
i = n
241 i = i - 1.0
if (i <= 0.0) go to 250
lambda = ((i + 0.5)/(i + t))*lambda/y
sum = lambda + sum
if (lambda > tol) go to 241
250 p = c + sum
251 p = p + p0
if (p >= 1.0) p = 1.0
return
!                           Special cases
300 p = x
return
310 p = c
return
320 p = 1.0
return
330 p = 1 - ind
return
!                           Error return
400 ierr = 2
return
410 if (a <= 0.0 .or. b <= 0.0) go to 400
411 ierr = 3
return
420 ierr = 4
end subroutine isubx

pure elemental real function blnd(a,b)
implicit none
real, intent(in) :: a, b
interface
   pure elemental function algdiv(a,b)
      implicit none
      real, intent(in) :: a
      real, intent(in) :: b
      real :: algdiv
   end function algdiv
   pure elemental function logam(x)
      implicit none
      real, intent(in) :: x
      real :: logam
   end function logam
end interface
if (a > 20.0) go to 10
blnd = (logam(a) - logam(a + b)) + logam(b + 1.0)
return
10 blnd = algdiv(b,a) + logam(b + 1.0)
end function blnd

pure elemental real function logam(x)
implicit none
real, intent(in) :: x
integer :: n
real :: t, z
real, parameter :: d = .41893853320467
real, parameter :: w(200) = [.57236494292470e+00, 0.0, -.12078223763525e+00, 0.0, .28468287047292e+00, .69314718055995e+00 &
   & , .12009736023471e+01, .17917594692281e+01, .24537365708424e+01, .31780538303479e+01, .39578139676187e+01, &
   & .47874917427820e+01, .56625620598571e+01, .65792512120101e+01, .75343642367587e+01, .85251613610654e+01, .95492672573010e+01, &
   & .10604602902745e+02, .11689333420797e+02, .12801827480081e+02, .13940625219404e+02, .15104412573076e+02, .16292000476567e+02, &
   & .17502307845874e+02, .18734347511936e+02, .19987214495662e+02, .21260076156245e+02, .22552163853123e+02, .23862765841689e+02, &
   & .25191221182739e+02, .26536914491116e+02, .27899271383841e+02, .29277754515041e+02, .30671860106081e+02, .32081114895947e+02, &
   & .33505073450137e+02, .34943315776877e+02, .36395445208033e+02, .37861086508961e+02, .39339884187199e+02, .40831500974531e+02, &
   & .42335616460753e+02, .43851925860675e+02, .45380138898477e+02, .46919978795809e+02, .48471181351835e+02, .50033494105019e+02, &
   & .51606675567764e+02, .53190494526169e+02, .54784729398112e+02, .56389167643720e+02, .58003605222981e+02, .59627846095884e+02, &
   & .61261701761002e+02, .62904990828877e+02, .64557538627006e+02, .66219176833549e+02, .67889743137182e+02, .69569080920824e+02, &
   & .71257038967168e+02, .72953471184169e+02, .74658236348830e+02, .76371197867783e+02, .78092223553315e+02, .79821185413614e+02, &
   & .81557959456115e+02, .83302425502950e+02, .85054467017582e+02, .86813970941781e+02, .88580827542198e+02, .90354930265818e+02, &
   & .92136175603687e+02, .93924462962300e+02, .95719694542143e+02, .97521775222888e+02, .99330612454787e+02, .10114611615586e+03, &
   & .10296819861451e+03, .10479677439716e+03, .10663176026064e+03, .10847307506907e+03, .11032063971476e+03, .11217437704318e+03, &
   & .11403421178146e+03, .11590007047041e+03, .11777188139975e+03, .11964957454634e+03, .12153308151544e+03, .12342233548444e+03, &
   & .12531727114936e+03, .12721782467361e+03, .12912393363913e+03, .13103553699957e+03, .13295257503562e+03, .13487498931216e+03, &
   & .13680272263733e+03, .13873571902320e+03, .14067392364823e+03, .14261728282115e+03, .14456574394634e+03, .14651925549072e+03, &
   & .14847776695177e+03, .15044122882700e+03, .15240959258450e+03, .15438281063467e+03, .15636083630308e+03, .15834362380427e+03, &
   & .16033112821663e+03, .16232330545817e+03, .16432011226320e+03, .16632150615984e+03, .16832744544843e+03, .17033788918059e+03, &
   & .17235279713916e+03, .17437212981875e+03, .17639584840700e+03, .17842391476655e+03, .18045629141754e+03, .18249294152079e+03, &
   & .18453382886145e+03, .18657891783334e+03, .18862817342367e+03, .19068156119837e+03, .19273904728784e+03, .19480059837319e+03, &
   & .19686618167289e+03, .19893576492993e+03, .20100931639928e+03, .20308680483583e+03, .20516819948264e+03, .20725347005963e+03, &
   & .20934258675254e+03, .21143552020227e+03, .21353224149456e+03, .21563272214993e+03, .21773693411395e+03, .21984484974781e+03, &
   & .22195644181913e+03, .22407168349308e+03, .22619054832373e+03, .22831301024565e+03, .23043904356578e+03, .23256862295547e+03, &
   & .23470172344282e+03, .23683832040517e+03, .23897838956183e+03, .24112190696703e+03, .24326884900298e+03, .24541919237325e+03, &
   & .24757291409619e+03, .24972999149863e+03, .25189040220972e+03, .25405412415489e+03, .25622113555001e+03, .25839141489572e+03, &
   & .26056494097186e+03, .26274169283208e+03, .26492164979855e+03, .26710479145687e+03, .26929109765102e+03, .27148054847853e+03, &
   & .27367312428569e+03, .27586880566295e+03, .27806757344037e+03, .28026940868320e+03, .28247429268763e+03, .28468220697654e+03, &
   & .28689313329543e+03, .28910705360840e+03, .29132395009427e+03, .29354380514276e+03, .29576660135076e+03, .29799232151870e+03, &
   & .30022094864701e+03, .30245246593264e+03, .30468685676567e+03, .30692410472600e+03, .30916419358015e+03, .31140710727802e+03, &
   & .31365282994988e+03, .31590134590330e+03, .31815263962021e+03, .32040669575401e+03, .32266349912673e+03, .32492303472629e+03, &
   & .32718528770378e+03, .32945024337081e+03, .33171788719693e+03, .33398820480710e+03, .33626118197920e+03, .33853680464160e+03, &
   & .34081505887080e+03, .34309593088909e+03, .34537940706227e+03, .34766547389743e+03, .34995411804077e+03, .35224532627544e+03, &
   & .35453908551944e+03, .35683538282361e+03, .35913420536958e+03]
!     ------------------------------------------------------------------
!     Computation of LN(gamma(x)) for x = n/2  where n is an integer
!     ------------------------------------------------------------------
!     d = 0.5*(ln(2*pi) - 1)
!     ---------------------
!     ---------------------
!     ------------------------------------------------------------------
if (x > 100.0) go to 10
n = 2.0*x + 0.1
logam = w(n)
return
10 t = (1.0/x)**2
z = (((-0.75*t + 1.0)*t - 3.5)*t + 105.0)/(x*1260.0)
logam = (d + z) + (x - 0.5)*(log(x) - 1.0)
end function logam

subroutine cbsslj(z, cnu, w)
implicit none
complex :: z
complex, intent(in) :: cnu
complex, intent(inout) :: w
integer :: i, k, m, n
real :: a, cn1, cn2, e, fn, pn, qm, qn, qnp1, r, r2, rn2, sn, t1, t2, u, v, x, y
complex :: c, nu, s, sm1, sm2, t, tsc, w0, w1, zn, zz
real, parameter :: pi = 3.14159265358979
interface
   pure elemental subroutine cbdb(cz,cnu,fn,w)
      implicit none
      complex, intent(in) :: cz
      complex, intent(in) :: cnu
      real, intent(in) :: fn
      complex, intent(inout) :: w
   end subroutine cbdb
   pure elemental subroutine cbja(cz,cnu,w)
      implicit none
      complex, intent(in) :: cz
      complex, intent(in) :: cnu
      complex, intent(inout) :: w
   end subroutine cbja
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
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!-----------------------------------------------------------------------
!         EVALUATION OF THE COMPLEX BESSEL FUNCTION J   (z)
!                                                    cnu
!-----------------------------------------------------------------------
!     Written by
!         Andrew H. van Tuyl and Alfred H. Morris, Jr.
!         Naval Surface Warfare Center
!         October, 1991
!     a modification of the procedure developed by allen V. hershey
!     (Naval Surface Warfare Center) in 1978 for handling the debye
!     approximation is employed.
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
x = real(z)
y = aimag(z)
r = cpabs(x,y)
cn1 = real(cnu)
cn2 = aimag(cnu)
rn2 = cn1*cn1 + cn2*cn2
pn = aint(cn1)
fn = cn1 - pn
!          Calculation when order is an integer
sn = 1.0
if (fn /= 0.0 .or. cn2 /= 0.0) go to 10
n = pn
pn = abs(pn)
cn1 = pn
if (n < 0 .and. n /= (n/2)*2) sn = -1.0
!          Selection of method
10 if (r <= 17.5) go to 20
if (r > 17.5 + 0.5*rn2) go to 40
go to 50
!          Use Maclaurin expansion and recursion
20 if (cn1 >= 0.0) go to 30
qn = -1.25*(r + 0.5*abs(cn2) - abs(y - 0.5*cn2))
if (cn1 >= qn) go to 30
qn = 1.25*(r - max(1.2*r,abs(y - cn2)))
if (cn1 >= qn) go to 30
qn = min(pn, -aint(1.25*(r - abs(cn2))))
go to 130
30 r2 = r*r
qm = 0.0625*r2*r2 - cn2*cn2
qn = max(pn, aint(sqrt(0.5*(qm + abs(qm)))))
go to 130
!          Use asymptotic expansion
40 call cbja(z, cnu, w)
return
!          Calculation for 17.5 .LT. abs(z) .LE. 17.5 + 0.5*abs(cnu)**2
50 n = 0
if (abs(cn2) >= 0.8*abs(y)) go to 60
qm = -1.25*(r + 0.5*abs(cn2) - abs(y - 0.5*cn2))
if (cn1 >= qm) go to 60
qm = 1.25*(r - max(1.2*r,abs(y - cn2)))
if (cn1 < qm) n = 1
60 qn = pn
a = 4.e-3*r*r
zz = z
if (x < 0.0) zz = -z
!          Calculation of zone of exclusion of debye approximation
70 nu = cmplx(qn + fn, cn2)
zn = nu/z
t2 = aimag(zn)*aimag(zn)
u = 1.0 - real(zn)
t1 = u*u + t2
u = 1.0 + real(zn)
t2 = u*u + t2
u = t1*t2
v = a*u/(t1*t1 + t2*t2)
if (u*v*v > 1.0) go to 80
!          The argument lies inside the zone of exclusion
qn = qn + 1.0
if (n == 0) go to 70
!          Use Maclaurin expansion with forward recurrence
qn = min(pn, -aint(1.25*(r - abs(cn2))))
go to 130
!          Use backward recurrence starting from the
!          asymptotic expansion
80 qnp1 = qn + 1.0
if (abs(qn) >= abs(pn)) go to 100
if (r < 17.5 + 0.5*(qnp1*qnp1 + cn2*cn2)) go to 100
nu = cmplx(qn + fn, cn2)
call cbja(zz, nu, sm1)
nu = cmplx(qnp1 + fn, cn2)
call cbja(zz, nu, sm2)
go to 110
!          Use backward recurrence starting from the
!          debye approximation
100 nu = cmplx(qn + fn, cn2)
call cbdb(zz, nu, fn, sm1)
if (qn == pn) go to 120
nu = cmplx(qnp1 + fn, cn2)
call cbdb(zz, nu, fn, sm2)
110 nu = cmplx(qn + fn, cn2)
tsc = 2.0*nu*sm1/zz - sm2
sm2 = sm1
sm1 = tsc
qn = qn - 1.0
if (qn /= pn) go to 110
120 w = sm1
if (sn < 0.0) w = -w
if (x >= 0.0) return
nu = pi*cmplx(-cn2, cn1)
if (y < 0.0) nu = -nu
w = exp(nu)*w
return
!          Use Maclaurin expansion with forward or backward recurrence.
130 m = qn - pn
if (abs(m) > 1) go to 140
nu = cmplx(cn1, cn2)
call cbjm(z, nu, w)
go to 180
140 nu = cmplx(qn + fn, cn2)
call cbjm(z, nu, w1)
w0 = 0.25*z*z
if (m > 0) go to 160
!          Forward recurrence
m = abs(m)
nu = nu + 1.0
call cbjm(z, nu, w)
do i = 2,m
   c = nu*(nu + 1.0)
   t = (c/w0)*(w - w1)
   w1 = w
   w = t
   nu = nu + 1.0
end do
go to 180
!          Backward recurrence
160 nu = nu - 1.0
call cbjm(z, nu, w)
do i = 2,m
   c = nu*(nu + 1.0)
   t = (w0/c)*w1
   w1 = w
   w = w - t
   nu = nu - 1.0
end do
!          Final assembly
180 if (fn /= 0.0 .or. cn2 /= 0.0) go to 190
k = pn
if (k == 0.0) return
e = sn/gamma(pn + 1.0)
w = e*w*(0.5*z)**k
return
190 s = cnu*log(0.5*z)
w = exp(s)*w
if (rn2 > 0.81) go to 200
w = w*cgam0(cnu)
return
200 call cgamma(0, cnu, t)
w = cdiv(w, cnu*t)
end subroutine cbsslj

subroutine cbjm(z, cnu, w)
implicit none
complex, intent(in) :: cnu
complex, intent(inout) :: w
complex :: z
integer :: i, imin, k, km1, km2
real :: a, a0, eps, rnu
complex :: nu, nup1, p, s, sn, t, ti
real :: inu, m
interface
   pure elemental function cdiv(a,b)
      implicit none
      complex, intent(in) :: a
      complex, intent(in) :: b
      complex :: cdiv
   end function cdiv
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!       COMPUTATION OF  (z/2)**(-cnu) * gamma(cnu + 1) * J(cnu,z)
!                           -----------------
!     The Maclaurin expansion is used. It is assumed that cnu is not
!     a negative integer.
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0 .
eps = spmpar(1)
!--------------------------
s = -0.25*(z*z)
nu = cnu
rnu = real(nu)
inu = aimag(nu)
a = 0.5 + (0.5 + rnu)
nup1 = cmplx(a, inu)
if (a <= 0.0) go to 10
m = 1.0
t = s/nup1
w = 1.0 + t
go to 70
!     Add 1.0 and the first k-1 terms
10 k = int(-a) + 2
km1 = k - 1
w = (1.0, 0.0)
t = w
do i = 1,km1
   m = i
   t = t*(s/(m*(nu + m)))
   w = w + t
   if (anorm(t) <= eps*anorm(w)) go to 30
end do
go to 70
!     Check if the (k-1)-ST and k-TH terms can be ignored.
!     If so then the summation is complete.
30 if (i == km1) go to 70
imin = i + 1
if (imin >= k - 5) go to 50
ti = t
m = km1
t = s/(nu + m)
a0 = anorm(t)/m
t = t * (s/(nu + (m + 1.0)))
a = anorm(t)/(m*(m + 1.0))
a = max(a, a0)
t = (1.0, 0.0)
km2 = k - 2
do i = imin,km2
   m = i
   t = t*(s/(m*(nu + m)))
   if (a*anorm(t) < 0.5) return
end do
t = t*ti
imin = km2
!     Add the (k-1)-ST term
50 a = 1.0
p = (1.0, 0.0)
sn = p
do i = imin,km1
   m = i
   a = a*m
   p = p*(nu + m)
   sn = s*sn
end do
t = t*(cdiv(sn,p)/a)
w = w + t
!     Add the remaining terms
70 m = m + 1.0
t = t*(s/(m*(nu + m)))
w = w + t
if (anorm(t) > eps*anorm(w)) go to 70
contains
   pure function anorm(z) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: z
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(z)),abs(aimag(z)))
   end function anorm
end subroutine cbjm

pure elemental subroutine cbdb(cz, cnu, fn, w)
implicit none
real, intent(in) :: fn
complex, intent(in) :: cz, cnu
complex, intent(inout) :: w
integer :: ind, k, l, m
real :: alpha, am, aq, ar, phi, sgn, theta, u, v, x, y, is, inu, izn
complex :: c1, c2, eta, nu, p, p1, q, r, s, s1, s2, sm, t, z, zn
complex, parameter :: j = (0.0, 1.0)
real, parameter :: c = .398942280401433
real, parameter :: pi = 3.14159265358979
real, parameter :: pi2 = 6.28318530717959
real, parameter :: bnd = 1.04719755119660
real, parameter :: a(136) = [1.0, -.208333333333333e+00, .125000000000000e+00, .334201388888889e+00, -.401041666666667e+00 &
   & , .703125000000000e-01, -.102581259645062e+01, .184646267361111e+01, -.891210937500000e+00, .732421875000000e-01, &
   & .466958442342625e+01, -.112070026162230e+02, .878912353515625e+01, -.236408691406250e+01, .112152099609375e+00, - &
   & .282120725582002e+02, .846362176746007e+02, -.918182415432400e+02, .425349987453885e+02, -.736879435947963e+01, &
   & .227108001708984e+00, .212570130039217e+03, -.765252468141182e+03, .105999045252800e+04, -.699579627376133e+03, &
   & .218190511744212e+03, -.264914304869516e+02, .572501420974731e+00, -.191945766231841e+04, .806172218173731e+04, - &
   & .135865500064341e+05, .116553933368645e+05, -.530564697861340e+04, .120090291321635e+04, -.108090919788395e+03, &
   & .172772750258446e+01, .202042913309661e+05, -.969805983886375e+05, .192547001232532e+06, -.203400177280416e+06, &
   & .122200464983017e+06, -.411926549688976e+05, .710951430248936e+04, -.493915304773088e+03, .607404200127348e+01, - &
   & .242919187900551e+06, .131176361466298e+07, -.299801591853811e+07, .376327129765640e+07, -.281356322658653e+07, &
   & .126836527332162e+07, -.331645172484564e+06, .452187689813627e+05, -.249983048181121e+04, .243805296995561e+02, &
   & .328446985307204e+07, -.197068191184322e+08, .509526024926646e+08, -.741051482115327e+08, .663445122747290e+08, - &
   & .375671766607634e+08, .132887671664218e+08, -.278561812808645e+07, .308186404612662e+06, -.138860897537170e+05, &
   & .110017140269247e+03, -.493292536645100e+08, .325573074185766e+09, -.939462359681578e+09, .155359689957058e+10, - &
   & .162108055210834e+10, .110684281682301e+10, -.495889784275030e+09, .142062907797533e+09, -.244740627257387e+08, &
   & .224376817792245e+07, -.840054336030241e+05, .551335896122021e+03, .814789096118312e+09, -.586648149205185e+10, &
   & .186882075092958e+11, -.346320433881588e+11, .412801855797540e+11, -.330265997498007e+11, .179542137311556e+11, - &
   & .656329379261928e+10, .155927986487926e+10, -.225105661889415e+09, .173951075539782e+08, -.549842327572289e+06, &
   & .303809051092238e+04, -.146792612476956e+11, .114498237732026e+12, -.399096175224466e+12, .819218669548577e+12, - &
   & .109837515608122e+13, .100815810686538e+13, -.645364869245377e+12, .287900649906151e+12, -.878670721780233e+11, &
   & .176347306068350e+11, -.216716498322380e+10, .143157876718889e+09, -.387183344257261e+07, .182577554742932e+05, &
   & .286464035717679e+12, -.240629790002850e+13, .910934118523990e+13, -.205168994109344e+14, .305651255199353e+14, - &
   & .316670885847852e+14, .233483640445818e+14, -.123204913055983e+14, .461272578084913e+13, -.119655288019618e+13, &
   & .205914503232410e+12, -.218229277575292e+11, .124700929351271e+10, -.291883881222208e+08, .118838426256783e+06, - &
   & .601972341723401e+13, .541775107551060e+14, -.221349638702525e+15, .542739664987660e+15, -.889496939881026e+15, &
   & .102695519608276e+16, -.857461032982895e+15, .523054882578445e+15, -.232604831188940e+15, .743731229086791e+14, - &
   & .166348247248925e+14, .248500092803409e+13, -.229619372968246e+12, .114657548994482e+11, -.234557963522252e+09, &
   & .832859304016289e+06]
interface
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
end interface
!-----------------------------------------------------------------------
!         CALCULATION OF j   (cz) BY THE DEBYE APPROXIMATION
!                         cnu
!                         ------------------
!     It is assumed that real(cz) .GE. 0 and that real(cnu) = fn + k
!     where k is an integer.
!-----------------------------------------------------------------------
!----------------------
!     c = 1/sqrt(2)
!     bnd = pi/3
!----------------------
!----------------------
!             Coefficients of the first 16 polynomials
!                   in the debye approximation
!----------------------
z = cz
nu = cnu
inu = aimag(cnu)
if (inu >= 0.0) go to 10
z = conjg(z)
nu = conjg(nu)
10 x = real(z)
y = aimag(z)
!          tanh(gamma) = sqrt(1 - (z/nu)**2) = w/nu
!          t = exp(nu*(tanh(gamma) - gamma))
zn = z/nu
izn = aimag(zn)
if (abs(izn) > 0.1*abs(real(zn))) go to 20
s = (1.0 - zn)*(1.0 + zn)
eta = 1.0/s
q = sqrt(s)
s = 1.0/(nu*q)
t = zn/(1.0 + q)
t = exp(nu*(q + log(t)))
go to 30

20 s = (nu - z)*(nu + z)
eta = (nu*nu)/s
w = sqrt(s)
q = w/nu
if (real(q) < 0.0) w = -w
s = 1.0/w
t = z/(nu + w)
t = exp(w + nu*log(t))
30 is = aimag(s)
r = sqrt(s)
c1 = r*t
ar = real(r)*real(r) + aimag(r)*aimag(r)
aq = -1.0/(real(q)*real(q) + aimag(q)*aimag(q))
phi = atan2(y,x)/3.0
q = nu - z
theta = atan2(aimag(q),real(q)) - phi
ind = 0
if (abs(theta) < 2.0*bnd) go to 50
ind = 1
call crec(real(t), aimag(t), u, v)
c2 = -j*r*cmplx(u, v)
if (is < 0.0) go to 40
if (is > 0.0) go to 50
if (real(s) <= 0.0) go to 50
40 c2 = -c2
!          Summation of the series s1 and s2
50 sm = s*s
p = (a(2)*eta + a(3))*s
p1 = ((a(4)*eta + a(5))*eta + a(6))*sm
s1 = (1.0 + p) + p1
if (ind /= 0) s2 = (1.0 - p) + p1
sgn = 1.0
am = ar*ar
m = 4
l = 6
!          p = Value of the m-TH polynomial
60 l = l + 1
alpha = a(l)
p = cmplx(a(l),0.0)
do k = 2,m
   l = l + 1
   alpha = a(l) + aq*alpha
   p = a(l) + eta*p
end do
!          Only the s1 sum is formed when ind = 0
sm = s*sm
p = p*sm
s1 = s1 + p
if (ind == 0) go to 80
sgn = -sgn
s2 = s2 + sgn*p
80 am = ar*am
if (1.0 + alpha*am == 1.0) go to 100
m = m + 1
if (m <= 16) go to 60
!          Final assembly
100 s1 = c*c1*s1
if (ind /= 0) go to 110
w = s1
go to 200
110 s2 = c*c2*s2
q = nu + z
theta = atan2(aimag(q),real(q)) - phi
if (abs(theta) > bnd) go to 120
w = s1 + s2
go to 200
120 alpha = pi2
if (izn < 0.0) alpha = -alpha
t = alpha*cmplx(abs(inu), -fn)
alpha = exp(real(t))
u = aimag(t)
r = cmplx(cos(u),sin(u))
t = s1 - (alpha*r)*s1
if (x == 0.0 .and. inu == 0.0) t = -t
if (y >= 0.0) go to 170
if (izn >= 0.0 .and. theta <= sign(pi,theta)) &
   & s2 = s2*(conjg(r)/alpha)
if (x == 0.0) go to 180
if (izn < 0.0) go to 170
if (is < 0.0) go to 180
170 w = s2 + t
go to 200
180 w = s2 - t
200 if (inu < 0.0) w = conjg(w)
end subroutine cbdb

pure elemental subroutine cbja(cz, cnu, w)
implicit none
complex, intent(in) :: cz, cnu
complex, intent(inout) :: w
integer :: i, ind
real :: eps, r, rnu, tol, u, v, x, y
real :: inu, m
complex :: a, a1, arg, e, eta, nu, p, q, t, z, zr, zz
real, parameter :: pihalf = 1.5707963267949
real, parameter :: c = 1.12837916709551
complex, parameter :: j = (0.0, 1.0)
interface
   pure elemental function cos1(x)
      implicit none
      real, intent(in) :: x
      real :: cos1
   end function cos1
   pure elemental subroutine crec(x,y,u,v)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine crec
   pure elemental function sin1(x)
      implicit none
      real, intent(in) :: x
      real :: sin1
   end function sin1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!        Computation of j(nu,z) by the asymptotic expansion
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
!     pihalf = pi/2
!     c = 2*pi**(-1/2)
!--------------------------
!--------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0 .
eps = spmpar(1)
!--------------------------
z = cz
x = real(z)
y = aimag(z)
nu = cnu
ind = 0
if (abs(x) > 1.e-2*abs(y)) go to 10
if (aimag(nu) >= 0.0 .or. abs(real(nu)) >= &
   & 1.e-2*abs(aimag(nu))) go to 10
ind = 1
nu = conjg(nu)
z = conjg(z)
y = -y
10 if (x < -1.e-2*y) z = -z
zz = z + z
call crec(real(zz), aimag(zz), u, v)
zr = cmplx(u, v)
eta = -zr*zr
p = (0.0,0.0)
q = (0.0,0.0)
a1 = nu*nu - 0.25
a = a1
t = a1
m = 1.0
tol = eps*anorm(a1)
do i = 1,16
   a = a - 2.0*m
   m = m + 1.0
   t = t*a*eta/m
   p = p + t
   a = a - 2.0*m
   m = m + 1.0
   t = t*a/m
   q = q + t
   if ( anorm ( t ) <= tol ) exit
end do
p = p + 1.0
q = (q + a1)*zr
w = z - pihalf*nu
if (abs(aimag(w)) > 1.0) go to 40
arg = w - 0.5*pihalf
w = c*sqrt(zr)*(p*cos(arg) - q*sin(arg))
go to 50
40 e = exp(-j*w)
t = q - j*p
if (aimag(z) > 0.0 .and. real(z) <= 1.e-2*aimag(z) .and. &
   & abs(real(nu)) < 1.e-2*aimag(nu)) t = 0.5*t
call crec(real(e), aimag(e), u, v)
w = 0.5*c*sqrt(j*zr)*((p - j*q)*e + t*cmplx(u, v))
50 if (x >= -1.e-2*y) go to 60
if (y < 0.0) nu = -nu
!     Computation of exp(i*PI*nu)
rnu = real(nu)
inu = aimag(nu)
r = exp(-2.0*pihalf*inu)
u = r*cos1(rnu)
v = r*sin1(rnu)
w = w*cmplx(u,v)
60 if (ind /= 0) w = conjg(w)
contains
   pure function anorm(z) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: z
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(z)), abs(aimag(z)))
   end function anorm
end subroutine cbja

pure elemental subroutine bsslj(a, in, w)
implicit none
integer, intent(in) :: in
complex, intent(in) :: a
complex, intent(inout) :: w
integer :: i, m, n
real :: an, aq(2), az(2), fj(2), pm, pn, qf(2), qm, qn, qz(2), rm(4), rz(2), sm(4), sn, ss, sz(2), tm(2), ts(2), zm, zr(2), zs
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
!     Fortran subroutine for ordinary Bessel function of integral order
!     ******************************************************************
!     a  = ARGUMENT (COMPLEX NUMBER)
!     in = order (integer)
!     w  = Function of first kind (complex number)
!     -------------------
!     -------------------
az(1) = real(a)
az(2) = aimag(a)
zs = az(1)*az(1) + az(2)*az(2)
zm = sqrt(zs)
pn = abs(in)
sn = 1.0
if ( ( in ) < 0 ) go to 002
go to 003
002 if (in == in/2*2) go to 003
sn = -1.0
003 if ( ( az ( 1 ) ) < 0 ) go to 004
go to 005
004 qz(1) = -az(1)
qz(2) = -az(2)
if (in == in/2*2) go to 006
sn = -sn
go to 006
005 qz(1) = az(1)
qz(2) = az(2)
006 if (zm <= 17.5 + 0.5*pn*pn) go to 007
qn = pn
go to 013
007 qn = 0.5*zm - 0.5*abs(qz(2)) + 0.5*abs(0.5*zm - abs(qz(2)))
if (pn <= qn) go to 008
qn = aint(0.0625*zs)
if (pn <= qn) go to 031
qn = pn
go to 031
008 if (zm <= 17.5) go to 009
qn = aint(sqrt(2.0*(zm - 17.5)))
go to 013
009 if ( ( zs - 1.0 ) < 0 ) go to 011
go to 010
010 if ( ( - abs ( az ( 2 ) ) + 0.096 * az ( 1 ) * az ( 1 ) ) < 0 ) &
   & go to 011
go to 012
011 qn = aint(0.0625*zs)
if (pn <= qn) go to 031
qn = pn
go to 031
012 qn = 0.0
013 sz(1) = qz(1)
sz(2) = qz(2)
qm = sn*0.797884560802865
zr(1) = sqrt(sz(1) + zm)
zr(2) = sz(2)/zr(1)
zr(1) = 0.707106781186548*zr(1)
zr(2) = 0.707106781186548*zr(2)
qf(1) = qm*zr(1)/zm
qf(2) = -qm*zr(2)/zm
if (zm <= 17.5) go to 018
rz(1) = 0.5*qz(1)/zs
rz(2) = -0.5*qz(2)/zs
an = qn*qn - 0.25
sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
go to 016
015 an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = -an*ts(1)/pm
tm(2) = -an*ts(2)/pm
016 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = an*ts(1)/pm
tm(2) = an*ts(2)/pm
if (abs(sm(3)) + abs(tm(1)) /= abs(sm(3))) go to 017
if (abs(sm(4)) + abs(tm(2)) == abs(sm(4))) go to 020
017 sm(3) = sm(3) + tm(1)
sm(4) = sm(4) + tm(2)
if (pm < 35.0) go to 015
go to 020
018 sm(1) = 1.0
sm(2) = 0.0
sm(3) = 1.0
sm(4) = 0.0
m = 15.0*qn + 2.0
n = 15.0*qn + 15.0
do i = m,n
   ts(1) = qz(2) - cd(i)
   ts(2) = -qz(1)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   ts(1) = -qz(2) - cd(i)
   ts(2) = qz(1)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(3) = sm(3) + tm(1)
   sm(4) = sm(4) + tm(2)
end do
ts(1) = 0.5*(sm(2) - sm(4))
ts(2) = -0.5*(sm(1) - sm(3))
sm(1) = 0.5*(sm(1) + sm(3))
sm(2) = 0.5*(sm(2) + sm(4))
sm(3) = ts(1)
sm(4) = ts(2)
020 aq(1) = qz(1) - 1.57079632679490*(qn + 0.5)
aq(2) = qz(2)
ts(1) = cos(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = -sin(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
tm(1) = sm(1)*ts(1) - sm(2)*ts(2)
tm(2) = sm(1)*ts(2) + sm(2)*ts(1)
ts(1) = sin(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = cos(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
rm(1) = tm(1) - sm(3)*ts(1) + sm(4)*ts(2)
rm(2) = tm(2) - sm(3)*ts(2) - sm(4)*ts(1)
if (qn == pn) go to 030
rm(3) = rm(1)
rm(4) = rm(2)
qn = qn + 1.0
if (zm <= 17.5) go to 025
an = qn*qn - 0.25
sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
go to 023
022 an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = -an*ts(1)/pm
tm(2) = -an*ts(2)/pm
023 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = an*ts(1)/pm
tm(2) = an*ts(2)/pm
if (abs(sm(3)) + abs(tm(1)) /= abs(sm(3))) go to 024
if (abs(sm(4)) + abs(tm(2)) == abs(sm(4))) go to 027
024 sm(3) = sm(3) + tm(1)
sm(4) = sm(4) + tm(2)
if (pm < 35.0) go to 022
go to 027
025 sm(1) = 1.0
sm(2) = 0.0
sm(3) = 1.0
sm(4) = 0.0
m = 15.0*qn + 2.0
n = 15.0*qn + 15.0
do i = m,n
   ts(1) = qz(2) - cd(i)
   ts(2) = -qz(1)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   ts(1) = -qz(2) - cd(i)
   ts(2) = qz(1)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(3) = sm(3) + tm(1)
   sm(4) = sm(4) + tm(2)
end do
ts(1) = 0.5*(sm(2) - sm(4))
ts(2) = -0.5*(sm(1) - sm(3))
sm(1) = 0.5*(sm(1) + sm(3))
sm(2) = 0.5*(sm(2) + sm(4))
sm(3) = ts(1)
sm(4) = ts(2)
027 aq(1) = qz(1) - 1.57079632679490*(qn + 0.5)
aq(2) = qz(2)
ts(1) = cos(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = -sin(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
tm(1) = sm(1)*ts(1) - sm(2)*ts(2)
tm(2) = sm(1)*ts(2) + sm(2)*ts(1)
ts(1) = sin(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = cos(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
rm(1) = tm(1) - sm(3)*ts(1) + sm(4)*ts(2)
rm(2) = tm(2) - sm(3)*ts(2) - sm(4)*ts(1)
go to 029
028 tm(1) = 2.0*qn*qz(1)/zs
tm(2) = -2.0*qn*qz(2)/zs
ts(1) = tm(1)*rm(1) - tm(2)*rm(2) - rm(3)
ts(2) = tm(1)*rm(2) + tm(2)*rm(1) - rm(4)
rm(3) = rm(1)
rm(4) = rm(2)
rm(1) = ts(1)
rm(2) = ts(2)
qn = qn + 1.0
029 if (qn < pn) go to 028
030 fj(1) = qf(1)*rm(1) - qf(2)*rm(2)
fj(2) = qf(1)*rm(2) + qf(2)*rm(1)
w = cmplx(fj(1),fj(2))
return
031 sz(1) = 0.25*(qz(1)*qz(1) - qz(2)*qz(2))
sz(2) = 0.5*qz(1)*qz(2)
an = qn
sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
032 an = an + 1.0
ts(1) = tm(1)/an
ts(2) = tm(2)/an
sm(3) = sm(3) + ts(1)
sm(4) = sm(4) + ts(2)
tm(1) = -ts(1)*sz(1) + ts(2)*sz(2)
tm(2) = -ts(1)*sz(2) - ts(2)*sz(1)
pm = pm + 1.0
tm(1) = tm(1)/pm
tm(2) = tm(2)/pm
if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 033
if (abs(sm(2)) + abs(tm(2)) == abs(sm(2))) go to 034
033 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
go to 032
034 sm(1) = sm(1) + 1.0
an = qn + 1.0
sm(3) = an*sm(3)
sm(4) = an*sm(4)
go to 036
035 an = qn*(qn + 1.0)
tm(1) = sz(1)/an
tm(2) = sz(2)/an
ts(1) = -tm(1)*sm(3) + tm(2)*sm(4)
ts(2) = -tm(1)*sm(4) - tm(2)*sm(3)
sm(3) = sm(1)
sm(4) = sm(2)
sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
qn = qn - 1.0
036 if (qn > pn) go to 035
qf(1) = sn
qf(2) = 0.0
qn = 0.0
go to 038
037 qn = qn + 1.0
tm(1) = qf(1)*qz(1) - qf(2)*qz(2)
tm(2) = qf(1)*qz(2) + qf(2)*qz(1)
qf(1) = 0.5*tm(1)/qn
qf(2) = 0.5*tm(2)/qn
038 if (qn < pn) go to 037
fj(1) = qf(1)*sm(1) - qf(2)*sm(2)
fj(2) = qf(1)*sm(2) + qf(2)*sm(1)
w = cmplx(fj(1),fj(2))
end subroutine bsslj

subroutine besj(x, alpha, n, y, nz)
implicit none
!     Written by D.E. Amos, S.L. Daniel and M.K. Weston, January, 1975.
!     References
!         sand-75-0147
!         CDC 6600 subroutines ibess and JBESS for Bessel functions
!         i(NU,x) AND J(NU,x), x.GE.0, NU.GE.0  BY D.E. AMOS, S.L.
!         Daniel, M.K. Weston. ACM trans math software,3,PP 76-92
!         (1977)
!         Tables of Bessel functions of moderate or large orders,
!         npl mathematical tables, vol. 6, by F.W.J. Olver, her
!         majesty-S stationery office, london, 1962.
!     Abstract
!         besj computes an n member sequence of J Bessel functions
!         J/sub(alpha+k-1)/(x), k=1,...,n for non-negative alpha and x.
!         A combination of the power series, the asymptotic expansion
!         for x to infinity and the uniform asymptotic expansion for
!         nu to infinity are applied over subdivisions of the (NU,x)
!         plane. For values of (NU,x) not covered by one of these
!         formulae, the order is incremented or decremented by integer
!         values into a region where one of the formulae apply. Backward
!         recursion is applied to reduce orders by integer values except
!         where the entire sequence lies in the oscillatory region. In
!         this case forward recursion is stable and values from the
!         asymptotic expansion for x to infinity start the recursion
!         when it is efficient to do so. Leading terms of the series and
!         uniform expansion are tested for underflow. If a sequence is
!         requested and the last member would underflow, the result is
!         set to zero and the next lower order tried, etc., until A
!         member comes on scale or all members are set to zero. Overflow
!         cannot occur.
!         besj calls asjy, jairy, gamln, spmpar, and ipmpar
!     description of arguments
!         input
!           x      - x.GE.0.0E0
!           alpha  - Order of first member of the sequence,
!                    alpha.GE.0.0E0
!           n      - Number of members in the sequence, n.GE.1
!         output
!           y      - A vector whose first n components contain
!                    values for J/sub(alpha+k-1)/(x), k=1,...,n
!           nz     - Error indicator
!                    nz=0      Normal return - Computation completed
!                    nz=-1     x is less than 0.0
!                    nz=-2     alpha is less than 0.0
!                    nz=-3     n is less than 1
!                    nz.GT.0   last nz components of y set to 0.0
!                              because of underflow
!     error conditions
!         improper input arguments - A fatal error
!         UNDERFLOW  - A NON-FATAL ERROR (nz.GT.0)
integer, intent(in) :: n
integer, intent(inout) :: nz
real, intent(in) :: alpha
real :: x
real, intent(inout) :: y(n)
external jairy
integer :: i, ialp, idalp, iflw, in, is, i1, i2, k, kk, km, kt, nn, ns, nswc_ai_i4
real :: ak, akm, ans, ap, arg, coef, dalpha, dfn, dtm, earg, elim, etx, fidal, flgjy, fn, fnf, fni, fnp1, fnu, gln, rden, relb, &
   & rtx, rzden, s, sa, sb, sxo2, s1, s2, t, ta, tau, tb, temp(3), tfn, tm, tol, tolln, trx, tx, t1, t2, wk(7), xo2, xo2l, &
   & nswc_ai_r4
real, parameter :: rtwo = 1.34839972492648e+00
real, parameter :: pdf = 7.85398163397448e-01
real, parameter :: rttp = 7.97884560802865e-01
real, parameter :: pidt = 1.57079632679490e+00
real, parameter :: pp(4) = [8.72909153935547e+00, 2.65693932265030e-01, 1.24578576865586e-01, 7.70133747430388e-04]
integer, parameter :: inlim = 150
real, parameter :: fnulim(2) = [100.0e0, 60.0e0]
interface
   pure elemental function gamln(a)
      implicit none
      real, intent(in) :: a
      real :: gamln
   end function gamln
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     -------------------
!     ipmpar(8) replaces ipmpar(5) in a double precision code
!     ipmpar(9) replaces ipmpar(6) in a double precision code
!     definition of the tolerances TOL and elim
tb = ipmpar(4)
ta = spmpar(1)/tb
if (tb == 2.0e0) go to 1
if (tb == 8.0e0) go to 2
if (tb == 16.0e0) go to 3
tb = log(tb)
go to 5
1 tb = .69315e0
go to 5
2 tb = 2.07944e0
go to 5
3 tb = 2.77259e0
5 tol = max(ta,1.e-15)
i1 = ipmpar(5)
i2 = ipmpar(6)
!     ln(10**3) = 6.90776
elim = float(-i2)*tb - 6.90776e0
!     tolln = -ln(tol)
tolln = float(i1)*tb
tolln = min(tolln,34.5388e0)
nz = 0
kt = 1
nswc_ai_i4 = n - 1
if ( nswc_ai_i4 < 0 ) go to 720
if ( nswc_ai_i4 == 0 ) go to 10
go to 20
10 kt = 2
20 nn = n
nswc_ai_r4 = x
if ( nswc_ai_r4 < 0 ) go to 730
if ( nswc_ai_r4 == 0 ) go to 30
go to 80
30 nswc_ai_r4 = alpha
if ( nswc_ai_r4 < 0 ) go to 710
if ( nswc_ai_r4 == 0 ) go to 40
go to 50
40 y(1) = 1.0e0
if (n == 1) return
i1 = 2
go to 60
50 i1 = 1
60 do i = i1,n
   y(i) = 0.0e0
end do
return
80 continue
if (alpha < 0.0e0) go to 710
ialp = int(alpha)
fni = float(ialp + n - 1)
fnf = alpha - float(ialp)
dfn = fni + fnf
fnu = dfn
xo2 = x*0.5e0
sxo2 = xo2*xo2
!     Decision tree for region where series, asymptotic expansion for x
!     to infinity and asymptotic expansion for nu to infinity are
!     applied.
if (sxo2 <= (fnu + 1.0e0)) go to 90
ta = max(20.0e0,fnu)
if (x > ta) go to 120
if (x > 12.0e0) go to 110
xo2l = log(xo2)
ns = int(sxo2 - fnu) + 1
go to 100
90 fn = fnu
fnp1 = fn + 1.0e0
xo2l = log(xo2)
is = kt
if (x <= 0.50e0) go to 330
ns = 0
100 fni = fni + float(ns)
dfn = fni + fnf
fn = dfn
fnp1 = fn + 1.0e0
is = kt
if (n - 1 + ns > 0) is = 3
go to 330
110 ans = max(36.0e0 - fnu,0.0e0)
ns = int(ans)
fni = fni + float(ns)
dfn = fni + fnf
fn = dfn
is = kt
if (n - 1 + ns > 0) is = 3
go to 130
120 continue
rtx = sqrt(x)
tau = rtwo*rtx
ta = tau + fnulim(kt)
if (fnu <= ta) go to 480
fn = fnu
is = kt
!     Uniform asymptotic expansion for nu to infinity
130 continue
i1 = abs(3 - is)
i1 = max(i1,1)
flgjy = 1.0e0
call asjy(jairy,x,fn,flgjy,i1,tol,elim,temp(is),wk,iflw)
if (iflw /= 0) go to 380
select case (is)
case (1)
   go to 320
case (2)
   go to 450
case (3)
   go to 620
end select
310 temp(1) = temp(3)
kt = 1
320 is = 2
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
if (i1 == 2) go to 450
go to 130
!     SERIES FOR (x/2)**2.LE.NU+1
330 continue
gln = gamln(fnp1)
arg = fn*xo2l - gln
if (arg < (-elim)) go to 400
earg = exp(arg)
340 continue
s = 1.0e0
if (x < tol) go to 360
ak = 3.0e0
t2 = 1.0e0
t = 1.0e0
s1 = fn
do k = 1,17
   s2 = t2 + s1
   t = -t*sxo2/s2
   s = s + t
   if ( abs ( t ) < tol ) exit
   t2 = t2 + ak
   ak = ak + 2.0e0
   s1 = s1 + fn
end do
360 continue
temp(is) = s*earg
select case (is)
case (1)
   go to 370
case (2)
   go to 450
case (3)
   go to 610
end select
370 earg = earg*fn/xo2
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
is = 2
go to 340
!     Set underflow value and update parameters
380 y(nn) = 0.0e0
nn = nn - 1
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
nswc_ai_i4 = nn - 1
if ( nswc_ai_i4 < 0 ) go to 440
if ( nswc_ai_i4 == 0 ) go to 390
go to 130
390 kt = 2
is = 2
go to 130
400 y(nn) = 0.0e0
nn = nn - 1
fnp1 = fn
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
nswc_ai_i4 = nn - 1
if ( nswc_ai_i4 < 0 ) go to 440
if ( nswc_ai_i4 == 0 ) go to 410
go to 420
410 kt = 2
is = 2
420 if (sxo2 <= fnp1) go to 430
go to 130
430 arg = arg - xo2l + log(fnp1)
if (arg < (-elim)) go to 400
go to 330
440 nz = n - nn
return
!     Backward recursion section
450 continue
nz = n - nn
if (kt == 2) go to 470
!     Backward recur from index alpha+nn-1 to alpha
y(nn) = temp(1)
y(nn - 1) = temp(2)
if (nn == 2) return
trx = 2.0e0/x
dtm = fni
tm = (dtm + fnf)*trx
k = nn + 1
do i = 3,nn
   k = k - 1
   y(k - 2) = tm*y(k - 1) - y(k)
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
end do
return
470 y(1) = temp(2)
return
!     Asymptotic expansion for x to infinity with forward recursion in
!     oscillatory region x.GT.max(20, NU), provided the last member
!     of the sequence is also in the region.
480 continue
in = int(alpha - tau + 2.0e0)
if (in <= 0) go to 490
idalp = ialp - in - 1
kt = 1
go to 500
490 continue
idalp = ialp
in = 0
500 is = kt
fidal = float(idalp)
dalpha = fidal + fnf
arg = x - pidt*dalpha - pdf
sa = sin(arg)
sb = cos(arg)
coef = rttp/rtx
etx = 8.0e0*x
510 continue
dtm = fidal + fidal
dtm = dtm*dtm
tm = 0.0e0
if (fidal == 0.0e0 .and. abs(fnf) < tol) go to 520
tm = 4.0e0*fnf*(fidal + fidal + fnf)
520 continue
trx = dtm - 1.0e0
t2 = (trx + tm)/etx
s2 = t2
relb = tol*abs(t2)
t1 = etx
s1 = 1.0e0
fn = 1.0e0
ak = 8.0e0
do k = 1,13
   t1 = t1 + etx
   fn = fn + ak
   trx = dtm - fn
   ap = trx + tm
   t2 = -t2*ap/t1
   s1 = s1 + t2
   t1 = t1 + etx
   ak = ak + 8.0e0
   fn = fn + ak
   trx = dtm - fn
   ap = trx + tm
   t2 = t2*ap/t1
   s2 = s2 + t2
   if ( abs ( t2 ) <= relb ) exit
   ak = ak + 8.0e0
end do
temp(is) = coef*(s1*sb - s2*sa)
if (is == 2) go to 560
fidal = fidal + 1.0e0
dalpha = fidal + fnf
is = 2
tb = sa
sa = -sb
sb = tb
go to 510
!     Forward recursion section
560 if (kt == 2) go to 470
s1 = temp(1)
s2 = temp(2)
tx = 2.0e0/x
tm = dalpha*tx
if (in == 0) go to 580
!     Forward recur to index alpha
do i = 1,in
   s = s2
   s2 = tm*s2 - s1
   tm = tm + tx
   s1 = s
end do
if (nn == 1) go to 600
s = s2
s2 = tm*s2 - s1
tm = tm + tx
s1 = s
580 continue
!     Forward recur from index alpha to alpha+n-1
y(1) = s1
y(2) = s2
if (nn == 2) return
do i = 3,nn
   y(i) = tm*y(i - 1) - y(i - 2)
   tm = tm + tx
end do
return
600 y(1) = s2
return
!     Backward recursion with normalization by
!     asymptotic expansion for nu to infinity or power series.
610 continue
!     Computation of last order for series normalization
akm = max(3.0e0 - fn,0.0e0)
km = int(akm)
tfn = fn + float(km)
ta = (gln + tfn - 0.9189385332e0 - 0.0833333333e0/tfn)/(tfn + 0.5e0)
ta = xo2l - ta
tb = -(1.0e0 - 1.5e0/tfn)/tfn
akm = tolln/(-ta + sqrt(ta*ta - tolln*tb)) + 1.5e0
in = km + int(akm)
go to 660
620 continue
!     Computation of last order for asymptotic expansion normalization
gln = wk(3) + wk(2)
if (wk(6) > 30.0e0) go to 640
rden = (pp(4)*wk(6) + pp(3))*wk(6) + 1.0e0
rzden = pp(1) + pp(2)*wk(6)
ta = rzden/rden
if (wk(1) < 0.10e0) go to 630
tb = gln/wk(5)
go to 650
630 tb = (1.259921049e0 + (0.1679894730e0 + 0.0887944358e0*wk(1))*wk(1)) &
   & /wk(7)
go to 650
640 continue
ta = 0.5e0*tolln/wk(4)
ta = ((0.0493827160e0*ta - 0.1111111111e0)*ta + 0.6666666667e0)*ta*wk(6)
if (wk(1) < 0.10e0) go to 630
tb = gln/wk(5)
650 in = int(ta/tb + 1.5e0)
if (in > inlim) go to 310
660 continue
dtm = fni + float(in)
trx = 2.0e0/x
tm = (dtm + fnf)*trx
ta = 0.0e0
tb = tol
kk = 1
670 continue
!     Backward recur unindexed
do i = 1,in
   s = tb
   tb = tm*tb - ta
   ta = s
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
end do
!     Normalization
if (kk /= 1) go to 690
ta = (ta/tb)*temp(3)
tb = temp(3)
kk = 2
in = ns
if (ns /= 0) go to 670
690 y(nn) = tb
nz = n - nn
if (nn == 1) return
k = nn - 1
y(k) = tm*tb - ta
if (nn == 2) return
dtm = dtm - 1.0e0
tm = (dtm + fnf)*trx
km = k - 1
!     Backward recur indexed
do i = 1,km
   y(k - 1) = tm*y(k) - y(k + 1)
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
   k = k - 1
end do
return
710 continue
nz = -2
return
720 continue
nz = -3
return
730 continue
nz = -1
end subroutine besj

subroutine asjy(funjy,x,fnu,flgjy,in,tol,elim,y,wk,iflw)
implicit none
!               asjy computes Bessel functions j and y
!               for arguments x.GT.0.0 and orders fnu.GE.35.0
!               ON flgjy = 1 AND flgjy = -1 RESPECTIVELY
!                                  input
!      FUNJY - External function jairy or YAIRY
!          x - ARGUMENT, x.GT.0.0E0
!        fnu - Order of the first Bessel function
!      flgjy - Selection flag
!              flgjy =  1.0E0 gives the j function
!              flgjy = -1.0E0 gives the y function
!         in - Number of functions desired, in = 1 Or 2
!        tol - Tolerance specified by besj or BESY
!       elim - Tolerance specified by besj or BESY
!                                  output
!         y  - A vector whose first in components contain the sequence
!       iflw - A flag indicating underflow or overflow
!                    RETURN VARIABLES FOR besj ONLY
!      wk(1) = 1 - (x/fnu)**2 = w**2
!      wk(2) = sqrt(abs(wk(1)))
!      wk(3) = abs(wk(2) - atan(wk(2)))  or
!              abs(LN((1 + wk(2))/(x/fnu)) - wk(2))
!            = abs((2/3)*ZETA**(3/2))
!      wk(4) = fnu*wk(3)
!      wk(5) = (1.5*wk(3)*fnu)**(1/3) = sqrt(zeta)*fnu**(1/3)
!      wk(6) = sign(1.,w**2)*wk(5)**2 = sign(1.,w**2)*zeta*fnu**(2/3)
!      wk(7) = fnu**(1/3)
!                                  written by
!                                  D. E. Amos
!     abstract
!         ASJK implements the uniform asymptotic expansion of
!         the j and y Bessel functions for fnu.GE.35 and real
!         x.GT.0.0E0. The forms are identical except for a change
!         in sign of some of the terms. This change in sign is
!         accomplished by means of the flag flgjy = 1 Or -1. On
!         flgjy = 1 The Airy functions ai(x) and dai(x) are
!         supplied by the external function jairy, and on
!         flgjy = -1 The Airy functions bi(x) and DBI(x) are
!         supplied by the external funtion YAIRY.
integer :: iflw, in
real :: elim, flgjy, fnu, tol, wk(*), x, y(*)
external funjy
integer :: i, j, jn, jr, ju, k, kb, klast, kmax(5), kp1, ks, ksp1, &
   & kstemp, l, lr, lrp1
real :: abw2, akm, alfa(26,4), ap, ar(8), asum, az, beta(26,5), br(10), bsum, c(65), con1, con2, con3, con548, cr(10), crz32, dfi, &
   & dr(10), fi, fn, fn2, gama(26), phi, rcz, rden, relb, rfn2, rtz, rzden, sa, sb, suma, sumb, s1, ta, tau, tb, tfn, tols, t2, &
   & upol(10), xx, z, z32
data tols            /-6.90775527898214e+00/
data con1,con2,con3,con548/ &
   & 6.66666666666667e-01, 3.33333333333333e-01, 1.41421356237310e+00, &
   & 1.04166666666667e-01/
data  ar(1),  ar(2),  ar(3),  ar(4),  ar(5),  ar(6),  ar(7), &
   & ar(8)          / 8.35503472222222e-02, 1.28226574556327e-01, &
   & 2.91849026464140e-01, 8.81627267443758e-01, 3.32140828186277e+00, &
   & 1.49957629868626e+01, 7.89230130115865e+01, 4.74451538868264e+02/
data  br(1), br(2), br(3), br(4), br(5), br(6), br(7), br(8), &
   & br(9), br(10)  /-1.45833333333333e-01,-9.87413194444444e-02, &
   & -1.43312053915895e-01,-3.17227202678414e-01,-9.42429147957120e-01, &
   & -3.51120304082635e+00,-1.57272636203680e+01,-8.22814390971859e+01, &
   & -4.92355370523671e+02,-3.31621856854797e+03/
data c(1), c(2), c(3), c(4), c(5), c(6), c(7), c(8), c(9), c(10), &
   & c(11), c(12), c(13), c(14), c(15), c(16), c(17), c(18), &
   & c(19), c(20), c(21), c(22), c(23), c(24)/ &
   & -2.08333333333333e-01,        1.25000000000000e-01, &
   & 3.34201388888889e-01,       -4.01041666666667e-01, &
   & 7.03125000000000e-02,       -1.02581259645062e+00, &
   & 1.84646267361111e+00,       -8.91210937500000e-01, &
   & 7.32421875000000e-02,        4.66958442342625e+00, &
   & -1.12070026162230e+01,        8.78912353515625e+00, &
   & -2.36408691406250e+00,        1.12152099609375e-01, &
   & -2.82120725582002e+01,        8.46362176746007e+01, &
   & -9.18182415432400e+01,        4.25349987453885e+01, &
   & -7.36879435947963e+00,        2.27108001708984e-01, &
   & 2.12570130039217e+02,       -7.65252468141182e+02, &
   & 1.05999045252800e+03,       -6.99579627376133e+02/
data c(25), c(26), c(27), c(28), c(29), c(30), c(31), c(32), &
   & c(33), c(34), c(35), c(36), c(37), c(38), c(39), c(40), &
   & c(41), c(42), c(43), c(44), c(45), c(46), c(47), c(48)/ &
   & 2.18190511744212e+02,       -2.64914304869516e+01, &
   & 5.72501420974731e-01,       -1.91945766231841e+03, &
   & 8.06172218173731e+03,       -1.35865500064341e+04, &
   & 1.16553933368645e+04,       -5.30564697861340e+03, &
   & 1.20090291321635e+03,       -1.08090919788395e+02, &
   & 1.72772750258446e+00,        2.02042913309661e+04, &
   & -9.69805983886375e+04,        1.92547001232532e+05, &
   & -2.03400177280416e+05,        1.22200464983017e+05, &
   & -4.11926549688976e+04,        7.10951430248936e+03, &
   & -4.93915304773088e+02,        6.07404200127348e+00, &
   & -2.42919187900551e+05,        1.31176361466298e+06, &
   & -2.99801591853811e+06,        3.76327129765640e+06/
data c(49), c(50), c(51), c(52), c(53), c(54), c(55), c(56), &
   & c(57), c(58), c(59), c(60), c(61), c(62), c(63), c(64), &
   & c(65)/ &
   & -2.81356322658653e+06,        1.26836527332162e+06, &
   & -3.31645172484564e+05,        4.52187689813627e+04, &
   & -2.49983048181121e+03,        2.43805296995561e+01, &
   & 3.28446985307204e+06,       -1.97068191184322e+07, &
   & 5.09526024926646e+07,       -7.41051482115327e+07, &
   & 6.63445122747290e+07,       -3.75671766607634e+07, &
   & 1.32887671664218e+07,       -2.78561812808645e+06, &
   & 3.08186404612662e+05,       -1.38860897537170e+04, &
   & 1.10017140269247e+02/
data alfa(1,1), alfa(2,1), alfa(3,1), alfa(4,1), alfa(5,1),   alfa(6,1), alfa(7,1), alfa(8,1), alfa(9,1), alfa(10,1),   alfa(11,1) &
   & ,alfa(12,1),alfa(13,1),alfa(14,1),alfa(15,1),   alfa(16,1),alfa(17,1),alfa(18,1),alfa(19,1),alfa(20,1),   alfa(21,1),alfa(22, &
   & 1),alfa(23,1),alfa(24,1),alfa(25,1),   alfa(26,1)     /-4.44444444444444e-03,-9.22077922077922e-04,   -8.84892884892885e-05, &
   & 1.65927687832450e-04, 2.46691372741793e-04,   2.65995589346255e-04, 2.61824297061501e-04, 2.48730437344656e-04, &
   & 2.32721040083232e-04, 2.16362485712365e-04, 2.00738858762752e-04,   1.86267636637545e-04, 1.73060775917876e-04, &
   & 1.61091705929016e-04,   1.50274774160908e-04, 1.40503497391270e-04, 1.31668816545923e-04,   1.23667445598253e-04, &
   & 1.16405271474738e-04, 1.09798298372713e-04,   1.03772410422993e-04, 9.82626078369363e-05, 9.32120517249503e-05, &
   & 8.85710852478712e-05, 8.42963105715700e-05, 8.03497548407791e-05/
data alfa(1,2), alfa(2,2), alfa(3,2), alfa(4,2), alfa(5,2),   alfa(6,2), alfa(7,2), alfa(8,2), alfa(9,2), alfa(10,2),   alfa(11,2) &
   & ,alfa(12,2),alfa(13,2),alfa(14,2),alfa(15,2),   alfa(16,2),alfa(17,2),alfa(18,2),alfa(19,2),alfa(20,2),   alfa(21,2),alfa(22, &
   & 2),alfa(23,2),alfa(24,2),alfa(25,2),   alfa(26,2)     / 6.93735541354589e-04, 2.32241745182922e-04,   -1.41986273556691e-05,- &
   & 1.16444931672049e-04,-1.50803558053049e-04,   -1.55121924918096e-04,-1.46809756646466e-04,-1.33815503867491e-04,   - &
   & 1.19744975684254e-04,-1.06184319207974e-04,-9.37699549891194e-05,   -8.26923045588193e-05,-7.29374348155221e-05,- &
   & 6.44042357721016e-05,   -5.69611566009369e-05,-5.04731044303562e-05,-4.48134868008883e-05,   -3.98688727717599e-05,- &
   & 3.55400532972042e-05,-3.17414256609022e-05,   -2.83996793904175e-05,-2.54522720634871e-05,-2.28459297164725e-05,   - &
   & 2.05352753106481e-05,-1.84816217627666e-05,-1.66519330021394e-05/
data alfa(1,3), alfa(2,3), alfa(3,3), alfa(4,3), alfa(5,3),   alfa(6,3), alfa(7,3), alfa(8,3), alfa(9,3), alfa(10,3),   alfa(11,3) &
   & ,alfa(12,3),alfa(13,3),alfa(14,3),alfa(15,3),   alfa(16,3),alfa(17,3),alfa(18,3),alfa(19,3),alfa(20,3),   alfa(21,3),alfa(22, &
   & 3),alfa(23,3),alfa(24,3),alfa(25,3),   alfa(26,3)     /-3.54211971457744e-04,-1.56161263945159e-04,   3.04465503594936e-05, &
   & 1.30198655773243e-04, 1.67471106699712e-04,   1.70222587683593e-04, 1.56501427608595e-04, 1.36339170977445e-04, &
   & 1.14886692029825e-04, 9.45869093034688e-05, 7.64498419250898e-05,   6.07570334965197e-05, 4.74394299290509e-05, &
   & 3.62757512005344e-05,   2.69939714979225e-05, 1.93210938247939e-05, 1.30056674793963e-05,   7.82620866744497e-06, &
   & 3.59257485819352e-06, 1.44040049814252e-07,   -2.65396769697939e-06,-4.91346867098486e-06,-6.72739296091248e-06,   - &
   & 8.17269379678658e-06,-9.31304715093561e-06,-1.02011418798016e-05/
data alfa(1,4), alfa(2,4), alfa(3,4), alfa(4,4), alfa(5,4),   alfa(6,4), alfa(7,4), alfa(8,4), alfa(9,4), alfa(10,4),   alfa(11,4) &
   & ,alfa(12,4),alfa(13,4),alfa(14,4),alfa(15,4),   alfa(16,4),alfa(17,4),alfa(18,4),alfa(19,4),alfa(20,4),   alfa(21,4),alfa(22, &
   & 4),alfa(23,4),alfa(24,4),alfa(25,4),   alfa(26,4)     / 3.78194199201773e-04, 2.02471952761816e-04,   -6.37938506318862e-05,- &
   & 2.38598230603006e-04,-3.10916256027362e-04,   -3.13680115247576e-04,-2.78950273791323e-04,-2.28564082619141e-04,   - &
   & 1.75245280340847e-04,-1.25544063060690e-04,-8.22982872820208e-05,   -4.62860730588116e-05,-1.72334302366962e-05, &
   & 5.60690482304602e-06,   2.31395443148287e-05, 3.62642745856794e-05, 4.58006124490189e-05,   5.24595294959114e-05, &
   & 5.68396208545815e-05, 5.94349820393104e-05,   6.06478527578422e-05, 6.08023907788436e-05, 6.01577894539460e-05, &
   & 5.89199657344698e-05, 5.72515823777593e-05, 5.52804375585853e-05/
data beta(1,1), beta(2,1), beta(3,1), beta(4,1), beta(5,1),   beta(6,1), beta(7,1), beta(8,1), beta(9,1), beta(10,1),   beta(11,1) &
   & ,beta(12,1),beta(13,1),beta(14,1),beta(15,1),   beta(16,1),beta(17,1),beta(18,1),beta(19,1),beta(20,1),   beta(21,1),beta(22, &
   & 1),beta(23,1),beta(24,1),beta(25,1),   beta(26,1)     / 1.79988721413553e-02, 5.59964911064388e-03,   2.88501402231133e-03, &
   & 1.80096606761054e-03, 1.24753110589199e-03,   9.22878876572938e-04, 7.14430421727287e-04, 5.71787281789705e-04, &
   & 4.69431007606482e-04, 3.93232835462917e-04, 3.34818889318298e-04,   2.88952148495752e-04, 2.52211615549573e-04, &
   & 2.22280580798883e-04,   1.97541838033063e-04, 1.76836855019718e-04, 1.59316899661821e-04,   1.44347930197334e-04, &
   & 1.31448068119965e-04, 1.20245444949303e-04,   1.10449144504599e-04, 1.01828770740567e-04, 9.41998224204238e-05, &
   & 8.74130545753834e-05, 8.13466262162801e-05, 7.59002269646219e-05/
data beta(1,2), beta(2,2), beta(3,2), beta(4,2), beta(5,2),   beta(6,2), beta(7,2), beta(8,2), beta(9,2), beta(10,2),   beta(11,2) &
   & ,beta(12,2),beta(13,2),beta(14,2),beta(15,2),   beta(16,2),beta(17,2),beta(18,2),beta(19,2),beta(20,2),   beta(21,2),beta(22, &
   & 2),beta(23,2),beta(24,2),beta(25,2),   beta(26,2)     /-1.49282953213429e-03,-8.78204709546389e-04,   -5.02916549572035e-04,- &
   & 2.94822138512746e-04,-1.75463996970783e-04,   -1.04008550460816e-04,-5.96141953046458e-05,-3.12038929076098e-05,   - &
   & 1.26089735980230e-05,-2.42892608575730e-07, 8.05996165414274e-06,   1.36507009262147e-05, 1.73964125472926e-05, &
   & 1.98672978842134e-05,   2.14463263790823e-05, 2.23954659232457e-05, 2.28967783814713e-05,   2.30785389811178e-05, &
   & 2.30321976080909e-05, 2.28236073720349e-05,   2.25005881105292e-05, 2.20981015361991e-05, 2.16418427448104e-05, &
   & 2.11507649256221e-05, 2.06388749782171e-05, 2.01165241997082e-05/
data beta(1,3), beta(2,3), beta(3,3), beta(4,3), beta(5,3),   beta(6,3), beta(7,3), beta(8,3), beta(9,3), beta(10,3),   beta(11,3) &
   & ,beta(12,3),beta(13,3),beta(14,3),beta(15,3),   beta(16,3),beta(17,3),beta(18,3),beta(19,3),beta(20,3),   beta(21,3),beta(22, &
   & 3),beta(23,3),beta(24,3),beta(25,3),   beta(26,3)     / 5.52213076721293e-04, 4.47932581552385e-04,   2.79520653992021e-04, &
   & 1.52468156198447e-04, 6.93271105657044e-05,   1.76258683069991e-05,-1.35744996343269e-05,-3.17972413350427e-05,   - &
   & 4.18861861696693e-05,-4.69004889379141e-05,-4.87665447413787e-05,   -4.87010031186735e-05,-4.74755620890087e-05,- &
   & 4.55813058138628e-05,   -4.33309644511266e-05,-4.09230193157750e-05,-3.84822638603221e-05,   -3.60857167535411e-05,- &
   & 3.37793306123367e-05,-3.15888560772110e-05,   -2.95269561750807e-05,-2.75978914828336e-05,-2.58006174666884e-05,   - &
   & 2.41308356761280e-05,-2.25823509518346e-05,-2.11479656768913e-05/
data beta(1,4), beta(2,4), beta(3,4), beta(4,4), beta(5,4),   beta(6,4), beta(7,4), beta(8,4), beta(9,4), beta(10,4),   beta(11,4) &
   & ,beta(12,4),beta(13,4),beta(14,4),beta(15,4),   beta(16,4),beta(17,4),beta(18,4),beta(19,4),beta(20,4),   beta(21,4),beta(22, &
   & 4),beta(23,4),beta(24,4),beta(25,4),   beta(26,4)     /-4.74617796559960e-04,-4.77864567147321e-04,   -3.20390228067038e-04,- &
   & 1.61105016119962e-04,-4.25778101285435e-05,   3.44571294294968e-05, 7.97092684075675e-05, 1.03138236708272e-04, &
   & 1.12466775262204e-04, 1.13103642108481e-04, 1.08651634848774e-04,   1.01437951597662e-04, 9.29298396593364e-05, &
   & 8.40293133016090e-05,   7.52727991349134e-05, 6.69632521975731e-05, 5.92564547323195e-05,   5.22169308826976e-05, &
   & 4.58539485165361e-05, 4.01445513891487e-05,   3.50481730031328e-05, 3.05157995034347e-05, 2.64956119950516e-05, &
   & 2.29363633690998e-05, 1.97893056664022e-05, 1.70091984636413e-05/
data beta(1,5), beta(2,5), beta(3,5), beta(4,5), beta(5,5),   beta(6,5), beta(7,5), beta(8,5), beta(9,5), beta(10,5),   beta(11,5) &
   & ,beta(12,5),beta(13,5),beta(14,5),beta(15,5),   beta(16,5),beta(17,5),beta(18,5),beta(19,5),beta(20,5),   beta(21,5),beta(22, &
   & 5),beta(23,5),beta(24,5),beta(25,5),   beta(26,5)     / 7.36465810572578e-04, 8.72790805146194e-04,   6.22614862573135e-04, &
   & 2.85998154194304e-04, 3.84737672879366e-06,   -1.87906003636972e-04,-2.97603646594555e-04,-3.45998126832656e-04,   - &
   & 3.53382470916038e-04,-3.35715635775049e-04,-3.04321124789040e-04,   -2.66722723047613e-04,-2.27654214122820e-04,- &
   & 1.89922611854562e-04,   -1.55058918599094e-04,-1.23778240761874e-04,-9.62926147717644e-05,   -7.25178327714425e-05,- &
   & 5.22070028895634e-05,-3.50347750511901e-05,   -2.06489761035552e-05,-8.70106096849767e-06, 1.13698686675100e-06, &
   & 9.16426474122779e-06, 1.56477785428873e-05, 2.08223629482467e-05/
data gama(1),   gama(2),   gama(3),   gama(4),   gama(5), &
   & gama(6),   gama(7),   gama(8),   gama(9),   gama(10), &
   & gama(11),  gama(12),  gama(13),  gama(14),  gama(15), &
   & gama(16),  gama(17),  gama(18),  gama(19),  gama(20), &
   & gama(21),  gama(22),  gama(23),  gama(24),  gama(25), &
   & gama(26)        / 6.29960524947437e-01, 2.51984209978975e-01, &
   & 1.54790300415656e-01, 1.10713062416159e-01, 8.57309395527395e-02, &
   & 6.97161316958684e-02, 5.86085671893714e-02, 5.04698873536311e-02, &
   & 4.42600580689155e-02, 3.93720661543510e-02, 3.54283195924455e-02, &
   & 3.21818857502098e-02, 2.94646240791158e-02, 2.71581677112934e-02, &
   & 2.51768272973862e-02, 2.34570755306079e-02, 2.19508390134907e-02, &
   & 2.06210828235646e-02, 1.94388240897881e-02, 1.83810633800683e-02, &
   & 1.74293213231963e-02, 1.65685837786612e-02, 1.57865285987918e-02, &
   & 1.50729501494096e-02, 1.44193250839955e-02, 1.38184805735342e-02/
!     ------------------------------------------------------------------
fn = fnu
iflw = 0
do jn = 1,in
   xx = x/fn
   wk(1) = 1.0e0 - xx*xx
   abw2 = abs(wk(1))
   wk(2) = sqrt(abw2)
   wk(7) = fn**con2
   if (abw2 > 0.27750e0) go to 80
!     Asymptotic expansion
!     cases near x=FN, abs(1.-(x/FN)**2).LE.0.2775
!     coefficients of asymptotic expansion by series
!     zeta and truncation for A(ZETA) and B(ZETA) series
!     kmax is truncation index for A(ZETA) and B(ZETA) series=max(2,SA)
   sa = 0.0e0
   if (abw2 == 0.0e0) go to 10
   sa = tols/log(abw2)
10 sb = sa
   do i = 1,5
      akm = max(sa,2.0e0)
      kmax(i) = int(akm)
      sa = sa + sb
   end do
   kb = kmax(5)
   klast = kb - 1
   sa = gama(kb)
   do k = 1,klast
      kb = kb - 1
      sa = sa*wk(1) + gama(kb)
   end do
   z = wk(1)*sa
   az = abs(z)
   rtz = sqrt(az)
   wk(3) = con1*az*rtz
   wk(4) = wk(3)*fn
   wk(5) = rtz*wk(7)
   wk(6) = -wk(5)*wk(5)
   if (z <= 0.0e0) go to 35
   if (wk(4) > elim) go to 75
   wk(6) = -wk(6)
35 continue
   phi = sqrt(sqrt(sa + sa + sa + sa))
!     B(ZETA) FOR S=0
   kb = kmax(5)
   klast = kb - 1
   sb = beta(kb,1)
   do k = 1,klast
      kb = kb - 1
      sb = sb*wk(1) + beta(kb,1)
   end do
   ksp1 = 1
   fn2 = fn*fn
   rfn2 = 1.0e0/fn2
   rden = 1.0e0
   asum = 1.0e0
   relb = tol*abs(sb)
   bsum = sb
   do ks = 1,4
      ksp1 = ksp1 + 1
      rden = rden*rfn2
!     A(ZETA) and B(ZETA) for S=1,2,3,4
      kstemp = 5 - ks
      kb = kmax(kstemp)
      klast = kb - 1
      sa = alfa(kb,ks)
      sb = beta(kb,ksp1)
      do k = 1,klast
         kb = kb - 1
         sa = sa*wk(1) + alfa(kb,ks)
         sb = sb*wk(1) + beta(kb,ksp1)
      end do
      ta = sa*rden
      tb = sb*rden
      asum = asum + ta
      bsum = bsum + tb
      if ( abs ( ta ) <= tol .and. abs ( tb ) <= relb ) exit
   end do
   bsum = bsum/(fn*wk(7))
   go to 160
75 continue
   iflw = 1
   return
80 continue
   upol(1) = 1.0e0
   tau = 1.0e0/wk(2)
   t2 = 1.0e0/wk(1)
   if (wk(1) >= 0.0e0) go to 90
!     CASES FOR (x/FN).GT.sqrt(1.2775)
   wk(3) = abs(wk(2) - atan(wk(2)))
   wk(4) = wk(3)*fn
   rcz = -con1/wk(4)
   z32 = 1.5e0*wk(3)
   rtz = z32**con2
   wk(5) = rtz*wk(7)
   wk(6) = -wk(5)*wk(5)
   go to 100
90 continue
!     CASES FOR (x/FN).LT.sqrt(0.7225)
   wk(3) = abs(log((1.0e0 + wk(2))/xx) - wk(2))
   wk(4) = wk(3)*fn
   rcz = con1/wk(4)
   if (wk(4) > elim) go to 75
   z32 = 1.5e0*wk(3)
   rtz = z32**con2
   wk(7) = fn**con2
   wk(5) = rtz*wk(7)
   wk(6) = wk(5)*wk(5)
100 continue
   phi = sqrt((rtz + rtz)*tau)
   tb = 1.0e0
   asum = 1.0e0
   tfn = tau/fn
   upol(2) = (c(1)*t2 + c(2))*tfn
   crz32 = con548*rcz
   bsum = upol(2) + crz32
   relb = tol*abs(bsum)
   ap = tfn
   ks = 0
   kp1 = 2
   rzden = rcz
   l = 2
   do lr = 2,8,2
!     Compute two U polynomials for next A(ZETA) and B(ZETA)
      lrp1 = lr + 1
      do k = lr,lrp1
         ks = ks + 1
         kp1 = kp1 + 1
         l = l + 1
         s1 = c(l)
         do j = 2,kp1
            l = l + 1
            s1 = s1*t2 + c(l)
         end do
         ap = ap*tfn
         upol(kp1) = ap*s1
         cr(ks) = br(ks)*rzden
         rzden = rzden*rcz
         dr(ks) = ar(ks)*rzden
      end do
      suma = upol(lrp1)
      sumb = upol(lr + 2) + upol(lrp1)*crz32
      ju = lrp1
      do jr = 1,lr
         ju = ju - 1
         suma = suma + cr(jr)*upol(ju)
         sumb = sumb + dr(jr)*upol(ju)
      end do
      tb = -tb
      if (wk(1) > 0.0e0) tb = abs(tb)
      asum = asum + suma*tb
      bsum = bsum + sumb*tb
      if ( abs ( suma ) <= tol .and. abs ( sumb ) <= relb ) exit
   end do
   tb = wk(5)
   if (wk(1) > 0.0e0) tb = -tb
   bsum = bsum/tb
160 continue
   call funjy(wk(6), wk(5), wk(4), fi, dfi)
   y(jn) = flgjy*phi*(fi*asum + dfi*bsum)/wk(7)
   fn = fn - flgjy
end do
end subroutine asjy

pure subroutine jairy(x,rx,c,ai,dai)
implicit none
real, intent(inout) :: ai
real, intent(in) :: c
real, intent(inout) :: dai
real, intent(in) :: rx, x
integer :: i, j
real :: ccv, cv, e1, e2, ec, f1, f2, rtrx, scv, t, temp1, temp2, tt
integer, parameter :: n1 = 14
integer, parameter :: n2 = 23
integer, parameter :: n3 = 19
integer, parameter :: n4 = 15
integer, parameter :: m1 = 12
integer, parameter :: m2 = 21
integer, parameter :: m3 = 17
integer, parameter :: m4 = 13
real, parameter :: fpi12 = 1.30899693899575e+00
real, parameter :: con1 = 6.66666666666667e-01
real, parameter :: con2 = 5.03154716196777e+00
real, parameter :: con3 = 3.80004589867293e-01
real, parameter :: con4 = 8.33333333333333e-01
real, parameter :: con5 = 8.66025403784439e-01
real, parameter :: ak1(14) = [2.20423090987793e-01, -1.25290242787700e-01, 1.03881163359194e-02, 8.22844152006343e-04, - &
   & 2.34614345891226e-04, 1.63824280172116e-05, 3.06902589573189e-07, -1.29621999359332e-07, 8.22908158823668e-09, &
   & 1.53963968623298e-11, -3.39165465615682e-11, 2.03253257423626e-12, -1.10679546097884e-14, -5.16169497785080e-15]
real, parameter :: ak2(23) = [2.74366150869598e-01, 5.39790969736903e-03, -1.57339220621190e-03, 4.27427528248750e-04, - &
   & 1.12124917399925e-04, 2.88763171318904e-05, -7.36804225370554e-06, 1.87290209741024e-06, -4.75892793962291e-07, &
   & 1.21130416955909e-07, -3.09245374270614e-08, 7.92454705282654e-09, -2.03902447167914e-09, 5.26863056595742e-10, - &
   & 1.36704767639569e-10, 3.56141039013708e-11, -9.31388296548430e-12, 2.44464450473635e-12, -6.43840261990955e-13, &
   & 1.70106030559349e-13, -4.50760104503281e-14, 1.19774799164811e-14, -3.19077040865066e-15]
real, parameter :: ak3(14) = [2.80271447340791e-01, -1.78127042844379e-03, 4.03422579628999e-05, -1.63249965269003e-06, &
   & 9.21181482476768e-08, -6.52294330229155e-09, 5.47138404576546e-10, -5.24408251800260e-11, 5.60477904117209e-12, - &
   & 6.56375244639313e-13, 8.31285761966247e-14, -1.12705134691063e-14, 1.62267976598129e-15, -2.46480324312426e-16]
real, parameter :: ajp(19) = [7.78952966437581e-02, -1.84356363456801e-01, 3.01412605216174e-02, 3.05342724277608e-02, - &
   & 4.95424702513079e-03, -1.72749552563952e-03, 2.43137637839190e-04, 5.04564777517082e-05, -6.16316582695208e-06, - &
   & 9.03986745510768e-07, 9.70243778355884e-08, 1.09639453305205e-08, -1.04716330588766e-09, -9.60359441344646e-11, &
   & 8.25358789454134e-12, 6.36123439018768e-13, -4.96629614116015e-14, -3.29810288929615e-15, 2.35798252031104e-16]
real, parameter :: ajn(19) = [3.80497887617242e-02, -2.45319541845546e-01, 1.65820623702696e-01, 7.49330045818789e-02, - &
   & 2.63476288106641e-02, -5.92535597304981e-03, 1.44744409589804e-03, 2.18311831322215e-04, -4.10662077680304e-05, - &
   & 4.66874994171766e-06, 7.15218807277160e-07, 6.52964770854633e-08, -8.44284027565946e-09, -6.44186158976978e-10, &
   & 7.20802286505285e-11, 4.72465431717846e-12, -4.66022632547045e-13, -2.67762710389189e-14, 2.36161316570019e-15]
real, parameter :: a(15) = [4.90275424742791e-01, 1.57647277946204e-03, -9.66195963140306e-05, 1.35916080268815e-07, &
   & 2.98157342654859e-07, -1.86824767559979e-08, -1.03685737667141e-09, 3.28660818434328e-10, -2.57091410632780e-11, - &
   & 2.32357655300677e-12, 9.57523279048255e-13, -1.20340828049719e-13, -2.90907716770715e-15, 4.55656454580149e-15, - &
   & 9.99003874810259e-16]
real, parameter :: b(15) = [2.78593552803079e-01, -3.52915691882584e-03, -2.31149677384994e-05, 4.71317842263560e-06, - &
   & 1.12415907931333e-07, -2.00100301184339e-08, 2.60948075302193e-09, -3.55098136101216e-11, -3.50849978423875e-11, &
   & 5.83007187954202e-12, -2.04644828753326e-13, -1.10529179476742e-13, 2.87724778038775e-14, -2.88205111009939e-15, - &
   & 3.32656311696166e-16]
integer, parameter :: n1d = 14
integer, parameter :: n2d = 24
integer, parameter :: n3d = 19
integer, parameter :: n4d = 15
integer, parameter :: m1d = 12
integer, parameter :: m2d = 22
integer, parameter :: m3d = 17
integer, parameter :: m4d = 13
real, parameter :: dak1(14) = [2.04567842307887e-01, -6.61322739905664e-02, -8.49845800989287e-03, 3.12183491556289e-03, - &
   & 2.70016489829432e-04, -6.35636298679387e-06, 3.02397712409509e-06, -2.18311195330088e-07, -5.36194289332826e-10, &
   & 1.13098035622310e-09, -7.43023834629073e-11, 4.28804170826891e-13, 2.23810925754539e-13, -1.39140135641182e-14]
real, parameter :: dak2(24) = [2.93332343883230e-01, -8.06196784743112e-03, 2.42540172333140e-03, -6.82297548850235e-04, &
   & 1.85786427751181e-04, -4.97457447684059e-05, 1.32090681239497e-05, -3.49528240444943e-06, 9.24362451078835e-07, - &
   & 2.44732671521867e-07, 6.49307837648910e-08, -1.72717621501538e-08, 4.60725763604656e-09, -1.23249055291550e-09, &
   & 3.30620409488102e-10, -8.89252099772401e-11, 2.39773319878298e-11, -6.48013921153450e-12, 1.75510132023731e-12, - &
   & 4.76303829833637e-13, 1.29498241100810e-13, -3.52679622210430e-14, 9.62005151585923e-15, -2.62786914342292e-15]
real, parameter :: dak3(14) = [2.84675828811349e-01, 2.53073072619080e-03, -4.83481130337976e-05, 1.84907283946343e-06, - &
   & 1.01418491178576e-07, 7.05925634457153e-09, -5.85325291400382e-10, 5.56357688831339e-11, -5.90889094779500e-12, &
   & 6.88574353784436e-13, -8.68588256452194e-14, 1.17374762617213e-14, -1.68523146510923e-15, 2.55374773097056e-16]
real, parameter :: dajp(19) = [6.53219131311457e-02, -1.20262933688823e-01, 9.78010236263823e-03, 1.67948429230505e-02, - &
   & 1.97146140182132e-03, -8.45560295098867e-04, 9.42889620701976e-05, 2.25827860945475e-05, -2.29067870915987e-06, - &
   & 3.76343991136919e-07, 3.45663933559565e-08, 4.29611332003007e-09, -3.58673691214989e-10, -3.57245881361895e-11, &
   & 2.72696091066336e-12, 2.26120653095771e-13, -1.58763205238303e-14, -1.12604374485125e-15, 7.31327529515367e-17]
real, parameter :: dajn(19) = [1.08594539632967e-02, 8.53313194857091e-02, -3.15277068113058e-01, -8.78420725294257e-02, &
   & 5.53251906976048e-02, 9.41674060503241e-03, -3.32187026018996e-03, -4.11157343156826e-04, 1.01297326891346e-04, &
   & 9.87633682208396e-06, -1.87312969812393e-06, -1.50798500131468e-07, 2.32687669525394e-08, 1.59599917419225e-09, - &
   & 2.07665922668385e-10, -1.24103350500302e-11, 1.39631765331043e-12, 7.39400971155740e-14, -7.32887475627500e-15]
real, parameter :: da(15) = [4.91627321104601e-01, 3.11164930427489e-03, 8.23140762854081e-05, -4.61769776172142e-06, - &
   & 6.13158880534626e-08, 2.87295804656520e-08, -1.81959715372117e-09, -1.44752826642035e-10, 4.53724043420422e-11, - &
   & 3.99655065847223e-12, -3.24089119830323e-13, 1.62098952568741e-13, -2.40765247974057e-14, 1.69384811284491e-16, &
   & 8.17900786477396e-16]
real, parameter :: db(15) = [-2.77571356944231e-01, 4.44212833419920e-03, -8.42328522190089e-05, -2.58040318418710e-06, &
   & 3.42389720217621e-07, -6.24286894709776e-09, -2.36377836844577e-09, 3.16991042656673e-10, -4.40995691658191e-12, - &
   & 5.18674221093575e-12, 9.64874015137022e-13, -4.90190576608710e-14, -1.77253430678112e-14, 5.55950610442662e-15, - &
   & 7.11793337579530e-16]
!                  jairy computes the Airy function ai(x)
!                   and its derivative dai(x) for JBESS
!                                   input
!         x - Argument, computed by JBESS, x unrestricted
!        rx - rx=sqrt(abs(x)), computed by JBESS
!         c - c=2.*(abs(x)**1.5)/3., Computed by JBESS
!                                  output
!        ai - Value of function ai(x)
!       dai - Value of the derivative dai(x)
!                                written by
!                                D. E. Amos
!                               S. L. Daniel
!                               M. K. Weston
!     -------------------
if (x < 0.) go to 300
if (c > 5.) go to 200
if (x > 1.2) go to 150
t = (x + x - 1.2)*con4
tt = t + t
j = n1
f1 = ak1(j)
f2 = 0.
do i = 1,m1
   j = j - 1
   temp1 = f1
   f1 = tt*f1 - f2 + ak1(j)
   f2 = temp1
end do
ai = t*f1 - f2 + ak1(1)
j = n1d
f1 = dak1(j)
f2 = 0.
do i = 1,m1d
   j = j - 1
   temp1 = f1
   f1 = tt*f1 - f2 + dak1(j)
   f2 = temp1
end do
dai = -(t*f1 - f2 + dak1(1))
return
150 continue
t = (x + x - con2)*con3
tt = t + t
j = n2
f1 = ak2(j)
f2 = 0.
do i = 1,m2
   j = j - 1
   temp1 = f1
   f1 = tt*f1 - f2 + ak2(j)
   f2 = temp1
end do
rtrx = sqrt(rx)
ec = exp(-c)
ai = ec*(t*f1 - f2 + ak2(1))/rtrx
j = n2d
f1 = dak2(j)
f2 = 0.
do i = 1,m2d
   j = j - 1
   temp1 = f1
   f1 = tt*f1 - f2 + dak2(j)
   f2 = temp1
end do
dai = -ec*(t*f1 - f2 + dak2(1))*rtrx
return
200 continue
t = 10./c - 1.
tt = t + t
j = n1
f1 = ak3(j)
f2 = 0.
do i = 1,m1
   j = j - 1
   temp1 = f1
   f1 = tt*f1 - f2 + ak3(j)
   f2 = temp1
end do
rtrx = sqrt(rx)
ec = exp(-c)
ai = ec*(t*f1 - f2 + ak3(1))/rtrx
j = n1d
f1 = dak3(j)
f2 = 0.
do i = 1,m1d
   j = j - 1
   temp1 = f1
   f1 = tt*f1 - f2 + dak3(j)
   f2 = temp1
end do
dai = -rtrx*ec*(t*f1 - f2 + dak3(1))
return
300 continue
if (c > 5.) go to 350
t = .4*c - 1.
tt = t + t
j = n3
f1 = ajp(j)
e1 = ajn(j)
f2 = 0.
e2 = 0.
do i = 1,m3
   j = j - 1
   temp1 = f1
   temp2 = e1
   f1 = tt*f1 - f2 + ajp(j)
   e1 = tt*e1 - e2 + ajn(j)
   f2 = temp1
   e2 = temp2
end do
ai = (t*e1 - e2 + ajn(1)) - x*(t*f1 - f2 + ajp(1))
j = n3d
f1 = dajp(j)
e1 = dajn(j)
f2 = 0.
e2 = 0.
do i = 1,m3d
   j = j - 1
   temp1 = f1
   temp2 = e1
   f1 = tt*f1 - f2 + dajp(j)
   e1 = tt*e1 - e2 + dajn(j)
   f2 = temp1
   e2 = temp2
end do
dai = x*x*(t*f1 - f2 + dajp(1)) + (t*e1 - e2 + dajn(1))
return
350 continue
t = 10./c - 1.
tt = t + t
j = n4
f1 = a(j)
e1 = b(j)
f2 = 0.
e2 = 0.
do i = 1,m4
   j = j - 1
   temp1 = f1
   temp2 = e1
   f1 = tt*f1 - f2 + a(j)
   e1 = tt*e1 - e2 + b(j)
   f2 = temp1
   e2 = temp2
end do
temp1 = t*f1 - f2 + a(1)
temp2 = t*e1 - e2 + b(1)
rtrx = sqrt(rx)
cv = c - fpi12
ccv = cos(cv)
scv = sin(cv)
ai = (temp1*ccv - temp2*scv)/rtrx
j = n4d
f1 = da(j)
e1 = db(j)
f2 = 0.
e2 = 0.
do i = 1,m4d
   j = j - 1
   temp1 = f1
   temp2 = e1
   f1 = tt*f1 - f2 + da(j)
   e1 = tt*e1 - e2 + db(j)
   f2 = temp1
   e2 = temp2
end do
temp1 = t*f1 - f2 + da(1)
temp2 = t*e1 - e2 + db(1)
e1 = ccv*con5 + .5*scv
e2 = scv*con5 - .5*ccv
dai = (temp1*e1 - temp2*e2)*rtrx
end subroutine jairy

pure elemental subroutine bssly(a, in, w)
implicit none
integer, intent(in) :: in
complex, intent(in) :: a
complex, intent(inout) :: w
integer :: i, la, lr, ly, m, n
real :: an, aq(2), az(2), pm, pn, qf(2), qm, qn, qz(2), rm, rn, rz(2), sl(2), sm(4), sn, sq(2), sr(2), ss, sz(2), tm(4), ts(2), zl &
   & (2), zs
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
!     Fortran subroutine for ordinary Bessel function of integral order
!     ******************************************************************
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
sn = 1.0
if ( ( in ) < 0 ) go to 002
go to 003
002 if (in == in/2*2) go to 003
sn = -1.0
003 if ( ( az ( 1 ) ) < 0 ) go to 004
go to 005
004 qz(1) = -az(1)
qz(2) = -az(2)
go to 006
005 qz(1) = az(1)
qz(2) = az(2)
006 if ( ( zs - 1.0 ) <= 0 ) go to 020
go to 007
007 if ( ( zs - 289.0 ) < 0 ) go to 008
go to 010
008 if ( ( - abs ( az ( 2 ) ) + 0.096 * az ( 1 ) * az ( 1 ) ) <= 0 ) &
   & go to 020
go to 015
010 qm = sn*0.797884560802865*exp(-0.5*zl(1))
qf(1) = qm*cos(-0.5*zl(2))
qf(2) = qm*sin(-0.5*zl(2))
if (an > 1.0) go to 012
pn = an
la = 11
go to 100
011 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
012 pn = 1.0
la = 13
go to 100
013 sq(1) = -qf(1)*sm(1) + qf(2)*sm(2)
sq(2) = -qf(1)*sm(2) - qf(2)*sm(1)
pn = 0.0
la = 14
go to 100
014 sr(1) = qf(1)*sm(1) - qf(2)*sm(2)
sr(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 026
015 qm = sn*0.3989422804014327*exp(-0.5*zl(1))
qf(1) = qm*cos(-0.5*zl(2))
qf(2) = qm*sin(-0.5*zl(2))
if (an > 1.0) go to 017
pn = an
lr = 16
go to 112
016 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
017 pn = 1.0
lr = 18
go to 112
018 sq(1) = -qf(1)*sm(1) + qf(2)*sm(2)
sq(2) = -qf(1)*sm(2) - qf(2)*sm(1)
pn = 0.0
lr = 19
go to 112
019 sr(1) = qf(1)*sm(1) - qf(2)*sm(2)
sr(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 026
020 qf(1) = sn*0.6366197723675813
qf(2) = 0.0
if (an > 1.0) go to 023
pn = an
ly = 22
go to 122
022 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
023 pn = 1.0
ly = 24
go to 122
024 sq(1) = -qf(1)*sm(1) + qf(2)*sm(2)
sq(2) = -qf(1)*sm(2) - qf(2)*sm(1)
pn = 0.0
ly = 25
go to 122
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
028 sm(1) = 2.0*pn*(rz(1)*sr(1) - rz(2)*sr(2)) - sq(1)
sm(2) = 2.0*pn*(rz(1)*sr(2) + rz(2)*sr(1)) - sq(2)
pn = pn + 1.0
if (pn < an) go to 027
029 w = cmplx(sm(1),sm(2))
return
100 sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
rz(1) = 0.5*qz(1)/zs
rz(2) = -0.5*qz(2)/zs
qn = pn*pn - 0.25
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
go to 102
101 qn = qn - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = -qn*ts(1)/pm
tm(2) = -qn*ts(2)/pm
102 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
qn = qn - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = qn*ts(1)/pm
tm(2) = qn*ts(2)/pm
if (abs(sm(3)) + abs(tm(1)) /= abs(sm(3))) go to 103
if (abs(sm(4)) + abs(tm(2)) == abs(sm(4))) go to 104
103 sm(3) = sm(3) + tm(1)
sm(4) = sm(4) + tm(2)
if (pm < 35.0) go to 101
104 aq(1) = qz(1) - 1.57079632679490*(pn + 0.5)
aq(2) = qz(2)
ts(1) = cos(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = -sin(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
tm(1) = sm(1)*ts(1) - sm(2)*ts(2)
tm(2) = sm(1)*ts(2) + sm(2)*ts(1)
tm(3) = sm(3)*ts(1) - sm(4)*ts(2)
tm(4) = sm(3)*ts(2) + sm(4)*ts(1)
ts(1) = sin(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = cos(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
tm(1) = tm(1) - sm(3)*ts(1) + sm(4)*ts(2)
tm(2) = tm(2) - sm(3)*ts(2) - sm(4)*ts(1)
tm(3) = tm(3) + sm(1)*ts(1) - sm(2)*ts(2)
tm(4) = tm(4) + sm(1)*ts(2) + sm(2)*ts(1)
if ( ( az ( 1 ) ) < 0 ) go to 106
go to 110
106 if ( ( az ( 2 ) ) < 0 ) go to 107
go to 108
107 sm(1) = -2.0*tm(1) + tm(4)
sm(2) = -2.0*tm(2) - tm(3)
go to 109
108 sm(1) = -2.0*tm(1) - tm(4)
sm(2) = -2.0*tm(2) + tm(3)
109 if (pn == 0.0) go to 111
sm(1) = -sm(1)
sm(2) = -sm(2)
go to 111
110 sm(1) = tm(3)
sm(2) = tm(4)
111 select case ( la )
case ( 11 )
   go to 11
case ( 13 )
   go to 13
case ( 14 )
   go to 14
end select
112 sm(1) = 1.0
sm(2) = 0.0
sm(3) = 1.0
sm(4) = 0.0
m = 15.0*pn + 2.0
n = 15.0*pn + 15.0
do i = m,n
   ts(1) = qz(2) - cd(i)
   ts(2) = -qz(1)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   ts(1) = -qz(2) - cd(i)
   ts(2) = qz(1)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(3) = sm(3) + tm(1)
   sm(4) = sm(4) + tm(2)
end do
aq(1) = qz(1) - 1.57079632679490*(pn + 0.5)
aq(2) = qz(2)
ts(1) = cos(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = -sin(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
tm(1) = ts(1)*sm(1) - ts(2)*sm(2) + ts(1)*sm(3) - ts(2)*sm(4)
tm(2) = ts(1)*sm(2) + ts(2)*sm(1) + ts(1)*sm(4) + ts(2)*sm(3)
tm(3) = ts(1)*sm(2) + ts(2)*sm(1) - ts(1)*sm(4) - ts(2)*sm(3)
tm(4) = -ts(1)*sm(1) + ts(2)*sm(2) + ts(1)*sm(3) - ts(2)*sm(4)
ts(1) = sin(aq(1))*0.5*(exp(+aq(2)) + exp(-aq(2)))
ts(2) = cos(aq(1))*0.5*(exp(+aq(2)) - exp(-aq(2)))
tm(1) = tm(1) - ts(1)*sm(2) - ts(2)*sm(1) + ts(1)*sm(4) + ts(2)*sm(3)
tm(2) = tm(2) + ts(1)*sm(1) - ts(2)*sm(2) - ts(1)*sm(3) + ts(2)*sm(4)
tm(3) = tm(3) + ts(1)*sm(1) - ts(2)*sm(2) + ts(1)*sm(3) - ts(2)*sm(4)
tm(4) = tm(4) + ts(1)*sm(2) + ts(2)*sm(1) + ts(1)*sm(4) + ts(2)*sm(3)
if ( ( az ( 1 ) ) < 0 ) go to 116
go to 120
116 if ( ( az ( 2 ) ) < 0 ) go to 117
go to 118
117 sm(1) = -2.0*tm(1) + tm(4)
sm(2) = -2.0*tm(2) - tm(3)
go to 119
118 sm(1) = -2.0*tm(1) - tm(4)
sm(2) = -2.0*tm(2) + tm(3)
119 if (pn == 0.0) go to 121
sm(1) = -sm(1)
sm(2) = -sm(2)
go to 121
120 sm(1) = tm(3)
sm(2) = tm(4)
121 select case ( lr )
case ( 16 )
   go to 16
case ( 18 )
   go to 18
case ( 19 )
   go to 19
end select
122 aq(1) = 1.0
aq(2) = 0.0
rn = 0.0
pm = 0.0
go to 124
123 pm = pm + 1.0
rn = rn + 0.5/pm
ts(1) = 0.5*(az(1)*aq(1) - az(2)*aq(2))
ts(2) = 0.5*(az(1)*aq(2) + az(2)*aq(1))
aq(1) = ts(1)/pm
aq(2) = ts(2)/pm
124 if (pm < pn) go to 123
sz(1) = 0.25*(az(1) - az(2))*(az(1) + az(2))
sz(2) = 0.5*az(1)*az(2)
sr(1) = 0.0
sr(2) = 0.0
ss = aq(1)*aq(1) + aq(2)*aq(2)
tm(1) = aq(1)/ss
tm(2) = -aq(2)/ss
pm = 0.0
go to 126
125 tm(1) = tm(1)/(pn - pm)
tm(2) = tm(2)/(pn - pm)
sr(1) = sr(1) - 0.5*tm(1)
sr(2) = sr(2) - 0.5*tm(2)
pm = pm + 1.0
ts(1) = sz(1)*tm(1) - sz(2)*tm(2)
ts(2) = sz(1)*tm(2) + sz(2)*tm(1)
tm(1) = ts(1)/pm
tm(2) = ts(2)/pm
126 if (pm < pn) go to 125
sm(1) = 0.0
sm(2) = 0.0
rm = 1.0
qm = 0.0
sl(1) = -0.115931515658412 + zl(1) - rn
sl(2) = zl(2)
pm = 0.0
go to 128
127 qm = qm + rm
pm = pm + 1.0
rm = 0.25*zs*rm/(pm*(pn + pm))
ts(1) = sz(1)*aq(1) - sz(2)*aq(2)
ts(2) = sz(1)*aq(2) + sz(2)*aq(1)
aq(1) = -ts(1)/(pm*(pn + pm))
aq(2) = -ts(2)/(pm*(pn + pm))
sl(1) = sl(1) - 0.5/pm - 0.5/(pn + pm)
128 tm(1) = aq(1)*sl(1) - aq(2)*sl(2)
tm(2) = aq(1)*sl(2) + aq(2)*sl(1)
sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (qm + rm > qm) go to 127
sm(1) = sr(1) + sm(1)
sm(2) = sr(2) + sm(2)
select case ( ly )
case ( 22 )
   go to 22
case ( 24 )
   go to 24
case ( 25 )
   go to 25
end select
end subroutine bssly

subroutine cbssli(z, cnu, w)
implicit none
complex, intent(in) :: z, cnu
complex, intent(inout) :: w
real :: t, x, y
complex :: nu, z0
real, parameter :: pihalf = 1.5707963267949
interface
   pure elemental function cos1(x)
      implicit none
      real, intent(in) :: x
      real :: cos1
   end function cos1
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental function sin1(x)
      implicit none
      real, intent(in) :: x
      real :: sin1
   end function sin1
end interface
!------------------------------------------------------------
!     Calculation of the modified Bessel function of the
!     first kind for complex order cnu and complex argument
!     z.  it is assumed that -Pi .LT. arg z .LE. pi.
!------------------------------------------------------------
x = real(z)
y = aimag(z)
if (y < 0.0) go to 10
z0 = cmplx(y, -x)
nu = cnu
go to 20
10 z0 = cmplx(-y, x)
nu = -cnu
20 t = -pihalf*aimag(nu)
if (t > exparg(1)) go to 30
w = (0.0, 0.0)
return
30 call cbsslj(z0, cnu, w)
w = exp(t)*w
t = 0.5*real(nu)
w = w*cmplx(cos1(t),sin1(t))
end subroutine cbssli

pure elemental subroutine bssli(mo, a, in, w)
implicit none
integer, intent(in) :: in, mo
complex, intent(in) :: a
complex, intent(inout) :: w
integer :: i, m, n
real :: an, aq(2), az(2), fi(2), pm, pn, qf(2), qm, qn, qz(2), rm(4), rz(2), sm(4), sn, ss, sz(2), tm(2), ts(2), zm, zr(2), zs
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
!     w  = Function of first kind (complex number)
!     -------------------
!     -------------------
az(1) = real(a)
az(2) = aimag(a)
zs = az(1)*az(1) + az(2)*az(2)
zm = sqrt(zs)
pn = abs(in)
sn = 1.0
if ( ( az ( 1 ) ) < 0 ) go to 002
go to 003
002 qz(1) = -az(1)
qz(2) = -az(2)
if (in == in/2*2) go to 004
sn = -1.0
go to 004
003 qz(1) = az(1)
qz(2) = az(2)
004 if (zm <= 17.5 + 0.5*pn*pn) go to 005
qn = pn
go to 011
005 qn = 0.5*zm - 0.5*abs(qz(1)) + 0.5*abs(0.5*zm - abs(qz(1)))
if (pn <= qn) go to 006
qn = aint(0.0625*zs)
if (pn <= qn) go to 039
qn = pn
go to 039
006 if (zm <= 17.5) go to 007
qn = aint(sqrt(2.0*(zm - 17.5)))
go to 011
007 if ( ( zs - 1.0 ) < 0 ) go to 009
go to 008
008 if ( ( - abs ( az ( 1 ) ) + 0.096 * az ( 2 ) * az ( 2 ) ) < 0 ) &
   & go to 009
go to 010
009 qn = aint(0.0625*zs)
if (pn <= qn) go to 039
qn = pn
go to 039
010 qn = 0.0
011 sz(1) = qz(1)
sz(2) = qz(2)
qm = sn*0.398942280401433
zr(1) = sqrt(sz(1) + zm)
zr(2) = sz(2)/zr(1)
zr(1) = 0.707106781186548*zr(1)
zr(2) = 0.707106781186548*zr(2)
qf(1) = qm*zr(1)/zm
qf(2) = -qm*zr(2)/zm
if (zm <= 17.5) go to 017
rz(1) = 0.5*qz(1)/zs
rz(2) = -0.5*qz(2)/zs
an = qn*qn - 0.25
sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
go to 014
013 an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = an*ts(1)/pm
tm(2) = an*ts(2)/pm
014 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = an*ts(1)/pm
tm(2) = an*ts(2)/pm
if (abs(sm(3)) + abs(tm(1)) /= abs(sm(3))) go to 015
if (abs(sm(4)) + abs(tm(2)) == abs(sm(4))) go to 016
015 sm(3) = sm(3) + tm(1)
sm(4) = sm(4) + tm(2)
if (pm < 35.0) go to 013
016 ts(1) = sm(1) + sm(3)
ts(2) = sm(2) + sm(4)
sm(1) = sm(1) - sm(3)
sm(2) = sm(2) - sm(4)
sm(3) = ts(1)
sm(4) = ts(2)
go to 019
017 sm(1) = 1.0
sm(2) = 0.0
sm(3) = 1.0
sm(4) = 0.0
m = 15.0*qn + 2.0
n = 15.0*qn + 15.0
do i = m,n
   ts(1) = -qz(1) - cd(i)
   ts(2) = -qz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   ts(1) = qz(1) - cd(i)
   ts(2) = qz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(3) = sm(3) + tm(1)
   sm(4) = sm(4) + tm(2)
end do
019 rm(1) = sm(1)
rm(2) = sm(2)
if (qz(1) >= 17.5) go to 023
aq(1) = -2.0*qz(1)
if ( ( qz ( 2 ) ) < 0 ) go to 020
go to 021
020 aq(2) = -2.0*qz(2) - 3.14159265358979*(qn + 0.5)
go to 022
021 aq(2) = -2.0*qz(2) + 3.14159265358979*(qn + 0.5)
022 qm = exp(aq(1))
ts(1) = qm*cos(aq(2))
ts(2) = qm*sin(aq(2))
rm(1) = rm(1) + ts(1)*sm(3) - ts(2)*sm(4)
rm(2) = rm(2) + ts(1)*sm(4) + ts(2)*sm(3)
023 if (qn == pn) go to 037
rm(3) = rm(1)
rm(4) = rm(2)
qn = qn + 1.0
if (zm <= 17.5) go to 029
an = qn*qn - 0.25
sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
go to 026
025 an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = an*ts(1)/pm
tm(2) = an*ts(2)/pm
026 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
an = an - 2.0*pm
pm = pm + 1.0
ts(1) = tm(1)*rz(1) - tm(2)*rz(2)
ts(2) = tm(1)*rz(2) + tm(2)*rz(1)
tm(1) = an*ts(1)/pm
tm(2) = an*ts(2)/pm
if (abs(sm(3)) + abs(tm(1)) /= abs(sm(3))) go to 027
if (abs(sm(4)) + abs(tm(2)) == abs(sm(4))) go to 028
027 sm(3) = sm(3) + tm(1)
sm(4) = sm(4) + tm(2)
if (pm < 35.0) go to 025
028 ts(1) = sm(1) + sm(3)
ts(2) = sm(2) + sm(4)
sm(1) = sm(1) - sm(3)
sm(2) = sm(2) - sm(4)
sm(3) = ts(1)
sm(4) = ts(2)
go to 031
029 sm(1) = 1.0
sm(2) = 0.0
sm(3) = 1.0
sm(4) = 0.0
m = 15.0*qn + 2.0
n = 15.0*qn + 15.0
do i = m,n
   ts(1) = -qz(1) - cd(i)
   ts(2) = -qz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   ts(1) = qz(1) - cd(i)
   ts(2) = qz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(3) = sm(3) + tm(1)
   sm(4) = sm(4) + tm(2)
end do
031 rm(1) = sm(1)
rm(2) = sm(2)
if (qz(1) >= 17.5) go to 036
aq(1) = -2.0*qz(1)
if ( ( qz ( 2 ) ) < 0 ) go to 032
go to 033
032 aq(2) = -2.0*qz(2) - 3.14159265358979*(qn + 0.5)
go to 034
033 aq(2) = -2.0*qz(2) + 3.14159265358979*(qn + 0.5)
034 qm = exp(aq(1))
ts(1) = qm*cos(aq(2))
ts(2) = qm*sin(aq(2))
rm(1) = rm(1) + ts(1)*sm(3) - ts(2)*sm(4)
rm(2) = rm(2) + ts(1)*sm(4) + ts(2)*sm(3)
go to 036
035 tm(1) = -2.0*qn*qz(1)/zs
tm(2) = 2.0*qn*qz(2)/zs
ts(1) = tm(1)*rm(1) - tm(2)*rm(2) + rm(3)
ts(2) = tm(1)*rm(2) + tm(2)*rm(1) + rm(4)
rm(3) = rm(1)
rm(4) = rm(2)
rm(1) = ts(1)
rm(2) = ts(2)
qn = qn + 1.0
036 if (qn < pn) go to 035
037 if (mo /= 0) go to 038
qm = exp(qz(1))
tm(1) = qm*cos(qz(2))
tm(2) = qm*sin(qz(2))
ts(1) = tm(1)*rm(1) - tm(2)*rm(2)
ts(2) = tm(1)*rm(2) + tm(2)*rm(1)
rm(1) = ts(1)
rm(2) = ts(2)
038 fi(1) = qf(1)*rm(1) - qf(2)*rm(2)
fi(2) = qf(1)*rm(2) + qf(2)*rm(1)
w = cmplx(fi(1),fi(2))
return
039 sz(1) = 0.25*(qz(1)*qz(1) - qz(2)*qz(2))
sz(2) = 0.5*qz(1)*qz(2)
an = qn
sm(1) = 0.0
sm(2) = 0.0
sm(3) = 0.0
sm(4) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
040 an = an + 1.0
ts(1) = tm(1)/an
ts(2) = tm(2)/an
sm(3) = sm(3) + ts(1)
sm(4) = sm(4) + ts(2)
tm(1) = ts(1)*sz(1) - ts(2)*sz(2)
tm(2) = ts(1)*sz(2) + ts(2)*sz(1)
pm = pm + 1.0
tm(1) = tm(1)/pm
tm(2) = tm(2)/pm
if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 041
if (abs(sm(2)) + abs(tm(2)) == abs(sm(2))) go to 042
041 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
go to 040
042 sm(1) = sm(1) + 1.0
an = qn + 1.0
sm(3) = an*sm(3)
sm(4) = an*sm(4)
go to 044
043 an = qn*(qn + 1.0)
tm(1) = sz(1)/an
tm(2) = sz(2)/an
ts(1) = tm(1)*sm(3) - tm(2)*sm(4)
ts(2) = tm(1)*sm(4) + tm(2)*sm(3)
sm(3) = sm(1)
sm(4) = sm(2)
sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
qn = qn - 1.0
044 if (qn > pn) go to 043
qf(1) = sn
qf(2) = 0.0
qn = 0.0
go to 046
045 qn = qn + 1.0
tm(1) = qf(1)*qz(1) - qf(2)*qz(2)
tm(2) = qf(1)*qz(2) + qf(2)*qz(1)
qf(1) = 0.5*tm(1)/qn
qf(2) = 0.5*tm(2)/qn
046 if (qn < pn) go to 045
if (mo == 0) go to 047
qm = exp(-qz(1))
tm(1) = qm*cos(-qz(2))
tm(2) = qm*sin(-qz(2))
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
qf(1) = ts(1)
qf(2) = ts(2)
047 fi(1) = qf(1)*sm(1) - qf(2)*sm(2)
fi(2) = qf(1)*sm(2) + qf(2)*sm(1)
w = cmplx(fi(1),fi(2))
end subroutine bssli

pure subroutine besi(x, alpha, kode, n, y, nz)
implicit none
!     Written by D. E. Amos and S. L. Daniel, January,1975.
!     Reference
!         sand-75-0152
!         CDC 6600 subroutines ibess and JBESS for Bessel functions
!         i(NU,x) AND J(NU,x), x.GE.0, NU.GE.0  BY D.E. AMOS, S.L.
!         Daniel, M.K. Weston. ACM trans math software,3,PP 76-92
!         (1977)
!         Tables of Bessel functions of moderate or large orders,
!         npl mathematical tables, vol. 6, by F.W.J. Olver, her
!         majesty-S stationery office, london, 1962.
!     Abstract
!         besi computes an n member sequence of i Bessel functions
!         i/sub(alpha+k-1)/(x), k=1,...,n or scaled Bessel functions
!         exp(-x)*i/sub(alpha+k-1)/(x), k=1,...,n for non-negative alpha
!         and x. a combination of the power series, the asymptotic
!         expansion for x to infinity, and the uniform asymptotic
!         expansion for nu to infinity are applied over subdivisions of
!         the (NU,x) plane. For values not covered by one of these
!         formulae, the order is incremented by an integer so that one
!         of these formulae apply. Backward recursion is used to reduce
!         orders by integer values. The asymptotic expansion for x to
!         infinity is used only when the entire sequence (specifically
!         the last member) lies within the region covered by the
!         expansion. Leading terms of these expansions are used to test
!         for over or underflow where appropriate. If a sequence is
!         requested and the last member would underflow, the result is
!         set to zero and the next lower order tried, etc., until A
!         member comes on scale or all are set to zero. An overflow
!         cannot occur with scaling.
!         besi calls asik, gamln, spmpar, and ipmpar
!     description of arguments
!         input
!           x      - x.GE.0.0E0
!           alpha  - Order of first member of the sequence,
!                    alpha.GE.0.0E0
!           kode   - A parameter to indicate the scaling option
!                    kode=1 returns
!                           y(k)=        i/sub(alpha+k-1)/(x),
!                                k=1,...,n
!                    kode=2 returns
!                           y(k)=exp(-x)*i/sub(alpha+k-1)/(x),
!                                k=1,...,n
!           n      - Number of members in the sequence, n.GE.1
!         output
!           y      - A vector whose first n components contain
!                    values for i/sub(alpha+k-1)/(x) or scaled
!                    values for exp(-x)*i/sub(alpha+k-1)/(x),
!                    k=1,...,n DEPENDING ON kode
!           nz     - Error indicator
!                    nz= 0     Normal return-computation completed
!                    nz=-1     x is less than 0.0
!                    nz=-2     alpha is less than 0.0
!                    nz=-3     n is less than 1
!                    nz=-4     kode IS NOT 1 OR 2
!                    nz=-5     x is too large for kode=1
!                    nz.GT.0   last nz components of y set to 0.0
!                              because of underflow
!     error conditions
!         improper input arguments - A fatal error
!         overflow with kode=1 - A fatal error
!         UNDERFLOW - A NON-FATAL ERROR(nz.GT.0)
integer, intent(in) :: kode
integer, intent(in) :: n
integer, intent(inout) :: nz
real, intent(in) :: alpha
real, intent(in) :: x
real, intent(inout) :: y(n)
integer :: i, ialp, in, is, i1, i2, k, kk, km, kt, nn, ns, nswc_ai_i4
real :: ain, ak, akm, ans, ap, arg, atol, tolln, dfn, dtm, dx, earg, elim, etx, flgik, fn, fnf, fni, fnp1, fnu, gln, ra, s, sx, &
   & sxo2, s1, s2, t, ta, tb, temp(3), tfn, tm, tol, trx, t2, xo2, xo2l, z, nswc_ai_r4
real, parameter :: rttpi = 3.98942280401433e-01
integer, parameter :: inlim = 80
interface
   pure subroutine asik(x,fnu,kode,flgik,ra,arg,in,tol,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: fnu
      integer, intent(in) :: kode
      real, intent(in) :: flgik
      real, intent(inout) :: ra
      real, intent(inout) :: arg
      integer, intent(in) :: in
      real, intent(in) :: tol
      real, intent(inout) :: y(*)
   end subroutine asik
   pure elemental function gamln(a)
      implicit none
      real, intent(in) :: a
      real :: gamln
   end function gamln
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     -------------------
!     ipmpar(8) replaces ipmpar(5) in a double precision code
!     ipmpar(9) replaces ipmpar(6) in a double precision code
!     definition of the tolerances TOL and elim
tb = ipmpar(4)
ta = spmpar(1)/tb
if (tb == 2.0e0) go to 1
if (tb == 8.0e0) go to 2
if (tb == 16.0e0) go to 3
tb = log(tb)
go to 5
1 tb = .69315e0
go to 5
2 tb = 2.07944e0
go to 5
3 tb = 2.77259e0
5 tol = max(ta,1.e-15)
i1 = ipmpar(5)
i2 = ipmpar(6)
!     ln(10**3) = 6.90776
elim = float(-i2)*tb - 6.90776e0
!     tolln = -ln(tol)
tolln = float(i1)*tb
tolln = min(tolln,34.5388e0)
nz = 0
kt = 1
nswc_ai_i4 = n - 1
if ( nswc_ai_i4 < 0 ) go to 590
if ( nswc_ai_i4 == 0 ) go to 10
go to 20
10 kt = 2
20 nn = n
if (kode < 1 .or. kode > 2) go to 570
nswc_ai_r4 = x
if ( nswc_ai_r4 < 0 ) go to 600
if ( nswc_ai_r4 == 0 ) go to 30
go to 80
30 nswc_ai_r4 = alpha
if ( nswc_ai_r4 < 0 ) go to 580
if ( nswc_ai_r4 == 0 ) go to 40
go to 50
40 y(1) = 1.0e0
if (n == 1) return
i1 = 2
go to 60
50 i1 = 1
60 do i = i1,n
   y(i) = 0.0e0
end do
return
80 continue
if (alpha < 0.0e0) go to 580
ialp = int(alpha)
fni = float(ialp + n - 1)
fnf = alpha - float(ialp)
dfn = fni + fnf
fnu = dfn
in = 0
xo2 = x*0.5e0
sxo2 = xo2*xo2
etx = float(kode - 1)
sx = etx*x
!     Decision tree for region where series, asymptotic expansion for x
!     to infinity and asymptotic expansion for nu to infinity are
!     applied.
if (sxo2 <= (fnu + 1.0e0)) go to 90
if (x <= 12.0e0) go to 110
fn = 0.55e0*fnu*fnu
fn = max(17.0e0,fn)
if (x >= fn) go to 430
ans = max(36.0e0 - fnu,0.0e0)
ns = int(ans)
fni = fni + float(ns)
dfn = fni + fnf
fn = dfn
is = kt
km = n - 1 + ns
if (km > 0) is = 3
go to 120
90 fn = fnu
fnp1 = fn + 1.0e0
xo2l = log(xo2)
is = kt
if (x <= 0.5e0) go to 230
ns = 0
100 fni = fni + float(ns)
dfn = fni + fnf
fn = dfn
fnp1 = fn + 1.0e0
is = kt
if (n - 1 + ns > 0) is = 3
go to 230
110 xo2l = log(xo2)
ns = int(sxo2 - fnu)
go to 100
120 continue
!     Overflow test on uniform asymptotic expansion
if (kode == 2) go to 130
if (alpha < 1.0e0) go to 150
z = x/alpha
ra = sqrt(1.0e0 + z*z)
gln = log((1.0e0 + ra)/z)
t = ra*(1.0e0 - etx) + etx/(z + ra)
arg = alpha*(t - gln)
if (arg > elim) go to 610
if (km == 0) go to 140
130 continue
!     Underflow test on uniform asymptotic expansion
z = x/fn
ra = sqrt(1.0e0 + z*z)
gln = log((1.0e0 + ra)/z)
t = ra*(1.0e0 - etx) + etx/(z + ra)
arg = fn*(t - gln)
140 if (arg < (-elim)) go to 280
go to 190
150 if (x > elim) go to 610
go to 130
!     Uniform asymptotic expansion for nu to infinity
160 if (km /= 0) go to 170
y(1) = temp(3)
return
170 temp(1) = temp(3)
in = ns
kt = 1
i1 = 0
180 continue
is = 2
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
if (i1 == 2) go to 350
z = x/fn
ra = sqrt(1.0e0 + z*z)
gln = log((1.0e0 + ra)/z)
t = ra*(1.0e0 - etx) + etx/(z + ra)
arg = fn*(t - gln)
190 continue
i1 = abs(3 - is)
i1 = max(i1,1)
flgik = 1.0e0
call asik(x,fn,kode,flgik,ra,arg,i1,tol,temp(is))
select case (is)
case (1)
   go to 180
case (2)
   go to 350
case (3)
   go to 510
end select
!     SERIES FOR (x/2)**2.LE.NU+1
230 continue
gln = gamln(fnp1)
arg = fn*xo2l - gln - sx
if (arg < (-elim)) go to 300
earg = exp(arg)
240 continue
s = 1.0e0
if (x < tol) go to 260
ak = 3.0e0
t2 = 1.0e0
t = 1.0e0
s1 = fn
do k = 1,17
   s2 = t2 + s1
   t = t*sxo2/s2
   s = s + t
   if ( abs ( t ) < tol ) exit
   t2 = t2 + ak
   ak = ak + 2.0e0
   s1 = s1 + fn
end do
260 continue
temp(is) = s*earg
select case (is)
case (1)
   go to 270
case (2)
   go to 350
case (3)
   go to 500
end select
270 earg = earg*fn/xo2
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
is = 2
go to 240
!     Set underflow value and update parameters
280 y(nn) = 0.0e0
nn = nn - 1
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
nswc_ai_i4 = nn - 1
if ( nswc_ai_i4 < 0 ) go to 340
if ( nswc_ai_i4 == 0 ) go to 290
go to 130
290 kt = 2
is = 2
go to 130
300 y(nn) = 0.0e0
nn = nn - 1
fnp1 = fn
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
nswc_ai_i4 = nn - 1
if ( nswc_ai_i4 < 0 ) go to 340
if ( nswc_ai_i4 == 0 ) go to 310
go to 320
310 kt = 2
is = 2
320 if (sxo2 <= fnp1) go to 330
go to 130
330 arg = arg - xo2l + log(fnp1)
if (arg < (-elim)) go to 300
go to 230
340 nz = n - nn
return
!     Backward recursion section
350 continue
nz = n - nn
360 continue
if (kt == 2) go to 420
s1 = temp(1)
s2 = temp(2)
trx = 2.0e0/x
dtm = fni
tm = (dtm + fnf)*trx
if (in == 0) go to 390
!     Backward recur to index alpha+nn-1
do i = 1,in
   s = s2
   s2 = tm*s2 + s1
   s1 = s
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
end do
y(nn) = s1
if (nn == 1) return
y(nn - 1) = s2
if (nn == 2) return
go to 400
390 continue
!     Backward recur from index alpha+nn-1 to alpha
y(nn) = s1
y(nn - 1) = s2
if (nn == 2) return
400 k = nn + 1
do i = 3,nn
   k = k - 1
   y(k - 2) = tm*y(k - 1) + y(k)
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
end do
return
420 y(1) = temp(2)
return
!     Asymptotic expansion for x to infinity
430 continue
earg = rttpi/sqrt(x)
if (kode == 2) go to 440
if (x > elim) go to 610
earg = earg*exp(x)
440 etx = 8.0e0*x
is = kt
in = 0
fn = fnu
450 dx = fni + fni
tm = 0.0e0
if (fni == 0.0e0 .and. abs(fnf) < tol) go to 460
tm = 4.0e0*fnf*(fni + fni + fnf)
460 continue
dtm = dx*dx
s1 = etx
trx = dtm - 1.0e0
dx = -(trx + tm)/etx
t = dx
s = 1.0e0 + dx
atol = tol*abs(s)
s2 = 1.0e0
ak = 8.0e0
do k = 1,25
   s1 = s1 + etx
   s2 = s2 + ak
   dx = dtm - s2
   ap = dx + tm
   t = -t*ap/s1
   s = s + t
   if ( abs ( t ) <= atol ) exit
   ak = ak + 8.0e0
end do
temp(is) = s*earg
if (is == 2) go to 360
is = 2
fni = fni - 1.0e0
dfn = fni + fnf
fn = dfn
go to 450
!     Backward recursion with normalization by
!     asymptotic expansion for nu to infinity or power series.
500 continue
!     Computation of last order for series normalization
akm = max(3.0e0 - fn,0.0e0)
km = int(akm)
tfn = fn + float(km)
ta = (gln + tfn - 0.9189385332e0 - 0.0833333333e0/tfn)/(tfn + 0.5e0)
ta = xo2l - ta
tb = -(1.0e0 - 1.0e0/tfn)/tfn
ain = tolln/(-ta + sqrt(ta*ta - tolln*tb)) + 1.5e0
in = int(ain)
in = in + km
go to 520
510 continue
!     Computation of last order for asymptotic expansion normalization
t = 1.0e0/(fn*ra)
ain = tolln/(gln + sqrt(gln*gln + t*tolln)) + 1.5e0
in = int(ain)
if (in > inlim) go to 160
520 continue
trx = 2.0e0/x
dtm = fni + float(in)
tm = (dtm + fnf)*trx
ta = 0.0e0
tb = tol
kk = 1
530 continue
!     Backward recur unindexed
do i = 1,in
   s = tb
   tb = tm*tb + ta
   ta = s
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
end do
!     Normalization
if (kk /= 1) go to 550
ta = (ta/tb)*temp(3)
tb = temp(3)
kk = 2
in = ns
if (ns /= 0) go to 530
550 y(nn) = tb
nz = n - nn
if (nn == 1) return
tb = tm*tb + ta
k = nn - 1
y(k) = tb
if (nn == 2) return
dtm = dtm - 1.0e0
tm = (dtm + fnf)*trx
km = k - 1
!     Backward recur indexed
do i = 1,km
   y(k - 1) = tm*y(k) + y(k + 1)
   dtm = dtm - 1.0e0
   tm = (dtm + fnf)*trx
   k = k - 1
end do
return
570 continue
nz = -4
return
580 continue
nz = -2
return
590 continue
nz = -3
return
600 continue
nz = -1
return
610 continue
nz = -5
end subroutine besi

pure subroutine asik(x,fnu,kode,flgik,ra,arg,in,tol,y)
implicit none
!                  asik computes Bessel functions I and k
!                  for arguments x.GT.0.0 and orders fnu.GE.35
!                  ON flgik = 1 AND flgik = -1 RESPECTIVELY.
!                                    Input
!      x    - ARGUMENT, x.GT.0.0E0
!      fnu  - Order of first Bessel function
!      kode - A parameter to indicate the scaling option
!             kode=1 RETURNS y(I)=        I/SUB(fnu+I-1)/(x), I=1,IN
!                    OR      y(I)=        k/SUB(fnu+I-1)/(x), I=1,IN
!                    ON flgik = 1.0E0 OR flgik = -1.0E0
!             kode=2 RETURNS y(I)=exp(-x)*I/SUB(fnu+I-1)/(x), I=1,IN
!                    OR      y(I)=exp( x)*k/SUB(fnu+I-1)/(x), I=1,IN
!                    ON flgik = 1.0E0 OR flgik = -1.0E0
!     flgik - Selection parameter for I or k function
!             flgik =  1.0E0 gives the I function
!             flgik = -1.0E0 gives the k function
!        ra - sqrt(1.+z*z), z=x/fnu
!       arg - Argument of the leading exponential
!        in - Number of functions desired, in=1 Or 2
!       tol - Tolerance specified by besi or BESK
!                                    output
!         y - A vector whose first in components contain the sequence
!                                 written by
!                                 D. E. Amos
!     abstract
!         asik implements the uniform asymptotic expansion of
!         the I and k Bessel functions for fnu.GE.35 and real
!         x.GT.0.0E0. The forms are identical except for a change
!         in sign of some of the terms. This change in sign is
!         accomplished by means of the flag flgik = 1 Or -1.
integer, intent(in) :: in
integer, intent(in) :: kode
real, intent(inout) :: arg
real, intent(in) :: flgik
real, intent(in) :: fnu
real, intent(inout) :: ra
real, intent(in) :: tol
real, intent(in) :: x
real, intent(inout) :: y(*)
integer :: j, jn, k, kk, l
real :: ak, ap, coef, etx, fn, gln, s1, s2, t, t2, z
real, parameter :: con(2) = [3.98942280401432678e-01, 1.25331413731550025e+00]
real, parameter :: c(65) = [-2.08333333333333e-01, 1.25000000000000e-01, 3.34201388888889e-01, -4.01041666666667e-01, &
   & 7.03125000000000e-02, -1.02581259645062e+00, 1.84646267361111e+00, -8.91210937500000e-01, 7.32421875000000e-02, &
   & 4.66958442342625e+00, -1.12070026162230e+01, 8.78912353515625e+00, -2.36408691406250e+00, 1.12152099609375e-01, - &
   & 2.82120725582002e+01, 8.46362176746007e+01, -9.18182415432400e+01, 4.25349987453885e+01, -7.36879435947963e+00, &
   & 2.27108001708984e-01, 2.12570130039217e+02, -7.65252468141182e+02, 1.05999045252800e+03, -6.99579627376133e+02, &
   & 2.18190511744212e+02, -2.64914304869516e+01, 5.72501420974731e-01, -1.91945766231841e+03, 8.06172218173731e+03, - &
   & 1.35865500064341e+04, 1.16553933368645e+04, -5.30564697861340e+03, 1.20090291321635e+03, -1.08090919788395e+02, &
   & 1.72772750258446e+00, 2.02042913309661e+04, -9.69805983886375e+04, 1.92547001232532e+05, -2.03400177280416e+05, &
   & 1.22200464983017e+05, -4.11926549688976e+04, 7.10951430248936e+03, -4.93915304773088e+02, 6.07404200127348e+00, - &
   & 2.42919187900551e+05, 1.31176361466298e+06, -2.99801591853811e+06, 3.76327129765640e+06, -2.81356322658653e+06, &
   & 1.26836527332162e+06, -3.31645172484564e+05, 4.52187689813627e+04, -2.49983048181121e+03, 2.43805296995561e+01, &
   & 3.28446985307204e+06, -1.97068191184322e+07, 5.09526024926646e+07, -7.41051482115327e+07, 6.63445122747290e+07, - &
   & 3.75671766607634e+07, 1.32887671664218e+07, -2.78561812808645e+06, 3.08186404612662e+05, -1.38860897537170e+04, &
   & 1.10017140269247e+02]
!     ---------------------
fn = fnu
z = (3.0e0 - flgik)/2.0e0
kk = int(z)
do jn = 1,in
   if (jn == 1) go to 10
   fn = fn - flgik
   z = x/fn
   ra = sqrt(1.0e0 + z*z)
   gln = log((1.0e0 + ra)/z)
   etx = float(kode - 1)
   t = ra*(1.0e0 - etx) + etx/(z + ra)
   arg = fn*(t - gln)*flgik
10 coef = exp(arg)
   t = 1.0e0/ra
   t2 = t*t
   t = t/fn
   t = sign(t,flgik)
   s2 = 1.0e0
   ap = 1.0e0
   l = 0
   do k = 2,11
      l = l + 1
      s1 = c(l)
      do j = 2,k
         l = l + 1
         s1 = s1*t2 + c(l)
      end do
      ap = ap*t
      ak = ap*s1
      s2 = s2 + ak
      if ( max ( abs ( ak ) , abs ( ap ) ) < tol ) exit
   end do
   t = abs(t)
   y(jn) = s2*coef*sqrt(t)*con(kk)
end do
end subroutine asik

subroutine cbesk(z, cnu, w)
implicit none
complex :: z
complex, intent(in) :: cnu
complex, intent(inout) :: w
real :: a, b, c, e, rn, rz, s, tau, x, y
complex :: nu
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!-----------------------------------------------------------------------
!        Calculation of the modified Bessel function of the
!        second kind for complex order cnu and complex argument
!        z.  it is assumed that -Pi .LT. arg z .LE. pi.
!-----------------------------------------------------------------------
!     Written by
!        Alfred H. Morris, Jr. and Andrew H. van Tuyl
!        Naval Surface Warfare Center
!        oct 1992
!--------------------------
x = abs(real(z))
y = abs(aimag(z))
nu = cnu
if (real(nu) < 0.0) nu = - nu
a = real(nu)
b = abs(aimag(nu))
rn = cpabs(a, b)
rz = cpabs(x, y)
!     Asymptotic expansion
if (rz < 17.5 + 0.5*rn*rn) go to 10
call cbka(z, nu, w)
return
10 if (b <= 1.5e-2*a) go to 200
tau = rn/rz
if (tau >= 1.5) go to 100
if (tau <= 0.05) go to 200
if (tau < 0.70 .and. real(z) <= 0.0) go to 100
if (aimag(nu) > 0.0 .and. b < 0.07*a) go to 200
if (tau < 1.291) go to 20
if (aimag(nu) < 0.0 .and. b < 0.127*a) go to 40
s = 0.5*(1.5 - tau)
if (b < s*a) go to 200
go to 100
20 if (tau < 0.639) go to 60
if (tau > 0.691) go to 30
if (b > 0.5*a) go to 61
e = b/a
go to 50
30 if (b < 0.191*a) go to 40
if (tau > 0.99 .and. b > 0.257*a .and. &
   & b < 0.64*a) go to 61
if (tau <= 1.16 .and. b < 0.727*a .and. &
   & y < 0.727*x) go to 200
if (tau <= 0.91 .and. a > 0.45*b .and. &
   & y < 0.325*x) go to 200
c = 0.471
if (tau < 0.75) c = 0.55
if (tau < 0.844 .and. a < 0.55*b .and. &
   & y < c*x) go to 200
40 s = 1.65*(1.54 - tau)**2
if (tau < 0.91) s = 0.82 - 1.5*(tau - 0.8)
e = 2.25
if (tau < 0.78) e = 2.90
if (b > e*s*a) go to 100
if (b > 0.5*a) go to 61
e = b/(s*a)
if (e < 0.50) go to 50
c = 2.83 - 1.66*e
if (y > c*x) go to 100
go to 200
50 c = 7.0 - 10.0*e
if (tau > 0.86) c = 8.0 - 12.0*e
if (y > c*x) go to 100
go to 200
60 if (b <= 0.191*a) go to 200
61 if (x < 0.64*(tau - 0.2)*y) go to 100
s = 1.5*b/(a + 1.e-7)
e = 0.95
if (tau > 0.95 .and. tau < 1.16 .and. &
   & b > 0.471*a .and. b <= a) e = 0.75
if (tau > 0.85 .and. tau <= 0.95 .and. &
   & b <= a) e = 0.80
if (tau > 0.71 .and. tau <= 0.85 .and. &
   & b < 1.21*a) e = 0.85
if (tau > 0.61 .and. tau <= 0.71 .and. &
   & b > 0.63*a .and. b < 1.15*a) e = 0.80
if (tau > 0.50 .and. tau <= 0.61 .and. &
   & b > 0.7*a .and. b <= a) e = 0.70
if (tau > 0.68 .and. tau <= 0.77 .and. &
   & a < 0.75*b) e = 1.15
if (tau > 0.77 .and. tau < 0.95 .and. &
   & a < 0.83*b) e = 1.10
c = (1.0 + e*tau)*tau*tanh(s)**2
if (x >= c*y) go to 200
!     Calculation in terms of the modified
!     Bessel function I
100 call cbki(z, nu, w)
return
!     Power series and Miller algorithm
200 call cbkm(z, rz, nu, w)
end subroutine cbesk

subroutine cbki(z, cnu, w)
implicit none
complex, intent(in) :: z, cnu
complex, intent(inout) :: w
real :: a, b, u1, u2
complex :: w1, w2
real, parameter :: pi = 3.14159265358979e+00
real, parameter :: pihalf = 1.5707963267949e+00
interface
   pure elemental function cdiv(a,b)
      implicit none
      complex, intent(in) :: a
      complex, intent(in) :: b
      complex :: cdiv
   end function cdiv
   pure elemental function cos1(x)
      implicit none
      real, intent(in) :: x
      real :: cos1
   end function cos1
   pure elemental function sin1(x)
      implicit none
      real, intent(in) :: x
      real :: sin1
   end function sin1
end interface
!------------------------------------------------------------
!     Calculation of the modified Bessel function of the
!     second kind with complex order and argument in terms
!     of the modified Bessel function of the first kind.
!------------------------------------------------------------
call cbssli(z, -cnu, w1)
call cbssli(z, cnu, w2)
a = real(cnu)
b = pi*aimag(cnu)
u1 = sin1(a)*cosh(b)
u2 = cos1(a)*sinh(b)
w = pihalf*cdiv(w1 - w2, cmplx(u1,u2))
end subroutine cbki

subroutine cbka(z, cnu, w)
implicit none
complex :: z
complex, intent(in) :: cnu
complex, intent(inout) :: w
integer :: i
real :: eps, u, v
real :: m
complex :: a, p, t, zr
real, parameter :: c = 1.77245385090552e+00
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
!        Computation of the Bessel function K for complex order
!        cnu and complex argument z by the asymptotic expansion
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
!     c = pi**(1/2)
!--------------------------
!--------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0 .
eps = spmpar(1)
!--------------------------
call crec(real(z), aimag(z), u, v)
zr = cmplx(0.5*u, 0.5*v)
a = cnu*cnu - 0.25
m = 1.0
t = a*zr
p = t
do i = 1, 16
   a = a - 2.0*m
   m = m + 1.0
   t = t*a*zr/m
   p = p + t
   if ( anorm ( t ) <= eps * anorm ( p ) ) exit
end do
p = p + 1.0
t = sqrt(zr)
if (aimag(z) == 0.0) t = conjg(t)
w = c*t*p*exp(-z)
contains
   pure function anorm(z) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: z
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(z)), abs(aimag(z)))
   end function anorm
end subroutine cbka

subroutine cbkm(z, rz, cnu, w)
implicit none
real, intent(in) :: rz
complex, intent(in) :: z, cnu
complex, intent(inout) :: w
integer :: i, ind, m, n, n1
real :: a, ai, b, c, t, x, y, znorm, zr1, zr2, nu
complex :: cz, ex, r, r1, u1, u2, u3, w1, w2, zr
real, parameter :: pi = 3.14159265358979
real, parameter :: cpi = 1.25331413731550
interface
   pure elemental subroutine cbkml(z,r,zr,nu,n,w,w0)
      implicit none
      complex, intent(in) :: z
      real, intent(in) :: r
      complex, intent(in) :: zr
      complex, intent(in) :: nu
      integer, intent(in) :: n
      complex, intent(inout) :: w
      complex, intent(inout) :: w0
   end subroutine cbkml
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
!-------------------------------------------------------------------
!     Calculation of the modified Bessel function of the second
!     kind with complex order and argument BY means of Maclaurin
!     expansions and the Miller algorithm. It is assumed that
!     rz = abs(z).
!-------------------------------------------------------------------
!---------------------------
!     cpi = sqrt(pi/2)
!---------------------------
!        Reduction of cnu to r = nu + b*i where
!                -0.5 .LT. nu .LE. 0.5
r = cnu
if (real(r) < 0.0) r = - r
a = real(r)
b = aimag(r)
n = a
nu = a - float(n)
t = nu - 0.5
if (t <= 0.0) go to 10
nu = t - 0.5
n = n + 1
10 m = n
r1 = cmplx(nu, b)
ind = 1
cz = z
x = 0.5*real(z)
y = 0.5*aimag(z)
call crec(x, y, zr1, zr2)
zr = cmplx (zr1, zr2)
if (t /= 0.0) go to 20
if (b /= 0.0) go to 20
!               Calculation for nu = 0.5
w = cmplx(cpi, 0.0)
w1 = (1.0, 0.0)
if (n == 0) go to 90
if (x >= 0.0) go to 15
ind = -1
cz = - z
zr = - zr
15 u1 = w
u2 = w
n = n + 1
r1 = (-0.5, 0.0)
go to 70
!           Calculation for abs(nu) .LT. 0.5
20 znorm = 0.5*rz
if (znorm > 1.0) go to 30
ind = 0
call ckps(z, znorm, zr, r1, u1, u2)
go to 50
30 u1 = (1.0, 0.0)
if (x < 0.0) go to 40
call cbkml(z, znorm, zr, r1, n, w1, u2)
go to 50
40 ind = -1
cz = - z
zr = - zr
call cbkml(cz, znorm, zr, r1, n, w1, u2)
50 if (n > 1) go to 70
w = u1
if (n /= 0) w = u2
go to 90
!                 Recursion
70 n1 = n - 1
do i = 1, n1
   ai = i
   u3 = (r1 + ai)*zr*u2 + u1
   u1 = u2
   u2 = u3
end do
w = u3
90 if (ind == 0) return
w = w*w1*exp(-cz)/sqrt(cz)
if (ind > 0) return
!            Analytic continuation
c = exp(0.5*b*pi)
ex = cxp(m, nu)
if (y < 0.0) go to 100
ex = c*ex
w1 = cmplx (aimag(z), -real(z))
call cbsslj(w1, r, w2)
w2 = cmplx (pi*aimag(w2), -pi*real(w2))
w = ex*(ex*w + w2)
return
100 ex = conjg(ex)/c
w1 = cmplx (-aimag(z), real(z))
call cbsslj(w1, r, w2)
w2 = cmplx (-pi*aimag(w2), pi*real(w2))
w = ex*(ex*w + w2)
end subroutine cbkm

subroutine ckps(z, r, zr, nu, w1, w2)
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex :: nu
complex, intent(inout) :: w1, w2
integer :: k
real :: ak, eps, eps0, phi, s, u, x, y
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
!        Calculation of the modified Bessel functions
!                  w1 = k  (z)  AND  w2 = k    (z)
!                        nu                nu+1
!     for a complex argument z where abs(z) .LE. 2 and a complex
!     order nu where abs(real(nu)) .LE. 0.5.  It is assumed that
!     -pi .LT. arg z .LE. pi, r = abs(z/2), and zr = 2/z.  power
!     series expansions are used.
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
!                     cl = - ln(z/2)
phi = atan2(aimag(z),real(z))
cl = cmplx(-log(r), -phi)
mu = nu*cl
c = exp(mu)
!                   g1 = gamma(1 + nu)
!                   g2 = gamma(1 - nu)
t = pi*nu
if (anorm(nu) > tol) go to 10
a = 1.0 + (t*t)/6.0
go to 20
10 a = t/sin(t)
20 s = real(nu)**2 + aimag(nu)**2
if (s >= 1.0) go to 21
t = cgam0(nu)
g1 = 1.0/t
g2 = a*t
go to 30
21 t = 0.5 + (0.5 + nu)
call cgamma(0, t, g1)
g2 = cdiv(a,g1)
30 gm2 = 0.5*(g1 + g2)
if (s > 0.04) go to 31
!         The following is the Taylor series for
!     w1 = (1/g2 - 1/g1)/(2*nu). Note that g1*g2 = a.
t = nu*nu
w1 = -((((((d(7)*t + d(6))*t + d(5))*t + d(4))*t + &
   & d(3))*t + d(2))*t + d(1))
gm1 = a*w1
go to 40
31 gm1 = 0.5*(g1 - g2)/nu
!            Initialization of the summation
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
60 f = gm1*ch + gm2*cl*sh
c = (1.0, 0.0)
w1 = f
w2 = p
!                 Summation of series
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
   if ( anorm ( t1 ) <= eps0 * anorm ( w1 ) ) exit
end do
w2 = w2 * zr
contains
   pure function anorm(t) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: t
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(t)), abs(aimag(t)))
   end function anorm
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
!             Computation of the scaled Bessel function
!                   w = (exp(z)*sqrt(z)) k  (z)
!                                         nu
!     and the value
!                   w0 = k    (z) /k  (z)
!                         nu+1      nu
!     for complex orders nu and nu + 1 and for complex argument z
!     by use of the Miller algorithm. For the greatest accuracy,
!     z should lie in a sector slightly larger than the right half
!     plane. It is assumed that abs(real(nu)) .LT. 0.5, and that
!     r = abs(z/2) AND zr = 2/z.
!-----------------------------------------------------------------------
!---------------------
!     c1 = sqrt(pi/2)
!     c2 = sqrt(pi)
!---------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
x = real(z)
y = aimag(z)
rnu = real(nu)
inu = aimag(nu)
!     Calculation of m for use in Miller algorithm.
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
!     Backward recurrence in Miller algorithm.
a = (0.5 - rnu)*(0.5 + rnu) + inu*inu
e = 2.0*rnu*inu
u2 = (0.0, 0.0)
u1 = (1.0, 0.0)
s = u1
l = m
do i = 2, m
   u3 = u2
   u2 = u1
   c = a/l + (l - 1.0)
   al = cmplx(c, - e/l)
   bl = 2.0*(l + z)
   u1 = (bl*u2 - (l + 1.0)*u3)/al
   s = s + u1
   c = abs(real(u1)) + abs(aimag(u1))
   if (i == m .or. c < 1.e+8) go to 30
!           Rescale to avoid overflow
   u2 = u2/c
   u1 = u1/c
   s = s/c
30 l = l - 1.0
end do
!     Last step in the Miller algorithm.
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
!     Final assembly
w = c1*(u1/s)
w0 = 1.0 + 0.5*(nu + 0.5 - u2/u1)*zr
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
!         Calculation of the modified Bessel function of the
!         second kind for real order r and complex argument z.
!         It is assumed that -pi .LT. arg z .LE. pi.
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
rz = cpabs(real(z), aimag(z))
!     Asymptotic expansion
if (rz < 17.5 + 0.5*r*r) go to 5
call cka(z, r, w)
return
!          Reduction of r to the range -0.5 .LT. nu .LE. 0.5
5 a = abs(r)
n = a
nu = a - float(n)
t = nu - 0.5
if (t <= 0.0) go to 10
nu = t - 0.5
n = n + 1
10 m = n
nu1 = nu
ind = 1
cz = z
x = 0.5*real(z)
y = 0.5*aimag(z)
call crec(x, y, zr1, zr2)
zr = cmplx (zr1, zr2)
if (t /= 0.0) go to 20
!               Calculation for nu = 0.5
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
!           Calculation for abs(nu) .LT. 0.5
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
50 if (n > 1) go to 70
w = u1
if (n /= 0) w = u2
go to 90
!                 Recursion
70 n1 = n - 1
do i = 1, n1
   ai = i
   u3 = (nu + ai)*zr*u2 + u1
   u1 = u2
   u2 = u3
end do
w = u3
90 if (ind == 0) return
w = w*exp(-cz)/sqrt(cz)
if (ind > 0) return
!            Analytic continuation
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
end subroutine cbsslk

subroutine cka(z, nu, w)
implicit none
complex :: z
complex, intent(inout) :: w
real, intent(in) :: nu
integer :: i
real :: a, eps, u, v
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
!--------------------------
!     c = pi**(1/2)
!--------------------------
!--------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0 .
eps = spmpar(1)
!--------------------------
call crec(real(z), aimag(z), u, v)
zr = cmplx(0.5*u, 0.5*v)
a = nu*nu - 0.25
m = 1.0
t = a*zr
p = t
do i = 1, 16
   a = a - 2.0*m
   m = m + 1.0
   t = (a/m)*t*zr
   p = p + t
   if ( anorm ( t ) <= eps * anorm ( p ) ) exit
end do
p = p + 1.0
t = sqrt(zr)
if (aimag(z) == 0.0) t = conjg(t)
w = c*t*p*exp(-z)
contains
   pure function anorm(z) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: z
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(z)), abs(aimag(z)))
   end function anorm
end subroutine cka

pure elemental subroutine ckm(z, r, zr, nu, w1, w2)
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex, intent(inout) :: w1, w2
real, intent(in) :: nu
integer :: k
real :: a, ak, eps, eps0, g1, g2, gm1, gm2, phi, t, x, y
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
!        Calculation of the modified Bessel functions
!                  w1 = k  (z)  AND  w2 = k    (z)
!                        nu                nu+1
!     for a complex argument z where abs(z) .LE. 2  and a real
!     order nu where abs(nu) .LE. 0.5.  It is assumed that
!     -pi .LT. arg z .LE. pi, r = abs(z/2), and zr = 2/z. power
!     series expansions are used.
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
!                     cl = - ln(z/2)
phi = atan2(aimag(z),real(z))
cl = cmplx(-log(r), -phi)
mu = nu*cl
c = exp(mu)
!                   g1 = gamma(1 + nu)
!                   g2 = gamma(1 - nu)
t = pi*nu
if (abs(nu) > tol) go to 10
a = 1.0 + (t*t)/6.0
go to 20
10 a = t/sin(t)
20 t = 0.5 + (0.5 + gam1(nu))
g1 = 1.0/t
g2 = a*t
gm2 = 0.5*(g1 + g2)
if (abs(nu) > 0.2) go to 30
!         The following is the Taylor series for
!     t = (1/g2 - 1/g1)/(2*nu). Note that g1*g2 = a.
t = nu*nu
t = -((((((d(7)*t + d(6))*t + d(5))*t + d(4))*t + &
   & d(3))*t + d(2))*t + d(1))
gm1 = a*t
go to 40
30 gm1 = 0.5*(g1 - g2)/nu
!            Initialization of the summation
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
60 f = gm1*ch + gm2*cl*sh
c = (1.0, 0.0)
w1 = f
w2 = p
!                 Summation of series
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
   if ( anorm ( t1 ) <= eps0 * anorm ( w1 ) ) exit
end do
w2 = w2 * zr
contains
   pure function anorm(w) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: w
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(w)), abs(aimag(w)))
   end function anorm
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
!             Computation of the scaled Bessel functions
!                   k1 = (exp(z)*sqrt(z)) k  (z)
!                                          nu
!                   k2 = (exp(z)*sqrt(z)) k    (z)
!                                          nu+1
!     for real orders nu and nu + 1 and for complex argument z
!     by use of the Miller algorithm. For the greatest accuracy,
!     z should lie in a sector slightly larger than the right
!     half plane. It is assumed that abs(nu) .LT. 0.5, and that
!     r = abs(z/2) AND zr = 2/z.
!-----------------------------------------------------------------------
!---------------------
!     c1 = sqrt(pi/2)
!---------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant.  Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-----------------------------------------------------------------------
eps0 = max(eps, 5.e-15)
x = real(z)
y = aimag(z)
nu2 = nu*nu
!     Calculation of m for use in Miller algorithm.
th = atan2(y,x)
a = 3.0/(1.0 + r)
b = 14.7/(28.0 + r)
c = 4.0*cos1(nu)/(c1*eps0*(2.0*r)**(0.25))
m = (0.485/r)*(log(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
   & (2.0*cos(b*th))**2 + 1.5
!     Backward recurrence in Miller algorithm.
u2 = (0.0, 0.0)
u1 = (1.0, 0.0)
s = u1
l = m
do i = 2, m
   u3 = u2
   u2 = u1
   e = l - 0.5
   al = (e*e - nu2)/(l*(l + 1.0))
   bl = (2.0/(l + 1.0))*(l + z)
   u1 = (bl*u2 - u3)/al
   s = s + u1
   c = abs(real(u1)) + abs(aimag(u1))
   if (i == m .or. c < 1.e+6) go to 10
!           Rescale to avoid overflow
   u2 = u2/c
   u1 = u1/c
   s = s/c
10 l = l - 1.0
end do
!     Last step in the Miller algorithm.
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
!     Final assembly
k1 = c1*(u1/s)
k2 = k1*(1.0 + 0.5*(nu + 0.5 - u2/u1)*zr)
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
c = cos0(nu)
s = sin0(nu)
k = mod(n,4)
if (k == 0) go to 10
if (k == 1) go to 20
if (k == 2) go to 30
go to 40
10 cxp = cmplx (c, -s)
return
20 cxp = cmplx (-s, -c)
return
30 cxp = cmplx (-c, s)
return
40 cxp = cmplx (s, c)
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
002 if ( ( zs - 1.0 ) <= 0 ) go to 020
go to 003
003 if ( ( zs - 289.0 ) < 0 ) go to 004
go to 010
004 if ( ( az ( 1 ) + 0.096 * az ( 2 ) * az ( 2 ) ) <= 0 ) go to 020
go to 015
010 qm = 1.25331413731550*exp(-0.5*zl(1) - tm(1))
qf(1) = qm*cos(-0.5*zl(2) - tm(2))
qf(2) = qm*sin(-0.5*zl(2) - tm(2))
if (an > 1.0) go to 012
pn = an
la = 11
go to 100
011 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
012 pn = 1.0
la = 13
go to 100
013 sq(1) = qf(1)*sm(1) - qf(2)*sm(2)
sq(2) = qf(1)*sm(2) + qf(2)*sm(1)
pn = 0.0
la = 14
go to 100
014 sr(1) = qf(1)*sm(1) - qf(2)*sm(2)
sr(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 026
015 qm = 1.25331413731550*exp(-0.5*zl(1) - tm(1))
qf(1) = qm*cos(-0.5*zl(2) - tm(2))
qf(2) = qm*sin(-0.5*zl(2) - tm(2))
if (an > 1.0) go to 017
pn = an
lr = 16
go to 104
016 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
017 pn = 1.0
lr = 18
go to 104
018 sq(1) = qf(1)*sm(1) - qf(2)*sm(2)
sq(2) = qf(1)*sm(2) + qf(2)*sm(1)
pn = 0.0
lr = 19
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
lk = 22
go to 106
022 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 029
023 pn = 1.0
lk = 24
go to 106
024 sq(1) = qf(1)*sm(1) - qf(2)*sm(2)
sq(2) = qf(1)*sm(2) + qf(2)*sm(1)
pn = 0.0
lk = 25
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
103 select case ( la )
case ( 11 )
   go to 11
case ( 13 )
   go to 13
case ( 14 )
   go to 14
end select
104 sm(1) = 1.0
sm(2) = 0.0
m = 15.0*pn + 2.0
n = 15.0*pn + 15.0
do i = m,n
   ts(1) = az(1) - cd(i)
   ts(2) = az(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
select case ( lr )
case ( 16 )
   go to 16
case ( 18 )
   go to 18
case ( 19 )
   go to 19
end select
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
select case ( lk )
case ( 22 )
   go to 22
case ( 24 )
   go to 24
case ( 25 )
   go to 25
end select
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
!     Maclaurin expansion
call airm(ind,z,ai,aip,bi,bip)
return
10 if (r > 10.0) go to 20
!     Intermediate range calculation
call aii(ind,z,ai,aip,ierr)
return
!     Asymptotic expansion
20 call aia(ind,z,ai,aip,ierr)
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
!     Summation of f and g
f = cmplx(a(8),0.0)
g = cmplx(b(8),0.0)
do n = 1, 7
   i = 8 - n
   f = a(i) + z3*f
   g = b(i) + z3*g
end do
f = 1.0 + z3*f
g = z + z2*z2*g
!     Summation of f1 and g1
f1 = cmplx(c(8),0.0)
g1 = cmplx(d(8),0.0)
do n = 1,7
   i = 8 - n
   f1 = c(i) + z3*f1
   g1 = d(i) + z3*g1
end do
f1 = z2*(0.5 + z3*f1)
g1 = 1.0 + z3*g1
!     Final assembly
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
!     c1 = 1/(pi*sqrt(3))
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a, b)
z1 = sqrt(z)
z2 = z1*z/1.5
if (abs(b) < -5.0*a) go to 10
!           ----  abs(b) .GE. -5.0*a  ----
call ka(ind, z2, w1, w2)
ai = c1*z1*w1
aip = -c1*z*w2
return
!           ----  abs(b) .LT. -5.0*a  ----
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
!     Eps, xpos, and xneg are machine dependent constants. Eps is
!     the smallest number such that 1.0 + eps .GT. 1.0, xpos is the
!     the largest postive number for which exp(X) can be computed,
!     and xneg is the largest negative number for which exp(X) does
!     not underflow.
eps = spmpar(1)
xpos = exparg(0)
xneg = exparg(1)
!------------------------
ierr = 0
if (real(z) < 0.0) go to 30
!             -----   real(z) .GE. 0    -----
z1 = sqrt(z)
z2 = sqrt(z1)
z2r = 1.0/z2
call crec(real(z), aimag(z), u, v)
w = -1.5*cmplx(u,v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u,v)
if (ind /= 0) go to 10
if (t == 0.0) go to 90
u1 = u/t
v1 = v/t
r = u*u1 + v*v1
xm = xpos
if (real(w) < 0.0) xm = -xneg
if (u1 >= r*xm .or. v1 >= 0.1*r/eps) go to 90
zeta = z1*z/1.5
e = exp(-zeta)
10 m = 20
if (t > 30.0) m = 8
s1 = cmplx(c(m),0.0)
s2 = cmplx(d(m),0.0)
i = m
do k = 2,m
   i = i - 1
   s1 = c(i) + w*s1
   s2 = d(i) + w*s2
end do
ai = 0.5*c1*z2r*s1
aip = - 0.5*c1*z2*s2
if (ind /= 0) return
ai = e*ai
aip = e*aip
return
!             -----   real(z) .LT. 0    -----
30 zz = -z
z1 = sqrt(zz)
z2 = sqrt(z1)
z2r = 1.0/z2
call crec(real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u,v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = max(u,v)
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
if (ind /= 0) go to 70
cn = cos(zeta)
si = sin(zeta)
go to 80
70 cn = 0.5*(1.0 + e)
si = 0.5*(1.0 - e)*j
80 alpha = s1 - s2
beta = s1 + s2
ai = c2*z2r*(alpha*cn + beta*si)
alpha = s3 - s4
beta = s3 + s4
aip = c2*z2*(alpha*si - beta*cn)
return
!         RETURN WITH ZERO VALUES IF SCALING IS NEEDED
90 ai = (0.0, 0.0)
aip = (0.0, 0.0)
ierr = 1
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
!     Maclaurin expansion
call airm(ind,z,ai,aip,bi,bip)
return
10 if (r > 9.6) go to 20
!     Intermediate range calculation
call bii(ind,z,bi,bip,ierr)
return
!     Asymptotic expansion
20 call bia(ind,z,bi,bip,ierr)
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
!     c1 = 1/sqrt(3)
!     sqt3 = sqrt(3)
ierr = 0
x = real(z)
y = aimag(z)
r = cpabs(x, y)
z1 = sqrt(z)
z2 = z1*z/1.5
e = exp(-z2)
e1 = 1.0/e
if (real(z) < 0.0) go to 10
!               ----  real(z) .GE. 0  ----
if (r < 8.9) go to 5
a = 0.156*r - 0.913
if (abs(y) < a*x .or. abs(y) > 0.58*x) go to 40
5 call ia(z2, w1, w2, w1m, w2m)
bi = c1*z1*(w1 + w1m)
bip = c1*z*(w2 + w2m)
if (ind == 0) return
go to 20
!               ----  real(z) .LT. 0  ----
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
!     Eps and XM are machine dependent constants. Eps is the
!     smallest number such that 1.0 + eps .GT. 1.0, xpos is the
!     largest positive number for which exp(XM) can be computed,
!     and XNEG is the negative number of largest magnitude for
!     which exp(X) does not underflow.
eps = spmpar(1)
xpos = exparg(0)
xneg = exparg(1)
!------------------------
ierr = 0
x = real(z)
y = aimag(z)
if (x < abs(y)*sqt3) go to 30
!          -----  abs(ARG(z)) .LE. PI/6  ----
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
10 m = 20
t = max(x, abs(y))
if (t > 30.0) m = 8
s1 = cmplx(c(m), 0.0)
s2 = cmplx(d(m), 0.0)
i = m
do k = 2,m
   i = i - 1
   s1 = c(i) + w*s1
   s2 = d(i) + w*s2
end do
bi = c1*z2r*s1
bip = c1*z2*s2
if (ind /= 0) return
bi = e*bi
bip = e*bip
return
30 if (x < 0.0) go to 50
!          ----  PI/6 .LT. abs(ARG(z)) .LE. PI/2  ----
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
!        e = exp(-2*i*(zeta - CLN2)) IF abs(ARG(zz)) .LE. PI/3
!        e = exp( 2*i*(zeta - CLN2)) IF abs(ARG(zz)) .GT. PI/3
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
!                  ----  real(z) .LT. 0  ----
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
!            RETURN WITH ZERO VALUES IF SCALING IS NEEDED.
90 bi = (0.0, 0.0)
bip = (0.0, 0.0)
ierr = 1
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
!     ex13 = exp(i*pi/3)
!     ex13c = exp(-i*pi/3)
!     ex23 = exp(2*i*pi/3)
!     ex23c = exp(-2*i*pi/3)
if (real(z) >= 0.0) go to 20
cz = -z
!     Calculation of i1, i2, i1m, and i2m when real(cz) .GT. 0.
call imc(cz, i1, i2, i1m, i2m)
!     Final assembly
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
!     gm1 = gamma(4.0/3.0)
!     gm2 = gamma(5.0/3.0)
zh = 0.5*z
sz = zh*zh
a = real(zh)
b = aimag(zh)
an = aint(a*a + b*b)
cn1 = c1 + an
cn2 = c2 + an
!     Calculation of initial values for backward recurrence by
!     use of the Maclaurin expansion.
call bim(z, cn1, ia1)
call bim(z, cn1 + 1.0, ia2)
call bim(z, cn2, ib1)
call bim(z, cn2 + 1.0, ib2)
!     Backward recurrence
n = an
m = an
n1 = n + 1
do i = 1, n1
   ia3 = ia2
   ia2 = ia1
   ib3 = ib2
   ib2 = ib1
   cfa = (m + c1)*(m + c1 + 1.0)
   cfb = (m + c2)*(m + c2 + 1.0)
   m = m - 1.0
   ia1 = ia2 + (sz/cfa)*ia3
   ib1 = ib2 + (sz/cfb)*ib3
end do
e = exp(c1*log(zh))
cf1 = e/gm1
cf2 = e*e/gm2
cf3 = c2*cf2/zh
cf4 = c1*cf1/zh
i1 = cf1*ia2
i2 = cf2*ib2
i1m = cf3*ib1
i2m = cf4*ia1
end subroutine imc

subroutine bim(z,cn,w)
implicit none
real, intent(in) :: cn
complex :: z
complex, intent(inout) :: w
real :: d, eps
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
!-------------------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the smallest
!     number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-------------------------------------------------------------
sz = 0.25*z*z
!     Initialization of Maclaurin expansion
m = 1.0
t = sz/(cn + 1.0)
w = t
!     Summation of Maclaurin expansion
10 m = m + 1.0
d = m*(cn + m)
t = t*(sz/d)
w = w + t
if (anorm(t) > eps*anorm(w)) go to 10
w = w + 1.0
contains
   pure function anorm(z) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: z
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(z)),abs(aimag(z)))
   end function anorm
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
!     ex13 = exp(i*pi/3)
!     ex13c = exp(-i*pi/3)
!     ex23 = exp(2*i*pi/3)
!     ex23c = exp(-2*i*pi/3)
if (real(z) >= 0.0) go to 20
cz = -z
!     Calculation of i1, i2, i1m, and i2m when real(cz) .GT. 0.0
call jmc(cz, i1, i2, i1m, i2m)
!     Final assembly
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
!     gm1 = gamma(4.0/3.0)
!     gm2 = gamma(5.0/3.0)
zh = 0.5*z
sz = zh*zh
a = real(zh)
b = aimag(zh)
an = aint(a*a + b*b)
cn1 = c1 + an
cn2 = c2 + an
!     Calculation of initial values for backward recurrence by
!     use of the Maclaurin expansion.
call bjm(z, cn1, ia1)
call bjm(z, cn1 + 1.0, ia2)
call bjm(z, cn2, ib1)
call bjm(z, cn2 + 1.0, ib2)
!     Backward recurrence
n = an
n1 = n + 1
m = an
do i = 1, n1
   ia3 = ia2
   ia2 = ia1
   ib3 = ib2
   ib2 = ib1
   cfa = (m + c1)*(m + c1 + 1.0)
   cfb = (m + c2)*(m + c2 + 1.0)
   m = m - 1.0
   ia1 = ia2 - (sz/cfa)*ia3
   ib1 = ib2 - (sz/cfb)*ib3
end do
e = exp(c1*log(zh))
cf1 = e/gm1
cf2 = e*e/gm2
cf3 = c2*cf2/zh
cf4 = c1*cf1/zh
i1 = cf1*ia2
i2 = cf2*ib2
i1m = cf3*ib1
i2m = cf4*ia1
end subroutine jmc

subroutine bjm(z,cn,w)
implicit none
real, intent(in) :: cn
complex :: z
complex, intent(inout) :: w
real :: d, eps
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
!-------------------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the smallest
!     number such that 1 + eps .GT. 1.
eps = spmpar(1)
!-------------------------------------------------------------
sz = -0.25*z*z
!     Initialization of Maclaurin expansion
m = 1.0
t = sz/(cn + 1.0)
w = t
!     Summation of Maclaurin expansion
10 m = m + 1.0
d = m*(cn + m)
t = t*(sz/d)
w = w + t
if (anorm(t) > eps*anorm(w)) go to 10
w = w + 1.0
contains
   pure function anorm(z) result(nswc_sf_result)
      implicit none
      complex, intent(in) :: z
      real :: nswc_sf_result
      nswc_sf_result = max(abs(real(z)),abs(aimag(z)))
   end function anorm
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
!     ex13c = exp(-pi*i/3)
!     ex23c = exp(-2*pi*i/3)
a = real(z)
b = aimag(z)
if (abs(b) < -0.5*a) go to 10
!            ----  abs(b) .GE. -0.5*a  ----
call kml(ind, z, k1, k2)
return
!            ----  abs(b) .LT. -0.5*a  ----
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
!     c1 = sqrt(pi/2)
eps = spmpar(1)
x1 = real(z)
x2 = aimag(z)
!     Calculation of m for use in Miller algorithm.
call capo(x1, x2, r, th)
a = 3.0/(1.0 + r)
b = 14.7/(28.0 + r)
c = 2.0/(c1*eps*(2.0*r)**(0.25))
m = (0.485/r)*(log(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
   & (2.0*cos(b*th))**2 + 1.5
!     Backward recurrence in Miller algorithm.
s = 0.0
u2 = 0.0
u1 = eps
l = m
do i = 1, m
   al = l
   u3 = u2
   u2 = u1
   ai = ((al - 0.5)**2 - 1.0/9.0)/(al*(al + 1.0))
   bi = 2.0*(al + z)/(al + 1.0)
   u1 = (bi*u2 - u3)/ai
   s = s + u1
   l = l - 1
end do
!     Final assembly
k1 = c1*u1/(s*sqrt(z))
k2 = k1*(z + 1.0/6.0 - u2/u1)/z
if (ind /= 0) return
e = exp(-z)
k1 = k1*e
k2 = k2*e
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
10 if (x >= 0.0) go to 20
ai = (((((((((an9*x + an8)*x + an7)*x + an6)*x + an5)*x &
   & + an4)*x + an3)*x + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
20 if (x >= 1.0) go to 30
ai = (((((((bn7*x + bn6)*x + bn5)*x + bn4)*x + bn3)*x + bn2)*x &
   & + bn1)*x + bn0) / &
   & (((((bd5*x + bd4)*x + bd3)*x + bd2)*x + bd1)*x + bd0)
return
30 rtx = sqrt(x)
if (x > x0) go to 40
t = 16.0/(x*rtx)
w = ((((pn4*t + pn3)*t + pn2)*t + pn1)*t + pn0) / &
   & (((((pd5*t + pd4)*t + pd3)*t + pd2)*t + pd1)*t + pd0)
ai = (w/sqrt(rtx)) * exp(-2.0*x*rtx/3.0)
return
40 if (x > 4.0d0) go to 50
t = 16.0/(x*rtx)
w = (((((qn5*t + qn4)*t + qn3)*t + qn2)*t + qn1)*t + qn0) / &
   & (((((qd5*t + qd4)*t + qd3)*t + qd2)*t + qd1)*t + qd0)
ai = (w/sqrt(rtx)) * exp(-2.0*x*rtx/3.0)
return
50 if (x*rtx > 1.5*exparg(0)) go to 60
t = 16.0/(x*rtx)
w = ((((rn4*t + rn3)*t + rn2)*t + rn1)*t + rn0) / &
   & (((((rd5*t + rd4)*t + rd3)*t + rd2)*t + rd1)*t + rd0)
n = rtx
n2 = n*n
t = (x - n2)/(rtx + n)
ai = ((w/sqrt(rtx)) / c**(n2*n)) * exp(-2.0*t*(n*rtx + t*t/3.0))
return
60 ai = 0.0
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
!                   Scaled Airy function ai(x)
!             aie(x) = exp(ZETA)*ai(x)  WHEN x .GE. 0
!             aie(x) = ai(x)            WHEN x .LT. 0
!             zeta = (2/3) * x**(3/2)
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
10 if (x >= 0.0) go to 20
aie = (((((((((an9*x + an8)*x + an7)*x + an6)*x + an5)*x &
   & + an4)*x + an3)*x + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
20 if (x >= 1.0) go to 30
aie = (((((((bn7*x + bn6)*x + bn5)*x + bn4)*x + bn3)*x + bn2)*x &
   & + bn1)*x + bn0) / &
   & (((((bd5*x + bd4)*x + bd3)*x + bd2)*x + bd1)*x + bd0)
if (x > 1.e-20) aie = aie * exp(2.0*x*sqrt(x)/3.0)
return
30 rtx = sqrt(x)
if (x > x0) go to 40
t = 16.0/(x*rtx)
w = ((((pn4*t + pn3)*t + pn2)*t + pn1)*t + pn0) / &
   & (((((pd5*t + pd4)*t + pd3)*t + pd2)*t + pd1)*t + pd0)
aie = w/sqrt(rtx)
return
40 if (x > 4.0d0) go to 50
t = 16.0/(x*rtx)
w = (((((qn5*t + qn4)*t + qn3)*t + qn2)*t + qn1)*t + qn0) / &
   & (((((qd5*t + qd4)*t + qd3)*t + qd2)*t + qd1)*t + qd0)
aie = w/sqrt(rtx)
return
50 if (x > 1.e20) go to 60
t = 16.0/(x*rtx)
w = ((((rn4*t + rn3)*t + rn2)*t + rn1)*t + rn0) / &
   & (((((rd5*t + rd4)*t + rd3)*t + rd2)*t + rd1)*t + rd0)
aie = w/sqrt(rtx)
return
60 aie = rn0/sqrt(rtx)
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
!             Evaluation of the Airy function bi(x)
!     note... if x is a positive number where bi(x) is too large
!     to be computed, then bi(x) is set to 0.
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
10 if (x >= 0.0) go to 20
bi = ((((((((((an10*x + an9)*x + an8)*x + an7)*x &
   & + an6)*x + an5)*x + an4)*x + an3)*x &
   & + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
20 if (x > 1.0) go to 30
bi = ((((((((((bn10*x + bn9)*x + bn8)*x + bn7)*x &
   & + bn6)*x + bn5)*x + bn4)*x + bn3)*x &
   & + bn2)*x + bn1)*x + bn0) / &
   & (((bd3*x + bd2)*x + bd1)*x + bd0)
return
30 rtx = sqrt(x)
if (x > 2.0) go to 40
t = x - 1.0
w = ((((((pn6*t + pn5)*t + pn4)*t + pn3)*t + pn2)*t &
   & + pn1)*t + pn0) / &
   & (((((((pd7*t + pd6)*t + pd5)*t + pd4)*t + pd3)*t &
   & + pd2)*t + pd1)*t + pd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
40 if (x > 4.0) go to 50
t = x - 2.0
w = (((((((qn7*t + qn6)*t + qn5)*t + qn4)*t + qn3)*t &
   & + qn2)*t + qn1)*t + qn0) / &
   & ((((((((qd8*t + qd7)*t + qd6)*t + qd5)*t + qd4)*t &
   & + qd3)*t + qd2)*t + qd1)*t + qd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
50 if (x > x0) go to 60
t = 16.0/(x*rtx) - 1.0
w = (((((((((((rn11*t + rn10)*t + rn9)*t + rn8)*t &
   & + rn7)*t + rn6)*t + rn5)*t + rn4)*t + rn3)*t &
   & + rn2)*t + rn1)*t + rn0) / &
   & ((rd2*t + rd1)*t + rd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
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
70 bi = 0.0
end function bi

